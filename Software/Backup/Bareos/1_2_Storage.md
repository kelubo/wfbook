# Storage Daemon 配置

As a consequence, there are quite a large number of  directives in the Device Resource definition that allow you to define  all the characteristics of your Storage device (normally a tape drive).  Fortunately, with modern storage devices, the defaults are sufficient,  and very few directives are actually needed.

Bareos Storage Daemon 配置文件的资源定义相对较少。但是，由于备份介质和系统功能的差异很大，存储守护程序必须具有高度可配置性。因此，在设备资源定义中有相当多的指令，允许您定义存储设备（通常是磁带驱动器）的所有特征。幸运的是，对于现代存储设备，默认值就足够了，实际上只需要很少的指令。

有关配置文件和资源（包括Bareos识别的数据类型）的一般讨论，请参阅本手册的配置章节。必须定义以下存储资源定义：

For a general discussion of configuration file and resources including the data types recognized by Bareos, please see the [Configuration](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#configurechapter) chapter of this manual. The following Storage Resource definitions must be defined:

- [Storage](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourcestorage) – to define the name of the Storage daemon.
- [Director](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourcedirector) – to define the Director’s name and its access password.
- [Device](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourcedevice) – to define the characteristics of your storage device (tape drive).
- [Messages](https://docs.bareos.org/Configuration/Messages.html#messageschapter) – to define where error and information messages are to be sent.

Following resources are optional:

- [Autochanger Resource](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourceautochanger) – to define Autochanger devices.
- [NDMP Resource](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourcendmp) – to define the NDMP authentication context.



## Storage Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#storage-resource)

 

In general, the properties specified under the Storage resource  define global properties of the Storage daemon. Each Storage daemon  configuration file must have one and only one Storage resource  definition.

| configuration directive name                                 | type of data                                                 | default value                                  | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------- | ------------ |
| [`Absolute Job Timeout (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AbsoluteJobTimeout) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                                |              |
| [`Allow Bandwidth Bursting (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AllowBandwidthBursting) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Auto XFlate On Replication (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AutoXFlateOnReplication) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Backend Directory (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_BackendDirectory) | = [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) | /usr/lib/bareos/backends *(platform specific)* |              |
| [`Checkpoint Interval (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CheckpointInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0                                              |              |
| [`Client Connect Wait (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_ClientConnectWait) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800                                           |              |
| [`Collect Device Statistics (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectDeviceStatistics) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | *no*                                           | *deprecated* |
| [`Collect Job Statistics (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectJobStatistics) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | *no*                                           | *deprecated* |
| [`Description (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                                |              |
| [`Device Reserve By Media Type (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_DeviceReserveByMediaType) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Enable kTLS (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`FD Connect Timeout (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_FdConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800                                           |              |
| [`File Device Concurrent Read (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_FileDeviceConcurrentRead) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Heartbeat Interval (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0                                              |              |
| [`Log Timestamp Format (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_LogTimestampFormat) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) | %d-%b %H:%M                                    |              |
| [`Maximum Bandwidth Per Job (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |                                                |              |
| [`Maximum Concurrent Jobs (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 20                                             |              |
| [`Maximum Network Buffer Size (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumNetworkBufferSize) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                                |              |
| [`Messages (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Messages) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |                                                |              |
| [`Name (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |                                                | **required** |
| [`NDMP Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddress) | = [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) | 10000                                          |              |
| [`NDMP Addresses (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddresses) | = [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) | 10000                                          |              |
| [`NDMP Enable (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`NDMP Log Level (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpLogLevel) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 4                                              |              |
| [`NDMP Port (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpPort) | = [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) | 10000                                          |              |
| [`NDMP Snooping (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpSnooping) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Plugin Directory (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_PluginDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`Plugin Names (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_PluginNames) | = [`PLUGIN_NAMES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names) |                                                |              |
| [`Scripts Directory (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_ScriptsDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`SD Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddress) | = [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) | 9103                                           |              |
| [`SD Addresses (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddresses) | = [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) | 9103                                           |              |
| [`SD Connect Timeout (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800                                           |              |
| [`SD Port (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdPort) | = [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) | 9103                                           |              |
| [`SD Source Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdSourceAddress) | = [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) | 0                                              |              |
| [`Secure Erase Command (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SecureEraseCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                                |              |
| [`Statistics Collect Interval (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_StatisticsCollectInterval) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | *0*                                            | *deprecated* |
| [`TLS Allowed CN (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |                                                |              |
| [`TLS Authenticate (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`TLS CA Certificate Dir (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS CA Certificate File (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Certificate (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Certificate Revocation List (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Cipher List (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Cipher Suites (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS DH File (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Enable (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                            |              |
| [`TLS Key (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                                |              |
| [`TLS Protocol (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                                |              |
| [`TLS Require (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                            |              |
| [`TLS Verify Peer (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                             |              |
| [`Ver Id (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_VerId) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                                |              |
| [`Working Directory (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_WorkingDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) | /var/lib/bareos *(platform specific)*          |              |

- Absolute Job Timeout[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AbsoluteJobTimeout)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Since Version: 14.2.0  Absolute time after which a Job gets terminated regardless of its progress

- Allow Bandwidth Bursting[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AllowBandwidthBursting)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no

- Auto XFlate On Replication[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_AutoXFlateOnReplication)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 13.4.0  This directive controls the [autoxflate-sd plugin](https://docs.bareos.org/TasksAndConcepts/Plugins.html#plugin-autoxflate-sd) plugin when replicating data inside one or between two storage daemons  (Migration/Copy Jobs). Normally the storage daemon will use the  autoinflate/autodeflate setting of the device when reading and writing  data to it which could mean that while reading it inflates the  compressed data and the while writing the other deflates it again. If  you just want the data to be exactly the same e.g. don’t perform any on the fly uncompression and compression while doing the replication of  data you can set this option to no and it will override any setting on  the device for doing auto inflation/deflation when doing data  replication. This will not have any impact on any normal backup or  restore jobs.

- Backend Directory[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_BackendDirectory)

  Type: [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) Default value: /usr/lib/bareos/backends *(platform specific)*

- Checkpoint Interval[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CheckpointInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  This is the interval at which Backup checkpoints are executed. For more information about checkpoints, check the [Checkpoints](https://docs.bareos.org/Appendix/Checkpoints.html#checkpoints-chapter) chapter.

- Client Connect Wait[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_ClientConnectWait)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800  This directive defines an interval of time in seconds that the  Storage daemon will wait for a Client (the File daemon) to connect. Be  aware that the longer the Storage daemon waits for a Client, the more  resources will be tied up.

- Collect Device Statistics[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectDeviceStatistics)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: deprecated

- Collect Job Statistics[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_CollectJobStatistics)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: deprecated

- Description[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Device Reserve By Media Type[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_DeviceReserveByMediaType)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no

- Enable kTLS[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- FD Connect Timeout[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_FdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800

- File Device Concurrent Read[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_FileDeviceConcurrentRead)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no

- Heartbeat Interval[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets used by the defined Bareos Storage Daemon. See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- Log Timestamp Format[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_LogTimestampFormat)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Default value: %d-%b %H:%M Since Version: 15.2.3  This parameter needs to be a valid strftime format string. See **man 3 strftime** for the full list of available substitution variables.

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)

- Maximum Concurrent Jobs[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 20  This directive specifies the maximum number of Jobs that may run  concurrently. Each contact from the Director (e.g. status request, job  start request) is considered as a Job, so if you want to be able to do a **status** request in the console at the same time as a Job is running, you will  need to set this value greater than 1. To run simultaneous Jobs, you  will need to set a number of other directives in the Director’s  configuration file. Which ones you set depend on what you want, but you will almost certainly need to set the [`Maximum Concurrent Jobs (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_MaximumConcurrentJobs). Please refer to the [Concurrent Jobs](https://docs.bareos.org/Appendix/Troubleshooting.html#concurrentjobs) chapter.

- Maximum Network Buffer Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_MaximumNetworkBufferSize)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)

- Messages[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Messages)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)

- Name[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Specifies the Name of the Storage daemon.

- NDMP Address[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 10000  This directive is optional, and if it is specified, it will cause the Storage daemon server (for NDMP Tape Server connections) to bind to the specified IP-Address, which is either a domain name or an IP address.  If it is not specified, the Storage Daemon will bind to both IPv6 and  IPv4 default addresses (the default).

- NDMP Addresses[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddresses)

  Type: [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) Default value: 10000  Specify the ports and addresses on which the Storage daemon will  listen for NDMP Tape Server connections. Normally, the default is  sufficient and you do not need to specify this directive.

- NDMP Enable[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive enables the Native NDMP Tape Agent.

- NDMP Log Level[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpLogLevel)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 4  This directive sets the loglevel for the NDMP protocol library.

- NDMP Port[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpPort)

  Type: [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) Default value: 10000  Specifies port number on which the Storage daemon listens for NDMP Tape Server connections. By default, the Storage daemon server (for NDMP Tape Server  connections) will listen to both IPv6 and IPv4 default addresses on the  port you set. If you want to listen on either IPv4 or IPv6 only, you  have to specify it with either [`NDMP Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddress), or remove [`NDMP Port (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpPort)and just use [`NDMP Addresses (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpAddresses)instead.

- NDMP Snooping[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_NdmpSnooping)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This directive enables the Snooping and pretty printing of NDMP protocol information in debugging mode.

- Plugin Directory[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_PluginDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  This directive specifies a directory in which the Storage Daemon searches for plugins with the name `<pluginname>-sd.so` which it will load at startup.

- Plugin Names[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_PluginNames)

  Type: [`PLUGIN_NAMES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names)  If a [`Plugin Directory (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_PluginDirectory) is specified **Plugin Names** defines, which [Storage Daemon Plugins](https://docs.bareos.org/TasksAndConcepts/Plugins.html#sdplugins) get loaded. If **Plugin Names** is not defined, all plugins get loaded, otherwise the defined ones.

- Scripts Directory[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_ScriptsDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  This directive is currently unused.

- SD Address[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 9103  This directive is optional, and if it is specified, it will cause the Storage daemon server (for Director and File daemon connections) to  bind to the specified IP-Address, which is either a domain name or an IP address. If this and the [`SD Addresses (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddresses) directives are not specified, the Storage Daemon will bind to both IPv6 and IPv4 default addresses (the default).

- SD Addresses[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddresses)

  Type: [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) Default value: 9103  Specify the ports and addresses on which the Storage daemon will  listen for Director connections. Using this directive, you can replace  both the [`SD Port (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdPort) and [`SD Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddress) directives.

- SD Connect Timeout[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800

- SD Port[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdPort)

  Type: [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) Default value: 9103  Specifies port number on which the Storage daemon listens for Director connections. By default, the Storage Daemon will listen to both IPv6 and IPv4  default addresses on the port you set. If you want to listen on either  IPv4 or IPv6 only, you have to specify it with either [`SD Address (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddress), or remove [`SD Port (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdPort)and just use [`SD Addresses (Sd->Storage)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdAddresses)instead.

- SD Source Address[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SdSourceAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 0

- Secure Erase Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_SecureEraseCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 15.2.1  Specify command that will be called when bareos unlinks files. When files are no longer needed, Bareos will delete (unlink) them.  With this directive, it will call the specified command to delete these  files. See [Secure Erase Command](https://docs.bareos.org/TasksAndConcepts/BareosSecurityIssues.html#section-secureerasecommand) for details.

- Statistics Collect Interval[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_StatisticsCollectInterval)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 0 Since Version: deprecated

- TLS Allowed CN[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. Chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) explains how the Bareos components must be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- Ver Id[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_VerId)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Working Directory[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Storage_WorkingDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) Default value: /var/lib/bareos *(platform specific)*  This directive specifies a directory in which the Storage daemon may  put its status files. This directory should be used only by Bareos, but  may be shared by other Bareos daemons provided the names given to each  daemon are unique.

The following is a typical Storage daemon storage resource definition.

Storage daemon storage definition[](https://docs.bareos.org/Configuration/StorageDaemon.html#id1)

```
#
# "Global" Storage daemon configuration specifications appear
# under the Storage resource.
#
Storage {
  Name = "Storage daemon"
  Address = localhost
}
```



## Director Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#director-resource)



The Director resource specifies the Name of the Director which is  permitted to use the services of the Storage daemon. There may be  multiple Director resources. The Director Name and Password must match  the corresponding values in the Director’s configuration file.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Description (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Key Encryption Key (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_KeyEncryptionKey) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               |              |
| [`Maximum Bandwidth Per Job (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |               |              |
| [`Monitor (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Monitor) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |               |              |
| [`Name (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | **required** |
| [`TLS Allowed CN (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Sd->Director)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Description[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Key Encryption Key[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_KeyEncryptionKey)

  Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  This key is used to encrypt the Security Key that is exchanged  between the Director and the Storage Daemon for supporting Application  Managed Encryption (AME). For security reasons each Director should have a different Key Encryption Key.

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)

- Monitor[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Monitor)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean)  If Monitor is set to no (default), this director will have full  access to this Storage daemon. If Monitor is set to yes, this director  will only be able to fetch the current status of this Storage daemon. Please note that if this director is being used by a Monitor, we  highly recommend to set this directive to yes to avoid serious security  problems.

- Name[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Specifies the Name of the Director allowed to connect to the Storage daemon. This directive is required.

- Password[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_Password)

  Required: True Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  Specifies the password that must be supplied by the above named Director. This directive is required.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. Chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) explains how the Bareos components must be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Director_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

The following is an example of a valid Director resource definition:

Storage daemon Director definition[](https://docs.bareos.org/Configuration/StorageDaemon.html#id2)

```
Director {
  Name = MainDirector
  Password = my_secret_password
}
```



## NDMP Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#ndmp-resource)



The NDMP Resource specifies the authentication details of each NDMP  client. There may be multiple NDMP resources for a single Storage  daemon. In general, the properties specified within the NDMP resource  are specific to one client.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Auth Type (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_AuthType) | = [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) | None          |              |
| [`Description (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Log Level (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_LogLevel) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 4             |              |
| [`Name (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Password) | = [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword) |               | **required** |
| [`Username (Sd->Ndmp)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Username) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |

- Auth Type[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_AuthType)

  Type: [`AUTH_TYPE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-auth_type) Default value: None  Specifies the authentication type that must be supplied by the above named NDMP Client. This directive is required. The following values are allowed: None - Use no password Clear - Use clear text password MD5 - Use MD5 hashing

- Description[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Log Level[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_LogLevel)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 4  Specifies the NDMP Loglevel which overrides the global NDMP loglevel for this client.

- Name[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Specifies the name of the NDMP Client allowed to connect to the Storage daemon. This directive is required.

- Password[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Password)

  Required: True Type: [`AUTOPASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-autopassword)  Specifies the password that must be supplied by the above named NDMP Client. This directive is required.

- Username[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Ndmp_Username)

  Required: True Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Specifies the username that must be supplied by the above named NDMP Client. This directive is required.



## Device Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#device-resource)



The Device Resource specifies the details of each device (normally a  tape drive) that can be used by the Storage daemon. There may be  multiple Device resources for a single Storage daemon. In general, the  properties specified within the Device resource are specific to the  Device.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Access Mode (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AccessMode) | = [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) | readwrite     |              |
| [`Alert Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlertCommand) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Always Open (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlwaysOpen) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               | **required** |
| [`Auto Deflate (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflate) | = [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) |               |              |
| [`Auto Deflate Algorithm (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflateAlgorithm) | = [`COMPRESSION_ALGORITHM`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-compression_algorithm) |               |              |
| [`Auto Deflate Level (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflateLevel) | = [`PINT16`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint16) | 6             |              |
| [`Auto Inflate (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoInflate) | = [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) |               |              |
| [`Auto Select (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoSelect) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Autochanger (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Automatic Mount (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutomaticMount) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Backward Space File (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BackwardSpaceFile) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Backward Space Record (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BackwardSpaceRecord) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Block Checksum (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BlockChecksum) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Block Positioning (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BlockPositioning) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Bsf At Eom (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BsfAtEom) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Changer Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerCommand) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Changer Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Check Labels (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CheckLabels) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | *no*          | *deprecated* |
| [`Close On Poll (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CloseOnPoll) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Collect Statistics (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CollectStatistics) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Count (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Count) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Description (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Device Options (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceOptions) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Device Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Diagnostic Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DiagnosticDevice) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Drive Crypto Enabled (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveCryptoEnabled) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |               |              |
| [`Drive Index (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveIndex) | = [`PINT16`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint16) |               |              |
| [`Drive Tape Alert Enabled (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveTapeAlertEnabled) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |               |              |
| [`Eof On Error Is Eot (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_EofOnErrorIsEot) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |               |              |
| [`Fast Forward Space File (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_FastForwardSpaceFile) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Forward Space File (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ForwardSpaceFile) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Forward Space Record (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ForwardSpaceRecord) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Hardware End Of File (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_HardwareEndOfFile) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Hardware End Of Medium (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_HardwareEndOfMedium) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Label Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelBlockSize) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 64512         |              |
| [`Label Media (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelMedia) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Label Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelType) | = [`LABEL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-label) |               | *deprecated* |
| [`Maximum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize) | = [`MAX_BLOCKSIZE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-max_blocksize) | 1048576       |              |
| [`Maximum Changer Wait (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumChangerWait) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 300           |              |
| [`Maximum Concurrent Jobs (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Maximum File Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumFileSize) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) | 1000000000    |              |
| [`Maximum Job Spool Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumJobSpoolSize) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Maximum Network Buffer Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumNetworkBufferSize) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`Maximum Open Volumes (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumOpenVolumes) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 1             |              |
| [`Maximum Open Wait (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumOpenWait) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 300           |              |
| [`Maximum Rewind Wait (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumRewindWait) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 300           |              |
| [`Maximum Spool Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumSpoolSize) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Media Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               | **required** |
| [`Minimum Block Size (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MinimumBlockSize) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |               |              |
| [`Mount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountCommand) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Mount Point (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountPoint) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Name (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`No Rewind On Close (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_NoRewindOnClose) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Offline On Unmount (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_OfflineOnUnmount) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Query Crypto Status (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_QueryCryptoStatus) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) |               |              |
| [`Random Access (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RandomAccess) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Removable Media (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RemovableMedia) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Requires Mount (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RequiresMount) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Spool Directory (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_SpoolDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`Two Eof (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_TwoEof) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | no            |              |
| [`Unmount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UnmountCommand) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               |              |
| [`Use Mtiocget (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UseMtiocget) | = [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) | yes           |              |
| [`Volume Capacity (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_VolumeCapacity) | = [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) |               |              |
| [`Volume Poll Interval (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_VolumePollInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 300           |              |

- Access Mode[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AccessMode)

  Type: [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) Default value: readwrite  Access mode specifies whether this device can be reserved for reading, writing or for both modes (default). The following values are valid: readonly - this device can be reserved only for reading. writeonly - this device can be reserved only for writing. readwrite - this device can be reserved for both reading and writing.

- Alert Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlertCommand)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This specifies an external program to be called at the completion of  each Job after the device is released. The purpose of this command is to check for Tape Alerts, which are present when something is wrong with  your tape drive (at least for most modern tape drives). The same  substitution characters that may be specified in the Changer Command may also be used in this string. For more information, see the [Autochanger & Tape drive Support](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#autochangerschapter) chapter. Note, it is not necessary to have an autochanger to use this command. The example below uses the **tapeinfo** program that comes with the **mtx** package, but it can be used on any tape drive. However, you will need to specify a [`Changer Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice) directive so that the generic SCSI device name can be edited into the command (with the %c). An example of the use of this command to print Tape Alerts in the Job report is: `Alert Command = "sh -c 'tapeinfo -f %c | grep TapeAlert'" `

and an example output when there is a problem could be:

```
bareos-sd  Alert: TapeAlert[32]: Interface: Problem with SCSI interface
                  between tape drive and initiator.
```

- Always Open[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlwaysOpen)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, Bareos will always keep the device open unless specifically  unmounted by the Console program. This permits Bareos to ensure that the tape drive is always available, and properly positioned. If you set  AlwaysOpen to no Bareos will only open the drive when necessary, and at  the end of the Job if no other Jobs are using the drive, it will be  freed. The next time Bareos wants to append to a tape on a drive that  was freed, Bareos will rewind the tape and position it to the end. To  avoid unnecessary tape positioning and to minimize unnecessary operator  intervention, it is highly recommended that Always Open = yes. This also ensures that the drive is available when Bareos needs it. If you have Always Open = yes (recommended) and you want to use the  drive for something else, simply use the unmount command in the Console  program to release the drive. However, don’t forget to remount the drive with mount when the drive is available or the next Bareos job will  block. For File storage, this directive is ignored. For a FIFO storage device, you must set this to No. Please note that if you set this directive to No Bareos will release  the tape drive between each job, and thus the next job will rewind the  tape and position it to the end of the data. This can be a very time  consuming operation. In addition, with this directive set to no, certain multiple drive autochanger operations will fail. We strongly recommend  to keep Always Open set to Yes

- Archive Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice)

  Required: True Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  Specifies where to read and write the backup data. The type of the Archive Device can be specified by the [`Device Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType) directive. If Device Type is not specified, Bareos tries to guess the  Device Type accordingly to the type of the specified Archive Device file type. There are different types that are supported: deviceUsually the device file name of a removable storage device (tape drive), for example `/dev/nst0` or `/dev/rmt/0mbn`, preferably in the “non-rewind” variant. In addition, on systems such as Sun, which have multiple tape access methods, you must be sure to  specify to use Berkeley I/O conventions with the device. The b in the  Solaris (Sun) archive specification `/dev/rmt/0mbn` is what is needed in this case. Bareos does not support SysV tape drive behavior. directoryIf a directory is specified, it is used as file storage. The directory must be existing and be specified as absolute  path. Bareos will write to file storage in the specified directory and  the filename used will be the Volume name as specified in the Catalog.  If you want to write into more than one directory (i.e. to spread the  load to different disk drives), you will need to define two Device  resources, each containing an Archive Device with a different directory.  fifo  A FIFO is a special kind of file that connects two programs via  kernel memory. If a FIFO device is specified for a backup operation, you must have a program that reads what Bareos writes into the FIFO. When  the Storage daemon starts the job, it will wait for [`Maximum Open Wait (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumOpenWait) seconds for the read program to start reading, and then time it out and terminate the job. As a consequence, it is best to start the readprogram at the beginning of the job perhaps with the [`Run Before Job (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_RunBeforeJob) directive. For this kind of device, you always want to specify [`Always Open (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlwaysOpen) = no, because you want the Storage daemon to open it only when a job  starts. Since a FIFO is a one way device, Bareos will not attempt to  read a label of a FIFO device, but will simply write on it. To create a  FIFO Volume in the catalog, use the add command rather than the label command to avoid attempting to write a label. `Device {  Name = FifoStorage  Media Type = Fifo  Device Type = Fifo  Archive Device = /tmp/fifo  LabelMedia = yes  Random Access = no  AutomaticMount = no  RemovableMedia = no  MaximumOpenWait = 60  AlwaysOpen = no } `



- Auto Deflate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflate)

  Type: [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) Since Version: 13.4.0  This is a parameter used by [autoxflate-sd](https://docs.bareos.org/TasksAndConcepts/Plugins.html#plugin-autoxflate-sd) which allow you to transform a non compressed piece of data into a  compressed piece of data on the storage daemon. e.g. Storage Daemon  compression. You can either enable compression on the client and use the CPU cyclces there to compress your data with one of the supported  compression algorithms. The value of this parameter specifies a so  called io-direction currently you can use the following io-directions: in - compress data streams while reading the data from a device. out - compress data streams while writing the data to a device. both - compress data streams both when reading and writing to a device. Currently only plain data streams are compressed (so things that are  already compressed or encrypted will not be considered for compression.) Also meta-data streams are not compressed. The compression is done in a way that the stream is transformed into a native compressed data  stream. So if you enable this and send the data to a filedaemon it will  know its a compressed stream and will do the decompression itself. This  also means that you can turn this option on and off at any time without having any problems with data already written. This option could be used if your clients doesn’t have enough power  to do the compression/decompression itself and you have enough network  bandwidth. Or when your filesystem doesn’t have the option to  transparently compress data you write to it but you want the data to be  compressed when written.

- Auto Deflate Algorithm[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflateAlgorithm)

  Type: [`COMPRESSION_ALGORITHM`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-compression_algorithm) Since Version: 13.4.0  This option specifies the compression algorithm used for the  autodeflate option which is performed by the autoxflate-sd plugin. The  algorithms supported are: GZIP - gzip level 1–9 LZO LZFAST LZ4 LZ4HC

- Auto Deflate Level[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoDeflateLevel)

  Type: [`PINT16`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint16) Default value: 6 Since Version: 13.4.0  This option specifies the level to be used when compressing when you select a compression algorithm that has different levels.

- Auto Inflate[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoInflate)

  Type: [`IO_DIRECTION`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-io_direction) Since Version: 13.4.0  This is a parameter used by [autoxflate-sd](https://docs.bareos.org/TasksAndConcepts/Plugins.html#plugin-autoxflate-sd) which allow you to transform a compressed piece of data into a non  compressed piece of data on the storage daemon. e.g. Storage Daemon  decompression. You can either enable decompression on the client and use the CPU cyclces there to decompress your data with one of the supported compression algorithms. The value of this parameter specifies a so  called io-direction currently you can use the following io-directions: in - decompress data streams while reading the data from a device. out - decompress data streams while writing the data to a device. both - decompress data streams both when reading and writing to a device. This option allows you to write uncompressed data to for instance a  tape drive that has hardware compression even when you compress your  data on the client with for instance a low cpu load compression method  (LZ4 for instance) to transfer less data over the network. It also  allows you to restore data in a compression format that the client might not support but the storage daemon does. This only works on normal  compressed datastreams not on encrypted datastreams or meta data  streams.

- Auto Select[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutoSelect)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If this directive is set to yes, and the Device belongs to an  autochanger, then when the Autochanger is referenced by the Director,  this device can automatically be selected. If this directive is set to  no, then the Device can only be referenced by directly using the Device  name in the Director. This is useful for reserving a drive for something special such as a high priority backup or restore operations. It is possible to temporarily set this directive using the console command [setdevice](https://docs.bareos.org/TasksAndConcepts/BareosConsole.html#bcommandsetdevice).

- Autochanger[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If set to **yes**, this device belongs to an automatic  tape changer, and you must specify an Autochanger resource that points  to this Device resource. If set to **no**, the volume must be manually changed. In the Bareos Director, the directive [`Auto Changer (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_AutoChanger) should be set in correspondence.

- Automatic Mount[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AutomaticMount)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If **yes**, permits the daemon to examine the device to  determine if it contains a Bareos labeled volume. This is done initially when the daemon is started, and then at the beginning of each job. This directive is particularly important if you have set [`Always Open (Sd->Device) = no`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlwaysOpen) because it permits Bareos to attempt to read the device before asking  the system operator to mount a tape. However, please note that the tape  must be mounted before the job begins.

- Backward Space File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BackwardSpaceFile)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, the archive device supports the MTBSF and MTBSF ioctls to  backspace over an end of file mark and to the start of a file. If No,  these calls are not used and the device must be rewound and advanced  forward to the desired position.

- Backward Space Record[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BackwardSpaceRecord)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, the archive device supports the tt MTBSR ioctl to backspace  records. If No, this call is not used and the device must be rewound and advanced forward to the desired position. This function if enabled is  used at the end of a Volume after writing the end of file and any  ANSI/IBM labels to determine whether or not the last block was written  correctly. If you turn this function off, the test will not be done.  This causes no harm as the re-read process is precautionary rather than required.

- Block Checksum[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BlockChecksum)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  You may turn off the Block Checksum (CRC32) code that Bareos uses  when writing blocks to a Volume. Doing so can reduce the Storage daemon  CPU usage slightly. It will also permit Bareos to read a Volume that has corrupted data. It is not recommend to turn this off, particularly on older tape  drives or for disk Volumes where doing so may allow corrupted data to go undetected.

- Block Positioning[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BlockPositioning)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  This directive tells Bareos not to use block positioning when doing  restores. Turning this directive off can cause Bareos to be extremely  slow when restoring files. You might use this directive if you wrote  your tapes with Bareos in variable block mode (the default), but your  drive was in fixed block mode.

- Bsf At Eom[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BsfAtEom)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If **no**, no special action is taken by Bareos with the End of Medium (end of tape) is reached because the tape will be  positioned after the last EOF tape mark, and Bareos can append to the  tape as desired. However, on some systems, such as FreeBSD, when Bareos  reads the End of Medium (end of tape), the tape will be positioned after the second EOF tape mark (two successive EOF marks indicated End of  Medium). If Bareos appends from that point, all the appended data will  be lost. The solution for such systems is to specify [`Bsf At Eom (Sd->Device) = yes`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_BsfAtEom) which causes Bareos to backspace over the second EOF mark.  Determination of whether or not you need this directive is done using  the test command in the **btape** program.

- Changer Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerCommand)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This directive can be specified if this device is used with an autochanger and you want to overwrite the default [`Changer Command (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerCommand). Normally, this directive will be specified only in the [Autochanger Resource](https://docs.bareos.org/Configuration/StorageDaemon.html#storageresourceautochanger), which is then used for all devices. However, you may also specify the different Changer Command in each Device resource.

- Changer Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This directive should be specified if this device is used with an autochanger and you want to overwrite the default [`Changer Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice) or if you have a standard tape drive and want to use the [`Alert Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_AlertCommand). The specified device must be a generic SCSI device. For details, see the [Autochanger & Tape drive Support](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#autochangerschapter) chapter.

- Check Labels[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CheckLabels)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no Since Version: deprecated  If you intend to read ANSI or IBM labels, this **must**  be set. Even if the volume is not ANSI labeled, you can set this to yes, and Bareos will check the label type. Without this directive set to  yes, Bareos will assume that labels are of Bareos type and will not  check for ANSI or IBM labels. In other words, if there is a possibility  of Bareos encountering an ANSI/IBM label, you must set this to yes.

- Close On Poll[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CloseOnPoll)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If Yes, Bareos close the device (equivalent to an unmount except no  mount is required) and reopen it at each poll. Normally this is not too  useful unless you have the Offline on Unmount directive set, in which  case the drive will be taken offline preventing wear on the tape during  any future polling. Once the operator inserts a new tape, Bareos will  recognize the drive on the next poll and automatically continue with the backup. Please see above for more details.

- Collect Statistics[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CollectStatistics)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes

- Count[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Count)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  If Count is set to (1 < Count < 10000), this resource will be  multiplied Count times. The names of multiplied resources will have a  serial number (0001, 0002, …) attached. If set to 1 only this single  resource will be used and its name will not be altered.

- Description[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  The Description directive provides easier human recognition, but is not used by Bareos directly.

- Device Options[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceOptions)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 15.2.0  Some [`Device Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType) require additional configuration. This can be specified in this directive, e.g. for [Droplet Storage Backend](https://docs.bareos.org/TasksAndConcepts/StorageBackends.html#sdbackenddroplet) [GFAPI Storage Backend](https://docs.bareos.org/TasksAndConcepts/StorageBackends.html#sdbackendgfapi) Before the Device Options directive have been introduced, these options have to be configured in the [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice) directive. This behavior have changed with *Version >= 15.2.0*.

- Device Type[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  The Device Type specification allows you to explicitly define the  kind of device you want to use. It may be one of the following: **Tape**is used to access tape device and thus has sequential access. Tape devices are controlled using ioctl() calls. **File**tells Bareos that the device is a  file. It may either be a file defined on fixed medium or a removable  filesystem such as USB. All files must be random access devices. **Fifo**is a first-in-first-out sequential access read-only or write-only device. **GFAPI** (GlusterFS)is used to access a GlusterFS storage. It must be configured using [`Device Options (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceOptions). For details, refer to [GFAPI Storage Backend](https://docs.bareos.org/TasksAndConcepts/StorageBackends.html#sdbackendgfapi). *Version >= 14.2.2* **Droplet**is used to access an object store supported by **libdroplet**, most notably S3. For details, refer to [Droplet Storage Backend](https://docs.bareos.org/TasksAndConcepts/StorageBackends.html#sdbackenddroplet). *Version >= 17.2.7*  The Device Type directive is not required in all cases. If it is not  specified, Bareos will attempt to guess what kind of device has been  specified using the [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice) specification supplied. There are several advantages to explicitly  specifying the Device Type. First, on some systems, block and character  devices have the same type. Secondly, if you explicitly specify the  Device Type, the mount point need not be defined until the device is opened. This is the case with most removable devices such as USB. If the Device Type is not explicitly specified, then the mount point must  exist when the Storage daemon starts.

- Diagnostic Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DiagnosticDevice)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)

- Drive Crypto Enabled[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveCryptoEnabled)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean)  The default for this directive is No. If Yes the storage daemon can  perform so called Application Managed Encryption (AME) using a special  Storage Daemon plugin which loads and clears the Encryption key using  the SCSI SPIN/SPOUT protocol.

- Drive Index[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveIndex)

  Type: [`PINT16`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint16)  The Drive Index that you specify is passed to the [`Changer Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerCommand). By default, the Drive Index is zero, so if you have only one drive in  your autochanger, everything will work normally. However, if you have  multiple drives, you must specify multiple Bareos Device resources (one  for each drive). The first Device should have the Drive Index set to 0,  and the second Device Resource should contain a Drive Index set to 1,  and so on. This will then permit you to use two or more drives in your autochanger. For details, refer to [Multiple Devices](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#section-multipledevices).

- Drive Tape Alert Enabled[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DriveTapeAlertEnabled)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean)

- Eof On Error Is Eot[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_EofOnErrorIsEot)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Since Version: 18.2.4  If Yes, Bareos will treat any read error at an end-of-file mark as  end-of-tape. You should only set this option if your tape-drive fails to detect end-of-tape while reading.

- Fast Forward Space File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_FastForwardSpaceFile)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If No, the archive device is not required to support keeping track of the file number (MTIOCGET ioctl) during forward space file. If Yes, the archive device must support the tt ioctl tt MTFSF call, which virtually all drivers support, but in addition, your SCSI driver must keep track  of the file number on the tape and report it back correctly by the  MTIOCGET ioctl. Note, some SCSI drivers will correctly forward space,  but they do not keep track of the file number or more seriously, they do not report end of medium.

- Forward Space File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ForwardSpaceFile)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, the archive device must support the tt MTFSF ioctl to forward space by file marks. If No, data must be read to advance the position  on the device.

- Forward Space Record[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ForwardSpaceRecord)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, the archive device must support the MTFSR ioctl to forward  space over records. If No, data must be read in order to advance the  position on the device.

- Hardware End Of File[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_HardwareEndOfFile)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes

- Hardware End Of Medium[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_HardwareEndOfMedium)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  All modern (after 1998) tape drives should support this feature. In  doubt, use the btape program to test your drive to see whether or not it supports this function. If the archive device does not support the end  of medium ioctl request tt MTEOM, set this parameter to No. The storage  daemon will then use the forward space file function to find the end of  the recorded data. In addition, your SCSI driver must keep track of the  file number on the tape and report it back correctly by the MTIOCGET ioctl. Note, some SCSI drivers will correctly forward space to the end of the recorded data, but they do not keep track of the file number. On Linux machines, the SCSI driver has a fast-eod option, which if set will cause the driver to lose track of the file number. You  should ensure that this option is always turned off using the mt  program.

- Label Block Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelBlockSize)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 64512  The storage daemon will write the label blocks with the size  configured here. Usually, you will not need to change this directive. For more information on this directive, please see [Tapespeed and blocksizes](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#tapespeed-and-blocksizes).

- Label Media[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelMedia)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If Yes, permits this  device to automatically label blank media without an explicit operator  command. It does so by using an internal algorithm as defined on the [`Label Format (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelFormat) record in each Pool resource. If this is No as by default, Bareos will label tapes only by specific operator command (**label** in the Console) or when the tape has been recycled. The automatic labeling feature is most useful when writing to disk rather than tape volumes.

- Label Type[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_LabelType)

  Type: [`LABEL`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-label) Since Version: deprecated  Defines the label type to use, see section [Tape Labels: ANSI or IBM](https://docs.bareos.org/Appendix/Troubleshooting.html#ansilabelschapter). This directive is implemented in the Director Pool resource ([`Label Type (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_LabelType)) and in the SD Device resource. If it is specified in the the SD Device  resource, it will take precedence over the value passed from the  Director to the SD. If it is set to a non-default value, make sure to  also enable [`Check Labels (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_CheckLabels).

- Maximum Block Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumBlockSize)

  Type: [`MAX_BLOCKSIZE`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-max_blocksize) Default value: 1048576  The Storage daemon will always attempt to write blocks of the  specified size (in bytes) to the archive device. As a consequence, this statement specifies both the default block size  and the maximum block size. The size written never exceeds the given size. If adding data to a block would cause it to exceed the given maximum  size, the block will be written to the archive device, and the new data  will begin a new block. In Bareos *Version >= 23.0.0* the default value is 1 MiB (1.048.576 bytes). Volumes written with  older versions (and the smaller default block size) are still readable  and will be rewritten with the larger block size. Please read chapter [Tapespeed and blocksizes](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#tapespeed-and-blocksizes), to see how to tune this value in a safe manner. Limitation: Setting Maximum Block Size for non-tapes is not supported This setting has only been tested with tape drives. The use with every other storage backend is untested and therefore unsupported and discouraged.  Warning After setting this value the device may write volumes with the new setting. Such volumes can only be read by a device with the same or a larger maximum block size configured. You must make sure that all devices with the same [`Media Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType) have the same value applied.

- Maximum Changer Wait[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumChangerWait)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 300  This directive specifies the maximum amount of time that Bareos will  wait for the changer to respond to a command (e.g. load). If you have a  slow autoloader you may want to set it longer. If the autoloader program fails to respond in this time, Bareos will  invalidate the volume slot number stored in the catalog and try again.  If no additional changer volumes exist, Bareos will ask the operator to  intervene.

- Maximum Concurrent Jobs[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1  This directive specifies the maximum number of Jobs that can run  concurrently on a specified Device. Using this directive, it is possible to have different Jobs using multiple drives, because when the Maximum  Concurrent Jobs limit is reached, the Storage Daemon will start new Jobs on any other available compatible drive. This facilitates writing to  multiple drives with multiple Jobs that all use the same Pool. Warning If [`Device Type (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_DeviceType) is “Droplet” then Maximum Concurrent Jobs is limited to 1.  Warning When using devices that are *not* of type *tape*, it is highly recommended to set Maximum Concurrent Jobs to 1 to avoid intermixing jobs. Intermixed jobs on a Volume will  significantly reduce performance during restore. Instead, define as many devices as required (e.g. multiply disk devices via [`Count (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Count)) and parallelize by storing each job to an individual device at once.

- Maximum File Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumFileSize)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64) Default value: 1000000000  No more than size bytes will be written into a given logical file on  the volume. Once this size is reached, an end of file mark is written on the volume and subsequent data are written into the next file. Breaking long sequences of data blocks with file marks permits quicker  positioning to the start of a given stream of data and can improve  recovery from read errors on the volume. The default is one Gigabyte.  This directive creates EOF marks only on tape media. However, regardless of the medium type (tape, disk, USB …) each time a the Maximum File Size is exceeded, a record is put into the catalog database that permits seeking to that  position on the medium for restore operations. If you set this to a  small value (e.g. 1MB), you will generate lots of database records  (JobMedia) and may significantly increase CPU/disk overhead. If you are configuring an modern drive like LTO-4 or newer, you  probably will want to set the Maximum File Size to 20GB or bigger to  avoid making the drive stop to write an EOF mark. For more info regarding this parameter, read [Tapespeed and blocksizes](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#tapespeed-and-blocksizes). Note, this directive does not limit the size of Volumes that Bareos  will create regardless of whether they are tape or disk volumes. It  changes only the number of EOF marks on a tape and the number of block  positioning records that are generated. If you want to limit the size of all Volumes for a particular device, use the use the [`Maximum Volume Bytes (Dir->Pool)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Pool_MaximumVolumeBytes) directive.

- Maximum Job Spool Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumJobSpoolSize)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)  where the bytes specify the maximum spool size for any one job that is running. The default is no limit.

- Maximum Network Buffer Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumNetworkBufferSize)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  where bytes specifies the initial network buffer size to use with the File daemon. This size will be adjusted down if it is too large until  it is accepted by the OS. Please use care in setting this value since if it is too large, it will be trimmed by 512 bytes until the OS is happy, which may require a large number of system calls. The default value is  32,768 bytes. The default size was chosen to be relatively large but not too big in the case that you are transmitting data over Internet. It is clear that on a high speed local network, you can increase this number and improve performance. For example, some users have found that if you use a value of 65,536 bytes they get five to ten times the throughput. Larger  values for most users don’t seem to improve performance. If you are  interested in improving your backup speeds, this is definitely a place  to experiment. You will probably also want to make the corresponding change in each of your File daemons conf files.

- Maximum Open Volumes[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumOpenVolumes)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 1

- Maximum Open Wait[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumOpenWait)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 300  This directive specifies the maximum amount of time that Bareos will  wait for a device that is busy. If the device cannot be obtained, the  current Job will be terminated in error. Bareos will re-attempt to open  the drive the next time a Job starts that needs the the drive.

- Maximum Rewind Wait[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumRewindWait)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 300  This directive specifies the maximum time in seconds for Bareos to  wait for a rewind before timing out. If this time is exceeded, Bareos  will cancel the job.

- Maximum Spool Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MaximumSpoolSize)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)  where the bytes specify the maximum spool size for all jobs that are running. The default is no limit.

- Media Type[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MediaType)

  Required: True Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  The specified value names the type of media supported by this device, for example, “DLT7000”. Media type names are arbitrary in that you set  them to anything you want, but they must be known to the volume database to keep track of which storage daemons can read which volumes. In  general, each different storage type should have a unique Media Type  associated with it. The same name-string must appear in the appropriate  Storage resource definition in the Director’s configuration file. Even though the names you assign are arbitrary (i.e. you choose the  name you want), you should take care in specifying them because the  Media Type is used to determine which storage device Bareos will select  during restore. Thus you should probably use the same Media Type  specification for all drives where the Media can be freely interchanged. This is not generally an issue if you have a single Storage daemon, but it is with multiple Storage daemons, especially if they have  incompatible media. For example, if you specify a Media Type of “DDS-4” then during the  restore, Bareos will be able to choose any Storage Daemon that handles  “DDS-4”. If you have an autochanger, you might want to name the Media  Type in a way that is unique to the autochanger, unless you wish to  possibly use the Volumes in other drives. You should also ensure to have unique Media Type names if the Media is not compatible between drives.  This specification is required for all devices. In addition, if you are using disk storage, each Device resource will generally have a different mount point or directory. In order for  Bareos to select the correct Device resource, each one must have a  unique Media Type.

- Minimum Block Size[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MinimumBlockSize)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This statement applies only to non-random access devices (e.g. tape  drives). Blocks written by the storage daemon to a non-random archive  device will never be smaller than the given size. The Storage daemon  will attempt to efficiently fill blocks with data received from active  sessions but will, if necessary, add padding to a block to achieve the  required minimum size. To force the block size to be fixed, as is the case for some  non-random access devices (tape drives), set the Minimum block size and  the Maximum block size to the same value. This is usually not required. The default is that the minimum block size is zero and maximum block  size is 1 MiB (1.048.576 bytes). This results in a default block size of 1 MiB (1.048.576 bytes). For example, suppose you want a fixed block size of 100K bytes, then you would specify: `Minimum block size = 100K Maximum block size = 100K `

Please note that if  you specify a fixed block size as shown above, the tape drive must  either be in variable block size mode, or if it is in fixed block size  mode, the block size (generally defined by **mt**) must be identical to the size specified in Bareos – otherwise when you attempt to re-read your Volumes, you will get an error.

If you want the block size to be variable but with a 63K minimum and 200K maximum (and default as well), you would specify:

> ```
> Minimum block size =  63K
> Maximum block size = 200K
> ```

- Mount Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountCommand)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This directive specifies the command that must be executed to mount  devices such as many USB devices. Before the command is executed, %a is  replaced with the Archive Device, and %m with the Mount Point. See the [Edit Codes for Mount and Unmount Directives](https://docs.bareos.org/Configuration/StorageDaemon.html#mountcodes) section below for more details of the editing codes that can be used in this directive. If you need to specify multiple commands, create a shell script.

- Mount Point[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountPoint)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  Directory where the device can be mounted. This directive is used  only for devices that have Requires Mount enabled such as USB file  devices.

- Name[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Unique identifier of the resource. Specifies the Name that the Director will use when asking to backup  or restore to or from to this device. This is the logical Device name,  and may be any string up to 127 characters in length. It is generally a  good idea to make it correspond to the English name of the backup  device. The physical name of the device is specified on the [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice) directive. The name you specify here is also used in your Director’s configuration file on the [Storage Resource](https://docs.bareos.org/Configuration/Director.html#directorresourcestorage) in its Storage resource.

- No Rewind On Close[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_NoRewindOnClose)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If Yes the storage daemon will not try to rewind the device on  closing the device e.g. when shutting down the Storage daemon. This  allows you to do an emergency shutdown of the Daemon without the need to wait for the device to rewind. On restarting and opening the device it  will get a rewind anyhow and this way services don’t have to wait  forever for a tape to spool back.

- Offline On Unmount[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_OfflineOnUnmount)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If Yes the archive device must support the tt MTOFFL ioctl to rewind  and take the volume offline. In this case, Bareos will issue the offline (eject) request before closing the device during the unmount command.  If No Bareos will not attempt to offline the device before unmounting  it. After an offline is issued, the cassette will be ejected thus  requiring operator intervention to continue, and on some systems require an explicit load command to be issued (mt -f /dev/xxx load) before the system will recognize the tape. If you are using an  autochanger, some devices require an offline to be issued prior to  changing the volume. However, most devices do not and may get very  confused. If you are using a Linux 2.6 kernel or other OSes such as FreeBSD or  Solaris, the Offline On Unmount will leave the drive with no tape, and  Bareos will not be able to properly open the drive and may fail the job.

- Query Crypto Status[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_QueryCryptoStatus)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean)  The default for this directive is No. If Yes the storage daemon may  query the tape device for it security status. This only makes sense when Drive Crypto Enabled is also set to yes as the actual query is  performed by the same Storage Daemon plugin and using the same SCSI SPIN protocol.

- Random Access[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RandomAccess)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If Yes, the archive device is assumed to be a random access medium  which supports the lseek (or lseek64 if Largefile is enabled during  configuration) facility. This should be set to Yes for all file systems  such as USB, and fixed files. It should be set to No for non-random  access devices such as tapes and named pipes.

- Removable Media[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RemovableMedia)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If Yes, this device supports removable media (for example tapes). If  No, media cannot be removed (for example, an intermediate backup area on a hard disk). If Removable media is enabled on a File device (as  opposed to a tape) the Storage daemon will assume that device may be  something like a USB device that can be removed or a simply a removable  harddisk. When attempting to open such a device, if the Volume is not  found (for File devices, the Volume name is the same as the Filename),  then the Storage daemon will search the entire device looking for likely Volume  names, and for each one found, it will ask the Director if the Volume  can be used. If so, the Storage daemon will use the first such Volume  found. Thus it acts somewhat like a tape drive – if the correct Volume  is not found, it looks at what actually is found, and if it is an  appendable Volume, it will use it. If the removable medium is not automatically mounted (e.g. udev),  then you might consider using additional Storage daemon device  directives such as Requires Mount, Mount Point, Mount Command, and  Unmount Command, all of which can be used in conjunction with Removable  Media.

- Requires Mount[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RequiresMount)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  When this directive is enabled, the Storage daemon will submit a  Mount Command before attempting to open the device. You must set this  directive to yes for removable file systems such as USB devices that are not automatically mounted by the operating system when plugged in or  opened by Bareos. It should be set to no for all other devices such as  tapes and fixed filesystems. It should also be set to no for any  removable device that is automatically mounted by the operating system  when opened (e.g. USB devices mounted by udev or hotplug). This directive indicates  if the device requires to be mounted using the Mount Command. To be able to write devices need a mount, the following directives must also be  defined: Mount Point, Mount Command, and Unmount Command.

- Spool Directory[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_SpoolDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  specifies the name of the directory to be used to store the spool  files for this device. This directory is also used to store temporary  part files when writing to a device that requires mount (USB). The  default is to use the working directory.

- Two Eof[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_TwoEof)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: no  If Yes, Bareos will write two end of file marks when terminating a  tape – i.e. after the last job or at the end of the medium. If No,  Bareos will only write one end of file to terminate the tape.

- Unmount Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UnmountCommand)

  Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This directive specifies the command that must be executed to unmount devices such as many USB devices. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point. Most frequently, you will define it as follows: `Unmount Command = "/bin/umount %m" `



- Use Mtiocget[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UseMtiocget)

  Type: [`BIT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-bit) Default value: yes  If No, the operating system is not required to support keeping track  of the file number and reporting it in the (MTIOCGET ioctl). If you must set this to No, Bareos will do the proper file position determination,  but it is very unfortunate because it means that tape movement is very  inefficient. Fortunately, this operation system deficiency seems to be  the case only on a few *BSD systems. Operating systems known to work  correctly are Solaris, Linux and FreeBSD.

- Volume Capacity[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_VolumeCapacity)

  Type: [`SIZE64`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-size64)

- Volume Poll Interval[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_VolumePollInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 300  If the time specified on this directive is non-zero, Bareos will  periodically poll (or read) the drive at the specified interval to see  if a new volume has been mounted. If the time interval is zero, no  polling will occur. This directive can be useful if you want to avoid  operator intervention via the console. Instead, the operator can simply  remove the old volume and insert the requested one, and Bareos on the  next poll will recognize the new tape and continue. Please be aware that if you set this interval too small, you may excessively wear your tape drive if the old tape remains in the drive, since Bareos will read it on each poll.



### Edit Codes for Mount and Unmount Directives[](https://docs.bareos.org/Configuration/StorageDaemon.html#edit-codes-for-mount-and-unmount-directives)



Before submitting the Mount Command, or Unmount Command directives to the operating system, Bareos performs character substitution of the  following characters:

```
%% = %
%a = Archive device name
%e = erase (set if cannot mount and first part)
%n = part number
%m = mount point
%v = last part name (i.e. filename)
```

### Devices that require a mount (USB)[](https://docs.bareos.org/Configuration/StorageDaemon.html#devices-that-require-a-mount-usb)



- [`Requires Mount (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_RequiresMount)

  You must set this directive to **yes** for removable devices such as USB unless they are automounted, and to **no** for all other devices (tapes/files).  This directive indicates if the device requires to be mounted to be read, and if it must be written in a special way.  If it set, [`Mount Point (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountPoint), [`Mount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountCommand) and [`Unmount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UnmountCommand)directives must also be defined.

- [`Mount Point (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountPoint)

  Directory where the device can be mounted.

- [`Mount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_MountCommand)

  Command that must be executed to mount the device. Before the command is executed, %a is replaced with the Archive Device, and %m with the Mount Point. Most frequently, you will define it as follows: `Mount Command = "/bin/mount -t iso9660 -o ro %a %m" `

For some media, you may need multiple commands.  If so, it is recommended that you use a shell script instead of putting them all into the Mount Command.  For example, instead of this:

```
Mount Command = "/usr/local/bin/mymount"
```

Where that script contains:

```
#!/bin/sh
ndasadmin enable -s 1 -o w
sleep 2
mount /dev/ndas-00323794-0p1 /backup
```

Similar consideration should be given to all other Command parameters.

[`Unmount Command (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_UnmountCommand)

Command that must be executed to unmount the device. Before the command  is executed, %a is replaced with the Archive Device, and %m with the  Mount Point.

Most frequently, you will define it as follows:

```
Unmount Command = "/bin/umount %m"
```





## Autochanger Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#autochanger-resource)



The Autochanger resource supports single or multiple drive  autochangers by grouping one or more Device resources into one unit  called an autochanger in Bareos (often referred to as a “tape library”  by autochanger manufacturers).

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Changer Command (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerCommand) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               | **required** |
| [`Changer Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice) | = [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname) |               | **required** |
| [`Description (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Device (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Device) | = [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list) |               | **required** |
| [`Name (Sd->Autochanger)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |

- Changer Command[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerCommand)

  Required: True Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  This command specifies an external program and parameter to be called that will automatically change volumes as required by Bareos. This  command is invoked each time that Bareos wishes to manipulate the  autochanger. Most frequently, you will specify the Bareos supplied **mtx-changer** script. The following substitutions are made in the command before it is sent to the operating system for execution: %%% %aarchive device name %cchanger device name %dchanger drive index base 0 %fClient’s name %jJob name %ocommand (loaded, load, or unload) %sSlot base 0 %SSlot base 1 %vVolume name  A typical setting for this is [`Changer Command (Sd->Autochanger) = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerCommand). Details of the three commands currently used by Bareos (loaded, load, unload) as well as the output expected by Bareos are given in the [Bareos Autochanger Interface](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#autochanger-interface) section. If it is specified here, it needs not to be specified in the Device  resource. If it is also specified in the Device resource, it will take  precedence over the one specified in the Autochanger resource.

- Changer Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_ChangerDevice)

  Required: True Type: [`STRNAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-strname)  The specified device must be the generic SCSI device of the autochanger. The changer device is additional to the the [`Archive Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice). This is because most autochangers are controlled through a different  device than is used for reading and writing the tapes. For example, on  Linux, one normally uses the generic SCSI interface for controlling the  autochanger, but the standard SCSI interface for reading and writing the tapes. On Linux, for the [`Archive Device (Sd->Device) = /dev/nst0`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ArchiveDevice), you would typically have [`Changer Device (Sd->Device) = /dev/sg0`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice). On FreeBSD systems, the changer device will typically be on `/dev/pass0` through `/dev/passN`. On Solaris, the changer device will typically be some file under `/dev/rdsk`. Please ensure that your Storage daemon has permission to access this device. It can be overwritten per device using the [`Changer Device (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_ChangerDevice) directive.

- Description[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Device)

  Required: True Type: [`RESOURCE_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-resource_list)  Specifies the names of the Device resource or resources that  correspond to the autochanger drive. If you have a multiple drive  autochanger, you must specify multiple Device names, each one referring  to a separate Device resource that contains a Drive Index specification  that corresponds to the drive number base zero. You may specify multiple device names on a single line separated by commas, and/or you may  specify multiple Device directives.

- Name[](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Autochanger_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Specifies the Name of the Autochanger. This name is used in the Director’s Storage definition to refer to the autochanger.

The following is an example of a valid Autochanger resource definition:

Autochanger Configuration Example[](https://docs.bareos.org/Configuration/StorageDaemon.html#id3)

```
Autochanger {
  Name = "DDS-4-changer"
  Device = DDS-4-1, DDS-4-2, DDS-4-3
  Changer Device = /dev/sg0
  Changer Command = "/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"
}
Device {
  Name = "DDS-4-1"
  Drive Index = 0
  Autochanger = yes
  ...
}
Device {
  Name = "DDS-4-2"
  Drive Index = 1
  Autochanger = yes
  ...
Device {
  Name = "DDS-4-3"
  Drive Index = 2
  Autochanger = yes
  Autoselect = no
  ...
}
```

Please note that it is important to include the [`Autochanger (Sd->Device) = yes`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Autochanger) directive in each device definition that belongs to an Autochanger. A  device definition should not belong to more than one Autochanger  resource.

Also, your [`Device (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Device) must refer to the Autochanger’s resource name rather than a name of one of the Devices.

For details refer to the [Autochanger & Tape drive Support](https://docs.bareos.org/TasksAndConcepts/AutochangerSupport.html#autochangerschapter) chapter.



## Multiplied Device[](https://docs.bareos.org/Configuration/StorageDaemon.html#multiplied-device)

The Multiplied Device feature can be used when multiple identical devices are needed. In this case the [`Count (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Count) can be added to the regarding Device resource.

When the configuration is loaded the Bareos Storage Daemon will then automatically multiply this device [`Count (Sd->Device)`](https://docs.bareos.org/Configuration/StorageDaemon.html#config-Sd_Device_Count) times. The number of multiplied devices includes the original Device.

A number “0001” will be appended to name of the initial Device. All  other multiplied Devices have increasing numbers “0002”, “0003”,  accordingly. In the example below the name of the multiplied devices  will be “MultiFileStorage0001”, “MultiFileStorage0002”, and so on.

bareos-sd.d/device/multiplied_device.conf[](https://docs.bareos.org/Configuration/StorageDaemon.html#id4)

```
Device {
  #Multiply this device Count times
  Count = 3

  Name = MultiFileStorage
  Media Type = File
  Archive Device = /home/testuser/multiplied-device-test/storage
  LabelMedia = yes                   # lets Bareos label unlabeled media
  Random Access = yes
  AutomaticMount = yes               # when device opened, read it
  RemovableMedia = no
  AlwaysOpen = no
  Description = "File device. Will be multiplied 3 times"
}
```

In the Bareos Director any of the Multiplied Devices can be referred to using their numbered names.

However, in the autochanger resource of the Bareos Storage Daemon the original name of the initial Multiplied Device Resource can be used.

bareos-sd.d/autochanger/autochanger.conf[](https://docs.bareos.org/Configuration/StorageDaemon.html#id5)

```
Autochanger {
  Name = "virtual-autochanger"

  # list here only the name of the initial multiplied device resource
  Device = MultiFileStorage

  Changer Device = /dev/null
  Changer Command = ""
}
```

When the configuration is exported, again only the name of the initial Multiplied Device Resource will be printed.



## Messages Resource[](https://docs.bareos.org/Configuration/StorageDaemon.html#messages-resource)

 

For a description of the Messages Resource, please see the [Messages Configuration](https://docs.bareos.org/Configuration/Messages.html#messageschapter) chapter of this manual.