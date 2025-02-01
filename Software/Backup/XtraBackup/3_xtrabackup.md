# xtrabackup

xtrabackup 二进制文件是一个编译的 C 程序，它与 *InnoDB* 库和标准 *MySQL* 客户端库链接。

xtrabackup 支持 *InnoDB* / *XtraDB* 表以及架构定义、*MyISAM* 表和服务器其他部分的时间点备份。

*InnoDB* 库提供了将日志应用于数据文件的功能。*MySQL* 客户端库用于解析命令行选项和配置文件。

该工具在 `--backup` 或 `--prepare` 模式下运行，对应于它执行的两个主要功能。这些函数有几种变体来完成不同的任务，还有一种不太常用的模式，即 ` --print-param`。

## xtrabackup 实现细节

### 文件权限

*xtrabackup* opens the source data files in read-write mode, although it does not modify the files. This means that you must run *xtrabackup* as a user who has permission to write the data files. The reason for opening the files in read-write mode is that *xtrabackup* uses the embedded *InnoDB* libraries to open and read the files, and *InnoDB* opens them in read-write mode because it normally assumes it is going to write to them.
*xtrabackup* 以读写模式打开源数据文件，尽管它不会修改文件。这意味着您必须以具有写入数据文件权限的用户身份运行 *xtrabackup*。以读写模式打开文件的原因是 *xtrabackup* 使用嵌入式 *InnoDB* 库来打开和读取文件，而 *InnoDB* 以读写模式打开它们，因为它通常假设它将要写入这些文件。

### 调整 OS 缓冲区

Because *xtrabackup* reads large amounts of data from the filesystem, it uses `posix_fadvise()` where possible, to instruct the operating system not to try to cache the blocks it reads from disk. Without this hint, the operating system would prefer to cache the blocks, assuming that `xtrabackup` is likely to need them again, which is not the case. Caching such large files can place pressure on the operating system’s virtual memory and cause other processes, such as the database server, to be swapped out. The `xtrabackup` tool avoids this with the following hint on both the source and destination files:
因为 *xtrabackup* 从文件系统中读取大量数据，所以它会尽可能使用 `posix_fadvise（）` 来指示操作系统不要尝试缓存它从磁盘读取的块。如果没有这个提示，操作系统更愿意缓存这些块，假设 `xtrabackup` 可能会再次需要它们，但事实并非如此。缓存此类大文件可能会给操作系统的虚拟内存带来压力，并导致其他进程（如数据库服务器）被换出。`xtrabackup` 工具通过在源文件和目标文件上提供以下提示来避免这种情况：

```
posix_fadvise(file, 0, 0, POSIX_FADV_DONTNEED)
```

In addition, xtrabackup asks the operating system to perform more aggressive read-ahead optimizations on the source files:
此外，xtrabackup 要求操作系统对源文件执行更积极的预读优化：

```
posix_fadvise(file, 0, 0, POSIX_FADV_SEQUENTIAL)
```

### 复制数据文件

When copying the data files to the target directory, *xtrabackup* reads and writes 1 MB of data at a time. This is not configurable. When copying the log file, *xtrabackup* reads and writes 512 bytes at a time. This is also not possible to configure, and matches InnoDB’s behavior (workaround exists in *Percona Server for MySQL* because it has an option to tune `innodb_log_block_size` for *XtraDB*, and in that case *Percona XtraBackup* will match the tuning).
将数据文件复制到目标目录时，*xtrabackup* 一次读取和写入 1 MB 的数据。这是不可配置的。复制日志文件时，*xtrabackup* 一次读取和写入 512 字节。这也无法配置，并且与 InnoDB 的行为相匹配（*Percona Server for MySQL* 中存在解决方法，因为它可以选择为 *XtraDB* 调整`innodb_log_block_size`，在这种情况下，*Percona XtraBackup* 将匹配调整）。

After reading from the files, `xtrabackup` iterates over the 1MB buffer a page at a time, and checks for page corruption on each page with InnoDB’s `buf_page_is_corrupted()` function. If the page is corrupt, it re-reads and retries up to 10 times for each page. It skips this check on the doublewrite buffer.
从文件中读取后，`xtrabackup` 一次迭代一页 1MB 的缓冲区，并使用 InnoDB 的 `buf_page_is_corrupted（）` 函数检查每个页面上的页面是否损坏。如果页面已损坏，它会重新读取每个页面并重试最多 10 次。它会跳过对 doublewrite buffer 的此检查。

## 命令行选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#the-xtrabackup-command-line-options)

Here you can find all of the command-line options for the xtrabackup binary.
在这里，您可以找到 xtrabackup 二进制文件的所有命令行选项。

### Modes of operation[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#modes-of-operation) 操作模式[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#modes-of-operation)

You invoke xtrabackup in one of the following modes:
您可以在以下模式之一中调用 xtrabackup：

- `--backup` mode to make a backup in a target directory
  `--backup` 模式在目标目录中进行备份
- `--prepare` mode to restore data from a backup (created in `--backup` mode)
  `--prepare` 模式从备份中恢复数据（在 `--backup` 模式下创建）
- `--copy-back` to copy data from a backup to the original location; to move the data instead of copying the data, use the alternate `--move-back` mode.
  `--copy-back` 将数据从备份复制到原始位置;要移动数据而不是复制数据，请使用备用 `--move-back` 模式。

When you intend to run xtrabackup in any of these modes, use the following syntax:
当您打算以任何这些模式运行 xtrabackup 时，请使用以下语法：

```
$ xtrabackup [--defaults-file=#] --backup|--prepare|--copy-back| [OPTIONS]
```

For example, the `--prepare` mode is applied as follows:
例如，`--prepare` 模式的应用方式如下：

```
$ xtrabackup --prepare --target-dir=/data/backup/mysql/
```

For all modes, the default options are read from the xtrabackup and mysqld configuration groups from the following files in the given order:
对于所有模式，默认选项按给定顺序从以下文件中的 xtrabackup 和 mysqld 配置组中读取：

1. `/etc/my.cnf`
2. `/etc/mysql/my.cnf`
3. `/usr/etc/my.cnf`
4. `~/.my.cnf`. `~/.my.cnf` 的

As the first parameter to xtrabackup in place of the `--defaults-file`, you may supply one of the following:
作为 xtrabackup 的第一个参数来代替 `--defaults-file`，你可以提供以下之一：

- `--print-defaults` - prints the argument list and exit.
  `--print-defaults` - 打印参数列表并退出。
- `--no-defaults` - forbids reading options from any file but the login file.
  `--no-defaults` - 禁止从除登录文件之外的任何文件中读取选项。
- `--defaults-file` -  reads the default options from the given file.
  `--defaults-file` - 从给定文件中读取默认选项。
- `--defaults-extra-file` - reads the specified additional file after the global files.
  `--defaults-extra-file` - 在全局文件之后读取指定的附加文件。
- `--defaults-group-suffix` -  reads the configuration groups with the given suffix. The effective  group name is constructed by concatenating the default configuration  groups (xtrabackup and mysqld) with the given suffix.
  `--defaults-group-suffix` - 读取具有给定后缀的配置组。有效的组名称是通过将默认配置组（xtrabackup 和 mysqld）与给定的后缀连接起来来构建的。
- `--login-path` - reads the given path from the login file.
  `--login-path` - 从登录文件中读取给定的路径。

#### InnoDB options[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-options) InnoDB 选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-options)

A large group of InnoDB options is usually read from the `my.cnf` configuration file, so xtrabackup boots up its embedded InnoDB in the  same configuration as your current server. You typically do not need to specify them explicitly. These options have the same behavior in InnoDB and XtraDB. See [`--innodb-miscellaneous`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-miscellaneous) for more information.
通常从 `my.cnf` 配置文件中读取一大组 InnoDB 选项，因此 xtrabackup 会以与当前服务器相同的配置启动其嵌入的 InnoDB。您通常不需要显式指定它们。这些选项在 InnoDB 和 XtraDB 中具有相同的行为。有关更多信息，请参阅 [`--innodb-miscellaneous`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-miscellaneous) 。

### Options[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#options) 选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#options)

#### apply-log-only[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#apply-log-only) 仅应用日志[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#apply-log-only)

Usage: `--apply-log-only`
用法：`--apply-log-only`

This option causes only the redo stage to be performed when preparing a backup. It is essential for incremental backups.
此选项会导致在准备备份时仅执行重做阶段。它对于增量备份至关重要。

#### backup[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup) 备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup)

Usage: `--backup` 用法：`--backup`

