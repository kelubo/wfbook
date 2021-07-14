# inotify

[TOC]

基于inode级别的文件系统监控技术,一种强大的、细粒度的、异步的机制，满足各种各样的文件监控需要，不仅限于安全和性能。不需要对被监视的目标打开文件描述符，而且如果被监视目标在可移动介质上，那么在 umount 该介质上的文件系统后，被监视目标对应的 watch 将被自动删除，并且会产生一个 umount 事件。既可以监视文件，也可以监视目录。使用系统调用而非 SIGIO 来通知文件系统事件。使用文件描述符作为接口，因而可以使用通常的文件 I/O 操作select 和 poll 来监视文件系统的变化。

可监视的文件系统事件

```bash
IN_ACCESS        : 即文件被访问
IN_MODIFY        : 文件被 write
IN_ATTRIB        : 文件属性被修改，如 chmod、chown、touch 等
IN_CLOSE_WRITE   : 可写文件被 close
IN_CLOSE_NOWRITE : 不可写文件被 close
IN_OPEN          : 文件被open
IN_MOVED_FROM    : 文件被移走,如 mv
IN_MOVED_TO      : 文件被移来，如 mv、cp
IN_CREATE        : 创建新文件
IN_DELETE        : 文件被删除，如 rm
IN_DELETE_SELF   : 自删除，即一个可执行文件在执行时删除自己
IN_MOVE_SELF     : 自移动，即一个可执行文件在执行时移动自己
IN_UNMOUNT       : 宿主文件系统被 umount
IN_CLOSE         : 文件被关闭，等同于(IN_CLOSE_WRITE | IN_CLOSE_NOWRITE)
IN_MOVE          : 文件被移动，等同于(IN_MOVED_FROM | IN_MOVED_TO)
```

注：上面所说的文件也包括目录

## inotify-tools

通过inotify机制监控文件变化的命令行工具，可实时监控服务器文件变化并记录，安装要求内核大于2.6.13。

inotify-tools项目地址：https://github.com/rvoicilas/inotify-tools

查看服务器是否符合安装要求：

```bash
uname -a
Linux centos5.7-x64 2.6.18-274.17.1.el5

ll /proc/sys/fs/inotify/
-rw-r--r-- 1 root root 0 05-15 01:12 max_queued_events
-rw-r--r-- 1 root root 0 05-15 01:12 max_user_instances
-rw-r--r-- 1 root root 0 05-15 01:12 max_user_watches
```

### yum EPEL源安装

```bash
yum install inotify-tools
```

### 编译安装

```bash
cd /usr/local/src/
wget --no-check-certificate https://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
tar zxvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure
make
make install
ldconfig -v
```

## inotify相关参数

```bash
/proc/sys/fs/inotify/max_queued_events
# 该文件中的值为调用inotify_init时分配给inotify instance中可排队的event的数目的最大值，超出这个值得事件被丢弃，但会触发IN_Q_OVERFLOW事件。
# 是 Inotify 管理的队列的最大长度，文件系统变化越频繁，这个值就应该越大。
# 如果你在日志中看到Event Queue Overflow，说明max_queued_events太小需要调整参数后再次使用。
# 默认值: 16384 
/proc/sys/fs/inotify/max_user_instances
# 每个real user ID可创建的instances数量上限。
# 默认值: 128
/proc/sys/fs/inotify/max_user_watches
# 可监控的目录最大数。指定了每个inotify instance相关联的watches的上限。
# 默认值: 8192 
```

## inotifywait
一个监控等待事件，可配合shell实时监控记录文件系统，常用参数：

```bash
--timefmt 时间格式
    %y年 %m月 %d日 %H小时 %M分钟
--format 输出格式
    %T时间 %w路径 %f文件名 %e状态
-m 始终保持监听状态，默认触发事件即退出。
-r 递归查询目录
-q 打印出监控事件。减少冗余信息，只打印出需要的信息。
-e 定义监控的事件，可用参数：
    open   打开，对文件进行打开操作。
    access 访问，读取文件。
    modify 修改，文件内容被修改。
    delete 删除，文件被删除。
    create 创建，生成新文件。
    attrib 属性，文件元数据被修改。
    move   移动，对文件进行移动操作。
    close  关闭，对文件进行关闭操作。
```

### shell脚本示例

```bash
#!/bin/bash
inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f %e' --event modify,delete,create,attrib /home/admin | while read \ date time file event
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
```
## inotifywatch

命令用于收集关于被监视的文件系统的统计数据，包括每个 inotify 事件发生多少次。

## incron

Incron是inotify的cron系统，与os本身的cron一样，包含一个后台守护进程（incrond）和一个事件编辑器。incrontab与os本身的cron不同的仅仅是触发时间的是os对某个文件（夹）的操作而不是时间,由系统事件触发的机制，对于应用系统来说，几乎可以做到实时性。

```bash
# 安装Incron
yum install Incron

# 查看 incron 支持的事件类型
incrontab -t

# 编辑配置文件
incrontab -e

# 启动incrond
/etc/init.d/incrond start
```

### 配置文件

默认配置在/var/spool/incron/ 目录下。

```bash
<path> <mask> <command>

# 选项说明:
# <path>：欲监控的文件或者目录
# <mask>：os对监控对象发生的事件
# <command>：command可以是系统命令，也可以是脚本，不能是用系统的重定向，除非重定向写在脚本中。

# <Command>中还可以使用下面的这些变量：

# $@：代表<path>，即监控对象
# $#：发生系统事件的对象（例如监控了某个文件夹，其下的某个文件发生了变化，那么$#就代表了该文件名）
# $%：代表<mask>，即发生的事件

# 配置举例：
/home/admin/a.txt IN_MODIFY echo "$@ $#"
# 表示文件abc一旦被修改，就执行 echo "$@ $#"
/home/admin/ IN_ALL_EVENTS echo "$@ $# $%"
# 表示目录下的文件任何事件触发,就执行 echo "$@ $#"
```


## fanotify与inotify的区别

fanotify 在2.6.36版本（2010-10-21）并入Linux内核（同时增加了CIFS本地缓存），它与原有的inotify的区别在于以下：  
1. inotify最麻烦的一点就是不能监控子目录，要自己去弄n多个监控。fanotify也不能自动监控子目录，但它有一个Global模式，可以监控整个文件系统的所有事件。这样就可以监控所有事件，然后在程序里判断，这样也算是个比之前好一些的解决方案。  
2. inotify只能接受事件。fanotify不仅可以接受事件，还可以阻塞事件，甚至进一步阻止事件执行成功。并且可以持续地给这个文件设置上acl，且不用每次触发都判断一次（省去麻烦，增加性能）；  
3. fanotify允许多个程序同时监控同一个文件系统对象，并且可以设置优先级（消息到达前后）。这个机制可以处理通过fanotify机制本身做出的动态文件。
4. fanotify可以指定不监控某些pid对文件的操作，这是inotify做不到的。使用场景例子：可以让监控程序自己不会触发事件，避免了让程序员自己去处理死循环的麻烦。
5. fanotify相对于inotify的致命缺陷：fanotify可以触发的事件比inotify少，尤其是缺乏MOVE、ATTRIB、CREATE、DELETE事件（有ACCESS、MODIFY、CLOSE）。
