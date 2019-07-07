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