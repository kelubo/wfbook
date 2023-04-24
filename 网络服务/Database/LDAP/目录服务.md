# LDAP

[TOC]

## 简介

轻量级目录访问协议

目录是一个专门为搜索和浏览而设计的数据库，另外也支持基本的查询和更新功能。

>  **Note:** 
>
> 有些人将目录定义为仅针对读取访问进行优化的数据库。这个定义充其量过于简单化了。
>

目录往往包含描述性的、基于属性的信息，并支持复杂的过滤功能。Directories generally do not support complicated transaction or roll-back schemes found in  database management systems designed for handling high-volume complex  updates.  目录通常不支持为处理大容量复杂更新而设计的数据库管理系统中的复杂事务或回滚方案。如果允许的话，目录更新通常是简单的要么全有要么全无的更改。目录通常经过调整，以便对大容量查找或搜索操作做出快速响应。They may have the ability to replicate information widely in order to increase  availability and reliability, while reducing response time.  他们可能能够广泛复制信息，以提高可用性和可靠性，同时减少响应时间。When  directory information is replicated, temporary inconsistencies between  the consumers may be okay, as long as inconsistencies are resolved in a  timely manner.当复制目录信息时，只要及时解决不一致，消费者之间的临时不一致可能是可以的。

There are many different ways to provide a directory service.  Different methods allow different kinds of information to be stored in  the directory, place different requirements on how that information can  be referenced, queried and updated, how it is protected from  unauthorized access, etc.  Some directory services are *local*,  providing service to a restricted context (e.g., the finger service on a single machine). Other services are global, providing service to a much broader context (e.g., the entire Internet).  Global services are  usually *distributed*, meaning that the data they contain is  spread across many machines, all of which cooperate to provide the  directory service. Typically a global service defines a uniform *namespace* which gives the same view of the data no matter where you are in relation to the data itself.

有许多不同的方式可以提供目录服务。不同的方法允许不同类型的信息存储在目录中，对如何引用、查询和更新信息，如何保护信息免受未经授权的访问等提出不同的要求。一些目录服务是本地的，为受限的上下文提供服务（例如，单台机器上的手指服务）。其他服务是全球性的，为更广泛的环境（例如，整个互联网）提供服务。全局服务通常是分布式的，这意味着它们包含的数据分布在许多机器上，所有这些机器都协同提供目录服务。通常，全局服务定义了一个统一的名称空间，该名称空间提供相同的数据视图，无论您处于与数据本身相关的位置。

web目录，例如Curlie项目提供的目录，是目录服务的一个很好的例子。这些服务对网页进行编目，专门设计用于支持浏览和搜索。

虽然有些人认为互联网域名系统（DNS）是全球分布式目录服务的一个例子，但DNS既不可浏览也不可搜索。它被更恰当地描述为一个全局分布的查找服务。

1.2.什么是LDAP？

LDAP代表轻量级目录访问协议。顾名思义，它是一种用于访问目录服务的轻量级协议，特别是基于X.500的目录服务。LDAP通过TCP/IP或其他面向连接的传输服务运行。LDAP是IETF标准跟踪协议，并在“轻量级目录访问协议（LDAP）技术规范路线图”RFC4510中指定。

本节从用户的角度对LDAP进行了概述。

什么样的信息可以存储在目录中？LDAP信息模型基于条目。条目是具有全局唯一可分辨名称（DN）的属性集合。DN用于明确地引用条目。条目的每个属性都有一个类型和一个或多个值。类型通常是助记符字符串，如“cn”表示常用名称，或“mail”表示电子邮件地址。值的语法取决于属性类型。例如，cn属性可能包含值Babs-Jensen。邮件属性可能包含值“babs@example.com“.jpeg照片属性将包含jpeg（二进制）格式的照片。

信息是如何安排的？在LDAP中，目录条目以分层树状结构排列。传统上，这种结构反映了地理和/或组织边界。代表国家/地区的条目显示在树的顶部。下面是代表国家和国家组织的条目。它们下面可能是代表组织单位、人员、打印机、文档的条目，或者你能想到的任何其他条目。图1.1显示了一个使用传统命名的LDAP目录树示例。

A web directory, such as provided by the *Curlie Project* <https://curlie.org>, is a good example of a directory service. These services catalog web  pages and are specifically designed to support browsing and searching.

