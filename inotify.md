fanotify与inotify的区别
fanotify在2.6.36版本（2010-10-21）并入Linux内核（同时增加了CIFS本地缓存），它与原有的inotify的区别在于以下：
1、inotify最麻烦的一点就是不能监控子目录，要自己去弄n多个监控。fanotify也不能自动监控子目录，但它有一个Global模式，可以监控整个文件系统的所有事件。这样就可以监控所有事件，然后在程序里判断，这样也算是个比之前好一些的解决方案；
2、inotify只能接受事件。fanotify不仅可以接受事件，还可以阻塞事件，甚至进一步阻止事件执行成功。并且可以持续地给这个文件设置上acl，且不用每次触发都判断一次（省去麻烦，增加性能）；
3、fanotify允许多个程序同时监控同一个文件系统对象，并且可以设置优先级（消息到达前后）。这个机制可以处理通过fanotify机制本身做出的动态文件；
4、fanotify可以指定不监控某些pid对文件的操作，这是inotify做不到的。使用场景例子：可以让监控程序自己不会触发事件，避免了让程序员自己去处理死循环的麻烦；
5、fanotify相对于inotify的致命缺陷：fanotify可以触发的事件比inotify少，尤其是缺乏MOVE、ATTRIB、CREATE、DELETE事件（有ACCESS、MODIFY、CLOSE）。
Linux下用inotify-tool实时监控服务器文件系统

发布时间：May 20, 2012 // 分类：备份存储 // No Comments

inotify-tools是linux下通过inotify机制监控文件变化的命令行工具，可实时监控服务器文件变化并记录，如果服务器出现问题可协助查找原因，安装要求内核大于2.6.13。
查看服务器是否符合安装要求：
1
2
	
uname -a
Linux centos5.7-x64 2.6.18-274.17.1.el5 
1
2
3
4
	
ll /proc/sys/fs/inotify/
-rw-r--r-- 1 root root 0 05-15 01:12 max_queued_events
-rw-r--r-- 1 root root 0 05-15 01:12 max_user_instances
-rw-r--r-- 1 root root 0 05-15 01:12 max_user_watches

服务器如有安装EPEL源可使用yum安装：
1
	
yum install inotify-tools

编译安装：
1
2
3
4
5
6
7
8
	
cd /usr/local/src/
wget --no-check-certificate https://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
tar zxvf inotify-tools-3.14.tar.gz 
cd inotify-tools-3.14
./configure
make
make install
ldconfig -v

inotify相关参数：
1
2
3
	
/proc/sys/fs/inotify/max_queued_events  #请求events数的最大值
/proc/sys/fs/inotify/max_user_instances #每个user可创建的instances数量上限
/proc/sys/fs/inotify/max_user_watches   #可监控的目录最大数

inotifywait是一个监控等待事件，可配合shell实时监控记录文件系统，常用参数：
1
2
3
4
5
6
7
8
9
10
11
12
13
14
	
--timefmt 时间格式
%y年 %m月 %d日 %H小时 %M分钟
--format 输出格式
%T时间 %w路径 %f文件名 %e状态
-m 始终保持监听状态，默认触发事件即退出。
-r 递归查询目录
-q 打印出监控事件
-e 定义监控的事件，可用参数：
open   打开文件
access 访问文件
modify 修改文件
delete 删除文件
create 新建文件
attrb  属性变更

应用示例：
实时监控wwwroot目录下新建或修改的文件并输出：
1
	
inotifywait -mrq -e modify,create --timefmt '%y-%m-%d %H:%M' --format '%T %f %e' /home/wwwroot/

输出如下：
1
2
3
4
5
6
	
12-05-14 20:43 favicon.ico
12-05-14 20:43 favicon.ico
12-05-14 20:43 tab_console_down.gif
12-05-14 20:43 tab_console_down.gif
12-05-14 20:43 tab_graphs.gif
12-05-14 20:43 tab_graphs.gif


