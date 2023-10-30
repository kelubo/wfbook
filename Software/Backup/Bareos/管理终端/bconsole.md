# bconsole

[TOC]

## 概述

为了与 Bareos Director 通信并查询 Bareos 的状态或运行作业，可以将 bconsole 程序用作文本界面。可替代地，对于大多数目的，也可以使用 Bareos Webui。

当前的 Bareos 控制台是一个 shell 界面（TTY 风格）。它允许管理员或授权用户与 Bareos 进行交互。您可以确定特定作业的状态、检查目录的内容以及使用 Console 程序执行某些磁带操作。

由于 Console 程序通过网络与 Director 交互，因此您的 Console 和 Director 程序不一定需要在同一台计算机上运行。

事实上，Bareos 需要对 Console 程序有一定的了解，才能在多个磁带上写入数据，因为当 Bareos 请求新磁带时，它会等待，直到用户通过Console程序指示新磁带已安装。

## 控制台配置

当控制台启动时，它读取一个名为 `bconsole.conf` 的标准 Bareos 配置文件，除非您指定 `-c` 命令行选项。此文件允许对控制台进行默认配置，并且当前定义的唯一资源记录是 Director 资源，该资源为控制台提供了 Director 的名称和地址。

## 运行控制台程序

可以使用以下选项运行控制台程序：

