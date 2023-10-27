# Bareos Webui

## Access Control Configuration

Access Control is configured in `Profile (Dir)`, `Console (Dir)` or `User (Dir)` resources.

Below are some example profile resources that should serve you as guidance to configure access to certain elements of the Bareos WebUI to your needs and use cases.

### Full Access

No restrictions are given by `Profile (Dir)`, everything is allowed. This profile is included in the Bareos WebUI package.

Profile Resource - Administrator Access Example

```
Profile {
   Name = "webui-admin"
   CommandACL = *all*
   JobACL = *all*
   ScheduleACL = *all*
   CatalogACL = *all*
   PoolACL = *all*
   StorageACL = *all*
   ClientACL = *all*
   FilesetACL = *all*
   WhereACL = *all*
}
```

### Limited Access

Users with the following profile example have limited access to various resources but they are allowed to **run**, **rerun** and **cancel** the jobs **backup-bareos-fd** and **backup-example-fd**.

Note

Access to depending resources for the jobs set in the [`Job ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_JobACL) needs also be given by [`Client ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ClientACL), [`Pool ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PoolACL), [`Storage ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_StorageACL) and `Fileset ACL (Dir->Profile)` settings.

Users of this profile are also able to do a restore from within the Bareos WebUI by having access to the RestoreFiles job resource, the required Bvfs API commands and the **restore** command itself.

Profile Resource - Limited Access Example

```
Profile {
   Name = "webui-user"
   # Multiple CommandACL directives as given below are concatenated
   CommandACL = .api, .help, use, version, status, show
   CommandACL = list, llist
   CommandACL = run, rerun, cancel, restore
   CommandACL = .clients, .jobs, .filesets, .pools, .storages, .defaults, .schedule
   CommandACL = .bvfs_update, .bvfs_get_jobids, .bvfs_lsdirs, .bvfs_lsfiles
   CommandACL = .bvfs_versions, .bvfs_restore, .bvfs_cleanup
   JobACL = backup-bareos-fd, backup-example-fd, RestoreFiles
   ScheduleACL = WeeklyCycle
   CatalogACL = MyCatalog
   PoolACL = Full, Differential, Incremental
   StorageACL = File
   ClientACL = bareos-fd, example-fd
   FilesetACL = SelfTest, example-fileset
   WhereACL = *all*
}
```

### Read-Only Access

This example profile resource denies access to most of the commands and additionally restricts access to certain other resources like `Job (Dir)`, `Schedule (Dir)`, `Pool (Dir)`, `Storage (Dir)`, `Client (Dir)`, `Fileset (Dir)`, etc.

Users of this profile would not be able to run or restore jobs, execute volume and autochanger related operations, enable or disable resources besides other restrictions.

Profile Resource - Read-Only Access Example 1

```
Profile {
  Name = "webui-user-readonly-example-1"

  # Deny general command access
  CommandACL = !.bvfs_clear_cache, !.exit, !configure, !purge, !prune, !reload
  CommandACL = !create, !update, !delete, !disable, !enable
  CommandACL = !show, !status

  # Deny job related command access
  CommandACL = !run, !rerun, !restore, !cancel

  # Deny autochanger related command access
  CommandACL = !mount, !umount, !unmount, !export, !import, !move, !release, !automount

  # Deny media/volume related command access
  CommandACL = !add, !label, !relabel, !truncate

  # Deny SQL related command access
  CommandACL = !sqlquery, !query, !.sql

  # Deny debugging related command access
  CommandACL = !setdebug, !trace

  # Deny network related command access
  CommandACL = !setbandwidth, !setip, !resolve

  # Allow non-excluded command access
  CommandACL = *all*

  # Allow access to the following job resources
  Job ACL = backup-bareos-fd, RestoreFiles

  # Allow access to the following schedule resources
  Schedule ACL = WeeklyCycle

  # Allow access to the following catalog resources
  Catalog ACL = MyCatalog

  # Deny access to the following pool resources
  Pool ACL = !Scratch

  # Allow access to non-excluded pool resources
  Pool ACL = *all*

  # Allow access to the following storage resources
  Storage ACL = File

  # Allow access to the following client resources
  Client ACL = bareos-fd

  # Allow access to the following filset resources
  FileSet ACL = SelfTest

  # Allow access to restore to any filesystem location
  Where ACL = *all*
}
```

