# Linux + Apache + Nginx + MySQL + PHP

## LNMP

1

2

3

## Nginx安装

### CentOS 7.7

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

### Debian

```bash
apt install curl gnupg2 ca-certificates lsb-release

# use stable nginx packages
echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
# use mainline nginx packages
echo "deb http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt-key fingerprint ABF5BD827BD9BF62

apt-get update
apt-get install nginx
```

### Ubuntu


```bash
sudo apt install curl gnupg2 ca-certificates lsb-release

# stable nginx packages
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx"   | sudo tee /etc/apt/sources.list.d/nginx.list
# mainline nginx packages
echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx"   | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62

sudo apt update
sudo apt install nginx
```

### FreeBSD

```bash
pkg_install -r nginx
```

### SLES

```bash
sudo zypper install curl ca-certificates gpg2

# stable nginx packages
sudo zypper addrepo --gpgcheck --type yum --refresh --check 'http://nginx.org/packages/sles/$releasever' nginx-stable

# mainline nginx packages
sudo zypper addrepo --gpgcheck --type yum --refresh --check  'http://nginx.org/packages/mainline/sles/$releasever' nginx-mainline

curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key

gpg --with-fingerprint /tmp/nginx_signing.key

sudo rpmkeys --import /tmp/nginx_signing.key

sudo zypper install nginx
```

### Alpine

```bash
sudo apk add openssl curl ca-certificates

# stable nginx packages
# 格式可能异常，需要确认
printf "%s%s%s\n" "http://nginx.org/packages/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` "/main" | sudo tee -a /etc/apk/repositories

# mainline nginx packages
# 格式可能异常，需要确认
printf "%s%s%s\n" "http://nginx.org/packages/mainline/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` "/main" | sudo tee -a /etc/apk/repositories

curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub

openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout

sudo mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

sudo apk add nginx
```

## PHP

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
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
```

使用yum list命令查看可安装的包(Package)。

```bash
yum list --enablerepo=remi --enablerepo=remi-php56 | grep php
```

#### 安装PHP5.6 + php-fpm

```shell
yum install --enablerepo=remi --enablerepo=remi-php56 php php-fpm
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

yum install php-mysqlnd php-mbstring php-pecl-redis
