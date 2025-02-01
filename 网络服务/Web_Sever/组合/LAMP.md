# Get started with LAMP applications LAMP应用入门

## Overview 概述

LAMP installations (Linux + Apache + MySQL + PHP/Perl/Python) are a popular  setup for Ubuntu servers. There are a plethora of Open Source  applications written using the LAMP application stack. Some popular LAMP applications include **wikis**, **management software** such as phpMyAdmin, and  **Content Management Systems (CMSs)** like WordPress.
LAMP安装（Linux + Apache + MySQL + PHP / Perl /  Python）是Ubuntu服务器的流行设置。有大量使用LAMP应用程序堆栈编写的开源应用程序。一些流行的 LAMP 应用程序包括  wiki、管理软件（如 phpMyAdmin）和内容管理系统 （CMS）（如 WordPress）。

One advantage of LAMP is the substantial flexibility for different  database, web server, and scripting languages. Popular substitutes for  MySQL include PostgreSQL and SQLite. Python, Perl, and Ruby are also  frequently used instead of PHP. While Nginx, Cherokee and Lighttpd can  replace Apache.
LAMP的一个优点是为不同的数据库、Web服务器和脚本语言提供了极大的灵活性。MySQL 的流行替代品包括 PostgreSQL 和 SQLite。Python、Perl 和 Ruby 也经常被用来代替 PHP。而  Nginx、Cherokee 和 Lighttpd 可以取代 Apache。

## Quickstart 快速入门

The fastest way to get started is to install LAMP using `tasksel`. Tasksel is a Debian/Ubuntu tool that installs multiple related packages as a co-ordinated “task” onto your system.
最快的入门方法是使用 `tasksel` 安装 LAMP。Tasksel 是一个 Debian/Ubuntu 工具，它将多个相关软件包作为协调的“任务”安装到您的系统上。

At a terminal prompt enter the following commands:
在终端提示符下，输入以下命令：

```bash
sudo apt-get update
sudo apt-get install -y tasksel
sudo tasksel install lamp-server
```

### LAMP application install process LAMP应用安装流程

After installing LAMP you’ll be able to install most LAMP applications in this way:
安装 LAMP 后，您将能够以这种方式安装大多数 LAMP 应用程序：

- Download an archive containing the application source files.
  下载包含应用程序源文件的存档。
- Unpack the archive, usually in a directory accessible to a web server.
  解压缩存档，通常位于 Web 服务器可访问的目录中。
- Depending on where the source was extracted, configure a web server to serve the files.
  根据提取源的位置，配置 Web 服务器以提供文件。
- Configure the application to connect to the database.
  配置应用程序以连接到数据库。
- Run a script, or browse to a page of the application, to install the database needed by the application.
  运行脚本或浏览到应用程序的页面，以安装应用程序所需的数据库。
- Once the steps above, or similar steps, are completed you are ready to begin using the application.
  完成上述步骤或类似步骤后，您就可以开始使用该应用程序了。

A disadvantage of using this approach is that the application files are  not placed in the file system in a standard way, which can cause  confusion as to where the application is installed.
使用此方法的一个缺点是应用程序文件未以标准方式放置在文件系统中，这可能会导致应用程序安装位置的混淆。

### Update LAMP applications 更新 LAMP 应用程序

When a new LAMP application version is released, follow the same installation process to apply updates to the application.
发布新的 LAMP 应用程序版本时，请按照相同的安装过程将更新应用于应用程序。

Fortunately, a number of LAMP applications are already packaged for Ubuntu, and are  available for installation in the same way as non-LAMP applications  (some applications may need extra configuration and setup steps). Two  popular examples are phpMyAdmin and WordPress.
幸运的是，许多LAMP应用程序已经打包用于Ubuntu，并且可以像非LAMP应用程序一样进行安装（某些应用程序可能需要额外的配置和设置步骤）。两个流行的例子是 phpMyAdmin 和 WordPress。

Refer to our guides on how to [install phpMyAdmin](https://ubuntu.com/server/docs/how-to-install-and-configure-phpmyadmin) and how to [install WordPress](https://ubuntu.com/server/docs/how-to-install-and-configure-wordpress) for more information on those applications.
有关这些应用程序的更多信息，请参阅我们关于如何安装 phpMyAdmin 和如何安装 WordPress 的指南。

------