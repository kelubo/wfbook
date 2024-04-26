# How to install and configure Ruby on Rails 如何安装和配置 Ruby on Rails

[Ruby on Rails](https://rubyonrails.org/) is an open source web framework for developing database-backed web  applications. It is optimised for sustainable productivity of the  programmer since it lets the programmer to write code by favouring  convention over configuration. This guide explains how to install and  configure Ruby on Rails for an Ubuntu system with Apache2 and MySQL.
Ruby on Rails 是一个开源 Web 框架，用于开发数据库支持的 Web  应用程序。它针对程序员的可持续生产力进行了优化，因为它允许程序员通过偏爱约定而不是配置来编写代码。本指南介绍了如何为带有 Apache2 和  MySQL 的 Ubuntu 系统安装和配置 Ruby on Rails。

## Prerequisites 先决条件

Before installing Rails you should install Apache (or a preferred web server) and a database service such as MySQL.
在安装 Rails 之前，您应该安装 Apache（或首选的 Web 服务器）和数据库服务，例如 MySQL。

- To install the Apache package, please refer to [our Apache guide](https://ubuntu.com/server/docs/introduction-to-web-servers).
  要安装 Apache 软件包，请参阅我们的 Apache 指南。
- To install and configure a MySQL database service, refer to [our MySQL guide](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
  要安装和配置 MySQL 数据库服务，请参阅我们的 MySQL 指南。

## Install `rails` 安装 `rails` 

Once you have a web server and a database service installed and configured, you are ready to install the Ruby on Rails package, `rails`, by entering the following in the terminal prompt.
安装并配置了 Web 服务器和数据库服务后，即可在终端提示符中输入以下内容来安装 Ruby on Rails 软件包 `rails` 。

```bash
sudo apt install rails
```

This will install both the Ruby base packages, and Ruby on Rails.
这将安装 Ruby 基础软件包和 Ruby on Rails。

## Configure the web server 配置 Web 服务器

You will need to modify the `/etc/apache2/sites-available/000-default.conf` configuration file to set up your domains.
您需要修改 `/etc/apache2/sites-available/000-default.conf` 配置文件以设置您的域。

The first thing to change is the `DocumentRoot` directive:
首先要更改的是 `DocumentRoot` 指令：

```nohighlight
DocumentRoot /path/to/rails/application/public
```

Next, change the `<Directory "/path/to/rails/application/public">` directive:
接下来，更改 `<Directory "/path/to/rails/application/public">` 指令：

```nohighlight
<Directory "/path/to/rails/application/public">
        Options Indexes FollowSymLinks MultiViews ExecCGI
        AllowOverride All
        Order allow,deny
        allow from all
        AddHandler cgi-script .cgi
</Directory>
```

You should also enable the `mod_rewrite` module for Apache. To enable the `mod_rewrite` module, enter the following command into a terminal prompt:
您还应该为 Apache 启用该 `mod_rewrite` 模块。要启用该 `mod_rewrite` 模块，请在终端提示符下输入以下命令：

```bash
sudo a2enmod rewrite
```

Finally, you will need to change the ownership of the `/path/to/rails/application/public` and `/path/to/rails/application/tmp` directories to the user that will be used to run the Apache process:
最后，您需要将 `/path/to/rails/application/public` and `/path/to/rails/application/tmp` 目录的所有权更改为将用于运行 Apache 进程的用户：

```bash
sudo chown -R www-data:www-data /path/to/rails/application/public
sudo chown -R www-data:www-data /path/to/rails/application/tmp
```

If you need to compile your application assets run the following command in
如果需要编译应用程序资产，请在
 your application directory:
应用程序目录：

```bash
RAILS_ENV=production rake assets:precompile
```

## Configure the database 配置数据库

With your database service in place, you need to make sure your app database configuration is also correct. For example, if you are using MySQL the  your `config/database.yml` should look like this:
数据库服务到位后，需要确保应用数据库配置也正确。例如，如果您使用的是 MySQL，则 your `config/database.yml` 应该如下所示：

```nohighlight
# Mysql 
production:
  adapter: mysql2
  username: user
  password: password
  host: 127.0.0.1 
  database: app
```

To finally create your application database and apply its migrations you can run the following commands from your app directory:
若要最终创建应用程序数据库并应用其迁移，可以从应用目录运行以下命令：

```bash
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
```

That’s it! Now your Server is ready for your Ruby on Rails application. You can daemonize your application as you want.
就是这样！现在，您的服务器已准备好用于 Ruby on Rails 应用程序。您可以根据需要对应用程序进行守护程序。

## Further reading 延伸阅读

- See the [Ruby on Rails](http://rubyonrails.org/) website for more information.
  有关更多信息，请参见 Ruby on Rails 网站。
- [Agile Development with Rails](https://pragprog.com/book/rails4/agile-web-development-with-rails-4) is also a great resource.
  Agile Development with Rails 也是一个很好的资源。