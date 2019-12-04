# cron
cron 服务在系统后台运行，并且会持续地检查 ` /etc/crontab` 文件和 ```/etc/cron.*/```目录。它同样也会检查 `/var/spool/cron/` 目录。

## 安装

### CentOS

```bash
yum install crontabs
```

## crontab 命令
crontab 是用来安装、卸载或者列出定时任务列表的命令。cron 配置文件则用于驱动 Vixie Cron 的 cron(8) 守护进程。每个用户都可以拥有自己的 crontab 文件，虽然这些文件都位于 /var/spool/cron/crontabs 目录中，但并不意味着你可以直接编辑它们。你需要通过 crontab 命令来编辑或者配置你自己的定时任务。

### crontab文件的类型
**UNIX 或 Linux 的系统级 crontab :**  

此类型通常由那些需要 root 或类似权限的系统服务和重要任务使用。位于 `/etc/crontab` 中，并且只能由 root 用户访问和编辑。第六个字段为用户名，用来指定此命令以哪个用户身份来执行。

**用户的 crontab:**  

用户可以使用 crontab 命令来安装属于他们自己的定时任务。 第六个字段为需要运行的命令, 所有的命令都会以创建该 crontab 任务的用户的身份运行。所有 cron 任务都存储在 `/var/spool/cron`（对于 RHEL 和 CentOS 发行版）和 `/var/spool/cron/crontabs`（对于 Debian 和 Ubuntu 发行版）中，cron 任务使用创建该文件的用户的用户名列出。

编辑 crontab 文件：

```bash
crontab -e
```

### crontab 语法（字段介绍）

语法为：

    1 2 3 4 5 /path/to/command arg1 arg2

或者

    1 2 3 4 5 /root/ntp_sync.sh

其中：

    第1个字段：分钟 (0-59)
    第2个字段：小时 (0-23)
    第3个字段：日期 (1-31)
    第4个字段：月份 (1-12 [12 代表 December])
    第5个字段：一周当中的某天 (0-7 [7 或 0 代表星期天])
    /path/to/command - 计划执行的脚本或命令的名称

便于记忆的格式：

    * * * * * 要执行的命令
    ----------------
    | | | | |
    | | | | ---- 周当中的某天 (0 - 7) (周日为 0 或 7)
    | | | ------ 月份 (1 - 12)
    | | -------- 一月当中的某天 (1 - 31)
    | ---------- 小时 (0 - 23)
    ------------ 分钟 (0 - 59)

### 使用操作符

操作符允许你为一个字段指定多个值，这里有三个操作符可供使用：

**星号 (*) :** 此操作符为字段指定所有可用的值。举个例子，在小时字段中，一个星号等同于每个小时。

**逗号 (,) : ** 这个操作符指定了一个包含多个值的列表，例如：1,5,10,15,20,25.

**横杠 (-) :** 此操作符指定了一个值的范围，例如：5-15 ，等同于使用逗号操作符键入的 5,6,7,8,9,...,13,14,15。

**分隔符 (/) :** 此操作符指定了一个步进值，例如： 0-23/ 可以用于小时字段来指定某个命令每小时被执行一次。步进值也可以跟在星号操作符后边，如果你希望命令行每 2 小时执行一次，则可以使用 ```*/2```。

### 禁用邮件输出

默认情况下，某个命令或者脚本的输出内容（如果有的话）会发送到你的本地邮箱账户中。若想停止接收 crontab 发送的邮件，需要添加 >/dev/null 2>&1 这段内容到执行的命令的后面，例如：

    0 3 * * * /root/backup.sh >/dev/null 2>&1

如果想将输出内容发送到特定的邮件账户中，比如说 vivek@nixcraft.in 这个邮箱， 则你需要像下面这样定义一个 MAILTO 变量：

    MAILTO="vivek@nixcraft.in"
    0 3 * * * /root/backup.sh >/dev/null 2>&1



