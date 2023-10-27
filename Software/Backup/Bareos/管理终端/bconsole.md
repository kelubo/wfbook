# bconsole

[TOC]

## 概述

为了与 Bareos Director 通信并查询 Bareos 的状态或运行作业，可以将 bconsole 程序用作文本界面。可替代地，对于大多数目的，也可以使用 Bareos Webui。

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

You will notice that the default Bareos Storage Daemon device is named `File (Dir->Storage)` and that it will use device `/var/lib/bareos/storage`, which is not currently open.

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

Here we have the choice to run (yes), to modify one or more of the  above parameters (mod), or to not run the job (no). Please enter yes, at which point you should immediately get the command prompt (an  asterisk).

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

## Restoring Your Files

If you have run the default configuration and run the job as  demonstrated above, you can restore the backed up files in the Console  program by entering:如果已运行默认配置并按上述方式运行作业，则可以通过输入以下命令在控制台程序中还原备份的文件：

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

As you can see, there are a number of options, but for the current  demonstration, please enter 5 to do a restore of the last backup you  did, and you will get the following output:输入5以还原上次备份，您将获得以下输出：

```bash
Automatically selected Client: bareos-fd
The defined FileSet resources are:
     1: Catalog
     2: Full Set
Select FileSet resource (1-2):
```

As you can see, Bareos knows what client you have, and since there  was only one, it selected it automatically. Select 2, because you want  to restore files from the file set.正如您所看到的，Bareos知道您拥有什么客户机，而且由于只有一个客户机，所以它会自动选择它。选择2，因为要从文件集中还原文件。

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

where I have truncated the listing on the right side to make it more readable.

Then Bareos produced a listing containing all the jobs that form the  current backup, in this case, there is only one, and the Storage daemon  was also automatically chosen. Bareos then took all the files that were  in Job number 1 and entered them into a directory tree (a sort of in  memory representation of your filesystem). At this point, you can use  the **cd** and **ls** or **dir** commands to walk up and down the directory tree and view what files will be restored. For example, if you enter **cd /usr/sbin** and then enter **dir** you will get a listing of all the files in the `/usr/sbin/` directory. On your system, the path might be somewhat different. For more information on this, please refer to the [Restore Command Chapter](https://docs.bareos.org/TasksAndConcepts/TheRestoreCommand.html#restorechapter) of this manual for more details.

To exit this mode, simply enter:我截断了右侧的列表，使其更具可读性。

然后Bareos生成了一个包含构成当前备份的所有作业的列表，在本例中，只有一个作业，并且存储守护进程也被自动选择。然后，Bareos获取作业1中的所有文件，并将它们输入目录树（一种文件系统的内存表示形式）。此时，可以使用cd和ls或dir命令在目录树上来回走动，查看要恢复的文件。例如，如果您输入cd/usr/sbin，然后输入dir，您将得到/usr/sbin/目录中所有文件的列表。在您的系统上，路径可能有些不同。有关这方面的更多信息，请参阅本手册的还原命令一章以了解更多详细信息。

要退出此模式，只需输入：

```bash
done
```

and you will get the following output:

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

If you answer yes your files will be restored to `/tmp/bareos-restores`. If you want to restore the files to their original locations, you must  use the mod option and explicitly set Where: to nothing (or to /). We  recommend you go ahead and answer yes and after a brief moment, enter **messages**, at which point you should get a listing of all the files that were  restored as well as a summary of the job that looks similar to this:如果回答“是”，则文件将还原到/tmp/bareos  restores。如果要将文件还原到其原始位置，必须使用mod选项并显式地将Where:设置为nothing（或to/）。我们建议您继续并回答“是”，过一会儿，输入消息，此时您将获得所有已还原文件的列表以及类似以下内容的作业摘要：

job report

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

After exiting the Console program, you can examine the files in `/tmp/bareos-restores`, which will contain a small directory tree with all the files. Be sure to clean up at the end with:退出控制台程序后，可以检查/tmp/bareos restores中的文件，其中将包含一个包含所有文件的小目录树。最后一定要清理干净：

remove restore directory

```bash
 rm -rf /tmp/bareos-restore
```

## 退出

```bash
quit
```
