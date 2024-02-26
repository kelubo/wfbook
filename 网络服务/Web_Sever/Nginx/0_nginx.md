# Nginx

[TOC]

## 概述

nginx [engine x] 是一个 HTTP 和反向代理服务器，一个邮件代理服务器，以及一个通用的 TCP/UDP 代理服务器，最初由 [Igor Sysoev](http://sysoev.ru/en/) 编写。很长一段时间以来，它一直在许多负载较重的俄罗斯网站上运行，包括 Yandex ，Mail.Ru ，VK 和 Rambler。根据 Netcraft 的数据，nginx 在 2024 年 1 月服务或代理了 20.71% 的最繁忙站点。以下是一些成功的故事：Dropbox、Netflix、Wordpress.com、FastMail. FM。

The sources and documentation are distributed under the [2-clause BSD-like license](http://nginx.org/LICENSE).源代码和文档在类似 BSD 的双条款许可证下分发。

商业支持可从 Nginx, Inc 获得。

Nginx 的发音为 [ˈendʒɪnks] ，是一个开源、轻量级、模块化和高性能的 Web 服务器 、反向代理服务器（HTTP、HTTPS、SMTP、IMAP、POP3）、负载均衡器。其特点是占有系统资源少，并发能力强。

由俄罗斯的程序员 Igor Sysoev 所开发，2004 年 10 月作为一个试图回答公众发布 C10K 问题。其中 C10k  是同时管理 10,000 个连接的挑战。Nginx 采用了事件驱动和异步架构，此设计使 Nginx 成为可扩展、高性能的服务器。  

Nginx 以事件驱动的方式编写，所以有非常好的性能，同时也是一个非常高效的反向代理、负载平衡服务器。在性能上，Nginx 占用很少的系统资源，能支持更多的并发连接，达到更高的访问效率；在功能上，Nginx 是优秀的代理服务器和负载均衡服务器；在安装配置上，Nginx 安装简单、配置灵活。

Nginx 支持热部署，启动速度特别快，还可以在不间断服务的情况下对软件版本或配置进行升级，即使运行数月也无需重新启动。

在微服务的体系之下，Nginx 正在被越来越多的项目采用作为网关来使用，配合 Lua 做限流、熔断等控制。

![img](../../../Image/n/nginx_工作.png)

Nginx 不可以直接处理 php、java。Nginx 只是一个静态文件服务器或者 http 请求转发器，它可以把静态文件的请求直接返回静态文件资源，把动态文件的请求转发给后台的处理程序，例如 php-fpm、apache、tomcat、jetty 等，这些后台服务，即使没有 nginx 的情况下也是可以直接访问的。	

## 功能

### 基本 HTTP 服务器功能

- Serving static and [index](http://nginx.org/en/docs/http/ngx_http_index_module.html) files, [autoindexing](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html); [open file descriptor cache](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache);提供静态和索引文件，自动索引;打开文件描述符缓存; 
- [Accelerated reverse proxying with caching](http://nginx.org/en/docs/http/ngx_http_proxy_module.html); [load balancing and fault tolerance](http://nginx.org/en/docs/http/ngx_http_upstream_module.html);通过缓存、负载平衡和容错加速反向代理; 
- Accelerated support with caching of [FastCGI](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html), [uwsgi](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html), [SCGI](http://nginx.org/en/docs/http/ngx_http_scgi_module.html), and [memcached](http://nginx.org/en/docs/http/ngx_http_memcached_module.html) servers; [load balancing and fault tolerance](http://nginx.org/en/docs/http/ngx_http_upstream_module.html);加速支持FastCGI、uwsgi、SCGI和memcached服务器的缓存;负载平衡和容错; 
- Modular architecture. Filters include [gzipping](http://nginx.org/en/docs/http/ngx_http_gzip_module.html), byte ranges, chunked responses, [XSLT](http://nginx.org/en/docs/http/ngx_http_xslt_module.html), [SSI](http://nginx.org/en/docs/http/ngx_http_ssi_module.html), and [image transformation](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html) filter. Multiple SSI inclusions within a single page can be processed in parallel if they are handled by proxied or FastCGI/uwsgi/SCGI servers;模块化架构。过滤器包括gzipping、字节范围、分块响应、CSS、SSI和图像转换过滤器。如果由代理或FastCGI/uwsgi/SCGI服务器处理，则可以并行处理单个页面中的多个SSI包含; 
- SSL 和 TLS SNI 支持; 
- Support for [HTTP/2](http://nginx.org/en/docs/http/ngx_http_v2_module.html) with weighted and dependency-based prioritization;支持HTTP/2，并具有加权和基于依赖关系的优先级;
- 支持 HTTP/3 。

### 其他 HTTP 服务器功能

- 基于名称和基于 IP 的虚拟服务器；
- [Keep-alive](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) and pipelined connections support;保持活动和管道连接支持；
- [Access log formats](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format), [buffered log writing](http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log), [fast log rotation](http://nginx.org/en/docs/control.html#logs), and [syslog logging](http://nginx.org/en/docs/syslog.html);访问日志格式、缓冲日志写入、快速日志循环和系统日志记录；
- 3xx-5xx 错误代码重定向；
- The rewrite module: [URI changing using regular expressions](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html);重写模块：使用正则表达式更改URI；
- [Executing different functions](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if) depending on the [client address](http://nginx.org/en/docs/http/ngx_http_geo_module.html);根据客户端地址执行不同的功能
- Access control based on [client IP address](http://nginx.org/en/docs/http/ngx_http_access_module.html), [by password (HTTP Basic authentication)](http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) and by the [result of subrequest](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html);基于客户端IP地址、密码（HTTP基本身份验证）和子请求结果的访问控制
- Validation of [HTTP referer](http://nginx.org/en/docs/http/ngx_http_referer_module.html);HTTP referer的验证
- PUT、DELETE、MKCOL、COPY 和 MOVE 方法；
- [FLV](http://nginx.org/en/docs/http/ngx_http_flv_module.html) and [MP4](http://nginx.org/en/docs/http/ngx_http_mp4_module.html) streaming;FLV和MP4流媒体
- [Response rate limiting](http://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate);反应速率限制
- Limiting the number of simultaneous [connections](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) or [requests](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html) coming from one address;限制来自一个地址的同时连接或请求的数量
- [IP-based geolocation](http://nginx.org/en/docs/http/ngx_http_geoip_module.html);基于IP的地理定位
- [A/B testing](http://nginx.org/en/docs/http/ngx_http_split_clients_module.html);A/B测试
- [Request mirroring](http://nginx.org/en/docs/http/ngx_http_mirror_module.html);请求镜像
- 嵌入式 Perl 。
- njs 脚本语言。

### 邮件代理服务功能

-  User redirection to [IMAP](http://nginx.org/en/docs/mail/ngx_mail_imap_module.html) or [POP3](http://nginx.org/en/docs/mail/ngx_mail_pop3_module.html) server using an external HTTP [authentication](http://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html) server;使用外部HTTP身份验证服务器将用户重定向到IMAP或POP3服务器
-  User authentication using an external HTTP [authentication](http://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html) server and connection redirection to an internal [SMTP](http://nginx.org/en/docs/mail/ngx_mail_smtp_module.html) server;使用外部HTTP身份验证服务器进行用户身份验证，并将连接重定向到内部SMTP服务器
-  认证方式：
   - [POP3](http://nginx.org/en/docs/mail/ngx_mail_pop3_module.html#pop3_auth): USER/PASS, APOP, AUTH LOGIN/PLAIN/CRAM-MD5;
   - [IMAP](http://nginx.org/en/docs/mail/ngx_mail_imap_module.html#imap_auth): LOGIN, AUTH LOGIN/PLAIN/CRAM-MD5;
   - [SMTP](http://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_auth): AUTH LOGIN/PLAIN/CRAM-MD5;
-  SSL 支持;
-  STARTTLS 和 STLS 支持。

### TCP/UDP 代理服务器功能

- [Generic proxying](http://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) of TCP and UDP;TCP 和 UDP的通用协议栈 
- [SSL](http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) and TLS [SNI](http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html) support for TCP;SSL和TLS SNI支持TCP;
- [Load balancing and fault tolerance](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html);负载平衡和容错
- 基于客户端地址的访问控制；
- Executing different functions depending on the [client address](http://nginx.org/en/docs/stream/ngx_stream_geo_module.html);根据客户端地址执行不同的功能
- Limiting the number of simultaneous [connections](http://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html) coming from one address;限制来自一个地址的同时连接数
- [Access log formats](http://nginx.org/en/docs/stream/ngx_stream_log_module.html#log_format), [buffered log writing](http://nginx.org/en/docs/stream/ngx_stream_log_module.html#access_log), [fast log rotation](http://nginx.org/en/docs/control.html#logs), and [syslog logging](http://nginx.org/en/docs/syslog.html);访问日志格式、缓冲日志写入、快速日志循环和系统日志记录
- [IP-based geolocation](http://nginx.org/en/docs/stream/ngx_stream_geoip_module.html);基于IP的地理定位
- [A/B testing](http://nginx.org/en/docs/stream/ngx_stream_split_clients_module.html);A/B测试
- njs 脚本语言。

### 体系结构和可扩展性

- 一个 master 进程和多个 worker 进程；worker 进程在一个非特权用户下运行；
- [Flexible configuration](http://nginx.org/en/docs/example.html);配置灵活
- [Reconfiguration](http://nginx.org/en/docs/control.html#reconfiguration) and [upgrade of an executable](http://nginx.org/en/docs/control.html#upgrade) without interruption of the client servicing;在不中断客户端服务的情况下重新配置和升级可执行文件
- [Support](http://nginx.org/en/docs/events.html) for kqueue (FreeBSD 4.1+), epoll (Linux 2.6+), /dev/poll (Solaris 7 11/99+), event ports (Solaris 10), select, and poll;支持kqueue（FreeBSD 4.1+）、epoll（Linux 2.6+）、/dev/poll（Solaris 7 11/99+）、事件端口（Solaris 10）、select和poll
- The support of the various kqueue features including EV_CLEAR, EV_DISABLE (to temporarily disable events), NOTE_LOWAT, EV_EOF, number of available data, error codes;支持各种kqueue特性，包括EV_CLEAR、EV_DISABLE（临时禁用事件）、NOTE_LOWAT、EV_REPORT、可用数据数量、错误代码
- The support of various epoll features including EPOLLRDHUP (Linux 2.6.17+, glibc 2.8+) and EPOLLEXCLUSIVE (Linux 4.5+, glibc 2.24+);支持各种epoll功能，包括EPOLLRDHUP（Linux 2.6.17+，glibc 2.8+）和EPOLLEXCLUSIVE（Linux 4.5+，glibc 2.24+）
- sendfile (FreeBSD 3.1+, Linux 2.2+, macOS 10.5+), sendfile64 (Linux 2.4.21+), and sendfilev (Solaris 8 7/01+) support;sendfile（FreeBSD 3.1+，Linux 2.2+，macOS 10.5+），sendfile 64（Linux 2.4.21+），和sendfilev（Solaris 8 7/01+）支持
- [File AIO](http://nginx.org/en/docs/http/ngx_http_core_module.html#aio) (FreeBSD 4.3+, Linux 2.6.22+);
- [DIRECTIO](http://nginx.org/en/docs/http/ngx_http_core_module.html#directio) (FreeBSD 4.4+, Linux 2.4+, Solaris 2.6+, macOS);
- Accept-filters (FreeBSD 4.1+, NetBSD 5.0+) and TCP_DEFER_ACCEPT (Linux 2.4+) [support](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen);接受过滤器（FreeBSD 4.1+，NetBSD 5.0+）和TCP_DEFER_ACCEPT（Linux 2.4+）支持
- 10,000 个非活动 HTTP keep-alive 连接占用约 2.5M 内存；
- Data copy operations are kept to a minimum.数据复制操作保持在最低限度。

## 经过测试的操作系统和平台

- FreeBSD 3 — 12 / i386; FreeBSD 5 — 12 / amd64; FreeBSD 11 / ppc; FreeBSD 12 / ppc64;
- Linux 2.2 — 4 / i386; Linux 2.6 — 5 / amd64; Linux 3 — 4 / armv6l, armv7l, aarch64, ppc64le; Linux 4 — 5 / s390x;
- Solaris 9 / i386, sun4u; Solaris 10 / i386, amd64, sun4v; Solaris 11 / x86;
- AIX 7.1 / powerpc;
- HP-UX 11.31 / ia64;
- macOS / ppc, i386, x86_64;
- Windows XP, Windows Server 2003, Windows 7, Windows 10.

## 2.2. 将 NGINX 配置为一个为不同域提供不同内容的 web 服务器

​				默认情况下，NGINX 作为 web 服务器，为与服务器的 IP 地址关联的所有域名提供相同的内容。此流程解释了如何配置 NGINX 来实现一下情况： 		

- ​						使用`/var/www/example.com/` 目录中的内容为 `example.com` 域提供请求 				
- ​						使用`/var/www/example.net/`目录中的内容为`example.net`域提供请求 				
- ​						使用`/usr/share/nginx/html/`目录中的内容为所有其他请求提供服务，例如，向服务器的IP地址或与服务器的IP地址相关联的其他域发送请求 				

**先决条件**

- ​						已安装 NGINX 				

- ​						客户端和 Web 服务器将 `example.com` 和 `example.net` 域解析为 Web 服务器的 IP 地址。 				

  ​						请注意，您必须手动将这些条目添加到 DNS 服务器中。 				

**步骤**

1. ​						编辑`/etc/nginx/nginx.conf`文件： 				

   1. ​								默认情况下，`/etc/nginx/nginx.conf`文件已包含catch-all配置。如果您已从配置中删除了这部分，请将以下`server`块重新添加到`/etc/nginx/nginx.conf`文件中的`http`块中： 						

      

      ```none
      server {
          listen       80 default_server;
          listen       [::]:80 default_server;
          server_name  _;
          root         /usr/share/nginx/html;
      }
      ```

      ​								这些设置配置以下内容： 						

      - ​										`listen`指令定义服务监听的 IP 地址和端口。在本例中，NGINX 监听所有 IPv4 和 IPv6 地址的`80`端口 。`default_server`参数表示，NGINX 使用此`server`块作为匹配 IP 地址和端口的请求的默认值。 								
      - ​										`server_name`参数定义此`server`块所负责的主机名。将`server_name`设置为`_`,会将NGINX配置为接受这个`server`块的任何主机名。 								
      - ​										`root`指令设置此`server`块的 Web 内容的路径。 								

   2. ​								将类似于`example.com`域的`server`块添加到 `http`块中： 						

      

      ```none
      server {
          server_name  example.com;
          root         /var/www/example.com/;
          access_log   /var/log/nginx/example.com/access.log;
          error_log    /var/log/nginx/example.com/error.log;
      }
      ```

      - ​										`access_log`指令为此域定义一个单独的访问日志文件。 								
      - ​										`error_log`指令为此域定义单独的错误日志文件。 								

   3. ​								将类似于`example.com`域的`server`块添加到 `http`块中： 						

      

      ```none
      server {
          server_name  example.net;
          root         /var/www/example.net/;
          access_log   /var/log/nginx/example.net/access.log;
          error_log    /var/log/nginx/example.net/error.log;
      }
      ```

2. ​						为这两个域创建根目录： 				

   

   ```none
   # mkdir -p /var/www/example.com/
   # mkdir -p /var/www/example.net/
   ```

3. ​						在两个根目录中设置`httpd_sys_content_t`上下文： 				

   

   ```none
   # semanage fcontext -a -t httpd_sys_content_t "/var/www/example.com(/.*)?"
   # restorecon -Rv /var/www/example.com/
   # semanage fcontext -a -t httpd_sys_content_t "/var/www/example.net(/.\*)?"
   # restorecon -Rv /var/www/example.net/
   ```

   ​						这些命令在`/var/www/example.com/`和`/var/www/example.net/`目录中设置`httpd_sys_content_t`上下文。 				

   ​						请注意，您必须安装 `policycoreutils-python-utils`软件包才能运行`restorecon`命令。 				

4. ​						为这两个域创建日志目录： 				

   

   ```none
   # mkdir /var/log/nginx/example.com/
   # mkdir /var/log/nginx/example.net/
   ```

5. ​						重启`nginx`服务： 				

   

   ```none
   # systemctl restart nginx
   ```

**验证步骤**

1. ​						在每个虚拟主机的文档 root 中创建不同的示例文件： 				

   

   ```none
   # echo "Content for example.com" > /var/www/example.com/index.html
   # echo "Content for example.net" > /var/www/example.net/index.html
   # echo "Catch All content" > /usr/share/nginx/html/index.html
   ```

2. ​						使用浏览器并连接到 `http://example.com`Web 服务器显示`/var/www/example.com/index.html`文件中的示例内容。 				

3. ​						使用浏览器并连接到 `http://example.net`Web 服务器显示`/var/www/example.net/index.html`文件中的示例内容。 				

4. ​						使用浏览器连接到`http://*IP_address_of_the_server*`。Web 服务器显示`/usr/share/nginx/html/index.html`文件中的示例内容。 				

## 2.3. 在 NGINX web 服务器中添加 TLS 加密

​				这部分论述了如何在`example.com`域的 NGINX web 服务器上启用 TLS 加密。 		

**先决条件**

- ​						已安装 NGINX。 				

- ​						私钥存储在 `/etc/pki/tls/private/example.com.key` 文件中。 				

  ​						有关创建私钥和证书签名请求(CSR)的详细信息，以及如何从证书颁发机构(CA)请求证书，请参阅您的 CA 文档。 				

- ​						TLS 证书存储在`/etc/pki/tls/certs/example.com.crt`文件中。如果您使用其他路径，请调整该流程的对应步骤。 				

- ​						CA 证书已附加到服务器的 TLS 证书文件中。 				

- ​						客户端和网页服务器会将服务器的主机名解析为 web 服务器的 IP 地址。 				

- ​						在本地防火墙中打开端口`443`。 				

**步骤**

1. ​						编辑 `/etc/nginx/nginx.conf`文件，并将以下`server`块添加到配置中的`http`块中： 				

   

   ```none
   server {
       listen              443 ssl;
       server_name         example.com;
       root                /usr/share/nginx/html;
       ssl_certificate     /etc/pki/tls/certs/example.com.crt;
       ssl_certificate_key /etc/pki/tls/private/example.com.key;
   }
   ```

2. ​						出于安全考虑，配置成只有 `root` 用户才可以访问私钥文件： 				

   

   ```none
   # chown root:root /etc/pki/tls/private/example.com.key
   # chmod 600 /etc/pki/tls/private/example.com.key
   ```

   警告

   ​							如果私钥被设置为可以被未授权的用户访问，则需要撤销证书，然后再创建一个新私钥并请求一个新证书。否则，TLS 连接就不再安全。 					

3. ​						重启`nginx`服务： 				

   

   ```none
   # systemctl restart nginx
   ```

**验证步骤**

- ​						使用浏览器连接到`https://example.com` 				

**其他资源**

- ​						[RHEL 中 TLS 的安全性注意事项](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/planning-and-implementing-tls_securing-networks#security-considerations-for-tls-in-rhel_planning-and-implementing-tls) 				

## 2.4. 将 NGINX 配置为 HTTP 流量的反向代理

​				您可以将 NGINX web 服务器配置为作为 HTTP  流量的反向代理。例如，您可以使用此功能将请求转发到远程服务器上的特定子目录。从客户端的角度来看，客户端从它所访问的主机加载内容。但是 NGINX 会从远程服务器加载实际内容并将其转发给客户端。 		

​				这个流程解释了如何将流向web 服务器上的`/example`目录的流量转发到URL`https://example.com`。 		

**先决条件**

- ​						已安装 NGINX 				
- ​						可选：在反向代理上启用了 TLS 加密。 				

**步骤**

1. ​						编辑`/etc/nginx/nginx.conf`文件，并将以下设置添加到提供反向代理的`server`块中： 				

   

   ```none
   location /example {
       proxy_pass https://example.com;
   }
   ```

   ​						`location`块定义了 NGINX 将`/example`目录中的所有请求传给`https://example.com`。 				

2. ​						将`httpd_can_network_connect`SELinux 布尔值参数设置为`1`，以便将 SELinux 设置为允许 NGINX 转发流量： 				

   

   ```none
   # setsebool -P httpd_can_network_connect 1
   ```

3. ​						重启`nginx`服务： 				

   

   ```none
   # systemctl restart nginx
   ```

**验证步骤**

- ​						使用浏览器连接到 `http://*host_name*/example`，就会显示`https://example.com`的内容。 				

## 2.5. 将 NGINX 配置为 HTTP 负载均衡器

​				您可以使用 NGINX 反向代理功能进行负载均衡流量。这个步骤描述了如何将 NGINX 配置为 HTTP  负载均衡器。它会根据服务器上的活跃连接的数量，将请求发送到不同服务器（发送到活跃连接数量最小的服务器）。如果两个服务器都不可用，这个过程还定义了第三个主机用于回退。 		

**先决条件**

- ​						已安装 NGINX 				

**步骤**

1. ​						编辑`/etc/nginx/nginx.conf`文件并添加以下设置： 				

   

   ```none
   http {
       upstream backend {
           least_conn;
           server server1.example.com;
           server server2.example.com;
           server server3.example.com backup;
       }
   
       server {
           location / {
               proxy_pass http://backend;
           }
       }
   }
   ```

   ​						在名为`backend`的主机组中的`least_conn`指令定义了 NGINX 将请求发送到`server1.example.com`或`server2.example.com`，具体取决于哪个主机具有最少的活动连接数。NGINX 仅在其他两个主机不可用时使用`server3.example.com`作为备份。 				

   ​						`proxy_pass`指令设置为`http://backend` 时，NGINX 充当反向代理，并使用`backend`主机组根据该组的设置分发请求。 				

   ​						您还可以指定其他方法，而不是`least_conn`负载均衡方法： 				

   - ​								不指定方法，使用轮询的方式在服务器间平均分发请求。 						
   - ​								`ip_hash`根据从 IPv4 地址的前三个八位字节或客户端的整个 IPv6 地址计算的哈希值将来自一个客户端地址的请求发送到同一台服务器。 						
   - ​								`hash`，根据用户定义的密钥（可以是字符串、变量或两者的组合）来确定服务器。用`consistent`参数来进行配置，NGINX可根据用户定义的哈希密钥值向所有的服务器分发请求。 						
   - ​								`random`将请求发送到随机挑选的服务器。 						

2. ​						重启`nginx`服务： 				

   

   ```none
   # systemctl restart nginx
   ```

​			

### 版本

Nginx 的开发人员认为 “mainline” 分支经过了良好的测试，对于一般用途来说是稳定的，因为它可以获得所有新功能、所有安全修复和所有 bug 修复。

使用 “stable” 分支的唯一原因包括：你真的想确保新功能和大修复不会破坏任何第三方代码或你自己的自定义代码。

From there, you could just start dropping HTML files into the `/usr/share/nginx/html/` directory to build a simple, static website. The configuration file for the default website/virtual host is called “nginx.conf” and it’s in `/etc/nginx/`. It also holds a number of other basic Nginx server configurations, so  even if you choose to move the actual website config to another file,  you should probably leave the rest of "nginx.conf" intact.

从那里，您可以开始将HTML文件放入/usr/share/nginx/HTML/目录，以构建一个简单的静态网站。默认网站/虚拟主机的配置文件称为“nginx.conf”，位于/etc/nginx/中。它还保存了许多其他基本的Nginx服务器配置，因此即使您选择将实际的网站配置移动到另一个文件，也可能应该保留“Nginx.conf”的其余部分。

* Nginx

  开源版本。两个分支：

  * mainline

    版本号中的第二位奇数标识。1.17.2

    是个活跃分支，会添加一些最新的功能并进行错误修复。

  * stable

    版本号中的第二位偶数标识。1.16.1

    会集成修复严重错误的代码，但不会增加新的功能。

* Nginx Plus

  商业版本。

* 衍生版

  * 淘宝      Tengine
  * 章亦春  OpenResty

## 卸载

### CentOS 7.6

### Ubuntu

```bash
# 卸载删除除配置文件外所有的文件
apt-get remove nginx nginx-common
# 卸载所有软件，包括配置文件
apt-get purge nginx nginx-common
```

## 控制

### 启动

要启动nginx，运行可执行文件。

```bash
# ./sbin/nginx
```

### 信号控制

nginx 可以用信号控制。

一旦 nginx 启动，就可以通过使用 `-s` 参数调用可执行文件来控制它。

```bash
nginx -s signal
```

signal ：

* stop     - 快速停机
* quit      - 正常关机，等待 worker 进程完成对当前请求的处理
* reload  - 重新加载配置文件
* reopen - 重新打开日志文件

在 Unix 工具（如 kill 实用程序）的帮助下，也可以向 nginx 进程发送信号。在这种情况下，信号将直接发送给具有给定进程 ID 的进程。默认情况下，nginx master 进程的进程 ID 将写入目录 `/usr/local/nginx/logs` 或 `/var/run ` 中的 `nginx.pid` 。

master 进程支持以下信号：

| 信号        | 作用                                                         |
| ----------- | ------------------------------------------------------------ |
| TERM 或 INT | 快速停止服务。                                               |
| QUIT        | 平缓停止服务。                                               |
| HUP         | 更改配置，keeping up with a changed time zone跟上更改的时区（仅适用于FreeBSD和Linux），使用新配置启动新的工作进程，优雅地关闭旧的工作进程。 |
| USR1        | 重新打开日志文件，常用于日志切割。                           |
| USR2        | 使用新版本 Nginx 启动服务，之后平缓停止原有进程，“平滑升级”。 |
| WINCH       | 平缓停止 worker process，用于服务器平滑升级。                |

单个 worker 进程也可以用信号控制，尽管这不是必需的。支持的信号包括：

| 信号        | 作用                                   |
| ----------- | -------------------------------------- |
| TERM 或 INT | 快速停止服务。                         |
| QUIT        | 平缓停止服务。                         |
| USR1        | 重新打开日志文件，常用于日志切割。     |
| WINCH       | 调试异常终止（需要启用 debug_points ） |


```bash
kill -s SIGNAL PID
kill -s SIGNAL `filepath`  #filepath为nginx.pid的路径
kill -s SIGNAL `cat filepath`  #filepath为nginx.pid的路径
# 上述两条需要确认哪一条是正确的。
```

#### 更改配置

为了让 nginx 重新读取配置文件，应该向 master 进程发送 HUP 信号。master 进程首先检查语法有效性，然后尝试应用新的配置，即打开日志文件和新的侦听套接字。

* 如果失败，它将回滚更改并继续使用旧配置。
* 如果成功，它将启动新的 worker 进程，并向旧的 worker 进程发送消息，请求它们正常关闭。旧 worker 进程关闭侦听套接字并继续为旧客户端提供服务。在所有客户端都得到服务后，旧的 worker 进程将关闭。

举个例子来说明这一点。想象一下 nginx 是在 FreeBSD 上运行的

```sh
ps axw -o pid,ppid,user,%cpu,vsz,wchan,command | egrep '(nginx|PID)'
```

产生以下输出：

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
33127 33126 nobody   0.0  1380 kqread nginx: worker process (nginx)
33128 33126 nobody   0.0  1364 kqread nginx: worker process (nginx)
33129 33126 nobody   0.0  1364 kqread nginx: worker process (nginx)
```

如果 HUP 被发送到 master 进程，则输出变为：

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
33129 33126 nobody   0.0  1380 kqread nginx: worker process is shutting down (nginx)
33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
33135 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
```

PID 为 33129 的旧 worker 进程仍继续工作。一段时间后，它退出：

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
33135 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
```

#### 动态升级可执行文件

为了升级服务器可执行文件，应首先将新的可执行文件放置在旧文件的位置。之后，应将 USR2 信号发送到 master 进程。master 进程首先将具有其进程 ID 的文件重命名为具有 `.oldbin` 后缀的新文件，例如 `/usr/local/nginx/logs/nginx.pid.oldbin` ，然后启动一个新的可执行文件，随后启动新的 worker 进程：

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
33135 33126 nobody   0.0  1380 kqread nginx: worker process (nginx)
33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
```

之后，所有 worker 进程（旧的和新的）继续接受请求。如果 WINCH 信号发送到第一个 master 进程，它将向其 worker 进程发送消息，请求它们正常关闭，然后它们将开始退出：

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
33135 33126 nobody   0.0  1380 kqread nginx: worker process is shutting down (nginx)
36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
```

一段时间后，只有新的 worker 进程将处理请求： 

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
```

应该注意，旧的 master 进程不会关闭其侦听套接字，如果需要，可以管理它重新启动其 worker 进程。如果由于某种原因，新的可执行文件无法正常工作，可以执行以下操作之一：

- 向旧 master 进程发送 HUP 信号。旧的 master 进程将启动新的 worker 进程，而无需重新读取配置。之后，通过向新的 master 进程发送 QUIT 信号，所有新进程都可以正常关闭。
- 向新的 master 进程发送 TERM 信号。然后，它会向其 worker 进程发送一条消息，请求它们立即退出，而它们几乎都会立即退出。（如果新进程由于某种原因没有退出，则应向它们发送 KILL 信号以强制它们退出。）当新 master 进程退出时，旧 master 进程将自动启动新的 worker 进程。

如果新的 master 进程退出，则旧的 master 进程将丢弃带有进程 ID 的文件名中的 `.oldbin` 后缀。

如果升级成功，则应向旧 master 进程发送 QUIT 信号，并且只有新进程将保留： 

```bash
  PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
36264     1 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
```

### 停止

```bash
nginx -s quit

nginx -s TERM | INT | QUIT
# TERM，INT	快速停止
# QUIT       平缓停止，等待工作进程完成当前请求

kill -s TERM | INT | QUIT `/nginx/logs/nginx.pid`

kill -9 | SIGKILL `/nginx/logs/nginx.pid`
# 不建议
```

### 重新加载配置文件

```bash
nginx -s reload
```

一旦 master 进程收到重新加载配置的信号，它将检查新配置文件的语法有效性，并尝试应用其中提供的配置。如果成功，master 进程将启动新的 worker 进程，并向旧的 worker 进程发送消息，请求它们关闭。否则，master 进程回滚更改并继续使用旧配置。旧 worker 进程收到关闭命令，停止接受新连接，并继续服务当前请求，直到所有此类请求都得到服务。之后，旧 worker 进程退出。

### 重启

```bash
nginx -s HUP [-c newConfFile]
kill -s HUP `/nginx/logs/nginx.pid`
```

### 升级

```bash
nginx -p newInstallPath

nginx -s USR2
kill USR2 `/nginx/logs/nginx.pid`

#确认新服务启动后,平滑停止旧服务
nginx -s WINCH
kill -s WINCH `/nginx/logs/nginx.pid`
```

## 工作原理

Nginx 由内核和模块组成，其中，内核的设计非常微小和简洁，完成的工作也非常简单，仅仅通过查找配置文件将客户端请求映射到一个 location  block ，而在这个 location 中所配置的每个指令将会启动不同的模块去完成相应的工作。

### Nginx进程

nginx 在启动后，会以 daemon 的方式在后台运行，后台进程包含一个 master 进程和多个 worker 进程，worker 进程以非 root 用户运行，可以在配置文件中配置运行 worker 进程的用户。 worker 进程默认是单线程的，但也可以设置为多线程。

master 进程主要目的是读取和评估配置，并用来管理 worker 进程，包含：接收来自外界的信号，向各 worker 进程发送信号，监控 worker 进程的运行状态，当 worker 进程退出后(异常情况下)，会自动重新启动新的 worker 进程。 

worker 进程则实际处理请求。多个 worker 进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个 worker 进程中处理，一个 worker 进程，不可能处理其它进程的请求。 

nginx 采用基于事件的模型和依赖于操作系统的机制，在 worker 进程之间高效地分配请求。worker 进程的数量在配置文件中定义，可以针对给定配置固定，也可以根据可用 CPU 核的数量自动调整。

主进程（master process）的功能： 

1. 读取 Nginx 配置文件并验证其有效性和正确性。
2. 按照配置启动、管理和关闭工作进程。
3. 接受外界指令，比如重启、升级及关闭服务器等指令。
4. 不中断服务，实现平滑升级，重启服务并应用新的配置。
5. 开启日志文件。

工作进程（woker process）的功能： 

1. 接收处理客户端的请求。
2. 将请求以此送入各个功能模块进行处理。
3. IO 调用，获取响应数据。
4. 与后端服务器通信，接收后端服务器的处理结果。
5. 缓存数据，访问缓存索引，查询和调用缓存数据。
6. 发送请求结果，响应客户端的请求。
7. 接收主程序指令，比如重启、升级和退出等。

cache相关进程：cache loader (缓存索引重建)与 cache manager( 缓存索引管理)组成

1. Cache loader 在 Nginx 服务启动后由主进程生成,根据本地磁盘上缓存建立索引元数据库后退出。
2. Cache manager 在元数据更新完成后，对元数据是否过期做出判断。 

 ![img](../../../Image/n/nginx.png) 

### Nginx的模块结构

Nginx 的各种功能和操作都由模块来实现。Nginx 由内核和一系列模块组成，内核提供 web 服务的基本功能，如启用网络协议，创建运行环境，接收和分配客户端请求，处理模块之间的交互。

Nginx 的模块从结构上分为：

* 核心模块
  * HTTP 模块
  * EVENT 模块
  * MAIL 模块
* 基础模块
  * HTTP Access 模块
  * HTTP FastCGI 模块
  * HTTP Proxy 模块
  * HTTP Rewrite 模块
* 第三方模块
  * HTTP Upstream Request Hash 模块
  * Notice 模块
  * HTTP Access Key 模块
  * 用户自己开发的模块。

这样的设计使 Nginx 方便开发和扩展，Nginx 的模块默认编译进 nginx 中，如果需要增加或删除模块，需要重新编译 nginx，这一点不如 Apache 的动态加载模块方便，最新版本 Nginx 已经支持动态模块。

Nginx 的模块从功能上分为：

* Handlers (处理器模块)

  此类模块直接处理请求，并进行输出内容和修改 headers 信息等操作。一般只能有一个。

* Filters （过滤器模块）

  此类模块主要对其他处理器模块输出的内容进行修改操作，最后由 Nginx 输出。

* Proxies (代理类模块)

  此类模块是 Nginx 的 HTTP Upstream 之类的模块，这些模块主要与后端一些服务比如 FastCGI 等进行交互，实现服务代理和负载均衡等功能。



```mermaid
graph LR
	A([HTTP 发出请求]) --> B[Nginx 内核] --选择 Handlers 模块--> C[Handlers （处理器模块）] --生成内容--> D[Filters 模块1] --处理内容--> E[Filters 模块2] --> F[Filters 模块N] --> G([HTTP 响应请求])
```

### 连接处理方法

nginx 支持多种连接处理方法。特定方法的可用性取决于所使用的平台。在支持多种方法的平台上，nginx 通常会自动选择最有效的方法。但是，如果需要，可以使用 `use` 指令显式选择连接处理方法。

支持以下连接处理方法：

- `select`

  标准方法。此模块是在缺乏更有效方法的平台上自动构建的。`--with-select_module` 和 `--without-select_module` 配置参数可用于强制启用或禁用此模块的构建。

- `poll`

  标准方法。此模块是在缺乏更有效方法的平台上自动构建的。`--with-poll_module` 和 `--without-poll_module` 配置参数可用于强制启用或禁用此模块的构建。

- `kqueue`

  在 FreeBSD 4.1+、OpenBSD 2.9+、NetBSD 2.0 和 macOS 上使用的高效方法。

- `epoll`

  在 Linux 2.6+ 上使用的高效方法。

  自 1.11.3 起，支持 `EPOLLRDHUP`（Linux 2.6.17，glibc 2.8）和 `EPOLLEXCLUSIVE`（Linux 4.5，glibc 2.24）标志。

  一些较旧的发行版（如 SuSE 8.2）提供了为 2.4 内核添加 epoll 支持的补丁。

- `/dev/poll`

  在 Solaris 7 11/99+、HP/UX 11.22+（eventport）、IRIX 6.5.15+ 和 Tru64 UNIX 5.1A+上使用的高效方法。

- `eventport`

  事件端口，Solaris 10+ 上使用的方法（由于已知问题，建议改用 `/dev/poll` 方法）。

## 文件

不同系统，文件位置可能不同。

所有结尾为 default 的文件都是备份文件。

```bash
/usr/local/nginx
├── client_body_temp                 # POST 大文件暂存目录
├── conf                             # Nginx 所有配置文件的目录
│   ├── fastcgi.conf                 # fastcgi 相关参数的配置文件
│   ├── fastcgi.conf.default         # fastcgi.conf 的原始备份文件
│   ├── fastcgi_params               # fastcgi 的参数文件
│   ├── fastcgi_params.default       
│   ├── koi-utf
│   ├── koi-win
│   ├── mime.types                   # 媒体类型
│   ├── mime.types.default
│   ├── nginx.conf                   # Nginx 默认的主配置文件，日常使用和修改的文件
│   ├── nginx.conf.default
│   ├── scgi_params                  # scgi 相关参数文件
│   ├── scgi_params.default  
│   ├── uwsgi_params                 # uwsgi 相关参数文件
│   ├── uwsgi_params.default
│   └── win-utf
├── fastcgi_temp                     # fastcgi 临时数据目录
├── html                             # Nginx 默认站点目录
│   ├── 50x.html                     # 错误页面优雅替代显示文件，例如出现502错误时会调用此页面
│   └── index.html                   # 默认的首页文件
├── logs                             # Nginx 日志目录
│   ├── access.log                   # 访问日志文件
│   ├── error.log                    # 错误日志文件
│   └── nginx.pid                    # pid 文件，Nginx 进程启动后，会把所有进程的 ID 号写到此文件
├── proxy_temp                       # 临时目录
├── sbin                             # Nginx 可执行文件目录
│   └── nginx                        # Nginx 二进制可执行程序
├── scgi_temp                        # 临时目录
└── uwsgi_temp                       # 临时目录
```

## 配置

### 配置文件测量单位

**容量**

大小可以指定为字节、千字节（后缀 k 和 K）或兆字节（后缀 m 和 M）。

Offsets may be also specified in gigabytes using `g` or `G` suffixes. 也可以使用 g 或 G 后缀以千兆字节为单位指定偏移量。

| 缩写 | 描述   |
| ---- | ------ |
| k,K  | 千字节 |
| m,M  | 兆字节 |

例如, "8k", "1m" 代表字节数计量.  

**时间**

可以使用以下后缀以毫秒、秒、分钟、小时、天等为单位指定时间间隔：

| 单位 | 描述         |
| ---- | ------------ |
| ms   | 毫秒         |
| s    | 秒           |
| m    | 分钟         |
| h    | 小时         |
| d    | 日           |
| w    | 周           |
| M    | 一个月, 30天 |
| y    | 年, 365 天   |

通过按从最高到最低的顺序指定多个单位，并可选地用空格分隔，可以将多个单位组合成一个值。例如，“1h 30m” 指定与 “90m” 或 “5400s” 相同的时间。例如, "1h 30m", "1y 6M" 代表 "1 小时 30 分", "1 年零 6 个月"。

没有后缀的值表示秒。建议始终指定后缀。某些时间间隔只能以秒分辨率指定。

### 配置文件

nginx 及其模块的工作方式在配置文件中确定。默认情况下，配置文件名为 `nginx.conf`，通常位于 `/usr/local/nginx/conf` 、`/etc/nginx` 或 `/usr/local/etc/nginx` 。

nginx 由模块组成，这些模块由配置文件中指定的指令控制。指令分为简单指令和块指令。简单指令由名称和参数组成，用空格分隔，并以分号（`;`）结尾。块指令具有与简单指令相同的结构，但它以一组由大括号（ `{` 和 `}` ）包围的附加指令结尾，而不是分号。如果块指令可以在大括号内包含其他指令，则称为上下文（例如：events 、http 、server 和 location ）。

`#` 符号后的其余行被视为注释。

#### nginx.conf

主配置文件 `/etc/nginx/nginx.conf` 是一个纯文本类型的文件，整个配置文件是以区块的形式组织，通常每一个区块以一对大括号 `{}` 来表示开始与结束。

- Main 位于 nginx.conf 配置文件的最高层。
- Main 层下可以有 Event、HTTP 层。
- Http 层下面允许有多个 Server 层，用于对不同的网站做不同的配置。
- Server 层下面允许有多个 Location，用于对不同的路径进行不同模块的配置。 

​	![](../../../Image/n/nginx_conf.jpeg) 

1. main 块

   全局配置部分，用来配置对整个 server 都有效的参数。主要会设置一些影响 nginx 服务器整体运行的配置指令，主要包括配置运行 Nginx 服务器的用户（组）、允许生成的 worker process 数，进程 PID 存放路径、日志存放路径和类型以 及配置文件的引入等。

2. events 块

   events 块涉及的指令主要影响 Nginx 服务器与用户的网络连接，常用的设置包括是否开启对多 worker process  下的网络连接进行序列化，是否允许同时接收多个网络连接，选取哪种事件驱动模型来处理连接请求，每个 worker process  可以同时支持的最大连接数等。

3. http 块

   可以嵌套多个 server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type 定义，日志自定义，是否使用 sendfile 传输文件，连接超时时间，单连接请求数等。一个 http 中可以有多个 server。

4. server 块

   Server 块也被叫做“虚拟主机”部分，它描述的是一组根据不同 server_name 指令逻辑分割的资源，这些虚拟服务器响应 HTTP  请求，因此都包含在 http 部分。最常见的配置是本虚拟机主机的监听配置和本虚拟主机的名称或 IP 配置。Nginx 必须使用虚拟机配置站点，每个虚拟主机使用一个 server。一个 server 块可以配置多个  location 块。

   通常 Server 配置在独立的 `/etc/nginx/conf.d/*.conf` 中，通过引用的方式调用。

5. location 块

   配置请求的路由，以及各种页面的处理情况。

```nginx
user user [group];
#user  nginx;
# 运行 Nginx 服务器的用户(组),如希望所有用户都可以运行，两种方法：
# 1.注释此项；
# 2.用户和组设置为 nobody 。

worker_processes  number | auto;
#worker_processes  1;
# 默认为 1。worker_processes最多开启8个，8个以上，性能不会再提升了，而且稳定性变得更低。
worker_cpu_affinity auto;
# 利用多核cpu的配置。默认不开启。
# 例如：2核cpu，开启2个进程
#  worker_processes     2;
#  worker_cpu_affinity 01 10;
# 解释：01表示启用第一个CPU内核，10表示启用第二个CPU内核。2核是01，四核是0001，8核是00000001，有多少个核，就有几位数，1表示该内核开启，0表示该内核关闭。

error_log  logs/error.log  cirt;
#error_log  file | stderr [debug | info | notice | warn | error | crit | alert | emerg];
# 错误日志路径及级别。debug输出最为详细，crit输出最少。

pid        logs/nginx.pid;
# Nginx 服务启动的 pid 的存储文件位置。

worker_rlimit_nofile 51200;
# Specifies the value for maximum file descriptors that can be opened by this process.

events {
    # 设定 Nginx 的工作模式及连接数上限。
	use epoll;
    # 处理网络消息的事件驱动模型，可选：
    # select,poll,kqueue,epoll,rtsig,/dev/poll,eventport
    # select 和 poll 都是标准的工作模式。
    # kqueue 和 epoll 是高效的工作模式，不同的是 epoll 用在 Linux 上，kqueue 用在 BSD 上。
    worker_connections  512;
    # 定义每个进程的最大连接数。不仅仅包含和前端用户建立的连接数，而是包含所有可能的连接数。
    # 受系统进程的最大打开文件数限制。
    accept_mutex	on | off;
    # 默认为on,对多个进程接收连接进行序列化，防止多个进程对连接的争抢。
    # 解决“惊群”问题。
    multi_accept	on | off;
    # 是否允许每个 work process 同时接收多个网络连接，默认为 off
}

http {
    include       /etc/nginx/mime.types;	        # 指定在当前文件中包含另一个文件的指令
    default_type  application/octet-stream;	        # 指定默认处理的文件类型可以是二进制

    server_names_hash_bucket_size 128;
    # 服务器名称的hash表大小
    client_header_buffer_size 32k;
    # 指定来自客户端请求头 headerbuffer 大小。
    large_client_header_buffers 4 32k;
    # 指定客户端请求中较大的消息头的缓存最大数量和大小。
    client_max_body_size 1m;
    # 允许用户最大上传数据大小。

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    # 指定日志的输出格式。main 为此日志输出格式的名称。可以在 access_log 指令中引用。
    # 1.$remote_addr 与 $http_x_forwarded_for  用以记录客户端的ip地址；
    # 2.$remote_user                           用来记录客户端用户名称；
    # 3.$time_local                            用来记录访问时间与时区；
    # 4.$request                               用来记录请求的url与http协议；
    # 5.$status                                用来记录请求状态；成功是200， 
    # 6.$body_bytes_s ent                      记录发送给客户端文件主体内容大小；
    # 7.$http_referer                          用来记录从那个页面链接访问过来的；
    # 8.$http_user_agent                       记录客户端浏览器的相关信息；

    #access_log  off;
    # 取消记录服务日志的功能。
    #access_log  logs/access.log  main;
    #访问日志
    
    sendfile        off;
    # 开启高效文件传输模式。将 tcp_nopush 和 tcp_nodely 两个指令设置为 on ，用于防止网络阻塞。
    # 默认为 off
    #优化静态资源
    sendfile_max_chunk	0;
    # 大于0，每个 worker process 每次调用 sendfile() 传输的数据量最大不能超过这个值。
    # 默认值为0，不限制。
    
    #tcp_nopush     on;
    # nginx不要缓存数据，而是一段一段发送
    
    #keepalive_timeout  75;
    # 给客户端分配连接超时时间，服务器会在这个时间过后关闭连接。
    #keepalive_timeout	timeout	[header_timeout];
    # timeout	服务器端对连接的保持时间
    # header_timeout	在应答报文头部的Keep-Alive域设置超时时间。

	#keepalive_requests		number;
	# 默认值为100，限制用户通过某一连接向服务器发送请求的此次。
    
	tcp_nodelay on;

    fastcgi_connect_timeout 300;
    # 连接到后端fastCGI的超时时间
    fastcgi_send_timeout 300;
    # 已经完成两次握手后向fastCGI传送的超时时间
    fastcgi_read_timeout 300;
    # 已经完成两次握手后接收fastCGI应答的超时时间
    fastcgi_buffer_size 64k;
    # 读取fastCGI应答第一部分需要多大的缓冲区
    fastcgi_buffers 4 64k;
    # 本地需要多少和多大的缓冲区来缓冲fastCGI的应答
    fastcgi_busy_buffers_size 128k;
    # 默认值是fastcgi_buffers的2倍
    fastcgi_temp_file_write_size 256k;
    # 在写入fastcgi_temp_path是用多大的数据块，默认值是fastcgi_buffers的2倍

    #gzip  on;
    # 开启gzip压缩输出
    gzip_min_length  1k;
    # 用于设置允许压缩的页面最小字节数，页面字节数从header头的content-length中获取。
    # 默认值是0，不管页面多大都进行压缩，建议设置成大于1k的字节数，小于1k可能会越压越大。
    gzip_buffers     4 16k;
    # 表示申请4个单位为16k的内存作为压缩结果流缓存。
    # 默认值是申请与原始数据大小相同的内存空间来存储gzip压缩结果
    gzip_http_version 1.1;
    # 压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2;
    # 压缩等级。1 压缩比最小，处理速度最快；9 压缩比最大，传输速度快，但处理最慢，CPU资源消耗最大。
    gzip_types     text/plain application/javascript application/x-javascript text/javascript text/css application/xml application/xml+rss;
    # 压缩类型，默认就已经包含 text/html，所以就不用再写了，写上去也不会有问题，但是会有一个warn。
    gzip_vary on;
    # 可让前端的缓存服务器缓存经过gzip压缩的页面，例如，用squid缓存经过nginx压缩的数据。
    gzip_proxied   expired no-cache no-store private auth;
    gzip_disable   "MSIE [1-6]\.";

    #limit_conn_zone $binary_remote_addr zone=perip:10m;
    # If enable limit_conn_zone,add "limit_conn perip 10;" to server section.

    server_tokens off;
    # 隐藏版本号

    server {
        listen       80;
        # 监听端口，默认80
        #listen		127.0.0.1:80;
        #listen		*:80;
        #listen 80 default_server reuseport;
        #listen [::]:80 default_server ipv6only=on;
        server_name  localhost;
        #server_name _;
        # 接受这个 server 块的任何主机名
        # 提供服务的域名或主机名

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
        # 指定此虚拟主机的访问日志存放路径。

        location / {                               # 控制网站访问路径
            root   html;                           # 存放网站的路径
            index  index.html index.htm;           # 默认访问的首页
        }
        
        # 完全匹配     =
        # 大小写敏感   ~
        # 忽略大小写   ~*
        
        #error_page  404              /404.html;   # 错误页面

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;   # 定义请求错误，指定错误代码
        location = /50x.html {                     # 错误代码重定向到新的 location
            root   html;
        }

        location /nginx_status
        {
            stub_status on;
            access_log   off;
        }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #location ~ [^/]\.php(/|$) {
        #    root           html;
        #    try_files $uri =404;
        #    fastcgi_pass  unix:/tmp/php-cgi.sock;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
        access_log  /data/wwwlogs/access.log;
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;
    # SSL证书配置

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    include /etc/nginx/conf.d/*.conf;
}
```

index指令中列出多个文件名，Nginx 按指定的顺序搜索文件并返回它找到的第一个文件。

```nginx
vi /etc/nginx/conf.d/mystie.conf

server {
    server_name  www.cainiaojc.com;
    
    error_page  404 403 500 502 503 504  /error.html;	#配置错误页
    location / {
        root   /usr/share/nginx/base;
        index  index.html;
    }
}
```

### Nginx相关安全策略

#### 禁止访问 htaccess

```nginx
location ~/\.ht {
     deny all;
}
```

#### 禁止访问多个目录

```nginx
 location ~ ^/(picture|move)/ {
      deny all;
      break;i
 }
```

#### 禁止访问 /data 开头的文件

```nginx
 location ~ ^/data {
      deny all;
  }
```

#### 禁止访问单个目录

```nginx
 location /imxhy/images/ {
      deny all;
 }
```

#### 允许特定 ip 访问

```nginx
root /usr/share/nginx/rewrite/;
allow 208.97.167.194;
allow 222.33.1.2;
allow 231.152.49.4;
deny all; 
```

### SELinux

```bash
semanage fcontext -a -t httpd_sys_content_t "/var/www/example.com(/.*)?"
restorecon -Rv /var/www/example.com/
```

## 指令

Nginx 中的配置选项称为指令。该选项有名称和参数，必须以分号 (;) 结尾，否则 Nginx 将无法加载配置并产生错误。例如：

```nginx
gzip on;
```

指令分为两部分：

- **简单指令：**简单指令由名称和参数组成，以空格分隔并以分号 ; 结尾。
- **块指令：** 结构类似于简单指令，但它不是以分号结尾，而是以一组用大括号 { 和 } 括起来的附加指令结尾。如果块指令在大括号内包含其他指令，则它被称为上下文 (context)。例如，Events、http、location 和 server。

配置文件中放置在任何上下文之外的指令都被认为是在**主上下文中**。**events** 与 **http** 指令在**主上下文中**，**server** 指令在 **http** 上下文， **location** 指令在 **server** 上下文。

### 指令类型

由于不同指令的继承模型不同，因此在多个上下文中使用同一个指令时要注意。共有三种类型的指令，每种类型都有其继承模型。

#### 普通的

每个上下文有一个值。只能在上下文中定义它一次。子上下文可以覆盖父指令，但此覆盖仅在给定的子上下文中有效。

```nginx
gzip on;  
gzip off; # 在同一个上下文中有两个普通指令是非法的   
  
server {  
  location /downloads {  
    gzip off;  
  }  
  
  location /assets {  
    # gzip 在这里有效  
  }  
}  
```

#### Array

在同一上下文中添加多条指令会增加值而不是完全覆盖它们。在子上下文中定义指令将覆盖给定子上下文中父级的所有值。

```nginx
error_log /var/log/nginx/error.log;  
error_log /var/log/nginx/error_notive.log notice;  
error_log /var/log/nginx/error_debug.log debug;  
  
server {  
  location /downloads {  
    # 这将覆盖父级所有指令  
    error_log /var/log/nginx/error_downloads.log;  
  }  
} 
```

#### 行动指令Action Directive

动作是用于改变事物的指令。它们的继承行为将取决于模块。

**例如：**在 rewrite 指令的情况下，每个匹配的指令都会被执行。

```nginx
server {  
  rewrite ^ /foobar;  
  
  location /foobar {  
    rewrite ^ /foo;  
    rewrite ^ /bar;  
  }  
}  
```

如果我们尝试访问**/sample**：

- 执行服务器重写，重写从 **/sample** 到 **/foobar**。
- 然后匹配位置 **/foobar**。
- location 里第一个重写被执行，从重写 **/foobar 到 /foo**。
- location 里第二个重写被执行，从重写 **/foo 到 /bar**。

让我们看看**return**指令提供的不同行为：

```nginx
server {  
  location / {  
    return 200;  
    return 404;  
  }  
}
```

从上面的情况来看，200 状态立即返回。

### 常用指令

| **指令**                               | 语法                                                         | 默认配置                             | 上下文                                               |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------ | ---------------------------------------------------- |
| **absolute_redirect**                  | absolute_redirect on \| off;                                 | absolute_redirect on;                | http, server, location                               |
| **accept_mutex**                       | accept_mutex on \| off;                                      | off                                  | Events                                               |
| **accept_mutex_delay**                 | accept_mutex_delay time;                                     | accept_mutex_delay 500ms;            | Events                                               |
| **access_log (ngx_http_log_module)**   | access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]]; access_log off; | access_log logs/access.log combined; | http, server, location, if in location, limit_except |
| **access_log (ngx_stream_log_module)** | access_log path format [buffer=size] [gzip[=level]] [flush=time] [if=condition]; access_log off; | access_log off;                      | stream, server                                       |
| **add_after_body**                     | add_before_body uri;                                         | -                                    | http, server, location                               |
| **add_before_body**                    | add_before_body uri;                                         | -                                    | http, server, location                               |
| **add_header**                         | add_header name value [always];                              | -                                    | http, server, location, if in location               |
| **add_trailer**                        | add_trailer name value [always];                             | -                                    | http, server, location, if in location               |
| **addition_types**                     | addition_types mime-type ...;                                | addition_types text/html;            | http, server, location                               |
| **aio**                                | aio on \| off \| threads[=pool];                             | aio off;                             | http, server, location                               |
| **aio_write**                          | aio_write on \| off;                                         | aio_write off;                       | http, server, location                               |
| **alias**                              | alias path;                                                  | -                                    | Location                                             |
| **allow (ngx_http_access_module)**     | allow address \| CIDR \| unix: \| all;                       | -                                    | http, server, location, limit_except                 |
| **allow (ngx_stream_access_module)**   | allow address \| CIDR \| unix: \| all;                       | -                                    | Stream, server                                       |
| **ancient_browser**                    | ancient_browser string ...;                                  | -                                    | http, server, location                               |
| **ancient_browser_value**              | ancient_browser_value string;                                | ancient_browser_value 1;             | http, server, location                               |
| **api**                                | api [write=on\|off];                                         | -                                    | location                                             |
| **auth_basic**                         | auth_basic string \| off;                                    | auth_basic off;                      | http, server, location, limit_except                 |
| **auth_basic_user_file**               | auth_basic_user_file file;                                   | -                                    | http, server, location, limit_except                 |
| **auth_http**                          | auth_http URL;                                               | -                                    | mail, server                                         |
| **auth_http_header**                   | auth_http_header header value;                               | -                                    | mail, server                                         |
| **auth_http_pass_client_cert**         | auth_http_pass_client_cert on \| off;                        | auth_http_pass_client_cert off;      | mail, server                                         |
| **auth_http_timeout**                  | auth_http_timeout time                                       | auth_http_timeout 60s;               | mail, server                                         |
| **auth_jwt**                           | auth_jwt string [token=$variable] \| off;                    | auth_jwt off;                        | http, server, location, limit_except                 |
| **auth_jwt_claim_set**                 | auth_jwt_claim_set $variable name ...;                       | -                                    | http                                                 |
| **auth_jwt_header_set**                | auth_jwt_header_set $variable name ...;                      | -                                    | http                                                 |
| **auth_jwt_key_file**                  | auth_jwt_key_file file;                                      | -                                    | ttp, server, location, limit_except                  |
| **auth_jwt_key_request**               |                                                              |                                      |                                                      |

### root 指令

用于设置请求的根目录，允许 nginx 将传入的请求映射到文件系统。

```nginx
server {  
  listen 80;  
  server_name localhost;  
  root   html;  
} 		 	
```

### Location 指令

用于根据请求的 URI（统一资源标识符）设置配置。

```nginx
location [modifier] path  
```

**例子：**

```nginx
location /foo {  
  # ...  
}  
```

当没有给出修饰符时，路径被视为前缀，之后可以跟任何东西。上面的例子将匹配：

```nginx
/foo  
/fooo  
/foo123  
/foo/bar/index.html  
... 
```

可以在给定的上下文中使用多个位置指令：

```nginx
server {  
  listen 80;  
  server_name localhost;  
  root   html;
  
  location / {  
    return 200 "root";  
  }  
  
  location /foo {  
    return 200 "foo";  
  }  
}
```

Nginx 还提供了一些可以与**location**指令结合使用的修饰符。

修饰符已分配优先级：

```bash
=           - 完全匹配  
^~          - 优先匹配  
~ && ~*     - 正则表达式匹配  
no modifier - 前缀匹配  
```

首先，nginx 将检查是否有任何完全匹配。如果它不存在，它将寻找优先的。如果此匹配也失败，则将按出现顺序测试正则表达式匹配。如果都失败了，将使用最后一个前缀匹配。

```nginx
location /match {  
  return 200 'Prefix match: will match everything that starting with /match';  
}  
  
location ~* /match[0-9] {  
  return 200 'Case insensitive regex match';  
}  
  
location ~ /MATCH[0-9] {  
  return 200 'Case sensitive regex match';  
}  
  
location ^~ /match0 {  
  return 200 'Preferential match';  
}  
  
location = /match {  
  return 200 'Exact match';  
} 
 
/match # =>  '完全匹配'  
/match0 # =>  '优先匹配'  
/match1 # =>  '不区分大小写的正则表达式匹配'  
/MATCH1 # =>  '区分大小写的正则表达式匹配'  
/match-abc # =>  '前缀匹配：匹配以 /match 开头的所有内容' 
```

### try_files 指令

尝试不同的路径，并将返回找到的任何一个。

```nginx
try_files $uri index.html =404;  
```

所以 /foo.html 将尝试按以下顺序返回文件：

- $uri (/foo.html) 
- index.html 
- If none is found:404 

如果在服务器上下文中定义 try_files，然后定义一个查找所有请求的blocation，try_files  将不会被执行。发生这种情况是因为服务器上下文中的 try_files 定义了伪 location，这是可能的最不具体的  location。因此，定义 location **/** 将比伪 location 更具体。

```nginx
server {  
  try_files $uri /index.html =404;  
  
  location / {  
  }  
}  
```

因此，我们应该避免在服务器上下文中使用 try_files：

```nginx
server {  
  location / {  
    try_files $uri /index.html =404;  
  }  
}  
```

## 上下文

Directives placed in the configuration file outside of any contexts are considered to be in the [main](http://nginx.org/en/docs/ngx_core_module.html) context. The `events` and `http` directives reside in the `main` context, `server` in `http`, and `location` in `server`.

配置文件中放置在任何上下文之外的指令都被认为是在主上下文中。事件和http指令位于主上下文、http中的服务器和服务器中的位置。

在文本编辑器中打开核心 Nginx 配置文件时，首先会注意到配置被组织成树状结构，并被花括号包围，即“{”和“}”。这些被大括号包围的位置称为放置配置指令的**上下文**。上下文可以嵌套在其他上下文中，从而创建上下文层次结构。

```nginx
# 全局上下文  
 ...  
 ...  
 # http 上下文  
http{  
     ...  
     ...  
     # 服务器上下文  
     server {  
              listen 80;  
              server_name example.com;  
              ...  
              ...  
              # Location 上下文  
              location / {              
                          root /var/www/html;              
                          try_files $uri $uri/ =404;          
                          ...  
                          ...  
             }  
    }  
    # 服务器上下文  
    server {  
             ...  
             ...  
             # Location 上下文  
             location / {   
                         ...  
                         ...  
             }  
    }  
    ...  
    ...  
}  
```

从上面的例子中，我们可以看到 HTTP 上下文声明了 HTTP 协议的设置。虚拟主机设置在服务器上下文中声明，包含在 http 上下文中。用于存储 URL 设置的 location 上下文包含在服务器上下文中。

### 主要上下文

最一般的上下文是**主上下文**。它也称为**全局上下文**。主上下文全局设置 Nginx 的设置，并且是唯一未被花括号包围的上下文。

主上下文位于核心 Nginx 配置文件的开头。此上下文的指令不能在任何其他上下文中继承，因此不能被覆盖。

主上下文用于配置在基本级别上影响整个应用程序的详细信息。在主上下文中配置的一些常见详细信息是运行工作进程的用户和组、工作进程总数以及保存主进程 ID 的文件。可以在主上下文级别设置整个应用程序的默认错误文件。

```nginx
user nginx;  
worker_processes auto;  
pid /run/nginx.pid;  
...  
... 
```

### 事件上下文

事件上下文为连接处理设置全局选项。事件上下文包含在主上下文中。Nginx 配置中只能定义一个事件上下文。

Nginx 使用基于事件的连接处理模型，因此在此上下文中定义的指令决定了工作进程应如何处理连接。

```nginx
# main context  
events {  
        # events context  
        worker_connections 768;   
        multi_accept on;  
}  
...  
...  
```

### HTTP 上下文

HTTP 上下文用于保存处理 HTTP 或 HTTPS 流量的指令。

HTTP 上下文是事件上下文的兄弟，因此它们必须并排列出，而不是嵌套。他们都是主要上下文的孩子。

较低的上下文处理请求，此级别的指令控制每个虚拟服务器的定义默认值。

```nginx
ser nginx;  
worker_processes auto;  
pid /run/nginx.pid;  
...  
...  
events {  
        # events context  
        worker_connections 768;   
        multi_accept on;  
        ...  
        ...  
}  
http {  
       sendfile on;   
       tcp_nopush on;     
       tcp_nodelay on;    
       keepalive_timeout 65;  
       ...  
       ...  
}  
```

### 服务器上下文

服务器上下文在 http 上下文中声明。服务器上下文用于定义 Nginx 虚拟主机设置。HTTP 上下文中可以有多个服务器上下文。服务器上下文中的指令处理对与特定域名或 IP 地址关联的资源的请求的处理。

此上下文中的指令可以覆盖许多可能在 http 上下文中定义的指令，包括文档位置、日志记录、压缩等。 除了从 http 上下文中获取的指令之外，我们还可以配置文件以尝试响应请求、发出重定向和重写，并设置任意变量。

```nginx
user nginx;  
worker_processes auto;  
pid /run/nginx.pid;  
...  
...  
events {  
         # events context  
         worker_connections 768;      
         multi_accept on;  
         ...  
         ...  
 }  
http {  
       sendfile on;   
       tcp_nopush on;     
       tcp_nodelay on;    
       keepalive_timeout 65;  
       ...  
       ...  
  
       server {  
                listen 80;  
                server_name domain1.com;  
                root /var/www/html/wordpress;  
                ...  
       
       }  
       server {  
                listen 80;  
                server_name domain2.com;  
                root /var/www/html/drupal;  
                ...  
       
       }  
}  
```

### location上下文

**location上下文**定义指令来处理客户端的请求。当任何对资源的请求到达 Nginx 时，它会尝试将 URI（统一资源标识符）与其中一个location匹配并相应地处理它。

可以在服务器块内定义多个location上下文。此外，一个location上下文也可以嵌套在另一个location上下文中。

```nginx
http {  
       ...  
       ...  
  
       server {  
                listen 80;  
                server_name domain1.com;  
                root /var/www/html/wordpress;  
                ...  
                location /some_url {    
                # configuration for processing URIs starting with /some_url  
                }  
                location /another_url {    
                # configuration for processing URIs starting with /another_url  
                }      
       }  
       server {  
                listen 80;  
                server_name domain2.com;  
                root /var/www/html/drupal;  
                ...  
                location /some_url {    
                # configuration for processing URIs starting with /some_url    
                }  
                location /some_other_url {    
                # configuration for processing URIs starting with /some_other_url  
                }    
       
       }  
}  
```

### upstream上下文

upstream 上下文用于配置和定义上游服务器。允许此上下文定义后端服务器池，Nginx 可以代理请求时使用的后端服务器。这个上下文通常是我们正在配置的各种类型的代理。

upstream 上下文使 Nginx 能够在代理请求的同时执行负载平衡。此上下文在 HTTP 上下文内部和任何服务器上下文外部定义。

upstream 上下文在服务器或 location 块中按名称引用。然后将某种类型的请求传递给定义好的服务器池。然后 upstream 将使用算法（默认为轮询）来确定需要使用哪个特定服务器来处理请求。

```nginx
http{  
     ...  
     ...  
     upstream backend_servers {  
                                server host1.example.com;  
                                server host2.example.com;  
                                server host3.example.com;  
     }  
  
server {  
             listen 80;  
             server_name example.com;  
             location / {  
                           proxy_pass http://backend_servers;  
             }  
  }  
}  
```

### 邮件上下文

尽管 Nginx 最常用作 Web 或反向代理服务器，但它也可以用作高性能邮件代理服务器。用于此类指令的**上下文**称为**邮件上下文**。邮件上下文定义在主上下文或全局上下文内或 http 上下文外。

邮件上下文的主要目的是为在服务器上配置邮件代理解决方案提供一个区域。Nginx 可以将身份验证请求重定向到外部身份验证服务器。然后，它可以提供对 POP3、SMTP 和 IMAP 邮件服务器的访问，以提供实际邮件数据。

通常，邮件上下文如下所示：

```nginx
# main context  
mail {  
       server_name mail.example.com;  
       auth_http   localhost:9000/cgi-bin/nginxauth.cgi;  
       proxy_pass_error_message on;  
       ...  
}  
http {  
  
}  
...  
...  
```

### if 上下文

if 上下文用于允许有条件地执行其中定义的指令。if 上下文就像任何其他编程语言的“if 语句”。如果给定条件返回 true，则 if 上下文将执行包含的指令。

由于某些限制，应尽可能避免使用 if 上下文。

```nginx
http {  
        server {  
                     location /some_url {  
                     if (test_condition) {  
                          # do some stuff here  
                   }  
  
         }  
    }  
}  
```

### limit_except 上下文

limit_except 上下文用于防止在 location 上下文中使用除我们明确允许的方法之外的所有 HTTP 方法。例如，如果某些客户端应该有权访问**POST 内容**并且每个人都应该有能力阅读内容，那么我们可以为此使用**limit_except**上下文。

```nginx
...  
...  
location /wp-admin/ {   
    limit_except GET {   
      allow 127.0.0.1;   
      deny all;   
    }   
}  
...  
...  
```

### 杂项上下文

除了上述上下文之外，Nginx 中可用的上下文很少，如下所述。这些上下文依赖于可选模块并且很少使用。

- **split_clients：** split_client 上下文将客户端的请求拆分为两个或多个类别。该上下文定义在 HTTP 上下文中，主要用于 A/B 测试。
- **geo：** geo 上下文对客户端 IP 地址进行分类。它用于根据连接的 IP 地址映射变量的值。
- **charset_map：**此上下文用于将特定字符集添加到“Content-Type”响应头字段。此外，使用上下文，可以将数据从一个字符集转换为另一个字符集，但有一些限制。
- **map：** map上下文用于创建变量，其值依赖于其他变量的值，并在http上下文中定义。
- **perl/perl_set：**用于在 Perl 中实现位置和变量处理程序，并将 Perl 调用插入 SSI。此外，在 perl_set 上下文的帮助下，我们可以为特定变量安装 Perl 处理程序。
- **类型：**类型上下文用正确的文件扩展名映射 MIME 类型。此上下文可能出现在 http 上下文、服务器上下文或位置上下文中。

## 变量

变量是编程语言的自然组成部分。变量是在 Perl、C/C++、Bourne shell、Perl 等语言中保存各种值的容器。值可以是像“hello world”这样的字符串，像 3.14 这样的数字，甚至是复杂的东西，比如在这些语言中对数组或哈希表的引用。

然而，对于 Nginx 配置语言，变量只能保存一种类型的值，即字符串。但有一个有趣的例外：第三方模块 ngx_array_var 扩展的 Nginx 变量包含数组。

### 变量语法

假设我们的 nginx.conf 配置文件，其中包含以下行：

```nginx
set $a "hello world";  
```

在这里，我们通过来自标准 nginx_rewrite 模块的 set 配置指令为变量“$a”赋值。在这里，我们将字符串值“hello world”分配给“$a”。

从上面的例子中，我们可以看到 Nginx变 量名前面带了一个美元符号（$）。因此，每当我们想在配置文件中添加对 nginx 变量的引用时，我们必须添加一个美元 ($) 前缀。

**让我们看另一个简单的例子，**

```nginx
set $a hello;  
set $b "$a, $a";  
```

从上面的例子中，我们可以看到变量 $a 用于构造变量 $b 的值。所以这两个指令执行完毕后，$a的值为“hello”，$b为“hello, hello”。这种技术称为“变量插值”。

**让我们看看 Nginx 中的变量列表：**

多变的描述

| **变量**                                                  | 描述                                                         |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| **$ancient_browser**                                      | 如果浏览器被识别为古浏览器，则此变量用于等于由 ancient_browser_value 指令设置的值。 |
| **$arg_name**                                             | 请求行中参数的名称。                                         |
| **$args**                                                 | 请求行上的参数列表。                                         |
| **$binary_remote_addr (ngx_http_core_module)**            | 二进制形式的客户端地址。IP4 地址的值长度始终为 4 个字节，IPv6 地址的值长度始终为 16 个字节。 |
| **$binary_remote_addr (ngx_stream_core_module)**          | 二进制形式的客户端地址。IP4 地址的值长度始终为 4 个字节，IPv6 地址的值长度始终为 16 个字节。 |
| **$body_bytes_sent**                                      | 发送到客户端的字节数，不计算响应头。                         |
| **$bytes_received**                                       | 从客户端接收的字节数。                                       |
| **$bytes_sent (ngx_http_core_module)**                    | 发送到客户端的字节数。                                       |
| **$bytes_sent (ngx_http_log_module)**                     | 发送到客户端的字节数。                                       |
| **$bytes_sent (ngx_stream_core_module)**                  | 发送到客户端的字节数。                                       |
| **$connection (ngx_http_core_module)**                    | 连接序列号                                                   |
| **$connection (ngx_http_log_module)**                     | 连接序列号                                                   |
| **$connection (ngx_stream_core_module)**                  | 连接序列号                                                   |
| **$connection_requests (ngx_http_core_module)**           | 当前通过连接发出的请求数。                                   |
| **$connection_requests (ngx_http_log_module)**            | 当前通过连接发出的请求数。                                   |
| **$connections_active**                                   | 与**活动连接**值相同                                         |
| **$connections_reading**                                  | 与**读取**值相同                                             |
| **$connections_waiting**                                  | 与**等待**值相同                                             |
| **$connections_writing**                                  | 与写入值相同。                                               |
| **$content_length**                                       | “内容长度”请求头字段。                                       |
| **$content_type**                                         | “内容类型”请求头域                                           |
| **$cookie_name**                                          | 饼干的名字                                                   |
| **$date_gmt**                                             | GMT（格林威治标准时间）的当前时间。要设置格式，请使用带有*timefmt*参数的*config*命令。 |
| **$date_local**                                           | 本地时区的当前时间。要设置格式，请使用带有*timefmt*参数的*config*命令。 |
| **$document_root**                                        | 当前请求的 root 或 alias 指令的值。                          |
| **$document_uri**                                         | 它与 $uri 相同。                                             |
| **$fastcgi_path_info**                                    | 使用 fastcgi_split_path_info 指令时，$fastcgi_script_name  变量等于该指令设置的第一个捕获的值。以及由 fastcgi_split_path_info 指令设置的第二次捕获的值。此变量用于设置  PATH_INFO 参数。 |
| **$fastcgi_script_name**                                  | 请求 URI（统一资源标识符），或者，如果 URI 以斜杠结尾，则请求 URI 并附加由 fastcgi_index 指令配置的索引文件名。 |
| **$geoip_area_code (ngx_http_geoip_module)**              | 电话区号（仅限美国）。此变量可能包含一些过时的信息，因为相应的数据库字段已被弃用。 |
| **$geoip_area_code (ngx_stream_geoip_module)**            | 电话区号（仅限美国）。此变量可能包含过时的信息，因为不推荐使用相应的数据库字段。 |
| **$geoip_city (ngx_http_geoip_module)**                   | 城市名称，例如“华盛顿”、“莫斯科”。                           |
| **$geoip_city (ngx_stream_geoip_module)**                 | 城市名称，例如“华盛顿”、“莫斯科”。                           |
| **$geoip_city_continent_code (ngx_http_geoip_module)**    | 两个字母的大陆代码。例如，“NA”、“EU”。                       |
| **$geoip_city_continent_code (ngx_stream_geoip_module)**  | 两个字母的大陆代码。例如，“NA”、“EU”。                       |
| **$geoip_city_country_code (ngx_http_geoip_module)**      | 两个字母的大陆代码。例如，“NA”、“EU”。                       |
| **$geoip_city_country_code (ngx_http_geoip_module)**      | 两个字母的国家/地区代码。例如，“RU”、“美国”。                |
| **$geoip_city_country_code (ngx_stream_geoip_module)**    | 两个字母的国家/地区代码。例如，“RU”、“美国”。                |
| **$geoip_city_country_code3 (ngx_http_geoip_module)**     | 三个字母的国家/地区代码。例如，“俄罗斯”、“美国”。            |
| **$geoip_city_country_code3 (ngx_stream_geoip_module)**   | 三个字母的国家/地区代码。例如，“俄罗斯”、“美国”。            |
| **$geoip_city_country_name (ngx_http_geoip_module)**      | 国家名称。例如，“印度”、“美国”。                             |
| **$geoip_city_country_name (ngx_stream_geoip_module)**    | 国家名称。例如，“印度”、“美国”。                             |
| **$geoip_country_code (ngx_http_geoip_module)**           | 两个字母的国家/地区代码。例如，“RU”、“美国”。                |
| **$geoip_country_code (ngx_stream_geoip_module)**         | 两个字母的国家/地区代码。例如，“RU”、“美国”。                |
| **$geoip_country_code3 (ngx_http_geoip_module)**          | 三个字母的国家/地区代码。例如，“俄罗斯”、“美国”。            |
| **$geoip_country_code3 (ngx_stream_geoip_module)**        | 三个字母的国家/地区代码。例如，“俄罗斯”、“美国”。            |
| **$geoip_country_name (ngx_http_geoip_module)**           | 国家名称。例如，“印度”、“美国”。                             |
| **$geoip_country_name (ngx_stream_geoip_module)**         | 国家名称。例如，“印度”、“美国”。                             |
| **$geoip_dma_code (ngx_http_geoip_module)**               | 根据 Google AdWords API 中的地理定位，它是美国的 DMA（指定市场区域）代码或地铁代码。 |
| **$geoip_dma_code (ngx_stream_geoip_module)**             | 根据 Google AdWords API 中的地理定位，它是美国的 DMA（指定市场区域）代码或地铁代码。 |
| **$geoip_latitude (ngx_http_geoip_module)**               | 纬度。                                                       |
| **$geoip_latitude (ngx_stream_geoip_module)**             | 纬度。                                                       |
| **$geoip_longitude (ngx_http_geoip_module)**              | 经度                                                         |
| **$geoip_longitude (ngx_stream_geoip_module)**            | 经度                                                         |
| **$geoip_org (ngx_http_geoip_module)**                    | 组织名称。例如“加州大学”。                                   |
| **$geoip_org (ngx_stream_geoip_module)**                  | 组织名称。例如“加州大学”。                                   |
| **$geoip_postal_code (ngx_http_geoip_module)**            | 邮政编码。                                                   |
| **$geoip_postal_code (ngx_stream_geoip_module)**          | 邮政编码。                                                   |
| **$geoip_region (ngx_http_geoip_module)**                 | 地区名称（省、地区、州、联邦土地、领土），例如，莫斯科市，DC。 |
| **$geoip_region (ngx_stream_geoip_module)**               | 地区名称（省、地区、州、联邦土地、领土），例如，莫斯科市，DC。 |
| **$geoip_region_name (ngx_http_geoip_module)**            | 国家/地区名称（（省、地区、州、联邦土地、领土），例如“莫斯科市”、“哥伦比亚特区”。 |
| **$geoip_region_name (ngx_stream_geoip_module)**          | 国家/地区名称（（省、地区、州、联邦土地、领土），例如“莫斯科市”、“哥伦比亚特区”。 |
| **$gzip_ratio**                                           | 它是实现的压缩率，计算为原始响应大小和压缩响应大小之间的比率。 |
| **$host**                                                 | 来自请求行的主机名，来自主机请求头字段的主机名，或匹配请求的服务器名。 |
| **$hostname (ngx_http_core_module)**                      | 主机名。                                                     |
| **$hostname（ngx_stream_core_module）**                   | 主机名。                                                     |
| **$http2**                                                | 协商协议标识符：h2 表示基于 TLS 的 HTTP/2，h2c 表示基于明文 TCP 的 HTTP/2，否则为空字符串。 |
| **$http_name**                                            | 它是任意的请求头字段：变量名的最后一部分是字段名，它被转换为小写，破折号被下划线代替。 |
| **$https**                                                | 如果连接在 SSL 模式下运行，则它为“on”，否则为空字符串。      |
| **$invalid_referer**                                      | 如果认为“Referer”请求头字段值有效，则字符串为空，否则为 1。  |
| **$is_args**                                              | “？” 如果请求行有参数，否则为空字符串。                      |
| **$jwt_claim_name**                                       | 它返回指定 JWT（JSON Web 令牌）声明的值。                    |
| **$jwt_header_name**                                      | 返回指定 JOSE（JavaScript 对象签名和加密）标头的值。         |
| **$limit_rate**                                           | 设置此变量可启用响应率限制。                                 |
| **$memcached_key**                                        | 定义从 memcached 服务器获取响应的键。                        |
| **$modern_browser**                                       | 如果浏览器被识别为现代浏览器，则等于由 modern_browser_value 指令设置的值。 |
| **$msec（ngx_http_core_module）**                         | 当前时间（以秒为单位），分辨率为 ms（毫秒）。                |
| **$msec（ngx_http_log_module）**                          | 以秒为单位的时间，日志写入时的毫秒分辨率。                   |
| **$msec（ngx_stream_core_module）**                       | 当前时间（以秒为单位），分辨率为 ms（毫秒）。                |
| **$msie**                                                 | 如果浏览器被识别为任何版本的 MSIE (Microsoft Internet Explorer)，则等于 1。 |
| **$nginx_version (ngx_http_core_module)**                 | 显示nginx版本                                                |
| **$nginx_version (ngx_stream_core_module)**               | Nginx 版本。                                                 |
| **$pid (ngx_http_core_module)**                           | 工作进程的PID（进程ID）。                                    |
| **$pid (ngx_stream_core_module)**                         | 工作进程的PID（进程ID）。                                    |
| **$pipe (ngx_http_core_module)**                          | “p”如果请求是流水线的，“。” 否则。                           |
| **$pipe (ngx_http_log_module)**                           | “p”如果请求是流水线的，“。” 否则。                           |
| **$protocol**                                             | 用于与客户端通信的协议：UDP 或 TCP。                         |
| **$proxy_add_x_forwarded_for**                            | 附加了 $remote_addr  变量的“X-Forwarded-For”客户端请求标头字段，用逗号分隔。如果客户端请求标头中不存在“X-Forwarded-For”字段，则  $proxy_add_x_forwarded_for 变量等于 $remote_addr 变量。 |
| **$proxy_host**                                           | proxy_pass 指令中指定的代理服务器的名称和端口。              |
| **$proxy_port**                                           | proxy_pass 指令中指定的代理服务器的端口，或协议的默认端口。  |
| **$proxy_protocol_addr (ngx_http_core_module)**           | 来自 PROXY 协议标头的客户端地址，否则为空字符串。必须先启用 PROXY 协议。这可以通过在 listen 指令中设置代理协议参数来完成。 |
| **$proxy_protocol_addr (ngx_stream_core_module)**         | 来自 PROXY 协议标头的客户端地址，否则为空字符串。必须先启用 PROXY 协议。这可以通过在 listen 指令中设置代理协议参数来完成。 |
| **$proxy_protocol_port (ngx_http_core_module)**           | 来自 PROXY 协议标头的客户端地址，否则为空字符串。必须先启用 PROXY 协议。这可以通过在 listen 指令中设置代理协议参数来完成。 |
| **$proxy_protocol_port (ngx_stream_core_module)**         | 来自 PROXY 协议标头的客户端地址，否则为空字符串。必须先启用 PROXY 协议。这可以通过在 listen 指令中设置代理协议参数来完成。 |
| **$query_string**                                         | 与 $args 相同                                                |
| **$realip_remote_addr (ngx_http_realip_module)**          | 它用于保留原始客户端地址。                                   |
| **$realip_remote_addr (ngx_stream_realip_module)**        | 它用于保留原始客户端地址。                                   |
| **$realip_remote_port (ngx_http_realip_module)**          | 它用于保留原始客户端地址。                                   |
| **$realip_remote_port (ngx_stream_realip_module)**        | 它用于保留原始客户端地址。                                   |
| **$realpath_root**                                        | 与当前请求的别名或根指令值相对应的绝对路径名，所有符号链接都解析为实际路径。 |
| **$remote_addr (ngx_http_core_module)**                   | 客户地址                                                     |
| **$remote_addr (ngx_stream_core_module)**                 | 客户地址                                                     |
| **$remote_port (ngx_http_core_module)**                   | 客户端端口                                                   |
| **$remote_port (ngx_stream_core_module)**                 | 客户端端口                                                   |
| **$remote_user**                                          | 基本身份验证提供的用户名。                                   |
| **$request**                                              | 完整的原始请求行。                                           |
| **$request_body**                                         | 当请求正文被读取到 memory_buffer 时，该变量的值在由 proxy_pass 和 scgi_pass 指令处理的位置中可用。 |
| **$request_body_file**                                    | 带有请求正文的临时文件的名称。                               |
| **$request_completion**                                   | 如果请求已完成，则值为“OK”，否则为空字符串。                 |
| **$request_filename**                                     | 当前请求的文件路径，基于根或别名指令，以及请求 URI。         |
| **$request_id**                                           | 从 16 个随机字节生成的唯一请求标识符，以十六进制表示。       |
| **$request_length (ngx_http_core_module)**                | 请求长度（请求行、请求正文和标头）。                         |
| **$request_length (ngx_http_log_module)**                 | 请求长度（请求行、请求正文和标头）。                         |
| **$request_method**                                       | 请求方法。通常是“GET”或“POST”。                              |
| **$request_time (ngx_http_core_module)**                  | 以毫秒为单位的请求处理时间；从客户端读取第一个字节以来经过的时间。 |
| **$request_time (ngx_http_log_module)**                   | 以毫秒为单位的请求处理时间；从客户端读取第一个字节到最后一个字节发送到客户端后写入日志之间经过的时间。 |
| **$request_uri**                                          | 带有参数的完整原始请求 URI（统一资源标识符）。               |
| **$scheme**                                               | 请求方案可能是 http 或 https                                 |
| **$secure_link**                                          | 显示链接检查的状态，其值取决于所选的操作模式。               |
| **$secure_link_expires**                                  | 请求中传递的链接的生命周期；                                 |
| **$sent_http_name**                                       | 它是任意的响应头域；变量名的最后一部分是转换为小写的字段名称，破折号由下划线代替。 |
| **$sent_trailer_name**                                    | 响应结束时发送的任意字段；变量名的最后一部分是转换为小写的字段名称，破折号由下划线代替。 |
| **$server_addr (ngx_http_core_module)**                   | 接受请求的服务器地址。计算这个变量的值需要一个系统调用。     |
| **$server_addr (ngx_stream_core_module)**                 | 接受请求的服务器地址。计算这个变量的值需要一个系统调用。     |
| **$server_name**                                          | 接受请求的服务器名称。                                       |
| **$server_port (ngx_http_core_module)**                   | 接受请求的服务器端口。                                       |
| **$server_port (ngx_stream_core_module)**                 | 接受连接的服务器端口。                                       |
| **$server_protocol**                                      | 它是一个请求协议，通常是 HTTP/1.0、HTTP/1.1 或 HTTP/2.0。    |
| **$session_log_binary_id**                                | 二进制形式的当前会话 ID。                                    |
| **$session_log_id**                                       | 当前会话 ID。                                                |
| **$session_time**                                         | 以毫秒为单位的会话持续时间，精度为毫秒。                     |
| **$slice_range**                                          | HTTP 字节范围格式的当前切片范围。例如字节=0-1048575          |
| **$spdy**                                                 | SPDY（发音为快速）连接的 SPDY 协议版本，否则为空字符串。     |
| **$spdy_request_priority**                                | 请求 SPDY（发音为快速）连接的优先级，否则为空字符串。        |
| **$ssl_cipher (ngx_http_ssl_module)**                     | 返回用于已建立的 SSL（安全套接字层）连接的密码字符串。       |
| **$ssl_cipher (ngx_stream_ssl_module)**                   | 返回用于已建立的 SSL（安全套接字层）连接的密码字符串。       |
| **$ssl_ciphers (ngx_http_ssl_module)**                    | 它将返回客户端支持的密码列表。这里，已知密码按名称列出，未知密码以十六进制显示，例如，AES128-SHA:AES256-SHA:0x00ff |
| **$ssl_ciphers (ngx_stream_ssl_module)**                  | 它将返回客户端支持的密码列表。这里，已知密码按名称列出，未知密码以十六进制显示，例如，AES128-SHA:AES256-SHA:0x00ff |
| **$ssl_client_cert (ngx_http_ssl_module)**                | 它会返回在PEM（增强保密邮件）的客户端证书建立SSL连接，其中每行除了1日前面添加制表符。 |
| **$ssl_client_cert (ngx_stream_ssl_module)**              | 它会返回在PEM（增强保密邮件）的客户端证书建立SSL连接，其中每行除了1日前面添加制表符。 |
| **$ssl_client_escaped_cert**                              | 它将为已建立的 SSL 连接返回 PEM（隐私增强邮件）中的客户端证书 |
| **$ssl_client_fingerprint (ngx_http_ssl_module)**         | 它将为已建立的 SSL 连接返回客户端证书的 SHA1（安全哈希算法）指纹。 |
| **$ssl_client_fingerprint (ngx_stream_ssl_module)**       | 它将为已建立的 SSL 连接返回客户端证书的 SHA1（安全哈希算法）指纹。 |
| **$ssl_client_i_dn (ngx_http_ssl_module)**                | 根据 RFC 2253，为已建立的 SSL 连接返回客户端证书的“颁发者 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_i_dn (ngx_stream_ssl_module)**              | 根据 RFC 2253，为已建立的 SSL 连接返回客户端证书的“颁发者 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_i_dn_legacy**                               | 返回已建立 SSL 连接的客户端证书的“颁发者 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_raw_cert (ngx_http_ssl_module)**            | 它将为已建立的 SSL 连接返回 PEM（隐私增强邮件）格式的客户端证书。 |
| **$ssl_client_raw_cert (ngx_stream_ssl_module)**          | 它将为已建立的 SSL 连接返回 PEM（隐私增强邮件）格式的客户端证书。 |
| **$ssl_client_s_dn (ngx_http_ssl_module)**                | 根据 RFC2253，为已建立的 SSL 连接返回客户端证书的“主题 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_s_dn (ngx_stream_ssl_module)**              | 根据 RFC2253，为已建立的 SSL 连接返回客户端证书的“主题 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_s_dn_legacy**                               | 返回已建立 SSL 连接的客户端证书的“主题 DN”（其中 DN 是专有名称）字符串。 |
| **$ssl_client_serial (ngx_http_ssl_module)**              | 它将返回已建立 SSL 连接的客户端证书的序列号。                |
| **$ssl_client_serial (ngx_stream_ssl_module)**            | 它将返回已建立 SSL 连接的客户端证书的序列号。                |
| **$ssl_client_v_end (ngx_http_ssl_module)**               | 它将返回客户端证书的结束日期。                               |
| **$ssl_client_v_end (ngx_stream_ssl_module)**             | 它将返回客户端证书的结束日期。                               |
| **$ssl_client_v_remain (ngx_http_ssl_module)**            | 它将返回客户端证书到期前的天数。                             |
| **$ssl_client_v_remain (ngx_stream_ssl_module)**          | 它将返回客户端证书到期前的天数。                             |
| **$ssl_client_v_start (ngx_http_ssl_module)**             | 它将返回客户端证书的开始日期。                               |
| **$ssl_client_v_start (ngx_stream_ssl_module)**           | 它将返回客户端证书的开始日期。                               |
| **$ssl_client_verify (ngx_http_ssl_module)**              | 如果证书不存在，它将返回客户端证书验证的结果：“SUCCESS”、“FAILD:reason”和“NONE”。 |
| **$ssl_client_verify (ngx_stream_ssl_module)**            | 如果证书不存在，它将返回客户端证书验证的结果：“SUCCESS”、“FAILD:reason”和“NONE”。 |
| **$ssl_curves (ngx_http_ssl_module)**                     | 返回客户端支持的曲线列表。所有已知曲线均按名称列出，未知曲线以十六进制显示，例如：0x001d:prime256v1:secp521r1:secp384r1 |
| **$ssl_curves (ngx_stream_ssl_module)**                   | 返回客户端支持的曲线列表。所有已知曲线均按名称列出，未知曲线以十六进制显示，例如：0x001d:prime256v1:secp521r1:secp384r1 |
| **$ssl_early_data**                                       | 如果使用 TLS 1.3 早期数据并且握手未完成，它将返回 1，否则返回空。 |
| **$ssl_preread_alpn_protocols**                           | 它返回客户端通过 ALPN 发布的协议列表，值之间用逗号分隔。     |
| **$ssl_preread_protocol**                                 | 客户端支持的最高 SSL（安全套接字层）协议版本。               |
| **$ssl_preread_server_name**                              | 返回通过 SNI（服务器名称指示）请求的服务器的名称。           |
| **$ssl_protocol (ngx_http_ssl_module)**                   | 它将返回已建立的 SSL 连接的协议。                            |
| **$ssl_protocol (ngx_stream_ssl_module)**                 | 它将返回已建立的 SSL 连接的协议。                            |
| **$ssl_server_name (ngx_http_ssl_module)**                | 返回通过 SNI（服务器名称指示）请求的服务器的名称。           |
| **$ssl_server_name (ngx_stream_ssl_module)**              | 返回通过 SNI（服务器名称指示）请求的服务器的名称。           |
| **$ssl_session_id (ngx_http_ssl_module)**                 | 它将返回已建立的 SSL 连接的会话标识符。                      |
| **$ssl_session_id (ngx_stream_ssl_module)**               | 它将返回已建立的 SSL 连接的会话标识符。                      |
| **$ssl_session_reused (ngx_http_ssl_module)**             | 如果 SSL 会话被重用，则返回“r”或“。” 否则。                  |
| **$ssl_session_reused (ngx_stream_ssl_module)**           | 如果 SSL 会话被重用，则返回“r”或“。” 否则。                  |
| **$status (ngx_http_core_module)**                        | 响应状态。                                                   |
| **$status (ngx_http_log_module)**                         | 响应状态。                                                   |
| **$status (ngx_stream_core_module)**                      | 会话状态，可以是以下之一： 200：会话成功完成。400：无法解析客户端的数据。403：禁止访问。500内部服务器错误。502错误的网关。503服务不可用。 |
| **$tcpinfo_rtt**                                          | 显示有关客户端 TCP 连接的信息，在支持*TCP_INFO*套接字选项的系统上可用。 |
| **$tcpinfo_rttvar**                                       | 显示有关客户端 TCP 连接的信息，在支持*TCP_INFO*套接字选项的系统上可用。 |
| **$tcpinfo_snd_cwnd**                                     | 显示有关客户端 TCP 连接的信息，在支持*TCP_INFO*套接字选项的系统上可用。 |
| **$tcpinfo_rcv_space**                                    | 显示有关客户端 TCP 连接的信息，在支持*TCP_INFO*套接字选项的系统上可用。 |
| **$time_iso8601 (ngx_http_core_module)**                  | 以 ISO 8601 标准格式显示当地时间。                           |
| **$time_iso8601 (ngx_http_log_module)**                   | 以 ISO 8601 标准格式显示当地时间。                           |
| **$time_iso8601 (ngx_stream_core_module)**                | 以 ISO 8601 标准格式显示当地时间。                           |
| **$time_local (ngx_http_core_module)**                    | 以普通日志格式显示当地时间                                   |
| **$time_local (ngx_http_log_module)**                     | 以普通日志格式显示当地时间。                                 |
| **$time_local (ngx_stream_core_module)**                  | 以普通日志格式显示当地时间。                                 |
| **$uid_got**                                              | cookie 的名称和收到的客户端标识符。                          |
| **$uid_reset**                                            | 如果变量设置为 ?non-empty' 字符串意味着不是 ?0'，那么客户端标识符将被重置。特殊值**日志**还会导致将有关重置标识符的消息输出到 error_log。 |
| **$uid_set**                                              | cookie 的名称和发送的客户端标识符。                          |
| **$upstream_addr (ngx_http_upstream_module)**             | 它将保留 IP 地址和端口，或到上游服务器的 UNIX 域套接字的路径。如果在请求处理期间联系了多个服务器，则它们的地址用逗号分隔。 |
| **$upstream_addr (ngx_stream_upstream_module)**           | 它将保留 IP 地址和端口，或到上游服务器的 UNIX 域套接字的路径。如果在请求处理期间联系了多个服务器，则它们的地址用逗号分隔。 |
| **$upstream_bytes_received (ngx_http_upstream_module)**   | 从上游流服务器接收的字节数。来自多个连接的值由逗号 (,) 和冒号 (:) 分隔，就像 $upstream_addr 变量中的地址一样。 |
| **$upstream_bytes_received (ngx_stream_upstream_module)** | 从上游流服务器接收的字节数。来自多个连接的值由逗号 (,) 和冒号 (:) 分隔，就像*$upstream_addr*变量中的地址一样。 |
| **$upstream_bytes_sent (ngx_http_upstream_module)**       | 发送到上游流服务器的字节数。来自多个连接的值由逗号 (,) 和冒号 (:) 分隔，就像*$upstream_addr*变量中的地址一样。 |
| **$upstream_bytes_sent (ngx_stream_upstream_module)**     | 发送到上游流服务器的字节数。来自多个连接的值由逗号 (,) 和冒号 (:) 分隔，就像*$upstream_addr*变量中的地址一样。 |
| **$upstream_cache_status**                                | 它将保持访问响应缓存的状态。状态可以是“BYPASS”、“MISS”、“EXPIRED”、“STALE”、“REVALIDATED”、“UPDATING”或“HIT”。 |
| **$upstream_connect_time (ngx_http_upstream_module)**     | 用于保持与上游服务器（1.9.1）建立连接所花费的时间；时间以秒为单位，分辨率为毫秒。在 SSL 的情况下，增加了握手所花费的时间。多个连接的时间用逗号 (,) 和冒号 (:) 分隔，就像 $upstream_addr 变量中的地址一样。 |
| **$upstream_connect_time (ngx_stream_upstream_module)**   | 保持连接上游服务器的时间；时间以秒为单位，精度为毫秒。多个连接的时间用逗号 (,) 分隔，如 $upstream_addr 变量中的地址。 |
| **$upstream_cookie_name**                                 | 上游服务器在 Set-Cookie 响应头字段中发送的具有定义名称的 Cookie。仅保存来自最后一个服务器响应的 cookie。 |
| **$upstream_first_byte_time**                             | 接收第一个数据字节的时间。时间以秒为单位，分辨率为毫秒。多个连接的时间用逗号 (,) 分隔，如 $upstream_addr 变量中的地址。 |
| **$upstream_header_time**                                 | 它用于保持从上游服务器接收标头所花费的时间。多个连接的时间用逗号 (,) 和冒号 (:) 分隔，就像 $upstream_addr 变量中的地址一样。 |
| **$upstream_http_name**                                   | 保留服务器响应头字段。                                       |
| **$upstream_queue_time**                                  | 用于保持请求在上游队列中花费的时间；时间以秒为单位，精度为毫秒。多个连接的时间用逗号 (,) 和冒号 (:) 分隔，就像 $upstream_addr 变量中的地址一样。 |
| **$upstream_response_length**                             | 它用于保持从上游服务器获得的响应的长度。长度以字节为单位。多个响应的长度由逗号 (,) 和冒号 (:) 分隔，如 $upstream_addr 变量中的地址。 |
| **$upstream_response_time**                               | 它用于保持从上游服务器接收响应所花费的时间；时间以秒为单位，精度为毫秒。多个连接的时间用逗号 (,) 和冒号 (:) 分隔，就像 $upstream_addr 变量中的地址一样。 |
| **$upstream_session_time**                                | 以毫秒为单位的会话持续时间。多个连接的时间用逗号 (,) 分隔，如 $upstream_addr 变量中的地址。 |
| **$upstream_status**                                      | 它用于保存从上游服务器获得的响应的状态码。多个响应的状态代码由逗号 (,) 和冒号 (:) 分隔，类似于 $upstream_addr 变量中的地址。如果无法选择服务器，则该变量会保留 502（错误网关）状态代码。 |
| **$upstream_trailer_name**                                | 它用于保持字段远离从上游服务器获得的响应的末尾。             |
| **$uri**                                                  | 请求中的当前 URI，已标准化。我们可以在请求处理期间更改 $uri 的值，例如在进行内部重定向或使用索引文件时。 |

## 静态网页服务器

一个重要的任务是提供文件（如图像或静态 HTML 页面）。将实现一个示例，根据请求，文件将从不同的本地目录被提供：`/data/www`（可能包含 HTML 文件）和 `/data/images`（包含图像）。需要编辑配置文件，并在 http 块内设置具有两个 location 块的 server 块。

首先，创建 `/data/www` 目录，并将包含任何文本内容的 `index.html` 文件放入其中，然后创建 `/data/images` 目录，并在其中放置一些图像。

接下来，打开配置文件。默认配置文件已经包含了 `server` 块的几个示例，其中大部分已注释掉。现在，注释掉所有这些块并开始新的 `server` 块：

```nginx
http {
    server {
    }
}
```

通常，配置文件可以包括多个 `server` 块，这些 `server` 块通过它们侦听的端口和服务器名称进行区分。一旦 nginx 决定了哪个 `server` 处理请求，它就会根据 `server` 块中定义的 `location` 指令的参数测试请求头中指定的 URI 。

将以下 `location` 块添加到 `server` 块：

```nginx
location / {
    root /data/www;
}
```

此 `location` 块指定与请求的 URI 相比较的“ `/` ”前缀。对于匹配的请求，URI 将添加到 `root` 指令中指定的路径，即 `/data/www` ，以形成本地文件系统上所请求文件的路径。如果有几个匹配的 `location` 块，nginx 选择前缀最长的块。上面的 `location` 块提供长度为 1 的最短前缀，因此只有当所有其他 `location` 块都无法提供匹配时，才会使用此块。

接下来，添加第二个 `location` 块：

```nginx
location /images/ {
 root /data/images;
}
```

它将匹配以 `/images/` 开头的请求（ `location /` 也匹配此类请求，但前缀更短）。

`server` 块的最终配置应如下所示：

```nginx
server {
 location / {
     root /data/www;
 }

 location /images/ {
     root /data/images;
 }
}
```

这已经是一个服务器的工作配置，该服务器在标准端口 80 上侦听，并可以在本地通过 `http://localhost/` 访问。响应 URI 以 `/images/` 开头的请求，服务器将从 `/data/images` 目录发送文件。例如，响应 `http://localhost/images/example.png` 请求，nginx 将发送 `/data/images/example.png` 文件。如果文件不存在，nginx 将发送一个响应，指示 404 错误。URI 不以 `/images/` 开头的请求将映射到 `/data/www` 目录。例如，响应 `http://localhost/some/example.html` 请求，nginx 将发送 `/data/www/some/example.html` 文件。

要应用新配置，如果 nginx 尚未启动，请启动它，或者通过执行以下操作向 nginx 的主进程发送重载信号：

```bash
nginx -s reload
```

如果不能按预期工作，可以尝试在 `/usr/local/nginx/logs` 或 `/var/log/nginx` 目录下的 `access.log` 和 `error.log` 文件中查找原因。

## 根目录和索引文件

root 指令用于定义将用于搜索文件的根目录。为了获得请求文件的路径，NGINX 将请求的 URI 附加到由 root 指令定义的路径。该指令可以放置在服务器 {}、http {} 或位置 {} 上下文中的任何级别。

让我们看一个例子；在这里，为虚拟服务器指定了 root 指令。它适用于所有没有添加 root 指令来显式重新定义 root 的 location {} 块：

```nginx
server {  
    root /www/data;  
  
    location / {  
    }  
  
    location /images/ {  
    }  
  
    location ~ \.(mp3|mp4) {  
        root /www/media;  
    }  
}  
```

在上面的例子中，NGINX 在文件系统的 /www/data/images/ 目录中搜索以 /images/ 开头的 URI（统一资源标识符）。但是如果 URI 以  .mp3 或 .mp4 扩展名结尾，NGINX 会在 /www/media/ 目录中查找该文件，因为它是在匹配的 locatioin  块中指定的，覆盖了上一级的 root 指令。

如果请求后缀带有斜杠，NGINX 会将其视为对目录的请求，并尝试在该目录中查找索引文件并返回。index 指令指定索引文件的名称（默认值为 index.html）。继续这个例子，如果请求 URI 是*/images/some/path/*，NGINX 传送文件**/www/data/images/some/path/index.html**如果它存在。如果没有，则默认情况下 NGINX 返回 HTTP 代码 404（未找到）。要将 NGINX 配置为返回自动生成的目录列表，请将“on”参数添加到自动索引指令中：

```nginx
location /images/ {  
    autoindex on;  
} 
```

我们可以在 index 指令中列出多个文件名。NGINX 按指定顺序查找文件并返回它找到的第一个文件。

```
location / {  
    index index.$geo.html index.htm index.html;  
}  
```

这里使用的 $geo 变量是通过 geo 指令设置的自定义变量。该变量的值取决于客户端的 IP 地址。

为了返回索引文件，NGINX 检查文件是否存在，然后通过将索引文件的名称附加到基本 URI 来进行内部重定向到 URI。这个内部重定向产生一个新的 location 搜索匹配过程，如下例所示：

```
location / {  
    root /data;  
    index index.html index.php;  
}  
  
location ~ \.php {  
    fastcgi_pass localhost:8000;  
    #...  
}  
```

在上面的例子中，如果请求中的 URI 是 /path/，并且 /data/path/index.html 不存在但  /data/path/index.php 存在，则内部重定向到 /path/index.php ，然后新的匹配到第二个 location ~  \.php { } ,请求被代理。

## try_files尝试几种选择

try_files 指令可用于检查定义的文件或目录是否存在；如果有，NGINX 会进行内部重定向，如果没有，则返回指定的状态代码。例如，要检查文件是否与请求 URI 对应，请使用 try_files 指令和 $uri 变量，如下所示：

```
server {  
    root /www/data;  
  
    location /images/ {  
        try_files $uri /images/default.gif;  
    }  
}  
```

该文件以 URI 的形式定义，使用在当前位置或虚拟服务器的上下文中设置的 root 或 alias 指令进行处理。在这种情况下，如果原始  URI 对应的文件不存在，NGINX 将内部重定向到最后一个参数指定的 URI，返回 /www/data/images/default.gif。

最后一个参数也可以是一个状态码，直接在等号或命名 location 之前。在下面的示例中，如果 try_files 指令的任何参数都没有解析为现有文件或目录，则会返回 404 错误。

```
location / {  
    try_files $uri $uri/ $uri.html =404;  
}  
```

## 优化服务内容的性能

加载速度是提供任何内容的关键因素。对我们的 NGINX 配置进行小幅优化可能会提高生产力并有助于达到最佳性能。

**启用发送文件**

默认情况下，NGINX 自己控制文件传输，并在发送之前将文件复制到缓冲区中。当我们启用 sendfile  指令时，它将消除将数据复制到缓冲区的步骤，并允许将数据从一个文件描述符直接复制到另一个文件描述符。或者，为了阻止快速连接完全占用工作进程，我们可以使用 sendfile_max_chunk 指令来限制在单个 sendfile() 调用中传输的数据量（在本例中为 1 MB）：

```
location /mp3 {  
    sendfile           on;  
    sendfile_max_chunk 1m;  
    #...  
}  
```

**启用 tcp_nopush**

将 tcp_nopush 指令与指令中的 sendfile 一起添加。这使 NGINX 能够在从 sendfile() 获取数据块后立即在一个数据包中发送 HTTP 响应标头。

```
location /mp3 {  
    sendfile   on;  
    tcp_nopush on;  
    #...  
} 
```

## 虚拟主机

每一个虚拟主机相当于一个在同一台服务器中却相互独立的站点，从而实现一台主机对外提供多个 web 服务，每个虚拟主机之间是独立的，互不影响的。

### 虚拟主机类型

- 基于 IP 的虚拟主机
- 基于域名的虚拟主机
- 基于端口的虚拟主机

### 基于IP虚拟主机

**1. 增加主机IP**

目标主机需要主机配备 2 个以上 ip 。

**2. 创建站点目录和网页**

```bash
mkdir -p /home/wwwroot/ipsite01/
mkdir -p /home/wwwroot/ipsite02/

echo 'ipsite01' > /home/wwwroot/ipsite01/index.html
echo 'ipsite02' > /home/wwwroot/ipsite02/index.html
```

**3. nginx 配置虚拟主机**

```nginx
server {
    listen  80;			                                       #监听端口
    server_name  192.168.1.1;	                               #配置虚拟主机名和 IP
    location / {
        root /home/wwwroot/ipsite01/;		                   #请求匹配路径
        index  index.html;			                           #指定主页
        access_log  /home/wwwlog/ipsite01.access.log  main;
        error_log   /home/wwwlog/ipsite01.error.log  warn;
    }
}
server {
    listen  80;
    server_name  192.168.1.1;
    location / {
        root /home/wwwroot/ipsite02/;
        index  index.html;
        access_log  /home/wwwlog/ipsite02.access.log  main;
        error_log   /home/wwwlog/ipsite02.error.log  warn;
    }
}
```

**4. 检查配置文件是否正确并重启加载配置生效**

```bash
nginx -t 	            #检查配置文件
nginx -s reload			#重载配置文件
```

### 基于域名虚拟主机

**1. 创建站点目录和网页**

```bash
mkdir -p /home/wwwroot/domainsite01/
mkdir -p /home/wwwroot/domainsite02/

echo 'domainsite01' > /home/wwwroot/domainsite01/index.html
echo 'domainsite02' > /home/wwwroot/domainsite02/index.html
```

**2. nginx 配置虚拟主机**

```nginx
server {
    listen  80;			                                             #监听端口
    server_name  www.cainiaojc.com;	                                 #配置虚拟主机域名
    location / {
        root /home/wwwroot/domainsite01/;		                     #请求匹配路径
        index  index.html;			                                 #指定主页
        access_log  /home/wwwlog/domainsite01.access.log  main;
        error_log   /home/wwwlog/domainsite01.error.log  warn;
    }
}
server {
    listen  80;
    server_name  man.niaoge.com;
    location / {
        root /home/wwwroot/domainsite02/;		                     #请求匹配路径 
        index  index.html;
        access_log  /home/wwwlog/domainsite02.access.log  main;
        error_log   /home/wwwlog/domainsite02.error.log  warn;
    }
}
```

**3. 检查配置文件是否正确并重启加载配置生效**

```bash
nginx -t 	            #检查配置文件
nginx -s reload			#重载配置文件
```

### 基于端口虚拟主机

**1. 创建站点目录和网页**

```bash
mkdir -p /home/wwwroot/portsite01/
mkdir -p /home/wwwroot/portsite02/
echo 'portsite01' > /home/wwwroot/portsite01/index.html
echo 'portsite02' > /home/wwwroot/portsite02/index.html
```

**2. nginx 配置虚拟主机**

```nginx
server {
    listen  8080;			                                    #监听端口
    server_name  www.cainiaojc.com;	                            #配置虚拟主机域名
    location / {
        root /home/wwwroot/portsite01/;		                    #请求匹配路径
        index  index.html;			                            #指定主页
        access_log  /home/wwwlog/portsite01.access.log  main;
        error_log   /home/wwwlog/portsite01.error.log  warn;
    }
}
server {
    listen  8090;
    server_name www.cainiaojc.com;
    location / {
        root /home/wwwroot/portsite02/;		                    #请求匹配路径 
        index  index.html;
        access_log  /home/wwwlog/portsite02.access.log  main;
        error_log   /home/wwwlog/portsite02.error.log  warn;
    }
}
```

**3. 检查配置文件是否正确并重启加载配置生效**

```bash
nginx -t 	            #检查配置文件
nginx -s reload			#重载配置文件
```

## 处理请求

### 基于名称的虚拟服务器

nginx 首先决定哪个 *server* 应该处理请求。从一个简单的配置开始，其中所有三个虚拟服务器都在端口 *：80 上侦听：

```nginx
server {
 listen      80;
 server_name example.org www.example.org;
 ...
}

server {
 listen      80;
 server_name example.net www.example.net;
 ...
}

server {
 listen      80;
 server_name example.com www.example.com;
 ...
}
```

在此配置中，nginx 仅测试请求的标头字段 “Host” ，以确定请求应路由到哪个服务器。如果其值与任何服务器名称都不匹配，或者请求根本不包含此标头字段，则 nginx 会将请求路由到此端口的默认服务器。在上面的配置中，默认服务器是第一个——这是 nginx 的标准默认行为。还可以使用 listen 指令中的 `default_server` 参数显式设置哪个服务器应该是默认的：

```nginx
server {
 listen      80 default_server;
 server_name example.net www.example.net;
 ...
}
```

> Note：
>
> 该 `default_server` 参数从版本 0.8.21 开始可用。在早期版本中，应改用该 `default` 参数。
>
> 请注意，默认服务器是侦听端口的属性，而不是服务器名称的属性。

### 如何防止处理具有未定义服务器名称的请求

如果不允许没有 “Host” 标头字段的请求，则可以定义仅丢弃请求的 server ：

```nginx
server {
    listen      80;
    server_name "";
    return      444;
}
```

在这里，server 名称被设置为一个空字符串，该字符串将匹配没有 “Host” 标头字段的请求，并返回一个特殊的 nginx 非标准代码 444 来关闭连接。

> Note：
>
> 从版本 0.8.48 开始，这是服务器名称的默认设置，因此 `server_name ""` 可以省略。在早期版本中，计算机的主机名用作默认服务器名称。

### 基于名称和基于 IP 的混合虚拟服务器
一个更复杂的配置，其中一些虚拟服务器侦听不同的地址：

```nginx
server {
    listen      192.168.1.1:80;
    server_name example.org www.example.org;
    ...
}

server {
    listen      192.168.1.1:80;
    server_name example.net www.example.net;
    ...
}

server {
    listen      192.168.1.2:80;
    server_name example.com www.example.com;
    ...
}
```

For example, a request for `www.example.com` received on the 192.168.1.1:80 port will be handled by the default server of the 192.168.1.1:80 port, i.e., by the first server, since there is no `www.example.com` defined for this port. 
在此配置中，nginx 首先根据 server 块的 listen 指令测试请求的 IP 地址和端口。然后，它根据与 IP 地址和端口匹配的 server 块的 server_name 条目测试请求的 “Host” 标头字段。如果未找到 server 名称，则默认服务器将处理该请求。例如，在 192.168.1.1:80 端口上接收的一个 `www.example.com` 的请求，将由 192.168.1.1:80 端口的默认服务器（即第一台服务器）处理，因为没有为此端口定义 `www.example.com` 。

如前所述，默认服务器是侦听端口的一个属性，可以为不同的端口定义不同的默认服务器：

```nginx
server {
    listen      192.168.1.1:80;
    server_name example.org www.example.org;
    ...
}

server {
    listen      192.168.1.1:80 default_server;
    server_name example.net www.example.net;
    ...
}

server {
    listen      192.168.1.2:80 default_server;
    server_name example.com www.example.com;
    ...
}
```

### 一个简单的 PHP 站点配置

现在让我们看看 nginx 如何选择一个 *location* 来处理一个典型的、简单的 PHP 站点的请求：

```nginx
server {
    listen      80;
    server_name example.org www.example.org;
    root        /data/www;

    location / {
        index   index.html index.php;
    }

    location ~* \.(gif|jpg|png)$ {
        expires 30d;
    }

    location ~ \.php$ {
        fastcgi_pass  localhost:9000;
        fastcgi_param SCRIPT_FILENAME
                      $document_root$fastcgi_script_name;
        include       fastcgi_params;
    }
}
```

nginx 首先搜索由文字字符串给出的最具体的前缀位置，而不管列出的顺序如何。在上面的配置中，唯一的前缀位置是“ `/` ”，由于它与任何请求匹配，因此将用作最后的手段。然后 nginx 按照配置文件中列出的顺序检查正则表达式给出的 location 。The first matching expression stops the search 第一个匹配的表达式停止搜索，nginx 将使用此 location 。如果没有正则表达式与请求匹配，则 nginx 使用之前找到的最具体的前缀位置。

请注意，所有类型的位置仅测试请求行的 URI 部分，而不带参数。之所以这样做，是因为查询字符串中的参数可以通过多种方式给出，例如：

```http
/index.php?user=john&page=1
/index.php?page=1&user=john
```

此外，任何人都可以在查询字符串中请求任何内容：

```http
/index.php?page=1&something+else&user=john
```

现在，让我们看看在上面的配置中如何处理请求：

- 请求 `/logo.gif` 首先与前缀位置 `/ `匹配，然后由正则表达式 `\.(gif|jpg|png)$` 匹配，因此，它由后一个位置处理。使用指令 `root /data/www` 将请求映射到文件 ，并将文件 `/data/www/logo.gif` 发送到客户端。
- 请求 `/index.php` 也首先由前缀位置 `/` 匹配，然后由正则表达式 `\.(php)$` 匹配。因此，它由后一个位置处理，并将请求传递到侦听  localhost:9000 的 FastCGI 服务器。fastcgi_param 指令将 FastCGI 参数 `SCRIPT_FILENAME` 设置为 `/data/www/index.php` ，FastCGI 服务器执行该文件。变量 `$document_root` 等于根指令的值，变量 `$fastcgi_script_name` 等于请求 URI，即 `/index.php` 。
- 请求 `/about.html` 仅与前缀位置 `/` 匹配，因此，它在此位置进行处理。使用指令 `root /data/www` 将请求映射到文件 ，并将文件 `/data/www/about.html` 发送到客户端。
- 处理请求 `/` 更为复杂。它仅与前缀位置 `/` 匹配，因此，它由此 location 处理。然后，index 指令根据索引文件的参数和 `root /data/www`  指令测试索引文件是否存在。如果 `/data/www/index.html` 文件不存在，而文件 `/data/www/index.php` 存在，则指令会执行内部重定向到 `/index.php` ，nginx 会再次搜索这些位置，就好像请求是由客户端发送的一样。正如我们之前所看到的，重定向的请求最终将由 FastCGI 服务器处理。

我们可以指定多个虚拟服务器，每个服务器由一个**server {}**上下文描述。

```
server {
  listen      *:80 default_server;
  server_name cainiaojc.com;

  return 200 "Hello from javatpoint.co";
}

server {
  listen      *:80;
  server_name nikita.co;

  return 200 "Hello from nikita.co";
}

server {
  listen      *:81;
  server_name deep.co;

  return 200 "Hello from deep.co";
}
```

上面的例子中，nginx 将检查 listen 指令以测试哪个虚拟服务器正在侦听给定的 IP: port组合，然后检查Host 标头中的域名匹配 **server_name 指令**的值。

Nginx 按以下顺序选择虚拟服务器：

- IP: port 上的服务器列表，带有匹配的指令，如 **server_name**。
- P: port 上的服务器列表，带有 **default_server** 标志；
- P: port 上的服务器列表，第一个已定义。
- 如果没有匹配项，则拒绝连接。

从上面的例子中，输出将是：

```
Request to nikita.co:80     => "Hello from nikita.co"
Request to www.nikita.co:80 => "Hello from cainiaojc.co"
Request to deep.co:80     => "Hello from cainiaojc.co"
Request to deep.co:81     => "Hello from nikita.co"
Request to nikita.co:81     => "Hello from deep.co"
```

## server_name 指令

server_name 指令用于接受多个值；它还用于处理通配符匹配和正则表达式。

```
server_name cainiaojc.com; ＃ 完全符合  
server_name *.cainiaojc.com; # 通配符匹配  
server_name cainiaojc.*; # 通配符匹配  
server_name ~^[ 0 - 9 ]*\.cainiaojc\.com$; # 正则匹配  
```

如果有任何歧义，那么 nginx 使用以下顺序：

- 完全匹配名称；
- 以星号开头的最长通配符名称，例如“*examples.org”，
- 以星号结尾的最长通配符名称，例如“mail.*”；
- 第一个匹配的正则表达式。

Nginx 将存储三个哈希表：确切名称、以星号开头的通配符和以星号结尾的通配符。如果结果不在上面声明的表中，则将按顺序测试正则表达式。

```
server_name .cainiaojc.com;
```

它是以下的缩写：

```
server_name  cainiaojc.co  www.cainiaojc.co  *.cainiaojc.co;  
```

只有一个区别：.cainiaojc.co 存储在第二个表中，这意味着它比显式声明慢一点。

## Server 名

server 名称是使用 server_name 指令定义的，用于确定哪个 server 块用于给定请求。可以使用确切名称、通配符名称或正则表达式来定义它们：

```nginx
server {
    listen       80;
    server_name  example.org  www.example.org;
    ...
}

server {
    listen       80;
    server_name  *.example.org;
    ...
}

server {
    listen       80;
    server_name  mail.*;
    ...
}

server {
    listen       80;
    server_name  ~^(?<user>.+)\.example\.net$;
    ...
}
```

按名称搜索虚拟服务器时，如果名称与多个指定的变体匹配，例如通配符名称和正则表达式都匹配，则将按以下优先顺序选择第一个匹配的变体：

1. 确切名称
2. 以星号开头的最长通配符名称，例如 `*.example.org`
3. 以星号结尾的最长通配符名称，例如 `mail.*`
4. 第一个匹配的正则表达式（按配置文件中的出现顺序）

### 通配符名称

A wildcard name may contain an asterisk only on the name’s start or end, and only on a dot border. 通配符名称只能在名称的开头或结尾包含星号，并且只能在点边框上包含星号。名称 `www.*.example.org` 和 `w*.example.org` 无效。但是，可以使用正则表达式指定这些名称，例如 `~^www\..+\.example\.org$` 和 `~^w.*\.example\.org$` 。星号可以匹配多个名称部分。名称 `*.example.org` 不仅匹配 `www.example.org` ，而且匹配 `www.sub.example.org` 。

格式为 `.example.org` 的特殊通配符名称可用于匹配确切名称 `example.org` 和通配符名称 `*.example.org` 。

### 正则表达式名称
nginx 使用的正则表达式与 Perl 编程语言 （PCRE） 使用的正则表达式兼容。若要使用正则表达式，server 名称必须以波浪号字符开头：

```nginx
server_name  ~^www\d+\.example\.net$;
```

Also note that domain name dots should be escaped with a backslash. A regular expression containing the characters “`{`” and “`}`” should be quoted: 
否则，它将被视为确切名称，或者如果表达式包含星号，则被视为通配符名称（并且很可能被视为无效名称）。不要忘记设置 `^` 和 `$` 锚点。它们在语法上不是必需的，而是在逻辑上需要的。另请注意，域名点应使用反斜杠进行转义。包含字符 `{` 和 `}` 的正则表达式应引用：

```nginx
server_name  "~^(?<name>\w\d{1,3}+)\.example\.net$";
```

否则 nginx 将无法启动并显示错误信息：

```bash
directive "server_name" is not terminated by ";" in ...
```

A named regular expression capture can be used later as a variable: 命名的正则表达式捕获稍后可以用作变量：

```nginx
server {
	server_name   ~^(www\.)?(?<domain>.+)$;

	location / {
		root   /sites/$domain;
	}
}
```

The PCRE library supports named captures using the following syntax: PCRE 库支持使用以下语法命名捕获：

* `?<name>`                     Perl 5.10 兼容语法，从 PCRE-7.0 开始支持
* `?'name'`                     Perl 5.10 兼容语法，从 PCRE-7.0 开始支持
* `?P<name>`                   Python 兼容语法，自 PCRE-4.0 起受支持

如果 nginx 无法启动并显示错误信息：

```bash
pcre_compile() failed: unrecognized character after (?< in ...
```

这意味着 PCRE 库很旧，应该尝试语法 `?P<name>` 。The captures can also be used in digital form: 捕获也可以以数字形式使用：

```nginx
server {
	server_name   ~^(www\.)?(.+)$;

	location / {
		root   /sites/$2;
	}
}
```

但是，这种用法应仅限于简单情况（如上所述），因为数字引用很容易被覆盖。

### Miscellaneous names 其他名称

有些 server 名称是经过特殊处理的。

If it is required to process requests without the “Host” header field in a [server](http://nginx.org/en/docs/http/ngx_http_core_module.html#server) block which is not the default, 
如果需要处理服务器块中没有 “Host” 标头字段的请求，而该请求不是默认的，则应指定一个空名称：

```nginx
server {
	listen       80;
 	server_name  example.org  www.example.org  "";
 	...
}
```

如果 server 块中没有定义 server_name，则 nginx 使用空名称作为服务器名称。

> Note ：
> 在这种情况下，nginx 0.8.48 及以下版本使用计算机的主机名作为 server 名称。

如果 server 名称定义为“ `$hostname` ” （0.9.4），则使用计算机的主机名。

如果有人使用 IP 地址而不是服务器名称发出请求，则“Host”请求标头字段将包含 IP 地址，并且可以使用 IP 地址作为 server 名称来处理请求：

```nginx
server {
	listen       80;
 	server_name  example.org
        	 	 www.example.org
              	 ""
                 192.168.1.1
                 ;
	...
}
```

在 catch-all server 示例中，可以看到奇怪的名字 “ `_` ”：

```nginx
server {
 	listen       80  default_server;
 	server_name  _;
 	return       444;
}
```

这个名字没有什么特别之处，它只是无数无效域名之一，从不与任何真实姓名相交。其他无效名称，如 `--` 和 `!@#` 也可以同样使用。

nginx versions up to 0.6.25 supported the special name “`*`” which was erroneously interpreted to be a catch-all name. 0.6.25 之前的 nginx 版本支持特殊名称 `*` ，它被错误地解释为一个包罗万象的名称。It never functioned as a catch-all or wildcard server name.它从未用作 catch-all 或通配符 server 名称。相反，它提供了现在由 server_name_in_redirect 指令提供的功能。特殊名称 `*` 现已弃用，应使用 server_name_in_redirect 指令。请注意，无法使用 server_name 指令指定 catch-all 名称或默认服务器。这是 listen 指令的属性，而不是 server_name 指令的属性。可以定义服务器侦听 *:80 和 *:8080 端口，并指示一个服务器是端口 *:8080 的默认服务器，而另一个服务器是端口 *:80 的默认服务器：

```nginx
server {
	listen       80;
	listen       8080  default_server;
	server_name  example.net;
	...
}

server {
	listen       80  default_server;
	listen       8080;
	server_name  example.org;
	...
}
```

### Internationalized names 国际化名称

国际化域名 （ IDN） 应在 server_name 指令中使用 ASCII （Punycode） 表示形式指定：

```nginx
server {
    listen       80;
    server_name  xn--e1afmkfd.xn--80akhbyknj4f;  # пример.испытание
    ...
}
```

### 虚拟服务器选择

First, a connection is created in a default server context. Then, the server name can be determined in the following request processing stages, each involved in server configuration selection: 
首先，在默认服务器上下文中创建连接。然后，可以在以下请求处理阶段确定服务器名称，每个阶段都涉及服务器配置选择：

- during SSL handshake, in advance, according to [SNI](http://nginx.org/en/docs/http/configuring_https_servers.html#sni)
  在SSL握手期间，根据SNI提前
- after processing the request line 
  处理请求行后
- after processing the `Host` header field 
  处理 `Host` 标题字段后
- if the server name was not determined after processing the request line or from the `Host` header field, nginx will use the empty name as the server name. 
  如果在处理请求行后或从 `Host` 标头字段中未确定服务器名称，则 nginx 将使用空名称作为服务器名称。

  At each of these stages, different server configurations can be applied. As such, certain directives should be specified with caution: 
  在每个阶段，都可以应用不同的服务器配置。因此，应谨慎指定某些指令：

- in case of the [ssl_protocols](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive, the protocol list is set by the OpenSSL library before the server configuration could be applied according to the name requested through SNI, thus, protocols should be specified only for a default server; 
  在 ssl_protocols 指令的情况下，协议列表由 OpenSSL 库设置，然后才能根据通过 SNI 请求的名称应用服务器配置，因此，协议应仅为默认服务器指定;
- the [client_header_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size) and [merge_slashes](http://nginx.org/en/docs/http/ngx_http_core_module.html#merge_slashes) directives are involved before reading the request line, thus, such directives use a default server configuration or the server configuration chosen by SNI; 
  在读取请求行之前涉及 client_header_buffer_size 和 merge_slashes 指令，因此，此类指令使用默认服务器配置或 SNI 选择的服务器配置;
- in case of the [ignore_invalid_headers](http://nginx.org/en/docs/http/ngx_http_core_module.html#ignore_invalid_headers), [large_client_header_buffers](http://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers), and [underscores_in_headers](http://nginx.org/en/docs/http/ngx_http_core_module.html#underscores_in_headers) directives involved in processing request header fields, it additionally depends whether the server configuration was updated according to the request line or the `Host` header field; 
  如果处理请求标头字段涉及 ignore_invalid_headers、large_client_header_buffers 和 underscores_in_headers 指令，则还取决于服务器配置是根据请求行还是标 `Host` 头字段更新的;
- an error response will be handled with the [error_page](http://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) directive in the server that currently fulfills the request. 
  错误响应将使用当前满足请求的服务器中的 error_page 指令进行处理。

### 优化

确切名称、以星号开头的通配符名称和以星号结尾的通配符名称存储在绑定到侦听端口的三个哈希表中。哈希表的大小在配置阶段进行了优化，so that a name can be found with the fewest CPU cache misses以便可以找到 CPU 缓存未命中最少的名称。

The exact names hash table is searched first. If a name is not found, the hash table with wildcard names starting with an asterisk is searched. If the name is not found there, the hash table with wildcard names ending with an asterisk is searched. 
首先搜索确切的名称哈希表。如果未找到名称，则搜索通配符名称以星号开头的哈希表。如果在此处找不到该名称，则搜索通配符名称以星号结尾的哈希表。

Searching wildcard names hash table is slower than searching exact names hash table because names are searched by domain parts. Note that the special wildcard form “`.example.org`” is stored in a wildcard names hash table and not in an exact names hash table. 
搜索通配符名称哈希表比搜索确切名称哈希表慢，因为名称是按域部分搜索的。请注意，特殊的通配符形式 “ `.example.org` ” 存储在通配符名称哈希表中，而不是存储在确切的名称哈希表中。

正则表达式是按顺序测试的，因此是最慢的方法，并且是不可扩展的。

For these reasons, it is better to use exact names where possible. For example, if the most frequently requested names of a server are `example.org` and `www.example.org`, it is more efficient to define them explicitly: 
由于这些原因，最好尽可能使用确切的名称。例如，如果服务器最常请求的名称是 `example.org` 和 `www.example.org` ，则显式定义它们会更有效：

```nginx
server {
 listen       80;
 server_name  example.org  www.example.org  *.example.org;
 ...
}
```

than to use the simplified form: 
比使用简化形式：

```nginx
server {
 listen       80;
 server_name  .example.org;
 ...
}
```

If the default value is 32 and server name is defined as “`too.long.server.name.example.org`” then nginx will fail to start and display the error message: 
如果定义了大量 server 名称，或者定义了异常长的 server 名称，则可能需要在 http 级别调整 server_names_hash_max_size 和 server_names_hash_bucket_size  指令。server_names_hash_bucket_size 指令的默认值可能等于 32、64 或其他值，具体取决于 CPU 缓存行大小。如果默认值为 32，并且 server 名称定义为 `too.long.server.name.example.org` ，则 nginx 将无法启动并显示错误消息：

```bash
could not build the server_names_hash,
you should increase server_names_hash_bucket_size: 32
```

the directive value should be increased to the next power of two: 
在这种情况下，指令值应增加到 2 的下一个幂：

```nginx
http {
	server_names_hash_bucket_size  64;
	...
```

如果定义了大量 server 名称，则会出现另一条错误消息：

```bash
could not build the server_names_hash,
you should increase either server_names_hash_max_size: 512
or server_names_hash_bucket_size: 32
```

在这种情况下，首先尝试将 server_names_hash_max_size 设置为接近 server 名称数的数字。只有当这没有帮助，或者如果 nginx 的启动时间长得令人无法接受时，才尝试增加 server_names_hash_bucket_size 。

If a server is the only server for a listen port, then nginx will not test server names at all (and will not build the hash tables for the listen port). However, there is one exception. If a server name is a regular expression with captures, then nginx has to execute the expression to get the captures. 
如果服务器是侦听端口的唯一服务器，则 nginx 根本不会测试服务器名称（也不会为侦听端口构建哈希表）。但是，有一个例外。如果服务器名称是带有捕获的正则表达式，则 nginx 必须执行表达式才能获取捕获。

### Compatibility 兼容性

- 自 0.9.4 起支持特殊服务器名称 `$hostname` 。
- 自 0.8.48 起，默认服务器名称值为空名称 “”。
- Named regular expression server name captures have been supported since 0.8.25. 
  自 0.8.25 起，已支持命名正则表达式服务器名称捕获。
- Regular expression server name captures have been supported since 0.7.40. 
  自 0.7.40 起，一直支持正则表达式服务器名称捕获。
- An empty server name “” has been supported since 0.7.12. 
  自 0.7.12 起，一直支持空服务器名称 “”。
- A wildcard server name or regular expression has been supported for use as the first server name since 0.6.25. 
  自 0.6.25 以来，支持将通配符服务器名称或正则表达式用作第一个服务器名称。
- Regular expression server names have been supported since 0.6.7. 
  自 0.6.7 起，一直支持正则表达式服务器名称。
- 从 0.6.0 开始支持通配符形式 `example.*` 。
- 自 0.3.18 起支持特殊表单 `.example.org` 。
- 自 0.1.13 起支持通配符形式 `*.example.org` 。

## listen 指令

在大多数情况下，我们会看到 listen 指令接受 IP: 端口值。

```
listen 127.0.0.1:80;  
listen 127.0.0.1;    # port :80 is used by default  
  
listen *:81;  
listen 81;           # all ips are used by default  
  
listen [::]:80;      # IPv6 addresses  
listen [::1];        # IPv6 addresses  
```

但是，也可以指定 UNIX 域的套接字：

```
listen unix:/var/run/nginx.sock;  
```

甚至我们可以使用主机名：

```
listen localhost:80;  
listen netguru.co:80;  
```

如果指令不存在，则使用***:80**。

## 代理

代理是在内部应用程序和外部客户端之间的服务器，将客户端请求转发到相应的服务器。**Nginx 的反向代理服务器**是代理服务器位于私有网络的防火墙后面，将客户端请求发送到相应的后端服务器。

### 设置简单代理服务器

nginx 的一个常见用法是将其设置为代理服务器，这意味着服务器接收请求，将其传递给代理服务器，从代理服务器检索响应，并将其发送给客户端。

配置一个基本的代理服务器，使用本地目录中的文件处理图像请求，并将所有其他请求发送到代理服务器。在本例中，两个服务器都将在单个 nginx 实例上定义。

首先，通过向 nginx 的配置文件中添加一个 `server` 块来定义代理服务器，其中包含以下内容：

```nginx
server {
    listen 8080;
    root /data/up1;

    location / {
    }
}
```

这将是一个简单的服务器，它侦听 8080 端口（以前，由于使用了标准端口 80，所以未指定 `listen` 指令），并将所有请求映射到本地文件系统上的 `/data/up1` 目录。创建此目录并将 `index.html` 文件放入其中。请注意，`root` 指令位于 `server` 上下文中。当选择用于服务请求的 `location` 块不包括其自己的 `root` 指令时，使用这样的 `root` 指令。

接下来，使用静态网页服务器节中的服务器配置，并将其修改为代理服务器配置。在第一个 `location` 块中，将 `proxy_pass` 指令与参数中指定的代理服务器的协议、名称和端口放在一起（在例子中，它是 `http://localhost:8080` ):

```nginx
server {
    location / {
        proxy_pass http://localhost:8080;
    }

    location /images/ {
        root /data;
    }
}
```

我们将修改第二个 `location` 块，该块当前将带有 `/images/` 前缀的请求映射到 `/data/images` 目录下的文件，以使其与具有典型文件扩展名的图像请求相匹配。修改后的 `location` 块如下所示：

```nginx
location ~ \.(gif|jpg|png)$ {
    root /data/images;
}
```

该参数是一个正则表达式，匹配所有以 `.gif` 、`.jpg` 或 `.png` 结尾的 URI 。正则表达式应以 `~` 开头。相应的请求将映射到 `/data/images` 目录。

当 nginx 选择一个 `location` 块来服务请求时，它首先检查指定前缀的 `location` 指令，记住前缀最长的 `location` ，然后检查正则表达式。如果与正则表达式匹配，nginx 会选择这个 `location` ，否则，它会选择前面记住的 `location` 。

代理服务器的最终配置如下所示：

```nginx
server {
    location / {
        proxy_pass http://localhost:8080/;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

此服务器将过滤以 `.gif` 、`.jpg` 或 `.png` 结尾的请求，并将它们映射到 `/data/images` 目录（通过向 `root` 指令的参数添加 URI ），并将所有其他请求传递到上面配置的代理服务器。

### 设置 FastCGI 代理

nginx 可用于将请求路由到 FastCGI 服务器，这些服务器运行用各种框架和编程语言（如 PHP）构建的应用程序。

与 FastCGI 服务器一起使用的最基本的 nginx 配置包括使用 `fastcgi-pass` 指令而不是 `proxy_pass` 指令，以及 `fastcgi-param` 指令来设置传递给 FastCGI 服务器的参数。假设 FastCGI 服务器可以在 `localhost:9000` 上访问。以上一节中的代理配置为基础，用 `fastcgi_pass` 指令替换 `proxy_pass` 指令，并将参数更改为 `localhost:9000` 。在 PHP 中， `SCRIPT_FILENAME` 参数用于确定脚本名称， `QUERY_STRING` 参数用于传递请求参数。结果配置为：

```nginx
server {
    location / {
        fastcgi_pass  localhost:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param QUERY_STRING    $query_string;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

这将设置一个服务器，该服务器将通过 FastCGI 协议将所有请求（静态图像请求除外）路由到在 `localhost:9000` 上运行的代理服务器。

### HTTP 流量反向代理

可以将 NGINX web 服务器配置为作为 HTTP  流量的反向代理。使用此功能将请求转发到远程服务器上的特定子目录。从客户端的角度来看，客户端从它所访问的主机加载内容。但是 NGINX 会从远程服务器加载实际内容并将其转发给客户端。

1. 编辑 `/etc/nginx/nginx.conf` 文件，并将以下设置添加到提供反向代理的`server`块中： 				

   ```bash
   location /example {
       proxy_pass https://example.com;
   }
   ```

   `location`块定义了 NGINX 将 `/example` 目录中的所有请求传给 `https://example.com`。 				

2. 将 `httpd_can_network_connect` SELinux 布尔值参数设置为`1`，以便将 SELinux 设置为允许 NGINX 转发流量： 				

   ```bash
   setsebool -P httpd_can_network_connect 1
   ```

3. 重启 `nginx` 服务： 				

   ```bash
   systemctl restart nginx
   ```



## 反向代理服务器的用途

**负载平衡：**反向代理服务器可以充当驻留在我们后端服务器前面的交通警察，并以提高速度和容量利用率的方式在一组服务器之间分配客户端请求，同时确保没有任何服务器过载。如果服务器未启动，则负载平衡器会将流量重定向到其余的在线服务器。

**Web 加速：** Nginx 反向代理用于压缩出站和入站数据，以及缓存常见请求的内容，这两者都加快了客户端和服务器之间的流量流动。

**安全性和匿名性：**我们可以拦截前往我们后端服务器的客户端的请求，通过这样做，反向代理服务器可以保护他们的身份并作为对安全攻击的额外防御。

## 将请求传递给代理服务器

当 NGINX 服务器代理请求时，它将请求发送到指定的服务器，获取响应，并将其发送回客户端。可以使用指定的协议向 HTTP 服务器或非 HTTP 服务器发送代理请求。支持的协议包括 FastCGI、uwsgi、SCGI 和 Memcached。

要将请求传递到 HTTP 代理服务器，使用 proxy_pass 指令。例如：

```
location /some/path/ {  
    proxy_pass http://www.example.com/link/;  
}  
```

要将请求传递到非 HTTP 代理服务器，请使用适当的 **_pass 指令：

- **fastcgi_pass：**将请求传递给 fastCGI 服务器。
- **uwsgi_pass：**将请求传递给 uwsgi 服务器。
- **scgi_pass：**将请求传递给 SCGI 服务器。
- **memcached_pass：**将请求传递给 memcached 服务器。



可以使用 NGINX 反向代理功能进行负载均衡流量。它会根据服务器上的活跃连接的数量，将请求发送到不同服务器（发送到活跃连接数量最小的服务器）。如果两个服务器都不可用，这个过程还定义了第三个主机用于回退。

1. 编辑 `/etc/nginx/nginx.conf` 文件并添加以下设置： 				

   ```bash
   http {
       upstream backend {
           least_conn;
           server server1.example.com;
           server server2.example.com;
           server server3.example.com backup;
       }
   
       server {
           location / {
               proxy_pass http://backend;
           }
       }
   }
   ```

   在名为 `backend` 的主机组中的 `least_conn` 指令定义了 NGINX 将请求发送到 `server1.example.com` 或 `server2.example.com` ，具体取决于哪个主机具有最少的活动连接数。NGINX 仅在其他两个主机不可用时使用 `server3.example.com` 作为备份。 				

   `proxy_pass`指令设置为`http://backend` 时，NGINX 充当反向代理，并使用`backend`主机组根据该组的设置分发请求。 				

   还可以指定其他方法，而不是`least_conn`负载均衡方法： 				

   - 不指定方法，使用轮询的方式在服务器间平均分发请求。 						
   - `ip_hash`根据从 IPv4 地址的前三个八位字节或客户端的整个 IPv6 地址计算的哈希值将来自一个客户端地址的请求发送到同一台服务器。 						
   - `hash`，根据用户定义的密钥（可以是字符串、变量或两者的组合）来确定服务器。用`consistent`参数来进行配置，NGINX可根据用户定义的哈希密钥值向所有的服务器分发请求。 						
   - `random`将请求发送到随机挑选的服务器。 						

2. 重启`nginx`服务： 				

   ```bash
   systemctl restart nginx
   ```

Nginx 以高并发、低消耗而闻名，这个特点使其很适合作为一个负载均衡器 (Load  Balancer)，有策略地分发请求给不同的后端服务器。避免单点故障之余，亦增强整个系统的可用性，简单说不容易宕机。负载均衡是反代的其中一个用途。本文介绍 Nginx 常用的几个负载均衡策略。

⚠️ 假设有一组名为 backend 的 upstream，那么**调用方式**是 proxy_pass http://backend。

## 热备 (Hot Standby)

在此例中，平时使用 www.example.com 提供服务，bad.example.com 则暂时下线，bak.example.com 作为发生故障时兜底的一台机器。又称故障转移 (failover)。

```
upstream backend {
    server www.example.com;
    server bad.example.com down;
    server bak.example.com backup;
}
```

## 轮询 (round-robin)

介个是经（mò）典（rèn）的负载均衡算法。理论上会跳过不能用的 server，但预设的超时太长，实务上可改成 proxy_connect_timeout 1、proxy_read_timeout 1 和 proxy_send_timeout 1。

按照时间先后来分发请求。在此例中，顾名思义第 1 个 request 走 srv1.example.com，第 2  个走 srv2.example.com，第 3 个走 srv3.example.com，第 4  个走 srv1.example.com……以此类推。

```
upstream backend {
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}
```

## 最小连接 (least-connected)

因应忙闲不均、负载不均的问题而生。在此例中，Nginx 将试图减轻已经很忙的服务器的压力，把新请求分发至没那么忙的主机。

若对动态负载均衡的算法感兴趣，还有一插件 nginx-upstream-fair 可以实现最快响应法。

```
upstream backend {
    least_conn;
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}
```

## 源地址哈希 (ip-hash)

Session 用于跟踪用户操作，涉及身份认证时 (用户系统) 往往能派上用场，而通常情况下会话信息保存在单机上，这就使得有些需求得在同一台服务器上完成，不能换到其他的服务器 (姑且不谈分布式 Session)。

Sticky Sessions (粘滞会话) 将保证一个用户对应一台服务器，从而解决 Session 不一致的问题 (通常表现为无法登录)。出于容灾理由，不建议大量使用。

```
upstream backend {
    ip_hash;
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}
```

## 加权负载均衡 (Weighted Load Balancing)

集群中难免有算力不均的情况。不同服务器处理速度有快有慢，不问性能的齐头式平等，很可能触发木桶原理的副作用——让配置最差的那个服务器决定整个服务器集群的性能。可跑一次 bench.sh，再依据测试结果给服务器排个序。

在此例中，每 10 个新请求有 6 个被分配至 srv1.example.com，然后各有 2 个被分配至 srv2.example.com 和 srv3.example.com。此例演示的轮询法，事实上最小连接和源地址哈希法也可以分配权重。

```
upstream backend {
    server srv1.example.com weight=3;
    server srv2.example.com;
    server srv3.example.com;
}
```

## 运行状况检查 (Health Checks)

根据 Nginx 的文档，max_fails 缺省值是 1，fail_timeout 缺省值是 10s。

在此例中，www.example.com 的健康检查会被关闭，一直都标记为可用；www2.example.com 连不上时先重试 2 次，如果还不行就退出服务，下线 1 天，方便运维人员排障。

```
upstream backend {
    server www.example.com max_fails=0;
    server www2.example.com max_fails=2 fail_timeout=1d;
}
```

## 关于指令 proxy_next_upstream

根据 Nginx 的文档，proxy_next_upstream 含括下列数种情况：

```
error 建立连接 / 发送请求 / 接收响应时出错（缺省值之一）；
timeout 建立连接 / 发送请求 / 接收响应时超时（缺省值之一）；
invalid_header 上游返回空白或无效响应；
http_500 上游返回 500 Internal Server Error；
http_501 上游返回 501 Not Implemented；
http_502 上游返回 502 Bad Gateway；
http_503 上游返回 503 Service Unavailable；
http_504 上游返回 504 Gateway Timeout；
http_404 上游返回 404 Not Found；
http_429 上游返回 429 Too Many Requests；
non_idempotent 解除对非幂等请求 (POST, LOCK, PATCH) 的封印，小心造成重复提交；
off 不得转给下一台服务器。
```

一般来说，即使某一台后端服务器返回了 500，这台服务器也会参与负载均衡，毕竟能收到 HTTP  状态码，就表示它还活着。但这样的结果在用户眼里跟 Connection Refused 以及 Operation Timed Out  可没啥区别，所以在此例中，把 500 一并纳入“**在下一台服务器重试**”的机制里。

```
location / {
    ...
    proxy_pass http://backend;
    proxy_next_upstream error timeout http_500;
    ...
}
```

# Nginx 内容缓存

proxy_cache 运用局部性的原理，备存一些先前被访问过、料将被再度使用的资源，使用户得以由前端服务器直接取得，从而减少后端服务器的资源开销，并缓解整个系统的压力。缓存也是反代的用途之一。本文介绍 Nginx 基本的缓存配置。

要启用缓存，请在顶级 http { } 上下文中添加 proxy_cache_path 指令。重要且强制的第一个参数是缓存内容的本地文件系统路径，keys_zone 参数指定用于存储缓数据的共享内存区域的名称和大小。

1) proxy_cache_path 定义一个缓存目录，路径为 /usr/local/nginx/cache；levels=1:2  采用二级的目录结构；keys_zone 建立一块用于存放缓存键 (cache keys) 和元数据 (metadata) 的共享内存区，名叫  ”the_cache_zone” 且分配 10MB 的内存；inactive 不活跃的缓存文件 1 小时后将被清除；max_size  缓存所占磁盘空间的上限是 512MB；不另设临时目录。

```
http {
    ...
    proxy_cache_path /usr/local/nginx/cache levels=1:2 keys_zone=the_cache_zone:10m inactive=1h max_size=512m use_temp_path=off;
    ...
}
```

2) 启用缓存。方便除错计，添加一响应头用以指示缓存状态 (*MISS* / *BYPASS* / *HIT* …)。

下列指令请斟酌——
proxy_cache_bypass 用于指定忽略缓存的情况，当其值为空或为零时，使用缓存。
proxy_cache_key 用于生成缓存键，区分不同的资源。要特别留心 Query String。
proxy_cache_min_uses 则规定缓存门槛，请求过多少次才缓存，不缓存低频请求，避免浪费。

在下例中，$is_args 反映请求的 URI 是否带参数（网址中问号后面那一长串），若没有即为空值。$request_uri 近似于 $uri$is_args$args。key 是决定缓存命中率的因素之一。

```
location / {
    ...
    proxy_pass http://www.example.com;

    proxy_cache the_cache_zone;
    #           proxy_cache_bypass $is_args;
    # (default) proxy_cache_key $scheme$proxy_host$request_uri;
    #           proxy_cache_min_uses 3;
    
    add_header X-Cache-Status $upstream_cache_status;
    ...
}
```

3) Nginx 作反代时，相对来说也是客户端。若希望抓取的源站内容总是新鲜，还需要忽略上游的缓存期限，即不遵循源站的 Cache-Control 和 Expires 等响应头，然后再来配置自己的缓存期限。

**服务端**一侧，proxy_cache_valid 控制的是 expiration (有效期)，针对不同的  HTTP 状态码可以设定不同的有效期。inactive 决定的是 retention (保留期限)，时间一到管你新不新鲜都要丢掉  (refresh)。可以理解为 inactive 要优位于 proxy_cache_valid。

proxy_cache_revalidate 将对客户端传来之 Etag 或 Last-Modified 作出验证，若服务端资源没有变化，则使用“稍早前”缓存页面，无论其有效期为何。有助减少回源次数。

```
location / {
    ...
    proxy_ignore_headers X-Accel-Expires Cache-Control Expires;

    proxy_cache_valid 301 1h;
    proxy_cache_valid 200 30m;
    proxy_cache_valid any 1m;
    proxy_cache_revalidate on;
    ...
}
```

4) 缓存一时爽，全家火葬场。一大波缓存同时失效，会导致**缓存雪崩** (Cache stampede)，使得大批请求涌向源站。如果网站不是特别大、并发要求不是特别高，可以采取**加锁排队**和**暂时返回陈旧数据**的方式缓解问题。但根本的还是要各别设定缓存期限，错峰更新缓存，不要一窝蜂。

proxy_cache_lock 对同一资源，未命中一次只回源一次，阻塞后续请求直至当前请求完成。
proxy_cache_lock_age “不能者止”，如果当前请求未能如期完成，就放行后续请求。
proxy_cache_lock_timeout 发生超时，同样放行，但不作缓存。

proxy_cache_use_stale 则是指定“共体时艰”的情境，比如服务器正在更新 (updating) 缓存的时候，或者遭遇 503 服务不可用错误的时候，勉予使用 (inactive 还未清理的) 过期缓存，以保持可用性。
proxy_cache_background_update 返回陈旧数据时，也跟源站要一份新鲜的，下次用。

```
location / {
    ...
    proxy_cache_lock on;
    # (default) proxy_cache_lock_age 5s;
    # (default) proxy_cache_lock_timeout 5s;

    proxy_cache_use_stale error timeout updating http_503;
    proxy_cache_background_update on;
    ...
}
```

5) 倘若有手动清除缓存的需求，又用不起 NGINX Plus，不妨考虑 ngx_cache_purge。

下载源码、nginx -V 检视参数、追加参数 --add-module=../ngx_cache_purge-2.3 且重新编译 Nginx，以完成添加模块的动作。

proxy_cache_purge 得回头看前面的配置，使用的缓存路径与 proxy_cache 的对应、缓存键向 proxy_cache_key 的看齐。URI 前面加上 /purge 即为清除缓存接口（最好不要被外部访问）。

```
location / {
    ...
    proxy_cache the_cache_zone;
    proxy_cache_key $scheme$proxy_host$request_uri;
    ...
}

location ~ /purge(/.*) {
    ...
    allow 127.0.0.1;
    deny all;
    proxy_cache_purge the_cache_zone $scheme$proxy_host$1$is_args$args;
    ...
}
```



# Nginx br 压缩

 Nginx 压缩和解压

压缩过程减少了传输数据的大小。然而，由于压缩发生在运行时，它也可能包括相当大的处理开销，这会对性能产生负面影响。Nginx 在向客户端发送响应之前执行压缩，但不会对已经压缩的响应进行双重压缩。

## 启用压缩

要启用压缩，请添加带有**on**参数的 gzip 指令：

```
gzip on;  
```

默认情况下，Nginx 仅使用 text/html（MIME 类型）压缩响应。要使用其他 MIME 类型压缩响应，请添加 gzip_types 指令并列出其他类型。

```
gzip_types text/plain application/xml;  
```

我们可以定义要压缩的响应的最小长度，使用 gzip_min_length 指令。默认值为 20 字节。

```
gzip_min_length 1000;  
```

## 开启解压

某些客户端不使用 gzip 编码方法处理响应。同时，可能需要动态存储压缩数据或响应并将它们存储在缓存中。为了成功地为接受和不接受压缩数据的客户端提供服务，NGINX 可以在将数据发送到后一种类型的客户端时即时解压缩数据。

要启用运行时解压缩，请使用 gunzip 指令。

```
location /storage/ {  
    gunzip on;  
    ...  
} 
```

gunzip 指令可以在与 gzip 指令相同的上下文中定义：

```
server {  
    gzip on;  
    gzip_min_length 1000;  
    gunzip on;  
    ...  
}  
```

#### 注意：该指令在一个单独的模块中定义，默认情况下可能不包含在 NGINX 构建中。

## 发送压缩文件

要将压缩文件而不是常规文件发送到客户端，请在适当的上下文中将 gzip_static 指令设置为 on。

```
location / {  
    gzip_static on;  
} 
```

在上面的例子中，为了服务一个对 /path/to/file 的请求，NGINX 试图找到并发送文件*/path/to/file.gz*。如果文件不存在，或者客户端不支持 gzip，NGINX 会发送未压缩的文件。  

## 压缩

Brotli 是 Google 研发的一种新兴压缩算法，可以加快网页的载入速度。相较于 Gzip 压缩率更高、性能也非常好，再基于 Chrome 的市场支配地位，Brotli 便得到迅速普及。不过要注意，它仅适用于 HTTPS。

![Can I use brotli.png](https://www.cainiaojc.com/uploads/nginx/images/3173997878.png)

1) 下载 Brotli 的源码；

```
yum install git && cd /usr/local/src

git clone https://github.com/google/ngx_brotli.git
pushd ngx_brotli
git submodule update --init
popd
```

2) 执行命令 nginx -V，*configure arguments* 即为现有的参数；

```
nginx version: nginx/1.16.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) 
built with OpenSSL 1.1.1c  28 May 2019
TLS SNI support enabled
configure arguments: --with-http_ssl_module --with-http_v2_module --with-http_sub_module --with-openssl=../openssl-1.1.1c
```

3) 追加参数 --add-module=../ngx_brotli，重新编译 Nginx。本系列文中 Nginx 的源码目录是 /usr/local/src/nginx-1.16.1；

```
cd nginx-1.16.1
./configure \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_sub_module \
--with-openssl=../openssl-1.1.1c \
--add-module=../ngx_brotli
make && make install
```

如需执行平滑升级 (热部署)，make 之后请不要 make install：

```
mv /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.old
cp objs/nginx /usr/local/nginx/sbin/nginx
make upgrade
```

4) 接着修改 nginx.conf (缺省值就够用，篇幅所限不显式设置。不妨再留意一下 gzip_types 和 brotli_types 指令，以允许压缩 text/html 以外的文件，MIME 类型列表见)；

```
http {
    ...
    gzip on;
    brotli on;
    
    # gzip_types text/css text/javascript application/rss+xml;
    # brotli_types text/css text/javascript application/rss+xml;
    ...
}
```

5) 重载 Nginx，可借由 Brotli Test 等工具检验效果。

```
nginx -t && nginx -s reload
```

# Nginx 安全控制

当我们的内容很有价值，并且我们关心用户的隐私和安全时，我们可以使用 Nginx 来控制和保护对服务和数据的访问。

## 配置 HTTPS 服务器

要配置 HTTPS 服务器，必须在 server 块中的侦听套接字上启用该 `ssl` 参数，并应指定服务器证书和私钥文件的位置：

```nginx
server {
	listen              443 ssl;
	server_name         www.example.com;
	ssl_certificate     www.example.com.crt;
	ssl_certificate_key www.example.com.key;
	ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers         HIGH:!aNULL:!MD5;
	...
}
```

服务器证书是公共实体。它被发送到连接到服务器的每个客户端。私钥是一个安全的实体，应该存储在一个访问受限的文件中，但是，它必须可以被nginx的主进程读取。私钥可以交替存储在与证书相同的文件中：

```nginx
 ssl_certificate     www.example.com.cert;
 ssl_certificate_key www.example.com.cert;
```

在这种情况下，还应限制文件访问权限。尽管证书和密钥存储在一个文件中，但只有证书会发送到客户端。

指令 ssl_protocols 和 ssl_ciphers 可用于限制连接，使其仅包含 SSL/TLS 的强版本和密码include only the strong versions and ciphers of SSL/TLS。默认情况下，nginx 使用 “`ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3`” 和 “ `ssl_ciphers HIGH:!aNULL:!MD5` ”，因此通常不需要显式配置它们。请注意，这些指令的默认值已更改多次。

## HTTPS 服务器优化

SSL 操作会消耗额外的 CPU 资源。在多处理器系统上，应运行多个工作进程，不少于可用 CPU 内核数。对 CPU 占用最大的操作是 SSL  握手。有两种方法可以最大程度地减少每个客户端的这些操作的数量：第一种方法是启用 keepalive 连接使能够通过一个连接发送多个请求，第二种方法是重用 SSL 会话参数以避免并行和后续连接的 SSL 握手。The sessions are stored in an SSL session cache shared between workers会话存储在工作线程之间共享的 SSL  会话缓存中，并由 ssl_session_cache 指令进行配置。一兆字节的缓存包含大约 4000 个会话。默认缓存超时为 5 分钟。可以通过使用 ssl_session_timeout 指令来增加它。

下面是针对具有 10 MB 共享会话缓存的多核系统优化的配置示例：

```nginx
worker_processes auto;

http {
 ssl_session_cache   shared:SSL:10m;
 ssl_session_timeout 10m;

 server {
     listen              443 ssl;
     server_name         www.example.com;
     keepalive_timeout   70;

     ssl_certificate     www.example.com.crt;
     ssl_certificate_key www.example.com.key;
     ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
     ssl_ciphers         HIGH:!aNULL:!MD5;
     ...
```

## SSL 证书链

某些浏览器可能会抱怨由知名证书颁发机构签名的证书，而其他浏览器可能会毫无问题地接受该证书。发生这种情况的原因是，颁发机构已使用中间证书对服务器证书进行签名，而中间证书不存在于与特定浏览器一起分发的已知受信任证书颁发机构的证书库中。在这种情况下，颁发机构会提供一组链式证书，这些证书应连接到已签名的服务器证书。服务器证书必须出现在组合文件中的链式证书之前：

```bash
$ cat www.example.com.crt bundle.crt > www.example.com.chained.crt
```

生成的文件应在 ssl_certificate 指令中使用：

```nginx
server {
	listen              443 ssl;
	server_name         www.example.com;
	ssl_certificate     www.example.com.chained.crt;
	ssl_certificate_key www.example.com.key;
	...
}
```

If the server certificate and the bundle have been concatenated in the wrong order, 如果服务器证书和捆绑包的连接顺序错误，nginx 将无法启动并显示错误消息：

```bash
SSL_CTX_use_PrivateKey_file(" ... /www.example.com.key") failed
	(SSL: error:0B080074:x509 certificate routines:
	 X509_check_private_key:key values mismatch)
```

because nginx has tried to use the private key with the bundle’s first certificate instead of the server certificate.因为 nginx 尝试将私钥与捆绑包的第一个证书一起使用，而不是服务器证书。

浏览器通常存储它们接收并由受信任的机构签名的中间证书，因此经常使用的浏览器可能已经拥有所需的中间证书，并且可能不会抱怨没有链接捆绑包的证书。为确保服务器发送完整的证书链，可以使用 `openssl` 命令行实用程序，例如：

```nginx
$ openssl s_client -connect www.godaddy.com:443
...
Certificate chain
0 s:/C=US/ST=Arizona/L=Scottsdale/1.3.6.1.4.1.311.60.2.1.3=US
  /1.3.6.1.4.1.311.60.2.1.2=AZ/O=GoDaddy.com, Inc
  /OU=MIS Department/CN=www.GoDaddy.com
  /serialNumber=0796928-7/2.5.4.15=V1.0, Clause 5.(b)
i:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
  /OU=http://certificates.godaddy.com/repository
  /CN=Go Daddy Secure Certification Authority
  /serialNumber=07969287
1 s:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
  /OU=http://certificates.godaddy.com/repository
  /CN=Go Daddy Secure Certification Authority
  /serialNumber=07969287
i:/C=US/O=The Go Daddy Group, Inc.
  /OU=Go Daddy Class 2 Certification Authority
2 s:/C=US/O=The Go Daddy Group, Inc.
  /OU=Go Daddy Class 2 Certification Authority
i:/L=ValiCert Validation Network/O=ValiCert, Inc.
  /OU=ValiCert Class 2 Policy Validation Authority
  /CN=http://www.valicert.com//emailAddress=info@valicert.com
...
```

> Note：
>
> When testing configurations with [SNI](https://nginx.org/en/docs/http/configuring_https_servers.html#sni), it is important to specify the `-servername` option as `openssl` does not use SNI by default.
>
> 使用 SNI 测试配置时，请务必指定默认 `-servername`  `openssl` 不使用 SNI 的选项。

the subject (“*s*”) of the `www.GoDaddy.com` server certificate #0 is signed by an issuer (“*i*”) which itself is the subject of the certificate #1, which is signed by an issuer which itself is the subject of the certificate #2, which signed by the well-known issuer *ValiCert, Inc.* whose certificate is stored in the browsers’ built-in certificate base (that lay in the house that Jack built).

在此示例中， `www.GoDaddy.com` 服务器证书 #0 的主题 （“s”） 由颁发者 （“i”） 签名，该颁发者本身是证书 #1 的主题，该证书由颁发者签名，该颁发者本身是证书  #2 的主题，证书由知名颁发者 ValiCert， Inc. 签名，其证书存储在浏览器的内置证书库（位于 Jack 建造的房子里）。

If a certificate bundle has not been added, only the server certificate #0 will be shown.

如果尚未添加证书捆绑包，则仅显示服务器证书 #0。

## 单个 HTTP/HTTPS server

可以配置同时处理 HTTP 和 HTTPS 请求的单个服务器：

```nginx
server {
	listen              80;
	listen              443 ssl;
	server_name         www.example.com;
	ssl_certificate     www.example.com.crt;
	ssl_certificate_key www.example.com.key;
	...
}
```

> Note：
>
> Prior to 0.7.14 SSL could not be enabled selectively for individual listening sockets, as shown above. SSL could only be enabled for the entire server using the [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive, making it impossible to set up a single HTTP/HTTPS server. The `ssl` parameter of the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive was added to solve this issue. The use of the [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive in modern versions is thus discouraged.
>
> 在 0.7.14 之前，无法有选择地为单个侦听套接字启用 SSL，如上所示。只能使用 ssl 指令为整个服务器启用 SSL，因此无法设置单个 HTTP/HTTPS 服务器。添加了 listen 指令的 `ssl` 参数以解决此问题。因此，不鼓励在现代版本中使用 ssl 指令。

## 基于名称的 HTTPS server

A common issue arises when configuring two or more HTTPS servers listening on a single IP address:配置两个或多个侦听单个 IP 地址的 HTTPS 服务器时，会出现一个常见问题：

```nginx
server {
 listen          443 ssl;
 server_name     www.example.com;
 ssl_certificate www.example.com.crt;
 ...
}

server {
 listen          443 ssl;
 server_name     www.example.org;
 ssl_certificate www.example.org.crt;
 ...
}
```

使用此配置，浏览器将接收默认服务器的证书，即 `www.example.com` ，与请求的服务器名称无关。这是由 SSL 协议行为引起的。SSL 连接是在浏览器发送 HTTP 请求之前建立的，nginx 不知道请求的服务器的名称。因此，它可能只提供默认服务器的证书。

解决此问题的最古老、最可靠的方法是为每个 HTTPS 服务器分配一个单独的 IP 地址：

```nginx
server {
 listen          192.168.1.1:443 ssl;
 server_name     www.example.com;
 ssl_certificate www.example.com.crt;
 ...
}

server {
 listen          192.168.1.2:443 ssl;
 server_name     www.example.org;
 ssl_certificate www.example.org.crt;
 ...
}
```

## 具有多个名称的 SSL 证书

还有其他方法允许在多个 HTTPS 服务器之间共享单个 IP 地址。但是，它们都有其缺点。一种方法是在 SubjectAltName 证书字段中使用具有多个名称的证书，例如 `www.example.com` 和 `www.example.org` 。但是，SubjectAltName 字段长度是有限的。

另一种方法是使用带有通配符名称的证书，例如 `*.example.org` 。通配符证书保护指定域的所有子域，但仅在一个级别上。此证书与 `www.example.org` 匹配，但与 `example.org` 和 `www.sub.example.org` 不匹配。这两种方法也可以结合使用。证书可以在 SubjectAltName 字段中包含精确名称和通配符名称，例如，`example.org` 和 `*.example.org` .

It is better to place a certificate file with several names and its private key file at the *http* level of configuration to inherit their single memory copy in all servers:最好将具有多个名称的证书文件及其私钥文件放在 http 配置级别，以便在所有服务器中继承其单个内存副本：

```nginx
ssl_certificate     common.crt;
ssl_certificate_key common.key;

server {
 listen          443 ssl;
 server_name     www.example.com;
 ...
}

server {
 listen          443 ssl;
 server_name     www.example.org;
 ...
}
```

## Server Name Indication 服务器名称指示

在单个 IP 地址上运行多个 HTTPS 服务器的更通用的解决方案是 TLS 服务器名称指示扩展TLS Server Name Indication extension（SNI，RFC 6066），它允许浏览器在 SSL 握手期间传递请求的服务器名称，因此，服务器将知道它应该使用哪个证书进行连接。SNI 目前被大多数现代浏览器支持，但某些旧客户端或特殊客户端可能不使用 SNI 。

> however some browsers may erroneously pass an IP address of the server as its name if a request includes literal IP address. One should not rely on this.
>
> 在 SNI 中只能传递域名，但是如果请求包含文字 IP 地址，某些浏览器可能会错误地将服务器的 IP 地址作为其名称传递。人们不应该依赖这个。

为了在 nginx 中使用 SNI，it must be supported in both the OpenSSL library with which the nginx binary has been built as well as the library to which it is being dynamically linked at run time.它必须在构建 nginx 二进制文件的 OpenSSL 库以及运行时动态链接到的库中都受支持。OpenSSL 从 0.9.8f 版本开始支持 SNI ，如果它是使用配置选项 “--enable-tlsext” 构建的。从 OpenSSL 0.9.8j  开始，此选项默认处于启用状态。如果 nginx 是使用 SNI 支持构建的，那么 nginx 将在使用 “-V” 开关运行时显示：

```bash
$ nginx -V
...
TLS SNI support enabled
...
```

但是，如果启用了 SNI 的 nginx 动态链接到不支持 SNI 的 OpenSSL 库，则 nginx 会显示警告：

```bash
nginx was built with SNI support, however, now it is linked
dynamically to an OpenSSL library which has no tlsext support,
therefore SNI is not available
```

## 兼容性

- 自 0.8.21 和 0.7.62 以来，“-V” 开关已显示 SNI 支持状态。
- The `ssl` parameter of the [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive has been supported since 0.7.14. Prior to 0.8.21 it could only be specified along with the `default` parameter. 
  从 0.7.14 开始支持 listen 指令的 `ssl` 参数。在 0.8.21 之前，它只能与 `default` 参数一起指定。
- SNI 从 0.5.23 开始受支持。
- The shared SSL session cache has been supported since 0.5.6. 
  自 0.5.6 起支持共享 SSL 会话缓存。

- 版本 1.23.4 及更高版本：默认 SSL 协议为 TLSv1、TLSv1.1、TLSv1.2 和 TLSv1.3（如果 OpenSSL 库支持）。
- 版本 1.9.1 及更高版本：默认 SSL 协议为 TLSv1、TLSv1.1 和 TLSv1.2（如果 OpenSSL 库支持）。
- 版本 0.7.65、0.8.19 及更高版本：默认 SSL 协议为 SSLv3、TLSv1、TLSv1.1 和 TLSv1.2（如果 OpenSSL 库支持）。
- 版本 0.7.64、0.8.18 及更早版本：默认 SSL 协议为 SSLv2、SSLv3 和 TLSv1。

- Version 1.0.5 and later: the default SSL ciphers are “`HIGH:!aNULL:!MD5`”. 
  版本 1.0.5 及更高版本：默认 SSL 密码为 “ `HIGH:!aNULL:!MD5` ”。

- Version 0.7.65, 0.8.20 and later: the default SSL ciphers are “`HIGH:!ADH:!MD5`”. 
  版本 0.7.65、0.8.20 及更高版本：默认 SSL 密码为 “ `HIGH:!ADH:!MD5` ”。

- Version 0.8.19: the default SSL ciphers are “`ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM`”. 
  版本 0.8.19：默认 SSL 密码为 “ `ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM` ”。

- Version 0.7.64, 0.8.18 and earlier: the default SSL ciphers are
  版本 0.7.64、0.8.18 及更早版本：默认 SSL 密码为“ `ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP` ”。

  

SSL（安全套接字层）连接在将加密数据从客户端计算机发送到网络服务器之前使用证书进行身份验证。

在本节中，我们将介绍如何在 NGINX 上配置 HTTPS 服务器。

要在我们的 nginx.conf 文件中设置 HTTPS 服务器，请将 ssl 参数添加到 server 块中的 listen 指令，然后指定服务器证书和私钥文件的位置：

```
server {  
    listen              443 ssl;  
    server_name         www.cainiaojc.com;  
    ssl_certificate     www.cainiaojc.com.crt;  
    ssl_certificate_key www.cainiaojc.com.key;  
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;  
    ssl_ciphers         HIGH:!aNULL:!MD5;  
    #...  
} 
```

服务器证书是一个公共实体。它被发送到连接到 Nginx 的每个客户端。

私钥是安全的密钥或实体，应存储在访问受限的文件中。但是 nginx 的 master 进程必须能够读取这个文件。我们还可以将私钥存储在与证书相同的文件中。

```
ssl_certificate     www.cainiaojc.com.cert;  
ssl_certificate_key www.cainiaojc.com.cert;  
```

ssl_protocol 和 ssl_ciphers 指令可用于要求客户端在建立连接时使用的 SSL/TLS 版本和加密方案。

## 使用 HTTP 基本身份验证限制访问

我们可以通过实施用户名和密码身份验证来限制对我们网站或其某些部分的访问。用户名和密码取自密码文件创建工具（例如 apache2-utils）创建。

**创建密码文件**

要创建用户名-密码对，请使用密码文件创建实用程序，例如 httpd-tools 或 apache2-utils：

\1. 首先，验证是否安装了 httpd-tools 或 apache2-utils。

\2. 创建密码文件和第一个用户，运行带有 -c 标志的 htpasswd 实用程序，用于创建新文件，文件路径名作为第一个参数，用户名作为第二个参数。

```
$ sudo htpasswd -c /etc/apache2/.htpasswd user1  
```

按 Enter 并在出现提示时输入 user1 的密码。

\3. 创建额外的用户名-密码对。省略 -c 标志，因为文件已经存在：

```
$ sudo htpasswd /etc/apache2/.htpasswd user2
```

\4. 我们可以确保文件包含配对的用户名和加密密码：

```
$ cat /etc/apache2/.htpasswd  
user1:$apr1$/woC1jnP$KAh0SsVn5qeSMjTtn0E9Q0  
user2:$apr1$QdR8fNLT$vbCEEzDj7LyqCMyNpSoBh/  
user3:$apr1$Mr5A0e.U$0j39Hp5FfxRkneklXaMrr/  
```

## 配置 Nginx HTTP 基本身份验证 

\1. 在我们要保护的 location 内，定义 auth_basic 指令并为受密码保护的区域命名。当要求提供凭据时，该区域的名称将显示在用户名和密码对话框中。

```
location /api {  
    auth_basic "Administrator's Area";  
    #...  
}  
```

\2. 使用 auth_basic_user_file 指令指定包含用户/密码对的 .htpasswd 文件：

```
location /api {  
    auth_basic           "Administrator's Area";  
    auth_basic_user_file /etc/apache2/.htpasswd;   
}  
```

# Nginx 缓存清理

NGINX 可以从缓存中删除旧的和过期的缓存文件。过期的缓存内容需要及时删除，以防止同时提供新旧版本的网页。当收到包含自定义 HTTP 标头或 HTTP PURGE 方法的特殊“Purge”请求时，将清除缓存。

## 配置缓存清除

让我们设置一个配置，用于识别使用 HTTP PURGE 方法的请求并删除匹配的 URL。

\1. 在 http {} 上下文中，添加一个新变量，例如 $purge_method，它依赖于 $request_method 变量：

```
http {  
    ...  
    map $request_method $purge_method {  
        PURGE 1;  
        default 0;  
    }  
}  
```

2.在配置缓存的 location {} 块中，添加 proxy_cache_purge 指令来指定**缓存清除请求**的条件。在我们的例子中，就是上面步骤中配置的 $purge_method ：

```
server {  
    listen      80;  
    server_name www.caioniaojc.com;  
  
    location / {  
        proxy_pass  https://localhost:8002;  
        proxy_cache mycache;  
  
        proxy_cache_purge $purge_method;  
    }  
}  
```

### 发送清除命令

当 proxy_cache_purge 指令配置完成后，我们需要发送一个特殊的 cache?purge 请求来清除缓存。我们可以使用一系列工具发出清除请求，包括本例中的 curl 命令： 

```
$ curl -X PURGE -D - "https://www.cainiaojc.com/*"  
HTTP/1.1 204 No Content  
Server: nginx/1.15.0  
Date: Sat, 19 May 2018 16:33:04 GMT  
Connection: keep-alive  
```

在上面的示例中，具有由星号通配符指定的公共 URL 部分的资源被清除。但是，此类缓存条目不会完全从缓存中删除：它们保留在磁盘上，直到它们因不活动、缓存清除程序或客户端尝试访问它们而被删除。

### 限制对清除命令的访问

建议限制允许发送缓存清除请求的 IP 地址数量：

```
geo $purge_allowed {  
   default         0;  # deny from other  
   10.0.0.1        1;  # allow from localhost  
   192.168.0.0/24  1;  # allow from 10.0.0.0/24  
}  
  
map $request_method $purge_method {  
   PURGE   $purge_allowed;  
   default 0;  
}  
```

在上面的例子中，NGINX 检查请求中是否使用了 PURGE 方法，如果是，则分析客户端 IP 地址。如果 IP 地址被列入白名单，则 $purge_method 设置为 $purge_allowed：1 用于允许清除，0 用于拒绝。

### 从缓存中完全删除文件

要完全删除与星号匹配的缓存文件，请激活一个特殊的缓存清除进程，该进程永久迭代所有缓存条目并删除与通配符键匹配的条目。在 http {} 上下文中的 proxy_cache_path 指令中包含 purger 参数：

```
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=mycache:10m purger=on;  
```

### 缓存清除配置示例

```
http {  
    ...  
    proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=mycache:10m purger=on;  
  
    map $request_method $purge_method {  
        PURGE 1;  
        default 0;  
    }  
  
    server {  
        listen      80;  
        server_name www.example.com;  
  
        location / {  
            proxy_pass        https://localhost:8002;  
            proxy_cache       mycache;  
            proxy_cache_purge $purge_method;  
        }  
    }  
  
    geo $purge_allowed {  
       default         0;  
       10.0.0.1        1;  
       192.168.0.0/24  1;  
    }  
  
    map $request_method $purge_method {  
       PURGE   $purge_allowed;  
       default 0;  
    }  
}  
```

### 字节范围缓存

有时初始缓存填充操作需要相当长的时间，特别是对于大型文件。例如，当一个视频文件开始下载以满足部分文件的初始请求时，后续请求必须等待整个文件下载并放入缓存中。

在 Nginx 中，可以缓存此类范围请求，并使用 Cache Slice 模块逐渐填充缓存，该模块将文件划分为更小的“切片”。每个范围请求选择覆盖所请求范围的特定切片，如果该范围仍未缓存，则将其放入缓存中。对这些切片的所有其他请求都从缓存中获取数据。

**要启用字节范围缓存：**

- 首先，确保 NGINX 是使用 Cache Slice 模块编译的。
- 使用 slice 指令定义切片的大小：

```
location / {  
    slice  1m;  
}  
```

- 选择使切片下载速度更快的切片大小。如果大小太小，则内存使用可能过多，并且打开了大量文件描述符。如果大小很大，则处理请求可能会导致延迟。将 $slice_range 变量添加到缓存键：

```
proxy_cache_key $uri$is_args$args$slice_range;  
```

 

- 使用 206 状态代码启用响应缓存：

```
proxy_cache_valid 200 206 1h;  
```

- 通过在 Range 标头字段中设置变量（即 $slice_range）来启用将范围请求传递到代理服务器：

```
proxy_set_header  Range $slice_range;  
```

 

这是完整的配置：

```
location / {  
    slice             1m;  
    proxy_cache       cache;  
    proxy_cache_key   $uri$is_args$args$slice_range;  
    proxy_set_header  Range $slice_range;  
    proxy_cache_valid 200 206 1h;  
    proxy_pass        http://localhost:8000;  
}
```

请注意，如果打开切片缓存，则不得更改初始文件。

### 组合配置示例

```
http {  
    ...  
    proxy_cache_path /data/nginx/cache keys_zone=one:10m loader_threshold=300   
                     loader_files=200 max_size=200m;  
  
    server {  
        listen 8080;  
        proxy_cache mycache;  
  
        location / {  
            proxy_pass http://backend1;  
        }  
  
        location /some/path {  
            proxy_pass http://backend2;  
            proxy_cache_valid any 1m;  
            proxy_cache_min_uses 3;  
            proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;  
        }  
    }  
}  
```

# nginx TCP 和 UDP 负载平衡

- 自 version 1.9.0 以来新增了 ngx_stream_core_module 模块，使  nginx 支持四层负载均衡。这个模块不仅能实现 TCP 和 UDP 转发，还能支持负载均衡 upstream  配置。默认编译的时候该模块并未编译进去，需要编译的时候添加 --with-stream 参数使其支持 stream 代理。
- 由于协议的不同，UDP 转发仅会将请求包转发至目标，UDP 回复包将由目标机器直接发出给你的请求端。这个回复包是不会经过转发端的，所以在你转发目标端 IP 已经被不明设备给屏蔽无法连接的话，这个 UDP 回复包你还是收不到，这并不是 Nginx 的问题。
- 请注意，stream 配置不能放到 http 内，因为stream是通过tcp层转发，而不是 http 转发

![使用Nginx实现TCP反向代理](https://www.cainiaojc.com/uploads/nginx/images/nginx-stream-proxy.png)

**使用Nginx实现TCP反向代理** 

- 下图是 nginx upstream keepalive 长连接的实现原理。首先每个进程需要一个 connection  pool，里面都是长连接，多进程之间是不需要共享这个连接池的。  一旦与后端服务器建立连接，则在当前请求连接结束之后不会立即关闭连接，而是把用完的连接保存在一个 keepalive connection  pool 里面，以后每次需要建立向后连接的时候，只需要从这个连接池里面找。
- 如果找到合适的连接的话，就可以直接来用这个连接，不需要重新创建 socket 或者发起 connect()。这样既省下建立连接时在握手的时间消耗，又可以避免 TCP 连接的 slow start 慢启动。如果在 keepalive 连接池找不到合适的连接，那就按照原来的步骤重新建立连接。
- 如果你的连接池的数控制在 128 个，总共线程池内的线程数是 128 * nginx  worker 个，但因为你要应对更多的并发请求，所以临时又加了很多的连接，但这临时的连接是短连接和长连接要看你的 Nginx 版本。那他如何被收回，两地保证，一点是他会主动去释放，另一点是 keepalive timeout 的时间。

![使用Nginx实现TCP反向代理](https://www.cainiaojc.com/uploads/nginx/images/nginx-stream-proxy-1.webp)**使用Nginx实现TCP反向代理**

## 1. 手动编译

**需要注意的是，使用 DockerHub 中的 Nginx 镜像是不用二次编译的。** 

```
# 下载1.9版本以上的nginx
wget http://nginx.org/download/nginx-1.20.2.tar.gz

# 安装依赖包
yum install -y gcc glibc gcc-c++ prce-devel openssl-devel pcre-devel
useradd -s /sbin/nologin nginx -M

# 加压目录
tar xf nginx-1.10.3.tar.gz && cd nginx-1.20.2

# 手动编译
./configure \
    --prefix=/usr/local/nginx-1.20.2 \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-stream

# 安装到系统上
make && make install

# 检查配置文件
/usr/local/nginx/sbin/nginx -t
```

## 2. Nginx TCP 转发

**以下的配置就是 TCP 转发的最简配置** 

- 我们能很明显的发现，stream 模块的配置其实跟 http 模块很类似。但实际上 stream 模块与 http 模块上完全是两套不同的处理流程。用最简单的说法就是，http 模块是基于 Layer7 层的应用层处理流程，而 Stream 仅在 Layer4 层上对连接进行处理。
- 所以 stream 模块无法像 http 模块那样能区分 vhost 主机名，然而这在  stream 模块在引入了 ssl 配置之后又能支持了。而且 stream 模块还能引入 ssl/tls 来对 TCP 连接进行加密。由于 TLS 标准内对 SNI 提供了支持，所以又能识别主机名了。在理论上，stream 模块的端口转发效率实际上相比 http 模块的反向代理效率更高。

 

```
user  nginx;
worker_processes  1;

events {
    worker_connections  1024;
}

stream {
    # 全局配置
    preread_timeout        120s;
    proxy_connect_timeout  120s;
    proxy_protocol_timeout 120s;
    resolver_timeout       120s;
    proxy_timeout          120s;
    tcp_nodelay            on;

    # 设置日志格式
    log_format proxy '$remote_addr [$time_local] '
                  '$protocol $status $bytes_sent $bytes_received '
                  '$session_time "$upstream_addr" "$upstream_bytes_sent"'
                  '"$upstream_bytes_received" "$upstream_connect_time"';

    access_log /var/log/nginx/stream.access.log proxy;
    error_log  /var/log/nginx/stream.error.log error;

    upstream app_pg {
        hash $remote_addr consistent;
        server 192.168.100.60:5432;
        server 192.168.100.61:5432;
        server 192.168.100.62:5432;
    }

    server {
        # 不指定协议默认是TCP协议
        listen 127.0.0.1:5432 so_keepalive=on;
        proxy_pass app_pg;
    }

    server{
        # keepalive的可配置参数差不多有以下几个：keepidle，keepintvl，keepcnt
        # keepidle为连接保持时间；keepintvl为连接的间隔时间；keepcnt是连接的个数

        # 下示将idle超时设置为30分钟，探测间隔为系统默认值，并将探测计数设置为10个探测器
        # 实际配置的格式为：so_keepalive=on|off|[keepidle]:[keepintvl]:[keepcnt]
        listen *:3306 so_keepalive=30m::10;
        proxy_connect_timeout 10s;
        proxy_timeout 20s;
        proxy_buffer_size 512k;
        proxy_pass 192.168.100.60:8000;
    }
}
```

 

- **Nginx实现 SSH 转发** 

 

```
user  nginx;
worker_processes  1;

events {
    worker_connections  1024;
}

stream {
    upstream ssh {
            hash $remote_addr consistent;
            server 192.168.1.42:22 weight=5;
       }

    server {
        listen 2222;
        proxy_pass ssh;
       }
}
```

## 3. Nginx UDP 转发

**以下的配置就是 UDP 转发的最简配置** 

- UDP 转发并不是 stream 模块一开始就支持的，而是在 1.9.3 版本之后的 stream 模块才追加了 UDP 转发支持，所以要配置 UDP 转发前必须得先确定自己的 Nginx 版本是否达到了要求。

```
user  nginx;
worker_processes  1;

events {
    worker_connections  1024;
}

stream {
    # 全局配置
    proxy_timeout 120s;
    tcp_nodelay on;

    # 设置日志格式
    log_format proxy '$remote_addr [$time_local] '
                 '$protocol $status $bytes_sent $bytes_received '
                 '$session_time "$upstream_addr" '
                 '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

    access_log /var/log/nginx/stream.access.log proxy;
    error_log /var/log/nginx/stream.error.log error;

    # 配置dns负载均衡
    upstream dns_upstreams {
        server 1.1.1.1:53 weight=1;
        server 1.0.0.1:53 weight=1;        # weight负载均衡权重
        server 8.8.8.8:53 weight=1 backup; # backup标记为备用服务器
    }

    server{
        listen 53 udp;
        proxy_responses 1; # UDP协议专用；期望后端返回给客户端数据包的数量
        proxy_timeout 20s; # 超时时间
        proxy_pass dns_upstreams;
    }
}
```

 

​                         

 ![img](../../../Image/n/nginx_ar.jpg)

## 反向代理服务器？

经常听人说到一些术语，如反向代理，那么什么是反向代理，什么又是正向代理呢？

**正向代理：**

![img](https://pic4.zhimg.com/80/v2-c8ac111c267ae0745f984e326ef0c47f_720w.jpg)正向代理示意图

**反向代理：**

![img](https://pic2.zhimg.com/80/v2-4787a512240b238ebf928cd0651e1d99_720w.jpg)反向代理示意图

由于防火墙的原因，我们并不能直接访问谷歌，那么我们可以借助VPN来实现，这就是一个简单的正向代理的例子。这里你能够发现，正向代理“代理”的是客户端，而且客户端是知道目标的，而目标是不知道客户端是通过VPN访问的。

当我们在外网访问百度的时候，其实会进行一个转发，代理到内网去，这就是所谓的反向代理，即反向代理“代理”的是服务器端，而且这一个过程对于客户端而言是透明的。

## Nginx的Master-Worker模式

![img](https://pic3.zhimg.com/80/v2-0951372e22a6314b1e9b520b3cd6b3b6_720w.jpg)nginx进程

启动Nginx后，其实就是在80端口启动了Socket服务进行监听，如图所示，Nginx涉及Master进程和Worker进程。

![img](https://pic4.zhimg.com/80/v2-b24eb2b29b48f59883232a58392ddae3_720w.jpg)Master-Worker模式

![img](https://pic2.zhimg.com/80/v2-d21393745de9c470934575ef76cefd29_720w.jpg)nginx.conf

Master进程的作用是？

**读取并验证配置文件nginx.conf；管理worker进程；**

Worker进程的作用是？

**每一个Worker进程都维护一个线程（避免线程切换），处理连接和请求；注意Worker进程的个数由配置文件决定，一般和CPU个数相关（有利于进程切换），配置几个就有几个Worker进程。**

## 思考：Nginx如何做到热部署？

所谓热部署，就是配置文件nginx.conf修改后，不需要stop Nginx，不需要中断请求，就能让配置文件生效！（nginx -s reload 重新加载/nginx -t检查配置/nginx -s stop）

通过上文我们已经知道worker进程负责处理具体的请求，那么如果想达到热部署的效果，可以想象：

方案一：

修改配置文件nginx.conf后，主进程master负责推送给woker进程更新配置信息，woker进程收到信息后，更新进程内部的线程信息。（有点valatile的味道）

方案二：

修改配置文件nginx.conf后，重新生成新的worker进程，当然会以新的配置进行处理请求，而且新的请求必须都交给新的worker进程，至于老的worker进程，等把那些以前的请求处理完毕后，kill掉即可。

Nginx采用的就是方案二来达到热部署的！

## 思考：Nginx如何做到高并发下的高效处理？

上文已经提及Nginx的worker进程个数与CPU绑定、worker进程内部包含一个线程高效回环处理请求，这的确有助于效率，但这是不够的。

**作为专业的程序员，我们可以开一下脑洞：BIO/NIO/AIO、异步/同步、阻塞/非阻塞...**

要同时处理那么多的请求，要知道，有的请求需要发生IO，可能需要很长时间，如果等着它，就会拖慢worker的处理速度。

**Nginx采用了Linux的epoll模型，epoll模型基于事件驱动机制，它可以监控多个事件是否准备完毕，如果OK，那么放入epoll队列中，这个过程是异步的。worker只需要从epoll队列循环处理即可。**

## 思考：Nginx挂了怎么办？

Nginx既然作为入口网关，很重要，如果出现单点问题，显然是不可接受的。

答案是：**Keepalived+Nginx实现高可用**。

Keepalived是一个高可用解决方案，主要是用来防止服务器单点发生故障，可以通过和Nginx配合来实现Web服务的高可用。（其实，Keepalived不仅仅可以和Nginx配合，还可以和很多其他服务配合）

Keepalived+Nginx实现高可用的思路：

第一：请求不要直接打到Nginx上，应该先通过Keepalived（这就是所谓虚拟IP，VIP）

第二：Keepalived应该能监控Nginx的生命状态（提供一个用户自定义的脚本，定期检查Nginx进程状态，进行权重变化,，从而实现Nginx故障切换）

![img](https://pic4.zhimg.com/80/v2-ec3208d1ea659d126fe2a008ec5ae927_720w.jpg)Keepalived+Nginx

## 我们的主战场：nginx.conf

很多时候，在开发、测试环境下，我们都得自己去配置Nginx，就是去配置nginx.conf。

nginx.conf是典型的分段配置文件，下面我们来分析下。

## 虚拟主机

![img](https://pic4.zhimg.com/80/v2-b418e69a42a65f033cfdf3b80b988d83_720w.jpg)http的server段

![img](https://pic3.zhimg.com/80/v2-bec9b433b145d892b4eddfaf5b2aee1e_720w.jpg)访问结果

其实这是把Nginx作为web server来处理静态资源。

第一：location可以进行正则匹配，应该注意正则的几种形式以及优先级。（这里不展开）

第二：Nginx能够提高速度的其中一个特性就是：动静分离，就是把静态资源放到Nginx上，由Nginx管理，动态请求转发给后端。

**第三：我们可以在Nginx下把静态资源、日志文件归属到不同域名下（也即是目录），这样方便管理维护。**

**第四：Nginx可以进行IP访问控制，有些电商平台，就可以在Nginx这一层，做一下处理，内置一个黑名单模块，那么就不必等请求通过Nginx达到后端在进行拦截，而是直接在Nginx这一层就处理掉。**

## 反向代理【proxy_pass】

所谓反向代理，很简单，其实就是在location这一段配置中的root替换成**proxy_pass**即可。root说明是静态资源，可以由Nginx进行返回；而proxy_pass说明是动态请求，需要进行转发，比如代理到Tomcat上。

反向代理，上面已经说了，过程是透明的，比如说request -> Nginx ->  Tomcat，那么对于Tomcat而言，请求的IP地址就是Nginx的地址，而非真实的request地址，这一点需要注意。不过好在Nginx不仅仅可以反向代理请求，还可以由用户**自定义设置HTTP HEADER**。

## 负载均衡【upstream】

上面的反向代理中，我们通过proxy_pass来指定Tomcat的地址，很显然我们只能指定一台Tomcat地址，那么我们如果想指定多台来达到负载均衡呢？

第一，通过**upstream**来定义一组Tomcat，并指定负载策略（IPHASH、加权论调、最少连接），健康检查策略（Nginx可以监控这一组Tomcat的状态）等。

第二，将proxy_pass替换成upstream指定的值即可。

**负载均衡可能带来的问题？**

负载均衡所带来的明显的问题是，一个请求，可以到A server，也可以到B server，这完全不受我们的控制，当然这也不是什么问题，只是我们得注意的是：**用户状态的保存问题，如Session会话信息，不能在保存到服务器上。**

## 缓存

缓存，是Nginx提供的，可以加快访问速度的机制，说白了，在配置上就是一个开启，同时指定目录，让缓存可以存储到磁盘上。具体配置，大家可以参考Nginx官方文档，这里就不在展开了。

一款自由的、开源的、高性能的HTTP服务器和反向代理服务器；同时也是一个IMAP、POP3、SMTP代理服务器。

源码：https://trac.nginx.org/nginx/browser

官网：http://www.nginx.org/



## 常用功能

### HTTP代理，反向代理

作为web服务器最常用的功能之一，尤其是反向代理。

### 负载均衡

负载均衡策略有2种：内置策略和扩展策略。

**内置策略:** 轮询，加权轮询，IP hash。

* 轮询：将每个前端请求按顺序（时间顺序或者排列顺序）逐一分配到不同的后端节点上，对于出现问题的后端节点自动排除。
* 加权轮询：在基本的轮询策略上考虑各后端节点接受请求的权重，指定各后端节点被轮询到的几率。主要用于后端节点性能不均衡的情况。
* Ip hash算法：对客户端请求的ip进行hash操作，然后根据hash结果将同一个客户端ip的请求分发给同一台服务器进行处理，可以解决session不共享的问题。

**扩展策略:** url hash， fair

* url hash: 对前端请求的url进行hash操作。
  * 优点：如果后端有缓存服务器，能够提高缓存效率，同时也解决了session的问题。
  * 缺点：如果后端节点出现异常，不能自动排除该节点。
* fair: 将前端请求转发到一个最近负载最小的后台节点。通过后端节点对请求的相应时间来判断负载情况。相应时间短的节点负载相对较轻。

### web缓存

Nginx可以对不同的文件做不同的缓存处理，配置灵活。

* Proxy_Cache	        用于在Nginx服务器提供反向代理时，对后端源服务器的返回内容进行URL缓存。
* FastCGI_Cache        用于对FastCGI的动态程序进行缓存。
* ngx_cache_purge    对指定的URL缓存内容进行增删管理。



## 配置 Nginx+PHP

假设我们用PHP实现了一个前端控制器，或者直白点说就是统一入口：把PHP请求都发送到同一个文件上，然后在此文件里通过解析「REQUEST_URI」实现路由。
一般这样配置

此时很多教程会教大家这样配置Nginx+PHP：

    server {
        listen 80;
        server_name foo.com;
        root /path;
        location / {
            index index.html index.htm index.php;
            if (!-e $request_filename) {
                rewrite . /index.php last;
            }
        }
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME /path$fastcgi_script_name;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
        }
    }

这里面有很多错误，或者说至少是坏味道的地方，大家看看能发现几个。

Nginx配置文件里指令的继承关系：

Nginx配置文件分为好多块，常见的从外到内依次是「http」、「server」、「location」等等，缺省的继承关系是从外到内，也就是说内层块会自动获取外层块的值作为缺省值。
让我们先从「index」指令入手吧

在问题配置中它是在「location」中定义的：

    location / {
        index index.html index.htm index.php;
    }

一旦未来需要加入新的「location」，必然会出现重复定义的「index」指令，这是因为多个「location」是平级的关系，不存在继承，此时应该在「server」里定义「index」，借助继承关系，「index」指令在所有的「location」中都能生效。
接下来看看「if」指令

说它是大家误解最深的Nginx指令毫不为过：

    if (!-e $request_filename) {
        rewrite . /index.php last;
    }

很多人喜欢用「if」指令做一系列的检查，不过这实际上是「try_files」指令的职责：

    try_files $uri $uri/ /index.php;

除此以外，初学者往往会认为「if」指令是内核级的指令，但是实际上它是rewrite模块的一部分，加上Nginx配置实际上是声明式的，而非过程式的，所以当其和非rewrite模块的指令混用时，结果可能会非你所愿。
下面看看「fastcgi_params」配置文件

    include fastcgi_params;

Nginx有两份fastcgi配置文件，分别是「fastcgi_params」和「fastcgi.conf」，它们没有太大的差异，唯一的区别是后者比前者多了一行「SCRIPT_FILENAME」的定义：

fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

注意：$document_root 和 $fastcgi_script_name 之间没有 /。

原本Nginx只有「fastcgi_params」，后来发现很多人在定义「SCRIPT_FILENAME」时使用了硬编码的方式，于是为了规范用法便引入了「fastcgi.conf」。

不过这样的话就产生一个疑问：为什么一定要引入一个新的配置文件，而不是修改旧的配置文件？这是因为「fastcgi_param」指令是数组型的，和普通指令相同的是：内层替换外层；和普通指令不同的是：当在同级多次使用的时候，是新增而不是替换。换句话说，如果在同级定义两次「SCRIPT_FILENAME」，那么它们都会被发送到后端，这可能会导致一些潜在的问题，为了避免此类情况，便引入了一个新的配置文件。

此外，我们还需要考虑一个安全问题：在PHP开启「cgi.fix_pathinfo」的情况下，PHP可能会把错误的文件类型当作PHP文件来解析。如果Nginx和PHP安装在同一台服务器上的话，那么最简单的解决方法是用「try_files」指令做一次过滤：

    try_files $uri =404;

改良后的版本

依照前面的分析，给出一份改良后的版本，是不是比开始的版本清爽了很多：

    server {
        listen 80;
        server_name foo.com;
        root /path;
        index index.html index.htm index.php;
        location / {
            try_files $uri $uri/ /index.php$is_args$args;
        }
        location ~ \.php$ {
            try_files $uri =404;
            include fastcgi.conf;
            fastcgi_pass 127.0.0.1:9000;
        }
    }

## 调试 nginx

Nginx的一个 **杀手级特性** 就是你能使用 debug_connection  指令只调试 **某些** 连接。

这个设置只有是你使用 *--with-debug* 编译的nginx才有效。

## 优化

Ngnix使用hash表来协助完成请求的快速处理。

考虑到保存键及其值的hash表存储单元的大小不至于超出设定参数(hash bucket size)，  在启动和每次重新配置时，Nginx为hash表选择尽可能小的尺寸。

直到hash表超过参数(hash max size)的大小才重新进行选择. 对于大多数hash表都有指令来修改这些参数。例如，保存服务器名字的hash表是由指令 `server_names_hash_max_size` 和 `server_names_hash_bucket_size`所控制的。参数hash bucket  size总是等于hash表的大小，并且是一路处理器缓存大小的倍数。在减少了在内存中的存取次数后，使在处理器中加速查找hash表键值成为可能。如果hash bucket  size等于一路处理器缓存的大小，那么在查找键的时候，最坏的情况下在内存中查找的次数为2。第一次是确定存储单元的地址，第二次是在存储单元中查找键值。因此，如果Nginx给出需要增大 hash max size 或 hash bucket size的提示，那么首要的是增大前一个参数的大小.

### 事件模型 

Nginx支持如下处理连接的方法（I/O复用方法），这些方法可以通过`use`指令指定。

-  **select** - 标准方法。 如果当前平台没有更有效的方法，它是编译时默认的方法。你可以使用配置参数 `--with-select_module` 和 `--without-select_module` 来启用或禁用这个模块。
-  **poll** - 标准方法。 如果当前平台没有更有效的方法，它是编译时默认的方法。你可以使用配置参数 `--with-poll_module` 和 `--without-poll_module` 来启用或禁用这个模块。
-  **kqueue** - 高效的方法，使用于 FreeBSD 4.1+, OpenBSD 2.9+, NetBSD 2.0 和 MacOS X. 使用双处理器的MacOS X系统使用kqueue可能会造成内核崩溃。
-  **epoll** - 高效的方法，使用于Linux内核2.6版本及以后的系统。在某些发行版本中，如SuSE 8.2, 有让2.4版本的内核支持epoll的补丁。
-  **rtsig** - 可执行的实时信号，使用于Linux内核版本2.2.19以后的系统。默认情况下整个系统中不能出现大于1024个POSIX实时(排队)信号。这种情况对于高负载的服务器来说是低效的；所以有必要通过调节内核参数 `/proc/sys/kernel/rtsig-max` 来增加队列的大小。可是从Linux内核版本2.6.6-mm2开始， 这个参数就不再使用了，并且对于每个进程有一个独立的信号队列，这个队列的大小可以用 RLIMIT_SIGPENDING 参数调节。当这个队列过于拥塞，nginx就放弃它并且开始使用 `poll` 方法来处理连接直到恢复正常。
-  **/dev/poll** - 高效的方法，使用于 Solaris 7 11/99+, HP/UX 11.22+ (eventport), IRIX 6.5.15+ 和 Tru64 UNIX 5.1A+.
-  **eventport** - 高效的方法，使用于 Solaris 10. 为了防止出现内核崩溃的问题， 有必要安装 [这个](http://sunsolve.sun.com/search/document.do?assetkey=1-26-102485-1)  安全补丁。

## 常见问题(FAQ)

-  [#notwork 某些东东不工作 (URL重写, 代理, 路径, ...)] 
-  [#other 有没有其它类似的Web服务器] 
-  [#chroot 对于chroot的支持是否在计划之中?] 
-  [#usecase 在什么情况下使用Nginx比使用squid要好?] 
-  [#imapexample 有没有人能给出一个完整的.conf配置文件来详细的解读一下怎么配置和测试 IMAP 模块， 而不只是关于 IMAP 的只言片语啊?] 
-  [#smtpexample 怎么让Nginx成为以postfix做为后端的SMTP代理?] 
-  [#loadbalancing Nginx使用什么算法来实现负载均衡? 它能实现基于连接数的负载均衡吗?] 
-  [#proxy_buffering 我能关闭从代理服务器到后端服务器的缓存吗或者使用上传进度特性?] 

###  某些东东不工作 (URL重写, 代理, 路径, ...) 

例如： 如URL重写(rewrite)不工作了或者是unix的路径(/$PATH)的问题云云...

请仔细阅读 [NginxDebugging]  并且 **逐行** 查看错误日志。
 如果你没找到错误 **打起精神** 试着到IRC或邮件列表里说明一下你碰到的问题。

###  有没有其它类似的Web服务器 

-  [Cherokee](http://www.0x50.org/) 
-  [Lighttpd (Lighty)](http://www.lighttpd.net/) 
-  [thttpd](http://www.acme.com/software/thttpd/) 

关于各自的优缺点请使用自己喜欢的搜索引挚查找  ;-)

### 对于chroot的支持是否在计划之中? 

有人知道吗？

### 在什么情况下使用Nginx比使用squid要好? 反之亦然。 

大体上来说nginx主要用于反向加速代理而不是像squid那样做为常规代理服务器。Nginx的最大优势在于高负载情况下内存和CPU的低消耗。 我不认为squid能给你带来比nginx更好的性能。

### 怎么让Nginx成为以postfix做为后端的SMTP代理? 

有人知道不？

###  Nginx使用什么算法来实现负载均衡? 它能实现基于连接数的负载均衡吗? 

目前Nginx使用简单的轮巡算法，所以无法做基本链接计数的负载均衡。 这个可能会在将来的版本中有所改变。

### > 我能关闭从代理服务器到后端服务器的缓存吗或者使用上传进度特性? 

基于 **太多**人询问下面的问题:

-  我能为了得到上传进度而关闭代理的缓存吗
-  使用nginx我怎么才能给用户显示上传进度
-  ...

到目前为止 (2007-Apr-26) 还没有办法关闭到后端服务器的缓存.

​	

## 添加 TLS 加密

### 先决条件

- 私钥存储在 `/etc/pki/tls/private/example.com.key` 文件中。

- TLS 证书存储在`/etc/pki/tls/certs/example.com.crt`文件中。

- CA 证书已附加到服务器的 TLS 证书文件中。 				

- 客户端和网页服务器会将服务器的主机名解析为 web 服务器的 IP 地址。 				

- 在本地防火墙中打开端口`443`。 				

### 步骤

1. 编辑 `/etc/nginx/nginx.conf`文件，并将以下`server`块添加到配置中的`http`块中： 				

   ```bash
   server {
       listen              443 ssl;
       server_name         example.com;
       root                /usr/share/nginx/html;
       ssl_certificate     /etc/pki/tls/certs/example.com.crt;
       ssl_certificate_key /etc/pki/tls/private/example.com.key;
   }
   ```

2. 出于安全考虑，配置成只有 `root` 用户才可以访问私钥文件： 				

   ```bash
   chown root:root /etc/pki/tls/private/example.com.key
   chmod 600 /etc/pki/tls/private/example.com.key
   ```

   > 警告：
>
   > 如果私钥被设置为可以被未授权的用户访问，则需要撤销证书，然后再创建一个新私钥并请求一个新证书。否则，TLS 连接就不再安全。 					

3. 重启 `nginx` 服务： 				

   ```bash
   systemctl restart nginx
   ```



## 2.6. 其他资源

- ​						有关官方 NGINX 文档，请参考 https://nginx.org/en/docs/。请注意，红帽并不维护这个文档，并且可能无法与您安装的 NGINX 版本一起使用。 				
- ​						[通过 PKCS #11 配置应用程序以使用加密硬件](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/configuring-applications-to-use-cryptographic-hardware-through-pkcs-11_security-hardening). 				



## How nginx processes a TCP/UDP session

A TCP/UDP session from a client is processed in successive steps called **phases**:

- `Post-accept`

  The first phase after accepting a client connection. The [ngx_stream_realip_module](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) module is invoked at this phase.

- `Pre-access`

  Preliminary check for access. The [ngx_stream_limit_conn_module](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html) and [ngx_stream_set_module](https://nginx.org/en/docs/stream/ngx_stream_set_module.html) modules are invoked at this phase.

- `Access`

  Client access limitation before actual data processing. At this phase, the [ngx_stream_access_module](https://nginx.org/en/docs/stream/ngx_stream_access_module.html) module is invoked, for [njs](https://nginx.org/en/docs/njs/index.html), the [js_access](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_access) directive is invoked.

- `SSL`

  TLS/SSL termination. The [ngx_stream_ssl_module](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) module is invoked at this phase.

- `Preread`

  Reading initial bytes of data into the [preread buffer](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#preread_buffer_size) to allow modules such as [ngx_stream_ssl_preread_module](https://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html) analyze the data before its processing. For [njs](https://nginx.org/en/docs/njs/index.html), the [js_preread](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_preread) directive is invoked at this phase.

- `Content`

  Mandatory phase where data is actually processed, usually [proxied](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) to [upstream](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html) servers, or a specified value is [returned](https://nginx.org/en/docs/stream/ngx_stream_return_module.html) to a client. For [njs](https://nginx.org/en/docs/njs/index.html), the [js_filter](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_filter) directive is invoked at this phase.

- `Log`

  The final phase where the result of a client session processing is recorded. The [ngx_stream_log_module](https://nginx.org/en/docs/stream/ngx_stream_log_module.html) module is invoked at this phase.

## njs scripting language



njs is a subset of the JavaScript language that allows extending nginx functionality. njs is created in compliance with [ECMAScript 5.1](http://www.ecma-international.org/ecma-262/5.1/) (strict mode) with some [ECMAScript 6](http://www.ecma-international.org/ecma-262/6.0/) and later extensions. The compliance is still [evolving](https://nginx.org/en/docs/njs/compatibility.html).





- [Download and install](https://nginx.org/en/docs/njs/install.html)
- [Changes](https://nginx.org/en/docs/njs/changes.html)
- [Reference](https://nginx.org/en/docs/njs/reference.html)
- [Examples](https://github.com/nginx/njs-examples/)
- [Security](https://nginx.org/en/docs/njs/security.html)
- [Compatibility](https://nginx.org/en/docs/njs/compatibility.html)
- [Command-line interface](https://nginx.org/en/docs/njs/cli.html)
- [Tested OS and platforms](https://nginx.org/en/docs/njs/index.html#tested_os_and_platforms)

 



- [ ngx_http_js_module](https://nginx.org/en/docs/http/ngx_http_js_module.html)
- [ ngx_stream_js_module](https://nginx.org/en/docs/stream/ngx_stream_js_module.html)

 



- [Writing njs code using TypeScript definition files](https://nginx.org/en/docs/njs/typescript.html)
- [Using node modules with njs](https://nginx.org/en/docs/njs/node_modules.html)

 



Use cases



- Complex access control and security checks in njs before a request reaches an upstream server
- Manipulating response headers
- Writing flexible asynchronous content handlers and filters

  See [examples](https://github.com/nginx/njs-examples/) and [blog posts](https://www.nginx.com/blog/tag/nginx-javascript-module/) for more njs use cases.



Basic HTTP Example

To use njs in nginx:

- [install](https://nginx.org/en/docs/njs/install.html) njs scripting language

- create an njs script file, for example, `http.js`. See [Reference](https://nginx.org/en/docs/njs/reference.html) for the list of njs properties and methods.

  > ```
  > function hello(r) {
  >     r.return(200, "Hello world!");
  > }
  > 
  > export default {hello};
  > ```

   

- in the `nginx.conf` file, enable [ngx_http_js_module](https://nginx.org/en/docs/http/ngx_http_js_module.html) module and specify the [js_import](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_import) directive with the `http.js` script file:

  > ```
  > load_module modules/ngx_http_js_module.so;
  > 
  > events {}
  > 
  > http {
  >     js_import http.js;
  > 
  >     server {
  >         listen 8000;
  > 
  >         location / {
  >             js_content http.hello;
  >         }
  >     }
  > }
  > ```

   

  There is also a standalone [command line](https://nginx.org/en/docs/njs/cli.html) utility that can be used independently of nginx for njs development and debugging.



Tested OS and platforms



- FreeBSD / amd64;
- Linux / x86, amd64, arm64, ppc64el;
- Solaris 11 / amd64;
- macOS / x86_64;

 



Presentation at nginx.conf 2018



<iframe type="text/html" src="https://www.youtube.com/embed/Jc_L6UffFOs?modestbranding=1&amp;rel=0&amp;showinfo=0&amp;color=white" allowfullscreen="1" frameborder="0"></iframe>

## Debugging nginx with DTrace pid provider

This article assumes the reader has a general knowledge of nginx internals and [DTrace](https://nginx.org/en/docs/nginx_dtrace_pid_provider.html#see_also).

Although nginx built with the [--with-debug](https://nginx.org/en/docs/debugging_log.html) option already provides a lot of information about request processing, it is sometimes desirable to trace particular parts of code path more thoroughly and at the same time omit the rest of debugging output. DTrace pid provider (available on Solaris, macOS) is a useful tool to explore userland program’s internals, since it doesn’t require any code changes and it can help with the task. A simple DTrace script to trace and print nginx function calls may look like this:

> ```
> #pragma D option flowindent
> 
> pid$target:nginx::entry {
> }
> 
> pid$target:nginx::return {
> }
> ```

 

DTrace capabilities for function calls tracing provide only a limited amount of useful information, though. Real-time inspection of function arguments is typically more interesting, but also a bit more complicated. Examples below are intended to help the reader become more familiar with DTrace and the process of analyzing nginx behavior using DTrace.

One of the common scenarios for using DTrace with nginx is the following: attach to the nginx worker process to log request lines and request start times. The corresponding function to attach is `ngx_http_process_request()`, and the argument in question is a pointer to the `ngx_http_request_t` structure. DTrace script for such request logging can be as simple as:

> ```
> pid$target::*ngx_http_process_request:entry
> {
>     this->request = (ngx_http_request_t *)copyin(arg0, sizeof(ngx_http_request_t));
>     this->request_line = stringof(copyin((uintptr_t)this->request->request_line.data,
>                                          this->request->request_line.len));
>     printf("request line = %s\n", this->request_line);
>     printf("request start sec = %d\n", this->request->start_sec);
> }
> ```

 

It should be noted that in the example above DTrace requires some knowledge about the `ngx_http_request_t` structure. Unfortunately while it is possible to use a specific `#include` directive in the DTrace script and then pass it to a C preprocessor (with the `-C` flag), that doesn’t really work. Due to a lot of cross dependencies, almost all nginx header files have to be included. In turn, based on `configure` script settings, nginx headers will include PCRE, OpenSSL and a variety of system header files. While in theory all those header files related to a specific nginx build might be included in DTrace script preprocessing and compilation, in reality DTrace script most probably will fail to compile because of unknown syntax in some header files.

The problem above can be solved by including only the relevant and necessary structure and type definitions in the DTrace script. DTrace has to know sizes of structures, types, and fields offsets. Thus dependencies can be further reduced by manually optimizing structure definitions for use with DTrace.

Let’s use DTrace script example above and see what structure definitions it needs to work properly.

First of all `objs/ngx_auto_config.h` file generated by configure should be included, because it defines a number of constants affecting various `#ifdef`’s. After that, some basic types and definitions like `ngx_str_t`, `ngx_table_elt_t`, `ngx_uint_t` etc. should be put at the beginning of the DTrace script. These definitions are compact, commonly used and unlikely to be frequently changed.

Then there’s the `ngx_http_request_t` structure that contains a lot of pointers to other structures. Because these pointers are really irrelevant to this script, and because they have the same size, it is possible to just replace them with void pointers. Instead of changing definitions, it is better to add appropriate typedefs, though:

> ```
> typedef ngx_http_upstream_t     void;
> typedef ngx_http_request_body_t void;
> ```

  Last but not least it is necessary to add definitions of two member structures (`ngx_http_headers_in_t`, `ngx_http_headers_out_t`), declarations of callback functions and definitions of constants.

The final DTrace script can be downloaded from [here](http://nginx.org/download/trace_process_request.d).

The following example shows the output of running this script:

> ```
> # dtrace -C -I ./objs -s trace_process_request.d -p 4848
> dtrace: script 'trace_process_request.d' matched 1 probe
> CPU     ID                    FUNCTION:NAME
>   1      4 .XAbmO.ngx_http_process_request:entry request line = GET / HTTP/1.1
> request start sec = 1349162898
> 
>   0      4 .XAbmO.ngx_http_process_request:entry request line = GET /en/docs/nginx_dtrace_pid_provider.html HTTP/1.1
> request start sec = 1349162899
> ```

 

Using similar techniques the reader should be able to trace other nginx function calls.



See also



- [ Solaris Dynamic Tracing Guide](http://docs.oracle.com/cd/E19253-01/817-6223/index.html)
- [ Introduction article on DTrace pid provider](http://dtrace.org/blogs/brendan/2011/02/09/dtrace-pid-provider/)

## Converting rewrite rules

[Converting Mongrel rules](https://nginx.org/en/docs/http/converting_rewrite_rules.html#converting_mongrel_rules) 

A redirect to a main site

People who during their shared hosting life used to configure *everything* using *only* Apache’s .htaccess files, usually translate the following rules:

> ```
> RewriteCond  %{HTTP_HOST}  example.org
> RewriteRule  (.*)          http://www.example.org$1
> ```

  to something like this:

> ```
> server {
>     listen       80;
>     server_name  www.example.org  example.org;
>     if ($http_host = example.org) {
>         rewrite  (.*)  http://www.example.org$1;
>     }
>     ...
> }
> ```

 

This is a wrong, cumbersome, and ineffective way. The right way is to define a separate server for `example.org`:

> ```
> server {
>     listen       80;
>     server_name  example.org;
>     return       301 http://www.example.org$request_uri;
> }
> 
> server {
>     listen       80;
>     server_name  www.example.org;
>     ...
> }
> ```

 

> On versions prior to 0.9.1, redirects can be made with:
>
> > ```
> >     rewrite      ^ http://www.example.org$request_uri?;
> > ```

 

Another example. Instead of the “upside-down” logic “all that is not `example.com` and is not `www.example.com`”:

> ```
> RewriteCond  %{HTTP_HOST}  !example.com
> RewriteCond  %{HTTP_HOST}  !www.example.com
> RewriteRule  (.*)          http://www.example.com$1
> ```

  one should simply define `example.com`, `www.example.com`, and “everything else”:

> ```
> server {
>     listen       80;
>     server_name  example.com www.example.com;
>     ...
> }
> 
> server {
>     listen       80 default_server;
>     server_name  _;
>     return       301 http://example.com$request_uri;
> }
> ```

 

> On versions prior to 0.9.1, redirects can be made with:
>
> > ```
> >     rewrite      ^ http://example.com$request_uri?;
> > ```

 



Converting Mongrel rules

Typical Mongrel rules:

> ```
> DocumentRoot /var/www/myapp.com/current/public
> 
> RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
> RewriteCond %{SCRIPT_FILENAME} !maintenance.html
> RewriteRule ^.*$ %{DOCUMENT_ROOT}/system/maintenance.html [L]
> 
> RewriteCond %{REQUEST_FILENAME} -f
> RewriteRule ^(.*)$ $1 [QSA,L]
> 
> RewriteCond %{REQUEST_FILENAME}/index.html -f
> RewriteRule ^(.*)$ $1/index.html [QSA,L]
> 
> RewriteCond %{REQUEST_FILENAME}.html -f
> RewriteRule ^(.*)$ $1.html [QSA,L]
> 
> RewriteRule ^/(.*)$ balancer://mongrel_cluster%{REQUEST_URI} [P,QSA,L]
> ```

  should be converted to

> ```
> location / {
>     root       /var/www/myapp.com/current/public;
> 
>     try_files  /system/maintenance.html
>                $uri  $uri/index.html $uri.html
>                @mongrel;
> }
> 
> location @mongrel {
>     proxy_pass  http://mongrel;
> }
> ```

## WebSocket proxying

To turn a connection between a client and server from HTTP/1.1 into WebSocket, the [protocol switch](https://datatracker.ietf.org/doc/html/rfc2616#section-14.42) mechanism available in HTTP/1.1 is used.

There is one subtlety however: since the “Upgrade” is a [hop-by-hop](https://datatracker.ietf.org/doc/html/rfc2616#section-13.5.1) header, it is not passed from a client to proxied server. With forward proxying, clients may use the `CONNECT` method to circumvent this issue. This does not work with reverse proxying however, since clients are not aware of any proxy servers, and special processing on a proxy server is required.

Since version 1.3.13, nginx implements special mode of operation that allows setting up a tunnel between a client and proxied server if the proxied server returned a response with the code 101 (Switching Protocols), and the client asked for a protocol switch via the “Upgrade” header in a request.

As noted above, hop-by-hop headers including “Upgrade” and “Connection” are not passed from a client to proxied server, therefore in order for the proxied server to know about the client’s intention to switch a protocol to WebSocket, these headers have to be passed explicitly:

> ```
> location /chat/ {
>     proxy_pass http://backend;
>     proxy_http_version 1.1;
>     proxy_set_header Upgrade $http_upgrade;
>     proxy_set_header Connection "upgrade";
> }
> ```

  A more sophisticated example in which a value of the “Connection” header field in a request to the proxied server depends on the presence of the “Upgrade” field in the client request header:

> ```
> http {
>     map $http_upgrade $connection_upgrade {
>         default upgrade;
>         ''      close;
>     }
> 
>     server {
>         ...
> 
>         location /chat/ {
>             proxy_pass http://backend;
>             proxy_http_version 1.1;
>             proxy_set_header Upgrade $http_upgrade;
>             proxy_set_header Connection $connection_upgrade;
>         }
>     }
> ```

 

By default, the connection will be closed if the proxied server does not transmit any data within 60 seconds. This timeout can be increased with the [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) directive. Alternatively, the proxied server can be configured to periodically send WebSocket ping frames to reset the timeout and check if the connection is still alive.

## Creating a Server User and Changing the Website Root Folder[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#creating-a-server-user-and-changing-the-website-root-folder)

While you *can* just drop your website into the default directory and go (and this might be fine for *Nginx* when it’s running inside a container, or on a test/development server), it’s not what we call best practice. Instead, it’s a good idea to  create a specific Linux user on your system for your website, and put  your website files in a directory made just for that user.

If you want to build multiple websites, it’s actually a good idea to  create multiple users and root directories, both for the sake of  organization and the sake of security.

In this guide, I’m going to have just the one user: a handsome devil  named “www”. Deciding where to put your website files gets more  complicated.

Depending on your server setup, you can put your website files in a  couple of different places. If you're on a bare-metal (physical) server, or you're installing `nginx` directly on a VPS, you probably have Security Enhanced Linux (SELinux) running. SELinux is a tool that  does a lot to protect your machine, but it also kind of dictates where  you can put certain things, like web pages.

So if you're installing `nginx` directly to your machine,  then you'll want to put your websites in subdirectories of the default  root folder. In this case, the default root is `/usr/share/nginx/html`, so the website for the “www” user might go into `/usr/share/nginx/html/www`.

If you're running `nginx` in a container such as LXD/LXC, however, SELinux will likely *not* be installed, and you can put your files wherever you like. In this  case, I like to put all of a user's website files under a directory in a normal home folder, like so: `/home/www/`.

I'll continue this guide as though SELinux is installed, though. Just change what you need to based on your use case. You can also learn more about how SELinux works in [our guide on the subject](https://docs.rockylinux.org/zh/guides/security/learning_selinux/).

### Creating the User[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#creating-the-user)

First, we make the folder we’re going to use:

```
sudo mkdir /usr/share/nginx/html/www
```

Next, create the www group:



```
sudo groupadd www
```

Then, we create the user:



```
sudo adduser -G nginx -g www -d /usr/share/nginx/html/www www --system --shell=/bin/false
```

That command tells the machine to:

- Make a user called “www” (as per the middle bit of text),
- put all of its files in `/usr/share/nginx/html/www`,
- and add it to the following groups: “nginx” as supplemental , “www” as primary.
- The `--system` flag says that the user is not a human  user, it's reserved for the system. If you want to create human user  accounts to manage different websites, that's a whole other guide.
- `--shell=/bin/false` makes sure no one can even *try* to log in as the “www” user.

The “nginx” group does some real magic. It allows the web server to  read and modify files that belong to the “www” user, and the “www” user  group. See the Rocky Linux [guide to user management](https://docs.rockylinux.org/zh/books/admin_guide/06-users/) for more information.

### Changing the Server Root Folder[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#changing-the-server-root-folder)

Now that you have your fancy new user account, it’s time to make `nginx` look for your website files in that folder. Grab your favorite text editor again.

For now, just run:

```
sudo nano /etc/nginx/conf.d/default.conf
```

When the file is open, look for the line that looks like `root   /usr/share/nginx/html;`. Change it to your chosen website root folder, eg. `root   /usr/share/nginx/html/www;` (or `/home/www` if you're running `nginx` in containers like I do). Save and close the file, then test your `nginx` configuration to make sure you didn’t skip a semi-colon or anything:

```
nginx -t
```

If you get the following success message, everything went right:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Then, give the server a soft restart with:

```
sudo systemctl reload nginx
```

Note

In the unlikely event that the soft restart doesn’t work, give `nginx` a kick in the pants with:

```
sudo systemctl restart nginx
```

Any HTML files in your new root folder should now be browsable from… your browser.

### Changing File Permissions[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#changing-file-permissions)

To make sure that `nginx` can read, write to, and execute any files in the website directory, permissions need to be set properly.

First, make sure that all files in the root folder are owned by the server user and its user group with:

```
sudo chown -R www:www /usr/share/nginx/html/www
```

And then, to make sure that users who want to actually browse your  website can actually see the pages, you should run these commands (and  yes, those semicolons matter):

```
sudo find /usr/share/nginx/html/www -type d -exec chmod 555 "{}" \;
sudo find /usr/share/nginx/html/www -type f -exec chmod 444 "{}" \;
```

That basically gives everyone the right to look at files on the  server, but not modify them. Only the root and server users get to do  that.

## Getting SSL Certificates for Your Site[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#getting-ssl-certificates-for-your-site)

As of now, our [guide to getting SSL certificates with certbot](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/) has been updated with some basic instructions for `nginx`. Go give that a look, as it has full instructions for installing certbot, as well as generating the certificates.

The time is coming when browsers might just stop letting people see  sites without certificates at all, so make sure you get one for every  site.

## Additional Configuration Options and Guides[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#additional-configuration-options-and-guides)

- If you want to see how to make *Nginx* work with PHP, and PHP-FPM specifically, check out our [guide to PHP on Rocky Linux](https://docs.rockylinux.org/zh/guides/web/php/).
- If you want to learn how to set up *Nginx* for multiple websites, we now have [a guide on just that subject](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/).

## Installing the Stable Branch From Rocky's Own Repos[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#installing-the-stable-branch-from-rockys-own-repos)

If you want to use the “stable” branch of `nginx`, even with its limitations, here's how you do it. First, make sure your OS is updated:

```
sudo dnf update
```

Then, look for the latest `nginx` version available in the default repos with:

```
sudo dnf module list nginx
```

That should get you a list that looks like this:

```
Rocky Linux 8 - AppStream
Name       Stream        Profiles        Summary
nginx      1.14 [d]      common [d]      nginx webserver
nginx      1.16          common [d]      nginx webserver
nginx      1.18          common [d]      nginx webserver
nginx      1.20          common [d]      nginx webserver
```

Choose the highest number on the list, and enable its module like so:

```
sudo dnf module enable nginx:1.20
```

You'll be asked if you're sure you want to do this, so just choose `Y` as usual. Then, use the default command to install `nginx`:

```
sudo dnf install nginx
```

Then you can enable the service and configure your server as detailed above.

Note

The default configuration file, in this case, is in the base `nginx` configuration folder at `/etc/nginx/nginx.conf`. The root website folder is the same, though.

## SELinux rules[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#selinux-rules)

Beware that when enforced, nginx proxy_pass directives will fail with "502 Bad Gateway"

You can either disable setenforce for development purposes

```
sudo setenforce 0
```

or you can enable `http_d` or other services that related to nginx in `/var/log/audit/audit.log`

```
sudo setsebool httpd_can_network_connect 1 -P
```

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/#conclusion)

The basic installation and configuration of `nginx` are  easy, even if it’s more complicated than it should be to get the latest  version. But, just follow the steps, and you’ll have one of the best  server options out there up and running quickly.

Now you just have to go and build yourself a website? What could that take, another ten minutes? *Sobs quietly in Web Designer*

------

# How to Set up Nginx for Multiple Websites on Rocky Linux[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#how-to-set-up-nginx-for-multiple-websites-on-rocky-linux)

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#introduction)

Here it is, my promised guide to Nginx multisite setups on Rocky  Linux. I'm going to start off with a note for beginners; the rest of you know what you're here for, so scroll on down.

Hi Newbies! One of the things that Nginx does *very* well is  direct traffic from one central point to multiple websites and apps on  one server, or on several other servers. This feature is called a  "reverse proxy", and the relative ease with which Nginx does this is one of the reasons I started using it.

Here I'll be showing you how to manage multiple websites on a single  Nginx installation, and how to do it in a simple and organized way that  will let you make changes quickly and easily.

For those looking for a similar setup for Apache, take a [look at this guide.](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/)

I'll be explaining a *lot* of details... but in the end, the  whole process basically involves setting up some folders, and making  some small text files. We won't be using overly-complicated website  configurations for this guide, so relax with a coffee and have some fun. Once you know how to do it, it'll only take minutes to do every time.  This one's easy.*

\* For given values of "easy".

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#prerequisites-and-assumptions)

This is everything you'll need:

- A Rocky Linux server connected to the internet, with Nginx already  running on it. If you haven't gotten that far, you can follow [our guide to installing Nginx](https://docs.rockylinux.org/zh/guides/web/nginx-mainline/) first.

- Some comfort with doing things on the command line, and a terminal-based text editor like `nano` installed.

  In a pinch

  ... you could use something like Filezilla or WinSCP — and a regular  GUI-based text editor — to replicate most of these steps, but we'll be  doing things the nerdy way in this tutorial.

- At least one domain pointed at your server for one of the test  websites. You can use either a second domain or a subdomain for the  other.

  Tip

  If you're doing all of this on a local server, adjust your hosts file as necessary to create simulated domain names. Instructions below.

- We are assuming that you're running Nginx on a bare metal server or  regular VPS, and that SELinux is running. All instructions will be  compatible with SELinux by default.

- *All commands must be run as root,* either by logging in as the root user, or using `sudo`.

## Setting up Your Folders and Test Sites[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#setting-up-your-folders-and-test-sites)

### The website folders[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#the-website-folders)

First, you're going to need a couple of folders for your website  files. When you first install Nginx, all of the "demo" website files  will be in `/usr/share/nginx/html`. That's fine if you're hosting just the one site, but we're going to get fancy. Ignore the `html` directory for now, and just navigate its parent folder:

```
cd /usr/share/nginx
```

The test domains for the sake of this tutorial will be `site1.server.test` and `site2.server.test`, and we're going to name those website folders accordingly. You should  change those domains to whatever you're using, of course. However (and  here's a trick I picked up from Smarter PeopleTM), we're going to write the domain names "backwards".

eg. "yourwebsite.com" would go in a folder called `com.yourwebsite`. Mind you, you can *literally* name these folders whatever you want, but there's a good reason for this method, which I've outlined below.

For now, just make your folders:

```
mkdir -p test.server.site1/html
mkdir -p test.server.site2/html
```

So that command will make, for example, the `test.server.site1` folder, and put another folder called `html` inside of it. That is where you're going to put the actual files you  want to serve via the web server. (You could also call it "webroot" or  something like that.)

This is so you can put website-related files that you *don't* want to make public in the parent directory, while still keeping everything in one place.

Note

The `-p` flag tells the `mkdir` command to create any missing folders in the path you just defined, so you don't have to make each folder one at a time.

For this test, we're keeping the "websites" themselves very simple.  Just make an HTML file in the first folder with your favorite text  editor:

```
nano test.server.site1/html/index.html
```

Then paste in the following bit of HTML:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Site 1</title>
</head>
<body>
    <h1>This is Site 1</h1>
</body>
</html>
```

Save and close your file, then repeat the steps with the `test.server.site2` folder, changing "Site 1" to "Site 2" in the HTML code above. This is  just so we can be sure everything is working as intended later on.

Your test websites are done, let's move on.

### The configuration folders[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#the-configuration-folders)

Now let's go to the Nginx settings and configuration folder, which is where we'll be working for the rest of this guide:

```
cd /etc/nginx/
```

If you run the `ls` command to see what files and folders  are in here, you'll see a bunch of different things, most of which are  irrelevant today. The ones to note are these:

- `nginx.conf` is the file that contains, you guessed it, the default Nginx configuration. We'll be editing that later.
- `conf.d` is a directory where you can put custom configuration files. You *could* use this for websites, but it's better to use it for feature-specific settings that you want on all of your websites.
- `default.d` is a directory where your website config *might* go if you were only running one site on the server, or if your server has a "primary" website. Leave it alone for now.

We want to create two new folders called `sites-available` and `sites-enabled`:

```
mkdir sites-available
mkdir sites-enabled
```

What we're going to do is put all of our website configuration files in the `sites-available` folder. There, you can work on the configuration files as long as you  need to, until you're ready to activate the files with a symbolic link  to the `sites-enabled` folder.

I'll show you how that works below. For now, we're done with making folders.

Why you (might) want to write your domains backwards:

Simply put, it's an organizational thing that's especially useful  when using the command line with tab completion, but still pretty useful in GUI-based apps. It's designed for people who are running a *lot* of websites or apps on a server.

Basically, all of your website folders (and configuration files) will get organized alphabetically; by the top level domain first (eg. .com,  .org, etc), then the primary domain, and then by any subdomains. When  you're searching through a long list of domains, it can be easier to  narrow down what you're looking for this way.

It also makes it easier to sort out your folders and config files via command line tools. To list all folders associated with a particular  domain, you might run:

```
ls /usr/share/nginx/ | grep com.yoursite*
```

Which would output something like:

```
com.yoursite.site1
com.yoursite.site2
com.yoursite.site3
```

## Setting up Your Configuration Files[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#setting-up-your-configuration-files)

### Editing nginx.conf[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#editing-nginxconf)

By default, Rocky Linux's implementation of Nginx is open to all HTTP traffic, and directs it all to the demo page you might have seen in our guide to installing Nginx. We don't want that. We want traffic from the domains we specify to go to the websites we specify.

So from the `/etc/nginx/` directory, open up `nginx.conf` in your favorite text editor:

```
nano nginx.conf
```

First, find the line that looks like this:

```
include /etc/nginx/conf.d/*.conf;
```

And **add** this bit just below it:

```
include /etc/nginx/sites-enabled/*.conf;
```

That will load in our website configuration files when they're ready to go live.

Now head down to the section that looks like this, and either **comment it out** with the hash sign #, or delete it if you feel so inclined:

```
server {
    listen       80;
    listen       [::]:80;
    server_name  _;
    root         /usr/share/nginx/www/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /404.html {
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    }
}
```

What that would look like "commented out":

```
#server {
#    listen       80;
#    listen       [::]:80;
#    server_name  _;
#    root         /usr/share/nginx/www/html;
#
#    # Load configuration files for the default server block.
#    include /etc/nginx/default.d/*.conf;
#
#    error_page 404 /404.html;
#    location = /404.html {
#    }
#
#    error_page 500 502 503 504 /50x.html;
#    location = /50x.html {
#    }
#}
```

If you're a beginner, you might want to keep the commented code  around for reference, and that goes for the example HTTPS code that's  already commented out further down in the file.

Save and close the file, then restart the server with:

```
systemctl restart nginx
```

Now no one will see the demo page, at least.

### Adding the website configuration files[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#adding-the-website-configuration-files)

Now let's make your test websites available on the server. As  previously mentioned, we're going to to this with symbolic links so we  have an easy way of turning the websites on and off at will.

Note

For absolute newbies, symbolic links are basically a way of letting  files pretend to be in two folders at once. Change the original file (or "target"), and it's changed everywhere that you've linked to it. If you use a program to edit the file via a link, the original gets changed.

However, if you delete a link to the target, nothing at all happens  to the original file. This trick is what allows us to put the website  configuration files in a working directory (`sites-available`), and then "activate" them by linking to those files from `sites-enabled`.

I'll show you what I mean. Make a configuration file for the first website like so:

```
nano sites-available/test.server.site1.conf
```

Now paste in this code. This is about the simplest working Nginx  configuration you can have, and should work fine for most static HTML  websites:

```
server {
    listen 80;
    listen [::]:80;

    # virtual server name i.e. domain name #
    server_name site1.server.test;

    # document root #
    root        /usr/share/nginx/test.server.site1/html;

    # log files
    access_log  /var/log/nginx/www_access.log;
    error_log   /var/log/nginx/www_error.log;

    # Directives to send expires headers and turn off 404 error logging. #
    location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
        access_log off; log_not_found off; expires max;
    }
}
```

And heck, everything from the document root on down is technically  optional. Useful and recommended, but not strictly required for the  website to function.

Anyway, save and close the file, then go into `sites-enabled` directory:

```
cd sites-enabled
```

Now, create a symbolic link to the configuration file you just made in the `sites-available` folder.:

```
ln -s ../sites-available/test.server.site1.conf
```

Test your configuration with the `nginx -t` command, and if you get a message saying everything is okay, reload the server:

```
systemctl restart nginx
```

Then point your browser at the domain you're using for this first  site (in my case: site1.server.test), and look for that "This is Site 1" message we put in the HTML file. If you have `curl` installed on your system, you could run `curl site1.server.test` and see if the HTML code loads in your terminal.

Note

Some browsers will (with all the best intentions) force you to use  HTTPS when you type your server domain into the address bar. If you  don't have HTTPS configured, that'll just throw errors at you.

Make sure to manually specify "http://" in your browser address bar  to avoid this issue. If that doesn't work, clear the cache, or use a  less picky browser for this part of the testing. I recommend [Min](https://minbrowser.org).

If *all* of that goes right, *repeat the steps above, changing the names of the files and the content of the configuration files* as you go. "site1" to "site2" and all of that. Once you have  configuration files and symbolic links for both Site 1 and Site 2, and  have restarted Nginx, it should look like this:

![A screenshot of the two test websites side by side](https://docs.rockylinux.org/zh/guides/web/nginx/images/multisite-nginx.png)

Note

You can also create links from outside of the sites-enabled directory with the long form of the `ln -s` command. It would look like `ln -s [source-file] [link]`.

In this context, that's:

```
ln -s /etc/nginx/sites-available/test.server.site1.conf /etc/nginx/sites-enabled/test.server.site1.conf
```

### Disabling a website[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#disabling-a-website)

If you need to stop one of your websites to work on it before taking  it live again, just delete the symbolic link in sites-enabled:

```
rm /etc/nginx/sites-enabled/test.server.site1.conf
```

Then restart Nginx as usual. To take the site back online, you'll need to re-create the symbolic link, and restart Nginx again.

## Optional: Editing Your Hosts File[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#optional-editing-your-hosts-file)

This part's definitely for beginners. Everyone else can probably skip.

So this section *only* applies if you're trying out this guide in a local development environment. That is, if you're running your  test server on your workstation, or on another machine in your local  home or business network.

Since pointing external domains at your local machines is a hassle  (and potentially dangerous if you don't know what you're doing), you can set up some "fake" domains that will work just fine on your local  network, and nowhere else.

The easiest way to do this is with the hosts file on your computer.  The hosts file is literally just a text file that can override DNS  settings. As in, you can manually specify a domain name to go with any  IP address you want. It'll *only* work on that one computer, though.

So on Mac and Linux, the hosts file is in the `/etc/`  directory, and can be edited via the command line super easily (you'll  need root access). Assuming you're working on a Rocky Linux workstation, just run:

```
nano /etc/hosts
```

On Windows, the hosts file is located at `C:\Windows\system32\drivers\etc\hosts`, and you can just use whatever GUI text editor you want as long as you have Admin access.

So if you're working on a Rocky Linux computer, and are running your  Nginx server on the same machine, you'd just open up the file, and  define the domains/IP addresses you want. If you're running your  workstation and test server on the same machine, that'd be:

```
127.0.0.1           site1.server.test
127.0.0.1           site2.server.test
```

If you're running your Nginx server on another machine on the network, just use the address of that machine, eg.:

```
192.168.0.45           site1.server.test
192.168.0.45           site2.server.test
```

Then you'll be able to point your browser to those domains and it should work as intended.

## Setting Up SSL Certificates for Your Sites[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#setting-up-ssl-certificates-for-your-sites)

Go check out [our guide to getting SSL certificates with Let's Encrypt and certbot](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/). The instructions there will work just fine.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/nginx-multisite/#conclusion)

Remember, most of the folder/file organization and naming conventions here are technically optional. Your website configuration files mostly  just have to go anywhere inside `/etc/nginx/` and `nginx.conf` needs to know where those files are.

The actual website files should be somewhere in `/usr/share/nginx/`, and the rest is gravy.

Try it out, do some ScienceTM, and don't forget to run `nginx -t` before you restart Nginx to make sure you didn't miss a semi-colon or anything. It'll save you a lot of time.

------