```bash
bconsole -?
Usage: bconsole [-s] [-c config_file] [-d debug_level]
       -D <dir>    select a Director
       -l          list Directors defined
       -c <path>   specify configuration file or directory
       -p <file>   specify pam credentials file
       -o          send pam credentials over unencrypted connection
       -d <nn>     set debug level to <nn>
       -dt         print timestamp in debug output
       -s          no signals
       -u <nn>     set command execution timeout to <nn> seconds
       -t          test - read configuration and exit
       -xc         print configuration and exit
       -xs         print configuration file schema in JSON format and exit
       -?          print this message.

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

where command is one of the commands listed below; keyword is one of  the keywords listed below (usually followed by an argument); and  argument is the value. The command may be abbreviated to the shortest  unique form. If two commands have the same starting letters, the one  that will be selected is the one that appears first in the help listing. If you want the second command, simply spell out the full command. None of the keywords following the command may be abbreviated.

其中 command 是下面列出的命令之一; keyword 是下面列出的关键字之一（通常后跟一个参数）; argument 是值。该命令可以缩写为最短的唯一形式。如果两个命令具有相同的起始字母，则将选择帮助列表中最先出现的命令。如果你想要第二个命令，只需拼出完整的命令。命令后的关键字都不能缩写。

例如：

```bash
list files jobid=23
```

将列出为 JobId 23 保存的所有文件。或者：

```bash
show pools
```

将显示所有池资源记录。

最大命令行长度限制为 511 个字符，因此如果您正在编写控制台脚本，则可能需要注意限制行长度。

## 退出控制台程序

通常，您只需输入 `quit` 或 `exit`，Console 程序就会终止。但是，它会等待控制器确认命令。如果 Director 正在执行一个较长的命令（例如 prune ），则可能需要一些时间。如果要立即终止 Console 程序，请输入 `.quit` 命令。

```bash
quit
exit
.quit
```

There is currently no way to interrupt a Console command once issued当前没有办法在控制台命令发出后中断（即 Ctrl - C 不起作用）。However, if you are at a prompt that is  asking you to select one of several possibilities and you would like to  abort the command, you can enter a period (.), and in most cases, 但是，如果提示符要求您从几种可能性中选择一种，并且您希望中止命令，则可以输入句点（.），you  will either be returned to the main command prompt or if appropriate the previous prompt (in the case of nested prompts). 在大多数情况下，您将返回到主命令提示符，或者如果合适，返回到上一个提示符（在嵌套提示符的情况下）。在一些地方，例如它要求卷名的地方，句号将被视为卷名。在这种情况下，you will most likely be able to cancel at the next prompt.您很可能可以在下一个提示时取消。

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

  Permitted on the update command to specify that all Volumes in the pool (specified on the command line) should be updated.允许在update命令中指定应更新池中（在命令行中指定）的所有缓存。

- allfrompools

  Permitted on the update command to specify that all Volumes in all pools should be updated.允许在update命令中指定应更新所有池中的所有VLAN。

- before

  在 restore 命令中使用。

- bootstrap

  在restore命令中使用。

- catalog

  Allowed in the use command to specify the catalog name to be used.允许在use命令中指定要使用的目录名称。

- catalogs

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- client | fd

  用于指定客户端（或 filedaemon ）。

- clients

  Used in the show, list, and llist commands. Takes no arguments.在show、list和llist命令中使用。不需要争论。

- counters

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- current

  Used in the restore command. Takes no argument.在restore命令中使用。不需要争论。

- days

  Used to define the number of days the **list nextvol** command should consider when looking for jobs to be run. The days keyword can also be used on the **status dir** command so that it will display jobs scheduled for the number of days you want. It can also be used on the **rerun** command, where it will automatically select all failed jobids in the last number of days for rerunning.

  用于定义list nextvol命令在查找要运行的作业时应考虑的天数。days关键字也可以用在status dir命令上，这样它就可以显示按您想要的天数调度的作业。它也可以用于restart命令，它将自动选择最近几天内所有失败的jobid重新运行。

- devices

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- director | dir | directors

  Used in the show and status command. Takes no arguments.在show和status命令中使用。不需要争论。

- directory

  在 restore 命令中使用。它的参数指定要还原的目录。

- enabled

  This keyword can appear on the **update volume** as well as the **update slots** commands, and can allows one of the following arguments: yes, true, no, false, archived, 0, 1, 2. Where 0 corresponds to no or false, 1  corresponds to yes or true, and 2 corresponds to archived. Archived  volumes will not be used, nor will the Media record in the catalog be  pruned. Volumes that are not enabled, will not be used for backup or  restore.

  此关键字可以出现在更新卷和更新插槽命令中，并且可以允许以下参数之一：yes、true、no、false、archived、0、1、2。其中0对应于否或假，1对应于是或真，2对应于存档。将不会使用存档卷，也不会修剪目录中的媒体记录。未启用的磁盘将不会用于备份或还原。

- done

  Used in the restore command. Takes no argument.在restore命令中使用。不需要争论。

- file

  Used in the restore command.在restore命令中使用。

- files

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- fileset

  Used in the run and restore command. Specifies the fileset.在运行和恢复命令中使用。指定文件集。

- filesets

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- help

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- hours

  Used on the **rerun** command to select all failed jobids in the last number of hours for rerunning.在UNIX命令中使用，选择最近几个小时内所有失败的作业ID以重新运行。

- jobs

  Used in the show, list and llist commands. Takes no arguments.用于show、list和llist命令。不需要争论。

- jobmedia

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- jobtotals

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- jobid

  The JobId is the numeric jobid that is printed in  the Job Report output. It is the index of the database record for the  given job. While it is unique for all the existing Job records in the  catalog database, the same JobId can be reused once a Job is removed  from the catalog. Probably you will refer specific Jobs that ran using  their numeric JobId. JobId can be used on the **rerun** command to select all jobs failed after and including the given jobid for rerunning.

  JobId是在作业报告输出中打印的数字作业ID。它是给定作业的数据库记录的索引。虽然它对于目录数据库中的所有现有作业记录都是唯一的，但从目录中删除作业后，可以重用相同的JobId。您可能会引用使用数字JobId运行的特定作业。

  JobId可用于restart命令，以选择所有失败的作业（包括给定的jobid），以便重新运行。

- job | jobname

  The Job or Jobname keyword refers to the name you specified in the  Job resource, and hence it refers to any number of Jobs that ran. It is  typically useful if you want to list all jobs of a particular name.

  Job或Jobname关键字指的是您在Job资源中指定的名称，因此它指的是运行的任意数量的Job。如果要列出具有特定名称的所有作业，此选项通常很有用。

- level

  Used in the run command. Specifies the backup level.用于run命令。指定备份级别。

- listing

  Permitted on the estimate command. Takes no argument.在估计命令上允许。不需要争论。

- limit

  Specifies the maximum number of items in the result.指定结果中的最大项数。

- messages

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- media

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- nextvolume | nextvol

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- on

  Takes no arguments.不需要争论。

- off

  Takes no arguments.不需要争论。

- pool

  Specify the pool to be used.指定要使用的池。

- pools

  Used in the show, list, and llist commands. Takes no arguments.在show、list和llist命令中使用。不需要争论。

- select

  Used in the restore command. Takes no argument.在restore命令中使用。不需要争论。

- limit

  Used in the setbandwidth command. Takes integer in KB/s unit.用于setbandwidth命令。以KB/s为单位的整数。

- schedules

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- storage | store | sd

  Used to specify the name of a storage daemon.用于指定存储守护程序的名称。

- storages

  Used in the show command. Takes no arguments.用于show命令。不需要争论。

- ujobid

  The ujobid is a unique job identification that is printed in the Job Report output. At the current time, it consists of the Job name (from  the Name directive for the job) appended with the date and time the job  was run. This keyword is useful if you want to completely identify the  Job instance run.

  ujobid是打印在作业报告输出中的唯一作业标识。当前，它由作业名称（来自作业的Name指令）和作业运行的日期和时间组成。如果要完全标识作业实例运行，此关键字非常有用。

- volume

  用于指定卷。

- volumes

  Used in the list and llist commands. Takes no arguments.在list和llist命令中使用。不需要争论。

- where

  在 restore 命令中使用。

- yes

  Used in the restore command. Takes no argument.在restore命令中使用。不需要争论。

## 控制台命令

当前实现了以下命令：

- add

  This  command is used to add Volumes to an existing Pool. That is, it creates  the Volume name in the catalog and inserts into the Pool in the catalog, but does not attempt to access the physical Volume. Once added, Bareos  expects that Volume to exist and to be labeled. This command is not  normally used since Bareos will automatically do the equivalent when  Volumes are labeled. However, there may be times when you have removed a Volume from the catalog and want to later add it back. The full form of this command is: add `add [pool=<pool-name>] [storage=<storage>] [jobid=<JobId>] `  Normally, the **label** command is used rather than this command because the **label** command labels the physical media (tape, disk,, …) and does the equivalent of the **add** command. The **add** command affects only the Catalog and not the physical media (data on  Volumes). The physical media must exist and be labeled before use  (usually with the **label** command). This command can, however, be useful if you wish to add a number of Volumes to the  Pool that will be physically labeled at a later time. It can also be  useful if you are importing a tape from another site. Please see the **label** command for the list of legal characters in a Volume name.

- autodisplay

  This  command accepts on or off as an argument, and turns auto-display of  messages on or off respectively. The default for the console program is  off, which means that you will be notified when there are console  messages pending, but they will not automatically be displayed. When autodisplay is turned off, you must explicitly  retrieve the messages with the messages command. When autodisplay is  turned on, the messages will be displayed on the console as they are  received.

- automount

  This command accepts on  or off as the argument, and turns auto-mounting of the Volume after a  label command on or off respectively. The default is on. If automount is turned off, you must explicitly mount tape Volumes after a label  command to use it.

- cancel

  This  command is used to cancel a job and accepts jobid=nnn or job=xxx as an  argument where nnn is replaced by the JobId and xxx is replaced by the  job name. If you do not specify a keyword, the Console program will  prompt you with the names of all the active jobs allowing you to choose  one. The full form of this command is: cancel `cancel [jobid=<number> job=<job-name> ujobid=<unique-jobid>] `  Once a Job is marked to be cancelled, it may take a bit of time  (generally within a minute but up to two hours) before the Job actually  terminates, depending on what operations it is doing. Don’t be surprised that you receive a Job not found message. That just means that one of  the three daemons had already canceled the job. Messages numbered in the 1000’s are from the Director, 2000’s are from the File daemon and  3000’s from the Storage daemon. It is possible to cancel multiple jobs at once. Therefore, the following extra options are available for the job-selection: all jobs all jobs with a created state all jobs with a blocked state all jobs with a waiting state all jobs with a running state Usage: cancel all `cancel all cancel all state=<created|blocked|waiting|running> `  Sometimes the Director already removed the job from its running  queue, but the storage daemon still thinks it is doing a backup (or  another job) - so you cannot cancel the job from within a console  anymore. Therefore it is possible to cancel a job by JobId on the  storage daemon. It might be helpful to execute a **status storage** on the Storage Daemon to make sure what job you want to cancel. Usage: cancel on Storage Daemon `cancel storage=<Storage Daemon> Jobid=<JobId> `  This way you can also remove a job that blocks any other jobs from running without the need to restart the whole storage daemon.

- create

  This  command is not normally used as the Pool records are automatically  created by the Director when it starts based on what it finds in the  configuration. If needed, this command can be used, to create a Pool  record in the database using the Pool resource record defined in the  Director’s configuration file. So in a sense, this command simply  transfers the information from the Pool resource in the configuration  file into the Catalog. Normally this command is done automatically for you when the Director  starts providing the Pool is referenced within a Job resource. If you  use this command on an existing Pool, it will automatically update the  Catalog to have the same information as the Pool resource. After  creating a Pool, you will most likely use the label command to label one or more volumes and add their names to the Media database. The full form of this command is: create `create [pool=<pool-name>] `  When starting a Job, if Bareos determines that there is  no Pool record in the database, but there is a Pool resource of the  appropriate name, it will create it for you. If you want the Pool record to appear in the database immediately, simply use this command to force it to be created.

- configure

  Configures director resources during runtime. The first configure subcommands are **configure add** and **configure export**. Other subcommands may follow in later releases. configure add This command allows to add resources during runtime. Usage: configure add usage `configure add <resourcetype> name=<resourcename> <directive1>=<value1> <directive2>=<value2> ... `  Values that must be quoted in the resulting configuration must be added as: configure add usage with values containing spaces `configure add <resourcetype> name=<resourcename> <directive1>="\"<value containing spaces>\"" ... `  The command generates and loads a new valid resource. As the new resource is also stored at `<CONFIGDIR>/bareos-dir.d/<resourcetype>/<resourcename>.conf` (see [Resource file conventions](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-configurationresourcefileconventions)) it is persistent upon reload and restart. This feature requires [Subdirectory Configuration Scheme](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-configurationsubdirectories). All kinds of resources can be added. When adding a client resource, the [Director Resource](https://docs.bareos.org/Configuration/FileDaemon.html#clientresourcedirector) for the Bareos File Daemon is also created and stored at: `<CONFIGDIR>/bareos-dir-export/client/<clientname>/bareos-fd.d/director/<clientname>.conf` Example: adding a client and a job resource during runtime `*configure add client name=client2-fd address=192.168.0.2 password=secret Created resource config file "/etc/bareos/bareos-dir.d/client/client2-fd.conf": Client {  Name = client2-fd  Address = 192.168.0.2  Password = secret } *configure add job name=client2-job client=client2-fd jobdefs=DefaultJob Created resource config file "/etc/bareos/bareos-dir.d/job/client2-job.conf": Job {  Name = client2-job  Client = client2-fd  JobDefs = DefaultJob } `  These two commands create three resource configuration files: `/etc/bareos/bareos-dir.d/client/client2-fd.conf` `/etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf` (assuming your director resource is named **bareos-dir**) `/etc/bareos/bareos-dir.d/job/client2-job.conf` The files in `bareos-dir-export/client/` directory are not used by the Bareos Director. However, they can be  copied to new clients to configure these clients for the Bareos  Director. Warning Don’t be confused by the extensive output of **help configure**. As **configure add** allows configuring arbitrary resources, the output of **help configure** lists all the resources, each with all valid directives. The same data is also used for **bconsole** command line completion. Available since Bareos *Version >= 16.2.4*.  configure export This command allows to export the `Director (Fd)` resource for clients already configured in the Bareos Director. Usage: Export the bareos-fd Director resource for the client bareos-fd `configure export client=bareos-fd Exported resource file "/etc/bareos/bareos-dir-export/client/bareos-fd/bareos-fd.d/director/bareos-dir.conf": Director {  Name = bareos-dir  Password = "[md5]932d1d3ef3c298047809119510f4bee6" } `  To use it, copy the `Director (Fd)` resource file to the client machine (on Linux: to `/etc/bareos/bareos-fd.d/director/`) and restart the Bareos File Daemon. Available since Bareos *Version >= 16.2.4*.

- delete

  The  delete command is used to delete a Volume, Pool or Job record from the  Catalog as well as all associated catalog Volume records that were  created. This command operates only on the Catalog database and has no  effect on the actual data written to a Volume. This command can be  dangerous and we strongly recommend that you do not use it unless you  know what you are doing. If the keyword Volume appears on the command line, the named Volume  will be deleted from the catalog, if the keyword Pool appears on the  command line, a Pool will be deleted, and if the keyword Job appears on  the command line, a Job and all its associated records (File and  JobMedia) will be deleted from the catalog. The full form of this command is: delete `delete pool=<pool-name> delete volume=<volume-name> pool=<pool-name> delete JobId=<job-id> JobId=<job-id2> ... delete Job JobId=n,m,o-r,t ... `  The first form deletes a Pool record from the catalog  database. The second form deletes a Volume record from the specified  pool in the catalog database. The third form deletes the specified Job  record from the catalog database. The last form deletes JobId records  for JobIds n, m, o, p, q, r, and t. Where each one of the n,m,… is, of  course, a number. That is a “delete jobid” accepts lists and ranges of  jobids.

- disable

  This  command permits you to disable a Job for automatic scheduling. The job  may have been previously enabled with the Job resource Enabled directive or using the console enable command. The next time the Director is  reloaded or restarted, the Enable/Disable state will be set to the value in the Job resource (default enabled) as defined in the Bareos Director configuration. The full form of this command is: disable `disable job=<job-name> `

- enable

  This  command permits you to enable a Job for automatic scheduling. The job  may have been previously disabled with the Job resource Enabled  directive or using the console disable command. The next time the  Director is reloaded or restarted, the Enable/Disable state will be set  to the value in the Job resource (default enabled) as defined in the  Bareos Director configuration. The full form of this command is: enable `enable job=<job-name> `

- estimate

  Using  this command, you can get an idea how many files will be backed up, or  if you are unsure about your Include statements in your FileSet, you can test them without doing an actual backup. The default is to assume a  Full backup. However, you can override this by specifying a  level=Incremental or level=Differential on the command line. A Job name  must be specified or you will be prompted for one, and optionally a  Client and FileSet may be specified on the command line. It then contacts the client which  computes the number of files and bytes that would be backed up. Please  note that this is an estimate calculated from the number of blocks in  the file rather than by reading the actual bytes. As such, the estimated backup size will generally be larger than an actual backup. The `estimate` command can use the accurate code to detect changes and give a better  estimation. You can set the accurate behavior on command line using `accurate=yes/no` or use the Job setting as default value. Optionally you may specify the keyword listing in which case, all the files to be backed up will be listed. Note, it could take quite some  time to display them if the backup is large. The full form is: The full form of this command is: estimate `estimate job=<job-name> listing client=<client-name> accurate=<yes|no> fileset=<fileset-name> level=<level-name> `  Specification of the job is sufficient, but you can also override the client, fileset, accurate and/or level by specifying them on the  estimate command line. As an example, you might do: estimate: redirected output `@output /tmp/listing estimate job=NightlySave listing level=Incremental @output `  which will do a full listing of all files to be backed  up for the Job NightlySave during an Incremental save and put it in the  file /tmp/listing. Note, the byte estimate provided by this command is  based on the file size contained in the directory item. This can give  wildly incorrect estimates of the actual storage used if there are  sparse files on your systems. Sparse files are often found on 64 bit  systems for certain system files. The size that is returned is the size  Bareos will backup if the sparse option is not specified in the FileSet. There is currently no way to get an estimate of the real file size that would be found should the sparse option be enabled.

- exit

  This command terminates the console program.

- export

  The  export command is used to export tapes from an autochanger. Most  Automatic Tapechangers offer special slots for importing new tape  cartridges or exporting written tape cartridges. This can happen without having to set the device offline. The full form of this command is: export `export storage=<storage-name> srcslots=<slot-selection> [dstslots=<slot-selection> volume=<volume-name> scan] `  The export command does exactly the opposite of the import command.  You can specify which slots should be transferred to import/export  slots. The most useful application of the export command is the  possibility to automatically transfer the volumes of a certain backup  into the import/export slots for external storage. To be able to to this, the export command also accepts a list of volume names to be exported. Example: export volume `export volume=A00020L4|A00007L4|A00005L4 `  Instead of exporting volumes by names you can also select a number of slots via the srcslots keyword and export those to the slots you  specify in dstslots. The export command will check if the slots have  content (e.g. otherwise there is not much to export) and if there are  enough export slots and if those are really import/export slots. Example: export slots `export srcslots=1-2 dstslots=37-38 `  To automatically export the Volumes used by a certain backup job, you can use the following RunScript in that job: automatic export `RunScript {    Console = "export storage=TandbergT40 volume=%V"    RunsWhen = After    RunsOnClient = no } `  To send an e-mail notification via the Messages resource regarding  export tapes you can use the Variable %V substitution in the Messages  resource, which is implemented in Bareos 13.2. However, it does also  work in earlier releases inside the job resources. So in versions prior  to Bareos 13.2 the following workaround can be used: e-mail notification via messages resource regarding export tapes `RunAfterJob = "/bin/bash -c \"/bin/echo Remove Tape %V | \ /usr/sbin/bsmtp -h localhost -f root@localhost -s 'Remove Tape %V' root@localhost \"" `

- gui

  Invoke the non-interactive gui mode. This command is only used when **bconsole** is commanded by an external program.

- help

  This command displays the list of commands available.

- import

  The  import command is used to import tapes into an autochanger. Most  Automatic Tapechangers offer special slots for importing new tape  cartridges or exporting written tape cartridges. This can happen without having to set the device offline. The full form of this command is: import `import storage=<storage-name> [srcslots=<slot-selection> dstslots=<slot-selection> volume=<volume-name> scan] `  To import new tapes into the autochanger, you only have to load the  new tapes into the import/export slots and call import from the cmdline. The import command will automatically transfer the new tapes into  free slots of the autochanger. The slots are filled in order of the slot numbers. To import all tapes, there have to be enough free slots to  load all tapes. Example with a Library with 36 Slots and 3 Import/Export Slots: import example `*import storage=TandbergT40 Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "slots" command. Device "Drive-1" has 39 slots. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "listall" command. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger transfer command. 3308 Successfully transfered volume from slot 37 to 20. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger transfer command. 3308 Successfully transfered volume from slot 38 to 21. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger transfer command. 3308 Successfully transfered volume from slot 39 to 25. `  You can also import certain slots when you don’t have enough free  slots in your autochanger to put all the import/export slots in. Example with a Library with 36 Slots and 3 Import/Export Slots importing one slot: import example `*import storage=TandbergT40 srcslots=37 dstslots=20 Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "slots" command. Device "Drive-1" has 39 slots. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "listall" command. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger transfer command. 3308 Successfully transfered volume from slot 37 to 20. `

- label

  This command is used to label physical volumes. The full form of this command is: label `label storage=<storage-name> volume=<volume-name> slot=<slot> `  If you leave out any part, you will be prompted for it. The media  type is automatically taken from the Storage resource definition that  you supply. Once the necessary information is obtained, the Console  program contacts the specified Storage daemon and requests that the  Volume be labeled. If the Volume labeling is successful, the Console  program will create a Volume record in the appropriate Pool. The Volume name is restricted to letters, numbers, and the special  characters hyphen (-), underscore (_), colon (:), and period (.). All  other characters including a space are invalid. This restriction is to  ensure good readability of Volume names to reduce operator errors. Please note, when labeling a blank tape, Bareos will get read I/O  error when it attempts to ensure that the tape is not already labeled.  If you wish to avoid getting these messages, please write an EOF mark on your tape before attempting to label it: `mt rewind mt weof ` The label command can fail for a number of reasons: The Volume name you specify is already in the Volume database. The Storage daemon has a tape or other Volume already mounted on the device, in which case you must unmount the device, insert a blank tape, then do the label command. The Volume in the device is already a Bareos labeled Volume. (Bareos will never relabel a Bareos labeled Volume unless it is recycled and  you use the relabel command). There is no Volume in the drive. There are two ways to relabel a volume that already has a Bareos  label. The brute force method is to write an end of file mark on the  tape using the system mt program, something like the following: `mt -f /dev/st0 rewind mt -f /dev/st0 weof ` For a disk volume, you would manually delete the Volume. Then you use the label command to add a new label. However, this could leave traces of the old volume in the catalog. The preferable method to relabel a Volume is to first purge the volume, either automatically, or explicitly with the **purge** command, then use the **relabel** command described below. If your autochanger has barcode labels, you can label all the Volumes in your autochanger one after another by using the **label barcodes** command. For each tape in the changer containing a barcode, Bareos will mount the tape and then label it with the same name as the barcode. An  appropriate Media record will also be created in the catalog. Any  barcode that begins with the same characters as specified on the  “CleaningPrefix=xxx” (default is “CLN”) directive in the Director’s Pool resource, will be treated as a cleaning tape, and will  not be labeled. However, an entry for the cleaning tape will be created  in the catalog. For example with: Cleaning Tape `Pool {    Name ...    Cleaning Prefix = "CLN" } `  Any slot containing a barcode of CLNxxxx will be treated as a  cleaning tape and will not be mounted. Note, the full form of the  command is: label `label storage=xxx pool=yyy slots=1-5,10 barcodes `

- list

  The list command lists the requested contents of the Catalog. The various fields of each record are listed on a single line. The various forms of the  list command are: list `list jobs list jobid=<id>           (list jobid id) list ujobid=<unique job name> (list job with unique name) list job=<job-name>   (list all jobs with "job-name") list jobname=<job-name>  (same as above)    In the above, you can add "limit=nn" to limit the output to nn jobs. list joblog jobid=<id> (list job output if recorded in the catalog) list jobmedia list jobmedia jobid=<id> list jobmedia job=<job-name> list files jobid=<id> list files job=<job-name> list pools list clients list jobtotals list volumes list volumes jobid=<id> list volumes pool=<pool-name> list volumes job=<job-name> list volume=<volume-name> list nextvolume job=<job-name> list nextvol job=<job-name> list nextvol job=<job-name> days=nnn `  What most of the above commands do should be more or less obvious. In general if you do not specify all the command line arguments, the  command will prompt you for what is needed. The **list nextvol** command will print the Volume name to be used by the specified job. You should be aware that exactly what Volume will be used depends on a lot  of factors including the time and what a prior job will do. It may fill a tape that is not full when you issue this command. As a consequence,  this command will give you a good estimate of what Volume will be used  but not a definitive answer. In addition, this command may have certain  side effect because it runs through the same algorithm as a job, which means it may  automatically purge or recycle a Volume. By default, the job specified  must run within the next two days or no volume will be found. You can,  however, use the days=nnn specification to specify up to 50 days. For  example, if on Friday, you want to see what Volume will be needed on  Monday, for job MyJob, you would use **list nextvol job=MyJob days=3**. If you wish to add specialized commands that list the contents of the catalog, you can do so by adding them to the `query.sql` file. However, this takes some knowledge of programming SQL. Please see the **query** command below for additional information. See below for listing the full contents of a catalog record with the **llist** command. As an example, the command list pools might produce the following output: list pools `*list pools +------+---------+---------+---------+----------+-------------+ | PoId | Name    | NumVols | MaxVols | PoolType | LabelFormat | +------+---------+---------+---------+----------+-------------+ |    1 | Default |       0 |       0 | Backup   | *           | |    2 | Recycle |       0 |       8 | Backup   | File        | +------+---------+---------+---------+----------+-------------+ `  As mentioned above, the list command lists what is in the database.  Some things are put into the database immediately when Bareos starts up, but in general, most things are put in only when they are first used,  which is the case for a Client as with Job records, etc. Bareos should create a client record in the database the first time  you run a job for that client. Doing a status will not cause a database  record to be created. The client database record will be created whether or not the job fails, but it must at least start. When the Client is  actually contacted, additional info from the client will be added to the client record (a “uname -a” output). If you want to see what Client resources you have available in your conf file, you use the Console command show clients.

- llist

  The  llist or “long list” command takes all the same arguments that the list  command described above does. The difference is that the llist command  list the full contents of each database record selected. It does so by  listing the various fields of the record vertically, with one field per  line. It is possible to produce a very large number of output lines with this command. If instead of the list pools as in the example above, you enter llist pools you might get the following output: llist pools `*llist pools          PoolId: 1            Name: Default         NumVols: 0         MaxVols: 0         UseOnce: 0      UseCatalog: 1 AcceptAnyVolume: 1    VolRetention: 1,296,000  VolUseDuration: 86,400      MaxVolJobs: 0     MaxVolBytes: 0       AutoPrune: 0         Recycle: 1        PoolType: Backup     LabelFormat: *           PoolId: 2            Name: Recycle         NumVols: 0         MaxVols: 8         UseOnce: 0      UseCatalog: 1 AcceptAnyVolume: 1    VolRetention: 3,600  VolUseDuration: 3,600      MaxVolJobs: 1     MaxVolBytes: 0       AutoPrune: 0         Recycle: 1        PoolType: Backup     LabelFormat: File `

- messages

  This command causes any pending console messages to be immediately displayed.

- memory

  Print current memory usage.

- mount

  The  mount command is used to get Bareos to read a volume on a physical  device. It is a way to tell Bareos that you have mounted a tape and that Bareos should examine the tape. This command is normally used only  after there was no Volume in a drive and Bareos requests you to mount a  new Volume or when you have specifically unmounted a Volume with the **unmount** console command, which causes Bareos to close the drive. If you have an autoloader, the mount command will not cause Bareos to  operate the autoloader unless you specify a slot and possibly a drive.  The various forms of the mount command are: mount `mount storage=<storage-name> [slot=<num>] [drive=<num>] mount [jobid=<id> | job=<job-name>] `  If you have specified [`Automatic Mount (Sd->Device) = yes`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutomaticMount), under most circumstances, Bareos will automatically access the Volume  unless you have explicitly unmounted it (in the Console program).

- move

  The move command allows to move volumes between slots in an autochanger without having to leave the bconsole. To move a volume from slot 32 to slots 33, use: move `*move storage=TandbergT40 srcslots=32 dstslots=33 Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "slots" command. Device "Drive-1" has 39 slots. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger "listall" command. Connecting to Storage daemon TandbergT40 at bareos:9103 ... 3306 Issuing autochanger transfer command. 3308 Successfully transfered volume from slot 32 to 33. `

- prune

  The Prune command allows you to safely remove expired database  records from Jobs, Volumes and Statistics. This command works only on  the Catalog database and does not affect data written to Volumes. In all cases, the Prune command applies a retention period to the specified  records. You can Prune expired File entries from Job records; you can  Prune expired Job records from the database, and you can Prune both expired Job and File records from specified Volumes. prune `prune files [client=<client>] [pool=<pool>] [yes] |      jobs [client=<client>] [pool=<pool>] [jobtype=<jobtype>] [yes] |      volume [=volume] [pool=<pool>] [yes] |      stats [yes] `  For a Volume to be pruned, the volume status must be **Full**, **Used** or **Append** otherwise the pruning will not take place.

- purge

  The Purge command will delete associated catalog database records  from Jobs and Volumes without considering the retention period. This  command can be dangerous because you can delete catalog records  associated with current backups of files, and we recommend that you do  not use it unless you know what you are doing. The permitted forms of **purge** are: purge `purge [files [job=<job> | jobid=<jobid> | client=<client> | volume=<volume>]] |      [jobs [client=<client> | volume=<volume>]] |      [volume [=<volume>] [storage=<storage>] [pool=<pool>] [devicetype=<type>] [drive=<drivenum>] [action=<action>]] |      [quota [client=<client>]] `  For the **purge** command to work on volume catalog database records the volume status must be **Append**, **Full**, **Used** or **Error**. The actual data written to the Volume will be unaffected by this command unless you are using the [`Action On Purge (Dir->Pool) = Truncate`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_ActionOnPurge) option. To ask Bareos to truncate your **Purged** volumes, you need to use the following command in interactive mode: purge example `*purge volume action=truncate storage=File pool=Full `  However, normally you should use the **purge** command only to purge a volume from the catalog and use the **truncate** command to truncate the volume on the Bareos Storage Daemon.

- resolve

  In the  configuration files, Addresses can (and normally should) be specified as DNS names. As the different components of Bareos will establish network connections to other Bareos components, it is important that DNS name  resolution works on involved components and delivers the same results.  The **resolve** command can be used to test DNS resolution of a given hostname on director, storage daemon or client. resolve example `*resolve www.bareos.com bareos-dir resolves www.bareos.com to host[ipv4:84.44.166.242] *resolve client=client1-fd www.bareos.com client1-fd resolves www.bareos.com to host[ipv4:84.44.166.242] *resolve storage=File www.bareos.com bareos-sd resolves www.bareos.com to host[ipv4:84.44.166.242] `

- query

  This command reads a predefined SQL query from the query file (the name  and location of the query file is defined with the QueryFile resource  record in the Director’s configuration file). You are prompted to select a query from the file, and possibly enter one or more parameters, then  the command is submitted to the Catalog database SQL engine.

- quit

  This command terminates  the console program. The console program sends the quit request to the  Director and waits for acknowledgment. If the Director is busy doing a  previous command for you that has not terminated, it may take some time. You may quit immediately by issuing the .quit command (i.e. quit  preceded by a period).

- relabel

  This command is used to label physical volumes. The full form of this command is: relabel `relabel storage=<storage-name> oldvolume=<old-volume-name> volume=<new-volume-name> pool=<pool-name> [encrypt] `  If you leave out any part, you will be prompted for it. In order for  the Volume (old-volume-name) to be relabeled, it must be in the catalog, and the volume status must be marked **Purged** or **Recycle**. This happens automatically as a result of applying retention periods or you may explicitly purge the volume using the **purge** command. Once the volume is physically relabeled, the old data previously written on the Volume is lost and cannot be recovered.

- release

  This  command is used to cause the Storage daemon to release (and rewind) the  current tape in the drive, and to re-read the Volume label the next time the tape is used. release `release storage=<storage-name> `  After a release command, the device is still kept open by Bareos (unless [`Always Open (Sd->Device) = no`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlwaysOpen)) so it cannot be used by another program. However, with some tape  drives, the operator can remove the current tape and to insert a  different one, and when the next Job starts, Bareos will know to re-read the tape label to find out what tape is mounted. If you want to be able to use the drive with another program (e.g. **mt**), you must use the **unmount** command to cause Bareos to completely release (close) the device.

- reload

  The  reload command causes the Director to re-read its configuration file and apply the new values. The new values will take effect immediately for  all new jobs. However, if you change schedules, be aware that the  scheduler pre-schedules jobs up to two hours in advance, so any changes  that are to take place during the next two hours may be delayed. Jobs  that have already been scheduled to run (i.e. surpassed their requested  start time) will continue with the old values. New jobs will use the new values. Each  time you issue a reload command while jobs are running, the prior config values will queued until all jobs that were running before issuing the  reload terminate, at which time the old config values will be released  from memory. The Directory permits keeping up to ten prior set of  configurations before it will refuse a reload command. Once at least one old set of config values has been released it will again accept new  reload commands. While it is possible to reload the Director’s  configuration on the fly, even while jobs are executing, this is a  complex operation and not without side effects. Accordingly, if you have to reload the Director’s configuration while Bareos is running, it is  advisable to restart the Director at the next convenient opportunity.

- rerun

  The  rerun command allows you to re-run a Job with exactly the same setting  as the original Job. In Bareos, the job configuration is often altered  by job overrides. These overrides alter the configuration of the job  just for one job run. If because of any reason, a job with overrides  fails, it is not easy to restart a new job that is exactly configured as the job that failed. The whole job configuration is automatically set  to the defaults and it is hard to configure everything like it was. By using the rerun command, it is much easier to rerun a job exactly  as it was configured. You only have to specify the JobId of the failed  job. rerun `rerun jobid=<jobid> since_jobid=<jobid> days=<nr_days> hours=<nr_hours> yes `  You can select the jobid(s) to rerun by using one of the selection criteria. Using jobid= will automatically select all jobs  failed after and including the given jobid for rerunning. By using days= or hours=, you can select all failed jobids in the last number of days  or number of hours respectively for rerunning.

- restore

  The restore command allows you to select one or more Jobs (JobIds) to be restored using various methods. Once the JobIds are selected, the  File records for those Jobs are placed in an internal Bareos directory  tree, and the restore enters a file selection mode that allows you to  interactively walk up and down the file tree selecting individual files to be restored. This mode is  somewhat similar to the standard Unix restore program’s interactive file selection mode. restore `restore storage=<storage-name> client=<backup-client-name>  where=<path> pool=<pool-name> fileset=<fileset-name>  restoreclient=<restore-client-name>  restorejob=<job-name>  select current all done `  Where current, if specified, tells the restore command to  automatically select a restore to the most current backup. If not  specified, you will be prompted. The all specification tells the restore command to restore all files. If it is not specified, you will be  prompted for the files to restore. For details of the restore command,  please see the [Restore Chapter](https://docs.bareos.org/TasksAndConcepts/TheRestoreCommand.html#restorechapter) of this manual. The client keyword initially specifies the client from which the  backup was made and the client to which the restore will be make.  However, if the restoreclient keyword is specified, then the restore is  written to that client. The restore job rarely needs to be specified, as bareos installations commonly only have a single restore job configured. However, for  certain cases, such as a varying list of RunScript specifications,  multiple restore jobs may be configured. The restorejob argument allows  the selection of one of these jobs. For more details, see the [Restore chapter](https://docs.bareos.org/TasksAndConcepts/TheRestoreCommand.html#restorechapter).

- run

  This command allows you to schedule jobs to be run immediately. The full form of the command is: run `run job=<job-name> client=<client-name> fileset=<fileset-name>   level=<level> storage=<storage-name> where=<directory-prefix>   when=<universal-time-specification> pool=<pool-name>   pluginoptions=<plugin-options-string> accurate=<yes|no>   comment=<text> spooldata=<yes|no> priority=<number>   jobid=<jobid> catalog=<catalog> migrationjob=<job-name> backupclient=<client-name>   backupformat=<format> nextpool=<pool-name> since=<universal-time-specification>   verifyjob=<job-name> verifylist=<verify-list> migrationjob=<complete_name>   yes `  Any information that is needed but not specified will be listed for  selection, and before starting the job, you will be prompted to accept,  reject, or modify the parameters of the job to be run, unless you have  specified yes, in which case the job will be immediately sent to the  scheduler. If you wish to start a job at a later time, you can do so by setting  the When time. Use the mod option and select When (no. 6). Then enter  the desired start time in YYYY-MM-DD HH:MM:SS format. The spooldata argument of the run command cannot be  modified through the menu and is only accessible by setting its value on the intial command line. If no spooldata flag is set, the job, storage  or schedule flag is used.

- setbandwidth

  This command (*Version >= 12.4.1*) is used to limit the bandwidth of a running job or a client. setbandwidth `setbandwidth limit=<nb> [jobid=<id> | client=<cli>] `

- setdebug

  This command is used to set the debug level in each daemon. The form of this command is: setdebug `setdebug level=nnn [trace=0/1 client=<client-name> | dir | director | storage=<storage-name> | all] `  Each of the daemons normally has debug compiled into the program, but disabled. There are two ways to enable the debug output. One is to add the -d nnn option on the command line when starting the daemon. The nnn is the debug level, and generally anything between 50  and 200 is reasonable. The higher the number, the more output is  produced. The output is written to standard output. The second way of getting debug output is to dynamically turn it on using the Console using the **setdebug level=nnn** command. If none of the options are given, the command will prompt you. You can selectively turn on/off debugging in any or all the daemons  (i.e. it is not necessary to specify all the components of the above  command). If trace=1 is set, then tracing will be enabled, and the daemon will  be placed in trace mode, which means that all debug output as set by the debug level will be directed to his trace file in the current directory of the daemon. When tracing, each debug output message is appended to  the trace file. You must explicitly delete the file when you are done. set Director debug level to 100 and get messages written to his trace file `*setdebug level=100 trace=1 dir level=100 trace=1 hangup=0 timestamp=0 tracefilename=/var/lib/bareos/bareos-dir.example.com.trace `

- setdevice

  This command is used to set [`Auto Select (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoSelect) of a device resource in the Bareos Storage Daemon. This command can be  used to temporarily disable that a device is automatically selected in  an autochanger. The setting is only valid until the next restart of the Bareos Storage Daemon. The form of this command is: setdevice `setdevice storage=<storage-name> device=<device-name> autoselect=<bool> `  Note: Consider the settings of [`Command ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CommandACL) and [`Storage ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_StorageACL).

