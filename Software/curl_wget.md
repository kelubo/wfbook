# curl  &  wget

[TOC]

## curl

## wget





curl和wget基础功能有诸多重叠，如下载等。

非要说区别的话，curl由于可自定义各种请求参数所以在模拟web请求方面更擅长；wget由于支持ftp和Recursive所以在下载文件方面更擅长。类比的话curl是浏览器，而wget是迅雷9。

1.下载文件

```
curl -O http:``//man.linuxde.net/text.iso          #O大写，不用O只是打印内容不会下载``wget http:``//www.linuxde.net/text.iso            #不用参数，直接下载文件
```

2.下载文件并重命名

```
curl -o rename.iso http:``//man.linuxde.net/text.iso     #o小写``wget -O rename.zip http:``//www.linuxde.net/text.iso     #O大写
```

3.断点续传

```
curl -O -C - http:``//man.linuxde.net/text.iso        #O大写，C大写``wget -c http:``//www.linuxde.net/text.iso          #c小写
```

4.限速下载

```
curl --limit-rate 50k -O http:``//man.linuxde.net/text.iso``wget --limit-rate=50k http:``//www.linuxde.net/text.iso
```

5.显示响应头部信息

```
curl -I http:``//man.linuxde.net/text.iso``wget --server-response http:``//www.linuxde.net/test.iso
```

6.wget利器--打包下载网站

```
wget --mirror -p --convert-links -P /``var``/www/html http:``//man.linuxde.net/
```

### cURL 与 wget：到底哪一个才更适合你

**wget** 简单直接。这意味着你能享受它超凡的下载速度。wget 是一个独立的程序，无需额外的资源库，更不会做其范畴之外的事情。

**cURL**是一个多功能工具。当然，它可以下载网络内容，但同时它也能做更多别的事情。

## wget

wget支持HTTP，HTTPS和FTP协议，可以使用HTTP代理。所谓的自动下载是指，wget可以在用户退出系统的之后在后台执行。这意味这你可以登录系统，启动一个wget下载任务，然后退出系统，wget将在后台执行直到任务完成

wget 可以跟踪HTML页面上的链接依次下载来创建远程服务器的本地版本，完全重建原始站点的目录结构。这又常被称作”递归下载”。

wget 非常稳定，它在带宽很窄的情况下和不稳定网络中有很强的适应性.如果是由于网络的原因下载失败，wget会不断的尝试，直到整个文件下载完毕。如果是服务器打断下载过程，它会再次联到服务器上从停止的地方继续下载。这对从那些限定了链接时间的服务器上下载大文件非常有用。

## curl

cURL 技术支持库是：libcurl。这就意味着你可以基于 cURL 编写整个程序，允许你基于 libcurl 库中编写图形环境的下载程序，访问它所有的功能。

cURL 宽泛的网络协议支持可能是其最大的卖点。cURL 支持访问 HTTP 和 HTTPS 协议，能够处理 FTP 传输。它支持 LDAP 协议，甚至支持 Samba 分享。实际上，你还可以用 cURL 收发邮件。

cURL 也有一些简洁的安全特性。cURL 支持安装许多 SSL/TLS 库，也支持通过网络代理访问，包括 SOCKS。这意味着，你可以越过 Tor 来使用cURL。

cURL 同样支持让数据发送变得更容易的 gzip 压缩技术。

`curl --help`查看帮助

**curl 的简单方法**
 `curl -X METHOD -H HEADER -i`

**HTTP动词**
 curl 默认的 HTTP 动词是 GET，使用 -X 参数可以支持其他动词。
 `$ curl -X POST www.qq.com`
 `$ curl -X DELETE www.qq.com`

**显示响应header信息**
 `$ curl -i www.qq.com`
 -i 参数可以显示 http response 的头信息，连同网页代码一起。
 -I 参数则只显示 http response 的头信息。

**增加头信息**
 `$ curl --header "Content-Type:application/json" http://example.com`