While some consider the Internet Domain Name System  (DNS) is an example of a globally distributed directory service, DNS is  not browsable nor searchable.  It is more properly described as a  globally distributed *lookup* service.

------

## 1.2. What is LDAP?

LDAP stands for Lightweight Directory Access Protocol.  As the name suggests, it is a lightweight protocol for accessing directory services, specifically X.500-based directory services.  LDAP runs over TCP/IP or other connection oriented transfer services.  LDAP is an [IETF](https://www.ietf.org/) Standard Track protocol and is specified in "Lightweight Directory Access Protocol (LDAP) Technical Specification Road Map" [RFC4510](https://www.rfc-editor.org/rfc/rfc4510.txt).

This section gives an overview of LDAP from a user's perspective.

*What kind of information can be stored in the directory?* The LDAP information model is based on *entries*. An entry is a collection of attributes that has a globally-unique Distinguished Name (DN).  The DN is used to refer to the entry unambiguously. Each of the entry's attributes has a *type* and one or more *values*. The types are typically mnemonic strings, like "`cn`" for common name, or "`mail`" for email address. The syntax of values depend on the attribute type.  For example, a `cn` attribute might contain the value `Babs Jensen`.  A `mail` attribute might contain the value "`babs@example.com`". A `jpegPhoto` attribute would contain a photograph in the JPEG (binary) format.

*How is the information arranged?* In LDAP, directory entries  are arranged in a hierarchical tree-like structure.  Traditionally, this structure reflected the geographic and/or organizational boundaries.   Entries representing countries appear at the top of the tree. Below them are entries representing states and national organizations. Below them  might be entries representing organizational units, people, printers,  documents, or just about anything else you can think of.  Figure 1.1  shows an example LDAP directory tree using traditional naming.



![img](https://openldap.org/doc/admin26/intro_tree.png)



Figure 1.1: LDAP directory tree (traditional naming)

The tree may also be arranged based upon Internet domain names. This  naming approach is becoming increasing popular as it allows for  directory services to be located using the *DNS*. Figure 1.2 shows an example LDAP directory tree using domain-based naming.



![img](https://openldap.org/doc/admin26/intro_dctree.png)



Figure 1.2: LDAP directory tree (Internet naming)

In addition, LDAP allows you to control which attributes are required and allowed in an entry through the use of a special attribute called `objectClass`.  The values of the `objectClass` attribute determine the *schema* rules the entry must obey.

*How is the information referenced?* An entry is referenced by its distinguished name, which is constructed by taking the name of the entry itself (called the Relative Distinguished Name or RDN) and concatenating the names of its ancestor entries. For  example, the entry for Barbara Jensen in the Internet naming example  above has an RDN of `uid=babs` and a DN of `uid=babs,ou=People,dc=example,dc=com`. The full DN format is described in [RFC4514](https://www.rfc-editor.org/rfc/rfc4514.txt), "LDAP: String Representation of Distinguished Names."

*How is the information accessed?* LDAP defines operations for interrogating and updating the directory.  Operations are provided for  adding and deleting an entry from the directory, changing an existing  entry, and changing the name of an entry. Most of the time, though, LDAP is used to search for information in the directory. The LDAP search  operation allows some portion of the directory to be searched for  entries that match some criteria specified by a search filter.  Information can be requested from each entry that matches the criteria.

For example, you might want to search the entire directory subtree at and below `dc=example,dc=com` for people with the name `Barbara Jensen`, retrieving the email address of each entry found. LDAP lets you do this easily.  Or you might want to search the entries directly below the `st=California,c=US` entry for organizations with the string `Acme` in their name, and that have a fax number. LDAP lets you do this too.  The next section describes in more detail what you can do with LDAP and  how it might be useful to you.

*How is the information protected from unauthorized access?*  Some directory services provide no protection, allowing anyone to see  the information. LDAP provides a mechanism for a client to authenticate, or prove its identity to a directory server, paving the way for rich  access control to protect the information the server contains. LDAP also supports data security (integrity and confidentiality) services.

------

## 1.3. When should I use LDAP?

This is a very good question. In general, you should use a Directory  server when you require data to be centrally managed, stored and  accessible via standards based methods.

Some common examples found throughout the industry are, but not limited to:

- Machine Authentication
- User Authentication
- User/System Groups
- Address book
- Organization Representation
- Asset Tracking
- Telephony Information Store
- User resource management
- E-mail address lookups
- Application Configuration store
- PBX Configuration store
- etc.....

There are various [Distributed Schema Files](https://openldap.org/doc/admin26/schema.html#Distributed Schema Files) that are standards based, but you can always create your own [Schema Specification](https://openldap.org/doc/admin26/schema.html).

There are always new ways to use a Directory and apply LDAP  principles to address certain problems, therefore there is no simple  answer to this question.

If in doubt, join the general LDAP forum for non-commercial discussions and information relating to LDAP at: http://www.umich.edu/~dirsvcs/ldap/mailinglist.html and ask

------

## 1.4. When should I not use LDAP?

When you start finding yourself bending the directory to do what you  require, maybe a redesign is needed. Or if you only require one  application to use and manipulate your data (for discussion of LDAP vs  RDBMS, please read the [LDAP vs RDBMS](https://openldap.org/doc/admin26/intro.html#LDAP vs RDBMS) section).

It will become obvious when LDAP is the right tool for the job.

------

## 1.5. How does LDAP work?

LDAP utilizes a *client-server model*. One or more LDAP servers contain the data making up the directory information tree (DIT). The client connects to servers and asks it a question.  The server  responds with an answer and/or with a pointer to where the client can  get additional information (typically, another LDAP server). No matter  which LDAP server a client connects to, it sees the same view of the  directory; a name presented to one LDAP server references the same entry it would at another LDAP server.  This is an important feature of a  global directory service.

------

## 1.6. What about X.500?

Technically, LDAP is a directory access protocol to an X.500 directory service, the OSI directory service. Initially, LDAP clients accessed gateways to the  X.500 directory service. This gateway ran LDAP between the client and  gateway and X.500's Directory Access Protocol (DAP) between the gateway and the X.500 server.  DAP is a heavyweight  protocol that operates over a full OSI protocol stack and requires a  significant amount of computing resources.  LDAP is designed to operate  over TCP/IP and provides most of the functionality of DAP at a much lower cost.

While LDAP is still used to access X.500 directory service via  gateways, LDAP is now more commonly directly implemented in X.500  servers.

The Standalone LDAP Daemon, or *slapd*(8), can be viewed as a *lightweight* X.500 directory server.  That is, it does not implement the X.500's DAP nor does it support the complete X.500 models.

If you are already running a X.500 DAP service and you want to  continue to do so, you can probably stop reading this guide.  This guide is all about running LDAP via *slapd*(8), without running X.500  DAP.  If you are not running X.500 DAP, want to stop running X.500 DAP,  or have no immediate plans to run X.500 DAP, read on.

It is possible to replicate data from an LDAP directory server to a X.500 DAP DSA.  This requires an LDAP/DAP gateway. OpenLDAP Software does not include such a gateway.

------

## 1.7. What is the difference between LDAPv2 and LDAPv3?

LDAPv3 was developed in the late 1990's to replace LDAPv2. LDAPv3 adds the following features to LDAP:

- Strong authentication and data security services via SASL
- Certificate authentication and data security services via TLS (SSL)
- Internationalization through the use of Unicode
- Referrals and Continuations
- Schema Discovery
- Extensibility (controls, extended operations, and more)

LDAPv2 is historic ([RFC3494](https://www.rfc-editor.org/rfc/rfc3494.txt)).  As most *so-called* LDAPv2 implementations (including *slapd*(8)) do not conform to the LDAPv2 technical specification, interoperability  amongst implementations claiming LDAPv2 support is limited.  As LDAPv2  differs significantly from LDAPv3, deploying both LDAPv2 and LDAPv3  simultaneously is quite problematic.  LDAPv2 should be avoided. LDAPv2  is disabled by default.

------

## 1.8. LDAP vs RDBMS

This question is raised many times, in different forms. The most common, however, is: *Why doesn't OpenLDAP use a relational database management system (RDBMS) instead of an embedded key/value store like LMDB?* In general, expecting that the sophisticated algorithms implemented by commercial-grade RDBMS would make *OpenLDAP* be faster or somehow better and, at the same time, permitting sharing of data with other applications.

The short answer is that use of an embedded database and custom  indexing system allows OpenLDAP to provide greater performance and  scalability without loss of reliability. OpenLDAP uses LMDB concurrent / transactional database software.

Now for the long answer. We are all confronted all the time with the  choice RDBMSes vs. directories. It is a hard choice and no simple answer exists.

It is tempting to think that having a RDBMS backend to the directory  solves all problems. However, it is a pig. This is because the data  models are very different. Representing directory data with a relational database is going to require splitting data into multiple tables.

Think for a moment about the person objectclass. Its definition  requires attribute types objectclass, sn and cn and allows attribute  types userPassword, telephoneNumber, seeAlso and description. All of  these attributes are multivalued, so a normalization requires putting  each attribute type in a separate table.

Now you have to decide on appropriate keys for those tables. The  primary key might be a combination of the DN, but this becomes rather  inefficient on most database implementations.

The big problem now is that accessing data from one entry requires  seeking on different disk areas. On some applications this may be OK but in many applications performance suffers.

The only attribute types that can be put in the main table entry are  those that are mandatory and single-value. You may add also the optional single-valued attributes and set them to NULL or something if not  present.

But wait, the entry can have multiple objectclasses and they are  organized in an inheritance hierarchy. An entry of objectclass  organizationalPerson now has the attributes from person plus a few  others and some formerly optional attribute types are now mandatory.

What to do? Should we have different tables for the different  objectclasses? This way the person would have an entry on the person  table, another on organizationalPerson, etc. Or should we get rid of  person and put everything on the second table?

But what do we do with a filter like (cn=*) where cn is an attribute  type that appears in many, many objectclasses. Should we search all  possible tables for matching entries? Not very attractive.

Once this point is reached, three approaches come to mind. One is to  do full normalization so that each attribute type, no matter what, has  its own separate table. The simplistic approach where the DN is part of  the primary key is extremely wasteful, and calls for an approach where  the entry has a unique numeric id that is used instead for the keys and a main table that maps DNs to ids. The approach, anyway, is very  inefficient when several attribute types from one or more entries are  requested. Such a database, though cumbersomely, can be managed from SQL applications.

The second approach is to put the whole entry as a blob in a table  shared by all entries regardless of the objectclass and have additional  tables that act as indices for the first table. Index tables are not  database indices, but are fully managed by the LDAP server-side  implementation. However, the database becomes unusable from SQL. And,  thus, a fully fledged database system provides little or no advantage.  The full generality of the database is unneeded. Much better to use  something light and fast, like LMDB.

A completely different way to see this is to give up any hopes of  implementing the directory data model. In this case, LDAP is used as an  access protocol to data that provides only superficially the directory  data model. For instance, it may be read only or, where updates are  allowed, restrictions are applied, such as making single-value attribute types that would allow for multiple values. Or the impossibility to add new objectclasses to an existing entry or remove one of those present.  The restrictions span the range from allowed restrictions (that might be elsewhere the result of access control) to outright violations of the  data model. It can be, however, a method to provide LDAP access to  preexisting data that is used by other applications. But in the  understanding that we don't really have a "directory".

Existing commercial LDAP server implementations that use a relational database are either from the first kind or the third. I don't know of  any implementation that uses a relational database to do inefficiently  what LMDB does efficiently. For those who are interested in "third way"  (exposing EXISTING data from RDBMS as LDAP tree, having some limitations compared to classic LDAP model, but making it possible to interoperate  between LDAP and SQL applications):

OpenLDAP includes back-sql - the backend that makes it possible. It  uses ODBC + additional metainformation about translating LDAP queries to SQL queries in your RDBMS schema, providing different levels of access - from read-only to full access depending on RDBMS you use, and your  schema.

For more information on concept and limitations, see *slapd-sql*(5) man page, or the [Backends](https://openldap.org/doc/admin26/backends.html) section. There are also several examples for several RDBMSes in `back-sql/rdbms_depend/*` subdirectories.



LDAP表示轻型目录访问协议。是一个轻量级协议，用于访问目录服务，特别是基于X.500的目录服务。 LDAP运行在TCP / IP或其他面向连接的传输服务。 LDAP是一个IETF标准跟踪协议，在“轻量级目录访问协议（ LDAP ）技术规范路线图”RFC4510中被指定。

LDAP信息模型是基于条目的. 一个条目是一个属性的集合，有一个全球唯一的识别名（ DN ）. DN用于明白无误地标识条目. 每个条目的属性有一个类型和一个或多个值. 该类型通常是可记忆的字符串，如“ cn ”就是标识通用名称，或“mail”就是电子邮件地址。 值的语法依赖于属性类型。

在LDAP, 目录条目都被排列在一个分层树形结构。传统上，这种结构反映了地域和/或组织界限. 代表国家的条目出现在树的顶端。它们下面是代表州和国家组织的条目. 再下面可能是代表组织单位,人,打印机,文档,或只是任何你你能想象到的东西。LDAP 目录树 (传统的命名)
![](../../../Image/intro_tree.png)

树也可以根据互联网域名组织。它允许使用DNS为目录服务定位 。LDAP 目录树(Internet命名)
![](../../../Image/intro_dctree.png)

通过使用一种特殊属性objectClass，可以让LDAP控制在一个条目中哪个属性是必需的和允许的。objectClass属性的值确定条目必须遵守的架构规则。

LDAP采用C/S模式。包含在一个或多个LDAP服务器中的数据组成了目录信息树(DIT)。

LDAP采用树状结构存储数据（类似于前面学习的DNS服务程序），用于在IP网络层面实现对分布式目录的访问和管理操作，**条目**是LDAP协议中最基本的元素，可以想象成字典中的单词或者数据库中的记录，通常对LDAP服务程序的添加、删除、更改、搜索都是以条目为基本对象的。
 ![第23章 使用OpenLDAP部署目录服务。第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/wp-content/uploads/2015/09/ldap存储结构1.png)

**LDAP树状结构存储数据**

> dn:每个条目的唯一标识符，如上图中linuxprobe的dn值是：
>
> ```
> cn=linuxprobe,ou=marketing,ou=people,dc=mydomain,dc=org
> ```
>
> rdn:一般为dn值中最左侧的部分，如上图中linuxprobe的rdn值是：
>
> ```
> cn=linuxprobe
> ```
>
> base DN:此为基准DN值，表示顶层的根部，上图中的base DN值是：
>
> ```
> dc=mydomain,dc=org
> ```

而每个条目可以有多个属性（如姓名、地址、电话等），每个属性中会保存着对象名称与对应值，LDAP已经为运维人员对常见的对象定义了属性，其中有：

| 属性名称               | 属性别名 | 语法             | 描述             | 值（举例）           |
| ---------------------- | -------- | ---------------- | ---------------- | -------------------- |
| commonName             | cn       | Directory String | 名字             | sean                 |
| surname                | sn       | Directory String | 姓氏             | Chow                 |
| organizationalUnitName | ou       | Directory String | 单位（部门）名称 | IT_SECTION           |
| organization           | o        | Directory String | 组织（公司）名称 | linuxprobe           |
| telephoneNumber        |          | Telephone Number | 电话号码         | 911                  |
| objectClass            |          |                  | 内置属性         | organizationalPerson |




## 适合存放于LDAP中的数据
>* 数据对象相对较小
>* 数据库可被广泛复制与缓存
>* 信息是基于属性的
>* 频繁读取数据，但很少写数据
>* 搜索是一种常用的操作

## LDAP层次结构常见属性

| 属性 | 代表 | 含义 |
|----|----|----|
| o | 机构 | 经常标识一个站点的顶级条目 |
| ou | 机构单元 | 逻辑上的组成部分 |
| cn | 常用名 | 表示条目的最自然的名字 |
| dc | 域名成分 | 用在以DNS为模型建立LDAP层次结构的站点 |
| objectClass | 对象类 | 该条目的属性所遵循的模式 |

## 确定管理信息源的优先级
/etc/nsswitch.conf(AIX:/etc/netsvc.conf)
信息源：nis,nisplus,files,dns,ldap,compat(NIS化的纯文件)  
可在某个信息源后的中括号内明确的定义它“失败”后的动作。例如：  
*hosts: dns [NOTFOUND=xxxx] files*  
*xxxx=[return/continue]*

**失败模式**  

| 条件 | 含义 |
|----|----|
| UNAVAIL | 信息源不存在或者已关闭 |
| NOTFOUND | 信息源存在，但不能回答查询 |
| TRYAGAIN | 信息源存在，但出于忙状态 |
| SUCCESS | 信息源能够回答查询 |
## nscd(name service cache daemon)
过期时间：  
passwd —— 10分钟  
hosts —— 1小时  
group —— 1小时
