# bconsole

[TOC]

## 概述

为了与 Bareos Director 通信并查询 Bareos 的状态或运行作业，可以将 bconsole 程序用作文本界面。可替代地，对于大多数目的，也可以使用 Bareos Webui。

当前的 Bareos 控制台是一个 shell 界面（TTY 风格）。它允许管理员或授权用户与 Bareos 进行交互。可以确定特定作业的状态、检查目录的内容以及使用 Console 程序执行某些磁带操作。

由于 Console 程序通过网络与 Director 交互，因此 Console 和 Director 程序不一定需要在同一台计算机上运行。然而，大多数情况下，人们在同一台机器上运行它作为Bareos Director。

事实上，Bareos 需要对 Console 程序有一定的了解，才能在多个磁带上写入数据，因为当 Bareos 请求新磁带时，它会等待，直到用户通过 Console 程序指示新磁带已安装。

## 控制台配置

当控制台启动时，它读取一个名为 `bconsole.conf` 的标准 Bareos 配置文件，除非您指定 `-c` 命令行选项。此文件允许对控制台进行默认配置，并且当前定义的唯一资源记录是 Director 资源，该资源为控制台提供了 Director 的名称和地址。

## 运行控制台程序

可以使用以下选项运行控制台程序：

```bash
bconsole [-s] [-c config_file] [-d debug_level]

    -h,-?,--help								Print this help message and exit.
    --version									Display program version information and exit
    -c,--config <path>:PATH(existing)			Use <path> as configuration file or directory
    -D,--director <director>					Specify director.
    -d,--debug-level <level>					Set debug level to <level>.
    --dt,--debug-timestamps						Print timestamps in debug output.
    -l,--list-directors		   					List defined Directors.
    -p,--pam-credentials-filename <path>:FILE	PAM Credentials file.
    -o											Force sending pam credentials unencrypted.
    -s,--no-signals								No signals (for debugging)
    -t,--test-config							Test - read configuration and exit
    -u,--timeout <seconds>:POSITIVE				Set command execution timeout to <seconds>.
    --xc,--export-config
        Excludes: --xs
        Print configuration resources and exit
    --xs,--export-schema
        Excludes: --xc
        Print configuration schema in JSON format and exit

# 可不加参数。
bconsole
Connecting to Director bareos:9101
Enter a period to cancel a command.
*
```

输入 **help** 查看所有可用命令：

```bash
*help
  Command       Description
  =======       ===========
  add           Add media to a pool
  autodisplay   Autodisplay console messages
  automount     Automount after label
  cancel        Cancel a job
  create        Create DB Pool from resource
  delete        Delete volume, pool or job
  disable       Disable a job
  enable        Enable a job
  estimate      Performs FileSet estimate, listing gives full listing
  exit          Terminate Bconsole session
  export        Export volumes from normal slots to import/export slots
  gui           Non-interactive gui mode
  help          Print help on specific command
  import        Import volumes from import/export slots to normal slots
  label         Label a tape
  list          List objects from catalog
  llist         Full or long list like list command
  messages      Display pending messages
  memory        Print current memory usage
  mount         Mount storage
  move          Move slots in an autochanger
  prune         Prune expired records from catalog
  purge         Purge records from catalog
  quit          Terminate Bconsole session
  query         Query catalog
  restore       Restore files
  relabel       Relabel a tape
  release       Release storage
  reload        Reload conf file
  rerun         Rerun a job
  run           Run a job
  status        Report status
  setbandwidth  Sets bandwidth
  setdebug      Sets debug level
  setip         Sets new client address -- if authorized
  show          Show resource records
  sqlquery      Use SQL to query catalog
  time          Print current time
  trace         Turn on/off trace to file
  unmount       Unmount storage
  umount        Umount - for old-time Unix guys, see unmount
  update        Update volume, pool or stats
  use           Use specific catalog
  var           Does variable expansion
  version       Print Director version
  wait          Wait until no jobs are running
```

启动控制台程序（bconsole）后，它将提示您输入下一个带有星号（*）的命令。通常，对于所有命令，只需输入命令名，Console 程序将提示输入必要的参数。或者，在大多数情况下，可以输入命令，后跟参数。一般格式为：

```bash
<command> <keyword1>[=<argument1>] <keyword2>[=<argument2>] ...
```

其中 command 是下面列出的命令之一; keyword 是下面列出的关键字之一（通常后跟一个参数）; argument 是值。命令可以缩写为最短的唯一形式。如果两个命令具有相同的起始字母，则将选择帮助列表中最先出现的命令。如果你想要第二个命令，只需拼出完整的命令。命令后的关键字都不能缩写。

例如：

```bash
list files jobid=23
```

将列出为 JobId 23 保存的所有文件。或者：

```bash
show pools
```

将显示所有池资源记录。

最大命令行长度限制为 511 个字符，因此如果正在编写控制台脚本，则可能需要注意限制行长度。

## 退出控制台程序

通常，您只需输入 `quit` 或 `exit`，Console 程序就会终止。但是，它会等待控制器确认命令。如果 Director 正在执行一个较长的命令（例如 prune ），则可能需要一些时间。如果要立即终止 Console 程序，请输入 `.quit` 命令。

```bash
quit
exit
.quit
```

当前没有办法在控制台命令发出后中断该命令（即 Ctrl - C 不起作用）。但是，如果提示符要求您从几种可能性中选择一种，并且您希望中止命令，则可以输入句点（`.`），在大多数情况下，您将返回到主命令提示符，或者在适当的情况下返回到上一个提示（在嵌套提示的情况下）。在一些地方，例如要求提供卷名的地方，句号将被视为卷名。在这种情况下，很可能可以在下一个提示时取消。

## 从 Shell 脚本运行控制台

通过从 shell 脚本运行控制台程序，可以自动执行许多控制台任务。例如，如果创建了包含以下命令的文件：

```bash
bconsole -c ./bconsole.conf <<END_OF_DATA
unmount storage=DDS-4
quit
END_OF_DATA
```

执行该文件时，它将卸载当前 DDS-4 存储设备。您可能希望在作业期间使用 RunBeforeJob 或 RunAfterJob 记录运行此命令。

也可以从文件输入运行 Console 程序，其中文件包含以下命令：

```bash
bconsole -c ./bconsole.conf <filename
```

其中名为 filename 的文件包含任何控制台命令集。

作为一个真实的例子，下面的脚本是 Bareos 系统测试的一部分。它标记卷（磁盘卷），运行备份，然后还原保存的文件。

```bash
bconsole <<END_OF_DATA
@output /dev/null
messages
@output /tmp/log1.out
label volume=TestVolume001
run job=Client1 yes
wait
messages
@#
@# now do a restore
@#
@output /tmp/log2.out
restore current all
yes
wait
messages
@output
quit
END_OF_DATA
```

备份的输出定向到 `/tmp/log1.out` ，还原的输出定向到 `/tmp/log2.out` 。为确保备份和恢复正确运行，使用以下命令检查输出文件：

```bash
grep "^ *Termination: *Backup OK" /tmp/log1.out
backupstat=$?
grep "^ *Termination: *Restore OK" /tmp/log2.out
restorestat=$?
```

## 控制台关键字

除非另外指定，否则以下每个关键字都带有一个参数，该参数在关键字后面的等号后面指定。例如：

```bash
jobid=536
```

- all

  允许在 status 和 show 命令上分别指定所有组件或资源。

- allfrompool

  允许在 update 命令中更新指定池中（在命令行中指定）的所有卷。

- allfrompools

  允许在 update 命令中指定更新所有池中的所有卷。

- before

  在 restore 命令中使用。

- bootstrap

  在 restore 命令中使用。

- catalog

  允许在 use 命令中指定要使用的目录名称。

- catalogs

  Takes no arguments.用于 show 命令。不需要争论。

- client | fd

  用于指定客户端（或 filedaemon ）。

- clients

  Takes no arguments.在 show、list 和 llist 命令中使用。不需要争论。

- counters

  Takes no arguments.用于 show 命令。不需要争论。

- current

  Takes no argument.在 restore 命令中使用。不需要争论。

- days

  用于定义 list nextvol 命令在查找要运行的作业时应考虑的天数。days 关键字也可以用在 status dir 命令上，这样它就可以显示按您想要的天数调度的作业。它也可以用于 rerun 命令，它将自动选择最近几天内所有失败的 jobid 重新运行。

- devices

  Takes no arguments.用于 show 命令。不需要争论。

- director | dir | directors

  Takes no arguments.在 show 和 status 命令中使用。不需要争论。

- directory

  在 restore 命令中使用。它的参数指定要还原的目录。

- enabled

  此关键字可以出现在 update volume 和 update slots 命令中，并且可以允许以下参数之一：yes、true、no、false、archived、0、1、2 。其中 0 对应于否或假，1 对应于是或真，2 对应于存档。将不会使用存档卷，也不会修剪目录中的媒体记录。未启用的卷将不会用于备份或还原。

- done

  Takes no argument.在 restore 命令中使用。不需要争论。

- file

  在 restore 命令中使用。

- files

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- fileset

  在 run 和 restore 命令中使用。指定文件集。

- filesets

  Takes no arguments.用于 show 命令。不需要争论。

- help

  Takes no arguments.用于 show 命令。不需要争论。

- hours

  在 rerun 命令中使用，选择最近几个小时内所有失败的 jobid 以重新运行。

- jobs

  Takes no arguments.用于 show、list 和 llist 命令。不需要争论。

- jobmedia

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- jobtotals

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- jobid

  JobId 是在作业报告输出中打印的数字作业 ID 。它是给定作业的数据库记录的索引。虽然它对于目录数据库中的所有现有作业记录都是唯一的，但从目录中删除作业后，可以重用相同的 JobId 。Probably you will refer specific Jobs that ran using  their numeric JobId. 您可能会引用使用数字 JobId 运行的特定作业。JobId 可用于 rerun 命令，以选择所有后面失败的作业（包括给定的 jobid ），以便重新运行。

- job | jobname

  Job  或 Jobname 关键字指的是您在 Job 资源中指定的名称，因此它指的是运行的任意数量的 Job 。如果要列出具有特定名称的所有作业，此选项通常很有用。

- level

  Specifies the backup level.用于 run 命令。指定备份级别。

- listing

  Takes no argument.在 estimate 命令上允许。不需要争论。

- limit

  指定结果中的最大项数。

- messages

  Takes no arguments.用于 show 命令。不需要争论。

- media

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- nextvolume | nextvol

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- on

  Takes no arguments.不需要争论。

- off

  Takes no arguments.不需要争论。

- pool

  Specify the pool to be used.指定要使用的池。

- pools

  Takes no arguments.在 show、list 和 llist 命令中使用。不需要争论。

- select

  Takes no argument.在 restore 命令中使用。不需要争论。

- limit

  用于 setbandwidth 命令。以 KB/s 为单位的整数。

- schedules

  Takes no arguments.用于 show 命令。不需要争论。

- storage | store | sd

  用于指定存储守护程序的名称。

- storages

  Takes no arguments.用于 show 命令。不需要争论。

- ujobid

  ujobid 是打印在作业报告输出中的唯一作业标识。当前，它由作业名称（来自作业的 Name 指令）和作业运行的日期和时间组成。如果要完全标识作业实例运行，此关键字非常有用。

- volume

  用于指定卷。

- volumes

  Takes no arguments.在 list 和 llist 命令中使用。不需要争论。

- where

  在 restore 命令中使用。

- yes

  Takes no argument.在 restore 命令中使用。不需要争论。

## 控制台命令

当前实现了以下命令：

