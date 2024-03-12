# CLI

[TOC]

## keystone-manage

Keystone 管理实用程序
`keystone-manage` 是命令行工具，它与 Keystone 服务交互以初始化和更新 Keystone 中的数据。通常， `keystone-manage` 仅用于无法通过HTTP API完成的操作，例如数据导入/导出和数据库迁移。

- Author: 作者：[openstack@lists.openstack.org](mailto:openstack@lists.openstack.org)

- Date: 日期：2017-02-23

- Copyright: 版权：OpenStack Foundation OpenStack 基金会

- Version: 版本：11.0.0

- Manual section: 手册部分：1

- Manual group: 手册组：cloud computing


```bash
keystone-manage [options] action [additional args]
```

调用 `keystone-manage` 本身将为您提供一些使用信息。

### 可用命令

- `bootstrap`: 执行基本的引导过程。
- `create_jws_keypair`: Create an ECDSA key pair for JWS token signing.创建用于 JWS 令牌签名的 ECDSA 密钥对。
- `credential_migrate`: Encrypt credentials using a new primary key.使用新的主密钥加密凭据。
- `credential_rotate`: Rotate Fernet keys for credential encryption.轮换 Fernet 密钥以进行凭据加密。
- `credential_setup`: Setup a Fernet key repository for credential encryption.设置用于凭据加密的 Fernet 密钥存储库。
- `db_sync`: 同步数据库。
- `db_version`: Print the current migration version of the database.打印数据库的当前迁移版本。
- `doctor`: Diagnose common problems with keystone deployments.诊断梯形失调部署的常见问题。
- `domain_config_upload`: 上传域配置文件。
- `fernet_rotate`: Rotate keys in the Fernet key repository.轮换 Fernet 密钥存储库中的密钥。
- `fernet_setup`: Setup a Fernet key repository for token encryption.设置用于令牌加密的 Fernet 密钥存储库。
- `mapping_populate`: Prepare domain-specific LDAP backend.准备特定于域的 LDAP 后端。
- `mapping_purge`: Purge the identity mapping table.清除身份映射表。
- `mapping_engine`: Test your federation mapping rules.测试联合映射规则。
- `receipt_rotate`: Rotate auth receipts encryption keys.轮换身份验证回执加密密钥。
- `receipt_setup`: Setup a key repository for auth receipts.为身份验证回执设置密钥存储库。
- `saml_idp_metadata`: Generate identity provider metadata.生成身份提供程序元数据。
- `token_rotate`: Rotate token keys in the key repository.轮换密钥存储库中的令牌密钥。
- `token_setup`: Setup a token key repository for token encryption.设置令牌密钥存储库以进行令牌加密。
- `trust_flush`: Purge expired trusts.清除过期的信任。

### 选项

- -h, --help

  显示此帮助消息并退出。

- --config-dir DIR

  Path to a config directory to pull *.conf files from. This file set is sorted, so as to provide a predictable parse order if individual options are over-ridden. The set is parsed after the file(s) specified via previous –config-file, arguments hence over-ridden options in the directory take precedence. 要从中提取 *.conf 文件的配置目录的路径。此文件集将进行排序，以便在覆盖单个选项时提供可预测的分析顺序。该集合在通过上一个 –config-file 指定的文件之后解析，因此参数优先于目录中被覆盖的选项。

- --config-file PATH

  Multiple config files can be specified, with values in later files taking precedence.要使用的配置文件的路径。可以指定多个配置文件，以后文件中的值优先。默认值为 None。

- --debug, -d

  如果设置为 true，则日志记录级别将设置为 DEBUG，而不是默认的 INFO 级别。

- --log-config-append PATH, --log_config PATH

  The name of a logging configuration file. This file is appended to any existing logging configuration files. For details about logging configuration files, see the Python logging module documentation. Note that when logging configuration files are used then all logging configuration is set in the configuration file and other logging configuration options are ignored (for example, logging_context_format_string). 日志记录配置文件的名称。此文件将追加到任何现有的日志记录配置文件中。有关日志记录配置文件的详细信息，请参阅 Python  日志记录模块文档。请注意，使用日志记录配置文件时，将在配置文件中设置所有日志记录配置，并忽略其他日志记录配置选项（例如，logging_context_format_string）。

- --log-date-format DATE_FORMAT

  Defines the format string for %(asctime)s in log records.定义日志记录中 %（asctime）s 的格式字符串。默认值：None 。如果设置了 log_config_append 则忽略此选项。

- --log-dir LOG_DIR, --logdir LOG_DIR

  (Optional) The base directory used for relative log_file paths.（可选）用于相对log_file路径的基目录。如果设置了 log_config_append 则忽略此选项。

