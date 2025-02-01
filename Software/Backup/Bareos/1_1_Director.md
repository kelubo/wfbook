# Director 配置

在运行 Bareos 所需的所有配置文件中，Director 的配置文件是最复杂的，也是在添加客户端或修改文件集时最需要修改的配置文件。

Everything revolves around a job and is tied to a job in one way or another.一切都围绕着一份 job ，并以这样或那样的方式与 job 联系在一起。

Bareos Director 了解以下资源类型：

- Director 资源 - 定义用于验证 Console 程序的 Director 名称及其访问密码。Director 的配置文件中只能显示一个 Director 资源定义。
- 作业资源 - 定义备份/恢复作业，并将每个作业要使用的客户端、文件集和计划资源绑定在一起。通常情况下，you  will Jobs of different names corresponding to each client (i.e. one Job  per client, but a different one with a different name for each client).每个客户端对应不同名称的作业（即每个客户端一个作业，但每个客户端有不同名称的不同作业）。
- JobDefs 资源 - 可选资源，用于提供作业资源的默认值。
- 调度资源 - 定义作业必须运行的时间。可以有任意数量的计划，但每个作业只能引用一个计划。
- 文件集资源 - 定义要为每个客户端备份的文件集。可以有任意数量的文件集，但每个作业将仅引用一个。
- 客户端资源 - 定义要备份的客户端。通常会有多个客户端定义。每个 Job 将仅引用单个客户端。
- 存储资源 - to define on what physical device the Volumes should be mounted定义应在哪个物理设备上装载卷。可以有一个或多个存储定义。
- 池资源 - 定义可用于特定作业的卷池。大多数人使用单个默认池。但是，如果您有大量的客户端或卷，则可能需要多个池。允许您将作业（或客户端）限制为仅使用一组特定的卷。
- 目录资源 - 定义在哪个数据库中保存文件列表和备份它们的卷名。大多数人只使用一个目录。可以使用多个目录，但不建议也不支持。
- 消息资源 - 定义发送或记录错误和信息消息的位置。可以定义多个不同的消息资源，从而将特定类别的消息定向到不同的用户或位置（文件等）。

## Director 资源

Director 资源定义在网络上运行的 Directors 的属性。只允许一个 Director 资源。

以下是有效 Director 资源定义的示例：

```bash
Director {
  Name = bareos-dir
  Password = secretpassword
  QueryFile = "/etc/bareos/query.sql"
  Maximum Concurrent Jobs = 10
  Messages = Daemon
}
```