- add

  此命令用于向现有池中添加卷。也就是说，它在目录中创建卷名并插入目录中的池，但不尝试访问物理卷。一旦添加，Bareos 期望卷存在并被标记。此命令通常不使用，因为 Bareos 会在标记了卷时，自动执行等效操作。但是，有时可能会从目录中删除某个卷，然后希望稍后再将其添加回来。

  此命令的完整形式为：

  ```bash
  add [pool=<pool-name>] [storage=<storage>] [jobid=<JobId>]
  ```

  通常，使用 label 命令而不是此命令，因为 label 命令标记物理介质（磁带、磁盘、...），并执行与 add 命令等效的操作。add 命令只影响目录，而不影响物理介质（卷上的数据）。物理介质必须存在，并且在使用前被标记（通常使用 label 命令）。但是，如果您希望向池中添加多个将在以后进行物理标记的卷，则此命令非常有用。如果您要从其他站点导入磁带，此功能也很有用。

- autodisplay

  此命令接受 on 或 off 作为参数，并分别打开或关闭消息的自动显示。控制台程序的默认设置是 off ，这意味着当有控制台消息挂起时，您将收到通知，但它们不会自动显示。

  当关闭自动显示时，必须使用 messages 命令显式检索消息。当自动显示打开时，消息将在接收时显示在控制台上。

- automount

  此命令接受 on 或 off 作为参数，并分别打开或关闭 label 命令后卷的自动挂载。默认值为 on 。如果automount 关闭，则必须在 label 命令后显式装入磁带卷才能使用它。

- cancel

  此命令用于取消作业，并接受 jobid=nnn 或 job=xxx 作为参数，其中 nnn 替换为 JobId ，xxx 替换为作业名称。如果未指定关键字，Console 程序将提示所有活动作业的名称，以便您选择一个。

  此命令的完整形式为：

  ```bash
  cancel [jobid=<number> job=<job-name> ujobid=<unique-jobid>]
  ```

  一旦作业被标记为取消，它可能需要一段时间（通常在一分钟内，但最多两个小时）才能真正终止，这取决于它正在执行的操作。当你收到找不到工作的消息时，不要感到惊讶。这只是意味着三个守护进程之一已经取消了作业。编号为 1000 的消息来自 Director ，2000 来自 File 守护程序，3000来自Storage守护程序。

  可以一次取消多个作业。因此，以下额外选项可用于作业选择：

  * all jobs                                            所有作业
  * all jobs with a created state        具有已创建状态的所有作业
  * all jobs with a blocked state       所有处于阻止状态的作业
  * all jobs with a waiting state        所有处于等待状态的作业
  * all jobs with a running state       所有处于运行状态的作业

  使用方法：

  ```bash
  cancel all
  cancel all state=<created|blocked|waiting|running>
  ```

  有时候，Director 已将作业从其运行队列中删除，但存储守护程序仍认为它正在执行备份（或其他作业），无法再从控制台中取消作业。因此，可以在存储守护程序上通过 JobId 取消作业。在存储守护程序上执行  status storage  可能会有所帮助，以确定要取消的作业。

  使用方法：

  ```bash
  cancel storage=<Storage Daemon> Jobid=<JobId>
  ```

  这样，还可以删除阻止其他作业运行的作业，而无需重新启动整个存储守护程序。

- create

  通常不使用此命令，因为池记录是由 Director 在启动时根据其在配置中找到的内容自动创建的。如果需要，可以使用此命令，使用 Director 配置文件中定义的池资源记录在数据库中创建池记录。因此，在某种意义上，此命令只是将信息从配置文件中的 Pool 资源传输到 Catalog 中。通常，当 Director 开始提供作业资源中引用的池时，此命令会自动为您执行。如果对现有池使用此命令，它将自动更新目录，使其具有与池资源相同的信息。创建池后，您很可能会使用 label 命令标记一个或多个卷，并将其名称添加到介质数据库中。

  此命令的完整形式为：

  ```bash
  create [pool=<pool-name>]
  ```

  启动作业时，如果 Bareos 确定数据库中没有池记录，但存在具有适当名称的池资源，它将为您创建它。如果您希望池记录立即出现在数据库中，只需使用此命令强制创建它。

- configure

  在运行时配置 director 资源。第一个 configure 子命令是 configure add 和 configure export 。其他子命令可能会在以后的版本中出现。

  * configure add

    此命令允许在运行时添加资源。使用方法：

    ```bash
    configure add <resourcetype> name=<resourcename> <directive1>=<value1> <directive2>=<value2> ...
    ```

    Values that must be quoted in the resulting configuration must be added as: 必须将结果配置中必须用引号引起来的值添加为：

    ```bash
    configure add <resourcetype> name=<resourcename> <directive1>="\"<value containing spaces>\"" ...
    ```

    该命令生成并加载新的有效资源。由于新资源也存储在 `<CONFIGDIR>/bareos-dir.d/<resourcetype>/<resourcename>.conf` ，它在重新加载和重新启动时是持久。此功能需要子目录配置方案。

    可以添加各种资源。添加客户端资源时，还将为 Bareos 文件守护程序创建 Director 资源并将其存储在： `<CONFIGDIR>/bareos-dir-export/client/<clientname>/bareos-fd.d/director/<clientname>.conf` 。

    ```bash
    *configure add client name=client2-fd address=192.168.0.2 password=secret
    Created resource config file "/etc/bareos/bareos-dir.d/client/client2-fd.conf": Client {
    	Name = client2-fd
        Address = 192.168.0.2
        Password = secret
    } 
    
    *configure add job name=client2-job client=client2-fd jobdefs=DefaultJob Created resource config file "/etc/bareos/bareos-dir.d/job/client2-job.conf": Job {
    	Name = client2-job
        Client = client2-fd
        JobDefs = DefaultJob
    }
    ```

    这两个命令创建三个资源配置文件：

    * `/etc/bareos/bareos-dir.d/client/client2-fd.conf`

    * `/etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf`

      （假设控制器资源名为 bareos-dir）

    * `/etc/bareos/bareos-dir.d/job/client2-job.conf`

    Bareos Director 不使用 `bareos-dir-export/client/` 目录中的文件。但是，可以将它们复制到新客户端，以便为 Bareos Director 配置这些客户端。

    > 警告
    >
    > 不要被 help configure 的大量输出所迷惑。由于 configure add 允许配置任意资源，help configure 的输出列出了所有资源，每个资源都有所有有效的指令。相同的数据也用于 bconsole 命令行。

    自 Bareos >= 16.2.4 起可用。

  * configure export

    此命令允许导出已在 Bareos Director 中配置的客户端的 `Director (Fd)` 资源。
    
    使用方法：
    
    ```bash
    configure export client=bareos-fd
    Exported resource file "/etc/bareos/bareos-dir-export/client/bareos-fd/bareos-fd.d/director/bareos-dir.conf":
    Director {
    	Name = bareos-dir
        Password = "[md5]932d1d3ef3c298047809119510f4bee6"
    }
    ```
    
    要使用它，请将 `Director (Fd)` 资源文件复制到客户端计算机（在 Linux 上：复制到 `/etc/bareos/bareos-fd.d/director/` ），然后重新启动 Bareos File Daemon。
    
    自 Bareos >= 16.2.4 起可用。

- delete

  delete 命令用于从目录中删除卷、池或作业记录以及创建的所有关联目录卷记录。此命令仅对目录数据库起作用，对写入卷的实际数据没有影响。此命令可能很危险，强烈建议不要使用它，除非您知道自己在做什么。

  如果命令行中出现关键字 Volume ，则命名的 Volume 将从目录中删除。如果命令行中出现关键字 Pool ，则将删除 Pool 。如果命令行中出现关键字 Job ，则将从目录中删除 Job 及其所有关联记录（文件和JobMedia）。如果关键字 storage 出现在命令行上，则将删除具有选定名称的孤立存储。

  此命令的完整形式为：

  ```bash
  delete pool=<pool-name>
  delete volume=<volume-name> pool=<pool-name>
  delete JobId=<job-id> JobId=<job-id2> ...
  delete Job JobId=n,m,o-r,t ...
  delete storage=<storage-name>
  ```

  第一种形式从目录数据库中删除池记录。第二种形式从目录数据库的指定池中删除卷记录。第三种形式从目录数据库中删除指定的作业记录。第四种形式删除 JobId n、m、o、p、q、r 和 t 的 JobId 记录。其中 n，m，...中的每一个，当然是一个数字。也就是说，“delete jobid” 接受作业 ID 的列表和范围。最后一种形式从数据库中删除选定的存储，只有当它是孤立的，这意味着如果仍然存在于数据库中，即使它的配置已被删除，没有卷或设备与它相关联了。

- disable

  此命令允许禁用自动调度作业。该作业可能已使用作业资源启用指令或使用控制台启用命令启用。下次重新加载或重新启动 Director 时，“启用/禁用”状态将设置为作业资源中的值（默认为启用），如 Bareos Director 配置中所定义。

  此命令的完整形式为：

  ```bash
  disable job=<job-name>
  ```

- enable

  此命令允许您启用自动调度作业。该作业以前可能已使用作业资源启用指令或使用控制台禁用命令禁用。下次重新加载或重新启动 Director 时，“启用/禁用”状态将设置为作业资源中的值（默认为启用），如 Bareos Director 配置中所定义。

  此命令的完整形式为：

  ```bash
  enable job=<job-name>
  ```

- estimate

  使用此命令，可以了解将备份多少文件，或者如果您不确定 FileSet 中的 Include 语句，则可以在不执行实际备份的情况下测试它们。默认情况下，将假定为完整备份。但是，可以通过在命令行上指定 level=Incremental 或 level=Differential 来覆盖此设置。必须指定作业名称，否则将提示您指定一个，并且可以在命令行上指定 Client 和 FileSet（可选）。然后，它联系客户端，客户端计算要备份的文件和字节数。请注意，这是根据文件中的块数计算的估计值，而不是通过阅读实际字节。因此，估计的备份大小通常会大于实际备份。

  `estimate` 命令可以使用精确的代码来检测变化并给予更好的估计。可以使用 `accurate=yes/no` 在命令行上设置准确的行为，或使用作业设置作为默认值。

  您可以选择指定关键字列表，在这种情况下，将列出所有要备份的文件。请注意，如果备份很大，显示它们可能需要相当长的时间。完整的形式是：

  此命令的完整形式为：

  ```bash
  estimate job=<job-name> listing client=<client-name> accurate=<yes|no> fileset=<fileset-name> level=<level-name>
  ```

  作业的规范就足够了，但是您还可以通过在  estimate 命令行中指定客户端、文件集、精确和/或、级别来覆盖它们。

  例如，您可以执行以下操作：

  ```bash
  @output /tmp/listing
  estimate job=NightlySave listing level=Incremental
  @output
  ```

  which will do a full listing of all files to be backed  up for the Job NightlySave during an Incremental save and put it in the  file /tmp/listing. 它将在增量保存期间为Job NightlySave备份的所有文件的完整列表，并将其放入文件 /tmp/listing 中。注意，此命令提供的字节估计值基于目录项中包含的文件大小。如果系统上有稀疏的文件，这可能会对实际使用的存储空间给出非常不正确的估计。稀疏文件通常在 64 位系统上用于某些系统文件。返回的大小是 Bareos 在 FileSet 中未指定 sparse 选项时将备份的大小。如果启用稀疏选项，目前无法估计发现的文件的真实大小。

- exit

  此命令终止控制台程序。

