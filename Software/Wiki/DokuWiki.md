# DokuWiki
## 需求
    PHP 5.3.4 或更高版本（建议使用 PHP 7+）
    一台 web 服务器（Apache/Nginx/任何其他）
## 安装
1.升级系统

    sudo apt-get update && sudo apt-get upgrade
2.安装 Apache

    apt-get install apache2
3.安装 PHP7 和模块

    apt-get install php7.0-fpm php7.0-cli php-apcu php7.0-gd php7.0-xml php7.0-curl php7.0-json php7.0-mcrypt php7.0-cgi php7.0 libapache2-mod-php7.0

4.下载安装 DokuWiki  
创建一个目录：

    mkdir -p /var/www/thrwiki

进入刚才创建的目录：

    cd /var/www/thrwiki

运行下面的命令来下载最新（稳定）的 DokuWiki：

    wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz

解压 .tgz 文件：

    tar xvf dokuwiki-stable.tgz

更改文件/文件夹权限：

    www-data:www-data -R /var/www/thrwiki
    chmod -R 707 /var/www/thrwiki

为 DokuWiki 配置 Apache

为你的 DokuWiki 创建一个 .conf 文件（我们把它命名为 thrwiki.conf，但是你可以把它命名成任何你想要的），并用你喜欢的文本编辑器打开。我们使用 nano：

    touch /etc/apache2/sites-available/thrwiki.conf
    ln -s /etc/apache2/sites-available/thrwiki.conf /etc/apache2/sites-enabled/thrwiki.conf
    nano /etc/apache2/sites-available/thrwiki.conf

下面是 thrwiki.conf 中的内容：

    <VirtualHost yourServerIP:80>
      ServerAdmin wikiadmin@thishosting.rocks
      DocumentRoot /var/www/thrwiki/
      ServerName wiki.thishosting.rocks
      ServerAlias www.wiki.thishosting.rocks
      <Directory /var/www/thrwiki/>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>
      ErrorLog /var/log/apache2/wiki.thishosting.rocks-error_log
      CustomLog /var/log/apache2/wiki.thishosting.rocks-access_log common
    </VirtualHost>

编辑与你服务器相关的行。将 wikiadmin@thishosting.rocks、wiki.thishosting.rocks 替换成你自己的数据，重启 apache 使更改生效：

    systemctl restart apache2.service

就是这样了。现在已经配置完成了。现在你可以继续通过前端页面 http://wiki.thishosting.rocks/install.php 安装配置 DokuWiki 了。安装完成后，你可以用下面的命令删除 install.php：

    rm -f /var/www/html/thrwiki/install.php
