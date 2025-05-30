# Howtos[](https://docs.bareos.org/Appendix/Howtos.html#howtos)



## Use a dummy device to test the backup[](https://docs.bareos.org/Appendix/Howtos.html#use-a-dummy-device-to-test-the-backup)

> If your are testing your configuration, but don’t want to store  the backup data, it is possible to use a dummy FIFO device to test your  configuration, see [Stored configuration](https://docs.bareos.org/Configuration/StorageDaemon.html#setupfifo).

Obviously, it can not be used to do a restore.

FIFO Storage Device Configuration[](https://docs.bareos.org/Appendix/Howtos.html#id1)

```
Device {
  Name = NULL
  Media Type = NULL
  Device Type = Fifo
  Archive Device = /dev/null
  LabelMedia = yes
  Random Access = no
  AutomaticMount = no
  RemovableMedia = no
  MaximumOpenWait = 60
  AlwaysOpen = no
}
```



## Backup Of Third Party Databases[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-third-party-databases)

If you are running a database in production mode on your machine, Bareos will happily backup the files, but if the database is  in use while Bareos is reading it, you may back it up in an unstable  state.

The best solution is to shutdown your database before backing it up,  or use some tool specific to your database to make a valid live copy  perhaps by dumping the database in ASCII format.



### Backup of MSSQL Databases with Bareos Plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-mssql-databases-with-bareos-plugin)

*Version >= 13.2.0*

#### Preparation[](https://docs.bareos.org/Appendix/Howtos.html#preparation)

If you like to use the MSSQL-Plugin to backing up your Databases you need to consider some things:

- Database Mode

  The database need to run in Full Recovery Mode.  Otherwise you are not able to use differential and incremental backups  or to use point in time recovery.

  Warning

  If you set the databases into the mentionend mode you have to  consider some maintenance facts. The database doesn’t shrink or delete  the logs unanttended, so you have to shrink them manual once a week and  you have to truncate the logs once in a month.

- Security and Access

  For connections you can use a SQL-User or a integrated systemaccount (Windows NT user). Both connection types are supported.

  - Standard Security

    You have to provide user credentials within your  options which do belong to user with the sufficent right performing  restores and backups from the database. This way stands for an extra  backup/restore user.

  - Trusted Security

    You use a systemaccount which have the sufficent  rights to performing backups and restores on a database. This  systemaccount have to be same account like the bareos-filedeamon runs  on.

- Permissions and Roles

  - Server-Role

    The user should be in the groups sysadmin and dbcreator.

  - Database permissions

    The user have to be a backupoperator and dbowner of the database which you like to backup.

There is no difference for the rights and roles between using a  systemaccount (trusted security method) or a extra backup user (standard security method). Please keep in mind if you use the trusted security  method you have to use the same system account like the  bareos-filedeamon runs on.

- PITR Point in time restore

  Warning

  Doing a PITR (Point In Time Restore) will break the backup chain. After the restore a Full job **must be** run afterwards to obtain a clean backup chain.



#### MSSQL Plugin Installation[](https://docs.bareos.org/Appendix/Howtos.html#mssql-plugin-installation)

For Bareos < 14.2, install the Bareos MSSQL plugin onto the MSSQL  server you want to backup. Bareos >= 14.2 also allows to backup  remote MSSQL servers (option **serveraddress**).

##### Bareos Windows-Installer[](https://docs.bareos.org/Appendix/Howtos.html#bareos-windows-installer)

Install the Bareos filedaemon including the component “Bareos FileDameon Plugins”.

##### Manual install[](https://docs.bareos.org/Appendix/Howtos.html#manual-install)

After downloading the plugin you need to copy it into `C:\Program Files\Bareos\Plugins`. Then you need to define the plugin directory and which plugin the  bareos-filedaemon should use. You have to edit the bareos-filedaemon  resource in `C:\Program Data\bareos-fd.conf` as follows:

MSSQL plugin configuration[](https://docs.bareos.org/Appendix/Howtos.html#id2)

```
FileDaemon {
  Name = mssqlserver-fd
  Maximum Concurrent Jobs = 20

  # remove comment in next line to load plugins from specified directory
  Plugin Directory = "C:/Program Files/Bareos/Plugins"

  Plugin Names = "mssqlvdi"
}
```

#### Plugin Test[](https://docs.bareos.org/Appendix/Howtos.html#plugin-test)

status client=mssqlserver-fd[](https://docs.bareos.org/Appendix/Howtos.html#id3)

```
*status client=mssqlserver-fd
Connecting to Client mssqlserver-fd at 192.168.10.101:9102

mssqlserver-fd Version: 13.2.2 (12 November 2013)  VSS Linux Cross-compile Win64
Daemon started 18-Nov-13 11:51. Jobs: run=0 running=0.
Microsoft Windows Server 2012 Standard Edition (build 9200), 64-bit
 Heap: heap=0 smbytes=20,320 max_bytes=20,522 bufs=71 max_bufs=73
 Sizeof: boffset_t=8 size_t=8 debug=0 trace=1 bwlimit=0kB/s
Plugin Info:
 Plugin     : mssqlvdi-fd.dll
 Description: Bareos MSSQL VDI Windows File Daemon Plugin
 Version    : 1, Date: July 2013
 Author     : Zilvinas Krapavickas
 License    : Bareos AGPLv3
 Usage      :
  mssqlvdi:
  serveraddress=<hostname>:
  instance=<instance name>:
  database=<database name>:
  username=<database username>:
  password=<database password>:
  norecovery=<yes|no>:
  replace=<yes|no>:
  recoverafterrestore=<yes|no>:
  stopbeforemark=<log sequence number specification>:
  stopatmark=<log sequence number specification>:
  stopat=<timestamp>
  getconfigurationtimeout=<timeout-seconds>

 examples:
  timestamp: 'Apr 15, 2020 12:00 AM'
  log sequence number: 'lsn:15000000040000037'
```

#### Configure the FileSet[](https://docs.bareos.org/Appendix/Howtos.html#configure-the-fileset)

To use the plugin you need to configure it in the fileset as a plugin resource. For each database instance you need to define a exclusive  backup job and fileset.

MSSQL FileSet[](https://docs.bareos.org/Appendix/Howtos.html#id4)

```
Fileset {
  Name = "Mssql"
  Enable VSS = no
  Include {
    Options {
      Signature = XXH128
    }
    Plugin = "mssqlvdi:instance=default:database=myDatabase:username=bareos:password=bareos"
  }
}
```

In this example we use the standard security method for the connection.

Used options in the plugin string are:

- mssqlvdi

  This is the reference to the MSSQL plugin.

- serveraddress

  (*Version >= 14.2.2*) Defines the server address to connect to (if empty defaults to localhost).

- instance

  Defines the instance within the database server.

- database

  Defines the database that should get backed up.

- username and password

  Username and Password are required, when the connection is done using a MSSQL user. If the systemaccount  the bareos-fd runs with has succifient permissions, this is not  required.

It is recommend to define an additional restore job.

For every database separate job and FileSet are required.

#### Run Backups[](https://docs.bareos.org/Appendix/Howtos.html#run-backups)

Here you can see an example for a backup:

run MSSQL backup job[](https://docs.bareos.org/Appendix/Howtos.html#id5)

```
*run job=MSSQLBak
Using Catalog "MyCatalog"
Run Backup job
JobName:  MSSQLBak
Level:    Full
Client:   mssqlserver-fd
Format:   Native
FileSet:  Mssql
Pool:     File (From Job resource)
Storage:  File (From Job resource)
When:     2013-11-21 09:48:27
Priority: 10
OK to run? (yes/mod/no): yes
Job queued. JobId=7
You have no messages.
*mess
21-Nov 09:48 bareos-dir JobId 7: Start Backup JobId 7, Job=MSSQLBak.2013-11-21_09.48.30_04
21-Nov 09:48 bareos-dir JobId 7: Using Device "FileStorage" to write.
21-Nov 09:49 bareos-sd JobId 7: Volume "test1" previously written, moving to end of data.
21-Nov 09:49 bareos-sd JobId 7: Ready to append to end of Volume "test1" size=2300114868
21-Nov 09:49 bareos-sd JobId 7: Elapsed time=00:00:27, Transfer rate=7.364 M Bytes/second

21-Nov 09:49 bareos-dir JobId 7: Bareos bareos-dir 13.4.0 (01Oct13):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 7.0 (wheezy)
  JobId:                  7
  Job:                    MSSQLBak.2013-11-21_09.48.30_04
  Backup Level:           Full
  Client:                 "mssqlserver-fd" 13.2.2 (12Nov13) Microsoft Windows Server 2012 Standard Edition (build 9200), 64-bit,Cross-compile,Win64
  FileSet:                "Mssql" 2013-11-04 23:00:01
  Pool:                   "File" (From Job resource)
  Catalog:                "MyCatalog" (From Client resource)
  Storage:                "File" (From Job resource)
  Scheduled time:         21-Nov-2013 09:48:27
  Start time:             21-Nov-2013 09:49:13
  End time:               21-Nov-2013 09:49:41
  Elapsed time:           28 secs
  Priority:               10
  FD Files Written:       1
  SD Files Written:       1
  FD Bytes Written:       198,836,224 (198.8 MB)
  SD Bytes Written:       198,836,435 (198.8 MB)
  Rate:                   7101.3 KB/s
  Software Compression:   None
  VSS:                    no
  Encryption:             no
  Accurate:               no
  Volume name(s):         test1
  Volume Session Id:      1
  Volume Session Time:    1384961357
  Last Volume Bytes:      2,499,099,145 (2.499 GB)
  Non-fatal FD errors:    0
  SD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Backup OK
```

At least you gain a full backup which contains the follow:

```
@MSSQL/
@MSSQL/default/
@MSSQL/default/myDatabase/
@MSSQL/default/myDatabase/db-full
```

After your first full backup you will be able to also run differential and incremental backups. Differential FileSet example:

```
/@MSSQL/
/@MSSQL/default/
/@MSSQL/default/myDatabase/
/@MSSQL/default/myDatabase/db-full
/@MSSQL/default/myDatabase/db-diff
```

Incremental FileSet example:

```
*@MSSQL/
  *default/
    *myDatabase/
      *db-diff
      *db-full
      *log-2013-11-21 17:32:20
```

#### Restores[](https://docs.bareos.org/Appendix/Howtos.html#restores)

If you want to perform a restore of a full backup without  differentials or incrementals you have some options which helps you to  restore even the corrupted database still exist. But you have to  specifiy the options like plugin, instance and database during every  backup.

- replace=<yes|no>

  With this option you can replace the database if it still exist.

- instance

  Defines the server instance within the database is running.

- database

  Defines the database you want to backup.

##### Restore to local files[](https://docs.bareos.org/Appendix/Howtos.html#restore-to-local-files)

Sometimes it is desirable to restore the backup **into local files** instead of restoring directly to the database server. This is useful to restore the database **under a different name**, or perform any kind of special operations using the sql management studio.

If the *where* parameter is set **to a directory** instead of ‘/’, the plugin will restore the backup as files into the given directory.

Example: If *where* is set to  **’c:/temp’**, the plugin will restore the selected backup files under a relocated path under c:/temp/@MSSQL@/…

If *where* is set to ’/’ it will restore to the Virtual Device Interface (VDI).

##### Restore to database[](https://docs.bareos.org/Appendix/Howtos.html#restore-to-database)

Example for a full restore:

restore MSSQL database[](https://docs.bareos.org/Appendix/Howtos.html#id6)

```
*restore client=mssqlserver-fd
Using Catalog "MyCatalog"

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
Select item:  (1-13): 5
Automatically selected FileSet: Mssql
+-------+-------+----------+-------------+---------------------+------------+
| JobId | Level | JobFiles | JobBytes    | StartTime           | VolumeName |
+-------+-------+----------+-------------+---------------------+------------+
|     8 | F     |        1 | 198,836,224 | 2013-11-21 09:52:28 | test1      |
+-------+-------+----------+-------------+---------------------+------------+
You have selected the following JobId: 8

Building directory tree for JobId(s) 8 ...
1 files inserted into the tree.

You are now entering file selection mode where you add (mark) and
remove (unmark) files to be restored. No files are initially added, unless
you used the "all" keyword on the command line.
Enter "done" to leave this mode.

cwd is: /
$ mark *
1 file marked.
$ done
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.4.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================

    test1                     File                      FileStorage

Volumes marked with "*" are online.


1 file selected to be restored.

The defined Restore Job resources are:
     1: RestoreMSSQL
     2: RestoreFiles
Select Restore Job (1-2): 1
Using Catalog "MyCatalog"
Run Restore job
JobName:         RestoreMSSQL
Bootstrap:       /var/lib/bareos/bareos-dir.restore.4.bsr
Where:           /
Replace:         Always
FileSet:         Mssql
Backup Client:   mssqlserver-fd
Restore Client:  mssqlserver-fd
Format:          Native
Storage:         File
When:            2013-11-21 17:12:05
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Restore Client
     6: Backup Format
     7: When
     8: Priority
     9: Bootstrap
    10: Where
    11: File Relocation
    12: Replace
    13: JobId
    14: Plugin Options
Select parameter to modify (1-14): 14
Please enter Plugin Options string: mssqlvdi:instance=default:database=myDatabase:replace=yes
Run Restore job
JobName:         RestoreMSSQL
Bootstrap:       /var/lib/bareos/bareos-dir.restore.4.bsr
Where:           /
Replace:         Always
FileSet:         Mssql
Backup Client:   mssqlserver-fd
Restore Client:  mssqlserver-fd
Format:          Native
Storage:         File
When:            2013-11-21 17:12:05
Catalog:         MyCatalog
Priority:        10
Plugin Options:  mssqlvdi:instance=default:database=myDatabase:replace=yes
OK to run? (yes/mod/no): yes
Job queued. JobId=10
You have messages.
*mess
21-Nov 17:12 bareos-dir JobId 10: Start Restore Job RestoreMSSQL.2013-11-21_17.12.26_11
21-Nov 17:12 bareos-dir JobId 10: Using Device "FileStorage" to read.
21-Nov 17:13 damorgan-sd JobId 10: Ready to read from volume "test1" on device "FileStorage" (/storage).
21-Nov 17:13 damorgan-sd JobId 10: Forward spacing Volume "test1" to file:block 0:2499099145.
21-Nov 17:13 damorgan-sd JobId 10: End of Volume at file 0 on device "FileStorage" (/storage), Volume "test1"
21-Nov 17:13 damorgan-sd JobId 10: End of all volumes.
21-Nov 17:13 bareos-dir JobId 10: Bareos bareos-dir 13.4.0 (01Oct13):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 7.0 (wheezy)
  JobId:                  10
  Job:                    RestoreMSSQL.2013-11-21_17.12.26_11
  Restore Client:         mssqlserver-fd
  Start time:             21-Nov-2013 17:12:28
  End time:               21-Nov-2013 17:13:21
  Files Expected:         1
  Files Restored:         1
  Bytes Restored:         198,836,224
  Rate:                   3751.6 KB/s
  FD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Restore OK
```

##### Restore a Backup Chain[](https://docs.bareos.org/Appendix/Howtos.html#restore-a-backup-chain)

If you like to restore a specific state or a whole chain consists of  full, incremental and differential backups you need to use the  “norecovery=yes” option. After this the database is in “recovery mode”.  You can also use a option which put the database right after the restore back into the right mode. If you like to restore certains point with  protocols or “LSN” it it not recommend to work with this option.

- norecovery=<yes|no>

  This option must be set to yes, if the database server should not do a automatic recovery after the  backup. Instead, additional manual maintenace operations are possible.

- recoverafterrestore=<yes|no>

  With this command the  database is right after backup in the correct mode. If you not use this  you have to use the followed tsql statement: `Restore DATABASE yourDatabase WITH RECOVERY GO `

- stopbeforemark=<log sequence number specification>

  used for point in time recovery.

- stopatmark=<log sequence number specification>

  used for point in time recovery.

- stopat=<timestamp>

  used for point in time recovery.

Followed is a example for a restore of full, differential and incremental backup with a replace of the original database:

restore MSSQL database chain[](https://docs.bareos.org/Appendix/Howtos.html#id7)

```
*restore client=mssqlserver-fd

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
Select item:  (1-13): 5
Automatically selected FileSet: Mssql
+-------+-------+----------+-------------+---------------------+------------+
| JobId | Level | JobFiles | JobBytes    | StartTime           | VolumeName |
+-------+-------+----------+-------------+---------------------+------------+
|     8 | F     |        1 | 198,836,224 | 2013-11-21 09:52:28 | test1      |
|    11 | D     |        1 |   2,555,904 | 2013-11-21 17:19:45 | test1      |
|    12 | I     |        1 |     720,896 | 2013-11-21 17:29:39 | test1      |
+-------+-------+----------+-------------+---------------------+------------+
You have selected the following JobIds: 8,11,12

Building directory tree for JobId(s) 8,11,12 ...
3 files inserted into the tree.

You are now entering file selection mode where you add (mark) and
remove (unmark) files to be restored. No files are initially added, unless
you used the "all" keyword on the command line.
Enter "done" to leave this mode.

cwd is: /
$ mark *
3 files marked.
$ lsmark
*@MSSQL/
  *default/
    *myDatabase/
      *db-diff
      *db-full
      *log-2013-11-21 17:32:20
$ done
Bootstrap records written to /var/lib/bareos/bareos-dir.restore.6.bsr

The job will require the following
   Volume(s)                 Storage(s)                SD Device(s)
===========================================================================

    test1                     File                      FileStorage

Volumes marked with "*" are online.


1 file selected to be restored.

The defined Restore Job resources are:
     1: RestoreMSSQL
     2: RestoreFiles
Select Restore Job (1-2): 1
Run Restore job
JobName:         RestoreMSSQL
Bootstrap:       /var/lib/bareos/bareos-dir.restore.6.bsr
Where:           /
Replace:         Always
FileSet:         Mssql
Backup Client:   mssqlserver-fd
Restore Client:  mssqlserver-fd
Format:          Native
Storage:         File
When:            2013-11-21 17:34:23
Catalog:         MyCatalog
Priority:        10
Plugin Options:  *None*
OK to run? (yes/mod/no): mod
Parameters to modify:
     1: Level
     2: Storage
     3: Job
     4: FileSet
     5: Restore Client
     6: Backup Format
     7: When
     8: Priority
     9: Bootstrap
    10: Where
    11: File Relocation
    12: Replace
    13: JobId
    14: Plugin Options
Select parameter to modify (1-14): 14
Please enter Plugin Options string: mssqlvdi:instance=default:database=myDatabase:replace=yes:norecovery=yes
Run Restore job
JobName:         RestoreMSSQL
Bootstrap:       /var/lib/bareos/bareos-dir.restore.6.bsr
Where:           /
Replace:         Always
FileSet:         Mssql
Backup Client:   mssqlserver-fd
Restore Client:  mssqlserver-fd
Format:          Native
Storage:         File
When:            2013-11-21 17:34:23
Catalog:         MyCatalog
Priority:        10
Plugin Options:  mssqlvdi:instance=default:database=myDatabase:replace=yes:norecovery=yes
OK to run? (yes/mod/no): yes
Job queued. JobId=14
21-Nov 17:34 bareos-dir JobId 14: Start Restore Job RestoreMSSQL.2013-11-21_17.34.40_16
21-Nov 17:34 bareos-dir JobId 14: Using Device "FileStorage" to read.
21-Nov 17:35 damorgan-sd JobId 14: Ready to read from volume "test1" on device "FileStorage" (/storage).
21-Nov 17:35 damorgan-sd JobId 14: Forward spacing Volume "test1" to file:block 0:2499099145.
21-Nov 17:35 damorgan-sd JobId 14: End of Volume at file 0 on device "FileStorage" (/storage), Volume "test1"
21-Nov 17:35 damorgan-sd JobId 14: End of all volumes.
21-Nov 17:35 bareos-dir JobId 14: Bareos bareos-dir 13.4.0 (01Oct13):
  Build OS:               x86_64-pc-linux-gnu debian Debian GNU/Linux 7.0 (wheezy)
  JobId:                  14
  Job:                    RestoreMSSQL.2013-11-21_17.34.40_16
  Restore Client:         mssqlserver-fd
  Start time:             21-Nov-2013 17:34:42
  End time:               21-Nov-2013 17:35:36
  Files Expected:         1
  Files Restored:         3
  Bytes Restored:         202,113,024
  Rate:                   3742.8 KB/s
  FD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Restore OK
```



### Backup of a PostgreSQL Database[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-postgresql-database)

In this section, we describe different methods how to do backups of the PostgreSQL databases.

#### Backup of a PostgreSQL Database by using the RunScript directive[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-postgresql-database-by-using-the-runscript-directive)

One method to backup a PostgreSQL database is to use the **pg_dumpall** tool to dump the database into a file and then backup it as a normal  file. After the backup, the file can be removed. It may also be an  option not to remove it, so that the latest version is always available  immediately. On the next job run it will be overwritten anyway.

This can be done by using [`Run Script (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_RunScript) directives inside a Job Resource, for example:

RunScript job resource for a PostgreSQL backup[](https://docs.bareos.org/Appendix/Howtos.html#id8)

```
 Job {
     Name = "backup-postgres"
     JobDefs = "DefaultJob"
     Client = dbserver-fd
     Level = Full
     FileSet="postgres"

     # This creates a dump of our database in the local filesystem on the client
     RunScript {
         FailJobOnError = Yes
         RunsOnClient = Yes
         RunsWhen = Before
         Command = "su postgres -c 'pg_dumpall > /var/tmp/postgresql_dump.sql'"
     }

     # This deletes the dump in our local filesystem on the client
     RunScript {
         RunsOnSuccess = Yes
         RunsOnClient = Yes
         RunsWhen = After
         Command = "rm /var/tmp/postgresql_dump.sql"
     }
 }

 FileSet {
     Name = "postgres"
     Include {
         Options {
             Signature = XXH128
             Compression = LZ4
         }
         # database dump file
         File = "/var/tmp/postgresql_dump.sql"
     }
 }
```

Note that redirecting the **pg_dumpall** output to a file requires to run the whole command line through a shell, otherwise the **pg_dumpall** would not know what do with the **>** character and the job would fail. As no shell features like redirection or piping are used for the **rm**, the **sh -c** is not needed there. See [`Run Script (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_RunScript) for more details.

#### Backup of a PostgreSQL Databases by using the bpipe plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-postgresql-databases-by-using-the-bpipe-plugin)

Instead of creating a temporary database dump file, the bpipe plugin can be used. For general information about bpipe, see the [bpipe Plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#bpipe) section. The bpipe plugin is configured inside the [`Include (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include) section of a File Set, e.g.:

bpipe directive for PostgreSQL backup[](https://docs.bareos.org/Appendix/Howtos.html#id9)

```
FileSet {
  Name = "postgresql-all"
  Include {
    Options {
      Signature = XXH128
      Compression = LZ4
    }
    Plugin = "bpipe:file=/POSTGRESQL/dump.sql:reader=su postgres -c pg_dumpall:writer=su postgres -c psql"
  }
}
```

This causes the File Daemon to call bpipe plugin, which will write its data into the “pseudo” file `/POSTGRESQL/dump.sql` by calling the program **pg_dumpall -U postgres** to read the data during backup. The **pg_dumpall** command outputs all the data for the database, which will be read by  the plugin and stored in the backup. During restore, the data that was  backed up will be sent to the program specified in the last field, which in this case is psql. When psql is called, it will read the data sent to it by  the plugin then write it back to the same database from which it came  from.

This can also be used, to backup a database that is running on a remote host:

bpipe directive to backup a PostgreSQL database that is running on a remote host[](https://docs.bareos.org/Appendix/Howtos.html#id10)

```
FileSet {
  Name = "postgresql-remote"
  Include {
    Plugin = "bpipe:file=/POSTGRESQL/dump.sql:reader=pg_dumpall -h <hostname> -U <username> -W <password>:writer=psql -h <hostname> -U <username> -W <password>"
    Options {
      Signature = XXH128
      Compression = LZ4
    }
  }
}
```

#### Backup of a PostgreSQL Databases by using the PostgreSQL-Plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-postgresql-databases-by-using-the-postgresql-plugin)

See [PostgreSQL Plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#plugin-postgresql-fd).



### Backup of a MySQL Database[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-mysql-database)



In this section, we describe different methods to do a full backup of a MySQL database.

#### Backup of a MySQL Database by using the RunScript directive[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-mysql-database-by-using-the-runscript-directive)



One method to backup a MySQL database is to use the **mysqldump** tool to dump the database into a file and then backup it as a normal  file. After the backup, the file can be removed. It may also be an  option not to remove it, so that the latest version is always available  immediately. On the next job run it will be overwritten anyway.

This can be done by using [`Run Script (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_RunScript) directives, for example:

RunScript job resource for a MySQL backup[](https://docs.bareos.org/Appendix/Howtos.html#id11)

```
Job {
  Name = "BackupDatabase"
  JobDefs = "DefaultJob"
  Client = dbserver-fd
  Level = Full
  FileSet="Database"

  # This creates a dump of our database in the local filesystem on the Client
  RunScript {
    FailJobOnError = Yes
    RunsOnClient = Yes
    RunsWhen = Before
    Command = "sh -c 'mysqldump --user=<username> --password=<password> --opt --all-databases > /var/lib/bareos/mysql_dump.sql'"
  }

  # This deletes the dump in the local filesystem on the Client
  RunScript {
    RunsOnSuccess = Yes
    RunsOnClient = Yes
    RunsWhen = After
    Command = "rm /var/lib/bareos/mysql_dump.sql"
  }
}

FileSet {
  Name = "Database"
  Include {
    Options {
      Signature = XXH128
      Compression = LZ4
    }
  # database dump file
  File = "/var/lib/bareos/mysql_dump.sql"
  }
}
```

Note that redirecting the **mysqldump** output to a file requires to run the whole command line through a shell, otherwise the **mysqldump** would not know what do with the **>** character and the job would fail. As no shell features like redirection or piping are used for the **rm**, the **sh -c** is not needed there. See [`Run Script (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_RunScript) for more details.

#### Backup of a MySQL Database by using the bpipe plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-a-mysql-database-by-using-the-bpipe-plugin)



Instead of creating a temporary database dump file, the bpipe plugin can be used. For general information about bpipe, see the [bpipe Plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#bpipe) section. The bpipe plugin is configured inside the Include section of a File Set, e.g.:

bpipe fileset for MySQL backup[](https://docs.bareos.org/Appendix/Howtos.html#id12)

```
FileSet {
  Name = "mysql-all"
  Include {
    Plugin = "bpipe:file=/MYSQL/dump.sql:reader=mysqldump --user=<user> --password=<password> --opt --all-databases:writer=mysql --user=<user> --password=<password>"
    Options {
      Signature = XXH128
      Compression = LZ4
    }
  }
}
```

This can also be used, to backup a database that is running on a remote host:

bpipe directive to backup a MySQL database that is running on a remote host[](https://docs.bareos.org/Appendix/Howtos.html#id13)

```
FileSet{
  Name = "mysql-all"
  Include {
    Plugin = "bpipe:file=/MYSQL/dump.sql:reader=mysqldump --host=<hostname> --user=<user> --password=<password> --opt --all-databases:writer=mysql --host=<hostname> --user=<user> --password=<password>"
    Options {
      Signature = XXH128
      Compression = LZ4
    }
  }
}
```

If you do not want a direct restore of your  data in your plugin directive, as shown in the examples above, there is  the possibility to restore the dump to the filesystem first, which  offers you more control over the restore process, e.g.:

bpipe directive to backup a MySQL database and restore the dump to the filesystem first[](https://docs.bareos.org/Appendix/Howtos.html#id14)

```
FileSet{
  Name = "mysql-all"
  Include {
    Plugin = "bpipe:file=/MYSQL/dump.sql:reader=mysqldump --host=<hostname> --user=<user> --password=<password> --opt --all-databases:writer=/usr/lib/bareos/scripts/bpipe-restore.sh"
    Options {
      Signature = XXH128
      Compression = LZ4
    }
  }
}
```

A very simple corresponding shell script (**bpipe-restore.sh**) to the method above might look like the following one:

bpipe shell script for a restore to filesystem[](https://docs.bareos.org/Appendix/Howtos.html#id15)

```
#!/bin/bash
cat - > /tmp/dump.sql
exit 0
```



#### Backup of MySQL Databases using the Python MySQL plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-mysql-databases-using-the-python-mysql-plugin)

The Python plugin from https://github.com/bareos/bareos/tree/master/contrib/fd-plugins/bareos_mysql_dump makes a backup of all or selected MySQL databases from the Bareos File  Daemon or any other MySQL server. It makes use of the mysqldump command  and basically grabs data from mysqldump via pipe. This plugin is  suitable to backup database dumps. Following settings must be done on the Bareos client (Bareos File  Daemon):

- install and enable the Bareos File Daemon Python plugin
- install the Python MySQL plugin (for some platforms it is  available prepackaged, on the other platforms: copy the plugin files to  the Bareos Plugin Directory)

bareos-fd.d/client/myself.conf[](https://docs.bareos.org/Appendix/Howtos.html#id16)

```
Client {
  ...
  Plugin Directory = /usr/lib64/bareos/plugins
  Plugin Names = "python3"
}
```

Configure the plugin in the Bareos Director:

bareos-dir.d/fileset/mysql.conf[](https://docs.bareos.org/Appendix/Howtos.html#id17)

```
FileSet {
    Name = "mysql"
    Include {
      Options {
        Signature = XXH128
        Compression = LZ4
      }
      Plugin = "python3"
               ":module_name=bareos_mysql_dump"
               ":db=test,wikidb"
      #Plugin = "python3"
      #         ":module_name=bareos_mysql_dump"
      #         ":mysqlhost=dbhost"
      #         ":mysqluser=bareos"
      #         ":mysqlpassword=bareos"
    }
}
```

In the above example the plugin creates and saves a dump from the databases called **test** and **wikidb**, running on the file-daemon. The commented example below specifies an explicit MySQL server called **dbhost**, and connects with user **bareos**, password **bareos**, to create and save a backup of all databases.

The plugin creates a pipe internally, thus no extra space on disk is  needed. You will find one file per database in the backups in the  virtual directory `@mysqlbackups@`.

List of supported options:

- db

  comma separated list of databases to save, where each  database will be stored in a separate file. If ommited, all databases  will be saved.

- dumpbinary

  command (with or without full path) to create the dumps. Default: **mysqldump**

- dumpoptions

  options for dumpbinary, default: “**–events –single-transaction**”

- drop_and_recreate

  if not set to **false**, adds **–add-drop-database –databases** to dumpoptions

- mysqlhost

  MySQL host to connect to, default: **localhost**

- mysqluser

  MySQL user. Default: unset, the user running the file-daemon will be used (usually root)

- mysqlpassword

  MySQL password. Default: unset (better use `my.cnf` to store passwords)

On restore, the database dumps are restored to the subdirectory `@mysqlbackups@` in the restore path. The database restore must be triggered manually (**mysql < @mysqlbackups@/DATABASENAME.sql**).

#### Backup of MySQL Databases using the Python xtrabackup plugin[](https://docs.bareos.org/Appendix/Howtos.html#backup-of-mysql-databases-using-the-python-xtrabackup-plugin)

For incremental hot-backups of InnoDB tables, please use the Bareos MySQL / MariaDB Percona xtrabackup Plugin (see [Percona XtraBackup Plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#backup-mysql-xtrabackup)).



## Migrate a Bareos Catalog from MySQL to PostgreSQL[](https://docs.bareos.org/Appendix/Howtos.html#migrate-a-bareos-catalog-from-mysql-to-postgresql)

Since Bareos *Version >= 21.0.0* the MySQL database backend is not shipped anymore. Therefore you need to use Bareos 20 to migrate an existing MySQL Bareos Catalog to PostgreSQL. To do so, upgrade to Bareos 20 first and use bareos-dbcopy to copy the whole Bareos MySQL catalog into a new PostgreSQL catalog database. This chapter describes how to do a migration using **bareos-dbcopy**.

### Make a backup of your old database[](https://docs.bareos.org/Appendix/Howtos.html#make-a-backup-of-your-old-database)

Warning

Make a backup of your old database before you start the migration process!

### Prepare the new database[](https://docs.bareos.org/Appendix/Howtos.html#prepare-the-new-database)

Warning

Don’t start the Bareos Director before completing the migration. Otherwise the Bareos Director will already insert data into the new PostgreSQL catalog while **bareos-dbcopy** will skip every table already containing data.

Firstly, create a new PostgreSQL database as described in [Prepare Bareos database](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-createdatabase), You have to give the dbtype to the script, so the right db engine is used.

Run creating script with db type specified[](https://docs.bareos.org/Appendix/Howtos.html#id18)

```
su - postgres /usr/lib/bareos/scripts/create_bareos_database postgresql
su - postgres /usr/lib/bareos/scripts/make_bareos_tables postgresql
su - postgres /usr/lib/bareos/scripts/grant_bareos_privileges postgresql
```

Both MySQL and PostgreSQL need to have the same Bareos database scheme version, i.e. have the schema from the identical Bareos version (this should be the case automatically, when upgrading the MySQL catalog to Bareos 20 and creating a Bareos 20 PostgreSQL catalog).

Add the new PostgreSQL database to the current Bareos Director configuration, but **do not remove** the MySQL database from the config, yet. Both catalog resources must be present during the migration process.

These are the catalog resources used in this example:

Existing catalog resource for MySQL[](https://docs.bareos.org/Appendix/Howtos.html#id19)

```
Catalog
{
  Name = MyCatalog
  DB Driver = mysql
  DB Name = bareos;
  DB User = bareos;
  DB Password = ""
}
```

New catalog resource for PostgreSQL[](https://docs.bareos.org/Appendix/Howtos.html#id20)

```
Catalog
{
  Name = MyCatalog-psql
  DB Driver = postgresql
  DB Name = bareos;
  DB User = bareos;
  DB Password = ""
}
```

### Run bareos-dbcopy[](https://docs.bareos.org/Appendix/Howtos.html#run-bareos-dbcopy)

Once the databases are running you can start to copy the contents from MySQL to PostgreSQL.

Note

Please run bareos-dbcopy as user **bareos** to avoid problems with access rights. See example below how to start the shell as user **bareos** and run dbcopy.

Run the bareos-dbcopy command as bareos user[](https://docs.bareos.org/Appendix/Howtos.html#id21)

```
Start the shell as bareos user
su -s /bin/bash - bareos
run the command as user bareos:
bareos-dbcopy -c <path-to-bareos-config> MyCatalog MyCatalog-psql
```

Depending on the size of your database the copy process can run up to several hours. In our tests with a database containing 160 Million rows in the file table took about 5 hours to copy (the testsystem was equipped with SSDs).

*bareos-dbcopy* will then examine the databases and copy the tables one by one. The *file table* is by far the largest table and usually takes the longest time to copy.

Example output of bareos-dbcopy[](https://docs.bareos.org/Appendix/Howtos.html#id22)

```
Copying tables from "MyCatalog" to "MyCatalog-psql"
gathering information about source catalog "MyCatalog"...
gathering information about destination catalog "MyCatalog-psql"...
getting column descriptions...
--> basefiles
--> client
--> counters

...

--> version
copying tables...
====== table BaseFiles ======
--> checking destination table...
--> requesting number of rows to be copied...
--> nothing to copy...
--> updating sequence
--> success

...

====== table File ======
--> checking destination table...
--> requesting number of rows to be copied...
--> copying 100'000 rows...
--> Start: 2020-02-26 16:52:01
      4% ETA:2020-02-26 16:52:08 (running:0h00m00s, remaining:0h00m07s)
     12% ETA:2020-02-26 16:52:07 (running:0h00m00s, remaining:0h00m05s)
     20% ETA:2020-02-26 16:52:08 (running:0h00m01s, remaining:0h00m05s)
     28% ETA:2020-02-26 16:52:07 (running:0h00m02s, remaining:0h00m04s)
     36% ETA:2020-02-26 16:52:07 (running:0h00m02s, remaining:0h00m04s)
     44% ETA:2020-02-26 16:52:07 (running:0h00m03s, remaining:0h00m03s)
     52% ETA:2020-02-26 16:52:08 (running:0h00m03s, remaining:0h00m03s)
     60% ETA:2020-02-26 16:52:07 (running:0h00m04s, remaining:0h00m02s)
     68% ETA:2020-02-26 16:52:08 (running:0h00m04s, remaining:0h00m02s)
     76% ETA:2020-02-26 16:52:08 (running:0h00m05s, remaining:0h00m01s)
     84% ETA:2020-02-26 16:52:08 (running:0h00m05s, remaining:0h00m01s)
     92% ETA:2020-02-26 16:52:08 (running:0h00m06s, remaining:0h00m00s)
    100% ETA:2020-02-26 16:52:08 (running:0h00m06s, remaining:0h00m00s)
--> updating sequence
--> success

...

====== table webacula_where_acl ======
--> checking destination table...
--> destination table does not exist
--> *** skipping ***
database copy completed successfully
```

Note

In the example above the table *webacula_where_acl* was skipped, because it does not exist in the target database scheme. This is the desired behaviour.

### Complete the migration process[](https://docs.bareos.org/Appendix/Howtos.html#complete-the-migration-process)

After bareos-dbcopy copied all data to the PostgreSQL catalog the following tasks need to be done:

- rename the PostgreSQL catalog resource to the name of the MySQL resource (in our example: MyCatalog-psql -> MyCatalog)
- comment out the MySQL catalog resource from the director configuration
- start the Bareos Director

The migration is now completed.

Note

Once you are ready to upgrade to *Version >= 21.0.0*, **remove** the package **bareos-database-mysql** from your installation. We’ve made the upgrade process failing on purpose to avoid unattended upgrade.



## Statistics Collection[](https://docs.bareos.org/Appendix/Howtos.html#statistics-collection)

Statistics Collection can be controlled by a number of  configuration directives. If Statistics Collection is enabled,  statistics are collected by the Bareos Director and stored into the  Catalog database. So enabling this feature will increase your database  size.

The Statistics are used by the Bareos WebUI to show the status of a running job.

### Director Configuration - Director Resource Directives[](https://docs.bareos.org/Appendix/Howtos.html#director-configuration-director-resource-directives)

- [`Statistics Collect Interval (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_StatisticsCollectInterval)
- [`Statistics Retention (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_StatisticsRetention)

### Director Configuration - Storage Resource Directives[](https://docs.bareos.org/Appendix/Howtos.html#director-configuration-storage-resource-directives)

- [`Collect Statistics (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_CollectStatistics)

### Storage Configuration - Storage Resource Directives[](https://docs.bareos.org/Appendix/Howtos.html#storage-configuration-storage-resource-directives)

- [`Collect Device Statistics (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectDeviceStatistics)
- [`Collect Job Statistics (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectJobStatistics)
- [`Statistics Collect Interval (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_StatisticsCollectInterval)

### Storage Configuration - Device Resource Directives[](https://docs.bareos.org/Appendix/Howtos.html#storage-configuration-device-resource-directives)

- [`Collect Statistics (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CollectStatistics)

See chapter [Job Statistics](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-jobstatistics) for additional information.



## Removing a Client[](https://docs.bareos.org/Appendix/Howtos.html#removing-a-client)

Removing a client can mean several things in Bareos context. You can  disable the client so no jobs that use this client will run anymore. You can also remove the client’s configuration so that no job can use the  client anymore. However, you will still have the client in your catalog  unless you explicitly remove it.

### Disable a client[](https://docs.bareos.org/Appendix/Howtos.html#disable-a-client)

It is possible to disable a client either by calling **disable client=<client-name>** or by setting [`Enabled (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Enabled) to no. While the configuration change will persist across restarts, the command just disables the client temporarily.

When a client is disabled, the scheduler will not run any job for  this client anymore, but you can still restore to it or manually trigger a job.

### Remove configuration for client[](https://docs.bareos.org/Appendix/Howtos.html#remove-configuration-for-client)

If you want to remove the client permanently, you can also completely remove the client from your configuration. This will make sure that no  job (neither backup nor restore) can use that client machine. After  removing the Client Resource from the director configuration, you will  also need to change or remove all Job and JobDefs Resources in the  Director configuration that reference the removed client.

Removing the client configuration does not remove the backed up data  or the file and job records in the catalog for the client. You can still restore the data that has been backed up from the client to a different client.

### Remove catalog records related to the client[](https://docs.bareos.org/Appendix/Howtos.html#remove-catalog-records-related-to-the-client)

Removing the client from the configuration will leave you with  catalog records concerning the client. If you don’t want to restore any  data backed up from the client anymore, you can call **purge jobs client=<client-name>**. This will remove all job and file records for the named client from the catalog. However, it will not remove the data from the volumes.

Warning

After removing the job and file records you will be unable to restore the client’s data. The **purge** command ignores retention policies, so please take careful.

As soon as all jobs for a client have been removed from the catalog  that client record becomes orphaned. Orphaned client records usually  stay in your database indefinitely, but if you want them removed for  cosmetic reasons you can do so using “Check for orphaned Client records” in **bareos-dbcheck**.

By default **bareos-dbcheck** only lists the orphaned clients it finds. You need to enable the modify database flag to make it actually change the database.