# PHP

# How to install and configure PHP 如何安装和配置 PHP

[PHP](https://www.php.net/) is a general-purpose scripting language well-suited for Web development since PHP scripts can be embedded into HTML. This guide explains how to install and configure PHP in an Ubuntu System with Apache2 and MySQL.
PHP 是一种通用脚本语言，非常适合 Web 开发，因为 PHP 脚本可以嵌入到 HTML 中。本指南介绍了如何在带有 Apache2 和 MySQL 的 Ubuntu 系统中安装和配置 PHP。

## Prerequisites 先决条件

Before installing PHP you should install Apache (or a preferred web server) and a database service such as MySQL.
在安装 PHP 之前，您应该安装 Apache（或首选的 Web 服务器）和数据库服务，例如 MySQL。

- To install the Apache package, please refer to [our Apache guide](https://ubuntu.com/server/docs/introduction-to-web-servers).
  要安装 Apache 软件包，请参阅我们的 Apache 指南。
- To install and configure a MySQL database service, refer to [our MySQL guide](https://ubuntu.com/server/docs/install-and-configure-a-mysql-server).
  要安装和配置 MySQL 数据库服务，请参阅我们的 MySQL 指南。

## Install PHP 安装 PHP

PHP is available on Ubuntu Linux, but unlike Python (which comes pre-installed), must be manually installed.
PHP 在 Ubuntu Linux 上可用，但与 Python（预装）不同，必须手动安装。

To install PHP – and the Apache PHP module – you can enter the following command into a terminal prompt:
要安装 PHP 和 Apache PHP 模块，您可以在终端提示符下输入以下命令：

```bash
sudo apt install php libapache2-mod-php
```

## Install optional packages 安装可选软件包

The following packages are optional, and can be installed if you need them for your setup.
以下软件包是可选的，如果您在设置中需要它们，可以安装它们。

- **PHP-CLI PHP-命令行界面**
   You can run PHP scripts via the Command Line Interface (CLI). To do this, you must first install the `php-cli` package. You can install it by running the following command:
  您可以通过命令行界面 （CLI） 运行 PHP 脚本。为此，必须先安装软件 `php-cli` 包。您可以通过运行以下命令来安装它：

  ```bash
  sudo apt install php-cli
  ```

- **PHP-CGI PHP-CGI的**
   You can also execute PHP scripts without installing the Apache PHP module. To accomplish this, you should install the `php-cgi` package via this command:
  您也可以在不安装 Apache PHP 模块的情况下执行 PHP 脚本。为此，您应该通过以下命令安装 `php-cgi` 软件包：

  ```bash
  sudo apt install php-cgi
  ```

- **PHP-MySQL PHP-MySQL的**
   To use MySQL with PHP you should install the `php-mysql` package, like so:
  要将MySQL与PHP一起使用，您应该安装该 `php-mysql` 软件包，如下所示：

  ```bash
  sudo apt install php-mysql
  ```

- **PHP-PgSQL PHP-PgSQL的**
   Similarly, to use PostgreSQL with PHP you should install the `php-pgsql` package:
  同样，要将 PostgreSQL 与 PHP 一起使用，您应该安装以下 `php-pgsql` 软件包：

  ```bash
  sudo apt install php-pgsql
  ```

## Configure PHP 配置 PHP

If you have installed the `libapache2-mod-php` or `php-cgi` packages, you can run PHP scripts from your web browser. If you have installed the `php-cli` package, you can run PHP scripts at a terminal prompt.
如果已安装 `libapache2-mod-php` 或 `php-cgi` 包，则可以从 Web 浏览器运行 PHP 脚本。如果已安装软件 `php-cli` 包，则可以在终端提示符下运行 PHP 脚本。

By default, when `libapache2-mod-php` is installed, the Apache2 web server is configured to run PHP scripts using this module. First, verify if the files `/etc/apache2/mods-enabled/php8.*.conf` and `/etc/apache2/mods-enabled/php8.*.load` exist. If they do not exist, you can enable the module using the `a2enmod` command.
默认情况下，安装时 `libapache2-mod-php` ，Apache2 Web 服务器配置为使用此模块运行 PHP 脚本。首先，验证文件 `/etc/apache2/mods-enabled/php8.*.conf` 是否 `/etc/apache2/mods-enabled/php8.*.load` 存在。如果它们不存在，则可以使用命令 `a2enmod` 启用该模块。

Once you have installed the PHP-related packages and enabled the Apache PHP  module, you should restart the Apache2 web server to run PHP scripts, by running the following command:
安装与 PHP 相关的软件包并启用 Apache PHP 模块后，应通过运行以下命令重新启动 Apache2 Web 服务器以运行 PHP 脚本：

```bash
sudo systemctl restart apache2.service 
```

## Test your setup 测试您的设置

To verify your installation, you can run the following PHP `phpinfo` script:
要验证安装，可以运行以下 PHP `phpinfo` 脚本：

```php
<?php
  phpinfo();
?>
```

You can save the content in a file – `phpinfo.php` for example – and place it under the `DocumentRoot` directory of the Apache2 web server. Pointing your browser to `http://hostname/phpinfo.php` will display the values of various PHP configuration parameters.
 `phpinfo.php` 例如，您可以将内容保存在文件中，并将其放在 Apache2 Web 服务器 `DocumentRoot` 的目录下。将浏览器指向 `http://hostname/phpinfo.php` 将显示各种 PHP 配置参数的值。

## Further reading 延伸阅读

- For more in depth information see [the php.net documentation](http://www.php.net/docs.php).
  有关更深入的信息，请参阅 php.net 文档。
- There are a plethora of books on PHP 7 and PHP 8. A good book from O’Reilly is [Learning PHP](http://oreilly.com/catalog/0636920043034/), which includes an exploration of PHP 7’s enhancements to the language.
  有大量关于 PHP 7 和 PHP 8 的书籍。O'Reilly 的一本好书是《学习 PHP》，其中包括对 PHP 7 对语言的增强的探索。
- Also, see the [Apache MySQL PHP Ubuntu Wiki](https://help.ubuntu.com/community/ApacheMySQLPHP) page for more information.
  此外，请参阅 Apache MySQL PHP Ubuntu Wiki 页面了解更多信息。

------



PHP（PHP：Hypertext Preprocessor，超文本预处理器"）是一种通用开源脚本语言。可嵌入到 HTML中，尤其适合 web 开发。

PHP 脚本主要用于以下三个领域：     

- 网站和 web 应用程序（服务器端脚本） 

  需要具备以下三点：PHP 解析器（CGI 或者服务器模块）、web 服务器和 web 浏览器。需要在运行 web 服务器时，安装并配置 PHP，然后，可以用 web 浏览器来访问 PHP 程序的输出，即浏览服务端的 PHP 页面。       

- 命令行脚本。             

- 桌面（GUI）应用程序。  

  可以利用 PHP-GTK 来编写这些程序。用这种方法，还可以编写跨平台的应用程序。  



PHP 代码是运行在服务端的。



​			超文本 Preprocessor(PHP)是主要用于服务器端脚本的通用脚本语言，可让您使用 Web 服务器运行 PHP 代码。 	

​			超文本 Preprocessor(PHP)是主要用于服务器端脚本的通用脚本语言，可让您使用 Web 服务器运行 PHP 代码。 	

​			在 RHEL 9 中，PHP 提供以下版本和格式： 	

- ​					PHP 8.0 作为 `php` RPM 软件包 			
- ​					PHP 8.1 作为 `php:8.1` 模块流 			

## 5.1. 安装 PHP 脚本语言

​				这部分论述了如何安装 PHP。 		

**步骤**

- ​						要安装 PHP 8.0，请使用： 				

  

  ```none
  # dnf install php
  ```

- ​						要使用默认配置集安装 `php:8.1` 模块流，请使用： 				

  

  ```none
  # dnf module install php:8.1
  ```

  ​						默认 `通用` 配置集安装 `php-fpm` 软件包，并预配置 PHP 以用于 Apache HTTP 服务器或 nginx。 				

- ​						要安装 `php:8.1` 模块流的特定配置集，请使用： 				

  

  ```none
  # dnf module install php:8.1/profile
  ```

  ​						可用配置集如下： 				

- ​						`common` - 使用 Web 服务器进行服务器端脚本的默认配置文件。它包括最常用的扩展。 				

- ​						`minimal` - 此配置集只安装命令行界面以用于使用 PHP 编写脚本，而无需使用 Web 服务器。 				

- ​						`devel` - 此配置集包含来自 common 配置集的软件包以及用于开发用途的其他软件包。 				

  ​						例如，要安装 PHP 8.1 以供不使用 web 服务器，请使用： 				

  

  ```none
  # dnf module install php:8.1/minimal
  ```

**其它资源**

- ​						[使用 DNF 工具管理软件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_software_with_the_dnf_tool) 				

## 5.2. 通过 Web 服务器使用 PHP 脚本语言

### 5.2.1. 在 Apache HTTP 服务器中使用 PHP

​					在 Red Hat Enterprise Linux 9 中，`Apache HTTP 服务器` 可让您将 PHP 作为 FastCGI 进程服务器运行。FastCGI Process Manager(FPM)是一种替代 PHP  FastCGI 守护进程，它允许网站管理高负载。默认情况下，PHP 在 RHEL 9 中使用 FastCGI Process Manager。 			

​					本节论述了如何使用 FastCGI 进程服务器运行 PHP 代码。 			

**先决条件**

- ​							在您的系统上安装 PHP 脚本语言。 					

**步骤**

1. ​							安装 `httpd` 软件包： 					

   

   ```none
   # dnf install httpd
   ```

2. ​							启动 `Apache HTTP 服务器` ： 					

   

   ```none
   # systemctl start httpd
   ```

   ​							或者，如果 `Apache HTTP` 服务器已在您的系统中运行，请在安装 PHP 后重启 `httpd` 服务： 					

   

   ```none
   # systemctl restart httpd
   ```

3. ​							启动 `php-fpm` 服务： 					

   

   ```none
   # systemctl start php-fpm
   ```

4. ​							可选：在引导时启用这两个服务： 					

   

   ```none
   # systemctl enable php-fpm httpd
   ```

5. ​							要获取有关 PHP 设置的信息，请在 `/var/www/html/` 目录中创建带有以下内容的 `index.php` 文件： 					

   

   ```none
   echo '<?php phpinfo(); ?>' > /var/www/html/index.php
   ```

6. ​							要运行 `index.php` 文件，请将浏览器指向： 					

   

   ```none
   http://<hostname>/
   ```

7. ​							可选：如果您有特定要求，请调整配置： 					

   - ​									`/etc/httpd/conf/httpd.conf` - 一般的 `httpd` 配置 							
   - ​									`/etc/httpd/conf.d/php.conf` - `httpd`特定 PHP 配置 							
   - ​									`/usr/lib/systemd/system/httpd.service.d/ php-fpm.conf` - 默认情况下，php-fpm 服务使用 `httpd`启动 							
   - ​									`/etc/php-fpm.conf` - FPM 主配置 							
   - ​									`/etc/php-fpm.d/www.conf` - 默认 `www` 池配置 							

例 5.1. 运行"Hello, World!" 使用 Apache HTTP 服务器的 PHP 脚本

1. ​								在 `/var/www/html/` 目录中为您的项目创建一个 `hello` 目录： 						

   

   ```none
   # mkdir hello
   ```

2. ​								在 `/var/www/html/hello/` 目录中创建 `hello.php` 文件，其内容如下： 						

   

   ```none
   # <!DOCTYPE html>
   <html>
   <head>
   <title>Hello, World! Page</title>
   </head>
   <body>
   <?php
       echo 'Hello, World!';
   ?>
   </body>
   </html>
   ```

3. ​								启动 `Apache HTTP 服务器` ： 						

   

   ```none
   # systemctl start httpd
   ```

4. ​								要运行 `hello.php` 文件，请将浏览器指向： 						

   

   ```none
   http://<hostname>/hello/hello.php
   ```

   ​								因此，会显示带有 "Hello, World!" 文本的网页。 						

**其它资源**

- ​							[设置 Apache HTTP web 服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deploying_web_servers_and_reverse_proxies/setting-apache-http-server_deploying-web-servers-and-reverse-proxies) 					

### 5.2.2. 使用带有 nginx web 服务器的 PHP

​					本节论述了如何通过 `nginx` web 服务器运行 PHP 代码。 			

**先决条件**

- ​							在您的系统上安装 PHP 脚本语言。 					

**步骤**

1. ​							安装`nginx`软件包： 					

   

   ```none
   # dnf install nginx
   ```

2. ​							启动 `nginx` 服务器： 					

   

   ```none
   # systemctl start nginx
   ```

   ​							或者，如果 `nginx` 服务器已在您的系统中运行，请在安装 PHP 后重启 `nginx` 服务： 					

   

   ```none
   # systemctl restart nginx
   ```

3. ​							启动 `php-fpm` 服务： 					

   

   ```none
   # systemctl start php-fpm
   ```

4. ​							可选：在引导时启用这两个服务： 					

   

   ```none
   # systemctl enable php-fpm nginx
   ```

5. ​							要获取 PHP 设置的信息，请在 `/usr/share/nginx/html/` 目录中使用以下内容创建 `index.php` 文件： 					

   

   ```none
   echo '<?php phpinfo(); ?>' > /usr/share/nginx/html/index.php
   ```

6. ​							要运行 `index.php` 文件，请将浏览器指向： 					

   

   ```none
   http://<hostname>/
   ```

7. ​							可选：如果您有特定要求，请调整配置： 					

   - ​									`/etc/nginx/nginx.conf` - `nginx` 主配置 							
   - ​									`/etc/nginx/conf.d/php-fpm.conf` - FPM 配置 `nginx` 							
   - ​									`/etc/php-fpm.conf` - FPM 主配置 							
   - ​									`/etc/php-fpm.d/www.conf` - 默认 `www` 池配置 							

例 5.2. 运行"Hello, World!" 使用 nginx 服务器的 PHP 脚本

1. ​								在 `/usr/share/nginx/html/` 目录中为您的项目创建一个 `hello` 目录： 						

   

   ```none
   # mkdir hello
   ```

2. ​								在 `/usr/share/nginx/html/hello/` 目录中创建一个包含以下内容的 `hello.php` 文件： 						

   

   ```none
   # <!DOCTYPE html>
   <html>
   <head>
   <title>Hello, World! Page</title>
   </head>
   <body>
   <?php
       echo 'Hello, World!';
   ?>
   </body>
   </html>
   ```

3. ​								启动 `nginx` 服务器： 						

   

   ```none
   # systemctl start nginx
   ```

4. ​								要运行 `hello.php` 文件，请将浏览器指向： 						

   

   ```none
   http://<hostname>/hello/hello.php
   ```

   ​								因此，会显示带有 "Hello, World!" 文本的网页。 						

**其它资源**

- ​							[设置和配置 NGINX](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/deploying_web_servers_and_reverse_proxies/setting-up-and-configuring-nginx_deploying-web-servers-and-reverse-proxies) 					

## 5.3. 使用命令行界面运行 PHP 脚本

​				PHP 脚本通常使用 Web 服务器运行，但也可以使用 命令行界面来运行。 		

**先决条件**

- ​						在您的系统上安装 PHP 脚本语言。 				

**步骤**

1. ​						在文本编辑器中，创建一个 `*filename*.php` 文件 				

   ​						将 *filename* 替换为您的文件名称。 				

2. ​						从命令行执行创建 `*filename*.php` 文件： 				

   

   ```none
   # php filename.php
   ```

例 5.3. 运行"Hello, World!" 使用命令行界面 PHP 脚本

1. ​							使用文本编辑器，创建包含以下内容的 `hello.php` 文件： 					

   

   ```none
   <?php
       echo 'Hello, World!';
   ?>
   ```

2. ​							从命令行执行 `hello.php` 文件： 					

   

   ```none
   # php hello.php
   ```

   ​							结果会输出 "Hello, World!"。 					

## 5.4. 其它资源

- ​						`httpd(8)` - `httpd`服务的手册页，包含其命令行选项的完整列表。 				
- ​						`httpd.conf(5)` - `httpd` 配置的 man page，描述 `httpd` 配置文件的结构和位置。 				
- ​						`nginx(8)` - `nginx` web 服务器的 man page，其中包含其命令行选项的完整列表和信号列表。 				
- ​						`php-fpm(8)` - PHP FPM 的 man page 描述其命令行选项和配置文件的完整列表。 				

## 5.1. 安装 PHP 脚本语言

​				这部分论述了如何安装 PHP。 		

**步骤**

- ​						要安装 PHP，请使用： 				

  ```none
  # dnf install php
  ```

## 5.2. 通过 Web 服务器使用 PHP 脚本语言

### 5.2.1. 在 Apache HTTP 服务器中使用 PHP

​					在 Red Hat Enterprise Linux 9 中，`Apache HTTP 服务器` 可让您将 PHP 作为 FastCGI 进程服务器运行。FastCGI Process Manager(FPM)是一种替代 PHP  FastCGI 守护进程，它允许网站管理高负载。默认情况下，PHP 在 RHEL 9 中使用 FastCGI Process Manager。 			

​					本节论述了如何使用 FastCGI 进程服务器运行 PHP 代码。 			

**先决条件**

- ​							在您的系统上安装 PHP 脚本语言。 					

**步骤**

1. ​							安装 `httpd` 软件包： 					

   ```none
   # dnf install httpd
   ```

2. ​							启动 `Apache HTTP 服务器` ： 					

   ```none
   # systemctl start httpd
   ```

   ​							或者，如果 `Apache HTTP` 服务器已在您的系统中运行，请在安装 PHP 后重启 `httpd` 服务： 					

   ```none
   # systemctl restart httpd
   ```

3. ​							启动 `php-fpm` 服务： 					

   ```none
   # systemctl start php-fpm
   ```

4. ​							可选：在引导时启用这两个服务： 					

   ```none
   # systemctl enable php-fpm httpd
   ```

5. ​							要获取有关 PHP 设置的信息，请在 `/var/www/html/` 目录中创建带有以下内容的 `index.php` 文件： 					

   ```none
   echo '<?php phpinfo(); ?>' > /var/www/html/index.php
   ```

6. ​							要运行 `index.php` 文件，请将浏览器指向： 					

   ```none
   http://<hostname>/
   ```

7. ​							可选：如果您有特定要求，请调整配置： 					

   - ​									`/etc/httpd/conf/httpd.conf` - 一般的 `httpd` 配置 							
   - ​									`/etc/httpd/conf.d/php.conf` - `httpd`特定 PHP 配置 							
   - ​									`/usr/lib/systemd/system/httpd.service.d/ php-fpm.conf` - 默认情况下，php-fpm 服务使用 `httpd`启动 							
   - ​									`/etc/php-fpm.conf` - FPM 主配置 							
   - ​									`/etc/php-fpm.d/www.conf` - 默认 `www` 池配置 							

**例 5.1. 运行"Hello, World!" 使用 Apache HTTP 服务器的 PHP 脚本**

1. ​								在 `/var/www/html/` 目录中为您的项目创建一个 `hello` 目录： 						

   ```none
   # mkdir hello
   ```

2. ​								在 `/var/www/html/hello/` 目录中创建 `hello.php` 文件，其内容如下： 						

   ```none
   # <!DOCTYPE html>
   <html>
   <head>
   <title>Hello, World! Page</title>
   </head>
   <body>
   <?php
       echo 'Hello, World!';
   ?>
   </body>
   </html>
   ```

3. ​								启动 `Apache HTTP 服务器` ： 						

   ```none
   # systemctl start httpd
   ```

4. ​								要运行 `hello.php` 文件，请将浏览器指向： 						

   ```none
   http://<hostname>/hello/hello.php
   ```

   ​								因此，会显示带有 "Hello, World!" 文本的网页。 						

**其它资源**

- ​							[设置 Apache HTTP web 服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/deploying_web_servers_and_reverse_proxies/setting-apache-http-server_deploying-web-servers-and-reverse-proxies) 					

### 5.2.2. 使用带有 nginx web 服务器的 PHP

​					本节论述了如何通过 `nginx` web 服务器运行 PHP 代码。 			

**先决条件**

- ​							在您的系统上安装 PHP 脚本语言。 					

**步骤**

1. ​							安装`nginx`软件包： 					

   ```none
   # dnf install nginx
   ```

2. ​							启动 `nginx` 服务器： 					

   ```none
   # systemctl start nginx
   ```

   ​							或者，如果 `nginx` 服务器已在您的系统中运行，请在安装 PHP 后重启 `nginx` 服务： 					

   ```none
   # systemctl restart nginx
   ```

3. ​							启动 `php-fpm` 服务： 					

   ```none
   # systemctl start php-fpm
   ```

4. ​							可选：在引导时启用这两个服务： 					

   ```none
   # systemctl enable php-fpm nginx
   ```

5. ​							要获取 PHP 设置的信息，请在 `/usr/share/nginx/html/` 目录中使用以下内容创建 `index.php` 文件： 					

   ```none
   echo '<?php phpinfo(); ?>' > /usr/share/nginx/html/index.php
   ```

6. ​							要运行 `index.php` 文件，请将浏览器指向： 					

   ```none
   http://<hostname>/
   ```

7. ​							可选：如果您有特定要求，请调整配置： 					

   - ​									`/etc/nginx/nginx.conf` - `nginx` 主配置 							
   - ​									`/etc/nginx/conf.d/php-fpm.conf` - FPM 配置 `nginx` 							
   - ​									`/etc/php-fpm.conf` - FPM 主配置 							
   - ​									`/etc/php-fpm.d/www.conf` - 默认 `www` 池配置 							

**例 5.2. 运行"Hello, World!" 使用 nginx 服务器的 PHP 脚本**

1. ​								在 `/usr/share/nginx/html/` 目录中为您的项目创建一个 `hello` 目录： 						

   ```none
   # mkdir hello
   ```

2. ​								在 `/usr/share/nginx/html/hello/` 目录中创建一个包含以下内容的 `hello.php` 文件： 						

   ```none
   # <!DOCTYPE html>
   <html>
   <head>
   <title>Hello, World! Page</title>
   </head>
   <body>
   <?php
       echo 'Hello, World!';
   ?>
   </body>
   </html>
   ```

3. ​								启动 `nginx` 服务器： 						

   ```none
   # systemctl start nginx
   ```

4. ​								要运行 `hello.php` 文件，请将浏览器指向： 						

   ```none
   http://<hostname>/hello/hello.php
   ```

   ​								因此，会显示带有 "Hello, World!" 文本的网页。 						

**其他资源**

- ​							[设置和配置 NGINX](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/deploying_web_servers_and_reverse_proxies/setting-up-and-configuring-nginx_deploying-web-servers-and-reverse-proxies) 					

## 5.3. 使用命令行界面运行 PHP 脚本

​				PHP 脚本通常使用 Web 服务器运行，但也可以使用 命令行界面来运行。 		

**先决条件**

- ​						在您的系统上安装 PHP 脚本语言。 				

**步骤**

1. ​						在文本编辑器中，创建一个 `*filename*.php` 文件 				

   ​						将 *filename* 替换为您的文件名称。 				

2. ​						从命令行执行创建 `*filename*.php` 文件： 				

   ```none
   # php filename.php
   ```

**例 5.3. 运行"Hello, World!" 使用命令行界面 PHP 脚本**

1. ​							使用文本编辑器，创建包含以下内容的 `hello.php` 文件： 					

   ```none
   <?php
       echo 'Hello, World!';
   ?>
   ```

2. ​							从命令行执行 `hello.php` 文件： 					

   ```none
   # php hello.php
   ```

   ​							结果会输出 "Hello, World!"。 					

## 5.4. 其它资源

- ​						`httpd(8)` - `httpd`服务的手册页，包含其命令行选项的完整列表。 				
- ​						`httpd.conf(5)` - `httpd` 配置的 man page，描述 `httpd` 配置文件的结构和位置。 				
- ​						`nginx(8)` - `nginx` web 服务器的 man page，其中包含其命令行选项的完整列表和信号列表。 				
- ​						`php-fpm(8)` - PHP FPM 的 man page 描述其命令行选项和配置文件的完整列表。 				

​       



## PHP 语法

    <?php
    // PHP 代码
    ?>

PHP 中的每个代码行都必须以分号结束。分号是一种分隔符，用于把指令集区分开来。



## 变量

mp 	变量是用于存储数据的容器。

    PHP 变量
    
    与代数类似，可以给 PHP 变量赋予某个值（x=5）或者表达式（z=x+y）。
    
    变量可以是很短的名称（如 x 和 y）或者更具描述性的名称（如 age、carname、totalvolume）。
    
    PHP 变量规则：
    
        变量以 $ 符号开始，后面跟着变量的名称
        变量名必须以字母或者下划线字符开始
        变量名只能包含字母数字字符以及下划线（A-z、0-9 和 _ ）
        变量名不能包含空格
        变量名是区分大小写的（$y 和 $Y 是两个不同的变量）
    
    lamp 	PHP 语句和 PHP 变量都是区分大小写的。
    创建（声明）PHP 变量
    
    PHP 没有声明变量的命令。
    
    变量在您第一次赋值给它的时候被创建：
    实例
    <?php
    $txt="Hello world!";
    $x=5;
    $y=10.5;
    ?>
    
    运行实例 »
    
    在上面的语句执行中，变量 txt 将保存值 Hello world!，且变量 x 将保存值 5。
    
    注释：当您赋一个文本值给变量时，请在文本值两侧加上引号。
    PHP 是一门弱类型语言
    
    在上面的实例中，我们注意到，不必向 PHP 声明该变量的数据类型。
    
    PHP 会根据变量的值，自动把变量转换为正确的数据类型。
    
    在强类型的编程语言中，我们必须在使用变量前先声明（定义）变量的类型和名称。
    PHP 变量作用域
    
    变量的作用域是脚本中变量可被引用/使用的部分。
    
    PHP 有四种不同的变量作用域：
    
        local
        global
        static
        parameter
    
    局部和全局作用域
    
    在所有函数外部定义的变量，拥有全局作用域。除了函数外，全局变量可以被脚本中的任何部分访问，要在一个函数中访问一个全局变量，需要使用 global 关键字。
    
    在 PHP 函数内部声明的变量是局部变量，仅能在函数内部访问：
    实例
    <?php
    $x=5; // 全局变量
    
    function myTest()
    {
        $y=10; // 局部变量
        echo "<p>测试函数内变量:<p>";
        echo "变量 x 为: $x";
        echo "<br>";
        echo "变量 y 为: $y";
    }
    
    myTest();
    
    echo "<p>测试函数外变量:<p>";
    echo "变量 x 为: $x";
    echo "<br>";
    echo "变量 y 为: $y";
    ?>
    
    运行实例 »
    
    在以上实例中 myTest() 函数定义了 $x 和 $y 变量。 $x 变量在函数外声明，所以它是全局变量 ， $y 变量在函数内声明所以它是局部变量。
    
    当我们调用myTest()函数并输出两个变量的值, 函数将会输出局部变量 $y 的值，但是不能输出 $x 的值，因为 $x 变量在函数外定义，无法在函数内使用，如果要在一个函数中访问一个全局变量，需要使用 global 关键字。
    
    然后我们在myTest()函数外输出两个变量的值，函数将会输出全局部变量 $x 的值，但是不能输出 $y 的值，因为 $y 变量在函数中定义，属于局部变量。
    Note 	你可以在不同函数中使用相同的变量名称，因为这些函数内定义的变量名是局部变量，只作用于该函数内。
    PHP global 关键字
    
    global 关键字用于函数内访问全局变量。
    
    在函数内调用函数外定义的全局变量，我们需要在函数中的变量前加上 global 关键字：
    实例
    <?php
    $x=5;
    $y=10;
    
    function myTest()
    {
    global $x,$y;
    $y=$x+$y;
    }
    
    myTest();
    echo $y; // 输出 15
    ?>
    
    运行实例 »
    
    PHP 将所有全局变量存储在一个名为 $GLOBALS[index] 的数组中。 index 保存变量的名称。这个数组可以在函数内部访问，也可以直接用来更新全局变量。
    
    上面的实例可以写成这样：
    实例
    <?php
    $x=5;
    $y=10;
    
    function myTest()
    {
    $GLOBALS['y']=$GLOBALS['x']+$GLOBALS['y'];
    }
    
    myTest();
    echo $y;
    ?>
    
    运行实例 »
    
    Static 作用域
    
    当一个函数完成时，它的所有变量通常都会被删除。然而，有时候您希望某个局部变量不要被删除。
    
    要做到这一点，请在您第一次声明变量时使用 static 关键字：
    实例
    <?php
    
    function myTest()
    {
    static $x=0;
    echo $x;
    $x++;
    }
    
    myTest();
    myTest();
    myTest();
    
    ?>
    
    运行实例 »
    
    然后，每次调用该函数时，该变量将会保留着函数前一次被调用时的值。
    
    注释：该变量仍然是函数的局部变量。
    参数作用域
    
    参数是通过调用代码将值传递给函数的局部变量。
    
    参数是在参数列表中声明的，作为函数声明的一部分：
    实例
    <?php
    
    function myTest($x)
    {
    echo $x;
    }
    
    myTest(5);
    
    ?>
    
    我们将在 PHP 函数 章节对它做更详细的讨论。

 






FastCGI 进程管理器（FPM）

   FPM（FastCGI 进程管理器）用于替换 PHP FastCGI 的大部分附加功能，对于高负载网站是非常有用的。  

   它的功能包括：   

- ​      支持平滑停止/启动的高级进程管理功能；     
- ​      可以工作于不同的 uid/gid/chroot 环境下，并监听不同的端口和使用不同的 php.ini 配置文件（可取代 safe_mode 的设置）；     
- ​      stdout 和 stderr 日志记录;     
- ​      在发生意外情况的时候能够重新启动并缓存被破坏的 opcode;     
- ​      文件上传优化支持;     
- ​      "慢日志" - 记录脚本（不仅记录文件名，还记录 PHP backtrace 信息，可以使用      ptrace或者类似工具读取和分析远程进程的运行数据）运行所导致的异常缓慢;     
- ​      [fastcgi_finish_request()](https://www.php.net/manual/zh/function.fastcgi-finish-request.php) -       特殊功能：用于在请求完成和刷新数据后，继续在后台执行耗时的工作（录入视频转换、统计处理等）；     
- ​      动态／静态子进程产生；     
- ​      基本 SAPI 运行状态信息（类似Apache的 mod_status）；     
- ​      基于 php.ini 的配置文件。     

### 从源代码编译

​       编译 PHP 时需要 *--enable-fpm* 配置选项来激活 FPM 支持。      

​       以下为 FPM 编译的具体配置参数（全部为可选参数）：      

- ​         *--with-fpm-user* - 设置 FPM 运行的用户身份（默认 - nobody）        
- ​         *--with-fpm-group* - 设置 FPM 运行时的用户组（默认 - nobody）        
- ​         *--with-fpm-systemd* - 启用 systemd 集成 (默认 - no)        
- ​         *--with-fpm-acl* - 使用POSIX 访问控制列表         (默认 - no) 5.6.5版本起有效        



## 配置

   FPM 使用类似 php.ini 语法的 php-fpm.conf 和进程池配置文件。  

### php-fpm.conf 全局配置段

- ​      `pid`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              PID 文件的位置。默认为空。            

- ​      `error_log`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              错误日志的位置。默认：*#INSTALL_PREFIX#/log/php-fpm.log*。       如果设置为 "syslog"，日志将不会写入本地文件，而是发送到 syslogd。            

- ​      `log_level`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              错误级别。可用级别为：alert（必须立即处理），error（错误情况），warning（警告情况），notice（一般重要信息），debug（调试信息）。默认：notice。            

- ​        `syslog.facility`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  设置何种程序记录消息，默认值：daemon。               

- ​        `syslog.ident`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  为每条信息添加前缀。         如果在同一台服务器上运行了多个 FPM 实例，可以修改此默认值来满足需求。默认值：php-fpm。               

- ​      `emergency_restart_threshold`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              如果子进程在 *emergency_restart_interval* 设定的时间内收到该参数设定次数的       SIGSEGV 或者 SIGBUS退出信息号，则FPM会重新启动。0 表示“关闭该功能”。默认值：0（关闭）。            

- ​      `emergency_restart_interval`      [mixed](https://www.php.net/manual/zh/language.pseudo-types.php#language.types.mixed)     

  ​              *emergency_restart_interval*       用于设定平滑重启的间隔时间。这么做有助于解决加速器中共享内存的使用问题。可用单位：s（秒），m（分），h（小时）或者       d（天）。默认单位：s（秒）。默认值：0（关闭）。            

- ​      `process_control_timeout`      [mixed](https://www.php.net/manual/zh/language.pseudo-types.php#language.types.mixed)     

  ​              设置子进程接受主进程复用信号的超时时间。可用单位：s（秒），m（分），h（小时）或者       d（天）。默认单位：s（秒）。默认值：0（关闭）。            

- ​        `process.max`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                  Fork 的最大 FPM 进程数。使用动态管理进程数时，此设计可以控制在一个进程池内的全局进程数量。         使用需谨慎。默认值：0。               

- ​        `process.priority`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                  设置 master 进程的 nice(2) 优先级（如果设置了此值）。         可以是 -19（最高优先级）到 20 （更低优先级）。         默认值：不设置。               

- ​      `daemonize`      [boolean](https://www.php.net/manual/zh/language.types.boolean.php)     

  ​              设置 FPM 在后台运行。设置“no”将 FPM 保持在前台运行用于调试。默认值：yes。            

- ​        `rlimit_files`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                    设置 master 进程的打开文件描述符 rlimit 数。               

- ​        `rlimit_core`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                  设置 master 进程最大 core 的 rlimit 尺寸。         默认值：0。               

- ​        `events.mechanism`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  设置 FPM 使用的事件机制。         可用以下选项：select、pool、epoll、kqueue (*BSD)、port (Solaris)。         默认值：不设置（自动检测）               

- ​        `systemd_interval`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                  使用 systemd 集成的 FPM 时，设置间歇秒数，报告健在通知给 systemd。         设置为 0 表示禁用。默认值：10。               

### 运行配置区段

​    在FPM中，可以使用不同的设置来运行多个进程池。    这些设置可以针对每个进程池单独设置。    

- ​      `listen`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              设置接受 FastCGI 请求的地址。可用格式为：'ip:port'，'port'，'/path/to/unix/socket'。每个进程池都需要设置。            

- ​      `listen.backlog`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置 listen(2) 的 backlog 最大值。“-1”表示无限制。默认值：-1。            

- ​      `listen.allowed_clients`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              设置允许连接到 FastCGI 的服务器 IPV4 地址。等同于 PHP FastCGI (5.2.2+) 中的 FCGI_WEB_SERVER_ADDRS       环境变量。仅对 TCP 监听起作用。每个地址是用逗号分隔，如果没有设置或者为空，则允许任何服务器请求连接。默认值：any。         PHP 5.5.20 和 5.6.4起，开始支持 IPv6 地址。            

- ​      `listen.owner`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              如果使用了 Unix 套接字，表示它的权限。在 Linux 中必须设置读/写权限，以便用于       WEB 服务器连接。       在很多 BSD 派生的系统中可以忽略权限允许自由连接。       默认值：运行所使用的用户和组，权限为 0660。            

- ​      `listen.group`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              参见 *listen.owner*。            

- ​      `listen.mode`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              参见 *listen.owner*。            

- ​        `listen.acl_users`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  当系统支持 POSIX ACL（Access Control Lists）时，可以设置使用此选项。         当设置了的时候，将会忽略 *listen.owner* 和 *listen.group*。         值是逗号分割的用户名列表。 PHP 5.6.5 起可用。               

- ​        `listen.acl_groups`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  参见 *listen.acl_users*。         值是逗号分割的用户组名称列表。 PHP 5.6.5 起可用。               

- ​      `user`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              FPM 进程运行的Unix用户。必须设置。            

- ​      `group`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              FPM 进程运行的 Unix 用户组。如果不设置，就使用默认用户的用户组。            

- ​      `pm`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              设置进程管理器如何管理子进程。可用值：*static*，*ondemand*，*dynamic*。必须设置。                   *static* - 子进程的数量是固定的（*pm.max_children*）。                   *ondemand* - 进程在有需求时才产生（当请求时才启动。与       dynamic 相反，在服务启动时 *pm.start_servers* 就启动了。                   *dynamic* -        子进程的数量在下面配置的基础上动态设置：*pm.max_children*，*pm.start_servers*，*pm.min_spare_servers*，*pm.max_spare_servers*。           

- ​      `pm.max_children`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              *pm* 设置为 *static*       时表示创建的子进程的数量，*pm* 设置为        *dynamic* 时表示最大可创建的子进程的数量。必须设置。                   该选项设置可以同时提供服务的请求数限制。类似 Apache 的 mpm_prefork 中 MaxClients       的设置和 普通PHP FastCGI中的 PHP_FCGI_CHILDREN 环境变量。           

- ​      `pm.start_servers`      in     

  ​              设置启动时创建的子进程数目。仅在 *pm* 设置为       *dynamic* 时使用。默认值：min_spare_servers + (max_spare_servers -       min_spare_servers) / 2。            

- ​      `pm.min_spare_servers`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置空闲服务进程的最低数目。仅在 *pm* 设置为 *dynamic* 时使用。必须设置。            

- ​      `pm.max_spare_servers`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置空闲服务进程的最大数目。仅在 *pm* 设置为 *dynamic* 时使用。必须设置。            

- ​        `pm.process_idle_timeout`        [mixed](https://www.php.net/manual/zh/language.pseudo-types.php#language.types.mixed)       

  ​                  秒数，多久之后结束空闲进程。         仅当设置 *pm* 为 *ondemand*。         可用单位：s（秒），m（分），h（小时）或者       d（天）。默认单位：10s。               

- ​      `pm.max_requests`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置每个子进程重生之前服务的请求数。对于可能存在内存泄漏的第三方模块来说是非常有用的。如果设置为       '0' 则一直接受请求，等同于 PHP_FCGI_MAX_REQUESTS 环境变量。默认值：0。            

- ​      `pm.status_path`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              FPM 状态页面的网址。如果没有设置，则无法访问状态页面，默认值：无。            

- ​      `ping.path`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              FPM 监控页面的 ping 网址。如果没有设置，则无法访问 ping       页面。该页面用于外部检测 FPM 是否存活并且可以响应请求。请注意必须以斜线开头（/）。            

- ​      `ping.response`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              用于定义 ping 请求的返回响应。返回为 HTTP 200 的 text/plain 格式文本。默认值：pong。            

- ​        `process.priority`        [int](https://www.php.net/manual/zh/language.types.integer.php)       

  ​                  设置 worker 的 nice(2)优先级（如果设置了的话）。         该值从 -19（最高优先级） 到 20（更低优先级）。         默认值：不设置               

- ​        `prefix`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  检测路径时使用的前缀。               

- ​      `request_terminate_timeout`      [mixed](https://www.php.net/manual/zh/language.pseudo-types.php#language.types.mixed)     

  ​              设置单个请求的超时中止时间。该选项可能会对 php.ini 设置中的 'max_execution_time'       因为某些特殊原因没有中止运行的脚本有用。设置为 '0' 表示 'Off'。可用单位：s（秒），m（分），h（小时）或者       d（天）。默认单位：s（秒）。默认值：0（关闭）。            

- ​      `request_slowlog_timeout`      [mixed](https://www.php.net/manual/zh/language.pseudo-types.php#language.types.mixed)     

  ​              当一个请求该设置的超时时间后，就会将对应的 PHP 调用堆栈信息完整写入到慢日志中。设置为       '0' 表示 'Off'。可用单位：s（秒），m（分），h（小时）或者       d（天）。默认单位：s（秒）。默认值：0（关闭）。            

- ​      `slowlog`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              慢请求的记录日志。默认值：*#INSTALL_PREFIX#/log/php-fpm.log.slow*。            

- ​      `rlimit_files`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置文件打开描述符的 rlimit 限制。默认值：系统定义值。            

- ​      `rlimit_core`      [int](https://www.php.net/manual/zh/language.types.integer.php)     

  ​              设置核心 rlimit 最大限制值。可用值：'unlimited'，0 或者正整数。默认值：系统定义值。            

- ​      `chroot`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              启动时的 Chroot 目录。所定义的目录需要是绝对路径。如果没有设置，则 chroot 不被使用。            

- ​      `chdir`      [string](https://www.php.net/manual/zh/language.types.string.php)     

  ​              设置启动目录，启动时会自动 Chdir 到该目录。所定义的目录需要是绝对路径。默认值：当前目录，或者根目录（chroot时）。            

- ​      `catch_workers_output`      [boolean](https://www.php.net/manual/zh/language.types.boolean.php)     

  ​              重定向运行过程中的 stdout 和 stderr 到主要的错误日志文件中。如果没有设置，stdout       和 stderr 将会根据 FastCGI 的规则被重定向到 /dev/null。默认值：无。            

- ​        `clear_env`        [boolean](https://www.php.net/manual/zh/language.types.boolean.php)       

  ​                  为 FPM worker 进程清除环境变量。         在进程池配置文件里设置环境变量前，阻止任意系统的环境变量进入 FPM worker 进程。         自 PHP 5.4.27、 5.5.11 和 5.6.0 起。         默认值: Yes               

- ​        `security.limit_extensions`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  限制 FPM 允许解析的脚本扩展名。         此设置可以预防 web 服务器配置的错误。         应当限制 FPM 仅仅解析 .php 扩展名，阻止恶意用户使用其他扩展名运行 php 代码。         默认值： .php .phar               

- ​        `access.log`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  Access log 文件。         默认值：不设置               

- ​        `access.format`        [string](https://www.php.net/manual/zh/language.types.string.php)       

  ​                  access log 的格式。         默认值: "%R - %u %t \"%m %r\" %s"               

​    还可以在为一个运行池传递附加的环境变量，或者更新 PHP    的配置值。可以在进程池配置文件中如下面的配置参数来做到：    

**Example #1 给运行池传递环境变量和设置 PHP 的配置值**

```
env[HOSTNAME] = $HOSTNAME
       env[PATH] = /usr/local/bin:/usr/bin:/bin
       env[TMP] = /tmp
       env[TMPDIR] = /tmp
       env[TEMP] = /tmp

       php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
       php_flag[display_errors] = off
       php_admin_value[error_log] = /var/log/fpm-php.www.log
       php_admin_flag[log_errors] = on
       php_admin_value[memory_limit] = 32M
```

​      PHP配置值通过 

php_value

 或者      

php_flag

 设置，并且会覆盖以前的值。请注意       

disable_functions

 或者       

disable_classes

 在      

php.ini

 之中定义的值不会被覆盖掉，但是会将新的设置附加在原有值的后面。          

​      使用 *php_admin_value* 或者 *php_admin_flag*      定义的值，不能被 PHP 代码中的 [ini_set()](https://www.php.net/manual/zh/function.ini-set.php) 覆盖。     

​      自 5.3.3 起，也可以通过 web 服务器设置 PHP 的设定。      

**Example #2 在 nginx.conf 中设定 PHP**

```
set $php_value "pcre.backtrack_limit=424242";
set $php_value "$php_value \n pcre.recursion_limit=99999";
fastcgi_param  PHP_VALUE $php_value;

fastcgi_param  PHP_ADMIN_VALUE "open_basedir=/var/www/htdocs";
```

Caution

​        由于这些设定是以 FastCGI 标头传递给 php-fpm，php-fpm        不应绑定到外部网可以访问的地址上，否则任何人都能修改 PHP        的配置选项了。参见        [listen.allowed_clients](https://www.php.net/manual/zh/install.fpm.configuration.php#listen-allowed-clients)。       

## 连接 MySQL

PHP 提供了 mysqli_connect() 函数来连接数据库。该函数有 6 个参数，在成功链接到 MySQL 后返回连接标识，失败返回 FALSE 。 

### 语法

```
mysqli_connect(host,username,password,dbname,port,socket);
```

**参数说明：**

| 参数       | 描述                                        |
| ---------- | ------------------------------------------- |
| *host*     | 可选。规定主机名或 IP 地址。                |
| *username* | 可选。规定 MySQL 用户名。                   |
| *password* | 可选。规定 MySQL 密码。                     |
| *dbname*   | 可选。规定默认使用的数据库。                |
| *port*     | 可选。规定尝试连接到 MySQL 服务器的端口号。 |
| *socket*   | 可选。规定 socket 或要使用的已命名 pipe。   |

可以使用 PHP 的 mysqli_close() 函数来断开与 MySQL 数据库的链接。该函数只有一个参数为 mysqli_connect() 函数创建连接成功后返回的 MySQL 连接标识符。

### 语法

```
bool mysqli_close ( mysqli $link )
```

本函数关闭指定的连接标识所关联的到 MySQL 服务器的非持久连接。如果没有指定 link_identifier，则关闭上一个打开的连接。

 **提示：**通常不需要使用 mysqli_close()，因为已打开的非持久连接会在脚本执行完毕后自动关闭。

### 实例

```php
<?php
    $dbhost = 'localhost';  // mysql服务器主机地址
    $dbuser = 'root';       // mysql用户名
    $dbpass = '123456';          // mysql用户名密码 
    $conn = mysqli_connect($dbhost, $dbuser, $dbpass);
    if(! $conn )
    {     
        die('Could not connect: ' . mysqli_error()); 
    } 
    echo '数据库连接成功！'; 
    mysqli_close($conn); 
?>
```

