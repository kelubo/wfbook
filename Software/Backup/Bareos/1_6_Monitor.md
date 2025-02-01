# Monitor Configuration[](https://docs.bareos.org/Configuration/Monitor.html#monitor-configuration)

The Monitor configuration file is a stripped down  version of the Director configuration file, mixed with a Console  configuration file. It simply contains the information necessary to  contact Directors, Clients, and Storage daemons you want to monitor.

For a general discussion of configuration file and resources including the data types recognized by Bareos, please see the [Configuration](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#configurechapter) chapter of this manual.

The following Monitor Resource definition must be defined:

- [Monitor](https://docs.bareos.org/Configuration/Monitor.html#monitorresource) – to define the Monitor’s name used to connect to all the daemons and  the password used to connect to the Directors. Note, you must not define more than one Monitor resource in the Monitor configuration file.
- At least one [Client](https://docs.bareos.org/Configuration/Monitor.html#clientresource1), [Storage](https://docs.bareos.org/Configuration/Monitor.html#storageresource1) or [Director](https://docs.bareos.org/Configuration/Monitor.html#directorresource2) resource, to define the daemons to monitor.



## Monitor Resource[](https://docs.bareos.org/Configuration/Monitor.html#monitor-resource)

The Monitor resource defines the attributes of the  Monitor running on the network. The parameters you define here must be  configured as a Director resource in Clients and Storages configuration  files, and as a Console resource in Directors configuration files.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Description (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Dir Connect Timeout (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_DirConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 10            |              |
| [`Enable kTLS (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`FD Connect Timeout (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_FdConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 10            |              |
| [`Name (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
| [`Refresh Interval (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_RefreshInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 60            |              |
| [`SD Connect Timeout (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_SdConnectTimeout) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 10            |              |
| [`TLS Allowed CN (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Console->Monitor)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Description[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Dir Connect Timeout[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_DirConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 10

- Enable kTLS[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- FD Connect Timeout[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_FdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 10

- Name[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  Specifies the Director name used to connect to Client and Storage,  and the Console name used to connect to Director. This record is  required.

- Password[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  Where the password is needed for Directors to accept the Console  connection. This password must be identical to the Password specified in the Console resource of the [Director’s configuration](https://docs.bareos.org/Configuration/Director.html#directorchapter) file. This record is required if you wish to monitor Directors.

- Refresh Interval[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_RefreshInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 60  Specifies the time to wait between status requests to each daemon. It can’t be set to less than 1 second or more than 10 minutes.

- SD Connect Timeout[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_SdConnectTimeout)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 10

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support.

- TLS Key[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Monitor_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.



## Director Resource[](https://docs.bareos.org/Configuration/Monitor.html#director-resource)

 

The Director resource defines the attributes of the Directors that are monitored by this Monitor.

As you are not permitted to define a Password in this resource, to  avoid obtaining full Director privileges, you must create a Console  resource in the [Director’s configuration](https://docs.bareos.org/Configuration/Director.html#directorchapter) file, using the Console Name and Password defined in the Monitor  resource. To avoid security problems, you should configure this Console  resource to allow access to no other daemons, and permit the use of only two commands: status and .status (see below for an example).

You may have multiple Director resource specifications in a single Monitor configuration file.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`Description (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Dir Port (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_DirPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9101          |              |
| [`Enable kTLS (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Name (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`TLS Allowed CN (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Address[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Address)

  Required: True Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Where the address is a host name, a fully qualified domain name, or a network address used to connect to the Director. This record is  required.

- Description[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Dir Port[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_DirPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9101  Specifies the port to use to connect to the Director. This port must  be identical to the DIRport specified in the Director resource of the [Director Configuration](https://docs.bareos.org/Configuration/Director.html#directorchapter) file.

- Enable kTLS[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Name[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The Director name used to identify the Director in the list of  monitored daemons. It is not required to be the same as the one defined  in the Director’s configuration file. This record is required.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see how the Bareos Director (and the other components) have to be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.



## Client Resource[](https://docs.bareos.org/Configuration/Monitor.html#client-resource)

 

The Client resource defines the attributes of the Clients that are monitored by this Monitor.

You must create a Director resource in the [Client’s configuration](https://docs.bareos.org/Configuration/FileDaemon.html#filedconfchapter) file, using the Director Name defined in the Monitor resource. To avoid security problems, you should set the Monitor directive to Yes in this  Director resource.

You may have multiple Director resource specifications in a single Monitor configuration file.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`Description (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`FD Port (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_FdPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9102          |              |
| [`Name (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
| [`TLS Allowed CN (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Console->Client)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Address[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Address)

  Required: True Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Where the address is a host name, a fully qualified domain name, or a network address in dotted quad notation for a Bareos File daemon. This  record is required.

- Description[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- FD Port[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_FdPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9102  Where the port is a port number at which the Bareos File daemon can be contacted.

- Name[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The Client name used to identify the Director in the list of  monitored daemons. It is not required to be the same as the one defined  in the Client’s configuration file. This record is required.

- Password[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  This is the password to be used when establishing a connection with  the File services, so the Client configuration file on the machine to be backed up must have the same password defined for this Director. This  record is required.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support.

- TLS Key[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Client_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.



## Storage Resource[](https://docs.bareos.org/Configuration/Monitor.html#storage-resource)

 

The Storage resource defines the attributes of the Storages that are monitored by this Monitor.

You must create a Director resource in the [Storage’s configuration](https://docs.bareos.org/Configuration/StorageDaemon.html#storedconfchapter) file, using the Director Name defined in the Monitor resource. To avoid security problems, you should set the Monitor directive to Yes in this  Director resource.

You may have multiple Director resource specifications in a single Monitor configuration file.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               | **required** |
| [`Description (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Name (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
| [`SD Address (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdAddress) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`SD Password (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdPassword) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               |              |
| [`SD Port (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9103          |              |
| [`TLS Allowed CN (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Console->Storage)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Address[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Address)

  Required: True Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Where the address is a host name, a fully qualified domain name, or a network address in dotted quad notation for a Bareos Storage daemon.  This record is required.

- Description[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Enable kTLS[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Name[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The Storage name used to identify the Director in the list of  monitored daemons. It is not required to be the same as the one defined  in the Storage’s configuration file. This record is required.

- Password[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  This is the password to be used when establishing a connection with  the Storage services. This same password also must appear in the  Director resource of the Storage daemon’s configuration file. This  record is required.

- SD Address[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdAddress)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- SD Password[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdPassword)

  Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)

- SD Port[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_SdPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9103  Where port is the port to use to contact the storage daemon for  information and to start jobs. This same port number must appear in the  Storage resource of the Storage daemon’s configuration file.

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support.

- TLS Key[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Storage_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

## Traymonitor[](https://docs.bareos.org/Configuration/Monitor.html#traymonitor)

### Traymonitor Security[](https://docs.bareos.org/Configuration/Monitor.html#traymonitor-security)

There is no security problem in relaxing the  permissions on Bareos Traymonitor configuration files as long as Bareos  File Daemon, Bareos Storage Daemon and Bareos Director are configured  properly, so the passwords contained in this file only gives access to  the status of the daemons. It could be a security problem if you  consider the status information as potentially dangerous (most people  consider this as not being dangerous).

Concerning Director’s configuration: In the Bareos Traymonitor configuration files the password in the  Monitor resource must point to a restricted console in Bareos Director  configuration. So, if you use this password with :command:` bconsole`,  you’ll only have access to the status of the director (commands status  and .status). It could be a security problem if there is a bug in the  ACL code of the director.

Concerning File and Storage Daemons’ configuration: In the Bareos Traymonitor configuration files the Name in the Monitor  resource must point to a Director resource in the Bareos File Daemon  respectively Bareos Storage Daemon configuration, with the Monitor  directive set to Yes.

### Example Traymonitor configuration[](https://docs.bareos.org/Configuration/Monitor.html#example-traymonitor-configuration)

An example Traymonitor configuration file might be the following:

```
#
# Bareos Tray Monitor Configuration File
#
Monitor {
  Name = rufus-mon        # password for Directors
  Password = "GN0uRo7PTUmlMbqrJ2Gr1p0fk0HQJTxwnFyE4WSST3MWZseR"
  RefreshInterval = 10 seconds
}

Client {
  Name = rufus-fd
  Address = rufus
  FDPort = 9102           # password for FileDaemon
  Password = "FYpq4yyI1y562EMS35bA0J0QC0M2L3t5cZObxT3XQxgxppTn"
}
Storage {
  Name = rufus-sd
  Address = rufus
  SDPort = 9103           # password for StorageDaemon
  Password = "9usxgc307dMbe7jbD16v0PXlhD64UVasIDD0DH2WAujcDsc6"
}
Director {
  Name = rufus-dir
  DIRport = 9101
  address = rufus
}
```

#### Example File daemon’s Director record[](https://docs.bareos.org/Configuration/Monitor.html#example-file-daemons-director-record)

Example Monitor resource[](https://docs.bareos.org/Configuration/Monitor.html#id1)

```
#
# Restricted Director, used by tray-monitor to get the
#   status of the file daemon
#
Director {
  Name = rufus-mon
  Password = "FYpq4yyI1y562EMS35bA0J0QC0M2L3t5cZObxT3XQxgxppTn"
  Monitor = yes
}
```

#### Example Storage daemon’s Director record[](https://docs.bareos.org/Configuration/Monitor.html#example-storage-daemons-director-record)

Example Monitor resource[](https://docs.bareos.org/Configuration/Monitor.html#id2)

```
#
# Restricted Director, used by tray-monitor to get the
#   status of the storage daemon
#
Director {
  Name = rufus-mon
  Password = "9usxgc307dMbe7jbD16v0PXlhD64UVasIDD0DH2WAujcDsc6"
  Monitor = yes
}
```

#### Example Director’s Console record[](https://docs.bareos.org/Configuration/Monitor.html#example-directors-console-record)

Example Monitor resource[](https://docs.bareos.org/Configuration/Monitor.html#id3)

```
#
# Restricted console used by tray-monitor to get the status of the director
#
Console {
  Name = Monitor
  Password = "GN0uRo7PTUmlMbqrJ2Gr1p0fk0HQJTxwnFyE4WSST3MWZseR"
  CommandACL = status, .status
}
```