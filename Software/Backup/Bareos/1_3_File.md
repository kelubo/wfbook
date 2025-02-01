# Client/File Daemon Configuration[](https://docs.bareos.org/Configuration/FileDaemon.html#client-file-daemon-configuration)

 

The Client (or File Daemon) Configuration is one of the simpler ones  to specify. Generally, other than changing the Client name so that error messages are easily identified, you will not need to modify the default Client configuration file.

For a general discussion of configuration file and resources including the data types recognized by Bareos, please see the [Configuration](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#configurechapter) chapter of this manual. The following Client Resource definitions must be defined:

- [Client](https://docs.bareos.org/Configuration/FileDaemon.html#clientresourceclient) – to define what Clients are to be backed up.
- [Director](https://docs.bareos.org/Configuration/FileDaemon.html#clientresourcedirector) – to define the Director’s name and its access password.
- [Messages](https://docs.bareos.org/Configuration/Messages.html#messageschapter) – to define where error and information messages are to be sent.



## Client Resource[](https://docs.bareos.org/Configuration/FileDaemon.html#client-resource)

 

The Client Resource (or FileDaemon) resource defines the name of the  Client (as used by the Director) as well as the port on which the Client listens for Director connections.

Start of the Client records. There must be one and only one Client  resource in the configuration file, since it defines the properties of  the current client program.

| configuration directive name                                 | type of data                                                 | default value                         | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------- | ------------ |
| [`Absolute Job Timeout (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AbsoluteJobTimeout) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                       |              |
| [`Allow Bandwidth Bursting (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowBandwidthBursting) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Allowed Job Command (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedJobCommand) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |                                       |              |
| [`Allowed Script Dir (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedScriptDir) | = [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) |                                       |              |
| [`Always Use LMDB (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AlwaysUseLmdb) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Description (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`Enable kTLS (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`FD Address (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddress) | = [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) | 9102                                  |              |
| [`FD Addresses (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddresses) | = [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) | 9102                                  |              |
| [`FD Port (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdPort) | = [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) | 9102                                  |              |
| [`FD Source Address (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdSourceAddress) | = [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) | 0                                     |              |
| [`Heartbeat Interval (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0                                     |              |
| [`LMDB Threshold (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_LmdbThreshold) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                       |              |
| [`Log Timestamp Format (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_LogTimestampFormat) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) | %d-%b %H:%M                           |              |
| [`Maximum Bandwidth Per Job (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |                                       |              |
| [`Maximum Concurrent Jobs (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumConcurrentJobs) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 20                                    |              |
| [`Maximum Network Buffer Size (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumNetworkBufferSize) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) |                                       |              |
| [`Maximum Workers Per Job (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumWorkersPerJob) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 2                                     |              |
| [`Messages (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Messages) | = [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res) |                                       |              |
| [`Name (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |                                       | **required** |
| [`Pki Cipher (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiCipher) | = [`ENCRYPTION_CIPHER`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-encryption_cipher) | aes128                                |              |
| [`Pki Encryption (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiEncryption) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Pki Key Pair (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiKeyPair) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`Pki Master Key (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiMasterKey) | = [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) |                                       |              |
| [`Pki Signatures (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiSignatures) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Pki Signer (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiSigner) | = [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) |                                       |              |
| [`Plugin Directory (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PluginDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`Plugin Names (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PluginNames) | = [`PLUGIN_NAMES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names) |                                       |              |
| [`Scripts Directory (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_ScriptsDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`SD Connect Timeout (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_SdConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 1800                                  |              |
| [`Secure Erase Command (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_SecureEraseCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`TLS Allowed CN (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |                                       |              |
| [`TLS Authenticate (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`TLS CA Certificate Dir (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS CA Certificate File (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Certificate (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Certificate Revocation List (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Cipher List (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Cipher Suites (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS DH File (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Enable (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                   |              |
| [`TLS Key (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |                                       |              |
| [`TLS Protocol (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`TLS Require (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes                                   |              |
| [`TLS Verify Peer (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no                                    |              |
| [`Ver Id (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_VerId) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |                                       |              |
| [`Working Directory (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_WorkingDirectory) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) | /var/lib/bareos *(platform specific)* |              |

- Absolute Job Timeout[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AbsoluteJobTimeout)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Since Version: 14.2.0  Absolute time after which a Job gets terminated regardless of its progress

- Allow Bandwidth Bursting[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowBandwidthBursting)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  This option sets if there is Bandwidth Limiting in effect if the  limiting code can use bursting e.g. when from a certain timeslice not  all bandwidth is used this bandwidth can be used in a next timeslice.  Which mean you will get a smoother limiting which will be much closer to the actual limit set but it also means that sometimes the bandwidth  will be above the setting here.

- Allowed Job Command[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedJobCommand)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  This directive filters what type of jobs the filedaemon should allow. Until now we had the -b (backup only) and -r (restore only) flags which could be specified at the startup of the filedaemon. Allowed Job Command can be defined globally for all directors by  adding it to the global filedaemon resource or for a specific director  when added to the director resource. You specify all commands you want to be executed by the filedaemon.  When you don’t specify the option it will be empty which means all  commands are allowed. The following example shows how to use this functionality: `Director {  Name = <name>  Password = <password>  Allowed Job Command = "backup"  Allowed Job Command = "runscript" } `



- Allowed Script Dir[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedScriptDir)

  Type: [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list)  This directive limits the impact of the runscript command of the filedaemon. It can be specified either for all directors by adding it to the  global filedaemon resource or for a specific director when added to the  director resource. All directories in which the scripts or commands are located that you allow to be run by the runscript command of the filedaemon. Any program not in one of these paths (or subpaths) cannot be used. The  implementation checks if the full path of the script starts with one of  the specified paths. The following example shows how to use this functionality: `# bareos-fd.conf Director {  Name = <name>  Password = <password>  Allowed Script Dir = "/etc/bareos"  Allowed Script Dir = "/path/that/is/also/allowed" }  # bareos-dir.conf Job {   Name = "<name>"   JobDefs = "DefaultJob"   Client Run Before Job = "/etc/bareos/runbeforejob.sh"   # this will run   Client Run Before Job = "/tmp/runbeforejob.sh"          # this will be blocked } `

- Always Use LMDB[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AlwaysUseLmdb)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no

- Description[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- FD Address[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 9102  This record is optional, and if it is specified, it will cause the  File daemon server (for Director connections) to bind to the specified  IP-Address, which is either a domain name or an IP address. If it is not specified, the File Daemon will bind to both IPv6 and IPv4 default  addresses (the default).

- FD Addresses[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddresses)

  Type: [`ADDRESSES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-addresses) Default value: 9102  Specify the ports and addresses on which the File daemon listens for  Director connections. Probably the simplest way to explain is to show an example: `FDAddresses  = {  ip = { addr = 1.2.3.4; port = 1205; }  ipv4 = {    addr = 1.2.3.4; port = http; }  ipv6 = {    addr = 1.2.3.4;    port = 1205;  }  ip = {    addr = 1.2.3.4    port = 1205  }  ip = { addr = 1.2.3.4 }  ip = {    addr = 201:220:222::2  }  ip = {    addr = bluedot.thun.net  } } `



- FD Port[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdPort)

  Type: [`PORT`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-port) Default value: 9102  This specifies the port number on which the Client listens for  Director connections. It must agree with the FDPort specified in the  Client resource of the Director’s configuration file. By default, the Client will listen to both IPv6 and IPv4 default  addresses on the port you set. If you want to listen on either IPv4 or  IPv6 only, you have to specify it with either [`FD Address (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddress), or remove [`FD Port (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdPort)and just use [`FD Addresses (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdAddresses)instead.

- FD Source Address[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_FdSourceAddress)

  Type: [`ADDRESS`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-address) Default value: 0  If specified, the Bareos File Daemon will bind to the specified  address when creating outbound connections. If this record is not  specified, the kernel will choose the best address according to the  routing table (the default).

- Heartbeat Interval[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets used by the defined Bareos File Daemon. See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- LMDB Threshold[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_LmdbThreshold)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)

- Log Timestamp Format[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_LogTimestampFormat)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Default value: %d-%b %H:%M Since Version: 15.2.3

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)  The speed parameter specifies the maximum allowed bandwidth that a job may use.

- Maximum Concurrent Jobs[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumConcurrentJobs)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 20  This directive specifies the maximum number of Jobs that should run  concurrently. Each contact from the Director (e.g. status request, job  start request) is considered as a Job, so if you want to be able to do a **status** request in the console at the same time as a Job is running, you will need to set this value greater than 1.

- Maximum Network Buffer Size[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumNetworkBufferSize)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32)  This directive specifies the initial network buffer size to use. This size will be adjusted down if it is too large until it is accepted by  the OS. Please use care in setting this value since if it is too large,  it will be trimmed by 512 bytes until the OS is happy, which may require a large number of system calls. The default value is 65,536 bytes. Note, on certain Windows machines, there are reports that the  transfer rates are very slow and this seems to be related to the default 65,536 size. On systems where the transfer rates seem abnormally slow  compared to other systems, you might try setting the Maximum Network  Buffer Size to 32,768 in both the File daemon and in the Storage daemon.

- Maximum Workers Per Job[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_MaximumWorkersPerJob)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 2

- Messages[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Messages)

  Type: [`RES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-res)

- Name[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of this resource. It is used to reference to it. The client name that must be used by the Director when connecting.  Generally, it is a good idea to use a name related to the machine so  that error messages can be easily identified if you have multiple  Clients. This directive is required.

- Pki Cipher[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiCipher)

  Type: [`ENCRYPTION_CIPHER`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-encryption_cipher) Default value: aes128  PKI Cipher used for data encryption. See the [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption) chapter of this manual. Depending on the openssl library version different ciphers are  available. To choose the desired cipher, you can use the PKI Cipher  option in the filedaemon configuration. `FileDaemon {   Name = client1-fd    # encryption configuration   PKI Signatures = Yes                           # Enable Data Signing   PKI Encryption = Yes                           # Enable Data Encryption   PKI Keypair    = "/etc/bareos/example-fd.pem"  # Public and Private Keys in one file   PKI Master Key = "/etc/bareos/master.pub.key" # ONLY the Public Key   PKI Cipher     = aes128                        # specify desired PKI Cipher here } `



- Pki Encryption[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiEncryption)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Enable Data Encryption. See [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption).

- Pki Key Pair[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiKeyPair)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  File with public and private key to sign, encrypt (backup) and decrypt (restore) the data. See [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption).

- Pki Master Key[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiMasterKey)

  Type: [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list)  List of public key files. Data will be decryptable via the corresponding private keys. See [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption).

- Pki Signatures[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiSignatures)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Enable Data Signing. See [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption).

- Pki Signer[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PkiSigner)

  Type: [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list)  Additional public/private key files to sign or verify the data. See [Data Encryption](https://docs.bareos.org/TasksAndConcepts/DataEncryption.html#dataencryption).

- Plugin Directory[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PluginDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  This directive specifies a directory in which the File Daemon searches for plugins with the name `<pluginname>-fd.so` which it will load at startup. Typically on Linux systems, plugins are installed to `/usr/lib/bareos/plugins/` or `/usr/lib64/bareos/plugins/`.

- Plugin Names[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PluginNames)

  Type: [`PLUGIN_NAMES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-plugin_names)  If a [`Plugin Directory (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_PluginDirectory) is specified **Plugin Names** defines, which [File Daemon Plugins](https://docs.bareos.org/TasksAndConcepts/Plugins.html#fdplugins) get loaded. If **Plugin Names** is not defined, all plugins get loaded, otherwise the defined ones. Warning It is highly recommended to always specify the **Plugin Names** directive to keep control about what plugins will be loaded by the filedaemon. Some plugins cannot be loaded at the same time, like the python2 and python3 plugins.

- Scripts Directory[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_ScriptsDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)

- SD Connect Timeout[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_SdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 1800  This record defines an interval of time that the File daemon will try to connect to the Storage daemon. If no connection is made in the  specified time interval, the File daemon cancels the Job.

- Secure Erase Command[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_SecureEraseCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 15.2.1  Specify command that will be called when bareos unlinks files. When files are no longer needed, Bareos will delete (unlink) them.  With this directive, it will call the specified command to delete these  files. See [Secure Erase Command](https://docs.bareos.org/TasksAndConcepts/BareosSecurityIssues.html#section-secureerasecommand) for details.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see how the Bareos Director (and the other components) have to be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

- Ver Id[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_VerId)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Working Directory[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_WorkingDirectory)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) Default value: /var/lib/bareos *(platform specific)*  This directive is optional and specifies a directory in which the File daemon may put its status files. On Win32 systems, in some circumstances you may need to specify a  drive letter in the specified working directory path. Also, please be  sure that this directory is writable by the SYSTEM user otherwise  restores may fail (the bootstrap file that is transferred to the File  daemon from the Director is temporarily put in this directory before  being passed to the Storage daemon).

The following is an example of a valid Client resource definition:

```
Client {                              # this is me
  Name = rufus-fd
}
```



## Director Resource[](https://docs.bareos.org/Configuration/FileDaemon.html#director-resource)

 

The Director resource defines the name and password of the Directors that are permitted to contact this Client.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Allowed Job Command (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_AllowedJobCommand) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`Allowed Script Dir (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_AllowedScriptDir) | = [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list) |               |              |
| [`Connection From Client To Director (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_ConnectionFromClientToDirector) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Connection From Director To Client (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_ConnectionFromDirectorToClient) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`Description (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Maximum Bandwidth Per Job (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_MaximumBandwidthPerJob) | = [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed) |               |              |
| [`Monitor (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Monitor) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Name (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
| [`Port (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Port) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9101          |              |
| [`TLS Allowed CN (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Fd->Director)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Address[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Address)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Director Network Address. Only required if “Connection From Client To Director” is enabled.

- Allowed Job Command[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_AllowedJobCommand)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  see [`Allowed Job Command (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedJobCommand)

- Allowed Script Dir[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_AllowedScriptDir)

  Type: [`DIRECTORY_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory_list)  see [`Allowed Script Dir (Fd->Client)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Client_AllowedScriptDir)

- Connection From Client To Director[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_ConnectionFromClientToDirector)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no Since Version: 16.2.2  Let the Filedaemon initiate network connections to the Director. For details, see [Client Initiated Connection](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-clientinitiatedconnection).

- Connection From Director To Client[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_ConnectionFromDirectorToClient)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes Since Version: 16.2.2  This Client will accept incoming network connection from this Director.

- Description[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Maximum Bandwidth Per Job[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_MaximumBandwidthPerJob)

  Type: [`SPEED`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-speed)  The speed parameter specifies the maximum allowed bandwidth that a  job may use when started from this Director. The speed parameter should  be specified in k/s, Kb/s, m/s or Mb/s.

- Monitor[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Monitor)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If Monitor is set to no, this director will have full access to this  Client. If Monitor is set to yes, this director will only be able to  fetch the current status of this Client. Please note that if this director is being used by a Monitor, we  highly recommend to set this directive to yes to avoid serious security  problems.

- Name[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of the Director that may contact this Client. This name must be the same as the name specified on the Director resource in the  Director’s configuration file. Note, the case (upper/lower) of the  characters in the name are significant (i.e. S is not the same as s).  This directive is required.

- Password[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  Specifies the password that must be supplied for a Director to be  authorized. This password must be the same as the password specified in  the Client resource in the Director’s configuration file. This directive is required.

- Port[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_Port)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9101 Since Version: 16.2.2  Director Network Port. Only used if “Connection From Client To Director” is enabled.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see how the Bareos Director (and the other components) have to be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Director_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

Thus multiple Directors may be authorized to use this Client’s  services. Each Director will have a different name, and normally a  different password as well.

The following is an example of a valid Director resource definition:

```
#
# List Directors who are permitted to contact the File daemon
#
Director {
  Name = HeadMan
  Password = very_good                # password HeadMan must supply
}
Director {
  Name = Worker
  Password = not_as_good
  Monitor = Yes
}
```



## Messages Resource[](https://docs.bareos.org/Configuration/FileDaemon.html#messages-resource)

There must be at least one Message resource in the Client configuration file.

Please see the [Messages Resource](https://docs.bareos.org/Configuration/Messages.html#messageschapter) Chapter of this manual for the details of the Messages Resource.

| configuration directive name                                 | type of data                                                 | default value | remark |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------ |
| [`Append (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Append) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Catalog (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Catalog) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Console (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Console) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Description (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Director (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Director) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`File (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_File) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Mail) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail Command (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Mail On Error (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailOnError) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Mail On Success (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailOnSuccess) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Name (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               |        |
| [`Operator (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Operator) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Operator Command (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_OperatorCommand) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |
| [`Stderr (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Stderr) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Stdout (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Stdout) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Syslog (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Syslog) | = [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages) |               |        |
| [`Timestamp Format (Fd->Messages)`](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_TimestampFormat) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |        |

- Append[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Append)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Catalog[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Catalog)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Console[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Console)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Description[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Director[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Director)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- File[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_File)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Mail[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Mail)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Mail Command[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Mail On Error[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailOnError)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Mail On Success[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_MailOnSuccess)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Name[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Name)

  Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)

- Operator[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Operator)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Operator Command[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_OperatorCommand)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Stderr[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Stderr)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Stdout[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Stdout)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Syslog[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_Syslog)

  Type: [`MESSAGES`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-messages)

- Timestamp Format[](https://docs.bareos.org/Configuration/FileDaemon.html#config-Fd_Messages_TimestampFormat)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

## Example Client Configuration File[](https://docs.bareos.org/Configuration/FileDaemon.html#example-client-configuration-file)

An example File Daemon configuration file might be the following:

```
#
# Bareos File Daemon Configuration file
#

#
# List Directors who are permitted to contact this File daemon
#
Director {
  Name = bareos-dir
  Password = "aEODFz89JgUbWpuG6hP4OTuAoMvfM1PaJwO+ShXGqXsP"
}

#
# Restricted Director, used by tray-monitor to get the
#   status of the file daemon
#
Director {
  Name = client1-mon
  Password = "8BoVwTju2TQlafdHFExRIJmUcHUMoIyIqPJjbvcSO61P"
  Monitor = yes
}

#
# "Global" File daemon configuration specifications
#
FileDaemon {                          # this is me
  Name = client1-fd
  Maximum Concurrent Jobs = 20

  # remove comment in next line to load plugins from specified directory
  # Plugin Directory = /usr/lib64/bareos/plugins
}

# Send all messages except skipped files back to Director
Messages {
  Name = Standard
  director = client1-dir = all, !skipped, !restored
}
```

​        