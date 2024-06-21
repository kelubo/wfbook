# Percona XtraBackup

[TOC]

## 概述

Percona XtraBackup 是一个开源的热备份实用程序，适用于基于 MySQL 的服务器，可在计划的维护时段内保持数据库完全可用。

无论是 24x7 全天候高负载服务器还是低事务量服务器，Percona XtraBackup 都旨在实现无缝备份，而不会中断生产环境中服务器的性能。Percona XtraBackup（PXB）是一个 100% 开源备份解决方案，为希望从全面、响应迅速且成本灵活的 MySQL 数据库支持中受益的组织提供商业支持。

## 支持的存储引擎

Percona XtraBackup 可以备份 MySQL 8.3 服务器上的 InnoDB、XtraDB、MyISAM、MyRocks 表以及 Percona  Server for MySQL with XtraDB、Percona Server for MySQL 8.3 和 Percona XtraDB Cluster 8.3 上的数据。

An incremental  backup on the MyRocks storage engine does not determine if an earlier  full or incremental backup contains duplicate files. 
Percona XtraBackup 8.3 支持 MyRocks 存储引擎。MyRocks 存储引擎上的增量备份无法确定早期的完整备份或增量备份是否包含重复文件。Percona XtraBackup 在每次备份时都会复制所有 MyRocks 文件。

### 限制

Percona XtraBackup 8.3 不支持备份在 MySQL、Percona Server for MySQL 或 Percona XtraDB Cluster 8.3 之前版本中创建的数据库。

Percona XtraBackup （PXB）是一个 100% 开源备份解决方案，适用于所有版本的 Percona Server for MySQL 和 MySQL®，可在事务系统上执行在线非阻塞、紧密压缩、高度安全的完整备份。使用 Percona XtraBackup 在计划的维护时段内维护完全可用的应用程序。

## 安装 Percona XtraBackup

You can install Percona XtraBackup using different methods:
您可以使用不同的方法安装Percona XtraBackup：

- [Use the Percona Repositories
  使用 Percona 存储库](https://docs.percona.com/percona-xtrabackup/innovation-release/installation.html)
- [Use APT 使用 APT](https://docs.percona.com/percona-xtrabackup/innovation-release/apt-repo.html)
- [Use YUM 使用 YUM](https://docs.percona.com/percona-xtrabackup/innovation-release/yum-repo.html)
- [Use binary tarballs 使用二进制压缩包](https://docs.percona.com/percona-xtrabackup/innovation-release/binary-tarball.html)
- [Use Docker 使用 Docker](https://docs.percona.com/percona-xtrabackup/innovation-release/docker.html)

## For superior and optimized performance[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/quickstart-overview.html#for-superior-and-optimized-performance) 实现卓越和优化的性能 ¶

Percona Server for MySQL (PS) is a freely available, fully compatible,  enhanced, and open source drop-in replacement for any MySQL database. It provides superior and optimized performance, greater scalability and  availability, enhanced backups, increased visibility, and  instrumentation. Percona Server for MySQL is trusted by thousands of  enterprises to provide better performance and concurrency for their most demanding workloads.
Percona Server for MySQL （PS） 是任何 MySQL  数据库的免费可用、完全兼容、增强和开源的直接替代品。它提供了卓越和优化的性能、更高的可扩展性和可用性、增强的备份、更高的可见性和检测。Percona Server for MySQL 受到数千家企业的信赖，可为其要求最苛刻的工作负载提供更好的性能和并发性。

Install [Percona Server for MySQL](https://docs.percona.com/percona-server/innovation-release/installation.html).
安装 Percona Server for MySQL。

## For high availability[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/quickstart-overview.html#for-high-availability) 为了实现高可用性 ¶

Percona XtraDB Cluster (PXC) is a 100% open source, enterprise-grade, highly  available clustering solution for MySQL multi-master setups based on  Galera. PXC helps enterprises minimize unexpected downtime and data  loss, reduce costs, and improve performance and scalability of your  database environments supporting your critical business applications in  the most demanding public, private, and hybrid cloud environments. 
Percona XtraDB Cluster （PXC） 是一个 100% 开源、企业级、高可用性的集群解决方案，适用于基于 Galera 的 MySQL  多主站设置。PXC  可帮助企业最大限度地减少意外停机时间和数据丢失，降低成本，并提高数据库环境的性能和可扩展性，从而在要求最苛刻的公有云、私有云和混合云环境中支持关键业务应用程序。

Install [Percona XtraDB Cluster](https://docs.percona.com/percona-xtradb-cluster/8.0/install-index.html).
安装 Percona XtraDB 集群。

## For Monitoring and Management[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/quickstart-overview.html#for-monitoring-and-management) 用于监控和管理 ¶

Percona Monitoring and Management (PMM) monitors and provides actionable  performance data for MySQL variants, including Percona Server for MySQL, Percona XtraDB Cluster, Oracle MySQL Community Edition, Oracle MySQL  Enterprise Edition, and MariaDB. PMM captures metrics and data for the  InnoDB, XtraDB, and MyRocks storage engines, and has specialized  dashboards for specific engine details.
Percona 监控和管理 （PMM） 监控 MySQL 变体并提供可操作的性能数据，包括 Percona Server for MySQL、Percona  XtraDB Cluster、Oracle MySQL Community Edition、Oracle MySQL Enterprise  Edition 和 MariaDB。PMM 捕获 InnoDB、XtraDB 和 MyRocks  存储引擎的指标和数据，并为特定引擎详细信息提供专门的仪表板。

[Install PMM and connect your MySQL instances to it](https://docs.percona.com/percona-monitoring-and-management/get-started/index.html).
安装 PMM 并将您的 MySQL 实例连接到它。

# 关于Percona XtraBackup ¶

Percona XtraBackup is the world’s only open source, free MySQL hot backup software that performs non-blocking backups for InnoDB and XtraDB databases. 
Percona XtraBackup是世界上唯一的开源免费MySQL热备份软件，可对InnoDB和XtraDB数据库进行无阻塞备份。

Percona XtraBackup has the following benefits:
Percona XtraBackup具有以下优点：

- Complete a backup quickly and reliably
  快速可靠地完成备份
- Process transactions uninterrupted during a backup
  在备份期间不间断地处理事务
- Save on disk space and network bandwidth
  节省磁盘空间和网络带宽
- Verify backup automatically
  自动验证备份

Percona XtraBackup makes hot backups for Percona Server for MySQL and  MySQL-compatible servers. XtraBackup takes streaming, compressed, and  incremental server backups, and supports encryption.
Percona XtraBackup为Percona Server for MySQL和MySQL兼容服务器进行热备份。XtraBackup支持流式备份、压缩备份和增量服务器备份，并支持加密。

Percona’s enterprise-grade commercial [MySQL Support](http://www.percona.com/mysql-support/) contracts include support for Percona XtraBackup. We recommend support for critical production deployments.
Percona的企业级商业MySQL支持合同包括对Percona XtraBackup的支持。建议支持关键生产部署。

## Supported storage engines[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/about-xtrabackup.html#supported-storage-engines) 支持的存储引擎 ¶

Percona XtraBackup can back up data from InnoDB, XtraDB, MyISAM, and MyRocks tables on MySQL 8.3 servers as well as Percona Server for MySQL 8.3.
Percona XtraBackup可以备份MySQL 8.3服务器以及Percona Server for MySQL 8.3上的InnoDB、XtraDB、MyISAM和MyRocks表中的数据。

Percona XtraBackup supports the MyRocks storage engine. Percona XtraBackup  copies all MyRocks files each time it takes a backup. An incremental  backup on the MyRocks storage engine does not determine if an earlier  full or incremental backup contains the same files.
Percona XtraBackup支持MyRocks存储引擎。Percona XtraBackup在每次备份时都会复制所有MyRocks文件。MyRocks 存储引擎上的增量备份无法确定早期的完整备份或增量备份是否包含相同的文件。

# Percona XtraBackup features[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/features.html#percona-xtrabackup-features) Percona XtraBackup 功能 ¶

The following is a short list of the Percona XtraBackup features:
以下是Percona XtraBackup功能的简短列表：

- Creates hot InnoDB backups without pausing your database
  在不暂停数据库的情况下创建热 InnoDB 备份
- Makes incremental backups of MySQL
  对MySQL进行增量备份
- Streams compressed MySQL backups to another server
  将压缩的MySQL备份流式传输到另一台服务器
- Moves tables between MySQL servers on-line
  在线在MySQL服务器之间移动表
- Creates new MySQL replication replicas easily
  轻松创建新的 MySQL 复制副本
- Backs up MySQL without adding load to the server
  在不增加服务器负载的情况下备份 MySQL
- Performs throttling based on the number of IO operations per second
  根据每秒 IO 操作数执行限制
- Exports individual tables from a full InnoDB backup
  从完整的 InnoDB 备份中导出单个表

Percona XtraBackup automatically uses backup locks, a lightweight alternative to `FLUSH TABLES WITH READ LOCK` available in Percona Server, to copy non-InnoDB data. This operation avoids blocking DML queries that modify InnoDB tables.
Percona XtraBackup自动使用备份锁（Percona Server中 `FLUSH TABLES WITH READ LOCK` 提供的轻量级替代方案）来复制非InnoDB数据。此操作可避免阻止修改 InnoDB 表的 DML 查询。

See also 另请参阅

[How Percona XtraBackup works
Percona XtraBackup的工作原理](https://docs.percona.com/percona-xtrabackup/innovation-release/how-xtrabackup-works.html)

# Limitations[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/limitations.html#limitations) 限制 ¶

Percona XtraBackup 8.3 does not support making backups of databases created in versions prior to 8.3 of MySQL, Percona Server for MySQL or Percona XtraDB Cluster.
Percona XtraBackup 8.3 不支持备份在 MySQL、Percona Server for MySQL 或 Percona XtraDB Cluster 8.3 之前的版本中创建的数据库。

### Additional information[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/limitations.html#additional-information) 附加信息 ¶

The InnoDB tables are locked while copying non-InnoDB data.
InnoDB 表在复制非 InnoDB 数据时被锁定。

# Percona XtraBackup的工作原理 ¶

Percona XtraBackup is based on InnoDB’s crash-recovery functionality. It copies your InnoDB data files, which results in data that is internally inconsistent; but then it performs crash recovery on the files to make them a consistent, usable database again.
Percona XtraBackup基于InnoDB的崩溃恢复功能。它会复制您的 InnoDB 数据文件，从而导致数据内部不一致;但随后它会对文件执行崩溃恢复，使它们再次成为一致、可用的数据库。

This works because InnoDB maintains a redo log, also called the transaction log. This contains a record of every change to InnoDB data. When InnoDB starts, it inspects the data files and the transaction log, and performs two steps. It applies committed transaction log entries to the data files, and it performs an undo operation on any transactions that modified data but did not commit.
这之所以有效，是因为 InnoDB 维护重做日志，也称为事务日志。这包含对 InnoDB 数据的每次更改的记录。当 InnoDB  启动时，它会检查数据文件和事务日志，并执行两个步骤。它将已提交的事务日志条目应用于数据文件，并对修改数据但未提交的任何事务执行撤消操作。

The `--register-redo-log-consumer` parameter is disabled by default. When enabled, this parameter lets  Percona XtraBackup register as a redo log consumer at the start of the  backup. The server does not remove a redo log that Percona XtraBackup  (the consumer) has not yet copied. The consumer reads the redo log and  manually advances the log sequence number (LSN). The server blocks the  writes during the process. Based on the redo log consumption, the server determines when it can purge the log.  
默认情况下，该 `--register-redo-log-consumer` 参数处于禁用状态。启用后，此参数允许 Percona XtraBackup 在备份开始时注册为重做日志使用者。服务器不会删除 Percona  XtraBackup（使用者）尚未复制的重做日志。使用者读取重做日志并手动推进日志序列号  （LSN）。服务器在此过程中阻止写入。根据重做日志消耗量，服务器确定何时可以清除日志。

Percona XtraBackup remembers the LSN when it starts, and then copies the data  files. The operation takes time, and the files may change, then LSN  reflects the state of the database at different points in time. Percona  XtraBackup also runs a background process that watches the transaction  log files, and copies any changes. Percona XtraBackup does this  continually. The transaction logs are written in a round-robin fashion,  and can be reused.
Percona XtraBackup在LSN启动时会记住LSN，然后复制数据文件。该操作需要时间，并且文件可能会更改，然后 LSN  会反映数据库在不同时间点的状态。Percona XtraBackup 还运行一个后台进程，用于监视事务日志文件并复制任何更改。Percona  XtraBackup会持续执行此操作。事务日志以循环方式写入，可以重复使用。

Percona XtraBackup uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html)
Percona XtraBackup使用备份锁

where available as a lightweight alternative to `FLUSH TABLES WITH READ LOCK`. MySQL 8.3 allows acquiring an instance level backup lock via the `LOCK INSTANCE FOR BACKUP` statement.
如果可作为 `FLUSH TABLES WITH READ LOCK` .MySQL 8.3 允许通过 `LOCK INSTANCE FOR BACKUP` 语句获取实例级备份锁。

Locking is only done for MyISAM and other non-InnoDB tables after Percona XtraBackup finishes backing up all InnoDB/XtraDB data and logs. Percona XtraBackup uses this automatically to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
只有在Percona XtraBackup完成所有InnoDB/XtraDB数据和日志的备份后，才会对MyISAM和其他非InnoDB表进行锁定。Percona  XtraBackup会自动使用它来复制非InnoDB数据，以避免阻止修改InnoDB表的DML查询。

Important 重要

The `BACKUP_ADMIN` privilege is required to query the  `performance_schema_log_status` for either `LOCK  INSTANCE FOR BACKUP` or `LOCK TABLES FOR BACKUP`.
查询 `LOCK  INSTANCE FOR BACKUP` 或 `LOCK TABLES FOR BACKUP` 需要该 `BACKUP_ADMIN` 权限 `performance_schema_log_status` 。

xtrabackup tries to avoid backup locks and `FLUSH TABLES WITH READ LOCK` when the instance contains only InnoDB tables. In this case, xtrabackup obtains binary log coordinates from `performance_schema.log_status`. `FLUSH TABLES WITH READ LOCK` is still required in MySQL 8.3 when xtrabackup is started with the `--slave-info`. The `log_status` table in Percona Server for MySQL 8.3 is extended to include the relay log coordinates, so no locks are needed even with the `--slave-info` option.
xtrabackup 会尝试避免备份锁定，并且 `FLUSH TABLES WITH READ LOCK` 当实例仅包含 InnoDB 表时。在这种情况下，xtrabackup 从 `performance_schema.log_status` 中获取二进制日志坐标。 `FLUSH TABLES WITH READ LOCK` 在 MySQL 8.3 中，当 xtrabackup 使用 `--slave-info` .Percona Server for MySQL 8.3 中的 `log_status` 表已扩展为包含中继日志坐标，因此即使使用 `--slave-info` 该选项也不需要锁。

See also 另请参阅

[MySQL Documentation: LOCK INSTANCE FOR BACKUP
MySQL 文档：锁定备份实例](https://dev.mysql.com/doc/refman/8.3/en/lock-instance-for-backup.html)

When backup locks are supported by the server, xtrabackup first copies InnoDB data, runs the `LOCK TABLES FOR BACKUP` and then copies the MyISAM tables. Once this is done, the backup of the files will begin. It will backup .frm, .MRG, .MYD, .MYI, .CSM, .CSV, `.sdi` and `.par` files.
当服务器支持备份锁时，xtrabackup 首先复制 InnoDB 数据，运行 `LOCK TABLES FOR BACKUP` MyISAM 表，然后复制 MyISAM 表。完成此操作后，将开始备份文件。它将备份 .frm、.磁共振成像（MRG）、.MYD， .MYI、.CSM、.CSV `.sdi` 和 `.par` 文件。

After that xtrabackup will use `LOCK BINLOG FOR BACKUP` to block all operations that might change either binary log position or `Exec_Master_Log_Pos` or `Exec_Gtid_Set` (i.e. source binary log coordinates corresponding to the current SQL thread state on a replication replica) as reported by `SHOW MASTER/SLAVE STATUS`. xtrabackup will then finish copying the REDO log files and fetch the binary log coordinates. After this is completed xtrabackup will unlock the binary log and tables.
之后，xtrabackup 将用于 `LOCK BINLOG FOR BACKUP` 阻止所有可能更改二进制日志位置或 `Exec_Master_Log_Pos` or `Exec_Gtid_Set` 的操作（即与复制副本上的当前 SQL 线程状态相对应的源二进制日志坐标），如 . `SHOW MASTER/SLAVE STATUS` 然后，xtrabackup 将完成复制 REDO 日志文件并获取二进制日志坐标。完成此操作后，xtrabackup 将解锁二进制日志和表。

Finally, the binary log position will be printed to `STDERR` and xtrabackup will exit returning 0 if all went OK.
最后，二进制日志位置将被打印到 `STDERR` 如果一切正常，xtrabackup 将退出返回 0。

Note that the `STDERR` of xtrabackup is not written in any file. You will have to redirect it to a file, for example, `xtrabackup OPTIONS 2> backupout.log`.
请注意， `STDERR` xtrabackup 不会写入任何文件中。您必须将其重定向到文件，例如 `xtrabackup OPTIONS 2> backupout.log` .

It will also create the following files in the directory of the backup.
它还将在备份目录中创建以下文件。

During the `prepare` phase, Percona XtraBackup performs crash recovery against the copied data files, using the copied transaction log file. After this is done, the database is ready to restore and use.
在此 `prepare` 阶段，Percona XtraBackup使用复制的事务日志文件对复制的数据文件执行崩溃恢复。完成此操作后，数据库即可还原和使用。

The backed-up MyISAM and InnoDB tables will be eventually consistent with each other, because after the prepare (recovery) process, InnoDB’s data is rolled forward to the point at which the backup completed, not rolled back to the point at which it started. This point in time matches where the `FLUSH TABLES WITH READ LOCK` was taken, so the MyISAM data and the prepared InnoDB data are in sync.
备份的 MyISAM 和 InnoDB 表最终将彼此一致，因为在准备（恢复）过程之后，InnoDB 的数据将前滚到备份完成的时间点，而不是回滚到备份开始的时间点。此时间点与获取位置 `FLUSH TABLES WITH READ LOCK` 匹配，因此 MyISAM 数据和准备好的 InnoDB 数据是同步的。

The xtrabackup offers many features not mentioned in the preceding explanation. The functionality of each tool is explained in more detail further in this manual. In brief, though, the tools enable you to do operations such as streaming and incremental backups with various combinations of copying the data files, copying the log files, and applying the logs to the data.
xtrabackup提供了许多前面解释中未提及的功能。本手册将进一步详细介绍每个工具的功能。简而言之，这些工具使您能够执行流式备份和增量备份等操作，并结合复制数据文件、复制日志文件和将日志应用于数据的各种组合。

## Restoring a backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/how-xtrabackup-works.html#restoring-a-backup) 恢复备份 ¶

To restore a backup with xtrabackup you can use the `--copy-back` or `--move-back` options.
要使用 xtrabackup 还原备份，您可以使用 `--copy-back` 或 `--move-back` 选项。

xtrabackup will read from the `my.cnf` the variables datadir, innodb_data_home_dir, innodb_data_file_path, innodb_log_group_home_dir and check that the directories exist.
XtraBackup 将从变量 datadir、innodb_data_home_dir、innodb_data_file_path innodb_log_group_home_dir 中读取 `my.cnf` ，并检查目录是否存在。

It will copy the MyISAM tables, indexes, etc. (.MRG, .MYD, .MYI, .CSM, .CSV, `.sdi`, and `par` files) first, InnoDB tables and indexes next and the log files at last. It will preserve file’s attributes when copying them, you may have to change the files’ ownership to `mysql` before starting the database server, as they will be owned by the user who created the backup.
它将复制 MyISAM 表、索引等。磁共振成像（MRG）、.MYD， .MYI、.CSM、.CSV、 `.sdi` 和 `par` files），其次是 InnoDB 表和索引，最后是日志文件。它将在复制文件时保留文件的属性，您可能需要 `mysql` 在启动数据库服务器之前更改文件的所有权，因为它们将由创建备份的用户拥有。

Alternatively, the `--move-back` option may be used to restore a backup. This option is similar to `--copy-back` with the only difference that instead of copying files it moves them to their target locations. As this option removes backup files, it must be used with caution. It is useful in cases when there is not enough free disk space to hold both data files and their backup copies.
或者，该 `--move-back` 选项可用于还原备份。此选项与 `--copy-back` 此选项类似，唯一的区别是不是复制文件，而是将它们移动到目标位置。由于此选项会删除备份文件，因此必须谨慎使用。在没有足够的可用磁盘空间来保存数据文件及其备份副本的情况下，它很有用。

# Understand version numbers[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-version-numbers.html#understand-version-numbers) 了解版本号 ¶

A version number identifies the innovtion product release. The product  contains the latest features, improvements, and bug fixes at the time of that release.
版本号标识创新产品版本。该产品包含该版本发布时的最新功能、改进和错误修复。

| 8.3.0                 | -1                               |
| --------------------- | -------------------------------- |
| Base version 基本版本 | Minor build version 次要构建版本 |

Percona uses semantic version numbering, which follows the pattern of base  version and build version. Percona assigns unique, non-negative integers in increasing order for each version release. The version number  combines the base [MySQL 8.3](https://dev.mysql.com/doc/relnotes/mysql/8.3/en/) version number and the minor build version.
Percona 使用语义版本编号，遵循基本版本和构建版本的模式。Percona 为每个版本版本按递增顺序分配唯一的非负整数。版本号结合了基本 MySQL 8.3 版本号和次要构建版本。

The version numbers for Percona XtraBackup 8.3.0-1 define the following information:
Percona XtraBackup 8.3.0-1 的版本号定义了以下信息：

- Base version - the leftmost numbers indicate the [MySQL 8.3](https://dev.mysql.com/doc/relnotes/mysql/8.3/en/) version used as a base. An increase in base version resets the minor build version to 0.  
  基本版本 - 最左边的数字表示用作基础的 MySQL 8.3 版本。基本版本的增加会将次要内部版本重置为 0。
- Minor build version - an internal number that denotes the version of the  software. A build version increases by one each time the Percona  XtraBackup is released.
  次要版本 - 表示软件版本的内部编号。每次发布Percona XtraBackup时，构建版本都会增加一个。

# LRU dump backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/lru-dump-backup.html#lru-dump-backup) LRU 转储备份 ¶

Percona XtraBackup includes a saved buffer pool dump into a backup to enable reducing the warm up time. It restores the buffer pool state from `ib_buffer_pool` file after restart. *Percona XtraBackup* discovers `ib_buffer_pool` and backs it up automatically.
Percona XtraBackup将保存的缓冲池转储到备份中，以减少预热时间。重新启动后，它会从 `ib_buffer_pool` 文件中恢复缓冲池状态。Percona XtraBackup会 `ib_buffer_pool` 自动发现并备份它。

![image](https://docs.percona.com/percona-xtrabackup/innovation-release/_static/lru_dump.png)

If the buffer restore option is enabled in `my.cnf`, buffer pool will be in the warm state after backup is restored.
如果在 中 `my.cnf` 启用了缓冲区还原选项，则在还原备份后，缓冲池将处于热状态。

Find the information on how to save and restore the buffer pool dump in [Saving and Restoring the Buffer Pool State](https://dev.mysql.com/doc/refman/8.3/en/innodb-preload-buffer-pool.html).
在保存和还原缓冲池状态中查找有关如何保存和还原缓冲池转储的信息。

# Throttling backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/throttling-backups.html#throttling-backups) 限制备份 ¶

Although *xtrabackup* does not block your database’s operation, any backup can add load to the system being backed up. On systems that do not have much spare I/O capacity, it might be helpful to throttle the rate at which *xtrabackup* reads and writes data. You can do this with the `--throttle` option. This option limits the number of chunks copied per second. The chunk +size is *10 MB*.
尽管 xtrabackup 不会阻止数据库的运行，但任何备份都会增加正在备份的系统的负载。在没有太多备用 I/O 容量的系统上，限制 xtrabackup 读取和写入数据的速率可能会有所帮助。您可以使用该 `--throttle` 选项执行此操作。此选项限制每秒复制的块数。块 +size 为 10 MB。

The image below shows how throttling works when `--throttle` is set to `1`.
下图显示了设置为 `--throttle` `1` 时限制的工作原理。

![how throttling works](https://docs.percona.com/percona-xtrabackup/innovation-release/_static/throttle.png)

When specified with the `--backup` option, this option limits the number of pairs of read-and-write operations per second that *xtrabackup* will perform. If you are creating an incremental backup, then the limit is the number of read I/O operations per second.
当使用该 `--backup` 选项指定时，此选项将限制 xtrabackup 每秒将执行的读写操作对数。如果要创建增量备份，则限制为每秒读取 I/O 操作数。

By default, there is no throttling, and *xtrabackup* reads and writes data as quickly as it can. If you set too strict of a  limit on the IOPS, the backup might be so slow that it will never catch  up with the transaction logs that InnoDB is writing, so the backup might never complete.
默认情况下，没有限制，xtrabackup 会尽可能快地读取和写入数据。如果对 IOPS 设置的限制过于严格，备份可能会非常慢，以至于永远无法赶上 InnoDB 正在写入的事务日志，因此备份可能永远不会完成。

# Store backup history on the server[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/store-backup-history.html#store-backup-history-on-the-server) 在服务器上存储备份历史记录 ¶

*Percona XtraBackup* supports storing the backups history on the server. Storing backup history on the server was implemented to provide users with additional information about backups that are being taken. Backup history information will be stored in the `PERCONA_SCHEMA.XTRABACKUP_HISTORY` table.
Percona XtraBackup支持在服务器上存储备份历史记录。在服务器上存储备份历史记录是为了向用户提供有关正在执行的备份的其他信息。备份历史记录信息将存储在表中 `PERCONA_SCHEMA.XTRABACKUP_HISTORY` 。

To use this feature the following options are available:
要使用此功能，可以使用以下选项：

- `--history` = : This option enables the history feature and allows the user to specify a backup series name that will be placed within the history record.
   `--history` = ：此选项启用历史记录功能，并允许用户指定将放置在历史记录中的备份系列名称。
- `--incremental-history-name` = : This option allows an incremental backup to be made based on a specific history series by name. *xtrabackup* will search the history table looking for the most recent (highest `to_lsn`) backup in the series and take the `to_lsn` value to use as it’s starting lsn. This is mutually exclusive with `--incremental-history-uuid`, `--incremental-basedir` and `--incremental-lsn` options. If no valid LSN can be found (no series by that name) *xtrabackup* will return with an error.
   `--incremental-history-name` = ：此选项允许按名称根据特定历史记录系列进行增量备份。XtraBackup 将搜索历史记录表，查找该系列中最新（最高 `to_lsn` ）的备份，并获取要用作启动 LSN 的 `to_lsn` 值。这与 `--incremental-history-uuid` 和 `--incremental-basedir` `--incremental-lsn` 选项是互斥的。如果找不到有效的 LSN（没有该名称的系列），xtrabackup 将返回并显示错误。
- `--incremental-history-uuid` = : Allows an incremental backup to be made based on a specific history record identified by UUID. *xtrabackup* will search the history table looking for the record matching UUID and take the `to_lsn` value to use as it’s starting LSN. This options is mutually exclusive with `--incremental-basedir`, `--incremental-lsn` and `--incremental-history-name` options. If no valid LSN can be found (no record by that UUID or missing `to_lsn`), *xtrabackup* will return with an error.
   `--incremental-history-uuid` = ：允许根据 UUID 标识的特定历史记录进行增量备份。xtrabackup 将搜索历史记录表，查找与 UUID 匹配的记录，并获取要在启动 LSN 时使用的 `to_lsn` 值。此选项与 `--incremental-basedir` 和 `--incremental-lsn` `--incremental-history-name` 选项互斥。如果找不到有效的 LSN（该 UUID 没有记录或缺失 `to_lsn` ），xtrabackup 将返回错误。

Note 注意

Backup that’s currently being performed will **NOT** exist in the xtrabackup_history table within the resulting backup set as the record will not be added to that table until after the backup has been taken.
当前正在执行的备份将不存在于生成的备份集中的xtrabackup_history表中，因为在执行备份之前不会将记录添加到该表中。

If you want access to backup history outside of your backup set in the case of some catastrophic event, you will need to either perform a `mysqldump`, partial backup or `SELECT` * on the history table after *xtrabackup* completes and store the results with you backup set.
如果要在发生灾难性事件时访问备份集之外的备份历史记录，则需要在 xtrabackup 完成后对历史记录表执行 `mysqldump` 、部分备份或 `SELECT` * 并将结果存储在备份集中。

For the necessary privileges, see Permissions and Privileges Needed.
有关必要的权限，请参阅所需的权限和特权。

### PERCONA_SCHEMA.XTRABACKUP_HISTORY table[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/store-backup-history.html#percona_schemaxtrabackup_history-table) PERCONA_SCHEMA。XTRABACKUP_HISTORY表 ¶

This table contains the information about the previous server backups. Information about the backups will only be written if the backup was taken with `--history` option.
此表包含有关以前的服务器备份的信息。仅当备份是使用 `--history` 选项进行备份时，才会写入有关备份的信息。

| Column Name 列名称 | Description 描述                                             |
| ------------------ | ------------------------------------------------------------ |
| uuid               | Unique backup id 唯一备份 ID                                 |
| name 名字          | User provided name of backup series. There may be multiple entries with the  same name used to identify related backups in a series. 用户提供的备份系列名称。可能有多个具有相同名称的条目用于标识系列中的相关备份。 |
| tool_name          | Name of tool used to take backup 用于备份的工具的名称        |
| tool_command       | Exact command line given to the tool with –password and –encryption_key obfuscated 使用 –password 和 –encryption_key 混淆提供给工具的确切命令行 |
| tool_version       | Version of tool used to take backup 用于备份的工具版本       |
| ibbackup_version   | Version of the xtrabackup binary used to take backup 用于备份的 xtrabackup 二进制文件的版本 |
| server_version     | Server version on which backup was taken 进行备份的服务器版本 |
| start_time         | Time at the start of the backup 备份开始时的时间             |
| end_time           | Time at the end of the backup 备份结束时的时间               |
| lock_time          | Amount of time, in seconds, spent calling and holding locks for `FLUSH TABLES WITH READ LOCK` 通话和按住锁所花费的时间（以秒为单位） `FLUSH TABLES WITH READ LOCK` |
| binlog_pos         | Binlog file and position at end of `FLUSH TABLES WITH READ LOCK` 二进制日志文件和末尾 `FLUSH TABLES WITH READ LOCK` 的位置 |
| innodb_from_lsn    | LSN at beginning of backup which can be used to determine prior backups 备份开始时的 LSN，可用于确定以前的备份 |
| innodb_to_lsn      | LSN at end of backup which can be used as the starting lsn for the next incremental 备份结束时的 LSN，可用作下一个增量的起始 LSN |
| partial 部分       | Is this a partial backup, if `N` that means that it’s the full backup 这是部分备份吗，如果 `N` 这意味着它是完整备份 |
| incremental 增量   | Is this an incremental backup 这是增量备份吗                 |
| format 格式        | Description of result format (`xbstream`) 结果格式说明 （ `xbstream` ） |
| compressed 压缩    | Is this a compressed backup 这是压缩备份吗                   |
| encrypted 加密     | Is this an encrypted backup 这是加密备份吗                   |

### Limitations[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/store-backup-history.html#limitations) 限制 ¶

- `--history` option must be specified only on the command line and not within a configuration file in order to be effective.
   `--history` 选项必须仅在命令行上指定，而不能在配置文件中指定才能生效。
- `--incremental-history-name` and `--incremental-history-uuid` options must be specified only on the command line and not within a configuration file in order to be effective.
   `--incremental-history-name` 并且 `--incremental-history-uuid` 必须仅在命令行上指定选项，而不能在配置文件中指定选项才能生效。

# Dictionary cache[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/dictionary-cache.html#dictionary-cache) 字典缓存 ¶

Percona XtraBackup is based on how [`crash recovery`] works. Percona XtraBackup copies the InnoDB data files, which results in data that is internally inconsistent; then the `prepare` phase performs crash recovery on the files to make a consistent, usable database again.
Percona XtraBackup基于[ `crash recovery` ]的工作原理。Percona XtraBackup复制InnoDB数据文件，导致数据内部不一致;然后，该 `prepare` 阶段对文件执行崩溃恢复，以再次创建一致、可用的数据库。

The `--prepare` phase has the following operations:
该 `--prepare` 阶段具有以下操作：

- Applies the redo log
  应用重做日志
- Applies the undo log
  应用撤消日志

As a physical operation, the changes from the redo log modifications are  applied to a page. In the redo log operation, there is no concept of row or transaction. The redo apply operation does not make the database  consistent with a transaction. An uncommitted transaction can be flushed or written to the redo log by the server. Percona XtraBackup applies  changes recorded in the redo log.
作为物理操作，重做日志修改中的更改将应用于页面。在重做日志操作中，没有行或事务的概念。重做应用操作不会使数据库与事务一致。服务器可以刷新未提交的事务，或将其写入重做日志。Percona XtraBackup应用重做日志中记录的更改。

Percona XtraBackup physically modifies a specific offset of a page within a tablespace (IBD file) when applying a redo log. 
Percona XtraBackup在应用重做日志时，会物理修改表空间（IBD文件）中页面的特定偏移量。

As a logical operation, Percona XtraBackup applies the undo log on a  specific row. When the redo log completes, XtraBackup uses the undo log  to roll back changes from uncommitted transactions during the backup.
作为逻辑操作，Percona XtraBackup 在特定行上应用撤消日志。重做日志完成后，XtraBackup 使用撤消日志在备份期间回滚未提交事务中的更改。

## Undo log[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/dictionary-cache.html#undo-log) 撤消日志 ¶

There are two types of undo log records:
有两种类型的撤消日志记录：

- INSERT 插入
- UPDATE 更新

An undo log record contains a `table_id`. Percona XtraBackup uses this `table_id` to find the table definition, and then uses that information to parse  the records on an index page. The transaction rollback reads the undo  log records and applies the changes. 
撤消日志记录包含 `table_id` .Percona XtraBackup使用它 `table_id` 来查找表定义，然后使用该信息来解析索引页上的记录。事务回滚读取撤消日志记录并应用更改。

After initializing the data dictionary engine and the data dictionary cache, the storage engine can request the `table_id` and uses this ID to fetch the table schema. An index search tuple (key) is created from the table schema and key fields from the undo log  record. The server finds the record using the search tuple (key) and  performs the undo operation.
初始化数据字典引擎和数据字典缓存后，存储引擎可以请求 `table_id` 并使用此 ID 获取表架构。索引搜索元组（键）是从表架构和撤消日志记录中的键字段创建的。服务器使用搜索元组（键）查找记录并执行撤消操作。

For example, InnoDB uses the `table_id` (also known as the `se_private_id`) for a table definition. Percona XtraBackup does not behave like a  server and does not have access to the data dictionary. XtraBackup  initializes the InnoDB engine and uses the `InnoDB table object` (`dict_table_t`) when needed. XtraBackup relies on Serialized Dictionary Information  (SDI) that is stored in the tablespace. SDI is a JSON representation of a table.
例如，InnoDB 使用 `table_id` （也称为 `se_private_id` ）作为表定义。Percona XtraBackup的行为不像服务器，也无法访问数据字典。XtraBackup初始化InnoDB引擎，并在需要时使用 `InnoDB table object` （ `dict_table_t` ）。XtraBackup依赖于存储在表空间中的序列化字典信息（SDI）。SDI 是表的 JSON 表示形式。

In Percona XtraBackup 8.3.0-1, tables are loaded as `evictable`. XtraBackup scans the B-tree index of the data dictionary tables `mysql.indexes` and `mysql.index_partitions` to establish a relationship between the `table_id` and the `tablespace(space_id)`. XtraBackup uses this relationship during transaction rollback.  XtraBackup does not load user tables unless there is a transaction  rollback on them.
在 Percona XtraBackup 8.3.0-1 中，表加载为 `evictable` .XtraBackup 扫描数据字典表 `mysql.indexes` 的 B 树索引，并在 `mysql.index_partitions` `table_id` 和 `tablespace(space_id)` 之间建立关系。XtraBackup在事务回滚期间使用此关系。XtraBackup不会加载用户表，除非用户表上有事务回滚。

A background thread or a Percona XtraBackup main thread handles the cache eviction when the cache size limit is reached.
当达到缓存大小限制时，后台线程或 Percona XtraBackup 主线程处理缓存逐出。

This  design provides the following benefits during the `--prepare` phase:
此设计在 `--prepare` 阶段中具有以下优势：

- Uses less memory 使用更少的内存
- Uses less IO 使用更少的 IO
- Improves the time taken in the `--prepare` phase
  缩短 `--prepare` 相位所花费的时间
- Completes successfully, even if the `--prepare` phase has a huge number of tables
  成功完成，即使该 `--prepare` 阶段有大量表
- Completes the Percona XtraDB Cluster SST process faster
  更快地完成 Percona XtraDB 集群 SST 过程

# Point-in-time recovery[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/point-in-time-recovery.html#point-in-time-recovery) 时间点恢复 ¶

Recovering up to particular moment in database’s history can be done with xtrabackup and the binary logs of the server.
可以使用xtrabackup和服务器的二进制日志来恢复数据库历史记录中的特定时刻。

Note that the binary log contains the operations that modified the database from a point in the past. You need a full datadir as a base, and then you can apply a series of operations from the binary log to make the data match what it was at the point in time you want.
请注意，二进制日志包含从过去的某个时间点修改数据库的操作。您需要一个完整的 datadir 作为基础，然后可以应用二进制日志中的一系列操作，使数据与您想要的时间点相匹配。

```
$ xtrabackup --backup --target-dir=/path/to/backup
$ xtrabackup --prepare --target-dir=/path/to/backup
```

For more details on these procedures, see Creating a backup and Preparing a backup.
有关这些过程的更多详细信息，请参阅创建备份和准备备份。

Now, suppose that some time has passed, and you want to restore the database to a certain point in the past, having in mind that there is the constraint of the point where the snapshot was taken.
现在，假设已经过去了一段时间，并且您希望将数据库还原到过去的某个时间点，同时牢记快照拍摄点的约束。

To find out what is the situation of binary logging in the server, execute the following queries:
若要了解服务器中二进制日志记录的情况，请执行以下查询：

```
mysql> SHOW BINARY LOGS;
```

<details class="example" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" open="">
<summary data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50"><pre><span></span><code>+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |       126 |
| mysql-bin.000002 |      1306 |
| mysql-bin.000003 |       126 |
| mysql-bin.000004 |       497 |
+------------------+-----------+
</code></pre></div>
</details>

and

```
mysql> SHOW MASTER STATUS;
```

<details class="example" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" open="">
<summary data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50"><pre><span></span><code>+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000004 |      497 |              |                  |
+------------------+----------+--------------+------------------+
</code></pre></div>
</details>

The first query will tell you which files contain the binary log and the second one which file is currently being used to record changes, and the current position within it. Those files are stored usually in the datadir (unless other location is specified when the server is started with the `--log-bin=` option).
第一个查询将告诉您哪些文件包含二进制日志，第二个查询将告诉您当前用于记录更改的文件以及其中的当前位置。这些文件通常存储在 datadir 中（除非在使用该 `--log-bin=` 选项启动服务器时指定了其他位置）。

To find out the position of the snapshot taken, see the `xtrabackup_binlog_info` at the backup’s directory:
要找出拍摄的快照的位置，请参阅备份目录： `xtrabackup_binlog_info` 

```
$ cat /path/to/backup/xtrabackup_binlog_info
```

<details class="example" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" open="">
<summary data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="3561fb9f-e647-4e31-8d52-42aebfa12c50"><pre><span></span><code>mysql-bin.000003      57
</code></pre></div>
</details>

This will tell you which file was used at moment of the backup for the binary log and its position. That position will be the effective one when you restore the backup:
这将告诉您在二进制日志备份时使用了哪个文件及其位置。当您还原备份时，该位置将是有效的位置：

```
$ xtrabackup --copy-back --target-dir=/path/to/backup
```

As the restoration will not affect the binary log files (you may need to adjust file permissions, see Restoring a Backup), the next step is extracting the queries from the binary log with mysqlbinlog starting from the position of the snapshot and redirecting it to a file
由于恢复不会影响二进制日志文件（您可能需要调整文件权限，请参阅恢复备份），因此下一步是从二进制日志中提取查询，mysqlbinlog 从快照的位置开始并将其重定向到文件

```
$ mysqlbinlog /path/to/datadir/mysql-bin.000003 /path/to/datadir/mysql-bin.000004 \
    --start-position=57 > mybinlog.sql
```

Note that if you have multiple files for the binary log, as in the example, you have to extract the queries with one process, as shown above.
请注意，如果二进制日志有多个文件（如示例中所示），则必须使用一个进程提取查询，如上所示。

Inspect the file with the queries to determine which position or date corresponds to the point-in-time wanted. Once determined, pipe it to the server. Assuming the point is `11-12-25 01:00:00`:
使用查询检查文件，以确定哪个位置或日期对应于所需的时间点。确定后，通过管道将其发送到服务器。假设要点是 `11-12-25 01:00:00` ：

```
$ mysqlbinlog /path/to/datadir/mysql-bin.000003 /path/to/datadir/mysql-bin.000004 \
    --start-position=57 --stop-datetime="11-12-25 01:00:00" | mysql -u root -p
```

and the database will be rolled forward up to that Point-In-Time.
数据库将前滚到该时间点。

# Restore individual tables[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html#restore-individual-tables) 恢复单个表 ¶

Percona XtraBackup can export a table that is contained in its own .ibd file.  With Percona XtraBackup, you can export individual tables from any  InnoDB database, and import them into Percona Server for MySQL with  XtraDB or MySQL 8.3. The source doesn’t have to be XtraDB or MySQL 8.3,  but the destination does. This method only works on individual .ibd  files.
Percona XtraBackup可以导出包含在其自己的.ibd文件中的表。使用 Percona XtraBackup，您可以从任何 InnoDB  数据库中导出单个表，并将它们导入到 Percona Server for MySQL with XtraDB 或 MySQL 8.3  中。源不必是 XtraDB 或 MySQL 8.3，但目标必须是。此方法仅适用于单个 .ibd 文件。

The following example exports and imports the following table:
以下示例导出和导入下表：

```
CREATE TABLE export_test (
a int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

## Export the table[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html#export-the-table) 导出表格 ¶

To generate an .ibd file in the target directory, create the table using the `innodb_file_per_table` mode:
要在目标目录中生成 .ibd 文件，请使用以下 `innodb_file_per_table` 模式创建表：

```
$ find /data/backups/mysql/ -name export_test.*
/data/backups/mysql/test/export_test.ibd
```

During the `--prepare` step, add the `--export` option to the command. For example:
在此 `--prepare` 步骤中，将 `--export` 选项添加到命令中。例如：

```
$ xtrabackup --prepare --export --target-dir=/data/backups/mysql/
```

When restoring an encrypted InnoDB tablespace table, add the keyring file:
恢复加密的 InnoDB 表空间表时，请添加密钥环文件：

```
$ xtrabackup --prepare --export --target-dir=/tmp/table \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

The following files are the only files required to import the table into a  server running Percona Server for MySQL with XtraDB or MySQL 8.3. If the server uses InnoDB Tablespace Encryption, add the .cfp file, which  contains the transfer key and an encrypted tablespace key.
以下文件是将表导入运行 Percona Server for MySQL with XtraDB 或 MySQL 8.3 的服务器所需的唯一文件。如果服务器使用 InnoDB 表空间加密，请添加 .cfp 文件，其中包含传输密钥和加密的表空间密钥。

The files are located in the target directory:
这些文件位于目标目录中：

```
/data/backups/mysql/test/export_test.ibd
/data/backups/mysql/test/export_test.cfg
```

## Import the table[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html#import-the-table) 导入表格 ¶

On the destination server running Percona Server for MySQL with XtraDB or  MySQL 8.3, create a table with the same structure, and then perform the  following steps:
在运行 Percona Server for MySQL with XtraDB 或 MySQL 8.3 的目标服务器上，创建具有相同结构的表，然后执行以下步骤：

1. Run the `ALTER TABLE test.export_test DISCARD TABLESPACE;` command. If you see the following error message:
   运行该 `ALTER TABLE test.export_test DISCARD TABLESPACE;` 命令。如果您看到以下错误消息：

   <details class="example" data-immersive-translate-walked="f40d6822-974e-4bf3-af19-c68769a5faa9" open="">
   <summary data-immersive-translate-walked="f40d6822-974e-4bf3-af19-c68769a5faa9" data-immersive-translate-paragraph="1">Error message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">错误信息</font></font></font></summary>
   <div class="no-copy highlight" data-immersive-translate-walked="f40d6822-974e-4bf3-af19-c68769a5faa9"><pre><span></span><code>ERROR 1809 (HY000): Table 'test/export_test' in system tablespace
   </code></pre></div>
   </details>

   enable `innodb_file_per_table` option on the server and create the table again.
   启用 `innodb_file_per_table` 选项，然后重新创建表。

   ```
   
   ```

```
$ set global innodb_file_per_table=ON;
```

Copy the exported files to the `test/` subdirectory of the destination server’s data directory.
将导出的文件复制到目标服务器数据目录的 `test/` 子目录。

Run `ALTER TABLE test.export_test IMPORT TABLESPACE;` 跑 `ALTER TABLE test.export_test IMPORT TABLESPACE;` 

The table is imported, and you can run a `SELECT` to see the imported data.
该表已导入，您可以运行 a `SELECT` 来查看导入的数据。

# Encrypted InnoDB tablespace backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#encrypted-innodb-tablespace-backups) 加密的 InnoDB 表空间备份 ¶

InnoDB supports [data encryption for InnoDB tables](https://dev.mysql.com/doc/refman/8.3/en/innodb-data-encryption.html) stored in file-per-table tablespaces. This feature provides an at-rest encryption for physical tablespace data files.
InnoDB 支持对存储在逐个表的表空间中的 InnoDB 表进行数据加密。此功能为物理表空间数据文件提供静态加密。

For an authenticated user or an application to access an encrypted F tablespace, InnoDB uses the master encryption key to decrypt the tablespace key. The master encryption key is stored in a keyring. 
为了让经过身份验证的用户或应用程序访问加密的 F 表空间，InnoDB 使用主加密密钥来解密表空间密钥。主加密密钥存储在密钥环中。

Percona XtraBackup supports the following keyring components and plugins: 
Percona XtraBackup支持以下密钥环组件和插件：

- [keyring_vault](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-vault-component) component keyring_vault组件
- [keyring_file](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-file-plugin) plugin keyring_file插件
- [keyring_file](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-file-component) component keyring_file组件
- [Key Management Interoperability Protocol (KMIP)
  密钥管理互操作性协议 （KMIP）](https://docs.percona.com/percona-server/innovation-release/using-kmip.html?h=kmip)
- [Amazon Key Management Service (AWS KMS)
  Amazon Key Management Service （AWS KMS）](https://docs.percona.com/percona-server/innovation-release/using-amz-kms.html)

These components are stored in the `plugin` directory.
这些组件存储在 `plugin` 目录中。

Note 注意

Enable only one keyring plugin or one keyring component simultaneously for  each server instance. Enabling multiple keyring plugins or keyring  components or mixing keyring plugins or keyring components is not  supported and may result in data loss.
仅为每个服务器实例同时启用一个密钥环插件或一个密钥环组件。不支持启用多个密钥环插件或密钥环组件，或者混合使用密钥环插件或密钥环组件，这可能会导致数据丢失。

## Use the keyring vault component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-vault-component) 使用密钥环库组件 ¶

The `keyring_vault` component extends the server capabilities. The server uses a manifest  to load the component and the component has its own configuration file.
该 `keyring_vault` 组件扩展了服务器功能。服务器使用清单来加载组件，并且该组件具有自己的配置文件。

The following example is a global manifest file that does not use local manifests:
以下示例是不使用本地清单的全局清单文件：

```
{
 "read_local_manifest": false,
 "components": "file://component_keyring_vault"
}
```

The following example of a global manifest file that points to a local manifest file:
以下指向本地清单文件的全局清单文件示例：

```
{
 "read_local_manifest": true
}
```

The following example of a local manifest file:
本地清单文件的以下示例：

```
{
 "components": "file://component_keyring_vault"
}
```

The configuration settings can be in either a global or a local configuration file.
配置设置可以位于全局配置文件中，也可以位于本地配置文件中。

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Example of a configuration file in JSON format<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">JSON格式的配置文件示例</font></font></font></summary>
<div class="highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre id="__code_3"><span></span></pre></div></details>

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open=""><div class="highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre id="__code_3"><code><span class="p">{</span>
<span class="w"> </span><span class="nt">"timeout"</span><span class="p">:</span><span class="w"> </span><span class="mi">15</span><span class="p">,</span>
<span class="w"> </span><span class="nt">"vault_url"</span><span class="p">:</span><span class="w"> </span><span class="s2">"https://vault.public.com:8202"</span><span class="p">,</span>
<span class="w"> </span><span class="nt">"secret_mount_point"</span><span class="p">:</span><span class="w"> </span><span class="s2">"secret"</span><span class="p">,</span>
<span class="w"> </span><span class="nt">"secret_mount_point_version"</span><span class="p">:</span><span class="w"> </span><span class="s2">"AUTO"</span><span class="p">,</span>
<span class="w"> </span><span class="nt">"token"</span><span class="p">:</span><span class="w"> </span><span class="s2">"58a20c08-8001-fd5f-5192-7498a48eaf20"</span><span class="p">,</span>
<span class="w"> </span><span class="nt">"vault_ca"</span><span class="p">:</span><span class="w"> </span><span class="s2">"/data/keyring_vault_confs/vault_ca.crt"</span>
<span class="p">}</span>
</code></pre></div>
</details>

Find more information on configuring the `keyring_vault` component in [Use the keyring vault component](https://docs.percona.com/percona-server/innovation-release/use-keyring-vault-component.html).
有关配置 `keyring_vault` 组件的详细信息，请参阅使用密钥环保管库组件。

The component has no special requirements for backing up a database that contains encrypted InnoDB tablespaces.
该组件对备份包含加密 InnoDB 表空间的数据库没有特殊要求。

The following command creates a backup in the `/data/backup` directory:
以下命令在 `/data/backup` 目录中创建备份：

```
$ xtrabackup --backup --target-dir=/data/backup --user=root
```

After xtrabackup completes the action, the following message confirms the action:
xtrabackup 完成操作后，以下消息将确认该操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>xtrabackup: Transaction log of lsn (5696709) to (5696718) was copied.
160401 10:25:51 completed OK!
</code></pre></div>
</details>

### Prepare the backup with the keyring vault component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#prepare-the-backup-with-the-keyring-vault-component) 使用密钥环保管库组件准备备份 ¶

To prepare the backup, the xtrabackup binary must access the keyring. The  xtrabackup binary does not communicate with the MySQL server or read the default `my.cnf` configuration file. Specify the keyring settings in the command line:
要准备备份，xtrabackup 二进制文件必须访问密钥环。xtrabackup 二进制文件不与 MySQL 服务器通信或读取默认 `my.cnf` 配置文件。在命令行中指定密钥环设置：

```
$ xtrabackup --prepare --target-dir=/data/backup --component-keyring-config==/etc/vault.cnf
```

The following message confirms that the xtrabackup binary completed the action:
以下消息确认 xtrabackup 二进制文件已完成操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 5697064
160401 10:34:28 completed OK!
</code></pre></div>
</details>

### Restore the backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#restore-the-backup) 恢复备份 ¶

As soon as the backup is prepared, you can restore it with the `--copy-back` option:
准备好备份后，可以使用以下 `--copy-back` 选项进行还原：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--transition-key=MySecretKey --generate-new-master-key \
--component-keyring-config=/etc/vault.cnf
```

## Use the keyring file plugin[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-file-plugin) 使用密钥环文件插件 ¶

Warning 警告

The `keyring_file` plugin should not be used for regulatory compliance.
该 `keyring_file` 插件不应用于法规遵从性。

In order to back up and prepare a database containing encrypted InnoDB
为了备份和准备包含加密InnoDB的数据库
 tablespaces, specify the path to a keyring file as the value of the `--keyring-file-data` option.
表空间，将密钥环文件的路径指定为 `--keyring-file-data` 选项的值。

```
$ xtrabackup --backup --target-dir=/data/backup/ --user=root \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

The following message confirms that the xtrabackup binary completed the action:
以下消息确认 xtrabackup 二进制文件已完成操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>xtrabackup: Transaction log of lsn (5696709) to (5696718) was copied.
160401 10:25:51 completed OK!
</code></pre></div>
</details>

Warning 警告

xtrabackup does not copy the keyring file into the backup directory. To prepare  the backup, you must copy the keyring file manually.
XtraBackup 不会将密钥环文件复制到备份目录中。若要准备备份，必须手动复制密钥环文件。

### Prepare the backup with the keyring file plugin[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#prepare-the-backup-with-the-keyring-file-plugin) 使用密钥环文件插件准备备份 ¶

To prepare the backup, specify the keyring-file-data.
要准备备份，请指定 keyring-file-data。

```
$ xtrabackup --prepare --target-dir=/data/backup \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

The following message confirms that the xtrabackup binary completed the action:
以下消息确认 xtrabackup 二进制文件已完成操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 5697064
160401 10:34:28 completed OK!
</code></pre></div>
</details>

The backup is now prepared and can be restored with the `--copy-back` option. You must restore the keyring used with the backup and prepare phases if the keyring has been rotated.
备份现在已准备好，可以使用该 `--copy-back` 选项进行还原。如果密钥环已旋转，则必须恢复用于备份和准备阶段的密钥环。

## Use the keyring file component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#use-the-keyring-file-component) 使用密钥环文件组件 ¶

The `keyring_file` component is part of the component-based MySQL infrastructure which extends the server capabilities.
该 `keyring_file` 组件是基于组件的MySQL基础架构的一部分，它扩展了服务器功能。

The server uses a manifest to load the component, and the component has its own configuration file. See the [MySQL documentation on the component  installation](https://dev.mysql.com/doc/refman/8.3/en/keyring-component-installation.html) for more information.
服务器使用清单来加载组件，并且该组件有自己的配置文件。有关更多信息，请参阅有关组件安装的 MySQL 文档。

An example of a manifest and a configuration file follows:
清单和配置文件的示例如下：

An example of `./bin/mysqld.my`:
举个 `./bin/mysqld.my` 例子：

```
{
   "components": "file://component_keyring_file"
}
```

An example of `/lib/plugin/component_keyring_file.cnf`:
举个 `/lib/plugin/component_keyring_file.cnf` 例子：

```
{
   "path": "/var/lib/mysql-keyring/keyring_file", "read_only": false
}
```

For more information, see [Keyring Component Installation](https://dev.mysql.com/doc/refman/8.3/en/keyring-component-installation.html) and [Using the keyring_file File-Based Keyring Plugin](https://dev.mysql.com/doc/refman/8.3/en/keyring-file-plugin.html).
有关更多信息，请参阅密钥环组件安装和使用基于keyring_file文件的密钥环插件。

With the appropriate privilege, you can `SELECT` on the [performance_schema.keyring_component_status table](https://dev.mysql.com/doc/refman/8.3/en/performance-schema-keyring-component-status-table.html) to view the attributes and status of the installed keyring component  when in use.
使用适当的权限，您可以在 `SELECT` performance_schema.keyring_component_status 表上查看已安装密钥环组件在使用时的属性和状态。

The component has no special requirements for backing up a database that contains encrypted InnoDB tablespaces.
该组件对备份包含加密 InnoDB 表空间的数据库没有特殊要求。

```
$ xtrabackup --backup --target-dir=/data/backup --user=root
```

The following message confirms that the xtrabackup binary completed the action:
以下消息确认 xtrabackup 二进制文件已完成操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>xtrabackup: Transaction log of lsn (5696709) to (5696718) was copied.
160401 10:25:51 completed OK!
</code></pre></div>
</details>

Warning 警告

xtrabackup does not copy the keyring file into the backup directory. To prepare  the backup, you must copy the keyring file manually.
XtraBackup 不会将密钥环文件复制到备份目录中。若要准备备份，必须手动复制密钥环文件。

### Prepare the backup with the keyring_file component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#prepare-the-backup-with-the-keyring_file-component) 使用 keyring_file 组件准备备份 ¶

xtrabackup reads the `keyring_file` component configuration from `xtrabackup_component_keyring_file.cnf`. You must specify the keyring_file data path if the `--component-keyring-config` is not located in the attribute `PATH` from the `xtrabackup_component_keyring_file.cnf`.
xtrabackup 从 `xtrabackup_component_keyring_file.cnf` 中读取 `keyring_file` 组件配置。如果 不在 `--component-keyring-config` 的属性 `PATH` 中，则必须指定 keyring_file 数据路径 `xtrabackup_component_keyring_file.cnf` 。

The following is an example of adding the location for the –component-keyring-config:
以下是为 –component-keyring-config 添加位置的示例：

```
$ xtrabackup --prepare --target-dir=/data/backup \
--component-keyring-config=/var/lib/mysql-keyring/keyring
```

xtrabackup attempts to read `xtrabackup_component_keyring_file.cnf`. You can assign another keyring file component configuration by passing the `--component-keyring-config` option.
xtrabackup 尝试读取 `xtrabackup_component_keyring_file.cnf` .您可以通过传递该 `--component-keyring-config` 选项来分配另一个密钥环文件组件配置。

The following message confirms that the xtrabackup binary completed the action:
以下消息确认 xtrabackup 二进制文件已完成操作：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 5697064
160401 10:34:28 completed OK!
</code></pre></div>
</details>

The backup is prepared. To restore the backup use the `--copy-back` option. If the keyring has been rotated, you must restore the specific keyring used to take and prepare the backup.
备份已准备就绪。要还原备份，请使用该 `--copy-back` 选项。如果密钥环已旋转，则必须还原用于获取和准备备份的特定密钥环。

## Incremental encrypted InnoDB tablespace backups with keyring file plugin[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#incremental-encrypted-innodb-tablespace-backups-with-keyring-file-plugin) 使用密钥环文件插件进行增量加密的 InnoDB 表空间备份 ¶

The process of taking incremental backups with InnoDB tablespace encryption is similar to taking incremental backups with unencrypted tablespace. 
使用 InnoDB 表空间加密进行增量备份的过程类似于使用未加密的表空间进行增量备份。

## Create an incremental backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#create-an-incremental-backup) 创建增量备份 ¶

To make an incremental backup, begin with a full backup. The xtrabackup binary writes `xtrabackup_checkpoints` into the backup’s target directory. This file contains a line showing the `to_lsn`, which is the LSN of the database at the end of the backup. First, you need to create a full backup with the following command:
若要进行增量备份，请从完整备份开始。xtrabackup 二进制文件写入 `xtrabackup_checkpoints` 备份的目标目录。此文件包含一行，其中显示 `to_lsn` ，这是备份末尾数据库的 LSN。首先，您需要使用以下命令创建完整备份：

```
$ xtrabackup --backup --target-dir=/data/backups/base \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

To prepare the backup, you must make a copy of the keyring file yourself.  The xtrabackup binary does not copy the keyring file into the backup  directory. Restoring the backup after the keyring has been changed  causes errors like `ERROR 3185 (HY000): Can't find master key from keyring, please check keyring plugin is loaded.` when the restore process tries accessing an encrypted table.
若要准备备份，必须自行复制密钥环文件。xtrabackup 二进制文件不会将密钥环文件复制到备份目录中。在更改密钥环后还原备份会导致错误，例如 `ERROR 3185 (HY000): Can't find master key from keyring, please check keyring plugin is loaded.` 还原过程尝试访问加密表时出现错误。

If you look at the `xtrabackup_checkpoints` file, you should see the output similar to the following:
如果查看该 `xtrabackup_checkpoints` 文件，应会看到类似于以下内容的输出：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>backup_type = full-backuped
from_lsn = 0
to_lsn = 7666625
last_lsn = 7666634
compact = 0
recover_binlog_info = 1
</code></pre></div>
</details>

Now that you have a full backup, you can make an incremental backup based on it. Use a command such as the following:
现在您已经有了完整备份，您可以基于它进行增量备份。使用如下命令：

```
$ xtrabackup --backup --target-dir=/data/backups/inc1 \
--incremental-basedir=/data/backups/base \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

To prepare the backup, you must copy the keyring file manually. The  xtrabackup binary does not copy the keyring file into the backup  directory. 
若要准备备份，必须手动复制密钥环文件。xtrabackup 二进制文件不会将密钥环文件复制到备份目录中。

If the keyring has not been rotated you can use the same one you’ve backed-up with the base backup. If the keyring has been rotated, or you have  upgraded the plugin to a component, you must back up the keyring file.  Otherwise, you cannot prepare the backup.
如果钥匙圈尚未旋转，则可以使用与基本备份备份相同的钥匙圈。如果密钥环已旋转，或者您已将插件升级为组件，则必须备份密钥环文件。否则，您将无法准备备份。

The `/data/backups/inc1/` directory should now contain delta files, such as `ibdata1.delta` and `test/table1.ibd.delta`. These represent the changes since the `LSN 7666625`. If you examine the `xtrabackup_checkpoints` file in this directory, you should see  the output similar to the following:
该 `/data/backups/inc1/` 目录现在应包含增量文件，例如 `ibdata1.delta` 和 `test/table1.ibd.delta` 。这些表示自 `LSN 7666625` .如果检查此目录中的 `xtrabackup_checkpoints` 文件，应看到类似于以下内容的输出：

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>backup_type = incremental
from_lsn = 7666625
to_lsn = 8873920
last_lsn = 8873929
compact = 0
recover_binlog_info = 1
</code></pre></div>
</details>

Use this directory as the base for yet another incremental backup:
使用此目录作为另一个增量备份的基础：

```
$ xtrabackup --backup --target-dir=/data/backups/inc2 \
--incremental-basedir=/data/backups/inc1 \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

### Prepare incremental backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#prepare-incremental-backups) 准备增量备份 ¶

The `--prepare` step for incremental backups is not the same as for normal backups. In normal backups, two types of operations are performed to make the database consistent: 
增量备份的 `--prepare` 步骤与普通备份的步骤不同。在普通备份中，执行两种类型的操作以使数据库保持一致：

- Committed transactions are replayed from the log file against the data files
  已提交的事务将根据数据文件从日志文件重播
- Uncommitted transactions are rolled back
  未提交的事务将回滚

You must skip the rollback of uncommitted transactions when preparing a  backup because transactions that were uncommitted at the time of your  backup may be in progress, and they will likely be committed in the next incremental backup. Use the `-`-apply-log-only`option to prevent the rollback phase. Your incremental backups are useless if you do not use the`–apply-log-only` option to prevent the rollback phase. After transactions have been  rolled back, further incremental backups cannot be applied.
在准备备份时，必须跳过未提交事务的回滚，因为在备份时未提交的事务可能正在进行中，并且它们可能会在下一次增量备份中提交。使用 `-` -apply-log-only `option to prevent the rollback phase. Your incremental backups are useless if you do not use the` –apply-log-only' 选项可防止回滚阶段。事务回滚后，无法应用进一步的增量备份。

Beginning with the full backup you created, you can prepare it and then apply the incremental differences. Recall that you have the following backups:
从您创建的完整备份开始，您可以准备它，然后应用增量差异。回想一下，您有以下备份：

```
/data/backups/base
/data/backups/inc1
/data/backups/inc2
```

To prepare the base backup, you need to run `--prepare` as usual, but prevent the rollback phase:
若要准备基本备份，需要照常运行 `--prepare` ，但要阻止回滚阶段：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

<details class="example" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" open="">
<summary data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="7606da5e-62c5-4189-8f09-5c64c19508a2"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 7666643
InnoDB: Number of pools: 1
160401 12:31:11 completed OK!
</code></pre></div>
</details>

To apply the first incremental backup to the full backup, you should use the following command:
若要将第一个增量备份应用于完整备份，应使用以下命令：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base \
--incremental-dir=/data/backups/inc1 \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

The backup should be prepared with the keyring file and type that was used  when the backup was being taken. This means that if the keyring has been rotated, or you have upgraded from a plugin to a component between the  base and incremental backup, you must use the keyring used when the  first incremental backup was taken.
备份应使用执行备份时使用的密钥环文件和类型进行准备。这意味着，如果密钥环已轮换，或者您已从插件升级到介于基本备份和增量备份之间的组件，则必须使用进行第一次增量备份时使用的密钥环。

Preparing the second incremental backup is a similar process: apply the deltas to the (modified) base backup, and you will roll its data forward in  time to the point of the second incremental backup:
准备第二个增量备份的过程与此类似：将增量应用于（修改后的）基础备份，然后将其数据及时向前滚动到第二个增量备份的点：



```
$ xtrabackup --prepare --target-dir=/data/backups/base \
--incremental-dir=/data/backups/inc2 \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

Use `--apply-log-only` when merging all incremental backups except the last one. The previous line does not contain the `--apply-log-only` option. Even if the `--apply-log-only` option was used on the last step, the backup would still be consistent, but in that case, the server would perform the rollback phase.
在合并除最后一个备份之外的所有增量备份时使用 `--apply-log-only` 。上一行不包含该 `--apply-log-only` 选项。即使在最后一步中使用了该 `--apply-log-only` 选项，备份仍将保持一致，但在这种情况下，服务器将执行回滚阶段。



The backup is now prepared and can be restored with `--copy-back` option. In case the keyring has been rotated you’ll need to restore the keyring which was used to take and prepare the backup.
备份现在已准备好，可以使用 `--copy-back` 选项进行恢复。如果钥匙圈已旋转，则需要恢复用于获取和准备备份的钥匙圈。

## Restore a backup when the keyring is not available[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#restore-a-backup-when-the-keyring-is-not-available) 当密钥环不可用时恢复备份 ¶

While this works, the method requires access to the same keyring that the  server is using. It may not be possible if the backup is prepared on a different server or at a much later time, when keys in the keyring are purged, or, in the case of a malfunction, when the keyring vault server  is unavailable.
虽然这有效，但该方法需要访问服务器正在使用的同一密钥环。如果备份是在另一台服务器上准备的，或者在很久以后，当密钥环中的密钥被清除时，或者在发生故障的情况下，当密钥环保管库服务器不可用时，则可能无法进行备份。

The `--transition-key=<passphrase>` option should be used to make it possible for the xtrabackup binary to  process the backup without access to the keyring vault server. In this  case, the binary derives the AES encryption key from the specified  passphrase and will use it to encrypt tablespace keys of tablespaces  being backed up.
该 `--transition-key=<passphrase>` 选项应用于使 xtrabackup 二进制文件能够在不访问密钥环保管库服务器的情况下处理备份。在这种情况下，二进制文件从指定的密码短语派生 AES 加密密钥，并将使用它来加密正在备份的表空间的表空间密钥。

### Create a backup with a passphrase[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#create-a-backup-with-a-passphrase) 使用密码创建备份 ¶

The following example illustrates how the backup can be created in this case:
以下示例说明了在这种情况下如何创建备份：

```
$ xtrabackup --backup --user=root -p --target-dir=/data/backup \
--transition-key=MySecretKey
```

If `--transition-key` is specified without a value, xtrabackup will ask for it.
如果 `--transition-key` 指定时没有值，则 xtrabackup 将要求提供该值。

xtrabackup scrapes `--transition-key` so that its value is not visible in the `ps` command output.
XtraBackup 抓 `--transition-key` 取，使其值在 `ps` 命令输出中不可见。

### Prepare a backup with a passphrase[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#prepare-a-backup-with-a-passphrase) 使用密码准备备份 ¶

The same passphrase should be specified for the prepare command:
应为 prepare 命令指定相同的密码：

```
$ xtrabackup --prepare --target-dir=/data/backup \
--transition-key=MySecretKey
```

There are no `--keyring-vault...`,``–keyring-file…``, or `--component-keyring-config` options here, because xtrabackup does not talk to the keyring in this case.
这里没有 `--keyring-vault...` ，''–keyring-file...'' 或 `--component-keyring-config` 选项，因为在这种情况下，xtrabackup 不会与密钥环通信。

### Restore a backup with a generated key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#restore-a-backup-with-a-generated-key) 使用生成的密钥恢复备份 ¶

When restoring a backup you need to generate a new master key. 
还原备份时，需要生成新的主密钥。

The example for `keyring_file` plugin:
 `keyring_file` 插件示例：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--transition-key=MySecretKey --generate-new-master-key \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

The example for `keyring_file` component:
 `keyring_file` 组件示例：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--transition-key=MySecretKey --generate-new-master-key \
--component-keyring-config=/var/lib/mysql-keyring/keyring
```

The example for `keyring_vault` component:
 `keyring_vault` 组件示例：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--transition-key=MySecretKey --generate-new-master-key \
--component-keyring-config=/etc/vault.cnf
```

xtrabackup generates a new master key, stores it in the target keyring vault server, and re-encrypts the tablespace keys using this key.
XtraBackup 生成一个新的主密钥，将其存储在目标密钥环保险库服务器中，并使用此密钥重新加密表空间密钥。

### Make a backup with a stored transition key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypted-innodb-tablespace-backups.html#make-a-backup-with-a-stored-transition-key) 使用存储的转换密钥进行备份 ¶

Finally, there is an option to store a transition key in the keyring. In this  case, xtrabackup must access the same keyring file or vault server  during prepare and copy-back steps, but does not depend on whether the  server keys have been purged.
最后，还有一个选项可以在密钥环中存储过渡密钥。在这种情况下，xtrabackup 必须在准备和复制回步骤期间访问相同的密钥环文件或 Vault 服务器，但不依赖于服务器密钥是否已被清除。

In this scenario, the three stages of the backup process look as follows.
在此方案中，备份过程的三个阶段如下所示。

- Back up 退后

```
$ xtrabackup --backup --user=root -p --target-dir=/data/backup \
--generate-transition-key
```

- Prepare 准备

  - `keyring_file` plugin variant:
     `keyring_file` 插件变体：

  ```
  
  ```

```
$ xtrabackup --prepare --target-dir=/data/backup \
--keyring-file-data=/var/lib/mysql-keyring/keyring
```

- `keyring_file` component variant:
   `keyring_file` 组件变体：

```
$ xtrabackup --prepare --target-dir=/data/backup \
--component-keyring-config=/var/lib/mysql-keyring/keyring
```

- `keyring_vault` component variant:
   `keyring_vault` 组件变体：

```
$ xtrabackup --prepare --target-dir=/data/backup \
--component-keyring-config=/etc/vault.cnf
```

Copy-back 回印

- `keyring_file` plugin variant:
   `keyring_file` 插件变体：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--generate-new-master-key --keyring-file-data=/var/lib/mysql-keyring/keyring
```

- `keyring_file` component variant:
   `keyring_file` 组件变体：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--generate-new-master-key --component-keyring-config=/var/lib/mysql-keyring/keyring
```

- `keyring_vault` component variant:
   `keyring_vault` 组件变体：

```
$ xtrabackup --copy-back --target-dir=/data/backup --datadir=/data/mysql \
--generate-new-master-key --component-keyring-config=/etc/vault.cnf
```

# FLUSH TABLES WITH READ LOCK option[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/flush-tables-with-read-lock.html#flush-tables-with-read-lock-option) FLUSH TABLES WITH READ LOCK 选项 ¶

The `FLUSH TABLES WITH READ LOCK` option does the following with a global read lock:
该 `FLUSH TABLES WITH READ LOCK` 选项使用全局读锁执行以下操作：

- Closes all open tables
  关闭所有打开的表
- Locks all tables for all databases
  锁定所有数据库的所有表

Release the lock with `UNLOCK TABLES`.
用 `UNLOCK TABLES` .

Note 注意

`FLUSH TABLES WITH READ LOCK` does not prevent inserting rows into the log tables.
 `FLUSH TABLES WITH READ LOCK` 不阻止在日志表中插入行。

To ensure consistent backups, use the `FLUSH TABLES WITH READ LOCK` option before taking a non-InnoDB file backup. The option does not affect long-running queries.
为确保备份的一致性，请在进行非 InnoDB 文件备份之前使用该 `FLUSH TABLES WITH READ LOCK` 选项。该选项不会影响长时间运行的查询。

Enabling `FLUSH TABLES WITH READ LOCK` when the server has long-running queries can leave the server in a  read-only mode until the queries finish. If the server is in either the `Waiting for table flush` or the `Waiting for master to send event` state, stopping the `FLUSH TABLES WITH READ LOCK` operation does not help. Stop any long-running queries to return to normal operation.
在服务器具有长时间运行的查询时启用 `FLUSH TABLES WITH READ LOCK` 可以使服务器处于只读模式，直到查询完成。如果服务器处于 `Waiting for table flush` 或 状态 `Waiting for master to send event` ，则停止 `FLUSH TABLES WITH READ LOCK` 操作无济于事。停止任何长时间运行的查询以恢复正常操作。

To prevent the server staying in a read-only mode until the queries finish, xtrabackup does the following:
要防止服务器在查询完成之前保持只读模式，xtrabackup 执行以下操作：

- checks if any queries run longer than specified in `--ftwrl-wait-threshold`. If xtrabackup finds such queries, xtrabackup waits for one second and  checks again. If xtrabackup waits longer than specified in `--ftwrl-wait-timeout`, the backup is aborted. As soon as xtrabackup finds no queries running longer than specified in `--ftwrl-wait-threshold`, xtrabackup issues the global lock.
  检查是否有任何查询的运行时间超过中 `--ftwrl-wait-threshold` 指定的时间。如果 xtrabackup 找到此类查询，xtrabackup 将等待一秒钟并再次检查。如果 xtrabackup 等待的时间长于 `--ftwrl-wait-timeout` 中指定的时间，则备份将中止。一旦 xtrabackup 发现没有查询的运行时间超过中 `--ftwrl-wait-threshold` 指定的时间，xtrabackup 就会发出全局锁定。
- kills all queries or only the SELECT queries which prevent the global lock from being acquired.
  终止所有查询或仅终止阻止获取全局锁的 SELECT 查询。

Note 注意

All operations described in this section have no effect when [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) are used.
使用备份锁时，本节中描述的所有操作均无效。

Percona XtraBackup uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) where available as a lightweight alternative to `FLUSH TABLES WITH READ LOCK`. This operation automatically copies non-InnoDB data and avoids blocking DML queries that modify InnoDB tables.
Percona XtraBackup使用备份锁作为轻量级的 `FLUSH TABLES WITH READ LOCK` 替代品。此操作会自动复制非 InnoDB 数据，并避免阻止修改 InnoDB 表的 DML 查询。

## Wait for queries to finish[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/flush-tables-with-read-lock.html#wait-for-queries-to-finish) 等待查询完成 ¶

You should issue a global lock when no long queries are running. Waiting to issue the global lock for extended period of time is not a good method. The wait can extend the time needed for backup to take place. The `–ftwrl-wait-timeout` option can limit the waiting time. If it cannot issue the lock during this time, xtrabackup stops the option, exits with an error message, and backup is not be taken.
当没有运行长查询时，应发出全局锁定。长时间等待颁发全局锁不是一个好方法。等待可能会延长进行备份所需的时间。该 `–ftwrl-wait-timeout` 选项可以限制等待时间。如果在此期间无法发出锁定，xtrabackup 将停止该选项，退出并显示错误消息，并且不进行备份。

The option’s default value is zero (0), which turns off the option.
该选项的默认值为零 （0），这将关闭该选项。

Another possibility is to specify the type of query to wait on. In this case `--ftwrl-wait-query-type`.
另一种可能性是指定要等待的查询类型。在这种情况下 `--ftwrl-wait-query-type` .

The possible values are `all` and `update`. When `all` is used xtrabackup will wait for all long running queries (execution time longer than allowed by `--ftwrl-wait-threshold`) to finish before running the `FLUSH TABLES WITH READ LOCK`. When `update` is used xtrabackup will wait on `UPDATE/ALTER/REPLACE/INSERT` queries to finish.
可能的值为 `all` 和 `update` 。使用时 `all` xtrabackup 将等待所有长时间运行的查询（执行时间长于 `--ftwrl-wait-threshold` ）完成，然后再运行 `FLUSH TABLES WITH READ LOCK` .使用时 `update` ，xtrabackup 将等待 `UPDATE/ALTER/REPLACE/INSERT` 查询完成。

The time needed for a specific query to complete is hard to predict. We  assume that the long-running queries will not finish in a timely manner. Other queries which run for a short time finish quickly. xtrabackup  uses the value of `–ftwrl-wait-threshold option to specify the long-running queries and will block a global lock. To use this option xtrabackup user should have`PROCESS`and`CONNECTION_ADMIN` privileges.
完成特定查询所需的时间很难预测。我们假设长时间运行的查询不会及时完成。其他运行时间较短的查询会很快完成。xtrabackup 使用 PROCESS `and` CONNECTION_ADMIN 权限的值 `–ftwrl-wait-threshold option to specify the long-running queries and will block a global lock. To use this option xtrabackup user should have` 。

## Kill the blocking queries[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/flush-tables-with-read-lock.html#kill-the-blocking-queries) 终止阻塞查询 ¶

The second option is to kill all the queries which prevent from acquiring the global lock. In this case, all queries which run longer than `FLUSH TABLES WITH READ LOCK` are potential blockers. Although all queries can be killed, additional time can be specified for the short running queries to finish using the `--kill-long-queries-timeout` option. This option specifies a query time limit. After the specified  time is reached, the server kills the query. The default value is zero,  which turns this feature off.
第二种选择是杀死所有阻止获取全局锁的查询。在这种情况下，所有运行时间超过 `FLUSH TABLES WITH READ LOCK` 潜在阻止程序的查询都是潜在的阻止程序。尽管可以终止所有查询，但可以使用该 `--kill-long-queries-timeout` 选项指定额外的时间，以便完成短时间运行的查询。此选项指定查询时间限制。达到指定时间后，服务器将终止查询。默认值为零，将关闭此功能。

The `--kill-long-query-type` option can be used to specify all or only `SELECT` queries that are preventing global lock from being acquired. To use this option xtrabackup user should have `PROCESS` and `CONNECTION_ADMIN` privileges.
该 `--kill-long-query-type` 选项可用于指定阻止获取全局锁的所有查询或仅 `SELECT` 指定查询。要使用此选项，xtrabackup 用户应具有 `PROCESS` 和 `CONNECTION_ADMIN` 权限。

## Options summary[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/flush-tables-with-read-lock.html#options-summary) 选项摘要 ¶

- `--ftwrl-wait-timeout` (seconds) - how long to wait for a good moment. Default is 0, not to wait.
   `--ftwrl-wait-timeout` （秒） - 等待一个好时机需要多长时间。默认值为 0，不等待。
- `--ftwrl-wait-query-type` - which long queries should be finished before `FLUSH TABLES WITH READ LOCK` is run. Default is all.
   `--ftwrl-wait-query-type` - 在运行之前 `FLUSH TABLES WITH READ LOCK` 应完成哪些长查询。默认值为全部。
- `--ftwrl-wait-threshold` (seconds) - how long query should be running before we consider it long running and potential blocker of global lock.
   `--ftwrl-wait-threshold` （秒） - 查询应该运行多长时间，然后我们认为它运行时间很长，并且可能会阻止全局锁定。
- `--kill-long-queries-timeout` (seconds) - how many time we give for queries to complete after `FLUSH TABLES WITH READ LOCK` is issued before start to kill. Default if `0`, not to kill.
   `--kill-long-queries-timeout` （秒） - 在开始终止之前，我们给 `FLUSH TABLES WITH READ LOCK` 查询多少时间完成。默认 if `0` ，不杀。
- `--kill-long-query-type` - which queries should be killed once `kill-long-queries-timeout` has expired.
   `--kill-long-query-type` - 哪些查询在过期后 `kill-long-queries-timeout` 应被终止。

### Example[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/flush-tables-with-read-lock.html#example) 示例 ¶

Running the xtrabackup with the following options will cause xtrabackup to spend no longer than 3 minutes waiting for all queries older than 40 seconds to complete.
使用以下选项运行 xtrabackup 将导致 xtrabackup 等待所有超过 40 秒的查询完成的时间不超过 3 分钟。

```
$  xtrabackup --backup --ftwrl-wait-threshold=40 \
--ftwrl-wait-query-type=all --ftwrl-wait-timeout=180 \
--kill-long-queries-timeout=20 --kill-long-query-type=all \
--target-dir=/data/backups/
```

After `FLUSH TABLES WITH READ LOCK` is issued, xtrabackup will wait for 20 seconds for lock to be acquired. If lock is still not acquired after 20 seconds, it will kill all queries which are running longer that the `FLUSH TABLES WITH READ LOCK`.
发出后 `FLUSH TABLES WITH READ LOCK` ，xtrabackup 将等待 20 秒以获取锁定。如果 20 秒后仍未获取 lock，它将终止所有运行时间长于 `FLUSH TABLES WITH READ LOCK` .

# Improved log statements[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/log-enhancements.html#improved-log-statements) 改进的日志语句 ¶

Percona XtraBackup is an open-source command-line utility. Command-line tools have limited interaction with the background operations and the logs provide the progress of an operation or more information about errors.
Percona XtraBackup是一个开源的命令行实用程序。命令行工具与后台操作的交互有限，日志提供操作的进度或有关错误的详细信息。

The error logs did not have a standard structure and the log statements varied in the following ways:
错误日志没有标准结构，日志语句在以下方面有所不同：

- The backup log statement header has the name of the module, `xtrabackup`, which generated the statement but no timestamp:
  备份日志语句头具有模块的名称， `xtrabackup` 该模块生成了语句，但没有时间戳：



```
 $ xtrabackup: recognized client arguments: --parallel=4 --target-dir=/data/backups/ --backup=1
```

The output should be similar to the following:
输出应类似于以下内容：



<details class="example" open="" data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418">
<summary data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418"><pre><span></span><code tabindex="0">./bin/xtrabackup version 8.3.0-1 based on MySQL server 8.3 Linux (x86_64) (revision id: b0f75188ca3)
</code></pre></div>
</details>

- The copy-back log statement has a timestamp but no module name. The  timestamp is a mix of UTC and the local timezone.
  copy-back log 语句具有时间戳，但没有模块名称。时间戳是 UTC 和本地时区的混合。

```
220322 19:05:13 [01] Copying undo_001 to /data/backups/undo_001
```

- The following prepare log statements do not have header information,  which makes diagnosing an issue more difficult.
  以下 prepare 日志语句没有标头信息，这使得诊断问题更加困难。

```
Completed space ID check of 1008 files.
Initializing buffer pool, total size = 128.000000M, instances = 1, chunk size =128.000000M
Completed initialization of buffer pool
If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
```

## Log statement structure[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/log-enhancements.html#log-statement-structure) 日志语句结构 ¶

The improved log structure is displayed in the backup, prepare, move-back/copy-back error logs.
改进的日志结构显示在备份、准备、移回/复制回错误日志中。

Each log statement has the following attributes:
每个日志语句都具有以下属性：

- Timestamp - a timestamp for when the event occurred in a UTC format.
  时间戳 - 事件以 UTC 格式发生的时间戳。
- Severity - the severity level of a statement indicates the importance of an event.
  严重性 - 语句的严重性级别指示事件的重要性。
- ID - this identifier is currently not used but may be used in future versions.
  ID - 此标识符当前未使用，但可能会在将来的版本中使用。
- Context - the name of the module that issued the log statement, such as XtraBackup, InnoDB, or Server.
  Context - 发出日志语句的模块的名称，例如 XtraBackup、InnoDB 或 Server。
- Message - a description of the event generated by the module.
  消息 - 模块生成的事件的描述。

An example of a `prepare` log that is generated with the improved structure. The uniformity of the headers makes it easier to follow an operation’s progress or review the log to diagnose issues.
使用改进的结构生成的 `prepare` 日志示例。标头的统一性使跟踪操作进度或查看日志以诊断问题变得更加容易。

<details class="example" open="" data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418">
<summary data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="152d8485-378a-4c01-aef4-4cf2488ec418"><pre><span></span><code tabindex="0">2022-03-22T19:15:36.142247+05:30 0 [Note] [MY-011825] [Xtrabackup] This target seems to be not prepared yet.
2022-03-22T19:15:36.142792+05:30 0 [Note] [MY-013251] [InnoDB] Number of pools: 1
2022-03-22T19:15:36.149212+05:30 0 [Note] [MY-011825] [Xtrabackup] xtrabackup_logfile detected: size=8388608, start_lsn=(33311656)
2022-03-22T19:15:36.149998+05:30 0 [Note] [MY-011825] [Xtrabackup] using the following InnoDB configuration for recovery:
2022-03-22T19:15:36.150023+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_data_home_dir = .
2022-03-22T19:15:36.150036+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_data_file_path = ibdata1:12M:autoextend
2022-03-22T19:15:36.150078+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_group_home_dir = .
2022-03-22T19:15:36.150095+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_files_in_group = 1
2022-03-22T19:15:36.150111+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_file_size = 8388608
2022-03-22T19:15:36.151667+05:30 0 [Note] [MY-011825] [Xtrabackup] inititialize_service_handles suceeded
2022-03-22T19:15:36.151903+05:30 0 [Note] [MY-011825] [Xtrabackup] using the following InnoDB configuration for recovery:
2022-03-22T19:15:36.151926+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_data_home_dir = .
2022-03-22T19:15:36.151954+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_data_file_path = ibdata1:12M:autoextend
2022-03-22T19:15:36.151976+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_group_home_dir = .
2022-03-22T19:15:36.151991+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_files_in_group = 1
2022-03-22T19:15:36.152004+05:30 0 [Note] [MY-011825] [Xtrabackup] innodb_log_file_size = 8388608
2022-03-22T19:15:36.152021+05:30 0 [Note] [MY-011825] [Xtrabackup] Starting InnoDB instance for recovery.
2022-03-22T19:15:36.152035+05:30 0 [Note] [MY-011825] [Xtrabackup] Using 104857600 bytes for buffer pool (set by --use-memory parameter)
</code></pre></div>
</details>

## Get expert help[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/log-enhancements.html#get-expert-help) 获取专家帮助 ¶

# lock-ddl-per-table option improvements[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/lock-options.html#lock-ddl-per-table-option-improvements) lock-ddl-per-table 选项改进 ¶

To block DDL statements on an instance, Percona Server implemented LOCK TABLES FOR BACKUP. Percona XtraBackup uses this lock for the duration of the backup. This lock does not affect DML statements.
为了阻止实例上的 DDL 语句，Percona Server 实现了 LOCK TABLES FOR BACKUP。Percona XtraBackup在备份期间使用此锁。此锁不会影响 DML 语句。

Percona XtraBackup has also implemented `--lock-ddl-per-table`, which blocks DDL statements by using metadata locks (MDL).
Percona XtraBackup还实现了 `--lock-ddl-per-table` ，它使用元数据锁（MDL）阻止DDL语句。

The following procedures describe a simplified backup operation when using `--lock-ddl-per-table`:
以下过程描述了使用 `--lock-ddl-per-table` 时简化的备份操作：

1. Parse and copy all redo logs after the checkpoint mark
   解析并复制检查点标记后的所有重做日志
2. Fork a dedicated thread to continue following new redo log entries
   分叉专用线程以继续跟踪新的重做日志条目
3. List the tablespaces required to copy
   列出复制所需的表空间
4. Iterate through the list. The following steps occur with each listed tablespace:
   循环访问列表。每个列出的表空间都执行以下步骤：
5. Query INFORMATION_SCHEMA.INNODB_TABLES to find which tables belong   to the tablespace ID and take an MDL on the underlying table or tables in   case there is a shared tablespace.
   查询INFORMATION_SCHEMA。INNODB_TABLES查找哪些表属于表空间 ID，并在存在共享表空间的情况下对基础表或表执行 MDL。
6. Copy the tablespace `.ibd` files.
   复制表空间 `.ibd` 文件。

The backup process may encounter a redo log event, generated by the bulk load operations, which notifies backup tools that data file changes have been omitted from the redo log. This event is an `MLOG_INDEX_LOAD`. If this event is found by the redo follow thread, the backup continues and assumes the backup is safe because the MDL protects tablespaces already copied and the MLOG_INDEX_LOAD event is for a tablespace that is not copied.
备份过程可能会遇到由批量加载操作生成的重做日志事件，该事件通知备份工具重做日志中省略了数据文件更改。此事件是 `MLOG_INDEX_LOAD` .如果重做跟踪线程发现此事件，则备份将继续，并假定备份是安全的，因为 MDL 保护已复制的表空间，而 MLOG_INDEX_LOAD 事件用于未复制的表空间。

These assumptions may not be correct and may lead to inconsistent backups.
这些假设可能不正确，并可能导致备份不一致。

## `--lock-ddl-per-table` redesign[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/lock-options.html#-lock-ddl-per-table-redesign) `--lock-ddl-per-table` 重新设计 ¶

The `--lock-ddl-per-table` option has been redesigned to minimize inconsistent backups.
该 `--lock-ddl-per-table` 选项已重新设计，以最大程度地减少不一致的备份。

The following procedure reorders the steps:
以下过程对步骤重新排序：

- The MDL lock acquired at the beginning of the backup
  在备份开始时获取的 MDL 锁
- Scan the redo logs. An `MLOG_INDEX_LOAD` event may be recorded if a `CREATE INDEX` statement has occurred before the backup starts. At this time, the backup process is safe and can parse and accept the event.
  扫描重做日志。如果在备份开始之前发生了 `CREATE INDEX` 语句，则可以记录 `MLOG_INDEX_LOAD` 事件。此时，备份过程是安全的，可以解析和接受事件。
- After the first scan has completed, the follow redo log thread is initiated. This thread stops the backup process if an `MLOG_INDEX_LOAD` event is found.
  第一次扫描完成后，将启动后续重做日志线程。如果发现事件， `MLOG_INDEX_LOAD` 此线程将停止备份过程。
- Gather the tablespace list to copy
  收集要复制的表空间列表
- Copy the `.ibd` files.
  复制 `.ibd` 文件。

## Other improvements[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/lock-options.html#other-improvements) 其他改进 ¶

The following improvements have been added:
添加了以下改进：

- If the `.ibd` file belongs to a temporary table, the `SELECT` query is skipped.
  如果 `.ibd` 文件属于临时表，则跳过 `SELECT` 查询。
- For a FullText Index, an MDL is acquired on the base table.
  对于全文索引，将在基表上获取 MDL。
- A `SELECT` query that acquires an MDL does not retrieve any data.
  获取 MDL 的 `SELECT` 查询不会检索任何数据。

# Smart memory estimation[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/smart-memory-estimation.html#smart-memory-estimation) 智能内存估算 ¶

The Smart memory estimation is [tech preview](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#tech-preview) feature. Before using Smart memory estimation in production, we  recommend that you test restoring production from physical backups in  your environment and also use the alternative backup method for  redundancy.
智能内存估算是技术预览功能。在生产中使用智能内存估算之前，建议测试从环境中的物理备份还原生产环境，并使用备用备份方法进行冗余。

Percona XtraBackup supports the Smart memory estimation feature. With this  feature, Percona XtraBackup computes the memory required for `prepare` phase, while copying redo log entries during the `backup` phase. Percona XtraBackup also considers the number of InnoDB pages to be fetched from the disk.  
Percona XtraBackup支持智能内存估算功能。借助此功能，Percona XtraBackup可以计算 `prepare` 阶段所需的内存，同时在 `backup` 阶段中复制重做日志条目。Percona XtraBackup还会考虑从磁盘中获取的InnoDB页面数。

Percona XtraBackup performs the backup procedure in two steps: 
Percona XtraBackup分两个步骤执行备份过程：

- Creates a backup 创建备份

  To create a backup, Percona XtraBackup copies your InnoDB data files.  While copying the files, Percona XtraBackup runs a background process  that watches the InnoDB redo log, also called the transaction log, and  copies changes from it. 
  要创建备份，Percona XtraBackup 会复制您的 InnoDB 数据文件。在复制文件时，Percona XtraBackup会运行一个后台进程，该进程监视InnoDB重做日志（也称为事务日志），并从中复制更改。

- Prepares a backup 准备备份

  During the `prepare` phase, Percona XtraBackup performs crash recovery against the copied  data files using the copied transaction log file. Percona XtraBackup  reads all the redo log entries into memory, categorizes them by space id and page id, reads the relevant pages into memory, and checks the log  sequence number (LSN) on the page and on the redo log record. If the  redo log LSN is more recent than the page LSN, Percona XtraBackup  applies the redo log changes to the page.
  在此 `prepare` 阶段，Percona XtraBackup使用复制的事务日志文件对复制的数据文件执行崩溃恢复。Percona  XtraBackup将所有重做日志条目读入内存，按空间ID和页面ID对它们进行分类，将相关页面读入内存，并检查页面和重做日志记录上的日志序列号（LSN）。如果重做日志 LSN 比页面 LSN 更新，Percona XtraBackup 会将重做日志更改应用于页面。

  To `prepare` a backup, Percona Xtrabackup uses InnoDB Buffer Pool memory. Percona  Xtrabackup reserves memory to load 256 pages into the buffer pool. The  remaining memory is used for hashing/categorizing the redo log entries.
  对于 `prepare` 备份，Percona Xtrabackup使用InnoDB缓冲池内存。Percona Xtrabackup 保留内存以将 256 页加载到缓冲池中。剩余内存用于对重做日志条目进行哈希/分类。

  The available memory is controlled by the `--use-memory` option. If the available memory on the buffer pool is insufficient, the work is performed in multiple batches. After the batch is processed,  the memory is freed to release space for the next batch. This process  greatly impacts performance as an InnoDB page holds data from multiple  rows. If a change on a page happens in different batches, that page is  fetched and evicted numerous times.
  可用内存由 `--use-memory` 选件控制。如果缓冲池上的可用内存不足，则分批执行工作。处理批处理后，将释放内存，为下一批处理释放空间。此过程极大地影响了性能，因为 InnoDB 页面包含来自多行的数据。如果页面上的更改发生在不同的批次中，则该页面将被多次提取和逐出。

## How does Smart memory estimation work[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/smart-memory-estimation.html#how-does-smart-memory-estimation-work) 智能内存估算如何工作 ¶

To run `prepare`, Percona XtraBackup checks the server’s available free memory and uses that memory up to the limit specified in the [`--use-free-memory-pct`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#use-free-memory-pct) option. Due to backward compatibility, the default value for the `--use-free-memory-pct` option is 0 (zero), which defines the option as disabled. For example, if you set `--use-free-memory-pct=50`, then 50% of the free memory is used to `prepare` a backup.
要运行 `prepare` ，Percona XtraBackup会检查服务器的可用内存，并将该内存使用到 `--use-free-memory-pct` 选项中指定的限制。由于向后兼容性，该 `--use-free-memory-pct` 选项的默认值为 0（零），这会将该选项定义为禁用。例如，如果设置 `--use-free-memory-pct=50` ，则 50% 的可用内存用于 `prepare` 备份。

You can enable or disable the memory estimation during the `backup` phase with the [`--estimate-memory`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#estimate-memory) option. The default value is `OFF`. Enable the memory estimation with  `--estimate-memory=ON`:
您可以使用该 `--estimate-memory` 选项在阶段 `backup` 启用或禁用内存估计。默认值为 `OFF` 。使用以下方法 `--estimate-memory=ON` 启用内存估算：

```
$ xtrabackup --backup --estimate-memory=ON --target-dir=/data/backups/
```

In the `prepare` phase, enable the [`--use-free-memory-pct`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#use-free-memory-pct) option by specifying the percentage of free memory to be used to `prepare` a backup. The `--use-free-memory-pct` value must be larger than 0.
在阶段 `prepare` 中，通过指定用于 `prepare` 备份的可用内存百分比来启用该 `--use-free-memory-pct` 选项。该 `--use-free-memory-pct` 值必须大于 0。

For example: 例如：

```
$ xtrabackup --prepare --use-free-memory-pct=50 --target-dir=/data/backups/
```

## Example of Smart memory estimation usage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/smart-memory-estimation.html#example-of-smart-memory-estimation-usage) 智能内存估算使用示例 ¶

The examples of how Smart memory estimation can improve the time spent on `prepare` in Percona XtraBackup:
智能内存估算如何改善在Percona XtraBackup中 `prepare` 花费的时间的示例：

We back up 16, 32, and 64 tables using sysbench. Each set contains 1M rows. In the `backup` phase, we enable Smart memory estimation with `--estimate-memory=ON`. In the `prepare` phase, we set `--use-free-memory-pct=50`, and Percona XtraBackup uses 50% of the free memory to prepare a backup. The backup is run on an ec2 c4.8xlarge instance (36 vCPUs / 60GB memory / General Purpose SSD (gp2)). 
我们使用 sysbench 备份 16、32 和 64 个表。每组包含 1M 行。在该 `backup` 阶段，我们使用 `--estimate-memory=ON` 启用智能内存估计。在 `prepare` 阶段中，我们设置 `--use-free-memory-pct=50` ，Percona XtraBackup 使用 50% 的可用内存来准备备份。备份在 ec2 c4.8xlarge 实例（36 个 vCPU/60GB 内存/通用型 SSD （gp2））上运行。

During each `--backup`, the following sysbench is run:
在每个 `--backup` 期间，运行以下 sysbench：

```
sysbench --db-driver=mysql --db-ps-mode=disable --mysql-user=sysbench --mysql-password=sysbench --table_size=1000000 --tables=${NUM_OF_TABLES} --threads=24 --time=0 --report-interval=1 /usr/share/sysbench/oltp_write_only.lua run
```

The following table shows the backup details (all measurements are in Gigabytes):
下表显示了备份详细信息（所有测量值均以 GB 为单位）：

|                     | Used memory 已用内存 | Size of XtraBackup log XtraBackup 日志的大小 | Size of backup 备份大小 |
| ------------------- | -------------------- | -------------------------------------------- | ----------------------- |
| 16 tables 16 桌     | 3.375                | 0.7                                          | 4.7                     |
| 32 tables 32 桌     | 8.625                | 2.6                                          | 11                      |
| 64 tables 64 张桌子 | 18.5                 | 5.6                                          | 22                      |

- Used memory - the amount of memory required by Percona XtraBackup with `--use-free-memory-pct=50`
  已用内存 - Percona XtraBackup 所需的 `--use-free-memory-pct=50` 内存量
- Size of XtraBackup log - the size of Percona XtraBackup log file (redo log entries copied during the backup)
  XtraBackup 日志的大小 - Percona XtraBackup 日志文件的大小（备份期间复制的重做日志条目）
- Size of backup - the size of the resulting backup folder
  备份大小 - 生成的备份文件夹的大小

`Prepare` executed without Smart memory estimation uses the default of 128MB for the buffer pool.
 `Prepare` 在没有智能内存估计的情况下执行，缓冲池使用默认值 128MB。

The results are the following:
结果如下：

Note 注意

The following results are based on tests in a specific environment. Your results may vary.
以下结果基于特定环境中的测试。您的结果可能会有所不同。

![Time to run --prepare](https://docs.percona.com/percona-xtrabackup/innovation-release/_static/smart_memory_estimation.png)

- 16 tables result - prepare time dropped to ~5.7% of the original time. An improvement in recovery time of about 17x.
  16 个表结果 - 准备时间下降到原始时间的 ~5.7%。恢复时间缩短约 17 倍。
- 32 tables result - prepare time dropped to ~8,2% of the original time. An improvement in recovery time of about 12x.
  32 表结果 - 准备时间下降到原始时间的 ~8,2%。恢复时间缩短约 12 倍。
- 64 tables result - prepare time dropped to ~9.9% of the original time. An improvement in recovery time of about 10x.
  64 个表结果 - 准备时间下降到原始时间的 ~9.9%。恢复时间缩短约 10 倍。

# Work with binary logs[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/working-with-binary-logs.html#work-with-binary-logs) 使用二进制日志 ¶

The `xtrabackup` binary integrates with the `log_status table`. This integration enables `xtrabackup` to print out the backup’s corresponding binary log position, so that  you can use this binary log position to provision a new replica or  perform point-in-time recovery.
二 `xtrabackup` 进制文件与 `log_status table` .此集成允许 `xtrabackup` 打印出备份的相应二进制日志位置，以便您可以使用此二进制日志位置来置备新副本或执行时间点恢复。

## Find the binary log position[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/working-with-binary-logs.html#find-the-binary-log-position) 查找二进制日志位置 ¶

You can find the binary log position corresponding to a backup after the  backup has been taken. If your backup is from a server with binary  logging enabled, `xtrabackup` creates a file named `xtrabackup_binlog_info` in the target directory. This file contains the binary log file name and position of the exact point when the backup was taken.
在进行备份后，您可以找到与备份相对应的二进制日志位置。如果备份来自启用了二进制日志记录的服务器， `xtrabackup` 请在目标目录中创建一个名为 `xtrabackup_binlog_info` 的文件。此文件包含二进制日志文件名和执行备份时确切点的位置。

<details class="example" open="" data-immersive-translate-walked="4beb43cc-fcc0-4108-bbf5-24a0961de44c">
<summary data-immersive-translate-walked="4beb43cc-fcc0-4108-bbf5-24a0961de44c" data-immersive-translate-paragraph="1">Expected output during the backup stage<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">备份阶段的预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="4beb43cc-fcc0-4108-bbf5-24a0961de44c"><pre><span></span><code>210715 14:14:59 Backup created in directory '/backup/'
MySQL binlog position: filename 'binlog.000002', position '156'
. . .
210715 14:15:00 completed OK!
</code></pre></div>
</details>

## Point-in-time recovery[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/working-with-binary-logs.html#point-in-time-recovery) 时间点恢复 ¶

To perform a point-in-time recovery from an `xtrabackup` backup, you should prepare and restore the backup, and then replay binary logs from the point shown in the `xtrabackup_binlog_info` file.
若要从 `xtrabackup` 备份执行时间点恢复，应准备并还原备份，然后从 `xtrabackup_binlog_info` 文件中显示的点重播二进制日志。

Find a more detailed procedure in the [Point-in-time recovery](https://docs.percona.com/percona-xtrabackup/innovation-release/point-in-time-recovery.html) document.
在时间点恢复文档中查找更详细的过程。

## Set up a new replication replica[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/working-with-binary-logs.html#set-up-a-new-replication-replica) 设置新的复制副本 ¶

To set up a new replica, you should prepare the backup, and restore it to  the data directory of your new replication replica. In the [CHANGE_REPLICATION_SOURCE_TO with the appropriate options](https://dev.mysql.com/doc/refman/8.3/en/change-replication-source-to.html) command, use the binary log filename and position shown in the `xtrabackup_binlog_info` file to start replication.
要设置新副本，应准备备份，并将其还原到新复制副本的数据目录。在具有相应选项命令的CHANGE_REPLICATION_SOURCE_TO中，使用文件中显示的 `xtrabackup_binlog_info` 二进制日志文件名和位置开始复制。

A more detailed procedure is found in  [How to setup a replica for replication in 6 simple steps with Percona XtraBackup](https://docs.percona.com/percona-xtrabackup/innovation-release/set-up-replication.html).
有关更详细的过程，请参阅如何使用 Percona XtraBackup 通过 6 个简单步骤设置复制副本进行复制。

# Percona XtraBackup binaries overview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/binaries-overview.html#percona-xtrabackup-binaries-overview) Percona XtraBackup 二进制文件概述 ¶

Percona XtraBackup contains a set of the following binaries:
Percona XtraBackup包含一组以下二进制文件：

- [xtrabackup](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-binary-overview.html) - a compiled C binary that provides functionality to backup a whole  MySQL database instance with MyISAM, InnoDB, and XtraDB tables.
  xtrabackup - 一个编译的 C 二进制文件，提供使用 MyISAM、InnoDB 和 XtraDB 表备份整个 MySQL 数据库实例的功能。
- [xbcrypt](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-binary-overview.html) - a utility used for encrypting and decrypting backup files.
  xbcrypt - 用于加密和解密备份文件的实用程序。
- [xbstream](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-binary-overview.html) - a utility that allows streaming and extracting files to or from the xbstream format.
  XBSTREAM - 允许将文件流式传输和提取到 XBSTREAM 格式或从 XBSTREAM 格式提取文件的实用程序。
- [xbcloud](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html) - a utility used for downloading and uploading full or part of xbstream archive from or to cloud.
  XBCloudー一个实用程序，用于从云端下载和上传全部或部分XBSriver存档。

The recommended way to take the backup is by using the xtrabackup script. For more information on script options, see [xtrabackup](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-binary-overview.html).
进行备份的推荐方法是使用 xtrabackup 脚本。有关脚本选项的详细信息，请参阅 xtrabackup。

# The xtrabackup binary overview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-binary-overview.html#the-xtrabackup-binary-overview) xtrabackup 二进制文件概述 ¶

The *xtrabackup* binary is a compiled C program that is linked with the *InnoDB* libraries and the standard *MySQL* client libraries.
xtrabackup 二进制文件是一个编译的 C 程序，它与 InnoDB 库和标准 MySQL 客户端库链接。

*xtrabackup* enables point-in-time backups of *InnoDB* / *XtraDB* tables together with the schema definitions, *MyISAM* tables, and other portions of the server.
xtrabackup 支持对 InnoDB/XtraDB 表以及架构定义、MyISAM 表和服务器的其他部分进行时间点备份。

The *InnoDB* libraries provide the functionality to apply a log to data files. The *MySQL* client libraries are used to parse command-line options and configuration file.
InnoDB 库提供了将日志应用于数据文件的功能。MySQL客户端库用于解析命令行选项和配置文件。

The tool runs in either `--backup` or `--prepare` mode, corresponding to the two main functions it performs. There are several variations on these functions to accomplish different tasks, and there is one less commonly used mode, `--print-param`.
该工具以 `--backup` 或 或 `--prepare` 模式运行，对应于它执行的两个主要功能。这些函数有几种变体来完成不同的任务，并且有一种不太常用的模式。 `--print-param` 

# xtrabackup implementation details[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-implementation-details.html#xtrabackup-implementation-details) XtraBackup 实现细节 ¶

This page contains notes on various internal aspects of the *xtrabackup* tool’s operation.
本页包含有关 xtrabackup 工具操作各个内部方面的说明。

## File permissions[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-implementation-details.html#file-permissions) 文件权限 ¶

*xtrabackup* opens the source data files in read-write mode, although it does not modify the files. This means that you must run *xtrabackup* as a user who has permission to write the data files. The reason for opening the files in read-write mode is that *xtrabackup* uses the embedded *InnoDB* libraries to open and read the files, and *InnoDB* opens them in read-write mode because it normally assumes it is going to write to them.
XtraBackup 以读写模式打开源数据文件，但它不会修改文件。这意味着您必须以有权写入数据文件的用户身份运行 xtrabackup。以读写模式打开文件的原因是  xtrabackup 使用嵌入式 InnoDB 库来打开和读取文件，而 InnoDB 以读写模式打开它们，因为它通常假设它要写入它们。

## Tune the OS buffers[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-implementation-details.html#tune-the-os-buffers) 调整操作系统缓冲区 ¶

Because *xtrabackup* reads large amounts of data from the filesystem, it uses `posix_fadvise()` where possible, to instruct the operating system not to try to cache the blocks it reads from disk. Without this hint, the operating system would prefer to cache the blocks, assuming that `xtrabackup` is likely to need them again, which is not the case. Caching such large files can place pressure on the operating system’s virtual memory and cause other processes, such as the database server, to be swapped out. The `xtrabackup` tool avoids this with the following hint on both the source and destination files:
由于 xtrabackup 从文件系统中读取大量数据，因此它会尽可能指示 `posix_fadvise()` 操作系统不要尝试缓存它从磁盘读取的块。如果没有这个提示，操作系统更愿意缓存块，假设 `xtrabackup` 很可能再次需要它们，但事实并非如此。缓存如此大的文件可能会给操作系统的虚拟内存带来压力，并导致其他进程（如数据库服务器）被换掉。该 `xtrabackup` 工具通过对源文件和目标文件的以下提示来避免这种情况：

```
posix_fadvise(file, 0, 0, POSIX_FADV_DONTNEED)
```

In addition, xtrabackup asks the operating system to perform more aggressive read-ahead optimizations on the source files:
此外，xtrabackup 还要求操作系统对源文件执行更积极的预读优化：

```
posix_fadvise(file, 0, 0, POSIX_FADV_SEQUENTIAL)
```

## Copy data files[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-implementation-details.html#copy-data-files) 复制数据文件 ¶

When copying the data files to the target directory, *xtrabackup* reads and writes 1 MB of data at a time. This is not configurable. When copying the log file, *xtrabackup* reads and writes 512 bytes at a time. This is also not possible to configure, and matches InnoDB’s behavior (workaround exists in *Percona Server for MySQL* because it has an option to tune `innodb_log_block_size` for *XtraDB*, and in that case *Percona XtraBackup* will match the tuning).
将数据文件复制到目标目录时，xtrabackup 一次读取和写入 1 MB 的数据。这是不可配置的。复制日志文件时，xtrabackup 一次读取和写入 512  个字节。这也无法配置，并且与InnoDB的行为相匹配（Percona Server for  MySQL中存在解决方法，因为它可以选择针对XtraDB进行调整 `innodb_log_block_size` ，在这种情况下，Percona XtraBackup将匹配调整）。

After reading from the files, `xtrabackup` iterates over the 1MB buffer a page at a time, and checks for page corruption on each page with InnoDB’s `buf_page_is_corrupted()` function. If the page is corrupt, it re-reads and retries up to 10 times for each page. It skips this check on the doublewrite buffer.
从文件中读取后， `xtrabackup` 一次遍历一页 1MB 的缓冲区，并使用 InnoDB `buf_page_is_corrupted()` 的功能检查每个页面上的页面损坏。如果页面已损坏，则每个页面最多会重新读取和重试 10 次。它跳过了对双写缓冲区的此检查。

# xtrabackup 命令行选项 ¶

Here you can find all of the command-line options for the xtrabackup binary.
在这里，您可以找到 xtrabackup 二进制文件的所有命令行选项。

## Modes of operation[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#modes-of-operation) 操作模式 ¶

You invoke xtrabackup in one of the following modes:
您可以在以下模式之一中调用 xtrabackup：

- `--backup` mode to make a backup in a target directory
   `--backup` 模式在目标目录中进行备份
- `--prepare` mode to restore data from a backup (created in `--backup` mode)
   `--prepare` mode 从备份还原数据（在模式下 `--backup` 创建）
- `--copy-back` to copy data from a backup to the original location; to move the data instead of copying the data, use the alternate `--move-back` mode.
   `--copy-back` 将数据从备份复制到原始位置;若要移动数据而不是复制数据，请使用备用 `--move-back` 模式。

When you intend to run xtrabackup in any of these modes, use the following syntax:
当您打算在上述任何模式下运行 xtrabackup 时，请使用以下语法：

```
$ xtrabackup [--defaults-file=#] --backup|--prepare|--copy-back| [OPTIONS]
```

For example, the `--prepare` mode is applied as follows:
例如， `--prepare` 该模式的应用方式如下：

```
$ xtrabackup --prepare --target-dir=/data/backup/mysql/
```

For all modes, the default options are read from the xtrabackup and mysqld configuration groups from the following files in the given order:
对于所有模式，默认选项按给定顺序从以下文件中的 xtrabackup 和 mysqld 配置组中读取：

1. `/etc/my.cnf`
2. `/etc/mysql/my.cnf`
3. `/usr/etc/my.cnf`
4. `~/.my.cnf`.

As the first parameter to xtrabackup in place of the `--defaults-file`, you may supply one of the following:
作为 xtrabackup 的第一个参数来代替 `--defaults-file` ，您可以提供以下参数之一：

- `--print-defaults` - prints the argument list and exit.
   `--print-defaults` - 打印参数列表并退出。
- `--no-defaults` - forbids reading options from any file but the login file.
   `--no-defaults` - 禁止从除登录文件以外的任何文件中读取选项。
- `--defaults-file` -  reads the default options from the given file.
   `--defaults-file` - 从给定文件中读取默认选项。
- `--defaults-extra-file` - reads the specified additional file after the global files.
   `--defaults-extra-file` - 读取全局文件之后指定的附加文件。
- `--defaults-group-suffix` -  reads the configuration groups with the given suffix. The effective  group name is constructed by concatenating the default configuration  groups (xtrabackup and mysqld) with the given suffix.
   `--defaults-group-suffix` - 读取具有给定后缀的配置组。有效的组名称是通过将默认配置组（xtrabackup 和 mysqld）与给定的后缀连接起来构建的。
- `--login-path` - reads the given path from the login file.
   `--login-path` - 从登录文件中读取给定路径。

### InnoDB options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#innodb-options) InnoDB 选项 ¶

A large group of InnoDB options is usually read from the `my.cnf` configuration file, so xtrabackup boots up its embedded InnoDB in the  same configuration as your current server. You typically do not need to specify them explicitly. These options have the same behavior in InnoDB and XtraDB. See [`--innodb-miscellaneous`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#innodb-miscellaneous) for more information.
通常从 `my.cnf` 配置文件中读取一大组 InnoDB 选项，因此 xtrabackup 以与当前服务器相同的配置启动其嵌入式 InnoDB。通常不需要显式指定它们。这些选项在 InnoDB 和 XtraDB 中具有相同的行为。有关详细信息，请参阅 `--innodb-miscellaneous` 。

## Options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#options) 选项 ¶

### apply-log-only[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#apply-log-only)

Usage: `--apply-log-only` 用法： `--apply-log-only` 

This option causes only the redo stage to be performed when preparing a backup. It is essential for incremental backups.
此选项会导致在准备备份时仅执行重做阶段。这对于增量备份至关重要。

### backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#backup) 备份 ¶

Usage: `--backup` 用法： `--backup` 

Make a backup and place it in `--target-dir`. See [Create a full backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-full-backup.html)
进行备份并将其放入 `--target-dir` .请参阅创建完整备份

### backup-lock-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#backup-lock-timeout)

Usage: `--backup-lock-timeout` 用法： `--backup-lock-timeout` 

The timeout in seconds for attempts to acquire metadata locks.
尝试获取元数据锁的超时时间（以秒为单位）。

### backup-lock-retry-count[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#backup-lock-retry-count)

Usage: `--backup-lock-retry-count` 用法： `--backup-lock-retry-count` 

The number of attempts to acquire metadata locks.
尝试获取元数据锁的次数。

### backup-locks[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#backup-locks) 备份锁 ¶

Usage: `--backup-locks` 用法： `--backup-locks` 

This option controls if [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) are used instead of `FLUSH TABLES WITH READ LOCK` on the backup stage. The option has no effect when the server does not support backup locks. This option is enabled by default, disable with [`--no-backup-locks`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-backup-locks).
此选项控制是否使用备份锁而不是 `FLUSH TABLES WITH READ LOCK` 在备份阶段使用备份锁。当服务器不支持备份锁时，该选项不起作用。默认情况下，此选项处于启用状态，请使用 `--no-backup-locks` 禁用。

### check-privileges[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#check-privileges)

Usage: `check-privileges` 用法： `check-privileges` 

This option checks if Percona XtraBackup has all the required privileges. If a required privilege is missing for the current operation, the operation terminates and prints an error message. If a privilege is not needed for the current operation but is missing  and may be necessary for another XtraBackup operation, the operation is  not aborted, and a warning is printed.
此选项检查Percona XtraBackup是否具有所有必需的权限。如果缺少当前操作所需的权限，则该操作将终止并打印错误消息。如果当前操作不需要权限，但缺少权限，并且其他 XtraBackup 操作可能需要该权限，则不会中止该操作，并打印警告。

<details class="example" data-immersive-translate-walked="42dfe119-0ae5-4d0c-8055-0b05b959a8dd" open="">
<summary data-immersive-translate-walked="42dfe119-0ae5-4d0c-8055-0b05b959a8dd" data-immersive-translate-paragraph="1">Example output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">示例输出</font></font></font></summary>
<div class="highlight" data-immersive-translate-walked="42dfe119-0ae5-4d0c-8055-0b05b959a8dd"><pre id="__code_2"><span></span></pre></div></details>

<details class="example" data-immersive-translate-walked="42dfe119-0ae5-4d0c-8055-0b05b959a8dd" open=""><div class="highlight" data-immersive-translate-walked="42dfe119-0ae5-4d0c-8055-0b05b959a8dd"><pre id="__code_2"><code>```{.text .no-copy}
xtrabackup: Error: missing required privilege LOCK TABLES on *.*
xtrabackup: Warning: missing required privilege REPLICATION CLIENT on *.*
```
</code></pre></div>
</details>

### close-files[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#close-files) 关闭文件 ¶

Usage: `--close-files` 用法： `--close-files` 

Do not keep files opened. When xtrabackup opens a tablespace, xtrabackup normally doesn’t close its file handle. This operation allows xtrabackup to handle the DDL operations correctly. However, if the number of tablespaces is huge and can not fit into any limit, there is an option to close file handles once they are no longer accessed. Percona XtraBackup can produce inconsistent backups with this option enabled. Use at your own risk.
不要使文件保持打开状态。当 xtrabackup 打开表空间时，xtrabackup 通常不会关闭其文件句柄。此操作允许 xtrabackup 正确处理 DDL  操作。但是，如果表空间的数量很大，并且无法容纳任何限制，则可以选择在不再访问文件句柄时关闭文件句柄。启用此选项后，Percona  XtraBackup 可能会生成不一致的备份。使用风险自负。

### compress[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress) 压缩 ¶

Usage: `--compress` 用法： `--compress` 

This option tells xtrabackup to compress all output data, including the transaction log and metadata files, using either the `ZSTD` or the `lz4` compression algorithm. `ZSTD` is the default compression algorithm.
此选项指示 xtrabackup 使用 `ZSTD` 或 压缩 `lz4` 算法压缩所有输出数据，包括事务日志和元数据文件。 `ZSTD` 是默认压缩算法。

`--compress` produces `\*.zst` files. You can extract the contents of these files using the `--decompress` option. You can specify the `ZSTD` compression level with the [`--compress-zstd-level`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-zstd-level) option.
 `--compress` 生成 `\*.zst` 文件。您可以使用该 `--decompress` 选项提取这些文件的内容。您可以使用该 `--compress-zstd-level` 选项指定 `ZSTD` 压缩级别。

`--compress=lz4` produces `\*.lz4` files. You can extract the contents of these files by using the `lz4` program.
 `--compress=lz4` 生成 `\*.lz4` 文件。您可以使用该 `lz4` 程序提取这些文件的内容。

### compress-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-chunk-size)

Usage: `--compress-chunk-size=#` 用法： `--compress-chunk-size=#` 

Size of working buffer(s) for compression threads in bytes. The default value is 64K.
压缩线程的工作缓冲区大小（以字节为单位）。默认值为 64K。

### compress-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-threads) 压缩线程 ¶

Usage: `--compress-threads=#` 用法： `--compress-threads=#` 

This option specifies the number of worker threads xtrabackup uses for parallel data compression. This option defaults to `1` and can be used with [parallel](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#parallel) file copying.
此选项指定 xtrabackup 用于并行数据压缩的工作线程数。此选项默认为 `1` 并行文件复制，并可用于并行文件复制。

For example, `--parallel=4 --compress --compress-threads=2` creates four I/O threads that read and pipe the data to two compression threads.
例如， `--parallel=4 --compress --compress-threads=2` 创建四个 I/O 线程，用于读取数据并将其通过管道传递到两个压缩线程。

### compress-zstd-level[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-zstd-level)

Usage: `--compress-zstd-level=#` 用法： `--compress-zstd-level=#` 

This option specifies `ZSTD` compression level. Compression levels provide a trade-off between the  compression speed and the compressed files’ size. A lower compression  level provides faster compression speed but larger file sizes. A higher  compression level provides lower compression speed but smaller file  sizes. For example, set level 1 if the compression speed is the most  important for you. Set level 19 if the size of the compressed files is  the most important.
此选项指定 `ZSTD` 压缩级别。压缩级别在压缩速度和压缩文件大小之间进行权衡。较低的压缩级别提供更快的压缩速度，但文件大小更大。较高的压缩级别提供较低的压缩速度，但文件大小较小。例如，如果压缩速度对您来说最重要，请设置级别 1。如果压缩文件的大小最重要，请设置级别 19。

The default value is 1. Allowed range of values is from 1 to 19.
默认值为 1。允许的值范围为 1 到 19。

### copy-back[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#copy-back) 复制回 ¶

Usage: `--copy-back` 用法： `--copy-back` 

Copy all the files in a previously made backup from the backup directory to their original locations. This option will not copy over existing files unless the [`--force-non-empty-directories`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#force-non-empty-directories) option is specified.
将以前创建的备份中的所有文件从备份目录复制到其原始位置。除非指定了该选项， `--force-non-empty-directories` 否则此选项不会复制现有文件。

### core-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#core-file) 核心文件 ¶

Usage: `--core-file` 用法： `--core-file` 

Write core on fatal signals.
在致命信号上写核心。

### databases[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#databases) 数据库 ¶

Usage: `--databases=#` 用法： `--databases=#` 

This option specifies a list of databases and tables that should be backed up. The option accepts the list of the form `"databasename1[.table_name1] databasename2[.table_name2] . . ."`.
此选项指定应备份的数据库和表的列表。该选项接受表单 `"databasename1[.table_name1] databasename2[.table_name2] . . ."` 的列表。

### databases-exclude[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#databases-exclude)

Usage: `--databases-exclude=name` 用法： `--databases-exclude=name` 

Databases are excluded based on name. This option operates the same way as `--databases` but excludes the matched names from the backup.
数据库根据名称排除。此选项的操作方式与 `--databases` 备份相同，但会从备份中排除匹配的名称。

This option has a higher priority than `--databases`.
此选项的优先级高于 `--databases` 。

### databases-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#databases-file) databases-文件 ¶

Usage: `--databases-file=#` 用法： `--databases-file=#` 

This option specifies the path to the file containing the list of databases and tables that should be backed up. The file can contain the list elements of the form `databasename1[.table_name1]`, one element per line.
此选项指定包含应备份的数据库和表列表的文件的路径。该文件可以包含表单 `databasename1[.table_name1]` 的列表元素，每行一个元素。

### datadir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#datadir)

Usage: `--datadir=DIRECTORY` 用法： `--datadir=DIRECTORY` 

The source directory for the backup. This should be the same as the datadir for your server, so it should be read from `my.cnf` if that exists; otherwise, specify the directory on the command line.
备份的源目录。这应该与服务器的 datadir 相同，因此如果存在，则应从 `my.cnf` 中读取它;否则，请在命令行上指定目录。

When combined with the [`--copy-back`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#copy-back) or the [`--move-back`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#move-back) option, this option refers to the destination directory.
当与 `--copy-back` 或 选项 `--move-back` 结合使用时，此选项引用目标目录。

To perform a backup, you must have the `READ` and `EXECUTE` permissions at a filesystem level in the server’s datadir.
要执行备份，您必须在服务器的 datadir 中具有文件系统级别的 `READ` and `EXECUTE` 权限。

### debug-sleep-before-unlock[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#debug-sleep-before-unlock) debug-sleep-before-unlock（解锁前调试睡眠） ¶

Usage: `--debug-sleep-before-unlock=#` 用法： `--debug-sleep-before-unlock=#` 

This option is only used by the xtrabackup test suite.
此选项仅供 xtrabackup 测试套件使用。

### debug-sync[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#debug-sync)

Usage: `--debug-sync=name` 用法： `--debug-sync=name` 

This option is only used by the xtrabackup test suite.
此选项仅供 xtrabackup 测试套件使用。

### decompress[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#decompress) 解压 ¶

Usage: `--decompress` 用法： `--decompress` 

Decompresses all files in a backup previously made with the `--compress` option. The `--parallel` option lets multiple files be decrypted simultaneously.
解压缩以前使用该 `--compress` 选项创建的备份中的所有文件。该 `--parallel` 选项允许同时解密多个文件。

Percona XtraBackup does not automatically remove the compressed files. Users should use the `--remove-original` option to clean up the backup directory.
Percona XtraBackup不会自动删除压缩文件。用户应使用该 `--remove-original` 选项清理备份目录。

### decompress-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#decompress-threads) 解压线程 ¶

Usage: `--decompress-threads=#` 用法： `--decompress-threads=#` 

Force xbstream to use the specified number of threads for decompressing.
强制 xbstream 使用指定数量的线程进行解压。

### decrypt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#decrypt) 解密 ¶

Usage: `--decrypt=ENCRYPTION-ALGORITHM` 用法： `--decrypt=ENCRYPTION-ALGORITHM` 

Decrypts all files with the `xbcrypt` extension in a backup previously made with [`--encrypt`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt) option. The [`--parallel`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#parallel) option lets multiple files be decrypted simultaneously. Percona XtraBackup doesn’t automatically remove the encrypted files; use `--`remove-original`](#remove-original) option.
解密之前使用 `--encrypt` 选项进行的备份中带有扩展 `xbcrypt` 名的所有文件。该 `--parallel` 选项允许同时解密多个文件。Percona XtraBackup不会自动删除加密文件;使用 `--` remove-original']（#remove-original） 选项。

### defaults-extra-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#defaults-extra-file) defaults-extra-文件 ¶

Usage: `--defaults-extra-file=[MY.CNF]` 用法： `--defaults-extra-file=[MY.CNF]` 

Read this file after the global files are read. The option must be the first option on the command line.
读取全局文件后读取此文件。该选项必须是命令行上的第一个选项。

### defaults-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#defaults-file) defaults-文件 ¶

Usage: `--defaults-file=[MY.CNF]` 用法： `--defaults-file=[MY.CNF]` 

Only read default options from the given file. The value must be the first option on the command line and cannot be a symbolic link.
仅从给定文件中读取默认选项。该值必须是命令行上的第一个选项，并且不能是符号链接。

### defaults-group[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#defaults-group)

Usage: `--defaults-group=GROUP-NAME` 用法： `--defaults-group=GROUP-NAME` 

This option sets the group that should be read from the configuration file and is needed for `mysqld_multi` deployments.
此选项设置应从配置文件中读取的组，以及 `mysqld_multi` 部署所需的组。

### defaults-group-suffix[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#defaults-group-suffix)

Usage: `--defaults-group-suffix=#` 用法： `--defaults-group-suffix=#` 

Also reads groups with concat(group, suffix).
还读取带有 concat（group， suffix） 的组。

### dump-innodb-buffer-pool[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#dump-innodb-buffer-pool)

Usage: `--dump-innodb-buffer-pool` 用法： `--dump-innodb-buffer-pool` 

This option controls creating a new dump of the buffer pool content.
此选项控制创建缓冲池内容的新转储。

The xtrabackup binary requests the server to start the buffer pool dump.  This operation may take time to complete and is done in the background.  The beginning of a backup with the option reports that the dump has been completed.
xtrabackup 二进制文件请求服务器启动缓冲池转储。此操作可能需要一些时间才能完成，并且在后台完成。带有该选项的备份的开头报告转储已完成。

```
$ xtrabackup --backup --dump-innodb-buffer-pool --target-dir=/home/user/backup
```

By default, this option is set to OFF.
默认情况下，此选项设置为 OFF。

If [`innodb_buffer_pool_dump_status`](https://dev.mysql.com/doc/refman/8.3/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status) reports that there is a running dump of the buffer pool, xtrabackup waits for the dump to complete using the value of [`--dump-innodb-buffer-pool-timeout`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#dump-innodb-buffer-pool-timeout)
如果报告缓冲池存在正在运行的转储，则 `innodb_buffer_pool_dump_status` xtrabackup 会使用 `--dump-innodb-buffer-pool-timeout` 

The file `ib_buffer_pool` stores the tablespace ID and page ID data used to warm up the buffer pool sooner.
该文件 `ib_buffer_pool` 存储用于更快地预热缓冲池的表空间 ID 和页面 ID 数据。

### dump-innodb-buffer-pool-pct[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#dump-innodb-buffer-pool-pct)

Usage: `--dump-innodb-buffer-pool-pct` 用法： `--dump-innodb-buffer-pool-pct` 

This option contains the percentage of the most recently used buffer pool pages to dump.
此选项包含要转储的最近使用的缓冲池页的百分比。

This option is effective if `--dump-innodb-buffer-pool` option is set to ON. If this option contains a value, xtrabackup sets the MySQL system variable [`innodb_buffer_pool_dump_pct`](https://dev.mysql.com/doc/refman/8.3/en/innodb-parameters.html#sysvar_innodb_buffer_pool_dump_pct). As soon as the buffer pool dump completes or is stopped (see `--dump-innodb-buffer-pool-timeout`), the value of the MySQL system variable is restored.
如果 `--dump-innodb-buffer-pool` 选项设置为 ON，则此选项有效。如果此选项包含值，则 xtrabackup 将设置 MySQL 系统变量 `innodb_buffer_pool_dump_pct` 。一旦缓冲池转储完成或停止（请参阅 `--dump-innodb-buffer-pool-timeout` ），MySQL 系统变量的值就会恢复。

### dump-innodb-buffer-pool-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#dump-innodb-buffer-pool-timeout)

Usage: `--dump-innodb-buffer-pool-timeout` 用法： `--dump-innodb-buffer-pool-timeout` 

This option contains the number of seconds that xtrabackup should monitor the value of [`innodb_buffer_pool_dump_status`](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status) to determine if the buffer pool dump has been completed.
此选项包含 xtrabackup `innodb_buffer_pool_dump_status` 应监视的秒数，以确定缓冲池转储是否已完成。

This option is used in combination with [`--dump-innodb-buffer-pool`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#dump-innodb-buffer-pool). By default, it is set to 10 seconds.
此选项与 `--dump-innodb-buffer-pool` 结合使用。默认情况下，它设置为 10 秒。

### encrypt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt) 加密 ¶

Usage: `--encrypt=ENCRYPTION_ALGORITHM` 用法： `--encrypt=ENCRYPTION_ALGORITHM` 

This option instructs xtrabackup to encrypt backup copies of InnoDB data files using the algorithm specified in the ENCRYPTION_ALGORITHM. Currently supported algorithms are: `AES128`, `AES192` and `AES256`
此选项指示 xtrabackup 使用ENCRYPTION_ALGORITHM中指定的算法加密 InnoDB 数据文件的备份副本。目前支持的算法包括： `AES128` 和 `AES192` `AES256` 

### encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt-key) 加密密钥 ¶

Usage: `--encrypt-key=ENCRYPTION_KEY` 用法： `--encrypt-key=ENCRYPTION_KEY` 

A proper length encryption key to use. This key can be viewed as part of  the process info. We do not recommend using this option with  uncontrolled access to the machine.
要使用的适当长度的加密密钥。此键可以作为进程信息的一部分进行查看。我们不建议将此选项用于对本机的不受控制的访问。

### encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt-key-file) 加密密钥文件 ¶

Usage: `--encrypt-key-file=ENCRYPTION_KEY_FILE` 用法： `--encrypt-key-file=ENCRYPTION_KEY_FILE` 

The name of a file where the raw key of the appropriate length can be read from. The file must be a simple binary (or text) file that contains exactly the key to be used.
可以从中读取适当长度的原始密钥的文件的名称。该文件必须是简单的二进制（或文本）文件，其中正好包含要使用的密钥。

It is passed directly to the xtrabackup child process. See the xtrabackup documentation for more details.
它直接传递给 xtrabackup 子进程。有关更多详细信息，请参阅 xtrabackup 文档。

### encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt-threads) 加密线程 ¶

Usage: `--encrypt-threads=#` 用法： `--encrypt-threads=#` 

This option specifies the number of worker threads that will be used for parallel encryption/decryption. See the xtrabackup documentation for more details.
此选项指定将用于并行加密/解密的工作线程数。有关更多详细信息，请参阅 xtrabackup 文档。

### encrypt-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt-chunk-size) 加密块大小 ¶

Usage: `--encrypt-chunk-size=#` 用法： `--encrypt-chunk-size=#` 

This option specifies the size of the internal working buffer for each encryption thread, measured in bytes. It is passed directly to the xtrabackup child process.
此选项指定每个加密线程的内部工作缓冲区的大小（以字节为单位）。它直接传递给 xtrabackup 子进程。

To adjust the chunk size for encrypted files, use [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#read-buffer-size) and this option.
若要调整加密文件的块大小，请使用 `--read-buffer-size` 此选项。

### estimate-memory[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#estimate-memory)

Usage: `--estimate-memory=#` 用法： `--estimate-memory=#` 

This option is in [tech preview](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#tech-preview).
此选项处于技术预览状态。

The option lets you enable or disable the [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/innovation-release/smart-memory-estimation.html) feature. The default value is OFF. Enable the feature by setting `--estimate-memory=ON` in the backup phase and setting the `--use-free-memory-pct` option in the `--prepare` phase. If the `--estimate-memory` setting is disabled, the `--use-free-memory-pct` setting is ignored.
该选项允许您启用或禁用智能内存估计功能。默认值为 OFF。 通过在备份阶段设置 `--estimate-memory=ON` 并在 `--prepare` 阶段中设置 `--use-free-memory-pct` 选项来启用该功能。如果禁用该 `--estimate-memory` 设置，则忽略该 `--use-free-memory-pct` 设置。

An example of how to enable the Smart memory estimation feature:
如何启用智能内存估算功能的示例：

```
$ xtrabackup --backup --estimate-memory=ON --target-dir=/data/backups/
$ xtrabackup --prepare --use-free-memory-pct=50 --target-dir=/data/backups/
```

### export[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#export) 导出 ¶

Usage: `--export` 用法： `--export` 

Create files necessary for exporting tables. For more details, see [Restore individual tables](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html).
创建导出表所需的文件。有关详细信息，请参阅还原单个表。

### extra-lsndir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#extra-lsndir) Extra-LSNDIR （英语：Extra-lsndir） ¶

Usage: `--extra-lsndir=DIRECTORY` 用法： `--extra-lsndir=DIRECTORY` 

(for –backup): save an extra copy of the `xtrabackup_checkpoints` and `xtrabackup_info` files in the specified directory.
（for –backup）：在指定目录中保存 `xtrabackup_checkpoints` and `xtrabackup_info` 文件的额外副本。

### force-non-empty-directories[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#force-non-empty-directories)

Usage: `--force-non-empty-directories` 用法： `--force-non-empty-directories` 

When specified, the `-`-copy-back`and`–move-back` options transfer files to non-empty directories. No existing files are overwritten. If files that need to be copied/moved from the backup directory already exist in the destination directory, the operation fails with an error.
指定后， `-` -copy-back `and` –move-back' 选项将文件传输到非空目录。不会覆盖任何现有文件。如果目标目录中已存在需要从备份目录复制/移动的文件，则操作将失败并显示错误。

### ftwrl-wait-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ftwrl-wait-timeout)

Usage: `--ftwrl-wait-timeout=SECONDS` 用法： `--ftwrl-wait-timeout=SECONDS` 

This option specifies the time in seconds that xtrabackup should wait for queries that would block `FLUSH TABLES WITH READ LOCK` before running it. If there are still such queries when the timeout expires, xtrabackup terminates with an error.
此选项指定 xtrabackup 在运行之前应等待将阻塞 `FLUSH TABLES WITH READ LOCK` 的查询的时间（以秒为单位）。如果超时到期时仍有此类查询，则 xtrabackup 将终止并显示错误。

The default value is `0`, xtrabackup does not wait for queries to complete and starts `FLUSH TABLES WITH READ LOCK` immediately. Where supported, xtrabackup automatically uses the [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify the InnoDB tables.
默认值为 `0` ，xtrabackup 不会等待查询完成并立即启动 `FLUSH TABLES WITH READ LOCK` 。在支持的情况下，xtrabackup 会自动使用备份锁作为复制非 InnoDB 数据的轻量级替代方案 `FLUSH TABLES WITH READ LOCK` ，以避免阻止修改 InnoDB 表的 DML 查询。

### ftwrl-wait-threshold[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ftwrl-wait-threshold)

Usage: `--ftwrl-wait-threshold=SECONDS` 用法： `--ftwrl-wait-threshold=SECONDS` 

This option specifies the query run time threshold which is used by xtrabackup to detect long-running queries with a non-zero value of `--ftwrl-wait-timeout`. `FLUSH TABLES WITH READ LOCK` is not started until such long-running queries exist.
此选项指定查询运行时阈值，xtrabackup 使用该阈值来检测值为 的非零值的 `--ftwrl-wait-timeout` 长时间运行的查询。 `FLUSH TABLES WITH READ LOCK` 在存在此类长时间运行的查询之前，不会启动。

This option has no effect if `--ftwrl-wait-timeout` is `0`. The default value is `60` seconds. The xtrabackup binary automatically uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables when backup locks are supported.
如果 `--ftwrl-wait-timeout` 是 `0` ，则此选项无效。默认值为 `60` seconds。xtrabackup 二进制文件会自动使用备份锁作为轻量级替代方法 `FLUSH TABLES WITH READ LOCK` 来复制非 InnoDB 数据，以避免在支持备份锁时阻止修改 InnoDB 表的 DML 查询。

### ftwrl-wait-query-type[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ftwrl-wait-query-type)

Usage: `--ftwrl-wait-query-type=all|update`This option specifies which queries can be completed before xtrabackup issues the global lock. The default value is `all`.
用法： `--ftwrl-wait-query-type=all|update` 此选项指定在 xtrabackup 发出全局锁之前可以完成哪些查询。默认值为 `all` 。

### galera-info[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#galera-info)

Usage: `--galera-info` 用法： `--galera-info` 

This option creates the `xtrabackup_galera_info` file, which contains the local node state at the backup time. This option should be used when performing the backup of a Percona XtraDB Cluster. The option has no effect when [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) are used to create the backup.
此选项将创建 `xtrabackup_galera_info` 文件，其中包含备份时的本地节点状态。执行 Percona XtraDB 集群备份时应使用此选项。当使用备份锁创建备份时，该选项不起作用。

### generate-new-master-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#generate-new-master-key) 生成新万能密钥 ¶

Usage: `--generate-new-master-key` 用法： `--generate-new-master-key` 

Generate a new master key when doing a copy-back.
执行回复制时生成新的主密钥。

### generate-transition-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#generate-transition-key)

Usage: `--generate-transition-key` 用法： `--generate-transition-key` 

xtrabackup needs to access the same keyring file or vault server during prepare and copy-back operations but it should not depend on whether the server keys have been purged.
XtraBackup 需要在准备和复制操作期间访问相同的密钥环文件或 Vault 服务器，但这不应取决于服务器密钥是否已被清除。

`--generate-transition-key` creates and adds to the keyring a transition key for xtrabackup to use if the master key used for encryption is not found because that key has been rotated and purged.
 `--generate-transition-key` 创建一个转换密钥并将其添加到密钥环中，以便在找不到用于加密的主密钥（因为该密钥已被轮换和清除）时使用 XtraBackup。

### get-server-public-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#get-server-public-key)

Usage: `--get-server-public-key` 用法： `--get-server-public-key` 

Get the server public key
获取服务器公钥

### help[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#help) 帮助 ¶

Usage: `--help` 用法： `--help` 

This option displays information about how to run the program along with  supported options and variables with the default values, where  appropriate.
此选项显示有关如何运行程序的信息，以及支持的选项和具有默认值的变量（如果适用）。

### history[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#history) 历史 ¶

Usage: `--history=NAME` 用法： `--history=NAME` 

This option enables the tracking of backup history in the `PERCONA_SCHEMA.xtrabackup_history` table. You can specify a history series name placed with the current backup’s history record.
此选项允许跟踪表中的 `PERCONA_SCHEMA.xtrabackup_history` 备份历史记录。您可以指定与当前备份的历史记录一起放置的历史记录序列名称。

### host[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#host) 主机 ¶

Usage: `--host=HOST` 用法： `--host=HOST` 

This option accepts a string argument that specifies the host to use when connecting to the database server with TCP/IP. It is passed to the mysql child process without alteration. See mysql –help for details.
此选项接受一个字符串参数，该参数指定使用 TCP/IP 连接到数据库服务器时要使用的主机。它不做任何更改就传递给 mysql 子进程。有关详细信息，请参阅 mysql –help。

### incremental-basedir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-basedir)

Usage: `--incremental-basedir=DIRECTORY` 用法： `--incremental-basedir=DIRECTORY` 

This is the directory that contains the full backup, which is the base dataset for the incremental backups.
这是包含完整备份的目录，该目录是增量备份的基本数据集。

### incremental-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-dir) 增量目录 ¶

Usage: `--incremental-dir=DIRECTORY` 用法： `--incremental-dir=DIRECTORY` 

This is the directory where the incremental backup is combined with the full backup to make a new full backup.
这是将增量备份与完整备份相结合以进行新的完整备份的目录。

### incremental-force-scan[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-force-scan) 增量强制扫描 ¶

Usage: `--incremental-force-scan` 用法： `--incremental-force-scan` 

When creating an incremental backup, force a full scan of the data pages in that instance.
创建增量备份时，请强制对该实例中的数据页进行完全扫描。

### incremental-history-name[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-history-name)

Usage: `--incremental-history-name=name` 用法： `--incremental-history-name=name` 

This option specifies the name of the backup series stored in the `PERCONA_SCHEMA.xtrabackup_history` used as a base for an incremental backup. xtrabackup searches the history table looking for the most recent (highest `innodb_to_lsn`), successful backup in the series and takes the `to_lsn`` value to use as the starting`lsn` for the incremental backup.
此选项指定存储在 `PERCONA_SCHEMA.xtrabackup_history` 用作增量备份基础的备份系列中的名称。XtraBackup 在历史记录表中搜索该系列中最近（最高 `innodb_to_lsn` ）成功的备份，并采用 `to_lsn`` value to use as the starting` LSN' 进行增量备份。

This options is mutually exclusive with [`--incremental-history-uuid`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-history-uuid), [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-basedir), and [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-lsn).
此选项与 `--incremental-history-uuid` 、 `--incremental-basedir` 和 `--incremental-lsn` 互斥。

If no valid lsn can be found, either no series by that name or no successful backups by that name, xtrabackup returns an error.
如果找不到有效的 lsn，则没有该名称的系列或该名称的备份没有成功备份，则 xtrabackup 将返回错误。

The option is used with the `--incremental` option.
该选项与 `--incremental` 选项一起使用。

### incremental-history-uuid[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-history-uuid)

Usage: `--incremental-history-uuid=name` 用法： `--incremental-history-uuid=name` 

This option specifies the Universal Unique Identifier (UUID) of the history record in `PERCONA_SCHEMA.xtrabackup_history` used as the base for an incremental backup.
此选项指定 `PERCONA_SCHEMA.xtrabackup_history` 用作增量备份基础的历史记录的通用唯一标识符 （UUID）。

This options is mutually exclusive with [`--incremental-history-name`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-history-name), [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-basedir), and [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-lsn).
此选项与 `--incremental-history-name` 、 `--incremental-basedir` 和 `--incremental-lsn` 互斥。

If there is no success record with that UUID, xtrabackup returns an error.
如果该 UUID 没有成功记录，xtrabackup 将返回错误。

The option is used with the `-–incremental` option.
该选项与 `-–incremental` 选项一起使用。

### incremental-lsn[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-lsn) 增量 lsn ¶

Usage: `--incremental-lsn=LSN` 用法： `--incremental-lsn=LSN` 

When creating an incremental backup, you can specify the log sequence number (LSN), a single 64-bit integer, instead of the  [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#incremental-basedir).
创建增量备份时，可以指定日志序列号 （LSN），即单个 64 位整数，而不是 `--incremental-basedir` .

Important 重要

Percona XtraBackup does not detect if an incorrect LSN value is specified; the backup is unusable. Be careful!
Percona XtraBackup不会检测到是否指定了不正确的LSN值;备份不可用。小心！

### innodb[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#innodb)

Usage: `--innodb=name` 用法： `--innodb=name` 

This option is ignored for MySQL option compatibility.
为了实现 MySQL 选项兼容性，将忽略此选项。

### innodb-miscellaneous[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#innodb-miscellaneous) innodb-杂项 ¶

Usage: `--innodb-miscellaneous xtrabackup boots up its embedded InnoDB with the same configuration as  your current server using the InnoDB options read from that server's`my.cnf` file. You do not need to specify these options explicitly.
用法： `--innodb-miscellaneous xtrabackup boots up its embedded InnoDB with the same configuration as  your current server using the InnoDB options read from that server's` my.cnf' 文件。您不需要显式指定这些选项。

These options behave the same in either InnoDB or XtraDB.
这些选项在 InnoDB 或 XtraDB 中的行为相同。

### keyring-file-data[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#keyring-file-data) 密钥环文件数据 ¶

Usage: `--keyring-file-data=FILENAME` 用法： `--keyring-file-data=FILENAME` 

Defines the path to the keyring file. You can combine this option with [`--xtrabackup-plugin-dir`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#xtrabackup-plugin-dir).
定义密钥环文件的路径。您可以将此选项与 `--xtrabackup-plugin-dir` .

### kill-long-queries-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#kill-long-queries-timeout)

Usage: `--kill-long-queries-timeout=SECONDS` 用法： `--kill-long-queries-timeout=SECONDS` 

This option specifies the number of seconds xtrabackup waits between starting `FLUSH TABLES WITH READ LOCK` and killing those queries that block it. The default value is 0 (zero) seconds, which means xtrabackup does not kill any queries.
此选项指定 xtrabackup 在启动 `FLUSH TABLES WITH READ LOCK` 和终止阻止它的查询之间等待的秒数。默认值为 0（零）秒，这意味着 xtrabackup 不会终止任何查询。

To use this option xtrabackup user should have the `PROCESS` and `SUPER` privileges.
要使用此选项，xtrabackup 用户应具有 `PROCESS` and `SUPER` 权限。

Where supported, xtrabackup automatically uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
在支持的情况下，xtrabackup 会自动使用备份锁作为复制非 InnoDB 数据的轻量级替代方案 `FLUSH TABLES WITH READ LOCK` ，以避免阻止修改 InnoDB 表的 DML 查询。

### kill-long-query-type[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#kill-long-query-type)

Usage: `--kill-long-query-type=all|select` 用法： `--kill-long-query-type=all|select` 

This option specifies which queries should be killed to unblock the global lock. The default value is “select”.
此选项指定应终止哪些查询以取消阻止全局锁。默认值为“select”。

### lock-ddl[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#lock-ddl)

Usage: `--lock-ddl` 用法： `--lock-ddl` 

Enabled by default to ensure that any DDL event does not corrupt the backup.  Any DML events continue to occur. A DDL lock protects table and view  definitions.
默认情况下启用以确保任何 DDL 事件不会损坏备份。任何 DML 事件都会继续发生。DDL 锁保护表和视图定义。

If the option is disabled, a backup continues while concurrent DDL events  are executed. These backups are invalid and fail in the Prepare step.
如果禁用该选项，则在执行并发 DDL 事件时继续备份。这些备份无效，并且在“准备”步骤中失败。

Use a [safe-slave-backup](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#safe-slave-backup) option to stop a SQL replica thread before copying the InnoDB files.
在复制 InnoDB 文件之前，使用 safe-slave-backup 选项停止 SQL 副本线程。

### lock-ddl-per-table[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#lock-ddl-per-table)

Usage: `--lock-ddl-per-table` 用法： `--lock-ddl-per-table` 

Deprecated. Use the [`–lock-ddl`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#lock-ddl) option instead
荒废的。请改用该 `–lock-ddl` 选项

Lock DDL for each table before xtrabackup starts to copy it and until the backup is completed.
在 xtrabackup 开始复制每个表之前锁定每个表的 DDL，直到备份完成。

### lock-ddl-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#lock-ddl-timeout)

Usage: `--lock-ddl-timeout` 用法： `--lock-ddl-timeout` 

If `LOCK TABLES FOR BACKUP` or `LOCK INSTANCE FOR BACKUP` does not return within a given time, abort the backup.
如果 `LOCK TABLES FOR BACKUP` 在给定时间内返回或 `LOCK INSTANCE FOR BACKUP` 未返回，则中止备份。

### log[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#log) 日志 ¶

Usage: `--log` 用法： `--log` 

This option is ignored for MySQL
对于 MySQL，将忽略此选项

### log-bin[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#log-bin) 日志 ¶

Usage: `--log-bin` 用法： `--log-bin` 

The base name for the log sequence.
日志序列的基本名称。

### log-bin-index[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#log-bin-index)

Usage: `--log-bin-index=name` 用法： `--log-bin-index=name` 

The file that stores the names for binary log files.
存储二进制日志文件名称的文件。

### log-copy-interval[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#log-copy-interval)

Usage: `--log-copy-interval=#` 用法： `--log-copy-interval=#` 

This option specifies the time interval between checks done by the log copying thread in milliseconds. The default value is 1 second.
此选项指定日志复制线程完成的检查之间的时间间隔（以毫秒为单位）。默认值为 1 秒。

### login-path[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#login-path) 登录路径 ¶

Usage: `--login-path` 用法： `--login-path` 

Read the given path from the login file.
从登录文件中读取给定路径。

### move-back[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#move-back) 后移 ¶

Usage: `--move-back` 用法： `--move-back` 

Move all files in a previous backup from the backup directory to their original locations.
将上一个备份中的所有文件从备份目录移动到其原始位置。

Use this option with caution since the operation removes backup files.
请谨慎使用此选项，因为该操作会删除备份文件。

### no-backup-locks[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-backup-locks) 无备份锁 ¶

Usage: `--no-backup-locks` 用法： `--no-backup-locks` 

Explicity disables the [`--backup-locks`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#backup-locks) option which is enabled by default.
显式禁用默认启用的 `--backup-locks` 选项。

### no-defaults[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-defaults) 无默认值 ¶

Usage: `--no-defaults` 用法： `--no-defaults` 

The default options are only read from the login file.
默认选项仅从登录文件中读取。

### no-lock[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-lock) 无锁 ¶

Usage: `--no-lock` 用法： `--no-lock` 

Disables the table lock with `FLUSH TABLES WITH READ LOCK`. Use it only if all your tables are InnoDB and you do not  care about the binary log position of the backup. This option shouldn’t be  used if any DDL statements are being executed or updates are happening on non-InnoDB tables; this includes the system MyISAM tables  in the mysql database. Otherwise, those operations could lead to an  inconsistent backup.
使用 `FLUSH TABLES WITH READ LOCK` 禁用表锁定。仅当您的所有表都是 InnoDB 并且您不关心备份的二进制日志位置时才使用它。如果正在执行任何 DDL  语句或在非 InnoDB 表上进行更新，则不应使用此选项;这包括 mysql 数据库中的系统 MyISAM  表。否则，这些操作可能会导致备份不一致。

Where supported, xtrabackup will automatically use [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
在支持的情况下，xtrabackup 将自动使用备份锁作为复制非 InnoDB 数据的轻量级替代方案 `FLUSH TABLES WITH READ LOCK` ，以避免阻止修改 InnoDB 表的 DML 查询。

If you consider using this option because your backups fail to acquire the lock, maybe incoming replication events prevent the lock from succeeding. Try the `--safe-slave-backup` option to stop the replication replica thread momentarily. The `--safe-slave-backup` option may help the backup to succeed and avoid using this option.
如果因为备份无法获取锁而考虑使用此选项，则传入的复制事件可能会阻止锁成功。尝试暂时停止复制副本线程的 `--safe-slave-backup` 选项。该 `--safe-slave-backup` 选项可能有助于备份成功并避免使用此选项。

### no-server-version-check[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-server-version-check)

Usage: `--no-server-version-check` 用法： `--no-server-version-check` 

The `--no-server-version-check` option disables the server version check.
该 `--no-server-version-check` 选项禁用服务器版本检查。

The default behavior runs a check that compares the source system version  to the Percona XtraBackup version. If the source system version is  higher than the XtraBackup version, the backup is aborted with a  message.
默认行为会运行检查，将源系统版本与 Percona XtraBackup 版本进行比较。如果源系统版本高于 XtraBackup 版本，则备份将中止并显示消息。

Adding the option overrides this check, and the backup proceeds, but there may be issues with the backup.
添加该选项将覆盖此检查，备份将继续进行，但备份可能存在问题。

See [Server Version and Backup Version Comparison](https://docs.percona.com/percona-xtrabackup/innovation-release/server-backup-version-comparison.html) for more information.
有关详细信息，请参阅服务器版本和备份版本比较。

### no-version-check[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#no-version-check)

Usage: `--no-version-check` 用法： `--no-version-check` 

This option disables the version check. 
此选项禁用版本检查。

If you do not pass this option, xtrabackup implicitly enables the automatic version check in the `--backup` mode. 
如果未传递此选项，xtrabackup 将在 `--backup` 该模式下隐式启用自动版本检查。

To disable the version check, invoke xtrabackup and explicitly pass this option.
要禁用版本检查，请调用 xtrabackup 并显式传递此选项。

When the automatic version check is enabled, xtrabackup performs a version check against the server on the backup stage after creating a server connection. xtrabackup sends the following information to the server:
启用自动版本检查后，xtrabackup 会在创建服务器连接后对备份阶段的服务器执行版本检查。XtraBackup 将以下信息发送到服务器：

- MySQL flavour and version
  MySQL 风格和版本
- Operating system name 操作系统名称
- Percona Toolkit version Percona Toolkit 版本
- Perl version Perl 版本

Each piece of information has a unique identifier. This identifier is a MD5 hash value that Percona Toolkit uses to obtain statistics about its use. This information is a random UUID; no client information is collected or stored.
每条信息都有一个唯一的标识符。此标识符是 Percona Toolkit 用于获取有关其使用情况的统计信息的 MD5 哈希值。此信息是随机的 UUID;不会收集或存储任何客户信息。

### open-files-limit[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#open-files-limit)

Usage: `--open-files-limit=#` 用法： `--open-files-limit=#` 

The maximum number of file descriptors to reserve with [setrlimit](https://linux.die.net/man/2/setrlimit)git .
使用 setrlimitgit 保留的最大文件描述符数。

### parallel[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#parallel) 并行 ¶

Usage: `--parallel=#` 用法： `--parallel=#` 

This option specifies the number of threads to use to copy multiple data files concurrently when creating a backup. The default value is 1, there is no concurrent transfer. This option can be used with the `--copy-back` option to copy the user data files in parallel. The redo logs and system tablespaces are copied in the main thread.
此选项指定在创建备份时用于同时复制多个数据文件的线程数。默认值为 1，没有并发传输。此选项可以与并行复制用户数据文件 `--copy-back` 的选项一起使用。重做日志和系统表空间被复制到主线程中。

### password[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#password) 密码 ¶

Usage: `--password=PASSWORD` 用法： `--password=PASSWORD` 

This option accepts a string argument that specifies the password used when connecting to the database.
此选项接受一个字符串参数，该参数指定连接到数据库时使用的密码。

### plugin-load[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#plugin-load) 插件加载 ¶

Usage: `--plugin-load` 用法： `--plugin-load` 

A list of plugins to load.
要加载的插件列表。

### port[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#port) 端口 ¶

Usage: `--port=PORT` 用法： `--port=PORT` 

This option accepts a string argument specifying the TCP/IP port used to  connect to the database server. This option is passed to the mysql child process without alteration.
此选项接受一个字符串参数，该参数指定用于连接到数据库服务器的 TCP/IP 端口。此选项将传递给 mysql 子进程，而不会进行更改。

### prepare[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#prepare) 准备 ¶

Usage: `--prepare` 用法： `--prepare` 

Makes xtrabackup perform a recovery on a backup created with `--backup`, so that the backup data is ready to use.
使 xtrabackup 对使用 `--backup` 创建的备份执行恢复，以便备份数据可供使用。

For details, see [Prepare a full backup](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-full-backup.html).
有关详细信息，请参阅准备完整备份。

### print-defaults[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#print-defaults)

Usage: `--print-defaults` 用法： `--print-defaults` 

Prints the program argument list and exit and must be the first option on the command line.
打印程序参数列表并退出，并且必须是命令行上的第一个选项。

### print-param[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#print-param)

Usage: `--print-param` 用法： `--print-param` 

Prints the parameters that can be used for copying the data files back to their original locations to restore them.
打印可用于将数据文件复制回其原始位置以还原它们的参数。

### read-buffer-size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#read-buffer-size)

Usage: `--read-buffer-size` 用法： `--read-buffer-size` 

Set the read buffer size. The given value is scaled up to page size. The  default size is 10MB. Use this option to increase the xbcloud/xbstream  chunk size from the default size.
设置读取缓冲区大小。给定值将放大到页面大小。默认大小为 10MB。使用此选项可将 xbcloud/xbstream 块大小从默认大小增加到默认大小。

To adjust the chunk size for encrypted files, use [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#read-buffer-size) and [`--encrypt-chunk-size`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#encrypt-chunk-size).
要调整加密文件的块大小，请使用 `--read-buffer-size` 和 `--encrypt-chunk-size` 。

### register-redo-log-consumer[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#register-redo-log-consumer)

Usage: `--register-redo-log-consumer` 用法： `--register-redo-log-consumer` 

This option is disabled by default.
默认情况下，此选项处于禁用状态。

When enabled, this options lets Percona XtraBackup register as a redo log  consumer at the start of the backup. The server does not remove a redo  log that Percona XtraBackup (the consumer) has not yet copied. The  consumer reads the redo log and manually advances the log sequence  number (LSN). The server blocks the writes during the process. The  server determines when to purge the log based on the redo log  consumption.
启用后，此选项允许 Percona XtraBackup 在备份开始时注册为重做日志使用者。服务器不会删除 Percona  XtraBackup（使用者）尚未复制的重做日志。使用者读取重做日志并手动推进日志序列号  （LSN）。服务器在此过程中阻止写入。服务器根据重做日志消耗量确定何时清除日志。

### remove-original[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#remove-original)

Usage: `--remove-original` 用法： `--remove-original` 

This option removes `.qp`, `.xbcrypt` and `.qp.xbcrypt` files after decryption and decompression.
此选项在解密和解压缩后删除 `.qp` 和 `.xbcrypt` `.qp.xbcrypt` 文件。

### rocksdb-datadir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rocksdb-datadir)

Usage: `--rocksdb-datadir` 用法： `--rocksdb-datadir` 

Names the RocksDB data directory
命名 RocksDB 数据目录

### rocksdb-wal-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rocksdb-wal-dir)

Usage: `--rocksdb-wal-dir` 用法： `--rocksdb-wal-dir` 

RocksDB WAL directory. RocksDB WAL 目录。

### rocksdb-checkpoint-max-age[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rocksdb-checkpoint-max-age)

Usage: `--rocksdb-checkpoint-max-age` 用法： `--rocksdb-checkpoint-max-age` 

The checkpoint cannot be older than this number of seconds when the backup is complete.
备份完成后，检查点不能超过此秒数。

### rocksdb-checkpoint-max-count[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rocksdb-checkpoint-max-count)

Usage: `--rocksdb-checkpoint-max-count` 用法： `--rocksdb-checkpoint-max-count` 

Complete the backup even if the checkpoint age requirement has not been met after this number of checkpoints.
即使在此数量的检查点之后仍未满足检查点期限要求，也要完成备份。

### rollback-prepared-trx[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rollback-prepared-trx)

Usage: `--rollback-prepared-trx` 用法： `--rollback-prepared-trx` 

Force rollback prepared InnoDB transactions.
强制回滚准备的 InnoDB 事务。

### rsync[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#rsync)

Usage: `--rsync` 用法： `--rsync` 

Uses the rsync utility to optimize local file transfers. The xtrabackup  binary uses rsync to copy all non-InnoDB files instead of spawning a  separate cp for each file, which can be much faster for servers with  many databases or tables.
使用 rsync 实用程序优化本地文件传输。xtrabackup 二进制文件使用 rsync 复制所有非 InnoDB 文件，而不是为每个文件生成单独的 cp，这对于具有许多数据库或表的服务器来说可能要快得多。

You cannot use this option with [`--stream`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#stream).
此选项不能与 `--stream` 一起使用。

### safe-slave-backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#safe-slave-backup) 安全从属备份 ¶

Usage: `--safe-slave-backup` 用法： `--safe-slave-backup` 

When specified, xtrabackup stops the replica SQL thread just before running `FLUSH TABLES WITH READ LOCK` and waits to start the backup operation until `Slave_open_temp_tables`` in`SHOW STATUS` is zero.
指定后，xtrabackup 会在运行 `FLUSH TABLES WITH READ LOCK` 前停止副本 SQL 线程，并等待启动备份操作，直到 `Slave_open_temp_tables`` in` SHOW STATUS' 为零。

If there are no open temporary tables, the backup takes place, otherwise  the SQL thread is started and stopped until there are no open temporary  tables. The backup fails if `Slave_open_temp_tables` does not become zero after [`--safe-slave-backup-timeout`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#safe-slave-backup-timeout) seconds. The replication SQL thread is restarted when the backup is complete. This option is implemented to deal with [replication and temporary tables](https://dev.mysql.com/doc/refman/8.0/en/replication-features-temptables.html) and isn’t necessary with row-based replication.
如果没有打开的临时表，则进行备份，否则将启动和停止 SQL 线程，直到没有打开的临时表。如果 `Slave_open_temp_tables` 在几秒钟后 `--safe-slave-backup-timeout` 未变为零，则备份将失败。备份完成后，复制 SQL 线程将重新启动。此选项用于处理复制表和临时表，对于基于行的复制不是必需的。

Using a safe-slave-backup option stops the SQL replica thread before copying the InnoDB files.
使用 safe-slave-backup 选项可在复制 InnoDB 文件之前停止 SQL 副本线程。

### safe-slave-backup-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#safe-slave-backup-timeout)

Usage: `--safe-slave-backup-timeout=SECONDS` 用法： `--safe-slave-backup-timeout=SECONDS` 

How many seconds the `--safe-slave-backup` option waits for the `Slave_open_temp_tables` to become zero. The default value is 300 seconds.
该 `--safe-slave-backup` 选项等待 变 `Slave_open_temp_tables` 为零的秒数。默认值为 300 秒。

### secure-auth[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#secure-auth) 安全身份验证 ¶

Usage: `--secure-auth` 用法： `--secure-auth` 

Refuse the client from connecting to the server if it uses the old protocol.  This option is enabled by default. Disable this options with `–skip-secure-auth`.
如果客户端使用旧协议，则拒绝客户端连接到服务器。默认情况下，此选项处于启用状态。使用 `–skip-secure-auth` 禁用此选项。

### server-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#server-id) 服务器 ID ¶

Usage: `--server-id=#` 用法： `--server-id=#` 

The server instance being backed up.
正在备份的服务器实例。

### server-public-key-path[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#server-public-key-path)

Usage: `--server-public-key-path` 用法： `--server-public-key-path` 

The file path to the server public RSA key in the PEM format.
PEM 格式的服务器公有 RSA 密钥的文件路径。

### skip-tables-compatibility-check[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#skip-tables-compatibility-check)

Usage: `--skip-tables-compatibility-check` 用法： `--skip-tables-compatibility-check` 

See [`--tables-compatibility-check`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables-compatibility-check). 请参见 `--tables-compatibility-check` 。

### slave-info[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#slave-info)

Usage: `--slave-info` 用法： `--slave-info` 

This option is useful when backing up a replication replica server. It prints the binary log position of the source server. It also writes the binary log coordinates to the `xtrabackup_slave_info` file as a [`CHANGE MASTER`](https://dev.mysql.com/doc/refman/8.3/en/change-master-to.html) command.
此选项在备份复制副本服务器时非常有用。它打印源服务器的二进制日志位置。它还将二进制日志坐标作为 `CHANGE MASTER` 命令写入 `xtrabackup_slave_info` 文件。

A new replica for this source can be set up by starting a replica server on this backup and issuing a [`CHANGE MASTER`](https://dev.mysql.com/doc/refman/8.3/en/change-master-to.html) command with the binary log position saved in the `xtrabackup_slave_info` file.
可以通过在此备份上启动副本服务器并发出 `CHANGE MASTER` 命令，并将二进制日志位置保存在 `xtrabackup_slave_info` 文件中，来设置此源的新副本。

### socket[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#socket) 套接字 ¶

Usage: `--socket` 用法： `--socket` 

This option accepts a string argument that specifies the socket to use when connecting to the local database server with a UNIX domain socket. It is passed to the MySQL child process without alteration. See mysql –help for details.
此选项接受一个字符串参数，该参数指定使用 UNIX 域套接字连接到本地数据库服务器时要使用的套接字。它不做任何更改就传递给 MySQL 子进程。有关详细信息，请参阅 mysql –help。

### ssl[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl) SSL协议 ¶

Usage: `--ssl` 用法： `--ssl` 

Enable secure connection.
启用安全连接。

### ssl-ca[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-ca)

Usage: `--ssl-ca` 用法： `--ssl-ca` 

The path of the file contains a list of trusted SSL CAs.
文件的路径包含受信任的 SSL CA 列表。

### ssl-capath[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-capath)

Usage: `--ssl-capath` 用法： `--ssl-capath` 

The directory path that contains trusted SSL CA files in PEM format.
包含 PEM 格式的受信任 SSL CA 文件的目录路径。

### ssl-cert[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-cert) SSL-证书 ¶

Usage: `--ssl-cert` 用法： `--ssl-cert` 

The path of the file contains the X509 certificate in PEM format.
文件的路径包含 PEM 格式的 X509 证书。

### ssl-cipher[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-cipher) SSL-密码 ¶

Usage: `--ssl-cipher` 用法： `--ssl-cipher` 

The list of the permitted ciphers to use for connection encryption.
允许用于连接加密的密码列表。

### ssl-crl[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-crl)

Usage: `--ssl-crl` 用法： `--ssl-crl` 

The path of the file that contains certificate revocation lists.
包含证书吊销列表的文件的路径。

### ssl-crlpath[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-crlpath)

Usage: `--ssl-crlpath` 用法： `--ssl-crlpath` 

The path of the directory that contains the certificate revocation list files.
包含证书吊销列表文件的目录的路径。

### ssl-fips-mode[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-fips-mode)

Usage: `--ssl-fips-mode` 用法： `--ssl-fips-mode` 

The SSL FIPS mode applies only for OpenSSL; permitted values are OFF, ON, and STRICT.
SSL FIPS 模式仅适用于 OpenSSL;允许的值为 OFF、ON 和 STRICT。

### ssl-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-key)

Usage: `--ssl-key` 用法： `--ssl-key` 

The path of the file that contains the X509 key in PEM format.
包含 PEM 格式的 X509 密钥的文件的路径。

### ssl-mode[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-mode) SSL 模式 ¶

Usage: `--ssl-mode` 用法： `--ssl-mode` 

The security state of connection to the server.
连接到服务器的安全状态。

### ssl-verify-server-cert[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#ssl-verify-server-cert)

Usage: `--ssl-verify-server-cert` 用法： `--ssl-verify-server-cert` 

Verify the server certificate Common Name value against the hostname used when connecting to the server.
根据连接到服务器时使用的主机名验证服务器证书公用名值。

### stream[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#stream) 流 ¶

Usage: `--stream=FORMAT` 用法： `--stream=FORMAT` 

Stream all backup files to the standard output in the specified format. Currently, this option only supports the xbstream format.
以指定格式将所有备份文件流式传输到标准输出。目前，此选项仅支持 xbstream 格式。

### strict[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#strict) 严格 ¶

Usage: `--strict` 用法： `--strict` 

If this option is specified, xtrabackup fails with an error when invalid parameters are passed.
如果指定此选项，则在传递无效参数时，xtrabackup 将失败并显示错误。

### tables[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables) 表格 ¶

Usage: `--tables=name` 用法： `--tables=name` 

A regular expression against which the full table name in the `databasename.tablename` format is matched. If the name matches, the table is backed up. See [Create a partial backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html).
一个正则表达式，与 `databasename.tablename` 格式中的完整表名相匹配。如果名称匹配，则备份该表。请参阅创建部分备份。

### tables-compatibility-check[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables-compatibility-check)

Usage: `--tables-compatibility-check` 用法： `--tables-compatibility-check` 

Enables the engine compatibility warning. The default value is `ON`. To disable the engine compatibility warning, use `--`skip-tables-compatibility-check`](#skip-tables-compatibility-check).
启用引擎兼容性警告。默认值为 `ON` 。要禁用引擎兼容性警告，请使用 `--` skip-tables-compatibility-check']（#skip-tables-compatibility-check）。

### tables-exclude[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables-exclude)

Usage: `--tables-exclude=name` 用法： `--tables-exclude=name` 

Filtering by regexp for table names. Operates the same way as [`--tables`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables), but matched names are excluded from backup. Note that this option has a higher priority than `--tables`.
按正则表达式筛选表名。操作方式与 `--tables` 相同，但从备份中排除匹配的名称。请注意，此选项的优先级高于 `--tables` 。

### tables-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tables-file) tables-文件 ¶

Usage: `--tables-file=name` 用法： `--tables-file=name` 

A file containing one table name per line in `databasename.tablename` format. The backup will be limited to the specified tables.
每行包含一个表名的文件，格式 `databasename.tablename` 。备份将限制为指定的表。

### target-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#target-dir) 目标-目录 ¶

Usage: `--target-dir=DIRECTORY` 用法： `--target-dir=DIRECTORY` 

This option specifies the destination directory for the backup. If the directory does not exist, xtrabackup creates it. If the directory does exist and is empty, xtrabackup will succeed. xtrabackup does not overwrite existing files, however, the operation fails with the operating system error 17, `file exists`.
此选项指定备份的目标目录。如果该目录不存在，则 xtrabackup 会创建该目录。如果该目录确实存在并且为空，则 xtrabackup 将成功。xtrabackup 不会覆盖现有文件，但是，操作失败，操作系统错误 17， `file exists` .

If this option is a relative path, it is interpreted as relative to the current working directory from which xtrabackup is executed.
如果此选项是相对路径，则将其解释为相对于从中执行 xtrabackup 的当前工作目录。

To perform a backup, you need `READ`, `WRITE`, and `EXECUTE` permissions at a filesystem level for the directory that you supply as the value of `--target-dir`.
要执行备份，您需要 `READ` 文件系统级别的 、 `WRITE` 和 `EXECUTE` 权限，以便作为 `--target-dir` 的值提供 的目录。

### innodb-temp-tablespaces-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#innodb-temp-tablespaces-dir)

Usage: `--innodb-temp-tablespaces-dir=DIRECTORY` 用法： `--innodb-temp-tablespaces-dir=DIRECTORY` 

The location of the directory for the temp tablespace files. This path can be absolute.
临时表空间文件的目录位置。此路径可以是绝对路径。

### throttle[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#throttle) 油门 ¶

Usage: `--throttle=#` 用法： `--throttle=#` 

This option limits the number of chunks copied per second. The chunk size is 10 MB.
此选项限制每秒复制的块数。块大小为 10 MB。

To limit the bandwidth to 10 MB/s, set the option to 1.
若要将带宽限制为 10 MB/s，请将选项设置为 1。

### tls-ciphersuites[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tls-ciphersuites)

Usage: `--tls-ciphersuites` 用法： `--tls-ciphersuites` 

The TLS v1.3 cipher to use.
要使用的 TLS v1.3 密码。

### tls-version[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tls-version) tls版本 ¶

Usage: `--tls-version` 用法： `--tls-version` 

Defines which TLS version to use. The permitted values are: TLSv1, TLSv1.1, TLSv1.2, TLSv1.3.
定义要使用的 TLS 版本。允许的值为：TLSv1、TLSv1.1、TLSv1.2、TLSv1.3。

### tmpdir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#tmpdir)

Usage: `--tmpdir=name` 用法： `--tmpdir=name` 

Specify the directory used to store temporary files during the backup
指定备份期间用于存储临时文件的目录

### transition-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#transition-key) 过渡键 ¶

Usage: `--transition-key=name` 用法： `--transition-key=name` 

This option is used to enable processing the backup without accessing the keyring vault server. In this case, xtrabackup derives the AES encryption key from the specified passphrase and uses it to encrypt the tablespace keys of tablespaces being backed up.
此选项用于在不访问密钥环保管库服务器的情况下处理备份。在这种情况下，xtrabackup 从指定的密码短语派生 AES 加密密钥，并使用它来加密正在备份的表空间的表空间密钥。

If `--transition-key` does not have any value, xtrabackup will ask for it. The same passphrase should be specified for the `--prepare` command.
如果 `--transition-key` 没有任何值，xtrabackup 将要求它。应为 `--prepare` 命令指定相同的密码。

### use-free-memory-pct[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#use-free-memory-pct)

Usage: `--use-free-memory-pct` 用法： `--use-free-memory-pct` 

The `--use-free-memory-pct` is a [tech preview](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#tech-preview) option.
这是一个 `--use-free-memory-pct` 技术预览选项。

This option lets you configure the [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/innovation-release/smart-memory-estimation.html) feature. The option controls the amount of free memory that can be used to `--prepare` a backup. The default value is 0 (zero), which defines the option as disabled. For example, if you set `--use-free-memory-pct=50`, then 50% of the free memory is used to `prepare` a backup. The maximum allowed value is 100.
此选项允许您配置智能内存估计功能。该选项控制可用于 `--prepare` 备份的可用内存量。默认值为 0（零），将选项定义为禁用。例如，如果设置 `--use-free-memory-pct=50` ，则 50% 的可用内存用于 `prepare` 备份。允许的最大值为 100。

This option works only if `--estimate-memory` option is enabled. If the `--estimate-memory` option is disabled, the `--use-free-memory-pct` setting is ignored.
仅当启用该选项时 `--estimate-memory` ，此选项才有效。如果禁用该 `--estimate-memory` 选项，则忽略该 `--use-free-memory-pct` 设置。

An example of how to enable the Smart memory estimation feature:
如何启用智能内存估算功能的示例：

```
$ xtrabackup --backup --estimate-memory=ON --target-dir=/data/backups/
$ xtrabackup --prepare --use-free-memory-pct=50 --target-dir=/data/backups/
```

### use-memory[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#use-memory)

Usage: `--use-memory` 用法： `--use-memory` 

This option affects how much memory is allocated and is similar to `innodb_buffer_pool_size`. This option is only relevant in the `--prepare` phase. The default value is 100MB. The recommended value is between 1GB to 2GB. Multiple values are supported if you provide the unit (1MB, 1M, 1GB, 1G).
此选项会影响分配的内存量 `innodb_buffer_pool_size` ，类似于 。此选项仅在 `--prepare` 阶段中相关。默认值为 100MB。建议值介于 1GB 到 2GB 之间。如果提供单位（1MB、1M、1GB、1G），则支持多个值。

### user[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#user) 用户 ¶

Usage: `--user=USERNAME` 用法： `--user=USERNAME` 

This option specifies the MySQL username used when connecting to the server  if that’s not the current user. The option accepts a string argument.  See mysql –help for details.
此选项指定连接到服务器时使用的MySQL用户名（如果该用户不是当前用户）。该选项接受字符串参数。有关详细信息，请参阅 mysql –help。

### version[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#version) 版本 ¶

Usage: `--version` 用法： `--version` 

This option prints xtrabackup version and exits.
此选项打印 xtrabackup 版本并退出。

### xtrabackup-plugin-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#xtrabackup-plugin-dir)

Usage: `--xtrabackup-plugin-dir=DIRNAME` 用法： `--xtrabackup-plugin-dir=DIRNAME` 

The absolute path to the directory that contains the `keyring` plugin.
包含 `keyring` 插件的目录的绝对路径。

# Configure xtrabackup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/configure-xtrabackup.html#configure-xtrabackup) 配置 xtrabackup ¶

All the xtrabackup configuration is done through options, which behave exactly like standard MySQL program options: they can be specified either at the command-line, or through a file such as `/etc/my.cnf`.
所有 xtrabackup 配置都是通过选项完成的，这些选项的行为与标准 MySQL 程序选项完全相同：它们可以在命令行中指定，也可以通过 `/etc/my.cnf` .

The xtrabackup binary reads the `[mysqld]` and `[xtrabackup]` sections from any configuration files, in that order. That is so that it can read its options from your existing MySQL installation, such as the datadir or some of the InnoDB options. If you want to override these, just specify them in the `[xtrabackup]` section, and because it is read later, it will take precedence.
xtrabackup 二进制文件按此顺序从任何配置文件中读取 `[mysqld]` and `[xtrabackup]` 部分。这样它就可以从您现有的MySQL安装中读取其选项，例如datadir或某些InnoDB选项。如果要覆盖这些内容，只需在 `[xtrabackup]` 本节中指定它们，并且由于稍后会读取，因此将优先使用。

You don’t need to put any configuration in your `my.cnf`. You can specify the options on the command-line. Normally, the only thing you may find convenient to place in the `[xtrabackup]` section of your `my.cnf` file is the `target_dir` option. This options adds a default path to the directory for backups.
您无需在 `my.cnf` .您可以在命令行上指定选项。通常，您可能发现唯一方便放置 `my.cnf` 在文件 `[xtrabackup]` 部分的就是 `target_dir` 该选项。此选项将默认路径添加到备份目录。

The following is an example:
下面是一个示例：

```
[xtrabackup]
target_dir = /data/backups/
```

This manual assumes you do not have any file-based configuration for xtrabackup and shows the command-line options.
本手册假定您没有任何基于文件的 xtrabackup 配置，并显示命令行选项。

Please see the option and variable reference for details on all the configuration options.
有关所有配置选项的详细信息，请参阅选项和变量参考。

The xtrabackup binary does not accept exactly the same syntax in the `my.cnf` file as the mysqld server binary does. For historical reasons, the mysqld server binary accepts parameters with a `--set-variable=<variable>=<value>` syntax, which xtrabackup does not understand. If your `my.cnf` file has such configuration directives, you should rewrite them in the `--variable=value` syntax.
xtrabackup 二进制文件不 `my.cnf` 接受与 mysqld 服务器二进制文件完全相同的语法。由于历史原因，mysqld服务器二进制文件接受xtrabackup不理解 `--set-variable=<variable>=<value>` 的语法参数。如果您 `my.cnf` 的文件具有此类配置指令，则应在 `--variable=value` 语法中重写它们。

## System configuration and NFS volumes[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/configure-xtrabackup.html#system-configuration-and-nfs-volumes) 系统配置和 NFS 卷 ¶

The xtrabackup tool requires no special configuration on most systems. However, the storage where the `--target-dir` is located must behave properly when `fsync()` is called. In particular, we have noticed that if you mount the NFS volume without the `sync` option the NFS  volume does not sync the data. As a result, if you back up to an NFS  volume mounted with the async option, and then try to prepare the backup from a different server that also mounts that volume, the data might appear to be corrupt. Use the `sync` mount option to avoid this issue.
xtrabackup 工具在大多数系统上不需要特殊配置。但是，所在的存储 `--target-dir` 在调用时 `fsync()` 必须正常运行。特别是，我们注意到，如果在没有该 `sync` 选项的情况下挂载 NFS 卷，则 NFS 卷不会同步数据。因此，如果备份到使用 async 选项挂载的 NFS 卷，然后尝试从同样装入该卷的其他服务器准备备份，则数据可能已损坏。使用 `sync` 装载选项可避免此问题。

# The xbcrypt binary overview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-binary-overview.html#the-xbcrypt-binary-overview) xbcrypt 二进制文件概述 ¶

To support encryption and decryption of the backups, a new tool `xbcrypt` was introduced to *Percona XtraBackup*.
为了支持备份的加密和解密，Percona XtraBackup引入了一个新工具 `xbcrypt` 。

This utility has been modeled after The [xbstream binary](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-binary-overview.html) to perform encryption and decryption outside of Percona XtraBackup.
此实用程序以 xbstream 二进制文件为模型，用于在 Percona XtraBackup 之外执行加密和解密。

The `XBCRYPT_ENCRYPTION_KEY` environment variable is only used in place of the `--encrypt_key=name` option. You can use the environment variable or command line option. If you use both, the command line option takes precedence over the value  specified in the environment variable.
 `XBCRYPT_ENCRYPTION_KEY` 环境变量仅用于代替 `--encrypt_key=name` 选项。您可以使用环境变量或命令行选项。如果同时使用这两种方法，则命令行选项优先于环境变量中指定的值。

# The xbcrypt command-line options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#the-xbcrypt-command-line-options) xbcrypt 命令行选项 ¶

Usage:  用法：

```
$ xbcrypt[OPTIONS]
```

The `xbcrypt` binary has the following command line options:
二 `xbcrypt` 进制文件具有以下命令行选项：

### decrypt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#decrypt) 解密 ¶

usage: `-d`  `--decrypt`
用法： `-d` `--decrypt` 

Decrypt data input to output.
将数据输入解密为输出。

### encrypt-algo[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#encrypt-algo) 加密算法 ¶

usage: `-a=name` `--encrypt-algo=name`
用法： `-a=name` `--encrypt-algo=name` 

Defines the name of the encryption algorithm.
定义加密算法的名称。

### encrypt-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#encrypt-chunk-size) 加密块大小 ¶

usage: `-s=#` `--encrypt-chunk-size=#`
用法： `-s=#` `--encrypt-chunk-size=#` 

Defines the size of the working buffer for encryption in bytes. The default value is `64000`.
定义加密工作缓冲区的大小（以字节为单位）。默认值为 `64000` 。

### encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#encrypt-key) 加密密钥 ¶

usage: `-k=name` `--encrypt-key=name`
用法： `-k=name` `--encrypt-key=name` 

The name of the encryption key.
加密密钥的名称。

### encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#encrypt-key-file) 加密密钥文件 ¶

usage: `-f=name` `--encrypt-key-file=name`
用法： `-f=name` `--encrypt-key-file=name` 

The name of the file that contains the encryption key.
包含加密密钥的文件的名称。

### encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#encrypt-threads) 加密线程 ¶

usage: `--encrypt-threads=#` 用法： `--encrypt-threads=#` 

This option specifies the number of worker threads used for parallel encryption/decryption. The default value is 1.
此选项指定用于并行加密/解密的工作线程数。默认值为 1。

### input[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#input) 输入 ¶

usage: `-i=name` `--input=name`
用法： `-i=name` `--input=name` 

Defines the name of the optional input file. If the name is not specified, the input reads from the standard input.
定义可选输入文件的名称。如果未指定名称，则输入将从标准输入读取。

### output[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#output) 输出 ¶

usage: `-o=name` `--output=name`
用法： `-o=name` `--output=name` 

Defines the name of the optional output file. If this name is not specified, the output is written to the standard output.
定义可选输出文件的名称。如果未指定此名称，则输出将写入标准输出。

### read-buffer-size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#read-buffer-size)

usage: `--read-buffer-size=#` 用法： `--read-buffer-size=#` 

Read the buffer size. The default value is 10MB. 
读取缓冲区大小。默认值为 10MB。

### verbose[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcrypt-options.html#verbose) 详细 ¶

usage: `-v` `--verbose`
用法： `-v` `--verbose` 

Display status in verbose mode.
以详细模式显示状态。

# The xbstream binary overview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-binary-overview.html#the-xbstream-binary-overview) xbstream 二进制文件概述 ¶

To support simultaneous compression and streaming, the xbstream binary was added to Percona XtraBackup, along with the xbstream format and tar  format. These additions were required to overcome some limitations of  traditional archive formats such as tar, cpio, and others, which did not allow  streaming dynamically generated files. 
为了支持同时压缩和流式传输，将 xbstream 二进制文件以及 xbstream 格式和 tar 格式添加到 Percona XtraBackup  中。这些添加是为了克服传统存档格式（如 tar、cpio 等）的一些限制，这些格式不允许流式传输动态生成的文件。

Other advantages of xbstream over traditional streaming/archive format  include streaming multiple files concurrently (so it is possible to use streaming in the xbstream format together with the –parallel option) and more compact data storage.
与传统的流式处理/存档格式相比，xbstream 的其他优点包括同时流式传输多个文件（因此可以将 xbstream 格式的流式处理与 –parallel 选项一起使用）和更紧凑的数据存储。

For details on the command-line options, see [xbcloud command-line options](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html). When available, the utility tries to minimize its impact on the OS page cache by using the appropriate `posix_fadvise()` calls.
有关命令行选项的详细信息，请参阅 xbcloud 命令行选项。如果可用，该实用程序会尝试使用适当的 `posix_fadvise()` 调用来最大程度地减少其对操作系统页面缓存的影响。

When compression is enabled with xtrabackup all data is compressed, including the transaction log file and metadata files, using the specified compression algorithm. Read more about supported compression algorithms in the [Create a compressed backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-compressed-backup.html) document.
使用 xtrabackup 启用压缩时，将使用指定的压缩算法压缩所有数据，包括事务日志文件和元数据文件。有关支持的压缩算法的更多信息，请参阅创建压缩备份文档。

# The xbstream command-line options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#the-xbstream-command-line-options) xbstream 命令行选项 ¶

```
$ xbstream -c [OPTIONS]
$ xbstream -x [OPTIONS]
```

This utility has a tar-like interface.
此实用程序具有类似 tar 的界面。

The xbstream binary has the following options:
xbstream 二进制文件具有以下选项：

## absolute-names[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#absolute-names) 绝对名称 ¶

Usage: `-absolute-names` 用法： `-absolute-names` 

Do not strip the leading // (slashes) from the file names when creating archives.
创建存档时，不要从文件名中去除前导 //（斜杠）。

## c[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#c)

Usage: `-c` 用法： `-c` 

Streams files specified on the command line to its standard output.
将命令行上指定的文件流式传输到其标准输出。

## decompress[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#decompress) 解压 ¶

Usage: `--decompress` 用法： `--decompress` 

Decompress the individual backup files
解压单个备份文件

## decompress-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#decompress-threads) 解压线程 ¶

Usage: `--decompress-threads=#` 用法： `--decompress-threads=#` 

The number of threads for parallel data decompression. The default value is 1.
用于并行数据解压缩的线程数。默认值为 1。

## decrypt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#decrypt) 解密 ¶

Usage: `--decrypt=name` 用法： `--decrypt=name` 

Specifies that xbstream automatically decrypts encrypted files when extracting input stream. The supported values are: `AES128`, `AES192`, and `AES256`. 
指定 xbstream 在提取输入流时自动解密加密文件。支持的值为： `AES128` 、 `AES192` 和 `AES256` 。

You can specify either `--encrypt-key` or `--encrypt-key-file` to provide the encryption key, but do not use both options. 
您可以指定 `--encrypt-key` or `--encrypt-key-file` 提供加密密钥，但不要同时使用这两个选项。

## directory[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#directory) 目录 ¶

Usage: `--directory=name` 用法： `--directory=name` 

Change the current directory to this named directory before streaming or extracting.
在流式传输或提取之前，将当前目录更改为此命名目录。

## encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#encrypt-key) 加密密钥 ¶

Usage: `--encrypt-key=name` 用法： `--encrypt-key=name` 

Specify the encryption key used. Do not use this option with `--encrypt-key-file`; these options are mutually exclusive.
指定使用的加密密钥。不要将此选项与 `--encrypt-key-file` ;这些选项是互斥的。

## encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#encrypt-key-file) 加密密钥文件 ¶

Usage: `--encrypt-key-file=name` 用法： `--encrypt-key-file=name` 

Specify the file that contains the encryption key. Do not use this option with `--encrypt-key`; these options are mutually exclusive.
指定包含加密密钥的文件。不要将此选项与 `--encrypt-key` ;这些选项是互斥的。

## encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#encrypt-threads) 加密线程 ¶

Usage: `--encrypt-threads-=#` 用法： `--encrypt-threads-=#` 

Specify the number of threads for parallel data encryption. The default value is `1`. 
指定并行数据加密的线程数。默认值为 `1` 。

## extract[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#extract) 提取 ¶

Usage: `--extract` 用法： `--extract` 

Extract to disk the files from the stream to the standard input.
将文件从流提取到磁盘到标准输入。

## fifo-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#fifo-dir)

Usage: `--fifo-dir=name` 用法： `--fifo-dir=name` 

The directory used to read or write named pipes.
用于读取或写入命名管道的目录。

## fifo-streams[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#fifo-streams)

Usage: `--fifo-streams=#` 用法： `--fifo-streams=#` 

The number of FIFO files (named pipes) to use for parallel data file  streaming. To disable the option and send the stream to STDOUT, set the  value to 1. 
用于并行数据文件流的 FIFO 文件（命名管道）的数量。若要禁用该选项并将流发送到 STDOUT，请将值设置为 1。

## fifo-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#fifo-timeout) FIFO-超时 ¶

Usage: `--fifo-timeout=#` 用法： `--fifo-timeout=#` 

The number of seconds to wait for the other end to open the stream. The default value is 60.
等待另一端打开流的秒数。默认值为 60。

## parallel[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#parallel) 并行 ¶

Usage: `--parallel=#` 用法： `--parallel=#` 

Defines the number of worker threads for reading or writing.
定义用于读取或写入的工作线程数。

## x[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#x)

Usage: `-x` 用法： `-x` 

Extracts files from the stream read from its standard input to the current directory unless specified otherwise with the `-c` option. Support for parallel extraction with the `--parallel` option
从从其标准输入读取到当前目录的流中提取文件，除非使用选项 `-c` 另行指定。支持使用 `--parallel` 选项进行并行提取

## verbose[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-options.html#verbose) 详细 ¶

Usage: `--verbose` 用法： `--verbose` 

Print verbose output 打印详细输出

# Take a streaming backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/take-streaming-backup.html#take-a-streaming-backup) 进行流式备份 ¶

Percona XtraBackup supports streaming mode. Streaming mode sends a backup to `STDOUT` in the *xbstream* format instead of copying the files to the backup directory.
Percona XtraBackup支持流模式。流式处理模式以 xbstream 格式发送备份， `STDOUT` 而不是将文件复制到备份目录。

This method allows you to use other programs to filter the output of the backup, providing greater flexibility for storage of the backup. For example, compression is achieved by piping the output to a compression utility. One of the benefits of streaming backups and using Unix pipes is that the backups can be automatically encrypted.
此方法允许您使用其他程序来筛选备份的输出，从而为备份的存储提供更大的灵活性。例如，压缩是通过将输出管道输送到压缩实用程序来实现的。流式备份和使用 Unix 管道的好处之一是可以自动加密备份。

To use the streaming feature, you must use the `--stream`, providing the format of the stream (`xbstream`) and where to store the temporary files:
要使用流功能，必须使用 `--stream` ，提供流的格式 （ `xbstream` ） 以及临时文件的存储位置：

```
$ xtrabackup --stream=xbstream --target-dir=/tmp
```

*xtrabackup* uses *xbstream* to stream all of the data files to `STDOUT`, in a special `xbstream` format. After it finishes streaming all of the data files to `STDOUT`, it stops xtrabackup and streams the saved log file too.
XtraBackup 使用 XBSriver 以特殊 `xbstream` 格式将所有数据文件流式传输到 `STDOUT` 。在完成将所有数据文件流式传输到 `STDOUT` 后，它会停止 xtrabackup 并流式传输保存的日志文件。

When compression is enabled, *xtrabackup* compresses the output data, except for the meta and non-InnoDB files  which are not compressed, using the specified compression algorithm.  Percona XtraBackup supports the following compression algorithms:
启用压缩后，xtrabackup 使用指定的压缩算法压缩输出数据，但未压缩的元文件和非 InnoDB 文件除外。Percona XtraBackup支持以下压缩算法：

## Zstandard (ZSTD)[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/take-streaming-backup.html#zstandard-zstd) Zstandard （ZSTD） ¶

The Zstandard (ZSTD) is a fast lossless compression algorithm that targets  real-time compression scenarios and better compression ratios. `ZSTD` is the default compression algorithm for the `--compress` option.
Zstandard （ZSTD） 是一种快速无损压缩算法，针对实时压缩场景和更好的压缩比。 `ZSTD` 是 `--compress` 该选项的默认压缩算法。

To compress files using the `ZSTD` compression algorithm, use the `--compress` option:
要使用 `ZSTD` 压缩算法压缩文件，请使用以下 `--compress` 选项：

```
$ xtrabackup --backup --compress --target-dir=/data/backup
```

The resulting files have the `\*.zst` format.
生成的文件具有以下 `\*.zst` 格式。

You can specify `ZSTD` compression level with the [`--compress-zstd-level(=#)`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-zstd-level) option. The default value is `1`.
您可以使用该 `--compress-zstd-level(=#)` 选项指定 `ZSTD` 压缩级别。默认值为 `1` 。

```
$ xtrabackup –backup –compress –compress-zstd-level=1 –target-dir=/data/backup
```

## lz4[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/take-streaming-backup.html#lz4)

To compress files using the `lz4` compression algorithm, set the `--compress` option to `lz4`:
要使用 `lz4` 压缩算法压缩文件，请将 `--compress` 选项设置为 `lz4` ：

```
$ xtrabackup --backup --compress=lz4 --target-dir=/data/backup
```

The resulting files have the `\*.lz4` format. 
生成的文件具有以下 `\*.lz4` 格式。

To decompress files, use the `--decompress` option.
要解压缩文件，请使用该 `--decompress` 选项。

Using *xbstream* as a stream option, backups can be copied and compressed in parallel.  This option can significantly improve the speed of the backup process.  In case backups were both compressed and encrypted, they must be decrypted before they  are uncompressed.
使用 xbstream 作为流选项，可以并行复制和压缩备份。此选项可以显著提高备份过程的速度。如果备份既压缩又加密，则必须在解压缩之前对其进行解密。

| Task 任务                                                    | Command 命令                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Stream the backup into an archived named `backup.xbstream` 将备份流式传输到存档的名为 `backup.xbstream` | `$ xtrabackup --backup --stream=xbstream --target-dir=./ > backup.xbstream` |
| Stream the backup into a compressed archive named `backup.xbstream` 将备份流式传输到名为 `backup.xbstream` | `$ xtrabackup --backup --stream=xbstream --compress --target-dir=./ > backup.xbstream` |
| Encrypt the backup 加密备份                                  | `$ xtrabackup --backup --stream=xbstream > backup.xbstream gzip -`` | openssl des3 -salt -k “password” backup.xbstream.gz.des3` |
| Unpack the backup to the current directory 将备份解压缩到当前目录 | `$ xbstream -x <  backup.xbstream`                           |
| Send the backup compressed directly to another host and unpack it 将压缩后的备份直接发送到另一台主机并解压缩 | `$ xtrabackup --backup --compress --stream=xbstream --target-dir=./ | ssh user@otherhost "xbstream -x"` |
| Send the backup to another server using `netcat` 使用以下方法 `netcat` 将备份发送到另一台服务器 | On the destination host: 在目标主机上： `$ nc -l 9999 | cat - > /data/backups/backup.xbstream`  On the source host: 在源主机上： `$ xtrabackup --backup --stream=xbstream | nc desthost 9999` |
| Send the backup to another server using a one-liner 使用单行代码将备份发送到另一台服务器 | `$ ssh user@desthost “( nc -l 9999 > /data/backups/backup.xbstream  & )” && xtrabackup --backup --stream=xbstream | nc desthost  9999` |
| Throttle the throughput to 10MB/sec using the [pipe viewer](https://www.ivarch.com/programs/quickref/pv.shtml) tool 使用管道查看器工具将吞吐量限制为 10MB/秒 | `$ xtrabackup --backup --stream=xbstream | pv -q -L10m ssh user@desthost “cat - > /data/backups/backup.xbstream”` |
| Checksum the backup during the streaming 在流式处理期间对备份进行校验和 | On the destination host: 在目标主机上： `$ nc -l 9999 | tee >(sha1sum > destination_checksum) > /data/backups/backup.xbstream`  On the source host: 在源主机上： `$ xtrabackup --backup --stream=xbstream | tee >(sha1sum > source_checksum) | nc desthost 9999`  Compare the checksums on the source host: 比较源主机上的校验和： `$ cat source_checksum 65e4f916a49c1f216e0887ce54cf59bf3934dbad`  Compare the checksums on the destination host: 比较目标主机上的校验和： `$ cat destination_checksum 65e4f916a49c1f216e0887ce54cf59bf3934dbad` |
| Parallel compression with parallel copying backup 使用并行复制备份进行并行压缩 | `$ xtrabackup --backup --compress --compress-threads=8 --stream=xbstream --parallel=4 --target-dir=./ > backup.xbstream` |

Important 重要

The streamed backup must be prepared before restoration. Streaming mode does not prepare the backup.
在还原之前，必须准备流式备份。流式处理模式不准备备份。



# Accelerate the backup process[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/accelerate-backup-process.html#accelerate-the-backup-process) 加快备份过程 ¶

## Copy with the `--parallel` and `--compress-threads` options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/accelerate-backup-process.html#copy-with-the-parallel-and-compress-threads-options) 使用 `--parallel` 和 `--compress-threads` 选项进行复制 ¶

When making a local or streaming backup with xbstream binary, multiple files can be copied at the same time when using the `--parallel` option. This option specifies the number of threads created by xtrabackup to copy data files.
使用 xbstream 二进制文件进行本地或流式备份时，使用该 `--parallel` 选项时可以同时复制多个文件。此选项指定 xtrabackup 创建的用于复制数据文件的线程数。

To take advantage of this option either the multiple tablespaces option must be enabled (innodb_file_per_table) or the shared tablespace must be stored in multiple ibdata files with the innodb_data_file_path option. Having multiple files for the database (or splitting one into many) doesn’t have a measurable impact on performance.
要利用此选项，必须启用多个表空间选项 （innodb_file_per_table），或者必须使用 innodb_data_file_path 选项将共享表空间存储在多个  ibdata 文件中。为数据库提供多个文件（或将一个文件拆分为多个文件）不会对性能产生可衡量的影响。

As this feature is implemented at the file level, concurrent file transfer can sometimes increase I/O throughput when doing a backup on highly fragmented data files, due to the overlap of a greater number of random read requests. You should consider tuning the filesystem also to obtain the maximum performance (e.g. checking fragmentation).
由于此功能是在文件级别实现的，因此在对高度碎片化的数据文件进行备份时，并发文件传输有时会增加 I/O 吞吐量，因为随机读取请求数量较多。您还应该考虑调整文件系统以获得最大性能（例如，检查碎片）。

If the data is stored on a single file, this option has no effect.
如果数据存储在单个文件上，则此选项不起作用。

To use this feature, simply add the option to a local backup, for example:
要使用此功能，只需将选项添加到本地备份中，例如：

```
$ xtrabackup --backup --parallel=4 --target-dir=/path/to/backup
```

By using the xbstream in streaming backups, you can additionally speed up the compression process with the `--compress-threads` option. This option specifies the number of threads created by xtrabackup for for parallel data compression. The default value for this option is 1.
通过在流式备份中使用 xbstream，您还可以使用该 `--compress-threads` 选项加快压缩过程。此选项指定 xtrabackup 为并行数据压缩创建的线程数。此选项的默认值为 1。

To use this feature, simply add the option to a local backup, for example:
要使用此功能，只需将选项添加到本地备份中，例如：

```
$ xtrabackup --backup --stream=xbstream --compress --compress-threads=4 --target-dir=./ > backup.xbstream
```

Before applying logs, compressed files will need to be uncompressed.
在应用日志之前，需要解压缩压缩的文件。

## The `--rsync` option[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/accelerate-backup-process.html#the-rsync-option) `--rsync` 选项 ¶

In order to speed up the backup process and to minimize the time `FLUSH TABLES WITH READ LOCK` is blocking the writes, the option `--rsync` should be used. When this option is specified, xtrabackup uses `rsync` to copy all non-InnoDB files instead of spawning a separate `cp` for each file, which can be much faster for servers with a large number of databases or tables. xtrabackup will call the `rsync` twice, once before the `FLUSH TABLES WITH READ LOCK` and once during to minimize the time the read lock is being held. During the second `rsync` call, it will only synchronize the changes to non-transactional data (if any) since the first call performed before the `FLUSH TABLES WITH READ LOCK`. Note that Percona XtraBackup will use [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) where available as a lightweight alternative to `FLUSH TABLES WITH READ LOCK`.
为了加快备份过程并最大程度地减少阻塞写入的时间 `FLUSH TABLES WITH READ LOCK` ，应使用该选项 `--rsync` 。指定此选项后，xtrabackup 将用于 `rsync` 复制所有非 InnoDB 文件，而不是为每个文件生成一个单独的 `cp` 文件，这对于具有大量数据库或表的服务器来说要快得多。XtraBackup 将调用 `rsync` 两次，一次在之前 `FLUSH TABLES WITH READ LOCK` ，一次在期间，以最大程度地减少按住读取锁的时间。在第二次 `rsync` 调用期间，它只会同步自第一次调用之前执行的更改（如果有 `FLUSH TABLES WITH READ LOCK` ）。请注意，Percona XtraBackup将使用备份锁作为轻量级的 `FLUSH TABLES WITH READ LOCK` 替代品。

Percona XtraBackup uses these locks automatically to copy non-InnoDB data to  avoid blocking Data manipulation language (DML) queries that modify  InnoDB tables.
Percona XtraBackup自动使用这些锁来复制非InnoDB数据，以避免阻止修改InnoDB表的数据操作语言（DML）查询。

Note 注意

This option cannot be used together with the `--stream` option.
此选项不能与该 `--stream` 选项一起使用。

# Encrypt backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#encrypt-backups) 加密备份 ¶

# Encrypt backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#encrypt-backups_1) 加密备份 ¶

Percona XtraBackup supports encrypting and decrypting local and streaming  backups with the upstream option, adding another protection layer. The encryption is implemented using the `libgcrypt` library from GnuPG.
Percona XtraBackup支持使用上游选项加密和解密本地和流式备份，从而增加了另一个保护层。加密是使用 GnuPG 的 `libgcrypt` 库实现的。

## Create encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#create-encrypted-backups) 创建加密备份 ¶

The following options create encrypted backups. The `--encrypt-key` and `--encrypt-key-file` options specify the encryption key and are mutually exclusive. You should select one or the other.
以下选项用于创建加密备份。 `--encrypt-key` 和 `--encrypt-key-file` 选项指定加密密钥，并且是互斥的。您应该选择其中之一。

- `--encrypt`
- `--encrypt-key`
- `--encrypt-key-file`

For an encryption key, use a command, such as `openssl rand -base64 24`, to generate a random alphanumeric string.
对于加密密钥，请使用命令（如 `openssl rand -base64 24` ）生成随机字母数字字符串。

### The `--encrypt-key` option[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#the-encrypt-key-option) `--encrypt-key` 选项 ¶

An example of the *xtrabackup* command using the `--encrypt-key`:
xtrabackup 命令的示例， `--encrypt-key` 使用 ：

```
$  xtrabackup --backup --encrypt=AES256 --encrypt-key="{randomly-generated-alphanumeric-string}" --target-dir=/data/backup
```

### The `--encrypt-key-file` option[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#the-encrypt-key-file-option) `--encrypt-key-file` 选项 ¶

The recommended method uses the command line: `echo -n “{randomly-generated-alphanumeric-string}” > /data/backups/keyfile` to create the file. Remember that using the– encrypt-key-file option, your text editor can  automatically insert a CRLF (end of line) character in the `KEYFILE`. This inserted character invalidates the key because the size is wrong. 
建议的方法使用命令行： `echo -n “{randomly-generated-alphanumeric-string}” > /data/backups/keyfile` 创建文件。请记住，使用 – encrypt-key-file 选项，您的文本编辑器可以自动在 `KEYFILE` .插入的此字符会使密钥失效，因为大小错误。

An example of using the `--encrypt-key-file` option:
使用该 `--encrypt-key-file` 选项的示例：

```
$ xtrabackup --backup --encrypt=AES256 --encrypt-key-file=/data/backups/keyfile --target-dir=/data/backup
```

## Optimize the encryption process[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#optimize-the-encryption-process) 优化加密流程 ¶

Additional encrypted backup options, `--encrypt-threads` and `--encrypt-chunk-size`, can speed up the encryption process. 
其他加密备份选项 `--encrypt-threads` 和 `--encrypt-chunk-size` ，可以加快加密过程。

Use the `--encrypt-threads` option to enable parallel encryption with multiple threads. 
使用该 `--encrypt-threads` 选项启用具有多个线程的并行加密。

The `--encrypt-chunk-size` option specifies the size, in bytes, of the working encryption buffer for each encryption thread. The default size is 64K.
该 `--encrypt-chunk-size` 选项指定每个加密线程的工作加密缓冲区的大小（以字节为单位）。默认大小为 64K。

## Decrypt encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#decrypt-encrypted-backups) 解密加密备份 ¶

You can decrypt backups with the `xbcrypt` binary. The following example encrypts a backup.
您可以使用 `xbcrypt` 二进制文件解密备份。以下示例对备份进行加密。

You can use the `--parallel` option and the `--decrypt` option to decrypt multiple files simultaneously.
您可以使用该 `--parallel` 选项和 `--decrypt` 选项同时解密多个文件。

```
$ for i in `find . -iname "*\.xbcrypt"`; do xbcrypt -d --encrypt-key-file=/root/secret_key --encrypt-algo=AES256 < $i > $(dirname $i)/$(basename $i .xbcrypt) && rm $i; done
```

The following example shows a decryption process.
以下示例显示了解密过程。

```
$ xtrabackup --decrypt=AES256 --encrypt-key="{randomly-generated-alphanumeric-string}" --target-dir=/data/backup/
```

Percona XtraBackup doesn’t automatically remove the encrypted files. You must remove the `\*.xbcrypt` files manually.
Percona XtraBackup不会自动删除加密文件。您必须手动删除 `\*.xbcrypt` 文件。

## Prepare encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#prepare-encrypted-backups) 准备加密备份 ¶

After decrypting the backups, prepare the backups with the `--prepare` option:
解密备份后，使用以下 `--prepare` 选项准备备份：

```
$ xtrabackup --prepare --target-dir=/data/backup/
```

## Restore encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/encrypt-backups.html#restore-encrypted-backups) 恢复加密备份 ¶

*xtrabackup* offers the `--copy-back` option to restore a backup to the server’s datadir:
XtraBackup 提供了将备份还原到服务器的 Datadir `--copy-back` 的选项：

```
$ xtrabackup --copy-back --target-dir=/data/backup/
```

The option copies all the data-related files to the server’s datadir. The server’s `my.cnf` configuration file determines the location. 
该选项将所有与数据相关的文件复制到服务器的 datadir。服务器的 `my.cnf` 配置文件确定位置。

You should check the last line of the output for a success message:
您应该检查输出的最后一行以获取成功消息：

<details class="example" data-immersive-translate-walked="1eac0a35-09d7-48df-9b86-42092a951464" open="">
<summary data-immersive-translate-walked="1eac0a35-09d7-48df-9b86-42092a951464" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="1eac0a35-09d7-48df-9b86-42092a951464"><pre><span></span><code>150318 11:08:13  xtrabackup: completed OK!
</code></pre></div>
</details>

# xbcloud 二进制文件概述 ¶

The purpose of xbcloud is to download from the cloud and upload to  the cloud the full or part of an xbstream archive. xbcloud will not  overwrite the backup with the same name. xbcloud accepts input via a pipe from xbstream so that it can be invoked as a pipeline with xtrabackup to stream directly to the cloud without needing a local storage.
xbcloud 的目的是从云下载并将 xbstream 存档的全部或部分上传到云。XBCloud不会覆盖同名备份。XBBloud 通过管道接受来自  XBSturek 的输入，以便可以使用 XtraBackup 将其作为管道调用，以直接流式传输到云，而无需本地存储。

Note 注意

In a Bash shell, the `$?` parameter returns the exit code from the last binary. If you use pipes, the ${PIPESTATUS[x]} array parameter returns the exit code for each  binary in the pipe string.
在 Bash shell 中，该 `$?` 参数返回最后一个二进制文件的退出代码。如果使用管道，则 ${PIPESTATUS[x]} 数组参数将返回管道字符串中每个二进制文件的退出代码。

```
$ xtrabackup --backup --stream=xbstream --target-dir=/storage/backups/ | xbcloud put [options] full_backup
...
$ ${PIPESTATUS[x]}
0 0
$ true | false
$ echo $?
1

# with PIPESTATUS
$ true | false
$ echo ${PIPESTATUS[0]} ${PIPESTATUS[1]}
0 1
```

The xbcloud binary stores each chunk as a separate object with a name `backup_name/database/table.ibd.NNN...`, where `NNN...` is a 0-padded serial number of chunk within a file. The size of chunk produced by xtrabackup and xbstream changed to 10M.
xbcloud 二进制文件将每个块存储为一个单独的对象，其名称 `backup_name/database/table.ibd.NNN...` 为 ，其中 `NNN...` 是文件中块的 0 填充序列号。xtrabackup 和 xbstream 生成的块大小更改为 10M。

To adjust the chunk size use [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#--read-buffer-size). To adjust the chunk size for encrypted files, use `--read-buffer-size` and [`--encrypt-chunk-size`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#--encrypt-chunk-size).
要调整块大小，请使用 `--read-buffer-size` 。要调整加密文件的块大小，请使用 `--read-buffer-size` 和 `--encrypt-chunk-size` 。

xbcloud has three essential operations: *put*, *get*, and *delete*. With these operations, backups are created, stored, retrieved, restored, and deleted. xbcloud operations clearly map to similar operations within  the AWS Amazon S3 API.
XBBloud 有三个基本操作：put、get 和 delete。通过这些操作，可以创建、存储、检索、还原和删除备份。xbcloud 操作清楚地映射到 AWS Amazon S3 API 中的类似操作。

The [Exponential Backoff](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html) feature increases the chances for the completion of a backup or a restore operation. When taking a backup, a chunk upload or download  may fail if you have an unstable network connection or other network  issues. This feature adds an exponential backoff, a sleep time, and  retries the operations.
指数退避功能增加了完成备份或还原操作的机会。进行备份时，如果网络连接不稳定或其他网络问题，区块上传或下载可能会失败。此功能会添加指数退避、睡眠时间，并重试操作。

With the [FIFO data sink](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html) feature, users with a streaming capacity of 10Gbps (typically on a  Local Area Network (LAN)) can benefit from faster backups by streaming  data in parallel to object storage.
借助 FIFO 数据接收器功能，流容量为 10Gbps（通常在局域网 （LAN） 上）的用户可以通过将数据并行流式传输到对象存储，从而从更快的备份中受益。

Important 重要

To prevent intermittent backup failures, [update the curl utility in Debian 10](https://docs.percona.com/percona-xtrabackup/innovation-release/update-curl-utility.html).
为了防止间歇性备份失败，请在 Debian 10 中更新 curl 实用程序。

## Supported cloud storage types[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#supported-cloud-storage-types) 支持的云存储类型 ¶

The following cloud storage types are supported:
支持以下云存储类型：

- OpenStack Object Storage (Swift) - see [Using the xbcloud binary with Swift](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html)
  OpenStack 对象存储 （Swift） - 参见将 xbcloud 二进制文件与 Swift 结合使用
- Amazon Simple Storage (S3) - see [Using the xbcloud binary with Amazon S3](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html)
  Amazon Simple Storage （S3） - 请参阅将 xbcloud 二进制文件与 Amazon S3 结合使用
- Azure Cloud Storage - see [Using the xbcloud binary with Microsoft Azure Cloud Storage](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-azure.html)
  Azure 云存储 - 请参阅将 xbcloud 二进制文件与 Microsoft Azure 云存储配合使用
- Google Cloud Storage (gcs) - see [Using the xbcloud binary with Google Cloud Storage](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-gcs.html)
  Google Cloud Storage （gcs） - 请参阅将 xbcloud 二进制文件与 Google Cloud Storage 结合使用
- MinIO - see [Using the xbcloud binary with MinIO](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-minio.html)
  MinIO - 请参阅将 xbcloud 二进制文件与 MinIO 配合使用

In addition to OpenStack Object Storage (Swift), which has been the only  option for storing backups in a cloud storage until Percona XtraBackup  2.4.14, xbcloud supports Amazon S3, MinIO, and Google Cloud Storage.  Other Amazon S3-compatible storages, such as Wasabi or Digital Ocean  Spaces, are also supported.
除了 OpenStack 对象存储 （Swift）（在 Percona XtraBackup 2.4.14  之前一直是将备份存储在云存储中的唯一选项）之外，xbcloud 还支持 Amazon S3、MinIO 和 Google Cloud  Storage。还支持其他与 Amazon S3 兼容的存储，例如 Wasabi 或 Digital Ocean Spaces。

See also 另请参阅

[OpenStack Object Storage(“Swift”)
OpenStack对象存储（“Swift”）](https://wiki.openstack.org/wiki/Swift)

[Amazon Simple Storage Service](https://aws.amazon.com/s3/)

[MinIO 米尼奥](https://min.io/)

[Google Cloud Storage Google 云存储](https://cloud.google.com/storage/)

[Wasabi 芥末](https://wasabi.com/)

[Digital Ocean Spaces 数字海洋空间](https://www.digitalocean.com/products/spaces)

## Usage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#usage) 用法 ¶

The following sample command creates a full backup:
以下示例命令创建完整备份：

```
$ xtrabackup --backup --stream=xbstream --target-dir=/storage/backups/ --extra-lsndirk=/storage/backups/| xbcloud \
put [options] full_backup
```

An incremental backup only includes the changes since the last backup. The last backup can be either a full or incremental backup.
增量备份仅包括自上次备份以来所做的更改。上次备份可以是完整备份，也可以是增量备份。

The following sample command creates an incremental backup:
以下示例命令创建增量备份：

```
$ xtrabackup --backup --stream=xbstream --incremental-basedir=/storage/backups \
--target-dir=/storage/inc-backup | xbcloud  put [options] inc_backup
```

To prepare an incremental backup, you must first download the full backup with the following command:
若要准备增量备份，必须首先使用以下命令下载完整备份：

```
$ xbcloud get [options] full_backup | xbstream -xv -C /tmp/full-backup
```

You must prepare the full backup:
您必须准备完整备份：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/tmp/full-backup
```

After the full backup has been prepared, download the incremental backup:
准备好完整备份后，下载增量备份：

```
xbcloud get [options] inc_backup | xbstream -xv -C /tmp/inc-backup
```

The downloaded backup is prepared by running the following command:
通过运行以下命令准备下载的备份：

```
$ xtrabackup --prepare --target-dir=/tmp/full-backup --incremental-dir=/tmp/inc-backup
```

You do not need the full backup to restore only a specific database. You can specify only the tables to be restored:
您不需要完整备份来仅还原特定数据库。您只能指定要还原的表：



```
xbcloud get [options] ibdata1 sakila/payment.ibd /tmp/partial/partial.xbs
```

An example of the code: 
代码示例：



```
xbstream -xv -C /tmp/partial < /tmp/partial/partial.xbs
```

## Supplying parameters[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#supplying-parameters) 提供参数 ¶

Each storage type has mandatory parameters that you can supply on the command line, in a configuration file, and via environment variables.
每种存储类型都有必需的参数，您可以在命令行、配置文件中和通过环境变量提供这些参数。

### Configuration files[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#configuration-files) 配置文件 ¶

The parameters the values of which do not change frequently can be stored in `my.cnf` or in a custom configuration file. The following example is a template of configuration options under the `[xbcloud]` group:
其值不经常更改的参数可以存储在自定义配置文件中 `my.cnf` 或自定义配置文件中。以下示例是 `[xbcloud]` 组下的配置选项模板：

```
[xbcloud]
storage=s3
s3-endpoint=http://localhost:9000/
s3-access-key=minio
s3-secret-key=minio123
s3-bucket=backupsx
s3-bucket-lookup=path
s3-api-version=4
```

Note 注意

If you explicitly use a parameter on the command line and in a  configuration file, xbcloud uses the value provided on the command line.
如果您在命令行和配置文件中显式使用参数，则 xbcloud 使用命令行上提供的值。

### Environment variables[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#environment-variables) 环境变量 ¶

If you explicitly use a parameter on the command line, in a configuration file, and the corresponding environment variable contains a value, xbcloud uses the value provided on the command line or in the configuration file.
如果您在命令行、配置文件中显式使用参数，并且相应的环境变量包含值，则 xbcloud 将使用命令行或配置文件中提供的值。

### Shortcuts[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#shortcuts) 快捷方式 ¶

For all operations (put, get, and delete), you can use a shortcut to specify the storage type, bucket name, and backup name as one parameter instead of using three distinct parameters (–storage, –s3-bucket, and backup name per se).
对于所有操作（put、get 和 delete），您可以使用快捷方式将存储类型、存储桶名称和备份名称指定为一个参数，而不是使用三个不同的参数（–storage、–s3-bucket 和备份名称本身）。

Note 注意

Use the following format: `storage-type://bucket-name/backup-name`
使用以下格式： `storage-type://bucket-name/backup-name` 

In this example s3 refers to a storage type, operator-testing  is a bucket name, and bak22 is the backup name. 
在此示例中，s3 指的是存储类型，operator-testing 是存储桶名称，bak22 是备份名称。

```
$ xbcloud get s3://operator-testing/bak22 ...
```

This shortcut expands as follows:
此快捷方式扩展如下：

```
$ xbcloud get --storage=s3 --s3-bucket=operator-testing bak22 ...
```

You can supply the mandatory parameters on the command line, configuration files, and in environment variables.
您可以在命令行、配置文件和环境变量中提供必需参数。

### Additional parameters[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#additional-parameters) 其他参数 ¶

xbcloud accepts additional parameters that you can use with any storage type. The `--md5` parameter computes the MD5 hash value of the backup chunks. The result is stored in files that following the `backup_name.md5` pattern.
XBCloud接受可用于任何存储类型的其他参数。该 `--md5` 参数计算备份块的 MD5 哈希值。结果存储在遵循该 `backup_name.md5` 模式的文件中。

```
$ xtrabackup --backup --stream=xbstream \
--parallel=8 2>backup.log | xbcloud put s3://operator-testing/bak22 \
--parallel=8 --md5 2>upload.log
```

You may use the `--header` parameter to pass an additional HTTP header with the server side encryption while specifying a customer key.
在指定客户密钥时，可以使用该 `--header` 参数传递具有服务器端加密的附加 HTTP 标头。

An example of using the `--header` for AES256 encryption.
使用 `--header` for AES256 加密的示例。

```
$ xtrabackup --backup --stream=xbstream --parallel=4 | \
xbcloud put s3://operator-testing/bak-enc/ \
--header="X-Amz-Server-Side-Encryption-Customer-Algorithm: AES256" \
--header="X-Amz-Server-Side-Encryption-Customer-Key: CuStoMerKey=" \
--header="X-Amz-Server-Side-Encryption-Customer-Key-MD5: CuStoMerKeyMd5==" \
--parallel=8
```

The `--header` parameter is also useful to set the access control list (ACL) permissions: `--header="x-amz-acl: bucket-owner-full-control`
该 `--header` 参数还可用于设置访问控制列表 （ACL） 权限： `--header="x-amz-acl: bucket-owner-full-control` 

## Incremental backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#incremental-backups) 增量备份 ¶

First, you need to make the full backup on which the incremental one is going to be based:
首先，您需要进行增量备份所基于的完整备份：

```
$ xtrabackup --backup --stream=xbstream --extra-lsndir=/storage/backups/ \
--target-dir=/storage/backups/ | xbcloud put \
--storage=swift --swift-container=test_backup \
--swift-auth-version=2.0 --swift-user=admin \
--swift-tenant=admin --swift-password=xoxoxoxo \
--swift-auth-url=http://127.0.0.1:35357/ --parallel=10 \
full_backup
```

Then you can make the incremental backup:
然后，您可以进行增量备份：

```
$ xtrabackup --backup --incremental-basedir=/storage/backups \
--stream=xbstream --target-dir=/storage/inc_backup | xbcloud put \
--storage=swift --swift-container=test_backup \
--swift-auth-version=2.0 --swift-user=admin \
--swift-tenant=admin --swift-password=xoxoxoxo \
--swift-auth-url=http://127.0.0.1:35357/ --parallel=10 \
inc_backup
```

### Preparing incremental backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#preparing-incremental-backups) 准备增量备份 ¶

To prepare a backup you first need to download the full backup:
要准备备份，首先需要下载完整备份：

```
$ xbcloud get --swift-container=test_backup \
--swift-auth-version=2.0 --swift-user=admin \
--swift-tenant=admin --swift-password=xoxoxoxo \
--swift-auth-url=http://127.0.0.1:35357/ --parallel=10 \
full_backup | xbstream -xv -C /storage/downloaded_full
```

Once you download the full backup it should be prepared:
下载完整备份后，应准备好：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/storage/downloaded_full
```

After the full backup has been prepared you can download the incremental backup:
准备好完整备份后，可以下载增量备份：

```
$ xbcloud get --swift-container=test_backup \
--swift-auth-version=2.0 --swift-user=admin \
--swift-tenant=admin --swift-password=xoxoxoxo \
--swift-auth-url=http://127.0.0.1:35357/ --parallel=10 \
inc_backup | xbstream -xv -C /storage/downloaded_inc
```

Once the incremental backup has been downloaded you can prepare it by running:
下载增量备份后，可以通过运行以下命令进行准备：

```
$ xtrabackup --prepare --apply-log-only \
--target-dir=/storage/downloaded_full \
--incremental-dir=/storage/downloaded_inc

$ xtrabackup --prepare --target-dir=/storage/downloaded_full
```

### Partial download of the cloud backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html#partial-download-of-the-cloud-backup) 部分下载云备份 ¶

If you do not want to download the entire backup to restore the specific database you can specify only the tables you want to restore:
如果不想下载整个备份来还原特定数据库，则只能指定要还原的表：

```
$ xbcloud get --swift-container=test_backup
--swift-auth-version=2.0 --swift-user=admin \
--swift-tenant=admin --swift-password=xoxoxoxo \
--swift-auth-url=http://127.0.0.1:35357/ full_backup \
ibdata1 sakila/payment.ibd \
> /storage/partial/partial.xbs

$ xbstream -xv -C /storage/partial < /storage/partial/partial.xbs
```

# The xbcloud command-line options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#the-xbcloud-command-line-options) xbcloud 命令行选项 ¶

Usage:  用法：

```
$ xbcloud put [OPTIONS]
$ xbcloud get [OPTIONS]
$ xbcloud delete [OPTIONS]
```

This document contains information on general options and the options available when you select the [Swift authentication version using `swift-auth-version`](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-auth-version).
本文档包含有关常规选项的信息，以及使用 `swift-auth-version` 选择 Swift 身份验证版本时可用的选项。

The xbcloud binary has the following general command line options:
xbcloud 二进制文件具有以下常规命令行选项：

## azure-access-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-access-key)

Usage: `--azure-access-key=name` 用法： `--azure-access-key=name` 

The name of the Azure access-key
Azure 访问密钥的名称

## azure-container-name[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-container-name)

Usage: `--azure-container-name=name` 用法： `--azure-container-name=name` 

The name of the Azure container
Azure 容器的名称

## azure-development-storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-development-storage)

Usage: `--azure-development-storage=name` 用法： `--azure-development-storage=name` 

If you run the [Azurite emulator](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio,blob-storage), use this option, and it works with the default credentials provided by  Azurite. You can overwrite these default credentials with other options.
如果运行 Azurite 模拟器，请使用此选项，它将使用 Azurite 提供的默认凭据。您可以使用其他选项覆盖这些默认凭据。

## azure-endpoint[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-endpoint)

Usage: `--azure-endpoint=name` 用法： `--azure-endpoint=name` 

The name of the Azure endpoint
Azure 终结点的名称

## azure-storage-account[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-storage-account)

Usage: `--azure-storage-account=name` 用法： `--azure-storage-account=name` 

The name of the Azure storage account
Azure 存储帐户的名称

## azure-tier-class[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#azure-tier-class)

Usage: `--azure-tier-class=name` 用法： `--azure-tier-class=name` 

The name of the Azure tier-class. The possible values are:
Azure 层级的名称。可能的值为：

- Hot
- Cool 凉
- Archive 档案

## cacert[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#cacert)

Usage: `--cacert=name` 用法： `--cacert=name` 

The path to the file with Certificate Authority (CA) certificates.
具有证书颁发机构 （CA） 证书的文件的路径。

## curl-retriable-errors[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#curl-retriable-errors)

Usage: `--curl-retriable-errors=name` 用法： `--curl-retriable-errors=name` 

Add a new cURL error code as retriable. For multiple codes, use a comma-separated list.
将新的 cURL 错误代码添加为可重试。对于多个代码，请使用逗号分隔的列表。

## fifo-dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#fifo-dir)

Usage: `--fifo-dir=name` 用法： `--fifo-dir=name` 

The directory used to read or write named pipes. In the put mode, xbcloud  reads from the named pipes. In the get mode, xbcloud writes to the named pipes.
用于读取或写入命名管道的目录。在放置模式下，xbcloud 从命名管道中读取。在 get 模式下，xbcloud 写入命名管道。

## fifo-streams[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#fifo-streams)

Usage: `--fifo-streams=#` 用法： `--fifo-streams=#` 

The number of parallel FIFO stream threads.
并行 FIFO 流线程数。

## fifo-timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#fifo-timeout) FIFO-超时 ¶

Usage: `--fifo-timeout=#` 用法： `--fifo-timeout=#` 

The number of seconds to wait for the other end to open the stream. The default value is 60.
等待另一端打开流的秒数。默认值为 60。

## google-access-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-access-key)

Usage: `--google-access-key=name` 用法： `--google-access-key=name` 

The Google Cloud storage access key
Google Cloud 存储访问密钥

## google-bucket-name[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-bucket-name) google-bucket-name（谷歌存储桶名称） ¶

Usage: `--google-bucket-name=name` 用法： `--google-bucket-name=name` 

The Google Cloud storage bucket name
Google Cloud 存储存储分区名称

## google-endpoint[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-endpoint)

Usage: `--google-endpoint=name` 用法： `--google-endpoint=name` 

The Google Cloud storage endpoint
Google Cloud 存储端点

## google-region[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-region) 谷歌地区 ¶

Usage: `--google-region=name` 用法： `--google-region=name` 

The Google Cloud storage region
Google Cloud 存储区域

## google-secret-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-secret-key)

Usage: `--google-secret-key=name` 用法： `--google-secret-key=name` 

The Google Cloud storage secret key
Google Cloud 存储密钥

## google-session-token[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-session-token)

Usage: `--google-session-token=name` 用法： `--google-session-token=name` 

The Google Cloud storage session-token
Google Cloud 存储会话令牌

## google-storage-class[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#google-storage-class)

Usage: `--google-storage-class=name` 用法： `--google-storage-class=name` 

The Google Cloud storage storage class
Google Cloud 存储存储类

The possible values are the following:
可能的值如下：

- STANDARD 标准
- NEARLINE 近线
- COLDLINE 冷线
- ARCHIVE 档案

## header[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#header) 标题 ¶

Usage: `--header=name` 用法： `--header=name` 

Extra header 额外的标题

## http-retriable-errors[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#http-retriable-errors)

Usage: `--http-retriable-errors=name` 用法： `--http-retriable-errors=name` 

Add a new http error code as retriable. For multiple codes, use a comma-separated list.
将新的 http 错误代码添加为可重试。对于多个代码，请使用逗号分隔的列表。

## insecure[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#insecure) 不安全 ¶

Usage: `--insecure` 用法： `--insecure` 

Do not verify the certificate of the server.
请勿验证服务器的证书。

## max-backoff[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#max-backoff) 最大退避 ¶

Usage: `--max-backoff=#` 用法： `--max-backoff=#` 

The maximum backoff delay, in milliseconds, between chunk upload or chunk download retries. The default value is 300000.
区块上传或区块下载重试之间的最大回退延迟（以毫秒为单位）。默认值为 300000。

## max-retries[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#max-retries)

Usage: `--max-retires=#` 用法： `--max-retires=#` 

The number of retries for chunk uploads or downloads after a failure. The default value is 10.
失败后区块上传或下载的重试次数。默认值为 10。

## md5[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#md5)

Usage: `--md5=name` 用法： `--md5=name` 

Uploads an MD5 file into the backup directory.
将 MD5 文件上传到备份目录。

## parallel[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#parallel) 并行 ¶

Usage: `--parallel=#` 用法： `--parallel=#` 

Defines the maximum number of concurrent upload/download requests. The default value is `1`.
定义并发上载/下载请求的最大数量。默认值为 `1` 。

## s3-access-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-access-key)

Usage: `--s3-access-key=name` 用法： `--s3-access-key=name` 

The name of the s3 access key
s3 访问密钥的名称

## s3-api-version[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-api-version)

Usage: `--s3-api-version=name` 用法： `--s3-api-version=name` 

The name of the s3 API version
s3 API 版本的名称

## s3-bucket[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-bucket)

Usage: `--s3-bucket=name` 用法： `--s3-bucket=name` 

The name of the s3 bucket
s3 存储桶的名称

## s3-bucket-lookup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-bucket-lookup) s3-bucket-lookup（s3-bucket-lookup） ¶

Usage: `--s3-bucket-lookup=name` 用法： `--s3-bucket-lookup=name` 

The name of the s3 bucket lookup method
s3 存储桶查找方法的名称

## s3-endpoint[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-endpoint)

Usage: `--s3-endpoint=name` 用法： `--s3-endpoint=name` 

The name of the s3 endpoint
s3 终端节点的名称

## s3-region[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-region)

Usage: `--s3-region=name` 用法： `--s3-region=name` 

The name of the s3 region
s3 区域的名称

## s3-secret-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-secret-key)

Usage: `--s3-secret-key=name` 用法： `--s3-secret-key=name` 

The name of the s3 secret key
s3 私有密钥的名称

## s3-session-token[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-session-token)

Usage: `--s3-session-token=name` 用法： `--s3-session-token=name` 

The name of the s3 session token
s3 会话令牌的名称

## s3-storage-class[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#s3-storage-class) s3-存储类 ¶

Usage: `--s3-storage-class=name` 用法： `--s3-storage-class=name` 

The name of the s3 storage class and is used to pass custom storage class  names provided by the other s3 implementations, such as MinIO.
s3 存储类的名称，用于传递其他 s3 实施（如 MinIO）提供的自定义存储类名称。

The possible values are:
可能的值为：

- STANDARD 标准
- STANDARD_ID
- GLACIER 冰川

## storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#storage) 存储 ¶

Usage: `--storage=[S3|SWIFT|GOOGLE|AZURE]` 用法： `--storage=[S3|SWIFT|GOOGLE|AZURE]` 

Defines the Cloud storage option. xbcloud supports Swift, MinIO, Google, Azure, and AWS S3. The default value is `swift`.
定义云存储选项。xbcloud 支持 Swift、MinIO、Google、Azure 和 AWS S3。默认值为 `swift` 。

## swift-auth-url[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-auth-url)

Usage: `--swift-auth-url=name` 用法： `--swift-auth-url=name` 

The Base URL of the Swift authentication service.
Swift 身份验证服务的基 URL。

## swift-container[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-container)

Usage: `--swift-container=name` 用法： `--swift-container=name` 

The Swift container used to store backups.
用于存储备份的 Swift 容器。

## swift-key[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-key)

Usage: `--swift-key` 用法： `--swift-key` 

The Swift key/password (X-Auth-Key)
Swift 密钥/密码 （X-Auth-Key）

## swift-storage-url[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-storage-url)

Usage: `--swift-storage-url=name` 用法： `--swift-storage-url=name` 

If a name is specified, the xbcloud attempts to get the object-store  endpoint for a given region from the keystone response. This option  overrides that value.
如果指定了名称，xbcloud 会尝试从 keystone 响应中获取给定区域的对象存储端点。此选项将覆盖该值。

## swift-user[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-user)

Usage: `--swift-user=name` 用法： `--swift-user=name` 

The Swift user name (X-Auth-User).
Swift 用户名 （X-Auth-User）。

## timeout[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#timeout) 超时 ¶

Usage: `--timeout=#` 用法： `--timeout=#` 

The number of seconds to wait for activity on the TCP connection. The  default value is 120. If the value is 0 (zero), there is no timeout.
等待 TCP 连接上的活动的秒数。默认值为 120。如果值为 0（零），则没有超时。

## verbose[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#verbose) 详细 ¶

Usage: `--verbose` 用法： `--verbose` 

Turns on the cURL tracing.
打开 cURL 跟踪。

## Swift authentication options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-authentication-options) Swift 身份验证选项 ¶

The Swift specification describes several [authentication options](http://docs.openstack.org/developer/swift/overview_auth.html). The *xbcloud* tool can authenticate against keystone with API version 2 and 3.
Swift 规范描述了几个身份验证选项。xbcloud 工具可以使用 API 版本 2 和 3 对 keystone 进行身份验证。

## swift-auth-version[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-auth-version)

Usage: `--swift-auth-version=name` 用法： `--swift-auth-version=name` 

Defines the swift authentication version used. 
定义使用的 swift 身份验证版本。

The possible values are the following: 
可能的值如下：

- `1.0` - TempAuth `1.0` - 临时身份验证
- `2.0` - Keystone v2.0
   `2.0` - Keystone v2.0 版本
- `3` - Keystone v3. 
   `3` - Keystone v3 版。

The default value is `1.0`.
默认值为 `1.0` 。

## If `--swift-auth-version=2`, the additional options are:[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#if-swift-auth-version2-the-additional-options-are) 如果 `--swift-auth-version=2` ，则附加选项为： ¶

### swift-password[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-password)

Usage: `--swift-password=name` 用法： `--swift-password=name` 

Swift password for the user
用户的 Swift 密码

### swift-region[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-region)

Usage: `--swift-region=name` 用法： `--swift-region=name` 

Swift region object-store endpoint
Swift 区域对象存储终结点

### swift-tenant[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-tenant)

Usage: `--swift-tenant=name` 用法： `--swift-tenant=name` 

The Swift tenant name 
Swift 租户名称

Either of the `--swift-tenant` or `--swift-tenant-id` can be defined, but you should not use both options together. Both of these options are optional.
可以定义 `--swift-tenant` or `--swift-tenant-id` 中的任何一个，但不应同时使用这两个选项。这两个选项都是可选的。

### swift-tenant-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-tenant-id)

Usage: `--swift-tenant-id=name` 用法： `--swift-tenant-id=name` 

The Swift tenant ID
Swift 租户 ID

Either of the `--swift-tenant` or `--swift-tenant-id` can be defined, but you should not use both options together. Both of these options are optional.
可以定义 `--swift-tenant` or `--swift-tenant-id` 中的任何一个，但不应同时使用这两个选项。这两个选项都是可选的。

## If `--swift-auth-version=3`, the  additional options are:[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#if-swift-auth-version3-the-additional-options-are) 如果 `--swift-auth-version=3` ，则附加选项为： ¶

### swift-domain[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-domain)

Usage: `--swift-domain=name` 用法： `--swift-domain=name` 

The Swift domain name
Swift 域名

### swift-domain-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-domain-id)

Usage: `--swift-domain-id=name` 用法： `--swift-domain-id=name` 

The Swift domain ID
Swift 域 ID

### swift-project[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-project)

Usage: `--swift-project=name` 用法： `--swift-project=name` 

The Swift project name
Swift 项目名称

### swift-project-domain[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-project-domain)

Usage: `--swift-project-domain=name` 用法： `--swift-project-domain=name` 

The Swift domain name
Swift 域名

### swift-project-domain-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-project-domain-id)

Usage: `--swift-project-domain-id=name` 用法： `--swift-project-domain-id=name` 

The Swift domain ID
Swift 域 ID

### swift-project-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-project-id)

Usage: `--swift-project-id=name` 用法： `--swift-project-id=name` 

The Swift project ID
Swift 项目 ID

### swift-user-id[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-options.html#swift-user-id)

Usage: `--swift-user-id=name` 用法： `--swift-user-id=name` 

The Swift user ID
Swift 用户 ID

# Use the xbcloud binary with Amazon S3[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html#use-the-xbcloud-binary-with-amazon-s3) 将 xbcloud 二进制文件与 Amazon S3 结合使用 ¶

## Create a full backup with Amazon S3[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html#create-a-full-backup-with-amazon-s3) 使用 Amazon S3 创建完整备份 ¶

```
$ xtrabackup --backup --stream=xbstream --extra-lsndir=/tmp --target-dir=/tmp | \
xbcloud put --storage=s3 \
--s3-endpoint='s3.amazonaws.com' \
--s3-access-key='YOUR-ACCESSKEYID' \
--s3-secret-key='YOUR-SECRETACCESSKEY' \
--s3-bucket='mysql_backups'
--parallel=10 \
$(date -I)-full_backup
```

The following options are available when using Amazon S3:
使用 Amazon S3 时，可以使用以下选项：

| Option 选择                    | Details 详                                                   |
| ------------------------------ | ------------------------------------------------------------ |
| –s3-access-key                 | Use to supply the AWS access key ID 用于提供 AWS 访问密钥 ID |
| –s3-secret-key                 | Use to supply the AWS secret access key 用于提供 AWS 秘密访问密钥 |
| –s3-bucket                     | Use supply the AWS bucket name 使用 supply the AWS bucket name （提供 AWS 存储桶名称） |
| –s3-region –s3 区域            | Use to specify the AWS region. The default value is **us-east-1** 用于指定 AWS 区域。默认值为 us-east-1 |
| –s3-api-version =              | Select the signing algorithm. The default value is AUTO. In this case, xbcloud will probe. 选择签名算法。默认值为 AUTO。在这种情况下，xbcloud 将进行探测。 |
| –s3-bucket-lookup =            | Specify whether to use bucket.endpoint.com or endpoint.com/bucket*style  requests. The default value is AUTO. In this case, xbcloud will probe. 指定是使用 bucket.endpoint.com 还是 endpoint.com/bucket*style 请求。默认值为 AUTO。在这种情况下，xbcloud 将进行探测。 |
| –s3-storage-class= –s3-存储类= | Specify the [S3 storage class](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html). The default storage class depends on the provider. The name options are the following: 指定 S3 存储类。默认存储类取决于提供程序。名称选项如下：STANDARD 标准STANDARD_IAGLACIER 冰川 **NOTE** If you use the GLACIER storage class, the object must be [restored to S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects.html) before restoring the backup. Also supports using custom S3 implementations such as MinIO or CephRadosGW. 注意 如果您使用 GLACIER 存储类，则必须先将对象还原到 S3，然后才能还原备份。还支持使用自定义 S3 实现，例如 MinIO 或 CephRadosGW。 |

## Permissions setup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html#permissions-setup) 权限设置 ¶

Following the principle of “least-privilege”, these are the minimum bucket  permissions needed for xbcloud to write backups to S3: ***LIST/PUT/GET/DELETE\***.
遵循“最小权限”原则，这些是 xbcloud 将备份写入 S3 所需的最低存储桶权限：LIST/PUT/GET/DELETE。

The following example shows the policy definition for writing to the `xbcloud-testing` bucket on the AWS S3 storage.
以下示例显示了用于写入 AWS S3 存储 `xbcloud-testing` 上的存储桶的策略定义。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::xbcloud-testing"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::xbcloud-testing/*"
        }
    ]
}
```

## Environment variables[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html#environment-variables) 环境变量 ¶

The following environment variables are recognized. xbcloud maps them automatically to corresponding parameters applicable to the selected storage.
可识别以下环境变量。XBWloud会自动将它们映射到适用于所选存储的相应参数。

- AWS_ACCESS_KEY_ID (or ACCESS_KEY_ID)
  AWS_ACCESS_KEY_ID（或ACCESS_KEY_ID）
- AWS_SECRET_ACCESS_KEY (or SECRET_ACCESS_KEY)
  AWS_SECRET_ACCESS_KEY（或SECRET_ACCESS_KEY）
- AWS_DEFAULT_REGION (or DEFAULT_REGION)
  AWS_DEFAULT_REGION（或DEFAULT_REGION）
- AWS_ENDPOINT (or ENDPOINT)
  AWS_ENDPOINT（或 ENDPOINT）
- AWS_CA_BUNDLE

## Restore with S3[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-s3.html#restore-with-s3) 使用 S3 恢复 ¶

```
$ xbcloud get s3://operator-testing/bak22 \
--s3-endpoint=https://storage.googleapis.com/ \
--parallel=10 2>download.log | xbstream -x -C restore --parallel=8
```

# Use the xbcloud binary with an IAM instance profile[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-iam-profile.html#use-the-xbcloud-binary-with-an-iam-instance-profile) 将 xbcloud 二进制文件与 IAM 实例配置文件结合使用 ¶

You can use the IAM instance profile when running xbcloud from an EC2 instance.
从 EC2 实例运行 xbcloud 时，您可以使用 IAM 实例配置文件。

An authentication system has two elements:
身份验证系统有两个元素：

- Who am I? 我是谁？
- What can I do?
  我能做些什么？

A role defines “what can I do.” A role provides a method to define a  collection of permissions. Roles are assigned to users, services and EC2 instances, the “who am I” element.
角色定义了“我能做什么”。角色提供用于定义权限集合的方法。角色分配给用户、服务和 EC2 实例，即“我是谁”元素。

The IAM instance profile is the “who” for an EC2 instance and assumes the  IAM role, which has permissions. The instance profile has the same name  as the IAM role.
IAM 实例配置文件是 EC2 实例的“谁”，并代入具有权限的 IAM 角色。实例配置文件与 IAM 角色同名。

An IAM instance profile does not need the `--s3-secret-key` nor the `--s3-access-key` if they are running `xbcloud` from an Amazon EC2 instance. To configure or attach an instance metadata to an EC2 instance, see [How can I grant my Amazon EC2 instance access to an Amazon S3 bucket](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-instance-access-s3-bucket/). 
如果 IAM 实例配置文件从 Amazon EC2 实例运行 `xbcloud` ， `--s3-secret-key` 则不需要 OR `--s3-access-key` 。要配置实例元数据或将实例元数据附加到 EC2 实例，请参阅如何授予 Amazon EC2 实例对 Amazon S3 存储桶的访问权限。

An example of the command:
命令示例：

```
$ xtrabackup ... | xbcloud put --storage=s3 --s3-bucket=bucket-name backup-name
```

The xbcloud binary outputs a connect message when successful.
xbcloud 二进制文件成功后输出连接消息。

<details class="example" open="" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa">
<summary data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="highlight" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa"><pre id="__code_1"><span></span></pre></div></details>

<details class="example" open="" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa"><div class="highlight" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa"><pre id="__code_1"><code>221121 13:16:26 Using instance metadata for access and secret key
221121 13:16:26 xbcloud: Successfully connected.
</code></pre></div>
</details>

An important consideration is that the instance metadata has a time to  live (TTL) of 6 hours. A backup that takes more than that time contains  Expired token errors. Use [Exponential Backoff](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html) to retry the upload after fetching new keys from the instance metadata.
一个重要的考虑因素是实例元数据的生存时间 （TTL） 为 6 小时。花费超过该时间的备份包含“令牌已过期”错误。使用指数退避在从实例元数据中获取新密钥后重试上传。

<details class="example" open="" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa">
<summary data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa" data-immersive-translate-paragraph="1">Output when keys have expired<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">密钥过期时的输出</font></font></font></summary>
<div class="highlight" data-immersive-translate-walked="a149a29c-8cf1-4ca0-8db9-2296a4d2c5aa"><pre id="__code_2"><span></span></pre></div></details>

```
221121 13:04:52 xbcloud: S3 error message: The provided token has expired.
221121 13:04:52 xbcloud: Sleeping for 2384 ms before retrying test/mysql.ibd.00000000000000000002 [1]
221121 13:04:55 xbcloud: S3 error message: The provided token has expired.
221121 13:04:55 xbcloud: Sleeping for 2887 ms before retrying test/mysql.ibd.00000000000000000003 [1]
221121 13:04:58 xbcloud: S3 error message: The provided token has expired.
221121 13:04:58 xbcloud: Sleeping for 2778 ms before retrying test/undo_002.00000000000000000000 [1]
221121 13:05:00 xbcloud: S3 error message: The provided token has expired.
221121 13:05:00 xbcloud: Sleeping for 2916 ms before retrying test/undo_002.00000000000000000001 [1]
221121 13:05:03 xbcloud: S3 error message: The provided token has expired.
221121 13:05:03 xbcloud: Sleeping for 2794 ms before retrying test/undo_002.00000000000000000002 [1]
221121 13:05:06 xbcloud: S3 error message: The provided token has expired.
221121 13:05:06 xbcloud: Sleeping for 2336 ms before retrying test/undo_001.00000000000000000000 [1]
221121 13:05:09 xbcloud: successfully uploaded chunk: test/mysql.ibd.00000000000000000002, size: 5242923
221121 13:05:09 xbcloud: successfully uploaded chunk: test/mysql.ibd.00000000000000000003, size: 23
221121 13:05:09 xbcloud: successfully uploaded chunk: test/undo_002.00000000000000000000, size: 10485802
221121 13:05:09 xbcloud: successfully uploaded chunk: test/undo_002.00000000000000000001, size: 6291498
221121 13:05:09 xbcloud: successfully uploaded chunk: test/undo_002.00000000000000000002, size: 22
221121 13:05:09 xbcloud: successfully uploaded chunk: test/undo_001.00000000000000000000, size: 10485802
221121 13:05:10 xbcloud: successfully uploaded chunk: test/undo_001.00000000000000000001, size: 6291498
221121 13:05:10 xbcloud: successfully uploaded chunk: test/undo_001.00000000000000000002, size: 22
. . .
221121 13:05:18 xbcloud: successfully uploaded chunk: test/xtrabackup_tablespaces.00000000000000000001, size: 36
221121 13:05:19 xbcloud: Upload completed. 
```

# Use the xbcloud binary with Swift[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#use-the-xbcloud-binary-with-swift) 将 xbcloud 二进制文件与 Swift 一起使用 ¶

## Create a full backup with Swift[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#create-a-full-backup-with-swift) 使用 Swift 创建完整备份 ¶

The following example shows how to make a full backup and upload it to Swift.
以下示例演示如何进行完整备份并将其上传到 Swift。

```
$ xtrabackup --backup --stream=xbstream --extra-lsndir=/tmp --target-dir=/tmp | \
xbcloud put --storage=swift \
--swift-container=test \
--swift-user=test:tester \
--swift-auth-url=http://192.168.8.80:8080/ \
--swift-key=testing \
--parallel=10 \
full_backup
```

The following OpenStack environment variables are also recognized and  mapped automatically to the corresponding swift parameters (`--storage=swift`):
以下 OpenStack 环境变量也被识别并自动映射到相应的 swift 参数 （ `--storage=swift` ）：

- OS_AUTH_URL
- OS_TENANT_NAME
- OS_TENANT_ID
- OS_USERNAME
- OS_PASSWORD
- OS_USER_DOMAIN
- OS_USER_DOMAIN_ID
- OS_PROJECT_DOMAIN
- OS_PROJECT_DOMAIN_ID
- OS_REGION_NAME
- OS_STORAGE_URL
- OS_CACERT

## Restore with Swift[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#restore-with-swift) 使用 Swift 恢复 ¶

```
$ xbcloud get [options] <name> [<list-of-files>] | xbstream -x
```

The following example shows how to fetch and restore the backup from Swift:
以下示例演示如何从 Swift 获取和恢复备份：

```
$ xbcloud get --storage=swift \
--swift-container=test \
--swift-user=test:tester \
--swift-auth-url=http://192.168.8.80:8080/ \
--swift-key=testing \
full_backup | xbstream -xv -C /tmp/downloaded_full

$ xbcloud delete --storage=swift --swift-user=xtrabackup \
--swift-password=xtrabackup123! --swift-auth-version=3 \
--swift-auth-url=http://openstack.ci.percona.com:5000/ \
--swift-container=mybackup1 --swift-domain=Default
```

## Command-line options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#command-line-options) 命令行选项 ¶

*xbcloud* has the following command line options:
xbcloud 具有以下命令行选项：

### –storage(=[swift|s3|google])[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#storageswifts3google) –storage（=[swift|s3|google]） ¶

Cloud storage option. *xbcloud* supports Swift, MinIO, and AWS S3. The default value is `swift`.
云存储选项。xbcloud 支持 Swift、MinIO 和 AWS S3。默认值为 `swift` 。

### –swift-auth-url()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-auth-url) –swift-auth-url（） ¶

The URL of the Swift cluster
Swift 集群的 URL

### –swift-storage-url()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-storage-url) –swift-storage-url（） ¶

The xbcloud tries to get the object-store URL for a given region (if any are specified) from the keystone response. You can override that URL by passing –swift-storage-url=URL argument.
xbcloud 尝试从 keystone 响应中获取给定区域（如果指定了任何）的对象存储 URL。您可以通过传递 –swift-storage-url=URL 参数来覆盖该 URL。

### –swift-user()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-user) –swift-user（） ¶

The Swift username (X-Auth-User, specific to Swift)
Swift 用户名（X-Auth-User，特定于 Swift）

### –swift-key()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-key) –swift-key（） ¶

The Swift key/password (X-Auth-Key, specific to Swift)
Swift 密钥/密码（X-Auth-Key，特定于 Swift）

### –swift-container()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-container) –swift-container（） ¶

The container to back up into (specific to Swift)
要备份到的容器（特定于 Swift）

### –parallel(=N)[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#paralleln) –parallel（=N） ¶

The maximum number of concurrent upload/download requests. The default value is `1`.
最大并发上传/下载请求数。默认值为 `1` 。

### –cacert()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#cacert) –cacert（） ¶

The path to the file with CA certificates
具有 CA 证书的文件的路径

### –insecure()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#insecure) –不安全（） ¶

Do not verify server’s certificate
不验证服务器的证书

### Swift authentication options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-authentication-options) Swift 身份验证选项 ¶

The Swift specification describes several [authentication options](http://docs.openstack.org/developer/swift/overview_auth.html). The *xbcloud* tool can authenticate against keystone with API version 2 and 3.
Swift 规范描述了几个身份验证选项。xbcloud 工具可以使用 API 版本 2 和 3 对 keystone 进行身份验证。

### –swift-auth-version()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-auth-version) –swift-auth-version（） ¶

Specifies the swift authentication version. The possible values are: `1.0` - TempAuth, `2.0` - Keystone v2.0, and `3` - Keystone v3. The default value is `1.0`.
指定 swift 身份验证版本。可能的值为： `1.0` - TempAuth、 `2.0` - Keystone v2.0 和 `3` - Keystone v3。默认值为 `1.0` 。

For v2 additional options are:
对于 v2，其他选项包括：

### –swift-tenant()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-tenant) –swift-tenant（） ¶

Swift tenant name Swift 租户名称

### –swift-tenant-id()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-tenant-id) –swift-tenant-id（） ¶

Swift tenant ID Swift 租户 ID

### –swift-region()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-region) –swift-region（） ¶

Swift endpoint region Swift 终端节点区域

### –swift-password()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-password) –swift-password（） ¶

Swift password for the user
用户的 Swift 密码

For v3 additional options are:
对于 v3，其他选项包括：

### –swift-user-id()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-user-id) –swift-user-id（） ¶

Swift user ID Swift 用户 ID

### –swift-project()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-project) –swift-project（） ¶

Swift project name Swift 项目名称

### –swift-project-id()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-project-id) –swift-project-id（） ¶

Swift project ID Swift 项目 ID

### –swift-domain()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-domain) –swift-domain（） ¶

Swift domain name Swift域名转让

### –swift-domain-id()[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-swift.html#swift-domain-id) –swift-domain-id（） ¶

Swift domain ID Swift 域 ID

# Use the xbcloud binary with Google Cloud Storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-gcs.html#use-the-xbcloud-binary-with-google-cloud-storage) 将 xbcloud 二进制文件与 Google Cloud Storage 结合使用 ¶

## Create a full backup with Google Cloud Storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-gcs.html#create-a-full-backup-with-google-cloud-storage) 使用 Google Cloud Storage 创建完整备份 ¶

The support for Google Cloud Storage is implemented using the interoperability mode. This mode was especially designed to interact with cloud services compatible with Amazon S3.
对 Google Cloud Storage 的支持是使用互操作性模式实现的。此模式专门设计用于与与 Amazon S3 兼容的云服务进行交互。

See also 另请参阅

[Cloud Storage Interoperability
云存储互操作性](https://cloud.google.com/storage/docs/interoperability)

```
$ xtrabackup --backup --stream=xbstream --extra-lsndir=/tmp --target-dir=/tmp | \
xbcloud put --storage=google \
--google-endpoint=`storage.googleapis.com` \
--google-access-key='YOUR-ACCESSKEYID' \
--google-secret-key='YOUR-SECRETACCESSKEY' \
--google-bucket='mysql_backups'
--parallel=10 \
$(date -I)-full_backup
```

The following options are available when using Google Cloud Storage:
使用 Google Cloud Storage 时，可以使用以下选项：

- –google-access-key = 
- –google-secret-key = 
- –google-bucket = 
- –google-storage-class=name
  –google-storage-class=名称

Note 注意

The Google storage class name options are the following:
Google 存储类名称选项如下：

- STANDARD 标准
- NEARLINE 近线
- COLDLINE 冷线
- ARCHIVE 档案

See also 另请参阅

[Google storage classes - the default Google storage class depends on  the storage class of the bucket
Google 存储类 - 默认的 Google 存储类取决于存储桶的存储类](https://cloud.google.com/storage/docs/changing-default-storage-class)

# Use the xbcloud binary with Microsoft Azure Cloud Storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-azure.html#use-the-xbcloud-binary-with-microsoft-azure-cloud-storage) 将 xbcloud 二进制文件与 Microsoft Azure 云存储配合使用 ¶

The xbcloud binary adds support for the Microsoft Azure Cloud Storage using the REST API.
xbcloud 二进制文件增加了对使用 REST API 的 Microsoft Azure 云存储的支持。

## Options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-azure.html#options) 选项 ¶

The following are the options, environment variables, and descriptions for  uploading a backup to Azure using the REST API. The environment  variables are recognized by xbcloud, which maps them automatically to  the corresponding parameters:
以下是使用 REST API 将备份上传到 Azure 的选项、环境变量和说明。环境变量由 xbcloud 识别，xbcloud 会自动将它们映射到相应的参数：

| Option name 选项名称                                    | Environment variables 环境变量 | Description 描述                                             |
| ------------------------------------------------------- | ------------------------------ | ------------------------------------------------------------ |
| –azure-storage-account=name –azure-storage-account=名称 | AZURE_STORAGE_ACCOUNT          | An Azure storage account is a unique namespace to access and store your Azure data objects. Azure 存储帐户是用于访问和存储 Azure 数据对象的唯一命名空间。 |
| –azure-container-name=name –azure-container-name=名称   | AZURE_CONTAINER_NAME           | A container name is a valid DNS name that conforms to the Azure naming rules 容器名称是符合 Azure 命名规则的有效 DNS 名称 |
| –azure-access-key=name –azure-access-key=名称           | AZURE_ACCESS_KEY               | A generated key that can be used to authorize access to data in your account using the Shared Key authorization. 生成的密钥，可用于使用共享密钥授权授权访问您账户中的数据。 |
| –azure-endpoint=name –azure-endpoint=名称               | AZURE_ENDPOINT                 | The endpoint allows clients to securely access data 端点允许客户端安全地访问数据 |
| –azure-tier-class=name –azure-tier-class=名称           | AZURE_STORAGE_CLASS            | Cloud tier can decrease the local storage required while maintaining the  performance. When enabled, this feature has the following categories:  云层可以在保持性能的同时减少所需的本地存储。启用后，此功能具有以下类别：  Hot - Frequently accessed or modified data  Hot - 经常访问或修改的数据  Cool - Infrequently accessed or modified data  冷 - 不经常访问或修改的数据  Archive - Rarely accessed or modified data 存档 - 很少访问或修改的数据 |

Test your Azure applications with the [Azurite open-source emulator](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio). For testing purposes, the xbcloud binary adds the `--azure-development-storage` option that uses the default `access_key` and `storage account` of azurite and `testcontainer` for the container. You can overwrite these options, if needed.
使用 Azurite 开源模拟器测试 Azure 应用程序。出于测试目的，xbcloud 二进制文件添加了使用默认 `access_key` 的 and `storage account` of azurite 和 `testcontainer` for the container 的 `--azure-development-storage` 选项。如果需要，可以覆盖这些选项。

## Usage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-azure.html#usage) 用法 ¶

All the available options for xbcloud, such as parallel,  max-retries, and others, can be used. For more information, see the [xbcloud binary overview](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-overview.html).
可以使用 xbcloud 的所有可用选项，例如并行、max-retries 等。有关详细信息，请参阅 xbcloud 二进制文件概述。

## Examples[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-azure.html#examples) 示例 ¶

An example of an xbcloud backup.
xbcloud 备份的示例。

```
$ xtrabackup --backup --stream=xbstream  | 
xbcloud put backup_name --azure-storage-account=pxbtesting --azure-access-key=$AZURE_KEY --azure-container-name=test --storage=azure
```

An example of restoring a backup from xbcloud.
从 xbcloud 还原备份的示例。

```
$ xbcloud get backup_name  --azure-storage-account=pxbtesting 
--azure-access-key=$AZURE_KEY --azure-container-name=test --storage=azure --parallel=10 2>download.log | xbstream -x -C restore
```

An example of deleting a backup from xbcloud.
从 xbcloud 删除备份的示例。

```
$ xbcloud delete backup_name --azure-storage-account=pxbtesting 
--azure-access-key=$AZURE_KEY --azure-container-name=test --storage=azure
```

An example of using a shortcut restore.
使用快捷方式还原的示例。

```
$ xbcloud get azure://operator-testing/bak22 ...
```

# Use the xbcloud binary with MinIO[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-minio.html#use-the-xbcloud-binary-with-minio) 将 xbcloud 二进制文件与 MinIO 一起使用 ¶

## Create a full backup with MinIO[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-minio.html#create-a-full-backup-with-minio) 使用 MinIO 创建完整备份 ¶

```
$ xtrabackup --backup --stream=xbstream --extra-lsndir=/tmp --target-dir=/tmp | \
xbcloud put --storage=s3 \
--s3-endpoint='play.minio.io:9000' \
--s3-access-key='YOUR-ACCESSKEYID' \
--s3-secret-key='YOUR-SECRETACCESSKEY' \
--s3-bucket='mysql_backups'
--parallel=10 \
$(date -I)-full_backup
```

# FIFO data sink[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html#fifo-data-sink) FIFO 数据接收器 ¶

The feature is in [tech preview](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#tech-preview).
该功能处于技术预览状态。

Percona XtraBackup implements a data sink that uses the first in, first out (FIFO) method. With the `FIFO` data sink feature, users with a streaming capacity of 10Gbps (typically on a Local Area Network (LAN)) can benefit from faster backups by  streaming data in parallel to an object storage.
Percona XtraBackup实现了使用先进先出（FIFO）方法的数据接收器。借助 `FIFO` 数据接收器功能，流容量为 10Gbps（通常在局域网 （LAN） 上）的用户可以通过将数据并行流式传输到对象存储，从而从更快的备份中受益。

## FIFO data sink options[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html#fifo-data-sink-options) FIFO 数据接收器选项 ¶

Percona XtraBackup implements the following options:
Percona XtraBackup实现了以下选项：

- `--fifo-streams=#` - specifies the number of FIFO files to use for parallel data stream. To disable FIFO data sink and send stream to STDOUT, set `--fifo-streams=1`. The default value is `1` (STDOUT) to ensure the backward compatibility. The `--fifo-streams` value must match on both the XtraBackup and xbcloud sides.
   `--fifo-streams=#` - 指定用于并行数据流的 FIFO 文件数。要禁用 FIFO 数据接收器并将流发送到 STDOUT，请设置 `--fifo-streams=1` 。默认值为 `1` （STDOUT） 以确保向后兼容性。该 `--fifo-streams` 值必须在 XtraBackup 和 xbcloud 端匹配。
- `--fifo-dir=name` - specifies a directory to write Named Pipe.
   `--fifo-dir=name` - 指定要写入 Named Pipe 的目录。
- `--fifo-timeout=#` - specifies the number of seconds to wait for the other end to open the stream for reading. The default value is `60` seconds.
   `--fifo-timeout=#` - 指定等待另一端打开流进行读取的秒数。默认值为 `60` seconds。

## How to enable FIFO data sink[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html#how-to-enable-fifo-data-sink) 如何启用 FIFO 数据接收器 ¶

To use FIFO data sink, you can either run two commands in separate terminal sessions or run xtrabackup in the background.
要使用 FIFO 数据接收器，您可以在单独的终端会话中运行两个命令，也可以在后台运行 xtrabackup。

For example, run the following commands in separate terminal sessions:
例如，在单独的终端会话中运行以下命令：

```
$ xtrabackup --backup --stream --fifo-streams=2 --fifo-dir=/tmp/fifo
$ xbcloud put --fifo-streams=2 --fifo-dir=/tmp/fifo full
```

Run xtrabackup in the background with the following commands:
使用以下命令在后台运行 xtrabackup：

```
$ xtrabackup --backup --stream --fifo-streams=2 --fifo-dir=/tmp/fifo &
$ xbcloud put --fifo-streams=2 --fifo-dir=/tmp/fifo full
```

## Stream to an object storage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html#stream-to-an-object-storage) 流式传输到对象存储 ¶

When taking a backup, you can save the files locally or stream the files to either a different server or an object storage. 
进行备份时，可以将文件保存在本地，也可以将文件流式传输到其他服务器或对象存储。

When you stream backups to Amazon S3 compatible storage using LAN with a  streaming capacity of 10Gbps, XtraBackup can use multiple FIFO streams  to stream the backups faster. 
当您使用流式处理容量为 10Gbps 的 LAN 将备份流式传输到 Amazon S3 兼容存储时，XtraBackup 可以使用多个 FIFO 流来更快地流式传输备份。

XtraBackup spawns multiple copy threads and each copy thread reads a data chunk  from a specific file. Then multiple FIFO files are created to store the  data from XtraBackup. Each XtraBackup copy thread writes the data chunks to a specific FIFO file. Xbcloud reads from the FIFO streams and  uploads data to an object storage using an async request. The xbcloud  event handler executes the callback depending on the response from the  object storage (success or failure). 
XtraBackup会生成多个复制线程，每个复制线程从特定文件中读取一个数据块。然后创建多个FIFO文件来存储来自XtraBackup的数据。每个 XtraBackup 复制线程将数据块写入特定的 FIFO 文件。Xbcloud 从 FIFO  流中读取数据，并使用异步请求将数据上传到对象存储。xbcloud 事件处理程序根据对象存储的响应（成功或失败）执行回调。

![image](https://docs.percona.com/percona-xtrabackup/innovation-release/_static/fifo-datasink.png)

## Performance improvement[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-binary-fifo-datasink.html#performance-improvement) 性能提升 ¶

Consider an example of using a FIFO data sink compared to the STDOUT method.
考虑一个使用 FIFO 数据接收器与 STDOUT 方法相比的示例。

The database has 1TB of data in multiple tables. The link speed between the source server and destination server using MinIO is ~ 9.2 Gbps.
该数据库在多个表中具有 1TB 的数据。使用 MinIO 的源服务器和目标服务器之间的链路速度为 ~ 9.2 Gbps。

Both STDOUT and FIFO data sink scenarios push 1TB of data from two servers.
STDOUT 和 FIFO 数据接收器方案都从两台服务器推送 1TB 的数据。

For the FIFO data sink we configure 8 parallel streams with `--fifo-streams=8` both for XtraBackup and xbcloud.
对于 FIFO 数据接收器，我们为 XtraBackup 和 xbcloud 配置了 8 个并行流 `--fifo-streams=8` 。

The results are the following:
结果如下：

- The `STDOUT` method takes 01:25:24 to push 1TB of data using 239 MBps (1.8 Gbps).
  该 `STDOUT` 方法需要 01：25：24 才能使用 239 MBps （1.8 Gbps） 推送 1TB 数据。
- The `FIFO` method, using 8 streams, takes 00:16:01 to push 1TB of data using 1.15 GBps (9.2 Gbps).
  该 `FIFO` 方法使用 8 个流，需要 00：16：01 才能使用 1.15 GBps （9.2 Gbps） 推送 1TB 数据。

# Exponential backoff[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html#exponential-backoff) 指数退避 ¶

Exponential backoff increases the chances for the completion of a backup or a restore operation. For example, a chunk upload or download may fail if you have an unstable network connection or other network issues. This feature adds an exponential backoff, or sleep, time and then retries the upload or download.
指数退避会增加完成备份或还原操作的机会。例如，如果网络连接不稳定或其他网络问题，则区块上传或下载可能会失败。此功能会添加指数退避或休眠时间，然后重试上传或下载。

When a chunk upload or download operation fails, xbcloud checks the reason for the failure. This failure can be a CURL error or an HTTP error, or a client-specific error. If the error is listed in the [Retriable errors](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html#retriable-errors) list, xbcloud pauses for a calculated time before retrying the operation until that time reaches the `--max-backoff` value.
当区块上传或下载操作失败时，xbcloud 会检查失败的原因。此故障可能是 CURL 错误或 HTTP 错误，也可能是特定于客户端的错误。如果错误列在“可重试错误”列表中，则 xbcloud 会暂停计算一段时间，然后再重试操作，直到该时间达到该 `--max-backoff` 值。

The operation is retried until the `--max-retries` value is reached. If the chunk operation fails on the last retry, xbcloud aborts the process.
该操作将重试，直到达到该 `--max-retries` 值。如果块操作在最后一次重试时失败，xbcloud 将中止该进程。

The default values are the following:
默认值如下：

- –max-backoff = 300000 (5 minutes)
  –max-backoff = 300000（5 分钟）
- –max-retries = 10 –最大重试次数 = 10

You can adjust the number of retries by adding the `--max-retries` parameter and adjust the maximum length of time between retries by adding the `--max-backoff` parameter to an xbcloud command.
您可以通过添加 `--max-retries` 参数来调整重试次数，并通过将 `--max-backoff` 参数添加到 xbcloud 命令来调整重试之间的最大时间长度。

Since xbcloud does multiple asynchronous requests in parallel, a calculated value, measured in milliseconds, is used for `max-backoff`. This algorithm calculates how many milliseconds to sleep before the next retry. A number generated is based on the combining the power of two (2), the number of retries already attempted and adds a random number between 1 and 1000. This number avoids network congestion if multiple chunks have the same backoff value. If the default values are used, the final retry attempt to be approximately 17 minutes after the first try. The number is no longer calculated when the milliseconds reach the `--max-backoff` setting. At that point, the retries continue by using the `--max-backoff` setting until the `max-retries` parameter is reached.
由于 xbcloud 并行执行多个异步请求，因此使用 `max-backoff` 以毫秒为单位的计算值。此算法计算在下次重试之前休眠的毫秒数。生成的数字基于两 （2） 的幂、已尝试的重试次数的组合，并将 1 到 1000  之间的随机数相加。如果多个区块具有相同的回退值，则此数字可避免网络拥塞。如果使用默认值，则最后一次重试尝试大约在第一次尝试后 17  分钟。当毫秒达到设置时 `--max-backoff` ，不再计算该数字。此时，使用该 `--max-backoff` 设置继续重试，直到达到该 `max-retries` 参数。

## Retriable errors[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html#retriable-errors) 可重找的错误 ¶

We retry for the following CURL operations:
我们重试以下 CURL 操作：

- CURLE_GOT_NOTHING
- CURLE_OPERATION_TIMEOUT
- CURLE_RECV_ERROR
- CURLE_SEND_ERROR
- CURLE_SEND_FAIL_REWIND
- CURLE_PARTIAL_FILE
- CURLE_SSL_CONNECT_ERROR

We retry for the following HTTP operation status codes:
我们重试以下 HTTP 操作状态代码：

- 503
- 500
- 504
- 408

Each cloud provider may return a different CURL error or an HTTP error, depending on the issue. Add new errors by setting the following variables `--curl-retriable-errors` or `--http-retriable-errors` on the command line or in `my.cnf` or in a custom configuration file under the [xbcloud] section. You can add multiple errors using a comma-separated list of codes.
每个云提供商可能会返回不同的 CURL 错误或 HTTP 错误，具体取决于问题。通过设置以下变量 `--curl-retriable-errors` 或 `--http-retriable-errors` 在命令行上或在 [xbcloud] 部分下的自定义配置文件中 `my.cnf` 或自定义配置文件中添加新错误。您可以使用逗号分隔的代码列表添加多个错误。

The error handling is enhanced when using the `--verbose` output. This output specifies which error caused xbcloud to fail and what parameter a user must add to retry on this error.
使用 `--verbose` 输出时，错误处理得到增强。此输出指定导致 xbcloud 失败的错误，以及用户必须添加什么参数才能重试此错误。

The following is an example of a verbose output:
以下是详细输出的示例：

<details class="example" data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8" open="">
<summary data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8"><pre><span></span><code tabindex="0">210701 14:34:23 /work/pxb/ins/8.3/bin/xbcloud: Operation failed. Error: Server returned nothing (no headers, no data)
210701 14:34:23 /work/pxb/ins/8.3/bin/xbcloud: Curl error (52) Server returned nothing (no headers, no data) is not configured as retriable. You can allow it by adding --curl-retriable-errors=52 parameter
</code></pre></div>
</details>

## Example[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html#example) 示例 ¶

The following example adjusts the maximum number of retries and the maximum time between retries.
以下示例调整最大重试次数和重试之间的最大时间。

```
xbcloud [options] --max-retries=5 --max-backoff=10000
```

The following list describes the process using `--max-backoff=10000`:
以下列表描述了使用以下方法 `--max-backoff=10000` 的过程：

- The chunk `xtrabackup_logfile.00000000000000000006` fails to upload the first time and sleeps for 2384 milliseconds.
  该块第一次上传 `xtrabackup_logfile.00000000000000000006` 失败，休眠 2384 毫秒。
- The same chunk fails for the second time and the sleep time is increased to 4387 milliseconds.
  同一块第二次失败，睡眠时间增加到 4387 毫秒。
- The same chunk fails for the third time and the sleep time is increased to 8691 milliseconds.
  同一块第三次失败，睡眠时间增加到 8691 毫秒。
- The same chunk fails for the fourth time. The `max-backoff` parameter has been reached. All retries sleep the same amount of time after reaching the parameter.
  同一块第四次失败。已达到该 `max-backoff` 参数。所有重试在达到参数后都以相同的时间休眠。
- The same chunk is successfully uploaded.
  成功上传相同的块。

<details class="example" data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8" open="">
<summary data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8" data-immersive-translate-paragraph="1">An example of the output for this setting<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">此设置的输出示例</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="913df07f-841e-47f1-85a4-e26e83473ae8"><pre><span></span><code tabindex="0">210702 10:07:05 /work/pxb/ins/8.3/bin/xbcloud: Operation failed. Error: Server returned nothing (no headers, no data)
210702 10:07:05 /work/pxb/ins/8.3/bin/xbcloud: Sleeping for 2384 ms before retrying backup3/xtrabackup_logfile.00000000000000000006
. . .
210702 10:07:23 /work/pxb/ins/8.3/bin/xbcloud: Operation failed. Error: Server returned nothing (no headers, no data)
210702 10:07:23 /work/pxb/ins/8.3/bin/xbcloud: Sleeping for 4387 ms before retrying backup3/xtrabackup_logfile.00000000000000000006
. . .
210702 10:07:52 /work/pxb/ins/8.3/bin/xbcloud: Operation failed. Error: Failed sending data to the peer
210702 10:07:52 /work/pxb/ins/8.3/bin/xbcloud: Sleeping for 8691 ms before retrying backup3/xtrabackup_logfile.00000000000000000006
. . .
210702 10:08:47 /work/pxb/ins/8.3/bin/xbcloud: Operation failed. Error: Failed sending data to the peer
210702 10:08:47 /work/pxb/ins/8.3/bin/xbcloud: Sleeping for 10000 ms before retrying backup3/xtrabackup_logfile.00000000000000000006
. . .
210702 10:10:12 /work/pxb/ins/8.3/bin/xbcloud: successfully uploaded chunk: backup3/xtrabackup_logfile.00000000000000000006, size: 8388660
</code></pre></div>
</details>

## Get expert help[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xbcloud-exbackoff.html#get-expert-help) 获取专家帮助 ¶

# Backup process overview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/backup-overview.html#backup-process-overview) 备份流程概述 ¶

Percona Xtrabackup is a tool that allows you to create backups of MySQL or  MariaDB databases. It works by copying the data files and the binary log files of the server, while ensuring that the data is consistent and not corrupted by ongoing transactions. Percona Xtrabackup can also prepare  the backup files for restoration, apply incremental backups, and stream  the backup files to another server or storage device.
Percona  Xtrabackup是一个工具，允许您创建MySQL或MariaDB数据库的备份。它的工作原理是复制服务器的数据文件和二进制日志文件，同时确保数据一致且不会被正在进行的事务损坏。Percona Xtrabackup还可以准备备份文件进行恢复，应用增量备份，并将备份文件流式传输到另一台服务器或存储设备。

## Backup types[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/backup-overview.html#backup-types) 备份类型 ¶

You can take and prepare the following types of backups:
您可以创建并准备以下类型的备份：

- [Full backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-full-backup.html) - a backup of all the contents of the database
  完整备份 - 数据库所有内容的备份
- [Incremental backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-incremental-backup.html) - a backup of only the files that have changed since the last full backup
  增量备份 - 仅备份自上次完整备份以来已更改的文件
- [Compressed backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-compressed-backup.html) - a backup of all the contents of the database with applying a  compression algorithm that reduces the size of the data to be stored
  压缩备份 - 通过应用压缩算法来备份数据库的所有内容，该算法可减小要存储的数据的大小
- [Partial backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html) - a backup of only the files that have changed in a specific folder or a set of folders, rather than the entire database
  部分备份 - 仅备份特定文件夹或一组文件夹中已更改的文件，而不是整个数据库
- [Individual partitions backup](https://docs.percona.com/percona-xtrabackup/innovation-release/create-individual-partition-backup.html) - a backup of an individual partition
  单个分区备份 - 单个分区的备份

## Backup restoration[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/backup-overview.html#backup-restoration) 备份恢复 ¶

- [Restore full, incremental, compressed backups
  还原完整、增量、压缩的备份](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-a-backup.html)
- [Restore a partial backup
  还原部分备份](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-partial-backup.html)
- [Restore an individual partitions backup
  还原单个分区备份](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-partitions.html)
- [Restore individual tables
  还原单个表](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html)

# Create a full backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-full-backup.html#create-a-full-backup) 创建完整备份 ¶

To create a backup, run xtrabackup with the `--backup` option. You also must specify the `--target-dir` option, which is where the backup is stored. If the InnoDB data or log files are not stored in the same directory, you must specify their location. If the target directory does not exist, xtrabackup creates it. If the directory does exist and is empty, xtrabackup succeeds.
要创建备份，请使用该 `--backup` 选项运行 xtrabackup。您还必须指定存储备份的 `--target-dir` 选项。如果 InnoDB 数据或日志文件未存储在同一目录中，则必须指定其位置。如果目标目录不存在，则 xtrabackup 会创建它。如果该目录确实存在并且为空，则 xtrabackup 成功。

xtrabackup does not overwrite existing files. It will fail with operating system error 17, `file exists`.
XtraBackup 不会覆盖现有文件。它将失败，并出现操作系统错误 17 和 `file exists` 。

The following command starts the process:
以下命令启动该过程：

```
$ xtrabackup --backup --target-dir=/data/backups/
```

This operation stores the backup at `/data/backups/`. If you specify a relative path, the target directory is relative to the current directory.
此操作将备份存储在 `/data/backups/` 。如果指定相对路径，则目标目录相对于当前目录。

During the backup process, the output shows the copied data files, and a log file thread that scans and copies from the log files.
在备份过程中，输出显示复制的数据文件，以及扫描和复制日志文件的日志文件线程。

The following is an example of the output:
以下是输出的示例：

<details class="example" data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3" open="">
<summary data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3"><pre><span></span><code>160906 10:19:17 Finished backing up non-InnoDB tables and files
160906 10:19:17 Executing FLUSH NO_WRITE_TO_BINLOG ENGINE LOGS...
xtrabackup: The latest check point (for incremental): '62988944'
xtrabackup: Stopping log copying thread.
.160906 10:19:18 &gt;&gt; log scanned up to (137343534)
160906 10:19:18 Executing UNLOCK TABLES
160906 10:19:18 All tables unlocked
160906 10:19:18 Backup created in directory '/data/backups/'
160906 10:19:18 [00] Writing backup-my.cnf
160906 10:19:18 [00]        ...done
160906 10:19:18 [00] Writing xtrabackup_info
160906 10:19:18 [00]        ...done
xtrabackup: Transaction log of lsn (26970807) to (137343534) was copied.
160906 10:19:18 completed OK!
</code></pre></div>
</details>

The process ends with the following statement; the value of the `<LSN>` depends on your system:
该过程以以下语句结束;的 `<LSN>` 值取决于您的系统：

```
$ xtrabackup: Transaction log of lsn (<LSN>) to (<LSN>) was copied.
```

Note 注意

Log copying thread checks the transactional log every second to see if  there were any new log records written that need to be copied, but there is a chance that the log copying thread might not be able to keep up  with the amount of writes that go to the transactional logs, and will  hit an error when the log records are overwritten before they could be  read.
日志复制线程每秒检查一次事务日志，以查看是否有任何需要复制的新日志记录，但日志复制线程可能无法跟上对事务日志的写入量，并且在日志记录被覆盖之前会遇到错误。

After the backup is finished, the target directory will contain files such as the following, assuming you have a single InnoDB table `test.tbl1` and you are using MySQL’s innodb_file_per_table option:
备份完成后，目标目录将包含如下文件，假设您有一个 InnoDB 表 `test.tbl1` 并且您正在使用 MySQL 的 innodb_file_per_table 选项：

```
$ ls -lh /data/backups/
```

The result should look like this:
结果应如下所示：

<details class="example" data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3" open="">
<summary data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="de8bb5f9-ef85-46da-8e4e-cfd68c739bd3"><pre><span></span><code>total 182M
drwx------  7 root root 4.0K Sep  6 10:19 .
drwxrwxrwt 11 root root 4.0K Sep  6 11:05 ..
-rw-r-----  1 root root  387 Sep  6 10:19 backup-my.cnf
-rw-r-----  1 root root  76M Sep  6 10:19 ibdata1
drwx------  2 root root 4.0K Sep  6 10:19 mysql
drwx------  2 root root 4.0K Sep  6 10:19 performance_schema
drwx------  2 root root 4.0K Sep  6 10:19 sbtest
drwx------  2 root root 4.0K Sep  6 10:19 test
drwx------  2 root root 4.0K Sep  6 10:19 world2
-rw-r-----  1 root root  116 Sep  6 10:19 xtrabackup_checkpoints
-rw-r-----  1 root root  433 Sep  6 10:19 xtrabackup_info
-rw-r-----  1 root root 106M Sep  6 10:19 xtrabackup_logfile
</code></pre></div>
</details>

The backup can take a long time, depending on how large the database is. It is safe to cancel at any time, because xtrabackup does not modify the  database.
备份可能需要很长时间，具体取决于数据库的大小。随时取消是安全的，因为 xtrabackup 不会修改数据库。

# Prepare a full backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-full-backup.html#prepare-a-full-backup) 准备完整备份 ¶

After creating a backup with the `--backup` option, you need to prepare the backup and then [restore](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-a-backup.html) it. Data files are not point-in-time consistent until they are prepared, because they were copied at  different times as the program ran, and they might have been changed  while this was happening.
使用该 `--backup` 选项创建备份后，您需要准备备份，然后还原它。数据文件在准备之前不是时间点一致的，因为它们在程序运行时在不同的时间复制，并且它们可能在发生这种情况时已更改。

If you try to start InnoDB with these data files, it will detect  corruption and stop working to avoid running on damaged data. The `--prepare` step makes the files perfectly consistent at a single instant in time, so you can run InnoDB on them.
如果您尝试使用这些数据文件启动 InnoDB，它将检测到损坏并停止工作以避免在损坏的数据上运行。该 `--prepare` 步骤使文件在单个时刻完全一致，因此您可以在其上运行 InnoDB。

You can run the prepare operation on any machine; it does not need to be on the originating server or the server to which you intend to restore.  You can copy the backup to a utility server and prepare it there.
您可以在任何计算机上运行准备操作;它不需要位于原始服务器或要还原到的服务器上。您可以将备份复制到实用程序服务器并在其中进行准备。

Note that Percona XtraBackup 8.3 can only prepare backups of MySQL 8.3 and Percona Server for MySQL 8.3 databases. Releases prior to 8.3 are not supported.
请注意，Percona XtraBackup 8.3 只能准备 MySQL 8.3 和 Percona Server for MySQL 8.3 数据库的备份。不支持 8.3 之前的版本。

During the prepare operation, xtrabackup boots up a kind of modified embedded  InnoDB (the libraries xtrabackup was linked against). The modifications  are necessary to disable InnoDB standard safety checks, such as  complaining about the log file not being the right size. This warning is not appropriate for working with backups. These modifications are only  for the xtrabackup binary; you do not need a modified InnoDB to use  xtrabackup for your backups.
在准备操作期间，xtrabackup 会启动一种经过修改的嵌入式 InnoDB（链接到 xtrabackup 的库）。这些修改对于禁用 InnoDB  标准安全检查是必要的，例如抱怨日志文件大小不正确。此警告不适用于使用备份。这些修改仅适用于 xtrabackup 二进制文件;您不需要修改后的  InnoDB 即可使用 xtrabackup 进行备份。

The prepare step uses this “embedded InnoDB” to perform crash recovery on the copied data files, using the copied log file. The `prepare` step is very simple to use: you simply run xtrabackup with the `--prepare` option and tell it which directory to prepare, for example, to prepare the previously taken backup run:
准备步骤使用此“嵌入式 InnoDB”，使用复制的日志文件对复制的数据文件执行崩溃恢复。该 `prepare` 步骤使用起来非常简单：您只需使用该 `--prepare` 选项运行 xtrabackup 并告诉它要准备哪个目录，例如，准备之前执行的备份运行：

```
$ xtrabackup --prepare --target-dir=/data/backups/
```

When this finishes, you should see an `InnoDB shutdown` with a message such as the following, where again the value of LSN will depend on your system:
完成此操作后，您应该会看到一条 `InnoDB shutdown` 消息，如下所示，其中 LSN 的值将再次取决于您的系统：

<details class="example" data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430" open="">
<summary data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 137345046
160906 11:21:01 completed OK!
</code></pre></div>
</details>

All following prepares will not change the already prepared data files, you’ll see that output says:
以下所有准备工作都不会更改已准备好的数据文件，您将看到输出显示：

<details class="example" data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430" open="">
<summary data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="139fc657-1170-4cdf-8416-59d1dd930430"><pre><span></span><code>xtrabackup: This target seems to be already prepared.
xtrabackup: notice: xtrabackup_logfile was already used to '--prepare'.
</code></pre></div>
</details>

It is not recommended to interrupt xtrabackup process while preparing  backup because it may cause data files corruption and backup will become unusable. Backup validity is not guaranteed if prepare process was  interrupted.
不建议在准备备份时中断xtrabackup进程，因为这可能会导致数据文件损坏，备份将变得不可用。如果准备过程中断，则无法保证备份的有效性。

Note 注意

If you intend the backup to be the basis for further incremental backups, you should use the `--apply-log-only` option when preparing the backup, or you will not be able to apply  incremental backups to it. See the documentation on preparing  incremental backups for more details.
如果希望将备份作为进一步增量备份的基础，则应在准备备份时使用该 `--apply-log-only` 选项，否则将无法对其应用增量备份。有关更多详细信息，请参阅有关准备增量备份的文档。



# Create an incremental backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-incremental-backup.html#create-an-incremental-backup) 创建增量备份 ¶

xtrabackup supports incremental backups, which means that they can copy only all  the data that has changed since the last backup.
XtraBackup 支持增量备份，这意味着它们只能复制自上次备份以来已更改的所有数据。

Note 注意

Incremental backups on the MyRocks storage engine do not determine if an earlier  full backup or incremental backup contains the same files. Percona  XtraBackup copies all the MyRocks files each time it takes a backup.
MyRocks 存储引擎上的增量备份无法确定早期的完整备份或增量备份是否包含相同的文件。Percona XtraBackup在每次备份时都会复制所有MyRocks文件。

You can perform many incremental backups between each full backup, so you  can set up a backup process such as a full backup once a week and an  incremental backup every day, or full backups every day and incremental  backups every hour.
您可以在每个完整备份之间执行许多增量备份，因此您可以设置备份过程，例如每周一次完整备份和每天增量备份，或者每天完整备份和每小时增量备份。

Incremental backups work because each InnoDB page contains a log sequence number, or LSN. The LSN is the system version number for the entire database. Each page’s LSN shows how recently it was changed.
增量备份之所以有效，是因为每个 InnoDB 页面都包含一个日志序列号或 LSN。LSN 是整个数据库的系统版本号。每个页面的 LSN 显示它最近更改的时间。

An incremental backup copies each page which LSN is newer than the previous incremental or full backup’s LSN. An algorithm finds the pages  that match the criteria. The algorithm reads the data pages and checks  the page LSN.
增量备份将复制每个页面，其中 LSN 比以前的增量备份或完整备份的 LSN 更新。算法查找与条件匹配的页面。该算法读取数据页并检查页 LSN。

## Create an incremental backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-incremental-backup.html#create-an-incremental-backup_1) 创建增量备份 ¶

To make an incremental backup, begin with a full backup as usual. The xtrabackup binary writes a file called `xtrabackup_checkpoints` into the backup’s target directory. This file contains a line showing the `to_lsn`, which is the database’s LSN at the end of the backup. Create the full backup with a following command:
要进行增量备份，请像往常一样从完整备份开始。xtrabackup 二进制文件将调用 `xtrabackup_checkpoints` 的文件写入备份的目标目录。此文件包含一行，显示 `to_lsn` ，这是备份末尾的数据库的 LSN。使用以下命令创建完整备份：

```
$ xtrabackup --backup --target-dir=/data/backups/base
```

If you look at the `xtrabackup_checkpoints` file, you should see similar content depending on your LSN nuber:
如果您查看该 `xtrabackup_checkpoints` 文件，您应该会看到类似的内容，具体取决于您的 LSN nuber：

<details class="example" open="" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d">
<summary data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d"><pre><span></span><code>backup_type = full-backuped
from_lsn = 0
to_lsn = 1626007
last_lsn = 1626007
compact = 0
recover_binlog_info = 1
</code></pre></div>
</details>

Now that you have a full backup, you can make an incremental backup based on it. Use the following command:
现在您已经有了完整备份，您可以基于它进行增量备份。使用以下命令：

```
$ xtrabackup --backup --target-dir=/data/backups/inc1 \
--incremental-basedir=/data/backups/base
```

The `/data/backups/inc1/` directory should now contain delta files, such as `ibdata1.delta` and `test/table1.ibd.delta`. These represent the changes since the `LSN 1626007`. If you examine the `xtrabackup_checkpoints` file in this directory, you should see similar content to the following:
该 `/data/backups/inc1/` 目录现在应包含增量文件，例如 `ibdata1.delta` 和 `test/table1.ibd.delta` 。这些表示自 `LSN 1626007` .如果检查此目录中的 `xtrabackup_checkpoints` 文件，应会看到与以下内容类似的内容：

<details class="example" open="" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d">
<summary data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d"><pre><span></span><code>backup_type = incremental
from_lsn = 1626007
to_lsn = 4124244
last_lsn = 4124244
compact = 0
recover_binlog_info = 1
</code></pre></div>
</details>

`from_lsn` is the starting LSN of the backup and for incremental it has to be the same as `to_lsn` (if it is the last checkpoint) of the previous/base backup.
 `from_lsn` 是备份的起始 LSN，对于增量备份，它必须与 `to_lsn` 上一个/基础备份的 LSN 相同（如果它是最后一个检查点）。

It’s now possible to use this directory as the base for yet another incremental backup:
现在可以将此目录用作另一个增量备份的基础：

```
$ xtrabackup --backup --target-dir=/data/backups/inc2 \
--incremental-basedir=/data/backups/inc1
```

This folder also contains the `xtrabackup_checkpoints`:
此文件夹还包含： `xtrabackup_checkpoints` 

<details class="example" open="" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d">
<summary data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="4c5d584f-2cd5-44a5-b556-37f2d5d54f8d"><pre><span></span><code>backup_type = incremental
from_lsn = 4124244
to_lsn = 6938371
last_lsn = 7110572
compact = 0
recover_binlog_info = 1
</code></pre></div>
</details>

Note 注意

In this case you can see that there is a difference between the `to_lsn` (last checkpoint LSN) and `last_lsn` (last copied LSN), this means that there was some traffic on the server during the backup process.
在这种情况下，您可以看到 `to_lsn` （最后一个检查点 LSN）和 `last_lsn` （上次复制的 LSN）之间存在差异，这意味着在备份过程中服务器上存在一些流量。

# Prepare an incremental backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-incremental-backup.html#prepare-an-incremental-backup) 准备增量备份 ¶

The `--prepare` step for incremental backups is not the same as for full backups. In full backups, two types of operations are performed to make the database consistent: committed transactions are replayed from the log file against the data files, and uncommitted transactions are rolled back. You must skip the rollback of uncommitted transactions when preparing an incremental backup, because transactions that were uncommitted at the time of your backup may be in progress, and it’s likely that they will be committed in the next incremental backup. You should use the `--apply-log-only` option to prevent the rollback phase.
增量备份的 `--prepare`  步骤与完整备份的步骤不同。在完整备份中，将执行两种类型的操作来使数据库保持一致：根据数据文件从日志文件中重放已提交的事务，以及回滚未提交的事务。在准备增量备份时，必须跳过未提交事务的回滚，因为在备份时未提交的事务可能正在进行中，并且很可能在下一次增量备份中提交。您应该使用该 `--apply-log-only` 选项来防止回滚阶段。

Warning 警告

If you do not use the `--apply-log-only` option to prevent the rollback phase, then your incremental backups  will be useless. After transactions have been rolled back, further  incremental backups cannot be applied.
如果不使用该 `--apply-log-only` 选项来阻止回滚阶段，则增量备份将毫无用处。事务回滚后，无法应用进一步的增量备份。

Beginning with the full backup you created, you can prepare it, and then apply the incremental differences to it. Recall that you have the following backups:
从您创建的完整备份开始，您可以准备它，然后将增量差异应用于它。回想一下，您有以下备份：

```
/data/backups/base
/data/backups/inc1
/data/backups/inc2
```

To prepare the base backup, you need to run `--prepare` as usual, but prevent the rollback phase:
若要准备基本备份，需要照常运行 `--prepare` ，但要阻止回滚阶段：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base
```

The output should end with text similar to the following:
输出应以类似于以下内容的文本结尾：

<details class="example" open="" data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211">
<summary data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211"><pre><span></span><code>InnoDB: Shutdown completed; log sequence number 1626007
161011 12:41:04 completed OK!
</code></pre></div>
</details>

The log sequence number should match the `to_lsn` of the base backup, which you saw previously.
日志序列号应与您 `to_lsn` 之前看到的基本备份的序列号匹配。

Warning 警告

This backup is actually safe to restore as-is now, even though the rollback  phase has been skipped. If you restore it and start MySQL, InnoDB will  detect that the rollback phase was not performed, and it will do that in the background, as it usually does for a crash recovery upon start. It  will notify you that the database was not shut down normally.
即使跳过了回滚阶段，此备份现在也可以安全地按原样恢复。如果您恢复它并启动 MySQL，InnoDB 将检测到未执行回滚阶段，并且它将在后台执行此操作，就像通常在启动时进行崩溃恢复一样。它会通知您数据库未正常关闭。

To apply the first incremental backup to the full backup, run the following command:
若要将第一个增量备份应用于完整备份，请运行以下命令：

```
$ xtrabackup --prepare --apply-log-only --target-dir=/data/backups/base \
--incremental-dir=/data/backups/inc1
```

This applies the delta files to the files in `/data/backups/base`, which rolls them forward in time to the time of the incremental backup. It then applies the redo log as usual to the result. The final data is in `/data/backups/base`, not in the incremental directory. You should see an output similar to:
这会将增量文件应用于 中的 `/data/backups/base` 文件，从而将它们及时前滚到增量备份的时间。然后，它像往常一样将重做日志应用于结果。最终数据位于 中 `/data/backups/base` ，而不是增量目录中。您应该会看到类似于以下内容的输出：

<details class="example" open="" data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211">
<summary data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="2b26b61f-d10f-4475-b64b-76cf2e15f211"><pre><span></span><code>incremental backup from 1626007 is enabled.
xtrabackup: cd to /data/backups/base
xtrabackup: This target seems to be already prepared with --apply-log-only.
xtrabackup: xtrabackup_logfile detected: size=2097152, start_lsn=(4124244)
...
xtrabackup: page size for /tmp/backups/inc1/ibdata1.delta is 16384 bytes
Applying /tmp/backups/inc1/ibdata1.delta to ./ibdata1...
...
161011 12:45:56 completed OK!
</code></pre></div>
</details>

Again, the LSN should match what you saw from your earlier inspection of the first incremental backup. If you restore the files from `/data/backups/base`, you should see the state of the database as of the first incremental backup.
同样，LSN 应与您之前检查第一个增量备份时看到的内容相匹配。如果从 `/data/backups/base` 还原文件，则应看到数据库在第一次增量备份时的状态。

Warning 警告

Percona XtraBackup does not support using the same incremental backup directory to prepare two copies of backup. Do not run `--prepare` with the same incremental backup directory (the value of –incremental-dir) more than once.
Percona XtraBackup不支持使用相同的增量备份目录来准备两个备份副本。不要多次使用相同的增量备份目录（–incremental-dir 的值）运行 `--prepare` 。

Preparing the second incremental backup is a similar process: apply the deltas to the (modified) base backup, and you will roll its data forward in time to the point of the second incremental backup:
准备第二个增量备份的过程与此类似：将增量应用于（修改后的）基础备份，然后将其数据及时向前滚动到第二个增量备份的点：

```
$ xtrabackup --prepare --target-dir=/data/backups/base \
--incremental-dir=/data/backups/inc2
```

Note 注意

`--apply-log-only` should be used when merging the incremental backups except the last one. That’s why the previous line does not contain the `--apply-log-only` option. Even if the `--apply-log-only` was used on the last step, backup would still be consistent but in that case server would perform the rollback phase.
 `--apply-log-only` 在合并增量备份时应使用，但最后一个备份除外。这就是为什么上一行不包含该 `--apply-log-only` 选项的原因。即使在最后一步中使用了备份 `--apply-log-only` ，备份仍将保持一致，但在这种情况下，服务器将执行回滚阶段。

# Take an incremental backup using page tracking[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#take-an-incremental-backup-using-page-tracking) 使用页面跟踪进行增量备份 ¶

To create an incremental backup with page tracking, Percona XtraBackup uses the MySQL `mysqlbackup` component. This component provides a list of pages modified since the last backup, and Percona XtraBackup copies only those pages. This operation removes the need to scan the pages in the database. If the majority of pages have not been modified, the page tracking feature can improve the speed of incremental backups.
为了创建具有页面跟踪功能的增量备份，Percona XtraBackup使用MySQL `mysqlbackup` 组件。此组件提供自上次备份以来修改的页面列表，Percona XtraBackup 仅复制这些页面。此操作无需扫描数据库中的页面。如果大部分页面没有被修改，页面跟踪功能可以提高增量备份的速度。

## Install the component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#install-the-component) 安装组件 ¶

To start using the page tracking functionality, do the following:
要开始使用页面跟踪功能，请执行以下操作：

1. Install the `mysqlbackup` component and enable it on the server:
   安装 `mysqlbackup` 组件并在服务器上启用它：

   ```
   
   ```

```
$ INSTALL COMPONENT "file://component_mysqlbackup";
```

Check whether the `mysqlbackup` component is installed successfully:
检查 `mysqlbackup` 组件安装是否成功：

1. ```
   $ SELECT COUNT(1) FROM mysql.component WHERE component_urn='file://component_mysqlbackup';
   ```

## Use page tracking[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#use-page-tracking) 使用页面跟踪 ¶

You can enable the page tracking functionality for the full and incremental backups with the `--page-tracking` option.
您可以使用该 `--page-tracking` 选项为完整备份和增量备份启用页面跟踪功能。

The option has the following benefits:
该选项具有以下优点：

- Resets page tracking to the start of the backup. This reset allows the next incremental backup to use page tracking.
  将页面跟踪重置为备份的开始。此重置允许下一个增量备份使用页面跟踪。
- Allows the use of page tracking for an incremental backup if the page tracking data is available from the backup’s start checkpoint LSN.
  如果页面跟踪数据可从备份的起始检查点 LSN 获得，则允许使用页面跟踪进行增量备份。

Percona XtraBackup processes a list of all the tracked pages in memory. If  Percona XtraBackup does not have enough available memory to process this list, the process throws an error and exits. For example, if an  incremental backup uses 200GB, Percona XtraBackup can use an additional  100MB of memory to process and store the page tracking data. 
Percona XtraBackup处理内存中所有跟踪页面的列表。如果Percona  XtraBackup没有足够的可用内存来处理此列表，则该进程将引发错误并退出。例如，如果增量备份使用 200GB，Percona  XtraBackup 可以使用额外的 100MB 内存来处理和存储页面跟踪数据。

The examples of creating full and incremental backups using the `--page-tracking` option:
使用以下 `--page-tracking` 选项创建完整备份和增量备份的示例：

[Full backup 完整备份](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#__tabbed_1_1)[Incremental backup 增量备份](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#__tabbed_1_2)

```
$ xtrabackup --backup --target-dir=$FULL_BACK --page-tracking

$ xtrabackup --backup --target-dir=$INC_BACKUP  
--incremental-basedir=$FULL_BACKUP --page-tracking
```

After enabling the functionality, the next incremental backup finds changed pages using page tracking.
启用该功能后，下一个增量备份将使用页面跟踪查找已更改的页面。

The first full backup using page tracking, Percona XtraBackup may have a delay. The following is an example of the message:
使用页面跟踪的第一个完整备份，Percona XtraBackup可能会有延迟。以下是该消息的示例：

<details class="example" data-immersive-translate-walked="18c38e33-b096-4a16-86fd-d8ef4230b223" open="">
<summary data-immersive-translate-walked="18c38e33-b096-4a16-86fd-d8ef4230b223" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="18c38e33-b096-4a16-86fd-d8ef4230b223"><pre><span></span><code>xtrabackup: pagetracking: Sleeping for 1 second, waiting for checkpoint lsn 17852922 /
to reach to page tracking start lsn 21353759
</code></pre></div>
</details>

Enable page tracking before creating the first backup to avoid this delay.  This method ensures that the page tracking log sequence number (LSN) is  higher than the checkpoint LSN of the server.
在创建第一个备份之前启用页面跟踪以避免此延迟。此方法可确保页面跟踪日志序列号 （LSN） 高于服务器的检查点 LSN。

## Start page tracking manually[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#start-page-tracking-manually) 手动起始页跟踪 ¶

After the mysqlbackup component is loaded and active on the server, you can start page tracking manually with the following option:
在服务器上加载并激活 mysqlbackup 组件后，您可以使用以下选项手动启动页面跟踪：

```
$ SELECT mysqlbackup_page_track_set(true);
```

## Check the LSN value[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#check-the-lsn-value) 检查 LSN 值 ¶

Check the LSN value starting from which changed pages are tracked with the following option:
使用以下选项检查从跟踪已更改页面开始的 LSN 值：

```
$ SELECT mysqlbackup_page_track_get_start_lsn();
```

## Stop page tracking[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#stop-page-tracking) 停止页面跟踪 ¶

To stop page tracking, use the following command:
若要停止页面跟踪，请使用以下命令：

```
$ SELECT mysqlbackup_page_track_set(false);
```

## Purge page tracking data[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#purge-page-tracking-data) 清除页面跟踪数据 ¶

When you start page tracking, it creates a file under the server’s datadir to collect data about changed pages. This file grows until you stop the page tracking. If you stop the server and then restart it, page tracking creates a new file but also keeps the old one. The old file continues to grow until you stop the page tracking explicitly.
当您开始页面跟踪时，它会在服务器的 datadir 下创建一个文件，以收集有关已更改页面的数据。此文件会一直增长，直到您停止页面跟踪。如果停止服务器，然后重新启动它，页面跟踪将创建一个新文件，但也会保留旧文件。旧文件会继续增长，直到您显式停止页面跟踪。

If you purge the page tracking data, you should create a full backup afterward. To purge the page tracking data, do the following steps:
如果清除页面跟踪数据，则应在之后创建完整备份。要清除页面跟踪数据，请执行以下步骤：

```
$ SELECT mysqlbackup_page_track_set(false);
$ SELECT mysqlbackup_page_track_purge_up_to(9223372036854775807);
/* Specify the LSN up to which you want to purge page tracking data. /
9223372036854775807 is the highest possible LSN which purges all page tracking files.*/
$ SELECT mysqlbackup_page_track_set(true);
```

## Known issue[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#known-issue) 已知问题 ¶

If the index is built in place using an exclusive algorithm and then is added to a table after the last LSN checkpoint, you may generate a bad incremental backup using page tracking. For more details see [PS-8032](https://jira.percona.com/browse/PS-8032).
如果索引是使用独占算法就地构建的，然后在最后一个 LSN 检查点之后添加到表中，则可能会使用页面跟踪生成错误的增量备份。有关详细信息，请参阅 PS-8032。

## Uninstall the mysqlbackup component[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/page-tracking.html#uninstall-the-mysqlbackup-component) 卸载 mysqlbackup 组件 ¶

To uninstall the mysqlbackup component, use the following statement:
要卸载 mysqlbackup 组件，请使用以下语句：

```
$ UNINSTALL COMPONENT "file://component_mysqlbackup"
```

# Create a compressed backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-compressed-backup.html#create-a-compressed-backup) 创建压缩备份 ¶

Percona XtraBackup supports compressed backups. To make a compressed backup, use the `--compress` option along with the `--backup` and `--target-dir` options. A local or streaming backup can be compressed or decompressed with [xbstream](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-binary-overview.html).
Percona XtraBackup支持压缩备份。要进行压缩备份，请将该 `--compress` 选项与 and `--backup` `--target-dir` 选项一起使用。可以使用 xbstream 压缩或解压缩本地或流式备份。

By default, the `--compress` option uses the `zstandard` tool that you can install with the `percona-release` package configuration tool as follows:
默认情况下，该 `--compress` 选项使用可通过 `percona-release` 包配置工具安装 `zstandard` 的工具，如下所示：

```
$ sudo percona-release enable tools
$ sudo apt update
$ sudo apt install zstandard
```

Note 注意

Enable the repository: `percona-release enable-only tools release`.
启用存储库： `percona-release enable-only tools release` .

If Percona XtraBackup is intended to be used in combination with the upstream MySQL Server, you only need to enable the `tools` repository: `percona-release enable-only tools`.
如果Percona XtraBackup打算与上游MySQL Server结合使用，则只需启用 `tools` 存储库： `percona-release enable-only tools` 。

Percona XtraBackup supports the following compression algorithms:
Percona XtraBackup支持以下压缩算法：

## Zstandard (ZSTD)[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-compressed-backup.html#zstandard-zstd) Zstandard （ZSTD） ¶

The Zstandard (ZSTD) is a fast lossless compression algorithm that targets  real-time compression scenarios and better compression ratios. `ZSTD` is the default compression algorithm for the `--compress` option.
Zstandard （ZSTD） 是一种快速无损压缩算法，针对实时压缩场景和更好的压缩比。 `ZSTD` 是 `--compress` 该选项的默认压缩算法。

To compress files using the `ZSTD` compression algorithm, use the `--compress` option:
要使用 `ZSTD` 压缩算法压缩文件，请使用以下 `--compress` 选项：

```
$ xtrabackup --backup --compress --target-dir=/data/backup
```

The resulting files have the `\*.zst` format.
生成的文件具有以下 `\*.zst` 格式。

You can specify `ZSTD` compression level with the [`--compress-zstd-level(=#)`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#compress-zstd-level) option. The default value is `1`.
您可以使用该 `--compress-zstd-level(=#)` 选项指定 `ZSTD` 压缩级别。默认值为 `1` 。

```
$ xtrabackup –backup –compress –compress-zstd-level=1 –target-dir=/data/backup
```

## lz4[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-compressed-backup.html#lz4)

To compress files using the `lz4` compression algorithm, set the `--compress` option to `lz4`:
要使用 `lz4` 压缩算法压缩文件，请将 `--compress` 选项设置为 `lz4` ：

```
$ xtrabackup --backup --compress=lz4 --target-dir=/data/backup
```

The resulting files have the `\*.lz4` format. 
生成的文件具有以下 `\*.lz4` 格式。

If you want to speed up the compression you can use the parallel compression, which can be enabled with `--compress-threads` option. Following example will use four threads for compression:
如果要加快压缩速度，可以使用并行压缩，可以通过 `--compress-threads` 选项启用。以下示例将使用四个线程进行压缩：

```
$ xtrabackup --backup --compress --compress-threads=4 \
--target-dir=/data/compressed/
```

<details class="example" data-immersive-translate-walked="ce8ff4d2-6c0b-4230-8ee2-a3a98cc031d5" open="">
<summary data-immersive-translate-walked="ce8ff4d2-6c0b-4230-8ee2-a3a98cc031d5" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="ce8ff4d2-6c0b-4230-8ee2-a3a98cc031d5"><pre><span></span><code>...
170223 13:00:38 [01] Compressing ./test/sbtest1.frm to /tmp/compressed/test/sbtest1.frm.qp
170223 13:00:38 [01]        ...done
170223 13:00:38 [01] Compressing ./test/sbtest2.frm to /tmp/compressed/test/sbtest2.frm.qp
170223 13:00:38 [01]        ...done
...
170223 13:00:39 [00] Compressing xtrabackup_info
170223 13:00:39 [00]        ...done
xtrabackup: Transaction log of lsn (9291934) to (9291934) was copied.
170223 13:00:39 completed OK!
</code></pre></div>
</details>

# Prepare the backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-compressed-backup.html#prepare-the-backup) 准备备份 ¶

Before you can prepare the backup you’ll need to uncompress all the files. Percona XtraBackup has implemented `--decompress` option that can be used to decompress the backup.
在准备备份之前，您需要解压缩所有文件。Percona XtraBackup已实现 `--decompress` 可用于解压缩备份的选项。

```
$ xtrabackup --decompress --target-dir=/data/compressed/
```

Note 注意

`--parallel` can be used with `--decompress` option to decompress multiple files simultaneously. 
 `--parallel` 可以与同时解压缩多个文件的选项一起 `--decompress` 使用。

Percona XtraBackup does not automatically remove the compressed files. In order to clean up the backup directory you should use `--remove-original` option. Even if they’re not removed these files will not be copied/moved over to the datadir if `--copy-back` or `--move-back` are used.
Percona XtraBackup不会自动删除压缩文件。为了清理备份目录，您应该使用 `--remove-original` 选项。即使它们没有被删除，这些文件也不会被 `--copy-back` 复制/移动到 datadir（如果被使用）。 `--move-back` 

When the files are uncompressed you can prepare the backup with the `--prepare` option:
解压缩文件后，您可以使用以下 `--prepare` 选项准备备份：

```
$ xtrabackup --prepare --target-dir=/data/compressed/
```

<details class="example" open="" data-immersive-translate-walked="95dd9e1f-7be5-4d4c-bdb0-1589ec8616f3">
<summary data-immersive-translate-walked="95dd9e1f-7be5-4d4c-bdb0-1589ec8616f3" data-immersive-translate-paragraph="1">Confirmation message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">确认消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="95dd9e1f-7be5-4d4c-bdb0-1589ec8616f3"><pre><span></span><code>InnoDB: Starting shutdown...
InnoDB: Shutdown completed; log sequence number 9293846
170223 13:39:31 completed OK!
</code></pre></div>
</details>

Now the files in `/data/compressed/` are ready to be used by the server.
现在，中的 `/data/compressed/` 文件已准备好供服务器使用。

# Create a partial backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html#create-a-partial-backup) 创建部分备份 ¶

xtrabackup supports taking partial backups when the `innodb_file_per_table` option is enabled.
启用该 `innodb_file_per_table` 选项后，XtraBackup 支持进行部分备份。

Warning 警告

Do not copy back the prepared backup.
不要复制回准备好的备份。

Restoring partial backups should be done by importing the tables. We do not by using the `–copy-back` option. This operation may lead to database inconsistencies.
还原部分备份应通过导入表来完成。我们没有使用选项 `–copy-back` 。此操作可能会导致数据库不一致。

We do not recommend running incremental backups after taking a partial backup.
我们不建议在进行部分备份后运行增量备份。

The xtrabackup binary fails if you delete any of the matched or listed tables during the backup.
如果在备份过程中删除任何匹配或列出的表，则 xtrabackup 二进制文件将失败。

There are multiple ways of specifying which part of the whole data is backed up:
有多种方法可以指定备份整个数据的哪一部分：

- Use the `--tables` option to list the table names
  使用该 `--tables` 选项列出表名称
- Use the `--tables-file` option to list the tables in a file
  使用该 `--tables-file` 选项列出文件中的表
- Use the `--databases` option to list the databases
  使用该 `--databases` 选项列出数据库
- Use the `--databases-file` option to list the databases
  使用该 `--databases-file` 选项列出数据库

The following examples assume a database named `test` that contains tables named `t1` and `t2`.
以下示例假定一个名为 `test` 的数据库包含名为 `t1` 和 `t2` 的表。

[`–-tables` option `–-tables` 选择](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html#__tabbed_1_1)[`-–tables-file` option `-–tables-file` 选择](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html#__tabbed_1_2)[`--databases` option `--databases` 选择](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html#__tabbed_1_3)[`--databases-file` option `--databases-file` 选择](https://docs.percona.com/percona-xtrabackup/innovation-release/create-partial-backup.html#__tabbed_1_4)

The first method involves the xtrabackup `–tables` option. The option’s value is a regular expression that is matched against the fully-qualified database name and table name using the `databasename.tablename` format.
第一种方法涉及 xtrabackup `–tables` 选项。该选项的值是一个正则表达式，该正则表达式与使用以下 `databasename.tablename` 格式的完全限定数据库名称和表名称进行匹配。

To back up only tables in the `test` database, use the following command:
若要仅备份数据库中的 `test` 表，请使用以下命令：

```
$ xtrabackup --backup --datadir=/var/lib/mysql --target-dir=/data/backups/ \
--tables="^test[.].*"
```

To back up only the `test.t1` table, use the following command:
若要仅备份 `test.t1` 表，请使用以下命令：

```
$ xtrabackup --backup --datadir=/var/lib/mysql --target-dir=/data/backups/ \
--tables="^test[.]t1"
```

The `--tables-file` option specifies a file that can contain multiple table names, one table name per line in the file. Only the tables named in the file will be backed up. Names are matched exactly, case-sensitive, with no pattern or regular expression matching. The table names must be fully-qualified in `databasename.tablename` format.
该 `--tables-file` 选项指定一个可以包含多个表名的文件，文件中每行一个表名。仅备份文件中命名的表。名称完全匹配，区分大小写，没有模式或正则表达式匹配。表名的 `databasename.tablename` 格式必须是完全限定的。

```
$ echo "mydatabase.mytable" > /tmp/tables.txt
$ xtrabackup --backup --tables-file=/tmp/tables.txt
```

The ` –databases` option accepts a space-separated list of the databases and tables to backup in the `databasename[.tablename]` format. In addition to this list, make sure to specify the `mysql`, `sys`, and
“–databases”选项接受以空格分隔的数据库和表列表，以以下 `databasename[.tablename]` 格式进行备份。除了此列表之外，请确保指定 `mysql` 、 `sys` 和

`performance_schema` databases. These databases are required when restoring the databases using xtrabackup –copy-back.
 `performance_schema` 数据库。使用 xtrabackup –copy-back 还原数据库时，这些数据库是必需的。

Note 注意

Tables processed during the –prepare step may also be added to the backup even if they are not explicitly listed by the parameter if they were created after the backup started.
在 –prepare 步骤中处理的表也可以添加到备份中，即使参数未显式列出这些表（如果它们是在备份开始后创建的）。

```
$ xtrabackup --databases='mysql sys performance_schema test ...'
```

The –databases-file option specifies a file that can contain multiple databases and tables in the `databasename[.tablename]` format, one element name per line in the file. Names are matched  exactly, case-sensitive, with no pattern or regular expression matching.
–databases-file 选项指定一个文件，该文件可以包含多个 `databasename[.tablename]` 数据库和表，格式为文件中每行一个元素名称。名称完全匹配，区分大小写，没有模式或正则表达式匹配。

Note 注意

Tables processed during the –prepare step may also be added to the backup even if they are not explicitly listed by the parameter if they were created after the backup started.
在 –prepare 步骤中处理的表也可以添加到备份中，即使参数未显式列出这些表（如果它们是在备份开始后创建的）。

# Prepare a partial backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-partial-backup.html#prepare-a-partial-backup) 准备部分备份 ¶

The procedure is analogous to restoring individual tables: apply the logs and use the `--export` option:
该过程类似于还原单个表：应用日志并使用以下 `--export` 选项：

```
$ xtrabackup --prepare --export --target-dir=/path/to/partial/backup
```

When you use the `--prepare` option on a partial backup, you will see warnings about tables that don’t exist. This is because these tables exist in the data dictionary inside InnoDB, but the corresponding .ibd files don’t exist. They were not copied into the backup directory. These tables will be removed from the data dictionary, and when you restore the backup and start InnoDB, they will no longer exist and will not cause any errors or warnings to be printed to the log file.
在部分备份上使用该 `--prepare` 选项时，您将看到有关不存在的表的警告。这是因为这些表存在于 InnoDB 的数据字典中，但相应的 .ibd  文件不存在。它们未复制到备份目录中。这些表将从数据字典中删除，当您还原备份并启动 InnoDB  时，它们将不再存在，并且不会导致将任何错误或警告打印到日志文件中。

Could not find any file associated with the tablespace ID: 5
找不到与表空间 ID 关联的任何文件： 5

Use `--innodb-directories` to find the tablespace files. If that fails then use `-–innodb-force-recovery=1` to ignore this and to permanently lose all changes to the missing tablespace(s).
用于 `--innodb-directories` 查找表空间文件。如果失败，则用于 `-–innodb-force-recovery=1` 忽略此操作并永久丢失对丢失的表空间的所有更改。

# Create an individual partitions backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/create-individual-partition-backup.html#create-an-individual-partitions-backup) 创建单个分区备份 ¶

Percona XtraBackup lets you back up individual partitions because partitions are regular tables with  specially formatted names. The only requirement for this feature is to  enable the `innodb_file_per_table` option on the server.
Percona XtraBackup允许您备份单个分区，因为分区是具有特殊格式名称的常规表。此功能的唯一要求是在服务器上启用该 `innodb_file_per_table` 选项。

There is one caveat about using this kind of backup: you can not copy back the prepared backup. Restoring partial backups should be done by importing the tables.
使用这种备份有一个注意事项：您不能复制回准备好的备份。还原部分备份应通过导入表来完成。

There are three ways of specifying which part of the whole data will be backed up: regular expressions (`--tables`), enumerating the tables in a file (`--tables-file`) or providing a list of databases (`--databases`).
有三种方法可以指定要备份整个数据的哪一部分：正则表达式 （ `--tables` ）、枚举文件中的表 （ `--tables-file` ） 或提供数据库列表 （ `--databases` ）。

The regular expression provided to this option will be matched against the fully qualified database name and table name, in the form of `database-name.table-name`.
提供给此选项的正则表达式将与完全限定的数据库名称和表名称进行匹配，格式为 `database-name.table-name` 。

If the partition 0 is not backed up, Percona XtraBackup cannot generate a  .cfg file. MySQL 8.0 stores the table metadata in partition 0.
如果未备份分区 0，Percona XtraBackup 将无法生成 .cfg 文件。MySQL 8.0 将表元数据存储在分区 0 中。

For example, this operation takes a back-up of the partition `p4` from  the table `name` located in the database `imdb`:
例如，此操作 `p4` 从位于数据库 `imdb` 中的表 `name` 中备份分区：

```
$ xtrabackup --tables=^imdb[.]name#p#p4 --backup
```

If partition 0 is not backed up, the following errors may occur:
如果未备份分区 0，可能会出现以下错误：

<details class="example" open="" data-immersive-translate-walked="2a5a1e08-3b0c-4da3-ad49-6cfabcd1153a">
<summary data-immersive-translate-walked="2a5a1e08-3b0c-4da3-ad49-6cfabcd1153a" data-immersive-translate-paragraph="1">The error message<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">错误消息</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="2a5a1e08-3b0c-4da3-ad49-6cfabcd1153a"><pre><span></span><code>xtrabackup: export option not specified
xtrabackup: error: cannot find dictionary record of table imdb/name#p#p4
</code></pre></div>
</details>

Note that this option is passed to `xtrabackup --tables` and is matched against each table of each database, the directories of each database will be created even if they are empty.
请注意，此选项将传递给 `xtrabackup --tables` 每个数据库的每个表并与之匹配，即使每个数据库的目录为空，也会创建它们。

# Prepare an individual partitions backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/prepare-individual-partitions-backup.html#prepare-an-individual-partitions-backup) 准备单个分区备份 ¶

For preparing partial backups, the procedure is analogous to restoring individual tables. Apply the logs and use xtrabackup `--export`:
对于准备部分备份，该过程类似于还原单个表。应用日志并使用 xtrabackup `--export` ：

```
$ xtrabackup --apply-log --export /mnt/backup/2012-08-28_10-29-09
```

You may see warnings in the output about tables that do not exist. This happens because InnoDB-based engines stores its data dictionary inside the tablespace files. xtrabackup removes the missing tables (those that haven’t been selected in the partial backup) from the data dictionary in order to avoid future warnings or errors.
您可能会在输出中看到有关不存在的表的警告。发生这种情况是因为基于 InnoDB 的引擎将其数据字典存储在表空间文件中。XtraBackup 会从数据字典中删除缺少的表（部分备份中未选择的表），以避免将来出现警告或错误。

# Restore full, incremental, compressed backups[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-a-backup.html#restore-full-incremental-compressed-backups) 恢复完整、增量、压缩备份 ¶

Warning 警告

Backup needs to be prepared before it can be restored.
在恢复备份之前，需要准备备份。

For convenience, *xtrabackup* binary has the `--copy-back` option to copy the backup to the datadir of the server:
为方便起见，xtrabackup 二进制文件 `--copy-back` 可以选择将备份复制到服务器的 datadir：

```
$ xtrabackup --copy-back --target-dir=/data/backups/
```

If you don’t want to save your backup, you can use the `--move-back` option which will move the backed up data to the datadir.
如果您不想保存备份，可以使用将备份的数据移动到 datadir 的 `--move-back` 选项。

If you don’t want to use any of the above options, you can additionally use rsync or cp to restore the files.
如果您不想使用上述任何选项，还可以使用 rsync 或 cp 来恢复文件。

Note 注意

The datadir must be empty before restoring the backup. Also, it’s important to note that MySQL server needs to be shut down before restore is  performed. You cannot restore to a datadir of a running mysqld instance  (except when importing a partial backup).
在还原备份之前，datadir 必须为空。另外，需要注意的是，在执行还原之前，需要关闭MySQL服务器。您无法还原到正在运行的 mysqld 实例的 datadir（导入部分备份时除外）。

Example of the rsync command that can be used to restore the backup can look like this:
可用于还原备份的 rsync 命令示例如下所示：

```
$ rsync -avrP /data/backup/ /var/lib/mysql/
```

You should check that the restored files have the correct ownership and permissions.
您应该检查还原的文件是否具有正确的所有权和权限。

As files’ attributes are preserved, in most cases you must change the files’ ownership to `mysql` before starting the database server, as the files are owned by the user who created the backup:
由于文件的属性是保留的，因此在大多数情况下，必须将文件的所有权更改为 `mysql` 在启动数据库服务器之前，因为这些文件归创建备份的用户所有：

```
$ chown -R mysql:mysql /var/lib/mysql
```

Data is now restored, and you can start the server.
数据现已恢复，您可以启动服务器。

# Restore a partial backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-partial-backup.html#restore-a-partial-backup) 恢复部分备份 ¶

Restoring should be done by restoring individual tables in the partial backup to the server.
还原应通过将部分备份中的单个表还原到服务器来完成。

It can also be done by copying back the prepared backup to a “clean” datadir (in that case, make sure to include the `mysql` database) to the datadir you are moving the backup to. A system database can be created with the following:
也可以通过将准备好的备份复制回“干净”的 datadir（在这种情况下，请确保包含 `mysql` 数据库）到要将备份移动到的 datadir 来完成。可以使用以下命令创建系统数据库：

```
$ sudo mysql --initialize --user=mysql
```

Once you start the server, you may see mysql complaining about missing tablespaces:
启动服务器后，您可能会看到 mysql 抱怨缺少表空间：

<details class="example" open="" data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b">
<summary data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b"><pre><span></span><code tabindex="0">2021-07-19T12:42:11.077200Z 1 [Warning] [MY-012351] [InnoDB] Tablespace 4, name 'test1/t1', file './d2/test1.ibd' is missing!
2021-07-19T12:42:11.077300Z 1 [Warning] [MY-012351] [InnoDB] Tablespace 4, name 'test1/t1', file './d2/test1.ibd' is missing!
</code></pre></div>
</details>

In order to clean the orphan database from the data dictionary, you must  manually create the missing database directory and then `DROP` this database from the server.
为了从数据字典中清除孤立数据库，必须手动创建缺少的数据库目录，然后 `DROP` 从服务器创建此数据库。

Example of creating the missing database:
创建缺少的数据库的示例：

```
$ mkdir /var/lib/mysql/test1/d2
```

Example of dropping the database from the server:
从服务器中删除数据库的示例：

```
mysql> DROP DATABASE d2;
```

<details class="example" open="" data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b">
<summary data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="996a509c-660c-4160-bb0d-db7f39ce7b9b"><pre><span></span><code>Query OK, 2 rows affected (0.5 sec)
</code></pre></div>
</details>

# Restore the partition from the backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-partitions.html#restore-the-partition-from-the-backup) 从备份中恢复分区 ¶

Restoring should be done by importing the tables in the partial backup to the server.
还原应通过将部分备份中的表导入到服务器来完成。

First step is to create new table in which data will be restored.
第一步是创建将在其中恢复数据的新表。

```
mysql> CREATE TABLE `name_p4` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` text NOT NULL,
`imdb_index` varchar(12) DEFAULT NULL,
`imdb_id` int(11) DEFAULT NULL,
`name_pcode_cf` varchar(5) DEFAULT NULL,
`name_pcode_nf` varchar(5) DEFAULT NULL,
`surname_pcode` varchar(5) DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2812744 DEFAULT CHARSET=utf8
```

Note 注意

Generate a [.cfg metadata file](https://dev.mysql.com/doc/refman/8.3/en/innodb-table-import.html) by running `FLUSH TABLES ... FOR EXPORT`. The command can only be run on a table, not on the individual table partitions. The file is located in the table schema directory and is used for schema verification when importing the tablespace. 
通过运行 `FLUSH TABLES ... FOR EXPORT` .该命令只能在表上运行，而不能在单个表分区上运行。该文件位于表模式目录中，用于导入表空间时的模式验证。

To restore the partition from the backup, the tablespace must be discarded for that table:
要从备份中恢复分区，必须放弃该表的表空间：

```
mysql> ALTER TABLE name_p4 DISCARD TABLESPACE;
```

The next step is to copy the `.ibd` file from the backup to the MySQL data directory:
下一步是将 `.ibd` 文件从备份复制到MySQL数据目录：

```
cp /mnt/backup/2012-08-28_10-29-09/imdb/name#P#p4.ibd /var/lib/mysql/imdb/name_p4.ibd
```

Note 注意

Make sure that the copied files can be accessed by the user running MySQL. 
确保运行MySQL的用户可以访问复制的文件。

The last step is to import the tablespace:
最后一步是导入表空间：

```
mysql> ALTER TABLE name_p4 IMPORT TABLESPACE;
```

# xtrabackup exit codes[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-exit-codes.html#xtrabackup-exit-codes) XtraBackup 退出代码 ¶

The *xtrabackup* binary exits with the traditional success value of 0 after a backup  when no error occurs. If an error occurs during the backup, the exit  value is 1.
当没有发生错误时，xtrabackup 二进制文件在备份后以传统的成功值 0 退出。如果备份过程中发生错误，则退出值为 1。

In certain cases, the exit value can be something other than 0 or 1, due to the command-line option code included from the *MySQL* libraries. An unknown command-line option, for example, will cause an exit code of 255.
在某些情况下，由于MySQL库中包含的命令行选项代码，退出值可能不是0或1。例如，未知的命令行选项将导致退出代码为 255。

# Update curl utility 更新 curl 实用程序

## Update the curl utility in Debian 10[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/update-curl-utility.html#update-the-curl-utility-in-debian-10) 更新 Debian 10 中的 curl 实用程序 ¶

The default curl version, 7.64.0, in Debian 10 has known issues when attempting to reuse an already closed connection. This issue directly affects `xbcloud` and users may see intermittent backup failures.
Debian 10 中的默认 curl 版本 7.64.0 在尝试重用已关闭的连接时存在已知问题。此问题直接影响 `xbcloud` 用户，用户可能会看到间歇性备份失败。

For more details, see [curl #3750](https://github.com/curl/curl/issues/3750) or [curl #3763](https://github.com/curl/curl/pull/3763).
有关详细信息，请参阅 curl #3750 或 curl #3763。

Follow these steps to upgrade curl to version 7.74.0:
按照以下步骤将 curl 升级到版本 7.74.0：

1. Edit the `/etc/apt/sources.list` to add the following:
   编辑以 `/etc/apt/sources.list` 添加以下内容：

   ```
   
   ```

```
deb http://ftp.de.debian.org/debian buster-backports main
```

Refresh the `apt` sources:
刷新 `apt` 源：

```
$ sudo apt update
```

Install the version from `buster-backports`:
从 `buster-backports` 以下位置安装版本：

```
$ sudo apt install curl/buster-backports
```

Verify the version number:
验证版本号：

```
$ curl --version
```

<details class="example" open="" data-immersive-translate-walked="d79a8b6f-eb2f-4819-bf51-ae7cf157feca">
<summary data-immersive-translate-walked="d79a8b6f-eb2f-4819-bf51-ae7cf157feca" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="d79a8b6f-eb2f-4819-bf51-ae7cf157feca"><pre><span></span><code>curl 7.74.0 (x86_64-pc-linux-gnu) libcurl/7.74.0
</code></pre></div>
</details>

# ndex of files created by Percona XtraBackup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-files.html#index-of-files-created-by-percona-xtrabackup) Percona XtraBackup创建的文件索引 ¶

- Information related to the backup and the server
  与备份和服务器相关的信息

| File Name 文件名          | Description 描述                                             |
| ------------------------- | ------------------------------------------------------------ |
| `backup-my.cnf`           | This file contains information to start the mini instance of InnoDB during the `--prepare`. This **not** a backup of the original `my.cnf`. The InnoDB configuration is read from the file `backup-my.cnf` created by **xtrabackup** when the backup was made. The `--prepare` uses InnoDB configuration from `backup-my.cnf` by default, or from `--defaults-file`, if specified. The InnoDB’s configuration in this context means server variables that affect dataformat, i.e., `innodb_page_size` option, `innodb_log_block_size`, etc. Location-related variables, like `innodb_log_group_home_dir` or `innodb_data_file_path` are always ignored by `--prepare`, so preparing a backup always works with data files from the back directory, rather than any external ones. 此文件包含用于在 `--prepare` .这不是原始 `my.cnf` 的备份。InnoDB 配置是从 xtrabackup 在进行备份时创建的文件中 `backup-my.cnf` 读取的。默认情况下使用 `--prepare` InnoDB 配置 from `backup-my.cnf` ，如果指定，则使用 from `--defaults-file` 。在这种情况下，InnoDB的配置意味着影响数据格式的服务器变量，即 `innodb_page_size` option等 `innodb_log_block_size` 。与位置相关的变量，例如 `innodb_log_group_home_dir` 或 `innodb_data_file_path` 总是被 `--prepare` 忽略，因此准备备份始终适用于后台目录中的数据文件，而不是任何外部文件。 |
| `xtrabackup_checkpoints`  | The type of the backup (for example, full or incremental), its state (for  example, prepared) and the LSN range contained in it. This information  is used for incremental backups. Example of the `xtrabackup_checkpoints` after taking a full backup: `backup_type = full-backuped from lsn= 0 to_lsn = 15188961605 last_lsn = 15188961605` Example of the `xtrabackup_checkpoints` after taking an incremental backup: `backup_type = incremental from_lsn = 15188961605 to_lsn = 15189350111 last_lsn = 15189350111` 备份的类型（例如，完整备份或增量备份）、备份状态（例如，已准备备份）以及备份中包含的 LSN 范围。此信息用于增量备份。进行完整备份 `xtrabackup_checkpoints` 后的示例： `backup_type = full-backuped from lsn= 0 to_lsn = 15188961605 last_lsn = 15188961605` 进行增量备份 `xtrabackup_checkpoints` 后的示例： `backup_type = incremental from_lsn = 15188961605 to_lsn = 15189350111 last_lsn = 15189350111` |
| `xtrabackup_binlog_info`  | The binary log file used by the server and its position at the moment of the backup. A result of the following query: `SELECT server_uuid, local, replication, storage_engines FROM performance_schema.log_status;` 服务器使用的二进制日志文件及其在备份时的位置。以下查询的结果： `SELECT server_uuid, local, replication, storage_engines FROM performance_schema.log_status;` |
| `xtrabackup_binlog`       | The **xtrabackup** binary used in the process. 进程中使用的 xtrabackup 二进制文件。 |
| `xtrabackup_logfile`      | Contains data needed for running the: `--prepare`. The bigger this file is the `--prepare` process will take longer to finish. 包含运行 . `--prepare` 此文件越大， `--prepare` 该过程将需要更长的时间才能完成。 |
| `<table_name>.delta.meta` | This file is going to be created when performing the incremental backup. It  contains the per-table delta metadata: page size, size of compressed  page (if the value is 0 it means the tablespace isn’t compressed) and  space id. Example of this file: `page_size = 16384 zip_size = 0 space_id = 0` 此文件将在执行增量备份时创建。它包含每个表的增量元数据：页面大小、压缩页面的大小（如果值为 0，则表示表空间未压缩）和空间 ID。此文件的示例： `page_size = 16384 zip_size = 0 space_id = 0` |

- Information related to the replication environment (if using the`--slave-info` option):
  与复制环境相关的信息（如果使用该 `--slave-info` 选项）：

  `xtrabackup_slave_info`

  The `CHANGE MASTER` statement needed for setting up a replica.
  设置副本所需的 `CHANGE MASTER` 语句。

- Information related to the *Galera* and *Percona XtraDB Cluster* (if using the `--galera-info` option):
  与 Galera 和 Percona XtraDB 集群相关的信息（如果使用该 `--galera-info` 选项）：

  `xtrabackup_galera_info`

  Contains the values of `wsrep_local_state_uuid` and`wsrep_last_committed` status variables
  包含 `wsrep_local_state_uuid` 和 `wsrep_last_committed` 状态变量的值

# Frequently asked questions[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#frequently-asked-questions) 常见问题 ¶

## Does Percona XtraBackup 8.3 support making backups of databases in versions prior to 8.3?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#does-percona-xtrabackup-83-support-making-backups-of-databases-in-versions-prior-to-83) Percona XtraBackup 8.3 是否支持对 8.3 之前版本的数据库进行备份？¶

Percona XtraBackup 8.3 does not support making backups of databases created in versions prior to 8.3 of MySQL, Percona Server for MySQL or Percona XtraDB Cluster. 
Percona XtraBackup 8.3 不支持备份在 MySQL、Percona Server for MySQL 或 Percona XtraDB Cluster 8.3 之前的版本中创建的数据库。

## Are you aware of any web-based backup management tools (commercial or not) built around Percona XtraBackup*?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#are-you-aware-of-any-web-based-backup-management-tools-commercial-or-not-built-around-percona-xtrabackup) 您是否知道任何基于 Web 的备份管理工具（商业或非商业）围绕 Percona XtraBackup* 构建？¶

[ZRM Community](https://www.zmanda.com/zrm-community/) is a community tool that uses Percona XtraBackup for Non-Blocking Backups:
ZRM Community 是一个社区工具，它使用 Percona XtraBackup 进行非阻塞备份：

“ZRM provides support for non-blocking backups of MySQL using Percona XtraBackup. ZRM with \Percona XtraBackup provides resource utilization management by providing throttling based on the number of IO operations  per second. Percona XtraBackup based backups also allow for table level  recovery even though the backup was done at the database level (needs  the recovery database server to be Percona Server for MySQL with  XtraDB).”*
“ZRM 支持使用 Percona XtraBackup 对 MySQL 进行非阻塞备份。带有 \Percona XtraBackup 的 ZRM  通过根据每秒 IO 操作数提供限制来提供资源利用率管理。基于Percona  XtraBackup的备份还允许表级恢复，即使备份是在数据库级别完成的（需要恢复数据库服务器是Percona Server for MySQL  with XtraDB）。*

## xtrabackup binary fails with a floating point exception[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#xtrabackup-binary-fails-with-a-floating-point-exception) xtrabackup 二进制文件失败并出现浮点异常 ¶

In most of the cases this is due to not having installed the required libraries (and version) by xtrabackup. Installing the GCC suite with the supporting libraries and recompiling xtrabackup solves the issue. See [Compiling and Installing from Source Code](https://docs.percona.com/percona-xtrabackup/innovation-release/compile-xtrabackup.html) for instructions on the procedure.
在大多数情况下，这是由于 xtrabackup 没有安装所需的库（和版本）。安装带有支持库的 GCC 套件并重新编译 xtrabackup 可以解决此问题。有关该过程的说明，请参阅从源代码编译和安装。

## How xtrabackup handles the ibdata/ib_log files on restore if they aren’t in mysql datadir?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#how-xtrabackup-handles-the-ibdataib_log-files-on-restore-if-they-arent-in-mysql-datadir) 如果 ibdata/ib_log 文件不在 mysql datadir 中，xtrabackup 如何处理还原时的文件？¶

In case the `ibdata` and `ib_log` files are located in different directories outside the datadir, you will have to put them in their proper place after the logs have been applied.
如果 `ibdata` 和 `ib_log` 文件位于 datadir 之外的不同目录中，则必须在应用日志后将它们放在适当的位置。

## Backup fails with Error 24: ‘Too many open files’[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#backup-fails-with-error-24-too-many-open-files) 备份失败，出现错误 24：“打开的文件太多” ¶

This usually happens when database being backed up contains large amount of files and Percona XtraBackup can’t open all of them to create a successful backup. In order to avoid this error the operating system should be configured appropriately so that Percona XtraBackup can open all its files. On Linux, this can be done with the `ulimit` command for specific backup session or by editing the `/etc/security/limits.conf` to change it globally (NOTE: the maximum possible value that can be set up is `1048576` which is a hard-coded constant in the Linux kernel).
当正在备份的数据库包含大量文件并且Percona XtraBackup无法打开所有文件以创建成功的备份时，通常会发生这种情况。为了避免此错误，应适当配置操作系统，以便Percona  XtraBackup可以打开其所有文件。在 Linux 上，这可以通过特定备份会话 `ulimit` 的命令或通过编辑 `/etc/security/limits.conf` 全局更改它来完成（注意：可以设置的最大可能值是 `1048576` Linux 内核中的硬编码常量）。

## How to deal with skipping of redo logs for DDL operations?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/faq.html#how-to-deal-with-skipping-of-redo-logs-for-ddl-operations) 如何处理DDL操作的重做日志跳过？¶

To prevent creating corrupted backups when running DDL operations, Percona XtraBackup aborts if it detects that redo logging is disabled. In this case, the following error is printed:
为了防止在运行DDL操作时创建损坏的备份，如果Percona XtraBackup检测到重做日志记录被禁用，则会中止。在这种情况下，将打印以下错误：

```
[FATAL] InnoDB: An optimized (without redo logging) DDL operation has been performed. All modified pages may not have been flushed to the disk yet.
Percona XtraBackup will not be able to take a consistent backup. Retry the backup operation.
```

Note 注意

- Redo logging is disabled during a [sorted index build](https://dev.mysql.com/doc/refman/8.3/en/sorted-index-builds.html). To avoid this error, Percona XtraBackup can use metadata locks on tables while they are copied:
  在排序索引生成期间禁用重做日志记录。为避免此错误，Percona XtraBackup 可以在复制表时对表使用元数据锁：
- To block all DDL operations, use the `--lock-ddl` option that issues `LOCK TABLES FOR BACKUP`.
  要阻止所有 DDL 操作，请使用 `--lock-ddl` 发出 `LOCK TABLES FOR BACKUP` .

# Glossary[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#glossary) 术语表 ¶

## .CSM[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#csm)

Each table with the CSV Storage Engine has `.CSM` file which contains the metadata of it.
每个具有 CSV 存储引擎的表都有 `.CSM` 包含其元数据的文件。

## .CSV[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#csv)

Each table with the CSV Storage engine has `.CSV` file which contains the data of it (which is a standard Comma Separated Value file).
每个具有 CSV 存储引擎的表都有 `.CSV` 包含其数据的文件（这是一个标准的逗号分隔值文件）。

## .exp[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#exp) .exp 文件 ¶

Files with the `.exp` extension are created by Percona XtraBackup per each InnoDB tablespace when the [`--export`](https://docs.percona.com/percona-xtrabackup/innovation-release/xtrabackup-option-reference.html#–-export) option is used on prepare. See [restore individual tables](https://docs.percona.com/percona-xtrabackup/innovation-release/restore-individual-tables.html).
当在准备中使用该 `--export` 选项时，Percona XtraBackup 会根据每个 InnoDB 表空间创建扩展 `.exp` 名的文件。请参阅还原单个表。

## .frm[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#frm) .frm 文件 ¶

For each table, the server will create a file with the `.frm` extension containing the table definition (for all storage engines).
对于每个表，服务器将创建一个 `.frm` 扩展名包含表定义的文件（适用于所有存储引擎）。

## General availability (GA)[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#general-availability-ga) 正式发布 （GA） ¶

A finalized version of the product which is made available to the general public. It is the final stage in the software release cycle.
向公众提供的产品的最终版本。这是软件发布周期的最后阶段。

## .ibd[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#ibd)

On a multiple tablespace setup ([innodb_file_per_table] enabled), MySQL will store each newly created table on a file with a `.ibd` extension.
在多表空间设置（启用 [innodb_file_per_table]）时，MySQL 会将每个新创建的表存储在带有 `.ibd` 扩展名的文件中。

## .MRG[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#mrg) .磁共振 ¶

Each table using the MERGE storage engine, besides of a `.frm` file,  will have `.MRG` file containing the names of the MyISAM tables  associated with it.
使用 MERGE 存储引擎的每个表，除了 `.frm` 文件之外，还将具有 `.MRG` 包含与其关联的 MyISAM 表名称的文件。

## .MYD[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#myd)

Each MyISAM table has `.MYD` (MYData) file which contains the data on it.
每个MyISAM表都有 `.MYD` 包含其数据的（MYData）文件。

## .MYI[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#myi)

Each MyISAM table has `.MYI` (MYIndex) file which contains the table’s indexes.
每个 MyISAM 表都有 `.MYI` （MYIndex） 文件，其中包含表的索引。

## .opt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#opt)

MySQL stores options of a database (like charset) in a file with a `.opt` extension in the database directory.
MySQL将数据库的选项（如charset）存储在数据库目录中具有 `.opt` 扩展名的文件中。

## .par[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#par)

Each partitioned table has `.par` file which contains metadata about the partitions.
每个分区表都有 `.par` 包含有关分区的元数据的文件。

## .TRG[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#trg)

The file contains the triggers associated with a table, for example, `\mytable.TRG`. With the `.TRN` file, they represent all the trigger definitions.
该文件包含与表关联的触发器，例如 `\mytable.TRG` .对于该 `.TRN` 文件，它们表示所有触发器定义。

## .TRN[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#trn) . TRN ¶

The file contains the names of triggers that are associated with a table, for example, `\mytable.TRN`. With the `.TRG` file, they represent all the trigger definitions.
该文件包含与表关联的触发器的名称，例如 `\mytable.TRN` 。对于该 `.TRG` 文件，它们表示所有触发器定义。

## backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#backup) 备份 ¶

The process of copying data or tables to be stored in a different location.
复制要存储在其他位置的数据或表的过程。

## compression[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#compression) 压缩 ¶

The method that produces backups in a reduced size.
以减小大小生成备份的方法。

## configuration file[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#configuration-file) 配置文件 ¶

The file that contains the server startup options.
包含服务器启动选项的文件。

## crash[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#crash) 崩溃 ¶

An unexpected shutdown which does not allow the normal server shutdown cleanup activities.
不允许正常服务器关闭清理活动的意外关闭。

## crash recovery[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#crash-recovery) 崩溃恢复 ¶

The actions that occur when MySQL is restarted after a crash.
崩溃后重新启动MySQL时发生的操作。

## data dictionary[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#data-dictionary) 数据字典 ¶

The metadata for the tables, indexes, and table columns stored in the InnoDB system tablespace.
存储在 InnoDB 系统表空间中的表、索引和表列的元数据。

## datadir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#datadir)

The directory in which the database server stores its data files. Most Linux distribution use `/var/lib/mysql` by default.
数据库服务器存储其数据文件的目录。默认情况下，大多数 Linux 发行版都使用 `/var/lib/mysql` 。

## full backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#full-backup) 完整备份 ¶

A backup that contains the complete source data from an instance.
包含实例中完整源数据的备份。

## ibdata[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#ibdata)

The default prefix for tablespace files. For example, `ibdata1` is a 10MB auto-extensible file that MySQL creates for a shared tablespace by default.
表空间文件的缺省前缀。例如， `ibdata1` 是 MySQL 默认为共享表空间创建的 10MB 自动扩展文件。

## incremental backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#incremental-backup) 增量备份 ¶

A backup stores data from a specific point in time.
备份存储来自特定时间点的数据。

## InnoDB[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb)

Storage engine which provides ACID-compliant transactions and foreign  key support, among others improvements over MyISAM. It is the default  engine for MySQL 8.3.
存储引擎，提供符合 ACID 的事务和外键支持，以及对 MyISAM 的改进。它是 MySQL 8.3 的默认引擎。

## innodb_buffer_pool_size[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb_buffer_pool_size)

The size in bytes of the memory buffer to cache data and indexes of  InnoDB’s tables. This aims to reduce disk access to provide better  performance. 
用于缓存 InnoDB 表的数据和索引的内存缓冲区的大小（以字节为单位）。这旨在减少磁盘访问以提供更好的性能。

> [mysqld] [mysqld的]
>  innodb_buffer_pool_size=8MB

## innodb_data_home_dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb_data_home_dir)

The directory (relative to `datadir`) where the database server stores  the files in a shared tablespace setup. This option does not affect the location of `innodb\_file\_per\_table`. For example:
数据库服务器在共享表空间设置中存储文件的目录（相对于 `datadir` ）。此选项不会影响 的位置 `innodb\_file\_per\_table` 。例如：

> [mysqld] [mysqld的]
>  innodb_data_home_dir = ./

## innodb_data_file_path[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb_data_file_path)

Specifies the names, sizes and location of shared tablespace files:
指定共享表空间文件的名称、大小和位置：

> [mysqld] [mysqld的]
>  innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend
> innodb_data_file_path=ibdata1：50M;ibdata2：50M：自动扩展

## innodb_file_per_table[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb_file_per_table)

By default, InnoDB creates tables and indexes in a [file-per-tablespace](https://dev.mysql.com/doc/refman/8.3/en/innodb-file-per-table-tablespaces.html). If the `innodb_file_per_table` variable is disabled, you can enable the variable in your configuration file:
默认情况下，InnoDB 在每个表空间的文件中创建表和索引。如果 `innodb_file_per_table` 该变量被禁用，则可以在配置文件中启用该变量：

> [mysqld] [mysqld的]
>  innodb_file_per_table 
>  or 
>  start the server with `--innodb_file_per_table`.
> 使用 `--innodb_file_per_table` 启动服务器。

## innodb_log_group_home_dir[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#innodb_log_group_home_dir)

Specifies the location of the InnoDB log files:
指定 InnoDB 日志文件的位置：

> [mysqld] [mysqld的]
>  innodb_log_group_home=/var/lib/mysql

## logical backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#logical-backup) 逻辑备份 ¶

A backup which contains a set of SQL statements. The statements can be used to recreate the databases.
包含一组 SQL 语句的备份。这些语句可用于重新创建数据库。

## LSN[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#lsn)

Each InnoDB page contains a log sequence number(LSN). The LSN is the system  version number for the database. Each page’s LSN shows how recently it  was changed.
每个 InnoDB 页面都包含一个日志序列号 （LSN）。LSN 是数据库的系统版本号。每个页面的 LSN 显示它最近更改的时间。

## my.cnf[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#mycnf)

The database server’s main configuration file. Most Linux distributions place it as `/etc/mysql/my.cnf` or `/etc/my.cnf`, but the location and name depends on the particular installation. Note  that this method is not the only way of configuring the server, some  systems rely on the command options.
数据库服务器的主配置文件。大多数 Linux 发行版将其定位为 `/etc/mysql/my.cnf` 或 `/etc/my.cnf` ，但位置和名称取决于特定的安装。请注意，此方法不是配置服务器的唯一方法，某些系统依赖于命令选项。

## MyISAM[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#myisam) 我的ISAM ¶

The MySQL default storage engine until version 5.5. It doesn’t fully  support transactions but in some scenarios may be faster than InnoDB.  Each table is stored on disk in 3 files: `.frm`, `.MYD`, `.MYI`.
MySQL 默认存储引擎，直到 5.5 版。它不完全支持事务，但在某些情况下可能比 InnoDB 更快。每个表以 3 个文件的形式存储在磁盘上： `.frm` 、 `.MYD` 、 `.MYI` 。

## physical backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#physical-backup) 物理备份 ¶

A backup that copies the data files.
复制数据文件的备份。

## point in time recovery[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#point-in-time-recovery) 时间点恢复 ¶

This method restores the data into the state it was at any selected point of time.
此方法将数据还原到任何选定时间点的状态。

## prepared backup[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#prepared-backup) 准备好的备份 ¶

A consistent set of backup data that is ready to be restored.
一组一致的备份数据，可随时还原。

## restore[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#restore) 恢复 ¶

Copies the database backups taken using the backup command to the original  location or a different location. A restore returns data that has been  either lost, corrupted, or stolen to the original condition at a  specific point in time.
将使用 backup 命令创建的数据库备份复制到原始位置或其他位置。还原将丢失、损坏或被盗的数据返回到特定时间点的原始状态。

## Tech preview[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#tech-preview) 技术预览 ¶

A tech preview item can be a feature, a variable, or a value within a  variable. Before using this feature in production, we recommend that you test restoring production from physical backups in your environment and also use an alternative backup method for redundancy. A tech preview  item is included in a release for users to provide feedback. The item is either updated and released as [general availability(GA)](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#general-availability-ga) or removed if not useful. The functionality can change from tech preview to GA.
技术预览项目可以是功能、变量或变量中的值。在生产中使用此功能之前，建议测试从环境中的物理备份还原生产环境，并使用替代备份方法来实现冗余。技术预览项目包含在发布中，供用户提供反馈。该项目将更新并作为正式发布 （GA） 发布，如果无用，则将其删除。该功能可以从技术预览版更改为 GA。

## xbcrypt[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#xbcrypt)

To support the encryption and the decryption of the backups. This utility  has been modeled after the xbstream binary to perform encryption and  decryption outside Percona XtraBackup.
支持备份的加密和解密。此实用程序以 xbstream 二进制文件为模型，用于在 Percona XtraBackup 外部执行加密和解密。

## xbstream[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#xbstream)

To support simultaneous compression and streaming, Percona XtraBackup uses the xbstream format. For more information see [xbstream](https://docs.percona.com/percona-xtrabackup/innovation-release/xbstream-binary-overview.html)
为了支持同时压缩和流式传输，Percona XtraBackup使用xbstream格式。有关详细信息，请参阅 xbstream

## XtraDB[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#xtradb)

Percona XtraDB is an enhanced version of the InnoDB storage engine, designed to better scale on modern hardware. Percona XtraDB includes features which are useful in a high performance environment. It is fully  backward-compatible, and is a drop-in replacement for the standard  InnoDB storage engine. For more information, see [The Percona XtraDB Storage Engine](https://www.percona.com/doc/percona-server/innovation-release/percona-xtradb.html).
Percona XtraDB 是 InnoDB 存储引擎的增强版本，旨在更好地在现代硬件上扩展。Percona XtraDB  包含在高性能环境中有用的功能。它完全向后兼容，是标准InnoDB存储引擎的直接替代品。有关更多信息，请参阅 Percona XtraDB  存储引擎。

## Zstandard (ZSTD)[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/glossary.html#zstandard-zstd) Zstandard （ZSTD） ¶

`ZSTD` is a fast lossless compression algorithm that targets real-time compression scenarios and better compression ratios.
 `ZSTD` 是一种快速无损压缩算法，针对实时压缩场景和更好的压缩比。

# Percona Toolkit version checking[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#percona-toolkit-version-checking) Percona Toolkit 版本检查 ¶

Some Percona software contains “version checking” functionality which is a feature that enables Percona software users to be notified of available software updates to improve your environment security and performance. Alongside this, the version check functionality also provides Percona with information relating to which software versions you are running, coupled with the environment confirmation which the software is running within. This helps enable Percona to focus our development effort accordingly based on trends within our customer community.
某些 Percona 软件包含“版本检查”功能，该功能使 Percona  软件用户能够收到可用软件更新的通知，以提高您的环境安全性和性能。除此之外，版本检查功能还为 Percona  提供了与您正在运行的软件版本相关的信息，以及软件运行的环境确认。这有助于 Percona 根据客户社区的趋势相应地集中我们的开发工作。

The purpose of this document is to articulate the information that is collected, as well as to provide guidance on how to disable this functionality if desired.
本文档的目的是阐明所收集的信息，并提供有关如何根据需要禁用此功能的指导。

## Usage[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#usage) 用法 ¶

*Version Check* was implemented in *Percona Toolkit* 2.1.4, and was enabled by default in version 2.2.1. Currently, it is supported as a `--[no]version-check` option by a number of tools in Percona Toolkit, *Percona XtraBackup*, and *Percona Monitoring and Management* (PMM).
版本检查在 Percona Toolkit 2.1.4 中实现，并在版本 2.2.1 中默认启用。目前，Percona Toolkit、Percona  XtraBackup 和 Percona Monitoring and Management （PMM） 中的许多工具都支持它作为 `--[no]version-check` 选项。

When launched with Version Check enabled, the tool that supports this feature connects to a Percona’s *version check service* via a secure HTTPS channel. It compares the locally installed version for possible updates, and also checks versions of the following software:
在启用版本检查的情况下启动时，支持此功能的工具通过安全的 HTTPS 通道连接到 Percona 的版本检查服务。它会比较本地安装的版本是否有可能的更新，并检查以下软件的版本：

- Operating System 操作系统
- Percona Monitoring and Management (PMM)
  Percona 监控和管理 （PMM）
- MySQL MySQL的
- Perl Perl的
- MySQL driver for Perl (DBD::mysql)
  适用于 Perl 的 MySQL 驱动程序 （DBD：：mysql）
- Percona Toolkit Percona 工具包

Then it checks for and warns about versions with known problems if they are identified as running in the environment.
然后，如果发现具有已知问题的版本，则会检查并警告这些版本在环境中运行。

Each version check request is logged by the server. Stored information consists of the checked system unique ID followed by the software name and version.  The ID is generated either at installation or when the *version checking* query is submitted for the first time.
每个版本检查请求都由服务器记录。存储的信息由检查的系统唯一 ID 后跟软件名称和版本组成。该 ID 在安装时或首次提交版本检查查询时生成。

Note 注意

Prior to version 3.0.7 of *Percona Toolkit*, the system ID was calculated as an MD5 hash of a hostname, and starting from *Percona Toolkit* 3.0.7 it is generated as an MD5 hash of a random number. *Percona XtraBackup* continues to use hostname-based MD5 hash.
在 Percona Toolkit 3.0.7 版本之前，系统 ID 计算为主机名的 MD5 哈希，从 Percona Toolkit 3.0.7 开始，它以随机数的 MD5 哈希生成。Percona XtraBackup 继续使用基于主机名的 MD5 哈希。

As a result, the content of the sent query is as follows:
因此，发送的查询内容如下：

<details class="example" data-immersive-translate-walked="d19b9616-5fdf-4d76-8a5b-f0aaeab73ef9" open="">
<summary data-immersive-translate-walked="d19b9616-5fdf-4d76-8a5b-f0aaeab73ef9" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary>
<div class="no-copy highlight" data-immersive-translate-walked="d19b9616-5fdf-4d76-8a5b-f0aaeab73ef9"><pre><span></span><code>85624f3fb5d2af8816178ea1493ed41a;DBD::mysql;4.044
c2b6d625ef3409164cbf8af4985c48d3;MySQL;MySQL Community Server (GPL) 5.7.22-log
85624f3fb5d2af8816178ea1493ed41a;OS;Manjaro Linux
85624f3fb5d2af8816178ea1493ed41a;Percona::Toolkit;3.0.11-dev
85624f3fb5d2af8816178ea1493ed41a;Perl;5.26.2
</code></pre></div>
</details>

## Disabling version check[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#disabling-version-check) 禁用版本检查 ¶

Although the *version checking* feature does not collect any personal information, you might prefer to disable this feature, either one time or permanently.  To disable it one time, use `--no-version-check` option when invoking the tool from a Percona product which supports it. Here is a simple example which shows running [pt-diskstats](https://www.percona.com/doc/percona-toolkit/LATEST/pt-diskstats.html) tool from the *Percona Toolkit* with *version checking* turned off:
尽管版本检查功能不会收集任何个人信息，但您可能希望一次性或永久禁用此功能。要禁用它一次，请在从支持该工具的 Percona 产品调用该工具时使用 `--no-version-check` 该选项。下面是一个简单的示例，它显示了在关闭版本检查的情况下从 Percona Toolkit 运行 pt-diskstats 工具：

```
pt-diskstats --no-version-check
```

Disabling *version checking* permanently can be done by placing `no-version-check` option into the configuration file of a Percona product (see correspondent documentation for exact file name and syntax). For example, in case of *Percona Toolkit* [this can be done](https://www.percona.com/doc/percona-toolkit/LATEST/configuration_files.html) in a global configuration file `/etc/percona-toolkit/percona-toolkit.conf`:
通过将选项放入 `no-version-check` Percona 产品的配置文件中，可以永久禁用版本检查（有关确切的文件名和语法，请参阅相应的文档）。例如，在 Percona Toolkit 的情况下，这可以在全局配置文件中完成 `/etc/percona-toolkit/percona-toolkit.conf` ：

```
# Disable Version Check for all tools:
no-version-check
```

In case of *Percona XtraBackup* this can be done [in its configuration file](https://docs.percona.com/percona-xtrabackup/innovation-release/configure-xtrabackup.html) in a similar way:
对于Percona XtraBackup，可以在其配置文件中以类似的方式完成：

```
[xtrabackup]
no-version-check
```

## FAQ

### Why is this functionality enabled by default?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#why-is-this-functionality-enabled-by-default) 为什么默认启用此功能？¶

We believe having this functionality enabled improves security and performance of environments running Percona Software and it is good choice for majority of the users.
我们相信启用此功能可以提高运行 Percona 软件的环境的安全性和性能，它是大多数用户的不错选择。

### Why not rely on Operating System’s built in functionality for software updates?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#why-not-rely-on-operating-systems-built-in-functionality-for-software-updates) 为什么不依靠操作系统的内置功能进行软件更新呢？¶

In many environments the Operating Systems repositories may not carry the latest version of software and newer versions of software often installed manually, so not being covered by operating system wide check for updates.
在许多环境中，操作系统存储库可能不包含最新版本的软件，而更新版本的软件通常是手动安装的，因此操作系统范围的更新检查不包括在内。

### Why do you send more information than just the version of software being run as a part of version check service?[¶](https://docs.percona.com/percona-xtrabackup/innovation-release/toolkit-version-check.html#why-do-you-send-more-information-than-just-the-version-of-software-being-run-as-a-part-of-version-check-service) 为什么您发送的信息不仅仅是作为版本检查服务的一部分运行的软件版本？¶

Compatibility problems can be caused by versions of various components in the environment, for example problematic versions of Perl, DBD or MySQL could cause operational problems with Percona Toolkit.
兼容性问题可能是由环境中各种组件的版本引起的，例如，有问题的 Perl、DBD 或 MySQL 版本可能会导致 Percona Toolkit 出现操作问题。