运维之道
道,可道,非常道 名,可名,非常名

    首页
    系统安全
    网海拾贝
    系统基础
    系统安装
    性能调优
    系统管理
    欢迎留言

文章内容

    Inotify 机制概述
    Inotify 在系统中使用

随机文章展示

    openssl 非对称加密DSA,RSA区别与使用介绍
    当你心烦意乱时,请您读一读,顿时平静(励志)
    fedora13(i386) 安装Pydev,Eclipse,进行ide化python开发
    fedora 系统使用 Broadcom BCM4312 无线网卡
    使用linux桌面办公 常用软件介绍
    PyYAML 配置文件格式简介以及在python上的应用
    使用linux 拷贝windows系统到新的磁盘上
    使用linux桌面办公 常用软件介绍
    软件包管理器yum 用法指南以及RPM仓库搭建方法
    下辈子，无论爱与不爱，都不会再见(转载)

关注微博
问答区

如果您对文章和网站有好的意见或者建议,或者有关于网站架构，运维，管理等方面的知识交流 欢迎留言
支持 运维之道

如果您觉得此文章对你有用或者有帮助，请支持我们，谢谢！

linux inotify 监控文件系统事件

Author: 北方人 LastUpdate : 2014-08-25 15:13:33

1. Inotify 机制概述
1.1. Inotify 介绍

在日常的运维过程中，经常需要备份某些文件，或者对系统的某些文件进行监控，比如重要的配置文件等。如果需要作到实时同步或者监控，就需要使用内核的inotify机制
Inotify 是基于inode级别的文件系统监控技术,是一种强大的、细粒度的、异步的机制，它满足各种各样的文件监控需要，不仅限于安全和性能

    Inotify 不需要对被监视的目标打开文件描述符，而且如果被监视目标在可移动介质上，那么在 umount 该介质上的文件系统后，被监视目标对应的 watch 将被自动删除，并且会产生一个 umount 事件。
    Inotify 既可以监视文件，也可以监视目录。
    Inotify 使用系统调用而非 SIGIO 来通知文件系统事件。
    Inotify 使用文件描述符作为接口，因而可以使用通常的文件 I/O 操作select 和 poll 来监视文件系统的变化。 

1.2. Inotify 可监视的文件系统事件

    IN_ACCESS : 即文件被访问
    IN_MODIFY : 文件被 write
    IN_ATTRIB : 文件属性被修改，如 chmod、chown、touch 等
    IN_CLOSE_WRITE : 可写文件被 close
    IN_CLOSE_NOWRITE : 不可写文件被 close
    IN_OPEN : 文件被open
    IN_MOVED_FROM : 文件被移走,如 mv
    IN_MOVED_TO : 文件被移来，如 mv、cp
    IN_CREATE : 创建新文件
    IN_DELETE : 文件被删除，如 rm
    IN_DELETE_SELF : 自删除，即一个可执行文件在执行时删除自己
    IN_MOVE_SELF : 自移动，即一个可执行文件在执行时移动自己
    IN_UNMOUNT : 宿主文件系统被 umount
    IN_CLOSE : 文件被关闭，等同于(IN_CLOSE_WRITE | IN_CLOSE_NOWRITE)
    IN_MOVE : 文件被移动，等同于(IN_MOVED_FROM | IN_MOVED_TO) 

注：上面所说的文件也包括目录
1.3. Inotify内核版本支持

    从kernel 2.6.13开始,Inotify正式并入内核，RHEL5已经支持.
    看看是否有 /proc/sys/fs/inotify/目录，以确定内核是否支持inotify

      [root@RHEL5 Rsync]# ls -l /proc/sys/fs/inotify/
      total 0
      -rw-r--r-- 1 root root 0 Oct  9 09:36 max_queued_events
      -rw-r--r-- 1 root root 0 Oct  9 09:36 max_user_instances
      -rw-r--r-- 1 root root 0 Oct  9 09:36 max_user_watches

