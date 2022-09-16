# Rsyslog

[TOC]

## 概述

Rsyslog 是一个开源的日志记录程序。提供了一种从客户端节点到单个中央服务器的“集中日志”的简单有效的方法。

日志集中化有两个好处：

* 简化了日志查看，因为系统管理员可以在一个中心节点查看远程服务器的所有日志，而无需登录每个客户端系统来检查日志。如果需要监视多台服务器，这将非常有用。
* 其次，如果远程客户端崩溃，你不用担心丢失日志，因为所有日志都将保存在中心的 Rsyslog 服务器上。rsyslog 取代了仅支持 UDP 协议的 syslog。它以优异的功能扩展了基本的 syslog  协议，例如在传输日志时支持 UDP 和 TCP 协议，增强的过滤功能以及灵活的配置选项。

Rsyslog is a rocket-fast system for log processing. It offers high-performance, great security features and a modular design. While it started as a regular syslogd, rsyslog has evolved into a kind of swiss army knife of logging, being able to   accept inputs from a wide variety of sources, transform them,and output the results to diverse destinations.

Rsyslog has a strong enterprise focus but also scales down to small systems. It supports, among others, MySQL , PostgreSQL, failover log destinations, syslog/tcp transport, fine grain output format control, high precision timestamps, queued operations and the ability to filter on any message part.

## 配置服务器

默认情况下，Rsyslog 已安装在 CentOS 8 / RHEL 8 服务器上。

```bash
# CentOS 8
yum install rsyslog
systemctl enable rsyslog
systemctl start rsyslog
systemctl status rsyslog
```

修改 Rsyslog 配置文件

```bash
vim /etc/rsyslog.conf
# 取消注释下面的行，以允许通过 UDP 协议接收日志
module(load="imudp") # needs to be done just onceinput(type="imudp" port="514")
# 取消注释下面的行，以允许通过 TCP 协议接收日志
module(load="imtcp") # needs to be done just onceinput(type="imtcp" port="514")
```

在防火墙上打开 Rsyslog 默认端口 514。

```bash
firewall-cmd  --add-port=514/tcp  --zone=public  --permanent
firewall-cmd --reload
```

重启 Rsyslog 服务器

```bash
systemctl restart rsyslog
```

## 配置客户端

```bash
systemctl status rsyslog
```

打开 rsyslog 配置文件

```bash
vim /etc/rsyslog.conf
```

在文件末尾，添加以下行：

```
*.* @10.128.0.47:514           # Use @ for UDP protocol*.* @@10.128.0.47:514          # Use @@ for TCP protocol
```

保存并退出配置文件。就像 Rsyslog 服务器一样，打开 514 端口，这是防火墙上的默认 Rsyslog 端口：

```
$ sudo firewall-cmd  --add-port=514/tcp  --zone=public  --permanent
```

接下来，重新加载防火墙以保存更改：

```
$ sudo firewall-cmd --reload
```

接下来，重启 rsyslog 服务：

```
$ sudo systemctl restart rsyslog
```

要在启动时运行 Rsyslog，请运行以下命令：

```
$ sudo systemctl enable rsyslog
```

### 测试日志记录操作

已经成功安装并配置 Rsyslog 服务器和客户端后，就该验证你的配置是否按预期运行了。

在客户端系统上，运行以下命令：

```
# logger "Hello guys! This is our first log"
```

现在进入 Rsyslog 服务器并运行以下命令来实时查看日志消息：

```
# tail -f /var/log/messages
```

客户端系统上命令运行的输出显示在了 Rsyslog 服务器的日志中，这意味着 Rsyslog 服务器正在接收来自客户端系统的日志