**支持重定向 Follow redirects**
 -L 参数，curl 就会跳转到新的网址。
 `$ curl -L www.qq.com`

若不加`-L`则会

```
curl www.qq.com
<html>
<head><title>302 Found</title></head>
<body bgcolor="white">
<center><h1>302 Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

**输出到文件, 可以使用 -o 参数：**
 `$ curl -o [文件名] www.qq.com`

### curl常用命令总结

```
 curl命令      访问网站url
 -I/--head   显示响应头信息
 -m/--max-time   访问超时的时间
 -o/--output     记录访问信息到文件
 -s/--silent     沉默模式访问，就是不输出信息
 -w/--write-out      以固定特殊的格式输出，例如：%{http_code}，输出状态码
```

利用curl命令返回值确定网站是否正常
 `curl -I -m 5 -s -w "%{http_code}\n" -o /dev/null www.baidu.com`
 若返回200则表示成功.

进行get请求
 `curl www.ithome.com`

进行post请求

**总结:**
 如果你想快速下载并且没有担心参数标识的需求，那你应该使用轻便有效的 wget。如果你想做一些更复杂的使用，直觉告诉你，你应该选择 cRUL。

cURL 支持你做很多事情。你可以把 cURL 想象成一个精简的命令行网页浏览器。它支持几乎你能想到的所有协议，可以交互访问几乎所有在线内容。唯一和浏览器不同的是，cURL 不会渲染接收到的相应信息。



作者：acc8226
链接：https://www.jianshu.com/p/a7e381c64999/
来源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。

#                  [     Linux操作系统下wget命令详解      ](https://www.cnblogs.com/hls-code/p/16408768.html)             

## 前言

1、wget命令是Linux操作系统中用于从Web下载文件的命令行工具，支持 HTTP、HTTPS及FTP协议下载文件，而且wget还提供了很多选项，例如下载多个文件、后台下载，使用代理等等，使用非常方便。接下来就介绍一下wget的使用方法。

2、wget是在Linux下开发的开放源代码的软件，作者是Hrvoje Niksic，后来被移植到包括Windows在内的各个平台上。它有以下功能和特点：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
（1）支持断点下传功能；这一点，也是网络蚂蚁和FlashGet当年最大的卖点，现在，Wget也可以使用此功能，那些网络不是太好的用户可以放心了；
（2）同时支持FTP和HTTP下载方式；尽管现在大部分软件可以使用HTTP方式下载，但是，有些时候，仍然需要使用FTP方式下载软件；
（3）支持代理服务器；对安全强度很高的系统而言，一般不会将自己的系统直接暴露在互联网上，所以，支持代理是下载软件必须有的功能；
（4）设置方便简单；可能，习惯图形界面的用户已经不是太习惯命令行了，但是，命令行在设置上其实有更多的优点，最少，鼠标可以少点很多次，也不要担心是否错点鼠标；
（5）程序小，完全免费；程序小可以考虑不计，因为现在的硬盘实在太大了；完全免费就不得不考虑了，即使网络上有很多所谓的免费软件，但是，这些软件的广告却不是我们喜欢的；
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

3、wget命令的语法格式：

```
wget [options] [url]
```

4、wget 命令格式：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
wget [参数列表] [目标软件、网页的网址]

-V,–version 显示软件版本号然后退出；
-h,–help 显示软件帮助信息；
-e,–execute=COMMAND 执行一个 “.wgetrc”命令

-o,–output-file=FILE 将软件输出信息保存到文件；
-a,–append-output=FILE 将软件输出信息追加到文件；
-d,–debug 显示输出信息；
-q,–quiet 不显示输出信息；
-i,–input-file=FILE 从文件中取得URL；

-t,–tries=NUMBER 是否下载次数（0表示无穷次）
-O –output-document=FILE 下载文件保存为别的文件名
-nc, –no-clobber 不要覆盖已经存在的文件
-N,–timestamping 只下载比本地新的文件
-T,–timeout=SECONDS 设置超时时间
-Y,–proxy=on/off 关闭代理

-nd,–no-directories 不建立目录
-x,–force-directories 强制建立目录

–http-user=USER 设置HTTP用户
–http-passwd=PASS 设置HTTP密码
–proxy-user=USER 设置代理用户
–proxy-passwd=PASS 设置代理密码

-r,–recursive 下载整个网站、目录（小心使用）
-l,–level=NUMBER 下载层次

-A,–accept=LIST 可以接受的文件类型
-R,–reject=LIST 拒绝接受的文件类型
-D,–domains=LIST 可以接受的域名
–exclude-domains=LIST 拒绝的域名
-L,–relative 下载关联链接
–follow-ftp 只下载FTP链接
-H,–span-hosts 可以下载外面的主机
-I,–include-directories=LIST 允许的目录
-X,–exclude-directories=LIST 拒绝的目录
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

## wget命令的使用

### 1、不带参数命令运行

使用wget下载redis的tar.gz文件：

```
wget https://download.redis.io/releases/redis-6.0.8.tar.gz
```

该命令会**默认下载文件到当前工作目录中**；在文件下载过程中，会显示进度条、文件大小、下载速度等。

### 2、使用 -O 选项以其他名称保存下载的文件

要以其他名称保存下载的文件，使用-O选项，后跟指定名称即可：

```
wget -O redis.tar.gz https://download.redis.io/releases/redis-6.0.8.tar.gz
```

将即将下载的文件 redis-6.0.8.tar.gz 重命名为 redis.tar.gz 。

### 3、使用 -P 选项将文件下载到指定目录

默认情况下，wget将下载的文件保存在当前工作目录中；（不加参数的命令运行时，文件将会存储到当前终端所在的路径）

使用-P选项可以将文件保存到指定目录下，例如，下面将将文件下载到/usr/software目录下：

```
wget -P /usr/software https://download.redis.io/releases/redis-6.0.8.tar.gz
```

### 4、使用 -c 选项断点续传

当我们下载一个大文件时，如果中途网络断开导致没有下载完成，我们就可以使用命令的-c选项恢复下载，让下载从断点续传，无需从头下载。

```
wget -c https://download.redis.io/releases/redis-6.0.8.tar.gz
```

### 5、使用 -b 选项在后台下载

```
wget -b https://download.redis.io/releases/redis-6.0.8.tar.gz
```

默认情况下，下载过程日志重定向到当前目录中的wget-log文件中，要查看下载状态，可以使用tail -f wget-log查看。

### 6、使用 -i 选项下载多个文件

如果想要一次下载多个文件，首先需要创建一个文本文件，并将所有的url添加到该文件中，每个url都必须是单独的一行。

```
vim download_list.txt
```

然后使用-i选项，后跟该文本文件：

```
wget -i download_list.txt
```

### 7、使用 --limit-rate 选项限制下载速度

默认情况下，wget命令会以全速下载，但是有时下载一个非常大的资源的话，可能会占用大量的可用带宽，影响其他使用网络的任务，这时就要限制下载速度，可以使用--limit-rate选项。

例如，以下命令将下载速度限制为1m/s：

```
wget --limit-rate=1m https://download.redis.io/releases/redis-6.0.8.tar.gz
```

### 8、使用 -U 选项设定模拟下载（伪装代理名称下载）

如果远程服务器阻止wget下载资源，我们可以通过-U选项模拟浏览器进行下载，例如下面模拟谷歌浏览器下载。

```
wget -U 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.43 Safari/537.36' https://download.redis.io/releases/redis-6.0.8.tar.gz
```

或者

```
wget –user-agent=”Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16″ 下载链接
```

### 9、使用 --tries 选项增加重试次数

如果网络有问题或下载一个大文件有可能会下载失败，wget默认重试20次，我们可以使用-tries选项来增加重试次数。

```
wget --tries=40 https://download.redis.io/releases/redis-6.0.8.tar.gz
```

### 10、通过FTP下载如果要从受密码保护的FTP服务器下载文件，需要指定用户名和密码

格式如下：

```
wget --ftp-user=<username> --ftp-password=<password> url
```

### 11、-o 选项将下载信息存入日志文件

下载信息不直接显示在终端，而是保存在一个指定的日志文件里

```
wget -o download.log url
```

### 12、-Q 选项限制总下载文件大小

```
wget -Q5m -i filelist.txt
```

上面命令的意思是：下载的文件超过5M时就退出下载。**注意**：这个参数对单个文件下载不起作用，只能递归下载时才有效。

### 13、--spider参数测试下载链接

测试下载链接是否有效。可以增加–spider参数进行检查。

```
wget --spider URL
```

下载链接正确有效时，显示如下：

```
Spider mode enabled. Check if remote file exists.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Remote file exists and could contain further links,
but recursion is disabled -- not retrieving.
```

下载链接错误无效时，显示如下：

```
 wget --spider url
 Spider mode enabled. Check if remote file exists.
 HTTP request sent, awaiting response... 404 Not Found
 Remote file does not exist -- broken link!!!
