# Linux启动

[TOC]

## 概述

引导（bootstrapping） 是“启动计算机（starting up a computer）”的标准术语。操作系统所提供的正常功能在启动过程中还不能使用，因此，计算机必须“通过其引导程序让自己启动起来”。在引导过程中，内核被加载到内存中并开始执行。各种初始化任务得以执行之后，用户就能够使用系统了。

引导阶段是系统特别脆弱的一段时间。配置文件中的错误、丢失设备或者设备不可靠，以及受损的文件系统都会妨碍计算机的启动。引导配置经常是系统管理员必须在新系统上执行的首批任务之一。遗憾的是，这也是最困难的任务之一，它要求在一定程度上熟悉 Linux 的许多其他方面。

当打开计算机时，计算机执行存储在 ROM 中的引导代码，这些代码接下来尝试确定如何加载并启动内核。内核检测系统的硬件，然后产生系统的 init 进程，这个进程总是 PID1 。

在出现登录提示符以前，要完成几项工作。系统必须检查并安装文件系统，而且系统的守护进程必须启动起来，这些步骤是由 init 进程按顺序运行的一系列 shell 脚本来管理的。启动脚本由于它们的命名方式而经常被称作 “rc 文件”，“rc” 代表 “runcom” 或 “run command(运行命令)” ，这是大约出现于 1965 年的 CTSS 操作系统的历史遗迹。启动脚本的确切位置布局以及它们的执行方式，随操作系统的不同而异。

## 引导分类

Linux 系统既可以以自动方式也可以以手工方式来引导。

* 自动引导

  系统自己执行全部引导过程，不需要任何外部的帮助。

* 手工引导

  系统先自动执行一些过程，然后到某一时刻后，在运行大多数初始化脚本以前，把控制权交给操作员。在这时候，计算机处于“单用户模式”，大多数系统进程还没有运行，其他用户还不能够登录进入系统。

在日常运行中，几乎总是使用自动引导。对于用户来说，在现代机器上典型的引导过程就是打开计算机的电源并等待系统准备就绪。尽管如此，懂得自动引导过程并知道怎样执行手工引导还是很重要的。当出现某些故障而打断了自动引导过程时，例如，出现损坏的文件系统或者出现没有正确配置的网络接口时，通常就不得不采用手工引导。

## 启动过程

Linux系统的启动过程分为以下几个阶段：

- BIOS 启动。
- 加载 MBR。
- 加载 Boot Loader。
- 内核的引导及初始化。
- 检测和配置设备。
- 创建内核线程。
- 操作员干预（仅用于手工引导）。
- 运行初始化进程服务。
- 系统初始化。
- 建立终端 。
- 用户登录系统。

系统管理员对以上大多数步骤几乎没有什么控制权。通过编辑系统启动脚本来影响大多数的引导配置。

## BIOS启动

当计算机打开电源后，首先是 BIOS （Basic Input / Output  System，基本输入输出系统） 开机自检，按照 BIOS 中设置的启动设备（通常是硬盘）来启动。

## 加载 MBR （Master Boot Record）

查找第一个磁盘头的 MBR 信息，并加载和执行 MBR 中的 Bootloader 程序，若第一个磁盘不存在 MBR，则会继续查找第二个磁盘，一旦 BootLoader 程序被检测并加载内存中，BIOS 就将控制权交接给了 BootLoader 程序。

## 加载 Boot Loader

### GRUB

其执行过程可分为三个步骤：

Stage1：这个其实就是 MBR，主要工作就是查找并加载第二段 Bootloader 程序 （stage2），但系统在没启动时，MBR 根本找不到文件系统，也就找不到 stage2 所存放的位置，因此，就有了stage1_5 。

Stage1_5：该步骤是为了识别文件系统。

Stage2：GRUB 程序会根据 `/boot/grub/grub.conf` 文件查找 Kernel 的信息，然后开始加载 Kernel 程序，当 Kernel 程序被检测并在加载到内存中，GRUB 就将控制权交接给了 Kernel 程序。

### GRUB2

