# Apache

http://httpd.apache.org

## 隐藏 Apache 版本号和其它敏感信息
当远程请求发送到你的 Apache Web 服务器时，在默认情况下，一些有价值的信息，如 web 服务器版本号、服务器操作系统详细信息、已安装的 Apache 模块等等，会随服务器生成的文档发回客户端。

这给攻击者利用漏洞并获取对 web 服务器的访问提供了很多有用的信息。为了避免显示 web 服务器信息，我们将在本文中演示如何使用特定的 Apache 指令隐藏 Apache Web 服务器的信息。

两个重要的指令是：
ServerSignature

这允许在服务器生成的文档（如错误消息、modproxy 的 ftp 目录列表、modinfo 输出等等）下添加一个显示服务器名称和版本号的页脚行。

它有三个可能的值：

    On - 允许在服务器生成的文档中添加尾部页脚行，
    Off - 禁用页脚行
    EMail - 创建一个 “mailto:” 引用；用于将邮件发送到所引用文档的 ServerAdmin。

ServerTokens

它决定了发送回客户端的服务器响应头字段是否包含服务器操作系统类型的描述和有关已启用的 Apache 模块的信息。

此指令具有以下可能的值（以及在设置特定值时发送到客户端的示例信息）：

    ServerTokens   Full (或者不指定)

发送给客户端的信息： Server: Apache/2.4.2 (Unix) PHP/4.2.2 MyMod/1.2

    ServerTokens   Prod[uctOnly]

发送给客户端的信息： Server: Apache

    ServerTokens   Major

发送给客户端的信息： Server: Apache/2

    ServerTokens   Minor

发送给客户端的信息： Server: Apache/2.4

    ServerTokens   Min[imal]

发送给客户端的信息：Server: Apache/2.4.2

    ServerTokens   OS

发送给客户端的信息： Server: Apache/2.4.2 (Unix)

注意：在 Apache 2.0.44 之后，ServerTokens 也控制由 ServerSignature 指令提供的信息。

推荐阅读： 5 个加速 Apache Web 服务器的贴士。

为了隐藏 web 服务器版本号、服务器操作系统细节、已安装的 Apache 模块等等，使用你最喜欢的编辑器打开 Apache 配置文件：

    $ sudo vi /etc/apache2/apache2.conf        #Debian/Ubuntu systems
    $ sudo vi /etc/httpd/conf/httpd.conf       #RHEL/CentOS systems

添加/修改/附加下面的行：

    ServerTokens Prod
    ServerSignature Off

保存并退出文件，重启你的 Apache 服务器：

    $ sudo systemctl apache2 restart  #SystemD
    $ sudo sevice apache2 restart     #SysVInit

## Apache HTTP Server Version 2.4

The configuration system is fully documented in /usr/share/doc/apache2/README.Debian.gz. Refer to this for the full documentation. Documentation for the web server itself can be found by accessing the manual if the apache2-doc package was installed on this server.

The configuration layout for an Apache2 web server installation on Debian systems is as follows:

/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf


    apache2.conf is the main configuration file. It puts the pieces together by including all remaining configuration files when starting up the web server.
    ports.conf is always included from the main configuration file. It is used to determine the listening ports for incoming connections, and this file can be customized anytime.
    Configuration files in the mods-enabled/, conf-enabled/ and sites-enabled/ directories contain particular configuration snippets which manage modules, global configuration fragments, or virtual host configurations, respectively.
    They are activated by symlinking available configuration files from their respective *-available/ counterparts. These should be managed by using our helpers a2enmod, a2dismod, a2ensite, a2dissite, and a2enconf, a2disconf . See their respective man pages for detailed information.
    The binary is called apache2. Due to the use of environment variables, in the default configuration, apache2 needs to be started/stopped with /etc/init.d/apache2 or apache2ctl. Calling /usr/bin/apache2 directly will not work with the default configuration.

Document Roots

By default, Debian does not allow access through the web browser to any file apart of those located in /var/www, public_html directories (when enabled) and /usr/share (for web applications). If your site is using a web document root located elsewhere (such as in /srv) you may need to whitelist your document root directory in /etc/apache2/apache2.conf.

The default Debian document root is /var/www/html. You can make your own virtual hosts under /var/www. This is different to previous releases which provides better security out of the box.
Reporting Problems

Please use the reportbug tool to report bugs in the Apache2 package with Debian. However, check existing bug reports before reporting a new bug.

Please report bugs specific to modules (such as PHP and others) to respective packages, not to the web server itself.





Download 	Download the latest release from http://httpd.apache.org/download.cgi
Extract 	$ gzip -d httpd-NN.tar.gz
$ tar xvf httpd-NN.tar
$ cd httpd-NN
Configure 	$ ./configure --prefix=PREFIX
Compile 	$ make
Install 	$ make install
Customize 	$ vi PREFIX/conf/httpd.conf
Test 	$ PREFIX/bin/apachectl -k start

NN must be replaced with the current version number, and PREFIX must be replaced with the filesystem path under which the server should be installed. If PREFIX is not specified, it defaults to /usr/local/apache2.

Each section of the compilation and installation process is described in more detail below, beginning with the requirements for compiling and installing Apache httpd.
top
Requirements

The following requirements exist for building Apache httpd:

APR and APR-Util
    Make sure you have APR and APR-Util already installed on your system. If you don't, or prefer to not use the system-provided versions, download the latest versions of both APR and APR-Util from Apache APR, unpack them into /httpd_source_tree_root/srclib/apr and /httpd_source_tree_root/srclib/apr-util (be sure the directory names do not have version numbers; for example, the APR distribution must be under /httpd_source_tree_root/srclib/apr/) and use ./configure's --with-included-apr option. On some platforms, you may have to install the corresponding -dev packages to allow httpd to build against your installed copy of APR and APR-Util.
Perl-Compatible Regular Expressions Library (PCRE)
    This library is required but not longer bundled with httpd. Download the source code from http://www.pcre.org, or install a Port or Package. If your build system can't find the pcre-config script installed by the PCRE build, point to it using the --with-pcre parameter. On some platforms, you may have to install the corresponding -dev package to allow httpd to build against your installed copy of PCRE.
Disk Space
    Make sure you have at least 50 MB of temporary free disk space available. After installation the server occupies approximately 10 MB of disk space. The actual disk space requirements will vary considerably based on your chosen configuration options, any third-party modules, and, of course, the size of the web site or sites that you have on the server.
ANSI-C Compiler and Build System
    Make sure you have an ANSI-C compiler installed. The GNU C compiler (GCC) from the Free Software Foundation (FSF) is recommended. If you don't have GCC then at least make sure your vendor's compiler is ANSI compliant. In addition, your PATH must contain basic build tools such as make.
Accurate time keeping
    Elements of the HTTP protocol are expressed as the time of day. So, it's time to investigate setting some time synchronization facility on your system. Usually the ntpdate or xntpd programs are used for this purpose which are based on the Network Time Protocol (NTP). See the NTP homepage for more details about NTP software and public time servers.
Perl 5 [OPTIONAL]
    For some of the support scripts like apxs or dbmmanage (which are written in Perl) the Perl 5 interpreter is required (versions 5.003 or newer are sufficient). If no Perl 5 interpreter is found by the configure script, you will not be able to use the affected support scripts. Of course, you will still be able to build and use Apache httpd.

top
Download

