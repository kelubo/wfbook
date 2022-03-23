# Update

[TOC]

## Arch Linux

```bash
pacman -Syu
```

## Ubuntu

```bash
apt-get update
apt-get upgrade
```

这个命令不会更新内核和其它一些包，所以也必须要运行下面这个命令：

```bash
apt-get dist-upgrade
```

## openSUSE

```bash
zypper refresh
zypper up
```

## Fedora

```bash
dnf update
dnf upgrade
```

## RHEL/CentOS

```bash
# 列出主机上尚未安装的所有可用安全更新
yum updateinfo list updates security

# 列出在主机上安装的安全更新
yum updateinfo list security --installed  #CentOS 7.9.2009 上测试不可用
yum updateinfo list security installed    #CentOS 7.9.2009 上测试可用

# 显示可用于更新的特定公告信息
yum updateinfo info <Update ID>

# 安装安全更新
yum update --security

# 安装特定的公告
yum update --advisory=<Update ID>

# 在安装更新的软件包后，列出需要手动重启系统的进程
yum needs-restarting                      #CentOS 7.9.2009 上测试不可用

yum update
yum upgrade
```

### 自动更新

```bash
yum update -y && yum install yum-cron -y
```

#### CentOS/RHEL 7

```bash
/etc/yum/yum-cron.conf

update_cmd = security
update_messages = yes
download_updates = yes
apply_updates = yes

emit_via = email
email_from = root@localhost
email_to = root
```

#### CentOS/RHEL 6

默认情况下， cron 任务被配置成了立即下载并安装所有更新，可以通过在 /etc/sysconfig/yum-cron 配置文件中把下面两个参数改为 yes，从而改变这种行为。

```bash
# 不要安装，只做检查（有效值： yes|no）
CHECK_ONLY=yes
# 不要安装，只做检查和下载（有效值： yes|no）
# 要求 CHECK_ONLY=yes（先要检查后才可以知道要下载什么）
DOWNLOAD_ONLY=yes
```

为了启用关于安装包更新的邮件通知，你需要把 MAILTO 参数设置为一个有效的邮件地址。

```bash
# 默认情况下 MAILTO 是没有设置的，crond 会将输出发送邮件给自己
# （LCTT 译注：执行 cron 的用户，这里是 root）
# 例子： MAILTO=root
MAILTO=admin@tecmint.com
```

#### 打开并启用 yum-cron 服务：

```bash
------------- On CentOS/RHEL 7 -------------
systemctl start yum-cron
systemctl enable yum-cron

------------- On CentOS/RHEL 6 -------------  
service yum-cron start
chkconfig --level 35 yum-cron on
```