- setip

  Sets new client address – if authorized. A console is authorized to use the SetIP command only if it has a Console resource definition in both the Director and the  Console. In addition, if the console name, provided on the Name =  directive, must be the same as a Client name, the user of that console  is permitted to use the SetIP command to change the Address directive in the Director’s client resource to the IP address of the Console. This  permits portables or other machines using DHCP (non-fixed IP addresses)  to “notify” the Director of their current IP address.

- show

  The show command will list the Director’s resource records as defined in the Director’s configuration. **help show** will show you all available options.The following keywords are accepted on the show command line: `*help show  Command            Description  =======            ===========  show               Show resource records Arguments:        catalog=<catalog-name> |        client=<client-name> |        ...        storages |        disabled [ clients | jobs | schedules ] |        all [verbose] ` **show all** will show you all available resources. The **verbose** argument will show you also all configuration directives with there default value: `*show client=bareos-fd verbose Client {  Name = "bareos-fd"  Description = "Client resource of the Director itself."  Address = "localhost"  #  Port = 9102  Password = "*************************************"  #  Catalog = "MyCatalog"  #  Passive = no  #  ConnectionFromDirectorToClient = yes  #  ConnectionFromClientToDirector = no  #  Enabled = yes  ... } ` If you are not using the default console, but a named console, ACLs are applied. Additionally, if the named console don’t have the permission to run the **configure** command, some resources (like consoles and profiles) are not shown at all. Please don’t confuse this command with the **list** command, which displays the contents of the catalog.

