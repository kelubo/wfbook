# Lighttpd Web 服务器
## 安装
CentOS 7

    # yum install epel-release
    # yum update
    # yum install lighttpd

Ubuntu 15.04

    # apt-get update
    # apt-get install lighttpd

从源代码安装 Lighttpd

    # cd /tmp/
    # wget http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.39.tar.gz

解压缩。

    # tar -zxvf lighttpd-1.4.39.tar.gz

编译。

    # cd lighttpd-1.4.39
    # ./configure
    # make

安装

    # make install

## 设置 Lighttpd

/etc/lighttpd/lighttpd.conf  
检查设置文件是否出错，可以执行下面的指令。

    # lighttpd -t -f /etc/lighttpd/lighttpd.conf

使用 CentOS 7

在 CentOS 7 中，我们需创建一个在 Lighttpd 默认配置文件中设置的 webroot 文件夹，例如/src/www/htdocs。

    # mkdir -p /srv/www/htdocs/

而后将默认欢迎页面从/var/www/lighttpd复制至刚刚新建的目录中：

    # cp -r /var/www/lighttpd/* /srv/www/htdocs/

开启服务

现在，通过执行 systemctl 指令来重启 Web 服务。

    # systemctl start lighttpd

然后我们将它设置为伴随系统启动自动运行。

    # systemctl enable lighttpd

设置防火墙

如要让我们运行在 Lighttpd 上的网页或网站能在 Internet 或同一个网络内被访问，我们需要在防火墙程序中设置打开 80 端口。由于 CentOS 7 和 Ubuntu15.04 都附带 Systemd 作为默认初始化系统，所以我们默认用的都是 firewalld。如果要打开 80 端口或 http 服务，我们只需执行下面的命令：

    # firewall-cmd --permanent --add-service=http
    success
    # firewall-cmd --reload
    success

连接至 Web 服务器

在将 80 端口设置为默认端口后，我们就可以直接访问 Lighttpd 的默认欢迎页了。我们需要根据运行 Lighttpd 的设备来设置浏览器的 IP 地址和域名。在本教程中，我们令浏览器访问 http://lighttpd.linoxide.com/ ，同时将该子域名指向上述 IP 地址。如此一来，我们就可以在浏览器中看到如下的欢迎页面了。

Lighttpd Welcome Page

Lighttpd Welcome Page

此外，我们可以将网站的文件添加到 webroot 目录下，并删除 Lighttpd 的默认索引文件，使我们的静态网站可以在互联网上访问。

如果想在 Lighttpd Web 服务器中运行 PHP 应用，请参考下面的步骤：
安装 PHP5 模块

在 Lighttpd 成功安装后，我们需要安装 PHP 及相关模块，以在 Lighttpd 中运行 PHP5 脚本。
使用 Ubuntu 15.04

    # apt-get install php5 php5-cgi php5-fpm php5-mysql php5-curl php5-gd php5-intl php5-imagick php5-mcrypt php5-memcache php-pear

使用 CentOS 7

    # yum install php php-cgi php-fpm php-mysql php-curl php-gd php-intl php-pecl-imagick php-mcrypt php-memcache php-pear lighttpd-fastcgi

设置 Lighttpd 的 PHP 服务

如要让 PHP 与 Lighttpd 协同工作，我们只要根据所使用的发行版执行如下对应的指令即可。
使用 CentOS 7

首先要做的便是使用文件编辑器编辑 php 设置文件（例如/etc/php.ini）并取消掉对cgi.fix_pathinfo=1这一行的注释。

    # nano /etc/php.ini

完成上面的步骤之后，我们需要把 PHP-FPM 进程的所有权从 Apache 转移至 Lighttpd。要完成这些，首先用文件编辑器打开/etc/php-fpm.d/www.conf文件。

    # nano /etc/php-fpm.d/www.conf

然后在文件中增加下面的语句：

    user = lighttpd
    group = lighttpd

做完这些，我们保存并退出文本编辑器。然后从/etc/lighttpd/modules.conf设置文件中添加 FastCGI 模块。

    # nano /etc/lighttpd/modules.conf

然后，去掉下面语句前面的#来取消对它的注释。

include "conf.d/fastcgi.conf"

最后我们还需在文本编辑器设置 FastCGI 的设置文件。

    # nano /etc/lighttpd/conf.d/fastcgi.conf

在文件尾部添加以下代码：

    fastcgi.server += ( ".php" =>
    ((
    "host" => "127.0.0.1",
    "port" => "9000",
    "broken-scriptfilename" => "enable"
    ))
    )

在编辑完成后保存并退出文本编辑器即可。
使用 Ubuntu 15.04

如需启用 Lighttpd 的 FastCGI，只需执行下列代码：

    # lighttpd-enable-mod fastcgi
    Enabling fastcgi: ok
    Run /etc/init.d/lighttpd force-reload to enable changes
    # lighttpd-enable-mod fastcgi-php
    Enabling fastcgi-php: ok
    Run `/etc/init.d/lighttpd` force-reload to enable changes

然后，执行下列命令来重启 Lighttpd。

    # systemctl force-reload lighttpd
