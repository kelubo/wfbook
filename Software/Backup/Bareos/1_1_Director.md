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

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  [![Allow Duplicate Jobs usage](https://docs.bareos.org/master/_images/duplicate-real.svg)](https://docs.bareos.org/master/_images/duplicate-real.svg) Allow Duplicate Jobs usage[](https://docs.bareos.org/master/Configuration/Director.html#fig-allowduplicatejobs)  A duplicate job in the sense we use it here means a second or  subsequent job with the same name starts. This happens most frequently  when the first job runs longer than expected because no tapes are  available. If this directive is enabled duplicate jobs will be run. If the directive is set to **no** then only one job of a given name may run at one time. The action that  Bareos takes to ensure only one job runs is determined by the directives [`Cancel Lower Level Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelLowerLevelDuplicates) [`Cancel Queued Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelQueuedDuplicates) [`Cancel Running Duplicates (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_CancelRunningDuplicates) If none of these directives is set to **yes**, Allow Duplicate Jobs is set to **no** and two jobs are present, then the current job (the second one started) will be cancelled. Virtual backup jobs of a consolidation are not affected by the directive. In those cases the directive is going to be ignored.

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

- Catalog[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Catalog)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res) Since Version: 13.4.0  This specifies the name of the catalog resource to be used for this  Job. When a catalog is defined in a Job it will override the definition  in the client.

- Client[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Client)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Client directive specifies the Client (File daemon) that will be  used in the current Job. Only a single Client may be specified in any  one Job. The Client runs on the machine to be backed up, and sends the  requested files to the Storage daemon for backup, or receives them when  restoring. For additional details, see the [Client Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourceclient) of this chapter. This directive is required For versions before 13.3.0, this directive is required for all Jobtypes. For *Version >= 13.3.0* it is required for all Jobtypes but Copy or Migrate jobs.

- Client Run After Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunAfterJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that run on the client after a backup job.

- Client Run Before Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_ClientRunBeforeJob)

  Type: [`RUNSCRIPT_SHORT`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-runscript_short)  This is basically a shortcut for the [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) resource, that run on the client before the backup job.  Warning For compatibility reasons, with this shortcut, the command is executed directly when the client receive it. And if the command is in error, other remote runscripts will be discarded. To be sure that all commands will be sent and executed, you have to use [`Run Script (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RunScript) syntax.

- `Description`

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

- Level[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Level)

  Type: [`BACKUP_LEVEL`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-backup_level)  The Level directive specifies the default Job level to be run. Each different [`Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Type) (Backup, Restore, Verify, …) has a different set of Levels that can be  specified. The Level is normally overridden by a different value that is specified in the [Schedule Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourceschedule). This directive is not required, but must be specified either by this directive or as an override specified in the [Schedule Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourceschedule). BackupFor a Backup Job, the Level may be one of the following: FullWhen the Level is set to Full all files in the FileSet whether or not they have changed will be backed up. IncrementalWhen the Level is set to  Incremental all files specified in the FileSet that have changed since  the last successful backup of the the same Job using the same FileSet  and Client, will be backed up. If the Director cannot find a previous  valid Full backup then the job will be upgraded into a Full backup. When the Director looks for a valid backup record in the catalog database,  it looks for a previous Job with: The same Job name. The same Client name. The same FileSet (any change to the definition of the FileSet  such as adding or deleting a file in the Include or Exclude sections  constitutes a different FileSet. The Job was a Full, Differential, or Incremental backup. The Job terminated normally (i.e. did not fail or was not canceled). The Job started no longer ago than Max Full Interval. If all the above conditions do not hold, the Director will upgrade  the Incremental to a Full save. Otherwise, the Incremental backup will  be performed as requested. The File daemon (Client) decides which files to backup for an  Incremental backup by comparing start time of the prior Job (Full,  Differential, or Incremental) against the time each file was last  “modified” (st_mtime) and the time its attributes were last  “changed”(st_ctime). If the file was modified or its attributes changed  on or after this start time, it will then be backed up. Some virus scanning software may change st_ctime while doing the  scan. For example, if the virus scanning program attempts to reset the  access time (st_atime), which Bareos does not use, it will cause  st_ctime to change and hence Bareos will backup the file during an  Incremental or Differential backup. In the case of Sophos virus  scanning, you can prevent it from resetting the access time (st_atime)  and hence changing st_ctime by using the **–no-reset-atime** option. For other software, please see their manual. When Bareos does an Incremental backup, all modified files that are  still on the system are backed up. However, any file that has been  deleted since the last Full backup remains in the Bareos catalog, which  means that if between a Full save and the time you do a restore, some  files are deleted, those deleted files will also be restored. The  deleted files will no longer appear in the catalog after doing another  Full save. In addition, if you move a directory rather than copy it, the files  in it do not have their modification time (st_mtime) or their attribute  change time (st_ctime) changed. As a consequence, those files will  probably not be backed up by an Incremental or Differential backup which depend solely on these time stamps. If you move a directory, and wish  it to be properly backed up, it is generally preferable to copy it, then delete the original. However, to manage deleted files or directories changes in the catalog during an Incremental backup you can use [Accurate mode](https://docs.bareos.org/master/Configuration/Director.html#accuratemode). This is quite memory consuming process. DifferentialWhen the Level is set to Differential all  files specified in the FileSet that have changed since the last  successful Full backup of the same Job will be backed up. If the  Director cannot find a valid previous Full backup for the same Job,  FileSet, and Client, backup, then the Differential job will be upgraded  into a Full backup. When the Director looks for a valid Full backup  record in the catalog database, it looks for a previous Job with: The same Job name. The same Client name. The same FileSet (any change to the definition of the FileSet  such as adding or deleting a file in the Include or Exclude sections  constitutes a different FileSet. The Job was a FULL backup. The Job terminated normally (i.e. did not fail or was not canceled). The Job started no longer ago than Max Full Interval. If all the above conditions do not hold, the Director will upgrade  the Differential to a Full save. Otherwise, the Differential backup will be performed as requested. The File daemon (Client) decides which files to backup for a  differential backup by comparing the start time of the prior Full backup Job against the time each file was last “modified” (st_mtime) and the  time its attributes were last “changed” (st_ctime). If the file was  modified or its attributes were changed on or after this start time, it  will then be backed up. The start time used is displayed after the Since on the Job report. In rare cases, using the start time of the prior  backup may cause some files to be backed up twice, but it ensures that no  change is missed. When Bareos does a Differential backup, all modified files that are  still on the system are backed up. However, any file that has been  deleted since the last Full backup remains in the Bareos catalog, which  means that if between a Full save and the time you do a restore, some  files are deleted, those deleted files will also be restored. The  deleted files will no longer appear in the catalog after doing another  Full save. However, to remove deleted files from the catalog during a Differential backup is quite a time consuming process and not currently  implemented in Bareos. It is, however, a planned future feature. As noted above, if you move a directory rather than copy it, the  files in it do not have their modification time (st_mtime) or their  attribute change time (st_ctime) changed. As a consequence, those files  will probably not be backed up by an Incremental or Differential backup  which depend solely on these time stamps. If you move a directory, and  wish it to be properly backed up, it is generally preferable to copy it, then delete the original. Alternatively, you can move the directory,  then use the touch program to update the timestamps. However, to manage deleted files or directories changes in the catalog during an Differential backup you can use [Accurate mode](https://docs.bareos.org/master/Configuration/Director.html#accuratemode). This is quite memory consuming process. See for more details. Every once and a while, someone asks why we need Differential backups as long as Incremental backups pickup all changed files. There are  possibly many answers to this question, but the one that is the most  important for me is that a Differential backup effectively merges all  the Incremental and Differential backups since the last Full backup into a single Differential backup. This has two effects: 1. It gives some  redundancy since the old backups could be used if the merged backup  cannot be read. 2. More importantly, it reduces the number of Volumes that are  needed to do a restore effectively eliminating the need to read all the  volumes on which the preceding Incremental and Differential backups  since the last Full are done. VirtualFullWhen the Level is set to VirtualFull, a new Full backup is generated from  the last existing Full backup and the matching Differential- and  Incremental-Backups. It matches this according the [`Name (Dir->Client)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Client_Name) and [`Name (Dir->Fileset)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Fileset_Name). This means, a new Full backup get created without transfering all the data from the client to the backup server again. The new Full backup will be stored in the pool defined in [`Next Pool (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_NextPool). Warning Opposite to the other backup levels, VirtualFull may require read and write access to multiple volumes. In most cases you have to make sure,  that Bareos does not try to read and write to the same Volume. With Virtual Full, you are restricted to use the same Bareos Storage  Daemon for the source and the destination, because the restore bsr file  created for the job can only be read by one storage daemon at a time.   RestoreFor a Restore Job, no level needs to be specified. VerifyFor a Verify Job, the Level may be one of the following: InitCatalogdoes a scan of the specified  FileSet and stores the file attributes in the Catalog database. Since no file data is saved, you might ask why you would want to do this. It  turns out to be a very simple and easy way to have a Tripwire like  feature using Bareos. In other words, it allows you to save the state of a set of files defined by the FileSet and later check to see if those  files have been modified or deleted and if any new files have been  added. This can be used to detect system intrusion. Typically you would specify a FileSet that contains the set of system files that should not change  (e.g. /sbin, /boot, /lib, /bin, …). Normally, you run the InitCatalog  level verify one time when your system is first setup, and then once  again after each modification (upgrade) to your system. Thereafter, when your want to check the state of your system files, you use a Verify  level = Catalog. This compares the results of your InitCatalog with the current state of the files. CatalogCompares the current state of the  files against the state previously saved during an InitCatalog. Any  discrepancies are reported. The items reported are determined by the  verify options specified on the Include directive in the specified  FileSet (see the FileSet resource below for more details). Typically  this command will be run once a day (or night) to check for any changes  to your system files. Warning If you run two Verify Catalog jobs on the same client at the same time, the results will certainly be incorrect.  This is because Verify Catalog modifies the Catalog database while running in order to track new files.  VolumeToCatalogThis level causes Bareos  to read the file attribute data written to the Volume from the last  backup Job for the job specified on the VerifyJob directive. The file  attribute data are compared to the values saved in the Catalog database  and any differences are reported. This is similar to the DiskToCatalog  level except that instead of comparing the disk file attributes to the  catalog database, the attribute data written to the Volume is read and compared to the catalog database. Although the attribute data including  the signatures (MD5 or SHA1) are compared, the actual file data is not  compared (it is not in the catalog). VolumeToCatalog jobs require a client to extract the metadata, but  this client does not have to be the original client. We suggest to use  the client on the backup server itself for maximum performance. Warning If you run two Verify VolumeToCatalog jobs on the same client at the same time, the results will certainly be incorrect.  This is because the Verify VolumeToCatalog modifies the Catalog database while running.  Limitation: Verify VolumeToCatalog does not check file checksums When running a Verify VolumeToCatalog job the file data will not be  checksummed and compared with the recorded checksum. As a result, file data errors that are introduced between the  checksumming in the Bareos File Daemon and the checksumming of the block by the Bareos Storage Daemon will not be detected.  DiskToCatalogThis level causes Bareos to  read the files as they currently are on disk, and to compare the current file attributes with the attributes saved in the catalog from the last  backup for the job specified on the VerifyJob directive. This level  differs from the VolumeToCatalog level described above by the fact that  it doesn’t compare against a previous Verify job but against a previous  backup. When you run this level, you must supply the verify options on your Include statements. Those options determine what attribute  fields are compared. This command can be very useful if you have disk problems because it  will compare the current state of your disk against the last successful  backup, which may be several jobs. Note, the current implementation does not identify files that have been deleted.

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

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time)  The time specifies the maximum allowed time that a job may block  waiting for a resource (such as waiting for a tape to be mounted, or  waiting for the storage or file daemons to perform their duties),  counted from the when the job starts, (not necessarily the same as when  the job was scheduled). [![Job time control directives](https://docs.bareos.org/master/_images/different_time.png)](https://docs.bareos.org/master/_images/different_time.png) Job time control directives[](https://docs.bareos.org/master/Configuration/Director.html#fig-differenttime)

- Maximum Bandwidth[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaximumBandwidth)

  Type: [`SPEED`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-speed)  The speed parameter specifies the maximum allowed bandwidth that a job may use.

- Maximum Concurrent Jobs[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  Specifies the maximum number of Jobs from the current Job resource  that can run concurrently. Note, this directive limits only Jobs with  the same name as the resource in which it appears. Any other  restrictions on the maximum concurrent jobs such as in the Director,  Client or Storage resources will also apply in addition to the limit  specified here. For details, see the [Concurrent Jobs](https://docs.bareos.org/master/Appendix/Troubleshooting.html#concurrentjobs) chapter.

- Messages[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Messages)

  Required: True Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Messages directive defines what Messages resource should be used  for this job, and thus how and where the various messages are to be  delivered. For example, you can direct some messages to a log file, and  others can be sent by email. For additional details, see the [Messages Resource](https://docs.bareos.org/master/Configuration/Messages.html#messageschapter) Chapter of this manual. This directive is required.

- Name[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the resource. The Job name. This name can be specified on the Run command in the  console program to start a job. If the name contains spaces, it must be  specified between quotes. It is generally a good idea to give your job  the same name as the Client that it will backup. This permits easy  identification of jobs. When the job actually runs, the unique Job Name will consist of the  name you specify here followed by the date and time the job was  scheduled for execution. It is recommended to limit job names to 98 characters. Higher is  always possible, but when the job is run, its name will be truncated to  accomodate certain protocol limitations, as well as the above mentioned  date and time.

- Next Pool[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_NextPool)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  A Next Pool override used for Migration/Copy and Virtual Backup Jobs.

- Pool[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool)

  Required: True Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Pool directive defines the pool of Volumes where your data can be backed up. Many Bareos installations will use only the Default pool.  However, if you want to specify a different set of Volumes for different Clients or different Jobs, you will probably want to use Pools. For  additional details, see the [Pool Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourcepool) of this chapter. This directive is required. In case of a Copy or Migration job, this setting determines what Pool will be examined for finding JobIds to migrate. The exception to this  is when [`Selection Type (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_SelectionType) = SQLQuery, and although a Pool directive must still be specified, no  Pool is used, unless you specifically include it in the SQL query. Note, in any case, the Pool resource defined by the Pool directive must  contain a [`Next Pool (Dir->Pool)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Pool_NextPool) = … directive to define the Pool to which the data will be migrated.

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

- Replace[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Replace)

  Type: [`REPLACE_OPTION`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-replace_option) Default value: Always  This directive applies only to a Restore job and specifies what  happens when Bareos wants to restore a file or directory that already  exists. You have the following options for replace-option: always when  the file to be restored already exists, it is deleted and then replaced  by the copy that was backed up. This is the default value. ifnewer if the backed up file (on tape) is newer than the existing file, the existing file is deleted and replaced by the back up. ifolder if the backed up file (on tape) is older than the existing file, the existing file is deleted and replaced by the back up. never if the backed up file already exists, Bareos skips restoring this file.

- Rerun Failed Levels[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_RerunFailedLevels)

  Type: [`BOOLEAN`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If this directive is set to yes (default no), and Bareos detects that a previous job at a higher level (i.e. Full or Differential) has  failed, the current job level will be upgraded to the higher level. This is particularly useful for Laptops where they may often be unreachable, and if a prior Full save has failed, you wish the very next backup to  be a Full save rather than whatever level it is started as. There are several points that must be taken into account when using  this directive: first, a failed job is defined as one that has not  terminated normally, which includes any running job of the same name  (you need to ensure that two jobs of the same name do not run  simultaneously); secondly, the [`Ignore File Set Changes (Dir->Fileset)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Fileset_IgnoreFileSetChanges) directive is not considered when checking for failed levels, which means that any FileSet change will trigger a rerun.

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

  Type: [`TIME`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0 Since Version: 19.2.4  The interval specifies the time between the most recent successful  backup (counting from start time) and the event of a client initiated  connection. When this interval is exceeded the job is started  automatically.  ![@startgantt [Run On Incoming Connect Interval = 35h] lasts 35 days and is colored in LightBlue [Run On Incoming Connect Interval starts again -->] lasts 18 days and is colored in LightBlue  -- Backups -- [Successful Backup] lasts 8 days [Successful Backup again] lasts 11 days  -- Client connection status -- [Client connected] lasts 10 days and is colored in Lime then [Client disconnected] lasts 10 days and is colored in DeepPink [Connect does not trigger] happens at [Client disconnected]'s end then [Client connected again] lasts 10 days and is colored in Lime then [Client disconnected again] lasts 13 days and is colored in DeepPink [Connect triggers backup] happens at [Client disconnected again]'s end then [Client connected again 2] lasts 11 days and is colored in Lime [Client disconnected again] -> [Client connected again 2] [Client disconnected again] -> [Successful Backup again] [Run On Incoming Connect Interval starts again -->] starts at [Successful Backup again]'s start  @endgantt](https://docs.bareos.org/master/_images/plantuml-47c1af1572ecefb4a6d99a587107685b6003a8e2.svg) Timing example for Run On Incoming Connect Interval[](https://docs.bareos.org/master/Configuration/Director.html#id2)

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

- Schedule[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Schedule)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Schedule directive defines what schedule is to be used for the  Job. The schedule in turn determines when the Job will be automatically  started and what Job level (i.e. Full, Incremental, …) is to be run.  This directive is optional, and if left out, the Job can only be started manually using the Console program. Although you may specify only a  single Schedule resource for any one job, the Schedule resource may  contain multiple Run directives, which allow you to run the Job at many  different times, and each run directive permits overriding the default Job Level  Pool, Storage, and Messages resources. This gives considerable  flexibility in what can be done with a single Job. For additional  details, see [Schedule Resource](https://docs.bareos.org/master/Configuration/Director.html#directorresourceschedule).

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

- Strip Prefix[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_StripPrefix)

  Type: [`STRING`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-string)  This directive applies only to a Restore job and specifies a prefix  to remove from the directory name of all files being restored. This will use the [File Relocation](https://docs.bareos.org/master/TasksAndConcepts/TheRestoreCommand.html#filerelocation) feature. Using `Strip Prefix=/etc`, `/etc/passwd` will be restored to `/passwd` Under Windows, if you want to restore `c:/files` to `d:/files`, you can use: `Strip Prefix = c: Add Prefix = d: `

- Type[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Type)

  Required: True Type: [`JOB_TYPE`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-job_type)  The **Type** directive specifies the Job type, which is one of the following: Backup   Run a  backup Job. Normally you will have at least one Backup job for each  client you want to save. Normally, unless you turn off cataloging, most  all the important statistics and data concerning files backed up will be placed in the catalog.  Restore   Run a  restore Job. Normally, you will specify only one Restore job which acts  as a sort of prototype that you will modify using the console program in order to perform restores. Although certain basic information from a  Restore job is saved in the catalog, it is very minimal compared to the  information stored for a Backup job – for example, no File database  entries are generated since no Files are saved. Restore jobs cannot be automatically started by the scheduler as is  the case for Backup, Verify and Admin jobs. To restore files, you must  use the restore command in the console. Verify   Run a  verify Job. In general, verify jobs permit you to compare the contents  of the catalog to the file system, or to what was backed up. In  addition, to verifying that a tape that was written can be read, you can also use verify as a sort of tripwire intrusion detection.  Admin   Run an  admin Job. An Admin job can be used to periodically run catalog pruning, if you do not want to do it at the end of each Backup Job. Although an  Admin job is recorded in the catalog, very little data is saved.  Migratedefines the job that is run as being a Migration  Job. A Migration Job is a sort of control job and does not have any  Files associated with it, and in that sense they are more or less like  an Admin job. Migration jobs simply check to see if there is anything to Migrate then possibly start and control new Backup jobs to migrate the  data from the specified Pool to another Pool. Note, any original JobId  that is migrated will be marked as having been migrated, and the  original JobId can nolonger be used for restores; all restores will be done from the new migrated  Job. Copydefines the job that is run as being a Copy Job. A  Copy Job is a sort of control job and does not have any Files associated with it, and in that sense they are more or less like an Admin job.  Copy jobs simply check to see if there is anything to Copy then possibly start and control new Backup jobs to copy the data from the specified  Pool to another Pool. Note that when a copy is made, the original JobIds are left unchanged. The new copies can not be used for restoration  unless you specifically choose them by JobId. If you subsequently delete a JobId  that has a copy, the copy will be automatically upgraded to a Backup  rather than a Copy, and it will subsequently be used for restoration. Consolidateis used to consolidate Always Incremental Backups jobs, see [Always Incremental Backup Scheme](https://docs.bareos.org/master/TasksAndConcepts/AlwaysIncrementalBackupScheme.html#section-alwaysincremental). It has been introduced in Bareos *Version >= 16.2.4*.  Within a particular Job Type, there are also Levels, see [`Level (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Level).

- Verify Job[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VerifyJob)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  *This directive is an alias.* If you run a verify job without this directive, the last job run will be compared with the catalog, which means that you must immediately  follow a backup by a verify command. If you specify a Verify Job Bareos  will find the last job with that name that ran. This permits you to run  all your backups, then run Verify jobs on those that you wish to be  verified (most often a VolumeToCatalog) so that the tape just written is re-read.

- Virtual Full Backup Pool[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_VirtualFullBackupPool)

  Type: [`RES`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-res)  The Virtual Full Backup Pool specifies a Pool to be used for Virtual Full backups. It will override any [`Pool (Dir->Job)`](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Pool) specification during a Virtual Full backup.

- Where[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_Where)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)  This directive applies only to a Restore job and specifies a prefix  to the directory name of all files being restored. This permits files to be restored in a different location from which they were saved. If  Where is not specified or is set to backslash (/), the files will be  restored to their original location. By default, we have set Where in  the example configuration files to be /tmp/bareos-restores. This is to  prevent accidental overwriting of your files.  Warning To use Where on NDMP backups, please read [Restore files to different path](https://docs.bareos.org/master/TasksAndConcepts/NdmpBackupsWithBareos.html#section-ndmp-where)

- Write Bootstrap[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_WriteBootstrap)

  Type: [`DIRECTORY_OR_COMMAND`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory_or_command)  The writebootstrap directive specifies a file name where Bareos will  write a bootstrap file for each Backup job run. This directive applies  only to Backup Jobs. If the Backup job is a Full save, Bareos will erase any current contents of the specified file before writing the bootstrap records. If the Job is an Incremental or Differential save, Bareos will append the current bootstrap record to the end of the file. Using this feature, permits you to constantly have a bootstrap file  that can recover the current state of your system. Normally, the file  specified should be a mounted drive on another machine, so that if your  hard disk is lost, you will immediately have a bootstrap record  available. Alternatively, you should copy the bootstrap file to another  machine after it is updated. Note, it is a good idea to write a separate bootstrap file for each Job backed up including the job that backs up  your catalog database. If the bootstrap-file-specification begins with a vertical bar (|),  Bareos will use the specification as the name of a program to which it  will pipe the bootstrap record. It could for example be a shell script  that emails you the bootstrap record. Before opening the file or executing the specified command, Bareos performs [character substitution](https://docs.bareos.org/master/Configuration/Director.html#character-substitution) like in RunScript directive. To automatically manage your bootstrap files, you can use this in your JobDefs resources: `Job Defs {  ...  Write Bootstrap = "%c_%n.bsr"  ... } `



- Write Verify List[](https://docs.bareos.org/master/Configuration/Director.html#config-Dir_Job_WriteVerifyList)

  Type: [`DIRECTORY`](https://docs.bareos.org/master/Configuration/CustomizingTheConfiguration.html#datatype-directory)

The following is an example of a valid Job resource definition:

Job Resource Example[](https://docs.bareos.org/master/Configuration/Director.html#id3)

```
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





## JobDefs Resource



The JobDefs resource permits all the same directives that can appear  in a Job resource. However, a JobDefs resource does not create a Job,  rather it can be referenced within a Job to provide defaults for that  Job. This permits you to concisely define several nearly identical Jobs, each one referencing a JobDefs resource which contains the defaults.  Only the changes from the defaults need to be mentioned in each Job.



## Schedule Resource



The Schedule resource provides a means of automatically scheduling a  Job as well as the ability to override the default Level, Pool, Storage  and Messages resources. If a Schedule resource is not referenced in a  Job, the Job can only be run manually. In general, you specify an action to be taken and when.

| configuration directive name                                 | type of data           | default value | remark       |
| ------------------------------------------------------------ | ---------------------- | ------------- | ------------ |
| [`Description (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Description) | = STRING               |               |              |
| [`Enabled (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Enabled) | = BOOLEAN              | yes           |              |
| [`Name (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Name) | **= NAME**             |               | **required** |
| [`Run (Dir->Schedule)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Schedule_Run) | = SCHEDULE_RUN_COMMAND |               |              |

- `Description`

  Type:STRING

- `Enabled`

  Type:BOOLEAN Default value:yes  En- or disable this resource.

- `Name`

  Required:True Type:NAME  The name of the resource. The name of the schedule being defined.

- `Run`

  Type:SCHEDULE_RUN_COMMAND  The Run directive defines when a Job is to be run, and what overrides if any to apply. You may specify multiple run directives within a  Schedule resource. If you do, they will all be applied (i.e. multiple  schedules). If you have two Run directives that start at the same time,  two Jobs will start at the same time (well, within one second of each  other). The Job-overrides permit overriding the Level, the Storage, the  Messages, and the Pool specifications provided in the Job resource. In  addition, the FullPool, the IncrementalPool, and the DifferentialPool  specifications permit overriding the Pool specification according to  what backup Job Level is in effect. By the use of overrides, you may customize a particular Job. For  example, you may specify a Messages override for your Incremental  backups that outputs messages to a log file, but for your weekly or  monthly Full backups, you may send the output by email by using a  different Messages override. Job-overrides are specified as: keyword=value where the keyword is  Level, Storage, Messages, Pool, FullPool, DifferentialPool, or  IncrementalPool, and the value is as defined on the respective directive formats for the Job resource. You may specify multiple Job-overrides on one Run directive by separating them with one or more spaces or by  separating them with a trailing comma. For example: Level=Full  is all files in the FileSet whether or not they have changed. Level=Incremental  is all files that have changed since the last backup. Pool=Weekly  specifies to use the Pool named Weekly. Storage=DLT_Drive  specifies to use DLT_Drive for the storage device. Messages=Verbose  specifies to use the Verbose message resource for the Job. FullPool=Full  specifies to use the Pool named Full if the job is a full backup, or is upgraded from another type to a full backup. DifferentialPool=Differential  specifies to use the Pool named Differential if the job is a differential backup. IncrementalPool=Incremental  specifies to use the Pool named Incremental if the job is an incremental backup. Accurate=yes|no  tells Bareos to use or not the Accurate code for the specific job. It  can allow you to save memory and and CPU resources on the catalog server in some cases. SpoolData=yes|no  tells Bareos to use or not to use spooling for the specific job. Date-time-specification determines when the Job is to be run. The  specification is a repetition, and as a default Bareos is set to run a  job at the beginning of the hour of every hour of every day of every  week of every month of every year. This is not normally what you want,  so you must specify or limit when you want the job to run. Any  specification given is assumed to be repetitive in nature and will serve to override or limit the default repetition. This is done by specifying masks or times for the hour, day of the month, day of the week, week of the month, week of the year, and month when you want the job to run. By specifying one  or more of the above, you can define a schedule to repeat at almost any  frequency you want. Basically, you must supply a month, day, hour, and minute the Job is  to be run. Of these four items to be specified, day is special in that  you may either specify a day of the month such as 1, 2, … 31, or you may specify a day of the week such as Monday, Tuesday, … Sunday. Finally,  you may also specify a week qualifier to restrict the schedule to the  first, second, third, fourth, or fifth week of the month. For example, if you specify only a day of the week, such as Tuesday  the Job will be run every hour of every Tuesday of every Month. That is  the month and hour remain set to the defaults of every month and all  hours. Note, by default with no other specification, your job will run at  the beginning of every hour. If you wish your job to run more than once  in any given hour, you will need to specify multiple run specifications  each with a different minute. The date/time to run the Job can be specified in the following way in pseudo-BNF: schedule run `<week-keyword>         ::= 1st | 2nd | 3rd | 4th | 5th | first | second | third | fourth | fifth | last <wday-keyword>         ::= sun | mon | tue | wed | thu | fri | sat | sunday | monday | tuesday | wednesday | thursday | friday | saturday <week-of-year-keyword> ::= w00 | w01 | ... w52 | w53 <month-keyword>        ::= jan | feb | mar | apr | may | jun | jul | aug | sep | oct | nov | dec | january | february | ... | december <digit>                ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 <number>               ::= <digit> | <digit><number> <12hour>               ::= 0 | 1 | 2 | ... 12 <hour>                 ::= 0 | 1 | 2 | ... 23 <minute>               ::= 0 | 1 | 2 | ... 59 <day>                  ::= 1 | 2 | ... 31 <time>                 ::= <hour>:<minute> | <12hour>:<minute>am | <12hour>:<minute>pm <time-spec>            ::= at <time> | hourly <day-range>            ::= <day>-<day> <month-range>          ::= <month-keyword>-<month-keyword> <wday-range>           ::= <wday-keyword>-<wday-keyword> <range>                ::= <day-range> | <month-range> | <wday-range> <modulo>               ::= <day>/<day> | <week-of-year-keyword>/<week-of-year-keyword> <date>                 ::= <date-keyword> | <day> | <range> <date-spec>            ::= <date> | <date-spec> <day-spec>             ::= <day> | <wday-keyword> | <day> | <wday-range> | <week-keyword> <wday-keyword> | <week-keyword> <wday-range> | daily <month-spec>           ::= <month-keyword> | <month-range> | monthly <date-time-spec>       ::= <month-spec> <day-spec> <time-spec> `

Note, the Week of Year specification wnn follows the ISO standard  definition of the week of the year, where Week 1 is the week in which  the first Thursday of the year occurs, or alternatively, the week which  contains the 4th of January. Weeks are numbered w01 to w53. w00 for  Bareos is the week that precedes the first ISO week (i.e. has the first  few days of the year if any occur before Thursday). w00 is not defined  by the ISO specification. A week starts with Monday and ends with  Sunday.

According to the NIST (US National Institute of Standards and  Technology), 12am and 12pm are ambiguous and can be defined to anything. However, 12:01am is the same as 00:01 and 12:01pm is the same as 12:01, so Bareos defines 12am as 00:00 (midnight) and 12pm as 12:00 (noon).  You can avoid this abiguity (confusion) by using 24 hour time  specifications (i.e. no am/pm).

An example schedule resource that is named WeeklyCycle and runs a job with level full each Sunday at 2:05am and an incremental job Monday  through Saturday at 2:05am is:

Schedule Example

```
Schedule {
  Name = "WeeklyCycle"
  Run = Level=Full sun at 2:05
  Run = Level=Incremental mon-sat at 2:05
}
```

An example of a possible monthly cycle is as follows:

```
Schedule {
  Name = "MonthlyCycle"
  Run = Level=Full Pool=Monthly 1st sun at 2:05
  Run = Level=Differential 2nd-5th sun at 2:05
  Run = Level=Incremental Pool=Daily mon-sat at 2:05
}
```

The first of every month:

```
Schedule {
  Name = "First"
  Run = Level=Full on 1 at 2:05
  Run = Level=Incremental on 2-31 at 2:05
}
```

The last friday of the month (i.e. the last friday in the last week of the month)

```
Schedule {
  Name = "Last Friday"
  Run = Level=Full last fri at 21:00
}
```

Every 10 minutes:

```
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

Schedule Examples: modulo

```
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

### Technical Notes on Schedules

Internally Bareos keeps a schedule as a bit mask.  There are six masks and a minute field to each schedule. The masks are  hour, day of the month (mday), month, day of the week (wday), week of  the month (wom), and week of the year (woy). The schedule is initialized to have the bits of each of these masks set, which means that at the  beginning of every hour, the job will run. When you specify a month for  the first time, the mask will be cleared and the bit corresponding to  your selected month will be selected. If you specify a second month, the bit corresponding to it  will also be added to the mask. Thus when Bareos checks the masks to see if the bits are set corresponding to the current time, your job will  run only in the two months you have set. Likewise, if you set a time  (hour), the hour mask will be cleared, and the hour you specify will be  set in the bit mask and the minutes will be stored in the minute field.

For any schedule you have defined, you can see how these bits are set by doing a show schedules command in the Console program. Please note  that the bit mask is zero based, and Sunday is the first day of the week (bit zero).



## FileSet Resource

The FileSet resource defines what files are to be  included or excluded in a backup job. A FileSet resource is required for each backup Job. It consists of a list of files or directories to be  included, a list of files or directories to be excluded and the various  backup options such as compression, encryption, and signatures that are  to be applied to each file.

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

  Type:STRING  Information only.

- `Enable VSS`

  Type:BOOLEAN Default value:yes

- `Exclude`

  Type:INCLUDE_EXCLUDE_ITEM  Describe the files, that should get excluded from a backup, see section about the [FileSet Exclude Resource](https://docs.bareos.org/Configuration/Director.html#fileset-exclude).

- `Ignore File Set Changes`

  Type:BOOLEAN Default value:no  Normally, if you modify `File (Dir->Fileset->Include)` or `File (Dir->Fileset->Exclude)` of the FileSet Include or Exclude lists, the next backup will be forced to a full so that Bareos can guarantee that any additions or deletions are properly saved. We strongly recommend against setting this directive to yes, since doing so may cause you to have an incomplete set of backups. If this directive is set to **yes**, any changes you make to the FileSet Include or Exclude lists, will not force a Full during subsequent backups.

- `Include`

  Type:INCLUDE_EXCLUDE_ITEM  Describe the files, that should get included to a backup, see section about the [FileSet Include Resource](https://docs.bareos.org/Configuration/Director.html#fileset-include).

- `Name`

  Required:True Type:NAME  The name of the resource. The name of the FileSet resource.



### FileSet Include Resource

The Include resource must contain a list of directories and/or files to be processed in the backup job.

Normally, all files found in all subdirectories of any directory in  the Include File list will be backed up. The Include resource may also  contain one or more Options resources that specify options such as  compression to be applied to all or any subset of the files found when  processing the file-list for backup. Please see below for more details  concerning Options resources.

There can be any number of Include resources within the FileSet, each having its own list of directories or files to be backed up and the  backup options defined by one or more Options resources.

Please take note of the following items in the FileSet syntax:

1. There is no equal sign (=) after the Include and before the opening brace ({). The same is true for the Exclude.
2. Each directory (or filename) to be included or excluded is preceded  by a File =. Previously they were simply listed on separate lines.
3. The Exclude resource does not accept Options.
4. When using wild-cards or regular expressions, directory names are  always terminated with a slash (/) and filenames have no trailing slash.

- `File`

  Type:“path” Type:“<includefile-server” Type:“\<includefile-client” Type:“|command-server” Type:“\|command-client”  The file list consists of one file or directory name per line.  Directory names should be specified without a trailing slash with Unix  path notation. Note Windows users, please take note to specify directories (even `c:/...`) in Unix path notation. If you use Windows conventions, you will most  likely not be able to restore your files due to the fact that the  Windows path separator was defined as an escape character long before  Windows existed, and Bareos adheres to that convention (i.e. means the  next character appears as itself). You should always specify a full path for every directory and file  that you list in the FileSet. In addition, on Windows machines, you  should always prefix the directory or filename with the drive  specification (e.g. `c:/xxx`) using Unix directory name separators (forward slash). The drive letter itself can be upper or lower case (e.g. `c:/xxx` or `C:/xxx`). A file item may not contain wild-cards. Use directives in the [FileSet Options Resource](https://docs.bareos.org/Configuration/Director.html#fileset-options) if you wish to specify wild-cards or regular expression matching. Bareos’s default for processing directories is to recursively descend in the directory saving all files and subdirectories. Bareos will not  by default cross filesystems (or mount points in Unix parlance). This  means that if you specify the root partition (e.g. `/`), Bareos will save only the root partition and not any of the other  mounted filesystems. Similarly on Windows systems, you must explicitly  specify each of the drives you want saved (e.g. `c:/` and `d:/` …). In addition, at least for Windows systems, you will most likely want to enclose each specification within double quotes particularly if the directory (or file) name  contains spaces. Take special care not to include a directory twice or Bareos will by  default backup the same files two times wasting a lot of space on your  archive device. Including a directory twice is very easy to do. For  example: File Set `Include {  Options {    compression=GZIP  }  File = /  File = /usr } `  on a Unix system where `/usr` is a subdirectory (rather than a mounted filesystem) will cause `/usr` to be backed up twice. Using the directive `Shadowing (Dir->Fileset->Include->Options)` Bareos can be configured to detect and exclude duplicates automatically. To include names containing spaces, enclose the name between double-quotes. There are a number of special cases when specifying directories and files. They are: `@filename` Any name preceded by an at-sign (@) is assumed to  be the name of a file, which contains a list of files each preceded by a “File =”. The named file is read once when the configuration file is  parsed during the Director startup. Note, that the file is read on the  Director’s machine and not on the Client’s. In fact, the @filename can  appear anywhere within a configuration file where a token would be read, and the contents of the named file will be logically inserted in the  place of the @filename. What must be in the file depends on the location the @filename is specified in the conf file. For example: File Set with Include File `Include {  Options {    compression=GZIP  }  @/home/files/my-files } `  `File = "<includefile-server"` Any file item preceded by a less-than sign (`<`) will be taken to be a file. This file will be read on the Director’s  machine (see below for doing it on the Client machine) at the time the  Job starts, and the data will be assumed to be a list of directories or  files, one per line, to be included. The names should start in column 1  and should not be quoted even if they contain spaces. This feature  allows you to modify the external file and change what will be saved  without stopping and restarting Bareos as would be necessary if using  the @ modifier noted above. For example: `Include {  Options {    signature = SHA1  }  File = "</home/files/local-filelist" } `  `File = "\\<includefile-client"` If you precede the less-than sign (`<`) with two backslashes as in `\\<`, the file-list will be read on the Client machine instead of on the Director’s machine. `Include {  Options {    Signature = SHA1  }  File = "\\</home/xxx/filelist-on-client" } `  `File = "|command-server"` Any name beginning with a vertical bar (|) is  assumed to be the name of a program. This program will be executed on  the Director’s machine at the time the Job starts (not when the Director reads the configuration file), and any output from that program will be assumed to be a list of files or directories, one per line, to be  included. Before submitting the specified command Bareos will performe [character substitution](https://docs.bareos.org/Configuration/Director.html#character-substitution). This allows you to have a job that, for example, includes all the  local partitions even if you change the partitioning by adding a disk.  The examples below show you how to do this. However, please note two  things: if you want the local filesystems, you probably should be using the `FS Type (Dir->Fileset->Include->Options)` directive and set `One FS (Dir->Fileset->Include->Options) = no`. the exact syntax of the command needed in the examples below is very system dependent. For example, on recent Linux systems, you may need to add the -P option, on FreeBSD systems, the options will be different as well. In general, you will need to prefix your command or commands with a **sh -c** so that they are invoked by a shell. This will not be the case if you  are invoking a script as in the second example below. Also, you must  take care to escape (precede with a `\`) wild-cards, shell character, and to ensure that any spaces in your  command are escaped as well. If you use a single quotes (’) within a  double quote (“), Bareos will treat everything between the single quotes as one field so it will not be necessary to escape the spaces. In  general, getting all the quotes and escapes correct is a real pain as  you can see by the next example. As a consequence, it is often easier to put everything in a file and simply use the file name within Bareos. In that case the sh -c will not be necessary providing the first line of  the file is #!/bin/sh. As an example: File Set with inline script `Include {   Options {     signature = SHA1   }   File = "|sh -c 'df -l | grep \"^/dev/hd[ab]\" | grep -v \".*/tmp\" | awk \"{print \\$6}\"'" } `  will produce a list of all the local partitions on a Linux system.  Quoting is a real problem because you must quote for Bareos which  consists of preceding every \ and every ” with a \, and you must also  quote for the shell command. In the end, it is probably easier just to  execute a script file with: File Set with external script `Include {  Options {    signature=MD5  }  File = "|my_partitions" } `  where **my_partitions** has: `#!/bin/sh df -l | grep "^/dev/hd[ab]" | grep -v ".*/tmp" \      | awk "{print \$6}" `  `File = "\\|command-client"` If the vertical bar (`|`) in front of **my_partitions** is preceded by a two backslashes as in `\\|`, the program will be executed on the Client’s machine instead of on the  Director’s machine. An example, provided by John Donagher, that backs up all the local UFS partitions on a remote system is: File Set with inline script in quotes `FileSet {  Name = "All local partitions"  Include {    Options {      Signature=SHA1      OneFs=yes    }    File = "\\|bash -c \"df -klF ufs | tail +2 | awk '{print \$6}'\""  } } `  The above requires two backslash characters after the double quote  (one preserves the next one). If you are a Linux user, just change the  ufs to ext3 (or your preferred filesystem type), and you will be in  business. If you know what filesystems you have mounted on your system, e.g.  for Linux only using ext2, ext3 or ext4, you can backup all local  filesystems using something like: File Set to backup all extfs partions `Include {   Options {     Signature = SHA1     OneFs=no     FsType=ext2   }   File = / } `  Raw Partition If you explicitly specify a block device such as `/dev/hda1`, then Bareos will assume that this is a raw partition to be backed up.  In this case, you are strongly urged to specify a Sparse=yes include  option, otherwise, you will save the whole partition rather than just  the actual data that the partition contains. For example: Backup Raw Partitions `Include {  Options {    Signature=MD5    Sparse=yes  }  File = /dev/hd6 } `  will backup the data in device `/dev/hd6`. Note, `/dev/hd6` must be the raw partition itself. Bareos will not back it up as a raw  device if you specify a symbolic link to a raw device such as my be  created by the LVM Snapshot utilities.

- `Exclude Dir Containing`

  Type:filename  This directive can be added to the Include section of the FileSet  resource. If the specified filename (filename-string) is found on the  Client in any directory to be backed up, the whole directory will be  ignored (not backed up). We recommend to use the filename `.nobackup`, as it is a hidden file on unix systems, and explains what is the purpose of the file. For example: Exlude Directories containing the file .nobackup `# List of files to be backed up FileSet {  Name = "MyFileSet"  Include {    Options {      Signature = MD5    }    File = /home    Exclude Dir Containing = .nobackup  } } `  But in `/home`, there may be hundreds of directories of users and some people want to  indicate that they don’t want to have certain directories backed up. For example, with the above FileSet, if the user or sysadmin creates a file named .nobackup in specific directories, such as `/home/user/www/cache/.nobackup /home/user/temp/.nobackup ` then Bareos will not backup the two directories named: `/home/user/www/cache /home/user/temp ` Subdirectories will not be backed up. That is, the directive applies  to the two directories in question and any children (be they files,  directories, etc).



- `Plugin`

  Type:“plugin-name”   “:plugin-parameter1”   “:plugin-parameter2”   “:…”  Instead of only specifying files, a file set can also use plugins.  Plugins are additional libraries that handle specific requirements. The  purpose of plugins is to provide an interface to any system program for  backup and restore. That allows you, for example, to do database backups without a local dump. The syntax and semantics of the Plugin directive require the first  part of the string up to the colon to be the name of the plugin.  Everything after the first colon is ignored by the File daemon but is  passed to the plugin. Thus the plugin writer may define the meaning of  the rest of the string as he wishes. Since *Version >= 20* the plugin string can be spread over multiple lines using quotes as shown above. For more information, see [File Daemon Plugins](https://docs.bareos.org/TasksAndConcepts/Plugins.html#fdplugins). It is also possible to define more than one plugin directive in a FileSet to do several database dumps at once.

- `Options`

  See the [FileSet Options Resource](https://docs.bareos.org/Configuration/Director.html#fileset-options) section.