- GRUB2 looks for the compressed kernel image （the `vmlinuz` file） in the `/boot` directory.
- GRUB2 loads the kernel image into memory and extracts the contents of the `initramfs` image file into a temporary folder in memory using the `tmpfs` file system.

## kernel 的引导及初始化

操作系统接管硬件以后，首先读入内核文件。

Linux 内核本身就是一个程序，系统引导过程中的第一项任务就是把这个程序载入内存，以便执行它。内核的路径名通常是 `/vmlinuz` 或者 `/boot/vmlinuz` 。Linux 系统实现了一种有两个阶段的加载过程。在第一阶段中，系统 ROM 把一个小的引导程序从磁盘载入到内存中。然后，这个程序再安排载入内核。

内核执行内存检测来确定有多少 RAM 可用。内核的一些内部数据结构按静态方式分配其内存量。因此，当内核启动时，它就为自己划分出一块固定大小的实存空间。这块空间保留给内核使用，用户级进程不能使用。内核在控制台上打印一条消息，报告物理内存的总量以及用户进程可用的内存量。

Kernel 是 Linux 系统最主要的程序，实际上，Kernel 的文件很小，只保留了最基本的模块，并以压缩的文件形式存储在硬盘中，当 GRUB 将 Kernel 读进内存，内存开始解压缩内核文件。讲内核启动，应该先讲下 initrd 这个文件，initrd（Initial RAM  Disk），它在 stage2 这个步骤就被拷贝到了内存中，这个文件是在安装系统时产生的，是一个临时的根文件系统（rootfs）。因为 Kernel 为了精简，只保留了最基本的模块，因此，Kernel 上并没有各种硬件的驱动程序，也就无法识 rootfs 所在的设备，故产生了 initrd 这个文件，该文件装载了必要的驱动模块，当 Kernel 启动时，可以从 initrd 文件中装载驱动模块，直到挂载真正的rootfs，然后将 initrd 从内存中移除。

Kernel会以只读方式挂载根文件系统，当根文件系统被挂载后，开始装载第一个进程（用户空间的进程），执行 /sbin/init ，之后就将控制权交接给了 init 程序。

 ![img](../../Image/l/i/linux_boot_1.png)

## 配置硬件

内核执行的第一批任务之一，包括检査机器的环境以确定机器有什么硬件。当为自己的系统构建内核时，要告诉内核，它会找到哪些硬件设备。当内核开始执行时，它试图找到并初始化已经告诉它的每一个设备。大多数内核为它们所找到的每个设备打印出一行专门信息。现在的发行版本所包含的内核能够在绝大多数机器配置上运行，只要做最少量的定制(如果需要的话)。

在内核配置期间提供的设备信息经常不够明确。在这样的情况下，内核通过探测设备总线和向适当的驱动程序寻求信息来尝试确定它所需要的其他信息。那些没有检测到设备的驱动程序或者那些没有响应探测的驱动程序将被禁用。如果某个设备后来被连接到系统上，那么还是有可能随时加载或者启用它的驱动程序的。

## 内核线程

一旦完成了基本的初始化任务，内核就在用户空间创建几个“自发”的进程。它们之所以被称作是自发进程，是因为这些进程不是通过系统正规的 fork 机制所创建的。

自发进程的数量和特性随系统的不同而不同。在 Linux 上，看不到有 PID 0 进程。和进程 init （一定是进程 1）一起的是几个内存和内核处理进程。这些进程的PID （进程号）都比较小，在 `ps` 命令的输出中它们的名字都被中括号括了起来（例如，`[kacpid]` ）。有时候这些进程的名字以一个斜线加一个数字结尾，比如`[kblockd/0]` 。这个数字表明该线程在哪个处理器上运行，在多处理器的系统上会出现这种有意思的情况。

各系统都有一些的 Linux 内核进程：

| 线程      | 作用                                                         |
| --------- | ------------------------------------------------------------ |
| kjournald | 向磁盘提交 ext3 日志更新信息。（每个已经安装的 ext3 文件系统对应一个 kjourmald 。） |
| kswapd    | 物理内存不足时执行交换操作的进程。                           |
| kreclaimd | 回收近期未用的内存页。                                       |
| ksofirgd  | 处理多层软中断。                                             |
| khubd     | 配置 USB 设备。                                              |

