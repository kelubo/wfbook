# 如何安装和配置phpMyAdmin

[phpMyAdmin](https://www.phpmyadmin.net/) is a LAMP application specifically written for administering MySQL  servers. Written in PHP, and accessed through a web browser, phpMyAdmin  provides a graphical interface for database administration tasks.
phpMyAdmin 是专门为管理 MySQL 服务器而编写的 LAMP 应用程序。phpMyAdmin 用 PHP 编写，并通过 Web 浏览器访问，为数据库管理任务提供了一个图形界面。

## Prerequisites 先决条件

Before you can install phpMyAdmin, you will need access to a MySQL database –  either on the same host as phpMyAdmin will be installed on, or on a host accessible over the network. For instructions on how to install a MySQL database service, see [our MySQL guide](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
在安装 phpMyAdmin 之前，您需要访问 MySQL 数据库 - 要么在将安装 phpMyAdmin 的同一主机上，要么在可通过网络访问的主机上。有关如何安装 MySQL 数据库服务的说明，请参阅我们的 MySQL 指南。

You will also need a web server. In this guide we use Apache2, although you can use another if you prefer. If you would like instructions on how to install Apache2, see [our Apache guide](https://ubuntu.com/server/docs/introduction-to-web-servers).
您还需要一个 Web 服务器。在本指南中，我们使用 Apache2，但如果您愿意，可以使用另一个。如果您想了解如何安装 Apache2，请参阅我们的 Apache 指南。

## Install `phpmyadmin` 安装 `phpmyadmin` 

Once your MySQL database is set up, you can install `phpmyadmin` via the terminal:
设置MySQL数据库后，您可以通过终端进行安装 `phpmyadmin` ：

```bash
sudo apt install phpmyadmin
```

At the prompt, choose which web server to configure for phpMyAdmin. Here, we are using Apache2 for the web server.
在提示符下，选择要为 phpMyAdmin 配置的 Web 服务器。在这里，我们将 Apache2 用于 Web 服务器。

In a browser, go to `http://servername/phpmyadmin` (replace `servername` with the server’s actual hostname).
在浏览器中，转到 `http://servername/phpmyadmin` （替换 `servername` 为服务器的实际主机名）。

At the login, page enter **root** for the username. Or, if you have a MySQL user already set up, enter the MySQL user’s password.
登录时，页面输入root作为用户名。或者，如果您已经设置了 MySQL 用户，请输入 MySQL 用户的密码。

Once logged in, you can reset the root password if needed, create users, create or destroy databases and tables, etc.
登录后，您可以根据需要重置root密码，创建用户，创建或销毁数据库和表等。

## Configure `phpmyadmin` 配置 `phpmyadmin` 

The configuration files for phpMyAdmin are located in `/etc/phpmyadmin`. The main configuration file is `/etc/phpmyadmin/config.inc.php`. This file contains configuration options that apply globally to phpMyAdmin.
phpMyAdmin 的配置文件位于 `/etc/phpmyadmin` 。主配置文件是 `/etc/phpmyadmin/config.inc.php` 。此文件包含全局应用于 phpMyAdmin 的配置选项。

To use phpMyAdmin to administer a MySQL database hosted on another server, adjust the following in `/etc/phpmyadmin/config.inc.php`:
要使用 phpMyAdmin 管理托管在另一台服务器上的 MySQL 数据库，请在 `/etc/phpmyadmin/config.inc.php` ：

```auto
$cfg['Servers'][$i]['host'] = 'db_server';
```

> **Note**: 注意：
>  Replace `db_server` with the actual remote database server name or IP address. Also, be  sure that the phpMyAdmin host has permissions to access the remote  database.
> 替换 `db_server` 为实际的远程数据库服务器名称或 IP 地址。此外，请确保 phpMyAdmin 主机具有访问远程数据库的权限。

Once configured, log out of phpMyAdmin then back in again, and you should be accessing the new server.
配置完成后，注销 phpMyAdmin，然后重新登录，您应该正在访问新服务器。

### Configuration files 配置文件

The `config.header.inc.php` and `config.footer.inc.php` files in the `/etc/phpmyadmin` directory are used to add a HTML header and footer, respectively, to phpMyAdmin.
 `/etc/phpmyadmin` 目录中的 `config.header.inc.php` 和 `config.footer.inc.php` 文件分别用于向 phpMyAdmin 添加 HTML 页眉和页脚。

Another important configuration file is `/etc/phpmyadmin/apache.conf`. This file is symlinked to `/etc/apache2/conf-available/phpmyadmin.conf`, and once enabled, is used to configure Apache2 to serve the phpMyAdmin  site. The file contains directives for loading PHP, directory  permissions, etc. From a terminal type:
另一个重要的配置文件是 `/etc/phpmyadmin/apache.conf` 。此文件符号链接到 `/etc/apache2/conf-available/phpmyadmin.conf` ，启用后，用于配置 Apache2 以服务于 phpMyAdmin 站点。该文件包含用于加载 PHP 的指令、目录权限等。从终端类型：

```bash
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf
sudo systemctl reload apache2.service
```

## Further reading 延伸阅读

- The phpMyAdmin documentation comes installed with the package and can be accessed from the **phpMyAdmin Documentation** link (a question mark with a box around it) under the phpMyAdmin logo. The official docs can also be access on [the phpMyAdmin website](http://www.phpmyadmin.net/home_page/docs.php).
  phpMyAdmin 文档随软件包一起安装，可以从 phpMyAdmin 徽标下的 phpMyAdmin 文档链接（一个带有方框的问号）访问。官方文档也可以在phpMyAdmin网站上访问。
- Another resource is the [phpMyAdmin Ubuntu Wiki](https://help.ubuntu.com/community/phpMyAdmin) page.
  另一个资源是 phpMyAdmin Ubuntu Wiki 页面。
- If you need more information on configuring Apache2, refer to [our guide on Apache2](https://ubuntu.com/server/docs/introduction-to-web-servers).
  如果您需要有关配置 Apache2 的更多信息，请参阅我们的 Apache2 指南。

------