- export

  export 命令用于从自动转换器中导出磁带。大多数自动换带器提供特殊的插槽，用于导入新的磁带盒或导出已写入的磁带盒。这可以在无需将设备设置为离线的情况下发生。

  此命令的完整形式为：

  ```bash
  export storage=<storage-name> srcslots=<slot-selection> [dstslots=<slot-selection> volume=<volume-name> scan]
  ```

  export 命令的作用与 import 命令完全相反。可以指定应将哪些插槽传输到导入/导出插槽。export 命令最有用的应用是可以自动将某个备份的卷传输到外部存储的导入/导出插槽中。

  为了能够做到这一点，export 命令还接受要导出的卷名列表。

  例如：

  ```bash
  export volume=A00020L4|A00007L4|A00005L4
  ```

  除了按名称导出卷，您还可以通过 srcslots 关键字选择多个插槽，并将这些插槽导出到您在 dstslots 中指定的插槽。export 命令将检查插槽是否有内容（例如，otherwise there is not much to export否则没有太多要导出的内容），是否有足够的导出插槽，以及这些插槽是否真的是导入/导出插槽。

  例如：

  ```bash
  export srcslots=1-2 dstslots=37-38
  ```

  若要自动导出某个备份作业使用的卷，可以在该作业中使用以下 RunScript ：

  ```bash
  RunScript {
  	Console = "export storage=TandbergT40 volume=%V"
      RunsWhen = After
      RunsOnClient = no
  }
  ```

  要通过 Messages 资源发送有关导出磁带的电子邮件通知，可以在 Messages 资源中使用 Variable %V 替换，该替换在 Bareos 13.2 中实现。但是，在早期版本中，它也可以在作业资源中工作。因此，在 Bareos 13.2 之前的版本中，可以使用以下解决方案：

  ```bash
  RunAfterJob = "/bin/bash -c \"/bin/echo Remove Tape %V | \ /usr/sbin/bsmtp -h localhost -f root@localhost -s 'Remove Tape %V' root@localhost \""
  ```
  
- gui

  取消非交互式 gui 模式。This command is only used when **bconsole** is commanded by an external program.此命令仅在 bconsole 由外部程序命令时使用。

- help

  此命令显示可用命令的列表。

- import

  import 命令用于将磁带导入自动转换器。大多数自动换带器提供特殊的插槽，用于导入新的磁带盒或导出已写入的磁带盒。这可以在无需将设备设置为离线的情况下发生。

  此命令的完整形式为：

  ```bash
  import storage=<storage-name> [srcslots=<slot-selection> dstslots=<slot-selection> volume=<volume-name> scan]
  ```

  要将新磁带导入自动转换器，只需将新磁带装入导入/导出插槽，然后从命令行调用 import 。

  import 命令将自动将新磁带转移到自动转换器的空闲插槽中。插槽按插槽编号的顺序填充。要导入所有磁带，必须有足够的空闲插槽来加载所有磁带。

  具有 36 个插槽和 3 个导入/导出插槽的库的示例：

  ```bash
  *import storage=TandbergT40
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger "slots" command.
  Device "Drive-1" has 39 slots. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 
  3306 Issuing autochanger "listall" command.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ... 
  3306 Issuing autochanger transfer command.
  3308 Successfully transfered volume from slot 37 to 20.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger transfer command.
  3308 Successfully transfered volume from slot 38 to 21.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger transfer command.
  3308 Successfully transfered volume from slot 39 to 25.
  ```

  当自动转换器中没有足够的可用插槽来放置所有导入/导出插槽时，也可以导入某些插槽。

  例如，一个库有 36 个插槽和 3 个导入/导出插槽，导入一个插槽：

  ```bash
  *import storage=TandbergT40 srcslots=37 dstslots=20
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger "slots" command.
  Device "Drive-1" has 39 slots.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger "listall" command.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger transfer command.
  3308 Successfully transfered volume from slot 37 to 20.
  ```
  
- label

  此命令用于标记物理卷。

  此命令的完整形式为：

  ```bash
  label storage=<storage-name> volume=<volume-name> slot=<slot>
  ```

  如果遗漏了任何部分，系统将提示您输入该部分。介质类型将自动从您提供的存储资源定义中获取。一旦获得必要的信息，控制台程序将联系指定的存储守护程序并请求标记卷。如果卷标记成功，控制台程序将在相应的池中创建卷记录。

  卷名仅限于字母、数字和特殊字符连字符（-）、下划线（_）、冒号（：）和句点（.）。包括空格在内的所有其他字符都无效。此限制是为了确保卷名称的可读性，以减少操作员错误。

  请注意，当标记空白磁带时，Bareos 将在it attempts to ensure that the tape is not already labeled尝试确保磁带尚未标记时获得读取 I/O 错误。如果不想收到这些信息，请在尝试标记之前在磁带上写一个 EOF 标记：

  ```bash
  mt rewind
  mt weof
  ```

  label 命令失败的原因有很多：

  1. 指定的卷名已在卷数据库中。
  2. 存储守护程序已在设备上装载了磁带或其他卷。在这种情况下，您必须卸载设备，插入空白磁带，然后执行 label 命令。
  3. 设备中的卷是一个已经被 Bareos 标记过的。（Bareos 永远不会重新标记 Bareos 标记过的卷，除非它被回收，并且使用 relabel 命令）。
  4. 驱动器中没有卷。

  有两种方法可以重新标记已具有 Bareos 标签的卷。蛮力方法是使用系统 mt 程序在磁带上写入文件结束标记，类似于以下内容：

  ```bash
  mt -f /dev/st0 rewind
  mt -f /dev/st0 weof
  ```

  对于磁盘卷，可以手动删除该卷。

  然后使用 label 命令添加新标签。但是，这可能会在目录中留下旧卷的痕迹。

  重新标记卷的首选方法是首先自动清除卷，或使用 purge 命令显式清除卷，然后使用下面介绍的 relabel 命令。

  如果自动转换器具有条形码标签，则可以使用 label barcodes 命令逐个标记自动转换器中的所有条形码。对于转换器中包含条形码的每个磁带，Bareos 将装载磁带，然后使用与条形码相同的名称对其进行标记。还将在目录中创建相应的媒体记录。Any  barcode that begins with the same characters as specified on the  “CleaningPrefix=xxx” (default is “CLN”) directive in the Director’s Pool resource, 以控制器池资源中“CleaningPrefix=xxx”（默认值为 “CLN” ）指令中指定的相同字符开头的任何条形码都将被视为清洗磁带，并且不会被标记。但是，将在目录中创建清洗磁带的条目。例如：

  ```bash
  Pool {
  	Name ...
      Cleaning Prefix = "CLN"
  }
  ```

  任何包含 CLNxxxx 条形码的插槽都将被视为清洁磁带，不会被安装。注意，命令的完整形式是：

  ```bash
  label storage=xxx pool=yyy slots=1-5,10 barcodes
  ```

- list

  list 命令列出所请求的目录内容。每条记录的各个字段都列在一行上。list 命令的各种形式有：

  ```bash
  list jobs
  list jobid=<id>           (list jobid id)
  list ujobid=<unique job name> (list job with unique name)
  list job=<job-name>   (list all jobs with "job-name")
  list jobname=<job-name>  (same as above)    In the above, you can add "limit=nn" to limit the output to nn jobs.
  list joblog jobid=<id> (list job output if recorded in the catalog)
  list jobmedia
  list jobmedia jobid=<id>
  list jobmedia job=<job-name>
  list files jobid=<id>
  list files job=<job-name>
  list pools
  list clients
  list jobtotals
  list volumes
  list volumes jobid=<id>
  list volumes pool=<pool-name>
  list volumes job=<job-name>
  list volume=<volume-name>
  list nextvolume job=<job-name>
  list nextvol job=<job-name>
  list nextvol job=<job-name> days=nnn
  ```

  以上大多数命令的作用应该或多或少是显而易见的。一般来说，如果您没有指定所有命令行参数，该命令将提示您需要什么。

  list nextvol 命令将打印指定作业要使用的卷名。你应该知道，究竟是什么卷将被使用取决于很多因素，包括the time and what a prior job will do时间和什么以前的工作将做。当您发出此命令时，它可能会填满未满的磁带。因此，此命令将给予您一个关于将使用的卷的良好估计，但不是一个确定的答案。此外，此命令可能会有一定的副作用，因为它通过与作业相同的算法运行，这意味着它可能会自动清除或回收卷。默认情况下，指定的作业必须在接下来的两天内运行，否则将找不到卷。但是，您可以使用 days=nnn 指定来指定最多 50 天。例如，如果在星期五，您想查看星期一需要的卷，对于作业 MyJob ，可以使用 list nextvol job=MyJob days=3 。

  如果希望添加列出目录内容的专用命令，可以通过将它们添加到 `query.sql` 文件来实现。但是，这需要一些 SQL 编程的知识。

  例如，命令 list pools 可能会产生以下输出：

  ```bash
  *list pools
  +------+---------+---------+---------+----------+-------------+
  | PoId | Name    | NumVols | MaxVols | PoolType | LabelFormat |
  +------+---------+---------+---------+----------+-------------+
  |    1 | Default |       0 |       0 | Backup   | *           |
  |    2 | Recycle |       0 |       8 | Backup   | File        |
  +------+---------+---------+---------+----------+-------------+
  ```

  如上所述，list 命令列出数据库中的内容。当 Bareos 启动时，有些东西会立即放入数据库中，但一般来说，大多数东西只在第一次使用时才放入数据库中，这是客户端的情况，如作业记录等。

  Bareos 应该在您第一次为该客户机运行作业时在数据库中创建一个客户机记录。执行状态操作不会导致创建数据库记录。无论作业是否失败，都将创建客户端数据库记录，但它必须至少启动。当实际联系到客户端时，来自客户端的附加信息将被添加到客户端记录中（ “uname -a” 输出）。

  如果要查看 conf 文件中有哪些客户端资源可用，可以使用 Console 命令 show clients 。

- llist

  llist 或 “long list” 命令采用与上述 list 命令相同的所有参数。不同之处在于，llist 命令列出所选每个数据库记录的完整内容。它通过垂直列出记录的各个字段来实现，每行一个字段。使用此命令可以生成大量的输出行。

  如果您输入 llist pools 而不是上面示例中的 list pools ，则可能会得到以下输出：

  ```bash
  *llist pools
           PoolId: 1
             Name: Default
          NumVols: 0
          MaxVols: 0
          UseOnce: 0
       UseCatalog: 1
  AcceptAnyVolume: 1
     VolRetention: 1,296,000
   VolUseDuration: 86,400
       MaxVolJobs: 0
      MaxVolBytes: 0
        AutoPrune: 0
          Recycle: 1
         PoolType: Backup
      LabelFormat: *
  
           PoolId: 2
             Name: Recycle
          NumVols: 0
          MaxVols: 8
          UseOnce: 0
       UseCatalog: 1
  AcceptAnyVolume: 1
     VolRetention: 3,600
   VolUseDuration: 3,600
       MaxVolJobs: 1
      MaxVolBytes: 0
        AutoPrune: 0
          Recycle: 1
         PoolType: Backup
      LabelFormat: File
  ```

- messages

  此命令会立即显示任何挂起的控制台消息。

- memory

  打印当前内存使用情况。

- mount

  mount 命令用于让 Bareos 读取物理设备上的卷。这是一种告诉 Bareos 您已经安装了磁带并且 Bareos 应该检查磁带的方法。此命令通常仅在驱动器中没有卷并且 Bareos 请求您挂载新卷时使用，或者当您使用unmount 命令专门卸载卷时使用，这会导致 Bareos 关闭驱动器。如果您有一个自动加载器，则 mount 命令不会导致 Bareos 操作自动加载器，除非您指定一个插槽和驱动器。mount 命令的各种形式有：

  ```bash
  mount storage=<storage-name> [slot=<num>] [drive=<num>]
  mount [jobid=<id> | job=<job-name>]
  ```

  如果您指定了 `Automatic Mount (Sd->Device) = yes` ，在大多数情况下，Bareos 将自动访问该卷，除非您已显式卸载它（在 Console 程序中）。

