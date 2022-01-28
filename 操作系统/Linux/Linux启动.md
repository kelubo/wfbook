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

| 级别 | 描述                                                      |
| ---- | --------------------------------------------------------- |
| 0    | 系统停机状态，系统默认运行级别不能设为0，否则不能正常启动 |
| 1    | 单用户工作状态，root权限，用于系统维护，禁止远程登陆      |
| 2    | 无网络多用户模式                                          |
| 3    | 有网络多用户模式，登陆后进入控制台命令行模式              |
| 4    | 保留为自定义，无定义时视为3                               |
| 5    | 有GUI的多用户模式，X11控制台，登陆后进入图形GUI模式       |
| 6    | 重启系统，默认运行级别不能设为6，否则不能正常启动         |

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







# System Startup[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#system-startup)

In this chapter you will learn how the system start.

------

**Objectives** : In this chapter, future Linux administrators will learn:

![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) The different stages of the booting process; 
 ![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) How Rocky Linux supports this boot via GRUB2 and systemd; 
 ![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) How to protect GRUB2 from an attack; 
 ![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) How to manage the services; 
 ![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) How to access to the logs from journald.

![🏁](https://twemoji.maxcdn.com/v/latest/svg/1f3c1.svg) **users**

**Knowledge**: ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) 
 **Complexity**: ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg)

**阅读时间**: 20 分钟

------

## The boot process[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-boot-process)

It is important to understand the boot process of Linux in order to be able to solve problems that may occur.

The boot process includes:

### The BIOS startup[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-bios-startup)

The **BIOS** (Basic Input/Output System) performs the **POST** (power on self test) to detect, test and initialize the system hardware components.

It then loads the **MBR** (Master Boot Record).

### The Master boot record (MBR)[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-master-boot-record-mbr)

The Master Boot Record is the first 512 bytes of the boot disk. The MBR discovers the boot device and loads the bootloader **GRUB2** into memory and transfers control to it.

The next 64 bytes contain the partition table of the disk.

### The GRUB2 bootloader[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-grub2-bootloader)

The default bootloader for the Rocky 8 distribution is **GRUB2** (GRand Unified Bootloader). GRUB2 replaces the old GRUB bootloader (also called GRUB legacy).

The GRUB 2 configuration file is located under `/boot/grub2/grub.cfg` but this file should not be edited directly.

The GRUB2 menu configuration settings are located under `/etc/default/grub` and are used to generate the `grub.cfg` file.

```
# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=rhel/swap crashkernel=auto rd.lvm.lv=rhel/root rhgb quiet net.ifnames=0"
GRUB_DISABLE_RECOVERY="true"
```

If changes are made to one or more of these parameters, the `grub2-mkconfig` command must be run to regenerate the `/boot/grub2/grub.cfg` file.

```
[root] # grub2-mkconfig –o /boot/grub2/grub.cfg
```

- GRUB2 looks for the compressed kernel image (the `vmlinuz` file) in the `/boot` directory.
- GRUB2 loads the kernel image into memory and extracts the contents of the `initramfs` image file into a temporary folder in memory using the `tmpfs` file system.

### The kernel[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-kernel)

The kernel starts the `systemd` process with PID 1.

```
root          1      0  0 02:10 ?        00:00:02 /usr/lib/systemd/systemd --switched-root --system --deserialize 23
```



### `systemd`[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#systemd)

Systemd is the parent of all system processes. It reads the target of the `/etc/systemd/system/default.target` link (e.g. `/usr/lib/systemd/system/multi-user.target`) to determine the default target of the system. The file defines the services to be started.

Systemd then places the system in the target-defined state by performing the following initialization tasks:

1. Set the machine name
2. Initialize the network
3. Initialize SELinux
4. Display the welcome banner
5. Initialize the hardware based on the arguments given to the kernel at boot time
6. Mount the file systems, including virtual file systems like /proc
7. Clean up directories in /var
8. Start the virtual memory (swap)

## Protecting the GRUB2 bootloader[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#protecting-the-grub2-bootloader)

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