1.4. inotify 的默认内核参数

    /proc/sys/fs/inotify/max_queued_events 默认值: 16384 该文件中的值为调用inotify_init时分配给inotify instance中可排队的event的数目的最大值，超出这个值得事件被丢弃，但会触发IN_Q_OVERFLOW事件

    /proc/sys/fs/inotify/max_user_instances 默认值: 128 指定了每一个real user ID可创建的inotify instatnces的数量上限

    /proc/sys/fs/inotify/max_user_watches 默认值: 8192 指定了每个inotify instance相关联的watches的上限 

注意: max_queued_events 是 Inotify 管理的队列的最大长度，文件系统变化越频繁，这个值就应该越大
如果你在日志中看到Event Queue Overflow，说明max_queued_events太小需要调整参数后再次使用.
2. Inotify 在系统中使用
2.1. linux shell 下使用inotify

    下载安装 inotify-tools源码 rhel5/centos5 RPM包
        inotifywait 仅执行阻塞，等待 inotify 事件。您可以监控任何一组文件和目录，或监控整个目录树（目录、子目录、子目录的子目录等等）
        在 shell 脚本中使用 inotifywait。
        inotifywatch 收集关于被监视的文件系统的统计数据，包括每个 inotify 事件发生多少次。

    shell脚本示例

      [root@localhost ]# cat /tmp/test.sh
      #!/bin/bash
      inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format  '%T %w%f %e' --event modify,delete,create,attrib  /home/admin | while read  date time file event
      do
          case $event in
              MODIFY|CREATE|MOVE|MODIFY,ISDIR|CREATE,ISDIR|MODIFY,ISDIR)
                      echo $event'-'$file
                  ;;
      
              MOVED_FROM|MOVED_FROM,ISDIR|DELETE|DELETE,ISDIR)
                      echo $event'-'$file
                  ;;
          esac
      done

    执行脚本，结果输出(这里测试删除了一个目录 rm -fr cronolog-1.6.2.bak)

      [root@localhost]# /tmp/test.sh 
      DELETE-/home/admin/cronolog-1.6.2.bak/COPYING
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/cronolog.info
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/cronolog.texi
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/Makefile.am
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/Makefile.in
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/texinfo.tex
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/cronosplit.1m
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/Makefile
      DELETE-/home/admin/cronolog-1.6.2.bak/doc/cronolog.1m
      DELETE,ISDIR-/home/admin/cronolog-1.6.2.bak/doc
      DELETE-/home/admin/cronolog-1.6.2.bak/TODO
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronotest.c
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronolog.c
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronoutils.h
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronoutils.c
      DELETE-/home/admin/cronolog-1.6.2.bak/src/Makefile.am
      DELETE-/home/admin/cronolog-1.6.2.bak/src/Makefile.in
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronosplit.in
      DELETE-/home/admin/cronolog-1.6.2.bak/src/Makefile
      DELETE-/home/admin/cronolog-1.6.2.bak/src/cronosplit
      DELETE-/home/admin/cronolog-1.6.2.bak/src/config.h
      DELETE,ISDIR-/home/admin/cronolog-1.6.2.bak/src
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/getopt1.c
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/getopt.h
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/Makefile.am
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/Makefile.in
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/localtime_r.c
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/getopt.c
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/Makefile
      DELETE-/home/admin/cronolog-1.6.2.bak/lib/strptime.c
      DELETE,ISDIR-/home/admin/cronolog-1.6.2.bak/lib
      DELETE-/home/admin/cronolog-1.6.2.bak/config.cache
      DELETE-/home/admin/cronolog-1.6.2.bak/install-sh
      DELETE-/home/admin/cronolog-1.6.2.bak/Makefile.am
      DELETE-/home/admin/cronolog-1.6.2.bak/README
      DELETE-/home/admin/cronolog-1.6.2.bak/AUTHORS
      DELETE-/home/admin/cronolog-1.6.2.bak/Makefile.in
      DELETE-/home/admin/cronolog-1.6.2.bak/testsuite/Makefile.am
      DELETE-/home/admin/cronolog-1.6.2.bak/testsuite/README
      DELETE-/home/admin/cronolog-1.6.2.bak/testsuite/Makefile.in
      DELETE-/home/admin/cronolog-1.6.2.bak/testsuite/Makefile
      DELETE,ISDIR-/home/admin/cronolog-1.6.2.bak/testsuite
      DELETE-/home/admin/cronolog-1.6.2.bak/cronolog.spec
      DELETE-/home/admin/cronolog-1.6.2.bak/NEWS
      DELETE-/home/admin/cronolog-1.6.2.bak/configure
      DELETE-/home/admin/cronolog-1.6.2.bak/ChangeLog
      DELETE-/home/admin/cronolog-1.6.2.bak/missing
      DELETE-/home/admin/cronolog-1.6.2.bak/config.log
      DELETE-/home/admin/cronolog-1.6.2.bak/aclocal.m4
      DELETE-/home/admin/cronolog-1.6.2.bak/Makefile
      DELETE-/home/admin/cronolog-1.6.2.bak/INSTALL
      DELETE-/home/admin/cronolog-1.6.2.bak/config.status
      DELETE-/home/admin/cronolog-1.6.2.bak/configure.in
      DELETE-/home/admin/cronolog-1.6.2.bak/mkinstalldirs
      DELETE,ISDIR-/home/admin/cronolog-1.6.2.bak

    详细请参考 man inotify , man inotifywait 

