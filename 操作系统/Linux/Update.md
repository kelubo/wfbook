# Update

[TOC]

## 概述

对系统管理员来说，管理安全更新的安装是一件重要的事情。

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

## RHEL / CentOS

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

#### 通过 `yum-cron` 更新

```bash
yum update -y && yum install yum-cron -y
```

根据需要设置配置：

```bash
/etc/yum/yum-cron.conf

[commands]
#  What kind of update to use:
# default                            = yum upgrade
# security                           = yum --security upgrade
# security-severity:Critical         = yum --sec-severity=Critical upgrade
# minimal                            = yum --bugfix update-minimal
# minimal-security                   = yum --security update-minimal
# minimal-security-severity:Critical =  --sec-severity=Critical update-minimal
update_cmd = default

# Whether a message should be emitted when updates are available,
# were downloaded, or applied.
update_messages = yes

# Whether updates should be downloaded when they are available.
download_updates = yes

# Whether updates should be applied when they are available.  Note
# that download_updates must also be yes for the update to be applied.
apply_updates = yes

# Maximum amout of time to randomly sleep, in minutes.  The program
# will sleep for a random amount of time between 0 and random_sleep
# minutes before running.  This is useful for e.g. staggering the
# times that multiple systems will access update servers.  If
# random_sleep is 0 or negative, the program will run immediately.
# 6*60 = 360
random_sleep = 30

emit_via = email
email_from = root@localhost
email_to = root
```

启用并启动服务：

```bash
systemctl enable --now yum-cron

------------- On CentOS/RHEL 7 -------------
systemctl start yum-cron
systemctl enable yum-cron

------------- On CentOS/RHEL 6 -------------  
service yum-cron start
chkconfig --level 35 yum-cron on
```

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

#### 通过 `dnf-automatic` 更新

##### 安装

```bash
dnf install dnf-automatic
```

##### 配置

默认情况下，更新过程将在早上 6 点开始，并有一个随机的额外时间增量，以避免所有机器同时更新。若要更改此行为，必须覆盖与应用程序服务关联的计时器配置：

```bash
systemctl edit dnf-automatic.timer

[Unit]
Description=dnf-automatic timer
# See comment in dnf-makecache.service
ConditionPathExists=!/run/ostree-booted
Wants=network-online.target

[Timer]
OnCalendar=*-*-* 6:00
RandomizedDelaySec=10m
Persistent=true

[Install]
WantedBy=timers.target
```

此配置减少了早上 6:00 到 6:10 分之间的启动延迟。（此时将关闭的服务器将在重新启动后自动进行修补。）

然后激活与服务相关联的计时器（而不是服务本身）：

```bash
systemctl enable --now dnf-automatic.timer
```



红帽安全公告（Red Hat Security Advisories，简称 RHSA）记录了有关红帽产品和服务中安全漏洞的信息。 		

每个 RHSA 包括以下信息： 		

- 严重性 				
- 类型和状态 				
- 受影响的产品 				
- 修复问题的摘要 				
- 问题相关的报告链接。请注意，不是所有的报告都是公开的。 				
- 公共漏洞和暴露（Common Vulnerabilities and Exposures，简称 CVE）编号以及更多详情（如攻击复杂性）的链接。 				

红帽客户门户（Red Hat Customer Portal）提供了红帽发布的红帽安全公告列表。您可以通过访问红帽安全公告列表中的公告 ID 来显示特定公告的详情。 		

**图 1.1. 安全公告列表**