The Apache HTTP Server can be downloaded from the Apache HTTP Server download site, which lists several mirrors. Most users of Apache on unix-like systems will be better off downloading and compiling a source version. The build process (described below) is easy, and it allows you to customize your server to suit your needs. In addition, binary releases are often not up to date with the latest source releases. If you do download a binary, follow the instructions in the INSTALL.bindist file inside the distribution.

After downloading, it is important to verify that you have a complete and unmodified version of the Apache HTTP Server. This can be accomplished by testing the downloaded tarball against the PGP signature. Details on how to do this are available on the download page and an extended example is available describing the use of PGP.
top
Extract

Extracting the source from the Apache HTTP Server tarball is a simple matter of uncompressing, and then untarring:

$ gzip -d httpd-NN.tar.gz
$ tar xvf httpd-NN.tar

This will create a new directory under the current directory containing the source code for the distribution. You should cd into that directory before proceeding with compiling the server.
top
Configuring the source tree

The next step is to configure the Apache source tree for your particular platform and personal requirements. This is done using the script configure included in the root directory of the distribution. (Developers downloading an unreleased version of the Apache source tree will need to have autoconf and libtool installed and will need to run buildconf before proceeding with the next steps. This is not necessary for official releases.)

To configure the source tree using all the default options, simply type ./configure. To change the default options, configure accepts a variety of variables and command line options.

The most important option is the location --prefix where Apache is to be installed later, because Apache has to be configured for this location to work correctly. More fine-tuned control of the location of files is possible with additional configure options.

Also at this point, you can specify which features you want included in Apache by enabling and disabling modules. Apache comes with a wide range of modules included by default. They will be compiled as shared objects (DSOs) which can be loaded or unloaded at runtime. You can also choose to compile modules statically by using the option --enable-module=static.

Additional modules are enabled using the --enable-module option, where module is the name of the module with the mod_ string removed and with any underscore converted to a dash. Similarly, you can disable modules with the --disable-module option. Be careful when using these options, since configure cannot warn you if the module you specify does not exist; it will simply ignore the option.

In addition, it is sometimes necessary to provide the configure script with extra information about the location of your compiler, libraries, or header files. This is done by passing either environment variables or command line options to configure. For more information, see the configure manual page. Or invoke configure using the --help option.

For a short impression of what possibilities you have, here is a typical example which compiles Apache for the installation tree /sw/pkg/apache with a particular compiler and flags plus the two additional modules mod_ldap and mod_lua:

$ CC="pgcc" CFLAGS="-O2" \
./configure --prefix=/sw/pkg/apache \
--enable-ldap=shared \
--enable-lua=shared

When configure is run it will take several minutes to test for the availability of features on your system and build Makefiles which will later be used to compile the server.

Details on all the different configure options are available on the configure manual page.
top
Build

Now you can build the various parts which form the Apache package by simply running the command:

$ make

Please be patient here, since a base configuration takes several minutes to compile and the time will vary widely depending on your hardware and the number of modules that you have enabled.
top
Install

Now it's time to install the package under the configured installation PREFIX (see --prefix option above) by running:

$ make install

This step will typically require root privileges, since PREFIX is usually a directory with restricted write permissions.

If you are upgrading, the installation will not overwrite your configuration files or documents.
top
Customize

Next, you can customize your Apache HTTP server by editing the configuration files under PREFIX/conf/.

$ vi PREFIX/conf/httpd.conf

Have a look at the Apache manual under PREFIX/docs/manual/ or consult http://httpd.apache.org/docs/2.4/ for the most recent version of this manual and a complete reference of available configuration directives.
top
Test

Now you can start your Apache HTTP server by immediately running:

$ PREFIX/bin/apachectl -k start

You should then be able to request your first document via the URL http://localhost/. The web page you see is located under the DocumentRoot, which will usually be PREFIX/htdocs/. Then stop the server again by running:

$ PREFIX/bin/apachectl -k stop
top
Upgrading

The first step in upgrading is to read the release announcement and the file CHANGES in the source distribution to find any changes that may affect your site. When changing between major releases (for example, from 2.0 to 2.2 or from 2.2 to 2.4), there will likely be major differences in the compile-time and run-time configuration that will require manual adjustments. All modules will also need to be upgraded to accommodate changes in the module API.

Upgrading from one minor version to the next (for example, from 2.2.55 to 2.2.57) is easier. The make install process will not overwrite any of your existing documents, log files, or configuration files. In addition, the developers make every effort to avoid incompatible changes in the configure options, run-time configuration, or the module API between minor versions. In most cases you should be able to use an identical configure command line, an identical configuration file, and all of your modules should continue to work.

To upgrade across minor versions, start by finding the file config.nice in the build directory of your installed server or at the root of the source tree for your old install. This will contain the exact configure command line that you used to configure the source tree. Then to upgrade from one version to the next, you need only copy the config.nice file to the source tree of the new version, edit it to make any desired changes, and then run:

$ ./config.nice
$ make
$ make install
$ PREFIX/bin/apachectl -k graceful-stop
$ PREFIX/bin/apachectl -k start
You should always test any new version in your environment before putting it into production. For example, you can install and run the new version along side the old one by using a different --prefix and a different port (by adjusting the Listen directive) to test for any incompatibilities before doing the final upgrade.

You can pass additional arguments to config.nice, which will be appended to your original configure options:

$ ./config.nice --prefix=/home/test/apache --with-port=90
top
Third-party packages

A large number of third parties provide their own packaged distributions of the Apache HTTP Server for installation on particular platforms. This includes the various Linux distributions, various third-party Windows packages, Mac OS X, Solaris, and many more.

Our software license not only permits, but encourages, this kind of redistribution. However, it does result in a situation where the configuration layout and defaults on your installation of the server may differ from what is stated in the documentation. While unfortunate, this situation is not likely to change any time soon.

A description of these third-party distrubutions is maintained in the HTTP Server wiki, and should reflect the current state of these third-party distributions. However, you will need to familiarize yourself with your particular platform's package management and installation procedures.

Available Languages:  de  |  en  |  es  |  fr  |  ja  |  ko  |  tr
top
Comments
Notice:
This is not a Q&A section. Comments placed here should be pointed towards suggestions on improving the documentation or server, and may be removed again by our moderators if they are either implemented or considered invalid/off-topic. Questions on how to manage the Apache HTTP Server should be directed at either our IRC channel, #httpd, on Freenode, or sent to our mailing lists.

RSS   Log in / register

Colton  18 days ago      Rating: 0 (register an account in order to rate comments)

How do I compile only certain modules?

Eric Strickland  27 days ago      Rating: 0 (register an account in order to rate comments)

I would like to know how to set up Apache to my text editor to build websites on my PC? like using localhost with HTML besides use a index.php. please help me. Thank you for your time.I've looked everywhere in the doc's for it a lot of stuff in there is confusing

liuzhe   33 days ago      Rating: 0 (register an account in order to rate comments)

does apache tar  divide into 64bit or 32bit

dimitry  38 days ago      Rating: 0 (register an account in order to rate comments)

Will Apache 2.2 or 2.4 support on Solaris 8 Operating System?

 [Account verified by Apache] covener  38 days ago      Rating: 0 (register an account in order to rate comments)

No answer other than "try it and see". It's probably too old for anyone else to care about.

nabendu  74 days ago      Rating: 0 (register an account in order to rate comments)

Hi Friend getting following errors while compiling apache with ssl

 Entering directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
