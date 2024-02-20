# Console Configuration[](https://docs.bareos.org/Configuration/Console.html#console-configuration)



The Console configuration file is the simplest of all the  configuration files, and in general, you should not need to change it  except for the password. It simply contains the information necessary to contact the Director or Directors.

For a general discussion of the syntax of configuration files and  their resources including the data types recognized by Bareos, please  see the [Configuration](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#configurechapter) chapter of this manual.

The following Console Resource definition must be defined:



## Director Resource[](https://docs.bareos.org/Configuration/Console.html#director-resource)



The Director resource defines the attributes of the Director running  on the network. You may have multiple Director resource specifications  in a single Console configuration file. If you have more than one, you  will be prompted to choose one when you start the Console program.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Address (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Address) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Description (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Dir Port (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_DirPort) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 9101          |              |
| [`Enable kTLS (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Heartbeat Interval (Console->Director)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`Name (Console->Director)`](https://docs.bareos.org/Configuration/Monitor.html#config-Console_Director_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Console->Director)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
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

- Address[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_Address)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  Where the address is a host name, a fully qualified domain name, or a network address used to connect to the Director. This record is  required.

- Description[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Dir Port[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_DirPort)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 9101  Specifies the port to use to connect to the Director. This port must  be identical to the DIRport specified in the Director resource of the [Director Configuration](https://docs.bareos.org/Configuration/Director.html#directorchapter) file.

- Enable kTLS[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Heartbeat Interval[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets with the defined director. If set, this value overrides [`Heartbeat Interval (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HeartbeatInterval). See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- Name[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The Director name used to identify the Director in the list of  monitored daemons. It is not required to be the same as the one defined  in the Director’s configuration file. This record is required.

- Password[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  This password is used to authenticate when connecting to the Bareos Director as default console. It must correspond to [`Password (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Password).

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see how the Bareos Director (and the other components) have to be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Console.html#config-Console_Director_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

An actual example might be:

```
Director {
  Name = HeadMan
  address = rufus.cats.com
  password = xyz1erploit
}
```



## Console Resource[](https://docs.bareos.org/Configuration/Console.html#console-resource)

 

There are three different kinds of consoles, which the administrator  or user can use to interact with the Director. These three kinds of  consoles comprise three different security levels.

- The first console type is an **admin** or **anonymous** or **default** console, which has full privileges. There is no console resource  necessary for this type since the password is specified in the Director  resource. Typically you would use this console only for administrators.

- The second type of console is a “named” or “restricted” console  defined within a Console resource in both the Director’s configuration  file and in the Console’s configuration file. Both the names and the  passwords in these two entries must match much as is the case for Client programs.

  This second type of console begins with absolutely no privileges  except those explicitly specified in the Director’s Console resource.  Note, the definition of what these restricted consoles can do is  determined by the Director’s conf file.

  Thus you may define within the Director’s conf file multiple Consoles with different names and passwords, sort of like multiple users, each  with different privileges. As a default, these consoles can do  absolutely nothing – no commands what so ever. You give them privileges  or rather access to commands and resources by specifying access control  lists in the Director’s Console resource. This gives the administrator  fine grained control over what particular consoles (or users) can do.

- The third type of console is similar to the above mentioned  restricted console in that it requires a Console resource definition in  both the Director and the Console. In addition, if the console name,  provided on the Name = directive, is the same as a Client name, the user of that console is permitted to use the SetIP command to change the  Address directive in the Director’s client resource to the IP address of the Console. This permits portables or other machines using DHCP  (non-fixed IP addresses) to “notify” the Director of their current IP address.

The Console resource is optional and need not be specified. However,  if it is specified, you can use ACLs (Access Control Lists) in the  Director’s configuration file to restrict the particular console (or  user) to see only information pertaining to his jobs or client machine.

You may specify as many Console resources in the console’s conf file. If you do so, generally the first Console resource will be used.  However, if you have multiple Director resources (i.e. you want to  connect to different directors), you can bind one of your Console  resources to a particular Director resource, and thus when you choose a  particular Director, the appropriate Console configuration resource will be used. See the “Director” directive in the Console resource described below for more information.

Note, the Console resource is optional, but can be useful for restricted consoles as noted above.

| configuration directive name                                 | type of data                                                 | default value | remark       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- | ------------ |
| [`Description (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Description) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Director (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Director) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`Enable kTLS (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_EnableKtls) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`Heartbeat Interval (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HeartbeatInterval) | = [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) | 0             |              |
| [`History File (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HistoryFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`History Length (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HistoryLength) | = [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) | 100           |              |
| [`Name (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Name) | = [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name) |               | **required** |
| [`Password (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Password) | = [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password) |               | **required** |
| [`Rc File (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_RcFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Allowed CN (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsAllowedCn) | = [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list) |               |              |
| [`TLS Authenticate (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsAuthenticate) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |
| [`TLS CA Certificate Dir (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCaCertificateDir) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS CA Certificate File (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCaCertificateFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCertificate) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Certificate Revocation List (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCertificateRevocationList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher List (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCipherList) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Cipher Suites (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCipherSuites) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS DH File (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsDhFile) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Enable (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsEnable) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Key (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsKey) | = [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory) |               |              |
| [`TLS Protocol (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsProtocol) | = [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) |               |              |
| [`TLS Require (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsRequire) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | yes           |              |
| [`TLS Verify Peer (Console->Console)`](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsVerifyPeer) | = [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) | no            |              |

- Description[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Description)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)

- Director[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Director)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string)  If this directive is specified, this Console resource will be used by bconsole when that particular director is selected when first starting  bconsole. I.e. it binds a particular console resource with its name and  password to a particular director.

- Enable kTLS[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_EnableKtls)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If set to “yes”, Bareos will allow the SSL implementation to use Kernel TLS.

- Heartbeat Interval[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HeartbeatInterval)

  Type: [`TIME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-time) Default value: 0  Optional and if specified set a keepalive interval (heartbeat) on the sockets with console. See details in [Heartbeat Interval - TCP Keepalive](https://docs.bareos.org/TasksAndConcepts/NetworkSetup.html#section-tcp-keepalive).

- History File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HistoryFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  If this directive is specified and the console is compiled with  readline support, it will use the given filename as history file. If not specified, the history file will be named `~/.bconsole_history`

- History Length[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_HistoryLength)

  Type: [`PINT32`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-pint32) Default value: 100  If this directive is specified the history file will be truncated after **HistoryLength** entries.

- Name[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Name)

  Required: True Type: [`NAME`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-name)  The name of this resource. The Console name used to allow a restricted console to change its IP  address using the SetIP command. The SetIP command must also be defined  in the Director’s conf CommandACL list.

- Password[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_Password)

  Required: True Type: [`MD5PASSWORD`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-md5password)  If this password is supplied, then the password specified in the  Director resource of you Console conf will be ignored. See below for  more details.

- Rc File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_RcFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)

- TLS Allowed CN[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsAllowedCn)

  Type: [`STRING_LIST`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string_list)  “Common Name”s (CNs) of the allowed peer certificates.

- TLS Authenticate[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsAuthenticate)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  Use TLS only to authenticate, not for encryption.

- TLS CA Certificate Dir[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCaCertificateDir)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a TLS CA certificate directory.

- TLS CA Certificate File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCaCertificateFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS CA certificate(s) file.

- TLS Certificate[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCertificate)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded TLS certificate.

- TLS Certificate Revocation List[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCertificateRevocationList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a Certificate Revocation List file.

- TLS Cipher List[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCipherList)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  List of valid TLSv1.2 and lower Ciphers; see **openssl ciphers**

- TLS Cipher Suites[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsCipherSuites)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Colon separated list of valid TLSv1.3 Ciphers; see **openssl ciphers -s -tls1_3**. Leftmost element has the highest priority. Currently only SHA256 ciphers are supported.

- TLS DH File[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsDhFile)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path to PEM encoded Diffie-Hellman parameter file. If this directive  is specified, DH key exchange will be used for the ephemeral keying,  allowing for forward secrecy of communications.

- TLS Enable[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsEnable)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  Enable TLS support. Bareos can be configured to encrypt all its network traffic. See chapter [TLS Configuration Directives](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#tlsdirectives) to see how the Bareos Director (and the other components) have to be configured to use TLS.

- TLS Key[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsKey)

  Type: [`DIRECTORY`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-directory)  Path of a PEM encoded private key. It must correspond to the specified “TLS Certificate”.

- TLS Protocol[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsProtocol)

  Type: [`STRING`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-string) Since Version: 20.0.0  OpenSSL Configuration: Protocol

- TLS Require[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsRequire)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: yes  If set to “no”, Bareos can fall back to use unencrypted connections.

- TLS Verify Peer[](https://docs.bareos.org/Configuration/Console.html#config-Console_Console_TlsVerifyPeer)

  Type: [`BOOLEAN`](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#datatype-boolean) Default value: no  If disabled, all certificates signed by a known CA will be accepted.  If enabled, the CN of a certificate must the Address or in the “TLS  Allowed CN” list.

## Example Console Configuration File[](https://docs.bareos.org/Configuration/Console.html#example-console-configuration-file)



A Console configuration file might look like this:

bconsole configuration[](https://docs.bareos.org/Configuration/Console.html#id1)

```
Director {
  Name = "bareos.example.com-dir"
  address = "bareos.example.com"
  Password = "PASSWORD"
}
```

With this configuration, the console program (e.g. **bconsole**) will try to connect to a Bareos Director named **bareos.example.com-dir** at the network address **bareos.example.com** and authenticate to the admin console using the password **PASSWORD**.



### Using Named Consoles[](https://docs.bareos.org/Configuration/Console.html#using-named-consoles)

The following configuration files were supplied by Phil Stracchino.

To use named consoles from **bconsole**, use a `bconsole.conf` configuration file like this:

bconsole: restricted-user[](https://docs.bareos.org/Configuration/Console.html#id2)

```
Director {
   Name = bareos-dir
   Address = myserver
   Password = "XXXXXXXXXXX"
}

Console {
   Name = restricted-user
   Password = "RUPASSWORD"
}
```

Where the Password in the Director section is deliberately incorrect and the Console resource is given a name, in this case **restricted-user**. Then in the Director configuration (not directly accessible by the user), we define:

bareos-dir.d/console/restricted-user.conf[](https://docs.bareos.org/Configuration/Console.html#id3)

```
Console {
  Name = restricted-user
  Password = "RUPASSWORD"
  JobACL = "Restricted Client Save"
  ClientACL = restricted-client
  StorageACL = main-storage
  ScheduleACL = *all*
  PoolACL = *all*
  FileSetACL = "Restricted Client's FileSet"
  CatalogACL = MyCatalog
  CommandACL = run
}
```

The user login into the Director from his Console will get logged in as [`restricted-user (Dir->Console)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Console_Name) and he will only be able to see or access a Job with the name [`Restricted Client Save (Dir->Job)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Job_Name), a Client with the name [`restricted-client (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Name), a storage device [`main-storage (Dir->Storage)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Storage_Name), any Schedule or Pool, a FileSet named [`Restricted Client's FileSet (Dir->Fileset)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Fileset_Name), a Catalog named [`MyCatalog (Dir->Catalog)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Catalog_Name) and the only command he can use in the Console is the **run** command. In other words, this user is rather limited in what he can see and do with Bareos. For details how to configure ACLs, see the **Acl** data type description.

The following is an example of a `bconsole.conf` file that can access several Directors and has different Consoles depending on the Director:

bconsole: multiple consoles[](https://docs.bareos.org/Configuration/Console.html#id4)

```
Director {
   Name = bareos-dir
   Address = myserver
   Password = "XXXXXXXXXXX"    # no, really.  this is not obfuscation.
}

Director {
   Name = SecondDirector
   Address = secondserver
   Password = "XXXXXXXXXXX"    # no, really.  this is not obfuscation.
}

Console {
   Name = restricted-user
   Password = "RUPASSWORD"
   Director = bareos-dir
}

Console {
   Name = restricted-user2
   Password = "OTHERPASSWORD"
   Director = SecondDirector
}
```

The second Director referenced at [`secondserver (Dir->Director)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Director_Name) might look like the following:

bareos-dir.d/console/restricted-user2.conf[](https://docs.bareos.org/Configuration/Console.html#id5)

```
Console {
  Name = restricted-user2
  Password = "OTHERPASSWORD"
  JobACL = "Restricted Client Save"
  ClientACL = restricted-client
  StorageACL = second-storage
  ScheduleACL = *all*
  PoolACL = *all*
  FileSetACL = "Restricted Client's FileSet"
  CatalogACL = RestrictedCatalog
  CommandACL = run, restore
  WhereACL = "/"
}
```

​        