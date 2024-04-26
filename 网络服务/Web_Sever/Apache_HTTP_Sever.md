# Apache HTTP web Server

[TOC]

## 概述

http://httpd.apache.org

​				*Web 服务器*是一个通过 Web 向客户端提供内容的网络服务。这通常是网页，但也可以提供任何其他文档。Web 服务器也称为 HTTP 服务器，因为它们使用 *超文本传输协议* (**HTTP**)。 		

​				**Apache HTTP 服务器** `httpd` 是由 [Apache Software Foundation](http://www.apache.org/) 开发的开源 Web 服务器。 		

​				如果您要从之前的 Red Hat Enterprise Linux 版本升级，您必须相应地更新 `httpd` 服务配置。本节介绍了一些新添加的功能，并指导您完成之前的配置文件的更新。 

# 如何安装 Apache2

[The Apache HTTP Server](https://httpd.apache.org/) (“httpd”) is the most commonly used web server on Linux systems, and is often used as part of the LAMP configuration. In this guide, we will  show you how to install and configure Apache2, which is the current  release of “httpd”.
Apache HTTP 服务器 （“httpd”） 是 Linux 系统上最常用的 Web 服务器，通常用作 LAMP 配置的一部分。在本指南中，我们将向您展示如何安装和配置 Apache2，这是“httpd”的当前版本。

## Install `apache2` 安装 `apache2` 

To install Apache2, enter the following command at the terminal prompt:
要安装 Apache2，请在终端提示符下输入以下命令：

```bash
sudo apt install apache2
```

## Configure `apache2` 配置 `apache2` 

Apache2 is configured by placing **directives** in plain text configuration files in `/etc/apache2/`. These *directives* are separated between the following files and directories:
Apache2 是通过将指令放在纯文本配置文件中的来 `/etc/apache2/` 配置的。这些指令在以下文件和目录之间分隔：

### Files 文件

- `apache2.conf`
   The main Apache2 configuration file. Contains settings that are **global** to Apache2.
  Apache2 主配置文件。包含 Apache2 的全局设置。

  > **Note**: Historically, the main Apache2 configuration file was `httpd.conf`, named after the “httpd” daemon. In other distributions (or older  versions of Ubuntu), the file might be present. In modern releases of  Ubuntu, all configuration options have been moved to `apache2.conf` and the below referenced directories and `httpd.conf` no longer exists.
  > 注意：从历史上看，主要的 Apache2 配置文件是 `httpd.conf` ，以“httpd”守护进程命名。在其他发行版（或旧版本的 Ubuntu）中，该文件可能存在。在 Ubuntu 的现代版本中，所有配置选项都已移至 `apache2.conf` 以下引用的目录中，不再 `httpd.conf` 存在。

- `envvars`
   File where Apache2 **environment** variables are set.
  设置 Apache2 环境变量的文件。

- `magic`
   Instructions for determining MIME type based on the first few bytes of a file.
  根据文件的前几个字节确定 MIME 类型的说明。

- `ports.conf`
   Houses the directives that determine which TCP ports Apache2 is listening on.
  包含确定 Apache2 正在侦听的 TCP 端口的指令。

In addition, other configuration files may be added using the **Include** directive, and wildcards can be used to include many configuration  files. Any directive may be placed in any of these configuration files.  Changes to the main configuration files are only recognized by Apache2  when it is started or restarted.
此外，可以使用 Include 指令添加其他配置文件，并且通配符可用于包含许多配置文件。任何指令都可以放在这些配置文件中的任何一个中。对主配置文件的更改只有在 Apache2 启动或重新启动时才能识别。

The server also reads a file containing MIME document types; the filename is set by the **TypesConfig** directive, typically via `/etc/apache2/mods-available/mime.conf`, which might also include additions and overrides, and is `/etc/mime.types` by default.
服务器还读取包含 MIME 文档类型的文件;默认情况下，文件名由 TypesConfig 指令设置，通常通过 `/etc/apache2/mods-available/mime.conf` ，其中可能还包括添加和重写 `/etc/mime.types` 。

### Directories 目录

- `conf-available`
   This directory contains available configuration files. All files that were previously in `/etc/apache2/conf.d` should be moved to `/etc/apache2/conf-available`.
  此目录包含可用的配置文件。以前所在的 `/etc/apache2/conf.d` 所有文件都应移动到 `/etc/apache2/conf-available` 。
- `conf-enabled`
   Holds **symlinks** to the files in `/etc/apache2/conf-available`. When a configuration file is symlinked, it will be enabled the next time Apache2 is restarted.
  保存指向 中的文件的 `/etc/apache2/conf-available` 符号链接。当配置文件被符号链接时，它将在下次重新启动 Apache2 时启用。
- `mods-available`
   This directory contains configuration files to both load **modules** and configure them. Not all modules will have specific configuration files, however.
  此目录包含用于加载模块和配置模块的配置文件。但是，并非所有模块都有特定的配置文件。
- `mods-enabled`
   Holds symlinks to the files in `/etc/apache2/mods-available`. When a module configuration file is symlinked it will be enabled the next time Apache2 is restarted.
  保存指向 中的文件的 `/etc/apache2/mods-available` 符号链接。当模块配置文件被符号链接时，它将在下次重新启动 Apache2 时启用。
- `sites-available`
   This directory has configuration files for Apache2 **Virtual Hosts**. Virtual Hosts allow Apache2 to be configured for multiple sites that have separate configurations.
  此目录包含 Apache2 虚拟主机的配置文件。虚拟主机允许为具有单独配置的多个站点配置 Apache2。
- `sites-enabled`
   Like `mods-enabled`, `sites-enabled` contains symlinks to the `/etc/apache2/sites-available` directory. Similarly, when a configuration file in `sites-available` is symlinked, the site configured by it will be active once Apache2 is restarted.
  Like `mods-enabled` ， `sites-enabled` 包含指向目录的 `/etc/apache2/sites-available` 符号链接。同样，当配置文件 `sites-available` 被符号链接时，一旦 Apache2 重新启动，它配置的站点将处于活动状态。

## Detailed configuration 详细配置

For more detailed information on configuring Apache2, check out our follow-up guides.
有关配置 Apache2 的更多详细信息，请查看我们的后续指南。

- Part 2: [Apache2 configuration settings](https://ubuntu.com/server/docs/how-to-configure-apache2-settings)
  第 2 部分：Apache2 配置设置
- Part 3: [how to extend Apache2](https://ubuntu.com/server/docs/how-to-use-apache2-modules) with modules.
  第 3 部分：如何使用模块扩展 Apache2。

## Further reading 延伸阅读

- [Apache2 Documentation](https://httpd.apache.org/docs/2.4/) contains in depth information on Apache2 configuration directives. Also, see the `apache2-doc` package for the official Apache2 docs.
  Apache2 文档包含有关 Apache2 配置指令的深入信息。另外，请参阅官方 Apache2 文档的 `apache2-doc` 软件包。
- O’Reilly’s [Apache Cookbook](http://shop.oreilly.com/product/9780596529949.do) is a good resource for accomplishing specific Apache2 configurations.
  O'Reilly 的 Apache Cookbook 是完成特定 Apache2 配置的良好资源。
- For Ubuntu-specific Apache2 questions, ask in the *#ubuntu-server* IRC channel on [libera.chat](https://libera.chat/).
  对于特定于 Ubuntu 的 Apache2 问题，请在 libera.chat 上的 #ubuntu-server IRC 频道中提问。

​		

# How to configure Apache2 settings 如何配置 Apache2 设置

After you have [installed Apache2](https://ubuntu.com/server/docs/how-to-install-apache2), you will likely need to configure it. In this explanatory guide, we  will explain the Apache2 server essential configuration parameters.
安装 Apache2 后，您可能需要对其进行配置。在本解释性指南中，我们将解释 Apache2 服务器的基本配置参数。

## Basic directives 基本指令

Apache2 ships with a “virtual-host-friendly” default configuration – it is  configured with a single default virtual host (using the **VirtualHost** directive) which can be modified or used as-is if you have a single  site, or used as a template for additional virtual hosts if you have  multiple sites.
Apache2 附带了一个“虚拟主机友好”的默认配置——它配置了一个默认虚拟主机（使用 VirtualHost 指令），如果您有一个站点，可以按原样修改或使用，或者如果您有多个站点，则用作其他虚拟主机的模板。

If left alone, the default virtual host will serve as your default site,  or the site users will see if the URL they enter does not match the **ServerName** directive of any of your custom sites. To modify the default virtual host, edit the file `/etc/apache2/sites-available/000-default.conf`.
如果不动，默认虚拟主机将用作默认站点，或者站点用户将看到他们输入的 URL 是否与任何自定义站点的 ServerName 指令不匹配。要修改默认虚拟主机，请编辑文件 `/etc/apache2/sites-available/000-default.conf` 。

> **Note**: 注意：
>  The directives set for a virtual host only apply to that particular  virtual host. If a directive is set server-wide and not defined in the  virtual host settings, the default setting is used. For example, you can define a Webmaster email address and not define individual email  addresses for each virtual host.
> 为虚拟主机设置的指令仅适用于该特定虚拟主机。如果指令是在服务器范围内设置的，并且未在虚拟主机设置中定义，则使用默认设置。例如，您可以定义网站站长电子邮件地址，而不是为每个虚拟主机定义单独的电子邮件地址。

If you want to configure a new virtual host or site, copy the `000-default.conf` file into the same directory with a name you choose. For example:
如果要配置新的虚拟主机或站点，请将 `000-default.conf` 文件复制到具有您选择的名称的同一目录中。例如：

```bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/mynewsite.conf
```

Edit the new file to configure the new site using some of the directives described below:
编辑新文件以使用下面描述的一些指令配置新站点：

### The **ServerAdmin** directive ServerAdmin 指令

> Found in `/etc/apache2/sites-available` 发现于 `/etc/apache2/sites-available` 

Specifies the email address to be advertised for the server’s administrator. The default value is `webmaster@localhost`. This should be changed to an email address that is delivered to you (if you are the server’s administrator). If your website has a problem,  Apache2 will display an error message containing this email address to  report the problem to.
指定要为服务器管理员播发的电子邮件地址。默认值为 `webmaster@localhost` 。这应该更改为发送给您的电子邮件地址（如果您是服务器的管理员）。如果您的网站有问题，Apache2 将显示一条错误消息，其中包含此电子邮件地址以报告问题。

### The **Listen** directive Listen 指令

> Found in `/etc/apache2/ports.conf` 发现于 `/etc/apache2/ports.conf` 

Specifies the port, and optionally the IP address, Apache2 should listen on. If  the IP address is not specified, Apache2 will listen on all IP addresses assigned to the machine it runs on. The default value for the **Listen** directive is `80`. Change this to:
指定 Apache2 应侦听的端口和可选的 IP 地址。如果未指定 IP 地址，Apache2 将侦听分配给运行它的机器的所有 IP 地址。Listen 指令的默认值为 `80` 。将其更改为：

- `127.0.0.1:80` to make Apache2 listen only on your loopback interface so that it will not be available to the Internet,
   `127.0.0.1:80` 使 Apache2 只在您的环回接口上侦听，这样它就不能用到 Internet，
- to e.g. `81` to change the port that it listens on,
  例如 `81` ，更改它侦听的端口，
- or leave it as is for normal operation.
  或保持原样以正常操作。

### The **ServerName** directive (optional) ServerName 指令（可选）

Specifies what FQDN your site should answer to. The default virtual host has no **ServerName** directive specified, so it will respond to all requests that do not  match a ServerName directive in another virtual host. If you have just  acquired the domain name `mynewsite.com` and wish to host it on your Ubuntu server, the value of the ServerName  directive in your virtual host configuration file should be `mynewsite.com`.
指定站点应响应的 FQDN。默认虚拟主机未指定 ServerName 指令，因此它将响应与另一个虚拟主机中的 ServerName 指令不匹配的所有请求。如果您刚刚获得域名 `mynewsite.com` 并希望将其托管在 Ubuntu 服务器上，则虚拟主机配置文件中 ServerName 指令的值应为 `mynewsite.com` 。

Add this directive to the new virtual host file you created earlier (`/etc/apache2/sites-available/mynewsite.conf`).
将此指令添加到您之前创建的新虚拟主机文件 （ `/etc/apache2/sites-available/mynewsite.conf` ）。

### The **ServerAlias** directive ServerAlias 指令

You may also want your site to respond to `www.mynewsite.com`, since many users will assume the www prefix is appropriate – use the *ServerAlias* directive for this. You may also use wildcards in the ServerAlias directive.
您可能还希望您的站点响应 `www.mynewsite.com` ，因为许多用户会认为 www 前缀是合适的 - 为此使用 ServerAlias 指令。还可以在 ServerAlias 指令中使用通配符。

For example, the following configuration will cause your site to respond to any domain request ending in *.mynewsite.com*.
例如，以下配置将导致您的站点响应任何以 .mynewsite.com 结尾的域请求。

```plaintext
ServerAlias *.mynewsite.com
```

### The **DocumentRoot** directive DocumentRoot 指令

Specifies where Apache2 should look for the files that make up the site. The default value is `/var/www/html`, as specified in `/etc/apache2/sites-available/000-default.conf`. If desired, change this value in your site’s virtual host file, and remember to create that directory if necessary!
指定 Apache2 应在何处查找组成站点的文件。默认值为 `/var/www/html` ，如 中 `/etc/apache2/sites-available/000-default.conf` 指定。如果需要，请在站点的虚拟主机文件中更改此值，并记得在必要时创建该目录！

Enable the new *VirtualHost* using the a2ensite utility and restart Apache2:
使用 a2ensite 实用程序启用新的 VirtualHost 并重新启动 Apache2：

```bash
sudo a2ensite mynewsite
sudo systemctl restart apache2.service
```

> **Note**: 注意：
>  Be sure to replace `mynewsite` with a more descriptive name for the VirtualHost. One method is to name the file after the **ServerName** directive of the VirtualHost.
> 请务必将 `mynewsite` VirtualHost 替换为更具描述性的名称。一种方法是在 VirtualHost 的 ServerName 指令之后命名文件。

Similarly, use the `a2dissite` utility to disable sites. This is can be useful when troubleshooting configuration problems with multiple virtual hosts:
同样，使用该 `a2dissite` 实用程序禁用站点。在对多个虚拟主机的配置问题进行故障排除时，这可能很有用：

```bash
sudo a2dissite mynewsite
sudo systemctl restart apache2.service
```

## Apache2 server default settings Apache2 服务器默认设置

This section explains configuration of the Apache2 server default settings.  For example, if you add a virtual host, the settings you configure for  the virtual host take precedence for that virtual host. For a directive  not defined within the virtual host settings, the default value is used.
本节介绍 Apache2 服务器默认设置的配置。例如，如果添加虚拟主机，则为该虚拟主机配置的设置优先于该虚拟主机。对于未在虚拟主机设置中定义的指令，将使用默认值。

### The **DirectoryIndex**

The **DirectoryIndex** is the default page served by the server when a user requests an index  of a directory by specifying a forward slash (/) at the end of the  directory name.
当用户通过在目录名称末尾指定正斜杠 （/） 来请求目录索引时，DirectoryIndex 是服务器提供的默认页面。

For example, when a user requests the page `http://www.example.com/this_directory/`, they will get either the DirectoryIndex page (if it exists), a  server-generated directory list (if it does not and the Indexes option  is specified), or a Permission Denied page if neither is true.
例如，当用户请求该页面 `http://www.example.com/this_directory/` 时，他们将获得 DirectoryIndex 页面（如果存在）、服务器生成的目录列表（如果没有并且指定了 Indexes 选项）或 Permission Denied 页面（如果两者都不成立）。

The server will try to find one of the files listed in the DirectoryIndex  directive and will return the first one it finds. If it does not find  any of these files and if **Options Indexes** is set for that directory, the server will generate and return a list,  in HTML format, of the subdirectories and files in the directory. The  default value, found in `/etc/apache2/mods-available/dir.conf` is “index.html index.cgi index.pl index.php index.xhtml index.htm”.  Thus, if Apache2 finds a file in a requested directory matching any of  these names, the first will be displayed.
服务器将尝试查找 DirectoryIndex 指令中列出的文件之一，并返回它找到的第一个文件。如果找不到这些文件中的任何一个，并且为该目录设置了“选项索引”，则服务器将生成并返回该目录中的子目录和文件的 HTML 格式列表。中的 `/etc/apache2/mods-available/dir.conf` 默认值为“index.html index.cgi index.pl index.php index.xhtml index.htm”。因此，如果 Apache2 在请求的目录中找到与这些名称中的任何一个匹配的文件，则将显示第一个文件。

### The **ErrorDocument**

The **ErrorDocument** directive allows you to specify a file for Apache2 to use for specific  error events. For example, if a user requests a resource that does not  exist, a 404 error will occur.
ErrorDocument 指令允许您指定 Apache2 用于特定错误事件的文件。例如，如果用户请求不存在的资源，则会出现 404 错误。

By default, Apache2 will return a HTTP 404 Return code. Read `/etc/apache2/conf-available/localized-error-pages.conf` for detailed instructions on using ErrorDocument, including locations of example files.
默认情况下，Apache2 将返回 HTTP 404 返回代码。阅读 `/etc/apache2/conf-available/localized-error-pages.conf` 有关使用 ErrorDocument 的详细说明，包括示例文件的位置。

### **CustomLog** and **ErrorLog** CustomLog 和 ErrorLog

By default, the server writes the transfer log to the file `/var/log/apache2/access.log`. You can change this on a per-site basis in your virtual host configuration files with the **CustomLog** directive, or omit it to accept the default, specified in `/etc/apache2/conf-available/other-vhosts-access-log.conf`.
默认情况下，服务器将传输日志写入文件 `/var/log/apache2/access.log` 。您可以使用 CustomLog 指令在虚拟主机配置文件中按站点更改此设置，也可以省略它以接受 中 `/etc/apache2/conf-available/other-vhosts-access-log.conf` 指定的默认值。

You can also specify the file to which errors are logged, via the **ErrorLog** directive, whose default is `/var/log/apache2/error.log`. These are kept separate from the transfer logs to aid in  troubleshooting problems with your Apache2 server. You may also specify  the **LogLevel** (the default value is “warn”) and the **LogFormat** (see `/etc/apache2/apache2.conf` for the default value).
还可以通过 ErrorLog 指令指定记录错误的文件，其默认值为 `/var/log/apache2/error.log` 。这些与传输日志分开保存，以帮助解决 Apache2 服务器的问题。还可以指定 LogLevel（默认值为“warn”）和 LogFormat（请参阅 `/etc/apache2/apache2.conf` 默认值）。

### The **Options** directive Options 指令

Some options are specified on a per-directory basis rather than per-server. **Options** is one of these directives. A Directory stanza is enclosed in XML-like tags, like so:
某些选项是按目录而不是按服务器指定的。Options 是这些指令之一。Directory 节包含在类似 XML 的标记中，如下所示：

```plaintext
<Directory /var/www/html/mynewsite>
...
</Directory>
```

The Options directive within a Directory stanza accepts one or more of the following values (among others), separated by spaces:
Directory 节中的 Options 指令接受以下一个或多个值（以及其他值），这些值之间用空格分隔：

- **ExecCGI 执行CGI**
   Allow CGI scripts to be run. CGI scripts are not run if this option is not chosen.
  允许运行 CGI 脚本。如果未选择此选项，则不会运行 CGI 脚本。

  > **Caution 谨慎**
  >  Most files should not be run as CGI scripts. This would be very  dangerous. CGI scripts should kept in a directory separate from and  outside your **DocumentRoot**, and only this directory should have the ExecCGI option set. This is the default, and the default location for CGI scripts is `/usr/lib/cgi-bin`.
  > 大多数文件不应作为 CGI 脚本运行。这将是非常危险的。CGI 脚本应保存在与 DocumentRoot 分开的目录中，并且只有此目录应设置 ExecCGI 选项。这是默认值，CGI 脚本的默认位置是 `/usr/lib/cgi-bin` 。

- **Includes 包括**
   Allow **server-side includes**. Server-side includes allow an HTML file to *include* other files. See [Apache SSI documentation (Ubuntu community)](https://help.ubuntu.com/community/ServerSideIncludes) for more information.
  允许服务器端包含。服务器端包含允许 HTML 文件包含其他文件。有关详细信息，请参阅 Apache SSI 文档（Ubuntu 社区）。

- **IncludesNOEXEC 包括NOEXEC**
   Allow server-side includes, but disable the `#exec` and `#include` commands in CGI scripts.
  允许服务器端包含，但禁用 CGI 脚本中的 `#exec` and `#include` 命令。

- **Indexes 指标**
   Display a formatted list of the directory’s contents, if no DirectoryIndex (such as `index.html`) exists in the requested directory.
  如果请求的目录中不存在 DirectoryIndex（如 `index.html` ），则显示目录内容的格式化列表。

  > **Caution 谨慎**
  >  For security reasons, this should usually not be set, and certainly  should not be set on your DocumentRoot directory. Enable this option  carefully on a per-directory basis **only** if you are certain you want users to see the entire contents of the directory.
  > 出于安全原因，通常不应设置此项，当然也不应在 DocumentRoot 目录上设置此项。仅当您确定希望用户查看目录的全部内容时，才在每个目录的基础上仔细启用此选项。

- **Multiview 多视图**
   Support content-negotiated multiviews; this option is disabled by default for security reasons. See the [Apache2 documentation on this option](https://httpd.apache.org/docs/2.4/mod/mod_negotiation.html#multiviews).
  支持内容协商的多视图;出于安全原因，默认情况下禁用此选项。请参阅有关此选项的 Apache2 文档。

- **SymLinksIfOwnerMatch 符号链接IfOwnerMatch**
   Only follow symbolic links if the target file or directory has the same owner as the link.
  仅当目标文件或目录与链接具有相同的所有者时，才遵循符号链接。

### Apache2 daemon settings Apache2 守护程序设置

This section briefly explains some basic Apache2 daemon configuration settings.
本节简要介绍一些基本的 Apache2 守护程序配置设置。

- **LockFile 锁文件**
   The **LockFile** directive sets the path to the lockfile used when the server is compiled with either `USE_FCNTL_SERIALIZED_ACCEPT` or `USE_FLOCK_SERIALIZED_ACCEPT`. It must be stored on the local disk. It should be left to the default  value unless the logs directory is located on an NFS share. If this is  the case, the default value should be changed to a location on the local disk and to a directory that is readable only by root.
  LockFile 指令设置使用 `USE_FCNTL_SERIALIZED_ACCEPT` 或 编译 `USE_FLOCK_SERIALIZED_ACCEPT` 服务器时使用的锁文件的路径。它必须存储在本地磁盘上。除非日志目录位于 NFS 共享上，否则应保留为默认值。如果是这种情况，则应将默认值更改为本地磁盘上的位置以及仅可由 root 读取的目录。

- **PidFile Pid文件**
   The **PidFile** directive sets the file in which the server records its process ID  (pid). This file should only be readable by root. In most cases, it  should be left to the default value.
  PidFile 指令设置服务器记录其进程 ID （pid） 的文件。此文件只能由 root 读取。在大多数情况下，应将其保留为默认值。

- **User 用户**
   The **User** directive sets the userid used by the server to answer requests. This  setting determines the server’s access. Any files inaccessible to this  user will also be inaccessible to your website’s visitors. The default  value for User is “www-data”.
  User 指令设置服务器用于应答请求的用户 ID。此设置确定服务器的访问权限。此用户无法访问的任何文件也将无法被您网站的访问者访问。User 的默认值为“www-data”。

  > **Warning 警告**
  >  Unless you know exactly what you are doing, do not set the User  directive to root. Using root as the User will create large security  holes for your Web server.
  > 除非您确切地知道自己在做什么，否则不要将 User 指令设置为 root。使用 root 作为用户将为您的 Web 服务器创建大型安全漏洞。

- **Group 群**
   The **Group** directive is similar to the User directive. Group sets the group under  which the server will answer requests. The default group is also  “www-data”.
  Group 指令类似于 User 指令。组设置服务器将在其下应答请求的组。默认组也是“www-data”。

## Extending Apache2 扩展 Apache2

Now that you know how to configure Apache2, you may also want to know [how to extend Apache2](https://ubuntu.com/server/docs/how-to-use-apache2-modules) with modules.
现在您已经知道如何配置 Apache2，您可能还想知道如何使用模块扩展 Apache2。

## Further reading 延伸阅读

- The [Apache2 Documentation](https://httpd.apache.org/docs/2.4/) contains in depth information on Apache2 configuration directives. Also, see the `apache2-doc` package for the official Apache2 docs.
  Apache2 文档包含有关 Apache2 配置指令的深入信息。另外，请参阅官方 Apache2 文档的 `apache2-doc` 软件包。
- O’Reilly’s [Apache Cookbook](http://shop.oreilly.com/product/9780596529949.do) is a good resource for accomplishing specific Apache2 configurations.
  O'Reilly 的 Apache Cookbook 是完成特定 Apache2 配置的良好资源。
- For Ubuntu specific Apache2 questions, ask in the `#ubuntu-server` IRC channel on [libera.chat](https://libera.chat/).
  对于特定于 Ubuntu 的 Apache2 问题，请在 libera.chat 的 `#ubuntu-server` IRC 频道中提问。

------



# How to use Apache2 modules 如何使用 Apache2 模块

Apache2 is a modular server. This implies that only the most basic  functionality is included in the core server. Extended features are  available through modules which can be loaded into Apache2.
Apache2 是一个模块化服务器。这意味着核心服务器中仅包含最基本的功能。扩展功能可通过模块获得，这些模块可以加载到 Apache2 中。

By default, a base set of modules is included in the server at  compile-time. If the server is compiled to use dynamically loaded  modules, then modules can be compiled separately, and added at any time  using the **LoadModule** directive. Otherwise, Apache2 must be recompiled to add or remove modules.
默认情况下，在编译时，服务器中包含一组基本模块。如果将服务器编译为使用动态加载的模块，则可以单独编译模块，并随时使用 LoadModule 指令添加模块。否则，必须重新编译 Apache2 才能添加或删除模块。

Ubuntu compiles Apache2 to allow the dynamic loading of modules. Configuration directives may be conditionally included on the presence of a  particular module by enclosing them in an `<IfModule>` block.
Ubuntu 编译 Apache2 以允许动态加载模块。配置指令可以通过将它们包含在块中 `<IfModule>` 来有条件地包含在特定模块的存在上。

## Installing and handling modules 安装和处理模块

You can install additional Apache2 modules and use them with your web  server. For example, run the following command at a terminal prompt to  install the Python 3 WSGI module:
您可以安装其他 Apache2 模块并将它们与 Web 服务器一起使用。例如，在终端提示符下运行以下命令以安装 Python 3 WSGI 模块：

```bash
sudo apt install libapache2-mod-wsgi-py3
```

The installation will enable the module automatically, but we can disable it with `a2dismod`:
安装将自动启用该模块，但我们可以通过以下方式 `a2dismod` 禁用它：

```bash
sudo a2dismod wsgi
sudo systemctl restart apache2.service
```

And then use the `a2enmod` utility to re-enable it:
然后使用实用 `a2enmod` 程序重新启用它：

```bash
sudo a2enmod wsgi
sudo systemctl restart apache2.service
```

See the `/etc/apache2/mods-available` directory for additional modules already available on your system.
请参阅 `/etc/apache2/mods-available` 目录，了解系统上已有的其他模块。

## Configure Apache2 for HTTPS 配置 Apache2 for HTTPS

The `mod_ssl` module adds an important feature to the Apache2 server - the ability to encrypt communications. Thus, when your browser is communicating using  SSL, the `https://` prefix is used at the beginning of the Uniform Resource Locator (URL) in the browser navigation bar.
该 `mod_ssl` 模块为 Apache2 服务器添加了一个重要功能 - 加密通信的能力。因此，当您的浏览器使用 SSL 进行通信时， `https://` 前缀将用于浏览器导航栏中统一资源定位符 （URL） 的开头。

The `mod_ssl` module is available in the `apache2-common` package. Run the following command at a terminal prompt to enable the `mod_ssl` module:
 `apache2-common` 该 `mod_ssl` 模块在包装中可用。在终端提示符下运行以下命令以启用该 `mod_ssl` 模块：

```bash
sudo a2enmod ssl
```

There is a default HTTPS configuration file in `/etc/apache2/sites-available/default-ssl.conf`. In order for Apache2 to provide HTTPS, a **certificate** and **key** file are also needed. The default HTTPS configuration will use a certificate and key generated by the `ssl-cert` package. They are good for testing, but the auto-generated certificate  and key should be replaced by a certificate specific to the site or  server.
中 `/etc/apache2/sites-available/default-ssl.conf` 有一个默认的 HTTPS 配置文件。为了让 Apache2 提供 HTTPS，还需要证书和密钥文件。默认 HTTPS 配置将使用包生成的 `ssl-cert` 证书和密钥。它们适用于测试，但自动生成的证书和密钥应替换为特定于站点或服务器的证书。

> **Note**: 注意：
>  For more information on generating a key and obtaining a certificate see [Certificates](https://ubuntu.com/server/docs/certificates).
> 有关生成密钥和获取证书的详细信息，请参阅证书。

To configure Apache2 for HTTPS, enter the following:
要为 APACHE2 配置 HTTPS，请输入以下命令：

```bash
sudo a2ensite default-ssl
```

> **Note**: 注意：
>  The directories `/etc/ssl/certs` and `/etc/ssl/private` are the default locations. If you install the certificate and key in another directory make sure to change *SSLCertificateFile* and *SSLCertificateKeyFile* appropriately.
> 目录 `/etc/ssl/certs` 和 `/etc/ssl/private` 是默认位置。如果将证书和密钥安装在另一个目录中，请确保相应地更改 SSLCertificateFile 和 SSLCertificateKeyFile。

With Apache2 now configured for HTTPS, restart the service to enable the new settings:
现在将 Apache2 配置为 HTTPS 后，重新启动服务以启用新设置：

```bash
sudo systemctl restart apache2.service
```

Note that depending on how you obtained your certificate, you may need to enter a passphrase when Apache2 restarts.
请注意，根据您获取证书的方式，您可能需要在 Apache2 重新启动时输入密码。

You can access the secure server pages by typing `https://your_hostname/url/` in your browser address bar.
您可以通过 `https://your_hostname/url/` 在浏览器地址栏中键入来访问安全服务器页面。

## Sharing write permission 共享写入权限

For more than one user to be able to write to the same directory you will  need to grant write permission to a group they share in common. The  following example grants shared write permission to `/var/www/html` to the group “webmasters”.
要使多个用户能够写入同一目录，您需要向他们共享的组授予写入权限。以下示例向组“webmasters”授予共享 `/var/www/html` 写入权限。

```bash
sudo chgrp -R webmasters /var/www/html
sudo chmod -R g=rwX /var/www/html/
```

These commands recursively set the group permission on all files and directories in `/var/www/html` to allow reading, writing and searching of directories. Many admins  find this useful for allowing multiple users to edit files in a  directory tree.
这些命令以递归方式设置对所有文件和目录的组权限， `/var/www/html` 以允许读取、写入和搜索目录。许多管理员发现这对于允许多个用户编辑目录树中的文件很有用。

> **Warning**: 警告：
>  The `apache2` daemon will run as the `www-data` user, which has a corresponding `www-data` group. These **should not** be granted write access to the document root, as this would mean that  vulnerabilities in Apache or the applications it is serving would allow  attackers to overwrite the served content.
>  `apache2` 守护程序将以 `www-data` 用户身份运行，该用户具有相应的 `www-data` 组。不应授予这些文档根目录的写入权限，因为这意味着 Apache 或其所服务的应用程序中的漏洞将允许攻击者覆盖提供的内容。

## Further reading 延伸阅读

- The [Apache2 Documentation](https://httpd.apache.org/docs/2.4/) contains in depth information on Apache2 configuration directives.  Also, see the apache2-doc package for the official Apache2 docs.
  Apache2 文档包含有关 Apache2 配置指令的深入信息。另外，请参阅 apache2-doc 包以获取官方 Apache2 文档。
- O’Reilly’s [Apache Cookbook](http://shop.oreilly.com/product/9780596529949.do) is a good resource for accomplishing specific Apache2 configurations.
  O'Reilly 的 Apache Cookbook 是完成特定 Apache2 配置的良好资源。
- For Ubuntu specific Apache2 questions, ask in the `#ubuntu-server` IRC channel on [libera.chat](https://libera.chat/).
  对于特定于 Ubuntu 的 Apache2 问题，请在 libera.chat 的 `#ubuntu-server` IRC 频道中提问。



# 设置 Apache HTTP web 服务器

## 1.1. Apache HTTP web 服务器简介

​				*Web 服务器*是一个通过 Web 向客户端提供内容的网络服务。这通常是网页，但也可以提供任何其他文档。Web 服务器也称为 HTTP 服务器，因为它们使用 *超文本传输协议* (**HTTP**)。 		

​				**Apache HTTP 服务器** `httpd` 是由 [Apache Software Foundation](http://www.apache.org/) 开发的开源 Web 服务器。 		

​				如果您要从之前的 Red Hat Enterprise Linux 版本升级，您必须相应地更新 `httpd` 服务配置。本节介绍了一些新添加的功能，并指导您完成之前的配置文件的更新。 		

## 1.2. Apache HTTP 服务器中的显著变化

​				RHEL 9 提供 Apache HTTP 服务器的版本 2.4.48。RHEL 8 发布的 2.4.37 版本的显著变化包括： 		

- ​						Apache HTTP 服务器控制接口(`apachectl`)： 				
  - ​								现在，`apachectl status` 输出禁用了 `systemctl` pager。 						
  - ​								现在，如果您传递了附加参数，则 `apachectl` 命令会失败，而不是发出警告。 						
  - ​								`apachectl graceful-stop` 命令现在会立即返回。 						
  - ​								`apachectl configtest` 命令现在在不更改 SELinux 上下文的情况下执行 `httpd -t` 命令。 						
  - ​								RHEL 中的 `apachectl(8)` man page 现在完全指明了与上游 `apachectl` 之间的差异。 						
- ​						Apache eXtenSion 工具(`pxs`)： 				
  - ​								构建 `httpd` 软件包时，`/usr/bin/apxs` 命令不再使用或公开编译器选择的标志。现在，您可以使用 `/usr/lib64/httpd/build/vendor-apxs` 命令应用与构建 `httpd` 相同的编译器标志。要使用 `vendor-apxs` 命令，您必须首先安装 `redhat-rpm-config` 软件包。 						
- ​						Apache 模块： 				
  - ​								`mod_lua` 模块现在在一个单独的软件包中提供。 						
- ​						配置语法更改： 				
  - ​								在由 `mod_access_compat` 模块提供的已弃用的 `Allow` 指令中，注释（ `#` 字符）现在会触发语法错误，而不是静默忽略。 						
- ​						其他更改： 				
  - ​								内核线程 ID 现在直接在错误信息中使用，从而使它们准确且更简洁。 						
  - ​								多个小幅改进和漏洞修复。 						
  - ​								模块作者可使用多个新接口。 						

​				从 RHEL 8 开始，`httpd` 模块 API 没有向后兼容的更改。 		

​				Apache HTTP Server 2.4 是此 Application Stream 的初始版本，您可以将其作为 RPM 软件包轻松安装。 		

## 1.3. Apache 配置文件

​				默认情况下，`httpd` 在启动时读取配置文件。您可以在下表中查看配置文件的位置列表。 		

表 1.1. httpd 服务配置文件

| 路径                         | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `/etc/httpd/conf/httpd.conf` | 主配置文件。                                                 |
| `/etc/httpd/conf.d/`         | 主配置文件中包含的配置文件的辅助目录。                       |
| `/etc/httpd/conf.modules.d/` | 用于载入 Red Hat Enterprise Linux 中打包动态模块的配置文件的辅助目录。在默认配置中，首先会处理这些配置文件。 |

​				虽然默认配置适用于大多数情况，但您也可以使用其他配置选项。要让任何更改生效，请首先重启 web 服务器。 		

​				要检查配置中的可能错误，在 shell 提示符后输入以下内容： 		



```none
# apachectl configtest
Syntax OK
```

​				要更方便地从错误中恢复，请在编辑前复制原始文件。 		

## 1.4. 管理 httpd 服务

​				本节描述了如何启动、停止和重新启动 `httpd` 服务。 		

**先决条件**

- ​						已安装 Apache HTTP 服务器。 				

**步骤**

- ​						要启动 `httpd` 服务，请输入： 				

  

  ```none
  # systemctl start httpd
  ```

- ​						要停止 `httpd` 服务，请输入： 				

  

  ```none
  # systemctl stop httpd
  ```

- ​						要重启 `httpd` 服务，请输入： 				

  

  ```none
  # systemctl restart httpd
  ```

## 1.5. 设置单实例 Apache HTTP 服务器

​				这部分论述了如何设置单实例 Apache HTTP 服务器来提供静态 HTML 内容。 		

​				如果 web 服务器应该为与服务器关联的所有域提供相同的内容，请按照本节中的步骤进行操作。如果要为不同的域提供不同的内容，请设置基于名称的虚拟主机。详情请参阅 [配置 Apache 基于名称的虚拟主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#configuring-apache-name-based-virtual-hosts_setting-apache-http-server)。 		

**步骤**

1. ​						安装 `httpd` 软件包： 				

   

   ```none
   # dnf install httpd
   ```

2. ​						如果使用 `firewalld`，请在本地防火墙中打开 TCP 端口 `80` ： 				

   

   ```none
   # firewall-cmd --permanent --add-port=80/tcp
   # firewall-cmd --reload
   ```

3. ​						启用并启动 `httpd` 服务： 				

   

   ```none
   # systemctl enable --now httpd
   ```

4. ​						可选：将 HTML 文件添加到 `/var/www/html/` 目录中。 				

   注意

   ​							在 向`/var/www/html/` 添加内容时，在`httpd`默认运行的情况下，文件和目录必须可被用户读取。内容所有者可以是 `root`用户和`root`用户组，也可以是管理员所选择的其他用户或组。如果内容所有者是 `root` 用户和 `root` 用户组，则文件必须可被其他用户读取。所有文件和目录的 SELinux 上下文必须为 `httpd_sys_content_t`，其默认应用于 `/var/www` 目录中的所有内容。 					

**验证步骤**

- ​						使用 Web 浏览器连接到 `http://*server_IP_or_host_name*/`。 				

  ​						如果 `/var/www/html/` 目录为空，或者不包含 `index.html`或`index.htm`文件，则 Apache 会显示 `Red Hat Enterprise Linux 测试页面`。如果 `/var/www/html/` 包含具有不同名称的 HTML 文件，您可以通过输入该文件的 URL 来加载它们，如 `http://*server_IP_or_host_name*/*example.html*`。 				

**其他资源**

- ​						Apache 手册：[安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 				
- ​						请参见 `httpd.service(8)` 手册页。 				

## 1.6. 配置基于 Apache 名称的虚拟主机

​				基于名称的虚拟主机可让 Apache 为解析到服务器 IP 地址的不同域提供不同的内容。 		

​				本节中的步骤论述了使用单独的文档根目录为 `example.com` 和 `example.net` 域设置虚拟主机。两个虚拟主机都提供静态 HTML 内容。 		

**先决条件**

- ​						客户端和 Web 服务器将 `example.com` 和 `example.net` 域解析为 Web 服务器的 IP 地址。 				

  ​						请注意，您必须手动将这些条目添加到 DNS 服务器中。 				

**步骤**

1. ​						安装 `httpd` 软件包： 				

   

   ```none
   # dnf install httpd
   ```

2. ​						编辑 `/etc/httpd/conf/httpd.conf` 文件： 				

   1. ​								为 `example.com` 域添加以下虚拟主机配置： 						

      

      ```none
      <VirtualHost *:80>
          DocumentRoot "/var/www/example.com/"
          ServerName example.com
          CustomLog /var/log/httpd/example.com_access.log combined
          ErrorLog /var/log/httpd/example.com_error.log
      </VirtualHost>
      ```

      ​								这些设置配置以下内容： 						

      - ​										`<VirtualHost *:80>` 指令中的所有设置都是针对这个虚拟主机的。 								

      - ​										`DocumentRoot` 设置虚拟主机的 Web 内容的路径。 								

      - ​										`ServerName` 设置此虚拟主机为其提供内容服务的域。 								

        ​										要设置多个域，请在配置中添加 `ServerAlias` 参数，并在此参数中指定用空格分开的额外域。 								

      - ​										`CustomLog` 设置虚拟主机的访问日志的路径。 								

      - ​										`ErrorLog` 设置虚拟主机错误日志的路径。 								

        注意

        ​											Apache 还将配置中找到的第一个虚拟主机用于与`ServerName`和`Server Alias`参数中设置的任何域不匹配的请求。这还包括发送到服务器 IP 地址的请求。 									

3. ​						为 `example.net` 域添加类似的虚拟主机配置： 				

   

   ```none
   <VirtualHost *:80>
       DocumentRoot "/var/www/example.net/"
       ServerName example.net
       CustomLog /var/log/httpd/example.net_access.log combined
       ErrorLog /var/log/httpd/example.net_error.log
   </VirtualHost>
   ```

4. ​						为两个虚拟主机创建文档根目录： 				

   

   ```none
   # mkdir /var/www/example.com/
   # mkdir /var/www/example.net/
   ```

5. ​						如果您在 `DocumentRoot` 参数中设置的路径不在`/var/www/`中，请在两个文档根中设置 `httpd_sys_content_t` 上下文： 				

   

   ```none
   # semanage fcontext -a -t httpd_sys_content_t "/srv/example.com(/.*)?"
   # restorecon -Rv /srv/example.com/
   # semanage fcontext -a -t httpd_sys_content_t "/srv/example.net(/.\*)?"
   # restorecon -Rv /srv/example.net/
   ```

   ​						这些命令在`/srv/example.com/`和`/srv/ example.net/` 目录中设置 `httpd_sys_content_t`上下文。 				

   ​						请注意，您必须安装 `policycoreutils-python-utils` 软件包才能运行`restorecon` 命令。 				

6. ​						如果使用 `firewalld`，请在本地防火墙中打开端口 `80` ： 				

   

   ```none
   # firewall-cmd --permanent --add-port=80/tcp
   # firewall-cmd --reload
   ```

7. ​						启用并启动 `httpd` 服务： 				

   

   ```none
   # systemctl enable --now httpd
   ```

**验证步骤**

1. ​						在每个虚拟主机的文档 root 中创建不同的示例文件： 				

   

   ```none
   # echo "vHost example.com" > /var/www/example.com/index.html
   # echo "vHost example.net" > /var/www/example.net/index.html
   ```

2. ​						使用浏览器并连接到 `http://example.com`Web 服务器显示`example.com`虚拟主机中的示例文件。 				

3. ​						使用浏览器并连接到 `http://example.net`Web 服务器显示`example.net`虚拟主机中的示例文件。 				

**其他资源**

- ​						[安装 Apache HTTP 服务器手册 - 虚拟主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server) 				

## 1.7. 为 Apache HTTP web 服务器配置 Kerberos 验证

​				要在 Apache HTTP web 服务器中执行 Kerberos 身份验证，RHEL 9 使用 `mod_auth_gssapi` Apache 模块。Generic Security Services API(`GSSAPI`)是请求使用安全库（如 Kerberos）的应用程序的接口。`gssproxy` 服务允许对 `httpd` 服务器实施特权分离，从安全的角度来看，这优化了此过程。 		

注意

​					`mod_auth_gssapi` 模块取代了已删除的 `mod_auth_kerb` 模块。 			

**先决条件**

- ​						已安装了 `**httpd**`, `**mod_auth_gssapi**` 和 `**gssproxy**` 软件包。 				
- ​						Apache Web 服务器已设置，并且 `httpd` 服务在运行。 				

### 1.7.1. 在 IdM 环境中设置 GSS-Proxy

​					这个流程描述了如何设置 `GSS-Proxy` ，以便在 Apache HTTP Web 服务器中执行 Kerberos 身份验证。 			

**步骤**

1. ​							通过创建服务主体来启用对 HTTP/<SERVER_NAME>@realm 主体的`keytab`文件的访问： 					

   

   ```none
   # ipa service-add HTTP/<SERVER_NAME>
   ```

2. ​							检索存储在`/etc/gssproxy/http.keytab`文件中的主体的`keytab`： 					

   

   ```none
   # ipa-getkeytab -s $(awk '/^server =/ {print $3}' /etc/ipa/default.conf) -k /etc/gssproxy/http.keytab -p HTTP/$(hostname -f)
   ```

   ​							此步骤将权限设置为 400，因此只有 `root` 用户有权访问 `keytab` 文件。`apache` 用户无法访问。 					

3. ​							使用以下内容创建 `/etc/gssproxy/80-httpd.conf` 文件： 					

   

   ```none
   [service/HTTP]
     mechs = krb5
     cred_store = keytab:/etc/gssproxy/http.keytab
     cred_store = ccache:/var/lib/gssproxy/clients/krb5cc_%U
     euid = apache
   ```

4. ​							重启并启用 `gssproxy` 服务： 					

   

   ```none
   # systemctl restart gssproxy.service
   # systemctl enable gssproxy.service
   ```

**其他资源**

- ​							`gssproxy (8)` man page 					
- ​							`gssproxy-mech(8)` man page 					
- ​							`gssproxy.conf(5)` man pages 					

### 1.7.2. 为 Apache HTTP Web 服务器共享的目录配置 Kerberos 身份验证

​					这个过程描述了如何为 `/var/www/html/private/` 目录配置 Kerberos 身份验证。 			

**先决条件**

- ​							`gssproxy` 服务已配置并在运行。 					

**步骤**

1. ​							配置 `mod_auth_gssapi`模块来保护 `/var/www/html/private/`目录： 					

   

   ```none
   <Location /var/www/html/private>
     AuthType GSSAPI
     AuthName "GSSAPI Login"
     Require valid-user
   </Location>
   ```

2. ​							使用以下内容创建`/etc/systemd/system/httpd.service`文件： 					

   

   ```none
   .include /lib/systemd/system/httpd.service
   [Service]
   Environment=GSS_USE_PROXY=1
   ```

3. ​							重新载入`systemd`配置： 					

   

   ```none
   # systemctl daemon-reload
   ```

4. ​							重启`httpd`服务： 					

   

   ```none
   # systemctl restart httpd.service
   ```

**验证步骤**

1. ​							获取Kerberos ticket： 					

   

   ```none
   # kinit
   ```

2. ​							在浏览器中打开到受保护目录的URL。 					

## 1.8. 在Apache HTTP服务器上配置TLS加密

​				默认情况下，Apache 使用未加密的 HTTP 连接向客户端提供内容。这部分论述了如何在 Apache HTTP 服务器上启用 TLS 加密和配置常用的与加密相关的设置。 		

**先决条件**

- ​						Apache HTTP 服务器已安装并运行。 				

### 1.8.1. 在 Apache HTTP 服务器中添加 TLS 加密

​					这部分论述了如何在Apache HTTP 服务器上对`example.com`域启用TLS加密。 			

**先决条件**

- ​							Apache HTTP 服务器已安装并运行。 					

- ​							私钥存储在 `/etc/pki/tls/private/example.com.key` 文件中。 					

  ​							有关创建私钥和证书签名请求(CSR)的详细信息，以及如何从证书颁发机构(CA)请求证书，请参阅您的 CA 文档。或者，如果您的 CA 支持 ACME 协议，您可以使用 `mod_md` 模块自动检索和调配 TLS 证书。 					

- ​							TLS 证书存储在`/etc/pki/tls/certs/example.com.crt`文件中。如果您使用其他路径，请调整该流程的对应步骤。 					

- ​							CA 证书存储在 `/etc/pki/tls/certs/ca.crt` 文件中。如果您使用其他路径，请调整该流程的对应步骤。 					

- ​							客户端和网页服务器会将服务器的主机名解析为 web 服务器的 IP 地址。 					

**步骤**

1. ​							安装 `mod_ssl` 软件包： 					

   

   ```none
   # dnf install mod_ssl
   ```

2. ​							编辑`/etc/httpd/conf.d/ssl.conf`文件，并将以下设置添加到 `<VirtualHost _default_:443>`指令中： 					

   1. ​									设置服务器名称： 							

      

      ```none
      ServerName example.com
      ```

      重要

      ​										服务器名称必须与证书的 `Common Name`字段中设置的条目匹配。 								

   2. ​									可选：如果证书在 `Subject Alt Names` (SAN)字段中包含额外的主机名，您可以配置 `mod_ssl` 来为这些主机名提供 TLS 加密。要配置此功能，请添加具有对应名称的`ServerAliases`参数： 							

      

      ```none
      ServerAlias www.example.com server.example.com
      ```

   3. ​									设置到私钥、服务器证书和 CA 证书的路径： 							

      

      ```none
      SSLCertificateKeyFile "/etc/pki/tls/private/example.com.key"
      SSLCertificateFile "/etc/pki/tls/certs/example.com.crt"
      SSLCACertificateFile "/etc/pki/tls/certs/ca.crt"
      ```

3. ​							出于安全考虑，配置成只有 `root` 用户才可以访问私钥文件： 					

   

   ```none
   # chown root:root /etc/pki/tls/private/example.com.key
   # chmod 600 /etc/pki/tls/private/example.com.key
   ```

   警告

   ​								如果私钥被设置为可以被未授权的用户访问，则需要撤销证书，然后再创建一个新私钥并请求一个新证书。否则，TLS 连接就不再安全。 						

4. ​							如果您使用 `firewalld`，在本地防火墙中打开端口 `443` ： 					

   

   ```none
   # firewall-cmd --permanent --add-port=443/tcp
   # firewall-cmd --reload
   ```

5. ​							重启`httpd`服务： 					

   

   ```none
   # systemctl restart httpd
   ```

   注意

   ​								如果您使用密码来保护私钥文件，则必须在每次 `httpd`服务启动时都输入此密码。 						

**验证步骤**

- ​							使用浏览器并连接到`https://*example.com*`。 					

**其他资源**

- ​							[SSL/TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server) 					
- ​							[RHEL 9 中 TLS 的安全注意事项](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/securing_networks/planning-and-implementing-tls_securing-networks#security-considerations-for-tls-in-rhel_planning-and-implementing-tls) 					

### 1.8.2. 在 Apache HTTP 服务器中设置支持的 TLS 协议版本

​					默认情况下，RHEL 上的 Apache HTTP 服务器使用系统范围的加密策略来定义安全默认值，这些值也与最新的浏览器兼容。例如，`DEFAULT`策略定义了在 apache 中只启用 `TLSv1.2`和`TLSv1.3`协议版本。 			

​					这部分论述了如何手动配置 Apache HTTP 服务器支持的 TLS 协议版本。如果您的环境只需要启用特定的 TLS 协议版本，请按照以下步骤操作，例如： 			

- ​							如果您的环境要求客户端也可以使用弱 `TLS1` (TLSv1.0)或`TLS1.1`协议。 					
- ​							如果你想将 Apache 配置为只支持`TLSv1.2`或`TLSv1.3`协议。 					

**先决条件**

- ​							TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 					

**步骤**

1. ​							编辑 `/etc/httpd/conf/httpd.conf` 文件，并将以下设置添加到您要为其设置 TLS 协议版本的`<VirtualHost>`指令中。例如，只启用`TLSv1.3`协议： 					

   

   ```none
   SSLProtocol -All TLSv1.3
   ```

2. ​							重启`httpd`服务： 					

   

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​							使用以下命令来验证服务器是否支持`TLSv1.3`: 					

   

   ```none
   # openssl s_client -connect example.com:443 -tls1_3
   ```

2. ​							使用以下命令来验证服务器是否不支持`TLSv1.2` ： 					

   

   ```none
   # openssl s_client -connect example.com:443 -tls1_2
   ```

   ​							如果服务器不支持该协议，命令会返回一个错误： 					

   

   ```none
   140111600609088:error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version:ssl/record/rec_layer_s3.c:1543:SSL alert number 70
   ```

3. ​							可选：为其他 TLS 协议版本重复该命令。 					

**其他资源**

- ​							`update-crypto-policies(8)` 手册页 					
- ​							[使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 					
- ​							有关`SSLProtocol`参数的详情，请参阅 Apache 手册中的`mod_ssl`文档:[安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 					

### 1.8.3. 在 Apache HTTP 服务器中设置支持的密码

​					默认情况下，Apache HTTP 服务器使用定义安全默认值的系统范围的加密策略，这些值也与最新的浏览器兼容。有关系统范围加密允许的密码列表，请查看`/etc/crypto-policies/back-ends/openssl.config` 文件。 			

​					这部分论述了如何手动配置 Apache HTTP 服务器支持的加密。如果您的环境需要特定的加密系统，请按照以下步骤操作。 			

**先决条件**

- ​							TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 					

**步骤**

1. ​							编辑`/etc/httpd/conf/httpd.conf`文件，并将`SSLCipherSuite`参数添加到您要为其设置 TLS 密码的`<VirtualHost>`指令中： 					

   

   ```none
   SSLCipherSuite "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!SHA1:!SHA256"
   ```

   ​							这个示例只启用 `EECDH+AESGCM`、`EDH+AESGCM`、`AES256+EECDH` 和 `AES256+EDH`密码，并禁用所有使用`SHA1`和`SHA256`消息身份验证码(MAC)的密码。 					

2. ​							重启`httpd`服务： 					

   

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​							显示 Apache HTTP 服务器支持的密码列表： 					

   1. ​									安装`nmap`软件包： 							

      

      ```none
      # dnf install nmap
      ```

   2. ​									使用`nmap`工具来显示支持的加密： 							

      

      ```none
      # nmap --script ssl-enum-ciphers -p 443 example.com
      ...
      PORT    STATE SERVICE
      443/tcp open  https
      | ssl-enum-ciphers:
      |   TLSv1.2:
      |     ciphers:
      |       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
      |       TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (dh 2048) - A
      |       TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (ecdh_x25519) - A
      ...
      ```

**其他资源**

- ​							`update-crypto-policies(8)` 手册页 					
- ​							[使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 					
- ​							[SSLCipherSuite](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server) 					

## 1.9. 配置 TLS 客户端证书身份验证

​				客户端证书身份验证可让管理员只允许使用证书进行身份验证的用户访问 web 服务器上的资源。这部分论述了如何为`/var/www/html/Example/`目录配置客户端证书身份验证。 		

​				如果 Apache HTTP 服务器使用 TLS 1.3 协议，某些客户端将需要额外的配置。例如，在 Firefox 中，将`about:config`菜单中的`security.tls.enable_post_handshake_auth`参数设置为`true`。详情请查看 [Red Hat Enterprise Linux 8中的传输层安全版本1.3](https://www.redhat.com/en/blog/transport-layer-security-version-13-red-hat-enterprise-linux-8)。 		

**先决条件**

- ​						TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 				

**步骤**

1. ​						编辑`/etc/httpd/conf/httpd.conf`文件，并将以下设置添加到你要为其配置客户端验证的`<VirtualHost>`指令中： 				

   

   ```none
   <Directory "/var/www/html/Example/">
     SSLVerifyClient require
   </Directory>
   ```

   ​						`SSLVerifyClient require`设置定义了服务器必须成功验证客户端证书，然后客户端才能访问`/var/www/html/Example/`目录中的内容。 				

2. ​						重启`httpd`服务： 				

   

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​						使用`curl`工具在没有客户端身份验证的情况下访问`https://example.com/Example/`URL： 				

   

   ```none
   $ curl https://example.com/Example/
   curl: (56) OpenSSL SSL_read: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 **alert certificate required**, errno 0
   ```

   ​						这个错误表示 web 服务器需要客户端证书验证。 				

2. ​						将客户端私钥和证书以及 CA 证书传递给`curl`以便使用客户端身份验证来访问相同的URL： 				

   

   ```none
   $ curl --cacert ca.crt --key client.key --cert client.crt https://example.com/Example/
   ```

   ​						如果请求成功，`curl`会显示存储在`/var/www/html/Example/`目录中的`index.html`文件。 				

**其他资源**

- ​						[mod_ssl 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server) 				

## 1.10. 使用 ModSecurity 在 web 服务器上保护 Web 应用程序

​				ModSecurity 是受各种 web 服务器（如 Apache、Nginx 和 IIS）支持的开源 Web 应用程序防火墙 (WAF)，它可以降低 web 应用程序中的安全风险。ModSecurity 为配置服务器提供可自定义的规则集。 		

​				`mod_security-crs` 软件包包含核心规则集(CRS)，针对跨 Web 站点脚本、错误的用户代理、SQL 注入、Trojans、会话劫持和其他利用的规则。 		

### 1.10.1. 为 Apache 部署基于 web 的 ModSecurity 应用程序防火墙

​					要通过部署 ModSecurity 来降低在 web 服务器上运行基于 Web 的应用程序的风险，请为 Apache HTTP 服务器安装 `mod_security` 和 `mod_security_crs` 软件包。`mod_security_crs` 软件包为 ModSecurity Web 的应用程序防火墙 (WAF) 模块提供了核心规则集 (CRS)。 			

**步骤**

1. ​							安装 `mod_security`、`mod_security_crs` 和 `httpd` 软件包： 					

   

   ```none
   # dnf install -y mod_security mod_security_crs httpd
   ```

2. ​							启动 `httpd` 服务器： 					

   

   ```none
   # systemctl restart httpd
   ```

**验证**

1. ​							验证 Apache HTTP 服务器中是否启用了 ModSecurity web 的应用程序防火墙： 					

   

   ```none
   # httpd -M | grep security
    security2_module (shared)
   ```

2. ​							检查 `/etc/httpd/modsecurity.d/activated_rules/` 目录是否包含由 `mod_security_crs` 提供的规则： 					

   

   ```none
   # ls /etc/httpd/modsecurity.d/activated_rules/
   ...
   REQUEST-921-PROTOCOL-ATTACK.conf
   REQUEST-930-APPLICATION-ATTACK-LFI.conf
   ...
   ```

**其他资源**

- ​							[Red Hat JBoss Core Services ModSecurity Guide](https://access.redhat.com/documentation/en-us/red_hat_jboss_core_services/2.4.37/html/red_hat_jboss_core_services_modsecurity_guide/index) 					
- ​							[Linux 系统管理员的 Web 应用程序防火墙简介](https://www.redhat.com/sysadmin/introducing-wafs) 					

### 1.10.2. 在 ModSecurity 中添加自定义规则

​					如果 ModSecurity 核心规则集 (CRS)  中包含的规则不能适合您的场景，如果您想要阻止其他可能攻击，则可以将自定义规则添加到基于 ModSecurity web  的应用防火墙使用的规则集合中。以下示例演示了添加简单规则。有关创建更复杂的规则，请参阅 [ModSecurity Wiki](https://github.com/SpiderLabs/ModSecurity/wiki) 网站上的参考手册。 			

**先决条件**

- ​							已安装并启用 ModSecurity for Apache。 					

**步骤**

1. ​							在您选择的文本编辑器中打开 `/etc/httpd/conf.d/mod_security.conf` 文件，例如： 					

   

   ```none
   # vi /etc/httpd/conf.d/mod_security.conf
   ```

2. ​							在以 `SecRuleEngine On` 开头的行后添加以下示例规则： 					

   

   ```none
   SecRule ARGS:data "@contains evil" "deny,status:403,msg:'param data contains evil data',id:1"
   ```

   ​							如果 `data` 参数包含 `evil` 字符串，则前面的规则禁止用户使用资源到用户。 					

3. ​							保存更改，退出编辑器。 					

4. ​							重启 `httpd` 服务器： 					

   

   ```none
   # systemctl restart httpd
   ```

**验证**

1. ​							创建 `*test*.html` 页面： 					

   

   ```none
   # echo "mod_security test" > /var/www/html/test.html
   ```

2. ​							重启 `httpd` 服务器： 					

   

   ```none
   # systemctl restart httpd
   ```

3. ​							在 HTTP 请求的 `GET` 变量中，请求 `*test.html*` 但没有恶意数据： 					

   

   ```none
   $ curl http://localhost/test.html?data=good
   
   mod_security test
   ```

4. ​							在 HTTP 请求的 `GET` 变量中使用恶意数据请求 `*test.html*` ： 					

   

   ```none
   $ curl localhost/test.html?data=xxxevilxxx
   
   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
   <html><head>
   <title>403 Forbidden</title>
   </head><body>
   <h1>Forbidden</h1>
   <p>You don't have permission to access this resource.</p>
   </body></html>
   ```

5. ​							检查 `/var/log/httpd/error_log` 文件，并找到有关使用 `param data containing an evil data` 拒绝访问的日志条目： 					

   

   ```none
   [Wed May 25 08:01:31.036297 2022] [:error] [pid 5839:tid 139874434791168] [client ::1:45658] [client ::1] ModSecurity: Access denied with code 403 (phase 2). String match "evil" at ARGS:data. [file "/etc/httpd/conf.d/mod_security.conf"] [line "4"] [id "1"] [msg "param data contains evil data"] [hostname "localhost"] [uri "/test.html"] [unique_id "Yo4amwIdsBG3yZqSzh2GuwAAAIY"]
   ```

**其他资源**

- ​							[ModSecurity Wiki](https://github.com/SpiderLabs/ModSecurity/wiki) 					

## 1.11. 安装 Apache HTTP 服务器手册

​				这部分论述了如何安装 Apache HTTP 服务器手册。手册提供了详细信息，例如： 		

- ​						配置参数和指令 				
- ​						性能调整 				
- ​						身份验证设置 				
- ​						模块 				
- ​						内容缓存 				
- ​						安全提示 				
- ​						配置 TLS 加密 				

​				安装后，您可以使用 Web 浏览器显示手册。 		

**先决条件**

- ​						Apache HTTP 服务器已安装并运行。 				

**步骤**

1. ​						安装`httpd-manual`软件包： 				

   

   ```none
   # dnf install httpd-manual
   ```

2. ​						可选：默认情况下，所有连接到 Apache HTTP 服务器的客户端都可以显示手册。要限制对特定 IP 范围的访问，如`192.0.2.0/24` 子网，编辑`/etc/httpd/conf.d/manual.conf`文件，并将`Require ip 192.0.2.0/24`设置添加到 `<Directory "/usr/share/httpd/manual">`指令中： 				

   

   ```none
   <Directory "/usr/share/httpd/manual">
   ...
       **Require ip 192.0.2.0/24**
   ...
   </Directory>
   ```

3. ​						重启`httpd`服务： 				

   

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​						要显示 Apache HTTP 服务器手册，使用 Web 浏览器连接到`http://*host_name_or_IP_address*/manual/` 				

## 1.12. 使用 Apache 模块

​				`httpd` 服务是一个模块化应用程序，您可以使用多个 *Dynamic Shared Objects* (**DSO**) 进行扩展。*动态共享对象*是您可以在运行时动态加载或卸载的模块。您可以在 `/usr/lib64/httpd/modules/` 目录中找到这些模块。 		

### 1.12.1. 载入 DSO 模块

​					作为管理员，您可以通过配置服务器应加载的模块来选择要包含在服务器中的功能。若要载入特定的 DSO 模块，可使用`LoadModule` 指令。请注意，由单独的包提供的模块通常在`/etc/httpd/conf.modules.d/`目录中有自己的配置文件。 			

**先决条件**

- ​							已安装 `httpd` 软件包。 					

**步骤**

1. ​							在 `/etc/httpd/conf.modules.d/` 目录中的配置文件中搜索模块名称： 					

   

   ```none
   # grep mod_ssl.so /etc/httpd/conf.modules.d/*
   ```

2. ​							编辑找到模块名称的配置文件，然后取消对模块的 `LoadModule` 指令的注释： 					

   

   ```none
   LoadModule ssl_module modules/mod_ssl.so
   ```

3. ​							如果没有找到该模块，例如，因为 RHEL 软件包没有提供该模块，请创建一个配置文件，如 `/etc/httpd/conf.modules.d/30-example.conf` ： 					

   

   ```none
   LoadModule ssl_module modules/<custom_module>.so
   ```

4. ​							重启`httpd`服务： 					

   

   ```none
   # systemctl restart httpd
   ```

### 1.12.2. 编译自定义 Apache 模块

​					您可以创建自己的模块，并使用 `httpd-devel` 软件包的帮助构建，其中包含包括文件、标头文件以及编译模块所需的 `**APache eXtenSion**` (`pxs`) 实用程序。 			

**先决条件**

- ​							已安装 `httpd-devel` 软件包。 					

**步骤**

- ​							使用以下命令构建自定义模块： 					

  

  ```none
  # apxs -i -a -c module_name.c
  ```

**验证步骤**

- ​							[加载模块的方式与加载 DSO 模块](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#loading-a-dso-module_working-with-apache-modules)中所述的方法相同。 					

## 1.13. 从 NSS 数据库导出私钥和证书，以便在 Apache Web 服务器配置中使用它们

​				RHEL 8 不再为 Apache web 服务器提供`mod_nss` 模块，红帽建议使用`mod_ssl`模块。如果您将私钥和证书存储在网络安全服务(NSS)数据库中，例如，因为您将 web 服务器从 RHEL 7 迁移了到 RHEL 8，请按照以下步骤以 Privacy Enhanced Mail(PEM)格式提取密钥和证书。然后，您可以使用 `mod_ssl` 配置中的文件，如[在 Apache HTTP 服务器 上配置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#configuring-tls-encryption-on-an-apache-http-server_setting-apache-http-server)所述。 		

​				这个过程假设 NSS 数据库存储在 `/etc/httpd/alias/`中，并将导出的私钥和证书存储在`/etc/pki/tls/`目录中。 		

**先决条件**

- ​						私钥、证书和证书颁发机构(CA)证书存储在 NSS 数据库中。 				

**步骤**

1. ​						列出 NSS 数据库中的证书： 				

   

   ```none
   # certutil -d /etc/httpd/alias/ -L
   Certificate Nickname           Trust Attributes
                                  SSL,S/MIME,JAR/XPI
   
   Example CA                     C,,
   Example Server Certificate     u,u,u
   ```

   ​						在下一步中需要证书的别名。 				

2. ​						要提取私钥,您必须临时将密钥导出到一个 PKCS #12 文件： 				

   1. ​								使用与私钥关联的证书的别名，将密钥导出到一个 PKCS #12 文件： 						

      

      ```none
      # pk12util -o /etc/pki/tls/private/export.p12 -d /etc/httpd/alias/ -n "Example Server Certificate"
      Enter password for PKCS12 file: password
      Re-enter password: password
      pk12util: PKCS12 EXPORT SUCCESSFUL
      ```

      ​								请注意，您必须在 PKCS #12 文件中设置一个密码。下一步需要这个密码。 						

   2. ​								从 PKCS #12 文件中导出私钥： 						

      

      ```none
      # openssl pkcs12 -in /etc/pki/tls/private/export.p12 -out /etc/pki/tls/private/server.key -nocerts -nodes
      Enter Import Password: password
      MAC verified OK
      ```

   3. ​								删除临时 PKCS #12 文件： 						

      

      ```none
      # rm /etc/pki/tls/private/export.p12
      ```

3. ​						对`/etc/pki/tls/private/server.key`设置权限，以确保只有`root`用户才可以访问该文件： 				

   

   ```none
   # chown root:root /etc/pki/tls/private/server.key
   # chmod 0600 /etc/pki/tls/private/server.key
   ```

4. ​						使用 NSS 数据库中的服务器证书的别名导出 CA 证书： 				

   

   ```none
   # certutil -d /etc/httpd/alias/ -L -n "Example Server Certificate" -a -o /etc/pki/tls/certs/server.crt
   ```

5. ​						对`/etc/pki/tls/certs/server.crt`设置权限，以确保只有`root`用户才可以访问该文件： 				

   

   ```none
   # chown root:root /etc/pki/tls/certs/server.crt
   # chmod 0600 /etc/pki/tls/certs/server.crt
   ```

6. ​						使用 NSS 数据库中 CA 证书的别名导出 CA 证书： 				

   

   ```none
   # certutil -d /etc/httpd/alias/ -L -n "Example CA" -a -o /etc/pki/tls/certs/ca.crt
   ```

7. ​						[在 Apache HTTP 服务器中配置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#configuring-tls-encryption-on-an-apache-http-server_setting-apache-http-server)以配置 Apache web 服务器，并： 				

   - ​								将 `SSLCertificateKeyFile`参数设置为`/etc/pki/tls/private/server.key`。 						
   - ​								将`SSLCertificateFile`参数设置为`/etc/pki/tls/certs/server.crt`。 						
   - ​								将`SSLCACertificateFile`参数设置为`/etc/pki/tls/certs/ca.crt`。 						

**其他资源**

- ​						`certutil(1)` man page 				
- ​						`pk12util(1)` man page 				
- ​						`pkcs12(1ssl)` man page 				

## 1.14. 其他资源

- ​						`httpd(8)` man page 				
- ​						`httpd.service(8)` man page 				
- ​						`httpd.conf(5)` man page 				
- ​						`apachectl(8)` man page 				
- ​						Apache HTTP 服务器中的 Kerberos 身份验证：[使用 GSS-Proxy 进行 Apache httpd 操作](https://access.redhat.com/articles/5854761).使用 Kerberos 是在 Apache HTTP 服务器中强制进行客户端授权的替代方法。 				
- ​						[通过 PKCS #11 配置应用程序以使用加密硬件](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/configuring-applications-to-use-cryptographic-hardware-through-pkcs-11_security-hardening). 				

## 1.2. Apache HTTP 服务器中的显著变化

​				RHEL 9 提供 Apache HTTP 服务器的版本 2.4.48。RHEL 8 发布的 2.4.37 版本的显著变化包括： 		

- ​						Apache HTTP 服务器控制接口(`apachectl`)： 				
  - ​								现在，`apachectl status` 输出禁用了 `systemctl` pager。 						
  - ​								现在，如果您传递了附加参数，则 `apachectl` 命令会失败，而不是发出警告。 						
  - ​								`apachectl graceful-stop` 命令现在会立即返回。 						
  - ​								`apachectl configtest` 命令现在在不更改 SELinux 上下文的情况下执行 `httpd -t` 命令。 						
  - ​								RHEL 中的 `apachectl(8)` man page 现在完全指明了与上游 `apachectl` 之间的差异。 						
- ​						Apache eXtenSion 工具(`pxs`)： 				
  - ​								构建 `httpd` 软件包时，`/usr/bin/apxs` 命令不再使用或公开编译器选择的标志。现在，您可以使用 `/usr/lib64/httpd/build/vendor-apxs` 命令应用与构建 `httpd` 相同的编译器标志。要使用 `vendor-apxs` 命令，您必须首先安装 `redhat-rpm-config` 软件包。 						
- ​						Apache 模块： 				
  - ​								`mod_lua` 模块现在在一个单独的软件包中提供。 						
- ​						配置语法更改： 				
  - ​								在由 `mod_access_compat` 模块提供的已弃用的 `Allow` 指令中，注释（ `#` 字符）现在会触发语法错误，而不是静默忽略。 						
- ​						其他更改： 				
  - ​								内核线程 ID 现在直接在错误信息中使用，从而使它们准确且更简洁。 						
  - ​								多个小幅改进和漏洞修复。 						
  - ​								模块作者可使用多个新接口。 						

​				从 RHEL 8 开始，`httpd` 模块 API 没有向后兼容的更改。 		

​				Apache HTTP Server 2.4 是此 Application Stream 的初始版本，您可以将其作为 RPM 软件包轻松安装。 		

## 1.3. Apache 配置文件

​				当 `httpd` 服务启动时，默认情况下，它会从 [表 1.1 “httpd 服务配置文件”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#table-apache-editing-files) 中列出的位置读取配置。 		

**表 1.1. httpd 服务配置文件**

| 路径                         | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `/etc/httpd/conf/httpd.conf` | 主配置文件。                                                 |
| `/etc/httpd/conf.d/`         | 主配置文件中包含的配置文件的辅助目录。                       |
| `/etc/httpd/conf.modules.d/` | 用于载入 Red Hat Enterprise Linux 中打包动态模块的配置文件的辅助目录。在默认配置中，首先会处理这些配置文件。 |

​				虽然默认配置适用于大多数情况，但您也可以使用其他配置选项。要让任何配置更改生效，请重新启动 Web 服务器。有关如何重启 `httpd` 服务的更多信息，请参阅 [第 1.4 节 “管理 httpd 服务”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#managing-the-httpd-service_setting-apache-http-server)。 		

​				要检查配置中的可能错误，在 shell 提示符后输入以下内容： 		

```none
# apachectl configtest
Syntax OK
```

​				要更方便地从错误中恢复，请在编辑前复制原始文件。 		

## 1.4. 管理 httpd 服务

​				本节描述了如何启动、停止和重新启动 `httpd` 服务。 		

**先决条件**

- ​						已安装 Apache HTTP 服务器。 				

**步骤**

- ​						要启动 `httpd` 服务，请输入： 				

  ```none
  # systemctl start httpd
  ```

- ​						要停止 `httpd` 服务，请输入： 				

  ```none
  # systemctl stop httpd
  ```

- ​						要重启 `httpd` 服务，请输入： 				

  ```none
  # systemctl restart httpd
  ```

## 1.5. 设置单实例 Apache HTTP 服务器

​				这部分论述了如何设置单实例 Apache HTTP 服务器来提供静态 HTML 内容。 		

​				如果 web 服务器应该为与服务器关联的所有域提供相同的内容，请按照本节中的步骤进行操作。如果要为不同的域提供不同的内容，请设置基于名称的虚拟主机。详情请参阅 [配置 Apache 基于名称的虚拟主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#configuring-apache-name-based-virtual-hosts_setting-apache-http-server)。 		

**步骤**

1. ​						安装 `httpd` 软件包： 				

   ```none
   # dnf install httpd
   ```

2. ​						在本地防火墙中打开 TCP 端口 `80`: 				

   ```none
   # firewall-cmd --permanent --add-port=80/tcp
   # firewall-cmd --reload
   ```

3. ​						启用并启动 `httpd` 服务： 				

   ```none
   # systemctl enable --now httpd
   ```

4. ​						可选：将 HTML 文件添加到 `/var/www/html/` 目录中。 				

   注意

   ​							在 向`/var/www/html/` 添加内容时，在`httpd`默认运行的情况下，文件和目录必须可被用户读取。内容所有者可以是 `root`用户和`root`用户组，也可以是管理员所选择的其他用户或组。如果内容所有者是 `root` 用户和 `root` 用户组，则文件必须可被其他用户读取。所有文件和目录的 SELinux 上下文必须为 `httpd_sys_content_t`，其默认应用于 `/var/www` 目录中的所有内容。 					

**验证步骤**

- ​						使用 Web 浏览器连接到 `http://*server_IP_or_host_name*/`。 				

  ​						如果 `/var/www/html/` 目录为空，或者不包含 `index.html`或`index.htm`文件，则 Apache 会显示 `Red Hat Enterprise Linux 测试页面`。如果 `/var/www/html/` 包含具有不同名称的 HTML 文件，您可以通过输入该文件的 URL 来加载它们，如 `http://*server_IP_or_host_name*/*example.html*`。 				

**其他资源**

- ​						请参阅 Apache 手册。请参阅 [安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 				
- ​						请参见 `httpd.service(8)` 手册页。 				

## 1.6. 配置基于 Apache 名称的虚拟主机

​				基于名称的虚拟主机可让 Apache 为解析到服务器 IP 地址的不同域提供不同的内容。 		

​				本节中的步骤论述了使用单独的文档根目录为 `example.com` 和 `example.net` 域设置虚拟主机。两个虚拟主机都提供静态 HTML 内容。 		

**先决条件**

- ​						客户端和 Web 服务器将 `example.com` 和 `example.net` 域解析为 Web 服务器的 IP 地址。 				

  ​						请注意，您必须手动将这些条目添加到 DNS 服务器中。 				

**步骤**

1. ​						安装 `httpd` 软件包： 				

   ```none
   # dnf install httpd
   ```

2. ​						编辑 `/etc/httpd/conf/httpd.conf` 文件： 				

   1. ​								为 `example.com` 域添加以下虚拟主机配置： 						

      ```none
      <VirtualHost *:80>
          DocumentRoot "/var/www/example.com/"
          ServerName example.com
          CustomLog /var/log/httpd/example.com_access.log combined
          ErrorLog /var/log/httpd/example.com_error.log
      </VirtualHost>
      ```

      ​								这些设置配置以下内容： 						

      - ​										`<VirtualHost *:80>` 指令中的所有设置都是针对这个虚拟主机的。 								

      - ​										`DocumentRoot` 设置虚拟主机的 Web 内容的路径。 								

      - ​										`ServerName` 设置此虚拟主机为其提供内容服务的域。 								

        ​										要设置多个域，请在配置中添加 `ServerAlias` 参数，并在此参数中指定用空格分开的额外域。 								

      - ​										`CustomLog` 设置虚拟主机的访问日志的路径。 								

      - ​										`ErrorLog` 设置虚拟主机错误日志的路径。 								

        注意

        ​											Apache 还将配置中找到的第一个虚拟主机用于与`ServerName`和`Server Alias`参数中设置的任何域不匹配的请求。这还包括发送到服务器 IP 地址的请求。 									

3. ​						为 `example.net` 域添加类似的虚拟主机配置： 				

   ```none
   <VirtualHost *:80>
       DocumentRoot "/var/www/example.net/"
       ServerName example.net
       CustomLog /var/log/httpd/example.net_access.log combined
       ErrorLog /var/log/httpd/example.net_error.log
   </VirtualHost>
   ```

4. ​						为两个虚拟主机创建文档根目录： 				

   ```none
   # mkdir /var/www/example.com/
   # mkdir /var/www/example.net/
   ```

5. ​						如果您在 `DocumentRoot` 参数中设置的路径不在`/var/www/`中，请在两个文档根中设置 `httpd_sys_content_t` 上下文： 				

   ```none
   # semanage fcontext -a -t httpd_sys_content_t "/srv/example.com(/.*)?"
   # restorecon -Rv /srv/example.com/
   # semanage fcontext -a -t httpd_sys_content_t "/srv/example.net(/.\*)?"
   # restorecon -Rv /srv/example.net/
   ```

   ​						这些命令在`/srv/example.com/`和`/srv/ example.net/` 目录中设置 `httpd_sys_content_t`上下文。 				

   ​						请注意，您必须安装 `policycoreutils-python-utils` 软件包才能运行`restorecon` 命令。 				

6. ​						在本地防火墙中打开端口 `80`: 				

   ```none
   # firewall-cmd --permanent --add-port=80/tcp
   # firewall-cmd --reload
   ```

7. ​						启用并启动 `httpd` 服务： 				

   ```none
   # systemctl enable --now httpd
   ```

**验证步骤**

1. ​						在每个虚拟主机的文档 root 中创建不同的示例文件： 				

   ```none
   # echo "vHost example.com" > /var/www/example.com/index.html
   # echo "vHost example.net" > /var/www/example.net/index.html
   ```

2. ​						使用浏览器并连接到 `http://example.com`Web 服务器显示`example.com`虚拟主机中的示例文件。 				

3. ​						使用浏览器并连接到 `http://example.net`Web 服务器显示`example.net`虚拟主机中的示例文件。 				

**其他资源**

- ​						有关配置 Apache 虚拟主机的详情，请参考 Apache 手册中的 `Virtual Hosts` 文档。有关安装手册的详情，请参考 [第 1.10 节 “安装 Apache HTTP 服务器手册”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 				

## 1.7. 为 Apache HTTP web 服务器配置 Kerberos 验证

​				要在 Apache HTTP web 服务器中执行 Kerberos 身份验证，RHEL 9 使用 `mod_auth_gssapi` Apache 模块。Generic Security Services API(`GSSAPI`)是请求使用安全库（如 Kerberos）的应用程序的接口。`gssproxy` 服务允许对 `httpd` 服务器实施特权分离，从安全的角度来看，这优化了此过程。 		

注意

​					`mod_auth_gssapi` 模块取代了已删除的 `mod_auth_kerb` 模块。 			

**先决条件**

- ​						已安装了 `**httpd**`, `**mod_auth_gssapi**` 和 `**gssproxy**` 软件包。 				
- ​						Apache Web 服务器已设置，并且 `httpd` 服务在运行。 				

### 1.7.1. 在 IdM 环境中设置 GSS-Proxy

​					这个流程描述了如何设置 `GSS-Proxy` ，以便在 Apache HTTP Web 服务器中执行 Kerberos 身份验证。 			

**步骤**

1. ​							通过创建服务主体来启用对 HTTP/<SERVER_NAME>@realm 主体的`keytab`文件的访问： 					

   ```none
   # ipa service-add HTTP/<SERVER_NAME>
   ```

2. ​							检索存储在`/etc/gssproxy/http.keytab`文件中的主体的`keytab`： 					

   ```none
   # ipa-getkeytab -s $(awk '/^server =/ {print $3}' /etc/ipa/default.conf) -k /etc/gssproxy/http.keytab -p HTTP/$(hostname -f)
   ```

   ​							此步骤将权限设置为 400，因此只有 `root` 用户有权访问 `keytab` 文件。`apache` 用户无法访问。 					

3. ​							使用以下内容创建 `/etc/gssproxy/80-httpd.conf` 文件： 					

   ```none
   [service/HTTP]
     mechs = krb5
     cred_store = keytab:/etc/gssproxy/http.keytab
     cred_store = ccache:/var/lib/gssproxy/clients/krb5cc_%U
     euid = apache
   ```

4. ​							重启并启用 `gssproxy` 服务： 					

   ```none
   # systemctl restart gssproxy.service
   # systemctl enable gssproxy.service
   ```

**其他资源**

- ​							有关使用或调整`GSS-Proxy`的详情，请查看 `gssproxy(8)`、`gssproxy-mech(8)`和`gssproxy.conf(5)`手册页。 					

### 1.7.2. 为 Apache HTTP Web 服务器共享的目录配置 Kerberos 身份验证

​					这个过程描述了如何为 `/var/www/html/private/` 目录配置 Kerberos 身份验证。 			

**先决条件**

- ​							`gssproxy` 服务已配置并在运行。 					

**步骤**

1. ​							配置 `mod_auth_gssapi`模块来保护 `/var/www/html/private/`目录： 					

   ```none
   <Location /var/www/html/private>
     AuthType GSSAPI
     AuthName "GSSAPI Login"
     Require valid-user
   </Location>
   ```

2. ​							使用以下内容创建`/etc/systemd/system/httpd.service`文件： 					

   ```none
   .include /lib/systemd/system/httpd.service
   [Service]
   Environment=GSS_USE_PROXY=1
   ```

3. ​							重新载入`systemd`配置： 					

   ```none
   # systemctl daemon-reload
   ```

4. ​							重启`httpd`服务： 					

   ```none
   # systemctl restart httpd.service
   ```

**验证步骤**

1. ​							获取Kerberos ticket： 					

   ```none
   # kinit
   ```

2. ​							在浏览器中打开到受保护目录的URL。 					

## 1.8. 在Apache HTTP服务器上配置TLS加密

​				默认情况下，Apache 使用未加密的 HTTP 连接向客户端提供内容。这部分论述了如何在 Apache HTTP 服务器上启用 TLS 加密和配置常用的与加密相关的设置。 		

**先决条件**

- ​						Apache HTTP 服务器已安装并运行。 				

### 1.8.1. 在 Apache HTTP 服务器中添加 TLS 加密

​					这部分论述了如何在Apache HTTP 服务器上对`example.com`域启用TLS加密。 			

**先决条件**

- ​							Apache HTTP 服务器已安装并运行。 					

- ​							私钥存储在 `/etc/pki/tls/private/example.com.key` 文件中。 					

  ​							有关创建私钥和证书签名请求(CSR)的详细信息，以及如何从证书颁发机构(CA)请求证书，请参阅您的 CA 文档。或者，如果您的 CA 支持 ACME 协议，您可以使用 `mod_md` 模块自动检索和调配 TLS 证书。 					

- ​							TLS 证书存储在`/etc/pki/tls/certs/example.com.crt`文件中。如果您使用其他路径，请调整该流程的对应步骤。 					

- ​							CA 证书存储在 `/etc/pki/tls/certs/ca.crt` 文件中。如果您使用其他路径，请调整该流程的对应步骤。 					

- ​							客户端和网页服务器会将服务器的主机名解析为 web 服务器的 IP 地址。 					

**步骤**

1. ​							安装 `mod_ssl` 软件包： 					

   ```none
   # dnf install mod_ssl
   ```

2. ​							编辑`/etc/httpd/conf.d/ssl.conf`文件，并将以下设置添加到 `<VirtualHost _default_:443>`指令中： 					

   1. ​									设置服务器名称： 							

      ```none
      ServerName example.com
      ```

      重要

      ​										服务器名称必须与证书的 `Common Name`字段中设置的条目匹配。 								

   2. ​									可选：如果证书在 `Subject Alt Names` (SAN)字段中包含额外的主机名，您可以配置 `mod_ssl` 来为这些主机名提供 TLS 加密。要配置此功能，请添加具有对应名称的`ServerAliases`参数： 							

      ```none
      ServerAlias www.example.com server.example.com
      ```

   3. ​									设置到私钥、服务器证书和 CA 证书的路径： 							

      ```none
      SSLCertificateKeyFile "/etc/pki/tls/private/example.com.key"
      SSLCertificateFile "/etc/pki/tls/certs/example.com.crt"
      SSLCACertificateFile "/etc/pki/tls/certs/ca.crt"
      ```

3. ​							出于安全考虑，配置成只有 `root` 用户才可以访问私钥文件： 					

   ```none
   # chown root:root /etc/pki/tls/private/example.com.key
   # chmod 600 /etc/pki/tls/private/example.com.key
   ```

   警告

   ​								如果私钥被设置为可以被未授权的用户访问，则需要撤销证书，然后再创建一个新私钥并请求一个新证书。否则，TLS 连接就不再安全。 						

4. ​							在本地防火墙中打开端口 `443`: 					

   ```none
   # firewall-cmd --permanent --add-port=443/tcp
   # firewall-cmd --reload
   ```

5. ​							重启`httpd`服务： 					

   ```none
   # systemctl restart httpd
   ```

   注意

   ​								如果您使用密码来保护私钥文件，则必须在每次 `httpd`服务启动时都输入此密码。 						

**验证步骤**

- ​							使用浏览器并连接到`https://*example.com*`。 					

**其他资源**

- ​							请参阅 Apache 手册中的 `SSL/TLS 加密` 文档。 					
- ​							请参阅 [安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 					
- ​							[RHEL 9 中 TLS 的安全注意事项](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/securing_networks/planning-and-implementing-tls_securing-networks#security-considerations-for-tls-in-rhel_planning-and-implementing-tls) 					

### 1.8.2. 在 Apache HTTP 服务器中设置支持的 TLS 协议版本

​					默认情况下，RHEL 上的 Apache HTTP 服务器使用系统范围的加密策略来定义安全默认值，这些值也与最新的浏览器兼容。例如，`DEFAULT`策略定义了在 apache 中只启用 `TLSv1.2`和`TLSv1.3`协议版本。 			

​					这部分论述了如何手动配置 Apache HTTP 服务器支持的 TLS 协议版本。如果您的环境只需要启用特定的 TLS 协议版本，请按照以下步骤操作，例如： 			

- ​							如果您的环境要求客户端也可以使用弱 `TLS1` (TLSv1.0)或`TLS1.1`协议。 					
- ​							如果你想将 Apache 配置为只支持`TLSv1.2`或`TLSv1.3`协议。 					

**先决条件**

- ​							TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 					

**步骤**

1. ​							编辑 `/etc/httpd/conf/httpd.conf` 文件，并将以下设置添加到您要为其设置 TLS 协议版本的`<VirtualHost>`指令中。例如，只启用`TLSv1.3`协议： 					

   ```none
   SSLProtocol -All TLSv1.3
   ```

2. ​							重启`httpd`服务： 					

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​							使用以下命令来验证服务器是否支持`TLSv1.3`: 					

   ```none
   # openssl s_client -connect example.com:443 -tls1_3
   ```

2. ​							使用以下命令来验证服务器是否不支持`TLSv1.2` ： 					

   ```none
   # openssl s_client -connect example.com:443 -tls1_2
   ```

   ​							如果服务器不支持该协议，命令会返回一个错误： 					

   ```none
   140111600609088:error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version:ssl/record/rec_layer_s3.c:1543:SSL alert number 70
   ```

3. ​							可选：为其他 TLS 协议版本重复该命令。 					

**其他资源**

- ​							请参阅 `update-crypto-policies(8)` 手册页。 					
- ​							请参阅 [使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 					
- ​							有关 `SSLProtocol` 参数的详情，请查看 Apache 手册中的 `mod_ssl` 文档。 					
- ​							请参阅 [安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 					

### 1.8.3. 在 Apache HTTP 服务器中设置支持的密码

​					默认情况下，Apache HTTP 服务器使用定义安全默认值的系统范围的加密策略，这些值也与最新的浏览器兼容。有关系统范围加密允许的密码列表，请查看`/etc/crypto-policies/back-ends/openssl.config` 文件。 			

​					这部分论述了如何手动配置 Apache HTTP 服务器支持的加密。如果您的环境需要特定的加密系统，请按照以下步骤操作。 			

**先决条件**

- ​							TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 					

**步骤**

1. ​							编辑`/etc/httpd/conf/httpd.conf`文件，并将`SSLCipherSuite`参数添加到您要为其设置 TLS 密码的`<VirtualHost>`指令中： 					

   ```none
   SSLCipherSuite "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!SHA1:!SHA256"
   ```

   ​							这个示例只启用 `EECDH+AESGCM`、`EDH+AESGCM`、`AES256+EECDH` 和 `AES256+EDH`密码，并禁用所有使用`SHA1`和`SHA256`消息身份验证码(MAC)的密码。 					

2. ​							重启`httpd`服务： 					

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​							显示 Apache HTTP 服务器支持的密码列表： 					

   1. ​									安装`nmap`软件包： 							

      ```none
      # dnf install nmap
      ```

   2. ​									使用`nmap`工具来显示支持的加密： 							

      ```none
      # nmap --script ssl-enum-ciphers -p 443 example.com
      ...
      PORT    STATE SERVICE
      443/tcp open  https
      | ssl-enum-ciphers:
      |   TLSv1.2:
      |     ciphers:
      |       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
      |       TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (dh 2048) - A
      |       TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (ecdh_x25519) - A
      ...
      ```

**其他资源**

- ​							请参阅 `update-crypto-policies(8)` 手册页。 					
- ​							请参阅 [使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 					
- ​							有关 `SSLCipherSuite` 参数的详情，请查看 Apache 手册中的 `mod_ssl` 文档。 					
- ​							请参阅 [安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 					

## 1.9. 配置 TLS 客户端证书身份验证

​				客户端证书身份验证可让管理员只允许使用证书进行身份验证的用户访问 web 服务器上的资源。这部分论述了如何为`/var/www/html/Example/`目录配置客户端证书身份验证。 		

​				如果 Apache HTTP 服务器使用 TLS 1.3 协议，某些客户端将需要额外的配置。例如，在 Firefox 中，将`about:config`菜单中的`security.tls.enable_post_handshake_auth`参数设置为`true`。详情请查看 [Red Hat Enterprise Linux 8中的传输层安全版本1.3](https://www.redhat.com/en/blog/transport-layer-security-version-13-red-hat-enterprise-linux-8)。 		

**先决条件**

- ​						TLS 加密在服务器上是启用的，如 [将 TLS 加密添加到 Apache HTTP 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#proc_adding-tls-encryption-to-an-apache-http-server-configuration_configuring-tls-encryption-on-an-apache-http-server) 中所述。 				

**步骤**

1. ​						编辑`/etc/httpd/conf/httpd.conf`文件，并将以下设置添加到你要为其配置客户端验证的`<VirtualHost>`指令中： 				

   ```none
   <Directory "/var/www/html/Example/">
     SSLVerifyClient require
   </Directory>
   ```

   ​						`SSLVerifyClient require`设置定义了服务器必须成功验证客户端证书，然后客户端才能访问`/var/www/html/Example/`目录中的内容。 				

2. ​						重启`httpd`服务： 				

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​						使用`curl`工具在没有客户端身份验证的情况下访问`https://example.com/Example/`URL： 				

   ```none
   $ curl https://example.com/Example/
   curl: (56) OpenSSL SSL_read: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 **alert certificate required**, errno 0
   ```

   ​						这个错误表示 web 服务器需要客户端证书验证。 				

2. ​						将客户端私钥和证书以及 CA 证书传递给`curl`以便使用客户端身份验证来访问相同的URL： 				

   ```none
   $ curl --cacert ca.crt --key client.key --cert client.crt https://example.com/Example/
   ```

   ​						如果请求成功，`curl`会显示存储在`/var/www/html/Example/`目录中的`index.html`文件。 				

**其他资源**

- ​						请参阅 Apache `手册中的 mod_ssl 配置指南` 文档。 				
- ​						请参阅 [安装 Apache HTTP 服务器手册](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#installing-the-apache-http-server-manual_setting-apache-http-server)。 				

## 1.10. 安装 Apache HTTP 服务器手册

​				这部分论述了如何安装 Apache HTTP 服务器手册。手册提供了详细信息，例如： 		

- ​						配置参数和指令 				
- ​						性能调整 				
- ​						身份验证设置 				
- ​						模块 				
- ​						内容缓存 				
- ​						安全提示 				
- ​						配置 TLS 加密 				

​				安装后，您可以使用 Web 浏览器显示手册。 		

**先决条件**

- ​						Apache HTTP 服务器已安装并运行。 				

**步骤**

1. ​						安装`httpd-manual`软件包： 				

   ```none
   # dnf install httpd-manual
   ```

2. ​						可选：默认情况下，所有连接到 Apache HTTP 服务器的客户端都可以显示手册。要限制对特定 IP 范围的访问，如`192.0.2.0/24` 子网，编辑`/etc/httpd/conf.d/manual.conf`文件，并将`Require ip 192.0.2.0/24`设置添加到 `<Directory "/usr/share/httpd/manual">`指令中： 				

   ```none
   <Directory "/usr/share/httpd/manual">
   ...
       **Require ip 192.0.2.0/24**
   ...
   </Directory>
   ```

3. ​						重启`httpd`服务： 				

   ```none
   # systemctl restart httpd
   ```

**验证步骤**

1. ​						要显示 Apache HTTP 服务器手册，使用 Web 浏览器连接到`http://*host_name_or_IP_address*/manual/` 				

## 1.11. 使用模块

​				作为一个模块化应用，`httpd`服务与多个*动态共享对象*(**DSO**s)一起分发，它们可以根据需要在运行时动态载入或卸载。这些模块位于`/usr/lib64/httpd/modules/`目录中。 		

### 1.11.1. 载入模块

​					若要载入特定的 DSO 模块，可使用`LoadModule` 指令。请注意，由单独的包提供的模块通常在`/etc/httpd/conf.modules.d/`目录中有自己的配置文件。 			

**载入 mod_ssl DSO**

​						

```none
LoadModule ssl_module modules/mod_ssl.so
```

​					载入该模块后，重启 web 服务器以重新载入配置。有关如何重启 `httpd` 服务的更多信息，请参阅 [第 1.4 节 “管理 httpd 服务”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_web_servers_and_reverse_proxies/index#managing-the-httpd-service_setting-apache-http-server)。 			

### 1.11.2. 编写模块

​					若要创建新的 DSO 模块，请确保已安装了`httpd-devel`软件包。要做到这一点，以`root`用户身份输入以下命令： 			

```none
# dnf install httpd-devel
```

​					此软件包包含编译模块所需的 include 文件、头文件和**APache eXtenSion**(`apxs`)工具。 			

​					编写完成后，可以使用以下命令构建模块： 			

```none
# apxs -i -a -c module_name.c
```

​					如果构建成功，您就可以像 **Apache HTTP 服务器**分发的其他模块一样，载入该模块。 			

## 1.12. 从 NSS 数据库导出私钥和证书，以便在 Apache Web 服务器配置中使用它们

​				因为 RHEL 8 不再为 Apache web 服务器提供 `mod_nss` 模块，因此红帽建议使用 `mod_ssl` 模块。如果您将私钥和证书存储在网络安全服务(NSS)数据库中，请按照以下步骤[以 Privacy Enhanced 邮件(PEM)格式提取密钥和证书](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/setting-apache-http-server_deploying-different-types-of-servers#exporting-a-private-key-and-certificates-from-an-nss-database-to-use-them-in-an-apache-web-server-configuration_setting-apache-http-server)。 		

## 1.13. 其他资源

- ​						`httpd(8)` - `httpd`服务的手册页，包含其命令行选项的完整列表。 				
- ​						`httpd.service(8)` - `httpd.service`单元文件的手册页，描述如何自定义和加强服务。 				
- ​						`httpd.conf(5)` - `httpd` 配置的 man page，描述 `httpd` 配置文件的结构和位置。 				
- ​						`apachectl(8)` - **Apache HTTP 服务器**控制接口的手册页。 				
- ​						有关如何在 Apache HTTP 服务器中配置 Kerberos 验证的详情，请参考[为 Apache httpd 操作使用 GSS-Proxy](https://access.redhat.com/articles/5854761)。使用 Kerberos 是在 Apache HTTP 服务器中强制进行客户端授权的替代方法。 				
- ​						[通过 PKCS #11 配置应用程序以使用加密硬件](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/configuring-applications-to-use-cryptographic-hardware-through-pkcs-11_security-hardening). 				

## 隐藏 Apache 版本号和其它敏感信息
当远程请求发送到你的 Apache Web 服务器时，在默认情况下，一些有价值的信息，如 web 服务器版本号、服务器操作系统详细信息、已安装的 Apache 模块等等，会随服务器生成的文档发回客户端。

这给攻击者利用漏洞并获取对 web 服务器的访问提供了很多有用的信息。为了避免显示 web 服务器信息，我们将在本文中演示如何使用特定的 Apache 指令隐藏 Apache Web 服务器的信息。

两个重要的指令是：
ServerSignature

这允许在服务器生成的文档（如错误消息、modproxy 的 ftp 目录列表、modinfo 输出等等）下添加一个显示服务器名称和版本号的页脚行。

它有三个可能的值：

    On - 允许在服务器生成的文档中添加尾部页脚行，
    Off - 禁用页脚行
    EMail - 创建一个 “mailto:” 引用；用于将邮件发送到所引用文档的 ServerAdmin。

ServerTokens

它决定了发送回客户端的服务器响应头字段是否包含服务器操作系统类型的描述和有关已启用的 Apache 模块的信息。

此指令具有以下可能的值（以及在设置特定值时发送到客户端的示例信息）：

    ServerTokens   Full (或者不指定)

发送给客户端的信息： Server: Apache/2.4.2 (Unix) PHP/4.2.2 MyMod/1.2

    ServerTokens   Prod[uctOnly]

发送给客户端的信息： Server: Apache

    ServerTokens   Major

发送给客户端的信息： Server: Apache/2

    ServerTokens   Minor

发送给客户端的信息： Server: Apache/2.4

    ServerTokens   Min[imal]

发送给客户端的信息：Server: Apache/2.4.2

    ServerTokens   OS

发送给客户端的信息： Server: Apache/2.4.2 (Unix)

注意：在 Apache 2.0.44 之后，ServerTokens 也控制由 ServerSignature 指令提供的信息。

推荐阅读： 5 个加速 Apache Web 服务器的贴士。

为了隐藏 web 服务器版本号、服务器操作系统细节、已安装的 Apache 模块等等，使用你最喜欢的编辑器打开 Apache 配置文件：

    $ sudo vi /etc/apache2/apache2.conf        #Debian/Ubuntu systems
    $ sudo vi /etc/httpd/conf/httpd.conf       #RHEL/CentOS systems

添加/修改/附加下面的行：

    ServerTokens Prod
    ServerSignature Off

保存并退出文件，重启你的 Apache 服务器：

    $ sudo systemctl apache2 restart  #SystemD
    $ sudo sevice apache2 restart     #SysVInit

## Apache HTTP Server Version 2.4

The configuration system is fully documented in /usr/share/doc/apache2/README.Debian.gz. Refer to this for the full documentation. Documentation for the web server itself can be found by accessing the manual if the apache2-doc package was installed on this server.

The configuration layout for an Apache2 web server installation on Debian systems is as follows:

/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf


    apache2.conf is the main configuration file. It puts the pieces together by including all remaining configuration files when starting up the web server.
    ports.conf is always included from the main configuration file. It is used to determine the listening ports for incoming connections, and this file can be customized anytime.
    Configuration files in the mods-enabled/, conf-enabled/ and sites-enabled/ directories contain particular configuration snippets which manage modules, global configuration fragments, or virtual host configurations, respectively.
    They are activated by symlinking available configuration files from their respective *-available/ counterparts. These should be managed by using our helpers a2enmod, a2dismod, a2ensite, a2dissite, and a2enconf, a2disconf . See their respective man pages for detailed information.
    The binary is called apache2. Due to the use of environment variables, in the default configuration, apache2 needs to be started/stopped with /etc/init.d/apache2 or apache2ctl. Calling /usr/bin/apache2 directly will not work with the default configuration.

Document Roots

By default, Debian does not allow access through the web browser to any file apart of those located in /var/www, public_html directories (when enabled) and /usr/share (for web applications). If your site is using a web document root located elsewhere (such as in /srv) you may need to whitelist your document root directory in /etc/apache2/apache2.conf.

The default Debian document root is /var/www/html. You can make your own virtual hosts under /var/www. This is different to previous releases which provides better security out of the box.
Reporting Problems

Please use the reportbug tool to report bugs in the Apache2 package with Debian. However, check existing bug reports before reporting a new bug.

Please report bugs specific to modules (such as PHP and others) to respective packages, not to the web server itself.





Download 	Download the latest release from http://httpd.apache.org/download.cgi
Extract 	$ gzip -d httpd-NN.tar.gz
$ tar xvf httpd-NN.tar
$ cd httpd-NN
Configure 	$ ./configure --prefix=PREFIX
Compile 	$ make
Install 	$ make install
Customize 	$ vi PREFIX/conf/httpd.conf
Test 	$ PREFIX/bin/apachectl -k start

NN must be replaced with the current version number, and PREFIX must be replaced with the filesystem path under which the server should be installed. If PREFIX is not specified, it defaults to /usr/local/apache2.

Each section of the compilation and installation process is described in more detail below, beginning with the requirements for compiling and installing Apache httpd.
top
Requirements

The following requirements exist for building Apache httpd:

APR and APR-Util
    Make sure you have APR and APR-Util already installed on your system. If you don't, or prefer to not use the system-provided versions, download the latest versions of both APR and APR-Util from Apache APR, unpack them into /httpd_source_tree_root/srclib/apr and /httpd_source_tree_root/srclib/apr-util (be sure the directory names do not have version numbers; for example, the APR distribution must be under /httpd_source_tree_root/srclib/apr/) and use ./configure's --with-included-apr option. On some platforms, you may have to install the corresponding -dev packages to allow httpd to build against your installed copy of APR and APR-Util.
Perl-Compatible Regular Expressions Library (PCRE)
    This library is required but not longer bundled with httpd. Download the source code from http://www.pcre.org, or install a Port or Package. If your build system can't find the pcre-config script installed by the PCRE build, point to it using the --with-pcre parameter. On some platforms, you may have to install the corresponding -dev package to allow httpd to build against your installed copy of PCRE.
Disk Space
    Make sure you have at least 50 MB of temporary free disk space available. After installation the server occupies approximately 10 MB of disk space. The actual disk space requirements will vary considerably based on your chosen configuration options, any third-party modules, and, of course, the size of the web site or sites that you have on the server.
ANSI-C Compiler and Build System
    Make sure you have an ANSI-C compiler installed. The GNU C compiler (GCC) from the Free Software Foundation (FSF) is recommended. If you don't have GCC then at least make sure your vendor's compiler is ANSI compliant. In addition, your PATH must contain basic build tools such as make.
Accurate time keeping
    Elements of the HTTP protocol are expressed as the time of day. So, it's time to investigate setting some time synchronization facility on your system. Usually the ntpdate or xntpd programs are used for this purpose which are based on the Network Time Protocol (NTP). See the NTP homepage for more details about NTP software and public time servers.
Perl 5 [OPTIONAL]
    For some of the support scripts like apxs or dbmmanage (which are written in Perl) the Perl 5 interpreter is required (versions 5.003 or newer are sufficient). If no Perl 5 interpreter is found by the configure script, you will not be able to use the affected support scripts. Of course, you will still be able to build and use Apache httpd.

top
Download

The Apache HTTP Server can be downloaded from the Apache HTTP Server download site, which lists several mirrors. Most users of Apache on unix-like systems will be better off downloading and compiling a source version. The build process (described below) is easy, and it allows you to customize your server to suit your needs. In addition, binary releases are often not up to date with the latest source releases. If you do download a binary, follow the instructions in the INSTALL.bindist file inside the distribution.

After downloading, it is important to verify that you have a complete and unmodified version of the Apache HTTP Server. This can be accomplished by testing the downloaded tarball against the PGP signature. Details on how to do this are available on the download page and an extended example is available describing the use of PGP.
top
Extract

Extracting the source from the Apache HTTP Server tarball is a simple matter of uncompressing, and then untarring:

$ gzip -d httpd-NN.tar.gz
$ tar xvf httpd-NN.tar

This will create a new directory under the current directory containing the source code for the distribution. You should cd into that directory before proceeding with compiling the server.
top
Configuring the source tree

The next step is to configure the Apache source tree for your particular platform and personal requirements. This is done using the script configure included in the root directory of the distribution. (Developers downloading an unreleased version of the Apache source tree will need to have autoconf and libtool installed and will need to run buildconf before proceeding with the next steps. This is not necessary for official releases.)

To configure the source tree using all the default options, simply type ./configure. To change the default options, configure accepts a variety of variables and command line options.

The most important option is the location --prefix where Apache is to be installed later, because Apache has to be configured for this location to work correctly. More fine-tuned control of the location of files is possible with additional configure options.

Also at this point, you can specify which features you want included in Apache by enabling and disabling modules. Apache comes with a wide range of modules included by default. They will be compiled as shared objects (DSOs) which can be loaded or unloaded at runtime. You can also choose to compile modules statically by using the option --enable-module=static.

Additional modules are enabled using the --enable-module option, where module is the name of the module with the mod_ string removed and with any underscore converted to a dash. Similarly, you can disable modules with the --disable-module option. Be careful when using these options, since configure cannot warn you if the module you specify does not exist; it will simply ignore the option.

In addition, it is sometimes necessary to provide the configure script with extra information about the location of your compiler, libraries, or header files. This is done by passing either environment variables or command line options to configure. For more information, see the configure manual page. Or invoke configure using the --help option.

For a short impression of what possibilities you have, here is a typical example which compiles Apache for the installation tree /sw/pkg/apache with a particular compiler and flags plus the two additional modules mod_ldap and mod_lua:

$ CC="pgcc" CFLAGS="-O2" \
./configure --prefix=/sw/pkg/apache \
--enable-ldap=shared \
--enable-lua=shared

When configure is run it will take several minutes to test for the availability of features on your system and build Makefiles which will later be used to compile the server.

Details on all the different configure options are available on the configure manual page.
top
Build

Now you can build the various parts which form the Apache package by simply running the command:

$ make

Please be patient here, since a base configuration takes several minutes to compile and the time will vary widely depending on your hardware and the number of modules that you have enabled.
top
Install

Now it's time to install the package under the configured installation PREFIX (see --prefix option above) by running:

$ make install

This step will typically require root privileges, since PREFIX is usually a directory with restricted write permissions.

If you are upgrading, the installation will not overwrite your configuration files or documents.
top
Customize

Next, you can customize your Apache HTTP server by editing the configuration files under PREFIX/conf/.

$ vi PREFIX/conf/httpd.conf

Have a look at the Apache manual under PREFIX/docs/manual/ or consult http://httpd.apache.org/docs/2.4/ for the most recent version of this manual and a complete reference of available configuration directives.
top
Test

Now you can start your Apache HTTP server by immediately running:

$ PREFIX/bin/apachectl -k start

You should then be able to request your first document via the URL http://localhost/. The web page you see is located under the DocumentRoot, which will usually be PREFIX/htdocs/. Then stop the server again by running:

$ PREFIX/bin/apachectl -k stop
top
Upgrading

The first step in upgrading is to read the release announcement and the file CHANGES in the source distribution to find any changes that may affect your site. When changing between major releases (for example, from 2.0 to 2.2 or from 2.2 to 2.4), there will likely be major differences in the compile-time and run-time configuration that will require manual adjustments. All modules will also need to be upgraded to accommodate changes in the module API.

Upgrading from one minor version to the next (for example, from 2.2.55 to 2.2.57) is easier. The make install process will not overwrite any of your existing documents, log files, or configuration files. In addition, the developers make every effort to avoid incompatible changes in the configure options, run-time configuration, or the module API between minor versions. In most cases you should be able to use an identical configure command line, an identical configuration file, and all of your modules should continue to work.

To upgrade across minor versions, start by finding the file config.nice in the build directory of your installed server or at the root of the source tree for your old install. This will contain the exact configure command line that you used to configure the source tree. Then to upgrade from one version to the next, you need only copy the config.nice file to the source tree of the new version, edit it to make any desired changes, and then run:

$ ./config.nice
$ make
$ make install
$ PREFIX/bin/apachectl -k graceful-stop
$ PREFIX/bin/apachectl -k start
You should always test any new version in your environment before putting it into production. For example, you can install and run the new version along side the old one by using a different --prefix and a different port (by adjusting the Listen directive) to test for any incompatibilities before doing the final upgrade.

You can pass additional arguments to config.nice, which will be appended to your original configure options:

$ ./config.nice --prefix=/home/test/apache --with-port=90
top
Third-party packages

A large number of third parties provide their own packaged distributions of the Apache HTTP Server for installation on particular platforms. This includes the various Linux distributions, various third-party Windows packages, Mac OS X, Solaris, and many more.

Our software license not only permits, but encourages, this kind of redistribution. However, it does result in a situation where the configuration layout and defaults on your installation of the server may differ from what is stated in the documentation. While unfortunate, this situation is not likely to change any time soon.

A description of these third-party distrubutions is maintained in the HTTP Server wiki, and should reflect the current state of these third-party distributions. However, you will need to familiarize yourself with your particular platform's package management and installation procedures.

Available Languages:  de  |  en  |  es  |  fr  |  ja  |  ko  |  tr
top
Comments
Notice:
This is not a Q&A section. Comments placed here should be pointed towards suggestions on improving the documentation or server, and may be removed again by our moderators if they are either implemented or considered invalid/off-topic. Questions on how to manage the Apache HTTP Server should be directed at either our IRC channel, #httpd, on Freenode, or sent to our mailing lists.

RSS   Log in / register

Colton  18 days ago      Rating: 0 (register an account in order to rate comments)

How do I compile only certain modules?

Eric Strickland  27 days ago      Rating: 0 (register an account in order to rate comments)

I would like to know how to set up Apache to my text editor to build websites on my PC? like using localhost with HTML besides use a index.php. please help me. Thank you for your time.I've looked everywhere in the doc's for it a lot of stuff in there is confusing

liuzhe   33 days ago      Rating: 0 (register an account in order to rate comments)

does apache tar  divide into 64bit or 32bit

dimitry  38 days ago      Rating: 0 (register an account in order to rate comments)

Will Apache 2.2 or 2.4 support on Solaris 8 Operating System?

 [Account verified by Apache] covener  38 days ago      Rating: 0 (register an account in order to rate comments)

No answer other than "try it and see". It's probably too old for anyone else to care about.

nabendu  74 days ago      Rating: 0 (register an account in order to rate comments)

Hi Friend getting following errors while compiling apache with ssl

 Entering directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
/root/Apache_Package/httpd-2.4.23/srclib/apr/libtool --silent --mode=link gcc -std=gnu99 -I/usr/local/ssl/include   -g -O2 -pthread    -L/usr/local/ssl/lib   -lssl -lcrypto -lrt -lcrypt -lpthread -ldl       -o mod_ssl.la -rpath /usr/local/apache2/modules -module -avoid-version  mod_ssl.lo ssl_engine_config.lo ssl_engine_init.lo ssl_engine_io.lo ssl_engine_kernel.lo ssl_engine_log.lo ssl_engine_mutex.lo ssl_engine_pphrase.lo ssl_engine_rand.lo ssl_engine_vars.lo ssl_scache.lo ssl_util_stapling.lo ssl_util.lo ssl_util_ssl.lo ssl_engine_ocsp.lo ssl_util_ocsp.lo  -export-symbols-regex ssl_module
/usr/bin/ld: /usr/local/ssl/lib/libssl.a(s3_srvr.o): relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC
/usr/local/ssl/lib/libssl.a: could not read symbols: Bad value
collect2: error: ld returned 1 exit status
make[4]: *** [mod_ssl.la] Error 1
make[4]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
make[3]: *** [shared-build-recursive] Error 1
make[3]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
make[2]: *** [shared-build-recursive] Error 1
make[2]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules'
make[1]: *** [shared-build-recursive] Error 1
make[1]: Leaving directory `/root/Apache_Package/httpd-2.4.23'
make: *** [all-recursive] Error 1


Please help.

 [Account verified by Apache] thumbs  73 days ago      Rating: 0 (register an account in order to rate comments)

This is not a Q&A section. Please use either the mailinglist users@httpd.apache.org or our IRC channel #httpd at irc.freenode.net for support.

Dani Grosu  143 days ago      Rating: 0 (register an account in order to rate comments)

Is "./configure --with-ssl=/etc/ssl" specifying that Apache will use the installed OpenSSL on the system?

Hosney Osman  756 days ago      Rating: 0 (register an account in order to rate comments)

Dear All
when i am trying to install apapche http 2.2 every thing working fine
when i trying to install apache http 2.4 there is 3 error comming
lnot found apr and apr-util and pcre
is there any recommended steps to solve this issues

 [Account verified by Apache] thumbs  755 days ago      Rating: 0 (register an account in order to rate comments)

If you're compiling from source, it'll try to find the system apr and apr-util, so you'll need to have those installed separately ahead of time.

Fabio Yamada  131 days ago      Rating: 0 (register an account in order to rate comments)

Please note that compilation with pcre2 don't work. One must choose older and discontinued version of pcre (like pcre-8.37) for compiling apache2 (tested using version 2.4.20).

gmb  60 days ago      Rating: 0 (register an account in order to rate comments)

Thanks for mentioning - this helped. Just wondering why the main  documentation above would not mention this info about PCRE version. I see i see a lot of people encountering this issue and posting Question for help. Though there is indication to use pcre-config and not pcre2-config - which is clear enough now, it would help a lot of newbies like myself (who by default, fall for the latest and greatest sometimes) to get this right the first time. Any thoughts Apache/httpd people ?

Anonymous  759 days ago      Rating: 0 (register an account in order to rate comments)

"make install" insists installing configuration files under /etc folder. Is there a way to change this?

Anonymous  759 days ago      Rating: 0 (register an account in order to rate comments)

I used --prefix=/app/product to configure apache

Anonymous  424 days ago      Rating: 0 (register an account in order to rate comments)

The best way to determine install layouts is to use the --enable-layout=ID option to configure and patch the config.layout file the way you want it.

Rodney  956 days ago      Rating: 0 (register an account in order to rate comments)

The "Install" section states "This step will typically require root privileges, since PREFIX is usually a directory with restricted write permissions."


It'd be useful if another sentence was added indicating that file ownership and permissions should also be verified or secured as desired.

If I do the build ("make") as a non-privileged user and then do the install ("sudo make install") then this results in files installed into PREFIX as the non-privileged user when I may want only root (or some service account) to own them.

I suggest the following:

After install ensure that the desired security settings are applied to the directory and files.  One possibility is "chown -R root:root PREFIX" and "chmod -R o-w PREFIX"

Nejc Vukovic  762 days ago      Rating: 0 (register an account in order to rate comments)

Just to add to this: In Mac OS X there is no root group therefore use "chown -R root:admin PREFIX"





## 使用 Apache 控制命令检查模块是否已经启用或加载
常见的 Apache 模块有：

    mod_ssl – 提供了 HTTPS 功能。
    mod_rewrite – 可以用正则表达式匹配 url 样式，并且使用 .htaccess 技巧来进行透明转发，或者提供 HTTP 状态码回应。
    mod_security – 用于保护 Apache 免于暴力破解或者 DDoS 攻击。
    mod_status - 用于监测 Apache 的负载及页面统计。

在 Linux 中 apachectl 或者 apache2ctl用于控制 Apache 服务器，是 Apache 的前端。

你可以用下面的命令显示 apache2ctl 的使用信息：

    $ apache2ctl help
    或者
    $ apachectl help
    
    Usage: /usr/sbin/httpd [-D name] [-d directory] [-f file]
                           [-C "directive"] [-c "directive"]
                           [-k start|restart|graceful|graceful-stop|stop]
                           [-v] [-V] [-h] [-l] [-L] [-t] [-S]
    Options:
      -D name            : define a name for use in  directives
      -d directory       : specify an alternate initial ServerRoot
      -f file            : specify an alternate ServerConfigFile
      -C "directive"     : process directive before reading config files
      -c "directive"     : process directive after reading config files
      -e level           : show startup errors of level (see LogLevel)
      -E file            : log startup errors to file
      -v                 : show version number
      -V                 : show compile settings
      -h                 : list available command line options (this page)
      -l                 : list compiled in modules
      -L                 : list available configuration directives
      -t -D DUMP_VHOSTS  : show parsed settings (currently only vhost settings)
      -S                 : a synonym for -t -D DUMP_VHOSTS
      -t -D DUMP_MODULES : show all loaded modules
      -M                 : a synonym for -t -D DUMP_MODULES
      -t                 : run syntax check for config files

apache2ctl 可以工作在两种模式下，SysV init 模式和直通模式。在 SysV init 模式下，apache2ctl 用如下的简单的单命令形式：

    $ apachectl command
    或者
    $ apache2ctl command

比如要启动并检查它的状态，运行这两个命令。如果你是普通用户，使用 sudo 命令来以 root 用户权限来运行：

    $ sudo apache2ctl start
    $ sudo apache2ctl status
    
    tecmint@TecMint ~ $ sudo apache2ctl start
    AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1\. Set the 'ServerName' directive globally to suppress this message
    httpd (pid 1456) already running
    tecmint@TecMint ~ $ sudo apache2ctl status
    Apache Server Status for localhost (via 127.0.0.1)
    Server Version: Apache/2.4.18 (Ubuntu)
    Server MPM: prefork
    Server Built: 2016-07-14T12:32:26
    -------------------------------------------------------------------------------
    Current Time: Tuesday, 15-Nov-2016 11:47:28 IST
    Restart Time: Tuesday, 15-Nov-2016 10:21:46 IST
    Parent Server Config. Generation: 2
    Parent Server MPM Generation: 1
    Server uptime: 1 hour 25 minutes 41 seconds
    Server load: 0.97 0.94 0.77
    Total accesses: 2 - Total Traffic: 3 kB
    CPU Usage: u0 s0 cu0 cs0
    .000389 requests/sec - 0 B/second - 1536 B/request
    1 requests currently being processed, 4 idle workers
    __W__...........................................................
    ................................................................
    ......................
    Scoreboard Key:
    "_" Waiting for Connection, "S" Starting up, "R" Reading Request,
    "W" Sending Reply, "K" Keepalive (read), "D" DNS Lookup,
    "C" Closing connection, "L" Logging, "G" Gracefully finishing,
    "I" Idle cleanup of worker, "." Open slot with no current process

当在直通模式下，apache2ctl 可以用下面的语法带上所有 Apache 的参数：

    $ apachectl [apache-argument]
    $ apache2ctl [apache-argument]

可以用下面的命令列出所有的 Apache 参数：

    $ apache2 help    [在基于Debian的系统中]
    $ httpd help      [在RHEL的系统中]

检查启用的 Apache 模块

因此，为了检测你的 Apache 服务器启动了哪些模块，在你的发行版中运行适当的命令，-t -D DUMP_MODULES 是一个用于显示所有启用的模块的 Apache 参数：

    ---------------  在基于 Debian 的系统中 ---------------
    $ apache2ctl -t -D DUMP_MODULES   
    或者
    $ apache2ctl -M
    
    ---------------  在 RHEL 的系统中 ---------------
    $ apachectl -t -D DUMP_MODULES   
    或者
    $ httpd -M
    $ apache2ctl -M
    
    [root@tecmint httpd]# apachectl -M
    Loaded Modules:
     core_module (static)
     mpm_prefork_module (static)
     http_module (static)
     so_module (static)
     auth_basic_module (shared)
     auth_digest_module (shared)
     authn_file_module (shared)
     authn_alias_module (shared)
     authn_anon_module (shared)
     authn_dbm_module (shared)
     authn_default_module (shared)
     authz_host_module (shared)
     authz_user_module (shared)
     authz_owner_module (shared)
     authz_groupfile_module (shared)
     authz_dbm_module (shared)
     authz_default_module (shared)
     ldap_module (shared)
     authnz_ldap_module (shared)
     include_module (shared)
    ....

## 代理(Proxy)

代理分为：正向代理(Foward Proxy)和反向代理(Reverse Proxy)

 

**1、正向代理(Foward Proxy)**

 

正向代理(Foward  Proxy)用于代理内部网络对Internet的连接请求，客户机必须指定代理服务器,并将本来要直接发送到Web服务器上的http请求发送到代理服务器，由代理服务器负责请求Internet，然后返回Internet的请求给内网的客户端。

 

Internal Network Client ——(request-url)——> Foward Proxy Server ———— > Internet

 

**2、反向代理(Reverse Proxy)**

 

反向代理（Reverse Proxy）方式是指以代理服务器来接受internet上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给internet上请求连接的客户端，此时代理服务器对外就表现为一个服务器。如图：

 

​							                                        	/————> Internal Server1

Internet ————> Reverse Proxy Server  ————> Internal Server2

​								                                        \————> internal serverN

 

Apache 代理

 

apache支持正向代理和反向代理，但一般反向代理使用较多。

 

 

```
#正向代理

# 正向代理开关
ProxyRequests On
ProxyVia On

<Proxy *>
Order deny,allow
Deny from all
Allow from internal.example.com
</Proxy>
```

 

 

```
# Reverse Proxy

# 设置反向代理
ProxyPass /foo http://foo.example.com/bar
# 设置反向代理使用代理服务的HOST重写内部原始服务器响应报文头中的Location和Content-Location
ProxyPassReverse /foo http://foo.example.com/bar
```

   注意：ProxyPassReverse 指令不是设置反向代理指令，只是设置反向代理重新重定向（3xx）Header头参数值。

 

举例：

 

下面是典型的APACHE+TOMCAT负载均衡和简单集群配置

 

```
    ProxyRequests Off  
    ProxyPreserveHost on 
    
    ProxyPass / balancer://cluster/ stickysession=jsessionid nofailover=Off
    ProxyPassReverse / balancer://cluster/  
    <Proxy balancer://cluster>  
      BalancerMember  http://localhost:8080 loadfactor=1 retry=10  
      BalancerMember  http://localhost:8081 loadfactor=1 retry=10  
      ProxySet lbmethod=bybusyness  
    </Proxy>
```

 

​    ProxyPassReverse / balancer://cluster/  表示负载均衡配置中的所有TOMCAT服务器，如果响应报文的Header中有Location(3xx指定重定向的URL)或Content-Location(指定多个URL指向同一个实体)，则使用请求报文中HOST替换URL中的HOST部分。

 

 

1. GET http://apache-host/entityRelativeUrl
2. tomcat response 307 ,Header Location: http://localhost:8080/entityRelativeUrl
3. apache 重写 response header中的Location为：http://apache-host:8080/entityRelativeUrl

 

注意：只有TOMCAT RESPINSE Location中的URL的Host部分匹配tomcat原始HOST的情况才重写。如307到http://localhost:8088/entityRelativeUrl是不会重写的。



**正向代理**

​        正向代理主要是将内网的访问请求通过代理服务器转发访问并返回结果。通常客户端无法直接访问外部的web,需要在客户端所在的网络内架设一台代理服务器,客户端通过代理服务器访问外部的web，需要在客户端的浏览器中设置代理服务器。一般由两个使用场景；

​        **场景1**：局域网的代理服务器；

​        **场景2**：访问某个受限网络的代理服务器，如访问某些国外网站。正向代理的原理图如下：

[![wKiom1nQvJvyOiRHAABfLbaNIhQ441.png](https://www.linuxidc.com/upload/2017_10/171009080745026.png)](https://www.linuxidc.com/upload/2017_10/171009080745026.png)

**反向代理**

​         客户端能访问外部的web,但是不能访问某些局域网中的web站点，此时我们需要目标网络中的一台主机做反向代理服务器来充当我们的访问目标，将局域网内部的web等站点资源缓存到代理服务器上，,客户端直接访问代理就像访问目标web一样(此代理对客户端透明,即客户端不用做如何设置,并不知道实际访问的只是代理而已,以为就是访问的目标)一般使用场景是：

​        **场景1**：idc的某台目标机器只对内开放web,外部的客户端要访问,就让另一台机器做proxy,外部直接访问proxy即相当于访问目标；

​        **场景2**：idc的目标机器的某个特殊的web服务工作在非正常端口如8080,而防火墙上只对外开放了80,此时可在80上做proxy映射到8080,外部访问80即相当于8080。方向代理的原理图如下：

[![wKioL1nQvGOC7pJoAABlKiLmEks752.png](https://www.linuxidc.com/upload/2017_10/171009080745027.png)](https://www.linuxidc.com/upload/2017_10/171009080745027.png)

 

### ProxyPass与ProxyPassServer

​         apache中的mod_proxy模块主要作用就是进行url的转发，即具有代理的功能。应用此功能，可以很方便的实现同tomcat等应用服务器的整合，甚者可以很方便的实现web集群的功能。

**1 ProxyPass**

​    语法：

```bash
ProxyPass [path] !|url
```

​    说明：它主要是用作URL前缀匹配，不能有正则表达式，它里面配置的Path实际上是一个虚拟的路径，在反向代理到后端的url后，path是不会带过去的，使用示例：

```bash
ProxyPass /images/  	!
#这个示例表示，/images/的请求不被转发。
ProxyPass /mirror/foo/  http://backend.example.com/
#假设当前的服务地址是http://example.com/，做下面这样的请求：http://example.com/mirror/foo/bar将被转成内部请求：http://backend.example.com/bar
#配置的时候，不需要被转发的请求，要配置在需要被转发的请求前面。
```

**2 ProxyPassMatch**

​    语法：

```bash
ProxyPassMatch [regex] !|url
```

​    说明：这个实际上是url正则匹配，而不是简单的前缀匹配，匹配上的regex部分是会带到后端的url的，这个是与ProxyPass不同的。使用示例：

```bash
ProxyPassMatch ^/images !   
#这个示例表示对/images的请求，都不会被转发。
ProxyPassMatch ^(/.*.gif) http://www.linuxidc.com
#表示对所有gif图片的请求，都被会转到后端，如此时请求 http://example.com/foo/bar.gif，那内部将会转换为这样的请求http://www.linuxidc.com/admin/bar.gif。
```

**3 ProxyPassReverse**

​    语法：

```bash
ProxyPassReverse [路径] url
```

​    说明：它一般和ProxyPass指令配合使用，此指令使Apache调整HTTP重定向应答中Location,  Content-Location,  URI头里的URL，这样可以避免在Apache作为反向代理使用时，后端服务器的HTTP重定向造成的绕过反向代理的问题。参看下面的例子：

```bash
ProxyPass        /Hadoop http://www.linuxidc.com/
ProxyPassReverse /hadoop http://www.linuxidc.com/
```

**实验环境搭建**

​        ProxyPass 很好理解，就是把所有来自客户端对http://www.linuxidc.com的请求转发给http://172.18.234.54上进行处理。ProxyPassReverse 的配置总是和ProxyPass 一致，但用途很让人费解。似乎去掉它很能很好的工作，事实真的是这样么，其实不然，如果响应中有重定向，ProxyPassReverse就派上用场。

​        ProxyPassReverse 工作原理：假设用户访问http://www.linuxidc.com/index.html.txt，通过转发交给http://172.18.234.54/index.html.txt处理，假定index.html.txt处理的结果是实现redirect到inde2.txt(使用相对路径,即省略了域名信息)，如果没有配置反向代理，客户端收到的请求响应是重定向操作，并且重定向目的url为http://172.18.234.54/inde2.txt  ，而这个地址只是代理服务器能访问到的，可想而知，客户端肯定是打不开的，反之如果配置了反向代理，则会在转交HTTP重定向应答到客户端之前调整它为 http://www.linuxidc.com/inde2.txt，即是在原请求之后追加上了redirect的路径。当客户端再次请求http: //www.linuxidc.com/inde2.txt，代理服务器再次工作把其转发到http://172.18.234.54/inde2.txt。客户端到服务器称之为正向代理，那服务器到客户端就叫反向代理。

​     1）配置代理服务器

​        代理服务器主要是实现对客户端的访问进行转发，去web服务器上替客户端访问资源。

[![wKioL1nQzLCAUc8qAAAla_v-hLc227.png](https://www.linuxidc.com/upload/2017_10/171009080745028.png)](https://www.linuxidc.com/upload/2017_10/171009080745028.png)

​    2）配置web服务器

​        在web服务器上配置虚拟主机并设置redirect参数，由于ProxyPassServer只有在出现302转发是才能体现出它与ProxyPass不同。为了模拟局域网环境，我们使用防火墙策略禁用客户端的访问。

[![wKioL1nQzMPz1lOVAABhR4Uj0Lo014.png](https://www.linuxidc.com/upload/2017_10/171009080745022.png)](https://www.linuxidc.com/upload/2017_10/171009080745022.png)

 

**结果分析**

------

​        上面搭建好了代理服务器，接下来配合是elinks与tcpdump以及wireshark我们来做实验分析（这里主要是验证ProxyPassServer的作用，ProxyPass原理简单，这里不做实验证明）。

**测试1**：我们不开启ProxyPassServer选项，只使用ProxyPass选项。如下图

```
[root@linuxidc ~]``#cat  /etc/httpd/conf.d/test.conf 
<VirtualHost *:80> 
    ``ProxyPass ``"/"` `"http://172.18.254.54/"
    ``#ProxyPassReverse "/" "     # 注释掉  
<``/VirtualHost``>
```

​    在客户端上使用elinks访问代理服务器。

```
[root@linuxidc ~]``#elinks http://172.18.250.234/index.html.txt
```

由于没有ProxyPassServer选项，所以我们访问资源失败，出现下图提示。

[![wKiom1nQ7uqyaKkHAAAVO6nZvk0199.png](https://www.linuxidc.com/upload/2017_10/171009080745024.png)](https://www.linuxidc.com/upload/2017_10/171009080745024.png)

**测试2**：开启ProxyPassServer选项，我么先在Agent上开启tcpdump进行抓包

```
[root@linuxidc ~]``# tcpdump tcp -i ens33 -w ./target.cap     # -w 表示将结果存储起来，方便wireshark进行分析
```

​    在客户端上使用elinks进行访问，为了验证ProxyPassServer的功能我们访问两次。由于使用了ProxyPassServer功能，所以我们能看到重定向的文件内容。

[![wKioL1nQ1ZOQTArTAAATeGu0wIU763.png](https://www.linuxidc.com/upload/2017_10/171009080745023.png)](https://www.linuxidc.com/upload/2017_10/171009080745023.png)

​    然后我们分析一下抓到的数据包。

[![wKiom1nQ1cXRMUIBAABKtqoQUgc867.png](https://www.linuxidc.com/upload/2017_10/171009080745025.png)](https://www.linuxidc.com/upload/2017_10/171009080745025.png)

​    从上面的数据包信息可知当我们第一次访问index.html.txt时，由于index.html.txt重定向到了inde2.html，所以代理服务器在返回结果是，不是返回给客户端一个重定向后的资源(http://172.18.254.54/inde2.html)，这个资源对客户端是不能访问的，此时ProxyPassServer的作用就起作用了，代理服务器在返回该资源时，直接又去访问了重定向之后的资源，然后在返回给客户端数据。也验证了上文中提到的ProxyPassServer的工作原理。

**本篇总结**

------

​        记得第一次看到这个两个参数的时候，也是一脸茫然，经过简单的实验发现，有没有ProxyPassServer参数都能访问成功，后来查找了许多资料，发现如果出现重定向（301、302）资源的情况下（目前我只发现这种时候会有区别，是不是唯一，我不敢说），客户端在去访问资源便不可以。于是亲手实验，发现果然如此，当添加ProxyPassServer参数后，访问重定向资源也能顺利访问了。由于实验需要很多的测试，一会儿在这台机器，一会儿在另外一台主机上，文章中为了能让大家能够很好的理解，有些小细节就省略了。实验步骤太多，所以绞尽脑汁也没有完美的描述出实验过程，望读者见谅。







# Apache Web 服务器多站点设置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache-web)

Rocky Linux 提供了许多方法来设置网络站点。Apache 只是在单台服务器上进行多站点设置的其中一种方法。尽管 Apache 是为多站点服务器设计的，但 Apache 也可以用于配置单站点服务器。 

历史事实：这个服务器设置方法似乎源自 Debian 系发行版，但它完全适合于任何运行 Apache 的 Linux 操作系统。

## 准备工作[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_1)

- 一台运行 Rocky Linux 的服务器

- 了解命令行和文本编辑器（本示例使用 

  vi

  ，但您可以选择任意您喜欢的编辑器）

  - 如果您想了解 vi 文本编辑器，[此处有一个简单教程](https://www.tutorialspoint.com/unix/unix-vi-editor.html)。

- 有关安装和运行 Web 服务的基本知识

## 安装 Apache[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache)

站点可能需要其他软件包。例如，几乎肯定需要 PHP，也可能需要一个数据库或其他包。从 Rocky Linux 仓库获取 PHP 与 httpd 的最新版本并安装。

有时可能还需要额外安装 php-bcmath 或 php-mysqlind 等模块，Web 应用程序规范应该会详细说明所需的模块。接下来安装 httpd 和 PHP：

- 从命令行运行 `dnf install httpd php`

## 添加额外目录[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_2)

本方法使用了两个额外目录，它们在当前系统上并不存在。在 */etc/httpd/* 中添加两个目录（sites-available 和 sites-enabled）。

- 从命令行处输入 `mkdir /etc/httpd/sites-available` 和 `mkdir /etc/httpd/sites-enabled`
- 还需要一个目录用来存放站点文件。它可以放在任何位置，但为了使目录井然有序，最好是创建一个名为 sub-domains 的目录。为简单起见，请将其放在 /var/www 中：`mkdir /var/www/sub-domains/`

## 配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_3)

还需要在 httpd.conf 文件的末尾添加一行。为此，输入 `vi /etc/httpd/conf/httpd.conf` 并跳转到文件末尾，然后添加 `Include /etc/httpd/sites-enabled`。

实际配置文件位于 */etc/httpd/sites-available*，需在 */etc/httpd/sites-enabled* 中为它们创建符号链接。

**为什么要这么做？**

原因很简单。假设运行在同一服务器上的 10 个站点有不同的 IP 地址。站点 B 有一些重大更新，且必须更改该站点的配置。如果所做的更改有问题，当重新启动 httpd 以读取新更改时，httpd 将不会启动。

不仅 B 站点不会启动，其他站点也不会启动。使用此方法，您只需移除导致故障的站点的符号链接，然后重新启动 httpd 即可。它将重新开始工作，您可以开始工作，尝试修复损坏的站点配置。

### 站点配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_4)

此方法的另一个好处是，它允许完全指定默认 httpd.conf 文件之外的所有内容。让默认的 httpd.conf 文件加载默认设置，并让站点配置执行其他所有操作。很好，对吧？再说一次，它使得排除损坏的站点配置故障变得非常容易。

现在，假设有一个 Wiki 站点，您需要一个配置文件，以通过 80 端口访问。如果站点使用 SSL（现在站点几乎都使用 SSL）提供服务，那么需要在同一文件中添加另一（几乎相同的）项，以便启用 443 端口。

因此，首先需要在 *sites-available* 中创建此配置文件：`vi /etc/httpd/sites-available/com.wiki.www`

配置文件的配置内容如下所示：

```
<VirtualHost *:80>
        ServerName www.wiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.wiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.wiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.wiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.wiki.www-error_log"

        <Directory /var/www/sub-domains/com.wiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

创建文件后，需要写入（保存）该文件：`shift : wq`

在上面的示例中，wiki 站点是从 com.wiki.www 的 html 子目录加载的，这意味着需要在上面提到的 /var/www 中创建额外的目录才能满足要求：

```
mkdir -p /var/www/sub-domains/com.wiki.www/html
```

这将使用单个命令创建整个路径。接下来将文件安装到该目录中，该目录将实际运行该站点。这些文件可能是由您或您下载的应用程序（在本例中为 Wiki）创建的。将文件复制到上面的路径：

```
cp -Rf wiki_source/* /var/www/sub-domains/com.wiki.www/html/
```

## 配置 https —— 使用 SSL 证书[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https-ssl)

如前所述，如今创建的每台 web 服务器都应该使用 SSL（也称为安全套接字层）运行。

此过程首先生成私钥和 CSR（表示证书签名请求），然后将 CSR 提交给证书颁发机构以购买 SSL 证书。生成这些密钥的过程有些复杂，因此它有自己的文档。

如果您不熟悉生成 SSL 密钥，请查看：[生成 SSL 密钥](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/)

### 密钥和证书的位置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_5)

现在您已经拥有了密钥和证书文件，此时需要将它们按逻辑放置在 Web 服务器上的文件系统中。正如在上面示例配置文件中所看到的，将 Web 文件放置在 */var/www/sub-domains/com.ourownwiki.www/html* 中。

我们建议您将证书和密钥文件放在域（domain）中，而不是放在文档根（document root）目录中（在本例中是 *html* 文件夹）。

如果不这样做，证书和密钥有可能暴露在网络上。那会很糟糕！

我们建议的做法是，将在文档根目录之外为 SSL 文件创建新目录：

```
mkdir -p /var/www/sub-domains/com.ourownwiki.www/ssl/{ssl.key,ssl.crt,ssl.csr}
```

如果您不熟悉创建目录的“树（tree）”语法，那么上面所讲的是：

创建一个名为 ssl 的目录，然后在其中创建三个目录，分别为 ssl.key、ssl.crt 和 ssl.csr。

提前提醒一下：对于 web 服务器的功能来说，CSR 文件不必存储在树中。

如果您需要从其他供应商重新颁发证书，则最好保存 CSR 文件的副本。问题变成了在何处存储它以便您记住，将其存储在 web 站点的树中是合乎逻辑的。

假设已使用站点名称来命名 key、csr 和 crt（证书）文件，并且已将它们存储在  */root* 中，那么将它们复制到刚才创建的相应位置：

```
cp /root/com.wiki.www.key /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/
cp /root/com.wiki.www.csr /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.csr/
cp /root/com.wiki.www.crt /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/
```

### 站点配置 —— https[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https)

一旦生成密钥并购买了 SSL 证书，现在就可以使用新密钥继续配置 web 站点。

首先，分析配置文件的开头。例如，即使仍希望监听 80 端口（标准 http）上的传入请求，但也不希望这些请求中的任何一个真正到达 80 端口。

希望请求转到 443 端口（或安全的 http，著名的 SSL）。80 端口的配置部分将变得最少：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
```

这意味着要将任何常规 Web 请求发送到 https 配置。上面显示的 apache  “Redirect”选项可以在所有测试完成后更改为“Redirect  permanent”，此时站点应该就会按照您希望的方式运行。此处选择的“Redirect”是临时重定向。

搜索引擎将记住永久重定向，很快，从搜索引擎到您网站的所有流量都只会流向 443 端口（https），而无需先访问 80 端口（http）。

接下来，定义配置文件的 https 部分。为了清楚起见，此处重复了 http 部分，以表明这一切都发生在同一配置文件中：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
<Virtual Host *:443>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.ourownwiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.ourownwiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.ourownwiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.ourownwiki.www-error_log"

        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1
        SSLHonorCipherOrder on
        SSLCipherSuite EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384
:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

        SSLCertificateFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/com.wiki.www.crt
        SSLCertificateKeyFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/com.wiki.www.key
        SSLCertificateChainFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/your_providers_intermediate_certificate.crt

        <Directory /var/www/sub-domains/com.ourownwiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

因此，在配置的常规部分之后，直到 SSL 部分结束，进一步分析此配置：

- SSLEngine on —— 表示使用 SSL。
- SSLProtocol all -SSLv2 -SSLv3 -TLSv1 —— 表示使用所有可用协议，但发现有漏洞的协议除外。您应该定期研究当前可接受的协议。
- SSLHonorCipherOrder on —— 这与下一行的相关密码套件一起使用，并表示按照给出的顺序对其进行处理。您应该定期检查要包含的密码套件。
- SSLCertificateFile —— 新购买和应用的证书文件及其位置。
- SSLCertificateKeyFile —— 创建证书签名请求时生成的密钥。
- SSLCertificateChainFile —— 来自证书提供商的证书，通常称为中间证书。

接下来，将所有内容全部上线，如果启动 Web 服务没有任何错误，并且如果转到您的网站显示没有错误的 https，那么您就可以开始使用。

## 生效[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_6)

注意，*httpd.conf* 文件在其末尾包含 */etc/httpd/sites-enabled*，因此，httpd 重新启动时，它将加载该 *sites-enabled* 目录中的所有配置文件。事实上，所有的配置文件都位于 *sites-available*。

这是设计使然，以便在 httpd 重新启动失败的情况下，可以轻松移除内容。因此，要启用配置文件，需要在 *sites-enabled* 中创建指向配置文件的符号链接，然后启动或重新启动 Web 服务。为此，使用以下命令：

```
ln -s /etc/httpd/sites-available/com.wiki.www /etc/httpd/sites-enabled/
```

这将在 *sites-enabled* 中创建指向配置文件的链接。

现在只需使用 `systemctl start httpd` 来启动 httpd。如果它已经在运行，则重新启动：`systemctl restart httpd`。假设网络服务重新启动，您现在可以在新站点上进行一些测试。



# `mod_ssl` on Rocky Linux in an httpd Apache Web-Server Environment[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#mod_ssl-on-rocky-linux-in-an-httpd-apache-web-server-environment)

Apache Web-Server has been used for many years now; `mod_ssl`is used to provide greater security for the Web-Server and can be  installed on almost any version of Linux, including Rocky Linux. The  installation of `mod_ssl` will be part of the creation of a Lamp-Server for Rocky Linux.

This procedure is designed to get you up and running with Rocky Linux using `mod_ssl` in an Apache Web-Server environment..

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#prerequisites)

- A Workstation or Server, preferably with Rocky Linux already installed.
- You should be in the Root environment or type `sudo` before all of the commands you enter.

## Install Rocky Linux Minimal[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#install-rocky-linux-minimal)

When installing Rocky Linux, we used the following sets of packages:

- Minimal
- Standard

## Run System Update[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#run-system-update)

First, run the system update command to let the server rebuild the  repository cache, so that it could recognize the packages available.

```
dnf update
```

## Enabling Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#enabling-repositories)

With a conventional Rocky Linux Server Installation all necessary Repositories should be in place.

## Check The Available Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#check-the-available-repositories)

Just to be sure check your Repository Listing with:

```
dnf repolist
```

You should get the following back showing all of the enabled repositories:

```
appstream                                                        Rocky Linux 8 - AppStream
baseos                                                           Rocky Linux 8 - BaseOS
extras                                                           Rocky Linux 8 - Extras
powertools                                                       Rocky Linux 8 - PowerTools
```

## Installing Packages[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#installing-packages)

To install `mod_ssl`, run:

```
dnf install mod_ssl
```

To enable the `mod_ssl` module, run:

```
apachectl restart httpd` `apachectl -M | grep ssl
```

You should see an output as such:

```
ssl_module (shared)
```

## Open TCP port 443[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#open-tcp-port-443)

To allow incoming traffic with HTTPS, run:

```
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

At this point you should be able to access the Apache Web-Server via HTTPS. Enter `https://your-server-ip` or `https://your-server-hostname` to confirm the `mod_ssl` configuration.

## Generate SSL Certificate[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#generate-ssl-certificate)

To generate a new self-signed certificate for Host rocky8 with 365 days expiry, run:

```
openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/httpd.key -x509 -days 365 -out /etc/pki/tls/certs/httpd.crt
```

You will see the following output:



```
Generating a RSA private key
................+++++
..........+++++
writing new private key to '/etc/pki/tls/private/httpd.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:AU
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:LinuxConfig.org
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:rocky8
Email Address []:
```

After this command completes execution, the following two SSL files will be created, run:



```
ls -l /etc/pki/tls/private/httpd.key /etc/pki/tls/certs/httpd.crt

-rw-r--r--. 1 root root 1269 Jan 29 16:05 /etc/pki/tls/certs/httpd.crt
-rw-------. 1 root root 1704 Jan 29 16:05 /etc/pki/tls/private/httpd.key
```

## Configure Apache Web-Server with New SSL Certificates[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#configure-apache-web-server-with-new-ssl-certificates)

To include your newly created SSL certificate into the Apache web-server configuration open the ssl.conf file by running:

```
nano /etc/httpd/conf.d/ssl.conf
```

Then change the following lines:

FROM:

```
SSLCertificateFile /etc/pki/tls/certs/localhost.crt
SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
```

TO:

```
SSLCertificateFile /etc/pki/tls/certs/httpd.crt
SSLCertificateKeyFile /etc/pki/tls/private/httpd.key
```



Then reload the Apache Web-Server by running:

```
systemctl reload httpd
```

## Test the `mod_ssl` configuration[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#test-the-mod_ssl-configuration)

Enter the following in a web browser:

```
https://your-server-ip` or `https://your-server-hostname
```

## To Redirect All HTTP Traffic To HTTPS[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#to-redirect-all-http-traffic-to-https)

Create a new file by running:

```
nano /etc/httpd/conf.d/redirect_http.conf
```

Insert the following content and save file, replacing "your-server-hostname" with your hostname.

```
<VirtualHost _default_:80>

        Servername rocky8
        Redirect permanent / https://your-server-hostname/

</VirtualHost/>
```

Apply the change when reloading the Apache service by running:

```
systemctl reload httpd
```

The Apache Web-Server will now be configured to  redirect any incoming traffic from `http://your-server-hostname` to `https://your-server-hostname` URL.

## Final Steps[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#final-steps)

We have seen how to install and configure `mod_ssl`. And, create a new SSL Certificate in order to run a Web-Server under HTTPS Service.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#conclusion)

This tutorial will be part of the tutorial covering installing a LAMP (Linux, Apache Web-Server, Maria Database-Server, and PHP Scripting  Language), Server on Rocky Linux version 8.x. Eventually we will be  including images to help better understand the installation.





# Apache Hardened Webserver[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#apache-hardened-webserver)

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#prerequisites-and-assumptions)

- A Rocky Linux web server running Apache
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- A comfort level with a command line editor (our examples use *vi* which will usually invoke the *vim* editor, but you can substitute your favorite editor)
- Assumes an *iptables* firewall, rather than *firewalld* or a hardware firewall.
- Assumes the use of a gateway hardware firewall that our trusted devices will sit behind.
- Assumes a public IP address directly applied to the web server. We  are substituting a private IP address for all of our examples.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#introduction)

Whether you are hosting multiple websites for customers, or a single, very important, website for your business, hardening your web server  will give you peace of mind, at the expense of a little more up-front  work for the administrator.

With multiple web sites uploaded by your customers, you can pretty  much be guaranteed that one of them will upload a Content Management  System (CMS) with the possibility of vulnerabilities. Most customers are focused on ease of use, not security, and what happens is that updating their own CMS becomes a process that falls out of their priority list  altogether.

While notifying customers of vulnerabilities in their CMS may be  possible for a company with a large IT staff, it may not be possible for a small department. The best defense is a hardened web server.

Web server hardening can take many forms, which may include any or all of the below tools, and possibly others not defined here.

You might elect to use a couple of these tools, and not the others,  so for clarity and readability this document is split out into separate  documents for each tool. The exception will be the packet-based firewall (*iptables*) which will be included in this main document.

- A good packet filter firewall based on ports (iptables, firewalld, or hardware firewall - we will use *iptables* for our example) [*iptables* procedure](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#iptablesstart)
- A Host-based Intrusion Detection System (HIDS), in this case *ossec-hids* [Apache Hardened Web Server - ossec-hids](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/)
- A Web-based Application Firewall (WAF), with *mod_security* rules [Apache Hardened Web Server - mod_security](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/)
- Rootkit Hunter (rkhunter): A scan tool that checks against Linux malware [Apache Hardened Web Server - rkhunter](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/)
- Database security (we are using *mariadb-server* here) [MariaDB Database Server](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/)
- A secure FTP or SFTP server (we are using *vsftpd* here) [Secure FTP Server - vsftpd](https://docs.rockylinux.org/zh/guides/file_sharing/secure_ftp_server_vsftpd/)

This procedure does not replace the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/), it simply adds these security elements to it. If you haven't read it, take some time to look at it before proceeding.

## Other Considerations[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#other-considerations)

Some of the tools outlined here have both free and fee-based options. Depending on your needs or support requirements, you may want to  consider the fee-based versions. You should research what is out there  and make a decision after weighing all of your options.

Know, too, that most of these options can be purchased as hardware  appliances. If you'd prefer not to hassle with installing and  maintaining your own system, there are options available other than  those outlined here.

This document uses a straight *iptables* firewall and requires [this procedure on Rocky Linux to disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/).

If you prefer to use *firewalld*, simply skip this step and  apply the rules needed. The firewall in our examples here, needs no  OUTPUT or FORWARD chains, only INPUT. Your needs may differ!

All of these tools need to be tuned to your system. That can only be  done with careful monitoring of logs, and reported web experience by  your customers. In addition, you will find that there will be ongoing  tuning required over time.

Even though we are using a private IP address to simulate a public one, all of this *could* have been done using a one-to-one NAT on the hardware firewall and  connecting the web server to that hardware firewall, rather than to the  gateway router, with a private IP address.

Explaining that requires digging into the hardware firewall shown  below, and since that is outside of the scope of this document, it is  better to stick with our example of a simulated public IP address.

## Conventions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conventions)

- **IP Addresses:** We are simulating the public IP  address here with a private block: 192.168.1.0/24 and we are using the  LAN IP address block as 10.0.0.0/24  In other words, it cannot be routed over the Internet. In reality, neither IP block can be routed over the  Internet as they are both reserved for private use, but there is no good way to simulate the public IP block, without using a real IP address  that is assigned to some company. Just remember that for our purposes,  the 192.168.1.0/24 block is the "public" IP block and the 10.0.0.0/24 is the "private" IP block.
- **Hardware Firewall:** This is the firewall that controls access to your server room devices from your trusted network. This is not the same as our *iptables* firewall, though it could be another instance of *iptables* running on another machine. This device will allow ICMP (ping) and SSH  (secure shell) to our trusted devices. Defining this device is outside  of the scope of this document. The author has used both [PfSense](https://www.pfsense.org/) and [OPNSense](https://opnsense.org/) and installed on dedicated hardware for this device with great success. This device will have two IP addresses assigned to it. One that will  connect to the Internet router's simulated public IP (192.168.1.2) and  one that will connect to our local area network, 10.0.0.1.
- **Internet Router IP:** We are simulating this with 192.168.1.1/24
- **Web Server IP:** This is the "public" IP address  assigned to our web server. Again, we are simulating this with the  private IP address 192.168.1.10/24

![Hardened Webserver](https://docs.rockylinux.org/guides/web/apache_hardened_webserver/images/hardened_webserver_figure1.jpeg)

The diagram above shows our general layout. The *iptables* packet-based firewall runs on the web server (shown above).

## Install Packages[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#install-packages)

Each individual package section has the needed installation files and any configuration procedure listed. The installation instructions for *iptables* is part of the [disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/) procedure.

## Configuring iptables[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#configuring-iptables)

This portion of the documentation assumes that you have elected to install the *iptables* services and utilities and that you are not planning on using *firewalld*.

If you are planning on using *firewalld*, you can use this *iptables* script to guide you in creating the appropriate rules in the *firewalld* format. Once the script is shown here, we will break it down to  describe what is happening. Only the INPUT chain is needed here. The  script is being placed in the /etc/ directory and for our example, it is named firewall.conf:

```
vi /etc/firewall.conf
```

and the contents will be:



```
#!/bin/sh
#
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m tcp -s 192.168.1.2 --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -s 192.168.1.2 -j ACCEPT
# dns rules
iptables -A INPUT -p udp -m udp -s 8.8.8.8 --sport 53 -d 0/0 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 8.8.4.4 --sport 53 -d 0/0 -j ACCEPT
# web ports
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# ftp ports
iptables -A INPUT -p tcp -m tcp --dport 20-21 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 7000-7500 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

So here's what is happening above:



- When we start, we flush all of the rules
- We then set the default policy for our INPUT chain to DROP, which  says, "Hey, if we haven't explicitly allowed you here, then we are  dropping you!"
- Then we allow SSH (port 22) from our trusted network, the devices behind the hardware firewall
- We allow DNS from some public DNS resolvers. (these can also be local DNS servers, if you have them)
- We allow our web traffic in from anywhere over port 80 and 443.
- We allow standard FTP (ports 20-21) and the passive ports needed to  exchange two-way communications in FTP (7000-7500). These ports can be  arbitrarily changed to other ports based on your ftp server  configuration.
- We allow any traffic on the local interface (127.0.0.1)
- Then we say, that any traffic that has successfully connected based  on the rules, should be allowed other traffic (ports) to maintain their  connection (ESTABLISHED,RELATED).
- And finally, we reject all other traffic and set the script to save the rules where *iptables* expects to find them.

Once this script is there, we need to make it executable:

```
chmod +x /etc/firewall.conf
```

We need to enable *iptables* if we haven't already:

```
systemctl enable iptables
```

We need to start *iptables*:

```
systemctl start iptables
```

We need to run /etc/firewall.conf:

```
/etc/firewall.conf
```

If we add new rules to the /etc/firewall.conf, just run it again to  take those rules live. Keep in mind that with a default DROP policy for  the INPUT chain, if you make a mistake, you could lock yourself out  remotely.

You can always fix this however, from the console on the server. Because the *iptables* service is enabled, a reboot will restore all rules that have been added with `/etc/firewall.conf`.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conclusion)

There are a number of ways to harden an Apache web server to make it  more secure. Each operates independently of the other options, so you  can choose to install any, or all, of them based on your needs.

Each requires some configuration with various tuning required for  some to meet your specific needs. Since web services are constantly  under attack 24/7 by unscrupulous actors, implementing at least some of  these will help an administrator sleep at night.



# Apache Hardened Webserver[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#apache-hardened-webserver)

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#prerequisites-and-assumptions)

- A Rocky Linux web server running Apache
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- A comfort level with a command line editor (our examples use *vi* which will usually invoke the *vim* editor, but you can substitute your favorite editor)
- Assumes an *iptables* firewall, rather than *firewalld* or a hardware firewall.
- Assumes the use of a gateway hardware firewall that our trusted devices will sit behind.
- Assumes a public IP address directly applied to the web server. We  are substituting a private IP address for all of our examples.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#introduction)

Whether you are hosting multiple websites for customers, or a single, very important, website for your business, hardening your web server  will give you peace of mind, at the expense of a little more up-front  work for the administrator.

With multiple web sites uploaded by your customers, you can pretty  much be guaranteed that one of them will upload a Content Management  System (CMS) with the possibility of vulnerabilities. Most customers are focused on ease of use, not security, and what happens is that updating their own CMS becomes a process that falls out of their priority list  altogether.

While notifying customers of vulnerabilities in their CMS may be  possible for a company with a large IT staff, it may not be possible for a small department. The best defense is a hardened web server.

Web server hardening can take many forms, which may include any or all of the below tools, and possibly others not defined here.

You might elect to use a couple of these tools, and not the others,  so for clarity and readability this document is split out into separate  documents for each tool. The exception will be the packet-based firewall (*iptables*) which will be included in this main document.

- A good packet filter firewall based on ports (iptables, firewalld, or hardware firewall - we will use *iptables* for our example) [*iptables* procedure](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#iptablesstart)
- A Host-based Intrusion Detection System (HIDS), in this case *ossec-hids* [Apache Hardened Web Server - ossec-hids](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/)
- A Web-based Application Firewall (WAF), with *mod_security* rules [Apache Hardened Web Server - mod_security](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/)
- Rootkit Hunter (rkhunter): A scan tool that checks against Linux malware [Apache Hardened Web Server - rkhunter](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/)
- Database security (we are using *mariadb-server* here) [MariaDB Database Server](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/)
- A secure FTP or SFTP server (we are using *vsftpd* here) [Secure FTP Server - vsftpd](https://docs.rockylinux.org/zh/guides/file_sharing/secure_ftp_server_vsftpd/) but we also have *sftp* and SSH lock down procedures [here](https://docs.rockylinux.org/zh/guides/file_sharing/sftp/)

This procedure does not replace the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/), it simply adds these security elements to it. If you haven't read it, take some time to look at it before proceeding.

## Other Considerations[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#other-considerations)

Some of the tools outlined here have both free and fee-based options. Depending on your needs or support requirements, you may want to  consider the fee-based versions. You should research what is out there  and make a decision after weighing all of your options.

Know, too, that most of these options can be purchased as hardware  appliances. If you'd prefer not to hassle with installing and  maintaining your own system, there are options available other than  those outlined here.

This document uses a straight *iptables* firewall and requires [this procedure on Rocky Linux to disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/). Since this document was first written, we now have a couple of excellent *firewalld* guides; one that allows someone with knowledge of *iptables* to transfer what they know to *firewalld* [here](https://docs.rockylinux.org/zh/guides/security/firewalld/), and one that is a more dedicated to beginners [here](https://docs.rockylinux.org/zh/guides/security/firewalld-beginners/).

If you prefer to use *firewalld*, simply skip this step and  apply the rules needed. The firewall in our examples here, needs no  OUTPUT or FORWARD chains, only INPUT. Your needs may differ!

All of these tools need to be tuned to your system. That can only be  done with careful monitoring of logs, and reported web experience by  your customers. In addition, you will find that there will be ongoing  tuning required over time.

Even though we are using a private IP address to simulate a public one, all of this *could* have been done using a one-to-one NAT on the hardware firewall and  connecting the web server to that hardware firewall, rather than to the  gateway router, with a private IP address.

Explaining that requires digging into the hardware firewall shown  below, and since that is outside of the scope of this document, it is  better to stick with our example of a simulated public IP address.

## Conventions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conventions)

- **IP Addresses:** We are simulating the public IP  address here with a private block: 192.168.1.0/24 and we are using the  LAN IP address block as 10.0.0.0/24  In other words, it cannot be routed over the Internet. In reality, neither IP block can be routed over the  Internet as they are both reserved for private use, but there is no good way to simulate the public IP block, without using a real IP address  that is assigned to some company. Just remember that for our purposes,  the 192.168.1.0/24 block is the "public" IP block and the 10.0.0.0/24 is the "private" IP block.
- **Hardware Firewall:** This is the firewall that controls access to your server room devices from your trusted network. This is not the same as our *iptables* firewall, though it could be another instance of *iptables* running on another machine. This device will allow ICMP (ping) and SSH  (secure shell) to our trusted devices. Defining this device is outside  of the scope of this document. The author has used both [PfSense](https://www.pfsense.org/) and [OPNSense](https://opnsense.org/) and installed on dedicated hardware for this device with great success. This device will have two IP addresses assigned to it. One that will  connect to the Internet router's simulated public IP (192.168.1.2) and  one that will connect to our local area network, 10.0.0.1.
- **Internet Router IP:** We are simulating this with 192.168.1.1/24
- **Web Server IP:** This is the "public" IP address  assigned to our web server. Again, we are simulating this with the  private IP address 192.168.1.10/24

![Hardened Webserver](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/images/hardened_webserver_figure1.jpeg)

The diagram above shows our general layout. The *iptables* packet-based firewall runs on the web server (shown above).

## Install Packages[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#install-packages)

Each individual package section has the needed installation files and any configuration procedure listed. The installation instructions for *iptables* is part of the [disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/) procedure.

## Configuring iptables[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#configuring-iptables)

This portion of the documentation assumes that you have elected to install the *iptables* services and utilities and that you are not planning on using *firewalld*.

If you are planning on using *firewalld*, you can use this *iptables* script to guide you in creating the appropriate rules in the *firewalld* format. Once the script is shown here, we will break it down to  describe what is happening. Only the INPUT chain is needed here. The  script is being placed in the /etc/ directory and for our example, it is named firewall.conf:

```
vi /etc/firewall.conf
```

and the contents will be:



```
#!/bin/sh
#
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m tcp -s 192.168.1.2 --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -s 192.168.1.2 -j ACCEPT
# dns rules
iptables -A INPUT -p udp -m udp -s 8.8.8.8 --sport 53 -d 0/0 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 8.8.4.4 --sport 53 -d 0/0 -j ACCEPT
# web ports
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# ftp ports
iptables -A INPUT -p tcp -m tcp --dport 20-21 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 7000-7500 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

So here's what is happening above:



- When we start, we flush all of the rules
- We then set the default policy for our INPUT chain to DROP, which  says, "Hey, if we haven't explicitly allowed you here, then we are  dropping you!"
- Then we allow SSH (port 22) from our trusted network, the devices behind the hardware firewall
- We allow DNS from some public DNS resolvers. (these can also be local DNS servers, if you have them)
- We allow our web traffic in from anywhere over port 80 and 443.
- We allow standard FTP (ports 20-21) and the passive ports needed to  exchange two-way communications in FTP (7000-7500). These ports can be  arbitrarily changed to other ports based on your ftp server  configuration.
- We allow any traffic on the local interface (127.0.0.1)
- Then we say, that any traffic that has successfully connected based  on the rules, should be allowed other traffic (ports) to maintain their  connection (ESTABLISHED,RELATED).
- And finally, we reject all other traffic and set the script to save the rules where *iptables* expects to find them.

Once this script is there, we need to make it executable:

```
chmod +x /etc/firewall.conf
```

We need to enable *iptables* if we haven't already:

```
systemctl enable iptables
```

We need to start *iptables*:

```
systemctl start iptables
```

We need to run /etc/firewall.conf:

```
/etc/firewall.conf
```

If we add new rules to the /etc/firewall.conf, just run it again to  take those rules live. Keep in mind that with a default DROP policy for  the INPUT chain, if you make a mistake, you could lock yourself out  remotely.

You can always fix this however, from the console on the server. Because the *iptables* service is enabled, a reboot will restore all rules that have been added with `/etc/firewall.conf`.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conclusion)

There are a number of ways to harden an Apache web server to make it  more secure. Each operates independently of the other options, so you  can choose to install any, or all, of them based on your needs.

Each requires some configuration with various tuning required for  some to meet your specific needs. Since web services are constantly  under attack 24/7 by unscrupulous actors, implementing at least some of  these will help an administrator sleep at night.

# Web-based Application Firewall (WAF)[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#web-based-application-firewall-waf)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#prerequisites)

- A Rocky Linux Web Server running Apache.
- Proficiency with a command-line editor (we are using *vi* in this example).
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties.
- An understanding that installing this tool also requires monitoring of actions and tuning to your environment.
- An account on Comodo's WAF site.
- All commands are run as the root user or sudo.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#introduction)

*mod_security* is an open-source web-based application  firewall (WAF). It is just one possible component of a hardened Apache  web server setup and can be used with, or without, other tools.

If you'd like to use this along with other tools for hardening, refer back to the [Apache Hardened Web Server guide](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/). This document also uses all of the assumptions and conventions outlined in that original document, so it is a good idea to review it before  continuing.

One thing that is missing with *mod_security* when installed  from the generic Rocky Linux repositories, is that the rules installed  are minimal at best. To get a more extensive package of free  mod_security rules, we are using [Comodo's](https://www.comodo.com/) WAF installation procedure after installing the base package.

Note that Comodo is a business that sells lots of tools to help secure networks. The free *mod_security* tools may not be free forever and they do require that you setup a login with Comodo in order to gain access to the rules.

## Installing mod_security[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#installing-mod_security)

To install the base package, use this command which will install any missing dependencies. We also need *wget* so if you haven't installed it, do that as well:

```
dnf install mod_security wget
```

## Setting Up Your Comodo account[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#setting-up-your-comodo-account)

To setup your free account, go to [Comodo's WAF site](https://waf.comodo.com/), and click the "Signup" link at the top of the page. You will be  required to setup username and password information, but no credit-card  or other billing will be done.

The credentials that you use for signing on to the web site will be  used in your setup of Comodo's software and also to obtain the rules, so you will need to keep these safe in a password manager somewhere.

Please note that the "Terms and Conditions" section of the form that  you need to fill out to use Comodo Web Application Firewall (CWAF) is  written to cover all of their products and services. That said, you  should read this carefully before agreeing to the terms!

## Installing CWAF[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#installing-cwaf)

Before you start, in order for the script to actually run after we  download it, you are going to need some development tools. Install the  package with:

```
dnf group install 'Development Tools'
```

In addition, you will need to have your web server running for Comodo to see *mod_security* correctly. So, start it if it is not already running:

```
systemctl start httpd
```

After signing up with Comodo, you will get an email with instructions on what to do next. Essentially, what you need to do is to login to the web site with your new credentials and then download the client install script.

From the root directory of your server, use the wget command to download the installer:

```
wget https://waf.comodo.com/cpanel/cwaf_client_install.sh
```

Run the installer by typing:

```
bash cwaf_client_install.sh
```

This will extract the installer and start the process, echoing to the screen. You'll get a message part way down:

```
No web host management panel found, continue in 'standalone' mode? [y/n]:
```

Type "y" and let the script continue.

You may also get this notice:

```
Some required perl modules are missed. Install them? This can take a while. [y/n]:
```

If so type "y" and allow those missing modules to install.

```
Enter CWAF login: username@domain.com
Enter password for 'username@domain.com' (will not be shown): *************************
Confirm password for 'username@domain.com' (will not be shown): ************************
```

Please note here that you will probably have to download the rules  and install them in the correct location, as the password field requires a punctuation or special character, but the configuration file  apparently has issues with this when sending it to Comodo's site from  the installer or update script.

These scripts will always fail with a credentials error. This  probably doesn't affect administrators who have web servers running with a GUI front end (Cpanel / Plesk) but if you are running the program  standalone as we are in our example, it does. [You can find the workaround below](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#cwaf_fix).

```
Enter absolute CWAF installation path prefix (/cwaf will be appended): /usr/local
Install into '/usr/local/cwaf' ? [y/n]:
```

Just accept the path as given and then type "y" in the next field for the install path.

If you have a non-standard path to the configuration file for  Apache/nginx, you would enter it here, otherwise just hit 'Enter' for no changes:

```
If you have non-standard Apache/nginx config path enter it here:
```

Here is where the failure comes in, and the only workaround is to  manually download and install the rules. Answer the prompts as shown  below:

```
Do you want to use HTTP GUI to manage CWAF rules? [y/n]: n
Do you want to protect your server with default rule set? [y/n]: y
```

But expect to get the next message as well:

```
 Warning! Rules have not been updated. Check your credentials and try again later manually
+------------------------------------------------------
| LOG : Warning! Rules have not been updated. Check your credentials and try again later manually
+------------------------------------------------------
| Installation complete!
| Please add the line:
|   Include "/usr/local/cwaf/etc/modsec2_standalone.conf"
| to Apache config file.
| To update ModSecurity ruleset run
|   /usr/local/cwaf/scripts/updater.pl
| Restart Apache after that.
| You may find useful utility /usr/local/cwaf/scripts/cwaf-cli.pl
| Also you may examine file
|   /usr/local/cwaf/INFO.TXT
| for some useful software information.
+------------------------------------------------------
| LOG : All Done!
| LOG : Exiting
```

That's a little frustrating. You can go to your account on the Comodo web site and change your password and re-run the install script, BUT it won't change anything. The credentials will still fail.

###  CWAF Rules File Workaround[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#cwaf-rules-file-workaround)

To fix this, we need to manually install the rules from the web site. This is done by logging into your account on https://waf.comodo.com and clicking on the the "Download Full Rule Set" link. You'll then need to  copy the rules to your web server using scp'

Example:

```
scp cwaf_rules-1.233.tgz root@mywebserversdomainname.com:/root/
```

Once the tar gzip file has been copied over, move the file to the rules directory:

```
mv /root/cwaf_rules-1.233.tgz /usr/local/cwaf/rules/
```

Then navigate to the rules directory:

```
cd /usr/local/cwaf/rules/
```

And uncompress the rules:

```
tar xzvf cwaf_rules-1.233.tgz
```

Any partial updates to the rules will have to be handled in the same way.

This is where paying for rules and support can come in handy. It all depends on your budget.

### Configuring CWAF[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#configuring-cwaf)

When we installed *mod_security*, the default configuration file was installed in `/etc/httpd/conf.d/mod_security.conf`. The next thing we need to do is to modify this in two places. Start by editing the file:

```
vi /etc/httpd/conf.d/mod_security.conf
```

At the very top of the file, you will see:

```
<IfModule mod_security2.c>
    # Default recommended configuration
    SecRuleEngine On
```

Beneath the `SecRuleEngine On` line add `SecStatusEngine On` so that the top of the file will now look like this:

```
<IfModule mod_security2.c>
    # Default recommended configuration
    SecRuleEngine On
    SecStatusEngine On
```

Next go to the bottom of this configuration file. We need to tell *mod_security* where to load the rules. You should see this at the bottom of the file before you make changes:

```
    # ModSecurity Core Rules Set and Local configuration
    IncludeOptional modsecurity.d/*.conf
    IncludeOptional modsecurity.d/activated_rules/*.conf
    IncludeOptional modsecurity.d/local_rules/*.conf
</IfModule>
```

We need to add in one line at the bottom to add the CWAF configuration, which in turn loads the CWAF rules. That line is `Include "/usr/local/cwaf/etc/cwaf.conf"`. The bottom of this file should look like this when you are done:

```
    # ModSecurity Core Rules Set and Local configuration
    IncludeOptional modsecurity.d/*.conf
    IncludeOptional modsecurity.d/activated_rules/*.conf
    IncludeOptional modsecurity.d/local_rules/*.conf
    Include "/usr/local/cwaf/etc/cwaf.conf"
</IfModule>
```

Now save your changes (with vi it's `SHIFT+:+wq!`) and restart httpd:

```
systemctl restart httpd
```

If httpd starts OK, then you are ready to start using *mod_security* with the CWAF.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/#conclusion)

*mod_security* with CWAF is another tool that can be used to  help harden an Apache web server. Because CWAF's passwords require  punctuation and because the standalone installation does not send that  punctuation correctly, managing CWAF rules requires logging into the  CWAF site and downloading rules and changes.

*mod_security*, like other hardening tools, has the potential  of false-positive responses, so you must be prepared to tune this tool  to your installation.

Like other solutions mentioned in the [Apache Hardened Web Server guide](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/), there are other free and fee-based solutions for *mod_security* rules, and for that matter, other WAF applications available. You can take a look at one of these at [Atomicorp's *mod_security* site](https://atomicorp.com/atomic-modsecurity-rules/).

------

# Host-based Intrusion Detection System (HIDS)[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#host-based-intrusion-detection-system-hids)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#prerequisites)

- Proficiency with a command-line text editor (we are using *vi* in this example)
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- An understanding that installing this tool also requires monitoring of actions and tuning to your environment
- All commands are run as the root user or using sudo

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#introduction)

*ossec-hids* is a host intrusion detection system that offers  automatic action-response steps to help mitigate host intrusion attacks. It is just one possible component of a hardened Apache web server setup and can be used with or without other tools.

If you'd like to use this along with other tools for hardening, refer back to the [Apache Hardened Web Server](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/) document. This document also uses all of the assumptions and  conventions outlined in that original document, so it is a good idea to  review it before continuing.

## Installing Atomicorp's Repository[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#installing-atomicorps-repository)

To install *ossec-hids*, we need a third-party repository from Atomicorp. Atomicorp also offers a reasonably priced fee-based  supported version for those who would like professional support if they  run into trouble.

If you'd prefer support, and have the budget for it, check out [Atomicorp's paid *ossec-hids*](https://atomicorp.com/atomic-enterprise-ossec/) version. Since we are going to need just a few packages from  Atomicorp's free repository, we are going to modify the repository after we have it downloaded.

Downloading the repository requires *wget* so install that first if you don't have it. Install the EPEL repository as well if you do not have it installed already, with:

```
dnf install wget epel-release
```

Now download and enable Atomicorp's free repository:

```
wget -q -O - http://www.atomicorp.com/installers/atomic | sh
```

This script will ask you to agree to the terms. Either type "yes" or hit 'Enter' to accept "yes" as the default.

Next, it will ask you if you want to enable the repository by default, and again we want to accept the default or type "yes".

### Configuring The Atomicorp Repository[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#configuring-the-atomicorp-repository)

We only need the atomic repository for a couple of packages. For this reason, we are going to modify the repository and specify only those  packages be chosen:

```
vi /etc/yum.repos.d/atomic.repo
```

And then add this line beneath the "enabled = 1" in the top section:

```
includepkgs = ossec* inotify-tools
```

That's the only change we need, so save your changes and get out of the repository, (in vi that would be esc to enter command mode, then `: wq` to save and quit).

This restricts the Atomicorp repository to only install and update these packages.

## Installing ossec-hids[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#installing-ossec-hids)

Now that we have the repository downloaded and configured, we need to install the packages:

```
dnf install ossec-hids-server ossec-hids inotify-tools
```

### Configuring ossec-hids[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#configuring-ossec-hids)

There are a number of changes that need to be made to the *ossec-hids* configuration file. Most of these have to do with server administrator notification and log locations.

*ossec-hids* looks at the logs to try and determine if there  is an attack, and whether to apply mitigation. It also sends reports to  the server administrator, either just as a notification, or that a  mitigation procedure has been activated based on what *ossec-hids* has seen.

To edit the configuration file type:

```
vi /var/ossec/etc/ossec.conf
```

We will break apart this configuration showing the changes in line and explaining them as we go:

```
<global>
  <email_notification>yes</email_notification>  
  <email_to>admin1@youremaildomain.com</email_to>
  <email_to>admin2@youremaildomain.com</email_to>
  <smtp_server>localhost</smtp_server>
  <email_from>ossec-webvms@yourwebserverdomain.com.</email_from>
  <email_maxperhour>1</email_maxperhour>
  <white_list>127.0.0.1</white_list>
  <white_list>192.168.1.2</white_list>
</global>
```

By default, email notifications are turned off and the `<global>` configuration is basically empty. You want to turn on email  notification and identify the people who should receive the email  reports by email address.

The `<smtp_server>` section currently shows  localhost, however you can specify an email server relay if you prefer,  or simply setup the postfix email settings for the local host by  following [this guide](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/).

You need to set the "from" address, so that you can deal with SPAM  filters on your email server which may see this email as SPAM. To avoid  getting inundated with email, set the email reporting to 1 per hour. You can expand this or remark out this command if you like while you are  getting started with *ossec-hids* and need to see things quickly.

The `<white_list>` sections deal with the server's  localohost IP and with the "public" address (remember, we are using a  private address to demonstrate this) of the firewall, from which all  connections on the trusted network will show. You can add multiple `<white_list>` entries as needed.

```
<syscheck>
  <!-- Frequency that syscheck is executed -- default every 22 hours -->
  <frequency>86400</frequency>
...
</syscheck>
```

The `<syscheck>` section takes a look at a list of  directories to include and exclude when looking for compromised files.  Think of this as yet another tool for watching and protecting the file  system against vulnerabilities. You should review the list of  directories and see if there are others that you want to add in to the `<syscheck>` section.

The `<rootcheck>` section just beneath the `<syscheck>` section is yet another protection layer. The locations that both `<syscheck>` and `<rootcheck>` watch are editable, but you probably will not need to make any changes to them.  

Changing the `<frequency>` for the `<rootcheck>` run to once every 24 hours (86400 seconds) from the default of 22 hours is an optional change shown above.

```
<localfile>
  <log_format>apache</log_format>
  <location>/var/log/httpd/*access_log</location>
</localfile>
<localfile>
  <log_format>apache</log_format>
  <location>/var/log/httpd/*error_log</location>
</localfile>
```

The `<localfile>` section deals with the locations of the logs we want to watch. There are entries already in place for *syslog* and *secure* logs that you just need to verify the path to, but everything else can be left as is.

We do need to add in the Apache log locations however, and we want to add these in as wild_cards, because we could have a bunch of logs for a lot of different web customers. That format is shown above.

```
  <command>
    <name>firewall-drop</name>
    <executable>firewall-drop.sh</executable>
    <expect>srcip</expect>
  </command>

  <active-response>
    <command>firewall-drop</command>
    <location>local</location>
    <level>7</level>
    <timeout>1200</timeout>
  </active-response>
```

Finally, towards the end of the file we need to add the active response section. This section contains two parts, a `<command>` section, and the `<active-response>` section.

The "firewall-drop" script already exists within the ossec path.  It tells *ossec_hids* that if a level of 7 is reached, add a firewall rule to block the IP  address for 20 minutes. Obviously, you can change the timeout value.  Just remember that the configuration file times are all in seconds.

Once you have made all of the configuration changes you need, simply  enable and start the service. If everything starts correctly, you should be ready to move on:

```
systemctl enable ossec-hids
```

And then:

```
systemctl start ossec-hids
```

There are a lot of options for the *ossec-hids* configuration file. You can find out about these options by visiting the [official documentation site](https://www.ossec.net/docs/).

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/#conclusion)

*ossec-hids* is just one element of an Apache hardened web  server. It can be used with other tools to gain better security for your web site.

While the installation and configuration are relatively straight forward, you will find that this is **not** an 'install it and forget it' application. You will need to tune it to  your environment to gain the most security with the least amount of  false-positive responses.

# Rootkit Hunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#rootkit-hunter)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#prerequisites)

- A Rocky Linux Web Server running Apache
- Proficiency with a command-line editor (we are using *vi* in this example)
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- An understanding of what can trigger a response to changed files on the file system (such as package updates) is helpful
- All commands are run as the root user or sudo

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#introduction)

*rkhunter* (Root Kit Hunter) is a Unix-based tool that scans  for rootkits, backdoors, and possible local exploits. It is a good part  of a hardened web server, and is designed to notify the administrator  quickly when something suspicious happens on the server's file system.

*rkhunter* is just one possible component of a hardened Apache web server setup and can be used with or without other tools. If you'd  like to use this along with other tools for hardening, refer back to the [Apache Hardened Web Server guide](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/).

This document also uses all of the assumptions and conventions  outlined in that original document, so it is a good idea to review it  before continuing.

## Installing rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#installing-rkhunter)

*rkhunter* requires the EPEL (Extra Packages for Enterprise  Linux) repository. So install that repository if you don't have it  installed already:

```
dnf install epel-release
```

Then install *rkhunter*:

```
dnf install rkhunter
```

## Configuring rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#configuring-rkhunter)

The only configuration options that need to be set are those dealing  with mailing reports to the administrator. To modify the configuration  file, run:

```
vi /etc/rkhunter.conf
```

And then search for:

```
#MAIL-ON-WARNING=me@mydomain   root@mydomain
```

Remove the remark here and change the me@mydomain.com to reflect your email address.

Then change the root@mydomain to root@whatever_the_server_name_is.

You may also need to setup [Postfix Email for Reporting](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/) in order to get the email section to work correctly.

## Running rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#running-rkhunter)

*rkhunter* can be run by typing it at the command-line. There is a cron job installed for you in `/etc/cron.daily`, but if you want to automate the procedure on a different schedule, look at the [Automating cron jobs guide](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/).

You'll also need to move the script somewhere other than `/etc/cron.daily`, such as `/usr/local/sbin` and then call it from your custom cron job. The easiest method, of course, is to leave the default cron.daily setup intact.

Before you run allow *rkhunter* to run automatically, run the  command manually with the "--propupd" flag to create the rkhunter.dat  file, and to make sure that your new environment is recognized without  issue:

```
rkhunter --propupd
```

To run *rkhunter* manually:

```
rkhunter --check
```

This will echo back to the screen as the checks are performed, prompting you to `[Press <ENTER> to continue]` after each section.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#conclusion)

*rkhunter* is one part of a hardened server strategy that can  help in monitoring the file system and reporting any issues to the  administrator. It is perhaps one of the easiest hardening tools to  install, configure, and run.

------

# Apache Web 服务器多站点设置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache-web)

Rocky Linux 提供了许多方法来设置网络站点。Apache 只是在单台服务器上进行多站点设置的其中一种方法。尽管 Apache 是为多站点服务器设计的，但 Apache 也可以用于配置单站点服务器。 

历史事实：这个服务器设置方法似乎源自 Debian 系发行版，但它完全适合于任何运行 Apache 的 Linux 操作系统。

## 准备工作[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_1)

- 一台运行 Rocky Linux 的服务器

- 了解命令行和文本编辑器（本示例使用 

  vi

  ，但您可以选择任意您喜欢的编辑器）

  - 如果您想了解 vi 文本编辑器，[此处有一个简单教程](https://www.tutorialspoint.com/unix/unix-vi-editor.html)。

- 有关安装和运行 Web 服务的基本知识

## 安装 Apache[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache)

站点可能需要其他软件包。例如，几乎肯定需要 PHP，也可能需要一个数据库或其他包。从 Rocky Linux 仓库获取 PHP 与 httpd 的最新版本并安装。

有时可能还需要额外安装 php-bcmath 或 php-mysqlind 等模块，Web 应用程序规范应该会详细说明所需的模块。接下来安装 httpd 和 PHP：

- 从命令行运行 `dnf install httpd php`

## 添加额外目录[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_2)

本方法使用了两个额外目录，它们在当前系统上并不存在。在 */etc/httpd/* 中添加两个目录（sites-available 和 sites-enabled）。

- 从命令行处输入 `mkdir /etc/httpd/sites-available` 和 `mkdir /etc/httpd/sites-enabled`
- 还需要一个目录用来存放站点文件。它可以放在任何位置，但为了使目录井然有序，最好是创建一个名为 sub-domains 的目录。为简单起见，请将其放在 /var/www 中：`mkdir /var/www/sub-domains/`

## 配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_3)

还需要在 httpd.conf 文件的末尾添加一行。为此，输入 `vi /etc/httpd/conf/httpd.conf` 并跳转到文件末尾，然后添加 `Include /etc/httpd/sites-enabled`。

实际配置文件位于 */etc/httpd/sites-available*，需在 */etc/httpd/sites-enabled* 中为它们创建符号链接。

**为什么要这么做？**

原因很简单。假设运行在同一服务器上的 10 个站点有不同的 IP 地址。站点 B 有一些重大更新，且必须更改该站点的配置。如果所做的更改有问题，当重新启动 httpd 以读取新更改时，httpd 将不会启动。

不仅 B 站点不会启动，其他站点也不会启动。使用此方法，您只需移除导致故障的站点的符号链接，然后重新启动 httpd 即可。它将重新开始工作，您可以开始工作，尝试修复损坏的站点配置。

### 站点配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_4)

此方法的另一个好处是，它允许完全指定默认 httpd.conf 文件之外的所有内容。让默认的 httpd.conf 文件加载默认设置，并让站点配置执行其他所有操作。很好，对吧？再说一次，它使得排除损坏的站点配置故障变得非常容易。

现在，假设有一个 Wiki 站点，您需要一个配置文件，以通过 80 端口访问。如果站点使用 SSL（现在站点几乎都使用 SSL）提供服务，那么需要在同一文件中添加另一（几乎相同的）项，以便启用 443 端口。

因此，首先需要在 *sites-available* 中创建此配置文件：`vi /etc/httpd/sites-available/com.wiki.www`

配置文件的配置内容如下所示：

```
<VirtualHost *:80>
        ServerName www.wiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.wiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.wiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.wiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.wiki.www-error_log"

        <Directory /var/www/sub-domains/com.wiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

创建文件后，需要写入（保存）该文件：`shift : wq`

在上面的示例中，wiki 站点是从 com.wiki.www 的 html 子目录加载的，这意味着需要在上面提到的 /var/www 中创建额外的目录才能满足要求：

```
mkdir -p /var/www/sub-domains/com.wiki.www/html
```

这将使用单个命令创建整个路径。接下来将文件安装到该目录中，该目录将实际运行该站点。这些文件可能是由您或您下载的应用程序（在本例中为 Wiki）创建的。将文件复制到上面的路径：

```
cp -Rf wiki_source/* /var/www/sub-domains/com.wiki.www/html/
```

## 配置 https —— 使用 SSL 证书[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https-ssl)

如前所述，如今创建的每台 web 服务器都应该使用 SSL（也称为安全套接字层）运行。

此过程首先生成私钥和 CSR（表示证书签名请求），然后将 CSR 提交给证书颁发机构以购买 SSL 证书。生成这些密钥的过程有些复杂，因此它有自己的文档。

如果您不熟悉生成 SSL 密钥，请查看：[生成 SSL 密钥](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/)

### 密钥和证书的位置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_5)

现在您已经拥有了密钥和证书文件，此时需要将它们按逻辑放置在 Web 服务器上的文件系统中。正如在上面示例配置文件中所看到的，将 Web 文件放置在 */var/www/sub-domains/com.ourownwiki.www/html* 中。

我们建议您将证书和密钥文件放在域（domain）中，而不是放在文档根（document root）目录中（在本例中是 *html* 文件夹）。

如果不这样做，证书和密钥有可能暴露在网络上。那会很糟糕！

我们建议的做法是，将在文档根目录之外为 SSL 文件创建新目录：

```
mkdir -p /var/www/sub-domains/com.ourownwiki.www/ssl/{ssl.key,ssl.crt,ssl.csr}
```

如果您不熟悉创建目录的“树（tree）”语法，那么上面所讲的是：

创建一个名为 ssl 的目录，然后在其中创建三个目录，分别为 ssl.key、ssl.crt 和 ssl.csr。

提前提醒一下：对于 web 服务器的功能来说，CSR 文件不必存储在树中。

如果您需要从其他供应商重新颁发证书，则最好保存 CSR 文件的副本。问题变成了在何处存储它以便您记住，将其存储在 web 站点的树中是合乎逻辑的。

假设已使用站点名称来命名 key、csr 和 crt（证书）文件，并且已将它们存储在  */root* 中，那么将它们复制到刚才创建的相应位置：

```
cp /root/com.wiki.www.key /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/
cp /root/com.wiki.www.csr /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.csr/
cp /root/com.wiki.www.crt /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/
```

### 站点配置 —— https[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https)

一旦生成密钥并购买了 SSL 证书，现在就可以使用新密钥继续配置 web 站点。

首先，分析配置文件的开头。例如，即使仍希望监听 80 端口（标准 http）上的传入请求，但也不希望这些请求中的任何一个真正到达 80 端口。

希望请求转到 443 端口（或安全的 http，著名的 SSL）。80 端口的配置部分将变得最少：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
```

这意味着要将任何常规 Web 请求发送到 https 配置。上面显示的 apache  “Redirect”选项可以在所有测试完成后更改为“Redirect  permanent”，此时站点应该就会按照您希望的方式运行。此处选择的“Redirect”是临时重定向。

搜索引擎将记住永久重定向，很快，从搜索引擎到您网站的所有流量都只会流向 443 端口（https），而无需先访问 80 端口（http）。

接下来，定义配置文件的 https 部分。为了清楚起见，此处重复了 http 部分，以表明这一切都发生在同一配置文件中：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
<Virtual Host *:443>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.ourownwiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.ourownwiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.ourownwiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.ourownwiki.www-error_log"

        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1
        SSLHonorCipherOrder on
        SSLCipherSuite EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384
:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

        SSLCertificateFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/com.wiki.www.crt
        SSLCertificateKeyFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/com.wiki.www.key
        SSLCertificateChainFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/your_providers_intermediate_certificate.crt

        <Directory /var/www/sub-domains/com.ourownwiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

因此，在配置的常规部分之后，直到 SSL 部分结束，进一步分析此配置：

- SSLEngine on —— 表示使用 SSL。
- SSLProtocol all -SSLv2 -SSLv3 -TLSv1 —— 表示使用所有可用协议，但发现有漏洞的协议除外。您应该定期研究当前可接受的协议。
- SSLHonorCipherOrder on —— 这与下一行的相关密码套件一起使用，并表示按照给出的顺序对其进行处理。您应该定期检查要包含的密码套件。
- SSLCertificateFile —— 新购买和应用的证书文件及其位置。
- SSLCertificateKeyFile —— 创建证书签名请求时生成的密钥。
- SSLCertificateChainFile —— 来自证书提供商的证书，通常称为中间证书。

接下来，将所有内容全部上线，如果启动 Web 服务没有任何错误，并且如果转到您的网站显示没有错误的 https，那么您就可以开始使用。

## 生效[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_6)

注意，*httpd.conf* 文件在其末尾包含 */etc/httpd/sites-enabled*，因此，httpd 重新启动时，它将加载该 *sites-enabled* 目录中的所有配置文件。事实上，所有的配置文件都位于 *sites-available*。

这是设计使然，以便在 httpd 重新启动失败的情况下，可以轻松移除内容。因此，要启用配置文件，需要在 *sites-enabled* 中创建指向配置文件的符号链接，然后启动或重新启动 Web 服务。为此，使用以下命令：

```
ln -s /etc/httpd/sites-available/com.wiki.www /etc/httpd/sites-enabled/
```

这将在 *sites-enabled* 中创建指向配置文件的链接。

现在只需使用 `systemctl start httpd` 来启动 httpd。如果它已经在运行，则重新启动：`systemctl restart httpd`。假设网络服务重新启动，您现在可以在新站点上进行一些测试。

------

# 'mod_ssl' on Rocky Linux in an httpd Apache Web-Server Environment[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#mod_ssl-on-rocky-linux-in-an-httpd-apache-web-server-environment)

Apache Web-Server has been used for many years now; 'mod_ssl' is used to provide greater security for the Web-Server and can be installed on  almost any version of Linux, including Rocky Linux. The installation of  'mod_ssl' will be part of the creation of a Lamp-Server for Rocky Linux.

This procedure is designed to get you up and running with Rocky Linux using 'mod_ssl' in an Apache Web-Server environment..

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#prerequisites)

- A Workstation or Server, preferably with Rocky Linux already installed.
- You should be in the Root environment or type `sudo` before all of the commands you enter.

## Install Rocky Linux Minimal[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#install-rocky-linux-minimal)

When installing Rocky Linux, we used the following sets of packages:

- Minimal
- Standard

## Run System Update[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#run-system-update)

First, run the system update command to let the server rebuild the  repository cache, so that it could recognize the packages available.

```
dnf update
```

## Enabling Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#enabling-repositories)

With a conventional Rocky Linux Server Installation all necessary Repositories should be in place.

## Check The Available Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#check-the-available-repositories)

Just to be sure check your Repository Listing with:

```
dnf repolist
```

You should get the following back showing all of the enabled repositories:

```
appstream                                                        Rocky Linux 8 - AppStream
baseos                                                           Rocky Linux 8 - BaseOS
extras                                                           Rocky Linux 8 - Extras
powertools                                                       Rocky Linux 8 - PowerTools
```

## Installing Packages[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#installing-packages)

To install 'mod_ssl', run:

```
dnf install mod_ssl
```

To enable the 'mod_ssl' module, run:

```
apachectl restart httpd` `apachectl -M | grep ssl
```

You should see an output as such:

```
ssl_module (shared)
```

## Open TCP port 443[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#open-tcp-port-443)

To allow incoming traffic with HTTPS, run:

```
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

At this point you should be able to access the Apache Web-Server via HTTPS. Enter `https://your-server-ip` or `https://your-server-hostname` to confirm the 'mod_ssl' configuration.

## Generate SSL Certificate[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#generate-ssl-certificate)

To generate a new self-signed certificate for Host rocky8 with 365 days expiry, run:

```
openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/httpd.key -x509 -days 365 -out /etc/pki/tls/certs/httpd.crt
```

You will see the following output:



```
Generating a RSA private key
................+++++
..........+++++
writing new private key to '/etc/pki/tls/private/httpd.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:AU
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:LinuxConfig.org
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:rocky8
Email Address []:
```

After this command completes execution, the following two SSL files will be created, run:



```
ls -l /etc/pki/tls/private/httpd.key /etc/pki/tls/certs/httpd.crt

-rw-r--r--. 1 root root 1269 Jan 29 16:05 /etc/pki/tls/certs/httpd.crt
-rw-------. 1 root root 1704 Jan 29 16:05 /etc/pki/tls/private/httpd.key
```

## Configure Apache Web-Server with New SSL Certificates[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#configure-apache-web-server-with-new-ssl-certificates)

To include your newly created SSL certificate into the Apache web-server configuration open the ssl.conf file by running:

```
nano /etc/httpd/conf.d/ssl.conf
```

Then change the following lines:

FROM:

```
SSLCertificateFile /etc/pki/tls/certs/localhost.crt
SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
```

TO:

```
SSLCertificateFile /etc/pki/tls/certs/httpd.crt
SSLCertificateKeyFile /etc/pki/tls/private/httpd.key
```



Then reload the Apache Web-Server by running:

```
systemctl reload httpd
```

## Test the 'mod_ssl' configuration[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#test-the-mod_ssl-configuration)

Enter the following in a web browser:

```
https://your-server-ip` or `https://your-server-hostname
```

## To Redirect All HTTP Traffic To HTTPS[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#to-redirect-all-http-traffic-to-https)

Create a new file by running:

```
nano /etc/httpd/conf.d/redirect_http.conf
```

Insert the following content and save file, replacing "your-server-hostname" with your hostname.

```
<VirtualHost _default_:80>

        Servername rocky8
        Redirect permanent / https://your-server-hostname/

</VirtualHost/>
```

Apply the change when reloading the Apache service by running:

```
systemctl reload httpd
```

The Apache Web-Server will now be configured to  redirect any incoming traffic from `http://your-server-hostname` to `https://your-server-hostname` URL.

## Final Steps[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#final-steps)

We have seen how to install and configure 'mod_ssl'. And, create a  new SSL Certificate in order to run a Web-Server under HTTPS Service.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#conclusion)

This tutorial will be part of the tutorial covering installing a LAMP (Linux, Apache Web-Server, Maria Database-Server, and PHP Scripting  Language), Server on Rocky Linux version 8.x. Eventually we will be  including images to help better understand the installation.
