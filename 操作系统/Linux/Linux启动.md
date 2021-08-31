# Linux启动

[TOC]

## 启动过程

Linux系统的启动过程可以分为5个阶段：

- 内核的引导。
- 运行 init 程序。
- 系统初始化。
- 建立终端 。
- 用户登录系统。

## 内核引导

当计算机打开电源后，首先是BIOS开机自检，按照BIOS中设置的启动设备（通常是硬盘）来启动。

操作系统接管硬件以后，首先读入 /boot 目录下的内核文件。

![img](../../Image/l/i/linux_boot_1.png)

## 运行 init 程序

init 进程是系统所有进程的起点，没有这个进程，系统中任何进程都不会启动。

init 程序首先是需要读取配置文件 /etc/inittab。

![img](../../Image/l/i/linux_boot_2.png)

### init 程序

* systemd

  CentOS 7,配置文件： /usr/lib/systemd/system、 /etc/systemd/system。

* openrc

* SysV

  CentOS 5之前, 配置文件： /etc/inittab。

  CentOS 6, 配置文件： /etc/inittab, /etc/init/*.conf。

* Upstart

### init启动级别

许多程序需要开机启动。在Linux就叫做"守护进程"（daemon）。

init进程的一大任务，就是去运行这些开机启动的程序。不同的场合需要启动不同的程序。

Linux允许为不同的场合，分配不同的开机启动程序，这就叫做"运行级别"（runlevel）。

![img](../../Image/l/i/linux_boot_3.png)

Linux系统有7个运行级别(runlevel)：

| 级别 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| 0    | 关机 系统停机状态，系统默认运行级别不能设为0，否则不能正常启动 |
| 1    | 单用户模式 单用户工作状态，root权限，用于系统维护，禁止远程登陆 |
| 2    | 无网络多用户模式多用户状态(没有NFS)                          |
| 3    | 有网络多用户模式完全的多用户状态(有NFS)，登陆后进入控制台命令行模式 |
| 4    | 保留为自定义，无定义时视为3系统未使用，保留                  |
| 5    | 有GUI的多用户模式X11控制台，登陆后进入图形GUI模式            |
| 6    | 重启系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动 |

在 init 的配置文件中有一行：  si::sysinit:/etc/rc.d/rc.sysinit　它调用执行了/etc/rc.d/rc.sysinit，而rc.sysinit是一个bash shell的脚本，它主要是完成一些系统初始化的工作，rc.sysinit是每一个运行级别都要首先运行的重要脚本。

它主要完成的工作有：激活交换分区，检查磁盘，加载硬件模块以及其它一些需要优先执行任务。

```bash
l5:5:wait:/etc/rc.d/rc 5
```

这一行表示以5为参数运行/etc/rc.d/rc，/etc/rc.d/rc是一个Shell脚本，它接受5作为参数，去执行/etc/rc.d/rc5.d/目录下的所有的rc启动脚本，/etc/rc.d/rc5.d/目录中的这些启动脚本实际上都是一些连接文件，而不是真正的rc启动脚本，真正的rc启动脚本实际上都是放在/etc/rc.d/init.d/目录下。

而这些rc启动脚本有着类似的用法，它们一般能接受start、stop、restart、status等参数。

/etc/rc.d/rc5.d/中的rc启动脚本通常是K或S开头的连接文件，对于以 S 开头的启动脚本，将以start参数来运行。

而如果发现存在相应的脚本也存在K打头的连接，而且已经处于运行态了(以/var/lock/subsys/下的文件作为标志)，则将首先以stop为参数停止这些已经启动了的守护进程，然后再重新运行。

这样做是为了保证是当init改变运行级别时，所有相关的守护进程都将重启。

至于在每个运行级中将运行哪些守护进程，用户可以通过chkconfig或setup中的"System Services"来自行设定。

![img](../../Image/l/i/linux_boot_4.png)

## 建立终端

rc执行完毕后，返回init。这时基本系统环境已经设置好了，各种守护进程也已经启动了。

init接下来会打开6个终端，以便用户登录系统。在inittab中的以下6行就是定义了6个终端：

```bash
1:2345:respawn:/sbin/mingetty tty1
2:2345:respawn:/sbin/mingetty tty2
3:2345:respawn:/sbin/mingetty tty3
4:2345:respawn:/sbin/mingetty tty4
5:2345:respawn:/sbin/mingetty tty5
6:2345:respawn:/sbin/mingetty tty6
```

在2、3、4、5的运行级别中都将以 respawn 方式运行 mingetty 程序，mingetty 程序能打开终端、设置模式。

同时它会显示一个文本登录界面，这个界面就是我们经常看到的登录界面，在这个登录界面中会提示用户输入用户名，而用户输入的用户将作为参数传给login程序来验证用户的身份。

## 用户登录系统

一般来说，用户的登录方式有三种：

- 命令行登录
- ssh登录
- 图形界面登录

![img](../../Image/l/i/linux_boot_5.png)

对于运行级别为5的图形方式用户来说，他们的登录是通过一个图形化的登录界面。登录成功后可以直接进入 KDE、Gnome 等窗口管理器。

Linux 的账号验证程序是 login，login 会接收 mingetty 传来的用户名作为用户名参数。

然后 login 会对用户名进行分析：如果用户名不是 root，且存在 /etc/nologin 文件，login 将输出 nologin 文件的内容，然后退出。这通常用来系统维护时防止非root用户登录。只有/etc/securetty中登记了的终端才允许 root 用户登录，如果不存在这个文件，则 root 用户可以在任何终端上登录。

/etc/usertty文件用于对用户作出附加访问限制，如果不存在这个文件，则没有其他限制。

## 图形模式与文字模式的切换方式

Linux预设提供了六个命令窗口终端机让我们来登录。

默认登录的就是第一个窗口，也就是tty1，这个六个窗口分别为tty1,tty2 … tty6，可以按下Ctrl + Alt + F1 ~ F6 来切换它们。

如果安装了图形界面，默认情况下是进入图形界面的，此时就可以按Ctrl + Alt + F1 ~ F6来进入其中一个命令窗口界面。

当进入命令窗口界面后再返回图形界面只要按下Ctrl + Alt + F7 就回来了。

![img](../../Image/l/i/linux_boot_6.png)