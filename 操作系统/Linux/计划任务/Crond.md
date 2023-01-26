# cron

Linux提供了 *cron* 系统，一个基于时间的作业调度程序，用于自动化进程。很简单，也很强大。

有不同的分支(或者叫变体)，它们具有相同的功能。

- cronie
- dcron
- fcron
- bcron
- cronsun

*crontab* 本质上是一个列表，用户可以在其中添加自己的自动化任务和作业，并且有许多可以进一步简化操作的选项。

cron 服务在系统后台运行，并且会持续地检查 ` /etc/crontab` 文件和 ```/etc/cron.*/```目录。它同样也会检查 `/var/spool/cron/` 目录。

## 安装

### CentOS

```bash
yum install crontabs
```

- **cronie** - 软件包名称。
- **crontab** - 命令，用于维护每个用户的crontab（任务时间表）。
- **crond.service** - cronie的守护进程，可以通过`systemctl start | restart | stop |status`的方式管理守护进程。
- **/etc/crontab** - 给不同的用户分配 cron jobs，通常更加习惯使用 `crontab -e` 的方式。
- **/var/log/cron\*** - cronie的日志，默认情况下，做了日志轮替，以日期后缀结尾。* 这里表示通配符。
- **anacron** - 属于 cronie 的一部分。

## crontab 命令

crontab 是用来安装、卸载或者列出定时任务列表的命令。cron 配置文件则用于驱动 Vixie Cron 的 cron(8) 守护进程。每个用户都可以拥有自己的 crontab 文件，虽然这些文件都位于 /var/spool/cron/crontabs 目录中，但并不意味着你可以直接编辑它们。你需要通过 crontab 命令来编辑或者配置你自己的定时任务。`crontab`代表"cron table"，文件的格式实际上是松散的表布局。这个文件中存储了需要执行的脚本或命令的调度列表以及执行时间。

### crontab文件的类型

**UNIX 或 Linux 的系统级 crontab :**  

此类型通常只被 root 用户或守护进程用于配置系统级别的任务。位于 `/etc/crontab` 中，并且只能由 root 用户访问和编辑。第六个字段为用户名，用来指定此命令以哪个用户身份来执行。

**用户的 crontab:**  

用户可以使用 crontab 命令来安装属于他们自己的定时任务。 第六个字段为需要运行的命令, 所有的命令都会以创建该 crontab 任务的用户的身份运行。所有 cron 任务都存储在 `/var/spool/cron`（对于 RHEL 和 CentOS 发行版）和 `/var/spool/cron/crontabs`（对于 Debian 和 Ubuntu 发行版）中，cron 任务使用创建该文件的用户的用户名列出。 `/var/cron/tabs/` 

编辑 crontab 文件：

```bash
crontab -e

# 编辑此文件以引入要由 cron 运行的任务。
#
# 一行定义一个要运行的任务
# 在一行中用不同的字段指示何时运行该任务
# 以及为该任务运行的命令
#
# 要定义时间，可以为
# 分钟（m）、小时（h）、月日（dom）、月（mon）和星期（dow）
# 提供具体值，或者在这些字段中使用"*"（表示"任何"）。
#
# 注意，将根据 cron 的系统守护程序的时间和
# 时区概念启动任务。
#
# 作业的输出（包括错误）通过电子邮件发送给
# crontab 文件所属的用户（除非重定向）。
# cron
# 例如，每周一上午 5 点运行所有用户
# 帐户的备份：
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# 有关更多信息，请参见 crontab（5）和 cron（8）的手册页
#
# m h  dom mon dow   command

# 如果 SHELL 行被忽略，cron 会使用默认的 sh shell。
# 如果 PATH 变量被忽略，就没有默认的搜索路径，所有的文件都需要使用绝对路径来定位。
# 如果 HOME 变量被忽略，cron 会使用调用者（用户）的家目录替代。
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# run-parts
01 * * * * root run-parts /etc/cron.hourly
02 4 * * * root run-parts /etc/cron.daily
22 4 * * 0 root run-parts /etc/cron.weekly
42 4 1 * * root run-parts /etc/cron.monthly
```

### crontab 语法（字段介绍）

语法为：

```bash
1 2 3 4 5 /path/to/command arg1 arg2
```

或者

```bash
1 2 3 4 5 /root/ntp_sync.sh
```

其中：

```bash
第1个字段：分钟 (0-59)
第2个字段：小时 (0-23)
第3个字段：日期 (1-31)
第4个字段：月份 (1-12 [12 代表 December])
第5个字段：一周当中的某天 (0-7 [7 或 0 代表星期天])
/path/to/command - 计划执行的脚本或命令的名称
```

便于记忆的格式：

```bash
* * * * * 要执行的命令
----------------
| | | | |
| | | | ---- 周当中的某天 (0 - 7) (周日为 0 或 7)
| | | ------ 月份 (1 - 12)
| | -------- 一月当中的某天 (1 - 31)
| ---------- 小时 (0 - 23)
------------ 分钟 (0 - 59)
```

### 使用操作符

操作符允许你为一个字段指定多个值，这里有三个操作符可供使用：

