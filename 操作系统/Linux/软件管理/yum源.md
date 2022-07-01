# YUM 源

[TOC]

## 源服务器部署

### 系统分区建议

建议 `/var` 分区空间尽可能大一些，以便于存放需要的源文件。

### 安装HTTP服务

```bash
yum install httpd
systemctl start httpd.service
systemctl enable httpd.service
```

### 同步YUM源文件

```bash
mkdir /var/www/html/centos
#存放YUM源相关文件
touch /var/www/html/centos/exclude.txt
#排除项，用于排除不想同步的文件，例如iso等。
rsync -av --exclude-from=/var/www/html/centos/exclude.txt rsync://mirrors.yun-idc.com/centos /var/www/html/centos
#进行同步操作
```

## RHEL 8.0 / CentOS Stream 8 / CentOS Stream 8

- BaseOS

  提供底层操作系统功能的核心组件，为所有安装提供基础操作系统的基础。这部分内容采用 RPM 格式，它的支持条款与之前的 RHEL 版本相似。

- AppStream

  内容包括额外的用户空间应用程序、运行时语言和数据库来支持各种工作负载和使用案例。
  
- CodeReady Linux Builder

  包含供开发人员使用的额外软件包。这个软件仓库包括在所有 Red Hat Enterprise Linux 订阅中，但不需要在运行时部署中启用。不支持包括在 CodeReady Linux Builder 存储库中的软件包。
  
- Supplementary

  包括没有包括在开源 Red Hat Enterprise Linux 软件仓库中的专有许可软件包。Supplementary 软件仓库中的软件包不被支持，且没有 ABIs 保证。不支持由属于 Supplementary 存储库的软件包造成的问题。

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