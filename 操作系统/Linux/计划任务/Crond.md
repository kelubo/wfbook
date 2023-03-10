# cron

[TOC]

## 概述

Linux提供了 cron 系统，一个基于时间的作业调度程序，用于自动化进程。

有不同的分支(或者叫变体)，它们具有相同的功能：

- cronie
- dcron
- fcron
- bcron
- cronsun

crontab 本质上是一个列表，用户可以在其中添加自己的自动化任务和作业，并且有许多可以进一步简化操作的选项。

cron 服务在系统后台运行，并且会持续地检查 ` /etc/crontab` 文件和 `/etc/cron.*/` 目录。它同样也会检查 `/var/spool/cron/` 目录。

## 安装

### CentOS

```bash
yum install crontabs
```

- **cronie**                -   软件包名称。
- **crontab**             -   命令，用于维护每个用户的 crontab（任务时间表）。
- **crond.service**  -   cronie 的守护进程，可以通过 `systemctl start | restart | stop |status` 的方式管理守护进程。
- **/etc/crontab**    -   给不同的用户分配 cron job，通常更加习惯使用 `crontab -e` 的方式。
- **/var/log/cron\*** -   cronie 的日志，默认情况下，做了日志轮替，以日期后缀结尾。`* 这里表示通配符。
- **anacron**             -   属于 cronie 的一部分。

## crontab 命令

用来安装、卸载或者列出定时任务列表。cron 配置文件则用于驱动 Vixie Cron 的 cron(8) 守护进程。每个用户都可以拥有自己的 crontab 文件，虽然这些文件都位于 `/var/spool/cron/crontabs` 目录中，但并不意味着可以直接编辑它们。需要通过 crontab 命令来编辑或者配置定时任务。crontab 代表 "cron table"，文件的格式实际上是松散的表布局。这个文件中存储了需要执行的脚本或命令的调度列表以及执行时间。

另外，cron 会读取 /etc/cron.d/ 目录中的文件。通常情况下，像 sa-update 或者 sysstat 这样的系统守护进程会将他们的定时任务存放在此处。作为 root 用户或者超级用户，你可以使用以下目录来配置你的定时任务。你可以直接将脚本放到这里。run-parts 命令会通过 /etc/crontab 文件来运行位于某个目录中的脚本或者程序。

## crontab 文件的类型

### UNIX / Linux 系统级 crontab  

此类型通常只被 root 用户或守护进程用于配置系统级别的任务。位于 `/etc/crontab` 中，并且只能由 root 用户访问和编辑。第六个字段为用户名，用来指定此命令以哪个用户身份来执行。

### 用户的 crontab  

用户可以使用 crontab 命令来配置自己的定时任务。 第六个字段为需要运行的命令, 所有的命令都会以创建该 crontab 任务的用户的身份运行。所有 cron 任务都存储在 `/var/spool/cron`（对于 RHEL 和 CentOS 发行版）和 `/var/spool/cron/crontabs`（对于 Debian 和 Ubuntu 发行版）中，cron 任务使用创建该文件的用户的用户名列出。 `/var/cron/tabs/` 

## crontab 文件

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



## crontab 语法（字段介绍）

```bash
1 2 3 4 5 /path/to/command arg1 arg2
```

![](D:\Git\wfbook\Image\c\cron.jpg)

其中：

```bash
第1个字段：分钟 (0-59)
第2个字段：小时 (0-23)
第3个字段：日期 (1-31)
第4个字段：月份 (1-12 [12 代表 December])
第5个字段：一周当中的某天 (0-7 [7 或 0 代表星期天])
/path/to/command - 计划执行的脚本或命令的名称
```

### 使用操作符

操作符允许为一个字段指定多个值，这里有三个操作符可供使用：

**星号 (*) :** 此操作符为字段指定所有可用的值。举个例子，在小时字段中，一个星号等同于每个小时。

**逗号 (,) : ** 这个操作符指定了一个包含多个值的列表，例如：1,5,10,15,20,25.

**横杠 (-) :** 此操作符指定了一个值的范围，例如：5-15 ，等同于使用逗号操作符键入的 5,6,7,8,9,...,13,14,15。

**分隔符 (/) :** 此操作符指定了一个步进值，例如： 0-23/ 可以用于小时字段来指定某个命令每小时被执行一次。步进值也可以跟在星号操作符后边，如果你希望命令行每 2 小时执行一次，则可以使用 ```*/2```。

```bash
*/2  *   *   *   *   /usr/local/sbin/backup
```

各种操作符可联用：

```bash
*/2  *   *   *   1,3,5   /usr/local/sbin/backup
*/2  *   *   *   1-5     /usr/local/sbin/backup
```



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

使用这些 `crontab` 条目将绕过 `anacron` 系统，无论是否安装了 `anacron`，都会恢复为 `crond.service` 。

对于备份脚本示例，如果使用 @daily 选项在午夜运行备份脚本，则该条目将如下所示：

```ini
@daily  /usr/local/sbin/backup
```

| 目录               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| /etc/cron.d/       | 将所有的脚本文件放在此处，并从 /etc/crontab 文件中调用它们。 |
| /etc/cron.daily/   | 运行需要 每天 运行一次的脚本                                 |
| /etc/cron.hourly/  | 运行需要 每小时 运行一次的脚本                               |
| /etc/cron.monthly/ | 运行需要 每月 运行一次的脚本                                 |
| /etc/cron.weekly/  | 运行需要 每周 运行一次的脚本                                 |

### 备份 crontab 条目

```bash
crontab -l > /path/to/file.txt
```

### 限制 crontab

可以使用 `/etc/cron.deny` 和 `/etc/cron.allow` 文件来控制。默认情况下，只有一个 `/etc/cron.deny` 文件，并且不包含任何条目。要限制用户使用 `crontab` 实用程序，将用户的用户名添加到该文件中。当用户添加到该文件中，并且该用户尝试运行 `crontab` 命令时，他/她将遇到以下错误。

要允许用户继续使用 `crontab` 实用程序，只需从 `/etc/cron.deny` 文件中删除用户名即可。

如果存在 `/etc/cron.allow` 文件，则仅文件中列出的用户可以访问和使用 `crontab` 实用程序。

如果两个文件都不存在，则只有 root 用户具有使用 `crontab` 命令的特权。

## cron 日志

cron 日志存储在 `/var/log/cron` 文件中。

Linux为流程自动化提供了 *cron* 系统，一个基于时间的作业计划器。 它是很简单，但却相当强大。 想要一个脚本或程序每天在 5 PM运行吗？ 这是您设置的地方。

*crontab* 基本上是一个用户添加自己的自动任务和工作的列表。 而且它有一些可以进一步简化事情的备选办法。 本文将探讨其中的一些问题。 对于那些具有一些经验的人来说，这是一个很好的温习，新用户可以将 `cron` 系统添加到他们的知识中。

`anacron` 在这里以 `cron` "dot" 目录的形式简短讨论。 `anacron` 由 `cron`运行， 而且对并非一直都在使用的机器，如工作站和笔记本计算机具有优势。 原因是 `cron` 按计划运行任务， 如果计划任务时机器已关闭，任务将不运行。 使用 `anacron` 当机器再次运行时，任务会被拿起并运行。 即使计划运行是过去。 `anacron` 不过，在时间不准确的情况下，使用更多的随机方式来运行任务。 这对工作站和膝上型计算机来说是可以的，但对服务器来说却是不合适的。  这可能是像服务器备份这样的问题，而这种备份需要在特定时间运行。 那就是 `cron` 继续为服务器管理员提供最好的解决方案。 尽管如此，服务器管理员和工作站或笔记本电脑用户可以从这两种方法中获得一些好处。 您可以根据您的需要轻松地混合和匹配。  关于 `anacron` 的更多信息，见 [anacron - 自动命令](https://docs.rockylinux.org/zh/guides/automation/anacron/)。

### 启动简单- `cron.d` 目录[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#-crond)

现在构建到许多版本的 Linux 系统中， `cron` "dot" 目录有助于快速自动处理。 这些将被 `cron` 根据他们的命名约定进行调用。 然而，他们被不同的调用，基于谁来调用他们， `anacron` 或 `cron` 默认行为是使用 `anacron`, 但这可以由服务器、 工作站或笔记本管理员来更改。

#### 服务器[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#_4)

如导言所述， `cron` 通常运行 `anacron` 这些天来执行这些"dot"目录中的脚本。 你 *可能*, 但也想要在服务器上使用这些"点"目录, 如果情况是这样。 然后您可以采取两个步骤来确保这些"点"目录是按严格的时间表运行的。 为此，我们需要安装一个软件包并删除另一个软件包：

```
dnf install cronie-noanacron
```

和

```
dnf remove cronie-anacron
```

正如你可能期望的那样，这将从服务器上移除 `anacron` 并恢复到严格的计划中的“dot”目录内的任务。 这个定义在了: `/etc/cron.d/dailyjob`, 其中包含以下内容：

```
# 每日运行，每周运行， 如果未安装 cronie-anacron
SHELL=/bin/bash
PATH=/sbin:/usr/sbin:/bin
MAILTO=root

