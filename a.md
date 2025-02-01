Networks consist of two or more devices, such as computer systems, printers, and related equipment, which are connected by either physical cabling or  wireless links for the purpose of sharing and distributing information  among the connected devices.
网络由两个或多个设备组成，如计算机系统、打印机和相关设备，它们通过物理电缆或无线链路连接，以便在连接的设备之间共享和分发信息。 

In this overview, we’ll take a look at some of the key principles involved in networks, and at some of the most popular tools available to help  you manage your networks.
在本概述中，我们将了解网络中涉及的一些关键原则，以及一些可帮助您管理网络的最流行工具。 

## Networking key concepts 联网关键概念 

If you’re new to networking, our explanatory [“Networking key concepts”](https://ubuntu.com/server/docs/networking-key-concepts) section provides an overview of some important concepts. It includes  detailed discussion of the popular network protocols: TCP/IP; IP  routing; TCP and UDP; and ICMP.
如果您是网络新手，我们的解释性“网络关键概念”部分提供了一些重要概念的概述。它包括对流行的网络协议的详细讨论：TCP/IP; IP路由; TCP和UDP;以及TCP/IP。

## Configuring networks 配置网络 

Ubuntu ships with a number of graphical utilities to configure your network devices. Our explanatory guide on [“configuring networks”](https://ubuntu.com/server/docs/configuring-networks) is geared toward server administrators focuses on managing your network on the command line.
Ubuntu附带了许多图形实用程序来配置您的网络设备。我们关于“配置网络”的解释性指南是面向服务器管理员的，侧重于在命令行上管理网络。

## Network tools and services 网络工具和服务 

### DHCP

The Dynamic Host Configuration Protocol (DHCP) enables host computers to be automatically assigned settings from a server. To learn more about DHCP and how configuration works, we have [an explanatory guide](https://ubuntu.com/server/docs/about-dynamic-host-configuration-protocol-dhcp).
动态主机配置协议（DHCP）使主机计算机能够从服务器自动分配设置。要了解更多关于DHCP和配置工作原理的信息，我们有一个解释性指南。

There are two DHCP servers available on Ubuntu. We have instructions on how to [install and configure `isc-dhcp-server`](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-dhcp-server), and how to [install its replacement, `isc-kea`](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-kea) (available from 23.04 onwards).
Ubuntu上有两个DHCP服务器。我们有关于如何安装和配置 `isc-dhcp-server` 以及如何安装其替代品 `isc-kea` 的说明（从2004年23月4日起提供）。

### Time synchronisation 时间同步 

Synchronising time over a network is handled by the Network Time Protocol (NTP). It  is a networking protocol that syncronises time between all computers on a network to within a few milliseconds of Coordinated Universal Time  (UTC). This explanation guide will tell you [more about time synchronisation](https://ubuntu.com/server/docs/about-time-synchronisation).
网络时间同步由网络时间协议（NTP）处理。它是一种网络协议，可以将网络上所有计算机之间的时间同步到协调世界时（UTC）的几毫秒之内。本解释指南将告诉您更多关于时间同步的信息。

In Ubuntu, time synchronisation is primarily handled by `timedatectl` and `timesyncd`, which are installed by default as part of `systemd`. To find out how to configure this service, [read our how-to guide](https://ubuntu.com/server/docs/about-time-synchronisation).
在Ubuntu中，时间同步主要由 `timedatectl` 和 `timesyncd` 处理，它们默认作为 `systemd` 的一部分安装。要了解如何配置此服务，请阅读我们的操作指南。

If you want to set up a server to *provide* NTP information, then we have a guide on [how to serve NTP using `chrony`](https://ubuntu.com/server/docs/how-to-serve-the-network-time-protocol-with-chrony).
如果你想设置一个服务器来提供NTP信息，那么我们有一个关于如何使用 `chrony` 服务NTP的指南。

### The DPDK library DPDK库 

The [Data Plane Development Kit (DPDK)](https://www.dpdk.org/) provides a set of libraries that accelerate packet processing workloads. If you would like to find out more [about DPDK and its use in Ubuntu](https://ubuntu.com/server/docs/about-dpdk), refer to our explanation page.
数据平面开发工具包（DPDK）提供了一组加速数据包处理工作负载的库。如果您想了解更多关于DPDK及其在Ubuntu中的使用，请参阅我们的解释页面。

One popular piece of software that makes use of DPDK is Open vSwitch (OVS), which can be run inside a VM and provides access to all virtual  machines in the server hypervisor layer. Check out our guide to find out [how to use DPDK with Open vSwitch](https://ubuntu.com/server/docs/how-to-use-dpdk-with-open-vswitch).
一个使用DPDK的流行软件是Open vSwitch（OVS），它可以在VM中运行，并提供对服务器管理程序层中所有虚拟机的访问。查看我们的指南，了解如何将DPDK与Open vSwitch配合使用。

## Other networking functionality 其他网络功能 

- **Samba 桑巴舞**
   If you need to network together both Ubuntu and Microsoft machines, you  will want to make use of Samba. To get started, check out our [introduction to Samba](https://ubuntu.com/server/docs/introduction-to-samba).
   如果您需要将Ubuntu和Microsoft机器联网，您将需要使用桑巴舞。要开始使用，请查看我们对桑巴舞的介绍。

------

# Introduction to Samba 桑巴舞简介 

Computer networks are often comprised of diverse systems. While operating a  network made up entirely of Ubuntu desktop and server computers would  definitely be fun, some network environments require both Ubuntu and  Microsoft Windows systems working together in harmony.
计算机网络通常由不同的系统组成。虽然操作完全由Ubuntu桌面和服务器计算机组成的网络肯定会很有趣，但某些网络环境需要Ubuntu和Microsoft Windows系统协调工作。 

This is where [Samba](https://www.samba.org) comes in! Samba provides various tools for configuring your Ubuntu  Server to share network resources with Windows clients. In this  overview, we’ll look at some of the key principles, how to install and  configure the tools available, and some common Samba use cases.
这就是桑巴舞的用武之地！桑巴舞提供了各种工具来配置您的Ubuntu服务器，以便与Windows客户端共享网络资源。在本概述中，我们将了解一些关键原则、如何安装和配置可用的工具，以及一些常见的桑巴舞用例。

## Samba functionality 桑巴舞功能 

There are several services common to Windows environments that your Ubuntu  system needs to integrate with in order to set up a successful network.  These services share data and configuration details of the computers and users on the network between them, and can each be classified under one of three main categories of functionality.
为了建立一个成功的网络，Ubuntu系统需要与Windows环境中常见的几个服务集成。这些服务在它们之间共享计算机和网络上用户的数据和配置详细信息，并且每个服务都可以分为三个主要功能类别之一。 

### File and printer sharing services 文件和打印机共享服务 

These services use the Server Message Block (SMB) protocol to facilitate the  sharing of files, folders, volumes, and the sharing of printers  throughout the network.
这些服务使用服务器消息块（SMB）协议来促进文件、文件夹、卷的共享以及整个网络中打印机的共享。 

- **File server 文件服务器**
   Samba can be [configured as a file server](https://ubuntu.com/server/docs/samba-as-a-file-server) to share files with Windows clients - our guide will walk you through that process.
   桑巴舞可以配置为文件服务器，与Windows客户端共享文件-我们的指南将引导您完成该过程。
- **Print server 打印服务器**
   Samba can also be [configured as a print server](https://ubuntu.com/server/docs/samba-as-a-print-server) to share printer access with Windows clients, as detailed in this guide.
   桑巴舞还可以配置为打印服务器，以便与Windows客户端共享打印机访问，如本指南中所述。

### Directory services 目录服务 

These services share vital information about the computers and users of the  network. They use technologies like the Lightweight Directory Access  Protocol (LDAP) and Microsoft Active Directory.
这些服务共享有关计算机和网络用户的重要信息。它们使用轻量级目录访问协议（LDAP）和Microsoft Active Directory等技术。 

- **Microsoft Active Directory**
   An Active Directory domain is a collection of users, groups, or hardware components within a Microsoft Active Directory network. This guide will show you how to set up your server as a [member of an Active Directory domain](https://ubuntu.com/server/docs/member-server-in-an-active-directory-domain).
   Active Directory域是Microsoft Active Directory网络中用户、组或硬件组件的集合。本指南将向您展示如何将服务器设置为Active Directory域的成员。
- NT4 Domain Controller *(deprecated)*
  NT4域控制器（已弃用）
   This guide will show you how to configure your Samba server to appear [as a Windows NT4-style domain controller](https://ubuntu.com/server/docs/nt4-domain-controller-legacy).
   本指南将向您展示如何配置桑巴舞服务器，使其显示为Windows NT 4风格的域控制器。
- OpenLDAP backend *(deprecated)*
  OpenLDAP后端（已弃用）
   This guide will show you how to integrate Samba with [LDAP in Windows NT4 mode](https://ubuntu.com/server/docs/openldap-backend-legacy).
   本指南将向您展示如何在Windows NT 4模式下将桑巴舞与LDAP集成。

### Authentication and access 认证和访问 

These services establish the identity of a computer or network user, and  determine the level of access that should be granted to the computer or  user. The services use such principles and technologies as file  permissions, group policies, and the Kerberos authentication service.
这些服务建立计算机或网络用户的身份，并确定应授予计算机或用户的访问级别。这些服务使用文件权限、组策略和身份验证服务等原则和技术。 

- **Share access controls 共享访问控制**
   This article provides more details on controlling access to shared directories.
   本文提供了有关控制对共享目录的访问的更多详细信息。
- **AppArmor profile for Samba
  桑巴舞的AppArmor配置文件**
   This guide will briefly cover how to [set up a profile for Samba](https://ubuntu.com/server/docs/samba-apparmor-profile) using the Ubuntu security module, AppArmor.
   本指南将简要介绍如何使用Ubuntu安全模块AppArmor为桑巴舞设置配置文件。
- **Mounting CIFS shares permanently
  永久装载CIFS共享**
   This guide will show you [how to set up Common Internet File System (CIFS) shares](https://ubuntu.com/server/docs/how-to-mount-cifs-shares-permanently) to automatically provide access to network files and resources.
   本指南将介绍如何设置通用Internet文件系统（CIFS）共享，以自动提供对网络文件和资源的访问。

------

# Introduction to Kerberos 企业简介 

Kerberos is a network authentication system based on the principal of a trusted  third party. The other two parties being the user and the service the  user wishes to authenticate to. Not all services and applications can  use Kerberos, but for those that can, it brings the network environment  one step closer to being Single Sign On (SSO).
身份认证是一种基于可信第三方主体的网络认证系统。其他两方是用户和用户希望进行身份验证的服务。并非所有服务和应用程序都可以使用SSL，但对于那些可以使用SSL的服务和应用程序，它使网络环境更接近单点登录（SSO）。 

This section covers installation and configuration of a Kerberos server, and some example client configurations.
本节将介绍一个SNMP服务器的安装和配置，以及一些客户端配置示例。 

## Overview 概述 

If you are new to Kerberos there are a few terms that are good to  understand before setting up a Kerberos server. Most of the terms will  relate to things you may be familiar with in other environments:
如果你是新手，在设置一个MySQL服务器之前，有几个术语是很好的理解。大多数术语将与您在其他环境中可能熟悉的内容相关： 

- *Principal:* any users, computers, and services provided by servers need to be defined as Kerberos Principals.
  主体：服务器提供的任何用户、计算机和服务都需要被定义为服务器主体。
- *Instances:* are a variation for service principals. For example, the principal for  an NFS service will have an instance for the hostname of the server,  like `nfs/server.example.com@REALM`. Similarly admin privileges on a principal use an instance of `/admin`, like `john/admin@REALM`, differentiating it from `john@REALM`. These variations fit nicely with ACLs.
  是服务主体的一种变体。例如，NFS服务的主体将具有服务器主机名的实例，如 `nfs/server.example.com@REALM` 。类似地，主体上的管理员权限使用 `/admin` 的实例，如 `john/admin@REALM` ，将其与 `john@REALM` 区分开来。这些变化很好地适应了。
- *Realms:* the unique realm of control provided by the Kerberos installation.  Think of it as the domain or group your hosts and users belong to.  Convention dictates the realm should be in uppercase. By default, Ubuntu will use the DNS domain converted to uppercase (`EXAMPLE.COM`) as the realm.
  Realms：由Windows安装提供的唯一控制领域。将其视为您的主机和用户所属的域或组。根据惯例，王国应该在罗马。默认情况下，Ubuntu将使用转换为DNS（ `EXAMPLE.COM` ）的DNS域作为域。
- *Key Distribution Center:* (KDC) consist of three parts: a database of all principals, the  authentication server, and the ticket granting server. For each realm  there must be at least one KDC.
  密钥分发中心（KDC）由三部分组成：所有主体的数据库、认证服务器和票证授予服务器。对于每个领域，必须至少有一个KDC。
- *Ticket Granting Ticket:* issued by the Authentication Server (AS), the Ticket Granting Ticket  (TGT) is encrypted in the user’s password which is known only to the  user and the KDC. This is the starting point for a user to acquire  additional tickets for the services being accessed.
  门票授予门票：在由认证服务器（AS）发出的证书中，证书授予证书（TGT）被加密在用户的密码中，该密码仅为用户和KDC所知。这是用户获取正在访问的服务的附加票证的起点。
- *Ticket Granting Server:* (TGS) issues service tickets to clients upon request.
  票证授予服务器（TGS）根据请求向客户端发出服务票证。
- *Tickets:* confirm the identity of the two principals. One principal being a user  and the other a service requested by the user. Tickets establish an  encryption key used for secure communication during the authenticated  session.
  门票：确认两位负责人的身份。一个主体是用户，另一个主体是用户请求的服务。票证建立一个加密密钥，用于在经过身份验证的会话期间进行安全通信。
- *Keytab Files:* contain encryption keys for a service or host extracted from the KDC principal database.
  Keytab文件：包含从KDC主体数据库提取的服务或主机的加密密钥。

To put the pieces together, a Realm has at least one KDC, preferably more  for redundancy, which contains a database of Principals. When a user  principal logs into a workstation that is configured for Kerberos  authentication, the KDC issues a Ticket Granting Ticket (TGT). If the  user supplied credentials match, the user is authenticated and can then  request tickets for Kerberized services from the Ticket Granting Server  (TGS). The service tickets allow the user to authenticate to the service without entering another username and password.
为了将这些部分组合在一起，一个领域至少有一个KDC，最好有更多的冗余，它包含一个主体数据库。当用户主体登录到配置为进行身份验证的工作站时，KDC会发出一个票证授予票证（TGT）。如果用户提供的凭据匹配，则用户通过身份验证，然后可以从票证授予服务器（TGS）请求Kerberized服务的票证。服务票证允许用户在不输入其他用户名和密码的情况下对服务进行身份验证。 

## Resources 资源 

- For more information on MIT’s version of Kerberos, see the [MIT Kerberos](http://web.mit.edu/Kerberos/) site.
  有关MIT版本的JavaScript的更多信息，请参见MIT JavaScript站点。
- Also, feel free to stop by the *#ubuntu-server* and *#kerberos* IRC channels on [Libera.Chat](https://libera.chat/) if you have Kerberos questions.
  另外，请随时访问Libera上的#ubuntu-server和#kernetyIRC频道。如果您有任何问题，请与我们聊天。
- [Another guide for installing Kerberos on Debian, includes PKINIT
   另一个在Debian上安装MySQL的指南，包括PKINIT](http://techpubs.spinlocksolutions.com/dklar/kerberos.html)

------

# ntroduction to network user authentication with SSSD 使用SSSD进行网络用户身份验证简介 

The [System Security Services Daemon (SSSD)](https://sssd.io/) is actually a collection of daemons that handle authentication,  authorisation, and user and group information from a variety of network  sources. It’s a useful tool for administrators of Linux and UNIX-based  systems, particularly in enterprise systems which may need to integrate  with other directory, access control and authentication services.
系统安全服务守护程序（SSSD）实际上是一个守护程序的集合，用于处理来自各种网络源的身份验证、授权以及用户和组信息。对于Linux和基于UNIX的系统的管理员来说，它是一个有用的工具，特别是在可能需要与其他目录、访问控制和身份验证服务集成的企业系统中。

## Common deployment scenarios 常见部署场景 

At its core, SSSD has support for a variety of authorisation and identity  services, such as Active Directory, LDAP, and Kerberos. See the  following guides to discover how to set up SSSD with…
在其核心，SSSD支持各种授权和身份服务，如Active Directory、LDAP和LDAP。请参阅以下指南以了解如何使用. 

- [Active Directory](https://ubuntu.com/server/docs/how-to-set-up-sssd-with-active-directory)
- [LDAP](https://ubuntu.com/server/docs/how-to-set-up-sssd-with-ldap)
- [LDAP and Kerberos LDAP和Kerberos](https://ubuntu.com/server/docs/how-to-set-up-sssd-with-ldap-and-kerberos)

## Integration with PAM and NSS 与PAM和NSS集成 

SSSD provides Pluggable Authentication Modules (PAM) and Name Service Switch (NSS) modules to integrate these remote sources into your system. This  allows remote users to login and be recognised as valid users, including group membership. To allow for disconnected operation, SSSD also can  also cache this information, so that users can continue to login in the  event of a network failure, or other problems of the same sort.
SSSD提供了可插入身份验证模块（PAM）和名称服务交换机（NSS）模块，以将这些远程源集成到您的系统中。这允许远程用户登录并被识别为有效用户，包括组成员身份。为了允许断开连接的操作，SSSD还可以缓存此信息，以便用户在网络故障或其他同类问题时可以继续登录。 

## Troubleshooting 故障排除 

If you have problems with your SSSD setup, you can use some of the tips contained in our [SSSD troubleshooting guide](https://ubuntu.com/server/docs/troubleshooting-sssd) to discover the cause.
如果您的SSSD设置有问题，您可以使用我们的SSSD故障排除指南中包含的一些提示来查找原因。

# OpenLDAP简介 

The Lightweight Directory Access Protocol, or LDAP, is a protocol for  querying and modifying an X.500-based directory service running over  TCP/IP. The current LDAP version is LDAPv3, as defined in [RFC 4510](http://tools.ietf.org/html/rfc4510), and the implementation used in Ubuntu is OpenLDAP.
轻量级目录访问协议（LDAP）是一种用于查询和修改在TCP/IP上运行的基于X.500的目录服务的协议。当前的LDAP版本是RFC 4510中定义的LDAPv 3，Ubuntu中使用的实现是OpenLDAP。

The LDAP protocol *accesses* directories. It’s common to refer to a directory as an *LDAP directory* or *LDAP database* as a shorthand – although technically incorrect, this shorthand is so widely used
LDAP协议访问目录。通常将目录称为LDAP目录或LDAP数据库，这是一种简写--尽管从技术上讲是不正确的，但这种简写使用得非常广泛
 that it’s understood as such.
 它是这样理解的。

## Key concepts and terms 关键概念和术语 

- A **directory** is a tree of data **entries** that is hierarchical in nature; it is called the Directory Information Tree (DIT).
  目录是一个数据条目树，本质上是分层的;它被称为目录信息树（DIT）。
- An **entry** consists of a set of **attributes**.
  一个条目由一组属性组成。
- An **attribute** has a **key** (a name or description) and one or more **values**. Every attribute must be defined in at least one **objectClass**.
  属性有一个键（名称或描述）和一个或多个值。每个属性必须至少在一个objectClass中定义。
- Attributes and objectClasses are defined in **schemas** (an objectClass is considered a special kind of attribute).
  属性和objectClass在模式中定义（objectClass被认为是一种特殊的属性）。
- Each entry has a unique identifier: its **Distinguished Name** (DN or dn). This, in turn, consists of a **Relative Distinguished Name** (RDN) followed by the parent entry’s DN.
  每个条目都有一个唯一的标识符：它的可分辨名称（DN或dn）。这又由一个相对可分辨名称（RDN）和父条目的DN组成。
- The entry’s DN is not an attribute. It is not considered part of the entry itself.
  条目的DN不是属性。它不被视为条目本身的一部分。 

> **Note**: 注意事项：
>  The terms **object**, **container**, and **node** have certain connotations but they all essentially mean the same thing as **entry** (the technically correct term).
>  术语对象、容器和节点有一定的含义，但它们本质上都与条目（技术上正确的术语）的含义相同。

For example, below we have a single entry consisting of 11 attributes where the following is true:
例如，下面我们有一个由11个属性组成的条目，其中以下为真： 

- DN is `cn=John Doe,dc=example,dc=com` DN为 `cn=John Doe,dc=example,dc=com` 
- RDN is `cn=John Doe` RDN是 `cn=John Doe` 
- parent DN is `dc=example,dc=com` 父DN为 `dc=example,dc=com` 

```plaintext
 dn: cn=John Doe,dc=example,dc=com
 cn: John Doe
 givenName: John
 sn: Doe
 telephoneNumber: +1 888 555 6789
 telephoneNumber: +1 888 555 1232
 mail: john@example.com
 manager: cn=Larry Smith,dc=example,dc=com
 objectClass: inetOrgPerson
 objectClass: organizationalPerson
 objectClass: person
 objectClass: top
```

The above entry is in **LDAP Data Interchange Format** format (LDIF). Any information that you feed into your DIT must also be in such a format. It is defined in [RFC 2849](https://datatracker.ietf.org/doc/html/rfc2849).
上面的条目是LDAP数据交换格式（LDIF）。输入到DIT中的任何信息也必须采用这种格式。它在RFC 2849中定义。

A directory accessed via LDAP is good for anything that involves a large  number of access requests to a mostly-read, attribute-based (name:value) backend, and that can benefit from a hierarchical structure. Examples  include an address book, company directory, a list of email addresses,  and a mail server’s configuration.
通过LDAP访问的目录适用于任何涉及大量对大多数读取的、基于属性（名称：值）的后端的访问请求的情况，并且可以从分层结构中受益。示例包括地址簿、公司目录、电子邮件地址列表和邮件服务器的配置。 

## Our OpenLDAP guide 我们的OpenLDAP指南 

For users who want to set up OpenLDAP, we recommend following our series of guides in this order:
对于想要设置OpenLDAP的用户，我们建议按照以下顺序遵循我们的系列指南： 

- [Install and configure LDAP
   安装和配置LDAP](https://ubuntu.com/server/docs/install-and-configure-ldap)
- [LDAP Access Control LDAP访问控制](https://ubuntu.com/server/docs/ldap-access-control)
- [LDAP users and groups
   LDAP用户和组](https://ubuntu.com/server/docs/how-to-set-up-ldap-users-and-groups)
- [SSL/TLS](https://ubuntu.com/server/docs/ldap-and-transport-layer-security-tls)
- [Replication 复制](https://ubuntu.com/server/docs/openldap-replication)
- [Backup and restore 备份和还原](https://ubuntu.com/server/docs/backup-and-restore-openldap)

## References 引用 

- The [OpenLDAP administrators guide](https://openldap.org/doc/admin25/)
  OpenLDAP管理员指南
- [RFC 4515: LDAP string representation of search filters
   RFC 4515：搜索过滤器的LDAP字符串表示](http://www.rfc-editor.org/rfc/rfc4515.txt)
- Zytrax’s [LDAP for Rocket Scientists](http://www.zytrax.com/books/ldap/); a less pedantic but comprehensive treatment of LDAP
  Zytrax的LDAP for Rocket Scientists;不那么迂腐但全面的LDAP处理
   Older references that might still be useful:
   可能仍然有用的旧参考资料：
- O’Reilly’s [LDAP System Administration](http://www.oreilly.com/catalog/ldapsa/) (textbook; 2003)
  O 'Reilly的LDAP系统管理（教科书; 2003）
- Packt’s [Mastering OpenLDAP](http://www.packtpub.com/OpenLDAP-Developers-Server-Open-Source-Linux/book) (textbook; 2007)
  Packt的Mastering OpenLDAP（教科书; 2007）

------

# 数据库简介 

Ubuntu provides two popular database servers. They are:
Ubuntu提供了两个流行的数据库服务器。它们是： 

- [MySQL](https://www.mysql.com/)
- [PostgreSQL](https://www.postgresql.org/)

Both are popular choices among developers, with similar feature sets and  performance capabilities. Historically, Postgres tended to be a  preferred choice for its attention to standards conformance, features,  and extensibility, whereas MySQL may be more preferred for higher  performance requirements. However, over time each has made good strides  catching up with the other. Specialised needs may make one a better  option for a certain application, but in general both are good, strong  options.
两者都是开发人员的热门选择，具有相似的功能集和性能。从历史上看，Postgres往往是关注标准一致性，功能和可扩展性的首选，而MySQL可能更适合更高的性能要求。然而，随着时间的推移，每一个都取得了很好的进展，赶上了另一个。专业化的需求可能会使一个更好的选择，为某一应用程序，但一般来说，这两个都是好的，强大的选择。 

They are available in the Main repository and equally supported by Ubuntu.  This section explains how to install and configure these database  servers.
它们在主存储库中可用，并且同样受到Ubuntu的支持。本节说明如何安装和配置这些数据库服务器。 

------

# ntroduction to security 安全介绍 

Security should always be considered when installing, deploying, and using any  type of computer system. Although a fresh installation of Ubuntu is  relatively safe for immediate use on the Internet, it is important to  have a balanced understanding of your system’s security posture based on how it will be used after deployment.
在安装、部署和使用任何类型的计算机系统时，都应始终考虑安全性。虽然Ubuntu的新安装对于在互联网上立即使用是相对安全的，但重要的是要根据部署后将如何使用系统来平衡了解系统的安全状态。 

This chapter provides an overview of security-related topics as they pertain to Ubuntu Server Edition, and outlines simple measures you may use to  protect your server and network from any number of potential security  threats.
本章概述了与Ubuntu Server Edition相关的安全相关主题，并概述了您可以用来保护您的服务器和网络免受任何潜在安全威胁的简单措施。 

## About security at Ubuntu 关于Ubuntu的安全性 

- Further information about security at Ubuntu, have a look at [Ubuntu Security](https://ubuntu.com/security)
  有关Ubuntu安全性的更多信息，请查看Ubuntu安全性

- Information about known vulnerabilities:

  
  有关已知漏洞的信息： 

  - per CVE check out the [CVE overview](https://ubuntu.com/security/cves)
    查看CVE概述
  - per Package have a look at the [Ubuntu Security Notices](https://ubuntu.com/security/notices)
    查看Ubuntu安全声明

- Reporting a security issue, have a look at the [disclosure policy](https://ubuntu.com/security/disclosure-policy)
  报告安全问题，查看披露政策

------

# Introduction to crypto libraries 加密库简介 

The cryptographic library landscape is vast and complex, and there are many crypto libraries available on an Ubuntu system. What an application  developer decides to use can be governed by many aspects, such as:
加密库环境是巨大而复杂的，Ubuntu系统上有许多加密库。应用程序开发人员决定使用什么可以由许多方面来管理，例如： 

- Technical requirements 技术要求 
- Language bindings 语言绑定 
- License 许可证 
- Community 社区 
- Ease of use 易用性 
- General availability 正式公开注册 
- Upstream maintenance 上游维护 

Among the most popular and widely used libraries and frameworks, we have:
在最流行和最广泛使用的库和框架中，我们有： 

- OpenSSL
- GnuTLS
- NSS
- GnuPG
- gcrypt

Each one of these has its own implementation details, API, behavior, configuration file, and syntax.
其中每一个都有自己的实现细节、API、行为、配置文件和语法。 

This poses a challenge to system administrators who need to determine what  cryptographic algorithms are being used on the systems they deploy. How  does one ensure no legacy crypto is being used? Or that no keys below a  certain size are ever selected or created? And which types of X509  certificates are acceptable for connecting to remote servers?
这给系统管理员提出了一个挑战，他们需要确定在他们部署的系统上使用了什么加密算法。如何确保没有使用遗留加密？或者说，没有选择或创建低于一定大小的键？哪些类型的X509证书可用于连接远程服务器？ 

One has to check all of the crypto implementations installed on the system  and their configuration. To make things even more complicated, sometimes an application implements its own crypto, without using anything  external.
必须检查系统上安装的所有加密实现及其配置。为了使事情变得更加复杂，有时应用程序实现自己的加密，而不使用任何外部的东西。 

## How do we know which library an application is using? 我们如何知道应用程序正在使用哪个库？ 

Ultimately, the only reliable way to determine how an application uses cryptography is via its documentation or inspection of source code. But the code is  not always available, and sometimes the documentation lacks this  information. When the documentation isn’t clear or enough, there are  some other practical checks that can be made.
最终，确定应用程序如何使用加密的唯一可靠方法是通过其文档或对源代码的检查。但是代码并不总是可用的，有时文档中缺少这些信息。当文档不清楚或不够时，可以进行一些其他的实际检查。 

First, let’s take a look at how an application could use crypto.
首先，让我们来看看应用程序如何使用加密。 

### Dynamic linking 动态链接 

This is the most common way, and very easy to spot via package dependencies  and helper tools. This is discussed later in this page.
这是最常见的方式，并且很容易通过包依赖项和帮助工具发现。这将在本页后面讨论。 

### Static linking 静态链接 

This is harder, as there is no dependency information in the binary package, and this usually requires inspection of the source package to see Build Dependencies. An example is shown later in this page.
这比较困难，因为二进制包中没有依赖信息，这通常需要检查源包以查看构建依赖。本页稍后将显示一个示例。 

### Plugins 插件 

The main binary of an application can not depend directly on a crypto  library, but it could load dynamic plugins which do. Usually these would be packaged separately, and then we fall under the dynamic or static  linking cases above. Note that via such a plugin mechanism, an  application could depend on multiple external cryptographic libraries.
应用程序的主二进制文件不能直接依赖于加密库，但它可以加载动态插件。通常，这些链接会被单独打包，然后我们就属于上面的动态链接或静态链接的情况。注意，通过这样的插件机制，应用程序可以依赖于多个外部加密库。 

### Execution of external binary 执行外部二进制 

The application could just plain call external binaries at runtime for its cryptographic operations, like calling out to `openssl` or `gnupg` to encrypt/decrypt data. This will hopefully be expressed in the  dependencies of the package. If it’s not, then it’s a bug that should be reported.
应用程序可以在运行时简单地调用外部二进制文件进行加密操作，比如调用 `openssl` 或 `gnupg` 来加密/解密数据。这将有望在包的依赖项中表达出来。如果不是，那么这是一个应该报告的bug。

### Indirect usage 使用状况间接 

The application could be using a third party library or executable which in turn could fall into any of the above categories.
应用程序可能使用第三方库或可执行文件，而这些库或可执行文件又可能属于上述任何类别。 

## Identify the crypto libraries used by an application 识别应用程序使用的加密库 

Here are some tips that can help identifying the crypto libraries used by an application that is installed on an Ubuntu system:
以下是一些提示，可以帮助识别安装在Ubuntu系统上的应用程序所使用的加密库： 

### Documentation 文件 

Read the application documentation. It might have crypto options directly in its own configuration files, or point at specific crypto configuration  files installed on the system. This may also clarify if the application  even uses external crypto libraries, or if it has its own  implementation.
阅读应用文档。它可能在自己的配置文件中直接包含加密选项，或者指向系统上安装的特定加密配置文件。这也可以澄清应用程序是否使用外部加密库，或者它是否有自己的实现。 

### Package dependencies 包依赖项 

The package dependencies are a good way to check what is needed at runtime by the application.
包依赖项是检查应用程序在运行时需要什么的好方法。 

To find out the package that owns a file, use `dpkg -S`. For example:
要找出拥有文件的包，请使用 `dpkg -S` 。举例来说：

```console
$ dpkg -S /usr/bin/lynx
lynx: /usr/bin/lynx
```

Then, with the package name in hand, check its dependencies. It’s best to also look for `Recommends`, as they are installed by default. Continuing with the example from before, we have:
然后，用包名检查它的依赖项。最好也查找 `Recommends` ，因为它们是默认安装的。继续前面的例子，我们有：

```console
$ dpkg -s lynx | grep -E "^(Depends|Recommends)"
Depends: libbsd0 (>= 0.0), libbz2-1.0, libc6 (>= 2.34), libgnutls30 (>= 3.7.0), libidn2-0 (>= 2.0.0), libncursesw6 (>= 6), libtinfo6 (>= 6), zlib1g (>= 1:1.1.4), lynx-common
Recommends: mime-support
```

Here we see that `lynx` links with `libgnutls30`, which answers our question: `lynx` uses the GnuTLS library for its cryptography operations.
在这里，我们看到 `lynx` 链接到 `libgnutls30` ，这回答了我们的问题： `lynx` 使用GnuTLS库进行加密操作。

### Dynamic linking, plugins 动态链接、插件 

The dynamic libraries that are needed by an application should always be  correctly identified in the list of dependencies of the application  package. When that is not the case, or if you need to identify what is  needed by some plugin that is not part of the package, you can use some  system tools to help identify the dependencies.
应用程序所需的动态库应始终在应用程序包的依赖项列表中正确标识。如果情况并非如此，或者如果您需要确定某些插件所需的内容不属于软件包的一部分，则可以使用一些系统工具来帮助确定依赖项。 

A very helpful tool that is installed in all Ubuntu systems is `ldd`. It will list all the dynamic libraries that are needed by the given  binary, including dependencies of dependencies, i.e. it’s recursive.  Going back to the `lynx` example:
一个非常有用的工具，安装在所有Ubuntu系统是 `ldd` 。它将列出给定二进制文件所需的所有动态库，包括依赖项的依赖项，即它是递归的。回到 `lynx` 的例子：

```console
$ ldd /usr/bin/lynx
    linux-vdso.so.1 (0x00007ffffd2df000)
    libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007feb69d77000)
    libbz2.so.1.0 => /lib/x86_64-linux-gnu/libbz2.so.1.0 (0x00007feb69d64000)
    libidn2.so.0 => /lib/x86_64-linux-gnu/libidn2.so.0 (0x00007feb69d43000)
    libncursesw.so.6 => /lib/x86_64-linux-gnu/libncursesw.so.6 (0x00007feb69d07000)
    libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007feb69cd5000)
    libgnutls.so.30 => /lib/x86_64-linux-gnu/libgnutls.so.30 (0x00007feb69aea000)
    libbsd.so.0 => /lib/x86_64-linux-gnu/libbsd.so.0 (0x00007feb69ad0000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007feb698a8000)
    libunistring.so.2 => /lib/x86_64-linux-gnu/libunistring.so.2 (0x00007feb696fe000)
    libp11-kit.so.0 => /lib/x86_64-linux-gnu/libp11-kit.so.0 (0x00007feb695c3000)
    libtasn1.so.6 => /lib/x86_64-linux-gnu/libtasn1.so.6 (0x00007feb695ab000)
    libnettle.so.8 => /lib/x86_64-linux-gnu/libnettle.so.8 (0x00007feb69565000)
    libhogweed.so.6 => /lib/x86_64-linux-gnu/libhogweed.so.6 (0x00007feb6951b000)
    libgmp.so.10 => /lib/x86_64-linux-gnu/libgmp.so.10 (0x00007feb69499000)
    /lib64/ld-linux-x86-64.so.2 (0x00007feb69fe6000)
    libmd.so.0 => /lib/x86_64-linux-gnu/libmd.so.0 (0x00007feb6948c000)
    libffi.so.8 => /lib/x86_64-linux-gnu/libffi.so.8 (0x00007feb6947f000)
```

We again see the GnuTLS library (via `libgnutls.so.30`) in the list, and can reach the same conclusion.
我们再次在列表中看到GnuTLS库（通过 `libgnutls.so.30` ），并且可以得出相同的结论。

Another way to check for such dependencies, but without the recursion, is via `objdump`. This may need to be installed via the `binutils` package, as it’s not mandatory.
另一种检查这种依赖关系的方法，但没有递归，是通过 `objdump` 。这可能需要通过 `binutils` 包安装，因为它不是强制性的。

The way to use it is to grep for the `NEEDED` string:
使用它的方法是grep获取 `NEEDED` 字符串：

```console
$ objdump -x /usr/bin/lynx|grep NEEDED
  NEEDED               libz.so.1
  NEEDED               libbz2.so.1.0
  NEEDED               libidn2.so.0
  NEEDED               libncursesw.so.6
  NEEDED               libtinfo.so.6
  NEEDED               libgnutls.so.30
  NEEDED               libbsd.so.0
  NEEDED               libc.so.6
```

Finally, if you want to see the dependency *tree*, you can use `lddtree` from the `pax-utils` package:
最后，如果你想查看依赖树，你可以使用 `pax-utils` 包中的 `lddtree` ：

```console
$ lddtree /usr/bin/lynx
lynx => /usr/bin/lynx (interpreter => /lib64/ld-linux-x86-64.so.2)
    libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1
    libbz2.so.1.0 => /lib/x86_64-linux-gnu/libbz2.so.1.0
    libidn2.so.0 => /lib/x86_64-linux-gnu/libidn2.so.0
        libunistring.so.2 => /lib/x86_64-linux-gnu/libunistring.so.2
    libncursesw.so.6 => /lib/x86_64-linux-gnu/libncursesw.so.6
    libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6
    libgnutls.so.30 => /lib/x86_64-linux-gnu/libgnutls.so.30
        libp11-kit.so.0 => /lib/x86_64-linux-gnu/libp11-kit.so.0
            libffi.so.8 => /lib/x86_64-linux-gnu/libffi.so.8
        libtasn1.so.6 => /lib/x86_64-linux-gnu/libtasn1.so.6
        libnettle.so.8 => /lib/x86_64-linux-gnu/libnettle.so.8
        libhogweed.so.6 => /lib/x86_64-linux-gnu/libhogweed.so.6
        libgmp.so.10 => /lib/x86_64-linux-gnu/libgmp.so.10
        ld-linux-x86-64.so.2 => /lib64/ld-linux-x86-64.so.2
    libbsd.so.0 => /lib/x86_64-linux-gnu/libbsd.so.0
        libmd.so.0 => /lib/x86_64-linux-gnu/libmd.so.0
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6
```

### Static linking 静态链接 

Identifying which libraries were used in a static build is a bit more involved.  There are two ways, and they are complementary most of the time:
识别在静态构建中使用了哪些库要复杂一些。有两种方法，它们在大多数情况下是互补的： 

- look for the `Built-Using` header in the binary package
  在二进制包中查找 `Built-Using` 头文件
- inspect the `Build-Depends` header in the source package
  检查源程序包中的 `Build-Depends` 头文件

For example, let’s try to discover which crypto libraries, if any, the `rclone` tool uses. First, let’s try the packaging dependencies:
例如，让我们尝试发现 `rclone` 工具使用哪些加密库（如果有的话）。首先，让我们尝试打包依赖项：

```console
$ dpkg -s rclone | grep -E "^(Depends|Recommends)"
Depends: libc6 (>= 2.34)
```

Uh, that’s a short list. But `rclone` definitely supports encryption, so what is going on? Turns out this is a tool written in the Go language, and that uses static linking of  libraries. So let’s try to inspect the package data more carefully, and  this time look for the `Built-Using` header:
呃，名单很短。但是 `rclone` 肯定支持加密，那么这是怎么回事呢？原来这是一个用Go语言编写的工具，它使用库的静态链接。因此，让我们尝试更仔细地检查包数据，这一次寻找 `Built-Using` 头：

```console
$ dpkg -s rclone | grep Built-Using
Built-Using: go-md2man-v2 (= 2.0.1+ds1-1), golang-1.18 (= 1.18-1ubuntu1), golang-bazil-fuse (= 0.0~git20160811.0.371fbbd-3), ...
```

Ok, this time we have a lot of information (truncated above for brevity,  since it’s all in one very long line). If we look at the full output  carefully, we can see that `rclone` was built statically using the `golang-go.crypto` package, and documentation about that package and its crypto implementations is what we should look for.
好了，这次我们有了很多信息（为了简洁，上面的信息被截断了，因为它们都在一个很长的行中）。如果我们仔细查看完整的输出，我们可以看到 `rclone` 是使用 `golang-go.crypto` 包静态构建的，我们应该寻找有关该包及其加密实现的文档。

If the `Built-Using` header was not there, or didn’t yield any clues, we could try one more  step and look for the build dependencies. These can be found in the `debian/control` file of the source package. In the case of `rclone` for Ubuntu Jammy, that can be seen at [control « debian - ubuntu/+source/rclone - [no description\]](https://git.launchpad.net/ubuntu/+source/rclone/tree/debian/control?h=ubuntu/jammy-devel#n7), and a quick look at the `Build-Depends` list shows us the `golang-golang-x-crypto-dev` build dependency, whose source package is `golang-go.crypto` as expected:
如果 `Built-Using` 头文件不在那里，或者没有产生任何线索，我们可以再尝试一步，寻找构建依赖项。这些可以在源程序包的 `debian/control` 文件中找到。在Ubuntu Jammy的 `rclone` 的情况下，可以在控制« debian - ubuntu/+source/rclone - [无描述]中看到，快速查看 `Build-Depends` 列表向我们展示了 `golang-golang-x-crypto-dev` 构建依赖项，其源代码包如预期的那样是 `golang-go.crypto` ：

```console
$ apt-cache show golang-golang-x-crypto-dev | grep ^Source:
Source: golang-go.crypto
```

> **NOTE 注意**
>  If there is no `Source:` line, then it means the name of the source package is the same as the binary package that was queried.
>  如果没有 `Source:` 行，则表示源程序包的名称与查询的二进制程序包相同。

## What’s next? 接下来呢？ 

Now that you have uncovered which library your application is using, the  following guides will help you to understand the associated  configuration files and what options you have available (including some  handy examples!).
现在你已经了解了你的应用程序正在使用哪个库，下面的指南将帮助你理解相关的配置文件以及你有哪些可用的选项（包括一些方便的例子！）。 

- [OpenSSL guide OpenSSL指南](https://ubuntu.com/server/docs/openssl)
- [GnuTLS guide GnuTLS指南](https://ubuntu.com/server/docs/gnutls)
- [Troubleshooting TLS/SSL TLS/SSL故障排除](https://ubuntu.com/server/docs/troubleshooting-tls-ssl)

------

# ntroduction to WireGuard VPN WireGuard VPN简介 

WireGuard is a simple, fast and modern VPN implementation. It is widely deployed and can be used cross-platform.
WireGuard是一个简单，快速和现代的VPN实现。它被广泛部署，可以跨平台使用。 

VPNs have traditionally been hard to understand, configure and deploy.  WireGuard removed most of that complexity by focusing on its single  task, and leaving out things like key distribution and pushed  configurations. You get a network interface which encrypts and verifies  the traffic, and the remaining tasks like setting up addresses, routing, etc, are left to the usual system tools like [ip-route(8)](https://manpages.ubuntu.com/manpages/man8/ip-route.8.html) and [ip-address(8)](https://manpages.ubuntu.com/manpages/man8/ip-address.8.html).
传统上，VPN很难理解、配置和部署。WireGuard通过专注于单一任务来消除大部分复杂性，并省略了密钥分发和推送配置等内容。你得到一个网络接口，它加密和验证流量，剩下的任务，如设置地址，路由等，留给常用的系统工具，如ip-route（8）和ip-address（8）。

Setting up the cryptographic keys is very much similar to configuring SSH for  key based authentication: each side of the connection has its own  private and public key, and the peers’ public key, and this is enough to start encrypting and verifying the exchanged traffic.
设置加密密钥非常类似于为基于密钥的身份验证配置SSH：连接的每一端都有自己的私钥和公钥，以及对等方的公钥，这足以开始加密和验证交换的流量。 

For more details on how WireGuard works, and information on its  availability on other platforms, please see the references section.
有关WireGuard如何工作的更多详细信息以及有关其在其他平台上的可用性的信息，请参阅参考资料部分。 

## WireGuard concepts WireGuard概念 

It helps to think of WireGuard primarily as a network interface, like any  other. It will have the usual attributes, like IP address, CIDR, and  there will be some routing associated with it. But it also has  WireGuard-specific attributes, which handle the VPN part of things.
它有助于将WireGuard主要视为网络接口，就像其他任何接口一样。它将具有通常的属性，如IP地址，CIDR，并且将有一些与之关联的路由。但它也具有WireGuard特定的属性，这些属性处理VPN部分。 

All of this can be configured via different tools. WireGuard itself ships its own tools in the user-space package `wireguard-tools`: [`wg`](https://manpages.ubuntu.com/manpages/man8/wg.8.html) and [`wg-quick`](https://manpages.ubuntu.com/manpages/man8/wg-quick.8.html). But these are not strictly needed: any user space with the right  privileges and kernel calls can configure a WireGuard interface. For  example, `systemd-networkd` and `network-manager` can do it on their own, without the WireGuard user-space utilities.
所有这些都可以通过不同的工具进行配置。WireGuard本身在用户空间包 `wireguard-tools` 中提供了自己的工具： `wg` 和 `wg-quick` 。但这些并不是严格需要的：任何具有正确权限和内核调用的用户空间都可以配置WireGuard接口。例如， `systemd-networkd` 和 `network-manager` 可以自己完成，而不需要WireGuard用户空间实用程序。

Important attributes of a WireGuard interface are:
WireGuard接口的重要属性包括： 

- **Private key**: together with the corresponding public key, they are used to authenticate and encrypt data. This is generated with the `wg genkey` command.
  私钥：与相应的公钥一起用于验证和加密数据。这是用 `wg genkey` 命令生成的。

- **Listen port**: the UDP port that WireGuard will be listening to for incoming traffic.
  侦听端口：WireGuard将侦听传入流量的UDP端口。

- List of 

  peers

  , each one with:

  
  对等体列表，每个对等体具有： 

  - **Public key**: the public counterpart of the private key. Generated from the private key of that peer, using the `wg pubkey` command.
    公钥：私钥的公钥对应物。使用 `wg pubkey` 命令从该对等方的私钥生成。
  - **Endpoint**: where to send the encrypted traffic to. This is optional, but at least  one of the corresponding peers must have it to bootstrap the connection.
    端点：加密流量发送到的位置。这是可选的，但至少有一个相应的对等点必须有它来引导连接。
  - **Allowed IPs**: list of inner tunnel destination networks or addresses for this peer  when sending traffic, or, when receiving traffic, which source networks  or addresses are allowed to send traffic to us.
    允许的IP：发送流量时，此对等体的内部隧道目的地网络或地址列表，或者接收流量时，允许哪些源网络或地址向我们发送流量。

> **Note**: 注意：
>  Cryptography is not simple. When we say that, for example, a private key is used to decrypt or sign traffic, and a public key is used to encrypt or verify the authenticity of traffic, this is a simplification and is  hiding a lot of important details. WireGuard has a detailed explanation  of its protocols and cryptography handling [on its website](https://www.wireguard.com/protocol/).
>  密码学并不简单。例如，当我们说私钥用于解密或签名流量，公钥用于加密或验证流量的真实性时，这是一种简化，隐藏了许多重要的细节。WireGuard在其网站上对其协议和加密处理进行了详细解释。

These parameters can be set with the low-level [`wg`](https://manpages.ubuntu.com/manpages/man8/wg.8.html) tool, directly via the command line or with a configuration file. This  tool, however, doesn’t handle the non-WireGuard settings of the  interface. It won’t assign an IP address to it, for example, nor set up  routing. For this reason, it’s more common to use [`wg-quick`](https://manpages.ubuntu.com/manpages/man8/wg-quick.8.html).
这些参数可以使用低级 `wg` 工具直接通过命令行或配置文件进行设置。但是，此工具不处理接口的非WireGuard设置。例如，它不会为其分配IP地址，也不会设置路由。因此，更常见的是使用 `wg-quick` 。

`wg-quick` will handle the lifecycle of the WireGuard interface. It can bring it  up or down, set up routing, execute arbitrary commands before or after  the interface is up, and more. It augments the configuration file that `wg` can use, with its own extra settings, which is important to keep in mind when feeding that file to `wg`, as it will contain settings `wg` knows nothing about.
 `wg-quick` 将处理WireGuard接口的生命周期。它可以打开或关闭接口，设置路由，在接口打开之前或之后执行任意命令，等等。它增加了 `wg` 可以使用的配置文件，带有自己的额外设置，当将该文件提供给 `wg` 时，请记住这一点很重要，因为它将包含 `wg` 一无所知的设置。

The `wg-quick` configuration file can have an arbitrary name, and can even be placed anywhere on the system, but the best practice is to:
 `wg-quick` 配置文件可以具有任意名称，甚至可以放置在系统上的任何位置，但最佳做法是：

- Place the file in `/etc/wireguard`.
  将文件放入 `/etc/wireguard` 。
- Name it after the interface it controls.
  以它所控制的接口命名。 

For example, a file called `/etc/wireguard/wg0.conf` will have the needed configuration settings for a WireGuard network interface called `wg0`. By following this practice, you get the benefit of being able to call `wg-quick` with just the interface name:
例如，名为 `/etc/wireguard/wg0.conf` 的文件将包含名为 `wg0` 的WireGuard网络接口所需的配置设置。通过遵循此实践，您可以获得仅使用接口名称调用 `wg-quick` 的好处：

```bash
$ sudo wg-quick up wg0
```

That will bring the `wg0` interface up, give it an IP address, set up routing, and configure the  WireGuard-specific parameters for it to work. This interface is usually  called `wg0`, but can have any valid network interface name, like `office` (it doesn’t need an index number after the name), `home1`, etc. It can help to give it a meaningful name if you plan to connect to multiple peers.
这将启动 `wg0` 接口，为它给予IP地址，设置路由，并配置WireGuard特定的参数以使其工作。此接口通常称为 `wg0` ，但可以使用任何有效的网络接口名称，如 `office` （名称后不需要索引号）、 `home1` 等。如果您计划连接到多个对等体，则可以为它给予一个有意义的名称。

Let’s go over an example of such a configuration file:
让我们看一个这样的配置文件的例子： 

```auto
[Interface]
PrivateKey = eJdSgoS7BZ/uWkuSREN+vhCJPPr3M3UlB3v1Su/amWk=
ListenPort = 51000
Address = 10.10.11.10/24

[Peer]
# office
PublicKey = xeWmdxiLjgebpcItF1ouRo0ntrgFekquRJZQO+vsQVs=
Endpoint = wg.example.com:51000 # fake endpoint, just an example
AllowedIPs = 10.10.11.0/24, 10.10.10.0/24
```

In the `[Interface]` section: 在 `[Interface]` 部分中：

- **`Address`**: this is the IP address, and CIDR, that the WireGuard interface will be set up with.
   `Address` ：这是设置WireGuard接口所使用的IP地址和CIDR。
- **`ListenPort`**: the UDP port WireGuard will use for traffic (listening and sending).
   `ListenPort` ：WireGuard将用于流量（侦听和发送）的UDP端口。
- **`PrivateKey`**: the secret key used to decrypt traffic destined for this interface.
   `PrivateKey` ：用于解密发往此接口的流量的密钥。

The **peers** list, each one in its own `[Peer]` section (example above has just one), comes next:
接下来是对等体列表，每个对等体都在自己的 `[Peer]` 部分中（上面的示例只有一个）：

- **`PublicKey`**: the key that will be used to encrypt traffic to this peer.
   `PublicKey` ：将用于加密到此对等方的流量的密钥。
- **`Endpoint`**: where to send encrypted traffic to.
   `Endpoint` ：将加密流量发送到何处。
- **`AllowedIPs`**: when sending traffic, this is the list of target addresses that  identify this peer. When receiving traffic, it’s the list of addresses  that are allowed to be the source of the traffic.
   `AllowedIPs` ：发送流量时，这是标识此对等体的目标地址列表。当接收流量时，它是允许作为流量源的地址列表。

To generate the keypairs for each peer, the `wg` command is used:
要为每个对等体生成密钥对，请使用 `wg` 命令：

```bash
$ umask 077
$ wg genkey > wg0.key
$ wg pubkey < wg0.key > wg0.pub
```

And then the contents of `wg0.key` and `wg0.pub` can be used in the configuration file.
然后 `wg0.key` 和 `wg0.pub` 的内容可以在配置文件中使用。

This is what it looks like when this interface is brought up by `wg-quick`:
这是当这个接口被 `wg-quick` 打开时的样子：

```bash
$ sudo wg-quick up wg0
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip -4 address add 10.10.11.10/24 dev wg0
[#] ip link set mtu 1420 up dev wg0
[#] ip -4 route add 10.10.10.0/24 dev wg0
```

This is what `wg-quick`:
这就是 `wg-quick` ：

- Created the WireGuard `wg0` interface.
  创建WireGuard `wg0` 接口。
- Configured it with the data from the configuration file.
  用配置文件中的数据配置了它。 
- Added the IP/CIDR from the `Address` field to the `wg0` interface.
  从 `Address` 字段添加IP/CIDR到 `wg0` 接口。
- Calculated a proper MTU (which can be overridden in the config if needed).
  计算出正确的MTU（如果需要，可以在配置中覆盖）。 
- Added a route for `AllowedIPs`.
  添加了 `AllowedIPs` 的路由。

Note that in this example `AllowedIPs` is a list of two CIDR network blocks, but `wg-quick` only added a route for `10.10.10.0/24` and skipped `10.10.11.0/24`. That’s because the `Address` was already specified as a `/24` one. Had we specified the address as `10.10.11.10/32` instead, then `wg-quick` would have added a route for `10.10.11.0/24` explicitly.
请注意，在此示例中， `AllowedIPs` 是两个CIDR网络块的列表，但 `wg-quick` 仅为 `10.10.10.0/24` 添加了路由，并跳过了 `10.10.11.0/24` 。这是因为 `Address` 已经被指定为 `/24` 。如果我们将地址指定为 `10.10.11.10/32` ，那么 `wg-quick` 将显式地为 `10.10.11.0/24` 添加一个路由。

To better understand how `AllowedIPs` work, let’s go through a quick example.
为了更好地理解 `AllowedIPs` 是如何工作的，让我们通过一个快速的例子。

Let’s say this system wants to send traffic to `10.10.10.201/24`. There is a route for it which says to use the `wg0` interface for that:
假设这个系统想要发送流量到 `10.10.10.201/24` 。有一个路由，它说使用 `wg0` 接口：

```bash
$ ip route get 10.10.10.201
10.10.10.201 dev wg0 src 10.10.11.10 uid 1000
    cache
```

Since `wg0` is a WireGuard interface, it will consult its configuration to see if any peer has that target address in the `AllowedIPs` list. Turns out one peer has it, in which case the traffic will:
由于 `wg0` 是一个WireGuard接口，它将查询其配置，以查看是否有任何对等体在 `AllowedIPs` 列表中具有该目标地址。结果是一个对等体拥有它，在这种情况下，流量将：

a) Be authenticated as us, and encrypted for that peer.
a）作为我们进行身份验证，并为该对等体加密。
 b) Sent away via the configured `Endpoint`.
 B）通过配置的 `Endpoint` 发送。

Now let’s picture the reverse. This system received traffic on the `ListenPort` UDP port. If it can be decrypted, and verified as having come from one  of the listed peers using its respective public key, and if the source  IP matches the corresponding `AllowedIPs` list, then the traffic is accepted.
现在让我们反过来想。此系统在 `ListenPort` UDP端口上接收流量。如果它可以被解密，并且被验证为来自使用其相应公钥的所列出的对等体之一，并且如果源IP与对应的 `AllowedIPs` 列表匹配，则流量被接受。

What if there is no `Endpoint`? Well, to bootstrap the VPN, at least one of the peers must have an `Endpoint`, or else it won’t know where to send the traffic to, and you will get an error saying “Destination address required” (see the [troubleshooting section](https://ubuntu.com/server/docs/troubleshooting-wireguard-vpn) for details).
如果没有 `Endpoint` 呢？好吧，要引导VPN，至少有一个对等端必须有一个 `Endpoint` ，否则它将不知道将流量发送到哪里，并且您将得到一个错误，说“需要目标地址”（请参阅故障排除部分了解详细信息）。

But once the peers know each other, the one that didn’t have an `Endpoint` setting in the interface will remember where the traffic came from, and use that address as the current endpoint. This has a very nice side  effect of automatically tracking the so called “road warrior” peer,  which keeps changing its IP. This is very common with laptops that keep  being suspended and awakened in a new network, and then try to establish the VPN again from that new address.
但是，一旦对等端相互了解，接口中没有 `Endpoint` 设置的对等端将记住流量来自何处，并将该地址用作当前端点。这有一个非常好的副作用，即自动跟踪所谓的"公路战士"对等体，它不断改变其IP。这是非常常见的笔记本电脑，保持暂停和唤醒在一个新的网络，然后尝试建立VPN再次从该新地址。

### Peers 同行 

You will notice that the term “peers” is used preferably to “server” or  “client”. Other terms used in some VPN documentation are “left” and  “right”, which is already starting to convey that the difference between a “server” and a “client” is a bit blurry. It only matters, if at all,  at the start of the traffic exchange: who sends the first packet of  data?
您会注意到，术语“对等点”最好用于“服务器”或“客户端”。一些VPN文档中使用的其他术语是“左”和“右”，这已经开始传达“服务器”和“客户端”之间的区别有点模糊。只有在流量交换开始时才有关系：谁发送第一个数据包？ 

In that sense, “servers” expect to sit idle and wait for connections to be initiated to them, and “clients” are the initiators. For example, a  laptop in a public cafe initiating a connection to the company VPN peer. The laptop needs to know the address of that peer, because it’s  initiating the exchange. But the “server” doesn’t need to know the IP of the laptop beforehand.
从这个意义上说，“服务器”期望处于空闲状态并等待与它们的连接被发起，而“客户端”是发起者。例如，公共咖啡馆中的笔记本电脑发起与公司VPN对等体的连接。笔记本电脑需要知道对等体的地址，因为它正在发起交换。但是“服务器”不需要事先知道笔记本电脑的IP。 

On a site-to-site VPN, however, when two separate networks are connected  through the tunnel, who is the server and who is the client? Both! So  it’s best to call them “peers” instead.
然而，在站点到站点VPN上，当两个独立的网络通过隧道连接时，谁是服务器，谁是客户端？两个都是所以最好叫他们“同伴”。 

## Putting it all together 把它放在一起 

Key takeaways from this introduction:
本简介的主要内容： 

- Each peer participating in the WireGuard VPN has a private key and a public key.
  参与WireGuard VPN的每个对等点都有一个私钥和一个公钥。 
- `AllowedIPs` is used as a routing key when sending traffic, and as an ACL when receiving traffic.
   `AllowedIPs` 在发送流量时用作路由键，在接收流量时用作ACL。
- To establish a VPN with a remote peer, you need its public key. Likewise, the remote peer will need your public key.
  要与远程对等体建立VPN，您需要其公钥。同样，远程对等点也需要您的公钥。 
- At least one of the peers needs an `Endpoint` configured in order to be able to initiate the VPN.
  至少有一个对等端需要配置 `Endpoint` ，以便能够启动VPN。

To help better understand these (and other) concepts, we will create some  WireGuard VPNs in the next sections, illustrating some common setups.
为了帮助更好地理解这些（和其他）概念，我们将在接下来的部分中创建一些WireGuard VPN，并说明一些常见的设置。 

### Peer-to-site 点对点 

- [About peer-to-site 关于点对点](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site)
- [Set up peer-to-site “on router”
   在路由器上设置对等站点](https://ubuntu.com/server/docs/wireguard-vpn-peer-to-site-on-router)
- [Set up peer-to-site on an internal device
   在内部设备上设置对等站点](https://ubuntu.com/server/docs/wireguard-on-an-internal-system)

### Site-to-site

- [Set up site-to-site 设置站点到站点](https://ubuntu.com/server/docs/wireguard-vpn-site-to-site)

### Default gateway 默认网关 

- [Using the VPN as the default gateway
   使用VPN作为默认网关](https://ubuntu.com/server/docs/using-the-vpn-as-the-default-gateway)

### Other common tasks, hints and tips 其他常见任务、提示和技巧 

- [Common tasks 常见任务](https://ubuntu.com/server/docs/common-tasks-in-wireguard-vpn)
- [Security tips 安全提示](https://ubuntu.com/server/docs/security-tips-for-wireguard-vpn)
- [Troubleshooting 故障排除](https://ubuntu.com/server/docs/troubleshooting-wireguard-vpn)

> **Note**: 注意：
>  Throughout this guide, we will sometimes mention a VPN “connection”.  This is technically false, as WireGuard uses UDP and there is no  persistent connection. The term is used just to facilitate  understanding, and means that the peers in the examples know each other  and have completed a handshake already.
>  在本指南中，我们有时会提到VPN“连接”。这在技术上是错误的，因为WireGuard使用UDP，并且没有持久连接。该术语仅用于促进理解，意味着示例中的对等点彼此认识并且已经完成了握手。

## Further reading 进一步阅读 

- See the [WireGuard website](https://www.wireguard.com) for more detailed information.
  请参阅WireGuard网站了解更多详细信息。
- The [WireGuard Quickstart](https://www.wireguard.com/quickstart/) has a good introduction and demo.
  WireGuard Quickstart有很好的介绍和演示。
- [wg(8)](https://manpages.ubuntu.com/manpages/jammy/man8/wg.8.html) and [wg-quick(8)](https://manpages.ubuntu.com/manpages/jammy/man8/wg-quick.8.html) manual pages.
   wg（8）和wg-quick（8）手册页。
- [Detailed explanation](https://www.wireguard.com/protocol/) of the algorithms used by WireGuard.
   WireGuard使用的算法的详细说明。

# Web服务器简介 

Web servers are used to serve web pages requested by client computers.  Clients typically request and view web pages using web browser  applications such as Firefox, Opera, Chromium, or Internet Explorer.
Web服务器用于为客户端计算机请求的网页提供服务。客户端通常使用Web浏览器应用程序（如Firefox、Opera、Chromium或Internet Explorer）请求和查看网页。 

If you’re new to web servers, see this page for more information [on the key concepts](https://ubuntu.com/server/docs/about-web-servers).
如果您是Web服务器新手，请参阅此页面以了解有关关键概念的更多信息。

## Squid proxy server Squid代理服务器 

Squid is a popular, open-source, proxy caching server that can help optimise  network efficiency and improve response times by saving local copies of  frequently accessed content. Read more [about Squid proxy servers](https://ubuntu.com/server/docs/about-squid-proxy-servers) and what they can do, or find out [how to install a Squid server](https://ubuntu.com/server/docs/how-to-install-a-squid-server).
Squid是一个流行的开源代理缓存服务器，可以通过保存频繁访问内容的本地副本来帮助优化网络效率并缩短响应时间。阅读更多关于Squid代理服务器及其功能的信息，或者了解如何安装Squid服务器。

## LAMP 灯 

LAMP installations (Linux + Apache + MySQL + PHP/Perl/Python) are a popular  setup for Ubuntu servers. Linux provides the operating system, while the rest of the stack is composed of a web server, a database server, and a scripting language.
LAMP安装（Linux + Apache + MySQL + PHP/Perl/Python）是Ubuntu服务器的流行设置。Linux提供操作系统，而堆栈的其余部分由Web服务器、数据库服务器和脚本语言组成。 

One advantage of LAMP is the substantial flexibility it provides for  combining different web server, database, and scripting languages.  Popular substitutes for MySQL include PostgreSQL and SQLite. Python,  Perl, and Ruby are also frequently used instead of PHP. Apache can be  replaced by Nginx, Cherokee and Lighttpd.
LAMP的一个优点是它为组合不同的Web服务器、数据库和脚本语言提供了很大的灵活性。MySQL的流行替代品包括PostgreSQL和SQLite。Python、Perl和Ruby也经常被用来代替PHP。Apache可以被Nginx、切罗基和Lighttpd取代。 

In this documentation, we can show you how to [get started with LAMP](https://ubuntu.com/server/docs/get-started-with-lamp-applications) quickly, but also how to separately install and configure some of the different tooling options in the classic LAMP stack.
在本文档中，我们将向您展示如何快速开始使用LAMP，以及如何单独安装和配置经典LAMP堆栈中的一些不同工具选项。

### Web server Web服务器 

Apache is the most commonly used web server on Linux systems, and the current  version is Apache2. It is robust, reliable, and highly configurable.  This set of guides will show you:
Apache是Linux系统上最常用的Web服务器，目前的版本是Apache2。它强大、可靠且高度可配置。这套指南将向您展示： 

- [How to install and configure Apache2
   如何安装和配置Apache 2](https://ubuntu.com/server/docs/how-to-install-apache2)
- [How to configure Apache2 for your needs
   如何根据您的需求配置Apache2](https://ubuntu.com/server/docs/how-to-configure-apache2-settings)
- [How to extend Apache2’s functionality with modules
   如何使用模块扩展Apache2的功能](https://ubuntu.com/server/docs/how-to-use-apache2-modules)

Nginx is a popular alternative web server also widely used on Linux, with a  focus on static file serving performance, ease of configuration, and use as both a web server and reverse proxy server.
Nginx是一种流行的替代Web服务器，也广泛用于Linux，专注于静态文件服务性能，易于配置，并用作Web服务器和反向代理服务器。 

- [How to install Nginx
   如何安装Nginx](https://ubuntu.com/server/docs/how-to)
- [How to configure Nginx
   如何配置Nginx](https://ubuntu.com/server/docs/how-to-configure-nginx)
- [How to use Nginx modules
   如何使用Nginx模块](https://ubuntu.com/server/docs/how-to-use-nginx-modules)

### Database server 数据库服务器 

The database server, when included in the LAMP stack, allows data for web  applications to be stored and managed. MySQL is one of the most popular  open source Relational Database Management Systems (RDBMS) available,  and you can find out in this guide [how to install MySQL](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server) – or [PostgreSQL](https://ubuntu.com/server/docs/install-and-configure-postgresql), as another popular alternative.
当数据库服务器包含在LAMP堆栈中时，它允许存储和管理Web应用程序的数据。MySQL是最流行的开源关系数据库管理系统（RDBMS）之一，您可以在本指南中找到如何安装MySQL或PostgreSQL，作为另一种流行的替代方案。

### Scripting languages 脚本语言 

Server-side scripting languages allow for the creation of dynamic web content,  processing of web forms, and interacting with databases (amongst other  crucial tasks). PHP is most often used, and we can show you [how to install PHP](https://ubuntu.com/server/docs/how-to-install-and-configure-php), or if you prefer, we can show you [how to install Ruby on Rails](https://ubuntu.com/server/docs/how-to-install-and-configure-ruby-on-rails).
服务器端脚本语言允许创建动态Web内容、处理Web表单以及与数据库交互（以及其他关键任务）。PHP是最常用的，我们可以告诉你如何安装PHP，或者如果你愿意，我们可以告诉你如何安装Ruby on Rails。

Whichever scripting language you choose, you will need to have installed and  configured your web and database servers beforehand.
无论选择哪种脚本语言，都需要事先安装和配置Web和数据库服务器。 

### LAMP applications 灯应用 

Once your LAMP stack is up-and-running, you’ll need some applications to use with it. Some popular LAMP applications include wikis, management  software such as phpMyAdmin, and Content Management Systems (CMSs) like  WordPress. These guides will show you how to install and configure [phpMyAdmin](https://ubuntu.com/server/docs/how-to-install-and-configure-phpmyadmin) and [WordPress](https://ubuntu.com/server/docs/how-to-install-and-configure-wordpress) as part of your LAMP stack.
一旦您的LAMP堆栈启动并运行，您将需要一些应用程序来使用它。一些流行的LAMP应用程序包括wiki，管理软件（如phpMyAdmin）和内容管理系统（CMS）（如WordPress）。这些指南将向您展示如何安装和配置phpMyAdmin和WordPress作为LAMP堆栈的一部分。

------

# Introduction to mail services 邮件服务简介 

The process of getting an email from one person to another over a network  or the Internet involves many systems working together. Each of these  systems must be correctly configured for the process to work.
通过网络或Internet从一个人向另一个人发送电子邮件的过程涉及许多系统的协同工作。这些系统中的每一个都必须正确配置，以便流程正常工作。 

The sender uses a *Mail User Agent* (MUA), or email client, to send the message through one or more *Mail Transfer Agents* (MTA), the last of which will hand it off to a *Mail Delivery Agent* (MDA) for delivery to the recipient’s mailbox, from which it will be  retrieved by the recipient’s email client, usually via a POP3 or IMAP  server.
发件人使用邮件用户代理（MUA）或电子邮件客户端，通过一个或多个邮件传输代理（MTA）发送消息，最后一个将其移交给邮件传递代理（MDA）以传递到收件人的邮箱，收件人的电子邮件客户端通常通过POP3或IMAP服务器从邮箱中检索消息。

## Mail User Agent 邮件用户代理 

- **Thunderbird 雷鸟**
   The default MUA used by Ubuntu is [Thunderbird](https://www.thunderbird.net/). It comes pre-installed on all Ubuntu machines from Ubuntu 16.04 LTS (Xenial) onwards.
   Ubuntu使用的默认MUA是Thunderbird。它预装在Ubuntu 16.04 LTS（Xenial）以上的所有Ubuntu机器上。

  If you need to install Thunderbird manually, [this short guide](https://snapcraft.io/install/thunderbird/ubuntu) will walk you through the steps.
  如果你需要手动安装Thunderbird，这个简短的指南将引导你完成步骤。

## Mail Transfer Agent 邮件传输代理 

- **Postfix**
   On Ubuntu, [Postfix](https://www.postfix.org/) is the default supported MTA. It aims to be fast and secure, with flexibility in administration. It is compatible with the [sendmail](https://www.authsmtp.com/sendmail/index.html) MTA.
   在Ubuntu上，Postfix是默认支持的MTA。它的目标是快速和安全，管理灵活。它与Sendmail MTA兼容。

  This guide explains [how to install and configure Postfix](https://ubuntu.com/server/docs/install-and-configure-postfix), including how to configure SMTP for secure communications.
  本指南介绍如何安装和配置Postfix，包括如何配置SMTP以实现安全通信。

- **Exim4**
   [Exim4](https://www.exim.org/) was developed at the University of Cambridge for use on Unix systems  connected to the Internet. Exim can be installed in place of sendmail,  although its configuration is quite different.
   Exim 4是由剑桥大学开发的，用于连接到Internet的Unix系统。sendmail可以被安装在sendmail的位置，尽管它的配置有很大的不同。

  This guide explains [how to install and configure Exim4](https://ubuntu.com/server/docs/install-and-configure-exim4) on Ubuntu.
  本指南介绍如何在Ubuntu上安装和配置Exim4。

## Mail Delivery Agent 邮件递送代理 

- **Dovecot**
   [Dovecot](https://www.dovecot.org/) is an MDA written with security primarily in mind. It supports the [mbox](https://en.wikipedia.org/wiki/Mbox) and [Maildir](https://en.wikipedia.org/wiki/Maildir) mailbox formats.
   Dovecot是一个主要考虑安全性编写的MDA。它支持mbox和Maildir邮箱格式。

  This guide explains [how to set up Dovecot](https://ubuntu.com/server/docs/install-and-configure-dovecot) as an IMAP or POP3 server.
  本指南介绍如何将Dovecot设置为IMAP或POP3服务器。

# Introduction to High Availability 高可用性简介 

A definition of High Availability Clusters [from Wikipedia:](https://en.wikipedia.org/wiki/High-availability_cluster)
高可用性集群的定义来自维基百科：

## High Availability Clusters 高可用性群集 

> **High-availability clusters**  (also known as  **HA clusters**  ,  **fail-over clusters**  or  **Metroclusters Active/Active** ) are groups of [computers](https://en.wikipedia.org/wiki/Computer) that support [server](https://en.wikipedia.org/wiki/Server_(computing)) [applications](https://en.wikipedia.org/wiki/Application_software) that can be reliably utilized with [a minimum amount of down-time](https://en.wikipedia.org/wiki/High_availability).
> 高可用性群集（也称为HA群集、故障转移群集或Metroclusters Active/Active）是支持服务器应用程序的计算机组，这些服务器应用程序可以在最短的停机时间内得到可靠的利用。
>
> They operate by using [high availability software](https://en.wikipedia.org/wiki/High_availability_software) to harness [redundant](https://en.wikipedia.org/wiki/Redundancy_(engineering)) computers in groups or [clusters](https://en.wikipedia.org/wiki/Computer_cluster) that provide continued service when system components fail. 
> 它们通过使用高可用性软件来管理组或集群中的冗余计算机，从而在系统组件发生故障时提供持续服务。 
>
> Without clustering, if a server running a particular application crashes, the  application will be unavailable until the crashed server is fixed. HA  clustering remedies this situation by detecting hardware/software  faults, and immediately restarting the application on another system  without requiring administrative intervention, a process known as [failover](https://en.wikipedia.org/wiki/Failover). 
> 如果没有集群，如果运行特定应用程序的服务器崩溃，则在修复崩溃的服务器之前，应用程序将不可用。HA集群通过检测硬件/软件故障，并立即在另一个系统上重新启动应用程序而无需管理干预（称为故障转移的过程）来纠正这种情况。 
>
> As part of this process, clustering software may configure the node before starting the application on it. For example, appropriate file systems  may need to be imported and mounted, network hardware may have to be  configured, and some supporting applications may need to be running as  well.
>  作为此过程的一部分，群集软件可能会在启动节点上的应用程序之前配置节点。例如，可能需要导入和挂载适当的文件系统，可能需要配置网络硬件，并且可能还需要运行某些支持应用程序。 
>
> HA clusters are often used for critical [databases](https://en.wikipedia.org/wiki/Database_management_system), file sharing on a network, business applications, and customer services such as [electronic commerce](https://en.wikipedia.org/wiki/Electronic_commerce) [websites](https://en.wikipedia.org/wiki/Websites).
> HA集群通常用于关键数据库、网络上的文件共享、业务应用程序和客户服务（如电子商务网站）。

## High Availability Cluster Heartbeat 高可用性群集心跳 

> HA cluster implementations attempt to build redundancy into a cluster to  eliminate single points of failure, including multiple network  connections and data storage which is redundantly connected via [storage area networks](https://en.wikipedia.org/wiki/Storage_area_network).
> HA集群实现尝试在集群中构建冗余以消除单点故障，包括多个网络连接和通过存储区域网络冗余连接的数据存储。
>
> HA clusters usually use a [heartbeat](https://en.wikipedia.org/wiki/Heartbeat_(computing)) private network connection which is used to monitor the health and  status of each node in the cluster. One subtle but serious condition all clustering software must be able to handle is [split-brain](https://en.wikipedia.org/wiki/Split-brain_(computing)), which occurs when all of the private links go down simultaneously, but the cluster nodes are still running. 
> HA集群通常使用心跳私有网络连接，用于监视集群中每个节点的健康和状态。所有集群软件都必须能够处理的一个微妙但严重的情况是split-brain，当所有私有链路同时断开时，会发生这种情况，但集群节点仍在运行。 
>
> If that happens, each node in the cluster may mistakenly decide that every other node has gone down and attempt to start services that other nodes are still running. Having duplicate instances of services may cause  data corruption on the shared storage.
>  如果发生这种情况，集群中的每个节点可能会错误地认为其他节点都已关闭，并尝试启动其他节点仍在运行的服务。具有重复的服务实例可能会导致共享存储上的数据损坏。 

## High Availability Cluster Quorum 高可用性群集仲裁 

> HA clusters often also use [quorum](https://en.wikipedia.org/wiki/Quorum_(distributed_computing)) witness storage (local or cloud) to avoid this scenario. A witness  device cannot be shared between two halves of a split cluster, so in the event that all cluster members cannot communicate with each other  (e.g., failed heartbeat), if a member cannot access the witness, it  cannot become active.
> HA集群通常还使用仲裁见证存储（本地或云）来避免这种情况。见证设备不能在分割集群的两半之间共享，因此在所有集群成员不能彼此通信的情况下（例如，失败的心跳），如果成员无法访问见证服务器，则它无法变为活动状态。

## Example 例如 

![2-node HA cluster](https://assets.ubuntu.com/v1/14896401-HA_intro.png)

## Fencing 击剑 

Fencing protects your data from being corrupted, and your application from  becoming unavailable, due to unintended concurrent access by rogue  nodes.
隔离保护您的数据不被破坏，并且您的应用程序不会由于流氓节点的意外并发访问而变得不可用。 

Just because a node is unresponsive doesn’t mean it has stopped accessing  your data. The only way to be 100% sure that your data is safe, is to  use fencing to ensure that the node is truly offline before allowing the data to be accessed from another node.
仅仅因为一个节点没有响应并不意味着它已经停止访问您的数据。100%确保数据安全的唯一方法是在允许从另一个节点访问数据之前使用屏蔽来确保节点真正脱机。 

Fencing also has a role to play in the event that a clustered service cannot be stopped. In this case, the cluster uses fencing to force the whole node offline, thereby making it safe to start the service
在无法停止集群服务的情况下，隔离也可以发挥作用。在这种情况下，群集使用屏蔽来强制整个节点脱机，从而使启动服务变得安全
 elsewhere. The most popular example of fencing is cutting a host’s power.
 其他地方击剑最流行的例子是切断主机的电源。

Key Benefits: 主要优点： 

- Active countermeasure taken by a functioning host to isolate a misbehaving (usually dead) host from shared data.
  正常运行的主机采取的主动对策，用于将行为异常（通常为死机）的主机与共享数据隔离。 
- **MOST CRITICAL** part of a cluster utilizing SAN or other shared storage technology (*Ubuntu HA Clusters can only be supported if the fencing mechanism is configured*).
  使用SAN或其他共享存储技术的集群的最关键部分（只有在配置了屏蔽机制的情况下才能支持Ubuntu HA集群）。
- Required by OCFS2, GFS2, cLVMd (before Ubuntu 20.04), lvmlockd (from 20.04 and beyond).
  OCFS2、GFS2、cLVMd（Ubuntu 20.04之前）、lvmlockd（从20.04及更高版本）需要。 

## Linux High Availability Projects Linux高可用性项目 

There are many upstream high availability related projects that are included  in Ubuntu Linux. This section will describe the most important ones.
Ubuntu Linux中包含许多与上游高可用性相关的项目。本节将介绍其中最重要的几个。 

The following packages are present in latest Ubuntu LTS release:
以下软件包出现在最新的Ubuntu LTS版本中： 

### Ubuntu HA Core Packages Ubuntu HA核心包 

Packages in this list are supported just like any other package available in  **[main] repository**  would be.
此列表中的包与[main]存储库中的任何其他可用包一样受支持。

| Package         | URL                                                          |
| --------------- | ------------------------------------------------------------ |
| libqb           | [Ubuntu](https://launchpad.net/ubuntu/+source/libqb) \| [Upstream](http://clusterlabs.github.io/libqb/) Ubuntu\|上游 |
| kronosnet       | [Ubuntu](https://launchpad.net/ubuntu/+source/kronosnet) \| [Upstream](https://kronosnet.org/) Ubuntu\|上游 |
| corosync        | [Ubuntu](https://launchpad.net/ubuntu/+source/corosync) \| [Upstream](http://corosync.github.io/corosync/) Ubuntu\|上游 |
| pacemaker       | [Ubuntu](https://launchpad.net/ubuntu/+source/pacemaker) \| [Upstream](https://www.clusterlabs.org/pacemaker/) Ubuntu\|上游 |
| resource-agents | [Ubuntu](https://launchpad.net/ubuntu/+source/resource-agents) \| [Upstream](https://github.com/ClusterLabs/resource-agents) Ubuntu\|上游 |
| fence-agents    | [Ubuntu](https://launchpad.net/ubuntu/+source/fence-agents) \| [Upstream](https://github.com/ClusterLabs/fence-agents) Ubuntu\|上游 |
| crmsh           | [Ubuntu](https://launchpad.net/ubuntu/+source/crmsh) \| [Upstream](https://github.com/ClusterLabs/crmsh) Ubuntu\|上游 |
| pcs*            | [Ubuntu](https://launchpad.net/ubuntu/+source/pcs) \| [Upstream](https://github.com/ClusterLabs/pcs/) Ubuntu\|上游 |
| cluster-glue    | [Ubuntu](https://launchpad.net/ubuntu/+source/cluster-glue) \| [Upstream](https://github.com/ClusterLabs/cluster-glue) Ubuntu\|上游 |
| drbd-utils      | [Ubuntu](https://launchpad.net/ubuntu/+source/drbd-utils) \| [Upstream](https://www.linbit.com/drbd/) Ubuntu\|上游 |
| dlm             | [Ubuntu](https://launchpad.net/ubuntu/+source/dlm) \| [Upstream](https://pagure.io/dlm) Ubuntu\|上游 |
| gfs2-utils      | [Ubuntu](https://launchpad.net/ubuntu/+source/gfs2-utils) \| [Upstream](https://pagure.io/gfs2-utils) Ubuntu\|上游 |
| keepalived      | [Ubuntu](https://launchpad.net/ubuntu/+source/keepalived) \| [Upstream](https://www.keepalived.org/) Ubuntu\|上游 |

- **libqb** - Library which provides a set of high performance client-server  reusable features. It offers high performance logging, tracing, IPC and  poll. Its initial features were spun off the *Corosync* cluster communication suite to make them accessible for other projects.
  libqb -提供一组高性能客户端-服务器可重用特性的库。它提供高性能的日志记录、跟踪、IPC和轮询。其最初的功能是从Corosync群集通信套件中分离出来的，以便其他项目可以使用。
- **Kronosnet** - Kronosnet, often referred to as knet, is a network abstraction layer  designed for High Availability. Corosync uses Kronosnet to provide  multiple networks for its interconnect (replacing the old [Totem Redundant Ring Protocol](https://discourse.ubuntu.com/t/corosync-and-redundant-rings/11627)) and add support for some more features like interconnect network hot-plug.
  Kronosnet - Kronosnet，通常称为knet，是为高可用性设计的网络抽象层。Corosync使用Kronosnet为其互连提供多个网络（取代旧的Totem冗余环协议），并添加对互连网络热插拔等更多功能的支持。
- **Corosync** - or *Cluster Membership Layer*, provides reliable messaging, membership and quorum information about  the cluster. Currently, Pacemaker supports Corosync as this layer.
  Corosync -或群集成员关系层，提供有关群集的可靠消息传递、成员关系和仲裁信息。目前，Pacemaker支持将Corosync作为此层。
- **Pacemaker** - or *Cluster Resource Manager*, provides the brain that processes and reacts to events that occur in  the cluster. Events might be: nodes joining or leaving the cluster,  resource events caused by failures, maintenance, or scheduled  activities. To achieve the desired availability, Pacemaker may start and stop resources and fence nodes.
  Pacemaker -或群集资源管理器，提供处理群集中发生的事件并对其作出反应的大脑。事件可能是：节点加入或离开群集，由故障、维护或计划活动引起的资源事件。为了实现所需的可用性，Pacemaker可以启动和停止资源并对节点进行防护。
- **Resource Agents** - Scripts or operating system components that start, stop or monitor  resources, given a set of resource parameters. These provide a uniform  interface between pacemaker and the managed services.
  资源代理-在给定一组资源参数的情况下，启动、停止或监视资源的代理或操作系统组件。这些在起搏器和托管服务之间提供了统一的接口。
- **Fence Agents** - Scripts that execute node fencing actions, given a target and fence device parameters.
  围栏代理-在给定目标和围栏设备参数的情况下执行节点围栏操作的代理。
- **crmsh** - Advanced command-line interface for High-Availability cluster management in GNU/Linux.
  crmsh -GNU/Linux中用于高可用性集群管理的高级命令行界面。
- **pcs** - Pacemaker command line interface and GUI. It permits users to easily view, modify and create pacemaker based clusters. `pcs` also provides `pcsd`, which operates as a GUI and remote server for `pcs`. Together `pcs` and `pcsd` form the recommended configuration tool for use with pacemaker. *NOTE: It was added to the [main] repository in Ubuntu Lunar Lobster (23.10)*.
  pcs—Pacemaker命令行界面和GUI。它允许用户轻松查看、修改和创建基于起搏器的群集。 `pcs` 还提供了 `pcsd` ，它作为 `pcs` 的GUI和远程服务器运行。 `pcs` 和 `pcsd` 一起构成了与起搏器一起使用的推荐配置工具。注意：它被添加到Ubuntu Lunar Lobster（23.10）的[main]存储库中。
- **cluster-glue** - Reusable cluster components for Linux HA. This package contains node  fencing plugins, an error reporting utility, and other reusable cluster  components from the Linux HA project.
  cluster—glue—用于Linux HA的可重用集群组件。此软件包包含节点屏蔽插件、错误报告实用程序以及来自Linux HA项目的其他可重用群集组件。
- **DRBD** - Distributed Replicated Block Device, **DRBD**  is a [distributed replicated storage system](https://en.wikipedia.org/wiki/Distributed_Replicated_Block_Device) for the Linuxplatform. It is implemented as a kernel driver, several  userspace management applications, and some shell scripts. DRBD is  traditionally used in high availability (HA) clusters.
  DRBD—分布式复制块设备，DRBD是Linux平台上的分布式复制存储系统。它被实现为一个内核驱动程序、几个用户空间管理应用程序和一些shell脚本。DRBD传统上用于高可用性（HA）集群。
- **DLM** - A distributed lock manager (DLM) runs in every machine in a cluster,  with an identical copy of a cluster-wide lock database. In this way    DLM provides software applications which are distributed across a  cluster on multiple machines with a means to synchronize their accesses  to shared resources.
  分布式锁管理器（DLM）运行在集群中的每台机器上，具有集群范围的锁数据库的相同副本。通过这种方式，DLM为跨集群分布在多台机器上的软件应用程序提供了一种同步它们对共享资源的访问的方法。
- **gfs2-utils** - Global File System 2 - filesystem tools. The Global File System  allows a cluster of machines to concurrently access shared storage  hardware like SANs or iSCSI and network block devices.
  gfs 2-utils -全局文件系统2 -文件系统工具。全局文件系统允许一个机器集群并发访问共享存储硬件，如SAN或iSCSI和网络块设备。
- **Keepalived** - Keepalived provides simple and robust facilities for loadbalancing  and high-availability to Linux system and Linux based infrastructures.  Loadbalancing framework relies on well-known and widely used [Linux Virtual Server (IPVS)](http://www.linux-vs.org/) kernel module providing Layer4 loadbalancing. Keepalived implements a  set of checkers to dynamically and adaptively maintain and manage  loadbalanced server pool according their health. On the other hand  high-availability is achieved by [VRRP](http://datatracker.ietf.org/wg/vrrp/) protocol.
  Keepalived -  Keepalived为Linux系统和基于Linux的基础架构提供简单而强大的负载平衡和高可用性工具。负载平衡框架依赖于众所周知的和广泛使用的Linux虚拟服务器（IPVS）内核模块提供第4层负载平衡。Keepalived实现了一组检查器，以根据其健康状况动态和自适应地维护和管理负载平衡的服务器池。另一方面，高可用性是通过VRRP协议来实现的。

### Ubuntu HA Community Packages Ubuntu HA社区包 

Packages in this list are supported just like any other package available in  **[universe] repository**  would be.
此列表中的包与[universe] repository中可用的任何其他包一样受支持。

| Package          | URL                                                          |
| ---------------- | ------------------------------------------------------------ |
| pcs*             | [Ubuntu](https://launchpad.net/ubuntu/+source/libqb) \| [Upstream](https://github.com/ClusterLabs/pcs) Ubuntu\|上游 |
| csync2           | [Ubuntu](https://launchpad.net/ubuntu/+source/csync2) \| [Upstream](https://github.com/LINBIT/csync2) Ubuntu\|上游 |
| corosync-qdevice | [Ubuntu](https://launchpad.net/ubuntu/+source/corosync-qdevice) \| [Upstream](https://github.com/corosync/corosync-qdevice) Ubuntu\|上游 |
| fence-virt       | [Ubuntu](https://launchpad.net/ubuntu/+source/fence-virt) \| [Upstream](https://github.com/ClusterLabs/fence-virt) Ubuntu\|上游 |
| sbd              | [Ubuntu](https://launchpad.net/ubuntu/+source/sbd) \| [Upstream](https://github.com/ClusterLabs/sbd) Ubuntu\|上游 |
| booth            | [Ubuntu](https://launchpad.net/ubuntu/+source/booth) \| [Upstream](https://github.com/ClusterLabs/booth) Ubuntu\|上游 |

- **Corosync-Qdevice** - Its primary use is for even-node clusters, operates at corosync  (quorum) layer. Corosync-Qdevice is an independent arbiter for solving  split-brain situations. (qdevice-net supports multiple algorithms).
  Corosync-Qdevice -主要用于偶数节点群集，在corosync（quorum）层运行。Corosync-Qdevice是解决裂脑情况的独立仲裁器。（qdevice-net支持多种算法）。
- **SBD** - A Fencing Block Device can be particularly useful in environments  where traditional fencing mechanisms are not possible. SBD integrates  with Pacemaker, a watchdog device and shared storage to arrange for  nodes to reliably self-terminate when  fencing is required.
  SBD -一个围栏块设备可以特别有用的环境中，传统的围栏机制是不可能的。SBD与Pacemaker、看门狗设备和共享存储集成，以安排节点在需要屏蔽时可靠地自终止。

> Note: **pcs** was added to the [main] repository in Ubuntu Lunar Lobster (23.04).
> 注意：pcs被添加到Ubuntu Lunar Lobster（23.04）的[main]存储库中。

### Ubuntu HA Deprecated Packages Ubuntu HA弃用的软件包 

Packages in this list are  **only supported by the upstream community** . All bugs opened against these agents will be forwarded to upstream IF makes sense (affected version is close to upstream).
此列表中的软件包仅受上游社区支持。所有针对这些代理打开的错误将被转发到上游（如果有意义）（受影响的版本接近上游）。

| Package     | URL                                                          |
| ----------- | ------------------------------------------------------------ |
| ocfs2-tools | [Ubuntu](https://launchpad.net/ubuntu/+source/ocfs2-tools) \| [Upstream](https://github.com/markfasheh/ocfs2-tools) Ubuntu\|上游 |

### Ubuntu HA Related Packages  Ubuntu HA相关软件包 

Packages in this list aren’t necessarily **HA** related packages, but they have a very important role in High  Availability Clusters and are supported like any other package provide  by the **[main]** repository.
此列表中的软件包不一定是HA相关的软件包，但它们在High Availability Clusters中具有非常重要的作用，并且与[main]存储库提供的任何其他软件包一样受到支持。

| Package                                 | URL                                                          |
| --------------------------------------- | ------------------------------------------------------------ |
| multipath-tools                         | [Ubuntu](https://launchpad.net/ubuntu/+source/multipath-tools) \| [Upstream](https://github.com/opensvc/multipath-tools) Ubuntu\|上游 |
| open-iscsi                              | [Ubuntu](https://launchpad.net/ubuntu/+source/open-iscsi) \| [Upstream](https://github.com/open-iscsi/open-iscsi) Ubuntu\|上游 |
| sg3-utils                               | [Ubuntu](https://launchpad.net/ubuntu/+source/sg3-utils) \| [Upstream](http://sg.danny.cz/sg/sg3_utils.html) Ubuntu\|上游 |
| tgt OR targetcli-fb* tgt或targetcli-fb* | [Ubuntu](https://launchpad.net/ubuntu/+source/tgt) \| [Upstream](https://github.com/fujita/tgt) Ubuntu\|上游 |
| lvm2                                    | [Ubuntu](https://launchpad.net/ubuntu/+source/lvm2) \| [Upstream](https://sourceware.org/lvm2/) Ubuntu\|上游 |

- LVM2

   in a Shared-Storage Cluster Scenario:

  
  共享存储群集方案中的LVM 2：

  CLVM

   \- supported before 

  Ubuntu 20.04

  
  CLVM -Ubuntu 20.04之前支持

  A distributed lock manager (DLM) is used to broker concurrent LVM  metadata accesses. Whenever a cluster node needs to modify the LVM  metadata, it must secure permission from its local  

  ```
  clvmd
  ```

   , which is in constant contact with other  

  ```
  clvmd
  ```

    daemons in the cluster and can communicate a desire to get a lock on a particular set of objects.

  
   分布式锁管理器（DLM）用于代理并发的LVM元数据访问。每当集群节点需要修改LVM元数据时，它必须从其本地 `clvmd` 获得权限，该本地 `clvmd` 与集群中的其他 `clvmd` 守护进程保持联系，并且可以传达获得特定对象集上的锁的期望。

  [lvmlockd](http://manpages.ubuntu.com/manpages/focal/man8/lvmlockd.8.html)

   \- supported after 

  Ubuntu 20.04

  
   lvmlockd -Ubuntu 20.04之后受支持

  As of 2017, a stable LVM component that is designed to replace  

  ```
  clvmd
  ```

    by making the locking of LVM objects transparent to the rest of LVM, without relying on a distributed lock manager.

  
   截至2017年，一个稳定的LVM组件，旨在通过使LVM对象的锁定对LVM的其余部分透明来取代 `clvmd` ，而不依赖于分布式锁管理器。

  The lvmlockd benefits over clvm are:

  
   lvmlockd相对于clvm的优势是：

  - lvmlockd supports two cluster locking plugins: DLM and SANLOCK. SANLOCK plugin  can supports up to ~2000 nodes that benefits LVM usage in big  virtualization / storage cluster, while DLM plugin fits HA cluster.
    lvmlockd支持两个集群锁定插件：DLM和SANLOCK。SAN插件可以支持多达2000个节点，有利于大型虚拟化/存储集群中的LVM使用，而DLM插件适合HA集群。 
  - lvmlockd has better design than clvmd. clvmd is command-line level based locking system, which means the whole LVM software will get hang if any LVM  command gets dead-locking issue.
    lvmlockd的设计比clvmd好。clvmd是基于命令行级别的锁定系统，这意味着如果任何一个LVM命令出现死锁问题，整个LVM软件都会挂起。 
  - lvmlockd can work with lvmetad.
    lvmlockd可以与lvmetad一起使用。 

> Note: **targetcli-fb (Linux LIO)** will likely replace **tgt** in future Ubuntu versions.
> 注意：targetcli-fb（Linux LIO）可能会在未来的Ubuntu版本中取代tgt。

## Upstream Documentation 上游文件 

The server guide does not have the intent to document every existing option for all the HA related softwares described in this page, but to  document recommended scenarios for Ubuntu HA Clusters. You will find  more complete documentation upstream at:
服务器指南并不打算记录本页面中描述的所有HA相关软件的每个现有选项，而是记录Ubuntu HA集群的推荐方案。您可以在上游找到更完整的文档： 

- ClusterLabs

   公司简介 

  - [Clusters From Scratch 从零开始的集群](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Clusters_from_Scratch/index.html)
  - [Managing Pacemaker Clusters
     管理起搏器群集](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Administration/index.html)
  - [Pacemaker Configuration Explained
     起搏器配置说明](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Explained/index.html)
  - [Pacemaker Remote - Scaling HA Clusters
     Pacemaker Remote -扩展HA群集](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Remote/index.html)

- Other

   其他 

  - [Ubuntu Bionic HA in Shared Disk Environments (Azure)
     共享磁盘环境中的Ubuntu Bionic HA（Azure）](https://discourse.ubuntu.com/t/ubuntu-high-availability-corosync-pacemaker-shared-disk-environments/14874)

> A very special thanks, and all the credits, to [ClusterLabs Project](https://clusterlabs.org/) for all that detailed documentation.
> 非常特别的感谢，以及所有的学分，对所有详细的文档，QuerterLabs项目。

------



# Introduction to device mapper multipathing 设备映射程序多路径简介 

Device mapper multipathing (which we will refer to as **multipath**) allows you to configure multiple input/output (I/O) paths between  server nodes and storage arrays into a single device. These I/O paths  are physical storage area network (SAN) connections that can include  separate cables, switches, and controllers.
设备映射器多路径（我们将其称为多路径）允许您将服务器节点和存储阵列之间的多个输入/输出（I/O）路径配置到单个设备中。这些I/O路径是物理存储区域网络（SAN）连接，可以包括单独的电缆、交换机和控制器。

Multipathing aggregates the I/O paths, creating a new device that consists of those  aggregated paths. This page provides an introduction and a high-level  overview of multipath.
多路径聚合I/O路径，创建由这些聚合路径组成的新设备。本页提供多路径的介绍和高级概述。 

## Benefits of multipath 多路径的好处 

Multipath can be used to provide:
多路径可用于提供： 

- **Redundancy 冗余**
   Multipath provides failover in an active/passive configuration. In an  active/passive configuration, only half the paths are used at any time  for I/O. If any element of an I/O path (the cable, switch, or  controller) fails, multipath switches to an alternate path.
   多路径在主动/被动配置中提供故障切换。在主动/被动配置中，任何时候只有一半的路径用于I/O。如果I/O路径的任何元素（电缆、交换机或控制器）出现故障，多路径将切换到备用路径。
- **Improved performance 改进的性能**
   Multipath can be configured in active/active mode, where I/O is spread  over the paths in a round-robin fashion. In some configurations,  multipath can detect loading on the I/O paths and dynamically re-balance the load.
   多路径可以配置为主动/主动模式，其中I/O以循环方式分布在路径上。在某些配置中，多路径可以检测I/O路径上的负载并动态地重新平衡负载。

## Storage array overview 存储阵列概述 

It is a good idea to consult your storage vendor’s installation guide for  the recommended multipath configuration variables for your storage  model. The default configuration will probably work but will likely need adjustments based on your storage setup.
最好查阅存储供应商的安装指南，以了解为您的存储模型推荐的多路径配置变量。默认配置可能会起作用，但可能需要根据您的存储设置进行调整。 

## Multipath components 多径分量 

| Component                                            | Description                                                  |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| `dm_multipath` kernel module `dm_multipath` 内核模块 | Reroutes I/O and supports **failover** for paths and path groups. 重新路由I/O并支持路径和路径组的故障切换。 |
| `multipath command`                                  | Lists and configures multipath devices. Normally started up with `/etc/rc.sysinit`, it can also be started up by a `udev` program whenever a block device is added, or it can be run by the `initramfs` file system. 列出并配置多路径设备。通常使用 `/etc/rc.sysinit` 启动，也可以在添加块设备时由 `udev` 程序启动，或者由 `initramfs` 文件系统运行。 |
| `multipathd` daemon `multipathd` 守护进程            | Monitors paths; as paths fail and come back, it may initiate path group  switches. Provides for interactive changes to multipath devices. This  daemon must be restarted for any changes to the `/etc/multipath.conf` file to take effect. 中断路径;当路径出现故障并恢复时，它可能会启动路径组切换。提供对多路径设备的交互式更改。要使对 `/etc/multipath.conf` 文件的任何更改生效，必须重新启动此守护程序。 |
| `kpartx` command `kpartx` 命令                       | Creates device-mapper devices for the partitions on a device. It is necessary  to use this command for DOS-based partitions with multipath. The `kpartx` is provided in its own package, but the `multipath-tools` package depends on it. 为设备上的分区创建设备映射程序设备。对于具有多路径的基于DOS的分区，必须使用此命令。 `kpartx` 在它自己的包中提供，但 `multipath-tools` 包依赖于它。 |

## Multipath setup overview  多路径设置概述 

Setting up multipath is often a simple procedure, since it includes compiled-in default settings that are suitable for common multipath configurations. The basic procedure for configuring your system with multipath is as  follows:
设置多路径通常是一个简单的过程，因为它包括编译的默认设置，适用于常见的多路径配置。使用多路径配置系统的基本步骤如下： 

1. Install the `multipath-tools` and `multipath-tools-boot` packages
   安装 `multipath-tools` 和 `multipath-tools-boot` 包
2. Create an empty config file called `/etc/multipath.conf`
   创建一个名为 `/etc/multipath.conf` 的空配置文件
3. Edit the `multipath.conf` file to modify default values and save the updated file
   编辑 `multipath.conf` 文件以修改默认值并保存更新后的文件
4. Start the multipath daemon
   启动多路径守护进程 
5. Update initial RAM disk
   更新初始RAM磁盘 

For detailed setup instructions for multipath configuration see [DM-Multipath configuration](https://ubuntu.com/server/docs/configuring-device-mapper-multipathing) and [DM-Multipath setup](https://ubuntu.com/server/docs/multipath-configuration-examples).
有关多路径配置的详细设置说明，请参阅DM-多路径配置和DM-多路径设置。

## Multipath devices 多路径设备 

Without multipath, each path from a server node to a storage controller is  treated by the system as a separate device, even when the I/O path  connects the same server node to the same storage controller. Multipath  provides a way of organizing the I/O paths logically, by creating a  single device on top of the underlying paths.
在没有多路径的情况下，从服务器节点到存储控制器的每条路径被系统视为单独的设备，即使当I/O路径将相同的服务器节点连接到相同的存储控制器时也是如此。多路径提供了一种逻辑组织I/O路径的方法，方法是在底层路径之上创建单个设备。 

### Multipath device identifiers 多路径设备标识符 

Each multipath device has a World Wide Identifier (WWID), which is  guaranteed to be globally unique and unchanging. By default, the name of a multipath device is set to its WWID. Alternatively, you can set the `user_friendly_names` option in `multipath.conf`, which causes multipath to use a **node-unique alias** of the form `mpathn` as the name.
每个多路径设备都有一个全球标识符（WWID），它保证是全球唯一的和不变的。默认情况下，多路径设备的名称设置为其WWID。或者，您可以在 `multipath.conf` 中设置 `user_friendly_names` 选项，这将导致多路径使用 `mpathn` 形式的节点唯一别名作为名称。

For example, a node with two host bus adapters (HBAs) attached to a storage controller, with two ports, via a single un-zoned FC switch sees four  devices:  `/dev/sda`, `/dev/sdb`, `/dev/sdc`, and `/dev/sdd`. Multipath creates a single device with a unique WWID that reroutes I/O  to those four underlying devices according to the multipath  configuration.
例如，通过单个未分区的FC交换机将两个主机总线适配器（Host Bus Adapter，NIC）连接到具有两个端口的存储控制器的节点可以看到四个设备： `/dev/sda` 、 `/dev/sdb` 、 `/dev/sdc` 和 `/dev/sdd` 。多路径创建一个具有唯一WWID的设备，该设备根据多路径配置将I/O重新路由到这四个基础设备。

When the `user_friendly_names` configuration option is set to ‘yes’, the name of the multipath device is set to `mpathn`. When new devices are brought under the control of multipath, the new devices may be seen in two different places under the `/dev` directory: `/dev/mapper/mpathn` and `/dev/dm-n`.
当 `user_friendly_names` 配置选项设置为“yes”时，多路径设备的名称将设置为 `mpathn` 。当新设备被置于多路径的控制下时，新设备可以在 `/dev` 目录下的两个不同的地方看到： `/dev/mapper/mpathn` 和 `/dev/dm-n` 。

- The devices in `/dev/mapper` are created early in the boot process. **Use these devices to access the multipathed devices.**
   `/dev/mapper` 中的设备是在靴子过程的早期创建的。使用这些设备访问多路径设备。
- Any devices of the form `/dev/dm-n` are for **internal use only** and should never be used directly.
  表 `/dev/dm-n` 的任何器械仅供内部使用，不得直接使用。

You can also set the name of a multipath device to a name of your choosing by using the `alias` option in the `multipaths` section of the multipath configuration file.
您还可以使用多路径配置文件 `multipaths` 部分中的 `alias` 选项将多路径设备的名称设置为您选择的名称。

> **See also**: 另请参阅：
>  For information on the multipath configuration defaults, including the `user_friendly_names` and `alias` configuration options, see [DM-Multipath configuration](https://ubuntu.com/server/docs/configuring-device-mapper-multipathing).
>  有关多路径配置默认值（包括 `user_friendly_names` 和 `alias` 配置选项）的信息，请参见DM-多路径配置。

### Consistent multipath device names in a cluster 群集中一致的多路径设备名称 

When the `user_friendly_names` configuration option is set to ‘yes’, the name of the multipath device  is unique to a node, but it is not guaranteed to be the same on all  nodes using the multipath device. Similarly, if you set the `alias` option for a device in the `multipaths` section of `/etc/multipath.conf`, the name is not automatically consistent across all nodes in the cluster.
当 `user_friendly_names` 配置选项设置为“yes”时，多路径设备的名称对于节点是唯一的，但不能保证在使用多路径设备的所有节点上都相同。同样，如果在 `/etc/multipath.conf` 的 `multipaths` 部分中为设备设置了 `alias` 选项，则群集中所有节点的名称不会自动保持一致。

This should not cause any difficulties if you [use LVM](https://ubuntu.com/server/docs/how-to-manage-logical-volumes) to create logical devices from the multipath device, but if you require that your multipath device names be consistent in every node it is  recommended that you leave the `user_friendly_names` option set to ‘no’ and that you **do not** configure aliases for the devices.
如果您使用LVM从多路径设备创建逻辑设备，这应该不会造成任何困难，但如果您要求多路径设备名称在每个节点中保持一致，建议您将 `user_friendly_names` 选项设置为“no”，并且不为设备配置别名。

If you configure an alias for a device that you would like to be  consistent across the nodes in the cluster, you should ensure that the `/etc/multipath.conf` file is the same for each node in the cluster by following the same procedure:
如果要为设备配置一个别名，并且希望该别名在群集中的节点之间保持一致，则应遵循相同的过程，确保 `/etc/multipath.conf` 文件对于群集中的每个节点都相同：

1. Configure the aliases for the multipath devices in the in the `multipath.conf` file on one machine.
   在一台计算机上的 `multipath.conf` 文件中配置多路径设备的别名。

2. Disable all of your multipath devices on your other machines by running the following commands as root:
   通过以root身份运行以下命令，禁用其他计算机上的所有多路径设备： 

   ```bash
   systemctl stop multipath-tools.service
   multipath -F
   ```

3. Copy the `/etc/multipath.conf` file from the first machine to all other machines in the cluster.
   将 `/etc/multipath.conf` 文件从第一台计算机复制到群集中的所有其他计算机。

4. Re-enable the `multipathd` daemon on all the other machines in the cluster by running the following command as root:
   通过以root身份运行以下命令，在群集中的所有其他计算机上重新启用 `multipathd` 守护程序：

   ```bash
   systemctl start multipath-tools.service
   ```

Whenever you add a new device you will need to repeat this process.
每当您添加新设备时，您都需要重复此过程。 

### Multipath device attributes 多路径设备属性 

In addition to the `user_friendly_names` and `alias` options, a multipath device has numerous attributes. You can modify  these attributes for a specific multipath device by creating an entry  for that device in the `multipaths` section of `/etc/multipath.conf`.
除了 `user_friendly_names` 和 `alias` 选项外，多路径设备还有许多属性。您可以通过在 `/etc/multipath.conf` 的 `multipaths` 部分中为特定多路径设备创建一个条目来修改该设备的这些属性。

For information on the `multipaths` section of the multipath configuration file, see [DM-Multipath configuration](https://ubuntu.com/server/docs/configuring-device-mapper-multipathing).
有关多路径配置文件的 `multipaths` 部分的信息，请参见DM-多路径配置。

### Multipath devices in logical volumes 逻辑卷中的多路径设备 

After creating multipath devices, you can use the multipath device names just as you would use a physical device name when creating an LVM physical  volume.
创建多路径设备之后，您可以使用多路径设备名称，就像在创建LVM物理卷时使用物理设备名称一样。 

For example, if `/dev/mapper/mpatha` is the name of a multipath device, the following command (run as root) will mark `/dev/mapper/mpatha` as a physical volume:
例如，如果 `/dev/mapper/mpatha` 是多路径设备的名称，则以下命令（以root身份运行）将 `/dev/mapper/mpatha` 标记为物理卷：

```bash
pvcreate /dev/mapper/mpatha
```

You can use the resulting LVM physical device when you create an LVM volume group just as you would use any other LVM physical device.
在创建LVM卷组时，可以像使用任何其他LVM物理设备一样使用生成的LVM物理设备。 

> **Note**: 注意：
>  If you try to create an LVM physical volume on a whole device on which you have configured partitions, the `pvcreate` command will fail.
>  如果您尝试在已配置分区的整个设备上创建一个LVM物理卷，则 `pvcreate` 命令将失败。

When you create an LVM logical volume that uses active/passive multipath  arrays as the underlying physical devices, you should include filters in the `lvm.conf` file to exclude the disks that underlie the multipath devices. This is  because if the array automatically changes the active path to the  passive path when it receives I/O, multipath will failover and fallback  whenever LVM scans the passive path if these devices are not filtered.
当您创建一个使用主动/被动多路径阵列作为底层物理设备的LVM逻辑卷时，您应该在 `lvm.conf` 文件中包括筛选器，以排除多路径设备底层的磁盘。这是因为，如果阵列在接收I/O时自动将主动路径更改为被动路径，则在未过滤这些设备的情况下，每当LVM扫描被动路径时，多路径将进行故障转移和回退。

For active/passive arrays that require a command to make the passive path  active, LVM prints a warning message when this occurs. To filter all  SCSI devices in the LVM configuration file (`lvm.conf`), include the following filter in the devices section of the file:
对于需要命令使被动路径成为活动路径的主动/被动阵列，当发生这种情况时，LVM将打印警告消息。要过滤LVM配置文件（ `lvm.conf` ）中的所有SCSI设备，请在文件的devices部分中包含以下过滤器：

```plaintext
filter = [ "r/block/", "r/disk/", "r/sd.*/", "a/.*/" ]
```

After updating `/etc/lvm.conf`, it’s necessary to update the `initrd` so that this file will be copied there, where the filter matters the most – during boot. Perform:
在更新了 `/etc/lvm.conf` 之后，有必要更新 `initrd` ，以便将此文件复制到那里，在那里过滤器最重要-在靴子期间。执行：

```bash
update-initramfs -u -k all
```

> **Note**: 注意：
>  Every time either `/etc/lvm.conf` or `/etc/multipath.conf` is updated, the `initrd` should be rebuilt to reflect these changes. This is imperative when **denylists** and filters are necessary to maintain a stable storage configuration.
>  每次更新 `/etc/lvm.conf` 或 `/etc/multipath.conf` 时，都应重新构建 `initrd` 以反映这些更改。当需要拒绝列表和过滤器来维护稳定的存储配置时，这是必不可少的。

------

# Introduction to backups 备份简介 

There are many ways to back up an Ubuntu installation. The most important  thing about backups is to develop a backup plan that consists of:
有很多方法可以备份Ubuntu安装。关于备份，最重要的是制定一个备份计划，其中包括： 

- What should be backed up
  应该备份什么 
- How often to back it up
  多久备份一次 
- Where backups should be stored
  备份应存储在何处 
- How to restore your backups
  如何恢复备份 

It is good practice to take backup media off-site in case of a disaster.  For backup plans involving physical tape or removable hard drives, the  tapes or drives can be manually taken off-site. However, in other cases  this may not be practical and the archives will need to be copied over a WAN link to a server in another location.
在发生灾难时，最好将备份介质带离现场。对于涉及物理磁带或可移动硬盘驱动器的备份计划，可以手动将磁带或驱动器带离现场。但是，在其他情况下，这可能不切实际，需要通过WAN链路将存档复制到另一个位置的服务器。 

## Backup options 备份选项 

On Ubuntu, two of the primary ways of backing up your system are through **backup utilities** and **shell scripts**. Wherever possible, it’s better to build redundancy into your backup  systems by combining backup methods so that you are not reliant on a  single system.
在Ubuntu上，备份系统的两种主要方法是通过备份实用程序和shell脚本。只要有可能，最好通过组合备份方法在备份系统中构建冗余，这样您就不会依赖于单个系统。

### Backup utilities 备份实用程序 

The most straightforward way to create backups is through using a dedicated tool like [Bacula](http://www.bacula.org/) or [rsnapshot](https://rsnapshot.org/). These tools offer specialised features such as automation, compression, data recovery, encryption and incremental/differential backups – but  with an easy-to-use interface or CLI to help simplify the backup  management process.
创建备份最直接的方法是使用专用工具，如Bacula或rsnapshot。这些工具提供自动化、压缩、数据恢复、加密和增量/差异备份等专业功能，但具有易于使用的界面或CLI，可帮助简化备份管理过程。

- **Bacula**
   This tool uses incremental backups, which only store changes made since  the last backup. This can significantly decrease the storage space and  backup time required. It can also manage backups of multiple systems  over a network. With more advanced features and support for additional  customisation, it is often used by users with more complex needs (e.g.  in enterprise environments).
   此工具使用增量备份，仅存储自上次备份以来所做的更改。这可以显著减少所需的存储空间和备份时间。它还可以通过网络管理多个系统的备份。它具有更高级的功能和对额外定制的支持，通常被具有更复杂需求的用户使用（例如在企业环境中）。
  - Find out [how to install and configure Bacula](https://ubuntu.com/server/docs/how-to-install-and-configure-bacula).
    了解如何安装和配置Bacula。
- **rsnapshot** uses rsync to take periodic “snapshots” of your files, which makes it  easier to access previous versions. It’s often used for local backups on a single system and is ideal for individual users or small-scale  organisations who want a simpler and more efficient solution.
  rsnapshot使用rsync定期为您的文件创建“快照”，这使得访问以前的版本更加容易。它通常用于在单个系统上进行本地备份，是想要更简单、更高效解决方案的个人用户或小型组织的理想选择。
  - Find out [how to install and configure rsnapshot](https://ubuntu.com/server/docs/how-to-install-and-configure-rsnapshot).
    了解如何安装和配置rsnapshot。

### Shell scripts Shell脚本 

Using shell scripts to manage your backups can be easy or complicated,  depending on the complexity of your setup. However, the advantage of  shell scripts over using backup utilities, is that they offer full  flexibility and customisation. Through backup shell scripts, you can  fully tailor the backup process to your specific requirements without  using third-party tools.
使用shell脚本来管理备份可能很简单，也可能很复杂，这取决于设置的复杂性。然而，shell脚本相对于使用备份实用程序的优势在于，它们提供了完全的灵活性和自定义性。通过备份shell脚本，您可以完全定制备份过程以满足您的特定要求，而无需使用第三方工具。 

Refer to this guide for instructions on [how to use shell scripts for backups](https://ubuntu.com/server/docs/how-to-back-up-using-shell-scripts) – or you can take a look at our reference examples:
有关如何使用shell脚本进行备份的说明，请参阅本指南-或者您可以查看我们的参考示例：

- [A basic backup shell script
   一个基本的备份shell脚本](https://ubuntu.com/server/docs/basic-backup-shell-script)
- [An example of archive rotation with shell scripts
   使用shell脚本的归档旋转示例](https://ubuntu.com/server/docs/archive-rotation-shell-script)

------



# VM tools in the Ubuntu space Ubuntu空间中的VM工具 

Let’s take a look at some of the major tools and technologies available in  the Ubuntu virtualization stack, in order of increasing abstraction.
让我们来看看Ubuntu虚拟化堆栈中可用的一些主要工具和技术，以增加抽象的顺序。 

### KVM

**Abstraction layer**: Hardware virtualization
抽象层：硬件虚拟化

[Kernel-Based Virtual Machine (KVM)](https://www.linux-kvm.org/page/Main_Page) is a Linux kernel module that enables hardware-assisted virtualization. It is the default virtualization technology supported by Ubuntu.
 Kernel-Based Virtual Machine（KVM）是一个Linux内核模块，支持硬件辅助的虚拟化。它是Ubuntu支持的默认虚拟化技术。

For Intel and AMD hardware, KVM requires virtualization extensions in order to run. KVM is also available for IBM Z and LinuxONE, IBM POWER, and  ARM64.
对于Intel和AMD硬件，KVM需要虚拟化扩展才能运行。KVM也可用于IBM Z和LinuxONE、IBM POWER和ARM 64。 

## QEMU

**Abstraction layer**: Emulation
抽象层：仿真

[Quick Emulator (QEMU)](https://www.qemu.org/) is a versatile and powerful open source machine emulator. It emulates  complete virtual machines, which allows users to run machines with  different operating systems than the underlying host system – without  needing to purchase dedicated hardware.
 Quick Emulator（QEMU）是一个多功能且功能强大的开源机器仿真器。它模拟完整的虚拟机，允许用户运行与底层主机系统不同的操作系统的机器，而无需购买专用硬件。

QEMU primarily functions as the user-space backend for KVM. When used in  collaboration with KVM kernel components, it harnesses the hardware  virtualization capability that KVM provides in order to efficiently  virtualize guests.
QEMU主要用作KVM的用户空间后端。当与KVM内核组件协作使用时，它利用KVM提供的硬件虚拟化功能来有效地虚拟化客户机。 

It also has a [command line interface](https://qemu-project.gitlab.io/qemu/system/invocation.html) and [a monitor](https://qemu-project.gitlab.io/qemu/system/monitor.html) for interacting with running guests. However, these are typically only used for development purposes.
它还有一个命令行界面和一个监视器，用于与正在运行的客户机进行交互。然而，这些通常仅用于开发目的。

To find out how to get started with QEMU quickly, check out this guide on [how to set up QEMU](https://ubuntu.com/server/docs/virtualisation-with-qemu).
要了解如何快速开始使用QEMU，请查看如何设置QEMU的指南。

## libvirt

**Abstraction layer**: API and toolkit
抽象层：API和工具包

[libvirt](https://libvirt.org/) provides an abstraction layer away from specific versions and  hypervisors, giving users a command-line toolkit and API for managing  virtualizations.
 libvirt提供了一个脱离特定版本和虚拟机管理程序的抽象层，为用户提供了用于管理虚拟化的命令行工具包和API。

By providing an abstraction away from the underlying technologies (such as QEMU/KVM), libvirt makes it possible to manage all kinds of virtual  resources – across different platforms and hypervisors – using one  single, common interface. This can greatly simplify administration and  automation tasks.
通过提供脱离底层技术（如QEMU/KVM）的抽象，libvirt可以使用一个单一的公共接口跨不同的平台和管理程序管理各种虚拟资源。这可以大大简化管理和自动化任务。 

For details of how to get libvirt set up and the basics of how to use it, see this guide on [how to use libvirt](https://ubuntu.com/server/docs/libvirt).
有关如何设置libvirt以及如何使用它的基础知识的详细信息，请参阅如何使用libvirt的指南。

## Multipass and UVtool Multipass和UVtool

**Abstraction layer**: User-friendly, CLI-based VM management
抽象层：用户友好的基于CLI的VM管理

[Multipass](https://multipass.run/install) and [UVtool](https://launchpad.net/uvtool) provide an abstraction layer away from libvirt, using command-line  interfaces to simplify VM management. Both Multipass and UVtool are  widely used in development and testing; they are lightweight and  straightforward to use, and can greatly simplify the process of creating and managing VMs.
 Multipass和UVtool提供了一个远离libvirt的抽象层，使用命令行界面来简化VM管理。Multipass和UVtool都广泛用于开发和测试;它们是轻量级的，使用简单，可以大大简化创建和管理VM的过程。

UVtool is essentially a wrapper around libvirt, providing an additional  abstraction layer to simplify its use. Multipass is not based on  libvirt, but can be integrated with it. This means that both tools can  be used as part of a virtualization “stack” based around QEMU and  libvirt.
UVtool本质上是libvirt的包装器，提供了一个额外的抽象层来简化其使用。Multipass并不基于libvirt，但可以与之集成，这意味着这两个工具都可以作为基于QEMU和libvirt的虚拟化“堆栈”的一部分使用。 

If you want to get started with either of these tools, you can see our guides on [how to use Multipass](https://ubuntu.com/server/docs/how-to-create-a-vm-with-multipass) or [how to use UVtool](https://ubuntu.com/server/docs/create-cloud-image-vms-with-uvtool).
如果您想开始使用这些工具中的任何一个，您可以查看我们关于如何使用Multipass或如何使用UVtool的指南。

## virt-manager

**Abstraction layer**: GUI-based VM management
抽象层：基于GUI的虚拟机管理

[Virt-manager](https://virt-manager.org/), the Virtual Machine Manager, provides another high-level way to manage  VMs. Like UVtool, virt-manager uses libvirt on the backend. However,  unlike UVtool, its abstraction is presented in the form of a graphical  user interface (GUI).
 Virt-manager，即虚拟机管理器，提供了另一种管理虚拟机的高级方法。与UVtool一样，virt-manager在后端使用libvirt。然而，与UVtool不同，它的抽象是以图形用户界面（GUI）的形式呈现的。

Although in many ways this makes virt-manager easier to use than Multipass and  UVtool, it also introduces more complex tooling that supports more  advanced users.
虽然在许多方面，这使得virt-manager比Multipass和UVtool更容易使用，但它也引入了更复杂的工具来支持更高级的用户。 

To get started with virt-manager, [this how-to guide](https://ubuntu.com/server/docs/virtual-machine-manager) showcases all the basic functionality and tooling.
要开始使用virt-manager，本指南展示了所有基本功能和工具。

# Using QEMU for microVMs 将QEMU用于microVM 

MicroVMs are a special case of virtual machines (VMs), which were designed to be used in a container-like way to provide better isolation than  containers, but which are optimised for initialisation speed and minimal resource use.
MicroVM是虚拟机（VM）的一种特殊情况，它被设计成以类似容器的方式使用，以提供比容器更好的隔离，但它针对初始化速度和最小的资源使用进行了优化。 

Because they are so lightweight, they are particularly useful in dynamic  workload situations where demands change rapidly and new resources need  to be quickly provisioned or de-provisioned to meet those demands.
由于它们非常轻量级，因此在需求快速变化且需要快速调配或取消调配新资源以满足这些需求的动态工作负载情况下，它们特别有用。 

They are also useful in situations where resources are limited (e.g. in IoT  devices), or where the cost of using resources is a factor, thanks to  their small footprint and overall efficiency.
它们在资源有限的情况下也很有用（例如在物联网设备中），或者使用资源的成本是一个因素，这要归功于它们的占地面积小和整体效率。 

## QEMU microVMs QEMU微虚拟机

QEMU provides additional components that were added to support this special use case:
QEMU提供了额外的组件来支持这个特殊的用例： 

1. The [`microvm` machine type](https://www.qemu.org/docs/master/system/i386/microvm.html) `microvm` 机型
2. Alternative simple firmware (FW) that can boot linux [called `qboot`](https://github.com/bonzini/qboot)
   替代简单固件（FW），可以靴子Linux称为 `qboot` 
3. QEMU build with reduced features matching these use cases called `qemu-system-x86-microvm` (we will call this “minimised `qemu`”)
   QEMU构建，减少了与这些用例匹配的特性，称为 `qemu-system-x86-microvm` （我们称之为“最小化的 `qemu` “）

## Basic command 基本命令

As an example, if you happen to already have a stripped-down workload that has all it would execute contained in an initrd, you might run it like  this:
举个例子，如果你碰巧已经有了一个精简的工作负载，它的所有执行都包含在一个initrd中，你可以这样运行它： 

```auto
sudo qemu-system-x86_64 \
 -M ubuntu-q35 \
 -cpu host \
 -m 1024 \
 -enable-kvm \
 -serial mon:stdio \
 -nographic \
 -display curses \
 -append 'console=ttyS0,115200,8n1' \
 -kernel vmlinuz-5.4.0-21 \
 -initrd /boot/initrd.img-5.4.0-21-workload
```

### The `microvm` case `microvm` 案例

To run the same basic command with `microvm` you would run it with with type `microvm`, so we change `-M` to `-M microvm`.
要使用 `microvm` 运行相同的基本命令，您可以使用类型 `microvm` 运行它，因此我们将 `-M` 更改为 `-M microvm` 。

Our command then becomes:
我们的命令是： 

```auto
sudo qemu-system-x86_64 \
 -M microvm ubuntu-q35 \
 -cpu host \
 -m 1024 \
 -enable-kvm \
 -serial mon:stdio \
 -nographic \
 -display curses \
 -append 'console=ttyS0,115200,8n1' \
 -kernel vmlinuz-5.4.0-21 \
 -initrd /boot/initrd.img-5.4.0-21-workload
```

### The `qboot` case `qboot` 案例

To run the basic command with `qboot` instead, we would use the `qboot bios` by adding `-bios /usr/share/qemu/bios-microvm.bin`.
要使用 `qboot` 来运行基本命令，我们将通过添加 `-bios /usr/share/qemu/bios-microvm.bin` 来使用 `qboot bios` 。

```auto
sudo qemu-system-x86_64 \
 -M ubuntu-q35 \
 -cpu host \
 -m 1024 \
 -enable-kvm \
 -serial mon:stdio \
 -nographic \
 -display curses \
 -append 'console=ttyS0,115200,8n1' \
 -kernel vmlinuz-5.4.0-21 \
 -initrd /boot/initrd.img-5.4.0-21-workload \
 -bios /usr/share/qemu/bios-microvm.bin
```

### The minimised `qemu` case 最小化的 `qemu` 情况

To run the the basic command instead using the minimised `qemu`, you would first need to install the feature-minimised `qemu-system` package, with:
要使用最小化的 `qemu` 运行基本命令，您首先需要安装功能最小化的 `qemu-system` 包，其中：

```bash
sudo apt install qemu-system-x86-microvm
```

Then, our basic command will look like this:
然后，我们的基本命令看起来像这样： 

```auto
sudo qemu-system-x86_64 \
 -M microvm \
 -bios /usr/share/qemu/bios-microvm.bin \
 -cpu host \
 -m 1024 \
 -enable-kvm \
 -serial mon:stdio \
 -nographic \
 -display curses \
 -append 'console=ttyS0,115200,8n1' \
 -kernel vmlinuz-5.4.0-21 \
 -initrd /boot/initrd.img-5.4.0-21-workload
```

This will cut down the `qemu`, `bios` and `virtual-hw` initialisation time a lot. You will now – more than you already were  before – spend the majority of time inside the guest, which implies that further tuning probably has to go into that kernel and user-space  initialisation time.
这将大大减少 `qemu` 、 `bios` 和 `virtual-hw` 的初始化时间。现在，您将比以前更多地将大部分时间花在客户机内部，这意味着进一步的调优可能必须进入内核和用户空间初始化时间。

## Further considerations 进一步考虑

For now, `microvm`, the `qboot` BIOS, and other components of this are rather new upstream and not  as  verified as many other parts of the virtualisation stack.
目前， `microvm` 、 `qboot` BIOS和其他组件都是相当新的上游组件，不像虚拟化堆栈的许多其他部分那样经过验证。

Therefore, none of the above options are the default. Being the default would mean many upgraders would regress upon finding a QEMU that doesn’t have most of the features they are accustomed to using.
因此，上述选项都不是默认选项。作为默认值，这意味着许多开发者在找到一个不具备他们习惯使用的大多数特性的QEMU时会倒退。 

Because of that the `qemu-system-x86-microvm` package (the minimised `qemu` option) is intentionally a strong opt-in that conflicts with the normal `qemu-system-x86` package.
因此， `qemu-system-x86-microvm` 包（最小化的 `qemu` 选项）是一个故意的强选择，与正常的 `qemu-system-x86` 包冲突。

# Upgrading the machine type of your VM 升级VM的计算机类型 

Upgrading the machine type of a virtual machine (VM) can be thought of in the  same way as buying (virtual) hardware of the same spec but with a newer  release date. Whereas to upgrade a physical machine you might buy an  improved CPU, more RAM, or increased storage, with a virtual machine you can change the configuration to achieve the same results.
升级虚拟机（VM）的机器类型可以被认为是购买相同规格的（虚拟）硬件，但具有更新的发布日期。如果要升级物理机，您可能会购买改进的CPU、更多的RAM或增加的存储，而对于虚拟机，您可以更改配置以实现相同的结果。 

## Why should you do this for a VM? 为什么要为VM这样做？

There are several reasons why you might want to update the machine type of an existing VM. For example, to:
您可能需要更新现有VM的计算机类型的原因有几个。例如： 

- Improve performance with additional computing power
  通过额外的计算能力提高性能 
- Add a virtual GPU
  添加虚拟GPU 
- Scale up the allocated resources to cope with increased workloads
  扩大分配的资源，以科普增加的工作量 
- Obtain the latest security fixes and features
  获取最新的安全修复程序和功能 
- Continue using a guest created on a now-unsupported release
  继续使用在现在不支持的版本上创建的来宾 
- Prepare for future expansion by upgrading in advance
  提前升级，为未来扩张做好准备 

## How does this work? 这是怎么回事？

It is generally recommended to update machine types when upgrading  QEMU/KVM to a new major version. However, this can likely never be an  automated task as the change is “guest visible”; the guest devices might change in appearance, new features will be announced to the guest, and  so on.
通常建议在升级QEMU/KVM到新的主版本时更新机器类型。然而，这可能永远不会是自动化的任务，因为更改是“访客可见的”;访客设备可能会在外观上发生更改，新功能将被通知给访客，等等。 

Linux is usually very good at tolerating such changes – but, it depends so  heavily on the setup and workload of the guest that this has to be  evaluated by the owner/admin of the system.
Linux通常非常善于容忍这样的更改-但是，它严重依赖于客户机的设置和工作负载，因此必须由系统的所有者/管理员进行评估。 

Other operating systems were known to often be severely impacted by changing  the hardware. Consider a machine type change as similar to replacing all devices and firmware of a physical machine to the latest revision. **All** of the considerations that apply to firmware upgrades apply to evaluating a machine type upgrade as well.
众所周知，其他操作系统经常会受到硬件变化的严重影响。将计算机类型更改视为类似于将物理机的所有设备和固件替换为最新版本。适用于固件升级的所有注意事项也适用于评估计算机类型升级。

## Backing up guest definitions 备份来宾定义

As usual, with major configuration changes it is wise to back up your  guest definition and disk state to be able to do a rollback – just in  case something goes wrong.
像往常一样，对于主要的配置更改，明智的做法是备份客户机定义和磁盘状态，以便能够进行回滚-以防出现错误。 

## Upgrade the machine type 升级机型

There is no integrated single command to update the machine type via `virsh` or similar tools. It is a normal part of your machine definition, and therefore updated the same way as most others.
没有通过 `virsh` 或类似工具更新机器类型的集成单一命令。它是您的计算机定义的正常部分，因此以与大多数其他定义相同的方式进行更新。

### Shut down the VM 关闭虚拟机

First shutdown your machine and wait until it has reached that state:
首先关闭你的机器，等待它达到这个状态： 

```auto
virsh shutdown <your_machine>
```

You can check the status of the machine with the following command:
您可以使用以下命令检查机器的状态： 

```auto
virsh list --inactive
```

### Edit the guest definition 编辑来宾定义

Once the machine is listed as “shut off”, you can then edit the machine definition and find the type in the `type` tag given at the machine attribute.
一旦机器被列为“关闭”，您就可以编辑机器定义，并在machine属性的 `type` 标记中找到类型。

```auto
virsh edit <your_machine>
<type arch='x86_64' machine='pc-i440fx-bionic'>hvm</type>
```

Change this to the value you want. If you need to check what machine types are available via the `kvm -M ?` command first, then note that while upstream types are provided for  convenience, only Ubuntu types are supported. There you can also see  what the current default would be, as in this example:
将其更改为您想要的值。如果您需要首先通过 `kvm -M ?` 命令检查哪些机器类型可用，请注意，虽然为了方便起见提供了上游类型，但仅支持Ubuntu类型。在那里，您还可以看到当前默认值是什么，如本例所示：

```auto
$ kvm -M ?
pc-i440fx-xenial       Ubuntu 16.04 PC (i440FX + PIIX, 1996) (default)
...
pc-i440fx-bionic       Ubuntu 18.04 PC (i440FX + PIIX, 1996) (default)
...
```

We strongly recommend that you change to newer types (if possible), not  only to take advantage of newer features, but also to benefit from bug  fixes that only apply to the newer device virtualisation.
我们强烈建议您更改为较新的类型（如果可能），不仅可以利用较新的功能，还可以从仅适用于较新设备虚拟化的错误修复中受益。 

### Restart the guest 重新启动来宾

After this you can start your guest again. You can check the current machine type from guest and host depending on your needs.
之后，您可以重新启动您的客户。您可以根据自己的需要从客户机和主机检查当前的机器类型。 

```auto
virsh start <your_machine>
# check from host, via dumping the active xml definition
virsh dumpxml <your_machine> | xmllint --xpath "string(//domain/os/type/@machine)" -
# or from the guest via dmidecode (if supported)
sudo dmidecode | grep Product -A 1
        Product Name: Standard PC (i440FX + PIIX, 1996)
        Version: pc-i440fx-bionic
```

If you keep non-live definitions around – such as `.xml` files – remember to update those as well.
如果您保留了非活动定义（例如 `.xml` 文件），请记住也要更新这些定义。

## Further reading 进一步阅读

- This process is also documented along with some more constraints and considerations at the [Ubuntu Wiki](https://wiki.ubuntu.com/QemuKVMMigration#Upgrade_machine_type)
  Ubuntu Wiki中还记录了此过程沿着一些更多的限制和注意事项 

# Container tools in the Ubuntu space Ubuntu空间中的容器工具 

Let’s take a look at some of the most commonly used tools and technologies available in the Ubuntu container space.
让我们来看看Ubuntu容器空间中最常用的一些工具和技术。 

## LXC

**Container type**: System containers
容器类型：系统容器

[Linux Containers, or LXC](https://linuxcontainers.org/) (pronounced “lex-see”), is a program that creates and administers  containers on your local system. It is the foundation of several other  system container technologies and provides both an API (to allow  higher-level managers like LXD to administer containers), and an  interface through which the user can interact with kernel containment  features (often called the “userspace interface”). LXC interacts  directly with the kernel to isolate processes, resources, etc, and  provides the necessary tools - and a container runtime - for creating  and managing system containers.
 Linux  Containers或LXC（发音为“lex-see”）是一个在本地系统上创建和管理容器的程序。它是其他几种系统容器技术的基础，并提供了一个API（允许像LXD这样的高级管理器管理容器）和一个接口，用户可以通过该接口与内核容器功能进行交互（通常称为“用户空间接口”）。LXC直接与内核交互以隔离进程、资源等，并提供必要的工具和容器运行时来创建和管理系统容器。

To get started with LXC containers, check out our [how-to guide](https://ubuntu.com/server/docs/lxc-containers).
要开始使用LXC容器，请查看我们的操作指南。

## LXD

**Container type**: System containers
容器类型：系统容器

The [Linux Containers Daemon, or LXD](https://ubuntu.com/lxd) (pronounced “lex-dee”) is the lightervisor, or lightweight container  hypervisor. It is a system container management tool built on top of  LXC. Since it is an abstraction layer away from LXC it offers a more  user-friendly interface, including both a REST API and a command-line  interface. The LXD API deals with “remotes”, which serve images and  containers. In fact, it comes with a built-in image store, so that  containers can be created more quickly.
Linux Containers  Daemon或LXD（发音为“lex-dee”）是轻量级容器管理程序。它是一个构建在LXC之上的系统容器管理工具。由于它是一个远离LXC的抽象层，因此它提供了一个更加用户友好的接口，包括REST API和命令行接口。LXD API处理“remote”，它为映像和容器提供服务。事实上，它带有一个内置的镜像存储，因此可以更快地创建容器。

To get started with LXD from an Ubuntu Server administrator’s point of view, check out our [how to get started with LXD](https://ubuntu.com/server/docs/lxd-containers) guide. For a more general beginner’s introduction to LXD, we [recommend this tutorial](https://documentation.ubuntu.com/lxd/en/latest/tutorial/) from the LXD team.
要从Ubuntu服务器管理员的角度开始使用LXD，请查看我们的如何开始使用LXD指南。对于初学者更一般的LXD介绍，我们推荐LXD团队的本教程。

In addition to creating and managing containers, LXD can also be [used to create virtual machines](https://documentation.ubuntu.com/lxd/en/latest/howto/instances_create/#launch-a-virtual-machine).
除了创建和管理容器，LXD还可以用于创建虚拟机。

## Docker

**Container type**: Application containers
容器类型：应用容器

Docker is one of the most popular containerization platforms, which allows  developers to package applications - together with their dependencies -  into lightweight containers. This provides a consistently reproducible  environment for deploying applications, which makes it easy to build,  ship, and run them even in different environments. Docker includes a  command-line interface and a daemon to create and manage containers.
Docker是最流行的容器化平台之一，它允许开发人员将应用程序及其依赖项打包到轻量级容器中。这为部署应用程序提供了一个一致的可复制环境，即使在不同的环境中也可以轻松构建、交付和运行应用程序。Docker包括一个命令行界面和一个守护进程来创建和管理容器。 

Although Docker is widely used by developers, it can also be used by system  administrators to manage resources and applications. For instance, by  encapsulating applications (and their libraries and dependencies) in a  single package, and providing version control, deployment of software  and updates can be simplified. It also helps to optimise resource use -  particularly through its alignment with microservices architecture.
虽然Docker被开发人员广泛使用，但系统管理员也可以使用它来管理资源和应用程序。例如，通过将应用程序（及其库和依赖项）封装在单个包中，并提供版本控制，可以简化软件和更新的部署。它还有助于优化资源使用—特别是通过与微服务架构的一致性。 

To get started with Docker from a system administrator’s point of view, check out our [Docker guide for sysadmins](https://ubuntu.com/server/docs/docker-for-system-admins).
要从系统管理员的角度开始使用Docker，请查看我们的Docker系统管理员指南。

------

# About OpenStack 关于OpenStack 

OpenStack is the most popular open source cloud computing platform that enables  the management of distributed compute, network and storage resources in  the data centre.
OpenStack是最受欢迎的开源云计算平台，可以管理数据中心的分布式计算、网络和存储资源。 

While the reference virtualisation stack (consisting of [QEMU/KVM](https://ubuntu.com/server/docs/virtualisation-with-qemu) and [libvirt](https://ubuntu.com/server/docs/libvirt)) enables hardware virtualisation and the management of virtual machines  (VMs) on a single host, in most cases the computing, network and storage resources are distributed across multiple hosts in the data centre.
虽然参考虚拟化堆栈（由QEMU/KVM和libvirt组成）可以在单个主机上实现硬件虚拟化和虚拟机（VM）管理，但在大多数情况下，计算，网络和存储资源分布在数据中心的多个主机上。

This creates an obvious challenge with centralised management of those  resources, scheduling VMs, etc. OpenStack solves this problem by  aggregating distributed pools of resources, allocating them to VMs  on-demand and enabling automated VM provisioning through a self-service  portal.
这给集中管理这些资源、调度虚拟机等带来了明显的挑战。OpenStack通过聚合分布式资源池、按需将其分配给虚拟机并通过自助服务门户实现自动化虚拟机配置来解决这一问题。 

OpenStack consists of the following primary components:
OpenStack由以下主要组件组成： 

- **Keystone**: Keystone：
   Serves as an identity service, providing authentication and authorisation functions for the users and enabling multi-tenancy.
   作为身份服务，为用户提供身份验证和授权功能，并支持多租户。
- **Glance**: 一瞥：
   This is an image service, responsible for uploading, managing and retrieving cloud images for VMs running on OpenStack.
   这是一个映像服务，负责为运行在OpenStack上的VM上传、管理和检索云映像。
- **Nova**: 新星：
   This is the primary compute engine of OpenStack, responsible for VM scheduling, creation and termination.
   这是OpenStack的主要计算引擎，负责VM调度、创建和终止。
- **Neutron**: 中子：
   Provides network connectivity between VMs, enabling multi-VM deployments.
   提供虚拟机之间的网络连接，支持多虚拟机部署。
- **Cinder**: 煤渣：
   This is a storage component that is responsible for provisioning, management and termination of persistent block devices.
   这是一个存储组件，负责持久块设备的配置、管理和终止。
- **Swift**: 斯威夫特：
   This is another storage component that provides a highly available and scalable object storage service.
   这是另一个提供高可用性和可伸缩对象存储服务的存储组件。

There are also many other OpenStack components and supporting services  available in the OpenStack ecosystem, enabling more advanced functions,  such as load balancing, secrets management, etc.
在OpenStack生态系统中还有许多其他的OpenStack组件和支持服务，可以实现更高级的功能，例如负载平衡，秘密管理等。 

## OpenStack installation OpenStack安装

The most straightforward way to get started with OpenStack on Ubuntu is to use [MicroStack](https://microstack.run/docs/single-node) since the entire installation process requires only 2 commands and takes around 20 minutes.
在Ubuntu上开始使用OpenStack最简单的方法是使用MicroStack，因为整个安装过程只需要2个命令，大约需要20分钟。

Apart from MicroStack, multiple different installation methods for OpenStack on Ubuntu are available. These include:
除了MicroStack之外，Ubuntu上的OpenStack还有多种不同的安装方法。其中包括： 

- [OpenStack Charms OpenStack魅力](https://docs.openstack.org/project-deploy-guide/charm-deployment-guide/latest/)
- [OpenStack Ansible](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/)
- [Manual Installation 手动安装](https://docs.openstack.org/install-guide/)
- [DevStack](https://docs.openstack.org/devstack/latest/)

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          [                   Previous 先前                    Containers: Container tools overview
容器：容器工具概述                  ](https://ubuntu.com/server/docs/container-tools-in-the-ubuntu-space)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     [                   ](https://ubuntu.com/server/docs/networking-key-concepts)

# Networking key concepts 联网关键概念 

This section provides high-level information pertaining to networking,  including an overview of network concepts and detailed discussion of  popular network protocols.
本节提供有关网络的高级信息，包括网络概念的概述和流行网络协议的详细讨论。 

## The Transmission Control Protocol and Internet Protocol (TCP/IP) 传输控制协议和互联网协议（TCP/IP） 

The Transmission Control Protocol and Internet Protocol is a standard set  of protocols developed in the late 1970s by the Defense Advanced  Research Projects Agency (DARPA) as a means of communication between  different types of computers and computer networks. TCP/IP is the  driving force of the Internet, and thus it is the most popular set of  network protocols on Earth.
传输控制协议（英语：Transmission Control Protocol）和互联网协议（英语：Internet  Protocol）是美国国防高级研究计划局（DARPA）在1970年代后期开发的一套标准协议，作为不同类型计算机和计算机网络之间的通信手段。TCP/IP是互联网的驱动力，因此它是地球上最流行的网络协议集。 

### TCP/IP overview TCP/IP概述 

The two protocol components of TCP/IP deal with different aspects of computer networking.
TCP/IP的两个协议组件处理计算机网络的不同方面。 

- **Internet Protocol** – the “IP” of TCP/IP – is a connectionless protocol that deals only with network packet routing using the *IP Datagram* as the basic unit of networking information. The IP Datagram consists of a header followed by a message.
  互联网协议-TCP/IP的“IP”-是一种无连接协议，它只处理使用IP数据报作为网络信息基本单元的网络数据包路由。IP数据报由报头和消息组成。
- **Transmission Control Protocol** – the “TCP” of TCP/IP – enables network hosts to establish connections  that may be used to exchange data streams. TCP also guarantees that data sent between connections is delivered, and that it arrives at one  network host in the same order as sent from another network host.
  传输控制协议-TCP/IP的“TCP”-使网络主机能够建立可用于交换数据流的连接。TCP还保证在连接之间发送的数据被传递，并且它以从另一个网络主机发送的相同顺序到达一个网络主机。

### TCP/IP configuration TCP/IP配置 

The TCP/IP protocol configuration consists of several elements that must be set by editing the appropriate configuration files, or by deploying  solutions such as the Dynamic Host Configuration Protocol (DHCP) server  which can, in turn, be configured to provide the proper TCP/IP  configuration settings to network clients automatically. These  configuration values must be set correctly in order to facilitate the  proper network operation of your Ubuntu system.
TCP/IP协议配置由几个元素组成，必须通过编辑适当的配置文件或部署解决方案（如动态主机配置协议（DHCP）服务器）来设置这些元素，而动态主机配置协议（DHCP）服务器又可以配置为自动向网络客户端提供适当的TCP/IP配置设置。这些配置值必须正确设置，以促进Ubuntu系统的正常网络操作。 

The common configuration elements of TCP/IP and their purposes are as follows:
TCP/IP的常见配置元素及其用途如下： 

- **IP address**: The IP address is a unique identifying string expressed as four decimal numbers ranging from zero (0) to two-hundred and fifty-five (255),  separated by periods, with each of the four numbers representing eight  (8) bits of the address for a total length of thirty-two (32) bits for  the whole address. This format is called *dotted quad notation*.
  IP地址：IP地址是唯一的标识字符串，表示为范围从零（0）到二百五十五（255）的四个十进制数字，由句点分隔，四个数字中的每一个表示地址的八（8）位，整个地址的总长度为三十二（32）位。这种格式称为点四分表示法。
- **Netmask**: The subnet mask (or simply, *netmask*) is a local bit mask, or set of flags, which separate the portions of an IP address significant to the network from the bits significant to the *subnetwork*. For example, in a Class C network, the standard netmask is  255.255.255.0 which masks the first three bytes of the IP address and  allows the last byte of the IP address to remain available for  specifying hosts on the subnetwork.
  网络掩码：子网掩码（或简称为netmask）是一个本地位掩码，或一组标志，它将IP地址中对网络重要的部分与对子网重要的位分开。例如，在C类网络中，标准网络掩码是255.255.255.0，它屏蔽IP地址的前三个字节，并允许IP地址的最后一个字节保持可用于指定子网上的主机。
- **Network address**: The network address represents the bytes comprising the network portion of an IP address. For example, the host 12.128.1.2 in a Class A network would use 12.0.0.0 as the network address, where twelve (12) represents the first byte of the IP address, (the network part) and zeroes (0) in  all of the remaining three bytes to represent the potential host values. A network host using the private IP address 192.168.1.100 would in turn use a network address of 192.168.1.0, which specifies the first three  bytes of the Class C 192.168.1 network and a zero (0) for all the  possible hosts on the network.
  网络地址：网络地址表示组成IP地址的网络部分的字节。例如，A类网络中的主机12.0.0.0将使用  12.128.1.2作为网络地址，其中十二（12）表示IP地址的第一个字节（网络部分），并且所有剩余三个字节中的零（0）表示潜在的主机值。使用专用IP地址www.example.com的网络主机将转而使用网络地址192.168.1.0，该地址指定C类192.168.1网络的前三个字节，并为网络上所有可能的主机指定零（0）。192.168.1.100
- **Broadcast address**: The broadcast address is an IP address that allows network data to be  sent simultaneously to all hosts on a given subnetwork, rather than  specifying a particular host. The standard general broadcast address for IP networks is 255.255.255.255, but this broadcast address cannot be  used to send a broadcast message to every host on the Internet because  routers block it. A more appropriate broadcast address is set to match a specific subnetwork. For example, on the private Class C IP network,  192.168.1.0, the broadcast address is 192.168.1.255. Broadcast messages  are typically produced by network protocols such as the Address  Resolution Protocol (ARP) and the Routing Information Protocol (RIP).
  广播地址：广播地址是一个IP地址，它允许网络数据同时发送到给定子网中的所有主机，而不是指定特定的主机。IP网络的标准通用广播地址是255.255.255.255，但此广播地址不能用于向Internet上的每台主机发送广播消息，因为路由器会阻止它。设置一个更合适的广播地址以匹配特定的子网。例如，在专用C类IP网络192.168.1.0上，广播地址为192.168.1.255。广播消息通常由诸如地址解析协议（阿普）和路由信息协议（RIP）之类的网络协议产生。
- **Gateway address**: A gateway address is the IP address through which a particular network, or host on a network, may be reached. If one network host wishes to  communicate with another network host, and that host is not located on  the same network, then a *gateway* must be used. In many cases, the gateway address will be that of a  router on the same network, which will in turn pass traffic on to other  networks or hosts, such as Internet hosts. The value of the Gateway  Address setting must be correct, or your system will not be able to  reach any hosts beyond those on the same network.
  网关地址：网关地址是可以到达特定网络或网络上的主机的IP地址。如果一台网络主机希望与另一台网络主机通信，并且该主机不在同一网络上，则必须使用网关。在许多情况下，网关地址将是同一网络上的路由器的地址，该路由器又将流量传递到其他网络或主机，例如Internet主机。网关地址设置的值必须正确，否则您的系统将无法访问同一网络上的主机以外的任何主机。
- **Nameserver address**: Nameserver addresses represent the IP addresses of Domain Name Service  (DNS) systems, which resolve network hostnames into IP addresses. There  are three levels of nameserver addresses, which may be specified in  order of precedence: The *primary* nameserver, the *secondary* nameserver, and the *tertiary* nameserver. So that your system can resolve network hostnames into  their corresponding IP addresses, you must specify valid nameserver  addresses that you are authorized to use in your system’s TCP/IP  configuration. In many cases, these addresses can and will be provided  by your network service provider, but many free and publicly accessible  nameservers are available for use, such as the Level3 (Verizon) servers  with IP addresses from 4.2.2.1 to 4.2.2.6.
  服务器地址：域名服务器地址表示域名服务（DNS）系统的IP地址，DNS系统将网络主机名解析为IP地址。有三个级别的名称服务器地址，可以按优先级顺序指定：主名称服务器、次名称服务器和第三级名称服务器。为了使您的系统能够将网络主机名解析为相应的IP地址，您必须指定您有权在系统的TCP/IP配置中使用的有效名称服务器地址。在许多情况下，这些地址可以并将由您的网络服务提供商提供，但许多免费和可公开访问的名称服务器可供使用，例如IP地址从4.2.2.1到4.2.2.6的Level 3（Verizon）服务器。

> **Tip**
>  The IP address, netmask, network address, broadcast address, gateway  address, and nameserver addresses are typically specified via the  appropriate directives in the file `/etc/network/interfaces`. For more information, view the system manual page for `interfaces`, with the following command typed at a terminal prompt:
>  IP地址、网络掩码、网络地址、广播地址、网关地址和名称服务器地址通常通过文件 `/etc/network/interfaces` 中的相应指令指定。有关详细信息，请查看 `interfaces` 的系统手册页，并在终端提示符处键入以下命令：

```auto
man interfaces
```

### IP routing IP路由 

IP routing is a way of specifying and discovering paths in a TCP/IP  network that network data can be sent along. Routing uses a set of *routing tables* to direct the forwarding of network data packets from their source to  the destination, often via many intermediary network nodes known as *routers*. There are two primary forms of IP routing: *static routing* and *dynamic routing.*
IP路由是一种在TCP/IP网络中指定和发现路径的方法，网络数据可以沿着这些路径沿着发送。路由使用一组路由表来指导网络数据包从其源到目的地的转发，通常通过许多称为路由器的中间网络节点。IP路由主要有两种形式：静态路由和动态路由。

Static routing involves manually adding IP routes to the system’s routing  table, and this is usually done by manipulating the routing table with  the `route` command. Static routing enjoys many advantages over dynamic routing,  such as simplicity of implementation on smaller networks, predictability (the routing table is always computed in advance, and thus the route is precisely the same each time it is used), and low overhead on other  routers and network links due to the lack of a dynamic routing protocol. However, static routing does present some disadvantages as well. For  example, static routing is limited to small networks and does not scale  well. Static routing also fails completely to adapt to network outages  and failures along the route due to the fixed nature of the route.
静态路由涉及手动将IP路由添加到系统的路由表中，通常通过使用 `route`  命令操作路由表来完成。与动态路由相比，静态路由具有许多优点，例如在较小的网络上实现简单，可预测性（路由表总是提前计算，因此每次使用时路由都完全相同），以及由于缺乏动态路由协议而导致的其他路由器和网络链路的开销较低。然而，静态路由也存在一些缺点。例如，静态路由仅限于小型网络，并且不能很好地扩展。由于路由的固定性质，静态路由也完全无法适应路由沿着的网络中断和故障。

Dynamic routing depends on large networks with multiple possible IP routes from a source to a destination and makes use of special routing protocols,  such as the Router Information Protocol (RIP), which handle the  automatic adjustments in routing tables that make dynamic routing  possible. Dynamic routing has several advantages over static routing,  such as superior scalability and the ability to adapt to failures and  outages along network routes. Additionally, there is less manual  configuration of the routing tables, since routers learn from one  another about their existence and available routes. This trait also  prevents mistakes being introduced into the routing tables via human  error. Dynamic routing is not perfect, however, and presents  disadvantages such as heightened complexity and additional network  overhead from router communications, which does not immediately benefit  the end users but still consumes network bandwidth.
动态路由依赖于从源到目的地具有多个可能IP路由的大型网络，并使用特殊的路由协议，如路由器信息协议（RIP），它处理路由表中的自动调整，使动态路由成为可能。与静态路由相比，动态路由有几个优点，例如上级可扩展性和适应沿着网络路由的故障和中断的能力。此外，路由表的手动配置较少，因为路由器可以相互了解它们的存在和可用路由。这个特性还可以防止通过人为错误将错误引入路由表。然而，动态路由并不完美，并且存在缺点，例如路由器通信的复杂性增加和额外的网络开销，这不会立即使最终用户受益，但仍然消耗网络带宽。 

### About TCP and UDP 关于TCP和UDP 

TCP (Transmission Control Protocol) and UDP (User Datagram Protocol) are  the most common protocols used to transfer data over networks.
TCP（传输控制协议）和UDP（用户数据报协议）是用于通过网络传输数据的最常见协议。 

TCP is a connection-based protocol, offering error correction and guaranteed delivery of data via what is known as *flow control*. Flow control determines when the flow of a data stream needs to be  stopped, and previously-sent data packets should be re-sent due to  problems such as *collisions*, for example, thus ensuring complete and accurate delivery of the data.  TCP is typically used in the exchange of important information such as  database transactions.
TCP是一种基于连接的协议，通过所谓的流控制提供错误纠正和有保证的数据传输。流量控制确定何时需要停止数据流的流动，并且由于诸如冲突之类的问题，先前发送的数据分组应当被重新发送，从而确保数据的完整和准确的递送。TCP通常用于交换重要信息，如数据库事务。

UDP on the other hand, is a *connectionless* protocol which seldom deals with the transmission of important data  because it lacks flow control or any other method to ensure reliable  delivery of the data. UDP is commonly used in such applications as audio and video streaming, where it is considerably faster than TCP due to  the lack of error correction and flow control, and where the loss of a  few packets is not generally catastrophic.
另一方面，UDP是一种无连接协议，很少处理重要数据的传输，因为它缺乏流量控制或任何其他方法来确保数据的可靠传输。UDP通常用于音频和视频流等应用，由于缺乏纠错和流量控制，它比TCP快得多，并且丢失几个数据包通常不会造成灾难性后果。

### Internet Control Messaging Protocol (ICMP) 互联网控制消息协议（ICMP） 

The Internet Control Messaging Protocol is an extension to the Internet Protocol (IP) as defined in the [Request For Comments (RFC) #792](https://www.rfc-editor.org/rfc/rfc792), and supports network packets containing control, error, and  informational messages. ICMP is used by such network applications as the ping utility, which can determine the availability of a network host or device. Examples of some error messages returned by ICMP which are  useful to both network hosts and devices such as routers, include *Destination Unreachable* and *Time Exceeded*.
互联网控制消息协议是在请求注解（RFC）#792中定义的互联网协议（IP）的扩展，并且支持包含控制、错误和信息消息的网络分组。Ping实用程序等网络应用程序使用Telnet，它可以确定网络主机或设备的可用性。例如，对于网络主机和设备（如路由器）都很有用的一些错误消息，包括Destination Unreachable和Time Exceeded。

### About daemons 关于守护进程 

Daemons are special system applications which typically execute continuously in the background and await requests for the functions they provide from  other applications. Many daemons are network-centric; that is, a large  number of daemons executing in the background on an Ubuntu system may  provide network-related functionality. Such network daemons include the *Hyper Text Transport Protocol Daemon* (`httpd`), which provides web server functionality; the *Secure SHell Daemon* (`sshd`), which provides secure remote login shell and file transfer capabilities; and the *Internet Message Access Protocol Daemon* (`imapd`), which provides E-Mail services.
守护进程是特殊的系统应用程序，通常在后台连续执行，并等待其他应用程序对其提供的功能的请求。许多守护进程是以网络为中心的;也就是说，在Ubuntu系统上后台执行的大量守护进程可以提供与网络相关的功能。此类网络守护程序包括提供Web服务器功能的超文本传输协议守护程序（ `httpd` ）;提供安全远程登录外壳和文件传输功能的Secure Shell守护程序（ `sshd` ）;以及提供电子邮件服务的Internet消息访问协议守护程序（ `imapd` ）。

### Resources 资源 

- There are man pages for [TCP](https://manpages.ubuntu.com/manpages/focal/en/man7/tcp.7.html) and [IP](http://manpages.ubuntu.com/manpages/focal/man7/ip.7.html) that contain more useful information.
  TCP和IP的手册页包含更多有用的信息。
- Also, see the [TCP/IP Tutorial and Technical Overview](http://www.redbooks.ibm.com/abstracts/gg243376.html) IBM Redbook.
  另请参阅TCP/IP协议和技术概述IBM红皮书。
- Another resource is O’Reilly’s [TCP/IP Network Administration](http://oreilly.com/catalog/9780596002978/).
  另一个资源是O 'Reilly的TCP/IP网络管理。

------

# Configuring networks 配置网络 

Ubuntu ships with a number of graphical utilities to configure your network  devices. This document is geared toward server administrators and will  focus on managing your network on the command line.
Ubuntu附带了许多图形实用程序来配置您的网络设备。本文档面向服务器管理员，重点介绍如何在命令行上管理网络。 

## Ethernet interfaces 以太网接口 

Ethernet interfaces are identified by the system using predictable network interface names. These names can appear as *eno1* or *enp0s25*. However, in some cases an interface may still use the kernel *eth#* style of naming.
以太网接口由系统使用可预测的网络接口名称标识。这些名称可以显示为eno1或enp0s25。但是，在某些情况下，接口可能仍然使用内核eth#风格的命名。

### Identify Ethernet interfaces 识别以太网接口 

To quickly identify all available Ethernet interfaces, you can use the ip command as shown below.
要快速识别所有可用的以太网接口，可以使用ip命令，如下所示。 

```auto
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:e2:52:42 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.102.66.200/24 brd 10.102.66.255 scope global dynamic eth0
       valid_lft 3257sec preferred_lft 3257sec
    inet6 fe80::216:3eff:fee2:5242/64 scope link
       valid_lft forever preferred_lft forever
```

Another application that can help identify all network interfaces available to your system is the `lshw` command. This command provides greater details around the hardware capabilities of specific adapters. In the example below, `lshw` shows a single Ethernet interface with the logical name of *eth4* along with bus information, driver details and all supported capabilities.
另一个可以帮助识别系统可用的所有网络接口的应用程序是 `lshw` 命令。此命令提供有关特定适配器的硬件功能的更多详细信息。在下面的示例中， `lshw` 显示了一个逻辑名称为eth4的以太网接口，沿着显示了总线信息、驱动程序详细信息和所有支持的功能。

```auto
sudo lshw -class network
  *-network
       description: Ethernet interface
       product: MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s]
       vendor: Mellanox Technologies
       physical id: 0
       bus info: pci@0004:01:00.0
       logical name: eth4
       version: b0
       serial: e4:1d:2d:67:83:56
       slot: U78CB.001.WZS09KB-P1-C6-T1
       size: 10Gbit/s
       capacity: 10Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm vpd msix pciexpress bus_master cap_list ethernet physical fibre 10000bt-fd
       configuration: autonegotiation=off broadcast=yes driver=mlx4_en driverversion=4.0-0 duplex=full firmware=2.9.1326 ip=192.168.1.1 latency=0 link=yes multicast=yes port=fibre speed=10Gbit/s
       resources: iomemory:24000-23fff irq:481 memory:3fe200000000-3fe2000fffff memory:240000000000-240007ffffff
```

### Ethernet Interface logical names 以太网接口逻辑名称 

Interface logical names can also be configured via a Netplan configuration. If  you would like control which interface receives a particular logical  name use the `match` and `set-name` keys. The `match` key is used to find an adapter based on some criteria like MAC address, driver, etc. The `set-name` key can be used to change the device to the desired logical name.
接口逻辑名称也可以通过网络计划配置进行配置。如果你想控制哪个接口接收一个特定的逻辑名称，使用 `match` 和 `set-name` 键。 `match` 键用于根据MAC地址、驱动程序等条件查找适配器。 `set-name` 键可用于将设备更改为所需的逻辑名称。

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    eth_lan0:
      dhcp4: true
      match:
        macaddress: 00:11:22:33:44:55
      set-name: eth_lan0
```

### Ethernet Interface settings 以太网接口设置 

`ethtool` is a program that displays and changes Ethernet card settings such as  auto-negotiation, port speed, duplex mode, and Wake-on-LAN. The  following is an example of how to view the supported features and  configured settings of an Ethernet interface.
 `ethtool` 是一个显示和更改以太网卡设置（如自动协商、端口速度、双工模式和LAN唤醒）的程序。以下是如何查看以太网接口的支持功能和配置设置的示例。

```auto
sudo ethtool eth4
Settings for eth4:
    Supported ports: [ FIBRE ]
    Supported link modes:   10000baseT/Full
    Supported pause frame use: No
    Supports auto-negotiation: No
    Supported FEC modes: Not reported
    Advertised link modes:  10000baseT/Full
    Advertised pause frame use: No
    Advertised auto-negotiation: No
    Advertised FEC modes: Not reported
    Speed: 10000Mb/s
    Duplex: Full
    Port: FIBRE
    PHYAD: 0
    Transceiver: internal
    Auto-negotiation: off
    Supports Wake-on: d
    Wake-on: d
    Current message level: 0x00000014 (20)
                   link ifdown
    Link detected: yes
```

## IP addressing IP寻址 

The following section describes the process of configuring your system’s IP address and default gateway needed for communicating on a local area  network and the Internet.
以下部分介绍配置系统IP地址和默认网关的过程，这些地址和网关是在局域网和Internet上进行通信所需的。 

### Temporary IP address assignment 临时IP地址分配 

For temporary network configurations, you can use the `ip` command which is also found on most other GNU/Linux operating systems. The `ip` command allows you to configure settings which take effect immediately – however they are not persistent and will be lost after a reboot.
对于临时网络配置，您可以使用 `ip` 命令，该命令也可以在大多数其他GNU/Linux操作系统上找到。 `ip` 命令允许您配置立即生效的设置-但它们不是持久性的，并且在重新启动后会丢失。

To temporarily configure an IP address, you can use the `ip` command in the following manner. Modify the IP address and subnet mask to match your network requirements.
要临时配置IP地址，您可以按以下方式使用 `ip` 命令。修改IP地址和子网掩码以符合您的网络要求。

```auto
sudo ip addr add 10.102.66.200/24 dev enp0s25
```

The `ip` can then be used to set the link up or down.
然后，可使用 `ip` 来设置链路的接通或断开。

```auto
ip link set dev enp0s25 up
ip link set dev enp0s25 down
```

To verify the IP address configuration of `enp0s25`, you can use the `ip` command in the following manner:
要验证 `enp0s25` 的IP地址配置，您可以按以下方式使用 `ip` 命令：

```auto
ip address show dev enp0s25
10: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:e2:52:42 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.102.66.200/24 brd 10.102.66.255 scope global dynamic eth0
       valid_lft 2857sec preferred_lft 2857sec
    inet6 fe80::216:3eff:fee2:5242/64 scope link
       valid_lft forever preferred_lft forever6
```

To configure a default gateway, you can use the `ip` command in the following manner. Modify the default gateway address to match your network requirements.
要配置默认网关，您可以按以下方式使用 `ip` 命令。修改默认网关地址以符合您的网络要求。

```auto
sudo ip route add default via 10.102.66.1
```

You can also use the `ip` command to verify your default gateway configuration, as follows:
您也可以使用 `ip` 命令验证默认网关配置，如下所示：

```auto
ip route show
default via 10.102.66.1 dev eth0 proto dhcp src 10.102.66.200 metric 100
10.102.66.0/24 dev eth0 proto kernel scope link src 10.102.66.200
10.102.66.1 dev eth0 proto dhcp scope link src 10.102.66.200 metric 100 
```

If you require DNS for your temporary network configuration, you can add DNS server IP addresses in the file `/etc/resolv.conf`. In general, editing `/etc/resolv.conf` directly is not recommended, but this is a temporary and non-persistent configuration. The example below shows how to enter two DNS servers to `/etc/resolv.conf`, which should be changed to servers appropriate for your network. A more lengthy description of the proper (persistent) way to do DNS client  configuration is in a following section.
如果临时网络配置需要DNS，可以在文件 `/etc/resolv.conf` 中添加DNS服务器IP地址。一般来说，不建议直接编辑 `/etc/resolv.conf` ，但这是一个临时的非持久性配置。下面的示例显示了如何在 `/etc/resolv.conf` 中输入两个DNS服务器，应将其更改为适合您网络的服务器。下一节将详细介绍DNS客户端配置的正确（持久）方法。

```auto
nameserver 8.8.8.8
nameserver 8.8.4.4
```

If you no longer need this configuration and wish to purge all IP configuration from an interface, you can use the `ip` command with the flush option:
如果您不再需要此配置并希望从接口清除所有IP配置，则可以使用带有flush选项的 `ip` 命令：

```auto
ip addr flush eth0
```

> **Note 注意**
>  Flushing the IP configuration using the `ip` command does not clear the contents of `/etc/resolv.conf`. You must remove or modify those entries manually (or re-boot), which should also cause `/etc/resolv.conf`, which is a symlink to `/run/systemd/resolve/stub-resolv.conf`, to be re-written.
>  使用 `ip` 命令刷新IP配置不会清除 `/etc/resolv.conf` 的内容。您必须手动删除或修改这些条目（或重新引导），这也会导致重新写入 `/etc/resolv.conf` ，它是 `/run/systemd/resolve/stub-resolv.conf` 的符号链接。

### Dynamic IP address assignment (DHCP client) 动态IP地址分配（DHCP客户端） 

To configure your server to use DHCP for dynamic address assignment, create a Netplan configuration in the file `/etc/netplan/99_config.yaml`. The following example assumes you are configuring your first Ethernet interface identified as `enp3s0`.
要将服务器配置为使用DHCP进行动态地址分配，请在文件 `/etc/netplan/99_config.yaml` 中创建网络计划配置。以下示例假定您正在配置标识为 `enp3s0` 的第一个以太网接口。

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true
```

The configuration can then be applied using the `netplan` command:
然后可以使用 `netplan` 命令应用配置：

```auto
sudo netplan apply
```

### Static IP address assignment 静态IP地址分配 

To configure your system to use static address assignment, create a `netplan` configuration in the file `/etc/netplan/99_config.yaml`. The example below assumes you are configuring your first Ethernet interface identified as `eth0`. Change the `addresses`, `routes`, and `nameservers` values to meet the requirements of your network.
要将系统配置为使用静态地址分配，请在文件 `/etc/netplan/99_config.yaml` 中创建 `netplan` 配置。下面的示例假设您正在配置标识为 `eth0` 的第一个以太网接口。更改 `addresses` 、 `routes` 和 `nameservers` 值以满足您的网络要求。

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.10.10.2/24
      routes:
        - to: default
          via: 10.10.10.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [10.10.10.1, 1.1.1.1]
```

The configuration can then be applied using the `netplan` command.
然后可以使用 `netplan` 命令应用配置。

```auto
sudo netplan apply
```

> **NOTE 注意**
>  `netplan` in  Ubuntu Bionic 18.04 LTS doesn’t understand the “`to: default`” syntax to specify a default route, and should use the older `gateway4: 10.10.10.1` key instead of the whole `routes:` block.
> Ubuntu Bionic 18.04 LTS中的 `netplan` 不理解指定默认路由的“ `to: default` “语法，应该使用旧的 `gateway4: 10.10.10.1` 键而不是整个 `routes:` 块。

The loopback interface is identified by the system as `lo` and has a default IP address of 127.0.0.1. It can be viewed using the `ip` command.
系统将ICMP接口标识为 `lo` ，其默认IP地址为127.0.0.1。可以使用 `ip` 命令查看。

```auto
ip address show lo
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
```

## Name resolution 名称解析 

Name resolution (as it relates to IP networking) is the process of mapping  hostnames to IP addresses, and vice-versa, making it easier to identify  resources on a network. The following section will explain how to  properly configure your system for name resolution using DNS and static  hostname records.
名称解析（因为它与IP网络有关）是将主机名映射到IP地址的过程，反之亦然，使其更容易识别网络上的资源。以下部分将解释如何正确配置系统，以便使用DNS和静态主机名记录进行名称解析。 

### DNS client configuration DNS客户端配置 

Traditionally, the file `/etc/resolv.conf` was a static configuration file that rarely needed to be changed, or it automatically changed via DCHP client hooks. `systemd-resolved` handles nameserver configuration, and it should be interacted with through the `systemd-resolve` command. Netplan configures `systemd-resolved` to generate a list of nameservers and domains to put in `/etc/resolv.conf`, which is a symlink:
传统上，文件 `/etc/resolv.conf` 是一个静态配置文件，很少需要更改，或者通过DCHP客户端钩子自动更改。 `systemd-resolved` 处理名称服务器配置，应该通过 `systemd-resolve` 命令进行交互。Netplan配置 `systemd-resolved` 以生成要放入 `/etc/resolv.conf` 的名称服务器和域的列表，这是一个符号链接：

```auto
/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

To configure the resolver, add the IP addresses of the appropriate nameservers for your network to the `netplan` configuration file. You can also add optional DNS suffix search-lists  to match your network domain names. The resulting file might look like  the following:
要配置解析器，请将网络的相应名称服务器的IP地址添加到 `netplan` 配置文件中。您还可以添加可选的DNS后缀搜索列表，以匹配您的网络域名。生成的文件可能如下所示：

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      addresses:
        - 192.168.0.100/24
      routes:
        - to: default
          via: 192.168.0.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [1.1.1.1, 8.8.8.8, 4.4.4.4]
```

The *search* option can also be used with multiple domain names so that DNS queries  will be appended in the order in which they are entered. For example,  your network may have multiple sub-domains to search; a parent domain of *`example.com`*, and two sub-domains, *`sales.example.com`* and *`dev.example.com`*.
搜索选项也可以用于多个域名，以便DNS查询将按照输入的顺序追加。例如，您的网络可能有多个要搜索的子域;父域 `example.com` 和两个子域 `sales.example.com` 和 `dev.example.com` 。

If you have multiple domains you wish to search, your configuration might look like the following:
如果您有多个域要搜索，您的配置可能如下所示： 

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      addresses:
        - 192.168.0.100/24
      routes:
        - to: default
          via: 192.168.0.1
      nameservers:
          search: [example.com, sales.example.com, dev.example.com]
          addresses: [1.1.1.1, 8.8.8.8, 4.4.4.4]
```

If you try to ping a host with the name `server1`, your system will automatically query DNS for its Fully Qualified Domain Name (FQDN) in the following order:
如果您尝试ping一个名称为 `server1` 的主机，您的系统将按以下顺序自动查询DNS以查找其完全限定域名（Fully Qualified Domain Name，简称FQDN）：

1. `server1.example.com`
2. `server1.sales.example.com`
3. `server1.dev.example.com`

If no matches are found, the DNS server will provide a result of *notfound* and the DNS query will fail.
如果没有找到匹配项，DNS服务器将提供notfound结果，DNS查询将失败。

### Static hostnames 静态主机名 

Static hostnames are locally defined hostname-to-IP mappings located in the file `/etc/hosts`. Entries in the `hosts` file will have precedence over DNS by default. This means that if your  system tries to resolve a hostname and it matches an entry in `/etc/hosts`, it will not attempt to look up the record in DNS. In some  configurations, especially when Internet access is not required, servers that communicate with a limited number of resources can be conveniently set to use static hostnames instead of DNS.
静态主机名是本地定义的主机名到IP的映射，位于文件 `/etc/hosts` 中。默认情况下， `hosts` 文件中的DNS优先于DNS。这意味着，如果您的系统尝试解析主机名，并且它与 `/etc/hosts` 中的条目匹配，则它不会尝试在DNS中查找记录。在某些配置中，特别是当不需要Internet访问时，可以方便地将与有限数量的资源通信的服务器设置为使用静态主机名而不是DNS。

The following is an example of a `hosts` file where a number of local servers have been identified by simple  hostnames, aliases and their equivalent Fully Qualified Domain Names  (FQDN’s):
以下是一个 `hosts` 文件的示例，其中许多本地服务器已通过简单的主机名、别名及其等效的完全限定域名（FullyQualified Domain Name，简称FQ）来标识：

```auto
127.0.0.1   localhost
127.0.1.1   ubuntu-server
10.0.0.11   server1 server1.example.com vpn
10.0.0.12   server2 server2.example.com mail
10.0.0.13   server3 server3.example.com www
10.0.0.14   server4 server4.example.com file
```

> **Note 注意**
>  In this example, notice that each of the servers were given aliases in addition to their proper names and FQDN’s. *Server1* has been mapped to the name *vpn*, *server2* is referred to as *mail*, *server3* as *www*, and *server4* as *file*.
>  在本例中，请注意，每个服务器除了它们的专有名称和别名之外，还被赋予了别名。服务器1被映射为名称vpn，服务器2被称为邮件，服务器3被称为www，服务器4被称为文件。

### Name Service Switch (NSS) configuration 名称服务交换机（NSS）配置 

The order in which your system selects a method of resolving hostnames to  IP addresses is controlled by the Name Service Switch (NSS)  configuration file `/etc/nsswitch.conf`. As mentioned in the previous section, typically static hostnames defined in the systems `/etc/hosts` file have precedence over names resolved from DNS. The following is an  example of the line responsible for this order of hostname lookups in  the file `/etc/nsswitch.conf`.
系统选择将主机名解析为IP地址的方法的顺序由名称服务交换机（NSS）配置文件 `/etc/nsswitch.conf` 控制。如前一节所述，系统 `/etc/hosts` 文件中定义的静态主机名通常优先于从DNS解析的名称。下面是文件 `/etc/nsswitch.conf` 中负责此主机名查找顺序的行的示例。

```auto
hosts:          files mdns4_minimal [NOTFOUND=return] dns mdns4
```

- **`files`** first tries to resolve static hostnames located in `/etc/hosts`.
   `files` 首先尝试解析位于 `/etc/hosts` 中的静态主机名。
- **`mdns4_minimal`** attempts to resolve the name using Multicast DNS.
   `mdns4_minimal` 尝试使用多播DNS解析名称。
- **`[NOTFOUND=return]`** means that any response of `notfound` by the preceding `mdns4_minimal` process should be treated as authoritative and that the system should not try to continue hunting for an answer.
   `[NOTFOUND=return]` 意味着前面的 `mdns4_minimal` 进程对 `notfound` 的任何响应都应该被视为权威的，并且系统不应该试图继续寻找答案。
- **`dns`** represents a legacy unicast DNS query.
   `dns` 表示传统单播DNS查询。
- **mdns4** represents a multicast DNS query.
  mdns4表示多播DNS查询。

To modify the order of these name resolution methods, you can simply change the `hosts:` string to the value of your choosing. For example, if you prefer to use legacy unicast DNS versus multicast DNS, you can change the string in `/etc/nsswitch.conf` as shown below:
要修改这些名称解析方法的顺序，只需将 `hosts:` 字符串更改为您选择的值。例如，如果您更喜欢使用传统单播DNS而不是多播DNS，则可以更改 `/etc/nsswitch.conf` 中的字符串，如下所示：

```auto
hosts:          files dns [NOTFOUND=return] mdns4_minimal mdns4
```

## Bridging multiple interfaces 桥接多个接口 

Bridging is a more advanced configuration, but is very useful in multiple  scenarios. One scenario is setting up a bridge with multiple network  interfaces, then using a firewall to filter traffic between two network  segments. Another scenario is using bridge on a system with one  interface to allow virtual machines direct access to the outside  network. The following example covers the latter scenario:
桥接是一种更高级的配置，但在多个场景中非常有用。一种情况是建立一个具有多个网络接口的网桥，然后使用防火墙过滤两个网段之间的流量。另一种情况是在具有一个接口的系统上使用网桥，以允许虚拟机直接访问外部网络。下面的示例涵盖了后一种情况： 

Configure the bridge by editing your `netplan` configuration found in `/etc/netplan/`, entering the appropriate values for your physical interface and network:
通过编辑在 `/etc/netplan/` 中找到的 `netplan` 配置来配置网桥，为物理接口和网络输入适当的值：

```auto
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: no
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - enp3s0
```

Now apply the configuration to enable the bridge:
现在应用配置以启用网桥： 

```auto
sudo netplan apply
```

The new bridge interface should now be up and running. The `brctl` provides useful information about the state of the bridge, controls which interfaces are part of the bridge, etc. See `man brctl` for more information.
新的网桥接口现在应该已经启动并运行了。 `brctl` 提供有关网桥状态的有用信息，控制哪些接口是网桥的一部分等。有关更多信息，请参见 `man brctl` 。

## networkd-dispatcher for hook scripts 钩子脚本的网络调度程序 

Users of the former  `ifupdown` may be familiar with using hook scripts (e.g., pre-up, post-up) in their interfaces file. [Netplan configuration](https://netplan.readthedocs.io/en/stable/netplan-yaml/) does not currently support hook scripts in its configuration definition.
前者 `ifupdown` 的用户可能熟悉使用钩子脚本（例如，pre-up、post-up）。网络计划配置当前在其配置定义中不支持挂钩脚本。

Instead, to achieve this functionality with the `networkd` renderer, users can use [networkd-dispatcher](http://manpages.ubuntu.com/manpages/focal/man8/networkd-dispatcher.8.html). The package provides both users and packages with hook points when  specific network states are reached, to aid in reacting to network  state.
相反，要使用 `networkd` 渲染器实现此功能，用户可以使用networkd-dispatcher。当达到特定的网络状态时，该软件包为用户和软件包提供挂钩点，以帮助对网络状态做出反应。

> **Note**: 注意：
>  If you are on Desktop (not Ubuntu Server) the network is driven by Network Manager - in that case you need [NM Dispatcher scripts](https://developer.gnome.org/NetworkManager/unstable/NetworkManager.html) instead.
>  如果你在桌面（不是Ubuntu服务器）上，网络是由网络管理器驱动的-在这种情况下，你需要NM Dispatcher脚本。

The [Netplan FAQ has a great table](https://netplan.io/faq/#use-pre-up%2C-post-up%2C-etc.-hook-scripts) that compares event timings between `ifupdown`/`systemd-networkd`/`network-manager`.
Netplan FAQ有一个很棒的表格，比较了 `ifupdown` / `systemd-networkd` / `network-manager` 之间的事件时间。

It is important to be aware that these hooks run asynchronously; i.e. they will not block transition into another state.
重要的是要知道这些钩子是异步运行的;也就是说，它们不会阻塞到另一个状态的转换。 

The [Netplan FAQ also has an example](https://netplan.io/faq/#example-for-an-ifupdown-legacy-hook-for-post-up%2Fpost-down-states) on converting an old `ifupdown` hook to `networkd-dispatcher`.
Netplan FAQ也有一个将旧的 `ifupdown` 钩子转换为 `networkd-dispatcher` 的示例。

## Resources 资源 

- The [Ubuntu Wiki Network page](https://help.ubuntu.com/community/Network) has links to articles covering more advanced network configuration.
  Ubuntu Wiki网络页面提供了一些链接，可以链接到介绍更高级网络配置的文章。
- The [Netplan website](https://netplan.io) has additional [examples](https://netplan.readthedocs.io/en/stable/netplan-yaml/#) and documentation.
  Netplan网站提供了其他示例和文档。
- The [Netplan man page](https://manpages.ubuntu.com/manpages/focal/man5/netplan.5.html) has more information on Netplan.
  Netplan手册页提供了有关Netplan的更多信息。
- The [systemd-resolved man page](https://manpages.ubuntu.com/manpages/focal/man8/systemd-resolved.8.html) has more information on systemd-resolved service.
  systemd解析的手册页提供了有关systemd解析的服务的更多信息。
- For more information on *bridging* see the [netplan.io examples page](https://netplan.readthedocs.io/en/stable/netplan-yaml/#properties-for-device-type-bridges)
  有关桥接的更多信息，请参见netplan.io示例页面

------

# About Dynamic Host Configuration Protocol (DHCP) 关于动态主机配置协议（DHCP） 

The Dynamic Host Configuration Protocol (DHCP) is a network service that  enables host computers to be automatically assigned settings from a  server as opposed to manually configuring each network host. Computers  configured to be DHCP clients have no control over the settings they  receive from the DHCP server, and the configuration is transparent to  the computer’s user.
动态主机配置协议（DHCP）是一种网络服务，它使主机计算机能够从服务器自动分配设置，而不是手动配置每个网络主机。配置为DHCP客户端的计算机无法控制它们从DHCP服务器接收的设置，并且配置对计算机的用户是透明的。 

The most common settings provided by a DHCP server to DHCP clients include:
DHCP服务器向DHCP客户端提供的最常见设置包括： 

- IP address and netmask
  IP地址和网络掩码 
- IP address of the default-gateway to use
  要使用的默认网关的IP地址 
- IP addresses of the DNS servers to use
  要使用的DNS服务器的IP地址 

However, a DHCP server can also supply configuration properties such as:
但是，DHCP服务器还可以提供配置属性，例如： 

- Hostname
- Domain name 域名 
- Time server 时间服务器 
- Print server 打印服务器 

The advantage of using DHCP is that any changes to the network, such as a  change in the DNS server address, only need to be changed at the DHCP  server, and all network hosts will be reconfigured the next time their  DHCP clients poll the DHCP server. As an added advantage, it is also  easier to integrate new computers into the network, as there is no need  to check for the availability of an IP address. Conflicts in IP address  allocation are also reduced.
使用DHCP的优点是，对网络的任何更改（如DNS服务器地址的更改）只需在DHCP服务器上更改，并且所有网络主机将在其DHCP客户端下次轮询DHCP服务器时重新配置。作为一个额外的优势，它也更容易将新计算机集成到网络中，因为不需要检查IP地址的可用性。IP地址分配中的冲突也减少了。 

## DHCP configuration DHCP配置 

A DHCP server can provide configuration settings using the following methods:
DHCP服务器可以使用以下方法提供配置设置： 

### Manual allocation (MAC address) 手动分配（MAC地址） 

This method uses DHCP to identify the unique hardware address of each  network card connected to the network, and then supplies a static  configuration each time the DHCP client makes a request to the DHCP  server using that network device. This ensures that a particular address is assigned automatically to that network card, based on its MAC  address.
此方法使用DHCP来标识连接到网络的每个网卡的唯一硬件地址，然后在每次DHCP客户端使用该网络设备向DHCP服务器发出请求时提供静态配置。这可确保根据网卡的MAC地址自动将特定地址分配给该网卡。 

### Dynamic allocation (address pool) 动态分配（地址池） 

In this method, the DHCP server assigns an IP address from a pool of  addresses (sometimes also called a range or scope) for a period of time  (known as a lease) configured on the server, or until the client informs the server that it doesn’t need the address anymore. This way, the  clients receive their configuration properties dynamically and on a  “first come, first served” basis. When a DHCP client is no longer on the network for a specified period, the configuration is expired and  released back to the address pool for use by other DHCP clients. After  the lease period expires, the client must renegotiate the lease with the server to maintain use of the same address.
在这种方法中，DHCP服务器从地址池（有时也称为范围或作用域）中分配一个IP地址，并在服务器上配置一段时间（称为租约），或者直到客户端通知服务器它不再需要该地址。这样，客户端动态地并在“先到先得”的基础上接收其配置属性。当DHCP客户端在指定的时间段内不在网络上时，配置将过期并释放回地址池供其他DHCP客户端使用。在租约到期后，客户端必须与服务器重新协商租约，以保持使用相同的地址。 

### Automatic allocation 自动分配 

Using this method, the DHCP automatically assigns an IP address permanently  to a device, selecting it from a pool of available addresses. Usually,  DHCP is used to assign a temporary address to a client, but a DHCP  server can allow an infinite lease time.
使用此方法，DHCP自动将IP地址永久分配给设备，从可用地址池中选择该地址。通常，DHCP用于为客户端分配临时地址，但DHCP服务器可以允许无限的租用时间。 

The last two methods can be considered “automatic” because in each case the DHCP server assigns an address with no extra intervention needed. The  only difference between them is in how long the IP address is leased; in other words, whether a client’s address varies over time.
最后两种方法可以被认为是“自动”的，因为在每种情况下，DHCP服务器都分配一个地址，而不需要额外的干预。它们之间的唯一区别是IP地址租用的时间;换句话说，客户端的地址是否随时间而变化。 

## Available servers 可用服务器 

Ubuntu makes two DHCP servers available:
Ubuntu提供了两个DHCP服务器： 

- `isc-dhcp-server`:
   This server installs `dhcpd`, the dynamic host configuration protocol daemon. Although Ubuntu still supports `isc-dhcp-server`, this software is [no longer supported by its vendor](https://www.isc.org/blogs/isc-dhcp-eol/).
   此服务器安装 `dhcpd` ，动态主机配置协议守护程序。虽然Ubuntu仍然支持 `isc-dhcp-server` ，但其供应商不再支持该软件。

  Find out [how to install and configure `isc-dhcp-server`](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-dhcp-server).
  了解如何安装和配置 `isc-dhcp-server` 。

- `isc-kea`:
   [Kea](https://www.isc.org/kea/) was created by ISC to replace `isc-dhcp-server` – It is supported in Ubuntu releases from 23.04 onwards.
   Kea是由ISC创建的，用于替换 `isc-dhcp-server` —它在Ubuntu 23.04版本中得到支持。

  Find out [how to install and configure `isc-kea`](https://ubuntu.com/server/docs/how-to-install-and-configure-isc-kea).
  了解如何安装和配置 `isc-kea` 。

## References 引用 

- The [isc-dhcp-server Ubuntu Wiki](https://help.ubuntu.com/community/isc-dhcp-server) page has more information.
  isc—dhcp—server Ubuntu Wiki页面有更多信息。
- For more `/etc/dhcp/dhcpd.conf` options see the [dhcpd.conf man page](https://manpages.ubuntu.com/manpages/focal/en/man5/dhcpd.conf.5.html).
  有关更多 `/etc/dhcp/dhcpd.conf` 选项，请参见dhcpd. conf手册页。
- [ISC dhcp-server ISC dhcp服务器](https://www.isc.org/software/dhcp)
- [ISC Kea Documentation ISC Kea文档](https://kb.isc.org/docs/kea-administrator-reference-manual)

------

# About time synchronisation 关于时间同步 

Network Time Protocol (NTP) is a networking protocol for synchronising time  over a network. Basically, a client requests the current time from a  server, and uses it to set its own clock.
网络时间协议（NTP）是一种用于在网络上同步时间的网络协议。基本上，客户端从服务器请求当前时间，并使用它来设置自己的时钟。 

Behind this simple description, there is a lot of complexity. There are three  tiers of NTP servers; tier one NTP servers are connected to atomic  clocks, while tier two and tier three three servers spread the load of  actually handling requests across the Internet.
在这个简单的描述背后，有很多复杂性。NTP服务器有三层;第一层NTP服务器连接到原子钟，而第二层和第三层服务器将实际处理请求的负载分散在整个Internet上。 

The client software is also a lot more complex than you might expect. It  must factor in communication delays and adjust the time in a way that  does not upset all the other processes that run on the server. Luckily,  all that complexity is hidden from you!
客户端软件也比你想象的要复杂得多。它必须考虑通信延迟，并以不会扰乱服务器上运行的所有其他进程的方式调整时间。幸运的是，所有这些复杂性都隐藏在您的视线之外！ 

By default, Ubuntu uses `timedatectl`/`timesyncd` to synchronise time, and they are available by default. See our guide If you would like to know [how to configure `timedatectl` and `timesyncd`](https://ubuntu.com/server/docs/use-timedatectl-and-timesyncd).
默认情况下，Ubuntu使用 `timedatectl` / `timesyncd` 来同步时间，它们默认可用。如果您想了解如何配置 `timedatectl` 和 `timesyncd` ，请参阅我们的指南。

Users can also optionally [use `chrony` to serve NTP](https://ubuntu.com/server/docs/how-to-serve-the-network-time-protocol-with-chrony).
用户还可以选择使用 `chrony` 来提供NTP。

## How time synchronisation works 时间同步如何工作 

Since Ubuntu 16.04, `timedatectl`/`timesyncd` (which are part of `systemd`) replace most of `ntpdate`/`ntp`.
从Ubuntu 16.04开始， `timedatectl` / `timesyncd` （是 `systemd` 的一部分）取代了大部分的 `ntpdate` / `ntp` 。

### About `timesyncd` 关于 `timesyncd` 

`timesyncd` replaces not only `ntpdate`, but also the client portion of `chrony` (formerly `ntpd`). So, on top of the one-shot action that `ntpdate` provided on boot and network activation, `timesyncd` now regularly checks and keeps your local time in sync. It also stores  time updates locally, so that after reboots the time monotonically  advances (if applicable).
 `timesyncd` 不仅取代了 `ntpdate` ，还取代了 `chrony` （以前的 `ntpd` ）的客户端部分。因此，除了4 #在靴子和网络激活时提供的一次性操作之外，5 #现在还定期检查并保持本地时间同步。它还在本地存储时间更新，以便在重新启动后时间单调前进（如果适用）。

### About `timedatectl` 关于 `timedatectl` 

If `chrony` is installed, `timedatectl` steps back to let `chrony` handle timekeeping. This ensures that no two time-syncing services can conflict with each other.
如果安装了 `chrony` ，则 `timedatectl` 后退一步，让 `chrony` 处理计时。这确保了没有两个时间同步服务可以相互冲突。

`ntpdate` is now considered deprecated in favor of `timedatectl` (or `chrony`) and is no longer installed by default. `timesyncd` will generally keep your time in sync, and `chrony` will help with more complex cases. But if you had one of a few known special `ntpdate` use cases, consider the following:
 `ntpdate` 现在被认为是不推荐使用的，而支持 `timedatectl` （或 `chrony` ），并且默认情况下不再安装。 `timesyncd` 通常会让你的时间保持同步， `chrony` 将有助于更复杂的情况。但是，如果你有几个已知的特殊 `ntpdate` 用例之一，请考虑以下内容：

- If you require a one-shot sync, use: `chronyd -q`
  如果需要单次同步，请使用：用途： `chronyd -q` 
- If you require a one-shot time check (without setting the time), use: `chronyd -Q`
  如果需要一次性时间检查（不设置时间），请使用：用途： `chronyd -Q` 

While use of `ntpd` is no longer recommended, this also still applies to `ntpd` being installed to retain any previous behaviour/config that you had  through an upgrade. However, it also implies that on an upgrade from a  former release, `ntp`/`ntpdate` might still be installed and therefore renders the new `systemd`-based services disabled.
虽然不再推荐使用 `ntpd` ，但这仍然适用于安装的 `ntpd` ，以保留您通过升级获得的任何以前的行为/配置。但是，这也意味着在从以前的版本升级时，可能仍然会安装 `ntp` / `ntpdate` ，因此会禁用基于 `systemd` 的新服务。

## Further reading 进一步阅读 

- [ntp.org: home of the Network Time Protocol project
   ntp.org：网络时间协议项目的主页](http://www.ntp.org/)
- [pool.ntp.org: project of virtual cluster of timeservers
   pool.ntp.org：时间服务器虚拟集群项目](http://www.pool.ntp.org/)
- [Freedesktop.org info on timedatectl](https://www.freedesktop.org/software/systemd/man/timedatectl.html)
- [Freedesktop.org info on systemd-timesyncd service
   Freedesktop.org关于systemd-timesyncd服务的信息](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html#)
- [Chrony FAQ Chrony常见问题](https://chrony.tuxfamily.org/faq.html)
- [Feeding chrony from GPSD
   来自GPSD的进食时间](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)
- Also see the [Ubuntu Time wiki page](https://help.ubuntu.com/community/UbuntuTime) for more information.
  更多信息请参见Ubuntu Time wiki页面。

------

# About DPDK 关于DPDK 

The Data Plane Development Kit (DPDK) is a set of libraries and drivers for fast packet processing, which runs mostly in Linux userland. This set  of libraries provides the so-called “Environment Abstraction Layer”  (EAL). The EAL hides the details of the environment and provides a  standard programming interface. Common use cases are around special  solutions, such as network function virtualisation and advanced  high-throughput network switching.
数据平面开发工具包（DPDK）是一组用于快速数据包处理的库和驱动程序，主要运行在Linux用户环境中。这组库提供了所谓的“环境抽象层”（EAL）。EAL隐藏了环境的细节，并提供了一个标准的编程接口。常见的用例是围绕特殊解决方案，例如网络功能虚拟化和高级高吞吐量网络交换。 

The DPDK uses a run-to-completion model for fast data plane performance and accesses devices via polling to eliminate the latency of interrupt  processing, albeit with the tradeoff of higher CPU consumption. It was  designed to run on any processor. The first supported CPU was Intel x86  and it is now extended to IBM PPC64 and ARM64.
DPDK使用运行到完成模型来实现快速数据平面性能，并通过轮询访问设备以消除中断处理的延迟，尽管代价是更高的CPU消耗。它被设计为在任何处理器上运行。第一个支持的CPU是Intel x86，现在扩展到IBM PPC 64和ARM 64。 

Ubuntu provides some additional infrastructure to increase DPDK’s usability.
Ubuntu提供了一些额外的基础设施来增加DPDK的可用性。 

## Prerequisites 先决条件 

This package is currently compiled for the lowest possible CPU requirements allowed by upstream. Starting with [DPDK 17.08](https://git.dpdk.org/dpdk/commit/?id=f27769f796a0639368117ce22fb124b6030dbf73), that means it requires at least SSE4_2 and for anything else activated by -march=corei7 (in GCC) to be supported by the CPU.
这个包目前是为上游允许的最低CPU要求编译的。从DPDK 17.08开始，这意味着它至少需要SSE4_2以及由—march = corei7（在GCC中）激活的任何其他内容才能得到CPU的支持。

The list of upstream DPDK-supported network cards can be found at [supported NICs](http://dpdk.org/doc/nics). However, a lot of those are disabled by default in the upstream project as they are not yet in a stable state. The subset of network cards that DPDK has enabled in the package (as available in Ubuntu 16.04) is:
上游DPDK支持的网卡列表可以在supported URL中找到。但是，由于它们尚未处于稳定状态，因此在上游项目中默认情况下禁用了其中的许多功能。DPDK在软件包中启用的网卡子集（在Ubuntu 16.04中可用）是：

DPDK has “userspace” drivers for the cards called PMDs.
DPDK有“用户空间”驱动程序，用于称为PMD的卡。
 The packages for these follow the pattern of `librte-pmd-<type>-<version>`. Therefore the example for an Intel e1000 in 18.11 would be `librte-pmd-e1000-18.11`.
 这些包遵循 `librte-pmd-<type>-<version>` 的模式。因此，18.11中英特尔e1000的示例为 `librte-pmd-e1000-18.11` 。

The more commonly used, tested and fully supported drivers are installed as dependencies of `dpdk`. But there are [many more “in-universe”](https://help.ubuntu.com/community/Repositories/Ubuntu#The_Four_Main_Repositories) that follow the same naming pattern.
更常用、测试和完全支持的驱动程序作为 `dpdk` 的依赖项安装。但是还有更多的“宇宙中”遵循相同的命名模式。

## 

## Unassign the default kernel drivers  取消分配默认内核驱动程序 

Cards must be unassigned from their kernel driver and instead be assigned to `uio_pci_generic` of `vfio-pci`. `uio_pci_generic` is older and it’s (usually) easier to get it to work. However, it also has fewer features and less isolation.
卡必须从其内核驱动程序中取消分配，而是分配给 `vfio-pci` 中的 `uio_pci_generic` 。 `uio_pci_generic` 是旧的，它（通常）更容易让它工作。然而，它也有更少的功能和更少的隔离。

The newer VFIO-PCI requires that you activate the following kernel  parameters to enable the input-output memory management unit (IOMMU):
较新的VFIO-PCI要求您激活以下内核参数以启用输入输出内存管理单元（IOMMU）： 

```auto
iommu=pt intel_iommu=on          
```

Alternatively, on AMD: 或者，在AMD上： 

```auto
amd_iommu=pt
```

On top of VFIO-PCI, you must also configure and assign the IOMMU groups  accordingly. This is mostly done in firmware and by hardware layout –  you can check the group assignment the kernel probed in `/sys/kernel/iommu_groups/`.
在VFIO-PCI之上，您还必须相应地配置和分配IOMMU组。这主要是在固件和硬件布局中完成的-您可以检查内核在 `/sys/kernel/iommu_groups/` 中探测的组分配。

> **Note**: 注意：
>  VirtIO is special. DPDK can directly work on these devices without `vfio_pci`/`uio_pci_generic`. However, to avoid issues that might arise from the kernel and DPDK  managing the device, you still need to unassign the kernel driver.
>  Virtio很特别。DPDK可以直接在这些设备上工作，而无需 `vfio_pci` / `uio_pci_generic` 。但是，为了避免内核和DPDK管理设备时可能出现的问题，您仍然需要取消分配内核驱动程序。

Manual configuration and status checks can be done via `sysfs`, or with the tool `dpdk_nic_bind`:
手动配置和状态检查可通过 `sysfs` 或工具 `dpdk_nic_bind` 完成：

```auto
dpdk_nic_bind.py --help
```

## Usage 使用 

```auto
dpdk-devbind.py [options] DEVICE1 DEVICE2 ....

where DEVICE1, DEVICE2 etc, are specified via PCI "domain:bus:slot.func" syntax
or "bus:slot.func" syntax. For devices bound to Linux kernel drivers, they may
also be referred to by Linux interface name e.g. eth0, eth1, em0, em1, etc.

Options:
--help, --usage:
    Display usage information and quit

-s, --status:
    Print the current status of all known network, crypto, event
    and mempool devices.
    For each device, it displays the PCI domain, bus, slot and function,
    along with a text description of the device. Depending upon whether the
    device is being used by a kernel driver, the igb_uio driver, or no
    driver, other relevant information will be displayed:
    * the Linux interface name e.g. if=eth0
    * the driver being used e.g. drv=igb_uio
    * any suitable drivers not currently using that device
        e.g. unused=igb_uio
    NOTE: if this flag is passed along with a bind/unbind option, the
    status display will always occur after the other operations have taken
    place.

--status-dev:
    Print the status of given device group. Supported device groups are:
    "net", "crypto", "event", "mempool" and "compress"

-b driver, --bind=driver:
    Select the driver to use or "none" to unbind the device

-u, --unbind:
    Unbind a device (Equivalent to "-b none")

--force:
    By default, network devices which are used by Linux - as indicated by
    having routes in the routing table - cannot be modified. Using the
    --force flag overrides this behavior, allowing active links to be
    forcibly unbound.
    WARNING: This can lead to loss of network connection and should be used
    with caution.

Examples:
---------

To display current device status:
    dpdk-devbind.py --status

To display current network device status:
    dpdk-devbind.py --status-dev net

To bind eth1 from the current driver and move to use igb_uio
    dpdk-devbind.py --bind=igb_uio eth1

To unbind 0000:01:00.0 from using any driver
    dpdk-devbind.py -u 0000:01:00.0

To bind 0000:02:00.0 and 0000:02:00.1 to the ixgbe kernel driver
    dpdk-devbind.py -b ixgbe 02:00.0 02:00.1
```

## DPDK device configuration DPDK设备配置 



The package `dpdk` provides *init* scripts that ease configuration of device assignment and huge pages. It also makes them persistent across reboots.                                      

​                    重试                                       

​                    错误原因                        

The following is an example of the file `/etc/dpdk/interfaces` configuring two ports of a network card: one with `uio_pci_generic` and the other with `vfio-pci`.                                      

​                    重试                                       

​                    错误原因                        

```auto
# <bus>         Currently only "pci" is supported
# <id>          Device ID on the specified bus
# <driver>      Driver to bind against (vfio-pci or uio_pci_generic)
#
# Be aware that the two DPDK compatible drivers uio_pci_generic and vfio-pci are
# part of linux-image-extra-<VERSION> package.
# This package is not always installed by default - for example in cloud-images.
# So please install it in case you run into missing module issues.
#
# <bus> <id>     <driver>
pci 0000:04:00.0 uio_pci_generic
pci 0000:04:00.1 vfio-pci     
```

Cards are identified by their PCI-ID. If you are need to check, you can use the tool `dpdk_nic_bind.py` to show the currently available devices – and the drivers they are assigned to. For example, running the command `dpdk_nic_bind.py --status` provides the following details:                                      

​                    重试                                       

​                    错误原因                        

```auto
Network devices using DPDK-compatible driver
============================================
0000:04:00.0 'Ethernet Controller 10-Gigabit X540-AT2' drv=uio_pci_generic unused=ixgbe

Network devices using kernel driver
===================================
0000:02:00.0 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth0 drv=tg3 unused=uio_pci_generic *Active*
0000:02:00.1 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth1 drv=tg3 unused=uio_pci_generic
0000:02:00.2 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth2 drv=tg3 unused=uio_pci_generic
0000:02:00.3 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth3 drv=tg3 unused=uio_pci_generic
0000:04:00.1 'Ethernet Controller 10-Gigabit X540-AT2' if=eth5 drv=ixgbe unused=uio_pci_generic

Other network devices
=====================
<none>
```

## DPDK hugepage configuration DPDK巨页配置 

DPDK makes heavy use of hugepages to eliminate pressure on the translation  lookaside buffer (TLB). Therefore, hugepages need to be configured in  your system. The `dpdk` package has a config file and scripts that try to ease hugepage configuration for DPDK in the form of `/etc/dpdk/dpdk.conf`.
DPDK大量使用大页面来消除翻译后备缓冲区（TLB）的压力。因此，需要在系统中配置hugepages。 `dpdk` 包有一个配置文件和脚本，试图以 `/etc/dpdk/dpdk.conf` 的形式简化DPDK的大页面配置。

If you have more consumers of hugepages than just DPDK in your system – or very special requirements for how your hugepages will be set up – you  likely want to allocate/control them yourself. If not, this can be a  great simplification to get DPDK configured for your needs.
如果您的系统中有比DPDK更多的hugepage消费者-或者对如何设置hugepage有非常特殊的要求-您可能希望自己分配/控制它们。如果没有，这可以极大地简化DPDK的配置以满足您的需求。 

As an example, we can specify a configuration of 1024 hugepages of 2M each and four 1G pages in `/etc/dpdk/dpdk.conf` by adding:
例如，我们可以在 `/etc/dpdk/dpdk.conf` 中指定1024个2 M的大页面和4个1G页面的配置，方法是添加：

```auto
NR_2M_PAGES=1024
NR_1G_PAGES=4
```

This supports configuring 2M and the larger 1G hugepages (or a mix of both). It will make sure there are proper `hugetlbfs` mountpoints for DPDK to find both sizes – no matter what size your  default hugepage is. The config file itself holds more details on  certain corner cases and a few hints if you want to allocate hugepages  manually via a kernel parameter.
这支持配置2 M和更大的1G hugepages（或两者的混合）。它将确保有适当的 `hugetlbfs` 挂载点DPDK找到这两个大小-无论什么大小您的默认hugepage是。如果你想通过内核参数手动分配hugepages，配置文件本身包含了一些关于某些极端情况的细节和一些提示。

The size you want depends on your needs: 1G pages are certainly more  effective regarding TLB pressure, but there have been reports of them  fragmenting inside the DPDK memory allocations. Also, it can be harder  to find enough free space to set up a certain number of 1G pages later  in the life-cycle of a system.
您想要的大小取决于您的需求：1G页面在TLB压力方面肯定更有效，但有报告称它们在DPDK内存分配中碎片化。此外，在系统生命周期的后期，很难找到足够的可用空间来设置一定数量的1G页面。 

## Compile DPDK applications 编译DPDK应用程序 

Currently, there are not many consumers of the DPDK library that are stable and  released. Open vSwitch DPDK is an exception to that (see below) and more are appearing, but in general it may be that you will want to compile  an app against the library.
目前，没有太多的DPDK库的消费者是稳定的和发布的。Open vSwitch DPDK是一个例外（见下文），更多的出现，但一般来说，你可能会想编译一个应用程序对库。 

You will often find guides that tell you to fetch the DPDK sources, build  them to your needs and eventually build your application based on DPDK  by setting values `RTE_*` for the build system. Since Ubuntu provides an already-compiled DPDK for you can can skip all that.
你经常会发现一些指导，告诉你获取DPDK源代码，根据你的需要构建它们，并最终通过为构建系统设置值 `RTE_*` 来基于DPDK构建你的应用程序。由于Ubuntu提供了一个已经编译好的DPDK，你可以跳过这一切。

DPDK provides a [valid pkg-config file](https://people.freedesktop.org/~dbn/pkg-config-guide.html) to simplify setting the proper variables and options:
DPDK提供了有效的pkg-config文件来简化设置适当的变量和选项：

```auto
sudo apt-get install dpdk-dev libdpdk-dev
gcc testdpdkprog.c $(pkg-config --libs --cflags libdpdk) -o testdpdkprog
```

An example of a complex (auto-configure) user of pkg-config of DPDK  including fallbacks to older non pkg-config style can be seen in the [Open vSwitch build system](https://github.com/openvswitch/ovs/blob/master/acinclude.m4#L283).
在Open vSwitch构建系统中可以看到DPDK的pkg-config的复杂（自动配置）用户的示例，包括回退到旧的非pkg-config样式。

Depending on what you are building, it may be a good idea to install all DPDK  build dependencies before the make. On Ubuntu, this can be done  automatically with the following command:
根据您正在构建的内容，在make之前安装所有DPDK构建依赖项可能是一个好主意。在Ubuntu上，这可以通过以下命令自动完成： 

```auto
sudo apt-get install build-dep dpdk
```

## DPDK in KVM guests KVM来宾中的DPDK 

Even if you have no access to DPDK-supported network cards, you can still  work with DPDK by using its support for VirtIO. To do so, you must  create guests backed by hugepages (see above). In addition, you will  also need to have *at least* Streaming SIMD Extensions 3 (SSE3).
即使您无法访问支持DPDK的网卡，您仍然可以通过使用其对VirtIO的支持来使用DPDK。为此，您必须创建由hugepages支持的访客（见上文）。此外，您还需要至少具有Streaming SIMD Extensions 3（SSE 3）。

The default CPU model used by QEMU/libvirt is only up to SSE2. So, you will need to define a model that passes the proper feature flags (or use `host-passthrough`). As an example, you can add the following snippet to your virsh XML (or the equivalent virsh interface you use).
QEMU/libvirt使用的默认CPU型号最高为SSE 2。因此，您需要定义一个传递适当特征标志（或使用 `host-passthrough` ）的模型。例如，您可以将以下代码片段添加到virsh XML（或您使用的等效virsh接口）。

```auto
<cpu mode='host-passthrough'>
```

Nowadays, VirtIO supports multi-queue, which DPDK in turn can exploit for  increased speed. To modify a normal VirtIO definition to have multiple  queues, add the following snippet to your interface definition.
如今，VirtIO支持多队列，DPDK反过来可以利用它来提高速度。要修改普通VirtIO定义以拥有多个队列，请将以下代码片段添加到接口定义中。 

```auto
<driver name="vhost" queues="4"/>
```

This will enhance a normal VirtIO NIC to have multiple queues, which can later be consumed by e.g., DPDK in the guest.
这将增强普通的VirtIO NIC，使其具有多个队列，这些队列稍后可以由例如，DPDK在来宾中。 

## Use DPDK 使用DPDK 

Since DPDK itself is only a (massive) library, you most likely will continue to [Open vSwitch DPDK](https://ubuntu.com/server/docs/how-to-use-dpdk-with-open-vswitch) as an example to put it to use.
由于DPDK本身只是一个（大型）库，因此您很可能会继续使用Open vSwitch DPDK作为示例来使用它。

## Resources 资源 

- [DPDK documentation DPDK文档](http://dpdk.org/doc)
- [Release Notes matching the version packages in Ubuntu 16.04
   与Ubuntu 16.04中的版本包相匹配的发行说明](http://dpdk.org/doc/guides/rel_notes/release_2_2.html)
- [Linux DPDK user getting started
   Linux DPDK用户入门](http://dpdk.org/doc/guides/linux_gsg/index.html)
- [EAL command-line options
   EAL命令行选项](http://dpdk.org/doc/guides/testpmd_app_ug/run_app.html)
- [DPDK API documentation DPDK API文档](http://dpdk.org/doc/api/)
- [Open vSwitch DPDK installation
   打开vSwitch DPDK安装](https://github.com/openvswitch/ovs/blob/branch-2.5/INSTALL.DPDK.md)
- [Wikipedia definition of DPDK
   维基百科对DPDK的定义](https://en.wikipedia.org/wiki/Data_Plane_Development_Kit)

------

# OpenVPN client implementations OpenVPN客户端实现 

## Linux Network-Manager GUI for OpenVPN 用于OpenVPN的Linux网络管理器GUI 

Many Linux distributions (including Ubuntu Desktop variants) come with  Network Manager; a GUI to configure your network settings. It also can  manage your VPN connections. It is the default, but if in doubt make  sure you have the `network-manager-openvpn` package installed.
许多Linux发行版（包括Ubuntu Desktop变体）都带有网络管理器;一个配置网络设置的GUI。它还可以管理您的VPN连接。它是默认的，但是如果有疑问，请确保您安装了 `network-manager-openvpn` 包。

- Open the Network Manager GUI, select the VPN tab and then the ‘Add’ button
  打开网络管理器GUI，选择VPN选项卡，然后选择“添加”按钮 

- Select OpenVPN as the VPN type in the opening requester and press ‘Create’
  选择OpenVPN作为开放请求中的VPN类型，然后按“创建” 

- In the next window, add the OpenVPN’s server name as the ‘Gateway’

  
  在下一个窗口中，添加OpenVPN的服务器名称为“网关” 

  - Set ‘Type’ to ‘Certificates (TLS)’
    将“类型”设置为“证书（TLS）” 
  - Point ‘User Certificate’ to your user certificate
    将“用户证书”指向您的用户证书 
  - Point ‘CA Certificate’ to your CA certificate
    将“CA证书”指向您的CA证书 
  - Point ‘Private Key’ to your private key file.
    将“私钥”指向您的私钥文件。 

- Use the ‘advanced’ button to enable compression (e.g. `comp-lzo`), dev tap, or other special settings you want to set on the server. Now try to establish your VPN.
  使用“高级”按钮来启用压缩（例如 `comp-lzo` ）、dev tap或您想要在服务器上设置的其他特殊设置。现在尝试建立您的VPN。

## OpenVPN with GUI for Mac OS X

[Tunnelblick](https://tunnelblick.net) is an excellent free, open source implementation of a GUI for OpenVPN  for OS X. Download the latest OS X installer from there and install it.
 Tunnelblick是一个优秀的免费，开源的GUI实现OpenVPN的OS X。从那里下载最新的OS X安装程序并安装它。

It also is [recommended by upstream](https://openvpn.net/vpn-server-resources/connecting-to-access-server-with-macos/#alternative-openvpn-open-source-tunnelblick-program), which [has an alternative](https://openvpn.net/vpn-server-resources/installation-guide-for-openvpn-connect-client-on-macos/) of their own.
它也是上游公司推荐的，上游公司有自己的替代方案。

Then put your `client.ovpn` config file together with the certificates and keys in `/Users/username/Library/Application Support/Tunnelblick/Configurations/` and launch Tunnelblick from your ‘Application’ folder.
然后将 `client.ovpn` 配置文件与证书和密钥放在 `/Users/username/Library/Application Support/Tunnelblick/Configurations/` 中，并从“应用程序”文件夹中启动Tunnelblick。

Instead of downloading manually, if you have brew set up on MacOS this is as easy as running:
如果你在MacOS上设置了brew，而不是手动下载，这就像运行一样简单： 

```
brew cask install tunnelblick
```

## OpenVPN with GUI for Win OpenVPN与GUI for Win 

First, download and install the latest [OpenVPN Windows Installer](https://openvpn.net/community-downloads/). As of this writing, the management GUI is included with the Windows binary installer.
首先，下载并安装最新的OpenVPN Windows SDK。在撰写本文时，管理GUI包含在Windows二进制安装程序中。

You need to start the OpenVPN service. Go to Start > Computer >  Manage > Services and Applications > Services. Find the OpenVPN  service and start it. Set its startup type to ‘automatic’.
您需要启动OpenVPN服务。转到开始>计算机>管理>服务和应用程序>服务。找到OpenVPN服务并启动它。将其启动类型设置为“自动”。 

When you start the OpenVPN MI GUI the first time you need to run it as an  administrator. You have to right click on it and you will see that  option.
当您第一次启动OpenVPN MI GUI时，您需要以管理员身份运行它。你必须右键单击它，你会看到这个选项。 

There is an [updated guide by the upstream](https://community.openvpn.net/openvpn/wiki/Easy_Windows_Guide) project for the client on Windows.
上游项目为Windows上的客户端提供了更新的指南。

## Further reading 进一步阅读 

- See the [OpenVPN](http://openvpn.net/) website for additional information.
  请参阅OpenVPN网站以获取更多信息。
- [OpenVPN hardening security guide
   OpenVPN强化安全指南](http://openvpn.net/index.php/open-source/documentation/howto.html#security)
- Also, Pakt’s [OpenVPN: Building and Integrating Virtual Private Networks](http://www.packtpub.com/openvpn/book) is a good resource.
  此外，Pakt的OpenVPN：构建和集成虚拟专用网络是一个很好的资源。

------

# Certificates 证书 

One of the most common forms of cryptography today is *public-key* cryptography. Public-key cryptography utilizes a *public key* and a *private key*. The system works by encrypting information using the public key. The  information can then only be decrypted using the private key.
当今最常见的加密形式之一是公钥加密。公钥加密使用公钥和私钥。该系统通过使用公钥加密信息来工作。然后，只能使用私钥对信息进行解密。

A common use for public-key cryptography is encrypting application  traffic using a Secure Socket Layer (SSL) or Transport Layer Security  (TLS) connection. One example: configuring Apache to provide *HTTPS*, the HTTP protocol over SSL/TLS. This allows a way to encrypt traffic using a protocol that does not itself provide encryption.
公钥加密的一个常见用途是使用安全套接字层（SSL）或传输层安全性（TLS）连接对应用程序通信进行加密。一个例子：配置Apache以提供HTTPS，即SSL/TLS上的HTTP协议。这允许使用本身不提供加密的协议来加密流量。

A *certificate* is a method used to distribute a *public key* and other information about a server and the organization who is responsible for it. Certificates can be digitally signed by a *Certification Authority*, or CA. A CA is a trusted third party that has confirmed that the information contained in the certificate is accurate.
证书是一种用于分发公钥以及有关服务器和负责该服务器的组织的其他信息的方法。证书可以由证书颁发机构（CA）进行数字签名。CA是一个受信任的第三方，它已确认证书中包含的信息是准确的。

## Types of Certificates 类型的证书 

To set up a secure server using public-key cryptography, in most cases,  you send your certificate request (including your public key), proof of  your company’s identity, and payment to a CA. The CA verifies the  certificate request and your identity, and then sends back a certificate for your secure server. Alternatively, you can create your own *self-signed* certificate.
要使用公钥加密设置安全服务器，在大多数情况下，您需要向CA发送证书请求（包括公钥）、公司身份证明和付款。CA验证证书请求和您的身份，然后为您的安全服务器发回证书。或者，您可以创建自己的自签名证书。

> **Note 注意**
>
> Note that self-signed certificates should not be used in most production environments.
> 请注意，在大多数生产环境中不应使用自签名证书。 

Continuing the HTTPS example, a CA-signed certificate provides two important  capabilities that a self-signed certificate does not:
继续HTTPS示例，CA签名的证书提供了自签名证书所不具备的两个重要功能： 

- Browsers (usually) automatically recognize the CA signature and allow a secure connection to be made without prompting the user.
  浏览器（通常）自动识别CA签名，并允许在不提示用户的情况下进行安全连接。 
- When a CA issues a signed certificate, it is guaranteeing the identity of  the organization that is providing the web pages to the browser.
  当CA颁发签名证书时，它保证向浏览器提供网页的组织的身份。 

Most of the software supporting SSL/TLS have a list of CAs whose  certificates they automatically accept. If a browser encounters a  certificate whose authorizing CA is not in the list, the browser asks  the user to either accept or decline the connection. Also, other  applications may generate an error message when using a self-signed  certificate.
大多数支持SSL/TLS的软件都有一个自动接受其证书的CA列表。如果浏览器遇到其授权CA不在列表中的证书，浏览器将要求用户接受或拒绝连接。此外，其他应用程序在使用自签名证书时可能会生成错误消息。 

The process of getting a certificate from a CA is fairly easy. A quick overview is as follows:
从CA获得证书的过程相当简单。简要概述如下： 

1. Create a private and public encryption key pair.
   创建私有和公共加密密钥对。 

2. Create a certificate signing request based on the public key. The certificate  request contains information about your server and the company hosting  it.
   根据公钥创建证书签名请求。证书请求包含有关服务器及其托管公司的信息。 

3. Send the certificate request, along with documents proving your identity, to a CA. We cannot tell you which certificate authority to choose. Your  decision may be based on your past experiences, or on the experiences of your friends or colleagues, or purely on monetary factors.
   将证书请求连同证明您身份的文档沿着发送给CA。我们无法告诉您选择哪个证书颁发机构。你的决定可能是基于你过去的经验，或者你的朋友或同事的经验，或者纯粹是基于金钱因素。 

   Once you have decided upon a CA, you need to follow the instructions they provide on how to obtain a certificate from them.
   一旦你决定了一个CA，你需要遵循他们提供的关于如何从他们那里获得证书的说明。 

4. When the CA is satisfied that you are indeed who you claim to be, they send you a digital certificate.
   当CA确信您确实是您所声称的人时，他们会向您发送数字证书。 

5. Install this certificate on your secure server, and configure the appropriate applications to use the certificate.
   在安全服务器上安装此证书，并配置相应的应用程序以使用此证书。 

## Generating a Certificate Signing Request (CSR) 生成证书签名请求（CSR） 

Whether you are getting a certificate from a CA or generating your own  self-signed certificate, the first step is to generate a key.
无论您是从CA获取证书还是生成自己的自签名证书，第一步都是生成密钥。 

If the certificate will be used by service daemons, such as Apache,  Postfix, Dovecot, etc., a key without a passphrase is often appropriate. Not having a passphrase allows the services to start without manual  intervention, usually the preferred way to start a daemon.
如果证书将由服务守护进程（如Apache、Postfix、Dovecot等）使用，没有密码短语的密钥通常是合适的。没有密码允许服务在没有手动干预的情况下启动，这通常是启动守护程序的首选方式。 

This section will cover generating a key with a passphrase, and one without. The non-passphrase key will then be used to generate a certificate that can be used with various service daemons.
本节将介绍如何生成一个带密码短语的密钥和一个不带密码短语的密钥。然后将使用非密码密钥生成可用于各种服务守护进程的证书。 

> **Warning 警告**
>
> Running your secure service without a passphrase is convenient because you will not need to enter the passphrase every time you start your secure  service. But it is insecure and a compromise of the key means a  compromise of the server as well.
> 在没有密码的情况下运行安全服务非常方便，因为您不需要在每次启动安全服务时都输入密码。但它是不安全的，密钥的泄露也意味着服务器的泄露。 

To generate the *keys* for the Certificate Signing Request (CSR) run the following command from a terminal prompt:
要为证书签名请求（CSR）生成密钥，请在终端提示符下运行以下命令：

```
openssl genrsa -des3 -out server.key 2048

Generating RSA private key, 2048 bit long modulus
..........................++++++
.......++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:
```

You can now enter your passphrase. For best security, it should at least  contain eight characters. The minimum length when specifying `-des3` is four characters. As a best practice it should include numbers and/or punctuation and not be a word in a dictionary. Also remember that your  passphrase is case-sensitive.
您现在可以输入您的密码。为了达到最佳安全性，它至少应该包含八个字符。指定 `-des3` 时的最小长度为四个字符。作为最佳实践，它应该包括数字和/或标点符号，而不是字典中的单词。还请记住，您的密码是区分大小写的。

Re-type the passphrase to verify. Once you have re-typed it correctly, the server key is generated and stored in the `server.key` file.
重新键入密码以进行验证。一旦您正确地重新键入它，服务器密钥将生成并存储在 `server.key` 文件中。

Now create the insecure key, the one without a passphrase, and shuffle the key names:
现在创建一个不安全的密钥，一个没有密码的密钥，然后打乱密钥名： 

```
openssl rsa -in server.key -out server.key.insecure
mv server.key server.key.secure
mv server.key.insecure server.key
```

The insecure key is now named `server.key`, and you can use this file to generate the CSR without passphrase.
不安全密钥现在命名为 `server.key` ，您可以使用此文件生成不带密码的CSR。

To create the CSR, run the following command at a terminal prompt:
要创建CSR，请在终端提示符下运行以下命令： 

```
openssl req -new -key server.key -out server.csr
```

It will prompt you enter the passphrase. If you enter the correct  passphrase, it will prompt you to enter Company Name, Site Name, Email  Id, etc. Once you enter all these details, your CSR will be created and  it will be stored in the `server.csr` file.
它会提示您输入密码。如果您输入了正确的密码，它将提示您输入公司名称、站点名称、电子邮件ID等。一旦您输入了所有这些详细信息，您的CSR将被创建并存储在 `server.csr` 文件中。

You can now submit this CSR file to a CA for processing. The CA will use  this CSR file and issue the certificate. On the other hand, you can  create self-signed certificate using this CSR.
您现在可以将此CSR文件提交给CA进行处理。CA将使用此CSR文件并颁发证书。另一方面，您可以使用此CSR创建自签名证书。 

## Creating a Self-Signed Certificate 创建自签名证书 

To create the self-signed certificate, run the following command at a terminal prompt:
要创建自签名证书，请在终端提示符下运行以下命令： 

```
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

The above command will prompt you to enter the passphrase. Once you enter  the correct passphrase, your certificate will be created and it will be  stored in the `server.crt` file.
上面的命令将提示您输入密码。输入正确的密码后，将创建证书并将其存储在 `server.crt` 文件中。

> **Warning 警告**
>
> If your secure server is to be used in a production environment, you  probably need a CA-signed certificate. It is not recommended to use  self-signed certificate.
> 如果您的安全服务器要在生产环境中使用，您可能需要CA签名的证书。不建议使用自签名证书。 

## Installing the Certificate 安装证书 

You can install the key file `server.key` and certificate file `server.crt`, or the certificate file issued by your CA, by running following commands at a terminal prompt:
您可以在终端提示符下运行以下命令，安装密钥文件 `server.key` 和证书文件 `server.crt` ，或者安装您的CA颁发的证书文件：

```
sudo cp server.crt /etc/ssl/certs
sudo cp server.key /etc/ssl/private
```

Now simply configure any applications, with the ability to use public-key cryptography, to use the *certificate* and *key* files. For example, Apache can provide HTTPS, Dovecot can provide IMAPS and POP3S, etc.
现在，只需配置任何能够使用公钥加密的应用程序，即可使用证书和密钥文件。例如，Apache可以提供HTTPS，Dovecot可以提供IMAPS和POP 3S等。

## Certification Authority 证书颁发机构 

If the services on your network require more than a few self-signed  certificates it may be worth the additional effort to setup your own  internal Certification Authority (CA). Using certificates signed by your own CA, allows the various services using the certificates to easily  trust other services using certificates issued from the same CA.
如果您网络上的服务需要多个自签名证书，则可能值得额外设置您自己的内部证书颁发机构（CA）。使用由您自己的CA签名的证书，允许使用证书的各种服务轻松信任使用从同一CA颁发的证书的其他服务。 

First, create the directories to hold the CA certificate and related files:
首先，创建保存CA证书和相关文件的目录： 

```
sudo mkdir /etc/ssl/CA
sudo mkdir /etc/ssl/newcerts
```

The CA needs a few additional files to operate, one to keep track of the  last serial number used by the CA, each certificate must have a unique  serial number, and another file to record which certificates have been  issued:
CA需要一些额外的文件来进行操作，一个文件用于跟踪CA使用的最后一个序列号，每个证书必须具有唯一的序列号，另一个文件用于记录已颁发的证书： 

```
sudo sh -c "echo '01' > /etc/ssl/CA/serial"
sudo touch /etc/ssl/CA/index.txt
```

The third file is a CA configuration file. Though not strictly necessary,  it is very convenient when issuing multiple certificates. Edit `/etc/ssl/openssl.cnf`, and in the *[ CA_default ]* change:
第三个文件是CA配置文件。虽然不是严格必要的，但在颁发多个证书时非常方便。编辑 `/etc/ssl/openssl.cnf` ，并在[ CA_default ]中更改：

```
dir             = /etc/ssl              # Where everything is kept
database        = $dir/CA/index.txt     # database index file.
certificate     = $dir/certs/cacert.pem # The CA certificate
serial          = $dir/CA/serial        # The current serial number
private_key     = $dir/private/cakey.pem# The private key
```

Next, create the self-signed root certificate:
接下来，创建自签名根证书： 

```
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
```

You will then be asked to enter the details about the certificate.
然后，系统将要求您输入有关证书的详细信息。 

Now install the root certificate and key:
现在安装根证书和密钥： 

```
sudo mv cakey.pem /etc/ssl/private/
sudo mv cacert.pem /etc/ssl/certs/
```

You are now ready to start signing certificates. The first item needed is a Certificate Signing Request (CSR), see [Generating a Certificate Signing Request (CSR)](https://ubuntu.com/server/docs/certificates#generating-a-csr) for details. Once you have a CSR, enter the following to generate a certificate signed by the CA:
您现在可以开始签署证书了。第一个需要的项目是证书签名请求（CSR），请参阅生成证书签名请求（CSR）了解详细信息。有了CSR后，输入以下内容以生成由CA签名的证书：

```
sudo openssl ca -in server.csr -config /etc/ssl/openssl.cnf
```

After entering the password for the CA key, you will be prompted to sign the  certificate, and again to commit the new certificate. You should then  see a somewhat large amount of output related to the certificate  creation.
输入CA密钥的密码后，系统将提示您签署证书，然后再次提交新证书。然后，您应该看到与证书创建相关的大量输出。 

There should now be a new file, `/etc/ssl/newcerts/01.pem`, containing the same output. Copy and paste everything beginning with the line: *-----BEGIN CERTIFICATE-----* and continuing through the line: *----END CERTIFICATE-----* lines to a file named after the hostname of the server where the certificate will be installed. For example `mail.example.com.crt`, is a nice descriptive name.
现在应该有一个新文件 `/etc/ssl/newcerts/01.pem` ，包含相同的输出。将以-BEGIN CERTIFICATE-行开始并一直到-END CERTIFICATE-行的所有内容复制并粘贴到一个以将安装证书的服务器的主机名命名的文件中。例如， `mail.example.com.crt` 是一个很好的描述性名称。

Subsequent certificates will be named `02.pem`, `03.pem`, etc.
后续证书将命名为 `02.pem` 、 `03.pem` 等。

> **Note 注意**
>
> Replace *mail.example.com.crt* with your own descriptive name.
> 将mail.example.com.crt替换为您自己的描述性名称。

Finally, copy the new certificate to the host that needs it, and configure the  appropriate applications to use it. The default location to install  certificates is `/etc/ssl/certs`. This enables multiple services to use the same certificate without overly complicated file permissions.
最后，将新证书复制到需要它的主机，并配置相应的应用程序来使用它。安装证书的默认位置是 `/etc/ssl/certs` 。这使得多个服务可以使用同一个证书，而无需过于复杂的文件权限。

For applications that can be configured to use a CA certificate, you should also copy the `/etc/ssl/certs/cacert.pem` file to the `/etc/ssl/certs/` directory on each server.
对于可以配置为使用CA证书的应用程序，还应将 `/etc/ssl/certs/cacert.pem` 文件复制到每台服务器上的 `/etc/ssl/certs/` 目录。

## References 引用 

- The Wikipedia [HTTPS](http://en.wikipedia.org/wiki/HTTPS) page has more information regarding HTTPS.
  Wikipedia HTTPS页面有关于HTTPS的更多信息。
- For more information on *OpenSSL* see the [OpenSSL Home Page](https://www.openssl.org/).
  有关OpenSSL的更多信息，请参阅OpenSSL主页。
- Also, O’Reilly’s [Network Security with OpenSSL](http://oreilly.com/catalog/9780596002701/) is a good in-depth reference.
  O'Reilly的Network Security with OpenSSL也是一个很好的深入参考。

------

# OpenSSL

OpenSSL is probably the most well known cryptographic library, used by thousands of projects and applications.
OpenSSL可能是最知名的加密库，被数千个项目和应用程序使用。 

The OpenSSL configuration file is located at `/etc/ssl/openssl.cnf` and is used both by the library itself and the command-line tools  included in the package. It is simple in structure, but quite complex in the details, and it won’t be fully covered here. In particular, we will only cover the settings that control which cryptographic algorithms  will be allowed by default.
OpenSSL配置文件位于 `/etc/ssl/openssl.cnf` ，由库本身和包中包含的命令行工具使用。它的结构很简单，但细节却相当复杂，这里就不一一介绍了。特别是，我们将只讨论控制默认情况下允许哪些加密算法的设置。

## Structure of the config file 配置文件的结构 

The OpenSSL configuration file is very similar to a standard INI file. It  starts with a nameless default section, not inside any `[section]` block, and after that we have the traditional `[section-name]` followed by the `key = value` lines. The [SSL config manpage](https://manpages.ubuntu.com/manpages/jammy/en/man5/config.5ssl.html) has all the details.
OpenSSL配置文件与标准INI文件非常相似。它以一个无名的默认节开始，不在任何 `[section]` 块内，之后是传统的 `[section-name]` ，后面跟着 `key = value` 行。SSL配置手册页有所有的细节。

This is what it looks like:
它看起来是这样的： 

```INI
openssl_conf = <name-of-conf-section>

[name-of-conf-section]
ssl_conf = <name-of-ssl-section>

[name-of-ssl-section]
server = <name of section>
client = <name of section>
system_default = <name of section>
```

See how it’s like a chain, where a key (`openssl_conf`) points at the name of a section, and that section has a key that points to another section, and so on.
看看它是如何像一个链，其中一个键（ `openssl_conf` ）指向一个节的名称，而该节有一个键指向另一个节，等等。

To adjust the algorithms and ciphers used in a SSL/TLS connection, we are  interested in the “SSL Configuration” section of the library, where we  can define the behavior of server, client, and the library defaults.
要调整SSL/TLS连接中使用的算法和密码，我们对库的"SSL配置"部分感兴趣，在那里我们可以定义服务器、客户端和库默认值的行为。 

For example, in an Ubuntu Jammy installation, we have (omitting unrelated entries for brevity):
例如，在Ubuntu Jammy安装中，我们有（为简洁起见，省略不相关的条目）： 

```INI
openssl_conf = openssl_init

[openssl_init]
ssl_conf = ssl_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
CipherString = DEFAULT:@SECLEVEL=2
```

This gives us our first information about the default set of ciphers and algorithms used by OpenSSL in an Ubuntu installation: `DEFAULT:@SECLEVEL=2`. What that means is detailed inside the [SSL_CTX_set_security_level(3) manpage](https://manpages.ubuntu.com/manpages/jammy/en/man3/SSL_CTX_set_security_level.3ssl.html).
这为我们提供了有关OpenSSL在Ubuntu安装中使用的默认密码和算法集的第一个信息： `DEFAULT:@SECLEVEL=2` 。SSL_CTX_set_security_level（3）手册页中详细介绍了这意味着什么。

> **Note**: 注意：
>  In Ubuntu Jammy, TLS versions below 1.2 are **disabled** in OpenSSL’s `SECLEVEL=2` due to [this patch](https://git.launchpad.net/ubuntu/+source/openssl/tree/debian/patches/tls1.2-min-seclevel2.patch?h=ubuntu/jammy-devel).
>  在Ubuntu Jammy中，由于此补丁，OpenSSL的 `SECLEVEL=2` 中禁用了1.2以下的TLS版本。

That default is also set at package building time, and in the case of Ubuntu, it’s [set to `SECLEVEL=2`](https://git.launchpad.net/ubuntu/+source/openssl/tree/debian/rules?h=ubuntu/jammy-devel#n15).
这个默认值也是在包构建时设置的，在Ubuntu的情况下，它被设置为 `SECLEVEL=2` 。

The list of allowed ciphers in a security level can be obtained with the [`openssl ciphers`](https://www.openssl.org/docs/man3.0/man1/openssl-ciphers.html) command (output truncated for brevity):
可以使用 `openssl ciphers` 命令获得安全级别中允许的密码列表（为简洁起见，输出被截断）：

```console
$ openssl ciphers -s -v DEFAULT:@SECLEVEL=2
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(256)            Mac=AEAD
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      Au=any   Enc=CHACHA20/POLY1305(256) Mac=AEAD
TLS_AES_128_GCM_SHA256         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(128)            Mac=AEAD
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256)            Mac=AEAD
(...)
```

> **Note**: 注意：
>  The `openssl ciphers` command will output even ciphers that are not allowed, unless the `-s` switch is given. That option tells the command to list only **supported** ciphers.
>  `openssl ciphers` 命令将输出不允许的密码，除非指定了 `-s` 开关。该选项告诉命令仅列出支持的密码。

All the options that can be set in the `system_default_sect` section are detailed in the [SSL_CONF_cmd manpage](https://manpages.ubuntu.com/manpages/jammy/en/man3/SSL_CONF_cmd.3ssl.html#supported configuration file commands).
SSL_CONF_cmd手册页中详细介绍了可以在 `system_default_sect` 部分中设置的所有选项。

## Cipher strings, cipher suites, cipher lists 密码串密码组密码列表 

Encrypting data (or signing it) is not a one step process. The whole  transformation applied to the source data (until it is in its encrypted  form) has several stages, and each stage typically uses a different  cryptographic algorithm. The combination of these algorithms is called a cipher suite.
加密数据（或签名）不是一个一步到位的过程。应用于源数据的整个转换（直到它处于加密形式）有几个阶段，每个阶段通常使用不同的加密算法。这些算法的组合称为密码套件。 

Similar to GnuTLS, OpenSSL also uses the concept of cipher strings to group  several algorithms and cipher suites together. The full list of cipher  strings is shown in the [`openssl ciphers`](https://www.openssl.org/docs/man3.0/man1/openssl-ciphers.html) manpage.
与GnuTLS类似，OpenSSL也使用密码字符串的概念来将几种算法和密码套件组合在一起。密码字符串的完整列表显示在 `openssl ciphers` 手册页中。

OpenSSL distinguishes the ciphers used with TLSv1.3, and those used with TLSv1.2 and older. Specifically for the `openssl ciphers` command, we have:
OpenSSL区分了TLSv1.3使用的密码和TLSv1.2及更早版本使用的密码。对于 `openssl ciphers` 命令，我们有：

- `-ciphersuites`: used for the TLSv1.3 ciphersuites. So far, there are only five listed in the [upstream documentation](https://www.openssl.org/docs/man3.0/man1/openssl-ciphers.html#TLS-v1.3-cipher-suites), and the defaults are:
   `-ciphersuites` ：用于TLSv1.3密码套件。到目前为止，上游文档中只列出了五个，默认值为：

  TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
  TLS_AES_256_GCM_SHA384：TLS_CHACHA20_POLY1305_SHA256：TLS_AES_128_GCM_SHA256 

- *cipherlist*: this is a plain argument in the command line of the `openssl ciphers` command, without a specific parameter, and is expected to be a list of  cipher strings used in TLSv1.2 and lower. The default in Ubuntu Jammy  22.04 LTS is `DEFAULT:@SECLEVEL=2`.
  密码列表：这是 `openssl ciphers` 命令的命令行中的一个普通参数，没有特定的参数，预计是TLSv1.2和更低版本中使用的密码字符串列表。Ubuntu Jammy 22.04 LTS中的默认值是 `DEFAULT:@SECLEVEL=2` 。

These defaults are built-in in the library, and can be set in `/etc/ssl/openssl.cnf` via the corresponding configuration keys `CipherString` for TLSv1.2 and older, and `CipherSuites` for TLSv1.3. For example:
这些默认值内置在库中，可以在 `/etc/ssl/openssl.cnf` 中通过相应的配置键 `CipherString` （对于TLSv1.2和更早版本）和 `CipherSuites` （对于TLSv1.3）进行设置。举例来说：

```INI
[system_default_sect]
CipherString = DEFAULT:@SECLEVEL=2
CipherSuites = TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
```

In the end, without other constraints, the library will merge both lists  into one set of supported crypto algorithms. If the crypto negotiation  in a connection settles on TLSv1.3, then the list of *CipherSuites* is considered. If it’s TLSv1.2 or lower, then *CipherString* is used.
最后，在没有其他约束的情况下，库将把两个列表合并到一组支持的加密算法中。如果连接中的加密协商解决在TLSv1.3上，则考虑CipherSuite列表。如果是TLSv1.2或更低版本，则使用CipherString。

### `openssl ciphers` examples `openssl ciphers` 示例

This will list all supported/enabled ciphers, with defaults taken from the library and `/etc/ssl/openssl.cnf`. Since no other options were given, this will include TLSv1.3 ciphersuites and TLSv1.2 and older cipher strings:
这将列出所有支持/启用的密码，默认值来自库和 `/etc/ssl/openssl.cnf` 。由于没有给出其他选项，这将包括TLSv1.3密码套件和TLSv1.2及更旧的密码字符串：

```console
$ openssl ciphers -s -v
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(256)            Mac=AEAD
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      Au=any   Enc=CHACHA20/POLY1305(256) Mac=AEAD
TLS_AES_128_GCM_SHA256         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(128)            Mac=AEAD
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256)            Mac=AEAD
ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2 Kx=ECDH     Au=RSA   Enc=AESGCM(256)            Mac=AEAD
DHE-RSA-AES256-GCM-SHA384      TLSv1.2 Kx=DH       Au=RSA   Enc=AESGCM(256)            Mac=AEAD
ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2 Kx=ECDH     Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
DHE-RSA-CHACHA20-POLY1305      TLSv1.2 Kx=DH       Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-ECDSA-AES128-GCM-SHA256  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(128)            Mac=AEAD
ECDHE-RSA-AES128-GCM-SHA256    TLSv1.2 Kx=ECDH     Au=RSA   Enc=AESGCM(128)            Mac=AEAD
DHE-RSA-AES128-GCM-SHA256      TLSv1.2 Kx=DH       Au=RSA   Enc=AESGCM(128)            Mac=AEAD
ECDHE-ECDSA-AES256-SHA384      TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)               Mac=SHA384
ECDHE-RSA-AES256-SHA384        TLSv1.2 Kx=ECDH     Au=RSA   Enc=AES(256)               Mac=SHA384
DHE-RSA-AES256-SHA256          TLSv1.2 Kx=DH       Au=RSA   Enc=AES(256)               Mac=SHA256
ECDHE-ECDSA-AES128-SHA256      TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(128)               Mac=SHA256
ECDHE-RSA-AES128-SHA256        TLSv1.2 Kx=ECDH     Au=RSA   Enc=AES(128)               Mac=SHA256
DHE-RSA-AES128-SHA256          TLSv1.2 Kx=DH       Au=RSA   Enc=AES(128)               Mac=SHA256
ECDHE-ECDSA-AES256-SHA         TLSv1   Kx=ECDH     Au=ECDSA Enc=AES(256)               Mac=SHA1
ECDHE-RSA-AES256-SHA           TLSv1   Kx=ECDH     Au=RSA   Enc=AES(256)               Mac=SHA1
DHE-RSA-AES256-SHA             SSLv3   Kx=DH       Au=RSA   Enc=AES(256)               Mac=SHA1
ECDHE-ECDSA-AES128-SHA         TLSv1   Kx=ECDH     Au=ECDSA Enc=AES(128)               Mac=SHA1
ECDHE-RSA-AES128-SHA           TLSv1   Kx=ECDH     Au=RSA   Enc=AES(128)               Mac=SHA1
DHE-RSA-AES128-SHA             SSLv3   Kx=DH       Au=RSA   Enc=AES(128)               Mac=SHA1
AES256-GCM-SHA384              TLSv1.2 Kx=RSA      Au=RSA   Enc=AESGCM(256)            Mac=AEAD
AES128-GCM-SHA256              TLSv1.2 Kx=RSA      Au=RSA   Enc=AESGCM(128)            Mac=AEAD
AES256-SHA256                  TLSv1.2 Kx=RSA      Au=RSA   Enc=AES(256)               Mac=SHA256
AES128-SHA256                  TLSv1.2 Kx=RSA      Au=RSA   Enc=AES(128)               Mac=SHA256
AES256-SHA                     SSLv3   Kx=RSA      Au=RSA   Enc=AES(256)               Mac=SHA1
AES128-SHA                     SSLv3   Kx=RSA      Au=RSA   Enc=AES(128)               Mac=SHA1
```

Let’s filter this a bit, and just as an example, remove all AES128 ciphers and SHA1 hashes:
让我们过滤一下，作为一个例子，删除所有AES 128密码和SHA1哈希： 

```console
$ openssl ciphers -s -v 'DEFAULTS:-AES128:-SHA1'
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(256)            Mac=AEAD
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      Au=any   Enc=CHACHA20/POLY1305(256) Mac=AEAD
TLS_AES_128_GCM_SHA256         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(128)            Mac=AEAD
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256)            Mac=AEAD
ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2 Kx=ECDH     Au=RSA   Enc=AESGCM(256)            Mac=AEAD
DHE-RSA-AES256-GCM-SHA384      TLSv1.2 Kx=DH       Au=RSA   Enc=AESGCM(256)            Mac=AEAD
ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2 Kx=ECDH     Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
DHE-RSA-CHACHA20-POLY1305      TLSv1.2 Kx=DH       Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-ECDSA-AES256-SHA384      TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)               Mac=SHA384
ECDHE-RSA-AES256-SHA384        TLSv1.2 Kx=ECDH     Au=RSA   Enc=AES(256)               Mac=SHA384
DHE-RSA-AES256-SHA256          TLSv1.2 Kx=DH       Au=RSA   Enc=AES(256)               Mac=SHA256
AES256-GCM-SHA384              TLSv1.2 Kx=RSA      Au=RSA   Enc=AESGCM(256)            Mac=AEAD
AES256-SHA256                  TLSv1.2 Kx=RSA      Au=RSA   Enc=AES(256)               Mac=SHA256
```

Since we didn’t use `-ciphersuites`, the TLSv1.3 list was unaffected by our filtering, and still contains the **AES128** cipher. But TLSv1.2 and older no longer have **AES128** or **SHA1**. This type of filtering with ‘`+`’, ‘`-`’ and ‘`!`’ can be done with the TLSv1.2 and older protocols and is detailed in the [`openssl ciphers` manpage](https://www.openssl.org/docs/man3.0/man1/openssl-ciphers.html#CIPHER-LIST-FORMAT).
由于我们没有使用 `-ciphersuites` ，TLSv1.3列表不受我们过滤的影响，并且仍然包含AES 128密码。但是TLSv1.2和更早的版本不再有AES 128或SHA1。使用“ `+` ”、“ `-` ”和“ `!` ”进行的这种类型的过滤可以使用TLSv1.2和更早的协议完成，在 `openssl ciphers` 手册页中有详细说明。

To filter out TLSv1.3 algorithms, there is no such mechanism, and we must list explicitly what we want by using `-ciphersuites`:
要过滤掉TLSv1.3算法，没有这样的机制，我们必须使用 `-ciphersuites` 明确列出我们想要的：

```console
$ openssl ciphers -s -v -ciphersuites TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256 'DEFAULTS:-AES128:-SHA1'
TLS_AES_256_GCM_SHA384         TLSv1.3 Kx=any      Au=any   Enc=AESGCM(256)            Mac=AEAD
TLS_CHACHA20_POLY1305_SHA256   TLSv1.3 Kx=any      Au=any   Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256)            Mac=AEAD
ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2 Kx=ECDH     Au=RSA   Enc=AESGCM(256)            Mac=AEAD
DHE-RSA-AES256-GCM-SHA384      TLSv1.2 Kx=DH       Au=RSA   Enc=AESGCM(256)            Mac=AEAD
ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2 Kx=ECDH     Au=ECDSA Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2 Kx=ECDH     Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
DHE-RSA-CHACHA20-POLY1305      TLSv1.2 Kx=DH       Au=RSA   Enc=CHACHA20/POLY1305(256) Mac=AEAD
ECDHE-ECDSA-AES256-SHA384      TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)               Mac=SHA384
ECDHE-RSA-AES256-SHA384        TLSv1.2 Kx=ECDH     Au=RSA   Enc=AES(256)               Mac=SHA384
DHE-RSA-AES256-SHA256          TLSv1.2 Kx=DH       Au=RSA   Enc=AES(256)               Mac=SHA256
AES256-GCM-SHA384              TLSv1.2 Kx=RSA      Au=RSA   Enc=AESGCM(256)            Mac=AEAD
AES256-SHA256                  TLSv1.2 Kx=RSA      Au=RSA   Enc=AES(256)               Mac=SHA256
```

## Config file examples 配置文件示例 

Let’s see some practical examples of how we can use the configuration file to tweak the default cryptographic settings of an application linked with  OpenSSL.
让我们看一些实际的例子，看看如何使用配置文件来调整与OpenSSL链接的应用程序的默认加密设置。 

Note that applications can still override these settings: what is set in the configuration file merely acts as a default that is used when nothing  else in the application command line or its own config says otherwise.
请注意，应用程序仍然可以覆盖这些设置：配置文件中的设置仅作为默认值，当应用程序命令行或其自己的配置中没有其他内容时使用。 

### Only use TLSv1.3 仅使用TLSv1.3 

To configure the OpenSSL library to consider TLSv1.3 as the minimum acceptable protocol, we add a `MinProtocol` parameter to the `/etc/ssl/openssl.cnf` configuration file like this:
要配置OpenSSL库以将TLSv1.3视为最低可接受协议，我们向 `/etc/ssl/openssl.cnf` 配置文件添加一个 `MinProtocol` 参数，如下所示：

```INI
[system_default_sect]
CipherString = DEFAULT:@SECLEVEL=2
MinProtocol = TLSv1.3
```

If you then try to connect securely to a server that only offers, say TLSv1.2, the connection will fail:
如果您尝试安全地连接到仅提供以下服务的服务器，例如TLSv1.2，则连接将失败： 

```console
$ curl https://j-server.lxd/stats
curl: (35) error:0A00042E:SSL routines::tlsv1 alert protocol version

$ wget https://j-server.lxd/stats
--2023-01-06 13:41:50--  https://j-server.lxd/stats
Resolving j-server.lxd (j-server.lxd)... 10.0.100.87
Connecting to j-server.lxd (j-server.lxd)|10.0.100.87|:443... connected.
OpenSSL: error:0A00042E:SSL routines::tlsv1 alert protocol version
Unable to establish SSL connection.
```

### Use only AES256 with TLSv1.3 仅将AES 256与TLSv1.3配合使用 

As an additional constraint, besides forcing TLSv1.3, let’s only allow  AES256. This would do it for OpenSSL applications that do not override  this elsewhere:
作为一个额外的约束，除了强制TLSv1.3之外，我们只允许AES 256。这将适用于在其他地方没有覆盖它的OpenSSL应用程序： 

```INI
[system_default_sect]
CipherString = DEFAULT:@SECLEVEL=2
CipherSuites = TLS_AES_256_GCM_SHA384
MinProtocol = TLSv1.3
```

Since we are already forcing TLSv1.3, there is no need to tweak the `CipherString` list, since that applies only to TLSv1.2 and older.
由于我们已经强制使用TLSv1.3，因此没有必要调整 `CipherString` 列表，因为这只适用于TLSv1.2和更早的版本。

The OpenSSL `s_server` command is very handy to test this (see [the Troubleshooting section](https://ubuntu.com/server/docs/troubleshooting-tls-ssl) for details on how to use it):
OpenSSL `s_server` 命令非常方便地测试这一点（有关如何使用它的详细信息，请参阅故障排除部分）：

```bash
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -www
```

> **Note**: 注意：
>  Be sure to use another system for this server, or else it will be subject to the same `/etc/ssl/openssl.cnf` constraints you are testing on the client, and this can lead to very confusing results.
>  请确保为该服务器使用另一个系统，否则它将受到您在客户机上测试的相同 `/etc/ssl/openssl.cnf` 约束的影响，这可能会导致非常混乱的结果。

As expected, a client will end up selecting TLSv1.3 and the `TLS_AES_256_GCM_SHA384` cipher suite:
正如预期的那样，客户端最终将选择TLSv1.3和 `TLS_AES_256_GCM_SHA384` 密码套件：

```console
$ wget https://j-server.lxd/stats -O /dev/stdout -q | grep Cipher -w
New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
    Cipher    : TLS_AES_256_GCM_SHA384
```

To be sure, we can tweak the server to only offer `TLS_CHACHA20_POLY1305_SHA256` for example:
可以肯定的是，我们可以调整服务器只提供 `TLS_CHACHA20_POLY1305_SHA256` ，例如：

```bash
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -www -ciphersuites TLS_CHACHA20_POLY1305_SHA256
```

And now the client will fail:
现在客户端会失败： 

```console
$ wget https://j-server.lxd/stats -O /dev/stdout
--2023-01-06 14:20:55--  https://j-server.lxd/stats
Resolving j-server.lxd (j-server.lxd)... 10.0.100.87
Connecting to j-server.lxd (j-server.lxd)|10.0.100.87|:443... connected.
OpenSSL: error:0A000410:SSL routines::sslv3 alert handshake failure
Unable to establish SSL connection.
```

### Drop AES128 entirely 完全丢弃AES 128 

If we want to still allow TLS v1.2, but just drop AES128, then we need to  configure the ciphers separatedly for TLS v1.3 and v1.2 or lower:
如果我们仍然希望允许TLS v1.2，但只是放弃AES 128，那么我们需要分别为TLS v1.3和v1.2或更低版本配置密码： 

```INI
[system_default_sect]
CipherString = DEFAULT:@SECLEVEL=2:!AES128
CipherSuites = TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
MinProtocol = TLSv1.2
```

To test, let’s force our test `s_server` server to only offer TLSv1.2:
为了进行测试，让我们强制测试 `s_server` 服务器只提供TLSv1.2：

```bash
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -www -tls1_2
```

And our client picks AES256:
我们的客户选择AES 256： 

```console
$ wget https://j-server.lxd/stats -O /dev/stdout -q | grep Cipher -w
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
```

But that could also be just because AES256 is stronger than AES128. Let’s  not offer AES256 on the server, and also jump ahead and also remove  CHACHA20, which would be the next one preferable to AES128:
但这也可能只是因为AES 256比AES 128更强。让我们不要在服务器上提供AES 256，并且也跳到前面并删除CHACHA 20，这将是下一个比AES 128更好的： 

```bash
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -www -tls1_2 -cipher 'DEFAULT:!AES256:!CHACHA20'
```

Surely `wget` should fail now. Well, turns out it does select AES128:
\#00000;现在已经失败了。好吧，事实证明它确实选择了AES 128：

```console
$ wget https://j-server.lxd/stats -O /dev/stdout -q | grep Cipher -w
New, TLSv1.2, Cipher is ECDHE-RSA-AES128-GCM-SHA256
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
```

It’s unclear why. Maybe it’s a safeguard, or maybe AES128 is always allowed  in TLSv1.2 and we produced an invalid configuration. This case shows how crypto is complex, and also applications can override any such  configuration setting that comes from the library. As a counter example, OpenSSL’s `s_client` tool follows the library config, and fails in this case:
原因不明。也许这是一种保护措施，或者也许在TLSv1.2中始终允许AES 128，而我们生成了一个无效的配置。这个案例显示了加密是多么复杂，而且应用程序可以覆盖来自库的任何此类配置设置。作为一个反例，OpenSSL的 `s_client` 工具遵循库配置，并在这种情况下失败：

```console
$ echo | openssl s_client -connect j-server.lxd:443  | grep -w -i cipher
4007F4F9D47F0000:error:0A000410:SSL routines:ssl3_read_bytes:sslv3 alert handshake failure:../ssl/record/rec_layer_s3.c:1584:SSL alert number 40
New, (NONE), Cipher is (NONE)
```

But we can override that as well with a command-line option and force `s_client` to allow AES128:
但是我们也可以使用命令行选项覆盖它，并强制 `s_client` 允许AES 128：

```console
$ echo | openssl s_client -connect j-server.lxd:443 --cipher DEFAULT:AES128 2>&1| grep -w -i cipher
New, TLSv1.2, Cipher is ECDHE-RSA-AES128-GCM-SHA256
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
```

## References 引用 

- [OpenSSL home page OpenSSL主页](https://www.openssl.org)
- SECLEVEL description: SECLEVEL描述： 
  - https://www.openssl.org/docs/man3.0/man3/SSL_CTX_set_security_level.html
  - https://www.feistyduck.com/library/openssl-cookbook/online/openssl-command-line/understanding-security-levels.html
- [Configuration directives that can be used in the `system_default_sect` section
  可以在 `system_default_sect` 节中使用的配置指令](https://manpages.ubuntu.com/manpages/jammy/en/man3/SSL_CONF_cmd.3ssl.html?_gl=1*1puobti*_gcl_au*MTA4Nzc1OTY4Mi4xNzA4NTkxMzIz&_ga=2.243243840.311818449.1713925671-599895355.1713925671#supported configuration file commands)

------

# GnuTLS

When initialised, the GnuTLS library tries to read its system-wide configuration file
初始化时，GnuTLS库尝试读取其系统范围的配置文件
 `/etc/gnutls/config`. If the file doesn’t exist, built-in defaults are used. To make configuration changes, the `/etc/gnutls` directory and the `config` file in it must be created manually, since they are not shipped in the Ubuntu packaging.
 `/etc/gnutls/config` 。如果文件不存在，则使用内置默认值。要进行配置更改，必须手动创建 `/etc/gnutls` 目录和其中的 `config` 文件，因为它们不在Ubuntu包中。

This config file can be used to disable (or mark as insecure) algorithms and
此配置文件可用于禁用（或标记为不安全）算法，
 protocols in a system-wide manner, overriding the library defaults. Note that,
 协议，覆盖库默认值。请注意，
 intentionally, any algorithms or protocols that were disabled or marked  as insecure cannot then be re-enabled or marked as secure.
 因此，被禁用或标记为不安全的任何算法或协议不能被重新启用或标记为安全。

There are many configuration options available for GnuTLs, and we strongly
GnuTL有很多配置选项，我们强烈建议
 recommend that you carefully read the upstream documentation listed in the
 建议您仔细阅读
 References section at the end of this page if creating this file or making changes to it.
 如果要创建此文件或对其进行更改，请在此页末尾的“引用”部分。

## Structure of the config file 配置文件的结构 

The GnuTLS configuration file is structured as an INI-style text file. There
GnuTLS配置文件的结构是一个INI风格的文本文件。那里
 are three sections, and each section contains `key = values` lines. For
 有三个部分，每个部分包含 `key = values` 行。为
 example: 例如：

```plaintext
[global]
override-mode = blocklist

[priorities]
SYSTEM = NORMAL:-MD5

[overrides]
tls-disabled-mac = sha1
```

## The `global` section `global` 部分

The `[global]` section sets the override mode used in the `[overrides]` section:
 `[global]` 部分设置 `[overrides]` 部分中使用的覆盖模式：

- `override-mode = blocklist`: the algorithms listed in `[overrides]` are disabled
   `override-mode = blocklist` ：禁用 `[overrides]` 中列出的算法
- `override-mode = allowlist`: the algorithms listed in `[overrides]` are enabled.
   `override-mode = allowlist` ：启用 `[overrides]` 中列出的算法。

Note that in the `allowlist` mode, all algorithms that should be enabled must be listed in `[overrides]`, as the library starts with marking all existing algorithms as disabled/insecure. In practice, this means that using `allowlist` tends to make the list in `[overrides]` quite large. Additionally, GnuTLS automatically constructs a `SYSTEM` keyword (that can be used in `[priorities]`) with all the allowed algorithms and ciphers specified in `[overrides]`.
请注意，在 `allowlist` 模式下，所有应该启用的算法必须在 `[overrides]` 中列出，因为库开始时会将所有现有算法标记为禁用/不安全。在实践中，这意味着使用 `allowlist` 往往会使 `[overrides]` 中的列表非常大。此外，GnuTLS自动构造一个 `SYSTEM` 关键字（可以在 `[priorities]` 中使用），其中包含 `[overrides]` 中指定的所有允许的算法和密码。

When using `allowlist`, all options in `[overrides]` will be of the `enabled` form. For example:
当使用 `allowlist` 时， `[overrides]` 中的所有选项都将是 `enabled` 形式。举例来说：

```plaintext
[global]
override-mode = allowlist

[overrides]
secure-hash = sha256
enabled-curve = secp256r1
secure-sig = ecdsa-secp256r1-sha256
enabled-version = tls1.3
tls-enabled-cipher = aes-128-gcm
tls-enabled-mac = aead
tls-enabled-group = secp256r1
```

And when using `blocklist`, all `[override]` options have the opposite meaning (i.e. `disabled`):
当使用 `blocklist` 时，所有 `[override]` 选项都具有相反的含义（即 `disabled` ）：

```plaintext
[global]
override-mode = blocklist

[overrides]
tls-disabled-cipher = aes-128-cbc
tls-disabled-cipher = aes-256-cbc
tls-disabled-mac = sha1
tls-disabled-group = group-ffdhe8192
```

For other examples and a complete list of the valid keys in the `[overrides]` section, please refer to [disabling algorithms and protocols](https://www.gnutls.org/manual/html_node/Disabling-algorithms-and-protocols.html).
有关其他示例和 `[overrides]` 部分中有效密钥的完整列表，请参阅禁用算法和协议。

## Priority strings 优先级字符串 

The `[priorities]` section is used to construct **priority strings**. These strings are a way to specify the TLS session’s handshake  algorithms and options in a compact, easy-to-use, format. Note that  priority strings are not guaranteed to imply the same set of algorithms  and protocols between different GnuTLS versions.
 `[priorities]` 部分用于构造优先级字符串。这些字符串是以紧凑、易于使用的格式指定TLS会话的握手算法和选项的一种方式。注意，优先级字符串不能保证在不同的GnuTLS版本之间使用相同的算法和协议。

The default priority string is selected at package build time by the vendor, and in the case of Ubuntu Jammy it’s [defined in `debian/rules`](https://git.launchpad.net/ubuntu/+source/gnutls28/tree/debian/rules?h=ubuntu/jammy-devel#n38) as:
默认的优先级字符串由供应商在包构建时选择，在Ubuntu Jammy的情况下，它在 `debian/rules` 中定义为：

```plaintext
NORMAL:-VERS-ALL:+VERS-TLS1.3:+VERS-TLS1.2:+VERS-DTLS1.2:%PROFILE_MEDIUM
```

A priority string can start with a single initial keyword, and then add or remove algorithms or special keywords. The `NORMAL` priority string is [defined in this table](https://gnutls.org/manual/html_node/Priority-Strings.html#tab_003aprio_002dkeywords) in the upstream documentation reference, which also includes many other useful keywords that can be used.
优先级字符串可以以单个初始关键字开始，然后添加或删除算法或特殊关键字。在上游文档参考中的这个表中定义了 `NORMAL` 优先级字符串，其中还包括许多其他可用的有用关键字。

To see the resulting list of ciphers and algorithms from a priority string, one can use the `gnutls-cli` command-line tool. For example, to list all the ciphers and algorithms allowed with the priority string `SECURE256`:
要查看优先级字符串的密码和算法的结果列表，可以使用 `gnutls-cli` 命令行工具。例如，要列出优先级字符串 `SECURE256` 允许的所有密码和算法：

```console
$ gnutls-cli --list --priority SECURE256
Cipher suites for SECURE256
TLS_AES_256_GCM_SHA384                                  0x13, 0x02      TLS1.3
TLS_CHACHA20_POLY1305_SHA256                            0x13, 0x03      TLS1.3
TLS_ECDHE_ECDSA_AES_256_GCM_SHA384                      0xc0, 0x2c      TLS1.2
TLS_ECDHE_ECDSA_CHACHA20_POLY1305                       0xcc, 0xa9      TLS1.2
TLS_ECDHE_ECDSA_AES_256_CCM                             0xc0, 0xad      TLS1.2
TLS_ECDHE_RSA_AES_256_GCM_SHA384                        0xc0, 0x30      TLS1.2
TLS_ECDHE_RSA_CHACHA20_POLY1305                         0xcc, 0xa8      TLS1.2
TLS_RSA_AES_256_GCM_SHA384                              0x00, 0x9d      TLS1.2
TLS_RSA_AES_256_CCM                                     0xc0, 0x9d      TLS1.2
TLS_DHE_RSA_AES_256_GCM_SHA384                          0x00, 0x9f      TLS1.2
TLS_DHE_RSA_CHACHA20_POLY1305                           0xcc, 0xaa      TLS1.2
TLS_DHE_RSA_AES_256_CCM                                 0xc0, 0x9f      TLS1.2

Protocols: VERS-TLS1.3, VERS-TLS1.2, VERS-TLS1.1, VERS-TLS1.0, VERS-DTLS1.2, VERS-DTLS1.0
Ciphers: AES-256-GCM, CHACHA20-POLY1305, AES-256-CBC, AES-256-CCM
MACs: AEAD
Key Exchange Algorithms: ECDHE-ECDSA, ECDHE-RSA, RSA, DHE-RSA
Groups: GROUP-SECP384R1, GROUP-SECP521R1, GROUP-FFDHE8192
PK-signatures: SIGN-RSA-SHA384, SIGN-RSA-PSS-SHA384, SIGN-RSA-PSS-RSAE-SHA384, SIGN-ECDSA-SHA384, SIGN-ECDSA-SECP384R1-SHA384, SIGN-EdDSA-Ed448, SIGN-RSA-SHA512, SIGN-RSA-PSS-SHA512, SIGN-RSA-PSS-RSAE-SHA512, SIGN-ECDSA-SHA512, SIGN-ECDSA-SECP521R1-SHA512
```

You can manipulate the resulting set by manipulating the priority string. For example, to remove `CHACHA20-POLY1305` from the `SECURE256` set:
可以通过操作优先级字符串来操作结果集。例如，要从 `SECURE256` 集合中删除 `CHACHA20-POLY1305` ：

```console
$ gnutls-cli --list --priority SECURE256:-CHACHA20-POLY1305
Cipher suites for SECURE256:-CHACHA20-POLY1305
TLS_AES_256_GCM_SHA384                                  0x13, 0x02      TLS1.3
TLS_ECDHE_ECDSA_AES_256_GCM_SHA384                      0xc0, 0x2c      TLS1.2
TLS_ECDHE_ECDSA_AES_256_CCM                             0xc0, 0xad      TLS1.2
TLS_ECDHE_RSA_AES_256_GCM_SHA384                        0xc0, 0x30      TLS1.2
TLS_RSA_AES_256_GCM_SHA384                              0x00, 0x9d      TLS1.2
TLS_RSA_AES_256_CCM                                     0xc0, 0x9d      TLS1.2
TLS_DHE_RSA_AES_256_GCM_SHA384                          0x00, 0x9f      TLS1.2
TLS_DHE_RSA_AES_256_CCM                                 0xc0, 0x9f      TLS1.2

Protocols: VERS-TLS1.3, VERS-TLS1.2, VERS-TLS1.1, VERS-TLS1.0, VERS-DTLS1.2, VERS-DTLS1.0
Ciphers: AES-256-GCM, AES-256-CBC, AES-256-CCM
MACs: AEAD
Key Exchange Algorithms: ECDHE-ECDSA, ECDHE-RSA, RSA, DHE-RSA
Groups: GROUP-SECP384R1, GROUP-SECP521R1, GROUP-FFDHE8192
PK-signatures: SIGN-RSA-SHA384, SIGN-RSA-PSS-SHA384, SIGN-RSA-PSS-RSAE-SHA384, SIGN-ECDSA-SHA384, SIGN-ECDSA-SECP384R1-SHA384, SIGN-EdDSA-Ed448, SIGN-RSA-SHA512, SIGN-RSA-PSS-SHA512, SIGN-RSA-PSS-RSAE-SHA512, SIGN-ECDSA-SHA512, SIGN-ECDSA-SECP521R1-SHA512
```

And you can give this a new name by adding the following to the `[priorities]` section:
您可以通过将以下内容添加到 `[priorities]` 部分来给予新名称：

```plaintext
[priorities]
MYSET = SECURE256:-CHACHA20-POLY1305
```

Which allows the `MYSET` priority string to be used like this:
它允许像这样使用 `MYSET` 优先级字符串：

```bash
$ gnutls-cli --list --priority @MYSET
```

## Verification profile (overrides) 验证配置文件（覆盖） 

When verifying a certificate, or TLS session parameters, GnuTLS uses a set  of profiles associated with the session to determine whether the  parameters seen in the session are acceptable. These profiles are  normally set using the `%PROFILE` priority string, but it is also possible to set a low bar that applications cannot override. This is done with the `min-verification-profile` setting in the `[overrides]` section.
在验证证书或TLS会话参数时，GnuTLS使用一组与会话关联的配置文件来确定会话中看到的参数是否可接受。这些配置文件通常使用 `%PROFILE` 优先级字符串设置，但也可以设置应用程序无法覆盖的低条。这是通过 `[overrides]` 部分中的 `min-verification-profile` 设置完成的。

For example: 举例来说，请注意： 

```plaintext
[overrides]
# do not allow applications use the LOW or VERY-WEAK profiles.
min-verification-profile = legacy
```

The list of values that can be used, and their meaning, is shown in the [key sizes and security parameters](https://gnutls.org/manual/html_node/Selecting-cryptographic-key-sizes.html#tab_003akey_002dsizes) table in the upstream documentation.
上游文档中的密钥大小和安全参数表显示了可以使用的值及其含义。

## Practical examples 实例 

Let’s see some practical examples of how we can use the configuration file to tweak the default cryptographic settings of an application linked with  GnuTLS.
让我们看一些实际的例子，看看如何使用配置文件来调整与GnuTLS链接的应用程序的默认加密设置。 

Contrary to OpenSSL, GnuTLS does not allow a cipher that was once removed to be  allowed again. So if you have a setting in the GnuTLS config file that  prohibits `CHACHA20`, an application using GnuTLS will not be able to allow it.
与OpenSSL相反，GnuTLS不允许曾经被删除的密码再次被允许。因此，如果您在GnuTLS配置文件中设置了禁止 `CHACHA20` 的设置，则使用GnuTLS的应用程序将无法允许它。

### Only use TLSv1.3 仅使用TLSv1.3 

One way to do it is to set a new default priority string that removes all TLS versions and then adds back just TLS 1.3:
一种方法是设置一个新的默认优先级字符串，删除所有TLS版本，然后只添加TLS 1.3： 

```INI
[global]
override-mode = blocklist

[overrides]
default-priority-string = NORMAL:-VERS-TLS-ALL:+VERS-TLS1.3
```

With our test server providing everything but TLSv1.3:
我们的测试服务器提供了除TLSv1.3之外的所有功能： 

```console
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -no_tls1_3  -www
```

Connections will fail: 连接将失败： 

```console
$ gnutls-cli j-server.lxd
Processed 125 CA certificate(s).
Resolving 'j-server.lxd:443'...
Connecting to '10.0.100.87:443'...
*** Fatal error: A TLS fatal alert has been received.
*** Received alert [70]: Error in protocol version
```

An application linked with GnuTLS will also fail:
与GnuTLS链接的应用程序也会失败： 

```console
$ lftp -c "cat https://j-server.lxd/status"
cat: /status: Fatal error: gnutls_handshake: A TLS fatal alert has been received.
```

But an application can override these settings, because it’s only the  priority string that is being manipulated in the GnuTLS config:
但是应用程序可以覆盖这些设置，因为它只是在GnuTLS配置中操作的优先级字符串： 

```console
$ lftp -c "set ssl:priority NORMAL:+VERS-TLS-ALL; cat https://j-server.lxd/status" | grep ^New
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
```

Another way to limit the TLS versions is via specific protocol version configuration keys:
另一种限制TLS版本的方法是通过特定的协议版本配置密钥： 

```INI
[global]
override-mode = blocklist

[overrides]
disabled-version = tls1.1
disabled-version = tls1.2
disabled-version = tls1.0
```

Note that setting the same key multiple times will append the new value to the previous value(s).
请注意，多次设置相同的键将把新值附加到以前的值。 

In this scenario, the application cannot override the config anymore:
在这种情况下，应用程序不能再覆盖配置： 

```console
$ lftp -c "set ssl:priority NORMAL:+VERS-TLS-ALL; cat https://j-server.lxd/status" | grep ^New
cat: /status: Fatal error: gnutls_handshake: A TLS fatal alert has been received.
```

### Use only AES256 with TLSv1.3 仅将AES 256与TLSv1.3配合使用 

TLSv1.3 has a small list of ciphers, but it includes AES128. Let’s remove it:
TLSv1.3有一个小的密码列表，但它包括AES 128。让我们删除它： 

```INI
[global]
override-mode = blocklist

[overrides]
disabled-version = tls1.1
disabled-version = tls1.2
disabled-version = tls1.0
tls-disabled-cipher = AES-128-GCM
```

If we now connect to a server that was brought up with this config:
如果我们现在连接到一个使用此配置的服务器： 

```bash
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -ciphersuites TLS_AES_128_GCM_SHA256 -www
```

Our GnuTLS client will fail:
我们的GnuTLS客户端会失败： 

```console
$ gnutls-cli j-server.lxd
Processed 126 CA certificate(s).
Resolving 'j-server.lxd:443'...
Connecting to '10.0.100.87:443'...
*** Fatal error: A TLS fatal alert has been received.
*** Received alert [40]: Handshake failed
```

And given GnuTLS’s behavior regarding re-enabling a cipher that was once  removed, we cannot allow AES128 from the command line either:
考虑到GnuTLS关于重新启用曾经被删除的密码的行为，我们也不能允许从命令行使用AES 128： 

```console
$ gnutls-cli --priority="NORMAL:+AES-128-GCM"  j-server.lxd
Processed 126 CA certificate(s).
Resolving 'j-server.lxd:443'...
Connecting to '10.0.100.87:443'...
*** Fatal error: A TLS fatal alert has been received.
*** Received alert [40]: Handshake failed
```

## References 引用 

- [System-wide configuration
   全系统配置](https://www.gnutls.org/manual/html_node/System_002dwide-configuration-of-the-library.html)
- [Priority strings 优先级字符串](https://gnutls.org/manual/html_node/Priority-Strings.html)
- [`min-verification-profile` values `min-verification-profile` 值](https://gnutls.org/manual/html_node/Selecting-cryptographic-key-sizes.html#tab_003akey_002dsizes)
- [Disabling algorithms and protocols
   禁用算法和协议](https://www.gnutls.org/manual/html_node/Disabling-algorithms-and-protocols.html)
- [Invoking the `gnutls-cli` command line tool
  禁用 `gnutls-cli` 命令行工具](https://gnutls.org/manual/html_node/gnutls_002dcli-Invocation.html)

# Network Security Services (NSS) 网络安全服务（NSS） 

Network Security Services, or NSS, is a set of libraries that was originally  developed by Netscape and later inherited by Mozilla. In Ubuntu, it’s  used mainly in Mozilla products such as Firefox and Thunderbird, but  there are modules and language bindings available for other packages to  use.
网络安全服务（Network Security  Services，简称NSS）是一组最初由Netscape开发，后来由Mozilla继承的库。在Ubuntu中，它主要用于Mozilla产品，如Firefox和Thunderbird，但也有模块和语言绑定可供其他软件包使用。 

Given its origins in the Netscape browser, this library used to be bundled  together with the applications that required it. Up to this day, for  example, the Debian package of Mozilla Thunderbird has its own copy of `libnss3`, ignoring the system-wide one shipped by the `libnss3` Debian package.
由于它起源于Netscape浏览器，这个库曾经与需要它的应用程序捆绑在一起。直到今天，例如，Mozilla Thunderbird的Debian软件包有自己的 `libnss3` 副本，忽略了 `libnss3` Debian软件包提供的系统级副本。

## Config file Config文件 

NSS doesn’t have a system-wide policy configuration file in Ubuntu ([see #2016303](https://bugs.launchpad.net/ubuntu/+source/nss/+bug/2016303) for details). That leaves the remaining location for the configuration  file to be in the NSS “database” directory. Depending on the  application, it can be in the following places by default:
NSS在Ubuntu中没有系统范围的策略配置文件（详情请参阅#2016303）。这使得配置文件的其余位置位于NSS“数据库”目录中。根据应用程序的不同，默认情况下，它可以位于以下位置：

- `~/.pki/nssdb/pkcs11.txt`
   This is where the system-provided `libnss3` library will look by default.
   默认情况下，系统提供的 `libnss3` 库将在此处查找。
- `~/snap/firefox/common/.mozilla/firefox/<random>.default/pkcs11.txt`
   This is where the Firefox snap will look.
   这就是Firefox Snap的样子。
- `~/.thunderbird/<random>.default-release/pkcs11.txt`
   Mozilla Thunderbird ships with its own copy of `libnss3`, and is configured to look into this directory to find it.
   Mozilla Thunderbird附带了自己的 `libnss3` 副本，并配置为查看此目录以找到它。
- `~/.netscape/pkcs11.txt`
   This is the default used by the NSS tools shipped in the `libnss3-tools` Debian package.
   这是 `libnss3-tools` Debian软件包中提供的NSS工具使用的默认值。

The directory where `pkcs11.txt` is looked up is also the NSS database directory. NSS will store the  certificates and private keys it imports or generates here, and the  directory will typically contain these SQLITE3 database files:
查找 `pkcs11.txt` 的目录也是NSS数据库目录。NSS将在此处存储它导入或生成的证书和私钥，该目录通常包含以下SQLITE3数据库文件：

- `cert9.db`: certificates database
   `cert9.db` ：证书数据库
- `key4.db`: private key database
   `key4.db` ：私钥数据库

With the `pkcs11.txt` file we can load PKCS#11 modules, including the one built into NSS  itself. Other examples of modules that can be loaded from there are  modules for smart cards or other hardware-based cryptographic devices.  Of interest to us here, though, is the policy module.
使用 `pkcs11.txt` 文件，我们可以加载PKCS#11模块，包括NSS本身内置的模块。可以从那里加载的模块的其他示例是用于智能卡或其他基于硬件的密码设备的模块。不过，我们在这里感兴趣的是政策模块。

## Configuring the NSS policy module 配置NSS策略模块 

The policy module is defined like this in `pkcs11.txt`:
策略模块在 `pkcs11.txt` 中定义如下：

```plaintext
library=
name=Policy
NSS=flags=policyOnly,moduleDB
config="disallow=<list> allow=<list> flags=<flags>"
```

It’s via the `config=` line that we can list which cryptographic algorithms we want to allow  and disallow. The terms in the list are separated with a colon (“`:`”) and consist of the following:
通过 `config=` 行，我们可以列出我们想要允许和不允许的加密算法。列表中的术语用冒号（“ `:` “）分隔，并由以下内容组成：

- **The special keyword “ALL”**, meaning all possible values and algorithms. It’s mostly used with `disallow`, so that a clean slate can be constructed with a following `allow` list. For example, `disallow=ALL allow=<list of allowed>` would only allow the algorithms explicitly listed in the `allow` list.
  特殊关键字“ALL”，表示所有可能的值和算法。它主要与 `disallow` 一起使用，以便可以使用以下 `allow` 列表构建一个干净的石板。例如， `disallow=ALL allow=<list of allowed>` 只允许在 `allow` 列表中明确列出的算法。
- **Algorithm name**: Standard names like `sha256`, `hmac-sha256`, `chacha20-poly1305`, `aes128-gcm` and others.
  算法名称：标准名称，如 `sha256` 、 `hmac-sha256` 、 `chacha20-poly1305` 、 `aes128-gcm` 等。
- **Version specifiers**: A minimum or maximum version for a protocol. These are the available ones:
  版本说明符：协议的最小或最大版本。这些是可用的：
  - `tls-version-min`, `tls-version-max`: Minimum and maximum version for the TLS protocol. For example, `tls-version-min=tls1.2`.
     `tls-version-min` 、 `tls-version-max` ：TLS协议的最低和最高版本。例如， `tls-version-min=tls1.2` 。
  - `dtls-version-min`, `dtls-version-max`: As above, but for DTLS (TLS over UDP)
     `dtls-version-min` 、 `dtls-version-max` ：同上，但用于DTLS（UDP上的TLS）
- **Key sizes**: Minimum size for a key:
  密钥大小：密钥的最小大小：
  - `DH-MIN`: Diffie-Helman minimum key size. For example, `DH-MIN=2048` specifies a minimum of 2048 bits.
     `DH-MIN` ：Diffie-Helman最小密钥大小。例如， `DH-MIN=2048` 指定最小值为2048位。
  - `DSA-MIN`: Digital Signature Algorithm minimum key size. For example, `DSA-MIN=2048` specifies a minimum of 2048 bits.
     `DSA-MIN` ：数字签名算法最小密钥大小。例如， `DSA-MIN=2048` 指定最小值为2048位。
  - `RSA-MIN`: RSA minimum key size. For example, `RSA-MIN=2048` specifies a minimum of 2048 bits.
     `RSA-MIN` ：RSA最小密钥大小。例如， `RSA-MIN=2048` 指定最小值为2048位。
- **Signature qualifier**: Selects the specified algorithm with a specific type of signature. For example, `sha256/cert-signature`. Here are some of the qualifiers that are available:
  签名限定符：使用特定类型的签名来限定指定的算法。例如， `sha256/cert-signature` 。以下是一些可用的限定符：
  - `/cert-signature`: Used in certificate signatures, certificate revocation lists (CRLs) and Online Certificate Status Protocol (OCSP).
     `/cert-signature` ：用于证书签名、证书撤销列表（CRL）和在线证书状态协议（OCSP）。
  - `/signature`: Used in any signature.
     `/signature` ：用于任何签名。
  - `/all`: Combines SSL, SSL key exchange, and signatures.
     `/all` ：结合SSL、SSL密钥交换和签名。
  - `/ssl-key-exchange`: Used in the SSL key exchange.
     `/ssl-key-exchange` ：用于SSL密钥交换。
  - `/ssl`: Used in the SSL record protocol.
     `/ssl` ：用于SSL记录协议。

The `disallow` rules are always parsed first, and then the `allow` ones, independent of the order in which they appear.
总是首先解析 `disallow` 规则，然后是 `allow` 规则，与它们出现的顺序无关。

There are extra flags that can be added to the `config` line as well, in a comma-separated list if more than one is specified:
如果指定了多个标记，也可以在逗号分隔的列表中将额外的标记添加到 `config` 行：

- `policy-lock`: Turn off the ability for applications to change policy with API calls.
   `policy-lock` ：关闭应用程序通过API调用更改策略的功能。
- `ssl-lock`: Turn off the ability to change the SSL defaults.
   `ssl-lock` ：关闭更改SSL默认值的功能。

## Practical examples 实例 

Let’s see some practical examples of how we can use the configuration file to tweak the default cryptographic settings of an application linked with  the system NSS libraries.
让我们看一些实际的例子，看看如何使用配置文件来调整与系统NSS库链接的应用程序的默认加密设置。 

For these examples, we will be using the configuration file located in `~/.pki/nssdb/pkcs11.txt`. As noted before, depending on the application this file can be in another directory.
对于这些示例，我们将使用位于 `~/.pki/nssdb/pkcs11.txt` 中的配置文件。如前所述，根据应用程序的不同，此文件可能位于另一个目录中。

The examples will use the `tstclnt` test application that is part of the `libnss3-tools` Debian package. For the server part, we will be using the OpenSSL test  server on the same system. Since it uses the OpenSSL library, it won’t  be affected by the changes we make to the NSS configuration.
这些示例将使用 `tstclnt` 测试应用程序，它是 `libnss3-tools` Debian软件包的一部分。对于服务器部分，我们将在同一系统上使用OpenSSL测试服务器。由于它使用OpenSSL库，因此不会受到我们对NSS配置所做更改的影响。

### Bootstrapping the NSS database 引导NSS数据库 

Install the `libnss3-tools` package which has the necessary tools we will need:
安装 `libnss3-tools` 包，其中包含我们需要的必要工具：

```bash
sudo apt install libnss3-tools
```

If you don’t have a `~/.pki/nssdb` directory yet, it will have to be created first. For that, we will use the `certutil` command, also part of the `libnss3-tools` package. This will bootstrap the NSS database in that directory, and also create the initial `pkcs11.txt` file we will tweak in the subsequent examples:
如果您还没有 `~/.pki/nssdb` 目录，则必须首先创建它。为此，我们将使用 `certutil` 命令，也是 `libnss3-tools` 包的一部分。这将在该目录中引导NSS数据库，并创建初始的 `pkcs11.txt` 文件，我们将在后续示例中进行调整：

```bash
mkdir -p ~/.pki/nssdb
certutil -d ~/.pki/nssdb -N
```

If you already have a populated `~/.pki/nssdb` directory, there is no need to run the above commands.
如果您已经有一个填充的 `~/.pki/nssdb` 目录，则不需要运行上述命令。

When running the `certutil` command as shown, you will be asked to choose a password. That password will protect the NSS database, and will be requested whenever certain  changes are made to it.
当运行如图所示的 `certutil` 命令时，系统将要求您选择密码。该密码将保护NSS数据库，并将在对其进行某些更改时请求。

In the following examples we will make changes to the `pkcs11.txt` file inside the NSS database directory. The bootstrap process above  will have created this file for us already. The changes that we will  make should be *added* to the file, and not replace it. For example, these are the contents of `~/.pki/nssdb/pkcs11.txt` right after the boostrap process:
在下面的示例中，我们将对NSS数据库目录中的 `pkcs11.txt` 文件进行更改。上面的引导过程已经为我们创建了这个文件。我们所做的更改应该添加到文件中，而不是替换它。例如，这些是引导过程之后 `~/.pki/nssdb/pkcs11.txt` 的内容：

```plaintext
library=
name=NSS Internal PKCS #11 Module
parameters=configdir='/home/ubuntu/.pki/nssdb' certPrefix='' keyPrefix='' secmod='secmod.db' flags= updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})
```

When an example asks to configure the policy module, its block should be  appended to the existing configuration block in the file. For example:
当一个示例要求配置策略模块时，它的块应该附加到文件中现有的配置块。举例来说，请注意： 

```plaintext
library=
name=NSS Internal PKCS #11 Module
parameters=configdir='/home/ubuntu/.pki/nssdb' certPrefix='' keyPrefix='' secmod='secmod.db' flags= updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})

library=
name=Policy
NSS=flags=policyOnly,moduleDB
config="allow=tls-version-min=tls1.3"
```

### Test setup 测试设置 

For these examples, we will be using a simple OpenSSL server on the same  system as the NSS client we are testing. For that we will have to  generate a certificate and key for the OpenSSL server to use, and then  import that into the NSS database so it can be trusted.
对于这些示例，我们将在与我们测试的NSS客户端相同的系统上使用一个简单的OpenSSL服务器。为此，我们必须为OpenSSL服务器生成一个证书和密钥，然后将其导入NSS数据库，以便它可以被信任。 

First, generate a keypair for OpenSSL:
首先，为OpenSSL生成一个密钥对： 

```bash
openssl req -new -x509 -days 30 -nodes -subj "/CN=localhost" -out localhost.pem -keyout localhost.key
```

To avoid telling `tstclnt` to ignore certification validation errors, which might mask the crypto  policy changes we are trying to demonstrate, it’s best to import this  certificate into the NSS database and mark it as trusted:
为了避免告诉 `tstclnt` 忽略证书验证错误，这可能会掩盖我们试图演示的加密策略更改，最好将此证书导入NSS数据库并将其标记为受信任：

```bash
certutil -d ~/.pki/nssdb -A -a -i localhost.pem -t TCP -n localhost
```

This command will ask you for the NSS database password that you supplied  when bootstrapping it. The command line options that were used have the  following meanings:
此命令将询问您在引导NSS数据库时提供的NSS数据库密码。所使用的命令行选项具有以下含义： 

- `-d ~/.pki/nssdb`: The path to the NSS database.
   `-d ~/.pki/nssdb` ：NSS数据库的路径。

- `-A`: Import a certificate.
   `-A` ：导入证书。

- `-a`: The certificate is in ASCII mode (PEM).
   `-a` ：证书处于ASCII模式（PEM）。

- `-i localhost.pem`: The file to read (the actual certificate).
   `-i localhost.pem` ：要读取的文件（实际证书）。

- ```
  -t TCP
  ```

  : Trust flags (see the 

  ```
  -t trustargs
  ```

   argument in the 

  certutil manpage

   for a full list).

  
   `-t TCP` ：信任标志（完整列表请参见certutil手册页中的 `-t trustargs` 参数）。 

  - `T`: Trusted CA for client authentication.
     `T` ：用于客户端身份验证的受信任CA。
  - `C`: Trusted CA. `C` ：可信CA。
  - `P`: Trusted peer. `P` ：受信任对等体。

- `-n localhost`: A nickname for this certificate, like a label. It can be used later on to select this certificate.
   `-n localhost` ：此证书的昵称，类似于标签。稍后可以使用它来选择此证书。

We are now ready to begin our tests. Unless otherwise noted, this is how it’s expected that the server will be run:
我们现在可以开始测试了。除非另有说明，否则这就是服务器的预期运行方式： 

```bash
openssl s_server -accept 4443 -cert localhost.pem -key localhost.key -www
```

### The `tstclnt` tool `tstclnt` 工具

The `libnss3-tools` package also contains the `tstclnt` tool, which is what we will use in the following examples to test our NSS configuration changes.
 `libnss3-tools` 包还包含 `tstclnt` 工具，我们将在以下示例中使用该工具来测试NSS配置更改。

This is the typical command we will use:
这是我们将使用的典型命令：用途： 

```bash
tstclnt -d ~/.pki/nssdb -h localhost -p 4443
```

Where the options have the following meanings:
其中选项具有以下含义： 

- `-d ~/.pki/nssdb`: Use the NSS database located in the `~/.pki/nssdb` directory.
   `-d ~/.pki/nssdb` ：使用位于 `~/.pki/nssdb` 目录中的NSS数据库。
- `-h localhost`: The server to connect to.
   `-h localhost` ：要连接的服务器。
- `-p 4443`: The TCP port to connect to.
   `-p 4443` ：要连接的TCP端口。

To make things a bit easier to see, since this tool prints a lot of information about the connection, we will wrap it like this:
为了让事情更容易看到，因为这个工具打印了很多关于连接的信息，我们将像这样包装它： 

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443 2>&1 | grep ^New

New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
^C
```

The above tells us that the connection was completed and that it is using `TLSv1.3`, with a `TLS_AES_128_GCM_SHA256` cipher suite.
上面告诉我们连接已经完成，并且它使用 `TLSv1.3` 和 `TLS_AES_128_GCM_SHA256` 密码套件。

It will not exit on its own, so it’s necessary to press Ctrl+C (`^C`) to get back to the shell prompt.
它不会自行退出，因此需要按 Ctrl + C （ `^C` ）返回shell提示符。

### Only use TLSv1.3 仅使用TLSv1.3 

Here is how we can restrict the TLS protocol version to 1.3 at a minimum:
下面是我们如何将TLS协议版本限制为最低1.3： 

```plaintext
library=
name=Policy
NSS=flags=policyOnly,moduleDB
config="allow=tls-version-min=tls1.3"
```

If we then start the OpenSSL server without TLSv1.3 support, like this (note the extra `no_tls1_3` at the end):
如果我们在没有TLSv1.3支持的情况下启动OpenSSL服务器，就像这样（注意最后额外的 `no_tls1_3` ）：

```bash
openssl s_server -accept 4443 -cert localhost.pem -key localhost.key -www -no_tls1_3
```

The `tstclnt` tool will fail to connect:
 `tstclnt` 工具将无法连接：

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443 2>&1 | grep ^New
echo $?

1
```

To see the actual error, we can remove the `grep` at the end:
要查看实际错误，我们可以删除末尾的 `grep` ：

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443 2>&1

tstclnt: write to SSL socket failed: SSL_ERROR_PROTOCOL_VERSION_ALERT: Peer reports incompatible or unsupported protocol version.
```

If we allow the server to offer TLSv1.3:
如果我们允许服务器提供TLSv1.3： 

```bash
openssl s_server -accept 4443 -cert localhost.pem -key localhost.key -www
```

Then the connection completes:
然后连接完成： 

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443 2>&1 | grep ^New

New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
^C
```

### Use only AES256 with TLSv1.3 仅将AES 256与TLSv1.3配合使用 

In the previous example, the connection ended up using TLSv1.3 as  expected, but AES128. To enforce AES256, we can disallow the 128-bit  version:
在前面的示例中，连接最终使用TLSv1.3，但使用的是AES 128。要强制执行AES 256，我们可以禁止128位版本： 

```plaintext
library=
name=Policy
NSS=flags=policyOnly,moduleDB
config="disallow=aes128-gcm allow=tls-version-min=tls1.3"
```

This time the client selects something else:
这一次，客户端选择了其他东西： 

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443  2>&1 | grep ^New

New, TLSv1.3, Cipher is TLS_CHACHA20_POLY1305_SHA256
```

We can remove that one from the list as well:
我们也可以将其从列表中删除： 

```plaintext
config="disallow=aes128-gcm:chacha20-poly1305 allow=tls-version-min=tls1.3"
```

And now we get AES256:
现在我们得到了AES 256： 

```bash
echo "GET / HTTP/1.0" | tstclnt -d ~/.pki/nssdb -h localhost -p 4443  2>&1 | grep ^New

New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
```

## References 引用 

Unfortunately most of the upstream Mozilla documentation is either outdated or  deprecated, and the best reference available about the policy module at  the moment is in the source code and tests.
不幸的是，大多数上游Mozilla文档要么已经过时，要么已经过时，目前关于策略模块的最佳参考资料是源代码和测试。 

- [In the source code
   在源代码中](https://git.launchpad.net/ubuntu/+source/nss/tree/nss/lib/pk11wrap/pk11pars.c#n144)
- [In the tests (policy)
   政策（Policy）](https://git.launchpad.net/ubuntu/+source/nss/tree/nss/tests/policy)
- [In the tests (SSL policy)
   在测试中（SSL策略）](https://git.launchpad.net/ubuntu/+source/nss/tree/nss/tests/ssl/sslpolicy.txt)

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [                   Previous 先前                    GnuTLS                 ](https://ubuntu.com/server/docs/gnutls)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             [                   Next 下                    Java cryptography configuration
Java加密配置                  ](https://ubuntu.com/server/docs/java-cryptography-configuration)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

This page was last modified a month ago. [Help improve this document in the forum](https://discourse.ubuntu.com/t/network-security-services-nss/35168).
此页面最后一次修改是在一个月前。在论坛中帮助改进此文档。

# ava cryptography configuration Java加密配置 

The Java cryptographic settings are large and complex, with many layers and policies. Here we will focus on one aspect of it, which is how to apply some basic filters to the set of cryptographic algorithms available to  applications. The references section at the end contains links to more  information.
Java加密设置庞大而复杂，有许多层和策略。在这里，我们将重点关注它的一个方面，即如何将一些基本的过滤器应用于应用程序可用的加密算法集。最后的参考资料部分包含更多信息的链接。 

There are many versions of Java available in Ubuntu. It’s best to install the “default” one, which is represented by the `default-jre` (for the Runtime Environment) or `default-jdk` (for the Development Kit). And their non-GUI counterparts `default-jre-headless` and `default-jdk-headless`, respectively.
在Ubuntu中有许多Java版本。最好安装“默认”版本，它由 `default-jre` （用于Windows环境）或 `default-jdk` （用于开发工具包）表示。以及它们的非GUI对应项 `default-jre-headless` 和 `default-jdk-headless` 。

To install the default Java Runtime on Ubuntu Server, run the following command:
要在Ubuntu Server上安装默认的Java Runtime，请运行以下命令： 

```bash
sudo apt install default-jre-headless
```

## Config file Config文件 

The Java installation in Ubuntu ships a system-wide configuration tree under `/etc/java-<VERSION>-openjdk`. In Ubuntu Jammy 22.04 LTS, the default Java version is 11, so this directory will be `/etc/java-11/openjdk`. In that directory, the file that defines Java security settings, including cryptographic algorithms, is `/etc/java-11-openjdk/security/java.security`.
Ubuntu中的Java安装在 `/etc/java-<VERSION>-openjdk` 下提供了一个系统范围的配置树。在Ubuntu Jammy 22.04 LTS中，默认的Java版本是11，所以这个目录将是 `/etc/java-11/openjdk` 。在该目录中，定义Java安全设置（包括加密算法）的文件是 `/etc/java-11-openjdk/security/java.security` 。

This is a very large file, with many options and comments. Its structure is  simple, with configuration keys and their values. For crypto algorithms, we will be looking into the following settings:
这是一个非常大的文件，有许多选项和注释。它的结构很简单，有配置键和它们的值。对于加密算法，我们将研究以下设置： 

- `jdk.certpah.disabledAlgorithms`: Restrictions on algorithms and key lengths used in certificate path processing.
   `jdk.certpah.disabledAlgorithms` ：证书路径处理中使用的算法和密钥长度限制。
- `jdk.tls.disabledAlgorithms`: Restrictions on algorithms and key lengths used in SSL/TLS connections.
   `jdk.tls.disabledAlgorithms` ：SSL/TLS连接中使用的算法和密钥长度限制。

The list of restrictions has its own format which allows for constructs  that disable whole families of algorithms, key sizes, usage, and more.  The [`java.security` configuration file](https://git.launchpad.net/ubuntu/+source/openjdk-lts/tree/src/java.base/share/conf/security/java.security?h=applied/ubuntu/jammy-devel#n520) has comments explaining this syntax with some examples.
限制列表有自己的格式，允许禁用整个算法系列、密钥大小、用法等的构造。 `java.security` 配置文件中有注释，通过一些示例解释了这种语法。

Changes to these security settings can be made directly in the `/etc/java-11-openjdk/security/java.security` file, or in an alternate file that can be specified to a Java application by setting the `java.security.properties` value. For example, if your java application is called `myapp.java`, you can invoke it as shown below to specify an additional security properties file:
对这些安全设置的更改可以直接在 `/etc/java-11-openjdk/security/java.security` 文件中进行，也可以在通过设置 `java.security.properties` 值指定给Java应用程序的备用文件中进行。例如，如果您的java应用程序名为 `myapp.java` ，则可以如下所示调用它以指定附加的安全属性文件：

```bash
java -Djava.security.properties=file://$HOME/java.security
```

When using just one equals sign (“`=`”) as above, the settings from the specified file are appended to the existing ones. If, however, we use two equals signs:
当如上所述仅使用一个等号（“ `=` “）时，指定文件中的设置将附加到现有文件中。但是，如果我们使用两个等号：

```bash
java -Djava.security.properties==file://$HOME/java.security
```

Then the settings from `$HOME/java.security` completely override the ones from the main file at `/etc/java-11-openjdk/security/java.security`.
然后， `$HOME/java.security` 中的设置完全覆盖 `/etc/java-11-openjdk/security/java.security` 中主文件中的设置。

To disable the ability to specify an additional properties file in the command line, set the key `security.overridePropertiesFile` to `false` in `/etc/java-11-openjdk/security/java.security`.
要禁用在命令行中指定其他属性文件的功能，请在 `/etc/java-11-openjdk/security/java.security` 中将键 `security.overridePropertiesFile` 设置为 `false` 。

## Practical examples 实例 

Let’s see some practical examples of how we can use the configuration file to tweak the default cryptographic settings of a Java application.
让我们看一些实际的例子，看看如何使用配置文件来调整Java应用程序的默认加密设置。 

The examples will use the Java `keytool` utility for the client part, and a simple OpenSSL test server on  localhost for the server part. Since OpenSSL has its own separate  configuration, it won’t be affected by the changes we make to the Java  security settings.
这些示例将使用Java `keytool` 实用程序作为客户端部分，使用本地主机上的一个简单OpenSSL测试服务器作为服务器部分。由于OpenSSL有自己独立的配置，因此它不会受到我们对Java安全设置所做的更改的影响。

### Test setup 测试设置 

To use the test OpenSSL server, we will have to generate a certificate and key for it to use, and then import that into the Java Certificate  Authority (CA) database so it can be trusted.
要使用测试OpenSSL服务器，我们必须生成一个证书和密钥供它使用，然后将其导入Java证书颁发机构（CA）数据库，以便它可以被信任。 

First, generate a keypair for OpenSSL:
首先，为OpenSSL生成一个密钥对： 

```bash
openssl req -new -x509 -days 30 -nodes -subj "/CN=localhost" -out localhost.pem -keyout localhost.key
```

Now let’s import this new certificate into the system-wide CA database. Execute the following commands:
现在让我们将这个新证书导入到系统范围的CA数据库中。执行以下命令： 

```bash
sudo cp localhost.pem /usr/local/share/ca-certificates/localhost-test.crt
sudo update-ca-certificates
```

For our testing purposes, this is how we will launch our OpenSSL test server:
出于测试目的，我们将以以下方式启动OpenSSL测试服务器： 

```bash
openssl s_server -accept 4443 -cert localhost.pem -key localhost.key | grep ^CIPHER
```

This will show the cipher that was selected for each connection, as it occurs.
这将显示为每个连接选择的密码。 

The client part of our setup will be using the `keytool` utility that comes with Java, but any Java application that is capable  of using SSL/TLS should suffice. We will be running the client as below:
我们设置的客户端部分将使用Java附带的 `keytool` 实用程序，但任何能够使用SSL/TLS的Java应用程序都应该足够了。我们将运行客户端如下：

```bash
keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443 > /dev/null;echo $?
```

These are the parameters:
这些是参数： 

- `-J-Djava.security.properties=...`
   This is used to point at the configuration file snippet that has our changes. It is NOT NEEDED if you are modifying `/etc/java-11-openjdk/security/java.security` instead.
   这用于指向包含我们更改的配置文件片段。如果您正在修改 `/etc/java-11-openjdk/security/java.security` ，则不需要。
- `-printcert -sslserver localhost:4443`
   Connect to a server on localhost (`-sslserver` is a parameter to `-printcert`, so we need the latter even though we are not interested in the certificate).
   连接到localhost上的服务器（ `-sslserver` 是 `-printcert` 的参数，所以我们需要后者，即使我们对证书不感兴趣）。

The rest is just to ignore all non-error output, and show us the exit status (`0` for success, anything else for an error).
剩下的就是忽略所有非错误输出，并向我们显示退出状态（ `0` 表示成功，其他表示错误）。

> **Note**: 注意：
>  `keytool` is not really intended as a tool to test SSL/TLS connections, but being part of the Java packaging makes it convenient and it’s enough for our  purposes.
>  `keytool` 实际上并不打算作为测试SSL/TLS连接的工具，但作为Java包的一部分使其非常方便，足以满足我们的目的。

Let’s see some examples now.
我们来看看一些例子。 

### Only use TLSv1.3 仅使用TLSv1.3 

Create `$HOME/java.security` with the following content:
使用以下内容创建 `$HOME/java.security` ：

```plaintext
jdk.tls.disabledAlgorithms=TLSv1, TLSv1.1, TLSv1.2, SSLv3, SSLv2
```

Notice that TLSv1.3 is absent.
请注意，TLSv1.3不存在。 

When you then run the `keytool` utility:
当您运行 `keytool` 实用程序时：

```bash
$ keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443 > /dev/null;echo $?

0
```

The server should log:
服务器应记录： 

```bash
$ openssl s_server -accept 4443 -key localhost.key -cert localhost.pem   | grep ^CIPHER

CIPHER is TLS_AES_256_GCM_SHA384
```

That is a TLSv1.3 cipher. To really test that TLSv1.3 is the only protocol available, we can force some failures:
这是TLSv1.3密码。为了真正测试TLSv1.3是唯一可用的协议，我们可以强制执行一些失败： 

Force the client to try to use TLSv1.2:
强制客户端尝试使用TLSv1.2： 

```bash
$ keytool \
  -J-Djava.security.properties=file://$HOME/java.security \
  -J-Djdk.tls.client.protocols=TLSv1.2 \
  -printcert -sslserver localhost:4443

keytool error: java.lang.Exception: No certificate from the SSL server
```

Restart the server with the `no_tls1_3` option, disabling TLSv1.3, and run the client again as originally (without the extra TLSv1.2 option we added above):
使用 `no_tls1_3` 选项重新启动服务器，禁用TLSv1.3，然后像原来一样再次运行客户端（没有我们上面添加的额外TLSv1.2选项）：

**Server**: 服务器：

```bash
$ openssl s_server -accept 4443 -key localhost.key -cert localhost.pem -no_tls1_3

Using default temp DH parameters
ACCEPT
ERROR
40676E75B37F0000:error:0A000102:SSL routines:tls_early_post_process_client_hello:unsupported protocol:../ssl/statem/statem_srvr.c:1657:
shutting down SSL
CONNECTION CLOSED
```

**Client**: 客户：

```bash
$ keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443

keytool error: java.lang.Exception: No certificate from the SSL server
```

To get a little bit more verbosity in the `keytool` output, you can add the `-v` option. Then, inside the traceback that we get back, we can see an error message about an SSL protocol version:
要在 `keytool` 输出中获得更多的详细信息，可以添加 `-v` 选项。然后，在我们返回的traceback中，我们可以看到关于SSL协议版本的错误消息：

```bash
$ keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443  -v

keytool error: java.lang.Exception: No certificate from the SSL server
java.lang.Exception: No certificate from the SSL server
        at java.base/sun.security.tools.keytool.Main.doPrintCert(Main.java:2981)
        at java.base/sun.security.tools.keytool.Main.doCommands(Main.java:1292)
        at java.base/sun.security.tools.keytool.Main.run(Main.java:421)
        at java.base/sun.security.tools.keytool.Main.main(Main.java:414)
Caused by: javax.net.ssl.SSLHandshakeException: Received fatal alert: protocol_version
...
```

### Prevent a specific cipher 防止特定密码 

The [Java Security Standard Algorithm Names](https://docs.oracle.com/en/java/javase/11/docs/specs/security/standard-names.html) page lists the names of all the cryptographic algorithms recognised by  Java. If you want to prevent a specific algorithm from being used, you  can list it in the `java.security` file.
Java Security Standard Algorithm Names（Java安全标准算法名称）页列出了Java可识别的所有加密算法的名称。如果您想阻止使用特定的算法，可以在 `java.security` 文件中列出它。

In the previous example where we allowed only TLSv1.3 we saw that the negotiated algorithm was `TLS_AES_256_GCM_SHA384`. But what happens if we block it?
在前面的例子中，我们只允许TLSv1.3，我们看到协商的算法是 `TLS_AES_256_GCM_SHA384` 。但是如果我们阻止了它会发生什么？

Add `TLS_AES_256_GCM_SHA384` to `jdk.tls.disabledAlgorithms` in `$HOME/java.security` like this:
在 `$HOME/java.security` 中添加 `TLS_AES_256_GCM_SHA384` 到 `jdk.tls.disabledAlgorithms` ，如下所示：

```plaintext
jdk.tls.disabledAlgorithms=TLSv1, TLSv1.1, TLSv1.2, SSLv3, SSLv2, TLS_AES_256_GCM_SHA384
```

If we run our client now:
如果我们现在运行客户端： 

```bash
$ keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443 > /dev/null; echo $?

0
```

The server will show the new selected cipher:
服务器将显示新选择的密码： 

```bash
$ openssl s_server -accept 4443 -key localhost.key -cert localhost.pem | grep ^CIPHER

CIPHER is TLS_AES_128_GCM_SHA256
```

## Blocking cipher “elements” 阻塞密码“元素” 

With TLSv1.3 ciphers, we must list the exact cipher name. With TLSv1.2  ciphers, however, there is a bit more flexibility and we can list just  an “element”.
对于TLSv1.3密码，我们必须列出确切的密码名称。然而，使用TLSv1.2密码，有更多的灵活性，我们可以只列出一个“元素”。 

For example, let’s check out a case where we only allow TLSv1.2 for simplicity by once again modifying `$HOME/java.security`:
例如，让我们检查一个情况，为了简单起见，我们只允许TLSv1.2，再次修改 `$HOME/java.security` ：

```plaintext
jdk.tls.disabledAlgorithms=TLSv1, TLSv1.1, TLSv1.3, SSLv2, SSLv3
```

When we run the client:
当我们运行客户端时： 

```bash
$ keytool -J-Djava.security.properties=file://$HOME/java.security -printcert -sslserver localhost:4443  > /dev/null; echo $?

0
```

The server reports: 服务器报告： 

```bash
$ openssl s_server -accept 4443 -key localhost.key -cert localhost.pem | grep ^CIPHER

CIPHER is ECDHE-RSA-AES256-GCM-SHA384
```

We can block just the AES256 component by using:
我们可以通过使用以下命令仅阻止AES 256组件： 

```plaintext
jdk.tls.disabledAlgorithms=TLSv1, TLSv1.1, TLSv1.3, SSLv2, SSLv3, AES_256_GCM
```

And now the server reports:
现在服务器报告： 

```bash
$ openssl s_server -accept 4443 -key localhost.key -cert localhost.pem | grep ^CIPHER

CIPHER is ECDHE-RSA-CHACHA20-POLY1305
```

## References 引用 

- Additional information on [Java’s Cryptographic Algorithms settings](https://www.java.com/en/configure_crypto.html)
  有关Java加密算法设置的其他信息
- Java Security [Standard Algorithm Names](https://docs.oracle.com/en/java/javase/12/docs/specs/security/standard-names.html)
  Java安全标准算法名称
- [Keytool upstream documentation
   Keytool上游文档](https://docs.oracle.com/en/java/javase/11/tools/keytool.html)
- [`java.security` file with comments](https://git.launchpad.net/ubuntu/+source/openjdk-lts/tree/src/java.base/share/conf/security/java.security?h=applied/ubuntu/jammy-devel#n520) – links to the section which explains the crypto algorithm restrictions)
  带注释的 `java.security` 文件-指向解释加密算法限制的部分的链接）

------

# BIND 9 DNSSEC cryptography selection BIND 9 DNSSEC加密选择 

Domain Name System Security Extensions (DNSSEC), which provides a set of  security features to DNS, is a broad topic. In this article, we will  briefly show DNSSEC validation happening on a `bind9` DNS server, and then introduce the topic of how we can disable certain  cryptographic algorithms from being used in this validation.
域名系统安全扩展（DNSSEC）为DNS提供了一组安全功能，是一个广泛的主题。在本文中，我们将简要介绍在 `bind9` DNS服务器上发生的DNSSEC验证，然后介绍如何在此验证中禁用某些加密算法。

## DNSSEC validation DNSSEC验证 

Out of the box, the BIND 9 DNS server is configured to try to use DNSSEC  whenever it’s available, doing all the validation checks automatically.  This is done via the `dnssec-validation` setting in `/etc/bind/named.conf.options`:
开箱即用，BIND 9 DNS服务器被配置为尝试使用DNSSEC，只要它可用，自动执行所有验证检查。这是通过 `/etc/bind/named.conf.options` 中的 `dnssec-validation` 设置完成的：

```plaintext
options {
    (...)
    dnssec-validation auto;
    (...)
};
```

This can be quickly checked with the help of `dig`. Right after you installed `bind9`, you can probe ask it about the `isc.org` domain:
这可以在 `dig` 的帮助下快速检查。安装 `bind9` 后，您可以探测并询问 `isc.org` 域：

```bash
$ dig @127.0.0.1 isc.org +dnssec +multiline

; <<>> DiG 9.18.12-0ubuntu0.22.04.1-Ubuntu <<>> @127.0.0.1 isc.org +dnssec +multiline
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 57669
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
; COOKIE: 71aa6b4e4ca6bb4b01000000643fee81edf0840b48d28d44 (good)
;; QUESTION SECTION:
;isc.org.		IN A

;; ANSWER SECTION:
isc.org.		300 IN A 149.20.1.66
isc.org.		300 IN RRSIG A 13 2 300 (
				20230510161711 20230410161439 27566 isc.org.
				EUA5QPEjtVC0scPsvf1c/EIBKHRpS8ektiWiOqk6nb3t
				JhJAt9uCr3e0KNAcc3WDU+wJzEvqDyJrlZoELqT/pQ== )

;; Query time: 740 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Apr 19 13:37:05 UTC 2023
;; MSG SIZE  rcvd: 183
```

We can see that a `RRSIG` DNSSEC record was returned, but the key information in this output is the `ad` flag near the top. That stands for “authenticated data”, and means that the DNSSEC records in the response were validated.
我们可以看到返回了 `RRSIG` DNSSEC记录，但此输出中的关键信息是顶部附近的 `ad` 标志。这代表“经过身份验证的数据”，意味着响应中的DNSSEC记录已经过验证。

To see an example where this verification fails, we can use the `www.dnssec-failed.org` domain, which is specially crafted for this:
要查看此验证失败的示例，我们可以使用 `www.dnssec-failed.org` 域，该域为此而特制：

```bash
$ dig @127.0.0.1 www.dnssec-failed.org +dnssec +multiline

; <<>> DiG 9.18.12-0ubuntu0.22.04.1-Ubuntu <<>> @127.0.0.1 www.dnssec-failed.org +dnssec +multiline
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 56056
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
; COOKIE: 541f6c66a216acdb01000000643fef9ebb21307fee2ea0e3 (good)
;; QUESTION SECTION:
;www.dnssec-failed.org.	IN A

;; Query time: 1156 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Apr 19 13:41:50 UTC 2023
;; MSG SIZE  rcvd: 78
```

Here we see that:
在这里我们看到： 

- There is no `IN A` IP address shown in the reply
  回复中没有显示 `IN A` IP地址
- The status is `SERVFAIL` 状态为 `SERVFAIL` 
- There is no `ad` flag
  没有 `ad` 标志

In the `bind9` logs, we will see DNSSEC validation errors:
在 `bind9` 日志中，我们将看到DNSSEC验证错误：

```bash
$ journalctl -u named.service -n 10

Apr 19 13:41:50 j named[3018]: validating dnssec-failed.org/DNSKEY: no valid signature found (DS)
Apr 19 13:41:50 j named[3018]: no valid RRSIG resolving 'dnssec-failed.org/DNSKEY/IN': 68.87.76.228#53
Apr 19 13:41:50 j named[3018]: broken trust chain resolving 'www.dnssec-failed.org/A/IN': 68.87.85.132#53
(...)
```

We can run `dig` with the `+cd` command line parameter which disables this verification, but notice that still we don’t get the `ad` flag in the reply:
我们可以使用 `+cd` 命令行参数运行 `dig` ，禁用此验证，但请注意，我们仍然没有在回复中获得 `ad` 标志：

```bash
$ dig @127.0.0.1 www.dnssec-failed.org +dnssec +multiline +cd

; <<>> DiG 9.18.12-0ubuntu0.22.04.1-Ubuntu <<>> @127.0.0.1 www.dnssec-failed.org +dnssec +multiline +cd
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42703
;; flags: qr rd ra cd; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
; COOKIE: 3d6a4f4ff0014bdc01000000643ff01c3229ed7d798c5f8d (good)
;; QUESTION SECTION:
;www.dnssec-failed.org.	IN A

;; ANSWER SECTION:
www.dnssec-failed.org.	7031 IN	A 68.87.109.242
www.dnssec-failed.org.	7031 IN	A 69.252.193.191
www.dnssec-failed.org.	7074 IN	RRSIG A 5 3 7200 (
				20230505145108 20230418144608 44973 dnssec-failed.org.
				R6/u+5Gv3rH93gO8uNvz3sb9ErQNuvFKu6W5rtUleXF/
				vkqJXbNe8grMuiV6Y+CNEP6jRBu0jOBPncb5cXbfcmfo
				CoVOjpsLySxt4D1EUl4yByWm2ZAdXRrk6A8SaldIdDv8
				9t+FguTdQrZv9Si+afKrLyC7L/mltXMllq3stDI= )

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Apr 19 13:43:56 UTC 2023
;; MSG SIZE  rcvd: 287
```

## Restricting DNSSEC algorithms 限制DNSSEC算法 

It’s possible to limit the cryptographic algorithms used by BIND to validate DNSSEC records. This is done via two configuration settings, located  inside the `options { }` block of `/etc/named/named.conf.options`:
可以限制BIND使用的加密算法来验证DNSSEC记录。这是通过两个配置设置完成的，位于 `/etc/named/named.conf.options` 的 `options { }` 块内：

- `disable-algorithms "<domain>" { a; b; ... };`
   Disables the listed algorithms for the specified domain and all subdomains of it.
   禁用指定域及其所有子域的列出算法。
- `disable-ds-digests "<domain>" { a; b; ... };`
   Disables the listed digital signature digests for the specified domain and all subdomains of it.
   禁用指定域及其所有子域的列出的数字签名验证。

For example, the following disables `RSAMD5`, `DSA` and `GOST` for all zones:
例如，以下命令将对所有分区禁用 `RSAMD5` 、 `DSA` 和 `GOST` ：

```plaintext
disable-algorithms "." {
    RSAMD5;
    DSA;
};
disable-ds-digest "." {
    GOST;
};
```

The list of algorithm names can be obtained at [DNSSEC Algorithm Numbers](https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml), in the **Mnemonic** column of the **Available Formats** table. The algorithm number is also standardised, and is part of the DNSSEC records.
算法名称列表可以在“可用的DNS”表的“助记符”列中的DNSSEC算法编号处获得。算法编号也是标准化的，并且是DNSSEC记录的一部分。

For example, if we go back to the `dig` result from before where we inspected the `isc.org` domain, the `RRSIG` record had this (showing just the first line for brevity):
例如，如果我们回到之前检查 `isc.org` 域的 `dig` 结果，则 `RRSIG` 记录如下（为了简洁起见，仅显示第一行）：

```plaintext
isc.org.        300 IN RRSIG A 13 2 300 (
```

In that record, the number `13` is the algorithm number, and in this case it means the algorithm `ECDSAP256SHA256` was used.
在该记录中，编号 `13` 是算法编号，在这种情况下，它意味着使用了算法 `ECDSAP256SHA256` 。

Just to see how BIND would react to an algorithm being disabled, let’s temporarily add `ECDSAP256SHA256` to the list of disabled algorithms:
为了看看BIND对禁用算法的反应，让我们暂时将 `ECDSAP256SHA256` 添加到禁用算法的列表中：

```plaintext
disable-algorithms "." {
   RSAMD5;
   DSA;
   ECDSAP256SHA256;
};
```

And restart BIND: 然后重新启动BIND： 

```bash
sudo systemctl restart bind9.service
```

Now the `ad` flag is gone, meaning that this answer wasn’t validated:
现在 `ad` 标志消失了，这意味着这个答案没有被验证：

```bash
$ dig @127.0.0.1 isc.org +dnssec +multiline

; <<>> DiG 9.18.1-1ubuntu1-Ubuntu <<>> @127.0.0.1 isc.org +dnssec +multiline
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43893
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
; COOKIE: 6527ce585598025d01000000643ff8fa02418ce38af13fa7 (good)
;; QUESTION SECTION:
;isc.org.               IN A

;; ANSWER SECTION:
isc.org.                300 IN A 149.20.1.66
isc.org.                300 IN RRSIG A 13 2 300 (
                                20230510161711 20230410161439 27566 isc.org.
                                EUA5QPEjtVC0scPsvf1c/EIBKHRpS8ektiWiOqk6nb3t
                                JhJAt9uCr3e0KNAcc3WDU+wJzEvqDyJrlZoELqT/pQ== )

;; Query time: 292 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Apr 19 14:21:46 UTC 2023
;; MSG SIZE  rcvd: 183
```

The logs only say there was no valid signature found:
日志只说没有找到有效的签名： 

```plaintext
Apr 19 14:23:01 j-bind9 named[2786]: validating isc.org/A: no valid signature found
```

Note this is different from rejecting the response: it just means that this  response is being treated as if it didn’t have any DNSSEC components in  it, or in other words, it’s treated as “insecure”.
请注意，这与拒绝响应不同：它只是意味着该响应被视为其中没有任何DNSSEC组件，或者换句话说，它被视为“不安全”。 

In general, as always with cryptography, be careful with which algorithms  you decide to disable and remove from DNSSEC validation, as such errors  can be hard to diagnose. To help with troubleshooting, the Internet  Systems Consortium (ISC) has published a very extensive DNSSEC guide,  which contains a detailed troubleshooting section (see below).
一般来说，与加密一样，要小心决定禁用哪些算法并从DNSSEC验证中删除，因为这些错误可能很难诊断。为了帮助进行故障排除，Internet Systems Consortium（ISC）发布了一个非常广泛的DNSSEC指南，其中包含详细的故障排除部分（见下文）。 

> **Note**: 注意：
>  Remember now to remove the disabling of `ECDSAP256SHA256` from `/etc/bind/named.conf.options` and restart BIND 9. This change was just a quick test!
>  记住现在从 `/etc/bind/named.conf.options` 中删除 `ECDSAP256SHA256` 的禁用并重新启动BIND 9。这个变化，只是一个快速的测试！

## References 引用 

- [ISC’s DNSSEC Guide ISC的DNSSEC指南](https://bind9.readthedocs.io/en/v9.18.14/dnssec-guide.html)
- [DNSSEC troubleshooting section of the ISC DNSSEC guide
   ISC DNSSEC指南的DNSSEC故障排除部分](https://bind9.readthedocs.io/en/v9.18.14/dnssec-guide.html#basic-dnssec-troubleshooting)
- [Standard algorithms used for DNSSEC
   用于DNSSEC的标准算法](https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml)

------

# OpenSSH crypto configuration OpenSSH加密配置 

Establishing an SSH connection to a remote service involves multiple stages. Each  one of these stages will use some form of encryption, and there are  configuration settings that control which cryptographic algorithms can  be used at each step.
建立到远程服务的SSH连接涉及多个阶段。这些阶段中的每一个都将使用某种形式的加密，并且有配置设置来控制每个步骤可以使用哪些加密算法。 

The default selection of algorithms for each stage should be good enough  for the majority of deployment scenarios. Sometimes, however, a  compliance rule, or a set of legacy servers, or something else, requires a change in this selection. Perhaps a legacy system or piece of  hardware that is still in production is not compatible with the current  encryption schemes and requires legacy algorithms to be enabled again.  Or a compliance rule that isn’t up-to-date with the current crypto  standards doesn’t allow a more advanced cipher.
每个阶段的默认算法选择对于大多数部署场景来说应该足够好。但是，有时候，合规性规则、一组遗留服务器或其他东西需要更改此选择。可能仍在生产中的遗留系统或硬件与当前的加密方案不兼容，需要再次启用遗留算法。或者，不符合当前加密标准的合规规则不允许更高级的密码。 

> **WARNING**: ：
>  Be careful when restricting cryptographic algorithms in SSH, specially  on the server side. You can inadvertently lock yourself out of a remote  system!
>  在SSH中限制加密算法时要小心，特别是在服务器端。您可能会无意中将自己锁定在远程系统之外！

## Algorithm configuration general rules 算法配置一般规则 

Most of the configuration options that take a list of cryptographic  algorithms follow a defined set of rules. The first algorithm in the  list (that the **client** offers to the server) that matches an offer from the server, is what will be selected. The rules are as follows:
大多数采用加密算法列表的配置选项都遵循一组已定义的规则。列表中的第一个算法（客户端提供给服务器）匹配来自服务器的报价，将被选择。规则如下：

- The lists are algorithm names separated by commas. For example, `Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com` will replace the current set of ciphers with the two named algorithms.
  这些列表是用逗号分隔的算法名称。例如， `Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com` 将用两个命名算法替换当前密码集。
- Instead of specifying the full list, which will replace the existing default  one, some manipulations are allowed. If the list starts with:
  代替指定完整列表，这将取代现有的默认列表，允许一些操作。如果列表以以下开头： 
  - **`+`**
     The specified algorithm(s) will be appended to the end of the default set. For example, `MACs +hmac-sha2-512,hmac-sha2-256` will append *both* Message Authentication Code (MAC) algorithms to the end of the current set.
     指定的算法将附加到默认集的末尾。例如， `MACs +hmac-sha2-512,hmac-sha2-256` 会将两个消息验证码（MAC）算法都附加到当前集合的末尾。
  - **`-`**
     The specified algorithm(s) will be removed from the default set. For example, `KexAlgorithms -diffie-hellman-group1-sha1,diffie-hellman-group14-sha1` will remove *both* key exchange algorithms from the current set.
     指定的算法将从默认设置中删除。例如， `KexAlgorithms -diffie-hellman-group1-sha1,diffie-hellman-group14-sha1` 将从当前集合中删除两个密钥交换算法。
  - **`^`**
     The specified ciphers will be placed at the beginning of the default set. For example, `PubkeyAcceptedAlgorithms ^ssh-ed25519,ecdsa-sha2-nistp256` will move *both* signature algorithms to the start of the set.
     指定的密码将放在默认密码集的开头。例如， `PubkeyAcceptedAlgorithms ^ssh-ed25519,ecdsa-sha2-nistp256` 会将两个签名算法都移动到集合的开头。
  - Wildcards (**`\*`**) are also allowed, but be careful to not inadvertently include or exclude something that wasn’t intended.
    通配符（ `*` ）也是允许的，但要注意不要无意中包含或排除一些不想要的东西。

With rare exceptions, the list of algorithms can be queried by running `ssh -Q <config>`, where `<config>` is the configuration setting name. For example, `ssh -Q ciphers` will show the available list of ciphers.
除了极少数例外情况，可以通过运行 `ssh -Q <config>` 查询算法列表，其中 `<config>` 是配置设置名称。例如， `ssh -Q ciphers` 将显示可用的密码列表。

> **Note**: 注意：
>  The output of the `ssh -Q <name>` command will not take into consideration the configuration changes that may have been made. It cannot therefore be used to test the crypto  configuration changes.
>  `ssh -Q <name>` 命令的输出不会考虑可能已进行的配置更改。因此，它不能用于测试加密配置更改。

## Configuration settings 配置设置 

It’s not the goal of this documentation to repeat the excellent upstream  documentation (see the References section at the end of this page).  Instead, we will show the configuration options, and some examples of  how to use them.
本文档的目的不是重复优秀的上游文档（请参阅本页末尾的参考资料部分）。相反，我们将展示配置选项，以及如何使用它们的一些示例。 

Here are the configuration settings that control the cryptographic  algorithms selection. Unless otherwise noted, they apply to both the  server and the client.
下面是控制加密算法选择的配置设置。除非另有说明，它们适用于服务器和客户端。 

- `Ciphers`
   List of symmetric ciphers. Examples include `aes256-ctr` and `chacha20-poly1305@openssh.com`.
   对称密码列表。示例包括 `aes256-ctr` 和 `chacha20-poly1305@openssh.com` 。
- `MACs`
   List of Message Authentication Code algorithms, used for data integrity protection. The `-etm` versions calculate the MAC after encryption and are considered safer. Examples include `hmac-sha2-256` and `hmac-sha2-512-etm@openssh.com`.
   用于数据完整性保护的消息验证码算法列表。 `-etm` 版本在加密后计算MAC，被认为更安全。示例包括 `hmac-sha2-256` 和 `hmac-sha2-512-etm@openssh.com` 。
- `GSSAPIKexAlgorithms`
   This option is not available in OpenSSH upstream, and is [provided via a patch](https://git.launchpad.net/ubuntu/+source/openssh/tree/debian/patches/gssapi.patch?h=applied/ubuntu/jammy-devel) that Ubuntu and many other Linux Distributions carry. It lists the key  exchange (kex) algorithms that are offered for Generic Security Services Application Program Interface (GSSAPI) key exchange, and only applies  to connections using GSSAPI. Examples include `gss-gex-sha1-` and `gss-group14-sha256-`.
   此选项在OpenSSH上游中不可用，并且通过Ubuntu和许多其他Linux发行版携带的补丁提供。它列出了为通用安全服务应用程序接口（GSSAPI）密钥交换提供的密钥交换（kex）算法，并且仅适用于使用GSSAPI的连接。示例包括 `gss-gex-sha1-` 和 `gss-group14-sha256-` 。
- `KexAlgorithms`
   List of available key exchange (kex) algorithms. Examples include `curve25519-sha256` and `sntrup761x25519-sha512@openssh.com`.
   可用的密钥交换（Kex）算法列表。示例包括 `curve25519-sha256` 和 `sntrup761x25519-sha512@openssh.com` 。
- `HostKeyAlgorithms`
   This is a **server-only** configuration option. It lists the available host key signature algorithms that the server offers. Examples include `ssh-ed25519-cert-v01@openssh.com` and `ecdsa-sha2-nistp521-cert-v01@openssh.com`.
   这是一个仅限服务器的配置选项。它列出了服务器提供的可用主机密钥签名算法。示例包括 `ssh-ed25519-cert-v01@openssh.com` 和 `ecdsa-sha2-nistp521-cert-v01@openssh.com` 。
- `PubkeyAcceptedAlgorithms`
   List of signature algorithms that will be accepted for public key authentication. Examples include `ssh-ed25519-cert-v01@openssh.com` and `rsa-sha2-512-cert-v01@openssh.com`.
   公钥身份验证将接受的签名算法列表。示例包括 `ssh-ed25519-cert-v01@openssh.com` 和 `rsa-sha2-512-cert-v01@openssh.com` 。
- `CASignatureAlgorithms`
   List of algorithms that certificate authorities (CAs) are allowed to use to sign certificates. Certificates signed using any other algorithm  will not be accepted for public key or host-based authentication.  Examples include `ssh-ed25519` and `ecdsa-sha2-nistp384`.
   允许证书颁发机构（CA）用于签名证书的算法列表。公钥或基于主机的身份验证不接受使用任何其他算法签名的证书。示例包括 `ssh-ed25519` 和 `ecdsa-sha2-nistp384` 。

To check what effect a configuration change has on the server, it’s helpful to use the `-T` parameter and `grep` the output for the configuration key you want to inspect. For example, to check the current value of the `Ciphers` configuration setting after having set `Ciphers ^3des-cbc` in `sshd_config`:
要检查配置更改对服务器的影响，使用 `-T` 参数和 `grep` 您想要检查的配置密钥的输出会很有帮助。例如，在 `sshd_config` 中设置 `Ciphers ^3des-cbc` 后，检查 `Ciphers` 配置设置的当前值：

```console
$ sudo sshd -T | grep ciphers

ciphers 3des-cbc,chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
```

The output will include changes made to the configuration key. There is no need to restart the service.
输出将包括对配置键所做的更改。不需要重新启动服务。 

## OpenSSH examples OpenSSH示例 

Here are some examples of how the cryptographic algorithms can be selected in OpenSSH.
下面是一些如何在OpenSSH中选择加密算法的示例。 

### Which cipher was used? 使用了哪种密码？ 

One way to examine which algorithm was selected is to add the `-v` parameter to the `ssh` client.
检查选择了哪种算法的一种方法是将 `-v` 参数添加到 `ssh` 客户端。

For example, assuming password-less public key authentication is being used (so no password prompt), we can use this command to initiate the  connection and exit right away:
例如，假设正在使用无密码公钥身份验证（因此没有密码提示），我们可以使用此命令启动连接并立即退出： 

```console
$ ssh -v <server> exit 2>&1 | grep "cipher:"

debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
```

In the above case, the `chacha20` cipher was automatically selected. We can influence this decision and only offer one algorithm:
在上述情况下，自动选择 `chacha20` 密码。我们可以影响这个决定，只提供一个算法：

```console
$ ssh -v -c aes128-ctr <server> exit 2>&1 | grep "cipher:"

debug1: kex: server->client cipher: aes128-ctr MAC: umac-64-etm@openssh.com compression: none
debug1: kex: client->server cipher: aes128-ctr MAC: umac-64-etm@openssh.com compression: none
```

For the other stages in the `ssh` connection, like key exchange, or public key authentication, other expressions for the `grep` command have to be used. In general, it will all be visible in the full `-v` output.
对于 `ssh` 连接中的其他阶段，如密钥交换或公钥认证，必须使用 `grep` 命令的其他表达式。一般来说，它都将在完整的 `-v` 输出中可见。

### Remove AES 128 from server 从服务器中删除AES 128 

Let’s configure an OpenSSH server to only offer the AES 256 bit variant of symmetric ciphers for an `ssh` connection.
让我们配置一个OpenSSH服务器，只为 `ssh` 连接提供对称密码的AES 256位变体。

First, let’s see what the default is:
首先，让我们看看默认值是什么： 

```console
$ sudo sshd -T | grep ciphers

ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
```

Now let’s make our change. On the server, we can edit `/etc/ssh/sshd_config` and add this line:
现在让我们做出改变。在服务器上，我们可以编辑 `/etc/ssh/sshd_config` 并添加这一行：

```plaintext
Ciphers -aes128*
```

And then check what is left:
然后看看剩下的是什么： 

```bash
$ sudo sshd -T | grep ciphers

ciphers chacha20-poly1305@openssh.com,aes192-ctr,aes256-ctr,aes256-gcm@openssh.com
```

To activate the change, `ssh` has to be restarted:
要激活更改，必须重新启动 `ssh` ：

```bash
$ sudo systemctl restart ssh.service
```

After we restart the service, clients will no longer be able to use AES 128 to connect to it:
在我们重新启动服务后，客户端将无法再使用AES 128连接到它： 

```console
$ ssh -c aes128-ctr <server>

Unable to negotiate with 10.0.102.49 port 22: no matching cipher found. Their offer: chacha20-poly1305@openssh.com,aes192-ctr,aes256-ctr,aes256-gcm@openssh.com
```

### Prioritise AES 256 on the client 在客户端上优先考虑AES 256 

If we just want to prioritise a particular cipher, we can use the “`^`” character to move it to the front of the list, without disabling any other cipher:
如果我们只是想优先考虑一个特定的密码，我们可以使用“ `^` “字符将其移动到列表的前面，而不禁用任何其他密码：

```console
$ ssh -c ^aes256-ctr -v <server> exit 2>&1 | grep "cipher:"

debug1: kex: server->client cipher: aes256-ctr MAC: umac-64-etm@openssh.com compression: none
debug1: kex: client->server cipher: aes256-ctr MAC: umac-64-etm@openssh.com compression: none
```

In this way, if the server we are connecting to does not support AES 256,  the negotiation will pick up the next one from the list. If we do that  on the server via `Ciphers -aes256*`, this is what the same client, with the same command line, now reports:
这样，如果我们连接的服务器不支持AES 256，协商将从列表中选择下一个。如果我们通过 `Ciphers -aes256*` 在服务器上这样做，这是同一个客户端，使用相同的命令行，现在报告：

```console
$ ssh -c ^aes256-ctr -v <server> exit 2>&1 | grep "cipher:"

debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
```

## References 引用 

- [OpenSSH upstream documentation index
   OpenSSH上游文档索引](https://www.openssh.com/manual.html)
- [Ubuntu `sshd_config` man page Ubuntu `sshd_config` 手册页](https://manpages.ubuntu.com/manpages/jammy/man5/sshd_config.5.html)
- [Ubuntu `ssh_config` man page Ubuntu `ssh_config` 手册页](https://manpages.ubuntu.com/manpages/jammy/man5/ssh_config.5.html)

------

# Troubleshooting TLS/SSL 

Debugging TLS/SSL connections and protocols can be daunting due to their complexity. Here are some troubleshooting tips.
TLS/SSL连接和协议由于其复杂性而令人生畏。以下是一些故障排除提示。 

## Separate the client and server 分离客户端和服务器 

Whenever testing TLS/SSL connections over the network, it’s best to really  separate the client and the server. Remember that the crypto library  configuration file is read by the library, not just by a server or a  client. It’s read by both. Therefore having separate systems acting as  clients and servers, with their own configuration files, makes things  simpler to analyse.
无论何时在网络上测试TLS/SSL连接，最好将客户端和服务器真正分开。请记住，加密库配置文件由库读取，而不仅仅是由服务器或客户端读取。它被两个人阅读。因此，使用独立的系统作为客户端和服务器，并使用自己的配置文件，可以使分析变得更简单。 

## Tools 工具 

Here are some tools to help troubleshooting a TLS/SSL configuration.
下面是一些帮助解决TLS/SSL配置问题的工具。 

### OpenSSL server and client apps OpenSSL服务器和客户端应用程序 

The OpenSSL server and client tools are very handy to quickly bring up a  server with a selection of ciphers and protocols and test it with a  client. Being part of OpenSSL, these tools will also initialise the  library defaults directly from the OpenSSL config file, so they are very useful to test your configuration changes.
OpenSSL服务器和客户端工具非常方便，可以快速启动一个带有密码和协议选择的服务器，并使用客户端对其进行测试。作为OpenSSL的一部分，这些工具还将直接从OpenSSL配置文件初始化库默认值，因此它们对于测试您的配置更改非常有用。 

To bring up an OpenSSL server, a certificate with a private key is needed. There are many ways to generate a pair, and here is a quick one:
要启动OpenSSL服务器，需要一个带有私钥的证书。有很多方法可以生成一对，这里有一个快速的方法： 

```bash
$ openssl req -new -x509 -nodes -days 30 -out myserver.pem -keyout myserver.key
```

Answer the questions as you prefer, but the one that needs special attention is the `commonName` (`CN`) one, which should match the hostname of this server. Then bring up the OpenSSL server with this command:
根据您的喜好回答问题，但需要特别注意的是 `commonName` （ `CN` ）问题，它应该与此服务器的主机名匹配。然后使用以下命令启动OpenSSL服务器：

```bash
$ openssl s_server -cert myserver.pem -key myserver.key
```

That will bring up a TLS/SSL server on port 4433. Extra options that can be useful:
这将在端口4433上启动TLS/SSL服务器。可能有用的额外选项： 

- `-port N`: Set a port number. Remember that ports below 1024 require root privileges, so use `sudo` if that’s the case.
   `-port N` ：设置端口号。请记住，低于1024的端口需要root权限，因此在这种情况下使用 `sudo` 。
- `-www`: Will send back a summary of the connection information, like ciphers used, protocols, etc.
   `-www` ：将发送回连接信息的摘要，如使用的密码，协议等。
- `-tls1_2`, `-tls1_3`, `-no_tls1_3`, `-no_tls1_2`: Enable only the mentioned protocol version, or, with the `no_` prefix variant, disable it.
   `-tls1_2` 、 `-tls1_3` 、 `-no_tls1_3` 、 `-no_tls1_2` ：仅启用所提及的协议版本，或使用 `no_` 前缀变体禁用该版本。
- `-cipher <string>`: Use the specified cipher string for TLS1.2 and lower.
   `-cipher <string>` ：使用TLS1.2及更低版本的指定密码字符串。
- `-ciphersuite <string>`: Use the specified string for TLS1.3 ciphers.
   `-ciphersuite <string>` ：使用指定的字符串作为TLS 1.3密码。

The client connection tool can be used like this when connecting to `server`:
客户端连接工具在连接到 `server` 时可以这样使用：

```bash
$ echo | openssl s_client -connect server:port 2>&1 | grep ^New
```

That will generally show the TLS version used, and the selected cipher:
这通常会显示所使用的TLS版本和所选密码： 

```console
$ echo | openssl s_client -connect j-server.lxd:443 2>&1  | grep ^New
New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
```

The ciphers and protocols can also be selected with the same command line options as the server:
也可以使用与服务器相同的命令行选项选择密码和协议： 

```console
$ echo | openssl s_client -connect j-server.lxd:443 -no_tls1_3 2>&1  | grep ^New
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384

$ echo | openssl s_client -connect j-server.lxd:443 -no_tls1_3 2>&1 -cipher DEFAULT:-AES256 | grep ^New
New, TLSv1.2, Cipher is ECDHE-RSA-CHACHA20-POLY1305
```

### The `sslscan` tool `sslscan` 工具

The `sslscan` tool comes from a package with the same name, and it will scan a server and list the supported algorithms and protocols. It’s super useful for  determining if your configuration has really disabled or enabled a  particular cipher or TLS version.
 `sslscan` 工具来自一个同名的包，它将扫描服务器并列出支持的算法和协议。它对于确定您的配置是否真的禁用或启用了特定的密码或TLS版本非常有用。

To use the tool, point it at the server you want to scan:
要使用该工具，请将其指向要扫描的服务器： 

```bash
$ sslscan j-server.lxd
```

And you will get a report of the ciphers and algorithms supported by that server. [Consult its manpage](https://manpages.ubuntu.com/manpages/jammy/man1/sslscan.1.html) for more details.
您将获得该服务器支持的密码和算法的报告。更多细节请参考其手册页。

## References 引用 

- [OpenSSL s_server](https://manpages.ubuntu.com/manpages/kinetic/en/man1/openssl-s_server.1ssl.html)
- [OpenSSL s_client](https://manpages.ubuntu.com/manpages/kinetic/en/man1/openssl-s_client.1ssl.html)
- [sslscan ssl扫描](https://manpages.ubuntu.com/manpages/jammy/man1/sslscan.1.html)
- [https://badssl.com](https://badssl.com/): excellent website that can be used to test a client against a multitude of certificates, algorithms, key sizes, protocol versions, and more.
   https://badssl.com

# Choosing between the arm64 and arm64+largemem installer options 在arm64和arm64+largemem安装程序选项之间选择 

From 22.04.4 onwards, Ubuntu will provide both 4k and 64k page size kernel ISOs for ARM servers.
从22.04.4开始，Ubuntu将为ARM服务器提供4k和64k页面大小的内核ISO。 

The default **arm64** ISO will still use a 4k page size kernel, while the new 64k page size kernel ISO is named **arm64+largemem**.
默认的arm64 ISO仍然使用4k页面大小的内核，而新的64k页面大小的内核ISO被命名为arm64+largemem。

- [arm64 4k ISO download
   arm64 4k ISO下载](https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.4-live-server-arm64.iso)
- [arm64+largemem ISO download
   arm 64 +largemem ISO下载](https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.4-live-server-arm64+largemem.iso)

## The default arm64 (4k) option 默认的arm 64（4k）选项 

The 4k page size is the default in our arm64 ISO. It is suitable for  workloads with many small processes, or environments with tight memory  constraints. Typical use cases include (but are not limited to):
4k页面大小是我们arm 64 ISO的默认值。它适用于具有许多小进程的工作负载，或具有严格内存限制的环境。典型用例包括（但不限于）： 

- Web servers Web服务器 
- Embedded devices 嵌入式设备 
- General purpose/build systems
  通用/构建系统 

## The arm64+largemem (64k) option arm 64 +largemem（64 k）选项 

Our new **arm64+largemem** ISO includes a kernel with 64k page size. A larger page size can  increase throughput, but comes at the cost of increased memory use,  making this option more suitable for servers with plenty of memory.  Typical use cases for this ISO include:
我们新的arm64+largemem ISO包括一个64k页面大小的内核。更大的页面大小可以提高吞吐量，但代价是增加内存使用，因此此选项更适合具有大量内存的服务器。此ISO的典型用例包括：

- Machine learning 机器学习 
- Databases with many large entries
  具有许多大型条目的数据库 
- High performance computing
  高性能计算 
- etc. 等 

> **Note: 注意：**
>  It is possible to switch between these kernel options after installation by installing the other kernel alternative, rebooting, and selecting  the new kernel from the GRUB menu.
>  在安装后，可以通过安装其他内核替代品、重新引导并从GRUB菜单中选择新内核来在这些内核选项之间切换。

## Switching kernels post-installation 安装后切换内核 

To switch between the two kernels after the initial installation you can run the following commands, replacing `<desired-kernel>` with `linux-generic-64k` when swapping to 64k, or `linux-generic` when swapping to the default 4k kernel:
要在初始安装后在两个内核之间切换，您可以运行以下命令，当交换到64k时将 `<desired-kernel>` 替换为 `linux-generic-64k` ，或者当交换到默认的4k内核时将 `linux-generic` 替换为：

```bash
sudo apt update
sudo apt install <desired-kernel>
sudo reboot
```

Upon reboot you will be greeted with the GRUB menu (you may need to hold down the Shift key during the reboot for it to appear). Select “Advanced Options for  Ubuntu”, then select your desired kernel to boot into Ubuntu.
重新启动后，您将看到GRUB菜单（您可能需要在重新启动期间按住 Shift 键才能显示该菜单）。选择“Ubuntu的高级选项”，然后选择你想要的内核来靴子到Ubuntu。

To permanently change the default to your `<desired-flavour>`, replace `<desired-flavour>` with `generic` or `generic-64k` and then run the following command:
要将默认值永久更改为 `<desired-flavour>` ，请将 `<desired-flavour>` 替换为 `generic` 或 `generic-64k` ，然后运行以下命令：

```bash
echo "GRUB_FLAVOUR_ORDER=<desired-flavour>" | sudo tee /etc/default/grub.d/local-order.cfg
```

To apply your change run:
要应用更改运行，请执行以下操作： 

```bash
sudo update-grub
```

Future boots will automatically use your new desired kernel flavour. You can verify this by rebooting using:
未来的靴子将自动使用您的新的所需内核风味。您可以通过使用以下命令重新启动来验证这一点： 

```bash
sudo reboot
```

And then running the following command to display the active kernel:
然后运行以下命令以显示活动内核： 

```bash
uname -r
```

# About Logical Volume Management (LVM) 关于逻辑卷管理（LVM） 

[Logical Volume Management](https://en.wikipedia.org/wiki/Logical_volume_management), or LVM, provides a method of allocating and managing space on  mass-storage devices that is more advanced and flexible than the  traditional method of partitioning storage volumes.
 逻辑卷管理（LVM）提供了一种分配和管理大容量存储设备上的空间的方法，这种方法比传统的存储卷分区方法更先进、更灵活。

To find out how to set up LVM in Ubuntu, [refer to this guide](https://ubuntu.com/server/docs/how-to-manage-logical-volumes), which will also show you how to resize and move partitions, and how to create snapshots.
要了解如何在Ubuntu中设置LVM，请参阅本指南，其中还将向您展示如何调整和移动分区以及如何创建快照。

## Key concepts 关键概念 

There are 3 concepts that LVM manages:
LVM管理的概念有3个： 

- **Physical volumes**: correspond to disks. They represent the lowest abstraction level of LVM, and are used to create a volume group.
  物理卷：对应于磁盘。它们表示最低的LVM抽象级别，用于创建卷组。
- **Volume groups**: are collections of physical volumes. They are pools of disk space that logical volumes can be allocated from.
  卷组：是物理卷的集合。它们是可以从中分配逻辑卷的磁盘空间池。
- **Logical volumes**: correspond to partitions – they usually hold a filesystem. Unlike  partitions though, they can span multiple disks (because of the way  volume groups are organised) and do not have to be physically  contiguous.
  逻辑卷：对应于分区-它们通常包含文件系统。与分区不同的是，它们可以跨越多个磁盘（因为卷组的组织方式），并且不必在物理上连续。

## Resizing partitions 调整分区大小 

LVM can expand a partition while it is mounted, if the filesystem used on  it also supports that. When expanding a partition, LVM can use free  space anywhere in the volume group, even on another disk.
如果在其上使用的文件系统也支持，则LVM可以在挂载时扩展分区。在扩展分区时，LVM可以使用卷组中任何位置的可用空间，甚至可以使用另一个磁盘上的可用空间。 

When resizing LVM partitions, and especially when shrinking them, it is  important to take the same precautions you would as if you were dealing  with regular partitions. Namely, always make a backup of your data  before actually executing the commands. Although LVM will try hard to  determine whether a partition can be expanded or shrunk before actually  performing the operation, there is always the possibility of data loss.
当删除LVM分区时，特别是在缩小分区时，采取与处理常规分区相同的预防措施是很重要的。也就是说，在实际执行命令之前，始终备份数据。虽然在实际执行操作之前，LVM会努力确定分区是否可以扩展或收缩，但始终存在数据丢失的可能性。 

## Moving Partitions 移动分区 

Moving regular partitions is usually only necessary because of the requirement that partitions be physically contiguous, so you probably will not need to do this with LVM. If you do, LVM can move a partition while it is in use, and will not corrupt your data if it is interrupted. In the event  that your system crashes or loses power during the move, you can simply  restart it after rebooting and it will finish normally. Another reason  you might want to move an LVM partition is to replace an old disk with a new, larger one. You can migrate the system to the new disk while using it, and then remove the old one later.
移动常规分区通常是必要的，因为要求分区在物理上是连续的，所以您可能不需要对LVM执行此操作。如果这样做，LVM可以在分区使用时移动分区，并且在中断时不会损坏数据。如果您的系统在移动过程中崩溃或断电，您可以在重新启动后重新启动它，它将正常完成。移动LVM分区的另一个原因是用一个新的更大的磁盘替换旧磁盘。您可以在使用新磁盘时将系统迁移到新磁盘，然后再删除旧磁盘。 

## Snapshots 快照 

LVM allows you to freeze an existing logical volume in time, at any moment, even while the system is running. You can continue to use the original  volume normally, but the snapshot volume appears to be an image of the  original, frozen in time at the moment you created it. You can use this  to get a consistent filesystem image to back up, without shutting down  the system. You can also use it to save the state of the system, so that you can later return to that state if needed. You can also mount the  snapshot volume and make changes to it, without affecting the original.
LVM允许您随时冻结现有的逻辑卷，即使系统正在运行。您可以继续正常使用原始卷，但快照卷似乎是原始卷的映像，在您创建它的那一刻就被冻结了。您可以使用它来备份一致的文件系统映像，而无需关闭系统。您还可以使用它来保存系统的状态，以便以后在需要时可以返回到该状态。您还可以装载快照卷并对其进行更改，而不会影响原始卷。 

# iSCSI initiator (or client) iSCSI启动器（或客户端） 

> Wikipedia [iSCSI Definition](https://en.wikipedia.org/wiki/ISCSI):
> Wikipedia iSCSI定义：
>
> iSCSI an acronym for  **Internet Small Computer Systems Interface** , an [Internet Protocol](https://en.wikipedia.org/wiki/Internet_Protocol) (IP)-based storage networking standard for linking data storage facilities. It provides [block-level access](https://en.wikipedia.org/wiki/Block-level_storage) to [storage devices](https://en.wikipedia.org/wiki/Computer_data_storage) by carrying [SCSI](https://en.wikipedia.org/wiki/SCSI) commands over a [TCP/IP](https://en.wikipedia.org/wiki/TCP/IP) network.
> iSCSI是Internet小型计算机系统接口的首字母缩写，是一种基于Internet协议（IP）的存储网络标准，用于链接数据存储设施。它通过在TCP/IP网络上传送SCSI命令，提供对存储设备的块级访问。
>
> iSCSI is used to facilitate data transfers over [intranets](https://en.wikipedia.org/wiki/Intranet) and to manage storage over long distances. It can be used to transmit data over [local area networks](https://en.wikipedia.org/wiki/Local_area_network) (LANs), [wide area networks](https://en.wikipedia.org/wiki/Wide_area_network) (WANs), or the [Internet](https://en.wikipedia.org/wiki/Internet) and can enable location-independent data storage and retrieval.
> iSCSI用于促进内部网上的数据传输，并管理远距离存储。它可用于通过局域网（LAN）、广域网（WAN）或Internet传输数据，并支持与位置无关的数据存储和检索。
>
> The [protocol](https://en.wikipedia.org/wiki/Protocol_(computing)) allows clients (called  *initiators*) to send SCSI commands ([*CDBs*](https://en.wikipedia.org/wiki/SCSI_CDB)) to storage devices (*targets*) on remote servers.  It is a [storage area network](https://en.wikipedia.org/wiki/Storage_area_network) (SAN) protocol, allowing organizations to consolidate storage into [storage arrays](https://en.wikipedia.org/wiki/Storage_array) while providing clients (such as database and web servers) with the illusion of locally attached SCSI disks.
> 该协议允许客户端（称为启动器）向远程服务器上的存储设备（目标）发送SCSI命令（CDB）。它是一种存储区域网络（SAN）协议，允许组织将存储整合到存储阵列中，同时为客户端（如数据库和Web服务器）提供本地连接SCSI磁盘的错觉。
>
> It mainly competes with [Fibre Channel](https://en.wikipedia.org/wiki/Fibre_Channel), but unlike traditional Fibre Channel, which usually requires dedicated  cabling, iSCSI can be run over long distances using existing network  infrastructure.
> 它主要与光纤通道竞争，但与传统的光纤通道（通常需要专用电缆）不同，iSCSI可以使用现有的网络基础设施长距离运行。

Ubuntu Server can be configured as both: **iSCSI initiator** and **iSCSI target**. This guide provides commands and configuration options to setup an **iSCSI initiator** (or Client).
Ubuntu Server可以配置为iSCSI发起方和iSCSI目标。本指南提供用于设置iSCSI启动器（或客户端）的命令和配置选项。

*Note: It is assumed that **you already have an iSCSI target on your local network** and have the appropriate rights to connect to it. The instructions for  setting up a target vary greatly between hardware providers, so consult  your vendor documentation to configure your specific iSCSI target.
注意事项：假设您的本地网络上已经有一个iSCSI目标，并且具有连接到该目标的适当权限。设置目标的说明在不同的硬件提供商之间有很大的差异，因此请参阅供应商文档以配置特定的iSCSI目标。*

## Network Interfaces Configuration 网络接口配置 

Before start configuring iSCSI, make sure to have the network interfaces  correctly set and configured in order to have open-iscsi package to  behave appropriately, specially during boot time. In Ubuntu 20.04 LTS,  the default network configuration tool is [netplan.io](https://netplan.readthedocs.io/en/latest/examples/).
在开始配置iSCSI之前，请确保正确设置和配置了网络接口，以便使open-iscsi软件包能够正常工作，特别是在靴子期间。在Ubuntu 20.04 LTS中，默认的网络配置工具是netplan.io。

For all the iSCSI examples bellow please consider the following netplan configuration for my iSCSI initiator:
对于下面的所有iSCSI示例，请考虑我的iSCSI启动器的以下网络计划配置： 

> */etc/cloud/cloud.cfg.d/99-disable-network-config.cfg*
>
> ```auto
> {config: disabled}
> ```
>
> */etc/netplan/50-cloud-init.yaml*
>
> ```auto
> network:
>     ethernets:
>         enp5s0:
>             match:
>                 macaddress: 00:16:3e:af:c4:d6
>             set-name: eth0
>             dhcp4: true
>             dhcp-identifier: mac
>         enp6s0:
>             match:
>                 macaddress: 00:16:3e:50:11:9c
>             set-name: iscsi01
>             dhcp4: true
>             dhcp-identifier: mac
>             dhcp4-overrides:
>               route-metric: 300
>         enp7s0:
>             match:
>                 macaddress: 00:16:3e:b3:cc:50
>             set-name: iscsi02
>             dhcp4: true
>             dhcp-identifier: mac
>             dhcp4-overrides:
>               route-metric: 300
>     version: 2
>     renderer: networkd
> ```

With this configuration, the interfaces names change by matching their mac  addresses. This makes it easier to manage them in a server containing  multiple interfaces.
使用此配置，接口名称会通过匹配其mac地址而更改。这使得在包含多个接口的服务器中管理它们更加容易。 

From this point and beyond, 2 interfaces are going to be mentioned:  **iscsi01** and **iscsi02**. This helps to demonstrate how to configure iSCSI in a multipath  environment as well (check the Device Mapper Multipath session in this  same Server Guide).
从这一点开始，我们将提到两个接口：iscsi 01和iscsi 02。这也有助于演示如何在多路径环境中配置iSCSI（请查看同一服务器指南中的设备映射器多路径会话）。

> If you have only a single interface for the iSCSI network, make sure to follow the same instructions, but only consider the **iscsi01** interface command line examples.
> 如果iSCSI网络只有一个接口，请确保遵循相同的说明，但仅考虑iscsi 01接口命令行示例。

## iSCSI Initiator Install iSCSI启动器安装 

To configure Ubuntu Server as an iSCSI initiator install the open-iscsi package. In a terminal enter:
要将Ubuntu Server配置为iSCSI启动器，请安装open-iscsi包。在终端中输入： 

```auto
$ sudo apt install open-iscsi
```

Once the package is installed you will find the following files:
安装软件包后，您将找到以下文件： 

- /etc/iscsi/iscsid.conf
- /etc/iscsi/initiatorname.iscsi

## iSCSI Initiator Configuration iSCSI启动器配置 

Configure the main configuration file like the example bellow:
配置主配置文件，如下所示： 

> /etc/iscsi/iscsid.conf
>
> ```auto
> ### startup settings
> 
> ## will be controlled by systemd, leave as is
> iscsid.startup = /usr/sbin/iscsidnode.startup = manual
> 
> ### chap settings
> 
> # node.session.auth.authmethod = CHAP
> 
> ## authentication of initiator by target (session)
> # node.session.auth.username = username
> # node.session.auth.password = password
> 
> # discovery.sendtargets.auth.authmethod = CHAP
> 
> ## authentication of initiator by target (discovery)
> # discovery.sendtargets.auth.username = username
> # discovery.sendtargets.auth.password = password
> 
> ### timeouts
> 
> ## control how much time iscsi takes to propagate an error to the
> ## upper layer. if using multipath, having 0 here is desirable
> ## so multipath can handle path errors as quickly as possible
> ## (and decide to queue or not if missing all paths)
> node.session.timeo.replacement_timeout = 0
> 
> node.conn[0].timeo.login_timeout = 15
> node.conn[0].timeo.logout_timeout = 15
> 
> ## interval for a NOP-Out request (a ping to the target)
> node.conn[0].timeo.noop_out_interval = 5
> 
> ## and how much time to wait before declaring a timeout
> node.conn[0].timeo.noop_out_timeout = 5
> 
> ## default timeouts for error recovery logics (lu & tgt resets)
> node.session.err_timeo.abort_timeout = 15
> node.session.err_timeo.lu_reset_timeout = 30
> node.session.err_timeo.tgt_reset_timeout = 30
> 
> ### retry
> 
> node.session.initial_login_retry_max = 8
> 
> ### session and device queue depth
> 
> node.session.cmds_max = 128
> node.session.queue_depth = 32
> 
> ### performance
> 
> node.session.xmit_thread_priority = -20
> ```

and re-start the iSCSI daemon:
并重新启动iSCSI守护程序： 

```auto
$ systemctl restart iscsid.service
```

This will set basic things up for the rest of configuration.
这将为其余的配置设置基本的东西。 

The other file mentioned:
另一个文件提到： 

> /etc/iscsi/initiatorname.iscsi
>
> ```auto
> InitiatorName=iqn.2004-10.com.ubuntu:01:60f3517884c3
> ```

contains this node’s initiator name and is generated during open-iscsi package  installation. If you modify this setting, make sure that you don’t have  duplicates in the same iSCSI SAN (Storage Area Network).
包含此节点的启动器名称，并在open-iscsi软件包安装期间生成。如果修改此设置，请确保在同一iSCSI SAN（存储区域网络）中没有重复项。 

## iSCSI Network Configuration iscsi网络配置 

Before configuring the Logical Units that are going to be accessed by the  initiator, it is important to inform the iSCSI service what are the  interfaces acting as paths.
在配置将由启动器访问的逻辑单元之前，必须告知iSCSI服务充当路径的接口是什么。 

A straightforward way to do that is by:
一个简单的方法是： 

- configuring the following environment variables
  配置以下环境变量 

```auto
$ iscsi01_ip=$(ip -4 -o addr show iscsi01 | sed -r 's:.* (([0-9]{1,3}\.){3}[0-9]{1,3})/.*:\1:')
$ iscsi02_ip=$(ip -4 -o addr show iscsi02 | sed -r 's:.* (([0-9]{1,3}\.){3}[0-9]{1,3})/.*:\1:')

$ iscsi01_mac=$(ip -o link show iscsi01 | sed -r 's:.*\s+link/ether (([0-f]{2}(\:|)){6}).*:\1:g')
$ iscsi02_mac=$(ip -o link show iscsi02 | sed -r 's:.*\s+link/ether (([0-f]{2}(\:|)){6}).*:\1:g')
```

- configuring **iscsi01** interface
  配置iscsi01接口

```auto
$ sudo iscsiadm -m iface -I iscsi01 --op=new
New interface iscsi01 added
$ sudo iscsiadm -m iface -I iscsi01 --op=update -n iface.hwaddress -v $iscsi01_mac
iscsi01 updated.
$ sudo iscsiadm -m iface -I iscsi01 --op=update -n iface.ipaddress -v $iscsi01_ip
iscsi01 updated.
```

- configuring **iscsi02** interface
  配置iscsi02接口

```auto
$ sudo iscsiadm -m iface -I iscsi02 --op=new
New interface iscsi02 added
$ sudo iscsiadm -m iface -I iscsi02 --op=update -n iface.hwaddress -v $iscsi02_mac
iscsi02 updated.
$ sudo iscsiadm -m iface -I iscsi02 --op=update -n iface.ipaddress -v $iscsi02_ip
iscsi02 updated.
```

- discovering the **targets** 发现目标

```auto
$ sudo iscsiadm -m discovery -I iscsi01 --op=new --op=del --type sendtargets --portal storage.iscsi01
10.250.94.99:3260,1 iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca

$ sudo iscsiadm -m discovery -I iscsi02 --op=new --op=del --type sendtargets --portal storage.iscsi02
10.250.93.99:3260,1 iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca
```

- configuring **automatic login**
  配置自动登录

```auto
$ sudo iscsiadm -m node --op=update -n node.conn[0].startup -v automatic
$ sudo iscsiadm -m node --op=update -n node.startup -v automatic
```

- make sure needed **services** are enabled during OS initialization:
  确保在操作系统初始化期间启用所需的服务：

```auto
$ systemctl enable open-iscsi
Synchronizing state of open-iscsi.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable open-iscsi
Created symlink /etc/systemd/system/iscsi.service → /lib/systemd/system/open-iscsi.service.
Created symlink /etc/systemd/system/sysinit.target.wants/open-iscsi.service → /lib/systemd/system/open-iscsi.service.

$ systemctl enable iscsid
Synchronizing state of iscsid.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable iscsid
Created symlink /etc/systemd/system/sysinit.target.wants/iscsid.service → /lib/systemd/system/iscsid.service.
```

- restarting **iscsid** service
  重新启动iscsid服务

```auto
$ systemctl restart iscsid.service
```

- and, finally, **login in** discovered logical units
  最后，登录发现的逻辑单元

```auto
$ sudo iscsiadm -m node --loginall=automatic
Logging in to [iface: iscsi02, target: iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca, portal: 10.250.93.99,3260] (multiple)
Logging in to [iface: iscsi01, target: iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca, portal: 10.250.94.99,3260] (multiple)
Login to [iface: iscsi02, target: iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca, portal: 10.250.93.99,3260] successful.
Login to [iface: iscsi01, target: iqn.2003-01.org.linux-iscsi.storage.x8664:sn.2c084c8320ca, portal: 10.250.94.99,3260] successful.
```

## Accessing the Logical Units (or LUNs) 删除逻辑单元（或LUN） 

Check dmesg to make sure that the new disks have been detected:
检查dmesg以确保已检测到新磁盘： 

> dmesg
>
> ```auto
> [  166.840694] scsi 7:0:0:4: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.840892] scsi 8:0:0:4: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.841741] sd 7:0:0:4: Attached scsi generic sg2 type 0
> [  166.841808] sd 8:0:0:4: Attached scsi generic sg3 type 0
> [  166.842278] scsi 7:0:0:3: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.842571] scsi 8:0:0:3: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.843482] sd 8:0:0:3: Attached scsi generic sg4 type 0
> [  166.843681] sd 7:0:0:3: Attached scsi generic sg5 type 0
> [  166.843706] sd 8:0:0:4: [sdd] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.843884] scsi 8:0:0:2: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.843971] sd 8:0:0:4: [sdd] Write Protect is off
> [  166.843972] sd 8:0:0:4: [sdd] Mode Sense: 2f 00 00 00
> [  166.844127] scsi 7:0:0:2: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.844232] sd 7:0:0:4: [sdc] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.844421] sd 8:0:0:4: [sdd] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.844566] sd 7:0:0:4: [sdc] Write Protect is off
> [  166.844568] sd 7:0:0:4: [sdc] Mode Sense: 2f 00 00 00
> [  166.844846] sd 8:0:0:2: Attached scsi generic sg6 type 0
> [  166.845147] sd 7:0:0:4: [sdc] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.845188] sd 8:0:0:4: [sdd] Optimal transfer size 65536 bytes
> [  166.845527] sd 7:0:0:2: Attached scsi generic sg7 type 0
> [  166.845678] sd 8:0:0:3: [sde] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.845785] scsi 8:0:0:1: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.845799] sd 7:0:0:4: [sdc] Optimal transfer size 65536 bytes
> [  166.845931] sd 8:0:0:3: [sde] Write Protect is off
> [  166.845933] sd 8:0:0:3: [sde] Mode Sense: 2f 00 00 00
> [  166.846424] scsi 7:0:0:1: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
> [  166.846552] sd 8:0:0:3: [sde] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.846708] sd 7:0:0:3: [sdf] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.847024] sd 8:0:0:1: Attached scsi generic sg8 type 0
> [  166.847029] sd 7:0:0:3: [sdf] Write Protect is off
> [  166.847031] sd 7:0:0:3: [sdf] Mode Sense: 2f 00 00 00
> [  166.847043] sd 8:0:0:3: [sde] Optimal transfer size 65536 bytes
> [  166.847133] sd 8:0:0:2: [sdg] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.849212] sd 8:0:0:2: [sdg] Write Protect is off
> [  166.849214] sd 8:0:0:2: [sdg] Mode Sense: 2f 00 00 00
> [  166.849711] sd 7:0:0:3: [sdf] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.849718] sd 7:0:0:1: Attached scsi generic sg9 type 0
> [  166.849721] sd 7:0:0:2: [sdh] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.853296] sd 8:0:0:2: [sdg] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.853721] sd 8:0:0:2: [sdg] Optimal transfer size 65536 bytes
> [  166.853810] sd 7:0:0:2: [sdh] Write Protect is off
> [  166.853812] sd 7:0:0:2: [sdh] Mode Sense: 2f 00 00 00
> [  166.854026] sd 7:0:0:3: [sdf] Optimal transfer size 65536 bytes
> [  166.854431] sd 7:0:0:2: [sdh] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.854625] sd 8:0:0:1: [sdi] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.854898] sd 8:0:0:1: [sdi] Write Protect is off
> [  166.854900] sd 8:0:0:1: [sdi] Mode Sense: 2f 00 00 00
> [  166.855022] sd 7:0:0:2: [sdh] Optimal transfer size 65536 bytes
> [  166.855465] sd 8:0:0:1: [sdi] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.855578] sd 7:0:0:1: [sdj] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
> [  166.855845] sd 7:0:0:1: [sdj] Write Protect is off
> [  166.855847] sd 7:0:0:1: [sdj] Mode Sense: 2f 00 00 00
> [  166.855978] sd 8:0:0:1: [sdi] Optimal transfer size 65536 bytes
> [  166.856305] sd 7:0:0:1: [sdj] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
> [  166.856701] sd 7:0:0:1: [sdj] Optimal transfer size 65536 bytes
> [  166.859624] sd 8:0:0:4: [sdd] Attached SCSI disk
> [  166.861304] sd 7:0:0:4: [sdc] Attached SCSI disk
> [  166.864409] sd 8:0:0:3: [sde] Attached SCSI disk
> [  166.864833] sd 7:0:0:3: [sdf] Attached SCSI disk
> [  166.867906] sd 8:0:0:2: [sdg] Attached SCSI disk
> [  166.868446] sd 8:0:0:1: [sdi] Attached SCSI disk
> [  166.871588] sd 7:0:0:1: [sdj] Attached SCSI disk
> [  166.871773] sd 7:0:0:2: [sdh] Attached SCSI disk
> ```

In the output above you will find **8 x SCSI disks** recognized. The storage server is mapping **4 x LUNs** to this node, AND the node has **2  x PATHs** to each LUN. The OS recognizes each path to each device as 1 SCSI device.
在上面的输出中，您将发现8个已识别的SCSI磁盘。存储服务器正在将4个LUN映射到此节点，并且该节点具有到每个LUN的2个PATH。操作系统将每个设备的每个路径识别为1个SCSI设备。

> You will find different output depending on the storage server your node is mapping the LUNs from, and the amount of LUNs being mapped as well.
> 根据节点映射LUN的存储服务器以及映射的LUN数量的不同，您会发现不同的输出。 

Although not the objective of this session, let’s find the 4 mapped LUNs using multipath-tools.
尽管这不是本课程的目标，但让我们使用multipath-tools查找4个映射的LUN。 

> You will find further details about multipath in “Device Mapper Multipathing” session of this same guide.
> 您将在本指南的“Device Mapper Multipathing”会话中找到有关多路径的更多详细信息。 

```auto
$ apt-get install multipath-tools
$ sudo multipath -r
$ sudo multipath -ll
mpathd (360014051a042fb7c41c4249af9f2cfbc) dm-3 LIO-ORG,TCMU device
size=1.0G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 7:0:0:4 sde 8:64  active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 8:0:0:4 sdc 8:32  active ready running
mpathc (360014050d6871110232471d8bcd155a3) dm-2 LIO-ORG,TCMU device
size=1.0G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 7:0:0:3 sdf 8:80  active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 8:0:0:3 sdd 8:48  active ready running
mpathb (360014051f65c6cb11b74541b703ce1d4) dm-1 LIO-ORG,TCMU device
size=1.0G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 7:0:0:2 sdh 8:112 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 8:0:0:2 sdg 8:96  active ready running
mpatha (36001405b816e24fcab64fb88332a3fc9) dm-0 LIO-ORG,TCMU device
size=1.0G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 7:0:0:1 sdj 8:144 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 8:0:0:1 sdi 8:128 active ready running
```

Now it is much easier to understand each recognized SCSI device and common  paths to same LUNs in the storage server. With the output above one can  easily see that:
现在，理解每个已识别的SCSI设备以及存储服务器中相同LUN的公共路径要容易得多。从上面的输出可以很容易地看到： 

- mpatha device

   (/dev/mapper/mpatha) is a multipath device for:

  
  mpatha设备（/dev/mapper/mpatha）是一个多路径设备，用于： 

  - /dev/sdj
  - /dev/dsi

- mpathb device

   (/dev/mapper/mpathb) is a multipath device for:

  
  mpathb设备（/dev/mapper/mpathb）是一个多路径设备，用于： 

  - /dev/sdh
  - /dev/dsg

- mpathc device

   (/dev/mapper/mpathc) is a multipath device for:

  
  mpathc设备（/dev/mapper/mpathc）是一个多路径设备，用于： 

  - /dev/sdf
  - /dev/sdd

- mpathd device

   (/dev/mapper/mpathd) is a multipath device for:

  
  mpathd设备（/dev/mapper/mpathd）是一个多路径设备，用于： 

  - /dev/sde
  - /dev/sdc

> **Do not use this in production** without checking appropriate multipath configuration options in the **Device Mapper Multipathing** session. The *default multipath configuration* is less than optimal for regular usage.
> 如果未在设备映射器多路径会话中检查相应的多路径配置选项，请勿在生产中使用此选项。默认的多路径配置对于常规使用来说不是最佳的。

Finally, to access the LUN (or remote iSCSI disk) you will:
最后，要访问LUN（或远程iSCSI磁盘），您需要： 

- If accessing through a single network interface:
  如果通过单个网络接口访问： 
  - access it through /dev/sdX where X is a letter given by the OS
    通过/dev/sdX访问它，其中X是操作系统给出的字母 
- If accessing through multiple network interfaces:
  如果通过多个网络接口访问： 
  - configure multipath and access the device through /dev/mapper/X
    配置多路径并通过/dev/mapper/X访问设备 

For everything else, the created devices are block devices and all commands used with local disks should work the same way:
对于其他所有内容，创建的设备都是块设备，所有用于本地磁盘的命令都应以相同的方式工作： 

- Creating a partition: 创建一个分区： 

```auto
$ sudo fdisk /dev/mapper/mpatha

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x92c0322a.

Command (m for help): p
Disk /dev/mapper/mpatha: 1 GiB, 1073741824 bytes, 2097152 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 65536 bytes
Disklabel type: dos
Disk identifier: 0x92c0322a

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-2097151, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-2097151, default 2097151):

Created a new partition 1 of type 'Linux' and of size 1023 MiB.

Command (m for help): w
The partition table has been altered.
```

- Creating a filesystem: 创建一个文件系统： 

```auto
$ sudo mkfs.ext4 /dev/mapper/mpatha-part1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 261888 4k blocks and 65536 inodes
Filesystem UUID: cdb70b1e-c47c-47fd-9c4a-03db6f038988
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```

- Mounting the block device:
  安装块设备： 

```auto
$ sudo mount /dev/mapper/mpatha-part1 /mnt
```

- Accessing the data: 搜索数据： 

```auto
$ ls /mnt
lost+found
```

Make sure to read other important sessions in Ubuntu Server Guide to follow up with concepts explored in this one.
请务必阅读Ubuntu服务器指南中的其他重要课程，以跟进本文中探索的概念。 

## References 引用 

1. [iscsid iscsid的](https://linux.die.net/man/8/iscsid)
2. [iscsi.conf](https://linux.die.net/man/5/iscsi.conf)
3. [iscsid.conf](https://github.com/open-iscsi/open-iscsi/blob/master/etc/iscsid.conf)
4. [iscsi.service](https://github.com/open-iscsi/open-iscsi/blob/master/etc/systemd/iscsi.service.template)
5. [iscsid.service](https://github.com/open-iscsi/open-iscsi/blob/master/etc/systemd/iscsid.service.template)
6. [Open-iSCSI Open—iSCSI的](http://www.open-iscsi.com/)
7. [Debian Open-iSCSI Debian Open—iSCSI系统](http://wiki.debian.org/SAN/iSCSI/open-iscsi)

# About `apt upgrade` and phased updates 关于"apt upgrade"和分阶段更新 

You may have noticed recently that updating your system with `apt upgrade` sometimes produces a weird message about packages being kept back…like this one:
你可能已经注意到最近用 `apt upgrade` 更新你的系统有时会产生一个奇怪的消息，关于软件包被保留了.

```bash
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following packages have been kept back:
  (Names of <X> held back packages listed here)
0 upgraded, 0 newly installed, 0 to remove and <X> not upgraded.
```

If you’ve ever used combinations of packages from different releases or  third party repos, you may be familiar with this message already.  However, it has become a much more common occurrence due to something  called “phased updates”.
如果你曾经使用过来自不同版本或第三方仓库的包的组合，你可能已经熟悉了这个消息。然而，由于所谓的“阶段性更新”，它已经成为一种更常见的现象。 

## What are phased updates? 什么是阶段性更新？ 

Phased updates are software updates that are rolled out in stages, rather than being provided to everyone at the same time. Initially, the update is  provided only to a small subset of Ubuntu machines. As the update proves to be stable, it is provided to an ever-increasing number of users  until everyone has received it (i.e., when the update is “fully  phased”).
分阶段更新是分阶段推出的软件更新，而不是同时提供给每个人。最初，更新仅提供给Ubuntu机器的一小部分。随着更新被证明是稳定的，它被提供给越来越多的用户，直到每个人都收到它（即，当更新是“完全分阶段的”时）。 

The good news is, you don’t need to do anything about the “packages kept  back” message – you can safely ignore it. Once the update has been  deemed safe for release, you will receive the update automatically.
好消息是，您不需要对“packages kept back”消息做任何事情-您可以安全地忽略它。一旦更新被认为可以安全发布，您将自动收到更新。 

## Why is Ubuntu doing this? Ubuntu为什么要这么做？ 

Although updates are thoroughly tested before they get released at all,  sometimes bugs can be hidden well enough to escape our attention and  make it into a release – especially in highly specific use cases that we didn’t know we needed to test. This can obviously cause problems for  our users, and used to be the norm before we phased updates through `apt`.
虽然更新在发布之前已经经过了彻底的测试，但有时bug可以隐藏得很好，足以逃脱我们的注意，并将其发布-特别是在我们不知道需要测试的高度特定用例中。这显然会给我们的用户带来问题，在我们通过 `apt` 进行阶段更新之前，这是一种常态。

Update phasing makes it much easier for us to detect serious breakages early  on – before they have a chance to cause problems for the majority of our users. It gives us the opportunity to hold back the update until the  bugs are fixed.
更新阶段使我们更容易在早期发现严重的中断-在他们有机会给我们的大多数用户造成问题之前。它给了我们机会，以阻止更新，直到错误得到修复。 

In other words, it directly benefits our users by increasing the safety, stability and reliability of Ubuntu.
换句话说，它通过提高Ubuntu的安全性，稳定性和可靠性直接使我们的用户受益。 

The phasing system makes it so that different sets of users are chosen to  be the first to get the updates, so that there isn’t one group of  unlucky people who always get potentially broken updates soon after  release.
分阶段系统使得不同的用户被选择成为第一个获得更新的用户，这样就不会有一组不幸的人总是在发布后不久就获得潜在的破坏更新。 

> **Note**: 注意：
>  It should be mentioned here that security updates are *never* phased.
>  这里应该提到的是，安全更新从不分阶段进行。

## Can I turn off phased updates? 我可以关闭分阶段更新吗？ 

That depends on how stable you need your system to be. If you just want to  avoid any notices about packages being held back during `apt` updates, and you’re willing to be one of the first people to get  updates whenever they’re released, you can turn off phased updates. Be  warned, though – if an update *is* broken, you will almost always be in the first set of people to get it  (i.e., you’re basically volunteering yourself as a guinea pig for the  early update releases!). It will get rid of the “held back packages” in `apt` message, though.
这取决于您需要系统的稳定性。如果你只是想避免任何关于在 `apt` 更新期间软件包被阻止的通知，并且你愿意成为第一个在更新发布时获得更新的人之一，你可以关闭分阶段更新。不过要注意的是，如果一个更新被破坏了，你几乎总是第一批得到它的人（即，你基本上是自愿作为一个豚鼠为早期更新版本！）。不过，它将摆脱 `apt` 消息中的“保留包”。

If that doesn’t sound like something you want, leave phased updates on  (this is the default). You will still temporarily get the “held back  packages” message, but your machine will be more protected from updates  that might otherwise break it – and once the packages are ready to be  safely installed on your system, they will no longer be held back.
如果这听起来不像你想要的东西，让分阶段更新（这是默认值）。您仍然会暂时收到“holded back packages”消息，但您的计算机将受到更好的保护，免受可能破坏它的更新-一旦包准备好安全地安装在您的系统上，它们将不再被阻止。 

## Can I `apt upgrade` the individual packages? (and should I?) 我可以 `apt upgrade` 单个包吗？(and我应该吗？）

While you can *technically* get around phased updates by running `apt install` on individual held back packages, it’s not recommended. You’re unlikely to break your machine by doing this – as long as the package is being  held back due to update phasing.
虽然您可以通过在单个保留包上运行 `apt install` 来从技术上绕过分阶段更新，但不建议这样做。这样做不太可能破坏您的计算机-只要软件包由于更新阶段而被阻止。

If you want to `apt upgrade` a package, you should first carefully examine the proposed changes that `apt` would make before you proceed. If the package update was kept back for a reason unrelated to phasing, `apt` may be forced to remove packages in order to complete your request, which could then cause problems elsewhere.
如果你想 `apt upgrade` 一个包，你应该在继续之前先仔细检查 `apt` 会做的修改。如果软件包更新由于与阶段无关的原因而被保留，则 `apt` 可能会被迫删除软件包以完成您的请求，这可能会在其他地方引起问题。

## How do I turn off phased updates? 如何关闭分阶段更新？ 

If you’re sure that you want to disable phased updates, reverting to the old behaviour, you can change `apt`’s configuration by creating a file in `/etc/apt/apt.conf.d` called `99-Phased-Updates` (if `/etc/apt/apt.conf.d/99-Phased-Updates` doesn’t already exist). In the file, simply add the following lines:
如果您确定要禁用分阶段更新，恢复到旧的行为，您可以通过在 `/etc/apt/apt.conf.d` 中创建一个名为 `99-Phased-Updates` 的文件（如果 `/etc/apt/apt.conf.d/99-Phased-Updates` 不存在）来更改 `apt` 的配置。在该文件中，只需添加以下行：

```bash
Update-Manager::Always-Include-Phased-Updates true;
APT::Get::Always-Include-Phased-Updates true;
```

Again, please only do this if you really know what you’re doing and are  absolutely sure you need to do it (for instance, if you are  intentionally installing all the latest packages to help test them – and don’t mind if your system breaks). We definitely don’t recommend  turning off phased updates if you’re a newer user.
同样，请只在你真的知道你在做什么并且绝对确定你需要这样做的时候才这样做（例如，如果你有意安装所有最新的软件包来帮助测试它们-并且不介意你的系统崩溃）。如果您是新用户，我们绝对不建议您关闭分阶段更新。 

## Why is this suddenly happening now? 为什么现在突然发生这种事？ 

Phased updates have been part of the update-manager on Ubuntu Desktop for quite a while (since 13.04, in fact!), but were [implemented in APT in 21.04](https://discourse.ubuntu.com/t/phased-updates-in-apt-in-21-04/20345). It now works on all versions of Ubuntu (including Ubuntu Server,  Raspberry Pi, and containers). Since this includes the 22.04 LTS, it’s  now getting a lot more attention as a result!
分阶段更新已经成为Ubuntu桌面更新管理器的一部分很长一段时间了（事实上，从13.04开始！），但在21.04年在APT中实现。它现在适用于所有版本的Ubuntu（包括Ubuntu Server，Raspberry Pi和容器）。由于这包括22.04 LTS，因此现在得到了更多的关注！

# How does it actually work? 它实际上是如何工作的？ 

Phased updates depend on a value derived from your machine’s “Machine ID”, as  well as the package name and package version. The neat thing about this  is that phasing is determined completely at the client end; no  identifiable information (or indeed any new information at all) is ever  sent to the server to achieve update phasing.
分阶段更新取决于从计算机的“计算机ID”以及软件包名称和软件包版本派生的值。这样做的好处是，阶段完全在客户端确定;没有可识别的信息（或者实际上任何新信息）被发送到服务器以实现更新阶段。 

When the software update is released, the initial subset of machines to  receive the update first is chosen at random. Only if there are no  problems detected by the first set of users will the update be made  available to everyone.
当软件更新发布时，随机选择首先接收更新的机器的初始子集。只有当第一组用户没有检测到任何问题时，更新才会提供给所有人。 

For more detailed information, including about how changes to phasing are timed, you can check the Ubuntu [wiki page on phased updates](https://wiki.ubuntu.com/PhasedUpdates).
有关更多详细信息，包括如何对阶段化的更改进行计时，您可以查看有关阶段化更新的Ubuntu wiki页面。

## How can I find out more information about currently phased packages? 如何了解有关当前分阶段软件包的更多信息？ 

You can find out the phasing details of a package by using the `apt policy` command:
您可以通过使用 `apt policy` 命令来了解包的阶段化详细信息：

```bash
apt policy <package>
```

For example, at the time of writing, the package `libglapi-mesa` has a phased update. Running `apt policy libglapi-mesa` then produces an output like this:
例如，在撰写本文时，软件包 `libglapi-mesa` 有一个阶段性更新。运行 `apt policy libglapi-mesa` 会产生如下输出：

```bash
libglapi-mesa:
  Installed: 22.0.5-0ubuntu0.3
  Candidate: 22.2.5-0ubuntu0.1~22.04.1
  Version table:
 	22.2.5-0ubuntu0.1~22.04.1 500 (phased 20%)
    	500 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages
 *** 22.0.5-0ubuntu0.3 100
    	100 /var/lib/dpkg/status
 	22.0.1-1ubuntu2 500
    	500 http://archive.ubuntu.com/ubuntu jammy/main amd64 Packages
```

In this output you can see that this package is 20% phased.
在此输出中，您可以看到此包是20%分阶段的。 

You can see the status of all packages currently being phased in Ubuntu at [Released Ubuntu SRUs](https://people.canonical.com/~ubuntu-archive/phased-updates.html)
您可以在发布的Ubuntu SRUs中查看当前在Ubuntu中分阶段运行的所有软件包的状态

> **Note**: 注意：
>  There is a bug report currently active about the fact that the “kept  back” message is not as informative as it could be, and the issue is on  our radar. If this issue also affects you, you have an Ubuntu Single  Sign-On (SSO) account and can log into Launchpad, you can click on the  link near the top of the page that says “This bug affects 85 people.  Does this bug affect you?”. If you then click on “Yes, it affects me”,  it will increase the bug heat rating, making it more significant.
>   有一个错误报告目前活跃的事实，即"保留"消息是不作为信息，因为它可以，这个问题是在我们的雷达。如果这个问题也影响到你，你有一个Ubuntu单点登录（SSO）帐户，可以登录到Launchpad，你可以点击页面顶部附近的链接，上面写着"这个错误影响85人。这个bug对你有影响吗？”如果你点击“是的，它影响了我”，它会增加错误的热度等级，使它更显着。

## Further reading 进一步阅读 

- The details in this page are based on this [excellent post on AskUbuntu](https://askubuntu.com/questions/1431940/what-are-phased-updates-and-why-does-ubuntu-use-them) by AskUbuntu user *ArrayBolt3*. This page is therefore licensed under Creative Commons Attribution-ShareAlike license, distributed under the terms of [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
  本页的详细信息基于AskUbuntu用户ArrayBolt 3在AskUbuntu上发表的一篇优秀文章。因此，本页面采用知识共享署名-相同方式共享许可协议，并根据CC BY-SA 4.0条款分发
- You can check on the progress of the current [phasing Ubuntu Stable Release Updates](https://people.canonical.com/~ubuntu-archive/phased-updates.html).
  您可以检查当前阶段Ubuntu稳定版本更新的进度。
- There is also more detail on how phased updates work in the [Ubuntu wiki](https://wiki.ubuntu.com/PhasedUpdates), the [Error Tracker](https://wiki.ubuntu.com/ErrorTracker/PhasedUpdates), and the [`apt` preferences manpage](https://manpages.ubuntu.com/manpages/jammy/man5/apt_preferences.5.html).
  在Ubuntu wiki、Error Tracker和 `apt` preferences手册页中也有关于分阶段更新如何工作的更多细节。

------

# Third party repository usage 第三方存储库使用 

Ubuntu is an operating system with thousands of packages and snaps available  to its users, but it is humanly (and sometimes technically!) impossible  to make all software out there available in the official repositories.  There are situations where you may want to install a package that is not maintained by Ubuntu, but *is* maintained by a third party entity. We don’t recommend using third  party APT repositories, but we know that users sometimes have no other  option – so let’s take a look at some of the pitfalls, alternatives, and mitigations.
Ubuntu是一个操作系统，有成千上万的软件包和快照可供用户使用，但它是人性化的（有时是技术上的！）不可能让所有的软件都在官方仓库中可用。在某些情况下，您可能希望安装一个不是由Ubuntu维护，而是由第三方实体维护的软件包。我们不建议使用第三方APT存储库，但我们知道用户有时没有其他选择-所以让我们看看一些陷阱，替代方案和缓解措施。

## Why **not** use third party APT repositories? 为什么不使用第三方APT仓库？

While having access to the software you want to use is great, it is crucial  to understand the risks involved in using third party APT repositories.
虽然能够访问您想要使用的软件是很好的，但了解使用第三方APT存储库所涉及的风险至关重要。 

### Security risk 安全风险 

When using any software that you have not audited yourself, you must  implicitly trust the publisher of that software with your data. However, with third party APT repositories, there are additional implications of this that are less obvious.
当使用任何您自己没有审核过的软件时，您必须隐式地信任该软件的发布者。然而，对于第三方APT存储库，还有其他不太明显的影响。 

Unlike more modern packaging systems, APT repositories run code that is not  sandboxed. When using software from more than one publisher, such as  from your distribution as well as a third party, APT and dpkg provide no security boundary between them.
与更现代的打包系统不同，APT存储库运行的代码不是沙箱。当使用来自多个发行商的软件时，例如来自您的发行版以及第三方的软件，APT和dpkg在它们之间没有提供安全边界。 

This is important because in addition to trusting the publisher’s  intentions, you are also implicitly trusting the quality and competence  of the publisher’s own information security, since an adversary can  compromise your system indirectly by compromising the software  publisher’s infrastructure.
这一点很重要，因为除了信任发布者的意图之外，您还隐含地信任发布者自己的信息安全的质量和能力，因为对手可以通过损害软件发布者的基础设施来间接损害您的系统。 

For example, consider users who use applications such as games where system security isn’t much of a concern, but also use their computers for  something more security-sensitive such as online banking. A properly  sandboxed packaging system would mitigate an adversary compromising the  game publisher in order to take over their users’ online banking  sessions, since the games wouldn’t have access to those sessions. But  with APT repositories, the game can access your online banking session  as well. Your system’s security – as a whole – has been downgraded to  the level of the app publisher that has the worst security; they may not consider their information security important because they aren’t a  bank.
例如，考虑使用游戏等应用程序的用户，这些应用程序的系统安全性不是很重要，但也使用他们的计算机进行更安全敏感的操作，如在线银行。一个适当的沙箱打包系统将减轻对手为了接管用户的在线银行会话而损害游戏发行商的风险，因为游戏无法访问这些会话。但是有了APT存储库，游戏也可以访问你的在线银行会话。您的系统的安全性-作为一个整体-已被降级到具有最差安全性的应用程序发布者的级别;他们可能不认为他们的信息安全很重要，因为他们不是银行。 

### System integrity 系统完整性 

Even if you are certain that the third party APT repository can be trusted,  you also need to take into account possible conflicts that having an  external package may bring to your system. Some third party packagers –  but not all – are careful to integrate their packages into Ubuntu in a  way that they don’t conflict with official packages from the  distribution, but it is technically impossible to predict future changes that might happen in future Ubuntu releases. This means that  fundamentally there always is the possibility of conflict. The most  common cause of system upgrade failure is the use of third party  repositories that worked at the time but later conflicted with a  subsequent upgrade.
即使您确信第三方APT存储库是可信的，您也需要考虑外部软件包可能给您的系统带来的冲突。一些第三方打包者--但不是全部--小心地将他们的软件包集成到Ubuntu中，使其不与发行版的官方软件包冲突，但从技术上讲，预测未来Ubuntu版本中可能发生的变化是不可能的。这意味着，从根本上说，冲突的可能性总是存在的。系统升级失败的最常见原因是使用第三方存储库，该存储库当时可以工作，但后来与后续升级发生冲突。 

One of the most common conflicts occurs when a third party package ships  with a file that is also shipped by an official Ubuntu package. In this  case, having both packages installed simultaneously is impossible  because `dpkg` will prevent managed files from being overwritten. Another possible  (and more subtle) issue can happen when the third party software  interacts in a problematic way with an official package from Ubuntu.  This can be harder to diagnose and might cause more serious problems in  the system, such as data loss and service unavailability.
最常见的冲突之一是当第三方软件包附带的文件也由官方Ubuntu软件包附带时发生。在这种情况下，同时安装两个软件包是不可能的，因为 `dpkg` 将防止托管文件被覆盖。当第三方软件以有问题的方式与Ubuntu的官方软件包交互时，可能会发生另一个可能的（更微妙的）问题。这可能更难诊断，并可能在系统中导致更严重的问题，例如数据丢失和服务不可用。

As a general rule, if the third party package you are installing is  interacting with or is a modified version of an existing Ubuntu package, you need to be more careful and do some preliminary research before  using it in your system.
作为一般规则，如果您正在安装的第三方软件包正在与现有Ubuntu软件包进行交互，或者是现有Ubuntu软件包的修改版本，则需要更加小心，并在系统中使用它之前进行一些初步研究。 

### Lack of official Ubuntu support Ubuntu官方支持 

If you decide to install a third party package on your Ubuntu system, the  Ubuntu community will struggle to offer support for whatever failures  you may encounter as a consequence, since it is out of their control and they are unlikely to be familiar with it. In fact, if you experience a  bug in an official Ubuntu package but it is later determined that the  bug was caused by a third party package, the Ubuntu community may not be able to help you.
如果你决定在你的Ubuntu系统上安装第三方软件包，Ubuntu社区将很难为你可能遇到的任何故障提供支持，因为这超出了他们的控制范围，他们不太可能熟悉它。事实上，如果你在官方Ubuntu软件包中遇到一个bug，但后来确定这个bug是由第三方软件包引起的，Ubuntu社区可能无法帮助您。 

In other words, if you use a third party software you will have to contact its packagers for help if you experience any problem with it.
换句话说，如果您使用第三方软件，如果遇到任何问题，您将不得不联系其包装商寻求帮助。 

## A better solution to third party APT repositories: snaps 第三方APT存储库的更好解决方案：snaps 

As we have seen, third party APT repositories are not simple and should be handled carefully. But there is an alternative that is natively  supported by Ubuntu and solves some of the issues affecting third party  APT repositories: [snaps](https://ubuntu.com/core/services/guide/snaps-intro).
正如我们所看到的，第三方APT仓库并不简单，应该小心处理。但是有一种替代方案是Ubuntu原生支持的，它解决了影响第三方APT存储库的一些问题：快照。

Due to the way they are architected, snaps already carry all of their  dependencies inside them. When they are installed, they are placed in an isolated directory in the system, which means that they cannot conflict with existing Ubuntu packages (or even with other snaps).
由于它们的架构方式，快照已经在内部携带了它们的所有依赖项。当它们安装时，它们被放置在系统中的一个隔离目录中，这意味着它们不会与现有的Ubuntu包（甚至与其他快照）冲突。 

When executed, a snap application is sandboxed and has limited access to the system resources. While still vulnerable to some security threats,  snaps offer a better isolation than third party APT repositories when it comes to the damage that can be done by an application.
执行时，快照应用程序将被沙箱化，并且对系统资源的访问受到限制。虽然仍然容易受到一些安全威胁，但在涉及应用程序可能造成的损害时，快照提供了比第三方APT存储库更好的隔离。 

Finally, if a snap is [published in the snapstore](https://snapcraft.io/store), you will not need to go through the hassle of modifying `sources.list` or adding a new GPG key to the keyring. Everything will work “out of the box” when you run `snap install`.
最后，如果一个快照发布到了snapstore中，你就不需要麻烦地修改 `sources.list` 或者添加一个新的GPG密钥到密匙环中。当您运行 `snap install` 时，一切都将“开箱即用”。

## Mitigating the risks 减少风险 

If the software you want is not available as a snap, you may still need to use a third party APT repository. In that case, there are some  mitigating steps you can take to help protect your system.
如果您想要的软件不能作为快照提供，您可能仍然需要使用第三方APT存储库。在这种情况下，您可以采取一些缓解措施来帮助保护您的系统。 

### Security risk mitigation 措施减缓安全风险 

- If the package you want to install is Free Software/Open Source, then the  risk can be reduced by carefully examining the source code of the entire software, including the packaging parts. The amount of work required to do this assessment will depend on the size and complexity of the  software, and is something that needs to be performed by an expert  whenever an update is available. Realistically, this kind of evaluation  almost never happens due to the efforts and time required.
  如果您要安装的软件包是自由软件/开源软件，那么可以通过仔细检查整个软件的源代码（包括打包部分）来降低风险。进行此评估所需的工作量将取决于软件的大小和复杂性，并且需要在更新可用时由专家执行。实际上，由于所需的努力和时间，这种评估几乎从未发生过。 
- The availability and cadence of fixes to security vulnerabilities should  also be taken into account when assessing the quality and reliability of the third party APT repository. It is important to determine whether  these fixes are covered by the third party entity, and how soon they are released once they have been disclosed.
  在评估第三方APT存储库的质量和可靠性时，还应考虑安全漏洞修复的可用性和节奏。重要的是要确定这些修复程序是否由第三方实体覆盖，以及一旦它们被披露，它们将在多长时间内发布。 
- In addition, you must ensure that the packages are cryptographically  signed with the repository’s GPG key. This requirement helps to confirm  the integrity of the package you are about to install on your system.
  此外，您必须确保软件包是使用存储库的GPG密钥进行加密签名的。此要求有助于确认要安装到系统上的软件包的完整性。 

### System integrity mitigation 系统完整性缓解 

- Avoid release upgrades whenever possible, favouring redeployment onto a newer release instead. Third party APT repositories will often break at  release time, and the only way to avoid this is to wait until the  maintainers of the repository have upgraded the software to be  compatible with the release.
  尽可能避免版本升级，而是倾向于重新部署到较新的版本上。第三方APT存储库通常会在发布时中断，避免这种情况的唯一方法是等待存储库的维护者升级软件以与发布兼容。 
- Configure pinning (we show how to do this below). Pinning is a way to assign a  preference level to some (or all) packages from a certain source; in  this particular case, the intention is to reduce the preference of  packages provided by an external repository so that official Ubuntu  packages are not overwritten by mistake.
  配置固定（我们将在下面介绍如何执行此操作）。固定是一种为来自某个来源的某些（或所有）软件包分配首选项级别的方法;在这种特定情况下，其目的是减少外部存储库提供的软件包的首选项，以便官方Ubuntu软件包不会被错误覆盖。 

## Dealing with third party APT repositories in Ubuntu 在Ubuntu中处理第三方APT存储库 

Now that we have discussed the risks and mitigations of using third party  APT repositories, let’s take a look at how we can work with them in  Ubuntu. Unless otherwise noted, all commands below are to be executed as the `root` user (or using `sudo` with your regular user).
现在我们已经讨论了使用第三方APT存储库的风险和缓解措施，让我们看看如何在Ubuntu中使用它们。除非另有说明，否则以下所有命令都将以 `root` 用户（或使用常规用户的 `sudo` ）执行。

### Add the repository 添加存储库 

Several third party entities provide their own instructions on how to add their repositories to a system, but more often than not they don’t [follow best practices](https://wiki.debian.org/DebianRepository/UseThirdParty) when doing so.
一些第三方实体提供了他们自己的关于如何将他们的存储库添加到系统中的说明，但他们在这样做时往往没有遵循最佳实践。

#### Fetch the GPG key 获取GPG密钥 

The first step before adding a third party APT repository to your system is to fetch the GPG key for it. This key must be obtained from the third  party entity; it should be available at the root of the repository’s  URL, but you might need to contact them and ask for the key file.
在添加第三方APT仓库到您的系统之前的第一步是获取它的GPG密钥。该密钥必须从第三方实体获得；它应该在仓库URL的根目录下可用，但您可能需要联系他们并要求密钥文件。 

Although several third party guides instruct the user to use `apt-key` in order to add the GPG key to `apt`’s keyring, this is no longer recommended. Instead, you should explicitly list the key in the `sources.list` entry by using the `signed-by` option (see below).
虽然一些第三方指南指导用户使用 `apt-key` 来将GPG密钥添加到 `apt` 的密钥环中，但不再推荐使用此方法。相反，您应该使用 `signed-by` 选项（见下文）在 `sources.list` 条目中显式列出该键。

Third party APT repositories should also provide a special package called `REPONAME-archive-keyring` whose purpose is to provide updates to the GPG key used to sign the  archive. Because this package is signed using the GPG key that is not  present in the system when we are initially configuring the repository,  we need to manually download and put it in the right place the first  time. Assuming that `REPONAME` is `externalrepo`, something like the following should work:
第三方APT仓库还应该提供一个名为 `REPONAME-archive-keyring` 的特殊包，其目的是提供用于签名存档的GPG密钥的更新。因为这个包是使用GPG密钥签名的，当我们最初配置仓库时，系统中没有这个密钥，所以我们需要手动下载并在第一次将它放在正确的位置。假设 `REPONAME` 是 `externalrepo` ，应该可以使用以下方法：

```auto
wget -O /usr/share/keyrings/externalrepo-archive-keyring.pgp https://thirdpartyrepo.com/ubuntu/externalrepo-archive-keyring.pgp
```

#### Sources.list entry 来源.列表条目 

To add a third party APT repository to your system, you will need to create a file under `/etc/apt/sources.list.d/` with information about the external archive. This file is usually named after the repository (in our example, `externalrepo`). There are two standards the file can follow:
要将第三方APT存储库添加到您的系统中，您需要在 `/etc/apt/sources.list.d/` 下创建一个包含外部存档信息的文件。该文件通常以存储库命名（在我们的示例中为 `externalrepo` ）。文件可以遵循两个标准：

- A one-line entry, which is the most common. In this case, the extension of the file should be `.list`.
  一行输入，这是最常见的。在这种情况下，文件的扩展名应该是 `.list` 。
- The `deb822` format, which is more descriptive but less common. In this case, the extension of the file should be `.sources`.
   `deb822` 格式，更具描述性但不太常见。在这种情况下，文件的扩展名应该是 `.sources` 。

An example of a one-line entry would be the following:
单行条目的示例如下： 

```auto
deb [signed-by=/usr/share/keyrings/externalrepo-archive-keyring.pgp] https://thirdpartyrepo.com/ubuntu/ jammy main
```

An example of a `deb822` file for the same case would be the following:
以下是同一情况下的 `deb822` 文件示例：

```auto
Types: deb
URIs: https://thirdpartyrepo.com/ubuntu
Suites: jammy
Components: main
Signed-By: /usr/share/keyrings/externalrepo-archive-keyring.pgp
```

There are cases when the third party APT repository may be served using HTTPS, in which case you will also need to install the `apt-transport-https` package.
在某些情况下，第三方APT存储库可能使用HTTPS提供服务，在这种情况下，您还需要安装 `apt-transport-https` 包。

After adding the repository information, you need to run `apt update` in order to install the third party packages. Also, now that you have everything configured you should be able to install the `externalrepo-archive-keyring` package to automate the update of the GPG key.
添加存储库信息后，您需要运行 `apt update` 以安装第三方软件包。此外，现在您已经配置了所有内容，您应该能够安装 `externalrepo-archive-keyring` 包来自动更新GPG密钥。

### Configure pinning for the repository 配置存储库的固定 

In order to increase the security of your system and to prevent the  conflict issues discussed in the “System integrity” section, we  recommend that you configure pinning for the third party APT repository.
为了提高系统的安全性并防止“系统完整性”部分中讨论的冲突问题，我们建议您为第三方APT存储库配置固定。 

You can configure this preference level by creating a file under `/etc/apt/preferences.d/` that is usually named after the repository name (`externalrepo` in this case).
您可以通过在 `/etc/apt/preferences.d/` 下创建一个文件来配置此首选项级别，该文件通常以存储库名称命名（在本例中为 `externalrepo` ）。

In our example, a file named `/etc/apt/preferences.d/externalrepo` should be created with the following contents:
在我们的示例中，应创建一个名为 `/etc/apt/preferences.d/externalrepo` 的文件，其内容如下：

```auto
Package: *
Pin: origin thirdpartyrepo.com
Pin-Priority: 100
```

There are several levels of pinning you can choose here; the [Debian Reference guide](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_tweaking_candidate_version) has good documentation about the topic. The level `100` used above means that users will be able to install packages from the  repository and that automatic package upgrades are also enabled. If you  want to be able to install packages but don’t want them to be considered for automatic upgrades, you should use the level `1`.
这里有几个级别的固定可以选择; Debian参考指南有关于这个主题的很好的文档。上面使用的级别 `100` 意味着用户将能够从存储库安装软件包，并且还启用了自动软件包升级。如果您希望能够安装软件包，但不希望它们被视为自动升级，则应该使用级别 `1` 。

### How to remove a repository 如何删除存储库 

If you have enabled a third party APT repository but found yourself in a  situation where you would like to remove it from the system, there are a few steps you need to take to make sure that the third party packages  are also uninstalled.
如果您启用了第三方APT存储库，但发现自己处于想要将其从系统中删除的情况下，则需要采取一些步骤来确保第三方软件包也被删除。 

The first step is to remove the files created in the steps above. These are:
第一步是删除在上述步骤中创建的文件。这些措施是： 

- The sources.list file, under `/etc/apt/sources.list.d/`.
  sources.list文件，在 `/etc/apt/sources.list.d/` 下。
- The package pinning preference, under `/etc/apt/preferences.d/`.
  包固定首选项，在 `/etc/apt/preferences.d/` 下。
- If the third party APT repository does not provide the GPG key in a package, then you can also remove it manually from `/usr/share/keyrings/`.
  如果第三方APT存储库没有在包中提供GPG密钥，那么您也可以从 `/usr/share/keyrings/` 手动删除它。

Before you run `apt update`, you might want to also remove the third party packages that were  installed from the repository. The following one-liner will list all  those packages:
在运行 `apt update` 之前，您可能还希望删除从存储库安装的第三方软件包。下面的一行程序将列出所有这些包：

```auto
apt remove --purge \
    $(grep "^Package: " /var/lib/apt/lists/#<SELECT_THE_FILE_FOR_YOUR_REPOSITORY>#_*_Packages \
        | cut -d " " -f2 | sort -u | \
        xargs dpkg-query -W -f='${binary:Package}\t${db:Status-Abbrev}\n' 2> /dev/null | \
        awk '/\tii $/{print $1}')
```

Make sure to replace `#<SELECT_THE_FILE_FOR_YOUR_REPOSITORY>#` with the right file for the third party APT repository.
确保将 `#<SELECT_THE_FILE_FOR_YOUR_REPOSITORY>#` 替换为第三方APT存储库的正确文件。

After that, you can safely run `apt update`.
在此之后，您可以安全地运行 `apt update` 。

## A special case: Ubuntu PPAs 一个特例：Ubuntu PPA 

Ubuntu PPAs can be considered as a special case of third party APT  repositories. In fact, there are upstream projects that choose to ship  their software through PPAs because of the existing tooling that allows  users to easily add them to their Ubuntu systems.
Ubuntu PPA可以被认为是第三方APT存储库的特殊情况。事实上，有些上游项目选择通过PPA发布软件，因为现有的工具允许用户轻松地将其添加到Ubuntu系统中。 

It is important to mention that the same points raised above regarding  security, system integrity and lack of official Ubuntu support also  apply to PPAs.
值得一提的是，上面提到的关于安全性、系统完整性和缺乏官方Ubuntu支持的问题也适用于PPA。 

If you would like to install packages from a PPA, first you will need to add it to your system. For that, you can use the `add-apt-repository` command. Suppose you want to add a PPA from user `thirdparty` named `externalrepo`. You can run:
如果您想从PPA安装软件包，首先需要将其添加到系统中。为此，您可以使用 `add-apt-repository` 命令。假设您要添加来自用户 `thirdparty` 名为 `externalrepo` 的PPA。您可以运行：

```auto
add-apt-repository ppa:thirdparty/externalrepo
```

This command will automatically set up the GPG key, as discussed above. After that, you can run `apt update` and install the third party packages provided by the PPA. Note that `add-apt-repository` will not adjust the repository pinning, so it is recommended that you go through that process manually.
如上所述，此命令将自动设置GPG密钥。之后，您可以运行 `apt update` 并安装PPA提供的第三方软件包。请注意， `add-apt-repository` 不会调整存储库固定，因此建议您手动完成该过程。

If you decide you do not want to use the PPA anymore and would like to  remove it (and its packages) from your system, the easiest way to do it  is by installing the `ppa-purge` package. You can then execute it and provide the PPA reference as its argument. In our example, that would be:
如果您决定不再使用PPA，并希望将其（及其软件包）从系统中删除，最简单的方法是安装 `ppa-purge` 软件包。然后可以执行它并提供PPA引用作为其参数。在我们的例子中，这将是：

```auto
ppa-purge ppa:thirdparty/externalrepo
```

------

# Changing package files 更改软件包文件 

Many packages in Ubuntu will create extra files when installed. These files  can contain metadata, configurations, rules for operating system  interaction, and so on. In many cases, these files will be fully managed by updates to a package, leading to issues when they are modified  manually. This page goes over some methods for changing the behavior of a package without causing conflicts in maintained files.
Ubuntu中的许多软件包在安装时会创建额外的文件。这些文件可以包含元数据、配置、操作系统交互规则等。在许多情况下，这些文件将由包的更新完全管理，从而在手动修改这些文件时导致问题。本页介绍了一些方法，用于更改包的行为，而不会在维护的文件中引起冲突。 

## Configuration files 配置文件 

Configuration files are often provided by packages. They come in many forms, but the majority can be found in the `/etc/` directory with either a `.conf` or `.cnf` extention. Most of the time, these files are managed by the package and editing them could lead to a conflict when updating. To get around  this, packages will check in additional `<config>.d/` directories where you can place personal changes.
配置文件通常由包提供。它们有多种形式，但大多数可以在 `/etc/` 目录中找到，扩展名为 `.conf` 或 `.cnf` 。大多数情况下，这些文件由软件包管理，编辑它们可能会导致更新时发生冲突。为了解决这个问题，软件包将签入额外的 `<config>.d/` 目录，您可以在其中放置个人更改。

For example, if you would like `mysql-server` to run on port 3307 instead of 3306, you can open the file `/etc/mysql/mysql.conf.d/mysqld.cnf`, and edit the port option.
例如，如果您希望 `mysql-server` 在端口3307而不是3306上运行，则可以打开文件 `/etc/mysql/mysql.conf.d/mysqld.cnf` 并编辑端口选项。

```ini
[mysqld]
#
# * Basic Settings
#
user            = mysql
# pid-file      = /var/run/mysqld/mysqld.pid
# socket        = /var/run/mysqld/mysqld.sock
port            = 3307
```

> **Note**: 注意：
>  Some packages do not automatically create files for you to edit in their `.d` directories. In these cases it is often acceptable to just create an  additional config file by any name there. When in doubt, check the  package’s documentation to confirm.
>  有些软件包不会自动在其 `.d` 目录中创建供您编辑的文件。在这些情况下，通常可以通过任何名称创建一个额外的配置文件。如果有疑问，请查看软件包的文档以进行确认。

After saving the file, restart the service.
保存文件后，重新启动服务。 

```bash
systemctl restart mysql
```

The `netstat` command shows that this was successful:
 `netstat` 命令表明这是成功的：

```bash
netstat -tunpevaW | grep -i 3307
tcp        0      0 127.0.0.1:3307          0.0.0.0:*               LISTEN      106        416022     1730/mysqld  
```

## Systemd files Systemd文件 

Many packages ship service unit files for interacting with [Systemd](https://systemd.io/). Unit files allow packages to define background tasks, initialization  behavior, and interactions with the operating system. The files, or  symlinks of them, will automatically be placed in the `/lib/systemd/system/` directory. Likewise, the files can also show up in `/etc/systemd/system`. If these are edited manually they can cause major issues when updating or even running in general.
许多包都提供了用于与Systemd交互的服务单元文件。单元文件允许包定义后台任务、初始化行为以及与操作系统的交互。这些文件或它们的符号链接将自动放置在 `/lib/systemd/system/` 目录中。同样，文件也可以显示在 `/etc/systemd/system` 中。如果这些是手动编辑的，它们可能会在更新甚至运行时导致重大问题。

Instead, if you would like to modify a unit file, do so through Systemd. It provides the command `systemctl edit <service>` which creates an override file and brings up a text editor for you to edit it.
相反，如果您想修改单元文件，请通过Systemd进行修改。它提供了命令 `systemctl edit <service>` ，该命令创建一个覆盖文件，并调出一个文本编辑器供您编辑。

For example, if you want to edit Apache2 such that it restarts after a  failure instead of just when it aborts, you can run the following:
例如，如果你想编辑Apache2，使它在失败后重新启动，而不是仅仅在中止时重新启动，你可以运行以下命令： 

```bash
sudo systemctl edit apache2
```

This will open a text editor containing:
这将打开一个文本编辑器，其中包含： 

```ini
### Editing /etc/systemd/system/apache2.service.d/override.conf
### Anything between here and the comment below will become the new contents of the file



### Lines below this comment will be discarded

### /lib/systemd/system/apache2.service
# [Unit]
# Description=The Apache HTTP Server
# After=network.target remote-fs.target nss-lookup.target
# Documentation=https://httpd.apache.org/docs/2.4/
# 
# [Service]
# Type=forking
# Environment=APACHE_STARTED_BY_SYSTEMD=true
# ExecStart=/usr/sbin/apachectl start
# ExecStop=/usr/sbin/apachectl graceful-stop
# ExecReload=/usr/sbin/apachectl graceful
# KillMode=mixed
# PrivateTmp=true
# Restart=on-abort
...
```

Override the on-abort option by adding a new line in the designated edit location.
通过在指定的编辑位置添加新行来禁用on-abort选项。 

```ini
### Editing /etc/systemd/system/apache2.service.d/override.conf
### Anything between here and the comment below will become the new contents of the file

[Service]
Restart=on-failure

### Lines below this comment will be discarded
...
```

> **Note**: 注意：
>  Some options, such as `ExecStart` are additive. If you would like to fully override them add an extra line that clears it (e.g. `ExecStart=`) before providing new options. See [Systemd’s man page](https://www.freedesktop.org/software/systemd/man/systemd.service.html) for more information.
>  某些选项（如 `ExecStart` ）是附加的。如果你想完全覆盖它们，在提供新的选项之前添加一个额外的行来清除它（例如 `ExecStart=` ）。有关更多信息，请参见Systemd的手册页。

Once the changes are saved, the override file will be created in `/etc/systemd/system/apache2.service.d/override.conf`. To apply changes, run
保存更改后，将在 `/etc/systemd/system/apache2.service.d/override.conf` 中创建覆盖文件。要应用更改，请运行

```bash
sudo systemctl daemon-reload
```

To verify the change was successful, you can run the status command.
要验证更改是否成功，可以运行status命令。 

```bash
systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; preset: enabled)
    Drop-In: /etc/systemd/system/apache2.service.d
             └─override.conf
             /run/systemd/system/service.d
             └─zzz-lxc-service.conf
     Active: active (running) since Fri 2023-02-17 16:39:22 UTC; 27min ago
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 4735 (apache2)
      Tasks: 55 (limit: 76934)
     Memory: 6.5M
        CPU: 65ms
     CGroup: /system.slice/apache2.service
             ├─4735 /usr/sbin/apache2 -k start
             ├─4736 /usr/sbin/apache2 -k start
             └─4737 /usr/sbin/apache2 -k start
...
```

## AppArmor

Packages that use [AppArmor](https://ubuntu.com/server/docs/security-apparmor) will install AppArmor profiles in the `/etc/apparmor.d/` directory. These files are often named after the process being protected, such as `usr.bin.firefox` and `usr.sbin.libvirtd`.
使用AppArmor的软件包将在 `/etc/apparmor.d/` 目录中安装AppArmor配置文件。这些文件通常以受保护的进程命名，例如 `usr.bin.firefox` 和 `usr.sbin.libvirtd` 。

When these files are modified manually, it can lead to a conflict during updates. This will show up in `apt` with something like:
手动修改这些文件时，可能会导致更新期间发生冲突。这将显示在 `apt` 中，类似于：

```bash
Configuration file '/etc/apparmor.d/usr.bin.swtpm'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** usr.bin.swtpm (Y/I/N/O/D/Z) [default=N] ?
```

Updating to the maintainer’s version will override your changes, which could  cause problems with your setup. However, using your version could cause  security issues.
更新到维护者的版本将覆盖您的更改，这可能会导致您的设置出现问题。但是，使用您的版本可能会导致安全问题。 

If you would like to modify these rules to provide the application with  additional permissions, you can instead update the local profile, most  often found in `/etc/apparmor.d/local/`.
如果您想修改这些规则以向应用程序提供额外的权限，您可以改为更新本地配置文件，最常见的是在 `/etc/apparmor.d/local/` 中。

For example, if you would like `swtpm` to access a custom directory called `/var/customtpm`, you can append the following line to `/etc/apparmor.d/local/usr.bin.swtpm` :
例如，如果您希望 `swtpm` 访问名为 `/var/customtpm` 的自定义目录，则可以将以下行附加到 `/etc/apparmor.d/local/usr.bin.swtpm` ：

```apparmor
/var/customtpm/** rwk,
```

This method will work for all [AppArmor syntax](https://ubuntu.com/tutorials/beginning-apparmor-profile-development).
此方法适用于所有AppArmor语法。

> **Note**: 注意：
>  Although most local profiles have the same name as the maintainer’s, you can often check what file is included based on the main profile’s  contents. In `swtpm`’s case, `/etc/apparmor.d/usr.bin.swtpm` contains the lines:
>  尽管大多数本地配置文件与维护者的配置文件同名，但您通常可以根据主配置文件的内容检查包含哪些文件。在 `swtpm` 的情况下， `/etc/apparmor.d/usr.bin.swtpm` 包含以下行：
>
> ```apparmor
> # Site-specific additions and overrides. See local/README for details.
> #include <local/usr.bin.swtpm>
> ```
>
> showing that the local profile is located at `/etc/apparmor.d/local/usr.bin.swtpm`
> 显示本地配置文件位于 `/etc/apparmor.d/local/usr.bin.swtpm` 

## Restoring configuration files 正在还原配置文件 

Since config files are meant to be intentional changes by the user/admin,  they are not overwritten by updates or even re-installs of the package.  However, it’s possible you might change it by accident or may just want  to go back to step one of a trial-and-error phase that you are in. In  those situations you can use `apt` to restore the original config files. Note that while we call `apt`, it is `dpkg` that actually handles the restoration.
由于配置文件是用户/管理员有意更改的，因此它们不会被更新或甚至重新安装软件包覆盖。但是，也有可能您无意中更改了它，或者可能只是想回到您所处的试错阶段的第一步。在这些情况下，您可以使用 `apt` 来恢复原始配置文件。请注意，虽然我们调用 `apt` ，但实际上是 `dpkg` 处理恢复。

If you have a particular config file, like in the example `/etc/rsyslog.conf`, you first want to find out which package owns that config file:
如果你有一个特定的配置文件，比如在示例 `/etc/rsyslog.conf` 中，你首先要找出哪个包拥有这个配置文件：

```bash
$ dpkg -S /etc/rsyslog.conf

rsyslog: /etc/rsyslog.conf
```

So we now know that the package `rsyslog` owns the config file `/etc/rsyslog.conf`.
因此，我们现在知道软件包 `rsyslog` 拥有配置文件 `/etc/rsyslog.conf` 。
 This command just queries package metadata and works even if the file has been deleted.
 此命令仅查询包元数据，即使文件已被删除也有效。

```bash
$ rm /etc/rsyslog.conf
$ dpkg -S /etc/rsyslog.conf

rsyslog: /etc/rsyslog.con
```

To restore that file you can re-install the package, telling `dpdk` to bring any missing files back.
要恢复该文件，您可以重新安装软件包，告诉 `dpdk` 将任何丢失的文件带回来。
 To do so you pass `dpkg` options through `apt` using `-o Dpkg::Options::="` and then set `--force-...` depending on what action you want. For example:
 要做到这一点，您可以使用 `-o Dpkg::Options::="` 将 `dpkg` 选项传递到 `apt` ，然后根据您想要的操作设置 `--force-...` 。举例来说：

```bash
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confmiss" rsyslog
...
Preparing to unpack .../rsyslog_8.2302.0-1ubuntu3_amd64.deb ...
Unpacking rsyslog (8.2302.0-1ubuntu3) over (8.2302.0-1ubuntu3) ...
Setting up rsyslog (8.2302.0-1ubuntu3) ...

Configuration file '/etc/rsyslog.conf', does not exist on system.
Installing new config file as you requested.
```

More details on these options can be found in the [`dpkg` man page](https://manpages.ubuntu.com/manpages/jammy/en/man1/dpkg.1.html), but the most common and important ones are:
有关这些选项的更多详细信息，请参见 `dpkg` 手册页，但最常见和最重要的选项是：

- `confmiss`
   Always install the missing conffile without prompting.
   总是安装缺少的文件而不提示。
- `confnew`
   If a conffile has been modified and the version in the package changed, always install the new version without prompting.
   如果一个文件被修改了，包中的版本也改变了，总是安装新版本而不提示。
- `confold`
   If a conffile has been modified and the version in the package changed, always keep the old version without prompting.
   如果一个文件被修改了，包中的版本也改变了，那么总是保留旧版本，而不提示。
- `confdef`
   If a conffile has been modified and the version in the package changed, always choose the default action without prompting.
   如果一个文件被修改了，并且包中的版本也改变了，那么总是选择默认操作而不提示。
- `confask`
   If a conffile has been modified, always offer to replace it with the  version in the package, even if the version in the package did not  change.
   如果一个conffile被修改了，总是提供用包中的版本替换它，即使包中的版本没有改变。

So in the case of an accidental bad config entry, if you want to go back to the package default you could use `--force-confask` to check the difference and consider restoring the content.
因此，在意外的错误配置条目的情况下，如果你想回到包默认值，你可以使用 `--force-confask` 来检查差异并考虑恢复内容。

```bash
$ echo badentry >> /etc/rsyslog.conf
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confask" rsyslog
...
Preparing to unpack .../rsyslog_8.2302.0-1ubuntu3_amd64.deb ...
Unpacking rsyslog (8.2302.0-1ubuntu3) over (8.2302.0-1ubuntu3) ...
Setting up rsyslog (8.2302.0-1ubuntu3) ...

Configuration file '/etc/rsyslog.conf'
 ==> Modified (by you or by a script) since installation.
     Version in package is the same as at last installation.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** rsyslog.conf (Y/I/N/O/D/Z) [default=N] ? D
--- /etc/rsyslog.conf   2023-04-18 07:11:50.427040350 +0000
+++ /etc/rsyslog.conf.dpkg-new  2023-02-23 16:58:03.000000000 +0000
@@ -51,4 +51,3 @@
 # Include all config files in /etc/rsyslog.d/
 #
 $IncludeConfig /etc/rsyslog.d/*.conf
-badentry

Configuration file '/etc/rsyslog.conf'
 ==> Modified (by you or by a script) since installation.
     Version in package is the same as at last installation.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** rsyslog.conf (Y/I/N/O/D/Z) [default=N] ? y
Installing new version of config file /etc/rsyslog.conf ...
```

The same can be used if you removed a whole directory by accident, to detect and re-install all related packages config files.
如果您意外删除了整个目录，可以使用相同的方法来检测并重新安装所有相关的软件包配置文件。 

```bash
$ rm -rf /etc/vim
$ dpkg -S /etc/vim
vim-common, vim-tiny: /etc/vim
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confmiss" vim-common vim-tiny
...
Configuration file '/etc/vim/vimrc', does not exist on system.
Installing new config file as you requested.
...
Configuration file '/etc/vim/vimrc.tiny', does not exist on system.
Installing new config file as you requested.
```

------

# About web servers 关于Web服务器 

The primary function of a **web server** is to store, process and deliver **web pages** to clients. The clients communicate with the server by sending HTTP requests.
Web服务器的主要功能是存储、处理和向客户端提供网页。客户端通过发送HTTP请求与服务器通信。

Clients, mostly via **web browsers**, request specific resources and the server responds with the content of  that resource (or an error message). The response is usually a web page  in the form of HTML documents – which may include images, style sheets,  scripts, and text.
客户端（主要是通过Web浏览器）请求特定的资源，服务器用该资源的内容（或错误消息）进行响应。响应通常是HTML文档形式的网页，其中可能包括图像、样式表、脚本和文本。

## URLs 网址 

Users enter a Uniform Resource Locator (URL) to point to a web server by  means of its Fully Qualified Domain Name (FQDN) and a path to the  required resource. For example, to view the home page of the [Ubuntu Web site](https://www.ubuntu.com) a user will enter only the FQDN:
用户输入统一资源定位符（URL），通过其完全限定的域名（FQDN）和所需资源的路径指向Web服务器。例如，要查看Ubuntu网站的主页，用户只需输入以下内容：

```nohighlight
www.ubuntu.com
```

To view the [community](https://www.ubuntu.com/community) sub-page, a user will enter the FQDN followed by a path:
要查看社区子页面，用户将输入后缀，后跟路径：

```nohighlight
www.ubuntu.com/community
```

## Transfer protocols 传输协议 

The most common protocol used to transfer web pages is the Hyper Text  Transfer Protocol (HTTP). Protocols such as Hyper Text Transfer Protocol over Secure Sockets Layer (HTTPS), and File Transfer Protocol (FTP), a  protocol for uploading and downloading files, are also supported.
用于传输网页的最常见协议是超文本传输协议（HTTP）。还支持诸如安全套接字层上的超文本传输协议（HTTPS）和文件传输协议（FTP）（用于上传和下载文件的协议）之类的协议。 

### HTTP status codes HTTP状态代码 

When accessing a web server, every HTTP request received is responded to  with content and a HTTP status code. HTTP status codes are three-digit  codes, which are grouped into five different classes. The class of a  status code can be quickly identified by its first digit:
当访问Web服务器时，收到的每个HTTP请求都会得到内容和HTTP状态代码的响应。HTTP状态码是三位数的代码，分为五个不同的类。状态代码的类别可以通过其第一位数字快速识别： 

- **1xx** :  *Informational* - Request received, continuing process
  1xx：信息-收到请求，继续处理
- **2xx** :  *Success* - The action was successfully received, understood, and accepted
  2xx：成功-成功接收、理解并接受操作
- **3xx** :  *Redirection* - Further action must be taken in order to complete the request
  3xx：重定向-必须采取进一步的操作才能完成请求
- **4xx** :  *Client Error* - The request contains bad syntax or cannot be fulfilled
  4xx：客户端错误-请求包含错误语法或无法完成
- **5xx** :  *Server Error* - The server failed to fulfill an apparently valid request
  5xx：服务器错误-服务器无法完成明显有效的请求

For more information about status codes, [check the RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html#sec6.1.1).
有关状态码的更多信息，请查看RFC 2616。

## Implementation 执行 

Web servers are heavily used in the deployment of websites, and there are two different implementations:
Web服务器在网站的部署中大量使用，有两种不同的实现方式： 

- **Static web server**: The content of the server’s response will be the hosted files “as-is”.
  静态Web服务器：服务器响应的内容将是托管文件“原样”。

- **Dynamic web server**:  Consists of a web server plus additional software (usually an *application server* and a *database*).
  动态Web服务器：由Web服务器和附加软件（通常是应用程序服务器和数据库）组成。

  For example, to produce the web pages you see in your web browser, the  application server might fill an HTML template with contents from a  database. We can therefore say that the content of the server’s response is generated dynamically.
  例如，为了生成您在Web浏览器中看到的网页，应用程序服务器可能会使用数据库中的内容填充HTML模板。因此，我们可以说服务器响应的内容是动态生成的。 

# About Squid proxy servers 关于Squid代理服务器 

[Squid](http://www.squid-cache.org/) is a proxy cache server which provides proxy and cache services for  Hyper Text Transport Protocol (HTTP), File Transfer Protocol (FTP), and  other popular network protocols.
 Squid是一个代理缓存服务器，它为超文本传输协议（HTTP）、文件传输协议（FTP）和其他流行的网络协议提供代理和缓存服务。

It acts as an intermediary between web servers and clients. When a client  sends a request for content, Squid fetches the content from the web  server and creates a local copy. Then, if a request is made again, it  shows the local, cached copy instead of making another request to the  web server. In this way, performance is improved and network bandwidth  is optimised. It can also filter web traffic, helping to improve  security.
它充当Web服务器和客户端之间的中介。当客户端发送内容请求时，Squid从Web服务器获取内容并创建本地副本。然后，如果再次发出请求，它会显示本地缓存副本，而不是向Web服务器发出另一个请求。通过这种方式，可以提高性能并优化网络带宽。它还可以过滤网络流量，帮助提高安全性。 

## Features 特征 

The Squid proxy cache server scales from the branch office to enterprise  level networks. It provides extensive, granular access controls, and  monitoring of critical parameters via the Simple Network Management  Protocol (SNMP).
Squid代理缓存服务器可从分支办公室扩展到企业级网络。它通过简单网络管理协议（SNMP）提供广泛的粒度访问控制和关键参数监控。 

When selecting a computer system for use as a dedicated Squid caching proxy  server, it is helpful to configure it with a large amount of physical  memory as Squid maintains an in-memory cache for increased performance.
当选择一个计算机系统作为专用Squid缓存代理服务器时，为它配置大量的物理内存是很有帮助的，因为Squid维护内存中的缓存以提高性能。 

## Caching 缓存 

Squid can implement caching and proxying of Secure Sockets Layer (SSL)  requests and caching of Domain Name Server (DNS) lookups, and perform  transparent caching. Squid also supports a wide variety of caching  protocols, such as Internet Cache Protocol (ICP), the Hyper Text Caching Protocol (HTCP), the Cache Array Routing Protocol (CARP), and the Web  Cache Coordination Protocol (WCCP).
Squid可以实现安全套接字层（SSL）请求的缓存和加密以及域名服务器（DNS）查找的缓存，并执行透明缓存。Squid还支持多种缓存协议，如Internet缓存协议（ICP）、超文本缓存协议（HTCP）、该高速缓存阵列路由协议（CARP）和Web缓存协调协议（WCCP）。 

If you would like to know how to install and configure your own Squid server, refer to [our installation guide](https://ubuntu.com/server/docs/how-to-install-a-squid-server).
如果您想了解如何安装和配置自己的Squid服务器，请参阅我们的安装指南。

## Further reading 进一步阅读 

- [The Squid website Squid网站](http://www.squid-cache.org/)
- [Ubuntu Wiki page on Squid](https://help.ubuntu.com/community/Squid).
   Squid上的Ubuntu Wiki页面

------

# TuneD 突尼斯 

[TuneD](https://tuned-project.org/)*1 is a service used to tune your system and optimise the performance under certain workloads. At the core of TuneD are **profiles**, which tune your system for different use cases. TuneD is distributed  with a number of predefined profiles for use cases such as:
 TuneD *1 是一项服务，用于调整您的系统并优化某些工作负载下的性能。TuneD的核心是配置文件，它针对不同的用例调整您的系统。TuneD与许多预定义的配置文件一起分发，用于用例，例如：

- High throughput 高通量 
- Low latency 低延迟 
- Saving power 节省功率 

It is possible to modify the rules defined for each profile and customise  how to tune a particular device. When you switch to another profile or  deactivate TuneD, all changes made to the system settings by the  previous profile revert back to their original state.
可以修改为每个配置文件定义的规则，并自定义如何调整特定设备。当您切换到另一个配置文件或停用TuneD时，以前的配置文件对系统设置所做的所有更改都将恢复到其原始状态。 

You can also configure TuneD to dynamically react to changes in device  usage and adjust settings to improve the performance of active devices  and reduce the power consumption of inactive devices.
您还可以将TuneD配置为动态响应设备使用情况的变化，并调整设置以提高活动设备的性能并降低非活动设备的功耗。 

Almost all tunable parameters can be good for one and bad for another type of  workload or environment. Not even the goal of tuning is the same for  everyone; do you want to improve latency, throughput, thermal or  work-per-power? The system defaults generally aim for a good compromise  on all of these, no matter what you will do with your system. The same  is true for the TuneD profiles - they are only suggestions and starting  points for a few named workload categories that allow you to react  dynamically. But those can’t be perfect either - the more you know about your workload, your system and what you want to achieve with your  tuning, the more you’ll be able to improve it to suit your needs.
几乎所有可调参数都可能对一种类型的工作负载或环境有利，而对另一种类型的工作负载或环境不利。甚至每个人的调优目标也不相同;您是想提高延迟、吞吐量、散热还是功耗比？系统默认值通常旨在对所有这些进行良好的折衷，无论您将如何处理系统。TuneD配置文件也是如此-它们只是一些命名工作负载类别的建议和起点，允许您动态响应。但是这些也不可能是完美的--您越了解您的工作负载、您的系统以及您希望通过调优实现的目标，您就越能够改进它以满足您的需求。 

## Static vs. dynamic tuning 静态调整与动态调整 

TuneD can perform two types of tuning: **static** and **dynamic**.
TuneD可以执行两种类型的调优：静态和动态。

- Static tuning mainly consists of applying predefined `sysctl` and `sysfs` settings and the one-shot activation of several configuration tools such as `ethtool`.
  静态调优主要包括应用预定义的 `sysctl` 和 `sysfs` 设置，以及一次性激活多个配置工具，如 `ethtool` 。
- In dynamic tuning, it watches how various system components are used  throughout the uptime of your system. TuneD then adjusts the system  settings dynamically based on that monitoring information. For example,  the hard drive is used heavily during startup and login, but is barely  used later when the user is mainly working with applications (e.g. web  browsers or email clients). Similarly, the CPU and network devices are  used differently at different times. TuneD monitors the activity of  these components and reacts to the changes in their use.
  在动态调优中，它观察各种系统组件在系统的整个过程中是如何使用的。TuneD然后根据该监控信息动态调整系统设置。例如，在启动和登录期间大量使用硬盘驱动器，但当用户主要使用应用程序（例如Web浏览器或电子邮件客户端）时，几乎不使用。同样，CPU和网络设备在不同时间的使用也不同。TuneD监控这些组件的活动，并对它们的使用变化做出反应。 

By default, dynamic tuning is enabled. To disable it, edit the `/etc/tuned/tuned-main.conf` file and change the `dynamic_tuning` option to `0`. TuneD then periodically analyses system statistics and uses them to  update your system tuning settings. To configure the time interval in  seconds between these updates, use the `update_interval` option. After any change in this configuration file, the systemd service needs to be restarted.
默认情况下，启用动态优化。要禁用它，请编辑 `/etc/tuned/tuned-main.conf` 文件并将 `dynamic_tuning` 选项更改为 `0` 。然后TuneD会定期分析系统统计信息，并使用它们来更新系统优化设置。要配置这些更新之间的时间间隔（以秒为单位），请使用 `update_interval` 选项。在此配置文件中进行任何更改后，需要重新启动systemd服务。

## Profiles 配置文件 

TuneD works with profiles, which are configuration files listing the tuning  plugins and their options. Many predefined profiles are already shipped  with the TuneD package, you can see them in `/usr/lib/tuned`. After installing the TuneD package, one can also use the `tuned-adm list` command to get a brief summary of all of the available profiles.
TuneD与配置文件一起工作，配置文件是列出调优插件及其选项的配置文件。许多预定义的配置文件已经与TuneD包一起提供，您可以在 `/usr/lib/tuned` 中看到它们。安装TuneD包后，还可以使用 `tuned-adm list` 命令获取所有可用配置文件的简要摘要。

Once the package is installed in a system, a profile is activated by default depending on the environment. These are the default profiles for each  type of environment:
在系统中安装软件包后，根据环境的不同，默认情况下会激活配置文件。以下是每种环境类型的默认配置文件： 

| Environment             | Default profile 默认配置文件 |
| ----------------------- | ---------------------------- |
| Compute nodes 计算节点  | `throughput-performance`     |
| Virtual Machines 虚拟机 | `virtual-guest`              |
| Containers              | `default`                    |
| Other cases             | `balanced`                   |

### Available profiles 可用配置文件 

The list of available profiles can be found using the following command:
可以使用以下命令找到可用配置文件的列表： 

```auto
root@tuned:~# tuned-adm list
Available profiles:
[...]
```

You can also check which profile is enabled:
您还可以检查启用了哪个配置文件： 

```console
root@tuned:~# tuned-adm active
Current active profile: virtual-guest
```

You can see the recommended profile:
你可以看到推荐的配置文件： 

```console
root@tuned:~# tuned-adm recommend
virtual-guest
```

And you can switch to another profile:
您可以切换到另一个配置文件： 

```console
root@tuned:~# tuned-adm profile default
root@tuned:~# tuned-adm active
Current active profile: default
```

### Customising a profile 自定义配置文件 

For some specific workloads, the predefined profiles might not be enough  and you may want to customise your own profile. In order to do that, you should follow these steps:
对于某些特定的工作负载，预定义的配置文件可能不够，您可能希望自定义自己的配置文件。为了做到这一点，你应该遵循这些步骤： 

- Inside `/etc/tuned`, create a directory with the name of your new profile.
  在 `/etc/tuned` 中，用新配置文件的名称创建一个目录。
- Inside the newly created directory, create a file called `tuned.conf`.
  在新创建的目录中，创建一个名为 `tuned.conf` 的文件。
- Write your custom configuration in the `tuned.conf` file.
  在 `tuned.conf` 文件中写入您的自定义配置。

After that, the new profile will be visible by TuneD via the `tuned-adm list` command. This is a simple example of a customised profile (it could be created in `/etc/tuned/custom-profile/tuned.conf`):
之后，TuneD将通过 `tuned-adm list` 命令看到新的配置文件。这是一个自定义配置文件的简单示例（可以在 `/etc/tuned/custom-profile/tuned.conf` 中创建）：

```plaintext
[main]
include=postgresql

[cpu]
load_threshold=0.5
latency_low=10
latency_high=10000
```

In the `[main]` section, the `include` keyword can be used to include any other predefined profile (in this example we are including the `postgresql` one).
在 `[main]` 部分， `include` 关键字可以用来包含任何其他预定义的配置文件（在本例中，我们包含 `postgresql` ）。

After the `[main]` section, the list of plugins (ways of tuning your system) can be  introduced, with all the options (here, there is just one plugin called `cpu` being used). For more information about the syntax and the list of plugins and their options, please refer to the [upstream documentation](https://github.com/redhat-performance/tuned/tree/master/doc/manual/).
在 `[main]` 部分之后，可以介绍插件列表（调优系统的方法），以及所有选项（这里，只使用了一个名为 `cpu` 的插件）。有关语法和插件列表及其选项的更多信息，请参阅上游文档。

## An example profile: hpc-compute 配置文件示例：hpc-compute 

Let’s take look at the predefined `hpc-compute` profile in more detail as an example. You can find the configuration of this profile in `/usr/lib/tuned/hpc-compute/tuned.conf`:
让我们以预定义的 `hpc-compute` 配置文件为例进行详细介绍。您可以在 `/usr/lib/tuned/hpc-compute/tuned.conf` 中找到此配置文件的配置：

```plaintext
\#
\# tuned configuration
\#

[main]
summary=Optimize for HPC compute workloads
description=Configures virtual memory, CPU governors, and network settings for HPC compute workloads.
include=latency-performance

[vm]
\# Most HPC application can take advantage of hugepages. Force them to on.
transparent_hugepages=always

[disk]
\# Increase the readahead value to support large, contiguous, files.
readahead=>4096

[sysctl]
\# Keep a reasonable amount of memory free to support large mem requests
vm.min_free_kbytes=135168

\# Most HPC applications are NUMA aware. Enabling zone reclaim ensures
\# memory is reclaimed and reallocated from local pages. Disabling
\# automatic NUMA balancing prevents unwanted memory unmapping.
vm.zone_reclaim_mode=1
kernel.numa_balancing=0

\# Busy polling helps reduce latency in the network receive path
\# by allowing socket layer code to poll the receive queue of a
\# network device, and disabling network interrupts.
\# busy_read value greater than 0 enables busy polling. Recommended
\# net.core.busy_read value is 50.
\# busy_poll value greater than 0 enables polling globally.
\# Recommended net.core.busy_poll value is 50
net.core.busy_read=50
net.core.busy_poll=50

\# TCP fast open reduces network latency by enabling data exchange
\# during the sender's initial TCP SYN. The value 3 enables fast open
\# on client and server connections.
net.ipv4.tcp_fastopen=3
```

The `[main]` section contains some metadata about this profile, a summary and  description, and whether it includes other profiles. In this case,  another profile *is* included; the `latency-performance` profile.
 `[main]` 部分包含有关此配置文件的一些元数据、摘要和描述，以及它是否包含其他配置文件。在这种情况下，包括另一个配置文件; `latency-performance` 配置文件。

The sections that follow `[main]` represent the configuration of tuning plugins.
 `[main]` 后面的部分表示调优插件的配置。

- The first one is the `vm` plugin, which is used to always make use of huge pages (useful in this HPC scenario).
  第一个是 `vm` 插件，用于始终使用巨大的页面（在此HPC场景中很有用）。
- The second plugin used is `disk`, which is used to set the `readahead` value to at least `4096`.
  使用的第二个插件是 `disk` ，用于将 `readahead` 值设置为至少 `4096` 。
- Finally, the `sysctl` plugin is configured to set several variables in `sysfs` (the comments in the example explain the rationale behind each change).
  最后， `sysctl` 插件被配置为在 `sysfs` 中设置几个变量（示例中的注释解释了每个更改背后的原理）。

The content of this profile can be overwritten if needed, by creating the file `/etc/tuned/hpc-compute/tuned.conf` with the desired content. The content in `/etc/tuned` always takes precedence over `/usr/lib/tuned`. One can also extend this profile by creating a custom profile and including `hpc-compute`.
如果需要，可以通过使用所需内容创建文件 `/etc/tuned/hpc-compute/tuned.conf` 来覆盖此配置文件的内容。 `/etc/tuned` 中的内容始终优先于 `/usr/lib/tuned` 。也可以通过创建自定义配置文件并包含 `hpc-compute` 来扩展此配置文件。

## Known issue in Ubuntu Ubuntu中的已知问题 

There is a known issue that a user should be aware of when using TuneD in Ubuntu:
在Ubuntu中使用TuneD时，用户应该注意一个已知的问题： 

- Any predefined or customised profile making use of the **scheduler** and the **irqbalance** tuning plugins will not work, because those two plugins depend on the `perf` Python module which is not provided by Ubuntu. There is a request to provide the needed Python module in [LP: #2051560](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2051560).
  任何预定义或自定义的配置文件使用调度器和irqbalance调优插件将无法工作，因为这两个插件依赖于Ubuntu不提供的 `perf` Python模块。有一个请求，要求在LP中提供所需的Python模块：#2051560。

## *1 This is a universe package  *1 这是一个宇宙包

Ubuntu ships this software as part of its [universe repository](https://canonical-ubuntu-pro-client.readthedocs-hosted.com/en/latest/explanations/about_esm/#what-are-main-and-universe), which is maintained by volunteers from the Ubuntu community. Canonical also offers [Ubuntu Pro](https://ubuntu.com/pro) – a free-for-personal-use subscription that provides a 10 year [security maintenance commitment](https://ubuntu.com/security/esm).
Ubuntu将此软件作为其universe存储库的一部分发布，该存储库由Ubuntu社区的志愿者维护。Canonical还提供Ubuntu Pro -一个免费的个人使用订阅，提供10年的安全维护承诺。

## Further reading 进一步阅读 

- [TuneD website TuneD网站](https://tuned-project.org/)
- [tuned-adm manpage tuned-adm手册页](https://manpages.ubuntu.com/manpages/noble/en/man8/tuned-adm.8.html)
- [TuneD profiles manpage TuneD profiles手册页](https://manpages.ubuntu.com/manpages/noble/en/man7/tuned-profiles.7.html)
- [TuneD daemon manpage TuneD守护程序手册页](https://manpages.ubuntu.com/manpages/noble/en/man8/tuned.8.html)
- [TuneD configuration manpage
   TuneD配置手册页](https://manpages.ubuntu.com/manpages/noble/en/man5/tuned.conf.5.html)

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [                   Previous 先前                    Web servers: About Squid proxy servers
Web服务器：关于Squid代理服务器                  ](https://ubuntu.com/server/docs/about-squid-proxy-servers)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             [                   Next 下                    High Availability: Pacemaker resource ](https://ubuntu.com/server/docs/pacemaker-resource-agents)

# Pacemaker resource agents Pacemaker资源代理 

From the ClusterLabs definition:
根据QuestionerLabs定义： 

> Resource agents are the abstraction that allows Pacemaker to manage services it  knows nothing about. They contain the logic for what to do when the  cluster wishes to start, stop or check the health of a service. This  particular set of agents conform to the Open Cluster Framework (OCF)  specification.
> 资源代理是允许Pacemaker管理其一无所知的服务的抽象。它们包含当集群希望启动、停止或检查服务的健康状况时要做什么的逻辑。这组特定的代理符合开放集群框架（OCF）规范。 

Currently, the `resource-agents` binary package has been split into two: `resource-agents-base` and `resource-agents-extra`. The `resource-agents-base` binary package contains a set of curated agents which the Ubuntu Server team continuously runs tests on to make sure everything is working as  expected. All the other agents previously in the `resource-agents` binary package are now found in the `resource-agents-extra` package.
目前， `resource-agents` 二进制包已被分成两个： `resource-agents-base` 和 `resource-agents-extra` 。 `resource-agents-base` 二进制包包含一组策划代理，Ubuntu Server团队不断对其进行测试，以确保一切都按预期工作。以前在 `resource-agents` 二进制包中的所有其他代理现在都可以在 `resource-agents-extra` 包中找到。

The `resource-agents-base` binary package contains the following agents in the latest Ubuntu release:
在最新的Ubuntu版本中， `resource-agents-base` 二进制包包含以下代理：

- `IPaddr2`
- `iscsi`
- `iSCSILogicalUnit`
- `iSCSITarget`
- `LVM-activate`
- `systemd`

All of these agents are in `main` and are fully supported.
所有这些代理都在 `main` 中，并且完全受支持。

All other agents are in `resource-agents-extra` and while most of them are supported by upstream, they are not curated  by the Ubuntu Server team. The set of resource agents that are not  maintained by upstream is listed in `/usr/share/doc/resource-agents-extra/DEPRECATED_AGENTS`, the use of those agents is discouraged.
所有其他代理都在 `resource-agents-extra` 中，虽然它们中的大多数都由上游支持，但它们不是由Ubuntu Server团队策划的。 `/usr/share/doc/resource-agents-extra/DEPRECATED_AGENTS` 中列出了不由上游维护的资源代理集，不鼓励使用这些代理。

For the resource agents provided by `resource-agents-base`, we will briefly describe how to use them.
对于 `resource-agents-base` 提供的资源代理，我们将简要介绍如何使用它们。

> **Note**: 注意：
>  There are two well known tools used to manage fence agents, they are `crmsh` and `pcs`. Here we will present examples with both, since `crmsh` is the recommended and supported tool until Ubuntu 22.10 Kinetic Kudu, and `pcs` is the recommended and supported tool from Ubuntu 23.04 Lunar Lobster onwards. For more information on how to migrate from `crmsh` to `pcs` please [refer to this migration guide](https://ubuntu.com/server/docs/migrate-from-crmsh-to-pcs).
>  有两个众所周知的工具用于管理围栏代理，它们是 `crmsh` 和 `pcs` 。在这里，我们将展示这两个例子，因为 `crmsh` 是Ubuntu 22.10 Kinetic Kudu之前推荐和支持的工具，而 `pcs` 是Ubuntu 23.04 Lunar Lobster之后推荐和支持的工具。有关如何从 `crmsh` 迁移到 `pcs` 的更多信息，请参阅此迁移指南。

## IPaddr2 ipaddr 2的 

From its manpage: 从它的manpage： 

> This Linux-specific resource manages IP alias IP addresses. It can add an IP alias, or remove one. In addition, it can implement Cluster Alias IP  functionality if invoked as a clone resource.
> 此Linux特定资源管理IP别名IP地址。它可以添加或删除IP别名。此外，如果作为克隆资源调用，它还可以实现群集VOIP功能。 

One could configure a `IPaddr2` resource with the following command:
可以使用以下命令配置 `IPaddr2` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME ocf:heartbeat:IPaddr2 \
            ip=$IP_ADDRESS \
            cidr_netmask=$NET_MASK \
            op monitor interval=30s
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME ocf:heartbeat:IPaddr2 \
            ip=$IP_ADDRESS \
            cidr_netmask=$NET_MASK \
            op monitor interval=30s
```

This is one way to set up `IPaddr2`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/man7/ocf_heartbeat_IPaddr2.7.html).
这是设置 `IPaddr2` 的一种方法，有关更多信息，请参阅其手册页。

## iscsi

From its manpage: 从它的manpage： 

> Manages a local iSCSI initiator and its connections to iSCSI targets.
> 管理本地iSCSI启动器及其与iSCSI目标的连接。 

Once the iSCSI target is ready to accept connections from the initiator(s), with all the appropriate permissions, the `iscsi` resource can be configured with the following command:
一旦iSCSI目标准备好接受来自启动器的连接，并具有所有适当的权限，就可以使用以下命令配置 `iscsi` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME ocf:heartbeat:iscsi \
          target=$TARGET \
          portal=$PORTAL
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME ocf:heartbeat:iscsi \
          target=$TARGET \
          portal=$PORTAL
```

Where `$TARGET` is the iSCSI Qualified Name (IQN) of the iSCSI target and `$PORTAL` its address, which can be, for instance, formed by the IP address and port number used by the target daemon.
其中 `$TARGET` 是iSCSI目标的iSCSI限定名称（IQN）， `$PORTAL` 是其地址，例如，可以由目标守护程序使用的IP地址和端口号形成。

This is one way to set up `iscsi`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man7/ocf_heartbeat_iscsi.7.html).
这是设置 `iscsi` 的一种方法，有关更多信息，请参阅其手册页。

## iSCSILogicalUnit iSCSI逻辑单元 

From its manpage: 从它的manpage： 

> Manages iSCSI Logical Unit. An iSCSI Logical unit is a subdivision of an SCSI  Target, exported via a daemon that speaks the iSCSI protocol.
> 管理iSCSI逻辑单元。iSCSI逻辑单元是SCSI目标的一个细分，通过使用iSCSI协议的守护程序导出。 

This agent is usually used alongside with `iSCSITarget` to manage the target itself and its Logical Units. The supported implementation of iSCSI targets is using `targetcli-fb`, due to that, make sure to use `lio-t` as the implementation type. Considering one has an iSCSI target in place, the `iSCSILogicalUnit` resource could be configured with the following command:
此代理通常与 `iSCSITarget` 一起使用，以管理目标本身及其逻辑单元。支持的iSCSI目标实现使用 `targetcli-fb` ，因此，请确保使用 `lio-t` 作为实现类型。考虑到已经有iSCSI目标，可以使用以下命令配置 `iSCSILogicalUnit` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME ocf:heartbeat:iSCSILogicalUnit \
          implementation=lio-t \
          target_iqn=$IQN_TARGET \
          path=$DEVICE \
          lun=$LUN
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME ocf:heartbeat:iSCSILogicalUnit \
          implementation=lio-t \
          target_iqn=$IQN_TARGET \
          path=$DEVICE \
          lun=$LUN
```

Where implementation is set to `lio-t` as mentioned before, `$IQN_TARGET` is the iSCSI Qualified Name (IQN) that this Logical Unit belongs to, `$DEVICE` is the path to the exposed block device, and `$LUN` is the number representing the Logical Unit which will be exposed to initiators.
如前所述，如果将implementation设置为 `lio-t` ，则 `$IQN_TARGET` 是此逻辑单元所属的iSCSI限定名称（IQN）， `$DEVICE` 是指向已公开数据块设备的路径， `$LUN` 是表示将向启动器公开的逻辑单元的编号。

This is one way to set up `iSCSILogicalUnit`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/man7/ocf_heartbeat_iSCSILogicalUnit.7.html).
这是设置 `iSCSILogicalUnit` 的一种方法，有关更多信息，请参阅其手册页。

## iSCSITarget iSCSI目标 

From its manpage: 从它的manpage： 

> Manages iSCSI targets. An iSCSI target is a collection of SCSI Logical Units  (LUs) exported via a daemon that speaks the iSCSI protocol.
> 管理iSCSI目标。iSCSI目标是通过使用iSCSI协议的守护程序导出的SCSI逻辑单元（LU）的集合。 

This agent is usually used alongside with `iSCSILogicalUnit` to manage the target itself and its Logical Units. The supported implementation of iSCSI targets is using `targetcli-fb`, due to that, make sure to use `lio-t` as the implementation type. With `targetcli-fb` installed on the system, the `iSCSITarget` resource can be configured with the following command:
此代理通常与 `iSCSILogicalUnit` 一起使用，以管理目标本身及其逻辑单元。支持的iSCSI目标实现使用 `targetcli-fb` ，因此，请确保使用 `lio-t` 作为实现类型。在系统上安装了 `targetcli-fb` 后，可以使用以下命令配置 `iSCSITarget` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME ocf:heartbeat:iSCSITarget \
          implementation=lio-t \
          iqn=$IQN_TARGET
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME ocf:heartbeat:iSCSITarget \
          implementation=lio-t \
          iqn=$IQN_TARGET
```

Where implementation is set to `lio-t` as mentioned before and `$IQN_TARGET` is the IQN of the target.
其中，如前所述，实现设置为 `lio-t` ， `$IQN_TARGET` 是目标的IQN。

This is one way to set up `iSCSITarget`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/man7/ocf_heartbeat_iSCSITarget.7.html).
这是设置 `iSCSITarget` 的一种方法，有关更多信息，请参阅其手册页。

## LVM-activate

From its manpage: 从它的manpage： 

> This agent manages LVM activation/deactivation work for a given volume group.
> 此代理管理给定卷组的LVM激活/停用工作。 

If the LVM setup is ready to be activated and deactivated by this resource agent (make sure the `system_id_resource` is set to `uname` in `/etc/lvm/lvm.conf`), the `LVM-activate` resource can be configured with the following command:
如果LVM设置准备好由此资源代理激活和停用（确保 `system_id_resource` 在 `/etc/lvm/lvm.conf` 中设置为 `uname` ），则可以使用以下命令配置 `LVM-activate` 资源：

```bash
$ crm configure primitive $RESOURCE_NAME ocf:heartbeat:LVM-activate \
             vgname=$VOLUME_GROUP \
             vg_access_mode=system_id
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME ocf:heartbeat:LVM-activate \
             vgname=$VOLUME_GROUP \
             vg_access_mode=system_id
```

This is one way to set up `LVM-activate`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man7/ocf_heartbeat_LVM-activate.7.html).
这是设置 `LVM-activate` 的一种方法，有关更多信息，请参阅其手册页。

## Systemd

There is also a way to manage systemd unit files via a resource agent. One  need to have the systemd unit file in place (already loaded by systemd)  and configure a resource using the following command:
还有一种通过资源代理管理systemd单元文件的方法。您需要准备好systemd单元文件（已经由systemd加载），并使用以下命令配置资源： 

```auto
$ crm configure primitive $RESOURCE_NAME systemd:$SERVICE_NAME
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs resource create $RESOURCE_NAME systemd:$SERVICE_NAME
```

The `$SERVICE_NAME` can be any service managed by a systemd unit file, and it needs to be available for the cluster nodes.
 `$SERVICE_NAME` 可以是由systemd单元文件管理的任何服务，并且它需要可用于群集节点。

## Further reading 进一步阅读 

- [ClusterLabs website QuarterLabs网站](http://www.clusterlabs.org/)
- [The OCF resource-agent developer’s guide
   OCF资源代理开发人员指南](https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc)

------

# Pacemaker fence agents 起搏器栅栏剂 

From the ClusterLabs definition:
根据QuestionerLabs定义： 

> A **fence agent** (or **fencing agent**) is a **stonith**-class resource agent.
> 隔离代理是stonith—class资源代理。
>
> The fence agent standard provides commands (such as `off` and `reboot`) that the cluster can use to fence nodes. As with other resource agent  classes, this allows a layer of abstraction so that Pacemaker doesn’t  need any knowledge about specific fencing technologies — that knowledge  is isolated in the agent.
> 围栏代理标准提供了群集可用于围栏节点的命令（如 `off` 和 `reboot` ）。与其他资源代理类一样，这允许一个抽象层，以便Pacemaker不需要任何有关特定屏蔽技术的知识—这些知识在代理中被隔离。

Currently, the `fence-agents` binary package has been split into two: `fence-agents-base` and `fence-agents-extra`. The `fence-agents-base` binary package contains a set of curated agents which the Ubuntu Server team continuously runs tests on to make sure everything is working as  expected. All the other agents previously in the `fence-agents` binary package are now moved to the `fence-agents-extra`.
目前， `fence-agents` 二进制包已被分成两个： `fence-agents-base` 和 `fence-agents-extra` 。 `fence-agents-base` 二进制包包含一组精心策划的代理，Ubuntu Server团队不断对其进行测试，以确保一切都按预期工作。以前在 `fence-agents` 二进制包中的所有其他代理现在都移动到 `fence-agents-extra` 。

The `fence-agents-base` binary package contains the following agents in the latest Ubuntu release:
在最新的Ubuntu版本中， `fence-agents-base` 二进制包包含以下代理：

- ```
  fence_ipmilan
  ```

  - `fence_idrac`
  - `fence_ilo3`
  - `fence_ilo4`
  - `fence_ilo5`
  - `fence_imm`
  - `fence_ipmilanplus`

- `fence_mpath`

- `fence_sbd`

- `fence_scsi`

- `fence_virsh`

All of these agents are in `main` and are fully supported. All other agents, in `fence-agents-extra`, are supported by upstream but are not curated by the Ubuntu Server team.
所有这些代理都在 `main` 中，并且完全受支持。 `fence-agents-extra` 中的所有其他代理都由上游支持，但不由Ubuntu Server团队管理。

For the fence agents provided by `fence-agents-base`, we will briefly describe how to use them.
对于 `fence-agents-base` 提供的围栏代理，我们将简要介绍如何使用它们。

> **Note**: 注意：
>  There are two well known tools used to manage fence agents, they are `crmsh` and `pcs`. Here we present examples with both, since `crmsh` is the recommended and supported tool until Ubuntu 22.10 Kinetic Kudu, and `pcs` is the recommended and supported tool from Ubuntu 23.04 Lunar Lobster onwards. For more information on how to migrate from `crmsh` to `pcs` [refer to our migration guide](https://ubuntu.com/server/docs/migrate-from-crmsh-to-pcs).
>  有两个众所周知的工具用于管理围栏代理，它们是 `crmsh` 和 `pcs` 。在这里，我们展示了这两个例子，因为 `crmsh` 是Ubuntu 22.10 Kinetic Kudu之前推荐和支持的工具，而 `pcs` 是Ubuntu 23.04 Lunar Lobster之后推荐和支持的工具。有关如何从 `crmsh` 迁移到 `pcs` 的更多信息，请参阅我们的迁移指南。

## fence_ipmilan

The content of this section is also applicable to the following fence agents: `fence_idrac`, `fence_ilo3`, `fence_ilo4`, `fence_ilo5`, `fence_imm`, and `fence_ipmilanplus`. All of them are symlinks to `fence_ipmilan`.
本节的内容也适用于以下围栏代理： `fence_idrac` 、 `fence_ilo3` 、 `fence_ilo4` 、 `fence_ilo5` 、 `fence_imm` 和 `fence_ipmilanplus` 。所有这些都是符号链接到 `fence_ipmilan` 。

From its manpage: 从它的manpage： 

> fence_ipmilan is an I/O Fencing agent which can be used with machines controlled by IPMI. This agent calls support software `ipmitool`. WARNING! This fence agent might report success before the node is powered off. You should use `-m/method onoff` if your fence device works correctly with that option.
> fence_ipmilan是一个I/O Fencing代理，可用于由IPMI控制的机器。此代理调用支持软件 `ipmitool` 。警告！警告！此栅栏代理可能会在节点关闭之前报告成功。如果您的围栏设备使用该选项可以正常工作，则应使用 `-m/method onoff` 。

In a system which supports IPMI and with `ipmitool` installed, a `fence_ipmilan` resource can be configured with the following command:
在支持IPMI并安装了 `ipmitool` 的系统中，可以使用以下命令配置 `fence_ipmilan` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME stonith:fence_ipmilan \
            ip=$IP \
            ipport=$PORT \
            username=$USER \
            password=$PASSWD \
            lanplus=1 \
            action=$ACTION
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs stonith create $RESOURCE_NAME fence_ipmilan \
            ip=$IP \
            ipport=$PORT \
            username=$USER \
            password=$PASSWD \
            lanplus=1 \
            action=$ACTION
```

Where `$IP` is the IP address or hostname of fencing device, `$PORT` is the TCP/UDP port to use for connection, `$USER` is the login name and `$PASSWD` its password, and `$ACTION` is the fencing actions which by default is `reboot`.
其中 `$IP` 是屏蔽设备的IP地址或主机名， `$PORT` 是用于连接的TCP/UDP端口， `$USER` 是登录名， `$PASSWD` 是其密码， `$ACTION` 是屏蔽操作，默认情况下为 `reboot` 。

This is one way to set up `fence_ipmilan`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man8/fence_ipmilan.8.html).
这是设置 `fence_ipmilan` 的一种方法，有关更多信息，请参阅其手册页。

## fence_mpath 栅栏路径 

From its manpage: 从它的manpage： 

> `fence_mpath` is an I/O fencing agent that uses SCSI-3 persistent reservations to  control access multipath devices. Underlying devices must support SCSI-3 persistent reservations (SPC-3 or greater) as well as the  “preempt-and-abort” subcommand. The `fence_mpath` agent works by having a unique key for each node that has to be set in `/etc/multipath.conf`. Once registered, a single node will become the reservation holder by  creating a “write exclusive, registrants only” reservation on the  device(s). The result is that only registered nodes may write to the  device(s). When a node failure occurs, the fence_mpath agent will remove the key belonging to the failed node from the device(s). The failed  node will no longer be able to write to the device(s). A manual reboot  is required.
>  `fence_mpath` 是一个I/O屏蔽代理，它使用SCSI-3持久保留来控制访问多路径设备。底层设备必须支持SCSI-3持久保留（SPC-3或更高版本）以及“preempt-and-abort”子命令。 `fence_mpath` 代理的工作原理是为每个节点设置一个唯一的密钥，该密钥必须在 `/etc/multipath.conf` 中设置。一旦注册，单个节点将通过在设备上创建“写独占、仅注册者”预留而成为预留保持器。结果是只有注册的节点可以写入设备。当节点发生故障时，fence_mpath代理将从设备中删除属于故障节点的密钥。发生故障的节点将无法再写入设备。需要手动重新启动。

One can configure a `fence_mpath` resource with the following command:
可以使用以下命令配置 `fence_mpath` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME stonith:fence_mpath \
            pcmk_host_map="$NODE1:$NODE1_RES_KEY;$NODE2:$NODE2_RES_KEY;$NODE3:$NODE3_RES_KEY" \
            pcmk_host_argument=key \
            pcmk_monitor_action=metadata \
            pcmk_reboot_action=off \
            devices=$MPATH_DEVICE \
            meta provides=unfencing
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs stonith create $RESOURCE_NAME fence_mpath \
            pcmk_host_map="$NODE1:$NODE1_RES_KEY;$NODE2:$NODE2_RES_KEY;$NODE3:$NODE3_RES_KEY" \
            pcmk_host_argument=key \
            pcmk_monitor_action=metadata \
            pcmk_reboot_action=off \
            devices=$MPATH_DEVICE \
            meta provides=unfencing
```

The `$NODE1_RES_KEY` is the reservation key used by this node 1 (same for the others node  with access to the multipath device), please make sure you have `reservation_key <key>` in the `default` section inside `/etc/multipath.conf` and the multipathd service was reloaded after it.
 `$NODE1_RES_KEY` 是此节点1使用的保留密钥（与访问多路径设备的其他节点相同），请确保您在 `/etc/multipath.conf` 内的 `default` 部分中具有 `reservation_key <key>` ，并且在此之后重新加载了multipathd服务。

This is one way to set up `fence_mpath`, for more information please check its manpage.
这是设置 `fence_mpath` 的一种方法，有关更多信息，请查看其手册页。

## fence_sbd 围栏_sbd 

From its manpage: 从它的manpage： 

> fence_sbd is I/O Fencing agent which can be used in environments where SBD can be used (shared storage).
> fence_sbd是I/O隔离代理，可用于可以使用SBD的环境（共享存储）。 

With STONITH Block Device (SBD) configured on a system, the `fence_sbd` resource can be configured with the following command:
在系统上配置STONITH Block Device（SBD）后，可以使用以下命令配置 `fence_sbd` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME stonith:fence_sbd devices=$DEVICE
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs stonith create $RESOURCE_NAME fence_sbd devices=$DEVICE
```

This is one way to set up `fence_sbd`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man8/fence_sbd.8.html).
这是设置 `fence_sbd` 的一种方法，有关更多信息，请参阅其手册页。

## fence_scsi 栅栏_scsi 

From its manpage: 从它的manpage： 

> `fence_scsi` is an I/O fencing agent that uses SCSI-3 persistent reservations to  control access to shared storage devices. These devices must support  SCSI-3 persistent reservations (SPC-3 or greater) as well as the  “preempt-and-abort” subcommand. The `fence_scsi` agent works by having each node in the cluster register a unique key  with the SCSI device(s). Reservation key is generated from “node id”  (default) or from “node name hash” (RECOMMENDED) by adjusting  “key_value” option. Using hash is recommended to prevent issues when  removing nodes from cluster without full cluster restart. Once  registered, a single node will become the reservation holder by creating a “write exclusive, registrants only” reservation on the device(s). The result is that only registered nodes may write to the device(s). When a node failure occurs, the `fence_scsi` agent will remove the key belonging to the failed node from the  device(s). The failed node will no longer be able to write to the  device(s). A manual reboot is required.
>  `fence_scsi` 是一个I/O屏蔽代理，它使用SCSI-3持久保留来控制对共享存储设备的访问。这些设备必须支持SCSI-3持久保留（SPC-3或更高版本）以及“preempt-and-abort”子命令。 `fence_scsi`  代理的工作方式是让群集中的每个节点向SCSI设备注册一个唯一的密钥。保留键是从“节点id”（默认）或从“节点名称哈希”（推荐）通过调整“key_value”选项生成的。建议使用哈希来防止在没有完全重新启动群集的情况下从群集中删除节点时出现问题。一旦注册，单个节点将通过在设备上创建“写独占、仅注册者”预留而成为预留保持器。结果是只有注册的节点可以写入设备。当发生节点故障时， `fence_scsi` 代理将从设备中删除属于故障节点的密钥。发生故障的节点将无法再写入设备。需要手动重新启动。

A `fence_scsi` resource can be configured with the following command:
可以使用以下命令配置 `fence_scsi` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME stonith:fence_scsi \
            pcmk_host_list="$NODE1 $NODE2 $NODE3" \
            devices=$SCSI_DEVICE \
            meta provides=unfencing
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs stonith create $RESOURCE_NAME fence_scsi \
            pcmk_host_list="$NODE1 $NODE2 $NODE3" \
            devices=$SCSI_DEVICE \
            meta provides=unfencing
```

The `pcmk_host_list` parameter contains a list of cluster nodes that can access the managed SCSI device.
 `pcmk_host_list` 参数包含可以访问托管SCSI设备的群集节点列表。

This is one way to set up `fence_scsi`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man8/fence_scsi.8.html).
这是设置 `fence_scsi` 的一种方法，有关更多信息，请参阅其手册页。

## fence_virsh 栅栏_virsh 

From its manpage: 从它的manpage： 

> `fence_virsh` is an I/O Fencing agent which can be used with the virtual machines  managed by libvirt. It logs via ssh to a dom0 and there run virsh  command, which does all work. By default, virsh needs root account to do properly work. So you must allow ssh login in your sshd_config.
>  `fence_virsh` 是一个I/O Fencing代理，可用于libvirt管理的虚拟机。它通过ssh登录到dom 0，并在那里运行virsh命令，该命令完成所有工作。默认情况下，virsh需要root帐户才能正常工作。所以你必须在sshd_config中允许ssh登录。

A `fence_virsh` resource can be configured with the following command:
可以使用以下命令配置 `fence_virsh` 资源：

```auto
$ crm configure primitive $RESOURCE_NAME stonith:fence_virsh \
            ip=$HOST_IP_ADDRESS \
            login=$HOST_USER \
            identity_file=$SSH_KEY \
            plug=$NODE \
            ssh=true \
            use_sudo=true
```

One can do the same using `pcs` via the following command:
可以通过以下命令使用 `pcs` 执行相同的操作：

```auto
$ pcs stonith create $RESOURCE_NAME fence_virsh \
            ip=$HOST_IP_ADDRESS \
            login=$HOST_USER \
            identity_file=$SSH_KEY \
            plug=$NODE \
            ssh=true \
            use_sudo=true
```

This is one way to set up `fence_virsh`, for more information [refer to its manpage](https://manpages.ubuntu.com/manpages/en/man8/fence_virsh.8.html).
这是设置 `fence_virsh` 的一种方法，有关更多信息，请参阅其手册页。

In order to avoid running the resource in the same node that should be fenced, we need to add a location restriction:
为了避免在同一个应该被隔离的节点上运行资源，我们需要添加一个位置限制： 

```auto
$ crm configure location fence-$NODE-location $RESOURCE_NAME -inf: $NODE
```

Using `pcs`: 使用 `pcs` ：

```auto
$ pcs constraint location $RESOURCE_NAME avoids $NODE
```

## Further reading 进一步阅读 

- [ClusterLabs website QuarterLabs网站](https://clusterlabs.org/)
- [Fence agents API documentation
   栅栏代理API文档](https://github.com/ClusterLabs/fence-agents/blob/master/doc/FenceAgentAPI.md)

# Configuring device mapper multipathing 配置设备映射程序多路径 

It is recommended that you first read the [device mapper multipathing introduction](https://ubuntu.com/server/docs/introduction-to-device-mapper-multipathing) if you are unfamiliar with the concepts and terms. For consistency, we refer to device mapper multipathing as **multipath**.
如果您不熟悉设备映射程序多路径的概念和术语，建议您先阅读这些内容。为了保持一致性，我们将设备映射器多路径称为多路径。

Multipath usually works out-of-the-box with most common storages. This doesn’t  mean the default configuration variables should be used in production:  they don’t treat important parameters your storage might need.
多路径通常与大多数常见的存储一起开箱即用。这并不意味着默认配置变量应该在生产中使用：它们不处理存储可能需要的重要参数。 

It’s a good idea to consult your storage manufacturer’s install guide for  the Linux Multipath configuration options. Storage vendors often provide the most adequate options for Linux, including minimal versions  required for kernel and multipath-tools.
最好查阅存储制造商的安装指南以了解Linux多路径配置选项。存储供应商通常为Linux提供最合适的选项，包括内核和多路径工具所需的最低版本。 

Default multipath configuration values can be overridden by editing the `/etc/multipath.conf` file and restarting the `multipathd` service. This page provides information on parsing and modifying the `multipath.conf` file.
可以通过编辑 `/etc/multipath.conf` 文件并重新启动 `multipathd` 服务来覆盖默认的多路径配置值。本页提供有关解析和修改 `multipath.conf` 文件的信息。

## Configuration file overview 配置文件概述 

The `multipath.conf` configuration file contains entries of the form:
 `multipath.conf` 配置文件包含以下格式的条目：

```auto
<section> {
       <attribute> <value>
       ...
       <subsection> {
              <attribute> <value>
              ...
       }
}
```

The following keywords are recognised:
识别以下关键字： 

- **`defaults`**: Defines default values for attributes used whenever no values are given in the appropriate device or multipath sections.
   `defaults` ：定义当在适当的设备或多路径部分中没有给出值时使用的属性的默认值。
- **`blacklist`**: Defines which devices should be excluded from the multipath topology discovery.
   `blacklist` ：定义应从多路径拓扑发现中排除哪些设备。
- **`blacklist_exceptions`**: Defines which devices should be included in the multipath topology discovery, despite being listed in the blacklist section.
   `blacklist_exceptions` ：定义哪些设备应包括在多路径拓扑发现中，尽管它们已列在黑名单部分中。
- **`multipaths`**: Defines the multipath topologies. They are indexed by a World Wide  Identifier (WWID). Attributes set in this section take precedence **over all others**.
   `multipaths` ：定义多路径拓扑。它们由万维网标识符（WWID）索引。本节中设置的属性优先于所有其他属性。
- **`devices`**: Defines the device-specific settings. Devices are identified by vendor, product, and revision.
   `devices` ：定义特定于设备的设置。器械按供应商、产品和版本识别。
- **`overrides`**: This section defines values for attributes that should override the device-specific settings for all devices.
   `overrides` ：此部分定义应覆盖所有设备的设备特定设置的属性值。

## Configuration file defaults 配置文件默认值 

Currently, the multipath configuration file ONLY includes a minor `defaults` section that sets the `user_friendly_names` parameter to ‘yes’:
当前，多路径配置文件仅包含一个次要的 `defaults` 部分，用于将 `user_friendly_names` 参数设置为“yes”：

```plaintext
defaults {
    user_friendly_names yes
}
```

This overwrites the default value of the `user_friendly_names` parameter.
这将覆盖 `user_friendly_names` 参数的默认值。

All the multipath attributes that can be set in the `defaults` section of the `multipath.conf` file can be found [in the man pages](https://manpages.ubuntu.com/manpages/en/man5/multipath.conf.5.html#defaults section) with an explanation of what they mean. The attributes are:
可以在手册页中找到可以在 `multipath.conf` 文件的 `defaults` 部分中设置的所有多路径属性，并解释了它们的含义。这些属性是：

- `verbosity`
- `polling_interval`
- `max_polling_interval`
- `reassign_maps`
- `multipath_dir`
- `path_selector`
- `path_grouping_policy`
- `uid_attrs`
- `uid_attribute`
- `getuid_callout`
- `prio`
- `prio_args`
- `features`
- `path_checker`
- `alias_prefix`
- `failback`
- `rr_min_io`
- `rr_min_io_rq`
- `max_fds`
- `rr_weight`
- `no_path_retry`
- `queue_without_daemon`
- `checker_timeout`
- `flush_on_last_del`
- `user_friendly_names`
- `fast_io_fail_tmo`
- `dev_loss_tmo`
- `bindings_file`
- `wwids_file`
- `prkeys_file`
- `log_checker_err`
- `reservation_key`
- `all_tg_pt`
- `retain_attached_hw_handler`
- `detect_prio`
- `detect_checker`
- `force_sync`
- `strict_timing`
- `deferred_remove`
- `partition_delimiter`
- `config_dir`
- `san_path_err_threshold`
- `san_path_err_forget_rate`
- `san_path_err_recovery_time`
- `marginal_path_double_failed_time`
- `marginal_path_err_sample_time`
- `marginal_path_err_rate_threshold`
- `marginal_path_err_recheck_gap_time`
- `delay_watch_checks`
- `delay_wait_checks`
- `marginal_pathgroups`
- `find_multipaths`
- `find_multipaths_timeout`
- `uxsock_timeout`
- `retrigger_tries`
- `retrigger_delay`
- `missing_uev_wait_timeout`
- `skip_kpartx`
- `disable_changed_wwids`
- `remove_retries`
- `max_sectors_kb`
- `ghost_delay`
- `enable_foreign`

> **Note**: 注意：
>  Previously, the `multipath-tools` project provided a complete configuration file with all the most  commonly used options for each of the most-used storage devices.  Currently, you can see all those default options by running `sudo multipath -t`. This will dump a used configuration file including all the embedded default options.
>  以前， `multipath-tools` 项目提供了一个完整的配置文件，其中包含每个最常用存储设备的所有最常用选项。目前，您可以通过运行 `sudo multipath -t` 来查看所有这些默认选项。这将转储包含所有嵌入默认选项的已使用配置文件。

## Configuration file blacklist and exceptions 配置文件黑名单和异常 

The blacklist section is used to exclude specific devices from the  multipath topology. It is most commonly used to exclude local disks,  non-multipathed devices, or non-disk devices.
黑名单部分用于从多路径拓扑中排除特定设备。它最常用于排除本地磁盘、非多路径设备或非磁盘设备。 

### By `devnode` 通过 `devnode` 

The default blacklist consists of the regular expressions `"^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]"` and `"^(td|hd|vd)[a-z]"`. This causes virtual devices, non-disk devices, and some other device types to be excluded from multipath handling by default.
默认黑名单由正则表达式 `"^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]"` 和 `"^(td|hd|vd)[a-z]"` 组成。这会导致虚拟设备、非磁盘设备和其他一些设备类型默认情况下被排除在多路径处理之外。

```plaintext
blacklist {
    devnode "^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]"
    devnode "^(td|hd|vd)[a-z]"
    devnode "^cciss!c[0-9]d[0-9]*"
}
```

### By `wwid` 通过 `wwid` 

Regular expression for the World Wide Identifier of a device to be excluded/included
要排除/包含的设备的全球通用标识符的正则表达式 

### By device 由设备 

Subsection for the device description. This subsection recognises the `vendor` and `product` keywords. Both are regular expressions.
设备描述的子部分。本小节识别 `vendor` 和 `product` 关键字。两者都是正则表达式。

```plaintext
device {
    vendor "LENOVO"
    product "Universal Xport"
}
```

### By property 购物车旗下物业旗下 

Regular expression for an udev property. All devices that have matching udev  properties will be excluded/included. The handling of the property  keyword is special, because devices must have at least one whitelisted  udev property; otherwise they’re treated as blacklisted, and the message “blacklisted, udev property missing” is displayed in the logs.
udev属性的正则表达式。将排除/包括具有匹配udev属性的所有设备。对property关键字的处理是特殊的，因为设备必须至少有一个列入白名单的udev属性;否则它们将被视为列入黑名单，并在日志中显示消息“blacklisted，udev property missing”。 

### Blacklist by protocol 按协议列出黑名单 

The protocol strings that multipath recognises are `scsi:fcp`, `scsi:spi`, `scsi:ssa`, `scsi:sbp`, `scsi:srp`, `scsi:iscsi`, `scsi:sas`, `scsi:adt`, `scsi:ata`, `scsi:unspec`, `ccw`, `cciss`, `nvme`, and `undef`. The protocol that a path is using can be viewed by running:
多路径识别的协议字符串为 `scsi:fcp` 、 `scsi:spi` 、 `scsi:ssa` 、 `scsi:sbp` 、 `scsi:srp` 、 `scsi:iscsi` 、 `scsi:sas` 、 `scsi:adt` 、 `scsi:ata` 、 `scsi:unspec` 、 `ccw` 、 `cciss` 、 `nvme` 和 `undef` 。可以通过运行以下命令查看路径正在使用的协议：

```bash
multipathd show paths format "%d %P"
```

### Blacklist exceptions 黑名单例外 

The `blacklist_exceptions` section is used to revert the actions of the blacklist section. This  allows one to selectively include (“whitelist”) devices which would  normally be excluded via the blacklist section.
 `blacklist_exceptions` 部分用于恢复黑名单部分的操作。这允许选择性地包括（“白名单”）通常经由黑名单部分被排除的设备。

```plaintext
blacklist_exceptions {
    property "(SCSI_IDENT_|ID_WWN)"
}
```

> **Note**: 注意：
>  A common use is to blacklist “everything” using a catch-all regular expression, and create specific `blacklist_exceptions` entries for those devices that should be handled by `multipath-tools`.
>  一个常见的用法是使用一个catch-all正则表达式将“所有内容”列入黑名单，并为那些应该由 `multipath-tools` 处理的设备创建特定的 `blacklist_exceptions` 条目。

## Configuration file multipath section 配置文件多路径节 

The `multipaths` section allows setting attributes of **multipath maps**. The attributes set via the multipaths section (see list below) take  precedence over all other configuration settings, including those from  the overrides section.
 `multipaths` 部分允许设置多路径映射的属性。通过多路径部分设置的属性（参见下面的列表）优先于所有其他配置设置，包括来自覆盖部分的设置。

The only recognised attribute for the multipaths section is the multipath  subsection. If there is more than one multipath subsection matching a  given WWID, the contents of these sections are merged, and settings from later entries take precedence.
多路径部分的唯一公认属性是多路径子部分。如果有多个多路径子部分与给定的WWID匹配，则合并这些部分的内容，后面条目的设置优先。 

The multipath subsection recognises the following attributes:
多路径子部分识别以下属性： 

- `wwid`: (Mandatory) World Wide Identifier. Detected multipath maps are matched against this attribute. Note that, unlike the `wwid` attribute in the blacklist section, this is not a regular expression or a substring; WWIDs must match exactly inside the multipaths section.
   `wwid` ：（必填）全球通用标识符。检测到的多路径映射与此属性匹配。请注意，与blacklist部分中的 `wwid` 属性不同，这不是正则表达式或子字符串; WWID必须在multipaths部分中完全匹配。
- `alias`: Symbolic name for the multipath map. This takes precedence over an entry for the same WWID in the `bindings_file`.
   `alias` ：多路径映射的符号名称。这优先于 `bindings_file` 中相同WWID的条目。

### Optional attributes 可选属性 

The following attributes are optional; if not set, the default values are taken from the overrides, devices, or [defaults section](https://manpages.ubuntu.com/manpages/en/man5/multipath.conf.5.html#defaults section):
以下属性是可选的;如果未设置，则默认值取自覆盖、设备或默认值部分：

- `path_grouping_policy`
- `path_selector`
- `prio`
- `prio_args`
- `failback`
- `rr_weight`
- `no_path_retry`
- `rr_min_io`
- `rr_min_io_rq`
- `flush_on_last_del`
- `features`
- `reservation_key`
- `user_friendly_names`
- `deferred_remove`
- `san_path_err_threshold`
- `san_path_err_forget_rate`
- `san_path_err_recovery_time`
- `marginal_path_err_sample_time`
- `marginal_path_err_rate_threshold`
- `marginal_path_err_recheck_gap_time`
- `marginal_path_double_failed_time`
- `delay_watch_checks`
- `delay_wait_checks`
- `skip_kpartx`
- `max_sectors_kb`
- `ghost_delay`

### Example 例如 

```plaintext
multipaths {
    multipath {
        wwid                    3600508b4000156d700012000000b0000
        alias                   yellow
        path_grouping_policy    multibus
        path_selector           "round-robin 0"
        failback                manual
        rr_weight               priorities
        no_path_retry           5
    }
    multipath {
        wwid                    1DEC_____321816758474
        alias                   red
    }
}
```

## Configuration file devices section 配置文件设备部分 

`multipath-tools` has a built-in **device table** with reasonable defaults for more than 100 known multipath-capable storage devices. The `devices` section can be used to override these settings. If there are multiple  matches for a given device, the attributes of all matching entries are  applied to it. If an attribute is specified in several matching device  subsections, later entries take precedence.
 `multipath-tools` 有一个内置的设备表，为100多个已知的支持多路径的存储设备提供了合理的默认值。 `devices` 部分可用于覆盖这些设置。如果给定设备有多个匹配项，则所有匹配项的属性都将应用于该设备。如果在多个匹配设备子部分中指定了一个属性，则后面的条目优先。

The only recognised attribute for the `devices` section is the `device` subsection. Devices detected in the system are matched against the  device entries using the vendor, product, and revision fields.
 `devices` 部分的唯一可识别属性是 `device` 子部分。系统中检测到的设备将与使用供应商、产品和版本字段的设备条目进行匹配。

The vendor, product, and revision fields that multipath or `multipathd` detect for devices in a system depend on the device type. For SCSI  devices, they correspond to the respective fields of the “SCSI INQUIRY”  page. In general, the command `multipathd show paths format "%d %s"` command can be used to see the detected properties for all devices in the system.
多路径或 `multipathd` 为系统中的设备检测的供应商、产品和版本字段取决于设备类型。对于SCSI设备，它们对应于“SCSI查询”页面的各个字段。通常，命令 `multipathd show paths format "%d %s"` 命令可用于查看系统中所有设备的检测属性。

The device subsection recognises the following attributes:
器械小节确认以下属性： 

1. **`vendor`**: (Mandatory) Regular expression to match the vendor name.
    `vendor` ：（必选）匹配供应商名称的正则表达式。

2. **`product`**: (Mandatory) Regular expression to match the product name.
    `product` ：（必选）正则表达式匹配产品名称。

3. **`revision`**: Regular expression to match the product revision.
    `revision` ：匹配产品版本的正则表达式。

4. **`product_blacklist`**: Products with the given vendor matching this string are blacklisted.
    `product_blacklist` ：给定供应商与此字符串匹配的产品被列入黑名单。

5. **`alias_prefix`**: The `user_friendly_names` prefix to use for this device type, instead of the default `mpath`.
    `alias_prefix` ：用于此设备类型的 `user_friendly_names` 前缀，而不是默认的 `mpath` 。

6. `hardware_handler`

   : The hardware handler to use for this device type. The following  hardware handlers are implemented (all of these are hardware-dependent):

   
    `hardware_handler` ：用于此设备类型的硬件处理程序。实现了以下硬件处理程序（所有这些都依赖于硬件）： 

   - **`1 emc`**: Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX and Unity families.
      `1 emc` ：DGC类阵列（如CLARiiON CX/AX和EMC VNX以及Unity系列）的硬件处理程序。
   - **`1 rdac`**: Hardware handler for LSI / Engenio / NetApp RDAC class as NetApp  SANtricity E/EF Series, and OEM arrays from IBM DELL SGI STK and SUN.
      `1 rdac` ：用于LSI / Engenio /PSDAC类的硬件处理程序，如PSDSANtricity E/EF系列，以及来自IBM DELL SGI STK和SUN的OEM阵列。
   - **`1 hp_sw`**: Hardware handler for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with Active/Standby mode exclusively.
      `1 hp_sw` ：HP/COMPAQ/DEC HSG 80和MSA/HSV阵列的硬件处理程序，仅支持主/备用模式。
   - **`1 alua`**: Hardware handler for SCSI-3 ALUA-compatible arrays.
      `1 alua` ：SCSI-3 SATA兼容阵列的硬件处理程序。
   - **`1 ana`**: Hardware handler for NVMe ANA-compatible arrays.
      `1 ana` ：NVMe ANA兼容阵列的硬件处理程序。

### Optional attributes 可选属性 

The following attributes are optional – if not set, the default values are taken from the defaults section:
以下属性是可选的-如果未设置，则默认值取自defaults部分： 

- `path_grouping_policy`
- `uid_attribute`
- `getuid_callout`
- `path_selector`
- `path_checker`
- `prio`
- `prio_args`
- `features`
- `failback`
- `rr_weight`
- `no_path_retry`
- `rr_min_io`
- `rr_min_io_rq`
- `fast_io_fail_tmo`
- `dev_loss_tmo`
- `flush_on_last_del`
- `user_friendly_names`
- `retain_attached_hw_handler`
- `detect_prio`
- `detect_checker`
- `deferred_remove`
- `san_path_err_threshold`
- `san_path_err_forget_rate`
- `san_path_err_recovery_time`
- `marginal_path_err_sample_time`
- `marginal_path_err_rate_threshold`
- `marginal_path_err_recheck_gap_time`
- `marginal_path_double_failed_time`
- `delay_watch_checks`
- `delay_wait_checks`
- `skip_kpartx`
- `max_sectors_kb`
- `ghost_delay`
- `all_tg_pt`

### Example 例如 

```plaintext
devices {
    device {
        vendor "3PARdata"
        product "VV"
        path_grouping_policy "group_by_prio"
        hardware_handler "1 alua"
        prio "alua"
        failback "immediate"
        no_path_retry 18
        fast_io_fail_tmo 10
        dev_loss_tmo "infinity"
    }
    device {
        vendor "DEC"
        product "HSG80"
        path_grouping_policy "group_by_prio"
        path_checker "hp_sw"
        hardware_handler "1 hp_sw"
        prio "hp_sw"
        no_path_retry "queue"
    }
}
```

# Multipath configuration examples 多路径配置示例 

Before moving on with this section we suggesting reading or being familiar with the topics covered in:
在继续本节之前，我们建议您阅读或熟悉以下内容所涵盖的主题： 

1. [Introduction to device mapper multipathing
    设备映射程序多路径简介](https://ubuntu.com/server/docs/introduction-to-device-mapper-multipathing)
2. [Configuration options and overview
    配置选项和概述](https://ubuntu.com/server/docs/configuring-device-mapper-multipathing)

For consistency with those sections, we will refer here to device mapper multipathing as **multipath**.
为了与这些部分保持一致，我们在这里将设备映射器多路径称为多路径。

## Basic setup 基本设置 

Before setting up multipath on your system, ensure that your system has been updated and includes the `multipath-tools` package. If you want to boot from the storage area network (SAN), then the `multipath-tools-boot` package is also required.
在您的系统上设置多路径之前，请确保您的系统已更新并包含 `multipath-tools` 软件包。如果您希望从存储区域网络（SAN）进行靴子，则还需要 `multipath-tools-boot` 软件包。

A very simple `/etc/multipath.conf` file exists, as explained in [the configuration overview](https://ubuntu.com/server/docs/configuring-device-mapper-multipathing). All attributes not declared in `multipath.conf` are taken from the `multipath-tools` internal database and its internal blacklist.
存在一个非常简单的 `/etc/multipath.conf` 文件，如配置概述中所述。所有未在 `multipath.conf` 中声明的属性都取自 `multipath-tools` 内部数据库及其内部黑名单。

The **internal attributes** database can be acquired by running the following on the command line:
可以通过在命令行上运行以下命令来获取内部属性数据库：

```bash
sudo multipath -t
```

Multipath usually works out-of-the-box with most common storages. This **does not mean** the default configuration variables should be used in production: the  default variables don’t treat important parameters your storage might  need.
多路径通常与大多数常见的存储一起开箱即用。这并不意味着默认配置变量应该在生产中使用：默认变量不处理存储可能需要的重要参数。

With the internal attributes (described above), and the example below, you will likely be able to create your `/etc/multipath.conf` file by squashing the code blocks below. Make sure to read the `defaults` section attribute comments and make any changes based on what your environment needs.
使用内部属性（如上所述）和下面的示例，您可能能够通过压缩下面的代码块来创建 `/etc/multipath.conf` 文件。请确保阅读 `defaults` 部分属性注释，并根据您的环境需要进行任何更改。

### Example of a defaults section 默认部分的示例 

```auto
defaults {
    #
    # name    : polling_interval
    # scope   : multipathd
    # desc    : interval between two path checks in seconds. For
    #           properly functioning paths, the interval between checks
    #           will gradually increase to (4 * polling_interval).
    # values  : n > 0
    # default : 5
    #
    polling_interval 10
    
    #
    # name    : path_selector
    # scope   : multipath & multipathd
    # desc    : the default path selector algorithm to use
    #           these algorithms are offered by the kernel multipath target
    # values  : "round-robin 0"  = Loop through every path in the path group,
    #                              sending the same amount of IO to each.
    #           "queue-length 0" = Send the next bunch of IO down the path
    #                              with the least amount of outstanding IO.
    #           "service-time 0" = Choose the path for the next bunch of IO
    #                              based on the amount of outstanding IO to
    #                              the path and its relative throughput.
    # default : "service-time 0"
    #
    path_selector "round-robin 0"
    
    #
    # name    : path_grouping_policy
    # scope   : multipath & multipathd
    # desc    : the default path grouping policy to apply to unspecified
    #           multipaths
    # values  : failover           = 1 path per priority group
    #           multibus           = all valid paths in 1 priority group
    #           group_by_serial    = 1 priority group per detected serial
    #                                number
    #           group_by_prio      = 1 priority group per path priority
    #                                value
    #           group_by_node_name = 1 priority group per target node name
    # default : failover
    #
    path_grouping_policy multibus
    
    #
    # name    : uid_attribute
    # scope   : multipath & multipathd
    # desc    : the default udev attribute from which the path
    #       identifier should be generated.
    # default : ID_SERIAL
    #
    uid_attribute "ID_SERIAL"
        
    #
    # name    : getuid_callout
    # scope   : multipath & multipathd
    # desc    : the default program and args to callout to obtain a unique
    #           path identifier. This parameter is deprecated.
    #           This parameter is deprecated, superseded by uid_attribute
    # default : /lib/udev/scsi_id --whitelisted --device=/dev/%n
    #
    getuid_callout "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
        
    #
    # name    : prio
    # scope   : multipath & multipathd
    # desc    : the default function to call to obtain a path
    #           priority value. The ALUA bits in SPC-3 provide an
    #           exploitable prio value for example.
    # default : const
    #
    # prio "alua"
        
    #
    # name    : prio_args
    # scope   : multipath & multipathd
    # desc    : The arguments string passed to the prio function
    #           Most prio functions do not need arguments. The
    #       datacore prioritizer need one.
    # default : (null)
    #
    # prio_args "timeout=1000 preferredsds=foo"
        
    #
    # name    : features
    # scope   : multipath & multipathd
    # desc    : The default extra features of multipath devices.
    #           Syntax is "num[ feature_0 feature_1 ...]", where `num' is the
    #           number of features in the following (possibly empty) list of
    #           features.
    # values  : queue_if_no_path = Queue IO if no path is active; consider
    #                              using the `no_path_retry' keyword instead.
    #           no_partitions    = Disable automatic partitions generation via
    #                              kpartx.
    # default : "0"
    #
    features    "0"
    #features   "1 queue_if_no_path"
    #features   "1 no_partitions"
    #features   "2 queue_if_no_path no_partitions"
        
    #
    # name    : path_checker, checker
    # scope   : multipath & multipathd
    # desc    : the default method used to determine the paths' state
    # values  : readsector0|tur|emc_clariion|hp_sw|directio|rdac|cciss_tur
    # default : directio
    #
    path_checker directio
        
    #
    # name    : rr_min_io
    # scope   : multipath & multipathd
    # desc    : the number of IO to route to a path before switching
    #           to the next in the same path group for the bio-based
    #           multipath implementation. This parameter is used for
    #           kernels version up to 2.6.31; newer kernel version
    #           use the parameter rr_min_io_rq
    # default : 1000
    #
    rr_min_io 100
        
    #
    # name    : rr_min_io_rq
    # scope   : multipath & multipathd
    # desc    : the number of IO to route to a path before switching
    #           to the next in the same path group for the request-based
    #           multipath implementation. This parameter is used for
    #           kernels versions later than 2.6.31.
    # default : 1
    #
    rr_min_io_rq 1
        
    #
    # name    : flush_on_last_del
    # scope   : multipathd
    # desc    : If set to "yes", multipathd will disable queueing when the
    #           last path to a device has been deleted.
    # values  : yes|no
    # default : no
    #
    flush_on_last_del yes
        
    #
    # name    : max_fds
    # scope   : multipathd
    # desc    : Sets the maximum number of open file descriptors for the
    #           multipathd process.
    # values  : max|n > 0
    # default : None
    #
    max_fds 8192
        
    #
    # name    : rr_weight
    # scope   : multipath & multipathd
    # desc    : if set to priorities the multipath configurator will assign
    #           path weights as "path prio * rr_min_io"
    # values  : priorities|uniform
    # default : uniform
    #
    rr_weight priorities
        
    #
    # name    : failback
    # scope   : multipathd
    # desc    : tell the daemon to manage path group failback, or not to.
    #           0 means immediate failback, values >0 means deffered
    #           failback expressed in seconds.
    # values  : manual|immediate|n > 0
    # default : manual
    #
    failback immediate
        
    #
    # name    : no_path_retry
    # scope   : multipath & multipathd
    # desc    : tell the number of retries until disable queueing, or
    #           "fail" means immediate failure (no queueing),
    #           "queue" means never stop queueing
    # values  : queue|fail|n (>0)
    # default : (null)
    #
    no_path_retry fail
        
    #
    # name    : queue_without_daemon
    # scope   : multipathd
    # desc    : If set to "no", multipathd will disable queueing for all
    #           devices when it is shut down.
    # values  : yes|no
    # default : yes
    queue_without_daemon no
        
    #
    # name    : user_friendly_names
    # scope   : multipath & multipathd
    # desc    : If set to "yes", using the bindings file
    #           /etc/multipath/bindings to assign a persistent and
    #           unique alias to the multipath, in the form of mpath<n>.
    #           If set to "no" use the WWID as the alias. In either case
    #           this be will be overriden by any specific aliases in this
    #           file.
    # values  : yes|no
    # default : no
    user_friendly_names yes
        
    #
    # name    : mode
    # scope   : multipath & multipathd
    # desc    : The mode to use for the multipath device nodes, in octal.
    # values  : 0000 - 0777
    # default : determined by the process
    mode 0644
        
    #
    # name    : uid
    # scope   : multipath & multipathd
    # desc    : The user id to use for the multipath device nodes. You
    #           may use either the numeric or symbolic uid
    # values  : <user_id>
    # default : determined by the process
    uid 0
        
    #
    # name    : gid
    # scope   : multipath & multipathd
    # desc    : The group id to user for the multipath device nodes. You
    #           may use either the numeric or symbolic gid
    # values  : <group_id>
    # default : determined by the process
    gid disk
       
    #
    # name    : checker_timeout
    # scope   : multipath & multipathd
    # desc    : The timeout to use for path checkers and prioritizers
    #           that issue scsi commands with an explicit timeout, in
    #           seconds.
    # values  : n > 0
    # default : taken from /sys/block/sd<x>/device/timeout
    checker_timeout 60
      
    #
    # name    : fast_io_fail_tmo
    # scope   : multipath & multipathd
    # desc    : The number of seconds the scsi layer will wait after a
    #           problem has been detected on a FC remote port before failing
    #           IO to devices on that remote port.
    # values  : off | n >= 0 (smaller than dev_loss_tmo)
    # default : determined by the OS
    fast_io_fail_tmo 5
       
    #
    # name    : dev_loss_tmo
    # scope   : multipath & multipathd
    # desc    : The number of seconds the scsi layer will wait after a
    #           problem has been detected on a FC remote port before
    #           removing it from the system.
    # values  : infinity | n > 0
    # default : determined by the OS
    dev_loss_tmo 120
        
    #
    # name    : bindings_file
    # scope   : multipath
    # desc    : The location of the bindings file that is used with
    #           the user_friendly_names option.
    # values  : <full_pathname>
    # default : "/var/lib/multipath/bindings"
    # bindings_file "/etc/multipath/bindings"
     
    #
    # name    : wwids_file
    # scope   : multipath
    # desc    : The location of the wwids file multipath uses to
    #           keep track of the created multipath devices.
    # values  : <full_pathname>
    # default : "/var/lib/multipath/wwids"
    # wwids_file "/etc/multipath/wwids"
      
    #
    # name    : reservation_key
    # scope   : multipath
    # desc    : Service action reservation key used by mpathpersist.
    # values  : <key>
    # default : (null)
    # reservation_key "mpathkey"
      
    #
    # name    : force_sync
    # scope   : multipathd
    # desc    : If set to yes, multipath will run all of the checkers in
    #           sync mode, even if the checker has an async mode.
    # values  : yes|no
    # default : no
    force_sync yes
        
    #
    # name    : config_dir
    # scope   : multipath & multipathd
    # desc    : If not set to an empty string, multipath will search
    #           this directory alphabetically for files ending in ".conf"
    #           and it will read configuration information from these
    #           files, just as if it was in /etc/multipath.conf
    # values  : "" or a fully qualified pathname
    # default : "/etc/multipath/conf.d"
       
    #
    # name    : delay_watch_checks
    # scope   : multipathd
    # desc    : If set to a value greater than 0, multipathd will watch
    #           paths that have recently become valid for this many
    #           checks.  If they fail again while they are being watched,
    #           when they next become valid, they will not be used until
    #           they have stayed up for delay_wait_checks checks.
    # values  : no|<n> > 0
    # default : no
    delay_watch_checks 12
        
    #
    # name    : delay_wait_checks
    # scope   : multipathd
    # desc    : If set to a value greater than 0, when a device that has
    #           recently come back online fails again within
    #           delay_watch_checks checks, the next time it comes back
    #           online, it will marked and delayed, and not used until
    #           it has passed delay_wait_checks checks.
    # values  : no|<n> > 0
    # default : no
    delay_wait_checks 12
    }
```

### Example of a multipaths section 多路径部分的示例 

> **Note**: 注意：
>  You can obtain the WWIDs for your LUNs by running: `multipath -ll`
>  您可以通过运行以下命令获取LUN的WWID： `multipath -ll` 
>  after the service `multipath-tools.service` has been restarted.
>  服务 `multipath-tools.service` 重新启动后。

```auto
multipaths {
    multipath {
        wwid 360000000000000000e00000000030001
        alias yellow
    }
    multipath {
        wwid 360000000000000000e00000000020001
        alias blue
    }
    multipath {
        wwid 360000000000000000e00000000010001
        alias red
    }
    multipath {
        wwid 360000000000000000e00000000040001
        alias green
    }
    multipath {
        wwid 360000000000000000e00000000050001
        alias purple
    }
}
```

### Example of a devices section 设备部分示例 

```auto
# devices {
#     device {
#         vendor "IBM"
#         product "2107900"
#         path_grouping_policy group_by_serial
#     }
# }
#
```

### Example of a blacklist section 黑名单部分示例 

```auto
# name    : blacklist
# scope   : multipath & multipathd
# desc    : list of device names to discard as not multipath candidates 
#
# Devices can be identified by their device node name "devnode",
# their WWID "wwid", or their vender and product strings "device"
# default : fd, hd, md, dm, sr, scd, st, ram, raw, loop, dcssblk
#
# blacklist {
#     wwid 26353900f02796769
#     devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\*"
#     devnode "^hd[a-z]"
#     devnode "^dcssblk[0-9]\*"
#     device {
#         vendor DEC.\*
#         product MSA[15]00
#     }
# }
```

### Example of a blacklist exception section 黑名单例外部分示例 

```auto
# name    : blacklist_exceptions
# scope   : multipath & multipathd
# desc    : list of device names to be treated as multipath candidates
#           even if they are on the blacklist.
#
# Note: blacklist exceptions are only valid in the same class.
# It is not possible to blacklist devices using the devnode keyword
# and to exclude some devices of them using the wwid keyword.
# default : -
#
# blacklist_exceptions {
#        devnode "^dasd[c-d]+[0-9]\*"
#        wwid    "IBM.75000000092461.4d00.34"
#        wwid    "IBM.75000000092461.4d00.35"
#        wwid    "IBM.75000000092461.4d00.36"
# }
```

------

## Determining device mapper entries with dmsetup 使用dmsetup确定设备映射程序项 

You can use the `dmsetup` command to find out which device mapper entries match the multipathed  devices. The following command displays all the device mapper devices  and their major and minor numbers. The minor numbers determine the name  of the **dm** device. For example, a minor number of 1 corresponds to the `multipathd` device `/dev/dm-1`.
您可以使用 `dmsetup` 命令查找与多路径设备匹配的设备映射器条目。以下命令显示所有设备映射程序设备及其主设备号和次设备号。次要编号确定dm设备的名称。例如，次要编号1对应于 `multipathd` 设备 `/dev/dm-1` 。

```bash
$ sudo dmsetup ls
mpathb  (253:0)
mpatha  (253:1)

$ ls -lahd /dev/dm*
brw-rw---- 1 root disk 253, 0 Apr 27 14:49 /dev/dm-0
brw-rw---- 1 root disk 253, 1 Apr 27 14:47 /dev/dm-1
```

## Troubleshooting with the multipathd interactive console 使用multipathd交互式控制台进行故障排除 

The `multipathd -k` command is an interactive interface to the `multipathd` daemon. Running this command brings up an interactive multipath console where you can enter `help` to get a list of available commands, you can enter an interactive command, or you can enter Ctrl+D to quit.
 `multipathd -k` 命令是到 `multipathd` 守护进程的交互式接口。运行此命令将打开一个交互式多路径控制台，您可以在其中输入 `help` 以获取可用命令的列表，也可以输入交互式命令，或者输入 Ctrl + D 退出。

The `multipathd` interactive console can be used to troubleshoot problems with your  system. For example, the following command sequence displays the  multipath configuration, including the defaults, before exiting the  console.
 `multipathd` 交互式控制台可用于解决系统问题。例如，以下命令序列在退出控制台之前显示多路径配置（包括默认值）。

```bash
$ sudo multipathd -k
  > show config
  > CTRL-D
```

The following command sequence ensures that multipath has picked up any changes to the `multipath.conf`:
以下命令序列确保多路径已拾取对 `multipath.conf` 的任何更改：

```bash
$ sudo multipathd -k
> reconfigure
> CTRL-D
```

Use the following command sequence to ensure that the path checker is working properly:
使用以下命令序列确保路径检查器正常工作： 

```bash
$ sudo multipathd -k
> show paths
> CTRL-D
```

Commands can also be streamed into `multipathd` using STDIN like so:
也可以使用STDIN将命令流式传输到 `multipathd` 中，如下所示：

```bash
$ echo 'show config' | sudo multipathd -k
```

------











- #### 3、查看本机IP

```dart
 ifconfig eth0 | awk -F "[ :]+" 'NR==2 {print $3}'
```


营养吸收会少，没法运输到全身；四肢秉受的营养不足，所以四肢会无力，肌肉会消瘦，因为脾主四肢、主肌肉；另外，人的肺气就会弱，因为“脾土生肺金”，肺气的来源是脾胃之气生发的，而“肺主皮毛”，那么人体体表的这些防卫系统——皮毛功能就会弱，出现头发没有光泽、掉发、皮肤干黄等症状……

什么是胃虚

就是人受纳食物的功能有问题，比如你吃了东西马上胃就胀，也就是吃不下去了，不能消化了，呕吐、呕酸水等，这都是胃虚、胃气上逆的表现。

什么是脾胃不和

脾和胃，都是属于消化系统的，在中医看来，它们本来是相表里的(互为表里的还有肝和胆、心和小肠、肺和大肠、肾和膀胱)。

如果脾胃不和了，比如说胃强脾弱，胃亢进，胃口特别好，特别能吃，但是吃了不吸收，不能运化——脾弱了，吃了就腹泻或者吃了以后肚子越来越胀，这就是胃强脾弱。

脾胃不和就是脾胃两个不能合作了，本来一个管接受的，另一个是帮助吸收的，但是如果能接受不能吸收，不能运化，不能向全身输动，就是脾胃不和。

脾胃不和通常还指脾胃与其他脏腑之间不能协调，比如肝气不舒、情绪不好也会引起脾胃不和，严格地说，这种脾胃不和叫做肝脾不和。

还有一种情况，是脾胃和外界不合。比如说你突然到了一个地方，水土特别不服，吃了什么东西，喝了比较硬的水，之后闹肚子，这也叫脾胃不和，是脾胃跟外界不合，跟当地的环境不合。

什么是积食

积食是脾胃虚弱里边的一个类型。积食会引起脾胃虚弱，脾胃虚弱又会引起积食，它们之间是互为因果的。

积食，有的是积在胃，就是吃东西多了，导致胃堵了，比如说孩子吃鸡腿，一下吃了三个，接下来不想吃别的了，有时甚至会往上呕酸水。

那么积在脾是什么意思呢？就是当积食长期地积在胃后没有被消除，慢慢地脾就被伤掉了，会给孩子带来更严重的危害。

如果积在胃里，可能吃点山楂之类的就消掉了，没事了。但是当积在脾以后，脾的功能被伤了，这是经过一个长期过程形成的，是积食发展到后来的更严重后果。

积食到了这步，孩子总爱腹泻，或者经常大便干燥——大便前边是硬的，后边是软的，不成型，吃一点东西肚子就爱胀，严重的孩子肚子会胀得像球一样。这样的孩子看上去四肢比较消瘦，这是因为肌肉缺乏营养来源了，然后会没有力气，经常出汗、气喘等，都是因为脾功能受伤了，它运化不了食物，就全部堵在那了。

脾积是长期形成的，因为胃积一两次，是不会导致身体状况改变的，但如果脾伤了以后，孩子身体状况就会改变。

积在脾的表现可能没有积在胃那么明显，因为如果积在胃，会出现一些比较突出的症状，比如口中味道大、突然食欲不振，甚至呕吐酸水、未消化食物等。

但是，积在脾，却往往是慢性的过程，在不知不觉中，慢慢开始变得虚弱，正气不足，因为不是突然出现的，往往没有胃积那么明显，但脾积伤害孩子会更严重一些。

总的说来，脾胃虚、脾胃不和、积食对孩子身心的影响都比较大。一般来讲，在孩子身上出现的毛病，由积食引起的多，最后会导致脾胃不和、脾虚。

如果孩子脾虚，家长一定要特别予以重视，因为脾虚已经是进入一个慢性疾病的状态了，而普通的积食多是急症，只要一消，可能第二天就好了，但脾虚不会是今天补，明天就好的，它要一点一点地调养。


web服务器：Nginx  
Web程序：PHP+Node  
搜素引擎：ElasticSearch  
队列服务：Gearman  
缓存服务：Redis+Memcache  
前端构建工具:npm+bower+gulp  
PHP CLI工具：Composer+PHPUnit


Vagrant  
PHPBrew  



十大历史上最知名的反坦克武器
　　伴随着1916年第一次世界大战索姆河战场上隆隆碾过战壕的大游民坦克登上历史舞台，围绕着坦克与反坦克一直是一对螺旋上升的矛盾课题，为了针对这位“陆战之王”，一系列反坦克武器被开发出来，而坦克自身的战斗力也是与日俱增。恰逢坦克诞生一百年，那么在这个百年之交，笔者就为大家盘点一番历史上出现的那些知反坦克武器。

游民星空

反坦克枪：

　　一战中，反坦克枪是专门设计出来击穿车辆装甲的步枪，它最主要的攻击对象就是坦克。这种步枪随着坦克刚出现的时代也同时投入战场，可是随着车辆装甲愈来愈厚，直到第二次世界大战初期反坦克枪失去效用，甚至无法对中型以上的坦克构成有效威胁，反坦克枪逐渐失去了装备的意义。不过越战的出现让反坦克枪再次焕发生机，因为他们发现了新的猎物——直升机，反坦克枪也拥有了全新的名字“反器材武器”。

游民星空
芬兰L39拉赫蒂20mm反坦克步枪

Gew.98毛瑟步枪配K子弹

　　1898年，7.92毫米口径1898年式毛瑟步枪成为德国陆军制式步枪，德国陆军命名为Gewehr 98（简称：Gew.98）。英军坦克的出现让德军的各种直射火力无能为力，最初提升贯穿力的尝试是使用“反向弹头”（reversed bullet），这种方式下仍使用和一般步枪相同的弹药和弹头，只是弹头是反着装入弹壳内，并增加装药量。更进一步的发展是采用特制的穿甲弹头，例如说像德军的“K子弹”（K bullet，德军正式名称：Patrone SmK Kurz 7.92mm），它也能由一般步枪发射。K子弹有着增量的推进药，并使用铁芯弹头，在与装甲表面垂直射入的情况下，它有约30%的机率能贯穿当时坦克8mm厚的装甲，而在100米距离射击的情况下，最多能击穿12-13mm厚的装甲。

游民星空
一战是德军装备的主力Gew.98毛瑟步枪

游民星空
反向安装弹头增强穿甲能力的子弹

德国毛瑟M1918 13.2毫米反坦克步枪

　　不过K子弹毕竟是一种概率武器，当时世界各国都需要更大威力的子弹，专职反坦克武器的开发工作还是提上了日程，最简单的方法就是使用更大口径的子弹来对付坦克，毛瑟M1918 13.2毫米反坦克步枪为德意志帝国陆军于第一次世界大战中针对协约国（主要是英国）的装甲车辆所研发生产的反装甲武器，初次登场时间是1918年2月。由于毛瑟开发的13×92mm子弹宣告完成，加上当时德意志帝国陆军都采用Gew.98步枪，因此毛瑟产生将G98步枪“巨大化”的概念并进入量产。毛瑟反坦克步枪同时采用Maschinengewehr 08的两脚架作为稳定支架。随后世界各国也相继推出自己的反坦克枪，如苏联的PTRS-41（cod5中有过出场）、日本九七式反坦克步枪、Boys反坦克步枪等。

游民星空
出现在《战地1》中的德国毛瑟M1918 13.2毫米反坦克步枪与大游民坦克

巴雷特

　　前文说过，二战初期反坦克枪即被打入冷宫，但是直升机的出现让这种武器又焕发了新的生命，美国武器设计师朗尼•巴雷特看到了其中的商机，设计生产了发射12.7mm的巴雷特。这种武器可以用来狩猎、狙击、反制轻型装甲车、雷达等军事器材，故称反器材武器。需要说明的是，巴雷特其实是民用武器，只不过美国军方觉得挺好用也采购而已，但经常出现对巴雷特实际威力进行夸大的文章。巴雷特发射的是12.7mm机枪弹，这种弹药美国陆军的魂——.50口径M2重机枪也在用，的确杀伤力可观，可完全到不了“轻松击穿主战坦克”的地步（说不定豹一的车尾35mm14°装甲极近距离怼射可以哦）。

游民星空

反坦克投掷物

　　既然枪发射的子弹很难击穿坦克，同时即便击穿了也可能会出现后效不足的问题，武器设计师和前线的官兵们同时也将注意力放在了火药上，许多以爆炸和燃烧为战斗机理的武器边应运而生。

游民星空
德军士兵在投掷PWM反坦克手榴弹

反坦克手榴弹

　　最早的反坦克手榴弹诞生在德国，不过这个手榴弹是半路出家的——并不是专门研制的武器，而是用六枚将手柄拆下来的24式手榴弹的弹头绑在1枚没有拆手柄的手榴弹上，组合成集束手榴弹。不过当时的坦克装甲普遍都不厚，这玩意还能凑合着用。但随着时代的进步，坦克也在进步，用集束手榴弹来对付坦克已经渐渐显得力不从心了。再说集束手榴弹那个重量实在是太大，投掷者至少要有运动员的身板，否则光是爆炸后产生的冲击波和破片都能把投掷者给一起报销了。于是专门进行破甲的聚能装药战斗部反坦克手榴弹出现，一般使用磁性吸附在坦克表面，或者是粘性等方式进行定向爆炸，使用手榴弹中的聚能装药融化锥形铜罩来穿透装甲，例如的RPG-43手榴弹、英国No.74粘性反坦克手榴弹

游民星空
《解放2突破》中出现的RPG-43反坦克手榴弹和波波沙战斗马扎

炸药包等IED（简易爆炸装置）

　　炸药包的作战原理更是人尽皆知，许多电影都有反应，《地雷战》中也将这写简易爆炸物的作战效能描写的淋漓尽致，《集结号》更是有直接使用炸药包进行反坦克作业的演示。炸药包的杀伤机理是使用爆炸来震碎敌军坦克装甲、造成内部装备崩落，甚至可以震晕震死车组成员，乃至掀翻战车。

游民星空
被IED埋伏而击毁的M1

莫洛托夫鸡尾酒

　　在《拯救大兵瑞恩》中，大家一定对美军使用燃烧瓶报销德军雪貂自走炮印象深刻。历史上莫洛托夫鸡尾酒是土制燃烧弹的别称。莫洛托夫鸡尾酒是游击队等非正规部队、街头暴动群众的常用武器。其实最早使用土制燃烧弹作为反坦克武器的是苏联人在西班牙内战中的应用，不过后来却被芬兰人发扬光大。后来苏联在卫国战争面对着如潮水般的德国坦克时，又想到了这种可怕的武器。由于德国坦克的尾部往往是防御最少的，但恰恰是坦克发动机和油箱的所在之处。当莫诺托夫鸡尾酒在坦克的尾部燃烧时，可能令坦克的发动机过热而抛锚和油缸爆炸。当苏联士兵在近距离以燃烧弹快速突击，坦克的灵活性不足应付，于是陷入被动。这亦是莫洛托夫鸡尾酒在当时能“一战成名”的原因之一。二战东线战役中莫诺托夫鸡尾酒的使用达到顶峰，它最便宜有效的反坦克武器﹐对坦克的效能超过集束手榴弹，只要将它投入坦克脆弱的发动机排气口里，使用汽油机的德国坦克边很容易燃烧起火。后来这种便宜却易于制造的非制式武器也被战争双发大量使用，并出现在了《CS：GO》等多种游戏中，时至今日依旧活跃在冲突地区。

游民星空
《拯救大兵瑞恩》中出现的莫洛托夫鸡尾酒对黄鼠狼坦克歼击车攻击

游民星空
反坦克炮

　　当然，反坦克的话，还是得让专业的来，反坦克炮需要有初速快、弹道平直的特点，而早已发展成熟的高射炮同样具有这样的特点，于是在二战中，许多国家都推出了基于本国高射炮而衍生出的专业反坦克炮。

游民星空
中国86式100毫米滑膛炮

17磅反坦克炮

　　76.2mm的17磅反坦克炮是英国在二战设计和制造的。1940年开始设计——作为6磅反坦克炮的后继型号，1942年开始生产，1943年使用了25磅榴弹炮的炮架，并首次参战。17磅反坦克炮一般是牵引式的，当然，也大量的装备在英国坦克上作为坦克主炮使用。它是二战期间，盟军最有效的反坦克炮。当它使用脱壳穿甲弹（APDS）的时候，能对付德国最厚重的坦克装甲。17磅反坦克炮也被装在国外制造的坦克上面，比如装备在M4谢尔曼坦克上，改装成的萤火虫坦克，让英国的坦克部队有直接对抗德国坦克的能力。也是英国二战中最好的反坦克炮，曾打出波卡基村神话的米歇尔•魏特曼虎式就有被装备着17磅反坦克炮的萤火虫坦克击毁的传言。

游民星空
英国17磅反坦克炮开火瞬间

88毫米高射炮

　　作为二次世界大战中使用得最成功的火炮系统，一型非常成功的中口径高炮，但最为人津津乐道的却是它无与伦比的反坦克能力。88毫米高射炮无疑是成功的设计，在开发初期，88mm属于当时罕见的大口径，并使其赋予弹丸较高的炮口初速，这个特点为它日后成为有效的反坦克武器奠定了基础。后期德国人也以88毫米高射炮为蓝本推出了专职进行反坦克的Pak 43反坦克炮，甚至还将后续型号搬上了虎式、虎王坦克。在整个二战过程中，盟军任何型号的坦克都难以抵挡其正面进攻，巴巴罗萨行动中阻挡德军一个步兵师的KV-2坦克，便是被88炮击毁。值得说明的是，有人说88炮打坦克是是1940年五月隆美尔指挥的第七坦克师从比利时境内向敦克尔克高速挺进，中途遭遇一支英军的反冲击时炮兵们临时拍脑子的发现其实并不是。反坦克弹药与高射反战机弹药不同，需要特别研发并装备，88既然能对英军坦克做出有效的打击，说明在研发时便有此设计，且装备有专用的反坦克弹药。

游民星空

自行反坦克炮及坦克歼击车

　　虽然17磅和88炮可以提供性能优异的反坦克火力，可是这些武器的机动能力严重不足，只能使用车辆或人力拖曳，被发现了很可能被空军及炮兵洗地，于是反坦克火力的车载化是大势所趋，使用坦克底盘便是其中一个选择，为坦克换装更大威力的反坦克炮，让拖拽式反坦克炮摇身一变变为自行反坦克炮。

游民星空
奇葩的炮口朝向车尾的弓箭手自行反坦克炮，开火时驾驶员不能坐在自己的位置上，否则会被后坐力怼死

猎豹坦克歼击车

　　如果说二战中最优秀的自行反坦克炮是谁的话，猎豹绝对是有力的竞争者，猎豹自行反坦克炮基于豹式底盘改装，搭载了虎王使用的KwK43/L71型88mm加农炮，机动与火力上佳。“猎豹”坦克歼击车可以在2000m的射击距离上击穿除IS-2外所有对方坦克的装甲，这在二战期间是很少见的。德军规定，“猎豹”坦克歼击车只允许用来执行反坦克作战任务，由集团军指挥。可见，德军是把它当作重要的反坦克武器来使用的。该车的机动性能也不错，最大速度达到55km/h，行程显得小一些。猎豹坦克歼击车采用的黑豹坦克底盘，正面装甲的厚度与黑豹坦克一样，为80mm 55°倾角的装甲，可以抵御绝大多数盟军坦克的正面攻击，甚至是IS-2、潘兴坦克都无法有效的在较远距离击穿其正面装甲。而谢尔曼坦克或T-34坦克更是无能为力。而它惊人的火力可以在2000米轻松击毁绝大部分的盟军坦克。

游民星空
《战争雷霆》中的猎豹坦克歼击车

SU-152自行火炮

　　而来自苏联的SU-152自行火炮（二战时苏联没有对自行火炮与自行反坦克炮、坦克歼击车做出明确划分）则使用了KV-1s坦克的底盘，搭载一门ML-20型火炮，口径高达152mm，既可以进行直射反坦克作业，也可以知性曲射轰炸任务，1943年5月，苏联组建了第一个装备这种新型突击炮的团。苏军坦克手对这种新型突击炮反映很好，因为它能有效的对抗德军新型坦克（“虎”和“豹”）。库尔斯克战役中，SU-152突击炮得了一个新的呢称——“动物杀手”（德军坦克取名多为动物）。在12天的战斗中，该团就摧毁德军12辆“虎”式坦克和7辆“斐迪南”重型坦克歼击车。

游民星空
同样出现在《战争雷霆》中的SU-152自行火炮，他和猎豹究竟谁更强呢？

PTZ-89自行反坦克炮

　　PTZ-89自行反坦克炮是中国人民解放军的一种自行反坦克炮车，也是世界上第一种进入现役的120毫米自行反坦克炮。该炮的出现弥补了我军大口径自行反坦克炮的空白。此车主要配属于机械化师的自行火炮团内，兼任中口径自行火炮与反装甲火力，该炮的出现弥补了解放军陆军当时直瞄反装甲火力的不足，和我军大口径自行反坦克炮的空白。PTZ-89自行反坦克炮的内部结构来看，是典型的自行火炮的结构，装有解放军现役坦克装甲车辆中唯一规格的大口径加农炮，采用了与解放军新一代改进型坦克基本相同的火控系统，规格上明显比中型和主战坦克轻，全重仅31吨。

游民星空
国产PTZ-89自行反坦克炮开火瞬间
攻击机、强击机

　　看了不少地上的反坦克武器，我们来看看空中的威胁，由于空中打击手段的崛起，坦克受到的空中威胁越来越大，各国也积极推出俯冲轰炸机、强击机、攻击机来增强对地打击能力，坦克的日子不好过啊。

游民星空
越战中挂载马桶的A-1H攻击机

Ju87斯图卡俯冲轰炸机

　　在凡尔赛条约的限制下，德国被禁止拥有空军。但是，伴随着德国实力的恢复，希特勒宣称不再遵守这个约束。斯图卡俯冲轰炸机是由Hans Pohlmann 设计，并于1935年首次试飞，一战的王牌飞行员Robort Ritter von Greim试飞了这架世界上第一个具备专业反坦克能力的作战飞机。这架 JU-87是依循旧的经验制造的，但是Pohlmann赋予了它新的特性：能够垂直的向目标进行俯冲攻击，这种轰炸的精确程度远远超过了水平轰炸。德国空军的第一个俯冲轰炸机单位于1937年诞生，并且有一部分JU 87A-1S交付给派往西班牙执行军事干涉任务的空军部队。当时德国空军中的很多军官对斯图卡轰炸机并不感兴趣，认为其飞行速度太慢，且过于笨重，容易成为敌军战斗机的靶子。然而，斯图卡在西班牙优异的表现，终于赢得了大多数德国空军军官广泛的赞誉。JU-87作为一架出色的俯冲轰炸机，在不少的经典战役中基于他的优良性能都发挥出色。 同时德国又是一个充满王牌飞行员的强大国家。在列宁格勒战役中，当时驻扎在此的第7俯冲轰炸航空团发挥出色。其中王牌艾迪•埃特上尉出击50余次，共打击苏军坦克187辆、火炮526门，令苏军闻风丧胆，被授予铁十字勋章 。

游民星空
被称为尖啸死神的Ju87斯图卡

强-5

　　强-5强击机，是中国参照歼-6战斗机自行研制的一型单座双发超音速喷气强击机。中国空军组建之初，因沿海岛屿解放作战而十分重视对地攻击，并组建强击航空兵，配备从前苏联引进的伊尔-10强击机。在上个世纪五十年代初解放军攻占一江山岛等两栖作战中，苏制伊尔-10强击机作战能力突出，给中国军方留下深刻印象。后来为寻求后继机型，中国空军下达了超音速强击机的研制任务。强-5左右翼各一门23毫米机炮，可以用自身挂载的炸弹、导弹、火箭及机炮进行反坦克作战。

游民星空
强-5进行战术轰炸瞬间，注意机翼上的火箭巢

A-10

　　被称为疣猪的A-10雷电攻击机有着堪称强悍的对地攻击能力，A-10攻击机的前机身内左下侧安装了1门30mm的GAU-8型7管加特林式机炮，机炮安装的下俯角为2°。最大备弹量1350发。整个机炮系统重约1.8吨，每分钟可以发射4000发贫铀穿甲弹，在整个海湾战争144架A-10机群出了将近8100次任务，一共摧毁了伊拉克1,000台以上的坦克、2,000台其他战斗车辆以及1,200个火炮据点，外加部份的雷达设施和机动性高的飞毛腿导弹发射器。

游民星空
A-10和其装备的巨大加特林式机炮
武装直升机

　　空中的打击当然不仅仅停留在固定翼飞机上，直升机尤其是专业的现代武装直升机对坦克的威胁更为明显，因为武装直升机可快可悬停，同时拥有多种打击和发现坦克的手段，可以称得上树梢上的杀手。

游民星空
《荣誉勋章》中出现的武装直升机进攻场景

米-24

　　米-24雌鹿武装运输直升机是苏联米里直升机设计局设计的苏联也是世界的第一代武装加运输的多用途中型直升机。米-24在机头拥有一门双管30mm机炮，在机翼上可以挂载多种武器，从无制导火箭弹到专用反坦克导弹都可以选择，载重大、火力强、装甲厚的特点，不光可以提供直接的强大火力支援，还可以运载突击分队，或后送伤员。而且苏联飞行员还经常飞出不可思议的机动动作，比如横滚……

游民星空
米-24开火瞬间

AH-64D长弓阿帕奇武装直升机

　　美国AH-64D长弓阿帕奇直升机是AH-64阿帕奇武装直升机的改进型，其最明显的特点就是在旋翼上的一个长弓毫米波雷达，可以全天候搜索/跟踪十几公里范围内的地面目标，极大提高了飞机的战场侦察能力。长弓雷达天线安装在主旋翼轴的顶部，可进行360度的全向扫描，也可以对某个扇形区进行重点扫描，发现机载红外设备发现不了的伪装目标，并通过目标探测和分类设备将目标信号特性与数据库进行比较，依次排列出对载机的威胁等级，也让其携带16枚反坦克导弹或76枚70毫米火箭弹作战效能倍增。

游民星空

武直-10

　　而由昌河飞机工业（集团）有限责任公司中国直升机设计研究所设计的武直-10则是中国的骄傲，武直-10是中国人民解放军第一种专业武装直升机和亚洲各国第一种自研专业武装直升机。结束了中国人民解放军陆军航空兵长期依赖法国海豚直升机的改型兼当武装直升机的历史，大大提高了中国人民解放军陆军航空兵的航空突击与反装甲能力。武直-10配备一座旋转式机炮塔，机体两侧武器短翼可挂载反坦克导弹以及空空导弹，采用串列双座式设计，在设计上符合西方专业武装直升机的主要特征。2012年11月12日，直-10在第九届中国国际航空航天博览会中首次正式曝光。2012年11月18日，中国中央电视台公布的军事新闻中，直-10已经正式加入现役，开始列装中国人民解放军陆军航空兵部队。

游民星空
无后坐力炮及反坦克火箭筒：

　　看完了填上飞的，对于血肉之躯的步兵来说，最趁手同时也是反映最快捷的恐怕是各种各样的反坦克榴弹和一款趁手的筒子了，这些筒子反射弹丸的方式既有无后坐力炮原理也有火箭原理，构成了每个国家反坦克计划中最后的一环。

游民星空
美国的把组卡巴祖卡火箭筒

m18无后坐力炮

　　二战伊始，美国人的战术思想还比较落后，坦克的主要武器是机枪，反坦克武器基本等于没有（如果M2算的话那就是有），面对欧洲早已横扫法国的德军装甲部队杀伤能力严重不足，这样的情况自然是多路反坦克武器上马，1943年第一批M18很快就被运到了欧洲和太平洋战场，首个接收它们的部队是位于欧洲的第17伞兵师。虽然作为轻型武器来说，其高爆弹的威力不俗，但是破甲弹63.5毫米的贯穿能力就颇为使人失望了。与之相比，巴祖卡火箭筒的穿甲能力为120毫米。这主要是因为用以提高精确度的膛线减缓了炮弹的速度，降低了威力。在太平洋战区，官兵们表示新的57毫米无坐力炮是一种极为成功的“手提火炮”。1945年6月9日，M18在冲绳岛战役中首次投入使用，同时提供的配套炮弹为高爆弹和烟雾弹。在太平洋地形复杂的岛屿上同日军进行艰难的拉锯战时，M18是能够提供有效的炮火支援。士兵们唯一的怨言就是希望能够提供更多的炮弹。在朝鲜战争中，M18被用于摧毁敌人的机枪据点。作为反坦克武器则缺乏效率，要想用M18击穿T-34型坦克只有打击它的后面装甲才行。因而美军士兵更愿意使用口径更大的M20型超级巴祖卡来攻击T-34。国民革命军接收并在M18型无后座力炮的基础上仿制出了民国36型无后坐力炮，中国人民解放军获取胜利后将这些M18和其图纸加以研究，开发出了52式无后坐力炮。这种武器被运用在了越南战争中， 坦桑尼亚也获得了部分52式，52式可以同时使用美国和中国的弹药，而M18却不能使用它的炮弹。

游民星空
m18无后坐力炮，炮弹上的空洞就是用来平衡后座力的排气孔

RPG-7

　　RPG-7最初被苏联设计出来的时候就是要执行反坦克作战，经过不断的改进，尤其是对弹药的改进，让RPG-7获得了越来越好的破甲深度，采用PG-7V式火箭弹拥有将近264mm的破甲厚度，可是随着技术的进步爆炸反应装甲的出现，，破甲战斗部效果被严重削弱，于是设计师推出了拥有两个聚能装药战斗部的PG-7VR弹药，前端下战斗部引爆爆炸反应装甲后，主战斗部依然拥有600mm的穿甲能力。

游民星空

陶氏导弹

　　可是火箭弹毕竟射程有限且精度不佳，想要让步兵更加有效的进行反坦克作战还是需要导弹这种武器，尤其是重型反坦克导弹，其中陶氏反坦克导弹作为最著名的反坦克导弹家族一直服役至今，TOW意为管射、光学追踪、线控导引，是由雷声公司研发的反坦克和精确攻击导弹系统。陶氏导弹系统现在世界上最广泛使用的反坦克导弹，该导弹广泛部署在美军斯特瑞克、布拉德利和悍马装甲车上。最新版本的陶氏导弹采用无线电指令链路代替导线制导系统。该导弹也可配备串联战斗部或爆炸成型弹丸（EFP），由地面三脚架、装甲车和直升机发射，最大射程为4.5千米。


安装和登录命令：login、 shutdown、 halt、 reboot 、mount、umount 、chsh

文件处理命令：file、 mkdir、 grep、dd、 find、 mv 、ls 、diff、 cat、 ln

系统管理相关命令：df、 top、 free、 quota 、 groupadd kill、 crontab、 tar、last

网络操作命令：ifconfig、 ip 、ping 、 netstat 、telnet、 ftp、 route、 rlogin rcp 、finger 、mail 、nslookup

系统安全相关命令： passwd 、su、 umask 、chgrp、 chmod、chown、chattr、sudo、 pswho











##### **16.2 设置主机清单**

在初次使用Ansible服务时，大家可能会遇到这种情况：参数明明已经修改了，但却不生效。这是因为Ansible服务的主配置文件存在优先级的顺序关系，默认存放在/etc/ansible目录中的主配置文件优先级最低。如果在当前目录或用户家目录中也存放着一份主配置文件，则以当前目录或用户家目录中的主配置文件为主。同时存在多个Ansible服务主配置文件时，具体优先级顺序如表16-2所示。

表16-2                   Ansible服务主配置文件优先级顺序

| 优先级 | 文件位置                 |
| ------ | ------------------------ |
| 高     | ./ansible.cfg            |
| 中     | ~/.ansible.cfg           |
| 低     | /etc/ansible/ansible.cfg |



既然Ansible服务是用于实现主机批量自动化控制的管理工具，受管的主机一定不是一两台台，而是数十台甚至成百上千台，那么主机清单（inventory）在生产环境中就可以帮上大忙了。用户可以把要管理的主机IP地址预先写入/etc/ansible/hosts文件，这样后续再通过执行ansible命令来执行任务时就自动包含这些主机了，也就不需要每次都重复输入受管主机的地址了。例如，要管理5台主机，对应的IP地址如表16-3所示。

表16-3                   受管主机信息

| 操作系统 | IP地址        | 功能用途  |
| -------- | ------------- | --------- |
| RHEL 8   | 192.168.10.20 | dev       |
| RHEL 8   | 192.168.10.21 | test      |
| RHEL 8   | 192.168.10.22 | prod      |
| RHEL 8   | 192.168.10.23 | prod      |
| RHEL 8   | 192.168.10.24 | balancers |



首先需要说明的是，受管主机的系统默认使用RHEL 8，这是为了避免大家在准备实验机阶段产生歧义而给出的建议值，也可以用其他Linux系统。主机清单文件/etc/ansible/hosts中默认存在大量的注释信息，建议全部删除，然后替换成实验信息。

```
[root@linuxprobe ~]# vim /etc/ansible/hosts
192.168.10.20
192.168.10.21
192.168.10.22
192.168.10.23
192.168.10.24
```

为了增加实验难度，“通吃”生产环境中的常见需求，我们又为这5台主机分别规划了功能用途，有开发机（dev）、测试机（test）、产品机（prod）（两台）和负载均衡机（balancers）。在对主机进行分组标注后，后期在管理时就方便多了。

```
[root@linuxprobe ~]# vim /etc/ansible/hosts
[dev]
192.168.10.20
[test]
192.168.10.21
[prod]
192.168.10.22
192.168.10.23
[balancers]
192.168.10.24
```

主机清单文件在修改后会立即生效，一般使用“ansible-inventory --graph”命令以结构化的方式显示出受管主机的信息。因为我们对受管主机进行了分组，因此这种方式非常便于我们的阅读。

```
[root@linuxprobe ~]# ansible-inventory --graph
@all:
  |--@balancers:
  |  |--192.168.10.24
  |--@dev:
  |  |--192.168.10.20
  |--@prod:
  |  |--192.168.10.22
  |  |--192.168.10.23
  |--@test:
  |  |--192.168.10.21
  |--@ungrouped:
```

等等！先不要着急开始后面的实验。前文讲过，Ansible服务是基于SSH协议进行自动化控制的，这是开展后面实验的前提条件。第9章曾经讲到，sshd服务在初次连接时会要求用户接受一次对方主机的指纹信息。准备输入受管主机的账号和密码。例如，正常的第一次SSH远程连接过程是这样的：

```
[root@linuxprobe ~]# ssh 192.168.10.10
The authenticity of host '192.168.10.10 (192.168.10.10)' can't be established.
ECDSA key fingerprint is SHA256:QRW1wrqdwN0PI2bsUvBlW5XOIpBjE+ujCB8yiCqjMQQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.10.10' (ECDSA) to the list of known hosts.
root@192.168.10.10's password: 此处应输入管理员密码后回车确认
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Mon Mar 29 06:30:15 2021
[root@linuxprobe ~]# 
```

众所周知，自动化运维的一个好处就是能提高工作效率。但是，如果每次执行操作都要输入受管主机的密码，也是比较麻烦的事情。好在Ansible服务已经对此有了解决办法，那就是使用如表16-4所示的变量。

表16-4                   Ansible常用变量汇总

| 参数                                             | 作用          |
| ------------------------------------------------ | ------------- |
| ansible_ssh_host                                 | 受管主机名    |
| ansible_ssh_port                                 | 端口号        |
| ansible_ssh_user                                 | 默认账号      |
| ansible_ssh_pass                                 | 默认密码      |
| ansible_[shell](https://www.linuxcool.com/)_type | Shell终端类型 |



用户只需要将对应的变量及信息填写到主机清单文件中，在执行任务时便会自动对账号和密码进行匹配，而不用每次重复输入它们。继续修改主机清单文件：

```
[root@linuxprobe ~]# vim /etc/ansible/hosts
[dev]
192.168.10.20
[test]
192.168.10.21
[prod]
192.168.10.22
192.168.10.23
[balancers]
192.168.10.24
[all:vars]
ansible_user=root
ansible_password=redhat
```

还剩最后一步。将Ansible主配置文件中的第71行设置成默认不需要SSH协议的指纹验证，以及将第107行设置成默认执行剧本时所使用的管理员名称为root：

```
[root@linuxprobe ~]# vim /etc/ansible/ansible.cfg
69
70 # uncomment this to disable SSH key host checking
71 host_key_checking = False
72
………………省略部分输出信息………………
104
105 # default user to use for playbooks if user is not specified
106 # (/usr/bin/ansible will use current user as default)
107 remote_user = root
108
```

不需要重启服务，在以上操作完全搞定后就可以开始后面的实验了。由于刚才是将Ansible服务器设置成了桥接及DHCP模式，现在请同学们自行将网络适配器修改回“仅主机模式”（见图16-3）以及192.168.10.10/24的IP地址。在修改完成后重启网卡，然后自行在主机之间执行ping操作。保证主机之间的网络能够互通是后续实验的基石。

```
[root@linuxprobe ~]# ifconfig
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.10.10  netmask 255.255.255.0  broadcast 192.168.10.255
        inet6 fe80::d0bb:17c8:880d:e719  prefixlen 64  scopeid 0x20
        ether 00:0c:29:7d:27:bf  txqueuelen 1000  (Ethernet)
        RX packets 32  bytes 5134 (5.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 43  bytes 4845 (4.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
………………省略部分输出信息………………
```

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/设置虚拟机网卡模式.png)

图16-3 将虚拟机网卡改回仅主机模式

##### **16.3 运行临时命令**

Ansible服务的强大之处在于只需要一条命令，便可以操控成千上万台的主机节点，而ansible命令便是最得力的工具之一。前文提到，Ansible服务实际上只是一个框架，能够完成工作的是模块化功能代码。Ansible的常用模块大致有20多个（见表16-5），本书将会在后面的实验中逐一详解。

偶尔遇到书中没有提及的模块，大家可以使用“ansible-doc模块名称”的命令格式自行查询，或是使用ansibe-doc -l命令列出所有的模块信息以供选择。

表16-5                   Ansible服务常用模块名称及作用

| 模块名称       | 模块作用                                 |
| -------------- | ---------------------------------------- |
| ping           | 检查受管节点主机网络是否能够联通。       |
| yum            | 安装、更新及卸载软件包。                 |
| yum_repository | 管理主机的软件仓库配置文件。             |
| template       | 复制模板文件到受管节点主机。             |
| copy           | 新建、修改及复制文件。                   |
| user           | 创建、修改及删除用户。                   |
| group          | 创建、修改及删除用户组。                 |
| service        | 启动、关闭及查看服务状态。               |
| get_url        | 从网络中下载文件。                       |
| file           | 设置文件权限及创建快捷方式。             |
| cron           | 添加、修改及删除计划任务。               |
| command        | 直接执行用户指定的命令。                 |
| shell          | 直接执行用户指定的命令（支持特殊字符）。 |
| debug          | 输出调试或报错信息。                     |
| mount          | 挂载硬盘设备文件。                       |
| filesystem     | 格式化硬盘设备文件。                     |
| lineinfile     | 通过正则表达式修改文件内容。             |
| setup          | 收集受管节点主机上的系统及变量信息。     |
| firewalld      | 添加、修改及删除防火墙策略。             |
| lvg            | 管理主机的物理卷及卷组设备。             |
| lvol           | 管理主机的逻辑卷设备。                   |



在Ansible服务中，ansible是用于执行临时任务的命令，也就在是执行后即结束（与剧本文件的可重复执行不同）。在使用ansible命令时，必须指明受管主机的信息，如果已经设置过主机清单文件（/etc/ansible/hosts），则可以使用all参数来指代全体受管主机，或是用dev、test等主机组名称来指代某一组的主机。

ansible命令常用的语法格式为“ansible受管主机节点 -m模块名称[-a模块参数]”，常见的参数如表16-6所示。其中，-a是要传递给模块的参数，只有功能极其简单的模块才不需要额外参数，所以大多情况下-m与-a参数都会同时出现。

表16-6                   ansible命令常用参数

| 参数      | 作用                    |
| --------- | ----------------------- |
| -k        | 手动输入SSH协议密码     |
| -i        | 指定主机清单文件        |
| -m        | 指定要使用的模块名      |
| -M        | 指定要使用的模块路径    |
| -S        | 使用su命令              |
| -T        | 设置SSH协议连接超时时间 |
| -a        | 设置传递给模块的参数    |
| --version | 查看版本信息            |
| -h        | 帮助信息                |



如果想实现某个功能，但是却不知道用什么模块，又或者是知道了模块名称，但不清楚模块具体的作用，则建议使用ansible-doc命令进行查找。例如，列举出当前Ansible服务所支持的所有模块信息：

```
[root@linuxprobe ~]# ansible-doc -l 
a10_server                                           Manage A10 Networks AX/SoftAX/Thunder/v...
a10_server_axapi3                                    Manage A10 Networks AX/SoftAX/Thunder/v...           
a10_service_group                                    Manage A10 Networks AX/SoftAX/Thunder/v...
a10_virtual_server                                   Manage A10 Networks AX/SoftAX/Thunder/v...
aci_aaa_user                                         Manage AAA users (aaa:User)                                              
aci_aaa_user_certificate                             Manage AAA user certificates (aaa:User...                        
aci_access_port_block_to_access_port                 Manage port blocks of Fabric interface ...
aci_access_port_to_interface_policy_leaf_profile     Manage Fabric interface policy leaf pro...
aci_access_sub_port_block_to_access_port             Manage sub port blocks of Fabric interf...
aci_aep                                              Manage attachable Access Entity Profile...
aci_aep_to_domain                                    Bind AEPs to Physical or Virtual Domain...   
aci_bd_subnet                                        Manage Subnets (fv:Subnet)                 
………………省略部分输出信息………………
```

一般情况下，很难通过名称来判别一个模块的作用，要么是参考模块后面的介绍信息，要么是平时多学多练，进行积累。例如，接下来随机查看一个模块的详细信息。ansible-doc命令会在屏幕上显示出这个模块的作用、可用参数及实例等信息：

```
[root@linuxprobe ~]# ansible-doc a10_server
> A10_SERVER    (/usr/lib/python3.6/site-packages/ansible/modules/network/a10/a10_server.py)

     Manage SLB (Server Load Balancer) server objects on A10 Networks devices via aXAPIv2.

  * This module is maintained by The Ansible Community
………………省略部分输出信息………………
```

在16.2节，已经成功地将受管主机的IP地址填写到主机清单文件中，接下来小试牛刀，检查一下这些主机的网络连通性。ping模块用于进行简单的网络测试（类似于常用的ping命令）。可以使用ansible命令直接针对所有主机调用ping模块，不需要增加额外的参数，返回值若为SUCCESS，则表示主机当前在线。

```
[root@linuxprobe ~]# ansible all -m ping
192.168.10.20 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.10.21 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.10.22 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.10.23 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}192.168.10.24 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
```

### **Tips**

由于5台受控主机的输出信息大致相同，因此为了提升读者的阅读体验，本章后续的输出结果默认仅保留192.168.10.20主机的输出值，其余相同的输出信息将会被省略。

是不是感觉很方便呢？！一次就能知道所有主机的在线情况。除了使用-m参数直接指定模块名称之外，还可以用-a参数将参数传递给模块，让模块的功能更高级，更好地满足当前生产的需求。例如，yum_repository模块的作用是管理主机的软件仓库，能够添加、修改及删除软件仓库的配置信息，参数相对比较复杂。遇到这种情况时，建议先用ansible-doc命令对其进行了解。尤其是下面的EXAMPLES结构段会有该模块的实例，对用户来说有非常高的参考价值。

```
[root@linuxprobe ~]# ansible-doc yum_repository
> YUM_REPOSITORY    (/usr/lib/python3.6/site-packages/ansible/modules/packaging>

        Add or remove YUM repositories in RPM-based Linux
        distributions. If you wish to update an existing repository
        definition use [ini_file] instead.

  * This module is maintained by The Ansible Core Team

……………………省略部分输出信息………………

EXAMPLES:

- name: Add repository
  yum_repository:
    name: epel
    description: EPEL YUM repo
    baseurl: https://download.fedoraproject.org/pub/epel/$releasever/$basearch/

- name: Add multiple repositories into the same file (1/2)
  yum_repository:
    name: epel
    description: EPEL YUM repo
    file: external_repos
    baseurl: https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
    gpgcheck: no

- name: Add multiple repositories into the same file (2/2)
  yum_repository:
    name: rpmforge
    description: RPMforge YUM repo
    file: external_repos
    baseurl: http://apt.sw.be/redhat/el7/en/$basearch/rpmforge
```

还好，参数并不是很多，而且与此前学过的/etc/yum.repos.d/目录中的配置文件基本相似。现在，想为主机清单中的所有服务器新增一个如表16-7所示的软件仓库，该怎么操作呢？

表16-7                   新增软件仓库信息

| 仓库名称    | EX294_BASE                                     |
| ----------- | ---------------------------------------------- |
| 仓库描述    | EX294 base software                            |
| 仓库地址    | file:///media/cdrom/BaseOS                     |
| GPG签名     | 启用                                           |
| GPG密钥文件 | file:///media/cdrom/RPM-GPG-KEY-redhat-release |



我们可以对照着EXAMPLE实例段，逐一对应填写需求值和参数，其标准格式是在-a参数后接整体参数（用单引号圈起），而各个参数字段的值则用双引号圈起。这是最严谨的写法。在执行下述命令后如果出现CHANGED字样，则表示修改已经成功：

```
[root@linuxprobe ~]# ansible all -m yum_repository -a 'name="EX294_BASE" description="EX294 base software" baseurl="file:///media/cdrom/BaseOS" gpgcheck=yes enabled=1 gpgkey="file:///media/cdrom/RPM-GPG-KEY-redhat-release"'

192.168.10.20 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": true,
    "repo": "EX294_BASE",
    "state": "present"
}
```

在命令执行成功后，可以到主机清单中的任意机器上查看新建成功的软件仓库配置文件。尽管这个实验的参数很多，但是并不难。

```
[root@linuxprobe ~]# cat /etc/yum.repos.d/EX294_BASE.repo 
[EX294_BASE]
baseurl = file:///media/cdrom/BaseOS
enabled = 1
gpgcheck = 1
gpgkey = file:///media/cdrom/RPM-GPG-KEY-redhat-release
name = EX294 base software
```

##### **16.4 剧本文件实战**

在很多情况下，仅仅执行单个命令或调用某一个模块，根本无法满足复杂工作的需要。Ansible服务允许用户根据需求，在类似于Shell脚本的模式下编写自动化运维脚本，然后由程序自动、重复地执行，从而大大提高了工作效率。

Ansible服务的剧本（playbook）文件采用YAML语言编写，具有强制性的格式规范，它通过空格将不同信息分组，因此有时会因一两个空格错位而导致报错。大家在使用时要万分小心。YAML文件的开头需要先写3个减号（---），多个分组的信息需要间隔一致才能执行，而且上下也要对齐，后缀名一般为.yml。剧本文件在执行后，会在屏幕上输出运行界面，内容会根据工作的不同而变化。在运行界面中，绿色表示成功，黄色表示执行成功并进行了修改，而红色则表示执行失败。

剧本文件的结构由4部分组成，分别是target、variable、task、handler，其各自的作用如下。

> **target**：用于定义要执行剧本的主机范围。
>
> **variable**：用于定义剧本执行时要用到的变量。
>
> **task**：用于定义将在远程主机上执行的任务列表。
>
> **handler**：用于定义执行完成后需要调用的后续任务。

YAML语言编写的Ansible剧本文件会按照从上到下的顺序自动运行，其形式类似于第4章介绍的Shell脚本，但格式有严格的要求。例如，创建一个名为packages.yml的剧本，让dev、test和prod组的主机可以自动安装数据库软件，并且将dev组主机的软件更新至最新。

安装和更新软件需要使用yum模块。先看一下帮助信息中的示例吧：

```
[root@linuxprobe ~]# ansible-doc yum
> YUM    (/usr/lib/python3.6/site-packages/ansible/modules/packaging/os/yum.py)

        Installs, upgrade, downgrades, removes, and lists packages and
        groups with the `yum' package manager. This module only works
        on Python 2. If you require Python 3 support see the [dnf]
        module.

  * This module is maintained by The Ansible Core Team
  * note: This module has a corresponding action plugin.

………………省略部分输出信息………………

EXAMPLES:

- name: install the latest version of Apache
  yum:
    name: httpd
    state: latest
```

在配置Ansible剧本文件时，ansible-doc命令提供的帮助信息真是好用。在知道yum模块的使用方法和格式后，就可以开始编写剧本了。初次编写剧本文件时，请务必看准格式，模块及play（动作）格式也要上下对齐，否则会出现“参数一模一样，但不能执行”的情况。

综上，一个剧本正确的写法应该是：

```
[root@linuxprobe ~]# vim packages.yml
---
- name: 安装软件包
  hosts: dev,test,prod
  tasks:
          - name: one
            yum:
                    name: mariadb
                    state: latest
[root@linuxprobe ~]#
```

其中，name字段表示此项play（动作）的名字，用于在执行过程中提示用户执行到了哪一步，以及帮助管理员在日后阅读时能想起这段代码的作用。大家可以在name字段自行命名，没有任何限制。hosts字段表示要在哪些主机上执行该剧本，多个主机组之间用逗号间隔；如果需要对全部主机进行操作，则使用all参数。tasks字段用于定义要执行的任务，每个任务都要有一个独立的name字段进行命名，并且每个任务的name字段和模块名称都要严格上下对齐，参数要单独缩进。

而错误的剧本文件是下面这样的：

```
[root@linuxprobe ~]# vim packages.yml
---
- name: 安装软件包
  hosts: dev,test,prod
  tasks:
          - name: one
            yum:
            name: mariadb
            state: latest
```

大家可以感受到YAML语言对格式要求有多严格吧。

在编写Ansible剧本文件时，RHEL 8系统自带的Vim编辑器具有自动缩进功能，这可以给我们提供很多帮助。在确认无误后就可以用ansible-playbook命令运行这个剧本文件了。

```
[root@linuxprobe ~]# ansible-playbook packages.yml 

PLAY [安装软件包] *******************************************************************

TASK [Gathering Facts] **************************************************************
ok: [192.168.10.20]
ok: [192.168.10.21]
ok: [192.168.10.22]
ok: [192.168.10.23]

TASK [one] **************************************************************************
changed: [192.168.10.20]
changed: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23]

PLAY RECAP **************************************************************************
192.168.10.20  : ok=2   changed=1  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.21  : ok=2   changed=1  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.22  : ok=2   changed=1  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.23  : ok=2   changed=1  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
```

在执行成功后，我们主要观察最下方的输出信息。其中，ok和changed表示执行及修改成功。如遇到unreachable或failed大于0的情况，建议手动检查剧本是否在所有主机中都正确运行了，以及有无安装失败的情况。在正确执行过packages.yml文件后，随机切换到dev、test、prod组中的任意一台主机上，再次安装mariadb软件包，此时会提示该服务已经存在。这说明刚才的操作一切顺利！

```
[root@linuxprobe ~]# dnf install mariadb
Updating Subscription Management repositories.
Unable to read consumer identity
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Last metadata expiration check: 1:05:53 ago on Thu 15 Apr 2021 08:29:11 AM CST.
Package mariadb-3:10.3.11-1.module+el8+2765+cfa4f87b.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```

##### **16.5 创建及使用角色**

在日常编写剧本时，会存在剧本越来越长的情况，这不利于进行阅读和维护，而且还无法让其他剧本灵活地调用其中的功能代码。角色（role）这一功能则是自Ansible  1.2版本开始引入的新特性，用于层次性、结构化地组织剧本。角色功能分别把变量、文件、任务、模块及处理器配置放在各个独立的目录中，然后对其进行便捷加载。简单来说，角色功能是把常用的一些功能“类模块化”，然后在用的时候加载即可。

Ansible服务的角色功能类似于编程中的封装技术—将具体的功能封装起来，用户不仅可以方便地调用它，而且甚至可以不用完全理解其中的原理。就像普通消费者不需要深入理解汽车刹车是如何实现的，制动总泵、刹车分泵、真空助力器、刹车盘、刹车鼓、刹车片或ABS泵都藏于底层结构中，用户只需要用脚轻踩刹车踏板就能制动汽车。这便是技术封装的好处。

角色的好处就在于将剧本组织成了一个简洁的、可重复调用的抽象对象，使得用户把注意力放到剧本的宏观大局上，统筹各个关键性任务，只有在需要时才去深入了解细节。角色的获取有3种方法，分别是加载系统内置角色、从外部环境获取角色以及自行创建角色。

###### **16.5.1 加载系统内置角色**

在使用RHEL系统的内置角色时，我们不需要联网就能实现。用户只需要配置好软件仓库的配置文件，然后安装包含系统角色的软件包rhel-system-roles，随后便可以在系统中找到它们了，然后就能够使用剧本文件调用角色了。

```
[root@linuxprobe ~]# dnf install -y rhel-system-roles
Updating Subscription Management repositories.
Unable to read consumer identity
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Last metadata expiration check: 1:06:26 ago on Tue 13 Apr 2021 07:22:03 AM CST.
Dependencies resolved.
================================================================================
 Package                  Arch          Version          Repository        Size
================================================================================
Installing:
 rhel-system-roles        noarch        1.0-5.el8        AppStream        127 k

Transaction Summary
================================================================================
Install  1 Package

………………省略部分输出信息………………  

Installed:
  rhel-system-roles-1.0-5.el8.noarch                                            

Complete!
```

安装完毕后，使用ansible-galaxy list命令查看RHEL 8系统中有哪些自带的角色可用：

```
[root@linuxprobe ~]# ansible-galaxy list
# /usr/share/ansible/roles
- linux-system-roles.kdump, (unknown version)
- linux-system-roles.network, (unknown version)
- linux-system-roles.postfix, (unknown version)
- linux-system-roles.selinux, (unknown version)
- linux-system-roles.timesync, (unknown version)
- rhel-system-roles.kdump, (unknown version)
- rhel-system-roles.network, (unknown version)
- rhel-system-roles.postfix, (unknown version)
- rhel-system-roles.selinux, (unknown version)
- rhel-system-roles.timesync, (unknown version)
# /etc/ansible/roles
[WARNING]: - the configured path /root/.ansible/roles does not exist.
```

大家千万不要低估这些由系统镜像自带的角色，它们在日常的工作中能派上大用场。这些角色的主要功能如表16-8所示。

表16-8                   ansible系统角色描述

| 角色名称                   | 作用                  |
| -------------------------- | --------------------- |
| rhel-system-roles.kdump    | 配置kdump崩溃恢复服务 |
| rhel-system-roles.network  | 配置网络接口          |
| rhel-system-roles.selinux  | 配置SELinux策略及模式 |
| rhel-system-roles.timesync | 配置网络时间协议      |
| rhel-system-roles.postfix  | 配置邮件传输服务      |
| rhel-system-roles.firewall | 配置防火墙服务        |
| rhel-system-roles.tuned    | 配置系统调优选项      |



以rhel-system-roles.timesync角色为例，它用于设置系统的时间和NTP服务，让主机能够同步准确的时间信息。剧本模板文件存放在/usr/share/doc/rhel-system-roles/目录中，可以复制过来修改使用：

```
[root@linuxprobe ~]# cp /usr/share/doc/rhel-system-roles/timesync/example-timesync-playbook.yml timesync.yml
```

NTP服务器主要用于同步计算机的时间，可以提供高精度的时间校准服务，帮助计算机校对系统时钟。在复制来的剧本模板文件中，删除掉多余的代码，将NTP服务器的地址填写到timesync_ntp_servers变量的hostname字段中即可。该变量的参数含义如表16-9所示。稍后timesync角色就会自动为用户配置参数信息了。

表16-9                  timesync_ntp_servers变量参数含义

| 参数     | 作用            |
| -------- | --------------- |
| hostname | NTP服务器主机名 |
| iburst   | 启用快速同步    |



```
[root@linuxprobe ~]# vim timesync.yml 
---
- hosts: all
  vars:
    timesync_ntp_servers:
      - hostname: pool.ntp.org
        iburst: yes
  roles:
    - rhel-system-roles.timesync
```

###### **16.5.2 从外部获取角色**

Ansible Galaxy是Ansible的一个官方社区，用于共享角色和功能代码，用户可以在网站自由地共享和下载Ansible角色。该社区是管理和使用角色的不二之选。

在图16-4所示的Ansible  Galaxy官网中，左侧有3个功能选项，分别是首页（Home）、搜索（Search）以及社区（Community）。单击Search按钮进入到搜索界面，这里以nginx服务为例进行搜索，即可找到Nginx官方发布的角色信息，如图16-5所示。

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/首页-1024x387.png)

图 16-4 Ansible Galaxy 官网首页

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/搜索界面-1024x447.png)

图16-5 搜索界面中找到nginx角色信息

### **Tips**

Ansible Galaxy 官网首页：https://galaxy.ansible.com

当单击nginx角色进入到详情页面后，会显示这个项目的软件版本、评分、下载次数等信息。在Installation字段可以看到相应的安装方式，如图16-6所示。在保持虚拟机能够连接外网的前提下，可以按这个页面提示的命令进行安装。

这时，如果需要使用这个角色，可以在虚拟机联网的状态下直接按照“ansible-galaxy install角色名称”的命令格式自动获取：

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/Nginx-1024x377.png)

图16-6 nginx角色详情页

```
[root@linuxprobe ~]# ansible-galaxy install nginxinc.nginx
- downloading role 'nginx', owned by nginxinc
- downloading role from https://github.com/nginxinc/ansible-role-nginx/archive/0.19.1.tar.gz
- extracting nginxinc.nginx to /etc/ansible/roles/nginxinc.nginx
- nginxinc.nginx (0.19.1) was installed successfully
```

执行完毕后，再次查看系统中已有的角色，便可找到nginx角色信息了：

```
[root@linuxprobe ~]# ansible-galaxy list
# /etc/ansible/roles
- nginxinc.nginx, 0.19.1
# /usr/share/ansible/roles
- linux-system-roles.kdump, (unknown version)
- linux-system-roles.network, (unknown version)
- linux-system-roles.postfix, (unknown version)
- linux-system-roles.selinux, (unknown version)
- linux-system-roles.timesync, (unknown version)
- rhel-system-roles.kdump, (unknown version)
- rhel-system-roles.network, (unknown version)
- rhel-system-roles.postfix, (unknown version)
- rhel-system-roles.selinux, (unknown version)
- rhel-system-roles.timesync, (unknown version)
```

这里还存在两种特殊情况。

> 在国内访问Ansible Galaxy官网时可能存在不稳定的情况，导致访问不了或者网速较慢。
>
> 某位作者是将作品上传到了自己的网站，或者除Ansible Galaxy官网以外的其他平台。

在这两种情况下，就不能再用“ansible-galaxy install角色名称”的命令直接加载了，而是需要手动先编写一个YAML语言格式的文件，指明网址链接和角色名称，然后再用-r参数进行加载。

例如，刘遄老师在本书的配套网站（www.linuxprobe.com）上传了一个名为nginx_core的角色软件包（一个用于对nginx网站进行保护的插件）。这时需要编写如下所示的一个yml配置文件：

```
[root@linuxprobe ~]# cat nginx.yml
---
- src: https://www.linuxprobe.com/Software/nginxinc-nginx_core-0.3.0.tar.gz
  name: nginx-core
```

随后使用ansible-galaxy命令的-r参数加载这个文件，即可查看到新角色信息了：

```
[root@linuxprobe ~]# ansible-galaxy install -r nginx.yml
- downloading role from https://www.linuxprobe.com/nginxinc-nginx_core-0.3.0.tar.gz
- extracting nginx to /etc/ansible/roles/nginx
- nginx was installed successfully
[root@linuxprobe ~]# ansible-galaxy list
# /etc/ansible/roles
- nginx-core, (unknown version)
- nginxinc.nginx, 0.19.1
# /usr/share/ansible/roles
- linux-system-roles.kdump, (unknown version)
- linux-system-roles.network, (unknown version)
- linux-system-roles.postfix, (unknown version)
- linux-system-roles.selinux, (unknown version)
- linux-system-roles.timesync, (unknown version)
- rhel-system-roles.kdump, (unknown version)
- rhel-system-roles.network, (unknown version)
- rhel-system-roles.postfix, (unknown version)
- rhel-system-roles.selinux, (unknown version)
- rhel-system-roles.timesync, (unknown version)
```

###### **16.5.3 创建新的角色**

除了能够使用系统自带的角色和从Ansible Galaxy中获取的角色之外，也可以自行创建符合工作需求的角色。这种定制化的编写工作能够更好地贴合生产环境的实际情况，但难度也会稍高一些。

接下来将会创建一个名为apache的新角色，它能够帮助我们自动安装、运行httpd网站服务，设置防火墙的允许规则，以及根据每个主机生成独立的index.html首页文件。用户在调用这个角色后能享受到“一条龙”的网站部署服务。

在Ansible的主配置文件中，第68行定义的是角色保存路径。如果用户新建的角色信息不在规定的目录内，则无法使用ansible-galaxy  list命令找到。因此需要手动填写新角色的目录路径，或是进入/etc/ansible/roles目录内再进行创建。为了避免后期角色信息过于分散导致不好管理，我们还是决定在默认目录下进行创建，不再修改。

```
[root@linuxprobe roles]# vim /etc/ansible/ansible.cfg
 66 
 67 # additional paths to search for roles in, colon separated
 68 #roles_path    = /etc/ansible/roles
 69 
```

在ansible-galaxy命令后面跟一个init参数，创建一个新的角色信息，且建立成功后便会在当前目录下生成出一个新的目录：

```
[root@linuxprobe ~]# cd /etc/ansible/roles
[root@linuxprobe roles]# ansible-galaxy init apache
- Role apache was created successfully
[root@linuxprobe roles]# ls
apache nginx nginxinc.nginx
```

此时的apache即是角色名称，也是用于存在角色信息的目录名称。切换到该目录下，查看它的结构：

```
[root@linuxprobe roles]# cd apache
[root@linuxprobe apache]# ls
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```

在创建新角色时，最关键的便是能够正确理解目录结构。通俗来说，就是要把正确的信息放入正确的目录中，这样在调用角色时才能有正确的效果。角色信息对应的目录结构及含义如表16-10所示。

表16-10                  Ansible角色目录结构及含义

| 目录      | 含义                                           |
| --------- | ---------------------------------------------- |
| defaults  | 包含角色变量的默认值（优先级低）。             |
| files     | 包含角色执行tasks任务时做引用的静态文件。      |
| handlers  | 包含角色的处理程序定义。                       |
| meta      | 包含角色的作者、许可证、频台和依赖关系等信息。 |
| tasks     | 包含角色所执行的任务。                         |
| templates | 包含角色任务所使用的Jinja2模板。               |
| tests     | 包含用于测试角色的剧本文件。                   |
| vars      | 包含角色变量的默认值（优先级高）。             |



下面准备创建新角色。

**第1步**：打开用于定义角色任务的tasks/main.yml文件。在该文件中不需要定义要执行的主机组列表，因为后面会单独编写剧本进行调用，此时应先对apache角色能做的事情（任务）有一个明确的思路，在调用角色后yml文件会按照从上到下的顺序自动执行。

> **任务1**：安装httpd网站服务。
>
> **任务2**：运行httpd网站服务，并加入到开机启动项中。
>
> **任务3**：配置防火墙，使其放行HTTP协议。
>
> **任务4**：根据每台主机的变量值，生成不同的主页文件。

先写出第一个任务。使用yum模块安装httpd网站服务程序（注意格式）：

```
[root@linuxprobe apache]# vim tasks/main.yml
---
- name: one
  yum:
          name: httpd
          state: latest
```

第2步：使用service模块启动httpd网站服务程序，并加入到启动项中，保证能够一直为用户提供服务。在初次使用模块前，先用ansible-doc命令查看一下帮助和实例信息。由于篇幅的限制，这里对信息进行了删减，仅保留了有用的内容。

```
[root@linuxprobe apache]# ansible-doc service
> SERVICE    (/usr/lib/python3.6/site-packages/ansible/modules/system/service.py)

        Controls services on remote hosts. Supported init systems
        include BSD init, OpenRC, SysV, Solaris SMF, systemd, upstart.
        For Windows targets, use the [win_service] module instead.

  * This module is maintained by The Ansible Core Team
  * note: This module has a corresponding action plugin.

………………省略部分输出信息………………

EXAMPLES:

- name: Start service httpd, if not started
  service:
    name: httpd
    state: started

- name: Enable service httpd, and not touch the state
  service:
    name: httpd
    enabled: yes
```

真幸运，默认的EXAMPLES示例使用的就是httpd网站服务。通过输出信息可得知，启动服务为“state: started”参数，而加入到开机启动项则是“enabled: yes”参数。继续编写：

```
[root@linuxprobe apache]# vim tasks/main.yml
---
- name: one
  yum:
          name: httpd
          state: latest
- name: two
  service:
          name: httpd
          state: started
          enabled: yes
```

第3步：配置防火墙的允许策略，让其他主机可以正常访问。在配置防火墙时，需要使用firewalld模块。同样也是先看一下帮助示例：

```
[root@linuxprobe defaults]# ansible-doc firewalld
> FIREWALLD    (/usr/lib/python3.6/site-packages/ansible/modules/system/firewalld.py)

        This module allows for addition or deletion of services and
        ports (either TCP or UDP) in either running or permanent
        firewalld rules.

  * This module is maintained by The Ansible Community
OPTIONS (= is mandatory):
EXAMPLES:

- firewalld:
    service: https
    permanent: yes
    state: enabled

- firewalld:
    port: 8081/tcp
    permanent: yes
    state: disabled
    immediate: yes
```

依据输出信息可得知，在firewalld模块设置防火墙策略时，指定协议名称为“service: http”参数，放行该协议为“state: enabled”参数，设置为永久生效为“permanent: yes”参数，当前立即生效为“immediate:  yes”参数。参数虽然多了一些，但是基本与在第8章节学习的一致，并不需要担心。继续编写：

```
[root@linuxprobe apache]# vim tasks/main.yml
---
- name: one
  yum:
          name: httpd
          state: latest
- name: two
  service:
          name: httpd
          state: started
          enabled: yes
- name: three
  firewalld:
          service: http
          permanent: yes
          state: enabled
          immediate: yes
```

第4步：让每台主机显示的主页文件均不相同。在使用Ansible的常规模块时，都是采用“查询版主示例并模仿”的方式搞定的，这里为了增加难度，我们再提出个新需求，即能否让每台主机上运行的httpd网站服务都能显示不同的内容呢？例如显示当前服务器的主机名及IP地址。这就要用到template模块及Jinja2技术了。

我们依然使用ansible-doc命令来查询template模块的使用方法。示例部分依然大有帮助：

```
[root@linuxprobe apache]# ansible-doc template
> TEMPLATE    (/usr/lib/python3.6/site-packages/ansible/modules/files/template.>

        Templates are processed by the L(Jinja2 templating
        language,http://jinja.pocoo.org/docs/). Documentation on the
        template formatting can be found in the L(Template Designer
        Documentation,http://jinja.pocoo.org/docs/templates/).
        Additional variables listed below can be used in templates.
        `ansible_managed' (configurable via the `defaults' section of
        `ansible.cfg') contains a string which can be used to describe
        the template name, host, modification time of the template
        file and the owner uid. `template_host' contains the node name
        of the template's machine. `template_uid' is the numeric user
        id of the owner. `template_path' is the path of the template.
        `template_fullpath' is the absolute path of the template.
        `template_destpath' is the path of the template on the remote
        system (added in 2.8). `template_run_date' is the date that
        the template was rendered.

  * This module is maintained by The Ansible Core Team
  * note: This module has a corresponding action plugin.

………………省略部分输出信息………………

EXAMPLES:

- name: Template a file to /etc/files.conf
  template:
    src: /mytemplates/foo.j2
    dest: /etc/file.conf
    owner: bin
    group: wheel
    mode: '0644'
```

从template模块的输出信息中可得知，这是一个用于复制文件模板的模块，能够把文件从Ansible服务器复制到受管主机上。其中，src参数用于定义本地文件的路径，dest参数用于定义复制到受管主机的文件路径，而owner、group、mode参数可选择性地设置文件归属及权限信息。

正常来说，我们可以直接复制文件的操作，受管主机上会获取到一个与Ansible服务器上的文件一模一样的文件。但有时候，我们想让每台客户端根据自身系统的情况产生不同的文件信息，这就需要用到Jinja2技术了，Jinja2格式的模板文件后缀是.j2。继续编写：

```
[root@linuxprobe apache]# vim tasks/main.yml
---
- name: one
  yum:
          name: httpd
          state: latest
- name: two
  service:
          name: httpd
          state: started
          enabled: yes
- name: three
  firewalld:
          service: http
          permanent: yes
          state: enabled
          immediate: yes
- name: four
  template:
          src: index.html.j2
          dest: /var/www/html/index.html
```

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/jinja.png)

Jinja2是Python语言中一个被广泛使用的模板引擎，最初的设计思想源自Django的模块引擎。Jinja2基于此发展了其语法和一系列强大的功能，能够让受管主机根据自身变量产生出不同的文件内容。换句话说，正常情况下的复制操作会让新旧文件一模一样，但在使用Jinja2技术时，不是在原始文件中直接写入文件内容，而是写入一系列的变量名称。在使用template模块进行复制的过程中，由Ansible服务负责在受管主机上收集这些变量名称所对应的值，然后再逐一填写到目标文件中，从而让每台主机的文件都根据自身系统的情况独立生成。

例如，想要让每个网站的输出信息值为“Welcome  to主机名on主机地址”，也就是用每个主机自己独有的名称和IP地址来替换文本中的内容，这样就有趣太多了。这个实验的难点在于查询到对应的变量名称、主机名及地址所对应的值保存在哪里？可以用setup模块进行查询。

```
[root@linuxprobe apache]# ansible-doc setup
> SETUP    (/usr/lib/python3.6/site-packages/ansible/modules/system/setup.py)

        This module is automatically called by playbooks to gather
        useful variables about remote hosts that can be used in
        playbooks. It can also be executed directly by
        `/usr/bin/ansible' to check what variables are available to a
        host. Ansible provides many `facts' about the system,
        automatically. This module is also supported for Windows
        targets.
```

setup模块的作用是自动收集受管主机上的变量信息，使用-a参数外加filter命令可以对收集来的信息进行二次过滤。相应的语法格式为ansible all -m setup -a  'filter="*关键词*"'，其中*号是第3章节讲到的通配符，用于进行关键词查询。例如，如果想搜索各个主机的名称，可以使用通配符搜索所有包含fqdn关键词的变量值信息。

FQDN（Fully Qualified Domain  Name，完全限定域名）用于在逻辑上准确表示出主机的位置。FQDN常常被作为主机名的完全表达形式，比/etc/hostname文件中定义的主机名更加严谨和准确。通过输出信息可得知，ansible_fqdn变量保存有主机名称。随后进行下一步操作：

```
[root@linuxprobe ~]# ansible all -m setup -a 'filter="*fqdn*"'
192.168.10.20 | SUCCESS => {
    "ansible_facts": {
        "ansible_fqdn": "linuxprobe.com",
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false
}
………………省略部分输出信息………………
```

用于指定主机地址的变量可以用ip作为关键词进行检索。可以看到，ansible_all_ipv4_addresses变量中的值是我们想要的信息。如果想输出IPv6形式的地址，则可用ansible_all_ipv6_addresses变量。

```
[root@linuxprobe ~]# ansible all -m setup -a 'filter="*ip*"'
192.168.10.20 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.10.20",
            "192.168.122.1"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::d0bb:17c8:880d:e719"
        ],
        "ansible_default_ipv4": {},
        "ansible_default_ipv6": {},
        "ansible_fips": false,
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false
}
………………省略部分输出信息………………
```

在确认了主机名与IP地址所对应的具体变量名称后，在角色所对应的templates目录内新建一个与上面的template模块参数相同的文件名称（index.html.j2）。Jinja2在调用变量值时，格式为在变量名称的两侧格加两个大括号：

```
[root@linuxprobe apache]# vim templates/index.html.j2
Welcome to {{ ansible_fqdn }} on {{ ansible_all_ipv4_addresses }}
```

进行到这里，任务基本就算完成了。最后要做的就是编写一个用于调用apache角色的yml文件，以及执行这个文件。

```
[root@linuxprobe apache]# cd ~
[root@linuxprobe ~]# vim roles.yml
---
- name: 调用自建角色
  hosts: all
  roles:
          - apache
[root@linuxprobe ~]# ansible-playbook roles.yml 
PLAY [调用自建角色] **************************************************************************

TASK [Gathering Facts] **********************************************************************
ok: [192.168.10.20]
ok: [192.168.10.21]
ok: [192.168.10.22]
ok: [192.168.10.23]
ok: [192.168.10.24]

TASK [apache : one] *************************************************************************
changed: [192.168.10.20]
changed: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23]
changed: [192.168.10.24]

TASK [apache : two] *************************************************************************
changed: [192.168.10.20]
changed: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23]
changed: [192.168.10.24]

TASK [apache : three] ***********************************************************************
changed: [192.168.10.20]
changed: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23]
changed: [192.168.10.24]

TASK [apache : four] ***********************************************************************
changed: [192.168.10.20]
changed: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23] 
changed: [192.168.10.24]

PLAY RECAP **********************************************************************************
192.168.10.20   : ok=5   changed=4  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.21   : ok=5   changed=4  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.22   : ok=5   changed=4  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.23   : ok=5   changed=4  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0   
192.168.10.24   : ok=4   changed=4  unreachable=0   failed=0   skipped=0   rescued=0   ignored=0
```

执行完毕后，在浏览器中随机输入几台主机的IP地址，即可访问到包含主机FQDN和IP地址的网页了，如图16-7～图16-9所示。

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/访问网站-1024x170.png)

图16-7 随机访问一台主机节点的网站首页

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/2-34-1024x160.png)

图16-8 随机访问一台主机节点的网站首页![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/3-15-1024x166.png)

图16-9 随机访问一台主机节点的网站首页

实验相当成功！



##### **16.6 创建和使用逻辑卷**

创建一个能批量、自动管理逻辑卷设备的剧本，不但能大大提高硬盘设备的管理效率，而且还能避免手动创建带来的错误。例如，我们想在每台受管主机上都创建出一个名为data的逻辑卷设备，大小为150MB，归属于research卷组。如果创建成功，则进一步用Ext4文件系统进行格式化操作；如果创建失败，则给用户输出一条报错提醒，以便排查原因。

在这种情况下，使用Ansible剧本要比使用Shell脚本的优势大，原因主要有下面两点。

> Ansible模块化的功能让操作更标准，只要在执行过程中无报错，那么便会依据远程主机的系统版本及配置自动做出判断和操作，不用担心因系统变化而导致命令失效的问题。
>
> Ansible服务在执行剧本文件时会进行判断：如果该文件或该设备已经被创建过，或是某个动作（play）已经被执行过，则绝对不会再重复执行；而使用Shell脚本有可能导致设备被重复格式化，导致数据丢失。

首先在prod组的两台主机上分别添加一块硬盘设备，大小为20GB，类型为SCSI，其余选项选择默认值，如图16-10～图16-12所示。

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/1-42.png)

图16-10 添加一块新硬盘
 ![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/2-33.png)

图16-11 设置硬盘类型

![第16章 使用Ansible服务实现自动化运维第16章 使用Ansible服务实现自动化运维](https://www.linuxprobe.com/wp-content/uploads/2021/03/3-14.png)

图16-12 新硬盘添加完毕

通过回忆第7章学习过的逻辑卷的知识，我们应该让剧本文件依次创建物理卷（PV）、卷组（VG）及逻辑卷（LV）。需要先使用lvg模块让设备支持逻辑卷技术，然后创建一个名为research的卷组。lvg模块的帮助信息如下：

```
[root@linuxprobe ~]# ansible-doc lvg
> LVG    (/usr/lib/python3.6/site-packages/ansible/modules/system/lvg.py)

        This module creates, removes or resizes volume groups.

  * This module is maintained by The Ansible Community

………………省略部分输出信息………………

EXAMPLES:

- name: Create a volume group on top of /dev/sda1 with physical extent size = 3>
  lvg:
    vg: vg.services
    pvs: /dev/sda1
    pesize: 32

- name: Create a volume group on top of /dev/sdb with physical extent size = 12>
  lvg:
    vg: vg.services
    pvs: /dev/sdb
    pesize: 128K
```

通过输出信息可得知，创建PV和VG的lvg模块总共有3个必备参数。其中，vg参数用于定义卷组的名称，pvs参数用于指定硬盘设备的名称，pesize参数用于确定最终卷组的容量大小（可以用PE个数或容量值进行指定）。这样一来，我们先创建出一个由/dev/sdb设备组成的名称为research、大小为150MB的卷组设备。

```
[root@linuxprobe ~]# vim lv.yml
---
- name: 创建和使用逻辑卷
  hosts: all
  tasks:
          - name: one
            lvg:
                    vg: research
                    pvs: /dev/sdb
                    pesize: 150M
```

由于刚才只在prod组的两台主机上添加了新硬盘设备文件，因此在执行上述操作时其余3台主机会提示未创建成功，这属于正常情况。接下来使用lvol模块创建出逻辑卷设备。还是按照惯例，先查看模块的帮助信息：

```
[root@linuxprobe ~]# ansible-doc lvol
> LVOL    (/usr/lib/python3.6/site-packages/ansible/modules/system/lvol.py)

        This module creates, removes or resizes logical volumes.

  * This module is maintained by The Ansible Community

………………省略部分输出信息………………

EXAMPLES:

- name: Create a logical volume of 512m
  lvol:
    vg: firefly
    lv: test
    size: 512

- name: Create a logical volume of 512m with disks /dev/sda and /dev/sdb
  lvol:
    vg: firefly
    lv: test
    size: 512
    pvs: /dev/sda,/dev/sdb
```

通过输出信息可得知，lvol是用于创建逻辑卷设备的模块。其中，vg参数用于指定卷组名称，lv参数用于指定逻辑卷名称，size参数则用于指定最终逻辑卷设备的容量大小（不用加单位，默认为MB）。填写好参数，创建出一个大小为150MB、归属于research卷组且名称为data的逻辑卷设备：

```
[root@linuxprobe ~]# vim lv.yml
---
- name: 创建和使用逻辑卷
  hosts: all
  tasks:
          - name: one
            lvg:
                    vg: research
                    pvs: /dev/sdb
                    pesize: 150M
          - name: two
            lvol:
                    vg: research
                    lv: data
                    size: 150M
```

这样还不够好，如果还能将创建出的/dev/research/data逻辑卷设备自动用Ext4文件系统进行格式化操作，则又能帮助运维管理员减少一些工作量。可使用filesystem模块来完成设备的文件系统格式化操作。该模块的帮助信息如下：

```
[root@linuxprobe ~]# ansible-doc filesystem
> FILESYSTEM    (/usr/lib/python3.6/site-packages/ansible/modules/system/filesy>

        This module creates a filesystem.

  * This module is maintained by The Ansible Community

………………省略部分输出信息………………

EXAMPLES:

- name: Create a ext2 filesystem on /dev/sdb1
  filesystem:
    fstype: ext2
    dev: /dev/sdb1
```

filesystem模块的参数真是简练，fstype参数用于指定文件系统的格式化类型，dev参数用于指定要格式化的设备文件路径。继续编写：

```
[root@linuxprobe ~]# vim lv.yml
---
- name: 创建和使用逻辑卷
  hosts: all
  tasks:
          - name: one
            lvg:
                    vg: research
                    pvs: /dev/sdb
                    pesize: 150M
          - name: two
            lvol:
                    vg: research
                    lv: data
                    size: 150M
          - name: three
            filesystem:
                    fstype: ext4
                    dev: /dev/research/data 
```

这样按照顺序执行下来，逻辑卷设备就能够自动创建好了。等一下，还有个问题没有解决。现在只有prod组的主机上添加了新的硬盘设备文件，其余主机是无法按照既定模块顺利完成操作的。这时就要使用类似于第4章学习的if条件语句的方式进行判断—如果失败……，则……。

首先用block操作符将上述的3个模块命令作为一个整体（相当于对这3个模块的执行结果作为一个整体进行判断），然后使用rescue操作符进行救援，且只有block块中的模块执行失败后才会调用rescue中的救援模块。其中，debug模块的msg参数的作用是，如果block中的模块执行失败，则输出一条信息到屏幕，用于提醒用户。完成编写后的剧本是下面这个样子：

```
[root@linuxprobe ~]# vim lv.yml
---
- name: 创建和使用逻辑卷
  hosts: all
  tasks:
          - block:
                  - name: one
                    lvg:
                            vg: research
                            pvs: /dev/sdb
                            pesize: 150M
                  - name: two
                    lvol:
                            vg: research
                            lv: data
                            size: 150M
                  - name: three
                    filesystem:
                            fstype: ext4
                            dev: /dev/research/data
            rescue:
                    - debug:
                            msg: "Could not create logical volume of that size"
```

YAML语言对格式有着硬性的要求，既然rescue是对block内的模块进行救援的功能代码，因此recue和block两个操作符必须严格对齐，错开一个空格都会导致剧本执行失败。确认无误后，执行lv.yml剧本文件检阅一下效果：

```
[root@linuxprobe ~]# ansible-playbook lv.yml 

PLAY [创建和使用逻辑卷] *********************************************************

TASK [Gathering Facts] *********************************************************
ok: [192.168.10.20]
ok: [192.168.10.21]
ok: [192.168.10.22]
ok: [192.168.10.23]
ok: [192.168.10.24]

TASK [one] *********************************************************************
fatal: [192.168.10.20]: FAILED! => {"changed": false, "msg": "Device /dev/sdb not found."}
fatal: [192.168.10.21]: FAILED! => {"changed": false, "msg": "Device /dev/sdb not found."}
changed: [192.168.10.22]
changed: [192.168.10.23]
fatal: [192.168.10.24]: FAILED! => {"changed": false, "msg": "Device /dev/sdb not found."}

TASK [two] *********************************************************************
changed: [192.168.10.22]
changed: [192.168.10.23]

TASK [three] *********************************************************************
changed: [192.168.10.22]
changed: [192.168.10.23]

TASK [debug] *******************************************************************
ok: [192.168.10.20] => {
    "msg": "Could not create logical volume of that size"
}
ok: [192.168.10.21] => {
    "msg": "Could not create logical volume of that size"
}
ok: [192.168.10.24] => {
    "msg": "Could not create logical volume of that size"
}

PLAY RECAP *********************************************************************
192.168.10.20  : ok=2  changed=0  unreachable=0  failed=0  skipped=0  rescued=1  ignored=0   
192.168.10.21  : ok=2  changed=0  unreachable=0  failed=0  skipped=0  rescued=1  ignored=0   
192.168.10.22  : ok=4  changed=3  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0   
192.168.10.23  : ok=4  changed=3  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0   
192.168.10.24  : ok=2  changed=0  unreachable=0  failed=0  skipped=0  rescued=1  ignored=0 
```

在剧本运行完毕后的执行记录（PLAY  RECAP）中可以很清晰地看到只有192.168.10.22及192.168.10.23这两台prod组中的主机执行成功了，其余3台主机均触发了rescue功能。登录到任意一台prod组的主机上，找到新建的逻辑卷设备信息：

```
[root@linuxprobe ~]# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/research/data
  LV Name                data
  VG Name                research
  LV UUID                EOUliC-tbkk-kOJR-8NaH-O9XQ-ijrK-TgEYGj
  LV Write Access        read/write
  LV Creation host, time linuxprobe.com, 2021-04-23 11:00:21 +0800
  LV Status              available
  # open                 0
  LV Size                5.00 GiB
  Current LE             1
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
………………省略部分输出信息………………
```

##### **16.7 判断主机组名**

在上面的剧本实验中，我们可以让不同的主机根据自身不同的变量信息而生成出独特的网站主页文件，但却无法对某个主机组进行针对性的操作。其实，在每个客户端中都会有一个名为inventory_hostname的变量，用于定义每台主机所对应的Ansible服务的主机组名称，也就是/etc/ansible/hosts文件中所对应的分组信息，例如dev、test、prod、balancers。

inventory_hostname是Ansible服务中的魔法变量，这意味着无法使用setup模块直接进行查询，诸如ansible  all -m setup -a 'filter="*关键词*"'这样的命令将对它失效。魔法变量需要在执行剧本文件时的Gathering  Facts阶段进行搜集，直接查询是看不到的，只能在剧本文件中进行调用。

在获得了存储主机组名称的变量名称后，接下来开始实战。这里的需求如下：

> 若主机在dev分组中，则修改/etc/issue文件内容为Development；
>
> 若主机在test分组中，则修改/etc/issue文件内容为Test；
>
> 若主机在prod分组中，则修改/etc/issue文件内容为Production。

根据表16-5所提及的Ansible常用模块名称及作用，可以看到copy模块的主要作用是新建、修改及复制文件，更符合当前的需要，此时便派上了用场。先查询copy模块的帮助信息：

```
[root@linuxprobe ~]# ansible-doc copy
> COPY    (/usr/lib/python3.6/site-packages/ansible/modules/files/copy.py)

        The `copy' module copies a file from the local or remote
        machine to a location on the remote machine. Use the [fetch]
        module to copy files from remote locations to the local box.
        If you need variable interpolation in copied files, use the
        [template] module. Using a variable in the `content' field
        will result in unpredictable output. For Windows targets, use
        the [win_copy] module instead.

  * This module is maintained by The Ansible Core Team
  * note: This module has a corresponding action plugin.

………………省略部分输出信息………………

EXAMPLES:

- name: Copy file with owner and permissions
  copy:
    src: /srv/myfiles/foo.conf
    dest: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Copy using inline content
  copy:
    content: '# This file was moved to /etc/other.conf'
    dest: /etc/mine.conf
```

在输出信息中列举了两种管理文件内容的示例。第一种用于文件的复制行为，第二种是通过content参数定义内容，通过dest参数指定新建文件的名称。显然，第二种更加符合当前的实验场景。编写剧本文件如下：

```
[root@linuxprobe ~]# vim issue.yml
---
- name: 修改文件内容
  hosts: all
  tasks:
          - name: one
            copy:
                    content: 'Development'
                    dest: /etc/issue
          - name: two
            copy:
                    content: 'Test'
                    dest: /etc/issue
          - name: three
            copy:
                    content: 'Production'
                    dest: /etc/issue
```

但是，如果按照这种顺序执行下去，每一台主机的/etc/issue文件都会被重复修改3次，最终定格在“Production”字样，这显然缺少了一些东西。我们应该依据inventory_hostname变量中的值进行判断。若主机为dev组，则执行第一个动作；若主机为test组，则执行第二个动作；若主机为prod组，则执行第三个动作。因此，要进行3次判断。

when是用于判断的语法，我们将其用在每个动作的下方进行判断，使得只有在满足条件才会执行：

```
[root@linuxprobe ~]# vim issue.yml
---
- name: 修改文件内容
  hosts: all
  tasks:
          - name: one
            copy:
                    content: 'Development'
                    dest: /etc/issue
            when: "inventory_hostname in groups.dev"
          - name: two
            copy:
                    content: 'Test'
                    dest: /etc/issue
            when: "inventory_hostname in groups.test"
          - name: three
            copy:
                    content: 'Production'
                    dest: /etc/issue
            when: "inventory_hostname in groups.prod"
```

执行剧本文件，在过程中可清晰地看到由于when语法的作用，未在指定主机组中的主机将被跳过（skipping）：

```
[root@linuxprobe ~]# ansible-playbook issue.yml 

PLAY [修改文件内容] ************************************************************************

TASK [Gathering Facts] ********************************************************************
ok: [192.168.10.20]
ok: [192.168.10.21]
ok: [192.168.10.22]
ok: [192.168.10.23]
ok: [192.168.10.24]

TASK [one] ********************************************************************************
changed: [192.168.10.20]
skipping: [192.168.10.21]
skipping: [192.168.10.22]
skipping: [192.168.10.23] 
skipping: [192.168.10.24]

TASK [two] ********************************************************************************
skipping: [192.168.10.20]
changed: [192.168.10.21]
skipping: [192.168.10.23]
skipping: [192.168.10.24]
skipping: [192.168.10.25]

TASK [three] ******************************************************************************
skipping: [192.168.10.20]
skipping: [192.168.10.21]
changed: [192.168.10.22]
changed: [192.168.10.23]
skipping: [192.168.10.24]

PLAY RECAP ********************************************************************************
192.168.10.20   : ok=2  changed=1  unreachable=0  failed=0  skipped=2  rescued=0  ignored=0   
192.168.10.21   : ok=2  changed=1  unreachable=0  failed=0  skipped=2  rescued=0  ignored=0   
192.168.10.22   : ok=2  changed=1  unreachable=0  failed=0  skipped=2  rescued=0  ignored=0   
192.168.10.23   : ok=2  changed=1  unreachable=0  failed=0  skipped=2  rescued=0  ignored=0 
192.168.10.24   : ok=1  changed=0  unreachable=0  failed=0  skipped=3  rescued=0  ignored=0 
```

登录到dev组的192.168.10.20主机上，查看文件内容：

```
[root@linuxprobe ~]# cat /etc/issue 
Development
```

登录到test组的192.168.10.21主机上，查看文件内容：

```
[root@linuxprobe ~]# cat /etc/issue 
Test
```

登录到prod组的192.168.10.22/23主机上，查看文件内容：

```
[root@linuxprobe ~]# cat /etc/issue 
Production
```

##### **16.8 管理文件属性**

我们学习剧本的目的是为了满足日常的工作需求，把重复的事情写入到脚本中，然后再批量执行下去，从而提高运维工作的效率。其中，创建文件、管理权限以及设置快捷方式几乎是每天都用到的技能。尤其是在第5章学习文件的一般权限、特殊权限、隐藏权限时，往往还会因命令的格式问题而导致出错。这么多命令该怎么记呢？

Ansible服务将常用的文件管理功能都合并到了file模块中，大家不用再为了寻找模块而“东奔西跑”了。先来看一下file模块的帮助信息：

```
[root@linuxprobe ~]# ansible-doc file
> FILE    (/usr/lib/python3.6/site-packages/ansible/modules/files/file.py)

        Set attributes of files, symlinks or directories.
        Alternatively, remove files, symlinks or directories. Many
        other modules support the same options as the `file' module -
        including [copy], [template], and [assemble]. For Windows
        targets, use the [win_file] module instead.

  * This module is maintained by The Ansible Core Team

………………省略部分输出信息………………

EXAMPLES:

- name: Change file ownership, group and permissions
  file:
    path: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Create a symbolic link
  file:
    src: /file/to/link/to
    dest: /path/to/symlink
    owner: foo
    group: foo
    state: link

- name: Create a directory if it does not exist
  file:
    path: /etc/some_directory
    state: directory
    mode: '0755'

- name: Remove file (delete file)
  file:
    path: /etc/foo.txt
    state: absent
```

通过上面的输出示例，大家已经能够了解file模块的基本参数了。其中，path参数定义了文件的路径，owner参数定义了文件所有者，group参数定义了文件所属组，mode参数定义了文件权限，src参数定义了源文件的路径，dest参数定义了目标文件的路径，state参数则定义了文件类型。

可见，file模块基本上把第5章学习过的管理文件权限的功能都包含在内了。我们来就来挑战下面的实验吧：

> 请创建出一个名为/linuxprobe的新目录，所有者及所属组均为root管理员身份；
>
> 设置所有者和所属于组拥有对文件的完全控制权，而其他人则只有阅读和执行权限；
>
> 给予SGID特殊权限；
>
> 仅在dev主机组的主机上实施。

第二条要求是算术题，即将权限描述转换为数字表示法，即可读为4、可写为2、可执行为1。大家可以先自行默默计算一下答案。此前在编写剧本文件时，hosts参数对应的一直是all，即全体主机，这次需要修改为仅对dev主机组成员生效，请小心谨慎。编写模块代码如下：

```
[root@linuxprobe ~]# vim chmod.yml
---
- name: 管理文件属性
  hosts: dev
  tasks:
          - name: one
            file:
                    path: /linuxprobe
                    state: directory 
                    owner: root
                    group: root
                    mode: '2775'
```

一不小心把题目出简单了，这里没能完全展示出file模块的强大之处。我们临时添加一个需求：请再创建一个名称为/linuxcool的快捷方式文件，指向刚刚建立的/linuxprobe目录。这样用户在访问两个目录时就能有相同的内容了。在使用file模块设置快捷方式时，不需要再单独创建目标文件，Ansible服务会帮我们完成：

```
[root@linuxprobe ~]# vim chmod.yml
---
- name: 管理文件属性
  hosts: dev
  tasks:
          - name: one
            file:
                    path: /linuxprobe
                    state: directory 
                    owner: root
                    group: root
                    mode: '2775'
          - name: two
            file:
                    src: /linuxprobe
                    dest: /linuxcool
                    state: link
```

剧本文件的执行过程如下所示：

```
[root@linuxprobe ~]# ansible-playbook chmod.yml 

PLAY [管理文件属性] ***************************************************************

TASK [Gathering Facts] ***********************************************************
ok: [192.168.10.20]
ok: [192.168.10.21]
ok: [192.168.10.22]
ok: [192.168.10.23]
ok: [192.168.10.24]

TASK [one] ***********************************************************************
changed: [192.168.10.20]
skipping: [192.168.10.21]
skipping: [192.168.10.22]
skipping: [192.168.10.23]
skipping: [192.168.10.24]

TASK [two] ***********************************************************************
changed: [192.168.10.20]
skipping: [192.168.10.21]
skipping: [192.168.10.22]
skipping: [192.168.10.23]
skipping: [192.168.10.24]

PLAY RECAP ***********************************************************************
192.168.10.20   : ok=3  changed=2  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0   
192.168.10.22   : ok=1  changed=0  unreachable=0  failed=0  skipped=3  rescued=0  ignored=0
192.168.10.22   : ok=1  changed=0  unreachable=0  failed=0  skipped=3  rescued=0  ignored=0
192.168.10.22   : ok=1  changed=0  unreachable=0  failed=0  skipped=3  rescued=0  ignored=0
192.168.10.22   : ok=1  changed=0  unreachable=0  failed=0  skipped=3  rescued=0  ignored=0
```

进入到dev组的主机中，可以看到/linuxprobe目录及/linuxcool的快捷方式均已经被顺利创建：

```
[root@linuxprobe ~]# ls -ld /linuxprobe
drwxrwsr-x. 2 root root 6 Apr 20 09:52 /linuxprobe
[root@linuxprobe ~]# ls -ld /linuxcool
lrwxrwxrwx. 1 root root 11 Apr 20 09:52 /linuxcool -> /linuxprobe
```

##### **16.9 管理密码库文件**

自Ansible  1.5版本发布后，vault作为一项新功能进入到了运维人员的视野。它不仅能对密码、剧本等敏感信息进行加密，而且还可以加密变量名称和变量值，从而确保数据不会被他人轻易阅读。使用ansible-vault命令可以实现内容的新建（create）、加密（encrypt）、解密（decrypt）、修改密码（rekey）及查看（view）等功能。

下面通过示例来学习vault的具体用法。

第1步：创建出一个名为locker.yml的配置文件，其中保存了两个变量值：

```
[root@linuxprobe ~]# vim locker.yml
---
pw_developer: Imadev
pw_manager: Imamgr
```

第2步：使用ansible-vault命令对文件进行加密。由于需要每次输入密码比较麻烦，因此还应新建一个用于保存密码值的文本文件，以便让ansible-vault命令自动调用。为了保证数据的安全性，在新建密码文件后将该文件的权限设置为600，确保仅管理员可读可写：

```
[root@linuxprobe ~]# vim /root/secret.txt
whenyouwishuponastar
[root@linuxprobe ~]# chmod 600 /root/secret.txt
```

在Ansible服务的主配置文件中，在第140行的vault_password_file参数后指定密码值保存的文件路径，准备进行调用：

```
[root@linuxprobe ~]# vim /etc/ansible/ansible.cfg
137 
138 # If set, configures the path to the Vault password file as an alternative to
139 # specifying --vault-password-file on the command line.
140 vault_password_file = /root/secret.txt
141 
```

第3步：在设置好密码文件的路径后，Ansible服务便会自动进行加载。用户也就不用在每次加密或解密时都重复输入密码了。例如，在加密刚刚创建的locker.yml文件时，只需要使用encrypt参数即可：

```
[root@linuxprobe ~]# ansible-vault encrypt locker.yml
Encryption successful
```

文件将使用AES 256加密方式进行加密，也就是意味着密钥有2256种可能。查看到加密后的内容为：

```
[root@linuxprobe ~]# cat locker.yml 
$ANSIBLE_VAULT;1.1;AES256
38653234313839336138383931663837333533396161343730353530313038313631653439366335
3432346333346239386334663836643432353434373733310a306662303565633762313232663763
38366334316239376262656230643531656665376166663635656436363338626464333430343162
6664643035316133650a333331393538616130656136653630303239663561663237373733373638
62383234303061623865633466336636363961623039343236356336356361613736333739623961
6334303865663838623363333339396637363061626363383266
```

如果不想使用原始密码了呢？也可以使用rekey参数手动对文件进行改密操作，同时应结合--ask-vault-pass参数进行修改，否则Ansible服务会因接收不到用户输入的旧密码值而拒绝新的密码变更请求：

```
[root@linuxprobe ~]# ansible-vault rekey --ask-vault-pass locker.yml 
Vault password: 输入旧的密码
New Vault password: 输入新的密码
Confirm New Vault password: 再输入新的密码
Rekey successful
```

第4步：如果想查看和修改加密文件中的内容，该怎么操作呢？对于已经加密过的文件，需要使用ansible-vault命令的edit参数进行修改，随后用view参数即可查看到修改后的内容。ansible-vault命令对加密文件的编辑操作默认使用的是Vim编辑器，在修改完毕后请记得执行wq操作保存后退出：

```
[root@linuxprobe ~]# ansible-vault edit locker.yml
---
pw_developer: Imadev
pw_manager: Imamgr
pw_production: Imaprod
```

最后，再用view参数进行查看，便是最新的内容了：

```
[root@linuxprobe ~]# ansible-vault view locker.yml
Vault password: 输入密码后敲击回车确认
--- 
pw_developer: Imadev 
pw_manager: Imamgr 
pw_production: Imaprod
```