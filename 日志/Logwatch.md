# How to install and configure Logwatch 如何安装和配置Logwatch 

Logs are an invaluable source of information about problems that may arise in your server.  [Logwatch](https://sourceforge.net/projects/logwatch/) keeps an eye on your logs for you, flags items that may be of interest, and reports them via email.
对于服务器中可能出现的问题，日志是非常宝贵的信息来源。Logwatch会为您关注您的日志，标记可能感兴趣的项目，并通过电子邮件报告它们。

## Install `logwatch` 安装 `logwatch` 

Install `logwatch` using the following command:
使用以下命令安装 `logwatch` ：

```bash
sudo apt install logwatch
```

You will also need to manually create a temporary directory in order for it to work:
您还需要手动创建一个临时目录才能使其工作： 

```bash
sudo mkdir /var/cache/logwatch
```

## Configure `logwatch` 配置 `logwatch` 

Logwatch’s default configuration is kept in` /usr/share/logwatch/default.conf/logwatch.conf`. However, configuration changes made directly to that file can be  overwritten during updates, so instead the file should be copied into `/etc` and modified there:
Logwatch的默认配置保存在 ` /usr/share/logwatch/default.conf/logwatch.conf` 中。但是，直接对该文件进行的配置更改可能会在更新期间被覆盖，因此应该将该文件复制到 `/etc` 并在那里进行修改：

```auto
sudo cp /usr/share/logwatch/default.conf/logwatch.conf /etc/logwatch/conf/
```

With your favorite editor, open `/etc/logwatch/conf/logwatch.conf`.  The uncommented lines indicate the default configuration values.  First, lets customise some of the basics:
使用您最喜欢的编辑器，打开 `/etc/logwatch/conf/logwatch.conf` 。未注释的行指示默认配置值。首先，让我们自定义一些基础知识：

```plaintext
Output = mail
MailTo = me@mydomain.org
MailFrom = logwatch@host1.mydomain.org
Detail = Low
Service = All
```

This assumes you’ve already set up mail services on `host1` that will allow mail to be delivered to your `me@mydomain.org` address. These emails will be addressed from `logwatch@host1.mydomain.org`.
这假定您已经在 `host1` 上设置了邮件服务，允许将邮件发送到您的 `me@mydomain.org` 地址。这些电子邮件将从 `logwatch@host1.mydomain.org` 开始处理。

The **Detail** level defines how much information is included in the reports. Possible values are: `Low`, `Medium`, and `High`.
详细级别定义报告中包含的信息量。可能的值为： `Low` 、 `Medium` 和 `High` 。

Logwatch will then monitor logs for all services on the system, unless specified otherwise with the **Service** parameter.  If there are undesired services included in the reports, they can be disabled by removing them with additional **Service** fields. E.g.:
Logwatch将监视系统上所有服务的日志，除非Service参数另有指定。如果报告中包含不需要的服务，则可以通过使用其他服务字段将其删除来禁用这些服务。例如：

```plaintext
Service = "-http"
Service = "-eximstats"
```

Next, run `logwatch` manually to verify your configuration changes are valid:
接下来，手动运行 `logwatch` 以验证您的配置更改是否有效：

```bash
sudo logwatch --detail Low --range today
```

The report produced should look something like this:
生成的报告应该是这样的： 

> \################### Logwatch 7.4.3 (12/07/16) ####################
> \# Logwatch 7.4.3（12/07/16）#
>  Processing Initiated: Fri Apr 24 16:58:14 2020
>  处理启动日期：2020年4月24日星期五16：58：14
>  Date Range Processed: today
>  处理日期范围：今天
>  ( 2020-Apr-24 ) （2020-Apr-24）
>  Period is day. 句号是一天。
>  Detail Level of Output: 0
>  输出的详细程度：0
>  Type of Output/Format: stdout / text
>  输出类型/格式：stdout / text
>  Logfiles for Host: `host1.mydomain.org`
>  主机的日志文件： `host1.mydomain.org` 
>  \##################################################################
>
> --------------------- pam_unix Begin ------------------------
> \- pam_unix开始-- 
>
> sudo: sudo：
>  Sessions Opened: 会议开幕：
>  bryce → root: 1 Time(s)
>  bryce → root：1 Time（s）
>
> ---------------------- pam_unix End -------------------------
> -- pam_unix结束- 
>
> --------------------- rsnapshot Begin ------------------------
> -- rsnapshot开始- 
>
> ERRORS: 医生：
>  /usr/bin/rsnapshot hourly: completed, but with some errors: 5 Time(s)
>  /usr/bin/rsnapshot hourly：已完成，但有一些错误：5时间
>  /usr/bin/rsync returned 127 while processing root@host2:/etc/: 5 Time(s)
>  /usr/bin/rsync在处理root@host2时返回127：/etc/：5时间
>  /usr/bin/rsync returned 127 while processing root@host2:/home/: 5 Time(s)
>  /usr/bin/rsync在处理root@host2：/home/时返回127：5时间
>  /usr/bin/rsync returned 127 while processing root@host2:/proc/uptime: 5 Time(s)
>  /usr/bin/rsync在处理root@host2时返回127：/proc/error：5时间
>  /usr/bin/rsync returned 127 while processing root@host3:/etc/: 5 Time(s)
>  /usr/bin/rsync在处理root@host3时返回127：/etc/：5时间
>  /usr/bin/rsync returned 127 while processing root@host3:/home/: 5 Time(s)
>  /usr/bin/rsync在处理root@host3：/home/时返回127：5时间
>  /usr/bin/rsync returned 127 while processing root@host3:/proc/uptime: 5 Time(s)
>  /usr/bin/rsync在处理root@host3时返回127：/proc/root：5 Time（s）
>
> ---------------------- rsnapshot End -------------------------
> ------------------------ rsnapshot结束--------------------- 
>
> --------------------- SSHD Begin ------------------------
> \- SSHD开始- 
>
> Users logging in through sshd:
> 通过sshd登录的用户：
>  bryce: 布莱斯：
>  192.168.1.123 (`host4.mydomain.org`): 1 time
>  192.168.1.123（ `host4.mydomain.org` ）：1次
>
> ---------------------- SSHD End -------------------------
> -- SSHD结束-- 
>
> --------------------- Sudo (secure-log) Begin ------------------------
> -- Sudo（secure-log）开始-- 
>
> bryce => root
>  \-------------
>  /bin/bash                      -   1 Time(s).
>  /bin/bash - 1 Time（s）.
>
> ---------------------- Sudo (secure-log) End -------------------------
> --------------------- Sudo（secure-log）End ------------------------ 
>
> --------------------- Disk Space Begin ------------------------
> --磁盘空间开始-- 
>
> Filesystem      Size  Used Avail Use% Mounted on
> 已使用的文件存储器大小可用使用%装载于
>  /dev/sdc1       220G   19G  190G   9% /
>  /dev/sdc1 220G 19G 190G 9%/
>  /dev/loop1      157M  157M     0 100% /snap/gnome-3-28-1804/110
>  /dev/loop1 157M 157M 0 100%/snap/gnome—3—28—1804/110
>  /dev/loop11     1.0M  1.0M     0 100% /snap/gnome-logs/81
>  /dev/loop11 1.0M 1.0M 0 100%/snap/gnome—logs/81
>  /dev/md5        9.1T  7.3T  1.8T  81% /srv/Products
>  /dev/md5 9.1T 7.3T 1.8T 81%/srv/产品
>  /dev/md6        9.1T  5.6T  3.5T  62% /srv/Archives
>  /dev/md6 9.1T 5.6T 3.5T 62%/srv/档案
>  /dev/loop14     3.8M  3.8M     0 100% /snap/gnome-system-monitor/127
>  /dev/loop14 3.8M 3.8M 0 100%/snap/gnome—system—monitor/127
>  /dev/loop17      15M   15M     0 100% /snap/gnome-characters/399
>  /dev/loop17 15M 15M 0 100%/snap/gnome—characters/399
>  /dev/loop18     161M  161M     0 100% /snap/gnome-3-28-1804/116
>  /dev/loop18 161M 161M 0 100%/snap/gnome—3—28—1804/116
>  /dev/loop6       55M   55M     0 100% /snap/core18/1668
>  /dev/loop6 55M 55M 0 100%/snap/core18/1668
>  /dev/md1        1.8T  1.3T  548G  71% /srv/Staff
>  /dev/md1 1.8T 1.3T 548G 71%/srv/Staff
>  /dev/md0        3.6T  3.5T   84G  98% /srv/Backup
>  /dev/md0 3.6T 3.5T 84G 98%/srv/Backup
>  /dev/loop2      1.0M  1.0M     0 100% /snap/gnome-logs/93
>  /dev/loop2 1.0M 1.0M 0 100%/snap/gnome—logs/93
>  /dev/loop5       15M   15M     0 100% /snap/gnome-characters/495
>  /dev/loop5 15M 15M 0 100%/snap/gnome—characters/495
>  /dev/loop8      3.8M  3.8M     0 100% /snap/gnome-system-monitor/135
>  /dev/loop8 3.8M 3.8M 0 100%/snap/gnome—system—monitor/135
>  /dev/md7        3.6T  495G  3.0T  15% /srv/Customers
>  /dev/md7 3.6T 495G 3.0T 15%/srv/客户
>  /dev/loop9       55M   55M     0 100% /snap/core18/1705
>  /dev/loop9 55M 55M 0 100%/snap/core18/1705
>  /dev/loop10      94M   94M     0 100% /snap/core/8935
>  /dev/loop10 94M 94M 0 100%/snap/core/8935
>  /dev/loop0       55M   55M     0 100% /snap/gtk-common-themes/1502
>  /dev/loop0 55M 55M 0 100%/snap/gtk—common—themes/1502
>  /dev/loop4       63M   63M     0 100% /snap/gtk-common-themes/1506
>  /dev/loop4 63M 63M 0 100%/snap/gtk—common—themes/1506
>  /dev/loop3       94M   94M     0 100% /snap/core/9066
>  /dev/loop3 94M 94M 0 100%/snap/core/9066
>
> /srv/Backup (/dev/md0) => 98% Used. Warning. Disk Filling up.
> /srv/Backup（/dev/md 0）=> 98%已使用。警告磁盘正在填充。 
>
> ---------------------- Disk Space End -------------------------
> --磁盘空间结束- 
>
> \###################### Logwatch End #########################
> \#日志监视结束## 

## Further reading 进一步阅读 

- The [Ubuntu manpage for logwatch](https://manpages.ubuntu.com/manpages/jammy/en/man8/logwatch.8.html) contains many more detailed options.
  logwatch的Ubuntu手册页包含许多更详细的选项。

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          [                   Previous 先前                    Logging, Monitoring and Alerting (LMA)
日志记录、监视和警报（LMA）                  ](https://ubuntu.com/server/docs/set-up-your-lma-stack)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 [                   Next 下 ](https://ubuntu.com/server/docs/how-to-install-and-configure-munin)