```

### 14、使用wget –mirror镜像网站

下面的例子是下载整个网站到本地。

```
wget –mirror -p –convert-links -P ./LOCAL URL
```

–miror：开户镜像下载

-p：下载所有为了html页面显示正常的文件

–convert-links：下载后，转换成本地的链接

-P ./LOCAL：保存所有文件和目录到本地指定目录

### 15、使用wget –reject过滤指定格式下载 

你想下载一个网站，但你不希望下载图片，你可以使用以下命令。

```
wget –reject=gif url
```

### 16、使用wget -r -A下载指定格式文件

 可以在以下情况使用该功能：

下载一个网站的所有图片

下载一个网站的所有视频

下载一个网站的所有PDF文件

```
wget -r -A .pdf url
```

 

转载至：https://baijiahao.baidu.com/s?id=1715589159640466321&wfr=spider&for=pc

​    去期待陌生，去拥抱惊喜。

# wget 文件下载

阅读 : 2088

Linux系统中的[wget](https://www.coonote.com/linux/wget-file-download.html)是一个下载文件的工具，它用在命令行下。对于Linux用户是必不可少的工具，我们经常要下载一些软件或从远程服务器恢复备份到本地服务器。wget支持HTTP，HTTPS和FTP协议，可以使用HTTP代理。

wget  可以跟踪HTML页面上的链接依次下载来创建远程服务器的本地版本，完全重建原始站点的目录结构。这又常被称作”递归下载”。在递归下载的时候，wget 遵循Robot Exclusion标准(/robots.txt). wget可以在下载的同时，将链接转换成指向本地文件，以方便离线浏览。

wget  非常稳定，它在带宽很窄的情况下和不稳定网络中有很强的适应性.如果是由于网络的原因下载失败，wget会不断的尝试，直到整个文件下载完毕。如果是服务器打断下载过程，它会再次联到服务器上从停止的地方继续下载。这对从那些限定了链接时间的服务器上下载大文件非常有用。

## 1. 命令格式

wget [参数] [URL地址]

## 2. 命令参数：

### 启动参数：

- -V, –version 显示wget的版本后退出
- -h, –help 打印语法帮助
- -b, –background 启动后转入后台执行
- -e, –execute=COMMAND 执行’.wgetrc’格式的命令，wgetrc格式参见/etc/wgetrc或~/.wgetrc

### 记录和输入文件参数

- -o, –output-file=FILE 把记录写到FILE文件中
- -a, –append-output=FILE 把记录追加到FILE文件中
- -d, –debug 打印调试输出
- -q, –quiet 安静模式(没有输出)
- -v, –verbose 冗长模式(这是缺省设置)
- -nv, –non-verbose 关掉冗长模式，但不是安静模式
- -i, –input-file=FILE 下载在FILE文件中出现的URLs
- -F, –force-html 把输入文件当作HTML格式文件对待
- -B, –base=URL 将URL作为在-F -i参数指定的文件中出现的相对链接的前缀

–sslcertfile=FILE 可选客户端证书 –sslcertkey=KEYFILE 可选客户端证书的KEYFILE –egd-file=FILE 指定EGD socket的文件名

### 下载参数

- -bind-address=ADDRESS 指定本地使用地址(主机名或IP，当本地有多个IP或名字时使用)
- -t, –tries=NUMBER 设定最大尝试链接次数(0 表示无限制).
- -O –output-document=FILE 把文档写到FILE文件中
- -nc, –no-clobber 不要覆盖存在的文件或使用.#前缀
- -c, –continue 接着下载没下载完的文件
- -progress=TYPE 设定进程条标记
- -N, –timestamping 不要重新下载文件除非比本地文件新
- -S, –server-response 打印服务器的回应
- -T, –timeout=SECONDS 设定响应超时的秒数
- -w, –wait=SECONDS 两次尝试之间间隔SECONDS秒
- -waitretry=SECONDS 在重新链接之间等待1…SECONDS秒
- -random-wait 在下载之间等待0…2*WAIT秒
- -Y, -proxy=on/off 打开或关闭代理
- -Q, -quota=NUMBER 设置下载的容量限制
- -limit-rate=RATE 限定下载输率

### 目录参数

- -nd –no-directories 不创建目录
- -x, –force-directories 强制创建目录
- -nH, –no-host-directories 不创建主机目录
- -P, –directory-prefix=PREFIX 将文件保存到目录 PREFIX/…
- -cut-dirs=NUMBER 忽略 NUMBER层远程目录

### HTTP 选项参数

- -http-user=USER 设定HTTP用户名为 USER.
- -http-passwd=PASS 设定http密码为 PASS
- -C, –cache=on/off 允许/不允许服务器端的数据缓存 (一般情况下允许)
- -E, –html-extension 将所有text/html文档以.html扩展名保存
- -ignore-length 忽略 ‘Content-Length’头域
- -header=STRING 在headers中插入字符串 STRING
- -proxy-user=USER 设定代理的用户名为 USER
- proxy-passwd=PASS 设定代理的密码为 PASS
- referer=URL 在HTTP请求中包含 ‘Referer: URL’头
- -s, –save-headers 保存HTTP头到文件
- -U, –user-agent=AGENT 设定代理的名称为 AGENT而不是 Wget/VERSION
- no-http-keep-alive 关闭 HTTP活动链接 (永远链接)
- cookies=off 不使用 cookies
- load-cookies=FILE 在开始会话前从文件 FILE中加载cookie
- save-cookies=FILE 在会话结束后将 cookies保存到 FILE文件中

### FTP 选项参数

- -nr, –dont-remove-listing 不移走 ‘.listing’文件
- -g, –glob=on/off 打开或关闭文件名的 globbing机制
- passive-ftp 使用被动传输模式 (缺省值).
- active-ftp 使用主动传输模式
- retr-symlinks 在递归的时候，将链接指向文件(而不是目录)

### 递归下载参数

- -r, –recursive 递归下载－－慎用!

- -l, –level=NUMBER 最大递归深度 (inf 或 0 代表无穷)

- -delete-after 在现在完毕后局部删除文件

- -k, –convert-links 转换非相对链接为相对链接

- -K, –backup-converted 在转换文件X之前，将之备份为 X.orig

- -m, –mirror 等价于 -r -N -l inf -nr

- - ​      -p, –page-requisites 下载显示HTML文件的所有图片     

    ​      递归下载中的包含和不包含(accept/reject)：     

- -A, –accept=LIST 分号分隔的被接受扩展名的列表

- -R, –reject=LIST 分号分隔的不被接受的扩展名的列表

- -D, –domains=LIST 分号分隔的被接受域的列表

- -exclude-domains=LIST 分号分隔的不被接受的域的列表

- -follow-ftp 跟踪HTML文档中的FTP链接

- -follow-tags=LIST 分号分隔的被跟踪的HTML标签的列表

- -G, –ignore-tags=LIST 分号分隔的被忽略的HTML标签的列表

- -H, –span-hosts 当递归时转到外部主机

- -L, –relative 仅仅跟踪相对链接

- -I, –include-directories=LIST 允许目录的列表

- -X, –exclude-directories=LIST 不被包含目录的列表

- -np, –no-parent 不要追溯到父目录

wget -S –spider url 不下载只显示过程

## 3. 使用实例

### 实例1：使用wget下载单个文件

```
<pre>$wget https://www.coonote.com/wordpress-3.1-zh_CN.zip<br></pre>
```

说明：以上例子从网络下载一个文件并保存在当前目录，在下载的过程中会显示进度条，包含（下载完成百分比，已经下载的字节，当前下载速度，剩余下载时间）。

### 实例2：使用wget -O下载并以不同的文件名保存

```
<pre>$wget -O wordpress.zip https://www.coonote.com/download.aspx?id=1080
```

wget默认会以最后一个符合”/”的后面的字符来命令，对于动态链接的下载通常文件名会不正确。

### 实例3：使用wget –limit -rate限速下载

```
<pre>$wget --limit-rate=300k https://www.coonote.com/wordpress-3.1-zh_CN.zip
```

当你执行wget的时候，它默认会占用全部可能的宽带下载。但是当你准备下载一个大文件，而你还需要下载其它文件时就有必要限速了。

### 实例4：使用wget -c断点续传

```
<pre>$wget -c https://www.coonote.com/wordpress-3.1-zh_CN.zip<br></pre>
```

使用wget -c重新启动下载中断的文件，对于我们下载大文件时突然由于网络等原因中断非常有帮助，我们可以继续接着下载而不是重新下载一个文件。需要继续中断的下载时可以使用-c参数。

### 实例5：使用wget -b后台下载

```
<pre>$wget -b https://www.coonote.comwordpress-3.1-zh_CN.zip<br>Continuing in background, pid 1840.
```

Output will be written to 'wget-log'.

对于下载非常大的文件的时候，我们可以使用参数-b进行后台下载。

你可以使用以下命令来察看下载进度:

```
<pre>$tail -f wget-log
```

### 实例6：伪装代理名称下载

```
<pre>wget --user-agent="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16" http://www.minjieren.com/wordpress-3.1-zh_CN.zip
```

有些网站能通过根据判断代理名称不是浏览器而拒绝你的下载请求。不过你可以通过–user-agent参数伪装。

### 实例7：使用wget -i下载多个文件

首先，保存一份下载链接文件,接着使用这个文件和参数-i下载:

```
<pre>$cat > filelist.txt
```

url1
 url2
 url3
 url4

$wget -i filelist.txt

### 实例8：使用wget –mirror镜像网站

```
<pre>$wget --mirror -p --convert-links -P ./LOCAL URL
```

- ​    下载整个网站到本地   

  -miror:开户镜像下载 -p:下载所有为了html页面显示正常的文件 -convert-links:下载后，转换成本地的链接 -P ./LOCAL：保存所有文件和目录到本地指定目录

### 实例9: 使用wget -r -A下载指定格式文件

```
<pre>$wget -r -A.pdf url
```

- ​    可以在以下情况使用该功能：   

  下载一个网站的所有图片 下载一个网站的所有视频 下载一个网站的所有PDF文件

### 实例10：使用wget FTP下载

```
<pre>$wget ftp-url
```

$wget --ftp-user=USERNAME --ftp-password=PASSWORD url

- ​    可以使用wget来完成ftp链接的下载   

  使用wget匿名ftp下载：wget ftp-url 使用wget用户名和密码认证的ftp下载:wget –ftp-user=USERNAME –ftp-password=PASSWORD url

## 4. 编译安装

使用如下命令编译安装:

```
tar zxvf wget-1.9.1.tar.gz
cd wget-1.9.1
./configure
make
make install
```

​      