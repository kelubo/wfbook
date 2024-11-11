# xbstream

To support simultaneous compression and streaming, the xbstream binary was added to Percona XtraBackup, along with the xbstream format and tar  format. These additions were required to overcome some limitations of  traditional archive formats such as tar, cpio, and others, which did not allow  streaming dynamically generated files. 
为了支持同步压缩和流式处理，xbstream 二进制文件与 xbstream 格式和 tar 格式一起被添加到 Percona XtraBackup  中。需要添加这些内容来克服传统存档格式（如 tar、cpio 等）的一些限制，这些格式不允许流式传输动态生成的文件。

Other advantages of xbstream over traditional streaming/archive format  include streaming multiple files concurrently (so it is possible to use streaming in the xbstream format together with the –parallel option) and more compact data storage.
与传统的流式处理/存档格式相比，xbstream 的其他优势包括同时流式处理多个文件（因此可以将 xbstream 格式的流式处理与 –parallel 选项一起使用）和更紧凑的数据存储。

For details on the command-line options, see [xbcloud command-line options](https://docs.percona.com/percona-xtrabackup/8.4/xbcloud-options.html). When available, the utility tries to minimize its impact on the OS page cache by using the appropriate `posix_fadvise()` calls.
有关命令行选项的详细信息，请参阅 [xbcloud 命令行选项](https://docs.percona.com/percona-xtrabackup/8.4/xbcloud-options.html)。如果可用，该实用程序会尝试使用适当的 `posix_fadvise（）` 调用来最大程度地减少其对操作系统页面高速缓存的影响。

When compression is enabled with xtrabackup all data is compressed, including the transaction log file and metadata files, using the specified compression algorithm. Read more about supported compression algorithms in the [Create a compressed backup](https://docs.percona.com/percona-xtrabackup/8.4/create-compressed-backup.html) document.
使用 xtrabackup 启用压缩后，将使用指定的压缩算法压缩所有数据，包括事务日志文件和元数据文件。有关支持的压缩算法的更多信息，请参阅 [创建压缩备份](https://docs.percona.com/percona-xtrabackup/8.4/create-compressed-backup.html) 文档。

# 命令行选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#the-xbstream-command-line-options)

```
$ xbstream -c [OPTIONS]
$ xbstream -x [OPTIONS]
```

This utility has a tar-like interface.
此实用程序具有类似 tar 的接口。

The xbstream binary has the following options:
xbstream 二进制文件具有以下选项：

## absolute-names[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#absolute-names) 绝对名称[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#absolute-names)

Usage: `-absolute-names`
用法： `-absolute-names`

Do not strip the leading // (slashes) from the file names when creating archives.
创建档案时，不要从文件名中删除前导 //（斜杠）。

## c[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#c)

Usage: `-c` 用法：`-c`

Streams files specified on the command line to its standard output.
将命令行上指定的文件流式传输到其标准输出。

## decompress[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decompress) 解压[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decompress)

Usage: `--decompress`
用法： `--decompress`

Decompress the individual backup files
解压缩单个备份文件

## decompress-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decompress-threads) 解压线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decompress-threads)

Usage: `--decompress-threads=#`
用法：`--decompress-threads=#`

The number of threads for parallel data decompression. The default value is 1.
用于并行数据解压缩的线程数。默认值为 1。

## decrypt[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decrypt) 解密[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#decrypt)

Usage: `--decrypt=name`
用法：`--decrypt=name`

Specifies that xbstream automatically decrypts encrypted files when extracting input stream. The supported values are: `AES128`, `AES192`, and `AES256`. 
指定 xbstream 在提取输入流时自动解密加密文件。支持的值为：`AES128`、`AES192` 和 `AES256`。

You can specify either `--encrypt-key` or `--encrypt-key-file` to provide the encryption key, but do not use both options. 
您可以指定 `--encrypt-key` 或 `--encrypt-key-file` 来提供加密密钥，但不要同时使用这两个选项。

## directory[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#directory) 目录[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#directory)

Usage: `--directory=name`
用法：`--directory=name`

Change the current directory to this named directory before streaming or extracting.
在流式传输或提取之前，将当前目录更改为此命名目录。

## encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-key) 加密密钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-key)

Usage: `--encrypt-key=name`
用法：`--encrypt-key=name`

Specify the encryption key used. Do not use this option with `--encrypt-key-file`; these options are mutually exclusive.
指定使用的加密密钥。不要将此选项与 `--encrypt-key-file` 一起使用;这些选项是互斥的。

## encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-key-file) 加密密钥文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-key-file)

Usage: `--encrypt-key-file=name`
用法：`--encrypt-key-file=name`

Specify the file that contains the encryption key. Do not use this option with `--encrypt-key`; these options are mutually exclusive.
指定包含加密密钥的文件。不要将此选项与 `--encrypt-key` 一起使用;这些选项是互斥的。

## encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-threads) 加密线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#encrypt-threads)

Usage: `--encrypt-threads-=#`
用法：`--encrypt-threads-=#`

Specify the number of threads for parallel data encryption. The default value is `1`. 
指定并行数据加密的线程数。默认值为 `1`。

## extract[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#extract) 提取[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#extract)

Usage: `--extract`
用法： `--extract`

Extract to disk the files from the stream to the standard input.
将流中的文件提取到磁盘到标准输入。

## fifo-dir[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#fifo-dir) fifo-dir [目录¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#fifo-dir)

Usage: `--fifo-dir=name`
用法：`--fifo-dir=name`

The directory used to read or write named pipes.
用于读取或写入命名管道的目录。

## fifo-streams[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#fifo-streams) FIFO 流[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#fifo-streams)

Usage: `--fifo-streams=#`
用法：`--fifo-streams=#`

The number of FIFO files (named pipes) to use for parallel data file  streaming. To disable the option and send the stream to STDOUT, set the  value to 1. 
用于并行数据文件流式处理的 FIFO 文件 （命名管道） 的数量。要禁用该选项并将流发送到 STDOUT，请将值设置为 1。

## fifo-timeout[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#fifo-timeout)

Usage: `--fifo-timeout=#`
用法：`--fifo-timeout=#`

The number of seconds to wait for the other end to open the stream. The default value is 60.
等待另一端打开流的秒数。默认值为 60。

## parallel[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#parallel) 并行[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#parallel)

Usage: `--parallel=#`
用法：`--parallel=#`

Defines the number of worker threads for reading or writing.
定义用于读取或写入的工作线程数。

## x[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#x)

Usage: `-x` 用法：`-x`

Extracts files from the stream read from its standard input to the current directory unless specified otherwise with the `-c` option. Support for parallel extraction with the `--parallel` option
从从其标准输入读取的流中提取文件到当前目录，除非使用 `-c` 选项另有指定。支持使用 `--parallel` 选项进行并行提取

## verbose[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#verbose) 详细[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-options.html#verbose)

Usage: `--verbose`
用法： `--verbose`

Print verbose output 打印详细输出

# 进行流式备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/take-streaming-backup.html#take-a-streaming-backup)

Percona XtraBackup supports streaming mode. Streaming mode sends a backup to `STDOUT` in the *xbstream* format instead of copying the files to the backup directory.
Percona XtraBackup 支持串流模式。流模式以 *xbstream* 格式将备份发送到 `STDOUT`，而不是将文件复制到备份目录。

This method allows you to use other programs to filter the output of the backup, providing greater flexibility for storage of the backup. For example, compression is achieved by piping the output to a compression utility. One of the benefits of streaming backups and using Unix pipes is that the backups can be automatically encrypted.
此方法允许您使用其他程序来筛选备份的输出，从而为备份的存储提供更大的灵活性。例如，压缩是通过将输出通过管道传输到压缩实用程序来实现的。流式备份和使用 Unix 管道的好处之一是备份可以自动加密。

To use the streaming feature, run the `--stream` option.
要使用流式处理功能，请运行 `--stream` 选项。

```
$ xtrabackup --stream
```

xtrabackup uses xbstream to stream all of the data files to `STDOUT`, in a special `xbstream` format. After it finishes streaming all of the data files to `STDOUT`, it stops xtrabackup and streams the saved log file too.
xtrabackup 使用 xbstream 以特殊的 `xbstream` 格式将所有数据文件流式传输到 `STDOUT`。在完成将所有数据文件流式传输到 `STDOUT` 后，它会停止 xtrabackup 并流式传输保存的日志文件。

When compression is enabled, xtrabackup compresses the output data, except  for the meta and non-InnoDB files which are not compressed, using the  specified compression algorithm. Percona XtraBackup supports the  following compression algorithms:
启用压缩后，xtrabackup 使用指定的压缩算法压缩输出数据，但未压缩的 meta 和非 InnoDB 文件除外。Percona XtraBackup 支持以下压缩算法：

## Zstandard (ZSTD)[¶](https://docs.percona.com/percona-xtrabackup/8.4/take-streaming-backup.html#zstandard-zstd) Zstandard （ZSTD） [¶](https://docs.percona.com/percona-xtrabackup/8.4/take-streaming-backup.html#zstandard-zstd)

The Zstandard (ZSTD) is a fast lossless compression algorithm that targets  real-time compression scenarios and better compression ratios. `ZSTD` is the default compression algorithm for the `--compress` option.
Zstandard （ZSTD） 是一种快速无损压缩算法，适用于实时压缩场景和更好的压缩比。`ZSTD` 是 `--compress` 选项的默认压缩算法。

To compress files using the `ZSTD` compression algorithm, use the `--compress` option:
要使用 `ZSTD` 压缩算法压缩文件，请使用 `--compress` 选项：

```
$ xtrabackup --backup --compress --target-dir=/data/backup
```

The resulting files have the `\*.zst` format.
生成的文件具有 `\*.zst` 格式。

You can specify `ZSTD` compression level with the [`--compress-zstd-level(=#)`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level) option. The default value is `1`.
您可以使用 [`--compress-zstd-level（=#）`](https://docs.percona.com/percona-xtrabackup/8.4/xtrabackup-option-reference.html#compress-zstd-level) 选项指定 `ZSTD` 压缩级别。默认值为 `1`。

```
$ xtrabackup –backup –compress –compress-zstd-level=1 –target-dir=/data/backup
```

## lz4[¶](https://docs.percona.com/percona-xtrabackup/8.4/take-streaming-backup.html#lz4)

To compress files using the `lz4` compression algorithm, set the `--compress` option to `lz4`:
要使用 `lz4` 压缩算法压缩文件，请将 `--compress` 选项设置为 `lz4`：

```
$ xtrabackup --backup --compress=lz4 --target-dir=/data/backup
```

The resulting files have the `\*.lz4` format. 
生成的文件具有 `\*.lz4` 格式。

To decompress files, use the `--decompress` option.
要解压缩文件，请使用 `--decompress` 选项。

In case backups were both compressed and encrypted, they must be decrypted before they are uncompressed.
如果备份同时经过压缩和加密，则必须先解密，然后才能解压缩。

| Task 任务                                                    | Command 命令                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Stream the backup into an archive named `backup.xbstream` 将备份流式传输到名为 `backup.xbstream` 的存档中 | `xtrabackup --backup --stream > backup.xbstream`             |
| Stream the backup into a compressed archive named `backup.xbstream` 将备份流式传输到名为 `backup.xbstream` 的压缩存档中 | `xtrabackup --backup --stream --compress > backup.xbstream`  |
| Encrypt the backup 加密备份                                  | `xtrabackup --backup --stream  \|gzip  \| openssl des3 -salt -k 'password' -out  backup.xbstream.gz.des3` |
| Unpack the backup to the current directory 将备份解压缩到当前目录 | `xbstream -x < backup.xbstream` `xbstream -x < 备份.xbstream` |
| Send the backup compressed directly to another host and unpack it 将压缩后的备份直接发送到另一台主机并解压缩 | `xtrabackup --backup --compress --stream | ssh user@otherhost "xbstream -x"` |
| Send the backup to another server using `netcat` 使用 `netcat` 将备份发送到另一台服务器 | On the destination host: 在目标主机上： `nc -l 9999 | cat - > /data/backups/backup.xbstream`  On the source host: 在源主机上： `xtrabackup --backup --stream | nc desthost 9999` |
| Send the backup to another server using a one-liner 使用单行代码将备份发送到另一台服务器 | `ssh user@desthost “( nc -l 9999 > /data/backups/backup.xbstream & )” && xtrabackup --backup --stream | nc desthost 9999` |
| Throttle the throughput to 10MB/sec using the [pipe viewer](https://www.ivarch.com/programs/quickref/pv.shtml) tool 使用 [Pipe Viewer](https://www.ivarch.com/programs/quickref/pv.shtml) 工具将吞吐量限制为 10MB/秒 | `xtrabackup --backup --stream | pv -q -L10m ssh user@desthost “cat - > /data/backups/backup.xbstream”` |
| Checksum the backup during the streaming 在流式处理期间对备份进行校验和 | On the destination host: 在目标主机上： `nc -l 9999 | tee >(sha1sum > destination_checksum) > /data/backups/backup.xbstream`  On the source host: 在源主机上： `xtrabackup --backup --stream | tee >(sha1sum > source_checksum) | nc desthost 9999`  Compare the checksums on the source host: 比较源主机上的校验和： `cat source_checksum 65e4f916a49c1f216e0887ce54cf59bf3934dbad`  Compare the checksums on the destination host: 比较目标主机上的校验和： `cat destination_checksum 65e4f916a49c1f216e0887ce54cf59bf3934dbad` |
| Parallel compression with parallel copying backup 使用并行复制备份进行并行压缩 | `xtrabackup --backup --compress --compress-threads=8 --stream --parallel=4 > backup.xbstream` |

Important 重要

The streamed backup must be prepared before restoration. Streaming mode does not prepare the backup.
在还原之前，必须准备流式备份。流式处理模式不会准备备份。

# 加速备份过程[¶](https://docs.percona.com/percona-xtrabackup/8.4/accelerate-backup-process.html#accelerate-the-backup-process)

## Copy with the `--parallel` and `--compress-threads` options[¶](https://docs.percona.com/percona-xtrabackup/8.4/accelerate-backup-process.html#copy-with-the-parallel-and-compress-threads-options) 使用 `--parallel` 和 `--compress-threads` 选项进行复制[¶](https://docs.percona.com/percona-xtrabackup/8.4/accelerate-backup-process.html#copy-with-the-parallel-and-compress-threads-options)

When making a local or streaming backup with xbstream binary, multiple files can be copied at the same time when using the `--parallel` option. This option specifies the number of threads created by xtrabackup to copy data files.
使用 xbstream 二进制文件进行本地备份或流式备份时，使用 `--parallel` 选项时，可以同时复制多个文件。此选项指定 xtrabackup 为复制数据文件而创建的线程数。

To take advantage of this option either the multiple tablespaces option must be enabled (innodb_file_per_table) or the shared tablespace must be stored in multiple ibdata files with the innodb_data_file_path option. Having multiple files for the database (or splitting one into many) doesn’t have a measurable impact on performance.
要利用此选项，必须启用多个表空间选项（innodb_file_per_table），或者必须使用 innodb_data_file_path 选项将共享表空间存储在多个 ibdata  文件中。为数据库提供多个文件（或将一个文件拆分为多个文件）不会对性能产生可衡量的影响。

As this feature is implemented at the file level, concurrent file transfer can sometimes increase I/O throughput when doing a backup on highly fragmented data files, due to the overlap of a greater number of random read requests. You should consider tuning the filesystem also to obtain the maximum performance (e.g. checking fragmentation).
由于此功能是在文件级别实现的，因此在对高度碎片化的数据文件执行备份时，并发文件传输有时会增加 I/O 吞吐量，因为随机读取请求的重叠数量较多。您还应该考虑调整文件系统以获得最佳性能（例如检查碎片）。

If the data is stored on a single file, this option has no effect.
如果数据存储在单个文件中，则此选项无效。

To use this feature, simply add the option to a local backup, for example:
要使用此功能，只需将选项添加到本地备份中，例如：

```
$ xtrabackup --backup --parallel=4 --target-dir=/path/to/backup
```

By using the xbstream in streaming backups, you can additionally speed up the compression process with the `--compress-threads` option. This option specifies the number of threads created by xtrabackup for for parallel data compression. The default value for this option is 1.
通过在流式备份中使用 xbstream，您还可以使用 `--compress-threads` 选项加快压缩过程。此选项指定 xtrabackup 为并行数据压缩创建的线程数。此选项的默认值为 1。

To use this feature, simply add the option to a local backup, for example:
要使用此功能，只需将选项添加到本地备份中，例如：

```
$ xtrabackup --backup --stream=xbstream --compress --compress-threads=4 --target-dir=./ > backup.xbstream
```

Before applying logs, compressed files will need to be uncompressed.
在应用日志之前，需要解压缩压缩文件。

## The `--rsync` option[¶](https://docs.percona.com/percona-xtrabackup/8.4/accelerate-backup-process.html#the-rsync-option) `--rsync` 选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/accelerate-backup-process.html#the-rsync-option)

In order to speed up the backup process and to minimize the time `FLUSH TABLES WITH READ LOCK` is blocking the writes, the option `--rsync` should be used. When this option is specified, xtrabackup uses `rsync` to copy all non-InnoDB files instead of spawning a separate `cp` for each file, which can be much faster for servers with a large number of databases or tables. xtrabackup will call the `rsync` twice, once before the `FLUSH TABLES WITH READ LOCK` and once during to minimize the time the read lock is being held. During the second `rsync` call, it will only synchronize the changes to non-transactional data (if any) since the first call performed before the `FLUSH TABLES WITH READ LOCK`. Note that Percona XtraBackup will use [Backup locks](https://docs.percona.com/percona-server/innovation-release/backup-locks.html) where available as a lightweight alternative to `FLUSH TABLES WITH READ LOCK`.
为了加快备份过程并最大限度地减少 `FLUSH TABLES WITH READ LOCK` 阻止写入的时间，应使用选项 `--rsync`。指定此选项后，xtrabackup 使用 `rsync` 复制所有非 InnoDB 文件，而不是为每个文件生成单独的 `cp`，这对于具有大量数据库或表的服务器来说可能要快得多。xtrabackup 将调用 `rsync` 两次，一次在 `FLUSH TABLES WITH READ LOCK` 之前，一次在读取锁期间调用，以最小化读取锁的持有时间。在第二次 `rsync` 调用期间，它只会同步自第一次调用在 `FLUSH TABLES WITH READ LOCK` 之前执行以来对非事务数据（如果有）的更改。请注意，Percona XtraBackup 将在可用的情况下使用 [Backup 锁](https://docs.percona.com/percona-server/innovation-release/backup-locks.html)作为 `FLUSH TABLES WITH READ LOCK` 的轻量级替代方案。

Percona XtraBackup uses these locks automatically to copy non-InnoDB data to  avoid blocking Data manipulation language (DML) queries that modify  InnoDB tables.
Percona XtraBackup 会自动使用这些锁来复制非 InnoDB 数据，以避免阻塞修改 InnoDB 表的数据操作语言 （DML） 查询。

Note 注意

This option cannot be used together with the `--stream` option.
此选项不能与 `--stream` 选项一起使用。

# 加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#encrypt-backups)

# Encrypt backups[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#encrypt-backups_1) 加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#encrypt-backups_1)

Percona XtraBackup supports encrypting and decrypting local and streaming  backups with the upstream option, adding another protection layer. The encryption is implemented using the `libgcrypt` library from GnuPG.
Percona XtraBackup 支持使用 upstream 选项加密和解密本地和流式备份，增加了另一个保护层。加密是使用 GnuPG 的 `libgcrypt` 库实现的。

## Create encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#create-encrypted-backups) 创建加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#create-encrypted-backups)

The following options create encrypted backups. The `--encrypt-key` and `--encrypt-key-file` options specify the encryption key and are mutually exclusive. You should select one or the other.
以下选项将创建加密备份。`--encrypt-key` 和 `--encrypt-key-file` 选项指定加密密钥，并且是互斥的。您应该选择一个或另一个。

- `--encrypt` `--加密`
- `--encrypt-key` `--加密密钥`
- `--encrypt-key-file`
  `--加密密钥文件`

For an encryption key, use a command, such as `openssl rand -base64 24`, to generate a random alphanumeric string.
对于加密密钥，请使用命令（例如 `openssl rand -base64 24`）生成随机字母数字字符串。

### The `--encrypt-key` option[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#the-encrypt-key-option) `--encrypt-key` 选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#the-encrypt-key-option)

An example of the *xtrabackup* command using the `--encrypt-key`:
使用 `--encrypt-key` 的 *xtrabackup* 命令示例：

```
$  xtrabackup --backup --encrypt=AES256 --encrypt-key="{randomly-generated-alphanumeric-string}" --target-dir=/data/backup
```

### The `--encrypt-key-file` option[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#the-encrypt-key-file-option) `--encrypt-key-file` 选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#the-encrypt-key-file-option)

The recommended method uses the command line: `echo -n “{randomly-generated-alphanumeric-string}” > /data/backups/keyfile` to create the file. Remember that using the– encrypt-key-file option, your text editor can  automatically insert a CRLF (end of line) character in the `KEYFILE`. This inserted character invalidates the key because the size is wrong. 
推荐的方法使用命令行： `echo -n “{randomly-generated-alphanumeric-string}” > /data/backups/keyfile` 创建文件。请记住，使用 – encrypt-key-file 选项，您的文本编辑器可以在 `KEYFILE` 中自动插入 CRLF（行尾）字符。此插入的字符会使密钥失效，因为大小错误。

An example of using the `--encrypt-key-file` option:
使用 `--encrypt-key-file` 选项的示例：

```
$ xtrabackup --backup --encrypt=AES256 --encrypt-key-file=/data/backups/keyfile --target-dir=/data/backup
```

## Optimize the encryption process[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#optimize-the-encryption-process) 优化加密过程[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#optimize-the-encryption-process)

Additional encrypted backup options, `--encrypt-threads` and `--encrypt-chunk-size`, can speed up the encryption process. 
其他加密备份选项 `--encrypt-threads` 和 `--encrypt-chunk-size` 可以加快加密过程。

Use the `--encrypt-threads` option to enable parallel encryption with multiple threads. 
使用 `--encrypt-threads` 选项启用多线程并行加密。

The `--encrypt-chunk-size` option specifies the size, in bytes, of the working encryption buffer for each encryption thread. The default size is 64K.
`--encrypt-chunk-size` 选项指定每个加密线程的工作加密缓冲区的大小（以字节为单位）。默认大小为 64K。

## Decrypt encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#decrypt-encrypted-backups) 解密加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#decrypt-encrypted-backups)

You can decrypt backups with the `xbcrypt` binary. The following example encrypts a backup.
您可以使用 `xbcrypt` 二进制文件解密备份。以下示例对备份进行加密。

You can use the `--parallel` option and the `--decrypt` option to decrypt multiple files simultaneously.
您可以使用 `--parallel` 选项和 `--decrypt` 选项同时解密多个文件。

```
$ for i in `find . -iname "*\.xbcrypt"`; do xbcrypt -d --encrypt-key-file=/root/secret_key --encrypt-algo=AES256 < $i > $(dirname $i)/$(basename $i .xbcrypt) && rm $i; done
```

The following example shows a decryption process.
以下示例显示了解密过程。

```
$ xtrabackup --decrypt=AES256 --encrypt-key="{randomly-generated-alphanumeric-string}" --target-dir=/data/backup/
```

Percona XtraBackup doesn’t automatically remove the encrypted files. You must remove the `\*.xbcrypt` files manually.
Percona XtraBackup 不会自动删除加密文件。您必须手动删除 `\*.xbcrypt` 文件。

## Prepare encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#prepare-encrypted-backups) 准备加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#prepare-encrypted-backups)

After decrypting the backups, prepare the backups with the `--prepare` option:
解密备份后，使用 `--prepare` 选项准备备份：

```
$ xtrabackup --prepare --target-dir=/data/backup/
```

## Restore encrypted backups[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#restore-encrypted-backups) 恢复加密备份[¶](https://docs.percona.com/percona-xtrabackup/8.4/encrypt-backups.html#restore-encrypted-backups)

*xtrabackup* offers the `--copy-back` option to restore a backup to the server’s datadir:
*xtrabackup* 提供了 `--copy-back` 选项来将备份恢复到服务器的 datadir：

```
$ xtrabackup --copy-back --target-dir=/data/backup/
```

The option copies all the data-related files to the server’s datadir. The server’s `my.cnf` configuration file determines the location. 
该选项将所有与数据相关的文件复制到服务器的 datadir 中。服务器的 `my.cnf` 配置文件确定位置。

You should check the last line of the output for a success message:
您应检查输出的最后一行是否有成功消息：

<details class="example" data-immersive-translate-walked="70caeff7-23b8-4721-9a0d-a768c934b8b2"><summary data-immersive-translate-walked="70caeff7-23b8-4721-9a0d-a768c934b8b2" data-immersive-translate-paragraph="1">Expected output<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><font class="notranslate" data-immersive-translate-translation-element-mark="1">&nbsp;</font><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-inline-wrapper-theme-none immersive-translate-target-translation-inline-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">预期输出</font></font></font></summary></details>