- move

  move 命令允许在自动转换器的插槽之间移动卷，而无需离开 bconsole 。

  要将卷从插槽 32 移动到插槽 33，请用：

  ```bash
  *move storage=TandbergT40 srcslots=32 dstslots=33
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger "slots" command.
  Device "Drive-1" has 39 slots.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger "listall" command.
  Connecting to Storage daemon TandbergT40 at bareos:9103 ...
  3306 Issuing autochanger transfer command.
  3308 Successfully transfered volume from slot 32 to 33.
  ```

- prune

  Prune 命令允许您安全地从作业、卷和统计中删除过期的数据库记录。此命令仅对 Catalog 数据库有效，不影响写入到卷的数据。在所有情况下，Prune 命令都会对指定的记录应用保留期。您可以从作业记录中删除过期的文件条目；您可以从数据库中删除过期的作业记录，并且您可以从指定的卷中删除过期的作业和文件记录。可以通过指定要修剪的卷来单独修剪卷，也可以使用 all 选项一次性修剪所有卷。

  ```bash
  prune files [client=<client>] [pool=<pool>] [yes] |
  	   jobs [client=<client>] [pool=<pool>] [yes] |
  	   volume [=volume] [pool=<pool>] [all] [yes] |
  	   stats [yes] |
  	   directory [=directory] [client=<client>] [recursive] [yes]
  ```

  对于要修剪的卷，卷状态必须为 “Full”、“Used” 或 “Append”，否则将不会进行修剪。不影响任何文件的作业（什么都不做的作业，例如没有任何新文件要备份的增量备份）将不会被修剪。

- purge

  Purge 命令将从作业和卷中删除关联的目录数据库记录，而不考虑保留期。此命令可能很危险，因为您可能会删除与当前文件备份关联的编录记录，因此建议您在不知道自己在做什么的情况下不要使用此命令。允许的 purge 形式有：

  ```bash
  purge [files [job=<job> | jobid=<jobid> | client=<client> | volume=<volume>]] |
        [jobs [client=<client> | volume=<volume>]] |
        [volume [=<volume>] [storage=<storage>] [pool=<pool>] [devicetype=<type>] [drive=<drivenum>] [action=<action>]] |
        [quota [client=<client>]]
  ```

  要使 purge 命令对卷目录数据库记录起作用，卷状态必须为 “Append”、“Full”、“Used” 或 “Error” 。

  写入卷的实际数据将不受此命令的影响，除非您使用 `Action On Purge (Dir->Pool) = Truncate` 选项。

  要让 Bareos 截断您的 Purged 卷，您需要在交互模式下使用以下命令：

  ```bash
  *purge volume action=truncate storage=File pool=Full
  ```

  但是，通常情况下，您应该仅使用 purge 命令从目录中清除卷，并使用 truncate 命令在 Bareos Storage Daemon 上截断卷。

- resolve

  在配置文件中，地址可以（通常应该）指定为 DNS 名称。由于 Bareos 的不同组件将与其他 Bareos 组件建立网络连接，因此 DNS 域名解析对相关组件起作用并提供相同的结果非常重要。resolve 命令可用于测试 Director 、存储守护程序或客户端上给定主机名的 DNS 解析。

  ```bash
  *resolve www.bareos.com
  bareos-dir resolves www.bareos.com to host[ipv4:84.44.166.242]
  
  *resolve client=client1-fd www.bareos.com
  client1-fd resolves www.bareos.com to host[ipv4:84.44.166.242]
  
  *resolve storage=File www.bareos.com
  bareos-sd resolves www.bareos.com to host[ipv4:84.44.166.242]
  ```

- query

  此命令从查询文件中读取预定义的 SQL 查询（查询文件的名称和位置是使用 Director 配置文件中的 QueryFile 资源记录定义的）。系统将提示您从文件中选择一个查询，并可能输入一个或多个参数，然后将命令提交给 Catalog 数据库 SQL 引擎。

- quit

  此命令终止控制台程序。控制台程序向 Director 发送退出请求并等待确认。如果 Director 正忙碌为您执行尚未终止的上一个命令，则可能需要一些时间。您可以通过发出 .quit 命令立即退出。

- relabel

  此命令用于标记物理卷。

  此命令的完整形式为：

  ```bash
  relabel storage=<storage-name> oldvolume=<old-volume-name> volume=<new-volume-name> pool=<pool-name> [encrypt] 
  ```

  如果您遗漏了任何部分，系统将提示您重新标记。要重新标记卷（旧卷名），卷必须在目录中，并且卷状态必须标记为 “Purged” 或 “Recycle” 。这是由于应用保留期而自动发生的，或者您可以使用 purge 命令显式清除卷。

  一旦对卷进行了物理重新标记，以前写入卷上的旧数据就会丢失，并且无法恢复。

- release

  此命令用于使存储守护程序释放（和倒带）驱动器中的当前磁带，并在下次使用磁带时重新读取卷标。

  ```bash
  release storage=<storage-name>
  ```

  在 release 命令之后，设备仍然被 Bareos 保持打开状态（除非 `Always Open (Sd->Device) = no` ），因此它不能被其他程序使用。但是，对于某些磁带驱动器，操作员可以移除当前磁带并插入不同的磁带，并且当下一个作业开始时，Bareos 将知道重新读取磁带标签以找出装载的磁带。如果您希望能够将驱动器与另一个程序（例如 mt ）一起使用，则必须使用 unmount 命令使 Bareos 完全释放（关闭）设备。

- reload

  reload 命令使 Director 重新读取其配置文件并应用新值。新值将立即对所有新作业生效。但是，如果更改计划，be aware that the  scheduler pre-schedules jobs up to two hours in advance, 请注意计划程序最多提前两个小时预先计划作业，因此在接下来的两个小时内发生的任何更改都可能会延迟。已计划运行的作业（即超过其请求的开始时间）将继续使用旧值。新作业将使用新值。Each  time you issue a reload command while jobs are running, the prior config values will queued until all jobs that were running before issuing the  reload terminate, 每次在作业运行时发出 reload 命令时，之前的配置值将排队，直到发出reload命令前运行的所有作业终止，此时旧的配置值将从内存中释放。The Directory permits keeping up to ten prior set of  configurations before it will refuse a reload command. 在拒绝重新加载命令之前，目录允许保留多达 10 个先前的配置集。一旦至少有一个旧的配置值被释放，它将再次接受新的  reload 命令。

  虽然可以在运行中重新加载 Director 的配置，即使作业正在执行，但这是一个复杂的操作，并且并非没有副作用。因此，如果您必须在 Bareos 运行时重新加载 Director 的配置，建议您在下次方便时重新启动Director。

- rerun

  rerun 命令允许您使用与原始作业完全相同的设置重新运行作业。在 Bareos 中，the job configuration is often altered  by job overrides作业配置经常被作业覆盖改变。These overrides alter the configuration of the job  just for one job run. 这些覆盖仅针对一次作业运行更改作业的配置。如果由于任何原因，a job with overrides  fails具有覆盖的作业失败，it is not easy to restart a new job that is exactly configured as the job that failed则不容易重新启动完全配置为失败作业的新作业。整个作业配置自动设置为默认值，很难像以前那样配置所有内容。

  通过使用 rerun 命令，it is much easier to rerun a job exactly  as it was configured可以更容易地完全按照作业的配置对其进行重新配置。您只需指定失败作业的 JobId 。

  ```bash
  rerun jobid=<jobid> since_jobid=<jobid> days=<nr_days> hours=<nr_hours> yes
  ```

  可以使用其中一个选择条件来选择要删除的作业 ID 。使用 jobid= 将自动选择所有在给定 jobid 之后失败的作业（包括给定 jobid ），以便重新运行。通过使用 days= 或 hours= ，您可以分别选择最近天数或小时数内的所有失败作业 ID 以重新运行。

- restore

  restore 命令允许您选择一个或多个要使用各种方法还原的作业（JobId）。选择 JobId 后，这些作业的文件记录将放置在内部 Bareos 目录树中，恢复将进入文件选择模式，允许您以交互方式在文件树中上下移动，选择要恢复的各个文件。此模式有点类似于标准 Unix 还原程序的交互式文件选择模式。

  ```bash
  restore storage=<storage-name> client=<backup-client-name>
  	where=<path> pool=<pool-name> fileset=<fileset-name>
      restoreclient=<restore-client-name>
      restorejob=<job-name>
      select current all done
  ```

  Where current, 如果指定, 告诉 restore 命令自动选择恢复到最新备份。如果未指定，将提示您。all 规范告诉 restore 命令恢复所有文件。如果未指定，系统将提示您输入要还原的文件。

  client 关键字最初指定从中进行备份的客户端和将进行恢复的客户端。The client keyword initially specifies the client from which the  backup was made and the client to which the restore will be make. 但是，如果指定了 restoreclient 关键字，则会将还原写入该客户端。

  很少需要指定还原作业，因为 bareos 安装通常只配置一个还原作业。但是，在某些情况下（such as a varying list of RunScript specifications,例如 RunScript 规范的不同列表），可能会配置多个还原作业。restorejob 参数允许选择其中一个作业。

- run

  此命令允许您立即运行计划的作业。

  命令的完整形式是：

  ```bash
  run job=<job-name> client=<client-name> fileset=<fileset-name>
  	level=<level> storage=<storage-name> where=<directory-prefix>
      when=<universal-time-specification> pool=<pool-name>
      pluginoptions=<plugin-options-string> accurate=<yes|no>
      comment=<text> spooldata=<yes|no> priority=<number>
      jobid=<jobid> catalog=<catalog> migrationjob=<job-name> backupclient=<client-name>
      backupformat=<format> nextpool=<pool-name> since=<universal-time-specification>   
      verifyjob=<job-name> verifylist=<verify-list> migrationjob=<complete_name>
      yes
  ```

  任何需要但未指定的信息都将列出供选择，并且在启动作业之前，系统将提示您接受、拒绝或修改要运行的作业的参数，除非您指定了 yes ，在这种情况下，作业将立即发送到调度程序。

  如果您希望在以后启动作业，可以通过设置 “ When ” 时间来实现。使用 mod 选项并选择 When（第 6 项）。然后以 YYYY-MM-DD HH:MM:SS 格式输入所需的开始时间。

  run 命令的 spooldata 参数不能通过菜单修改，只能通过在初始命令行上设置其值来访问。If no spooldata flag is set, the job, storage  or schedule flag is used.如果未设置 spooldata 标志，则使用作业、存储或计划标志。

- setbandwidth

  此命令（版本 >= 12.4.1）用于限制正在运行的作业或客户端的带宽。

  ```bash
  setbandwidth limit=<nb> [jobid=<id> | client=<cli>]
  ```