**星号 (*) :** 此操作符为字段指定所有可用的值。举个例子，在小时字段中，一个星号等同于每个小时。

**逗号 (,) : ** 这个操作符指定了一个包含多个值的列表，例如：1,5,10,15,20,25.

**横杠 (-) :** 此操作符指定了一个值的范围，例如：5-15 ，等同于使用逗号操作符键入的 5,6,7,8,9,...,13,14,15。

**分隔符 (/) :** 此操作符指定了一个步进值，例如： 0-23/ 可以用于小时字段来指定某个命令每小时被执行一次。步进值也可以跟在星号操作符后边，如果你希望命令行每 2 小时执行一次，则可以使用 ```*/2```。

```ini
*/2  *   *   *   *   /usr/local/sbin/backup
```

各种操作符可联用：

```ini
*/2  *   *   *   1,3,5   /usr/local/sbin/backup
*/2  *   *   *   1-5     /usr/local/sbin/backup
```

星号（*）指定命令应该在每一个时间阶段执行。也就是说，如果*是写在cron作业中的小时字段中，那么命令就会每小时执行一次。与此类似，如果你希望在某个特定时段执行命令，那么就在对应的时间字段中指定时段，并用逗号分隔（例如要在第5分钟和第10分钟运行命令，那就在分钟字段中输入"5, 10"）。还有另一个不错的选项可以让我们以特定的时间间隔运行命令。在分钟字段使用*/5，可以每5分钟运行一次命令。这个技巧可以用在任何时间字段。一个cron表条目是由一行或多行cron作业组成的。cron表条目中的每一行都是一项作业。例如：
编写一个crontab条目的样例：02 * * * * /home/slynux/test.sh
这个cron作业会在每天各小时的第2分钟执行脚本test.sh。
要在每天的第5、6、7小时执行脚本：00 5,6,7 * * /home/slynux/test.sh
在周日的每个小时执行脚本script.sh：00 */12 * * 0 /home/slynux/script.sh
在每天凌晨2点钟关闭计算机：00 02 * * * /sbin/shutdown -h



### 禁用邮件输出

默认情况下，某个命令或者脚本的输出内容（如果有的话）会发送到你的本地邮箱账户中。若想停止接收 crontab 发送的邮件，需要添加 >/dev/null 2>&1 这段内容到执行的命令的后面，例如：

```bash
0 3 * * * /root/backup.sh >/dev/null 2>&1
```

如果想将输出内容发送到特定的邮件账户中，比如说 vivek@nixcraft.in 这个邮箱， 则你需要像下面这样定义一个 MAILTO 变量：

```bash
MAILTO="vivek@nixcraft.in"
0 3 * * * /root/backup.sh >/dev/null 2>&1
```







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

### 使用特殊字符串节省编写 cron 任务的时间 @

在严格计划的时间(即日、周、月、年等)运行作业的方法，是使用 @选项，它提供使用更自然的时间的能力。

@选项包括：

- `@hourly` 在每天每小时的 0 分钟后运行脚本。(这也正是将你的脚本放在`/etc/cron.hourly`中的结果）。等效于 `0 * * * *` 。
- `@daily` 在每天午夜运行脚本。等效于 `0 0 * * *` 。
- `@weekly` 在每周的周日午夜运行脚本。等效于 `0 0 * * 0` 。
- `@monthly` 在每个月的第一天午夜运行脚本。等效于 `0 0 1 * *` 。
- `@yearly` 在每年 1 月 1 日午夜运行脚本。等效于 `0 0 1 1 *` 。
- `@reboot` 仅在系统启动时运行脚本。
- `@annually` 	(同 `@yearly`)
- `@midnight` 	(同 `@daily`)

**注意：**

使用这些`crontab`条目将绕过`anacron`系统，无论是否安装了`anacron`，都会恢复为`crond.service`。

对于备份脚本示例，如果使用 @daily 选项在午夜运行备份脚本，则该条目将如下所示：

```ini
@daily  /usr/local/sbin/backup
```

![](D:\Git\wfbook\Image\c\cron.jpg)

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







如果在脚本中调用crontab进行任务调度，那么有另外两种方法可供使用：
(1) 创建一个文本文件（例如task.cron），并写入cron作业。
然后将文件名作为命令参数，运行crontab： crontab task.cron
(2) 通过下面的方法，我们可以在行内（inline）指定cron作业，而无需创建单独的文件。例如：crontab＜＜EOF02 * * * * /home/slynux/script.shEOF
cron作业需要写在crontab＜＜EOF和EOF之间。
执行cron作业所使用的权限同执行crontab命令所使用的权限相同。如果你需要执行要求更高权限的命令，例如关闭计算机，那么就要以超级用户身份执行crontab。
在cron作业中指定的命令需要使用完整路径。这是因为执行cron作业时的环境与终端所使用的环境不同，因此环境变量PATH可能都没有设置。如果命令运行时需要设置某些环境变量，你应该明确设定出来。

例如，如果你使用的是代理服务器连接Internet，要调度某个需要使用Internet的命令，你就得设置HTTP代理环境变量http_proxy，可以用下面的方法来完成：crontab＜＜EOFhttp_proxy=http://192.168.03:312800 * * * * /home/slynux/download.shEOF