Alternatively the example above can be configured as following if you prefer a shorter version.

Profile Resource - Read-Only Access Example 2

```
Profile {
  Name = "webui-user-readonly-example-2"

  # Allow access to the following commands
  CommandACL = .api, .help, use, version, status
  CommandACL = list, llist
  CommandACL = .clients, .jobs, .filesets, .pools, .storages, .defaults, .schedule
  CommandACL = .bvfs_lsdirs, .bvfs_lsfiles, .bvfs_update, .bvfs_get_jobids, .bvfs_versions, .bvfs_restore

  # Allow access to the following job resources
  Job ACL = backup-bareos-fd, RestoreFiles

  # Allow access to the following schedule resources
  Schedule ACL = WeeklyCycle

  # Allow access to the following catalog resources
  Catalog ACL = MyCatalog

  # Allow access to the following  pool resources
  Pool ACL = Full, Differential, Incremental

  # Allow access to the following storage resources
  Storage ACL = File

  # Allow access to the following client resources
  Client ACL = bareos-fd

  # Allow access to the following filset resources
  FileSet ACL = SelfTest

  # Allow access to restore to any filesystem location
  Where ACL = *all*
}
```

For more details, please read [Profile Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceprofile).



## Restore

By default when running a restore in the Bareos WebUI the most recent version of all files from the available backups will be restored. You  can change this behaviour by selecting the merge strategy and specific  job selections in the fields described below. The Bareos WebUI allows  you to restore multiple files or specific file versions.



### Available restore parameters

