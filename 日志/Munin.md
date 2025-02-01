# How to install and configure Munin 如何安装和配置Munin 

The monitoring of essential servers and services is an important part of  system administration. This guide will show you how to set up [Munin](https://munin-monitoring.org/) for performance monitoring.
对基本服务器和服务的监控是系统管理的重要组成部分。本指南将向您展示如何设置Munin进行性能监控。

In this example, we will use two servers with hostnames: **`server01`** and **`server02`**.
在本例中，我们将使用两台服务器，主机名分别为： `server01` 和 `server02` 。

`Server01` will be set up with the `munin` package to gather information from the network. Using the `munin-node` package, `server02` will be configured to send information to `server01`.
 `Server01` 将与 `munin` 软件包一起设置，以从网络收集信息。使用 `munin-node` 包， `server02` 将被配置为向 `server01` 发送信息。

## Prerequisites 先决条件 

Before installing Munin on `server01`, [Apache2 will need to be installed](https://ubuntu.com/server/docs/introduction-to-web-servers). The default configuration is fine for running a `munin` server.
在 `server01` 上安装Munin之前，需要安装Apache2。默认配置适合运行 `munin` 服务器。

## Install `munin` and `munin-node` 安装 `munin` 和 `munin-node` 

First, on `server01` install the `munin` package. In a terminal enter the following command:
首先，在 `server01` 上安装 `munin` 包。在终端中输入以下命令：

```bash
sudo apt install munin
```

Now on `server02`, install the `munin-node` package:
现在在 `server02` 上，安装 `munin-node` 包：

```bash
sudo apt install munin-node
```

## Configure `munin` 配置 `munin` 

On `server01` edit the `/etc/munin/munin.conf` file, adding the IP address for `server02`:
在 `server01` 编辑 `/etc/munin/munin.conf` 文件，添加 `server02` 的IP地址：

```plaintext
## First our "normal" host.
[server02]
       address 172.18.100.101
```

> **Note**: 注意事项：
>  Replace `server02` and `172.18.100.101` with the actual hostname and IP address for your server.
>  将 `server02` 和 `172.18.100.101` 替换为服务器的实际主机名和IP地址。

## Configure `munin-node` 配置 `munin-node` 

Next, configure `munin-node` on `server02`. Edit `/etc/munin/munin-node.conf` to allow access by `server01`:
接下来，在 `server02` 上配置 `munin-node` 。编辑 `/etc/munin/munin-node.conf` 以允许 `server01` 访问：

```plaintext
allow ^172\.18\.100\.100$
```

> **Note**: 注意事项：
>  Replace `^172\.18\.100\.100$` with the IP address for your `munin` server.
>  将 `^172\.18\.100\.100$` 替换为 `munin` 服务器的IP地址。

Now restart `munin-node` on `server02` for the changes to take effect:
现在在 `server02` 上重新启动 `munin-node` ，以使更改生效：

```bash
sudo systemctl restart munin-node.service
```

## Test the setup 测试设立 

In a browser, go to `http://server01/munin`, and you should see links to nice graphs displaying information from the standard **munin-plugins** for disk, network, processes, and system. However, it should be noted  that since this is a new installation, it may take some time for the  graphs to display anything useful.
在浏览器中，转到 `http://server01/munin` ，您应该看到指向漂亮图形的链接，这些图形显示了来自磁盘、网络、进程和系统的标准munin插件的信息。但是，应该注意的是，由于这是一个新的安装，它可能需要一些时间的图形显示任何有用的。

## Additional Plugins 额外的插件 

The `munin-plugins-extra` package contains performance checks and additional services such as  DNS, DHCP, and Samba, etc. To install the package, from a terminal  enter:
 `munin-plugins-extra` 软件包包含性能检查和其他服务，如DNS、DHCP和桑巴舞等。要安装该软件包，请从终端输入：

```bash
sudo apt install munin-plugins-extra
```

Be sure to install the package on both the server and node machines.
请确保在服务器和节点计算机上都安装该软件包。 

## References 引用 

- See the [Munin](https://munin-monitoring.org/) website for more details.
  更多详情请参见Munin网站。
- Specifically the [Munin Documentation](https://munin.readthedocs.io/en/latest/) page includes information on additional plugins, writing plugins, etc.
  具体来说，Munin文档页面包括关于附加插件、编写插件等的信息。

------

# How to use Nagios with Munin 如何在Munin中使用Nagios 

> **Note**: 注意事项：
>  Nagios Core 3 has been deprecated and is now replaced by Nagios Core 4. The `nagios3` package was last supported in Bionic, so subsequent releases should use `nagios4` instead.
>  Nagios Core 3已被弃用，现在被Nagios Core 4取代。Bionic最后一次支持 `nagios3` 包，因此后续版本应使用 `nagios4` 。

The monitoring of essential servers and services is an important part of  system administration. Most network services are monitored for  performance, availability, or both. This section will cover installation and configuration of Nagios 3 for availability monitoring alongside  Munin for performance monitoring.
对基本服务器和服务的监控是系统管理的重要组成部分。大多数网络服务的性能和/或可用性都受到监控。本节将介绍Nagios 3的安装和配置，以进行可用性监控，以及Munin的性能监控。 

The examples in this section will use two servers with hostnames **`server01`** and **`server02`**. `Server01` will be configured with Nagios 3 to monitor services on both itself and `server02`. `Server01` will also be set up with the Munin package to gather information from the network. Using the `munin-node` package, `server02` will be configured to send information to `server01`.
本节中的示例将使用主机名为 `server01` 和 `server02` 的两个服务器。 `Server01` 将配置Nagios 3以监控自身和 `server02` 上的服务。 `Server01` 也将与Munin包一起设置，以从网络收集信息。使用 `munin-node` 包， `server02` 将被配置为向 `server01` 发送信息。

## Install Nagios 3 安装Nagios 3 

### On server01 在server 01上 

First, on `server01`, install the `nagios3` package. In a terminal, enter:
首先，在 `server01` 上，安装 `nagios3` 包。在终端中，输入：

```bash
sudo apt install nagios3 nagios-nrpe-plugin
```

You will be asked to enter a password for the `nagiosadmin` user. The user’s credentials are stored in `/etc/nagios3/htpasswd.users`. To change the `nagiosadmin` password, or add additional users to the Nagios CGI scripts, use the `htpasswd` that is part of the `apache2-utils` package.
系统将要求您输入 `nagiosadmin` 用户的密码。用户的凭据存储在 `/etc/nagios3/htpasswd.users` 中。要更改 `nagiosadmin` 密码，或向Nagios CGI脚本添加其他用户，请使用 `apache2-utils` 包中的 `htpasswd` 。

For example, to change the password for the `nagiosadmin` user enter:
例如，要更改 `nagiosadmin` 用户的密码，请输入：

```bash
sudo htpasswd /etc/nagios3/htpasswd.users nagiosadmin
```

To add a user:
要添加用户，请执行以下操作： 

```bash
sudo htpasswd /etc/nagios3/htpasswd.users steve
```

### On server02 在server02上 

Next, on `server02` install the `nagios-nrpe-server` package. From a terminal on `server02`, enter:
接下来，在 `server02` 上安装 `nagios-nrpe-server` 包。从 `server02` 上的终端，输入：

```bash
sudo apt install nagios-nrpe-server
```

> **Note**: 注意事项：
>  NRPE allows you to run local checks on remote hosts. There are other  ways of accomplishing this, including through other Nagios plugins.
>  NRPE允许您在远程主机上运行本地检查。还有其他方法可以实现这一点，包括通过其他Nagios插件。

### Configuration overview 配置概述 

There are a few directories containing Nagios configuration and check files.
有几个目录包含Nagios配置和检查文件。 

- `/etc/nagios3`: contains configuration files for the operation of the Nagios daemon, CGI files, hosts, etc.
   `/etc/nagios3` ：包含Nagios守护进程、CGI文件、主机等操作的配置文件。

- `/etc/nagios-plugins`: houses configuration files for the service checks.
   `/etc/nagios-plugins` ：存放用于服务检查的配置文件。

- `/etc/nagios`: is located on the remote host and contains the `nagios-nrpe-server` configuration files.
   `/etc/nagios` ：位于远程主机上，包含 `nagios-nrpe-server` 配置文件。

- `/usr/lib/nagios/plugins/`: where the check binaries are stored. To see the options of a check use the `-h` option.
   `/usr/lib/nagios/plugins/` ：校验二进制文件的存储位置。要查看支票的选项，请使用 `-h` 选项。

  For example: `/usr/lib/nagios/plugins/check_dhcp -h` 例如： `/usr/lib/nagios/plugins/check_dhcp -h` 

There are many checks Nagios can be configured to run for any particular  host. In this example, Nagios will be configured to check disk space,  DNS, and a MySQL host group. The DNS check will be on `server02`, and the MySQL host group will include both `server01` and `server02`.
Nagios可以配置为针对任何特定主机运行许多检查。在本例中，Nagios将被配置为检查磁盘空间、DNS和MySQL主机组。DNS检查将在 `server02` 上进行，MySQL主机组将包括 `server01` 和 `server02` 。

> **Note**: 注意事项：
>  See these additional guides for details on setting up [Apache](https://ubuntu.com/server/docs/introduction-to-web-servers), [Domain Name Service (DNS)](https://ubuntu.com/server/docs/domain-name-service-dns), and [MySQL](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
>  有关设置Apache、域名服务（DNS）和MySQL的详细信息，请参阅这些附加指南。

Additionally, there are some terms that once explained will hopefully make understanding Nagios configuration easier:
此外，有一些术语，一旦解释将有望使理解Nagios配置更容易： 

- **Host**: a server, workstation, network device, etc that is being monitored.
  主机：被监控的服务器、工作站、网络设备等。
- **Host group**: a group of similar hosts. For example, you could group all web servers, file servers, etc.
  主机组：一组相似的主机。例如，您可以对所有Web服务器、文件服务器等进行分组。
- **Service**: the service being monitored on the host, such as HTTP, DNS, NFS, etc.
  Service：主机上被监控的服务，如HTTP、DNS、NFS等。
- **Service group**: allows you to group multiple services together. This is useful for grouping, e.g.,  multiple HTTP.
  服务组：允许您将多个服务分组在一起。这对于分组是有用的，例如，多个HTTP
- **Contact**: the person to be notified when an event takes place. Nagios can be configured to send emails, SMS messages, etc.
  联系人：事件发生时应通知的人。Nagios可以配置为发送电子邮件、SMS消息等。

By default Nagios is configured to check HTTP, disk space, SSH, current users, processes, and load on the **localhost**. Nagios will also ping-check the **gateway**.
默认情况下，Nagios被配置为检查HTTP、磁盘空间、SSH、当前用户、进程和本地主机上的负载。Nagios还将ping检查网关。

Large Nagios installations can be quite complex to configure. It is usually  best to start small (i.e. with one or two hosts), get things configured  the way you like, and then expand.
大型Nagios安装的配置可能相当复杂。通常最好从小规模开始（即使用一个或两个主机），按照您喜欢的方式配置，然后扩展。 

## Configure Nagios 配置Nagios 

First, create a **host** configuration file for `server02`. Unless otherwise specified, run all these commands on `server01`. In a terminal enter:
首先，为 `server02` 创建主机配置文件。除非另有说明，否则请在 `server01` 上运行所有这些命令。在终端中输入：

```bash
sudo cp /etc/nagios3/conf.d/localhost_nagios2.cfg \
/etc/nagios3/conf.d/server02.cfg
```

> **Note**: 注意事项：
>  In the above and following command examples, replace “`server01`”, “`server02`”, `172.18.100.100`, and `172.18.100.101` with the host names and IP addresses of your servers.
>  在上面和下面的命令示例中，将" `server01` "、" `server02` "、 `172.18.100.100` 和 `172.18.100.101` 替换为服务器的主机名和IP地址。

Next, edit `/etc/nagios3/conf.d/server02.cfg`: 接下来，编辑 `/etc/nagios3/conf.d/server02.cfg` ：

```plaintext
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
```

Restart the Nagios daemon to enable the new configuration:
重新启动Nagios守护进程以启用新配置： 

```bash
sudo systemctl restart nagio3.service
```

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

A **mysql-servers** host group now needs to be defined. Edit `/etc/nagios3/conf.d/hostgroups_nagios2.cfg` adding:
现在需要定义一个mysql-servers主机组。编辑 `/etc/nagios3/conf.d/hostgroups_nagios2.cfg` 添加：

~~~plaintext
# MySQL hostgroup.
define hostgroup {
        hostgroup_name  mysql-servers
                alias           MySQL servers
                members         localhost, server02
}

The Nagios check needs to authenticate to MySQL. To add a `nagios` user to MySQL, enter:

```bash
mysql -u root -p -e "create user nagios identified by 'secret';"
    
> **Note**:
> The `nagios` user will need to be added all hosts in the `mysql-servers` host group.
    
Restart Nagios to start checking the MySQL servers.

```bash
sudo systemctl restart nagios3.service
~~~

Lastly, configure NRPE to check the disk space on `server02`. On `server01` add the service check to `/etc/nagios3/conf.d/server02.cfg`:
最后，配置NRPE以检查 `server02` 上的磁盘空间。在 `server01` 上，将服务检查添加到 `/etc/nagios3/conf.d/server02.cfg` ：

```plaintext
# NRPE disk check.
define service {
        use                     generic-service
        host_name               server02
        service_description     nrpe-disk
        check_command           check_nrpe_1arg!check_all_disks!172.18.100.101
}
```

Now on `server02` edit `/etc/nagios/nrpe.cfg`, changing:
现在在 `server02` 编辑 `/etc/nagios/nrpe.cfg` ，更改：

```plaintext
allowed_hosts=172.18.100.100
```

And below in the command definition area add:
并在下面的命令定义区域中添加： 

```plaintext
command[check_all_disks]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -e
```

Finally, restart `nagios-nrpe-server`: 最后，重启 `nagios-nrpe-server` ：

```bash
sudo systemctl restart nagios-nrpe-server.service
```

Also, on `server01` restart `nagios3`:
此外，在 `server01` 重新启动 `nagios3` ：

```bash
sudo systemctl restart nagios3.service
```

You should now be able to see the host and service checks in the Nagios CGI files. To access them, point a browser to `http://server01/nagios3`. You will then be prompted for the `nagiosadmin` username and password.
您现在应该能够在Nagios CGI文件中看到主机和服务检查。要访问它们，请将浏览器指向 `http://server01/nagios3` 。系统将提示您输入 `nagiosadmin` 用户名和密码。

## Install Munin 安装Munin 

Before installing Munin on `server01` Apache2 will need to be installed. The default configuration is fine for running a Munin server. For more information see [setting up Apache](https://ubuntu.com/server/docs/introduction-to-web-servers).
在 `server01` Apache2上安装Munin之前，需要先安装。默认配置对于运行Munin服务器是合适的。有关更多信息，请参阅设置Apache。

### On server01 在server 01上 

First, on `server01` install `munin` by running the following command in a terminal:
首先，在 `server01` 上通过在终端中运行以下命令安装 `munin` ：

```bash
sudo apt install munin
```

### On server02 在server02上 

Now on `server02` install the `munin-node` package:
现在在 `server02` 上安装 `munin-node` 包：

```bash
sudo apt install munin-node
```

### Configure Munin on server01 在server01上配置Munin 

On `server01` edit the `/etc/munin/munin.conf` to add the IP address for `server02`:
在 `server01` 上，编辑 `/etc/munin/munin.conf` 以添加 `server02` 的IP地址：

```plaintext
## First our "normal" host.
[server02]
       address 172.18.100.101
```

> **Note**: 注意事项：
>  Replace `server02` and `172.18.100.101` with the actual hostname and IP address of your server.
>  将 `server02` 和 `172.18.100.101` 替换为服务器的实际主机名和IP地址。

### Configure munin-node on server02 在server 02上配置munin-node 

To configure `munin-node` on `server02`, edit `/etc/munin/munin-node.conf` to allow access by `server01`:
要在 `server02` 上配置 `munin-node` ，请编辑 `/etc/munin/munin-node.conf` 以允许 `server01` 访问：

```plaintext
allow ^172\.18\.100\.100$
```

> **Note**: 注意事项：
>  Replace `^172\.18\.100\.100$` with IP address for your Munin server.
>  将 `^172\.18\.100\.100$` 替换为Munin服务器的IP地址。

Now restart `munin-node` on `server02` for the changes to take effect:
现在在 `server02` 上重新启动 `munin-node` ，以使更改生效：

```bash
sudo systemctl restart munin-node.service
```

Finally, in a browser go to `http://server01/munin`, and you should see links to some graphs displaying information from the standard `munin-plugins` for disk, network, processes, and system.
最后，在浏览器中转到 `http://server01/munin` ，您应该会看到一些图表的链接，这些图表显示了标准 `munin-plugins` 中有关磁盘、网络、进程和系统的信息。

> **Note**: 注意事项：
>  Since this is a new install it may take some time for the graphs to display anything useful.
>  由于这是一个新的安装，它可能需要一些时间的图形显示任何有用的东西。

### Additional plugins 额外的插件 

The `munin-plugins-extra` package contains performance checks and additional services such as  DNS, DHCP, Samba, etc. To install the package, from a terminal enter:
 `munin-plugins-extra` 软件包包含性能检查和其他服务，如DNS、DHCP、桑巴舞等。要安装该软件包，请从终端输入：

```bash
sudo apt install munin-plugins-extra
```

Be sure to install the package on both the server and node machines.
请确保在服务器和节点计算机上都安装该软件包。 

## Further reading 进一步阅读 

- See the [Munin](http://munin-monitoring.org/) and [Nagios](https://www.nagios.org/) websites for more details on these packages.
  有关这些软件包的更多详细信息，请参阅Munin和Nagios网站。
- The [Munin Documentation](https://munin.readthedocs.io/en/latest/) page includes information on additional plugins, writing plugins, etc.
  Munin文档页面包含有关附加插件、编写插件等的信息。
- The [Nagios Online Documentation](https://www.nagios.org/documentation/) site.
  Nagios在线文档网站。
- There is also a [list of books](https://www.nagios.org/propaganda/books/) related to Nagios and network monitoring.
  还有一个与Nagios和网络监控相关的书籍列表。
- The [Nagios Ubuntu Wiki](https://help.ubuntu.com/community/Nagios3) page also has more details.
  Nagios Ubuntu Wiki页面也有更多细节。