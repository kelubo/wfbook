# anacron- 定期运行命令

[TOC]

## 简介

anacron 用于定期运行命令，运行频率以天为单位进行定义，适用于在笔记本电脑和台式机等不会全天候 `7*24` 运行的计算机上。假设有一个计划的任务要在每天凌晨使用 crontab 运行，但台式机/笔记本电脑已经关闭，则任务将不会执行。但是，如果使用 anacron，下次再次打开台式机/笔记本电脑时，将执行该任务。

anacron 的出现并不是取代 crontab，而是与 crontab 相互补充。关系如下图：

![](../../../Image/a/anacron.png)

## 配置文件

相关文件列表：

```bash
rpm -ql cronie-anacron
=============================================================
/etc/anacrontab
/etc/cron.hourly/0anacron
/usr/lib/.build-id
/usr/lib/.build-id/0e
/usr/lib/.build-id/0e/6b094fa55505597cb69dc5a6b7f5f30b04d40f
/usr/sbin/anacron
/usr/share/man/man5/anacrontab.5.gz
/usr/share/man/man8/anacron.8.gz
/var/spool/anacron
/var/spool/anacron/cron.daily
/var/spool/anacron/cron.monthly
/var/spool/anacron/cron.weekly
```

默认的配置文件 `/etc/anacontab` ：

```bash
# /etc/anacrontab: configuration file for anacron
# See anacron(8) and anacrontab(5) for details.
SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# 默认45分钟，指定anacron中每个作业的延迟将随机增加0到45分钟。
RANDOM_DELAY=45
# 指定工作的时间范围，这里表示3：00~22：00
START_HOURS_RANGE=3-22
# period in days   delay in minutes   job-identifier   command
# 每天开机5分钟后就检查 /etc/cron.daily 目录内的文件是否被执行
1        5   cron.daily      nice run-parts /etc/cron.daily
# 每隔7天开机后25分钟检查 /etc/cron.weekly 目录内的文件是否被执行
7        25  cron.weekly     nice run-parts /etc/cron.weekly
# 每隔一个月开机后 45 分钟检查 /etc/cron.monthly 目录内的文件是否被执行
@monthly 45  cron.monthly    nice run-parts /etc/cron.monthly
```

## 执行过程

用 cron.daily 工作来说明一下 /etc/anacrontab 的执行过程:

1. anacron 读取 `/var/spool/anacron/cron.daily` 文件，文件内容显示为上一次执行的时间。
2. 和当前的时间比较，如果两个时间的差值超过 1 天，就执行 cron.daily 工作。
3. 只能在 03：00-22：00 执行这个工作。
4. 开机5分钟检查有文件是否被执行，当执行第一个后，再随机延迟 0～45 分钟执行下一个。
5. 使用 nice 参数指定默认优先级，使用 `run-parts` 参数执行 `/etc/cron.daily/` 目录中所有的可执行文件。

## 相关命令

使用到的命令 `anacron`，常用选项有：

| 选项 | 说明                                       |
| ---- | ------------------------------------------ |
| -f   | 执行所有的作业，忽略时间戳                 |
| -u   | 不执行任何作用的情况下更新时间戳为当前时间 |
| -T   | 测试配置文件/etc/anacrontab的有效性        |