- setdebug

  此命令用于设置每个守护程序中的调试级别。此命令的格式为：

  ```bash
  setdebug level=nnn [trace=0/1 client=<client-name> | dir | director | storage=<storage-name> | all]
  ```

  每个守护进程通常都将 debug 编译到程序中，但被禁用。有两种方法可以启用调试输出。

  一种是在启动守护进程时在命令行上添加 -d nnn 选项。nnn 是调试级别，通常介于 50 到 200 之间是合理的。数字越高，产出越多。输出被写入标准输出。

  获取调试输出的第二种方法，是在控制台使用 setdebug level=nnn 命令动态打开它。如果没有给出任何选项，命令将提示您。您可以在任何或所有守护进程中选择性地打开/关闭调试（i.e. it is not necessary to specify all the components of the above  command即，没有必要指定上述命令的所有组件）。

  如果设置了 trace=1 ，那么跟踪将被启用，守护进程将被置于跟踪模式，这意味着调试级别设置的所有调试输出将被定向到守护进程当前目录中的跟踪文件。跟踪时，每个调试输出消息都被追加到跟踪文件中。完成后必须显式删除该文件。

  ```bash
  *setdebug level=100 trace=1 dir 
  level=100 trace=1 hangup=0 timestamp=0 tracefilename=/var/lib/bareos/bareos-dir.example.com.trace
  ```

