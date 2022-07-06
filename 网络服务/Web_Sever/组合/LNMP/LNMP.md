# Linux + Apache + Nginx + MySQL + PHP

[TOC]

本文件中，各个服务器均**分离**部署。当然也可以安装在一台服务器上。

## 软件安装

### Nginx（CentOS 7.7）

#### 配置源

CentOS 自带的版本较低，使用官方的 yum repo 安装。

```bash
yum install yum-utils
```

新建 nginx.repo (/etc/yum.repos.d/) 文件，内容如下:

```bash
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

#### 安装

```bash
yum-config-manager --disable nginx-stable && yum-config-manager --enable  nginx-mainline
yum makecache
yum install nginx -y && systemctl enable nginx && systemctl start nginx
```

#### 配置防火墙

```bash
firewall-cmd --permanent --add-port={80/tcp,443/tcp}
firewall-cmd --reload
```

#### 验证

```bash
dnf list installed nginx

firewall-cmd --list-ports

systemctl is-enabled nginx
```

#### 配置文件

```bash
/etc/nginx/nginx.conf
/etc/nginx/conf.d/
/etc/nginx/conf.d/default.conf
```
Nginx 无需存放项目文件，配置文件中指定路径即可。

### PHP (5.6)

#### 配置yum源

CentOS 6.5的epel及remi源

```shell
rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
```

CentOS 7.0

```bash
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
```

CentOS 8.0

```bash
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

启用remi源

```bash
rm /etc/yum.repo.d/remi.repo
mv /etc/yum.repo.d/remi.repo.rpmnew remi.repo
# Ucloud配置修改
yum-config-manager --enable remi --enable remi-php56
# CentOS 8
yum-config-manager --enable remi
```

#### 安装PHP5.6 + php-fpm

```bash
yum install php php-fpm
```

用PHP命令查看版本。

```bash
php --version
```

启动 php-fpm

```bash
systemctl start php-fpm && systemctl enable php-fpm
```

#### 模块

```bash
yum install php-mysqlnd php-mbstring php-pecl-redis php-ZendFramework//应该无用 php-opcache//应该无用 php-gd php-xml
```

#### 项目目录

创建项目目录。

## 配置

![](..\..\..\..\Image\n\nginx_phpfpm1.PNG)

### 单节点

#### Nginx


/etc/nginx/conf.d/default.conf 

```bash
location ~ \.php$ {
        root           /usr/share/nginx/html;
        # php-fpm 服务器上*.php页面文件存放路径
        fastcgi_pass   10.0.0.2:9000;
        fastcgi_index  index.php;
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
```

#### php-fpm

 /etc/php-fpm.d/www.conf

```bash
listen = 10.0.0.2:9000
listen.allowed_clients = 10.0.0.1
```

![](..\..\..\..\Image\n\nginx_phpfpm2.PNG)

### 多节点

#### Nginx

/etc/nginx/nginx.conf

```bash
upstream php-fpm-backend {
    server 10.0.0.2:9000;
    server 10.0.0.3:9000;
}
```


/etc/nginx/conf.d/default.conf ：

```bash
location ~ \.php$ {
        root           /usr/share/nginx/html;
        # php-fpm 服务器上*.php页面文件存放路径
        fastcgi_pass   php-fpm-backend;
        fastcgi_index  index.php;
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
```

#### php-fpm

 /etc/php-fpm.d/www.conf

```bash
listen = 10.0.0.2:9000
listen.allowed_clients = 10.0.0.1
```

```bash
listen = 10.0.0.3:9000
listen.allowed_clients = 10.0.0.1
```