在所有这些进程中，只有 init 是真正完整的用户进程。其他进程实际上都是内核的组成部分，为了调度或者结构上的原因而进行了装扮，使它们看上去像是进程罢了。一旦创建完毕自发进程，内核在引导阶段的任务就完成了。不过，处理基本操作（比如接受登录）的进程还一个都没有创建，而且大多数 Linux 守护进程也都没有启动。这些任务都是由 init 来（有些情况下是间接）负责的。

## 操作员干预（仅限手工引导）

如果系统以单用户模式进行引导，那么在 init 启动时，内核所给出的命令行标志（就是 “single” 这个单词）会通知 init 实际要引导的是单用户模式。进程 init 最后会把控制权交给 sulogin，后者是 login 的一个“中间但不可控”的特殊版本，它提示用户输入 root 口令（参考 inittab 和 sulogin 的 man 手册页了解更多信息。糟糕的是，即便是 Red Hat 和 Fedora 当前的版本，在进入单用户模式之前，也不要求输入口令。）。如果输入的口令正确，系统将产生一个 root shell 。用户可以按下 <Control-D> 而不是输入口令来绕过单用户模式而继续进入到多用户模式。

在单用户 shell 中执行命令的方式和登录到已完全引导的系统上执行命令的方式类似。不过在 SUSE、Debian 还有 Ubuntu 系统上，这时通常只安装了root 分区。为了使用不在 /bin、/sbin 或 /etc 下的程序，用户必须手工安装其他文件系统。

在许多单用户环境下，文件系统的根目录是按只读方式安装的。如果 /tmp 是根文件系统的一部分，那么许多要使用临时文件的命令（例如 vi ）都不能执行。为了解决这个问题，必须先把根文件系统（ / ）以读写方式重新安装，再开始单用户模式的交互操作。下面这条命令通常就能实现这个技巧：

```bash
mount -o rw,remount /
```

> Red Hat 和 Fedora 的单用户模式比正常的模式要稍微多做些工作。在出现 shell 的命令行提示之前，这两种发行版本都会尝试安装所有的本地文件系统。虽然这样做乍看起来挺有用，但是如果系统中包含一个有错的文件系统，那么就会发生问题。

正常的自动引导过程会运行 fsck 命令，检查并修复文件系统。在以单用户模式启动系统时，可能需要手工执行 fsck 。当单用户 shell 退出时，系统将尝试继续引导进入多用户模式。

## 运行初始化进程服务

### 初始化进程服务

常见的初始化进程服务：

* systemd

  CentOS 7，配置文件： /usr/lib/systemd/system 、 /etc/systemd/system。

* openrc