/root/Apache_Package/httpd-2.4.23/srclib/apr/libtool --silent --mode=link gcc -std=gnu99 -I/usr/local/ssl/include   -g -O2 -pthread    -L/usr/local/ssl/lib   -lssl -lcrypto -lrt -lcrypt -lpthread -ldl       -o mod_ssl.la -rpath /usr/local/apache2/modules -module -avoid-version  mod_ssl.lo ssl_engine_config.lo ssl_engine_init.lo ssl_engine_io.lo ssl_engine_kernel.lo ssl_engine_log.lo ssl_engine_mutex.lo ssl_engine_pphrase.lo ssl_engine_rand.lo ssl_engine_vars.lo ssl_scache.lo ssl_util_stapling.lo ssl_util.lo ssl_util_ssl.lo ssl_engine_ocsp.lo ssl_util_ocsp.lo  -export-symbols-regex ssl_module
/usr/bin/ld: /usr/local/ssl/lib/libssl.a(s3_srvr.o): relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC
/usr/local/ssl/lib/libssl.a: could not read symbols: Bad value
collect2: error: ld returned 1 exit status
make[4]: *** [mod_ssl.la] Error 1
make[4]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
make[3]: *** [shared-build-recursive] Error 1
make[3]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules/ssl'
make[2]: *** [shared-build-recursive] Error 1
make[2]: Leaving directory `/root/Apache_Package/httpd-2.4.23/modules'
make[1]: *** [shared-build-recursive] Error 1
make[1]: Leaving directory `/root/Apache_Package/httpd-2.4.23'
make: *** [all-recursive] Error 1


Please help.

 [Account verified by Apache] thumbs  73 days ago      Rating: 0 (register an account in order to rate comments)

This is not a Q&A section. Please use either the mailinglist users@httpd.apache.org or our IRC channel #httpd at irc.freenode.net for support.

Dani Grosu  143 days ago      Rating: 0 (register an account in order to rate comments)

Is "./configure --with-ssl=/etc/ssl" specifying that Apache will use the installed OpenSSL on the system?

Hosney Osman  756 days ago      Rating: 0 (register an account in order to rate comments)

Dear All
when i am trying to install apapche http 2.2 every thing working fine
when i trying to install apache http 2.4 there is 3 error comming
lnot found apr and apr-util and pcre
is there any recommended steps to solve this issues

 [Account verified by Apache] thumbs  755 days ago      Rating: 0 (register an account in order to rate comments)

If you're compiling from source, it'll try to find the system apr and apr-util, so you'll need to have those installed separately ahead of time.

Fabio Yamada  131 days ago      Rating: 0 (register an account in order to rate comments)

Please note that compilation with pcre2 don't work. One must choose older and discontinued version of pcre (like pcre-8.37) for compiling apache2 (tested using version 2.4.20).

gmb  60 days ago      Rating: 0 (register an account in order to rate comments)

Thanks for mentioning - this helped. Just wondering why the main  documentation above would not mention this info about PCRE version. I see i see a lot of people encountering this issue and posting Question for help. Though there is indication to use pcre-config and not pcre2-config - which is clear enough now, it would help a lot of newbies like myself (who by default, fall for the latest and greatest sometimes) to get this right the first time. Any thoughts Apache/httpd people ?

Anonymous  759 days ago      Rating: 0 (register an account in order to rate comments)

"make install" insists installing configuration files under /etc folder. Is there a way to change this?

Anonymous  759 days ago      Rating: 0 (register an account in order to rate comments)

I used --prefix=/app/product to configure apache

Anonymous  424 days ago      Rating: 0 (register an account in order to rate comments)

The best way to determine install layouts is to use the --enable-layout=ID option to configure and patch the config.layout file the way you want it.

Rodney  956 days ago      Rating: 0 (register an account in order to rate comments)

The "Install" section states "This step will typically require root privileges, since PREFIX is usually a directory with restricted write permissions."


It'd be useful if another sentence was added indicating that file ownership and permissions should also be verified or secured as desired.

If I do the build ("make") as a non-privileged user and then do the install ("sudo make install") then this results in files installed into PREFIX as the non-privileged user when I may want only root (or some service account) to own them.

I suggest the following:

After install ensure that the desired security settings are applied to the directory and files.  One possibility is "chown -R root:root PREFIX" and "chmod -R o-w PREFIX"

Nejc Vukovic  762 days ago      Rating: 0 (register an account in order to rate comments)

Just to add to this: In Mac OS X there is no root group therefore use "chown -R root:admin PREFIX"





## 使用 Apache 控制命令检查模块是否已经启用或加载
常见的 Apache 模块有：

    mod_ssl – 提供了 HTTPS 功能。
    mod_rewrite – 可以用正则表达式匹配 url 样式，并且使用 .htaccess 技巧来进行透明转发，或者提供 HTTP 状态码回应。
    mod_security – 用于保护 Apache 免于暴力破解或者 DDoS 攻击。
    mod_status - 用于监测 Apache 的负载及页面统计。

在 Linux 中 apachectl 或者 apache2ctl用于控制 Apache 服务器，是 Apache 的前端。

你可以用下面的命令显示 apache2ctl 的使用信息：

    $ apache2ctl help
    或者
    $ apachectl help
    
    Usage: /usr/sbin/httpd [-D name] [-d directory] [-f file]
                           [-C "directive"] [-c "directive"]
                           [-k start|restart|graceful|graceful-stop|stop]
                           [-v] [-V] [-h] [-l] [-L] [-t] [-S]
    Options:
      -D name            : define a name for use in  directives
      -d directory       : specify an alternate initial ServerRoot
      -f file            : specify an alternate ServerConfigFile
      -C "directive"     : process directive before reading config files
      -c "directive"     : process directive after reading config files
      -e level           : show startup errors of level (see LogLevel)
      -E file            : log startup errors to file
      -v                 : show version number
      -V                 : show compile settings
      -h                 : list available command line options (this page)
      -l                 : list compiled in modules
      -L                 : list available configuration directives
      -t -D DUMP_VHOSTS  : show parsed settings (currently only vhost settings)
      -S                 : a synonym for -t -D DUMP_VHOSTS
      -t -D DUMP_MODULES : show all loaded modules
      -M                 : a synonym for -t -D DUMP_MODULES
      -t                 : run syntax check for config files

apache2ctl 可以工作在两种模式下，SysV init 模式和直通模式。在 SysV init 模式下，apache2ctl 用如下的简单的单命令形式：

    $ apachectl command
    或者
    $ apache2ctl command

比如要启动并检查它的状态，运行这两个命令。如果你是普通用户，使用 sudo 命令来以 root 用户权限来运行：

    $ sudo apache2ctl start
    $ sudo apache2ctl status
    
    tecmint@TecMint ~ $ sudo apache2ctl start
    AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1\. Set the 'ServerName' directive globally to suppress this message
    httpd (pid 1456) already running
    tecmint@TecMint ~ $ sudo apache2ctl status
    Apache Server Status for localhost (via 127.0.0.1)
    Server Version: Apache/2.4.18 (Ubuntu)
    Server MPM: prefork
    Server Built: 2016-07-14T12:32:26
    -------------------------------------------------------------------------------
    Current Time: Tuesday, 15-Nov-2016 11:47:28 IST
    Restart Time: Tuesday, 15-Nov-2016 10:21:46 IST
    Parent Server Config. Generation: 2
    Parent Server MPM Generation: 1
    Server uptime: 1 hour 25 minutes 41 seconds
    Server load: 0.97 0.94 0.77
    Total accesses: 2 - Total Traffic: 3 kB
    CPU Usage: u0 s0 cu0 cs0
    .000389 requests/sec - 0 B/second - 1536 B/request
    1 requests currently being processed, 4 idle workers
    __W__...........................................................
    ................................................................
    ......................
    Scoreboard Key:
    "_" Waiting for Connection, "S" Starting up, "R" Reading Request,
    "W" Sending Reply, "K" Keepalive (read), "D" DNS Lookup,
    "C" Closing connection, "L" Logging, "G" Gracefully finishing,
    "I" Idle cleanup of worker, "." Open slot with no current process

