# anacron- 定期运行命令

[TOC]

## 简介

一般而言，cron 不能弥补因为系统宕机或者机器时间出现不连续的情况而错过执行的命令。不过，Vixie-cron 的确在努力，对于每隔一个小时以上的时间才执行一次的任务来说，如果时间的变化不到 3 个小时，仍然争取让任务正确执行。对于在时间上的小调整，比如像美国夏时制这样的情况，它能处理得不错。

膝上机以及其他并不长期开机的机器与 cron 的关系更不好，采用 cron 的候补软件对它们有好处。anacron 这个软件对 cron 有很好的补充作用，它是一种按照时间间隔来安排任务执行的工具。如果在系统的默认安装里没有包括 anacron，可以通过系统默认的软件包管理系统来安装它。

在 anacron 这个软件的世界里，用户只需要求某条特殊的命令每星期执行一次，但用不着指定它在每周一的凌晨 2 点执行。anacron 和 cron 不同，它维护着每条命令最近执行时间的记录，所以它只要比较这个时间、指定的时间间隔，以及当前时间就能判定是否需要再次执行命令。

anacron 提供了几种功能，有助于避免新启动的计算机对同时维护的大量任务应接不暇的问题。启动每项任务的延迟时间都不同，anacron 将命令逐条运行，所以一次只有一条命令激活。对于系统管理任务来说，按时间间隔来安排执行，要比安排固定时间执行的方式更有用。遗憾的是，anacron 要求它的时间间隔按天来表示，这个事实限制了 anacron 作为一种一线的日程安排执行工具的功用。

anacron 本身必须在 cron 里使用。虽然 anacron 安排时间的粒度是天，但是每天多运行 anacron 几次就会有意义——如果知道 cron 始终能够在每天同一时间运行 anacron，那么可能就不会首先考虑使用 anacron 了。类似地，在系统启动的时候运行 anacron 也会有意义。

Anacron 用于定期运行命令，运行频率以天为单位，适于在不全天候 `7*24` 运行的计算机上。假设有一个计划任务要在每天凌晨使用 crontab 运行，但此时台式机/笔记本电脑已经关闭，则任务将不会执行。但是，如果使用 anacron，下次再次打开台式机/笔记本电脑时，将执行该任务。

Anacron 的出现并不是取代 crontab，而是与 crontab 相互补充。关系如下图：

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
4. 开机 5 分钟检查有文件是否被执行，当执行第一个后，再随机延迟 0～45 分钟执行下一个。
5. 使用 nice 参数指定默认优先级，使用 `run-parts` 参数执行 `/etc/cron.daily/` 目录中所有的可执行文件。

## 相关命令

使用到的命令 `anacron`，常用选项有：

| 选项 | 说明                                       |
| ---- | ------------------------------------------ |
| -f   | 执行所有的作业，忽略时间戳                 |
| -u   | 不执行任何任务的情况下更新时间戳为当前时间 |
| -T   | 测试配置文件 /etc/anacrontab 的有效性      |

```
https://man7.org/linux/man-pages/man8/anacron.8.html
    
    anacron - runs commands periodically
```

## SYNOPSIS      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       anacron [-s] [-f] [-n] [-d] [-q] [-t anacrontab] [-S spooldir]
       [job]
       anacron [-S spooldir] -u [-t anacrontab] [job]
       anacron [-V|-h]
       anacron -T [-t anacrontab]
```

## DESCRIPTION      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       Anacron is used to execute commands periodically, with a
       frequency specified in days.  Unlike cron(8), it does not assume
       that the machine is running continuously.  Hence, it can be used
       on machines that are not running 24 hours a day to control
       regular jobs as daily, weekly, and monthly jobs.

       Anacron reads a list of jobs from the /etc/anacrontab
       configuration file (see anacrontab(5)).  This file contains the
       list of jobs that Anacron controls.  Each job entry specifies a
       period in days, a delay in minutes, a unique job identifier, and
       a shell command.

       For each job, Anacron checks whether this job has been executed
       in the last n days, where n is the time period specified for that
       job.  If a job has not been executed in n days or more, Anacron
       runs the job's shell command, after waiting for the number of
       minutes specified as the delay parameter.

       After the command exits, Anacron records the date (excludes the
       hour) in a special timestamp file for that job, so it knows when
       to execute that job again.

       When there are no more jobs to be run, Anacron exits.

       Anacron only considers jobs whose identifier, as specified in
       anacrontab(5), matches any of the job command-line arguments.
       The job command-line arguments can be represented by shell
       wildcard patterns (be sure to protect them from your shell with
       adequate quoting).  Specifying no job command-line arguments is
       equivalent to specifying "*"  (that is, all jobs are considered
       by Anacron).

       Unless Anacron is run with the -d option (specified below), it
       forks to the background when it starts, and any parent processes
       exit immediately.

       Unless Anacron is run with the -s or -n options, it starts jobs
       immediately when their delay is over.  The execution of different
       jobs is completely independent.

       If an executed job generates any output to standard output or to
       standard error, the output is mailed to the user under whom
       Anacron is running (usually root), or to the address specified in
       the MAILTO environment variable in the /etc/anacrontab file, if
       such exists.  If the LOGNAME environment variable is set, it is
       used in the From: field of the mail.

       Any informative messages generated by Anacron are sent to
       syslogd(8) or rsyslogd(8) under with facility set to cron and
       priority set to notice.  Any error messages are sent with the
       priority error.

       "Active" jobs (i.e., jobs that Anacron already decided to run and
       are now waiting for their delay to pass, and jobs that are
       currently being executed by Anacron), are "locked", so that other
       copies of Anacron cannot run them at the same time.
```

