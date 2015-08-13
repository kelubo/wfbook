---
title: Installation
---

本文提供下载和启动InfluxDB Version 0.9.2的指导。

## 要求
安装预编译版本的InfluxDB软件包，需要主机的管理员权限。

### 网络
默认情况下InfluxDB将使用TCP端口`8083`和`8086`，所以这些端口应该在你的系统中开放。一旦安装完成，你可以在配置文件中修改这些端口和其他选项。配置文件默认存放于`/etc/opt/influxdb`。

## Ubuntu & Debian
Debian用户可通过下载软件包安装0.9.2 ，如下：

```bash
# 64-bit system install instructions
wget http://influxdb.s3.amazonaws.com/influxdb_0.9.2_amd64.deb
sudo dpkg -i influxdb_0.9.2_amd64.deb
```

通过运行如下命令启动守护进程：

```sh
sudo /etc/init.d/influxdb start
```

## RedHat & CentOS
RedHat和CentOS用户可以下载和安装rpm包，如下：

```bash
# 64-bit system install instructions
wget http://influxdb.s3.amazonaws.com/influxdb-0.9.2-1.x86_64.rpm
sudo yum localinstall influxdb-0.9.2-1.x86_64.rpm
```

通过运行如下命令启动守护进程：

```sh
sudo /etc/init.d/influxdb start
```

## OS X

OS X 10.8和更高版本的用户可以使用[Homebrew](http://brew.sh/)软件包管理器安装。

```sh
brew update
brew install influxdb
```

<a href="getting_started.html"><font size="6"><b>⇒ Now get started!</b></font></a>


## 服务器托管

For users who don't want to install any software and are ready to use InfluxDB, you may want to check out our [managed hosted InfluxDB offering](http://customers.influxdb.com). 

## 生成一个配置文件

所有InfluxDB软件包附带一个示例配置文件。另外，在任何时候使用命令`influxd config`可以显示一个有效的配置文件。重定向输出内容到一个文件，可以生成一个整洁的配置文件。

## 开发版本

Nightly packages are available and can be found on the [downloads page](/download/index.html)
