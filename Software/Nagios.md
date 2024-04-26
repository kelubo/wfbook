# Nagios Core

# How to install and configure Nagios Core 3 如何安装和配置Nagios Core 3 

> **Note**: 注意事项：
>  Nagios Core 3 has been deprecated and is now replaced by Nagios Core 4. The `nagios3` package was last supported in Bionic, so subsequent releases should use `nagios4` instead.
>  Nagios Core 3已被弃用，现在被Nagios Core 4取代。Bionic最后一次支持 `nagios3` 包，因此后续版本应使用 `nagios4` 。

The monitoring of essential servers and services is an important part of  system administration. This guide walks through how to install and  configure Nagios Core 3 for availability monitoring.
对基本服务器和服务的监控是系统管理的重要组成部分。本指南介绍如何安装和配置Nagios Core 3以进行可用性监控。 

The example in this guide uses two servers with hostnames: **`server01`** and **`server02`**.
本指南中的示例使用了两台主机名为 `server01` 和 `server02` 的服务器。

`Server01` will be configured with Nagios to monitor services on itself and on `server02`, while `server02` will be configured to send data to `server01`.
 `Server01` 将配置Nagios以监控自身和 `server02` 上的服务，而 `server02` 将配置为向 `server01` 发送数据。

## Install `nagios3` on `server01` 在 `server01` 上安装 `nagios3` 

First, on `server01`, install the `nagios3` package by entering the following command into your terminal:
首先，在 `server01` 上，通过在终端中输入以下命令安装 `nagios3` 软件包：

```bash
sudo apt install nagios3 nagios-nrpe-plugin
```

You will be asked to enter a password for the **nagiosadmin** user. The user’s credentials are stored in `/etc/nagios3/htpasswd.users`. To change the nagiosadmin password, or add more users to the Nagios CGI scripts, use the `htpasswd` that is part of the `apache2-utils` package.
您将被要求输入密码nagiosadmin用户。用户的凭据存储在 `/etc/nagios3/htpasswd.users` 中。要更改nagiosadmin密码，或向Nagios CGI脚本添加更多用户，请使用 `apache2-utils` 包中的 `htpasswd` 。

For example, to change the password for the nagiosadmin user, enter:
例如，要更改nagiosadmin用户的密码，请输入： 

```bash
sudo htpasswd /etc/nagios3/htpasswd.users nagiosadmin
```

To add a user:
要添加用户，请执行以下操作： 

```bash
sudo htpasswd /etc/nagios3/htpasswd.users steve
```

## Install `nagios-nrpe-server` on `server02` 在 `server02` 上安装 `nagios-nrpe-server` 

Next, on `server02` install the `nagios-nrpe-server` package. From a terminal on `server02` enter:
接下来，在 `server02` 上安装 `nagios-nrpe-server` 包。从 `server02` 上的终端输入：

```bash
sudo apt install nagios-nrpe-server
```

> **Note**: 注意事项：
>  NRPE allows you to execute local checks on remote hosts. There are other ways of accomplishing this through other Nagios plugins, as well as  other checks.
>  NRPE允许您在远程主机上执行本地检查。还有其他方法可以通过其他Nagios插件以及其他检查来实现这一点。

## Configuration overview 配置概述 

There are a couple of directories containing Nagios configuration and check files.
有几个目录包含Nagios配置和检查文件。 

- `/etc/nagios3`: Contains configuration files for the operation of the Nagios daemon, CGI files, hosts, etc.
   `/etc/nagios3` ：包含Nagios守护进程、CGI文件、主机等操作的配置文件。
- `/etc/nagios-plugins`: Contains configuration files for the service checks.
   `/etc/nagios-plugins` ：包含服务检查的配置文件。
- `/etc/nagios`: On the remote host, contains the `nagios-nrpe-server` configuration files.
   `/etc/nagios` ：在远程主机上，包含 `nagios-nrpe-server` 配置文件。
- `/usr/lib/nagios/plugins/`: Where the check binaries are stored. To see the options of a check use the `-h` option. For example: `/usr/lib/nagios/plugins/check_dhcp -h`
   `/usr/lib/nagios/plugins/` ：校验二进制文件存储的位置。要查看支票的选项，请使用 `-h` 选项。例如： `/usr/lib/nagios/plugins/check_dhcp -h` 

There are multiple checks Nagios can be configured to execute for any given  host. For this example, Nagios will be configured to check disk space,  DNS, and a MySQL hostgroup. The DNS check will be on `server02`, and the MySQL hostgroup will include both `server01` and `server02`.
Nagios可以配置为对任何给定的主机执行多个检查。对于本例，Nagios将被配置为检查磁盘空间、DNS和MySQL主机组。DNS检查将在 `server02` 上进行，MySQL主机组将包括 `server01` 和 `server02` 。