2.2. 使用incron实现重要配置文件监控

Incron是inotify的cron系统，与os本身的cron一样，包含一个后台守护进程（incrond）和一个事件编辑器（incrontab
与os本身的cron不同的仅仅是触发时间的是os对某个文件（夹）的操作而不是时间,由系统事件触发的机制，对于应用系统来说，几乎可以做到实时性。

    安装Incron Incron Rpm包

      [root@localhost]# yum install Incron

    查看 incron 支持的事件类型 incrontab -t ,编辑配置文件使用 incrontab -e
    配置文件格式说明(默认配置在/var/spool/incron/ 目录下)

      <path> <mask> <command>

    选项说明:
    <path>：欲监控的文件或者目录
    <mask>：os对监控对象发生的事件
    <command>：command可以是系统命令，也可以是脚本，不能是用系统的重定向，除非重定向写在脚本中。

    <Command>中还可以使用下面的这些变量：

    $@：代表<path>，即监控对象
    $#：发生系统事件的对象（例如监控了某个文件夹，其下的某个文件发生了变化，那么$#就代表了该文件名）
    $%：代表<mask>，即发生的事件 

    配置举例：
        /home/admin/a.txt IN_MODIFY echo "$@ $#"

        表示文件abc一旦被修改，就执行 echo "$@ $#"

        /home/admin/ IN_ALL_EVENTS echo "$@ $# $%"

        表示目录下的文件任何事件触发,就执行 echo "$@ $#"

    启动incrond (/etc/init.d/incrond start),然后在 /home/admin目录删除 ssss 文件，查看日志 tail /var/log/cron ,有如下输出

      Mar 23 14:05:19 localhost incrond[6857]: (root) CMD (echo "/home/admin =  = IN_OPEN,IN_ISDIR")
      Mar 23 14:05:19 localhost incrond[6857]: (root) CMD (echo "/home/admin =  = IN_CLOSE_NOWRITE,IN_ISDIR")
      Mar 23 14:05:20 localhost incrond[6857]: (root) CMD (echo "/home/admin =  = IN_OPEN,IN_ISDIR")
      Mar 23 14:05:20 localhost incrond[6857]: (root) CMD (echo "/home/admin =  = IN_CLOSE_NOWRITE,IN_ISDIR")
      Mar 23 14:05:20 localhost incrond[6857]: (root) CMD (echo "/home/admin = ssss = IN_DELETE")

总体来说，在文件和目录实时监控还是很有效的，可以结合其他工具来作统一化的解决方案,比如使用syslog-ng作统一化收集，当然最重要还是要有场景.

关于作者