| 配置指令名                                                   | type of data                                                 | default value                         | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------- | ------------ |
| `Absolute Job Timeout (Dir->Director)`                       | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                       |              |
| `Audit Events (Dir->Director)`                               | =`AUDIT_COMMAND_LIST`                                        |                                       |              |
| [`Auditing (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Auditing) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Description (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Description) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`Dir Address (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddress) | = [`ADDRESS`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-address) | 9101                                  |              |
| [`Dir Addresses (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddresses) | = [`ADDRESSES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-addresses) | 9101                                  |              |
| [`Dir Port (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirPort) | = [`PORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-port) | 9101                                  |              |
| [`Dir Source Address (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirSourceAddress) | = [`ADDRESS`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-address) | 0                                     |              |
| [`Enable kTLS (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`FD Connect Timeout (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_FdConnectTimeout) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 180                                   |              |
| [`Heartbeat Interval (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0                                     |              |
| [`Key Encryption Key (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_KeyEncryptionKey) | = [`AUTOPASSWORD`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |                                       |              |
| [`Log Timestamp Format (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_LogTimestampFormat) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) | %d-%b %H:%M                           |              |
| [`Maximum Concurrent Jobs (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1                                     |              |
| [`Maximum Console Connections (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_MaximumConsoleConnections) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 20                                    |              |
| [`Messages (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Messages) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |                                       |              |
| [`Name (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Name) | = [`NAME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-name) |                                       | **required** |
| [`NDMP Log Level (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpLogLevel) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 4                                     |              |
| [`NDMP Namelist Fhinfo Set Zero For Invalid Uquad (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpNamelistFhinfoSetZeroForInvalidUquad) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`NDMP Snooping (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpSnooping) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |                                       |              |
| [`Password (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |                                       | **required** |
| [`Plugin Directory (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_PluginDirectory) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`Plugin Names (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_PluginNames) | = [`PLUGIN_NAMES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names) |                                       |              |
| [`Query File (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_QueryFile) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       | **required** |
| [`Scripts Directory (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_ScriptsDirectory) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`SD Connect Timeout (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_SdConnectTimeout) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800                                  |              |
| [`Secure Erase Command (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_SecureEraseCommand) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`Statistics Collect Interval (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_StatisticsCollectInterval) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | *0*                                   | *deprecated* |
| [`Statistics Retention (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_StatisticsRetention) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | *160704000*                           | *deprecated* |
| [`Subscriptions (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Subscriptions) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 0                                     |              |
| [`TLS Allowed CN (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |                                       |              |
| [`TLS Authenticate (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`TLS CA Certificate Dir (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS CA Certificate File (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Certificate (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Certificate Revocation List (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Cipher List (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Cipher Suites (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS DH File (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Enable (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                   |              |
| [`TLS Key (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Protocol (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsProtocol) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`TLS Require (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                   |              |
| [`TLS Verify Peer (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Ver Id (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_VerId) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`Working Directory (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_WorkingDirectory) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) | /var/lib/bareos *(platform specific)* |              |

- `Absolute Job Timeout`

  Type:PINT32

  Since Version:14.2.0

  无论作业进度如何，作业终止的绝对时间。

- `Audit Events`

  Type:AUDIT_COMMAND_LIST

  Since Version:14.2.0

  指定要审核的命令。如果未指定任何内容（并且启用了 `Auditing (Dir->Director)` ），则将审核所有命令。

- `Auditing`

  Type:BOOLEAN

  Default value:no

  Since Version:14.2.0

  此指令允许启用或禁用与 Bareos Director 交互的审计。如果启用，将生成审核消息。在 `Messages (Dir->Director)` 中配置的 messages 资源定义了如何处理这些消息。

- `Description`

  Type:STRING

  文本字段包含将在图形用户界面中显示的 Director 的说明。此指令是可选的。

- `Dir Address`

  Type:ADDRESS

  Default value:9101

  此指令是可选的，但如果指定了它，它将导致 Director 服务器（用于 Console 程序）绑定到指定的地址。如果未指定此指令和 `Dir Addresses (Dir->Director)` 指令，则 Director 将绑定到 IPv6 和 IPv4 默认地址（默认值）。

- `Dir Addresses`

  Type: [`ADDRESSES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-addresses) Default value: 9101  Specify the ports and addresses on which the Director daemon will listen for Bareos Console connections. Please note that if you use the [`Dir Addresses (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddresses) directive, you must not use either a [`Dir Port (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirPort) or a [`Dir Address (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddress) directive in the same resource.

- Dir Port[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirPort)

  Type: [`PORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-port) Default value: 9101  Specify the port on which the Director daemon will listen for Bareos  Console connections. This same port number must be specified in the  Director resource of the Console configuration file. This directive  should not be used if you specify [`Dir Addresses (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddresses) (N.B plural) directive. By default, the Director will listen to both IPv6 and IPv4 default  addresses on the port you set. If you want to listen on either IPv4 or  IPv6 only, you have to specify it with either [`Dir Address (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddress), or remove [`Dir Port (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirPort)and just use [`Dir Addresses (Dir->Director)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirAddresses)instead.

- Dir Source Address[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_DirSourceAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 0  This record is optional, and if it is specified, it will cause the  Director server (when initiating connections to a storage or file  daemon) to source its connections from the specified address. Only a  single IP address may be specified. If this record is not specified, the Director server will source its outgoing connections according to the  system routing table (the default).

- Enable kTLS[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- FD Connect Timeout[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_FdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 180  where **time** is the time that the Director should  continue attempting to contact the File daemon to start a job, and after which the Director will cancel the job.

- Heartbeat Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets used by the Bareos Director. See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/master/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- Key Encryption Key[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_KeyEncryptionKey)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  This key is used to encrypt the Security Key that is exchanged  between the Director and the Storage Daemon for supporting Application  Managed Encryption (AME). For security reasons each Director should have a different Key Encryption Key.

- Log Timestamp Format[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_LogTimestampFormat)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) Default value: %d-%b %H:%M Since Version: 15.2.3  This parameter needs to be a valid strftime format string. See **man 3 strftime** for the full list of available substitution variables.

- `Maximum Concurrent Jobs`

  Type: PINT32

  Default value: 1

  此指令指定应并发运行的最大控制器 Director 总数。

- `Maximum Console Connections`

  Type:PINT32

  Default value: 20

  This directive specifies the maximum number of Console Connections that could run concurrently.此指令指定可以同时运行的控制台连接的最大数量。

- Messages[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Messages)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The messages resource specifies where to deliver Director messages  that are not associated with a specific Job. Most messages are specific  to a job and will be directed to the Messages resource specified by the  job. However, there are a messages that can occur when no job is  running.

- `Name`

  Required: True

  Type: NAME

  资源的名称。系统管理员使用的 director 名称。

- NDMP Log Level[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpLogLevel)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 4 Since Version: 13.2.0  This directive sets the loglevel for the NDMP protocol library.

- NDMP Namelist Fhinfo Set Zero For Invalid Uquad[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpNamelistFhinfoSetZeroForInvalidUquad)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 20.0.6  This directive enables a bug workaround for Isilon 9.1.0.0 systems  where the NDMP namelists tape offset (also known as fhinfo) is sanity  checked resulting in valid value -1 being no more accepted. The Isilon  system sends the following error message: ‘Invalid nlist.tape_offset -1  at index 1 - tape offset not aligned at 512B boundary’. The workaround  sends 0 instead of -1 which is accepted by the Isilon system and enables normal operation again.

- NDMP Snooping[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_NdmpSnooping)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Since Version: 13.2.0  This directive enables the Snooping and pretty printing of NDMP protocol information in debugging mode.

- `Password`

  Required: True

  Type: AUTOPASSWORD

  Specifies the password that must be supplied for the default Bareos Console to be authorized. This password correspond to [`Password (Console->Director)`](https://docs.bareos.org/master/Configuration/Console.html#config-Console_Director_Password) of the Console configuration file. 指定必须为默认 Bareos 控制台提供的密码才能进行授权。此密码对应于控制台配置文件的密码（控制台->Director）。

  密码为纯文本。

- Plugin Directory[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_PluginDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) Since Version: 14.2.0  Plugins are loaded from this directory. To load only specific plugins, use ‘Plugin Names’.

- Plugin Names[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_PluginNames)

  Type: [`PLUGIN_NAMES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names) Since Version: 14.2.0  List of plugins, that should get loaded from ‘Plugin Directory’ (only basenames, ‘-dir.so’ is added automatically). If empty, all plugins  will get loaded.

- `Query File`

  Required: True

  Type: `DIRECTORY`

  specifies a directory and file in which the Director can find the canned SQL statements for the [query](https://docs.bareos.org/master/TasksAndConcepts/BareosConsole.html#section-bcommandquery) command.此指令是必需的，它指定 Director 可以在其中找到查询命令的固定 SQL 语句的目录和文件。

- Scripts Directory[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_ScriptsDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  This directive is currently unused.

- SD Connect Timeout[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_SdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800  where **time** is the time that the Director should  continue attempting to contact the Storage daemon to start a job, and  after which the Director will cancel the job.

- Secure Erase Command[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_SecureEraseCommand)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 15.2.1  Specify command that will be called when bareos unlinks files. When files are no longer needed, Bareos will delete (unlink) them.  With this directive, it will call the specified command to delete these  files. See [Secure Erase Command](https://docs.bareos.org/master/TasksAndConcepts/BareosSecurityIssues.html#section-secureerasecommand) for details.

- Statistics Collect Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_StatisticsCollectInterval)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0 Since Version: deprecated  Bareos offers the possibility to collect statistic information from its connected devices. To do so, [`Collect Statistics (Dir->Storage)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Storage_CollectStatistics) must be enabled. This interval defines, how often the Director connects to the attached Storage Daemons to collect the statistic information.

- Statistics Retention[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_StatisticsRetention)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 160704000 Since Version: deprecated  The **Statistics Retention** directive defines the  length of time that Bareos will keep statistics job records in the  Catalog database after the Job End time (in the catalog **JobHisto** table). When this time period expires, and if user runs **prune stats** command, Bareos will prune (remove) Job records that are older than the specified period. Theses statistics records aren’t use for restore purpose, but mainly for capacity planning, billings, etc. See chapter [Job Statistics](https://docs.bareos.org/master/TasksAndConcepts/CatalogMaintenance.html#section-jobstatistics) for additional information.

- Subscriptions[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_Subscriptions)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0 Since Version: 12.4.4  In case you want check that the number of active clients don’t exceed a specific number, you can define this number here and check with the **status subscriptions** command. However, this is only intended to give a hint. No active limiting is implemented.

- TLS Allowed CN[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/master/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see, how the Bareos Director (and the other components) must be configured to use TLS.

- TLS Key[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Director_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- `Ver Id`

  Type: STRING

  where **string** is an identifier which can be used for support purpose. 其中字符串是可用于支持目的的标识符。此字符串使用 **version** 命令显示。

- `Working Directory`

  Type: DIRECTORY 

  Default value: /var/lib/bareos *(platform specific)*

  此指令是可选的，它指定 Director 可以将其状态文件放入的目录。这个目录只能由 Bareos 使用，但可以由其他 Bareos 守护进程共享。Standard shell  expansion of the directory is done when the configuration file is read  so that values such as `$HOME` will be properly expanded. 当读取配置文件时，会对目录进行标准的shell扩展，这样，将适当扩大。

  指定的工作目录必须已经存在，并且可以被引用它的 Bareos 守护进程读写。

## Job 资源

job 资源定义 Bareos 必须执行的作业（备份、还原等）。每个作业资源定义都包含要备份的客户端和文件集的名称、作业的计划、数据的存储位置以及可以使用的介质池。实际上，each Job resource must specify What, Where, How, and When or FileSet,  Storage, Backup/Restore/Level, and Schedule respectively每个作业资源都必须分别指定“内容”、“位置”、“方式”和“时间”，或者分别指定“文件集”、“存储”、“备份/还原/级别”和“计划”。请注意，由于历史原因，必须为还原作业指定 FileSet ，但它已不再使用。

只能为任何作业指定一种类型（备份、还原等）。如果要在同一客户端或多个客户端上备份多个文件集，则必须为每个文件集定义一个作业。

you define only a single Job to do the Full, Differential, and  Incremental backups since the different backup levels are tied together  by a unique Job name. Normally, you will have only one Job per Client,  but if a client has a really huge number of files (more than several  million), you might want to split it into several Jobs each with a  different FileSet covering only parts of the total files.

请注意，由于不同的备份级别由唯一的作业名称绑定在一起，因此您只需定义一个作业来执行完整、差异和增量备份。通常情况下，每个客户端只有一个Job，但如果客户端有大量的文件（超过几百万），您可能希望将其拆分为多个Job，每个Job都有不同的文件集，仅覆盖全部文件的一部分。

Multiple Storage daemons are not currently supported for Jobs, if you do want to use multiple storage daemons, you will need to create a  different Job and ensure the combination of Client and FileSet is  unique.

作业当前不支持多个存储守护程序，如果您确实希望使用多个存储守护程序，则需要创建不同的作业，并确保Client和FileSet的组合是唯一的。

> Warning
>
> Bareos uses only [`Client (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Client) and `Fileset (Dir->Job)` to determine which jobids belong together. If job A and B have the same client and fileset defined, the resulting jobids will be intermixed as follows:
>
> 1. When a job determines its predecessor to determine its required  level and since-time, it will consider all jobs with the same client and fileset.
> 2. When restoring a client you select the fileset and all jobs that used that fileset will be considered.
>
> As a matter of fact, if you want separate backups, you  have to duplicate your filesets with a different name and the same  content.
>
> Bareos仅使用Client（Dir->Job）和File Set（Dir->Job）来确定哪些jobid属于一起。如果作业A和B定义了相同的客户端和文件集，则生成的作业ID将混合如下：
>
>     当一个作业确定其前置作业以确定其所需的级别和自那时起，它将考虑具有相同客户端和文件集的所有作业。
>                                                                                 
>     当还原客户端时，选择文件集，使用该文件集的所有作业都将被考虑。
>
> 事实上，如果您想要单独的备份，您必须用不同的名称和相同的内容复制您的文件集。

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Accurate (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Accurate) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Add Prefix (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AddPrefix) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Add Suffix (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AddSuffix) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Allow Duplicate Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowDuplicateJobs) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Allow Higher Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowHigherDuplicates) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Allow Mixed Priority (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowMixedPriority) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Always Incremental (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncremental) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Always Incremental Job Retention (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalJobRetention) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Always Incremental Keep Number (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalKeepNumber) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 0             |              |
| [`Always Incremental Max Full Age (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalMaxFullAge) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Backup Format (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_BackupFormat) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) | Native        |              |
| [`Base (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Base) | = [`RESOURCE_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               | *deprecated* |
| [`Bootstrap (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Bootstrap) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`Cancel Lower Level Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelLowerLevelDuplicates) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Cancel Queued Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelQueuedDuplicates) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Cancel Running Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelRunningDuplicates) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Catalog (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Catalog) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Client (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Client) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Client Run After Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunAfterJob) | = [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short) |               |              |
| [`Client Run Before Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunBeforeJob) | = [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short) |               |              |
| [`Description (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Description) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Differential Backup Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_DifferentialBackupPool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Differential Max Runtime (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_DifferentialMaxRuntime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Dir Plugin Options (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_DirPluginOptions) | = [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`Enabled (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Enabled) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`FD Plugin Options (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FdPluginOptions) | = [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`File History Size (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FileHistorySize) | = [`SIZE64`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-size64) | 10000000      |              |
| [`File Set (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FileSet) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Full Backup Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FullBackupPool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Full Max Runtime (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FullMaxRuntime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Incremental Backup Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_IncrementalBackupPool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Incremental Max Runtime (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_IncrementalMaxRuntime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Job Defs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_JobDefs) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Job To Verify (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_JobToVerify) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Level (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Level) | = [`BACKUP_LEVEL`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-backup_level) |               |              |
| [`Max Concurrent Copies (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxConcurrentCopies) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 100           |              |
| [`Max Diff Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxDiffInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Full Consolidations (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxFullConsolidations) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 0             |              |
| [`Max Full Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxFullInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Run Sched Time (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxRunSchedTime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Run Time (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxRunTime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Start Delay (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxStartDelay) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Virtual Full Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxVirtualFullInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Max Wait Time (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxWaitTime) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Maximum Bandwidth (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaximumBandwidth) | = [`SPEED`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-speed) |               |              |
| [`Maximum Concurrent Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Messages (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Messages) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               | **required** |
| [`Name (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Name) | = [`NAME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Next Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_NextPool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               | **required** |
| [`Prefer Mounted Volumes (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PreferMountedVolumes) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Prefix Links (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PrefixLinks) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Priority (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Priority) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 10            |              |
| [`Protocol (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Protocol) | = [`PROTOCOL_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-protocol_type) | Native        |              |
| [`Prune Files (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneFiles) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Prune Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneJobs) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Prune Volumes (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneVolumes) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Purge Migration Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PurgeMigrationJob) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Regex Where (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RegexWhere) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Replace (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Replace) | = [`REPLACE_OPTION`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-replace_option) | Always        |              |
| [`Rerun Failed Levels (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RerunFailedLevels) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Reschedule Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800          |              |
| [`Reschedule On Error (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleOnError) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Reschedule Times (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleTimes) | = [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 5             |              |
| [`Run (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Run) | = [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`Run After Failed Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterFailedJob) | = [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short) |               |              |
| [`Run After Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterJob) | = [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short) |               |              |
| [`Run Before Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunBeforeJob) | = [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short) |               |              |
| [`Run On Incoming Connect Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunOnIncomingConnectInterval) | = [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) | { [`RUNSCRIPT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript)} |               |              |
| [`Save File History (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SaveFileHistory) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Schedule (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Schedule) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`SD Plugin Options (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SdPluginOptions) | = [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Selection Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionType) | = [`MIGRATION_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-migration_type) |               |              |
| [`Spool Attributes (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolAttributes) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Spool Data (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolData) | = [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Spool Size (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolSize) | = [`SIZE64`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Storage (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Storage) | = [`RESOURCE_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               |              |
| [`Strip Prefix (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_StripPrefix) | = [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Type) | = [`JOB_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-job_type) |               | **required** |
| [`Verify Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VerifyJob) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               | *alias*      |
| [`Virtual Full Backup Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VirtualFullBackupPool) | = [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Where (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Where) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`Write Bootstrap (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_WriteBootstrap) | = [`DIRECTORY_OR_COMMAND`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory_or_command) |               |              |
| [`Write Verify List (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_WriteVerifyList) | = [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |

- `Accurate`

  Type: BOOLEAN

  Default value: no

  In accurate mode, the File daemon knowns exactly which files were present after the last backup.  

  在精确模式下，文件守护程序确切地知道上次备份后存在哪些文件。因此，它能够处理删除或重命名的文件。

  When restoring a FileSet for a specified date (including “most  recent”), Bareos is able to restore exactly the files and directories  that existed at the time of the last backup prior to that date including ensuring that deleted files are actually deleted, and renamed  directories are restored properly. 

  When doing [VirtualFull](https://docs.bareos.org/master/Configuration/Director.html#virtualfull) backups, it is advised to use the accurate mode, otherwise the VirtualFull might contain already deleted files. 

  However, using the accurate mode has also disadvantages:

  * The File daemon must keep data concerning all files in memory. So If you do not have sufficient memory, the backup may either be terribly slow or fail. For 500.000 files (a typical desktop linux system), it  will require approximately 64 Megabytes of RAM on your File daemon to  hold the required information.

  当恢复指定日期（包括“最近”）的文件集时，Bareos能够准确地恢复该日期之前的最后一次备份时存在的文件和目录，包括确保删除的文件实际上被删除，重命名的目录被正确恢复。

  在执行VirtualFull备份时，建议使用精确模式，否则VirtualFull可能包含已删除的文件。

  然而，使用精确模式也有缺点：

      文件守护程序必须在内存中保存有关所有文件的数据。因此，如果您没有足够的内存，备份可能会非常慢或失败。对于500.000个文件（典型的桌面Linux系统），File守护程序需要大约64 MB的RAM来保存所需的信息。

- `Add Prefix`

  Type: STRING

  This directive applies only to a Restore job and specifies a prefix  to the directory name of all files being restored. 此指令仅适用于还原作业，并为要还原的所有文件的目录名指定前缀。这将使用文件重新定位功能。

- Add Suffix[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AddSuffix)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string)  This directive applies only to a Restore job and specifies a suffix to all files being restored. This will use [File Relocation](https://docs.bareos.org/master/TasksAndConcepts/TheRestoreCommand.html#filerelocation) feature. Using `Add Suffix=.old`, `/etc/passwd` will be restored to `/etc/passwsd.old`

- Allow Duplicate Jobs[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowDuplicateJobs)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  [![Allow Duplicate Jobs usage](../../../Image/d/duplicate-real.svg)](https://docs.bareos.org/master/_images/duplicate-real.svg) Allow Duplicate Jobs usage[](https://docs.bareos.org/master/Configuration/Director.html#fig-allowduplicatejobs)  A duplicate job in the sense we use it here means a second or  subsequent job with the same name starts. This happens most frequently  when the first job runs longer than expected because no tapes are  available. If this directive is enabled duplicate jobs will be run. If the directive is set to **no** then only one job of a given name may run at one time. The action that  Bareos takes to ensure only one job runs is determined by the directives [`Cancel Lower Level Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelLowerLevelDuplicates) [`Cancel Queued Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelQueuedDuplicates) [`Cancel Running Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelRunningDuplicates) If none of these directives is set to **yes**, Allow Duplicate Jobs is set to **no** and two jobs are present, then the current job (the second one started) will be cancelled. Virtual backup jobs of a consolidation are not affected by the directive. In those cases the directive is going to be ignored.

- Allow Higher Duplicates[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowHigherDuplicates)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes

- Allow Mixed Priority[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowMixedPriority)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  When set to **yes**, this job may run even if lower  priority jobs are already running. This means a high priority job will  not have to wait for other jobs to finish before starting. The scheduler will only mix priorities when all running jobs have this set to true. Note that only higher priority jobs will start early. Suppose the  director will allow two concurrent jobs, and that two jobs with priority 10 are running, with two more in the queue. If a job with priority 5 is added to the queue, it will be run as soon as one of the running jobs  finishes. However, new priority 10 jobs will not be run until the  priority 5 job has finished.

- `Always Incremental`

  Type: BOOLEAN

  Default value: no

  Since Version: 16.2.4

  启用/禁用始终增量备份方案。

- Always Incremental Job Retention[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalJobRetention)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0 Since Version: 16.2.4  Backup Jobs older than the specified time duration will be merged into a new Virtual backup.

- Always Incremental Keep Number[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalKeepNumber)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0 Since Version: 16.2.4  Guarantee that at least the specified number of Backup Jobs will  persist, even if they are older than “Always Incremental Job Retention”.

- Always Incremental Max Full Age[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AlwaysIncrementalMaxFullAge)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Since Version: 16.2.4  If “AlwaysIncrementalMaxFullAge” is set, during consolidations only  incremental backups will be considered while the Full Backup remains to  reduce the amount of data being consolidated. Only if the Full Backup is older than “AlwaysIncrementalMaxFullAge”, the Full Backup will be part  of the consolidation to avoid the Full Backup becoming too old .

- `Backup Format`

  Type: STRING

  Default value: Native

  The backup format used for protocols which support multiple formats. Other protocols, like NDMP supports different backup formats for instance: 用于支持多种格式的协议的备份格式。默认情况下，it uses the Bareos **Native** Backup format它使用 Bareos 本机备份格式。其他协议，如 NDMP 支持不同的备份格式，例如：

  * Dump
  * Tar
  * SMTape

- Base[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Base)

  Type: [`RESOURCE_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) Since Version: deprecated  The Base directive permits to specify the list of jobs that will be  used during Full backup as base. This directive is optional. See the [Base Job chapter](https://docs.bareos.org/master/TasksAndConcepts/FileDeduplicationUsingBaseJobs.html#basejobs) for more information.

- Bootstrap[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Bootstrap)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  The Bootstrap directive specifies a bootstrap file that, if provided, will be used during Restore Jobs and is ignored in other Job types. The bootstrap file contains the list of tapes to be used in a restore Job  as well as which files are to be restored. Specification of this  directive is optional, and if specified, it is used only for a restore  job. In addition, when running a Restore job from the console, this  value can be changed. If you use the [restore](https://docs.bareos.org/master/TasksAndConcepts/BareosConsole.html#bcommandrestore) command in the Console program, to start a restore job, the bootstrap  file will be created automatically from the files you select to be  restored. For additional details see [The Bootstrap File](https://docs.bareos.org/master/Appendix/TheBootstrapFile.html#bootstrapchapter) chapter.

- Cancel Lower Level Duplicates[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelLowerLevelDuplicates)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If [`Allow Duplicate Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowDuplicateJobs) is set to **no** and this directive is set to **yes**, Bareos will choose between duplicated jobs the one with the highest  level. For example, it will cancel a previous Incremental to run a Full  backup. It works only for Backup jobs. If the levels of the duplicated  jobs are the same, nothing is done and the directives [`Cancel Queued Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelQueuedDuplicates) and [`Cancel Running Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelRunningDuplicates) will be examined.

- Cancel Queued Duplicates[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelQueuedDuplicates)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If [`Allow Duplicate Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowDuplicateJobs) is set to **no** and if this directive is set to **yes** any job that is already queued to run but not yet running will be canceled.

- Cancel Running Duplicates[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelRunningDuplicates)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If [`Allow Duplicate Jobs (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_AllowDuplicateJobs) is set to **no** and if this directive is set to **yes** any job that is already running will be canceled.

- Catalog

  Type: RES

  Since Version: 13.4.0

  指定要用于此作业的目录资源的名称。当在作业中定义目录时，它将覆盖客户端中的定义。

- Client

  Type: RES

  指定将在当前作业中使用的 Client（文件守护程序）。在任何一个作业中只能指定一个客户端。客户端在要备份的计算机上运行，并将请求的文件发送到存储守护程序进行备份，或在恢复时接收它们。此指令对于 13.3.0 之前的版本是必需的，所有作业类型都需要此指令。对于版本 >= 13.3.0，除复制或迁移作业外，所有作业类型都需要此选项。

- Client Run After Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunAfterJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that run on the client after a backup job.

- Client Run Before Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunBeforeJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is basically a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that run on the client before the backup job.  Warning For compatibility reasons, with this shortcut, the command is executed directly when the client receive it. And if the command is in error, other remote runscripts will be discarded. To be sure that all commands will be sent and executed, you have to use [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) syntax.

- Description

  Type: STRING

- `Differential Backup Pool`

  Type: RES

  指定用于差异备份的池。It will override any [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) specification during a Differential backup.它将在差异备份期间覆盖任何池（目录->作业）规范。

- Differential Max Runtime[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_DifferentialMaxRuntime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a Differential  backup job may run, counted from when the job starts (not necessarily  the same as when the job was scheduled).

- Dir Plugin Options[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_DirPluginOptions)

  Type: [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  These settings are plugin specific, see [Director Plugins](https://docs.bareos.org/master/TasksAndConcepts/Plugins.html#dirplugins).

- `Enabled`

  Type: BOOLEAN

  Default value: yes

  启用或禁用此资源。This directive allows you to enable or disable automatic execution via the scheduler of a Job.此指令允许您通过作业的调度程序启用或禁用自动执行。

- FD Plugin Options[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FdPluginOptions)

  Type: [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  These settings are plugin specific, see [File Daemon Plugins](https://docs.bareos.org/master/TasksAndConcepts/Plugins.html#fdplugins).

- File History Size[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FileHistorySize)

  Type: [`SIZE64`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-size64) Default value: 10000000 Since Version: 15.2.4  When using NDMP and [`Save File History (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SaveFileHistory) is enabled, this directives controls the size of the internal temporary database (LMDB) to translate NDMP file and directory information into  Bareos file and directory information. **File History Size** must be greater the number of directories + files of this NDMP backup job. Warning This uses a large memory mapped file (**File History Size** * 256 => around 2,3 GB for the **File History Size = 10000000**). On 32-bit systems or if a memory limit for the user running the Bareos Director (normally **bareos**) exists (verify by **su - bareos -s /bin/sh -c "ulimit -a"**), this may fail.

- `File Set`

  Type: RES

  FileSet 指令指定将在当前作业中使用的 FileSet 。文件集指定要备份的目录（或文件）以及要使用的选项（例如压缩等）。在任何一个作业中只能指定一个 FileSet 资源。此指令是必需的（对于 13.3.0 之前的版本，所有作业类型都是如此；对于 13.3.0 之后的版本，所有作业类型都是如此，但复制和迁移除外）。

- `Full Backup Pool`

  Type: RES

  指定用于完全备份的池。It will override any [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) specification during a Full backup.它将在完整备份期间覆盖任何池（目录->作业）规范。

- Full Max Runtime[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FullMaxRuntime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a Full backup job  may run, counted from when the job starts (not necessarily the same as  when the job was scheduled).

- `Incremental Backup Pool`

  Type: RES

  指定用于增量备份的池。它将在增量备份期间覆盖任何池（目录->作业）规范。It will override any [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) specification during an Incremental backup.

- Incremental Max Runtime[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_IncrementalMaxRuntime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that an Incremental  backup job may run, counted from when the job starts, (not necessarily  the same as when the job was scheduled).

- `Job Defs`

  Type: RES

  如果指定了 Job Defs 资源名称，则命名的 Job Defs 资源中包含的所有值将用作当前作业的默认值。在当前作业资源中显式定义的任何值都将覆盖在 Job Defs 资源中指定的任何默认值。The use of this directive permits writing much more compact Job resources where the bulk of the directives are defined in one or more [Job Defs](https://docs.bareos.org/master/Configuration/Director.html#directorresourcejobdefs). 使用此指令允许编写更紧凑的作业资源，其中大部分指令在一个或多个作业定义中定义。This is particularly useful if you have many similar Jobs but with  minor variations such as different Clients. 如果你有许多类似的工作，但有一些小的变化，如不同的客户端，这是特别有用的。为了进一步构造配置，作业定义本身也可以引用其他作业定义。To structure the  configuration even more, [Job Defs](https://docs.bareos.org/master/Configuration/Director.html#directorresourcejobdefs) themselves can also refer to other [Job Defs](https://docs.bareos.org/master/Configuration/Director.html#directorresourcejobdefs). 

  > Warning
  >
  > If a parameter like RunScript for example can be specified multiple  times, the configuration will be added instead of overridden as  described above. Therefore, if one RunScript is defined in the JobDefs  and another in the job, both will be executed.
  >
  > 如果像RunScript这样的参数可以被多次指定，配置将被添加而不是如上所述被覆盖。因此，如果在JobDefs中定义了一个RunScript，而在作业中定义了另一个RunScript，则两者都将执行。

- `Job To Verify`

  Type: RES

- Level

  Type: BACKUP_LEVEL

  指定要运行的默认作业级别。Each different [`Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Type) (Backup, Restore, Verify, …) has a different set of Levels that can be  specified. 每种不同的类型（目录->作业）（备份、还原、验证等）都有一组不同的级别可供指定。该级别通常由计划资源中指定的其他值覆盖。此指令不是必需的，但必须由此指令指定，或作为调度资源中指定的重写。but must be specified either by this directive or as an override specified in the [Schedule Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourceschedule). 

  * Backup

    对于备份作业，级别可能是以下之一：

    * Full

      当级别设置为 Full 时，文件集中的所有文件（无论是否已更改）都将被备份。

    * Incremental

      当级别设置为 Incremental 时，all files specified in the FileSet that have changed since  the last successful backup of the the same Job using the same FileSet  and Client, will be backed up. 将备份文件集中指定的所有文件，这些文件自上次使用相同文件集和客户端成功备份相同作业以来发生了更改。如果 Director 找不到以前有效的完整备份，则作业将升级为完整备份。当 Director 在目录数据库中查找有效备份记录时，会查找具有以下内容的先前作业：

      1. 相同的作业名称。
      2. 相同的客户名称。
      3. 相同的文件集（对文件集定义的任何更改，例如在包含或删除部分中添加或删除文件，都将构成不同的文件集。）
      4. 作业是完整备份、差异备份或增量备份。
      5. 作业正常终止（即未失败或未取消）。
      6. 作业的启动时间不早于最大完全间隔 Max Full Interval 。

      如果上述所有条件都不成立，Director 将 Incremental 存储升级为 Full 保存。Otherwise, the Incremental backup will  be performed as requested.否则，将按请求执行增量备份。

      文件守护程序（客户端）通过将上一个作业（Full 、Differential 或 Incremental）的开始时间与每个文件上次 “modified” 的时间（st_mtime）及其属性上次 “changed” 的时间（st_ctime）进行比较，来决定要备份哪些文件以进行增量备份。If the file was modified or its attributes changed  on or after this start time, 如果在此开始时间或之后修改了文件或更改了其属性，则将备份该文件。

      某些病毒扫描软件在扫描时可能会更改 st_ctime 。例如，if the virus scanning program attempts to reset the  access time (st_atime), which Bareos does not use, it will cause  st_ctime to change如果病毒扫描程序试图重置 Bareos 不使用的访问时间（st_atime），它将导致st_ctime更改，因此 Bareos 将在 Incremental 或 Differential 期间备份文件。 In the case of Sophos virus  scanning, you can prevent it from resetting the access time (st_atime)  and hence changing st_ctime by using the **–no-reset-atime** option.在 Sophos 病毒扫描的情况下，您可以使用 `-no-reset-atime` 选项阻止它重置访问时间（st_atime）并因此更改 st_ctime 。对于其他软件，请参阅其手册。

      当 Bareos 执行 Incremental 备份时，系统上所有修改过的文件都会被备份。any file that has been  deleted since the last Full backup remains in the Bareos catalog, which  means that if between a Full save and the time you do a restore, some  files are deleted, those deleted files will also be restored. 但是，自上次完整备份以来删除的任何文件仍保留在Bareos目录中，这意味着如果在完整保存和执行还原之间删除了某些文件，则这些删除的文件也将被还原。执行另一次完整保存后，删除的文件将不再显示在目录中。

      此外，如果移动目录而不是复制目录，则其中的文件不会更改其修改时间（st_mtime）或属性更改时间（st_ctime）。因此，这些文件可能不会通过 Incremental 或 Differential 备份进行备份，因为 Incremental 或 Differential 备份仅依赖于这些时间戳。如果您移动了一个目录，并希望它得到正确的备份，通常最好是复制它，然后删除原始的。

      但是，要在 Incremental 备份期间管理目录中已删除的文件或目录更改，可以使用精确模式。这是一个非常消耗内存的过程。

    * Differential

      当级别设置为 Differential 时，all  files specified in the FileSet that have changed since the last  successful Full backup of the same Job will be backed up. 将备份文件集中指定的、自上次成功 Full 备份同一作业以来发生更改的所有文件。如果 Director 无法为同一作业、文件集和客户端备份找到以前有效的 Full 备份，则 Differential 作业将升级为 Full 备份。当 Director 在目录数据库中查找有效的 Full 备份记录时，它会查找具有以下内容的先前作业：

      1. 相同的作业名称。
      2. 相同的客户名称。
      3. 相同的文件集（对文件集定义的任何更改，例如在包含或删除部分中添加或删除文件，都将构成不同的文件集。）
      4. 作业是完整备份。
      5. 作业正常终止（即未失败或未取消）。
      6. 作业的启动时间不早于最大完全间隔 Max Full Interval。

      如果上述所有条件都不成立，Director 将把 Differential 存储升级为 Full 保存。否则，将按请求执行 Differential 备份。

      文件守护程序（客户端）通过将上一个 Full 备份作业的开始时间与每个文件上次“修改”的时间（st_mtime）及其属性上次“更改”的时间（st_ctime）进行比较，来决定要备份哪些文件以进行 Differential 备份。如果在此开始时间或之后修改了文件或更改了其属性，则将备份该文件。The start time used is displayed after the Since on the Job report. 使用的开始时间显示在作业报告的“Since”之后。在极少数情况下，使用先前备份的开始时间可能会导致某些文件备份两次，但它可以确保不会遗漏任何更改。

      当 Bareos 执行 Differential 备份时，系统上所有已修改的文件都会被备份。但是，自上次 Full 备份以来删除的任何文件仍保留在 Bareos 目录中，这意味着如果在 Full 保存和执行还原之间删除了某些文件，则这些删除的文件也将被还原。any file that has been  deleted since the last Full backup remains in the Bareos catalog, which  means that if between a Full save and the time you do a restore, some  files are deleted, those deleted files will also be restored. 执行另一次 Full 保存后，删除的文件将不再显示在目录中。但是，在 Differential 备份期间从目录中删除已删除的文件是一个相当耗时的过程，目前尚未在 Bareos 中实现。这是一个计划中的未来功能。

      如上所述，如果您移动目录而不是复制它，则其中的文件不会更改其修改时间（st_mtime）或属性更改时间（st_ctime）。因此，这些文件可能不会通过 Incremental 或 Differential 备份进行备份，因为 Incremental 或 Differential 备份仅依赖于这些时间戳。如果您移动了一个目录，并希望它得到正确的备份，通常最好是复制它，然后删除原始的。或者，可以移动目录，然后使用 touch 程序更新时间戳。

      但是，要在 Differential 备份期间管理目录中已删除的文件或目录更改，可以使用精确模式。这是一个非常消耗内存的过程。

      时不时地，有人会问，只要 Incremental 备份可以拾取所有更改的文件，为什么我们需要 Differential 备份。这个问题可能有很多答案，但对我来说最重要的是 Differential 备份有效地将自上次 Full 备份以来的所有 Incremental 和 Differential 备份合并到一个差异备份中。a Differential backup effectively merges all  the Incremental and Differential backups since the last Full backup into a single Differential backup这有两个影响：

      1. it gives some  redundancy since the old backups could be used if the merged backup  cannot be read. 它提供了一些冗余，因为如果无法读取合并的备份，则可以使用旧的备份。
      2. 更重要的是，它减少了执行恢复所需的卷的数量，effectively eliminating the need to read all the  volumes on which the preceding Incremental and Differential backups  since the last Full are done.从而有效地消除了读取自上次完整备份以来执行增量备份和差异备份的所有卷的需要。

    * VirtualFull

      当级别设置为 VirtualFull 时，将从最后一个现有的 Full 备份以及匹配的 Differential 备份和 Incremental 备份生成新的 Full 备份。It matches this according the [`Name (Dir->Client)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Client_Name) and [`Name (Dir->Fileset)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Fileset_Name). 它根据名称（Dir->Client）和名称（Dir-> Film）与此匹配。这意味着创建新的 Full 备份，而无需将所有数据从客户端再次传输到备份服务器。新的 Full 备份将存储在 [`Next Pool (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_NextPool) 下一个池（Dir->Pool）中定义的池中。

      > Warning
      >
      > 与其他备份级别相反，VirtualFull 可能需要对多个卷进行读写访问。在大多数情况下，你必须确保，Bareos 不会尝试读取和写入同一卷。使用VirtualFull，只能对源和目标使用相同的 Storage Daemon ，因为为作业创建的还原 bsr 文件一次只能由一个存储守护程序读取。
    
  * Restore

    对于还原作业，无需指定级别。

  * Verify

    对于验证作业，级别可以是以下之一：

    * InitCatalog

      扫描指定的文件集并将文件属性存储在目录数据库中。由于不保存文件数据，您可能会问为什么要这样做。It  turns out to be a very simple and easy way to have a Tripwire like  feature using Bareos.事实证明，这是一个非常简单和容易的方法，有一个类似Tripwire的功能使用Bareos。换句话说，it allows you to save the state of a set of files defined by the FileSet and later check to see if those  files have been modified or deleted and if any new files have been  added.它允许您保存由FileSet定义的一组文件的状态，并在以后检查这些文件是否已被修改或删除，以及是否添加了任何新文件。这可以用来检测系统入侵。通常，您会指定一个 FileSet，其中包含不应更改的系统文件集（例如 /sbin、/boot、/lib、/bin 等）。通常，在系统首次设置时运行一次 InitCatalog 级别验证，然后在每次修改（升级）系统后再运行一次。此后，当您想要检查系统文件的状态时，可以使用 Verify level = Catalog 。这会将 InitCatalog 的结果与文件的当前状态进行比较。

    * Catalog

      Compares the current state of the  files against the state previously saved during an InitCatalog. 将文件的当前状态与以前在初始化目录期间保存的状态进行比较。报告任何差异。The items reported are determined by the  verify options specified on the Include directive in the specified  FileSet.报告的项由指定 FileSet 中 Include 指令上指定的验证选项确定。通常，此命令将每天（或晚上）运行一次，以检查系统文件的任何更改。

      > Warning
      >
      > If you run two Verify Catalog jobs on the same client at the same time,如果在同一客户端上同时运行两个“验证目录”作业，则结果肯定不正确。This is because Verify Catalog modifies the Catalog database while running in order to track new files.  这是因为“验证目录”在运行时会修改目录数据库，以便跟踪新文件。

    * VolumeToCatalog

      This level causes Bareos  to read the file attribute data written to the Volume from the last  backup Job for the job specified on the VerifyJob directive. The file  attribute data are compared to the values saved in the Catalog database  and any differences are reported. This is similar to the DiskToCatalog  level except that instead of comparing the disk file attributes to the  catalog database, the attribute data written to the Volume is read and compared to the catalog database. Although the attribute data including  the signatures (MD5 or SHA1) are compared, the actual file data is not  compared (it is not in the catalog). 

      此级别使Bareos读取VerifyJob指令上指定作业的最后一个备份作业中写入卷的文件属性数据。将文件属性数据与保存在目录数据库中的值进行比较，并报告任何差异。这类似于卷到目录级别，不同之处在于，不是将磁盘文件属性与目录数据库进行比较，而是读取写入卷的属性数据并将其与目录数据库进行比较。虽然比较了包括签名（MD5或SHA1）的属性数据，但不比较实际的文件数据（它不在目录中）。

      VolumeToCatalog作业需要客户端来提取元数据，但此客户端不必是原始客户端。我们建议在备份服务器本身上使用客户端，以获得最佳性能。

      VolumeToCatalog jobs require a client to extract the metadata, but  this client does not have to be the original client. We suggest to use  the client on the backup server itself for maximum performance. 

      > Warning
      >
      > If you run two Verify VolumeToCatalog jobs on the same client at the same time, the results will certainly be incorrect.  This is because the Verify VolumeToCatalog modifies the Catalog database while running.  如果在同一客户端上同时运行两个Verify VolumeToCatalog作业，则结果肯定不正确。这是因为Verify VolumeToCatalog在运行时会修改Catalog数据库。

      > Limitation:
      >
      > Verify VolumeToCatalog does not check file checksums When running a Verify VolumeToCatalog job the file data will not be  checksummed and compared with the recorded checksum. As a result, file data errors that are introduced between the  checksumming in the Bareos File Daemon and the checksumming of the block by the Bareos Storage Daemon will not be detected.  
      >
      > 运行Verify VolumeToCatalog作业时，不会对文件数据进行校验和，也不会将其与记录的校验和进行比较。因此，在Bareos文件守护程序中的校验和和Bareos存储守护程序对块的校验和之间引入的文件数据错误将不会被检测到。

    * DiskToCatalog

      This level causes Bareos to  read the files as they currently are on disk, and to compare the current file attributes with the attributes saved in the catalog from the last  backup for the job specified on the VerifyJob directive. This level  differs from the VolumeToCatalog level described above by the fact that  it doesn’t compare against a previous Verify job but against a previous  backup. When you run this level, you must supply the verify options on your Include statements. Those options determine what attribute  fields are compared.

      此级别使Bareos读取当前磁盘上的文件，并将当前文件属性与上次备份中保存在目录中的属性进行比较，以执行VerifyJob指令上指定的作业。此级别与上述VolumeToCatalog级别的不同之处在于，它不与以前的验证作业进行比较，而是与以前的备份进行比较。运行此级别时，必须在Include语句中提供verify选项。这些选项确定要比较哪些属性字段。

      This command can be very useful if you have disk problems because it  will compare the current state of your disk against the last successful  backup, which may be several jobs.

      如果您有磁盘问题，此命令可能非常有用，因为它会将磁盘的当前状态与上次成功备份（可能是几个作业）进行比较。

      注意，当前的实现不识别已删除的文件。

- Max Concurrent Copies[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxConcurrentCopies)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 100

- Max Diff Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxDiffInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed age (counting from start time) of the most recent successful Differential backup that is required in  order to run Incremental backup jobs. If the most recent Differential  backup is older than this interval, Incremental backups will be upgraded to Differential backups automatically. If this directive is not  present, or specified as 0, then the age of the previous Differential  backup is not considered.

- Max Full Consolidations[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxFullConsolidations)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0 Since Version: 16.2.4  If “AlwaysIncrementalMaxFullAge” is configured, do not run more than  “MaxFullConsolidations” consolidation jobs that include the Full backup.

- Max Full Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxFullInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed age (counting from start time) of the most recent successful Full backup that is required in order to  run Incremental or Differential backup jobs. If the most recent Full  backup is older than this interval, Incremental and Differential backups will be upgraded to Full backups automatically. If this directive is  not present, or specified as 0, then the age of the previous Full backup is not considered.

- Max Run Sched Time[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxRunSchedTime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a job may run,  counted from when the job was scheduled. This can be useful to prevent  jobs from running during working hours. We can see it like `Max Start Delay + Max Run Time`.

- Max Run Time[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxRunTime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a job may run,  counted from when the job starts, (not necessarily the same as when the  job was scheduled). By default, the watchdog thread will kill any Job that has run more than 6 days. The maximum watchdog timeout is independent of **Max Run Time** and cannot be changed.

- Max Start Delay[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxStartDelay)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum delay between the scheduled time and  the actual start time for the Job. For example, a job can be scheduled  to run at 1:00am, but because other jobs are running, it may wait to  run. If the delay is set to 3600 (one hour) and the job has not begun to run by 2:00am, the job will be canceled. This can be useful, for  example, to prevent jobs from running during day time hours. The default is no limit.

- Max Virtual Full Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxVirtualFullInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Since Version: 14.4.0  The time specifies the maximum allowed age (counting from start time) of the most recent successful Virtual Full backup that is required in  order to run Incremental or Differential backup jobs. If the most recent Virtual Full backup is older than this interval, Incremental and  Differential backups will be upgraded to Virtual Full backups  automatically. If this directive is not present, or specified as 0, then the age of the previous Virtual Full backup is not considered.

- Max Wait Time[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaxWaitTime)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a job may block  waiting for a resource (such as waiting for a tape to be mounted, or  waiting for the storage or file daemons to perform their duties),  counted from the when the job starts, (not necessarily the same as when  the job was scheduled). [![Job time control directives](../../../Image/d/different_time.png)](https://docs.bareos.org/master/_images/different_time.png) Job time control directives[](https://docs.bareos.org/master/Configuration/Director.html#fig-differenttime)

- Maximum Bandwidth

  Type: SPEED

  speed 参数指定作业可以使用的最大允许带宽。

- Maximum Concurrent Jobs[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  Specifies the maximum number of Jobs from the current Job resource  that can run concurrently. Note, this directive limits only Jobs with  the same name as the resource in which it appears. Any other  restrictions on the maximum concurrent jobs such as in the Director,  Client or Storage resources will also apply in addition to the limit  specified here. For details, see the [Concurrent Jobs](https://docs.bareos.org/master/Appendix/Troubleshooting.html#concurrentjobs) chapter.

- Messages

  Required: True

  Type: RES

  The Messages directive defines what Messages resource should be used  for this job, and thus how and where the various messages are to be  delivered. Messages 指令定义了什么 Messages 资源应该被用于这个作业，以及如何以及在哪里传递各种消息。例如，您可以将某些消息定向到日志文件，而其他消息可以通过电子邮件发送。此指令是必需的。

- Name

  Required: True

  Type: NAME

  资源的名称。

  作业名称。可以在控制台程序的 Run 命令中指定此名称以启动作业。如果名称包含空格，则必须在引号之间指定。It is generally a good idea to give your job  the same name as the Client that it will backup.通常，最好给予作业与它要备份的客户端相同的名称。这使得作业容易识别。

  When the job actually runs, the unique Job Name will consist of the  name you specify here followed by the date and time the job was  scheduled for execution. 当作业实际运行时，唯一的作业名称将由您在此处指定的名称以及作业计划执行的日期和时间组成。

  建议将作业名称限制为 98 个字符。更高的值总是可能的，但是当作业运行时，它的名称将被截断以适应某些协议限制，以及上述日期和时间。

- Next Pool

  Type: RES

  A Next Pool override used for Migration/Copy and Virtual Backup Jobs.用于 迁移/拷贝和虚拟备份作业的下一个池覆盖。

- Pool

  Required: True

  Type: RES

  Pool 指令定义可以备份数据的卷池。许多 Bareos 安装将仅使用默认池。但是，如果您想为不同的客户端或不同的作业指定不同的一组卷，则可能需要使用池。此指令是必需的。

  In case of a Copy or Migration job, this setting determines what Pool will be examined for finding JobIds to migrate. The exception to this  is when [`Selection Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionType) = SQLQuery, and although a Pool directive must still be specified, no  Pool is used, unless you specifically include it in the SQL query. Note, in any case, the Pool resource defined by the Pool directive must  contain a [`Next Pool (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_NextPool) = … directive to define the Pool to which the data will be migrated.对于拷贝或迁移作业，此设置确定将检查哪个池以查找要迁移的JobId。例外情况是当选择类型（Dir->Job）= SQLQuery时，尽管仍然必须指定Pool指令，但不使用Pool，除非您在SQL查询中特别包含它。请注意，在任何情况下，Pool指令定义的Pool资源都必须包含Next Pool（Dir->Pool）=...指令，以定义数据将迁移到的Pool。

- Prefer Mounted Volumes[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PreferMountedVolumes)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If the Prefer Mounted Volumes directive is set to yes, the Storage  daemon is requested to select either an Autochanger or a drive with a  valid Volume already mounted in preference to a drive that is not ready. This means that all jobs will attempt to append to the same Volume  (providing the Volume is appropriate – right Pool, … for that job),  unless you are using multiple pools. If no drive with a suitable Volume  is available, it will select the first available drive. Note, any Volume that has been requested to be mounted, will be considered valid as a mounted  volume by another job. This if multiple jobs start at the same time and  they all prefer mounted volumes, the first job will request the mount,  and the other jobs will use the same volume. If the directive is set to no, the Storage daemon will prefer finding an unused drive, otherwise, each job started will append to the same  Volume (assuming the Pool is the same for all jobs). Setting Prefer  Mounted Volumes to no can be useful for those sites with multiple drive  autochangers that prefer to maximize backup throughput at the expense of using additional drives and Volumes. This means that the job will  prefer to use an unused drive rather than use a drive that is already in use. Despite the above, we recommend against setting this directive to no  since it tends to add a lot of swapping of Volumes between the different drives and can easily lead to deadlock situations in the Storage  daemon. We will accept bug reports against it, but we cannot guarantee  that we will be able to fix the problem in a reasonable time. A better alternative for using multiple drives is to use multiple  pools so that Bareos will be forced to mount Volumes from those Pools on different drives.

- Prefix Links[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PrefixLinks)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If a Where path prefix is specified for a recovery job, apply it to  absolute links as well. The default is No. When set to Yes then while  restoring files to an alternate directory, any absolute soft links will  also be modified to point to the new alternate directory. Normally this  is what is desired – i.e. everything is self consistent. However, if you wish to later move the files to their original locations, all files  linked with absolute names will be broken.

- Priority[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Priority)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 10  This directive permits you to control the order in which your jobs  will be run by specifying a positive non-zero number. The higher the  number, the lower the job priority. Assuming you are not running  concurrent jobs, all queued jobs of priority 1 will run before queued  jobs of priority 2 and so on, regardless of the original scheduling  order. The priority only affects waiting jobs that are queued to run, not  jobs that are already running. If one or more jobs of priority 2 are  already running, and a new job is scheduled with priority 1, the  currently running priority 2 jobs must complete before the priority 1  job is run, unless Allow Mixed Priority is set. If you want to run concurrent jobs you should keep these points in mind: See [Concurrent Jobs](https://docs.bareos.org/master/Appendix/Troubleshooting.html#concurrentjobs) on how to setup concurrent jobs. Bareos concurrently runs jobs of only one priority at a time. It will not simultaneously run a priority 1 and a priority 2 job. If Bareos is running a priority 2 job and a new priority 1 job is scheduled, it will wait until the running priority 2 job terminates  even if the Maximum Concurrent Jobs settings would otherwise allow two  jobs to run simultaneously. Suppose that bareos is running a priority 2 job and a new  priority 1 job is scheduled and queued waiting for the running priority 2 job to terminate. If you then start a second priority 2 job, the  waiting priority 1 job will prevent the new priority 2 job from running  concurrently with the running priority 2 job. That is: as long as there  is a higher priority job waiting to run, no new lower priority jobs will start even if the Maximum Concurrent Jobs settings would normally allow them to run. This ensures that higher priority jobs will be run as soon as  possible. If you have several jobs of different priority, it may not best to  start them at exactly the same time, because Bareos must examine them  one at a time. If by Bareos starts a lower priority job first, then it  will run before your high priority jobs. If you experience this problem, you may avoid it by starting any higher priority jobs a few seconds  before lower priority ones. This insures that Bareos will examine the  jobs in the correct order, and that your priority scheme will be  respected.

- Protocol[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Protocol)

  Type: [`PROTOCOL_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-protocol_type) Default value: Native  The backup protocol to use to run the Job. See dtProtocolType.

- Prune Files[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneFiles)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Normally, pruning of Files from the Catalog is specified on a Client by Client basis in [`Auto Prune (Dir->Client)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Client_AutoPrune). If this directive is specified and the value is **yes**, it will override the value specified in the Client resource.

- Prune Jobs[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneJobs)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Normally, pruning of Jobs from the Catalog is specified on a Client by Client basis in [`Auto Prune (Dir->Client)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Client_AutoPrune). If this directive is specified and the value is **yes**, it will override the value specified in the Client resource.

- Prune Volumes[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PruneVolumes)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Normally, pruning of Volumes from the Catalog is specified on a Pool by Pool basis in [`Auto Prune (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_AutoPrune) directive. Note, this is different from File and Job pruning which is  done on a Client by Client basis. If this directive is specified and the value is **yes**, it will override the value specified in the Pool resource.

- Purge Migration Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_PurgeMigrationJob)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive may be added to the Migration Job definition in the  Director configuration file to purge the job migrated at the end of a  migration.

- Regex Where[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RegexWhere)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string)  This directive applies only to a Restore job and specifies a regex  filename manipulation of all files being restored. This will use [File Relocation](https://docs.bareos.org/master/TasksAndConcepts/TheRestoreCommand.html#filerelocation) feature. For more informations about how use this option, see [RegexWhere Format](https://docs.bareos.org/master/TasksAndConcepts/TheRestoreCommand.html#regexwhere).

- Replace

  Type: REPLACE_OPTION

  Default value: Always

  此指令仅适用于还原作业，specifies what  happens when Bareos wants to restore a file or directory that already  exists.并指定当 Bareos 想要还原已存在的文件或目录时会发生什么。您有以下 replace-option 选项：

  * always

    当要还原的文件已经存在时，将删除该文件，然后用备份的副本替换。这是默认值。

  * ifnewer

    如果备份的文件（在磁带上）比现有文件新，则删除现有文件并用备份文件替换。

  * ifolder

    如果备份的文件（在磁带上）比现有文件旧，则删除现有文件并用备份文件替换。

  * never

    如果备份的文件已经存在，Bareos 将跳过恢复此文件。

- Rerun Failed Levels[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RerunFailedLevels)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If this directive is set to yes (default no), and Bareos detects that a previous job at a higher level (i.e. Full or Differential) has  failed, the current job level will be upgraded to the higher level. This is particularly useful for Laptops where they may often be unreachable, and if a prior Full save has failed, you wish the very next backup to  be a Full save rather than whatever level it is started as.

  如果此指令设置为yes（默认为no），并且Bareos检测到更高级别（即Full或Differential）的先前作业失败，则当前作业级别将升级到更高级别。这对于笔记本电脑尤其有用，因为笔记本电脑可能经常无法访问，并且如果之前的完全保存失败，您希望下一次备份是完全保存，而不是启动时的任何级别。

  使用此指令时必须考虑以下几点：首先，失败的作业定义为尚未正常终止的作业，其中包括任何同名的正在运行的作业（您需要确保两个同名的作业不会同时运行）;其次，在检查失败的级别时，不考虑忽略文件集更改（Dir-> Filename）指令，这意味着任何文件集更改都将触发一个filename。

  There are several points that must be taken into account when using  this directive: first, a failed job is defined as one that has not  terminated normally, which includes any running job of the same name  (you need to ensure that two jobs of the same name do not run  simultaneously); secondly, the [`Ignore File Set Changes (Dir->Fileset)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Fileset_IgnoreFileSetChanges) directive is not considered when checking for failed levels, which means that any FileSet change will trigger a rerun.

- Reschedule Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800  If you have specified Reschedule On Error = yes and the job terminates in error, it will be rescheduled after the interval of time specified by time-specification. See the time specification formats of [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) for details of time specifications. If no interval is specified, the job will not be rescheduled on error.

- Reschedule On Error[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleOnError)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If this directive is enabled, and the job terminates in error, the job will be rescheduled as determined by the [`Reschedule Interval (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleInterval) and [`Reschedule Times (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleTimes) directives. If you cancel the job, it will not be rescheduled. This specification can be useful for portables, laptops, or other  machines that are not always connected to the network or switched on. Warning In case of Bareos Director crash, none of the running nor waiting jobs will be rescheduled.

- Reschedule Times[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RescheduleTimes)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 5  This directive specifies the maximum number of times to reschedule  the job. If it is set to zero the job will be rescheduled an indefinite  number of times.

- Run[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Run)

  Type: [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  The Run directive (not to be confused with the Run option in a Schedule) allows you to start  other jobs or to clone the current jobs. The part after the equal sign must be enclosed in double quotes, and  can contain any string or set of options (overrides) that you can  specify when entering the **run** command from the console. For example storage=DDS-4 …. In addition,  there are two special keywords that permit you to clone the current job. They are level=%l and since=%s. The %l in the level keyword permits  entering the actual level of the current job and the %s in the since  keyword permits putting the same time for comparison as used on the current job. Note, in the case  of the since keyword, the %s must be enclosed in double quotes, and thus they must be preceded by a backslash since they are already inside  quotes. For example: `run = "Nightly-backup level=%l since=\"%s\" storage=DDS-4" `



- Run After Failed Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterFailedJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that runs a command after a failed job. If the exit code of the program run is non-zero, Bareos will print a warning message. `Run Script {  Command = "echo test"  Runs When = After  Runs On Failure = yes  Runs On Client  = no  Runs On Success = yes    # default, you can drop this line } `

- Run After Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that runs a command after a successful job (without error or without being canceled). If the exit code of the program run is non-zero, Bareos will print a warning message.

- Run Before Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunBeforeJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that runs a command before a job. If the exit code of the program run is non-zero, the current Bareos job will be canceled. `Run Before Job = "echo test" `

is equivalent to:

> ```
> Run Script {
>   Command = "echo test"
>   Runs On Client = No
>   Runs When = Before
> }
> ```

- Run On Incoming Connect Interval[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunOnIncomingConnectInterval)

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0 Since Version: 19.2.4  The interval specifies the time between the most recent successful  backup (counting from start time) and the event of a client initiated  connection. When this interval is exceeded the job is started  automatically.  ![@startgantt [Run On Incoming Connect Interval = 35h] lasts 35 days and is colored in LightBlue [Run On Incoming Connect Interval starts again -->] lasts 18 days and is colored in LightBlue  -- Backups -- [Successful Backup] lasts 8 days [Successful Backup again] lasts 11 days  -- Client connection status -- [Client connected] lasts 10 days and is colored in Lime then [Client disconnected] lasts 10 days and is colored in DeepPink [Connect does not trigger] happens at [Client disconnected]'s end then [Client connected again] lasts 10 days and is colored in Lime then [Client disconnected again] lasts 13 days and is colored in DeepPink [Connect triggers backup] happens at [Client disconnected again]'s end then [Client connected again 2] lasts 11 days and is colored in Lime [Client disconnected again] -> [Client connected again 2] [Client disconnected again] -> [Successful Backup again] [Run On Incoming Connect Interval starts again -->] starts at [Successful Backup again]'s start  @endgantt](../../../Image/p/plantuml-47c1af1572ecefb4a6d99a587107685b6003a8e2.svg) Timing example for Run On Incoming Connect Interval[](https://docs.bareos.org/master/Configuration/Director.html#id2)

- Run Script[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript)

  Type: [`RUNSCRIPT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript)  The RunScript directive behaves like a resource in that it requires  opening and closing braces around a number of directives that make up  the body of the runscript. **Command** options specifies commands to run as an external program prior or after the current job. **Console** options are special commands that are sent to the Bareos Director instead of the OS. Console command outputs are redirected to log with the jobid 0. You can use following console command: `delete`, `disable`, `enable`, `estimate`, `list`, `llist`, `memory`, `prune`, `purge`, `release`, `reload`, `status`, `setdebug`, `show`, `time`, `trace`, `update`, `version`, `whoami`, `.client`, `.jobs`, `.pool`, `.storage`. See [Bareos Console](https://docs.bareos.org/master/TasksAndConcepts/BareosConsole.html#section-bconsole) for more information. You need to specify needed information on command line, nothing will be prompted. Example: `Console = "prune files client=\%c" Console = "update stats age=3" `

You can specify more than one Command/Console option per RunScript.

You can use following options may be specified in the body of the RunScript:

| Options           | Value                                                   | Description                                                  |
| ----------------- | ------------------------------------------------------- | ------------------------------------------------------------ |
| Runs On Success   | **Yes** \| No                                           | run if JobStatus is successful                               |
| Runs On Failure   | Yes \| **No**                                           | run if JobStatus isn’t successful                            |
| Runs On Client    | **Yes** \| No                                           | run a command on client (only for external commands - not console commands) |
| Runs When         | **Never** \| `Before` | `After` | `Always` | `AfterVSS` | When to run                                                  |
| Fail Job On Error | **Yes** \| No                                           | Fail job if script returns something different from 0        |
| Command           |                                                         | External command (optional)                                  |
| Console           |                                                         | Console command (optional)                                   |

Any output sent by the command to standard output will be included in the Bareos job report. The command string must be a valid program name  or name of a shell script.

RunScript commands that are configured to run “before” a job, are also executed before the device reservation.

Warning

The command string is parsed then fed to the OS, which means that the path will be searched to execute your specified command, but there is no shell interpretation. As a consequence, if you invoke complicated commands or want any shell features such as redirection or piping, you must call a shell script and do it inside that script. Alternatively, it is possible to use **sh -c '...'** in the command definition to force shell interpretation, see example below.

Before executing the specified command, Bareos performs character substitution of the following characters:

| %%   | %                                                            |
| ---- | ------------------------------------------------------------ |
| %b   | Job Bytes                                                    |
| %B   | Job Bytes in human readable format                           |
| %c   | Client’s name                                                |
| %d   | Daemon’s name (Such as host-dir or host-fd)                  |
| %D   | Director’s name (also valid on a Bareos File Daemon)         |
| %e   | Job Exit Status                                              |
| %f   | Job FileSet (only on director side)                          |
| %F   | Job Files                                                    |
| %h   | Client address                                               |
| %i   | Job Id                                                       |
| %j   | Unique Job Id                                                |
| %l   | Job Level                                                    |
| %m   | Modification time (only on Bareos File Daemon side for incremental and differential) |
| %n   | Job name                                                     |
| %N   | New Job Id (only on director side during migration/copy jobs) |
| %O   | Previous Job Id (only on director side during migration/copy jobs) |
| %p   | Pool name (only on director side)                            |
| %P   | Daemon PID                                                   |
| %s   | Since time                                                   |
| %t   | Job type (Backup, …)                                         |
| %v   | Read Volume name(s) (only on director side)                  |
| %V   | Write Volume name(s) (only on director side)                 |
| %w   | Storage name (only on director side)                         |
| %x   | Spooling enabled? (“yes” or “no”)                            |

Some character substitutions are not available in all situations.

The Job Exit Status code %e edits the following values:

- OK
- Error
- Fatal Error
- Canceled
- Differences
- Unknown term code

Thus if you edit it on a command line, you will need to enclose it within some sort of quotes.

You can use these following shortcuts:

| Keyword                                                      | RunsOnSuccess | RunsOnFailure | FailJobOnError | Runs On Client | RunsWhen |
| ------------------------------------------------------------ | ------------- | ------------- | -------------- | -------------- | -------- |
| [`Run Before Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunBeforeJob) |               |               | Yes            | No             | Before   |
| [`Run After Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterJob) | Yes           | No            |                | No             | After    |
| [`Run After Failed Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunAfterFailedJob) | No            | Yes           |                | No             | After    |
| [`Client Run Before Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunBeforeJob) |               |               | Yes            | Yes            | Before   |
| [`Client Run After Job (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunAfterJob) | Yes           | No            |                | Yes            | After    |

Examples:

```
Run Script {
  RunsWhen = Before
  FailJobOnError = No
  Command = "/etc/init.d/apache stop"
}

RunScript {
  RunsWhen = After
  RunsOnFailure = Yes
  Command = "/etc/init.d/apache start"
}

RunScript {
  RunsWhen = Before
  FailJobOnError = Yes
  Command = "sh -c 'top -b -n 1 > /var/backup/top.out'"
}
```

**Special Windows Considerations**

You can run scripts just after snapshots initializations with *AfterVSS* keyword.

In addition, for a Windows client, please take note that you must  ensure a correct path to your script. The script or program can be a  .com, .exe or a .bat file. If you just put the program name in then  Bareos will search using the same rules that cmd.exe uses (current  directory, Bareos bin directory, and PATH). It will even try the  different extensions in the same order as cmd.exe. The command can be  anything that cmd.exe or command.com will recognize as an executable  file.

However, if you have slashes in the program name then Bareos figures  you are fully specifying the name, so you must also explicitly add the  three character extension.

The command is run in a Win32 environment, so Unix like commands will not work unless you have installed and properly configured Cygwin in  addition to and separately from Bareos.

The System %Path% will be searched for the command. (under the  environment variable dialog you have have both System Environment and  User Environment, we believe that only the System environment will be  available to bareos-fd, if it is running as a service.)

System environment variables can be referenced with %var% and used as either part of the command name or arguments.

So if you have a script in the Bareos bin directory then the following lines should work fine:

```
        Client Run Before Job = "systemstate"
or
        Client Run Before Job = "systemstate.bat"
or
        Client Run Before Job = "\"C:/Program Files/Bareos/systemstate.bat\""
```



- Save File History[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SaveFileHistory)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes Since Version: 14.2.0  Allow disabling storing  the file history, as this causes problems problems with some  implementations of NDMP (out-of-order metadata). With [`File History Size (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_FileHistorySize) the maximum number of files and directories inside a NDMP job can be configured.  Warning The File History is required to do a single file restore from NDMP backups. With this disabled, only full restores are possible.

- Schedule

  Type: RES

  Schedule 指令定义作业使用的时间表。The schedule in turn determines when the Job will be automatically  started and what Job level (i.e. Full, Incremental, …) is to be run. 调度进而确定何时自动启动作业以及要运行的作业级别（即完整、增量等）。此指令是可选的，如果省略此指令，则只能使用 Console 程序手动启动作业。Although you may specify only a  single Schedule resource for any one job, the Schedule resource may  contain multiple Run directives, which allow you to run the Job at many  different times, and each run directive permits overriding the default Job Level  Pool, Storage, and Messages resources. This gives considerable  flexibility in what can be done with a single Job. 虽然您可以为任何一个作业只指定一个计划资源，但计划资源可能包含多个运行指令，这些指令允许您在许多不同的时间运行作业，并且每个运行指令都允许覆盖默认的作业级别池、存储和消息资源。这就给了我们很大的灵活性，可以用一个单一的工作。

- SD Plugin Options[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SdPluginOptions)

  Type: [`STRING_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  These settings are plugin specific, see [Storage Daemon Plugins](https://docs.bareos.org/master/TasksAndConcepts/Plugins.html#sdplugins).

- Selection Pattern[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string)  Selection Patterns is only used for Copy and Migration jobs, see [Migration and Copy](https://docs.bareos.org/master/TasksAndConcepts/MigrationAndCopy.html#migrationchapter). The interpretation of its value depends on the selected [`Selection Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionType). For the OldestVolume and SmallestVolume, this Selection pattern is not used (ignored). For the Client, Volume, and Job keywords, this pattern must be a  valid regular expression that will filter the appropriate item names  found in the Pool. For the SQLQuery keyword, this pattern must be a valid **SELECT** SQL statement that returns JobIds. Example: `# SQL selecting all jobid in pool "Full" # which is a terminated backup (T,W) # and was never copied or migrated (PriorJobid 0). Job {    Name = "<name>"    JobDefs = "DefaultJob"    Type = Migrate    Selection Type = SQL Query    # Multiple lines instructions is available since version 21.0.0    Selection Pattern = "WITH pids AS            ( SELECT poolid FROM pool WHERE name = 'Full' )            SELECT jobid FROM job j, pids p            WHERE j.poolid=p.poolid            AND type='B'            AND jobstatus IN ('T','W')            AND priorjobid = 0;" } `

- Selection Type[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionType)

  Type: [`MIGRATION_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-migration_type)  Selection Type is only used for Copy and Migration jobs, see [Migration and Copy](https://docs.bareos.org/master/TasksAndConcepts/MigrationAndCopy.html#migrationchapter). It determines how a migration job will go about selecting what JobIds  to migrate. In most cases, it is used in conjunction with a [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) to give you fine control over exactly what JobIds are selected. The possible values are: SmallestVolumeThis selection keyword selects the volume  with the fewest bytes from the Pool to be migrated. The Pool to be  migrated is the Pool defined in the Migration Job resource. The  migration control job will then start and run one migration backup job  for each of the Jobs found on this Volume. The Selection Pattern, if  specified, is not used. OldestVolumeThis selection keyword selects the volume  with the oldest last write time in the Pool to be migrated. The Pool to  be migrated is the Pool defined in the Migration Job resource. The  migration control job will then start and run one migration backup job  for each of the Jobs found on this Volume. The Selection Pattern, if  specified, is not used. ClientThe Client selection type, first selects all the  Clients that have been backed up in the Pool specified by the Migration  Job resource, then it applies the [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) as a regular expression to the list of Client names, giving a filtered  Client name list. All jobs that were backed up for those filtered  (regexed) Clients will be migrated. The migration control job will then  start and run one migration backup job for each of the JobIds found for those filtered Clients. VolumeThe Volume selection type, first selects all the  Volumes that have been backed up in the Pool specified by the Migration  Job resource, then it applies the [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) as a regular expression to the list of Volume names, giving a filtered  Volume list. All JobIds that were backed up for those filtered (regexed) Volumes will be migrated. The migration control job will then start and run one migration backup job for each of the JobIds found on those filtered Volumes. JobThe Job selection type, first selects all the Jobs (as defined on the [`Name (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Name) directive in a Job resource) that have been backed up in the Pool specified by the Migration Job resource, then it applies the [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) as a regular expression to the list of Job names, giving a filtered Job name list. All JobIds that were run for those filtered (regexed) Job  names will be migrated. Note, for a given Job named, they can be many jobs (JobIds) that ran. The migration  control job will then start and run one migration backup job for each of the Jobs found. SQLQueryThe SQLQuery selection type, used the [`Selection Pattern (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionPattern) as an SQL query to obtain the JobIds to be migrated. The Selection  Pattern must be a valid SELECT SQL statement for your SQL engine, and it must return the JobId as the first field of the SELECT. PoolOccupancyThis selection type will cause the  Migration job to compute the total size of the specified pool for all  Media Types combined. If it exceeds the [`Migration High Bytes (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_MigrationHighBytes) defined in the Pool, the Migration job will migrate all JobIds  beginning with the oldest Volume in the pool (determined by Last Write  time) until the Pool bytes drop below the [`Migration Low Bytes (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_MigrationLowBytes) defined in the Pool. This calculation should be consider rather approximative because it is made once by the  Migration job before migration is begun, and thus does not take into  account additional data written into the Pool during the migration. In  addition, the calculation of the total Pool byte size is based on the  Volume bytes saved in the Volume (Media) database entries. The bytes  calculate for Migration is based on the value stored in the Job records  of the Jobs to be migrated. These do not include the Storage daemon overhead as is in the total Pool size. As a consequence, normally, the  migration will migrate more bytes than strictly necessary. PoolTimeThe PoolTime selection type will cause the  Migration job to look at the time each JobId has been in the Pool since  the job ended. All Jobs in the Pool longer than the time specified on [`Migration Time (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_MigrationTime) directive in the Pool resource will be migrated. PoolUncopiedJobsThis selection which copies all jobs from a pool to an other pool which were not copied before is available only for copy Jobs.

- Spool Attributes[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolAttributes)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Is Spool Attributes is disabled, the File attributes are sent by the  Storage daemon to the Director as they are stored on tape. However, if  you want to avoid the possibility that database updates will slow down  writing to the tape, you may want to set the value to **yes**, in which case the Storage daemon will buffer the File attributes and  Storage coordinates to a temporary file in the Working Directory, then  when writing the Job data to the tape is completed, the attributes and storage coordinates will be sent to the Director. NOTE: When [`Spool Data (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolData) is set to yes, Spool Attributes is also automatically set to yes. For details, see [Data Spooling](https://docs.bareos.org/master/TasksAndConcepts/DataSpooling.html#section-spooling).

- Spool Data[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolData)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If this directive is set to **yes**, the Storage daemon  will be requested to spool the data for this Job to disk rather than  write it directly to the Volume (normally a tape). Thus the data is written in large blocks to the Volume rather than  small blocks. This directive is particularly useful when running  multiple simultaneous backups to tape. Once all the data arrives or the  spool files’ maximum sizes are reached, the data will be despooled and  written to tape. Spooling data prevents interleaving data from several job and reduces or eliminates tape drive stop and start commonly known as “shoe-shine”. We don’t recommend using this option if you are writing to a disk  file using this option will probably just slow down the backup jobs. NOTE: When this directive is set to yes, [`Spool Attributes (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolAttributes) is also automatically set to yes. For details, see [Data Spooling](https://docs.bareos.org/master/TasksAndConcepts/DataSpooling.html#section-spooling).

- Spool Size[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SpoolSize)

  Type: [`SIZE64`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-size64)  This specifies the maximum spool size for this job. The default is taken from [`Maximum Spool Size (Sd->Device)`](https://docs.bareos.org/master/Configuration/StorageDaemon.html#config-Sd_Device_MaximumSpoolSize) limit.

- Storage[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Storage)

  Type: [`RESOURCE_LIST`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-resource_list)  The Storage directive defines the name of the storage services where  you want to backup the FileSet data. For additional details, see the [Storage Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourcestorage) of this manual. The Storage resource may also be specified in the Job’s Pool resource, in which case the value in the Pool resource overrides  any value in the Job. This Storage resource definition is not required  by either the Job resource or in the Pool, but it must be specified in  one or the other, if not an error will result.

- Strip Prefix

  Type: STRING

  此指令仅适用于还原作业，并指定要从要还原的所有文件的目录名称中删除的前缀。specifies a prefix  to remove from the directory name of all files being restored.这将使用文件重新定位 [File Relocation](https://docs.bareos.org/master/TasksAndConcepts/TheRestoreCommand.html#filerelocation) 功能。使用 `Strip Prefix=/etc` ，`/etc/passwd` 将被恢复为 `/passwd` 。

  在 Windows 下，如果要将 `c:/files` 还原为 `d:/files` ，可以使用：

  ```bash
  Strip Prefix = c:
  Add Prefix = d:
  ```

- Type

  Required: True

  Type: JOB_TYPE

  Type 指令指定作业类型，它是以下类型之一：

  * Backup

    运行备份作业。通常情况下，对于要保存的每个客户端，您至少有一个备份作业。通常情况下，除非您关闭编目，否则有关备份文件的大多数重要统计信息和数据都将放在编目中。unless you turn off cataloging, most  all the important statistics and data concerning files backed up will be placed in the catalog. 

  * Restore

    运行还原作业。通常，you will specify only one Restore job which acts  as a sort of prototype that you will modify using the console program in order to perform restores. 您将只指定一个还原作业，该作业充当一种原型，您将使用控制台程序修改该原型以执行还原。尽管还原作业中的某些基本信息保存在目录中，但与为备份作业存储的信息相比，这些信息非常少-例如，由于未保存文件，因此不会生成文件数据库条目。Although certain basic information from a  Restore job is saved in the catalog, it is very minimal compared to the  information stored for a Backup job – for example, no File database  entries are generated since no Files are saved. 

    Restore jobs cannot be automatically started by the scheduler as is  the case for Backup, Verify and Admin jobs. 还原作业不能像备份、验证和管理作业那样由计划程序自动启动。要还原文件，必须使用控制台中的 restore 命令。

  * Verify

    Run a  verify Job. In general, verify jobs permit you to compare the contents  of the catalog to the file system, or to what was backed up. In  addition, to verifying that a tape that was written can be read, you can also use verify as a sort of tripwire intrusion detection. 
  
  * Admin
  
    Run an  admin Job. An Admin job can be used to periodically run catalog pruning, if you do not want to do it at the end of each Backup Job. Although an  Admin job is recorded in the catalog, very little data is saved.
  
  * Migrate
  
    defines the job that is run as being a Migration  Job. A Migration Job is a sort of control job and does not have any  Files associated with it, and in that sense they are more or less like  an Admin job. Migration jobs simply check to see if there is anything to Migrate then possibly start and control new Backup jobs to migrate the  data from the specified Pool to another Pool. Note, any original JobId  that is migrated will be marked as having been migrated, and the  original JobId can nolonger be used for restores; all restores will be done from the new migrated  Job. 
  
  * Copy
  
    defines the job that is run as being a Copy Job. A  Copy Job is a sort of control job and does not have any Files associated with it, and in that sense they are more or less like an Admin job.  Copy jobs simply check to see if there is anything to Copy then possibly start and control new Backup jobs to copy the data from the specified  Pool to another Pool. Note that when a copy is made, the original JobIds are left unchanged. The new copies can not be used for restoration  unless you specifically choose them by JobId. If you subsequently delete a JobId  that has a copy, the copy will be automatically upgraded to a Backup  rather than a Copy, and it will subsequently be used for restoration.
  
  * Consolidate
  
    is used to consolidate Always Incremental Backups jobs, see [Always Incremental Backup Scheme](https://docs.bareos.org/master/TasksAndConcepts/AlwaysIncrementalBackupScheme.html#section-alwaysincremental). It has been introduced in Bareos *Version >= 16.2.4*.

​       Within a particular Job Type, there are also Levels, see [`Level (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Level).在特定的工作类型中，也有级别，请参阅级别（Dir->Job）。

- Verify Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VerifyJob)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  *This directive is an alias.* If you run a verify job without this directive, the last job run will be compared with the catalog, which means that you must immediately  follow a backup by a verify command. If you specify a Verify Job Bareos  will find the last job with that name that ran. This permits you to run  all your backups, then run Verify jobs on those that you wish to be  verified (most often a VolumeToCatalog) so that the tape just written is re-read.

- Virtual Full Backup Pool[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VirtualFullBackupPool)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Virtual Full Backup Pool specifies a Pool to be used for Virtual Full backups. It will override any [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) specification during a Virtual Full backup.

- Where

  Type: DIRECTORY

  This directive applies only to a Restore job and specifies a prefix  to the directory name of all files being restored. This permits files to be restored in a different location from which they were saved. If  Where is not specified or is set to backslash (/), the files will be  restored to their original location. By default, we have set Where in  the example configuration files to be /tmp/bareos-restores. This is to  prevent accidental overwriting of your files. 

  > Warning
  >
  > To use Where on NDMP backups, please read [Restore files to different path](https://docs.bareos.org/master/TasksAndConcepts/NdmpBackupsWithBareos.html#section-ndmp-where)

- Write Bootstrap

  Type: DIRECTORY_OR_COMMAND
  
  writebootstrap 指令指定一个文件名，Bareos 将在其中为每个备份作业运行写入引导文件。此指令仅适用于备份作业。如果备份作业是 Full 保存，Bareos 将在写入引导记录之前擦除指定文件的任何当前内容。如果作业是 Incremental 或 Differential 保存，则 Bareos 会将当前引导记录附加到文件的末尾。
  
  使用此功能，permits you to constantly have a bootstrap file  that can recover the current state of your system. 允许您不断地拥有可以恢复系统当前状态的引导文件。通常，the file  specified should be a mounted drive on another machine, 指定的文件应该是另一台机器上的一个挂载驱动器，这样，如果您的硬盘丢失，您将立即有一个可用的引导记录。或者，您应该在更新引导文件后将其复制到另一台计算机。请注意，最好为每个备份的作业（包括备份目录数据库的作业）编写单独的引导文件。it is a good idea to write a separate bootstrap file for each Job backed up including the job that backs up  your catalog database.
  
  If the bootstrap-file-specification begins with a vertical bar (|),  Bareos will use the specification as the name of a program to which it  will pipe the bootstrap record. 如果引导程序文件规范以竖线开始（|），Bareos将使用该规范作为程序的名称，它将引导记录输送到该程序。It could for example be a shell script  that emails you the bootstrap record.例如，它可以是一个shell脚本，通过电子邮件向您发送引导记录。
  
  Before opening the file or executing the specified command, Bareos performs [character substitution](https://docs.bareos.org/master/Configuration/Director.html#character-substitution) like in RunScript directive. 在打开文件或执行指定的命令之前，Bareos会像RunScript指令一样执行字符替换。要自动管理引导文件，您可以在 JobDefs 资源中使用以下命令：
  
  ```bash
  Job Defs {
  	...
      Write Bootstrap = "%c_%n.bsr"
      ...
  }
  ```

- Write Verify List[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_WriteVerifyList)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)

以下是有效作业资源定义的示例：

```bash
Job {
  Name = "Minou"
  Type = Backup
  Level = Incremental                 # default
  Client = Minou
  FileSet="Minou Full Set"
  Storage = DLTDrive
  Pool = Default
  Schedule = "MinouWeeklyCycle"
  Messages = Standard
}
```

## JobDefs 资源

The JobDefs resource permits all the same directives that can appear  in a Job resource.JobDefs 资源允许出现在作业资源中的所有相同指令。但是，JobDefs 资源不会创建作业，而是可以在作业中引用它以提供该作业的默认值。这允许您简洁地定义几个几乎相同的作业，每个作业引用一个包含默认值的 JobDefs 资源。Only the changes from the defaults need to be mentioned in each Job.在每个作业中只需要提及默认值的更改。

## Schedule 资源

The Schedule resource provides a means of automatically scheduling a  Job as well as the ability to override the default Level, Pool, Storage  and Messages resources. 调度资源提供了一种自动调度作业的方法，以及覆盖默认级别、池、存储和消息资源的能力。如果作业中未引用计划资源，则只能手动运行作业。通常，您指定要采取的操作以及何时采取。

| configuration directive name                                 | type of data           | default value | remark       |
| ------------------------------------------------------------ | ---------------------- | ------------- | ------------ |
| [`Description (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Description) | = STRING               |               |              |
| [`Enabled (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Enabled) | = BOOLEAN              | yes           |              |
| [`Name (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Name) | **= NAME**             |               | **required** |
| [`Run (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Run) | = SCHEDULE_RUN_COMMAND |               |              |

- `Description`

  Type:STRING

- `Enabled`

  Type:BOOLEAN

  Default value:yes

  启用或禁用此资源。

- `Name`

  Required:True

  Type:NAME

  The name of the schedule being defined.资源的名称。正在定义的计划的名称。

- `Run`

  Type:SCHEDULE_RUN_COMMAND
  
  Run 指令定义作业何时运行，以及应用什么覆盖（如果有的话）and what overrides if any to apply。您可以在一个调度资源中指定多个 run 指令。如果您这样做，它们都将被应用（即多个计划）。如果你有两个同时启动的 Run 指令，那么两个 Job 将同时启动（好吧，彼此在一秒之内）。
  
  The Job-overrides permit overriding the Level, the Storage, the  Messages, and the Pool specifications provided in the Job resource. In  addition, the FullPool, the IncrementalPool, and the DifferentialPool  specifications permit overriding the Pool specification according to  what backup Job Level is in effect.
  
  作业覆盖允许覆盖作业资源中提供的级别、存储、消息和池规范。此外，FullPool、IncrementalPool和DifferentialPool规范允许根据有效的备份作业级别覆盖池规范。
  
  By the use of overrides, you may customize a particular Job. 通过使用覆盖，您可以自定义特定的作业。例如，您可以为增量备份指定消息覆盖，将消息输出到日志文件，但对于每周或每月完整备份，您可以使用不同的消息覆盖通过电子邮件发送输出。you may specify a Messages override for your Incremental  backups that outputs messages to a log file, but for your weekly or  monthly Full backups, you may send the output by email by using a  different Messages override.
  
  Job-overrides are specified as: keyword=value where the keyword is  Level, Storage, Messages, Pool, FullPool, DifferentialPool, or  IncrementalPool, and the value is as defined on the respective directive formats for the Job resource. You may specify multiple Job-overrides on one Run directive by separating them with one or more spaces or by  separating them with a trailing comma. 作业覆盖被指定为：keyword=value，其中关键字是Level、Storage、Messages、Pool、FullPool、DifferentialPool或IncrementalPool，并且值是在作业资源的相应指令格式上定义的。您可以在一个Run指令上指定多个Job-overrides，方法是用一个或多个空格分隔它们，或者用一个尾随逗号分隔它们。举例来说：
  
  * Level=Full
  
    is all files in the FileSet whether or not they have changed. 是文件集中的所有文件，无论它们是否已更改。
  
  * Level=Incremental
  
    is all files that have changed since the last backup.是自上次备份以来更改的所有文件。
  
  * Pool=Weekly
  
    specifies to use the Pool named Weekly.指定使用名为Weekly的池。
  
  * Storage=DLT_Drive
  
    specifies to use DLT_Drive for the storage device.指定对存储设备使用DLT_Drive。
  
  * Messages=Verbose
  
    specifies to use the Verbose message resource for the Job.指定对作业使用详细消息资源。
  
  * FullPool=Full
  
    specifies to use the Pool named Full if the job is a full backup, or is upgraded from another type to a full backup.指定在作业为完整备份或从其他类型升级为完整备份时使用名为Full的池。
  
  * DifferentialPool=Differential
  
    specifies to use the Pool named Differential if the job is a differential backup.指定如果作业是差异备份，则使用名为差异的池。
  
  * IncrementalPool=Incremental
  
    specifies to use the Pool named Incremental if the job is an incremental backup.指定在作业为增量备份时使用名为Incremental的池。
  
  * Accurate=yes|no
  
    tells Bareos to use or not the Accurate code for the specific job. It  can allow you to save memory and and CPU resources on the catalog server in some cases.告诉Bareos使用或不使用特定作业的Accurate代码。在某些情况下，它可以让您在目录服务器上保存内存和CPU资源。
  
  * SpoolData=yes|no
  
    tells Bareos to use or not to use spooling for the specific job.告诉Bareos对特定作业使用或不使用假脱机。
  
  Date-time-specification日期-时间-规范确定何时运行作业。The  specification is a repetition, and as a default Bareos is set to run a  job at the beginning of the hour of every hour of every day of every  week of every month of every year.规范是重复的，作为默认值，Bareos 被设置为在每年每个月每个月每个星期每个小时的开始运行作业。这通常不是您想要的，因此您必须指定或限制希望作业运行的时间。Any  specification given is assumed to be repetitive in nature and will serve to override or limit the default repetition. 任何给定的规范都被认为是重复的，并将用于覆盖或限制默认的重复。This is done by specifying masks or times for the hour, day of the month, day of the week, week of the month, week of the year, and month when you want the job to run. 这是通过为希望运行作业的小时、月中的日、周中的日、月中的周、年中的周和月指定掩码或时间来实现的。通过指定上述一个或多个选项，您可以定义一个计划，以几乎任何您想要的频率重复。
  
  基本上，you must supply a month, day, hour, and minute the Job is  to be run.你必须提供一个月，一天，一小时，一分钟的工作是要运行。在要指定的这四个项目中，day 是特殊的，因为您可以指定一个月中的某一天，如 1，2，... 31，也可以指定一周中的某一天，如 Monday，Tuesday，... Sunday 。最后，you may also specify a week qualifier to restrict the schedule to the  first, second, third, fourth, or fifth week of the month.您还可以指定一个周限定符，以将计划限制为每月的第一、第二、第三、第四或第五周。
  
  if you specify only a day of the week, such as Tuesday  the Job will be run every hour of every Tuesday of every Month. That is  the month and hour remain set to the defaults of every month and all  hours.例如，如果仅指定一周中的某一天（如星期二），则作业将在每个月的每个星期二的每个小时运行。也就是说，月份和小时仍然设置为每个月和所有小时的默认值。
  
  注意，by default with no other specification, your job will run at  the beginning of every hour. If you wish your job to run more than once  in any given hour, you will need to specify multiple run specifications  each with a different minute.默认情况下，如果没有其他规范，作业将在每小时开始时运行。如果您希望作业在任何给定的小时内运行多次，则需要指定多个运行规范，每个运行规范具有不同的分钟。
  
  在 pseudo-BNF 中，可以通过以下方式指定运行作业的日期/时间：
  
  ```bash
  <week-keyword>         ::= 1st | 2nd | 3rd | 4th | 5th | first | second | third | fourth | fifth | last
  <wday-keyword>         ::= sun | mon | tue | wed | thu | fri | sat | sunday | monday | tuesday | wednesday | thursday | friday | saturday
  <week-of-year-keyword> ::= w00 | w01 | ... w52 | w53
  <month-keyword>        ::= jan | feb | mar | apr | may | jun | jul | aug | sep | oct | nov | dec | january | february | ... | december
  <digit>                ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0
  <number>               ::= <digit> | <digit><number>
  <12hour>               ::= 0 | 1 | 2 | ... 12
  <hour>                 ::= 0 | 1 | 2 | ... 23
  <minute>               ::= 0 | 1 | 2 | ... 59
  <day>                  ::= 1 | 2 | ... 31
  <time>                 ::= <hour>:<minute> | <12hour>:<minute>am | <12hour>:<minute>pm
  <time-spec>            ::= at <time> | hourly
  <day-range>            ::= <day>-<day>
  <month-range>          ::= <month-keyword>-<month-keyword>
  <wday-range>           ::= <wday-keyword>-<wday-keyword>
  <range>                ::= <day-range> | <month-range> | <wday-range>
  <modulo>               ::= <day>/<day> | <week-of-year-keyword>/<week-of-year-keyword>
  <date>                 ::= <date-keyword> | <day> | <range>
  <date-spec>            ::= <date> | <date-spec>
  <day-spec>             ::= <day> | <wday-keyword> | <day> | <wday-range> | <week-keyword> <wday-keyword> | <week-keyword> <wday-range> | daily
  <month-spec>           ::= <month-keyword> | <month-range> | monthly
  <date-time-spec>       ::= <month-spec> <day-spec> <time-spec>
  ```

请注意，the Week of Year specification wnn follows the ISO standard  definition of the week of the year, where Week 1 is the week in which  the first Thursday of the year occurs, or alternatively, the week which  contains the 4th of January. wnn的Week of Year规范遵循ISO标准定义，其中Week 1是一年中的第一个星期四所在的星期，或者包含1月4日的星期。周数从 w01 到 w53 。w00 for  Bareos is the week that precedes the first ISO week (i.e. has the first  few days of the year if any occur before Thursday).对于Bareos，w00是ISO第一周之前的一周（即，如果在星期四之前发生，则具有一年中的前几天）。ISO 规范中没有定义 w00 。一个星期从星期一开始到星期天结束。

According to the NIST (US National Institute of Standards and  Technology), 12am and 12pm are ambiguous and can be defined to anything. However, 12:01am is the same as 00:01 and 12:01pm is the same as 12:01, so Bareos defines 12am as 00:00 (midnight) and 12pm as 12:00 (noon). 

根据 NIST（美国国家标准与技术研究所）的说法，12am 和 12pm 是模糊的，可以定义为任何东西。但是，12：01 am和00：01是一样的，12：01 pm和12：01是一样的，所以Bareos将12 am定义为00：00（午夜），12 pm定义为12：00（中午）。您可以通过使用 24 小时时间规范（即没有上午/下午）来避免这种不确定性（混淆）。

以下是一个名为 WeeklyCycle 的调度资源示例，它在每个星期日的凌晨 2:05 运行一个具有 full 级别的作业，在星期一到星期六的凌晨 2:05 运行一个 incremental 作业：

```bash
Schedule {
  Name = "WeeklyCycle"
  Run = Level=Full sun at 2:05
  Run = Level=Incremental mon-sat at 2:05
}
```

An example of a possible monthly cycle is as follows:可能的月周期的示例如下：

```bash
Schedule {
  Name = "MonthlyCycle"
  Run = Level=Full Pool=Monthly 1st sun at 2:05
  Run = Level=Differential 2nd-5th sun at 2:05
  Run = Level=Incremental Pool=Daily mon-sat at 2:05
}
```

每个月的第一天：

```bash
Schedule {
  Name = "First"
  Run = Level=Full on 1 at 2:05
  Run = Level=Incremental on 2-31 at 2:05
}
```

The last friday of the month (i.e. the last friday in the last week of the month)该月的最后一个星期五（即该月最后一个星期的最后一个星期五）

```bash
Schedule {
  Name = "Last Friday"
  Run = Level=Full last fri at 21:00
}
```

每 10 分钟：

```bash
Schedule {
  Name = "TenMinutes"
  Run = Level=Full hourly at 0:05
  Run = Level=Full hourly at 0:15
  Run = Level=Full hourly at 0:25
  Run = Level=Full hourly at 0:35
  Run = Level=Full hourly at 0:45
  Run = Level=Full hourly at 0:55
}
```

The modulo scheduler makes it easy to specify schedules like odd or  even days/weeks, or more generally every n days or weeks. It is called  modulo scheduler because it uses the modulo to determine if the schedule must be run or not. The second variable behind the slash lets you  determine in which cycle of days/weeks a job should be run. The first  part determines on which day/week the job should be run first. E.g. if  you want to run a backup in a 5-week-cycle, starting on week 3, you set  it up as w03/w05.

模调度器可以很容易地指定奇数或偶数天/周，或者更一般地每n天或每n周的调度。它被称为模调度器，因为它使用模来确定调度是否必须运行。斜线后面的第二个变量用于确定作业应该在哪个天/周的周期中运行。第一部分确定作业应在哪一天/星期首先运行。例如，如果你想在5周的周期内运行备份，从第3周开始，你将其设置为w 03/w 05。

```bash
Schedule {
  Name = "Odd Days"
  Run = 1/2 at 23:10
}

Schedule {
  Name = "Even Days"
  Run = 2/2 at 23:10
}

Schedule {
  Name = "On the 3rd week in a 5-week-cycle"
  Run = w03/w05 at 23:10
}

Schedule {
  Name = "Odd Weeks"
  Run = w01/w02 at 23:10
}

Schedule {
  Name = "Even Weeks"
  Run = w02/w02 at 23:10
}
```

### Technical Notes on Schedules附表的技术说明

Internally Bareos keeps a schedule as a bit mask.  There are six masks and a minute field to each schedule. The masks are  hour, day of the month (mday), month, day of the week (wday), week of  the month (wom), and week of the year (woy). The schedule is initialized to have the bits of each of these masks set, which means that at the  beginning of every hour, the job will run. When you specify a month for  the first time, the mask will be cleared and the bit corresponding to  your selected month will be selected. If you specify a second month, the bit corresponding to it  will also be added to the mask. Thus when Bareos checks the masks to see if the bits are set corresponding to the current time, your job will  run only in the two months you have set. Likewise, if you set a time  (hour), the hour mask will be cleared, and the hour you specify will be  set in the bit mask and the minutes will be stored in the minute field.

在内部，Bareos保持一个时间表作为位掩码。每个时间表有六个掩码和一个分钟字段。这些掩码是小时、月的第几天（mday）、月、周的第几天（wday）、月的第几周（wom）和年的第几周（woy）。调度被初始化为设置每个掩码的位，这意味着在每个小时的开始，作业将运行。当您第一次指定月份时，掩码将被清除，并选择与所选月份对应的位。如果指定第二个月，则与之对应的位也将添加到掩码中。因此，当Bareos检查掩码以查看是否设置了与当前时间相对应的位时，您的作业将仅在您设置的两个月内运行。同样，如果您设置时间（小时），小时掩码将被清除，您指定的小时将被设置在位掩码中，分钟将被存储在分钟字段中。

For any schedule you have defined, you can see how these bits are set by doing a show schedules command in the Console program. Please note  that the bit mask is zero based, and Sunday is the first day of the week (bit zero).

对于您定义的任何计划，您可以通过在Console程序中执行show schedules命令来查看这些位是如何设置的。请注意，位掩码是从零开始的，星期日是一周的第一天（位零）。

## FileSet 资源

It consists of a list of files or directories to be  included, a list of files or directories to be excluded and the various  backup options such as compression, encryption, and signatures that are  to be applied to each file.

FileSet 资源定义备份作业中要包括或排除的文件。每个备份作业都需要一个 FileSet 资源。它包括要包括的文件或目录列表、要排除的文件或目录列表以及要应用于每个文件的各种备份选项，如压缩、加密和签名。

对包含的文件列表的任何更改都将导致Bareos自动创建一个新的FileSet（由名称和Include/Include File指令内容的MD5校验和定义）。每次创建新的FileSet时，Bareos将确保下一次备份始终是完整备份。但是，这只适用于指令File（Dir-> Film->Include）和File（Dir-> Film-> Include）中的更改。其他指令或文件集选项资源中的更改不会导致升级到完整备份。使用“忽略文件集更改”（Dir-> Filtrate）来禁用此行为。

Any change to the list of the included files will cause Bareos to automatically create a new FileSet (defined by the name and an MD5 checksum of the Include/Exclude File directives contents). Each time a new FileSet is created Bareos will ensure that the next backup is always a full backup. However, this does only apply to changes in directives `File (Dir->Fileset->Include)` and `File (Dir->Fileset->Exclude)`. Changes in other directives or the [FileSet Options Resource](https://docs.bareos.org/Configuration/Director.html#fileset-options) do not result in upgrade to a full backup. Use [`Ignore File Set Changes (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_IgnoreFileSetChanges) to disable this behavior.

| configuration directive name                                 | type of data             | default value | remark       |
| ------------------------------------------------------------ | ------------------------ | ------------- | ------------ |
| [`Description (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Description) | = STRING                 |               |              |
| [`Enable VSS (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_EnableVSS) | = BOOLEAN                | yes           |              |
| [`Exclude (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Exclude) | { INCLUDE_EXCLUDE_ITEM } |               |              |
| [`Ignore File Set Changes (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_IgnoreFileSetChanges) | = BOOLEAN                | no            |              |
| [`Include (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include) | { INCLUDE_EXCLUDE_ITEM } |               |              |
| [`Name (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Name) | **= NAME**               |               | **required** |

- `Description`

  Type: STRING

  Information only.

- `Enable VSS`

  Type: BOOLEAN

  Default value: yes

  如果将此指令设置为 yes ，则会通知文件守护程序用户希望为此作业使用卷影复制服务（VSS）备份。此指令仅对 Windows 文件守护程序有效。It permits a consistent copy of open files to be made for  cooperating writer applications, and for applications that are not VSS  away, Bareos can at least copy open files. 它允许为协作的writer应用程序创建打开文件的一致副本，对于不在VSS之外的应用程序，Bareos至少可以复制打开的文件。The Volume Shadow Copy will  only be done on Windows drives where the drive (e.g. C:, D:, …) is explicitly mentioned  in a **File** directive.卷影复制将仅在文件指令中明确提到驱动器（例如C：，D：，...）的Windows 驱动器上完成。

- `Exclude`

  Type: INCLUDE_EXCLUDE_ITEM

  描述应从备份中排除的文件。

- `Ignore File Set Changes`

  Type: BOOLEAN

  Default value: no

  if you modify `File (Dir->Fileset->Include)` or `File (Dir->Fileset->Exclude)` of the FileSet Include or Exclude lists, 通常情况下，如果您修改文件集包含或删除列表的文件（目录->文件->包含）或文件（目录->文件->删除），下一次备份将强制为完整备份，以便 Bareos 可以保证任何添加或删除都被正确保存。

  强烈建议不要将此指令设置为 yes ，因为这样做可能会导致备份集不完整。

  any changes you make to the FileSet Include or Exclude lists, will not force a Full during subsequent backups.如果将此指令设置为 yes ，则对文件集包含或删除列表所做的任何更改都不会在后续备份期间强制执行完整备份。

- `Include`

  Type: INCLUDE_EXCLUDE_ITEM

  描述应包含在备份中的文件。

- `Name`

  Required: True
  
  Type: NAME
  
  资源的名称。FileSet 资源的名称。

### FileSet Include 资源

Include 资源必须包含要在备份作业中处理的目录和/或文件的列表。

通常，all files found in all subdirectories of any directory in  the Include File list will be backed up. 将备份在“包括文件”列表中任何目录的所有子目录中找到的所有文件。The Include resource may also  contain one or more Options resources that specify options such as  compression to be applied to all or any subset of the files found when  processing the file-list for backup.Include 资源还可以包含一个或多个 Options 资源，这些资源指定选项，例如在处理文件列表以进行备份时要应用于找到的所有文件或任何文件子集的压缩。

There can be any number of Include resources within the FileSet, each having its own list of directories or files to be backed up and the  backup options defined by one or more Options resources.文件集中可以有任意数量的包含资源，每个包含资源都有自己的要备份的目录或文件列表以及由一个或多个 Options 资源定义的备份选项。

请注意 FileSet 语法中的以下项目：

1. 在 Include 之后和左大括号（`{`）之前没有等号（`=`）。对于 Exclude 来说，也是如此。
2. 要包含或排除的每个目录（或文件名）前面都有一个 `File =` 。以前，它们只是单独列在不同的行上。
3. Exclude 资源不接受选项。
4. 当使用通配符或正则表达式时，目录名总是以斜杠（`/`）结尾，文件名没有尾随的斜杠。

- `File`

  Type: “path”

  Type: “<includefile-server”

  Type: “\\\\<includefile-client”

  Type: “|command-server”

  Type: “\\\\|command-client”

  文件列表由每行一个文件或目录名组成。Directory names should be specified without a trailing slash with Unix  path notation. 目录名应该在 Unix 路径表示法中不带尾随斜杠。

  > Note
  >
  > Windows 用户，please take note to specify directories (even `c:/...`) in Unix path notation.请注意指定目录（即使是c：/...）Unix路径表示法。如果您使用 Windows 约定，则很可能无法恢复文件，因为 Windows 路径分隔符早在 Windows 存在之前就被定义为转义字符，而 Bareos 遵守该约定（即意味着下一个字符显示为本身）。

  应该始终为文件集中列出的每个目录和文件指定完整路径。此外，在 Windows 计算机上，you  should always prefix the directory or filename with the drive  specification (e.g. `c:/xxx`) using Unix directory name separators (forward slash). 您应该始终使用 Unix 目录名分隔符（正斜杠）将驱动器规范（例如c：/xxx）作为目录或文件名的前缀。驱动器号本身可以是大写或小写（例如 `c:/xxx` 或 `C:/xxx`）。

  文件项不能包含通配符。如果要指定通配符或正则表达式匹配，请使用文件集 option 资源中的指令。

  Bareos’s default for processing directories is to recursively descend in the directory saving all files and subdirectories. Bareos 处理目录的默认方式是递归地向下搜索保存所有文件和子目录的目录。默认情况下，Bareos 不会跨文件系统（或 Unix 术语中的挂载点）。这意味着如果您指定根分区（例如 `/` ），Bareos 将只保存根分区，而不保存任何其他挂载的文件系统。同样，在 Windows 系统上，必须明确指定要保存的每个驱动器（例如 `c:/` 和 `d:/` ...）。此外，至少对于 Windows 系统，您最有可能希望将每个规范用双引号括起来，特别是当目录（或文件）名包含空格时。

  请特别注意不要包含一个目录两次，否则 Bareos 默认情况下会将相同的文件备份两次，从而浪费存档设备上的大量空间。包含一个目录两次是非常容易做到的。举例来说：

  ```bash
  Include {
  	Options {
      	Compression = LZ4
      }
      File = /
      File = /usr
  }
  ```

  在 Unix 系统上，如果 `/usr` 是一个子目录（而不是一个挂载的文件系统），将导致 `/usr` 备份两次。使用 `Shadowing (Dir->Fileset->Include->Options)` 指令可以将 Bareos 配置为自动检测和排除重复项。

  若要 include 包含空格的名称，请将名称括在双引号之间。

  在指定目录和文件时有许多特殊情况。它们是：

  * `@filename`

    任何前面带有 at 符号（@）的名称都被假定为文件名，其中包含一个文件列表，每个文件前面都有一个 “`File =` "。The named file is read once when the configuration file is  parsed during the Director startup. 在 Director 启动期间分析配置文件时，将读取一次命名文件。请注意，文件是在 Director 的计算机上读取的，而不是在客户端的计算机上读取的。the @filename can  appear anywhere within a configuration file where a token would be read, and the contents of the named file will be logically inserted in the  place of the @filename. 事实上，@filename 可以出现在配置文件中任何读取标记的位置，并且命名文件的内容将逻辑地插入到 @filename 的位置。文件中必须包含的内容取决于 @filename 在 conf 文件中指定的位置。举例来说：

    ```bash
    Include {
    	Options {
        	compression = LZ4
        }
        @/home/files/my-files
    }
    ```

  * `File = "<includefile-server"`

    任何前面带有小于号（`<`）的文件项都将被视为一个文件。作业启动时，将在 Directo r计算机上读取此文件，并且假定数据是要包含的目录或文件列表，每行一个。名称应该从第 1 列开始，即使包含空格也不应该用引号括起来。此功能允许您修改外部文件并更改将保存的内容，而无需停止并重新启动 Bareos，如果使用上面提到的 @ 修饰符，则需要这样做。举例来说：

    ```bash
    Include {
    	Options {
        	Signature = XXH128
        }
        File = "</home/files/local-filelist"
    }
    ```

  * `File = "\\<includefile-client"`

    如果您在小于号（`<`）前面加上两个反斜杠，如 `\\<` 中所示，则文件列表将在客户端计算机上读取，而不是在 Director 计算机上读取。

    ```bash
    Include {
    	Options {
        	Signature = XXH128
        }
        File = "\\</home/xxx/filelist-on-client"
    }
    ```

  * `File = "|command-server"`

    任何以竖线开头的名称（|）被假定为程序的名称。此程序将在作业启动时（而不是在 Director 读取配置文件时）在 Director 的计算机上执行，并且该程序的任何输出都将被假定为要包含的文件或目录列表，每行一个。在提交指定的命令之前，Bareos 将执行字符替换。

    This allows you to have a job that, for example, includes all the  local partitions even if you change the partitioning by adding a disk.  The examples below show you how to do this.这允许您拥有一个作业，例如，即使您通过添加磁盘更改了分区，该作业也包括所有本地分区。下面的例子告诉你如何做到这一点。但是，请注意两件事：

    1. if you want the local filesystems, you probably should be using the `FS Type (Dir->Fileset->Include->Options)` directive and set `One FS (Dir->Fileset->Include->Options) = no`. 如果你想要本地文件系统，你可能应该使用 `FS Type (Dir->Fileset->Include->Options)` 指令并设置 `One FS (Dir->Fileset->Include->Options) = no` 。
    2. 下面的例子中所需的命令的确切语法是非常依赖于系统的。例如，在最近的 Linux 系统上，您可能需要添加 -P 选项，在 FreeBSD 系统上，选项也会有所不同。

    一般来说，您需要在命令前面加上 `sh -c` ，这样它们才能被 shell 调用。如果您像下面的第二个示例中那样调用脚本，则不会出现这种情况。此外，必须注意转义（前面加 `\` ）通配符、shell 字符，并确保命令中的任何空格也被转义。如果在双引号（“）中使用单引号（'），Bareos 将把单引号之间的所有内容视为一个字段，因此没有必要对空格进行转义。一般来说，正确使用所有引号和转义是一件实在痛苦的事情，正如您在下一个示例中看到的那样。因此，通常更容易将所有内容放在一个文件中，并简单地使用 Bareos 中的文件名。在这种情况下，如果文件的第一行是 `#!/bin/sh`，就不需要 `sh -c` 了。

    例如：

    ```bash
    Include {
       Options {
         Signature = XXH128
       }
       File = "|sh -c 'df -l | grep \"^/dev/hd[ab]\" | grep -v \".*/tmp\" | awk \"{print \\$6}\"'"
    }
    ```

    将生成 Linux 系统上所有本地分区的列表。引用是一个真实的问题，因为你必须为Bareos引用，它包括在每个 `\` 和每个 `“` 前面加上一个 `\` ，你还必须为 shell 命令引用。Quoting is a real problem because you must quote for Bareos which  consists of preceding every \ and every ” with a \, and you must also  quote for the shell command. 最后，执行一个脚本文件可能更容易：

    ```bash
    Include {
      Options {
        Signature = XXH128
      }
      File = "|my_partitions"
    }
    ```
    
    其中 my_partitions 有：

    ```bash
    #!/bin/sh
    df -l | grep "^/dev/hd[ab]" | grep -v ".*/tmp" \
          | awk "{print \$6}"
    ```
    
  * `File = "\\|command-client"`

    If the vertical bar (`|`) in front of **my_partitions** is preceded by a two backslashes as in `\\|`, 如果垂直条（`|`）在 my_partitions 前面加上两个反斜杠，如 `\\|` ，程序将在客户端的计算机上而不是在 Director 的计算机上执行。John Donagher 提供了一个备份远程系统上所有本地 UFS 分区的示例：

    ```bash
  FileSet {
      Name = "All local partitions"
      Include {
        Options {
          Signature = XXH128
          OneFs=yes
        }
        File = "\\|bash -c \"df -klF ufs | tail +2 | awk '{print \$6}'\""
      }
    }
    ```
  
    上面的代码需要在双引号后面加上两个反斜杠字符（一个保留下一个）。如果您是 Linux 用户，只需将 ufs 更改为 ext3（或者您喜欢的文件系统类型），就可以开始工作了。

    如果你知道你在系统上挂载了哪些文件系统，例如对于Linux只使用 ext2、ext3 或 ext4，你可以使用以下命令备份所有本地文件系统：

    ```bash
  Include {
       Options {
         Signature = XXH128
         OneFs = no
         FsType = ext2
         FsType = ext3
         FsType = ext4
       }
       File = /
    }
    ```
  
  * Raw Partition

    如果您显式地指定一个块设备，例如 `/dev/hda1` ，那么 Bareos 将假定这是一个要备份的原始分区。在这种情况下，强烈建议您指定 `Sparse=yes`  include 选项，否则，将保存整个分区，而不仅仅是分区包含的实际数据。举例来说：

    ```bash
    Include {
      Options {
        Signature = XXH128
        Sparse = yes
      }
      File = /dev/hd6
    }
    ```
  
    将备份 device `/dev/hd6` 中的数据。注意，`/dev/hd6` 必须是原始分区本身。如果您指定了一个指向原始设备的符号链接，例如由 LVM Snapshot 实用程序创建的，则 Bareos 不会将其作为原始设备进行备份。

- `Exclude Dir Containing`

  Type: filename
  
  此指令可以添加到 FileSet 资源的 Include 部分。如果在客户端上的任何要备份的目录中找到指定的文件名（文件名字符串），则整个目录将被忽略（不备份）。我们建议使用文件名 `.nobackup` ，因为它是 unix 系统上的隐藏文件，并解释了该文件的用途。
  
  举例来说：
  
  ```bash
  # List of files to be backed up
  FileSet {
    Name = "MyFileSet"
    Include {
      Options {
        Signature = XXH128
      }
      File = /home
      Exclude Dir Containing = .nobackup
    }
  }
  ```
  
  For example, with the above FileSet, if the user or sysadmin creates a file named .nobackup in specific directories, such as 
  
  但在 `/home` 中，可能有数百个用户目录，有些人希望表明他们不希望备份某些目录。例如，对于上述 FileSet ，如果用户或系统管理员在特定目录创建了一个名为 `.nobackup` 的文件，例如：
  
  ```bash
  /home/user/www/cache/.nobackup
  /home/user/temp/.nobackup
  ```
  
  那么 Bareos 将不会备份这两个目录：
  
  ```bash
  /home/user/www/cache
  /home/user/temp
  ```
  
  子目录也将不进行备份。也就是说，the directive applies  to the two directories in question and any children (be they files,  directories, etc).该指令适用于有问题的两个目录和任何子目录（无论是文件、目录等）。

- Plugin

  Type: “plugin-name”

  ​           “:plugin-parameter1”

  ​           “:plugin-parameter2”

  ​           “:…”

  除了指定文件之外，文件集还可以使用插件。插件是处理特定需求的附加库。The  purpose of plugins is to provide an interface to any system program for  backup and restore. 插件的目的是为任何系统程序提供一个接口，用于备份和恢复。That allows you, for example, to do database backups without a local dump. 例如，这允许您在没有本地转储的情况下进行数据库备份。

  The syntax and semantics of the Plugin directive require the first  part of the string up to the colon to be the name of the plugin.Plugin 指令的语法和语义要求字符串的第一部分到冒号是插件的名称。第一个冒号之后的所有内容都会被 File 守护进程忽略，但会传递给插件。Thus the plugin writer may define the meaning of  the rest of the string as he wishes. 因此，插件编写者可以按照自己的意愿定义字符串其余部分的含义。

  从 Version >= 20 开始，插件字符串可以使用引号分布在多行中，如上所示。

  It is also possible to define more than one plugin directive in a FileSet to do several database dumps at once.也可以在 FileSet 中定义多个 plugin 指令，以便同时执行多个数据库转储。


- Options

  See the [FileSet Options Resource](https://docs.bareos.org/Configuration/Director.html#fileset-options) section.

### FileSet Exclude 资源

FileSet Exclude 资源与 Include 资源非常相似，不同之处在于它们只允许以下指令：

- File

  Type: “path”

  Type: “<includefile-server”

  Type: “\\\\<includefile-client”

  Type: “|command-server”

  Type: “\\\\|command-client”

  Files to exclude are descripted in the same way as at the [FileSet Include Resource](https://docs.bareos.org/Configuration/Director.html#fileset-include). 要排除的文件将以与文件集包含资源中相同的方式被删除。

  举例来说：

  ```bash
  FileSet {
    Name = Exclusion_example
    Include {
      Options {
        Signature = XXH128
      }
      File = /
      File = /boot
      File = /home
      File = /rescue
      File = /usr
    }
    Exclude {
      File = /proc
      File = /tmp                          # Don't add trailing /
      File = .journal
      File = .autofsck
    }
  }
  ```

  另一种排除文件和目录的方法是在 Include 部分中使用 [`Exclude (Dir->Fileset->Include->Options) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Exclude) 设置。

### FileSet Options 资源

Options 资源是可选的，但是当指定时，it will contain a list of keyword=value options to be applied to the file-list. 它将包含要应用于file-list的keyword=value选项的列表。可以一个接一个地指定多个选项资源。Options will applied to the filenames to determine if  and how the file should be backed up.当在指定目录中找到文件时，选项将应用于文件名，以确定是否以及如何备份文件。Options 资源的通配符和正则表达式模式匹配部分将按照它们在 FileSet 中指定的顺序进行检查，直到第一个匹配为止。The wildcard and regular  expression pattern matching parts of the Options resources are checked  in the order they are specified in the FileSet until the first one that matches. Once one matches, the compression and other flags within the Options  specification will apply to the pattern matched.一旦匹配，选项规范中的压缩和其他标志将应用于匹配的模式。

一个关键点是，如果没有一个选项或没有其他选项匹配，每个文件都被接受备份。A key point is that in the absence of an Option or no other Option is matched, every file is accepted for backing up. This means that if you  want to exclude something, you must explicitly specify an Option with an exclude = yes and some pattern matching.这意味着，如果你想排除一些东西，你必须显式地指定一个带有exclude = yes和一些模式匹配的Option。

Once Bareos determines that the Options resource matches the file  under consideration, that file will be saved without looking at any  other Options resources that may be present. This means that any wild  cards must appear before an Options resource without wild cards.一旦Bareos确定选项资源与正在考虑的文件匹配，该文件将被保存，而不查看可能存在的任何其他选项资源。这意味着所有通配符都必须出现在不带通配符的选项资源之前。

If for some reason, Bareos checks all the Options resources to a file under consideration for backup, but there are no matches (generally  because of wild cards that don’t match), Bareos as a default will then  backup the file. This is quite logical if you consider the case of no  Options clause is specified, where you want everything to be backed up,  and it is important to keep in mind when excluding as mentioned above.如果由于某种原因，Bareos检查所有选项资源到正在考虑备份的文件，但没有匹配（通常是因为通配符不匹配），Bareos将默认备份该文件。如果考虑到没有指定Options子句的情况，这是非常合乎逻辑的，在这种情况下，您希望备份所有内容，并且在如上所述排除时记住这一点很重要。

然而，还有一点是，在没有找到匹配的情况下，Bareos 将使用在最后一个 Options 资源中找到的选项。As a consequence, if you want a particular set of “default” options, you should put them in an Options resource after any other Options.因此，如果您需要一组特定的“默认”选项，则应将它们放在Options资源中的任何其他Options之后。

将所有的通配符和正则表达式放在双引号内是一个好主意，以防止 conf 文件扫描问题。

This is perhaps a bit overwhelming, so there are a number of examples included below to illustrate how this works.这可能有点压倒性，所以下面有一些例子来说明这是如何工作的。

你会发现自己使用了很多 Regex 语句，这将花费大量的 CPU 时间，建议你尽可能简化它们，或者更好地将它们转换为 Wild 语句，这样效率会高得多。

选项资源中的指令可以是以下之一：

- Auto Exclude

  Type: BOOLEAN

  Default value: yes

  自动排除不用于备份的文件。当前仅用于 Windows ，用于排除注册表项中定义的文件 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\BackupRestore\FilesNotToBackup` 。

  Since *Version >= 14.2.2*.

- Compression

  Type: <GZIP|GZIP1|…|GZIP9|LZO|LZFAST|LZ4|LZ4HC>

  Configures the software compression to be used by the File Daemon. 配置文件守护程序要使用的软件压缩。压缩是在逐个文件的基础上完成的。

  如果您要写入到本身不支持压缩的设备（例如硬盘），则软件压缩变得非常重要。否则，所有现代磁带驱动器都支持硬件压缩。

  软件压缩也有助于减少所需的网络带宽，因为压缩是在文件守护程序上完成的。在大多数情况下，LZ4 是最好的选择，因为它相对较快。如果 LZ4 的压缩率不够好，你可以考虑 LZ4HC 。但是，不建议同时使用 Bareos 软件压缩和设备硬件压缩，as trying to compress precompressed data is a very CPU-intense task and probably end up in even larger data. 因为尝试压缩预压缩数据是一项非常CPU密集型的任务，并且可能最终导致更大的数据。

  您可以使用 [`Allow Compression (Dir->Storage) = no`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AllowCompression) 选项覆盖每个存储资源的此选项。

  * GZIP

    所有保存的文件都将使用 GNU ZIP 压缩格式进行软件压缩。

    GZIP 使用默认的压缩级别 6（即 GZIP 与 GZIP6 相同）。如果需要不同的压缩级别（1 到 9），可以通过在 GZIP 后面附加级别编号（中间不带空格）来指定。Thus **compression=GZIP1** would give minimum compression but the fastest algorithm, and **compression=GZIP9** would give the highest level of compression, but requires more computation. 因此，compression=GZIP1 将给予最小的压缩，但最快的算法，而 compression=GZIP9 将给出最高级别的压缩，但需要更多的计算。根据 GZIP 文档，compression levels greater than six generally give very little extra compression and are rather CPU intensive.大于 6 的压缩级别通常给予很少的额外压缩，并且相当 CPU 密集。

  * LZFAST

    自版本 19.2 起弃用。

    所有保存的文件将使用 LZFAST 压缩格式进行软件压缩。

    LZFAST 提供比 GZIP 快得多的压缩和解压缩速度，但压缩比较低。如果你的 CPU 足够快，你应该能够压缩你的数据，而不会使备份持续时间更长。

    > Warning
    >
    > 这是一种非标准的压缩算法，在将来的版本中可能会删除对使用它压缩备份的支持。请考虑使用其他算法替代。

  * LZO

    所有保存的文件将使用 LZO 压缩格式进行软件压缩。

    LZO 提供更快的压缩和解压缩速度，但比 GZIP 压缩率低。如果你的 CPU 足够快，你应该能够压缩你的数据，而不会使备份持续时间更长。

    请注意，Bareos 只使用 LZO 指定的一个压缩级别 LZO1X-1 。

  * LZ4

    所有保存的文件将使用 LZ4 压缩格式进行软件压缩。

    LZ4 提供更快的压缩和解压缩速度，但比 GZIP 压缩率低。如果你的 CPU 足够快，你应该能够压缩你的数据，而不会使备份持续时间更长。

    LZ4 和 LZ4HC 都具有相同的解压缩速度，大约是 LZO 压缩速度的两倍。因此，对于恢复，LZ4 和 LZ4HC 都是很好的候选。

  * LZ4HC

    保存的所有文件将使用 LZ4HC 压缩格式进行软件压缩。
    
    LZ4HC 是 LZ4 压缩的高压缩版本。它具有比 LZ4 更高的压缩比，并且在压缩率和 CPU 使用率方面与 GZIP-6 更具可比性。
    
    LZ4 和 LZ4HC 都具有相同的解压缩速度，大约是 LZO 压缩速度的两倍。因此，对于恢复，LZ4 和 LZ4HC 都是很好的候选。

- Signature

  Type: <MD5|SHA1|SHA256|SHA512|XXH128>

  It is strongly recommend to use signatures for your backups. 强烈建议使用签名进行备份。Note, only one type of signature can be computed per file.注意，每个文件只能计算一种类型的签名。

  你必须在速度和安全性之间找到正确的平衡。今天的 CPU 通常有特殊的指令，可以非常快地计算校验和。So if in doubt, testing the speed of the different signatures in  your environment will show what is the fastest algorithm. 因此，如果有疑问，在您的环境中测试不同签名的速度将显示最快的算法。XXH128 算法在密码学上并不安全，但它适用于非密码学目的（如计算校验和以避免数据损坏，如 Bareos 在这里使用的）。Bareos 建议将 XXH128 作为首选算法，因为它的计算需求大大降低。The calculation of the cryptographical checksum like MD5 or SHA has proven to be the bottleneck in  environments with high-speed requirements. MD5 或 SHA 等加密校验和的计算已被证明是高速要求环境中的瓶颈。

  * MD5

    将为每个保存的文件计算 MD5 签名（128 位）。添加此选项会为每个文件的保存产生大约 5% 的额外开销。除了额外的 CPU 时间外，MD5 签名还为 catalog 中的每个文件增加了 16 个字节。

  * SHA1

    将为每个保存的文件计算 SHA1（160 位）签名。SHA1 算法据称比 MD5 算法慢一些，but at the same time is significantly better from a cryptographic point of view (i.e. much fewer collisions). 但同时从加密的角度来看（即冲突少得多）。SHA1 签名要求为每个文件添加 20 个字节到 catalog 中。

  * SHA256

    将为每个保存的文件计算 SHA256 签名（256 位）。SHA256 算法据称比 SHA1 算法慢，but at the same time is significantly better from a cryptographic point of view (i.e. no collisions found). 但同时从加密的角度来看（即没有发现冲突）。SHA256 签名要求 catalog 中的每个文件 32 个字节。

  * SHA512

    将为每个保存的文件计算 SHA512 签名（512 位）。这是最慢的算法， is equivalent in terms of cryptographic value than SHA256.在加密值方面与 SHA256 相当。SHA512 签名要求 catalog 中的每个文件有 64 个字节。

  * XXH128

    将为每个保存的文件计算 xxHash 签名（XXH3，128 位）。这是计算需求最少的算法，但它在密码学上也不安全。XXH128 签名要求 catalog 中的每个文件 16 个字节。

- Base Job

  Type: <options>  

  The options letters specified are used when running a **Backup Level=Full** with BaseJobs. The options letters are the same than in the **verify=** option below.当使用 BaseJobs 运行 Backup Level=Full 时，将使用指定的选项字母。选项字母与下面的 verify= 选项中的字母相同。

- Accurate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Accurate)

  Type: <options>  

  The options letters specified are used when running a **Backup Level=Incremental/Differential** in Accurate mode. The options letters are the same than in the **verify=** option below. The default setting is **mcs** which means that *modification time*, *change time* and *size* are compared.在精确模式下运行备份级别=增量/差异时，将使用指定的选项字母。选项字母与下面的verify=选项中的字母相同。默认设置为mcs，这意味着比较修改时间、更改时间和大小。

- Verify[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Verify)

  Type: <options> 

  The options letters specified are used  when running a **Verify Level=Catalog** as well as the  **DiskToCatalog** level job. The options letters may be any  combination of the following:

  * i

    compare the inodes

  * p

    compare the permission bits

  * n

    compare the number of links

  * u

    compare the user id

  * g

    compare the group id

  * s

    compare the size

  * a

    compare the access time

  * m

    compare the modification time (st_mtime)

  * c

    compare the change time (st_ctime)

  * d

    report file size decreases

  * 5

    compare the MD5 signature

  * 1

    compare the SHA1 signature

  * A

    Only for Accurate option, it allows to always backup the file

  A useful set of general options on the **Level=Catalog**  or **Level=DiskToCatalog**  verify is **pins5** i.e. compare permission bits, inodes, number  of links, size, and MD5 changes.

- One FS

  Type: yes|no
  
  Default value: yes
  
  如果设置为 yes ，Bareos will remain on a single file system. Bareos 将保留在单个文件系统上。也就是说，它不会备份挂载在子目录上的文件系统。如果你使用的是 Unix 系统，你甚至可能不知道有几个不同的文件系统，因为它们通常是由操作系统自动挂载的（例如 /dev，/net，/sys，/proc，...）。当 Bareos 决定不遍历另一个文件系统时，它会通知您。这可能是非常有用的，如果你忘记备份一个特定的分区。作业报告中的信息性消息示例如下：
  
  ```bash
  host-fd: /misc is a different filesystem. Will not descend from / into /misc
  host-fd: /net is a different filesystem. Will not descend from / into /net
  host-fd: /var/lib/nfs/rpc_pipefs is a different filesystem. Will not descend from /var/lib/nfs into /var/lib/nfs/rpc_pipefs
  host-fd: /selinux is a different filesystem. Will not descend from / into /selinux
  host-fd: /sys is a different filesystem. Will not descend from / into /sys
  host-fd: /dev is a different filesystem. Will not descend from / into /dev
  host-fd: /home is a different filesystem. Will not descend from / into /home
  ```
  
  如果您希望备份多个文件系统，可以显式地列出您想要保存的每个文件系统。否则，如果您将 onefs 选项设置为 no ，Bareos 将备份在 FileSet 中找到的所有挂载的文件系统（即遍历挂载点）。因此，如果您在 FileSet 中列出的目录上装载了 NFS 或 Samba 文件系统，它们也将被备份。通常情况下，最好设置 [`One FS (Dir->Fileset->Include->Options) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_OneFs) ，并显式命名您想要备份的每个文件系统。显式地命名要备份的文件系统可以避免陷入无限循环递归文件系统的可能性。另一种可能性是使用 [`One FS (Dir->Fileset->Include->Options) = no`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_OneFs)  ，并设置 [`FS Type (Dir->Fileset->Include->Options) = ext2, ...`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_FsType) 。
  
  如果你认为 Bareos 应该备份一个特定的目录，但它没有，并且你有 **onefs=yes** 设置，在你抱怨之前，请做：
  
  ```bash
  stat /
  stat <filesystem>
  ```
  
  where you replace **filesystem** with the one in question.  If the **Device:** number is different for / and for your filesystem, then they are on different filesystems.  E.g.在这里你用有问题的文件系统替换文件系统。如果/和文件系统的Device：number不同，则它们位于不同的文件系统上。例如
  
  ```bash
  root@host:~# stat /
  File: `/'
  Size: 4096            Blocks: 16         IO Block: 4096   directory
  Device: 302h/770d       Inode: 2           Links: 26
  Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
  Access: 2005-11-10 12:28:01.000000000 +0100
  Modify: 2005-09-27 17:52:32.000000000 +0200
  Change: 2005-09-27 17:52:32.000000000 +0200
  
  root@host:~# stat /net
  File: `/home'
  Size: 4096            Blocks: 16         IO Block: 4096   directory
  Device: 308h/776d       Inode: 2           Links: 7
  Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
  Access: 2005-11-10 12:28:02.000000000 +0100
  Modify: 2005-11-06 12:36:48.000000000 +0100
  Change: 2005-11-06 12:36:48.000000000 +0100
  ```
  
  Also be aware that even if you include `/home` in your list of files to backup, as you most likely should, you will get the informational message that  “/home is a different filesystem” when Bareos is processing the `/` directory.  This message does not indicate an error. This message means that while examining the **File =** referred to in the second part of the message, Bareos will not descend into the directory mentioned in the first part of the message. However, it is possible that the separate filesystem will be backed up despite the message. For example, consider the following FileSet:还要注意的是，即使您在要备份的文件列表中包括/home（您很可能应该这样做），当Bareos处理/目录时，您也会收到“/home是一个不同的文件系统”的信息性消息。此消息并不表示错误。这条消息意味着，当检查消息第二部分中提到的File =时，Bareos不会下降到消息第一部分中提到的目录。但是，尽管有此消息，也可能会备份单独的文件系统。例如，考虑以下文件集：
  
  ```bash
  File = /
  File = /var
  ```
  
  where `/var` is a separate filesystem.  In this example, you will get a message saying that Bareos will not decend from `/` into `/var`.  But it is important to realise that Bareos will descend into `/var` from the second File directive shown above.  In effect, the warning is bogus, but it is supplied to alert you to possible omissions from your FileSet. In this example, `/var` will be backed up.  If you changed the FileSet such that it did not specify `/var`, then `/var` will not be backed up.
  
  其中/var是一个单独的文件系统。在这个例子中，你会得到一条消息，说Bareos不会从/decend到/var。但重要的是要认识到，Bareos将从上面显示的第二个File指令下降到/var。实际上，该警告是虚假的，但提供它是为了提醒您文件集中可能存在的遗漏。在这个例子中，/var将被备份。如果您更改了文件集，使其未指定/var，则不会备份/var。

- Honor No Dump Flag

  Type: yes|no
  
  If your file system supports the **nodump** flag (e. g. most BSD-derived systems) Bareos will honor the setting of the flag when this option is set to **yes**. Files having this flag set will not be included in the backup and will not show up in the catalog. For directories with the **nodump** flag set recursion is turned off and the directory will be listed in the catalog. If the **honor nodump flag** option is not defined or set to **no** every file and directory will be eligible for backup.
  
  如果您的文件系统支持nodump标志（例如，G.大多数BSD衍生系统）当此选项设置为yes时，Bareos将荣誉该标志的设置。设置了此标志的文件将不会包含在备份中，也不会显示在编录中。对于设置了nodump标志的目录，递归将被关闭，目录将在目录中列出。如果未定义荣誉nodump标志选项或将其设置为no，则每个文件和目录都将符合备份条件。

- Portable[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Portable)

  Type: yes|no

  If set to **yes** (default is **no**), the Bareos File daemon will backup Win32 files in a portable format, but not all Win32 file attributes will be saved and restored.  By default, this option is set to **no**, which means that on Win32 systems, the data will be backed up using Windows API calls and on WinNT/2K/XP, all the security and ownership attributes will be properly backed up (and restored).  However this format is not portable to other systems – e.g.  Unix, Win95/98/Me. When backing up Unix systems, this option is ignored, and unless you have a specific need to have portable backups, we recommend accept the default (**no**) so that the maximum information concerning your files is saved.

  如果设置为yes（默认值为no），Bareos File守护程序将以可移植格式备份Win32文件，但不会保存和恢复所有Win32文件属性。默认情况下，此选项设置为no，这意味着在Win32系统上，将使用Windows API调用备份数据，而在WinNT/2K/XP上，将正确备份（并恢复）所有安全性和所有权属性。但是，此格式不能移植到其他系统-例如Unix、Win95/98/Me。在备份Unix系统时，此选项将被忽略，除非您有特定的需要进行可移植备份，否则我们建议接受默认值（否），以便保存有关文件的最大信息。

- Recurse[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Recurse)

  Type: yes|no  If set to **yes** (the default), Bareos will recurse (or descend) into all subdirectories found unless the directory is explicitly excluded using an **exclude** definition.  If you set **recurse=no**, Bareos will save the subdirectory entries, but not descend into the subdirectories, and thus will not save the files or directories contained in the subdirectories.  Normally, you will want the default (**yes**).如果设置为yes（默认值），Bareos将递归（或下降）到找到的所有子目录，除非使用排除定义显式排除该目录。如果您设置recurse=no，Bareos将保存目录条目，但不会下降到子目录，因此不会保存子目录中包含的文件或目录。通常情况下，您需要默认值（是）。

- Sparse[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Sparse)

  Type: yes|no  Enable special code that checks for sparse files such as created by ndbm.  The default is **no**, so no checks are made for sparse files. You may specify **sparse=yes** even on files that are not sparse file. No harm will be done, but there will be a small additional overhead to check for buffers of all zero, and if there is a 32K block of all zeros (see below), that block will become a hole in the file, which may not be desirable if the original file was not a sparse file. **Restrictions:** Bareos reads files in 32K buffers.  If the whole buffer is zero, it will be treated as a sparse block and not written to tape.  However, if any part of the buffer is non-zero, the whole buffer will be written to tape, possibly including some disk sectors (generally 4098 bytes) that are all zero.  As a consequence, Bareos’s detection of sparse blocks is in 32K increments rather than the system block size. If anyone considers this to be a real problem, please send in a request for change with the reason. If you are not familiar with sparse files, an example is say a file where you wrote 512 bytes at address zero, then 512 bytes at address 1 million.  The operating system will allocate only two blocks, and the empty space or hole will have nothing allocated.  However, when you read the sparse file and read the addresses where nothing was written, the OS will return all zeros as if the space were allocated, and if you backup such a file, a lot of space will be used to write zeros to the volume. Worse yet, when you restore the file, all the previously empty space will now be allocated using much more disk space.  By turning on the **sparse** option, Bareos will specifically look for empty space in the file, and any empty space will not be written to the Volume, nor will it be restored.  The price to pay for this is that Bareos must search each block it reads before writing it.  On a slow system, this may be important.  If you suspect you have sparse files, you should benchmark the difference or set sparse for only those files that are really sparse. You probably should not use this option on files or raw disk devices that are not really sparse files (i.e. have holes in them).



- Read Fifo[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_ReadFifo)

  Type: yes|no  If enabled, tells the Client to read the data on a backup and write the data on a restore to any FIFO (pipe) that is explicitly mentioned in the FileSet.  In this case, you must have a program already running that writes into the FIFO for a backup or reads from the FIFO on a restore. This can be accomplished with the **RunBeforeJob** directive.  If this is not the case, Bareos will hang indefinitely on reading/writing the FIFO. When this is not enabled (default), the Client simply saves the directory entry for the FIFO. Normally, when Bareos runs a RunBeforeJob, it waits until that script terminates, and if the script accesses the FIFO to write into it, the Bareos job will block and everything will stall. However, Vladimir Stavrinov as supplied tip that allows this feature to work correctly.  He simply adds the following to the beginning of the RunBeforeJob script: `exec > /dev/null `
  
  ```bash
  Include {
    Options {
      signature=SHA1
      readfifo=yes
    }
    File = "/home/abc/fifo"
  }
  ```
  
  This feature can be used to do a “hot” database backup. You can use the **RunBeforeJob** to create the fifo and to start a program that dynamically reads your database and writes it to the fifo.  Bareos will then write it to the Volume.
  
  During the restore operation, the inverse is true, after Bareos creates the fifo if there was any data stored with it (no need to explicitly list it or add any options), that data will be written back to the fifo. As a consequence, if any such FIFOs exist in the fileset to be restored, you must ensure that there is a reader program or Bareos will block, and after one minute, Bareos will time out the write to the fifo and move on to the next file.
  
  If you are planing to use a Fifo for backup, better take a look to the [bpipe Plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#bpipe) section.

- No Atime[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_NoAtime)

  Type: yes|no  If enabled, and if your Operating System supports the O_NOATIME file open flag, Bareos will open all files to be backed up with this option. It makes it possible to read a file without updating the inode atime (and also without the inode ctime update which happens if you try to set the atime back to its previous value).  It also prevents a race condition when two programs are reading the same file, but only one does not want to change the atime.  It’s most useful for backup programs and file integrity checkers (and Bareos can fit on both categories). This option is particularly useful for sites where users are sensitive to their MailBox file access time.  It replaces both the **keepatime** option without the inconveniences of that option (see below). If your Operating System does not support this option, it will be silently ignored by Bareos.

- Mtime Only[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_MtimeOnly)

  Type: yes|no Default value: no  If enabled, tells the Client that the selection of files during Incremental and Differential backups should based only on the st_mtime value in the stat() packet.  The default is **no** which means that the selection of files to be backed up will be based on both the st_mtime and the st_ctime values.  In general, it is not recommended to use this option.

- Keep Atime[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_KeepAtime)

  Type: yes|no  The default is **no**.  When enabled, Bareos will reset the st_atime (access time) field of files that it backs up to their value prior to the backup.  This option is not generally recommended as there are very few programs that use st_atime, and the backup overhead is increased because of the additional system call necessary to reset the times. However, for some files, such as mailboxes, when Bareos backs up the file, the user will notice that someone (Bareos) has accessed the file. In this, case keepatime can be useful. (I’m not sure this works on Win32). Note, if you use this feature, when Bareos resets the access time, the change time (st_ctime) will automatically be modified by the system, so on the next incremental job, the file will be backed up even if it has not changed. As a consequence, you will probably also want to use **mtimeonly = yes** as well as keepatime (thanks to Rudolf Cejka for this tip).

- Check File Changes

  Type: yes|no
  
  Default value: no
  
  If enabled, the Client will check size, age of each file after their backup to see if they have changed during backup.如果启用，客户端将在备份每个文件后检查它们的大小，年龄，看看他们是否已更改备份过程中。如果时间或大小不匹配，将引发错误。
  
  ```bash
  zog-fd: Client1.2007-03-31_09.46.21 Error: /tmp/test mtime changed during backup.
  ```
  
  > Note
  >
  > This option is intended to be used [`File (Dir->Fileset->Include)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_File) resources. Using it with [`Plugin (Dir->Fileset->Include)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Plugin) filesets will generate warnings during backup.此选项旨在用于文件（目录->文件->包含）资源。使用它与插件（目录->文件夹->包含）文件集将在备份过程中生成警告。

- Hard Links

  Type: yes|no

  Default value: no

  Warning Since *Version >= 23.0.0* the default is **no**. When disabled, Bareos will backup each file individually and restore them as unrelated files as well. The fact that the files were hard links will be lost. When enabled, this directive will cause hard links to be backed up as hard links. For each set of hard links, the file daemon will only backup the file contents once – when it encounters the first file of that set – and only backup meta data and a reference to that first file for each subsequent file in that set. Be aware that the process of keeping track of the hard links can be quite expensive if you have lots of them (tens of thousands or more). Backups become very long and the File daemon will consume a lot of CPU power checking hard links. See related performance option like [`Optimize For Size (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_OptimizeForSize) Note If you created backups with [`Hard Links (Dir->Fileset->Include->Options) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_HardLinks) you should only ever restore all files in that set of hard links at once or not restore any of them. If you were to restore a file inside that set, which was not the file with the contents attached, then Bareos will not restore its data, but instead just try to link with the file it references and restore its meta data. This means that the newly restored file might not actually have the same contents as when it was backed up.

- Wild

  Type: <string>

  指定要应用于文件名和目录名的通配符字符串。请注意，如果 Exclude 未启用，通配符将选择要包含的文件。如果指定了 **Exclude=yes**  ，通配符将选择要排除的文件。可以指定多个通配符指令，they will be applied in turn until the first one that matches.它们将依次应用，直到第一个匹配为止。请注意，如果您排除一个目录，则其下的任何文件或目录都不会匹配。

  建议将字符串括在双引号中。

  您可能希望在运行备份之前使用 bwild 程序测试表达式。您还可以使用 estimate 命令测试完整的 FileSet 定义。

  文件集示例中提供了使用 WildFile 选项排除的示例

- Wild Dir

  Type: <string>

  指定仅应用于目录名的通配符字符串。此指令将不匹配任何文件名。请注意，如果 Exclude 未启用，通配符将选择要包含的目录。如果指定了 **Exclude=yes** ，通配符将选择要排除的目录。可以指定多个通配符指令，and they will be applied in turn until the first one that matches. 它们将依次应用，直到第一个匹配为止。请注意，如果您排除一个目录，则其下的任何文件或目录都不会匹配。

  建议将字符串括在双引号中。

  您可能希望在运行备份之前使用 bwild 程序测试表达式。您还可以使用 estimate 命令测试完整的 FileSet 定义。

  文件集示例中提供了使用WildFile选项排除的示例

- Wild File

  Type: <string>
  
  指定要应用于非目录的通配符字符串。也就是说，此指令将不匹配任何目录条目。However, note that the match is done against the full path and filename, so your wild-card string must take into account that filenames are preceded by the full path. 但是，请注意，匹配是根据完整路径和文件名完成的，因此您的通配符字符串必须考虑文件名前面是完整路径。如果未启用通配符（Dir-> Filename->Include->Options），通配符将选择要包含的文件。如果指定了“否”（Dir-> Film->Include->Options）= yes，通配符将选择要排除的文件。If [`Exclude (Dir->Fileset->Include->Options)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Exclude) is not enabled, the wild-card will select which files are to be included. If [`Exclude (Dir->Fileset->Include->Options) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Exclude) is specified, the wild-card will select which files are to be excluded.  Multiple wild-card directives may be specified, and they will be applied in turn until the first one that matches. 可以指定多个通配符指令，它们将依次应用，直到第一个匹配为止。
  
  建议将字符串括在双引号中。
  
  您可能希望在运行备份之前使用 bwild 程序测试表达式。您还可以使用 estimate 命令测试完整的 FileSet 定义。
  
  文件集示例中提供了使用 WildFile 选项排除的示例

- Regex[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Regex)

  Type: <string>  Specifies a POSIX extended regular expression to be applied to the filenames and directory names, which include the full path.  If :strong:` Exclude` is not enabled, the regex will select which files are to be included. If [`Exclude (Dir->Fileset->Include->Options) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Exclude) is specified, the regex will select which files are to be excluded.  Multiple regex directives may be specified within an Options resource, and they will be applied in turn until the first one that matches.  Note, if you exclude a directory, no files or directories below it will be matched. It is recommended to enclose the string in double quotes. The regex libraries differ from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the [bregex](https://docs.bareos.org/Appendix/BareosPrograms.html#bregex) program. You can also test your full FileSet definition by using the [estimate](https://docs.bareos.org/TasksAndConcepts/BareosConsole.html#estimate) command. You find yourself using a lot of Regex statements, which will cost quite a lot of CPU time, we recommend you simplify them if you can, or better yet convert them to Wild statements which are much more efficient.

- Regex File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_RegexFile)

  Type: <string>  Specifies a POSIX extended regular expression to be applied to non-directories. No directories will be matched by this directive. However, note that the match is done against the full path and filename, so your regex string must take into account that filenames are preceded by the full path. If **Exclude** is not enabled, the regex will select which files are to be included.  If **Exclude=yes** is specified, the regex will select which files are to be excluded.  Multiple regex directives may be specified, and they will be applied in turn until the first one that matches. It is recommended to enclose the string in double quotes. The regex libraries differ from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the [bregex](https://docs.bareos.org/Appendix/BareosPrograms.html#bregex) program.

- Regex Dir[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_RegexDir)

  Type: <string>  Specifies a POSIX extended regular expression to be applied to directory names only.  No filenames will be matched by this directive.  Note, if **Exclude** is not enabled, the regex will select directories files are to be included.  If **Exclude=yes** is specified, the regex will select which files are to be excluded.  Multiple regex directives may be specified, and they will be applied in turn until the first one that matches.  Note, if you exclude a directory, no files or directories below it will be matched. It is recommended to enclose the string in double quotes. The regex libraries differ from one operating system to another, and in addition, regular expressions are complicated, so you may want to test your expressions prior to running your backup by using the [bregex](https://docs.bareos.org/Appendix/BareosPrograms.html#bregex) program.

- Exclude

  Type: BOOLEAN
  
  启用后，将从备份中排除选项中匹配的任何文件。

- ACL Support[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_AclSupport)

  Type: yes|no Default value: yes  Since *Version >= 18.2.4* the default is **yes**. If this option is set to yes, and you have the POSIX **libacl** installed on your Linux system, Bareos will backup the file and directory Unix Access Control Lists (ACL) as defined in IEEE Std 1003.1e draft 17 and “POSIX.1e” (abandoned).  This feature is available on Unix systems only and requires the Linux ACL library. Bareos is automatically compiled with ACL support if the **libacl** library is installed on your Linux system (shown in config.out).  While restoring the files Bareos will try to restore the ACLs, if there is no ACL support available on the system, Bareos restores the files and directories but not the ACL information.  Please note, if you backup an EXT3 or XFS filesystem with ACLs, then you restore them to a different filesystem (perhaps reiserfs) that does not have ACLs, the ACLs will be ignored. For other operating systems there is support for either POSIX ACLs or the more extensible NFSv4 ACLs. The ACL stream format between Operation Systems is **not** compatible so for example an ACL saved on Linux cannot be restored on Solaris. The following Operating Systems are currently supported: AIX (pre-5.3 (POSIX) and post 5.3 (POSIX and NFSv4) ACLs) Darwin FreeBSD (POSIX and NFSv4/ZFS ACLs) HPUX IRIX Linux Solaris (POSIX and NFSv4/ZFS ACLs) Tru64



- XAttr Support[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_XAttrSupport)

  Type: yes|no Default value: yes  Since *Version >= 18.2.4* the default is **yes**. If this option is set to yes, and your operating system support either so called Extended Attributes or Extensible Attributes Bareos will backup the file and directory XATTR data. This feature is available on UNIX only and depends on support of some specific library calls in libc. The XATTR stream format between Operating Systems is **not** compatible so an XATTR saved on Linux cannot for example be restored on Solaris. On some operating systems ACLs are also stored as Extended Attributes (Linux, Darwin, FreeBSD) Bareos checks if you have the aclsupport option enabled and if so will not save the same info when saving extended attribute information. Thus ACLs are only saved once. The following Operating Systems are currently supported: AIX (Extended Attributes) Darwin (Extended Attributes) FreeBSD (Extended Attributes) IRIX (Extended Attributes) Linux (Extended Attributes) NetBSD (Extended Attributes) Solaris (Extended Attributes and Extensible Attributes) Tru64 (Extended Attributes)

- Ignore Case[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_IgnoreCase)

  Type: yes|no  The default is **no**.  On Windows systems, you will almost surely want to set this to **yes**.  When this directive is set to **yes** all the case of character will be ignored in wild-card and regex comparisons.  That is an uppercase A will match a lowercase a.

- FS Type

  Type: filesystem-type

  此选项允许您按文件系统类型选择文件和目录。文件系统类型名称的示例如下：

  btrfs, ext2, ext3, ext4, jfs, ntfs, proc, reiserfs, xfs, nfs, vfat, usbdevfs, sysfs, smbfs, iso9660

  您可能有多个 Fstype 指令，因此允许在单个 Options 资源中匹配多个文件系统类型。If the type specified on the fstype directive does not match the filesystem for a particular directive, that directory will not be backed up.  如果fstype指令上指定的类型与特定指令的文件系统不匹配，则不会备份该目录。此指令可用于防止备份非本地文件系统。通常，当你使用这个指令的时候，你还需要设置 [`One FS (Dir->Fileset->Include->Options) = no`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_OneFs) ，这样 Bareos 就会遍历文件系统。

  此选项在 Win32 系统中未实现。

- Drive Type[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_DriveType)

  Type: Windows-drive-type  This option is effective only on Windows machines and is somewhat similar to the Unix/Linux [`FS Type (Dir->Fileset->Include->Options)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_FsType) described above, except that it allows you to select what Windows drive types you want to allow.  By default all drive types are accepted. The permitted drivetype names are: removable, fixed, remote, cdrom, ramdisk You may have multiple Driveype directives, and thus permit matching of multiple drive types within a single Options resource.  If the type specified on the drivetype directive does not match the filesystem for a particular directive, that directory will not be backed up.  This directive can be used to prevent backing up non-local filesystems. Normally, when you use this directive, you would also set [`One FS (Dir->Fileset->Include->Options) = no`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_OneFs) so that Bareos will traverse filesystems. This option is not implemented in Unix/Linux systems.

- Hfs Plus Support[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_HfsPlusSupport)

  Type: yes|no  This option allows you to turn on support for Mac OSX HFS plus finder information.

- Strip Path[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_StripPath)

  Type: <integer>  This option will cause **integer** paths to be stripped from the front of the full path/filename being backed up. This can be useful if you are migrating data from another vendor or if you have taken a snapshot into some subdirectory.  This directive can cause your filenames to be overlayed with regular backup data, so should be used only by experts and with great care.

- Size[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Size)

  Type: sizeoption  This option will allow you to select files by their actual size. You can select either files smaller than a certain size or bigger then a certain size, files of a size in a certain range or files of a size which is within 1 % of its actual size. The following settings can be used: <size>-<size>Select file in range size - size. <sizeSelect files smaller than size. >sizeSelect files bigger than size. sizeSelect files which are within 1 % of size.

- Shadowing[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Shadowing)

  Type: none|localwarn|localremove|globalwarn|globalremove

  Default value: none

  This option performs a check within the fileset for any file-list entries which are shadowing each other. Lets say you specify / and /usr but /usr is not a separate filesystem. Then in the normal situation both / and /usr would lead to data being backed up twice.

  这个选项在文件集中检查任何相互隐藏的文件列表条目。假设您指定了/和/usr，但/usr不是一个单独的文件系统。那么在正常情况下，/和/usr都会导致数据备份两次。

  The following settings can be used: noneDo NO shadowing check localwarnDo shadowing check within one include block and warn localremoveDo shadowing check within one include block and remove duplicates globalwarnDo shadowing check between all include blocks and warn globalremoveDo shadowing check between all include blocks and remove duplicates  The local and global part of the setting relate to the fact if the check should be performed only within one include block (local) or between multiple include blocks of the same fileset (global). The warn and remove part of the keyword sets the action e.g. warn the user about shadowing or remove the entry shadowing the other. Example for a fileset resource with fileset shadow warning enabled: FileSet resource with fileset shadow warning enabled[](https://docs.bareos.org/Configuration/Director.html#id17) `FileSet {  Name = "Test Set"  Include {    Options {      Signature = XXH128      shadowing = localwarn    }    File = /    File = /usr  } } `

- Meta[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Include_Options_Meta)

  Type: tag  This option will add a meta tag to a fileset. These meta tags are used by the Native NDMP protocol to pass NDMP backup or restore environment variables via the Data Management Agent (DMA) in Bareos to the remote NDMP Data Agent. You can have zero or more metatags which are all passed to the remote NDMP Data Agent.

### FileSet 示例

以下是有效的 FileSet 资源定义的示例。注意，第一个 Include 在 Bareos 启动时拉入文件 `/etc/backup.list` 的内容（即@），并且该文件必须在每个要备份的文件名之前加上 File = ，并在单独的行上。

```bash
FileSet {
  Name = "Full Set"
  Include {
    Options {
      Compression=GZIP
      signature=SHA1
      Sparse = yes
    }
    @/etc/backup.list
  }
  Include {
     Options {
        wildfile = "*.o"
        wildfile = "*.exe"
        Exclude = yes
     }
     File = /root/myfile
     File = /usr/lib/another_file
  }
}
```

在上面的例子中，`/etc/backup.list` 中包含的所有文件都将使用 LZ4 压缩，an XXH128 signature will be  computed on the file’s contents (its data), and sparse file handling  will apply.XXH128 签名将在文件的内容（其数据）上计算，并且稀疏文件处理将应用。

`/root/myfile` 和 `/usr/lib/another_file` 这两个目录也将被保存，但没有任何选项，但这些目录中所有扩展名为 `.o` 和 `.exe` 的文件将被排除。

假设您现在想要排除目录 `/tmp` 。最简单的方法是添加一个列出 `/tmp` 的 exclude 指令。上面的例子将变成：

```bash
FileSet {
  Name = "Full Set"
  Include {
    Options {
      Compression = LZ4
      Signature = XXH128
      Sparse = yes
    }
    @/etc/backup.list
  }
  Include {
     Options {
        wildfile = "*.o"
        wildfile = "*.exe"
        Exclude = yes
     }
     File = /root/myfile
     File = /usr/lib/another_file
  }
  Exclude {
     File = /tmp                          # don't add trailing /
  }
}
```

You can add wild-cards to the File directives listed in the Exclude directory, 您可以向目录中列出的 File 指令添加通配符，但需要注意，因为如果排除某个目录，则该目录及其下的所有文件和目录也将被排除。

现在让我们稍微改变一下上面的方法，假设你想保存除了 `/tmp` 之外的所有文件系统。出现的问题是 Bareos 通常不会从一个文件系统跨到另一个文件系统。执行一个 `df` 命令，你会得到以下输出：

```bash
df
Filesystem      1k-blocks      Used Available Use% Mounted on
/dev/hda5         5044156    439232   4348692  10% /
/dev/hda1           62193      4935     54047   9% /boot
/dev/hda9        20161172   5524660  13612372  29% /home
/dev/hda2           62217      6843     52161  12% /rescue
/dev/hda8         5044156     42548   4745376   1% /tmp
/dev/hda6         5044156   2613132   2174792  55% /usr
none               127708         0    127708   0% /dev/shm
//minimatou/c$   14099200   9895424   4203776  71% /mnt/mmatou
lmatou:/          1554264    215884   1258056  15% /mnt/matou
lmatou:/home      2478140   1589952    760072  68% /mnt/matou/home
lmatou:/usr       1981000   1199960    678628  64% /mnt/matou/usr
lpmatou:/          995116    484112    459596  52% /mnt/pmatou
lpmatou:/home    19222656   2787880  15458228  16% /mnt/pmatou/home
lpmatou:/usr      2478140   2038764    311260  87% /mnt/pmatou/usr
deuter:/          4806936     97684   4465064   3% /mnt/deuter
deuter:/home      4806904    280100   4282620   7% /mnt/deuter/home
deuter:/files    44133352  27652876  14238608  67% /mnt/deuter/files
```

To save all filesystems except /tmp with out  including any of the Samba or NFS mounted systems, and explicitly  excluding a /tmp, /proc, .journal, and .autofsck, which you will not  want to be saved and restored, you can use the following:

我们看到有许多独立的文件系统(/  /boot /home /rescue /tmp and /usr not to mention mounted systems)（/ /boot /home /rescue /tmp 和 /usr，更不用说挂载的系统了）。如果在包含列表中只指定 / ，Bareos 将只保存文件系统 /dev/hda5 。要保存除 /tmp 之外的所有文件系统，而不包括任何 Samba 或 NFS 挂载的系统，并显式排除不希望保存和恢复的 /tmp 、/proc 、.journal 和 .autofsck ，可以使用以下命令：

```bash
FileSet {
  Name = Include_example
  Include {
    Options {
       wilddir = /proc
       wilddir = /tmp
       wildfile = "/.journal"
       wildfile = "/.autofsck"
       exclude = yes
    }
    File = /
    File = /boot
    File = /home
    File = /rescue
    File = /usr
  }
}
```

由于 `/tmp` 在它自己的文件系统上，并且它没有在 Include 列表中显式命名，因此在 exclude 列表中实际上不需要它。为了清楚起见，最好将其列在 exclude 列表中，以防磁盘发生更改，使其不再位于自己的分区中。

Now, lets assume you only want to backup .Z and .gz files and nothing else. This is a bit trickier because Bareos by default will select  everything to backup, so we must exclude everything but .Z and .gz  files. If we take the first example above and make the obvious  modifications to it, we might come up with a FileSet that looks like  this:

现在，让我们假设您只想备份.Z和.gz文件，而不想备份其他文件。这是一个有点棘手，因为Bareos默认情况下将选择一切备份，所以我们必须排除一切，但.Z和.gz文件。如果我们采用上面的第一个示例并对其进行明显的修改，我们可能会得到一个看起来像这样的FileSet：

```bash
FileSet {
  Name = "Full Set"
  Include {                    !!!!!!!!!!!!
     Options {                    This
        wildfile = "*.Z"          example
        wildfile = "*.gz"         doesn't
                                  work
     }                          !!!!!!!!!!!!
     File = /myfile
  }
}
```

*.Z 和 *.gz 文件确实会被备份，但所有其他与选项指令不匹配的文件也会自动备份（即，这是默认规则）。

为了实现我们想要的，我们必须明确地排除所有其他文件。我们通过以下方式实现这一点：

```bash
FileSet {
  Name = "Full Set"
  Include {
     Options {
        wildfile = "*.Z"
        wildfile = "*.gz"
     }
     Options {
        Exclude = yes
        RegexFile = ".*"
     }
     File = /myfile
  }
}
```

The “trick” here was to add a RegexFile  expression that matches all files. It does not match directory names, so all directories in /myfile will be backed up (the directory entry) and  any *.Z and *.gz files contained in them. If you know that certain  directories do not contain any *.Z or *.gz files and you do not want the directory entries backed up, you will need to explicitly exclude those  directories. Backing up a directory entries is not very expensive.

Bareos uses the system regex library and some of them are different on different OSes. This can be tested by using the **estimate job=job-name listing** command in the console and adapting the RegexFile expression appropriately.

Please be aware that allowing Bareos to traverse or change file systems can be very dangerous. For example, with the following:

这里的“技巧”是添加一个匹配所有文件的RegexFile表达式。它与目录名不匹配，因此将备份/myfile中的所有目录（目录条目）以及其中包含的任何 *.Z和 *.gz文件。如果您知道某些目录不包含任何 *.Z或 *.gz文件，并且您不希望备份目录条目，则需要显式排除这些目录。备份一个目录条目并不昂贵。

Bareos使用系统正则表达式库，其中一些在不同的操作系统上是不同的。这可以通过在控制台中使用estimate job=job-name listing命令并适当调整RegexFile表达式来测试。

请注意，允许Bareos遍历或更改文件系统可能非常危险。例如，对于以下内容：

```bash
FileSet {
  Name = "Bad example"
  Include {
    Options {
      onefs=no
    }
    File = /mnt/matou
  }
}
```

you will be backing up an NFS mounted  partition (/mnt/matou), and since onefs is set to no, Bareos will  traverse file systems. Now if /mnt/matou has the current machine’s file  systems mounted, as is often the case, you will get yourself into a  recursive loop and the backup will never end.

您将备份NFS挂载的分区（/mnt/matou），由于onefs设置为no，Bareos将遍历文件系统。现在，如果/mnt/matou挂载了当前机器的文件系统（通常情况下），您将进入递归循环，备份将永远不会结束。

作为最后一个例子，假设您只需要备份/home的一个或两个子目录。例如，您希望只备份以字母a和字母b开头的子目录，即 `/home/a*` 和 `/home/b*` 。你可以先试试：

```bash
FileSet {
  Name = "Full Set"
  Include {
     Options {
        wilddir = "/home/a*"
        wilddir = "/home/b*"
     }
     File = /home
  }
}
```

The problem is that the above will include  everything in /home. To get things to work correctly, you need to start  with the idea of exclusion instead of inclusion. So, you could simply  exclude all directories except the two you want to use:

问题是，上述内容将包括/home中的所有内容。为了让事情正常工作，你需要从排斥而不是包容的想法开始。因此，您可以简单地排除所有目录，除了您要使用的两个目录：用途：

```
FileSet {
  Name = "Full Set"
  Include {
     Options {
        RegexDir = "^/home/[c-z]"
        exclude = yes
     }
     File = /home
  }
}
```

And assuming that all subdirectories start with a lowercase letter, this would work.

假设所有的子目录都以一个小写字母开头，这就可以了。

另一种方法是包含所需的两个子目录，并排除其他所有内容：

An alternative would be to include the two subdirectories desired and exclude everything else:

Include and Exclude[](https://docs.bareos.org/Configuration/Director.html#id27)

```
FileSet {
  Name = "Full Set"
  Include {
     Options {
        wilddir = "/home/a*"
        wilddir = "/home/b*"
     }
     Options {
        RegexDir = ".*"
        exclude = yes
     }
     File = /home
  }
}
```

The following example shows how to back up  only the My Pictures directory inside the My Documents directory for all users in C:/Documents and Settings, i.e. everything matching the  pattern:以下示例显示如何仅为C：/Documents and Settings中的所有用户备份My Documents目录中的My Pictures目录，即与模式匹配的所有内容：

```
C:/Documents and Settings/*/My Documents/My Pictures/*
```

To understand how this can be achieved, there are two important points to remember:

Firstly, Bareos walks over the filesystem depth-first starting from  the File = lines. It stops descending when a directory is excluded, so  you must include all ancestor directories of each directory containing  files to be included.

Secondly, each directory and file is compared to the Options clauses  in the order they appear in the FileSet. When a match is found, no  further clauses are compared and the directory or file is either  included or excluded.

The FileSet resource definition below implements this by including specific directories and files and excluding everything else.

要理解如何实现这一点，有两个要点需要记住：

首先，Bareos从File =行开始深度优先遍历文件系统。当排除某个目录时，它将停止降序，因此您必须包括包含要包括的文件的每个目录的所有祖先目录。

其次，将每个目录和文件与Options子句按它们在FileSet中出现的顺序进行比较。当找到匹配项时，不再比较其他子句，目录或文件要么被包括，要么被排除。

下面的FileSet资源定义通过包括特定的目录和文件并排除其他所有内容来实现这一点。

```
FileSet {
  Name = "AllPictures"

  Include {

    File  = "C:/Documents and Settings"

    Options {
      signature = SHA1
      verify = s1
      IgnoreCase = yes

      # Include all users' directories so we reach the inner ones.  Unlike a
      # WildDir pattern ending in *, this RegExDir only matches the top-level
      # directories and not any inner ones.
      RegExDir = "^C:/Documents and Settings/[^/]+$"

      # Ditto all users' My Documents directories.
      WildDir = "C:/Documents and Settings/*/My Documents"

      # Ditto all users' My Documents/My Pictures directories.
      WildDir = "C:/Documents and Settings/*/My Documents/My Pictures"

      # Include the contents of the My Documents/My Pictures directories and
      # any subdirectories.
      Wild = "C:/Documents and Settings/*/My Documents/My Pictures/*"
    }

    Options {
      Exclude = yes
      IgnoreCase = yes

      # Exclude everything else, in particular any files at the top level and
      # any other directories or files in the users' directories.
      Wild = "C:/Documents and Settings/*"
    }
  }
}
```

### Windows FileSets[](https://docs.bareos.org/Configuration/Director.html#windows-filesets)

 

If you are entering Windows file names, the directory path may be  preceded by the drive and a colon (as in c:). However, the path  separators must be specified in Unix convention (i.e. forward slash  (/)). If you wish to include a quote in a file name, precede the quote  with a backslash (). For example you might use the following for a  Windows machine to backup the “My Documents” directory:

Windows FileSet[](https://docs.bareos.org/Configuration/Director.html#id29)

```
FileSet {
  Name = "Windows Set"
  Include {
    Options {
       WildFile = "*.obj"
       WildFile = "*.exe"
       exclude = yes
     }
     File = "c:/My Documents"
  }
}
```

For exclude lists to work correctly on Windows, you must observe the following rules:

- Filenames are case sensitive, so you must use the correct case.
- To exclude a directory, you must not have a trailing slash on the directory name.
- If you have spaces in your filename, you must enclose the entire  name in double-quote characters (“). Trying to use a backslash before  the space will not work.
- If you are using the old Exclude syntax (noted below), you may  not specify a drive letter in the exclude. The new syntax noted above  should work fine including driver letters.

Thanks to Thiago Lima for summarizing the above items for us. If you  are having difficulties getting includes or excludes to work, you might  want to try using the **estimate job=job-name listing** command documented in the [Console Commands](https://docs.bareos.org/TasksAndConcepts/BareosConsole.html#section-consolecommands) section of this manual.

On Win32 systems, if you move a directory or file or rename a file  into the set of files being backed up, and a Full backup has already  been made, Bareos will not know there are new files to be saved during  an Incremental or Differential backup (blame Microsoft, not us). To  avoid this problem, please copy any new directory or files into the  backup area. If you do not have enough disk to copy the directory or  files, move them, but then initiate a Full backup.

#### Example Fileset for Windows[](https://docs.bareos.org/Configuration/Director.html#example-fileset-for-windows)

 

The following example demonstrates a Windows FileSet. It backups all  data from all fixed drives and only excludes some Windows temporary  data.

Windows All Drives FileSet[](https://docs.bareos.org/Configuration/Director.html#id30)

```
FileSet {
  Name = "Windows All Drives"
  Enable VSS = yes
  Include {
    Options {
      Signature = XXH128
      Drive Type = fixed
      IgnoreCase = yes
      WildFile = "[A-Z]:/pagefile.sys"
      WildDir = "[A-Z]:/RECYCLER"
      WildDir = "[A-Z]:/$RECYCLE.BIN"
      WildDir = "[A-Z]:/System Volume Information"
      Exclude = yes
    }
    File = /
  }
}
```

`File = /` includes all Windows drives. Using `Drive Type = fixed` excludes drives like USB-Stick or CD-ROM Drive. Using `WildDir = "[A-Z]:/RECYCLER"` excludes the backup of the directory `RECYCLER` from all drives.

### FileSet 测试

如果你想知道你的文件集将真正备份什么，或者你的排除规则是否正常工作，你可以使用 estimate 命令来测试它。

例如，假设您添加以下测试 FileSet：

```bash
FileSet {
  Name = Test
  Include {
    File = /home/xxx/test
    Options {
       regex = ".*\.c$"
    }
  }
}
```

然后，您可以将一些测试文件添加到 /home/xxx/test 目录中，并在控制台中使用以下命令：

```bash
estimate job=<any-job-name> listing client=<desired-client> fileset=Test
```

给予你所有匹配的文件列表。在上面的例子中，它应该只包含名称以 . c 结尾的文件。

## Client 资源

Client（或 FileDaemon）资源定义此 Director 所服务的客户端的属性；即要备份的计算机。需要为每台要备份的计算机定义一个客户端资源。

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`Auth Type (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AuthType) | = [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) | None          |              |
| [`Auto Prune (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AutoPrune) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | *no*          | *deprecated* |
| [`Catalog (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Catalog) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Connection From Client To Director (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_ConnectionFromClientToDirector) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Connection From Director To Client (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_ConnectionFromDirectorToClient) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Description (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Enabled (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Enabled) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`FD Address (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FdAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | *alias*      |
| [`FD Password (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FdPassword) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | *alias*      |
| [`FD Port (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FdPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | *9102*        | *alias*      |
| [`File Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FileRetention) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | *5184000*     | *deprecated* |
| [`Hard Quota (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_HardQuota) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) | 0             |              |
| [`Heartbeat Interval (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Job Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_JobRetention) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | *15552000*    | *deprecated* |
| [`Lan Address (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_LanAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Maximum Bandwidth Per Job (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |               |              |
| [`Maximum Concurrent Jobs (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Name (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`NDMP Block Size (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpBlockSize) | = [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32) | 64512         |              |
| [`NDMP Log Level (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpLogLevel) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 4             |              |
| [`NDMP Use LMDB (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpUseLmdb) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Passive (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Passive) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Password (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | **required** |
| [`Port (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Port) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9102          |              |
| [`Protocol (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Protocol) | = [`AUTH_PROTOCOL_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_protocol_type) | Native        |              |
| [`Quota Include Failed Jobs (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_QuotaIncludeFailedJobs) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Soft Quota (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuota) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) | 0             |              |
| [`Soft Quota Grace Period (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuotaGracePeriod) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Strict Quotas (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_StrictQuotas) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS Allowed CN (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Username (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Username) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |

- Address

  Required: True

  Type: STRING

  地址是主机名、完全限定域名或 Bareos 文件服务器守护程序的网络地址（以四点表示法表示）。此指令是必需的。

- Auth Type[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AuthType)

  Type: [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) Default value: None

  Specifies the authentication type that must be supplied when  connecting to a backup protocol that uses a specific authentication  type.指定连接到使用特定身份验证类型的备份协议时必须提供的身份验证类型。

- Auto Prune[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AutoPrune)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: deprecated  If set to **yes**, Bareos will automatically apply the [`File Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FileRetention) period and the [`Job Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_JobRetention) period for the client at the end of the job. Pruning affects only information in the catalog and not data stored  in the backup archives (on Volumes), but if pruning deletes all data  referring to a certain volume, the volume is regarded as empty and will  possibly be overwritten before the volume retention has expired.

- Catalog[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Catalog)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  This specifies the name of the catalog resource to be used for this  Client. If none is specified the first defined catalog is used.

- Connection From Client To Director[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_ConnectionFromClientToDirector)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 16.2.2  The Director will accept incoming network connection from this Client. For details, see [Client Initiated Connection](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-clientinitiatedconnection).

- Connection From Director To Client[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_ConnectionFromDirectorToClient)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes Since Version: 16.2.2  Let the Director initiate the network connection to the Client.

- Description

  Type: STRING

- Enable kTLS[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Enabled

  Type: BOOLEAN

  Default value: yes

  启用或禁用此资源。

- FD Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FdAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Alias for Address.

- FD Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FdPassword)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  *This directive is an alias.*

- FD Port

  Type: PINT32

  Default value: 9102

  此指令是别名。

  where the port is a port number at which the Bareos File Daemon can  be contacted. 其中端口是可以联系 Bareos 文件守护程序的端口号。默认值为 9102 。对于 NDMP 备份，将此值设置为 10000 。

- File Retention[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FileRetention)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 5184000 Since Version: deprecated  The File Retention directive defines the length of time that Bareos  will keep File records in the Catalog database after the End time of the Job corresponding to the File records. When this time period expires  and [`Auto Prune (Dir->Client) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AutoPrune), Bareos will prune (remove) File records that are older than the  specified File Retention period. Note, this affects only records in the  catalog database. It does not affect your archive backups. File records may actually be retained for a shorter period than you specify on this directive if you specify either a shorter [`Job Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_JobRetention) or a shorter [`Volume Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention) period. The shortest retention period of the three takes precedence. The default is 60 days.

- Hard Quota[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_HardQuota)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) Default value: 0  The amount of data determined by the Hard Quota directive sets the  hard limit of backup space that cannot be exceeded. This is the maximum  amount this client can back up before any backup job will be aborted. If the Hard Quota is exceeded, the running job is terminated: `Fatal error: append.c:218 Quota Exceeded. Job Terminated. `

- Heartbeat Interval[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets between the defined Bareos File Daemon and Bareos Director. If set, this value overrides [`Heartbeat Interval (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_HeartbeatInterval). See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- Job Retention[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_JobRetention)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 15552000 Since Version: deprecated  The Job Retention directive defines the length of time that Bareos  will keep Job records in the Catalog database after the Job End time.  When this time period expires and [`Auto Prune (Dir->Client) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_AutoPrune) Bareos will prune (remove) Job records that are older than the  specified File Retention period. As with the other retention periods,  this affects only records in the catalog and not data in your archive  backup. If a Job record is selected for pruning, all associated File and  JobMedia records will also be pruned regardless of the File Retention  period set. As a consequence, you normally will set the File retention  period to be less than the Job retention period. The Job retention  period can actually be less than the value you specify here if you set  the [`Volume Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention) directive to a smaller duration. This is because the Job retention  period and the Volume retention period are independently applied, so the smaller of the two takes precedence. The default is 180 days.

- Lan Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_LanAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 16.2.6  Sets additional address used for connections between Client and Storage Daemon inside separate network. This directive might be useful in network setups where the Bareos  Director and Bareos Storage Daemon need different addresses to  communicate with the Bareos File Daemon. For details, see [Using different IP Adresses for SD – FD Communication](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#lanaddress). This directive corresponds to [`Lan Address (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_LanAddress).

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)  The speed parameter specifies the maximum allowed bandwidth that a job may use when started for this Client.

- Maximum Concurrent Jobs[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  This directive specifies the maximum number of Jobs with the current  Client that can run concurrently. Note, this directive limits only Jobs  for Clients with the same name as the resource in which it appears. Any  other restrictions on the maximum concurrent jobs such as in the  Director, Job or Storage resources will also apply in addition to any  limit specified here.

- Name

  Required: True

  Type: NAME

  资源的名称。将在作业资源指令或控制台运行命令中使用的客户端名称。

- NDMP Block Size[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpBlockSize)

  Type: [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32) Default value: 64512  This directive sets the default NDMP blocksize for this client.

- NDMP Log Level[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpLogLevel)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 4  This directive sets the loglevel for the NDMP protocol library.

- NDMP Use LMDB[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_NdmpUseLmdb)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes

- Passive[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Passive)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 13.2.0  If enabled, the Storage Daemon will initiate the network connection  to the Client. If disabled, the Client will initiate the network  connection to the Storage Daemon. The normal way of initializing the data channel (the channel where  the backup data itself is transported) is done by the file daemon  (client) that connects to the storage daemon. By using the client passive mode, the initialization of the  datachannel is reversed, so that the storage daemon connects to the  filedaemon. See chapter [Passive Client](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-passiveclient).

- Password

  Required: True

  Type: AUTOPASSWORD

  这是在与文件服务建立连接时要使用的密码，so the Client configuration file on the machine to be backed up must have the same password defined for this Director. 因此要备份的计算机上的客户端配置文件必须具有为此控制器定义的相同密码。

  密码为纯文本。

- Port

  Type: PINT32

  Default value: 9102

- Protocol

  Type: AUTH_PROTOCOL_TYPE

  Default value: Native

  Since Version: 13.2.0

  用于运行作业的备份协议。

  目前，director 了解以下协议：

  1. Native - The native Bareos protocol
  2. NDMP - The NDMP protocol

- Quota Include Failed Jobs[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_QuotaIncludeFailedJobs)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  When calculating the amount a client used take into consideration any failed Jobs.

- Soft Quota[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuota)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) Default value: 0  This is the amount after which there will be a warning issued that a  client is over his softquota. A client can keep doing backups until it  hits the hard quota or when the [`Soft Quota Grace Period (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuotaGracePeriod) is expired.

- Soft Quota Grace Period[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuotaGracePeriod)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Time allowed for a client to be over its [`Soft Quota (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_SoftQuota) before it will be enforced. When the amount of data backed up by the client outruns the value  specified by the Soft Quota directive, the next start of a backup job  will start the soft quota grace time period. This is written to the job  log
  
  ```bash
  Error: Softquota Exceeded, Grace Period starts now.
  ```
  
  In the Job Overview, the value of Grace Expiry Date: will then change from **Soft Quota was never exceeded** to the date when the grace time expires, e.g. **11-Dec-2012 04:09:05**.
  
  During that period, it is possible to do backups even if the total  amount of stored data exceeds the limit specified by soft quota.
  
  If in this state, the job log will write:
  
  ```bash
  Error: Softquota Exceeded, will be enforced after Grace Period expires.
  ```
  
  After the grace time expires, in the next backup job of the client, the value for Burst Quota will be  set to the value that the client has stored at this point in time. Also, the job will be terminated. The following information in the job log  shows what happened:
  
  ```bash
  Warning: Softquota Exceeded and Grace Period expired.
  Setting Burst Quota to 122880000 Bytes.
  Fatal error: Soft Quota Exceeded / Grace Time expired. Job terminated.
  ```
  
  At this point, it is not possible to do any backup of the client. To be  able to do more backups, the amount of stored data for this client has  to fall under the burst quota value.

- Strict Quotas[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_StrictQuotas)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  The directive Strict Quotas determines whether, after the Grace Time  Period is over, to enforce the Burst Limit (Strict Quotas = No) or the  Soft Limit (Strict Quotas = Yes). The Job Log shows either 
  
  ```bash
  Softquota Exceeded, enforcing Burst Quota Limit.
  ```
  
  or
  
  ```bash
  Softquota Exceeded, enforcing Strict Quota Limit.
  ```

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see, how the Bareos Director (and the other components) must be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- Username

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Specifies the username that must be supplied when authenticating. Only used for the non Native protocols at the moment.指定身份验证时必须提供的用户名。目前仅用于非本机协议。

以下是有效的客户端资源定义的示例：

```bash
Client {
  Name = client1-fd
  Address = client1.example.com
  Password = "secret"
}
```

The following is an example of a Quota Configuration in Client resource:以下是客户端资源中的配置配置示例：

```bash
Client {
  Name = client1-fd
  Address = client1.example.com
  Password = "secret"

  # Quota
  Soft Quota = 50 mb
  Soft Quota Grace Period = 2 days
  Strict Quotas = Yes
  Hard Quota = 150 mb
  Quota Include Failed Jobs = yes
}
```

## Storage 资源

存储资源定义哪些存储守护程序可供 Director 使用。

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`Allow Compression (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AllowCompression) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Auth Type (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AuthType) | = [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) | None          |              |
| [`Auto Changer (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Cache Status Interval (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_CacheStatusInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 30            |              |
| [`Collect Statistics (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_CollectStatistics) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | *no*          | *deprecated* |
| [`Description (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Device (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Device) | = [`DEVICE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-device) |               | **required** |
| [`Enable kTLS (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Enabled (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Enabled) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Heartbeat Interval (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Lan Address (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_LanAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Maximum Bandwidth Per Job (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |               |              |
| [`Maximum Concurrent Jobs (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Maximum Concurrent Read Jobs (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumConcurrentReadJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 0             |              |
| [`Media Type (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MediaType) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               | **required** |
| [`Name (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`NDMP Changer Device (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_NdmpChangerDevice) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Paired Storage (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_PairedStorage) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Password (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | **required** |
| [`Port (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Port) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9103          |              |
| [`Protocol (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Protocol) | = [`AUTH_PROTOCOL_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_protocol_type) | Native        |              |
| [`SD Address (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | *alias*      |
| [`SD Password (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdPassword) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | *alias*      |
| [`SD Port (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | *9103*        | *alias*      |
| [`TLS Allowed CN (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Username (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Username) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |

- Address

  Required: True

  Type: STRING

  其中地址是主机名、完全限定域名或 IP 地址。请注意，此处指定的 <address> 将被传输到 File 守护程序，后者将使用它来联系 Storage 守护程序。因此，使用 localhost 作为名称不是一个好主意，而是一个完全限定的机器名或 IP 地址。此指令是必需的。

- Allow Compression

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) 

  Default value: yes

  此指令是可选的，如果指定为 No，it will cause  backups jobs running on this storage resource to run without client File Daemon compression. 则会导致在此存储资源上运行的备份作业在不压缩客户端File Daemon的情况下运行。This effectively overrides compression options in  FileSets used by jobs which use this storage resource.这将有效地覆盖使用此存储资源的作业所使用的文件集中的压缩选项。

- Auth Type[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AuthType)

  Type: [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) Default value: None  Specifies the authentication type that must be supplied when  connecting to a backup protocol that uses a specific authentication  type.

- Auto Changer[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  When [`Device (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Device) refers to an Auto Changer ([`Autochanger (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger)), this directive must be set to **yes**. If you specify **yes**, Volume management command like **label** or **add** will request a Autochanger Slot number. Bareos will prefer Volumes, that are in a Auto Changer slot. If  none of theses volumes can be used, even after recycling, pruning, …,  Bareos will search for any volume of the same [`Media Type (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MediaType) whether or not in the magazine. Please consult the [Autochanger & Tape drive Support](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#autochangerschapter) chapter for details.

- Cache Status Interval[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_CacheStatusInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 30

- Collect Statistics[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_CollectStatistics)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: deprecated  Collect statistic information. These information will be collected by the Director (see [`Statistics Collect Interval (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_StatisticsCollectInterval)) and stored in the Catalog.

- Description

  Type: STRING

  信息。

- Device[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Device)

  Required: True Type: [`DEVICE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-device)  If [`Protocol (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Protocol) is not **NDMP_NATIVE** (default is [`Protocol (Dir->Job) = Native`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Protocol)), this directive refers to one or multiple [`Name (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Name) or a single [`Name (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Name). If an Autochanger should be used, it had to refer to a configured [`Name (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Name). In this case, also set [`Auto Changer (Dir->Storage) = yes`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger). Otherwise it refers to one or more configured [`Name (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Name), see [Using Multiple Storage Devices](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html#section-multiplestoragedevices). This name is not the physical device name, but the logical device name as defined in the Bareos Storage Daemon resource. If [`Protocol (Dir->Job) = NDMP_NATIVE`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Protocol), it refers to tape devices on the NDMP Tape Agent, see [NDMP_NATIVE](https://docs.bareos.org/TasksAndConcepts/NdmpBackupsWithBareos.html#section-ndmpnative).

- Enable kTLS[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Enabled

  Type: BOOLEAN

  Default value: yes

  启用或禁用此资源。

- Heartbeat Interval[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets between the defined storage and Bareos Director. If set, this value overrides [`Heartbeat Interval (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_HeartbeatInterval). See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- Lan Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_LanAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 16.2.6  Sets additional address used for connections between Client and Storage Daemon inside separate network. This directive might be useful in network setups where the Bareos  Director and Bareos File Daemon need different addresses to communicate  with the Bareos Storage Daemon. For details, see [Using different IP Adresses for SD – FD Communication](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#lanaddress). This directive corresponds to [`Lan Address (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_LanAddress).

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)

- Maximum Concurrent Jobs[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  This directive specifies the maximum number of Jobs with the current  Storage resource that can run concurrently. Note, this directive limits  only Jobs for Jobs using this Storage daemon. Any other restrictions on  the maximum concurrent jobs such as in the Director, Job or Client  resources will also apply in addition to any limit specified here. If you set the Storage daemon’s number of concurrent jobs greater than one, we recommend that you read [Concurrent Jobs](https://docs.bareos.org/Appendix/Troubleshooting.html#concurrentjobs) and/or turn data spooling on as documented in [Data Spooling](https://docs.bareos.org/TasksAndConcepts/DataSpooling.html#spoolingchapter).

- Maximum Concurrent Read Jobs[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumConcurrentReadJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0  This directive specifies the maximum number of Jobs with the current Storage resource that can read concurrently.

- Media Type

  Required: True

  Type: STRNAME

  此指令指定用于存储数据的介质类型。这是您定义的任意字符串，最多 127 个字符。你想要什么都行。但是，最好是使其描述存储介质（例如文件，DAT，“HP DLT 8000”，8毫米，...）。In addition, it is essential that you make the Media  Type specification unique for each storage media type. 此外，必须使介质类型规范对每种存储介质类型唯一。如果您有两个格式不兼容的 DDS-4 驱动器，或者您有一个 DDS-4 驱动器和一个 DDS-4 autochanger自动转换器，you almost certainly should specify different Media Types.您几乎肯定应该指定不同的介质类型。在还原过程中，assuming a DDS-4 Media Type is associated with the  Job, Bareos can decide to use any Storage daemon that supports Media  Type DDS-4 and on any drive that supports it. 假设DDS-4介质类型与作业关联，Bareos可以决定使用任何支持介质类型DDS-4的存储守护程序以及任何支持该介质类型的驱动器。

  如果要写入磁盘卷，则必须加倍确保Storage守护进程（以及Director的conf文件）中定义的每个Device资源都具有唯一的媒体类型。you must make doubly sure that  each Device resource defined in the Storage daemon (and hence in the  Director’s conf file) has a unique media type. Otherwise Bareos may  assume, these Volumes can be mounted and read by any Storage daemon File device.否则，Bareos可能会认为，这些磁盘可以安装和读取任何存储守护程序文件设备。

  目前，Bareos 只允许每个存储设备定义一个介质类型。Consequently, if you have a drive that supports more than  one Media Type, you can give a unique string to Volumes with different  intrinsic Media Type (Media Type = DDS-3-4 for DDS-3 and DDS-4 types),  but then those volumes will only be mounted on drives indicated with the dual type (DDS-3-4). 因此，如果您的驱动器支持多个介质类型，则可以给予一个唯一的字符串，以使用不同的固有介质类型（对于DDS-3和DDS-4类型，介质类型= DDS-3-4）进行磁盘驱动器升级，但这些卷将仅装载在指示为双类型（DDS-3-4）的驱动器上。

  如果要将Bareos绑定到使用单个存储守护程序或驱动器，则必须为该驱动器指定唯一的介质类型。这是一个重要的观点，应该仔细理解。请注意，这同样适用于磁盘驱动器。如果您在Storage守护程序的conf文件中定义了多个磁盘设备资源，则这两个设备上的磁盘资源实际上是不兼容的，因为一个设备无法挂载到另一个设备上，因为它们位于不同的目录中。出于这个原因，您可能应该为两个磁盘设备使用两种不同的媒体类型（即使您可能认为它们都是文件类型）。您可以在本手册的“基本卷管理”一章中找到有关此主题的更多信息。If you want to tie Bareos to using a single Storage daemon or drive,  you must specify a unique Media Type for that drive. This is an  important point that should be carefully understood. Note, this applies  equally to Disk Volumes. If you define more than one disk Device  resource in your Storage daemon’s conf file, the Volumes on those two  devices are in fact incompatible because one can not be mounted on the  other device since they are found in different directories. For this  reason, you probably should use two different Media Types for your two disk Devices (even  though you might think of them as both being File types). You can find  more on this subject in the [Basic Volume Management](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html#diskchapter) chapter of this manual. 

  The MediaType specified in the Director’s Storage resource, must  correspond to the Media Type specified in the Device resource of the  Storage daemon configuration file. 在控制器的存储资源中指定的MediaType必须与存储守护程序配置文件的设备资源中指定的媒体类型相对应。此指令是必需的，and it is used by the Director and the Storage daemon to ensure that a Volume  automatically selected from the Pool corresponds to the physical device. If a Storage daemon handles multiple devices (e.g. will write to  various file Volumes on different partitions), this directive allows you to specify exactly which device. Director和Storage守护程序使用它来确保从池中自动选择的卷与物理设备相对应。如果存储守护进程处理多个设备（例如，将写入不同分区上的各种文件夹），则此指令允许您指定确切的设备。

  如上所述，the value specified in the Director’s Storage  resource must agree with the value specified in the Device resource in  the Storage daemon’s configuration file. 控制器的存储资源中指定的值必须与存储守护程序的配置文件中的设备资源中指定的值一致。这也是一种额外的检查，这样您就不会尝试将 DLT 的数据写入 8mm 设备。

- Name

  Required: True

  Type: NAME

  This name appears on the Storage directive specified in the Job resource资源的名称。

  存储资源的名称。此名称出现在作业资源中指定的存储指令上，并且是必需的。

- NDMP Changer Device[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_NdmpChangerDevice)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) Since Version: 16.2.4  Allows direct control of a Storage Daemon Auto Changer device by the Director. Only used in NDMP_NATIVE environments.

- Paired Storage[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_PairedStorage)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  For NDMP backups this points to the definition of the Native Storage  that is accesses via the NDMP protocol. For now we only support NDMP  backups and restores to access Native Storage Daemons via the NDMP  protocol. In the future we might allow to use Native NDMP storage which  is not bound to a Bareos Storage Daemon.

- Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Password)

  Required: True Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  This is the password to be used when establishing a connection with  the Storage services. This same password also must appear in the  Director resource of the Storage daemon’s configuration file. This  directive is required. The password is plain text.

- Port[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Port)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9103  Where port is the port to use to contact the storage daemon for  information and to start jobs. This same port number must appear in the  Storage resource of the Storage daemon’s configuration file.

- Protocol[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Protocol)

  Type: [`AUTH_PROTOCOL_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_protocol_type) Default value: Native

- SD Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Alias for Address.

- SD Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdPassword)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  Alias for Password.

- SD Port[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_SdPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9103  Alias for Port.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. For details, refer to chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives).

- TLS Key[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- Username

  Type: STRING

以下是有效的存储资源定义的示例：

```bash
Storage {
  Name = DLTDrive
  Address = lpmatou
  Password = storage\_password # password for Storage daemon
  Device = "HP DLT 80"    # same as Device in Storage daemon
  Media Type = DLT8000    # same as MediaType in Storage daemon
}
```



## Pool 资源

池资源定义了 Bareos 用来写入数据的一组存储卷（磁带或文件）。通过配置不同的池，您可以确定哪组卷（介质）接收备份数据。例如，这允许将所有完整备份数据存储在一组卷上，将所有增量备份存储在另一组卷上。或者，您可以为备份的每台计算机分配一组不同的卷。This is most easily done by defining multiple  Pools.这是最容易做到的，定义多个变量。

Another important aspect of a Pool is that it contains the default  attributes (Maximum Jobs, Retention Period, Recycle flag, …) that will  be given to a Volume when it is created. This avoids the need for you to answer a large number of questions when labeling a new Volume. Each of  these attributes can later be changed on a Volume by Volume basis using  the **update** command in the console program. Note that you must explicitly specify which Pool Bareos is to use with each Job. Bareos will not automatically search for the correct Pool.

池的另一个重要方面是它包含创建卷时将赋予卷的默认属性（最大作业数、保留期、回收标志等）。这避免了您在标记新卷时回答大量问题的需要。这些属性中的每一个都可以在以后使用控制台程序中的更新命令逐个卷地更改。请注意，您必须显式指定每个作业要使用哪个池Bareo。Bareos不会自动搜索正确的池。

要使用池，有三个不同的步骤。首先，必须在控制器的配置中定义池。然后必须将池写入目录数据库。每次启动时，Director都会自动执行此操作。最后，如果您在Director的配置文件中更改池定义并重新启动Bareos，则池将被更新，您也可以使用update pool控制台命令刷新数据库映像。默认卷属性使用的是此数据库映像，而不是Director的资源映像。注意，要自动创建或更新池，作业资源必须显式引用它。

如果未启用自动标记（请参阅自动卷标记），则必须手动标记物理介质。可以使用控制台程序中的label命令或使用btape程序进行标记。首选方法是在控制台程序中使用label命令。一般情况下，设备类型（Sd->设备）=文件时启用自动标记，设备类型（Sd->设备）=磁带时禁用自动标记。

最后，您必须将卷名称（及其属性）添加到池中。对于要由Bareos使用的磁盘，它们必须与为作业指定的归档设备具有相同的介质类型（Sd->Device）（即，如果您要备份到DLT设备，则池必须定义DLT卷，因为8 mm卷无法装载在DLT驱动器上）。如果要备份到文件，则介质类型（Sd->设备）特别重要。运行作业时，必须显式指定要使用的池。然后，Bareos将自动从池中选择下一个要使用的卷，但它将确保从池中选择的任何卷的介质类型（Sd->设备）与您为作业指定的存储资源所需的介质类型相同。

如果您在控制台程序中使用label命令来标记磁盘，它们将自动添加到池中，因此通常不需要最后一步。

也可以在不显式标记物理卷的情况下向数据库添加磁盘。这是通过add console命令完成的。

如前所述，每次Bareos启动时，它都会扫描与每个Catalog关联的所有数据库记录，如果数据库记录不存在，则会从Pool Resource定义中创建。如果更改池定义，则必须手动调用控制台程序中的update pool命令，以将更改传播到现有卷。



To use a Pool, there are three distinct steps. First the Pool must be defined in the Director’s configuration. Then the Pool must be written  to the Catalog database. This is done automatically by the Director each time that it starts. Finally, if you change the Pool definition in the  Director’s configuration file and restart Bareos, the pool will be  updated alternatively you can use the **update pool** console command to refresh the database image. It is this database  image rather than the Director’s resource image that is used for the default  Volume attributes. Note, for the pool to be automatically created or  updated, it must be explicitly referenced by a Job resource.

If automatic labeling is not enabled (see [Automatic Volume Labeling](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html#automaticlabeling)) the physical media must be manually labeled. The labeling can either be done with the **label** command in the console program or using the **btape** program. The preferred method is to use the **label** command in the console program. Generally, automatic labeling is enabled for [`Device Type (Sd->Device) = File`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType)and disabled for [`Device Type (Sd->Device) = Tape`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType).

Finally, you must add Volume names (and their attributes) to the  Pool. For Volumes to be used by Bareos they must be of the same [`Media Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType) as the archive device specified for the job (i.e. if you are going to  back up to a DLT device, the Pool must have DLT volumes defined since  8mm volumes cannot be mounted on a DLT drive). The [`Media Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType) has particular importance if you are backing up to files. When running a Job, you must explicitly specify which Pool to use.  Bareos will then automatically select the next Volume to use from the  Pool, but it will ensure that the [`Media Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType) of any Volume selected from the Pool is identical to that required by the Storage resource you have specified for the Job.

If you use the **label** command in the console program to label the Volumes, they will  automatically be added to the Pool, so this last step is not normally  required.

It is also possible to add Volumes to the database without explicitly labeling the physical volume. This is done with the **add** console command.

As previously mentioned, each time Bareos starts, it scans all the  Pools associated with each Catalog, and if the database record does not  already exist, it will be created from the Pool Resource definition. If  you change the Pool definition, you manually have to call **update pool** command in the console program to propagate the changes to existing volumes.

Director 配置中定义的池资源可能包含以下指令：

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Action On Purge (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_ActionOnPurge) | = [`ACTION_ON_PURGE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-action_on_purge) |               |              |
| [`Auto Prune (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_AutoPrune) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Catalog (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Catalog) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Catalog Files (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_CatalogFiles) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Cleaning Prefix (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_CleaningPrefix) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) | CLN           |              |
| [`Description (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`File Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_FileRetention) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Job Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_JobRetention) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Label Type (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelType) | = [`LABEL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-label) |               | *deprecated* |
| [`Maximum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumBlockSize) | = [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32) |               |              |
| [`Maximum Volume Bytes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeBytes) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Maximum Volume Files (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeFiles) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`Maximum Volume Jobs (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`Maximum Volumes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumes) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`Migration High Bytes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationHighBytes) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Migration Low Bytes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationLowBytes) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Migration Time (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationTime) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |
| [`Minimum Block Size (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MinimumBlockSize) | = [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32) |               |              |
| [`Name (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Next Pool (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_NextPool) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Pool Type (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_PoolType) | = [`POOLTYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pooltype) | Backup        |              |
| [`Purge Oldest Volume (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_PurgeOldestVolume) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Recycle (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Recycle) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Recycle Current Volume (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecycleCurrentVolume) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Recycle Oldest Volume (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecycleOldestVolume) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Recycle Pool (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecyclePool) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Scratch Pool (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_ScratchPool) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Storage (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Storage) | = [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               |              |
| [`Use Catalog (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_UseCatalog) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Volume Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 31536000      |              |
| [`Volume Use Duration (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeUseDuration) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) |               |              |

- Action On Purge[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_ActionOnPurge)

  Type: [`ACTION_ON_PURGE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-action_on_purge)  The directive `Action On Purge=Truncate` instructs Bareos to truncate the volume when it is purged with the **purge volume action=truncate** command. It is useful to prevent disk based volumes from consuming too much space.

- Auto Prune[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_AutoPrune)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If `Auto Prune=yes`, the [`Volume Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention) period is automatically applied when a new Volume is needed and no  appendable Volumes exist in the Pool. Volume pruning causes expired Jobs (older than the [`Volume Retention (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention) period) to be deleted from the Catalog and permits possible recycling of the Volume.

- Catalog[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Catalog)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  This specifies the name of the catalog resource to be used for this  Pool. When a catalog is defined in a Pool it will override the  definition in the client (and the Catalog definition in a Job since *Version >= 13.4.0*). e.g. this catalog setting takes precedence over any other definition.

- Catalog Files[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_CatalogFiles)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  This directive defines whether or not you want the names of the files that were saved to be put into the catalog. If disabled, the Catalog  database will be significantly smaller. The disadvantage is that you  will not be able to produce a Catalog listing of the files backed up for each Job (this is often called Browsing). Also, without the File  entries in the catalog, you will not be able to use the Console **restore** command nor any other command that references File entries.

- Cleaning Prefix[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_CleaningPrefix)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) Default value: CLN  This directive defines a prefix string, which if it matches the  beginning of a Volume name during labeling of a Volume, the Volume will  be defined with the VolStatus set to Cleaning and thus Bareos will never attempt to use this tape. This is primarily for use with autochangers  that accept barcodes where the convention is that barcodes beginning  with CLN are treated as cleaning tapes. The default value for this directive is consequently set to CLN, so  that in most cases the cleaning tapes are automatically recognized  without configuration. If you use another prefix for your cleaning  tapes, you can set this directive accordingly.

- Description

  Type: STRING

- File Retention[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_FileRetention)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time)  The File Retention directive defines the length of time that Bareos  will keep File records in the Catalog database after the End time of the Job corresponding to the File records. This directive takes precedence over Client directives of the same  name. For example, you can decide to increase Retention times for  Archive or OffSite Pool. Note, this affects only records in the catalog database. It does not affect your archive backups. For more information see Client documentation about [`File Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_FileRetention)

- Job Retention[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_JobRetention)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time)  The Job Retention directive defines the length of time that Bareos  will keep Job records in the Catalog database after the Job End time. As with the other retention periods, this affects only records in the  catalog and not data in your archive backup. This directive takes precedence over Client directives of the same  name. For example, you can decide to increase Retention times for  Archive or OffSite Pool. For more information see Client side documentation [`Job Retention (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_JobRetention)

- Label Format[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This directive specifies the format of the labels contained in this  pool. The format directive is used as a sort of template to create new  Volume names during automatic Volume labeling. The format should be specified in double quotes (`"`), and consists of letters, numbers and the special characters hyphen (`-`), underscore (`_`), colon (`:`), and period (`.`), which are the legal characters for a Volume name. In addition, the format may contain a number of variable expansion  characters which will be expanded by a complex algorithm allowing you to create Volume names of many different formats. In all cases, the  expansion process must resolve to the set of characters noted above that are legal Volume names. Generally, these variable expansion characters  begin with a dollar sign (`$`) or a left bracket (`[`). For more details on variable expansion, please see [Variable Expansion on Volume Labels](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-variableexpansionvolumelabels). If no variable expansion characters are found in the string, the  Volume name will be formed from the format string appended with the a  unique number that increases. If you do not remove volumes from the  pool, this number should be the number of volumes plus one, but this is  not guaranteed. The unique number will be edited as four digits with  leading zeros. For example, with a **Label Format = “File-”**, the first volumes will be named **File-0001**, **File-0002**, … In almost all cases, you should enclose the format specification (part after the equal sign) in double quotes (`"`).

- Label Type[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelType)

  Type: [`LABEL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-label) Since Version: deprecated  This directive is implemented in the Director Pool resource and in the SD Device resource ([`Label Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelType)). If it is specified in the SD Device resource, it will take precedence over the value passed from the Director to the SD.

- Maximum Block Size[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumBlockSize)

  Type: [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32) Since Version: 14.2.0  The **Maximum Block Size** can be defined here to define different block sizes per volume or statically for all volumes at [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize). Increasing this value may improve the throughput of writing to tapes.  Warning However make sure to read the [Setting Block Sizes](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#setblocksizes) chapter carefully before applying any changes.

- Maximum Volume Bytes[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeBytes)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)  This directive specifies the maximum number of bytes that can be  written to the Volume. If you specify zero (the default), there is no  limit except the physical size of the Volume. Otherwise, when the number of bytes written to the Volume equals size the Volume will be marked  Used. When the Volume is marked Used it can no longer be used for  appending Jobs, much like the Full status but it can be recycled if  recycling is enabled, and thus the Volume can be re-used after  recycling. This value is checked and the Used status set while the job is writing to the  particular volume. This directive is particularly useful for restricting the size of  disk volumes, and will work correctly even in the case of multiple  simultaneous jobs writing to the volume. The value defined by this directive in the bareos-dir.conf file is  the default value used when a Volume is created. Once the volume is  created, changing the value in the bareos-dir.conf file will not change  what is stored for the Volume. To change the value for an existing  Volume you must use the update command in the Console.

- Maximum Volume Files[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeFiles)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This directive specifies the maximum number of files that can be  written to the Volume. If you specify zero (the default), there is no  limit. Otherwise, when the number of files written to the Volume equals  positive-integer the Volume will be marked Used. When the Volume is  marked Used it can no longer be used for appending Jobs, much like the  Full status but it can be recycled if recycling is enabled and thus used again. This value is checked and the Used status is set only at the end of a job that writes to the particular volume. The value defined by this directive in the bareos-dir.conf file is  the default value used when a Volume is created. Once the volume is  created, changing the value in the bareos-dir.conf file will not change  what is stored for the Volume. To change the value for an existing  Volume you must use the update command in the Console.

- Maximum Volume Jobs[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This directive specifies the maximum number of Jobs that can be  written to the Volume. If you specify zero (the default), there is no  limit. Otherwise, when the number of Jobs backed up to the Volume equals positive-integer the Volume will be marked Used. When the Volume is  marked Used it can no longer be used for appending Jobs, much like the  Full status but it can be recycled if recycling is enabled, and thus  used again. By setting MaximumVolumeJobs to one, you get the same effect as setting UseVolumeOnce = yes. The value defined by this directive in the bareos-dir.conf file is  the default value used when a Volume is created. Once the volume is  created, changing the value in the bareos-dir.conf file will not change  what is stored for the Volume. To change the value for an existing  Volume you must use the update command in the Console. If you are running multiple simultaneous jobs, this directive may not work correctly because when a drive is reserved for a job, this  directive is not taken into account, so multiple jobs may try to start  writing to the Volume. At some point, when the Media record is updated,  multiple simultaneous jobs may fail since the Volume can no longer be  written.

- Maximum Volumes[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumes)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This directive specifies the maximum number of volumes (tapes or  files) contained in the pool. This directive is optional, if omitted or  set to zero, any number of volumes will be permitted. In general, this  directive is useful to ensure that the number of volumes does not become too numerous when using automatic labeling.

- Migration High Bytes[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationHighBytes)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)  This directive specifies the number of bytes in the Pool which will trigger a migration if [`Selection Type (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_SelectionType) = PoolOccupancy has been specified. The fact that the Pool usage goes  above this level does not automatically trigger a migration job.  However, if a migration job runs and has the PoolOccupancy selection  type set, the Migration High Bytes will be applied. Bareos does not  currently restrict a pool to have only a single [`Media Type (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MediaType), so you must keep in mind that if you mix Media Types in a Pool, the  results may not be what you want, as the Pool count of all bytes will be for all Media Types combined.

- Migration Low Bytes[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationLowBytes)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)  This directive specifies the number of bytes in the Pool which will stop a migration if [`Selection Type (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_SelectionType) = PoolOccupancy has been specified and triggered by more than [`Migration High Bytes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationHighBytes) being in the pool. In other words, once a migration job is started with PoolOccupancy migration selection and it determines that there are more than Migration High Bytes, the migration job will continue to run jobs until the number of bytes in the Pool drop to or below Migration Low  Bytes.

- Migration Time[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MigrationTime)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time)  If [`Selection Type (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_SelectionType) = PoolTime, the time specified here will be used. If the previous  Backup Job or Jobs selected have been in the Pool longer than the  specified time, then they will be migrated.

- Minimum Block Size[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MinimumBlockSize)

  Type: [`SIZE32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size32)  The **Minimum Block Size** can be defined here to define different block sizes per volume or statically for all volumes at [`Minimum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MinimumBlockSize). For details, see chapter [Setting Block Sizes](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#setblocksizes).

- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the resource. The name of the pool.

- Next Pool[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_NextPool)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  This directive specifies the pool a Migration or Copy Job and a  Virtual Backup Job will write their data too. This directive is required to define the Pool into which the data will be migrated. Without this  directive, the migration job will terminate in error.

- Pool Type

  Type: POOLTYPE

  Default value: Backup

  此指令定义池类型，which corresponds to the type  of Job being run. 该类型对应于正在运行的作业的类型。它是必需的，可以是以下之一：

  * Backup
  * *Archive
  * *Cloned
  * *Migration
  * *Copy
  * *Save

  Note, only Backup is currently implemented.

- Purge Oldest Volume[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_PurgeOldestVolume)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive instructs the Director to search for the oldest used  Volume in the Pool when another Volume is requested by the Storage  daemon and none are available. The catalog is then purged irrespective  of retention periods of all Files and Jobs written to this Volume. The  Volume is then recycled and will be used as the next Volume to be  written. This directive overrides any Job, File, or Volume retention  periods that you may have specified. This directive can be useful if you have a fixed number of Volumes in the Pool and you want to cycle through them and reusing the oldest one  when all Volumes are full, but you don’t want to worry about setting  proper retention periods. However, by using this option you risk losing  valuable data. In most cases, you should use [`Recycle Oldest Volume (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecycleOldestVolume) instead.  Warning Be aware that **Purge Oldest Volume** disregards all retention periods. If you have only a single Volume defined and you turn this variable on, that Volume will always be immediately overwritten when it fills!  So at a minimum, ensure that you have a decent number of Volumes in your Pool before running any jobs.  If you want retention periods to apply do not use this directive.\ We **highly** recommend against using this directive, because it is sure that some day, Bareos will purge a Volume that contains current data.

- Recycle[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Recycle)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  This directive specifies whether or not Purged Volumes may be recycled. If it is set to **yes** and Bareos needs a volume but finds none that are appendable, it will  search for and recycle (reuse) Purged Volumes (i.e. volumes with all the Jobs and Files expired and thus deleted from the Catalog). If the  Volume is recycled, all previous data written to that Volume will be  overwritten. If Recycle is set to **no**, the Volume will  not be recycled, and hence, the data will remain valid. If you want to reuse (re-write) the Volume,  and the recycle flag is no (0 in the catalog), you may manually set the  recycle flag (update command) for a Volume to be reused. Please note that the value defined by this directive in the  configuration file is the default value used when a Volume is created.  Once the volume is created, changing the value in the configuration file will not change what is stored for the Volume. To change the value for  an existing Volume you must use the **update volume** command. When all Job and File records have been pruned or purged from the  catalog for a particular Volume, if that Volume is marked as Append,  Full, Used, or Error, it will then be marked as Purged. Only Volumes  marked as Purged will be considered to be converted to the Recycled  state if the **Recycle** directive is set to **yes**.

- Recycle Current Volume[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecycleCurrentVolume)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If Bareos needs a new Volume, this directive instructs Bareos to  Prune the volume respecting the Job and File retention periods. If all  Jobs are pruned (i.e. the volume is Purged), then the Volume is recycled and will be used as the next Volume to be written. This directive  respects any Job, File, or Volume retention periods that you may have  specified. This directive can be useful if you have: a fixed number of Volumes  in the Pool, you want to cycle through them, and you have specified  retention periods that prune Volumes before you have cycled through the  Volume in the Pool. However, if you use this directive and have only one Volume in the  Pool, you will immediately recycle your Volume if you fill it and Bareos needs another one. Thus your backup will be totally invalid. Please use this directive with care.

- Recycle Oldest Volume[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecycleOldestVolume)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive instructs the Director to search for the oldest used  Volume in the Pool when another Volume is requested by the Storage  daemon and none are available. The catalog is then pruned respecting the retention periods of all Files and Jobs written to this Volume. If all  Jobs are pruned (i.e. the volume is Purged), then the Volume is recycled and will be used as the next Volume to be written. This directive  respects any Job, File, or Volume retention periods that you may have  specified. This directive can be useful if you have a fixed number of Volumes in the Pool and you want to cycle through them and you have specified the  correct retention periods. However, if you use this directive and have only one Volume in the  Pool, you will immediately recycle your Volume if you fill it and Bareos needs another one. Thus your backup will be totally invalid. Please use this directive with care.

- Recycle Pool[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_RecyclePool)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  This directive defines to which pool the Volume will be placed  (moved) when it is recycled. Without this directive, a Volume will  remain in the same pool when it is recycled. With this directive, it can be moved automatically to any existing pool during a recycle. This  directive is probably most useful when defined in the Scratch pool, so  that volumes will be recycled back into the Scratch pool. For more on  the see the [Scratch Pool](https://docs.bareos.org/Configuration/Director.html#thescratchpool) section of this manual. Although this directive is called RecyclePool, the Volume in question is actually moved from its current pool to the one you specify on this  directive when Bareos prunes the Volume and discovers that there are no  records left in the catalog and hence marks it as Purged.

- Scratch Pool[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_ScratchPool)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  This directive permits to specify a dedicate *Scratch* for the current pool. This pool will replace the special pool named *Scrach* for volume selection. For more information about *Scratch* see [Scratch Pool](https://docs.bareos.org/Configuration/Director.html#thescratchpool) section of this manual. This is useful when using multiple storage  sharing the same mediatype or when you want to dedicate volumes to a  particular set of pool.

- Storage[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_Storage)

  Type: [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list)  The Storage directive defines the name of the storage services where  you want to backup the FileSet data. For additional details, see the [Storage Resource](https://docs.bareos.org/Configuration/Director.html#directorresourcestorage) of this manual. The Storage resource may also be specified in the Job  resource, but the value, if any, in the Pool resource overrides any  value in the Job. This Storage resource definition is not required by  either the Job resource or in the Pool, but it must be specified in one  or the other. If not configuration error will result. We highly recommend that you define the Storage  resource to be used in the Pool rather than elsewhere (job, schedule  run, …). Be aware that you theoretically can give a list of storages  here but only the first item from the list is actually used for backup  and restore jobs.

- Use Catalog[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_UseCatalog)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Store information into Catalog. In all pratical use cases, leave this value to its defaults.

- Volume Retention[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeRetention)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 31536000  The Volume Retention directive defines the length of time that Bareos will keep records associated with the Volume in the Catalog database  after the End time of each Job written to the Volume. When this time  period expires, and if AutoPrune is set to yes Bareos may prune (remove) Job records that are older than the specified Volume Retention period  if it is necessary to free up a Volume. Recycling will not occur until  it is absolutely necessary to free up a volume (i.e. no other writable  volume exists). All File records associated with pruned Jobs are also pruned.  The time may be specified as seconds, minutes, hours, days, weeks,  months, quarters, or years. The Volume Retention is applied  independently of the Job Retention and the File Retention periods  defined in the Client resource. This means that all the retentions  periods are applied in turn and that the shorter period is the one that  effectively takes precedence. Note, that when the Volume Retention  period has been reached, and it is necessary to obtain a new volume, Bareos will prune both the Job  and the File records. This pruning could also occur during a status dir  command because it uses similar algorithms for finding the next  available Volume. It is important to know that when the Volume Retention period  expires, Bareos does not automatically recycle a Volume. It attempts to  keep the Volume data intact as long as possible before over writing the  Volume. By defining multiple Pools with different Volume Retention periods,  you may effectively have a set of tapes that is recycled weekly, another Pool of tapes that is recycled monthly and so on. However, one must  keep in mind that if your Volume Retention period is too short, it may  prune the last valid Full backup, and hence until the next Full backup  is done, you will not have a complete backup of your system, and in  addition, the next Incremental or Differential backup will be promoted  to a Full backup. As a consequence, the minimum Volume Retention period should be  at twice the interval of your Full backups. This means that if you do a  Full backup once a month, the minimum Volume retention period should be  two months. The default Volume retention period is 365 days, and either the  default or the value defined by this directive in the bareos-dir.conf  file is the default value used when a Volume is created. Once the volume is created, changing the value in the `bareos-dir.conf` file will not change what is stored for the Volume. To change the value for an existing Volume you must use the update command in the Console.

- Volume Use Duration[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_VolumeUseDuration)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time)  The Volume Use Duration directive defines the time period that the  Volume can be written beginning from the time of first data write to the Volume. If the time-period specified is zero (the default), the Volume  can be written indefinitely. Otherwise, the next time a job runs that  wants to access this Volume, and the time period from the first write to the volume (the first Job written) exceeds the  time-period-specification, the Volume will be marked Used, which means  that no more Jobs can be appended to the Volume, but it may be recycled if recycling is enabled.  Once the Volume is recycled, it will be available for use again. You might use this directive, for example, if you have a Volume used  for Incremental backups, and Volumes used for Weekly Full backups. Once  the Full backup is done, you will want to use a different Incremental  Volume. This can be accomplished by setting the Volume Use Duration for  the Incremental Volume to six days. I.e. it will be used for the 6 days  following a Full save, then a different Incremental volume will be used. Be careful about setting the duration to short periods such as 23  hours, or you might experience problems of Bareos waiting for a tape over the  weekend only to complete the backups Monday morning when an operator  mounts a new tape. Please note that the value defined by this directive in the  bareos-dir.conf file is the default value used when a Volume is created. Once the volume is created, changing the value in the bareos-dir.conf  file will not change what is stored for the Volume. To change the value  for an existing Volume you must use the :ref:` update volume  <UpdateCommand>` command in the Console.

以下是有效的池资源定义的示例：

```bash
Pool {
  Name = Default
  Pool Type = Backup
}
```

### Scratch Pool

一般来说，您可以给予您的池任意名称，但有一个重要的限制：名为 Scratch 的池，if it exists behaves  like a scratch pool of Volumes in that when Bareos needs a new Volume  for writing and it cannot find one, it will look in the Scratch pool,  and if it finds an available Volume, it will move it out of the Scratch  pool into the Pool currently being used by the job.如果它存在，则其行为类似于磁盘的暂存池，当Bareos需要一个新的卷进行写入而无法找到时，它将在暂存池中查找，如果找到可用的卷，则将其从暂存池移到作业当前正在使用的池中。

## Catalog 资源

The Catalog Resource defines what catalog to use for the current job.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | *alias*      |
| [`DB Address (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`DB Name (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbName) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`DB Password (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPassword) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               |              |
| [`DB Port (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`DB Socket (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbSocket) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`DB User (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbUser) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Description (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Disable Batch Insert (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DisableBatchInsert) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Exit On Fatal (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_ExitOnFatal) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Idle Timeout (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_IdleTimeout) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 30            |              |
| [`Inc Connections (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_IncConnections) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Max Connections (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MaxConnections) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 5             |              |
| [`Min Connections (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MinConnections) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Multiple Connections (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MultipleConnections) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) |               |              |
| [`Name (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | *alias*      |
| [`Reconnect (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Reconnect) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`User (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_User) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | *alias*      |
| [`Validate Timeout (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_ValidateTimeout) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 120           |              |

- Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Address)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  *This directive is an alias.* Alias for [`DB Address (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbAddress).

- DB Address[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  This is the host address of the database server. Normally, you would specify this instead of [`DB Socket (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbSocket) if the database server is on another machine. In that case, you will also specify [`DB Port (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPort).

- DB Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbName)

  Required: True Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  This specifies the name of the database.

- DB Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPassword)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  This specifies the password to use when login into the database.

- DB Port[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This defines the port to be used in conjunction with [`DB Address (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbAddress) to access the database if it is on another machine.

- DB Socket[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbSocket)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  This is the name of a socket to use on the local host to connect to the database. Normally, if neither [`DB Socket (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbSocket) or [`DB Address (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbAddress) are specified, the default socket will be used.

- DB User[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbUser)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  This specifies what user name to use to log into the database.

- Description[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Disable Batch Insert[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DisableBatchInsert)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive allows you to override at runtime if the Batch insert  should be enabled or disabled. Normally this is determined by querying  the database library if it is thread-safe. If you think that disabling  Batch insert will make your backup run faster you may disable it using  this option and set it to **Yes**.

- Exit On Fatal[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_ExitOnFatal)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 15.1.0  Make any fatal error in the connection to the database exit the program

- Idle Timeout[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_IdleTimeout)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 30  This directive is used by the experimental database pooling  functionality. Only use this for non production sites.  This sets the  idle time after which a database pool should be shrinked. This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  idle time after which a database pool should be shrinked.

- Inc Connections[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_IncConnections)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  number of connections to add to a database pool when not enough  connections are available on the pool anymore. This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  number of connections to add to a database pool when not enough  connections are available on the pool anymore.

- Max Connections[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MaxConnections)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 5  This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  maximum number of connections to a database to keep in this database  pool. This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  maximum number of connections to a database to keep in this database  pool.

- Min Connections[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MinConnections)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  minimum number of connections to a database to keep in this database  pool. This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  minimum number of connections to a database to keep in this database  pool.

- Multiple Connections[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_MultipleConnections)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit)  Not yet implemented.

- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the resource. The name of the Catalog. No necessary relation to the database server name. This name will be specified in the Client resource directive  indicating that all catalog data for that Client is maintained in this  Catalog.

- Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Password)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  *This directive is an alias.* Alias for [`DB Password (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbPassword).

- Reconnect[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Reconnect)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes Since Version: 15.1.0  Try to reconnect a database connection when it is dropped

- User[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_User)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  *This directive is an alias.* Alias for [`DB User (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_DbUser).

- Validate Timeout[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_ValidateTimeout)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 120  This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  validation timeout after which the database connection is polled to see  if its still alive. This directive is used by the experimental database pooling  functionality. Only use this for non production sites. This sets the  validation timeout after which the database connection is polled to see  if its still alive.

以下是有效的目录资源定义的示例：

```bash
Catalog
{
  Name = MyCatalog
  DB Name = bareos;
  DB User = bareos;
  DB Password = ""
}
```

or for a Catalog on another machine:或对于另一台计算机上的目录：

```bash
Catalog
{
  Name = RemoteCatalog
  DB Name = bareos
  DB User = bareos
  DB Password = "secret"
  DB Address = remote.example.com
  DB Port = 1234
}
```



## Messages 资源

For the details of the Messages Resource, please see the [Messages Configuration](https://docs.bareos.org/Configuration/Messages.html#messageschapter) of this manual.

## Console 资源

There are three different kinds of consoles, which the administrator  or user can use to interact with the Director. These three kinds of  consoles comprise three different security levels.

- Default Console

   the first console type is an “anonymous” or “default” console, which  has full privileges. There is no console resource necessary for this  type since the password is specified in the Director’s resource and  consequently such consoles do not have a name as defined on a **Name** directive. Typically you would use it only for administrators.

- Named Console

     the second type of console, is a “named” console (also called  “Restricted Console”) defined within a Console resource in both the  Director’s configuration file and in the Console’s configuration file.  Both the names and the passwords in these two entries must match much as is the case for Client programs. This second type of console begins with absolutely no privileges  except those explicitly specified in the Director’s Console resource.  Thus you can have multiple Consoles with different names and passwords,  sort of like multiple users, each with different privileges. As a  default, these consoles can do absolutely nothing – no commands  whatsoever. You give them privileges or rather access to commands and  resources by specifying access control lists in the Director’s Console  resource. The ACLs are specified by a directive followed by a list of access names.  Examples of this are shown below. The third type of console is similar to the above mentioned one  in that it requires a Console resource definition in both the Director  and the Console. In addition, if the console name, provided on the [`Name (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Name) directive, is the same as a Client name, that console is permitted to use the **SetIP** command to change the Address directive in the Director’s client resource to the IP address of the Console. This permits portables or other machines using DHCP (non-fixed IP addresses) to “notify” the Director of their current IP address.

The Console resource is optional and need not be specified. The following directives are permitted within these resources:

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Catalog ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CatalogAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Client ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_ClientAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Command ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CommandAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Description (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`File Set ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_FileSetAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Job ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_JobAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Name (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | **required** |
| [`Plugin Options ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_PluginOptionsAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Pool ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_PoolAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Profile (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Profile) | = [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               |              |
| [`Schedule ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_ScheduleAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Storage ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_StorageAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`TLS Allowed CN (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Use Pam Authentication (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_UsePamAuthentication) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Where ACL (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_WhereAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |

- Catalog ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CatalogAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Catalog resources, this resource has access to. The special keyword *all* allows access to all Catalog resources. This directive is used to specify a list of Catalog resource names that can be accessed by the console.

- Client ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_ClientAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Client resources, this resource has access to. The special keyword *all* allows access to all Client resources. This directive is used to specify a list of Client resource names that can be accessed by the console.

- Command ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_CommandAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the commands, this resource has access to. The special keyword *all* allows using commands. This directive is used to specify a list of of console commands that can be executed by the console. See [Command ACL example](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-commandaclexample).

- Description[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- File Set ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_FileSetAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the File Set resources, this resource has access to. The special keyword *all* allows access to all File Set resources. This directive is used to specify a list of FileSet resource names that can be accessed by the console.

- Job ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_JobAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Job resources, this resource has access to. The special keyword *all* allows access to all Job resources. This directive is used to specify a list of Job resource names that  can be accessed by the console. Without this directive, the console  cannot access any of the Director’s Job resources. Multiple Job resource names may be specified by separating them with commas, and/or by  specifying multiple **Job ACL** directives. For example, the directive may be specified as: `JobACL = "backup-bareos-fd", "backup-www.example.com-fd" JobACL = "RestoreFiles" `



- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the console. This name must match the name specified at the Console client.

- Password[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Password)

  Required: True Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  Specifies the password that must be supplied for a named Bareos Console to be authorized.

- Plugin Options ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_PluginOptionsAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the allowed plugin options. An empty strings allows all Plugin Options. Use this directive to specify the list of allowed Plugin Options.

- Pool ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_PoolAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Pool resources, this resource has access to. The special keyword *all* allows access to all Pool resources. This directive is used to specify a list of Pool resource names that can be accessed by the console.

- Profile[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Profile)

  Type: [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) Since Version: 14.2.3  Profiles can be assigned to a Console. ACL are checked until either a deny ACL is found or an allow ACL. First the console ACL is checked  then any profile the console is linked to. One or more Profile names can be assigned to a Console. If an ACL is  not defined in the Console, the profiles of the Console will be checked  in the order as specified here. The first found ACL will be used. See [Profile Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceprofile).

- Schedule ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_ScheduleAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Schedule resources, this resource has access to. The special keyword *all* allows access to all Schedule resources. This directive is used to specify a list of Schedule resource names that can be accessed by the console.

- Storage ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_StorageAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Storage resources, this resource has access to. The special keyword *all* allows access to all Storage resources. This directive is used to specify a list of Storage resource names that can be accessed by the console.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see, how the Bareos Director (and the other components) must be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- Use Pam Authentication[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_UsePamAuthentication)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 18.2.4  If set to yes, PAM will be used to authenticate the user on this  console. Otherwise, only the credentials of this console resource are  used for authentication.

- Where ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_WhereAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the base directories, where files could be restored. An empty string allows restores to all directories. This directive permits you to specify where a restricted console can  restore files. If this directive is not specified, only the default  restore location is permitted (normally `/tmp/bareos-restores`. If ***all\*** is specified any path the user enters will be accepted. Any other value specified (there may be multiple **Where ACL** directives) will restrict the user to use that path. For example, on a Unix system, if you specify “/”, the file will be restored to the original location.

The example at [Using Named Consoles](https://docs.bareos.org/Configuration/Console.html#section-consoleaccessexample) shows how to use a console resource for a connection from a client like **bconsole**.



## User 资源

Each user who wants to login using PAM needs a dedicated User  Resource in the Bareos Director configuration. The main purpose is to  configure ACLs as shown in the table below, they are the same as in the [Console Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceconsole) and the [Profile Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceprofile).

If a user is authenticated with PAM but is not authorized by a user resource, the login will be denied by the Bareos Director.

Refer to chapter [Pluggable Authentication Modules (PAM)](https://docs.bareos.org/TasksAndConcepts/PAM.html#pamconfigurationchapter) for details how to configure PAM.

The following table contains all configurable directives in the User Resource:

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Catalog ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_CatalogAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Client ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_ClientAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Command ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_CommandAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Description (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`File Set ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_FileSetAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Job ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_JobAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Name (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Plugin Options ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_PluginOptionsAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Pool ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_PoolAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Profile (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Profile) | = [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               |              |
| [`Schedule ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_ScheduleAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Storage ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_StorageAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Where ACL (Dir->User)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_WhereAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |

- Catalog ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_CatalogAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Catalog resources, this resource has access to. The special keyword *all* allows access to all Catalog resources.

- Client ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_ClientAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Client resources, this resource has access to. The special keyword *all* allows access to all Client resources.

- Command ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_CommandAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the commands, this resource has access to. The special keyword *all* allows using commands.

- Description[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- File Set ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_FileSetAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the File Set resources, this resource has access to. The special keyword *all* allows access to all File Set resources.

- Job ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_JobAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Job resources, this resource has access to. The special keyword *all* allows access to all Job resources.

- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)

- Plugin Options ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_PluginOptionsAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the allowed plugin options. An empty strings allows all Plugin Options.

- Pool ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_PoolAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Pool resources, this resource has access to. The special keyword *all* allows access to all Pool resources.

- Profile[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_Profile)

  Type: [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) Since Version: 14.2.3  Profiles can be assigned to a Console. ACL are checked until either a deny ACL is found or an allow ACL. First the console ACL is checked  then any profile the console is linked to.

- Schedule ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_ScheduleAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Schedule resources, this resource has access to. The special keyword *all* allows access to all Schedule resources.

- Storage ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_StorageAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Storage resources, this resource has access to. The special keyword *all* allows access to all Storage resources.

- Where ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_User_WhereAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the base directories, where files could be restored. An empty string allows restores to all directories.



## Profile 资源 

The Profile Resource defines a set of ACLs. [Console Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceconsole) can be tight to one or more profiles ([`Profile (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Profile)), making it easier to use a common set of ACLs.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Catalog ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CatalogAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Client ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ClientAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Command ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CommandAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Description (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`File Set ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_FileSetAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Job ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_JobAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Name (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Plugin Options ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PluginOptionsAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Pool ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PoolAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Schedule ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ScheduleAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Storage ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_StorageAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |
| [`Where ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_WhereAcl) | = [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl) |               |              |

- Catalog ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CatalogAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Catalog resources, this resource has access to. The special keyword *all* allows access to all Catalog resources.

- Client ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ClientAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Client resources, this resource has access to. The special keyword *all* allows access to all Client resources.

- Command ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CommandAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the commands, this resource has access to. The special keyword *all* allows using commands.

- Description[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Additional information about the resource. Only used for UIs.

- File Set ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_FileSetAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the File Set resources, this resource has access to. The special keyword *all* allows access to all File Set resources.

- Job ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_JobAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Job resources, this resource has access to. The special keyword *all* allows access to all Job resources.

- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the resource.

- Plugin Options ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PluginOptionsAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the allowed plugin options. An empty strings allows all Plugin Options.

- Pool ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PoolAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Pool resources, this resource has access to. The special keyword *all* allows access to all Pool resources.

- Schedule ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ScheduleAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Schedule resources, this resource has access to. The special keyword *all* allows access to all Schedule resources.

- Storage ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_StorageAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Lists the Storage resources, this resource has access to. The special keyword *all* allows access to all Storage resources.

- Where ACL[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_WhereAcl)

  Type: [`ACL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-acl)  Specifies the base directories, where files could be restored. An empty string allows restores to all directories.



## Counter 资源

The Counter Resource defines a counter variable that can be accessed  by variable expansion used for creating Volume labels with the [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) directive.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Catalog (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Catalog) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |
| [`Description (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Maximum (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Maximum) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 2147483647    |              |
| [`Minimum (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Minimum) | = [`INT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-int32) | 0             |              |
| [`Name (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Wrap Counter (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_WrapCounter) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |               |              |

- Catalog[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Catalog)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  If this directive is specified, the counter and its values will be  saved in the specified catalog. If this directive is not present, the  counter will be redefined each time that Bareos is started.

- Description[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Maximum[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Maximum)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 2147483647  This is the maximum value value that the counter can have. If not  specified or set to zero, the counter can have a maximum value of  2,147,483,648 (2 to the 31 power). When the counter is incremented past  this value, it is reset to the Minimum.

- Minimum[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Minimum)

  Type: [`INT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-int32) Default value: 0  This specifies the minimum value that the counter can have. It also becomes the default. If not supplied, zero is assumed.

- Name[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the resource. The name of the Counter. This is the name you will use in the variable expansion to reference the counter value.

- Wrap Counter[](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_WrapCounter)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)  If this value is specified, when the counter is incremented past the  maximum and thus reset to the minimum, the counter specified on the [`Wrap Counter (Dir->Counter)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Counter_WrapCounter) is incremented. (This is currently not implemented).