[![../_images/bareos-webui-restore-0.png](https://docs.bareos.org/_images/bareos-webui-restore-0.png)](https://docs.bareos.org/_images/bareos-webui-restore-0.png)

Client

> A list of available backup clients.

Backup jobs

> A list of successful backup jobs available for the selected client.

Merge all client filesets

> Determines if all available backup job filesets for the selected  client should be merged into one file tree. This is helpful i.e. if  multiple backup jobs with different filesets are available for the  selected client. When you are just interested in a specific backup job,  disable merging here and make the appropriate selection of a backup job.

Merge all related jobs to last full backup of selected backup job

> By default all most recent versions of a file from your  incremental, differential and full backup jobs will be merged into the  file tree. If this behaviour is not desirable and instead the file tree  should show the contents of a particular backup job, set the value to  “No” here. Select a specific backup job afterwards to browse through the according file tree which has been backed up by that job.

Restore to client

> In case you do not want to restore to the original client, you can select an alternative client here.

Restore job

> Sometimes dedicated restore jobs may be required, which can be selected here.

Replace files on client

> Here you can change the behaviour of how and when files should be replaced on the backup client while restoring.
>
> > - always
> > - never
> > - if file being restored is older than existing file
> > - if file being restored is newer than existing file

Restore location on client

> If you like to restore all files to the original location then enter a single `/` here but keep the settings of “Replace files on client” in mind.
>
> In case you want to use another location, simply enter the path here  where you want to restore to on the selected client, for example `/tmp/bareos-restore/`.

### Restore multiple files

[![../_images/bareos-webui-restore-1.png](https://docs.bareos.org/_images/bareos-webui-restore-1.png)](https://docs.bareos.org/_images/bareos-webui-restore-1.png)

### Restore a specific file version

[![../_images/bareos-webui-restore-2.png](https://docs.bareos.org/_images/bareos-webui-restore-2.png)](https://docs.bareos.org/_images/bareos-webui-restore-2.png)

  Critical Items to Implement Before Production



We recommend you take your time before implementing a production on a Bareos backup system since Bareos is a rather complex program, and if  you make a mistake, you may suddenly find that you cannot restore your  files in case of a disaster. This is especially true if you have not  previously used a major backup product.

If you follow the instructions in this chapter, you will have covered most of the major problems that can occur. It goes without saying that  if you ever find that we have left out an important point, please inform us, so that we can document it to the benefit of everyone.



## Critical Items



The following assumes that you have installed Bareos, you more or  less understand it, you have at least worked through the tutorial or  have equivalent experience, and that you have set up a basic production  configuration. If you haven’t done the above, please do so and then come back here. The following is a sort of checklist that points with  perhaps a brief explanation of why you should do it. In most cases, you  will find the details elsewhere in the manual. The order is more or less the order you would use in setting up a production system (if you already are in  production, use the checklist anyway).

- Test your tape drive for compatibility with Bareos by using the test command of the [btape](https://docs.bareos.org/Appendix/BareosPrograms.html#btape) program.

- Test the end of tape handling of your tape drive by using the fill command in the [btape](https://docs.bareos.org/Appendix/BareosPrograms.html#btape) program.

- Do at least one restore of files. If you backup  multiple OS types (Linux, Solaris, HP, MacOS, FreeBSD, Win32, …),  restore files from each system type. The [Restoring Files](https://docs.bareos.org/TasksAndConcepts/TheRestoreCommand.html#restorechapter) chapter shows you how.

- Write a bootstrap file to a separate system for each backup job. See [`Write Bootstrap (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_WriteBootstrap) directive and more details are available in the [The Bootstrap File](https://docs.bareos.org/Appendix/TheBootstrapFile.html#bootstrapchapter) chapter. Also, the default `bareos-dir.conf` comes with a Write Bootstrap directive defined. This allows you to recover the state of your system as of the last backup.

- Backup your catalog. An example of this is found in the default bareos-dir.conf file. The backup script is installed by  default and should handle any database, though you may want to make your own local modifications. See also [Backing Up Your Bareos Database](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#backingupbareos) for more information.

- Write a bootstrap file for the catalog. An example  of this is found in the default bareos-dir.conf file. This will allow  you to quickly restore your catalog in the event it is wiped out –  otherwise it is many excruciating hours of work.

- Make a copy of the bareos-dir.conf, bareos-sd.conf, and bareos-fd.conf files that you are using on your server. Put it in a safe place (on another machine) as these files can be difficult to  reconstruct if your server dies.

- Bareos assumes all filenames are in UTF-8 format.  This is important when saving the filenames to the catalog. For Win32  machine, Bareos will automatically convert from Unicode to UTF-8, but on Unix, Linux, *BSD, and MacOS X machines, you must explicitly ensure  that your locale is set properly. Typically this means that the LANG  environment variable must end in .UTF-8. A full example is en_US.UTF-8.  The exact syntax may vary a bit from OS to OS, and exactly how you  define it will also vary.

  On most modern Win32 machines, you can edit the conf files with notepad and choose output encoding UTF-8.

## Recommended Items



Although these items may not be critical, they are recommended and will help you avoid problems.

- Read the [Getting Started with Bareos](https://docs.bareos.org/IntroductionAndTutorial/GettingStartedWithBareos.html#quickstartchapter) chapter

- After installing and experimenting with Bareos, read and work carefully through the examples in the [Tutorial](https://docs.bareos.org/IntroductionAndTutorial/Tutorial.html#tutorialchapter) chapter of this manual.

- Learn what each of the [Bareos Programs](https://docs.bareos.org/Appendix/BareosPrograms.html#section-utilities) does.

- Set up reasonable retention periods so that your catalog does not grow to be too big. See the following three chapters:

  [Automatic Volume Recycling](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html#recyclingchapter),

  [Volume Management](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html#diskchapter),

  [Automated Disk Backup](https://docs.bareos.org/TasksAndConcepts/AutomatedDiskBackup.html#poolschapter).

If you absolutely must implement a system where you write a different tape each night and take it offsite in the morning. We recommend that  you do several things:

- Write a bootstrap file of your backed up data and a bootstrap file  of your catalog backup to a external media like CDROM or USB stick, and  take that with the tape. If this is not possible, try to write those  files to another computer or offsite computer, or send them as email to a friend. If none of that is possible, at least print the bootstrap files and take that offsite with the tape. Having the bootstrap files will  make recovery much easier.
- It is better not to force Bareos to load a particular tape each day. Instead, let Bareos choose the tape. If you need to know what tape to  mount, you can print a list of recycled and appendable tapes daily, and  select any tape from that list. Bareos may propose a particular tape for use that it considers optimal, but it will accept any valid tape from  the correct pool.