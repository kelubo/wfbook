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

## 使用 Visual C 在 Win32 平台上构建 nginx

[Build steps 生成步骤](http://nginx.org/en/docs/howto_build_on_win32.html#build_steps) [See also 另请参阅](http://nginx.org/en/docs/howto_build_on_win32.html#see_also) 

Prerequisites 先决条件

To build nginx on the Microsoft Win32® platform you need: 
要在 Microsoft Win32 ® 平台上构建 nginx，您需要：

- Microsoft Visual C compiler. Microsoft Visual Studio® 8 and 10 are known to work. 
  Microsoft Visual C 编译器。众所周知，Microsoft Visual Studio ® 8 和 10 可以正常工作。
- [MSYS](https://sourceforge.net/projects/mingw/files/MSYS/) or [MSYS2](https://www.msys2.org). 
  MSYS 或 MSYS2。
- Perl, if you want to build OpenSSL® and nginx with SSL support. For example [ActivePerl](http://www.activestate.com/activeperl) or [Strawberry Perl](http://strawberryperl.com). 
  Perl，如果你想构建支持SSL的 ® OpenSSL和nginx。例如，ActivePerl 或 Strawberry Perl。
- [Mercurial](https://www.mercurial-scm.org) client. Mercurial客户。
- [PCRE](http://www.pcre.org), [zlib](http://zlib.net) and [OpenSSL](http://www.openssl.org) libraries sources. 
  PCRE、zlib 和 OpenSSL 库源。

 



Build steps 生成步骤

Ensure that paths to Perl, Mercurial and MSYS bin directories are added to PATH environment variable before you start build. To set Visual C environment run vcvarsall.bat script from Visual C directory. 
在开始构建之前，请确保将 Perl、Mercurial 和 MSYS bin 目录的路径添加到 PATH 环境变量中。若要设置 Visual C 环境vcvarsall.bat请从 Visual C 目录运行脚本。

To build nginx: 
要构建 nginx：

- Start MSYS bash. 启动 MSYS bash。

- Check out nginx sources from the hg.nginx.org repository. For example:

  
  从 hg.nginx.org 存储库中查看 nginx 源代码。例如：

  > ```
  > hg clone http://hg.nginx.org/nginx
  > ```

- Create a build and lib directories, and unpack zlib, PCRE and OpenSSL libraries sources into lib directory:

  
  创建一个 build 和 lib 目录，并将 zlib、PCRE 和 OpenSSL 库源代码解压缩到 lib 目录中：

  > ```
  > mkdir objs
  > mkdir objs/lib
  > cd objs/lib
  > tar -xzf ../../pcre2-10.39.tar.gz
  > tar -xzf ../../zlib-1.3.tar.gz
  > tar -xzf ../../openssl-3.0.10.tar.gz
  > ```

- Run configure script:

  
  运行配置脚本：

  > ```
  > auto/configure \
  >     --with-cc=cl \
  >     --with-debug \
  >     --prefix= \
  >     --conf-path=conf/nginx.conf \
  >     --pid-path=logs/nginx.pid \
  >     --http-log-path=logs/access.log \
  >     --error-log-path=logs/error.log \
  >     --sbin-path=nginx.exe \
  >     --http-client-body-temp-path=temp/client_body_temp \
  >     --http-proxy-temp-path=temp/proxy_temp \
  >     --http-fastcgi-temp-path=temp/fastcgi_temp \
  >     --http-scgi-temp-path=temp/scgi_temp \
  >     --http-uwsgi-temp-path=temp/uwsgi_temp \
  >     --with-cc-opt=-DFD_SETSIZE=1024 \
  >     --with-pcre=objs/lib/pcre2-10.39 \
  >     --with-zlib=objs/lib/zlib-1.3 \
  >     --with-openssl=objs/lib/openssl-3.0.10 \
  >     --with-openssl-opt=no-asm \
  >     --with-http_ssl_module
  > ```

- Run make:

   运行 make：

  > ```
  > nmake
  > ```