## Systemd[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#systemd_1)

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
- Systemd stops or restarts only running services. Previous versions  (before RHEL7) attempted to stop services directly without checking  their current status.
- System services do not inherit any context (like HOME and PATH  environment variables). Each service operates in its own execution  context.

All service unit operations are subject to a default timeout of 5  minutes to prevent a malfunctioning service from freezing the system.

### Managing system services[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#managing-system-services)

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

### Example of a .service file for the postfix service[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#example-of-a-service-file-for-the-postfix-service)

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

### Using system targets[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#using-system-targets)

On Rocky8/RHEL8, the concept of run levels has been replaced by Systemd targets.

Systemd targets are represented by target units. Target units end with the `.target` file extension and their sole purpose is to group other Systemd units into a chain of dependencies.

For example, the `graphical.target` unit, which is used to start a graphical session, starts system services such as the **GNOME display manager** (`gdm.service`) or the **accounts service** (`accounts-daemon.service`) and also activates the `multi-user.target` unit.

Similarly, the `multi-user.target` unit starts other essential system services, such as **NetworkManager** (`NetworkManager.service`) or **D-Bus** (`dbus.service`) and activates another target unit named `basic.target`.

| Target Units      | Description                                               |
| ----------------- | --------------------------------------------------------- |
| poweroff.target   | Shuts down the system and turns it off                    |
| rescue.target     | Activates a rescue shell                                  |
| multi-user.target | Activates a multi-user system without graphical interface |
| graphical.target  | Activates a multi-user system with graphical interface    |
| reboot.target     | Shuts down and restarts the system                        |

#### The default target[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-default-target)

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
local-fs-pre.target    loaded active active Local File Systems (Pre)
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

#### Shutdown, suspension and hibernation[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#shutdown-suspension-and-hibernation)

The `systemctl` command replaces a number of power management commands used in previous versions:

| Old command         | New command              | Description                         |
| ------------------- | ------------------------ | ----------------------------------- |
| `halt`              | `systemctl halt`         | Shuts down the system.              |
| `poweroff`          | `systemctl poweroff`     | Turns off the system.               |
| `reboot`            | `systemctl reboot`       | Restarts the system.                |
| `pm-suspend`        | `systemctl suspend`      | Suspends the system.                |
| `pm-hibernate`      | `systemctl hibernate`    | Hibernates the system.              |
| `pm-suspend-hybrid` | `systemctl hybrid-sleep` | Hibernates and suspends the system. |

### The `journald` process[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#the-journald-process)

Log files can, in addition to `rsyslogd`, also be managed by the `journald` daemon which is a component of `systemd`.

The `journald` daemon captures Syslog messages, kernel log messages, messages from the initial RAM disk and from the start of  boot, as well as messages written to the standard output and the  standard error output of all services, then indexes them and makes them  available to the user.

The format of the native log file, which is a structured and indexed  binary file, improves searches and allows for faster operation, it also  stores metadata information, such as timestamps or user IDs.

### `journalctl` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#journalctl-command)

The `journalctl` command displays the log files.

```
journalctl
```

The command lists all log files generated on the system. The structure of this output is similar to that used in `/var/log/messages/` but it offers some improvements:

- the priority of entries is marked visually;
- timestamps are converted to the local time zone of your system;
- all logged data is displayed, including rotating logs;
- the beginning of a start is marked with a special line.

#### Using continuous display[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#using-continuous-display)

With continuous display, log messages are displayed in real time.

```
journalctl -f
```

This command returns a list of the ten most recent log lines. The  journalctl utility then continues to run and waits for new changes to  occur before displaying them immediately.

#### Filtering messages[¶](https://docs.rockylinux.org/zh/books/admin_guide/10-boot/#filtering-messages)

It is possible to use different filtering methods to extract  information that fits different needs. Log messages are often used to  track erroneous behavior on the system. To view entries with a selected  or higher priority:

```
journalctl -p priority
```

You must replace priority with one of the following keywords (or a number):

- debug (7),
- info (6),
- notice (5),
- warning (4),
- err (3),
- crit (2),
- alert (1),
- and emerg (0).