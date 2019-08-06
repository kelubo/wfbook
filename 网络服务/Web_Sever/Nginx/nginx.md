# Nginx

## 安装(CentOS 7.6)

CentOS自带的版本较低，使用官方的yum repo安装。

新建nginx.repo文件，内容如下:

```bash
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
```

安装nginx

```bash
yum install nginx
```

配置文件

```bash
/etc/nginx/nginx.conf
/etc/nginx/conf.d/
/etc/nginx/conf.d/default.conf
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

```bash
user user [group];
#运行 Nginx 服务器的用户(组),如希望所有用户都可以运行，
#1，注释此项；
#2，用户和组设置为 nobody。

worker_processes  number | auto;
#默认为 1

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#error_log  file | stderr [debug | info | notice | warn | error | crit | alert | emerg];

#pid        logs/nginx.pid;

use method;
#处理网络消息的事件驱动模型，可选 select,poll,kqueue,epoll,rtsig,/dev/poll,eventport

events {
    worker_connections  1024;
    #不仅仅包含和前端用户建立的连接数，而是包含所有可能的连接数。
    accept_mutex	on | off;
    #对多个进程接收连接进行序列化，防止多个进程对连接的争抢。
    multi_accept	on | off;
    #是否允许每个 work process 同时接收多个网络连接，默认为 off
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  off;
    #取消记录服务日志的功能。
    #access_log  logs/access.log  main;

    sendfile        on;
    #sendfile_max_chunk	size;
    #大于0，每个 worker process 每次调用 sendfile() 传输的数据量最大不能超过这个值。
    #默认值为0，不限制。
    
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    #keepalive_timeout	timeout	[header_timeout];

	#keepalive_requests		number;
	#默认值为100，限制用户通过某一连接向服务器发送请求的此次。

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
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