- --log-file PATH, --logfile PATH

  (Optional) Name of log file to send logging output to. If no default is set, logging will go to stderr as defined by use_stderr. This option is ignored if log_config_append is set. （可选）要将日志记录输出发送到的日志文件的名称。如果未设置默认值，则日志记录将转到 use_stderr 定义的 stderr。如果设置了此选项log_config_append则忽略此选项。

- --nodebug

  The inverse of –debug –debug 的反函数

- --nostandard-threads

  The inverse of –standard-threads –standard-threads 的反向

- --nouse-syslog

  The inverse of –use-syslog –use-syslog 的反面

- --noverbose

  The inverse of –verbose –verbose 的反面

- --nowatch-log-file

  The inverse of –watch-log-file –watch-log-file 的反面

- --pydev-debug-host PYDEV_DEBUG_HOST

  Host to connect to for remote debugger. 要连接到的主机用于远程调试器。

- --pydev-debug-port PYDEV_DEBUG_PORT

  Port to connect to for remote debugger. 远程调试器要连接到的端口。

- --standard-threads

  Do not monkey-patch threading system modules. 不要对线程系统模块进行猴子修补。

- --syslog-log-facility SYSLOG_LOG_FACILITY

  Syslog facility to receive log lines. This option is ignored if log_config_append is set. 用于接收日志行的 Syslog 工具。如果设置了此选项log_config_append则忽略此选项。

- --use-syslog

  使用 syslog 进行日志记录。现有的 syslog 格式已弃用，稍后将进行更改以遵守 RFC5424 。如果设置了 log_config_append 则忽略此选项。

- --verbose, -v

  如果设置为 false，则日志记录级别将设置为 WARNING，而不是默认的 INFO 级别。

- --version

  显示程序的版本号并退出

- --watch-log-file

  Uses logging handler designed to watch file system. When log file is moved or removed this handler will open a new log file with specified path instantaneously.使用旨在监视文件系统的日志记录处理程序。移动或删除日志文件时，此处理程序将立即打开具有指定路径的新日志文件。仅当指定 log_file 选项并使用 Linux 平台时才有意义。如果设置了 log_config_append 则忽略此选项。

## keystone-status

Keystone 状态实用程序，是一个命令行工具，可帮助操作员升级其部署。

- Author: 作者：[openstack@lists.openstack.org](mailto:openstack@lists.openstack.org)

- Date: 日期：2018-10-15

- Copyright: 版权：OpenStack Foundation OpenStack 基金会

- Version: 版本：15.0.0

- Manual section: 手册部分：1

- Manual group: 手册组：cloud computing


```bash
keystone-status [options] action [additional args]
```

### Categories and commands 类别和命令

You can also run with a category argument such as `upgrade` to see a list of all commands in that category:
还可以使用 category 参数运行，例如 `upgrade` 查看该类别中所有命令的列表：

```bash
keystone-status upgrade
```

Categories are: 类别包括：

- `upgrade`

- `upgrade check`

  在使用新代码重新启动服务或升级之前，执行特定于版本的就绪情况检查。此命令需要具有完整的配置和对数据库的访问权限。
  
  **Return Codes 返回代码**
  
  | Return code 返回代码 | 描述                                                         |
  | -------------------- | ------------------------------------------------------------ |
  | 0                    | All upgrade readiness checks passed successfully and there is nothing to do. 所有升级准备情况检查都已成功通过，无需执行任何操作。 |
  | 1                    | At least one check encountered an issue and requires further investigation. This is considered a warning but the upgrade may be OK. 至少有一项检查遇到了问题，需要进一步调查。这被视为警告，但升级可能正常。 |
  | 2                    | There was an upgrade status check failure that needs to be investigated. This should be considered something that stops an upgrade. 存在需要调查的升级状态检查失败。这应该被视为停止升级的事情。 |
  | 255                  | An unexpected error occurred. 发生意外错误。                 |
  
  **History of Checks 检查历史**
  
  **15.0.0 (Stein)**
  
  * Placeholder to be filled in with checks as they are added in Stein. 在 Stein 中添加支票时要填写的占位符。

### 选项

* -h, --help

  显示此帮助消息并退出。

* --config-dir DIR

  Path to a config directory to pull \*.conf files from.This file set is sorted, so as to provide apredictable parse order if individual options are
  over-ridden. The set is parsed after the file(s)specified via previous --config-file, arguments hence over-ridden options in the directory take precedence.要从中提取\*.conf文件的配置目录的路径。对该文件集进行排序，以便提供可预测的分析顺序，如果各个选项被覆盖了在文件之后分析集合    通过previous --number-file指定，参数因此目录中被覆盖的选项优先。

* --config-file PATH

  Multiple config files can be specified, with values in later files taking precedence. 要使用的配置文件的路径。可以指定多个配置文件
      ，后面的文件中的值采用    优先级。默认为 None 。