当在直通模式下，apache2ctl 可以用下面的语法带上所有 Apache 的参数：

    $ apachectl [apache-argument]
    $ apache2ctl [apache-argument]

可以用下面的命令列出所有的 Apache 参数：

    $ apache2 help    [在基于Debian的系统中]
    $ httpd help      [在RHEL的系统中]

检查启用的 Apache 模块

因此，为了检测你的 Apache 服务器启动了哪些模块，在你的发行版中运行适当的命令，-t -D DUMP_MODULES 是一个用于显示所有启用的模块的 Apache 参数：

    ---------------  在基于 Debian 的系统中 ---------------
    $ apache2ctl -t -D DUMP_MODULES   
    或者
    $ apache2ctl -M
    
    ---------------  在 RHEL 的系统中 ---------------
    $ apachectl -t -D DUMP_MODULES   
    或者
    $ httpd -M
    $ apache2ctl -M
    
    [root@tecmint httpd]# apachectl -M
    Loaded Modules:
     core_module (static)
     mpm_prefork_module (static)
     http_module (static)
     so_module (static)
     auth_basic_module (shared)
     auth_digest_module (shared)
     authn_file_module (shared)
     authn_alias_module (shared)
     authn_anon_module (shared)
     authn_dbm_module (shared)
     authn_default_module (shared)
     authz_host_module (shared)
     authz_user_module (shared)
     authz_owner_module (shared)
     authz_groupfile_module (shared)
     authz_dbm_module (shared)
     authz_default_module (shared)
     ldap_module (shared)
     authnz_ldap_module (shared)
     include_module (shared)
    ....

## 代理(Proxy)

代理分为：正向代理(Foward Proxy)和反向代理(Reverse Proxy)

 

**1、正向代理(Foward Proxy)**

 

正向代理(Foward  Proxy)用于代理内部网络对Internet的连接请求，客户机必须指定代理服务器,并将本来要直接发送到Web服务器上的http请求发送到代理服务器，由代理服务器负责请求Internet，然后返回Internet的请求给内网的客户端。

 

Internal Network Client ——(request-url)——> Foward Proxy Server ———— > Internet

 

**2、反向代理(Reverse Proxy)**

 

反向代理（Reverse Proxy）方式是指以代理服务器来接受internet上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给internet上请求连接的客户端，此时代理服务器对外就表现为一个服务器。如图：

 

​							                                        	/————> Internal Server1

Internet ————> Reverse Proxy Server  ————> Internal Server2

​								                                        \————> internal serverN

 

Apache 代理

 

apache支持正向代理和反向代理，但一般反向代理使用较多。

 

 

```
#正向代理

# 正向代理开关
ProxyRequests On
ProxyVia On

<Proxy *>
Order deny,allow
Deny from all
Allow from internal.example.com
</Proxy>
```

 

 

```
# Reverse Proxy

# 设置反向代理
ProxyPass /foo http://foo.example.com/bar
# 设置反向代理使用代理服务的HOST重写内部原始服务器响应报文头中的Location和Content-Location
ProxyPassReverse /foo http://foo.example.com/bar
```

   注意：ProxyPassReverse 指令不是设置反向代理指令，只是设置反向代理重新重定向（3xx）Header头参数值。

 

举例：

 

下面是典型的APACHE+TOMCAT负载均衡和简单集群配置

 

```
    ProxyRequests Off  
    ProxyPreserveHost on 
    
    ProxyPass / balancer://cluster/ stickysession=jsessionid nofailover=Off
    ProxyPassReverse / balancer://cluster/  
    <Proxy balancer://cluster>  
      BalancerMember  http://localhost:8080 loadfactor=1 retry=10  
      BalancerMember  http://localhost:8081 loadfactor=1 retry=10  
      ProxySet lbmethod=bybusyness  
    </Proxy>
```

 

​    ProxyPassReverse / balancer://cluster/  表示负载均衡配置中的所有TOMCAT服务器，如果响应报文的Header中有Location(3xx指定重定向的URL)或Content-Location(指定多个URL指向同一个实体)，则使用请求报文中HOST替换URL中的HOST部分。

 

 

1. GET http://apache-host/entityRelativeUrl
2. tomcat response 307 ,Header Location: http://localhost:8080/entityRelativeUrl
3. apache 重写 response header中的Location为：http://apache-host:8080/entityRelativeUrl

 

注意：只有TOMCAT RESPINSE Location中的URL的Host部分匹配tomcat原始HOST的情况才重写。如307到http://localhost:8088/entityRelativeUrl是不会重写的。



**正向代理**

​        正向代理主要是将内网的访问请求通过代理服务器转发访问并返回结果。通常客户端无法直接访问外部的web,需要在客户端所在的网络内架设一台代理服务器,客户端通过代理服务器访问外部的web，需要在客户端的浏览器中设置代理服务器。一般由两个使用场景；

​        **场景1**：局域网的代理服务器；

​        **场景2**：访问某个受限网络的代理服务器，如访问某些国外网站。正向代理的原理图如下：

