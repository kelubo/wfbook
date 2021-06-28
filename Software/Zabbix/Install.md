# 安装

[TOC]

## 获取 Zabbix

-  从发行包安装；
-  下载最新的归档源码包并编译；
-  从容器中安装；
-  下载Zabbix 应用。

### 获取ZABBIX源代码

- 从Zabbix官方网站下载发布的稳定版本

- 从Zabbix官方网站开发人员页面下载每晚构建版本

- 从Git源代码存储库系统获取最新的开发版本

   https://git.zabbix.com/scm/zbx/zabbix.git

-  主版本和受支持的版本也映射到Github

​        https://github.com/zabbix/zabbix

## 安装要求

### 硬件

#### 内存和磁盘

刚接触 Zabbix，128 MB 的物理内存和 256 MB 的可用磁盘空间可能是一个很好的起点。

每个 Zabbix 守护程序进程都需要与数据库服务器建立多个连接。 为连接分配的内存量取决于数据库引擎的配置。

#### CPU

Zabbix，尤其是 Zabbix 数据库可能需要大量 CPU 资源，该具体取决于被监控参数的数量和所选的数据库引擎。

#### 其他硬件

如果需要启用短信（SMS）通知功能，需要串行通讯口（serial communication port）和串行GSM调制解调器（serial GSM modem）。USB转串行转接器也同样可以工作。

#### 硬件资源配置参考

| 规模     | 平台                    | CPU/内存          | 数据库                                 | 受监控的主机数量 |
| -------- | ----------------------- | ----------------- | -------------------------------------- | ---------------- |
| *小型*   | CentOS                  | Virtual Appliance | MySQL InnoDB                           | 100              |
| *中型*   | CentOS                  | 2 CPU cores/2GB   | MySQL InnoDB                           | 500              |
| *大型*   | RedHat Enterprise Linux | 4 CPU cores/8GB   | RAID10 MySQL InnoDB 或 PostgreSQL      | >1000            |
| *极大型* | RedHat Enterprise Linux | 8 CPU cores/16GB  | Fast RAID10 MySQL InnoDB 或 PostgreSQL | >10000           |

如果是进行大规模部署，强烈建议将数据库独立部署。

### 受支持的平台

-  Linux
-  IBM AIX 
-  FreeBSD 
-  NetBSD
-  OpenBSD 
-  HP-UX 
-  Mac OS X 
-  Solaris
-  Windows：自 XP 以来的所有桌面和服务器版本（仅限 Zabbix agent）

如果使用加密编译，Zabbix将禁用核心转储（Core dumps），如果系统不允许禁用核心转储，则 Zabbix 不会启动。

### 软件

#### 数据库管理系统

| 数据库       | 版本           | 备注                                                         |
| ------------ | -------------- | ------------------------------------------------------------ |
| *MySQL*      | 5.0.3 - 8.0.x  | 使用 MySQL 作为 Zabbix 后端数据库。需要InnoDB引擎。  MariaDB 同样支持。 |
| *Oracle*     | 10g or later   | 使用 Oracle 作为 Zabbix 后端数据库。                         |
| *PostgreSQL* | 8.1 or later   | 使用 PostgreSQL  作为 Zabbix 后端数据库。   建议使用 PostgreSQL 8.3 以上的版本, 以提供更好的VACUUM性能。 |
| *IBM DB2*    | 9.7 or later   | 使用 DB2 作为 Zabbix 后端数据库。对于 IBM DB2 的支持是实验性的。 |
| *SQLite*     | 3.3.5 or later | 只有 Zabbix proxy 支持 SQLite ，可以使用 SQLite 作为 Zabbix proxy 数据库。 |

#### 前端

Zabbix 前端需要使用下列软件:

| 软件         | 版本          | 备注                                                         |
| ------------ | ------------- | ------------------------------------------------------------ |
| *Apache*     | 1.3.12 或以上 |                                                              |
| *PHP*        | 5.4.0 或以上  |                                                              |
| PHP 扩展库： |               |                                                              |
| *gd*         | 2.0 or later  | PHP GD 扩展库必须支持 PNG 图像(*--with-png-dir*)、JPEG 图像 (*--with-jpeg-dir*) 和 FreeType 2  (*--with-freetype-dir*). |
| *bcmath*     |               | php-bcmath (*--enable-bcmath*)                               |
| *ctype*      |               | php-ctype (*--enable-ctype*)                                 |
| *libXML*     | 2.6.15 或以上 | php-xml or php5-dom，如果发布者提供独立的部署包。            |
| *xmlreader*  |               | php-xmlreader，如果发布者提供独立的部署包。                  |
| *xmlwriter*  |               | php-xmlwriter，如果发布者提供独立的部署包。                  |
| *session*    |               | php-session，如果发布者提供独立的部署包。                    |
| *sockets*    |               | php-net-socket (*--enable-sockets*) 。用户脚本支持所需要的组件。 |
| *mbstring*   |               | php-mbstring (*--enable-mbstring*)                           |
| *gettext*    |               | php-gettext (*--with-gettext*)。用于多语言翻译支持。         |
| *ldap*       |               | php-ldap。只有在前端使用 LDAP 认证时才需要。                 |
| *ibm_db2*    |               | 使用 IBM DB2 作为 Zabbix 后端数据库所需要的组件。            |
| *mysqli*     |               | 使用 MySQL 作为 Zabbix 后端数据库所需要的组件。              |
| *oci8*       |               | 使用 Oracle 作为 Zabbix 后端数据库所需要的组件。             |
| *pgsql*      |               | 使用 PostgreSQL 作为 Zabbix 后端数据库所需要的组件。         |

值得注意的是，如果需要使用默认 DejaVu 以外的字体, 可能会需要 PHP 的 imagerotate 函数。如果缺少，则在 Zabbix 前端查看图形时显示异常。该函数只有在使用捆绑的 GD 库编译 PHP 时才可用。在 Debian 和某些发行版本中，这个问题不存在。 

#### 客户端浏览器

浏览器必须启用 Cookies 和 Java Script 。

支持最新版本的 Google、Mozilla Firefox、Microsoft Internet Explorer 和 Opero。其他浏览器（Apple Safari、Konqueror）也许会支持。

值得注意的，为了执行 IFrame 的“同源政策”，意味着 Zabbix 不能放在不同域的 frames 中。

但是，如果放置在 frames 中的页面和 Zabbix 前端位于同一个域中，则置于 Zabbix frames 中的页面将可以访问 Zabbix 前端（通过JavaScript）。像 `http://secure-zabbix.com/cms/page.html` 这样的页面，如果置于 `http://secure-zabbix.com/zabbix/` 的聚合图形或仪表盘上，将拥有对 Zabbix 的完整 JS 访问权限。

#### 服务端

始终需要强制性要求。支持特定功能需要可选要求

| 要求         | 状态   | 描述                                                         |
| ------------ | ------ | ------------------------------------------------------------ |
| *libpcre*    | 强制性 | Perl兼容正则表达式 (PCRE) 支持需要PCRE库。命名可能因GNU / Linux发行版而异，例如'libpcre3'或'libpcre1'。请注意，您确实需要PCRE（v8.x）；不使用PCRE2（v10.x）库 |
| *libevent*   |        | 对于批量指标支持和IPMI监视是必需的。1.4版或更高版本。请注意，对于Zabbix代理，此要求是可选的。IPMI监视支持需要它 |
| *libpthread* |        | 互斥锁和读写锁支持                                           |
| *zlib*       |        | 需要压缩支持                                                 |
| *OpenIPMI*   | 可选   | IPMI支持时需要                                               |
| *libssh2*    |        | 支持SSH时需要。1.0或更高版本                                 |
| *fping*      |        | 支持 ICMP ping items 时需要                                  |
| *libcurl*    |        | 用于web监控、VMware监控、SMTP认证。对于SMTP身份验证，需要7.20.0或更高版本。Elasticsearch也需要 |
| *libiksemel* |        | Jabber支持时需要                                             |
| *libxml2*    |        | VMware监控时需要                                             |
| *net-snmp*   |        | 支持SNMP时需要                                               |

#### Java gateway

如果从源码存储库或归档中获取 Zabbix，则在源代码树中已包含必需的依赖关系。

如果从发行包中获取 Zabbix ，则封装系统里已提供了必要的依赖关系。

下表列出了原始代码中当前与 Java gateway 捆绑在一起的 JAR 文件：

| 库                           | 网站                                                         | 备注                                                         |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| *logback-core-0.9.27.jar*    | http://logback.qos.ch/                                       | 0.9.27、1.0.13 和 1.1.1 测试通过。                           |
| *logback-classic-0.9.27.jar* | http://logback.qos.ch/                                       | 0.9.27、1.0.13 和 1.1.1 测试通过。                           |
| *slf4j-api-1.6.1.jar*        | http://www.slf4j.org/                                        | 1.6.1、1.6.6 和 1.7.6 测试通过                               |
| *android-json-4.3_r3.1.jar*  | https://android.googlesource.com/platform/libcore/+/master/json | 2.3.3_r1.1 和 4.3_r3.1 测试通过。关于创建 JAR 文件，详见 src/zabbix_java/lib/README 说明。 |

Java gateway 使用 Java 1.6 及更高版本编译和运行。 如需要对 Java gateway 预编译版本进行编译，建议使用Java 1.6进行编译，直到最新版本。

### 数据库容量

Zabbix 配置文件数据需要固定数量的磁盘空间，且增长不大。

Zabbix 数据库大小主要取决于这些变量，这些变量决定了存储的历史数据量:

- 每秒处理值的数量

  这是 Zabbix server 每秒接收的新值的平均数。 例如，如果有3000个监控项用于监控，取值间隔为60秒，则这个值的数量计算为 3000/60 =  **50** 。这意味着每秒有 50 个新值被添加到 Zabbix 数据库中。

- 关于历史数据的管家设置

  Zabbix 将接收到的值保存一段固定的时间，通常为几周或几个月。 每个新值都需要一定量的磁盘空间用于数据和索引。所以，如果我们每秒收到 50 个值，且希望保留 30 天的历史数据，值的总数将大约在 (**30***24*3600)* **50** = 129.600.000，即大约 130M 个值。

  根据所使用的数据库引擎，接收值的类型（浮点数、整数、字符串、日志文件等），单个值的磁盘空间可能在 40 字节到数百字节之间变化。 通常，数值类型的每个值大约为 90 个字节。

  在上面的例子中，这意味着 130M 个值需要占用 130M * 90 bytes = **10.9GB** 磁盘空间。

  文本和日志类型的监控项值的大小是无法确定的，但可以以每个值大约 500 字节来计算。

- 趋势数据的管家设置

  Zabbix 为表 **trends** 中的每个项目保留1小时的最大值 / 最小值 / 平均值 / 统计值。 该数据用于趋势图形和历史数据图形。 这一个小时的时间段是无法自定义。

  Zabbix数据库，根据数据库类型，每个值总共需要大约90个字节。

  假设我们希望将趋势数据保持5年。 3000 个监控项的值每年需要占用 3000*24*365* **90** = **2.2GB** 空间，或者5年需要占用 **11GB** 空间。

- 事件的管家设置

  每个 Zabbix 事件需要大约 170 个字节的磁盘空间。 很难估计 Zabbix 每天生成的事件数量。 在最坏的情况下，假设 Zabbix 每秒生成一个事件。

  这意味着如果想要保留3年的事件，这将需要占用 **3***365*24*3600* **170** = **15GB** 的空间。

下表包含可用于计算 Zabbix 系统所需磁盘空间的公式：

| 参数              | 所需磁盘空间的计算公式 （单位：字节）                        |
| ----------------- | ------------------------------------------------------------ |
| *Zabbix 配置文件* | 固定大小。通常为 10MB 或更少。                               |
| *History*         | days*(items/refresh rate)*24*3600*bytes  items：监控项数量。  days：保留历史数据的天数。  refresh rate：监控项的更新间隔。  bytes：保留单个值所需要占用的字节数，依赖于数据库引擎，通常为 ~90 字节。 |
| *Trends*          | days*(items/3600)*24*3600*bytes  items：监控项数量。  days：保留历史数据的天数。  bytes：保留单个趋势数据所需要占用的字节数，依赖于数据库引擎，通常为 ~90 字节。 |
| *Events*          | days*events*24*3600*bytes  events：每秒产生的事件数量。假设最糟糕的情况下，每秒产生 1 个事件。  days：保留历史数据的天数。  bytes：保留单个趋势数据所需的字节数，取决于数据库引擎，通常为 ~170 字节。 |

根据使用 MySQL 后端数据库的实际统计数据中收集到的平均值，例如监控项为数值类型的值约 90 个字节，事件约 170 个字节。

因此，所需要的磁盘总空间按下列方法计算：

**配置文件数据+ 历史数据+ 趋势数据+ 事件数据**

在安装 Zabbix 后不会立即使用磁盘空间。 数据库大小取决于管家设置，在某些时间点增长或停止增长。

### 时间同步

如果时间未同步，Zabbix将在建立数据连接之后，根据得到的客户端和服务器的时间戳，并通过客户端和服务器的时间差对获得值的时间戳进行调整，将获得值的时间戳转化为 Zabbix server 的时间。 为了尽可能简化并且避免可能的并发问题出现，网络延迟将会被忽略。因此，通过主动连接（active  agent, active proxy, sender）获得的时间戳数据将包含网络延迟，通过被动连接（passive  proxy）获得的数据已经减去了网络延迟。所有其他监控类型都在服务器时间里完成，并且不会调整其时间戳。

## 安全设置 Zabbix 的最佳实践



### 概述

本章节包含为了以安全的方式设置 Zabbix 应遵守的最佳实践。

Zabbix 的功能不依赖于此处的实践。但建议使用它们以提高系统的安全性。

### 原则最小特权

Zabbix应该始终使用最小特权原则。 此原则意味着用户帐户（在Zabbix前端中）或流程用户（对于Zabbix server/proxy或agent）仅具有执行预期功能所必需的特权。 换句话说，用户帐户始终应以尽可能少的特权运行

授予“ zabbix”用户额外的权限将使其能够访问配置文件并执行可能损害基础架构整体安全性的操作。