关于 /etc/crontab 文件和 /etc/cron.d/* 目录的更多内容

/etc/crontab 是系统的 crontab 文件。通常只被 root 用户或守护进程用于配置系统级别的任务。每个单独的用户必须像上面介绍的那样使用 crontab 命令来安装和编辑自己的任务。/var/spool/cron/ 或者 /var/cron/tabs/ 目录存放了个人用户的 crontab 文件，它应该备份在用户的家目录当中。
理解默认的 /etc/crontab 文件

典型的 /etc/crontab 文件内容是这样的：

    SHELL=/bin/bash
    PATH=/sbin:/bin:/usr/sbin:/usr/bin
    MAILTO=root
    HOME=/
    # run-parts
    01 * * * * root run-parts /etc/cron.hourly
    02 4 * * * root run-parts /etc/cron.daily
    22 4 * * 0 root run-parts /etc/cron.weekly
    42 4 1 * * root run-parts /etc/cron.monthly

首先，环境变量必须被定义。如果 SHELL 行被忽略，cron 会使用默认的 sh shell。如果 PATH 变量被忽略，就没有默认的搜索路径，所有的文件都需要使用绝对路径来定位。如果 HOME 变量被忽略，cron 会使用调用者（用户）的家目录替代。

另外，cron 会读取 /etc/cron.d/目录中的文件。通常情况下，像 sa-update 或者 sysstat 这样的系统守护进程会将他们的定时任务存放在此处。作为 root 用户或者超级用户，你可以使用以下目录来配置你的定时任务。你可以直接将脚本放到这里。run-parts命令会通过 /etc/crontab 文件来运行位于某个目录中的脚本或者程序。
目录	描述
/etc/cron.d/ 	将所有的脚本文件放在此处，并从 /etc/crontab 文件中调用它们。
/etc/cron.daily/ 	运行需要 每天 运行一次的脚本
/etc/cron.hourly/ 	运行需要 每小时 运行一次的脚本
/etc/cron.monthly/ 	运行需要 每月 运行一次的脚本
/etc/cron.weekly/ 	运行需要 每周 运行一次的脚本
备份定时任务

    # crontab -l > /path/to/file
    # crontab -u user -l > /path/to/file

### 管理 cron 任务

#### 创建 cron 任务

要以 root 用户身份创建或编辑 cron 任务，请运行以下命令：

```bash
crontab -e
```

要为另一个用户创建或安排 cron 任务，请使用以下语法：

```bash
crontab -u username -e
```

例如，要以 Pradeep 用户身份运行 cron 任务，请发出以下命令：

```bash
crontab -u Pradeep -e
```

如果该 crontab 文件尚不存在，那么你将打开一个空白文本文件。如果该 crontab 文件已经存在，则 `-e` 选项会让你编辑该文件，

#### 列出 crontab 文件

要查看已创建的 cron 任务，只需传递 `-l` 选项：

```bash
crontab -l
crontab -u username -l
```

#### 删除 crontab 文件

要删除 cron 任务，只需运行 `crontab -e` 并删除所需的 cron 任务行，然后保存该文件。

要删除所有的 cron 任务，请运行以下命令：

```bash
crontab -r
# 删除某用户名下的定时任务，此命令需以 root 用户身份执行
crontab -r -u username
```

### 使用 crontab 安排任务示例

如图所示，所有 cron 任务文件都带有释伴shebang标头。

```
#!/bin/bash
```

接下来，使用我们之前指定的 cron 任务条目指定要安排任务的时间间隔。

要每天下午 12:30 重启系统，请使用以下语法：

```
30  12 *  *  * /sbin/reboot
```

要安排在凌晨 4:00 重启，请使用以下语法：

```
0  4  *  *  *  /sbin/reboot
```

注：星号 `*` 用于匹配所有记录。

要每天两次运行脚本（例如，凌晨 4:00 和下午 4:00），请使用以下语法：

```
0  4,16  *  *  *  /path/to/script
```

要安排 cron 任务在每个星期五下午 5:00 运行，请使用以下语法：

```
0  17  *  *  Fri  /path/to/script
```

或

```
0 17  *  *  *  5  /path/to/script
```

如果你希望每 30 分钟运行一次 cron 任务，请使用：

```
*/30  *  *  *  * /path/to/script
```

要安排 cron 任务每 5 小时运行一次，请运行：

```
*  */5  *  *  *  /path/to/script
```

要在选定的日期（例如，星期三和星期五的下午 6:00）运行脚本，请执行以下操作：

```
0  18  *  *  wed,fri  /path/to/script
```

要使用单个 cron 任务运行多个命令，请使用分号分隔任务，例如：

```
*  *  *  *  *  /path/to/script1 ; /path/to/script2
```

### 使用特殊字符串节省编写 cron 任务的时间

某些 cron 任务可以使用对应于特定时间间隔的特殊字符串轻松配置。例如，

1）`@hourly` 时间戳等效于 `0 * * * *`
2）`@daily` 时间戳等效于 `0 0 * * *`
3）`@weekly` 时间戳等效于 `0 0 * * 0`
4）`@monthly` 时间戳等效于 `0 0 1 * *`
5）`@yearly` 时间戳等效于 `0 0 1 1 *`
6）`@reboot` 	在每次启动时运行一次
7）`@annually` 	(同 `@yearly`)
8）`@midnight` 	(同 `@daily`)

### 限制 crontab

可以使用 `/etc/cron.deny` 和 `/etc/cron.allow` 文件来控制。默认情况下，只有一个 `/etc/cron.deny` 文件，并且不包含任何条目。要限制用户使用 `crontab` 实用程序，将用户的用户名添加到该文件中。当用户添加到该文件中，并且该用户尝试运行 `crontab` 命令时，他/她将遇到以下错误。

要允许用户继续使用 `crontab` 实用程序，只需从 `/etc/cron.deny` 文件中删除用户名即可。

如果存在 `/etc/cron.allow` 文件，则仅文件中列出的用户可以访问和使用 `crontab` 实用程序。

如果两个文件都不存在，则只有 root 用户具有使用 `crontab` 命令的特权。

### 备份 crontab 条目

```bash
crontab -l > /path/to/file.txt
```

### 检查 cron 日志

cron 日志存储在 `/var/log/cron` 文件中。