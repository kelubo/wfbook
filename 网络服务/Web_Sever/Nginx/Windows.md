# Windows

[TOC]

## 概述

适用于 Windows 的 nginx 版本使用 native Win32 API（而不是 Cygwin 仿真层）。目前仅使用 `select()` 和  `poll()` （1.15.9） 连接处理方法，因此不应期望高性能和可伸缩性。由于这个和其他一些已知问题，nginx for Windows 的版本被认为是一个测试版 *beta* 。目前，它提供了与 UNIX 版本的 nginx 几乎相同的功能，除了 XSLT 过滤器、image 过滤器、GeoIP 模块和嵌入式 Perl 语言。

## 安装

要安装 nginx/Windows，请下载最新的 mainline 版本发行版 （1.25.4），因为 nginx 的 mainline 分支包含所有已知的修复程序。然后解压发行版，进入 nginx-1.25.4 目录，运行 `nginx` 。下面是示例：

```bash
cd c:\
unzip nginx-1.25.4.zip
cd nginx-1.25.4
start nginx
```

Run the `tasklist` command-line utility to see nginx processes:运行 `tasklist` 命令行实用程序以查看 nginx 进程：

```bash
C:\nginx-1.25.4>tasklist /fi "imagename eq nginx.exe"

Image Name           PID Session Name     Session#    Mem Usage
=============== ======== ============== ========== ============
nginx.exe            652 Console                 0      2 780 K
nginx.exe           1332 Console                 0      3 112 K
```

其中一个进程是 master 进程，另一个是 worker 进程。如果 nginx 没有启动，请在错误日志文件中 `logs\error.log` 查找原因。如果尚未创建日志文件，则应在 Windows 事件日志中报告其原因。如果显示的是错误页面而不是预期的页面，则还要在 `logs\error.log` 文件中查找原因。

nginx/Windows 使用运行它的目录作为配置中相对路径的前缀。在上面的示例中，前缀为 `C:\nginx-1.25.4\` 。配置文件中的路径必须使用正斜杠以 UNIX 样式指定：

```bash
access_log   logs/site.log;
root         C:/web/html;
```

nginx/Windows 作为标准控制台应用程序（而不是服务）运行，可以使用以下命令进行管理：

* nginx -s stop            快速关闭。
* nginx -s quit             正常关闭。
* nginx -s reload        更改配置，使用新配置启动新的工作进程，正常关闭旧工作进程
* nginx -s reopen       重新打开日志文件

## 已知问题

- 虽然可以启动几个 worker 线程，但实际上只有一个 worker 线程在做任何工作。
- 不支持 UDP 代理功能。

## 未来可能的增强功能

- 作为服务运行。
- 使用 I/O 完成端口（ the I/O completion ports ）作为连接处理方法。
- 在单个 worker 进程中使用多个 worker 线程。