# bconsole

[TOC]

## 概述

为了与 Bareos Director 通信并查询 Bareos 的状态或运行作业，bconsole 程序可以用作文本界面。可替代地，对于大多数目的，也可以使用 Bareos Webui。

bconsole 是一个用于连接到 Bareos Director 的 Bareos Console 程序。由于 Bareos 是一个网络程序，因此可以在网络上的任何地方运行 Console 程序。然而，大多数情况下，它是在与 Bareos Director 相同的机器上运行的。通常，Console 程序将打印类似以下内容：

```bash
bconsole
Connecting to Director bareos:9101
Enter a period to cancel a command.
*
# *是控制台命令提示符。
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

其中一个文件集是预定义的 `SelfTest (Dir->Fileset)` 文件集，它将备份 `/usr/sbin` 目录。文件集 `Catalog (Dir->Fileset)` 用于备份 Bareos 的目录。

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

This shows that an Incremental job is scheduled to run  for the Job `BackupClient1 (Dir->Job)` at 1:05am and that at 1:10, a `BackupCatalog (Dir->Job)` is scheduled to run.

这表明计划在凌晨1:05为作业备份客户端1（Dir->job）运行增量作业，并计划在1:10运行备份目录（Dir->job）。

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

In this case, the client is named `bareos-fd (Dir->Client)` your name might be different, but the line beginning with `bareos-fd Version` is printed by your Bareos File Daemon, so we are now sure it is up and running.

在本例中，客户机名为bareos fd（Dir->client）您的名称可能不同，但以bareos fd Version开头的行是由您的bareos文件守护程序打印的，因此我们现在确定它已启动并正在运行。

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

You will notice that the default Bareos Storage Daemon device is named `File (Dir->Storage)` and that it will use device `/var/lib/bareos/storage`, which is not currently open.

您将注意到，默认的Bareos存储守护程序设备名为File（Dir->Storage），它将使用device/var/lib/Bareos/Storage，该设备当前未打开。

运行作业:

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

Bareos列出了可以运行的三个不同的作业，选择数字1并键入enter：

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

At this point, take some time to look carefully at what is printed  and understand it. It is asking you if it is OK to run a job named `BackupClient1 (Dir->Job)` with FileSet `SelfTest (Dir->Fileset)` as an Incremental job on your Client, and to use Storage `File (Dir->Storage)` and Pool `Full (Dir->Pool)`, and finally, it wants to run it now .在这一点上，花一些时间仔细看看什么是印刷和理解它。它询问您是否可以在您的客户机上运行一个名为Backup Client1（Dir->job）的作业，并将File Set Self  Test（Dir->Fileset）作为增量作业，使用Storage File（Dir->Storage）和Pool  Full（Dir->Pool），最后，它希望立即运行它。

Here we have the choice to run (yes), to modify one or more of the  above parameters (mod), or to not run the job (no). Please enter yes, at which point you should immediately get the command prompt (an  asterisk).在这里，我们可以选择运行（yes），修改上面的一个或多个参数（mod），或者不运行作业（no）。请输入yes，此时应立即得到命令提示（星号）。

If you wait a few seconds, then enter the commandyou will get back something like

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

Instead of typing **messages** multiple times, you can also ask bconsole to wait, until a specific job is finished:

您也可以要求bconsole等待特定作业完成，而不是多次键入messages：

```bash
*wait jobid=1
```

or just **wait**, which waits for all running jobs to finish.或者只是等待，等待所有正在运行的作业完成。

Another useful command is **autodisplay on**. With autodisplay activated, messages will automatically be displayed as soon as they are ready.另一个有用的命令是autodisplay on。当autodisplay激活时，消息一准备好就会自动显示。

If you do an **ls -l** of your `/var/lib/bareos/storage` directory, you will see that you have the following item:

如果对/var/lib/bareos/storage目录执行ls-l操作，您将看到有以下项：

```bash
-rw-r-----    1 bareos bareos   39072153 Apr 28 14:30 Full-001
```

This is the file Volume that you just wrote and it contains all the  data of the job just run. If you run additional jobs, they will be  appended to this Volume unless you specify otherwise.这是您刚刚编写的文件卷，它包含刚刚运行的作业的所有数据。如果运行其他作业，除非另有指定，否则这些作业将附加到此卷。

If you would like to stop here, you can simply enter **quit** in the Console program.如果您想在此停止，只需在控制台程序中输入quit即可。
