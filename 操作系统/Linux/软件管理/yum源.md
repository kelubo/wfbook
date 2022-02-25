# YUM 源

[TOC]

## 源服务器部署

### 系统分区建议

建议/var分区空间尽可能大一些，以便于存放需要的源文件。

### 安装HTTP服务

    yum install httpd
    systemctl start httpd.service
    systemctl enable httpd.service

### 同步YUM源文件

    mkdir /var/www/html/centos
    #存放YUM源相关文件
    touch /var/www/html/centos/exclude.txt
    #排除项，用于排除不想同步的文件，例如iso等。
    rsync -av --exclude-from=/var/www/html/centos/exclude.txt rsync://mirrors.yun-idc.com/centos /var/www/html/centos
    #进行同步操作

## RHEL 8.0

- BaseOS
- AppStream

## 第三方源

### EPEL (**E**xtra **P**ackages for **E**nterprise **L**inux) 

```bash
# 安装
dnf install epel-release

# 如果存在代理，先设置变量
export http_proxy=http://172.16.1.10:8080
```

### Remi

### RPMForge