- sqlquery

  The  sqlquery command puts the Console program into SQL query mode where each line you enter is concatenated to the previous line until a semicolon  (;) is seen. The semicolon terminates the command, which is then passed  directly to the SQL database engine. When the output from the SQL engine is displayed, the formation of a new SQL command begins. To terminate  SQL query mode and return to the Console command prompt, you enter a  period (.) in column 1. Using this command, you can query the SQL catalog database directly.  Note you should really know what you are doing otherwise you could  damage the catalog database. See the query command below for simpler and safer way of entering SQL queries. Depending on what database engine you are using (MySQL,  PostgreSQL or SQLite), you will have somewhat different SQL commands  available. For more detailed information, please refer to the MySQL,  PostgreSQL or SQLite documentation.

- status

  This command will display the status of all components. For the  director, it will display the next jobs that are scheduled during the  next 24 hours as well as the status of currently running jobs. For the  Storage Daemon, you will have drive status or autochanger content. The  File Daemon will give you information about current jobs like average  speed or file accounting. The full form of this command is: status `status [all | dir=<dir-name> | director | scheduler | schedule=<schedule-name> |        client=<client-name> | storage=<storage-name> slots | subscriptions | configuration] `  If you do a status dir, the console will list any currently running  jobs, a summary of all jobs scheduled to be run in the next 24 hours,  and a listing of the last ten terminated jobs with their statuses. The  scheduled jobs summary will include the Volume name to be used. You  should be aware of two things: 1. to obtain the volume name, the code  goes through the same code that will be used when the job runs, but it  does not do pruning nor recycling of Volumes; 2. The Volume listed is at best a guess. The Volume actually used may be different because of the time  difference (more durations may expire when the job runs) and another job could completely fill the Volume requiring a new one. In the Running Jobs listing, you may find the following types of information: `2507 Catalog MatouVerify.2004-03-13_05.05.02 is waiting execution 5349 Full    CatalogBackup.2004-03-13_01.10.00 is waiting for higher             priority jobs to finish 5348 Differe Minou.2004-03-13_01.05.09 is waiting on max Storage jobs 5343 Full    Rufus.2004-03-13_01.05.04 is running ` Looking at the above listing from bottom to top, obviously JobId 5343 (Rufus) is running. JobId 5348 (Minou) is waiting for JobId 5343 to  finish because it is using the Storage resource, hence the “waiting on  max Storage jobs”. JobId 5349 has a lower priority than all the other  jobs so it is waiting for higher priority jobs to finish, and finally,  JobId 2507 (MatouVerify) is waiting because only one job can run at a  time, hence it is simply “waiting execution” If you do a status dir, it will by default list the first occurrence  of all jobs that are scheduled today and tomorrow. If you wish to see  the jobs that are scheduled in the next three days (e.g. on Friday you  want to see the first occurrence of what tapes are scheduled to be used  on Friday, the weekend, and Monday), you can add the days=3 option.  Note, a days=0 shows the first occurrence of jobs scheduled today only.  If you have multiple run statements, the first occurrence of each run statement for the job will be displayed for the period specified. If your job seems to be blocked, you can get a general idea of the  problem by doing a status dir, but you can most often get a much more  specific indication of the problem by doing a status storage=xxx. For  example, on an idle test system, when I do status storage=File, I get: status storage `*status storage=File Connecting to Storage daemon File at 192.168.68.112:8103 rufus-sd Version: 1.39.6 (24 March 2006) i686-pc-linux-gnu redhat (Stentz) Daemon started 26-Mar-06 11:06, 0 Jobs run since started. Running Jobs: No Jobs running. ==== Jobs waiting to reserve a drive: ==== Terminated Jobs: JobId  Level   Files          Bytes Status   Finished        Name ======================================================================    59  Full        234      4,417,599 OK       15-Jan-06 11:54 usersave ==== Device status: Autochanger "DDS-4-changer" with devices:   "DDS-4" (/dev/nst0) Device "DDS-4" (/dev/nst0) is mounted with Volume="TestVolume002" Pool="*unknown*"    Slot 2 is loaded in drive 0.    Total Bytes Read=0 Blocks Read=0 Bytes/block=0    Positioned at File=0 Block=0 Device "File" (/tmp) is not open. ==== In Use Volume status: ==== `  Now, what this tells me is that no jobs are running and that none of  the devices are in use. Now, if I unmount the autochanger, which will  not be used in this example, and then start a Job that uses the File  device, the job will block. When I re-issue the status storage command, I get for the Device status: status storage `*status storage=File ... Device status: Autochanger "DDS-4-changer" with devices:   "DDS-4" (/dev/nst0) Device "DDS-4" (/dev/nst0) is not open.    Device is BLOCKED. User unmounted.    Drive 0 is not loaded. Device "File" (/tmp) is not open.    Device is BLOCKED waiting for media. ==== ... `  Now, here it should be clear that if a job were running that wanted  to use the Autochanger (with two devices), it would block because the  user unmounted the device. The real problem for the Job I started using  the “File” device is that the device is blocked waiting for media – that is Bareos needs you to label a Volume. The command **status scheduler** (*Version >= 12.4.4*) can be used to check when a certain schedule will trigger. This gives more information than **status director**. Called without parameters, **status scheduler** shows a preview for all schedules for the next 14 days. It first shows a list of the known schedules and the jobs that will be triggered by  these jobs, and next, a table with date (including weekday), schedule  name and applied overrides is displayed: status scheduler `*status scheduler Scheduler Jobs: Schedule               Jobs Triggered =========================================================== WeeklyCycle                       BackupClient1 WeeklyCycleAfterBackup                       BackupCatalog ==== Scheduler Preview for 14 days: Date                  Schedule                Overrides ============================================================== Di 04-Jun-2013 21:00  WeeklyCycle             Level=Incremental Di 04-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Mi 05-Jun-2013 21:00  WeeklyCycle             Level=Incremental Mi 05-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Do 06-Jun-2013 21:00  WeeklyCycle             Level=Incremental Do 06-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Fr 07-Jun-2013 21:00  WeeklyCycle             Level=Incremental Fr 07-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Sa 08-Jun-2013 21:00  WeeklyCycle             Level=Differential Mo 10-Jun-2013 21:00  WeeklyCycle             Level=Incremental Mo 10-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Di 11-Jun-2013 21:00  WeeklyCycle             Level=Incremental Di 11-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Mi 12-Jun-2013 21:00  WeeklyCycle             Level=Incremental Mi 12-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Do 13-Jun-2013 21:00  WeeklyCycle             Level=Incremental Do 13-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Fr 14-Jun-2013 21:00  WeeklyCycle             Level=Incremental Fr 14-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full Sa 15-Jun-2013 21:00  WeeklyCycle             Level=Differential Mo 17-Jun-2013 21:00  WeeklyCycle             Level=Incremental Mo 17-Jun-2013 21:10  WeeklyCycleAfterBackup  Level=Full ==== `  **status scheduler** accepts the following parameters: client=clientname shows only the schedules that affect the given client. job=jobname shows only the schedules that affect the given job. schedule=schedulename shows only the given schedule. days=number of days shows only the number of days in the scheduler preview.  Positive numbers show the future, negative numbers show the past. days  can be combined with the other selection criteria. days= can be combined with the other selection criteria. In case you are running a maintained version of Bareos, the command **status subscriptions** (*Version >= 12.4.4*) can help you to keep the overview over the subscriptions that are used. To enable this functionality, just add the configuration [`Subscriptions (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Subscriptions) directive and specify the number of subscribed clients, for example: enable subscription check `Director {   ...   Subscriptions = 50 } `  Using the console command **status subscriptions**, the status of the subscriptions can be checked any time interactively: status subscriptions `*status subscriptions Ok: available subscriptions: 8 (42/50) (used/total) `  Also, the number of subscriptions is checked after every job. If the  number of clients is bigger than the configured limit, a Job warning is  created a message like this: subscriptions warning `JobId 7: Warning: Subscriptions exceeded: (used/total) (51/50) `  Please note: Nothing else than the warning is issued, no enforcement on backup, restore or any other operation will happen. Setting the value for [`Subscriptions (Dir->Director) = 0`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Subscriptions) disables this functionality: disable subscription check `Director {   ...   Subscriptions = 0 } `  Not configuring the directive at all also disables it, as the default value for the Subscriptions directive is zero. Using the console command **status configuration** will show a list of deprecated configuration settings that were  detected when loading the director’s configuration. Be sure to enable  access to the “configuration” command by using the according command  ACL.

- time

  The time command shows the current date, time and weekday.

- trace

  Turn on/off trace to file.

- truncate



> If the status of a volume is **Purged**, it normally still contains data, even so it can not easily be accessed.
>
> truncate
>
> ```
> truncate volstatus=Purged [storage=<storage>] [pool=<pool>] [volume=<volume>] [yes]
> ```
>
> When using a disk volume (and other volume types also) the volume  file still resides on the Bareos Storage Daemon. If you want to reclaim  disk space, you can use the **truncate volstatus=Purged** command. When used on a volume, it rewrites the header and by this frees the rest of the disk space.
>
> If the volume you want to get rid of has not the **Purged** status, you first have to use the **prune volume** or even the **purge volume** command to free the volume from all remaining jobs.
>
> This command is available since Bareos *Version >= 16.2.5*.

- umount

  Alias for **unmount**.

- unmount

  This  command causes the indicated Bareos Storage daemon to unmount the  specified device. The forms of the command are the same as the mount  command: unmount `unmount storage=<storage-name> [drive=<num>] unmount [jobid=<id> | job=<job-name>] `  Once you unmount a storage device, Bareos will no longer be able to  use it until you issue a mount command for that device. If Bareos needs  to access that device, it will block and issue mount requests  periodically to the operator. If the device you are unmounting is an autochanger, it will unload  the drive you have specified on the command line. If no drive is  specified, it will assume drive 1. In most cases, it is preferable to use the **release** instead.

- update

  This command will update the catalog for either a specific Pool  record, a Volume record, or the Slots in an autochanger with barcode  capability. In the case of updating a Pool record, the new information  will be automatically taken from the corresponding Director’s  configuration resource record. It can be used to increase the maximum  number of volumes permitted or to set a maximum number of volumes. The following main keywords may be specified: volume pool slots iobid stats In the case of updating a Volume (**update volume**), you will be prompted for which value you wish to change. The following Volume parameters may be changed: `Volume Status Volume Retention Period Volume Use Duration Maximum Volume Jobs Maximum Volume Files Maximum Volume Bytes Recycle Flag Recycle Pool Slot InChanger Flag Pool Volume Files Volume from Pool All Volumes from Pool All Volumes from all Pools ` For slots **update slots**, Bareos will obtain a list of slots and their barcodes from the Storage  daemon, and for each barcode found, it will automatically update the  slot in the catalog Media record to correspond to the new value. This is very useful if you have moved cassettes in the magazine, or if you have removed the magazine and inserted a different one. As the slot of each  Volume is updated, the InChanger flag for that Volume will also be set,  and any other Volumes in the Pool that were last mounted on the same Storage device  will have their InChanger flag turned off. This permits Bareos to know  what magazine (tape holder) is currently in the autochanger. If you do not have barcodes, you can accomplish the same thing by using the **update slots scan** command. The **scan** keyword tells Bareos to physically mount each tape and to read its VolumeName. For Pool **update pool**, Bareos will move the Volume record from its existing pool to the pool specified. For Volume from Pool, All Volumes from Pool and All Volumes from all  Pools, the following values are updated from the Pool record: Recycle,  RecyclePool, VolRetention, VolUseDuration, MaxVolJobs, MaxVolFiles, and  MaxVolBytes. For updating the statistics, use **updates stats**, see [Job Statistics](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-jobstatistics). The full form of the update command with all command line arguments is: update `update  volume=<volume-name> [volstatus=<status>]        [volretention=<time-def>] [pool=<pool-name>]        [recycle=<yes/no>] [slot=<number>] [inchanger=<yes/no>] |        pool=<pool-name> [maxvolbytes=<size>] [maxvolfiles=<nb>]        [maxvoljobs=<nb>][enabled=<yes/no>] [recyclepool=<pool-name>]        [actiononpurge=<action>] |        slots [storage=<storage-name>] [scan] |        jobid=<jobid> [jobname=<name>] [starttime=<time-def>]        [client=<client-name>] [filesetid=<fileset-id>]        [jobtype=<job-type>] |        stats [days=<number>] `

- use

  This command allows you to specify which Catalog database to use.  Normally, you will be using only one database so this will be done  automatically. In the case that you are using more than one database,  you can use this command to switch from one to another. use `use [catalog=<catalog>] `

- var

  This command takes a string or quoted string and does variable expansion on it mostly the same way variable expansion is done on the [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) string. The difference between the **var** command and the actual [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) process is that during the var command, no job is running so dummy values are used in place of Job specific variables.

- version

  The command prints the Director’s version.

- wait

  The wait command causes the Director to pause until there are no jobs running.  This command is useful in a batch situation such as regression testing  where you wish to start a job and wait until that job completes before  continuing. This command now has the following options: wait `wait [jobid=<jobid>] [jobuid=<unique id>] [job=<job name>] `  If specified with a specific JobId, … the wait command will wait for that particular job to terminate before continuing.

- whoami

  Print the name of the user associated with this console.



### Special dot (.) Commands



There is a list of commands that are prefixed with a period (.).  These commands are intended to be used either by batch programs or  graphical user interface front-ends. They are not normally used by  interactive users. For details, see [Bareos Developer Guide (dot-commands)](https://docs.bareos.org/DeveloperGuide/api.html#dot-commands).



### Special At (@) Commands

Normally, all commands entered to the Console program are immediately forwarded to the Director, which may be on another machine, to be  executed. However, there is a small list of at commands, all beginning  with an at character (@), that will not be sent to the Director, but  rather interpreted by the Console program directly. Note, these commands are implemented only in the TTY console program and not in the Bat  Console. These commands are:

- @input <filename>

  Read and execute the commands contained in the file specified.

- @output <filename> <w|a>

  Send all following output to the filename specified either overwriting the file  (w) or appending to the file (a). To redirect the output to the  terminal, simply enter @output without a filename specification.  WARNING: be careful not to overwrite a valid file. A typical example  during a regression test might be: `@output /dev/null commands ... @output `

- @tee <filename> <w|a>

  Send all subsequent  output to both the specified file and the terminal. It is turned off by  specifying @tee or @output without a filename.

- @sleep <seconds>

  Sleep the specified number of seconds.

- @time

  Print the current time and date.

- @version

  Print the console’s version.

- @quit

  quit

- @exit

  quit

- @# anything

  Comment

- @help

  Get the list of every special @ commands.

- @separator <char>

  When  using bconsole with readline, you can set the command separator to one  of those characters to write commands who require multiple input on one  line, or to put multiple commands on a single line. `!$%&'()*+,-/:;<>?[]^`{|}~ ` Note, if you use a semicolon (;) as a separator  character, which is common, you will not be able to use the sql command, which requires each command to be terminated by a semicolon.

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

现在是运行第一个备份作业的时候了。我们将把你的 Bareos 源目录备份到你的 /var/lib/bareos/storage/ 目录中的一个文件卷，只是为了向你展示它是多么容易。现在输入：

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

您将注意到，默认的 Bareos 存储守护程序设备名为 `File (Dir->Storage)` ，它将使用设备 `/var/lib/bareos/storage` ，该设备当前未打开。

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
28-Apr-2003 14:30 bareos-sd: Wrote label to prelabeled Volume
   "TestVolume001" on device /var/lib/bareos/storage
28-Apr-2003 14:30 rufus-dir: Bareos 1.30 (28Apr03): 28-Apr-2003 14:30
JobId:                  1
Job:                    BackupClient1.2003-04-28_14.22.33
FileSet:                Full Set
Backup Level:           Full
Client:                 bareos-fd
Start time:             28-Apr-2003 14:22
End time:               28-Apr-2003 14:30
Files Written:          1,444
Bytes Written:          38,988,877
Rate:                   81.2 KB/s
Software Compression:   None
Volume names(s):        TestVolume001
Volume Session Id:      1
Volume Session Time:    1051531381
Last Volume Bytes:      39,072,359
FD termination status:  OK
SD termination status:  OK
Termination:            Backup OK
28-Apr-2003 14:30 rufus-dir: Begin pruning Jobs.
28-Apr-2003 14:30 rufus-dir: No Jobs found to prune.
28-Apr-2003 14:30 rufus-dir: Begin pruning Files.
28-Apr-2003 14:30 rufus-dir: No Files found to prune.
28-Apr-2003 14:30 rufus-dir: End auto prune.
```

您也可以要求 bconsole 等待特定作业完成，而不是多次键入 `messages` ：

```bash
*wait jobid=1
```

或者只是等待，等待所有正在运行的作业完成。

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

要退出此模式，只需输入：

```bash
done
```

会得到如下输出：

```bash
Bootstrap records written to
   /home/user/bareos/testbin/working/restore.bsr
The restore job will require the following Volumes:

   TestVolume001
1444 files selected to restore.
Run Restore job
JobName:         RestoreFiles
Bootstrap:      /home/user/bareos/testbin/working/restore.bsr
Where:          /tmp/bareos-restores
Replace:        always
FileSet:        Full Set
Backup Client:  rufus-fd
Restore Client: rufus-fd
Storage:        File
JobId:          *None*
When:           2005-04-28 14:53:54
OK to run? (yes/mod/no):
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.1.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================

    TestVolume001             File                      FileStorage

Volumes marked with "*" are online.


166 files selected to be restored.

Run Restore job
JobName:         RestoreFiles
Bootstrap:       /var/lib/bareos/bareos-dir.restore.1.bsr
Where:           /tmp/bareos-restores
Replace:         Always
FileSet:         Full Set
Backup Client:   bareos-fd
Restore Client:  bareos-fd
Format:          Native
Storage:         File
When:            2013-05-23 15:56:53
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no):
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

  Show detail information about a specific command, in this case the command **list**.显示有关特定命令的详细信息，在本例中为命令列表。