[![客户门户网站列表中安全公告 rhel9](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_and_monitoring_security_updates-zh-CN/images/92730a9b9723abc51744d30fb5cfac33/customer-portal-list-security-advisories-rhel9.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Managing_and_monitoring_security_updates-zh-CN/images/92730a9b9723abc51744d30fb5cfac33/customer-portal-list-security-advisories-rhel9.png)

​				此外，您还可以根据特定产品、变体、版本和架构过滤结果。例如，要只显示 Red Hat Enterprise Linux 9 公告，您可以设置以下过滤器： 		

- ​						产品：Red Hat Enterprise Linux 				
- ​						变体：所有变体 				
- ​						版本：9 				
- ​						（可选）选择一个次版本。 				

**其他资源**

- ​						[红帽安全公告列表](https://access.redhat.com/security/security-updates) 				
- ​						[红帽安全公告分析](https://access.redhat.com/blogs/766093/posts/1975923) 				
- ​						[红帽客户门户网站](https://access.redhat.com/front) 				

## 1.2. 显示主机上未安装的安全更新

​				您可以使用 `dnf` 实用程序列出系统的所有可用安全更新。 		

**前提条件**

- ​						附加到主机的红帽订阅。 				

**步骤**

- ​						列出主机上尚未安装的所有可用安全更新： 				

  ```none
  # dnf updateinfo list updates security
  ...
  RHSA-2019:0997 Important/Sec. platform-python-3.6.8-2.el8_0.x86_64
  RHSA-2019:0997 Important/Sec. python3-libs-3.6.8-2.el8_0.x86_64
  RHSA-2019:0990 Moderate/Sec.  systemd-239-13.el8_0.3.x86_64
  ...
  ```

## 1.3. 显示在主机上安装的安全更新

​				您可以使用 `dnf` 实用程序列出已安装系统的安全更新。 		

**步骤**

- ​						列出主机上安装的所有安全更新： 				

  ```none
  # dnf updateinfo list security --installed
  ...
  RHSA-2019:1234 Important/Sec. libssh2-1.8.0-7.module+el8+2833+c7d6d092
  RHSA-2019:4567 Important/Sec. python3-libs-3.6.7.1.el8.x86_64
  RHSA-2019:8901 Important/Sec. python3-libs-3.6.8-1.el8.x86_64
  ...
  ```

  ​						如果安装了多个软件包更新，`dnf` 将列出该软件包的所有公告。在上例中，自系统安装以来，已安装了 `python3-libs` 软件包的两个安全更新。 				

## 1.4. 使用 dnf 显示特定公告

​				您可以使用 `dnf` 实用程序显示可用于更新的特定公告信息。 		

**先决条件**

- ​						附加到主机的红帽订阅。 				
- ​						您有一个安全公告`更新 ID`。请参阅[识别安全公告更新](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_and_monitoring_security_updates/identifying-security-updates_managing-and-monitoring-security-updates)。 				
- ​						公告提供的更新没有安装。 				

**步骤**

- ​						显示一个特定公告： 				

  ```none
  # dnf updateinfo info <Update ID>
  ====================================================================
    Important: python3 security update
  ====================================================================
    Update ID: RHSA-2019:0997
         Type: security
      Updated: 2019-05-07 05:41:52
         Bugs: 1688543 - CVE-2019-9636 python: Information Disclosure due to urlsplit improper NFKC normalization
         CVEs: CVE-2019-9636
  Description: ...
  ```

  ​						将 *更新 ID* 替换为所需的公告。例如： `# dnf updateinfo info *<RHSA-2019:0997>*`。 				

# 第 2 章 安装安全更新

## 2.1. 安装所有可用的安全更新

​				要保持系统的安全性，您可以使用 `dnf` 工具安装所有当前可用的安全更新。 		

**前提条件**

- ​						附加到主机的红帽订阅。 				

**步骤**

1. ​						使用 `dnf` 工具安装安全更新： 				

   ```none
   # dnf update --security
   ```

   注意

   ​							`--security` 参数非常重要。如果没有它，`dnf update` 会安装所有更新，包括错误修复和增强。 					

2. ​						按 **y** 确认并启动安装： 				

   ```none
   ...
   Transaction Summary
   ===========================================
   Upgrade  ... Packages
   
   Total download size: ... M
   Is this ok [y/d/N]: y
   ```

3. ​						可选：在安装更新的软件包后列出需要手动重启系统的进程： 				

   ```none
   # dnf needs-restarting
   1107 : /usr/sbin/rsyslogd -n
   1199 : -bash
   ```

   注意

   ​							此命令仅列出需要重启的进程，而不是服务。也就是说，您无法使用 `systemctl` 实用程序重启列出的进程。例如，当拥有此进程的用户注销时，输出中的 `bash` 进程将被终止。 					

## 2.2. 安装特定公告提供的安全更新

​				在某些情况下，您可能只希望安装特定的更新。例如，某个特定的服务可以在不需要停机的情况下进行更新，您可以只为该服务安装安全更新，并在以后安装剩余的安全更新。 		

**先决条件**

- ​						附加到主机的红帽订阅。 				
- ​						您有一个安全公告更新 ID。请参阅[识别安全公告更新](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/managing_and_monitoring_security_updates/identifying-security-updates_managing-and-monitoring-security-updates)。 				

**步骤**

1. ​						安装特定的公告： 				

   ```none
   # dnf update --advisory=<Update ID>
   ```

   ​						将 *更新 ID* 替换为所需的公告。例如： `#dnf update --advisory= <*RHSA-2019:0997>*` 				

2. ​						按 `y` 确认并启动安装： 				

   ```none
   ...
   Transaction Summary
   ===========================================
   Upgrade  ... Packages
   
   Total download size: ... M
   Is this ok [y/d/N]: y
   ```

3. ​						可选：在安装更新的软件包后列出需要手动重启系统的进程： 				

   ```none
   # dnf needs-restarting
   1107 : /usr/sbin/rsyslogd -n
   1199 : -bash
   ```

   注意

   ​							此命令仅列出需要重启的进程，而不是服务。这意味着您无法使用 `systemctl` 工具重启所有列出的进程。例如，当拥有此进程的用户注销时，输出中的 `bash` 进程将被终止。 					

## 2.3. 其他资源

- ​						请参阅[安全固化](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/index)文档中保护工作站和服务器安全的做法。 				
- ​						[Security-Enhanced Linux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/index) 文档。 				
