## The Current State of Bareos

- Job Control

  - Network backup/restore with centralized Director.使用集中式控制器进行网络备份/恢复。

  - Internal scheduler for automatic Job execution.自动作业执行的内部调度程序。

  - Scheduling of multiple Jobs at the same time.同时调度多个作业。

  - You may run one Job at a time or multiple simultaneous Jobs (sometimes called multiplexing).您可以一次运行一个作业，也可以同时运行多个作业（有时称为多路复用）

  - Job sequencing using priorities.使用优先级进行作业排序。

  - Console interface to the Director allowing complete control. Some GUIs are also available.控制器的控制台接口，允许完全控制。一些图形用户界面也可用。

- Security

  - Verification of files previously cataloged, permitting a Tripwire like capability (system break-in detection).
  - CRAM-MD5 password authentication between each component (daemon).
  - Configurable [TLS (SSL) communications encryption](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#commencryption) between each component.
  - Configurable [Data (on Volume) encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption) on a Client by Client basis.
  - Computation of MD5 or SHA1 signatures of the file data if requested.

  验证以前编目的文件，允许类似Tripwire的功能（系统中断检测）。

  每个组件（守护进程）之间的CRAM-MD5密码验证。

  每个组件之间的可配置TLS（SSL）通信加密。

  可配置数据（在卷上）按客户机进行加密。

  如果需要，计算文件数据的MD5或SHA1签名。

- Restore Features

  - Restore of one or more files selected interactively either for the  current backup or a backup prior to a specified time and date.

  - Listing and Restoration of files using stand-alone **bls** and **bextract** tool programs. Among other things, this permits extraction of files  when Bareos and/or the catalog are not available. Note, the recommended  way to restore files is using the restore command in the Console. These  programs are designed for use as a last resort.

  - Ability to restore the catalog database rapidly by using bootstrap files (previously saved).

  - Ability to recreate the catalog database by scanning backup Volumes using the **bscan** program.

  - 在指定时间和日期之前，以交互方式还原为当前备份或备份选择的一个或多个文件。

    使用独立bls和bextract工具程序列出和恢复文件。除其他外，这允许在Bareos和/或目录不可用时提取文件。注意，恢复文件的推荐方法是使用控制台中的restore命令。这些程序是为最后一种手段而设计的。

    能够使用引导文件（以前保存的）快速还原目录数据库。

    通过使用bscan程序扫描备份卷来重新创建目录数据库的能力。

- SQL Catalog

  - Catalog database facility for remembering Volumes, Pools, Jobs, and Files backed up.目录数据库功能，用于记忆备份的卷、池、作业和文件。

  - Support for PostgreSQL, MySQL and SQLite Catalog databases.

  - User extensible queries to the PostgreSQL, MySQL and SQLite databases.

  - 

    支持PostgreSQL、MySQL和SQLite目录数据库。

    对Postgre-SQL、My-SQL和SQLite数据库的用户可扩展查询。

- Advanced Volume and Pool Management

  - Labeled Volumes, preventing accidental overwriting (at least by Bareos).

  - Any number of Jobs and Clients can be backed up to a single Volume.  That is, you can backup and restore Linux, Unix and Windows machines to  the same Volume.

  - Multi-volume saves. When a Volume is full, Bareos automatically requests the next Volume and continues the backup.

  - [Pool and Volume](https://docs.bareos.org/Configuration/Director.html#directorresourcepool) library management providing Volume flexibility (e.g. monthly, weekly, daily Volume sets, Volume sets segregated by Client, …).

  - Machine independent Volume data format. Linux, Solaris, and Windows clients can all be backed up to the same Volume if desired.

  - The Volume data format is upwards compatible so that old Volumes can always be read.

  - A flexible [message](https://docs.bareos.org/Configuration/Messages.html#messageschapter) handler including routing of messages from any daemon back to the Director and automatic email reporting.

  - Data spooling to disk during backup with subsequent write to tape  from the spooled disk files. This prevents tape “shoe shine” during  Incremental/Differential backups.

  - 标记卷，防止意外覆盖（至少由Bareos）。

    可以将任意数量的作业和客户端备份到单个卷。也就是说，您可以将Linux、Unix和Windows计算机备份和恢复到同一卷。

    多卷存储。当一个卷已满时，Bareos会自动请求下一个卷并继续备份。

    提供卷灵活性的池和卷库管理（例如，每月、每周、每日卷集、按客户端分隔的卷集…）。

    独立于机器的卷数据格式。如果需要，Linux、Solaris和Windows客户机都可以备份到同一卷。

    卷数据格式是向上兼容的，因此可以始终读取旧卷。

    一个灵活的消息处理程序，包括将消息从任何守护进程路由回控制器和自动电子邮件报告。

    备份期间数据假脱机到磁盘，随后从假脱机磁盘文件写入磁带。这可防止磁带在增量/差异备份期间“擦鞋”。

- Advanced Support for most Storage Devices

  - Autochanger support using a simple shell interface that can interface to virtually any autoloader program. A script for **mtx** is provided.

  - Support for autochanger barcodes – automatic tape labeling from barcodes.

  - Automatic support for multiple autochanger magazines either using barcodes or by reading the tapes.

  - Support for multiple drive autochangers.

  - Raw device backup/restore. Restore must be to the same device.

  - All Volume blocks contain a data checksum.

  - Migration support – move data from one Pool to another or one Volume to another.

  - 自动转换器支持使用一个简单的shell接口，可以接口到几乎任何自动加载程序。为mtx提供了一个脚本。

    支持自动转换器条形码–从条形码自动标记磁带。

    自动支持使用条形码或读取磁带的多个自动转换器库。

    支持多驱动器自动转换器。

    原始设备备份/还原。还原必须在同一设备上。

    所有卷块都包含数据校验和。

    迁移支持—将数据从一个池移动到另一个池或从一个卷移动到另一个卷。

- Multi-Operating System Support

  - Programmed to handle arbitrarily long filenames and messages.

  - Compression on a file by file basis done by the Client program if requested before network transit.

  - Saves and restores POSIX ACLs and Extended Attributes on most OSes if enabled.

  - Access control lists for Consoles that permit restricting user access to only their data.

  - Support for save/restore of files larger than 2GB.

  - Support ANSI and IBM tape labels.

  - Support for Unicode filenames (e.g. Chinese) on Win32 machines

  - Consistent backup of open files on Win32 systems using Volume Shadow Copy (VSS).

  - Support for path/filename lengths of up to 64K on Win32 machines (unlimited on Unix/Linux machines).

  - 编程处理任意长的文件名和消息。

    如果在网络传输之前请求，则客户端程序按文件进行压缩。

    如果启用，则在大多数OSE上保存和恢复POSIX ACL和扩展属性。

    允许仅限制用户访问其数据的控制台的访问控制列表。

    支持保存/恢复大于2GB的文件。

    支持ANSI和IBM磁带标签。

    支持Win32计算机上的Unicode文件名（例如中文）

    使用卷影复制（VSS）在Win32系统上一致地备份打开的文件。

    支持Win32计算机上的路径/文件名长度高达64K（Unix/Linux计算机上不限）。

- Miscellaneous各种各样的，混杂的

  - Multi-threaded implementation.多线程实现。

### 与其他备份程序相比的优势

- Bareos handles multi-volume backups.Bareos处理多卷备份。Bareos处理多卷备份。

- A full comprehensive SQL standard database of all files backed up.  This permits online viewing of files saved on any particular Volume.

- Automatic pruning of the database (removal of old records) thus simplifying database administration.

- The modular but integrated design makes Bareos very scalable.

- Bareos has a built-in Job scheduler.

- The Volume format is documented and there are simple C programs to read/write it.

- Bareos uses well defined (IANA registered) TCP/IP ports – no rpcs, no shared memory.

- Bareos installation and configuration is relatively simple compared to other comparable products.

- Aside from several GUI administrative interfaces, Bareos has a  comprehensive shell administrative interface, which allows the  administrator to use tools such as ssh to administrate any part of  Bareos from anywhere.


  一个完整的SQL标准数据库，包含所有备份的文件。这允许在线查看保存在任何特定卷上的文件。

  自动修剪数据库（删除旧记录），从而简化数据库管理。

  模块化但集成化的设计使Bareos非常可扩展。

  Bareos有一个内置的作业调度程序。

  卷格式已记录下来，并且有简单的C程序来读/写。

  Bareos使用定义良好（IANA注册）TCP/IP端口–无RPC，无共享内存。

  与其他类似产品相比，Bareos的安装和配置相对简单。

  除了几个GUI管理接口外，Bareos还有一个全面的shell管理接口，它允许管理员使用诸如ssh之类的工具从任何地方管理Bareos的任何部分。

### Current Implementation Restrictions当前实施限制

#### Multiple Catalogs多个目录

It is possible to configure the Bareos Director to use multiple  Catalogs. However, this is neither advised, nor supported. Multiple  catalogs require more management because in general you must know what  catalog contains what data, e.g. currently, all Pools are defined in  each catalog.

- Bareos can generally restore any backup made from one client to any  other client. However, if the architecture is significantly different  (i.e. 32 bit architecture to 64 bit or Win32 to Unix), some restrictions may apply (e.g. Solaris door files do not exist on other Unix/Linux  machines; there are reports that Zlib compression written with 64 bit  machines does not always read correctly on a 32 bit machine).

可以将Bareos控制器配置为使用多个目录。然而，这既不建议，也不支持。多个目录需要更多的管理，因为通常您必须知道哪个目录包含哪些数据，例如，当前，所有池都在每个目录中定义。

Bareos通常可以将一个客户机的任何备份恢复到任何其他客户机。但是，如果体系结构明显不同（即32位体系结构与64位或Win32与Unix），则可能会有一些限制（例如，其他Unix/Linux机器上不存在Solaris door文件；有报告称，使用64位机器编写的Zlib压缩在32位机器上并不总是正确读取）。

### Design Limitations or Restrictions设计限制或限制

- Names (resource names, volume names, and such) defined in Bareos  configuration files are limited to a fixed number of characters.  Currently the limit is defined as 127 characters. Note, this does not  apply to filenames, which may be arbitrarily long.

- Command line input to some of the stand alone tools – e.g. **btape**, **bconsole** is restricted to several hundred characters maximum. Normally, this is  not a restriction, except in the case of listing multiple Volume names  for programs such as **bscan**. To avoid this command line length restriction, please use a .bsr file to specify the Volume names.

- Bareos configuration files for each of the components can be any  length. However, the length of an individual line is limited to 500  characters after which it is truncated. If you need lines longer than  500 characters for directives such as ACLs where they permit a list of  names are character strings simply specify multiple short lines  repeating the directive on each line but with different list values.

- Bareos配置文件中定义的名称（资源名称、卷名等）仅限于固定数量的字符。当前限制定义为127个字符。注意，这不适用于文件名，文件名可能任意长。

  命令行输入到一些独立工具（例如btape、bconsole）最多几百个字符。通常，这不是限制，除非列出bscan等程序的多个卷名。要避免此命令行长度限制，请使用.bsr文件指定卷名。

  每个组件的Bareos配置文件可以是任意长度的。但是，一条单独的行的长度限制为500个字符，之后它被截断。如果您需要的行长度超过500个字符，例如ACL，其中允许名称列表的是字符字符串，那么只需指定多条短行，在每行重复该指令，但列表值不同。

### Items to Note注意事项



- Bareos’s Differential and Incremental *normal* backups are  based on time stamps. Consequently, if you move files into an existing  directory or move a whole directory into the backup fileset after a Full backup, those files will probably not be backed up by an Incremental  save because they will have old dates. This problem is corrected by  using [Accurate mode](https://docs.bareos.org/Configuration/Director.html#accuratemode) backups or by explicitly updating the date/time stamp on all moved files.

- In non Accurate mode, files deleted after a Full save will be  included in a restoration. This is typical for most similar backup  programs. To avoid this, use [Accurate mode](https://docs.bareos.org/Configuration/Director.html#accuratemode) backup.

- Bareos的差异备份和增量正常备份是基于时间戳的。因此，如果在完全备份后将文件移到现有目录或将整个目录移到备份文件集中，则这些文件可能不会通过增量保存进行备份，因为它们将具有旧的日期。通过使用精确的模式备份或显式更新所有移动文件上的日期/时间戳，可以纠正此问题。

  在非精确模式下，完全保存后删除的文件将包含在恢复中。这是大多数类似备份程序的典型情况。要避免这种情况，请使用精确模式备份。