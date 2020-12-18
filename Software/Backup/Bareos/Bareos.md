# Bareos

[TOC]

BAREOS（Backup Archiving REcovery Open  Sourced）是源于Bacula系统的开源免费备份/恢复系统。在2010年从Bacula分支，在此以后一直由德国的bareos.com/bareos.org提供开发和服务。

## 组件

**管理终端**

* bconsole：全功能CLI管理终端。
* WebUI：只能用于备份和恢复，同时包含基于Web的CLI界面。

**管理服务（Director Daemon）**
 运行在bareos管理机上，包含全部管理功能、CLI管理服务、WebUI后台支持、目录（catalog）数据库支持等。

**存储服务（Storage Daemon）**
 运行在bareos管理机上，支持不同的物理存储媒体（如硬盘存储系统、磁带存储系统等），管理数据的读取和存储。

**文件服务（File Daemon）**
 运行在客户机上，管理本地文件的备份和恢复。

**储存媒体**
 物理存储媒体（如硬盘存储系统、磁带存储系统等）。

| 服务器                                              | 客户机      |
| --------------------------------------------------- | ----------- |
| bconsole 、WebUI 、Director Daemon 、Storage Daemon | File Daemon |

## 准备操作系统

### CentOS 8



Bareos软件仓库的URL是：

> http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo

## 安装BareOS

- 配置防火墙策略（当然也可以关闭防火墙）

> firewall-cmd --permanent --add-port 9101-9103/tcp
>  firewall-cmd --permanent --add-service http
>  firewall-cmd --reload
>  firewall-cmd --list-all

安装BareOS及插件

> yum install -y bareos bareos-database-mysql
>  安装MySQL数据库（除了MySQL数据库外还可以使用PostgreSQL数据库，这里以MySQL试例）

配置MySQL源

> vim /etc/yum.repos.d/mysql56-community.repo

输入如下内容：

> [mysql56-community]
>  name=MySQL 5.6 Community Server
>  baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/
>  enabled=1
>  gpgcheck=1
>  gpgkey=http://repo.mysql.com/RPM-GPG-KEY-mysql

安装MySQL相关包

> yum install -y mysql-community-server mysql-community-devel mysql-community-client

启动并配置服务自启

> systemctl start mysqld
>  systemctl enable mysqld

初始化MySQL服务

> mysql_secure_installation

向导如下：
 注意：这一步可以不设置密码，如果设置密码之后需要些认证文件

> […]
>  Enter current password for root (enter for none):
>  […]
>  Set root password? [Y/n] y
>  New password: eisoo.com
>  Re-enter new password: eisoo.com
>  […]
>  Remove anonymous users? [Y/n] y
>  […]
>  Disallow root login remotely? [Y/n] n
>  […]
>  Remove test database and access to it? [Y/n] y
>  […]
>  Reload privilege tables now? [Y/n] y
>  […]

配置认证文件

> vim ~/.my.cnf

输入如下内容：

> [client]
>  host=localhost
>  user=root
>  password=‘eisoo.com’

注意：如果初始化MySQL的时候没有设置密码就要确保root用户可以不用密码 MySQL数据库；默认安装的MySQL数据库密码为空，所以可以直接访问，如下：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618163024403.png)

创建数据库：

> sh /usr/lib/bareos/scripts/create_bareos_database

提示如下则成功：

> Creating mysql database
>  Creating of bareos database succeeded.

创建数据库的表：

> sh /usr/lib/bareos/scripts/make_bareos_tables

提示如下则成功：

> Making mysql tables
>  Creation of Bareos MySQL tables succeeded.

> sh /usr/lib/bareos/scripts/grant_bareos_privileges

提示如下则成功：

> Granting mysql tables
>  Privileges for user bareos granted ON database bareos.

启动并配置BareOS服务自启：

> systemctl start bareos-dir # Director进程，逻辑控制
>  systemctl start bareos-sd # Storage Daemon
>  systemctl start bareos-fd # File Daemon
>  systemctl enable bareos-dir
>  systemctl enable bareos-sd
>  systemctl enable bareos-fd

Bareos使用的端口 9101-9103。
 使用如下命令访问Director：

> bconsole

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618163457207.png)
 输入help命令查看帮助：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618163512226.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 常用的命令有：

> *show filesets
>  *status dir
>  *status client
>  *status storage
>  *run命令开始执行备份任务

安装Bareos Webui
 Bareos-webui是Bareos的Web管理接口，比 bconsole 命令要简单直观。
 Bareos-webui依赖Apache和PHP；安装Apache和PHP：

> yum install -y bareos-webui

配置SELinux

> setsebool -P httpd_can_network_connect on

启动服务并设自启动

> systemctl start httpd
>  systemctl enable httpd

配置控制台密码

> [root@localhost ~]#bconsole
>  *conﬁgure add console name=admin password=admin proﬁle=webui-admin
>
> 如果提示为conﬁgure: is an invalid command.则命令无效
>  如果在控制台配置无效的话就手动配置

手动配置如下：

> cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf

注：请根据实际情况修改
 手动配置需要重启服务使配置生效：

> systemctl restart bareos-dir

这时候就可以访问web界面了

> http://192.168.0.30/bareos-webui/
>  账号admin
>  密码admin
>  测试Bareos Webui
>  使用浏览器访问：http://192.168.0.30/bareos-webui/

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618163947461.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 完成安装：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618164104841.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)

## 添加CentOS客户端

客户端防火墙配置

> firewall-cmd --permanent --add-port 9102/tcp
>  firewall-cmd --reload
>  firewall-cmd --list-all

安装客户端软件包

> 配置yum源
>
> curl http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo > /etc/yum.repos.d/bareos.repo

安装相关包

> yum install -y bareos-filedaemon

启动并配置自启服务

> systemctl start bareos-fd
>  systemctl enable bareos-fd

服务端：

> [root@localhost ~]#bconsole
>  Connecting to Director localhost:9101
>  1000 OK: bareos-dir Version: 16.2.4 (01 July 2016)
>  Enter a period to cancel a command.
>  *configure add client name=bareos-client-fd address=192.168.0.31 password=eisoo.com #这个ip是你客户端的ip
>  *reload
>  Reloaded

当然我们建立了客户端后会自动创建如下两个文件/etc/bareos/bareos-dir.d/client/ bareos-client-fd.conf内容为：

> Client {
>  Name = bareos-client-fd
>  Address = 192.168.0.31
>  Password = eisoo.com
>  }

/etc/bareos/bareos-dir-export/client/bareos-client-fd/bareos-fd.d/director/bareos-dir.conf
 内容如下：

> Director {
>  Name = bareos-dir
>  Password = “[md5]f4a43f6600da9afe39bd76f6fb1f435b”
>  }

注：手动配置请使用以下方法

> vim /etc/bareos/bareos-dir.d/client/bareos-client.conf

输入如下配置：

> Client {
>  Name = bareos-client-fd
>  Address = 192.168.0.31
>  Password = eisoo.com
>  }

重启服务使配置生效

> [root@localhost ~]#bconsole
>  Connecting to Director localhost:9101
>
> 1000 OK: bareos-dir Version: 16.2.4 (01 July 2016) Enter a period to
>  cancel a command.
>  *reload reloaded
>  *

复制导出目录配置到客户端

> scp  /etc/bareos/bareos-dir-export/client/你添加的客户端名/bareos-fd.d/director/bareos-dir.conf root@192.168.0.31:/etc/bareos/bareos-fd.d/director/
>  如：scp /etc/bareos/bareos-dir-export/client/win-fd/bareos-fd.d/director/bareos-dir.conf

修改客户端名字声明

> vim /etc/bareos/bareos-fd.d/client/myself.conf

修改如下名字与添加客户端名字一致

> Name = bareos-client-fd

修改客户端如何发消息

> cat /etc/bareos/bareos-fd.d/messages/Standard.conf

参数如下：

> Messages {
>  Name = Standard
>  Director = bareos-dir = all, !skipped, !restored
>  Description = “Send relevant messages to the Director.”
>  }

注：以上将消息发给Direcotr

重启客户端服务

> systemctl restart bareos-fd

测试客户端连接

> [root@localhost ~]#bconsole
>
> *show clients
>  *status client=bareos-client-fd

添加客户端作业
 添加作业资源

默认备份的目录为/usr/sbin/，如果你想备份别的目录需要去/etc/bareos/bareos-dir.d/fileset/SelfTest.conf配置文件中修改，修改完成后重启BareOS的三个服务

> *configure add job name=bareos-client-job-fd client=bareos-client-fd jobdefs=DefaultJob

信息显示如下：

> Created resource config file “/etc/bareos/bareos-dir.d/job/bareos-client-job.conf”:
>  Job {
>  Name = bareos-client-job-fd
>  Client = bareos-client-fd
>  JobDefs = DefaultJob
>  }

预演作业

> *estimate listing job=bareos-client-job-fd

注：以上只是预估备份的文件列表
 运行作业

> *run job=bareos-client-job-fd

注：这个时候会备份失败
 排除故障
 查阅故障

> *list joblog jobid=…

发现如下错误：

> 2017-08-31 14:40:46 bareos-dir JobId 15: Start Backup JobId 15,
>  Job=bareos-client-job-fd.2017-08-31_14.40.44_00 2017-08-31 14:40:46
>  bareos-dir JobId 15: Using Device “FileStorage” to write. 2017-08-31
>  14:40:56 bareos-client JobId 15: Warning: bsock_tcp.c:128 Could not
>  connect to Storage daemon on localhost:9103. ERR=Connection refused
>  Retrying … 2017-08-31 14:46:06 bareos-client JobId 15: Warning:
>  bsock_tcp.c:128 Could not connect to Storage daemon on localhost:9103.
>  ERR=Connection refused Retrying … 2017-08-31 14:51:16 bareos-client
>  JobId 15: Warning: bsock_tcp.c:128 Could not connect to Storage daemon
>  on localhost:9103. ERR=Connection refused Retrying … 2017-08-31
>  14:56:26 bareos-client JobId 15: Warning: bsock_tcp.c:128 Could not
>  connect to Storage daemon on localhost:9103. ERR=Connection refused
>  Retrying … 2017-08-31 15:01:36 bareos-client JobId 15: Warning:
>  bsock_tcp.c:128 Could not connect to Storage daemon on localhost:9103.
>  ERR=Connection refused Retrying … 2017-08-31 15:06:46 bareos-client
>  JobId 15: Warning: bsock_tcp.c:128 Could not connect to Storage daemon
>  on localhost:9103. ERR=Connection refused Retrying … 2017-08-31
>  15:10:46 bareos-client JobId 15: Fatal error: bsock_tcp.c:134 Unable
>  to connect to Storage daemon on localhost:9103. ERR=Connection refused
>  2017-08-31 15:10:46 bareos-client JobId 15: Fatal error: Failed to
>  connect to Storage daemon: localhost:9103 2017-08-31 15:10:46
>  bareos-dir JobId 15: Fatal error: Bad response to Storage command:
>  wanted 2000 OK storage , got 2902 Bad storage
>
> 2017-08-31 15:10:46 bareos-dir JobId 15: Error: Bareos bareos-dir
>  16.2.4 (01Jul16): Build OS: x86_64-redhat-linux-gnu redhat CentOS Linux release 7.0.1406 (Core) JobId:
>  15 Job:
>  bareos-client-job-fd.2020-02-25_14.40.44_00 Backup Level:
>  Full Client: “bareos-client” 16.2.4 (01Jul16)
>  x86_64-redhat-linux-gnu,redhat,CentOS Linux release 7.0.1406 (Core)
>  ,CentOS_7,x86_64 FileSet: “SelfTest” 2017-08-29
>  05:01:45 Pool: “Full” (From command line)
>  Catalog: “MyCatalog” (From Client resource) Storage:
>  “File” (From Job resource) Scheduled time: 31-Aug-2017
>  14:40:43 Start time: 31-Aug-2017 14:40:46 End time:
>  31-Aug-2017 15:10:46 Elapsed time: 30 mins Priority:
>  10 FD Files Written: 0 SD Files Written: 0 FD Bytes
>  Written: 0 (0 B) SD Bytes Written: 0 (0 B) Rate:
>  0.0 KB/s Software Compression: None VSS: no Encryption: no Accurate: no Volume
>  name(s): Volume Session Id: 3 Volume Session Time:
>  1504157857 Last Volume Bytes: 0 (0 B) Non-fatal FD errors:
>  2 SD Errors: 0 FD termination status: Fatal Error
>  SD termination status: Waiting on FD Termination: ***
>  Backup Error ***

更正存储配置文件
 修改以下配置文件：

> vim /etc/bareos/bareos-dir.d/storage/File.conf

修改如下参数：

> Address = 192.168.0.30 #注意：这个ip是服务端dir的ip

重启服务使配置生效

> systemctl restart bareos-dir bareos-fd bareos-sd

测试配置文件
 方法运行适当的守护进程，可以测试配置文件在语法上是否正确。-t选择。守护进程将处理配置文件并打印任何错误消息，然后终止。
 当Bareos Director和Bareos存储守护进程以用户身份运行时赤裸，测试配置应按照赤裸.
 这对于测试BareosDirector尤其必要，因为它还连接到数据库，并检查目录模式版本是否正确。取决于数据库，只有赤裸有权访问它。
 重新运行作业

> *run job=bareos-client-job-fd

等待作业完成

> *wait jobid=…

验证作业

> *list joblog jobid=…
>  *list files jobid=…
>  *list volumes

备份完成后登陆web端
 会在首页看到你的任务success为成功的。Failure为失败的
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618165546188.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 然后点击clients
 如果你的客户端添加成功这里会显示客户端的系统，以及版本，状态等信息
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618165611808.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 点击restore-client下拉选择你的客户端
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618165626597.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 在backup jobs这会自动选择你备份过的文件目录，如果你有多个备份可以下拉选择你想恢复的备份。
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/2020061816563875.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 往下滑动Restore location on client这里输入一个位置，指定你的文件恢复到哪个位置。然后点击restore
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618165649696.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 然后点击ok，然后去客户端切到你指定的目录去查看是否完成恢复

# 增客Windows客户机

> 这里是引用[root@localhost ~]# bconsole
>  *configure add client name=win-fd address=192.168.0.35 password=eisoo.com #客户端的ip
>  Exported resource file “/etc/bareos/bareos-dir-export/client/win-fd/bareos-fd.d/director/bareos-dir.conf”:
>  Director {
>  Name = bareos-dir
>  Password = “[md5]f4a43f6600da9afe39bd76f6fb1f435b” #注意这个密码一会要用到
>  }
>  Created resource config file “/etc/bareos/bareos-dir.d/client/win-fd.conf”:
>  Client {
>  Name = win-fd
>  Address = 192.168.0.35
>  Password = eisoo.com
>  }
>  *q
>  [root@localhost ~]# cat /etc/bareos/bareos-dir.d/console/bareos-mon.conf
>  Console {
>  Name = bareos-mon
>  Description = “Restricted console used by tray-monitor to get the status of the director.”
>  Password = “y15fQiwuwqU/mCtCmUwAE2eln2DOf4PNIBrEhhItOfPV” #这个密码也要用到
>  CommandACL = status, .status
>  JobACL = *all*
>  }
>  [root@localhost ~]#

在Windows客户机上安装bareos-fd软件包
 下载地址：

> http://download.bareos.org/bareos/release/latest/windows/opsi/

安装Bareos File Daemon

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618170731457.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618170740179.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618170753903.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618170803248.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 这时候就需要用到两个密码了
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200618170840156.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1ODk2MjUz,size_16,color_FFFFFF,t_70)
 Client name：这里填你在服务端添加客户端时设置的名字，一定要保持一致
 Director name 保持默认就行
 Password 这里填你在服务端添加客户端时给出的md5的密码，连带[md5]一同复制过来
 Network address 保持默认就行
 Client monitor password 这里填写/etc/bareos/bareos-dir.d/console/bareos-mon.conf文件中的密码

到此为止Bareos的Director，Storage和Client都已经配置完成，可以使用了。

> [root@localhost ~]#bconsole
>  *Connecting to Director  localhost:9101 Encryption: PSK-AES256-CBC-SHA 1000 OK: bareos-dir  Version: 19.2.6 (11 February 2020) bareos.org
>  build binary bareos.org binaries are UNSUPPORTED by bareos.com. Get
>  official binaries and vendor support on https://www.bareos.com You are
>  connected using the default console
>  Enter a period (.) to cancel a command.
>  *reload reloaded
>  *status client=win-fd Connecting to Client win-fd at 192.168.0.35:9102  Probing client protocol… (result will be saved until config reload)
>  Handshake: Immediate TLS, Encryption: PSK-AES256-CBC-SHA
>  win-fd Version: 20.0.0~pre255.bddd6c0b8 (18 February 2020) VSS Linux
>  Cross-compile Win64 Daemon started 27-Feb-20 16:01. Jobs: run=0
>  running=0, pre-release version binary Microsoft Windows 7 Ultimate
>  Edition Service Pack 1 (build 7601), 64-bit Sizeof: boffset_t=8
>  size_t=8 debug=0 trace=1 bwlimit=0kB/s
>
> Running Jobs: win-mon (director) connected at: 27-Feb-20 16:03
>  bareos-dir (director) connected at: 27-Feb-20 16:03
>
> No Jobs running.
>
> ====
>  Terminated Jobs:
>  *show client
>  Client {
>  Name = “win-fd”
>  Address = “192.168.0.35”
>  Password = “[md5]f4a43f6600da9afe39bd76f6fb1f435b”
>  Catalog = “MyCatalog”
>  }
>  Client {
>  Name = “bareos-fd”
>  Description = “Client resource of the Director itself.”
>  Address = “localhost”
>  Password = “[md5]7a0b5f3a138070aae8badd647030ca4c”
>  Catalog = “MyCatalog”
>  }

默认备份的目录为空，如果你想备份目录需要去/etc/bareos/bareos-dir.d/fileset/ Windows All Drives.conf配置文件中修改，修改完成后重启BareOS的三个服务

> [root@localhost ~]#vim /etc/bareos/bareos-dir.d/fileset/Windows All
>  Drives.conf

备份Windows电脑

> FileSet { Name = “Windows电脑备份[A-Z]:/QMDownload” Enable VSS = yes
>
> # 当YES时，当文件正在被写时也能被备份；如NO，被写文件不会被备份 Include {
>
> ```
> Options {
>   Signature = MD5
>   Drive Type = fixed                            # 只备份固定磁盘
>   IgnoreCase = yes                              # 忽略字母的大小写
>   WildFile = "[A-Z]:/pagefile.sys"              # 指定文件：从磁盘A到Z下的/pagefile.sys
>   WildDir = "[A-Z]:/RECYCLER"                   # 指定文件：从磁盘A到Z下的
>   WildDir = "[A-Z]:/$RECYCLE.BIN"               # 指定文件：从磁盘A到Z下的
>   WildDir = "[A-Z]:/System Volume Information"  # 指定文件：从磁盘A到Z下的
>   Exclude = yes                                 # 另一种方式指定不备份上述指定文件
> }
> File ="C: / QMDownload "                    # 备份目录C:/QMDownload   } }
> 1234567891011
> ```

如您需要备份不同的文件，只需要修改 File =C: /QMDownload 即可。
 如：

> File = D:/Data # 备份D:/Data目录

用户可根据不同的需求来定义不同的fileset。

> [root@localhost ~]#bconsole
>  *run Automatically selected Catalog: MyCatalog Using Catalog “MyCatalog” A job name must be specified. The defined Job resources
>  are:
>  1: backup-bareos-fd #选项调用的是/etc/bareos/bareos-dir.d/job/backup-bareos-fd.conf
>  2: BackupCatalog #选项调用的是/etc/bareos/bareos-dir.d/job/BackupCatalog.conf
>  3: RestoreFiles #选项调用的是/etc/bareos/bareos-dir.d/job/RestoreFiles.conf
>  Select Job resource (1-3): 1 Run Backup job JobName: backup-bareos-fd
>  Level: Incremental Client: bareos-fd Format: Native FileSet:
>  SelfTest Pool: Incremental (From Job IncPool override) Storage:
>  File (From Job resource) When: 2020-02-27 03:07:05 Priority: 10 OK
>  to run? (yes/mod/no): mod Parameters to modify:
>  1: Level #级别
>  2: Storage #（存储）选项调用/etc/bareos/bareos-dir.d/storage/File.conf
>  3: Job #（工作）选项调用/etc/bareos/bareos-dir.d/job/*.conf
>  4: FileSet #（文件集）选项调用/etc/bareos/bareos-dir.d/fileset/*.conf
>  5: Client #（客户）选项调用/etc/bareos/bareos-dir.d/client/*.conf
>  6: Backup Format #备份格式
>  7: When #什么时候（可以定时备份）
>  8: Priority #优先
>  9: Pool #（池）选项调用/etc/bareos/bareos-dir.d/pool/*.conf
>  10: Plugin Options #插件选项 Select parameter to modify (1-10): 1 Levels:
>  1: Full #完整
>  2: Incremental #递增
>  3: Differential #差异
>  4: Since #以来
>  5: VirtualFull #虚拟全 Select level (1-5): 1 Run Backup job JobName: backup-bareos-fd Level: Full Client: bareos-fd Format:
>  Native FileSet: SelfTest Pool: Full (From Job FullPool override)
>  Storage: File (From Job resource) When: 2020-02-27 03:07:05
>  Priority: 10 OK to run? (yes/mod/no): mod Parameters to modify:
>  1: Level #级别
>  2: Storage #（存储）选项调用/etc/bareos/bareos-dir.d/storage/File.conf
>  3: Job #（工作）选项调用/etc/bareos/bareos-dir.d/job/*.conf
>  4: FileSet #（文件集）选项调用/etc/bareos/bareos-dir.d/fileset/*.conf
>  5: Client #（客户）选项调用/etc/bareos/bareos-dir.d/client/*.conf
>  6: Backup Format #备份格式
>  7: When #什么时候（可以定时备份）
>  8: Priority #优先
>  9: Pool #（池）选项调用/etc/bareos/bareos-dir.d/pool/*.conf
>  10: Plugin Options #插件选项 Select parameter to modify (1-10): 5 The defined Client resources are:
>  1: bareos-fd
>  2: win-fd #这个是win客户端的调用的是/etc/bareos/bareos-dir.d/client/win-fd.conf
>  Select Client (File daemon) resource (1-2): 2 Run Backup job JobName:
>  backup-bareos-fd Level: Full Client: win-fd Format: Native
>  FileSet: SelfTest Pool: Full (From Job FullPool override)
>  Storage: File (From Job resource) When: 2020-02-27 03:07:05
>  Priority: 10 OK to run? (yes/mod/no): mod Parameters to modify:
>  1: Level #级别
>  2: Storage #（存储）选项调用/etc/bareos/bareos-dir.d/storage/File.conf
>  3: Job #（工作）选项调用/etc/bareos/bareos-dir.d/job/*.conf
>  4: FileSet （文件集）选项调用/etc/bareos/bareos-dir.d/fileset/*.conf
>  5: Client ##（客户）选项调用/etc/bareos/bareos-dir.d/client/*.conf
>  6: Backup Format #备份格式
>  7: When #什么时候（可以定时备份）
>  8: Priority #优先
>  9: Pool #（池）选项调用/etc/bareos/bareos-dir.d/pool/*.conf
>  10: Plugin Options #插件选项 Select parameter to modify (1-10): 4 The defined FileSet resources are:
>  1: Catalog #（目录）调用/etc/bareos/bareos-dir.d/fileset/Catalog.conf
>  2: LinuxAll #全部Linux 调用/etc/bareos/bareos-dir.d/fileset/LinuxAll.conf
>  3: SelfTest #（测试）调用/etc/bareos/bareos-dir.d/fileset/SelfTest.conf
>  4: Windows All Drives #（所有Windows驱动）调用/bareos-dir.d/fileset/*.conf Select FileSet
>  resource (1-4): 4 Run Backup job JobName: backup-bareos-fd Level:
>  Full Client: win-fd Format: Native FileSet: Windows All Drives
>  Pool: Full (From Job FullPool override) Storage: File (From Job
>  resource) When: 2020-02-27 03:07:05 Priority: 10 OK to run?
>  (yes/mod/no): yes Job queued. JobId=1
>
> - You have new mail in /var/spool/mail/root [root@localhost ~]#

可以去web界面查看备份的状态了

## 添加Unbantu客户端

软件仓库的URL是：

> http://download.bareos.org/bareos/release/latest/Debian_9.0

建立/etc/apt/sources.list.d/bareos.list文件，文件内容为：

> deb http://download.bareos.org/bareos/release/latest/Debian_9.0 /

添加bareos软件仓库的apt键值

> root@bareos:~# wget -q
>  http://download.bareos.org/bareos/release/latest/Debian_9.0/Release.key
>  -O- | apt-key add -

更新APT源列表

> root@bareos:~# apt update apt-get install bareos-filedaemon

备份文件组（fileset）配置文件

> /etc/bareos/bareos-dir.d/fileset/*.conf

该目录下有一系列配置文件，这些文件用于定义如何备份一组文件（fileset）。
 这是最重要的配置之一，而又只能通过终端手工配置，所以我们在此将详细介绍。

备份Linux电脑

> FileSet { # fileset 开始标志
>  Name = “LinuxAll” # 该 fileset
>  的名字，这个名字会在备份任务中使用 Description = “备份所有系统，除了不需要备份的。” Include {
>
> # 备份中需要包含的文件
>
> ```
> Options {                                 # 选项
>   Signature = MD5                         # 每个文件产生MD5校验文件
>   One FS = No                             # 所有指定的文件（含子目录）都会被备份
>   # One FS = Yes                          # 指定的文件（含子目录）如不在同一文件系统下不会被备份
>   #
>   # 需要备份的文件系统类型列表
>   FS Type = btrfs                         # btrfs 文件系统需要备份
>   FS Type = ext2                          # ext2 文件系统需要备份 
>   FS Type = ext3                          # ext3 文件系统需要备份
>   FS Type = ext4                          # ext4 文件系统需要备份
>   FS Type = reiserfs                      # reiserfs 文件系统需要备份
>   FS Type = jfs                           # jfs 文件系统需要备份
>   FS Type = xfs                           # xfs 文件系统需要备份
>   FS Type = zfs                           # zfs 文件系统需要备份
> }
> File = /                                  # 所有目录和文件   }   # 定义不需要备份的文件和目录   Exclude {                                   #
> 12345678910111213141516
> ```
>
> 备份中不应该包含的文件
>  \# 无需备份文件/目录列表
>  File = /var/lib/bareos # /var/lib/bareos 下放的是bareos的临时文件
>  File = /var/lib/bareos/storage # /var/lib/bareos/storage 下放的是备份文件
>  File = /proc # /proc 无需备份
>  File = /tmp # /tmp无需备份
>  File = /var/tmp # /var/tmp无需备份
>  File = /.journal # /.journal 无需备份
>  File = /.fsck # /.fsck无需备份 } }

一般情况下，您只需要修改该文件来达到不同的备份需求。如子备份/home目录：

> …
>  FS Type = xfs # xfs 文件系统需要备份
>  FS Type = zfs # zfs 文件系统需要备份
>  }
>  File = /home # /home下的所有目录和文件 } # 定义不需要备份的文件和目录 Exclude { #
>  备份中不应该包含的文件
>  \# 无需备份文件/目录列表
>  File = /var/lib/bareos # /var/lib/bareos 下放的是bareos的临时文件 …

下面我们定义一个用于测试任务的fileset（TestSet）

> FileSet { # fileset 开始标志
>
> ```
>   Name = "TestSet"                            # 该 fileset 的名字，这个名字会在备份任务中使用
>   Description = "备份/usr/sbin（用于测试任务）"
>   Include {                                   # 备份中需要包含的文件 
>     Options {                                 # 选项
>       Signature = MD5                         # 每个文件产生MD5校验文件
>       One FS = No                             # 所有指定的文件（含子目录）都会被备份
>       # One FS = Yes                          # 指定的文件（含子目录）如不在同一文件系统下不会被备份
>       #
>       # 需要备份的文件系统类型列表
>       FS Type = btrfs                         # btrfs 文件系统需要备份
>       FS Type = ext2                          # ext2 文件系统需要备份 
>       FS Type = ext3                          # ext3 文件系统需要备份
>       FS Type = ext4                          # ext4 文件系统需要备份
>       FS Type = reiserfs                      # reiserfs 文件系统需要备份
>       FS Type = jfs                           # jfs 文件系统需要备份
>       FS Type = xfs                           # xfs 文件系统需要备份
>       FS Type = zfs                           # zfs 文件系统需要备份
>     }
>     File = /"/usr/sbin"                       # 所有目录和文件
>   }
> }
> 123456789101112131415161718192021
> ```

因为没有不需要备份的文件，所以我们移除了Exclude。

备份任务定义（jobdefs）配置文件

> /etc/bareos/bareos-dir.d/jobdefs/*.conf

实例：测试任务（TestJob）

> JobDefs { Name = “TestJob”
>
> # 测试任务 Type = Backup # 类型：备份（Backup） Level = Incremental
>
> # 方式：递进（Incremental） Client = bareos-fd # 被备份客户端：bareos-fd （在Client中定义） FileSet = “TestSet” # 备份文件组：TesetSet （在FileSet中定义） Schedule = “WeeklyCycle” #  备份周期：WeeklyCy（在schedule中定义） Storage = File # 备份媒体： File（在Storage中定义）  Messages = Standard # 消息方式：Standard（在Message中定义） Pool = Incremental #  存储池：Incremental（在pool中定义） Priority = 10 # 优先级：10 Write Bootstrap =  “/var/lib/bareos/%c.bsr” # Full Backup Pool = Full # Full备份，使用 “Full”
>
> 池（在storage中定义） Differential Backup Pool = Differential #
>  Differential备份，使用 “Differential” 池（在storage中定义） Incremental Backup
>  Pool = Incremental # Incremental备份，使用 “Incremental” 池（在storage中定义）
>  }

任务（job）配置文件

> /etc/bareos/bareos-dir.d/job/*.conf

配置备份任务：实例：在客户端bareos-fa上运行TestJob（备份/usr/sbin下的所有文件）

> Job { Name = “backup-test-on-bareos-fd” # 任务名 JobDefs
>  = “TestJob” # 使用已定义的备份任务TestJob （在jobdefs中定义） Client = “bareos-fd” #
>  客户端名称： bareos-fd（在client中定义） } 存储媒体（storage）配置文件
>  /etc/bareos/bareos-dir.d/storage/*.conf
>
> Storage { Name = File Address = bareos #
>  director-sd名字，使用FQDN (不要使用 “localhost” ). Password =
>  “JgwtSYloo93DlXnt/cjUfPJIAD9zocr920FEXEV0Pn+S” Device = FileStorage
>  \#在bareos-sd中定义 Media Type = File }

注意：Device是在Bareos的Storage Daemon中定义的，Device的名字和Media Type必须一致。

这是在安装时自动生成的存储媒体配置文件，如使用本地硬盘文件系统做存储媒体，不需要做任何修改。

存储池（pool）配置文件

> /etc/bareos/bareos-dir.d/pool/*.conf

一般情况下，我们需要四个存储池。分别是：

> Full：用于完整备份【Full：备份所有文件】 Incremental：用于递增备份【Incremental：备份所有状态变化的文件】
>  Differential：用于差异备份【Differential：备份所有修改了（modified标志变化）的文件】
>  Scratch：当系统找不到需要的Volume时，自动使用该存储池。 Scratch名称不可修改，其他存储池名字可修改。

下面是系统安装时生成的pool定义文件，一般情况下无需修改。

> Differential.conf
>
> Pool { Name = Differential Pool Type = Backup Recycle = yes
>  Bareos 自动回收重复使用 Volumes（Volume备份文件标记） AutoPrune = yes # 自动清除过期的Volumes Volume Retention = 90 days # Volume有效时间 Maximum Volume
>  Bytes = 10G # Volume最大尺寸 Maximum Volumes = > 100 # 单个存储池允许的Volume数量
>  Label Format = “Differential-” > # Volumes 将被标记为
>  “Differential-” } Full.conf > > > Pool { Name = Full Pool
>  Type = Backup Recycle = yes > > > Bareos 自动回收重复使用
>  Volumes（Volume备份文件标记） AutoPrune = yes # 自动清除过期的Volumes Volume
>  Retention = 365 days # Volume有效时间 Maximum Volume Bytes = 50G #
>  Volume最大尺寸 Maximum Volumes = > 100 # 单个存储池允许的Volume数量 Label Format =
>  “Full-” > > > # > Volumes 将被标记为 “Differential-” }
>  Incremental.conf > > > > Pool { Name = Incremental Pool Type = Backup
>  Recycle = yes > # Bareos 自动回收重复使用 Volumes（Volume备份文件标记） AutoPrune =
>  yes # 自动清除过期的Volumes Volume Retention = 30 days # Volume有效时间 Maximum
>  Volume Bytes = 1G # Volume最大尺寸 Maximum Volumes = > 100 #
>  单个存储池允许的Volume数量 Label Format = “Incremental-” > # Volumes 将被标记为
>  “Differential-” } Scratch.conf
>
> Pool { Name = Scratch Pool Type = Scratch }

修改bareos-dir的配置后，必须重启Director。在重启Director前，请首先使用bareos-dir -t  -v检查bareos-dir配置文件。如bareos-dir -t -v没有任何输出，说明配置文件没有任何语法问题，可以重启Director。

计划（schedule）配置文件

> /etc/bareos/bareos-dir.d/schedule/*.conf

实例：
 一、每月第一个周六晚9点做完整备份；
 二、其余周六晚9点做差异备份；
 三、周一至周五晚九点做递增备份。

> Schedule { Name = “WeeklyCycle” Run = Full 1st sat at 21:00
>  每月第一个周六/晚九点，完整备份 Run = Differential 2nd-5th sat at 21:00 # 其余周六/晚九点，差异备份 Run = Incremental mon-fri at 21:00 #
>  周一至周五，递增备份 }

提示信息（message）配置文件

> /etc/bareos/bareos-dir.d/message/*.conf

用于配置任务（job）完成后如何发送提示信息
 示例：

## 

> Messages { Name = Standard Description = “Reasonable message delivery
>  – send most everything to email address and to the console.” # operatorcommand = “/usr/bin/bsmtp -h localhost -f “(Bareos)
>  <%r>” -s “Bareos: Intervention needed for %j” %r” # mailcommand =
>  “/usr/bin/bsmtp -h localhost -f “(Bareos) <%r>” -s “Bareos: %t
>  %e of %c %l” %r” operator = root@localhost = mount #
>  执行operatorcommand命令，用户：root@localhost，操作：mount mail = root@localhost =
>  all, !skipped, !saved, !audit #
>  执行mailcommand，用户：root@localhost，操作：所有（除skipped，saved和audit） console =
>  all, !skipped, !saved, !audit # 所有操作，除skipped，saved和audit append =
>  “/var/log/bareos/bareos.log” = all, !skipped, !saved, !audit #
>  所有操作，除skipped，saved和audit catalog = all, !skipped, !saved, !audit #
>  所有操作，除skipped，saved和audit # 可用参数 # %% = % # %c = Client’s name # %d =
>  Director’s name # %e = Job Exit code (OK, Error, …) # %h = Client
>  address # %i = Job Id # %j = Unique Job name # %l = Job level # %n =
>  Job name # %r = Recipients # %s = Since time # %t = Job type (e.g.
>  Backup, …) # %v = Read Volume name (Only on director side) # %V =
>  Write Volume name (Only on director side) # console：定义发送到console的信息 #
>  append：定义发送到日志文件的信息 # catalog：定义发送到数据库的信息 }

bsmtp只适用于有本地SMTP服务器，一般情况并不适用。我们将另文介绍如何使用外部SMTP邮件服务器发送bareos的信息邮件。

Bareos的Director已配置完成，在开始备份任务前，我们还需要配置客户端（File Daemon）。

配置Bareos客户端（File Daemon）模块
 Bareos客户端（File Daemon）模块的配置文件位于/etc/bareos/bareos-dir.d目录下。

## 准备操作系统

***安装Ubuntu 18.04 LTS\*** 
 我们使用的操作系统是headless的Ubuntu 18.04 LTS服务器系统，只安装了最基本系统和SSH。 
 系统安装完成后，将系统更新。

***安装MariaDB\*** 
  在安装Bareos时，如系统未安装数据库软件，数据库软件将会按选择的数据库类型被自动安装。我们选用的数据库类型是mysql，而Ubuntu  18.04的默认数据库MySQL。为了使用MariaDB作为SQL数据库，我们必须先安装MariaDB数据库软件。 
 `apt install mariadb-server mariadb-client`

------

## 安装Bareos和Bareos-WebUI

我们使用的是Bareos的软件仓库中的版本。

软件仓库的URL是： [http://download.bareos.org/bareos/release/latest/Debian_9.0](https://blog.csdn.net/laotou1963/article/details/download.bareos.org/bareos/release/latest/Debian_9.0) 
 Ubuntu 18.04是基于Debian9，我们选用的版本是bareos.org的最新版本。

***建立/etc/apt/sources.list.d/bareos.list文件，文件内容为：\***

```
deb http://download.bareos.org/bareos/release/latest/Debian_9.0 /1
```

***添加bareos软件仓库的apt键值\***

```
root@bareos:~# wget -q http://download.bareos.org/bareos/release/latest/Debian_9.0/Release.key -O- | apt-key add -1
```

***更新APT源列表\***

```
root@bareos:~# apt update1
```

***安装Bareos和Bareos-WebUI\***

```
root@bareos:~# apt-get install bareos bareos-database-mysql bareos-webui1
```

在安装过程中，会弹出下列对话框 
 ![这里写图片描述](https://img-blog.csdn.net/20180911102500161?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 
 出现左边的对话框时，选择【Yes】；出现右边的对话框时，选择【MySQL】，因为我们使用的是MariaDB。 
 在配置MariaDB时，根据弹出的对话框配置即可。

`bareos` - bareos备份/恢复软件安装包 
 `bareos-webui` - bareos备份/恢复Web界面安装包 
 `bareos-database-mysql` - bareos备份/恢复MySQL数据库初始化数据安装包

所有未安装的依赖软件包都会被自动安装。安装完成后，需重启apache2服务（`service apache2 restart`）。

***检查安装是否成功\*** 
 在安装和重启apache2过程中，如没有出错信息，我们可以连接到bareos的web界面，检查安装是否成功。 
 http://bareos.lswin.cn/bareos-webui （bareos.lswin.cn是我们新建的bareos服务器地址） 
 ![这里写图片描述](https://img-blog.csdn.net/20180911104113572?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 
 这是成功安装后应该出现的Bareos的Web界面。

重启系统，然后检查bareos-dir、bareos-fd和bareos-sd是否自动启动。

```
root@bareos:~# service bareos-dir status
● bareos-director.service - Bareos Director Daemon service
   Loaded: loaded (/lib/systemd/system/bareos-director.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-09-11 10:46:30 CST; 12s ago
     Docs: man:bareos-dir(8)
  Process: 1350 ExecStart=/usr/sbin/bareos-dir (code=exited, status=0/SUCCESS)
  Process: 1324 ExecStartPre=/usr/sbin/bareos-dir -t -f (code=exited, status=0/SUCCESS)
 Main PID: 1351 (bareos-dir)
    Tasks: 5 (limit: 1082)
   CGroup: /system.slice/bareos-director.service
           └─1351 /usr/sbin/bareos-dir

Sep 11 10:46:30 bareos systemd[1]: Starting Bareos Director Daemon service...
Sep 11 10:46:30 bareos systemd[1]: bareos-director.service: Can't open PID file /var/lib/bareos/bareos-dir.9101.pid (yet?) after start: No such f
Sep 11 10:46:30 bareos systemd[1]: Started Bareos Director Daemon service.
12345678910111213141516
root@bareos:~# 
root@bareos:~# service bareos-fd status
● bareos-filedaemon.service - Bareos File Daemon service
   Loaded: loaded (/lib/systemd/system/bareos-filedaemon.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-09-11 10:46:29 CST; 1min 3s ago
     Docs: man:bareos-fd(8)
  Process: 974 ExecStart=/usr/sbin/bareos-fd (code=exited, status=0/SUCCESS)
 Main PID: 1048 (bareos-fd)
    Tasks: 3 (limit: 1082)
   CGroup: /system.slice/bareos-filedaemon.service
           └─1048 /usr/sbin/bareos-fd

Sep 11 10:46:29 bareos systemd[1]: Starting Bareos File Daemon service...
Sep 11 10:46:29 bareos systemd[1]: bareos-filedaemon.service: Can't open PID file /var/lib/bareos/bareos-fd.9102.pid (yet?) after start: No such 
Sep 11 10:46:29 bareos systemd[1]: Started Bareos File Daemon service.
12345678910111213141516
root@bareos:~# service bareos-sd status
● bareos-storage.service - Bareos Storage Daemon service
   Loaded: loaded (/lib/systemd/system/bareos-storage.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-09-11 10:46:29 CST; 1min 9s ago
     Docs: man:bareos-sd(8)
  Process: 973 ExecStart=/usr/sbin/bareos-sd (code=exited, status=0/SUCCESS)
 Main PID: 1081 (bareos-sd)
    Tasks: 3 (limit: 1082)
   CGroup: /system.slice/bareos-storage.service
           └─1081 /usr/sbin/bareos-sd

Sep 11 10:46:29 bareos systemd[1]: Starting Bareos Storage Daemon service...
Sep 11 10:46:29 bareos systemd[1]: bareos-storage.service: Can't open PID file /var/lib/bareos/bareos-sd.9103.pid (yet?) after start: No such fil
Sep 11 10:46:29 bareos systemd[1]: Started Bareos Storage Daemon service.
123456789101112131415
```

如这三个服务已启动，基本安装已完成。

***设置 Web界面管理员登陆账号\*** 
 使用Bareos的CLI界面（bconsole）设置Web界面管理员登陆账号。只有 root 用户能使用该界面，其他用户会返回错误。

```
lsadm@bareos:~$ bconsole
console: ERROR TERMINATION at parse_conf.c:198
Config error: Cannot open config file "/etc/bareos/bconsole.conf": Permission denied

lsadm@bareos:~$ 12345
```

添加Web界面的管理员账号

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*
*configure add console name=admin password=pwd111111 profile=webui-admin
Created resource config file "/etc/bareos/bareos-dir.d/console/admin.conf":
Console {
  Name = admin
  Password = pwd111111
  Profile = webui-admin
}
*
1234567891011121314
```

Web界面的管理员账号添加完成。下面是管理员登陆后的基本页面。 
 ![这里写图片描述](https://img-blog.csdn.net/20180911111219298?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

------

至此BAREOS备份/恢复系统已成功安装，下文我们将介绍如何使用bconsole设置Bareos备份/恢复系统。

# **备份/恢复系统BAREOS的设置**

本文将介绍如何设置bareos系统，将分别介绍Bareos系统主机设置（含Director Daemon、Storage Daemon和Storage Daemon）、客户机安装/设置和系统集成测试。

在介绍设置前，我们先简单介绍一下bareos系统架构，方便大家理解。

![img](https://img-blog.csdn.net/20180915104627543?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



------

## **Bareos系统设置**

#### **配置Bareos存储服务（Storage Daemon）模块**

Bareos存储服务（Storage）模块为bareos系统提供数据存储服务模块。它的配置文件位于/etc/bareos/bareos-sd.d目录下。

```
root@bareos:/etc/bareos/bareos-sd.d# ls -l
total 16
drwxr-x--- 2 bareos bareos 4096 Sep 16 11:37 device
drwxr-x--- 2 bareos bareos 4096 Sep 16 11:37 director
drwxr-x--- 2 bareos bareos 4096 Sep 16 11:44 messages
drwxr-x--- 2 bareos bareos 4096 Sep 16 11:43 storage
root@bareos:/etc/bareos/bareos-sd.d#
1234567
```

***配置Storage的存储设备***

device下放的是存储媒体配置文件，bareos系统是基于文件的备份/恢复系统，device下只有一个配置文件FileStorage.conf。

可能的FileStorage.conf如下：

```
# HDD 存储设备
Device {
  Name = FileStorage                  # 设备名称
  Media Type = File                   # 类型，bareos是基于文件的备份/恢复系统，类型永远是文件
  Archive Device = /bareos/hdd        # Ubuntu下的备份文件目录（或mount point）
  LabelMedia = yes;                   # lets Bareos label unlabeled media
  Random Access = yes;                # 可随机读写
  AutomaticMount = yes;               # 自动加载
  RemovableMedia = no;                # 媒体介质不可移除
  AlwaysOpen = yes;                   # 总是打开
}

# 磁带存储设备
Device {
  Name = TapeStorage                  # 设备名称
  Media Type = File                   # 类型，bareos是基于文件的备份/恢复系统，类型永远是文件
  Archive Device = /bareos/tape       # Ubuntu下的mount point
  LabelMedia = yes;                   # lets Bareos label unlabeled media
  Random Access = no;                 # 不能随机读写
  AutomaticMount = no;                # 不自动加载
  RemovableMedia = yes;               # 媒体介质可移除
  AlwaysOpen = no;                    # 按需打开
}
1234567891011121314151617181920212223
```

在上述配置文件中，我们配置了二种存储设备，分别是硬盘和磁带。在配置时，请注意被配置存储设备的物理属性。硬盘类的存储设备是可随机读写，磁带类的是不可随机读写。
 现在公司一般很少配磁带备份，我们的备份方案是：在/bareos/hdd下挂载SAN设备，然后通过rsync将/bareos/hdd目录下的内容同步到远程SAN上，从而保证数据的安全。

实例中的FileStorage.conf文件：

```
/etc/bareos/bareos-sd.d/device/FileStorage.conf
# HDD 存储设备
Device {
  Name = FileStorage                  # 设备名称
  Media Type = File                   # 类型，bareos是基于文件的备份/恢复系统，类型永远是文件
  Archive Device = /bareos/hdd        # Ubuntu下的mount point
  LabelMedia = yes;                   # lets Bareos label unlabeled media
  Random Access = yes;                # 可随机读写
  AutomaticMount = yes;               # 自动加载
  RemovableMedia = no;                # 媒体介质不可移除
  AlwaysOpen = yes;                   # 总是打开
}
1234567891011
```

***配置Storage的ACL***
 director下有二个配置文件`bareos-dir.conf`和`bareos-mon.conf`，分别用于管理director和monitor对storage模块的授权。

**`/etc/bareos/bareos-sd.d/director/bareos-dir.conf`**

```
Director {
  Name = bareos-dir                                             # 名字
  Password = "JgwtSYloo93DlXnt/cjUfPJIAD9zocr920FEXEV0Pn+S"     # 密码
  Description = "允许操作此storage的Director设置"
}

123456
```

**`/etc/bareos/bareos-sd.d/director/bareos-mon.conf`**

```
Director {
  Name = bareos-mon
  Password = "4wdzVcvZAFgTz+IWlB4C5hd09czTXhsAd8SnZQ1VZn4X"
  Monitor = yes 
  Description = "允许读取此storage状态的Monitor设置"
}
123456
```

monitor是bareos的GUI监视程序。

***配置 storage 相关信息服务***

```
/etc/bareos/bareos-sd.d/messages/Standard.conf
Messages {
  Name = Standard
  Director = bareos-dir = all # bareos-dir：发送信息到bareis-dir，all：所有信息
  # mailcommand =  # 可执行命令或脚本
  # operatorcommand = # 可执行命令或脚本
  Description = "Send all messages to the Director."
  # 可用参数
  # %% = %
  # %c = Client’s name
  # %d = Director’s name
  # %e = Job Exit code (OK, Error, ...)
  # %h = Client address
  # %i = Job Id
  # %j = Unique Job name
  # %l = Job level
  # %n = Job name
  # %r = Recipients
  # %s = Since time
  # %t = Job type (e.g. Backup, ...)
  # %v = Read Volume name (Only on director side)
  # %V = Write Volume name (Only on director side)
}
12345678910111213141516171819202122
```

***配置 storage 相关特性或功能***

```
Storage {
  Name = bareos-sd
  Maximum Concurrent Jobs = 20

  # remove comment from "Plugin Directory" to load plugins from specified directory.
  # if "Plugin Names" is defined, only the specified plugins will be loaded,
  # otherwise all storage plugins (*-sd.so) from the "Plugin Directory".
  #
  # Plugin Directory = /usr/lib/bareos/plugins
  # Plugin Names = ""
}

123456789101112
```

一般情况下，我们只需要修改FileStorage.conf配置文件中的`Archive Device`，默认的`Archive Device`是`/var/lib/bareos/storage`，默认的`bareos-sd`配置能满足一般需求。

修改`bareos-sd`的配置后，必须重启`bareos-sd`。在重启`bareos-sd`前，请首先使用`bareos-sd -t -v`检查`bareos-sd`配置文件。如`bareos-sd -t -v`没有任何输出，说明配置文件没有任何语法问题，可以重启`bareos-sd`。

------

#### **配置Bareos管理（Director）模块**

Bareos管理（Director）模块为bareos系统管理模块。它的配置文件位于/etc/bareos/bareos-dir.d目录下。

```
root@bareos:/etc/bareos/bareos-dir.d# ls -l
total 48
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 catalog 
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 client
drwxr-x--- 2 bareos bareos 4096 Sep 11 11:08 console
drwxr-x--- 2 bareos bareos 4096 Sep 15 20:42 director
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 fileset
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 job
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 jobdefs
drwxr-x--- 2 bareos bareos 4096 Sep 18 17:18 messages
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 pool
drwxr-x--- 2 bareos bareos 4096 Sep 15 20:45 profile
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 schedule
drwxr-x--- 2 bareos bareos 4096 Sep 11 09:13 storage
root@bareos:/etc/bareos/bareos-dir.d# 
123456789101112131415
```

配置文件的文件名可任意，但必须以`.conf`结尾。

***目录（catalog）数据库链接方式配置文件***
 `/etc/bareos/bareos-dir.d/MyCatalog.conf`

```
Catalog {
  Name = MyCatalog          # catalog名字
  dbdriver = mysql          # 使用MySQL驱动（兼容MariaDB）
  dbname = bareos           # 数据库名
  dbuser = bareos           # 该数据库之用户名
  dbpassword = bareos       # 该用户之密码
}

12345678
```

该文件在安装bareos-mysql时已被初始化，一般情况下无需修改。

***客户端（File Daemon）配置文件***
 `/etc/bareos/bareos-dir.d/client/clientname-fd.conf`

下面是bareos服务器的默认File Daemon配置文件：

```
Client {
  Name = bareos-fd                                                   # Director中使用的客户端名字
  Description = "Client resource of the Director itself."            # 解释
  Address = localhost                                                # 客户端FQDN或IP地址
  Password = "QGSqraVyf7kQfpdTxv+j/h27nesW7ypmGP5wLPLXltE9"          # 密码
}

1234567
```

配置客户端可以直接建立/修改配置文件，也可以通过bconsole来完成。

下面是使用bconsole建立客户端示例：
 root@bareos:~# bconsole
 Connecting to Director localhost:9101
 1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
 Enter a period to cancel a command.
 `*configure add client name=lscms-fd address=lscms.lswin.cn password=lscmsFdPasswd`

我们可以在/etc/bareos/bareos-dir.d/client下见到新的客户端配置文件`lscms-fd.conf`。内容为：

```
Client {
  Name = lscms-fd
  Address = lscms.lswin.cn
  Password = lscmsFdPasswd
}
12345
```

***终端（console）配置文件***
 在该目录（`/etc/bareos/bareos-dir.d/console`）下有二个配置文件：admin.conf 和 bareos-mon.conf
 `/etc/bareos/bareos-dir.d/console/admin.conf`：Web GUI 配置文件
 `/etc/bareos/bareos-dir.d/console/bareos-mon.conf`：Bareos 托盘监测配置文件

Web GUI 配置文件 `/etc/bareos/bareos-dir.d/console/admin.conf`：

```
Console {
  Name = admin
  Password = pwd111111
  Profile = webui-admin             # 指明是为WebGUI，该名字必须是webui-admin
}
12345
```

托盘监测配置文件`/etc/bareos/bareos-dir.d/console/bareos-mon.conf`

```
Console {
  Name = bareos-mon
  Description = "Restricted console used by tray-monitor to get the status of the director."
  Password = "8ipdQxiufhgskdNWk4ydvVWZfXGa9SmVBG690X+Mh9Ph"
  CommandACL = status, .status             # 只有 status 命令或 .status命令被授权
  JobACL = *all*                           # 所有任务都被授权
}
1234567
```

一般情况下，这些文件无需修改。

***控制端（Director）配置文件***
 `/etc/bareos/bareos-dir.d/director/bareos-dir.conf`

```
Director {                                                          # 配置控制端
  Name = bareos-dir
  QueryFile = "/usr/lib/bareos/scripts/query.sql"
  Maximum Concurrent Jobs = 10                                      # 同时可执行10个任务，更多任务需排队
  Password = "LiYwqsOHIEhfjPts14Pvenk9YMfmWEN81PxugpdOHt3C"         # 控制端 password
  Messages = Daemon                                                 # 只接受驻留任务消息
  Auditing = yes                                                    # 开启审计

  # Enable the Heartbeat if you experience connection losses
  # Heartbeat Interval = 1 min                                      # 如Director不在本地，可能需要开启    
}
1234567891011
```

一般情况，无需修改。

***备份文件组（fileset）配置文件***
 `/etc/bareos/bareos-dir.d/fileset/*.conf`

该目录下有一系列配置文件，这些文件用于定义如何备份一组文件（fileset）。
 这是最重要的配置之一，而又只能通过终端手工配置，所以我们在此将详细介绍。

一、备份Linux电脑

```
FileSet {                                     # fileset 开始标志                                
  Name = "LinuxAll"                           # 该 fileset 的名字，这个名字会在备份任务中使用
  Description = "备份所有系统，除了不需要备份的。"
  Include {                                   # 备份中需要包含的文件 
    Options {                                 # 选项
      Signature = MD5                         # 每个文件产生MD5校验文件
      One FS = No                             # 所有指定的文件（含子目录）都会被备份
      # One FS = Yes                          # 指定的文件（含子目录）如不在同一文件系统下不会被备份
      #
      # 需要备份的文件系统类型列表
      FS Type = btrfs                         # btrfs 文件系统需要备份
      FS Type = ext2                          # ext2 文件系统需要备份 
      FS Type = ext3                          # ext3 文件系统需要备份
      FS Type = ext4                          # ext4 文件系统需要备份
      FS Type = reiserfs                      # reiserfs 文件系统需要备份
      FS Type = jfs                           # jfs 文件系统需要备份
      FS Type = xfs                           # xfs 文件系统需要备份
      FS Type = zfs                           # zfs 文件系统需要备份
    }
    File = /                                  # 所有目录和文件
  }
  # 定义不需要备份的文件和目录
  Exclude {                                   # 备份中不应该包含的文件
    # 无需备份文件/目录列表
    File = /var/lib/bareos                    # /var/lib/bareos 下放的是bareos的临时文件
    File = /var/lib/bareos/storage            # /var/lib/bareos/storage 下放的是备份文件
    File = /proc                              # /proc 无需备份
    File = /tmp                               # /tmp无需备份
    File = /var/tmp                           # /var/tmp无需备份
    File = /.journal                          # /.journal 无需备份
    File = /.fsck                             # /.fsck无需备份
  }
}
123456789101112131415161718192021222324252627282930313233
```

一般情况下，您只需要修改该文件来达到不同的备份需求。如子备份`/home`目录：

```
......
      FS Type = xfs                           # xfs 文件系统需要备份
      FS Type = zfs                           # zfs 文件系统需要备份
    }
    File = /home                              # /home下的所有目录和文件
  }
  # 定义不需要备份的文件和目录
  Exclude {                                   # 备份中不应该包含的文件
    # 无需备份文件/目录列表
    File = /var/lib/bareos                    # /var/lib/bareos 下放的是bareos的临时文件
......
1234567891011
```

二、备份Windows电脑

```
FileSet {
  Name = "Windows电脑备份[A-Z]:/QMDownload"
  Enable VSS = yes                                  # 当YES时，当文件正在被写时也能被备份；如NO，被写文件不会被备份
  Include {
    Options {
      Signature = MD5
      Drive Type = fixed                            # 只备份固定磁盘
      IgnoreCase = yes                              # 忽略字母的大小写
      WildFile = "[A-Z]:/pagefile.sys"              # 指定文件：从磁盘A到Z下的/pagefile.sys
      WildDir = "[A-Z]:/RECYCLER"                   # 指定文件：从磁盘A到Z下的
      WildDir = "[A-Z]:/$RECYCLE.BIN"               # 指定文件：从磁盘A到Z下的
      WildDir = "[A-Z]:/System Volume Information"  # 指定文件：从磁盘A到Z下的
      Exclude = yes                                 # 另一种方式指定不备份上述指定文件
    }
    File ="C: / QMDownload "                    # 备份目录C:/QMDownload
  }
}
1234567891011121314151617
```

如您需要备份不同的文件，只需要修改 `File =C: /QMDownload` 即可。
 如：
 `File = D:/Data # 备份D:/Data目录`

用户可根据不同的需求来定义不同的fileset。

三、下面我们定义一个用于测试任务的fileset（`TestSet`）

```
    FileSet {                                     # fileset 开始标志                                
      Name = "TestSet"                            # 该 fileset 的名字，这个名字会在备份任务中使用
      Description = "备份/usr/sbin（用于测试任务）"
      Include {                                   # 备份中需要包含的文件 
        Options {                                 # 选项
          Signature = MD5                         # 每个文件产生MD5校验文件
          One FS = No                             # 所有指定的文件（含子目录）都会被备份
          # One FS = Yes                          # 指定的文件（含子目录）如不在同一文件系统下不会被备份
          #
          # 需要备份的文件系统类型列表
          FS Type = btrfs                         # btrfs 文件系统需要备份
          FS Type = ext2                          # ext2 文件系统需要备份 
          FS Type = ext3                          # ext3 文件系统需要备份
          FS Type = ext4                          # ext4 文件系统需要备份
          FS Type = reiserfs                      # reiserfs 文件系统需要备份
          FS Type = jfs                           # jfs 文件系统需要备份
          FS Type = xfs                           # xfs 文件系统需要备份
          FS Type = zfs                           # zfs 文件系统需要备份
        }
        File = /"/usr/sbin"                       # 所有目录和文件
      }
    }
12345678910111213141516171819202122
```

因为没有不需要备份的文件，所以我们移除了Exclude。

***备份任务定义（jobdefs）配置文件***
 `/etc/bareos/bareos-dir.d/jobdefs/*.conf`

实例：测试任务（TestJob）

```
JobDefs {
  Name = "TestJob"                                          # 测试任务
  Type = Backup                                             # 类型：备份（Backup）
  Level = Incremental                                       # 方式：递进（Incremental）
  Client = bareos-fd                                        # 被备份客户端：bareos-fd （在Client中定义）
  FileSet = "TestSet"                                       # 备份文件组：TesetSet （在FileSet中定义）
  Schedule = "WeeklyCycle"                                  # 备份周期：WeeklyCy（在schedule中定义）
  Storage = File                                            # 备份媒体： File（在Storage中定义）
  Messages = Standard                                       # 消息方式：Standard（在Message中定义）
  Pool = Incremental                                        # 存储池：Incremental（在pool中定义） 
  Priority = 10                                             # 优先级：10
  Write Bootstrap = "/var/lib/bareos/%c.bsr"                # 
  Full Backup Pool = Full                  # Full备份，使用 "Full" 池（在storage中定义）
  Differential Backup Pool = Differential  # Differential备份，使用 "Differential" 池（在storage中定义）
  Incremental Backup Pool = Incremental    # Incremental备份，使用 "Incremental" 池（在storage中定义）
}
12345678910111213141516
```

***任务（job）配置文件***
 `/etc/bareos/bareos-dir.d/job/*.conf`
 配置备份任务：实例：在客户端bareos-fa上运行TestJob（备份/usr/sbin下的所有文件）

```
Job {
  Name = "backup-test-on-bareos-fd"              # 任务名
  JobDefs = "TestJob"                            # 使用已定义的备份任务TestJob （在jobdefs中定义）
  Client = "bareos-fd"                           # 客户端名称： bareos-fd（在client中定义）
}
12345
```

***存储媒体（storage）配置文件***
 `/etc/bareos/bareos-dir.d/storage/*.conf`

```
Storage {
  Name = File
  Address = bareos                # director-sd名字，使用FQDN (不要使用 "localhost" ).
  Password = "JgwtSYloo93DlXnt/cjUfPJIAD9zocr920FEXEV0Pn+S"
  Device = FileStorage            # 在bareos-sd中定义
  Media Type = File
}
1234567
```

注意：Device是在Bareos的Storage Daemon中定义的，Device的名字和Media Type必须一致。

这是在安装时自动生成的存储媒体配置文件，如使用本地硬盘文件系统做存储媒体，不需要做任何修改。

***存储池（pool）配置文件***
 `/etc/bareos/bareos-dir.d/pool/*.conf`
 一般情况下，我们需要四个存储池。分别是：
 Full：用于完整备份【Full：备份所有文件】
 Incremental：用于递增备份【Incremental：备份所有状态变化的文件】
 Differential：用于差异备份【Differential：备份所有修改了（modified标志变化）的文件】
 Scratch：当系统找不到需要的Volume时，自动使用该存储池。
 Scratch名称不可修改，其他存储池名字可修改。
 下面是系统安装时生成的pool定义文件，一般情况下无需修改。

***Differential.conf***

```
Pool {
  Name = Differential
  Pool Type = Backup
  Recycle = yes                       # Bareos 自动回收重复使用 Volumes（Volume备份文件标记）
  AutoPrune = yes                     # 自动清除过期的Volumes
  Volume Retention = 90 days          # Volume有效时间
  Maximum Volume Bytes = 10G          # Volume最大尺寸
  Maximum Volumes = 100               # 单个存储池允许的Volume数量
  Label Format = "Differential-"      # Volumes 将被标记为 "Differential-<volume-id>"
}
12345678910
```

***Full.conf***

```
Pool {
  Name = Full
  Pool Type = Backup
  Recycle = yes                       # Bareos 自动回收重复使用 Volumes（Volume备份文件标记）
  AutoPrune = yes                     # 自动清除过期的Volumes
  Volume Retention = 365 days         # Volume有效时间
  Maximum Volume Bytes = 50G          # Volume最大尺寸
  Maximum Volumes = 100               # 单个存储池允许的Volume数量
  Label Format = "Full-"              # Volumes 将被标记为 "Differential-<volume-id>"
}
1234567891011
```

***Incremental.conf***

```
Pool {
  Name = Incremental
  Pool Type = Backup
  Recycle = yes                       # Bareos 自动回收重复使用 Volumes（Volume备份文件标记）
  AutoPrune = yes                     # 自动清除过期的Volumes
  Volume Retention = 30 days          # Volume有效时间
  Maximum Volume Bytes = 1G           # Volume最大尺寸
  Maximum Volumes = 100               # 单个存储池允许的Volume数量
  Label Format = "Incremental-"       # Volumes 将被标记为 "Differential-<volume-id>"
}
12345678910
```

***Scratch.conf***

```
Pool {
  Name = Scratch
  Pool Type = Scratch
}

12345
```

修改`bareos-dir`的配置后，必须重启Director。在重启Director前，请首先使用`bareos-dir -t -v`检查`bareos-dir`配置文件。如`bareos-dir -t -v`没有任何输出，说明配置文件没有任何语法问题，可以重启Director。

***计划（schedule）配置文件***
 `/etc/bareos/bareos-dir.d/schedule/*.conf`
 实例：
 一、每月第一个周六晚9点做完整备份；
 二、其余周六晚9点做差异备份；
 三、周一至周五晚九点做递增备份。

```
Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sat at 21:00                   # 每月第一个周六/晚九点，完整备份
  Run = Differential 2nd-5th sat at 21:00       # 其余周六/晚九点，差异备份
  Run = Incremental mon-fri at 21:00            # 周一至周五，递增备份
}
123456
```

***提示信息（message）配置文件***
 `/etc/bareos/bareos-dir.d/message/*.conf`
 用于配置任务（job）完成后如何发送提示信息
 示例：

```
Messages {
  Name = Standard
  Description = "Reasonable message delivery -- send most everything to email address and to the console."
  # operatorcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<%r\>\" -s \"Bareos: Intervention needed for %j\" %r"
  # mailcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<%r\>\" -s \"Bareos: %t %e of %c %l\" %r"
  operator = root@localhost = mount                                 # 执行operatorcommand命令，用户：root@localhost，操作：mount
  mail = root@localhost = all, !skipped, !saved, !audit             # 执行mailcommand，用户：root@localhost，操作：所有（除skipped，saved和audit）
  console = all, !skipped, !saved, !audit                           # 所有操作，除skipped，saved和audit
  append = "/var/log/bareos/bareos.log" = all, !skipped, !saved, !audit  # 所有操作，除skipped，saved和audit
  catalog = all, !skipped, !saved, !audit                           # 所有操作，除skipped，saved和audit
   # 可用参数
  # %% = %
  # %c = Client’s name
  # %d = Director’s name
  # %e = Job Exit code (OK, Error, ...)
  # %h = Client address
  # %i = Job Id
  # %j = Unique Job name
  # %l = Job level
  # %n = Job name
  # %r = Recipients
  # %s = Since time
  # %t = Job type (e.g. Backup, ...)
  # %v = Read Volume name (Only on director side)
  # %V = Write Volume name (Only on director side)
  # console：定义发送到console的信息
  # append：定义发送到日志文件的信息
  # catalog：定义发送到数据库的信息
}
1234567891011121314151617181920212223242526272829
```

bsmtp只适用于有本地SMTP服务器，一般情况并不适用。我们将另文介绍如何使用外部SMTP邮件服务器发送bareos的信息邮件。

Bareos的Director已配置完成，在开始备份任务前，我们还需要配置客户端（File Daemon）。

------

#### **配置Bareos客户端（File Daemon）模块**

Bareos客户端（File Daemon）模块的配置文件位于/etc/bareos/bareos-dir.d目录下。

***一、添加/配置客户机***

需要在Director和客户机上分别配置。

首先在Director上有 bconsole 新增客户机 [scm.lswin.cn](http://scm.lswin.cn)（这是示例用Ubuntu客户机）

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*
You have messages.
*configure add client name=scm-fd address=scm.lswin.cn password=scmFdPass
Exported resource file "/etc/bareos/bareos-dir-export/client/scm-fd/bareos-fd.d/director/bareos-dir.conf":
Director {
  Name = bareos-dir
  Password = "[md5]94d9e38bace980feecc1be983f379823"
}
Created resource config file "/etc/bareos/bareos-dir.d/client/scm-fd.conf":
Client {
  Name = scm-fd
  Address = scm.lswin.cn
  Password = scmFdPass
}
*
12345678910111213141516171819
```

再新增客户机 [lswin7-1.lswin.cn](http://lswin7-1.lswin.cn)（这是示例用Windows客户机）

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*
You have messages.
*configure add client name=lswin7-1-fd address=lswin7-1.lswin.cn password=lswin7-1FdPass
Exported resource file "/etc/bareos/bareos-dir-export/client/lswin7-1-fd/bareos-fd.d/director/bareos-dir.conf":
Director {
  Name = bareos-dir
  Password = "[md5]c25dfe0e029bfcebc4feb30c0d68f857"
}
Created resource config file "/etc/bareos/bareos-dir.d/client/lswin7-1-fd.conf":
Client {
  Name = lswin7-1-fd
  Address = lswin7-1.lswin.cn
  Password = lswin7-1FdPass
}
*
12345678910111213141516171819
```

新增客户机配置后，需要重启Director，否则新增的客户机不会出现在客户机列表中。

***二、在Ubuntu客户机上安装bareos-fd软件包。***

*添加 Bareos 库的APT健*

```
root@scm:~# 
root@scm:~# wget -q http://download.bareos.org/bareos/release/latest/Debian_9.0/Release.key -O- | apt-key add -
OK
root@scm:~# 
1234
```

*添加 Bareos 库定义（/etc/apt/sources.list.d/bareos.list）*

```
 deb http://download.bareos.org/bareos/release/latest/Debian_9.0 /
1
```

*更新 APT 库*

```
root@scm:~# apt update
1
```

*在Ubuntu安装 bareos-fd软件包*

```
root@scm:~# apt install bareos-filedaemon
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  bareos-common libfastlz libjansson4
The following NEW packages will be installed:
  bareos-common bareos-filedaemon libfastlz libjansson4
0 upgraded, 4 newly installed, 0 to remove and 2 not upgraded.
Need to get 756 kB of archives.
After this operation, 2,369 kB of additional disk space will be used.
Do you want to continue? [Y/n] 
Get:1 http://mirrors.aliyun.com/ubuntu bionic/main amd64 libjansson4 amd64 2.11-1 [29.3 kB]
......
......
......
Processing triggers for systemd (237-3ubuntu10.3) ...
Processing triggers for ureadahead (0.100.0-20) ...
root@scm:~# 
12345678910111213141516171819
```

然后将Director机器上的`/etc/bareos/bareos-dir-export/client/scm-fd/bareos-fd.d/director/bareos-dir.conf`文件复制到本地，文件为`/etc/bareos/bareos-fd.d`。复制完成后需重启Bareos 的 FileDaemon，否则新的配置不会取作用。

***三、在Windows客户机上安装bareos-fd软件包。***

软件包下载地址：
 [64位Bareos File Daemon软件包](http://download.bareos.org/bareos/release/latest/windows/winbareos-17.2.4-postvista-64-bit-r8.1.exe)
 [32位Bareos File Daemon软件包](http://download.bareos.org/bareos/release/latest/windows/winbareos-17.2.4-postvista-32-bit-r8.1.exe)

安装Bareos File Daemon
 ![在这里插入图片描述](https://img-blog.csdn.net/20181004194501412?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![在这里插入图片描述](https://img-blog.csdn.net/20181004194634517?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/2018100419473766?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181004194813891?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181004195341920?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

将Director机器上文件`/etc/bareos# /etc/bareos/bareos-dir-export/client/lswin7-1-fd/bareos-fd.d/director/bareos-dir.conf`中的Password复制到Password中；再将`/etc/bareos/bareos-dir.d/bareos-dir.d/console/bareos-mon.conf`文件中的Password复制到`Client Monitor Password`中。如不需要Monitor，可忽略复制`Client Monitor Password`这一步。

后面的只需要按提示进行直到完成即可。

到此为止Bareos的Director，Storage和Client都已经配置完成，可以使用了。

------

## **Bareos系统测试**

在此我们使用bconsole对已配置的Bareos系统进行测试。

***检查安装的版本***

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*version
bareos-dir Version: 17.2.4 (21 Sep 2017) x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch) Debian_9.0 x86_64 
*
1234567
```

安装的bareos-dir版本是 17.2.4 的 Debian_9.0版，ubuntu 18.04是基于Debian_9.0。

***检查配置的客户机***

```
*show client
Client {
  Name = "scm-fd"
  Address = "scm.lswin.cn"
  Password = "[md5]94d9e38bace980feecc1be983f379823"
  Catalog = "MyCatalog"
}

Client {
  Name = "lswin7-1-fd"
  Address = "lswin7-1.lswin.cn"
  Password = "[md5]c25dfe0e029bfcebc4feb30c0d68f857"
  Catalog = "MyCatalog"
}

Client {
  Name = "bareos-fd"
  Description = "Client resource of the Director itself."
  Address = "localhost"
  Password = "[md5]33e11c4e5a631bf5620f66e4b4e18e76"
  Catalog = "MyCatalog"
}

*
123456789101112131415161718192021222324
```

***测试备份任务（backup-test-on-bareos-fd）***

```
*
*run
A job name must be specified.
The defined Job resources are:
     1: RestoreFiles
     2: backup-test-on-bareos-fd
     3: BackupCatalog
     4: backup-bareos-fd
Select Job resource (1-4): 2
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Incremental
Client:   bareos-fd
Format:   Native
FileSet:  TestSet
Pool:     Incremental (From Job IncPool override)
Storage:  File (From Job resource)
When:     2018-10-04 18:39:17
Priority: 10
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Client
     6: Backup Format
     7: When
     8: Priority
     9: Pool
    10: Plugin Options
Select parameter to modify (1-10): 1
Levels:
     1: Full
     2: Incremental
     3: Differential
     4: Since
     5: VirtualFull
Select level (1-5): 1
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Full
Client:   bareos-fd
Format:   Native
FileSet:  TestSet
Pool:     Full (From Job FullPool override)
Storage:  File (From Job resource)
When:     2018-10-04 18:39:17
Priority: 10
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Client
     6: Backup Format
     7: When
     8: Priority
     9: Pool
    10: Plugin Options
Select parameter to modify (1-10): 5
The defined Client resources are:
     1: scm-fd
     2: bareos-fd
Select Client (File daemon) resource (1-3): 1
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Full
Client:   scm-fd
Format:   Native
FileSet:  TestSet
Pool:     Full (From Job FullPool override)
Storage:  File (From Job resource)
When:     2018-10-04 18:39:17
Priority: 10
OK to run? (yes/mod/no): 
Job queued. JobId=13
*status
Status available for:
     1: Director
     2: Storage
     3: Client
     4: Scheduler
     5: All
Select daemon type for status (1-5): 1
bareos-dir Version: 17.2.4 (21 Sep 2017) x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch)
Daemon started 04-Oct-18 18:03. Jobs: run=2, running=0 mode=0 db=mysql
 Heap: heap=409,600 smbytes=260,292 max_bytes=302,389 bufs=1,044 max_bufs=1,458

Scheduled Jobs:
Level          Type     Pri  Scheduled          Name               Volume
===================================================================================
Incremental    Backup    10  04-Oct-18 21:00    backup-test-on-bareos-fd Incremental-0002
Incremental    Backup    10  04-Oct-18 21:00    backup-bareos-fd   Incremental-0002
Full           Backup    11  04-Oct-18 21:10    BackupCatalog      Incremental-0002
====

Running Jobs:
Console connected at 04-Oct-18 18:32
No Jobs running.
====

Terminated Jobs:
 JobId  Level    Files      Bytes   Status   Finished        Name 
====================================================================
     4  Incr          0         0   OK       20-Sep-18 21:00 backup-bareos-fd
     5  Full         62    84.23 K  OK       20-Sep-18 21:10 BackupCatalog
     6  Incr          0         0   OK       24-Sep-18 21:00 backup-bareos-fd
     7  Full         67    96.19 K  OK       24-Sep-18 21:10 BackupCatalog
    10  Full        202    32.57 M  OK       03-Oct-18 15:08 backup-test-on-bareos-fd
    11                1    83.58 K  OK       03-Oct-18 15:17 RestoreFiles
    13  Full        175    30.33 M  OK       04-Oct-18 18:40 backup-test-on-bareos-fd


Client Initiated Connections (waiting for jobs):
Connect time        Protocol            Authenticated       Name                                    
====================================================================================================
====
You have messages.
*messages 
04-Oct 18:40 bareos-dir JobId 13: Start Backup JobId 13, Job=backup-test-on-bareos-fd.2018-10-04_18.40.45_37
04-Oct 18:40 bareos-dir JobId 13: Using Device "FileStorage" to write.
04-Oct 18:40 bareos-sd JobId 13: Volume "Full-0001" previously written, moving to end of data.
04-Oct 18:40 bareos-sd JobId 13: Ready to append to end of Volume "Full-0001" size=95925221
04-Oct 18:40 bareos-sd JobId 13: Elapsed time=00:00:01, Transfer rate=30.35 M Bytes/second
04-Oct 18:40 bareos-dir JobId 13: sql_create.c:872 Insert of attributes batch table done
04-Oct 18:40 bareos-dir JobId 13: Bareos bareos-dir 17.2.4 (21Sep17):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch)
  JobId:                  13
  Job:                    backup-test-on-bareos-fd.2018-10-04_18.40.45_37
  Backup Level:           Full
  Client:                 "scm-fd" 17.2.4 (21Sep17) x86_64-pc-linux-gnu,debian,Debian GNU/Linux 9.3 (stretch),Debian_9.0,x86_64
  FileSet:                "TestSet" 2018-10-03 15:08:15
  Pool:                   "Full" (From Job FullPool override)
  Catalog:                "MyCatalog" (From Client resource)
  Storage:                "File" (From Job resource)
  Scheduled time:         04-Oct-2018 18:39:17
  Start time:             04-Oct-2018 18:40:47
  End time:               04-Oct-2018 18:40:48
  Elapsed time:           1 sec
  Priority:               10
  FD Files Written:       175
  SD Files Written:       175
  FD Bytes Written:       30,336,281 (30.33 MB)
  SD Bytes Written:       30,354,503 (30.35 MB)
  Rate:                   30336.3 KB/s
  Software Compression:   None
  VSS:                    no
  Encryption:             no
  Accurate:               no
  Volume name(s):         Full-0001
  Volume Session Id:      2
  Volume Session Time:    1538647406
  Last Volume Bytes:      126,307,760 (126.3 MB)
  Non-fatal FD errors:    0
  SD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Backup OK

*
123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143144145146147148149150151152153154155156157158159160161162
```

信息显示备份已成功完成。

***测试恢复任务（backup-test-on-bareos-fd）***

```
*restore 

First you select one or more JobIds that contain files
to be restored. You will be presented several methods
of specifying the JobIds. Then you will be allowed to
select which files from those JobIds are to be restored.

To select the JobIds, you have the following choices:
     1: List last 20 Jobs run
     2: List Jobs where a given File is saved
     3: Enter list of comma separated JobIds to select
     4: Enter SQL list command
     5: Select the most recent backup for a client
     6: Select backup for a client before a specified time
     7: Enter a list of files to restore
     8: Enter a list of files to restore before a specified time
     9: Find the JobIds of the most recent backup for a client
    10: Find the JobIds for a backup for a client before a specified time
    11: Enter a list of directories to restore for found JobIds
    12: Select full restore to a specified Job date
    13: Cancel
Select item:  (1-13): 5
Defined Clients:
     1: bareos-fd
     2: scm-fd
Select the Client (1-3): 3
Automatically selected FileSet: TestSet
+-------+-------+----------+------------+---------------------+------------+
| JobId | Level | JobFiles | JobBytes   | StartTime           | VolumeName |
+-------+-------+----------+------------+---------------------+------------+
|    13 | F     |      175 | 30,336,281 | 2018-10-04 18:40:47 | Full-0001  |
+-------+-------+----------+------------+---------------------+------------+
You have selected the following JobId: 13

Building directory tree for JobId(s) 13 ...  +++++++++++++++++++++++++++++++++++++++++++
174 files inserted into the tree.

You are now entering file selection mode where you add (mark) and
remove (unmark) files to be restored. No files are initially added, unless
you used the "all" keyword on the command line.
Enter "done" to leave this mode.

cwd is: /
$ 
$ ls
usr/
$ mark usr
175 files marked.
$ done
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.1.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================
   
    Full-0001                 File                      FileStorage              

Volumes marked with "*" are online.

175 files selected to be restored.

Run Restore job
JobName:         RestoreFiles
Bootstrap:       /var/lib/bareos/bareos-dir.restore.1.bsr
Where:           /tmp/bareos-restores
Replace:         Always
FileSet:         LinuxAll
Backup Client:   scm-fd
Restore Client:  scm-fd
Format:          Native
Storage:         File
When:            2018-10-04 18:56:40
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no): 
Job queued. JobId=16
*status
Status available for:
     1: Director
     2: Storage
     3: Client
     4: Scheduler
     5: All
Select daemon type for status (1-5): 1
bareos-dir Version: 17.2.4 (21 Sep 2017) x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch)
Daemon started 04-Oct-18 18:03. Jobs: run=5, running=0 mode=0 db=mysql
 Heap: heap=311,296 smbytes=535,619 max_bytes=836,693 bufs=1,209 max_bufs=1,792

Scheduled Jobs:
Level          Type     Pri  Scheduled          Name               Volume
===================================================================================
Incremental    Backup    10  04-Oct-18 21:00    backup-test-on-bareos-fd Incremental-0002
Incremental    Backup    10  04-Oct-18 21:00    backup-bareos-fd   Incremental-0002
Full           Backup    11  04-Oct-18 21:10    BackupCatalog      Incremental-0002
====

Running Jobs:
Console connected at 04-Oct-18 18:32
No Jobs running.
====

Terminated Jobs:
 JobId  Level    Files      Bytes   Status   Finished        Name 
====================================================================
     7  Full         67    96.19 K  OK       24-Sep-18 21:10 BackupCatalog
    10  Full        202    32.57 M  OK       03-Oct-18 15:08 backup-test-on-bareos-fd
    11                1    83.58 K  OK       03-Oct-18 15:17 RestoreFiles
    13  Full        175    30.33 M  OK       04-Oct-18 18:40 backup-test-on-bareos-fd
    16              175    30.33 M  OK       04-Oct-18 18:56 RestoreFiles


Client Initiated Connections (waiting for jobs):
Connect time        Protocol            Authenticated       Name                                    
====================================================================================================
====
You have messages.
*
*messages 
04-Oct 18:56 bareos-dir JobId 16: Start Restore Job RestoreFiles.2018-10-04_18.56.47_55
04-Oct 18:56 bareos-dir JobId 16: Using Device "FileStorage" to read.
04-Oct 18:56 bareos-sd JobId 16: Ready to read from volume "Full-0001" on device "FileStorage" (/var/lib/bareos/storage).
04-Oct 18:56 bareos-sd JobId 16: Forward spacing Volume "Full-0001" to file:block 0:95925221.
04-Oct 18:56 bareos-sd JobId 16: End of Volume at file 0 on device "FileStorage" (/var/lib/bareos/storage), Volume "Full-0001"
04-Oct 18:56 bareos-sd JobId 16: End of all volumes.
04-Oct 18:56 bareos-dir JobId 16: Bareos bareos-dir 17.2.4 (21Sep17):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch)
  JobId:                  16
  Job:                    RestoreFiles.2018-10-04_18.56.47_55
  Restore Client:         scm-fd
  Start time:             04-Oct-2018 18:56:49
  End time:               04-Oct-2018 18:56:49
  Elapsed time:           0 secs
  Files Expected:         175
  Files Restored:         175
  Bytes Restored:         30,336,281
  Rate:                   0.0 KB/s
  FD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Restore OK

*
123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143
```

信息显示文件恢复已成功完成。

***测试备份Windows电脑（backup-test-on-bareos-fd）***

```
root@bareos:~# 
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*run
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"
A job name must be specified.
The defined Job resources are:
     1: RestoreFiles
     2: backup-test-on-bareos-fd
     3: BackupCatalog
     4: backup-bareos-fd
Select Job resource (1-4): 2
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Incremental
Client:   bareos-fd
Format:   Native
FileSet:  TestSet
Pool:     Incremental (From Job IncPool override)
Storage:  File (From Job resource)
When:     2018-10-05 10:39:59
Priority: 10
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Client
     6: Backup Format
     7: When
     8: Priority
     9: Pool
    10: Plugin Options
Select parameter to modify (1-10): 1
Levels:
     1: Full
     2: Incremental
     3: Differential
     4: Since
     5: VirtualFull
Select level (1-5): 1
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Full
Client:   bareos-fd
Format:   Native
FileSet:  TestSet
Pool:     Full (From Job FullPool override)
Storage:  File (From Job resource)
When:     2018-10-05 10:39:59
Priority: 10
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Client
     6: Backup Format
     7: When
     8: Priority
     9: Pool
    10: Plugin Options
Select parameter to modify (1-10): 5
The defined Client resources are:
     1: scm-fd
     2: lswin7-1-fd
     3: lscms-fd
     4: bareos-fd
Select Client (File daemon) resource (1-4): 2
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Full
Client:   lswin7-1-fd
Format:   Native
FileSet:  TestSet
Pool:     Full (From Job FullPool override)
Storage:  File (From Job resource)
When:     2018-10-05 10:39:59
Priority: 10
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Client
     6: Backup Format
     7: When
     8: Priority
     9: Pool
    10: Plugin Options
Select parameter to modify (1-10): 4
The defined FileSet resources are:
     1: Windows Test Fileset
     2: Windows All Drives
     3: TestSet
     4: SelfTest
     5: LinuxAll
     6: Catalog
Select FileSet resource (1-6): 1
Run Backup job
JobName:  backup-test-on-bareos-fd
Level:    Full
Client:   lswin7-1-fd
Format:   Native
FileSet:  Windows Test Fileset
Pool:     Full (From Job FullPool override)
Storage:  File (From Job resource)
When:     2018-10-05 10:39:59
Priority: 10
OK to run? (yes/mod/no): 
Job queued. JobId=19
You have messages.
*messages 
05-Oct 10:18 bareos-dir JobId 19: Start Backup JobId 18, Job=backup-test-on-bareos-fd.2018-10-05_10.18.57_06
05-Oct 10:18 bareos-dir JobId 19: Using Device "FileStorage" to write.
05-Oct 10:18 bareos-sd JobId 19: Volume "Full-0001" previously written, moving to end of data.
05-Oct 10:18 bareos-sd JobId 19: Ready to append to end of Volume "Full-0001" size=126308232
05-Oct 10:18 lswin7-1-fd JobId 19: Created 28 wildcard excludes from FilesNotToBackup Registry key
05-Oct 10:19 lswin7-1-fd JobId 19: Generate VSS snapshots. Driver="Win64 VSS", Drive(s)="C"
05-Oct 10:19 lswin7-1-fd JobId 19: VolumeMountpoints are not processed as onefs = yes.
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "Task Scheduler Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "VSS Metadata Store Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "Performance Counters Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "System Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "ASR Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "Registry Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "Shadow Copy Optimization Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "BITS Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "COM+ REGDB Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "WMI Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 lswin7-1-fd JobId 19: VSS Writer (BackupComplete): "MSSearch Service Writer", State: 0x1 (VSS_WS_STABLE)
05-Oct 10:19 bareos-sd JobId 19: Elapsed time=00:00:18, Transfer rate=2.182 M Bytes/second
05-Oct 10:19 bareos-dir JobId 19: sql_create.c:872 Insert of attributes batch table done
05-Oct 10:19 bareos-dir JobId 19: Bareos bareos-dir 17.2.4 (21Sep17):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 9.3 (stretch)
  JobId:                  19
  Job:                    backup-test-on-bareos-fd.2018-10-05_10.18.57_06
  Backup Level:           Full
  Client:                 "lswin7-1-fd" 17.2.4 (21Sep17) Microsoft Windows 7 Ultimate Edition Service Pack 1 (build 7601), 64-bit,Cross-compile,Win64
  FileSet:                "Windows Test Fileset" 2018-10-05 10:18:57
  Pool:                   "Full" (From command line)
  Catalog:                "MyCatalog" (From Client resource)
  Storage:                "File" (From Job resource)
  Scheduled time:         05-Oct-2018 10:18:57
  Start time:             05-Oct-2018 10:18:59
  End time:               05-Oct-2018 10:19:17
  Elapsed time:           18 secs
  Priority:               10
  FD Files Written:       6
  SD Files Written:       6
  FD Bytes Written:       39,284,012 (39.28 MB)
  SD Bytes Written:       39,285,181 (39.28 MB)
  Rate:                   2182.4 KB/s
  Software Compression:   None
  VSS:                    yes
  Encryption:             no
  Accurate:               no
  Volume name(s):         Full-0001
  Volume Session Id:      2
  Volume Session Time:    1538702289
  Last Volume Bytes:      165,623,141 (165.6 MB)
  Non-fatal FD errors:    0
  SD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Backup OK

*
123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143144145146147148149150151152153154155156157158159160161162163164165166167168169170171172173174
```

备份Windows电脑已成功备份。

最基本的Bareos系统配置已全部完成。Bareos是一个完整的企业级备份恢复系统，上述介绍的只是最简单的配置，详细配置请参阅[Bareos文档](https://www.bareos.org/en/manual.html)。

下文我们将介绍Bareos-WebUI。

# Bareos-WebUI使用介绍

Bareos-WebUI提供Bareos系统的使用和监控Web用户界面，不直接支持Bareos系统的配置功能。WebUI提供基于浏览器的模拟bconsole，Bareos的配置基本都可使用该bconsole界面来完成。完整的系统管理和配置只能通过系统终端完成。

------

## 登陆界面

![在这里插入图片描述](https://img-blog.csdn.net/2018100609584011?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
  WebUI支持多Director和多种语言，包括中文。在示例中只有一个Director（localhost-dir），所以默认选择为localhost-dir，如有多个Director，可以通过下拉菜单选择连接的Director。默认语言为英文，如需要使用中文显示，使用语言下拉菜单选择Chinese。

Bareos的中文支持并不完美，其一是它只支持一种中文，所以现在的翻译是简繁体混杂；二是还有部分没翻译或翻译不精确；三是还有部分代码不支持多语言。

Bareos系统没有设置默认WebUI管理用户，在使用前必须先设置管理用户。
 使用bconsole添加WebUI管理员账号（profile名字为webui-admin，这是系统为WebUI保留的profile名字）。

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*
*configure add console name=admin password=pwd111111 profile=webui-admin
Created resource config file "/etc/bareos/bareos-dir.d/console/admin.conf":
Console {
  Name = admin
  Password = pwd111111
  Profile = webui-admin
}
*
12345678910111213
```

------

## 主页界面

使用新建账号登陆Bareos系统。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181006165318135?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

首页共分5个显示区域：

**工具/状态栏**
 左边是工具选择，分别是`主页`、`任务`、`客户端`、`时间表`、`存储`和`主控端`，用于选择不同的功能。
 右边显示的是当前连接的`Director`和`当前用户`。

**过去24小时中执行的任务情况**
 显示最近24小时内任务执行的简单统计：
 运行：显示正在运行的任务数。
 等待：显示已经启动但正在等待资源就绪的任务数。
 成功：显示正在运行成功的任务数。
 失败：显示正在运行失败的任务数。

**作业统计**
 显示系统启用后的任务总数、文件总数和数据总量。

**最近执行的作业详情**
 显示每个任务执行的任务详情，每个任务只显示最后一次的详情。

**正在执行的任务**
 显示正在执行的任务。

点击当前用户（`admin`），将出现附加功能下拉菜单：

![img](https://img-blog.csdn.net/20181006191453345?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

`用户手册`：点击打开Bareos用户手册页面。
 `用户论坛`：点击打开Bareos用户论坛页面。
 `问题追踪`：点击打开Bareos问题追踪页面。
 `技术支持`：点击打开Bareos技术支持页面。
 `订阅`：点击打开订阅Bareos付费支持页面。
 `登出`：点击退出Bareos-WebUI。

------

## 任务界面

![在这里插入图片描述](https://img-blog.csdn.net/20181006190927596?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

**运行模块**
 功能：通过临时修改现有任务的方式，在指定时间执行备份任务。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181008112401609?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- `作业*`：在下拉菜单中选择一个预定义的任务。
- `客户端`：在下拉菜单中，选择合适的客户机，在这里我们选择了lswin0-01-fd（WIN10客户机）。在任务定义中，客户端是总是bareos-fd，原因是bareos-dir无法启动如果客户机没有运行。
- `文件集`：在下拉菜单中选择一个合适的预定义文件集。
- `存储`：在下拉菜单中选择一个合适的预定义存储类型。
- `池`：在下拉菜单中选择一个合适的预定义存储池。
- `备份级别`：在下拉菜单中选择一个合适的备份级别，只用三种备份级别：Full、Differential和Incremental。
- `类型`：在`运行`界面只能运行备份任务。
- `优先级`：为大于或等于1的整数。数值越大优先级越低，优先级高的任务先于优先级的任务运行。
- `执行时间`：从弹出时间选择对话窗口选择执行时间。如不选择时间，即立刻执行该任务。

所有的修改都是临时性的，不会存入选择的任务中。

**动作模块**
 功能：直接运行任务和禁用/启用任务。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010100322547?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 点击动作栏中的                                    ▶                              \blacktriangleright                  ▶ 可直接运行任务。
- 点击动作栏中的                                    ×                              \times                  × 禁用该任务。
- 点击动作栏中的                                    √                              \surd                  √ 启用该任务。
- 状态栏显示的是现有任务的状态。

**显示模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/2018101010165873?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 点击作业ID栏中的                                    +                              +                  + 显示该任务详情。
- 点击作业ID栏中的数字（ID）显示该任务的执行详情。
- 点击动作栏中的                                    ↻                              \boldsymbol{\circlearrowright}                  ↻ 再次执行该任务。
- 点击动作栏中的                                              ↓                            ‾                                       \boldsymbol{\underline{\downarrow}}                  ↓ 使用该任务的备份恢复文件。

------

## 还原界面

![在这里插入图片描述](https://img-blog.csdn.net/20181010155019635?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

功能：从现有备份中恢复文件。

- `客户端`：从下拉菜单中选择备份所属的客户端
- `备份作业`：从下拉菜单中选择需要的备份作业。
- `合并所有客户端文件集`：自动把该客户端该作业和该作业以前的所有备份（含不同作业）集合在一起供恢复文件使用；如选“否”，只从选择的备份中恢复文件。
- `合并所有相关作业`：如选“是”，自动把该客户端该作业和该作业以前的所有同一作业的备份集合在一起供恢复文件使用；如选“否”，只从选择的备份中恢复文件。
- `还原到客户端`：从下拉菜单中选择恢复文件的目标客户端。
- `还原作业`：从下拉菜单中选择预定义的还原作业。
- `替换客户端上的文件`：选择同名文件的覆盖规则。可选规则为：总是、从不、比现有文件旧和比现有文件新。
- `要恢复到客户端的位置`：指定恢复文件的目标路径。
- `文件选择`：点击文件/路径前                                    □                              \Box                  □ 来选择是否要恢复此文件/路径；如选择路径，在该路径下的所有文件都会被恢复。                                                                                 ✓                                                                        \boxed{\color{#00FF00}{\checkmark}}                  ✓ 表示需要恢复的文件/路径，                                   □                              \Box                  □ 表示该文件或路径不需要恢复。

完成设置后，点击                                                  还原                                           \colorbox{#0080ff}{\color{white}{还原}}               还原 键启动恢复任务。

------

## 客户端界面

![在这里插入图片描述](https://img-blog.csdn.net/20181010161148306?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 列表所有已定义的客户端。

- 名称栏显示的是所有已定义客户端的名字，点击客户端名字将显示客户端当前的一些情况。
- 版本栏显示客户端FD的版本情况，图标是表示系统类型，数字表示版本号。                                                        17.2.4                                                 \colorbox{#00d000}{\color{white}{17.2.4}}                  17.2.4 表示是最新版本，                                                         17.2.4                                                 \colorbox{#a0a0a0}{\color{white}{17.2.4}}                  17.2.4 表示无法确定是否是最新版本。
- 状态栏显示的是该FD当前的状态，可以是                                                         已启用                                                 \colorbox{#00d000}{\color{white}{已启用}}                  已启用 或                                                         禁用                                                 \colorbox{#d00000}{\color{white}{禁用}}                  禁用。
- 点击动作栏中的                                    ×                              \times                  × 禁用该FD。
- 点击动作栏中的                                    √                              \surd                  √ 启用该FD。
- 点击动作栏中的                                              ↘                            ‾                                       \underline{\boldsymbol{\searrow}}                  ↘ 开始该客户端备份的恢复任务。
- 点击动作栏中的                                    ⨀                              {\boldsymbol{\bigodot}}                  ⨀ 检查FD的当前状态。
- 

------

## 时间表（schedule）界面

**显示模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164448237?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 名称栏显示的是所有已定义时间表的名字，点击时间表名字将显示该时间表详细信息。
- 状态栏显示的是该FD当前的状态，可以是                                                         已启用                                                 \colorbox{#00d000}{\color{white}{已启用}}                  已启用 或                                                         禁用                                                 \colorbox{#d00000}{\color{white}{禁用}}                  禁用。
- 点击动作栏中的                                    ×                              \times                  × 禁用该FD。
- 点击动作栏中的                                    √                              \surd                  √ 启用该FD。

**概述模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164728191?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 显示时间表定义文件。

**调度程序状态模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164920851?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 显示时间表调度详情。

------

## 存储（storage）界面

共有三个显示模块，分别显示设备（device）、池（pool）和卷（volume）的情况。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170117161?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170136222?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170154398?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

------

## 主控端（Director）界面

共有三个模块，分别显示状态（status）、信息（message）情况和控制台（bconsole）模拟界面。
 ![在这里插入图片描述](https://img-blog.csdn.net/2018101017080180?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170817554?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010171033260?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 模拟bconsole界面的可用性并不是太好，建议在系统终端使用bconsole来配置系统。

------

Bareos-WebUI的真正目的是为管理员提供一个友好的日常系统备份/恢复界面，它通过模拟bconsole界面支持的系统配置功能有限，使用体验不是太好。

Bareos-WebUI使用介绍就此结束，下文将介绍一些支持Bareos备份/恢复系统功能的安装和配置，如如何使用外部SMTP服务器发送信息邮件等。最后我们用一张较为完整的首页图片结束本文。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010172119582?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



- ​                                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarThumbUp.png)               点赞                                    

- ​                [                     ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarComment.png)                                          评论                                                           ](https://blog.csdn.net/laotou1963/article/details/82949459#commentBox)            

- ​                [                     ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarShare.png)                                          分享                 ](javascript:;)                            

- ​                [                                          ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png)                                          收藏                                                           ](javascript:;)            

- ​                                    ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarReward.png)                                        打赏                             

- ​                              ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarReport.png)                                举报                          

- ​                    [关注](javascript:;)                            

- 一键三连

  点赞Mark关注该博主, 随时了解TA的最新博文![img](https://csdnimg.cn/release/blogv2/dist/pc/img/closePrompt.png)

## 为Bareos配置外部SMTP邮件服务器

Bareos可以用电子邮件将有关信息发送到邮箱，并提供了bsmtp邮件发送工具。bsmtp工具很简单，并不适用一般中小微企业情况。本文将介绍如何配置外部SMTP服务器为Bareos发送邮件。




------

### 安装配置postfix服务



#### 安装Postfix

```shell
root@bareos:~# apt install libsasl2-modules postfix mailutils
Reading package lists... Done
Building dependency tree       
Reading state information... Done
libsasl2-modules is already the newest version (2.1.27~101-g0780600+dfsg-3ubuntu2).
The following additional packages will be installed:
  guile-2.0-libs libgc1c2 libgsasl7 libkyotocabinet16v5 libltdl7 libmailutils5 libmysqlclient20 libntlm0 libpython2.7 libpython2.7-minimal
  libpython2.7-stdlib mailutils-common mysql-common ssl-cert
Suggested packages:
  mailutils-mh mailutils-doc procmail postfix-mysql postfix-pgsql postfix-ldap postfix-pcre postfix-lmdb postfix-sqlite sasl2-bin
  dovecot-common resolvconf postfix-cdb postfix-doc openssl-blacklist
The following NEW packages will be installed:
  guile-2.0-libs libgc1c2 libgsasl7 libkyotocabinet16v5 libltdl7 libmailutils5 libmysqlclient20 libntlm0 libpython2.7 libpython2.7-minimal
  libpython2.7-stdlib mailutils mailutils-common mysql-common postfix ssl-cert
0 upgraded, 16 newly installed, 0 to remove and 0 not upgraded.
Need to get 8,916 kB of archives.
After this operation, 43.1 MB of additional disk space will be used.
Do you want to continue? [Y/n] 
......
......
......
Processing triggers for systemd (237-3ubuntu10.3) ...
Processing triggers for ureadahead (0.100.0-20) ...
Processing triggers for rsyslog (8.32.0-1ubuntu4) ...
Processing triggers for ufw (0.35-5) ...
root@bareos:~# 

123456789101112131415161718192021222324252627
```

当询问邮件设置类型时，暂时选择“No configuration”，我们将在后面手工配置。

![这里写图片描述](https://img-blog.csdn.net/20180915175825514?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



#### 配置postfix

现在的SMTP服务，一般都会有严格的安全控制，包括QQ邮箱、阿里邮箱。如以前经常使用的方式：以account1授权发送邮件，在邮件头使用From：account2或Reply-to：account3的方式来说明不同的邮件来源，现在已不可行，account2和account3都必须独立验证授权。为此，我们需要为postfix配置三个文件，分别是`main.cf`、`sasl_passwd`和`sender_relay`。


**配置 [main.cf](http://main.cf)**

**`/etc/postfix/main.cf`**

```bash
# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Bareos)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = lswin.cn
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = localhost
mynetworks = localhost
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = ipv4
smtputf8_enable = no
# 使用TLS
smtp_use_tls = yes
# 启用SASL授权
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sender_dependent_authentication = yes
# accounts独立授权
sender_dependent_relayhost_maps = hash:/etc/postfix/sender_relay
# accounts信息
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354
```



**配置 sasl_passwd**

**`/etc/postfix/sasl/sasl_passwd`**

```shell
admin@lswin.cn admin@lswin.cn:admin-passwd
bareos@lswin.cn bareos@lswin.cn:bareos-passwd

[smtp.mxhichina.com]:587 admin@lswin.cn:admin-passwd
1234
```

因sasl_passwd含有明码密码，我们需要修改它的属性为600（只有root能读写）
 最后产生hash文件（sasl_passwd.db)

```shell
root@bareos:~# chmod 600 /etc/postfix/sasl/sasl_passwd
root@bareos:~# postmap /etc/postfix/sasl/sasl_passwd
12
```



**配置 sender_relay**

**`/etc/postfix/sender_relay`**

```shell
admin@lswin.cn [smtp.mxhichina.com]:587
bareos@lswin.cn [smtp.mxhichina.com]:587
12
```

该文件也需要hash。

```shell
root@bareos:~# postmap /etc/postfix/sender_reply
1
```

文件中邮件账号的密码在sasl_passwd中。


**配置 mailname**

将下列行加入/etc/mailname文件

```
lswin.cn
1
```

[这个文件指明邮件域名是lswin.cn](http://xn--lswin-mn1hs1ca148iosjt35anjghxbknv472cs1c.cn)。

***注意：这里使用的 [lswin.cn](http://lswin.cn) 和 邮件账号都是虚拟的，您必须使用真实的邮件域名和相对应的邮件账号。***


**检查postfix**

至此，postfix已设置安装完成，需要重启postfix服务，然后再检查postfix是否正常运行。

```shell
root@bareos:~# 
root@bareos:~# systemctl status postfix
● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/lib/systemd/system/postfix.service; enabled; vendor preset: enabled)
   Active: active (exited) since Sat 2018-09-15 20:04:04 CST; 12s ago
  Process: 5713 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 5713 (code=exited, status=0/SUCCESS)

Sep 15 20:04:04 bareos systemd[1]: Starting Postfix Mail Transport Agent...
Sep 15 20:04:04 bareos systemd[1]: Started Postfix Mail Transport Agent.
root@bareos:~# 

123456789101112
```

如您能见到类似上面的结果，说明postfix运行正常。



#### 检查邮件发送

```shell
root@bareos:~# echo “This is a test email body.” | mail -s "Subject: BAREOS相关提示！" s.zhang@lswin.cn
1
```

这里我们没有指定发送者，邮件客户端会自动使用当前用户（root）@本地domain（[lscm.lswin.cn](http://lscm.lswin.cn)）作为发送者，授权使用admin@lswin.cn（在sasl_passwd中配置的默认值）。

下面是/var/log/mail.log中显示的信息：

```shell
Sep 15 20:07:33 bareos postfix/pickup[5711]: 715DE41696: uid=0 from=<root@bareos.lswin.cn>
Sep 15 20:07:33 bareos postfix/cleanup[5755]: 715DE41696: message-id=<20180915120733.715DE41696@lswin.cn>
Sep 15 20:07:33 bareos postfix/qmgr[5712]: 715DE41696: from=<root@bareos.lswin.cn>, size=381, nrcpt=1 (queue active)
Sep 15 20:07:33 bareos postfix/smtp[5748]: 715DE41696: host smtp.mxhichina.com[42.120.219.29] said: 440 mail from account doesn't conform with authentication (Auth Account:admin@lswin.cn|Mail Account:root@bareos.lswin.cn) (in reply to MAIL FROM command)
1234
```

我们可以清楚看到出错原因：发送用的账号（admin@lswin.cn）和发送者账号（root@bareos.lswin.cn）不符，已被拒绝（错误码：440）。

```
root@bareos:~# echo “This is a test email body.” | mail -s "Subject: BAREOS相关提示！" -r admin@lswin.cn s.zhang@lswin.cn
1
```

这里我们指定Reply-to为admin@lswin.cn（-r admin@lswin.cn），postfix根据sasl_passwd和sender_relay中的配置，选择正确的用户信息来发送邮件。

下面是/var/log/mail.log中显示的信息：

```shell
Sep 15 20:25:05 bareos postfix/pickup[5711]: ACBD541698: uid=0 from=<admin@lswin.cn>
Sep 15 20:25:05 bareos postfix/cleanup[5784]: ACBD541698: message-id=<20180915122505.ACBD541698@lswin.cn>
Sep 15 20:25:05 bareos postfix/qmgr[5712]: ACBD541698: from=<admin@lswin.cn>, size=373, nrcpt=1 (queue active)
Sep 15 20:25:35 bareos postfix/smtp[5786]: connect to smtp.mxhichina.com[42.120.226.4]:587: Connection timed out
Sep 15 20:25:36 bareos postfix/smtp[5786]: ACBD541698: to=<s.zhang@lswin.cn>, relay=smtp.mxhichina.com[42.120.219.29]:587, delay=31, delays=0.02/0.01/30/0.23, dsn=2.0.0, status=sent (250 Data Ok: queued as freedom)
Sep 15 20:25:36 bareospostfix/qmgr[5712]: ACBD541698: removed
123456
```

当您看到类似上面的结果，邮件发送请求已被SMTP服务器接受。到此，Postfix安装/配置已完成。




------

### 修改Director邮件发送命令

在Director的信息配置中，发送邮件使用的bsmtp，由于bsmtp的局限性，无法使用一般外部商业SMTP服务，我们必须对此进行修改。在示例中，我们对`/etc/bareos/bareos-dir.d/message/Standard.conf`做修改，您可以参照示例，对其他的邮件发送配置做对应的修改。

在配置文件中的邮件命令为：

```
mailcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<%r\>\" -s \"Bareos: %t %e of %c %l\" %r"
1
```

默认使用BSMTP发送邮件。我们将其修改为：

```
mailcommand = "/usr/local/bin/sendmail -c %c -d %d -e %e -h %h -i %i -j %j -n %n -r %r -t %t -s \"%s\"  -l %l -v \"%v\" -V \"%V\%"
1
```

`/user/local/bin/sendmail` 是我们自定义的发送邮件脚本程序。
 以`%`开头的是在Bareos中可用的参数，我们把所有可用参数全部传递到脚本程序。%s、%v和%V用" "包起来的原因是，这些参数有可能为空，如不把它们包起来，当它们为空时，会造成参数处理问题。

```bash
#!/bin/bash
# available mailcommand parameters
# %% = %
# %c = Client’s name
# %d = Director’s name
# %e = Job Exit code (OK, Error, ...)
# %h = Client address
# %i = Job Id
# %j = Unique Job name
# %l = Job level
# %n = Job name
# %r = Recipients
# %s = Since time
# %t = Job type (e.g. Backup, ...)
# %v = Read Volume name (Only on director side)
# %V = Write Volume name (Only on director side)

bareos_admin="admin@lswin.cn"
mail_receiver="s.zhang@lswin.cn"

# get input opts
while getopts ":c:d:e:h:i:j:l:n:r:s:t:v:V:" o; do
  case "${o}" in
    c)
       client_name=${OPTARG}
       ;;
    d)
       director_name=${OPTARG}
       ;;
    e)
       job_exit_code=${OPTARG}
       ;;
    h)
       client_address=${OPTARG}
       ;;
    i)
       job_id=${OPTARG}
       ;;
    j)
       unique_job_name=${OPTARG}
       ;;
    l)
       job_level=${OPTARG}
       ;;
    n)
       job_name=${OPTARG}
       ;;
    r)
       recipients=${OPTARG}
       ;;
    s)
       since_time=${OPTARG}
       ;;
    t)
       job_type=${OPTARG}
       ;;
    v)
       read_volume_name=${OPTARG}
       ;;
    V)
       write_volume_name=${OPTARG}
       ;;
    *)
       ;;
    esac
done

# 建立邮件 Subject
ubject="BAREOS任务执行"
if [[ "$job_exit_code" == "OK" ]]
then
  Subject=$Subject"完成通知"
else
  Subject=$Subject"失败通知！"
fi

# 建立邮件内容
Content="\"任务 "$job_name" 执行简况:\n 任务ID："$job_id"\n 任务名字："$unique_job_name"\n 任务类型："$job_type
if [[ ! -z "$job_level" && "$job_type" == "Backup" ]]; then Content=$Content"\n 备份级别："$job_level; fi
Content=$Content"\n 完成情况："$job_exit_code"\n 主控端名字："$director_name"\n 客户端名字："$client_name"\n 客户端地址："$client_address
if [[ ! -z "$read_volume_name" && "$job_type" == "RestoreFiles" ]]; then Content=$Content"\n 读取卷名字："$read_volume_name; fi
if [[ ! -z "$write_volume_name" && "$job_type" == "Backup" ]]; then Content=$Content"\n 写入卷名字："$write_volume_name; fi
Content=$Content"\""

# 建立邮件发送命令
cmd="echo -e $Content | /usr/bin/mail -s \"Subject: $Subject\" -r $bareos_admin $mail_receiver"

# 执行邮件发送命令
eval $cmd

exit 0

1234567891011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192
```

然后修改`/usr/local/bin/sendmail`属性，将其改为可执行。

```shell
root@bareos:~# chmod + x /usr/local/bin/sendmail
1
```

最后重启Bareos，为Bareos配置外部SMTP（阿里企业邮箱）在重启后即可正常工作。




------

### 邮件示例

下面是几个Bareos在备份/恢复成功或失败后发送的邮件示例。

**备份成功邮件**

```shell
Subject: BAREOS任务执行完成通知

发件人：admin <admin@lswin.cn>    	
时   间：2018年10月18日(星期四) 上午10:26	纯文本 |  
收件人：
S Zhang<s.zhang@lswin.cn>
任务 backup-bareos-fd 执行简况:
 任务ID：52
 任务名字：backup-bareos-fd.2018-10-18_10.26.39_12
 任务类型：Backup
 备份级别：Full
 完成情况：OK
 主控端名字：bareos-dir
 客户端名字：bareos-fd
 客户端地址：localhost
 写入卷名字：Full-0001
12345678910111213141516
```



**备份失败邮件**

```shell
Subject: BAREOS任务执行失败通知！

发件人：admin <admin@lswin.cn>    	
时   间：2018年10月18日(星期四) 上午10:45	纯文本 |  
收件人：
S Zhang<s.zhang@lswin.cn>
任务 backup-test-on-bareos-fd 执行简况:
 任务ID：53
 任务名字：backup-test-on-bareos-fd.2018-10-18_10.42.13_17
 任务类型：Backup
 备份级别：Full
 完成情况：Error
 主控端名字：bareos-dir
 客户端名字：lscms-fd
 客户端地址：lscms.lswin.cn
123456789101112131415
```



**恢复成功邮件**

```shell
Subject: BAREOS任务执行完成通知

发件人：admin <admin@lswin.cn>    	
时   间：2018年10月18日(星期四) 上午10:45	纯文本 |  
收件人：
S Zhang <s.zhang@lswin.cn>
任务 RestoreFiles 执行简况:
 任务ID：54
 任务名字：RestoreFiles.2018-10-18_10.43.18_37
 任务类型：Restore
 完成情况：OK
 主控端名字：bareos-dir
 客户端名字：bareos-fd
 客户端地址：localhos
1234567891011121314
```



**恢复失败邮件**

```shell
Subject: BAREOS任务执行失败通知！

发件人：admin <admin@lswin.cn>    	
时   间：2018年10月18日(星期四) 上午10:45	纯文本 |  
收件人：
S Zhang<s.zhang@lswin.cn>
任务 RestoreFiles 执行简况:
 任务ID：55
 任务名字：RestoreFiles.2018-10-18_10.44.20_01
 任务类型：Restore
 完成情况：Error
 主控端名字：bareos-dir
 客户端名字：lswin7-1-fd
 客户端地址：lswin7-1.lswin.cn
```

package such as Legato Networker, ARCserveIT, Arkeia, IBM Tivoli Storage Manager or PerfectBackup+, you may be interested in Bareos, which provides many of the same features and is free software available under the GNU AGPLv3 software license.

#
1.3 Bareos Components or Services

Bareos is made up of the following ﬁve major components or services: Director, Console, File, Storage, and Monitor services.

Bareos Directorl

The Bareos Director service is the program that supervises all the backup, restore, verify and archive operations. The system administrator uses the Bareos Director to schedule backups and to recover ﬁles. The Director runs as a daemon (or service) in the background.

Bareos Console

The Bareos Console service is the program that allows the administrator or user to communicate with the Bareos Director. Currently, the Bareos Console is available in two versions: a text-based console and a QT-based GUI interface. The ﬁrst and simplest is to run the Console program in a shell window (i.e. TTY interface). Most system administrators will ﬁnd this completely adequate. The second version is a GUI interface that is far from complete, but quite functional as it has most the capabilities of the shell Console. For more details see the Bareos Console.

Bareos File Daemon

The Bareos File service (also known as the Client program) is the software program that is installed on the machine to be backed up. It is speciﬁc to the operating system on which it runs and is responsible for providing the ﬁle attributes and data when requested by the Director. The File services are also responsible for the ﬁle system dependent part of restoring the ﬁle attributes and data during a recovery operation. This program runs as a daemon on the machine to be backed up.

Bareos Storage Daemon

The Bareos Storage services consist of the software programs that perform the storage and recovery of the ﬁle attributes and data to the physical backup media or volumes. In other words, the Storage daemon is responsible for reading and writing your tapes (or other storage media, e.g. ﬁles). The Storage services runs as a daemon on the machine that has the backup device (such as a tape drive).

Catalog

The Catalog services are comprised of the software programs responsible for maintaining the ﬁle indexes and volume databases for all ﬁles backed up. The Catalog services permit the system administrator or user to quickly locate and restore any desired ﬁle. The Catalog services sets Bareos apart from simple backup programs like tar and bru, because the catalog maintains a record of all Volumes used, all Jobs run, and all Files saved, permitting eﬃcient restoration and Volume management. Bareos currently supports three diﬀerent databases, MySQL, PostgreSQL, and SQLite, one of which must be chosen when building Bareos.

The three SQL databases currently supported (MySQL, PostgreSQL or SQLite) provide quite a number of features, including rapid indexing, arbitrary queries, and security. Although the Bareos project plans to support other major SQL databases, the current Bareos implementation interfaces only to MySQL, PostgreSQL and SQLite.

To perform a successful save or restore, the following four daemons must be conﬁgured and running: the Director daemon, the File daemon, the Storage daemon, and the Catalog service (MySQL, PostgreSQL or SQLite).

#
1.4 Bareos Packages

Following Bareos Linux packages are available (release 14.2):


Package Name 	Description

bareos 	Backup Archiving REcovery Open Sourced - metapackage
bareos-bat 	Bareos Admin Tool (GUI)
bareos-bconsole 	Bareos administration console (CLI)
bareos-client 	Bareos client Meta-All-In-One package
bareos-common 	Common ﬁles, required by multiple Bareos packages
bareos-database-common 	Generic abstraction libs and ﬁles to connect to a database
bareos-database-mysql 	Libs and tools for mysql catalog
bareos-database-postgresql 	Libs and tools for postgresql catalog
bareos-database-sqlite3 	Libs and tools for sqlite3 catalog
bareos-database-tools 	Bareos CLI tools with database dependencies (bareos-dbcheck, bscan)
bareos-devel 	Devel headers
bareos-director 	Bareos Director daemon
bareos-director-python-plugin 	Python plugin for Bareos Director daemon
bareos-ﬁledaemon 	Bareos File daemon (backup and restore client)
bareos-ﬁledaemon-ceph-plugin 	CEPH plugin for Bareos File daemon
bareos-ﬁledaemon-glusterfs-plugin 	GlusterFS plugin for Bareos File daemon
bareos-ﬁledaemon-ldap-python-plugin	LDAP Python plugin for Bareos File daemon
bareos-ﬁledaemon-python-plugin 	Python plugin for Bareos File daemon
bareos-storage 	Bareos Storage daemon
bareos-storage-ceph 	CEPH support for the Bareos Storage daemon
bareos-storage-ﬁfo 	FIFO support for the Bareos Storage backend
bareos-storage-glusterfs 	GlusterFS support for the Bareos Storage daemon
bareos-storage-python-plugin 	Python plugin for Bareos Storage daemon
bareos-storage-tape 	Tape support for the Bareos Storage daemon
bareos-tools 	Bareos CLI tools (bcopy, bextract, bls, bregex, bwild)
bareos-traymonitor 	Bareos Tray Monitor (QT)
bareos-vadp-dumper 	VADP Dumper - vStorage APIs for Data Protection Dumper program
bareos-vmware-plugin 	Bareos VMware plugin
bareos-vmware-vix-disklib 	VMware vix disklib distributable libraries
bareos-webui 	Bareos Web User Interface


Not all packages (especially optional backends and plugins) are available on all platforms. For details, see Packages for the diﬀerent Linux platforms.

Additionally, packages containing debug information are available. These are named diﬀerently depending on the distribution (bareos-debuginfo or bareos-dbg or …).

Not all packages are required to run Bareos.

    For the Bareos Director, the package bareos-director and one of bareos-database-mysql , bareos-database-postgresql or bareos-database-sqlite3 are required (use bareos-database-sqlite3 only for testing).
    For the Bareos Storage Daemon, the package bareos-storage is required. If you plan to connect tape drives to the storage director, also install the package bareos-storage-tape . This is kept separately, because it has additional dependencies for tape tools.
    On a client, only the package bareos-filedaemon is required. If you run it on a workstation, the packages bareos-traymonitor gives the user information about running backups.
    On a Backup Administration system you need to install at least bareos-bconsole to have an interactive console to the Bareos Director.

#
1.5 Bareos Conﬁguration

In order for Bareos to understand your system, what clients you want backed up and how, you must create a number of conﬁguration ﬁles containing resources (or objects).

TODO: add overview picture

#
1.6 Conventions Used in this Document

Bareos is in a state of evolution, and as a consequence, this manual will not always agree with the code. If an item in this manual is preceded by an asterisk (*), it indicates that the particular feature is not implemented. If it is preceded by a plus sign (+), it indicates that the feature may be partially implemented.

If you are reading this manual as supplied in a released version of the software, the above paragraph holds true. If you are reading the online version of the manual, http://www.bareos.org, please bear in mind that this version describes the current version in development that may contain features not in the released version. Just the same, it generally lags behind the code a bit.

The source of this document is available at https://github.com/bareos/bareos-docs. As with the rest of the Bareos project, you are welcome to participate and improve it.

#
1.7 Quick Start

To get Bareos up and running quickly, the author recommends that you ﬁrst scan the Terminology section below, then quickly review the next chapter entitled The Current State of Bareos, then the Installing Bareos, the Getting Started with Bareos, which will give you a quick overview of getting Bareos running. After which, you should proceed to the chapter How to Conﬁgure Bareos, and ﬁnally the chapter on Running Bareos.

#
1.8 Terminology

Administrator
    The person or persons responsible for administrating the Bareos system.
Backup
    The term Backup refers to a Bareos Job that saves ﬁles.
Bootstrap File
    The bootstrap ﬁle is an ASCII ﬁle containing a compact form of commands that allow Bareos or the stand-alone ﬁle extraction utility (bextract) to restore the contents of one or more Volumes, for example, the current state of a system just backed up. With a bootstrap ﬁle, Bareos can restore your system without a Catalog. You can create a bootstrap ﬁle from a Catalog to extract any ﬁle or ﬁles you wish.
Catalog
    The Catalog is used to store summary information about the Jobs, Clients, and Files that were backed up and on what Volume or Volumes. The information saved in the Catalog permits the administrator or user to determine what jobs were run, their status as well as the important characteristics of each ﬁle that was backed up, and most importantly, it permits you to choose what ﬁles to restore. The Catalog is an online resource, but does not contain the data for the ﬁles backed up. Most of the information stored in the catalog is also stored on the backup volumes (i.e. tapes). Of course, the tapes will also have a copy of the ﬁle data in addition to the File Attributes (see below).

    The catalog feature is one part of Bareos that distinguishes it from simple backup and archive programs such as dump and tar.
Client
    In Bareos’s terminology, the word Client refers to the machine being backed up, and it is synonymous with the File services or File daemon, and quite often, it is referred to it as the FD. A Client is deﬁned in a conﬁguration ﬁle resource.
Console
    The program that interfaces to the Director allowing the user or system administrator to control Bareos.
Daemon
    Unix terminology for a program that is always present in the background to carry out a designated task. On Windows systems, as well as some Unix systems, daemons are called Services.
Directive
    The term directive is used to refer to a statement or a record within a Resource in a conﬁguration ﬁle that deﬁnes one speciﬁc setting. For example, the Name directive deﬁnes the name of the Resource.
Director
    The main Bareos server daemon that schedules and directs all Bareos operations. Occasionally, the project refers to the Director as DIR.
Diﬀerential
    A backup that includes all ﬁles changed since the last Full save started. Note, other backup programs may deﬁne this diﬀerently.
File Attributes
    The File Attributes are all the information necessary about a ﬁle to identify it and all its properties such as size, creation date, modiﬁcation date, permissions, etc. Normally, the attributes are handled entirely by Bareos so that the user never needs to be concerned about them. The attributes do not include the ﬁle’s data.
File daemon
    The daemon running on the client computer to be backed up. This is also referred to as the File services, and sometimes as the Client services or the FD.

FileSet
    A FileSet is a Resource contained in a conﬁguration ﬁle that deﬁnes the ﬁles to be backed up. It consists of a list of included ﬁles or directories, a list of excluded ﬁles, and how the ﬁle is to be stored (compression, encryption, signatures). For more details, see the FileSet Resource in the Director chapter of this document.
Incremental
    A backup that includes all ﬁles changed since the last Full, Diﬀerential, or Incremental backup started. It is normally speciﬁed on the Level directive within the Job resource deﬁnition, or in a Schedule resource.

Job
    A Bareos Job is a conﬁguration resource that deﬁnes the work that Bareos must perform to backup or restore a particular Client. It consists of the Type (backup, restore, verify, etc), the Level (full, diﬀerential, incremental, etc.), the FileSet, and Storage the ﬁles are to be backed up (Storage device, Media Pool). For more details, see the Job Resource in the Director chapter of this document.
Monitor
    The program that interfaces to all the daemons allowing the user or system administrator to monitor Bareos status.
Resource
    A resource is a part of a conﬁguration ﬁle that deﬁnes a speciﬁc unit of information that is available to Bareos. It consists of several directives (individual conﬁguration statements). For example, the Job resource deﬁnes all the properties of a speciﬁc Job: name, schedule, Volume pool, backup type, backup level, ...
Restore
    A restore is a conﬁguration resource that describes the operation of recovering a ﬁle from backup media. It is the inverse of a save, except that in most cases, a restore will normally have a small set of ﬁles to restore, while normally a Save backs up all the ﬁles on the system. Of course, after a disk crash, Bareos can be called upon to do a full Restore of all ﬁles that were on the system.
Schedule
    A Schedule is a conﬁguration resource that deﬁnes when the Bareos Job will be scheduled for execution. To use the Schedule, the Job resource will refer to the name of the Schedule. For more details, see the Schedule Resource in the Director chapter of this document.
Service
    This is a program that remains permanently in memory awaiting instructions. In Unix environments, services are also known as daemons.
Storage Coordinates
    The information returned from the Storage Services that uniquely locates a ﬁle on a backup medium. It consists of two parts: one part pertains to each ﬁle saved, and the other part pertains to the whole Job. Normally, this information is saved in the Catalog so that the user doesn’t need speciﬁc knowledge of the Storage Coordinates. The Storage Coordinates include the File Attributes (see above) plus the unique location of the information on the backup Volume.
Storage Daemon
    The Storage daemon, sometimes referred to as the SD, is the code that writes the attributes and data to a storage Volume (usually a tape or disk).
Session
    Normally refers to the internal conversation between the File daemon and the Storage daemon. The File daemon opens a session with the Storage daemon to save a FileSet or to restore it. A session has a one-to-one correspondence to a Bareos Job (see above).
Verify
    A verify is a job that compares the current ﬁle attributes to the attributes that have previously been stored in the Bareos Catalog. This feature can be used for detecting changes to critical system ﬁles similar to what a ﬁle integrity checker like Tripwire does. One of the major advantages of using Bareos to do this is that on the machine you want protected such as a server, you can run just the File daemon, and the Director, Storage daemon, and Catalog reside on a diﬀerent machine. As a consequence, if your server is ever compromised, it is unlikely that your veriﬁcation database will be tampered with.

    Verify can also be used to check that the most recent Job data written to a Volume agrees with what is stored in the Catalog (i.e. it compares the ﬁle attributes), *or it can check the Volume contents against the original ﬁles on disk.
Retention Period
    There are various kinds of retention periods that Bareos recognizes. The most important are the File Retention Period, Job Retention Period, and the Volume Retention Period. Each of these retention periods applies to the time that speciﬁc records will be kept in the Catalog database. This should not be confused with the time that the data saved to a Volume is valid.

    The File Retention Period determines the time that File records are kept in the catalog database. This period is important for two reasons: the ﬁrst is that as long as File records remain in the database, you can ”browse” the database with a console program and restore any individual ﬁle. Once the File records are removed or pruned from the database, the individual ﬁles of a backup job can no longer be ”browsed”. The second reason for carefully choosing the File Retention Period is because the volume of the database File records use the most storage space in the database. As a consequence, you must ensure that regular ”pruning” of the database ﬁle records is done to keep your database from growing too large. (See the Console prune command for more details on this subject).
    
    The Job Retention Period is the length of time that Job records will be kept in the database. Note, all the File records are tied to the Job that saved those ﬁles. The File records can be purged leaving the Job records. In this case, information will be available about the jobs that ran, but not the details of the ﬁles that were backed up. Normally, when a Job record is purged, all its File records will also be purged.
    
    The Volume Retention Period is the minimum of time that a Volume will be kept before it is reused. Bareos will normally never overwrite a Volume that contains the only backup copy of a ﬁle. Under ideal conditions, the Catalog would retain entries for all ﬁles backed up for all current Volumes. Once a Volume is overwritten, the ﬁles that were backed up on that Volume are automatically removed from the Catalog. However, if there is a very large pool of Volumes or a Volume is never overwritten, the Catalog database may become enormous. To keep the Catalog to a manageable size, the backup information should be removed from the Catalog after the deﬁned File Retention Period. Bareos provides the mechanisms for the catalog to be automatically pruned according to the retention periods deﬁned.
Scan
    A Scan operation causes the contents of a Volume or a series of Volumes to be scanned. These Volumes with the information on which ﬁles they contain are restored to the Bareos Catalog. Once the information is restored to the Catalog, the ﬁles contained on those Volumes may be easily restored. This function is particularly useful if certain Volumes or Jobs have exceeded their retention period and have been pruned or purged from the Catalog. Scanning data from Volumes into the Catalog is done by using the bscan program. See the bscan section of the Bareos Utilities chapter of this manual for more details.
Volume
    A Volume is an archive unit, normally a tape or a named disk ﬁle where Bareos stores the data from one or more backup jobs. All Bareos Volumes have a software label written to the Volume by Bareos so that it identiﬁes what Volume it is really reading. (Normally there should be no confusion with disk ﬁles, but with tapes, it is easy to mount the wrong one.)

#
1.9 What Bareos is Not

Bareos is a backup, restore and veriﬁcation program and is not a complete disaster recovery system in itself, but it can be a key part of one if you plan carefully and follow the instructions included in the Disaster Recovery chapter of this manual.

#
1.10 Interactions Between the Bareos Services

The following block diagram shows the typical interactions between the Bareos Services for a backup job. Each block represents in general a separate process (normally a daemon). In general, the Director oversees the ﬂow of information. It also maintains the Catalog.

pict

#
1.11 The Current State of Bareos

#
1.11.1 What is Implemented

    Job Control
        Network backup/restore with centralized Director.
        Internal scheduler for automatic Job execution.
        Scheduling of multiple Jobs at the same time.
        You may run one Job at a time or multiple simultaneous Jobs (sometimes called multiplexing).
        Job sequencing using priorities.
        Console interface to the Director allowing complete control. Same GUIs are also available.
    Security
        Veriﬁcation of ﬁles previously cataloged, permitting a Tripwire like capability (system break-in detection).
        CRAM-MD5 password authentication between each component (daemon).
        Conﬁgurable TLS (SSL) communications encryption between each component.
        Conﬁgurable Data (on Volume) encryption on a Client by Client basis.
        Computation of MD5 or SHA1 signatures of the ﬁle data if requested.
    Restore Features
        Restore of one or more ﬁles selected interactively either for the current backup or a backup prior to a speciﬁed time and date.
        Listing and Restoration of ﬁles using stand-alone bls and bextract tool programs. Among other things, this permits extraction of ﬁles when Bareos and/or the catalog are not available. Note, the recommended way to restore ﬁles is using the restore command in the Console. These programs are designed for use as a last resort.
        Ability to restore the catalog database rapidly by using bootstrap ﬁles (previously saved).
        Ability to recreate the catalog database by scanning backup Volumes using the bscan program.
    SQL Catalog
        Catalog database facility for remembering Volumes, Pools, Jobs, and Files backed up.
        Support for MySQL, PostgreSQL, and SQLite Catalog databases.
        User extensible queries to the MySQL, PostgreSQL and SQLite databases.
    Advanced Volume and Pool Management
        Labeled Volumes, preventing accidental overwriting (at least by Bareos).
        Any number of Jobs and Clients can be backed up to a single Volume. That is, you can backup and restore Linux, Unix and Windows machines to the same Volume.
        Multi-volume saves. When a Volume is full, Bareos automatically requests the next Volume and continues the backup.
        Pool and Volume library management providing Volume ﬂexibility (e.g. monthly, weekly, daily Volume sets, Volume sets segregated by Client, ...).
        Machine independent Volume data format. Linux, Solaris, and Windows clients can all be backed up to the same Volume if desired.
        The Volume data format is upwards compatible so that old Volumes can always be read.
        A ﬂexible message handler including routing of messages from any daemon back to the Director and automatic email reporting.
        Data spooling to disk during backup with subsequent write to tape from the spooled disk ﬁles. This prevents tape ”shoe shine” during Incremental/Diﬀerential backups.
    Advanced Support for most Storage Devices
        Autochanger support using a simple shell interface that can interface to virtually any autoloader program. A script for mtx is provided.
        Support for autochanger barcodes – automatic tape labeling from barcodes.
        Automatic support for multiple autochanger magazines either using barcodes or by reading the tapes.
        Support for multiple drive autochangers.
        Raw device backup/restore. Restore must be to the same device.
        All Volume blocks contain a data checksum.
        Migration support – move data from one Pool to another or one Volume to another.
    Multi-Operating System Support
        Programmed to handle arbitrarily long ﬁlenames and messages.
        Compression on a ﬁle by ﬁle basis done by the Client program if requested before network transit.
        Saves and restores POSIX ACLs and Extended Attributes on most OSes if enabled.
        Access control lists for Consoles that permit restricting user access to only their data.
        Support for save/restore of ﬁles larger than 2GB.
        Support ANSI and IBM tape labels.
        Support for Unicode ﬁlenames (e.g. Chinese) on Win32 machines
        Consistent backup of open ﬁles on Win32 systems using Volume Shadow Copy (VSS).
        Support for path/ﬁlename lengths of up to 64K on Win32 machines (unlimited on Unix/Linux machines).
    Miscellaneous
        Multi-threaded implementation.
        A comprehensive and extensible conﬁguration ﬁle for each daemon.

#
1.11.2 Advantages Over Other Backup Programs

    Since there is a client for each machine, you can backup and restore clients of any type ensuring that all attributes of ﬁles are properly saved and restored.
    It is also possible to backup clients without any client software by using NFS or CIFS. However, if possible, we recommend running a Client File daemon on each machine to be backed up.
    Bareos handles multi-volume backups.
    A full comprehensive SQL standard database of all ﬁles backed up. This permits online viewing of ﬁles saved on any particular Volume.
    Automatic pruning of the database (removal of old records) thus simplifying database administration.
    Any SQL database engine can be used making Bareos very ﬂexible. Drivers currently exist for MySQL, PostgreSQL, and SQLite.
    The modular but integrated design makes Bareos very scalable.
    Since Bareos uses client ﬁle servers, any database or other application can be properly shutdown by Bareos using the native tools of the system, backed up, then restarted (all within a Bareos Job).
    Bareos has a built-in Job scheduler.
    The Volume format is documented and there are simple C programs to read/write it.
    Bareos uses well deﬁned (IANA registered) TCP/IP ports – no rpcs, no shared memory.
    Bareos installation and conﬁguration is relatively simple compared to other comparable products.
    Aside from several GUI administrative interfaces, Bareos has a comprehensive shell administrative interface, which allows the administrator to use tools such as ssh to administrate any part of Bareos from anywhere.

#
1.11.3 Current Implementation Restrictions

    It is possible to conﬁgure the Bareos Director to use multiple Catalogs. However, this is neither adviced, nor supported. Multiple catalogs require more management because in general you must know what catalog contains what data, e.g. currently, all Pools are deﬁned in each catalog.
    Bareos can generally restore any backup made from one client to any other client. However, if the architecture is signiﬁcantly diﬀerent (i.e. 32 bit architecture to 64 bit or Win32 to Unix), some restrictions may apply (e.g. Solaris door ﬁles do not exist on other Unix/Linux machines; there are reports that Zlib compression written with 64 bit machines does not always read correctly on a 32 bit machine).

#
1.11.4 Design Limitations or Restrictions

    Names (resource names, volume names, and such) deﬁned in Bareos conﬁguration ﬁles are limited to a ﬁxed number of characters. Currently the limit is deﬁned as 127 characters. Note, this does not apply to ﬁlenames, which may be arbitrarily long.
    Command line input to some of the stand alone tools – e.g. btape, bconsole is restricted to several hundred characters maximum. Normally, this is not a restriction, except in the case of listing multiple Volume names for programs such as bscan. To avoid this command line length restriction, please use a .bsr ﬁle to specify the Volume names.
    Bareos conﬁguration ﬁles for each of the components can be any length. However, the length of an individual line is limited to 500 characters after which it is truncated. If you need lines longer than 500 characters for directives such as ACLs where they permit a list of names are character strings simply specify multiple short lines repeating the directive on each line but with diﬀerent list values.

#
1.11.5 Items to Note

    Bareos’s Diﬀerential and Incremental normal backups are based on time stamps. Consequently, if you move ﬁles into an existing directory or move a whole directory into the backup ﬁleset after a Full backup, those ﬁles will probably not be backed up by an Incremental save because they will have old dates. This problem is corrected by using Accurate mode backups or by explicitly updating the date/time stamp on all moved ﬁles.
    In non Accurate mode, ﬁles deleted after a Full save will be included in a restoration. This is typical for most similar backup programs. To avoid this, use Accurate mode backup.

#
Chapter 2
Installing Bareos

If you are like me, you want to get Bareos running immediately to get a feel for it, then later you want to go back and read about all the details. This chapter attempts to accomplish just that: get you going quickly without all the details.

Bareos comes prepackaged for a number of Linux distributions. So the easiest way to get to a running Bareos installation, is to use a platform where prepacked Bareos packages are available. Additional information can be found in the chapter Operating Systems.

If Bareos is available as a package, only 5 steps are required to get to a running Bareos System:

    Decide about the Bareos release to use
    Decide about the Database Backend
    Install the Bareos Software Packages
    Prepare Bareos database
    Start the daemons

This will start a very basic Bareos installation which will regularly backup a directory to disk. In order to ﬁt it to your needs, you’ll have to adapt the conﬁguration and might want to backup other clients. #
2.1 Decide about the Bareos release to use

    http://download.bareos.org/bareos/release/latest/

You’ll ﬁnd Bareos binary package repositories at http://download.bareos.org/. The latest stable released version is available at http://download.bareos.org/bareos/release/latest/.

The public key to verify the repository is also in repository directory (Release.key for Debian based distributions, repodata/repomd.xml.key for RPM based distributions).

Section Install the Bareos Software Packages describes how to add the software repository to your system.

#
2.2 Decide about the Database Backend

Next you have to decide, what database backend you want to use. Bareos supports following database backends:

    PostgreSQL by package bareos-database-postgresql
    MySQL by package bareos-database-mysql
    Sqlite by package bareos-database-sqlite3
    Please note! The Sqlite backend is only intended for testing, not for productive use.

The PostgreSQL backend is the default. However, the MySQL backend is also supported, while the Sqlite backend is intended for testing purposes only.

The Bareos database packages have there dependencies only to the database client packages, therefore the database itself must be installed manually.

#
2.3 Install the Bareos Software Packages

You will have to install the package bareos and the database backend package (bareos-database-* ) you want to use. The corresponding database should already be installed and running, see Decide about the Database Backend.

If you do not explicitly choose a database backend, your operating system installer will choose one for you. The default should be PostgreSQL, but depending on your operating system and the already installed packages, this may diﬀer.

The package bareos is only a meta package, that contains dependencies to the main components of Bareos, see Bareos Packages. If you want to setup a distributed environment (like one Director, separate database server, multiple Storage daemons) you have to choose the corresponding Bareos packages to install on each hosts instead of just installing the bareos package.

#
2.3.1 Install on RedHat based Linux Distributions

RHEL≥7, CentOS≥7, Fedora

Bareos Version >= 15.2.0 requires the Jansson library package. On RHEL 7 it is available through the RHEL Server Optional channel. On CentOS 7 and Fedora is it included on the main repository.


#
# define parameter
#

DIST=RHEL_7
# or
# DIST=Fedora_22
# DIST=CentOS_7

DATABASE=postgresql
# or
# DATABASE=mysql

# add the Bareos repository
URL=http://download.bareos.org/bareos/release/latest/$DIST
wget -O /etc/yum.repos.d/bareos.repo $URL/bareos.repo

# install Bareos packages
yum install bareos bareos-database-$DATABASE


Commands 2.1: Bareos installation on RHEL ≥ 7 / CentOS ≥ 7 / Fedora

RHEL 6, CentOS 6

Bareos Version >= 15.2.0 requires the Jansson library package. This package is available on EPEL 6. Make sure, it is available on your system.


#
# define parameter
#

DIST=RHEL_6
# DIST=CentOS_6

DATABASE=postgresql
# or
# DATABASE=mysql

# add the Bareos repository
URL=http://download.bareos.org/bareos/release/latest/$DIST
wget -O /etc/yum.repos.d/bareos.repo $URL/bareos.repo

# install Bareos packages
yum install bareos bareos-database-$DATABASE


Commands 2.2: Bareos installation on RHEL ≥ 6 / CentOS ≥ 6

RHEL 5, CentOS 5

yum in RHEL 5/CentOS 5 has slightly diﬀerent behaviour as far as dependency resolving is concerned: it sometimes install a dependent package after the one that has the dependency deﬁned. To make sure that it works, install the desired Bareos database backend package ﬁrst in a separate step:


#
# define parameter
#

DIST=RHEL_5
# or
# DIST=CentOS_5

DATABASE=postgresql
# or
# DATABASE=mysql

# add the Bareos repository
URL=http://download.bareos.org/bareos/release/latest/$DIST
wget -O /etc/yum.repos.d/bareos.repo $URL/bareos.repo

# install Bareos packages
yum install bareos-database-$DATABASE
yum install bareos


Commands 2.3: Bareos installation on RHEL 5 / CentOS 5

#
2.3.2 Install on SUSE based Linux Distributions

SUSE Linux Enterprise Server (SLES), openSUSE


#
# define parameter
#

DIST=SLE_12
# or
# DIST=SLE_11_SP4
# DIST=SLE_11_SP3
# DIST=openSUSE_Leap_42.1
# DIST=openSUSE_13.2
# DIST=openSUSE_13.1

DATABASE=postgresql
# or
# DATABASE=mysql

# add the Bareos repository
URL=http://download.bareos.org/bareos/release/latest/$DIST
zypper addrepo --refresh $URL/bareos.repo

# install Bareos packages
zypper install bareos bareos-database-$DATABASE


Commands 2.4: Bareos installation on SLES / openSUSE

#
2.3.3 Install on Debian based Linux Distributions

Debian / Ubuntu

Bareos Version >= 15.2.0 requires the Jansson library package. On Ubuntu is it available in Ubuntu Universe. In Debian, is it included in the main repository.


#
# define parameter
#

DIST=Debian_8.0
# or
# DIST=Debian_7.0
# DIST=xUbuntu_14.04
# DIST=xUbuntu_12.04

DATABASE=postgresql
# or
# DATABASE=mysql

URL=http://download.bareos.org/bareos/release/latest/$DIST/

# add the Bareos repository
printf "deb $URL /\n" > /etc/apt/sources.list.d/bareos.list

# add package key
wget -q $URL/Release.key -O- | apt-key add -

# install Bareos packages
apt-get update
apt-get install bareos bareos-database-$DATABASE


Commands 2.5: Bareos installation on Debian / Ubuntu

If you prefer using the versions of Bareos directly integrated into the distributions, please note that there are some diﬀerences, see Limitations of the Debian.org/Ubuntu Universe version of Bareos.

#
2.3.4 Install on Univention Corporate Server

Bareos oﬀers additional functionality and integration into an Univention Corporate Server environment. Please follow the intructions in Univention Corporate Server.

If you are not interested in this additional functionality, the commands described in Install on Debian based Linux Distributions will also work for Univention Corporate Servers.

#
2.4 Prepare Bareos database

We assume that you have already your database installed and basically running. Currently the database backends PostgreSQL and MySQL are recommended. The Sqlite database backend is only intended for testing purposes.

The easiest way to set up a database is using an system account that have passwordless local access to the database. Often this is the user root for MySQL and the user postgres for PostgreSQL.

For details, see chapter Catalog Maintenance.

#
2.4.1 Debian based Linux Distributions

Since Bareos Version >= 14.2.0 the Debian (and Ubuntu) based packages support the dbconfig-common mechanism to create and update the Bareos database.

Follow the instructions during install to conﬁgure it according to your needs.

pict pict

If you decide not to use dbconfig-common (selecting <_No>_ on the initial dialog), follow the instructions for Other Platforms.

The selectable database backends depend on the bareos-database-* packages installed.

For details see dbconﬁg-common (Debian).

#
2.4.2 Other Platforms

PostgreSQL

If your are using PostgreSQL and your PostgreSQL administration user is postgres (default), use following commands:


su postgres -c /usr/lib/bareos/scripts/create_bareos_database
su postgres -c /usr/lib/bareos/scripts/make_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges


Commands 2.6: Setup Bareos catalog with PostgreSQL

MySQL/MariaDB

Make sure, that root has direct access to the local MySQL server. Check if the command mysql connects to the database without deﬁning the password. This is the default on RedHat and SUSE distributions. On other systems (Debian, Ubuntu), create the ﬁle ~/.my.cnf with your authentication informations:


[client]
host=localhost
user=root
password=YourPasswordForAccessingMysqlAsRoot


Conﬁguration 2.7: MySQL credentials ﬁle .my.cnf

It is recommended, to secure the Bareos database connection with a password. See Catalog Maintenance – MySQL about how to archieve this. For testing, using a password-less MySQL connection is probable okay. Setup the Bareos database tables by following commands:


/usr/lib/bareos/scripts/create_bareos_database
/usr/lib/bareos/scripts/make_bareos_tables
/usr/lib/bareos/scripts/grant_bareos_privileges


Commands 2.8: Setup Bareos catalog with MySQL

As some Bareos updates require a database schema update, therefore the ﬁle /root/.my.cnf might also be useful in the future.

#
2.5 Start the daemons


service bareos-dir start
service bareos-sd start
service bareos-fd start


Commands 2.9: Start the Bareos Daemons

You will eventually have to allow access to the ports 9101-9103, used by Bareos.

Now you should be able to access the director using the bconsole.

When you want to use the bareos-webui, please refer to the chapter Installing Bareos Webui.

#
Chapter 3
Installing Bareos Webui

This chapter addresses the installation process of the Bareos Webui.

Since Version >= 15.2.0 bareos-webui is part of the Bareos project and available for a number of platforms.

pict
#
3.1 System Requirements

    A working Bareos environment, Bareos >= 15.2.2, including JSON API mode, see jansson.
    A Bareos platform, where bareos-webui packages are provided.
    An Apache 2.x Webserver with mod-rewrite, mod-php5 and mod-setenv
    PHP >= 5.3.3
    Zend Framework 2.2.x or later. Note: Unfortunately, not all distributions oﬀer a Zend Framework 2 package. The following list shows where to get the Zend Framework 2 package.
        RHEL, CentOS
            https://fedoraproject.org/wiki/EPEL
            https://apps.fedoraproject.org/packages/php-ZendFramework2
        Fedora
            https://apps.fedoraproject.org/packages/php-ZendFramework2
        SUSE, Debian, Ubuntu
            http://download.bareos.org/bareos

#
3.2 Installation

#
3.2.1 Adding the Bareos Repository

If not already done, add the Bareos repository that is matching your Linux distribution. Please have a look at the chapter Install the Bareos Software Packages for more information on how to achieve this.

#
3.2.2 Install the bareos-webui package

After adding the repository simply install the bareos-webui package via your package manager.

    RHEL, CentOS and Fedora


    yum install bareos-webui


    or


    dnf install bareos-webui


    SUSE Linux Enterprise Server (SLES), openSUSE


    zypper install bareos-webui


    Debian, Ubuntu


    apt-get install bareos-webui


#
3.2.3 Conﬁguration of restricted consoles and proﬁle resources

You can have multiple consoles with diﬀerent names and passwords, sort of like multiple users, each with diﬀerent privileges. As a default, these consoles can do absolutely nothing – no commands whatsoever. You give them privileges or rather access to commands and resources by specifying access control lists (ACLs) in the director’s console resource. The ACLs are speciﬁed by a directive followed by a list of access names.

It is required to add at least one restricted named console in your director conﬁguration (bareos-dir.conf) for bareos-webui. The restricted named consoles, conﬁgured in your bareos-dir.conf, are used for authentication and access control. The name and password directives of the restricted consoles are the credentials you have to provide during authentication to the webui as username and password.

The bareos-webui package provides a default console and proﬁle conﬁguration under /etc/bareos/bareos-dir.d/, which have to be included at the bottom of your /etc/bareos/bareos-dir.conf and edited to your needs.


echo "@/etc/bareos/bareos-dir.d/webui-consoles.conf" >> /etc/bareos/bareos-dir.conf
echo "@/etc/bareos/bareos-dir.d/webui-profiles.conf" >> /etc/bareos/bareos-dir.conf


Commands 3.1: add webui-consoles and webui-proﬁles to the Bareos Director conﬁguration


#
# Restricted console used by bareos-webui
#
Console {
  Name = user1
  Password = "CHANGEME"
  Profile = webui
}


Conﬁguration 3.2: webui-consoles.conf

For more details about the console resource conﬁguration, please have a look at the chapter Console Resource.


#
# bareos-webui default profile resource
#
Profile {
  Name = webui
  CommandACL = status, messages, show, version, run, rerun, cancel, .api, .bvfs_*, list, llist, use, restore, .jobs, .filesets, .clients
  Job ACL = *all*
  Schedule ACL = *all*
  Catalog ACL = *all*
  Pool ACL = *all*
  Storage ACL = *all*
  Client ACL = *all*
  FileSet ACL = *all*
  Where ACL = *all*
}


Conﬁguration 3.3: webui-proﬁles.conf

For more details about proﬁle resource conﬁguration in bareos, please have a look at the chapter Proﬁle Resource.

Please note! Do not forget to reload your new director conﬁguration.

#
3.2.4 Conﬁgure your Apache Webserver

If you have installed from package, a default conﬁguration is provided, please see /etc/apache2/conf.d/bareos-webui.conf, /etc/httpd/conf.d/bareos-webui.conf or /etc/apache2/available-conf/bareos-webui.conf.

The required Apache modules, setenv, rewrite and php are enabled via package postinstall script. You simply need to restart your apache webserver manually.

#
3.2.5 Conﬁgure your /etc/bareos-webui/directors.ini

Conﬁgure your directors in /etc/bareos-webui/directors.ini to match your settings, which you have chosen in the previous steps.

The conﬁguration ﬁle /etc/bareos-webui/directors.ini should look similar to this:


;
; Bareos WebUI Configuration
; File: /etc/bareos-webui/directors.ini
;

;
; Section localhost-dir
;
[localhost-dir]

; Enable or disable section. Possible values are "yes" or "no", the default is "yes".
enabled = "yes"

; Fill in the IP-Address or FQDN of you director.
diraddress = "localhost"

; Default value is 9101
dirport = 9101

;
; Section remote-dir
;
[remote-dir]
enabled = "no"
diraddress = "hostname"
dirport = 9101
;tls_verify_peer = false
;server_can_do_tls = false
;server_requires_tls = false
;client_can_do_tls = false
;client_requires_tls = false
;ca_file = ""
;cert_file = ""
;cert_file_passphrase = ""
;allowed_cns = ""


Conﬁguration 3.4: Bareos-webui directors.ini

You can add as many directors as you want.

Now you are able to login by calling http://HOSTNAME/bareos-webui in your browser of choice. Your login credentials are deﬁned in your Bareos Director Console conﬁguration.

#
3.3 Additional information

#
3.3.1 SELinux

To install bareos-webui on a system with SELinux enabled, the following additional steps have to be performed.

    Allow HTTPD scripts and modules to connect to the network


    setsebool -P httpd_can_network_connect on


#
3.3.2 NGINX

If you prefer to use bareos-webui on Nginx with php5-fpm instead of Apache, a basic working conﬁguration could look like this:


server {

        listen       9100;
        server_name  bareos;
        root         /var/www/bareos-webui/public;
    
        location / {
                index index.php;
                try_files $uri $uri/ /index.php?$query_string;
        }
    
        location ~ .php$ {
    
                include snippets/fastcgi-php.conf;
    
                # With php5-cgi alone pass the PHP
                # scripts to FastCGI server
                # listening on 127.0.0.1:9000
    
                # fastcgi_pass 127.0.0.1:9000;
    
                # With php5-fpm:
    
                fastcgi_pass unix:/var/run/php5-fpm.sock;
    
        }

}


Conﬁguration 3.5: bareos-webui on nginx

#
3.3.3 Installation from source

For information about installing from source, please refer to https://github.com/bareos/bareos-webui/blob/master/doc/INSTALL.md.

#
Chapter 4
Updating Bareos

In most cases, a Bareos update is simply done by a package update of the distribution. Please remind, that Bareos Director and Bareos Storage Daemon must always have the same version. The version of the File Daemon may diﬀer, see chapter about backward compatibility. #
4.1 Updating the database scheme

Sometimes improvements in Bareos make it neccessary to update the database scheme.

Please note! If the Bareos catalog database does not have the current schema, the Bareos Director refuses to start.

Detailed information can then be found in the log ﬁle /var/log/bareos/bareos.log.

Take a look into the Release Notes to see which Bareos updates do require a database scheme update.

#
4.1.1 Debian based Linux Distributions

Since Bareos Version >= 14.2.0 the Debian (and Ubuntu) based packages support the dbconfig-common mechanism to create and update the Bareos database. If this is properly conﬁgured, the database schema will be automatically adapted by the Bareos packages.

Please note! When using the PostgreSQL backend and updating to Bareos < 14.2.3, it is necessary to manually grant database permissions, normally by using


root@linux:~#
 su − postgres −c /usr/lib/bareos/scripts/grant_bareos_privileges


For details see dbconﬁg-common (Debian).

If you disabled the usage of dbconfig-common , follow the instructions for Other Platforms.

#
4.1.2 Other Platforms

This has to be done as database administrator. On most platforms Bareos knows only about the credentials to access the Bareos database, but not about the database administrator to modify the database schema.

The task of updating the database schema is done by the script /usr/lib/bareos/scripts/update_bareos_tables.

However, this script requires administration access to the database. Depending on your distribution and your database, this requires diﬀerent preparations. More details can be found in chapter Catalog Maintenance.

Please note! If you’re updating to Bareos <= 13.2.3 and have conﬁgured the Bareos database during install using Bareos environment variables (db_name, db_user or db_password, see Catalog Maintenance), make sure to have these variables deﬁned in the same way when calling the update and grant scripts. Newer versions of Bareos read these variables from the Director conﬁguration ﬁle /etc/bareos/bareos-dir.conf. However, make sure that the user running the database scripts has read access to this ﬁle (or set the environment variables). The postgres user normally does not have the required permissions.

PostgreSQL

If your are using PostgreSQL and your PostgreSQL administrator is postgres (default), use following commands:


su postgres -c /usr/lib/bareos/scripts/update_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges


Commands 4.1: Update PostgreSQL database schema

The grant_bareos_privileges command is required, if new databases tables are introduced. It does not hurt to run it multiple times.

After this, restart the Bareos Director and verify it starts without problems.

MySQL/MariaDB

Make sure, that root has direct access to the local MySQL server. Check if the command mysql without parameter connects to the database. If not, you may be required to adapt your local MySQL conﬁg ﬁle ~/.my.cnf. It should look similar to this:


[client]
host=localhost
user=root
password=YourPasswordForAccessingMysqlAsRoot


Conﬁguration 4.2: MySQL credentials ﬁle .my.cnf

If you are able to connect via the mysql to the database, run the following script from the Unix prompt:


/usr/lib/bareos/scripts/update_bareos_tables


Commands 4.3: Update MySQL database schema

Currently on MySQL is it not neccessary to run grant_bareos_privileges, because access to the database is already given using wildcards.

After this, restart the Bareos Director and verify it starts without problems.

#
Chapter 5
Getting Started with Bareos
#
5.1 Understanding Jobs and Schedules

In order to make Bareos as ﬂexible as possible, the directions given to Bareos are speciﬁed in several pieces. The main instruction is the job resource, which deﬁnes a job. A backup job generally consists of a FileSet, a Client, a Schedule for one or several levels or times of backups, a Pool, as well as additional instructions. Another way of looking at it is the FileSet is what to backup; the Client is who to backup; the Schedule deﬁnes when, and the Pool deﬁnes where (i.e. what Volume).

Typically one FileSet/Client combination will have one corresponding job. Most of the directives, such as FileSets, Pools, Schedules, can be mixed and matched among the jobs. So you might have two diﬀerent Job deﬁnitions (resources) backing up diﬀerent servers using the same Schedule, the same Fileset (backing up the same directories on two machines) and maybe even the same Pools. The Schedule will deﬁne what type of backup will run when (e.g. Full on Monday, incremental the rest of the week), and when more than one job uses the same schedule, the job priority determines which actually runs ﬁrst. If you have a lot of jobs, you might want to use JobDefs, where you can set defaults for the jobs, which can then be changed in the job resource, but this saves rewriting the identical parameters for each job. In addition to the FileSets you want to back up, you should also have a job that backs up your catalog.

Finally, be aware that in addition to the backup jobs there are restore, verify, and admin jobs, which have diﬀerent requirements.

#
5.2 Understanding Pools, Volumes and Labels

If you have been using a program such as tar to backup your system, Pools, Volumes, and labeling may be a bit confusing at ﬁrst. A Volume is a single physical tape (or possibly a single ﬁle) on which Bareos will write your backup data. Pools group together Volumes so that a backup is not restricted to the length of a single Volume (tape). Consequently, rather than explicitly naming Volumes in your Job, you specify a Pool, and Bareos will select the next appendable Volume from the Pool and request you to mount it.

Although the basic Pool options are speciﬁed in the Director’s Pool resource, the real Pool is maintained in the Bareos Catalog. It contains information taken from the Pool resource (bareos-dir.conf) as well as information on all the Volumes that have been added to the Pool. Adding Volumes to a Pool is usually done manually with the Console program using the label command.

For each Volume, Bareos maintains a fair amount of catalog information such as the ﬁrst write date/time, the last write date/time, the number of ﬁles on the Volume, the number of bytes on the Volume, the number of Mounts, etc.

Before Bareos will read or write a Volume, the physical Volume must have a Bareos software label so that Bareos can be sure the correct Volume is mounted. This is usually done using the label command in the Console program.

The steps for creating a Pool, adding Volumes to it, and writing software labels to the Volumes, may seem tedious at ﬁrst, but in fact, they are quite simple to do, and they allow you to use multiple Volumes (rather than being limited to the size of a single tape). Pools also give you signiﬁcant ﬂexibility in your backup process. For example, you can have a ”Daily” Pool of Volumes for Incremental backups and a ”Weekly” Pool of Volumes for Full backups. By specifying the appropriate Pool in the daily and weekly backup Jobs, you thereby insure that no daily Job ever writes to a Volume in the Weekly Pool and vice versa, and Bareos will tell you what tape is needed and when.

For more on Pools, see the Pool Resource section of the Director Conﬁguration chapter, or simply read on, and we will come back to this subject later.

#
5.3 Setting Up Bareos Conﬁguration Files

On Unix, Bareos conﬁguration ﬁles are usualy location in the /etc/bareos/ directory and are named accordingly to the programs that use it: bareos-fd.conf, bareos-sd.conf, bareos-dir.conf, bconsole.conf, etc.

For information about Windows conﬁguration ﬁles, see the Windows chapter.

#
5.3.1 Conﬁguring the Console Program

The Console program is used by the administrator to interact with the Director and to manually start/stop Jobs or to obtain Job status information.

The Console conﬁguration ﬁle is named bconsole.conf.

Normally, for ﬁrst time users, no change is needed to these ﬁles. Reasonable defaults are set.

Further details are in the Console conﬁguration chapter.

#
5.3.2 Conﬁguring the File daemon

The File daemon is a program that runs on each (Client) machine. At the request of the Director, ﬁnds the ﬁles to be backed up and sends them (their data) to the Storage daemon.

The File daemon conﬁguration ﬁle is named bareos-fd.conf. Normally, for ﬁrst time users, no change is needed to this ﬁle. Reasonable defaults are set. However, if you are going to back up more than one machine, you will need to install the File daemon with a unique conﬁguration ﬁle on each machine to be backed up. The information about each File daemon must appear in the Director’s conﬁguration ﬁle.

Further details are in the File daemon conﬁguration chapter.

#
5.3.3 Conﬁguring the Director

The Director is the central control program for all the other daemons. It schedules and monitors all jobs to be backed up.

The Director conﬁguration ﬁle is named bareos-dir.conf.

In general, the only change you must make is modify the FileSet resource so that the Include conﬁguration directive contains at least one line with a valid name of a directory (or ﬁle) to be saved.

You may also want to change the email address for notiﬁcation from the default root to your email address.

Finally, if you have multiple systems to be backed up, you will need a separate File daemon or Client speciﬁcation for each system, specifying its name, address, and password. We have found that giving your daemons the same name as your system but post ﬁxed with -fd helps a lot in debugging. That is, if your system name is foobaz, you would give the File daemon the name foobaz-fd. For the Director, you should use foobaz-dir, and for the storage daemon, you might use foobaz-sd. Each of your Bareos components must have a unique name. If you make them all the same, aside from the fact that you will not know what daemon is sending what message, if they share the same working directory, the daemons temporary ﬁle names will not be unique, and you will get many strange failures.

More information is in the Director Conﬁguration chapter.

#
5.3.4 Conﬁguring the Storage daemon

The Storage daemon is responsible, at the Director’s request, for accepting data from a File daemon and placing it on Storage media, or in the case of a restore request, to ﬁnd the data and send it to the File daemon.

The Storage daemon’s conﬁguration ﬁle is named bareos-sd.conf. The default conﬁguration comes with backup to disk only, so the Archive device points to a directory in which the Volumes will be created as ﬁles when you label the Volume. These Storage resource name and Media Type must be the same as the corresponding ones in the Director’s conﬁguration ﬁle bareos-dir.conf.

Further information is in the Storage daemon conﬁguration chapter.

#
5.4 Testing your Conﬁguration Files

You can test if your conﬁguration ﬁle is syntactically correct by running the appropriate daemon with the -t option. The daemon will process the conﬁguration ﬁle and print any error messages then terminate.


bareos-dir -t -c /etc/bareos/bareos-dir.conf
bareos-fd -t -c /etc/bareos/bareos-fd.conf
bareos-sd -t -c /etc/bareos/bareos-sd.conf
bconsole -t -c /etc/bareos/bconsole.conf
bareos-tray-monitor -t -c /etc/bareos/tray-monitor.conf


Commands 5.1: Testing Conﬁguration Files

#
5.5 Testing Compatibility with Your Tape Drive

Before spending a lot of time on Bareos only to ﬁnd that it doesn’t work with your tape drive, please read the Tape Drive section. If you have a modern standard SCSI tape drive on a Linux or Solaris, most likely it will work, but better test than be sorry. For FreeBSD (and probably other xBSD ﬂavors), reading the above mentioned tape testing chapter is a must.

#
5.6 Running Bareos

Probably the most important part of running Bareos is being able to restore ﬁles. If you haven’t tried recovering ﬁles at least once, when you actually have to do it, you will be under a lot more pressure, and prone to make errors, than if you had already tried it once.

To get a good idea how to use Bareos in a short time, we strongly recommend that you follow the example in the Tutorial chapter of this manual where you will get detailed instructions on how to run Bareos.

#
Chapter 6
Tutorial

This chapter will guide you through running Bareos. To do so, we assume you have installed Bareos. However, we assume that you have not changed the .conf ﬁles. If you have modiﬁed the .conf ﬁles, please go back and uninstall Bareos, then reinstall it, but do not make any changes. The examples in this chapter use the default conﬁguration ﬁles, and will write the volumes to disk in your /var/lib/bareos/storage/ directory, in addition, the data backed up will be the source directory where you built Bareos. As a consequence, you can run all the Bareos daemons for these tests as non-root. Please note, in production, your File daemon(s) must run as root. See the Security chapter for more information on this subject.

The general ﬂow of running Bareos is:

    Start the Database (if using MySQL or PostgreSQL)
    Start the Bareos Daemons
    Start the Console program to interact with the Director
    Run a job
    When the Volume ﬁlls, unmount the Volume, if it is a tape, label a new one, and continue running. In this chapter, we will write only to disk ﬁles so you won’t need to worry about tapes for the moment.
    Test recovering some ﬁles from the Volume just written to ensure the backup is good and that you know how to recover. Better test before disaster strikes
    Add a second client.

Each of these steps is described in more detail below. #
6.1 Installing Bareos

For installing Bareos, follow the instructions from the Installing Bareos chapter.

#
6.2 Starting the Database

If you are using MySQL or PostgreSQL as the Bareos database, you should start it before you attempt to run a job to avoid getting error messages from Bareos when it starts. If you are using SQLite you need do nothing. SQLite is automatically started by Bareos.

#
6.3 Starting the Daemons

Assuming you have installed the packages, to start the three daemons, from your installation directory, simply enter:
service bareos-dir start  
service bareos-sd start  
service bareos-fd start

The bareos script starts the Storage daemon, the File daemon, and the Director daemon, which all normally run as daemons in the background. If you are using the autostart feature of Bareos, your daemons will either be automatically started on reboot, or you can control them individually with the ﬁles bareos-dir, bareos-fd, and bareos-sd, which are usually located in /etc/init.d, though the actual location is system dependent. Some distributions may do this diﬀerently.

Note, on Windows, currently only the File daemon is ported, and it must be started diﬀerently. Please see the Windows Version of Bareos chapter of this manual.

The rpm packages conﬁgure the daemons to run as user=root and group=bareos. The rpm installation also creates the group bareos if it does not exist on the system. Any users that you add to the group bareos will have access to ﬁles created by the daemons. To disable or alter this behavior edit the daemon startup scripts:

    /etc/init.d/bareos-dir
    /etc/init.d/bareos-sd
    /etc/init.d/bareos-fd

and then restart as noted above.

The installation chapter of this manual explains how you can install scripts that will automatically restart the daemons when the system starts.

#
6.4 Using the Director to Query and Start Jobs

To communicate with the director and to query the state of Bareos or run jobs, from the top level directory, simply enter:

bconsole

For simplicity, here we will describe only the bconsole program, also there is also a graphical interface called BAT.

The bconsole runs the Bareos Console program, which connects to the Director daemon. Since Bareos is a network program, you can run the Console program anywhere on your network. Most frequently, however, one runs it on the same machine as the Director. Normally, the Console program will print something similar to the following:


root@linux:~#
bconsole
Connecting to Director bareos:9101
Enter a period to cancel a command.
*


Commands 6.1: bconsole

the asterisk is the console command prompt.

Type help to see a list of available commands:


* help
  Command       Description
  =======       ===========
  add           Add media to a pool
  autodisplay   Autodisplay console messages
  automount     Automount after label
  cancel        Cancel a job
  create        Create DB Pool from resource
  delete        Delete volume, pool or job
  disable       Disable a job
  enable        Enable a job
  estimate      Performs FileSet estimate, listing gives full listing
  exit          Terminate Bconsole session
  export        Export volumes from normal slots to import/export slots
  gui           Non−interactive gui mode
  help          Print help on specific command
  import        Import volumes from import/export slots to normal slots
  label         Label a tape
  list          List objects from catalog
  llist         Full or long list like list command
  messages      Display pending messages
  memory        Print current memory usage
  mount         Mount storage
  move          Move slots in an autochanger
  prune         Prune expired records from catalog
  purge         Purge records from catalog
  quit          Terminate Bconsole session
  query         Query catalog
  restore       Restore files
  relabel       Relabel a tape
  release       Release storage
  reload        Reload conf file
  rerun         Rerun a job
  run           Run a job
  status        Report status
  setbandwidth  Sets bandwidth
  setdebug      Sets debug level
  setip         Sets new client address −− if authorized
  show          Show resource records
  sqlquery      Use SQL to query catalog
  time          Print current time
  trace         Turn on/off trace to file
  unmount       Unmount storage
  umount        Umount − for old−time Unix guys, see unmount
  update        Update volume, pool or stats
  use           Use specific catalog
  var           Does variable expansion
  version       Print Director version
  wait          Wait until no jobs are running


bconsole 6.2: help

Details of the console program’s commands are explained in the Bareos Console chapter.

#
6.5 Running a Job

At this point, we assume you have done the following:

    Installed Bareos
    Started the Database
    Prepared the database for Bareos
    Started Bareos Director, Storage Daemon and File Daemon
    Invoked the Console program with bconsole

Furthermore, we assume for the moment you are using the default conﬁguration ﬁles.

At this point, enter the show filesets and you should get something similar this:


* show filesets
...
FileSet {
  Name = ”SelfTest”
  Include {
    Options {
      Signature = MD5
    }
    File = ”/usr/sbin”
  }
}

FileSet {
  Name = ”Catalog”
  Include {
    Options {
      Signature = MD5
    }
    File = ”/var/lib/bareos/bareos.sql”
    File = ”/etc/bareos”
  }
}
...


bconsole 6.3: show ﬁlesets

One of the FileSets is the pre-deﬁned SelfTest FileSet that will backup the /usr/sbin directory. For testing purposes, we have chosen a directory of moderate size (about 30 Megabytes) and complexity without being too big. The FileSet Catalog is used for backing up Bareos’s catalog and is not of interest to us for the moment. You can change what is backed up by editing bareos-dir.conf and changing the File = line in the FileSet resource.

Now is the time to run your ﬁrst backup job. We are going to backup your Bareos source directory to a File Volume in your /var/lib/bareos/storage/ directory just to show you how easy it is. Now enter:


* status dir
bareos−dir Version: 13.2.0 (09 April 2013) x86_64−pc−linux−gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23−May−13 13:17. Jobs: run=0, running=0 mode=0
 Heap: heap=270,336 smbytes=59,285 max_bytes=59,285 bufs=239 max_bufs=239

Scheduled Jobs:
Level          Type     Pri  Scheduled          Name               Volume
===================================================================================
Incremental    Backup    10  23−May−13 23:05    BackupClient1      testvol
Full           Backup    11  23−May−13 23:10    BackupCatalog      testvol
====

Running Jobs:
Console connected at 23−May−13 13:34
No Jobs running.
====


bconsole 6.4: status dir

where the times and the Director’s name will be diﬀerent according to your setup. This shows that an Incremental job is scheduled to run for the Job BackupClient1 at 1:05am and that at 1:10, a BackupCatalog is scheduled to run. Note, you should probably change the name BackupClient1 to be the name of your machine, if not, when you add additional clients, it will be very confusing.

Now enter:


* status client
Automatically selected Client: bareos−fd
Connecting to Client bareos−fd at bareos:9102

bareos−fd Version: 13.2.0 (09 April 2013)  x86_64−pc−linux−gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23−May−13 13:17. Jobs: run=0 running=0.
 Heap: heap=135,168 smbytes=26,000 max_bytes=26,147 bufs=65 max_bufs=66
 Sizeof: boffset_t=8 size_t=8 debug=0 trace=0 bwlimit=0kB/s

Running Jobs:
Director connected at: 23−May−13 13:58
No Jobs running.
====


bconsole 6.5: status client

In this case, the client is named bareos-fd your name will be diﬀerent, but the line beginning with bareos-fd Version ... is printed by your File daemon, so we are now sure it is up and running.

Finally do the same for your Storage daemon with:


* status storage
Automatically selected Storage: File
Connecting to Storage daemon File at bareos:9103

bareos−sd Version: 13.2.0 (09 April 2013) x86_64−pc−linux−gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23−May−13 13:17. Jobs: run=0, running=0.
 Heap: heap=241,664 smbytes=28,574 max_bytes=88,969 bufs=73 max_bufs=74
 Sizes: boffset_t=8 size_t=8 int32_t=4 int64_t=8 mode=0 bwlimit=0kB/s

Running Jobs:
No Jobs running.
====

Device status:

Device ”FileStorage” (/var/lib/bareos/storage) is not open.
==
====

Used Volume status:
====

====


bconsole 6.6: status storage

You will notice that the default Storage daemon device is named File and that it will use device /var/lib/bareos/storage, which is not currently open.

Now, let’s actually run a job with:
run

you should get the following output:
Automatically selected Catalog: MyCatalog  
Using Catalog "MyCatalog"  
A job name must be specified.  
The defined Job resources are:  
     1: BackupClient1  
     2: BackupCatalog  
     3: RestoreFiles  
Select Job resource (1-3):

Here, Bareos has listed the three diﬀerent Jobs that you can run, and you should choose number 1 and type enter, at which point you will get:
Run Backup job  
JobName:  BackupClient1  
Level:    Incremental  
Client:   bareos-fd  
Format:   Native  
FileSet:  Full Set  
Pool:     File (From Job resource)  
NextPool: *None* (From unknown source)  
Storage:  File (From Job resource)  
When:     2013-05-23 14:50:04  
Priority: 10  
OK to run? (yes/mod/no):

At this point, take some time to look carefully at what is printed and understand it. It is asking you if it is OK to run a job named BackupClient1 with FileSet Full Set (we listed above) as an Incremental job on your Client (your client name will be diﬀerent), and to use Storage File and Pool Default, and ﬁnally, it wants to run it now (the current time should be displayed by your console).

Here we have the choice to run (yes), to modify one or more of the above parameters (mod), or to not run the job (no). Please enter yes, at which point you should immediately get the command prompt (an asterisk). If you wait a few seconds, then enter the command messages you will get back something like:

TODO: Replace bconsole output by current version of Bareos.
28-Apr-2003 14:22 bareos-dir: Last FULL backup time not found. Doing  
                  FULL backup.  
28-Apr-2003 14:22 bareos-dir: Start Backup JobId 1,  
                  Job=Client1.2003-04-28_14.22.33  
28-Apr-2003 14:22 bareos-sd: Job Client1.2003-04-28_14.22.33 waiting.  
                  Cannot find any appendable volumes.  
Please use the "label"  command to create a new Volume for:  
    Storage:      FileStorage  
    Media type:   File  
    Pool:         Default

The ﬁrst message, indicates that no previous Full backup was done, so Bareos is upgrading our Incremental job to a Full backup (this is normal). The second message indicates that the job started with JobId 1., and the third message tells us that Bareos cannot ﬁnd any Volumes in the Pool for writing the output. This is normal because we have not yet created (labeled) any Volumes. Bareos indicates to you all the details of the volume it needs.

At this point, the job is BLOCKED waiting for a Volume. You can check this if you want by doing a status dir. In order to continue, we must create a Volume that Bareos can write on. We do so with:
label

and Bareos will print:
The defined Storage resources are:  
     1: File  
Item 1 selected automatically.  
Enter new Volume name:

at which point, you should enter some name beginning with a letter and containing only letters and numbers (period, hyphen, and underscore) are also permitted. For example, enter TestVolume001, and you should get back:
Defined Pools:  
     1: Default  
Item 1 selected automatically.  
Connecting to Storage daemon File at bareos:8103 ...  
Sending label command for Volume "TestVolume001" Slot 0 ...  
3000 OK label. Volume=TestVolume001 Device=/var/lib/bareos/storage  
Catalog record for Volume "TestVolume002", Slot 0  successfully created.  
Requesting mount FileStorage ...  
3001 OK mount. Device=/var/lib/bareos/storage

Finally, enter messages and you should get something like:
28-Apr-2003 14:30 bareos-sd: Wrote label to prelabeled Volume  
   "TestVolume001" on device /var/lib/bareos/storage  
28-Apr-2003 14:30 rufus-dir: Bareos 1.30 (28Apr03): 28-Apr-2003 14:30  
JobId:                  1  
Job:                    BackupClient1.2003-04-28_14.22.33  
FileSet:                Full Set  
Backup Level:           Full  
Client:                 bareos-fd  
Start time:             28-Apr-2003 14:22  
End time:               28-Apr-2003 14:30  
Files Written:          1,444  
Bytes Written:          38,988,877  
Rate:                   81.2 KB/s  
Software Compression:   None  
Volume names(s):        TestVolume001  
Volume Session Id:      1  
Volume Session Time:    1051531381  
Last Volume Bytes:      39,072,359  
FD termination status:  OK  
SD termination status:  OK  
Termination:            Backup OK  
28-Apr-2003 14:30 rufus-dir: Begin pruning Jobs.  
28-Apr-2003 14:30 rufus-dir: No Jobs found to prune.  
28-Apr-2003 14:30 rufus-dir: Begin pruning Files.  
28-Apr-2003 14:30 rufus-dir: No Files found to prune.  
28-Apr-2003 14:30 rufus-dir: End auto prune.

If you don’t see the output immediately, you can keep entering messages until the job terminates.

Instead of typing messages multiple times, you can also ask bconsole to wait, until a speciﬁc job is ﬁnished:
wait jobid=1

or just wait, which waits for all running jobs to ﬁnish.

Another useful command is autodisplay on. With autodisplay activated, messages will automatically be displayed as soon as they are ready.

If you do an ls -l of your /var/lib/bareos/storage directory, you will see that you have the following item:
-rw-r-----    1 bareos bareos   39072153 Apr 28 14:30 TestVolume001

This is the ﬁle Volume that you just wrote and it contains all the data of the job just run. If you run additional jobs, they will be appended to this Volume unless you specify otherwise.

You might ask yourself if you have to label all the Volumes that Bareos is going to use. The answer for disk Volumes, like the one we used, is no. It is possible to have Bareos automatically label volumes. For tape Volumes, you will most likely have to label each of the Volumes you want to use.

If you would like to stop here, you can simply enter quit in the Console program.

If you would like to try restoring the ﬁles that you just backed up, read the following section.

#
6.6 Restoring Your Files

If you have run the default conﬁguration and run the job as demonstrated above, you can restore the backed up ﬁles in the Console program by entering:
restore all

where you will get:
First you select one or more JobIds that contain files  
to be restored. You will be presented several methods  
of specifying the JobIds. Then you will be allowed to  
select which files from those JobIds are to be restored.  

To select the JobIds, you have the following choices:  
     1: List last 20 Jobs run  
     2: List Jobs where a given File is saved  
     3: Enter list of comma separated JobIds to select  
     4: Enter SQL list command  
     5: Select the most recent backup for a client  
     6: Select backup for a client before a specified time  
     7: Enter a list of files to restore  
     8: Enter a list of files to restore before a specified time  
     9: Find the JobIds of the most recent backup for a client  
    10: Find the JobIds for a backup for a client before a specified time  
    11: Enter a list of directories to restore for found JobIds  
    12: Select full restore to a specified Job date  
    13: Cancel  
Select item:  (1-13):

As you can see, there are a number of options, but for the current demonstration, please enter 5 to do a restore of the last backup you did, and you will get the following output:
Automatically selected Client: bareos-fd  
The defined FileSet resources are:  
     1: Catalog  
     2: Full Set  
Select FileSet resource (1-2):

As you can see, Bareos knows what client you have, and since there was only one, it selected it automatically. Select 2, because you want to restore ﬁles from the ﬁle set.
+-------+-------+----------+------------+---------------------+---------------+  
| jobid | level | jobfiles | jobbytes   | starttime           | volumename    |  
+-------+-------+----------+------------+---------------------+---------------+  
|     1 | F     |      166 | 19,069,526 | 2013-05-05 23:05:02 | TestVolume001 |  
+-------+-------+----------+------------+---------------------+---------------+  
You have selected the following JobIds: 1  

Building directory tree for JobId(s) 1 ...  +++++++++++++++++++++++++++++++++++++++++  
165 files inserted into the tree and marked for extraction.  

You are now entering file selection mode where you add (mark) and  
remove (unmark) files to be restored. No files are initially added, unless  
you used the "all" keyword on the command line.  
Enter "done" to leave this mode.  

cwd is: /  
$

where I have truncated the listing on the right side to make it more readable.

Then Bareos produced a listing containing all the jobs that form the current backup, in this case, there is only one, and the Storage daemon was also automatically chosen. Bareos then took all the ﬁles that were in Job number 1 and entered them into a directory tree (a sort of in memory representation of your ﬁlesystem). At this point, you can use the cd and ls or dir commands to walk up and down the directory tree and view what ﬁles will be restored. For example, if I enter cd /usr/sbin and then enter dir I will get a listing of all the ﬁles in the Bareos source directory. On your system, the path might be somewhat diﬀerent. For more information on this, please refer to the Restore Command Chapter of this manual for more details.

To exit this mode, simply enter:
done

and you will get the following output:
Bootstrap records written to  
   /home/user/bareos/testbin/working/restore.bsr  
The restore job will require the following Volumes:  

   TestVolume001  
1444 files selected to restore.  
Run Restore job  
JobName:         RestoreFiles  
Bootstrap:      /home/user/bareos/testbin/working/restore.bsr  
Where:          /tmp/bareos-restores  
Replace:        always  
FileSet:        Full Set  
Backup Client:  rufus-fd  
Restore Client: rufus-fd  
Storage:        File  
JobId:          *None*  
When:           2005-04-28 14:53:54  
OK to run? (yes/mod/no):  
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.1.bsr  

The job will require the following  
   Volume(s)                 Storage(s)                SD Device(s)  
===========================================================================  

    TestVolume001             File                      FileStorage  

Volumes marked with "*" are online.  


166 files selected to be restored.  

Run Restore job  
JobName:         RestoreFiles  
Bootstrap:       /var/lib/bareos/bareos-dir.restore.1.bsr  
Where:           /tmp/bareos-restores  
Replace:         Always  
FileSet:         Full Set  
Backup Client:   bareos-fd  
Restore Client:  bareos-fd  
Format:          Native  
Storage:         File  
When:            2013-05-23 15:56:53  
Catalog:         MyCatalog  
Priority:        10  
Plugin Options:  *None*  
OK to run? (yes/mod/no):

If you answer yes your ﬁles will be restored to /tmp/bareos-restores. If you want to restore the ﬁles to their original locations, you must use the mod option and explicitly set Where: to nothing (or to /). We recommend you go ahead and answer yes and after a brief moment, enter messages, at which point you should get a listing of all the ﬁles that were restored as well as a summary of the job that looks similar to this:
23-May 15:24 bareos-dir JobId 2: Start Restore Job RestoreFiles.2013-05-23_15.24.01_10  
23-May 15:24 bareos-dir JobId 2: Using Device "FileStorage" to read.  
23-May 15:24 bareos-sd JobId 2: Ready to read from volume "TestVolume001" on device "FileStorage" (/var/lib/bareos/storage).  
23-May 15:24 bareos-sd JobId 2: Forward spacing Volume "TestVolume001" to file:block 0:194.  
23-May 15:58 bareos-dir JobId 3: Bareos bareos-dir 13.2.0 (09Apr13):  
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 6.0 (squeeze)  
  JobId:                  2  
  Job:                    RestoreFiles.2013-05-23_15.58.48_11  
  Restore Client:         bareos-fd  
  Start time:             23-May-2013 15:58:50  
  End time:               23-May-2013 15:58:52  
  Files Expected:         166  
  Files Restored:         166  
  Bytes Restored:         19,069,526  
  Rate:                   9534.8 KB/s  
  FD Errors:              0  
  FD termination status:  OK  
  SD termination status:  OK  
  Termination:            Restore OK

After exiting the Console program, you can examine the ﬁles in /tmp/bareos-restores, which will contain a small directory tree with all the ﬁles. Be sure to clean up at the end with:
rm -rf /tmp/bareos-restore

#
6.7 Quitting the Console Program

Simply enter the command quit.

#
6.8 Adding a Second Client

Changes on the Client

If you have gotten the example shown above to work on your system, you may be ready to add a second Client (File daemon). That is you have a second machine that you would like backed up. The only part you need installed on the other machine is the bareos-ﬁledaemon.

This packages installs also its conﬁguration ﬁle /etc/bareos/bareos-fd.conf and sets its hostname + -fd as FileDaemon name. However, the client does not known the Bareos Director, so this information must be given manually.

Lets assume, your second client has the hostname client2 and this name is resolvable by DNS from the client and from the Bareos Director.

Specify the Bareos Director in the File Daemon conﬁguration ﬁle /etc/bareos/bareos-fd.conf:
...  
#  
# List Directors who are permitted to contact this File daemon  
#  
Director {  
  Name = bareos-dir  
  Password = "PASSWORD" # this is the passwort which you need to use within the client resource.  
}  
...

The password is also generated at installation time, but you are free to change it. Just keep in mind, it must be identical on the client and the Bareos Director.

Restart the Bareos File Daemon by
root@client2:~ # service bareos-fd restart

Changes on the Server (Bareos Director)

Then you need to make some additions to your Director’s conﬁguration ﬁle to deﬁne the new File Daemon (Client).

Starting from our original example which should be installed on your system, you should add the following lines (essentially copies of the existing data but with the names changed) to your Director’s conﬁguration ﬁle bareos-dir.conf.

Add following section makes the new client know to the Bareos Director. Add this section to the existing Bareos Director conﬁguration ﬁle /etc/bareos/bareos-dir.conf:
Client {  
  Name = client2-fd  
  Address = client2             # the name has to be resolvable through DNS. If this is not possible,  
                                # you can work with IP addresses  
  Password = "PASSWORD"         # password for FileDaemon which has to be the same like the password  
                                # in the director resource of the bareos-fd.conf on the backup client.  
                                # Copy it the the client to this line.  
}

Using this, the client is known to the Bareos Director. Additional you must specify, what to do with this client. Therefore we specify a Job, which mostly takes its settings from the existing DefaultJob:
Job {  
  JobDefs = "DefaultJob"  
  Name    = "client2"  
  Client  = "client2-fd"  
}

Check if the conﬁguration ﬁle is correct by
root@bareos:~ # bareos-dir -t -c /etc/bareos/bareos-dir.conf

If everything is okay, reload the Bareos Director:
root@bareos:~ # service bareos-dir reload

Now the setup for the second client should be ready.

To test the functionality, you can run a backup and restore job like in the example with the ﬁrst attached FileDaemon. However, there is an even earier way to check if a connection to a File Daemon is working. This is the estimate listing command in bconsole. Using this, the Bareos Director immediately connects to a client and returns all ﬁles that will be included in the next backup.

Start bconsole and follow the instructions:
* estimate listing

The result should appear immediately.

To make this a real production installation, you will possibly want to use diﬀerent Pool, or a diﬀerent schedule. It is up to you to customize.

#
6.9 When The Tape Fills

If you have scheduled your job, typically nightly, there will come a time when the tape ﬁlls up and Bareos cannot continue. In this case, Bareos will send you a message similar to the following:
bareos-sd: block.c:337 === Write error errno=28: ERR=No space left on device

This indicates that Bareos got a write error because the tape is full. Bareos will then search the Pool speciﬁed for your Job looking for an appendable volume. In the best of all cases, you will have properly set your Retention Periods and you will have all your tapes marked to be Recycled, and Bareos will automatically recycle the tapes in your pool requesting and overwriting old Volumes. For more information on recycling, please see the Recycling chapter of this manual. If you ﬁnd that your Volumes were not properly recycled (usually because of a conﬁguration error), please see the Manually Recycling Volumes section of the Recycling chapter.

If like me, you have a very large set of Volumes and you label them with the date the Volume was ﬁrst writing, or you have not set up your Retention periods, Bareos will not ﬁnd a tape in the pool, and it will send you a message similar to the following:
bareos-sd: Job usersave.2002-09-19.10:50:48 waiting. Cannot find any  
          appendable volumes.  
Please use the "label"  command to create a new Volume for:  
    Storage:      SDT-10000  
    Media type:   DDS-4  
    Pool:         Default

Until you create a new Volume, this message will be repeated an hour later, then two hours later, and so on doubling the interval each time up to a maximum interval of one day.

The obvious question at this point is: What do I do now?

The answer is simple: ﬁrst, using the Console program, close the tape drive using the unmount command. If you only have a single drive, it will be automatically selected, otherwise, make sure you release the one speciﬁed on the message (in this case STD-10000).

Next, you remove the tape from the drive and insert a new blank tape. Note, on some older tape drives, you may need to write an end of ﬁle mark (mt  -f  /dev/nst0  weof) to prevent the drive from running away when Bareos attempts to read the label.

Finally, you use the label command in the Console to write a label to the new Volume. The label command will contact the Storage daemon to write the software label, if it is successful, it will add the new Volume to the Pool, then issue a mount command to the Storage daemon. See the previous sections of this chapter for more details on labeling tapes.

The result is that Bareos will continue the previous Job writing the backup to the new Volume.

If you have a Pool of volumes and Bareos is cycling through them, instead of the above message ”Cannot ﬁnd any appendable volumes.”, Bareos may ask you to mount a speciﬁc volume. In that case, you should attempt to do just that. If you do not have the volume any more (for any of a number of reasons), you can simply mount another volume from the same Pool, providing it is appendable, and Bareos will use it. You can use the list volumes command in the console program to determine which volumes are appendable and which are not.

If like me, you have your Volume retention periods set correctly, but you have no more free Volumes, you can relabel and reuse a Volume as follows:

    Do a list volumes in the Console and select the oldest Volume for relabeling.
    If you have setup your Retention periods correctly, the Volume should have VolStatus Purged.
    If the VolStatus is not set to Purged, you will need to purge the database of Jobs that are written on that Volume. Do so by using the command purge jobs volume in the Console. If you have multiple Pools, you will be prompted for the Pool then enter the VolumeName (or MediaId) when requested.
    Then simply use the relabel command to relabel the Volume.

To manually relabel the Volume use the following additional steps:

    To delete the Volume from the catalog use the delete volume command in the Console and select the VolumeName (or MediaId) to be deleted.
    Use the unmount command in the Console to unmount the old tape.
    Physically relabel the old Volume that you deleted so that it can be reused.
    Insert the old Volume in the tape drive.
    From a command line do: mt  -f  /dev/st0  rewind and mt  -f  /dev/st0  weof, where you need to use the proper tape drive name for your system in place of /dev/st0.
    Use the label command in the Console to write a new Bareos label on your tape.
    Use the mount command in the Console if it is not automatically done, so that Bareos starts using your newly labeled tape.

#
6.10 Other Useful Console Commands

status dir
    Print a status of all running jobs and jobs scheduled in the next 24 hours.
status
    The console program will prompt you to select a daemon type, then will request the daemon’s status.
status jobid=nn
    Print a status of JobId nn if it is running. The Storage daemon is contacted and requested to print a current status of the job as well.
list pools
    List the pools deﬁned in the Catalog (normally only Default is used).
list media
    Lists all the media deﬁned in the Catalog.
list jobs
    Lists all jobs in the Catalog that have run.
list jobid=nn
    Lists JobId nn from the Catalog.
list jobtotals
    Lists totals for all jobs in the Catalog.
list ﬁles jobid=nn
    List the ﬁles that were saved for JobId nn.
list jobmedia
    List the media information for each Job run.
messages
    Prints any messages that have been directed to the console.
unmount storage=storage-name
    Unmounts the drive associated with the storage device with the name storage-name if the drive is not currently being used. This command is used if you wish Bareos to free the drive so that you can use it to label a tape.
mount storage=storage-name
    Causes the drive associated with the storage device to be mounted again. When Bareos reaches the end of a volume and requests you to mount a new volume, you must issue this command after you have placed the new volume in the drive. In eﬀect, it is the signal needed by Bareos to know to start reading or writing the new volume.
quit
    Exit or quit the console program.

Most of the commands given above, with the exception of list, will prompt you for the necessary arguments if you simply enter the command name.

#
6.11 Patience When Starting Daemons or Mounting Blank Tapes

When you start the Bareos daemons, the Storage daemon attempts to open all deﬁned storage devices and verify the currently mounted Volume (if conﬁgured). Until all the storage devices are veriﬁed, the Storage daemon will not accept connections from the Console program. If a tape was previously used, it will be rewound, and on some devices this can take several minutes. As a consequence, you may need to have a bit of patience when ﬁrst contacting the Storage daemon after starting the daemons. If you can see your tape drive, once the lights stop ﬂashing, the drive will be ready to be used.

The same considerations apply if you have just mounted a blank tape in a drive such as an HP DLT. It can take a minute or two before the drive properly recognizes that the tape is blank. If you attempt to mount the tape with the Console program during this recognition period, it is quite possible that you will hang your SCSI driver (at least on my Red Hat Linux system). As a consequence, you are again urged to have patience when inserting blank tapes. Let the device settle down before attempting to access it.

#
6.12 Diﬃculties Connecting from the FD to the SD

If you are having diﬃculties getting one or more of your File daemons to connect to the Storage daemon, it is most likely because you have not used a fully qualiﬁed domain name on the Address directive in the Director’s Storage resource. That is the resolver on the File daemon’s machine (not on the Director’s) must be able to resolve the name you supply into an IP address. An example of an address that is guaranteed not to work: localhost. An example that may work: megalon. An example that is more likely to work: magalon.mydomain.com. On Win32 if you don’t have a good resolver (often true on older Windows systems), you might try using an IP address in place of a name.

If your address is correct, then make sure that no other program is using the port 9103 on the Storage daemon’s machine. The Bacula project has reserved these port numbers by IANA, therefore they should only be used by Bacula and its replacements like Bareos. However, apparently some HP printers do use these port numbers. A netstat -a on the Storage daemon’s machine can determine who is using the 9103 port (used for FD to SD communications in Bareos).

#
6.13 Creating a Pool

Creating the Pool is automatically done when Bareos starts, so if you understand Pools, you can skip to the next section.

When you run a job, one of the things that Bareos must know is what Volumes to use to backup the FileSet. Instead of specifying a Volume (tape) directly, you specify which Pool of Volumes you want Bareos to consult when it wants a tape for writing backups. Bareos will select the ﬁrst available Volume from the Pool that is appropriate for the Storage device you have speciﬁed for the Job being run. When a volume has ﬁlled up with data, Bareos will change its VolStatus from Append to Full, and then Bareos will use the next volume and so on. If no appendable Volume exists in the Pool, the Director will attempt to recycle an old Volume, if there are still no appendable Volumes available, Bareos will send a message requesting the operator to create an appropriate Volume.

Bareos keeps track of the Pool name, the volumes contained in the Pool, and a number of attributes of each of those Volumes.

When Bareos starts, it ensures that all Pool resource deﬁnitions have been recorded in the catalog. You can verify this by entering:
list pools

to the console program, which should print something like the following:
*list pools  
Using default Catalog name=MySQL DB=bareos  
+--------+---------+---------+---------+----------+-------------+  
| PoolId | Name    | NumVols | MaxVols | PoolType | LabelFormat |  
+--------+---------+---------+---------+----------+-------------+  
| 1      | Default | 3       | 0       | Backup   | *           |  
| 2      | File    | 12      | 12      | Backup   | File        |  
+--------+---------+---------+---------+----------+-------------+  
*

If you attempt to create the same Pool name a second time, Bareos will print:
Error: Pool Default already exists.  
Once created, you may use the update command to  
modify many of the values in the Pool record.

#
6.14 Labeling Your Volumes

Bareos requires that each Volume contains a software label. There are several strategies for labeling volumes. The one I use is to label them as they are needed by Bareos using the console program. That is when Bareos needs a new Volume, and it does not ﬁnd one in the catalog, it will send me an email message requesting that I add Volumes to the Pool. I then use the label command in the Console program to label a new Volume and to deﬁne it in the Pool database, after which Bareos will begin writing on the new Volume. Alternatively, I can use the Console relabel command to relabel a Volume that is no longer used providing it has VolStatus Purged.

Another strategy is to label a set of volumes at the start, then use them as Bareos requests them. This is most often done if you are cycling through a set of tapes, for example using an autochanger. For more details on recycling, please see the Automatic Volume Recycling chapter of this manual.

If you run a Bareos job, and you have no labeled tapes in the Pool, Bareos will inform you, and you can create them ”on-the-ﬂy” so to speak. In my case, I label my tapes with the date, for example: DLT-18April02. See below for the details of using the label command.

Labeling Volumes with the Console Program

Labeling volumes is normally done by using the console program.

    bconsole
    label

If Bareos complains that you cannot label the tape because it is already labeled, simply unmount the tape using the unmount command in the console, then physically mount a blank tape and re-issue the label command.

Since the physical storage media is diﬀerent for each device, the label command will provide you with a list of the deﬁned Storage resources such as the following:
The defined Storage resources are:  
     1: File  
     2: 8mmDrive  
     3: DLTDrive  
     4: SDT-10000  
Select Storage resource (1-4):

At this point, you should have a blank tape in the drive corresponding to the Storage resource that you select.

It will then ask you for the Volume name.
Enter new Volume name:

If Bareos complains:
Media record for Volume xxxx already exists.

It means that the volume name xxxx that you entered already exists in the Media database. You can list all the deﬁned Media (Volumes) with the list media command. Note, the LastWritten column has been truncated for proper printing.
+---------------+---------+--------+----------------+-----/~/-+------------+-----+  
| VolumeName    | MediaTyp| VolStat| VolBytes       | LastWri | VolReten   | Recy|  
+---------------+---------+--------+----------------+---------+------------+-----+  
| DLTVol0002    | DLT8000 | Purged | 56,128,042,217 | 2001-10 | 31,536,000 |   0 |  
| DLT-07Oct2001 | DLT8000 | Full   | 56,172,030,586 | 2001-11 | 31,536,000 |   0 |  
| DLT-08Nov2001 | DLT8000 | Full   | 55,691,684,216 | 2001-12 | 31,536,000 |   0 |  
| DLT-01Dec2001 | DLT8000 | Full   | 55,162,215,866 | 2001-12 | 31,536,000 |   0 |  
| DLT-28Dec2001 | DLT8000 | Full   | 57,888,007,042 | 2002-01 | 31,536,000 |   0 |  
| DLT-20Jan2002 | DLT8000 | Full   | 57,003,507,308 | 2002-02 | 31,536,000 |   0 |  
| DLT-16Feb2002 | DLT8000 | Full   | 55,772,630,824 | 2002-03 | 31,536,000 |   0 |  
| DLT-12Mar2002 | DLT8000 | Full   | 50,666,320,453 | 1970-01 | 31,536,000 |   0 |  
| DLT-27Mar2002 | DLT8000 | Full   | 57,592,952,309 | 2002-04 | 31,536,000 |   0 |  
| DLT-15Apr2002 | DLT8000 | Full   | 57,190,864,185 | 2002-05 | 31,536,000 |   0 |  
| DLT-04May2002 | DLT8000 | Full   | 60,486,677,724 | 2002-05 | 31,536,000 |   0 |  
| DLT-26May02   | DLT8000 | Append |  1,336,699,620 | 2002-05 | 31,536,000 |   1 |  
+---------------+---------+--------+----------------+-----/~/-+------------+-----+

Once Bareos has veriﬁed that the volume does not already exist, it will prompt you for the name of the Pool in which the Volume (tape) is to be created. If there is only one Pool (Default), it will be automatically selected.

If the tape is successfully labeled, a Volume record will also be created in the Pool. That is the Volume name and all its other attributes will appear when you list the Pool. In addition, that Volume will be available for backup if the MediaType matches what is requested by the Storage daemon.

When you labeled the tape, you answered very few questions about it – principally the Volume name, and perhaps the Slot. However, a Volume record in the catalog database (internally known as a Media record) contains quite a few attributes. Most of these attributes will be ﬁlled in from the default values that were deﬁned in the Pool (i.e. the Pool holds most of the default attributes used when creating a Volume).

It is also possible to add media to the pool without physically labeling the Volumes. This can be done with the add command. For more information, please see the Bareos Console chapter.

#
Chapter 7
Critical Items to Implement Before Production

We recommend you take your time before implementing a production on a Bareos backup system since Bareos is a rather complex program, and if you make a mistake, you may suddenly ﬁnd that you cannot restore your ﬁles in case of a disaster. This is especially true if you have not previously used a major backup product.

If you follow the instructions in this chapter, you will have covered most of the major problems that can occur. It goes without saying that if you ever ﬁnd that we have left out an important point, please inform us, so that we can document it to the beneﬁt of everyone.

#
7.1 Critical Items

The following assumes that you have installed Bareos, you more or less understand it, you have at least worked through the tutorial or have equivalent experience, and that you have set up a basic production conﬁguration. If you haven’t done the above, please do so and then come back here. The following is a sort of checklist that points with perhaps a brief explanation of why you should do it. In most cases, you will ﬁnd the details elsewhere in the manual. The order is more or less the order you would use in setting up a production system (if you already are in production, use the checklist anyway).

    Test your tape drive for compatibility with Bareos by using the test command of the btape program.
    Test the end of tape handling of your tape drive by using the ﬁll command in the btape program.
    Do at least one restore of ﬁles. If you backup multiple OS types (Linux, Solaris, HP, MacOS, FreeBSD, Win32, ...), restore ﬁles from each system type. The Restoring Files chapter shows you how.
    Write a bootstrap ﬁle to a separate system for each backup job. See Write Bootstrap Dir Job directive and more details are available in the The Bootstrap File chapter. Also, the default bareos-dir.conf comes with a Write Bootstrap directive deﬁned. This allows you to recover the state of your system as of the last backup.
    Backup your catalog. An example of this is found in the default bareos-dir.conf ﬁle. The backup script is installed by default and should handle any database, though you may want to make your own local modiﬁcations. See also Backing Up Your Bareos Database for more information.
    Write a bootstrap ﬁle for the catalog. An example of this is found in the default bareos-dir.conf ﬁle. This will allow you to quickly restore your catalog in the event it is wiped out – otherwise it is many excruciating hours of work.
    Make a copy of the bareos-dir.conf, bareos-sd.conf, and bareos-fd.conf ﬁles that you are using on your server. Put it in a safe place (on another machine) as these ﬁles can be diﬃcult to reconstruct if your server dies.
    Bareos assumes all ﬁlenames are in UTF-8 format. This is important when saving the ﬁlenames to the catalog. For Win32 machine, Bareos will automatically convert from Unicode to UTF-8, but on Unix, Linux, *BSD, and MacOS X machines, you must explicitly ensure that your locale is set properly. Typically this means that the LANG environment variable must end in .UTF-8. A full example is en_US.UTF-8. The exact syntax may vary a bit from OS to OS, and exactly how you deﬁne it will also vary.
    
    On most modern Win32 machines, you can edit the conf ﬁles with notepad and choose output encoding UTF-8.

#
7.2 Recommended Items

Although these items may not be critical, they are recommended and will help you avoid problems.

    Read the Getting Started with Bareos chapter
    After installing and experimenting with Bareos, read and work carefully through the examples in the Tutorial chapter of this manual.
    Learn what each of the Bareos Programs does.
    Set up reasonable retention periods so that your catalog does not grow to be too big. See the following three chapters:
    Automatic Volume Recycling,
    Volume Management,
    Automated Disk Backup.

If you absolutely must implement a system where you write a diﬀerent tape each night and take it oﬀsite in the morning. We recommend that you do several things:

    Write a bootstrap ﬁle of your backed up data and a bootstrap ﬁle of your catalog backup to a external media like CDROM or USB stick, and take that with the tape. If this is not possible, try to write those ﬁles to another computer or oﬀsite computer, or send them as email to a friend. If none of that is possible, at least print the bootstrap ﬁles and take that oﬀsite with the tape. Having the bootstrap ﬁles will make recovery much easier.
    It is better not to force Bareos to load a particular tape each day. Instead, let Bareos choose the tape. If you need to know what tape to mount, you can print a list of recycled and appendable tapes daily, and select any tape from that list. Bareos may propose a particular tape for use that it considers optimal, but it will accept any valid tape from the correct pool.

Part II
Conﬁguration

#
Chapter 8
Customizing the Conﬁguration

Each Bareos component (Director, Client, Storage, Console) has its own conﬁguration containing a set of resource deﬁnitions. These resources are very similar from one service to another, but may contain diﬀerent directives (records) depending on the component. For example, in the Director conﬁguration, the Director Resource deﬁnes the name of the Director, a number of global Director parameters and his password. In the File daemon conﬁguration, the Director Resource speciﬁes which Directors are permitted to use the File daemon.

If you install all Bareos daemons (Director, Storage and File Daemon) onto one system, the Bareos package tries its best to generate a working conﬁguration as a basis for your individual conﬁguration.

The details of each resource and the directives permitted therein are described in the following chapters.

The following conﬁguration ﬁles must be present:

    Director Conﬁguration – to deﬁne the resources necessary for the Director. You deﬁne all the Clients and Storage daemons that you use in this conﬁguration ﬁle.
    Storage Daemon Conﬁguration – to deﬁne the resources to be used by each Storage daemon. Normally, you will have a single Storage daemon that controls your disk storage or tape drives. However, if you have tape drives on several machines, you will have at least one Storage daemon per machine.
    Client/File Daemon Conﬁguration – to deﬁne the resources for each client to be backed up. That is, you will have a separate Client resource ﬁle on each machine that runs a File daemon.
    Console Conﬁguration – to deﬁne the resources for the Console program (user interface to the Director). It deﬁnes which Directors are available so that you may interact with them.

#
8.1 Conﬁguration Path Layout

When a Bareos component starts, it reads its conﬁguration. In Bareos < 16.2.2 only conﬁguration ﬁles (which optionally can include other ﬁles) are supported. Since Bareos Version >= 16.2.2 also conﬁguration subdirectories are supported.

Naming

In this section, the following naming is used:

    $CONFIGDIR refers to the base conﬁguration directory. Bareos Linux packages use /etc/bareos/.
    A component is one of the following Bareos programs:
        bareos-dir
        bareos-sd
        bareos-fd
        bareos-traymonitor
        bconsole
        bat (only legacy conﬁg ﬁle: bat.conf)
        Bareos tools, like Volume Utility Commands and others.
    $COMPONENT refers to one of the listed components.

#
8.1.1 What conﬁguration will be used?

When starting a Bareos component, it will look for its conﬁguration. Bareos components allow the conﬁguration ﬁle/directory to be speciﬁed as a command line parameter -c $PATH.

    conﬁguration path parameter is not given (default)
        $CONFIGDIR/$COMPONENT.conf is a ﬁle
            the conﬁguration is read from the ﬁle $CONFIGDIR/$COMPONENT.conf
        $CONFIGDIR/$COMPONENT.d/ is a directory
            the conﬁguration is read from $CONFIGDIR/$COMPONENT.d/*/*.conf (subdirectory conﬁguration)
    conﬁguration path parameter is given (-c $PATH)
        $PATH is a ﬁle
            the conﬁguration is read from the ﬁle speciﬁed in $PATH
        $PATH is a directory
            the conﬁguration is read from $PATH/$COMPONENT.d/*/*.conf (subdirectory conﬁguration)

As the $CONFIGDIR diﬀers between platforms or is overwritten by the path parameter, the documentation will often refer to the conﬁguration without the leading path (e.g. $COMPONENT.d/*/*.conf instead of $CONFIGDIR/$COMPONENT.d/*/*.conf).

pict

When subdirectory conﬁguration is used, all ﬁles matching $PATH/$COMPONENT.d/*/*.conf will be read, see Subdirectory Conﬁguration Scheme.

Relation between Bareos components and conﬁguration

Bareos component 	

Conﬁguration File (default path on Unix)


Subdirectory Conﬁguration Scheme (default path on Unix) since Bareos >= 16.2.2


bareos-dir 	bareos-dir.conf 	bareos-dir.d
Director Conﬁguration 	(/etc/bareos/bareos-dir.conf) 	(/etc/bareos/bareos-dir.d/)

bareos-sd 	bareos-sd.conf 	bareos-sd.d
Storage Daemon Conﬁguration 	(/etc/bareos/bareos-sd.conf) 	(/etc/bareos/bareos-sd.d/)

bareos-fd 	bareos-fd.conf 	bareos-fd.d
Client/File Daemon Conﬁguration	(/etc/bareos/bareos-fd.conf) 	(/etc/bareos/bareos-fd.d/)

bconsole 	bconsole.conf 	bconsole.d
Console Conﬁguration 	(/etc/bareos/bconsole.conf) 	(/etc/bareos/bconsole.d/)

bareos-traymonitor 	tray-monitor.conf 	tray-monitor.d
Monitor Conﬁguration 	(/etc/bareos/tray-monitor.conf) 	(/etc/bareos/tray-monitor.d/)

bat 	bat.conf 	(not supported)
	(/etc/bareos/bat.conf) 	

Volume Utility Commands 	bareos-sd.conf 	bareos-sd.d
(use the bareos-sd conﬁguration) 	(/etc/bareos/bareos-sd.conf) 	(/etc/bareos/bareos-sd.d/)

#
8.1.2 Subdirectory Conﬁguration Scheme

If the subdirectory conﬁguration is used, instead of a single conﬁguration ﬁle, all ﬁles matching $COMPONENT.d/*/*.conf are read as a conﬁguration, see What conﬁguration will be used?.

Reason for the Subdirectory Conﬁguration Scheme

In Bareos < 16.2.2, Bareos uses one conﬁguration ﬁle per component.

Most larger Bareos environments split their conﬁguration into separate ﬁles, making it easier to manage the conﬁguration.

Also some extra packages (bareos-webui, plugins, ...) require a conﬁguration, which must be included into the Bareos Director or Bareos Storage Daemon conﬁguration. The subdirectory approach makes it easier to add or modify the conﬁguration resources of diﬀerent Bareos packages.

The Bareos conﬁgure command requires a conﬁguration directory structure, as provided by the subdirectory approach.

From Bareos Version >= 16.2.4 on, new installations will use conﬁguration subdirectories by default.

Resource ﬁle conventions

    Each conﬁguration resource has to use its own conﬁguration ﬁle.
    The path of a resource ﬁle is $COMPONENT.d/$RESOURCETYPE/$RESOURCENAME.conf.
    The name of the conﬁguration ﬁle is identical with the resource name:
        e.g.
            bareos-dir.d/director/bareos-dir.conf
            bareos-dir.d/pool/Full.conf
        Exceptions:
            The resource ﬁle bareos-fd.d/client/myself.conf always has the ﬁle name myself.conf, while the name is normally set to the hostname of the system.
    Example resource ﬁles:
        Additional packages can contain conﬁguration ﬁles that are automatically included. However, most additional conﬁguration resources require conﬁguration. When a resource ﬁle requires conﬁguration, it has to be included as an example ﬁle:
            $CONFIGDIR/$COMPONENT.d/$RESOURCE/$NAME.conf.example
            For example, the Bareos Webui entails one conﬁg resource and one conﬁg resource example for the Bareos Director:
                $CONFIGDIR/bareos-director.d/profile/webui-admin.conf
                $CONFIGDIR/bareos-director.d/console/admin.conf.example
    Disable/remove conﬁguration resource ﬁles:
        Normally you should not remove resources that are already in use (jobs, clients, ...). Instead you should disable them by adding the directive Enable = no. Otherwise you take the risk that orphaned entries are kept in the Bareos catalog. However, if a resource has not been used or all references have been cleared from the database, they can also be removed from the conﬁguration. Please note! If you want to remove a conﬁguration resource that is part of a Bareos package, replace the resource conﬁguration ﬁle by an empty ﬁle. This prevents the resource from reappearing in the course of a package update.

Using Subdirectories Conﬁguration Scheme

New installation

    The Subdirectories Conﬁguration Scheme is used by default from Bareos Version >= 16.2.4 onwards.
    They will be usable immediately after installing a Bareos component.
    If additional packages entail example conﬁguration ﬁles ($NAME.conf.example), copy them to $NAME. conf, modify it as required and reload or restart the component.

Updates from Bareos < 16.2.4

    When updating to a Bareos version containing the Subdirectories Conﬁguration, the existing conﬁguration will not be touched and is still the default conﬁguration.
        Please note! Problems can occur if you have implemented an own wildcard mechanism to load your conﬁguration from the same subdirectories as used by the new packages ($CONFIGDIR/ $COMPONENT.d/*/*.conf). In this case, newly installed conﬁguration resource ﬁles can alter your current conﬁguration by adding resources. Best create a copy of your conﬁguration directory before updating Bareos and modify your existing conﬁguration ﬁle to use that other directory.
    As long as the old conﬁguration ﬁle ($CONFIGDIR/$COMPONENT.conf) exists, it will be used.
    The correct way of migrating to the new conﬁguration scheme would be to split the conﬁguration ﬁle into resources, store them in the resource directories and then remove the original conﬁguration ﬁle.
        This requires eﬀort. TODO: It is planned to create a program that helps to migrate the settings, however, until now, it is not available.
        The easy way is:
            mkdir $CONFIGDIR/$COMPONENT.d/migrate && mv $CONFIGDIR/$COMPONENT. conf $CONFIGDIR/$COMPONENT.d/migrate
            Resources deﬁned in both, the new conﬁguration directory scheme and the old conﬁguration ﬁle, must be removed from one of the places, best from the old conﬁguration ﬁle, after verifying that the settings are identical with the new settings.

#
8.2 Conﬁguration File Format

A conﬁguration ﬁle consists of one or more resources (see Resource).

Bareos programs can work with

    all resources deﬁned in one conﬁguration ﬁle
    conﬁguration ﬁles that include other conﬁguration ﬁles (see Including other Conﬁguration Files)
    Subdirectory Conﬁguration Scheme, where each conﬁguration ﬁle contains exactly one resource deﬁnition

#
8.2.1 Character Sets

Bareos is designed to handle most character sets of the world, US ASCII, German, French, Chinese, ... However, it does this by encoding everything in UTF-8, and it expects all conﬁguration ﬁles (including those read on Win32 machines) to be in UTF-8 format. UTF-8 is typically the default on Linux machines, but not on all Unix machines, nor on Windows, so you must take some care to ensure that your locale is set properly before starting Bareos.

To ensure that Bareos conﬁguration ﬁles can be correctly read including foreign characters, the LANG environment variable must end in .UTF-8. A full example is en_US.UTF-8. The exact syntax may vary a bit from OS to OS, so that the way you have to deﬁne it will diﬀer from the example. On most newer Win32 machines you can use notepad to edit the conf ﬁles, then choose output encoding UTF-8.

Bareos assumes that all ﬁlenames are in UTF-8 format on Linux and Unix machines. On Win32 they are in Unicode (UTF-16) and will hence be automatically converted to UTF-8 format.

#
8.2.2 Comments

When reading a conﬁguration, blank lines are ignored and everything after a hash sign (#) until the end of the line is taken to be a comment.

#
8.2.3 Semicolons

A semicolon (;) is a logical end of line and anything after the semicolon is considered as the next statement. If a statement appears on a line by itself, a semicolon is not necessary to terminate it, so generally in the examples in this manual, you will not see many semicolons.

#
8.2.4 Including other Conﬁguration Files

If you wish to break your conﬁguration ﬁle into smaller pieces, you can do so by including other ﬁles using the syntax @filename where filename is the full path and ﬁlename of another ﬁle. The @filename speciﬁcation can be given anywhere a primitive token would appear.


@/etc/bareos/extra/clients.conf


Conﬁguration 8.1: include a conﬁguration ﬁle

Since Bareos Version >= 16.2.1 wildcards in pathes are supported:


@/etc/bareos/extra/*.conf


Conﬁguration 8.2: include multiple conﬁguration ﬁles

By using @|command it is also possible to include the output of a script as a conﬁguration:


@|"/etc/bareos/generate_configuration_to_stdout.sh"


Conﬁguration 8.3: use the output of a script as conﬁguration

or if a parameter should be used:


@|"sh -c ’/etc/bareos/generate_client_configuration_to_stdout.sh clientname=client1.example.com’"


Conﬁguration 8.4: use the output of a script with parameter as a conﬁguration

The scripts are called at the start of the daemon. You should use this with care.

#
8.3 Resource

A resource is deﬁned as the resource type (see Resource Types), followed by an open brace ({), a number of Resource Directives, and ended by a closing brace (})

Each resource deﬁnition MUST contain a Name directive. It can contain a Description directive. The Name directive is used to uniquely identify the resource. The Description directive can be used during the display of the Resource to provide easier human recognition. For example:


Director {
  Name = "bareos-dir"
  Description = "Main Bareos Director"
  Query File = "/usr/lib/bareos/scripts/query.sql"
}


Conﬁguration 8.5: Resource example

deﬁnes the Director resource with the name bareos-dir and a query ﬁle /usr/lib/bareos/scripts/query.sql.

#
8.3.1 Resource Directive

Each directive contained within the resource (within the curly braces {}) is composed of a Resource Directive Keyword followed by an equal sign (=) followed by a Resource Directive Value. The keywords must be one of the known Bareos resource record keywords.

#
8.3.2 Resource Directive Keyword

A resource directive keyword is the part before the equal sign (=) in a Resource Directive. The following sections will list all available directives by Bareos component resources.

Upper and Lower Case and Spaces

Case (upper/lower) and spaces are ignored in the resource directive keywords.

Within the keyword (i.e. before the equal sign), spaces are not signiﬁcant. Thus the keywords: name, Name, and N a m e are all identical.

#
8.3.3 Resource Directive Value

A resource directive value is the part after the equal sign (=) in a Resource Directive.

Spaces

Spaces after the equal sign and before the ﬁrst character of the value are ignored. Other spaces within a value may be signiﬁcant (not ignored) and may require quoting.

Quotes

In general, if you want spaces in a name to the right of the ﬁrst equal sign (=), you must enclose that name within double quotes. Otherwise quotes are not generally necessary because once deﬁned, quoted strings and unquoted strings are all equal.

Within a quoted string, any character following a backslash (∖) is taken as itself (handy for inserting backslashes and double quotes (”)).

Please note! If the conﬁgure directive is used to deﬁne a number, the number is never to be put between surrounding quotes. This is even true if the number is speciﬁed together with its unit, like 365 days.

Numbers

Numbers are not to be quoted, see Quotes. Also do not prepend numbers by zeros (0), as these are not parsed in the expected manner (write 1 instead of 01).

Data Types

When parsing the resource directives, Bareos classiﬁes the data according to the types listed below.

acl
    This directive deﬁnes what is permitted to be accessed. It does this by using a list of strings, separated by commas (,_).

    The special keyword *all* allows unrestricted access.
    
    Depending on the type of the ACL, the strings can be either resource names, paths or bconsole commands.
auth-type
    Speciﬁes the authentication type that must be supplied when connecting to a backup protocol that uses a speciﬁc authentication type. Currently only used for NDMP Resource.

    The following values are allowed:
    
    None
        - Use no password
    Clear
        - Use clear text password
    MD5
        - Use MD5 hashing

integer
    A 32 bit integer value. It may be positive or negative.

    Don’t use quotes around the number, see Quotes.
long integer
    A 64 bit integer value. Typically these are values such as bytes that can exceed 4 billion and thus require a 64 bit value.

    Don’t use quotes around the number, see Quotes.
name
    A keyword or name consisting of alphanumeric characters, including the hyphen, underscore, and dollar characters. The ﬁrst character of a name must be a letter. A name has a maximum length currently set to 127 bytes.

    Please note that Bareos resource names as well as certain other names (e.g. Volume names) must contain only letters (including ISO accented letters), numbers, and a few special characters (space, underscore, ...). All other characters and punctuation are invalid.
password
    This is a Bareos password and it is stored internally in MD5 hashed format.
path
    A path is either a quoted or non-quoted string. A path will be passed to your standard shell for expansion when it is scanned. Thus constructs such as $HOME are interpreted to be their correct values. The path can either reference to a ﬁle or a directory.
positive integer
    A 32 bit positive integer value.

    Don’t use quotes around the number, see Quotes.
speed
    The speed parameter can be speciﬁed as k/s, kb/s, m/s or mb/s.

    Don’t use quotes around the parameter, see Quotes.
string
    A quoted string containing virtually any character including spaces, or a non-quoted string. A string may be of any length. Strings are typically values that correspond to ﬁlenames, directories, or system command names. A backslash (∖) turns the next character into itself, so to include a double quote in a string, you precede the double quote with a backslash. Likewise to include a backslash.
string-list
    Multiple strings, speciﬁed in multiple directives, or in a single directive, separated by commas (,).
strname
    is similar to a name, except that the name may be quoted and can thus contain additional characters including spaces.
net-address
    is either a domain name or an IP address speciﬁed as a dotted quadruple in string or quoted string format. This directive only permits a single address to be speciﬁed. The net-port must be speciﬁcly separated. If multiple net-addresses are needed, please assess if it is also possible to specify net-addresses (plural).
net-addresses
    Specify a set of net-addresses and net-ports. Probably the simplest way to explain this is to show an example:


    Addresses  = {
        ip = { addr = 1.2.3.4; port = 1205;}
        ipv4 = {
            addr = 1.2.3.4; port = http;}
        ipv6 = {
            addr = 1.2.3.4;
            port = 1205;
        }
        ip = {
            addr = 1.2.3.4
            port = 1205
        }
        ip = { addr = 1.2.3.4 }
        ip = { addr = 201:220:222::2 }
        ip = {
            addr = server.example.com
        }
    }


    Conﬁguration 8.6: net-addresses
    
    where ip, ip4, ip6, addr, and port are all keywords. Note, that the address can be speciﬁed as either a dotted quadruple, or in IPv6 colon notation, or as a symbolic name (only in the ip speciﬁcation). Also, the port can be speciﬁed as a number or as the mnemonic value from the /etc/services ﬁle. If a port is not speciﬁed, the default one will be used. If an ip section is speciﬁed, the resolution can be made either by IPv4 or IPv6. If ip4 is speciﬁed, then only IPv4 resolutions will be permitted, and likewise with ip6.
net-port
    Specify a network port (a positive integer).

    Don’t use quotes around the parameter, see Quotes.
resource
    A resource deﬁnes a relation to the name of another resource.
size
    A size speciﬁed as bytes. Typically, this is a ﬂoating point scientiﬁc input format followed by an optional modiﬁer. The ﬂoating point input is stored as a 64 bit integer value. If a modiﬁer is present, it must immediately follow the value with no intervening spaces. The following modiﬁers are permitted:

    k
        1,024 (kilobytes)
    kb
        1,000 (kilobytes)
    m
        1,048,576 (megabytes)
    mb
        1,000,000 (megabytes)
    g
        1,073,741,824 (gigabytes)
    gb
        1,000,000,000 (gigabytes)
    
    Don’t use quotes around the parameter, see Quotes.
time
    A time or duration speciﬁed in seconds. The time is stored internally as a 64 bit integer value, but it is speciﬁed in two parts: a number part and a modiﬁer part. The number can be an integer or a ﬂoating point number. If it is entered in ﬂoating point notation, it will be rounded to the nearest integer. The modiﬁer is mandatory and follows the number part, either with or without intervening spaces. The following modiﬁers are permitted:

    seconds
    minutes
        (60 seconds)
    hours
        (3600 seconds)
    days
        (3600*24 seconds)
    weeks
        (3600*24*7 seconds)
    months
        (3600*24*30 seconds)
    quarters
        (3600*24*91 seconds)
    years
        (3600*24*365 seconds)
    
    Any abbreviation of these modiﬁers is also permitted (i.e. seconds may be speciﬁed as sec or s). A speciﬁcation of m will be taken as months.
    
    The speciﬁcation of a time may have as many number/modiﬁer parts as you wish. For example:
    1 week 2 days 3 hours 10 mins  
    1 month 2 days 30 sec
    
    are valid date speciﬁcations.
    
    Don’t use quotes around the parameter, see Quotes.
audit-command-list
    Speciﬁes the commands that should be logged on execution (audited). E.g.


    Audit Events = label
    Audit Events = restore


    Based on the type string-list.
yes|no
    Either a yes or a no (or true or false).

Variable Expansion

Depending on the directive, Bareos will expand to the following variables:

Variable Expansion on Volume Labels

When labeling a new volume (see Label Format Dir Pool), following Bareos internal variables can be used:

Internal Variable


Description

$Year


Year

$Month


Month: 1-12

$Day


Day: 1-31

$Hour


Hour: 0-24

$Minute


Minute: 0-59

$Second


Second: 0-59

$WeekDay


Day of the week: 0-6, using 0 for Sunday

$Job


Name of the Job

$Dir


Name of the Director

$Level


Job Level

$Type


Job Type

$JobId


JobId

$JobName


unique name of a job

$Storage


Name of the Storage Daemon

$Client


Name of the Clients

$NumVols


Numbers of volumes in the pool

$Pool


Name of the Pool

$Catalog


Name of the Catalog

$MediaType


Type of the media

Additional, normal environment variables can be used, e.g. $HOME oder $HOSTNAME.

With the exception of Job speciﬁc variables, you can trigger the variable expansion by using the var command.

Variable Expansion on RunScripts At the conﬁguration of RunScripts following variables can be used:

Variable


Description

\%c


Client’s Name

\%d


Director’s Name

\%e


Job Exit Code

\%i


JobId

\%j


Unique JobId

\%l


Job Level

\%n


Unadorned Job Name

\%r


Recipients

\%s


Since Time

\%b


Job Bytes

\%B


Job Bytes in human readable format

\%f


Job Files

\%t


Job Type (Backup, ...)

\%v


Read Volume Name (only on Director)

\%V


Write Volume Name (only on Director)

Variable Expansion in Autochanger Commands At the conﬁguration of autochanger commands the following variables can be used:

Variable


Description

\%a


Archive Device Name

\%c


Changer Device Name

\%d


Changer Drive Index

\%f


Client’s Name

\%j


Job Name

\%o


Command

\%s


Slot Base 0

\%S


Slot Base 1

\%v


Volume Name

Variable Expansion in Mount Commands At the conﬁguration of mount commands the following variables can be used:

Variable


Description

\%a


Archive Device Name

\%e


Erase

\%n


Part Number

\%m


Mount Point

\%v


Last Part Name

Variable Expansion in Mail and Operator Commands At the conﬁguration of mail and operator commands the following variables can be used:

Variable


Description

\%c


Client’s Name

\%d


Director’s Name

\%e


Job Exit Code

\%i


JobId

\%j


Unique Job Id

\%l


Job Level

\%n


Unadorned Job Name

\%s


Since Time

\%t


Job Type (Backup, ...)

\%r


Recipients

\%v


Read Volume Name

\%V


Write Volume Name

\%b


Job Bytes

\%B


Job Bytes in human readable format

\%F


Job Files

#
8.3.4 Resource Types

The following table lists all current Bareos resource types. It shows what resources must be deﬁned for each service (daemon). The default conﬁguration ﬁles will already contain at least one example of each permitted resource.

Resource

Director

Client

Storage

Console

Autochanger			x 	

Catalog 	x 			

Client 	x 	x 		

Console 	x 			x

Device 			x 	

Director 	x 	x 	x 	x

FileSet 	x 			

Job 	x 			

JobDefs 	x 			

Message 	x 	x 	x 	

NDMP 			x 	

Pool 	x 			

Proﬁle 	x 			

Schedule 	x 			

Storage 	x 		x 	



#
8.4 Names, Passwords and Authorization

In order for one daemon to contact another daemon, it must authorize itself with a password. In most cases, the password corresponds to a particular name, so both the name and the password must match to be authorized. Passwords are plain text, any text. They are not generated by any special process; just use random text.

The default conﬁguration ﬁles are automatically deﬁned for correct authorization with random passwords. If you add to or modify these ﬁles, you will need to take care to keep them consistent.

The following image illustrates what names/passwords in which ﬁles/Resources must match up:

pict

In the left column, you can see the Director, Storage, and Client resources and their corresponding names and passwords – these are all in bareos-dir.conf. In the right column the corresponding values in the Console, Storage daemon (SD), and File daemon (FD) conﬁguration ﬁles are shown.

Please note that the address fw-sd, that appears in the Storage resource of the Director, is passed to the File daemon in symbolic form. The File daemon then resolves it to an IP address. For this reason you must use either an IP address or a resolvable fully qualiﬁed name. A name such as localhost, not being a fully qualiﬁed name, will resolve in the File daemon to the localhost of the File daemon, which is most likely not what is desired. The password used for the File daemon to authorize with the Storage daemon is a temporary password unique to each Job created by the daemons and is not speciﬁed in any .conf ﬁle.

#
Chapter 9
Director Conﬁguration

Of all the conﬁguration ﬁles needed to run Bareos, the Director’s is the most complicated, and the one that you will need to modify the most often as you add clients or modify the FileSets.

For a general discussion of conﬁguration ﬁles and resources including the data types recognized by Bareos. Please see the Conﬁguration chapter of this manual.

Director resource type may be one of the following:

Job, JobDefs, Client, Storage, Catalog, Schedule, FileSet, Pool, Director, or Messages. We present them here in the most logical order for deﬁning them:

Note, everything revolves around a job and is tied to a job in one way or another.

    Director Resource – to deﬁne the Director’s name and its access password used for authenticating the Console program. Only a single Director resource deﬁnition may appear in the Director’s conﬁguration ﬁle. If you have either /dev/random or bc on your machine, Bareos will generate a random password during the conﬁguration process, otherwise it will be left blank.
    Job Resource – to deﬁne the backup/restore Jobs and to tie together the Client, FileSet and Schedule resources to be used for each Job. Normally, you will Jobs of diﬀerent names corresponding to each client (i.e. one Job per client, but a diﬀerent one with a diﬀerent name for each client).
    JobDefs Resource – optional resource for providing defaults for Job resources.
    Schedule Resource – to deﬁne when a Job has to run. You may have any number of Schedules, but each job will reference only one.
    FileSet Resource – to deﬁne the set of ﬁles to be backed up for each Client. You may have any number of FileSets but each Job will reference only one.
    Client Resource – to deﬁne what Client is to be backed up. You will generally have multiple Client deﬁnitions. Each Job will reference only a single client.
    Storage Resource – to deﬁne on what physical device the Volumes should be mounted. You may have one or more Storage deﬁnitions.
    Pool Resource – to deﬁne the pool of Volumes that can be used for a particular Job. Most people use a single default Pool. However, if you have a large number of clients or volumes, you may want to have multiple Pools. Pools allow you to restrict a Job (or a Client) to use only a particular set of Volumes.
    Catalog Resource – to deﬁne in what database to keep the list of ﬁles and the Volume names where they are backed up. Most people only use a single catalog. It is possible, however not adviced and not supported to use multiple catalogs, see Current Implementation Restrictions.
    Messages Resource – to deﬁne where error and information messages are to be sent or logged. You may deﬁne multiple diﬀerent message resources and hence direct particular classes of messages to diﬀerent users or locations (ﬁles, ...).

#
9.1 Director Resource

The Director resource deﬁnes the attributes of the Directors running on the network. Only a single Director resource is allowed.

The following is an example of a valid Director resource deﬁnition:


Director {
  Name = bareos-dir
  Password = secretpassword
  QueryFile = "/etc/bareos/query.sql"
  Maximum Concurrent Jobs = 10
  Messages = Daemon
}


Conﬁguration 9.1: Director Ressource example


conﬁguration directive name

type of data

default value

remark

Absolute Job Timeout 	= positive-integer 		
Audit Events 	= audit-command-list		
Auditing 	= yes|no 	no 	
Backend Directory 	= DirectoryList 	/usr/lib/bareos/backends (platform speciﬁc)
Description 	= string 		
Dir Address 	= net-address 	9101 	
Dir Addresses 	= net-addresses 	9101 	
Dir Port 	= net-port 	9101 	
Dir Source Address 	= net-address 	0 	
FD Connect Timeout 	= time 	180 	
Heartbeat Interval 	= time 	0 	
Key Encryption Key 	= password 		
Log Timestamp Format 	= string 		
Maximum Concurrent Jobs 	= positive-integer 	1 	
Maximum Connections 	= positive-integer 	30 	
Maximum Console Connections 	= positive-integer 	20 	
Messages 	= resource-name 		
Name 	= name 		required
NDMP Log Level 	= positive-integer 	4 	

NDMP Snooping 	= yes|no 		
Omit Defaults 	= yes|no 	yes 	
Optimize For Size 	= yes|no 	no 	
Optimize For Speed 	= yes|no 	no 	
Password 	= password 		required
Pid Directory 	= path 	/var/lib/bareos (platform speciﬁc)
Plugin Directory 	= path 		
Plugin Names 	= PluginNames 		
Query File 	= path 		required
Scripts Directory 	= path 		
SD Connect Timeout 	= time 	1800 	
Secure Erase Command 	= string 		
Statistics Collect Interval	= positive-integer	150 	
Statistics Retention 	= time 	160704000 	
Sub Sys Directory 	= path 		deprecated
Subscriptions 	= positive-integer	0 	
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string		
TLS DH File 	= path 		
TLS Enable 	= yes|no	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer 	= yes|no	yes 	
Ver Id 	= string		
Working Directory 	= path 	/var/lib/bareos (platform speciﬁc)


Absolute Job Timeout = <positive-integer>


    Version >= 14.2.0
Audit Events = <audit-command-list>

    Specify which commands (see Console Commands) will be audited. If nothing is speciﬁed (and Auditing Dir Director is enabled), all commands will be audited.  
    Version >= 14.2.0
Auditing = <yes|no>
    (default: no)
    This directive allows to en- or disable auditing of interaction with the Bareos Director. If enabled, audit messages will be generated. The messages resource conﬁgured in Messages Dir Director deﬁnes, how these messages are handled.  
    Version >= 14.2.0
Backend Directory = <DirectoryList>
    (default: /usr/lib/bareos/backends (platform speciﬁc))
    This directive speciﬁes a directory from where the Bareos Director loads his dynamic backends.  
Description = <string>

    The text ﬁeld contains a description of the Director that will be displayed in the graphical user interface. This directive is optional.  
Dir Address = <net-address>
    (default: 9101)
    This directive is optional, but if it is speciﬁed, it will cause the Director server (for the Console program) to bind to the speciﬁed address. If this and the Dir Addresses Dir Director directives are not speciﬁed, the Director will bind to any available address (the default).  
Dir Addresses = <net-addresses>
    (default: 9101)
    Specify the ports and addresses on which the Director daemon will listen for Bareos Console connections.

    Please note that if you use the Dir Addresses Dir Director directive, you must not use either a Dir Port Dir Director or a Dir Address Dir Director directive in the same resource.  
Dir Port = <net-port>
    (default: 9101)
    Specify the port on which the Director daemon will listen for Bareos Console connections. This same port number must be speciﬁed in the Director resource of the Console conﬁguration ﬁle. This directive should not be used if you specify Dir Addresses Dir Director (N.B plural) directive.  
Dir Source Address = <net-address>
    (default: 0)
    This record is optional, and if it is speciﬁed, it will cause the Director server (when initiating connections to a storage or ﬁle daemon) to source its connections from the speciﬁed address. Only a single IP address may be speciﬁed. If this record is not speciﬁed, the Director server will source its outgoing connections according to the system routing table (the default).  
FD Connect Timeout = <time>
    (default: 180)
    where time is the time that the Director should continue attempting to contact the File daemon to start a job, and after which the Director will cancel the job.  
Heartbeat Interval = <time>
    (default: 0)
    This directive is optional and if speciﬁed will cause the Director to set a keepalive interval (heartbeat) in seconds on each of the sockets it opens for the Client resource. This value will override any speciﬁed at the Director level. It is implemented only on systems that provide the setsockopt TCP_KEEPIDLE function (Linux, ...). The default value is zero, which means no change is made to the socket.  
Key Encryption Key = <password>

    This key is used to encrypt the Security Key that is exchanged between the Director and the Storage Daemon for supporting Application Managed Encryption (AME). For security reasons each Director should have a diﬀerent Key Encryption Key.  
Log Timestamp Format = <string>


    Version >= 15.2.3
Maximum Concurrent Jobs = <positive-integer>
    (default: 1)
    This directive speciﬁes the maximum number of total Director Jobs that should run concurrently.

    The Volume format becomes more complicated with multiple simultaneous jobs, consequently, restores may take longer if Bareos must sort through interleaved volume blocks from multiple simultaneous jobs. This can be avoided by having each simultaneous job write to a diﬀerent volume or by using data spooling, which will ﬁrst spool the data to disk simultaneously, then write one spool ﬁle at a time to the volume thus avoiding excessive interleaving of the diﬀerent job blocks.
    
    See also the section about Concurrent Jobs.  
Maximum Connections = <positive-integer>
    (default: 30)

Maximum Console Connections = <positive-integer>
    (default: 20)
    This directive speciﬁes the maximum number of Console Connections that could run concurrently.  
Messages = <resource-name>

    The messages resource speciﬁes where to deliver Director messages that are not associated with a speciﬁc Job. Most messages are speciﬁc to a job and will be directed to the Messages resource speciﬁed by the job. However, there are a messages that can occur when no job is running.  
Name = <name>
    (required)
    The name of the resource.

    The director name used by the system administrator.  
NDMP Log Level = <positive-integer>
    (default: 4)
    This directive sets the loglevel for the NDMP protocol library.  
    Version >= 13.2.0
NDMP Snooping = <yes|no>

    This directive enables the Snooping and pretty printing of NDMP protocol information in debugging mode.  
    Version >= 13.2.0
Omit Defaults = <yes|no>
    (default: yes)
    When showing the conﬁguration, omit those parameter that have there default value assigned.  
Optimize For Size = <yes|no>
    (default: no)
    If set to yes this directive will use the optimizations for memory size over speed. So it will try to use less memory which may lead to a somewhat lower speed. Its currently mostly used for keeping all hardlinks in memory.

    If none of Optimize For Size Dir Director and Optimize For Speed Dir Director is enabled, Optimize For Size Dir Director is enabled by default.  
Optimize For Speed = <yes|no>
    (default: no)
    If set to yes this directive will use the optimizations for speed over the memory size. So it will try to use more memory which lead to a somewhat higher speed. Its currently mostly used for keeping all hardlinks in memory. Its relates to the Optimize For Size Dir Director option set either one to yes as they are mutually exclusive.  
Password = <password>
    (required)
    Speciﬁes the password that must be supplied for the default Bareos Console to be authorized. This password correspond to Password Console Director of the Console conﬁguration ﬁle.

    The password is plain text.  
Pid Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive is optional and speciﬁes a directory in which the Director may put its process Id ﬁle. The process Id ﬁle is used to shutdown Bareos and to prevent multiple copies of Bareos from running simultaneously. Standard shell expansion of the Directory is done when the conﬁguration ﬁle is read so that values such as $HOME will be properly expanded.

    The PID directory speciﬁed must already exist and be readable and writable by the Bareos daemon referencing it.
    
    Typically on Linux systems, you will set this to: /var/run. If you are not installing Bareos in the system directories, you can use the Working Directory as deﬁned above.  
Plugin Directory = <path>

    Plugins are loaded from this directory. To load only speciﬁc plugins, use ’Plugin Names’.


    Version >= 14.2.0
Plugin Names = <PluginNames>

    List of plugins, that should get loaded from ’Plugin Directory’ (only basenames, ’-dir.so’ is added automatically). If empty, all plugins will get loaded.


    Version >= 14.2.0
Query File = <path>
    (required)
    This directive is required and speciﬁes a directory and ﬁle in which the Director can ﬁnd the canned SQL statements for the query command.  
Scripts Directory = <path>

    This directive is currently unused.


SD Connect Timeout = <time>
    (default: 1800)
    where time is the time that the Director should continue attempting to contact the Storage daemon to start a job, and after which the Director will cancel the job.  
Secure Erase Command = <string>

    Specify command that will be called when bareos unlinks ﬁles.
    
    When ﬁles are no longer needed, Bareos will delete (unlink) them. With this directive, it will call the speciﬁed command to delete these ﬁles. See Secure Erase Command for details.  
    Version >= 15.2.1
Statistics Collect Interval = <positive-integer>
    (default: 150)
    Bareos oﬀers the possibility to collect statistic information from its connected devices. To do so, Collect Statistics Dir Storage must be enabled. This interval deﬁnes, how often the Director connects to the attached Storage Daemons to collect the statistic information.  
    Version >= 14.2.0
Statistics Retention = <time>
    (default: 160704000)
    The Statistics Retention directive deﬁnes the length of time that Bareos will keep statistics job records in the Catalog database after the Job End time (in JobHistory table). When this time period expires, and if user runs prune stats command, Bareos will prune (remove) Job records that are older than the speciﬁed period.

    Theses statistics records aren’t use for restore purpose, but mainly for capacity planning, billings, etc. See chapter about how to extract information from the catalog for additional information.
    
    See the Conﬁguration chapter of this manual for additional details of time speciﬁcation.  
Sub Sys Directory = <path>

    Please note! This directive is deprecated.

Subscriptions = <positive-integer>
    (default: 0)
    In case you want check that the number of active clients don’t exceed a speciﬁc number, you can deﬁne this number here and check with the status subscriptions command.

    However, this is only indended to give a hint. No active limiting is implemented.  
    Version >= 12.4.4
TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see, how the Bareos Director (and the other components) must be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Ver Id = <string>

    where string is an identiﬁer which can be used for support purpose. This string is displayed using the version command.  
Working Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive is optional and speciﬁes a directory in which the Director may put its status ﬁles. This directory should be used only by Bareos but may be shared by other Bareos daemons. Standard shell expansion of the directory is done when the conﬁguration ﬁle is read so that values such as $HOME will be properly expanded.

    The working directory speciﬁed must already exist and be readable and writable by the Bareos daemon referencing it.  

#
9.2 Job Resource

The Job resource deﬁnes a Job (Backup, Restore, ...) that Bareos must perform. Each Job resource deﬁnition contains the name of a Client and a FileSet to backup, the Schedule for the Job, where the data are to be stored, and what media Pool can be used. In eﬀect, each Job resource must specify What, Where, How, and When or FileSet, Storage, Backup/Restore/Level, and Schedule respectively. Note, the FileSet must be speciﬁed for a restore job for historical reasons, but it is no longer used.

Only a single type (Backup, Restore, ...) can be speciﬁed for any job. If you want to backup multiple FileSets on the same Client or multiple Clients, you must deﬁne a Job for each one.

Note, you deﬁne only a single Job to do the Full, Diﬀerential, and Incremental backups since the diﬀerent backup levels are tied together by a unique Job name. Normally, you will have only one Job per Client, but if a client has a really huge number of ﬁles (more than several million), you might want to split it into to Jobs each with a diﬀerent FileSet covering only part of the total ﬁles.

Multiple Storage daemons are not currently supported for Jobs, so if you do want to use multiple storage daemons, you will need to create a diﬀerent Job and ensure that for each Job that the combination of Client and FileSet are unique. The Client and FileSet are what Bareos uses to restore a client, so if there are multiple Jobs with the same Client and FileSet or multiple Storage daemons that are used, the restore will not work. This problem can be resolved by deﬁning multiple FileSet deﬁnitions (the names must be diﬀerent, but the contents of the FileSets may be the same).


conﬁguration directive name

type of data

default value

remark

Accurate 	= yes|no 	no 	
Add Preﬁx 	= string 		
Add Suﬃx 	= string 		
Allow Duplicate Jobs 	= yes|no 	yes 	
Allow Higher Duplicates 	= yes|no 	yes 	
Allow Mixed Priority 	= yes|no 	no 	
Always Incremental 	= yes|no 	no 	
Always Incremental Job Retention	= time 	0 	
Always Incremental Keep Number	= positive-integer 	0 	
Always Incremental Max Full Age 	= time 		
Backup Format 	= string 	Native 	
Base 	= ResourceList 		
Bootstrap 	= path 		
Cancel Lower Level Duplicates 	= yes|no 	no 	
Cancel Queued Duplicates 	= yes|no 	no 	
Cancel Running Duplicates 	= yes|no 	no 	
Catalog 	= resource-name 		
Client 	= resource-name 		
Client Run After Job 	= RunscriptShort		

Client Run Before Job 	= RunscriptShort		
Description 	= string 		
Diﬀerential Backup Pool 	= resource-name 		
Diﬀerential Max Runtime 	= time 		
Diﬀerential Max Wait Time 	= time 		deprecated
Dir Plugin Options 	= string-list 		
Enabled 	= yes|no 	yes 	
FD Plugin Options 	= string-list 		
File History Size 	= Size64 	10000000
File Set 	= resource-name 		
Full Backup Pool 	= resource-name 		
Full Max Runtime 	= time 		
Full Max Wait Time 	= time 		deprecated
Incremental Backup Pool 	= resource-name 		
Incremental Max Runtime 	= time 		
Incremental Max Wait Time	= time 		deprecated
Job Defs 	= resource-name 		
Job To Verify 	= resource-name 		
Level 	= BackupLevel 		
Max Concurrent Copies 	= positive-integer 	100 	
Max Diﬀ Interval 	= time 		
Max Full Consolidations 	= positive-integer 	0 	
Max Full Interval 	= time 		
Max Run Sched Time 	= time 		
Max Run Time 	= time 		
Max Start Delay 	= time 		
Max Virtual Full Interval 	= time 		
Max Wait Time 	= time 		
Maximum Bandwidth 	= speed 		
Maximum Concurrent Jobs	= positive-integer 	1 	
Messages 	= resource-name		required
Name 	= name 		required
Next Pool 	= resource-name 		
Plugin Options 	= string-list 		alias, deprecated
Pool 	= resource-name		required
Prefer Mounted Volumes 	= yes|no 	yes 	
Preﬁx Links 	= yes|no 	no 	
Priority 	= positive-integer 	10 	
Protocol 	= ProtocolType 	Native
Prune Files 	= yes|no 	no 	
Prune Jobs 	= yes|no 	no 	
Prune Volumes 	= yes|no 	no 	
Purge Migration Job 	= yes|no 	no 	
Regex Where 	= string 		
Replace 	= ReplaceOption 	Always
Rerun Failed Levels 	= yes|no 	no 	
Reschedule Interval 	= time 	1800 	
Reschedule On Error	= yes|no 	no 	
Reschedule Times 	= positive-integer 	5 	
Run 	= string-list 		
Run After Failed Job	= RunscriptShort		
Run After Job 	= RunscriptShort		
Run Before Job 	= RunscriptShort		
Run Script 	{Runscript } 		
Save File History 	= yes|no 	yes 	
Schedule 	= resource-name 		
SD Plugin Options 	= string-list 		
Selection Pattern 	= string 		
Selection Type 	= MigrationType 		
Spool Attributes 	= yes|no 	no 	
Spool Data 	= yes|no 	no
Spool Size 	= Size64 		
Storage 	= ResourceList		
Strip Preﬁx 	= string 		
Type 	= JobType 		required
Verify Job 	= resource-name		alias
Virtual Full Backup Pool	= resource-name		
Where 	= path 		
Write Bootstrap 	= path 		
Write Part After Job 	= yes|no 		deprecated
Write Verify List 	= path 		


Accurate = <yes|no>
    (default: no)
    In accurate mode, the File daemon knowns exactly which ﬁles were present after the last backup. So it is able to handle deleted or renamed ﬁles.

    When restoring a FileSet for a speciﬁed date (including ”most recent”), Bareos is able to restore exactly the ﬁles and directories that existed at the time of the last backup prior to that date including ensuring that deleted ﬁles are actually deleted, and renamed directories are restored properly.
    
    When doing VirtualFull backups, it is advised to use the accurate mode, otherwise the VirtualFull might contain already deleted ﬁles.
    
    However, using the accurate mode has also disadvantages:
    
        The File daemon must keep data concerning all ﬁles in memory. So If you do not have suﬃcient memory, the backup may either be terribly slow or fail. For 500.000 ﬁles (a typical desktop linux system), it will require approximately 64 Megabytes of RAM on your File daemon to hold the required information.


Add Preﬁx = <string>

    This directive applies only to a Restore job and speciﬁes a preﬁx to the directory name of all ﬁles being restored. This will use File Relocation feature.  
Add Suﬃx = <string>

    This directive applies only to a Restore job and speciﬁes a suﬃx to all ﬁles being restored. This will use File Relocation feature.
    
    Using Add Suffix=.old, /etc/passwd will be restored to /etc/passwsd.old  
Allow Duplicate Jobs = <yes|no>
    (default: yes)
    pict
    Figure 9.1: Allow Duplicate Jobs usage

    A duplicate job in the sense we use it here means a second or subsequent job with the same name starts. This happens most frequently when the ﬁrst job runs longer than expected because no tapes are available.
    
    If this directive is enabled duplicate jobs will be run. If the directive is set to no then only one job of a given name may run at one time. The action that Bareos takes to ensure only one job runs is determined by the directives
    
        Cancel Lower Level Duplicates Dir Job
        Cancel Queued Duplicates Dir Job
        Cancel Running Duplicates Dir Job
    
    If none of these directives is set to yes, Allow Duplicate Jobs is set to no and two jobs are present, then the current job (the second one started) will be cancelled.  
Allow Higher Duplicates = <yes|no>
    (default: yes)

Allow Mixed Priority = <yes|no>
    (default: no)
    When set to yes, this job may run even if lower priority jobs are already running. This means a high priority job will not have to wait for other jobs to ﬁnish before starting. The scheduler will only mix priorities when all running jobs have this set to true.

    Note that only higher priority jobs will start early. Suppose the director will allow two concurrent jobs, and that two jobs with priority 10 are running, with two more in the queue. If a job with priority 5 is added to the queue, it will be run as soon as one of the running jobs ﬁnishes. However, new priority 10 jobs will not be run until the priority 5 job has ﬁnished.  
Always Incremental = <yes|no>
    (default: no)
    Enable/disable always incremental backup scheme.


    Version >= 16.2.4
Always Incremental Job Retention = <time>
    (default: 0)
    Backup Jobs older than the speciﬁed time duration will be merged into a new Virtual backup.


    Version >= 16.2.4
Always Incremental Keep Number = <positive-integer>
    (default: 0)
    Guarantee that at least the speciﬁed number of Backup Jobs will persist, even if they are older than ”Always Incremental Job Retention”.


    Version >= 16.2.4
Always Incremental Max Full Age = <time>

    If ”AlwaysIncrementalMaxFullAge” is set, during consolidations only incremental backups will be considered while the Full Backup remains to reduce the amount of data being consolidated. Only if the Full Backup is older than ”AlwaysIncrementalMaxFullAge”, the Full Backup will be part of the consolidation to avoid the Full Backup becoming too old .


    Version >= 16.2.4
Backup Format = <string>
    (default: Native)
    The backup format used for protocols which support multiple formats. By default, it uses the Bareos Native Backup format. Other protocols, like NDMP supports diﬀerent backup formats for instance:

        Dump
        Tar
        SMTape


Base = <ResourceList>

    The Base directive permits to specify the list of jobs that will be used during Full backup as base. This directive is optional. See the Base Job chapter for more information.  
Bootstrap = <path>

    The Bootstrap directive speciﬁes a bootstrap ﬁle that, if provided, will be used during Restore Jobs and is ignored in other Job types. The bootstrap ﬁle contains the list of tapes to be used in a restore Job as well as which ﬁles are to be restored. Speciﬁcation of this directive is optional, and if speciﬁed, it is used only for a restore job. In addition, when running a Restore job from the console, this value can be changed.
    
    If you use the restore command in the Console program, to start a restore job, the bootstrap ﬁle will be created automatically from the ﬁles you select to be restored.
    
    For additional details see The Bootstrap File chapter.  
Cancel Lower Level Duplicates = <yes|no>
    (default: no)
    If Allow Duplicate Jobs Dir Job is set to no and this directive is set to yes, Bareos will choose between duplicated jobs the one with the highest level. For example, it will cancel a previous Incremental to run a Full backup. It works only for Backup jobs. If the levels of the duplicated jobs are the same, nothing is done and the directives Cancel Queued Duplicates Dir Job and Cancel Running Duplicates Dir Job will be examined.  
Cancel Queued Duplicates = <yes|no>
    (default: no)
    If Allow Duplicate Jobs Dir Job is set to no and if this directive is set to yes any job that is already queued to run but not yet running will be canceled.  
Cancel Running Duplicates = <yes|no>
    (default: no)
    If Allow Duplicate Jobs Dir Job is set to no and if this directive is set to yes any job that is already running will be canceled.  
Catalog = <resource-name>

    This speciﬁes the name of the catalog resource to be used for this Job. When a catalog is deﬁned in a Job it will override the deﬁnition in the client.  
    Version >= 13.4.0
Client = <resource-name>

    The Client directive speciﬁes the Client (File daemon) that will be used in the current Job. Only a single Client may be speciﬁed in any one Job. The Client runs on the machine to be backed up, and sends the requested ﬁles to the Storage daemon for backup, or receives them when restoring. For additional details, see the Client Resource of this chapter. This directive is required For versions before 13.3.0, this directive is required for all Jobtypes. For Version >= 13.3.0 it is required for all Jobtypes but Copy or Migrate jobs.  
Client Run After Job = <RunscriptShort>

    This is a shortcut for the Run Script Dir Job resource, that run on the client after a backup job.  
Client Run Before Job = <RunscriptShort>

    This is basically a shortcut for the Run Script Dir Job resource, that run on the client before the backup job.
    
    Please note! For compatibility reasons, with this shortcut, the command is executed directly when the client receive it. And if the command is in error, other remote runscripts will be discarded. To be sure that all commands will be sent and executed, you have to use Run Script Dir Job syntax.  
Description = <string>


Diﬀerential Backup Pool = <resource-name>

    The Diﬀerential Backup Pool speciﬁes a Pool to be used for Diﬀerential backups. It will override any Pool Dir Job speciﬁcation during a Diﬀerential backup.  
Diﬀerential Max Runtime = <time>

    The time speciﬁes the maximum allowed time that a Diﬀerential backup job may run, counted from when the job starts (not necessarily the same as when the job was scheduled).  
Diﬀerential Max Wait Time = <time>

    Please note! This directive is deprecated.
    This directive has been deprecated in favor of Diﬀerential Max Runtime Dir Job.  
Dir Plugin Options = <string-list>

    These settings are plugin speciﬁc, see Director Plugins.  
Enabled = <yes|no>
    (default: yes)
    En- or disable this resource.

    This directive allows you to enable or disable automatic execution via the scheduler of a Job.  
FD Plugin Options = <string-list>

    These settings are plugin speciﬁc, see File Daemon Plugins.  
File History Size = <Size64>
    (default: 10000000)

    Version >= 15.2.4
File Set = <resource-name>

    The FileSet directive speciﬁes the FileSet that will be used in the current Job. The FileSet speciﬁes which directories (or ﬁles) are to be backed up, and what options to use (e.g. compression, ...). Only a single FileSet resource may be speciﬁed in any one Job. For additional details, see the FileSet Resource section of this chapter. This directive is required (For versions before 13.3.0 for all Jobtypes and for versions after that for all Jobtypes but Copy and Migrate).  
Full Backup Pool = <resource-name>

    The Full Backup Pool speciﬁes a Pool to be used for Full backups. It will override any Pool Dir Job speciﬁcation during a Full backup.  
Full Max Runtime = <time>

    The time speciﬁes the maximum allowed time that a Full backup job may run, counted from when the job starts (not necessarily the same as when the job was scheduled).  
Full Max Wait Time = <time>

    Please note! This directive is deprecated.
    This directive has been deprecated in favor of Full Max Runtime Dir Job.  
Incremental Backup Pool = <resource-name>

    The Incremental Backup Pool speciﬁes a Pool to be used for Incremental backups. It will override any Pool Dir Job speciﬁcation during an Incremental backup.  
Incremental Max Runtime = <time>

    The time speciﬁes the maximum allowed time that an Incremental backup job may run, counted from when the job starts, (not necessarily the same as when the job was scheduled).  
Incremental Max Wait Time = <time>

    Please note! This directive is deprecated.
    This directive has been deprecated in favor of Incremental Max Runtime Dir Job  
Job Defs = <resource-name>

    If a Job Defs resource name is speciﬁed, all the values contained in the named Job Defs resource will be used as the defaults for the current Job. Any value that you explicitly deﬁne in the current Job resource, will override any defaults speciﬁed in the Job Defs resource. The use of this directive permits writing much more compact Job resources where the bulk of the directives are deﬁned in one or more Job Defs. This is particularly useful if you have many similar Jobs but with minor variations such as diﬀerent Clients. To structure the conﬁguration even more, Job Defs themselves can also refer to other Job Defs.  
Job To Verify = <resource-name>


Level = <BackupLevel>

    The Level directive speciﬁes the default Job level to be run. Each diﬀerent Type Dir Job (Backup, Restore, Verify, ...) has a diﬀerent set of Levels that can be speciﬁed. The Level is normally overridden by a diﬀerent value that is speciﬁed in the Schedule Resource. This directive is not required, but must be speciﬁed either by this directive or as an override speciﬁed in the Schedule Resource.
    
    Backup
    
        For a Backup Job, the Level may be one of the following:
    
        Full
    
            When the Level is set to Full all ﬁles in the FileSet whether or not they have changed will be backed up.
        Incremental
    
            When the Level is set to Incremental all ﬁles speciﬁed in the FileSet that have changed since the last successful backup of the the same Job using the same FileSet and Client, will be backed up. If the Director cannot ﬁnd a previous valid Full backup then the job will be upgraded into a Full backup. When the Director looks for a valid backup record in the catalog database, it looks for a previous Job with:
    
                The same Job name.
                The same Client name.
                The same FileSet (any change to the deﬁnition of the FileSet such as adding or deleting a ﬁle in the Include or Exclude sections constitutes a diﬀerent FileSet.
                The Job was a Full, Diﬀerential, or Incremental backup.
                The Job terminated normally (i.e. did not fail or was not canceled).
                The Job started no longer ago than Max Full Interval.
    
            If all the above conditions do not hold, the Director will upgrade the Incremental to a Full save. Otherwise, the Incremental backup will be performed as requested.
    
            The File daemon (Client) decides which ﬁles to backup for an Incremental backup by comparing start time of the prior Job (Full, Diﬀerential, or Incremental) against the time each ﬁle was last ”modiﬁed” (st_mtime) and the time its attributes were last ”changed”(st_ctime). If the ﬁle was modiﬁed or its attributes changed on or after this start time, it will then be backed up.
    
            Some virus scanning software may change st_ctime while doing the scan. For example, if the virus scanning program attempts to reset the access time (st_atime), which Bareos does not use, it will cause st_ctime to change and hence Bareos will backup the ﬁle during an Incremental or Diﬀerential backup. In the case of Sophos virus scanning, you can prevent it from resetting the access time (st_atime) and hence changing st_ctime by using the --no-reset-atime option. For other software, please see their manual.
    
            When Bareos does an Incremental backup, all modiﬁed ﬁles that are still on the system are backed up. However, any ﬁle that has been deleted since the last Full backup remains in the Bareos catalog, which means that if between a Full save and the time you do a restore, some ﬁles are deleted, those deleted ﬁles will also be restored. The deleted ﬁles will no longer appear in the catalog after doing another Full save.
    
            In addition, if you move a directory rather than copy it, the ﬁles in it do not have their modiﬁcation time (st_mtime) or their attribute change time (st_ctime) changed. As a consequence, those ﬁles will probably not be backed up by an Incremental or Diﬀerential backup which depend solely on these time stamps. If you move a directory, and wish it to be properly backed up, it is generally preferable to copy it, then delete the original.
    
            However, to manage deleted ﬁles or directories changes in the catalog during an Incremental backup you can use Job Resource. This is quite memory consuming process.
        Diﬀerential
    
            When the Level is set to Diﬀerential all ﬁles speciﬁed in the FileSet that have changed since the last successful Full backup of the same Job will be backed up. If the Director cannot ﬁnd a valid previous Full backup for the same Job, FileSet, and Client, backup, then the Diﬀerential job will be upgraded into a Full backup. When the Director looks for a valid Full backup record in the catalog database, it looks for a previous Job with:
    
                The same Job name.
                The same Client name.
                The same FileSet (any change to the deﬁnition of the FileSet such as adding or deleting a ﬁle in the Include or Exclude sections constitutes a diﬀerent FileSet.
                The Job was a FULL backup.
                The Job terminated normally (i.e. did not fail or was not canceled).
                The Job started no longer ago than Max Full Interval.
    
            If all the above conditions do not hold, the Director will upgrade the Diﬀerential to a Full save. Otherwise, the Diﬀerential backup will be performed as requested.
    
            The File daemon (Client) decides which ﬁles to backup for a diﬀerential backup by comparing the start time of the prior Full backup Job against the time each ﬁle was last ”modiﬁed” (st_mtime) and the time its attributes were last ”changed” (st_ctime). If the ﬁle was modiﬁed or its attributes were changed on or after this start time, it will then be backed up. The start time used is displayed after the Since on the Job report. In rare cases, using the start time of the prior backup may cause some ﬁles to be backed up twice, but it ensures that no change is missed.
    
            When Bareos does a Diﬀerential backup, all modiﬁed ﬁles that are still on the system are backed up. However, any ﬁle that has been deleted since the last Full backup remains in the Bareos catalog, which means that if between a Full save and the time you do a restore, some ﬁles are deleted, those deleted ﬁles will also be restored. The deleted ﬁles will no longer appear in the catalog after doing another Full save. However, to remove deleted ﬁles from the catalog during a Diﬀerential backup is quite a time consuming process and not currently implemented in Bareos. It is, however, a planned future feature.
    
            As noted above, if you move a directory rather than copy it, the ﬁles in it do not have their modiﬁcation time (st_mtime) or their attribute change time (st_ctime) changed. As a consequence, those ﬁles will probably not be backed up by an Incremental or Diﬀerential backup which depend solely on these time stamps. If you move a directory, and wish it to be properly backed up, it is generally preferable to copy it, then delete the original. Alternatively, you can move the directory, then use the touch program to update the timestamps.
    
            However, to manage deleted ﬁles or directories changes in the catalog during an Diﬀerential backup you can use accurate mode. This is quite memory consuming process. See for more details.
    
            Every once and a while, someone asks why we need Diﬀerential backups as long as Incremental backups pickup all changed ﬁles. There are possibly many answers to this question, but the one that is the most important for me is that a Diﬀerential backup eﬀectively merges all the Incremental and Diﬀerential backups since the last Full backup into a single Diﬀerential backup. This has two eﬀects: 1. It gives some redundancy since the old backups could be used if the merged backup cannot be read. 2. More importantly, it reduces the number of Volumes that are needed to do a restore eﬀectively eliminating the need to read all the volumes on which the preceding Incremental and Diﬀerential backups since the last Full are done.
        VirtualFull
    
            When the Level is set to VirtualFull, a new Full backup is generated from the last existing Full backup and the matching Diﬀerential- and Incremental-Backups. It matches this according the Name Dir Client and Name Dir FileSet. This means, a new Full backup get created without transfering all the data from the client to the backup server again. The new Full backup will be stored in the pool deﬁned in Next Pool Dir Pool.
    
            Please note! Opposite to the oﬀer backup levels, VirtualFull may require read and write access to multiple volumes. In most cases you have to make sure, that Bareos does not try to read and write to the same Volume.
    
    Restore
    
        For a Restore Job, no level needs to be speciﬁed.
    Verify
    
        For a Verify Job, the Level may be one of the following:
    
        InitCatalog
    
            does a scan of the speciﬁed FileSet and stores the ﬁle attributes in the Catalog database. Since no ﬁle data is saved, you might ask why you would want to do this. It turns out to be a very simple and easy way to have a Tripwire like feature using Bareos. In other words, it allows you to save the state of a set of ﬁles deﬁned by the FileSet and later check to see if those ﬁles have been modiﬁed or deleted and if any new ﬁles have been added. This can be used to detect system intrusion. Typically you would specify a FileSet that contains the set of system ﬁles that should not change (e.g. /sbin, /boot, /lib, /bin, ...). Normally, you run the InitCatalog level verify one time when your system is ﬁrst setup, and then once again after each modiﬁcation (upgrade) to your system. Thereafter, when your want to check the state of your system ﬁles, you use a Verify level = Catalog. This compares the results of your InitCatalog with the current state of the ﬁles.
        Catalog
    
            Compares the current state of the ﬁles against the state previously saved during an InitCatalog. Any discrepancies are reported. The items reported are determined by the verify options speciﬁed on the Include directive in the speciﬁed FileSet (see the FileSet resource below for more details). Typically this command will be run once a day (or night) to check for any changes to your system ﬁles.
    
            Please note! If you run two Verify Catalog jobs on the same client at the same time, the results will certainly be incorrect. This is because Verify Catalog modiﬁes the Catalog database while running in order to track new ﬁles.
        VolumeToCatalog
    
            This level causes Bareos to read the ﬁle attribute data written to the Volume from the last backup Job for the job speciﬁed on the VerifyJob directive. The ﬁle attribute data are compared to the values saved in the Catalog database and any diﬀerences are reported. This is similar to the DiskToCatalog level except that instead of comparing the disk ﬁle attributes to the catalog database, the attribute data written to the Volume is read and compared to the catalog database. Although the attribute data including the signatures (MD5 or SHA1) are compared, the actual ﬁle data is not compared (it is not in the catalog).
    
            VolumeToCatalog jobs need a client to extract the metadata, but this client does not have to be the original client. We suggest to use the client on the backup server itself for maximum performance.
    
            Please note! If you run two Verify VolumeToCatalog jobs on the same client at the same time, the results will certainly be incorrect. This is because the Verify VolumeToCatalog modiﬁes the Catalog database while running.
        DiskToCatalog
    
            This level causes Bareos to read the ﬁles as they currently are on disk, and to compare the current ﬁle attributes with the attributes saved in the catalog from the last backup for the job speciﬁed on the VerifyJob directive. This level diﬀers from the VolumeToCatalog level described above by the fact that it doesn’t compare against a previous Verify job but against a previous backup. When you run this level, you must supply the verify options on your Include statements. Those options determine what attribute ﬁelds are compared.
    
            This command can be very useful if you have disk problems because it will compare the current state of your disk against the last successful backup, which may be several jobs.
    
            Note, the current implementation does not identify ﬁles that have been deleted.


Max Concurrent Copies = <positive-integer>
    (default: 100)

Max Diﬀ Interval = <time>

    The time speciﬁes the maximum allowed age (counting from start time) of the most recent successful Diﬀerential backup that is required in order to run Incremental backup jobs. If the most recent Diﬀerential backup is older than this interval, Incremental backups will be upgraded to Diﬀerential backups automatically. If this directive is not present, or speciﬁed as 0, then the age of the previous Diﬀerential backup is not considered.  
Max Full Consolidations = <positive-integer>
    (default: 0)
    If ”AlwaysIncrementalMaxFullAge” is conﬁgured, do not run more than ”MaxFullConsolidations” consolidation jobs that include the Full backup.


    Version >= 16.2.4
Max Full Interval = <time>

    The time speciﬁes the maximum allowed age (counting from start time) of the most recent successful Full backup that is required in order to run Incremental or Diﬀerential backup jobs. If the most recent Full backup is older than this interval, Incremental and Diﬀerential backups will be upgraded to Full backups automatically. If this directive is not present, or speciﬁed as 0, then the age of the previous Full backup is not considered.  
Max Run Sched Time = <time>

    The time speciﬁes the maximum allowed time that a job may run, counted from when the job was scheduled. This can be useful to prevent jobs from running during working hours. We can see it like Max Start Delay + Max Run Time.  
Max Run Time = <time>

    The time speciﬁes the maximum allowed time that a job may run, counted from when the job starts, (not necessarily the same as when the job was scheduled).
    
    By default, the watchdog thread will kill any Job that has run more than 6 days. The maximum watchdog timeout is independent of Max Run Time and cannot be changed.  
Max Start Delay = <time>

    The time speciﬁes the maximum delay between the scheduled time and the actual start time for the Job. For example, a job can be scheduled to run at 1:00am, but because other jobs are running, it may wait to run. If the delay is set to 3600 (one hour) and the job has not begun to run by 2:00am, the job will be canceled. This can be useful, for example, to prevent jobs from running during day time hours. The default is no limit.  
Max Virtual Full Interval = <time>

    The time speciﬁes the maximum allowed age (counting from start time) of the most recent successful Virtual Full backup that is required in order to run Incremental or Diﬀerential backup jobs. If the most recent Virtual Full backup is older than this interval, Incremental and Diﬀerential backups will be upgraded to Virtual Full backups automatically. If this directive is not present, or speciﬁed as 0, then the age of the previous Virtual Full backup is not considered.  
    Version >= 14.4.0
Max Wait Time = <time>

    The time speciﬁes the maximum allowed time that a job may block waiting for a resource (such as waiting for a tape to be mounted, or waiting for the storage or ﬁle daemons to perform their duties), counted from the when the job starts, (not necessarily the same as when the job was scheduled).
    
    pict
    Figure 9.2: Job time control directives


Maximum Bandwidth = <speed>

    The speed parameter speciﬁes the maximum allowed bandwidth that a job may use.  
Maximum Concurrent Jobs = <positive-integer>
    (default: 1)
    Speciﬁes the maximum number of Jobs from the current Job resource that can run concurrently. Note, this directive limits only Jobs with the same name as the resource in which it appears. Any other restrictions on the maximum concurrent jobs such as in the Director, Client or Storage resources will also apply in addition to the limit speciﬁed here.

    For details, see the Concurrent Jobs chapter.  
Messages = <resource-name>
    (required)
    The Messages directive deﬁnes what Messages resource should be used for this job, and thus how and where the various messages are to be delivered. For example, you can direct some messages to a log ﬁle, and others can be sent by email. For additional details, see the Messages Resource Chapter of this manual. This directive is required.  
Name = <name>
    (required)
    The name of the resource.

    The Job name. This name can be speciﬁed on the Run command in the console program to start a job. If the name contains spaces, it must be speciﬁed between quotes. It is generally a good idea to give your job the same name as the Client that it will backup. This permits easy identiﬁcation of jobs.
    
    When the job actually runs, the unique Job Name will consist of the name you specify here followed by the date and time the job was scheduled for execution. This directive is required.


Next Pool = <resource-name>

    A Next Pool override used for Migration/Copy and Virtual Backup Jobs.  
Plugin Options = <string-list>

    Please note! This directive is deprecated.
    This directive is an alias.


Pool = <resource-name>
    (required)
    The Pool directive deﬁnes the pool of Volumes where your data can be backed up. Many Bareos installations will use only the Default pool. However, if you want to specify a diﬀerent set of Volumes for diﬀerent Clients or diﬀerent Jobs, you will probably want to use Pools. For additional details, see the Pool Resource of this chapter. This directive is required.

    In case of a Copy or Migration job, this setting determines what Pool will be examined for ﬁnding JobIds to migrate. The exception to this is when Selection Type Dir Job = SQLQuery, and although a Pool directive must still be speciﬁed, no Pool is used, unless you speciﬁcally include it in the SQL query. Note, in any case, the Pool resource deﬁned by the Pool directive must contain a Next Pool Dir Pool = ... directive to deﬁne the Pool to which the data will be migrated.  
Prefer Mounted Volumes = <yes|no>
    (default: yes)
    If the Prefer Mounted Volumes directive is set to yes, the Storage daemon is requested to select either an Autochanger or a drive with a valid Volume already mounted in preference to a drive that is not ready. This means that all jobs will attempt to append to the same Volume (providing the Volume is appropriate – right Pool, ... for that job), unless you are using multiple pools. If no drive with a suitable Volume is available, it will select the ﬁrst available drive. Note, any Volume that has been requested to be mounted, will be considered valid as a mounted volume by another job. This if multiple jobs start at the same time and they all prefer mounted volumes, the ﬁrst job will request the mount, and the other jobs will use the same volume.

    If the directive is set to no, the Storage daemon will prefer ﬁnding an unused drive, otherwise, each job started will append to the same Volume (assuming the Pool is the same for all jobs). Setting Prefer Mounted Volumes to no can be useful for those sites with multiple drive autochangers that prefer to maximize backup throughput at the expense of using additional drives and Volumes. This means that the job will prefer to use an unused drive rather than use a drive that is already in use.
    
    Despite the above, we recommend against setting this directive to no since it tends to add a lot of swapping of Volumes between the diﬀerent drives and can easily lead to deadlock situations in the Storage daemon. We will accept bug reports against it, but we cannot guarantee that we will be able to ﬁx the problem in a reasonable time.
    
    A better alternative for using multiple drives is to use multiple pools so that Bareos will be forced to mount Volumes from those Pools on diﬀerent drives.  
Preﬁx Links = <yes|no>
    (default: no)
    If a Where path preﬁx is speciﬁed for a recovery job, apply it to absolute links as well. The default is No. When set to Yes then while restoring ﬁles to an alternate directory, any absolute soft links will also be modiﬁed to point to the new alternate directory. Normally this is what is desired – i.e. everything is self consistent. However, if you wish to later move the ﬁles to their original locations, all ﬁles linked with absolute names will be broken.  
Priority = <positive-integer>
    (default: 10)
    This directive permits you to control the order in which your jobs will be run by specifying a positive non-zero number. The higher the number, the lower the job priority. Assuming you are not running concurrent jobs, all queued jobs of priority 1 will run before queued jobs of priority 2 and so on, regardless of the original scheduling order.

    The priority only aﬀects waiting jobs that are queued to run, not jobs that are already running. If one or more jobs of priority 2 are already running, and a new job is scheduled with priority 1, the currently running priority 2 jobs must complete before the priority 1 job is run, unless Allow Mixed Priority is set.
    
    If you want to run concurrent jobs you should keep these points in mind:
    
        See Concurrent Jobs on how to setup concurrent jobs.
        Bareos concurrently runs jobs of only one priority at a time. It will not simultaneously run a priority 1 and a priority 2 job.
        If Bareos is running a priority 2 job and a new priority 1 job is scheduled, it will wait until the running priority 2 job terminates even if the Maximum Concurrent Jobs settings would otherwise allow two jobs to run simultaneously.
        Suppose that bareos is running a priority 2 job and a new priority 1 job is scheduled and queued waiting for the running priority 2 job to terminate. If you then start a second priority 2 job, the waiting priority 1 job will prevent the new priority 2 job from running concurrently with the running priority 2 job. That is: as long as there is a higher priority job waiting to run, no new lower priority jobs will start even if the Maximum Concurrent Jobs settings would normally allow them to run. This ensures that higher priority jobs will be run as soon as possible.
    
    If you have several jobs of diﬀerent priority, it may not best to start them at exactly the same time, because Bareos must examine them one at a time. If by Bareos starts a lower priority job ﬁrst, then it will run before your high priority jobs. If you experience this problem, you may avoid it by starting any higher priority jobs a few seconds before lower priority ones. This insures that Bareos will examine the jobs in the correct order, and that your priority scheme will be respected.  
Protocol = <ProtocolType>
    (default: Native)
    The backup protocol to use to run the Job. If not set it will default to Native currently the director understand the following protocols:

        Native - The native Bareos protocol
        NDMP - The NDMP protocol


Prune Files = <yes|no>
    (default: no)
    Normally, pruning of Files from the Catalog is speciﬁed on a Client by Client basis in the Client resource with the AutoPrune directive. If this directive is speciﬁed (not normally) and the value is yes, it will override the value speciﬁed in the Client resource.  
Prune Jobs = <yes|no>
    (default: no)
    Normally, pruning of Jobs from the Catalog is speciﬁed on a Client by Client basis in the Client resource with the AutoPrune directive. If this directive is speciﬁed (not normally) and the value is yes, it will override the value speciﬁed in the Client resource.  
Prune Volumes = <yes|no>
    (default: no)
    Normally, pruning of Volumes from the Catalog is speciﬁed on a Pool by Pool basis in the Pool resource with the AutoPrune directive. Note, this is diﬀerent from File and Job pruning which is done on a Client by Client basis. If this directive is speciﬁed (not normally) and the value is yes, it will override the value speciﬁed in the Pool resource.  
Purge Migration Job = <yes|no>
    (default: no)
    This directive may be added to the Migration Job deﬁnition in the Director conﬁguration ﬁle to purge the job migrated at the end of a migration.  
Regex Where = <string>

    This directive applies only to a Restore job and speciﬁes a regex ﬁlename manipulation of all ﬁles being restored. This will use File Relocation feature.
    
    For more informations about how use this option, see RegexWhere Format.  
Replace = <ReplaceOption>
    (default: Always)
    This directive applies only to a Restore job and speciﬁes what happens when Bareos wants to restore a ﬁle or directory that already exists. You have the following options for replace-option:

    always
        when the ﬁle to be restored already exists, it is deleted and then replaced by the copy that was backed up. This is the default value.
    ifnewer
        if the backed up ﬁle (on tape) is newer than the existing ﬁle, the existing ﬁle is deleted and replaced by the back up.
    ifolder
        if the backed up ﬁle (on tape) is older than the existing ﬁle, the existing ﬁle is deleted and replaced by the back up.
    never
        if the backed up ﬁle already exists, Bareos skips restoring this ﬁle.


Rerun Failed Levels = <yes|no>
    (default: no)
    If this directive is set to yes (default no), and Bareos detects that a previous job at a higher level (i.e. Full or Diﬀerential) has failed, the current job level will be upgraded to the higher level. This is particularly useful for Laptops where they may often be unreachable, and if a prior Full save has failed, you wish the very next backup to be a Full save rather than whatever level it is started as.

    There are several points that must be taken into account when using this directive: ﬁrst, a failed job is deﬁned as one that has not terminated normally, which includes any running job of the same name (you need to ensure that two jobs of the same name do not run simultaneously); secondly, the Ignore File Set Changes Dir FileSet directive is not considered when checking for failed levels, which means that any FileSet change will trigger a rerun.  
Reschedule Interval = <time>
    (default: 1800)
    If you have speciﬁed Reschedule On Error = yes and the job terminates in error, it will be rescheduled after the interval of time speciﬁed by time-speciﬁcation. See the time speciﬁcation formats in the Conﬁgure chapter for details of time speciﬁcations. If no interval is speciﬁed, the job will not be rescheduled on error.  
Reschedule On Error = <yes|no>
    (default: no)
    If this directive is enabled, and the job terminates in error, the job will be rescheduled as determined by the Reschedule Interval Dir Job and Reschedule Times Dir Job directives. If you cancel the job, it will not be rescheduled.

    This speciﬁcation can be useful for portables, laptops, or other machines that are not always connected to the network or switched on.  
Reschedule Times = <positive-integer>
    (default: 5)
    This directive speciﬁes the maximum number of times to reschedule the job. If it is set to zero (the default) the job will be rescheduled an indeﬁnite number of times.  
Run = <string-list>

    The Run directive (not to be confused with the Run option in a Schedule) allows you to start other jobs or to clone jobs. By using the cloning keywords (see below), you can backup the same data (or almost the same data) to two or more drives at the same time. The job-name is normally the same name as the current Job resource (thus creating a clone). However, it may be any Job name, so one job may start other related jobs.
    
    The part after the equal sign must be enclosed in double quotes, and can contain any string or set of options (overrides) that you can specify when entering the Run command from the console. For example storage=DDS-4 .... In addition, there are two special keywords that permit you to clone the current job. They are level=%l and since=%s. The %l in the level keyword permits entering the actual level of the current job and the %s in the since keyword permits putting the same time for comparison as used on the current job. Note, in the case of the since keyword, the %s must be enclosed in double quotes, and thus they must be preceded by a backslash since they are already inside quotes. For example:
    
    run = "Nightly-backup level=%l since=\"%s\" storage=DDS-4"
    
    A cloned job will not start additional clones, so it is not possible to recurse.
    
    Please note that all cloned jobs, as speciﬁed in the Run directives are submitted for running before the original job is run (while it is being initialized). This means that any clone job will actually start before the original job, and may even block the original job from starting until the original job ﬁnishes unless you allow multiple simultaneous jobs. Even if you set a lower priority on the clone job, if no other jobs are running, it will start before the original job.
    
    If you are trying to prioritize jobs by using the clone feature (Run directive), you will ﬁnd it much easier to do using a Run Script Dir Job resource, or a Run Before Job Dir Job directive.  
Run After Failed Job = <RunscriptShort>

    This is a shortcut for the Run Script Dir Job resource, that runs a command after a failed job.
    
    If the exit code of the program run is non-zero, Bareos will print a warning message.
    
    Run Script {
      Command = "echo test"
      Runs When = After
      Runs On Failure = yes
      Runs On Client  = no
      Runs On Success = yes    # default, you can drop this line
    }


Run After Job = <RunscriptShort>

    This is a shortcut for the Run Script Dir Job resource, that runs a command after a successful job (without error or without being canceled).
    
    If the exit code of the program run is non-zero, Bareos will print a warning message.  
Run Before Job = <RunscriptShort>

    This is a shortcut for the Run Script Dir Job resource, that runs a command before a job.
    
    If the exit code of the program run is non-zero, the current Bareos job will be canceled.
    
    Run Before Job = "echo test"
    
    is equivalent to:
    
    Run Script {
      Command = "echo test"
      Runs On Client = No
      Runs When = Before
    }


Run Script = <Runscript>

    The RunScript directive behaves like a resource in that it requires opening and closing braces around a number of directives that make up the body of the runscript.
    
    The speciﬁed Command (see below for details) is run as an external program prior or after the current Job. This is optional. By default, the program is executed on the Client side like in ClientRunXXXJob.
    
    Console options are special commands that are sent to the director instead of the OS. At this time, console command ouputs are redirected to log with the jobid 0.
    
    You can use following console command: delete, disable, enable, estimate, list, llist, memory, prune, purge, reload, status, setdebug, show, time, trace, update, version, .client, .jobs, .pool, .storage. See Bareos Console for more information. You need to specify needed information on command line, nothing will be prompted. Example:
    
    Console = "prune files client=\%c"
    Console = "update stats age=3"
    
    You can specify more than one Command/Console option per RunScript.
    
    You can use following options may be speciﬁed in the body of the runscript:



    Options


    Value


    Information



    Runs On Success


    Yes | No


    run if JobStatus is successful


    Runs On Failure


    Yes | No


    run if JobStatus isn’t successful


    Runs On Client


    Yes | No


    run command on client


    Runs When


    Never | Before | After | Always | AfterVSS


    When to run


    Fail Job On Error


    Yes | No


    Fail job if script returns something diﬀerent from 0


    Command




    External command


    Console




    Console command


    Any output sent by the command to standard output will be included in the Bareos job report. The command string must be a valid program name or name of a shell script.
    
    Please note! The command string is parsed then fed to the OS, which means that the path will be searched to execute your speciﬁed command, but there is no shell interpretation. As a consequence, if you invoke complicated commands or want any shell features such as redirection or piping, you must call a shell script and do it inside that script. Alternatively, it is possible to use sh -c ’_...’_ in the command deﬁnition to force shell interpretation, see example below.
    
    Before executing the speciﬁed command, Bareos performs character substitution of the following characters:
    
    %%	%
    %b 	Job Bytes
    %B	Job Bytes in human readable format
    %c 	Client’s name
    %d 	Daemon’s name (Such as host-dir or host-fd)
    %D	Director’s name (Also valid on ﬁle daemon)
    %e 	Job Exit Status
    %f 	Job FileSet (Only on director side)
    %F 	Job Files
    %h 	Client address
    %i 	Job Id
    %j 	Unique Job Id
    %l 	Job Level
    %n 	Job name
    %p 	Pool name (Only on director side)
    %P	Daemon PID
    %s 	Since time
    %t 	Job type (Backup, ...)
    %v 	Read Volume name(s) (Only on director side)
    %V	Write Volume name(s) (Only on director side)
    
    %w	Storage name (Only on director side)
    %x 	Spooling enabled? (”yes” or ”no”)
    
    Some character substitutions are not available in all situations. The Job Exit Status code %e edits the following values:
    
        OK
        Error
        Fatal Error
        Canceled
        Diﬀerences
        Unknown term code
    
    Thus if you edit it on a command line, you will need to enclose it within some sort of quotes.
    
    You can use these following shortcuts:
    
    Keyword 	RunsOnSuccess	RunsOnFailure	FailJobOnError	Runs On Client	RunsWhen


    Run Before Job Dir Job 			Yes 	No 	Before
    
    Run After Job Dir Job 	Yes 	No 		No 	After
    
    Run After Failed Job Dir Job 	No 	Yes 		No 	After
    
    Client Run Before Job Dir Job			Yes 	Yes 	Before
    
    Client Run After Job Dir Job 	Yes 	No 		Yes 	After


    Examples:
    
    Run Script {
      RunsWhen = Before
      FailJobOnError = No
      Command = "/etc/init.d/apache stop"
    }
    
    RunScript {
      RunsWhen = After
      RunsOnFailure = Yes
      Command = "/etc/init.d/apache start"
    }
    
    RunScript {
      RunsWhen = Before
      FailJobOnError = Yes
      Command = "sh -c ’top -b -n 1 > /var/backup/top.out’"
    }
    
    Special Windows Considerations
    
    You can run scripts just after snapshots initializations with AfterVSS keyword.
    
    In addition, for a Windows client, please take note that you must ensure a correct path to your script. The script or program can be a .com, .exe or a .bat ﬁle. If you just put the program name in then Bareos will search using the same rules that cmd.exe uses (current directory, Bareos bin directory, and PATH). It will even try the diﬀerent extensions in the same order as cmd.exe. The command can be anything that cmd.exe or command.com will recognize as an executable ﬁle.
    
    However, if you have slashes in the program name then Bareos ﬁgures you are fully specifying the name, so you must also explicitly add the three character extension.
    
    The command is run in a Win32 environment, so Unix like commands will not work unless you have installed and properly conﬁgured Cygwin in addition to and separately from Bareos.
    
    The System %Path% will be searched for the command. (under the environment variable dialog you have have both System Environment and User Environment, we believe that only the System environment will be available to bareos-fd, if it is running as a service.)
    
    System environment variables can be referenced with %var% and used as either part of the command name or arguments.
    
    So if you have a script in the Bareos
    bin directory then the following lines should work ﬁne:
    
            Client Run Before Job = "systemstate"
    or
            Client Run Before Job = "systemstate.bat"
    or
            Client Run Before Job = "\"C:/Program Files/Bareos/systemstate.bat\""
    
    The outer set of quotes is removed when the conﬁguration ﬁle is parsed. You need to escape the inner quotes so that they are there when the code that parses the command line for execution runs so it can tell what the program name is.
    
    The special characters &<_>_()@| will need to be quoted, if they are part of a ﬁlename or argument.
    
    If someone is logged in, a blank ”command” window running the commands will be present during the execution of the command.
    
    Some Suggestions from Phil Stracchino for running on Win32 machines with the native Win32 File daemon:
    
        You might want the ClientRunBeforeJob directive to specify a .bat ﬁle which runs the actual client-side commands, rather than trying to run (for example) regedit /e directly.
        The batch ﬁle should explicitly ’exit 0’ on successful completion.
        The path to the batch ﬁle should be speciﬁed in Unix form:
    
        Client Run Before Job = "c:/bareos/bin/systemstate.bat"
    
        rather than DOS/Windows form:
    
        INCORRECT: Client Run Before Job = "c:\bareos \bin \systemstate .bat"
    
    For Win32, please note that there are certain limitations:
    
    Client Run Before Job = "C:/Program Files/Bareos/bin/pre-exec.bat"
    
    Lines like the above do not work because there are limitations of cmd.exe that is used to execute the command. Bareos preﬁxes the string you supply with cmd.exe /c. To test that your command works you should type cmd /c "C:/Program Files/test.exe" at a cmd prompt and see what happens. Once the command is correct insert a backslash (∖) before each double quote (”), and then put quotes around the whole thing when putting it in the director’s .conf ﬁle. You either need to have only one set of quotes or else use the short name and don’t put quotes around the command path.
    
    Below is the output from cmd’s help as it relates to the command line passed to the /c option.
    
    If /C or /K is speciﬁed, then the remainder of the command line after the switch is processed as a command line, where the following logic is used to process quote (”) characters:
    
        If all of the following conditions are met, then quote characters on the command line are preserved:
            no /S switch.
            exactly two quote characters.
            no special characters between the two quote characters, where special is one of: &<_>_()@|
            there are one or more whitespace characters between the the two quote characters.
            the string between the two quote characters is the name of an executable ﬁle.
        Otherwise, old behavior is to see if the ﬁrst character is a quote character and if so, strip the leading character and remove the last quote character on the command line, preserving any text after the last quote character.


Save File History = <yes|no>
    (default: yes)
    Allow disabling storing the ﬁle history, as this causes problems problems with some implementations of NDMP (out-of-order metadata).

    Please note! The File History is required to do a single ﬁle restore from NDMP backups. With this disabled, only full restores are possible.  
    Version >= 14.2.0
Schedule = <resource-name>

    The Schedule directive deﬁnes what schedule is to be used for the Job. The schedule in turn determines when the Job will be automatically started and what Job level (i.e. Full, Incremental, ...) is to be run. This directive is optional, and if left out, the Job can only be started manually using the Console program. Although you may specify only a single Schedule resource for any one job, the Schedule resource may contain multiple Run directives, which allow you to run the Job at many diﬀerent times, and each run directive permits overriding the default Job Level Pool, Storage, and Messages resources. This gives considerable ﬂexibility in what can be done with a single Job. For additional details, see Schedule Resource.  
SD Plugin Options = <string-list>

    These settings are plugin speciﬁc, see Storage Daemon Plugins.  
Selection Pattern = <string>

    Selection Patterns is only used for Copy and Migration jobs, see Migration and Copy. The interpretation of its value depends on the selected Selection Type Dir Job.
    
    For the OldestVolume and SmallestVolume, this Selection pattern is not used (ignored).
    
    For the Client, Volume, and Job keywords, this pattern must be a valid regular expression that will ﬁlter the appropriate item names found in the Pool.
    
    For the SQLQuery keyword, this pattern must be a valid SELECT SQL statement that returns JobIds.  
Selection Type = <MigrationType>

    Selection Type is only used for Copy and Migration jobs, see Migration and Copy. It determines how a migration job will go about selecting what JobIds to migrate. In most cases, it is used in conjunction with a Selection Pattern Dir Job to give you ﬁne control over exactly what JobIds are selected. The possible values are:
    
    SmallestVolume
        This selection keyword selects the volume with the fewest bytes from the Pool to be migrated. The Pool to be migrated is the Pool deﬁned in the Migration Job resource. The migration control job will then start and run one migration backup job for each of the Jobs found on this Volume. The Selection Pattern, if speciﬁed, is not used.
    OldestVolume
        This selection keyword selects the volume with the oldest last write time in the Pool to be migrated. The Pool to be migrated is the Pool deﬁned in the Migration Job resource. The migration control job will then start and run one migration backup job for each of the Jobs found on this Volume. The Selection Pattern, if speciﬁed, is not used.
    Client
        The Client selection type, ﬁrst selects all the Clients that have been backed up in the Pool speciﬁed by the Migration Job resource, then it applies the Selection Pattern Dir Job as a regular expression to the list of Client names, giving a ﬁltered Client name list. All jobs that were backed up for those ﬁltered (regexed) Clients will be migrated. The migration control job will then start and run one migration backup job for each of the JobIds found for those ﬁltered Clients.
    Volume
        The Volume selection type, ﬁrst selects all the Volumes that have been backed up in the Pool speciﬁed by the Migration Job resource, then it applies the Selection Pattern Dir Job as a regular expression to the list of Volume names, giving a ﬁltered Volume list. All JobIds that were backed up for those ﬁltered (regexed) Volumes will be migrated. The migration control job will then start and run one migration backup job for each of the JobIds found on those ﬁltered Volumes.
    Job
        The Job selection type, ﬁrst selects all the Jobs (as deﬁned on the Name Dir Job directive in a Job resource) that have been backed up in the Pool speciﬁed by the Migration Job resource, then it applies the Selection Pattern Dir Job as a regular expression to the list of Job names, giving a ﬁltered Job name list. All JobIds that were run for those ﬁltered (regexed) Job names will be migrated. Note, for a given Job named, they can be many jobs (JobIds) that ran. The migration control job will then start and run one migration backup job for each of the Jobs found.
    SQLQuery
        The SQLQuery selection type, used the Selection Pattern Dir Job as an SQL query to obtain the JobIds to be migrated. The Selection Pattern must be a valid SELECT SQL statement for your SQL engine, and it must return the JobId as the ﬁrst ﬁeld of the SELECT.
    PoolOccupancy
        This selection type will cause the Migration job to compute the total size of the speciﬁed pool for all Media Types combined. If it exceeds the Migration High Bytes Dir Pool deﬁned in the Pool, the Migration job will migrate all JobIds beginning with the oldest Volume in the pool (determined by Last Write time) until the Pool bytes drop below the Migration Low Bytes Dir Pool deﬁned in the Pool. This calculation should be consider rather approximative because it is made once by the Migration job before migration is begun, and thus does not take into account additional data written into the Pool during the migration. In addition, the calculation of the total Pool byte size is based on the Volume bytes saved in the Volume (Media) database entries. The bytes calculate for Migration is based on the value stored in the Job records of the Jobs to be migrated. These do not include the Storage daemon overhead as is in the total Pool size. As a consequence, normally, the migration will migrate more bytes than strictly necessary.
    PoolTime
        The PoolTime selection type will cause the Migration job to look at the time each JobId has been in the Pool since the job ended. All Jobs in the Pool longer than the time speciﬁed on Migration Time Dir Pool directive in the Pool resource will be migrated.
    PoolUncopiedJobs
        This selection which copies all jobs from a pool to an other pool which were not copied before is available only for copy Jobs.


Spool Attributes = <yes|no>
    (default: no)
    Is Spool Attributes is disabled, the File attributes are sent by the Storage daemon to the Director as they are stored on tape. However, if you want to avoid the possibility that database updates will slow down writing to the tape, you may want to set the value to yes, in which case the Storage daemon will buﬀer the File attributes and Storage coordinates to a temporary ﬁle in the Working Directory, then when writing the Job data to the tape is completed, the attributes and storage coordinates will be sent to the Director.

    NOTE: When Spool Data Dir Job is set to yes, Spool Attributes is also automatically set to yes.
    
    For details, see Data Spooling.  
Spool Data = <yes|no>
    (default: no)
    If this directive is set to yes, the Storage daemon will be requested to spool the data for this Job to disk rather than write it directly to the Volume (normally a tape).

    Thus the data is written in large blocks to the Volume rather than small blocks. This directive is particularly useful when running multiple simultaneous backups to tape. Once all the data arrives or the spool ﬁles’ maximum sizes are reached, the data will be despooled and written to tape.
    
    Spooling data prevents interleaving data from several job and reduces or eliminates tape drive stop and start commonly known as ”shoe-shine”.
    
    We don’t recommend using this option if you are writing to a disk ﬁle using this option will probably just slow down the backup jobs.
    
    NOTE: When this directive is set to yes, Spool Attributes Dir Job is also automatically set to yes.
    
    For details, see Data Spooling.  
Spool Size = <Size64>

    This speciﬁes the maximum spool size for this job. The default is taken from Maximum Spool Size Sd Device limit.  
Storage = <ResourceList>

    The Storage directive deﬁnes the name of the storage services where you want to backup the FileSet data. For additional details, see the Storage Resource of this manual. The Storage resource may also be speciﬁed in the Job’s Pool resource, in which case the value in the Pool resource overrides any value in the Job. This Storage resource deﬁnition is not required by either the Job resource or in the Pool, but it must be speciﬁed in one or the other, if not an error will result.  
Strip Preﬁx = <string>

    This directive applies only to a Restore job and speciﬁes a preﬁx to remove from the directory name of all ﬁles being restored. This will use the File Relocation feature.
    
    Using Strip Prefix=/etc, /etc/passwd will be restored to /passwd
    
    Under Windows, if you want to restore c:/files to d:/files, you can use:
    
    Strip Prefix = c:
    Add Prefix = d:


Type = <JobType>
    (required)
    The Type directive speciﬁes the Job type, which is one of the following:

    Backup
    
        Run a backup Job. Normally you will have at least one Backup job for each client you want to save. Normally, unless you turn oﬀ cataloging, most all the important statistics and data concerning ﬁles backed up will be placed in the catalog.
    Restore
    
        Run a restore Job. Normally, you will specify only one Restore job which acts as a sort of prototype that you will modify using the console program in order to perform restores. Although certain basic information from a Restore job is saved in the catalog, it is very minimal compared to the information stored for a Backup job – for example, no File database entries are generated since no Files are saved.
    
        Restore jobs cannot be automatically started by the scheduler as is the case for Backup, Verify and Admin jobs. To restore ﬁles, you must use the restore command in the console.
    Verify
    
        Run a verify Job. In general, verify jobs permit you to compare the contents of the catalog to the ﬁle system, or to what was backed up. In addition, to verifying that a tape that was written can be read, you can also use verify as a sort of tripwire intrusion detection.
    Admin
    
        Run an admin Job. An Admin job can be used to periodically run catalog pruning, if you do not want to do it at the end of each Backup Job. Although an Admin job is recorded in the catalog, very little data is saved.
    Migrate
        deﬁnes the job that is run as being a Migration Job. A Migration Job is a sort of control job and does not have any Files associated with it, and in that sense they are more or less like an Admin job. Migration jobs simply check to see if there is anything to Migrate then possibly start and control new Backup jobs to migrate the data from the speciﬁed Pool to another Pool. Note, any original JobId that is migrated will be marked as having been migrated, and the original JobId can nolonger be used for restores; all restores will be done from the new migrated Job.
    Copy
        deﬁnes the job that is run as being a Copy Job. A Copy Job is a sort of control job and does not have any Files associated with it, and in that sense they are more or less like an Admin job. Copy jobs simply check to see if there is anything to Copy then possibly start and control new Backup jobs to copy the data from the speciﬁed Pool to another Pool. Note that when a copy is made, the original JobIds are left unchanged. The new copies can not be used for restoration unless you speciﬁcally choose them by JobId. If you subsequently delete a JobId that has a copy, the copy will be automatically upgraded to a Backup rather than a Copy, and it will subsequently be used for restoration.
    
    Within a particular Job Type, there are also Levels, see Level Dir Job.  
Verify Job = <resource-name>

    This directive is an alias.
    
    If you run a verify job without this directive, the last job run will be compared with the catalog, which means that you must immediately follow a backup by a verify command. If you specify a Verify Job Bareos will ﬁnd the last job with that name that ran. This permits you to run all your backups, then run Verify jobs on those that you wish to be veriﬁed (most often a VolumeToCatalog) so that the tape just written is re-read.  
Virtual Full Backup Pool = <resource-name>


Where = <path>

    This directive applies only to a Restore job and speciﬁes a preﬁx to the directory name of all ﬁles being restored. This permits ﬁles to be restored in a diﬀerent location from which they were saved. If Where is not speciﬁed or is set to backslash (/), the ﬁles will be restored to their original location. By default, we have set Where in the example conﬁguration ﬁles to be /tmp/bareos-restores. This is to prevent accidental overwriting of your ﬁles.
    
    Please note! To use Where on NDMP backups, please read Restore ﬁles to diﬀerent path.  
Write Bootstrap = <path>

    The writebootstrap directive speciﬁes a ﬁle name where Bareos will write a bootstrap ﬁle for each Backup job run. This directive applies only to Backup Jobs. If the Backup job is a Full save, Bareos will erase any current contents of the speciﬁed ﬁle before writing the bootstrap records. If the Job is an Incremental or Diﬀerential save, Bareos will append the current bootstrap record to the end of the ﬁle.
    
    Using this feature, permits you to constantly have a bootstrap ﬁle that can recover the current state of your system. Normally, the ﬁle speciﬁed should be a mounted drive on another machine, so that if your hard disk is lost, you will immediately have a bootstrap record available. Alternatively, you should copy the bootstrap ﬁle to another machine after it is updated. Note, it is a good idea to write a separate bootstrap ﬁle for each Job backed up including the job that backs up your catalog database.
    
    If the bootstrap-ﬁle-speciﬁcation begins with a vertical bar (|), Bareos will use the speciﬁcation as the name of a program to which it will pipe the bootstrap record. It could for example be a shell script that emails you the bootstrap record.
    
    Before opening the ﬁle or executing the speciﬁed command, Bareos performs character substitution like in RunScript directive. To automatically manage your bootstrap ﬁles, you can use this in your JobDefs resources:
    
    Job Defs {
      ...
      Write Bootstrap = "%c_%n.bsr"
      ...
    }
    
    For more details on using this ﬁle, please see chapter The Bootstrap File.  
Write Part After Job = <yes|no>

    Please note! This directive is deprecated.

Write Verify List = <path>



The following is an example of a valid Job resource deﬁnition:


Job {
  Name = "Minou"
  Type = Backup
  Level = Incremental                 # default
  Client = Minou
  FileSet="Minou Full Set"
  Storage = DLTDrive
  Pool = Default
  Schedule = "MinouWeeklyCycle"
  Messages = Standard
}


Conﬁguration 9.2: Job Resource Example

#
9.3 JobDefs Resource

The JobDefs resource permits all the same directives that can appear in a Job resource. However, a JobDefs resource does not create a Job, rather it can be referenced within a Job to provide defaults for that Job. This permits you to concisely deﬁne several nearly identical Jobs, each one referencing a JobDefs resource which contains the defaults. Only the changes from the defaults need to be mentioned in each Job.

#
9.4 Schedule Resource

The Schedule resource provides a means of automatically scheduling a Job as well as the ability to override the default Level, Pool, Storage and Messages resources. If a Schedule resource is not referenced in a Job, the Job can only be run manually. In general, you specify an action to be taken and when.


conﬁguration directive name

type of data

default value

remark

Description 	= string 		
Enabled 	= yes|no 	yes 	
Name 	= name 		required
Run 	= job-overrides> <date-time-speciﬁcation		



Description = <string>


Enabled = <yes|no>
    (default: yes)
    En- or disable this resource.


Name = <name>
    (required)
    The name of the resource.

    The name of the schedule being deﬁned.  
Run = <job-overrides> <date-time-speciﬁcation>

    The Run directive deﬁnes when a Job is to be run, and what overrides if any to apply. You may specify multiple run directives within a Schedule resource. If you do, they will all be applied (i.e. multiple schedules). If you have two Run directives that start at the same time, two Jobs will start at the same time (well, within one second of each other).
    
    The Job-overrides permit overriding the Level, the Storage, the Messages, and the Pool speciﬁcations provided in the Job resource. In addition, the FullPool, the IncrementalPool, and the DiﬀerentialPool speciﬁcations permit overriding the Pool speciﬁcation according to what backup Job Level is in eﬀect.
    
    By the use of overrides, you may customize a particular Job. For example, you may specify a Messages override for your Incremental backups that outputs messages to a log ﬁle, but for your weekly or monthly Full backups, you may send the output by email by using a diﬀerent Messages override.
    
    Job-overrides are speciﬁed as: keyword=value where the keyword is Level, Storage, Messages, Pool, FullPool, DiﬀerentialPool, or IncrementalPool, and the value is as deﬁned on the respective directive formats for the Job resource. You may specify multiple Job-overrides on one Run directive by separating them with one or more spaces or by separating them with a trailing comma. For example:
    
    Level=Full
        is all ﬁles in the FileSet whether or not they have changed.
    Level=Incremental
        is all ﬁles that have changed since the last backup.
    Pool=Weekly
        speciﬁes to use the Pool named Weekly.
    Storage=DLT_Drive
        speciﬁes to use DLT_Drive for the storage device.
    Messages=Verbose
        speciﬁes to use the Verbose message resource for the Job.
    FullPool=Full
        speciﬁes to use the Pool named Full if the job is a full backup, or is upgraded from another type to a full backup.
    DiﬀerentialPool=Diﬀerential
        speciﬁes to use the Pool named Diﬀerential if the job is a diﬀerential backup.
    IncrementalPool=Incremental
        speciﬁes to use the Pool named Incremental if the job is an incremental backup.
    Accurate=yes|no
        tells Bareos to use or not the Accurate code for the speciﬁc job. It can allow you to save memory and and CPU resources on the catalog server in some cases.
    SpoolData=yes|no
        tells Bareos to use or not to use spooling for the speciﬁc job.
    
    Date-time-speciﬁcation determines when the Job is to be run. The speciﬁcation is a repetition, and as a default Bareos is set to run a job at the beginning of the hour of every hour of every day of every week of every month of every year. This is not normally what you want, so you must specify or limit when you want the job to run. Any speciﬁcation given is assumed to be repetitive in nature and will serve to override or limit the default repetition. This is done by specifying masks or times for the hour, day of the month, day of the week, week of the month, week of the year, and month when you want the job to run. By specifying one or more of the above, you can deﬁne a schedule to repeat at almost any frequency you want.
    
    Basically, you must supply a month, day, hour, and minute the Job is to be run. Of these four items to be speciﬁed, day is special in that you may either specify a day of the month such as 1, 2, ... 31, or you may specify a day of the week such as Monday, Tuesday, ... Sunday. Finally, you may also specify a week qualiﬁer to restrict the schedule to the ﬁrst, second, third, fourth, or ﬁfth week of the month.
    
    For example, if you specify only a day of the week, such as Tuesday the Job will be run every hour of every Tuesday of every Month. That is the month and hour remain set to the defaults of every month and all hours.
    
    Note, by default with no other speciﬁcation, your job will run at the beginning of every hour. If you wish your job to run more than once in any given hour, you will need to specify multiple run speciﬁcations each with a diﬀerent minute.
    
    The date/time to run the Job can be speciﬁed in the following way in pseudo-BNF:
    <week-keyword> ::= 	
    
    1st | 2nd | 3rd | 4th | 5th | ﬁrst | second | third | fourth | ﬁfth | last
    <wday-keyword> ::= 	
    
    sun | mon | tue | wed | thu | fri | sat | sunday | monday | tuesday | wednesday | thursday | friday | saturday
    <week-of-year-keyword> ::= 	
    
    w00 | w01 | ... w52 | w53
    <month-keyword> ::= 	
    
    jan | feb | mar | apr | may | jun | jul | aug | sep | oct | nov | dec | january | february | ... | december
    <digit> ::= 	
    
    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0
    <number> ::= 	
    
    <digit> | <digit><number>
    <12hour> ::= 	
    
    0 | 1 | 2 | ... 12
    <hour> ::= 	
    
    0 | 1 | 2 | ... 23
    <minute> ::= 	
    
    0 | 1 | 2 | ... 59
    <day> ::= 	
    
    1 | 2 | ... 31
    <time> ::= 	
    
    <hour>:<minute> | <12hour>:<minute>am | <12hour>:<minute>pm
    <time-spec> ::= 	
    
    at <time> | hourly
    <day-range> ::= 	
    
    <day>-<day>
    <month-range> ::= 	
    
    <month-keyword>-<month-keyword>
    <wday-range> ::= 	
    
    <wday-keyword>-<wday-keyword>
    <range> ::= 	
    
    <day-range> | <month-range> | <wday-range>
    <modulo> ::= 	
    
    <day>/<day> | <week-of-year-keyword>/<week-of-year-keyword>
    <date> ::= 	
    
    <date-keyword> | <day> | <range>
    <date-spec> ::= 	
    
    <date> | <date-spec>
    <day-spec> ::= 	
    
    <day> | <wday-keyword> | <day> | <wday-range> | <week-keyword> <wday-keyword> | <week-keyword> <wday-range> | daily
    
    <month-spec> ::= 	
    
    <month-keyword> | <month-range> | monthly
    <date-time-spec> ::= 	
    
    <month-spec> <day-spec> <time-spec>
    ::=
    ::=
    ::=
    ::=
    ::=



Note, the Week of Year speciﬁcation wnn follows the ISO standard deﬁnition of the week of the year, where Week 1 is the week in which the ﬁrst Thursday of the year occurs, or alternatively, the week which contains the 4th of January. Weeks are numbered w01 to w53. w00 for Bareos is the week that precedes the ﬁrst ISO week (i.e. has the ﬁrst few days of the year if any occur before Thursday). w00 is not deﬁned by the ISO speciﬁcation. A week starts with Monday and ends with Sunday.

According to the NIST (US National Institute of Standards and Technology), 12am and 12pm are ambiguous and can be deﬁned to anything. However, 12:01am is the same as 00:01 and 12:01pm is the same as 12:01, so Bareos deﬁnes 12am as 00:00 (midnight) and 12pm as 12:00 (noon). You can avoid this abiguity (confusion) by using 24 hour time speciﬁcations (i.e. no am/pm).

An example schedule resource that is named WeeklyCycle and runs a job with level full each Sunday at 2:05am and an incremental job Monday through Saturday at 2:05am is:


Schedule {
  Name = "WeeklyCycle"
  Run = Level=Full sun at 2:05
  Run = Level=Incremental mon-sat at 2:05
}


Conﬁguration 9.3: Schedule Example

An example of a possible monthly cycle is as follows:


Schedule {
  Name = "MonthlyCycle"
  Run = Level=Full Pool=Monthly 1st sun at 2:05
  Run = Level=Differential 2nd-5th sun at 2:05
  Run = Level=Incremental Pool=Daily mon-sat at 2:05
}


The ﬁrst of every month:


Schedule {
  Name = "First"
  Run = Level=Full on 1 at 2:05
  Run = Level=Incremental on 2-31 at 2:05
}


The last friday of the month (i.e. the last friday in the last week of the month)


Schedule {
  Name = "Last Friday"
  Run = Level=Full last fri at 21:00
}


Every 10 minutes:


Schedule {
  Name = "TenMinutes"
  Run = Level=Full hourly at 0:05
  Run = Level=Full hourly at 0:15
  Run = Level=Full hourly at 0:25
  Run = Level=Full hourly at 0:35
  Run = Level=Full hourly at 0:45
  Run = Level=Full hourly at 0:55
}


The modulo scheduler makes it easy to specify schedules like odd or even days/weeks, or more generally every n days or weeks. It is called modulo scheduler because it uses the modulo to determine if the schedule must be run or not. The second variable behind the slash lets you determine in which cycle of days/weeks a job should be run. The ﬁrst part determines on which day/week the job should be run ﬁrst. E.g. if you want to run a backup in a 5-week-cycle, starting on week 3, you set it up as w03/w05.


Schedule {
  Name = "Odd Days"
  Run = 1/2 at 23:10
}

Schedule {
  Name = "Even Days"
  Run = 2/2 at 23:10
}

Schedule {
  Name = "On the 3rd week in a 5-week-cycle"
  Run = w03/w05 at 23:10
}

Schedule {
  Name = "Odd Weeks"
  Run = w01/w02 at 23:10
}

Schedule {
  Name = "Even Weeks"
  Run = w02/w02 at 23:10
}


Conﬁguration 9.4: Schedule Examples: modulo

#
9.4.1 Technical Notes on Schedules

Internally Bareos keeps a schedule as a bit mask. There are six masks and a minute ﬁeld to each schedule. The masks are hour, day of the month (mday), month, day of the week (wday), week of the month (wom), and week of the year (woy). The schedule is initialized to have the bits of each of these masks set, which means that at the beginning of every hour, the job will run. When you specify a month for the ﬁrst time, the mask will be cleared and the bit corresponding to your selected month will be selected. If you specify a second month, the bit corresponding to it will also be added to the mask. Thus when Bareos checks the masks to see if the bits are set corresponding to the current time, your job will run only in the two months you have set. Likewise, if you set a time (hour), the hour mask will be cleared, and the hour you specify will be set in the bit mask and the minutes will be stored in the minute ﬁeld.

For any schedule you have deﬁned, you can see how these bits are set by doing a show schedules command in the Console program. Please note that the bit mask is zero based, and Sunday is the ﬁrst day of the week (bit zero).

#
9.5 FileSet Resource

The FileSet resource deﬁnes what ﬁles are to be included or excluded in a backup job. A FileSet resource is required for each backup Job. It consists of a list of ﬁles or directories to be included, a list of ﬁles or directories to be excluded and the various backup options such as compression, encryption, and signatures that are to be applied to each ﬁle.

Any change to the list of the included ﬁles will cause Bareos to automatically create a new FileSet (deﬁned by the name and an MD5 checksum of the Include/Exclude contents). Each time a new FileSet is created, Bareos will ensure that the next backup is always a Full save.


conﬁguration directive name

type of data

default value

remark

Description 	= string 		
Enable VSS 	= yes|no 	yes 	
Exclude 	{IncludeExcludeItem }		
Ignore File Set Changes 	= yes|no 	no 	
Include 	{IncludeExcludeItem }		
Name 	= name 		required



Description = <string>

    Information only.  
Enable VSS = <yes|no>
    (default: yes)
    If this directive is set to yes the File daemon will be notiﬁed that the user wants to use a Volume Shadow Copy Service (VSS) backup for this job. This directive is eﬀective only on the Windows File Daemon. It permits a consistent copy of open ﬁles to be made for cooperating writer applications, and for applications that are not VSS away, Bareos can at least copy open ﬁles. The Volume Shadow Copy will only be done on Windows drives where the drive (e.g. C:, D:, ...) is explicitly mentioned in a File directive. For more information, please see the Windows chapter of this manual.  
Exclude = <IncludeExcludeItem>

    Describe the ﬁles, that should get excluded from a backup, see section about the FileSet Exclude Ressource.  
Ignore File Set Changes = <yes|no>
    (default: no)
    Normally, if you modify the FileSet Include or Exclude lists, the next backup will be forced to a Full so that Bareos can guarantee that any additions or deletions are properly saved.

    We strongly recommend against setting this directive to yes, since doing so may cause you to have an incomplete set of backups.
    
    If this directive is set to yes, any changes you make to the FileSet Include or Exclude lists, will not force a Full during subsequent backups.  
Include = <IncludeExcludeItem>

    Describe the ﬁles, that should get included to a backup, see section about the FileSet Include Ressource.  
Name = <name>
    (required)
    The name of the resource.

    The name of the FileSet resource.  

#
9.5.1 FileSet Include Ressource

The Include resource must contain a list of directories and/or ﬁles to be processed in the backup job.

Normally, all ﬁles found in all subdirectories of any directory in the Include File list will be backed up. Note, see below for the deﬁnition of <ﬁle-list>. The Include resource may also contain one or more Options resources that specify options such as compression to be applied to all or any subset of the ﬁles found when processing the ﬁle-list for backup. Please see below for more details concerning Options resources.

There can be any number of Include resources within the FileSet, each having its own list of directories or ﬁles to be backed up and the backup options deﬁned by one or more Options resources.

Please take note of the following items in the FileSet syntax:

    There is no equal sign (=) after the Include and before the opening brace ({). The same is true for the Exclude.
    Each directory (or ﬁlename) to be included or excluded is preceded by a File =. Previously they were simply listed on separate lines.
    The Exclude resource does not accept Options.
    When using wild-cards or regular expressions, directory names are always terminated with a slash (/) and ﬁlenames have no trailing slash.

File = < ﬁlename | dirname | |command | ∖<includeﬁle-client | <includeﬁle-server >

    The ﬁle list consists of one ﬁle or directory name per line. Directory names should be speciﬁed without a trailing slash with Unix path notation.
    
    Windows users, please take note to specify directories (even c:/...) in Unix path notation. If you use Windows conventions, you will most likely not be able to restore your ﬁles due to the fact that the Windows path separator was deﬁned as an escape character long before Windows existed, and Bareos adheres to that convention (i.e. means the next character appears as itself).
    
    You should always specify a full path for every directory and ﬁle that you list in the FileSet. In addition, on Windows machines, you should always preﬁx the directory or ﬁlename with the drive speciﬁcation (e.g. c:/xxx) using Unix directory name separators (forward slash). The drive letter itself can be upper or lower case (e.g. c:/xxx or C:/xxx).
    
    Bareos’s default for processing directories is to recursively descend in the directory saving all ﬁles and subdirectories. Bareos will not by default cross ﬁlesystems (or mount points in Unix parlance). This means that if you specify the root partition (e.g. /), Bareos will save only the root partition and not any of the other mounted ﬁlesystems. Similarly on Windows systems, you must explicitly specify each of the drives you want saved (e.g. c:/ and d:/ ...). In addition, at least for Windows systems, you will most likely want to enclose each speciﬁcation within double quotes particularly if the directory (or ﬁle) name contains spaces. The df command on Unix systems will show you which mount points you must specify to save everything. See below for an example.
    
    Take special care not to include a directory twice or Bareos will backup the same ﬁles two times wasting a lot of space on your archive device. Including a directory twice is very easy to do. For example:


      Include {
        Options {
          compression=GZIP
        }
        File = /
        File = /usr
      }


    Conﬁguration 9.5: File Set
    
    on a Unix system where /usr is a subdirectory (rather than a mounted ﬁlesystem) will cause /usr to be backed up twice.
    
    <ﬁle-list> is a list of directory and/or ﬁlename names speciﬁed with a File = directive. To include names containing spaces, enclose the name between double-quotes. Wild-cards are not interpreted in ﬁle-lists. They can only be speciﬁed in Options resources.
    
    There are a number of special cases when specifying directories and ﬁles in a ﬁle-list. They are:
    
        Any name preceded by an at-sign (@) is assumed to be the name of a ﬁle, which contains a list of ﬁles each preceded by a ”File =”. The named ﬁle is read once when the conﬁguration ﬁle is parsed during the Director startup. Note, that the ﬁle is read on the Director’s machine and not on the Client’s. In fact, the @ﬁlename can appear anywhere within the conf ﬁle where a token would be read, and the contents of the named ﬁle will be logically inserted in the place of the @ﬁlename. What must be in the ﬁle depends on the location the @ﬁlename is speciﬁed in the conf ﬁle. For example:


        Include {
          Options {
            compression=GZIP
          }
          @/home/files/my-files
        }


        Conﬁguration 9.6: File Set with Include File
        Any name beginning with a vertical bar (|) is assumed to be the name of a program. This program will be executed on the Director’s machine at the time the Job starts (not when the Director reads the conﬁguration ﬁle), and any output from that program will be assumed to be a list of ﬁles or directories, one per line, to be included. Before submitting the speciﬁed command Bareos will performe character substitution.
    
        This allows you to have a job that, for example, includes all the local partitions even if you change the partitioning by adding a disk. The examples below show you how to do this. However, please note two things:
        1. if you want the local ﬁlesystems, you probably should be using the fstype directive and set onefs=no.
    
        2. the exact syntax of the command needed in the examples below is very system dependent. For example, on recent Linux systems, you may need to add the -P option, on FreeBSD systems, the options will be diﬀerent as well.
    
        In general, you will need to preﬁx your command or commands with a sh -c so that they are invoked by a shell. This will not be the case if you are invoking a script as in the second example below. Also, you must take care to escape (precede with a ∖) wild-cards, shell character, and to ensure that any spaces in your command are escaped as well. If you use a single quotes (’) within a double quote (”), Bareos will treat everything between the single quotes as one ﬁeld so it will not be necessary to escape the spaces. In general, getting all the quotes and escapes correct is a real pain as you can see by the next example. As a consequence, it is often easier to put everything in a ﬁle and simply use the ﬁle name within Bareos. In that case the sh -c will not be necessary providing the ﬁrst line of the ﬁle is #!/bin/sh.
    
        As an example:


        Include {
           Options {
             signature = SHA1
           }
           File = "|sh -c ’df -l | grep \"^/dev/hd[ab]\" | grep -v \".*/tmp\" | awk \"{print \\$6}\"’"
        }


        Conﬁguration 9.7: File Set with inline script
    
        will produce a list of all the local partitions on a Linux system. Quoting is a real problem because you must quote for Bareos which consists of preceding every ∖ and every ” with a ∖, and you must also quote for the shell command. In the end, it is probably easier just to execute a script ﬁle with:


        Include {
          Options {
            signature=MD5
          }
          File = "|my_partitions"
        }


        Conﬁguration 9.8: File Set with external script
    
        where my_partitions has:
        #!/bin/sh  
        df -l | grep "^/dev/hd[ab]" | grep -v ".*/tmp" \  
              | awk "{print \$6}"
    
        If the vertical bar (|) in front of my_partitions is preceded by a backslash as in ∖|, the program will be executed on the Client’s machine instead of on the Director’s machine. Please note that if the ﬁlename is given within quotes, you will need to use two slashes. An example, provided by John Donagher, that backs up all the local UFS partitions on a remote system is:


        FileSet {
          Name = "All local partitions"
          Include {
            Options {
              signature=SHA1
              onefs=yes
            }
            File = "\\|bash -c \"df -klF ufs | tail +2 | awk ’{print \$6}’\""
          }
        }


        Conﬁguration 9.9: File Set with inline script in quotes
    
        The above requires two backslash characters after the double quote (one preserves the next one). If you are a Linux user, just change the ufs to ext3 (or your preferred ﬁlesystem type), and you will be in business.
    
        If you know what ﬁlesystems you have mounted on your system, e.g. for Linux only using ext2, ext3 or ext4, you can backup all local ﬁlesystems using something like:


        Include {
           Options {
             signature = SHA1
             onfs=no
             fstype=ext2
           }
           File = /
        }


        Conﬁguration 9.10: File Set to backup all extfs partions
        Any ﬁle-list item preceded by a less-than sign (<) will be taken to be a ﬁle. This ﬁle will be read on the Director’s machine (see below for doing it on the Client machine) at the time the Job starts, and the data will be assumed to be a list of directories or ﬁles, one per line, to be included. The names should start in column 1 and should not be quoted even if they contain spaces. This feature allows you to modify the external ﬁle and change what will be saved without stopping and restarting Bareos as would be necessary if using the @ modiﬁer noted above. For example:
        Include {  
          Options {  
            signature = SHA1  
          }  
          File = "</home/files/local-filelist"  
        }
    
        If you precede the less-than sign (<) with a backslash as in ∖<, the ﬁle-list will be read on the Client machine instead of on the Director’s machine. Please note that if the ﬁlename is given within quotes, you will need to use two slashes.
        Include {  
          Options {  
            signature = SHA1  
          }  
          File = "\\</home/xxx/filelist-on-client"  
        }
    
        If you explicitly specify a block device such as /dev/hda1, then Bareos will assume that this is a raw partition to be backed up. In this case, you are strongly urged to specify a sparse=yes include option, otherwise, you will save the whole partition rather than just the actual data that the partition contains. For example:


        Include {
          Options {
            signature=MD5
            sparse=yes
          }
          File = /dev/hd6
        }


        Conﬁguration 9.11: Backup Raw Partitions
    
        will backup the data in device /dev/hd6. Note, the bf /dev/hd6 must be the raw partition itself. Bareos will not back it up as a raw device if you specify a symbolic link to a raw device such as my be created by the LVM Snapshot utilities.
        A ﬁle-list may not contain wild-cards. Use directives in the Options resource if you wish to specify wild-cards or regular expression matching.

Exclude Dir Containing = <ﬁlename>

    This directive can be added to the Include section of the FileSet resource. If the speciﬁed ﬁlename (ﬁlename-string) is found on the Client in any directory to be backed up, the whole directory will be ignored (not backed up). We recommend to use the ﬁlename .nobackup, as it is a hidden ﬁle on unix systems, and explains what is the purpose of the ﬁle.
    
    For example:


        # List of files to be backed up
        FileSet {
            Name = "MyFileSet"
            Include {
                Options {
                    signature = MD5
                }
                File = /home
                Exclude Dir Containing = .nobackup
            }
        }



    Conﬁguration 9.12: Exlude Directories containing the ﬁle .nobackup
    
    But in /home, there may be hundreds of directories of users and some people want to indicate that they don’t want to have certain directories backed up. For example, with the above FileSet, if the user or sysadmin creates a ﬁle named .nobackup in speciﬁc directories, such as
        /home/user/www/cache/.nobackup  
        /home/user/temp/.nobackup  


    then Bareos will not backup the two directories named:
        /home/user/www/cache  
        /home/user/temp  


    NOTE: subdirectories will not be backed up. That is, the directive applies to the two directories in question and any children (be they ﬁles, directories, etc).
Plugin = <plugin-name:plugin-parameter1:plugin-parameter2:…>

    Instead of only specifying ﬁles, a ﬁle set can also use plugins. Plugins are additional libraries that handle speciﬁc requirements. The purpose of plugins is to provide an interface to any system program for backup and restore. That allows you, for example, to do database backups without a local dump.
    
    The syntax and semantics of the Plugin directive require the ﬁrst part of the string up to the colon to be the name of the plugin. Everything after the ﬁrst colon is ignored by the File daemon but is passed to the plugin. Thus the plugin writer may deﬁne the meaning of the rest of the string as he wishes.
    
    The program bpluginfo can be used, to retreive information about a speciﬁc plugin.
    
    Examples about the bpipe- and the mssql-plugin can be found in the sections about the bpipe Plugin and the Backup of MSSQL Databases with Bareos Plugin.
    
    Note: It is also possible to deﬁne more than one plugin directive in a FileSet to do several database dumps at once.
Options = <…>

    See the FileSet Options Ressource section.

FileSet Options Ressource

The Options resource is optional, but when speciﬁed, it will contain a list of keyword=value options to be applied to the ﬁle-list. See below for the deﬁnition of ﬁle-list. Multiple Options resources may be speciﬁed one after another. As the ﬁles are found in the speciﬁed directories, the Options will applied to the ﬁlenames to determine if and how the ﬁle should be backed up. The wildcard and regular expression pattern matching parts of the Options resources are checked in the order they are speciﬁed in the FileSet until the ﬁrst one that matches. Once one matches, the compression and other ﬂags within the Options speciﬁcation will apply to the pattern matched.

A key point is that in the absence of an Option or no other Option is matched, every ﬁle is accepted for backing up. This means that if you want to exclude something, you must explicitly specify an Option with an exclude = yes and some pattern matching.

Once Bareos determines that the Options resource matches the ﬁle under consideration, that ﬁle will be saved without looking at any other Options resources that may be present. This means that any wild cards must appear before an Options resource without wild cards.

If for some reason, Bareos checks all the Options resources to a ﬁle under consideration for backup, but there are no matches (generally because of wild cards that don’t match), Bareos as a default will then backup the ﬁle. This is quite logical if you consider the case of no Options clause is speciﬁed, where you want everything to be backed up, and it is important to keep in mind when excluding as mentioned above.

However, one additional point is that in the case that no match was found, Bareos will use the options found in the last Options resource. As a consequence, if you want a particular set of ”default” options, you should put them in an Options resource after any other Options.

It is a good idea to put all your wild-card and regex expressions inside double quotes to prevent conf ﬁle scanning problems.

This is perhaps a bit overwhelming, so there are a number of examples included below to illustrate how this works.

You ﬁnd yourself using a lot of Regex statements, which will cost quite a lot of CPU time, we recommend you simplify them if you can, or better yet convert them to Wild statements which are much more eﬃcient.

The directives within an Options resource may be one of the following:

AutoExclude = <yes|no>
    (default: yes)
    Automatically exclude ﬁles not intended for backup. Currently only used for Windows, to exclude ﬁles deﬁned in the registry key HKEY_LOCAL_MACHINE\SYSTEM \CurrentControlSet \Control \ BackupRestore \FilesNotToBackup , see section FilesNotToBackup Registry Key.  
    Version >= 14.2.2
compression=<GZIP|GZIP1|...|GZIP9|LZO|LZFAST|LZ4|LZ4HC>

    Conﬁgures the software compression to be used by the File Daemon. The compression is done on a ﬁle by ﬁle basis.
    
    Software compression gets important if you are writing to a device that does not support compression by itself (e.g. hard disks). Otherwise, all modern tape drive do support hardware compression. Software compression can also be helpful to reduce the required network bandwidth, as compression is done on the File Daemon. However, using Bareos software compression and device hardware compression together is not advised, as trying to compress precompressed data is a very CPU-intense task and probably end up in even larger data.
    
    You can overwrite this option per Storage resource using the Allow Compression Dir Storage = no option.
    
    compression=GZIP
    
        All ﬁles saved will be software compressed using the GNU ZIP compression format.
    
        Specifying GZIP uses the default compression level 6 (i.e. GZIP is identical to GZIP6). If you want a diﬀerent compression level (1 through 9), you can specify it by appending the level number with no intervening spaces to GZIP. Thus compression=GZIP1 would give minimum compression but the fastest algorithm, and compression=GZIP9 would give the highest level of compression, but requires more computation. According to the GZIP documentation, compression levels greater than six generally give very little extra compression and are rather CPU intensive.
    compression=LZO
    
        All ﬁles saved will be software compressed using the LZO compression format. The compression is done on a ﬁle by ﬁle basis by the File daemon. Everything else about GZIP is true for LZO.
    
        LZO provides much faster compression and decompression speed but lower compression ratio than GZIP. If your CPU is fast enough you should be able to compress your data without making the backup duration longer.
    
        Note that Bareos only use one compression level LZO1X-1 speciﬁed by LZO.
    compression=LZFAST
    
        All ﬁles saved will be software compressed using the LZFAST compression format. The compression is done on a ﬁle by ﬁle basis by the File daemon. Everything else about GZIP is true for LZFAST.
    
        LZFAST provides much faster compression and decompression speed but lower compression ratio than GZIP. If your CPU is fast enough you should be able to compress your data without making the backup duration longer.
    compression=LZ4
    
        All ﬁles saved will be software compressed using the LZ4 compression format. The compression is done on a ﬁle by ﬁle basis by the File daemon. Everything else about GZIP is true for LZ4.
    
        LZ4 provides much faster compression and decompression speed but lower compression ratio than GZIP. If your CPU is fast enough you should be able to compress your data without making the backup duration longer.
    
        Both LZ4 and LZ4HC have the same decompression speed which is about twice the speed of the LZO compression. So for a restore both LZ4 and LZ4HC are good candidates.
    
        Please note! As LZ4 compression is not supported by Bacula, make sure Compatible Fd Client = no.
    compression=LZ4HC
    
        All ﬁles saved will be software compressed using the LZ4HC compression format. The compression is done on a ﬁle by ﬁle basis by the File daemon. Everything else about GZIP is true for LZ4.
    
        LZ4HC is the High Compression version of the LZ4 compression. It has a higher compression ratio than LZ4 and is more comparable to GZIP-6 in both compression rate and cpu usage.
    
        Both LZ4 and LZ4HC have the same decompression speed which is about twice the speed of the LZO compression. So for a restore both LZ4 and LZ4HC are good candidates.
    
        Please note! As LZ4 compression is not supported by Bacula, make sure Compatible Fd Client = no.

signature=<SHA1|MD5>

    signature=SHA1
    
        An SHA1 signature will be computed for all The SHA1 algorithm is purported to be some what slower than the MD5 algorithm, but at the same time is signiﬁcantly better from a cryptographic point of view (i.e. much fewer collisions, much lower probability of being hacked.) It adds four more bytes than the MD5 signature. We strongly recommend that either this option or MD5 be speciﬁed as a default for all ﬁles. Note, only one of the two options MD5 or SHA1 can be computed for any ﬁle.
    signature=MD5
    
        An MD5 signature will be computed for all ﬁles saved. Adding this option generates about 5% extra overhead for each ﬁle saved. In addition to the additional CPU time, the MD5 signature adds 16 more bytes per ﬁle to your catalog. We strongly recommend that this option or the SHA1 option be speciﬁed as a default for all ﬁles.

basejob=<options>

    The options letters speciﬁed are used when running a Backup Level=Full with BaseJobs. The options letters are the same than in the verify= option below.
accurate=<options>
    The options letters speciﬁed are used when running a Backup Level=Incremental/Diﬀerential in Accurate mode. The options letters are the same than in the verify= option below.
verify=<options>

    The options letters speciﬁed are used when running a Verify Level=Catalog as well as the DiskToCatalog level job. The options letters may be any combination of the following:
    
        i compare the inodes
        p compare the permission bits
        n compare the number of links
        u compare the user id
        g compare the group id
        s compare the size
        a compare the access time
        m compare the modiﬁcation time (st_mtime)
        c compare the change time (st_ctime)
        d report ﬁle size decreases
        5 compare the MD5 signature
        1 compare the SHA1 signature
        A Only for Accurate option, it allows to always backup the ﬁle
    
    A useful set of general options on the Level=Catalog or Level=DiskToCatalog verify is pins5 i.e. compare permission bits, inodes, number of links, size, and MD5 changes.
onefs=yes|no

    If set to yes (the default), Bareos will remain on a single ﬁle system. That is it will not backup ﬁle systems that are mounted on a subdirectory. If you are using a *nix system, you may not even be aware that there are several diﬀerent ﬁlesystems as they are often automatically mounted by the OS (e.g. /dev, /net, /sys, /proc, ...). Bareos will inform you when it decides not to traverse into another ﬁlesystem. This can be very useful if you forgot to backup a particular partition. An example of the informational message in the job report is:
    rufus-fd: /misc is a different filesystem. Will not descend from / into /misc  
    rufus-fd: /net is a different filesystem. Will not descend from / into /net  
    rufus-fd: /var/lib/nfs/rpc_pipefs is a different filesystem. Will not descend from /var/lib/nfs into /var/lib/nfs/rpc_pipefs  
    rufus-fd: /selinux is a different filesystem. Will not descend from / into /selinux  
    rufus-fd: /sys is a different filesystem. Will not descend from / into /sys  
    rufus-fd: /dev is a different filesystem. Will not descend from / into /dev  
    rufus-fd: /home is a different filesystem. Will not descend from / into /home
    
    If you wish to backup multiple ﬁlesystems, you can explicitly list each ﬁlesystem you want saved. Otherwise, if you set the onefs option to no, Bareos will backup all mounted ﬁle systems (i.e. traverse mount points) that are found within the FileSet. Thus if you have NFS or Samba ﬁle systems mounted on a directory listed in your FileSet, they will also be backed up. Normally, it is preferable to set onefs=yes and to explicitly name each ﬁlesystem you want backed up. Explicitly naming the ﬁlesystems you want backed up avoids the possibility of getting into a inﬁnite loop recursing ﬁlesystems. Another possibility is to use onefs=no and to set fstype=ext2, .... See the example below for more details.
    
    If you think that Bareos should be backing up a particular directory and it is not, and you have onefs=no set, before you complain, please do:
      stat /  
      stat <filesystem>
    
    where you replace ﬁlesystem with the one in question. If the Device: number is diﬀerent for / and for your ﬁlesystem, then they are on diﬀerent ﬁlesystems. E.g.
    stat /  
      File: ‘/’  
      Size: 4096            Blocks: 16         IO Block: 4096   directory  
    Device: 302h/770d       Inode: 2           Links: 26  
    Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)  
    Access: 2005-11-10 12:28:01.000000000 +0100  
    Modify: 2005-09-27 17:52:32.000000000 +0200  
    Change: 2005-09-27 17:52:32.000000000 +0200  
    
    stat /net  
      File: ‘/home’  
      Size: 4096            Blocks: 16         IO Block: 4096   directory  
    Device: 308h/776d       Inode: 2           Links: 7  
    Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)  
    Access: 2005-11-10 12:28:02.000000000 +0100  
    Modify: 2005-11-06 12:36:48.000000000 +0100  
    Change: 2005-11-06 12:36:48.000000000 +0100
    
    Also be aware that even if you include /home in your list of ﬁles to backup, as you most likely should, you will get the informational message that ”/home is a diﬀerent ﬁlesystem” when Bareos is processing the / directory. This message does not indicate an error. This message means that while examining the File = referred to in the second part of the message, Bareos will not descend into the directory mentioned in the ﬁrst part of the message. However, it is possible that the separate ﬁlesystem will be backed up despite the message. For example, consider the following FileSet:
      File = /  
      File = /var
    
    where /var is a separate ﬁlesystem. In this example, you will get a message saying that Bareos will not decend from / into /var. But it is important to realise that Bareos will descend into /var from the second File directive shown above. In eﬀect, the warning is bogus, but it is supplied to alert you to possible omissions from your FileSet. In this example, /var will be backed up. If you changed the FileSet such that it did not specify /var, then /var will not be backed up.
honor nodump ﬂag=<yes|no>

    If your ﬁle system supports the nodump ﬂag (e. g. most BSD-derived systems) Bareos will honor the setting of the ﬂag when this option is set to yes. Files having this ﬂag set will not be included in the backup and will not show up in the catalog. For directories with the nodump ﬂag set recursion is turned oﬀ and the directory will be listed in the catalog. If the honor nodump ﬂag option is not deﬁned or set to no every ﬁle and directory will be eligible for backup.
portable=yes|no

    If set to yes (default is no), the Bareos File daemon will backup Win32 ﬁles in a portable format, but not all Win32 ﬁle attributes will be saved and restored. By default, this option is set to no, which means that on Win32 systems, the data will be backed up using Windows API calls and on WinNT/2K/XP, all the security and ownership attributes will be properly backed up (and restored). However this format is not portable to other systems – e.g. Unix, Win95/98/Me. When backing up Unix systems, this option is ignored, and unless you have a speciﬁc need to have portable backups, we recommend accept the default (no) so that the maximum information concerning your ﬁles is saved.
recurse=yes|no

    If set to yes (the default), Bareos will recurse (or descend) into all subdirectories found unless the directory is explicitly excluded using an exclude deﬁnition. If you set recurse=no, Bareos will save the subdirectory entries, but not descend into the subdirectories, and thus will not save the ﬁles or directories contained in the subdirectories. Normally, you will want the default (yes).
sparse=yes|no

    Enable special code that checks for sparse ﬁles such as created by ndbm. The default is no, so no checks are made for sparse ﬁles. You may specify sparse=yes even on ﬁles that are not sparse ﬁle. No harm will be done, but there will be a small additional overhead to check for buﬀers of all zero, and if there is a 32K block of all zeros (see below), that block will become a hole in the ﬁle, which may not be desirable if the original ﬁle was not a sparse ﬁle.
    
    Restrictions: Bareos reads ﬁles in 32K buﬀers. If the whole buﬀer is zero, it will be treated as a sparse block and not written to tape. However, if any part of the buﬀer is non-zero, the whole buﬀer will be written to tape, possibly including some disk sectors (generally 4098 bytes) that are all zero. As a consequence, Bareos’s detection of sparse blocks is in 32K increments rather than the system block size. If anyone considers this to be a real problem, please send in a request for change with the reason.
    
    If you are not familiar with sparse ﬁles, an example is say a ﬁle where you wrote 512 bytes at address zero, then 512 bytes at address 1 million. The operating system will allocate only two blocks, and the empty space or hole will have nothing allocated. However, when you read the sparse ﬁle and read the addresses where nothing was written, the OS will return all zeros as if the space were allocated, and if you backup such a ﬁle, a lot of space will be used to write zeros to the volume. Worse yet, when you restore the ﬁle, all the previously empty space will now be allocated using much more disk space. By turning on the sparse option, Bareos will speciﬁcally look for empty space in the ﬁle, and any empty space will not be written to the Volume, nor will it be restored. The price to pay for this is that Bareos must search each block it reads before writing it. On a slow system, this may be important. If you suspect you have sparse ﬁles, you should benchmark the diﬀerence or set sparse for only those ﬁles that are really sparse.
    
    You probably should not use this option on ﬁles or raw disk devices that are not really sparse ﬁles (i.e. have holes in them).
readﬁfo=yes|no

    If enabled, tells the Client to read the data on a backup and write the data on a restore to any FIFO (pipe) that is explicitly mentioned in the FileSet. In this case, you must have a program already running that writes into the FIFO for a backup or reads from the FIFO on a restore. This can be accomplished with the RunBeforeJob directive. If this is not the case, Bareos will hang indeﬁnitely on reading/writing the FIFO. When this is not enabled (default), the Client simply saves the directory entry for the FIFO.
    
    Normally, when Bareos runs a RunBeforeJob, it waits until that script terminates, and if the script accesses the FIFO to write into it, the Bareos job will block and everything will stall. However, Vladimir Stavrinov as supplied tip that allows this feature to work correctly. He simply adds the following to the beginning of the RunBeforeJob script:
       exec > /dev/null


    Include {
      Options {
        signature=SHA1
        readfifo=yes
      }
      File = /home/abc/fifo
    }


    Conﬁguration 9.13: FileSet with Fifo
    
    This feature can be used to do a ”hot” database backup. You can use the RunBeforeJob to create the ﬁfo and to start a program that dynamically reads your database and writes it to the ﬁfo. Bareos will then write it to the Volume.
    
    During the restore operation, the inverse is true, after Bareos creates the ﬁfo if there was any data stored with it (no need to explicitly list it or add any options), that data will be written back to the ﬁfo. As a consequence, if any such FIFOs exist in the ﬁleset to be restored, you must ensure that there is a reader program or Bareos will block, and after one minute, Bareos will time out the write to the ﬁfo and move on to the next ﬁle.
    
    If you are planing to use a Fifo for backup, better take a look to the bpipe Plugin section.
noatime=yes|no

    If enabled, and if your Operating System supports the O_NOATIME ﬁle open ﬂag, Bareos will open all ﬁles to be backed up with this option. It makes it possible to read a ﬁle without updating the inode atime (and also without the inode ctime update which happens if you try to set the atime back to its previous value). It also prevents a race condition when two programs are reading the same ﬁle, but only one does not want to change the atime. It’s most useful for backup programs and ﬁle integrity checkers (and Bareos can ﬁt on both categories).
    
    This option is particularly useful for sites where users are sensitive to their MailBox ﬁle access time. It replaces both the keepatime option without the inconveniences of that option (see below).
    
    If your Operating System does not support this option, it will be silently ignored by Bareos.
mtimeonly=yes|no

    If enabled, tells the Client that the selection of ﬁles during Incremental and Diﬀerential backups should based only on the st_mtime value in the stat() packet. The default is no which means that the selection of ﬁles to be backed up will be based on both the st_mtime and the st_ctime values. In general, it is not recommended to use this option.
keepatime=yes|no

    The default is no. When enabled, Bareos will reset the st_atime (access time) ﬁeld of ﬁles that it backs up to their value prior to the backup. This option is not generally recommended as there are very few programs that use st_atime, and the backup overhead is increased because of the additional system call necessary to reset the times. However, for some ﬁles, such as mailboxes, when Bareos backs up the ﬁle, the user will notice that someone (Bareos) has accessed the ﬁle. In this, case keepatime can be useful. (I’m not sure this works on Win32).
    
    Note, if you use this feature, when Bareos resets the access time, the change time (st_ctime) will automatically be modiﬁed by the system, so on the next incremental job, the ﬁle will be backed up even if it has not changed. As a consequence, you will probably also want to use mtimeonly = yes as well as keepatime (thanks to Rudolf Cejka for this tip).
checkﬁlechanges=yes|no

    If enabled, the Client will check size, age of each ﬁle after their backup to see if they have changed during backup. If time or size mismatch, an error will raise.
     zog-fd: Client1.2007-03-31_09.46.21 Error: /tmp/test mtime changed during backup.
    
    In general, it is recommended to use this option.
hardlinks=yes|no

    When enabled (default), this directive will cause hard links to be backed up. However, the File daemon keeps track of hard linked ﬁles and will backup the data only once. The process of keeping track of the hard links can be quite expensive if you have lots of them (tens of thousands or more). This doesn’t occur on normal Unix systems, but if you use a program like BackupPC, it can create hundreds of thousands, or even millions of hard links. Backups become very long and the File daemon will consume a lot of CPU power checking hard links. In such a case, set hardlinks=no and hard links will not be backed up. Note, using this option will most likely backup more data and on a restore the ﬁle system will not be restored identically to the original.
wild=<string>

    Speciﬁes a wild-card string to be applied to the ﬁlenames and directory names. Note, if Exclude is not enabled, the wild-card will select which ﬁles are to be included. If Exclude=yes is speciﬁed, the wild-card will select which ﬁles are to be excluded. Multiple wild-card directives may be speciﬁed, and they will be applied in turn until the ﬁrst one that matches. Note, if you exclude a directory, no ﬁles or directories below it will be matched.
    
    You may want to test your expressions prior to running your backup by using the bwild program. Please see the Utilities chapter of this manual for more. You can also test your full FileSet deﬁnition by using the estimate command in the Console chapter of this manual. It is recommended to enclose the string in double quotes.
wilddir=<string>

    Speciﬁes a wild-card string to be applied to directory names only. No ﬁlenames will be matched by this directive. Note, if Exclude is not enabled, the wild-card will select directories to be included. If Exclude=yes is speciﬁed, the wild-card will select which directories are to be excluded. Multiple wild-card directives may be speciﬁed, and they will be applied in turn until the ﬁrst one that matches. Note, if you exclude a directory, no ﬁles or directories below it will be matched.
    
    It is recommended to enclose the string in double quotes.
    
    You may want to test your expressions prior to running your backup by using the bwild program. Please see the Utilities chapter of this manual for more. You can also test your full FileSet deﬁnition by using the estimate command in the Console chapter of this manual. An example of excluding with the WildDir option on Win32 machines is presented below.
wildﬁle=<string>

    Speciﬁes a wild-card string to be applied to non-directories. That is no directory entries will be matched by this directive. However, note that the match is done against the full path and ﬁlename, so your wild-card string must take into account that ﬁlenames are preceded by the full path. If Exclude is not enabled, the wild-card will select which ﬁles are to be included. If Exclude=yes is speciﬁed, the wild-card will select which ﬁles are to be excluded. Multiple wild-card directives may be speciﬁed, and they will be applied in turn until the ﬁrst one that matches.
    
    It is recommended to enclose the string in double quotes.
    
    You may want to test your expressions prior to running your backup by using the bwild program. Please see the Utilities chapter of this manual for more. You can also test your full FileSet deﬁnition by using the estimate command in the Console chapter of this manual. An example of excluding with the WildFile option on Win32 machines is presented below.
regex=<string>

    Speciﬁes a POSIX extended regular expression to be applied to the ﬁlenames and directory names, which include the full path. If Exclude is not enabled, the regex will select which ﬁles are to be included. If Exclude=yes is speciﬁed, the regex will select which ﬁles are to be excluded. Multiple regex directives may be speciﬁed within an Options resource, and they will be applied in turn until the ﬁrst one that matches. Note, if you exclude a directory, no ﬁles or directories below it will be matched.
    
    It is recommended to enclose the string in double quotes.
    
    The regex libraries diﬀer from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the bregex program. Please see the Utilities chapter of this manual for more. You can also test your full FileSet deﬁnition by using the estimate command in the Console chapter of this manual.
    
    You ﬁnd yourself using a lot of Regex statements, which will cost quite a lot of CPU time, we recommend you simplify them if you can, or better yet convert them to Wild statements which are much more eﬃcient.
regexﬁle=<string>

    Speciﬁes a POSIX extended regular expression to be applied to non-directories. No directories will be matched by this directive. However, note that the match is done against the full path and ﬁlename, so your regex string must take into account that ﬁlenames are preceded by the full path. If Exclude is not enabled, the regex will select which ﬁles are to be included. If Exclude=yes is speciﬁed, the regex will select which ﬁles are to be excluded. Multiple regex directives may be speciﬁed, and they will be applied in turn until the ﬁrst one that matches.
    
    It is recommended to enclose the string in double quotes.
    
    The regex libraries diﬀer from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the bregex program. Please see the Utilities chapter of this manual for more.
regexdir=<string>

    Speciﬁes a POSIX extended regular expression to be applied to directory names only. No ﬁlenames will be matched by this directive. Note, if Exclude is not enabled, the regex will select directories ﬁles are to be included. If Exclude=yes is speciﬁed, the regex will select which ﬁles are to be excluded. Multiple regex directives may be speciﬁed, and they will be applied in turn until the ﬁrst one that matches. Note, if you exclude a directory, no ﬁles or directories below it will be matched.
    
    It is recommended to enclose the string in double quotes.
    
    The regex libraries diﬀer from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the bregex program. Please see the Utilities chapter of this manual for more.
Exclude = <yes|no>
    (default: no)
    When enabled, any ﬁles matched within the Options will be excluded from the backup.  
aclsupport=yes|no

    The default is no. If this option is set to yes, and you have the POSIX libacl installed on your Linux system, Bareos will backup the ﬁle and directory Unix Access Control Lists (ACL) as deﬁned in IEEE Std 1003.1e draft 17 and ”POSIX.1e” (abandoned). This feature is available on Unix systems only and requires the Linux ACL library. Bareos is automatically compiled with ACL support if the libacl library is installed on your Linux system (shown in conﬁg.out). While restoring the ﬁles Bareos will try to restore the ACLs, if there is no ACL support available on the system, Bareos restores the ﬁles and directories but not the ACL information. Please note, if you backup an EXT3 or XFS ﬁlesystem with ACLs, then you restore them to a diﬀerent ﬁlesystem (perhaps reiserfs) that does not have ACLs, the ACLs will be ignored.
    
    For other operating systems there is support for either POSIX ACLs or the more extensible NFSv4 ACLs.
    
    The ACL stream format between Operation Systems is not compatible so for example an ACL saved on Linux cannot be restored on Solaris.
    
    The following Operating Systems are currently supported:
    
        AIX (pre-5.3 (POSIX) and post 5.3 (POSIX and NFSv4) ACLs)
        Darwin
        FreeBSD (POSIX and NFSv4/ZFS ACLs)
        HPUX
        IRIX
        Linux
        Solaris (POSIX and NFSv4/ZFS ACLs)
        Tru64

xattrsupport=yes|no

    The default is no. If this option is set to yes, and your operating system support either so called Extended Attributes or Extensible Attributes Bareos will backup the ﬁle and directory XATTR data. This feature is available on UNIX only and depends on support of some speciﬁc library calls in libc.
    
    The XATTR stream format between Operating Systems is not compatible so an XATTR saved on Linux cannot for example be restored on Solaris.
    
    On some operating systems ACLs are also stored as Extended Attributes (Linux, Darwin, FreeBSD) Bareos checks if you have the aclsupport option enabled and if so will not save the same info when saving extended attribute information. Thus ACLs are only saved once.
    
    The following Operating Systems are currently supported:
    
        AIX (Extended Attributes)
        Darwin (Extended Attributes)
        FreeBSD (Extended Attributes)
        IRIX (Extended Attributes)
        Linux (Extended Attributes)
        NetBSD (Extended Attributes)
        Solaris (Extended Attributes and Extensible Attributes)
        Tru64 (Extended Attributes)

ignore case=yes|no

    The default is no. On Windows systems, you will almost surely want to set this to yes. When this directive is set to yes all the case of character will be ignored in wild-card and regex comparisons. That is an uppercase A will match a lowercase a.
fstype=ﬁlesystem-type

    This option allows you to select ﬁles and directories by the ﬁlesystem type. The permitted ﬁlesystem-type names are:
    
    ext2, jfs, ntfs, proc, reiserfs, xfs, usbdevfs, sysfs, smbfs, iso9660.
    
    You may have multiple Fstype directives, and thus permit matching of multiple ﬁlesystem types within a single Options resource. If the type speciﬁed on the fstype directive does not match the ﬁlesystem for a particular directive, that directory will not be backed up. This directive can be used to prevent backing up non-local ﬁlesystems. Normally, when you use this directive, you would also set onefs=no so that Bareos will traverse ﬁlesystems.
    
    This option is not implemented in Win32 systems.
DriveType=Windows-drive-type

    This option is eﬀective only on Windows machines and is somewhat similar to the Unix/Linux fstype described above, except that it allows you to select what Windows drive types you want to allow. By default all drive types are accepted.
    
    The permitted drivetype names are:
    
    removable, ﬁxed, remote, cdrom, ramdisk
    
    You may have multiple Driveype directives, and thus permit matching of multiple drive types within a single Options resource. If the type speciﬁed on the drivetype directive does not match the ﬁlesystem for a particular directive, that directory will not be backed up. This directive can be used to prevent backing up non-local ﬁlesystems. Normally, when you use this directive, you would also set onefs=no so that Bareos will traverse ﬁlesystems.
    
    This option is not implemented in Unix/Linux systems.
hfsplussupport=yes|no

    This option allows you to turn on support for Mac OSX HFS plus ﬁnder information.
strippath=<integer>

    This option will cause integer paths to be stripped from the front of the full path/ﬁlename being backed up. This can be useful if you are migrating data from another vendor or if you have taken a snapshot into some subdirectory. This directive can cause your ﬁlenames to be overlayed with regular backup data, so should be used only by experts and with great care.
size=sizeoption

    This option will allow you to select ﬁles by their actual size. You can select either ﬁles smaller than a certain size or bigger then a certain size, ﬁles of a size in a certain range or ﬁles of a size which is within 1 % of its actual size.
    
    The following settings can be used:
    
        <size>-<size> - Select ﬁle in range size - size.
        <size - Select ﬁles smaller than size.
        >size - Select ﬁles bigger than size.
        size - Select ﬁles which are within 1 % of size.

shadowing=none|localwarn|localremove|globalwarn|globalremove

    The default is none. This option performs a check within the ﬁleset for any ﬁle-list entries which are shadowing each other. Lets say you specify / and /usr but /usr is not a separate ﬁlesystem. Then in the normal situation both / and /usr would lead to data being backed up twice.
    
    The following settings can be used:
    
        none - Do NO shadowing check
        localwarn - Do shadowing check within one include block and warn
        localremove - Do shadowing check within one include block and remove duplicates
        globalwarn - Do shadowing check between all include blocks and warn
        globalremove - Do shadowing check between all include blocks and remove duplicates
    
    The local and global part of the setting relate to the fact if the check should be performed only within one include block (local) or between multiple include blocks of the same ﬁleset (global). The warn and remove part of the keyword sets the action e.g. warn the user about shadowing or remove the entry shadowing the other.
    
    Example for a ﬁleset resource with ﬁleset shadow warning enabled:


    FileSet {
      Name = "Test Set"
      Include {
        Options {
          signature = MD5
          shadowing = localwarn
        }
      File = /
      File = /usr
      }
    }


    Conﬁguration 9.14: FileSet resource with ﬁleset shadow warning enabled
meta=tag

    This option will add a meta tag to a ﬁleset. These meta tags are used by the Native NDMP protocol to pass NDMP backup or restore environment variables via the Data Management Agent (DMA) in Bareos to the remote NDMP Data Agent. You can have zero or more metatags which are all passed to the remote NDMP Data Agent.

#
9.5.2 FileSet Exclude Ressource

FileSet Exclude-Ressources very similar to Include-Ressources, except that they only allow following directives:

File = < ﬁlename | directory | |command | ∖<includeﬁle-client | <includeﬁle-server >

    Files to exclude are descripted in the same way as at the FileSet Include Ressource.  

For example:


FileSet {
  Name = Exclusion_example
  Include {
    Options {
      Signature = SHA1
    }
    File = /
    File = /boot
    File = /home
    File = /rescue
    File = /usr
  }
  Exclude {
    File = /proc
    File = /tmp                          # Don’t add trailing /
    File = .journal
    File = .autofsck
  }
}


Conﬁguration 9.15: FileSet using Exclude

Another way to exclude ﬁles and directories is to use the Exclude option from the Include section.

#
9.5.3 FileSet Examples

The following is an example of a valid FileSet resource deﬁnition. Note, the ﬁrst Include pulls in the contents of the ﬁle /etc/backup.list when Bareos is started (i.e. the @), and that ﬁle must have each ﬁlename to be backed up preceded by a File = and on a separate line.


FileSet {
  Name = "Full Set"
  Include {
    Options {
      Compression=GZIP
      signature=SHA1
      Sparse = yes
    }
    @/etc/backup.list
  }
  Include {
     Options {
        wildfile = "*.o"
        wildfile = "*.exe"
        Exclude = yes
     }
     File = /root/myfile
     File = /usr/lib/another_file
  }
}


Conﬁguration 9.16: FileSet using import

In the above example, all the ﬁles contained in /etc/backup.list will be compressed with GZIP compression, an SHA1 signature will be computed on the ﬁle’s contents (its data), and sparse ﬁle handling will apply.

The two directories /root/myfile and /usr/lib/another_file will also be saved without any options, but all ﬁles in those directories with the extensions .o and .exe will be excluded.

Let’s say that you now want to exclude the directory /tmp. The simplest way to do so is to add an exclude directive that lists /tmp. The example above would then become:


FileSet {
  Name = "Full Set"
  Include {
    Options {
      Compression=GZIP
      signature=SHA1
      Sparse = yes
    }
    @/etc/backup.list
  }
  Include {
     Options {
        wildfile = "*.o"
        wildfile = "*.exe"
        Exclude = yes
     }
     File = /root/myfile
     File = /usr/lib/another_file
  }
  Exclude {
     File = /tmp                          # don’t add trailing /
  }
}


Conﬁguration 9.17: extended FileSet excluding /tmp

You can add wild-cards to the File directives listed in the Exclude directory, but you need to take care because if you exclude a directory, it and all ﬁles and directories below it will also be excluded.

Now lets take a slight variation on the above and suppose you want to save all your whole ﬁlesystem except /tmp. The problem that comes up is that Bareos will not normally cross from one ﬁlesystem to another. Doing a df command, you get the following output:


root@linux:~#
df
Filesystem      1k-blocks      Used Available Use% Mounted on
/dev/hda5         5044156    439232   4348692  10% /
/dev/hda1           62193      4935     54047   9% /boot
/dev/hda9        20161172   5524660  13612372  29% /home
/dev/hda2           62217      6843     52161  12% /rescue
/dev/hda8         5044156     42548   4745376   1% /tmp
/dev/hda6         5044156   2613132   2174792  55% /usr
none               127708         0    127708   0% /dev/shm
//minimatou/c$   14099200   9895424   4203776  71% /mnt/mmatou
lmatou:/          1554264    215884   1258056  15% /mnt/matou
lmatou:/home      2478140   1589952    760072  68% /mnt/matou/home
lmatou:/usr       1981000   1199960    678628  64% /mnt/matou/usr
lpmatou:/          995116    484112    459596  52% /mnt/pmatou
lpmatou:/home    19222656   2787880  15458228  16% /mnt/pmatou/home
lpmatou:/usr      2478140   2038764    311260  87% /mnt/pmatou/usr
deuter:/          4806936     97684   4465064   3% /mnt/deuter
deuter:/home      4806904    280100   4282620   7% /mnt/deuter/home
deuter:/files    44133352  27652876  14238608  67% /mnt/deuter/files


Commands 9.18: df

And we see that there are a number of separate ﬁlesystems (/ /boot /home /rescue /tmp and /usr not to mention mounted systems). If you specify only / in your Include list, Bareos will only save the Filesystem /dev/hda5. To save all ﬁlesystems except /tmp with out including any of the Samba or NFS mounted systems, and explicitly excluding a /tmp, /proc, .journal, and .autofsck, which you will not want to be saved and restored, you can use the following:


FileSet {
  Name = Include_example
  Include {
    Options {
       wilddir = /proc
       wilddir = /tmp
       wildfile = "/.journal"
       wildfile = "/.autofsck"
       exclude = yes
    }
    File = /
    File = /boot
    File = /home
    File = /rescue
    File = /usr
  }
}


Conﬁguration 9.19: FileSet mount points

Since /tmp is on its own ﬁlesystem and it was not explicitly named in the Include list, it is not really needed in the exclude list. It is better to list it in the Exclude list for clarity, and in case the disks are changed so that it is no longer in its own partition.

Now, lets assume you only want to backup .Z and .gz ﬁles and nothing else. This is a bit trickier because Bareos by default will select everything to backup, so we must exclude everything but .Z and .gz ﬁles. If we take the ﬁrst example above and make the obvious modiﬁcations to it, we might come up with a FileSet that looks like this:


FileSet {
  Name = "Full Set"
  Include {                    !!!!!!!!!!!!
     Options {                    This
        wildfile = "*.Z"          example
        wildfile = "*.gz"         doesn’t
                                  work
     }                          !!!!!!!!!!!!
     File = /myfile
  }
}


Conﬁguration 9.20: Non-working example

The *.Z and *.gz ﬁles will indeed be backed up, but all other ﬁles that are not matched by the Options directives will automatically be backed up too (i.e. that is the default rule).

To accomplish what we want, we must explicitly exclude all other ﬁles. We do this with the following:


FileSet {
  Name = "Full Set"
  Include {
     Options {
        wildfile = "*.Z"
        wildfile = "*.gz"
     }
     Options {
        Exclude = yes
        RegexFile = ".*"
     }
     File = /myfile
  }
}


Conﬁguration 9.21: Exclude all except speciﬁc wildcards

The ”trick” here was to add a RegexFile expression that matches all ﬁles. It does not match directory names, so all directories in /myﬁle will be backed up (the directory entry) and any *.Z and *.gz ﬁles contained in them. If you know that certain directories do not contain any *.Z or *.gz ﬁles and you do not want the directory entries backed up, you will need to explicitly exclude those directories. Backing up a directory entries is not very expensive.

Bareos uses the system regex library and some of them are diﬀerent on diﬀerent OSes. The above has been reported not to work on FreeBSD. This can be tested by using the estimate job=job-name listing command in the console and adapting the RegexFile expression appropriately.

Please be aware that allowing Bareos to traverse or change ﬁle systems can be very dangerous. For example, with the following:


FileSet {
  Name = "Bad example"
  Include {
    Options {
      onefs=no
    }
    File = /mnt/matou
  }
}


Conﬁguration 9.22: backup all ﬁlesystem below /mnt/matou (use with care)

you will be backing up an NFS mounted partition (/mnt/matou), and since onefs is set to no, Bareos will traverse ﬁle systems. Now if /mnt/matou has the current machine’s ﬁle systems mounted, as is often the case, you will get yourself into a recursive loop and the backup will never end.

As a ﬁnal example, let’s say that you have only one or two subdirectories of /home that you want to backup. For example, you want to backup only subdirectories beginning with the letter a and the letter b – i.e. /home/a* and /home/b*. Now, you might ﬁrst try:


FileSet {
  Name = "Full Set"
  Include {
     Options {
        wilddir = "/home/a*"
        wilddir = "/home/b*"
     }
     File = /home
  }
}


Conﬁguration 9.23: Non-working example

The problem is that the above will include everything in /home. To get things to work correctly, you need to start with the idea of exclusion instead of inclusion. So, you could simply exclude all directories except the two you want to use:


FileSet {
  Name = "Full Set"
  Include {
     Options {
        RegexDir = "^/home/[c-z]"
        exclude = yes
     }
     File = /home
  }
}


Conﬁguration 9.24: Exclude by regex

And assuming that all subdirectories start with a lowercase letter, this would work.

An alternative would be to include the two subdirectories desired and exclude everything else:


FileSet {
  Name = "Full Set"
  Include {
     Options {
        wilddir = "/home/a*"
        wilddir = "/home/b*"
     }
     Options {
        RegexDir = ".*"
        exclude = yes
     }
     File = /home
  }
}


Conﬁguration 9.25: Include and Exclude

The following example shows how to back up only the My Pictures directory inside the My Documents directory for all users in C:/Documents and Settings, i.e. everything matching the pattern:

C:/Documents and Settings/*/My Documents/My Pictures/*

To understand how this can be achieved, there are two important points to remember:

Firstly, Bareos walks over the ﬁlesystem depth-ﬁrst starting from the File = lines. It stops descending when a directory is excluded, so you must include all ancestor directories of each directory containing ﬁles to be included.

Secondly, each directory and ﬁle is compared to the Options clauses in the order they appear in the FileSet. When a match is found, no further clauses are compared and the directory or ﬁle is either included or excluded.

The FileSet resource deﬁnition below implements this by including specifc directories and ﬁles and excluding everything else.


FileSet {
  Name = "AllPictures"

  Include {

    File  = "C:/Documents and Settings"
    
    Options {
      signature = SHA1
      verify = s1
      IgnoreCase = yes
    
      # Include all users’ directories so we reach the inner ones.  Unlike a
      # WildDir pattern ending in *, this RegExDir only matches the top-level
      # directories and not any inner ones.
      RegExDir = "^C:/Documents and Settings/[^/]+$"
    
      # Ditto all users’ My Documents directories.
      WildDir = "C:/Documents and Settings/*/My Documents"
    
      # Ditto all users’ My Documents/My Pictures directories.
      WildDir = "C:/Documents and Settings/*/My Documents/My Pictures"
    
      # Include the contents of the My Documents/My Pictures directories and
      # any subdirectories.
      Wild = "C:/Documents and Settings/*/My Documents/My Pictures/*"
    }
    
    Options {
      Exclude = yes
      IgnoreCase = yes
    
      # Exclude everything else, in particular any files at the top level and
      # any other directories or files in the users’ directories.
      Wild = "C:/Documents and Settings/*"
    }
  }
}


Conﬁguration 9.26: Include/Exclude example

#
9.5.4 Windows FileSets

If you are entering Windows ﬁle names, the directory path may be preceded by the drive and a colon (as in c:). However, the path separators must be speciﬁed in Unix convention (i.e. forward slash (/)). If you wish to include a quote in a ﬁle name, precede the quote with a backslash (∖). For example you might use the following for a Windows machine to backup the ”My Documents” directory:


FileSet {
  Name = "Windows Set"
  Include {
    Options {
       WildFile = "*.obj"
       WildFile = "*.exe"
       exclude = yes
     }
     File = "c:/My Documents"
  }
}


Conﬁguration 9.27: Windows FileSet

For exclude lists to work correctly on Windows, you must observe the following rules:

    Filenames are case sensitive, so you must use the correct case.
    To exclude a directory, you must not have a trailing slash on the directory name.
    If you have spaces in your ﬁlename, you must enclose the entire name in double-quote characters (”). Trying to use a backslash before the space will not work.
    If you are using the old Exclude syntax (noted below), you may not specify a drive letter in the exclude. The new syntax noted above should work ﬁne including driver letters.

Thanks to Thiago Lima for summarizing the above items for us. If you are having diﬃculties getting includes or excludes to work, you might want to try using the estimate job=xxx listing command documented in the Console chapter of this manual.

On Win32 systems, if you move a directory or ﬁle or rename a ﬁle into the set of ﬁles being backed up, and a Full backup has already been made, Bareos will not know there are new ﬁles to be saved during an Incremental or Diﬀerential backup (blame Microsoft, not us). To avoid this problem, please copy any new directory or ﬁles into the backup area. If you do not have enough disk to copy the directory or ﬁles, move them, but then initiate a Full backup.

Example Fileset for Windows The following example demostrates a Windows FileSet. It backups all data from all ﬁxed drives and only excludes some Windows temporary data.


FileSet {
  Name = "Windows All Drives"
  Enable VSS = yes
  Include {
    Options {
      Signature = MD5
      Drive Type = fixed
      IgnoreCase = yes
      WildFile = "[A-Z]:/pagefile.sys"
      WildDir = "[A-Z]:/RECYCLER"
      WildDir = "[A-Z]:/$RECYCLE.BIN"
      WildDir = "[A-Z]:/System Volume Information"
      Exclude = yes
    }
    File = /
  }
}


Conﬁguration 9.28: Windows All Drives FileSet

File = / includes all Windows drives. Using Drive Type = fixed excludes drives like USB-Stick or CD-ROM Drive. Using WildDir = "[A-Z]:/RECYCLER" excludes the backup of the directory RECYCLER from all drives.

#
9.5.5 Testing Your FileSet

If you wish to get an idea of what your FileSet will really backup or if your exclusion rules will work correctly, you can test it by using the estimate command in the Console program. See the estimate in the Console chapter of this manual.

As an example, suppose you add the following test FileSet:


FileSet {
  Name = Test
  Include {
    File = /home/xxx/test
    Options {
       regex = ".*\\.c$"
    }
  }
}


Conﬁguration 9.29: FileSet for all *.c ﬁles

You could then add some test ﬁles to the directory /home/xxx/test and use the following command in the console:


estimate job=<any−job−name> listing client=<desired−client> fileset=Test


bconsole 9.30: estimate

to give you a listing of all ﬁles that match. In the above example, it should be only ﬁles with names ending in .c.

#
9.6 Client Resource

The Client (or FileDaemon) resource deﬁnes the attributes of the Clients that are served by this Director; that is the machines that are to be backed up. You will need one Client resource deﬁnition for each machine to be backed up.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		required
Allow Client Connect 	= yes|no 		alias, deprecated
Auth Type 	= None|Clear|MD5	None 	
Auto Prune 	= yes|no 	no 	
Catalog 	= resource-name 		
Connection From Client To Director	= yes|no 	no 	
Connection From Director To Client	= yes|no 	yes 	
Description 	= string 		
Enabled 	= yes|no 	yes 	
FD Address 	= string 		alias
FD Password 	= password 		alias
FD Port 	= positive-integer 	9102 	alias
File Retention 	= time 	5184000 	
Hard Quota 	= Size64 	0 	
Heartbeat Interval 	= time 	0 	
Job Retention 	= time 	15552000 	
Maximum Bandwidth Per Job 	= speed 		
Maximum Concurrent Jobs 	= positive-integer 	1 	
Name 	= name 		required

NDMP Block Size 	= positive-integer 	64512 	
NDMP Log Level 	= positive-integer 	4 	
NDMP Use LMDB 	= yes|no 	yes 	
Passive 	= yes|no 	no 	
Password 	= password 		required
Port 	= positive-integer 	9102 	
Protocol 	= AuthProtocolType	Native
Quota Include Failed Jobs 	= yes|no 	yes 	
Soft Quota 	= Size64 	0 	
Soft Quota Grace Period 	= time 	0 	
Strict Quotas 	= yes|no 	no 	
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		
TLS Enable 	= yes|no 	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer	= yes|no	yes
Username 	= string		


Address = <string>
    (required)
    Where the address is a host name, a fully qualiﬁed domain name, or a network address in dotted quad notation for a Bareos File server daemon. This directive is required.  
Allow Client Connect = <yes|no>

    Please note! This directive is deprecated.
    Alias of ”Connection From Client To Director”.


Auth Type = <None|Clear|MD5>
    (default: None)
    Speciﬁes the authentication type that must be supplied when connecting to a backup protocol that uses a speciﬁc authentication type.  
Auto Prune = <yes|no>
    (default: no)
    If AutoPrune is set to yes, Bareos will automatically apply the File retention period and the Job retention period for the Client at the end of the Job. If you leave the default AutoPrune = no, pruning will not be done, and your Catalog will grow in size each time you run a Job. Pruning aﬀects only information in the catalog and not data stored in the backup archives (on Volumes), but if pruning deletes all data referring to a certain volume, the volume is regarded as empty and will possibly be overwritten before the volume retention has expired.  
Catalog = <resource-name>

    This speciﬁes the name of the catalog resource to be used for this Client. If none is speciﬁed the ﬁrst deﬁned catalog is used.  
Connection From Client To Director = <yes|no>
    (default: no)
    The Director will accept incoming network connection from this Client.

    For details, see Client Initiated Connection.  
    Version >= 16.2.2
Connection From Director To Client = <yes|no>
    (default: yes)
    Let the Director initiate the network connection to the Client.


    Version >= 16.2.2
Description = <string>


Enabled = <yes|no>
    (default: yes)
    En- or disable this resource.


FD Address = <string>

    Alias for Address.


FD Password = <password>

    This directive is an alias.


FD Port = <positive-integer>
    (default: 9102)
    This directive is an alias.

    Where the port is a port number at which the Bareos File server daemon can be contacted. The default is 9102. For NDMP backups set this to 10000.  
File Retention = <time>
    (default: 5184000)
    The File Retention directive deﬁnes the length of time that Bareos will keep File records in the Catalog database after the End time of the Job corresponding to the File records. When this time period expires, and if AutoPrune is set to yes Bareos will prune (remove) File records that are older than the speciﬁed File Retention period. Note, this aﬀects only records in the catalog database. It does not aﬀect your archive backups.

    File records may actually be retained for a shorter period than you specify on this directive if you specify either a shorter Job Retention Dir Client or a shorter Volume Retention Dir Pool period. The shortest retention period of the three takes precedence. The time may be expressed in seconds, minutes, hours, days, weeks, months, quarters, or years. See the Conﬁguration chapter of this manual for additional details of time speciﬁcation.
    
    The default is 60 days.  
Hard Quota = <Size64>
    (default: 0)
    The amount of data determined by the Hard Quota directive sets the hard limit of backup space that cannot be exceeded. This is the maximum amount this client can back up before any backup job will be aborted.

    If the Hard Quota is exceeded, the running job is terminated:
    
    Fatal error: append.c:218 Quota Exceeded. Job Terminated.


Heartbeat Interval = <time>
    (default: 0)
    This directive is optional and if speciﬁed will cause the Director to set a keepalive interval (heartbeat) in seconds on each of the sockets it opens for the Storage resource. This value will override any speciﬁed at the Director level. It is implemented only on systems (Linux, ...) that provide the setsockopt TCP_KEEPIDLE function. The default value is zero, which means no change is made to the socket.  
Job Retention = <time>
    (default: 15552000)
    The Job Retention directive deﬁnes the length of time that Bareos will keep Job records in the Catalog database after the Job End time. When this time period expires, and if Auto Prune Dir Client is set to yes Bareos will prune (remove) Job records that are older than the speciﬁed File Retention period. As with the other retention periods, this aﬀects only records in the catalog and not data in your archive backup.

    If a Job record is selected for pruning, all associated File and JobMedia records will also be pruned regardless of the File Retention period set. As a consequence, you normally will set the File retention period to be less than the Job retention period. The Job retention period can actually be less than the value you specify here if you set the Volume Retention Dir Pool directive to a smaller duration. This is because the Job retention period and the Volume retention period are independently applied, so the smaller of the two takes precedence.
    
    The Job retention period is speciﬁed as seconds, minutes, hours, days, weeks, months, quarters, or years. See the Conﬁguration chapter of this manual for additional details of time speciﬁcation.
    
    The default is 180 days.  
Maximum Bandwidth Per Job = <speed>

    The speed parameter speciﬁes the maximum allowed bandwidth that a job may use when started for this Client. The speed parameter should be speciﬁed in k/s, Kb/s, m/s or Mb/s.  
Maximum Concurrent Jobs = <positive-integer>
    (default: 1)
    This directive speciﬁes the maximum number of Jobs with the current Client that can run concurrently. Note, this directive limits only Jobs for Clients with the same name as the resource in which it appears. Any other restrictions on the maximum concurrent jobs such as in the Director, Job or Storage resources will also apply in addition to any limit speciﬁed here.  
Name = <name>
    (required)
    The name of the resource.

    The client name which will be used in the Job resource directive or in the console run command.  
NDMP Block Size = <positive-integer>
    (default: 64512)
    This directive sets the default NDMP blocksize for this client.  
NDMP Log Level = <positive-integer>
    (default: 4)
    This directive sets the loglevel for the NDMP protocol library.  
NDMP Use LMDB = <yes|no>
    (default: yes)

Passive = <yes|no>
    (default: no)
    If enabled, the Storage Daemon will initiate the network connection to the Client. If disabled, the Client will initiate the netowrk connection to the Storage Daemon.

    The normal way of initializing the data channel (the channel where the backup data itself is transported) is done by the ﬁle daemon (client) that connects to the storage daemon.
    
    By using the client passive mode, the initialization of the datachannel is reversed, so that the storage daemon connects to the ﬁledaemon.
    
    See chapter Passive Client.  
    Version >= 13.2.0
Password = <password>
    (required)
    This is the password to be used when establishing a connection with the File services, so the Client conﬁguration ﬁle on the machine to be backed up must have the same password deﬁned for this Director. If you have either /dev/random or bc on your machine, Bareos will generate a random password during the conﬁguration process, otherwise it will be left blank.

    The password is plain text. It is not generated through any special process, but it is preferable for security reasons to make the text random.  
Port = <positive-integer>
    (default: 9102)

Protocol = <Native|NDMP>
    (default: Native)
    The backup protocol to use to run the Job.

    Currently the director understands the following protocols:
    
        Native - The native Bareos protocol
        NDMP - The NDMP protocol


    Version >= 13.2.0
Quota Include Failed Jobs = <yes|no>
    (default: yes)
    When calculating the amount a client used take into consideration any failed Jobs.  
Soft Quota = <Size64>
    (default: 0)
    This is the amount after which there will be a warning issued that a client is over his softquota. A client can keep doing backups until it hits the hard quota or when the Soft Quota Grace Period Dir Client is expired.  
Soft Quota Grace Period = <time>
    (default: 0)
    Time allowed for a client to be over its Soft Quota Dir Client before it will be enforced.

    When the amount of data backed up by the client outruns the value speciﬁed by the Soft Quota directive, the next start of a backup job will start the soft quota grace time period. This is written to the job log:
    
    Error: Softquota Exceeded, Grace Period starts now.
    
    In the Job Overview, the value of Grace Expiry Date: will then change from Soft Quota was never exceeded to the date when the grace time expires, e.g. 11-Dec-2012 04:09:05.
    
    During that period, it is possible to do backups even if the total amount of stored data exceeds the limit speciﬁed by soft quota.
    
    If in this state, the job log will write:
    
    Error: Softquota Exceeded, will be enforced after Grace Period expires.
    
    After the grace time expires, in the next backup job of the client, the value for Burst Quota will be set to the value that the client has stored at this point in time. Also, the job will be terminated. The following information in the job log shows what happened:
    
    Warning: Softquota Exceeded and Grace Period expired.
    Setting Burst Quota to 122880000 Bytes.
    Fatal error: Soft Quota Exceeded / Grace Time expired. Job terminated.
    
    At this point, it is not possible to do any backup of the client. To be able to do more backups, the amount of stored data for this client has to fall under the burst quota value.  
Strict Quotas = <yes|no>
    (default: no)
    The directive Strict Quotas determines whether, after the Grace Time Period is over, to enforce the Burst Limit (Strict Quotas = No) or the Soft Limit (Strict Quotas = Yes).

    The Job Log shows either
    
    Softquota Exceeded, enforcing Burst Quota Limit.
    
    or
    
    Softquota Exceeded, enforcing Strict Quota Limit.


TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see, how the Bareos Director (and the other components) must be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Username = <string>

    Speciﬁes the username that must be supplied when authenticating. Only used for the non Native protocols at the moment.



The following is an example of a valid Client resource deﬁnition:


Client {
  Name = client1-fd
  Address = client1.example.com
  Password = "secret"
}


Conﬁguration 9.31: Minimal client resource deﬁnition in bareos-dir.conf

The following is an example of a Quota Conﬁguration in Client resource:


Client {
  Name = client1-fd
  Address = client1.example.com
  Password = "secret"

  # Quota
  Soft Quota = 50 mb
  Soft Quota Grace Period = 2 days
  Strict Quotas = Yes
  Hard Quota = 150 mb
  Quota Include Failed Jobs = yes
}


Conﬁguration 9.32: Quota Conﬁguration in Client resource

#
9.7 Storage Resource

The Storage resource deﬁnes which Storage daemons are available for use by the Director.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		required
Allow Compression 	= yes|no 	yes 	
Auth Type 	= None|Clear|MD5	None 	
Auto Changer 	= yes|no 	no 	
Cache Status Interval 	= time 	30 	
Changer Device 	= strname 		
Collect Statistics 	= yes|no 	no 	
Description 	= string 		
Device 	= Device 		required
Enabled 	= yes|no 	yes 	
Heartbeat Interval 	= time 	0 	
Maximum Bandwidth Per Job 	= speed 		
Maximum Concurrent Jobs 	= positive-integer 	1 	
Maximum Concurrent Read Jobs	= positive-integer 	0 	
Media Type 	= strname 		required
Name 	= name 		required
Paired Storage 	= resource-name 		
Password 	= password 		required
Port 	= positive-integer 	9103 	

Protocol 	= AuthProtocolType	Native
SD Address 	= string 		alias
SD Password 	= password 		alias
SD Port 	= positive-integer 	9103 	alias
Sdd Port 	= positive-integer 		deprecated
Tape Device 	= string-list 		
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		
TLS Enable 	= yes|no 	no 	
TLS Key 	= path 		
TLS Require 	= yes|no 	no 	
TLS Verify Peer 	= yes|no 	yes 	
Username 	= string 		


Address = <string>
    (required)
    Where the address is a host name, a fully qualiﬁed domain name, or an IP address. Please note that the <address> as speciﬁed here will be transmitted to the File daemon who will then use it to contact the Storage daemon. Hence, it is not, a good idea to use localhost as the name but rather a fully qualiﬁed machine name or an IP address. This directive is required.  
Allow Compression = <yes|no>
    (default: yes)
    This directive is optional, and if you specify No, it will cause backups jobs running on this storage resource to run without client File Daemon compression. This eﬀectively overrides compression options in FileSets used by jobs which use this storage resource.  
Auth Type = <None|Clear|MD5>
    (default: None)
    Speciﬁes the authentication type that must be supplied when connecting to a backup protocol that uses a speciﬁc authentication type.  
Auto Changer = <yes|no>
    (default: no)
    If you specify yes for this command, when you use the label command or the add command to create a new Volume, Bareos will also request the Autochanger Slot number. This simpliﬁes creating database entries for Volumes in an autochanger. If you forget to specify the Slot, the autochanger will not be used. However, you may modify the Slot associated with a Volume at any time by using the update volume or update slots command in the console program. When autochanger is enabled, the algorithm used by Bareos to search for available volumes will be modiﬁed to consider only Volumes that are known to be in the autochanger’s magazine. If no in changer volume is found, Bareos will attempt recycling, pruning, ..., and if still no volume is found, Bareos will search for any volume whether or not in the magazine. By privileging in changer volumes, this procedure minimizes operator intervention.

    For the autochanger to be used, you must also specify Autochanger = yes in the Autochanger Sd Device in the Storage daemon’s conﬁguration ﬁle as well as other important Storage daemon conﬁguration information. Please consult the Autochanger Support chapter for the details of using autochangers.  
Cache Status Interval = <time>
    (default: 30)

Changer Device = <strname>


Collect Statistics = <yes|no>
    (default: no)
    Collect statistic information. These information will be collected by the Director (see Statistics Collect Interval Dir Director) and stored in the Catalog.  
Description = <string>

    Information.  
Device = <Device>
    (required)
    This directive speciﬁes the Storage daemon’s name of the device resource to be used for the storage. If you are using an Autochanger, the name speciﬁed here should be the name of the Storage daemon’s Autochanger resource rather than the name of an individual device. This name is not the physical device name, but the logical device name as deﬁned on the Name directive contained in the Device or the Autochanger resource deﬁnition of the Storage daemon conﬁguration ﬁle. You can specify any name you would like (even the device name if you prefer) up to a maximum of 127 characters in length. The physical device name associated with this device is speciﬁed in the Storage daemon conﬁguration ﬁle (as Archive Device). Please take care not to deﬁne two diﬀerent Storage resource directives in the Director that point to the same Device in the Storage daemon. Doing so may cause the Storage daemon to block (or hang) attempting to open the same device that is already open. This directive is required.  
Enabled = <yes|no>
    (default: yes)
    En- or disable this resource.


Heartbeat Interval = <time>
    (default: 0)
    This directive is optional and if speciﬁed will cause the Director to set a keepalive interval (heartbeat) in seconds on each of the sockets it opens for the Storage resource. This value will override any speciﬁed at the Director level. It is implemented only on systems (Linux, ...) that provide the setsockopt TCP_KEEPIDLE function. The default value is zero, which means no change is made to the socket.  
Maximum Bandwidth Per Job = <speed>


Maximum Concurrent Jobs = <positive-integer>
    (default: 1)
    This directive speciﬁes the maximum number of Jobs with the current Storage resource that can run concurrently. Note, this directive limits only Jobs for Jobs using this Storage daemon. Any other restrictions on the maximum concurrent jobs such as in the Director, Job or Client resources will also apply in addition to any limit speciﬁed here.

    If you set the Storage daemon’s number of concurrent jobs greater than one, we recommend that you read Concurrent Jobs and/or turn data spooling on as documented in Data Spooling.  
Maximum Concurrent Read Jobs = <positive-integer>
    (default: 0)
    This directive speciﬁes the maximum number of Jobs with the current Storage resource that can read concurrently.  
Media Type = <strname>
    (required)
    This directive speciﬁes the Media Type to be used to store the data. This is an arbitrary string of characters up to 127 maximum that you deﬁne. It can be anything you want. However, it is best to make it descriptive of the storage media (e.g. File, DAT, ”HP DLT8000”, 8mm, ...). In addition, it is essential that you make the Media Type speciﬁcation unique for each storage media type. If you have two DDS-4 drives that have incompatible formats, or if you have a DDS-4 drive and a DDS-4 autochanger, you almost certainly should specify diﬀerent Media Types. During a restore, assuming a DDS-4 Media Type is associated with the Job, Bareos can decide to use any Storage daemon that supports Media Type DDS-4 and on any drive that supports it.

    If you are writing to disk Volumes, you must make doubly sure that each Device resource deﬁned in the Storage daemon (and hence in the Director’s conf ﬁle) has a unique media type. Otherwise Bareos may assume, these Volumes can be mounted and read by any Storage daemon File device.
    
    Currently Bareos permits only a single Media Type per Storage Device deﬁnition. Consequently, if you have a drive that supports more than one Media Type, you can give a unique string to Volumes with diﬀerent intrinsic Media Type (Media Type = DDS-3-4 for DDS-3 and DDS-4 types), but then those volumes will only be mounted on drives indicated with the dual type (DDS-3-4).
    
    If you want to tie Bareos to using a single Storage daemon or drive, you must specify a unique Media Type for that drive. This is an important point that should be carefully understood. Note, this applies equally to Disk Volumes. If you deﬁne more than one disk Device resource in your Storage daemon’s conf ﬁle, the Volumes on those two devices are in fact incompatible because one can not be mounted on the other device since they are found in diﬀerent directories. For this reason, you probably should use two diﬀerent Media Types for your two disk Devices (even though you might think of them as both being File types). You can ﬁnd more on this subject in the Basic Volume Management chapter of this manual.
    
    The MediaType speciﬁed in the Director’s Storage resource, must correspond to the Media Type speciﬁed in the Device resource of the Storage daemon conﬁguration ﬁle. This directive is required, and it is used by the Director and the Storage daemon to ensure that a Volume automatically selected from the Pool corresponds to the physical device. If a Storage daemon handles multiple devices (e.g. will write to various ﬁle Volumes on diﬀerent partitions), this directive allows you to specify exactly which device.
    
    As mentioned above, the value speciﬁed in the Director’s Storage resource must agree with the value speciﬁed in the Device resource in the Storage daemon’s conﬁguration ﬁle. It is also an additional check so that you don’t try to write data for a DLT onto an 8mm device.  
Name = <name>
    (required)
    The name of the resource.

    The name of the storage resource. This name appears on the Storage directive speciﬁed in the Job resource and is required.  
Paired Storage = <resource-name>

    For NDMP backups this points to the deﬁnition of the Native Storage that is accesses via the NDMP protocol. For now we only support NDMP backups and restores to access Native Storage Daemons via the NDMP protocol. In the future we might allow to use Native NDMP storage which is not bound to a Bareos Storage Daemon.  
Password = <password>
    (required)
    This is the password to be used when establishing a connection with the Storage services. This same password also must appear in the Director resource of the Storage daemon’s conﬁguration ﬁle. This directive is required.

    The password is plain text.  
Port = <positive-integer>
    (default: 9103)
    Where port is the port to use to contact the storage daemon for information and to start jobs. This same port number must appear in the Storage resource of the Storage daemon’s conﬁguration ﬁle.  
Protocol = <AuthProtocolType>
    (default: Native)

SD Address = <string>

    Alias for Address.


SD Password = <password>

    Alias for Password.


SD Port = <positive-integer>
    (default: 9103)
    Alias for Port.


Sdd Port = <positive-integer>

    Please note! This directive is deprecated.

Tape Device = <string-list>


TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. For details, refer to chapter TLS Conﬁguration Directives.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Username = <string>



The following is an example of a valid Storage resource deﬁnition:


Storage {
  Name = DLTDrive
  Address = lpmatou
  Password = storage_password # password for Storage daemon
  Device = "HP DLT 80"    # same as Device in Storage daemon
  Media Type = DLT8000    # same as MediaType in Storage daemon
}


Conﬁguration 9.33: Storage resource (tape) example

#
9.8 Pool Resource

The Pool resource deﬁnes the set of storage Volumes (tapes or ﬁles) to be used by Bareos to write the data. By conﬁguring diﬀerent Pools, you can determine which set of Volumes (media) receives the backup data. This permits, for example, to store all full backup data on one set of Volumes and all incremental backups on another set of Volumes. Alternatively, you could assign a diﬀerent set of Volumes to each machine that you backup. This is most easily done by deﬁning multiple Pools.

Another important aspect of a Pool is that it contains the default attributes (Maximum Jobs, Retention Period, Recycle ﬂag, ...) that will be given to a Volume when it is created. This avoids the need for you to answer a large number of questions when labeling a new Volume. Each of these attributes can later be changed on a Volume by Volume basis using the update command in the console program. Note that you must explicitly specify which Pool Bareos is to use with each Job. Bareos will not automatically search for the correct Pool.

Most often in Bareos installations all backups for all machines (Clients) go to a single set of Volumes. In this case, you will probably only use the Default Pool. If your backup strategy calls for you to mount a diﬀerent tape each day, you will probably want to deﬁne a separate Pool for each day. For more information on this subject, please see the Backup Strategies chapter of this manual.

To use a Pool, there are three distinct steps. First the Pool must be deﬁned in the Director’s conﬁguration ﬁle. Then the Pool must be written to the Catalog database. This is done automatically by the Director each time that it starts, or alternatively can be done using the create command in the console program. Finally, if you change the Pool deﬁnition in the Director’s conﬁguration ﬁle and restart Bareos, the pool will be updated alternatively you can use the update pool console command to refresh the database image. It is this database image rather than the Director’s resource image that is used for the default Volume attributes. Note, for the pool to be automatically created or updated, it must be explicitly referenced by a Job resource.

Next the physical media must be labeled. The labeling can either be done with the label command in the console program or using the btape program. The preferred method is to use the label command in the console program.

Finally, you must add Volume names (and their attributes) to the Pool. For Volumes to be used by Bareos they must be of the same Media Type as the archive device speciﬁed for the job (i.e. if you are going to back up to a DLT device, the Pool must have DLT volumes deﬁned since 8mm volumes cannot be mounted on a DLT drive). The Media Type has particular importance if you are backing up to ﬁles. When running a Job, you must explicitly specify which Pool to use. Bareos will then automatically select the next Volume to use from the Pool, but it will ensure that the Media Type of any Volume selected from the Pool is identical to that required by the Storage resource you have speciﬁed for the Job.

If you use the label command in the console program to label the Volumes, they will automatically be added to the Pool, so this last step is not normally required.

It is also possible to add Volumes to the database without explicitly labeling the physical volume. This is done with the add console command.

As previously mentioned, each time Bareos starts, it scans all the Pools associated with each Catalog, and if the database record does not already exist, it will be created from the Pool Resource deﬁnition. Bareos probably should do an update pool if you change the Pool deﬁnition, but currently, you must do this manually using the update pool command in the Console program.

The Pool Resource deﬁned in the Director’s conﬁguration ﬁle (bareos-dir.conf) may contain the following directives:


conﬁguration directive name

type of data

default value

remark

Action On Purge 	= ActionOnPurge		
Auto Prune 	= yes|no 	yes 	
Catalog 	= resource-name 		
Catalog Files 	= yes|no 	yes 	
Cleaning Preﬁx 	= strname 	CLN 	
Description 	= string 		
File Retention 	= time 		
Job Retention 	= time 		
Label Format 	= strname 		
Label Type 	= Label 		
Maximum Block Size 	= positive-integer		
Maximum Volume Bytes 	= Size64 		
Maximum Volume Files 	= positive-integer		
Maximum Volume Jobs 	= positive-integer		
Maximum Volumes 	= positive-integer		
Migration High Bytes 	= Size64 		
Migration Low Bytes 	= Size64 		
Migration Time 	= time 		
Minimum Block Size 	= positive-integer		

Name 	= name 		required
Next Pool 	= resource-name		
Pool Type 	= Pooltype 	Backup 	
Purge Oldest Volume 	= yes|no 	no 	
Recycle 	= yes|no 	yes 	
Recycle Current Volume	= yes|no 	no 	
Recycle Oldest Volume 	= yes|no 	no 	
Recycle Pool 	= resource-name		
Scratch Pool 	= resource-name		
Storage 	= ResourceList		
Use Catalog 	= yes|no 	yes 	
Use Volume Once 	= yes|no 		deprecated
Volume Retention 	= time 	31536000
Volume Use Duration 	= time 		


Action On Purge = <ActionOnPurge>

    This directive Action On Purge=Truncate instructs Bareos to truncate the volume when it is purged with the Purge Volume Action=Truncate command. It is useful to prevent disk based volumes from consuming too much space.
    
    Pool {
      Name = Default
      Action On Purge = Truncate
      ...
    }
    
    You can schedule the truncate operation at the end of your CatalogBackup job like in this example:
    
    Job {
      Name = CatalogBackup
      ...
      RunScript {
        RunsWhen=After
        RunsOnClient=No
        Console = "purge volume action=all allpools storage=File"
      }
    }


Auto Prune = <yes|no>
    (default: yes)
    If AutoPrune is set to yes, Bareos will automatically apply the Volume Retention period when new Volume is needed and no appendable Volumes exist in the Pool. Volume pruning causes expired Jobs (older than the Volume Retention period) to be deleted from the Catalog and permits possible recycling of the Volume.  
Catalog = <resource-name>

    This speciﬁes the name of the catalog resource to be used for this Pool. When a catalog is deﬁned in a Pool it will override the deﬁnition in the client (and the Catalog deﬁnition in a Job since Version >= 13.4.0). e.g. this catalog setting takes precedence over any other deﬁnition.  
Catalog Files = <yes|no>
    (default: yes)
    This directive deﬁnes whether or not you want the names of the ﬁles that were saved to be put into the catalog. If disabled, the Catalog database will be signiﬁcantly smaller. The disadvantage is that you will not be able to produce a Catalog listing of the ﬁles backed up for each Job (this is often called Browsing). Also, without the File entries in the catalog, you will not be able to use the Console restore command nor any other command that references File entries.  
Cleaning Preﬁx = <strname>
    (default: CLN)
    This directive deﬁnes a preﬁx string, which if it matches the beginning of a Volume name during labeling of a Volume, the Volume will be deﬁned with the VolStatus set to Cleaning and thus Bareos will never attempt to use this tape. This is primarily for use with autochangers that accept barcodes where the convention is that barcodes beginning with CLN are treated as cleaning tapes.

    The default value for this directive is consequently set to CLN, so that in most cases the cleaning tapes are automatically recognized without conﬁguration. If you use another preﬁx for your cleaning tapes, you can set this directive accordingly.  
Description = <string>


File Retention = <time>

    The File Retention directive deﬁnes the length of time that Bareos will keep File records in the Catalog database after the End time of the Job corresponding to the File records.
    
    This directive takes precedence over Client directives of the same name. For example, you can decide to increase Retention times for Archive or OﬀSite Pool.
    
    Note, this aﬀects only records in the catalog database. It does not aﬀect your archive backups.
    
    For more information see Client documentation about File Retention Dir Client  
Job Retention = <time>

    The Job Retention directive deﬁnes the length of time that Bareos will keep Job records in the Catalog database after the Job End time. As with the other retention periods, this aﬀects only records in the catalog and not data in your archive backup.
    
    This directive takes precedence over Client directives of the same name. For example, you can decide to increase Retention times for Archive or OﬀSite Pool.
    
    For more information see Client side documentation Job Retention Dir Client  
Label Format = <strname>

    This directive speciﬁes the format of the labels contained in this pool. The format directive is used as a sort of template to create new Volume names during automatic Volume labeling.
    
    The format should be speciﬁed in double quotes ("), and consists of letters, numbers and the special characters hyphen (-), underscore (_), colon (:), and period (.), which are the legal characters for a Volume name.
    
    In addition, the format may contain a number of variable expansion characters which will be expanded by a complex algorithm allowing you to create Volume names of many diﬀerent formats. In all cases, the expansion process must resolve to the set of characters noted above that are legal Volume names. Generally, these variable expansion characters begin with a dollar sign ($) or a left bracket ([). For more details on variable expansion, please see Variable Expansion on Volume Labels.
    
    If no variable expansion characters are found in the string, the Volume name will be formed from the format string appended with the a unique number that increases. If you do not remove volumes from the pool, this number should be the number of volumes plus one, but this is not guaranteed. The unique number will be edited as four digits with leading zeros. For example, with a Label Format = "File-", the ﬁrst volumes will be named File-0001, File-0002, ...
    
    In almost all cases, you should enclose the format speciﬁcation (part after the equal sign) in double quotes (").  
Label Type = <ANSI|IBM|Bareos>

    This directive is implemented in the Director Pool resource and in the SD Device resource (Label Type Sd Device). If it is speciﬁed in the SD Device resource, it will take precedence over the value passed from the Director to the SD.  
Maximum Block Size = <positive-integer>

    The Maximum Block Size can be deﬁned here to deﬁne diﬀerent block sizes per volume or statically for all volumes at Maximum Block Size Sd Device. If not deﬁned, its default is 63 KB. Increasing this value could improve the throughput of writing to tapes.
    
    Please note! However make sure to read the Setting Block Sizes chapter carefully before applying any changes.  
    Version >= 14.2.0
Maximum Volume Bytes = <Size64>

    This directive speciﬁes the maximum number of bytes that can be written to the Volume. If you specify zero (the default), there is no limit except the physical size of the Volume. Otherwise, when the number of bytes written to the Volume equals size the Volume will be marked Used. When the Volume is marked Used it can no longer be used for appending Jobs, much like the Full status but it can be recycled if recycling is enabled, and thus the Volume can be re-used after recycling. This value is checked and the Used status set while the job is writing to the particular volume.
    
    This directive is particularly useful for restricting the size of disk volumes, and will work correctly even in the case of multiple simultaneous jobs writing to the volume.
    
    The value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.  
Maximum Volume Files = <positive-integer>

    This directive speciﬁes the maximum number of ﬁles that can be written to the Volume. If you specify zero (the default), there is no limit. Otherwise, when the number of ﬁles written to the Volume equals positive-integer the Volume will be marked Used. When the Volume is marked Used it can no longer be used for appending Jobs, much like the Full status but it can be recycled if recycling is enabled and thus used again. This value is checked and the Used status is set only at the end of a job that writes to the particular volume.
    
    The value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.  
Maximum Volume Jobs = <positive-integer>

    This directive speciﬁes the maximum number of Jobs that can be written to the Volume. If you specify zero (the default), there is no limit. Otherwise, when the number of Jobs backed up to the Volume equals positive-integer the Volume will be marked Used. When the Volume is marked Used it can no longer be used for appending Jobs, much like the Full status but it can be recycled if recycling is enabled, and thus used again. By setting MaximumVolumeJobs to one, you get the same eﬀect as setting UseVolumeOnce = yes.
    
    The value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.
    
    If you are running multiple simultaneous jobs, this directive may not work correctly because when a drive is reserved for a job, this directive is not taken into account, so multiple jobs may try to start writing to the Volume. At some point, when the Media record is updated, multiple simultaneous jobs may fail since the Volume can no longer be written.  
Maximum Volumes = <positive-integer>

    This directive speciﬁes the maximum number of volumes (tapes or ﬁles) contained in the pool. This directive is optional, if omitted or set to zero, any number of volumes will be permitted. In general, this directive is useful for Autochangers where there is a ﬁxed number of Volumes, or for File storage where you wish to ensure that the backups made to disk ﬁles do not become too numerous or consume too much space.  
Migration High Bytes = <Size64>

    This directive speciﬁes the number of bytes in the Pool which will trigger a migration if Selection Type Dir Job = PoolOccupancy has been speciﬁed. The fact that the Pool usage goes above this level does not automatically trigger a migration job. However, if a migration job runs and has the PoolOccupancy selection type set, the Migration High Bytes will be applied. Bareos does not currently restrict a pool to have only a single Media Type Dir Storage, so you must keep in mind that if you mix Media Types in a Pool, the results may not be what you want, as the Pool count of all bytes will be for all Media Types combined.  
Migration Low Bytes = <Size64>

    This directive speciﬁes the number of bytes in the Pool which will stop a migration if Selection Type Dir Job = PoolOccupancy has been speciﬁed and triggered by more than Migration High Bytes Dir Pool being in the pool. In other words, once a migration job is started with PoolOccupancy migration selection and it determines that there are more than Migration High Bytes, the migration job will continue to run jobs until the number of bytes in the Pool drop to or below Migration Low Bytes.  
Migration Time = <time>

    If Selection Type Dir Job = PoolTime, the time speciﬁed here will be used. If the previous Backup Job or Jobs selected have been in the Pool longer than the speciﬁed time, then they will be migrated.  
Minimum Block Size = <positive-integer>

    The Minimum Block Size can be deﬁned here to deﬁne diﬀerent block sizes per volume or statically for all volumes at Minimum Block Size Sd Device. For details, see chapter Setting Block Sizes.  
Name = <name>
    (required)
    The name of the resource.

    The name of the pool.  
Next Pool = <resource-name>

    This directive speciﬁes the pool a Migration or Copy Job and a Virtual Backup Job will write their data too. This directive is required to deﬁne the Pool into which the data will be migrated. Without this directive, the migration job will terminate in error.  
Pool Type = <Pooltype>
    (default: Backup)
    This directive deﬁnes the pool type, which corresponds to the type of Job being run. It is required and may be one of the following:

    Backup
    *Archive
    *Cloned
    *Migration
    *Copy
    *Save
    
    Note, only Backup is currently implemented.  
Purge Oldest Volume = <yes|no>
    (default: no)
    This directive instructs the Director to search for the oldest used Volume in the Pool when another Volume is requested by the Storage daemon and none are available. The catalog is then purged irrespective of retention periods of all Files and Jobs written to this Volume. The Volume is then recycled and will be used as the next Volume to be written. This directive overrides any Job, File, or Volume retention periods that you may have speciﬁed.

    This directive can be useful if you have a ﬁxed number of Volumes in the Pool and you want to cycle through them and reusing the oldest one when all Volumes are full, but you don’t want to worry about setting proper retention periods. However, by using this option you risk losing valuable data.
    
    Please note! Be aware that Purge Oldest Volume disregards all retention periods. If you have only a single Volume deﬁned and you turn this variable on, that Volume will always be immediately overwritten when it ﬁlls! So at a minimum, ensure that you have a decent number of Volumes in your Pool before running any jobs. If you want retention periods to apply do not use this directive.
    We highly recommend against using this directive, because it is sure that some day, Bareos will purge a Volume that contains current data.  
Recycle = <yes|no>
    (default: yes)
    This directive speciﬁes whether or not Purged Volumes may be recycled. If it is set to yes (default) and Bareos needs a volume but ﬁnds none that are appendable, it will search for and recycle (reuse) Purged Volumes (i.e. volumes with all the Jobs and Files expired and thus deleted from the Catalog). If the Volume is recycled, all previous data written to that Volume will be overwritten. If Recycle is set to no, the Volume will not be recycled, and hence, the data will remain valid. If you want to reuse (re-write) the Volume, and the recycle ﬂag is no (0 in the catalog), you may manually set the recycle ﬂag (update command) for a Volume to be reused.

    Please note that the value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.
    
    When all Job and File records have been pruned or purged from the catalog for a particular Volume, if that Volume is marked as Append, Full, Used, or Error, it will then be marked as Purged. Only Volumes marked as Purged will be considered to be converted to the Recycled state if the Recycle directive is set to yes.  
Recycle Current Volume = <yes|no>
    (default: no)
    If Bareos needs a new Volume, this directive instructs Bareos to Prune the volume respecting the Job and File retention periods. If all Jobs are pruned (i.e. the volume is Purged), then the Volume is recycled and will be used as the next Volume to be written. This directive respects any Job, File, or Volume retention periods that you may have speciﬁed, and thus it is much better to use it rather than the Purge Oldest Volume directive.

    This directive can be useful if you have: a ﬁxed number of Volumes in the Pool, you want to cycle through them, and you have speciﬁed retention periods that prune Volumes before you have cycled through the Volume in the Pool.
    
    However, if you use this directive and have only one Volume in the Pool, you will immediately recycle your Volume if you ﬁll it and Bareos needs another one. Thus your backup will be totally invalid. Please use this directive with care.  
Recycle Oldest Volume = <yes|no>
    (default: no)
    This directive instructs the Director to search for the oldest used Volume in the Pool when another Volume is requested by the Storage daemon and none are available. The catalog is then pruned respecting the retention periods of all Files and Jobs written to this Volume. If all Jobs are pruned (i.e. the volume is Purged), then the Volume is recycled and will be used as the next Volume to be written. This directive respects any Job, File, or Volume retention periods that you may have speciﬁed, and as such it is much better to use this directive than the Purge Oldest Volume.

    This directive can be useful if you have a ﬁxed number of Volumes in the Pool and you want to cycle through them and you have speciﬁed the correct retention periods.
    
    However, if you use this directive and have only one Volume in the Pool, you will immediately recycle your Volume if you ﬁll it and Bareos needs another one. Thus your backup will be totally invalid. Please use this directive with care.  
Recycle Pool = <resource-name>

    This directive deﬁnes to which pool the Volume will be placed (moved) when it is recycled. Without this directive, a Volume will remain in the same pool when it is recycled. With this directive, it can be moved automatically to any existing pool during a recycle. This directive is probably most useful when deﬁned in the Scratch pool, so that volumes will be recycled back into the Scratch pool. For more on the see the Scratch Pool section of this manual.
    
    Although this directive is called RecyclePool, the Volume in question is actually moved from its current pool to the one you specify on this directive when Bareos prunes the Volume and discovers that there are no records left in the catalog and hence marks it as Purged.  
Scratch Pool = <resource-name>

    This directive permits to specify a dedicate Scratch for the current pool. This pool will replace the special pool named Scrach for volume selection. For more information about Scratch see Scratch Pool section of this manual. This is useful when using multiple storage sharing the same mediatype or when you want to dedicate volumes to a particular set of pool.  
Storage = <ResourceList>

    The Storage directive deﬁnes the name of the storage services where you want to backup the FileSet data. For additional details, see the Storage Resource of this manual. The Storage resource may also be speciﬁed in the Job resource, but the value, if any, in the Pool resource overrides any value in the Job. This Storage resource deﬁnition is not required by either the Job resource or in the Pool, but it must be speciﬁed in one or the other. If not conﬁguration error will result. We highly recommend that you deﬁne the Storage resource to be used in the Pool rather than elsewhere (job, schedule run, ...). Be aware that you theoretically can give a list of storages here but only the ﬁrst item from the list is actually used for backup and restore jobs.  
Use Catalog = <yes|no>
    (default: yes)
    Store information into Catalog. In all pratical use cases, leave this value to its defaults.


Use Volume Once = <yes|no>

    Please note! This directive is deprecated.
    Use Maximum Volume Jobs Dir Pool = 1 instead.  
Volume Retention = <time>
    (default: 31536000)
    The Volume Retention directive deﬁnes the length of time that Bareos will keep records associated with the Volume in the Catalog database after the End time of each Job written to the Volume. When this time period expires, and if AutoPrune is set to yes Bareos may prune (remove) Job records that are older than the speciﬁed Volume Retention period if it is necessary to free up a Volume. Recycling will not occur until it is absolutely necessary to free up a volume (i.e. no other writable volume exists). All File records associated with pruned Jobs are also pruned. The time may be speciﬁed as seconds, minutes, hours, days, weeks, months, quarters, or years. The Volume Retention is applied independently of the Job Retention and the File Retention periods deﬁned in the Client resource. This means that all the retentions periods are applied in turn and that the shorter period is the one that eﬀectively takes precedence. Note, that when the Volume Retention period has been reached, and it is necessary to obtain a new volume, Bareos will prune both the Job and the File records. This pruning could also occur during a status dir command because it uses similar algorithms for ﬁnding the next available Volume.

    It is important to know that when the Volume Retention period expires, Bareos does not automatically recycle a Volume. It attempts to keep the Volume data intact as long as possible before over writing the Volume.
    
    By deﬁning multiple Pools with diﬀerent Volume Retention periods, you may eﬀectively have a set of tapes that is recycled weekly, another Pool of tapes that is recycled monthly and so on. However, one must keep in mind that if your Volume Retention period is too short, it may prune the last valid Full backup, and hence until the next Full backup is done, you will not have a complete backup of your system, and in addition, the next Incremental or Diﬀerential backup will be promoted to a Full backup. As a consequence, the minimum Volume Retention period should be at twice the interval of your Full backups. This means that if you do a Full backup once a month, the minimum Volume retention period should be two months.
    
    The default Volume retention period is 365 days, and either the default or the value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.  
Volume Use Duration = <time>

    The Volume Use Duration directive deﬁnes the time period that the Volume can be written beginning from the time of ﬁrst data write to the Volume. If the time-period speciﬁed is zero (the default), the Volume can be written indeﬁnitely. Otherwise, the next time a job runs that wants to access this Volume, and the time period from the ﬁrst write to the volume (the ﬁrst Job written) exceeds the time-period-speciﬁcation, the Volume will be marked Used, which means that no more Jobs can be appended to the Volume, but it may be recycled if recycling is enabled. Once the Volume is recycled, it will be available for use again.
    
    You might use this directive, for example, if you have a Volume used for Incremental backups, and Volumes used for Weekly Full backups. Once the Full backup is done, you will want to use a diﬀerent Incremental Volume. This can be accomplished by setting the Volume Use Duration for the Incremental Volume to six days. I.e. it will be used for the 6 days following a Full save, then a diﬀerent Incremental volume will be used. Be careful about setting the duration to short periods such as 23 hours, or you might experience problems of Bareos waiting for a tape over the weekend only to complete the backups Monday morning when an operator mounts a new tape.
    
    Please note that the value deﬁned by this directive in the bareos-dir.conf ﬁle is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf ﬁle will not change what is stored for the Volume. To change the value for an existing Volume you must use the update volume command in the Console.  

In order for a Pool to be used during a Backup Job, the Pool must have at least one Volume associated with it. Volumes are created for a Pool using the label or the add commands in the Bareos Console, program. In addition to adding Volumes to the Pool (i.e. putting the Volume names in the Catalog database), the physical Volume must be labeled with a valid Bareos software volume label before Bareos will accept the Volume. This will be automatically done if you use the label command. Bareos can automatically label Volumes if instructed to do so, but this feature is not yet fully implemented.

The following is an example of a valid Pool resource deﬁnition:


Pool {
  Name = Default
  Pool Type = Backup
}


Conﬁguration 9.34: Pool resource example

#
9.8.1 Scratch Pool

In general, you can give your Pools any name you wish, but there is one important restriction: the Pool named Scratch, if it exists behaves like a scratch pool of Volumes in that when Bareos needs a new Volume for writing and it cannot ﬁnd one, it will look in the Scratch pool, and if it ﬁnds an available Volume, it will move it out of the Scratch pool into the Pool currently being used by the job.

#
9.9 Catalog Resource

The Catalog Resource deﬁnes what catalog to use for the current job. Currently, Bareos can only handle a single database server (SQLite, MySQL, PostgreSQL) that is deﬁned when conﬁguring Bareos. However, there may be as many Catalogs (databases) deﬁned as you wish. For example, you may want each Client to have its own Catalog database, or you may want backup jobs to use one database and verify or restore jobs to use another database.

Since SQLite is compiled in, it always runs on the same machine as the Director and the database must be directly accessible (mounted) from the Director. However, since both MySQL and PostgreSQL are networked databases, they may reside either on the same machine as the Director or on a diﬀerent machine on the network. See below for more details.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		alias
DB Address 	= string 		
DB Driver 	= string 		required
DB Name 	= string 		required
DB Password 	= password 		
DB Port 	= positive-integer		
DB Socket 	= string 		
DB User 	= string 		
Description 	= string 		
Disable Batch Insert 	= yes|no 	no 	
Exit On Fatal 	= yes|no 	no 	
Idle Timeout 	= positive-integer	30 	
Inc Connections 	= positive-integer	1 	
Max Connections 	= positive-integer	5 	
Min Connections 	= positive-integer	1 	
Multiple Connections 	= yes|no 		
Name 	= name 		required
Password 	= password 		alias
Reconnect 	= yes|no 	no 	

User 	= string 		alias
Validate Timeout	= positive-integer	120


Address = <string>

    This directive is an alias.
    
    Alias for DB Address Dir Catalog.  
DB Address = <string>

    This is the host address of the database server. Normally, you would specify this instead of DB Socket Dir Catalog if the database server is on another machine. In that case, you will also specify DB Port Dir Catalog. This directive is used only by MySQL and PostgreSQL and is ignored by SQLite if provided.  
DB Driver = <postgresql | mysql | sqlite>
    (required)
    Selects the database type to use.  
DB Name = <string>
    (required)
    This speciﬁes the name of the database.  
DB Password = <password>

    This speciﬁes the password to use when login into the database.  
DB Port = <positive-integer>

    This deﬁnes the port to be used in conjunction with DB Address Dir Catalog to access the database if it is on another machine. This directive is used only by MySQL and PostgreSQL and is ignored by SQLite if provided.  
DB Socket = <string>

    This is the name of a socket to use on the local host to connect to the database. This directive is used only by MySQL and is ignored by SQLite. Normally, if neither DB Socket Dir Catalog or DB Address Dir Catalog are speciﬁed, MySQL will use the default socket. If the DB Socket is speciﬁed, the MySQL server must reside on the same machine as the Director.  
DB User = <string>

    This speciﬁes what user name to use to log into the database.  
Description = <string>


Disable Batch Insert = <yes|no>
    (default: no)
    This directive allows you to override at runtime if the Batch insert should be enabled or disabled. Normally this is determined by querying the database library if it is thread-safe. If you think that disabling Batch insert will make your backup run faster you may disable it using this option and set it to Yes.  
Exit On Fatal = <yes|no>
    (default: no)
    Make any fatal error in the connection to the database exit the program


    Version >= 15.1.0
Idle Timeout = <positive-integer>
    (default: 30)
    This directive is used by the experimental database pooling functionality. Only use this for non production sites. This sets the idle time after which a database pool should be shrinked.  
Inc Connections = <positive-integer>
    (default: 1)
    This directive is used by the experimental database pooling functionality. Only use this for non production sites. This sets the number of connections to add to a database pool when not enough connections are available on the pool anymore.  
Max Connections = <positive-integer>
    (default: 5)
    This directive is used by the experimental database pooling functionality. Only use this for non production sites. This sets the maximum number of connections to a database to keep in this database pool.  
Min Connections = <positive-integer>
    (default: 1)
    This directive is used by the experimental database pooling functionality. Only use this for non production sites. This sets the minimum number of connections to a database to keep in this database pool.  
Multiple Connections = <yes|no>

    Not yet implemented.  
Name = <name>
    (required)
    The name of the resource.

    The name of the Catalog. No necessary relation to the database server name. This name will be speciﬁed in the Client resource directive indicating that all catalog data for that Client is maintained in this Catalog.  
Password = <password>

    This directive is an alias.
    
    Alias for DB Password Dir Catalog.  
Reconnect = <yes|no>
    (default: no)
    Try to reconnect a database connection when its dropped


    Version >= 15.1.0
User = <string>

    This directive is an alias.
    
    Alias for DB User Dir Catalog.  
Validate Timeout = <positive-integer>
    (default: 120)
    This directive is used by the experimental database pooling functionality. Only use this for non production sites. This sets the validation timeout after which the database connection is polled to see if its still alive.  

The following is an example of a valid Catalog resource deﬁnition:


Catalog
{
  Name = SQLite
  DB Driver = sqlite
  DB Name = bareos;
  DB User = bareos;
  DB Password = ""
}


Conﬁguration 9.35: Catalog Resource for Sqlite

or for a Catalog on another machine:


Catalog
{
  Name = MySQL
  DB Driver = mysql
  DB Name = bareos
  DB User = bareos
  DB Password = "secret"
  DB Address = remote.example.com
  DB Port = 1234
}


Conﬁguration 9.36: Catalog Resource for remote MySQL

#
9.10 Messages Resource

For the details of the Messages Resource, please see the Messages Resource of this manual.

#
9.11 Console Resource

There are three diﬀerent kinds of consoles, which the administrator or user can use to interact with the Director. These three kinds of consoles comprise three diﬀerent security levels.

Default Console
    the ﬁrst console type is an “anonymous” or “default” console, which has full privileges. There is no console resource necessary for this type since the password is speciﬁed in the Director’s resource and consequently such consoles do not have a name as deﬁned on a Name directive. Typically you would use it only for administrators.
Named Console
    the second type of console, is a “named” console (also called “Restricted Console”) deﬁned within a Console resource in both the Director’s conﬁguration ﬁle and in the Console’s conﬁguration ﬁle. Both the names and the passwords in these two entries must match much as is the case for Client programs.

    This second type of console begins with absolutely no privileges except those explicitly speciﬁed in the Director’s Console resource. Thus you can have multiple Consoles with diﬀerent names and passwords, sort of like multiple users, each with diﬀerent privileges. As a default, these consoles can do absolutely nothing – no commands whatsoever. You give them privileges or rather access to commands and resources by specifying access control lists in the Director’s Console resource. The ACLs are speciﬁed by a directive followed by a list of access names. Examples of this are shown below.
    
        The third type of console is similar to the above mentioned one in that it requires a Console resource deﬁnition in both the Director and the Console. In addition, if the console name, provided on the Name Dir Console directive, is the same as a Client name, that console is permitted to use the SetIP command to change the Address directive in the Director’s client resource to the IP address of the Console. This permits portables or other machines using DHCP (non-ﬁxed IP addresses) to ”notify” the Director of their current IP address.

The Console resource is optional and need not be speciﬁed. The following directives are permitted within the Director’s conﬁguration resource:


conﬁguration directive name

type of data

default value

remark

Catalog ACL 	= acl 		
Client ACL 	= acl 		
Command ACL 	= acl 		
Description 	= string 		
File Set ACL 	= acl 		
Job ACL 	= acl 		
Name 	= name 		required
Password 	= password 		required
Plugin Options ACL 	= acl 		
Pool ACL 	= acl 		
Proﬁle 	= ResourceList		
Run ACL 	= acl 		
Schedule ACL 	= acl 		
Storage ACL 	= acl 		
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		

TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string		
TLS DH File 	= path 		
TLS Enable 	= yes|no	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer 	= yes|no	yes
Where ACL 	= acl 		


Catalog ACL = <acl>

    This directive is used to specify a list of Catalog resource names that can be accessed by the console.  
Client ACL = <acl>

    This directive is used to specify a list of Client resource names that can be accessed by the console.  
Command ACL = <acl>

    This directive is used to specify a list of of console commands that can be executed by the console.  
Description = <string>


File Set ACL = <acl>

    This directive is used to specify a list of FileSet resource names that can be accessed by the console.  
Job ACL = <acl>

    This directive is used to specify a list of Job resource names that can be accessed by the console. Without this directive, the console cannot access any of the Director’s Job resources. Multiple Job resource names may be speciﬁed by separating them with commas, and/or by specifying multiple JobACL directives. For example, the directive may be speciﬁed as:
    
    JobACL = "Backup client 1", "Backup client 2"
    JobACL = "RestoreFiles"
    
    With the above speciﬁcation, the console can access the Director’s resources for the four jobs named on the JobACL directives, but for no others.  
Name = <name>
    (required)
    The name of the console. This name must match the name speciﬁed in the Console’s conﬁguration resource (much as is the case with Client deﬁnitions).  
Password = <password>
    (required)
    Speciﬁes the password that must be supplied for a named Bareos Console to be authorized. The same password must appear in the Console resource of the Console conﬁguration ﬁle. For added security, the password is never actually passed across the network but rather a challenge response hash code created with the password. This directive is required.

    The password is plain text. It is preferable for security reasons to choose random text.  
Plugin Options ACL = <acl>


Pool ACL = <acl>

    This directive is used to specify a list of Pool resource names that can be accessed by the console.  
Proﬁle = <ResourceList>

    Proﬁles can be assigned to a Console. ACL are checked until either a deny ACL is found or an allow ACL. First the console ACL is checked then any proﬁle the console is linked to.
    
    One or more Proﬁle names can be assigned to a Console. If an ACL is not deﬁned in the Console, the proﬁles of the Console will be checked in the order as speciﬁed here. The ﬁrst found ACL will be used. See Proﬁle Resource.  
    Version >= 14.2.3
Run ACL = <acl>


Schedule ACL = <acl>

    This directive is used to specify a list of Schedule resource names that can be accessed by the console.  
Storage ACL = <acl>

    This directive is used to specify a list of Storage resource names that can be accessed by the console.  
TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see, how the Bareos Director (and the other components) must be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Where ACL = <acl>

    This directive permits you to specify where a restricted console can restore ﬁles. If this directive is not speciﬁed, only the default restore location is permitted (normally /tmp/bareos-restores. If all is speciﬁed any path the user enters will be accepted (not very secure), any other value speciﬁed (there may be multiple WhereACL directives) will restrict the user to use that path. For example, on a Unix system, if you specify ”/”, the ﬁle will be restored to the original location. This directive is untested.  

Aside from Director resource names and console command names, the special keyword *all* can be speciﬁed in any of the above access control lists. When this keyword is present, any resource or command name (which ever is appropriate) will be accepted. For an example conﬁguration ﬁle, please see the Console Conﬁguration chapter of this manual.

#
9.12 Proﬁle Resource

The Proﬁle Resource deﬁnes a set of ACLs. Console Resources can be tight to one or more proﬁles (Proﬁle Dir Console), making it easier to use a common set of ACLs.


conﬁguration directive name

type of data

default value

remark

Catalog ACL 	= acl 		
Client ACL 	= acl 		
Command ACL 	= acl 		
Description 	= string 		
File Set ACL 	= acl 		
Job ACL 	= acl 		
Name 	= name 		required
Plugin Options ACL 	= acl 		
Pool ACL 	= acl 		
Schedule ACL 	= acl 		
Storage ACL 	= acl 		
Where ACL 	= acl 		



Catalog ACL = <acl>

    Lists the Catalog resources, this resource has access to. The special keyword *all* allows access to all Catalog resources.


Client ACL = <acl>

    Lists the Client resources, this resource has access to. The special keyword *all* allows access to all Client resources.


Command ACL = <acl>

    Lists the commands, this resource has access to. The special keyword *all* allows using commands.


Description = <string>

    Additional information about the resource. Only used for UIs.


File Set ACL = <acl>

    Lists the File Set resources, this resource has access to. The special keyword *all* allows access to all File Set resources.


Job ACL = <acl>

    Lists the Job resources, this resource has access to. The special keyword *all* allows access to all Job resources.


Name = <name>
    (required)
    The name of the resource.


Plugin Options ACL = <acl>

    Speciﬁes the allowed plugin options. An empty strings allows all Plugin Options.


Pool ACL = <acl>

    Lists the Pool resources, this resource has access to. The special keyword *all* allows access to all Pool resources.


Schedule ACL = <acl>

    Lists the Schedule resources, this resource has access to. The special keyword *all* allows access to all Schedule resources.


Storage ACL = <acl>

    Lists the Storage resources, this resource has access to. The special keyword *all* allows access to all Storage resources.


Where ACL = <acl>

    Speciﬁes the base directories, where ﬁles could be restored. An empty string allows restores to all directories.



#
9.13 Counter Resource

The Counter Resource deﬁnes a counter variable that can be accessed by variable expansion used for creating Volume labels with the Label Format Dir Pool directive.


conﬁguration directive name

type of data

default value

remark

Catalog 	= resource-name 		
Description 	= string 		
Maximum 	= positive-integer	2147483647 	
Minimum 	= Int32 	0 	
Name 	= name 		required
Wrap Counter 	= resource-name 		



Catalog = <resource-name>

    If this directive is speciﬁed, the counter and its values will be saved in the speciﬁed catalog. If this directive is not present, the counter will be redeﬁned each time that Bareos is started.  
Description = <string>


Maximum = <positive-integer>
    (default: 2147483647)
    This is the maximum value value that the counter can have. If not speciﬁed or set to zero, the counter can have a maximum value of 2,147,483,648 (2 to the 31 power). When the counter is incremented past this value, it is reset to the Minimum.  
Minimum = <Int32>
    (default: 0)
    This speciﬁes the minimum value that the counter can have. It also becomes the default. If not supplied, zero is assumed.  
Name = <name>
    (required)
    The name of the resource.

    The name of the Counter. This is the name you will use in the variable expansion to reference the counter value.  
Wrap Counter = <resource-name>

    If this value is speciﬁed, when the counter is incremented past the maximum and thus reset to the minimum, the counter speciﬁed on the Wrap Counter Dir Counter is incremented. (This is currently not implemented).  

#
9.14 Example Director Conﬁguration File

See below an example of a full Director conﬁguration ﬁle:

#
# Default Bareos Director configuration file for disk-only backup
# (C) 2013 Bareos GmbH & Co.KG
#
# Each configuration item has a reference number that shows
# where this property can be changed in the configuration file.
# Search for the number to find the correct line.
#
# You have to configure the following accoring to your environment:
#
# (#01)Email Address for bareos disaster recovery.
#      Specify a mailaddress outside of your backupserver.
#      There will be one mail per day.
#
# (#02)Email Address for bareos reports. (Mail Command)
#      This mail address will recieve a report about each backup job.
#      It will be sent after the backupjob is complete.
#      Has to be configured twice ("Standard" and "Daemon" Message Ressources)
#
# (#03)Email Address for bareos operator. (Operator Command)
#      This mail address will recieve a mail immediately when the
#      bareos system needs an operator intervention.
#      May be the same address as in (#02)
#
#
# This disk-only setup stores all data into @archivedir@
#
# The preconfigured backup scheme is as follows:
#
#   Full Backups are done on first Saturday at 21:00              (#04)
#   Full Backups are written into the "Full" Pool                 (#05)
#   Full Backups are kept for 365 Days                            (#06)
#
#   Differential Backups are done on 2nd to 5th Saturday at 21:00 (#07)
#   Differential Backups are written into the "Differential" Pool (#08)
#   Differential Backups are kept for 90 Days                     (#09)
#
#   Incremental Backups are done monday to friday at 21:00        (#10)
#   Incremental Backups are written into the "Incremental" Pool   (#11)
#   Incremental Backups are kept for 30 Days                      (#12)
#
#   What you also have to do is to change the default fileset     (#13)
#   to either one of the demo filesets given or create our own fileset.
#
#
#
#  For Bareos release @VERSION@ (@DATE@) -- @DISTNAME@ @DISTVER@
#
#
Director {                            # define myself
  Name = @basename@-dir
  QueryFile = "@scriptdir@/query.sql"
  Maximum Concurrent Jobs = 10
  Password = "@dir_password@"         # Console password
  Messages = Daemon

  # remove comment in next line to load plugins from specified directory
  # Plugin Directory = @plugindir@
}

JobDefs {
  Name = "DefaultJob"
  Type = Backup
  Level = Incremental
  Client = @basename@-fd
  FileSet = "SelfTest"                     # selftest fileset                            (#13)
  Schedule = "WeeklyCycle"
  Storage = File
  Messages = Standard
  Pool = Incremental
  Priority = 10
  Write Bootstrap = "@working_dir@/%c.bsr"
  Full Backup Pool = Full                  # write Full Backups into "Full" Pool         (#05)
  Differential Backup Pool = Differential  # write Diff Backups into "Differential" Pool (#08)
  Incremental Backup Pool = Incremental    # write Incr Backups into "Incremental" Pool  (#11)
}

#
# Define the main nightly save backup job
#   By default, this job will back up to disk in @archivedir@
Job {
  Name = "BackupClient1"
  JobDefs = "DefaultJob"
}

#
# Backup the catalog database (after the nightly save)
#
Job {
  Name = "BackupCatalog"
  JobDefs = "DefaultJob"
  Level = Full
  FileSet="Catalog"
  Schedule = "WeeklyCycleAfterBackup"

  # This creates an ASCII copy of the catalog
  # Arguments to make_catalog_backup.pl are:
  #  make_catalog_backup.pl <catalog-name>
  RunBeforeJob = "@scriptdir@/make_catalog_backup.pl MyCatalog"

  # This deletes the copy of the catalog
  RunAfterJob  = "@scriptdir@/delete_catalog_backup"

  # This sends the bootstrap via mail for disaster recovery.
  # Should be sent to another system, please change recipient accordingly
  Write Bootstrap = "|@sbindir@/bsmtp -h @smtp_host@ -f \"\(Bareos\) \" -s \"Bootstrap for Job %j\" @job_email@" # (#01)
  Priority = 11                   # run after main backup
}

#
# Standard Restore template, to be changed by Console program
#  Only one such job is needed for all Jobs/Clients/Storage ...
#
Job {
  Name = "RestoreFiles"
  Type = Restore
  Client=@basename@-fd
  FileSet = "Linux All"
  Storage = File
  Pool = Incremental
  Messages = Standard
  Where = /tmp/bareos-restores
}


FileSet {
  Name = "Windows All Drives"
  Enable VSS = yes
  Include {
    Options {
      Signature = MD5
      Drive Type = fixed
      IgnoreCase = yes
      WildFile = "[A-Z]:/pagefile.sys"
      WildDir = "[A-Z]:/RECYCLER"
      WildDir = "[A-Z]:/$RECYCLE.BIN"
      WildDir = "[A-Z]:/System Volume Information"
      Exclude = yes
    }
    File = /
  }
}


FileSet {
  Name = "Linux All"
  Include {
    Options {
      Signature = MD5 # calculate md5 checksum per file
      One FS = No     # change into other filessytems
      FS Type = ext2  # filesystems of given types will be backed up
      FS Type = ext3  # others will be ignored
      FS Type = ext4
      FS Type = xfs
      FS Type = reiserfs
      FS Type = jfs
      FS Type = btrfs
    }
    File = /
  }
  # Things that usually have to be excluded
  # You have to exclude @archivedir@
  # on your bareos server
  Exclude {
    File = @working_dir@
    File = @archivedir@
    File = /proc
    File = /tmp
    File = /.journal
    File = /.fsck
  }

}

# fileset just to backup some files for selftest
FileSet {
  Name = "SelfTest"
  Include {
    Options {
      Signature = MD5 # calculate md5 checksum per file
    }
    File = @sbindir@
  }
}

Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sat at 21:00                   # (#04)
  Run = Differential 2nd-5th sat at 21:00       # (#07)
  Run = Incremental mon-fri at 21:00            # (#10)
}

# This schedule does the catalog. It starts after the WeeklyCycle
Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Full mon-fri at 21:10
}

# This is the backup of the catalog
FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
    }
    File = "@working_dir@/@db_name@.sql" # database dump
    File = "@sysconfdir@"                # configuration
  }
}

# Client (File Services) to backup
Client {
  Name = @basename@-fd
  Address = @hostname@
  Password = "@fd_password@"          # password for FileDaemon
  File Retention = 30 days            # 30 days
  Job Retention = 6 months            # six months
  AutoPrune = no                      # Prune expired Jobs/Files
}

#
# Definition of file storage device
#
Storage {
  Name = File
# Do not use "localhost" here
  Address = @hostname@                # N.B. Use a fully qualified name here
  Password = "@sd_password@"
  Device = FileStorage
  Media Type = File
}

#
# Generic catalog service
#
Catalog {
  Name = MyCatalog
  # Uncomment the following lines if you want the dbi driver
  @uncomment_dbi@ dbdriver = "dbi:@DEFAULT_DB_TYPE@"; dbaddress = 127.0.0.1; dbport = @db_port@
  #dbdriver = "@DEFAULT_DB_TYPE@"
  dbdriver = "XXX_REPLACE_WITH_DATABASE_DRIVER_XXX"
  dbname = "@db_name@"
  dbuser = "@db_user@"
  dbpassword = "@db_password@"
}

#
# Reasonable message delivery -- send most everything to email address and to the console
#
Messages {
  Name = Standard
  mailcommand = "@sbindir@/bsmtp -h @smtp_host@ -f \"\(Bareos\) \<%r\>\" -s \"Bareos: %t %e of %c %l\" %r"
  operatorcommand = "@sbindir@/bsmtp -h @smtp_host@ -f \"\(Bareos\) \<%r\>\" -s \"Bareos: Intervention needed for %j\" %r"
  mail = @job_email@ = all, !skipped # (#02)
  operator = @job_email@ = mount     # (#03)
  console = all, !skipped, !saved
  append = "@logdir@/bareos.log" = all, !skipped
  catalog = all
}

#
# Message delivery for daemon messages (no job).
#
Messages {
  Name = Daemon
  mailcommand = "@sbindir@/bsmtp -h @smtp_host@ -f \"\(Bareos\) \<%r\>\" -s \"Bareos daemon message\" %r"
  mail = @job_email@ = all, !skipped # (#02)
  console = all, !skipped, !saved
  append = "@logdir@/bareos.log" = all, !skipped
}


#
# Full Pool definition
#
Pool {
  Name = Full
  Pool Type = Backup
  Recycle = yes                       # Bareos can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # How long should the Full Backups be kept? (#06)
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Full-"              # Volumes will be labeled "Full-<volume-id>"
}

#
# Differential Pool definition
#
Pool {
  Name = Differential
  Pool Type = Backup
  Recycle = yes                       # Bareos can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 90 days          # How long should the Differential Backups be kept? (#09)
  Maximum Volume Bytes = 10G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Differential-"      # Volumes will be labeled "Differential-<volume-id>"
}

#
# Incremental Pool definition
#
Pool {
  Name = Incremental
  Pool Type = Backup
  Recycle = yes                       # Bareos can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 30 days          # How long should the Incremental Backups be kept?  (#12)
  Maximum Volume Bytes = 1G           # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Incremental-"       # Volumes will be labeled "Incremental-<volume-id>"
}

#
# Scratch pool definition
#
Pool {
  Name = Scratch
  Pool Type = Backup
}

#
# Restricted console used by tray-monitor to get the status of the director
#
Console {
  Name = @basename@-mon
  Password = "@mon_dir_password@"
  CommandACL = status, .status
}

#
Chapter 10
Storage Daemon Conﬁguration

The Bareos Storage Daemon conﬁguration ﬁle has relatively few resource deﬁnitions. However, due to the great variation in backup media and system capabilities, the storage daemon must be highly conﬁgurable. As a consequence, there are quite a large number of directives in the Device Resource deﬁnition that allow you to deﬁne all the characteristics of your Storage device (normally a tape drive). Fortunately, with modern storage devices, the defaults are suﬃcient, and very few directives are actually needed.

For a general discussion of conﬁguration ﬁle and resources including the data types recognized by Bareos, please see the Conﬁguration chapter of this manual. The following Storage Resource deﬁnitions must be deﬁned:

    Storage – to deﬁne the name of the Storage daemon.
    Director – to deﬁne the Director’s name and his access password.
    Device – to deﬁne the characteristics of your storage device (tape drive).
    Messages – to deﬁne where error and information messages are to be sent.

Following resources are optional:

    Autochanger Resource – to deﬁne Autochanger devices.
    NDMP Resource – to deﬁne the NDMP authentication context.

#
10.1 Storage Resource

In general, the properties speciﬁed under the Storage resource deﬁne global properties of the Storage daemon. Each Storage daemon conﬁguration ﬁle must have one and only one Storage resource deﬁnition.


conﬁguration directive name

type of data

default value

remark

Absolute Job Timeout 	= positive-integer		
Allow Bandwidth Bursting 	= yes|no 	no 	
Auto XFlate On Replication 	= yes|no 	no 	
Backend Directory 	= DirectoryList	/usr/lib/bareos/backends (platform speciﬁc)
Client Connect Wait 	= time 	1800 	
Collect Device Statistics 	= yes|no 	no 	
Collect Job Statistics 	= yes|no 	no 	
Compatible 	= yes|no 	no 	
Description 	= string 		
Device Reserve By Media Type 	= yes|no 	no 	
FD Connect Timeout 	= time 	1800 	
File Device Concurrent Read 	= yes|no 	no 	
Heartbeat Interval 	= time 	0 	
Log Timestamp Format 	= string 		
Maximum Bandwidth Per Job 	= speed 		
Maximum Concurrent Jobs 	= positive-integer	20 	
Maximum Connections 	= positive-integer	42 	
Maximum Network Buﬀer Size 	= positive-integer		
Messages 	= resource-name 		

Name 	= name 		required
NDMP Address 	= net-address 	10000 	
NDMP Addresses 	= net-addresses 	10000 	
NDMP Enable 	= yes|no 	no 	
NDMP Log Level 	= positive-integer	4 	
NDMP Port 	= net-port 	10000 	
NDMP Snooping 	= yes|no 	no 	
Pid Directory 	= path 	/var/lib/bareos (platform speciﬁc)
Plugin Directory 	= path 		
Plugin Names 	= PluginNames 		
Scripts Directory 	= path 		
SD Address 	= net-address 	9103 	
SD Addresses 	= net-addresses 	9103 	
SD Connect Timeout 	= time 	1800 	
SD Port 	= net-port 	9103 	
SD Source Address 	= net-address 	0 	
Secure Erase Command 	= string 		
Statistics Collect Interval	= positive-integer	30 	
Sub Sys Directory 	= path 		
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string		
TLS DH File 	= path 		
TLS Enable 	= yes|no	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer 	= yes|no	yes 	
Ver Id 	= string		
Working Directory 	= path 	/var/lib/bareos (platform speciﬁc)


Absolute Job Timeout = <positive-integer>


Allow Bandwidth Bursting = <yes|no>
    (default: no)

Auto XFlate On Replication = <yes|no>
    (default: no)
    This directive controls the autoxﬂate-sd plugin plugin when replicating data inside one or between two storage daemons (Migration/Copy Jobs). Normally the storage daemon will use the autoinﬂate/autodeﬂate setting of the device when reading and writing data to it which could mean that while reading it inﬂates the compressed data and the while writing the other deﬂates it again. If you just want the data to be exactly the same e.g. don’t perform any on the ﬂy uncompression and compression while doing the replication of data you can set this option to no and it will override any setting on the device for doing auto inﬂation/deﬂation when doing data replication. This will not have any impact on any normal backup or restore jobs.  
    Version >= 13.4.0
Backend Directory = <DirectoryList>
    (default: /usr/lib/bareos/backends (platform speciﬁc))

Client Connect Wait = <time>
    (default: 1800)
    This directive deﬁnes an interval of time in seconds that the Storage daemon will wait for a Client (the File daemon) to connect. Be aware that the longer the Storage daemon waits for a Client, the more resources will be tied up.  
Collect Device Statistics = <yes|no>
    (default: no)

Collect Job Statistics = <yes|no>
    (default: no)

Compatible = <yes|no>
    (default: no)
    This directive enables the compatible mode of the storage daemon. In this mode the storage daemon will try to write the storage data in a compatible way with Bacula of which Bareos is a fork. This only works for the data streams both share and not for any new datastreams which are Bareos speciﬁc. Which may be read when used by a Bareos storage daemon but might not be understood by any of the Bacula components (dir/sd/fd).

    The default setting of this directive was changed to no since Bareos Version >= 15.2.0.  
Description = <string>


Device Reserve By Media Type = <yes|no>
    (default: no)

FD Connect Timeout = <time>
    (default: 1800)

File Device Concurrent Read = <yes|no>
    (default: no)

Heartbeat Interval = <time>
    (default: 0)
    This directive deﬁnes an interval of time in seconds. When the Storage daemon is waiting for the operator to mount a tape, each time interval, it will send a heartbeat signal to the File daemon. The default interval is zero which disables the heartbeat. This feature is particularly useful if you have a router that does not follow Internet standards and times out an valid connection after a short duration despite the fact that keepalive is set. This usually results in a broken pipe error message.  
Log Timestamp Format = <string>


    Version >= 15.2.3
Maximum Bandwidth Per Job = <speed>


Maximum Concurrent Jobs = <positive-integer>
    (default: 20)
    This directive speciﬁes the maximum number of Jobs that may run concurrently. Each contact from the Director (e.g. status request, job start request) is considered as a Job, so if you want to be able to do a status request in the console at the same time as a Job is running, you will need to set this value greater than 1. To run simultaneous Jobs, you will need to set a number of other directives in the Director’s conﬁguration ﬁle. Which ones you set depend on what you want, but you will almost certainly need to set the Maximum Concurrent Jobs Dir Storage. Please refer to the Concurrent Jobs chapter.  
Maximum Connections = <positive-integer>
    (default: 42)

    Version >= 15.2.3
Maximum Network Buﬀer Size = <positive-integer>


Messages = <resource-name>


Name = <name>
    (required)
    Speciﬁes the Name of the Storage daemon.  
NDMP Address = <net-address>
    (default: 10000)
    This directive is optional, and if it is speciﬁed, it will cause the Storage daemon server (for NDMP Tape Server connections) to bind to the speciﬁed IP-Address, which is either a domain name or an IP address speciﬁed as a dotted quadruple. If this directive is not speciﬁed, the Storage daemon will bind to any available address (the default).  
NDMP Addresses = <net-addresses>
    (default: 10000)
    Specify the ports and addresses on which the Storage daemon will listen for NDMP Tape Server connections. Normally, the default is suﬃcient and you do not need to specify this directive.  
NDMP Enable = <yes|no>
    (default: no)
    This directive enables the Native NDMP Tape Agent.  
NDMP Log Level = <positive-integer>
    (default: 4)
    This directive sets the loglevel for the NDMP protocol library.  
NDMP Port = <net-port>
    (default: 10000)
    Speciﬁes port number on which the Storage daemon listens for NDMP Tape Server connections.  
NDMP Snooping = <yes|no>
    (default: no)
    This directive enables the Snooping and pretty printing of NDMP protocol information in debugging mode.  
Pid Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive speciﬁes a directory in which the Storage Daemon may put its process Id ﬁle ﬁles. The process Id ﬁle is used to shutdown Bareos and to prevent multiple copies of Bareos from running simultaneously. Standard shell expansion of the directory is done when the conﬁguration ﬁle is read so that values such as $HOME will be properly expanded.  
Plugin Directory = <path>

    This directive speciﬁes a directory in which the Storage Daemon searches for plugins with the name <_pluginname>_-sd.so which it will load at startup.  
Plugin Names = <PluginNames>

    If a Plugin Directory Sd Storage is speciﬁed Plugin Names deﬁnes, which Storage Daemon Plugins get loaded.
    
    If Plugin Names is not deﬁned, all plugins get loaded, otherwise the deﬁned ones.  
Scripts Directory = <path>

    This directive is currently unused.  
SD Address = <net-address>
    (default: 9103)
    This directive is optional, and if it is speciﬁed, it will cause the Storage daemon server (for Director and File daemon connections) to bind to the speciﬁed IP-Address, which is either a domain name or an IP address speciﬁed as a dotted quadruple. If this and the SD Addresses Sd Storage directives are not speciﬁed, the Storage daemon will bind to any available address (the default).  
SD Addresses = <net-addresses>
    (default: 9103)
    Specify the ports and addresses on which the Storage daemon will listen for Director connections. Using this directive, you can replace both the SD Port Sd Storage and SD Address Sd Storage directives.  
SD Connect Timeout = <time>
    (default: 1800)

SD Port = <net-port>
    (default: 9103)
    Speciﬁes port number on which the Storage daemon listens for Director connections.  
SD Source Address = <net-address>
    (default: 0)

Secure Erase Command = <string>

    Specify command that will be called when bareos unlinks ﬁles.
    
    When ﬁles are no longer needed, Bareos will delete (unlink) them. With this directive, it will call the speciﬁed command to delete these ﬁles. See Secure Erase Command for details.  
    Version >= 15.2.1
Statistics Collect Interval = <positive-integer>
    (default: 30)

Sub Sys Directory = <path>


TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. Chapter TLS Conﬁguration Directives explains how the Bareos components must be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Ver Id = <string>


Working Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive speciﬁes a directory in which the Storage daemon may put its status ﬁles. This directory should be used only by Bareos, but may be shared by other Bareos daemons provided the names given to each daemon are unique.  

The following is a typical Storage daemon storage resource deﬁnition.


#
# "Global" Storage daemon configuration specifications appear
# under the Storage resource.
#
Storage {
  Name = "Storage daemon"
  Address = localhost
}


Conﬁguration 10.1: Storage daemon storage deﬁnition

#
10.2 Director Resource

The Director resource speciﬁes the Name of the Director which is permitted to use the services of the Storage daemon. There may be multiple Director resources. The Director Name and Password must match the corresponding values in the Director’s conﬁguration ﬁle.


conﬁguration directive name

type of data

default value

remark

Description 	= string 		
Key Encryption Key 	= password 		
Maximum Bandwidth Per Job 	= speed 		
Monitor 	= yes|no 		
Name 	= name 		required
Password 	= password 		required
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List 	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		
TLS Enable 	= yes|no 	no 	
TLS Key 	= path 		
TLS Require 	= yes|no 	no 	
TLS Verify Peer 	= yes|no 	yes 	



Description = <string>


Key Encryption Key = <password>

    This key is used to encrypt the Security Key that is exchanged between the Director and the Storage Daemon for supporting Application Managed Encryption (AME). For security reasons each Director should have a diﬀerent Key Encryption Key.  
Maximum Bandwidth Per Job = <speed>


Monitor = <yes|no>

    If Monitor is set to no (default), this director will have full access to this Storage daemon. If Monitor is set to yes, this director will only be able to fetch the current status of this Storage daemon.
    
    Please note that if this director is being used by a Monitor, we highly recommend to set this directive to yes to avoid serious security problems.  
Name = <name>
    (required)
    Speciﬁes the Name of the Director allowed to connect to the Storage daemon. This directive is required.  
Password = <password>
    (required)
    Speciﬁes the password that must be supplied by the above named Director. This directive is required.  
TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. Chapter TLS Conﬁguration Directives explains how the Bareos components must be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.



The following is an example of a valid Director resource deﬁnition:


Director {
  Name = MainDirector
  Password = my_secret_password
}


Conﬁguration 10.2: Storage daemon Director deﬁnition

#
10.3 NDMP Resource

The NDMP Resource speciﬁes the authentication details of each NDMP client. There may be multiple NDMP resources for a single Storage daemon. In general, the properties speciﬁed within the NDMP resource are speciﬁc to one client.


conﬁguration directive name

type of data

default value

remark

Auth Type 	= None|Clear|MD5	None 	
Description 	= string 		
Log Level 	= positive-integer 	4 	
Name 	= name 		required
Password 	= password 		required
Username 	= string 		required



Auth Type = <None|Clear|MD5>
    (default: None)
    Speciﬁes the authentication type that must be supplied by the above named NDMP Client. This directive is required.

    The following values are allowed:
    
        None - Use no password
        Clear - Use clear text password
        MD5 - Use MD5 hashing


Description = <string>


Log Level = <positive-integer>
    (default: 4)
    Speciﬁes the NDMP Loglevel which overrides the global NDMP loglevel for this client.  
Name = <name>
    (required)
    Speciﬁes the name of the NDMP Client allowed to connect to the Storage daemon. This directive is required.  
Password = <password>
    (required)
    Speciﬁes the password that must be supplied by the above named NDMP Client. This directive is required.  
Username = <string>
    (required)
    Speciﬁes the username that must be supplied by the above named NDMP Client. This directive is required.  

#
10.4 Device Resource

The Device Resource speciﬁes the details of each device (normally a tape drive) that can be used by the Storage daemon. There may be multiple Device resources for a single Storage daemon. In general, the properties speciﬁed within the Device resource are speciﬁc to the Device.


conﬁguration directive name

type of data

default value

remark

Alert Command 	= strname 		
Always Open 	= yes|no 	yes 	
Archive Device 	= strname 		required
Auto Deﬂate 	= IoDirection 		
Auto Deﬂate Algorithm 	= CompressionAlgorithm		
Auto Deﬂate Level 	= Pint16 	6 	
Auto Inﬂate 	= IoDirection 		
Auto Select 	= yes|no 	yes 	
Autochanger 	= yes|no 	no 	
Automatic Mount 	= yes|no 	no 	
Backward Space File 	= yes|no 	yes 	
Backward Space Record 	= yes|no 	yes 	
Block Checksum 	= yes|no 	yes 	
Block Positioning 	= yes|no 	yes 	
Bsf At Eom 	= yes|no 	no 	
Changer Command 	= strname 		
Changer Device 	= strname 		
Check Labels 	= yes|no 	no 	
Close On Poll 	= yes|no 	no 	

Collect Statistics 	= yes|no 	yes 	
Description 	= string 		
Device Options 	= string 		
Device Type 	= DeviceType 		
Diagnostic Device 	= strname 		
Drive Crypto Enabled 	= yes|no 		
Drive Index 	= Pint16 		
Drive Tape Alert Enabled 	= yes|no 		
Fast Forward Space File 	= yes|no 	yes 	
Forward Space File 	= yes|no 	yes 	
Forward Space Record 	= yes|no 	yes 	
Free Space Command 	= strname 		deprecated
Hardware End Of File 	= yes|no 	yes 	
Hardware End Of Medium 	= yes|no 	yes 	
Label Block Size 	= positive-integer	64512
Label Media 	= yes|no 	no 	
Label Type 	= Label 		
Maximum Block Size 	= MaxBlocksize 		
Maximum Changer Wait 	= time 	300 	
Maximum Concurrent Jobs	= positive-integer		
Maximum File Size 	= Size64 	1000000000
Maximum Job Spool Size 	= Size64 		
Maximum Network Buﬀer Size	= positive-integer		
Maximum Open Volumes 	= positive-integer	1 	
Maximum Open Wait 	= time 	300 	
Maximum Part Size 	= Size64 		deprecated
Maximum Rewind Wait 	= time 	300 	
Maximum Spool Size 	= Size64 		
Maximum Volume Size 	= Size64 		deprecated
Media Type 	= strname 		required
Minimum Block Size 	= positive-integer		
Mount Command 	= strname 		
Mount Point 	= strname 		
Name 	= name 		required
No Rewind On Close 	= yes|no 	yes 	
Oﬄine On Unmount 	= yes|no 	no 	
Query Crypto Status 	= yes|no 		
Random Access 	= yes|no 	no 	
Removable Media 	= yes|no 	yes 	
Requires Mount 	= yes|no 	no 	
Spool Directory 	= path 		
Two Eof 	= yes|no 	no 	
Unmount Command 	= strname		
Use Mtiocget 	= yes|no 	yes
Volume Capacity 	= Size64 		
Volume Poll Interval 	= time 	300
Write Part Command	= strname		deprecated


Alert Command = <strname>

    The name-string speciﬁes an external program to be called at the completion of each Job after the device is released. The purpose of this command is to check for Tape Alerts, which are present when something is wrong with your tape drive (at least for most modern tape drives). The same substitution characters that may be speciﬁed in the Changer Command may also be used in this string. For more information, please see the Autochangers chapter of this manual.
    
    Note, it is not necessary to have an autochanger to use this command. The example below uses the tapeinfo program that comes with the mtx package, but it can be used on any tape drive. However, you will need to specify a Changer Device directive in your Device resource (see above) so that the generic SCSI device name can be edited into the command (with the %c).
    
    An example of the use of this command to print Tape Alerts in the Job report is:
    
    Alert Command = "sh -c ’tapeinfo -f %c | grep TapeAlert’"
    
    and an example output when there is a problem could be:
    
    bareos-sd  Alert: TapeAlert[32]: Interface: Problem with SCSI interface
                      between tape drive and initiator.


Always Open = <yes|no>
    (default: yes)
    If Yes, Bareos will always keep the device open unless speciﬁcally unmounted by the Console program. This permits Bareos to ensure that the tape drive is always available, and properly positioned. If you set AlwaysOpen to no Bareos will only open the drive when necessary, and at the end of the Job if no other Jobs are using the drive, it will be freed. The next time Bareos wants to append to a tape on a drive that was freed, Bareos will rewind the tape and position it to the end. To avoid unnecessary tape positioning and to minimize unnecessary operator intervention, it is highly recommended that Always Open = yes. This also ensures that the drive is available when Bareos needs it.

    If you have Always Open = yes (recommended) and you want to use the drive for something else, simply use the unmount command in the Console program to release the drive. However, don’t forget to remount the drive with mount when the drive is available or the next Bareos job will block.
    
    For File storage, this directive is ignored. For a FIFO storage device, you must set this to No.
    
    Please note that if you set this directive to No Bareos will release the tape drive between each job, and thus the next job will rewind the tape and position it to the end of the data. This can be a very time consuming operation. In addition, with this directive set to no, certain multiple drive autochanger operations will fail. We strongly recommend to keep Always Open set to Yes  
Archive Device = <strname>
    (required)
    Speciﬁes where to read and write the backup data. The type of the Archive Device can be speciﬁed by the Device Type Sd Device directive. If Device Type is not speciﬁed, Bareos tries to guess the Device Type accordingly to the type of the speciﬁed Archive Device ﬁle type.

    There are diﬀerent types that are supported:
    
    device
        Usually the device ﬁle name of a removable storage device (tape drive), for example /dev/nst0 or /dev/rmt/0mbn, preferably in the ”non-rewind” variant. In addition, on systems such as Sun, which have multiple tape access methods, you must be sure to specify to use Berkeley I/O conventions with the device. The b in the Solaris (Sun) archive speciﬁcation /dev/rmt/0mbn is what is needed in this case. Bareos does not support SysV tape drive behavior.
    directory
        If a directory is speciﬁed, it is used as ﬁle storage. The directory must be existing and be speciﬁed as absolute path. Bareos will write to ﬁle storage in the speciﬁed directory and the ﬁlename used will be the Volume name as speciﬁed in the Catalog. If you want to write into more than one directory (i.e. to spread the load to diﬀerent disk drives), you will need to deﬁne two Device resources, each containing an Archive Device with a diﬀerent directory.
    ﬁfo
        A FIFO is a special kind of ﬁle that connects two programs via kernel memory. If a FIFO device is speciﬁed for a backup operation, you must have a program that reads what Bareos writes into the FIFO. When the Storage daemon starts the job, it will wait for Maximum Open Wait Sd Device seconds for the read program to start reading, and then time it out and terminate the job. As a consequence, it is best to start the read program at the beginning of the job perhaps with the Run Before Job Dir Job directive. For this kind of device, you always want to specify Always Open Sd Device = no, because you want the Storage daemon to open it only when a job starts. Since a FIFO is a one way device, Bareos will not attempt to read a label of a FIFO device, but will simply write on it. To create a FIFO Volume in the catalog, use the add command rather than the label command to avoid attempting to write a label.
    
        Device {
          Name = FifoStorage
          Media Type = Fifo
          Device Type = Fifo
          Archive Device = /tmp/fifo
          LabelMedia = yes
          Random Access = no
          AutomaticMount = no
          RemovableMedia = no
          MaximumOpenWait = 60
          AlwaysOpen = no
        }
    
        During a restore operation, if the Archive Device is a FIFO, Bareos will attempt to read from the FIFO, so you must have an external program that writes into the FIFO. Bareos will wait Maximum Open Wait Sd Device seconds for the program to begin writing and will then time it out and terminate the job. As noted above, you may use the Run Before Job Dir Job to start the writer program at the beginning of the job.
    
        A FIFO device can also be used to test your conﬁguration, see the Howto section.
    GlusterFS Storage
        don’t use this directive, but only Device Type Sd Device and Device Options Sd Device (this behavior have changed with Version >= 15.2.0).
    Ceph Object Store
        don’t use this directive, but only Device Type Sd Device and Device Options Sd Device. (this behavior have changed with Version >= 15.2.0).


Auto Deﬂate = <IoDirection>

    This is a parameter used by autoxﬂate-sd which allow you to transform a non compressed piece of data into a compressed piece of data on the storage daemon. e.g. Storage Daemon compression. You can either enable compression on the client and use the CPU cyclces there to compress your data with one of the supported compression algorithms. The value of this parameter speciﬁes a so called io-direction currently you can use the following io-directions:
    
        in - compress data streams while reading the data from a device.
        out - compress data streams while writing the data to a device.
        both - compress data streams both when reading and writing to a device.
    
    Currently only plain data streams are compressed (so things that are already compressed or encrypted will not be considered for compression.) Also meta-data streams are not compressed. The compression is done in a way that the stream is transformed into a native compressed data stream. So if you enable this and send the data to a ﬁledaemon it will know its a compressed stream and will do the decompression itself. This also means that you can turn this option on and oﬀ at any time without having any problems with data already written.
    
    This option could be used if your clients doesn’t have enough power to do the compression/decompression itself and you have enough network bandwidth. Or when your ﬁlesystem doesn’t have the option to transparently compress data you write to it but you want the data to be compressed when written.  
    Version >= 13.4.0
Auto Deﬂate Algorithm = <CompressionAlgorithm>

    This option speciﬁes the compression algorithm used for the autodeﬂate option which is performed by the autoxﬂate-sd plugin. The algorithms supported are:
    
        GZIP - gzip level 1–9
        LZO
        LZFAST
        LZ4
        LZ4HC


    Version >= 13.4.0
Auto Deﬂate Level = <Pint16>
    (default: 6)
    This option speciﬁes the level to be used when compressing when you select a compression algorithm that has diﬀerent levels.  
    Version >= 13.4.0
Auto Inﬂate = <IoDirection>

    This is a parameter used by autoxﬂate-sd which allow you to transform a compressed piece of data into a non compressed piece of data on the storage daemon. e.g. Storage Daemon decompression. You can either enable decompression on the client and use the CPU cyclces there to decompress your data with one of the supported compression algorithms. The value of this parameter speciﬁes a so called io-direction currently you can use the following io-directions:
    
        in - decompress data streams while reading the data from a device.
        out - decompress data streams while writing the data to a device.
        both - decompress data streams both when reading and writing to a device.
    
    This option allows you to write uncompressed data to for instance a tape drive that has hardware compression even when you compress your data on the client with for instance a low cpu load compression method (LZ4 for instance) to transfer less data over the network. It also allows you to restore data in a compression format that the client might not support but the storage daemon does. This only works on normal compressed datastreams not on encrypted datastreams or meta data streams.  
    Version >= 13.4.0
Auto Select = <yes|no>
    (default: yes)
    If this directive is set to yes, and the Device belongs to an autochanger, then when the Autochanger is referenced by the Director, this device can automatically be selected. If this directive is set to no, then the Device can only be referenced by directly using the Device name in the Director. This is useful for reserving a drive for something special such as a high priority backup or restore operations.  
Autochanger = <yes|no>
    (default: no)
    If Yes, this device belongs to an automatic tape changer, and you must specify an Autochanger resource that points to the Device resources. You must also specify a Changer Device Sd Device. If the Autochanger directive is set to No, the volume must be manually changed. You should also have an identical directive to the Auto Changer Dir Storage in the Director’s conﬁguration ﬁle so that when labeling tapes you are prompted for the slot.  
Automatic Mount = <yes|no>
    (default: no)
    If Yes, permits the daemon to examine the device to determine if it contains a Bareos labeled volume. This is done initially when the daemon is started, and then at the beginning of each job. This directive is particularly important if you have set Always Open = no because it permits Bareos to attempt to read the device before asking the system operator to mount a tape. However, please note that the tape must be mounted before the job begins.  
Backward Space File = <yes|no>
    (default: yes)
    If Yes, the archive device supports the MTBSF and MTBSF ioctls to backspace over an end of ﬁle mark and to the start of a ﬁle. If No, these calls are not used and the device must be rewound and advanced forward to the desired position.  
Backward Space Record = <yes|no>
    (default: yes)
    If Yes, the archive device supports the MTBSR ioctl to backspace records. If No, this call is not used and the device must be rewound and advanced forward to the desired position. This function if enabled is used at the end of a Volume after writing the end of ﬁle and any ANSI/IBM labels to determine whether or not the last block was written correctly. If you turn this function oﬀ, the test will not be done. This causes no harm as the re-read process is precautionary rather than required.  
Block Checksum = <yes|no>
    (default: yes)
    You may turn oﬀ the Block Checksum (CRC32) code that Bareos uses when writing blocks to a Volume. Doing so can reduce the Storage daemon CPU usage slightly. It will also permit Bareos to read a Volume that has corrupted data.

    It is not recommend to turn this oﬀ, particularly on older tape drives or for disk Volumes where doing so may allow corrupted data to go undetected.  
Block Positioning = <yes|no>
    (default: yes)
    This directive tells Bareos not to use block positioning when doing restores. Turning this directive oﬀ can cause Bareos to be extremely slow when restoring ﬁles. You might use this directive if you wrote your tapes with Bareos in variable block mode (the default), but your drive was in ﬁxed block mode.  
Bsf At Eom = <yes|no>
    (default: no)
    If No, no special action is taken by Bareos with the End of Medium (end of tape) is reached because the tape will be positioned after the last EOF tape mark, and Bareos can append to the tape as desired. However, on some systems, such as FreeBSD, when Bareos reads the End of Medium (end of tape), the tape will be positioned after the second EOF tape mark (two successive EOF marks indicated End of Medium). If Bareos appends from that point, all the appended data will be lost. The solution for such systems is to specify BSF at EOM which causes Bareos to backspace over the second EOF mark. Determination of whether or not you need this directive is done using the test command in the btape program.  
Changer Command = <strname>

    The name-string speciﬁes an external program to be called that will automatically change volumes as required by Bareos. Normally, this directive will be speciﬁed only in the AutoChanger resource, which is then used for all devices. However, you may also specify the diﬀerent Changer Command in each Device resource. Most frequently, you will specify the Bareos supplied mtx-changer script as follows:
    
    Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
    
    and you will install the mtx on your system. An example of this command is in the default bareos-sd.conf ﬁle. For more details on the substitution characters that may be speciﬁed to conﬁgure your autochanger please see the Autochanger Support chapter of this manual.  
Changer Device = <strname>

    The speciﬁed name-string must be the generic SCSI device name of the autochanger that corresponds to the normal read/write Archive Device speciﬁed in the Device resource. This generic SCSI device name should be speciﬁed if you have an autochanger or if you have a standard tape drive and want to use the Alert Command (see below). For example, on Linux systems, for an Archive Device name of /dev/nst0, you would specify /dev/sg0 for the Changer Device name. Depending on your exact conﬁguration, and the number of autochangers or the type of autochanger, what you specify here can vary. This directive is optional. See the Using Autochangers chapter of this manual for more details of using this and the following autochanger directives.  
Check Labels = <yes|no>
    (default: no)
    If you intend to read ANSI or IBM labels, this must be set. Even if the volume is not ANSI labeled, you can set this to yes, and Bareos will check the label type. Without this directive set to yes, Bareos will assume that labels are of Bareos type and will not check for ANSI or IBM labels. In other words, if there is a possibility of Bareos encountering an ANSI/IBM label, you must set this to yes.  
Close On Poll = <yes|no>
    (default: no)
    If Yes, Bareos close the device (equivalent to an unmount except no mount is required) and reopen it at each poll. Normally this is not too useful unless you have the Oﬄine on Unmount directive set, in which case the drive will be taken oﬄine preventing wear on the tape during any future polling. Once the operator inserts a new tape, Bareos will recognize the drive on the next poll and automatically continue with the backup. Please see above for more details.  
Collect Statistics = <yes|no>
    (default: yes)

Description = <string>

    The Description directive provides easier human recognition, but is not used by Bareos directly.


Device Options = <string>

    Some Device Type Sd Device require additional conﬁguration. This can be speciﬁed in this directive, e.g. for
    
    GFAPI (GlusterFS)
        A GlusterFS Storage can be used as Storage backend of Bareos. Prerequistes are a working GlusterFS storage system and the package bareos-storage-glusterfs . See http://www.gluster.org/ for more information regarding GlusterFS installation and conﬁguration and speciﬁcally https://gluster.readthedocs.org/en/latest/Administrator Guide/Bareos/ for Bareos integration. You can use following snippet to conﬁgure it as storage device:
    
        Device {
          Name = GlusterStorage
          Archive Device = "Gluster Device"
          Device Options = "uri=gluster://server.example.com/volumename/bareos"
          Device Type = gfapi
          Media Type = GlusterFile
          Label Media = yes
          Random Access = yes
          Automatic Mount = yes
          Removable Media = no
          Always Open = no
        }
    
        Adapt server and volume name to your environment.
    
        Version >= 15.2.0
    Rados (Ceph Object Store)
        Here you conﬁgure the Ceph object store, which is accessed by the SD using the Rados library. Prerequistes are a working Ceph object store and the package bareos-storage-ceph . See http://ceph.com for more information regarding Ceph installation and conﬁguration. Assuming that you have an object store with name poolname and your Ceph access is conﬁgured in /etc/ceph/ceph.conf, you can use following snippet to conﬁgure it as storage device:
    
        Device {
          Name = RadosStorage
          Archive Device = "Rados Device"
          Device Options = "conffile=/etc/ceph/ceph.conf,poolname=poolname"
          Device Type = rados
          Media Type = RadosFile
          Label Media = yes
          Random Access = yes
          Automatic Mount = yes
          Removable Media = no
          Always Open = no
        }
    
        Version >= 15.2.0
    
    Before the Device Options directive have been introduced, these options have to be conﬁgured in the Archive Device Sd Device directive. This behavior have changed with Version >= 15.2.0.  
    Version >= 15.2.0
Device Type = <DeviceType>

    The Device Type speciﬁcation allows you to explicitly deﬁne the kind of device you want to use. It may be one of the following:
    
    Tape
        is used to access tape device and thus has sequential access. Tape devices are controlled using ioctl() calls.
    File
        tells Bareos that the device is a ﬁle. It may either be a ﬁle deﬁned on ﬁxed medium or a removable ﬁlesystem such as USB. All ﬁles must be random access devices.
    Fifo
        is a ﬁrst-in-ﬁrst-out sequential access read-only or write-only device.
    GFAPI (GlusterFS)
        is used to access a GlusterFS storage. It must be conﬁgured using Device Options Sd Device. Version >= 14.2.2
    Rados (Ceph Object Store)
        is used to access a Ceph object store. It must be conﬁgured using Device Options Sd Device. Version >= 14.2.2
    
    The Device Type directive is not required in all cases. If it is not speciﬁed, Bareos will attempt to guess what kind of device has been speciﬁed using the Archive Device Sd Device speciﬁcation supplied. There are several advantages to explicitly specifying the Device Type. First, on some systems, block and character devices have the same type. Secondly, if you explicitly specify the Device Type, the mount point need not be deﬁned until the device is opened. This is the case with most removable devices such as USB. If the Device Type is not explicitly speciﬁed, then the mount point must exist when the Storage daemon starts.  
Diagnostic Device = <strname>


Drive Crypto Enabled = <yes|no>

    The default for this directive is No. If Yes the storage daemon can perform so called Application Managed Encryption (AME) using a special Storage Daemon plugin which loads and clears the Encryption key using the SCSI SPIN/SPOUT protocol.  
Drive Index = <Pint16>

    The Drive Index that you specify is passed to the mtx-changer script and is thus passed to the mtx program. By default, the Drive Index is zero, so if you have only one drive in your autochanger, everything will work normally. However, if you have multiple drives, you must specify multiple Bareos Device resources (one for each drive). The ﬁrst Device should have the Drive Index set to 0, and the second Device Resource should contain a Drive Index set to 1, and so on. This will then permit you to use two or more drives in your autochanger.  
Drive Tape Alert Enabled = <yes|no>


Fast Forward Space File = <yes|no>
    (default: yes)
    If No, the archive device is not required to support keeping track of the ﬁle number (MTIOCGET ioctl) during forward space ﬁle. If Yes, the archive device must support the ioctl MTFSF call, which virtually all drivers support, but in addition, your SCSI driver must keep track of the ﬁle number on the tape and report it back correctly by the MTIOCGET ioctl. Note, some SCSI drivers will correctly forward space, but they do not keep track of the ﬁle number or more seriously, they do not report end of medium.  
Forward Space File = <yes|no>
    (default: yes)
    If Yes, the archive device must support the MTFSF ioctl to forward space by ﬁle marks. If No, data must be read to advance the position on the device.  
Forward Space Record = <yes|no>
    (default: yes)
    If Yes, the archive device must support the MTFSR ioctl to forward space over records. If No, data must be read in order to advance the position on the device.  
Free Space Command = <strname>

    Please note! This directive is deprecated.

Hardware End Of File = <yes|no>
    (default: yes)

Hardware End Of Medium = <yes|no>
    (default: yes)
    All modern (after 1998) tape drives should support this feature. In doubt, use the btape program to test your drive to see whether or not it supports this function. If the archive device does not support the end of medium ioctl request MTEOM, set this parameter to No. The storage daemon will then use the forward space ﬁle function to ﬁnd the end of the recorded data. In addition, your SCSI driver must keep track of the ﬁle number on the tape and report it back correctly by the MTIOCGET ioctl. Note, some SCSI drivers will correctly forward space to the end of the recorded data, but they do not keep track of the ﬁle number. On Linux machines, the SCSI driver has a fast-eod option, which if set will cause the driver to lose track of the ﬁle number. You should ensure that this option is always turned oﬀ using the mt program.  
Label Block Size = <64512>
    (default: 64512)
    The storage daemon will write the label blocks with the size conﬁgured here. Usually, you will not need to change this directive.

    For more information on this directive, please see Tapespeed and blocksizes.  
    Version >= 14.2.0
Label Media = <yes|no>
    (default: no)
    If Yes, permits this device to automatically label blank media without an explicit operator command. It does so by using an internal algorithm as deﬁned on the Label Format Dir Pool record in each Pool resource. If this is No as by default, Bareos will label tapes only by speciﬁc operator command (label in the Console) or when the tape has been recycled. The automatic labeling feature is most useful when writing to disk rather than tape volumes.  
Label Type = <Label>

    Deﬁnes the label type to use, see section Tape Labels: ANSI or IBM. This directive is implemented in the Director Pool resource (Label Type Dir Pool) and in the SD Device resource. If it is speciﬁed in the the SD Device resource, it will take precedence over the value passed from the Director to the SD. If it is set to a non-default value, make sure to also enable Check Labels Sd Device.  
Maximum Block Size = <64512>

    The Storage daemon will always attempt to write blocks of the speciﬁed size (in-bytes) to the archive device. As a consequence, this statement speciﬁes both the default block size and the maximum block size. The size written never exceed the given size. If adding data to a block would cause it to exceed the given maximum size, the block will be written to the archive device, and the new data will begin a new block.
    
    If no value is speciﬁed or zero is speciﬁed, the Storage daemon will use a default block size of 64,512 bytes (126 * 512).
    
    Please note! If your are using LTO drives, changing the block size after labeling the tape will result into unreadable tapes.
    
    Please read chapter Tapespeed and blocksizes, to see how to tune this value in a safe manner.  
Maximum Changer Wait = <time>
    (default: 300)
    This directive speciﬁes the maximum time in seconds for Bareos to wait for an autochanger to change the volume. If this time is exceeded, Bareos will invalidate the Volume slot number stored in the catalog and try again. If no additional changer volumes exist, Bareos will ask the operator to intervene.  
Maximum Concurrent Jobs = <positive-integer>

    This directive speciﬁes the maximum number of Jobs that can run concurrently on a speciﬁed Device. Using this directive, it is possible to have diﬀerent Jobs using multiple drives, because when the Maximum Concurrent Jobs limit is reached, the Storage Daemon will start new Jobs on any other available compatible drive. This facilitates writing to multiple drives with multiple Jobs that all use the same Pool.  
Maximum File Size = <Size64>
    (default: 1000000000)
    No more than size bytes will be written into a given logical ﬁle on the volume. Once this size is reached, an end of ﬁle mark is written on the volume and subsequent data are written into the next ﬁle. Breaking long sequences of data blocks with ﬁle marks permits quicker positioning to the start of a given stream of data and can improve recovery from read errors on the volume. The default is one Gigabyte. This directive creates EOF marks only on tape media. However, regardless of the medium type (tape, disk, USB ...) each time a the Maximum File Size is exceeded, a record is put into the catalog database that permits seeking to that position on the medium for restore operations. If you set this to a small value (e.g. 1MB), you will generate lots of database records (JobMedia) and may signiﬁcantly increase CPU/disk overhead.

    If you are conﬁguring an modern drive like LTO-4 or newer, you probably will want to set the Maximum File Size to 20GB or bigger to avoid making the drive stop to write an EOF mark.
    
    For more info regarding this parameter, read the tape speed whitepaper: Bareos Whitepaper Tape Speed Tuning
    
    Note, this directive does not limit the size of Volumes that Bareos will create regardless of whether they are tape or disk volumes. It changes only the number of EOF marks on a tape and the number of block positioning records that are generated. If you want to limit the size of all Volumes for a particular device, use the use the Maximum Volume Bytes Dir Pool directive.  
Maximum Job Spool Size = <Size64>

    where the bytes specify the maximum spool size for any one job that is running. The default is no limit.  
Maximum Network Buﬀer Size = <positive-integer>

    where bytes speciﬁes the initial network buﬀer size to use with the File daemon. This size will be adjusted down if it is too large until it is accepted by the OS. Please use care in setting this value since if it is too large, it will be trimmed by 512 bytes until the OS is happy, which may require a large number of system calls. The default value is 32,768 bytes.
    
    The default size was chosen to be relatively large but not too big in the case that you are transmitting data over Internet. It is clear that on a high speed local network, you can increase this number and improve performance. For example, some users have found that if you use a value of 65,536 bytes they get ﬁve to ten times the throughput. Larger values for most users don’t seem to improve performance. If you are interested in improving your backup speeds, this is deﬁnitely a place to experiment. You will probably also want to make the corresponding change in each of your File daemons conf ﬁles.  
Maximum Open Volumes = <positive-integer>
    (default: 1)

Maximum Open Wait = <time>
    (default: 300)
    This directive speciﬁes the maximum amount of time that Bareos will wait for a device that is busy. If the device cannot be obtained, the current Job will be terminated in error. Bareos will re-attempt to open the drive the next time a Job starts that needs the the drive.  
Maximum Part Size = <Size64>

    Please note! This directive is deprecated.

Maximum Rewind Wait = <time>
    (default: 300)
    This directive speciﬁes the maximum time in seconds for Bareos to wait for a rewind before timing out. If this time is exceeded, Bareos will cancel the job.  
Maximum Spool Size = <Size64>

    where the bytes specify the maximum spool size for all jobs that are running. The default is no limit.  
Maximum Volume Size = <Size64>

    Please note! This directive is deprecated.
    Normally, Maximum Volume Bytes Dir Pool should be used instead. Limit the number of bytes that will be written onto a given volume on the archive device. This directive is used mainly in testing Bareos to simulate a small Volume.  
Media Type = <strname>
    (required)
    The speciﬁed value names the type of media supported by this device, for example, ”DLT7000”. Media type names are arbitrary in that you set them to anything you want, but they must be known to the volume database to keep track of which storage daemons can read which volumes. In general, each diﬀerent storage type should have a unique Media Type associated with it. The same name-string must appear in the appropriate Storage resource deﬁnition in the Director’s conﬁguration ﬁle.

    Even though the names you assign are arbitrary (i.e. you choose the name you want), you should take care in specifying them because the Media Type is used to determine which storage device Bareos will select during restore. Thus you should probably use the same Media Type speciﬁcation for all drives where the Media can be freely interchanged. This is not generally an issue if you have a single Storage daemon, but it is with multiple Storage daemons, especially if they have incompatible media.
    
    For example, if you specify a Media Type of ”DDS-4” then during the restore, Bareos will be able to choose any Storage Daemon that handles ”DDS-4”. If you have an autochanger, you might want to name the Media Type in a way that is unique to the autochanger, unless you wish to possibly use the Volumes in other drives. You should also ensure to have unique Media Type names if the Media is not compatible between drives. This speciﬁcation is required for all devices.
    
    In addition, if you are using disk storage, each Device resource will generally have a diﬀerent mount point or directory. In order for Bareos to select the correct Device resource, each one must have a unique Media Type.  
Minimum Block Size = <positive-integer>

    This statement applies only to non-random access devices (e.g. tape drives). Blocks written by the storage daemon to a non-random archive device will never be smaller than the given size. The Storage daemon will attempt to eﬃciently ﬁll blocks with data received from active sessions but will, if necessary, add padding to a block to achieve the required minimum size.
    
    To force the block size to be ﬁxed, as is the case for some non-random access devices (tape drives), set the Minimum block size and the Maximum block size to the same value. The default is that both the minimum and maximum block size are zero and the default block size is 64,512 bytes.
    
    For example, suppose you want a ﬁxed block size of 100K bytes, then you would specify:
    
    Minimum block size = 100K
    Maximum block size = 100K
    
    Please note that if you specify a ﬁxed block size as shown above, the tape drive must either be in variable block size mode, or if it is in ﬁxed block size mode, the block size (generally deﬁned by mt) must be identical to the size speciﬁed in Bareos – otherwise when you attempt to re-read your Volumes, you will get an error.
    
    If you want the block size to be variable but with a 63K minimum and 200K maximum (and default as well), you would specify:
    
    Minimum block size =  63K
    Maximum block size = 200K


Mount Command = <strname>

    This directive speciﬁes the command that must be executed to mount devices such as many USB devices. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point.
    
    See the Edit Codes for Mount and Unmount Directives section below for more details of the editing codes that can be used in this directive.
    
    If you need to specify multiple commands, create a shell script.  
Mount Point = <strname>

    Directory where the device can be mounted. This directive is used only for devices that have Requires Mount enabled such as USB ﬁle devices.  
Name = <name>
    (required)
    Unique identiﬁer of the resource.

    Speciﬁes the Name that the Director will use when asking to backup or restore to or from to this device. This is the logical Device name, and may be any string up to 127 characters in length. It is generally a good idea to make it correspond to the English name of the backup device. The physical name of the device is speciﬁed on the Archive Device Sd Device directive. The name you specify here is also used in your Director’s conﬁguration ﬁle on the Storage Resource in its Storage resource.  
No Rewind On Close = <yes|no>
    (default: yes)
    If Yes the storage daemon will not try to rewind the device on closing the device e.g. when shutting down the Storage daemon. This allows you to do an emergency shutdown of the Daemon without the need to wait for the device to rewind. On restarting and opening the device it will get a rewind anyhow and this way services don’t have to wait forever for a tape to spool back.  
Oﬄine On Unmount = <yes|no>
    (default: no)
    If Yes the archive device must support the MTOFFL ioctl to rewind and take the volume oﬄine. In this case, Bareos will issue the oﬄine (eject) request before closing the device during the unmount command. If No Bareos will not attempt to oﬄine the device before unmounting it. After an oﬄine is issued, the cassette will be ejected thus requiring operator intervention to continue, and on some systems require an explicit load command to be issued (mt -f /dev/xxx load) before the system will recognize the tape. If you are using an autochanger, some devices require an oﬄine to be issued prior to changing the volume. However, most devices do not and may get very confused.

    If you are using a Linux 2.6 kernel or other OSes such as FreeBSD or Solaris, the Oﬄine On Unmount will leave the drive with no tape, and Bareos will not be able to properly open the drive and may fail the job.  
Query Crypto Status = <yes|no>

    The default for this directive is No. If Yes the storage daemon may query the tape device for it security status. This only makes sense when Drive Crypto Enabled is also set to yes as the actual query is performed by the same Storage Daemon plugin and using the same SCSI SPIN protocol.  
Random Access = <yes|no>
    (default: no)
    If Yes, the archive device is assumed to be a random access medium which supports the lseek (or lseek64 if Largeﬁle is enabled during conﬁguration) facility. This should be set to Yes for all ﬁle systems such as USB, and ﬁxed ﬁles. It should be set to No for non-random access devices such as tapes and named pipes.  
Removable Media = <yes|no>
    (default: yes)
    If Yes, this device supports removable media (for example tapes). If No, media cannot be removed (for example, an intermediate backup area on a hard disk). If Removable media is enabled on a File device (as opposed to a tape) the Storage daemon will assume that device may be something like a USB device that can be removed or a simply a removable harddisk. When attempting to open such a device, if the Volume is not found (for File devices, the Volume name is the same as the Filename), then the Storage daemon will search the entire device looking for likely Volume names, and for each one found, it will ask the Director if the Volume can be used. If so, the Storage daemon will use the ﬁrst such Volume found. Thus it acts somewhat like a tape drive – if the correct Volume is not found, it looks at what actually is found, and if it is an appendable Volume, it will use it.

    If the removable medium is not automatically mounted (e.g. udev), then you might consider using additional Storage daemon device directives such as Requires Mount, Mount Point, Mount Command, and Unmount Command, all of which can be used in conjunction with Removable Media.  
Requires Mount = <yes|no>
    (default: no)
    When this directive is enabled, the Storage daemon will submit a Mount Command before attempting to open the device. You must set this directive to yes for removable ﬁle systems such as USB devices that are not automatically mounted by the operating system when plugged in or opened by Bareos. It should be set to no for all other devices such as tapes and ﬁxed ﬁlesystems. It should also be set to no for any removable device that is automatically mounted by the operating system when opened (e.g. USB devices mounted by udev or hotplug). This directive indicates if the device requires to be mounted using the Mount Command. To be able to write devices need a mount, the following directives must also be deﬁned: Mount Point, Mount Command, and Unmount Command.  
Spool Directory = <path>

    speciﬁes the name of the directory to be used to store the spool ﬁles for this device. This directory is also used to store temporary part ﬁles when writing to a device that requires mount (USB). The default is to use the working directory.  
Two Eof = <yes|no>
    (default: no)
    If Yes, Bareos will write two end of ﬁle marks when terminating a tape – i.e. after the last job or at the end of the medium. If No, Bareos will only write one end of ﬁle to terminate the tape.  
Unmount Command = <strname>

    This directive speciﬁes the command that must be executed to unmount devices such as many USB devices. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point.
    
    Most frequently, you will deﬁne it as follows:
    
    Unmount Command = "/bin/umount %m"
    
    See the Edit Codes for Mount and Unmount Directives section below for more details of the editing codes that can be used in this directive.
    
    If you need to specify multiple commands, create a shell script.  
Use Mtiocget = <yes|no>
    (default: yes)
    If No, the operating system is not required to support keeping track of the ﬁle number and reporting it in the (MTIOCGET ioctl). If you must set this to No, Bareos will do the proper ﬁle position determination, but it is very unfortunate because it means that tape movement is very ineﬃcient. Fortunately, this operation system deﬁciency seems to be the case only on a few *BSD systems. Operating systems known to work correctly are Solaris, Linux and FreeBSD.  
Volume Capacity = <Size64>


Volume Poll Interval = <time>
    (default: 300)
    If the time speciﬁed on this directive is non-zero, Bareos will periodically poll (or read) the drive at the speciﬁed interval to see if a new volume has been mounted. If the time interval is zero, no polling will occur. This directive can be useful if you want to avoid operator intervention via the console. Instead, the operator can simply remove the old volume and insert the requested one, and Bareos on the next poll will recognize the new tape and continue. Please be aware that if you set this interval too small, you may excessively wear your tape drive if the old tape remains in the drive, since Bareos will read it on each poll.  
Write Part Command = <strname>

    Please note! This directive is deprecated.


#
10.4.1 Edit Codes for Mount and Unmount Directives

Before submitting the Mount Command, or Unmount Command directives to the operating system, Bareos performs character substitution of the following characters:
    %% = %  
    %a = Archive device name  
    %e = erase (set if cannot mount and first part)  
    %n = part number  
    %m = mount point  
    %v = last part name (i.e. filename)

#
10.4.2 Devices that require a mount (USB)

    Requires Mount Sd Device You must set this directive to yes for removable devices such as USB unless they are automounted, and to no for all other devices (tapes/ﬁles). This directive indicates if the device requires to be mounted to be read, and if it must be written in a special way. If it set, Mount Point Sd Device, Mount Command Sd Device and Unmount Command Sd Device directives must also be deﬁned.
    Mount Point Sd Device Directory where the device can be mounted.
    Mount Command Sd Device Command that must be executed to mount the device. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point.
    
    Most frequently, you will deﬁne it as follows:


    Mount Command = "/bin/mount -t iso9660 -o ro %a %m"


    For some media, you may need multiple commands. If so, it is recommended that you use a shell script instead of putting them all into the Mount Command. For example, instead of this:


    Mount Command = "/usr/local/bin/mymount"


    Where that script contains:


    #!/bin/sh
    ndasadmin enable -s 1 -o w
    sleep 2
    mount /dev/ndas-00323794-0p1 /backup


    Similar consideration should be given to all other Command parameters.
    Unmount Command Sd Device Command that must be executed to unmount the device. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point.
    
    Most frequently, you will deﬁne it as follows:


    Unmount Command = "/bin/umount %m"


    If you need to specify multiple commands, create a shell script.

#
10.5 Autochanger Resource

The Autochanger resource supports single or multiple drive autochangers by grouping one or more Device resources into one unit called an autochanger in Bareos (often referred to as a ”tape library” by autochanger manufacturers).

If you have an Autochanger, and you want it to function correctly, you must have an Autochanger resource in your Storage conf ﬁle, and your Director’s Storage directives that want to use an Autochanger must refer to the Autochanger resource name.


conﬁguration directive name

type of data

default value

remark

Changer Command 	= strname 		required
Changer Device 	= strname 		required
Description 	= string 		
Device 	= ResourceList		required
Name 	= name 		required



Changer Command = <strname>
    (required)
    This command speciﬁes an external program to be called that will automatically change volumes as required by Bareos. Most frequently, you will specify the Bareos supplied mtx-changer script as follows. If it is speciﬁed here, it needs not to be speciﬁed in the Device resource. If it is also speciﬁed in the Device resource, it will take precedence over the one speciﬁed in the Autochanger resource.  
Changer Device = <strname>
    (required)
    The speciﬁed name-string gives the system ﬁle name of the autochanger device name. If speciﬁed in this resource, the Changer Device name is not needed in the Device resource. If it is speciﬁed in the Device resource (see above), it will take precedence over one speciﬁed in the Autochanger resource.  
Description = <string>


Device = <ResourceList>
    (required)
    Speciﬁes the names of the Device resource or resources that correspond to the autochanger drive. If you have a multiple drive autochanger, you must specify multiple Device names, each one referring to a separate Device resource that contains a Drive Index speciﬁcation that corresponds to the drive number base zero. You may specify multiple device names on a single line separated by commas, and/or you may specify multiple Device directives.  
Name = <name>
    (required)
    Speciﬁes the Name of the Autochanger. This name is used in the Director’s Storage deﬁnition to refer to the autochanger.  

The following is an example of a valid Autochanger resource deﬁnition:


Autochanger {
  Name = "DDS-4-changer"
  Device = DDS-4-1, DDS-4-2, DDS-4-3
  Changer Device = /dev/sg0
  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
}
Device {
  Name = "DDS-4-1"
  Drive Index = 0
  Autochanger = yes
  ...
}
Device {
  Name = "DDS-4-2"
  Drive Index = 1
  Autochanger = yes
  ...
Device {
  Name = "DDS-4-3"
  Drive Index = 2
  Autochanger = yes
  Autoselect = no
  ...
}


Conﬁguration 10.3: Autochanger Conﬁguration Example

Please note that it is important to include the Autochanger = yes directive in each Device deﬁnition that belongs to an Autochanger. A device deﬁnition should not belong to more than one Autochanger resource. Also, your Device directive in the Storage resource of the Director’s conf ﬁle should have the Autochanger’s resource name rather than a name of one of the Devices.

If you have a drive that physically belongs to an Autochanger but you don’t want to have it automatically used when Bareos references the Autochanger for backups, for example, you want to reserve it for restores, you can add the directive:
Autoselect = no

to the Device resource for that drive. In that case, Bareos will not automatically select that drive when accessing the Autochanger. You can still use the drive by referencing it by the Device name directly rather than the Autochanger name. An example of such a deﬁnition is shown above for the Device DDS-4-3, which will not be selected when the name DDS-4-changer is used in a Storage deﬁnition, but will be used if DDS-4-3 is used.

#
10.6 Messages Resource

For a description of the Messages Resource, please see the Messages Resource chapter of this manual.

#
10.7 Example Storage Daemon Conﬁguration File

A example Storage Daemon conﬁguration ﬁle might be the following:

#
# Default Bareos Storage Daemon Configuration file
#
#  For Bareos release 12.4.4 (12 June 2013) -- suse SUSE Linux Enterprise Server 11 (x86_64)
#
# You may need to change the name of your tape drive
#   on the "Archive Device" directive in the Device
#   resource.  If you change the Name and/or the
#   "Media Type" in the Device resource, please ensure
#   that dird.conf has corresponding changes.
#

Storage {                             # definition of myself
  Name = bareos-storage-sd
  Maximum Concurrent Jobs = 20

  # remove comment in next line to load plugins from specified directory
  # Plugin Directory = /usr/lib64/bareos/plugins
}

#
# List Directors who are permitted to contact Storage daemon
#
Director {
  Name = bareos-dir
  Password = "XXX_REPLACE_WITH_STORAGE_PASSWORD_XXX"
}

#
# Restricted Director, used by tray-monitor to get the
#   status of the storage daemon
#
Director {
  Name = bareos-storage-mon
  Password = "XXX_REPLACE_WITH_STORAGE_MONITOR_PASSWORD_XXX"
  Monitor = yes
}

#
# Note, for a list of additional Device templates please
#  see the directory <bareos-source>/examples/devices
# Or follow the following link:
#  http://bareos.svn.sourceforge.net/viewvc/bareos/trunk/bareos/examples/devices/
#

#
# Devices supported by this Storage daemon
# To connect, the Director’s bareos-dir.conf must have the
#  same Name and MediaType.
#

Device {
  Name = FileStorage
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes;                   # lets Bareos label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
}

#
# An autochanger device with two drives
#
#Autochanger {
#  Name = Autochanger
#  Device = Drive-1
#  Device = Drive-2
#  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
#  Changer Device = /dev/sg0
#}

#Device {
#  Name = Drive-1                      #
#  Drive Index = 0
#  Media Type = DLT-8000
#  Archive Device = /dev/nst0
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes;
#  RemovableMedia = yes;
#  RandomAccess = no;
#  AutoChanger = yes
#  #
#  # Enable the Alert command only if you have the mtx package loaded
#  # Note, apparently on some systems, tapeinfo resets the SCSI controller
#  #  thus if you turn this on, make sure it does not reset your SCSI
#  #  controller.  I have never had any problems, and smartctl does
#  #  not seem to cause such problems.
#  #
#  Alert Command = "sh -c ’tapeinfo -f %c |grep TapeAlert|cat’"
#  If you have smartctl, enable this, it has more info than tapeinfo
#  Alert Command = "sh -c ’smartctl -H -l error %c’"
#}

#Device {
#  Name = Drive-2                      #
#  Drive Index = 1
#  Media Type = DLT-8000
#  Archive Device = /dev/nst1
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes;
#  RemovableMedia = yes;
#  RandomAccess = no;
#  AutoChanger = yes
#  # Enable the Alert command only if you have the mtx package loaded
#  Alert Command = "sh -c ’tapeinfo -f %c |grep TapeAlert|cat’"
#  If you have smartctl, enable this, it has more info than tapeinfo
#  Alert Command = "sh -c ’smartctl -H -l error %c’"
#}

#
# A Linux or Solaris LTO-2 tape drive
#
#Device {
#  Name = LTO-2
#  Media Type = LTO-2
#  Archive Device = /dev/nst0
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes;
#  RemovableMedia = yes;
#  RandomAccess = no;
#  Maximum File Size = 3GB
## Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
## Changer Device = /dev/sg0
## AutoChanger = yes
#  # Enable the Alert command only if you have the mtx package loaded
## Alert Command = "sh -c ’tapeinfo -f %c |grep TapeAlert|cat’"
## If you have smartctl, enable this, it has more info than tapeinfo
## Alert Command = "sh -c ’smartctl -H -l error %c’"
#}

#
# A Linux or Solaris LTO-3 tape drive
#
#Device {
#  Name = LTO-3
#  Media Type = LTO-3
#  Archive Device = /dev/nst0
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes;
#  RemovableMedia = yes;
#  RandomAccess = no;
#  Maximum File Size = 4GB
## Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
## Changer Device = /dev/sg0
## AutoChanger = yes
#  # Enable the Alert command only if you have the mtx package loaded
## Alert Command = "sh -c ’tapeinfo -f %c |grep TapeAlert|cat’"
## If you have smartctl, enable this, it has more info than tapeinfo
## Alert Command = "sh -c ’smartctl -H -l error %c’"
#}

#
# A Linux or Solaris LTO-4 tape drive
#
#Device {
#  Name = LTO-4
#  Media Type = LTO-4
#  Archive Device = /dev/nst0
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes;
#  RemovableMedia = yes;
#  RandomAccess = no;
#  Maximum File Size = 5GB
## Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
## Changer Device = /dev/sg0
## AutoChanger = yes
#  # Enable the Alert command only if you have the mtx package loaded
## Alert Command = "sh -c ’tapeinfo -f %c |grep TapeAlert|cat’"
## If you have smartctl, enable this, it has more info than tapeinfo
## Alert Command = "sh -c ’smartctl -H -l error %c’"
#}




#
# A FreeBSD tape drive
#
#Device {
#  Name = DDS-4
#  Description = "DDS-4 for FreeBSD"
#  Media Type = DDS-4
#  Archive Device = /dev/nsa1
#  AutomaticMount = yes;               # when device opened, read it
#  AlwaysOpen = yes
#  Offline On Unmount = no
#  Hardware End of Medium = no
#  BSF at EOM = yes
#  Backward Space Record = no
#  Fast Forward Space File = no
#  TWO EOF = yes
#  If you have smartctl, enable this, it has more info than tapeinfo
#  Alert Command = "sh -c ’smartctl -H -l error %c’"
#}

#
# Send all messages to the Director,
# mount messages also are sent to the email address
#
Messages {
  Name = Standard
  director = bareos-dir = all
}

#
Chapter 11
Client/File Daemon Conﬁguration

The Client (or File Daemon) Conﬁguration is one of the simpler ones to specify. Generally, other than changing the Client name so that error messages are easily identiﬁed, you will not need to modify the default Client conﬁguration ﬁle.

For a general discussion of conﬁguration ﬁle and resources including the data types recognized by Bareos, please see the Conﬁguration chapter of this manual. The following Client Resource deﬁnitions must be deﬁned:

    Client – to deﬁne what Clients are to be backed up.
    Director – to deﬁne the Director’s name and its access password.
    Messages – to deﬁne where error and information messages are to be sent.

#
11.1 Client Resource

The Client Resource (or FileDaemon) resource deﬁnes the name of the Client (as used by the Director) as well as the port on which the Client listens for Director connections.

Start of the Client records. There must be one and only one Client resource in the conﬁguration ﬁle, since it deﬁnes the properties of the current client program.


conﬁguration directive name

type of data

default value

remark

Absolute Job Timeout 	= positive-integer		
Allow Bandwidth Bursting 	= yes|no 	no 	
Allowed Job Command 	= string-list 		
Allowed Script Dir 	= DirectoryList		
Always Use LMDB 	= yes|no 	no 	
Compatible 	= yes|no 	no 	
Description 	= string 		
FD Address 	= net-address 	9102 	
FD Addresses 	= net-addresses 	9102 	
FD Port 	= net-port 	9102 	
FD Source Address 	= net-address 	0 	
Heartbeat Interval 	= time 	0 	
LMDB Threshold 	= positive-integer		
Log Timestamp Format 	= string 		
Maximum Bandwidth Per Job 	= speed 		
Maximum Concurrent Jobs 	= positive-integer	20 	
Maximum Connections 	= positive-integer	42 	
Maximum Network Buﬀer Size 	= positive-integer		
Messages 	= resource-name 		

Name 	= name 		required
Pid Directory 	= path 	/var/lib/bareos (platform speciﬁc)
Pki Cipher 	= EncryptionCipher	aes128 	
Pki Encryption 	= yes|no 	no 	
Pki Key Pair 	= path 		
Pki Master Key 	= DirectoryList 		
Pki Signatures 	= yes|no 	no 	
Pki Signer 	= DirectoryList 		
Plugin Directory 	= path 		
Plugin Names 	= PluginNames 		
Scripts Directory 	= path 		
SD Connect Timeout 	= time 	1800 	
Secure Erase Command 	= string 		
Sub Sys Directory 	= path 		deprecated
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string		
TLS DH File 	= path 		
TLS Enable 	= yes|no	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer 	= yes|no	yes 	
Ver Id 	= string		
Working Directory	= path 	/var/lib/bareos (platform speciﬁc)


Absolute Job Timeout = <positive-integer>


Allow Bandwidth Bursting = <yes|no>
    (default: no)
    This option sets if there is Bandwidth Limiting in eﬀect if the limiting code can use bursting e.g. when from a certain timeslice not all bandwidth is used this bandwidth can be used in a next timeslice. Which mean you will get a smoother limiting which will be much closer to the actual limit set but it also means that sometimes the bandwidth will be above the setting here.  
Allowed Job Command = <string-list>

    This directive ﬁlters what type of jobs the ﬁledaemon should allow. Until now we had the -b (backup only) and -r (restore only) ﬂags which could be speciﬁed at the startup of the ﬁledaemon.
    
    Allowed Job Command can be deﬁned globally for all directors by adding it to the global ﬁledaemon resource or for a speciﬁc director when added to the director resource.
    
    You specify all commands you want to be executed by the ﬁledaemon. When you don’t specify the option it will be empty which means all commands are allowed.
    
    The following example shows how to use this functionality:
    
    Director {
      Name = <name>
      Password = <password>
      Allowed Job Command = "backup"
      Allowed Job Command = "runscript"
    }
    
    All commands that are allowed are speciﬁed each on a new line with the Allowed Job Command keyword.
    
    The following job commands are recognized:
    
    backup
        allow backups to be made
    restore
        allow restores to be done
    verify
        allow verify jobs to be done
    estimate
        allow estimate cmds to be executed
    runscript
        allow runscripts to run
    
    Only the important commands the ﬁledaemon can perform are ﬁltered, as some commands are part of the above protocols and by disallowing the action the other commands are not invoked at all.
    
    If runscripts are not needed it would be recommended as a security measure to disable running those or only allow the commands that you really want to be used.
    
    Runscripts are particularly a problem as they allow the Bareos File Daemon to run arbitrary commands. You may also look into the Allowed Script Dir Fd Client keyword to limit the impact of the runscript command.  
Allowed Script Dir = <DirectoryList>

    This directive limits the impact of the runscript command of the ﬁledaemon.
    
    It can be speciﬁed either for all directors by adding it to the global ﬁledaemon resource or for a speciﬁc director when added to the director resource.
    
    All directories in which the scripts or commands are located that you allow to be run by the runscript command of the ﬁledaemon. Any program not in one of these paths (or subpaths) cannot be used. The implementation checks if the full path of the script starts with one of the speciﬁed paths.
    
    The following example shows how to use this functionality:


    # bareos-fd.conf
    Director {
      Name = <name>
      Password = <password>
      Allowed Script Dir = "/etc/bareos"
      Allowed Script Dir = "/path/that/is/also/allowed"
    }



    # bareos-dir.conf
    Job {
       Name = "<name>"
       JobDefs = "DefaultJob"
       Client Run Before Job = "/etc/bareos/runbeforejob.sh"   # this will run
       Client Run Before Job = "/tmp/runbeforejob.sh"          # this will be blocked
    }


Always Use LMDB = <yes|no>
    (default: no)

Compatible = <yes|no>
    (default: no)
    This directive enables the compatible mode of the ﬁle daemon. In this mode the ﬁle daemon will try to be as compatible to a native Bacula ﬁle daemon as possible. Enabling this option means that certain new options available in Bareos cannot be used as they would lead to data not being able to be restored by a Native Bareos ﬁle daemon.

    The default value for this directive was changed from yes to no since Bareos Version >= 15.2.0.
    
    When you want to use bareos-only features, the value of compatible must be no.  
Description = <string>


FD Address = <net-address>
    (default: 9102)
    This record is optional, and if it is speciﬁed, it will cause the File daemon server (for Director connections) to bind to the speciﬁed IP-Address, which is either a domain name or an IP address speciﬁed as a dotted quadruple.  
FD Addresses = <net-addresses>
    (default: 9102)
    Specify the ports and addresses on which the File daemon listens for Director connections. Probably the simplest way to explain is to show an example:

    FDAddresses  = {
      ip = { addr = 1.2.3.4; port = 1205; }
      ipv4 = {
        addr = 1.2.3.4; port = http; }
      ipv6 = {
        addr = 1.2.3.4;
        port = 1205;
      }
      ip = {
        addr = 1.2.3.4
        port = 1205
      }
      ip = { addr = 1.2.3.4 }
      ip = {
        addr = 201:220:222::2
      }
      ip = {
        addr = bluedot.thun.net
      }
    }
    
    where ip, ip4, ip6, addr, and port are all keywords. Note, that the address can be speciﬁed as either a dotted quadruple, or IPv6 colon notation, or as a symbolic name (only in the ip speciﬁcation). Also, the port can be speciﬁed as a number or as the mnemonic value from the /etc/services ﬁle. If a port is not speciﬁed, the default will be used. If an ip section is speciﬁed, the resolution can be made either by IPv4 or IPv6. If ip4 is speciﬁed, then only IPv4 resolutions will be permitted, and likewise with ip6.  
FD Port = <net-port>
    (default: 9102)
    This speciﬁes the port number on which the Client listens for Director connections. It must agree with the FDPort speciﬁed in the Client resource of the Director’s conﬁguration ﬁle.  
FD Source Address = <net-address>
    (default: 0)
    If speciﬁed, the Bareos File Daemon will bind to the speciﬁed address when creating outbound connections. If this record is not speciﬁed, the kernel will choose the best address according to the routing table (the default).  
Heartbeat Interval = <time>
    (default: 0)
    This record deﬁnes an interval of time in seconds. For each heartbeat that the File daemon receives from the Storage daemon, it will forward it to the Director. In addition, if no heartbeat has been received from the Storage daemon and thus forwarded the File daemon will send a heartbeat signal to the Director and to the Storage daemon to keep the channels active. Setting the interval to 0 (zero) disables the heartbeat. This feature is particularly useful if you have a router that does not follow Internet standards and times out a valid connection after a short duration despite the fact that keepalive is set. This usually results in a broken pipe error message.  
LMDB Threshold = <positive-integer>


Log Timestamp Format = <string>


    Version >= 15.2.3
Maximum Bandwidth Per Job = <speed>

    The speed parameter speciﬁes the maximum allowed bandwidth that a job may use.  
Maximum Concurrent Jobs = <positive-integer>
    (default: 20)
    This directive speciﬁes the maximum number of Jobs that should run concurrently. Each contact from the Director (e.g. status request, job start request) is considered as a Job, so if you want to be able to do a status request in the console at the same time as a Job is running, you will need to set this value greater than 1.  
Maximum Connections = <positive-integer>
    (default: 42)

    Version >= 15.2.3
Maximum Network Buﬀer Size = <positive-integer>

    This directive speciﬁes the initial network buﬀer size to use. This size will be adjusted down if it is too large until it is accepted by the OS. Please use care in setting this value since if it is too large, it will be trimmed by 512 bytes until the OS is happy, which may require a large number of system calls. The default value is 65,536 bytes.
    
    Note, on certain Windows machines, there are reports that the transfer rates are very slow and this seems to be related to the default 65,536 size. On systems where the transfer rates seem abnormally slow compared to other systems, you might try setting the Maximum Network Buﬀer Size to 32,768 in both the File daemon and in the Storage daemon.  
Messages = <resource-name>


Name = <name>
    (required)
    The name of this resource. It is used to reference to it.

    The client name that must be used by the Director when connecting. Generally, it is a good idea to use a name related to the machine so that error messages can be easily identiﬁed if you have multiple Clients. This directive is required.  
Pid Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive speciﬁes a directory in which the File Daemon may put its process Id ﬁle ﬁles. The process Id ﬁle is used to shutdown Bareos and to prevent multiple copies of Bareos from running simultaneously.

    The Bareos ﬁle daemon uses a platform speciﬁc default value, that is deﬁned at compile time. Typically on Linux systems, it is set to /var/lib/bareos/ or /var/run/.  
Pki Cipher = <EncryptionCipher>
    (default: aes128)
    See the Data Encryption chapter of this manual.

    Depending on the openssl library version diﬀerent ciphers are available. To choose the desired cipher, you can use the PKI Cipher option in the ﬁledaemon conﬁguration. Note that you have to set Compatible Fd Client = no:
    
    FileDaemon {
       Name = client1-fd
    
       # encryption configuration
       PKI Signatures = Yes                          # Enable Data Signing
       PKI Encryption = Yes                          # Enable Data Encryption
       PKI Keypair    = "/etc/bareos/client1-fd.pem" # Public and Private Keys
       PKI Master Key = "/etc/bareos/master.cert"    # ONLY the Public Key
       PKI Cipher     = aes128                       # specify desired PKI Cipher here
    }
    
    The available options (and ciphers) are:
    
        aes128
        aes192
        aes256
        camellia128
        camellia192
        camellia256
        aes128hmacsha1
        aes256hmacsha1
        blowﬁsh
    
    They depend on the version of the openssl library installed.
    
    For decryption of encrypted data, the right decompression algorithm should be automatically chosen.


Pki Encryption = <yes|no>
    (default: no)
    See Data Encryption.  
Pki Key Pair = <path>

    See Data Encryption.  
Pki Master Key = <DirectoryList>

    See Data Encryption.  
Pki Signatures = <yes|no>
    (default: no)
    See Data Encryption.  
Pki Signer = <DirectoryList>

    See Data Encryption.  
Plugin Directory = <path>

    This directive speciﬁes a directory in which the File Daemon searches for plugins with the name <_pluginname>_-fd.so which it will load at startup. Typically on Linux systems, plugins are installed to /usr/lib/bareos/plugins/ or /usr/lib64/bareos/plugins/.  
Plugin Names = <PluginNames>

    If a Plugin Directory Fd Client is speciﬁed Plugin Names deﬁnes, which File Daemon Plugins get loaded.
    
    If Plugin Names is not deﬁned, all plugins get loaded, otherwise the deﬁned ones.  
Scripts Directory = <path>


SD Connect Timeout = <time>
    (default: 1800)
    This record deﬁnes an interval of time that the File daemon will try to connect to the Storage daemon. If no connection is made in the speciﬁed time interval, the File daemon cancels the Job.  
Secure Erase Command = <string>

    Specify command that will be called when bareos unlinks ﬁles.
    
    When ﬁles are no longer needed, Bareos will delete (unlink) them. With this directive, it will call the speciﬁed command to delete these ﬁles. See Secure Erase Command for details.  
    Version >= 15.2.1
Sub Sys Directory = <path>

    Please note! This directive is deprecated.

TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see how the Bareos Director (and the other components) have to be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.


Ver Id = <string>


Working Directory = <path>
    (default: /var/lib/bareos (platform speciﬁc))
    This directive is optional and speciﬁes a directory in which the File daemon may put its status ﬁles.

    On Win32 systems, in some circumstances you may need to specify a drive letter in the speciﬁed working directory path. Also, please be sure that this directory is writable by the SYSTEM user otherwise restores may fail (the bootstrap ﬁle that is transferred to the File daemon from the Director is temporarily put in this directory before being passed to the Storage daemon).  

The following is an example of a valid Client resource deﬁnition:
Client {                              # this is me  
  Name = rufus-fd  
}

#
11.2 Director Resource

The Director resource deﬁnes the name and password of the Directors that are permitted to contact this Client.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		
Allowed Job Command 	= string-list 		
Allowed Script Dir 	= DirectoryList		
Connection From Client To Director	= yes|no 	no 	
Connection From Director To Client	= yes|no 	yes 	
Description 	= string 		
Maximum Bandwidth Per Job 	= speed 		
Monitor 	= yes|no 	no 	
Name 	= name 		required
Password 	= Md5password 		required
Port 	= positive-integer	9101 	
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List 	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		

TLS Enable 	= yes|no	no 	
TLS Key 	= path 		
TLS Require 	= yes|no	no 	
TLS Verify Peer	= yes|no	yes


Address = <string>

    Director Network Address. Only required if ”Connection From Client To Director” is enabled.


Allowed Job Command = <string-list>

    see Allowed Job Command Fd Client  
Allowed Script Dir = <DirectoryList>

    see Allowed Script Dir Fd Client  
Connection From Client To Director = <yes|no>
    (default: no)
    Let the Filedaemon initiate network connections to the Director.

    For details, see Client Initiated Connection.  
    Version >= 16.2.2
Connection From Director To Client = <yes|no>
    (default: yes)
    This Client will accept incoming network connection from this Director.


    Version >= 16.2.2
Description = <string>


Maximum Bandwidth Per Job = <speed>

    The speed parameter speciﬁes the maximum allowed bandwidth that a job may use when started from this Director. The speed parameter should be speciﬁed in k/s, Kb/s, m/s or Mb/s.  
Monitor = <yes|no>
    (default: no)
    If Monitor is set to no, this director will have full access to this Client. If Monitor is set to yes, this director will only be able to fetch the current status of this Client.

    Please note that if this director is being used by a Monitor, we highly recommend to set this directive to yes to avoid serious security problems.  
Name = <name>
    (required)
    The name of the Director that may contact this Client. This name must be the same as the name speciﬁed on the Director resource in the Director’s conﬁguration ﬁle. Note, the case (upper/lower) of the characters in the name are signiﬁcant (i.e. S is not the same as s). This directive is required.  
Password = <Md5password>
    (required)
    Speciﬁes the password that must be supplied for a Director to be authorized. This password must be the same as the password speciﬁed in the Client resource in the Director’s conﬁguration ﬁle. This directive is required.  
Port = <positive-integer>
    (default: 9101)
    Director Network Port. Only used if ”Connection From Client To Director” is enabled.


    Version >= 16.2.2
TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see how the Bareos Director (and the other components) have to be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.



Thus multiple Directors may be authorized to use this Client’s services. Each Director will have a diﬀerent name, and normally a diﬀerent password as well.

The following is an example of a valid Director resource deﬁnition:
#  
# List Directors who are permitted to contact the File daemon  
#  
Director {  
  Name = HeadMan  
  Password = very_good                # password HeadMan must supply  
}  
Director {  
  Name = Worker  
  Password = not_as_good  
  Monitor = Yes  
}

#
11.3 Messages Resource

Please see the Messages Resource Chapter of this manual for the details of the Messages Resource.

There must be at least one Message resource in the Client conﬁguration ﬁle.

#
11.4 Example Client Conﬁguration File

An example File Daemon conﬁguration ﬁle might be the following:
#  
# Default  Bareos File Daemon Configuration file  
#  
#  For Bareos release 12.4.4 (12 June 2013)  
#  
# There is not much to change here except perhaps the  
# File daemon Name to  
#  

#  
# List Directors who are permitted to contact this File daemon  
#  
Director {  
  Name = bareos-dir  
  Password = "aEODFz89JgUbWpuG6hP4OTuAoMvfM1PaJwO+ShXGqXsP"  
}  

#  
# Restricted Director, used by tray-monitor to get the  
#   status of the file daemon  
#  
Director {  
  Name = client1-mon  
  Password = "8BoVwTju2TQlafdHFExRIJmUcHUMoIyIqPJjbvcSO61P"  
  Monitor = yes  
}  

#  
# "Global" File daemon configuration specifications  
#  
FileDaemon {                          # this is me  
  Name = client1-fd  
  Maximum Concurrent Jobs = 20  

  # remove comment in next line to load plugins from specified directory  
  # Plugin Directory = /usr/lib64/bareos/plugins  
}  

# Send all messages except skipped files back to Director  
Messages {  
  Name = Standard  
  director = client1-dir = all, !skipped, !restored  
}

#
Chapter 12
Messages Resource

The Messages resource deﬁnes how messages are to be handled and destinations to which they should be sent.

Even though each daemon has a full message handler, within the File daemon and the Storage daemon, you will normally choose to send all the appropriate messages back to the Director. This permits all the messages associated with a single Job to be combined in the Director and sent as a single email message to the user, or logged together in a single ﬁle.

Each message that Bareos generates (i.e. that each daemon generates) has an associated type such as INFO, WARNING, ERROR, FATAL, etc. Using the message resource, you can specify which message types you wish to see and where they should be sent. In addition, a message may be sent to multiple destinations. For example, you may want all error messages both logged as well as sent to you in an email. By deﬁning multiple messages resources, you can have diﬀerent message handling for each type of Job (e.g. Full backups versus Incremental backups).

In general, messages are attached to a Job and are included in the Job report. There are some rare cases, where this is not possible, e.g. when no job is running, or if a communications error occurs between a daemon and the director. In those cases, the message may remain in the system, and should be ﬂushed at the end of the next Job. However, since such messages are not attached to a Job, any that are mailed will be sent to /usr/lib/sendmail. On some systems, such as FreeBSD, if your sendmail is in a diﬀerent place, you may want to link it to the the above location.

The records contained in a Messages resource consist of a destination speciﬁcation followed by a list of message-types in the format:

destination = message-type1, message-type2, message-type3, ...

or for those destinations that need and address speciﬁcation (e.g. email):

destination = address = message-type1, message-type2, message-type3, ...

    where
    
    destination
        is one of a predeﬁned set of keywords that deﬁne where the message is to be sent (Append Dir Messages, Console Dir Messages, File Dir Messages, Mail Dir Messages, ...),
    address
        varies according to the destination keyword, but is typically an email address or a ﬁlename,
    message-type
        is one of a predeﬁned set of keywords that deﬁne the type of message generated by Bareos: ERROR, WARNING, FATAL, ...


conﬁguration directive name

type of data

default value

remark

Append 	= [ address = ] message-type [ , message-type ]* 		
Catalog 	= [ address = ] message-type [ , message-type ]* 		
Console 	= [ address = ] message-type [ , message-type ]* 		
Description 	= string 		
Director 	= [ address = ] message-type [ , message-type ]* 		
File 	= [ address = ] message-type [ , message-type ]* 		
Mail 	= [ address = ] message-type [ , message-type ]* 		
Mail Command 	= string 		
Mail On Error 	= [ address = ] message-type [ , message-type ]* 		
Mail On Success 	= [ address = ] message-type [ , message-type ]* 		
Name 	= name 		
Operator 	= [ address = ] message-type [ , message-type ]* 		
Operator Command 	= string 		
Stderr 	= [ address = ] message-type [ , message-type ]* 		
Stdout 	= [ address = ] message-type [ , message-type ]* 		
Syslog 	= [ address = ] message-type [ , message-type ]* 		
Timestamp Format 	= string 		



Append = <[ address = ] message-type [ , message-type ]* >

    Append the message to the ﬁlename given in the address ﬁeld. If the ﬁle already exists, it will be appended to. If the ﬁle does not exist, it will be created.  
Catalog = <[ address = ] message-type [ , message-type ]* >

    Send the message to the Catalog database. The message will be written to the table named Log and a timestamp ﬁeld will also be added. This permits Job Reports and other messages to be recorded in the Catalog so that they can be accessed by reporting software. Bareos will prune the Log records associated with a Job when the Job records are pruned. Otherwise, Bareos never uses these records internally, so this destination is only used for special purpose programs (e.g. frontend programs).  
Console = <[ address = ] message-type [ , message-type ]* >

    Send the message to the Bareos console. These messages are held until the console program connects to the Director.  
Description = <string>


Director = <[ address = ] message-type [ , message-type ]* >

    Send the message to the Director whose name is given in the address ﬁeld. Note, in the current implementation, the Director Name is ignored, and the message is sent to the Director that started the Job.  
File = <[ address = ] message-type [ , message-type ]* >

    Send the message to the ﬁlename given in the address ﬁeld. If the ﬁle already exists, it will be overwritten.  
Mail = <[ address = ] message-type [ , message-type ]* >

    Send the message to the email addresses that are given as a comma separated list in the address ﬁeld. Mail messages are grouped together during a job and then sent as a single email message when the job terminates. The advantage of this destination is that you are notiﬁed about every Job that runs. However, if you backup mutliple machines every night, the number of email messages can be annoying. Some users use ﬁlter programs such as procmail to automatically ﬁle this email based on the Job termination code (see Mail Command Dir Messages).  
Mail Command = <string>

    In the absence of this resource, Bareos will send all mail using the following command:
    
    mail -s ”Bareos Message” <recipients>
    
    In many cases, depending on your machine, this command may not work. However, by using the Mail Command, you can specify exactly how to send the mail. During the processing of the command part, normally speciﬁed as a quoted string, the following substitutions will be used:
    
        %% = %
        %c = Client’s name
        %d = Director’s name
        %e = Job Exit code (OK, Error, ...)
        %h = Client address
        %i = Job Id
        %j = Unique Job name
        %l = Job level
        %n = Job name
        %r = Recipients
        %s = Since time
        %t = Job type (e.g. Backup, ...)
        %v = Read Volume name (Only on director side)
        %V = Write Volume name (Only on director side)
    
    Please note: any Mail Command directive must be speciﬁed in the Messages resource before the desired Mail Dir Messages, Mail On Success Dir Messages or Mail On Error Dir Messages directive. In fact, each of those directives may be preceded by a diﬀerent Mail Command.
    
    A default installation will use the program bsmtp as Mail Command. The program bsmtp is provided by Bareos and uniﬁes the usage of a mail client to a certain degree:
    
    Mail Command = "/usr/sbin/bsmtp -h mail.example.com -f \"\(Bareos\) \%r\" -s \"Bareos: \%t \%e of \%c \%l\" \%r"
    
    The bsmtp program is provided as part of Bareos. For additional details, please see the bsmtp section. Please test any Mail Command that you use to ensure that your smtp gateway accepts the addressing form that you use. Certain programs such as Exim can be very selective as to what forms are permitted particularly in the from part.  
Mail On Error = <[ address = ] message-type [ , message-type ]* >

    Send the message to the email addresses that are given as a comma separated list in the address ﬁeld if the Job terminates with an error condition. Mail On Error messages are grouped together during a job and then sent as a single email message when the job terminates. This destination diﬀers from the mail destination in that if the Job terminates normally, the message is totally discarded (for this destination). If the Job terminates in error, it is emailed. By using other destinations such as append you can ensure that even if the Job terminates normally, the output information is saved.  
Mail On Success = <[ address = ] message-type [ , message-type ]* >

    Send the message to the email addresses that are given as a comma separated list in the address ﬁeld if the Job terminates normally (no error condition). Mail On Success messages are grouped together during a job and then sent as a single email message when the job terminates. This destination diﬀers from the mail destination in that if the Job terminates abnormally, the message is totally discarded (for this destination). If the Job terminates normally, it is emailed.  
Name = <name>

    The name of the Messages resource. The name you specify here will be used to tie this Messages resource to a Job and/or to the daemon.  
Operator = <[ address = ] message-type [ , message-type ]* >

    Send the message to the email addresses that are speciﬁed as a comma separated list in the address ﬁeld. This is similar to mail above, except that each message is sent as received. Thus there is one email per message. This is most useful for mount messages (see below).  
Operator Command = <string>

    This resource speciﬁcation is similar to the Mail Command Dir Messages except that it is used for Operator messages. The substitutions performed for the Mail Command Dir Messages are also done for this command. Normally, you will set this command to the same value as speciﬁed for the Mail Command Dir Messages. The Operator Command directive must appear in the Messages resource before the Operator Dir Messages directive.  
Stderr = <[ address = ] message-type [ , message-type ]* >

    Send the message to the standard error output (normally not used).  
Stdout = <[ address = ] message-type [ , message-type ]* >

    Send the message to the standard output (normally not used).  
Syslog = <[ address = ] message-type [ , message-type ]* >

    Send the message to the system log (syslog).
    
    Since Version >= 14.4.0 the facility can be speciﬁed in the address ﬁeld and the loglevel correspond to the Bareos Message Types. The defaults are DAEMON and LOG_ERR.
    
    Although the syslog destination is not used in the default Bareos conﬁg ﬁles, in certain cases where Bareos encounters errors in trying to deliver a message, as a last resort, it will send it to the system syslog to prevent loss of the message, so you might occassionally check the syslog for Bareos output.  
Timestamp Format = <string>



#
12.1 Message Types

For any destination, the message-type ﬁeld is a comma separated list of the following types or classes of messages:

info

    General information messages.
warning

    Warning messages. Generally this is some unusual condition but not expected to be serious.
error

    Non-fatal error messages. The job continues running. Any error message should be investigated as it means that something went wrong.
fatal

    Fatal error messages. Fatal errors cause the job to terminate.
terminate

    Message generated when the daemon shuts down.
notsaved

    Files not saved because of some error. Usually because the ﬁle cannot be accessed (i.e. it does not exist or is not mounted).
skipped

    Files that were skipped because of a user supplied option such as an incremental backup or a ﬁle that matches an exclusion pattern. This is not considered an error condition such as the ﬁles listed for the notsaved type because the conﬁguration ﬁle explicitly requests these types of ﬁles to be skipped. For example, any unchanged ﬁle during an incremental backup, or any subdirectory if the no recursion option is speciﬁed.
mount

    Volume mount or intervention requests from the Storage daemon. These requests require a speciﬁc operator intervention for the job to continue.
restored

    The ls style listing generated for each ﬁle restored is sent to this message class.
all

    All message types.
security

    Security info/warning messages principally from unauthorized connection attempts.
alert

    Alert messages. These are messages generated by tape alerts.
volmgmt

    Volume management messages. Currently there are no volume mangement messages generated.
audit

    Audit messages. Interacting with the Bareos Director will be audited. Can be conﬁgured with in resource Auditing Dir Director.

The following is an example of a valid Messages resource deﬁnition, where all messages except ﬁles explicitly skipped or daemon termination messages are sent by email to backupoperator@example.com. In addition all mount messages are sent to the operator (i.e. emailed to backupoperator@example.com). Finally all messages other than explicitly skipped ﬁles and ﬁles saved are sent to the console:


Messages {
  Name = Standard
  Mail = backupoperator@example.com = all, !skipped, !terminate
  Operator = backupoperator@example.com = mount
  Console = all, !skipped, !saved
}


Conﬁguration 12.1: Message resource

With the exception of the email address, an example Director’s Messages resource is as follows:


Messages {
  Name = Standard
  Mail Command = "/usr/sbin/bsmtp -h mail.example.com  -f \"\(Bareos\) %r\" -s \"Bareos: %t %e of %c %l\" %r"
  Operator Command = "/usr/sbin/bsmtp -h mail.example.com -f \"\(Bareos\) %r\" -s \"Bareos: Intervention needed for %j\" %r"
  Mail On Error = backupoperator@example.com = all, !skipped, !terminate
  Append = "/var/log/bareos/bareos.log" = all, !skipped, !terminate
  Operator = backupoperator@example.com = mount
  Console = all, !skipped, !saved
}


Conﬁguration 12.2: Message resource

#
Chapter 13
Console Conﬁguration

The Console conﬁguration ﬁle is the simplest of all the conﬁguration ﬁles, and in general, you should not need to change it except for the password. It simply contains the information necessary to contact the Director or Directors.

For a general discussion of the syntax of conﬁguration ﬁles and their resources including the data types recognized by Bareos, please see the Conﬁguration chapter of this manual.

The following Console Resource deﬁnition must be deﬁned: #
13.1 Director Resource

The Director resource deﬁnes the attributes of the Director running on the network. You may have multiple Director resource speciﬁcations in a single Console conﬁguration ﬁle. If you have more than one, you will be prompted to choose one when you start the Console program.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		
Description 	= string 		
Dir Port 	= positive-integer	9101 	
Heartbeat Interval 	= time 	0 	
Name 	= name 		required
Password 	= Md5password 		required
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		
TLS Enable 	= yes|no 	no 	
TLS Key 	= path 		
TLS Require 	= yes|no 	no 	
TLS Verify Peer 	= yes|no 	yes 	



Address = <string>

    Where the address is a host name, a fully qualiﬁed domain name, or a network address used to connect to the Director.  
Description = <string>


Dir Port = <positive-integer>
    (default: 9101)
    This port must be identical to the Dir Port Dir Director speciﬁed in the Director Conﬁguration ﬁle.  
Heartbeat Interval = <time>
    (default: 0)

Name = <name>
    (required)
    The director name used to select among diﬀerent Directors, otherwise, this name is not used.  
Password = <Md5password>
    (required)
    This password is used to authenticate when connecting to the Bareos Director as default console. It must correspond to Password Dir Director.  
TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see how the Bareos Director (and the other components) have to be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.



An actual example might be:
Director {  
  Name = HeadMan  
  address = rufus.cats.com  
  password = xyz1erploit  
}

#
13.2 Console Resource

There are three diﬀerent kinds of consoles, which the administrator or user can use to interact with the Director. These three kinds of consoles comprise three diﬀerent security levels.

    The ﬁrst console type is an anonymous or default console, which has full privileges. There is no console resource necessary for this type since the password is speciﬁed in the Director resource. Typically you would use this anonymous console only for administrators.
    The second type of console is a ”named” or ”restricted” console deﬁned within a Console resource in both the Director’s conﬁguration ﬁle and in the Console’s conﬁguration ﬁle. Both the names and the passwords in these two entries must match much as is the case for Client programs.
    
    This second type of console begins with absolutely no privileges except those explicitly speciﬁed in the Director’s Console resource. Note, the deﬁnition of what these restricted consoles can do is determined by the Director’s conf ﬁle.
    
    Thus you may deﬁne within the Director’s conf ﬁle multiple Consoles with diﬀerent names and passwords, sort of like multiple users, each with diﬀerent privileges. As a default, these consoles can do absolutely nothing – no commands what so ever. You give them privileges or rather access to commands and resources by specifying access control lists in the Director’s Console resource. This gives the administrator ﬁne grained control over what particular consoles (or users) can do.
    The third type of console is similar to the above mentioned restricted console in that it requires a Console resource deﬁnition in both the Director and the Console. In addition, if the console name, provided on the Name = directive, is the same as a Client name, the user of that console is permitted to use the SetIP command to change the Address directive in the Director’s client resource to the IP address of the Console. This permits portables or other machines using DHCP (non-ﬁxed IP addresses) to ”notify” the Director of their current IP address.

The Console resource is optional and need not be speciﬁed. However, if it is speciﬁed, you can use ACLs (Access Control Lists) in the Director’s conﬁguration ﬁle to restrict the particular console (or user) to see only information pertaining to his jobs or client machine.

You may specify as many Console resources in the console’s conf ﬁle. If you do so, generally the ﬁrst Console resource will be used. However, if you have multiple Director resources (i.e. you want to connect to diﬀerent directors), you can bind one of your Console resources to a particular Director resource, and thus when you choose a particular Director, the appropriate Console conﬁguration resource will be used. See the ”Director” directive in the Console resource described below for more information.

Note, the Console resource is optional, but can be useful for restricted consoles as noted above.


conﬁguration directive name

type of data

default value

remark

Description 	= string 		
Director 	= string 		
Heartbeat Interval 	= time 	0 	
History File 	= path 		
History Length 	= positive-integer	100 	
Name 	= name 		required
Password 	= Md5password 		required
Rc File 	= path 		
TLS Allowed CN 	= string-list 		
TLS Authenticate 	= yes|no 	no 	
TLS CA Certiﬁcate Dir 	= path 		
TLS CA Certiﬁcate File 	= path 		
TLS Certiﬁcate 	= path 		
TLS Certiﬁcate Revocation List	= path 		
TLS Cipher List 	= string 		
TLS DH File 	= path 		
TLS Enable 	= yes|no 	no 	
TLS Key 	= path 		
TLS Require 	= yes|no 	no 	

TLS Verify Peer	= yes|no	yes


Description = <string>


Director = <string>

    If this directive is speciﬁed, this Console resource will be used by bconsole when that particular director is selected when ﬁrst starting bconsole. I.e. it binds a particular console resource with its name and password to a particular director.  
Heartbeat Interval = <time>
    (default: 0)
    This directive is optional and if speciﬁed will cause the Console to set a keepalive interval (heartbeat) in seconds on each of the sockets to communicate with the Director. It is implemented only on systems (Linux, ...) that provide the setsockopt TCP_KEEPIDLE function. If the value is set to 0 (zero), no change is made to the socket.  
History File = <path>

    If this directive is speciﬁed and the console is compiled with readline support, it will use the given ﬁlename as history ﬁle. If not speciﬁed, the history ﬁle will be named ~/.bconsole_history  
History Length = <positive-integer>
    (default: 100)
    If this directive is speciﬁed the history ﬁle will be truncated after HistoryLength entries.  
Name = <name>
    (required)
    The name of this resource.

    The Console name used to allow a restricted console to change its IP address using the SetIP command. The SetIP command must also be deﬁned in the Director’s conf CommandACL list.  
Password = <Md5password>
    (required)
    If this password is supplied, then the password speciﬁed in the Director resource of you Console conf will be ignored. See below for more details.  
Rc File = <path>


TLS Allowed CN = <string-list>

    ”Common Name”s (CNs) of the allowed peer certiﬁcates.


TLS Authenticate = <yes|no>
    (default: no)
    Use TLS only to authenticate, not for encryption.


TLS CA Certiﬁcate Dir = <path>

    Path of a TLS CA certiﬁcate directory.


TLS CA Certiﬁcate File = <path>

    Path of a PEM encoded TLS CA certiﬁcate(s) ﬁle.


TLS Certiﬁcate = <path>

    Path of a PEM encoded TLS certiﬁcate.


TLS Certiﬁcate Revocation List = <path>

    Path of a Certiﬁcate Revocation List ﬁle.


TLS Cipher List = <string>

    List of valid TLS Ciphers.


TLS DH File = <path>

    Path to PEM encoded Diﬃe-Hellman parameter ﬁle. If this directive is speciﬁed, DH key exchange will be used for the ephemeral keying, allowing for forward secrecy of communications.


TLS Enable = <yes|no>
    (default: no)
    Enable TLS support.

    Bareos can be conﬁgured to encrypt all its network traﬃc. See chapter TLS Conﬁguration Directives to see how the Bareos Director (and the other components) have to be conﬁgured to use TLS.  
TLS Key = <path>

    Path of a PEM encoded private key. It must correspond to the speciﬁed ”TLS Certiﬁcate”.


TLS Require = <yes|no>
    (default: no)
    Without setting this to yes, Bareos can fall back to use unencryption connections. Enabling this implicietly sets ”TLS Enable = yes”.


TLS Verify Peer = <yes|no>
    (default: yes)
    If disabled, all certiﬁcates signed by a known CA will be accepted. If enabled, the CN of a certiﬁcate must the Address or in the ”TLS Allowed CN” list.



#
13.3 Example Console Conﬁguration File

The following conﬁguration ﬁles were supplied by Phil Stracchino. For example, if we deﬁne the following in the user’s bconsole.conf ﬁle:


Director {
   Name = MyDirector
   Address = myserver
   Password = "XXXXXXXXXXX"
}

Console {
   Name = restricted-user
   Password = "UntrustedUser"
}


Where the Password in the Director section is deliberately incorrect, and the Console resource is given a name, in this case restricted-user. Then in the Director’s bareos-dir.conf ﬁle (not directly accessible by the user), we deﬁne:


Console {
  Name = restricted-user
  Password = "UntrustedUser"
  JobACL = "Restricted Client Save"
  ClientACL = restricted-client
  StorageACL = main-storage
  ScheduleACL = *all*
  PoolACL = *all*
  FileSetACL = "Restricted Client’s FileSet"
  CatalogACL = DefaultCatalog
  CommandACL = run
}


the user logging into the Director from his Console will get logged in as restricted-user, and he will only be able to see or access a Job with the name Restricted Client Save a Client with the name restricted-client, a Storage device main-storage, any Schedule or Pool, a FileSet named Restricted Client’s FileSet, a Catalog named DefaultCatalog, and the only command he can use in the Console is the run command. In other words, this user is rather limited in what he can see and do with Bareos.

The following is an example of a bconsole.conf ﬁle that can access several Directors and has diﬀerent Consoles depending on the director:


Director {
   Name = MyDirector
   Address = myserver
   Password = "XXXXXXXXXXX"    # no, really.  this is not obfuscation.
}

Director {
   Name = SecondDirector
   Address = secondserver
   Password = "XXXXXXXXXXX"    # no, really.  this is not obfuscation.
}

Console {
   Name = restricted-user
   Password = "UntrustedUser"
   Director = MyDirector
}

Console {
   Name = restricted-user
   Password = "A different UntrustedUser"
   Director = SecondDirector
}


The second Director referenced at ”secondserver” might look like the following:


Console {
  Name = restricted-user
  Password = "A different UntrustedUser"
  JobACL = "Restricted Client Save"
  ClientACL = restricted-client
  StorageACL = second-storage
  ScheduleACL = *all*
  PoolACL = *all*
  FileSetACL = "Restricted Client’s FileSet"
  CatalogACL = RestrictedCatalog
  CommandACL = run, restore
  WhereACL = "/"
}


An example Console conﬁguration ﬁle might be the following:


#
# Bareos Console Configuration File
#
Director {
  Name = "bareos.example.com-dir"
  address = "bareos.example.com"
  Password = "PASSWORD"
}


#
Chapter 14
Monitor Conﬁguration

The Monitor conﬁguration ﬁle is a stripped down version of the Director conﬁguration ﬁle, mixed with a Console conﬁguration ﬁle. It simply contains the information necessary to contact Directors, Clients, and Storage daemons you want to monitor.

For a general discussion of conﬁguration ﬁle and resources including the data types recognized by Bareos, please see the Conﬁguration chapter of this manual.

The following Monitor Resource deﬁnition must be deﬁned:

    Monitor – to deﬁne the Monitor’s name used to connect to all the daemons and the password used to connect to the Directors. Note, you must not deﬁne more than one Monitor resource in the Monitor conﬁguration ﬁle.
    At least one Client, Storage or Director resource, to deﬁne the daemons to monitor.

#
14.1 Monitor Resource

The Monitor resource deﬁnes the attributes of the Monitor running on the network. The parameters you deﬁne here must be conﬁgured as a Director resource in Clients and Storages conﬁguration ﬁles, and as a Console resource in Directors conﬁguration ﬁles.


conﬁguration directive name

type of data

default value

remark

Description 	= string 		
Dir Connect Timeout 	= time 	10 	
FD Connect Timeout 	= time 	10 	
Name 	= name 		required
Password 	= Md5password		required
Refresh Interval 	= time 	60 	
Require SSL 	= yes|no 	no 	
SD Connect Timeout 	= time 	10 	



Description = <string>


Dir Connect Timeout = <time>
    (default: 10)

FD Connect Timeout = <time>
    (default: 10)

Name = <name>
    (required)
    Speciﬁes the Director name used to connect to Client and Storage, and the Console name used to connect to Director. This record is required.  
Password = <Md5password>
    (required)
    Where the password is needed for Directors to accept the Console connection. This password must be identical to the Password speciﬁed in the Console resource of the Director’s conﬁguration ﬁle. This record is required if you wish to monitor Directors.  
Refresh Interval = <time>
    (default: 60)
    Speciﬁes the time to wait between status requests to each daemon. It can’t be set to less than 1 second or more than 10 minutes.  
Require SSL = <yes|no>
    (default: no)

SD Connect Timeout = <time>
    (default: 10)


#
14.2 Director Resource

The Director resource deﬁnes the attributes of the Directors that are monitored by this Monitor.

As you are not permitted to deﬁne a Password in this resource, to avoid obtaining full Director privileges, you must create a Console resource in the Director’s conﬁguration ﬁle, using the Console Name and Password deﬁned in the Monitor resource. To avoid security problems, you should conﬁgure this Console resource to allow access to no other daemons, and permit the use of only two commands: status and .status (see below for an example).

You may have multiple Director resource speciﬁcations in a single Monitor conﬁguration ﬁle.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		required
Description 	= string 		
Dir Port 	= positive-integer	9101 	
Enable SSL 	= yes|no 	no 	
Name 	= name 		required



Address = <string>
    (required)
    Where the address is a host name, a fully qualiﬁed domain name, or a network address used to connect to the Director. This record is required.  
Description = <string>


Dir Port = <positive-integer>
    (default: 9101)
    Speciﬁes the port to use to connect to the Director. This port must be identical to the DIRport speciﬁed in the Director resource of the Director Conﬁguration ﬁle.  
Enable SSL = <yes|no>
    (default: no)

Name = <name>
    (required)
    The Director name used to identify the Director in the list of monitored daemons. It is not required to be the same as the one deﬁned in the Director’s conﬁguration ﬁle. This record is required.  

#
14.3 Client Resource

The Client resource deﬁnes the attributes of the Clients that are monitored by this Monitor.

You must create a Director resource in the Client’s conﬁguration ﬁle, using the Director Name deﬁned in the Monitor resource. To avoid security problems, you should set the Monitor directive to Yes in this Director resource.

You may have multiple Director resource speciﬁcations in a single Monitor conﬁguration ﬁle.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		required
Description 	= string 		
Enable SSL 	= yes|no 	no 	
FD Port 	= positive-integer	9102 	
Name 	= name 		required
Password 	= Md5password 		required



Address = <string>
    (required)
    Where the address is a host name, a fully qualiﬁed domain name, or a network address in dotted quad notation for a Bareos File daemon. This record is required.  
Description = <string>


Enable SSL = <yes|no>
    (default: no)

FD Port = <positive-integer>
    (default: 9102)
    Where the port is a port number at which the Bareos File daemon can be contacted.  
Name = <name>
    (required)
    The Client name used to identify the Director in the list of monitored daemons. It is not required to be the same as the one deﬁned in the Client’s conﬁguration ﬁle. This record is required.  
Password = <Md5password>
    (required)
    This is the password to be used when establishing a connection with the File services, so the Client conﬁguration ﬁle on the machine to be backed up must have the same password deﬁned for this Director. This record is required.  

#
14.4 Storage Resource

The Storage resource deﬁnes the attributes of the Storages that are monitored by this Monitor.

You must create a Director resource in the Storage’s conﬁguration ﬁle, using the Director Name deﬁned in the Monitor resource. To avoid security problems, you should set the Monitor directive to Yes in this Director resource.

You may have multiple Director resource speciﬁcations in a single Monitor conﬁguration ﬁle.


conﬁguration directive name

type of data

default value

remark

Address 	= string 		required
Description 	= string 		
Enable SSL 	= yes|no 	no 	
Name 	= name 		required
Password 	= Md5password 		required
SD Address 	= string 		
SD Password 	= Md5password 		
SD Port 	= positive-integer	9103 	



Address = <string>
    (required)
    Where the address is a host name, a fully qualiﬁed domain name, or a network address in dotted quad notation for a Bareos Storage daemon. This record is required.  
Description = <string>


Enable SSL = <yes|no>
    (default: no)

Name = <name>
    (required)
    The Storage name used to identify the Director in the list of monitored daemons. It is not required to be the same as the one deﬁned in the Storage’s conﬁguration ﬁle. This record is required.  
Password = <Md5password>
    (required)
    This is the password to be used when establishing a connection with the Storage services. This same password also must appear in the Director resource of the Storage daemon’s conﬁguration ﬁle. This record is required.  
SD Address = <string>


SD Password = <Md5password>


SD Port = <positive-integer>
    (default: 9103)
    Where port is the port to use to contact the storage daemon for information and to start jobs. This same port number must appear in the Storage resource of the Storage daemon’s conﬁguration ﬁle.  

#
14.5 Tray Monitor

Tray Monitor Security

There is no security problem in relaxing the permissions on tray-monitor.conf as long as FD, SD and DIR are conﬁgured properly, so the passwords contained in this ﬁle only gives access to the status of the daemons. It could be a security problem if you consider the status information as potentially dangerous (most people consider this as not being dangerous).

Concerning Director’s conﬁguration:
In tray-monitor.conf, the password in the Monitor resource must point to a restricted console in bareos-dir.conf (see the documentation). So, if you use this password with bconsole, you’ll only have access to the status of the director (commands status and .status). It could be a security problem if there is a bug in the ACL code of the director.

Concerning File and Storage Daemons’ conﬁguration:
In tray-monitor.conf, the Name in the Monitor resource must point to a Director resource in bareos-fd/sd.conf, with the Monitor directive set to Yes (see the documentation). It could be a security problem if there is a bug in the code which check if a command is valid for a Monitor (this is very unlikely as the code is pretty simple).

Example Tray Monitor conﬁguration

An example Tray Monitor conﬁguration ﬁle might be the following:


#
# Bareos Tray Monitor Configuration File
#
Monitor {
  Name = rufus-mon        # password for Directors
  Password = "GN0uRo7PTUmlMbqrJ2Gr1p0fk0HQJTxwnFyE4WSST3MWZseR"
  RefreshInterval = 10 seconds
}

Client {
  Name = rufus-fd
  Address = rufus
  FDPort = 9102           # password for FileDaemon
  Password = "FYpq4yyI1y562EMS35bA0J0QC0M2L3t5cZObxT3XQxgxppTn"
}
Storage {
  Name = rufus-sd
  Address = rufus
  SDPort = 9103           # password for StorageDaemon
  Password = "9usxgc307dMbe7jbD16v0PXlhD64UVasIDD0DH2WAujcDsc6"
}
Director {
  Name = rufus-dir
  DIRport = 9101
  address = rufus
}


Conﬁguration 14.1: Example tray-monitor.conf

Example File daemon’s Director record


#
# Restricted Director, used by tray-monitor to get the
#   status of the file daemon
#
Director {
  Name = rufus-mon
  Password = "FYpq4yyI1y562EMS35bA0J0QC0M2L3t5cZObxT3XQxgxppTn"
  Monitor = yes
}


Conﬁguration 14.2: Example Monitor resource

A full example can be found at Example Client Conﬁguration File.

Example Storage daemon’s Director record


#
# Restricted Director, used by tray-monitor to get the
#   status of the storage daemon
#
Director {
  Name = rufus-mon
  Password = "9usxgc307dMbe7jbD16v0PXlhD64UVasIDD0DH2WAujcDsc6"
  Monitor = yes
}


Conﬁguration 14.3: Example Monitor resource

A full example can be found at Example Storage Daemon Conﬁguration File.

Example Director’s Console record


#
# Restricted console used by tray-monitor to get the status of the director
#
Console {
  Name = Monitor
  Password = "GN0uRo7PTUmlMbqrJ2Gr1p0fk0HQJTxwnFyE4WSST3MWZseR"
  CommandACL = status, .status
}


Conﬁguration 14.4: Example Monitor resource

A full example can be found at Example Director Conﬁguration File.

Part III
Tasks and Concepts

#
Chapter 15
Bareos Console

The Bareos Console (bconsole) is a program that allows the user or the System Administrator, to interact with the Bareos Director daemon while the daemon is running.

The current Bareos Console comes as a shell interface (TTY style). It permit the administrator or authorized users to interact with Bareos. You can determine the status of a particular job, examine the contents of the Catalog as well as perform certain tape manipulations with the Console program.

Since the Console program interacts with the Director through the network, your Console and Director programs do not necessarily need to run on the same machine.

In fact, a certain minimal knowledge of the Console program is needed in order for Bareos to be able to write on more than one tape, because when Bareos requests a new tape, it waits until the user, via the Console program, indicates that the new tape is mounted. #
15.1 Console Conﬁguration

When the Console starts, it reads a standard Bareos conﬁguration ﬁle named bconsole.conf unless you specify the -c command line option (see below). This ﬁle allows default conﬁguration of the Console, and at the current time, the only Resource Record deﬁned is the Director resource, which gives the Console the name and address of the Director. For more information on conﬁguration of the Console program, please see the Console Conﬁguration chapter of this document.

#
15.2 Running the Console Program

The console program can be run with the following options:

root@linux:~# bconsole -?  
Usage: bconsole [-s] [-c config_file] [-d debug_level]  
       -D <dir>    select a Director  
       -l          list Directors defined  
       -c <file>   set configuration file to file  
       -d <nn>     set debug level to <nn>  
       -dt         print timestamp in debug output  
       -n          no conio  
       -s          no signals  
       -u <nn>     set command execution timeout to <nn> seconds  
       -t          test - read configuration and exit  
       -?          print this message.
Command 1: bconsole command line options

After launching the Console program (bconsole), it will prompt you for the next command with an asterisk (*). Generally, for all commands, you can simply enter the command name and the Console program will prompt you for the necessary arguments. Alternatively, in most cases, you may enter the command followed by arguments. The general format is:
 <command> <keyword1>[=<argument1>] <keyword2>[=<argument2>] ...

where command is one of the commands listed below; keyword is one of the keywords listed below (usually followed by an argument); and argument is the value. The command may be abbreviated to the shortest unique form. If two commands have the same starting letters, the one that will be selected is the one that appears ﬁrst in the help listing. If you want the second command, simply spell out the full command. None of the keywords following the command may be abbreviated.

For example:
list files jobid=23

will list all ﬁles saved for JobId 23. Or:
show pools

will display all the Pool resource records.

The maximum command line length is limited to 511 characters, so if you are scripting the console, you may need to take some care to limit the line length.

#
15.2.1 Exit the Console Program

Normally, you simply enter quit or exit and the Console program will terminate. However, it waits until the Director acknowledges the command. If the Director is already doing a lengthy command (e.g. prune), it may take some time. If you want to immediately terminate the Console program, enter the .quit command.

There is currently no way to interrupt a Console command once issued (i.e. Ctrl-C does not work). However, if you are at a prompt that is asking you to select one of several possibilities and you would like to abort the command, you can enter a period (.), and in most cases, you will either be returned to the main command prompt or if appropriate the previous prompt (in the case of nested prompts). In a few places such as where it is asking for a Volume name, the period will be taken to be the Volume name. In that case, you will most likely be able to cancel at the next prompt.

#
15.2.2 Running the Console from a Shell Script

You can automate many Console tasks by running the console program from a shell script. For example, if you have created a ﬁle containing the following commands:
 bconsole -c ./bconsole.conf <<END_OF_DATA  
 unmount storage=DDS-4  
 quit  
 END_OF_DATA

when that ﬁle is executed, it will unmount the current DDS-4 storage device. You might want to run this command during a Job by using the RunBeforeJob or RunAfterJob records.

It is also possible to run the Console program from ﬁle input where the ﬁle contains the commands as follows:
bconsole -c ./bconsole.conf <filename

where the ﬁle named ﬁlename contains any set of console commands.

As a real example, the following script is part of the Bareos regression tests. It labels a volume (a disk volume), runs a backup, then does a restore of the ﬁles saved.
bconsole <<END_OF_DATA  
@output /dev/null  
messages  
@output /tmp/log1.out  
label volume=TestVolume001  
run job=Client1 yes  
wait  
messages  
@#  
@# now do a restore  
@#  
@output /tmp/log2.out  
restore current all  
yes  
wait  
messages  
@output  
quit  
END_OF_DATA

The output from the backup is directed to /tmp/log1.out and the output from the restore is directed to /tmp/log2.out. To ensure that the backup and restore ran correctly, the output ﬁles are checked with:
grep "^ *Termination: *Backup OK" /tmp/log1.out  
backupstat=$?  
grep "^ *Termination: *Restore OK" /tmp/log2.out  
restorestat=$?

#
15.3 Console Keywords

Unless otherwise speciﬁed, each of the following keywords takes an argument, which is speciﬁed after the keyword following an equal sign. For example:
jobid=536

all
    Permitted on the status and show commands to specify all components or resources respectively.
allfrompool
    Permitted on the update command to specify that all Volumes in the pool (speciﬁed on the command line) should be updated.
allfrompools
    Permitted on the update command to specify that all Volumes in all pools should be updated.
before
    Used in the restore command.
bootstrap
    Used in the restore command.
catalog
    Allowed in the use command to specify the catalog name to be used.
catalogs
    Used in the show command. Takes no arguments.
client | fd
clients
    Used in the show, list, and llist commands. Takes no arguments.
counters
    Used in the show command. Takes no arguments.
current
    Used in the restore command. Takes no argument.
days
    Used to deﬁne the number of days the list nextvol command should consider when looking for jobs to be run. The days keyword can also be used on the status dir command so that it will display jobs scheduled for the number of days you want. It can also be used on the rerun command, where it will automatically select all failed jobids in the last number of days for rerunning.
devices
    Used in the show command. Takes no arguments.
director | dir
directors
    Used in the show command. Takes no arguments.
directory
    Used in the restore command. Its argument speciﬁes the directory to be restored.
enabled
    This keyword can appear on the update volume as well as the update slots commands, and can allows one of the following arguments: yes, true, no, false, archived, 0, 1, 2. Where 0 corresponds to no or false, 1 corresponds to yes or true, and 2 corresponds to archived. Archived volumes will not be used, nor will the Media record in the catalog be pruned. Volumes that are not enabled, will not be used for backup or restore.
done
    Used in the restore command. Takes no argument.
ﬁle
    Used in the restore command.
ﬁles
    Used in the list and llist commands. Takes no arguments.
ﬁleset
ﬁlesets
    Used in the show command. Takes no arguments.
help
    Used in the show command. Takes no arguments.
hours
    Used on the rerun command to select all failed jobids in the last number of hours for rerunning.
jobs
    Used in the show, list and llist commands. Takes no arguments.
jobmedia
    Used in the list and llist commands. Takes no arguments.
jobtotals
    Used in the list and llist commands. Takes no arguments.
jobid
    The JobId is the numeric jobid that is printed in the Job Report output. It is the index of the database record for the given job. While it is unique for all the existing Job records in the catalog database, the same JobId can be reused once a Job is removed from the catalog. Probably you will refer speciﬁc Jobs that ran using their numeric JobId.

    JobId can be used on the rerun command to select all jobs failed after and including the given jobid for rerunning.
job | jobname
    The Job or Jobname keyword refers to the name you speciﬁed in the Job resource, and hence it refers to any number of Jobs that ran. It is typically useful if you want to list all jobs of a particular name.
level
listing
    Permitted on the estimate command. Takes no argument.
limit
messages
    Used in the show command. Takes no arguments.
media
    Used in the list and llist commands. Takes no arguments.
nextvolume | nextvol
    Used in the list and llist commands. Takes no arguments.
on
    Takes no keyword.
oﬀ
    Takes no keyword.
pool
pools
    Used in the show, list, and llist commands. Takes no arguments.
select
    Used in the restore command. Takes no argument.
limit
    Used in the setbandwidth command. Takes integer in KB/s unit.
schedules
    Used in the show command. Takes no arguments.
storage | store | sd
storages
    Used in the show command. Takes no arguments.
ujobid
    The ujobid is a unique job identiﬁcation that is printed in the Job Report output. At the current time, it consists of the Job name (from the Name directive for the job) appended with the date and time the job was run. This keyword is useful if you want to completely identify the Job instance run.
volume
volumes
    Used in the list and llist commands. Takes no arguments.
where
    Used in the restore command.
yes
    Used in the restore command. Takes no argument.

#
15.4 Console Commands

The following commands are currently implemented:

add
    This command is used to add Volumes to an existing Pool. That is, it creates the Volume name in the catalog and inserts into the Pool in the catalog, but does not attempt to access the physical Volume. Once added, Bareos expects that Volume to exist and to be labeled. This command is not normally used since Bareos will automatically do the equivalent when Volumes are labeled. However, there may be times when you have removed a Volume from the catalog and want to later add it back.

    The full form of this command is:


    add [pool=<pool−name> storage=<storage> jobid=<JobId>


    bconsole 15.1: add
    
    Normally, the label command is used rather than this command because the label command labels the physical media (tape, disk, DVD, ...) and does the equivalent of the add command. The add command aﬀects only the Catalog and not the physical media (data on Volumes). The physical media must exist and be labeled before use (usually with the label command). This command can, however, be useful if you wish to add a number of Volumes to the Pool that will be physically labeled at a later time. It can also be useful if you are importing a tape from another site. Please see the label command below for the list of legal characters in a Volume name.
autodisplay
    This command accepts on or oﬀ as an argument, and turns auto-display of messages on or oﬀ respectively. The default for the console program is oﬀ, which means that you will be notiﬁed when there are console messages pending, but they will not automatically be displayed.

    When autodisplay is turned oﬀ, you must explicitly retrieve the messages with the messages command. When autodisplay is turned on, the messages will be displayed on the console as they are received.
automount
    This command accepts on or oﬀ as the argument, and turns auto-mounting of the Volume after a label command on or oﬀ respectively. The default is on. If automount is turned oﬀ, you must explicitly mount tape Volumes after a label command to use it.
cancel
    This command is used to cancel a job and accepts jobid=nnn or job=xxx as an argument where nnn is replaced by the JobId and xxx is replaced by the job name. If you do not specify a keyword, the Console program will prompt you with the names of all the active jobs allowing you to choose one.

    The full form of this command is:


    cancel [jobid=<number> job=<job−name> ujobid=<unique−jobid>]


    bconsole 15.2: cancel
    
    Once a Job is marked to be cancelled, it may take a bit of time (generally within a minute but up to two hours) before the Job actually terminates, depending on what operations it is doing. Don’t be surprised that you receive a Job not found message. That just means that one of the three daemons had already canceled the job. Messages numbered in the 1000’s are from the Director, 2000’s are from the File daemon and 3000’s from the Storage daemon.
    
    It is possible to cancel multiple jobs at once. Therefore, the following extra options are available for the job-selection:
    
        all jobs
        all jobs with a created state
        all jobs with a blocked state
        all jobs with a waiting state
        all jobs with a running state
    
    Usage:


    cancel all
    cancel all state=<created|blocked|waiting|running>


    bconsole 15.3: cancel all
    
    Sometimes the Director already removed the job from its running queue, but the storage daemon still thinks it is doing a backup (or another job) - so you cannot cancel the job from within a console anymore. Therefore it is possible to cancel a job by JobId on the storage daemon. It might be helpful to execute a status storage on the Storage Daemon to make sure what job you want to cancel.
    
    Usage:


    cancel storage=<Storage Daemon> Jobid=<JobId>


    bconsole 15.4: cancel on Storage Daemon
    
    This way you can also remove a job that blocks any other jobs from running without the need to restart the whole storage daemon.
create
    This command is not normally used as the Pool records are automatically created by the Director when it starts based on what it ﬁnds in the conﬁguration. If needed, this command can be used, to create a Pool record in the database using the Pool resource record deﬁned in the Director’s conﬁguration ﬁle. So in a sense, this command simply transfers the information from the Pool resource in the conﬁguration ﬁle into the Catalog. Normally this command is done automatically for you when the Director starts providing the Pool is referenced within a Job resource. If you use this command on an existing Pool, it will automatically update the Catalog to have the same information as the Pool resource. After creating a Pool, you will most likely use the label command to label one or more volumes and add their names to the Media database.

    The full form of this command is:


    create [pool=<pool−name>]


    bconsole 15.5: create
    
    When starting a Job, if Bareos determines that there is no Pool record in the database, but there is a Pool resource of the appropriate name, it will create it for you. If you want the Pool record to appear in the database immediately, simply use this command to force it to be created.
conﬁgure

    Conﬁgures director resources during runtime. The ﬁrst conﬁgure subcommand configure add is available since Bareos Version >= 16.2.4. Other subcommands may follow in later releases.
    
    add
    
        This command allows to add resources during runtime. Usage:


        configure add <resourcetype> name=<resourcename> <directive1>=<value1> <directive2>=<value2> ...


        The command generates and loads a new, valid resource. As the new resource is also stored at
    
        <_CONFIGDIR>_/bareos-dir.d/<_resourcetype>_/<_resourcename>_.conf
    
        (see Resource ﬁle conventions) it is persistent upon reload and restart.
    
        This feature requires Subdirectory Conﬁguration Scheme.
    
        All kinds of resources can be added. When adding a client resource, the Director Resource for the Bareos File Daemon is also created and stored at:
    
        <_CONFIGDIR>_/bareos-dir-export/client/<_clientname>_/bareos-fd.d/director/<_clientname>_.conf


        *configure add client name=client2−fd address=192.168.0.2 password=secret
        Created resource config file ”/etc/bareos/bareos−dir.d/client/client2−fd.conf”:
        Client {
          Name = client2−fd
          Address = 192.168.0.2
          Password = secret
        }
        *configure add job name=client2−job client=client2−fd jobdefs=DefaultJob
        Created resource config file ”/etc/bareos/bareos−dir.d/job/client2−job.conf”:
        Job {
          Name = client2−job
          Client = client2−fd
          JobDefs = DefaultJob
        }


        bconsole 15.6: Example: adding a client and a job resource during runtime
    
        These two commands create three resource conﬁguration ﬁles:
    
            /etc/bareos/bareos-dir.d/client/client2-fd.conf
            /etc/bareos/bareos-dir-export/client/ client2-fd/bareos-fd.d/director/bareos-dir.conf (assuming your director resource is named bareos-dir)
            /etc/bareos/bareos-dir.d/job/client2-job.conf
    
        The ﬁles in bareos-dir-export/client/ directory are not used by the Bareos Director. However, they can be copied to new clients to conﬁgure these clients for the Bareos Director.
    
        Please note! Don’t be confused by the extensive output of help configure. As configure add allows conﬁguring arbitrary resources, the output of help configure lists all the resources, each with all valid directives. The same data is also used for bconsole command line completion.

delete
    The delete command is used to delete a Volume, Pool or Job record from the Catalog as well as all associated catalog Volume records that were created. This command operates only on the Catalog database and has no eﬀect on the actual data written to a Volume. This command can be dangerous and we strongly recommend that you do not use it unless you know what you are doing.

    If the keyword Volume appears on the command line, the named Volume will be deleted from the catalog, if the keyword Pool appears on the command line, a Pool will be deleted, and if the keyword Job appears on the command line, a Job and all its associated records (File and JobMedia) will be deleted from the catalog.
    
    The full form of this command is:


    delete pool=<pool−name>
    delete volume=<volume−name> pool=<pool−name>
    delete JobId=<job−id> JobId=<job−id2> ...
    delete Job JobId=n,m,o−r,t ...


    bconsole 15.7: delete
    
    The ﬁrst form deletes a Pool record from the catalog database. The second form deletes a Volume record from the speciﬁed pool in the catalog database. The third form deletes the speciﬁed Job record from the catalog database. The last form deletes JobId records for JobIds n, m, o, p, q, r, and t. Where each one of the n,m,... is, of course, a number. That is a ”delete jobid” accepts lists and ranges of jobids.
disable
    This command permits you to disable a Job for automatic scheduling. The job may have been previously enabled with the Job resource Enabled directive or using the console enable command. The next time the Director is reloaded or restarted, the Enable/Disable state will be set to the value in the Job resource (default enabled) as deﬁned in the Bareos Director conﬁguration.

    The full form of this command is:


    disable job=<job−name>


    bconsole 15.8: disable
enable
    This command permits you to enable a Job for automatic scheduling. The job may have been previously disabled with the Job resource Enabled directive or using the console disable command. The next time the Director is reloaded or restarted, the Enable/Disable state will be set to the value in the Job resource (default enabled) as deﬁned in the Bareos Director conﬁguration.

    The full form of this command is:


    enable job=<job−name>


    bconsole 15.9: enable

estimate
    Using this command, you can get an idea how many ﬁles will be backed up, or if you are unsure about your Include statements in your FileSet, you can test them without doing an actual backup. The default is to assume a Full backup. However, you can override this by specifying a level=Incremental or level=Diﬀerential on the command line. A Job name must be speciﬁed or you will be prompted for one, and optionally a Client and FileSet may be speciﬁed on the command line. It then contacts the client which computes the number of ﬁles and bytes that would be backed up. Please note that this is an estimate calculated from the number of blocks in the ﬁle rather than by reading the actual bytes. As such, the estimated backup size will generally be larger than an actual backup.

    The estimate command can use the accurate code to detect changes and give a better estimation. You can set the accurate behavior on command line using accurate=yes/no or use the Job setting as default value.
    
    Optionally you may specify the keyword listing in which case, all the ﬁles to be backed up will be listed. Note, it could take quite some time to display them if the backup is large. The full form is:
    
    The full form of this command is:


    estimate job=<job−name> listing client=<client−name> accurate=<yes|no> fileset=<fileset−name> level=<level−name>


    bconsole 15.10: estimate
    
    Speciﬁcation of the job is suﬃcient, but you can also override the client, ﬁleset, accurate and/or level by specifying them on the estimate command line.
    
    As an example, you might do:


    @output /tmp/listing
    estimate job=NightlySave listing level=Incremental
    @output


    bconsole 15.11: estimate: redirected output
    
    which will do a full listing of all ﬁles to be backed up for the Job NightlySave during an Incremental save and put it in the ﬁle /tmp/listing. Note, the byte estimate provided by this command is based on the ﬁle size contained in the directory item. This can give wildly incorrect estimates of the actual storage used if there are sparse ﬁles on your systems. Sparse ﬁles are often found on 64 bit systems for certain system ﬁles. The size that is returned is the size Bareos will backup if the sparse option is not speciﬁed in the FileSet. There is currently no way to get an estimate of the real ﬁle size that would be found should the sparse option be enabled.
exit
    This command terminates the console program.
export
    The export command is used to export tapes from an autochanger. Most Automatic Tapechangers oﬀer special slots for importing new tape cartridges or exporting written tape cartridges. This can happen without having to set the device oﬄine.

    The full form of this command is:


    export storage=<storage−name> srcslots=<slot−selection> [dstslots=<slot−selection> volume=<volume−name> scan]


    bconsole 15.12: export
    
    The export command does exactly the opposite of the import command. You can specify which slots should be transferred to import/export slots. The most useful application of the export command is the possibility to automatically transfer the volumes of a certain backup into the import/export slots for external storage.
    
    To be able to to this, the export command also accepts a list of volume names to be exported.
    
    Example:


    export volume=A00020L4|A00007L4|A00005L4


    bconsole 15.13: export volume
    
    Instead of exporting volumes by names you can also select a number of slots via the srcslots keyword and export those to the slots you specify in dstslots. The export command will check if the slots have content (e.g. otherwise there is not much to export) and if there are enough export slots and if those are really import/export slots.
    
    Example:


    export srcslots=1−2 dstslots=37−38


    bconsole 15.14: export slots
    
    To automatically export the Volumes used by a certain backup job, you can use the following RunScript in that job:


    RunScript {
        Console = ”export storage=TandbergT40 volume=%V”
        RunsWhen = After
        RunsOnClient = no
    }


    bconsole 15.15: automatic export
    
    To send an e-mail notiﬁcation via the Messages resource regarding export tapes you can use the Variable %V substitution in the Messages resource, which is implemented in Bareos 13.2. However, it does also work in earlier releases inside the job resources. So in versions prior to Bareos 13.2 the following workaround can be used:


    RunAfterJob = ”/bin/bash −c ∖”/bin/echo Remove Tape %V | ∖
    /usr/sbin/bsmtp −h localhost −f root@localhost −s ’Remove Tape %V’ root@localhost ∖””


    bconsole 15.16: e-mail notiﬁcation via messages resource regarding export tapes
gui
    Invoke the non-interactive gui mode. This command is only used when bconsole is commanded by an external program.
help
    This command displays the list of commands available.
import
    The import command is used to import tapes into an autochanger. Most Automatic Tapechangers oﬀer special slots for importing new tape cartridges or exporting written tape cartridges. This can happen without having to set the device oﬄine.

    The full form of this command is:


    import storage=<storage−name> [srcslots=<slot−selection> dstslots=<slot−selection> volume=<volume−name> scan]


    bconsole 15.17: import
    
    To import new tapes into the autochanger, you only have to load the new tapes into the import/export slots and call import from the cmdline.
    
    The import command will automatically transfer the new tapes into free slots of the autochanger. The slots are ﬁlled in order of the slot numbers. To import all tapes, there have to be enough free slots to load all tapes.
    
    Example with a Library with 36 Slots and 3 Import/Export Slots:


    *import storage=TandbergT40
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”slots” command.
    Device ”Drive−1” has 39 slots.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”listall” command.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger transfer command.
    3308 Successfully transfered volume from slot 37 to 20.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger transfer command.
    3308 Successfully transfered volume from slot 38 to 21.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger transfer command.
    3308 Successfully transfered volume from slot 39 to 25.


    bconsole 15.18: import example
    
    You can also import certain slots when you don’t have enough free slots in your autochanger to put all the import/export slots in.
    
    Example with a Library with 36 Slots and 3 Import/Export Slots importing one slot:


    *import storage=TandbergT40 srcslots=37 dstslots=20
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”slots” command.
    Device ”Drive−1” has 39 slots.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”listall” command.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger transfer command.
    3308 Successfully transfered volume from slot 37 to 20.


    bconsole 15.19: import example
label
    This command is used to label physical volumes. The full form of this command is:


    label storage=<storage−name> volume=<volume−name> slot=<slot>


    bconsole 15.20: label
    
    If you leave out any part, you will be prompted for it. The media type is automatically taken from the Storage resource deﬁnition that you supply. Once the necessary information is obtained, the Console program contacts the speciﬁed Storage daemon and requests that the Volume be labeled. If the Volume labeling is successful, the Console program will create a Volume record in the appropriate Pool.
    
    The Volume name is restricted to letters, numbers, and the special characters hyphen (-), underscore (_), colon (:), and period (.). All other characters including a space are invalid. This restriction is to ensure good readability of Volume names to reduce operator errors.
    
    Please note, when labeling a blank tape, Bareos will get read I/O error when it attempts to ensure that the tape is not already labeled. If you wish to avoid getting these messages, please write an EOF mark on your tape before attempting to label it:
           mt rewind  
           mt weof
    
    The label command can fail for a number of reasons:
    
        The Volume name you specify is already in the Volume database.
        The Storage daemon has a tape or other Volume already mounted on the device, in which case you must unmount the device, insert a blank tape, then do the label command.
        The Volume in the device is already a Bareos labeled Volume. (Bareos will never relabel a Bareos labeled Volume unless it is recycled and you use the relabel command).
        There is no Volume in the drive.
    
    There are two ways to relabel a volume that already has a Bareos label. The brute force method is to write an end of ﬁle mark on the tape using the system mt program, something like the following:
           mt -f /dev/st0 rewind  
           mt -f /dev/st0 weof
    
    For a disk volume, you would manually delete the Volume.
    
    Then you use the label command to add a new label. However, this could leave traces of the old volume in the catalog.
    
    The preferable method to relabel a Volume is to ﬁrst purge the volume, either automatically, or explicitly with the purge command, then use the relabel command described below.
    
    If your autochanger has barcode labels, you can label all the Volumes in your autochanger one after another by using the label barcodes command. For each tape in the changer containing a barcode, Bareos will mount the tape and then label it with the same name as the barcode. An appropriate Media record will also be created in the catalog. Any barcode that begins with the same characters as speciﬁed on the ”CleaningPreﬁx=xxx” (default is ”CLN”) directive in the Director’s Pool resource, will be treated as a cleaning tape, and will not be labeled. However, an entry for the cleaning tape will be created in the catalog. For example with:


    Pool {
        Name ...
        Cleaning Prefix = "CLN"
    }


    Conﬁguration 15.21: Cleaning Tape
    
    Any slot containing a barcode of CLNxxxx will be treated as a cleaning tape and will not be mounted. Note, the full form of the command is:


    label storage=xxx pool=yyy slots=1−5,10 barcodes


    bconsole 15.22: label
list
    The list command lists the requested contents of the Catalog. The various ﬁelds of each record are listed on a single line. The various forms of the list command are:


    list jobs
    list jobid=<id>           (list jobid id)
    list ujobid=<unique job name> (list job with unique name)
    list job=<job−name>   (list all jobs with ”job−name”)
    list jobname=<job−name>  (same as above)
        In the above, you can add ”limit=nn” to limit the output to nn jobs.
    list joblog jobid=<id> (list job output if recorded in the catalog)
    list jobmedia
    list jobmedia jobid=<id>
    list jobmedia job=<job−name>
    list files jobid=<id>
    list files job=<job−name>
    list pools
    list clients
    list jobtotals
    list volumes
    list volumes jobid=<id>
    list volumes pool=<pool−name>
    list volumes job=<job−name>
    list volume=<volume−name>
    list nextvolume job=<job−name>
    list nextvol job=<job−name>
    list nextvol job=<job−name> days=nnn


    bconsole 15.23: list
    
    What most of the above commands do should be more or less obvious. In general if you do not specify all the command line arguments, the command will prompt you for what is needed.
    
    The list nextvol command will print the Volume name to be used by the speciﬁed job. You should be aware that exactly what Volume will be used depends on a lot of factors including the time and what a prior job will do. It may ﬁll a tape that is not full when you issue this command. As a consequence, this command will give you a good estimate of what Volume will be used but not a deﬁnitive answer. In addition, this command may have certain side eﬀect because it runs through the same algorithm as a job, which means it may automatically purge or recycle a Volume. By default, the job speciﬁed must run within the next two days or no volume will be found. You can, however, use the days=nnn speciﬁcation to specify up to 50 days. For example, if on Friday, you want to see what Volume will be needed on Monday, for job MyJob, you would use list nextvol job=MyJob days=3.
    
    If you wish to add specialized commands that list the contents of the catalog, you can do so by adding them to the query.sql ﬁle. However, this takes some knowledge of programming SQL. Please see the query command below for additional information. See below for listing the full contents of a catalog record with the llist command.
    
    As an example, the command list pools might produce the following output:


    *list pools
    +−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−−+−−−−−−−−−−−−−+
    | PoId | Name    | NumVols | MaxVols | PoolType | LabelFormat |
    +−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−−+−−−−−−−−−−−−−+
    |    1 | Default |       0 |       0 | Backup   | *           |
    |    2 | Recycle |       0 |       8 | Backup   | File        |
    +−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−+−−−−−−−−−−+−−−−−−−−−−−−−+


    bconsole 15.24: list pools
    
    As mentioned above, the list command lists what is in the database. Some things are put into the database immediately when Bareos starts up, but in general, most things are put in only when they are ﬁrst used, which is the case for a Client as with Job records, etc.
    
    Bareos should create a client record in the database the ﬁrst time you run a job for that client. Doing a status will not cause a database record to be created. The client database record will be created whether or not the job fails, but it must at least start. When the Client is actually contacted, additional info from the client will be added to the client record (a ”uname -a” output).
    
    If you want to see what Client resources you have available in your conf ﬁle, you use the Console command show clients.
llist
    The llist or ”long list” command takes all the same arguments that the list command described above does. The diﬀerence is that the llist command list the full contents of each database record selected. It does so by listing the various ﬁelds of the record vertically, with one ﬁeld per line. It is possible to produce a very large number of output lines with this command.

    If instead of the list pools as in the example above, you enter llist pools you might get the following output:


    *llist pools
              PoolId: 1
                Name: Default
             NumVols: 0
             MaxVols: 0
             UseOnce: 0
          UseCatalog: 1
     AcceptAnyVolume: 1
        VolRetention: 1,296,000
      VolUseDuration: 86,400
          MaxVolJobs: 0
         MaxVolBytes: 0
           AutoPrune: 0
             Recycle: 1
            PoolType: Backup
         LabelFormat: *
    
              PoolId: 2
                Name: Recycle
             NumVols: 0
             MaxVols: 8
             UseOnce: 0
          UseCatalog: 1
     AcceptAnyVolume: 1
        VolRetention: 3,600
      VolUseDuration: 3,600
          MaxVolJobs: 1
         MaxVolBytes: 0
           AutoPrune: 0
             Recycle: 1
            PoolType: Backup
         LabelFormat: File


    bconsole 15.25: llist pools
messages
    This command causes any pending console messages to be immediately displayed.
memory
    Print current memory usage.
mount
    The mount command is used to get Bareos to read a volume on a physical device. It is a way to tell Bareos that you have mounted a tape and that Bareos should examine the tape. This command is normally used only after there was no Volume in a drive and Bareos requests you to mount a new Volume or when you have speciﬁcally unmounted a Volume with the unmount console command, which causes Bareos to close the drive. If you have an autoloader, the mount command will not cause Bareos to operate the autoloader unless you specify a slot and possibly a drive. The various forms of the mount command are:


    mount  storage=<storage−name> [slot=<num>] [
           drive=<num> ]
    mount [jobid=<id> | job=<job−name>]


    bconsole 15.26: mount
    
    If you have speciﬁed Automatic Mount = yes in the Storage daemon’s Device resource, under most circumstances, Bareos will automatically access the Volume unless you have explicitly unmount ed it in the Console program.
move
    The move command allows to move volumes between slots in an autochanger without having to leave the bconsole.

    To move a volume from slot 32 to slots 33, use:


    *move storage=TandbergT40 srcslots=32 dstslots=33
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”slots” command.
    Device ”Drive−1” has 39 slots.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger ”listall” command.
    Connecting to Storage daemon TandbergT40 at bareos:9103 ...
    3306 Issuing autochanger transfer command.
    3308 Successfully transfered volume from slot 32 to 33.


    bconsole 15.27: move
prune
    The Prune command allows you to safely remove expired database records from Jobs, Volumes and Statistics. This command works only on the Catalog database and does not aﬀect data written to Volumes. In all cases, the Prune command applies a retention period to the speciﬁed records. You can Prune expired File entries from Job records; you can Prune expired Job records from the database, and you can Prune both expired Job and File records from speciﬁed Volumes.


    prune files|jobs|volume|stats client=<client−name> volume=<volume−name>


    bconsole 15.28: prune
    
    For a Volume to be pruned, the VolStatus must be Full, Used, or Append, otherwise the pruning will not take place.
purge
    The Purge command will delete associated Catalog database records from Jobs and Volumes without considering the retention period. Purge works only on the Catalog database and does not aﬀect data written to Volumes. This command can be dangerous because you can delete catalog records associated with current backups of ﬁles, and we recommend that you do not use it unless you know what you are doing. The permitted forms of purge are:


    purge files jobid=<jobid>|job=<job−name> | client=<client−name>
    purge jobs client=<client−name> (of all jobs)
    purge volume|volume=<vol−name> (of all jobs)


    bconsole 15.29: purge
    
    For the purge command to work on Volume Catalog database records the VolStatus must be Append, Full, Used, or Error.
    
    The actual data written to the Volume will be unaﬀected by this command unless you are using the ActionOnPurge=Truncate option on those Media.
    
    To ask Bareos to truncate your Purged volumes, you need to use the following command in interactive mode or in a RunScript:


    *purge volume action=truncate storage=File allpools
    # or by default, action=all
    *purge volume action storage=File pool=Default


    bconsole 15.30: purge example
    
    It is possible to specify the volume name, the media type, the pool, the storage, etc…(see help purge). Be sure that your storage device is idle when you decide to run this command.
resolve
    In the conﬁguration ﬁles, Addresses can (and normally should) be speciﬁed as DNS names. As the diﬀerent components of Bareos will establish network connections to other Bareos components, it is important that DNS name resolution works on involved components and delivers the same results. The resolve command can be used to test DNS resolution of a given hostname on director, storage daemonm or client.


    *resolve www.bareos.com
    bareos−dir resolves www.bareos.com to host[ipv4:84.44.166.242]
    
    *resolve client=client1−fd www.bareos.com
    client1−fd resolves www.bareos.com to host[ipv4:84.44.166.242]
    
    *resolve storage=File www.bareos.com
    bareos−sd resolves www.bareos.com to host[ipv4:84.44.166.242]


    bconsole 15.31: resolve example
query
    This command reads a predeﬁned SQL query from the query ﬁle (the name and location of the query ﬁle is deﬁned with the QueryFile resource record in the Director’s conﬁguration ﬁle). You are prompted to select a query from the ﬁle, and possibly enter one or more parameters, then the command is submitted to the Catalog database SQL engine.
quit
    This command terminates the console program. The console program sends the quit request to the Director and waits for acknowledgment. If the Director is busy doing a previous command for you that has not terminated, it may take some time. You may quit immediately by issuing the .quit command (i.e. quit preceded by a period).
relabel
    This command is used to label physical volumes.

    The full form of this command is:


    relabel storage=<storage−name> oldvolume=<old−volume−name> volume=<newvolume−name>}


    bconsole 15.32: relabel
    
    If you leave out any part, you will be prompted for it. In order for the Volume (old-volume-name) to be relabeled, it must be in the catalog, and the volume status must be marked Purged or Recycle. This happens automatically as a result of applying retention periods, or you may explicitly purge the volume using the purge command.
    
    Once the volume is physically relabeled, the old data previously written on the Volume is lost and cannot be recovered.
release
    This command is used to cause the Storage daemon to release (and rewind) the current tape in the drive, and to re-read the Volume label the next time the tape is used.


    release storage=<storage−name>


    bconsole 15.33: release
    
    After a release command, the device is still kept open by Bareos (unless Always Open Sd Device=No) so it cannot be used by another program. However, with some tape drives, the operator can remove the current tape and to insert a diﬀerent one, and when the next Job starts, Bareos will know to re-read the tape label to ﬁnd out what tape is mounted. If you want to be able to use the drive with another program (e.g. mt), you must use the unmount command to cause Bareos to completely release (close) the device.
reload
    The reload command causes the Director to re-read its conﬁguration ﬁle and apply the new values. The new values will take eﬀect immediately for all new jobs. However, if you change schedules, be aware that the scheduler pre-schedules jobs up to two hours in advance, so any changes that are to take place during the next two hours may be delayed. Jobs that have already been scheduled to run (i.e. surpassed their requested start time) will continue with the old values. New jobs will use the new values. Each time you issue a reload command while jobs are running, the prior conﬁg values will queued until all jobs that were running before issuing the reload terminate, at which time the old conﬁg values will be released from memory. The Directory permits keeping up to ten prior set of conﬁgurations before it will refuse a reload command. Once at least one old set of conﬁg values has been released it will again accept new reload commands.

    While it is possible to reload the Director’s conﬁguration on the ﬂy, even while jobs are executing, this is a complex operation and not without side eﬀects. Accordingly, if you have to reload the Director’s conﬁguration while Bareos is running, it is advisable to restart the Director at the next convenient opportunity.
rerun
    The rerun command allows you to re-run a Job with exactly the same setting as the original Job. In Bareos, the job conﬁguration is often altered by job overrides. These overrides alter the conﬁguration of the job just for one job run. If because of any reason, a job with overrides fails, it is not easy to restart a new job that is exactly conﬁgured as the job that failed. The whole job conﬁguration is automatically set to the defaults and it is hard to conﬁgure everything like it was.

    By using the rerun command, it is much easier to rerun a job exactly as it was conﬁgured. You only have to specify the JobId of the failed job.


    rerun jobid=<jobid> since_jobid=<jobid> days=<nr_days> hours=<nr_hours> yes


    bconsole 15.34: rerun
    
    You can select the jobid(s) to rerun by using one of the selection criteria. Using jobid= will automatically select all jobs failed after and including the given jobid for rerunning. By using days= or hours=, you can select all failed jobids in the last number of days or number of hours respectively for rerunning.
restore
    The restore command allows you to select one or more Jobs (JobIds) to be restored using various methods. Once the JobIds are selected, the File records for those Jobs are placed in an internal Bareos directory tree, and the restore enters a ﬁle selection mode that allows you to interactively walk up and down the ﬁle tree selecting individual ﬁles to be restored. This mode is somewhat similar to the standard Unix restore program’s interactive ﬁle selection mode.


    restore storage=<storage−name> client=<backup−client−name>
      where=<path> pool=<pool−name> fileset=<fileset−name>
      restoreclient=<restore−client−name>
      restorejob=<job−name>
      select current all done


    bconsole 15.35: restore
    
    Where current, if speciﬁed, tells the restore command to automatically select a restore to the most current backup. If not speciﬁed, you will be prompted. The all speciﬁcation tells the restore command to restore all ﬁles. If it is not speciﬁed, you will be prompted for the ﬁles to restore. For details of the restore command, please see the Restore Chapter of this manual.
    
    The client keyword initially speciﬁes the client from which the backup was made and the client to which the restore will be make. However, if the restoreclient keyword is speciﬁed, then the restore is written to that client.
    
    The restore job rarely needs to be speciﬁed, as bareos installations commonly only have a single restore job conﬁgured. However, for certain cases, such as a varying list of RunScript speciﬁcations, multiple restore jobs may be conﬁgured. The restorejob argument allows the selection of one of these jobs.
    
    For more details, see the Restore chapter.
run
    This command allows you to schedule jobs to be run immediately.

    The full form of the command is:


    run job=<job−name> client=<client−name>
      fileset=<FileSet−name>  level=<level−keyword>
      storage=<storage−name>  where=<directory−prefix>
      when=<universal−time−specification> spooldata=yes|no yes


    bconsole 15.36: run
    
    Any information that is needed but not speciﬁed will be listed for selection, and before starting the job, you will be prompted to accept, reject, or modify the parameters of the job to be run, unless you have speciﬁed yes, in which case the job will be immediately sent to the scheduler.
    
    If you wish to start a job at a later time, you can do so by setting the When time. Use the mod option and select When (no. 6). Then enter the desired start time in YYYY-MM-DD HH:MM:SS format.
    
    The spooldata argument of the run command cannot be modiﬁed through the menu and is only accessible by setting its value on the intial command line. If no spooldata ﬂag is set, the job, storage or schedule ﬂag is used.
setbandwidth
    This command (Version >= 12.4.1) is used to limit the bandwidth of a running job or a client.


    setbandwidth limit=<nb> [jobid=<id> | client=<cli>]


    bconsole 15.37: setbandwidth
setdebug
    This command is used to set the debug level in each daemon. The form of this command is:


    setdebug level=nnn [trace=0/1 client=<client−name> | dir | director | storage=<storage−name> | all]


    bconsole 15.38: setdebug
    
    Each of the daemons normally has debug compiled into the program, but disabled. There are two ways to enable the debug output.
    
    One is to add the -d nnn option on the command line when starting the daemon. The nnn is the debug level, and generally anything between 50 and 200 is reasonable. The higher the number, the more output is produced. The output is written to standard output.
    
    The second way of getting debug output is to dynamically turn it on using the Console using the setdebug level=nnn command. If none of the options are given, the command will prompt you. You can selectively turn on/oﬀ debugging in any or all the daemons (i.e. it is not necessary to specify all the components of the above command).
    
    If trace=1 is set, then tracing will be enabled, and the daemon will be placed in trace mode, which means that all debug output as set by the debug level will be directed to his trace ﬁle in the current directory of the daemon. When tracing, each debug output message is appended to the trace ﬁle. You must explicitly delete the ﬁle when you are done.


    *setdebug level=100 trace=1 dir
    level=100 trace=1 hangup=0 timestamp=0 tracefilename=/var/lib/bareos/bareos−dir.example.com.trace


    bconsole 15.39: set Director debug level to 100 and get messages written to his trace ﬁle
setip
    Sets new client address – if authorized.

    A console is authorized to use the SetIP command only if it has a Console resource deﬁnition in both the Director and the Console. In addition, if the console name, provided on the Name = directive, must be the same as a Client name, the user of that console is permitted to use the SetIP command to change the Address directive in the Director’s client resource to the IP address of the Console. This permits portables or other machines using DHCP (non-ﬁxed IP addresses) to ”notify” the Director of their current IP address.
show
    The show command will list the Director’s resource records as deﬁned in the Director’s conﬁguration ﬁle (normally bareos-dir.conf). This command is used mainly for debugging purposes by developers. The following keywords are accepted on the show command line: catalogs, clients, counters, devices, directors, ﬁlesets, jobs, messages, pools, schedules, storages, all, help. Please don’t confuse this command with the list, which displays the contents of the catalog.
sqlquery
    The sqlquery command puts the Console program into SQL query mode where each line you enter is concatenated to the previous line until a semicolon (;) is seen. The semicolon terminates the command, which is then passed directly to the SQL database engine. When the output from the SQL engine is displayed, the formation of a new SQL command begins. To terminate SQL query mode and return to the Console command prompt, you enter a period (.) in column 1.

    Using this command, you can query the SQL catalog database directly. Note you should really know what you are doing otherwise you could damage the catalog database. See the query command below for simpler and safer way of entering SQL queries.
    
    Depending on what database engine you are using (MySQL, PostgreSQL or SQLite), you will have somewhat diﬀerent SQL commands available. For more detailed information, please refer to the MySQL, PostgreSQL or SQLite documentation.
status

    This command will display the status of all components. For the director, it will display the next jobs that are scheduled during the next 24 hours as well as the status of currently running jobs. For the Storage Daemon, you will have drive status or autochanger content. The File Daemon will give you information about current jobs like average speed or ﬁle accounting. The full form of this command is:


    status [all | dir=<dir−name> | director | scheduler | schedule=<schedule−name> |
            client=<client−name> | storage=<storage−name> slots | subscriptions]


    bconsole 15.40: status
    
    If you do a status dir, the console will list any currently running jobs, a summary of all jobs scheduled to be run in the next 24 hours, and a listing of the last ten terminated jobs with their statuses. The scheduled jobs summary will include the Volume name to be used. You should be aware of two things: 1. to obtain the volume name, the code goes through the same code that will be used when the job runs, but it does not do pruning nor recycling of Volumes; 2. The Volume listed is at best a guess. The Volume actually used may be diﬀerent because of the time diﬀerence (more durations may expire when the job runs) and another job could completely ﬁll the Volume requiring a new one.
    
    In the Running Jobs listing, you may ﬁnd the following types of information:


    2507 Catalog MatouVerify.2004−03−13_05.05.02 is waiting execution
    5349 Full    CatalogBackup.2004−03−13_01.10.00 is waiting for higher
                 priority jobs to finish
    5348 Differe Minou.2004−03−13_01.05.09 is waiting on max Storage jobs
    5343 Full    Rufus.2004−03−13_01.05.04 is running


    Looking at the above listing from bottom to top, obviously JobId 5343 (Rufus) is running. JobId 5348 (Minou) is waiting for JobId 5343 to ﬁnish because it is using the Storage resource, hence the ”waiting on max Storage jobs”. JobId 5349 has a lower priority than all the other jobs so it is waiting for higher priority jobs to ﬁnish, and ﬁnally, JobId 2507 (MatouVerify) is waiting because only one job can run at a time, hence it is simply ”waiting execution”
    
    If you do a status dir, it will by default list the ﬁrst occurrence of all jobs that are scheduled today and tomorrow. If you wish to see the jobs that are scheduled in the next three days (e.g. on Friday you want to see the ﬁrst occurrence of what tapes are scheduled to be used on Friday, the weekend, and Monday), you can add the days=3 option. Note, a days=0 shows the ﬁrst occurrence of jobs scheduled today only. If you have multiple run statements, the ﬁrst occurrence of each run statement for the job will be displayed for the period speciﬁed.
    
    If your job seems to be blocked, you can get a general idea of the problem by doing a status dir, but you can most often get a much more speciﬁc indication of the problem by doing a status storage=xxx. For example, on an idle test system, when I do status storage=File, I get:


    *status storage=File
    Connecting to Storage daemon File at 192.168.68.112:8103
    
    rufus−sd Version: 1.39.6 (24 March 2006) i686−pc−linux−gnu redhat (Stentz)
    Daemon started 26−Mar−06 11:06, 0 Jobs run since started.
    
    Running Jobs:
    No Jobs running.
    ====
    
    Jobs waiting to reserve a drive:
    ====
    
    Terminated Jobs:
     JobId  Level   Files          Bytes Status   Finished        Name
    ======================================================================
        59  Full        234      4,417,599 OK       15−Jan−06 11:54 usersave
    ====
    
    Device status:
    Autochanger ”DDS−4−changer” with devices:
       ”DDS−4” (/dev/nst0)
    Device ”DDS−4” (/dev/nst0) is mounted with Volume=”TestVolume002”
    Pool=”*unknown*”
        Slot 2 is loaded in drive 0.
        Total Bytes Read=0 Blocks Read=0 Bytes/block=0
        Positioned at File=0 Block=0
    
    Device ”File” (/tmp) is not open.
    ====
    
    In Use Volume status:
    ====


    bconsole 15.41: status storage
    
    Now, what this tells me is that no jobs are running and that none of the devices are in use. Now, if I unmount the autochanger, which will not be used in this example, and then start a Job that uses the File device, the job will block. When I re-issue the status storage command, I get for the Device status:


    *status storage=File
    ...
    Device status:
    Autochanger ”DDS−4−changer” with devices:
       ”DDS−4” (/dev/nst0)
    Device ”DDS−4” (/dev/nst0) is not open.
        Device is BLOCKED. User unmounted.
        Drive 0 is not loaded.
    
    Device ”File” (/tmp) is not open.
        Device is BLOCKED waiting for media.
    ====
    ...


    bconsole 15.42: status storage
    
    Now, here it should be clear that if a job were running that wanted to use the Autochanger (with two devices), it would block because the user unmounted the device. The real problem for the Job I started using the ”File” device is that the device is blocked waiting for media – that is Bareos needs you to label a Volume.
    
    The command status scheduler (Version >= 12.4.4) can be used to check when a certain schedule will trigger. This gives more information than status director .
    
    Called without parameters, status scheduler shows a preview for all schedules for the next 14 days. It ﬁrst shows a list of the known schedules and the jobs that will be triggered by these jobs, and next, a table with date (including weekday), schedule name and applied overrides is displayed:


    *status scheduler
    Scheduler Jobs:
    
    Schedule               Jobs Triggered
    ===========================================================
    WeeklyCycle
                           BackupClient1
    
    WeeklyCycleAfterBackup
                           BackupCatalog
    
    ====
    
    Scheduler Preview for 14 days:
    
    Date                  Schedule                Overrides
    ==============================================================
    Di 04−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Di 04−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Mi 05−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Mi 05−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Do 06−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Do 06−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Fr 07−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Fr 07−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Sa 08−Jun−2013 21:00  WeeklyCycle             Level=Differential
    Mo 10−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Mo 10−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Di 11−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Di 11−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Mi 12−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Mi 12−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Do 13−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Do 13−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Fr 14−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Fr 14−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Sa 15−Jun−2013 21:00  WeeklyCycle             Level=Differential
    Mo 17−Jun−2013 21:00  WeeklyCycle             Level=Incremental
    Mo 17−Jun−2013 21:10  WeeklyCycleAfterBackup  Level=Full
    ====


    bconsole 15.43: status scheduler
    
    status scheduler accepts the following parameters:
    
    client=clientname
        shows only the schedules that aﬀect the given client.
    job=jobname
        shows only the schedules that aﬀect the given job.
    schedule=schedulename
        shows only the given schedule.
    days=number
        of days shows only the number of days in the scheduler preview. Positive numbers show the future, negative numbers show the past. days can be combined with the other selection criteria. days= can be combined with the other selection criteria.
    
    In case you are running a maintained version of Bareos, the command status subscriptions (Version >= 12.4.4) can help you to keep the overview over the subscriptions that are used.
    
    To enable this functionality, just add the conﬁguration directive subscriptions to the director conﬁguration in the director resource:
    
    The number of subscribed clients can be set in the director resource, for example:


    Director {
       ...
       Subscriptions = 50
    }


    Conﬁguration 15.44: enable subscription check
    
    Using the console command status subscriptions , the status of the subscriptions can be checked any time interactively:


    *status subscriptions
    Ok: available subscriptions: 8 (42/50) (used/total)


    bconsole 15.45: status subscriptions
    
    Also, the number of subscriptions is checked after every job. If the number of clients is bigger than the conﬁgured limit, a Job warning is created a message like this:


    JobId 7: Warning: Subscriptions exceeded: (used/total) (51/50)


    bconsole 15.46: subscriptions warning
    
    Please note: Nothing else than the warning is issued, no enforcement on backup, restore or any other operation will happen.
    
    Setting the value for Subscriptions to 0 disables this functionality:


    Director {
       ...
       Subscriptions = 0
    }


    Conﬁguration 15.47: disable subscription check
    
    Not conﬁguring the directive at all also disables it, as the default value for the Subscriptions directive is zero.
time
    The time command shows the current date, time and weekday.
trace
    Turn on/oﬀ trace to ﬁle.
umount
    Alias for unmount .
unmount
    This command causes the indicated Bareos Storage daemon to unmount the speciﬁed device. The forms of the command are the same as the mount command:


    unmount storage=<storage−name> [drive=<num>]
    unmount [jobid=<id> | job=<job−name>]


    bconsole 15.48: unmount
    
    Once you unmount a storage device, Bareos will no longer be able to use it until you issue a mount command for that device. If Bareos needs to access that device, it will block and issue mount requests periodically to the operator.
    
    If the device you are unmounting is an autochanger, it will unload the drive you have speciﬁed on the command line. If no drive is speciﬁed, it will assume drive 1.
    
    In most cases, it is preferable to use the release instead.
update
    This command will update the catalog for either a speciﬁc Pool record, a Volume record, or the Slots in an autochanger with barcode capability. In the case of updating a Pool record, the new information will be automatically taken from the corresponding Director’s conﬁguration resource record. It can be used to increase the maximum number of volumes permitted or to set a maximum number of volumes. The following main keywords may be speciﬁed:
       media, volume, pool, slots, stats

    In the case of updating a Volume, you will be prompted for which value you wish to change. The following Volume parameters may be changed:
       Volume Status  
       Volume Retention Period  
       Volume Use Duration  
       Maximum Volume Jobs  
       Maximum Volume Files  
       Maximum Volume Bytes  
       Recycle Flag  
       Recycle Pool  
       Slot  
       InChanger Flag  
       Pool  
       Volume Files  
       Volume from Pool  
       All Volumes from Pool  
       All Volumes from all Pools
    
    For slots update slots, Bareos will obtain a list of slots and their barcodes from the Storage daemon, and for each barcode found, it will automatically update the slot in the catalog Media record to correspond to the new value. This is very useful if you have moved cassettes in the magazine, or if you have removed the magazine and inserted a diﬀerent one. As the slot of each Volume is updated, the InChanger ﬂag for that Volume will also be set, and any other Volumes in the Pool that were last mounted on the same Storage device will have their InChanger ﬂag turned oﬀ. This permits Bareos to know what magazine (tape holder) is currently in the autochanger.
    
    If you do not have barcodes, you can accomplish the same thing by using the update slots scan command. The scan keyword tells Bareos to physically mount each tape and to read its VolumeName.
    
    For Pool update pool, Bareos will move the Volume record from its existing pool to the pool speciﬁed.
    
    For Volume from Pool, All Volumes from Pool and All Volumes from all Pools, the following values are updated from the Pool record: Recycle, RecyclePool, VolRetention, VolUseDuration, MaxVolJobs, MaxVolFiles, and MaxVolBytes.
    
    The full form of the update command with all command line arguments is:


    update volume=<volume−name> pool=<poolname>
      slots volstatus=<volume−status> VolRetention=<volume−retention>
      VolUse=<volume−use−period> MaxVolJobs=nnn MaxVolBytes=nnn Recycle=yes|no
      slot=nnn enabled=n recyclepool=<pool−name>


    bconsole 15.49: update
use
    This command allows you to specify which Catalog database to use. Normally, you will be using only one database so this will be done automatically. In the case that you are using more than one database, you can use this command to switch from one to another.


    use [catalog=<catalog>]


    bconsole 15.50: use
var
    This command takes a string or quoted string and does variable expansion on it mostly the same way variable expansion is done on the Label Format Dir Pool string. The diﬀerence between the var command and the actual Label Format Dir Pool process is that during the var command, no job is running so dummy values are used in place of Job speciﬁc variables.
version
    The command prints the Director’s version.
wait
    The wait command causes the Director to pause until there are no jobs running. This command is useful in a batch situation such as regression testing where you wish to start a job and wait until that job completes before continuing. This command now has the following options:


    wait [jobid=<jobid>] [jobuid=<unique id>] [job=<job name>]


    bconsole 15.51: wait
    
    If speciﬁed with a speciﬁc JobId, ... the wait command will wait for that particular job to terminate before continuing.

#
15.4.1 Special dot (.) Commands

There is a list of commands that are preﬁxed with a period (.). These commands are intended to be used either by batch programs or graphical user interface front-ends. They are not normally used by interactive users. For details, see Bareos Developer Guide (dot-commands) .

#
15.4.2 Special At (@) Commands

Normally, all commands entered to the Console program are immediately forwarded to the Director, which may be on another machine, to be executed. However, there is a small list of at commands, all beginning with an at character (@), that will not be sent to the Director, but rather interpreted by the Console program directly. Note, these commands are implemented only in the TTY console program and not in the Bat Console. These commands are:

@input <ﬁlename>
    Read and execute the commands contained in the ﬁle speciﬁed.
@output <ﬁlename> <w|a>
    Send all following output to the ﬁlename speciﬁed either overwriting the ﬁle (w) or appending to the ﬁle (a). To redirect the output to the terminal, simply enter @output without a ﬁlename speciﬁcation. WARNING: be careful not to overwrite a valid ﬁle. A typical example during a regression test might be:
        @output /dev/null  
        commands ...  
        @output

@tee <ﬁlename> <w|a>
    Send all subsequent output to both the speciﬁed ﬁle and the terminal. It is turned oﬀ by specifying @tee or @output without a ﬁlename.
@sleep <seconds>
    Sleep the speciﬁed number of seconds.
@time
    Print the current time and date.
@version
    Print the console’s version.
@quit
    quit
@exit
    quit
@# anything
    Comment
@help
    Get the list of every special @ commands.
@separator <char>
    When using bconsole with readline, you can set the command separator to one of those characters to write commands who require multiple input on one line, or to put multiple commands on a single line.
      !$%&’()*+,-/:;<>?[]^‘{|}~

    Note, if you use a semicolon (;) as a separator character, which is common, you will not be able to use the sql command, which requires each command to be terminated by a semicolon.

#
15.5 Adding Volumes to a Pool

TODO: move to another chapter

If you have used the label command to label a Volume, it will be automatically added to the Pool, and you will not need to add any media to the pool.

Alternatively, you may choose to add a number of Volumes to the pool without labeling them. At a later time when the Volume is requested by Bareos you will need to label it.

Before adding a volume, you must know the following information:

    The name of the Pool (normally ”Default”)
    The Media Type as speciﬁed in the Storage Resource in the Director’s conﬁguration ﬁle (e.g. ”DLT8000”)
    The number and names of the Volumes you wish to create.

For example, to add media to a Pool, you would issue the following commands to the console program:
*add  
Enter name of Pool to add Volumes to: Default  
Enter the Media Type: DLT8000  
Enter number of Media volumes to create. Max=1000: 10  
Enter base volume name: Save  
Enter the starting number: 1  
10 Volumes created in pool Default  
*

To see what you have added, enter:
*list media pool=Default  
+-------+----------+---------+---------+-------+------------------+  
| MedId | VolumeNa | MediaTyp| VolStat | Bytes | LastWritten      |  
+-------+----------+---------+---------+-------+------------------+  
|    11 | Save0001 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    12 | Save0002 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    13 | Save0003 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    14 | Save0004 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    15 | Save0005 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    16 | Save0006 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    17 | Save0007 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    18 | Save0008 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    19 | Save0009 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
|    20 | Save0010 | DLT8000 | Append  |     0 | 0000-00-00 00:00 |  
+-------+----------+---------+---------+-------+------------------+  
*

Notice that the console program automatically appended a number to the base Volume name that you specify (Save in this case). If you don’t want it to append a number, you can simply answer 0 (zero) to the question ”Enter number of Media volumes to create. Max=1000:”, and in this case, it will create a single Volume with the exact name you specify.

#
Chapter 16
The Restore Command
#
16.1 General

Below, we will discuss restoring ﬁles with the Console restore command, which is the recommended way of doing restoring ﬁles. It is not possible to restore ﬁles by automatically starting a job as you do with Backup, Verify, ... jobs. However, in addition to the console restore command, there is a standalone program named bextract, which also permits restoring ﬁles. For more information on this program, please see the Bareos Utility Programs chapter of this manual. We don’t particularly recommend the bextract program because it lacks many of the features of the normal Bareos restore, such as the ability to restore Win32 ﬁles to Unix systems, and the ability to restore access control lists (ACL). As a consequence, we recommend, wherever possible to use Bareos itself for restores as described below.

You may also want to look at the bls program in the same chapter, which allows you to list the contents of your Volumes. Finally, if you have an old Volume that is no longer in the catalog, you can restore the catalog entries using the program named bscan, documented in the same Bareos Utility Programs chapter.

In general, to restore a ﬁle or a set of ﬁles, you must run a restore job. That is a job with Type = Restore. As a consequence, you will need a predeﬁned restore job in your bareos-dir.conf (Director’s conﬁg) ﬁle. The exact parameters (Client, FileSet, ...) that you deﬁne are not important as you can either modify them manually before running the job or if you use the restore command, explained below, Bareos will automatically set them for you. In fact, you can no longer simply run a restore job. You must use the restore command.

Since Bareos is a network backup program, you must be aware that when you restore ﬁles, it is up to you to ensure that you or Bareos have selected the correct Client and the correct hard disk location for restoring those ﬁles. Bareos will quite willingly backup client A, and restore it by sending the ﬁles to a diﬀerent directory on client B. Normally, you will want to avoid this, but assuming the operating systems are not too diﬀerent in their ﬁle structures, this should work perfectly well, if so desired. By default, Bareos will restore data to the same Client that was backed up, and those data will be restored not to the original places but to /tmp/bareos-restores. This is conﬁgured in the default restore command resource in bareos-dir.conf. You may modify any of these defaults when the restore command prompts you to run the job by selecting the mod option.

#
16.2 The Restore Command

Since Bareos maintains a catalog of your ﬁles and on which Volumes (disk or tape), they are stored, it can do most of the bookkeeping work, allowing you simply to specify what kind of restore you want (current, before a particular date), and what ﬁles to restore. Bareos will then do the rest.

This is accomplished using the restore command in the Console. First you select the kind of restore you want, then the JobIds are selected, the File records for those Jobs are placed in an internal Bareos directory tree, and the restore enters a ﬁle selection mode that allows you to interactively walk up and down the ﬁle tree selecting individual ﬁles to be restored. This mode is somewhat similar to the standard Unix restore program’s interactive ﬁle selection mode.

If a Job’s ﬁle records have been pruned from the catalog, the restore command will be unable to ﬁnd any ﬁles to restore. Bareos will ask if you want to restore all of them or if you want to use a regular expression to restore only a selection while reading media. See FileRegex option and below for more details on this.

Within the Console program, after entering the restore command, you are presented with the following selection prompt:


* restore
First you select one or more JobIds that contain files
to be restored. You will be presented several methods
of specifying the JobIds. Then you will be allowed to
select which files from those JobIds are to be restored.

To select the JobIds, you have the following choices:
     1: List last 20 Jobs run
     2: List Jobs where a given File is saved
     3: Enter list of comma separated JobIds to select
     4: Enter SQL list command
     5: Select the most recent backup for a client
     6: Select backup for a client before a specified time
     7: Enter a list of files to restore
     8: Enter a list of files to restore before a specified time
     9: Find the JobIds of the most recent backup for a client
    10: Find the JobIds for a backup for a client before a specified time
    11: Enter a list of directories to restore for found JobIds
    12: Select full restore to a specified Job date
    13: Cancel
Select item:  (1−13):


bconsole 16.1: restore

There are a lot of options, and as a point of reference, most people will want to select item 5 (the most recent backup for a client). The details of the above options are:

    Item 1 will list the last 20 jobs run. If you ﬁnd the Job you want, you can then select item 3 and enter its JobId(s).
    Item 2 will list all the Jobs where a speciﬁed ﬁle is saved. If you ﬁnd the Job you want, you can then select item 3 and enter the JobId.
    Item 3 allows you the enter a list of comma separated JobIds whose ﬁles will be put into the directory tree. You may then select which ﬁles from those JobIds to restore. Normally, you would use this option if you have a particular version of a ﬁle that you want to restore and you know its JobId. The most common options (5 and 6) will not select a job that did not terminate normally, so if you know a ﬁle is backed up by a Job that failed (possibly because of a system crash), you can access it through this option by specifying the JobId.
    Item 4 allows you to enter any arbitrary SQL command. This is probably the most primitive way of ﬁnding the desired JobIds, but at the same time, the most ﬂexible. Once you have found the JobId(s), you can select item 3 and enter them.
    Item 5 will automatically select the most recent Full backup and all subsequent incremental and diﬀerential backups for a speciﬁed Client. These are the Jobs and Files which, if reloaded, will restore your system to the most current saved state. It automatically enters the JobIds found into the directory tree in an optimal way such that only the most recent copy of any particular ﬁle found in the set of Jobs will be restored. This is probably the most convenient of all the above options to use if you wish to restore a selected Client to its most recent state.
    
    There are two important things to note. First, this automatic selection will never select a job that failed (terminated with an error status). If you have such a job and want to recover one or more ﬁles from it, you will need to explicitly enter the JobId in item 3, then choose the ﬁles to restore.
    
    If some of the Jobs that are needed to do the restore have had their File records pruned, the restore will be incomplete. Bareos currently does not correctly detect this condition. You can however, check for this by looking carefully at the list of Jobs that Bareos selects and prints. If you ﬁnd Jobs with the JobFiles column set to zero, when ﬁles should have been backed up, then you should expect problems.
    
    If all the File records have been pruned, Bareos will realize that there are no ﬁle records in any of the JobIds chosen and will inform you. It will then propose doing a full restore (non-selective) of those JobIds. This is possible because Bareos still knows where the beginning of the Job data is on the Volumes, even if it does not know where particular ﬁles are located or what their names are.
    Item 6 allows you to specify a date and time, after which Bareos will automatically select the most recent Full backup and all subsequent incremental and diﬀerential backups that started before the speciﬁed date and time.
    Item 7 allows you to specify one or more ﬁlenames (complete path required) to be restored. Each ﬁlename is entered one at a time or if you preﬁx a ﬁlename with the less-than symbol (<) Bareos will read that ﬁle and assume it is a list of ﬁlenames to be restored. If you preﬁx the ﬁlename with a question mark (?), then the ﬁlename will be interpreted as an SQL table name, and Bareos will include the rows of that table in the list to be restored. The table must contain the JobId in the ﬁrst column and the FileIndex in the second column. This table feature is intended for external programs that want to build their own list of ﬁles to be restored. The ﬁlename entry mode is terminated by entering a blank line.
    Item 8 allows you to specify a date and time before entering the ﬁlenames. See Item 7 above for more details.
    Item 9 allows you ﬁnd the JobIds of the most recent backup for a client. This is much like option 5 (it uses the same code), but those JobIds are retained internally as if you had entered them manually. You may then select item 11 (see below) to restore one or more directories.
    Item 10 is the same as item 9, except that it allows you to enter a before date (as with item 6). These JobIds will then be retained internally.
    Item 11 allows you to enter a list of JobIds from which you can select directories to be restored. The list of JobIds can have been previously created by using either item 9 or 10 on the menu. You may then enter a full path to a directory name or a ﬁlename preceded by a less than sign (<). The ﬁlename should contain a list of directories to be restored. All ﬁles in those directories will be restored, but if the directory contains subdirectories, nothing will be restored in the subdirectory unless you explicitly enter its name.
    Item 12 is a full restore to a speciﬁed job date.
    Item 13 allows you to cancel the restore command.

As an example, suppose that we select item 5 (restore to most recent state). If you have not speciﬁed a client=xxx on the command line, it it will then ask for the desired Client, which on my system, will print all the Clients found in the database as follows:


Select item:  (1−13): 5
Defined clients:
     1: Rufus
     2: Matou
     3: Polymatou
     4: Minimatou
     5: Minou
     6: MatouVerify
     7: PmatouVerify
     8: RufusVerify
     9: Watchdog
Select Client (File daemon) resource (1−9): 1


bconsole 16.2: restore: select client

The listed clients are only examples, yours will look diﬀerently. If you have only one Client, it will be automatically selected. In this example, I enter 1 for Rufus to select the Client. Then Bareos needs to know what FileSet is to be restored, so it prompts with:
The defined FileSet resources are:  
     1: Full Set  
     2: Other Files  
Select FileSet resource (1-2):

If you have only one FileSet deﬁned for the Client, it will be selected automatically. I choose item 1, which is my full backup. Normally, you will only have a single FileSet for each Job, and if your machines are similar (all Linux) you may only have one FileSet for all your Clients.

At this point, Bareos has all the information it needs to ﬁnd the most recent set of backups. It will then query the database, which may take a bit of time, and it will come up with something like the following. Note, some of the columns are truncated here for presentation:
+-------+------+----------+-------------+-------------+------+-------+------------+  
| JobId | Levl | JobFiles | StartTime   | VolumeName  | File | SesId |VolSesTime  |  
+-------+------+----------+-------------+-------------+------+-------+------------+  
| 1,792 | F    |  128,374 | 08-03 01:58 | DLT-19Jul02 |   67 |    18 | 1028042998 |  
| 1,792 | F    |  128,374 | 08-03 01:58 | DLT-04Aug02 |    0 |    18 | 1028042998 |  
| 1,797 | I    |      254 | 08-04 13:53 | DLT-04Aug02 |    5 |    23 | 1028042998 |  
| 1,798 | I    |       15 | 08-05 01:05 | DLT-04Aug02 |    6 |    24 | 1028042998 |  
+-------+------+----------+-------------+-------------+------+-------+------------+  
You have selected the following JobId: 1792,1792,1797  
Building directory tree for JobId 1792 ...  
Building directory tree for JobId 1797 ...  
Building directory tree for JobId 1798 ...  
cwd is: /  
$

Depending on the number of JobFiles for each JobId, the “Building directory tree ...” can take a bit of time. If you notice ath all the JobFiles are zero, your Files have probably been pruned and you will not be able to select any individual ﬁles – it will be restore everything or nothing.

In our example, Bareos found four Jobs that comprise the most recent backup of the speciﬁed Client and FileSet. Two of the Jobs have the same JobId because that Job wrote on two diﬀerent Volumes. The third Job was an incremental backup to the previous Full backup, and it only saved 254 Files compared to 128,374 for the Full backup. The fourth Job was also an incremental backup that saved 15 ﬁles.

Next Bareos entered those Jobs into the directory tree, with no ﬁles marked to be restored as a default, tells you how many ﬁles are in the tree, and tells you that the current working directory (cwd) is /. Finally, Bareos prompts with the dollar sign ($) to indicate that you may enter commands to move around the directory tree and to select ﬁles.

If you want all the ﬁles to automatically be marked when the directory tree is built, you could have entered the command restore all, or at the $ prompt, you can simply enter mark *.

Instead of choosing item 5 on the ﬁrst menu (Select the most recent backup for a client), if we had chosen item 3 (Enter list of JobIds to select) and we had entered the JobIds 1792,1797,1798 we would have arrived at the same point.

One point to note, if you are manually entering JobIds, is that you must enter them in the order they were run (generally in increasing JobId order). If you enter them out of order and the same ﬁle was saved in two or more of the Jobs, you may end up with an old version of that ﬁle (i.e. not the most recent).

Directly entering the JobIds can also permit you to recover data from a Job that wrote ﬁles to tape but that terminated with an error status.

While in ﬁle selection mode, you can enter help or a question mark (?) to produce a summary of the available commands:
 Command    Description  
  =======    ===========  
  cd         change current directory  
  count      count marked files in and below the cd  
  dir        long list current directory, wildcards allowed  
  done       leave file selection mode  
  estimate   estimate restore size  
  exit       same as done command  
  find       find files, wildcards allowed  
  help       print help  
  ls         list current directory, wildcards allowed  
  lsmark     list the marked files in and below the cd  
  mark       mark dir/file to be restored recursively in dirs  
  markdir    mark directory name to be restored (no files)  
  pwd        print current working directory  
  unmark     unmark dir/file to be restored recursively in dir  
  unmarkdir  unmark directory name only no recursion  
  quit       quit and do not do restore  
  ?          print help

As a default no ﬁles have been selected for restore (unless you added all to the command line. If you want to restore everything, at this point, you should enter mark *, and then done and Bareos will write the bootstrap records to a ﬁle and request your approval to start a restore job.

If you do not enter the above mentioned mark * command, you will start with an empty state. Now you can simply start looking at the tree and mark particular ﬁles or directories you want restored. It is easy to make a mistake in specifying a ﬁle to mark or unmark, and Bareos’s error handling is not perfect, so please check your work by using the ls or dir commands to see what ﬁles are actually selected. Any selected ﬁle has its name preceded by an asterisk.

To check what is marked or not marked, enter the count command, which displays:
128401 total files. 128401 marked to be restored.  

Each of the above commands will be described in more detail in the next section. We continue with the above example, having accepted to restore all ﬁles as Bareos set by default. On entering the done command, Bareos prints:
Run Restore job  
JobName:         RestoreFiles  
Bootstrap:       /var/lib/bareos/client1.restore.3.bsr  
Where:           /tmp/bareos-restores  
Replace:         Always  
FileSet:         Full Set  
Backup Client:   client1  
Restore Client:  client1  
Format:          Native  
Storage:         File  
When:            2013-06-28 13:30:08  
Catalog:         MyCatalog  
Priority:        10  
Plugin Options:  *None*  
OK to run? (yes/mod/no):

Please examine each of the items very carefully to make sure that they are correct. In particular, look at Where, which tells you where in the directory structure the ﬁles will be restored, and Client, which tells you which client will receive the ﬁles. Note that by default the Client which will receive the ﬁles is the Client that was backed up. These items will not always be completed with the correct values depending on which of the restore options you chose. You can change any of these default items by entering mod and responding to the prompts.

The above assumes that you have deﬁned a Restore Job resource in your Director’s conﬁguration ﬁle. Normally, you will only need one Restore Job resource deﬁnition because by its nature, restoring is a manual operation, and using the Console interface, you will be able to modify the Restore Job to do what you want.

An example Restore Job resource deﬁnition is given below.

Returning to the above example, you should verify that the Client name is correct before running the Job. However, you may want to modify some of the parameters of the restore job. For example, in addition to checking the Client it is wise to check that the Storage device chosen by Bareos is indeed correct. Although the FileSet is shown, it will be ignored in restore. The restore will choose the ﬁles to be restored either by reading the Bootstrap ﬁle, or if not speciﬁed, it will restore all ﬁles associated with the speciﬁed backup JobId (i.e. the JobId of the Job that originally backed up the ﬁles).

Finally before running the job, please note that the default location for restoring ﬁles is not their original locations, but rather the directory /tmp/bareos-restores. You can change this default by modifying your bareos-dir.conf ﬁle, or you can modify it using the mod option. If you want to restore the ﬁles to their original location, you must have Where set to nothing or to the root, i.e. /.

If you now enter yes, Bareos will run the restore Job.

#
16.3 Selecting Files by Filename

If you have a small number of ﬁles to restore, and you know the ﬁlenames, you can either put the list of ﬁlenames in a ﬁle to be read by Bareos, or you can enter the names one at a time. The ﬁlenames must include the full path and ﬁlename. No wild cards are used.

To enter the ﬁles, after the restore, you select item number 7 from the prompt list:


* restore
First you select one or more JobIds that contain files
to be restored. You will be presented several methods
of specifying the JobIds. Then you will be allowed to
select which files from those JobIds are to be restored.

To select the JobIds, you have the following choices:
     1: List last 20 Jobs run
     2: List Jobs where a given File is saved
     3: Enter list of comma separated JobIds to select
     4: Enter SQL list command
     5: Select the most recent backup for a client
     6: Select backup for a client before a specified time
     7: Enter a list of files to restore
     8: Enter a list of files to restore before a specified time
     9: Find the JobIds of the most recent backup for a client
    10: Find the JobIds for a backup for a client before a specified time
    11: Enter a list of directories to restore for found JobIds
    12: Select full restore to a specified Job date
    13: Cancel
Select item:  (1−13): 7


bconsole 16.3: restore list of ﬁles

which then prompts you for the client name:
Defined Clients:  
     1: client1  
     2: Tibs  
     3: Rufus  
Select the Client (1-3): 3

Of course, your client list will be diﬀerent, and if you have only one client, it will be automatically selected. And ﬁnally, Bareos requests you to enter a ﬁlename:
Enter filename:

At this point, you can enter the full path and ﬁlename
Enter filename: /etc/resolv.conf  
Enter filename:

as you can see, it took the ﬁlename. If Bareos cannot ﬁnd a copy of the ﬁle, it prints the following:
Enter filename: junk filename  
No database record found for: junk filename  
Enter filename:

If you want Bareos to read the ﬁlenames from a ﬁle, you simply precede the ﬁlename with a less-than symbol (<).

It is possible to automate the selection by ﬁle by putting your list of ﬁles in say /tmp/ﬁle-list, then using the following command:
restore client=client1 file=</tmp/file-list

If in modifying the parameters for the Run Restore job, you ﬁnd that Bareos asks you to enter a Job number, this is because you have not yet speciﬁed either a Job number or a Bootstrap ﬁle. Simply entering zero will allow you to continue and to select another option to be modiﬁed.

#
16.4 Replace Options

When restoring, you have the option to specify a Replace option. This directive determines the action to be taken when restoring a ﬁle or directory that already exists. This directive can be set by selecting the mod option. You will be given a list of parameters to choose from. Full details on this option can be found in the Job Resource section of the Director documentation.

#
16.5 Command Line Arguments

If all the above sounds complicated, you will probably agree that it really isn’t after trying it a few times. It is possible to do everything that was shown above, with the exception of selecting the FileSet, by using command line arguments with a single command by entering:
restore client=Rufus select current all done yes

The client=Rufus speciﬁcation will automatically select Rufus as the client, the current tells Bareos that you want to restore the system to the most current state possible, and the yes suppresses the ﬁnal yes/mod/no prompt and simply runs the restore.

The full list of possible command line arguments are:

    all – select all Files to be restored.
    select – use the tree selection method.
    done – do not prompt the user in tree mode.
    copies – instead of using the actual backup jobs for restoring use the copies which were made of these backup Jobs. This could mean that on restore the client will contact a remote storage daemon if the data is copied to a remote storage daemon as part of your copy Job scheme.
    current – automatically select the most current set of backups for the speciﬁed client.
    client=xxxx – initially speciﬁes the client from which the backup was made and the client to which the restore will be make. See also ”restoreclient” keyword.
    restoreclient=xxxx – if the keyword is speciﬁed, then the restore is written to that client.
    jobid=nnn – specify a JobId or comma separated list of JobIds to be restored.
    before=YYYY-MM-DD HH:MM:SS – specify a date and time to which the system should be restored. Only Jobs started before the speciﬁed date/time will be selected, and as is the case for current Bareos will automatically ﬁnd the most recent prior Full save and all Diﬀerential and Incremental saves run before the date you specify. Note, this command is not too user friendly in that you must specify the date/time exactly as shown.
    ﬁle=ﬁlename – specify a ﬁlename to be restored. You must specify the full path and ﬁlename. Preﬁxing the entry with a less-than sign (<) will cause Bareos to assume that the ﬁlename is on your system and contains a list of ﬁles to be restored. Bareos will thus read the list from that ﬁle. Multiple ﬁle=xxx speciﬁcations may be speciﬁed on the command line.
    jobid=nnn – specify a JobId to be restored.
    pool=pool-name – specify a Pool name to be used for selection of Volumes when specifying options 5 and 6 (restore current system, and restore current system before given date). This permits you to have several Pools, possibly one oﬀsite, and to select the Pool to be used for restoring.
    where=/tmp/bareos-restore – restore ﬁles in where directory.
    yes – automatically run the restore without prompting for modiﬁcations (most useful in batch scripts).
    strip_preﬁx=/prod – remove a part of the ﬁlename when restoring.
    add_preﬁx=/test – add a preﬁx to all ﬁles when restoring (like where) (can’t be used with where=).
    add_suﬃx=.old – add a suﬃx to all your ﬁles.
    regexwhere=!a.pdf!a.bkp.pdf! – do complex ﬁlename manipulation like with sed unix command. Will overwrite other ﬁlename manipulation. For details, see the regexwhere section.
    restorejob=jobname – Pre-chooses a restore job. Bareos can be conﬁgured with multiple restore jobs (”Type = Restore” in the job deﬁnition). This allows the speciﬁcation of diﬀerent restore properties, including a set of RunScripts. When more than one job of this type is conﬁgured, during restore, Bareos will ask for a user selection interactively, or use the given restorejob.

#
16.6 Using File Relocation

Introduction

The where= option is simple, but not very powerful. With ﬁle relocation, Bareos can restore a ﬁle to the same directory, but with a diﬀerent name, or in an other directory without recreating the full path.

You can also do ﬁlename and path manipulations, such as adding a suﬃx to all your ﬁles, renaming ﬁles or directories, etc. Theses options will overwrite where= option.

For example, many users use OS snapshot features so that ﬁle /home/eric/mbox will be backed up from the directory /.snap/home/eric/mbox, which can complicate restores. If you use where=/tmp, the ﬁle will be restored to /tmp/.snap/home/eric/mbox and you will have to move the ﬁle to /home/eric/mbox.bkp by hand.

However, case, you could use the strip_preﬁx=/.snap and add_suﬃx=.bkp options and Bareos will restore the ﬁle to its original location – that is /home/eric/mbox.

To use this feature, there are command line options as described in the restore section of this manual; you can modify your restore job before running it; or you can add options to your restore job in as described in Strip Preﬁx Dir Job and Add Preﬁx Dir Job.
Parameters to modify:  
     1: Level  
     2: Storage  
    ...  
    10: File Relocation  
    ...  
Select parameter to modify (1-12):  


This will replace your current Where value  
     1: Strip prefix  
     2: Add prefix  
     3: Add file suffix  
     4: Enter a regexp  
     5: Test filename manipulation  
     6: Use this ?  
Select parameter to modify (1-6):

RegexWhere Format

The format is very close to that used by sed or Perl (s/replace this/by that/) operator. A valid regexwhere expression has three ﬁelds :

    a search expression (with optional submatch)
    a replacement expression (with optionnal back references $1 to $9)
    a set of search options (only case-insensitive “i” at this time)

Each ﬁeld is delimited by a separator speciﬁed by the user as the ﬁrst character of the expression. The separator can be one of the following:
<separator-keyword> = / ! ; % : , ~ # = &

You can use several expressions separated by a commas.

Examples

Orignal ﬁlename 	New ﬁlename 	RegexWhere 	Comments


c:/system.ini 	c:/system.old.ini	/.ini$/.old.ini/ 	$ matches end of name

/prod/u01/pdata/	/rect/u01/rdata 	/prod/rect/,/pdata/rdata/ 	uses two regexp

/prod/u01/pdata/	/rect/u01/rdata 	!/prod/!/rect/!,/pdata/rdata/	use ! as separator

C:/WINNT 	d:/WINNT 	/c:/d:/i 	case insensitive pattern match


#
16.7 Restoring Directory Attributes

Depending how you do the restore, you may or may not get the directory entries back to their original state. Here are a few of the problems you can encounter, and for same machine restores, how to avoid them.

    You backed up on one machine and are restoring to another that is either a diﬀerent OS or doesn’t have the same users/groups deﬁned. Bareos does the best it can in these situations. Note, Bareos has saved the user/groups in numeric form, which means on a diﬀerent machine, they may map to diﬀerent user/group names.
    You are restoring into a directory that is already created and has ﬁle creation restrictions. Bareos tries to reset everything but without walking up the full chain of directories and modifying them all during the restore, which Bareos does and will not do, getting permissions back correctly in this situation depends to a large extent on your OS.
    You are doing a recursive restore of a directory tree. In this case Bareos will restore a ﬁle before restoring the ﬁle’s parent directory entry. In the process of restoring the ﬁle Bareos will create the parent directory with open permissions and ownership of the ﬁle being restored. Then when Bareos tries to restore the parent directory Bareos sees that it already exists (Similar to the previous situation). If you had set the Restore job’s ”Replace” property to ”never” then Bareos will not change the directory’s permissions and ownerships to match what it backed up, you should also notice that the actual number of ﬁles restored is less then the expected number. If you had set the Restore job’s ”Replace” property to ”always” then Bareos will change the Directory’s ownership and permissions to match what it backed up, also the actual number of ﬁles restored should be equal to the expected number.
    You selected one or more ﬁles in a directory, but did not select the directory entry to be restored. In that case, if the directory is not on disk Bareos simply creates the directory with some default attributes which may not be the same as the original. If you do not select a directory and all its contents to be restored, you can still select items within the directory to be restored by individually marking those ﬁles, but in that case, you should individually use the ”markdir” command to select all higher level directory entries (one at a time) to be restored if you want the directory entries properly restored.

#
16.8 Restoring on Windows

If you are restoring on Windows systems, Bareos will restore the ﬁles with the original ownerships and permissions as would be expected. This is also true if you are restoring those ﬁles to an alternate directory (using the Where option in restore). However, if the alternate directory does not already exist, the Bareos File daemon (Client) will try to create it. In some cases, it may not create the directories, and if it does since the File daemon runs under the SYSTEM account, the directory will be created with SYSTEM ownership and permissions. In this case, you may have problems accessing the newly restored ﬁles.

To avoid this problem, you should create any alternate directory before doing the restore. Bareos will not change the ownership and permissions of the directory if it is already created as long as it is not one of the directories being restored (i.e. written to tape).

The default restore location is /tmp/bareos-restores/ and if you are restoring from drive E:, the default will be /tmp/bareos-restores/e/, so you should ensure that this directory exists before doing the restore, or use the mod option to select a diﬀerent where directory that does exist.

Some users have experienced problems restoring ﬁles that participate in the Active Directory. They also report that changing the userid under which Bareos (bareos-fd.exe) runs, from SYSTEM to a Domain Admin userid, resolves the problem.

#
16.9 Restore Errors

There are a number of reasons why there may be restore errors or warning messages. Some of the more common ones are:

ﬁle count mismatch
    This can occur for the following reasons:

        You requested Bareos not to overwrite existing or newer ﬁles.
        A Bareos miscount of ﬁles/directories. This is an on-going problem due to the complications of directories, soft/hard link, and such. Simply check that all the ﬁles you wanted were actually restored.

ﬁle size error
    When Bareos restores ﬁles, it checks that the size of the restored ﬁle is the same as the ﬁle status data it saved when starting the backup of the ﬁle. If the sizes do not agree, Bareos will print an error message. This size mismatch most often occurs because the ﬁle was being written as Bareos backed up the ﬁle. In this case, the size that Bareos restored will be greater than the status size. This often happens with log ﬁles.

    If the restored size is smaller, then you should be concerned about a possible tape error and check the Bareos output as well as your system logs.

#
16.10 Example Restore Job Resource
Job {  
  Name = "RestoreFiles"  
  Type = Restore  
  Client = Any-client  
  FileSet = "Any-FileSet"  
  Storage = Any-storage  
  Where = /tmp/bareos-restores  
  Messages = Standard  
  Pool = Default  
}

If Where is not speciﬁed, the default location for restoring ﬁles will be their original locations.

#
16.11 File Selection Commands

After you have selected the Jobs to be restored and Bareos has created the in-memory directory tree, you will enter ﬁle selection mode as indicated by the dollar sign ($) prompt. While in this mode, you may use the commands listed above. The basic idea is to move up and down the in memory directory structure with the cd command much as you normally do on the system. Once you are in a directory, you may select the ﬁles that you want restored. As a default no ﬁles are marked to be restored. If you wish to start with all ﬁles, simply enter: cd / and mark *. Otherwise proceed to select the ﬁles you wish to restore by marking them with the mark command. The available commands are:

cd
    The cd command changes the current directory to the argument speciﬁed. It operates much like the Unix cd command. Wildcard speciﬁcations are not permitted.

    Note, on Windows systems, the various drives (c:, d:, ...) are treated like a directory within the ﬁle tree while in the ﬁle selection mode. As a consequence, you must do a cd c: or possibly in some cases a cd C: (note upper case) to get down to the ﬁrst directory.
dir
    The dir command is similar to the ls command, except that it prints it in long format (all details). This command can be a bit slower than the ls command because it must access the catalog database for the detailed information for each ﬁle.
estimate
    The estimate command prints a summary of the total ﬁles in the tree, how many are marked to be restored, and an estimate of the number of bytes to be restored. This can be useful if you are short on disk space on the machine where the ﬁles will be restored.
ﬁnd
    The ﬁnd command accepts one or more arguments and displays all ﬁles in the tree that match that argument. The argument may have wildcards. It is somewhat similar to the Unix command ﬁnd / -name arg.
ls
    The ls command produces a listing of all the ﬁles contained in the current directory much like the Unix ls command. You may specify an argument containing wildcards, in which case only those ﬁles will be listed.

    Any ﬁle that is marked to be restored will have its name preceded by an asterisk (*). Directory names will be terminated with a forward slash (/) to distinguish them from ﬁlenames.
lsmark
    The lsmark command is the same as the ls except that it will print only those ﬁles marked for extraction. The other distinction is that it will recursively descend into any directory selected.
mark
    The mark command allows you to mark ﬁles to be restored. It takes a single argument which is the ﬁlename or directory name in the current directory to be marked for extraction. The argument may be a wildcard speciﬁcation, in which case all ﬁles that match in the current directory are marked to be restored. If the argument matches a directory rather than a ﬁle, then the directory and all the ﬁles contained in that directory (recursively) are marked to be restored. Any marked ﬁle will have its name preceded with an asterisk (*) in the output produced by the ls or dir commands. Note, supplying a full path on the mark command does not work as expected to select a ﬁle or directory in the current directory. Also, the mark command works on the current and lower directories but does not touch higher level directories.

    After executing the mark command, it will print a brief summary:
        No files marked.  
    
    If no ﬁles were marked, or:
        nn files marked.  
    
    if some ﬁles are marked.
unmark
    The unmark is identical to the mark command, except that it unmarks the speciﬁed ﬁle or ﬁles so that they will not be restored. Note: the unmark command works from the current directory, so it does not unmark any ﬁles at a higher level. First do a cd / before the unmark * command if you want to unmark everything.
pwd
    The pwd command prints the current working directory. It accepts no arguments.
count
    The count command prints the total ﬁles in the directory tree and the number of ﬁles marked to be restored.
done
    This command terminates ﬁle selection mode.
exit
    This command terminates ﬁle selection mode (the same as done).
quit
    This command terminates the ﬁle selection and does not run the restore job.
help
    This command prints a summary of the commands available.
?
    This command is the same as the help command.

If your ﬁlename contains some weird caracters, you can use ?, * or ∖∖. For example, if your ﬁlename contains a ∖, you can use ∖∖∖∖.
* mark weird_file\\\\with-backslash

#
Chapter 17
Volume Management

This chapter presents most all the features needed to do Volume management. Most of the concepts apply equally well to both tape and disk Volumes. However, the chapter was originally written to explain backing up to disk, so you will see it is slanted in that direction, but all the directives presented here apply equally well whether your volume is disk or tape.

If you have a lot of hard disk storage or you absolutely must have your backups run within a small time window, you may want to direct Bareos to backup to disk Volumes rather than tape Volumes. This chapter is intended to give you some of the options that are available to you so that you can manage either disk or tape volumes. #
17.1 Key Concepts and Resource Records

Getting Bareos to write to disk rather than tape in the simplest case is rather easy. In the Storage daemon’s conﬁguration ﬁle, you simply deﬁne an Archive Device Sd Device to be a directory. The default directory to store backups on disk is /var/lib/bareos/storage:
Device {  
  Name = FileBackup  
  Media Type = File  
  Archive Device = /var/lib/bareos/storage  
  Random Access = Yes;  
  AutomaticMount = yes;  
  RemovableMedia = no;  
  AlwaysOpen = no;  
}

Assuming you have the appropriate Storage resource in your Director’s conﬁguration ﬁle that references the above Device resource,
Storage {  
  Name = FileStorage  
  Address = ...  
  Password = ...  
  Device = FileBackup  
  Media Type = File  
}

Bareos will then write the archive to the ﬁle /var/lib/bareos/storage/<volume-name> where <volume-name> is the volume name of a Volume deﬁned in the Pool. For example, if you have labeled a Volume named Vol001, Bareos will write to the ﬁle /var/lib/bareos/storage/Vol001. Although you can later move the archive ﬁle to another directory, you should not rename it or it will become unreadable by Bareos. This is because each archive has the ﬁlename as part of the internal label, and the internal label must agree with the system ﬁlename before Bareos will use it.

Although this is quite simple, there are a number of problems. The ﬁrst is that unless you specify otherwise, Bareos will always write to the same volume until you run out of disk space. This problem is addressed below.

In addition, if you want to use concurrent jobs that write to several diﬀerent volumes at the same time, you will need to understand a number of other details. An example of such a conﬁguration is given at the end of this chapter under Concurrent Disk Jobs.

#
17.1.1 Pool Options to Limit the Volume Usage

Some of the options you have, all of which are speciﬁed in the Pool record, are:

    Maximum Volume Jobs Dir Pool: write only the speciﬁed number of jobs on each Volume.
    Maximum Volume Bytes Dir Pool: limit the maximum size of each Volume.
    
    Note, if you use disk volumes you should probably limit the Volume size to some reasonable value. If you ever have a partial hard disk failure, you are more likely to be able to recover more data if they are in smaller Volumes.
    Volume Use Duration Dir Pool: restrict the time between ﬁrst and last data written to Volume.

Note that although you probably would not want to limit the number of bytes on a tape as you would on a disk Volume, the other options can be very useful in limiting the time Bareos will use a particular Volume (be it tape or disk). For example, the above directives can allow you to ensure that you rotate through a set of daily Volumes if you wish.

As mentioned above, each of those directives is speciﬁed in the Pool or Pools that you use for your Volumes. In the case of Maximum Volume Jobs Dir Pool, Maximum Volume Bytes Dir Pool and Volume Use Duration Dir Pool, you can actually specify the desired value on a Volume by Volume basis. The value speciﬁed in the Pool record becomes the default when labeling new Volumes. Once a Volume has been created, it gets its own copy of the Pool defaults, and subsequently changing the Pool will have no eﬀect on existing Volumes. You can either manually change the Volume values, or refresh them from the Pool defaults using the update volume command in the Console. As an example of the use of one of the above, suppose your Pool resource contains:


Pool {
  Name = File
  Pool Type = Backup
  Volume Use Duration = 23h
}


Conﬁguration 17.1: Volume Use Duration

then if you run a backup once a day (every 24 hours), Bareos will use a new Volume for each backup, because each Volume it writes can only be used for 23 hours after the ﬁrst write. Note, setting the use duration to 23 hours is not a very good solution for tapes unless you have someone on-site during the weekends, because Bareos will want a new Volume and no one will be present to mount it, so no weekend backups will be done until Monday morning.

#
17.1.2 Automatic Volume Labeling

Use of the above records brings up another problem – that of labeling your Volumes. For automated disk backup, you can either manually label each of your Volumes, or you can have Bareos automatically label new Volumes when they are needed.

Please note that automatic Volume labeling can also be used with tapes, but it is not nearly so practical since the tapes must be pre-mounted. This requires some user interaction. Automatic labeling from templates does NOT work with autochangers since Bareos will not access unknown slots. There are several methods of labeling all volumes in an autochanger magazine. For more information on this, please see the Autochanger Support chapter.

Automatic Volume labeling is enabled by making a change to both the PoolDir resource and to the DeviceSd resource shown above. In the case of the Pool resource, you must provide Bareos with a label format that it will use to create new names. In the simplest form, the label format is simply the Volume name, to which Bareos will append a four digit number. This number starts at 0001 and is incremented for each Volume the catalog contains. Thus if you modify your Pool resource to be:


Pool {
  Name = File
  Pool Type = Backup
  Volume Use Duration = 23h
  Label Format = "Vol"
}


Conﬁguration 17.2: Label Format

Bareos will create Volume names Vol0001, Vol0002, and so on when new Volumes are needed. Much more complex and elaborate labels can be created using variable expansion deﬁned in the Variable Expansion chapter of this manual.

The second change that is necessary to make automatic labeling work is to give the Storage daemon permission to automatically label Volumes. Do so by adding Label Media Sd Device = yes to the Device resource as follows:


Device {
  Name = File
  Media Type = File
  Archive Device = /var/lib/bareos/storage/
  Random Access = yes
  Automatic Mount = yes
  Removable Media = no
  Always Open = no
  Label Media = yes
}


Conﬁguration 17.3: Label Media

See Label Format Dir Pool for details about the labeling format.

#
17.1.3 Restricting the Number of Volumes and Recycling

Automatic labeling discussed above brings up the problem of Volume management. With the above scheme, a new Volume will be created every day. If you have not speciﬁed Retention periods, your Catalog will continue to ﬁll keeping track of all the ﬁles Bareos has backed up, and this procedure will create one new archive ﬁle (Volume) every day.

The tools Bareos gives you to help automatically manage these problems are the following:

    File Retention Dir Client: catalog ﬁle record retention period.
    Job Retention Dir Client: catalog job record retention period.
    Auto Prune Dir Client = yes: permit the application of the above two retention periods.
    Volume Retention Dir Pool
    Auto Prune Dir Pool = yes: permit the application of the Volume Retention Dir Pool period.
    Recycle Dir Pool = yes: permit automatic recycling of Volumes whose Volume retention period has expired.
    Recycle Oldest Volume Dir Pool = yes: prune the oldest volume in the Pool, and if all ﬁles were pruned, recycle this volume and use it.
    Recycle Current Volume Dir Pool = yes: prune the currently mounted volume in the Pool, and if all ﬁles were pruned, recycle this volume and use it.
    Purge Oldest Volume Dir Pool = yes: permits a forced recycling of the oldest Volume when a new one is needed.
    Please note! This record ignores retention periods! We highly recommend not to use this record, but instead use Recycle Oldest Volume Dir Pool.
    Maximum Volumes Dir Pool: limitthe number of Volumes that can be created.

The ﬁrst three records (File Retention Dir Client, Job Retention Dir Client and Auto Prune Dir Client) determine the amount of time that Job and File records will remain in your Catalog and they are discussed in detail in the Automatic Volume Recycling chapter.

Volume Retention Dir Pool, Auto Prune Dir Pool and Recycle Dir Pool determine how long Bareos will keep your Volumes before reusing them and they are also discussed in detail in the Automatic Volume Recycling chapter.

The Maximum Volumes Dir Pool record can also be used in conjunction with the Volume Retention Dir Pool period to limit the total number of archive Volumes that Bareos will create. By setting an appropriate Volume Retention Dir Pool period, a Volume will be purged just before it is needed and thus Bareos can cycle through a ﬁxed set of Volumes. Cycling through a ﬁxed set of Volumes can also be done by setting Purge Oldest Volume Dir Pool = yes or Recycle Current Volume Dir Pool = yes. In this case, when Bareos needs a new Volume, it will prune the speciﬁed volume.

#
17.2 Concurrent Disk Jobs

Above, we discussed how you could have a single device named FileBackupSd Device that writes to volumes in /var/lib/bareos/storage/. You can, in fact, run multiple concurrent jobs using the Storage deﬁnition given with this example, and all the jobs will simultaneously write into the Volume that is being written.

Now suppose you want to use multiple Pools, which means multiple Volumes, or suppose you want each client to have its own Volume and perhaps its own directory such as /home/bareos/client1 and /home/bareos/client2 ... . With the single Storage and Device deﬁnition above, neither of these two is possible. Why? Because Bareos disk storage follows the same rules as tape devices. Only one Volume can be mounted on any Device at any time. If you want to simultaneously write multiple Volumes, you will need multiple Device resources in your Bareos Storage Daemon conﬁguration and thus multiple Storage resources in your Bareos Director conﬁguration.

Okay, so now you should understand that you need multiple Device deﬁnitions in the case of diﬀerent directories or diﬀerent Pools, but you also need to know that the catalog data that Bareos keeps contains only the Media Type and not the speciﬁc storage device. This permits a tape for example to be re-read on any compatible tape drive. The compatibility being determined by the Media Type (Media Type Dir Storage and Media Type Sd Device). The same applies to disk storage. Since a volume that is written by a Device in say directory /home/bareos/backups cannot be read by a Device with an Archive Device Sd Device = /home/bareos/client1, you will not be able to restore all your ﬁles if you give both those devices Media Type Sd Device = File. During the restore, Bareos will simply choose the ﬁrst available device, which may not be the correct one. If this is confusing, just remember that the Directory has only the Media Type and the Volume name. It does not know the Archive Device Sd Device (or the full path) that is speciﬁed in the Bareos Storage Daemon. Thus you must explicitly tie your Volumes to the correct Device by using the Media Type.

#
17.2.1 Example for two clients, separate devices and recycling

The following example is not very practical, but can be used to demonstrate the proof of concept in a relatively short period of time.

The example consists of a two clients that are backed up to a set of 12 Volumes for each client into diﬀerent directories on the Storage machine. Each Volume is used (written) only once, and there are four Full saves done every hour (so the whole thing cycles around after three hours).

What is key here is that each physical device on the Bareos Storage Daemon has a diﬀerent Media Type. This allows the Director to choose the correct device for restores.

The Bareos Director conﬁguration is as follows:


Director {
  Name = bareos-dir
  QueryFile = "/usr/lib/bareos/scripts/query.sql"
  Password = "<secret>"
}

Schedule {
  Name = "FourPerHour"
  Run = Level=Full hourly at 0:05
  Run = Level=Full hourly at 0:20
  Run = Level=Full hourly at 0:35
  Run = Level=Full hourly at 0:50
}

FileSet {
  Name = "Example FileSet"
  Include {
    Options {
      compression=GZIP
      signature=SHA1
    }
    File = /etc
  }
}

Job {
  Name = "RecycleExample"
  Type = Backup
  Level = Full
  Client = client1-fd
  FileSet= "Example FileSet"
  Messages = Standard
  Storage = FileStorage
  Pool = Recycle
  Schedule = FourPerHour
}

Job {
  Name = "RecycleExample2"
  Type = Backup
  Level = Full
  Client = client2-fd
  FileSet= "Example FileSet"
  Messages = Standard
  Storage = FileStorage2
  Pool = Recycle2
  Schedule = FourPerHour
}

Client {
  Name = client1-fd
  Address = client1.example.com
  Password = client1_password
}

Client {
  Name = client2-fd
  Address = client2.example.com
  Password = client2_password
}

Storage {
  Name = FileStorage
  Address = bareos-sd.example.com
  Password = local_storage_password
  Device = RecycleDir
  Media Type = File
}

Storage {
  Name = FileStorage2
  Address = bareos-sd.example.com
  Password = local_storage_password
  Device = RecycleDir2
  Media Type = File1
}

Catalog {
  Name = MyCatalog
  ...
}

Messages {
  Name = Standard
  ...
}

Pool {
  Name = Recycle
  Pool Type = Backup
  Label Format = "Recycle-"
  Auto Prune = yes
  Use Volume Once = yes
  Volume Retention = 2h
  Maximum Volumes = 12
  Recycle = yes
}

Pool {
  Name = Recycle2
  Pool Type = Backup
  Label Format = "Recycle2-"
  Auto Prune = yes
  Use Volume Once = yes
  Volume Retention = 2h
  Maximum Volumes = 12
  Recycle = yes
}


and the Bareos Storage Daemon conﬁguration is:


Storage {
  Name = bareos-sd
  Maximum Concurrent Jobs = 10
}

Director {
  Name = bareos-dir
  Password = local_storage_password
}

Device {
  Name = RecycleDir
  Media Type = File
  Archive Device = /home/bareos/backups
  LabelMedia = yes;
  Random Access = Yes;
  AutomaticMount = yes;
  RemovableMedia = no;
  AlwaysOpen = no;
}

Device {
  Name = RecycleDir2
  Media Type = File2
  Archive Device = /home/bareos/backups2
  LabelMedia = yes;
  Random Access = Yes;
  AutomaticMount = yes;
  RemovableMedia = no;
  AlwaysOpen = no;
}

Messages {
  Name = Standard
  director = bareos-dir = all
}


With a little bit of work, you can change the above example into a weekly or monthly cycle (take care about the amount of archive disk space used).

#
17.2.2 Using Multiple Storage Devices

Bareos treats disk volumes similar to tape volumes as much as it can. This means that you can only have a single Volume mounted at one time on a disk as deﬁned in your DeviceSd resource.

If you use Bareos without Data Spooling, multiple concurrent backup jobs can be written to a Volume using interleaving. However, interleaving has disadvantages, see Concurrent Jobs.

Also the DeviceSd will be in use. If there are other jobs, requesting other Volumes, these jobs have to wait.

On a tape (or autochanger), this is a physical limitation of the hardware. However, when using disk storage, this is only a limitation of the software.

To enable Bareos to run concurrent jobs (on disk storage), deﬁne as many DeviceSd as concurrent jobs should run. All these DeviceSds can use the same Archive Device Sd Device directory. Set Maximum Concurrent Jobs Sd Device = 1 for all these devices.

Example: use four storage devices pointing to the same directory


Director {
  Name = bareos-dir.example.com
  QueryFile = "/usr/lib/bareos/scripts/query.sql"
  Maximum Concurrent Jobs = 10
  Password = "<secret>"
}

Storage {
  Name = File
  Address = bareos-sd.bareos.com
  Password = "<sd-secret>"
  Device = FileStorage1
  Device = FileStorage2
  Device = FileStorage3
  Device = FileStorage4
  # number of devices = Maximum Concurrent Jobs
  Maximum Concurrent Jobs = 4
  Media Type = File
}

[...]


Conﬁguration 17.4: Bareos Director conﬁguration: using 4 storage devices


Storage {
  Name = bareos-sd.example.com
  # any number >= 4
  Maximum Concurrent Jobs = 20
}

Director {
  Name = bareos-dir.example.com
  Password = "<sd-secret>"
}

Device {
  Name = FileStorage1
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes
  Random Access = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = no
  Maximum Concurrent Jobs = 1
}

Device {
  Name = FileStorage2
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes
  Random Access = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = no
  Maximum Concurrent Jobs = 1
}

Device {
  Name = FileStorage3
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes
  Random Access = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = no
  Maximum Concurrent Jobs = 1
}

Device {
  Name = FileStorage4
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes
  Random Access = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = no
  Maximum Concurrent Jobs = 1
}


Conﬁguration 17.5: Bareos Storage Daemon conﬁguraton: using 4 storage devices

#
17.3 Automatic Volume Recycling

By default, once Bareos starts writing a Volume, it can append to the volume, but it will not overwrite the existing data thus destroying it. However when Bareos recycles a Volume, the Volume becomes available for being reused and Bareos can at some later time overwrite the previous contents of that Volume. Thus all previous data will be lost. If the Volume is a tape, the tape will be rewritten from the beginning. If the Volume is a disk ﬁle, the ﬁle will be truncated before being rewritten.

You may not want Bareos to automatically recycle (reuse) tapes. This would require a large number of tapes though, and in such a case, it is possible to manually recycle tapes. For more on manual recycling, see the Manually Recycling Volumes chapter.

Most people prefer to have a Pool of tapes that are used for daily backups and recycled once a week, another Pool of tapes that are used for Full backups once a week and recycled monthly, and ﬁnally a Pool of tapes that are used once a month and recycled after a year or two. With a scheme like this, the number of tapes in your pool or pools remains constant.

By properly deﬁning your Volume Pools with appropriate Retention periods, Bareos can manage the recycling (such as deﬁned above) automatically.

Automatic recycling of Volumes is controlled by four records in the PoolDir resource deﬁnition. These four records are:

    Auto Prune Dir Pool = yes
    Volume Retention Dir Pool
    Recycle Dir Pool = yes
    Recycle Pool Dir Pool

The above three directives are all you need assuming that you ﬁll each of your Volumes then wait the Volume Retention period before reusing them. If you want Bareos to stop using a Volume and recycle it before it is full, you can use one or more additional directives such as:

    Volume Use Duration Dir Pool
    Maximum Volume Jobs Dir Pool
    Maximum Volume Bytes Dir Pool

Please see below and the Basic Volume Management chapter of this manual for complete examples.

Automatic recycling of Volumes is performed by Bareos only when it wants a new Volume and no appendable Volumes are available in the Pool. It will then search the Pool for any Volumes with the Recycle ﬂag set and the Volume Status is Purged. At that point, it will choose the oldest purged volume and recycle it.

If there are no volumes with status Purged, then the recycling occurs in two steps:

    The Catalog for a Volume must be pruned of all Jobs (i.e. Purged).
    The actual recycling of the Volume.

Only Volumes marked Full or Used will be considerd for pruning. The Volume will be purged if the Volume Retention period has expired. When a Volume is marked as Purged, it means that no Catalog records reference that Volume and the Volume can be recycled.

Until recycling actually occurs, the Volume data remains intact. If no Volumes can be found for recycling for any of the reasons stated above, Bareos will request operator intervention (i.e. it will ask you to label a new volume).

A key point mentioned above, that can be a source of frustration, is that Bareos will only recycle purged Volumes if there is no other appendable Volume available. Otherwise, it will always write to an appendable Volume before recycling even if there are Volume marked as Purged. This preserves your data as long as possible. So, if you wish to “force” Bareos to use a purged Volume, you must ﬁrst ensure that no other Volume in the Pool is marked Append. If necessary, you can manually set a volume to Full. The reason for this is that Bareos wants to preserve the data on your old tapes (even though purged from the catalog) as long as absolutely possible before overwriting it. There are also a number of directives such as Volume Use Duration that will automatically mark a volume as Used and thus no longer appendable.

#
17.3.1 Automatic Pruning

As Bareos writes ﬁles to tape, it keeps a list of ﬁles, jobs, and volumes in a database called the catalog. Among other things, the database helps Bareos to decide which ﬁles to back up in an incremental or diﬀerential backup, and helps you locate ﬁles on past backups when you want to restore something. However, the catalog will grow larger and larger as time goes on, and eventually it can become unacceptably large.

Bareos’s process for removing entries from the catalog is called Pruning. The default is Automatic Pruning, which means that once an entry reaches a certain age (e.g. 30 days old) it is removed from the catalog. Note that Job records that are required for current restore and File records are needed for VirtualFull and Accurate backups won’t be removed automatically.

Once a job has been pruned, you can still restore it from the backup tape, but one additional step is required: scanning the volume with bscan.

The alternative to Automatic Pruning is Manual Pruning, in which you explicitly tell Bareos to erase the catalog entries for a volume. You’d usually do this when you want to reuse a Bareos volume, because there’s no point in keeping a list of ﬁles that USED TO BE on a tape. Or, if the catalog is starting to get too big, you could prune the oldest jobs to save space. Manual pruning is done with the prune command in the console.

#
17.3.2 Pruning Directives

There are three pruning durations. All apply to catalog database records and not to the actual data in a Volume. The pruning (or retention) durations are for: Volumes (Media records), Jobs (Job records), and Files (File records). The durations inter-depend because if Bareos prunes a Volume, it automatically removes all the Job records, and all the File records. Also when a Job record is pruned, all the File records for that Job are also pruned (deleted) from the catalog.

Having the File records in the database means that you can examine all the ﬁles backed up for a particular Job. They take the most space in the catalog (probably 90-95% of the total). When the File records are pruned, the Job records can remain, and you can still examine what Jobs ran, but not the details of the Files backed up. In addition, without the File records, you cannot use the Console restore command to restore the ﬁles.

When a Job record is pruned, the Volume (Media record) for that Job can still remain in the database, and if you do a list volumes, you will see the volume information, but the Job records (and its File records) will no longer be available.

In each case, pruning removes information about where older ﬁles are, but it also prevents the catalog from growing to be too large. You choose the retention periods in function of how many ﬁles you are backing up and the time periods you want to keep those records online, and the size of the database. It is possible to re-insert the records (with 98% of the original data) by using bscan to scan in a whole Volume or any part of the volume that you want.

By setting Auto Prune Dir Pool = yes you will permit the Bareos Director to automatically prune all Volumes in the Pool when a Job needs another Volume. Volume pruning means removing records from the catalog. It does not shrink the size of the Volume or aﬀect the Volume data until the Volume gets overwritten. When a Job requests another volume and there are no Volumes with Volume status Append available, Bareos will begin volume pruning. This means that all Jobs that are older than the Volume Retention period will be pruned from every Volume that has Volume status Full or Used and has Recycle = yes. Pruning consists of deleting the corresponding Job, File, and JobMedia records from the catalog database. No change to the physical data on the Volume occurs during the pruning process. When all ﬁles are pruned from a Volume (i.e. no records in the catalog), the Volume will be marked as Purged implying that no Jobs remain on the volume. The Pool records that control the pruning are described below.

    Auto Prune Dir Pool = yes: when running a Job and it needs a new Volume but no appendable volumes are available, apply the Volume retention period. At that point, Bareos will prune all Volumes that can be pruned in an attempt to ﬁnd a usable volume. If during the autoprune, all ﬁles are pruned from the Volume, it will be marked with Volume status Purged.
    
    Note, that although the File and Job records may be pruned from the catalog, a Volume will only be marked Purged (and hence ready for recycling) if the Volume status is Append, Full, Used, or Error. If the Volume has another status, such as Archive, Read-Only, Disabled, Busy or Cleaning, the Volume status will not be changed to Purged.
    Volume Retention Dir Pool deﬁnes the length of time that Bareos will guarantee that the Volume is not reused counting from the time the last job stored on the Volume terminated. A key point is that this time period is not even considered as long at the Volume remains appendable. The Volume Retention period count down begins only when the Append status has been changed to some other status (Full, Used, Purged, ...).
    
    When this time period expires and if Auto Prune Dir Pool = yes and a new Volume is needed, but no appendable Volume is available, Bareos will prune (remove) Job records that are older than the speciﬁed Volume Retention period.
    
    The Volume Retention period takes precedence over any Job Retention Dir Client period you have speciﬁed in the Client resource. It should also be noted, that the Volume Retention period is obtained by reading the Catalog Database Media record rather than the Pool resource record. This means that if you change the Volume Retention Dir Pool in the Pool resource record, you must ensure that the corresponding change is made in the catalog by using the update pool command. Doing so will insure that any new Volumes will be created with the changed Volume Retention period. Any existing Volumes will have their own copy of the Volume Retention period that can only be changed on a Volume by Volume basis using the update volume command.
    
    When all ﬁle catalog entries are removed from the volume, its Volume status is set to Purged. The ﬁles remain physically on the Volume until the volume is overwritten.
    Recycle Dir Pool deﬁnes whether or not the particular Volume can be recycled (i.e. rewritten). If Recycle is set to no, then even if Bareos prunes all the Jobs on the volume and it is marked Purged, it will not consider the tape for recycling. If Recycle is set to yes and all Jobs have been pruned, the volume status will be set to Purged and the volume may then be reused when another volume is needed. If the volume is reused, it is relabeled with the same Volume Name, however all previous data will be lost.

#
17.3.3 Recycling Algorithm

After all Volumes of a Pool have been pruned (as mentioned above, this happens when a Job needs a new Volume and no appendable Volumes are available), Bareos will look for the oldest Volume that is Purged (all Jobs and Files expired), and if the Recycle = yes for that Volume, Bareos will relabel it and write new data on it.

As mentioned above, there are two key points for getting a Volume to be recycled. First, the Volume must no longer be marked Append (there are a number of directives to automatically make this change), and second since the last write on the Volume, one or more of the Retention periods must have expired so that there are no more catalog backup job records that reference that Volume. Once both those conditions are satisﬁed, the volume can be marked Purged and hence recycled.

The full algorithm that Bareos uses when it needs a new Volume is:

The algorithm described below assumes that Auto Prune is enabled, that Recycling is turned on, and that you have deﬁned appropriate Retention periods or used the defaults for all these items.

    If the request is for an Autochanger device, look only for Volumes in the Autochanger (i.e. with InChanger set and that have the correct Storage device).
    Search the Pool for a Volume with Volume status=Append (if there is more than one, the Volume with the oldest date last written is chosen. If two have the same date then the one with the lowest MediaId is chosen).
    Search the Pool for a Volume with Volume status=Recycle and the InChanger ﬂag is set true (if there is more than one, the Volume with the oldest date last written is chosen. If two have the same date then the one with the lowest MediaId is chosen).
    Try recycling any purged Volumes.
    Prune volumes applying Volume retention period (Volumes with VolStatus Full, Used, or Append are pruned). Note, even if all the File and Job records are pruned from a Volume, the Volume will not be marked Purged until the Volume retention period expires.
    Search the Pool for a Volume with VolStatus=Purged
    If a Pool named ScratchDir Pool exists, search for a Volume and if found move it to the current Pool for the Job and use it. Note, when the Scratch Volume is moved into the current Pool, the basic Pool defaults are applied as if it is a newly labeled Volume (equivalent to an update volume from pool command).
    If we were looking for Volumes in the Autochanger, go back to step 2 above, but this time, look for any Volume whether or not it is in the Autochanger.
    Attempt to create a new Volume if automatic labeling enabled. If the maximum number of Volumes speciﬁed for the pool is reached, no new Volume will be created.
    Prune the oldest Volume if Recycle Oldest Volume Dir Pool=yes (the Volume with the oldest LastWritten date and VolStatus equal to Full, Recycle, Purged, Used, or Append is chosen). This record ensures that all retention periods are properly respected.
    Purge the oldest Volume if Purge Oldest Volume Dir Pool=yes (the Volume with the oldest LastWritten date and VolStatus equal to Full, Recycle, Purged, Used, or Append is chosen). Please note! We strongly recommend against the use of Purge Oldest Volume as it can quite easily lead to loss of current backup data.
    Give up and ask operator.

The above occurs when Bareos has ﬁnished writing a Volume or when no Volume is present in the drive.

On the other hand, if you have inserted a diﬀerent Volume after the last job, and Bareos recognizes the Volume as valid, it will request authorization from the Director to use this Volume. In this case, if you have set Recycle Current Volume Dir Pool = yes and the Volume is marked as Used or Full, Bareos will prune the volume and if all jobs were removed during the pruning (respecting the retention periods), the Volume will be recycled and used.

The recycling algorithm in this case is:

    If the Volume status is Append or Recycle, the volume will be used.
    If Recycle Current Volume Dir Pool = yes and the volume is marked Full or Used, Bareos will prune the volume (applying the retention period). If all Jobs are pruned from the volume, it will be recycled.

This permits users to manually change the Volume every day and load tapes in an order diﬀerent from what is in the catalog, and if the volume does not contain a current copy of your backup data, it will be used.

A few points from Alan Brown to keep in mind:

    If Maximum Volumes Dir Pool is not set, Bareos will prefer to demand new volumes over forcibly purging older volumes.
    If volumes become free through pruning and the Volume retention period has expired, then they get marked as Purged and are immediately available for recycling - these will be used in preference to creating new volumes.

#
17.3.4 Recycle Status

Each Volume inherits the Recycle status (yes or no) from the Pool resource record when the Media record is created (normally when the Volume is labeled). This Recycle status is stored in the Media record of the Catalog. Using the Console program, you may subsequently change the Recycle status for each Volume. For example in the following output from list volumes:
+----------+-------+--------+---------+------------+--------+-----+  
| VolumeNa | Media | VolSta | VolByte | LastWritte | VolRet | Rec |  
+----------+-------+--------+---------+------------+--------+-----+  
| File0001 | File  | Full   | 4190055 | 2002-05-25 | 14400  | 1   |  
| File0002 | File  | Full   | 1896460 | 2002-05-26 | 14400  | 1   |  
| File0003 | File  | Full   | 1896460 | 2002-05-26 | 14400  | 1   |  
| File0004 | File  | Full   | 1896460 | 2002-05-26 | 14400  | 1   |  
| File0005 | File  | Full   | 1896460 | 2002-05-26 | 14400  | 1   |  
| File0006 | File  | Full   | 1896460 | 2002-05-26 | 14400  | 1   |  
| File0007 | File  | Purged | 1896466 | 2002-05-26 | 14400  | 1   |  
+----------+-------+--------+---------+------------+--------+-----+

all the volumes are marked as recyclable, and the last Volume, File0007 has been purged, so it may be immediately recycled. The other volumes are all marked recyclable and when their Volume Retention period (14400 seconds or four hours) expires, they will be eligible for pruning, and possibly recycling. Even though Volume File0007 has been purged, all the data on the Volume is still recoverable. A purged Volume simply means that there are no entries in the Catalog. Even if the Volume Status is changed to Recycle, the data on the Volume will be recoverable. The data is lost only when the Volume is re-labeled and re-written.

To modify Volume File0001 so that it cannot be recycled, you use the update volume pool=File command in the console program, or simply update and Bareos will prompt you for the information.
+----------+------+-------+---------+-------------+-------+-----+  
| VolumeNa | Media| VolSta| VolByte | LastWritten | VolRet| Rec |  
+----------+------+-------+---------+-------------+-------+-----+  
| File0001 | File | Full  | 4190055 | 2002-05-25  | 14400 | 0   |  
| File0002 | File | Full  | 1897236 | 2002-05-26  | 14400 | 1   |  
| File0003 | File | Full  | 1896460 | 2002-05-26  | 14400 | 1   |  
| File0004 | File | Full  | 1896460 | 2002-05-26  | 14400 | 1   |  
| File0005 | File | Full  | 1896460 | 2002-05-26  | 14400 | 1   |  
| File0006 | File | Full  | 1896460 | 2002-05-26  | 14400 | 1   |  
| File0007 | File | Purged| 1896466 | 2002-05-26  | 14400 | 1   |  
+----------+------+-------+---------+-------------+-------+-----+

In this case, File0001 will never be automatically recycled. The same eﬀect can be achieved by setting the Volume Status to Read-Only.

As you have noted, the Volume Status (VolStatus) column in the catalog database contains the current status of the Volume, which is normally maintained automatically by Bareos. To give you an idea of some of the values it can take during the life cycle of a Volume, here is a picture created by Arno Lehmann:
A typical volume life cycle is like this:  

              because job count or size limit exceeded  
      Append  -------------------------------------->  Used/Full  
        ^                                                  |  
        | First Job writes to        Retention time passed |  
        | the volume                   and recycling takes |  
        |                                            place |  
        |                                                  v  
      Recycled <-------------------------------------- Purged  
                     Volume is selected for reuse  

#
17.3.5 Daily, Weekly, Monthly Tape Usage Example

This example is meant to show you how one could deﬁne a ﬁxed set of volumes that Bareos will rotate through on a regular schedule. There are an inﬁnite number of such schemes, all of which have various advantages and disadvantages.

We start with the following assumptions:

    A single tape has more than enough capacity to do a full save.
    There are ten tapes that are used on a daily basis for incremental backups. They are prelabeled Daily1 ... Daily10.
    There are four tapes that are used on a weekly basis for full backups. They are labeled Week1 ... Week4.
    There are 12 tapes that are used on a monthly basis for full backups. They are numbered Month1 ... Month12
    A full backup is done every Saturday evening (tape inserted Friday evening before leaving work).
    No backups are done over the weekend (this is easy to change).
    The ﬁrst Friday of each month, a Monthly tape is used for the Full backup.
    Incremental backups are done Monday - Friday (actually Tue-Fri mornings).

We start the system by doing a Full save to one of the weekly volumes or one of the monthly volumes. The next morning, we remove the tape and insert a Daily tape. Friday evening, we remove the Daily tape and insert the next tape in the Weekly series. Monday, we remove the Weekly tape and re-insert the Daily tape. On the ﬁrst Friday of the next month, we insert the next Monthly tape in the series rather than a Weekly tape, then continue. When a Daily tape ﬁnally ﬁlls up, Bareos will request the next one in the series, and the next day when you notice the email message, you will mount it and Bareos will ﬁnish the unﬁnished incremental backup.

What does this give? Well, at any point, you will have the last complete Full save plus several Incremental saves. For any given ﬁle you want to recover (or your whole system), you will have a copy of that ﬁle every day for at least the last 14 days. For older versions, you will have at least three and probably four Friday full saves of that ﬁle, and going back further, you will have a copy of that ﬁle made on the beginning of the month for at least a year.

So you have copies of any ﬁle (or your whole system) for at least a year, but as you go back in time, the time between copies increases from daily to weekly to monthly.

What would the Bareos conﬁguration look like to implement such a scheme?
Schedule {  
  Name = "NightlySave"  
  Run = Level=Full Pool=Monthly 1st sat at 03:05  
  Run = Level=Full Pool=Weekly 2nd-5th sat at 03:05  
  Run = Level=Incremental Pool=Daily tue-fri at 03:05  
}  
Job {  
  Name = "NightlySave"  
  Type = Backup  
  Level = Full  
  Client = LocalMachine  
  FileSet = "File Set"  
  Messages = Standard  
  Storage = DDS-4  
  Pool = Daily  
  Schedule = "NightlySave"  
}  
# Definition of file storage device  
Storage {  
  Name = DDS-4  
  Address = localhost  
  SDPort = 9103  
  Password = XXXXXXXXXXXXX  
  Device = FileStorage  
  Media Type = 8mm  
}  
FileSet {  
  Name = "File Set"  
  Include {  
    Options {  
      signature=MD5  
    }  
    File = fffffffffffffffff  
  }  
  Exclude  { File=*.o }  
}  
Pool {  
  Name = Daily  
  Pool Type = Backup  
  AutoPrune = yes  
  VolumeRetention = 10d   # recycle in 10 days  
  Maximum Volumes = 10  
  Recycle = yes  
}  
Pool {  
  Name = Weekly  
  Use Volume Once = yes  
  Pool Type = Backup  
  AutoPrune = yes  
  VolumeRetention = 30d  # recycle in 30 days (default)  
  Recycle = yes  
}  
Pool {  
  Name = Monthly  
  Use Volume Once = yes  
  Pool Type = Backup  
  AutoPrune = yes  
  VolumeRetention = 365d  # recycle in 1 year  
  Recycle = yes  
}

#
17.3.6 Automatic Pruning and Recycling Example

Perhaps the best way to understand the various resource records that come into play during automatic pruning and recycling is to run a Job that goes through the whole cycle. If you add the following resources to your Director’s conﬁguration ﬁle:
Schedule {  
  Name = "30 minute cycle"  
  Run = Level=Full Pool=File Messages=Standard Storage=File  
         hourly at 0:05  
  Run = Level=Full Pool=File Messages=Standard Storage=File  
         hourly at 0:35  
}  
Job {  
  Name = "Filetest"  
  Type = Backup  
  Level = Full  
  Client=XXXXXXXXXX  
  FileSet="Test Files"  
  Messages = Standard  
  Storage = File  
  Pool = File  
  Schedule = "30 minute cycle"  
}  
# Definition of file storage device  
Storage {  
  Name = File  
  Address = XXXXXXXXXXX  
  SDPort = 9103  
  Password = XXXXXXXXXXXXX  
  Device = FileStorage  
  Media Type = File  
}  
FileSet {  
  Name = "File Set"  
  Include {  
    Options {  
      signature=MD5  
    }  
    File = fffffffffffffffff  
  }  
  Exclude  { File=*.o }  
}  
Pool {  
  Name = File  
  Use Volume Once = yes  
  Pool Type = Backup  
  LabelFormat = "File"  
  AutoPrune = yes  
  VolumeRetention = 4h  
  Maximum Volumes = 12  
  Recycle = yes  
}

Where you will need to replace the ﬀﬀﬀﬀﬀ’s by the appropriate ﬁles to be saved for your conﬁguration. For the FileSet Include, choose a directory that has one or two megabytes maximum since there will probably be approximately eight copies of the directory that Bareos will cycle through.

In addition, you will need to add the following to your Storage daemon’s conﬁguration ﬁle:
Device {  
  Name = FileStorage  
  Media Type = File  
  Archive Device = /tmp  
  LabelMedia = yes;  
  Random Access = Yes;  
  AutomaticMount = yes;  
  RemovableMedia = no;  
  AlwaysOpen = no;  
}

With the above resources, Bareos will start a Job every half hour that saves a copy of the directory you chose to /tmp/File0001 ... /tmp/File0012. After 4 hours, Bareos will start recycling the backup Volumes (/tmp/File0001 ...). You should see this happening in the output produced. Bareos will automatically create the Volumes (Files) the ﬁrst time it uses them.

To turn it oﬀ, either delete all the resources you’ve added, or simply comment out the Schedule record in the Job resource.

#
17.3.7 Manually Recycling Volumes

Although automatic recycling of Volumes is implemented (see the Automatic Volume Recycling chapter of this manual), you may want to manually force reuse (recycling) of a Volume.

Assuming that you want to keep the Volume name, but you simply want to write new data on the tape, the steps to take are:

    Use the update volume command in the Console to ensure that Recycle = yes.
    Use the purge jobs volume command in the Console to mark the Volume as Purged. Check by using list volumes.

Once the Volume is marked Purged, it will be recycled the next time a Volume is needed.

If you wish to reuse the tape by giving it a new name, use the relabel instead of the purge command.

Please note! The delete command can be dangerous. Once it is done, to recover the File records, you must either restore your database as it was before the delete command or use the bscan utility program to scan the tape and recreate the database entries.

#
Chapter 18
Automated Disk Backup

If you manage ﬁve or ten machines and have a nice tape backup, you don’t need Pools, and you may wonder what they are good for. In this chapter, you will see that Pools can help you optimize disk storage space. The same techniques can be applied to a shop that has multiple tape drives, or that wants to mount various diﬀerent Volumes to meet their needs.

The rest of this chapter will give an example involving backup to disk Volumes, but most of the information applies equally well to tape Volumes.

Given is a scenario, where the size of a full backup is about 15GB.

It is required, that backup data is available for six months. Old ﬁles should be available on a daily basis for a week, a weekly basis for a month, then monthly for six months. In addition, oﬀsite capability is not needed. The daily changes amount to about 300MB on the average, or about 2GB per week.

As a consequence, the total volume of data they need to keep to meet their needs is about 100GB (15GB x 6 + 2GB x 5 + 0.3 x 7) = 102.1GB.

The chosen solution was to use a 120GB hard disk – far less than 1/10th the price of a tape drive and the cassettes to handle the same amount of data, and to have the backup software write to disk ﬁles.

The rest of this chapter will explain how to setup Bareos so that it would automatically manage a set of disk ﬁles with the minimum sysadmin intervention. #
18.1 Overall Design

Getting Bareos to write to disk rather than tape in the simplest case is rather easy.

One needs to consider about what happens if we have only a single large Bareos Volume deﬁned on our hard disk. Everything works ﬁne until the Volume ﬁlls, then Bareos will ask you to mount a new Volume. This same problem applies to the use of tape Volumes if your tape ﬁlls. Being a hard disk and the only one you have, this will be a bit of a problem. It should be obvious that it is better to use a number of smaller Volumes and arrange for Bareos to automatically recycle them so that the disk storage space can be reused.

As mentioned, the solution is to have multiple Volumes, or ﬁles on the disk. To do so, we need to limit the use and thus the size of a single Volume, by time, by number of jobs, or by size. Any of these would work, but we chose to limit the use of a single Volume by putting a single job in each Volume with the exception of Volumes containing Incremental backup where there will be 6 jobs (a week’s worth of data) per volume. The details of this will be discussed shortly. This is a single client backup, so if you have multiple clients you will need to multiply those numbers by the number of clients, or use a diﬀerent system for switching volumes, such as limiting the volume size.

TODO: This chapter will get rewritten. Instead of limiting a Volume to one job, we will utilize Max Use Duration = 24 hours. This prevents problems when adding more clients, because otherwise each job has to run seperat.

The next problem to resolve is recycling of Volumes. As you noted from above, the requirements are to be able to restore monthly for 6 months, weekly for a month, and daily for a week. So to simplify things, why not do a Full save once a month, a Diﬀerential save once a week, and Incremental saves daily. Now since each of these diﬀerent kinds of saves needs to remain valid for diﬀering periods, the simplest way to do this (and possibly the only) is to have a separate Pool for each backup type.

The decision was to use three Pools: one for Full saves, one for Diﬀerential saves, and one for Incremental saves, and each would have a diﬀerent number of volumes and a diﬀerent Retention period to accomplish the requirements.

#
18.1.1 Full Pool

Putting a single Full backup on each Volume, will require six Full save Volumes, and a retention period of six months. The Pool needed to do that is:


Pool {
  Name = Full-Pool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 6 months
  Maximum Volume Jobs = 1
  Label Format = Full-
  Maximum Volumes = 9
}


Conﬁguration 18.1: Full-Pool

Since these are disk Volumes, no space is lost by having separate Volumes for each backup (done once a month in this case). The items to note are the retention period of six months (i.e. they are recycled after six months), that there is one job per volume (Maximum Volume Jobs = 1), the volumes will be labeled Full-0001, ... Full-0006 automatically. One could have labeled these manually from the start, but why not use the features of Bareos.

Six months after the ﬁrst volume is used, it will be subject to pruning and thus recycling, so with a maximum of 9 volumes, there should always be 3 volumes available (note, they may all be marked used, but they will be marked purged and recycled as needed).

If you have two clients, you would want to set Maximum Volume Jobs to 2 instead of one, or set a limit on the size of the Volumes, and possibly increase the maximum number of Volumes.

#
18.1.2 Diﬀerential Pool

For the Diﬀerential backup Pool, we choose a retention period of a bit longer than a month and ensure that there is at least one Volume for each of the maximum of ﬁve weeks in a month. So the following works:


Pool {
  Name = Diff-Pool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 40 days
  Maximum Volume Jobs = 1
  Label Format = Diff-
  Maximum Volumes = 10
}


Conﬁguration 18.2: Diﬀerential Pool

As you can see, the Diﬀerential Pool can grow to a maximum of 9 volumes, and the Volumes are retained 40 days and thereafter they can be recycled. Finally there is one job per volume. This, of course, could be tightened up a lot, but the expense here is a few GB which is not too serious.

If a new volume is used every week, after 40 days, one will have used 7 volumes, and there should then always be 3 volumes that can be purged and recycled.

See the discussion above concering the Full pool for how to handle multiple clients.

#
18.1.3 Incremental Pool

Finally, here is the resource for the Incremental Pool:


Pool {
  Name = Inc-Pool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 20 days
  Maximum Volume Jobs = 6
  Label Format = Inc-
  Maximum Volumes = 7
}


Conﬁguration 18.3: Incremental Pool

We keep the data for 20 days rather than just a week as the needs require. To reduce the proliferation of volume names, we keep a week’s worth of data (6 incremental backups) in each Volume. In practice, the retention period should be set to just a bit more than a week and keep only two or three volumes instead of ﬁve. Again, the lost is very little and as the system reaches the full steady state, we can adjust these values so that the total disk usage doesn’t exceed the disk capacity.

If you have two clients, the simplest thing to do is to increase the maximum volume jobs from 6 to 12. As mentioned above, it is also possible limit the size of the volumes. However, in that case, you will need to have a better idea of the volume or add suﬃcient volumes to the pool so that you will be assured that in the next cycle (after 20 days) there is at least one volume that is pruned and can be recycled.

#
18.2 Conﬁguration Files

The following example shows you the actual ﬁles used, with only a few minor modiﬁcations to simplify things.

The Director’s conﬁguration ﬁle is as follows:


Director {          # define myself
  Name = bareos-dir
  QueryFile = "/usr/lib/bareos/scripts/query.sql"
  Maximum Concurrent Jobs = 1
  Password = "*** CHANGE ME ***"
  Messages = Standard
}

JobDefs {
  Name = "DefaultJob"
  Type = Backup
  Level = Incremental
  Client = bareos-fd
  FileSet = "Full Set"
  Schedule = "WeeklyCycle"
  Storage = File
  Messages = Standard
  Pool = Inc-Pool
  Full Backup Pool = Full-Pool
  Incremental Backup Pool = Inc-Pool
  Differential Backup Pool = Diff-Pool
  Priority = 10
  Write Bootstrap = "/var/lib/bareos/%c.bsr"
}

Job {
  Name = client
  Client = client-fd
  JobDefs = "DefaultJob"
  FileSet = "Full Set"
}

# Backup the catalog database (after the nightly save)
Job {
  Name = "BackupCatalog"
  Client = client-fd
  JobDefs = "DefaultJob"
  Level = Full
  FileSet="Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  # This creates an ASCII copy of the catalog
  # Arguments to make_catalog_backup.pl are:
  #  make_catalog_backup.pl <catalog-name>
  RunBeforeJob = "/usr/lib/bareos/scripts/make_catalog_backup.pl MyCatalog"
  # This deletes the copy of the catalog
  RunAfterJob  = "/usr/lib/bareos/scripts/delete_catalog_backup"
  # This sends the bootstrap via mail for disaster recovery.
  # Should be sent to another system, please change recipient accordingly
  Write Bootstrap = "|/usr/sbin/bsmtp -h localhost -f \"\(Bareos\) \" -s \"Bootstrap for Job %j\" root@localhost"
  Priority = 11                   # run after main backup
}

# Standard Restore template, to be changed by Console program
Job {
  Name = "RestoreFiles"
  Type = Restore
  Client = client-fd
  FileSet="Full Set"
  Storage = File
  Messages = Standard
  Pool = Default
  Where = /tmp/bareos-restores
}

# List of files to be backed up
FileSet {
  Name = "Full Set"
  Include = {
    Options {
      signature=SHA1;
      compression=GZIP9
    }
    File = /
    File = /usr
    File = /home
    File = /boot
    File = /var
    File = /opt
  }
  Exclude = {
    File = /proc
    File = /tmp
    File = /.journal
    File = /.fsck
    ...
  }
}

Schedule {
  Name = "WeeklyCycle"
  Run = Level=Full 1st sun at 2:05
  Run = Level=Differential 2nd-5th sun at 2:05
  Run = Level=Incremental mon-sat at 2:05
}

# This schedule does the catalog. It starts after the WeeklyCycle
Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Level=Full sun-sat at 2:10
}

# This is the backup of the catalog
FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
    }
    File = "/var/lib/bareos/bareos.sql" # database dump
    File = "/etc/bareos"                # configuration
  }
}

Client {
  Name = client-fd
  Address = client
  FDPort = 9102
  Password = " *** CHANGE ME ***"
  AutoPrune = yes      # Prune expired Jobs/Files
  Job Retention = 6 months
  File Retention = 60 days
}

Storage {
  Name = File
  Address = localhost
  Password = " *** CHANGE ME ***"
  Device = FileStorage
  Media Type = File
}

Catalog {
  Name = MyCatalog
  dbname = bareos; user = bareos; password = ""
}

Pool {
  Name = Full-Pool
  Pool Type = Backup
  Recycle = yes           # automatically recycle Volumes
  AutoPrune = yes         # Prune expired volumes
  Volume Retention = 6 months
  Maximum Volume Jobs = 1
  Label Format = Full-
  Maximum Volumes = 9
}

Pool {
  Name = Inc-Pool
  Pool Type = Backup
  Recycle = yes           # automatically recycle Volumes
  AutoPrune = yes         # Prune expired volumes
  Volume Retention = 20 days
  Maximum Volume Jobs = 6
  Label Format = Inc-
  Maximum Volumes = 7
}

Pool {
  Name = Diff-Pool
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 40 days
  Maximum Volume Jobs = 1
  Label Format = Diff-
  Maximum Volumes = 10
}

Messages {
  Name = Standard
  mailcommand = "bsmtp -h mail.domain.com -f \"\(Bareos\) %r\"
      -s \"Bareos: %t %e of %c %l\" %r"
  operatorcommand = "bsmtp -h mail.domain.com -f \"\(Bareos\) %r\"
      -s \"Bareos: Intervention needed for %j\" %r"
  mail = root@domain.com = all, !skipped
  operator = root@domain.com = mount
  console = all, !skipped, !saved
  append = "/home/bareos/bin/log" = all, !skipped
}


Conﬁguration 18.4: bareos-dir.conf

and the Storage daemon’s conﬁguration ﬁle is:


Storage {               # definition of myself
  Name = bareos-sd
}

Director {
  Name = bareos-dir
  Password = " *** CHANGE ME ***"
}

Device {
  Name = FileStorage
  Media Type = File
  Archive Device = /var/lib/bareos/storage
  LabelMedia = yes;    # lets Bareos label unlabeled media
  Random Access = yes;
  AutomaticMount = yes;   # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
}

Messages {
  Name = Standard
  director = bareos-dir = all
}


Conﬁguration 18.5: bareos-sd.conf

#
Chapter 19
Autochanger Support

Bareos provides autochanger support for reading and writing tapes. In order to work with an autochanger, Bareos requires a number of things, each of which is explained in more detail after this list:

    The package bareos-storage-tape must be installed.
    A script that actually controls the autochanger according to commands sent by Bareos. Bareos contains the script mtx-changer, that utilize the command mtx. It’s conﬁg ﬁle is normally located at /etc/bareos/mtx-changer.conf
    That each Volume (tape) to be used must be deﬁned in the Catalog and have a Slot number assigned to it so that Bareos knows where the Volume is in the autochanger. This is generally done with the label command, but can also done after the tape is labeled using the update slots command. See below for more details. You must pre-label the tapes manually before using them.
    Modiﬁcations to your Storage daemon’s Device conﬁguration resource to identify that the device is a changer, as well as a few other parameters.
    You should also modify your Storage resource deﬁnition in the Director’s conﬁguration ﬁle so that you are automatically prompted for the Slot when labeling a Volume.
    You need to ensure that your Storage daemon has access permissions to both the tape drive and the control device. On Linux, the system user bareos is added to the groups disk and tape, so that it should have the permission to access the library.
    You need to have Autochanger = yes in your Storage resource in your bareos-dir.conf ﬁle so that you will be prompted for the slot number when you label Volumes.

Bareos uses its own mtx-changer script to interface with a program that actually does the tape changing. Thus in principle, mtx-changer can be adapted to function with any autochanger program, or you can call any other script or program. The current version of mtx-changer works with the mtx program. FreeBSD users might need to adapt this script to use chio. For more details, refer to the Testing Autochanger chapter.

Bareos also supports autochangers with barcode readers. This support includes two Console commands: label barcodes and update slots. For more details on these commands, see the chapter about Barcode Support.

Current Bareos autochanger support does not include cleaning, stackers, or silos. Stackers and silos are not supported because Bareos expects to be able to access the Slots randomly. However, if you are very careful to setup Bareos to access the Volumes in the autochanger sequentially, you may be able to make Bareos work with stackers (gravity feed and such).

In principle, if mtx will operate your changer correctly, then it is just a question of adapting the mtx-changer script (or selecting one already adapted) for proper interfacing.

If you are having troubles, please use the auto command in the btape program to test the functioning of your autochanger with Bareos. Please remember, that on most distributions, the Storage daemon runs as user bareos and not as root. You will need to ensure that the Storage daemon has suﬃcient permissions to access the autochanger.

Some users have reported that the the Storage daemon blocks under certain circumstances in trying to mount a volume on a drive that has a diﬀerent volume loaded. As best we can determine, this is simply a matter of waiting a bit. The drive was previously in use writing a Volume, and sometimes the drive will remain BLOCKED for a good deal of time (up to 7 minutes on a slow drive) waiting for the cassette to rewind and to unload before the drive can be used with a diﬀerent Volume. #
19.1 Knowing What SCSI Devices You Have

#
19.1.1 Linux

Under Linux, you can
cat /proc/scsi/scsi

to see what SCSI devices you have available. You can also:
cat /proc/scsi/sg/device_hdr /proc/scsi/sg/devices

to ﬁnd out how to specify their control address (/dev/sg0 for the ﬁrst, /dev/sg1 for the second, ...) on the Changer Device = Bareos directive.

You can also use the excellent lsscsi tool.
$ lsscsi -g  
 [1:0:2:0]    tape    SEAGATE  ULTRIUM06242-XXX 1619  /dev/st0  /dev/sg9  
 [1:0:14:0]   mediumx STK      L180             0315  /dev/sch0 /dev/sg10  
 [2:0:3:0]    tape    HP       Ultrium 3-SCSI   G24S  /dev/st1  /dev/sg11  
 [3:0:0:0]    enclosu HP       A6255A           HP04  -         /dev/sg3  
 [3:0:1:0]    disk    HP 36.4G ST336753FC       HP00  /dev/sdd  /dev/sg4

#
19.1.2 FreeBSD

Under FreeBSD, use the following command to list the SCSI devices as well as the /dev/passn that you will use on the Bareos Changer Device = directive:
camcontrol devlist

Please check that your Storage daemon has permission to access this device.

The following tip for FreeBSD users comes from Danny Butroyd: on reboot Bareos will NOT have permission to control the device /dev/pass0 (assuming this is your changer device). To get around this just edit the /etc/devfs.conf ﬁle and add the following to the bottom:
own     pass0   root:bareos  
perm    pass0   0666  
own     nsa0.0  root:bareos  
perm    nsa0.0    0666

This gives the bareos group permission to write to the nsa0.0 device too just to be on the safe side. To bring these changes into eﬀect just run:-

/etc/rc.d/devfs restart

Basically this will stop you having to manually change permissions on these devices to make Bareos work when operating the AutoChanger after a reboot.

#
19.2 Slots

To properly address autochangers, Bareos must know which Volume is in each slot of the autochanger. Slots are where the changer cartridges reside when not loaded into the drive. Bareos numbers these slots from one to the number of cartridges contained in the autochanger.

Bareos will not automatically use a Volume in your autochanger unless it is labeled and the slot number is stored in the catalog and the Volume is marked as InChanger. This is because it must know where each volume is to be able to load the volume. For each Volume in your changer, you will, using the Console program, assign a slot. This information is kept in Bareos’s catalog database along with the other data for the volume. If no slot is given, or the slot is set to zero, Bareos will not attempt to use the autochanger even if all the necessary conﬁguration records are present. When doing a mount command on an autochanger, you must specify which slot you want mounted. If the drive is loaded with a tape from another slot, it will unload it and load the correct tape, but normally, no tape will be loaded because an unmount command causes Bareos to unload the tape in the drive.

You can check if the Slot number and InChanger ﬂag are set by doing a:
list Volumes

in the Console program.

#
19.3 Multiple Devices

Some autochangers have more than one read/write device (drive). The Autochanger resource permits you to group Device resources, where each device represents a drive. The Director may still reference the Devices (drives) directly, but doing so, bypasses the proper functioning of the drives together. Instead, the Director (in the Storage resource) should reference the Autochanger resource name. Doing so permits the Storage daemon to ensure that only one drive uses the mtx-changer script at a time, and also that two drives don’t reference the same Volume.

Multi-drive requires the use of the Drive Index directive in the Device resource of the Storage daemon’s conﬁguration ﬁle. Drive numbers or the Device Index are numbered beginning at zero, which is the default. To use the second Drive in an autochanger, you need to deﬁne a second Device resource and set the Drive Index to 1 for that device. In general, the second device will have the same Changer Device (control channel) as the ﬁrst drive, but a diﬀerent Archive Device.

As a default, Bareos jobs will prefer to write to a Volume that is already mounted. If you have a multiple drive autochanger and you want Bareos to write to more than one Volume in the same Pool at the same time, you will need to set Prefer Mounted Volumes Dir Job in the Directors Job resource to no. This will cause the Storage daemon to maximize the use of drives.

#
19.4 Device Conﬁguration Records

Conﬁguration of autochangers within Bareos is done in the Device resource of the Storage daemon. Four records: Autochanger, Changer Device, Changer Command, and Maximum Changer Wait control how Bareos uses the autochanger.

These four records, permitted in Device resources, are described in detail below. Note, however, that the Changer Device and the Changer Command directives are not needed in the Device resource if they are present in the Autochanger resource.

Autochanger = <yes | no>
    (default: no)
    The Autochanger record speciﬁes if the current device belongs to an autochanger resource.  
Changer Device = <device-name>
    In addition to the Archive Device name, you must specify a Changer Device name. This is because most autochangers are controlled through a diﬀerent device than is used for reading and writing the cartridges. For example, on Linux, one normally uses the generic SCSI interface for controlling the autochanger, but the standard SCSI interface for reading and writing the tapes. On Linux, for the Archive Device = /dev/nst0, you would typically have Changer Device = /dev/sg0. Note, some of the more advanced autochangers will locate the changer device on /dev/sg1. Such devices typically have several drives and a large number of tapes.

    On FreeBSD systems, the changer device will typically be on /dev/pass0 through /dev/passN.
    
    On Solaris, the changer device will typically be some ﬁle under /dev/rdsk.
    
    Please ensure that your Storage daemon has permission to access this device.
Changer Command = <command>
    This record is used to specify the external program to call and what arguments to pass to it. The command is assumed to be a standard program or shell script that can be executed by the operating system. This command is invoked each time that Bareos wishes to manipulate the autochanger. The following substitutions are made in the command before it is sent to the operating system for execution:
          %% = %  
          %a = archive device name  
          %c = changer device name  
          %d = changer drive index base 0  
          %f = Client’s name  
          %j = Job name  
          %o = command  (loaded, load, or unload)  
          %s = Slot base 0  
          %S = Slot base 1  
          %v = Volume name

    An actual example for using mtx with the mtx-changer script (part of the Bareos distribution) is:
    Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
    
    Details of the three commands currently used by Bareos (loaded, load, unload) as well as the output expected by Bareos are given in the Bareos Autochanger Interface section.
Maximum Changer Wait = <time>
    This record is used to deﬁne the maximum amount of time that Bareos will wait for an autoloader to respond to a command (e.g. load). The default is set to 120 seconds. If you have a slow autoloader you may want to set it longer.

    If the autoloader program fails to respond in this time, it will be killed and Bareos will request operator intervention.
Drive Index = <number>
    This record allows you to tell Bareos to use the second or subsequent drive in an autochanger with multiple drives. Since the drives are numbered from zero, the second drive is deﬁned by
    Device Index = 1  

    To use the second drive, you need a second Device resource deﬁnition in the Bareos conﬁguration ﬁle. See the Multiple Drive section above in this chapter for more information.

In addition, for proper functioning of the Autochanger, you must deﬁne an Autochanger resource.

#
19.5 An Example Conﬁguration File

The following two resources implement an autochanger:
Autochanger {  
  Name = Autochanger  
  Device = DDS-4  
  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"  
  Changer Device = /dev/sg0  
}  

Device {  
  Name = DDS-4  
  Media Type = DDS-4  
  Archive Device = /dev/nst0    # Normal archive device  
  Autochanger = yes  
  LabelMedia = no;  
  AutomaticMount = yes;  
  AlwaysOpen = yes;  
}

where you will adapt the Archive Device, the Changer Device, and the path to the Changer Command to correspond to the values used on your system.

#
19.6 A Multi-drive Example Conﬁguration File

The following resources implement a multi-drive autochanger:
Autochanger {  
  Name = Autochanger  
  Device = Drive-0  
  Device = Drive-1  
  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"  
  Changer Device = /dev/sg0  
}  

Device {  
  Name = Drive-0  
  Drive Index = 0  
  Media Type = DDS-4  
  Archive Device = /dev/nst0    # Normal archive device  
  Autochanger = yes  
  LabelMedia = no;  
  AutomaticMount = yes;  
  AlwaysOpen = yes;  
}  

Device {  
  Name = Drive-1  
  Drive Index = 1  
  Media Type = DDS-4  
  Archive Device = /dev/nst1    # Normal archive device  
  Autochanger = yes  
  LabelMedia = no;  
  AutomaticMount = yes;  
  AlwaysOpen = yes;  
}

where you will adapt the Archive Device and the Changer Device to correspond to the values used on your system.

#
19.7 Specifying Slots When Labeling

If you add an Autochanger = yes record to the Storage resource in your Director’s conﬁguration ﬁle, the Bareos Console will automatically prompt you for the slot number when the Volume is in the changer when you add or label tapes for that Storage device. If your mtx-changer script is properly installed, Bareos will automatically load the correct tape during the label command.

You must also set Autochanger = yes in the Storage daemon’s Device resource as we have described above in order for the autochanger to be used. Please see the Auto Changer Dir Storage in the Director’s chapter and the Autochanger Sd Device in the Storage daemon chapter for more details on these records.

Thus all stages of dealing with tapes can be totally automated. It is also possible to set or change the Slot using the update command in the Console and selecting Volume Parameters to update.

Even though all the above conﬁguration statements are speciﬁed and correct, Bareos will attempt to access the autochanger only if a slot is non-zero in the catalog Volume record (with the Volume name).

If your autochanger has barcode labels, you can label all the Volumes in your autochanger one after another by using the label barcodes command. For each tape in the changer containing a barcode, Bareos will mount the tape and then label it with the same name as the barcode. An appropriate Media record will also be created in the catalog. Any barcode that begins with the same characters as speciﬁed on the ”CleaningPreﬁx=xxx” command, will be treated as a cleaning tape, and will not be labeled. For example with:
Pool {  
  Name ...  
  Cleaning Prefix = "CLN"  
}

Any slot containing a barcode of CLNxxxx will be treated as a cleaning tape and will not be mounted.

#
19.8 Changing Cartridges

If you wish to insert or remove cartridges in your autochanger or you manually run the mtx program, you must ﬁrst tell Bareos to release the autochanger by doing:
unmount  
(change cartridges and/or run mtx)  
mount

If you do not do the unmount before making such a change, Bareos will become completely confused about what is in the autochanger and may stop function because it expects to have exclusive use of the autochanger while it has the drive mounted.

#
19.9 Dealing with Multiple Magazines

If you have several magazines or if you insert or remove cartridges from a magazine, you should notify Bareos of this. By doing so, Bareos will as a preference, use Volumes that it knows to be in the autochanger before accessing Volumes that are not in the autochanger. This prevents unneeded operator intervention.

If your autochanger has barcodes (machine readable tape labels), the task of informing Bareos is simple. Every time, you change a magazine, or add or remove a cartridge from the magazine, simply use following commands in the Console program:
unmount  
(remove magazine)  
(insert new magazine)  
update slots  
mount

This will cause Bareos to request the autochanger to return the current Volume names in the magazine. This will be done without actually accessing or reading the Volumes because the barcode reader does this during inventory when the autochanger is ﬁrst turned on. Bareos will ensure that any Volumes that are currently marked as being in the magazine are marked as no longer in the magazine, and the new list of Volumes will be marked as being in the magazine. In addition, the Slot numbers of the Volumes will be corrected in Bareos’s catalog if they are incorrect (added or moved).

If you do not have a barcode reader on your autochanger, you have several alternatives.

    You can manually set the Slot and InChanger ﬂag using the update volume command in the Console (quite painful).
    You can issue a
    update slots scan
    
    command that will cause Bareos to read the label on each of the cartridges in the magazine in turn and update the information (Slot, InChanger ﬂag) in the catalog. This is quite eﬀective but does take time to load each cartridge into the drive in turn and read the Volume label.

#
19.10 Update Slots Command

If you change only one cartridge in the magazine, you may not want to scan all Volumes, so the update slots command (as well as the update slots scan command) has the additional form:
update slots=n1,n2,n3-n4, ...

where the keyword scan can be appended or not. The n1,n2, ... represent Slot numbers to be updated and the form n3-n4 represents a range of Slot numbers to be updated (e.g. 4-7 will update Slots 4,5,6, and 7).

This form is particularly useful if you want to do a scan (time expensive) and restrict the update to one or two slots.

For example, the command:
update slots=1,6 scan

will cause Bareos to load the Volume in Slot 1, read its Volume label and update the Catalog. It will do the same for the Volume in Slot 6. The command:
update slots=1-3,6

will read the barcoded Volume names for slots 1,2,3 and 6 and make the appropriate updates in the Catalog. If you don’t have a barcode reader the above command will not ﬁnd any Volume names so will do nothing.

#
19.11 Using the Autochanger

Let’s assume that you have properly deﬁned the necessary Storage daemon Device records, and you have added the Autochanger = yes record to the Storage resource in your Director’s conﬁguration ﬁle.

Now you ﬁll your autochanger with say six blank tapes.

What do you do to make Bareos access those tapes?

One strategy is to prelabel each of the tapes. Do so by starting Bareos, then with the Console program, enter the label command:
./bconsole  
Connecting to Director rufus:8101  
1000 OK: rufus-dir Version: 1.26 (4 October 2002)  
*label

it will then print something like:
Using default Catalog name=BackupDB DB=bareos  
The defined Storage resources are:  
     1: Autochanger  
     2: File  
Select Storage resource (1-2): 1

I select the autochanger (1), and it prints:
Enter new Volume name: TestVolume1  
Enter slot (0 for none): 1

where I entered TestVolume1 for the tape name, and slot 1 for the slot. It then asks:
Defined Pools:  
     1: Default  
     2: File  
Select the Pool (1-2): 1

I select the Default pool. This will be automatically done if you only have a single pool, then Bareos will proceed to unload any loaded volume, load the volume in slot 1 and label it. In this example, nothing was in the drive, so it printed:
Connecting to Storage daemon Autochanger at localhost:9103 ...  
Sending label command ...  
3903 Issuing autochanger "load slot 1" command.  
3000 OK label. Volume=TestVolume1 Device=/dev/nst0  
Media record for Volume=TestVolume1 successfully created.  
Requesting mount Autochanger ...  
3001 Device /dev/nst0 is mounted with Volume TestVolume1  
You have messages.  
*

You may then proceed to label the other volumes. The messages will change slightly because Bareos will unload the volume (just labeled TestVolume1) before loading the next volume to be labeled.

Once all your Volumes are labeled, Bareos will automatically load them as they are needed.

To ”see” how you have labeled your Volumes, simply enter the list volumes command from the Console program, which should print something like the following:
*{\bf list volumes}  
Using default Catalog name=BackupDB DB=bareos  
Defined Pools:  
     1: Default  
     2: File  
Select the Pool (1-2): 1  
+-------+----------+--------+---------+-------+--------+----------+-------+------+  
| MedId | VolName  | MedTyp | VolStat | Bites | LstWrt | VolReten | Recyc | Slot |  
+-------+----------+--------+---------+-------+--------+----------+-------+------+  
| 1     | TestVol1 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 1    |  
| 2     | TestVol2 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 2    |  
| 3     | TestVol3 | DDS-4  | Append  | 0     | 0      | 30672000 | 0     | 3    |  
| ...                                                                            |  
+-------+----------+--------+---------+-------+--------+----------+-------+------+

#
19.12 Barcode Support

Bareos provides barcode support with two Console commands, label barcodes and update slots.

The label barcodes will cause Bareos to read the barcodes of all the cassettes that are currently installed in the magazine (cassette holder) using the mtx-changer list command. Each cassette is mounted in turn and labeled with the same Volume name as the barcode.

The update slots command will ﬁrst obtain the list of cassettes and their barcodes from mtx-changer. Then it will ﬁnd each volume in turn in the catalog database corresponding to the barcodes and set its Slot to correspond to the value just read. If the Volume is not in the catalog, then nothing will be done. This command is useful for synchronizing Bareos with the current magazine in case you have changed magazines or in case you have moved cassettes from one slot to another. If the autochanger is empty, nothing will be done.

The Cleaning Preﬁx statement can be used in the Pool resource to deﬁne a Volume name preﬁx, which if it matches that of the Volume (barcode) will cause that Volume to be marked with a VolStatus of Cleaning. This will prevent Bareos from attempting to write on the Volume.

#
19.13 Use bconsole to display Autochanger content

The status slots storage=xxx command displays autochanger content.
 Slot |  Volume Name    |  Status  |      Type         |    Pool        |  Loaded |  
------+-----------------+----------+-------------------+----------------+---------|  
    1 |           00001 |   Append |  DiskChangerMedia |        Default |    0    |  
    2 |           00002 |   Append |  DiskChangerMedia |        Default |    0    |  
    3*|           00003 |   Append |  DiskChangerMedia |        Scratch |    0    |  
    4 |                 |          |                   |                |    0    |

If you see a * near the slot number, you have to run update slots command to synchronize autochanger content with your catalog.

#
19.14 Bareos Autochanger Interface

Bareos calls the autochanger script that you specify on the Changer Command statement. Normally this script will be the mtx-changer script that we provide, but it can in fact be any program. The only requirement for the script is that it must understand the commands that Bareos uses, which are loaded, load, unload, list, and slots. In addition, each of those commands must return the information in the precise format as speciﬁed below:
- Currently the changer commands used are:  
    loaded -- returns number of the slot that is loaded, base 1,  
              in the drive or 0 if the drive is empty.  
    load   -- loads a specified slot (note, some autochangers  
              require a 30 second pause after this command) into  
              the drive.  
    unload -- unloads the device (returns cassette to its slot).  
    list   -- returns one line for each cassette in the autochanger  
              in the format <slot>:<barcode>. Where  
              the {\bf slot} is the non-zero integer representing  
              the slot number, and {\bf barcode} is the barcode  
              associated with the cassette if it exists and if you  
              autoloader supports barcodes. Otherwise the barcode  
              field is blank.  
    slots  -- returns total number of slots in the autochanger.

Bareos checks the exit status of the program called, and if it is zero, the data is accepted. If the exit status is non-zero, Bareos will print an error message and request the tape be manually mounted on the drive.

#
19.15 Tapespeed and blocksizes

The Bareos Whitepaper Tape Speed Tuning shows that the two parameters Maximum File Size and Maximum Block Size of the device have signiﬁcant inﬂuence on the tape speed.

While it is no problem to change the Maximum File Size Sd Device parameter, unfortunately it is not possible to change the Maximum Block Size Sd Device parameter, because the previously written tapes would become unreadable in the new setup. It would require that the Maximum Block Size Sd Device parameter is switched back to the old value to be able to read the old volumes, but of course then the new volumes would be unreadable.

Why is that the case?

The problem is that Bareos writes the label block (header) in the same block size that is conﬁgured in the Maximum Block Size Sd Device parameter in the device. Per default, this value is 63k, so usually a tape written by Bareos looks like this:
|-------------------  
|label block  (63k)|  
|-------------------  
|data block  1(63k)|  
|data block  2(63k)|  
|...               |  
|data block  n(63k)|  
--------------------

Setting the maximum block size to e.g. 512k, would lead to the following:
|-------------------  
|label block (512k)|  
|-------------------  
|data block 1(512k)|  
|data block 2(512k)|  
|...               |  
|data block n(512k)|  
--------------------

As you can see, every block is written with the maximum block size, also the label block.

The problem that arises here is that reading a block header with a wrong block size causes a read error which is interpreted as an non-existent label by Bareos.

This is a potential source of data loss, because in normal operation, Bareos refuses to relabel an already labeled volume to be sure to not overwrite data that is still needed. If Bareos cannot read the volume label, this security mechanism does not work and you might label tapes already labeled accidentally.

To solve this problem, the block size handling was changed in Bareos Version >= 14.2.0 in the following way:

    The tape label block is always written in the standard 63k (64512) block size.
    The following blocks are then written in the block size conﬁgured in the Maximum Block Size directive.
    To be able to change the block size in an existing environment, it is now possible to set the Maximum Block Size Dir Pool and Minimum Block Size Dir Pool in the pool resource. This setting is automatically promoted to each medium in that pool as usual (i.e. when a medium is labeled for that pool or if a volume is transferred to that pool from the scratch pool). When a volume is mounted, the volume’s block size is used to write and read the data blocks that follow the header block.

The following picture shows the result:
|--------------------------------|  
|label block (label block size)  |
|--------------------------------|
|data block 1(maximum block size)|
|data block 2(maximum block size)|
|...                             |
|data block n(maximum block size)|
---------------------------------|

We have a label block with a certain size (63k per default to be compatible to old installations), and the following data blocks are written with another blocksize.

This approach has the following advantages:

    If nothing is conﬁgured, existing installations keep on working without problems.
    If you want to switch an existing installation that uses the default block size and move to a new (usually bigger) block size, you can do that easily by creating a new pool, where Maximum Block Size Dir Pool is set to the new value that you wish to use in the future:


Pool {
   Name = LTO-4-1M
      Pool Type = Backup
      Recycle = yes                       # Bareos can automatically recycle Volumes
      AutoPrune = yes                     # Prune expired volumes
      Volume Retention = 1 Month          # How long should the Full Backups be kept? (#06)
      Maximum Block Size = 1048576
      Recycle Pool = Scratch
}


Conﬁguration 19.1: Pool Ressource: setting Maximum Block Size

Now conﬁgure your backups that they will write into the newly deﬁned pool in the future, and your backups will be written with the new block size.

Your existing tapes can be automatically transferred to the new pool when they expire via the Scratch Pool mechanism. When a tape in your old pool expires, it is transferred to the scratch pool if you set Recycle Pool = Scratch. When your new pool needs a new volume, it will get it from the scratch pool and apply the new pool’s properties to that tape which also include Maximum Block Size Dir Pool and Minimum Block Size Dir Pool.

This way you can smoothly switch your tapes to a new block size while you can still restore the data on your old tapes at any time.

Possible Problems

There is only one case where the new block handling will cause problems, and this is if you have used bigger block sizes already in your setup. As we now deﬁned the label block to always be 63k, all labels will not be readable.

To also solve this problem, the directive Label Block Size Sd Device can be used to deﬁne a diﬀerent label block size. That way, everything should work smoothly as all label blocks will be readable again.

How can I ﬁnd out which block size was used when the tape was written?

At least on Linux, you can see if Bareos tries to read the blocks with the wrong block size. In that case, you get a kernel message like the following in your system’s messages:
[542132.410170] st1: Failed to read 1048576 byte block with 64512 byte transfer.

Here, the block was written with 1M block size but we only read 64k.

Direct access to Volumes with with non-default block sizes

bls and bextract can directly access Bareos volumes without catalog database. This means that these programs don’t have information about the used block size.

To be able to read a volume written with an arbitrary block size, you need to set the Label Block Size Sd Device (to be able to to read the label block) and the Maximum Block Size Sd Device (to be able to read the data blocks) setting in the device deﬁnition used by those tools to be able to open the medium.

Example using bls with a tape that was written with another blocksize than the DEFAULT_BLOCK_SIZE (63k), but with the default label block size of 63k:


root@linux:~#
bls FC−Drive−1 −V A00007L4
bls: butil.c:289-0 Using device: "FC-Drive-1" for reading.
25-Feb 12:47 bls JobId 0: No slot defined in catalog (slot=0) for Volume "A00007L4" on "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:47 bls JobId 0: Cartridge change or "update slots" may be required.
25-Feb 12:47 bls JobId 0: Ready to read from volume "A00007L4" on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:47 bls JobId 0: Error: block.c:1004 Read error on fd=3 at file:blk 0:1 on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst). ERR=Cannot allocate memory.
 Bareos status: file=0 block=1
 Device status: ONLINE IM_REP_EN file=0 block=2
0 files found.


Commands 19.2: bls with non-default block size

As can be seen, bls manages to read the label block as it knows what volume is mounted (Ready to read from volume A00007L4), but fails to read the data blocks.


root@linux:~#
dmesg
[...]
st2: Failed to read 131072 byte block with 64512 byte transfer.
[...]


Commands 19.3: dmesg

This shows that the block size for the data blocks that we need is 131072.

Now we have to set this block size in the bareos-sd.conf, device resource as Maximum Block Size Sd Device:


Device {
  Name = FC-Drive-1
  Drive Index = 0
  Media Type = LTO-4
  Archive Device = /dev/tape/by-id/scsi-350011d00018a5f03-nst
  AutomaticMount = yes
  AlwaysOpen = yes
  RemovableMedia = yes
  RandomAccess = no
  AutoChanger = yes
  Maximum Block Size = 131072
}


Conﬁguration 19.4: Storage Device Resource: setting Maximum Block Size

Now we can call bls again, and everything works as expected:


root@linux:~#
bls FC−Drive−1 −V A00007L4
bls: butil.c:289-0 Using device: "FC-Drive-1" for reading.
25-Feb 12:49 bls JobId 0: No slot defined in catalog (slot=0) for Volume "A00007L4" on "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
25-Feb 12:49 bls JobId 0: Cartridge change or "update slots" may be required.
25-Feb 12:49 bls JobId 0: Ready to read from volume "A00007L4" on device "FC-Drive-1" (/dev/tape/by-id/scsi-350011d00018a5f03-nst).
bls JobId 203: [...]


Commands 19.5: bls with non-default block size

How to conﬁgure the block sizes in your environment

The following chart shows how to set the directives for maximum block size and label block size depending on how your current setup is:

pict

#
Chapter 20
Using Tape Drives without Autochanger

Although Recycling and Backing Up to Disk Volume have been discussed in previous chapters, this chapter is meant to give you an overall view of possible backup strategies and to explain their advantages and disadvantages. #
20.1 Simple One Tape Backup

Probably the simplest strategy is to back everything up to a single tape and insert a new (or recycled) tape when it ﬁlls and Bareos requests a new one.

#
20.1.1 Advantages

    The operator intervenes only when a tape change is needed (e.g. once a month).
    There is little chance of operator error because the tape is not changed daily.
    A minimum number of tapes will be needed for a full restore. Typically the best case will be one tape and worst two.
    You can easily arrange for the Full backup to occur a diﬀerent night of the month for each system, thus load balancing and shortening the backup time.

#
20.1.2 Disadvantages

    If your site burns down, you will lose your current backups
    After a tape ﬁlls and you have put in a blank tape, the backup will continue, and this will generally happen during working hours.

#
20.1.3 Practical Details

This system is very simple. When the tape ﬁlls and Bareos requests a new tape, you unmount the tape from the Console program, insert a new tape and label it. In most cases after the label, Bareos will automatically mount the tape and resume the backup. Otherwise, you simply mount the tape.

Using this strategy, one typically does a Full backup once a week followed by daily Incremental backups. To minimize the amount of data written to the tape, one can do a Full backup once a month on the ﬁrst Sunday of the month, a Diﬀerential backup on the 2nd-5th Sunday of the month, and incremental backups the rest of the week.

#
20.2 Manually Changing Tapes

If you use the strategy presented above, Bareos will ask you to change the tape, and you will unmount it and then remount it when you have inserted the new tape.

If you do not wish to interact with Bareos to change each tape, there are several ways to get Bareos to release the tape:

    In your Storage daemon’s Device resource, set AlwaysOpen = no. In this case, Bareos will release the tape after every job. If you run several jobs, the tape will be rewound and repositioned to the end at the beginning of every job. This is not very eﬃcient, but does let you change the tape whenever you want.
    Use a RunAfterJob statement to run a script after your last job. This could also be an Admin job that runs after all your backup jobs. The script could be something like:
          #!/bin/sh  
          bconsole <<END_OF_DATA  
          release storage=your-storage-name  
          END_OF_DATA
    
    In this example, you would have AlwaysOpen=yes, but the release command would tell Bareos to rewind the tape and on the next job assume the tape has changed. This strategy may not work on some systems, or on autochangers because Bareos will still keep the drive open.
    The ﬁnal strategy is similar to the previous case except that you would use the unmount command to force Bareos to release the drive. Then you would eject the tape, and remount it as follows:
          #!/bin/sh  
          bconsole <<END_OF_DATA  
          unmount storage=your-storage-name  
          END_OF_DATA  
    
          # the following is a shell command  
          mt eject  
    
          bconsole <<END_OF_DATA  
          mount storage=your-storage-name  
          END_OF_DATA

#
20.3 Daily Tape Rotation

This scheme is quite diﬀerent from the one mentioned above in that a Full backup is done to a diﬀerent tape every day of the week. Generally, the backup will cycle continuously through ﬁve or six tapes each week. Variations are to use a diﬀerent tape each Friday, and possibly at the beginning of the month. Thus if backups are done Monday through Friday only, you need only ﬁve tapes, and by having two Friday tapes, you need a total of six tapes. Many sites run this way, or using modiﬁcations of it based on two week cycles or longer.

#
20.3.1 Advantages

    All the data is stored on a single tape, so recoveries are simple and faster.
    Assuming the previous day’s tape is taken oﬀsite each day, a maximum of one days data will be lost if the site burns down.

#
20.3.2 Disadvantages

    The tape must be changed every day requiring a lot of operator intervention.
    More errors will occur because of human mistakes.
    If the wrong tape is inadvertently mounted, the Backup for that day will not occur exposing the system to data loss.
    There is much more movement of the tape each day (rewinds) leading to shorter tape drive life time.
    Initial setup of Bareos to run in this mode is more complicated than the Single tape system described above.
    Depending on the number of systems you have and their data capacity, it may not be possible to do a Full backup every night for time reasons or reasons of tape capacity.

#
20.3.3 Practical Details

The simplest way to ”force” Bareos to use a diﬀerent tape each day is to deﬁne a diﬀerent Pool for each day of the the week a backup is done. In addition, you will need to specify appropriate Job and File retention periods so that Bareos will relabel and overwrite the tape each week rather than appending to it. Nic Bellamy has supplied an actual working model of this which we include here.

What is important is to create a diﬀerent Pool for each day of the week, and on the run statement in the Schedule, to specify which Pool is to be used. He has one Schedule that accomplishes this, and a second Schedule that does the same thing for the Catalog backup run each day after the main backup (Priorities were not available when this script was written). In addition, he uses a Max Start Delay of 22 hours so that if the wrong tape is premounted by the operator, the job will be automatically canceled, and the backup cycle will re-synchronize the next day. He has named his Friday Pool WeeklyPool because in that Pool, he wishes to have several tapes to be able to restore to a time older than one week.

And ﬁnally, in his Storage daemon’s Device resource, he has Automatic Mount = yes and Always Open = No. This is necessary for the tape ejection to work in his end_of_backup.sh script below.

For example, his bareos-dir.conf ﬁle looks like the following:

# /etc/bareos/bareos-dir.conf  
#  
# Bareos Director Configuration file  
#  
Director {  
  Name = ServerName  
  DIRport = 9101  
  QueryFile = "/etc/bareos/query.sql"  
  Maximum Concurrent Jobs = 1  
  Password = "console-pass"  
  Messages = Standard  
}  
#  
# Define the main nightly save backup job  
#  
Job {  
  Name = "NightlySave"  
  Type = Backup  
  Client = ServerName  
  FileSet = "Full Set"  
  Schedule = "WeeklyCycle"  
  Storage = Tape  
  Messages = Standard  
  Pool = Default  
  Write Bootstrap = "/var/lib/bareos/NightlySave.bsr"  
  Max Start Delay = 22h  
}  
# Backup the catalog database (after the nightly save)  
Job {  
  Name = "BackupCatalog"  
  Type = Backup  
  Client = ServerName  
  FileSet = "Catalog"  
  Schedule = "WeeklyCycleAfterBackup"  
  Storage = Tape  
  Messages = Standard  
  Pool = Default  
  # This creates an ASCII copy of the catalog  
  # WARNING!!! Passing the password via the command line is insecure.  
  # see comments in make_catalog_backup for details.  
  RunBeforeJob = "/usr/lib/bareos/make_catalog_backup -u bareos"  
  # This deletes the copy of the catalog, and ejects the tape  
  RunAfterJob  = "/etc/bareos/end_of_backup.sh"  
  Write Bootstrap = "/var/lib/bareos/BackupCatalog.bsr"  
  Max Start Delay = 22h  
}  
# Standard Restore template, changed by Console program  
Job {  
  Name = "RestoreFiles"  
  Type = Restore  
  Client = ServerName  
  FileSet = "Full Set"  
  Storage = Tape  
  Messages = Standard  
  Pool = Default  
  Where = /tmp/bareos-restores  
}  
# List of files to be backed up  
FileSet {  
  Name = "Full Set"  
  Include = signature=MD5 {  
    /  
    /data  
  }  
  Exclude = { /proc /tmp /.journal }  
}  
#  
# When to do the backups  
#  
Schedule {  
  Name = "WeeklyCycle"  
  Run = Level=Full Pool=MondayPool Monday at 8:00pm  
  Run = Level=Full Pool=TuesdayPool Tuesday at 8:00pm  
  Run = Level=Full Pool=WednesdayPool Wednesday at 8:00pm  
  Run = Level=Full Pool=ThursdayPool Thursday at 8:00pm  
  Run = Level=Full Pool=WeeklyPool Friday at 8:00pm  
}  
# This does the catalog. It starts after the WeeklyCycle  
Schedule {  
  Name = "WeeklyCycleAfterBackup"  
  Run = Level=Full Pool=MondayPool Monday at 8:15pm  
  Run = Level=Full Pool=TuesdayPool Tuesday at 8:15pm  
  Run = Level=Full Pool=WednesdayPool Wednesday at 8:15pm  
  Run = Level=Full Pool=ThursdayPool Thursday at 8:15pm  
  Run = Level=Full Pool=WeeklyPool Friday at 8:15pm  
}  
# This is the backup of the catalog  
FileSet {  
  Name = "Catalog"  
  Include = signature=MD5 {  
     /var/lib/bareos/bareos.sql  
  }  
}  
# Client (File Services) to backup  
Client {  
  Name = ServerName  
  Address = dionysus  
  FDPort = 9102  
  Password = "client-pass"  
  File Retention = 30d  
  Job Retention = 30d  
  AutoPrune = yes  
}  
# Definition of file storage device  
Storage {  
  Name = Tape  
  Address = dionysus  
  SDPort = 9103  
  Password = "storage-pass"  
  Device = Tandberg  
  Media Type = MLR1  
}  
# Generic catalog service  
Catalog {  
  Name = MyCatalog  
  dbname = bareos; user = bareos; password = ""  
}  
# Reasonable message delivery -- send almost all to email address  
#  and to the console  
Messages {  
  Name = Standard  
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bareos\) %r\" -s \"Bareos: %t %e of %c %l\" %r"  
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bareos\) %r\" -s \"Bareos: Intervention needed for %j\" %r"  
  mail = root@localhost = all, !skipped  
  operator = root@localhost = mount  
  console = all, !skipped, !saved  
  append = "/var/lib/bareos/log" = all, !skipped  
}  

# Pool definitions  
#  
# Default Pool for jobs, but will hold no actual volumes  
Pool {  
  Name = Default  
  Pool Type = Backup  
}  
Pool {  
  Name = MondayPool  
  Pool Type = Backup  
  Recycle = yes  
  AutoPrune = yes  
  Volume Retention = 6d  
  Maximum Volume Jobs = 2  
}  
Pool {  
  Name = TuesdayPool  
  Pool Type = Backup  
  Recycle = yes  
  AutoPrune = yes  
  Volume Retention = 6d  
  Maximum Volume Jobs = 2  
}  
Pool {  
  Name = WednesdayPool  
  Pool Type = Backup  
  Recycle = yes  
  AutoPrune = yes  
  Volume Retention = 6d  
  Maximum Volume Jobs = 2  
}  
Pool {  
  Name = ThursdayPool  
  Pool Type = Backup  
  Recycle = yes  
  AutoPrune = yes  
  Volume Retention = 6d  
  Maximum Volume Jobs = 2  
}  
Pool {  
  Name = WeeklyPool  
  Pool Type = Backup  
  Recycle = yes  
  AutoPrune = yes  
  Volume Retention = 12d  
  Maximum Volume Jobs = 2  
}  
# EOF

In order to get Bareos to release the tape after the nightly backup, this setup uses a RunAfterJob script that deletes the database dump and then rewinds and ejects the tape. The following is a copy of end_of_backup.sh
#! /bin/sh  
/usr/lib/bareos/delete_catalog_backup  
mt rewind  
mt eject  
exit 0

Finally, if you list his Volumes, you get something like the following:
*list media  
Using default Catalog name=MyCatalog DB=bareos  
Pool: WeeklyPool  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| 5   | Friday_1  | MLR1  | Used   | 2157171998| 2003-07-11 20:20| 103680| 1    |  
| 6   | Friday_2  | MLR1  | Append | 0         | 0               | 103680| 1    |  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
Pool: MondayPool  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| 2   | Monday    | MLR1  | Used   | 2260942092| 2003-07-14 20:20| 518400| 1    |  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
Pool: TuesdayPool  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| 3   | Tuesday   | MLR1  | Used   | 2268180300| 2003-07-15 20:20| 518400| 1    |  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
Pool: WednesdayPool  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| 4   | Wednesday | MLR1  | Used   | 2138871127| 2003-07-09 20:2 | 518400| 1    |  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
Pool: ThursdayPool  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| MeId| VolumeName| MedTyp| VolStat| VolBytes  | LastWritten     | VolRet| Recyc|  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
| 1   | Thursday  | MLR1  | Used   | 2146276461| 2003-07-10 20:50| 518400| 1    |  
+-----+-----------+-------+--------+-----------+-----------------+-------+------+  
Pool: Default  
No results to list.

#
Chapter 21
Data Spooling

Bareos allows you to specify that you want the Storage daemon to initially write your data to disk and then subsequently to tape. This serves several important purposes.

    It takes a long time for data to come in from the File daemon during an Incremental backup. If it is directly written to tape, the tape will start and stop or shoe-shine as it is often called causing tape wear. By ﬁrst writing the data to disk, then writing it to tape, the tape can be kept in continual motion.
    While the spooled data is being written to the tape, the despooling process has exclusive use of the tape. This means that you can spool multiple simultaneous jobs to disk, then have them very eﬃciently despooled one at a time without having the data blocks from several jobs intermingled, thus substantially improving the time needed to restore ﬁles. While despooling, all jobs spooling continue running.
    Writing to a tape can be slow. By ﬁrst spooling your data to disk, you can often reduce the time the File daemon is running on a system, thus reducing downtime, and/or interference with users. Of course, if your spool device is not large enough to hold all the data from your File daemon, you may actually slow down the overall backup.

Data spooling is exactly that ”spooling”. It is not a way to ﬁrst write a ”backup” to a disk ﬁle and then to a tape. When the backup has only been spooled to disk, it is not complete yet and cannot be restored until it is written to tape.

Bareos also supports writing a backup to disk then later migrating or moving it to a tape (or any other medium). For details on this, please see the Migration and Copy chapter of this manual for more details.

The remainder of this chapter explains the various directives that you can use in the spooling process. #
21.1 Data Spooling Directives

The following directives can be used to control data spooling.

    Turn data spooling on/oﬀ at the Job level: Spool Data Dir Job = yes|no
    This setting can be overwritten in a Schedule Run Dir Schedule directive: SpoolData=yes|no
    To override the Job speciﬁcation in a bconsole session using the run command: SpoolData=yes|no
    
    Please note that this does not refer to a conﬁguration statement, but to an argument for the run command.
    To limit the the maximum spool ﬁle size for a particular job: Spool Size Dir Job
    To limit the maximum total size of the spooled data for a particular device: Maximum Spool Size Sd Device
    To limit the maximum total size of the spooled data for a particular device for a single job: Maximum Job Spool Size Sd Device
    To specify the spool directory for a particular device: Spool Directory Sd Device

#
21.1.1 Additional Notes

    Please note! Exclude your the spool directory from any backup, otherwise, your job will write enormous amounts of data to the Volume, and most probably terminate in error. This is because in attempting to backup the spool ﬁle, the backup data will be written a second time to the spool ﬁle, and so on ad inﬁnitum.
    Another advice is to always specify the Maximum Spool Size Sd Device so that your disk doesn’t completely ﬁll up. In principle, data spooling will properly detect a full disk, and despool data allowing the job to continue. However, attribute spooling is not so kind to the user. If the disk on which attributes are being spooled ﬁlls, the job will be canceled. In addition, if your working directory is on the same partition as the spool directory, then Bareos jobs will fail possibly in bizarre ways when the spool ﬁlls.
    When data spooling is enabled, Bareos automatically turns on attribute spooling. In other words, it also spools the catalog entries to disk. This is done so that in case the job fails, there will be no catalog entries pointing to non-existent tape backups.
    Attribute despooling occurs near the end of a job. The Storage daemon accumulates ﬁle attributes during the backup and sends them to the Director at the end of the job. The Director then inserts the ﬁle attributes into the catalog. During this insertion, the tape drive may be inactive. When the ﬁle attribute insertion is completed, the job terminates.
    Attribute spool ﬁles are always placed in the working directory of the Storage daemon.
    When Bareos begins despooling data spooled to disk, it takes exclusive use of the tape. This has the major advantage that in running multiple simultaneous jobs at the same time, the blocks of several jobs will not be intermingled.
    It is probably best to provide as large a spool ﬁle as possible to avoid repeatedly spooling/despooling. Also, while a job is despooling to tape, the File daemon must wait (i.e. spooling stops for the job while it is despooling).
    If you are running multiple simultaneous jobs, Bareos will continue spooling other jobs while one is despooling to tape, provided there is suﬃcient spool ﬁle space.

#
Chapter 22
Migration and Copy

The term Migration, as used in the context of Bareos, means moving data from one Volume to another. In particular it refers to a Job (similar to a backup job) that reads data that was previously backed up to a Volume and writes it to another Volume. As part of this process, the File catalog records associated with the ﬁrst backup job are purged. In other words, Migration moves Bareos Job data from one Volume to another by reading the Job data from the Volume it is stored on, writing it to a diﬀerent Volume in a diﬀerent Pool, and then purging the database records for the ﬁrst Job.

The Copy process is essentially identical to the Migration feature with the exception that the Job that is copied is left unchanged. This essentially creates two identical copies of the same backup. However, the copy is treated as a copy rather than a backup job, and hence is not directly available for restore. If Bareos ﬁnds a copy when a job record is purged (deleted) from the catalog, it will promote the copy as real backup and will make it available for automatic restore.

Copy and Migration jobs do not involve the File daemon.

Jobs can be selected for migration based on a number of criteria such as:

    a single previous Job
    a Volume
    a Client
    a regular expression matching a Job, Volume, or Client name
    the time a Job has been on a Volume
    high and low water marks (usage or occupation) of a Pool
    Volume size

The details of these selection criteria will be deﬁned below.

To run a Migration job, you must ﬁrst deﬁne a Job resource very similar to a Backup Job but with Type Dir Job = Migrate instead of Type Dir Job = Backup. One of the key points to remember is that the Pool that is speciﬁed for the migration job is the only pool from which jobs will be migrated, with one exception noted below. In addition, the Pool to which the selected Job or Jobs will be migrated is deﬁned by the Next Pool Dir Pool = ... in the Pool resource speciﬁed for the Migration Job.

Bareos permits Pools to contain Volumes of diﬀerent Media Types. However, when doing migration, this is a very undesirable condition. For migration to work properly, you should use Pools containing only Volumes of the same Media Type for all migration jobs.

A migration job can be started manually or from a Schedule, like a backup job. It searches for existing backup Jobs that match the parameters speciﬁed in the migration Job resource, primarily a Selection Type Dir Job. If no match was found, the Migration job terminates without further action. Otherwise, for each Job found this way, the Migration Job will run a new Job which copies the Job data to a new Volume in the Migration Pool.

Normally three jobs are involved during a migration:

    The Migration control Job which starts the migration child Jobs.
    The previous Backup Job (already run). The File records of this Job are purged when the Migration job terminates successfully. The data remain on the Volume until it is recycled.
    A new Migration Backup Job that moves the data from the previous Backup job to the new Volume. If you subsequently do a restore, the data will be read from this Job.

If the Migration control Job ﬁnds more than one existing Job to migrate, it creates one migration job for each of them. This may result in a large number of Jobs. Please note that Migration doesn’t scale too well if you migrate data oﬀ of a large Volume because each job must read the same Volume, hence the jobs will have to run consecutively rather than simultaneously. #
22.1 Important Migration Considerations

    Each Pool into which you migrate Jobs or Volumes must contain Volumes of only one Media Type Dir Storage.
    Migration takes place on a JobId by JobId basis. That is each JobId is migrated in its entirety and independently of other JobIds. Once the Job is migrated, it will be on the new medium in the new Pool, but for the most part, aside from having a new JobId, it will appear with all the same characteristics of the original job (start, end time, ...). The column RealEndTime in the catalog Job table will contain the time and date that the Migration terminated, and by comparing it with the EndTime column you can tell whether or not the job was migrated. Also, the Job table contains a PriorJobId column which is set to the original JobId for migration jobs. For non-migration jobs this column is zero.
    After a Job has been migrated, the File records are purged from the original Job. Moreover, the Type of the original Job is changed from ”B” (backup) to ”M” (migrated), and another Type ”B” job record is added which refers to the new location of the data. Since the original Job record stays in the bareos catalog, it is still possible to restore from the old media by specifying the original JobId for the restore. However, no ﬁle selection is possible in this case, so one can only restore all ﬁles this way.
    A Job will be migrated only if all Volumes on which the job is stored are marked Full, Used, or Error. In particular, Volumes marked Append will not be considered for migration which rules out the possibility that new ﬁles are appended to a migrated Volume. This policy also prevents deadlock situations, like attempting to read and write the same Volume from two jobs at the same time.
    Migration works only if the Job resource of the original Job is still deﬁned in the current director conﬁguration. Otherwise you’ll get a fatal error.
    Setting the Migration High Bytes watermark is not suﬃcient for migration to take place. In addition, you must deﬁne and schedule a migration job which looks for jobs that can be migrated.
    To ﬁgure out which jobs are going to be migrated by a given conﬁguration, choose a debug level of 100 or more. This activates information about the migration selection process.
    Bareos currently does only minimal Storage conﬂict resolution, so you must take care to ensure that you don’t try to read and write to the same device or Bareos may block waiting to reserve a drive that it will never ﬁnd. In general, ensure that all your migration pools contain only one Media Type Dir Storage, and that you always migrate to pools with diﬀerent Media Types.
    The Next Pool Dir Pool = ... directive must be deﬁned in the Pool referenced in the Migration Job to deﬁne the Pool into which the data will be migrated.
    Migration has only be tested carefully for the ”Job” and ”Volume” selection types. All other selection types (time, occupancy, smallest, oldest, ...) are experimental features.

#
22.2 Conﬁgure Copy or Migration Jobs

The following directives can be used to deﬁne a Copy or Migration job:

Job Resource

    Type Dir Job = Migrate|Copy
    Selection Type Dir Job
    Selection Pattern Dir Job
    Pool Dir Job
    For Selection Type Dir Job other than SQLQuery, this deﬁnes what Pool will be examined for ﬁnding JobIds to migrate
    Purge Migration Job Dir Job

Pool Resource

    Next Pool Dir Pool
    to what pool Jobs will be migrated
    Migration Time Dir Pool
    if Selection Type Dir Job = PoolTime
    Migration High Bytes Dir Pool
    if Selection Type Dir Job = PoolOccupancy
    Migration Low Bytes Dir Pool
    optional if Selection Type Dir Job = PoolOccupancy is used
    Storage Dir Pool
    if Copy/Migration involves multiple Storage Daemon, see Multiple Storage Daemons

#
22.2.1 Example Migration Jobs

Assume a simple conﬁguration with a single backup job as described below.


# Define the backup Job
Job {
  Name = "NightlySave"
  Type = Backup
  Level = Incremental                 # default
  Client=rufus-fd
  FileSet="Full Set"
  Schedule = "WeeklyCycle"
  Messages = Standard
  Pool = Default
}

# Default pool definition
Pool {
  Name = Default
  Pool Type = Backup
  AutoPrune = yes
  Recycle = yes
  Next Pool = Tape
  Storage = File
  LabelFormat = "File"
}

# Tape pool definition
Pool {
  Name = Tape
  Pool Type = Backup
  AutoPrune = yes
  Recycle = yes
  Storage = DLTDrive
}

# Definition of File storage device
Storage {
  Name = File
  Address = rufus
  Password = "secret"
  Device = "File"          # same as Device in Storage daemon
  Media Type = File        # same as MediaType in Storage daemon
}

# Definition of DLT tape storage device
Storage {
  Name = DLTDrive
  Address = rufus
  Password = "secret"
  Device = "HP DLT 80"      # same as Device in Storage daemon
  Media Type = DLT8000      # same as MediaType in Storage daemon
}


Conﬁguration 22.1: Backup Job

Note that the backup job writes to the DefaultDir Pool pool, which corresponds to FileDir Storage storage. There is no Storage Dir Pool directive in the Job resource while the two PoolDir resources contain diﬀerent Storage Dir Pool directives. Moreover, the DefaultDir Pool pool contains a Next Pool Dir Pool directive that refers to the TapeDir Pool pool.

In order to migrate jobs from the DefaultDir Pool pool to the TapeDir Pool pool we add the following Job resource:


Job {
  Name = "migrate-volume"
  Type = Migrate
  Messages = Standard
  Pool = Default
  Selection Type = Volume
  Selection Pattern = "."
}


Conﬁguration 22.2: migrate all volumes of a pool

The Selection Type Dir Job and Selection Pattern Dir Job directives instruct Bareos to select all volumes of the given pool (DefaultDir Pool) whose volume names match the given regular expression (”.”), i.e., all volumes. Hence those jobs which were backed up to any volume in the DefaultDir Pool pool will be migrated. Because of the Next Pool Dir Pool directive of the DefaultDir Pool pool resource, the jobs will be migrated to tape storage.

Another way to accomplish the same is the following Job resource:


Job {
  Name = "migrate"
  Type = Migrate
  Messages = Standard
  Pool = Default
  Selection Type = Job
  Selection Pattern = ".*Save"
}


Conﬁguration 22.3: migrate all jobs named *Save

This migrates all jobs ending with Save from the DefaultDir Pool pool to the TapeDir Pool pool, i.e., from File storage to Tape storage.

Multiple Storage Daemons

Beginning from Bareos Version >= 13.2.0, Migration and Copy jobs are also possible from one Storage daemon to another Storage Daemon.

Please note:

    the director must have two diﬀerent storage resources conﬁgured (e.g. storage1 and storage2)
    each storage needs an own device and an individual pool (e.g. pool1, pool2)
    each pool is linked to its own storage via the storage directive in the pool resource
    to conﬁgure the migration from pool1 to pool2, the Next Pool Dir Pool directive of pool1 has to point to pool2
    the copy job itself has to be of type copy/migrate (exactly as already known in copy- and migration jobs)

Example:


#bareos-dir.conf

# Fake fileset for copy jobs
Fileset {
  Name = None
  Include {
    Options {
      signature = MD5
    }
  }
}

# Fake client for copy jobs
Client {
  Name = None
  Address = localhost
  Password = "NoNe"
  Catalog = MyCatalog
}

# Source storage for migration
Storage {
   Name = storage1
   Address = sd1.example.com
   Password = "secret1"
   Device = File1
   Media Type = File
}

# Target storage for migration
Storage {
   Name = storage2
   Address = sd2.example.com
   Password = "secret2"
   Device = File2
   Media Type = File2   # Has to be different than in storage1
}

Pool {
   Name = pool1
   Storage = storage1
   Next Pool = pool2    # This points to the target storage
}

Pool {
   Name = pool2
   Storage = storage2
}

Job {
   Name = CopyToRemote
   Type = Copy
   Messages = Standard
   Selection Type = PoolUncopiedJobs
   Spool Data = Yes
   Pool = pool1
}


Conﬁguration 22.4: bareos-dir.conf: Copy Job between diﬀerent Storage Daemons

#
Chapter 23
File Deduplication using Base Jobs
A base job is sort of like a Full save except that you will want the FileSet to contain only ﬁles that are unlikely to change in the future (i.e. a snapshot of most of your system after installing it). After the base job has been run, when you are doing a Full save, you specify one or more Base jobs to be used. All ﬁles that have been backed up in the Base job/jobs but not modiﬁed will then be excluded from the backup. During a restore, the Base jobs will be automatically pulled in where necessary.

Imagine having 100 nearly identical Windows or Linux machine containing the OS and user ﬁles. Now for the OS part, a Base job will be backed up once, and rather than making 100 copies of the OS, there will be only one. If one or more of the systems have some ﬁles updated, no problem, they will be automatically backuped.

A new Job directive Base=JobX,_JobY,_... permits to specify the list of ﬁles that will be used during Full backup as base.
Job {  
   Name = BackupLinux  
   Level= Base  
   ...  
}  

Job {  
   Name = BackupZog4  
   Base = BackupZog4, BackupLinux  
   Accurate = yes  
   ...  
}

In this example, the job BackupZog4 will use the most recent version of all ﬁles contained in BackupZog4 and BackupLinux jobs. Base jobs should have run with Level=Base to be used.

By default, Bareos will compare permissions bits, user and group ﬁelds, modiﬁcation time, size and the checksum of the ﬁle to choose between the current backup and the BaseJob ﬁle list. You can change this behavior with the BaseJob FileSet option. This option works like the Verify, that is described in the FileSet chapter.
FileSet {  
  Name = Full  
  Include = {  
    Options {  
       BaseJob  = pmugcs5  
       Accurate = mcs  
       Verify   = pin5  
    }  
    File = /  
  }  
}

Please note! The current implementation doesn’t permit to scan volume with bscan. The result wouldn’t permit to restore ﬁles easily.

#
Chapter 24
Plugins

The functionality of Bareos can be extended by plugins. They do exists plugins for the diﬀerent daemons (Director, Storage- and File-Daemon).

To use plugins, they must be enabled in the conﬁguration (Plugin Directory and optionally Plugin Names).

If a
conﬁgdirectivePlugin Directory is speciﬁed Plugin Names deﬁnes, which plugins get loaded.

If Plugin Names is not deﬁned. #
24.1 File Daemon Plugins

File Daemon plugins are conﬁgured by the Plugin directive of a File Set.

Please note! Currently the plugin command is being stored as part of the backup. The restore command in your directive should be ﬂexible enough if things might change in future, otherwise you could run into trouble.

#
24.1.1 bpipe Plugin

The bpipe plugin is a generic pipe program, that simply transmits the data from a speciﬁed program to Bareos for backup, and from Bareos to a speciﬁed program for restore. The purpose of the plugin is to provide an interface to any system program for backup and restore. That allows you, for example, to do database backups without a local dump. By using diﬀerent command lines to bpipe, you can backup any kind of data (ASCII or binary) depending on the program called.

On Linux, the Bareos bpipe plugin is part of the bareos-filedaemon package and is therefore installed on any system running the ﬁledaemon.

The bpipe plugin is so simple and ﬂexible, you may call it the ”Swiss Army Knife” of the current existing plugins for Bareos.

The bpipe plugin is speciﬁed in the Include section of your Job’s FileSet resource in your bareos-dir.conf.


FileSet {
  Name = "MyFileSet"
  Include {
    Options {
      signature = MD5
      compression = gzip
    }
    Plugin = "bpipe:file=<filepath>:reader=<readprogram>:writer=<writeprogram>
  }
}


Conﬁguration 24.1: bpipe ﬁleset

The syntax and semantics of the Plugin directive require the ﬁrst part of the string up to the colon to be the name of the plugin. Everything after the ﬁrst colon is ignored by the File daemon but is passed to the plugin. Thus the plugin writer may deﬁne the meaning of the rest of the string as he wishes. The full syntax of the plugin directive as interpreted by the bpipe plugin is:


Plugin = "<plugin>:file=<filepath>:reader=<readprogram>:writer=<writeprogram>"


Conﬁguration 24.2: bpipe directive

plugin
    is the name of the plugin with the trailing -fd.so stripped oﬀ, so in this case, we would put bpipe in the ﬁeld.
ﬁlepath
    speciﬁes the namespace, which for bpipe is the pseudo path and ﬁlename under which the backup will be saved. This pseudo path and ﬁlename will be seen by the user in the restore ﬁle tree. For example, if the value is /MySQL/mydump.sql, the data backed up by the plugin will be put under that “pseudo” path and ﬁlename. You must be careful to choose a naming convention that is unique to avoid a conﬂict with a path and ﬁlename that actually exists on your system.
readprogram
    for the bpipe plugin speciﬁes the ”reader” program that is called by the plugin during backup to read the data. bpipe will call this program by doing a popen on it.
writeprogram
    for the bpipe plugin speciﬁes the ”writer” program that is called by the plugin during restore to write the data back to the ﬁlesystem.

Please note that the two items above describing the ”reader” and ”writer”, these programs are ”executed” by Bareos, which means there is no shell interpretation of any command line arguments you might use. If you want to use shell characters (redirection of input or output, ...), then we recommend that you put your command or commands in a shell script and execute the script. In addition if you backup a ﬁle with reader program, when running the writer program during the restore, Bareos will not automatically create the path to the ﬁle. Either the path must exist, or you must explicitly do so with your command or in a shell script.

See the examples about Backup of a PostgreSQL Database and Backup of a MySQL Database.

#
24.1.2 PGSQL Plugin

See chapter Backup of a PostgreSQL Databases by using the PGSQL-Plugin.

#
24.1.3 MSSQL Plugin

See chapter Backup of MSSQL Databases with Bareos Plugin.

#
24.1.4 LDAP Plugin

This plugin is intended to backup (and restore) the contents of a LDAP server. It uses normal LDAP operation for this. The package bareos-filedaemon-ldap-python-plugin (Version >= 15.2.0) contains an example conﬁguration ﬁle, that must be adapted to your envirnoment.

#
24.1.5 Cephfs Plugin

Opposite to the Rados Backend that is used to store data on a CEPH Object Store, this plugin is intended to backup a CEPH Object Store via the Cephfs interface to other media. The package bareos-filedaemon-ceph-plugin (Version >= 15.2.0) contains an example conﬁguration ﬁle, that must be adapted to your envirnoment.

#
24.1.6 Rados Plugin

Opposite to the Rados Backend that is used to store data on a CEPH Object Store, this plugin is intended to backup a CEPH Object Store via the Rados interface to other media. The package bareos-filedaemon-ceph-plugin (Version >= 15.2.0) contains an example conﬁguration ﬁle, that must be adapted to your envirnoment.

#
24.1.7 GlusterFS Plugin

Opposite to the GFAPI Backend that is used to store data on a Gluster system, this plugin is intended to backup data from a Gluster system to other media. The package bareos-filedaemon-glusterfs-plugin (Version >= 15.2.0) contains an example conﬁguration ﬁle, that must be adapted to your envirnoment.

#
24.1.8 python-fd Plugin

The python-fd plugin behaves similar to the python-dir Plugin. Base plugins and an example get installed via the package bareos-ﬁledaemon-python-plugin. Conﬁguration is done in the FileSet Resource on the director.

We basically distinguish between command-plugin and option-plugins.

Command Plugins

Command plugins are used to replace or extend the FileSet deﬁnition in the File Section. If you have a command-plugin, you can use it like in this example:


FileSet {
  Name = "mysql"
  Include {
    Options {
      Signature = MD5 # calculate md5 checksum per file
    }
    File = "/etc"
    Plugin = "python:module_path=/usr/lib/bareos/plugins:module_name=bareos-fd-mysql"
  }
}


Conﬁguration 24.3: bareos-dir.conf: Python FD command plugins

This example uses the MySQL plugin to backup MySQL dumps in addition to /etc.

Option Plugins

Option plugins are activated in the Options resource of a FileSet deﬁnition.

Example:


FileSet {
  Name = "option"
  Include {
    Options {
      Signature = MD5 # calculate md5 checksum per file
      Plugin = "python:module_path=/usr/lib/bareos/plugins:module_name=bareos-fd-file-interact"
    }
    File = "/etc"
    File = "/usr/lib/bareos/plugins"
  }
}


Conﬁguration 24.4: bareos-dir.conf: Python FD option plugins

This plugin bareos-fd-ﬁle-interact from https://github.com/bareos/bareos-contrib/tree/master/fd-plugins/options-plugin-sample has a method that is called before and after each ﬁle that goes into the backup, it can be used as a template for whatever plugin wants to interact with ﬁles before or after backup.

#
24.1.9 VMware Plugin

The VMware®; Plugin can be used for agentless backups of virtual machines running on VMware vSphere®;. It makes use of CBT (Changed Block Tracking) to do space eﬃcient full and incremental backups, see below for mandatory requirements.

It is included in Bareos since Version >= 15.2.0.

Status

The Plugin can do full, diﬀerential and incremental backup and restore of VM disks.

Current limitations amongst others are:

Normal VM disks can not be excluded from the backup. It is not yet possible to exclude normal (dependent) VM disks from backups. However, independent disks are excluded implicitly because they are not aﬀected by snapshots which are required for CBT based backup.

VM conﬁguration is not backed up. The VM conﬁguration is not yet (bareos-15.2.2) backed up, so that it is not yet possible to recreate a completely deleted VM.

Restore can only be done to the same VM or to local VMDK ﬁles. Until Bareos Version 15.2.2, the restore has only be possible to the same existing VM with existing virtual disks. Since Version >= 15.2.3 it is also possible to restore to local VMDK ﬁles, see below for more details.

Requirements

As the Plugin is based on the VMware vSphere®; Storage APIs for Data Protection, which requires at least a VMware vSphere®; Essentials License. It does not work with standalone unlicensed VMware®; ESXi™.

Installation

Install the package bareos-vmware-plugin including its requirments by using an appropriate package management tool (eg. yum, zypper, apt)

The FAQ may have additional useful information.

Conﬁguration

First add a user account in vCenter that has full privileges by assigning the account to an administrator role or by adding the account to a group that is assigned to an administrator role. While any user account with full privileges could be used, it is better practice to create a separate user account, so that the actions by this account logged in vSphere are clearly distinguishable. In the future a more detailed set of required role privilges may be deﬁned.

When using the vCenter appliance with embedded SSO, a user account usually has the structure <_username>_@vsphere.local, it may be diﬀerent when using Active Directory as SSO in vCenter. For the examples here, we will use bakadm@vsphere.local with the password Bak.Adm-1234.

For more details regarding users and permissions in vSphere see

    http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-72BFF98C-C530-4C50-BF31-B5779D2A4BBB.html and
    http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-5372F580-5C23-4E9C-8A4E-EF1B4DD9033E.html

Make sure to add or enable the following settings in /etc/bareos/bareos-fd.conf:


...
FileDaemon {
...
  Plugin Directory = /usr/lib/bareos/plugins
  Plugin Names = python
...
}


Conﬁguration 24.5: bareos-fd.conf: Plugin Settings

Note: Depending on Platform, the Plugin Directory may also be /usr/lib64/bareos/plugins

To deﬁne the backup of a VM in Bareos, a job deﬁnition and a ﬁleset resource must be added to the Bareos director confguration. In vCenter, VMs are usually organized in datacenters and folders. The following example shows how to conﬁgure the backup of the VM named websrv1 in the datacenter mydc1 folder webservers on the vCenter server vcenter.example.org:


Job {
  Name = "vm-websrv1"
  JobDefs = "DefaultJob"
  FileSet = "vm-websrv1_fileset"
}

FileSet {
  Name = "vm-websrv1_fileset"

  Include {
    Options {
         signature = MD5
         Compression = GZIP
    }
    Plugin = "python:module_path=/usr/lib64/bareos/plugins/vmware_plugin:module_name=bareos-fd-vmware:dc=mydc1:folder=/webservers:vmname=websrv1:vcserver=vcenter.example.org:vcuser=bakadm@vsphere.local:vcpass=Bak.Adm-1234"
  }
}


Conﬁguration 24.6: bareos-dir.conf: VMware Plugin Job and FileSet deﬁnition

For VMs deﬁned in the root-folder, folder=/ must be speciﬁed in the Plugin deﬁnition.

Backup

Before running the ﬁrst backup, CBT (Changed Block Tracking) must be enabled for the VMs to be backed up.

As of http://kb.vmware.com/kb/2075984 manually enabling CBT is currently not working properly. The API however works properly. To enable CBT use the Script vmware_cbt_tool.py, it is packaged in the bareos-vmware-plugin package:


# vmware_cbt_tool.py −−help
usage: vmware_cbt_tool.py [-h] -s HOST [-o PORT] -u USER [-p PASSWORD] -d
                          DATACENTER -f FOLDER -v VMNAME [--enablecbt]
                          [--disablecbt] [--resetcbt] [--info]

Process args for enabling/disabling/resetting CBT

optional arguments:
  -h, --help            show this help message and exit
  -s HOST, --host HOST  Remote host to connect to
  -o PORT, --port PORT  Port to connect on
  -u USER, --user USER  User name to use when connecting to host
  -p PASSWORD, --password PASSWORD
                        Password to use when connecting to host
  -d DATACENTER, --datacenter DATACENTER
                        DataCenter Name
  -f FOLDER, --folder FOLDER
                        Folder Name
  -v VMNAME, --vmname VMNAME
                        Names of the Virtual Machines
  --enablecbt           Enable CBT
  --disablecbt          Disable CBT
  --resetcbt            Reset CBT (disable, then enable)
  --info                Show information (CBT supported and enabled or
                        disabled)


Commands 24.7: usage of vmware_cbt_tool.py

For the above conﬁguration example, the command to enable CBT would be


# vmware_cbt_tool.py −s vcenter.example.org −u bakadm@vsphere.local −p Bak.Adm−1234 −d mydc1 −f /webservers −v websrv1 −−enablecbt


Commands 24.8: Example using vmware_cbt_tool.py

Note: CBT does not work if the virtual hardware version is 6 or earlier.

After enabling CBT, Backup Jobs can be run or scheduled as usual, for example in bconsole:

run job=vm-websrv1 level=Full

Restore

For restore, the VM must be powered oﬀ and no snapshot must exist. In bconsole use the restore menu 5, select the correct FileSet and enter mark *, then done. After restore has ﬁnished, the VM can be powered on.

Restore to local VMDK File

Since Version >= 15.2.3 it is possible to restore to local VMDK ﬁles. That means, instead of directly restoring a disk that belongs to the VM, the restore creates VMDK disk image ﬁles on the ﬁlesystem of the system that runs the Bareos File Daemon. As the VM that the backup was taken from is not aﬀected by this, it can remain switched on while restoring to local VMDK. Such a restored VMDK ﬁle can then be uploaded to a VMware vSphere®;datastore or accessed by tools like guestﬁsh to extract single ﬁles.

For restoring to local VMDK, the plugin option localvmdk=yes must be passed. The following example shows how to perform such a restore using bconsole:


*restore
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"

First you select one or more JobIds that contain files
to be restored. You will be presented several methods
of specifying the JobIds. Then you will be allowed to
select which files from those JobIds are to be restored.

To select the JobIds, you have the following choices:
     1: List last 20 Jobs run
     ...
     5: Select the most recent backup for a client
     ...
    13: Cancel
Select item:  (1-13): 5
Automatically selected Client: vmw5-bareos-centos6-64-devel-fd
The defined FileSet resources are:
     1: Catalog
     ...
     5: PyTestSetVmware-test02
     6: PyTestSetVmware-test03
     ...
Select FileSet resource (1-10): 5
+-------+-------+----------+---------------+---------------------+------------------+
| jobid | level | jobfiles | jobbytes      | starttime           | volumename       |
+-------+-------+----------+---------------+---------------------+------------------+
|   625 | F     |        4 | 4,733,002,754 | 2016-02-18 10:32:03 | Full-0067        |
...
You have selected the following JobIds: 625,626,631,632,635

Building directory tree for JobId(s) 625,626,631,632,635 ...
10 files inserted into the tree.

You are now entering file selection mode where you add (mark) and
remove (unmark) files to be restored. No files are initially added, unless
you used the "all" keyword on the command line.
Enter "done" to leave this mode.

cwd is: /
$ mark *
10 files marked.
$ done
Bootstrap records written to /var/lib/bareos/vmw5-bareos-centos6-64-devel-dir.restore.1.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================

    Full-0001                 File                      FileStorage
    ...
    Incremental-0078          File                      FileStorage

Volumes marked with "*" are online.

10 files selected to be restored.

Using Catalog "MyCatalog"
Run Restore job
JobName:         RestoreFiles
Bootstrap:       /var/lib/bareos/vmw5-bareos-centos6-64-devel-dir.restore.1.bsr
Where:           /tmp/bareos-restores
Replace:         Always
FileSet:         Linux All
Backup Client:   vmw5-bareos-centos6-64-devel-fd
Restore Client:  vmw5-bareos-centos6-64-devel-fd
Format:          Native
Storage:         File
When:            2016-02-25 15:06:48
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     ...
    14: Plugin Options
Select parameter to modify (1-14): 14
Please enter Plugin Options string: python:localvmdk=yes
Run Restore job
JobName:         RestoreFiles
Bootstrap:       /var/lib/bareos/vmw5-bareos-centos6-64-devel-dir.restore.1.bsr
Where:           /tmp/bareos-restores
Replace:         Always
FileSet:         Linux All
Backup Client:   vmw5-bareos-centos6-64-devel-fd
Restore Client:  vmw5-bareos-centos6-64-devel-fd
Format:          Native
Storage:         File
When:            2016-02-25 15:06:48
Catalog:         MyCatalog
Priority:        10
Plugin Options:  python: module_path=/usr/lib64/bareos/plugins/vmware_plugin: module_name=bareos-fd-vmware: dc=dass5:folder=/: vmname=stephand-test02: vcserver=virtualcenter5.dass-it:vcuser=bakadm@vsphere.local: vcpass=Bak.Adm-1234: localvmdk=yes
OK to run? (yes/mod/no): yes
Job queued. JobId=639


Commands 24.9: Example restore to local VMDK

Note: Since Bareos Version >= 15.2.3 it is suﬃcient to add Python plugin options, e.g. by

python:localvmdk=yes

Before, all Python plugin must be repeated and the additional be added, like: python:module_path=/usr/lib64/bareos/plugins/vmware_plugin:module_name=bareos-fd-vmware:dc=dass5:folder=/: vmname=stephand-test02:vcserver=virtualcenter5.dass-it:vcuser=bakadm@vsphere.local:vcpass=Bak.Adm-1234:localvmdk=yes

After the restore process has ﬁnished, the restored VMDK ﬁles can be found under /tmp/bareos-restores/:


# ls −laR /tmp/bareos−restores
/tmp/bareos-restores:
total 28
drwxr-x--x.  3 root root  4096 Feb 25 15:47 .
drwxrwxrwt. 17 root root 20480 Feb 25 15:44 ..
drwxr-xr-x.  2 root root  4096 Feb 25 15:19 [ESX5-PS100] stephand-test02

/tmp/bareos-restores/[ESX5-PS100] stephand-test02:
total 7898292
drwxr-xr-x. 2 root root       4096 Feb 25 15:19 .
drwxr-x--x. 3 root root       4096 Feb 25 15:47 ..
-rw-------. 1 root root 2075197440 Feb 25 15:19 stephand-test02_1.vmdk
-rw-------. 1 root root 6012731392 Feb 25 15:19 stephand-test02.vmdk


Commands 24.10: Example result of restore to local VMDK

#
24.2 Storage Daemon Plugins

#
24.2.1 autoxﬂate-sd

This plugin is part of the bareos-storage package.

The autoxﬂate-sd plugin can inﬂate (decompress) and deﬂate (compress) the data being written to or read from a device. It can also do both.

pict

Therefore the autoxﬂate plugin inserts a inﬂate and a deﬂate function block into the stream going to the device (called OUT) and coming from the device (called IN).

Each stream passes ﬁrst the inﬂate function block, then the deﬂate function block.

The inﬂate blocks are controlled by the setting of the Auto Inﬂate Sd Device directive.

The deﬂate blocks are controlled by the setting of the Auto Deﬂate Sd Device, Auto Deﬂate Algorithm Sd Device and Auto Deﬂate Level Sd Device directives.

The inﬂate blocks, if enabled, will uncompress data if it is compressed using the algorithm that was used during compression.

The deﬂate blocks, if enabled, will compress uncompressed data with the algorithm and level conﬁgured in the according directives.

The series connection of the inﬂate and deﬂate function blocks makes the plugin very ﬂexible.
