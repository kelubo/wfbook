# 安装

## 配置源

CentOS 自带的版本较低，使用官方的 yum repo 安装。

```bash
yum install yum-utils
```

新建 nginx.repo ( /etc/yum.repos.d/ ) 文件，内容如下:

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

## 安装

```bash
yum-config-manager --disable nginx-stable && yum-config-manager --enable  nginx-mainline
yum makecache
yum install nginx -y

systemctl enable nginx && systemctl start nginx
# OR
systemctl enable --now nginx
```

## 配置防火墙

```bash
# 两种方式：
firewall-cmd --permanent --zone=public --add-port={80/tcp,443/tcp}

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

firewall-cmd --reload
```

## 验证

```bash
dnf list installed nginx

firewall-cmd --list-ports

systemctl is-enabled nginx
```

 ![](../../../Image/w/welcome-nginx.png)