> **Note**: 注意事项：
>  See these guides for details on [setting up Apache](https://ubuntu.com/server/docs/introduction-to-web-servers), [Domain Name Service](https://ubuntu.com/server/docs/domain-name-service-dns), and [MySQL](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
>  有关设置Apache、域名服务和MySQL的详细信息，请参阅这些指南。

Additionally, there are some terms that once explained will hopefully make understanding Nagios configuration easier:
此外，有一些术语，一旦解释将有望使理解Nagios配置更容易： 

- *Host*: A server, workstation, network device, etc. that is being monitored.
  主机：被监控的服务器、工作站、网络设备等。
- *Host Group*: A group of similar hosts. For example, you could group all web servers, file server, etc.
  主机组：一组相似的主机。例如，您可以对所有Web服务器、文件服务器等进行分组。
- *Service*: The service being monitored on the host, such as HTTP, DNS, NFS, etc.
  服务：主机上被监控的服务，如HTTP、DNS、NFS等。
- *Service Group*: Allows you to group multiple services together. This is useful for grouping multiple HTTP for example.
  服务组：允许您将多个服务分组在一起。例如，这对于分组多个HTTP很有用。
- *Contact*: Person to be notified when an event takes place. Nagios can be configured to send emails, SMS messages, etc.
  联系人：事件发生时应通知的人。Nagios可以配置为发送电子邮件、SMS消息等。

By default, Nagios is configured to check HTTP, disk space, SSH, current users, processes, and load on the **localhost**. Nagios will also ping check the **gateway**.
默认情况下，Nagios被配置为检查HTTP、磁盘空间、SSH、当前用户、进程和本地主机上的负载。Nagios还将ping检查网关。

Large Nagios installations can be quite complex to configure. It is usually  best to start small, with one or two hosts, to get things configured the way you want before expanding.
大型Nagios安装的配置可能相当复杂。通常，最好从小规模开始，使用一台或两台主机，以便在扩展之前按照您想要的方式进行配置。 

## Configure Nagios 配置Nagios 

### Create host config file for server02 为server02创建主机配置文件 

First, create a **host** configuration file for `server02`. Unless otherwise specified, run all these commands on `server01`. In a terminal enter:
首先，为 `server02` 创建主机配置文件。除非另有说明，否则请在 `server01` 上运行所有这些命令。在终端中输入：

~~~bash
sudo cp /etc/nagios3/conf.d/localhost_nagios2.cfg \
/etc/nagios3/conf.d/server02.cfg
    
> **Note**:
> In all command examples, replace "`server01`", "`server02`", `172.18.100.100`, and `172.18.100.101` with the host names and IP addresses of your servers.

### Edit the host config file    

Next, edit `/etc/nagios3/conf.d/server02.cfg`:
 
```text    
define host{
        use                     generic-host  ; Name of host template to use
        host_name               server02
        alias                   Server 02
        address                 172.18.100.101
}
        
# check DNS service.
define service {
        use                             generic-service
        host_name                       server02
        service_description             DNS
        check_command                   check_dns!172.18.100.101
}
~~~

Restart the Nagios daemon to enable the new configuration:
重新启动Nagios守护进程以启用新配置： 

```bash
sudo systemctl restart nagio3.service
```

### Add service definition 添加服务定义 

Now add a service definition for the MySQL check by adding the following to `/etc/nagios3/conf.d/services_nagios2.cfg`:
现在，通过将以下内容添加到 `/etc/nagios3/conf.d/services_nagios2.cfg` 中，为MySQL检查添加一个服务定义：

```plaintext
# check MySQL servers.
define service {
        hostgroup_name        mysql-servers
        service_description   MySQL
        check_command         check_mysql_cmdlinecred!nagios!secret!$HOSTADDRESS
        use                   generic-service
        notification_interval 0 ; set > 0 if you want to be renotified
}
```

A **mysql-servers** hostgroup now needs to be defined. Edit `/etc/nagios3/conf.d/hostgroups_nagios2.cfg` and add the following:
现在需要定义一个mysql-servers主机组。编辑 `/etc/nagios3/conf.d/hostgroups_nagios2.cfg` 并添加以下内容：

```plaintext
# MySQL hostgroup.
define hostgroup {
        hostgroup_name  mysql-servers
                alias           MySQL servers
                members         localhost, server02
        }
```

The Nagios check needs to authenticate to MySQL. To add a `nagios` user to MySQL enter:
Nagios检查需要对MySQL进行身份验证。要将 `nagios` 用户添加到MySQL，请输入：

```bash
mysql -u root -p -e "create user nagios identified by 'secret';"
```

> **Note**: 注意事项：
>  The `nagios` user will need to be added to all hosts in the **mysql-servers** hostgroup.
>  需要将 `nagios` 用户添加到mysql-servers主机组中的所有主机。

Restart nagios to start checking the MySQL servers.
重新启动nagios以开始检查MySQL服务器。 

sudo systemctl restart nagios3.service

### Configure NRPE 配置NRPE 

Lastly configure NRPE to check the disk space on *server02*.
最后配置NRPE检查server02上的磁盘空间。

On `server01` add the service check to `/etc/nagios3/conf.d/server02.cfg`:
在 `server01` 上，将服务检查添加到 `/etc/nagios3/conf.d/server02.cfg` ：

```plaintext
# NRPE disk check.
define service {
        use                     generic-service
        host_name               server02
        service_description     nrpe-disk
        check_command           check_nrpe_1arg!check_all_disks!172.18.100.101
}
```

Now on `server02` edit `/etc/nagios/nrpe.cfg` changing:
现在在 `server02` 编辑 `/etc/nagios/nrpe.cfg` 更改：

```plaintext
allowed_hosts=172.18.100.100
```

And below, in the command definition area, add:
在下面的命令定义区域中，添加： 

```plaintext
command[check_all_disks]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -e
```

Finally, restart `nagios-nrpe-server`: 最后，重启 `nagios-nrpe-server` ：

```bash
sudo systemctl restart nagios-nrpe-server.service
```

Also, on `server01` restart Nagios:
另外，在 `server01` 上重启Nagios：

```bash
sudo systemctl restart nagios3.service
```

You should now be able to see the host and service checks in the Nagios CGI files. To access them, point a browser to `http://server01/nagios3`. You will then be prompted for the **nagiosadmin** username and password.
您现在应该能够在Nagios CGI文件中看到主机和服务检查。要访问它们，请将浏览器指向 `http://server01/nagios3` 。系统将提示您输入用户名和密码

## Further reading 进一步阅读 

This section has just scratched the surface of Nagios’ features. The `nagios-plugins-extra` and `nagios-snmp-plugins` contain many more service checks.
本节只是触及了Nagios特性的表面。 `nagios-plugins-extra` 和 `nagios-snmp-plugins` 包含更多的服务检查。

- For more information about Nagios, see [the Nagios website](https://www.nagios.org/).
  有关Nagios的更多信息，请参阅Nagios网站。
- The [Nagios Core Documentation](https://library.nagios.com/library/products/nagios-core/documentation/) and [Nagios Core 3 Documentation](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/toc.html) may also be useful.
  Nagios Core文档和Nagios Core 3文档也可能有用。
- They also provide a [list of books](https://www.nagios.org/propaganda/books/) related to Nagios and network monitoring.
  他们还提供了与Nagios和网络监控相关的书籍列表。
- The [Nagios Ubuntu Wiki](https://help.ubuntu.com/community/Nagios3) page also has more details.
  Nagios Ubuntu Wiki页面也有更多细节。





一个自由开源的网络和警报引擎，用于监控各种设备，例如网络设备和网络中的服务器。

![](../Image/n/nagios-platform.png)

### 安装 LAMP

```bash
dnf install httpd mariadb-server php-mysqlnd php-fpm
```

启用并启动 Apache 服务器：

```bash
systemctl start httpd
systemctl enable httpd
```

启用并启动 MariaDB 服务器：

```bash
systemctl start mariadb
systemctl enable mariadb
```

保护服务器，请运行以下命令：

```bash
mysql_secure_installation
```

### 安装必需的软件包：

```bash
dnf install gcc glibc glibc-common wget gd gd-devel perl postfix
```

### 创建 Nagios 用户帐户

为 Nagios 创建一个用户帐户。

```bash
adduser nagios
passwd nagios
```

为 Nagios 创建一个组，并将 Nagios 用户添加到该组中。

```bash
groupadd nagios
```

现在添加 Nagios 用户到组中：

```bash
usermod -aG nagios nagios
```

将 Apache 用户添加到 Nagios 组：

```bash
usermod -aG nagios apache
```

### 下载并安装 Nagios Core

下载 tarball 文件：

```bash
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz
```

解压缩：

```bash
tar -xvf nagios-4.4.5.tar.gz
```

接下来，进入文件夹：

```bash
cd nagios-4.4.5
```

运行以下命令：

```bash
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-daemoninit
make install-config
make install-commandmode
make install-exfoliation
```

要配置 Apache，运行以下命令：

```bash
make install-webconf
```

### 配置 Apache Web 服务器身份验证

为用户 `nagiosadmin` 设置身份验证。

要设置身份验证，请运行以下命令：

```bash
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```

重新启动 Web 服务器：

```bash
systemctl restart httpd
```

### 下载并安装 Nagios 插件

要下载插件的 tarball 文件，请运行以下命令：

```bash
wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
```

解压 tarball 文件并进入到未压缩的插件文件夹：

```bash
tar -xvf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
```

要安装插件，请编译源代码，如下所示：

```bash
./configure --with-nagios-user=nagios
--with-nagios-group=nagios
make
make install
```

### 验证和启动 Nagios

成功安装 Nagios 插件后，验证 Nagios 配置以确保一切良好，并且配置中没有错误：

```bash
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```

启动 Nagios 并验证其状态：

```bash
systemctl start nagios
systemctl status nagios
```

如果系统中有防火墙，那么使用以下命令允许 ”80“ 端口：

```bash
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
```

### 通过 Web 浏览器访问 Nagios 面板

要访问 Nagios，请打开服务器的 IP 地址，如下所示：http://server-ip/nagios 。