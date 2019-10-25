# Nginx

一款自由的、开源的、高性能的HTTP服务器和反向代理服务器；同时也是一个IMAP、POP3、SMTP代理服务器。

源码：https://trac.nginx.org/nginx/browser

官网：http://www.nginx.org/

## 常用功能

1、Http代理，反向代理：作为web服务器最常用的功能之一，尤其是反向代理。

![img](..\..\..\Image\n\nginx代理.jpg)

2、负载均衡

Nginx提供的负载均衡策略有2种：内置策略和扩展策略。内置策略为轮询，加权轮询，Ip hash。

![img](..\..\..\Image\n\nginx负载均衡.jpg)

Ip hash算法，对客户端请求的ip进行hash操作，然后根据hash结果将同一个客户端ip的请求分发给同一台服务器进行处理，可以解决session不共享的问题。 ![img](..\..\..\Image\n\nginx负载均衡1.jpg)

3、web缓存

Nginx可以对不同的文件做不同的缓存处理，配置灵活，并且支持FastCGI_Cache，主要用于对FastCGI的动态程序进行缓存。配合着第三方的ngx_cache_purge，对制定的URL缓存内容可以的进行增删管理。

## 安装

见LNMP内容

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

### 信号控制

| 信号      | 作用                                                         |
| --------- | ------------------------------------------------------------ |
| TERM或INT | 快速停止服务。                                               |
| QUIT      | 平缓停止服务。                                               |
| HUP       | 使用新的配置文件启动进程，之后平缓停止原有进程，“平滑重启”。 |
| USR1      | 重新打开日志文件，常用于日志切割。                           |
| USR2      | 使用新版本Nginx启动服务，之后平缓停止原有进程，“平滑升级”。  |
| WINCH     | 平缓停止worker process，用于服务器平滑升级。                 |

```bash
kill -SIGNAL PID
kill -SIGNAL `filepath`  #filepath为nginx.pid的路径
kill -SIGNAL `cat filepath`  #filepath为nginx.pid的路径
# 上述两条需要确认哪一条是正确的。
```

### 启动

```bash
# ./sbin/nginx
```

```bash
nginx [-?hvVtq] [-s signal] [-c filename] [-p prefix] [-g directives]

-?,-h			:显示帮助信息
-v				：打印版本号并退出
-V				：打印版本号和配置并退出
-t				：测试配置正确性并退出
-q				：测试配置时只显示错误
-s signal		：向主进程发送信号，stop,quit,reopen,reload
-p prefix		：指定服务器路径
-c filename		：指定配置文件路径，替代缺省配置文件。
-g directives	：指定附加配置文件路径
```

### 停止

```bash
nginx -g TERM | INT | QUIT
# TERM，INT	快速停止
# QUIT		 平缓停止

kill TERM | INT | QUIT `/nginx/logs/nginx.pid`

kill -9 | SIGKILL `/nginx/logs/nginx.pid`
# 不建议
```

### 重启

```bash
nginx -g HUP [-c newConfFile]
kill HUP `/nginx/logs/nginx.pid`
```

### 升级

## 配置符号

**容量符号缩写**

| k,K  | 千字节 |
| ---- | ------ |
| m,M  | 兆字节 |

例如, "8k", "1m" 代表字节数计量.  

**时间符号缩写**

| ms   | 毫秒         |
| ---- | ------------ |
| s    | 秒           |
| m    | 分钟         |
| h    | 小时         |
| d    | 日           |
| w    | 周           |
| M    | 一个月, 30天 |
| y    | 年, 365 天   |

例如, "1h 30m", "1y 6M". 代表 "1小时 30分", "1年零6个月". 

### 配置文件

**nginx.conf**

1、全局块：配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。
2、events块：配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。

3、http块：可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。

4、server块：配置虚拟主机的相关参数，一个http中可以有多个server。

5、location块：配置请求的路由，以及各种页面的处理情况。

```bash
user user [group];
# 运行 Nginx 服务器的用户(组),如希望所有用户都可以运行，两种方法：
# 1，注释此项；
# 2，用户和组设置为 nobody。

worker_processes  number | auto;
# 默认为 1。worker_processes最多开启8个，8个以上，性能不会再提升了，而且稳定性变得更低。
worker_cpu_affinity auto;
# 利用多核cpu的配置。默认不开启。
# 例如：2核cpu，开启2个进程
#  worker_processes     2;
#  worker_cpu_affinity 01 10;
# 解释：01表示启用第一个CPU内核，10表示启用第二个CPU内核。2核是01，四核是0001，8核是00000001，有多少个核，就有几位数，1表示该内核开启，0表示该内核关闭。

error_log  logs/error.log  cirt;
#error_log  file | stderr [debug | info | notice | warn | error | crit | alert | emerg];

pid        logs/nginx.pid;

worker_rlimit_nofile 51200;
# Specifies the value for maximum file descriptors that can be opened by this process.

events {
	use epoll;
    # 处理网络消息的事件驱动模型，可选
    #  select,poll,kqueue,epoll,rtsig,/dev/poll,eventport
    worker_connections  512;
    # 不仅仅包含和前端用户建立的连接数，而是包含所有可能的连接数。
    accept_mutex	on | off;
    # 默认为on,对多个进程接收连接进行序列化，防止多个进程对连接的争抢。
    # 解决“惊群”问题。
    multi_accept	on | off;
    # 是否允许每个 work process 同时接收多个网络连接，默认为 off
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    server_names_hash_bucket_size 128;
    # 服务器名称的hash表大小
    client_header_buffer_size 32k;
    # 指定来自客户端请求头headerbuffer大小
    large_client_header_buffers 4 32k;
    # 指定客户端请求中较大的消息头的缓存最大数量和大小
    client_max_body_size 1m;
    # 允许用户最大上传数据大小

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
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

    sendfile        off;
    # 默认为off
    sendfile_max_chunk	0;
    # 大于0，每个 worker process 每次调用 sendfile() 传输的数据量最大不能超过这个值。
    # 默认值为0，不限制。
    
    #tcp_nopush     on;

    #keepalive_timeout  75;
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
    # 用于设置允许压缩的页面最小字节数，页面字节数从header头的content-length中获取，默认值是0，不管页面多大都进行压缩，建议设置成大于1k的字节数，小于1k可能会越压越大最小压缩文件大小
    gzip_buffers     4 16k;
    # 表示申请4个单位为16k的内存作为压缩结果流缓存，默认值是申请与原始数据大小相同的内存空间来存储gzip压缩结果
    gzip_http_version 1.1;
    # 压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2;
    # 压缩等级
    gzip_types     text/plain application/javascript application/x-javascript text/javascript text/css application/xml application/xml+rss;
    # 压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
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
        #listen		127.0.0.1:80;
        #listen		*:80;
        # listen 80 default_server reuseport;
        # listen [::]:80 default_server ipv6only=on;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }
        
        # 完全匹配     =
        # 大小写敏感   ~
        # 忽略大小写   ~*
        
        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
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

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    include vhost/*.conf;
}
```



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

## PHP


修改 /etc/nginx/conf.d/default.conf 文件：

```bash
location ~ \.php$ {
        root           /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
```

重启nginx：

```bash
nginx -s reload
```