Make a backup and place it in `--target-dir`. See [Create a full backup](https://docs.percona.com/percona-xtrabackup/8.4/create-full-backup.html)
进行备份并将其放在 `--target-dir` 中。请参阅[创建完整备份](https://docs.percona.com/percona-xtrabackup/8.4/create-full-backup.html)

#### backup-lock-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-lock-timeout) 备份锁定超时[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-lock-timeout)

Usage: `--backup-lock-timeout`
用法：`--backup-lock-timeout`

The timeout in seconds for attempts to acquire metadata locks.
尝试获取元数据锁的超时（以秒为单位）。

#### backup-lock-retry-count[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-lock-retry-count) 备份锁重试计数[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-lock-retry-count)

Usage: `--backup-lock-retry-count`
用法：`--backup-lock-retry-count`

The number of attempts to acquire metadata locks.
尝试获取元数据锁的次数。

#### backup-locks[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-locks) 备份锁[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-locks)

Usage: `--backup-locks`
用法： `--backup-locks`

This option controls if [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) are used instead of `FLUSH TABLES WITH READ LOCK` on the backup stage. The option has no effect when the server does not support backup locks. This option is enabled by default, disable with [`--no-backup-locks`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-backup-locks).
此选项控制是否在备份阶段使用 [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) 而不是 `FLUSH TABLES WITH READ LOCK`。当服务器不支持备份锁定时，该选项无效。此选项默认启用，使用 [`--no-backup-locks`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-backup-locks) 禁用。

#### check-privileges[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#check-privileges)

Usage: `check-privileges`
用法：`check-privileges`

This option checks if Percona XtraBackup has all the required privileges. If a required privilege is missing for the current operation, the operation terminates and prints an error message. If a privilege is not needed for the current operation but is missing  and may be necessary for another XtraBackup operation, the operation is  not aborted, and a warning is printed.
此选项检查 Percona XtraBackup 是否具有所有必需的权限。如果当前操作缺少所需的权限，则操作将终止并打印错误消息。如果当前操作不需要某个权限，但缺少该权限，并且另一个 XtraBackup 操作可能需要该权限，则不会中止该操作，并打印警告。

<details class="example" data-immersive-translate-walked="7cbc67fd-dc20-443c-9445-5dd25fc11c8e"><summary data-immersive-translate-walked="7cbc67fd-dc20-443c-9445-5dd25fc11c8e" data-immersive-translate-paragraph="1">Example output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">示例输出</font></font></font></summary><div class="highlight" data-immersive-translate-walked="7cbc67fd-dc20-443c-9445-5dd25fc11c8e"><pre id="__code_2"><span></span></pre></div></details>

<details class="example" data-immersive-translate-walked="7cbc67fd-dc20-443c-9445-5dd25fc11c8e"><div class="highlight" data-immersive-translate-walked="7cbc67fd-dc20-443c-9445-5dd25fc11c8e"><pre id="__code_2"><code></code></pre></div></details>

#### close-files[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#close-files) 关闭文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#close-files)

Usage: `--close-files`
用法： `--close-files`

Do not keep files opened. When xtrabackup opens a tablespace, xtrabackup normally doesn’t close its file handle. This operation allows xtrabackup to handle the DDL operations correctly. However, if the number of tablespaces is huge and can not fit into any limit, there is an option to close file handles once they are no longer accessed. Percona XtraBackup can produce inconsistent backups with this option enabled. Use at your own risk.
不要让文件保持打开状态。当 xtrabackup 打开一个表空间时，xtrabackup 通常不会关闭其文件句柄。此操作允许 xtrabackup 正确处理 DDL  操作。但是，如果表空间的数量很大并且无法满足任何限制，则可以选择在不再访问文件句柄时关闭它们。启用此选项后，Percona XtraBackup 可能会产生不一致的备份。使用风险自负。

#### compress[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress) 压缩[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress)

Usage: `--compress`
用法： `--compress`

This option tells xtrabackup to compress all output data, including the transaction log and metadata files, using either the `ZSTD` or the `lz4` compression algorithm. `ZSTD` is the default compression algorithm.
此选项指示 xtrabackup 使用 `ZSTD` 或 `lz4` 压缩算法压缩所有输出数据，包括事务日志和元数据文件。`ZSTD` 是默认的压缩算法。

`--compress` produces `\*.zst` files. You can extract the contents of these files using the `--decompress` option. You can specify the `ZSTD` compression level with the [`--compress-zstd-level`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level) option.
`--compress` 会生成 `\*.zst` 文件。您可以使用 `--decompress` 选项提取这些文件的内容。您可以使用 [`--compress-zstd-level`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level) 选项指定 `ZSTD` 压缩级别。

`--compress=lz4` produces `\*.lz4` files. You can extract the contents of these files by using the `lz4` program.
`--compress=lz4` 生成 `\*.lz4` 文件。您可以使用 `lz4` 程序提取这些文件的内容。

#### compress-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-chunk-size) 压缩块大小[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-chunk-size)

Usage: `--compress-chunk-size=#`
用法： `--compress-chunk-size=#`

Size of working buffer(s) for compression threads in bytes. The default value is 64K.
压缩线程的工作缓冲区大小（以字节为单位）。默认值为 64K。

#### compress-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-threads) 压缩线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-threads)

Usage: `--compress-threads=#`
用法：`--compress-threads=#`

This option specifies the number of worker threads xtrabackup uses for parallel data compression. This option defaults to `1` and can be used with [parallel](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel) file copying.
此选项指定 xtrabackup 用于并行数据压缩的工作线程数。此选项默认为 `1`，可与[并行](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel)文件复制一起使用。

For example, `--parallel=4 --compress --compress-threads=2` creates four I/O threads that read and pipe the data to two compression threads.
例如， `--parallel=4 --compress --compress-threads=2` 创建四个 I/O 线程，用于读取数据并通过管道将数据传输到两个压缩线程。

#### compress-zstd-level[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level) compress-zstd-level [级别¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level)

Usage: `--compress-zstd-level=#`
用法：`--compress-zstd-level=#`

This option specifies `ZSTD` compression level. Compression levels provide a trade-off between the  compression speed and the compressed files’ size. A lower compression  level provides faster compression speed but larger file sizes. A higher  compression level provides lower compression speed but smaller file  sizes. For example, set level 1 if the compression speed is the most  important for you. Set level 19 if the size of the compressed files is  the most important.
此选项指定 `ZSTD` 压缩级别。压缩级别提供压缩速度和压缩文件大小之间的权衡。较低的压缩级别提供更快的压缩速度，但文件大小较大。压缩级别越高，压缩速度越慢，但文件大小越小。例如，如果压缩速度对您来说最重要，则设置 level 1。如果压缩文件的大小最重要，则设置级别 19。

The default value is 1. Allowed range of values is from 1 to 19.
默认值为 1。允许的值范围为 1 到 19。

#### copy-back[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#copy-back) 复制回来[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#copy-back)

Usage: `--copy-back`
用法： `--copy-back`

Copy all the files in a previously made backup from the backup directory to their original locations. This option will not copy over existing files unless the [`--force-non-empty-directories`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#force-non-empty-directories) option is specified.
将先前创建的备份中的所有文件从备份目录复制到其原始位置。除非指定了 [`--force-non-empty-directories`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#force-non-empty-directories) 选项，否则此选项不会复制现有文件。

#### core-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#core-file) 核心文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#core-file)

Usage: `--core-file`
用法：`--core-file`

Write core on fatal signals.

#### databases[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases) 数据库[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases)

Usage: `--databases=#`
用法：`--databases=#`

This option specifies a list of databases and tables that should be backed up. The option accepts the list of the form `"databasename1[.table_name1] databasename2[.table_name2] . . ."`.
此选项指定应备份的数据库和表的列表。该选项接受表单 `"databasename1[.table_name1] databasename2[.table_name2] . . ."` 的列表 。

#### databases-exclude[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases-exclude) databases-exclude（数据库排除[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases-exclude)

Usage: `--databases-exclude=name`
用法：`--databases-exclude=name`

Databases are excluded based on name. This option operates the same way as `--databases` but excludes the matched names from the backup.
根据名称排除数据库。此选项的操作方式与 `--databases` 相同，但从备份中排除匹配的名称。

This option has a higher priority than `--databases`.
此选项的优先级高于 `--databases`。

#### databases-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases-file) databases 文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#databases-file)

Usage: `--databases-file=#`
用法：`--databases-file=#`

This option specifies the path to the file containing the list of databases and tables that should be backed up. The file can contain the list elements of the form `databasename1[.table_name1]`, one element per line.
此选项指定包含应备份的数据库和表列表的文件的路径。该文件可以包含格式 `databasename1[.table_name1]` 的列表元素，每行一个元素。

#### datadir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#datadir) 数据目录[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#datadir)

Usage: `--datadir=DIRECTORY`
用法：`--datadir=DIRECTORY`

The source directory for the backup. This should be the same as the datadir for your server, so it should be read from `my.cnf` if that exists; otherwise, specify the directory on the command line.
备份的源目录。这应该与服务器的 datadir 相同，因此如果存在，则应从 `my.cnf` 中读取它;否则，请在命令行上指定目录。

When combined with the [`--copy-back`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#copy-back) or the [`--move-back`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#move-back) option, this option refers to the destination directory.
当与 [`--copy-back`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#copy-back) 或 [`--move-back`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#move-back) 选项结合使用时，此选项是指目标目录。

To perform a backup, you must have the `READ` and `EXECUTE` permissions at a filesystem level in the server’s datadir.
要执行备份，您必须在服务器的 datadir 中具有文件系统级别的 `READ` 和 `EXECUTE` 权限。

#### debug-sleep-before-unlock[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#debug-sleep-before-unlock)

Usage: `--debug-sleep-before-unlock=#`
用法： `--debug-sleep-before-unlock=#`

This option is only used by the xtrabackup test suite.
此选项仅由 xtrabackup 测试套件使用。

#### debug-sync[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#debug-sync) 调试同步[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#debug-sync)

Usage: `--debug-sync=name`
用法：`--debug-sync=name`

This option is only used by the xtrabackup test suite.
此选项仅由 xtrabackup 测试套件使用。

#### decompress[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decompress) 解压[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decompress)

Usage: `--decompress`
用法： `--decompress`

Decompresses all files in a backup previously made with the `--compress` option. The `--parallel` option lets multiple files be decrypted simultaneously.
解压缩之前使用 `--compress` 选项创建的备份中的所有文件。`--parallel` 选项允许同时解密多个文件。

Percona XtraBackup does not automatically remove the compressed files. Users should use the `--remove-original` option to clean up the backup directory.
Percona XtraBackup 不会自动删除压缩文件。用户应使用 `--remove-original` 选项清理备份目录。

#### decompress-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decompress-threads) 解压线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decompress-threads)

Usage: `--decompress-threads=#`
用法：`--decompress-threads=#`

Force xbstream to use the specified number of threads for decompressing.
强制 xbstream 使用指定数量的线程进行解压缩。

#### decrypt[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decrypt) 解密[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#decrypt)

Usage: `--decrypt=ENCRYPTION-ALGORITHM` 用法： `--decrypt=ENCRYPTION-ALGORITHM` 

Decrypts all files with the `xbcrypt` extension in a backup previously made with [`--encrypt`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt) option. The [`--parallel`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel) option lets multiple files be decrypted simultaneously. Percona XtraBackup doesn’t automatically remove the encrypted files; use `--`remove-original`](#remove-original) option.
解密之前使用 [`--encrypt`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt) 选项创建的备份中所有带有 `xbcrypt` 扩展名的文件。[`--parallel`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel) 选项允许同时解密多个文件。Percona XtraBackup 不会自动删除加密文件;使用 `--`remove-original']（#remove-original） 选项。

#### defaults-extra-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-extra-file) defaults-extra-文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-extra-file)

Usage: `--defaults-extra-file=[MY.CNF]` 用法： `--defaults-extra-file=[MY.CNF]` 

Read this file after the global files are read. The option must be the first option on the command line.
读取全局文件后读取此文件。该选项必须是命令行上的第一个选项。

#### defaults-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-file) defaults-file（默认文件[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-file)

Usage: `--defaults-file=[MY.CNF]`
用法：`--defaults-file=[MY.CNF]`

Only read default options from the given file. The value must be the first option on the command line and cannot be a symbolic link.
仅从给定文件中读取默认选项。该值必须是命令行上的第一个选项，并且不能是符号链接。

#### defaults-group[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-group) defaults-group（默认组[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-group)

Usage: `--defaults-group=GROUP-NAME`
用法：`--defaults-group=GROUP-NAME`

This option sets the group that should be read from the configuration file and is needed for `mysqld_multi` deployments.
此选项设置应从配置文件中读取的组，并且是 `mysqld_multi` 部署所需的组。

#### defaults-group-suffix[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-group-suffix) defaults-group-suffix （默认组后缀[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#defaults-group-suffix)

Usage: `--defaults-group-suffix=#`
用法：`--defaults-group-suffix=#`

Also reads groups with concat(group, suffix).
还可以使用 concat（group， suffix） 读取组。

#### dump-innodb-buffer-pool[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool)

Usage: `--dump-innodb-buffer-pool`
用法：`--dump-innodb-buffer-pool`

This option controls creating a new dump of the buffer pool content.
此选项控制创建缓冲池内容的新转储。

The xtrabackup binary requests the server to start the buffer pool dump.  This operation may take time to complete and is done in the background.  The beginning of a backup with the option reports that the dump has been completed.
xtrabackup 二进制文件请求服务器启动缓冲池转储。此操作可能需要一些时间才能完成，并在后台完成。带有 option 的备份开始报告转储已完成。

```
$ xtrabackup --backup --dump-innodb-buffer-pool --target-dir=/home/user/backup
```

By default, this option is set to OFF.
默认情况下，此选项设置为 OFF。

If [`innodb_buffer_pool_dump_status`](https://dev.mysql.com/doc/refman/8.3/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status) reports that there is a running dump of the buffer pool, xtrabackup waits for the dump to complete using the value of [`--dump-innodb-buffer-pool-timeout`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool-timeout)
如果[ `innodb_buffer_pool_dump_status` ](https://dev.mysql.com/doc/refman/8.3/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status)报告缓冲池有正在运行的转储，则 xtrabackup 将使用[ `--dump-innodb-buffer-pool-timeout` ](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool-timeout)

The file `ib_buffer_pool` stores the tablespace ID and page ID data used to warm up the buffer pool sooner.
该文件`ib_buffer_pool`存储用于更快地预热缓冲池的表空间 ID 和页 ID 数据。

#### dump-innodb-buffer-pool-pct[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool-pct)

Usage: `--dump-innodb-buffer-pool-pct`
用法：`--dump-innodb-buffer-pool-pct`

This option contains the percentage of the most recently used buffer pool pages to dump.
此选项包含要转储的最近使用的缓冲池页面的百分比。

This option is effective if `--dump-innodb-buffer-pool` option is set to ON. If this option contains a value, xtrabackup sets the MySQL system variable [`innodb_buffer_pool_dump_pct`](https://dev.mysql.com/doc/refman/8.3/en/innodb-parameters.html#sysvar_innodb_buffer_pool_dump_pct). As soon as the buffer pool dump completes or is stopped (see `--dump-innodb-buffer-pool-timeout`), the value of the MySQL system variable is restored.
如果 `--dump-innodb-buffer-pool` 选项设置为 ON，则此选项有效。如果此选项包含值，则 xtrabackup 会将 MySQL 系统变量[`设置为 innodb_buffer_pool_dump_pct`](https://dev.mysql.com/doc/refman/8.3/en/innodb-parameters.html#sysvar_innodb_buffer_pool_dump_pct)。一旦缓冲池转储完成或停止（请参阅 `--dump-innodb-buffer-pool-timeout` ），MySQL 系统变量的值就会恢复。

#### dump-innodb-buffer-pool-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool-timeout)

Usage: `--dump-innodb-buffer-pool-timeout` 用法： `--dump-innodb-buffer-pool-timeout` 

This option contains the number of seconds that xtrabackup should monitor the value of [`innodb_buffer_pool_dump_status`](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status) to determine if the buffer pool dump has been completed.
此选项包含 xtrabackup 应监视的值[ `innodb_buffer_pool_dump_status` ](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Innodb_buffer_pool_dump_status)以确定缓冲池转储是否已完成的秒数。

This option is used in combination with [`--dump-innodb-buffer-pool`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool). By default, it is set to 10 seconds.
此选项与 [`--dump-innodb-buffer-pool`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#dump-innodb-buffer-pool) 结合使用。默认情况下，它设置为 10 秒。

#### encrypt[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt) 加密[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt)

Usage: `--encrypt=ENCRYPTION_ALGORITHM` 用法： `--encrypt=ENCRYPTION_ALGORITHM` 

This option instructs xtrabackup to encrypt backup copies of InnoDB data files using the algorithm specified in the ENCRYPTION_ALGORITHM. Currently supported algorithms are: `AES128`, `AES192` and `AES256`
此选项指示 xtrabackup 使用ENCRYPTION_ALGORITHM中指定的算法加密 InnoDB 数据文件的备份副本。目前支持的算法有：`AES128`、`AES192` 和 `AES256`

#### encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-key) 加密密钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-key)

Usage: `--encrypt-key=ENCRYPTION_KEY`
用法：`--encrypt-key=ENCRYPTION_KEY`

A proper length encryption key to use. This key can be viewed as part of  the process info. We do not recommend using this option with  uncontrolled access to the machine.
要使用的适当长度的加密密钥。此键可以作为流程信息的一部分查看。我们建议不要在对计算机进行不受控制的访问时使用此选项。

#### encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-key-file) 加密密钥文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-key-file)

Usage: `--encrypt-key-file=ENCRYPTION_KEY_FILE` 用法： `--encrypt-key-file=ENCRYPTION_KEY_FILE` 

The name of a file where the raw key of the appropriate length can be read from. The file must be a simple binary (or text) file that contains exactly the key to be used.
可以从中读取适当长度的原始键的文件的名称。该文件必须是一个简单的二进制（或文本）文件，该文件恰好包含要使用的密钥。

It is passed directly to the xtrabackup child process. See the xtrabackup documentation for more details.
它直接传递给 xtrabackup 子进程。有关更多详细信息，请参阅 xtrabackup 文档。

#### encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-threads) 加密线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-threads)

Usage: `--encrypt-threads=#`
用法：`--encrypt-threads=#`

This option specifies the number of worker threads that will be used for parallel encryption/decryption. See the xtrabackup documentation for more details.
此选项指定将用于并行加密/解密的工作线程数。有关更多详细信息，请参阅 xtrabackup 文档。

#### encrypt-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-chunk-size) 加密块大小[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-chunk-size)

Usage: `--encrypt-chunk-size=#`
用法：`--encrypt-chunk-size=#`

This option specifies the size of the internal working buffer for each encryption thread, measured in bytes. It is passed directly to the xtrabackup child process.
此选项指定每个加密线程的内部工作缓冲区的大小，以字节为单位。它直接传递给 xtrabackup 子进程。

To adjust the chunk size for encrypted files, use [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size) and this option.
要调整加密文件的块大小，请使用 [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size) 和此选项。

#### estimate-memory[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#estimate-memory) 估计内存[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#estimate-memory)

Usage: `--estimate-memory=#`
用法：`--estimate-memory=#`

This option is in [tech preview](https://docs.percona.com/percona-xtrabackup/8.4/glossary.html#tech-preview).
此选项处于[技术预览](https://docs.percona.com/percona-xtrabackup/8.4/glossary.html#tech-preview)阶段。

The option lets you enable or disable the [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/8.4/smart-memory-estimation.html) feature. The default value is OFF. Enable the feature by setting `--estimate-memory=ON` in the backup phase and setting the `--use-free-memory-pct` option in the `--prepare` phase. If the `--estimate-memory` setting is disabled, the `--use-free-memory-pct` setting is ignored.
该选项允许您启用或禁用 [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/8.4/smart-memory-estimation.html) 功能。默认值为 OFF。通过在备份阶段设置 `--estimate-memory=ON`，并在 `--prepare` 阶段设置 `--use-free-memory-pct` 选项来启用该功能。如果禁用了 `--estimate-memory` 设置，则忽略 `--use-free-memory-pct` 设置。

An example of how to enable the Smart memory estimation feature:
如何启用 Smart memory estimation 功能的示例：

```
$ xtrabackup --backup --estimate-memory=ON --target-dir=/data/backups/
$ xtrabackup --prepare --use-free-memory-pct=50 --target-dir=/data/backups/
```

#### export[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#export) 导出[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#export)

Usage: `--export` 用法： `--export`

Create files necessary for exporting tables. For more details, see [Restore individual tables](https://docs.percona.com/percona-xtrabackup/8.4/restore-individual-tables.html).
创建导出表所需的文件。有关更多详细信息，请参阅[还原单个表](https://docs.percona.com/percona-xtrabackup/8.4/restore-individual-tables.html)。

#### extra-lsndir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#extra-lsndir) extra-lsndir [文件¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#extra-lsndir)

Usage: `--extra-lsndir=DIRECTORY`
用法：`--extra-lsndir=DIRECTORY`

(for –backup): save an extra copy of the `xtrabackup_checkpoints` and `xtrabackup_info` files in the specified directory.
（对于 –backup）：在指定目录中保存 `xtrabackup_checkpoints` 和 `xtrabackup_info` 文件的额外副本。

#### force-non-empty-directories[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#force-non-empty-directories) force-non-empty-directories（强制非空目录[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#force-non-empty-directories)

Usage: `--force-non-empty-directories`
用法：`--force-non-empty-directories`

When specified, the `-`-copy-back`and`–move-back` options transfer files to non-empty directories. No existing files are overwritten. If files that need to be copied/moved from the backup directory already exist in the destination directory, the operation fails with an error.
指定后， `-`-copy-back`和` –move-back' 选项会将文件传输到非空目录。不会覆盖任何现有文件。如果需要从备份目录复制/移动的文件已存在于目标目录中，则操作将失败并显示错误。

#### ftwrl-wait-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ftwrl-wait-timeout)

Usage: `--ftwrl-wait-timeout=SECONDS`
用法：`--ftwrl-wait-timeout=SECONDS`

This option specifies the time in seconds that xtrabackup should wait for queries that would block `FLUSH TABLES WITH READ LOCK` before running it. If there are still such queries when the timeout expires, xtrabackup terminates with an error.
此选项指定 xtrabackup 在运行之前应等待会阻止 `FLUSH TABLES WITH READ LOCK` 的查询的时间（以秒为单位）。如果在超时到期时仍有此类查询，则 xtrabackup 将终止并显示错误。

The default value is `0`, xtrabackup does not wait for queries to complete and starts `FLUSH TABLES WITH READ LOCK` immediately. Where supported, xtrabackup automatically uses the [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify the InnoDB tables.
默认值为 0，xtrabackup 不会等待查询完成，并立即启动 `FLUSH TABLES WITH READ LOCK`。``在支持的情况下，xtrabackup 会自动使用 [Backup 锁](https://docs.percona.com/percona-server/innovation-release/backup-locks.html)作为 `FLUSH TABLES WITH READ LOCK` 的轻量级替代方案来复制非 InnoDB 数据，以避免阻止修改 InnoDB 表的 DML 查询。

#### ftwrl-wait-threshold[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ftwrl-wait-threshold) ftwrl-wait-阈值[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ftwrl-wait-threshold)

Usage: `--ftwrl-wait-threshold=SECONDS` 用法： `--ftwrl-wait-threshold=SECONDS` 

This option specifies the query run time threshold which is used by xtrabackup to detect long-running queries with a non-zero value of `--ftwrl-wait-timeout`. `FLUSH TABLES WITH READ LOCK` is not started until such long-running queries exist.
此选项指定查询运行时阈值，xtrabackup 使用该阈值来检测具有非零值 `--ftwrl-wait-timeout` 的长时间运行的查询。在存在此类长时间运行的查询之前，`不会启动 FLUSH TABLES WITH READ LOCK`。

This option has no effect if `--ftwrl-wait-timeout` is `0`. The default value is `60` seconds. The xtrabackup binary automatically uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables when backup locks are supported.
如果 `--ftwrl-wait-timeout` 为 `0`，则此选项无效。默认值为 `60` 秒。xtrabackup 二进制文件自动使用[备份锁](https://docs.percona.com/percona-server/innovation-release/backup-locks.html)作为 `FLUSH TABLES WITH READ LOCK` 的轻量级替代方案来复制非 InnoDB 数据，以避免在支持备份锁时阻止修改 InnoDB 表的 DML 查询。

#### ftwrl-wait-query-type[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ftwrl-wait-query-type)

Usage: `--ftwrl-wait-query-type=all|update`This option specifies which queries can be completed before xtrabackup issues the global lock. The default value is `all`.
Usage（用法）： `--ftwrl-wait-query-type=all|update` 此选项指定在 xtrabackup 发出全局锁之前可以完成哪些查询。默认值为 `all`。

#### galera-info[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#galera-info)

Usage: `--galera-info`
用法： `--galera-info`

This option creates the `xtrabackup_galera_info` file, which contains the local node state at the backup time. This option should be used when performing the backup of a Percona XtraDB Cluster. The option has no effect when [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) are used to create the backup.
此选项将创建 `xtrabackup_galera_info` 文件，其中包含备份时的本地节点状态。在执行 Percona XtraDB 集群的备份时，应使用此选项。当使用 [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) 创建备份时，该选项无效。

#### generate-new-master-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#generate-new-master-key) 生成新主密钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#generate-new-master-key)

Usage: `--generate-new-master-key`
用法：`--generate-new-master-key`

Generate a new master key when doing a copy-back.
在执行复制回时生成新的主密钥。

#### generate-transition-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#generate-transition-key) generate-transition-key（生成转换密钥[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#generate-transition-key)

Usage: `--generate-transition-key`
用法：`--generate-transition-key`

xtrabackup needs to access the same keyring file or vault server during prepare and copy-back operations but it should not depend on whether the server keys have been purged.
xtrabackup 需要在准备和复制回操作期间访问相同的密钥环文件或 Vault 服务器，但它不应依赖于服务器密钥是否已被清除。

`--generate-transition-key` creates and adds to the keyring a transition key for xtrabackup to use if the master key used for encryption is not found because that key has been rotated and purged.
`--generate-transition-key` 会创建一个转换密钥，并将其添加到密钥环中，如果由于该密钥已被轮换和清除而找不到用于加密的主密钥，则 xtrabackup 可以使用该密钥。

#### get-server-public-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#get-server-public-key) 获取服务器公钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#get-server-public-key)

Usage: `--get-server-public-key`
用法：`--get-server-public-key`

Get the server public key
获取服务器公钥

#### help[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#help) 帮助[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#help)

Usage: `--help` 用法： `--help`

This option displays information about how to run the program along with  supported options and variables with the default values, where  appropriate.
此选项显示有关如何运行程序的信息，以及支持的选项和变量以及默认值（如果适用）。

#### history[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#history) 历史[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#history)

Usage: `--history=NAME`
用法：`--history=NAME`

This option enables the tracking of backup history in the `PERCONA_SCHEMA.xtrabackup_history` table. You can specify a history series name placed with the current backup’s history record.
此选项启用 `PERCONA_SCHEMA.xtrabackup_history` 对表中备份历史记录的跟踪。您可以指定与当前备份的历史记录一起放置的历史序列名称。

#### host[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#host) 主机[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#host)

Usage: `--host=HOST`
用法：`--host=HOST`

This option accepts a string argument that specifies the host to use when connecting to the database server with TCP/IP. It is passed to the mysql child process without alteration. See mysql –help for details.
此选项接受一个字符串参数，该参数指定在使用 TCP/IP 连接到数据库服务器时要使用的主机。它被传递给 mysql 子进程，而不做任何更改。有关详细信息，请参阅 mysql – help。

#### incremental-basedir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir) 增量式 IR[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir)

Usage: `--incremental-basedir=DIRECTORY` 用法： `--incremental-basedir=DIRECTORY` 

This is the directory that contains the full backup, which is the base dataset for the incremental backups.
这是包含完整备份的目录，它是增量备份的基本数据集。

#### incremental-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-dir) incremental-dir [目录¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-dir)

Usage: `--incremental-dir=DIRECTORY`
用法：`--incremental-dir=DIRECTORY`

This is the directory where the incremental backup is combined with the full backup to make a new full backup.
这是增量备份与完整备份相结合以进行新完整备份的目录。

#### incremental-force-scan[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-force-scan) 增量力扫描[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-force-scan)

Usage: `--incremental-force-scan`
用法：`--incremental-force-scan`

When creating an incremental backup, force a full scan of the data pages in that instance.
创建增量备份时，强制对该实例中的数据页进行完全扫描。

#### incremental-history-name[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-name) 增量历史记录名称[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-name)

Usage: `--incremental-history-name=name` 用法： `--incremental-history-name=name` 

This option specifies the name of the backup series stored in the `PERCONA_SCHEMA.xtrabackup_history` used as a base for an incremental backup. xtrabackup searches the history table looking for the most recent (highest `innodb_to_lsn`), successful backup in the series and takes the `to_lsn`` value to use as the starting`lsn` for the incremental backup.
此选项指定存储在 中的备份序列的名称， `PERCONA_SCHEMA.xtrabackup_history` 用作增量备份的基础。XtraBackup 搜索历史记录表，查找系列中最近（`最高innodb_to_lsn`）的成功备份，并获取 `to_lsn`` value to use as the starting` lsn' 进行增量备份。

This options is mutually exclusive with [`--incremental-history-uuid`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-uuid), [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir), and [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-lsn).
此选项与 [`--incremental-history-uuid`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-uuid)、[`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir) 和 [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-lsn) 互斥。

If no valid lsn can be found, either no series by that name or no successful backups by that name, xtrabackup returns an error.
如果找不到有效的 lsn，要么没有该名称的序列，要么没有该名称的成功备份，则 xtrabackup 将返回错误。

The option is used with the `--incremental` option.
该选项与 `--incremental` 选项一起使用。

#### incremental-history-uuid[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-uuid) 增量历史记录 uuid[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-uuid)

Usage: `--incremental-history-uuid=name` 用法： `--incremental-history-uuid=name` 

This option specifies the Universal Unique Identifier (UUID) of the history record in `PERCONA_SCHEMA.xtrabackup_history` used as the base for an incremental backup.
此选项指定 `PERCONA_SCHEMA.xtrabackup_history` 用作增量备份基础的历史记录的通用唯一标识符 （UUID）。

This options is mutually exclusive with [`--incremental-history-name`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-name), [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir), and [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-lsn).
此选项与 [`--incremental-history-name`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-history-name)、[`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir) 和 [`--incremental-lsn`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-lsn) 互斥。

If there is no success record with that UUID, xtrabackup returns an error.
如果该 UUID 没有成功记录，则 xtrabackup 将返回错误。

The option is used with the `-–incremental` option.
该选项与 `-–incremental` 选项一起使用。

#### incremental-lsn[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-lsn)

Usage: `--incremental-lsn=LSN`
用法：`--incremental-lsn=LSN`

When creating an incremental backup, you can specify the log sequence number (LSN), a single 64-bit integer, instead of the  [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir).
创建增量备份时，您可以指定日志序列号 （LSN），一个 64 位整数，而不是 [`--incremental-basedir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#incremental-basedir)。

Important 重要

Percona XtraBackup does not detect if an incorrect LSN value is specified; the backup is unusable. Be careful!
Percona XtraBackup 不会检测是否指定了不正确的 LSN 值;备份不可用。小心！

#### innodb[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb)

Usage: `--innodb=name`
用法：`--innodb=name`

This option is ignored for MySQL option compatibility.
为了 MySQL 选项兼容性，将忽略此选项。

#### innodb-miscellaneous[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-miscellaneous) innodb-杂项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-miscellaneous)

Usage: `--innodb-miscellaneous xtrabackup boots up its embedded InnoDB with the same configuration as  your current server using the InnoDB options read from that server's`my.cnf` file. You do not need to specify these options explicitly.
用法： `--innodb-miscellaneous xtrabackup boots up its embedded InnoDB with the same configuration as  your current server using the InnoDB options read from that server's` my.cnf' 文件。您无需显式指定这些选项。

These options behave the same in either InnoDB or XtraDB.
这些选项在 InnoDB 或 XtraDB 中的行为相同。

#### keyring-file-data[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#keyring-file-data) 密钥环文件数据[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#keyring-file-data)

Usage: `--keyring-file-data=FILENAME`
用法：`--keyring-file-data=FILENAME`

Defines the path to the keyring file. You can combine this option with [`--xtrabackup-plugin-dir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#xtrabackup-plugin-dir).
定义密钥环文件的路径。你可以将此选项与 [`--xtrabackup-plugin-dir`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#xtrabackup-plugin-dir) 结合使用。

#### kill-long-queries-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#kill-long-queries-timeout)

Usage: `--kill-long-queries-timeout=SECONDS` 用法： `--kill-long-queries-timeout=SECONDS` 

This option specifies the number of seconds xtrabackup waits between starting `FLUSH TABLES WITH READ LOCK` and killing those queries that block it. The default value is 0 (zero) seconds, which means xtrabackup does not kill any queries.
此选项指定 xtrabackup 在启动 `FLUSH TABLES WITH READ LOCK` 和终止阻止它的查询之间等待的秒数。默认值为 0（零）秒，这意味着 xtrabackup 不会终止任何查询。

To use this option xtrabackup user should have the `PROCESS` and `SUPER` privileges.
要使用此选项，xtrabackup 用户应具有 `PROCESS` 和 `SUPER` 权限。

Where supported, xtrabackup automatically uses [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
在支持的情况下，xtrabackup 会自动使用 [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) 作为 `FLUSH TABLES WITH READ LOCK` 的轻量级替代方案来复制非 InnoDB 数据，以避免阻止修改 InnoDB 表的 DML 查询。

#### kill-long-query-type[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#kill-long-query-type)

Usage: `--kill-long-query-type=all|select` 用法： `--kill-long-query-type=all|select` 

This option specifies which queries should be killed to unblock the global lock. The default value is “select”.
此选项指定应终止哪些查询以取消阻止全局锁。默认值为 “select”。

#### lock-ddl[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl)

Usage: `--lock-ddl`
用法： `--lock-ddl`

Enabled by default to ensure that any DDL event does not corrupt the backup.  Any DML events continue to occur. A DDL lock protects table and view  definitions.
默认情况下启用，以确保任何 DDL 事件都不会损坏备份。任何 DML 事件都会继续发生。DDL 锁保护表和视图定义。

If the option is disabled, a backup continues while concurrent DDL events  are executed. These backups are invalid and fail in the Prepare step.
如果禁用该选项，则在执行并发 DDL 事件时继续备份。这些备份无效，并在 Prepare 步骤中失败。

Use a [safe-slave-backup](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup) option to stop a SQL replica thread before copying the InnoDB files.
在复制 InnoDB 文件之前，使用 [safe-slave-backup](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup) 选项停止 SQL 副本线程。

#### lock-ddl-per-table[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl-per-table) 每个表的 lock-ddl[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl-per-table)

Usage: `--lock-ddl-per-table`
用法：`--lock-ddl-per-table`

Deprecated. Use the [`–lock-ddl`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl) option instead
荒废的。请改用 [`–lock-ddl`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl) 选项

Lock DDL for each table before xtrabackup starts to copy it and until the backup is completed.
在 xtrabackup 开始复制每个表之前，直到备份完成，锁定每个表的 DDL。

#### lock-ddl-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl-timeout) lock-ddl-timeout（锁定 ddl 超时[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#lock-ddl-timeout)

Usage: `--lock-ddl-timeout`
用法：`--lock-ddl-timeout`

If `LOCK TABLES FOR BACKUP` or `LOCK INSTANCE FOR BACKUP` does not return within a given time, abort the backup.
如果 `LOCK TABLES FOR BACKUP` 或 `LOCK INSTANCE FOR BACKUP` 在给定时间内未返回，请中止备份。

### log[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log) 日志[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log)

Usage: `--log` 用法：`--log`

This option is ignored for MySQL
对于 MySQL，此选项将被忽略

### log-bin[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-bin) 日志箱[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-bin)

Usage: `--log-bin`
用法：`--log-bin`

The base name for the log sequence.
日志序列的基本名称。

### log-bin-index[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-bin-index) log-bin-index（日志bin索引[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-bin-index)

Usage: `--log-bin-index=name`
用法：`--log-bin-index=name`

The file that stores the names for binary log files.
存储二进制日志文件名称的文件。

### log-copy-interval[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-copy-interval) log-copy-interval （日志复制间隔[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#log-copy-interval)

Usage: `--log-copy-interval=#`
用法：`--log-copy-interval=#`

This option specifies the time interval between checks done by the log copying thread in milliseconds. The default value is 1 second.
此选项指定日志复制线程完成的检查之间的时间间隔（以毫秒为单位）。默认值为 1 秒。

### login-path[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#login-path) 登录路径[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#login-path)

Usage: `--login-path`
用法：`--login-path`

Read the given path from the login file.
从登录文件中读取给定的路径。

### move-back[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#move-back) 移回[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#move-back)

Usage: `--move-back`
用法： `--move-back`

Move all files in a previous backup from the backup directory to their original locations.
将先前备份中的所有文件从备份目录移动到其原始位置。

Use this option with caution since the operation removes backup files.
请谨慎使用此选项，因为该操作会删除备份文件。

### no-backup-locks[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-backup-locks) 无备份锁[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-backup-locks)

Usage: `--no-backup-locks`
用法： `--no-backup-locks`

Explicity disables the [`--backup-locks`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-locks) option which is enabled by default.
显式禁用默认启用的 [`--backup-locks`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#backup-locks) 选项。

### no-defaults[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-defaults) 无默认值[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-defaults)

Usage: `--no-defaults`
用法：`--no-defaults`

The default options are only read from the login file.
默认选项仅从登录文件中读取。

### no-lock[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-lock) 无锁[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-lock)

Usage: `--no-lock`
用法： `--no-lock`

Disables the table lock with `FLUSH TABLES WITH READ LOCK`. Use it only if all your tables are InnoDB and you do not  care about the binary log position of the backup. This option shouldn’t be  used if any DDL statements are being executed or updates are happening on non-InnoDB tables; this includes the system MyISAM tables  in the mysql database. Otherwise, those operations could lead to an  inconsistent backup.
使用 `FLUSH TABLES WITH READ LOCK` 禁用表锁。仅当所有 table 都是 InnoDB 并且您不关心备份的二进制日志位置时，才使用它。如果正在执行任何 DDL 语句或在非  InnoDB table 上进行更新，则不应使用此选项;这包括 mysql 数据库中的系统 MyISAM  表。否则，这些操作可能会导致备份不一致。

Where supported, xtrabackup will automatically use [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) as a lightweight alternative to `FLUSH TABLES WITH READ LOCK` to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
在支持的情况下，xtrabackup 将自动使用 [Backup 锁](https://docs.percona.com/percona-server/innovation-release/backup-locks.html)作为 `FLUSH TABLES WITH READ LOCK` 的轻量级替代方案来复制非 InnoDB 数据，以避免阻止修改 InnoDB 表的 DML 查询。

If you consider using this option because your backups fail to acquire the lock, maybe incoming replication events prevent the lock from succeeding. Try the `--safe-slave-backup` option to stop the replication replica thread momentarily. The `--safe-slave-backup` option may help the backup to succeed and avoid using this option.
如果因为备份无法获取锁定而考虑使用此选项，则可能是传入的复制事件会阻止锁定成功。尝试 `--safe-slave-backup` 选项暂时停止复制副本线程。`--safe-slave-backup` 选项可以帮助备份成功并避免使用此选项。

### no-server-version-check[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-server-version-check) 无服务器版本检查[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-server-version-check)

Usage: `--no-server-version-check`
用法：`--no-server-version-check`

The `--no-server-version-check` option disables the server version check.
`--no-server-version-check` 选项禁用服务器版本检查。

The default behavior runs a check that compares the source system version  to the Percona XtraBackup version. If the source system version is  higher than the XtraBackup version, the backup is aborted with a  message.
默认行为运行一个检查，将源系统版本与 Percona XtraBackup 版本进行比较。如果源系统版本高于 XtraBackup 版本，则备份将中止并显示一条消息。

Adding the option overrides this check, and the backup proceeds, but there may be issues with the backup.
添加该选项将覆盖此检查，备份将继续，但备份可能存在问题。

See [Server Version and Backup Version Comparison](https://docs.percona.com/percona-xtrabackup/8.4/server-backup-version-comparison.html) for more information.
有关更多信息[，请参阅 Server Version 和 Backup Version 比较](https://docs.percona.com/percona-xtrabackup/8.4/server-backup-version-comparison.html)。

### no-version-check[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-version-check) 无版本检查[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#no-version-check)

Usage: `--no-version-check`
用法：`--no-version-check`

This option disables the version check. 
此选项将禁用版本检查。

If you do not pass this option, xtrabackup implicitly enables the automatic version check in the `--backup` mode. 
如果不传递此选项，xtrabackup 将在 `--backup` 模式下隐式启用自动版本检查。

To disable the version check, invoke xtrabackup and explicitly pass this option.
要禁用版本检查，请调用 xtrabackup 并显式传递此选项。

When the automatic version check is enabled, xtrabackup performs a version check against the server on the backup stage after creating a server connection. xtrabackup sends the following information to the server:
启用自动版本检查后，xtrabackup 会在创建服务器连接后，在备份阶段对服务器执行版本检查。xtrabackup 将以下信息发送到服务器：

- MySQL flavour and version
  MySQL 风格和版本
- Operating system name 操作系统名称
- Percona Toolkit version Percona Toolkit 版本
- Perl version Perl 版本

Each piece of information has a unique identifier. This identifier is a MD5 hash value that Percona Toolkit uses to obtain statistics about its use. This information is a random UUID; no client information is collected or stored.
每条信息都有一个唯一的标识符。此标识符是 Percona Toolkit 用于获取有关其使用情况的统计信息的 MD5 哈希值。此信息是随机 UUID;不会收集或存储任何客户端信息。

### open-files-limit[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#open-files-limit) 打开文件限制[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#open-files-limit)

Usage: `--open-files-limit=#`
用法：`--open-files-limit=#`

The maximum number of file descriptors to reserve with [setrlimit](https://linux.die.net/man/2/setrlimit)git .
使用 [setrlimit](https://linux.die.net/man/2/setrlimit)git 保留的最大文件描述符数。

### parallel[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel) 并行[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#parallel)

Usage: `--parallel=#`
用法：`--parallel=#`

This option specifies the number of threads to use to copy multiple data files concurrently when creating a backup. The default value is 1, there is no concurrent transfer. This option can be used with the `--copy-back` option to copy the user data files in parallel. The redo logs and system tablespaces are copied in the main thread.
此选项指定在创建备份时用于同时复制多个数据文件的线程数。默认值为 1，没有并发传输。此选项可与 `--copy-back` 选项一起使用，以并行复制用户数据文件。重做日志和系统表空间将复制到主线程中。

### password[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#password) 密码[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#password)

Usage: `--password=PASSWORD`
用法：`--password=PASSWORD`

This option accepts a string argument that specifies the password used when connecting to the database.
此选项接受一个 string 参数，该参数指定连接到数据库时使用的密码。

### plugin-load[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#plugin-load) 插件加载[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#plugin-load)

Usage: `--plugin-load`
用法： `--plugin-load`

A list of plugins to load.
要加载的插件列表。

### port[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#port) 端口[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#port)

Usage: `--port=PORT`
用法：`--port=PORT`

This option accepts a string argument specifying the TCP/IP port used to  connect to the database server. This option is passed to the mysql child process without alteration.
此选项接受一个字符串参数，该参数指定用于连接到数据库服务器的 TCP/IP 端口。此选项将传递给 mysql 子进程，无需更改。

### prepare[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#prepare) 准备[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#prepare)

Usage: `--prepare`
用法： `--prepare`

Makes xtrabackup perform a recovery on a backup created with `--backup`, so that the backup data is ready to use.
使 xtrabackup 对使用 `--backup` 创建的备份执行恢复，以便备份数据可供使用。

For details, see [Prepare a full backup](https://docs.percona.com/percona-xtrabackup/8.4/prepare-full-backup.html).
有关详细信息，请参阅[准备全量备份](https://docs.percona.com/percona-xtrabackup/8.4/prepare-full-backup.html)。

### print-defaults[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#print-defaults) 打印默认值[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#print-defaults)

Usage: `--print-defaults`
用法： `--print-defaults`

Prints the program argument list and exit and must be the first option on the command line.
打印程序参数列表并退出，并且必须是命令行上的第一个选项。

### print-param[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#print-param)

Usage: `--print-param`
用法： `--print-param`

Prints the parameters that can be used for copying the data files back to their original locations to restore them.
打印可用于将数据文件复制回其原始位置以恢复它们的参数。

### read-buffer-size[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size) 读取缓冲区大小[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size)

Usage: `--read-buffer-size`
用法：`--read-buffer-size`

Set the read buffer size. The given value is scaled up to page size. The  default size is 10MB. Use this option to increase the xbcloud/xbstream  chunk size from the default size.
设置读取缓冲区大小。给定的值将放大到页面大小。默认大小为 10MB。使用此选项可将 xbcloud/xbstream 块大小从默认大小增加。

To adjust the chunk size for encrypted files, use [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size) and [`--encrypt-chunk-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-chunk-size).
要调整加密文件的块大小，请使用 [`--read-buffer-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#read-buffer-size) 和 [`--encrypt-chunk-size`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#encrypt-chunk-size)。

### register-redo-log-consumer[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#register-redo-log-consumer)

Usage: `--register-redo-log-consumer`
用法：`--register-redo-log-consumer`

This option is disabled by default.
默认情况下，此选项处于禁用状态。

When enabled, this options lets Percona XtraBackup register as a redo log  consumer at the start of the backup. The server does not remove a redo  log that Percona XtraBackup (the consumer) has not yet copied. The  consumer reads the redo log and manually advances the log sequence  number (LSN). The server blocks the writes during the process. The  server determines when to purge the log based on the redo log  consumption.
启用后，此选项允许 Percona XtraBackup 在备份开始时注册为重做日志使用者。服务器不会删除 Percona  XtraBackup（消费者）尚未复制的重做日志。使用者读取重做日志并手动推进日志序列号  （LSN）。服务器在此过程中阻止写入。服务器根据重做日志消耗量确定何时清除日志。

### remove-original[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#remove-original) remove-original [删除原始¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#remove-original)

Usage: `--remove-original`
用法： `--remove-original`

This option removes `.qp`, `.xbcrypt` and `.qp.xbcrypt` files after decryption and decompression.
此选项在解密和解压缩后删除 `.qp`、`.xbcrypt` 和 `.qp.xbcrypt` 文件。

### rocksdb-datadir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-datadir) rocksdb-data目录[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-datadir)

Usage: `--rocksdb-datadir`
用法：`--rocksdb-datadir`

Names the RocksDB data directory
命名 RocksDB 数据目录

### rocksdb-wal-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-wal-dir) rocksdb-wal-dir [目录¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-wal-dir)

Usage: `--rocksdb-wal-dir`
用法： `--rocksdb-wal-dir`

RocksDB WAL directory. RocksDB WAL 目录。

### rocksdb-checkpoint-max-age[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-checkpoint-max-age) rocksdb-checkpoint-max-age （rocksdb-checkpoint-max-age[） （](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-checkpoint-max-age)最大年龄） ¶

Usage: `--rocksdb-checkpoint-max-age`
用法：`--rocksdb-checkpoint-max-age`

The checkpoint cannot be older than this number of seconds when the backup is complete.
备份完成后，检查点不能早于此秒数。

### rocksdb-checkpoint-max-count[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-checkpoint-max-count) rocksdb-checkpoint-max-count （最大检查点[） ¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rocksdb-checkpoint-max-count)

Usage: `--rocksdb-checkpoint-max-count` 用法： `--rocksdb-checkpoint-max-count` 

Complete the backup even if the checkpoint age requirement has not been met after this number of checkpoints.
即使在此数量的 checkpoint 之后仍未满足 checkpoint 期限要求，也请完成备份。

### rollback-prepared-trx[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rollback-prepared-trx) 回滚准备的 trx[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rollback-prepared-trx)

Usage: `--rollback-prepared-trx`
用法：`--rollback-prepared-trx`

Force rollback prepared InnoDB transactions.
强制回滚准备好的 InnoDB 事务。

### rsync[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#rsync)

Usage: `--rsync` 用法：`--rsync`

Uses the rsync utility to optimize local file transfers. The xtrabackup  binary uses rsync to copy all non-InnoDB files instead of spawning a  separate cp for each file, which can be much faster for servers with  many databases or tables.
使用 rsync 实用程序优化本地文件传输。xtrabackup 二进制文件使用 rsync 复制所有非 InnoDB 文件，而不是为每个文件生成单独的 cp，这对于具有许多数据库或表的服务器来说可能要快得多。

You cannot use this option with [`--stream`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#stream).
您不能将此选项与 [`--stream`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#stream) 一起使用。

### safe-slave-backup[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup) 安全从属备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup)

Usage: `--safe-slave-backup`
用法： `--safe-slave-backup`

When specified, xtrabackup stops the replica SQL thread just before running `FLUSH TABLES WITH READ LOCK` and waits to start the backup operation until `Replica_open_temp_tables`` in`SHOW STATUS` is zero.
指定后，xtrabackup 会在运行 `FLUSH TABLES WITH READ LOCK` 之前停止副本 SQL 线程，并等待开始备份操作，直到 `Replica_open_temp_tables'' in`SHOW STATUS' 为零。

If there are no open temporary tables, the backup takes place, otherwise  the SQL thread is started and stopped until there are no open temporary  tables. The backup fails if `Replica_open_temp_tables` does not become zero after [`--safe-slave-backup-timeout`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup-timeout) seconds. The replication SQL thread is restarted when the backup is complete. This option is implemented to deal with [replication and temporary tables](https://dev.mysql.com/doc/refman/8.4/en/replication-features-temptables.html) and isn’t necessary with row-based replication.
如果没有打开的临时表，则进行备份，否则将启动和停止 SQL 线程，直到没有打开的临时表。如果在 [`--safe-slave-backup-timeout`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup-timeout) 秒后`Replica_open_temp_tables`没有变为零，则备份将失败。备份完成后，复制 SQL 线程将重新启动。实现此选项是为了处理[复制表和临时表](https://dev.mysql.com/doc/refman/8.4/en/replication-features-temptables.html)，对于基于行的复制不是必需的。

Using a safe-slave-backup option stops the SQL replica thread before copying the InnoDB files.
使用 safe-slave-backup 选项会在复制 InnoDB 文件之前停止 SQL 副本线程。

### safe-slave-backup-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup-timeout) 安全从备份超时[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#safe-slave-backup-timeout)

Usage: `--safe-slave-backup-timeout=SECONDS` 用法： `--safe-slave-backup-timeout=SECONDS` 

How many seconds the `--safe-slave-backup` option waits for the `Replica_open_temp_tables` to become zero. The default value is 300 seconds.
`--safe-slave-backup` 选项等待`Replica_open_temp_tables`变为零的秒数。默认值为 300 秒。

### secure-auth[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#secure-auth) secure-auth [身份验证¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#secure-auth)

Usage: `--secure-auth`
用法：`--secure-auth`

Refuse the client from connecting to the server if it uses the old protocol.  This option is enabled by default. Disable this options with `–skip-secure-auth`.
如果客户端使用旧协议，则拒绝客户端连接到服务器。默认情况下，此选项处于启用状态。使用 `–skip-secure-auth` 禁用此选项。

### server-id[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#server-id) 服务器 ID[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#server-id)

Usage: `--server-id=#`
用法：`--server-id=#`

The server instance being backed up.
正在备份的服务器实例。

### server-public-key-path[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#server-public-key-path) 服务器公钥路径[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#server-public-key-path)

Usage: `--server-public-key-path`
用法：`--server-public-key-path`

The file path to the server public RSA key in the PEM format.
PEM 格式的服务器公有 RSA 密钥的文件路径。

### skip-tables-compatibility-check[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#skip-tables-compatibility-check)

Usage: `--skip-tables-compatibility-check` 用法： `--skip-tables-compatibility-check` 

See [`--tables-compatibility-check`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-compatibility-check).
请参阅 [`--tables-compatibility-check`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-compatibility-check)。

### slave-info[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#slave-info) slave-info （奴隶信息[） ¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#slave-info)

Usage: `--slave-info`
用法： `--slave-info`

This option is useful when backing up a replication replica server. It prints the binary log position of the source server. It also writes the binary log coordinates to the `xtrabackup_slave_info` file as a [`CHANGE REPLICATION SOURCE TO`](https://dev.mysql.com/doc/refman/8.4/en/change-replication-source-to.html) command.
备份复制副本服务器时，此选项非常有用。它打印源服务器的二进制日志位置。它还将二进制日志坐标作为 [`CHANGE REPLICATION SOURCE TO`](https://dev.mysql.com/doc/refman/8.4/en/change-replication-source-to.html) 命令写入 `xtrabackup_slave_info` 文件。

A new replica for this source can be set up by starting a replica server on this backup and issuing a [`CHANGE REPLICATION SOURCE TO`](https://dev.mysql.com/doc/refman/8.4/en/change-replication-source-to.html) command with the binary log position saved in the `xtrabackup_slave_info` file.
可以通过在此备份上启动副本服务器并发出 [`CHANGE REPLICATION SOURCE TO`](https://dev.mysql.com/doc/refman/8.4/en/change-replication-source-to.html) 命令并将二进制日志位置保存在 `xtrabackup_slave_info` 文件中来设置此源的新副本。

### socket[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#socket) 套接字[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#socket)

Usage: `--socket` 用法： `--socket`

This option accepts a string argument that specifies the socket to use when connecting to the local database server with a UNIX domain socket. It is passed to the MySQL child process without alteration. See mysql –help for details.
此选项接受一个 string 参数，该参数指定在使用 UNIX 域套接字连接到本地数据库服务器时要使用的套接字。它被传递给 MySQL 子进程，而不进行任何更改。有关详细信息，请参阅 mysql – help。

### ssl[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl) [SSL协议¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl)

Usage: `--ssl` 用法：`--ssl`

Enable secure connection.
启用安全连接。

### ssl-ca[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-ca) SSL-CA [协议¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-ca)

Usage: `--ssl-ca` 用法：`--ssl-ca`

The path of the file contains a list of trusted SSL CAs.
该文件的路径包含受信任的 SSL CA 列表。

### ssl-capath[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-capath) ssl-capath [浏览器¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-capath)

Usage: `--ssl-capath`
用法：`--ssl-capath`

The directory path that contains trusted SSL CA files in PEM format.
包含 PEM 格式的可信 SSL CA 文件的目录路径。

### ssl-cert[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-cert) SSL 证书[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-cert)

Usage: `--ssl-cert`
用法：`--ssl-cert`

The path of the file contains the X509 certificate in PEM format.
该文件的路径包含 PEM 格式的 X509 证书。

### ssl-cipher[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-cipher) ssl 密码[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-cipher)

Usage: `--ssl-cipher`
用法：`--ssl-cipher`

The list of the permitted ciphers to use for connection encryption.
允许用于连接加密的密码列表。

### ssl-crl[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-crl) ssl-crl [文件¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-crl)

Usage: `--ssl-crl`
用法：`--ssl-crl`

The path of the file that contains certificate revocation lists.
包含证书吊销列表的文件的路径。

### ssl-crlpath[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-crlpath) ssl-crl路径[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-crlpath)

Usage: `--ssl-crlpath`
用法：`--ssl-crlpath`

The path of the directory that contains the certificate revocation list files.
包含证书吊销列表文件的目录的路径。

### ssl-fips-mode[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-fips-mode) ssl-fips 模式[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-fips-mode)

Usage: `--ssl-fips-mode`
用法：`--ssl-fips-mode`

The SSL FIPS mode applies only for OpenSSL; permitted values are OFF, ON, and STRICT.
SSL FIPS 模式仅适用于 OpenSSL;允许的值为 OFF、ON 和 STRICT。

### ssl-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-key) SSL 密钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-key)

Usage: `--ssl-key`
用法：`--ssl-key`

The path of the file that contains the X509 key in PEM format.
包含 PEM 格式的 X509 密钥的文件的路径。

### ssl-mode[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-mode) SSL 模式[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-mode)

Usage: `--ssl-mode`
用法：`--ssl-mode`

The security state of connection to the server.
连接到服务器的安全状态。

### ssl-verify-server-cert[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-verify-server-cert) ssl-verify-server-cert （SSL验证服务器证书[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#ssl-verify-server-cert)

Usage: `--ssl-verify-server-cert`
用法：`--ssl-verify-server-cert`

Verify the server certificate Common Name value against the hostname used when connecting to the server.
根据连接到服务器时使用的主机名验证服务器证书公用名值。

### stream[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#stream) 流[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#stream)

Usage: `--stream=FORMAT`
用法：`--stream=FORMAT`

Stream all backup files to the standard output in the specified format. Currently, this option only supports the xbstream format.
将所有备份文件流式传输到指定格式的标准输出。目前，此选项仅支持 xbstream 格式。

### strict[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#strict) 严格[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#strict)

Usage: `--strict` 用法： `--strict`

If this option is specified, xtrabackup fails with an error when invalid parameters are passed.
如果指定了此选项，则在传递无效参数时，xtrabackup 将失败并显示错误。

### tables[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables) 表格[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables)

Usage: `--tables=name`
用法：`--tables=name`

A regular expression against which the full table name in the `databasename.tablename` format is matched. If the name matches, the table is backed up. See [Create a partial backup](https://docs.percona.com/percona-xtrabackup/8.4/create-partial-backup.html).
一个正则表达式，与该正则表达式匹配 `databasename.tablename` 格式的完整表名。如果名称匹配，则备份表。请参阅[创建部分备份](https://docs.percona.com/percona-xtrabackup/8.4/create-partial-backup.html)。

### tables-compatibility-check[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-compatibility-check)

Usage: `--tables-compatibility-check`
用法：`--tables-compatibility-check`

Enables the engine compatibility warning. The default value is `ON`. To disable the engine compatibility warning, use `--`skip-tables-compatibility-check`](#skip-tables-compatibility-check).
启用引擎兼容性警告。默认值为 `ON。`要禁用引擎兼容性警告，请使用 `--`skip-tables-compatibility-check']（#skip-tables-compatibility-check）。

### tables-exclude[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-exclude) tables-exclude（表除外[）¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-exclude)

Usage: `--tables-exclude=name`
用法：`--tables-exclude=name`

Filtering by regexp for table names. Operates the same way as [`--tables`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables), but matched names are excluded from backup. Note that this option has a higher priority than `--tables`.
按 regexp 筛选表名。操作方式与 [`--tables`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables) 相同，但匹配的名称将从备份中排除。请注意，此选项的优先级高于 `--tables`。

### tables-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-file) 表文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tables-file)

Usage: `--tables-file=name`
用法：`--tables-file=name`

A file containing one table name per line in `databasename.tablename` format. The backup will be limited to the specified tables.
一个文件，每行包含一个 `databasename.tablename` 格式的表名。备份将限制为指定的表。

### target-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#target-dir) 目标目录[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#target-dir)

Usage: `--target-dir=DIRECTORY`
用法：`--target-dir=DIRECTORY`

This option specifies the destination directory for the backup. If the directory does not exist, xtrabackup creates it. If the directory does exist and is empty, xtrabackup will succeed. xtrabackup does not overwrite existing files, however, the operation fails with the operating system error 17, `file exists`.
此选项指定备份的目标目录。如果该目录不存在，则 xtrabackup 将创建该目录。如果目录确实存在且为空，则 xtrabackup 将成功。XtraBackup 不会覆盖现有文件，但是，操作失败，并显示操作系统错误 17，`文件存在`。

If this option is a relative path, it is interpreted as relative to the current working directory from which xtrabackup is executed.
如果此选项是相对路径，则将其解释为相对于执行 xtrabackup 的当前工作目录。

To perform a backup, you need `READ`, `WRITE`, and `EXECUTE` permissions at a filesystem level for the directory that you supply as the value of `--target-dir`.
要执行备份，您需要在文件系统级别对您作为 `--target-dir` 的值提供的目录具有 `READ`、`WRITE` 和 `EXECUTE` 权限。

### innodb-temp-tablespaces-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#innodb-temp-tablespaces-dir)

Usage: `--innodb-temp-tablespaces-dir=DIRECTORY` 用法： `--innodb-temp-tablespaces-dir=DIRECTORY` 

The location of the directory for the temp tablespace files. This path can be absolute.
临时表空间文件的目录位置。这条路可以是绝对的。

### throttle[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#throttle) 节流[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#throttle)

Usage: `--throttle=#`
用法：`--throttle=#`

This option limits the number of chunks copied per second. The chunk size is 10 MB.
此选项限制每秒复制的块数。块大小为 10 MB。

To limit the bandwidth to 10 MB/s, set the option to 1.
要将带宽限制为 10 MB/s，请将选项设置为 1。

### tls-ciphersuites[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tls-ciphersuites) TLS 密码套件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tls-ciphersuites)

Usage: `--tls-ciphersuites`
用法：`--tls-ciphersuites`

The TLS v1.3 cipher to use.
要使用的 TLS v1.3 密码。

### tls-version[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tls-version)

Usage: `--tls-version`
用法：`--tls-version`

Defines which TLS version to use. The permitted values are: TLSv1, TLSv1.1, TLSv1.2, TLSv1.3.
定义要使用的 TLS 版本。允许的值为：TLSv1、TLSv1.1、TLSv1.2、TLSv1.3。

### tmpdir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tmpdir) tmpdir [目录¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#tmpdir)

Usage: `--tmpdir=name`
用法：`--tmpdir=name`

Specify the directory used to store temporary files during the backup
指定备份期间用于存储临时文件的目录

### transition-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#transition-key) 转换键[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#transition-key)

Usage: `--transition-key=name`
用法：`--transition-key=name`

This option is used to enable processing the backup without accessing the keyring vault server. In this case, xtrabackup derives the AES encryption key from the specified passphrase and uses it to encrypt the tablespace keys of tablespaces being backed up.
此选项用于启用在不访问密钥环保险库服务器的情况下处理备份。在这种情况下，xtrabackup 从指定的密码中派生 AES 加密密钥，并使用它来加密正在备份的表空间的表空间密钥。

If `--transition-key` does not have any value, xtrabackup will ask for it. The same passphrase should be specified for the `--prepare` command.
如果 `--transition-key` 没有任何值，xtrabackup 将请求它。应为 `--prepare` 命令指定相同的密码。

### use-free-memory-pct[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#use-free-memory-pct) 使用空闲内存 PCT[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#use-free-memory-pct)

Usage: `--use-free-memory-pct`
用法：`--use-free-memory-pct`

The `--use-free-memory-pct` is a [tech preview](https://docs.percona.com/percona-xtrabackup/8.4/glossary.html#tech-preview) option.
`--use-free-memory-pct` 是一个[技术预览](https://docs.percona.com/percona-xtrabackup/8.4/glossary.html#tech-preview)选项。

This option lets you configure the [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/8.4/smart-memory-estimation.html) feature. The option controls the amount of free memory that can be used to `--prepare` a backup. The default value is 0 (zero), which defines the option as disabled. For example, if you set `--use-free-memory-pct=50`, then 50% of the free memory is used to `prepare` a backup. The maximum allowed value is 100.
此选项允许您配置 [Smart memory estimation](https://docs.percona.com/percona-xtrabackup/8.4/smart-memory-estimation.html) 功能。该选项控制可用于 `--prepare` 备份的可用内存量。默认值为 0 （零） ，它将选项定义为 disabled。例如，如果您设置 `--use-free-memory-pct=50`，则 50% 的可用内存用于`准备`备份。允许的最大值为 100。

This option works only if `--estimate-memory` option is enabled. If the `--estimate-memory` option is disabled, the `--use-free-memory-pct` setting is ignored.
仅当启用了 `--estimate-memory` 选项时，此选项才有效。如果禁用了 `--estimate-memory` 选项，则忽略 `--use-free-memory-pct` 设置。

An example of how to enable the Smart memory estimation feature:
如何启用 Smart memory estimation 功能的示例：

```
$ xtrabackup --backup --estimate-memory=ON --target-dir=/data/backups/
$ xtrabackup --prepare --use-free-memory-pct=50 --target-dir=/data/backups/
```

### use-memory[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#use-memory) 使用内存[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#use-memory)

Usage: `--use-memory`
用法：`--use-memory`

This option affects how much memory is allocated and is similar to `innodb_buffer_pool_size`. This option is only relevant in the `--prepare` phase. The default value is 100MB. The recommended value is between 1GB to 2GB. Multiple values are supported if you provide the unit (1MB, 1M, 1GB, 1G).
此选项会影响分配的内存量，类似于 `innodb_buffer_pool_size`。此选项仅在 `--prepare` 阶段相关。默认值为 100MB。建议的值介于 1GB 到 2GB 之间。如果您提供单位（1MB、1M、1GB、1G），则支持多个值。

### user[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#user) 用户[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#user)

Usage: `--user=USERNAME`
用法：`--user=USERNAME`

This option specifies the MySQL username used when connecting to the server  if that’s not the current user. The option accepts a string argument.  See mysql –help for details.
此选项指定连接到服务器时使用的 MySQL 用户名（如果该用户不是当前用户）。该选项接受 string 参数。有关详细信息，请参阅 mysql – help。

### version[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#version) 版本[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#version)

Usage: `--version`
用法：`--version`

This option prints xtrabackup version and exits.
此选项打印 xtrabackup 版本并退出。

### xtrabackup-plugin-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#xtrabackup-plugin-dir) xtrabackup-plugin-目录[¶](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#xtrabackup-plugin-dir)

Usage: `--xtrabackup-plugin-dir=DIRNAME` 用法： `--xtrabackup-plugin-dir=DIRNAME` 

The absolute path to the directory that contains the `keyring` plugin.
包含`密钥环`插件的目录的绝对路径。

## 配置 xtrabackup

All the xtrabackup configuration is done through options, which behave exactly like standard MySQL program options: they can be specified either at the command-line, or through a file such as `/etc/my.cnf`.
所有 xtrabackup 配置都是通过选项完成的，这些选项的行为与标准的 MySQL 程序选项完全相同：它们可以在命令行中指定，也可以通过 `/etc/my.cnf` 之类的文件指定。

The xtrabackup binary reads the `[mysqld]` and `[xtrabackup]` sections from any configuration files, in that order. That is so that it can read its options from your existing MySQL installation, such as the datadir or some of the InnoDB options. If you want to override these, just specify them in the `[xtrabackup]` section, and because it is read later, it will take precedence.
xtrabackup 二进制文件按此顺序从任何配置文件中读取 `[mysqld]` 和 `[xtrabackup]` 部分。这样它就可以从您现有的 MySQL 安装中读取其选项，例如 datadir 或一些 InnoDB 选项。如果你想覆盖这些，只需在 `[xtrabackup]` 部分指定它们，因为它是稍后读取的，所以它会优先。

You don’t need to put any configuration in your `my.cnf`. You can specify the options on the command-line. Normally, the only thing you may find convenient to place in the `[xtrabackup]` section of your `my.cnf` file is the `target_dir` option. This options adds a default path to the directory for backups.
您无需在 `my.cnf` 中放置任何配置。您可以在命令行上指定选项。通常，您唯一可以方便地放在 `my.cnf` 文件的 `[xtrabackup]` 部分的是 `target_dir` 选项。此选项将添加备份目录的默认路径。

The following is an example:
下面是一个示例：

```
[xtrabackup]
target_dir = /data/backups/
```

This manual assumes you do not have any file-based configuration for xtrabackup and shows the command-line options.
本手册假定您没有任何基于文件的 xtrabackup 配置，并显示了命令行选项。

Please see the option and variable reference for details on all the configuration options.
有关所有配置选项的详细信息，请参阅 option 和 variable reference 。

The xtrabackup binary does not accept exactly the same syntax in the `my.cnf` file as the mysqld server binary does. For historical reasons, the mysqld server binary accepts parameters with a `--set-variable=<variable>=<value>` syntax, which xtrabackup does not understand. If your `my.cnf` file has such configuration directives, you should rewrite them in the `--variable=value` syntax.
xtrabackup 二进制文件在 `my.cnf` 文件中接受与 mysqld 服务器二进制文件完全相同的语法。由于历史原因， mysqld 服务器二进制文件接受带有 `--set-variable=<variable>=<value>` 语法的参数，而 xtrabackup 无法理解。如果您的 `my.cnf` 文件具有此类配置指令，则应使用 `--variable=value` 语法重写它们。

### 系统配置和 NFS 卷

The xtrabackup tool requires no special configuration on most systems. However, the storage where the `--target-dir` is located must behave properly when `fsync()` is called. In particular, we have noticed that if you mount the NFS volume without the `sync` option the NFS  volume does not sync the data. As a result, if you back up to an NFS  volume mounted with the async option, and then try to prepare the backup from a different server that also mounts that volume, the data might appear to be corrupt. Use the `sync` mount option to avoid this issue.
xtrabackup 工具在大多数系统上不需要特殊配置。但是，在调用 `fsync（）` 时，`--target-dir` 所在的存储必须正常运行。特别是，我们注意到，如果您在没有`同步`选项的情况下挂载 NFS 卷，则 NFS 卷不会同步数据。因此，如果您备份到使用 async 选项挂载的 NFS 卷，然后尝试从同样挂载该卷的其他服务器准备备份，则数据可能会损坏。使用 `sync` 挂载选项可避免此问题。