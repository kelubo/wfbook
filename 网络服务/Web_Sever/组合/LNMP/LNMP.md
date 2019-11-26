# Linux + Apache + Nginx + MySQL + PHP

本文件中，各个服务器均**分离**部署。也可以安装在一台服务器上。

## LNMP

1

2

3

## Nginx

### 1. CentOS 7.7

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
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

安装nginx

```bash
yum-config-manager --disable nginx-stable && yum-config-manager --enable  nginx-mainline
yum makecache
yum install nginx
systemctl enable nginx
systemctl start nginx
```

配置文件

```bash
/etc/nginx/nginx.conf
/etc/nginx/conf.d/
/etc/nginx/conf.d/default.conf
```
## PHP (5.6)

### CentOS

#### 配置yum源

CentOS 6.5的epel及remi源。

```shell
rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
```

CentOS 7.0的源。

```bash
yum install epel-release
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
```

CentOS 8.0

```
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

启用remi源

```bash
rm /etc/yum.repo.d/remi.repo
mv /etc/yum.repo.d/remi.repo.rpmnew remi.repo
# Ucloud配置修改
yum-config-manager --enablerepo=remi --enablerepo=remi-php56
# CentOS 8
yum-config-manager --enablerepo=remi
```

#### 安装PHP5.6 + php-fpm

```shell
yum install php php-fpm
```

用PHP命令查看版本。

```shell
php --version
```

启动 php-fpm

```bash
systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm
```

#### 模块

**mysqli**

yum install php-mysqlnd php-mbstring php-pecl-redis php-ZendFramework

#### Nginx 配置文件


修改 /etc/nginx/conf.d/default.conf 文件：

```bash
location ~ \.php$ {
        root           /usr/share/nginx/html;
        # php-fpm 服务器上*.php页面文件存放路径
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
```

重启nginx：

```bash
nginx -s reload
```

