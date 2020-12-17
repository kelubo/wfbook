# 重置 root 密码

[TOC]

## RHEL7/CentOS7

**启动进入最小模式**

重启系统并在内核列表页面在系统启动之前按下 e。进入编辑模式。

**中断启动进程**

在内核字符串中 - 在以 linux 16 /vmlinuz- ect 结尾的行中输入 rd.break。接着 Ctrl+X 重启。系统启动进入初始化内存磁盘，并挂载在 /sysroot。在此模式中不需要输入密码。

**重新挂载文件系统以便读写**

```bash
mount -o remount,rw /sysroot/
```

**使 /sysroot 成为根目录**

```bash
chroot /sysroot
```

命令行提示符会稍微改变。

**修改 root 密码**

```bash
passwd
```

**加载 SELinux 策略**

```bash
load_policy -i
```

在 /etc/shadow 中设置上下文类型

```bash
chcon -t shadow_t /etc/shadow
```

注意：可以通过如下创建 autorelabel 文件的方式来略过最后两步，但自动重建卷标会花费很长时间。

```bash
touch /.autorelabel
```

**退出并重启**

退出并重启并用新的 root 密码登录。

## SUSE Enterprise Linux 11

1. 启动grub时候选择 Failsave, 下面的“boot option“内容全部删除，写入`init=/bin/bash`，进入单用户模式。
2. 出现命令行

```bash
(none)#:#mount -o remount, rw /
```

 根文件系统重新mount为可读写。

```bsh
cd /usr/bin
passwd root
```

> 注：
>
> 如果usr分区是单独分的，此处会报错。可通过再将usr分区挂载后，重复扫行上面的步骤。如usr分区们于/dev/sda5分区上，执行下面的命令：
>
> ```bash
> mount /dev/sda5 /usr
> ```
> 