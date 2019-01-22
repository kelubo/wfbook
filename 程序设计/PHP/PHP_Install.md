# PHP 安装

## CentOS

### 配置yum源

CentOS 6.5的epel及remi源。

```shell
# rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
# rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
```

CentOS 7.0的源。

```shell
# yum install epel-release
# rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
```

使用yum list命令查看可安装的包(Packege)。

```shell
# yum list --enablerepo=remi --enablerepo=remi-php56 | grep php
```

### 安装PHP5.6

```shell
# yum install --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof
```

用PHP命令查看版本。

```shell
# php --version
```