[![wKiom1nQvJvyOiRHAABfLbaNIhQ441.png](https://www.linuxidc.com/upload/2017_10/171009080745026.png)](https://www.linuxidc.com/upload/2017_10/171009080745026.png)

**反向代理**

​         客户端能访问外部的web,但是不能访问某些局域网中的web站点，此时我们需要目标网络中的一台主机做反向代理服务器来充当我们的访问目标，将局域网内部的web等站点资源缓存到代理服务器上，,客户端直接访问代理就像访问目标web一样(此代理对客户端透明,即客户端不用做如何设置,并不知道实际访问的只是代理而已,以为就是访问的目标)一般使用场景是：

​        **场景1**：idc的某台目标机器只对内开放web,外部的客户端要访问,就让另一台机器做proxy,外部直接访问proxy即相当于访问目标；

​        **场景2**：idc的目标机器的某个特殊的web服务工作在非正常端口如8080,而防火墙上只对外开放了80,此时可在80上做proxy映射到8080,外部访问80即相当于8080。方向代理的原理图如下：

[![wKioL1nQvGOC7pJoAABlKiLmEks752.png](https://www.linuxidc.com/upload/2017_10/171009080745027.png)](https://www.linuxidc.com/upload/2017_10/171009080745027.png)

 

### ProxyPass与ProxyPassServer

​         apache中的mod_proxy模块主要作用就是进行url的转发，即具有代理的功能。应用此功能，可以很方便的实现同tomcat等应用服务器的整合，甚者可以很方便的实现web集群的功能。

**1 ProxyPass**

​    语法：

```bash
ProxyPass [path] !|url
```

​    说明：它主要是用作URL前缀匹配，不能有正则表达式，它里面配置的Path实际上是一个虚拟的路径，在反向代理到后端的url后，path是不会带过去的，使用示例：

```bash
ProxyPass /images/  	!
#这个示例表示，/images/的请求不被转发。
ProxyPass /mirror/foo/  http://backend.example.com/
#假设当前的服务地址是http://example.com/，做下面这样的请求：http://example.com/mirror/foo/bar将被转成内部请求：http://backend.example.com/bar
#配置的时候，不需要被转发的请求，要配置在需要被转发的请求前面。
```

**2 ProxyPassMatch**

​    语法：

```bash
ProxyPassMatch [regex] !|url
```

​    说明：这个实际上是url正则匹配，而不是简单的前缀匹配，匹配上的regex部分是会带到后端的url的，这个是与ProxyPass不同的。使用示例：

```bash
ProxyPassMatch ^/images !   
#这个示例表示对/images的请求，都不会被转发。
ProxyPassMatch ^(/.*.gif) http://www.linuxidc.com
#表示对所有gif图片的请求，都被会转到后端，如此时请求 http://example.com/foo/bar.gif，那内部将会转换为这样的请求http://www.linuxidc.com/admin/bar.gif。
```

**3 ProxyPassReverse**

​    语法：

```bash
ProxyPassReverse [路径] url
```

​    说明：它一般和ProxyPass指令配合使用，此指令使Apache调整HTTP重定向应答中Location,  Content-Location,  URI头里的URL，这样可以避免在Apache作为反向代理使用时，后端服务器的HTTP重定向造成的绕过反向代理的问题。参看下面的例子：

```bash
ProxyPass        /Hadoop http://www.linuxidc.com/
ProxyPassReverse /hadoop http://www.linuxidc.com/
```

**实验环境搭建**

​        ProxyPass 很好理解，就是把所有来自客户端对http://www.linuxidc.com的请求转发给http://172.18.234.54上进行处理。ProxyPassReverse 的配置总是和ProxyPass 一致，但用途很让人费解。似乎去掉它很能很好的工作，事实真的是这样么，其实不然，如果响应中有重定向，ProxyPassReverse就派上用场。

​        ProxyPassReverse 工作原理：假设用户访问http://www.linuxidc.com/index.html.txt，通过转发交给http://172.18.234.54/index.html.txt处理，假定index.html.txt处理的结果是实现redirect到inde2.txt(使用相对路径,即省略了域名信息)，如果没有配置反向代理，客户端收到的请求响应是重定向操作，并且重定向目的url为http://172.18.234.54/inde2.txt  ，而这个地址只是代理服务器能访问到的，可想而知，客户端肯定是打不开的，反之如果配置了反向代理，则会在转交HTTP重定向应答到客户端之前调整它为 http://www.linuxidc.com/inde2.txt，即是在原请求之后追加上了redirect的路径。当客户端再次请求http: //www.linuxidc.com/inde2.txt，代理服务器再次工作把其转发到http://172.18.234.54/inde2.txt。客户端到服务器称之为正向代理，那服务器到客户端就叫反向代理。

​     1）配置代理服务器

​        代理服务器主要是实现对客户端的访问进行转发，去web服务器上替客户端访问资源。

[![wKioL1nQzLCAUc8qAAAla_v-hLc227.png](https://www.linuxidc.com/upload/2017_10/171009080745028.png)](https://www.linuxidc.com/upload/2017_10/171009080745028.png)

​    2）配置web服务器

​        在web服务器上配置虚拟主机并设置redirect参数，由于ProxyPassServer只有在出现302转发是才能体现出它与ProxyPass不同。为了模拟局域网环境，我们使用防火墙策略禁用客户端的访问。

[![wKioL1nQzMPz1lOVAABhR4Uj0Lo014.png](https://www.linuxidc.com/upload/2017_10/171009080745022.png)](https://www.linuxidc.com/upload/2017_10/171009080745022.png)

 

**结果分析**

------

​        上面搭建好了代理服务器，接下来配合是elinks与tcpdump以及wireshark我们来做实验分析（这里主要是验证ProxyPassServer的作用，ProxyPass原理简单，这里不做实验证明）。

**测试1**：我们不开启ProxyPassServer选项，只使用ProxyPass选项。如下图

```
[root@linuxidc ~]``#cat  /etc/httpd/conf.d/test.conf 
<VirtualHost *:80> 
    ``ProxyPass ``"/"` `"http://172.18.254.54/"
    ``#ProxyPassReverse "/" "     # 注释掉  
<``/VirtualHost``>
```

​    在客户端上使用elinks访问代理服务器。

```
[root@linuxidc ~]``#elinks http://172.18.250.234/index.html.txt
```

由于没有ProxyPassServer选项，所以我们访问资源失败，出现下图提示。

[![wKiom1nQ7uqyaKkHAAAVO6nZvk0199.png](https://www.linuxidc.com/upload/2017_10/171009080745024.png)](https://www.linuxidc.com/upload/2017_10/171009080745024.png)

**测试2**：开启ProxyPassServer选项，我么先在Agent上开启tcpdump进行抓包

```
[root@linuxidc ~]``# tcpdump tcp -i ens33 -w ./target.cap     # -w 表示将结果存储起来，方便wireshark进行分析
```

​    在客户端上使用elinks进行访问，为了验证ProxyPassServer的功能我们访问两次。由于使用了ProxyPassServer功能，所以我们能看到重定向的文件内容。

[![wKioL1nQ1ZOQTArTAAATeGu0wIU763.png](https://www.linuxidc.com/upload/2017_10/171009080745023.png)](https://www.linuxidc.com/upload/2017_10/171009080745023.png)

​    然后我们分析一下抓到的数据包。

[![wKiom1nQ1cXRMUIBAABKtqoQUgc867.png](https://www.linuxidc.com/upload/2017_10/171009080745025.png)](https://www.linuxidc.com/upload/2017_10/171009080745025.png)

​    从上面的数据包信息可知当我们第一次访问index.html.txt时，由于index.html.txt重定向到了inde2.html，所以代理服务器在返回结果是，不是返回给客户端一个重定向后的资源(http://172.18.254.54/inde2.html)，这个资源对客户端是不能访问的，此时ProxyPassServer的作用就起作用了，代理服务器在返回该资源时，直接又去访问了重定向之后的资源，然后在返回给客户端数据。也验证了上文中提到的ProxyPassServer的工作原理。

**本篇总结**

------

​        记得第一次看到这个两个参数的时候，也是一脸茫然，经过简单的实验发现，有没有ProxyPassServer参数都能访问成功，后来查找了许多资料，发现如果出现重定向（301、302）资源的情况下（目前我只发现这种时候会有区别，是不是唯一，我不敢说），客户端在去访问资源便不可以。于是亲手实验，发现果然如此，当添加ProxyPassServer参数后，访问重定向资源也能顺利访问了。由于实验需要很多的测试，一会儿在这台机器，一会儿在另外一台主机上，文章中为了能让大家能够很好的理解，有些小细节就省略了。实验步骤太多，所以绞尽脑汁也没有完美的描述出实验过程，望读者见谅。







# Apache Web 服务器多站点设置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache-web)

Rocky Linux 提供了许多方法来设置网络站点。Apache 只是在单台服务器上进行多站点设置的其中一种方法。尽管 Apache 是为多站点服务器设计的，但 Apache 也可以用于配置单站点服务器。 

历史事实：这个服务器设置方法似乎源自 Debian 系发行版，但它完全适合于任何运行 Apache 的 Linux 操作系统。

## 准备工作[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_1)

- 一台运行 Rocky Linux 的服务器

- 了解命令行和文本编辑器（本示例使用 

  vi

  ，但您可以选择任意您喜欢的编辑器）

  - 如果您想了解 vi 文本编辑器，[此处有一个简单教程](https://www.tutorialspoint.com/unix/unix-vi-editor.html)。

- 有关安装和运行 Web 服务的基本知识

## 安装 Apache[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#apache)

站点可能需要其他软件包。例如，几乎肯定需要 PHP，也可能需要一个数据库或其他包。从 Rocky Linux 仓库获取 PHP 与 httpd 的最新版本并安装。

有时可能还需要额外安装 php-bcmath 或 php-mysqlind 等模块，Web 应用程序规范应该会详细说明所需的模块。接下来安装 httpd 和 PHP：

- 从命令行运行 `dnf install httpd php`

## 添加额外目录[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_2)

本方法使用了两个额外目录，它们在当前系统上并不存在。在 */etc/httpd/* 中添加两个目录（sites-available 和 sites-enabled）。

- 从命令行处输入 `mkdir /etc/httpd/sites-available` 和 `mkdir /etc/httpd/sites-enabled`
- 还需要一个目录用来存放站点文件。它可以放在任何位置，但为了使目录井然有序，最好是创建一个名为 sub-domains 的目录。为简单起见，请将其放在 /var/www 中：`mkdir /var/www/sub-domains/`

## 配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_3)

还需要在 httpd.conf 文件的末尾添加一行。为此，输入 `vi /etc/httpd/conf/httpd.conf` 并跳转到文件末尾，然后添加 `Include /etc/httpd/sites-enabled`。

实际配置文件位于 */etc/httpd/sites-available*，需在 */etc/httpd/sites-enabled* 中为它们创建符号链接。

**为什么要这么做？**

原因很简单。假设运行在同一服务器上的 10 个站点有不同的 IP 地址。站点 B 有一些重大更新，且必须更改该站点的配置。如果所做的更改有问题，当重新启动 httpd 以读取新更改时，httpd 将不会启动。

不仅 B 站点不会启动，其他站点也不会启动。使用此方法，您只需移除导致故障的站点的符号链接，然后重新启动 httpd 即可。它将重新开始工作，您可以开始工作，尝试修复损坏的站点配置。

### 站点配置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_4)

此方法的另一个好处是，它允许完全指定默认 httpd.conf 文件之外的所有内容。让默认的 httpd.conf 文件加载默认设置，并让站点配置执行其他所有操作。很好，对吧？再说一次，它使得排除损坏的站点配置故障变得非常容易。

现在，假设有一个 Wiki 站点，您需要一个配置文件，以通过 80 端口访问。如果站点使用 SSL（现在站点几乎都使用 SSL）提供服务，那么需要在同一文件中添加另一（几乎相同的）项，以便启用 443 端口。

因此，首先需要在 *sites-available* 中创建此配置文件：`vi /etc/httpd/sites-available/com.wiki.www`

配置文件的配置内容如下所示：

```
<VirtualHost *:80>
        ServerName www.wiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.wiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.wiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.wiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.wiki.www-error_log"

        <Directory /var/www/sub-domains/com.wiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

创建文件后，需要写入（保存）该文件：`shift : wq`

在上面的示例中，wiki 站点是从 com.wiki.www 的 html 子目录加载的，这意味着需要在上面提到的 /var/www 中创建额外的目录才能满足要求：

```
mkdir -p /var/www/sub-domains/com.wiki.www/html
```

这将使用单个命令创建整个路径。接下来将文件安装到该目录中，该目录将实际运行该站点。这些文件可能是由您或您下载的应用程序（在本例中为 Wiki）创建的。将文件复制到上面的路径：

```
cp -Rf wiki_source/* /var/www/sub-domains/com.wiki.www/html/
```

## 配置 https —— 使用 SSL 证书[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https-ssl)

如前所述，如今创建的每台 web 服务器都应该使用 SSL（也称为安全套接字层）运行。

此过程首先生成私钥和 CSR（表示证书签名请求），然后将 CSR 提交给证书颁发机构以购买 SSL 证书。生成这些密钥的过程有些复杂，因此它有自己的文档。

如果您不熟悉生成 SSL 密钥，请查看：[生成 SSL 密钥](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/)

### 密钥和证书的位置[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_5)

现在您已经拥有了密钥和证书文件，此时需要将它们按逻辑放置在 Web 服务器上的文件系统中。正如在上面示例配置文件中所看到的，将 Web 文件放置在 */var/www/sub-domains/com.ourownwiki.www/html* 中。

我们建议您将证书和密钥文件放在域（domain）中，而不是放在文档根（document root）目录中（在本例中是 *html* 文件夹）。

如果不这样做，证书和密钥有可能暴露在网络上。那会很糟糕！

我们建议的做法是，将在文档根目录之外为 SSL 文件创建新目录：

```
mkdir -p /var/www/sub-domains/com.ourownwiki.www/ssl/{ssl.key,ssl.crt,ssl.csr}
```

如果您不熟悉创建目录的“树（tree）”语法，那么上面所讲的是：

创建一个名为 ssl 的目录，然后在其中创建三个目录，分别为 ssl.key、ssl.crt 和 ssl.csr。

提前提醒一下：对于 web 服务器的功能来说，CSR 文件不必存储在树中。

如果您需要从其他供应商重新颁发证书，则最好保存 CSR 文件的副本。问题变成了在何处存储它以便您记住，将其存储在 web 站点的树中是合乎逻辑的。

假设已使用站点名称来命名 key、csr 和 crt（证书）文件，并且已将它们存储在  */root* 中，那么将它们复制到刚才创建的相应位置：

```
cp /root/com.wiki.www.key /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/
cp /root/com.wiki.www.csr /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.csr/
cp /root/com.wiki.www.crt /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/
```

### 站点配置 —— https[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#https)

一旦生成密钥并购买了 SSL 证书，现在就可以使用新密钥继续配置 web 站点。

首先，分析配置文件的开头。例如，即使仍希望监听 80 端口（标准 http）上的传入请求，但也不希望这些请求中的任何一个真正到达 80 端口。

希望请求转到 443 端口（或安全的 http，著名的 SSL）。80 端口的配置部分将变得最少：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
```

这意味着要将任何常规 Web 请求发送到 https 配置。上面显示的 apache  “Redirect”选项可以在所有测试完成后更改为“Redirect  permanent”，此时站点应该就会按照您希望的方式运行。此处选择的“Redirect”是临时重定向。

搜索引擎将记住永久重定向，很快，从搜索引擎到您网站的所有流量都只会流向 443 端口（https），而无需先访问 80 端口（http）。

接下来，定义配置文件的 https 部分。为了清楚起见，此处重复了 http 部分，以表明这一切都发生在同一配置文件中：

```
<VirtualHost *:80>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.ourownwiki.com/
</VirtualHost>
<Virtual Host *:443>
        ServerName www.ourownwiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.ourownwiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.ourownwiki.www/cgi-bin/

    CustomLog "/var/log/httpd/com.ourownwiki.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.ourownwiki.www-error_log"

        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1
        SSLHonorCipherOrder on
        SSLCipherSuite EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384
:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

        SSLCertificateFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/com.wiki.www.crt
        SSLCertificateKeyFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.key/com.wiki.www.key
        SSLCertificateChainFile /var/www/sub-domains/com.ourownwiki.www/ssl/ssl.crt/your_providers_intermediate_certificate.crt

        <Directory /var/www/sub-domains/com.ourownwiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

因此，在配置的常规部分之后，直到 SSL 部分结束，进一步分析此配置：

- SSLEngine on —— 表示使用 SSL。
- SSLProtocol all -SSLv2 -SSLv3 -TLSv1 —— 表示使用所有可用协议，但发现有漏洞的协议除外。您应该定期研究当前可接受的协议。
- SSLHonorCipherOrder on —— 这与下一行的相关密码套件一起使用，并表示按照给出的顺序对其进行处理。您应该定期检查要包含的密码套件。
- SSLCertificateFile —— 新购买和应用的证书文件及其位置。
- SSLCertificateKeyFile —— 创建证书签名请求时生成的密钥。
- SSLCertificateChainFile —— 来自证书提供商的证书，通常称为中间证书。

接下来，将所有内容全部上线，如果启动 Web 服务没有任何错误，并且如果转到您的网站显示没有错误的 https，那么您就可以开始使用。

## 生效[¶](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/#_6)

注意，*httpd.conf* 文件在其末尾包含 */etc/httpd/sites-enabled*，因此，httpd 重新启动时，它将加载该 *sites-enabled* 目录中的所有配置文件。事实上，所有的配置文件都位于 *sites-available*。

这是设计使然，以便在 httpd 重新启动失败的情况下，可以轻松移除内容。因此，要启用配置文件，需要在 *sites-enabled* 中创建指向配置文件的符号链接，然后启动或重新启动 Web 服务。为此，使用以下命令：

```
ln -s /etc/httpd/sites-available/com.wiki.www /etc/httpd/sites-enabled/
```

这将在 *sites-enabled* 中创建指向配置文件的链接。

现在只需使用 `systemctl start httpd` 来启动 httpd。如果它已经在运行，则重新启动：`systemctl restart httpd`。假设网络服务重新启动，您现在可以在新站点上进行一些测试。



# `mod_ssl` on Rocky Linux in an httpd Apache Web-Server Environment[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#mod_ssl-on-rocky-linux-in-an-httpd-apache-web-server-environment)

Apache Web-Server has been used for many years now; `mod_ssl`is used to provide greater security for the Web-Server and can be  installed on almost any version of Linux, including Rocky Linux. The  installation of `mod_ssl` will be part of the creation of a Lamp-Server for Rocky Linux.

This procedure is designed to get you up and running with Rocky Linux using `mod_ssl` in an Apache Web-Server environment..

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#prerequisites)

- A Workstation or Server, preferably with Rocky Linux already installed.
- You should be in the Root environment or type `sudo` before all of the commands you enter.

## Install Rocky Linux Minimal[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#install-rocky-linux-minimal)

When installing Rocky Linux, we used the following sets of packages:

- Minimal
- Standard

## Run System Update[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#run-system-update)

First, run the system update command to let the server rebuild the  repository cache, so that it could recognize the packages available.

```
dnf update
```

## Enabling Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#enabling-repositories)

With a conventional Rocky Linux Server Installation all necessary Repositories should be in place.

## Check The Available Repositories[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#check-the-available-repositories)

Just to be sure check your Repository Listing with:

```
dnf repolist
```

You should get the following back showing all of the enabled repositories:

```
appstream                                                        Rocky Linux 8 - AppStream
baseos                                                           Rocky Linux 8 - BaseOS
extras                                                           Rocky Linux 8 - Extras
powertools                                                       Rocky Linux 8 - PowerTools
```

## Installing Packages[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#installing-packages)

To install `mod_ssl`, run:

```
dnf install mod_ssl
```

To enable the `mod_ssl` module, run:

```
apachectl restart httpd` `apachectl -M | grep ssl
```

You should see an output as such:

```
ssl_module (shared)
```

## Open TCP port 443[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#open-tcp-port-443)

To allow incoming traffic with HTTPS, run:

```
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

At this point you should be able to access the Apache Web-Server via HTTPS. Enter `https://your-server-ip` or `https://your-server-hostname` to confirm the `mod_ssl` configuration.

## Generate SSL Certificate[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#generate-ssl-certificate)

To generate a new self-signed certificate for Host rocky8 with 365 days expiry, run:

```
openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/httpd.key -x509 -days 365 -out /etc/pki/tls/certs/httpd.crt
```

You will see the following output:



```
Generating a RSA private key
................+++++
..........+++++
writing new private key to '/etc/pki/tls/private/httpd.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:AU
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:LinuxConfig.org
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:rocky8
Email Address []:
```

After this command completes execution, the following two SSL files will be created, run:



```
ls -l /etc/pki/tls/private/httpd.key /etc/pki/tls/certs/httpd.crt

-rw-r--r--. 1 root root 1269 Jan 29 16:05 /etc/pki/tls/certs/httpd.crt
-rw-------. 1 root root 1704 Jan 29 16:05 /etc/pki/tls/private/httpd.key
```

## Configure Apache Web-Server with New SSL Certificates[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#configure-apache-web-server-with-new-ssl-certificates)

To include your newly created SSL certificate into the Apache web-server configuration open the ssl.conf file by running:

```
nano /etc/httpd/conf.d/ssl.conf
```

Then change the following lines:

FROM:

```
SSLCertificateFile /etc/pki/tls/certs/localhost.crt
SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
```

TO:

```
SSLCertificateFile /etc/pki/tls/certs/httpd.crt
SSLCertificateKeyFile /etc/pki/tls/private/httpd.key
```



Then reload the Apache Web-Server by running:

```
systemctl reload httpd
```

## Test the `mod_ssl` configuration[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#test-the-mod_ssl-configuration)

Enter the following in a web browser:

```
https://your-server-ip` or `https://your-server-hostname
```

## To Redirect All HTTP Traffic To HTTPS[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#to-redirect-all-http-traffic-to-https)

Create a new file by running:

```
nano /etc/httpd/conf.d/redirect_http.conf
```

Insert the following content and save file, replacing "your-server-hostname" with your hostname.

```
<VirtualHost _default_:80>

        Servername rocky8
        Redirect permanent / https://your-server-hostname/

</VirtualHost/>
```

Apply the change when reloading the Apache service by running:

```
systemctl reload httpd
```

The Apache Web-Server will now be configured to  redirect any incoming traffic from `http://your-server-hostname` to `https://your-server-hostname` URL.

## Final Steps[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#final-steps)

We have seen how to install and configure `mod_ssl`. And, create a new SSL Certificate in order to run a Web-Server under HTTPS Service.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/mod_SSL_apache/#conclusion)

This tutorial will be part of the tutorial covering installing a LAMP (Linux, Apache Web-Server, Maria Database-Server, and PHP Scripting  Language), Server on Rocky Linux version 8.x. Eventually we will be  including images to help better understand the installation.





# Apache Hardened Webserver[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#apache-hardened-webserver)

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#prerequisites-and-assumptions)

- A Rocky Linux web server running Apache
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- A comfort level with a command line editor (our examples use *vi* which will usually invoke the *vim* editor, but you can substitute your favorite editor)
- Assumes an *iptables* firewall, rather than *firewalld* or a hardware firewall.
- Assumes the use of a gateway hardware firewall that our trusted devices will sit behind.
- Assumes a public IP address directly applied to the web server. We  are substituting a private IP address for all of our examples.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#introduction)

Whether you are hosting multiple websites for customers, or a single, very important, website for your business, hardening your web server  will give you peace of mind, at the expense of a little more up-front  work for the administrator.

With multiple web sites uploaded by your customers, you can pretty  much be guaranteed that one of them will upload a Content Management  System (CMS) with the possibility of vulnerabilities. Most customers are focused on ease of use, not security, and what happens is that updating their own CMS becomes a process that falls out of their priority list  altogether.

While notifying customers of vulnerabilities in their CMS may be  possible for a company with a large IT staff, it may not be possible for a small department. The best defense is a hardened web server.

Web server hardening can take many forms, which may include any or all of the below tools, and possibly others not defined here.

You might elect to use a couple of these tools, and not the others,  so for clarity and readability this document is split out into separate  documents for each tool. The exception will be the packet-based firewall (*iptables*) which will be included in this main document.

- A good packet filter firewall based on ports (iptables, firewalld, or hardware firewall - we will use *iptables* for our example) [*iptables* procedure](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#iptablesstart)
- A Host-based Intrusion Detection System (HIDS), in this case *ossec-hids* [Apache Hardened Web Server - ossec-hids](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/ossec-hids/)
- A Web-based Application Firewall (WAF), with *mod_security* rules [Apache Hardened Web Server - mod_security](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/modsecurity/)
- Rootkit Hunter (rkhunter): A scan tool that checks against Linux malware [Apache Hardened Web Server - rkhunter](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/)
- Database security (we are using *mariadb-server* here) [MariaDB Database Server](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/)
- A secure FTP or SFTP server (we are using *vsftpd* here) [Secure FTP Server - vsftpd](https://docs.rockylinux.org/zh/guides/file_sharing/secure_ftp_server_vsftpd/)

This procedure does not replace the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/), it simply adds these security elements to it. If you haven't read it, take some time to look at it before proceeding.

## Other Considerations[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#other-considerations)

Some of the tools outlined here have both free and fee-based options. Depending on your needs or support requirements, you may want to  consider the fee-based versions. You should research what is out there  and make a decision after weighing all of your options.

Know, too, that most of these options can be purchased as hardware  appliances. If you'd prefer not to hassle with installing and  maintaining your own system, there are options available other than  those outlined here.

This document uses a straight *iptables* firewall and requires [this procedure on Rocky Linux to disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/).

If you prefer to use *firewalld*, simply skip this step and  apply the rules needed. The firewall in our examples here, needs no  OUTPUT or FORWARD chains, only INPUT. Your needs may differ!

All of these tools need to be tuned to your system. That can only be  done with careful monitoring of logs, and reported web experience by  your customers. In addition, you will find that there will be ongoing  tuning required over time.

Even though we are using a private IP address to simulate a public one, all of this *could* have been done using a one-to-one NAT on the hardware firewall and  connecting the web server to that hardware firewall, rather than to the  gateway router, with a private IP address.

Explaining that requires digging into the hardware firewall shown  below, and since that is outside of the scope of this document, it is  better to stick with our example of a simulated public IP address.

## Conventions[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conventions)

- **IP Addresses:** We are simulating the public IP  address here with a private block: 192.168.1.0/24 and we are using the  LAN IP address block as 10.0.0.0/24  In other words, it cannot be routed over the Internet. In reality, neither IP block can be routed over the  Internet as they are both reserved for private use, but there is no good way to simulate the public IP block, without using a real IP address  that is assigned to some company. Just remember that for our purposes,  the 192.168.1.0/24 block is the "public" IP block and the 10.0.0.0/24 is the "private" IP block.
- **Hardware Firewall:** This is the firewall that controls access to your server room devices from your trusted network. This is not the same as our *iptables* firewall, though it could be another instance of *iptables* running on another machine. This device will allow ICMP (ping) and SSH  (secure shell) to our trusted devices. Defining this device is outside  of the scope of this document. The author has used both [PfSense](https://www.pfsense.org/) and [OPNSense](https://opnsense.org/) and installed on dedicated hardware for this device with great success. This device will have two IP addresses assigned to it. One that will  connect to the Internet router's simulated public IP (192.168.1.2) and  one that will connect to our local area network, 10.0.0.1.
- **Internet Router IP:** We are simulating this with 192.168.1.1/24
- **Web Server IP:** This is the "public" IP address  assigned to our web server. Again, we are simulating this with the  private IP address 192.168.1.10/24

![Hardened Webserver](https://docs.rockylinux.org/guides/web/apache_hardened_webserver/images/hardened_webserver_figure1.jpeg)

The diagram above shows our general layout. The *iptables* packet-based firewall runs on the web server (shown above).

## Install Packages[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#install-packages)

Each individual package section has the needed installation files and any configuration procedure listed. The installation instructions for *iptables* is part of the [disable firewalld and enable the iptables services](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/) procedure.

## Configuring iptables[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#configuring-iptables)

This portion of the documentation assumes that you have elected to install the *iptables* services and utilities and that you are not planning on using *firewalld*.

If you are planning on using *firewalld*, you can use this *iptables* script to guide you in creating the appropriate rules in the *firewalld* format. Once the script is shown here, we will break it down to  describe what is happening. Only the INPUT chain is needed here. The  script is being placed in the /etc/ directory and for our example, it is named firewall.conf:

```
vi /etc/firewall.conf
```

and the contents will be:



```
#!/bin/sh
#
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m tcp -s 192.168.1.2 --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -s 192.168.1.2 -j ACCEPT
# dns rules
iptables -A INPUT -p udp -m udp -s 8.8.8.8 --sport 53 -d 0/0 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 8.8.4.4 --sport 53 -d 0/0 -j ACCEPT
# web ports
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# ftp ports
iptables -A INPUT -p tcp -m tcp --dport 20-21 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 7000-7500 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

So here's what is happening above:



- When we start, we flush all of the rules
- We then set the default policy for our INPUT chain to DROP, which  says, "Hey, if we haven't explicitly allowed you here, then we are  dropping you!"
- Then we allow SSH (port 22) from our trusted network, the devices behind the hardware firewall
- We allow DNS from some public DNS resolvers. (these can also be local DNS servers, if you have them)
- We allow our web traffic in from anywhere over port 80 and 443.
- We allow standard FTP (ports 20-21) and the passive ports needed to  exchange two-way communications in FTP (7000-7500). These ports can be  arbitrarily changed to other ports based on your ftp server  configuration.
- We allow any traffic on the local interface (127.0.0.1)
- Then we say, that any traffic that has successfully connected based  on the rules, should be allowed other traffic (ports) to maintain their  connection (ESTABLISHED,RELATED).
- And finally, we reject all other traffic and set the script to save the rules where *iptables* expects to find them.

Once this script is there, we need to make it executable:

```
chmod +x /etc/firewall.conf
```

We need to enable *iptables* if we haven't already:

```
systemctl enable iptables
```

We need to start *iptables*:

```
systemctl start iptables
```

We need to run /etc/firewall.conf:

```
/etc/firewall.conf
```

If we add new rules to the /etc/firewall.conf, just run it again to  take those rules live. Keep in mind that with a default DROP policy for  the INPUT chain, if you make a mistake, you could lock yourself out  remotely.

You can always fix this however, from the console on the server. Because the *iptables* service is enabled, a reboot will restore all rules that have been added with `/etc/firewall.conf`.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/#conclusion)

There are a number of ways to harden an Apache web server to make it  more secure. Each operates independently of the other options, so you  can choose to install any, or all, of them based on your needs.

Each requires some configuration with various tuning required for  some to meet your specific needs. Since web services are constantly  under attack 24/7 by unscrupulous actors, implementing at least some of  these will help an administrator sleep at night.