## OPTIONS      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       -f     Forces execution of all jobs, ignoring any timestamps.

       -u     Updates the timestamps of all jobs to the current date,
              but does not run any.

       -s     Serializes execution of jobs.  Anacron does not start a
              new job before the previous one finished.

       -n     Runs jobs immediately and ignores the specified delays in
              the /etc/anacrontab file.  This options implies -s.

       -d     Does not fork Anacron to the background.  In this mode,
              Anacron will output informational messages to standard
              error, as well as to syslog.  The output of any job is
              mailed by Anacron.

       -q     Suppresses any messages to standard error.  Only
              applicable with -d.

       -t some_anacrontab
              Uses the specified anacrontab, rather than the
              /etc/anacrontab default one.

       -T     Anacrontab testing. Tests the /etc/anacrontab
              configuration file for validity. If there is an error in
              the file, it is shown on the standard output and Anacron
              returns the value of 1.  Valid anacrontabs return the
              value of 0.

       -S spooldir
              Uses the specified spooldir to store timestamps in.  This
              option is required for users who wish to run anacron
              themselves.

       -V     Prints version information, and exits.

       -h     Prints short usage message, and exits.
```

## SIGNALS      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       After receiving a SIGUSR1 signal, Anacron waits for any running
       jobs to finish and then exits.  This can be used to stop Anacron
       cleanly.
```

## NOTES      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       Make sure your time-zone is set correctly before Anacron is
       started since the time-zone affects the date.  This is usually
       accomplished by setting the TZ environment variable, or by
       installing a /usr/lib/zoneinfo/localtime file.  See tzset(3) for
       more information.

       Timestamp files are created in the spool directory for each job
       specified in an anacrontab.  These files are never removed
       automatically by Anacron, and should be removed by hand if a job
       is no longer being scheduled.
```

## FILES      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       /etc/anacrontab
              Contains specifications of jobs.  See anacrontab(5) for a
              complete description.

       /var/spool/anacron
              This directory is used by Anacron for storing timestamp
              files.
```

## SEE ALSO      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       anacrontab(5), cron(8), tzset(3)

       The Anacron README file.
```

## BUGS      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       Anacron never removes timestamp files.  Remove unused files
       manually.

       Anacron uses up to two file descriptors for each active job.  It
       may run out of descriptors if there are lots of active jobs.  See
       echo $(($(ulimit -n) / 2)) for information how many concurrent
       jobs anacron may run.

       Mail comments, suggestions and bug reports to Sean 'Shaleh' Perry
       ⟨shaleh@(debian.org|valinux.com)⟩.
```

## AUTHOR      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       Anacron was originally conceived and implemented by Christian
       Schwarz ⟨schwarz@monet.m.isar.de⟩.

       The current implementation is a complete rewrite by Itai Tzur
       ⟨itzur@actcom.co.il⟩.

       The code base was maintained by Sean 'Shaleh' Perry ⟨shaleh@
       (debian.org|valinux.com)⟩.

       Since 2004, it is maintained by Pascal Hakim ⟨pasc@(debian.org|
       redellipse.net)⟩.

       For Fedora, Anacron is maintained by Marcela Mašláňová
       ⟨mmaslano@redhat.com⟩.
```

## COLOPHON      [top](https://man7.org/linux/man-pages/man8/anacron.8.html#top_of_page)

```
       This page is part of the cronie (crond daemon) project.
       Information about the project can be found at 
       ⟨https://github.com/cronie-crond/cronie⟩.  If you have a bug
       report for this manual page, see
       ⟨https://github.com/cronie-crond/cronie/issues⟩.  This page was
       obtained from the project's upstream Git repository
       ⟨https://github.com/cronie-crond/cronie.git⟩ on 2022-12-17.  (At
       that time, the date of the most recent commit that was found in
       the repository was 2022-12-16.)  If you discover any rendering
       problems in this HTML version of the page, or you believe there
       is a better or more up-to-date source for the page, or you have
       corrections or improvements to the information in this COLOPHON
       (which is not part of the original manual page), send a mail to
       man-pages@man7.org
```