- status dir

  Print a status of all running jobs and jobs scheduled in the next 24 hours.打印所有正在运行的作业和计划在未来24小时内执行的作业的状态。

- status

  The console program will prompt you to select a daemon type, then will request the daemon’s status.控制台程序将提示您选择守护进程类型，然后请求守护进程的状态。

- status jobid=nn

  Print a status of JobId  nn if it is running. The Storage daemon is contacted and requested to  print a current status of the job as well.如果作业正在运行，则打印作业ID nn的状态。存储守护进程也会被联系并请求打印作业的当前状态。

- list pools

  List the pools defined in the Catalog (normally only Default is used).列出目录中定义的池（通常仅使用默认值）。

- list volumes

  Lists all the media defined in the Catalog.列出目录中定义的所有介质。

- list jobs

  Lists all jobs in the Catalog that have run.列出目录中已运行的所有作业。

- list jobid=nn

  Lists JobId nn from the Catalog.列出目录中的作业ID nn。

- list jobtotals

  Lists totals for all jobs in the Catalog.列出目录中所有作业的总计。

- list files jobid=nn

  List the files that were saved for JobId nn.列出为JobId nn保存的文件。

- list jobmedia

  List the media information for each Job run.列出每个作业运行的介质信息。

- messages

  Prints any messages that have been directed to the console.打印已定向到控制台的任何消息。

- quit

  Exit or quit the console program.退出或退出控制台程序。

上面给出的大多数命令，除了 list，如果只输入命令名，就会提示您输入必要的参数。