- setdevice

  This command is used to set [`Auto Select (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoSelect) of a device resource in the Bareos Storage Daemon. This command can be  used to temporarily disable that a device is automatically selected in  an autochanger. The setting is only valid until the next restart of the Bareos Storage Daemon. The form of this command is: 

  此命令用于在Bareos Storage Daemon中设置设备资源的自动选择（Sd->Device）。此命令可用于暂时禁止自动转换器中自动选择设备。

  该设置仅在下次重新启动Bareos Storage Daemon之前有效。此命令的格式为：

  ```bash
  setdevice storage=<storage-name> device=<device-name> autoselect=<bool>
  ```

  注意：请考虑命令ACL（Dir->Console）和存储ACL（Dir->Console）的设置。Note: Consider the settings of [`Command ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CommandACL) and [`Storage ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_StorageACL).

- setip

  Sets new client address – if authorized. 

  设置新的客户端地址-如果授权。

  仅当控制台在Director和控制台中均具有控制台资源定义时，才授权该控制台使用SetIP命令。此外，如果Name =指令中提供的控制台名称必须与客户端名称相同，则允许该控制台的用户使用SetIP命令将Director客户端资源中的Address指令更改为控制台的IP地址。这允许笔记本电脑或其他使用DHCP（非固定IP地址）的计算机将其当前IP地址“通知”Director。

  A console is authorized to use the SetIP command only if it has a Console resource definition in both the Director and the  Console. In addition, if the console name, provided on the Name =  directive, must be the same as a Client name, the user of that console  is permitted to use the SetIP command to change the Address directive in the Director’s client resource to the IP address of the Console. This  permits portables or other machines using DHCP (non-fixed IP addresses)  to “notify” the Director of their current IP address.

- show

  The show command will list the Director’s resource records as defined in the Director’s configuration. **help show** will show you all available options.The following keywords are accepted on the show command line:

  show命令将列出控制器配置中定义的控制器资源记录。help show将显示所有可用选项。show命令行接受以下关键字：

  ```bash
  *help show
  Command            Description
  =======            ===========
  show               Show resource records
  
  Arguments:
  		catalog=<catalog-name> |
          client=<client-name> |
          ...
          storages |
          disabled [ clients | jobs | schedules ] |
          all [verbose]
  ```

   **show all** will show you all available resources. The **verbose** argument will show you also all configuration directives with there default value: 

  show all将显示所有可用资源。verbose参数还将显示所有具有默认值的配置指令：

  ```bash
  *show client=bareos-fd verbose
  Client {
  	Name = "bareos-fd"
      Description = "Client resource of the Director itself."
      Address = "localhost"
      #  Port = 9102
      Password = "*************************************"
      #  Catalog = "MyCatalog"
      #  Passive = no
      #  ConnectionFromDirectorToClient = yes
      #  ConnectionFromClientToDirector = no
      #  Enabled = yes
      ...
  }
  ```

   If you are not using the default console, but a named console, ACLs are applied. Additionally, if the named console don’t have the permission to run the **configure** command, some resources (like consoles and profiles) are not shown at all. Please don’t confuse this command with the **list** command, which displays the contents of the catalog.

  如果不使用默认控制台，而是使用命名控制台，则将应用命名控制台。此外，如果命名的控制台没有运行configure命令的权限，则根本不会显示某些资源（如控制台和配置文件）。

  请不要将此命令与显示目录内容的list命令混淆。

- sqlquery

  The  sqlquery command puts the Console program into SQL query mode where each line you enter is concatenated to the previous line until a semicolon  (;) is seen. The semicolon terminates the command, which is then passed  directly to the SQL database engine. When the output from the SQL engine is displayed, the formation of a new SQL command begins. To terminate  SQL query mode and return to the Console command prompt, you enter a  period (.) in column 1.

  sqlquery命令将Console程序置于SQL查询模式，在该模式下，您输入的每一行都将与前一行连接在一起，直到看到一个分号（;）。SQL Server将终止命令，然后将命令直接传递到SQL数据库引擎。当显示SQL引擎的输出时，就开始形成新的SQL命令。要终止SQL查询模式并返回到控制台命令提示符，请输入句点（.）第1栏。

  使用此命令，可以直接查询SQL目录数据库。注意，你应该真正知道你在做什么，否则你可能会损坏目录数据库。请参阅下面的查询命令，以获得更简单、更安全的输入SQL查询的方法。

   Using this command, you can query the SQL catalog database directly.  Note you should really know what you are doing otherwise you could  damage the catalog database. See the query command below for simpler and safer way of entering SQL queries. Depending on what database engine you are using (MySQL,  PostgreSQL or SQLite), you will have somewhat different SQL commands  available. For more detailed information, please refer to the MySQL,  PostgreSQL or SQLite documentation.

- status

  This command will display the status of all components. For the  director, it will display the next jobs that are scheduled during the  next 24 hours as well as the status of currently running jobs. For the  Storage Daemon, you will have drive status or autochanger content. The  File Daemon will give you information about current jobs like average  speed or file accounting. The full form of this command is: 

  此命令将显示所有组件的状态。对于控制器，它将显示在接下来的24小时内计划的下一个作业以及当前正在运行的作业的状态。对于存储守护程序，您将拥有驱动器状态或自动转换器内容。文件守护程序将给予您有关当前作业的信息，如平均速度或文件会计。此命令的完整形式为：

  ```bash
  status [all | dir=<dir-name> | director | scheduler | schedule=<schedule-name> |
  	client=<client-name> | storage=<storage-name> slots | subscriptions | configuration]
  ```

   If you do a status dir, the console will list any currently running  jobs, a summary of all jobs scheduled to be run in the next 24 hours,  and a listing of the last ten terminated jobs with their statuses. The  scheduled jobs summary will include the Volume name to be used. You  should be aware of two things: 1. to obtain the volume name, the code  goes through the same code that will be used when the job runs, but it  does not do pruning nor recycling of Volumes; 2. The Volume listed is at best a guess. The Volume actually used may be different because of the time  difference (more durations may expire when the job runs) and another job could completely fill the Volume requiring a new one. In the Running Jobs listing, you may find the following types of information: 

  如果您执行状态目录，控制台将列出所有当前正在运行的作业，计划在未来24小时内运行的所有作业的摘要，以及最近十个已终止作业及其状态的列表。计划的作业摘要将包括要使用的卷名称。你应该知道两件事：1。为了获得卷名，代码将遍历作业运行时将使用的相同代码，但它不进行修剪，也不回收卷名; 2.所列出的数量充其量只是一个猜测。实际使用的卷可能因时间差异而不同（作业运行时可能会有更多持续时间到期），另一个作业可能会完全填满卷，需要一个新的卷。

  在“正在运行的作业”列表中，您可以找到以下类型的信息：

  ```bash
  2507 Catalog MatouVerify.2004-03-13_05.05.02 is waiting execution
  5349 Full    CatalogBackup.2004-03-13_01.10.00 is waiting for higher
  			priority jobs to finish
  5348 Differe Minou.2004-03-13_01.05.09 is waiting on max Storage jobs
  5343 Full    Rufus.2004-03-13_01.05.04 is running `
  ```

   Looking at the above listing from bottom to top, obviously JobId 5343 (Rufus) is running. JobId 5348 (Minou) is waiting for JobId 5343 to  finish because it is using the Storage resource, hence the “waiting on  max Storage jobs”. JobId 5349 has a lower priority than all the other  jobs so it is waiting for higher priority jobs to finish, and finally,  JobId 2507 (MatouVerify) is waiting because only one job can run at a  time, hence it is simply “waiting execution” If you do a status dir, it will by default list the first occurrence  of all jobs that are scheduled today and tomorrow. If you wish to see  the jobs that are scheduled in the next three days (e.g. on Friday you  want to see the first occurrence of what tapes are scheduled to be used  on Friday, the weekend, and Monday), you can add the days=3 option.  Note, a days=0 shows the first occurrence of jobs scheduled today only.  If you have multiple run statements, the first occurrence of each run statement for the job will be displayed for the period specified. If your job seems to be blocked, you can get a general idea of the  problem by doing a status dir, but you can most often get a much more  specific indication of the problem by doing a status storage=xxx. For  example, on an idle test system, when I do status storage=File, I get: 

  从下到上看上面的清单，显然JobId 5343（Rufus）正在运行。JobId 5348（Minou）正在等待JobId 5343完成，因为它正在使用存储资源，因此“等待最大存储作业”。JobId 5349的优先级低于所有其他作业，因此它正在等待更高优先级的作业完成，最后，JobId 2507（MatouVerify）正在等待，因为一次只能运行一个作业，因此它只是“等待执行”。

  如果你做一个状态目录，它将默认列出今天和明天计划的所有作业的第一个出现。如果您希望查看计划在未来三天内执行的作业（例如，您希望在星期五查看计划在星期五、周末和星期一使用的磁带的第一次出现），则可以添加days=3选项。请注意，days=0仅显示今天排定的作业的首次出现。如果有多个run语句，则将在指定的时间段内显示作业的每个run语句的第一次出现。

  如果您的作业似乎被阻塞了，您可以通过执行status dir来大致了解问题，但您通常可以通过执行status storage=xxx来获得更具体的问题指示。例如，在一个空闲的测试系统上，当我执行status storage=File时，我得到：

  ```bash
  *status storage=File
  Connecting to Storage daemon File at 192.168.68.112:8103
  
  rufus-sd Version: 1.39.6 (24 March 2006) i686-pc-linux-gnu redhat (Stentz)
  Daemon started 26-Mar-06 11:06, 0 Jobs run since started.
  
  Running Jobs:
  No Jobs running.
  ====
  
  Jobs waiting to reserve a drive:
  ====
  
  Terminated Jobs:
  JobId  Level   Files          Bytes Status   Finished        Name
  ======================================================================
     59  Full    234            4,417,599 OK   15-Jan-06 11:54 usersave
  ====
  
  Device status:
  Autochanger "DDS-4-changer" with devices:
  	"DDS-4" (/dev/nst0)
  Device "DDS-4" (/dev/nst0) is mounted with Volume="TestVolume002"
  Pool="*unknown*"
  	Slot 2 is loaded in drive 0.
      Total Bytes Read=0 Blocks Read=0 Bytes/block=0
      Positioned at File=0 Block=0
  
  Device "File" (/tmp) is not open.
  ====
  
  In Use Volume status:
  ==== `  
  ```

  Now, what this tells me is that no jobs are running and that none of  the devices are in use. Now, if I unmount the autochanger, which will  not be used in this example, and then start a Job that uses the File  device, the job will block. When I re-issue the status storage command, I get for the Device status: 

  现在，这告诉我没有作业正在运行，也没有设备在使用。现在，如果我卸载自动转换器（本示例中不会使用该自动转换器），然后启动使用File设备的作业，则该作业将阻塞。当我重新发出status storage命令时，我得到设备状态：

  ```bash
  *status storage=File
  ...
  Device status:
  Autochanger "DDS-4-changer" with devices:
  	"DDS-4" (/dev/nst0)
  Device "DDS-4" (/dev/nst0) is not open.
  	Device is BLOCKED. User unmounted.
      Drive 0 is not loaded.
  
  Device "File" (/tmp) is not open.
  	Device is BLOCKED waiting for media.
  ====
  ...
  ```

   Now, here it should be clear that if a job were running that wanted  to use the Autochanger (with two devices), it would block because the  user unmounted the device. The real problem for the Job I started using  the “File” device is that the device is blocked waiting for media – that is Bareos needs you to label a Volume. 

  现在，应该清楚的是，如果正在运行的作业想要使用自动转换器（带有两个设备），它将被阻止，因为用户卸载了该设备。我开始使用“文件”设备的作业的真实的问题是设备被阻塞等待媒体-也就是说Bareos需要你标记一个卷。

  * status scheduler

    The command **status scheduler** (*Version >= 12.4.4*) can be used to check when a certain schedule will trigger. This gives more information than **status director**. Called without parameters, **status scheduler** shows a preview for all schedules for the next 14 days. It first shows a list of the known schedules and the jobs that will be triggered by  these jobs, and next, a table with date (including weekday), schedule  name and applied overrides is displayed: 

    命令status scheduler（Version >= 12.4.4）可以用来检查某个调度何时触发。这提供了比状态控制器更多的信息。

    在没有参数的情况下调用，状态调度程序显示未来14天所有调度的预览。它首先显示已知计划和将由这些作业触发的作业的列表，然后显示包含日期（包括工作日）、计划名称和应用的覆盖的表：

    ```bash
    *status scheduler
    Scheduler Jobs:
    
    Schedule               Jobs Triggered
    ===========================================================
    WeeklyCycle
    						BackupClient1
    WeeklyCycleAfterBackup
    						BackupCatalog
    ====
    
    Scheduler Preview for 14 days:
    
    Date                  Schedule                Overrides
    ==============================================================
    Di 04-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Di 04-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Mi 05-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Mi 05-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Do 06-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Do 06-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Fr 07-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Fr 07-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Sa 08-Jun-2013 21:00  WeeklyCycle             Level=Differential
    Mo 10-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Mo 10-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Di 11-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Di 11-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Mi 12-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Mi 12-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Do 13-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Do 13-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Fr 14-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Fr 14-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full
    Sa 15-Jun-2013 21:00  WeeklyCycle             Level=Differential
    Mo 17-Jun-2013 21:00  WeeklyCycle             Level=Incremental
    Mo 17-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full 
    ====
    ```

    **status scheduler** 接受以下参数：

    * client=clientname

      仅显示影响给定客户端的计划。

    * job=jobname

      shows only the schedules that affect the given job. 仅显示影响给定作业的计划。

    * schedule=schedulename

      仅显示给定的时间表。

    * days=number

      of days shows only the number of days in the scheduler preview.  Positive numbers show the future, negative numbers show the past. days  can be combined with the other selection criteria. days= can be combined with the other selection criteria. of days仅显示计划程序预览中的天数。正数表示未来，负数表示过去。可以与其他选择标准相结合。天数=可以与其他选择标准结合使用。

  * status subscriptions

    In case you have a service contract for Bareos, the command **status subscriptions**  can help you to keep the overview over the subscriptions that are used.

    Using the console command **status subscriptions**, the status of the subscriptions can be checked any time interactively:

    如果您有Bareos的服务合同，命令状态订阅可以帮助您查看所使用的订阅。

    使用控制台命令status subscriptions，可以随时以交互方式检查订阅的状态：

    ```bash
    *status subscriptions
    Automatically selected Catalog: MyCatalog
    Using Catalog "MyCatalog"
    
    Backup unit totals:
           used: 42
     configured: 100
      remaining: 58
    ```

    

    This shows the backup units that are used by your current setup. It also shows the value configured in [`Subscriptions (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Subscriptions) and the difference between the two (i.e. how many units you have remaining). You can configure [`Subscriptions (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Subscriptions) to the amount of units you have subscribed. However, this does not have any effect on the system outside of the **status subscriptions** and is completely optional.

    这将显示当前设置使用的备份设备。它还显示了订阅中配置的值（Dir->Director）以及两者之间的差异（即您剩余的单位数）。您可以将订阅（Director->Director）配置为您已订阅的单位数量。但是，这对状态订阅之外的系统没有任何影响，并且是完全可选的。

    如果您需要更详细的信息，哪个客户端使用了多少备份单元，您可以使用状态订阅详细信息，它将显示客户端和文件集的详细列表以及每个客户端和文件集消耗的备份单元的数量。

    If you need more detailed information which client uses how many backup units, you can use **status subscriptions detail** which will show a detailed list of clients and filesets and the amount of backup units each of these consumes.

    ```bash
    *status subscriptions detail
    
    Detailed backup unit report:
    +------------------+------------------+----------+----------+-------------+--------------+
    | client           | fileset          | db_units | vm_units | filer_units | normal_units |
    +------------------+------------------+----------+----------+-------------+--------------+
    | bareos-fd        | <all file-based> |          |          |             | 1            |
    | dbsrv1-fd        | <all file-based> |          |          |             | 1            |
    | dbsrv1-fd        | mssql-dev-db     |        1 |          |             |              |
    | dbsrv1-fd        | mssql-prod-db    |        1 |          |             |              |
    | dbsrv2-fd        | mariadb-crm-db   |        1 |          |             |              |
    | dbsrv2-fd        | mariadb-web-db   |        1 |          |             |              |
    | filesrv-fd       | <all file-based> |          |          |             | 24           |
    | netapp-ndmp      | <all file-based> |          |          | 7           | 1            |
    | vcenter-proxy-fd | vm-cisrv         |          |        1 |             |              |
    | vcenter-proxy-fd | vm-crmsrv        |          |        1 |             |              |
    | vcenter-proxy-fd | vm-printsrv      |          |        1 |             |              |
    | websrv-fd        | <all file-based> |          |          |             | 1            |
    | TOTAL            |                  |        4 |        3 | 7           | 28           |
    +------------------+------------------+----------+----------+-------------+--------------+
    
    Backup unit totals:
           used: 42
     configured: 100
      remaining: 58
    ```

    Some clients and/or filesets may not be listed in the detailed report and also not be accounted. You can get a list of these systems and filesets with **status subscriptions unknown**.

    某些客户端和/或文件集可能未在详细报告中列出，也未被计入。您可以获得这些系统和状态订阅未知的文件集的列表。

    ```bash
    *status subscriptions unknown
    
    Clients/Filesets that cannot be categorized for backup units yet:
    +----------------------+-----------------------------------------+-------------+
    | client               | fileset                                 | filesettext |
    +----------------------+-----------------------------------------+-------------+
    | websrv-fd            | Archive Set                             | <empty>     |
    | legayc-system-fd     | very-old-filset                         | <empty>     |
    +----------------------+-----------------------------------------+-------------+
    
    Amount of data that cannot be categorized for backup units yet:
             unknown_mb: 1510970
     unknown_percentage: 2.50
    ```

    > Limitation: status subscription provides only an approximation
    >
    > The backup units determined by **status subscription** are an approximation that covers the basics. If you back up the same files with different filesets, this data would be accounted twice. When you back up a VM using a plugin and with a filedaemon installed inside of the VM, that will also be accounted twice.
    >
    > 限制：状态订阅仅提供近似值
    >
    > 由状态订阅确定的备份单元是涵盖基本内容的近似值。如果您使用不同的文件集备份相同的文件，则此数据将被计算两次。当您使用插件备份VM并在VM内部安装了filedaemon时，也会被计入两次。

  * status configuration

    Using the console command **status configuration** will show a list of deprecated configuration settings that were  detected when loading the director’s configuration. Be sure to enable  access to the “configuration” command by using the according command  ACL.
    
    使用控制台命令status configuration将显示加载控制器配置时检测到的不推荐使用的配置设置的列表。确保使用相应的命令ACL启用对“configuration”命令的访问。

- time

  The time command shows the current date, time and weekday.time命令显示当前日期、时间和工作日。

- trace

  Turn on/off trace to file.打开/关闭跟踪到文件。

- truncate

  If the status of a volume is **Purged**, it normally still contains data, even so it can not easily be accessed.如果卷的状态为“已清除”，则通常仍包含数据，即使这样也无法轻松访问。

  ```bash
  truncate volstatus=Purged [storage=<storage>] [pool=<pool>] [volume=<volume>] [yes]
  ```

  When using a disk volume (and other volume types also) the volume  file still resides on the Bareos Storage Daemon. If you want to reclaim  disk space, you can use the **truncate volstatus=Purged** command. When used on a volume, it rewrites the header and by this frees the rest of the disk space.

  If the volume you want to get rid of has not the **Purged** status, you first have to use the **prune volume** or even the **purge volume** command to free the volume from all remaining jobs.

  This command is available since Bareos *Version >= 16.2.5*.

  当使用磁盘卷（以及其他卷类型）时，卷文件仍然驻留在Bareos Storage Daemon上。如果要回收磁盘空间，可以使用truncate volstatus=Purged命令。当在卷上使用时，它重写头，并通过此释放其余的磁盘空间。默认情况下，使用自动转换器的第一个驱动器（编号0）。通过指定drive=<drivenum>，可以选择不同的驱动器。

  如果要删除的卷没有“已清除”状态，则必须首先使用prune volume（删除卷）甚至purge volume（清除卷）命令来从所有剩余作业中释放该卷。

  此命令自Bareos版本&gt;= 16.2.5起可用。驱动器=<drivenum>选项是在版本&gt;= 20.0.2中添加的。

- umount

  Alias for **unmount**.

- unmount

  This  command causes the indicated Bareos Storage daemon to unmount the  specified device. The forms of the command are the same as the mount  command:此命令会导致指定的Bareos Storage守护程序卸载指定的设备。命令的格式与mount命令相同：

  ```bash
  unmount storage=<storage-name> [drive=<num>]
  unmount [jobid=<id> | job=<job-name>]
  ```

  Once you unmount a storage device, Bareos will no longer be able to  use it until you issue a mount command for that device. If Bareos needs  to access that device, it will block and issue mount requests  periodically to the operator. If the device you are unmounting is an autochanger, it will unload  the drive you have specified on the command line. If no drive is  specified, it will assume drive 1. In most cases, it is preferable to use the **release** instead.

  卸载存储设备后，Bareos将无法再使用它，直到您为该设备发出mount命令。如果Bareos需要访问该设备，它将阻止并定期向操作员发出挂载请求。

  如果要卸载的设备是自动转换器，它将卸载您在命令行中指定的驱动器。如果未指定驱动器，则将假定为驱动器1。

  在大多数情况下，最好使用释放。

- update

  This command will update the catalog for either a specific Pool  record, a Volume record, or the Slots in an autochanger with barcode  capability. In the case of updating a Pool record, the new information  will be automatically taken from the corresponding Director’s  configuration resource record. It can be used to increase the maximum  number of volumes permitted or to set a maximum number of volumes. The following main keywords may be specified: 

  此命令将为特定池记录、卷记录或具有条形码功能的自动转换器中的插槽更新目录。在更新池记录的情况下，新信息将自动从相应控制器的配置资源记录中获取。它可用于增加允许的最大卷数或设置最大卷数。可以指定以下主要关键字：

  * volume
  * pool
  * slots
  * iobid
  * stats

  In the case of updating a Volume (**update volume**), you will be prompted for which value you wish to change. The following Volume parameters may be changed: 在更新卷（更新卷）的情况下，系统将提示您要更改的值。可以更改以下音量参数：

  ```bash
  Volume Status
  Volume Retention Period
  Volume Use Duration
  Maximum Volume Jobs
  Maximum Volume Files
  Maximum Volume Bytes
  Recycle Flag
  Recycle Pool
  Slot
  InChanger Flag
  Pool
  Volume Files
  Volume from Pool
  All Volumes from Pool
  All Volumes from all Pools
  ```

  For slots **update slots**, Bareos will obtain a list of slots and their barcodes from the Storage  daemon, and for each barcode found, it will automatically update the  slot in the catalog Media record to correspond to the new value. This is very useful if you have moved cassettes in the magazine, or if you have removed the magazine and inserted a different one. As the slot of each  Volume is updated, the InChanger flag for that Volume will also be set,  and any other Volumes in the Pool that were last mounted on the same Storage device  will have their InChanger flag turned off. This permits Bareos to know  what magazine (tape holder) is currently in the autochanger. If you do not have barcodes, you can accomplish the same thing by using the **update slots scan** command. The **scan** keyword tells Bareos to physically mount each tape and to read its VolumeName. For Pool **update pool**, Bareos will move the Volume record from its existing pool to the pool specified. For Volume from Pool, All Volumes from Pool and All Volumes from all  Pools, the following values are updated from the Pool record: Recycle,  RecyclePool, VolRetention, VolUseDuration, MaxVolJobs, MaxVolFiles, and  MaxVolBytes. For updating the statistics, use **updates stats**, see [Job Statistics](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-jobstatistics). The full form of the update command with all command line arguments is: 

  对于插槽更新插槽，Bareos将从存储守护程序获取插槽及其条形码的列表，对于找到的每个条形码，它将自动更新目录介质记录中的插槽以对应于新值。如果您在杂志中移动了磁带盒，或者您已取出杂志并插入了另一个磁带盒，则此操作非常有用。随着每个卷的插槽更新，该卷的InChanger标志也将被设置，池中最后装载在同一存储设备上的任何其他磁盘将关闭其InChanger标志。这样，Bareos就可以知道自动换碟机中当前有什么杂志（磁带保持器）。

  如果您没有条形码，您可以通过使用更新插槽扫描命令来完成相同的事情。scan关键字告诉Bareos物理挂载每个磁带并读取其VolumeName。

  对于池更新池，Bareos将卷记录从其现有池移动到指定的池。

  对于“来自池的卷”、“来自池的所有卷”和“来自所有卷的所有卷”，将从池记录中更新以下值：“回收”、“卷池”、“卷保留”、“卷持续时间”、“最大卷作业”、“最大卷文件”和“最大卷”。

  要更新统计信息，请使用更新统计信息，请参阅作业统计信息。

  带有所有命令行参数的update命令的完整形式是：

  ```bash
  update  volume=<volume-name> [volstatus=<status>]
  	[volretention=<time-def>] [pool=<pool-name>]
  	[recycle=<yes/no>] [slot=<number>] [inchanger=<yes/no>] |
      pool=<pool-name> [maxvolbytes=<size>] [maxvolfiles=<nb>]
      [maxvoljobs=<nb>][enabled=] [recyclepool=<pool-name>]
      [actiononpurge=<action>] |
      slots [storage=<storage-name>] [scan] |
      jobid=<jobid> [jobname=<name>] [starttime=<time-def>]
      [client=<client-name>] [filesetid=<fileset-id>]
      [jobtype=<job-type>] |
      stats [days=<number>]
  ```

- use

  This command allows you to specify which Catalog database to use.  Normally, you will be using only one database so this will be done  automatically. In the case that you are using more than one database,  you can use this command to switch from one to another. 

  此命令允许您指定要使用的目录数据库。通常，您将只使用一个数据库，因此这将自动完成。在使用多个数据库的情况下，可以使用此命令从一个数据库切换到另一个数据库。

  ```bash
  use [catalog=<catalog>]
  ```

- var

  This command takes a string or quoted string and does variable expansion on it mostly the same way variable expansion is done on the [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) string. The difference between the **var** command and the actual [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) process is that during the var command, no job is running so dummy values are used in place of Job specific variables.

  这个命令接受一个字符串或带引号的字符串，并对它进行变量扩展，其方式与对标签格式（Dir->Pool）字符串进行变量扩展的方式大致相同。var命令和实际的标签格式（Dir->Pool）过程之间的区别在于，在var命令期间，没有作业正在运行，因此使用虚拟值代替作业特定变量。

- version

  该命令打印 Director 的版本。

- wait

  The wait command causes the Director to pause until there are no jobs running.  This command is useful in a batch situation such as regression testing  where you wish to start a job and wait until that job completes before  continuing. This command now has the following options: 

  wait命令会使Director暂停，直到没有作业正在运行。当您希望启动作业并等待作业完成后再继续时，此命令非常有用。此命令现在具有以下选项：

  ```
  wait [jobid=<jobid>] [jobuid=<unique id>] [job=<job name>]
  ```

  If specified with a specific JobId, … the wait command will wait for that particular job to terminate before continuing.

  如果指定了特定的JobId，. wait命令将等待该特定作业终止后再继续。

- whoami

  打印与此控制台关联的用户名。

### 特别 dot (.) 命令

有一个以句点（.）为前缀的命令列表。这些命令旨在由批处理程序或图形用户界面前端使用。它们通常不被交互式用户使用。

### 特别 At (@) 命令

通常，输入到 Console 程序的所有命令都会立即转发到 Director（可能位于另一台计算机上）执行。但是，有一个小的 at 命令列表，所有的都以 at 字符（@）开头，这些命令不会发送到 Director，而是由 bconsole 程序直接解释。这些命令是：

- `@input <filename>`

  读取并执行指定文件中包含的命令。

- `@output <filename> <w|a>`

  Send all following output to the filename specified either overwriting the file  (w) or appending to the file (a). To redirect the output to the  terminal, simply enter @output without a filename specification.  WARNING: be careful not to overwrite a valid file. A typical example  during a regression test might be: 

  将以下所有输出发送到指定的文件名，或者将其添加到文件（w）或附加到文件（a）。要将输出重定向到终端，只需输入@output而不指定文件名。注意不要覆盖一个有效的文件。一个典型的例子可能是：

  ```bash
  @output /dev/null
  commands ...
  @output
  ```

- `@tee <filename> <w|a>`

  Send all subsequent  output to both the specified file and the terminal. It is turned off by  specifying @tee or @output without a filename.将所有后续输出发送到指定的文件和终端。通过指定不带文件名的@tee或@output可以关闭该选项。

- `@sleep <seconds>`

  Sleep the specified number of seconds.休眠指定的秒数。

- `@time`

  打印当前时间和日期。

- `@version`

  打印控制台的版本。

- `@quit`

  退出

- `@exit`

  退出

- `@# anything`

  Comment评论

- `@help`

  Get the list of every special @ commands.获取每个特殊@命令的列表。

- `@separator <char>`

  When  using bconsole with readline, you can set the command separator to one  of those characters to write commands who require multiple input on one  line, or to put multiple commands on a single line.在使用bconsole和readline时，您可以将命令分隔符设置为以下字符之一，以将需要多个输入的命令写入一行，或者将多个命令放在一行上。 
  
  ```bash
  !$%&'()*+,-/:;<>?[]^`{|}~ 
  ```
  
   Note, if you use a semicolon (;) as a separator  character, which is common, you will not be able to use the sql command, which requires each command to be terminated by a semicolon.请注意，如果您使用分号（;）作为分隔符（这是常见的），则将无法使用sql命令，因为该命令要求每个命令都以分号终止。

## 运行一个作业 

假设目前使用的是默认配置文件。

输入 `show filesets` ，查看文件集：

```bash
*show filesets
...
FileSet {
  Name = "SelfTest"
  Include {
    Options {
      Signature = MD5
    }
    File = "/usr/sbin"
  }
}

FileSet {
  Name = "Catalog"
  Include {
    Options {
      Signature = MD5
    }
    File = "/var/lib/bareos/bareos.sql"
    File = "/etc/bareos"
  }
}
...
```

其中一个文件集是预定义的 `SelfTest (Dir->Fileset)` 文件集，它将备份 `/usr/sbin` 目录。文件集 `Catalog (Dir->Fileset)` 用于备份 Bareos 的目录。可以通过编辑配置并更改 `Fileset (Dir)` 资源中的 `File =` 行来更改备份内容。

现在是运行第一个备份作业的时候了。我们将把 Bareos 源目录备份到 /var/lib/bareos/storage/ 目录中的一个文件卷，只是为了向你展示它是多么容易。现在输入：

```bash
*status dir
bareos-dir Version: 13.2.0 (09 April 2013) x86_64-pc-linux-gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23-May-13 13:17. Jobs: run=0, running=0 mode=0
 Heap: heap=270,336 smbytes=59,285 max_bytes=59,285 bufs=239 max_bufs=239

Scheduled Jobs:
Level          Type     Pri  Scheduled          Name               Volume
===================================================================================
Incremental    Backup    10  23-May-13 23:05    BackupClient1      testvol
Full           Backup    11  23-May-13 23:10    BackupCatalog      testvol
====

Running Jobs:
Console connected at 23-May-13 13:34
No Jobs running.
====
```

这表明计划在凌晨 1:05 为作业 `BackupClient1 (Dir->Job)` 运行增量作业，并计划在1:10运行 `BackupCatalog (Dir->Job)` 。

```bash
*status client
Automatically selected Client: bareos-fd
Connecting to Client bareos-fd at bareos:9102

bareos-fd Version: 13.2.0 (09 April 2013)  x86_64-pc-linux-gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23-May-13 13:17. Jobs: run=0 running=0.
 Heap: heap=135,168 smbytes=26,000 max_bytes=26,147 bufs=65 max_bufs=66
 Sizeof: boffset_t=8 size_t=8 debug=0 trace=0 bwlimit=0kB/s

Running Jobs:
Director connected at: 23-May-13 13:58
No Jobs running.
====
```

在本例中，客户机名为 `bareos-fd (Dir->Client)` 。您的名称可能不同，但以 `bareos-fd Version` 开头的行是由您的 bareos 文件守护程序打印的，因此我们现在确定它已启动并正在运行。

最后，对您的 Bareos Storage Daemon 执行相同的操作：

```bash
*status storage
Automatically selected Storage: File
Connecting to Storage daemon File at bareos:9103

bareos-sd Version: 13.2.0 (09 April 2013) x86_64-pc-linux-gnu debian Debian GNU/Linux 6.0 (squeeze)
Daemon started 23-May-13 13:17. Jobs: run=0, running=0.
 Heap: heap=241,664 smbytes=28,574 max_bytes=88,969 bufs=73 max_bufs=74
 Sizes: boffset_t=8 size_t=8 int32_t=4 int64_t=8 mode=0 bwlimit=0kB/s

Running Jobs:
No Jobs running.
====

Device status:

Device "FileStorage" (/var/lib/bareos/storage) is not open.
==
====

Used Volume status:
====

====
```

将注意到，默认的 Bareos 存储守护程序设备名为 `File (Dir->Storage)` ，它将使用设备 `/var/lib/bareos/storage` ，该设备当前未打开。

现在，实际运行一个作业：

```bash
run
```

选择作业：

```bash
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"
A job name must be specified.
The defined Job resources are:
     1: BackupClient1
     2: BackupCatalog
     3: RestoreFiles
Select Job resource (1-3):
```

Bareos 列出了可以运行的三个不同的作业，选择数字 1 并键入 enter ：

```bash
Run Backup job
JobName:  BackupClient1
Level:    Incremental
Client:   bareos-fd
Format:   Native
FileSet:  SelfTest
Pool:     Full (From Job resource)
NextPool: *None* (From unknown source)
Storage:  File (From Job resource)
When:     2013-05-23 14:50:04
Priority: 10
OK to run? (yes/mod/no):
```

此时，请花一些时间仔细查看打印的内容并理解它。它会询问您是否可以使用FileSet  `SelfTest (Dir->Fileset)` 运行名为 `BackupClient1 (Dir->Job)` 的作业作为客户端上的增量作业，并使用存储 `File (Dir->Storage)` 和Pool `Full (Dir->Pool)` ，最后，它希望现在运行它（当前时间应该由您的控制台显示）。

在这里，我们可以选择运行（yes），修改上面的一个或多个参数（mod），或者不运行作业（no）。请输入 yes ，此时应立即得到命令提示符（星号）。

如果等待几秒钟，然后输入 `messages` 命令，将得到如下结果：

```bash
*messages
2023-09-23T09:50:04+0000 bareos-dir JobId 1: No prior Full backup Job record found.
2023-09-23T09:50:04+0000 bareos-dir JobId 1: No prior or suitable Full backup found in catalog. Doing FULL backup.
2023-09-23T09:50:06+0000 bareos-dir JobId 1: Start Backup JobId 1, Job=backup-bareos-fd.2023-09-23T09.50.04_03
2023-09-23T09:50:06+0000 bareos-dir JobId 1: Connected Storage daemon at localhost:9103, encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-dir JobId 1:  Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-dir JobId 1: Connected Client: bareos-fd at localhost:9102, encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-dir JobId 1:  Handshake: Immediate TLS
2023-09-23T09:50:06+0000 bareos-dir JobId 1:  Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-dir JobId 1: Created new Volume "Full-0001" in catalog.
2023-09-23T09:50:06+0000 bareos-dir JobId 1: Using Device "FileStorage" to write.
2023-09-23T09:50:06+0000 bareos-fd  JobId 1: Connected Storage daemon at localhost:9103, encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-fd  JobId 1:  Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
2023-09-23T09:50:06+0000 bareos-fd  JobId 1: Extended attribute support is enabled
2023-09-23T09:50:06+0000 bareos-fd  JobId 1: ACL support is enabled
2023-09-23T09:50:06+0000 bareos-sd  JobId 1: Labeled new Volume "Full-0001" on device "FileStorage" (/var/lib/bareos/storage).
2023-09-23T09:50:06+0000 bareos-sd  JobId 1: Wrote label to prelabeled Volume "Full-0001" on device "FileStorage" (/var/lib/bareos/storage)
2023-09-23T09:50:07+0000 bareos-sd  JobId 1: Releasing device "FileStorage" (/var/lib/bareos/storage).
2023-09-23T09:50:07+0000 bareos-sd  JobId 1: Elapsed time=00:00:01, Transfer rate=62.68 M Bytes/second
2023-09-23T09:50:07+0000 bareos-dir JobId 1: Insert of attributes batch table with 173 entries start
2023-09-23T09:50:07+0000 bareos-dir JobId 1: Insert of attributes batch table done
2023-09-23T09:50:07+0000 bareos-dir JobId 1: Bareos bareos-dir 23.0.0 (23Sep23):
  Build OS:               GNU/Linux
  JobId:                  1
  Job:                    backup-bareos-fd.2023-09-23T09.50.04_03
  Backup Level:           Full (upgraded from Incremental)
  Client:                 "bareos-fd" 23.0.0 (23Sep23) GNU/Linux
  FileSet:                "SelfTest" 2023-09-23T09:50:04+0000
  Pool:                   "Full" (From Job FullPool override)
  Catalog:                "MyCatalog" (From Client resource)
  Storage:                "File" (From Job resource)
  Scheduled time:         2023-09-23T09:48:54+0000
  Start time:             2023-09-23T09:50:06+0000
  End time:               2023-09-23T09:50:07+0000
  Elapsed time:           1 sec
  Priority:               10
  FD Files Written:       173
  SD Files Written:       173
  FD Bytes Written:       62,668,227 (62.66 MB)
  SD Bytes Written:       62,685,875 (62.68 MB)
  Rate:                   62668.2 KB/s
  Software Compression:   None
  VSS:                    no
  Encryption:             no
  Accurate:               no
  Volume name(s):         Full-0001
  Volume Session Id:      1
  Volume Session Time:    1695718743
  Last Volume Bytes:      62,706,904 (62.70 MB)
  Non-fatal FD errors:    0
  SD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Bareos binary info:     Bareos subscription release
  Job triggered by:       User
  Termination:            Backup OK
```

如果没有立即看到输出，则可以继续输入消息，直到作业终止。

您也可以要求 bconsole 等待特定作业完成，而不是多次键入 `messages` ：

```bash
*wait jobid=1
```

或者只是 `wait`，等待所有正在运行的作业完成。

另一个有用的命令是 `autodisplay on` 。当 autodisplay 激活时，消息一准备好就会自动显示。

如果对 `/var/lib/bareos/storage` 目录执行 `ls-l` 操作，将看到有以下项：

```bash
-rw-r-----    1 bareos bareos   39072153 Apr 28 14:30 Full-001
```

这是您刚刚写入的文件卷，它包含了刚刚运行的作业的所有数据。如果您运行其他作业，它们将被附加到此卷，除非您另有指定。

如果你想在这里停止，你可以简单地在控制台程序中输入 `quit` 。

## 恢复文件

如果已运行默认配置并按上述方式运行作业，则可以通过输入以下命令在控制台程序中还原备份的文件：

```bash
*restore all
First you select one or more JobIds that contain files
to be restored. You will be presented several methods
of specifying the JobIds. Then you will be allowed to
select which files from those JobIds are to be restored.

To select the JobIds, you have the following choices:
     1: List last 20 Jobs run
     2: List Jobs where a given File is saved
     3: Enter list of comma separated JobIds to select
     4: Enter SQL list command
     5: Select the most recent backup for a client
     6: Select backup for a client before a specified time
     7: Enter a list of files to restore
     8: Enter a list of files to restore before a specified time
     9: Find the JobIds of the most recent backup for a client
    10: Find the JobIds for a backup for a client before a specified time
    11: Enter a list of directories to restore for found JobIds
    12: Select full restore to a specified Job date
    13: Cancel
Select item:  (1-13):
```

有许多选项，但对于当前演示，请输入 5 来恢复您上次备份的数据，将获得以下输出：

```bash
Automatically selected Client: bareos-fd
The defined FileSet resources are:
     1: Catalog
     2: Full Set
Select FileSet resource (1-2):
```

Bareos 知道拥有什么客户机，而且由于只有一个客户机，所以它会自动选择它。选择 2 ，因为要从文件集中还原文件。

```bash
+-------+-------+----------+------------+---------------------+---------------+
| jobid | level | jobfiles | jobbytes   | starttime           | volumename    |
+-------+-------+----------+------------+---------------------+---------------+
|     1 | F     |      166 | 19,069,526 | 2013-05-05 23:05:02 | TestVolume001 |
+-------+-------+----------+------------+---------------------+---------------+
You have selected the following JobIds: 1

Building directory tree for JobId(s) 1 ...  +++++++++++++++++++++++++++++++++++++++++
165 files inserted into the tree and marked for extraction.

You are now entering file selection mode where you add (mark) and
remove (unmark) files to be restored. No files are initially added, unless
you used the "all" keyword on the command line.
Enter "done" to leave this mode.

cwd is: /
$
```

然后，Bareos 生成一个列表，其中包含构成当前备份的所有作业，在本例中，只有一个作业，并且还自动选择了 Storage 守护程序。然后，Bareos 获取 Job 1 中的所有文件，并将它们输入到一个目录树（a sort of in  memory representation of your filesystem一种文件系统的内存表示）中。此时，您可以使用 cd 、ls 或 dir 命令在目录树中上下移动，查看将要恢复的文件。例如，如果您输入 `cd /usr/sbin` ，然后输入 `dir` ，您将获得 `/usr/sbin/` 目录中所有文件的列表。在您的系统上，路径可能有所不同。

要退出此模式并取消还原，只需输入：`.`

要选择要恢复的所有文件，请输入：

```bash
cwd is: /
$ mark *
173 files marked.
$
```

要退出此模式并继续恢复操作，只需输入：

```bash
done
```

会得到如下输出：

```bash
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.2.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================

   Full-0001                 File                      FileStorage

Volumes marked with "*" are online.


173 files selected to be restored.

Run Restore job
JobName:         RestoreFiles
Bootstrap:       /var/lib/bareos/bareos-dir.restore.1.bsr
Where:           /tmp/bareos-restores
Replace:         Always
FileSet:         LinuxAll
Backup Client:   bareos-fd
Restore Client:  bareos-fd
Format:          Native
Storage:         File
When:            2023-09-23T09:55:09+0000
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no): yes
```

如果回答是，文件将被恢复到 `/tmp/bareos-restores` 。如果要将文件还原到其原始位置，必须使用 mod 选项并将 Where ：显式设置为 nothing（或 / ）。建议继续并回答是，并在短暂的片刻后输入 `messages`，此时应该会获得已恢复的所有文件的列表以及类似于以下内容的作业摘要：

```bash
23-May 15:24 bareos-dir JobId 2: Start Restore Job RestoreFiles.2013-05-23_15.24.01_10
23-May 15:24 bareos-dir JobId 2: Using Device "FileStorage" to read.
23-May 15:24 bareos-sd JobId 2: Ready to read from volume "TestVolume001" on device "FileStorage" (/var/lib/bareos/storage).
23-May 15:24 bareos-sd JobId 2: Forward spacing Volume "TestVolume001" to file:block 0:194.
23-May 15:58 bareos-dir JobId 3: Bareos bareos-dir 13.2.0 (09Apr13):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 6.0 (squeeze)
  JobId:                  2
  Job:                    RestoreFiles.2013-05-23_15.58.48_11
  Restore Client:         bareos-fd
  Start time:             23-May-2013 15:58:50
  End time:               23-May-2013 15:58:52
  Files Expected:         166
  Files Restored:         166
  Bytes Restored:         19,069,526
  Rate:                   9534.8 KB/s
  FD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Restore OK
```

退出控制台程序后，可以检查 `/tmp/bareos-restores` 中的文件，其中将包含一个包含所有文件的小目录树。最后一定要清理干净：

```bash
 rm -rf /tmp/bareos-restore
```

## 控制台命令



- help

  显示所有可用命令的列表。

- help list

  显示有关特定命令的详细信息，在本例中为命令 **list** 。

- status dir

  打印所有正在运行的和计划在未来 24 小时内执行的作业的状态。

- status

  控制台程序将提示您选择守护进程类型，然后请求守护进程的状态。

- status jobid=nn

  如果作业正在运行，则打印 ID 为 nn 的作业的状态。存储守护进程也会被联系，并请求打印作业的当前状态。

- list pools

  (normally only Default is used).列出目录中定义的池（通常仅使用默认值）。

- list volumes

  列出目录中定义的所有介质。

- list jobs

  列出目录中已运行的所有作业。

- list jobid=nn

  列出目录中 ID 为 nn 的作业。

- list jobtotals

  列出目录中所有作业的总计。

- list files jobid=nn

  列出 ID 为 nn 的作业所保存的文件。

- list jobmedia

  列出每个运行的作业的介质信息。

- messages

  打印已定向到控制台的任何消息。

- quit

  退出或退出控制台程序。

上面给出的大多数命令，除了 list，如果只输入命令名，就会提示您输入必要的参数。

