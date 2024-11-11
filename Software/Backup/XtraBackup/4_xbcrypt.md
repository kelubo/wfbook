# xbcrypt

To support encryption and decryption of the backups, a new tool `xbcrypt` was introduced to *Percona XtraBackup*.
为了支持备份的加密和解密，*Percona XtraBackup* 引入了一个新工具 `xbcrypt`。

This utility has been modeled after The [xbstream binary](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-binary-overview.html) to perform encryption and decryption outside of Percona XtraBackup.
此实用程序以 [xbstream 二进制文件](https://docs.percona.com/percona-xtrabackup/8.4/xbstream-binary-overview.html)为模型，用于在 Percona XtraBackup 之外执行加密和解密。

The `XBCRYPT_ENCRYPTION_KEY` environment variable is only used in place of the `--encrypt_key=name` option. You can use the environment variable or command line option. If you use both, the command line option takes precedence over the value  specified in the environment variable.
`XBCRYPT_ENCRYPTION_KEY` 环境变量仅用于代替 `--encrypt_key=name` 选项。您可以使用环境变量或命令行选项。如果同时使用两者，则命令行选项优先于环境变量中指定的值。

# xbcrypt 命令行选项[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#the-xbcrypt-command-line-options)

Usage:  用法：

```
$ xbcrypt[OPTIONS]
```

The `xbcrypt` binary has the following command line options:
`xbcrypt` 二进制文件具有以下命令行选项：

### decrypt[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#decrypt) 解密[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#decrypt)

usage: `-d`  `--decrypt`
用法： `-d``--decrypt`

Decrypt data input to output.
解密数据输入到输出。

### encrypt-algo[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-algo) 加密算法[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-algo)

usage: `-a=name` `--encrypt-algo=name`
用法：`-a=name``--encrypt-algo=name`

Defines the name of the encryption algorithm.
定义加密算法的名称。

### encrypt-chunk-size[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-chunk-size) 加密块大小[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-chunk-size)

usage: `-s=#` `--encrypt-chunk-size=#`
用法： `-s=#``--encrypt-chunk-size=#`

Defines the size of the working buffer for encryption in bytes. The default value is `64000`.
定义用于加密的工作缓冲区的大小（以字节为单位）。默认值为 `64000`。

### encrypt-key[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-key) 加密密钥[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-key)

usage: `-k=name` `--encrypt-key=name`
用法：`-k=name``--encrypt-key=name`

The name of the encryption key.
加密密钥的名称。

### encrypt-key-file[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-key-file) 加密密钥文件[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-key-file)

usage: `-f=name` `--encrypt-key-file=name`
用法：`-f=name``--encrypt-key-file=name`

The name of the file that contains the encryption key.
包含加密密钥的文件的名称。

### encrypt-threads[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-threads) 加密线程[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#encrypt-threads)

usage: `--encrypt-threads=#`
用法：`--encrypt-threads=#`

This option specifies the number of worker threads used for parallel encryption/decryption. The default value is 1.
此选项指定用于并行加密/解密的工作线程数。默认值为 1。

### input[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#input) 输入[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#input)

usage: `-i=name` `--input=name`
用法：`-i=name``--input=name`

Defines the name of the optional input file. If the name is not specified, the input reads from the standard input.
定义可选输入文件的名称。如果未指定名称，则 input 将从标准输入中读取。

### output[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#output) 输出[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#output)

usage: `-o=name` `--output=name`
用法：`-o=name``--output=name`

Defines the name of the optional output file. If this name is not specified, the output is written to the standard output.
定义可选输出文件的名称。如果未指定此名称，则输出将写入标准输出。

### read-buffer-size[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#read-buffer-size) 读取缓冲区大小[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#read-buffer-size)

usage: `--read-buffer-size=#`
用法： `--read-buffer-size=#`

Read the buffer size. The default value is 10MB. 
读取缓冲区大小。默认值为 10MB。

### verbose[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#verbose) 详细[¶](https://docs.percona.com/percona-xtrabackup/8.4/xbcrypt-options.html#verbose)

usage: `-v` `--verbose`
用法： `-v``--verbose`

Display status in verbose mode.
以详细模式显示状态。