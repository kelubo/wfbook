# How to install and configure WordPress 如何安装和配置 WordPress

[Wordpress](https://wordpress.com/) is a blog tool, publishing platform and content management system (CMS) implemented in PHP and licensed under the [GNU General Public License (GPL) v2 or later](https://en-gb.wordpress.org/about/license/).
Wordpress 是用 PHP 实现的博客工具、发布平台和内容管理系统 （CMS），并在 GNU 通用公共许可证 （GPL） v2 或更高版本下获得许可。

In this guide, we show you how to install and configure WordPress in an Ubuntu system with Apache2 and MySQL.
在本指南中，我们将向您展示如何使用 Apache2 和 MySQL 在 Ubuntu 系统中安装和配置 WordPress。

## Prerequisites 先决条件

Before installing WordPress you should install Apache2 (or a preferred web server) and a database service such as MySQL.
在安装 WordPress 之前，您应该安装 Apache2（或首选的 Web 服务器）和数据库服务，例如 MySQL。

- To install the Apache package, refer to [our Apache guide](https://ubuntu.com/server/docs/introduction-to-web-servers).
  要安装 Apache 软件包，请参阅我们的 Apache 指南。
- To install and configure a MySQL database service, refer to [our MySQL guide](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
  要安装和配置 MySQL 数据库服务，请参阅我们的 MySQL 指南。

## Install WordPress 安装 WordPress

To install WordPress, run the following comand in the command prompt:
要安装 WordPress，请在命令提示符下运行以下命令：

```bash
sudo apt install wordpress
```

## Configure WordPress 配置 WordPress

To configure your first WordPress application, you need to configure your Apache web server. To do this, open `/etc/apache2/sites-available/wordpress.conf` and write the following lines:
要配置您的第一个 WordPress 应用程序，您需要配置您的 Apache Web 服务器。为此，请打开 `/etc/apache2/sites-available/wordpress.conf` 并编写以下行：

```nohighlight
Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>
```

Now you can enable this new WordPress site:
现在，您可以启用这个新的WordPress站点：

```bash
sudo a2ensite wordpress
```

Once you configure the Apache2 web server (and make it ready for your  WordPress application), you will need to restart it. You can run the  following command to restart the Apache2 web server:
一旦你配置了Apache2 Web服务器（并使其为你的WordPress应用程序做好准备），你将需要重新启动它。您可以运行以下命令来重新启动 Apache2 Web 服务器：

```bash
sudo systemctl reload apache2.service
```

### The configuration file 配置文件

To facilitate having multiple WordPress installations, the name of the configuration file is based on the **Host header** of the HTTP request.
为了便于安装多个 WordPress，配置文件的名称基于 HTTP 请求的 Host 标头。

This means you can have a configuration per **Virtual Host** by matching the hostname portion of this configuration with your Apache Virtual Host, e.g. `/etc/wordpress/config-10.211.55.50.php`, `/etc/wordpress/config-hostalias1.php`, etc.
这意味着您可以通过将此配置的主机名部分与 Apache 虚拟主机（例如 、 `/etc/wordpress/config-hostalias1.php` 等） `/etc/wordpress/config-10.211.55.50.php` 进行匹配，为每个虚拟主机提供配置。

These instructions assume you can access Apache via the **localhost** hostname (perhaps by using an SSH tunnel) if not, replace `/etc/wordpress/config-localhost.php` with `/etc/wordpress/config-NAME_OF_YOUR_VIRTUAL_HOST.php`.
这些说明假定您可以通过 localhost 主机名（可能通过使用 SSH 隧道）访问 Apache，否则请替换 `/etc/wordpress/config-localhost.php` 为 `/etc/wordpress/config-NAME_OF_YOUR_VIRTUAL_HOST.php` .

Once the configuration file is written, it is up to you to choose a  convention for username and password to MySQL for each WordPress  database instance. This documentation shows only one, localhost, to act  as an example.
编写配置文件后，您可以为每个 WordPress 数据库实例选择 MySQL 的用户名和密码约定。本文档仅显示一个 localhost 作为示例。

### Configure the MySQL database 配置MySQL数据库

Now we need to configure WordPress to use a MySQL database. Open the `/etc/wordpress/config-localhost.php` file and write the following lines:
现在我们需要配置WordPress以使用MySQL数据库。打开文件 `/etc/wordpress/config-localhost.php` 并写下以下行：

```php
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'yourpasswordhere');
define('DB_HOST', 'localhost');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
```

## Create the MySQL database 创建 MySQL 数据库

Now create the mySQL database you’ve just configured. Open a temporary file with MySQL command `wordpress.sql` and write the following lines:
现在创建刚刚配置的 mySQL 数据库。使用 MySQL 命令 `wordpress.sql` 打开一个临时文件并编写以下行：

```auto
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'localhost'
IDENTIFIED BY 'yourpasswordhere';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON wordpress.*
TO wordpress@localhost;
FLUSH PRIVILEGES;
```

Then, run the following commands:
然后，运行以下命令：

```bash
cat wordpress.sql | sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf
```

Your new WordPress installation can now be configured by visiting `http://localhost/blog/wp-admin/install.php` (or `http://NAME_OF_YOUR_VIRTUAL_HOST/blog/wp-admin/install.php` if your server has no GUI and you are completing WordPress  configuration via a web browser running on another computer). Fill out  the Site Title, username, password, and E-mail and click “Install  WordPress”.
现在可以通过访问 `http://localhost/blog/wp-admin/install.php` 来配置您的新 WordPress 安装（或者 `http://NAME_OF_YOUR_VIRTUAL_HOST/blog/wp-admin/install.php` 如果您的服务器没有 GUI，并且您正在通过另一台计算机上运行的 Web 浏览器完成 WordPress 配置）。填写网站标题、用户名、密码和电子邮件，然后单击“安装 WordPress”。

Note the generated password (if applicable) and click the login password. Your WordPress is now ready for use!
记下生成的密码（如果适用），然后单击登录密码。您的 WordPress 现在可以使用了！

## Further reading 延伸阅读

- [WordPress.org Codex WordPress.org 法典](https://codex.wordpress.org/)
- [Ubuntu Wiki WordPress Ubuntu Wiki WordPress的](https://help.ubuntu.com/community/WordPress)

------