# run-parts
02 * * * * root [ ！ -f /etc/cron.hourly/0anacron ] && run-part /etc/cron.day
22 4 * 0 root [ ! -f /etc/cron.hourly/0anacron ] && run-parts /etc/cron.weekly
42 4 1 * * root [ ! -f /etc/cron.hourly/0anacron ] && run-parts /etc/cron.monthly
```

这就意味着：

- 运行脚本 `cron.daily` 于每日04:02:00。
- 运行脚本`cron.weekly` 于每周的周日 04:22:00。
- 运行脚本 `cron.monthly` 于每月第一天04:42:00。

#### 工作站[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#_5)

如果您想要在一个工作站或笔记本电脑在 `cron`  "."目录中运行脚本 那么你不需要做任何特殊事。 只需将您的脚本文件复制到相关目录，并确保它是可执行的。 以下是这些目录：

- `/etc/cron.hourly` - 放置在这里的脚本将每小时运行一次。 (这是由 `cron` 运行的，无论 `anacron` 是否安装)
- `/etc/cron.daily` - 放在这里的脚本将每天运行。 `anacron` 调整了这些任务的时间。 （参考提示）
- `/etc/cron.week` - 放置在这里的脚本每7天运行一次。 （参考提示）
- `/etc/cron.monthly` - 放在这里的脚本将每月运行。 （参考提示）

提示

这些活动很可能每天、每周和每月都会在类似（但并非完全相同）的情况下进行。 更确切的运行时间，请参阅下面的@options

所以让系统自动运行您的脚本，让您也能正常运行， 并且允许他们在指定的时间段内运行，然后它会使任务自动化变得非常容易。

说明

没有规定说服务器管理员不能随意运行 'anacron' 的"."目录中的脚本。 对此使用的大小写将是一个不具有时间敏感性的脚本。

### 创建您自己的 `cron`[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#cron)

当然，如果自动、随机化的时间在 [对超过](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#for-workstations)的工作站来说不那么合适， 和 [中的预定时间。对于前面提到](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#for-servers)的服务器，你可以创建自己的计划任务。 在这个例子中，我们认为您是root用户。 [见前提条件](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#assumptions) 要做到这一点，请输入以下内容：

```
crontab -e
```

这将会拉取根用户的 `crontab` 内容，将会显示在您选定的编辑器中，可能看起来就像这样。 继续阅读里面的注释内容，因为它包含了我们下一步操作的说明：

```
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# cron
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
```

请注意这个特殊的 `crontab` 文件有自己的文档内置. 情况并非总是如此。 在容器或最低操作系统上修改 `crontab` 时， `crontab` 将是一个空文件，除非已经有条目已经放入它。

让我们假设我们有一个备份脚本，我们想要在晚上运行10个PM。 `crontab` 使用了一个24小时钟，所以这将是22:00。 让我们假定备份脚本叫做“backup”，它目前位于 */usr/local/sbin* 目录中。

说明

请记住，这个脚本也需要可执行(`chmod +x`)，才能运行 `cron` 。

要添加作业，我们将：

```
crontab -e
```

`crontab` 表示"cron table"，文件的格式实际上是一个松散的表布局。 现在我们在 `crontab`中，转到文件的底部，然后添加您的新条目。 如果您使用 `vi` 作为您的系统默认编辑器，那么使用以下按键完成：

```
Shift : $
```

现在你处于文件底部， 插入一行并输入简短的注释来描述您的条目正在发生什么事情。 这是通过在行首添加一个“#”来完成的：

```
# 每晚在 10PM 上备份系统
```

现在按回车键。 您仍然应该在插入模式，下一步是添加您的条目。 如 `crontab` 上面的注释 所示，这将是 **m** 分钟， **h** 小时数， **dom** (day of month) 一个月的某天， **mon** 月份 ， **dow**(day of week) 一周的某天。

如果每天10:00时运行我们的备份脚本，该条目看起来就像这样：

```
00 22 * * /usr/local/sbin/backup
```

这表明脚本是每月10 PM，每个月每天、每个月和每周的每一天都是如此。 显然，这是一个非常简单的例子，当你需要具体的时候，事情可能会变得相当复杂。

### `crontab的@选项`[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#crontab)

另一种在严格规定的时间(即白天、周、月份、年份等)进行工作的方式 使用 @options 提供了使用更加自然的时间的能力。 @options 由以下内容组成：

- `@hourly` 每小时 0 分钟运行脚本。 (这正是将您的脚本放入 `/etc/cron.hourly` 的结果)
- `@daily` 每天午夜运行脚本。
- `@weekly` 每周在星期日午夜运行脚本。
- `@monthly` 每月在该月第一天午夜运行脚本。
- `@year` 每年在1月第一天午夜运行脚本。
- `@reboot` 仅在系统启动时运行脚本。

说明

使用这些`crontab`条目绕过了`anacron`系统，并恢复到`crond.service`，不管是否安装了`anacron`。

对于我们的备份脚本示例，如果我们使用 @daily 选项在午夜运行备份脚本，那么该条目看起来就像这样：

```
@day/usr/local/sbin/backup
```

### 更多复杂选项[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#_6)

到目前为止，我们所谈到的一切都有相当简单的选择，但是更复杂的任务时间是怎样呢？ 比如说，你想要每隔10分钟运行一次你的备份脚本(可能不是一个非常实际的事情需要做的。 但，嘿，这是一个例子！)。 要做到这一点，您将写：

```
*/10  *   *   *   *   /usr/local/sbin/backup
```

如果你想每隔10分钟、但仅在星期一、星期三和星期五运行备份怎么办？

```
*/10  *   *   *   1,3,5   /usr/local/sbin/backup
```

除星期六和星期天外，每隔10分钟？

```
*/10  *   *   *    1-5    /usr/local/sbin/backup
```

在表中，逗号让您在一个字段中指定单独的条目。 当破折号允许您在字段中指定一个值范围。 这可以同时在任何一个字段和多个字段发生。 如您所见，事情可能变得相当复杂。

当决定何时运行脚本时，您需要花费时间并规划它，尤其是如果标准很复杂。

## 结语[¶](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/#_7)

*cron/crontab* 系统是Rocky Linux系统管理员或桌面用户非常强大的工具。 它可以允许您自动执行任务和脚本，这样您就不必记住手动运行它们了。 这里提供了更多的例子：

- 对于那些 **不**是24小时运行的机器，浏览 [anacron - 自动化命令](https://docs.rockylinux.org/zh/guides/automation/anacron/).
- 关于 `cron` 的简明描述，请参阅 [cronie - 计划任务](https://docs.rockylinux.org/zh/guides/automation/cronie/)

虽然基础知识非常容易，但你可以得到更多的复杂程度。 关于 `crontab` 的更多信息，直到 [crontab 手册页面](https://man7.org/linux/man-pages/man5/crontab.5.html)。 在大多数系统中，您也可以输入 `man crontab` 获取额外的命令细节。 您也可以简单地进行网页搜索“crontab”，为您提供丰富的结果，帮助您提高 `crontab` 技能。

## cron 介绍[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#cron)

GNU/Linux提供 *cron* 系统，这是一个基于时间的 `cron` 自动化流程的作业程序。 它是很简单，但却相当强大。 想要一个脚本或程序每天在 5 pm 运行？ `cron` 可以做到。 `cron`的不同分支(或变量)，具有相同的功能。 在这个文档中，使用 **cronie** ，版本为 1.5.2。 您可以点击 [here](https://github .com/cronie-cronie-cronie/cronie) 查找最新版本并更新日志。

## cronie的描述[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#cronie)

- **cronie** -包名, Rocky Linux 默认包含cronie;
- **crontab** -命令为每个用户保留 `crontab` (任务计划)；
- **crond.service** -cronie 的守护程序，您可以通过 `systemctl 启动来管理守护进程 | 重启 | 停止 | 状态`;
- **/etc/crontab** -将cron 任务分配给不同的用户，通常我们更习惯于使用 `crontab-e`。 例如，如果您目前是以 root 用户身份登录， 输入 `crontab -e` 并在保存后您将在文件 /var/spool/cron/root 中看到特定的 cron 作业。
- **/var/log/cron \***  -Cronie 的日志，默认情况下是日志旋转并以日期后缀结尾。 * 此表示通配符
- **anacron** -cronie的一部分 关于 `anacron` 的更多信息，见 [anacron - 自动命令](https://docs.rockylinux.org/zh/guides/automation/anacron/)。 关于 `anacron` 的更多信息，见 [anacron - 自动命令](https://docs.rockylinux.org/zh/guides/automation/anacron/)。

## `ceontab` 命令[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#ceontab)

`crontab` 是安装cronie 软件包后获得的命令。 与 `anacron`, 它更适合于每天工作7*24小时的服务器。 `crontab` 的常见选项是：

```
-e # 编辑定时任务
-l # 查看定时任务
-r # 删除所有当前用户的 crontab任务
```

## Cronie的使用[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#cronie_1)

为了允许不同的用户在不同时间执行不同的命令(或脚本)，他们可以写入这个文件。 然而，我们通常更习惯使用 `crontab -e`。

```
shell > cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/usr/bin
MAILTO=root
# 详细信息见man 4 crontab
# 作业定义示例：
# 。
--------------- 分钟(0-59)
# | .------------ 小时 (0-23)
# | . ------------ 月份(1-31)
# | | .-------- 月 (1-12个月) 或 jan,feb,mar,apr ...
# | | | | . --- 每周一天(0-6) (unday=0 或 7) 或日,蒙,tue,wed,thu,fri,, 在
# | | | | | | |
# * * * * * 需要执行的用户名称命令
```

| 参数     | 含义             | 取值范围            |
| -------- | ---------------- | ------------------- |
| 1st*     | 一小时的第一分钟 | 0-59                |
| 2nd*     | 一天中的每小时   | 0-23                |
| 3rd*     | 月中的某一天     | 1-31                |
| The 4th* | 年度月           | 1-12                |
| The 5th* | 一周中的一天     | 0-7(0和7均表示周日) |

在这个示例中，假定您作为根用户执行此操作。 输入以下内容： `crontab -e`, 这将提升根用户的定时任务 如果您使用 `vi` 作为默认系统编辑器， 按 i  键进入插入模式， 输入以下内容，# 表示这是一条注释行。 按 Esc 退出插入模式，请输入：wq (显示在底部) 保存并退出 `vi`这意味着每晚22:00时运行脚本。 显然，这是一个非常简单的例子，当你需要详细阐述时，情况可能变得非常复杂。

```
# 晚间10：00 备份系统
00 * * /usr/local/sbin/备份
```

!!! !!! tip "注意"

```
脚本需要先执行权限 (chmod +x`) 才能运行它。
```

#### 复杂选项[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#_2)

迄今为止，讨论的内容是非常简单的选择，但是如何完成更复杂的定时任务？

```
# 假设你想要运行每10分钟备份脚本(可能不切实际，但它只是一个例子！ ) 整天都是如此。 为此目的， 以下将写入：
* /10 * * * * /usr/local/sbin/backup
#如果你只想在星期一每10分钟运行一个备份怎么办。 星期三和星期五？ :
* /10 * * 1,3,5 /usr/local/sbin/backup
# 除了星期六和星期天之外, 每天10分钟一次，如何备份？
* /10 *  *  * 1-5 /usr/local/sbin/backup
```

| 特殊符号 | 含义                                                         |
| -------- | ------------------------------------------------------------ |
| *        | 代表任何时间。 例如，第一个*是指任何分钟，第二个*是指任何一小时 |
| ,        | 代表连续时间，例如"08,12,16***", 这意味着命令将在每天8:00、12:00和16:00执行一次 |
| -        | 代表一个连续的时间范围，例如“05* * 1-6”， 这意味着一个命令将在星期一至星期六每天早上5点被执行 |
| */n      | 表示执行间隔的频率，例如"*/10 **  *  " 表示每隔10分钟执行    |

!!! !!! tip "注意"

```
Cronie能够识别的最小时间单位为1分钟。 使用例如`30 4 1,15 * 5 command` 时， 它将使指挥部每个月第1和第15次运行，每星期五上午4时30分运行； 某些脚本或命令的输出信息将防止执行定时任务。 和输出重定向是必需的，例如`*/10 * * * /usr/local/sbin/backup &> /dev/null`
```

## 常见问答[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#_3)

1. /etc/crontab 和 `crontab -e` , 两种方法之间是否有任何差异？ `crontab-e` 不需要指定用户 (默认情况下使用当前登录的用户)， /etc/crontab需要指定用户。
2. 如果指定的命令或脚本没有正确执行，我应该怎么办？ 检查/var/log/cron* 文件，使用 `journalctl -u crond.service` 来检查有关守护进程的信息，脚本是否有 x 权限等用于排除故障。
3. 除了croni，还有什么样的cron变体？ [ dcron ](http://www.jimpryor.net/linux/dcron.html), 最新版本是 4.5 (2011-50-01)。 [ fcron ](http://fcron.free.fr/), 最新版本是 3.3.0 (dev, 2016-08-14)。 [ bcron ](http://untroubled.org/bcron/), 最新版本是 0.11 (2015-08-12). [ bcron ](http://untroubled.org/bcron/), 最新版本是 0.11 (2015-08-12). [ cronsun ](https://github.com/shunfei/cronsun), 最新版本 0.3.5 (2018-11-20).

## 总结[¶](https://docs.rockylinux.org/zh/guides/automation/cronie/#_4)

对Rocky Linux桌面用户或系统管理员来说，cronie 是一个非常强大的工具。 它可以允许您自动执行任务和脚本，这样您就不必记住手动运行它们了。 虽然基本知识很简单，但实际任务可能很复杂。 关于 `crontab` 的更多信息，直到 [crontab 手册页面](https://man7.org/linux/man-pages/man5/crontab.5.html)。 您也可以简单地在互联网上搜索"crontab"。 这将为您提供大量的搜索结果，并帮助您提高`crontab` 表达式。
