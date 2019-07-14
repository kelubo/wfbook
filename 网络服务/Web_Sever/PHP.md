# PHP

## 安装
```bash
yum install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
```
### PHP 7

```bash
yum install php70w.x86_64
```

安装php-fpm：

```bash
yum install php70w-fpm php70w-opcache
```

启动php-fpm：

```bash
systemctl start php-fpm
systemctl enable php-fpm
```