在为用户帐户实现最小特权原则时，应考虑Zabbix[前端用户类型](https://www.zabbix.com/documentation/5.0/manual/config/users_and_usergroups/permissions)。 重要的是要理解，尽管“ Zabbix Admin”用户类型的特权比“ Zabbix Super Admin”用户类型少，但它具有允许管理配置和执行自定义脚本的管理权限

某些信息甚至适用于非特权用户。 例如，虽然“管理”→“脚本”不适用于非超级管理员，但脚本本身可用于使用Zabbix API进行检索。 应使用限制脚本权限且不添加敏感信息（例如访问凭据等）的方法，以避免暴露全局脚本中可用的敏感信息

### Zabbix agent 的安全用户

在默认的配置中，Zabbix server 和 Zabbix agent 进程共享一个“zabbix”用户。 如果您希望确保 Zabbix  agent 无法访问 Zabbix server 配置中的敏感详细信息（例如，数据库登录信息），则应以不同的用户身份运行 Zabbix  agent：

1.  创建一个安全用户；

1.  在 Zabbix agent 的 [配置文件](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_agentd) 中指定此用户（修改 'User' parameter）；

1.  以拥有管理员权限的用户重启 Zabbix agent。之后，此权限将赋予给先前指定的用户。

### utf-8编码

UTF-8是Zabbix支持的唯一编码。 它可以正常工作而没有任何安全漏洞。 用户应注意，如果使用其他一些编码，则存在已知的安全问题

### 为 Zabbix 前端设置 SSL

在 RHEL/Centos 操作系统上，安装 mod_ssl 包：

```
yum install mod_ssl
```

为 SSL keys 创建目录：

```
mkdir -p /etc/httpd/ssl/private
chmod 700 /etc/httpd/ssl/private
```

创建 SSL 证书：

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/private/apache-selfsigned.key -out /etc/httpd/ssl/apache-selfsigned.crt
```

下面提示内容适当填写。 最重要的一行是请求 Common Name 的行。 您需要输入要与服务器关联的域名。 如果您没有域名，则可以输入公共IP地址。 下面将使用 *example.com*。

```
Country Name (两个字母) [XX]:
State or Province Name (全名) []:
Locality Name (eg, city) [默认的城市]:
Organization Name (eg, company) [默认的公司名]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:example.com
Email Address []:
```

编辑 Apache SSL 配置：

```
/etc/httpd/conf.d/ssl.conf
DocumentRoot "/usr/share/zabbix"
ServerName example.com:443
SSLCertificateFile /etc/httpd/ssl/apache-selfsigned.crt
SSLCertificateKeyFile /etc/httpd/ssl/private/apache-selfsigned.key
```

重启 Apache 服务使以上修改的配置生效：

```
systemctl restart httpd.service
```

### 在 URL 的根目录上启用 Zabbix

将虚拟主机添加到 Apache 配置，并将文档根目录的永久重定向设置为 Zabbix SSL URL。 不要忘记将 *example.com* 替换为服务器的实际名称。

```
/etc/httpd/conf/httpd.conf
```



```
#Add lines

<VirtualHost *:*>
    ServerName example.com
    Redirect permanent / http://example.com
</VirtualHost>
```



重启 Apache 服务使以上修改的配置生效：

```
systemctl restart httpd.service
```

### 在Web服务器上启用HTTP严格传输安全性（HSTS）

为了保护Zabbix前端不受协议降级攻击，我们建议在Web服务器上启用[HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security)策略

例如，要在Apache配置中为您的Zabbix前端启用HSTS策略：

```
/etc/httpd/conf/httpd.conf
```

将以下指令添加到虚拟主机的配置中：

```
<VirtualHost *:443>
 Header set Strict-Transport-Security "max-age=31536000"
</VirtualHost>
```

重新启动Apache服务以应用更改：

```
systemctl restart httpd.service
```

### 在Web服务器上启用内容安全策略（CSP）

为了保护Zabbix前端免受跨站点脚本（XSS），数据注入和其他类似类型的攻击的影响，我们建议在Web服务器上启用内容安全策略。 为此，您需要配置Web服务器以返回[Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) HTTP标头

要在Apache配置中为您的Zabbix前端启用CSP，请编辑：

```
/etc/httpd/conf/httpd.conf
```

例如，如果计划所有内容都来自站点的来源（不包括子域），则可以将以下指令添加到虚拟主机的配置中：

```
<VirtualHost *:*>
 Header set Content-Security-Policy "default-src 'self';"
</VirtualHost>
```

重新启动Apache服务以应用更改：

```
systemctl restart httpd.service
```

### 禁用曝光的 Web 服务器信息

建议在 Web 服务器强化过程中禁用所有 Web 服务器签名。 默认情况下，Web 服务器正在公开软件签名：

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/requirements/software_signature.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/requirements/software_signature.png?id=zh%3Amanual%3Ainstallation%3Arequirements%3Abest_practices)

可以通过向 Apache（用作示例）配置文件添加两行来禁用签名：

```
ServerSignature Off
ServerTokens Prod
```

可以通过更改 php.ini 配置文件来禁用 PHP 签名（X-Powered-By HTTP header）（默认情况下禁用签名）：

```
expose_php = Off
```

若要应用配置文件更改，需要重新启动 Web 服务器。

通过在 Apache中 使用 mod_security（ libapache2-mod-security2）可以实现额外的安全级别。  mod_security 允许删除服务器签名，而不是仅仅从服务器签名中删除版本。 通过在安装 mod_security  之后将“SecServerSignature”更改为任何所需的值，可以将签名更改为任何值。

请参阅 Web 服务器的文档以获取有关如何删除/更改软件签名的帮助。

### 禁用默认Web服务器错误页面

建议禁用默认错误页面以避免信息泄露。 Web服务器默认使用内置错误页面：

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/requirements/error_page.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/requirements/error_page.png?id=zh%3Amanual%3Ainstallation%3Arequirements%3Abest_practices)

在Web服务器强化过程中，应替换/删除默认错误页面。 “ ErrorDocument”指令可用于为Apache Web服务器定义自定义错误页面/文本（用作示例）

请参考Web服务器的文档以找到有关如何替换/删除默认错误页面的帮助

### 删除 Web 服务器的测试页面

建议删除 Web 服务器测试页以避免信息泄露。 默认情况下，Web 服务器的 webroot 包含一个名为 index.html 的测试页（以Ubuntu上的 Apache2 为例）：

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/requirements/test_page.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/requirements/test_page.png?id=zh%3Amanual%3Ainstallation%3Arequirements%3Abest_practices)

应删除测试页面，或者应将其作为Web服务器强化过程的一部分使用。

### 在sandbox中显示URL内容

从5.0.2版开始，一些Zabbix前端元素（例如[URL小部件](https://www.zabbix.com/documentation/5.0/manual/web_interface/frontend_sections/monitoring/dashboard/widgets#url)）已预先配置为从URL检索的sandbox内容。 建议保持所有sandbox限制处于启用状态，以确保免受XSS攻击。

### 带有OPENSSL的在Windows上的zabbix agent

使用OpenSSL编译的Zabbix agent将尝试在c：\ openssl-64bit中访问SSL配置文件。 磁盘C：上的“ openssl-64bit”目录可以由非特权用户创建

因此，为了加强安全性，需要手动创建此目录并撤消非管理员用户的写访问权限

请注意，在Windows的32位和64位版本上，目录名称将有所不同

## 从源代码包安装

您可以通过从源代码编译来获取最新版本的 Zabbix。

这里提供了从源代码安装 Zabbix 的具体步骤。

### 1 安装 Zabbix 守护进程



#### 1 下载源代码存档

转到 [Zabbix download page](https://www.zabbix.com/download_sources) 下载源代码存档。待下载完毕后，执行以下命令解压缩源代码存档：

```
$ tar -zxvf zabbix-5.0.0.tar.gz
```

请在命令中输入正确的 Zabbix 版本。 它必须与下载的存档的名称匹配。

#### 2 创建用户账户

对于所有 Zabbix 守护进程，需要一个非特权用户。 如果从非特权用户帐户启动 Zabbix 守护程序，它将以该用户身份运行。

然而，如果一个守护进程以“root”启动，它会切换到“zabbix”用户，且这个用户必须存在。在 Linux 系统中，可以使用下面命令建立一个用户（该用户属于自己的用户组，“zabbix”）

在基于RedHat的系统上，运行：

```
groupadd --system zabbix
useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix
```

在基于Debian的系统上，运行：

```
addgroup --system --quiet zabbix
adduser --quiet --system --disabled-login --ingroup zabbix --home /var/lib/zabbix --no-create-home zabbix
```

Zabbix进程不需要主目录，这就是为什么我们不建议创建它的原因。 但是，如果您使用某些需要它的功能（例如，将MySQL凭据存储在$ HOME / .my.cnf中），则可以使用以下命令自由创建它。 在基于RedHat的系统上，运行：

```
mkdir -m u=rwx,g=rwx,o= -p /usr/lib/zabbix
chown zabbix:zabbix /usr/lib/zabbix
```

在基于Debian的系统上，运行：

```
mkdir -m u=rwx,g=rwx,o= -p /var/lib/zabbix
chown zabbix:zabbix /var/lib/zabbix
```

而对于 Zabbix 前端安装，并不需要单独的用户帐户。

如果 Zabbix [server](https://www.zabbix.com/documentation/5.0/manual/concepts/server) 和 [agent](https://www.zabbix.com/documentation/5.0/manual/concepts/agent) 运行在相同的机器上，建议使用不同的用户运行来 Zabbix server 和 agent。 否则，如果两者都作为同一用户运行，则 Zabbix agent 可以访问 Zabbix server 配置文件，并且可以轻松检索到 Zabbix 中的任何管理员级别的用户，例如，数据库密码。

以 `root` 、`bin` 或其他具有特殊权限的账户运行 Zabbix 是非常危险的。

#### 3 创建 Zabbix 数据库

对于 Zabbix [server](https://www.zabbix.com/documentation/5.0/manual/concepts/server) 和 [proxy](https://www.zabbix.com/documentation/5.0/manual/concepts/proxy) 守护进程以及 Zabbix 前端，必须需要一个数据库。但是 Zabbix [agent](https://www.zabbix.com/documentation/5.0/manual/concepts/agent) 并不需要。

SQL [脚本](https://www.zabbix.com/documentation/5.0/manual/appendix/install/db_scripts) 用于创建数据库 schema 和插入 dataset。Zabbix proxy 数据库只需要数据库 schema，而 Zabbix server 数据库在建立数据库 schema 后，还需要 dataset。 

当创建数据库后，继续执行编译 Zabbix 的步骤。

#### 4 配置源代码

当配置 Zabbix server 或者 proxy 的源代码时，需要指定所使用的数据库类型。一次只能使用 Zabbix server 或 Zabbix proxy 进程编译一种数据库类型。

如果要查看所有受支持的配置选项，请在解压缩的 Zabbix 源代码目录中运行：

```
./configure --help
```

如果要配置 Zabbix server 和 Zabbix proxy 的源代码，您可以运行以下内容：

```
./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2
```

如果要配置 Zabbix server 的源代码（使用 PostgreSQL 等），您可以运行：

```
./configure --enable-server --with-postgresql --with-net-snmp
```

如果要配置 Zabbix proxy 的源代码（使用 SQLite 等），您可以运行：

```
./configure --prefix=/usr --enable-proxy --with-net-snmp --with-sqlite3 --with-ssh2
```

如果要配置 Zabbix agent 的源代码，您可以运行：

```
./configure --enable-agent
```

或者，Zabbix agent 2：

```
./configure --enable-agent2
```

有关编译选项的注意事项：

-  如果使用–enable-agent选项，则会编译命令行实用程序zabbix_get和zabbix_sender
-  虚拟机监视需要–with-libcurl和–with-libxml2配置选项； SMTP验证和web.page也需要–with-libcurl。* Zabbix代理[项目](https://www.zabbix.com/documentation/5.0/zh/manual/config/items/itemtypes/zabbix_agent)。 请注意，使用–with-libcurl配置选项[需要](https://www.zabbix.com/documentation/5.0/zh/manual/installation/requirements)cURL 7.20.0或更高版本
-  Zabbix始终使用PCRE库进行编译（从3.4.0版开始）； 安装它不是可选的。 –with-libpcre = [DIR]仅允许指向特定的基本安装目录，而不是在多个常用位置中搜索libpcre文件
-  您可以使用–enable-static标志来静态链接库。 如果计划在不同的服务器之间分发编译的二进制文件，则必须使用此标志来使这些二进制文件在没有必需的库的情况下工作。 请注意，-enable-static在[Solaris](http://blogs.sun.com/rie/entry/static_linking_where_did_it)中不起作用
-  在构建服务器时，不建议使用–enable-static选项。 为了静态构建服务器，您必须具有所需的每个外部库的静态版本。 在配置脚本中没有对此进行严格检查
-  当需要使用不在默认位置的库时，在MySQL配置文件–with-mysql = / <path_to_the_file> / mysql_config中添加可选路径，以选择所需的MySQL客户端库。  当在同一系统上安装了多个版本的MySQL或与MySQL一起安装了MariaDB时，此功能很有用
-  使用–with-oracle标志可以指定OCI API的位置
-  编译Zabbix代理2需要Go版本1.13或更高版本。有关安装说明，请参阅[golang.org](https://golang.org/doc/install)

如果./configure由于缺少库或其他某些情况而失败，请参阅config.log文件以获取有关该错误的更多详细信息。 例如，如果缺少libssl，则立即错误消息可能会引起误解：

```
checking for main in -lmysqlclient... no
configure: error: Not found mysqlclient library
```

尽管config.log有更详细的描述：

```
/usr/bin/ld: cannot find -lssl
/usr/bin/ld: cannot find -lcrypto
```

另请参阅：

-  [使用加密支持编译Zabbix以支持加密](https://www.zabbix.com/documentation/5.0/zh/manual/encryption)
-  [在HP-UX上编译Zabbix agent的已知问题](https://www.zabbix.com/documentation/5.0/zh/manual/installation/known_issues)

#### 5 安装

如果从 git 安装，需要先运行以下命令：

```
$ make dbschema
make install
```

这步需要使用一个拥有足够权限的用户来运行 (如 'root'，或者使用 sudo)。

运行 `make install` 将使用在 /usr/local/sbin 下的守护进程二进制文件（zabbix_server, zabbix_agentd, zabbix_proxy）和在 /usr/local/bin 下的客户端二进制文件进行默认安装。

 如需要指定 /usr/local 以外的位置，可在之前的配置源代码的步骤中使用   --prefix，例如 --prefix=/home/zabbix。在这个案例中，守护进程的二进制文件会被安装在  <prefix>/sbin 下，工具会安装在 <prefix>/bin 下。帮助文件会安装在  <prefix>/share 下。

#### 6 查看和编辑配置文件

-  在此编辑 Zabbix agent 的配置文件 **/usr/local/etc/zabbix_agentd.conf** 

您需要为每台安装了 zabbix_agentd 的主机配置这个文件。

您必须在这个文件中指定 Zabbix server 的 **IP 地址** 。若从其他主机发起的请求会被拒绝。

-  在此编辑 Zabbix server 的配置文件 **/usr/local/etc/zabbix_server.conf**

您必须指定数据库的名称、用户和密码（如果使用的话）。

如果您进行小型环境部署（最多十个受监控主机），其余参数的默认值将适合您的环境。 如果要最大化 Zabbix server（或 proxy）的性能，则应更改默认参数。 详见[性能调整](https://www.zabbix.com/documentation/5.0/manual/appendix/performance_tuning)。

-  如果您安装了 Zabbix proxy，请在此编辑 proxy 的配置文件 **/usr/local/etc/zabbix_proxy.conf**

您必须指定 Zabbix server 的 IP 地址和 Zabbix proxy 主机名（必须被 Zabbix server 识别），同时也要指定数据库的名称、用户和密码（如果使用的话）。

使用 SQLite 必须指定数据库文件的完整路径；数据库用户和密码不是必须的。

##### 7 启动守护进程

在 Zabbix server 端运行 zabbix_server：

```
shell> zabbix_server
```

值得注意的是，确保您的系统允许分配 36MB（或更多）的共享内存，否则 Zabbix  server 将无法启动，并会在 Zabbix server 日志文件中看到 “Cannot allocate shared memory  for <type of cache>.” 这样的报错信息。这可能会发生在 FreeBSD 和 Solaris 8 上。
 详见本页底部的 ["另请参阅"](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install#see_also) 部分，了解如何配置共享内存。.

在受监控的主机上运行 zabbix_agentd：

```
shell> zabbix_agentd
```

值得注意的是，请确保您的系统允许分配 2MB 的共享内存，否则 Zabbix agent  可能会无法运行，并会在 Zabbix agent 日志文件中看到 “Cannot allocate shared memory for  collector.” 这样的报错信息。这可能会发生在 Solaris 8 上。

如果您安装了 Zabbix proxy，请运行 zabbix_proxy：

```
shell> zabbix_proxy
```

### 2 安装 Zabbix web 界面

请参阅[Web界面安装](https://www.zabbix.com/documentation/5.0/zh/manual/installation/frontend)页面以获取有关Zabbix web安装向导的信息

#### 复制 PHP 文件

Zabbix 前端是 PHP 编写的，所以必须运行在支持 PHP 的 Web 服务器上。只需要简单的从 frontends/php 路径下复制 PHP 文件到 Web 服务器的 HTML 文档目录，即可完成安装。

Apache Web 服务器的 HTML 文档目录通常包括：

-  /usr/local/apache2/htdocs （从源代码安装 Apache 的默认目录）
-  /srv/www/htdocs (OpenSUSE, SLES)
-  /var/www/html (Debian, Ubuntu, Fedora, RHEL, CentOS)

建议使用子目录替代 HTML 根目录。可以使用下列命令，以创建一个子目录并复制 Zabbix 的前端文件到这个目录下（注意替换为实际的目录）：

```
mkdir <htdocs>/zabbix
cd frontends/php
cp -a . <htdocs>/zabbix
```

如果准备从 git 安装英语以外的语言，您必须生成翻译文件。可以运行下列命令：

```
locale/make_mo.sh
```

需要来自 gettext 安装包的 `msgfmt` 组件。

此外，使用英语以外的语言，需要在 Web 服务器上安装该语言对应的 locale 。详见“用户文件”页面中的 ["另请参阅"](https://www.zabbix.com/documentation/5.0/manual/web_interface/user_profile#see_also) 板块，以寻找如何安装它（如果需要的话）。

#### 安装前端



### 3安装JAVA GATEWAY

仅当您要监视JMX应用程序时才需要安装Java gateway。 Java gateway是轻量级的，不需要数据库

要从源代码安装，请首先[下载](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install)并解压缩源归档文件

要编译Java gateway，请使用–enable-java选项运行./configure脚本。 建议您指定–prefix选项来请求默认的/ usr / local以外的安装路径，因为安装Java gateway会创建整个目录树，而不仅仅是一个可执行文件

```
$ ./configure --enable-java --prefix=$PREFIX
```

要将Java gateway编译并打包到JAR文件中，请运行make。 请注意，对于此步骤，您将在路径中需要javac和jar可执行文件

```
$ make
```

现在，您在src / zabbix_java / bin中有一个zabbix-java-gateway- $ VERSION.jar文件。  如果您可以从分发目录中的src / zabbix_java运行Java gateway，那么可以继续阅读有关配置和运行[Java gateway](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java)的说明。 否则，请确保您具有足够的特权并运行make install

```
$ make install
```

继续[安装](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java/from_sources)，了解关于配置和运行Java gateway的更多细节



1.  [如何为 Zabbix 守护进程配置共享内存](http://www.zabbix.org/wiki/How_to/configure_shared_memory)？

在Windows上安装Zabbix agent 2[Old revisions](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install/building_zabbix_agent_2_on_windows?do=revisions)[Backlinks](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install/building_zabbix_agent_2_on_windows?do=backlink)[Export to PDF](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install/building_zabbix_agent_2_on_windows?do=export_pdf)[Back to top](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install/building_zabbix_agent_2_on_windows#dokuwiki__top)



### 概述

本节演示如何从源代码安装Zabbix agent 2 (Windows)

### 安装MinGW编译器

\1. 下载带有SJLJ(set jump/long jump)异常处理和Windows线程的MinGW-w64 (例如 *x86_64-8.1.0-release-win32-sjlj-rt_v6-rev0.7z*) 
 \2. 提取并移动到 *c:\mingw* 
 \3. 设置环境变量 

```
@echo off
set PATH=%PATH%;c:\bin\mingw\bin
cmd
```

编译时使用Windows提示符而不是MinGW提供的MSYS终端

#### 编译PCRE开发库

下面的说明将编译和安装64位的PCRE库 *c:\dev\pcre* 和32位库 *c:\dev\pcre32*：

\1. 从pcre.org下载PCRE库版本8.XX ([ftp://ftp.pcre.org/pub/pcre/](ftp://ftp.pcre.org/pub/pcre/)) 并提取 
 \2. 打开 *cmd* 并导航到提取的源

#### 安装64位PCRE

\1. 删除旧的配置/缓存（如果存在）：

```
del CMakeCache.txt
rmdir /q /s CMakeFiles
```

\2. 运行 cmake (可从https://cmake.org/download/安装CMake):

```
cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=gcc -DCMAKE_C_FLAGS="-O2 -g" -DCMAKE_CXX_FLAGS="-O2 -g" -DCMAKE_INSTALL_PREFIX=c:\dev\pcre
```

\3. 接下来执行:

```
mingw32-make clean
mingw32-make install
```

#### 安装32位PCRE

\1. 执行: 

```
mingw32-make clean
```

\2. 删除 *CMakeCache.txt*:

```
del CMakeCache.txt
rmdir /q /s CMakeFiles
```

\3. 执行 cmake:

```
cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=gcc -DCMAKE_C_FLAGS="-m32 -O2 -g" -DCMAKE_CXX_FLAGS="-m32 -O2 -g" -DCMAKE_EXE_LINKER_FLAGS="-Wl,-mi386pe" -DCMAKE_INSTALL_PREFIX=c:\dev\pcre32
```

\4. 接下来执行:

```
mingw32-make install
```

#### 安装OpenSSL开发库

\1. 从https://bintray.com/vszakats/generic/openssl/1.1.1d下载32和64位版本 
 \2. 分别将文件解压缩到 *c:\dev\openssl32* 和 *c:\dev\openssl* 目录中 
 \3. 之后，删除提取的 **.dll.a* (dll调用包装库) ，因为MinGW优先于静态库

### 编译Zabbix agent 2



#### 32位

打开MinGW环境（Windows命令提示符），然后导航到Zabbix源代码树中的 *build/mingw* 目录

执行:

```
mingw32-make clean
mingw32-make ARCH=x86 PCRE=c:\dev\pcre32 OPENSSL=c:\dev\openssl32
```

#### 64位

打开MinGW环境（Windows命令提示符），然后导航到Zabbix源代码树中的 build/mingw 目录

执行:

```
mingw32-make clean
mingw32-make PCRE=c:\dev\pcre OPENSSL=c:\dev\openssl
```

 32位和64位版本都可以在64位平台上构建，但是只能在32位平台上构建32位版本。 在32位平台上工作时，请遵循与64位平台上64位版本相同的步骤 

### 在macOS上安装zabbix agent



本节演示如何从包含或不包含TLS的源代码安装Zabbix agent二进制文件(macOS)

### 先决条件

您将需要命令行开发人员工具（不需要Xcode），Automake，pkg-config和PCRE（v8.x） 如果要使用TLS构建agent二进制文件，则还需要OpenSSL或GnuTLS

要安装Automake和pkg-config，您将需要来自https://brew.sh/的Homebrew软件包管理器。 要安装它，请打开终端并运行以下命令：

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

然后安装Automake和pkg-config：

```
$ brew install automake
$ brew install pkg-config
```

准备PCRE，OpenSSL和GnuTLS库取决于如何将它们链接到agent

如果打算在已经具有这些库的macOS计算机上运行agent二进制文件，则可以使用Homebrew提供的预编译库。 这些通常是使用Homebrew来构建Zabbix agent二进制文件或用于其他目的的macOS计算机

如果agent二进制文件将在没有共享库版本的macOS计算机上使用，则应从源代码编译静态库并将Zabbix agent与它们链接

#### 使用共享库构建agent二进制文件

安装 PCRE:

```
$ brew install pcre
```

使用TLS构建时，请安装OpenSSL和/或GnuTLS:

```
$ brew install openssl
$ brew install gnutls
```

下载Zabbix源码:

```
$ git clone https://git.zabbix.com/scm/zbx/zabbix.git
```

不使用TLS构建agent:

```
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6
$ make
$ make install
```

使用OpenSSL构建agent:

```
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6 --with-openssl=/usr/local/opt/openssl
$ make
$ make install
```

使用GnuTLS构建agent:

```
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6 --with-gnutls=/usr/local/opt/gnutls
$ make
$ make install
```

#### 使用不带TLS的静态库构建agent二进制文件

让我们假设PCRE静态库将安装在“$HOME/static-libs”中。我们将使用PCRE 8.42

```
$ PCRE_PREFIX="$HOME/static-libs/pcre-8.42"
```

下载并构建具有Unicode属性支持的PCRE:

```
$ mkdir static-libs-source
$ cd static-libs-source
$ curl --remote-name https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz
$ tar xf pcre-8.42.tar.gz
$ cd pcre-8.42
$ ./configure --prefix="$PCRE_PREFIX" --disable-shared --enable-static --enable-unicode-properties
$ make
$ make check
$ make install
```

下载Zabbix源代码并构建agent：

```
$ git clone https://git.zabbix.com/scm/zbx/zabbix.git
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6 --with-libpcre="$PCRE_PREFIX"
$ make
$ make install
```

### 使用OpenSSL构建带有静态库的agent二进制文件

构建OpenSSL时，建议在成功构建后运行“make test”。 即使构建成功，测试有时也会失败。 在这种情况下，应进行研究并解决问题，然后再继续

让我们假设PCRE和OpenSSL静态库将安装在“$HOME/static-libs”中。我们将使用PCRE 8.42和OpenSSL 1.1.1a

```
$ PCRE_PREFIX="$HOME/static-libs/pcre-8.42"
$ OPENSSL_PREFIX="$HOME/static-libs/openssl-1.1.1a"
```

让我们在“static-libs-source”中构建静态库:

```
$ mkdir static-libs-source
$ cd static-libs-source
```

下载并构建具有Unicode属性支持的PCRE：

```
$ curl --remote-name https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz
$ tar xf pcre-8.42.tar.gz
$ cd pcre-8.42
$ ./configure --prefix="$PCRE_PREFIX" --disable-shared --enable-static --enable-unicode-properties
$ make
$ make check
$ make install
$ cd ..
```

下载并构建OpenSSL：

```
$ curl --remote-name https://www.openssl.org/source/openssl-1.1.1a.tar.gz
$ tar xf openssl-1.1.1a.tar.gz
$ cd openssl-1.1.1a
$ ./Configure --prefix="$OPENSSL_PREFIX" --openssldir="$OPENSSL_PREFIX" --api=1.1.0 no-shared no-capieng no-srp no-gost no-dgram no-dtls1-method no-dtls1_2-method darwin64-x86_64-cc
$ make
$ make test
$ make install_sw
$ cd ..
```

下载Zabbix源代码并构建agent：

```
$ git clone https://git.zabbix.com/scm/zbx/zabbix.git
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6 --with-libpcre="$PCRE_PREFIX" --with-openssl="$OPENSSL_PREFIX"
$ make
$ make install
```

#### 使用带有GnuTLS的静态库构建agent二进制文件

GnuTLS取决于Nettle加密后端和GMP算术库。 本指南将使用Nettle中包含的mini-gmp，而不是使用完整的GMP库

构建GnuTLS和Nettle时，建议在成功构建后运行“make check”。 即使构建成功，测试有时也会失败。 在这种情况下，应进行研究并解决问题，然后再继续

假设PCRE，Nettle和GnuTLS静态库将安装在“ $ HOME / static-libs”中。 我们将使用PCRE 8.42，Nettle 3.4.1和GnuTLS 3.6.5

```
$ PCRE_PREFIX="$HOME/static-libs/pcre-8.42"
$ NETTLE_PREFIX="$HOME/static-libs/nettle-3.4.1"
$ GNUTLS_PREFIX="$HOME/static-libs/gnutls-3.6.5"
```

让我们在“static-libs-source”中构建静态库:

```
$ mkdir static-libs-source
$ cd static-libs-source
```

下载并构建Nettle：

```
$ curl --remote-name https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz
$ tar xf nettle-3.4.1.tar.gz
$ cd nettle-3.4.1
$ ./configure --prefix="$NETTLE_PREFIX" --enable-static --disable-shared --disable-documentation --disable-assembler --enable-x86-aesni --enable-mini-gmp
$ make
$ make check
$ make install
$ cd ..
```

下载并构建GnuTLS：

```
$ curl --remote-name https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.5.tar.xz
$ tar xf gnutls-3.6.5.tar.xz
$ cd gnutls-3.6.5
$ PKG_CONFIG_PATH="$NETTLE_PREFIX/lib/pkgconfig" ./configure --prefix="$GNUTLS_PREFIX" --enable-static --disable-shared --disable-guile --disable-doc --disable-tools --disable-libdane --without-idn --without-p11-kit --without-tpm --with-included-libtasn1 --with-included-unistring --with-nettle-mini
$ make
$ make check
$ make install
$ cd ..
```

下载Zabbix源代码和构建agent：

```
$ git clone https://git.zabbix.com/scm/zbx/zabbix.git
$ cd zabbix/
$ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
$ ./bootstrap.sh
$ CFLAGS="-Wno-unused-command-line-argument -framework Foundation -framework Security" \
> LIBS="-lgnutls -lhogweed -lnettle" \
> LDFLAGS="-L$GNUTLS_PREFIX/lib -L$NETTLE_PREFIX/lib" \
> ./configure --sysconfdir=/usr/local/etc/zabbix --enable-agent --enable-ipv6 --with-libpcre="$PCRE_PREFIX" --with-gnutls="$GNUTLS_PREFIX"
$ make
$ make install
```

### 在Windows上安装Zabbix agent

本节演示如何从包含或不包含TLS的源代码安装Zabbix agent二进制文件(Windows)

#### 安装OpenSSL

以下步骤将帮助您从MS Windows 10（64位）上的源代码编译OpenSSL

1. 要安装OpenSSL，您将需要在Windows计算机上：

   1.  C compiler (e.g. VS 2017 RC),
   2.  NASM (https://www.nasm.us/),
   3.  Perl (e.g. Strawberry Perl from http://strawberryperl.com/),
   4.  Perl module Text::Template (cpan Text::Template).

2. 从https://www.openssl.org/获取OpenSSL源。 这里使用OpenSSL 1.1.1

3. 解压缩OpenSSL源，例如在E:\openssl-1.1.1

4. 打开命令行窗口，例如 VS 2017 RC的x64本机工具命令提示符

5. 转到OpenSSL源目录，例如E:\openssl-1.1.1

   1. 验证是否可以找到NASM:

      ```
      e:\openssl-1.1.1> nasm --version
      NASM version 2.13.01 compiled on May  1 2017
      ```

6. 例如，配置OpenSSL:

   ```
   e:\openssl-1.1.1> perl E:\openssl-1.1.1\Configure VC-WIN64A no-shared no-capieng no-srp no-gost no-dgram no-dtls1-method no-dtls1_2-method  --api=1.1.0 --prefix=C:\OpenSSL-Win64-111-static --openssldir=C:\OpenSSL-Win64-111-static
   ```

   -  注意选项“ no-shared”：如果使用“  no-shared”，则OpenSSL静态库libcrypto.lib和libssl.lib将是“self-sufficient”，并且所产生的Zabbix二进制文件本身将包括OpenSSL，而无需外部 OpenSSL DLLs。 优点：Zabbix二进制文件无需OpenSSL库即可复制到其他Windows计算机。  缺点：发布新的OpenSSL错误修正版本时，Zabbix agent需要重新编译并重新安装
   -  如果不使用“  no-shared”，则静态库libcrypto.lib和libssl.lib将在运行时使用OpenSSL DLLs。  优点：发布新的OpenSSL错误修正版本时，可能无需升级Zabbix agent即可仅升级OpenSSL DLLs。 缺点：将Zabbix  agent复制到另一台计算机也需要复制OpenSSL DLLs

7. 编译OpenSSL，运行安装，测试:

   ```
   e:\openssl-1.1.1> nmake
   e:\openssl-1.1.1> nmake test
   ...
   All tests successful.
   Files=152, Tests=1152, 501 wallclock secs ( 0.67 usr +  0.61 sys =  1.28 CPU)
   Result: PASS
   e:\openssl-1.1.1> nmake install_sw
   ```

   'install_sw'仅安装软件组件（即库，头文件，但没有文档）。 如果需要所有内容，请使用“ nmake install”

#### 编译PCRE

1. 从pcre.org 8.XX版下载PCRE库（自Zabbix 4.0起为强制性库）；不是pcre2（[ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.zip](ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.zip)）

2. 提取到目录 *E:\pcre-8.41*

3. 从https://cmake.org/download/安装CMake，在安装过程中选择：并确保cmake\bin在您的路径上（经过测试的版本3.9.4）

4. 创建一个新的空构建目录，最好是源目录的子目录。 例如， *E:\pcre-8.41\build*

5. 打开命令行窗口，例如 VS 2017的x64本机工具命令提示符，并从该Shell环境运行cmake-gui。 不要尝试从Windows“开始”菜单启动Cmake，因为这可能会导致错误

6. 输入 *E:\pcre-8.41* 和 *E:\pcre-8.41\build* 作为源目录

7. 点击“Configure”按钮

8. 为该项目指定生成器时，选择“ NMake Makefiles”

9. 创建一个新的空安装目录。 例如， *E:\pcre-8.41-install*

10. 然后，GUI将列出几个配置选项。 确保选择以下选项：

    -  **PCRE_SUPPORT_UNICODE_PROPERTIES** ON
    -  **PCRE_SUPPORT_UTF** ON
    -  **CMAKE_INSTALL_PREFIX**                *E:\pcre-8.41-install*

11. 再次点击“Configure”。 相邻的“Generate”按钮现在应该处于active状态。

12. 点击“Generate”

13. 如果发生错误，建议您在尝试重复CMake构建过程之前删除CMake缓存。 在CMake GUI中，可以通过选择“File > Delete Cache”来删除缓存

14. 现在，构建目录应该包含一个可用的构建系统-Makefile

15. 打开命令行窗口，例如 VS 2017的x64本机工具命令提示符，并导航到上面提到的Makefile

16. 运行NMake命令: 

    ```
    E:\pcre-8.41\build> nmake install
    ```

#### 编译Zabbix

以下步骤将帮助您从MS Windows 10（64位）上的源代码编译Zabbix。 当使用/不支持TLS编译Zabbix时，唯一的不同是在步骤4中

1. 在Linux机器上，检查GIT的来源:

   ```
   $ git clone https://git.zabbix.com/scm/zbx/zabbix.git
   $ cd zabbix/
   $ git checkout 5.0.1 -b 5.0.1 # replace 5.0.1 with the latest release available
   $ ./bootstrap.sh
   $ ./configure --enable-agent --enable-ipv6 --prefix=`pwd`
   $ make dbschema
   $ make dist
   ```

2. 复制并解压缩存档,例如 Windows机器上为zabbix-5.0.0.tar.gz

3. 假设源位于 e:\zabbix-5.0.0中。 打开命令行窗口，例如 VS 2017 RC的x64本机工具命令提示符。转到 E:\zabbix-5.0.0\build\win32\project

4. 编译zabbix_get，zabbix_sender和zabbix_agent

   - 不使用TLS: 

     ```
     E:\zabbix-5.0.0\build\win32\project> nmake /K PCREINCDIR=E:\pcre-8.41-install\include PCRELIBDIR=E:\pcre-8.41-install\lib
     ```

   - 使用TLS: 

     ```
     E:\zabbix-5.0.0\build\win32\project> nmake /K -f Makefile_get TLS=openssl TLSINCDIR=C:\OpenSSL-Win64-111-static\include TLSLIBDIR=C:\OpenSSL-Win64-111-static\lib PCREINCDIR=E:\pcre-8.41-install\include PCRELIBDIR=E:\pcre-8.41-install\lib
     E:\zabbix-5.0.0\build\win32\project> nmake /K -f Makefile_sender TLS=openssl TLSINCDIR="C:\OpenSSL-Win64-111-static\include TLSLIBDIR="C:\OpenSSL-Win64-111-static\lib" PCREINCDIR=E:\pcre-8.41-install\include PCRELIBDIR=E:\pcre-8.41-install\lib
     E:\zabbix-5.0.0\build\win32\project> nmake /K -f Makefile_agent TLS=openssl TLSINCDIR=C:\OpenSSL-Win64-111-static\include TLSLIBDIR=C:\OpenSSL-Win64-111-static\lib PCREINCDIR=E:\pcre-8.41-install\include PCRELIBDIR=E:\pcre-8.41-install\lib
     ```

5. 新的二进制文件位于e:\zabbix-5.0.0\bin\win64中。 由于OpenSSL是使用“ no-shared”选项编译的，因此Zabbix二进制文件本身包含OpenSSL，并且可以将其复制到其他没有OpenSSL的计算机上

#### 使用LibreSSL编译Zabbix

该过程类似于使用OpenSSL进行编译，但是您需要对 `build\win32\project` 目录中的文件进行一些小的更改:

- 在 `Makefile_tls` 中删除 `/DHAVE_OPENSSL_WITH_PSK`. 即找到 

  ```
  CFLAGS =	$(CFLAGS) /DHAVE_OPENSSL /DHAVE_OPENSSL_WITH_PSK
  ```

  并替换为 

  ```
  CFLAGS =	$(CFLAGS) /DHAVE_OPENSSL
  ```

- 在 `Makefile_common.inc` 中添加 `/NODEFAULTLIB:LIBCMT`. 即找到 

  ```
  /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /DYNAMICBASE:NO /PDB:$(TARGETDIR)\$(TARGETNAME).pdb
  ```

  并替换为 

  ```
  /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /DYNAMICBASE:NO /PDB:$(TARGETDIR)\$(TARGETNAME).pdb /NODEFAULTLIB:LIBCMT
  ```

## 从二进制包安装

#### 使用ZABBIX官方存储库

Zabbix SIA提供官方RPM和DEB软件包:

-  [Red Hat Enterprise Linux/CentOS](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install_from_packages/rhel_centos)
-  [Debian/Ubuntu/Raspbian](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install_from_packages/debian_ubuntu)
-  [SUSE Linux Enterprise Server](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install_from_packages/suse)

yum/dnf, apt和zypper各种OS发行版的软件包文件可以在[repo.zabbix.com](https://repo.zabbix.com/)上找到

注意，尽管一些OS发行版(特别是基于debian的发行版)提供了它们自己的Zabbix包，但Zabbix不支持这些包。第三方提供的Zabbix包可能已经过时，可能缺乏最新的特性和bug修复。建议只使用[repo.zabbix.com](https://repo.zabbix.com/)上的官方软件包。如果您以前使用过非官方的Zabbix包，请参阅[关于从操作系统存储库升级Zabbix包](https://www.zabbix.com/documentation/5.0/zh/manual/installation/upgrade/packages)的说明

### Red Hat Enterprise Linux/CentOS

Zabbix官方包可用于: RHEL 8, CentOS 8 and Oracle Linux 8   [下载](https://www.zabbix.com/download?zabbix=5.0&os_distribution=red_hat_enterprise_linux&os_version=8&db=mysql) RHEL 7, CentOS 7 and Oracle Linux 7   [下载](https://www.zabbix.com/download?zabbix=5.0&os_distribution=red_hat_enterprise_linux&os_version=7&db=mysql)

软件包可以使用MySQL/PostgreSQL数据库和Apache/Nginx webserver支持 [RHEL 6](https://repo.zabbix.com/zabbix/5.0/rhel/6/x86_64/)和[RHEL 5](https://repo.zabbix.com/zabbix/5.0/rhel/5/x86_64/)也可以使用Zabbix agent包和实用程序Zabbix get和Zabbix sender

Zabbix官方存储库还提供fping，iksemel，libssh2软件包。 这些软件包位于[不支持的](https://repo.zabbix.com/non-supported/)目录中

#### 安装注意事项

请参阅下载页面中每个平台的[安装说明](https://www.zabbix.com/download?zabbix=5.0&os_distribution=red_hat_enterprise_linux&os_version=8&db=mysql)，以了解：

-  安装存储库
-  安装server/agent/frontend
-  创建初始数据库，导入初始数据
-  为Zabbix server配置数据库
-  为Zabbix frontend配置PHP
-  启动server/agent进程
-  配置Zabbix frontend

如果要以root用户身份运行Zabbix agent，请参阅[以root用户身份运行agent](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/run_agent_as_root)

#### 使用TIMESCALE DB导入数据

使用TimescaleDB，除了PostgreSQL的import命令外，还运行：

```
# zcat /usr/share/doc/zabbix-server-pgsql*/timescaledb.sql.gz | sudo -u zabbix psql zabbix
```

仅Zabbix server支持TimescaleDB

#### frontend安装要求

Zabbix frontend需要基本安装中不提供的其他软件包。 您需要在将运行Zabbix frontend的系统中启用可选rpm的存储库： RHEL 7:

```
# yum-config-manager --enable rhel-7-server-optional-rpms
```

请注意，Nginx for RHEL在Red Hat Software Collections和EPEL中可用。 如果使用Red Hat Software Collections，只需安装zabbix-nginx-conf-scl软件包

#### SELINUX配置

在强制模式下启用SELinux状态后，您需要执行以下命令以启用Zabbix frontend与server之间的通信： RHEL 7及更高版本：

```
# setsebool -P httpd_can_connect_zabbix on
```

如果可以通过网络访问数据库（在PostgreSQL中包括“ localhost”），则还需要允许Zabbix frontend连接到数据库：

```
# setsebool -P httpd_can_network_connect_db on
```

RHEL 7之前的版本：

```
# setsebool -P httpd_can_network_connect on
# setsebool -P zabbix_can_network on
```

完成frontend和SELinux配置后，重新启动Apache Web服务器：

```
# service httpd restart
```

#### 代理安装

添加所需的存储库后，可以通过运行以下命令来安装Zabbix agent：

```
# yum install zabbix-proxy-mysql
```

在命令中用“ pgsql”代替“ mysql”以使用PostgreSQL，或用“ sqlite3”代替以使用SQLite3（仅代理）

##### 创建数据库

为Zabbix proxy[创建](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/db_scripts)一个单独的数据库

Zabbix server和Zabbix proxy不能使用相同的数据库。 如果它们安装在同一主机上，则proxy数据库必须具有不同的名称

##### 导入数据

导入初始架构：

```
# zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix
```

对于PostgreSQL（或SQLite）代理：

```
# zcat /usr/share/doc/zabbix-proxy-pgsql*/schema.sql.gz | sudo -u zabbix psql zabbix
# zcat /usr/share/doc/zabbix-proxy-sqlite3*/schema.sql.gz | sqlite3 zabbix.db
```

##### 为ZABBIX PROXY配置数据库

编辑zabbix_proxy.conf：

```
# vi /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<password>
```

在DBName for Zabbix proxy中，请使用与Zabbix server不同的数据库 在DBPassword中，为MySQL使用Zabbix数据库密码； PostgreSQL的PostgreSQL用户密码 在PostgreSQL中使用DBHost =。 您可能想要保留默认设置DBHost = localhost（或IP地址），但这将使PostgreSQL使用网络套接字连接到Zabbix。 有关说明，请参见SELinux配置

##### 启动ZABBIX PROXY过程

要启动Zabbix proxy进程并使其在系统启动时启动：

```
# service zabbix-proxy start
# systemctl enable zabbix-proxy
```

##### 前端配置

Zabbix proxy没有前端。 它仅与Zabbix server通信

#### JAVA网关安装

仅当您要监视JMX应用程序时才需要安装[Java网关](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java)。 Java网关是轻量级的，不需要数据库 添加所需的存储库后，您可以通过运行以下命令来安装Zabbix Java网关：

```
# yum install zabbix-java-gateway
```

继续进行[设置](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java/from_rhel_centos)，以获取有关配置和运行Java网关的更多详细信息

#### 安装调试信息包

Debuginfo软件包当前可用于RHEL / CentOS版本7、6和5

要启用debuginfo存储库，请编辑/etc/yum.repos.d/zabbix.repo文件。 对于zabbix-debuginfo存储库，将enabled = 0更改为enabled = 1

```
[zabbix-debuginfo]
name=Zabbix Official Repository debuginfo - $basearch
baseurl=http://repo.zabbix.com/zabbix/5.0/rhel/7/$basearch/debuginfo/
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
gpgcheck=1
```

这将允许您安装zabbix-debuginfo软件包

```
# yum install zabbix-debuginfo
```

该单个软件包包含所有Zabbix二进制组件的调试信息

### DEBIAN/UBUNTU/RASPBIAN



#### 概述

官方 Zabbix 发行包适用于：

| Debian 10 (Buster)               | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=debian&os_version=10_buster&db=mysql) |
| -------------------------------- | ------------------------------------------------------------ |
| Debian 9 (Stretch)               | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=debian&os_version=9_stretch&db=mysql) |
| Debian 8 (Jessie)                | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=debian&os_version=8_jessie&db=mysql) |
| Ubuntu 20.04 (Focal Fossa) LTS   | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=ubuntu&os_version=20.04_focal&db=mysql) |
| Ubuntu 18.04 (Bionic Beaver) LTS | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=ubuntu&os_version=18.04_bionic&db=mysql) |
| Ubuntu 16.04 (Xenial Xerus) LTS  | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=ubuntu&os_version=16.04_xenial&db=mysql) |
| Ubuntu 14.04 (Trusty Tahr) LTS   | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=ubuntu&os_version=14.04_trusty&db=mysql) |
| Raspbian (Buster)                | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=raspbian&os_version=10_buster&db=mysql) |
| Raspbian (Stretch)               | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=raspbian&os_version=9_stretch&db=mysql) |

软件包提供了MySQL/PostgreSQL数据库和Apache/Nginx webserver支持。

#### 安装注意事项

请参阅下载页中每个平台的[安装说明](https://www.zabbix.com/download?zabbix=5.0&os_distribution=debian&os_version=10_buster&db=mysql)：

-  安装存储库
-  安装server/agent/前端
-  创建初始数据库，导入初始数据
-  为Zabbix server配置数据库
-  为Zabbix前端配置PHP
-  启动server/agent 进程
-  配置Zabbix前端

仅Debian9/10和Ubuntu 18.04/20.04支持Zabbix agent 2（zabbix-agent2）。

如果要以root用户运行Zabbix agent，请参阅以[root用户运行agent](https://www.zabbix.com/documentation/5.0/manual/appendix/install/run_agent_as_root)。

基于Debian的发行版通常在其存储库中提供自己的Zabbix包。Zabbix不支持这些包,仅支持Zabbix[官方存储库](https://repo.zabbix.com/zabbix/)的包。

#### 使用TIMESCALE DB导入数据

使用TimescaleDB，除了PostgreSQL的导入命令外，还需运行：

```
# zcat /usr/share/doc/zabbix-server-pgsql*/timescaledb.sql.gz | sudo -u zabbix psql zabbix
```

TimescaleDB仅支持Zabbix server。

#### PHP 7.2

从Zabbix 5.0开始，Zabbix前端需要PHP7.2或更高版本。

请参阅有关在7.2以下PHP版本上安装Zabbix前端的[说明](https://www.zabbix.com/documentation/5.0/zh/manual/installation/frontend/frontend_on_debian)。

#### SELINUX配置

请参阅RHEL/CentOS的[SELinux配置](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install_from_packages/rhel_centos#selinux_configuration)。

完成前端和SELinux配置后，重新启动Apache Web服务器：

```
# service apache2 restart
```

#### Proxy安装

添加所需的存储库后，可以通过运行以下命令来安装Zabbix proxy ：

```
# apt install zabbix-proxy-mysql
```

使用PostgreSQL，将命令中的“mysql”替换为“pgsql”，使用sqlite3，将命令中的“mysql”替换为“sqlite3”。

#### 创建数据库

为Zabbix Proxy[创建](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/db_scripts)一个单独的数据库。

Zabbix server和Zabbix proxy不能使用相同的数据库。 如果它们安装在同一主机，proxy数据库必须有一个不同的名字。

#### 导入数据

导入初始schema

```
# zcat /usr/share/doc/zabbix-proxy-mysql/schema.sql.gz | mysql -uzabbix -p zabbix
```

使用PostgreSQL (或者SQLite)的proxy:

```
# zcat /usr/share/doc/zabbix-proxy-pgsql/schema.sql.gz | sudo -u zabbix psql zabbix
# zcat /usr/share/doc/zabbix-proxy-sqlite3/schema.sql.gz | sqlite3 zabbix.db 
```

#### 为ZABBIX PROXY配置数据库

编辑zabbix_proxy.conf:

```
# vi /etc/zabbix/zabbix_proxy.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<password>
```

Zabbix proxy的DBName使用与Zabbix server不同的数据库。 在DBPassword配置处输入由MySQL或PosgreSQL创建的Zabbix 数据库密码。

在 PostgreSQL 使用 DBHost=。您可能希望保留默认设置DBHost=localhost（或 IP 地址，但这会使 PostgreSQL 使用网络套接字连接到 Zabbix。请参阅RHEL/CentOS的相应部分[有关说明](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install_from_packages/rhel_centos#selinux_configuration)。

#### 启动ZABBIX PROXY进程

运行以下命令启动Zabbix proxy进程，并使其开机自启:

```
# systemctl restart zabbix-proxy
# systemctl enable zabbix-proxy
```

#### 前端配置

Zabbix proxy没有前端;它仅与Zabbix server通信。

#### JAVA GATEWAY安装

仅当您要监视JMX应用程序时才需要安装[Java网关](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java)。 Java网关是轻量级的，不需要数据库。

添加所需的存储库后，您可以通过运行以下命令来安装Zabbix Java网关：

```
# apt install zabbix-java-gateway
```

继续进行[设置](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/java/from_debian_ubuntu)，以获取有关配置和运行Java网关的更多详细信息。

### SUSE Linux Enterprise Server

### 概述

官方Zabbix安装包适用于:

| SUSE Linux Enterprise Server 15 | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=suse_linux_enterprise_server&os_version=15&db=mysql) |
| ------------------------------- | ------------------------------------------------------------ |
| SUSE Linux Enterprise Server 12 | [Download](https://www.zabbix.com/download?zabbix=5.0&os_distribution=suse_linux_enterprise_server&os_version=12&db=mysql) |

### 添加Zabbix软件仓库

安装软件仓库配置包，这个包包含了 yum（软件包管理器）的配置文件。

SLES 15:

```
# rpm -Uvh --nosignature https://repo.zabbix.com/zabbix/5.0/sles/15/x86_64/zabbix-release-5.0-1.el15.noarch.rpm
# zypper --gpg-auto-import-keys refresh 'Zabbix Official Repository' 
```

SLES 12:

```
# rpm -Uvh --nosignature https://repo.zabbix.com/zabbix/5.0/sles/12/x86_64/zabbix-release-5.0-1.el12.noarch.rpm
# zypper --gpg-auto-import-keys refresh 'Zabbix Official Repository' 
```

### Server/前端/agent 安装

要安装Zabbix前端，必须激活`web-scripting模块`。它包含必要的PHP依赖项。

SLES 15:

```
# SUSEConnect -p sle-module-web-scripting/15/x86_64
```

SLES 12:

```
# SUSEConnect -p sle-module-web-scripting/12/x86_64
```

安装支持MySQL的Zabbix server/前端/agent：

```
# zypper install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
```

如果使用nginx web server，则将命令中的“apache”替换为“nginx”。另请参见：[ SLES 12/15 Zabbix nginx设置](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/nginx)。

如果使用zabbix agent 2（仅支持SLES 15 SP1+），则将命令中的“zabbix-agent”替换为“zabbix-agent2”。

安装支持MySQL的Zabbix proxy ：

```
# zypper install zabbix-proxy-mysql
```

使用PostgreSQL,将命令中的“mysql”替换为“pgsql”。

#### 创建数据库

Zabbix [server](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/server)和[proxy](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/proxy)守护进程需要数据库。Zabbix [agent](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/agent)不需要。

Zabbix server和Zabbix proxy需要单独的数据库，他们不能使用相同的数据库。 因此如果它们安装在同一主机上，则必须创建不同名称的数据库！

使用[MySQL](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/db_scripts#mysql)或[PostgreSQL](https://www.zabbix.com/documentation/5.0/zh/manual/appendix/install/db_scripts#postgresql)提供的说明创建数据库。

#### 导入数据

现在使用MySQL导入 **server** 的初始schema 和数据：

```
# zcat /usr/share/doc/packages/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
```

系统将提示您输入新创建数据库的密码。

使用PostgreSQL：

```
# zcat /usr/share/doc/packages/zabbix-server-pgsql*/create.sql.gz | sudo -u <username> psql zabbix
```

使用TimescaleDB，除了前面的命令外，还需运行：

```
# zcat /usr/share/doc/packages/zabbix-server-pgsql*/timescaledb.sql.gz | sudo -u <username> psql zabbix
```

TimescaleDB仅支持Zabbix server。

导入初始**proxy** schema:

```
# zcat /usr/share/doc/packages/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix
```

proxy使用PostgreSQL:

```
# zcat /usr/share/doc/packages/zabbix-proxy-pgsql*/schema.sql.gz | sudo -u <username> psql zabbix
```

#### 为ZABBIX SERVER/PROXY配置数据库

编辑/etc/zabbix/zabbix_server.conf（和zabbix_proxy.conf）使用各自的数据库。 例如：

```
# vi /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<password>
```

DBPassword处MySQL使用Zabbix数据库密码；PosgreSQL使用PosgreSQL用户密码。

PostgreSQL使用`DBHost=`。您可能希望保留默认设置“DBHost=localhost”（或IP地址），但这将使PostgreSQL使用网络套接字连接到Zabbix。

#### Zabbix前端配置

根据使用的web server（Apache/Nginx），编辑Zabbix前端相应的配置文件：

-  Apache配置文件位于`/etc/apache2/conf.d/zabbix.conf`。已经配置了一些PHP设置。但是有必要取消" date.timezone "设置的注释，并为您[设置正确的时区](https://php.net/manual/en/timezones.php)。

```
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value max_input_vars 10000
php_value always_populate_raw_post_data -1
# php_value date.timezone Europe/Riga
```

-   zabbix-nginx-conf软件包为Zabbix前端安装了单独的Nginx server  。其配置文件位于/etc/nginx/conf.d/zabbix.conf。 为了使Zabbix前端正常工作，必须取消注释并设置“  listen”和“server_name”指令。

```
# listen 80;
# server_name example.com;
```

-  Zabbix uses its own dedicated php-fpm connection pool with Nginx:

它的配置文件位于`/etc/php7/fpm/php-fpm.d/zabbix.conf`。已经配置了一些PHP设置。但是有必要为您配置正确的[时区](https://php.net/manual/en/timezones.php)。

```
php_value[max_execution_time] = 300
php_value[memory_limit] = 128M
php_value[post_max_size] = 16M
php_value[upload_max_filesize] = 2M
php_value[max_input_time] = 300
php_value[max_input_vars] = 10000
; php_value[date.timezone] = Europe/Riga
```

现在您可以继续进行[前端安装步骤](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install#installing_frontend)，这将允许您访问新安装的Zabbix。

请注意，Zabbix proxy没有前端；它只与Zabbix server通信。

#### 启动ZABBIX SERVER/AGENT进程

启动Zabbix server和agent进程，并使其在系统启动时启动。

使用Apache web server:

```
# systemctl restart zabbix-server zabbix-agent apache2 php-fpm
# systemctl enable zabbix-server zabbix-agent apache2 php-fpm
```

使用Nginx web server,用'nginx'代替'apache2'。

### 安装debuginfo包

编辑*/etc/zypp/repos.d/zabbix.repo*文件启用debuginfo存储库

将zabbix debuginfo存储库的enabled=0更改为enabled=1。

```
[zabbix-debuginfo]
name=Zabbix Official Repository debuginfo
type=rpm-md
baseurl=http://repo.zabbix.com/zabbix/5.0/sles/15/x86_64/debuginfo/
gpgcheck=1
gpgkey=http://repo.zabbix.com/zabbix/5.0/sles/15/x86_64/debuginfo/repodata/repomd.xml.key
enabled=0
update=1
```

这将允许您安装zabbix-***<component>\***-debuginfo包。

###  通过MSI安装Windows agent



#### 概述

Zabbix Windows agent可通过[下载](https://www.zabbix.com/download_agents#tab:44)的Windows MSI安装包(32位或者64位)安装。

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_a.png?w=400&tok=654705)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_a.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

32位软件包不能安装在64位Windows上。

所有软件包都支持TLS，但是配置TLS是可选的。

支持基于UI和命令行的安装。

#### 安装步骤

双击下载的MSI文件进行安装。

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_b.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_b.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_c.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_c.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

接受许可证点击下一步。

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_d.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_d.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

指定以下参数。

| 参数                                | 描述                                         |
| ----------------------------------- | -------------------------------------------- |
| *Host name*                         | 指定主机名。                                 |
| *Zabbix server IP/DNS*              | 指定Zabbix server的IP/DNS。                  |
| *Agent listen port*                 | 指定Agent侦听端口（默认为10050）。           |
| *Server or Proxy for active checks* | 为主动式agent指定Zabbix server/proxy的IP/DNS |
| *Remote commands*                   | 选中复选框启用远程命令。                     |
| *Enable PSK*                        | 选中复选框通过预共享密钥启用TLS支持。        |
| *Add agent location to the PATH*    | 将agent位置添加到PATH变量。                  |

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_e.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_e.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

输入预共享密钥标识和值。只有在上一步中选中*启用PSK*时，此步骤才可用。

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_f.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_f.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

选择要安装的Zabbix组件 - [Zabbix agent daemon](https://www.zabbix.com/documentation/5.0/manual/concepts/agent), [Zabbix sender](https://www.zabbix.com/documentation/5.0/manual/concepts/sender), [Zabbix get](https://www.zabbix.com/documentation/5.0/manual/concepts/get).

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_g.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_g.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

Zabbix组件和配置文件安装在Program Files下Zabbix Agent文件夹中。zabbix_agentd.exe将设置为自动启动的Windows服务。

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/installation/install_from_packages/msi0_h.png)](https://www.zabbix.com/documentation/5.0/_detail/manual/installation/install_from_packages/msi0_h.png?id=zh%3Amanual%3Ainstallation%3Ainstall_from_packages%3Awin_msi)

#### 基于命令行安装



##### 支持的参数

MSI安装支持以下参数集：

| Number | 参数                 | 描述                             |
| ------ | -------------------- | -------------------------------- |
| 1      | LOGTYPE              |                                  |
| 2      | LOGFILE              |                                  |
| 3      | ENABLEREMOTECOMMANDS |                                  |
| 4      | SERVER               |                                  |
| 5      | LISTENPORT           |                                  |
| 6      | SERVERACTIVE         |                                  |
| 7      | HOSTNAME             |                                  |
| 8      | TIMEOUT              |                                  |
| 9      | TLSCONNECT           |                                  |
| 10     | TLSACCEPT            |                                  |
| 11     | TLSPSKIDENTITY       |                                  |
| 12     | TLSPSKFILE           |                                  |
| 13     | TLSPSKVALUE          |                                  |
| 14     | TLSCAFILE            |                                  |
| 15     | TLSCRLFILE           |                                  |
| 16     | TLSSERVERCERTISSUER  |                                  |
| 17     | TLSSERVERCERTSUBJECT |                                  |
| 18     | TLSCERTFILE          |                                  |
| 19     | TLSKEYFILE           |                                  |
| 20     | INSTALLFOLDER        |                                  |
| 21     | ENABLEPATH           |                                  |
| 22     | SKIP                 | `SKIP=fw` - 不安装防火墙例外规则 |

运行如下命令安装:

```
SET INSTALLFOLDER=C:\Program Files\za

msiexec /l*v log.txt /i zabbix_agent-4.0.6-x86.msi /qn^
 LOGTYPE=file^
 LOGFILE="%INSTALLFOLDER%\za.log"^
 ENABLEREMOTECOMMANDS=1^
 SERVER=192.168.6.76^
 LISTENPORT=12345^
 SERVERACTIVE=::1^
 HOSTNAME=myHost^
 TLSCONNECT=psk^
 TLSACCEPT=psk^
 TLSPSKIDENTITY=MyPSKID^
 TLSPSKFILE="%INSTALLFOLDER%\mykey.psk"^
 TLSCAFILE="c:\temp\f.txt1"^
 TLSCRLFILE="c:\temp\f.txt2"^
 TLSSERVERCERTISSUER="My CA"^
 TLSSERVERCERTSUBJECT="My Cert"^
 TLSCERTFILE="c:\temp\f.txt5"^
 TLSKEYFILE="c:\temp\f.txt6"^
 ENABLEPATH=1^
 INSTALLFOLDER="%INSTALLFOLDER%"
 SKIP=fw
```

或者

```
msiexec /l*v log.txt /i zabbix_agent-4.4.0-x86.msi /qn^
 SERVER=192.168.6.76^
 TLSCONNECT=psk^
 TLSACCEPT=psk^
 TLSPSKIDENTITY=MyPSKID^
 TLSPSKVALUE=1f87b595725ac58dd977beef14b97461a7c1045b9a1c963065002c5473194952
```

###  从PKG安装MAC OS代理

#### 概述

Zabbix Mac OS代理可以使用PKG包进行安装，PKG包可以从如下地址下载  [下载](https://www.zabbix.com/download_agents#tab:44). 加密版本和不加密版本均可以下载.

#### 代理安装

代理可以使用图形用户界面方式或者命令行方式，例如:

```
sudo installer -pkg zabbix_agent-4.4.1-macos-amd64-openssl.pkg -target /
```

请保证在命令行中使用正确版本的Zabbix安装包版本。在命令行中，pkg包的名字务必匹配所下载的安装包的名字。

#### 代理运行

在安装完成或者系统重启后，代理会自动启动。

有需要的情况下，您可以编辑相关的配置文件`/usr/local/etc/zabbix/zabbix_agentd.conf` 。

如果需要人工启动代理，执行如下命令:

```
sudo launchctl start com.zabbix.zabbix_agentd
```

如果需要人工停止代理，执行如下命令:

```
sudo launchctl stop com.zabbix.zabbix_agentd
```

在升级过程中，现有的配置文件不会被覆盖，系统会生成一个新的配置文件，新的配置文件用于检查和更新现有的配置文件。在对配置文件作出任何修改后，必须重启代理才能够生效。

#### 故障排除和删除代理

以下部分列出了许多非常有用的命令，这些命令可以用于故障排除和删除Zabbix代理。

查看Zabbix代理是否在运行:

```
ps aux | grep zabbix_agentd
```

查看Zabbix代理是否使用PKG包方式进行安装:

```
$ pkgutil --pkgs | grep zabbix 
com.zabbix.pkg.ZabbixAgent
```

查看安装Zabbix代理后，有哪些文件被安装在系统中 (注意：每行开头的`/`并没在以下示例中进行显示):

```
$ pkgutil --only-files --files com.zabbix.pkg.ZabbixAgent
Library/LaunchDaemons/com.zabbix.zabbix_agentd.plist                                                                                                                                                                                                                           
usr/local/bin/zabbix_get                                                                                                                                                                                                                                                       
usr/local/bin/zabbix_sender                                                                                                                                                                                                                                                    
usr/local/etc/zabbix/zabbix_agentd/userparameter_examples.conf.NEW                                                                                                                                                                                                             
usr/local/etc/zabbix/zabbix_agentd/userparameter_mysql.conf.NEW                                                                                                                                                                                                                
usr/local/etc/zabbix/zabbix_agentd.conf.NEW                                                                                                                                                                                                                                    
usr/local/sbin/zabbix_agentd
```

如果Zabbix的代理使用`launchctl`方式启动，您可以使用如下命令停止Zabbix代理:

```
sudo launchctl unload /Library/LaunchDaemons/com.zabbix.zabbix_agentd.plist
```

删除已安装文件 (包括配置文件和相关日志文件) ，使用以下命令:

```
sudo rm -f /Library/LaunchDaemons/com.zabbix.zabbix_agentd.plist
sudo rm -f /usr/local/sbin/zabbix_agentd
sudo rm -f /usr/local/bin/zabbix_get
sudo rm -f /usr/local/bin/zabbix_sender
sudo rm -rf /usr/local/etc/zabbix
sudo rm -rf /var/logs/zabbix
```

忘记已安装Zabbix代理，使用命令:

```
sudo pkgutil --forget com.zabbix.pkg.ZabbixAgent
```

## 从容器中安装

### Docker

Zabbix 组件支持 MySQL 和 PostgreSQL 数据库、Apache2 和 Nginx Web 服务器。这些镜像被分成多个不同的镜像。  

#### Docker 的基础镜像

Zabbix 组件提供了 Ubuntu、Alpine Linux 和 CentOS 的基础镜像。

| 镜像   | 版本   |
| ------ | ------ |
| alpine | 3.4    |
| ubuntu | trusty |
| centos | latest |

如果基础镜像升级了，所有的镜像被配置为重建成最新版本的镜像。

#### 组件

-  MySQL 数据库和 Nginx Web 服务器支持的 Zabbix 应用 - [zabbix/zabbix-appliance](https://hub.docker.com/r/zabbix/zabbix-appliance/)
-  Zabbix agent - [zabbix/zabbix-agent](https://hub.docker.com/r/zabbix/zabbix-agent/)
-  Zabbix server
   -  MySQL 数据库支持  - [zabbix/zabbix-server-mysql](https://hub.docker.com/r/zabbix/zabbix-server-mysql/)
   -  PostgreSQL  数据库支持  - [zabbix/zabbix-server-pgsql](https://hub.docker.com/r/zabbix/zabbix-server-pgsql/)
-  Zabbix web-interface
   -  基于 Apache2 Web 服务器以及支持 MySQL 数据库 - [zabbix/zabbix-web-apache-mysql](https://hub.docker.com/r/zabbix/zabbix-web-apache-mysql/)
   -  基于 Apache2 Web 服务器以及支持 PostgreSQL 数据库 - [zabbix/zabbix-web-apache-pgsql](https://hub.docker.com/r/zabbix/zabbix-web-apache-pgsql/)
   -  基于 Nginx Web 服务器以及支持 MySQL 数据库 - [zabbix/zabbix-web-nginx-mysql](https://hub.docker.com/r/zabbix/zabbix-web-nginx-mysql/)
   -  基于 Nginx Web 服务器以及支持 PostgreSQL 数据库 - [zabbix/zabbix-web-nginx-pgsql](https://hub.docker.com/r/zabbix/zabbix-web-nginx-pgsql/)
-  Zabbix proxy
   -  SQLite3 数据库支持 - [zabbix/zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3/)
   -  MySQL 数据库支持 - [zabbix/zabbix-proxy-mysql](https://hub.docker.com/r/zabbix/zabbix-proxy-mysql/)
-  Zabbix Java Gateway - [zabbix/zabbix-java-gateway](https://hub.docker.com/r/zabbix/zabbix-java-gateway/)

此外，对于 SNMP trap 的支持，它仅作为基于 Ubuntu Trusty 的额外镜像仓库 ([zabbix/zabbix-snmptraps](https://hub.docker.com/r/zabbix/zabbix-snmptraps/)) 提供。它可以与 Zabbix server 和 Zabbix proxy 关联。

#### 版本

Zabbix 组件的每个镜像仓库都包含了下列标签：

-  `latest` - 基于 Alpine Linux 镜像的最新稳定版的 Zabbix 组件；
-  `alpine-latest` - 基于 Alpine Linux 镜像的最新稳定版的 Zabbix 组件；
-  `ubuntu-latest` - 基于 Ubuntu 镜像的最新稳定版的 Zabbix 组件；
-  `alpine-5.0-latest` - 基于 Alpine Linux 镜像的最新次要版本的 Zabbix 5.0 组件；
-  `ubuntu-5.0-latest` - 基于 Unbuntu 镜像的最新次要版本的 Zabbix 5.0 组件；
-  `alpine-5.0.*` - 基于 Alpine Linux 镜像的不同次要版本的 Zabbix 5.0 组件，其中 `*` 代表 Zabbix 组件的次要版本；
-  `ubuntu-5.0.*` - 基于 Ubuntu 镜像的不同次要版本的 Zabbix 5.0 组件，其中 `*` 代表 Zabbix 组件的次要版本

#### 使用方法

##### 环境变量

所有 Zabbix 组件镜像都提供环境变量来控制配置。 这些环境变量在每个组件镜像仓库中列出。这些环境变量是 Zabbix 配置文件中的选项，但具有不同的命名方法。 例如，`ZBX_LOGSLOWQUERIES` 等于来自 Zabbix server 和 Zabbix proxy 配置文件的 `LogSlowQueries`。

 一些配置选项是不允许更改的。例如，`PIDFile` 和 `LogType`。

其中，一些组件有特定的环境变量，而这些环境变量在官方 Zabbix 配置文件并不存在：

| **变量**                 | **组件**                     | **描述**                                                     |
| ------------------------ | ---------------------------- | ------------------------------------------------------------ |
| `DB_SERVER_HOST`         | Server  Proxy  Web interface | MySQL 或 PostgreSQL 的 IP 或 DNS。  默认情况下，这个值根据  MySQL 和 PostgreSQL，分别为`mysql-server` 或 `postgres-server` |
| `DB_SERVER_PORT`         | Server  Proxy  Web interface | MySQL 或 PostgreSQL 的端口。  默认情况下，这个值根据  MySQL 和 PostgreSQL，分别为 '3306' 或 '5432' 。 |
| `MYSQL_USER`             | Server  Proxy  Web-interface | MySQL 数据库用户。  默认情况下，这个值为 'zabbix'。          |
| `MYSQL_PASSWORD`         | Server  Proxy  Web interface | MySQL 数据库密码。  默认情况下，这个值为 'zabbix'。          |
| `MYSQL_DATABASE`         | Server  Proxy  Web interface | Zabbix 数据库库名。  默认情况下，这个值根据 Zabbix server 和 Zabbix proxy，分别为 'zabbix' 和 'zabbix_proxy' 。 |
| `POSTGRES_USER`          | Server  Web interface        | PostgreSQL 数据库用户。  默认情况下，这个值为 'zabbix'。     |
| `POSTGRES_PASSWORD`      | Server  Web interface        | PostgreSQL 数据库密码。  默认情况下，这个值为 'zabbix'。     |
| `POSTGRES_DB`            | Server  Web interface        | Zabbix 数据库库名。  默认情况下，这个值根据 Zabbix server 和 Zabbix proxy，分别为 'zabbix' 和 'zabbix_proxy' 。 |
| `TZ`                     | Web-interface                | PHP 时区格式。所有支持的时区列表为 php.net 。 默认情况下，这个值为 'Europe/Riga' 。 |
| `ZBX_SERVER_NAME`        | Web interface                | Web 界面右上角显示的安装名称。  默认情况下，这个值为  'Zabbix Docker' 。 |
| `ZBX_JAVAGATEWAY_ENABLE` | Server  Proxy                | 是否启用 Zabbix Java gateway 以采集与 Java 相关的检查数据。默认情况下，这个值为 “false” 。 |
| `ZBX_ENABLE_SNMP_TRAPS`  | Server  Proxy                | 是否启用 SNMP trap feature 功能。这要求 **zabbix-snmptraps** 实例并共享 */var/lib/zabbix/snmptraps* 卷到 Zabbix server 或 proxy。 |

##### 卷

| **卷**                                        | **描述**                                                     |
| --------------------------------------------- | ------------------------------------------------------------ |
| **Zabbix agent**                              |                                                              |
| */etc/zabbix/zabbix_agentd.d*                 | 该卷允许包含 **.conf* 文件并使用 `UserParameter` 功能扩展 Zabbix agent。 |
| */var/lib/zabbix/modules*                     | 该卷允许通过 `LoadModule` 功能加载额外的模块以扩展 Zabbix agent。 |
| */var/lib/zabbix/enc*                         | 该卷用于存放 TLS 相关的文件。这些文件名指定使用 `ZBX_TLSCAFILE`、`ZBX_TLSCRLFILE`、`ZBX_TLSKEY_FILE` 和 `ZBX_TLSPSKFILE` 环境变量。 |
| **Zabbix server**                             |                                                              |
| */usr/lib/zabbix/alertscripts*                | 该卷用于自定义告警脚本。即 [zabbix_server.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_server) 中的 `AlertScriptsPath` 参数。 |
| */usr/lib/zabbix/externalscripts*             | 该卷用于 [外部检查](https://www.zabbix.com/documentation/5.0/manual/config/items/itemtypes/external)。即在 [zabbix_server.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_server) 中的 `ExternalScripts` 参数。 |
| */var/lib/zabbix/modules*                     | 该卷允许通过 `LoadModule` 功能加载额外的模块以扩展 Zabbix agent。 |
| */var/lib/zabbix/enc*                         | 该卷用于存放 TLS 相关的文件。这些文件名指定使用 `ZBX_TLSCAFILE`、`ZBX_TLSCRLFILE`、`ZBX_TLSKEY_FILE` 和 `ZBX_TLSPSKFILE` 环境变量。 |
| */var/lib/zabbix/ssl/certs*                   | 该卷用于用于存放客户端认证的 SSL 客户端认证文件。即在 [zabbix_server.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_server) 中的 `SSLCertLocation` 参数。 |
| */var/lib/zabbix/ssl/keys*                    | 该卷用于存放客户端认证的 SSL 私钥文件。即在 [zabbix_server.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_server) 中的 `SSLKeyLocation` 参数。 |
| */var/lib/zabbix/ssl/ssl_ca*                  | 该卷用于存放 SSL 服务器证书认证的证书颁发机构(CA)文件。即在 [zabbix_server.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_server) 中的 `SSLCALocation` 参数。 |
| */var/lib/zabbix/snmptraps*                   | 该卷用于存放 snmptraps.log 文件。它可由 zabbix-snmptraps 容器共享，并在创建 Zabbix server 新实例时使用 Docker 的 volumes_from 选项继承。可以通过共享卷，并将 `ZBX_ENABLE_SNMP_TRAPS` 环境变量切换为 'true' 以启用 SNMP trap 处理功能。 |
| */var/lib/zabbix/mibs*                        | 该卷允许添加新的 MIB 文件。它不支持子目录，所有的 MIB 文件必须位于 `/var/lib/zabbix/mibs` 下。 |
| **Zabbix proxy**                              |                                                              |
| */usr/lib/zabbix/externalscripts*             | 该卷用于使用 [外部检查](https://www.zabbix.com/documentation/5.0/manual/config/items/itemtypes/external)。即在 [zabbix_proxy.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_proxy) 中的 `ExternalScripts` 参数。 |
| */var/lib/zabbix/modules*                     | 该卷允许通过 `LoadModule` 功能加载额外的模块以扩展 Zabbix server。 |
| */var/lib/zabbix/enc*                         | 该卷用于存放 TLS 相关的文件。这些文件名指定使用 `ZBX_TLSCAFILE`、`ZBX_TLSCRLFILE`、`ZBX_TLSKEY_FILE` 和 `ZBX_TLSPSKFILE` 环境变量。 |
| */var/lib/zabbix/ssl/certs*                   | 该卷用于存放客户端认证的 SSL 客户端认证文件。即在 [zabbix_proxy.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_proxy) 中的 `SSLCertLocation` 参数。 |
| */var/lib/zabbix/ssl/keys*                    | 该卷用于存放客户端认证的 SSL 私钥文件。即在 [zabbix_proxy.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_proxy) 中的 `SSLKeyLocation` 参数。 |
| */var/lib/zabbix/ssl/ssl_ca*                  | 该卷用于存放 SSL 服务器证书认证的证书颁发机构(CA)文件。即在 [zabbix_proxy.conf](https://www.zabbix.com/documentation/5.0/manual/appendix/config/zabbix_proxy) 中的 `SSLCALocation` 参数。 |
| */var/lib/zabbix/snmptraps*                   | 该卷用于存放 snmptraps.log 文件。它可由 zabbix-snmptraps 容器共享，并在创建 Zabbix server 新实例时使用 Docker的 volumes_from 选项继承。可以通过共享卷，并将 `ZBX_ENABLE_SNMP_TRAPS` 环境变量切换为 'true' 以启用 SNMP trap 处理功能。 |
| */var/lib/zabbix/mibs*                        | 该卷允许添加新的 MIB 文件。它不支持子目录，所有的 MIB 文件必须位于 `/var/lib/zabbix/mibs` 下。 |
| **基于 Apache2 Web 服务器的 Zabbix Web 接口** |                                                              |
| */etc/ssl/apache2*                            | 该卷允许为 Zabbix Web 接口启用 HTTPS。该卷必须包含为 Apache2 SSL 连接准备的 `ssl.crt` 和 `ssl.key` 两个文件。 |
| **基于 Nginx Web 服务器的 Zabbix Web 接口**   |                                                              |
| */etc/ssl/nginx*                              | 该卷允许为 Zabbix Web 接口启用 HTTPS。该卷必须包含为 Nginx SSL 连接装备的 `ssl.crt` 和 `ssl.key` 两个文件。 |
| **Zabbix snmptraps**                          |                                                              |
| */var/lib/zabbix/snmptraps*                   | 该卷包含了以接收到的 SNMP traps 命名的 `snmptraps.log` 日志文件。 |
| */var/lib/zabbix/mibs*                        | 该卷允许添加新的 MIB 文件。它不支持子目录，该 MIB 文件必须位于 `/var/lib/zabbix/mibs` 下。 |

##### 使用方法实例

**示例 1** 

示范了如何使用内置 MySQL 数据库、Zabbix server、基于 Nginx Web 服务器的 Zabbix Web 界面和 Zabbix Java gateway 来运行 Zabbix 应用。

1. 创建专用于Zabbix组件容器的网络：

   ```bash
   docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
   ```

2. 启动空的MySQL服务器实例

   ```bash
   docker run --name mysql-server -t \
         -e MYSQL_DATABASE="zabbix" \
         -e MYSQL_USER="zabbix" \
         -e MYSQL_PASSWORD="zabbix_pwd" \
         -e MYSQL_ROOT_PASSWORD="root_pwd" \
         --network=zabbix-net \
         -d mysql:8.0 \
         --restart unless-stopped \
         --character-set-server=utf8 --collation-server=utf8_bin \
         --default-authentication-plugin=mysql_native_password
   ```

3. 启动Zabbix Java gateway实例

   ```bash
   docker run --name zabbix-java-gateway -t \
         --network=zabbix-net \
         --restart unless-stopped \
         -d zabbix/zabbix-java-gateway:alpine-5.0-latest
   ```

4. 启动Zabbix server实例并将该实例与创建的MySQL服务器实例链接。Zabbix服务器实例向主机公开10051 / TCP端口（Zabbix trapper）

   ```bash
   docker run --name zabbix-server-mysql -t \
         -e DB_SERVER_HOST="mysql-server" \
         -e MYSQL_DATABASE="zabbix" \
         -e MYSQL_USER="zabbix" \
         -e MYSQL_PASSWORD="zabbix_pwd" \
         -e MYSQL_ROOT_PASSWORD="root_pwd" \
         -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
         --network=zabbix-net \
         -p 10051:10051 \
         --restart unless-stopped \
         -d zabbix/zabbix-server-mysql:alpine-5.0-latest
   ```

5. 启动Zabbix Web界面，并将实例与创建的MySQL服务器和Zabbix server实例链接。Zabbix Web界面实例向主机公开80 / TCP端口（HTTP）。

   ```bash
   docker run --name zabbix-web-nginx-mysql -t \
         -e ZBX_SERVER_HOST="zabbix-server-mysql" \
         -e DB_SERVER_HOST="mysql-server" \
         -e MYSQL_DATABASE="zabbix" \
         -e MYSQL_USER="zabbix" \
         -e MYSQL_PASSWORD="zabbix_pwd" \
         -e MYSQL_ROOT_PASSWORD="root_pwd" \
         --network=zabbix-net \
         -p 80:8080 \
         --restart unless-stopped \
         -d zabbix/zabbix-web-nginx-mysql:alpine-5.0-latest
   ```

 **示例 2** 

该示例演示了如何在具有PostgreSQL数据库支持，基于Nginx Web服务器的Zabbix Web界面和SNMP陷阱功能的情况下运行Zabbix服务器。

1. 创建专用于Zabbix组件容器的网络：

   ```bash
   docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
   ```

2. 启动空的PostgreSQL服务器实例

   ```bash
   docker run --name postgres-server -t \
         -e POSTGRES_USER="zabbix" \
         -e POSTGRES_PASSWORD="zabbix_pwd" \
         -e POSTGRES_DB="zabbix" \
         --network=zabbix-net \
         --restart unless-stopped \
         -d postgres:latest
   ```

3. 启动Zabbix snmptraps实例。Zabbix snmptrap实例向主机公开162 / UDP端口（SNMP traps）

   ```bash
   docker run --name zabbix-snmptraps -t \
         -v /zbx_instance/snmptraps:/var/lib/zabbix/snmptraps:rw \
         -v /var/lib/zabbix/mibs:/usr/share/snmp/mibs:ro \
         --network=zabbix-net \
         -p 162:1162/udp \
         --restart unless-stopped \
         -d zabbix/zabbix-snmptraps:alpine-5.0-latest
   ```

4. 启动Zabbix服务器实例并将该实例与创建的PostgreSQL服务器实例链接。Zabbix服务器实例将10051 / TCP端口（Zabbix trapper）公开给主机。

   ```bash
   docker run --name zabbix-server-pgsql -t \
         -e DB_SERVER_HOST="postgres-server" \
         -e POSTGRES_USER="zabbix" \
         -e POSTGRES_PASSWORD="zabbix_pwd" \
         -e POSTGRES_DB="zabbix" \
         -e ZBX_ENABLE_SNMP_TRAPS="true" \
         --network=zabbix-net \
         -p 10051:10051 \
         --volumes-from zabbix-snmptraps \
         --restart unless-stopped \
         -d zabbix/zabbix-server-pgsql:alpine-5.0-latest
   ```

5. 启动Zabbix Web界面，并将实例与创建的PostgreSQL服务器和Zabbix服务器实例链接。Zabbix Web界面实例向主机公开443 / TCP端口（HTTPS）。 目录/ etc / ssl / nginx必须包含具有所需名称的证书。

   ```bash
   docker run --name zabbix-web-nginx-pgsql -t \
         -e ZBX_SERVER_HOST="zabbix-server-pgsql" \
         -e DB_SERVER_HOST="postgres-server" \
         -e POSTGRES_USER="zabbix" \
         -e POSTGRES_PASSWORD="zabbix_pwd" \
         -e POSTGRES_DB="zabbix" \
         --network=zabbix-net \
         -p 443:8443 \
         -p 80:8080 \
         -v /etc/ssl/nginx:/etc/ssl/nginx:ro \
         --restart unless-stopped \
         -d zabbix/zabbix-web-nginx-pgsql:alpine-5.0-latest
   ```

 **示例 3** 

在Red Hat 8上使用podman运行具有MySQL数据库支持的Zabbix服务器，基于Nginx Web服务器的Zabbix Web界面以及Zabbix Java gateway。

1. 使用名称zabbix和公开的端口（Web界面，Zabbix server trapper）创建新的Pod：

   ```bash
   podman pod create --name zabbix -p 80:8080 -p 10051:10051
   ```

2. (可选）在zabbix pod位置启动Zabbix agent容器：

   ```bash
   podman run --name zabbix-agent \
       -eZBX_SERVER_HOST="127.0.0.1,localhost" \
       --restart=always \
       --pod=zabbix \
       -d registry.connect.redhat.com/zabbix/zabbix-agent-50:latest
   ```

3. 在主机上创建./mysql/目录，然后启动Oracle MySQL server 8.0：

   ```bash
   podman run --name mysql-server -t \
         -e MYSQL_DATABASE="zabbix" \
         -e MYSQL_USER="zabbix" \
         -e MYSQL_PASSWORD="zabbix_pwd" \
         -e MYSQL_ROOT_PASSWORD="root_pwd" \
         -v ./mysql/:/var/lib/mysql/:Z \
         --restart=always \
         --pod=zabbix \
         -d mysql:8.0 \
         --character-set-server=utf8 --collation-server=utf8_bin \
         --default-authentication-plugin=mysql_native_password
   ```

4. 启动Zabbix server容器：

   ```bash
   podman run --name zabbix-server-mysql -t \
                     -e DB_SERVER_HOST="127.0.0.1" \
                     -e MYSQL_DATABASE="zabbix" \
                     -e MYSQL_USER="zabbix" \
                     -e MYSQL_PASSWORD="zabbix_pwd" \
                     -e MYSQL_ROOT_PASSWORD="root_pwd" \
                     -e ZBX_JAVAGATEWAY="127.0.0.1" \
                     --restart=always \
                     --pod=zabbix \
                     -d registry.connect.redhat.com/zabbix/zabbix-server-mysql-50
   ```

   

5. 启动Zabbix Java Gateway容器。

   ```bash
   podman run --name zabbix-java-gateway -t \
         --restart=always \
         --pod=zabbix \
         -d registry.connect.redhat.com/zabbix/zabbix-java-gateway-50
   ```

### Docker Compose

compose 文件可以在 github.com: https://github.com/zabbix/zabbix-docker 上的 Zabbix docker 官方镜像仓库中找到。

以下为几个不同版本的 compose 文件：

| **文件名**                                   | **描述**                                                     |
| -------------------------------------------- | ------------------------------------------------------------ |
| `docker-compose_v3_alpine_mysql_latest.yaml` | 该 compose 文件运行基于 Alpine Linux 的 Zabbix 5.0 最新版本的组件，支持 MySQL 数据库。 |
| `docker-compose_v3_alpine_mysql_local.yaml`  | 该 compose 文件本地构建和运行基于 Alpine Linux 的 Zabbix 5.0 最新版本的组件，支持 MySQL数据库。 |
| `docker-compose_v3_alpine_pgsql_latest.yaml` | 该 compose 文件运行基于 Alpine Linux 的 Zabbix 5.0 最新版本的组件，支持 PostgreSQL 数据库。 |
| `docker-compose_v3_alpine_pgsql_local.yaml`  | 该 compose 文件本地构建和运行基于 Apline Linux 的 Zabbix 5.0 最新版本的组件，支持 PostgreSQL 数据库。 |
| `docker-compose_v3_centos_mysql_latest.yaml` | 该 compose 文件运行基于 CentOS8 的 Zabbix 5.0 最新版本的组件，支持 MySQL 数据库。 |
| `docker-compose_v3_centos_mysql_local.yaml`  | 该 compose 文件本地构建和运行基于 CentOS8 的 Zabbix 5.0 最新版本的组件，支持 MySQL 数据库。 |
| `docker-compose_v3_centos_pgsql_latest.yaml` | 该 compose 文件运行基于 CentOS8 的 Zabbix 5.0 最新版本的组件，支持 PostgreSQL 数据库。 |
| `docker-compose_v3_centos_pgsql_local.yaml`  | 该 compose 文件本地构建和运行基于 CentOS8 的 Zabbix 5.0 最新版本的组件，支持 PostgreSQL 数据库。 |
| `docker-compose_v3_ubuntu_mysql_latest.yaml` | 该 compose 文件运行基于 Ubuntu 20.04 的 Zabbix 5.0 最新版本的组件，支持 MySQL 数据库。 |
| `docker-compose_v3_ubuntu_mysq l_local.yaml` | 该 compose 文件本地构建和运行基于 Ubuntu 20.04 的 Zabbix 5.0 最新版本的组件，支持 MySQL 数据库。 |
| `docker-compose_v3_ubuntu_pgsql_latest.yaml` | 该 compose 文件运行基于 Ubuntu 20.04 的 Zabbix 5.0 最新版本的组件，支持 PostgreSQL 数据库。 |
| `docker-compose_v3_ubuntu_pgsql_local.yaml`  | 该 compose 文件本地构建和运行基于 Ubuntu 20.04 的 Zabbix 5.0 最新版本的组件，支持 PosegreSQL 数据库。 |

#### 存储

撰写文件被配置为支持主机上的本地存储。 当您使用compose文件运行Zabbix组件时，Docker Compose将在文件夹中使用compose文件创建一个zbx_env目录。 该目录将包含与上述“[卷](https://www.zabbix.com/documentation/5.0/zh/manual/installation/containers)”部分中描述的结构相同的目录以及用于数据库存储的目录。

此外，还有卷 `/etc/localtime` 和 `/etc/timezone` 下的文件为只读模式。

#### 环境变量文件

在 github.com 上与存放 compose 文件的同一目录中，您可以在 compose 文件中找到每个组件的默认环境变量文件，这些环境变量文件的命令与 `.env_<type of component>` 类似。

#### 示例

 **示例 1** 



```bash
git checkout 5.0
docker-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
```



该命令将为每个Zabbix组件下载最新的Zabbix 5.0映像，并在分离模式下运行它们。

不要忘记从 github.com 的 Zabbix 官方镜像仓库下载 `.env_<type of component>` 文件和 compose 文件。

 **示例 2** 



```bash
git checkout 5.0
docker-compose -f ./docker-compose_v3_ubuntu_mysql_local.yaml up -d
```

该命令将下载基本映像Ubuntu 20.04（本地），然后在本地构建Zabbix 5.0组件并以分离模式运行它们。

## Web界面安装

以下部分介绍如何一步一步安装Zabbix Web界面。Zabbix Web界面使用PHP语言编写,所以Zabbix Web界面必须在支持PHP环境的web服务器上运行. 

 如果需要使用除了英语以外的其他语言，在Web服务器上必须安装相关的语言支持. 如果有需要使用其他的语言环境，在请查看“User profile”的相关章节["另请参见"](https://www.zabbix.com/documentation/5.0/manual/web_interface/user_profile#see_also) 

#### 欢迎页面

从浏览器上打开Zabbix前端访问URL. 如果你是从packages方式安装Zabbix, URL是:

-  对应Apache: *http://<server_ip_or_name>/zabbix*  
-  对应Nginx: *http://<server_ip_or_name>*

您看到的第一个Web前端安装向导页面如下.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_1_c.png?w=550&tok=d3e775)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_1_c.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

#### 先决条件检查

请确保先满足所有软件先决条件.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_2.png?w=550&tok=e33038)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_2.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

| 先决条件                            | 最小满足要求                         | 描述                                                         |
| ----------------------------------- | ------------------------------------ | ------------------------------------------------------------ |
| *PHP version*                       | 7.2.0                                |                                                              |
| *PHP memory_limit option*           | 128MB                                | 在配置文件php.ini:  memory_limit = 128M                      |
| *PHP post_max_size option*          | 16MB                                 | 在配置文件php.ini:  post_max_size = 16M                      |
| *PHP upload_max_filesize option*    | 2MB                                  | 在配置文件php.ini:  upload_max_filesize = 2M                 |
| *PHP max_execution_time option*     | 300 秒 ( 0 和 -1 值 被允许)          | 在配置文件 php.ini:  max_execution_time = 300                |
| *PHP max_input_time option*         | 300 秒 (0 和 -1 值 被允许)           | 在配置文件 php.ini:  max_input_time = 300                    |
| *PHP session.auto_start option*     | 必须关闭                             | 在配置文件 php.ini:  session.auto_start = 0                  |
| *Database support*                  | 其中之一: MySQL, Oracle, PostgreSQL. | 以下必须安装其中一个模块:  mysql, oci8, pgsql                |
| *bcmath*                            |                                      | php-bcmath                                                   |
| *mbstring*                          |                                      | php-mbstring                                                 |
| *PHP mbstring.func_overload option* | 必须关闭                             | 在配置文件 php.ini:  mbstring.func_overload = 0              |
| *sockets*                           |                                      | php-net-socket. 需要用户脚本支持.                            |
| *gd*                                | 2.0.28                               | php-gd. PHP GD 扩展性必须支持PNG格式的图片 (*--with-png-dir*), JPEG (*--with-jpeg-dir*) images and FreeType 2 (*--with-freetype-dir*). |
| *libxml*                            | 2.6.15                               | php-xml                                                      |
| *xmlwriter*                         |                                      | php-xmlwriter                                                |
| *xmlreader*                         |                                      | php-xmlreader                                                |
| *ctype*                             |                                      | php-ctype                                                    |
| *session*                           |                                      | php-session                                                  |
| *gettext*                           |                                      | php-gettext  从 Zabbix 2.2.1版本开始, PHP gettext 扩展性不是安装Zabbix的强制性要求. 如果没有安装gettext, 前端也能够正常运行, 然而, 翻译将不可用. |

可选的先决条件也可能出现在清单中。失败的可选先决条件显示为橙色，并处于*Warning*状态。如果可选前提条件失败，安装程序也可以继续。

如果需要更改Apache用户或用户组，则必须验证对会话文件夹的权限。否则，Zabbix安装程序可能无法继续。

#### 配置数据库连接

输入连接数据库所需的详细信息. Zabbix数据库必须先建立好.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_3.png?w=550&tok=6de07c)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_3.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

如果选中*TLS加密选项*选项, 额外需要填写的字段会显示并需要填写 [配置TLS连接信息](https://www.zabbix.com/documentation/5.0/manual/appendix/install/db_encrypt) (只支持MySQL或PostgreSQL数据库).

#### Zabbix服务器详情

请输入Zabbix服务器详情.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_4.png?w=550&tok=bdd8d7)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_4.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

可选的输入Zabbix服务器的名字, 然而, 如果输入并提交了, Zabbix服务器的名字将会显示在菜单和页面的标题.

#### 安装前总结

回顾所有配置.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_5.png?w=550&tok=33d529)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_5.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

#### Install

如果是从源代码处安装，请下载配置文件，并将其放在web服务器 HTML documents子目录下，您所复制的Zabbix PHP文件的conf/目录下。.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_6.png?w=550&tok=e7c6cc)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_6.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/saving_zabbix_conf.png?w=350&tok=43dae7)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/saving_zabbix_conf.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

如果webserver用户对conf/目录有写访问权，配置文件将自动保存，并且可以立即进入下一步.

完成安装.

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/installation/install_7.png?w=550&tok=dca6ba)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/installation/install_7.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

#### 登录

Zabbix前端已经安装完成! 缺省用户名是 **Admin**, 密码 **zabbix**.

[![img](https://www.zabbix.com/documentation/5.0/_media/manual/quickstart/login.png?w=350&tok=128699)](https://www.zabbix.com/documentation/5.0/_detail/manual/quickstart/login.png?id=zh%3Amanual%3Ainstallation%3Afrontend)

下一步 [开始你的Zabbix旅行](https://www.zabbix.com/documentation/5.0/manual/quickstart/login).

### RHEL/CentOS 7 前端安装

从Zabbix 5.0版本开始，Zabbix前端需要PHP 7.2版或更高版本。 非常不幸的是, RHEL/CentOS 7 缺省只提供PHP 5.4版本. 本章节介绍在RHEL/CentOS 7上安装Zabbix前端的建议方法。

### 使用Red Hat软件集合中的PHP和Nginx

如果你从官方提供的安装包[repo.zabbix.com](https://repo.zabbix.com/)完成了Zabbix 5.0的干净的安装, 使用yum搜索Zabbix时，您可能会注意到缺少前端包。.

```
zabbix-agent.x86_64 : Old Zabbix Agent
zabbix-get.x86_64 : Zabbix Get
zabbix-java-gateway.x86_64 : Zabbix java gateway
zabbix-js.x86_64 : Zabbix JS
zabbix-proxy-mysql.x86_64 : Zabbix proxy for MySQL or MariaDB database
zabbix-proxy-pgsql.x86_64 : Zabbix proxy for PostgreSQL database
zabbix-proxy-sqlite3.x86_64 : Zabbix proxy for SQLite3 database
zabbix-release.noarch : Zabbix repository configuration
zabbix-sender.x86_64 : Zabbix Sender
zabbix-server-mysql.x86_64 : Zabbix server for MySQL or MariaDB database
zabbix-server-pgsql.x86_64 : Zabbix server for PostgresSQL database
```

这是因为前端包被移动到了一个专用的前端子目录 `frontend` .
 然而, Zabbix前端是可以被安装的，前提是PHP 7.2依赖条件已经提供.

 为了方便起见，已经从主`zabbix-web`包中删除了对PHP的任何直接依赖。这为解决PHP7.2依赖关系的方法提供了更大的灵活性。 

建议使用Red Hat软件集合中的PHP包。 [Red Hat Software Collections](https://access.redhat.com/documentation/en-us/red_hat_software_collections/3/).
 启用PHP包，执行:

在RHEL环境下

```
# yum-config-manager --enable rhel-server-rhscl-7-rpms
```

在CentOS环境下

```
# sudo yum install centos-release-scl
```

在Oracle Linux环境下

```
# yum install scl-utils
# yum install oraclelinux-release-el7
# /usr/bin/ol_yum_configure.sh
# yum-config-manager --enable software_collections
# yum-config-manager --enable ol7_latest ol7_optional_latest 
```

此时，执行

```
# yum list rh-php7\*
```

会返回显示新的rh-php7*列表.

然后, 编辑 `/etc/yum.repos.d/zabbix.repo` 文件 (如果没有此文件, 先安装 [zabbix-release](https://www.zabbix.com/download)). 打开 `zabbix-frontend` 存储库.

```
[zabbix-frontend]
...
enabled=1
...
```

把 `enabled=0` 替代成 `enabled=1`.

在此阶段，通过`yum`搜索`Zabbix`将返回`zabbix-web`包和四个新包。  这四个包是:

```
zabbix-nginx-conf-scl.noarch : Nginx的Zabbix前端配置 (scl 版本)
zabbix-web-deps-scl.noarch : 用于从redhat软件集合安装zabbix-web包所需PHP依赖项的便利包
zabbix-web-mysql-scl.noarch : 用于MySQL数据库的Zabbix web前端包 (scl 版本)
zabbix-web-pgsql-scl.noarch : 用于PostgreSQL数据库的Zabbix web前端包(scl 版本)
```

在安装MySQL数据库所需的`zabbix-web-mysql-scl`或者 PostgreSQL数据库所需的`zabbix-web-pgsql-scl`. 取决于Web服务器的需要，也请安装`zabbix-apache-conf-scl` 或者 `zabbix-nginx-conf-scl`.

 在Zabbix 4.4版本中，已经加入了对Nginx的支持, 但是官方的RHEL/CentOS 7存储库中没有可用的web服务器. 因此, 它必须通过第三方仓库提供, 由用户安装。尤其是 `epel`. 在Zabbix 5.0, 如果您选择使用Red Hat软件集合, 无需使用任何第三方存储库，因为SCL中提供Nginx. 只需安装`zabbix-nginx-conf-scl`包. 

### 新包的技术细节

**zabbix-web-deps-scl**

这个包用于从Red Hat软件集合中提取Zabbix前端的常见PHP依赖项。.

```
# repoquery --requires zabbix-web-deps-scl
rh-php72
rh-php72-php-bcmath
rh-php72-php-fpm
rh-php72-php-gd
rh-php72-php-ldap
rh-php72-php-mbstring
rh-php72-php-xml
```

它还包含用于Zabbix的php fpm池，因为在这种配置中，前端可以通过fastcgi与Apache和Nginx一起工作。
 配置文件位于`/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf`.

**zabbix-web-mysql-scl**

元软件包用于获取`zabbix-web`包、PHP对MySQL数据库模块的支持以及常见的PHP依赖项.

```
# repoquery --requires zabbix-web-mysql-scl
rh-php72-php-mysqlnd
zabbix-web
zabbix-web-deps-scl
```

**zabbix-web-pgsql-scl**

元软件包用于获取`zabbix-web`包、PHP对PostgreSQL数据库模块的支持以及常见的PHP依赖项。

```
# repoquery --requires zabbix-web-pgsql-scl
rh-php72-php-pgsql
zabbix-web
zabbix-web-deps-scl
```

**zabbix-apache-conf-scl**

这个包用于获取apache并包含`/etc/httpd/cond.d/zabbix.conf` 文件.

```
# repoquery --requires zabbix-apache-conf-scl
httpd
zabbix-web-deps-scl
```

**zabbix-nginx-conf-scl**

这个包用于从Red Hat软件集合中提取Nginx.

```
# repoquery --requires zabbix-nginx-conf-scl
rh-nginx116-nginx
zabbix-web
```

它还包含Nginx服务器所需的Zabbix配置文件，文件在 `/etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf`.

### 使用第三方PHP存储库

如果由于某些原因不能够使用Red Hat软件集合, 可以用以下的替代办法:

-  使用任何可以提供PHP的第三方存储库。
-  从源代码构建PHP。

Zabbix前端所需的PHP模块是`php-gd`, `php-bcmath`, `php-mbstring`, `php-xml`, `php-ldap` 和 `php-json`.

### 从旧版本Zabbix升级至Zabbix 5.0版本

在旧版本升级至Zabbix 5.0版本时，需要特别注意一些事项。

[请查看通用升级指引.](https://www.zabbix.com/documentation/5.0/manual/installation/upgrade/packages/rhel_centos)

Red Hat软件集合中的包旨在避免与主存储库中的文件冲突.
 每一个特定的包都被安装到一个单独的环境中，专门用于它的组.
 例如, 来自rh-php72-php*组的 在 `/etc/opt/rh/rh-php72/` 目录下会有对应的配置文件, 日志会生成在 `/var/opt/rh/rh-php72/log/` 目录下, 等等. 这些包提供的服务具有不寻常的名称，如`rh-php72-php-fpm` or `rh-nginx116-nginx`。

官方的zabbix5.0前端包将php-fpm与Apache和Nginx结合使用

#### 在Apache环境下的升级进程

本章节提供了有关将Zabbix前端和服务端从4.0版本或4.4版本升级到5.0版本，与Apache相关的特定说明.  与Nginx相关的指引请参见[在Nginx环境下的升级进程](https://www.zabbix.com/documentation/5.0/manual/installation/install_from_packages/frontend_on_rhel7?do=edit#upgrade_process_with_nginx). 
 下面的说明是针对已经安装MySQL支持的Zabbix服务。将命令中的“mysql”替换为“pgsql”可以适用于PostgreSQL数据库

下面假设Zabbix前端和Zabbix服务安装在同一台服务器上。如果您的Zabbix相关服务安装与之不同，请根据实际情况调整。

**清除旧的Zabbix前端**

在升级开始之前，你必须把已有的Zabbix前端清除。 旧的配置文件将会被rpm移动到 `/etc/httpd/conf.d/zabbix.conf.rpmsave`. 

```
yum remove zabbix-web-*
```

**安装 SCL 存储库**

在 `RHEL`环境下执行 

```
yum-config-manager --enable rhel-server-rhscl-7-rpms
```

在 `CentOS`环境下执行

```
yum install centos-release-scl
```

在 `Oracle Linux`环境下执行

```
yum install scl-utils
yum install oraclelinux-release-el7
/usr/bin/ol_yum_configure.sh
yum-config-manager --enable software_collections
yum-config-manager --enable ol7_latest ol7_optional_latest
```

**安装Zabbix 5.0发行包并启用Zabbix前端存储库**

安装 `zabbix-release-5.0` 包.

```
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all
```

编辑 `/etc/yum.repos.d/zabbix.repo` file. 把 `enabled=0` 替换成 `enabled=1`.

```
[zabbix-frontend]
...
enabled=1
...
```

**安装新的前端包**

```
yum install zabbix-web-mysql-scl zabbix-apache-conf-scl
```

官方Zabbix 5.0前端包使用php-fpm. 在`/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf`文件中更新时区.

 **更新剩余的包并重启Zabbix server**

```
yum update zabbix-*
```

重启Zabbix server 将会升级数据库. 请确保数据库已经备份.

```
systemctl restart zabbix-server
```

 **更新剩余的服务** 

启用并开启php-fpm服务。

```
systemctl start rh-php72-php-fpm
systemctl enable rh-php72-php-fpm
```

重启Apache.

```
systemctl restart httpd
```

#### 在Nginx环境下的升级进程

遵循上面描述的apache升级过程，但做一些调整.
 以下几个步骤需要执行:

在升级之前，请确保停止并禁用旧的Nginx和php-fpm。执行:

```
systemctl stop nginx php-fpm
systemctl disable nginx php-fpm
```

为php-fpm编辑`zabbix.conf` 文件时, 添加用户`nginx` 到`listen.acl_users`

```
listen.acl_users = apache,nginx
```

确保`zabbix-nginx-conf-scl` 包已经被安装，而不是`zabbix-apache-conf-scl`包被安装.

```
yum install zabbix-nginx-conf-scl
```

编辑 `/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf` 文件.
 Configure `listen` and `server_name` directives.

```
#        listen          80;
#        server_name     example.com;
```

启动并启用 Nginx和php-fpm

```
systemctl start rh-nginx116-nginx rh-php72-php-fpm
systemctl enable rh-nginx116-nginx rh-php72-php-fpm
```

### Debian/Ubuntu前端安装

从Zabbix 5.0版本开始，Zabbix前端需要PHP 7.2版或更高版本。 非常不幸的是, 旧版本的Debian & Ubuntu提供PHP 7.2以下的版本。

#### 发行版支持的PHP版本

| 发行版版本             | PHP 版本 |
| ---------------------- | -------- |
| Debian 10    (buster)  | 7.3      |
| Debian 9     (stretch) | 7.0      |
| Debian 8     (jessie)  | 5.6      |
| Ubuntu 20.04 (focal)   | 7.4      |
| Ubuntu 18.04 (bionic)  | 7.2      |
| Ubuntu 16.04 (xenial)  | 7.0      |
| Ubuntu 14.04 (trusty)  | 5.5      |
| Raspbian 10  (buster)  | 7.3      |
| Raspbian 8   (stretch) | 7.0      |

在 *stretch, jessie, xenial和trusty*的发行版中, PHP 7.2 依赖并不可用, 因此 Zabbix 前端或更高版本不能简单地安装.  考虑到这方面的原因, 在上述发行版上，`zabbix-frontend-php` 包已经被替换成为 `zabbix-frontend-php-deprecated`。
 主要区别在于没有对任何php或web服务器包的直接依赖。 因此，用户可以（而且必须）自己提供这些依赖关系. 换句话说, 安装`zabbix-frontend-php-deprecated` 包并不会提供可用的Zabbix前端. 必须手动安装web服务器以及PHP7.2及其模块（从源代码处使用PPAs/build PHP）. 我们不支持任何特别的方法.

在老版本的Debian/Ubuntu上获得php7.2或更高版本的官方方法是升级到buster/bionic发行版

Zabbix前端所需的PHP模块是 `php-gd`, `php-bcmath`, `php-mbstring`, `php-xml`, `php-ldap` 和 `php-json`. 

### 已知问题



#### 全局事件关联

如果第一次和第二次事件之间的时间间隔非常短，即半秒或更短，则事件可能无法正确关联。

#### IPMI 检查

在 Debian 9（stretch）之前和 Ubuntu16.04（xenial）之前使用 OpenIPMI 库，IPMI 检查可能无法正常工作。若要解决此问题，需要重新编译 OpenIPMI 库并启用 OpenSSL，详见[ZBX-6139](https://support.zabbix.com/browse/ZBX-6139)。

#### SSH 检查

一些 Linux 发行版本如 Debian、Ubuntu，如果使用了安装包安装了 libssh2 类库，则系统将不支持使用密码加密私钥，详见 [ZBX-4850](https://support.zabbix.com/browse/ZBX-4850) 获得更多信息。

#### ODBC 检查

由于 [upstream bug](https://bugs.mysql.com/bug.php?id=73709)，如果 Zabbix server 或 proxy 使用 MySQL 作为其数据库，MySQL ODBC 库可能无法使用。有关更多信息和可用的解决办法，详见 [ZBX-7665](https://support.zabbix.com/browse/ZBX-7665)。

由于 Microsoft 的 [问题](https://support.microsoft.com/en-us/help/310378/the-xml-data-row-is-truncated-at-2-033-characters-when-you-use-the-sql)。从 Microsoft SQL Server 查询的 XML 数据可能会被截断为 2033 个字符。

#### HTTPS 检查

在使用 https 协议的 Web 场景和 HTTP agent 监控项，如果目标服务器配置了禁止 TLS v1.0 或更低版本的协议，Zabbix agent 检查 `net.tcp.service[https…]` 和 `net.tcp.service.perf[https…]` 可能会失败。有关更多信息和可用的解决方法，详见[ZBX-9879](https://support.zabbix.com/browse/ZBX-9879)。

#### Web 监控和 HTTP agent

当 "SSL verify peer" 在 Web 场景或 HTTP agent 启用时，由于[upstream bug](https://bugzilla.redhat.com/show_bug.cgi?id=1057388)，Zabbix server 可能在 CentOS6、CentOS7和其他相关 Linux 发行版本上发生内存泄露。有关更多信息和可用的解决方法，详见[ZBX-10486](https://support.zabbix.com/browse/ZBX-10486)。

#### 简单检查

由于早于 v3.10 和 2.1.2 版本的 **fping** 存在一个 BUG，即它错误地处理重复的回放数据包。这可能会使监控项 `icmpping`、`icmppingloss`、`icmppingsec` 导致一些意外的结果。建议使用最新版本的**fping**。详见 [ZBX-11726](https://support.zabbix.com/browse/ZBX-11726) 获得更多信息。

#### SNMP 检查

如果使用 OpenBSD 操作系统，并在 Zabbix server 的配置文件中设置了 SourceIP 参数，则在 5.7.3 版本的  Net-SNMP 库中的一个 Use-After-Free（UAF）漏洞可能导致Zabbix server 崩溃。 作为解决方法，请不要设置  SourceIP 参数。 同样的问题也适用于Linux，但它不会导致 Zabbix server 停止工作。应用与 OpenBSD 上  net-snmp 软件包的局部补丁，将会随 OpenBSD 6.3 版本一起发布。

#### PHP 7.0 的兼容性问题

已经观察到，使用 PHP 7.0 导入具有 Web 监控触发器的模板，可能会因触发器表达式中的 Web 监控项的双引号错误而导入失败。 但将 PHP 升级到 7.1 时，问题就随之消失了。

#### 图表

切换到夏令时（Daylight Saving Time，DST）会导致显示 X 轴标签错误（如日期重复，日期缺失等）。

#### 日志文件监控

当文件系统空间为 100% 已满时，如果日志文件仍然在被追加，那么 `log[]` 和 `logrt[]` 监控想会反复从头重新读取日志文件。详见 [ZBX-10884](https://support.zabbix.com/browse/ZBX-10884) 获得更多信息。

#### MySQL 的慢查询

如果监控项的值不存在，那么 Zabbix server 将会生成慢查询（关于 SELECT）。这是由于 MySQL 5.6/5.7 版本中一个已知的[问题](https://bugs.mysql.com/bug.php?id=74602)造成的。解决此问题的办法是在 MySQL 中禁用 index_condition_pushdown 优化器。详见[ZBX-10652](https://support.zabbix.com/browse/ZBX-10652)。

#### API

如果使用 `history.get` 方法，则 **output**  参数将无法正常工作。

#### API login

当使用带有 `user.login` [方法](https://www.zabbix.com/documentation/5.0/manual/api/reference/user/login) 的自定义脚本时，则可以创建大量开放式用户会话，而无需遵循 `user.logout`。

