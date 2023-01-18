# issue

[TOC]

## 概述

设置登录前后的欢迎信息。

实现登录消息的功能，可以修改 3 个文件：

1. /etc/issue 本地登陆显示的信息，本地登录前。
2. /etc/issue.net 网络登陆显示的信息，登录后显示，需要由sshd配置
3. /etc/motd 常用于通告信息，如计划关机时间的警告等，登陆后的提示信息

## /etc/issue | /etc/issue.net

查看帮助：

```bash
man pam_issue
```

文件内容：

```bash
\S
Kernel \r on an \m
```

选项：

```bash
\d		#本地端时间的日期；
\l		#显示当前tty的名字即第几个tty；
\m		#显示硬体的架构 (i386/i486/i586/i686…)；
\n		#显示主机的网路名称；
\o		#显示 domain name；
\r		#当前系统的版本 (相当于 uname -r)
\t		#显示本地端时间的时间；
\u		#当前有几个用户在线。
\s		#当前系统的名称；
\v		#当前系统的版本。
```





issue和issue.net建议配置内容：

    ^[c
    \d at \t
    Access to this host is for authorized persons only.
    Unauthorized use or access is regarded as a criminal act
    and is subject to civil and criminal prosecution.User
    activities on this host may be monitored without prior notice.


至于文件/etc/motd，(motd即motd即message of today布告栏信息的缩写) 则是在每次用户登录时，motd文件的内容会显示在用户的终端。

系统管理员可以在文件中编辑系统活动消息，例如：管理员通知用户系统何时进行软件或硬件的升级、何时进行系统维护等。如果shell支持中文，

还可以使用中文，这样看起来更易于了解。/etc/motd缺点是，现在许多用户登录系统时选择自动进入图形界面，所以这些信息往往看不到。

issue与motd文件主要区别在于：当一个用户过本地文本设备（如本地终端，本地虚拟控制台等）登录

/etc/issue的文件内容显示在login提示符之前，而/etc/motd内容显示在用户成功登录系统之后。

issue.net文件（只针对网络用户）–若通过远程本文设备（如通过ssh或telnet等）登录，则显示该文件的内容。

使用ssh登录时，会不会显示issue信息由sshd服务的sshd_config的Banner属性配置决定，但本人在测试时发现

虽设置了Banner属性但并未对issue.net中的\r和\m等内容进行转义，而是直接显示。

其中上面的三个文件，issue.net和motd文件都是在登录后显示，那么顺序是怎么样的呢，笔者做过一个测试，如下图所示：

这里写图片描述

在这里笔者使用的是Putty进行登录，我们可以发现先显示的是issue.net文件中的内容，最后才显示motd文件中的内容。

笔者又使用Xshell进行登录，得出的结果一样、都是先显示issue.net文件内容，最后显示motd文件的内容。中间隔着上次登录信息。

其中不同的是：

使用Putty登录时，当我们输入用户名root后，就显示了issue.net的内容，输入密码后，再显示的motd的内容。

使用Xshell登录时，只有当我们输入用户名和密码后，验证成功了，才会依次显示issue.net和motd文件的内容。



一、/etc/issue

linux字符终端在登录提示符前的输出信息。通常包括系统的一段短说明或欢迎信息，内容由系统管理员确定。issue选项说明：

\d:插入当前日期；

\s:插入系统名称；

\l:插入当前终端登入的名称；

\m:插入计算机的[体系结构](https://so.csdn.net/so/search?q=体系结构&spm=1001.2101.3001.7020)标识符，例如，i486、i386、x86_64；

\n:插入机器的节点(主机名)；

\o:机器的NIS域名；

\O:计算机的DNS域名；

\r:操作系统内核版本号(uname -r)；

\t:插入当前时间；

\u:插入当前用户登陆的数量；

示例：显示当前日期和时间①vim /etc/issue    ##编辑配置文件

②the times is \d \t  ##在配置文件中输入

技术小白，求大神指教，如有重复，纯属巧合。

/etc/issue文件是Linux系统开机启动时在命令行界面弹出的欢迎语句文件。

先看看里边都有什么

\S

Kernel \r on an \m

以上就是这个文件的所有内容。感觉很少，但是却很有意思。

本人曾经尝试过写一些命令什么的，但是却没有在执行。可能是因为不知道怎么执行吧，假如有知道的大牛请不吝赐教，在此先谢过了。接下来就说下小编在这里边找到的好玩的东西吧。

\d 本地端时间的日期

\l 显示第几个终端机的接口

\n 显示主机的网络名称

\o 显示 domain name

\r 操作系统的版本 (类似 uname-r)

\t 显示本地端时间的时间

\s 操作系统的名称

\v 操作系统的版本

\r详细的内核版本

\m给出当前操作系统的位数

以上就是小白尝试出来的几个小的功能，可能还会有没有测试出来的，如果知道的可以加评论，之后我会及时修改的。