* SysV

  CentOS 5之前，配置文件： /etc/inittab。

  CentOS 6，配置文件： /etc/inittab, /etc/init/*.conf。

* Upstart

### init

init 进程是系统所有进程的起点，没有这个进程，系统中任何进程都不会启动。

init 程序首先是需要读取配置文件 /etc/inittab 。

init，初始化，顾名思义，该程序就是进行 OS 初始化操作，实际上是根据 /etc/inittab（定义了系统默认运行级别）设定的动作进行脚本的执行，第一个被执行的脚本为 /etc/rc.d/rc.sysinit ，这个是真正的 OS 初始化脚本，简单讲下这个脚本的任务：

1. 激活 udev 和 selinux
2. 根据 /etc/sysctl.conf 文件，来设定内核参数
3. 设定系统时钟
4. 装载硬盘映射
5. 启用交换分区
6. 设置主机名
7. 根文件系统检测，并以读写方式重新挂载根文件系统
8. 激活 RAID 和 LVM 设备
9. 启用磁盘配额
10. 根据 /etc/fstab ，检查并挂载其他文件系统
11. 清理过期的锁和 PID 文件
12. 执行完后，根据配置的启动级别，执行对应目录底下的脚本，最后执行/etc/rc.d/rc.local 这个脚本，至此，系统启动完成。

 ![img](../../Image/l/i/linux_boot_2.png)

#### 启动级别

许多程序需要开机启动。在Linux就叫做"守护进程"（daemon）。

init 进程的一大任务，就是去运行这些开机启动的程序。不同的场合需要启动不同的程序。

Linux 允许为不同的场合，分配不同的开机启动程序，这就叫做"运行级别"（runlevel）。

 ![img](../../Image/l/i/linux_boot_3.png)

Linux系统有7个运行级别（runlevel）：

| 级别 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| 0    | 系统停机状态，系统默认运行级别不能设为 0，否则不能正常启动。 |
| 1    | 单用户工作状态，root 权限，用于系统维护，禁止远程登陆。      |
| 2    | 无网络多用户模式。                                           |
| 3    | 有网络多用户模式，登陆后进入控制台命令行模式。               |
| 4    | 保留为自定义，无定义时视为 3。                               |
| 5    | 有 GUI 的多用户模式，X11 控制台，登陆后进入图形 GUI 模式。   |
| 6    | 重启系统，默认运行级别不能设为 6，否则不能正常启动。         |

在 init 的配置文件中有一行： `si::sysinit:/etc/rc.d/rc.sysinit`　它调用执行了 /etc/rc.d/rc.sysinit，而 rc.sysinit 是一个 bash shell 的脚本，它主要是完成一些系统初始化的工作，rc.sysinit 是每一个运行级别都要首先运行的重要脚本。

主要完成的工作有：激活交换分区，检查磁盘，加载硬件模块以及其它一些需要优先执行任务。

```bash
l5:5:wait:/etc/rc.d/rc 5
```

这一行表示以 5 为参数运行 /etc/rc.d/rc ，/etc/rc.d/rc 是一个Shell 脚本，它接受 5 作为参数，去执行 /etc/rc.d/rc5.d/ 目录下的所有的 rc 启动脚本，/etc/rc.d/rc5.d/ 目录中的这些启动脚本实际上都是一些连接文件，而不是真正的 rc 启动脚本，真正的 rc 启动脚本实际上都是放在 /etc/rc.d/init.d/ 目录下。

而这些 rc 启动脚本有着类似的用法，它们一般能接受 start、stop、restart、status 等参数。

/etc/rc.d/rc5.d/ 中的 rc 启动脚本通常是 K 或 S 开头的连接文件，对于以 S 开头的启动脚本，将以 start 参数来运行。

而如果发现存在相应的脚本也存在 K 打头的连接，而且已经处于运行态了（以 /var/lock/subsys/ 下的文件作为标志），则将首先以 stop 为参数停止这些已经启动了的守护进程，然后再重新运行。这样做是为了保证是当 init 改变运行级别时，所有相关的守护进程都将重启。

至于在每个运行级中将运行哪些守护进程，用户可以通过 chkconfig 或 setup 中的 "System Services" 来自行设定。

 ![img](../../Image/l/i/linux_boot_4.png)

### systemd

红帽RHEL 7/8 系统替换掉了初始化进程服务 System V  init，正式采用全新的 systemd 初始化进程服务。

The kernel starts the `systemd` process with PID 1.

```bash
root          1      0  0 02:10 ?        00:00:02 /usr/lib/systemd/systemd --switched-root --system --deserialize 23
```

Linux系统在启动时要进行大量的初始化工作，比如挂载文件系统和交换分区、启动各类进程服务等，这些都可以看作是一个一个的单元（unit），systemd 用目标（target）代替了 System V init 中运行级别的概念，这两者的区别如表所示。

| System V init运行级别 | systemd目标名称   | systemd 目标作用 |
| --------------------- | ----------------- | ---------------- |
| 0                     | poweroff.target   | 关机             |
| 1                     | rescue.target     | 单用户模式       |
| 2                     | multi-user.target | 多用户的文本界面 |
| 3                     | multi-user.target | 多用户的文本界面 |
| 4                     | multi-user.target | 多用户的文本界面 |
| 5                     | graphical.target  | 多用户的图形界面 |
| 6                     | reboot.target     | 重启             |
| emergency             | emergency.target  | 救援模式         |

如果想要将系统默认的运行目标修改为“多用户的文本界面”模式，可直接用 ln 命令把多用户模式目标文件链接到 /etc/systemd/system/ 目录：

```bash
ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
```

使用systemctl命令来管理服务：

| 老系统命令          | 新系统命令              | 作用                             |
| ------------------- | ----------------------- | -------------------------------- |
| service foo start   | systemctl start httpd   | 启动服务。                       |
| service foo restart | systemctl restart httpd | 重启服务。                       |
| service foo stop    | systemctl stop httpd    | 停止服务。                       |
| service foo reload  | systemctl reload httpd  | 重新加载配置文件（不终止服务）。 |
| service foo status  | systemctl status httpd  | 查看服务状态。                   |
| chkconfig foo on  | systemctl enable httpd                 | 开机自动启动。                      |
| chkconfig foo off | systemctl disable httpd                | 开机不自动启动。                    |
| chkconfig foo     | systemctl is-enabled httpd             | 查看特定服务是否为开机自启动。      |
| chkconfig --list  | systemctl list-unit-files --type=httpd | 查看各个级别下服务的启动与禁用情况。 |

## 建立终端

rc 执行完毕后，返回 init 。这时基本系统环境已经设置好了，各种守护进程也已经启动了。此时用户还无法登录。

为了在某个特定终端(包括控制台)上接受用户登录，必须有一个 getty 进程监听终端或者控制台。init 直接生成这些 getty 进程，打开 6 个终端，完成引导过程。init 还负责生成图形登录系统，例如 xdm 或 gdm （如果设置系统使用它们的话）。

> Note：
>
> 即使在引导完成以后，init 还继续担当重要的角色。init 拥有一个单用户和几个多用户“运行级”，运行级决定启用系统的哪些资源。

在 inittab 中的以下 6 行就是定义了 6 个终端：

```bash
1:2345:respawn:/sbin/mingetty tty1
2:2345:respawn:/sbin/mingetty tty2
3:2345:respawn:/sbin/mingetty tty3
4:2345:respawn:/sbin/mingetty tty4
5:2345:respawn:/sbin/mingetty tty5
6:2345:respawn:/sbin/mingetty tty6
```

在 2、3、4、5 的运行级别中都将以 respawn 方式运行 mingetty 程序，mingetty 程序能打开终端、设置模式。

同时它会显示一个文本登录界面，这个界面就是我们经常看到的登录界面，在这个登录界面中会提示用户输入用户名，而用户输入的用户将作为参数传给 login 程序来验证用户的身份。

## 用户登录系统

一般来说，用户的登录方式有三种：

- 命令行登录
- ssh登录
- 图形界面登录

 ![img](../../Image/l/i/linux_boot_5.png)

对于运行级别为 5 的图形方式用户来说，他们的登录是通过一个图形化的登录界面。登录成功后可以直接进入 KDE、Gnome 等窗口管理器。

Linux 的账号验证程序是 login，login 会接收 mingetty 传来的用户名作为用户名参数。

然后 login 会对用户名进行分析：如果用户名不是 root，且存在 /etc/nologin 文件，login 将输出 nologin 文件的内容，然后退出。这通常用来系统维护时防止非root用户登录。只有 /etc/securetty 中登记了的终端才允许 root 用户登录，如果不存在这个文件，则 root 用户可以在任何终端上登录。

/etc/usertty 文件用于对用户作出附加访问限制，如果不存在这个文件，则没有其他限制。

## 图形模式与文字模式的切换方式

Linux 预设提供了六个命令窗口终端机让我们来登录。

默认登录的就是第一个窗口，也就是 tty1，这个六个窗口分别为 tty1,tty2 … tty6，可以按下 Ctrl + Alt + F1 ~ F6 来切换它们。

如果安装了图形界面，默认情况下是进入图形界面的，此时就可以按 Ctrl + Alt + F1 ~ F6 来进入其中一个命令窗口界面。

当进入命令窗口界面后再返回图形界面只要按下 Ctrl + Alt + F7 就回来了。

 ![img](../../Image/l/i/linux_boot_6.png)

















### `systemd`[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#systemd）

Systemd is the parent of all system processes. It reads the target of the `/etc/systemd/system/default.target` link （e.g. `/usr/lib/systemd/system/multi-user.target`） to determine the default target of the system. The file defines the services to be started.

Systemd then places the system in the target-defined state by performing the following initialization tasks:

1. Set the machine name
2. Initialize the network
3. Initialize SELinux
4. Display the welcome banner
5. Initialize the hardware based on the arguments given to the kernel at boot time
6. Mount the file systems, including virtual file systems like /proc
7. Clean up directories in /var
8. Start the virtual memory （swap）

## Protecting the GRUB2 bootloader[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#protecting-the-grub2-bootloader）

Why protect the bootloader with a password?

1. Prevent *Single* user mode access - If an attacker can boot into single user mode, he becomes the root user.
2. Prevent access to GRUB console - If an attacker manages to use GRUB  console, he can change its configuration or collect information about  the system by using the `cat` command.
3. Prevent access to insecure operating systems. If there is a dual  boot on the system, an attacker can select an operating system like DOS  at boot time that ignores access controls and file permissions.

To password protect the GRUB2 bootloader:

- Remove `-unrestricted` from the main `CLASS=` statement in the `/etc/grub.d/10_linux` file.
- If a user has not yet been configured, use the `grub2-setpassword` command to provide a password for the root user:

```
# grub2-setpassword
```

A `/boot/grub2/user.cfg` file will be created if it was not already present. It contains the hashed password of the GRUB2.

!!! Note This command only supports configurations with a single root user.

```
[root]# cat /boot/grub2/user.cfg
GRUB2_PASSWORD=grub.pbkdf2.sha512.10000.CC6F56....A21
```

- Recreate the configuration file with the `grub2-mkconfig` command:

```
[root]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-327.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-327.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-f9725b0c842348ce9e0bc81968cf7181
Found initrd image: /boot/initramfs-0-rescue-f9725b0c842348ce9e0bc81968cf7181.img
done
```

- Restart the server and check.

All entries defined in the GRUB menu will now require a user and  password to be entered at each boot. The system will not boot a kernel  without direct user intervention from the console.

- When the user is requested, enter `root`;
- When a password is requested, enter the password provided at the `grub2-setpassword` command.

To protect only the editing of GRUB menu entries and access to the console, the execution of the `grub2-setpassword` command is sufficient. There may be cases where you have good reasons  for doing only that. This might be particularly true in a remote data  center where entering a password each time a server is rebooted is  either difficult or impossible to do.

## Systemd[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#systemd_1）

*Systemd* is a service manager for the Linux operating systems.

It is developed to:

- remain compatible with older SysV initialization scripts,
- provide many features, such as parallel start of system services at  system startup, on-demand activation of daemons, support for snapshots,  or management of dependencies between services.

!!! Note Systemd is the default initialization system since RedHat/CentOS 7.

Systemd introduces the concept of systemd units.

| Type         | File extension | Observation                              |
| ------------ | -------------- | ---------------------------------------- |
| Service unit | `.service`     | System service                           |
| Target unit  | `.target`      | A group of systemd units                 |
| Mount unit   | `.automount`   | An automatic mount point for file system |

!!! Note There are many types of units: Device unit, Mount unit, Path unit, Scope unit, Slice unit, Snapshot unit, Socket unit, Swap unit,  Timer unit.

- Systemd supports system state snapshots and restore.
- Mount points can be configured as systemd targets.
- At startup, systemd creates listening sockets for all system services that support this type of activation and passes these sockets to these  services as soon as they are started. This makes it possible to restart a service without losing a single message sent to it by the network  during its unavailability. The corresponding socket remains accessible  and all messages are queued.
- System services that use D-BUS for their inter-process communications can be started on demand the first time they are used by a client.
- Systemd stops or restarts only running services. Previous versions  （before RHEL7） attempted to stop services directly without checking  their current status.
- System services do not inherit any context （like HOME and PATH  environment variables）. Each service operates in its own execution  context.

All service unit operations are subject to a default timeout of 5  minutes to prevent a malfunctioning service from freezing the system.

### Managing system services[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#managing-system-services）

Service units end with the `.service` file extension and have a similar purpose to init scripts. The `systemctl` command is used to `display`, `start`, `stop`, `restart` a system service:

| systemctl                                 | Description                             |
| ----------------------------------------- | --------------------------------------- |
| systemctl start *name*.service            | Start a service                         |
| systemctl stop *name*.service             | Stops a service                         |
| systemctl restart *name*.service          | Restart a service                       |
| systemctl reload *name*.service           | Reload a configuration                  |
| systemctl status *name*.service           | Checks if a service is running          |
| systemctl try-restart *name*.service      | Restart a service only if it is running |
| systemctl list-units --type service --all | Display the status of all services      |

The `systemctl` command is also used for the `enable` or `disable` of system a service and displaying associated services:

| systemctl                                | Description                                             |
| ---------------------------------------- | ------------------------------------------------------- |
| systemctl enable *name*.service          | Activate a service                                      |
| systemctl disable *name*.service         | Disable a service                                       |
| systemctl list-unit-files --type service | Lists all services and checks if they are running       |
| systemctl list-dependencies --after      | Lists the services that start before the specified unit |
| systemctl list-dependencies --before     | Lists the services that start after the specified unit  |

Examples:

```
systemctl stop nfs-server.service
# or
systemctl stop nfs-server
```

To list all units currently loaded:

```
systemctl list-units --type service
```

To list all units to check if they are activated:

```
systemctl list-unit-files --type service
systemctl enable httpd.service
systemctl disable bluetooth.service
```

### Example of a .service file for the postfix service[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#example-of-a-service-file-for-the-postfix-service）

```
postfix.service Unit File
What follows is the content of the /usr/lib/systemd/system/postfix.service unit file as currently provided by the postfix package:

[Unit]
Description=Postfix Mail Transport Agent
After=syslog.target network.target
Conflicts=sendmail.service exim.service

[Service]
Type=forking
PIDFile=/var/spool/postfix/pid/master.pid
EnvironmentFile=-/etc/sysconfig/network
ExecStartPre=-/usr/libexec/postfix/aliasesdb
ExecStartPre=-/usr/libexec/postfix/chroot-update
ExecStart=/usr/sbin/postfix start
ExecReload=/usr/sbin/postfix reload
ExecStop=/usr/sbin/postfix stop

[Install]
WantedBy=multi-user.target
```

### Using system targets[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#using-system-targets）

On Rocky8/RHEL8, the concept of run levels has been replaced by Systemd targets.

Systemd targets are represented by target units. Target units end with the `.target` file extension and their sole purpose is to group other Systemd units into a chain of dependencies.

For example, the `graphical.target` unit, which is used to start a graphical session, starts system services such as the **GNOME display manager** （`gdm.service`） or the **accounts service** （`accounts-daemon.service`） and also activates the `multi-user.target` unit.

Similarly, the `multi-user.target` unit starts other essential system services, such as **NetworkManager** （`NetworkManager.service`） or **D-Bus** （`dbus.service`） and activates another target unit named `basic.target`.

| Target Units      | Description                                               |
| ----------------- | --------------------------------------------------------- |
| poweroff.target   | Shuts down the system and turns it off                    |
| rescue.target     | Activates a rescue shell                                  |
| multi-user.target | Activates a multi-user system without graphical interface |
| graphical.target  | Activates a multi-user system with graphical interface    |
| reboot.target     | Shuts down and restarts the system                        |

#### The default target[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-default-target）

To determine which target is used by default:

```
systemctl get-default
```

This command searches for the target of the symbolic link located at `/etc/systemd/system/default.target` and displays the result.

```
$ systemctl get-default
graphical.target
```

The `systemctl` command can also provide a list of available targets:

```
systemctl list-units --type target
UNIT                   LOAD   ACTIVE SUB    DESCRIPTION
basic.target           loaded active active Basic System
bluetooth.target       loaded active active Bluetooth
cryptsetup.target      loaded active active Encrypted Volumes
getty.target           loaded active active Login Prompts
graphical.target       loaded active active Graphical Interface
local-fs-pre.target    loaded active active Local File Systems （Pre）
local-fs.target        loaded active active Local File Systems
multi-user.target      loaded active active Multi-User System
network-online.target  loaded active active Network is Online
network.target         loaded active active Network
nss-user-lookup.target loaded active active User and Group Name Lookups
paths.target           loaded active active Paths
remote-fs.target       loaded active active Remote File Systems
slices.target          loaded active active Slices
sockets.target         loaded active active Sockets
sound.target           loaded active active Sound Card
swap.target            loaded active active Swap
sysinit.target         loaded active active System Initialization
timers.target          loaded active active Timers
```

To configure the system to use a different default target:

```
systemctl set-default name.target
```

Example:

```
# systemctl set-default multi-user.target
rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/multi-user.target' '/etc/systemd/system/default.target'
```

To switch to a different target unit in the current session:

```
systemctl isolate name.target
```

The **Rescue mode** provides a simple environment to repair your system in cases where it is impossible to perform a normal boot process.

In `rescue mode`, the system attempts to mount all local  file systems and start several important system services, but does not  enable a network interface or allow other users to connect to the system at the same time.

On Rocky 8, the `rescue mode` is equivalent to the old `single user mode` and requires the root password.

To change the current target and enter `rescue mode` in the current session:

```
systemctl rescue
```

**Emergency mode** provides the most minimalist  environment possible and allows the system to be repaired even in  situations where the system is unable to enter rescue mode. In the  emergency mode, the system mounts the root file system only for reading. It will not attempt to mount any other local file system, will not  activate any network interface, and will start some essential services.

To change the current target and enter emergency mode in the current session:

```
systemctl emergency
```

#### Shutdown, suspension and hibernation[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#shutdown-suspension-and-hibernation）

The `systemctl` command replaces a number of power management commands used in previous versions:

| Old command         | New command              | Description                         |
| ------------------- | ------------------------ | ----------------------------------- |
| `halt`              | `systemctl halt`         | Shuts down the system.              |
| `poweroff`          | `systemctl poweroff`     | Turns off the system.               |
| `reboot`            | `systemctl reboot`       | Restarts the system.                |
| `pm-suspend`        | `systemctl suspend`      | Suspends the system.                |
| `pm-hibernate`      | `systemctl hibernate`    | Hibernates the system.              |
| `pm-suspend-hybrid` | `systemctl hybrid-sleep` | Hibernates and suspends the system. |

### The `journald` process[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-journald-process）

Log files can, in addition to `rsyslogd`, also be managed by the `journald` daemon which is a component of `systemd`.

The `journald` daemon captures Syslog messages, kernel log messages, messages from the initial RAM disk and from the start of  boot, as well as messages written to the standard output and the  standard error output of all services, then indexes them and makes them  available to the user.

The format of the native log file, which is a structured and indexed  binary file, improves searches and allows for faster operation, it also  stores metadata information, such as timestamps or user IDs.

### `journalctl` command[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#journalctl-command）

The `journalctl` command displays the log files.

```
journalctl
```

The command lists all log files generated on the system. The structure of this output is similar to that used in `/var/log/messages/` but it offers some improvements:

- the priority of entries is marked visually;
- timestamps are converted to the local time zone of your system;
- all logged data is displayed, including rotating logs;
- the beginning of a start is marked with a special line.

#### Using continuous display[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#using-continuous-display）

With continuous display, log messages are displayed in real time.

```
journalctl -f
```

This command returns a list of the ten most recent log lines. The  journalctl utility then continues to run and waits for new changes to  occur before displaying them immediately.

#### Filtering messages[¶]（https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#filtering-messages）

It is possible to use different filtering methods to extract  information that fits different needs. Log messages are often used to  track erroneous behavior on the system. To view entries with a selected  or higher priority:

```
journalctl -p priority
```

You must replace priority with one of the following keywords （or a number）:

- debug （7）,
- info （6）,
- notice （5）,
- warning （4）,
- err （3）,
- crit （2）,
- alert （1）,
- and emerg （0）.

