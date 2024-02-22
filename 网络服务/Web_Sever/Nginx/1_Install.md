# 安装

## Linux

## FreeBSD

On FreeBSD, nginx can be installed either from the [packages](https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro) or through the [ports](https://docs.freebsd.org/en/books/handbook/ports/#ports-using) system. The ports system provides greater flexibility, allowing selection among a wide range of options. The port will compile nginx with the specified options and install it.

在 FreeBSD 上，nginx 可以从软件包或通过 ports 系统安装。ports 系统提供了更大的灵活性，允许在广泛的选项中进行选择。该 port 将使用指定的选项编译 nginx 并安装它。

## 源代码 

如果需要一些特殊功能，但软件包和 port 中不可用，nginx 也可以从源文件编译。
使用 `configure` 命令进行配置。它定义了系统的各个方面，包括允许 nginx 用于连接处理的方法。最后，它创建一个 `Makefile` 。
该 `configure` 命令支持以下参数：

- `--help`

  打印帮助消息。

- `--prefix=path`

  This same directory will also be used for all relative paths set by `configure` (except for paths to libraries sources) and in the `nginx.conf` configuration file. It is set to the `/usr/local/nginx` directory by default.  定义将保存服务文件的目录。同一目录也将用于由 `configure` 配置文件设置的所有相对路径（库源的路径除外）。 `nginx.conf` 默认情况下，它设置为目录 `/usr/local/nginx` 。

- `--sbin-path=path`

  sets the name of an nginx executable file. This name is used only during installation. By default the file is named `*prefix*/sbin/nginx`.  设置 nginx 可执行文件的名称。此名称仅在安装期间使用。默认情况下，该文件名为 `*prefix*/sbin/nginx` 。

- `--modules-path=*path*`

  defines a directory where nginx dynamic modules will be installed. By default the `*prefix*/modules` directory is used.  定义将安装 nginx 动态模块的目录。默认情况下，使用该 `*prefix*/modules` 目录。

- `--conf-path=*path*`

  sets the name of an `nginx.conf` configuration file. If needs be, nginx can always be started with a different configuration file, by specifying it in the command-line parameter `-c *file*`. By default the file is named `*prefix*/conf/nginx.conf`.  设置 `nginx.conf` 配置文件的名称。如果需要，nginx 始终可以使用不同的配置文件启动，方法是在命令行参数中指定它 `-c *file*` 。默认情况下，该文件名为 `*prefix*/conf/nginx.conf` 。

- `--error-log-path=*path*`

  sets the name of the primary error, warnings, and diagnostic file. After installation, the file name can always be changed in the `nginx.conf` configuration file using the [error_log](http://nginx.org/en/docs/ngx_core_module.html#error_log) directive. By default the file is named `*prefix*/logs/error.log`.  设置主要错误、警告和诊断文件的名称。安装后，始终可以使用 error_log 指令在 `nginx.conf` 配置文件中更改文件名。默认情况下，该文件名为 `*prefix*/logs/error.log` 。

- `--pid-path=*path*`

  sets the name of an `nginx.pid` file that will store the process ID of the main process. After installation, the file name can always be changed in the `nginx.conf` configuration file using the [pid](http://nginx.org/en/docs/ngx_core_module.html#pid) directive. By default the file is named `*prefix*/logs/nginx.pid`.  设置将存储主进程的进程 ID 的文件的名称 `nginx.pid` 。安装后，始终可以使用 pid 指令在 `nginx.conf` 配置文件中更改文件名。默认情况下，该文件名为 `*prefix*/logs/nginx.pid` 。

- `--lock-path=*path*`

  sets a prefix for the names of lock files. After installation, the value can always be changed in the `nginx.conf` configuration file using the [lock_file](http://nginx.org/en/docs/ngx_core_module.html#lock_file) directive. By default the value is `*prefix*/logs/nginx.lock`.  为锁定文件的名称设置前缀。安装后，始终可以使用 lock_file 指令在 `nginx.conf` 配置文件中更改该值。默认情况下，该值为 `*prefix*/logs/nginx.lock` 。

- `--user=name`

  设置非特权用户的名称，其凭据将由 worker 进程使用。安装后，始终可以使用 user 指令在 `nginx.conf` 配置文件中更改名称。默认用户名为 nobody 。

- `--group=*name*`

  sets the name of a group whose credentials will be used by worker processes. After installation, the name can always be changed in the `nginx.conf` configuration file using the [user](http://nginx.org/en/docs/ngx_core_module.html#user) directive. By default, a group name is set to the name of an unprivileged user.  设置工作进程将使用其凭据的组的名称。安装后，始终可以使用 user 指令在 `nginx.conf` 配置文件中更改名称。默认情况下，组名称设置为非特权用户的名称。

- `--build=name`

  sets an optional nginx build name.  设置可选的 nginx 构建名称。

- `--builddir=*path*`

  sets a build directory.  设置构建目录。

- `--with-select_module`  `--without-select_module`

  enables or disables building a module that allows the server to work with the `select()` method. This module is built automatically if the platform does not appear to support more appropriate methods such as kqueue, epoll, or /dev/poll.  启用或禁用生成允许服务器使用该 `select()` 方法的模块。如果平台似乎不支持更合适的方法，例如 kqueue、epor 或 /dev/poll，则会自动构建此模块。

- `--with-poll_module`  `--without-poll_module`

  enables or disables building a module that allows the server to work with the `poll()` method. This module is built automatically if the platform does not appear to support more appropriate methods such as kqueue, epoll, or /dev/poll.  启用或禁用生成允许服务器使用该 `poll()` 方法的模块。如果平台似乎不支持更合适的方法，例如 kqueue、epor 或 /dev/poll，则会自动构建此模块。

- `--with-threads`

  允许使用线程池。

- `--with-file-aio`

  enables the use of [asynchronous file I/O](http://nginx.org/en/docs/http/ngx_http_core_module.html#aio) (AIO) on FreeBSD and Linux.  支持在 FreeBSD 和 Linux 上使用异步文件 I/O （AIO）。

- `--with-http_ssl_module`

  enables building a module that adds the [HTTPS protocol support](http://nginx.org/en/docs/http/ngx_http_ssl_module.html) to an HTTP server. 允许构建一个模块，该模块将 HTTPS 协议支持添加到 HTTP 服务器。默认情况下不构建此模块。构建和运行此模块需要 OpenSSL 库。

- `--with-http_v2_module`

  enables building a module that provides support for [HTTP/2](http://nginx.org/en/docs/http/ngx_http_v2_module.html).启用构建支持 HTTP/2 的模块。默认情况下不构建此模块。

- `--with-http_v3_module`

  enables building a module that provides support for [HTTP/3](http://nginx.org/en/docs/http/ngx_http_v3_module.html). This module is not built by default. An SSL library that provides HTTP/3 support is recommended to build and run this module, such as [BoringSSL](https://boringssl.googlesource.com/boringssl), [LibreSSL](https://www.libressl.org), or [QuicTLS](https://github.com/quictls/openssl). Otherwise, if using the OpenSSL library, OpenSSL compatibility layer will be used that does not support QUIC [early data](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_early_data).  用于构建支持 HTTP/3 的模块。默认情况下不构建此模块。建议使用提供 HTTP/3 支持的 SSL 库来构建和运行此模块，例如  BoringSSL、LibreSSL 或 QuicTLS。否则，如果使用 OpenSSL 库，将使用不支持 QUIC 早期数据的 OpenSSL 兼容层。

- `--with-http_realip_module`

  enables building the [ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html) module that changes the client address to the address sent in the specified header field. 启用生成 ngx_http_realip_module 模块，该模块将客户端地址更改为在指定标头字段中发送的地址。默认情况下不构建此模块。

- `--with-http_addition_module`

  enables building the [ngx_http_addition_module](http://nginx.org/en/docs/http/ngx_http_addition_module.html) module that adds text before and after a response. 启用生成在响应之前和之后添加文本的 ngx_http_addition_module 模块。默认情况下不构建此模块。

- `--with-http_xslt_module`  `--with-http_xslt_module=dynamic`

  enables building the [ngx_http_xslt_module](http://nginx.org/en/docs/http/ngx_http_xslt_module.html) module that transforms XML responses using one or more XSLT stylesheets. The [libxml2](http://xmlsoft.org) and [libxslt](http://xmlsoft.org/XSLT/) libraries are required to build and run this module.  启用生成ngx_http_xslt_module模块，该模块使用一个或多个 XSLT 样式表转换 XML 响应。默认情况下不构建此模块。需要 libxml2 和 libxslt 库来构建和运行此模块。

- `--with-http_image_filter_module`  `--with-http_image_filter_module=dynamic`

  enables building the [ngx_http_image_filter_module](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html) module that transforms images in JPEG, GIF, PNG, and WebP formats.支持构建 ngx_http_image_filter_module 模块，该模块可转换 JPEG、GIF、PNG 和 WebP 格式的图像。默认情况下不构建此模块。

- `--with-http_geoip_module`  `--with-http_geoip_module=dynamic`

  enables building the [ngx_http_geoip_module](http://nginx.org/en/docs/http/ngx_http_geoip_module.html) module that creates variables depending on the client IP address and the precompiled [MaxMind](http://www.maxmind.com) databases.支持构建 ngx_http_geoip_module 模块，该模块根据客户端 IP 地址和预编译的 MaxMind 数据库创建变量。默认情况下不构建此模块。

- `--with-http_sub_module`

  enables building the [ngx_http_sub_module](http://nginx.org/en/docs/http/ngx_http_sub_module.html) module that modifies a response by replacing one specified string by another. 启用生成 ngx_http_sub_module 模块，该模块通过将一个指定的字符串替换为另一个指定的字符串来修改响应。默认情况下不构建此模块。

- `--with-http_dav_module`

  enables building the [ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html) module that provides file management automation via the WebDAV protocol.支持构建通过 WebDAV 协议提供文件管理自动化的 ngx_http_dav_module 模块。默认情况下不构建此模块。

- `--with-http_flv_module`

  enables building the [ngx_http_flv_module](http://nginx.org/en/docs/http/ngx_http_flv_module.html) module that provides pseudo-streaming server-side support for Flash Video (FLV) files.启用构建 ngx_http_flv_module 模块，该模块为 Flash 视频 （FLV） 文件提供伪流式处理服务器端支持。默认情况下不构建此模块。

- `--with-http_mp4_module`

  enables building the [ngx_http_mp4_module](http://nginx.org/en/docs/http/ngx_http_mp4_module.html) module that provides pseudo-streaming server-side support for MP4 files.启用构建 ngx_http_mp4_module 模块，该模块为 MP4 文件提供伪流式处理服务器端支持。默认情况下不构建此模块。

- `--with-http_gunzip_module`

  enables building the [ngx_http_gunzip_module](http://nginx.org/en/docs/http/ngx_http_gunzip_module.html) module that decompresses responses with “`Content-Encoding: gzip`” for clients that do not support “gzip” encoding method.允许为不支持“gzip”编码方法的客户端构建使用 “ `Content-Encoding: gzip` ” 解压缩响应的 ngx_http_gunzip_module 模块。默认情况下不构建此模块。

- `--with-http_gzip_static_module`

  enables building the [ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) module that enables sending precompressed files with the “`.gz`” filename extension instead of regular files.启用构建 ngx_http_gzip_static_module 模块，该模块允许发送带有 “ `.gz` ” 文件扩展名的预压缩文件，而不是常规文件。默认情况下不构建此模块。

- `--with-http_auth_request_module`

  enables building the [ngx_http_auth_request_module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) module that implements client authorization based on the result of a subrequest.能够构建基于子请求结果实现客户端授权的 ngx_http_auth_request_module 模块。默认情况下不构建此模块。

- `--with-http_random_index_module`

  enables building the [ngx_http_random_index_module](http://nginx.org/en/docs/http/ngx_http_random_index_module.html) module that processes requests ending with the slash character (‘`/`’) and picks a random file in a directory to serve as an index file.能够生成 ngx_http_random_index_module 模块，该模块处理以斜杠字符 （' ' `/` ） 结尾的请求，并在目录中选取一个随机文件作为索引文件。默认情况下不构建此模块。

- `--with-http_secure_link_module`

  enables building the [ngx_http_secure_link_module](http://nginx.org/en/docs/http/ngx_http_secure_link_module.html) module.启用构建ngx_http_secure_link_module模块。默认情况下不构建此模块。

- `--with-http_degradation_module`

  enables building the `ngx_http_degradation_module` module.启用构建 `ngx_http_degradation_module` 模块。默认情况下不构建此模块。

- `--with-http_slice_module`

  enables building the [ngx_http_slice_module](http://nginx.org/en/docs/http/ngx_http_slice_module.html) module that splits a request into subrequests, each returning a certain range of response. The module provides more effective caching of big responses.支持构建 ngx_http_slice_module 模块，该模块将请求拆分为子请求，每个子请求返回特定范围的响应。该模块提供了更有效的大响应缓存。默认情况下不构建此模块。

- `--with-http_stub_status_module`

  enables building the [ngx_http_stub_status_module](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html) module that provides access to basic status information.启用构建 ngx_http_stub_status_module 模块，该模块提供对基本状态信息的访问。默认情况下不构建此模块。

- `--without-http_charset_module`

  disables building the [ngx_http_charset_module](http://nginx.org/en/docs/http/ngx_http_charset_module.html) module that adds the specified charset to the “Content-Type” response header field and can additionally convert data from one charset to another.  禁止生成将指定字符集添加到“Content-Type”响应标头字段的 ngx_http_charset_module 模块，并且还可以将数据从一个字符集转换为另一个字符集。

- `--without-http_gzip_module`

  disables building a module that [compresses responses](http://nginx.org/en/docs/http/ngx_http_gzip_module.html) of an HTTP server.禁止生成压缩 HTTP 服务器响应的模块。需要 zlib 库来构建和运行此模块。

- `--without-http_ssi_module`

  disables building the [ngx_http_ssi_module](http://nginx.org/en/docs/http/ngx_http_ssi_module.html) module that processes SSI (Server Side Includes) commands in responses passing through it.  禁止生成 ngx_http_ssi_module 模块，该模块在通过它的响应中处理 SSI（服务器端包含）命令。

- `--without-http_userid_module`

  disables building the [ngx_http_userid_module](http://nginx.org/en/docs/http/ngx_http_userid_module.html) module that sets cookies suitable for client identification.  禁用构建 ngx_http_userid_module 模块，该模块设置适合客户端标识的 Cookie。

- `--without-http_access_module`

  disables building the [ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html) module that allows limiting access to certain client addresses.  禁用构建允许限制对某些客户端地址的访问的 ngx_http_access_module 模块。

- `--without-http_auth_basic_module`

  disables building the [ngx_http_auth_basic_module](http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) module that allows limiting access to resources by validating the user name and password using the “HTTP Basic Authentication” protocol.  禁用构建 ngx_http_auth_basic_module 模块，该模块允许通过使用“HTTP 基本身份验证”协议验证用户名和密码来限制对资源的访问。

- `--without-http_mirror_module`

  disables building the [ngx_http_mirror_module](http://nginx.org/en/docs/http/ngx_http_mirror_module.html) module that implements mirroring of an original request by creating background mirror subrequests.  禁止构建 ngx_http_mirror_module 模块，该模块通过创建后台镜像子请求来实现原始请求的镜像。

- `--without-http_autoindex_module`

  disables building the [ngx_http_autoindex_module](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html) module that processes requests ending with the slash character (‘`/`’) and produces a directory listing in case the [ngx_http_index_module](http://nginx.org/en/docs/http/ngx_http_index_module.html) module cannot find an index file.  禁止生成 ngx_http_autoindex_module 模块，该模块处理以斜杠字符 （' ' `/` ） 结尾的请求，并在 ngx_http_index_module 模块找不到索引文件时生成目录列表。

- `--without-http_geo_module`

  disables building the [ngx_http_geo_module](http://nginx.org/en/docs/http/ngx_http_geo_module.html) module that creates variables with values depending on the client IP address.  禁止生成 ngx_http_geo_module 模块，该模块创建具有基于客户端 IP 地址的值的变量。

- `--without-http_map_module`

  disables building the [ngx_http_map_module](http://nginx.org/en/docs/http/ngx_http_map_module.html) module that creates variables with values depending on values of other variables.  禁用生成 ngx_http_map_module 模块，该模块创建具有依赖于其他变量值的值的变量。

- `--without-http_split_clients_module`

  disables building the [ngx_http_split_clients_module](http://nginx.org/en/docs/http/ngx_http_split_clients_module.html) module that creates variables for A/B testing.  禁用生成用于 A/B 测试的变量的 ngx_http_split_clients_module 模块。

- `--without-http_referer_module`

  disables building the [ngx_http_referer_module](http://nginx.org/en/docs/http/ngx_http_referer_module.html) module that can block access to a site for requests with invalid values in the “Referer” header field.  禁止生成 ngx_http_referer_module 模块，该模块可以阻止对“Referer”标头字段中值无效的请求访问站点。

- `--without-http_rewrite_module`

  disables building a module that allows an HTTP server to [redirect requests and change URI of requests](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html). The PCRE library is required to build and run this module.  禁止生成允许 HTTP 服务器重定向请求和更改请求 URI 的模块。生成和运行此模块需要 PCRE 库。

- `--without-http_proxy_module`

  disables building an HTTP server [proxying module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html).  禁用构建 HTTP 服务器代理模块。

- `--without-http_fastcgi_module`

  disables building the [ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) module that passes requests to a FastCGI server.  禁止生成将请求传递到 FastCGI 服务器的 ngx_http_fastcgi_module 模块。

- `--without-http_uwsgi_module`

  disables building the [ngx_http_uwsgi_module](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) module that passes requests to a uwsgi server.  禁用构建将请求传递到 UWSGi 服务器的 ngx_http_uwsgi_module 模块。

- `--without-http_scgi_module`

  disables building the [ngx_http_scgi_module](http://nginx.org/en/docs/http/ngx_http_scgi_module.html) module that passes requests to an SCGI server.  禁止构建将请求传递到 SCGI 服务器的 ngx_http_scgi_module 模块。

- `--without-http_grpc_module`

  disables building the [ngx_http_grpc_module](http://nginx.org/en/docs/http/ngx_http_grpc_module.html) module that passes requests to a gRPC server.  禁用生成将请求传递到 gRPC 服务器的 ngx_http_grpc_module 模块。

- `--without-http_memcached_module`

  disables building the [ngx_http_memcached_module](http://nginx.org/en/docs/http/ngx_http_memcached_module.html) module that obtains responses from a memcached server.  禁止构建从 memcached 服务器获取响应的 ngx_http_memcached_module 模块。

- `--without-http_limit_conn_module`

  disables building the [ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) module that limits the number of connections per key, for example, the number of connections from a single IP address.  禁用生成限制每个密钥的连接数（例如，来自单个 IP 地址的连接数）的 ngx_http_limit_conn_module 模块。

- `--without-http_limit_req_module`

  disables building the [ngx_http_limit_req_module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html) module that limits the request processing rate per key, for example, the processing rate of requests coming from a single IP address.  禁止生成限制每个密钥的请求处理速率的 ngx_http_limit_req_module 模块，例如，来自单个 IP 地址的请求的处理速率。

- `--without-http_empty_gif_module`

  disables building a module that [emits single-pixel transparent GIF](http://nginx.org/en/docs/http/ngx_http_empty_gif_module.html).  禁止构建发出单像素透明 GIF 的模块。

- `--without-http_browser_module`

  disables building the [ngx_http_browser_module](http://nginx.org/en/docs/http/ngx_http_browser_module.html) module that creates variables whose values depend on the value of the “User-Agent” request header field.  禁止生成 ngx_http_browser_module 模块，该模块创建变量，其值取决于“User-Agent”请求标头字段的值。

- `--without-http_upstream_hash_module`

  disables building a module that implements the [hash](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash) load balancing method.  禁止生成实现哈希负载平衡方法的模块。

- `--without-http_upstream_ip_hash_module`

  disables building a module that implements the [ip_hash](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash) load balancing method.  禁止生成实现ip_hash负载平衡方法的模块。

- `--without-http_upstream_least_conn_module`

  disables building a module that implements the [least_conn](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn) load balancing method.  禁止生成实现least_conn负载平衡方法的模块。

- `--without-http_upstream_random_module`

  disables building a module that implements the [random](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#random) load balancing method.  禁止构建实现随机负载均衡方法的模块。

- `--without-http_upstream_keepalive_module`

  disables building a module that provides [caching of connections](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) to upstream servers.  禁止构建提供与上游服务器连接缓存的模块。

- `--without-http_upstream_zone_module`

  disables building a module that makes it possible to store run-time state of an upstream group in a shared memory [zone](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone).  禁止生成一个模块，该模块可以在共享内存区域中存储上游组的运行时状态。

- `--with-http_perl_module`  `--with-http_perl_module=dynamic`

  enables building the [embedded Perl module](http://nginx.org/en/docs/http/ngx_http_perl_module.html). This module is not built by default.  支持构建嵌入式 Perl 模块。默认情况下不构建此模块。

- `--with-perl_modules_path=*path*`

  defines a directory that will keep Perl modules.  定义一个将保存 Perl 模块的目录。

- `--with-perl=*path*`

  sets the name of the Perl binary.  设置 Perl 二进制文件的名称。

- `--http-log-path=*path*`

  sets the name of the primary request log file of the HTTP server. After installation, the file name can always be changed in the `nginx.conf` configuration file using the [access_log](http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) directive. By default the file is named `*prefix*/logs/access.log`.  设置 HTTP 服务器的主请求日志文件的名称。安装后，始终可以使用 access_log 指令在 `nginx.conf` 配置文件中更改文件名。默认情况下，该文件名为 `*prefix*/logs/access.log` 。

- `--http-client-body-temp-path=*path*`

  defines a directory for storing temporary files that hold client request bodies. After installation, the directory can always be changed in the `nginx.conf` configuration file using the [client_body_temp_path](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_temp_path) directive. By default the directory is named `*prefix*/client_body_temp`.  定义一个目录，用于存储保存客户端请求正文的临时文件。安装后，始终可以使用 client_body_temp_path 指令在 `nginx.conf` 配置文件中更改目录。默认情况下，该目录名为 `*prefix*/client_body_temp` 。

- `--http-proxy-temp-path=*path*`

  defines a directory for storing temporary files with data received from proxied servers. After installation, the directory can always be changed in the `nginx.conf` configuration file using the [proxy_temp_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_temp_path) directive. By default the directory is named `*prefix*/proxy_temp`.  定义一个目录，用于存储临时文件以及从代理服务器接收的数据。安装后，始终可以使用 proxy_temp_path 指令在 `nginx.conf` 配置文件中更改目录。默认情况下，该目录名为 `*prefix*/proxy_temp` 。

- `--http-fastcgi-temp-path=*path*`

  defines a directory for storing temporary files with data received from FastCGI servers. After installation, the directory can always be changed in the `nginx.conf` configuration file using the [fastcgi_temp_path](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_temp_path) directive. By default the directory is named `*prefix*/fastcgi_temp`.  定义一个目录，用于存储包含从 FastCGI 服务器接收的数据的临时文件。安装后，始终可以使用 fastcgi_temp_path 指令在 `nginx.conf` 配置文件中更改目录。默认情况下，该目录名为 `*prefix*/fastcgi_temp` 。

- `--http-uwsgi-temp-path=*path*`

  defines a directory for storing temporary files with data received from uwsgi servers. After installation, the directory can always be changed in the `nginx.conf` configuration file using the [uwsgi_temp_path](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_temp_path) directive. By default the directory is named `*prefix*/uwsgi_temp`.  定义一个目录，用于存储包含从 UWSGi 服务器接收的数据的临时文件。安装后，始终可以使用 uwsgi_temp_path 指令在 `nginx.conf` 配置文件中更改目录。默认情况下，该目录名为 `*prefix*/uwsgi_temp` 。

- `--http-scgi-temp-path=*path*`

  defines a directory for storing temporary files with data received from SCGI servers. After installation, the directory can always be changed in the `nginx.conf` configuration file using the [scgi_temp_path](http://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_temp_path) directive. By default the directory is named `*prefix*/scgi_temp`.  定义一个目录，用于存储包含从 SCGI 服务器接收的数据的临时文件。安装后，始终可以使用 scgi_temp_path 指令在 `nginx.conf` 配置文件中更改目录。默认情况下，该目录名为 `*prefix*/scgi_temp` 。

- `--without-http`

  禁用 HTTP 服务器。

- `--without-http-cache`

  disables HTTP cache. 禁用 HTTP 缓存。

- `--with-mail`  `--with-mail=dynamic`

  enables POP3/IMAP4/SMTP [mail proxy](http://nginx.org/en/docs/mail/ngx_mail_core_module.html) server.  启用 POP3/IMAP4/SMTP 邮件代理服务器。

- `--with-mail_ssl_module`

  enables building a module that adds the [SSL/TLS protocol support](http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html) to the mail proxy server. This module is not built by default. The OpenSSL library is required to build and run this module.  允许构建一个模块，将 SSL/TLS 协议支持添加到邮件代理服务器。默认情况下不构建此模块。构建和运行此模块需要 OpenSSL 库。

- `--without-mail_pop3_module`

  disables the [POP3](http://nginx.org/en/docs/mail/ngx_mail_pop3_module.html) protocol in mail proxy server.  禁用邮件代理服务器中的 POP3 协议。

- `--without-mail_imap_module`

  disables the [IMAP](http://nginx.org/en/docs/mail/ngx_mail_imap_module.html) protocol in mail proxy server.  禁用邮件代理服务器中的 IMAP 协议。

- `--without-mail_smtp_module`

  disables the [SMTP](http://nginx.org/en/docs/mail/ngx_mail_smtp_module.html) protocol in mail proxy server.  禁用邮件代理服务器中的 SMTP 协议。

- `--with-stream`  `--with-stream=dynamic`

  enables building the [stream module](http://nginx.org/en/docs/stream/ngx_stream_core_module.html) for generic TCP/UDP proxying and load balancing. This module is not built by default.  支持为通用 TCP/UDP 代理和负载平衡构建流模块。默认情况下不构建此模块。

- `--with-stream_ssl_module`

  enables building a module that adds the [SSL/TLS protocol support](http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) to the stream module. This module is not built by default. The OpenSSL library is required to build and run this module.  允许构建一个模块，该模块将 SSL/TLS 协议支持添加到流模块。默认情况下不构建此模块。构建和运行此模块需要 OpenSSL 库。

- `--with-stream_realip_module`

  enables building the [ngx_stream_realip_module](http://nginx.org/en/docs/stream/ngx_stream_realip_module.html) module that changes the client address to the address sent in the PROXY protocol header. This module is not built by default.  启用生成 ngx_stream_realip_module 模块，该模块将客户端地址更改为 PROXY 协议标头中发送的地址。默认情况下不构建此模块。

- `--with-stream_geoip_module`  `--with-stream_geoip_module=dynamic`

  enables building the [ngx_stream_geoip_module](http://nginx.org/en/docs/stream/ngx_stream_geoip_module.html) module that creates variables depending on the client IP address and the precompiled [MaxMind](http://www.maxmind.com) databases. This module is not built by default.  启用构建 ngx_stream_geoip_module 模块，该模块根据客户端 IP 地址和预编译的 MaxMind 数据库创建变量。默认情况下不构建此模块。

- `--with-stream_ssl_preread_module`

  enables building the [ngx_stream_ssl_preread_module](http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html) module that allows extracting information from the [ClientHello](https://datatracker.ietf.org/doc/html/rfc5246#section-7.4.1.2) message without terminating SSL/TLS. This module is not built by default.  启用构建 ngx_stream_ssl_preread_module 模块，该模块允许在不终止 SSL/TLS 的情况下从 ClientHello 消息中提取信息。默认情况下不构建此模块。

- `--without-stream_limit_conn_module`

  disables building the [ngx_stream_limit_conn_module](http://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html) module that limits the number of connections per key, for example, the number of connections from a single IP address.  禁止生成限制每个密钥的连接数（例如，来自单个 IP 地址的连接数）的 ngx_stream_limit_conn_module 模块。

- `--without-stream_access_module`

  disables building the [ngx_stream_access_module](http://nginx.org/en/docs/stream/ngx_stream_access_module.html) module that allows limiting access to certain client addresses.  禁用生成允许限制对某些客户端地址的访问的 ngx_stream_access_module 模块。

- `--without-stream_geo_module`

  disables building the [ngx_stream_geo_module](http://nginx.org/en/docs/stream/ngx_stream_geo_module.html) module that creates variables with values depending on the client IP address.  禁止生成 ngx_stream_geo_module 模块，该模块创建具有基于客户端 IP 地址的值的变量。

- `--without-stream_map_module`

  disables building the [ngx_stream_map_module](http://nginx.org/en/docs/stream/ngx_stream_map_module.html) module that creates variables with values depending on values of other variables.  禁止生成 ngx_stream_map_module 模块，该模块创建具有取决于其他变量值的值的变量。

- `--without-stream_split_clients_module`

  disables building the [ngx_stream_split_clients_module](http://nginx.org/en/docs/stream/ngx_stream_split_clients_module.html) module that creates variables for A/B testing.  禁用生成为 A/B 测试创建变量的 ngx_stream_split_clients_module 模块。

- `--without-stream_return_module`

  disables building the [ngx_stream_return_module](http://nginx.org/en/docs/stream/ngx_stream_return_module.html) module that sends some specified value to the client and then closes the connection.  禁用生成ngx_stream_return_module模块，该模块将某些指定值发送到客户端，然后关闭连接。

- `--without-stream_set_module`

  disables building the [ngx_stream_set_module](http://nginx.org/en/docs/stream/ngx_stream_set_module.html) module that sets a value for a variable.  禁止生成为变量设置值的 ngx_stream_set_module 模块。

- `--without-stream_upstream_hash_module`

  disables building a module that implements the [hash](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#hash) load balancing method.  禁止生成实现哈希负载平衡方法的模块。

- `--without-stream_upstream_least_conn_module`

  disables building a module that implements the [least_conn](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_conn) load balancing method.  禁止生成实现least_conn负载平衡方法的模块。

- `--without-stream_upstream_random_module`

  disables building a module that implements the [random](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#random) load balancing method.  禁止构建实现随机负载均衡方法的模块。

- `--without-stream_upstream_zone_module`

  disables building a module that makes it possible to store run-time state of an upstream group in a shared memory [zone](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone).  禁止生成一个模块，该模块可以在共享内存区域中存储上游组的运行时状态。

- `--with-google_perftools_module`

  enables building the [ngx_google_perftools_module](http://nginx.org/en/docs/ngx_google_perftools_module.html) module that enables profiling of nginx worker processes using [Google Performance Tools](https://github.com/gperftools/gperftools). The module is intended for nginx developers支持构建 ngx_google_perftools_module 模块，该模块允许使用 Google Performance Tools 对 nginx 工作进程进行分析。该模块面向 nginx 开发人员，默认情况下不构建。

- `--with-cpp_test_module`

  enables building the `ngx_cpp_test_module` module.  启用构建 `ngx_cpp_test_module` 模块。

- `--add-module=*path*`

  enables an external module.  启用外部模块。

- `--add-dynamic-module=*path*`

  enables an external dynamic module.  启用外部动态模块。

- `--with-compat`

  enables dynamic modules compatibility.  启用动态模块兼容性。

- `--with-cc=*path*`

  sets the name of the C compiler.  设置 C 编译器的名称。

- `--with-cpp=*path*`

  sets the name of the C preprocessor.  设置 C 预处理器的名称。

- `--with-cc-opt=*parameters*`

  sets additional parameters that will be added to the CFLAGS variable. When using the system PCRE library under FreeBSD, `--with-cc-opt="-I /usr/local/include"` should be specified. If the number of files supported by `select()` needs to be increased it can also be specified here such as this: `--with-cc-opt="-D FD_SETSIZE=2048"`.  设置将添加到 CFLAGS 变量的其他参数。在 FreeBSD 下使用系统 PCRE 库时， `--with-cc-opt="-I /usr/local/include"` 应该指定。如果需要增加支持 `select()` 的文件数量，也可以在这里指定，如下所示： `--with-cc-opt="-D FD_SETSIZE=2048"` 。

- `--with-ld-opt=*parameters*`

  sets additional parameters that will be used during linking. When using the system PCRE library under FreeBSD, `--with-ld-opt="-L /usr/local/lib"` should be specified.  设置将在链接期间使用的其他参数。在 FreeBSD 下使用系统 PCRE 库时， `--with-ld-opt="-L /usr/local/lib"` 应该指定。

- `--with-cpu-opt=*cpu*`

  enables building per specified CPU: `pentium`, `pentiumpro`, `pentium3`, `pentium4`, `athlon`, `opteron`, `sparc32`, `sparc64`, `ppc64`.  允许按指定的 CPU 进行构建： `pentium` 、、、、 `opteron` 、 `sparc32` `sparc64` `pentiumpro` `pentium3` `pentium4` `athlon` 。 `ppc64` 

- `--without-pcre`

  disables the usage of the PCRE library.  禁用 PCRE 库的使用。

- `--with-pcre`

  forces the usage of the PCRE library.  强制使用 PCRE 库。

- `--with-pcre=*path*`

  sets the path to the sources of the PCRE library. The library distribution needs to be downloaded from the [PCRE](http://www.pcre.org) site and extracted. The rest is done by nginx’s `./configure` and `make`. The library is required for regular expressions support in the [location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive and for the [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module.  设置 PCRE 库源的路径。需要从 PCRE 站点下载并提取库分发。其余的由 nginx `./configure` 和 `make` .location 指令中的正则表达式支持和 ngx_http_rewrite_module 模块需要该库。

- `--with-pcre-opt=*parameters*`

  sets additional build options for PCRE.  为 PCRE 设置其他生成选项。

- `--with-pcre-jit`

  builds the PCRE library with “just-in-time compilation” support (1.1.12, the [pcre_jit](http://nginx.org/en/docs/ngx_core_module.html#pcre_jit) directive).  构建具有“实时编译”支持的 PCRE 库（1.1.12，pcre_jit指令）。

- `--without-pcre2`

  disables use of the PCRE2 library instead of the original PCRE library (1.21.5).  禁用 PCRE2 库而不是原始 PCRE 库 （1.21.5）。

- `--with-zlib=*path*`

  sets the path to the sources of the zlib library. The library distribution (version 1.1.3 — 1.3) needs to be downloaded from the [zlib](http://zlib.net) site and extracted. The rest is done by nginx’s `./configure` and `make`. The library is required for the [ngx_http_gzip_module](http://nginx.org/en/docs/http/ngx_http_gzip_module.html) module.  设置 zlib 库源的路径。库发行版（版本 1.1.3 — 1.3）需要从 zlib 站点下载并解压缩。其余的由 nginx `./configure` 和 `make` .该库是 ngx_http_gzip_module 模块所必需的。

- `--with-zlib-opt=*parameters*`

  sets additional build options for zlib.  为 zlib 设置其他生成选项。

- `--with-zlib-asm=*cpu*`

  enables the use of the zlib assembler sources optimized for one of the specified CPUs: `pentium`, `pentiumpro`.  允许使用针对指定 CPU 之一优化的 zlib 汇编程序源： `pentium` 、 `pentiumpro` 。

- `--with-libatomic`

  forces the libatomic_ops library usage.  强制使用libatomic_ops库。

- `--with-libatomic=*path*`

  sets the path to the libatomic_ops library sources.  设置libatomic_ops库源的路径。

- `--with-openssl=*path*`

  sets the path to the OpenSSL library sources.  设置 OpenSSL 库源的路径。

- `--with-openssl-opt=*parameters*`

  sets additional build options for OpenSSL.  为 OpenSSL 设置其他构建选项。

- `--with-debug`

  启用调试日志。

### 参数用法示例

所有这些都需要在一行中输入

```bash
./configure
 --sbin-path=/usr/local/nginx/nginx
 --conf-path=/usr/local/nginx/nginx.conf
 --pid-path=/usr/local/nginx/nginx.pid
 --with-http_ssl_module
 --with-pcre=../pcre2-10.39
 --with-zlib=../zlib-1.3
```

配置完成后，使用 `make` 进行编译和安装。

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