# Collectd

collectd – The system statistics collection daemon

collectd is a daemon which collects system and application performance metrics periodically and provides mechanisms to store the values in a variety of ways, for example in RRD files.
Collectd for Windows
http://ssc-serv.com/
High-resolution system metrics. Download free trial version!
Advertisement
What does collectd do?

collectd gathers metrics from various sources, e.g. the operating system, applications, logfiles and external devices, and stores this information or makes it available over the network. Those statistics can be used to monitor systems, find performance bottlenecks (i.e. performance analysis) and predict future system load (i.e. capacity planning). Or if you just want pretty graphs of your private server and are fed up with some homegrown solution you're at the right place, too ;).

A graph can say more than a thousand words, so here's a graph showing the CPU utilization of a system over the last 60 minutes:
Graph of CPU utilization
Why collectd?

There are other free, open source projects that are similar to collectd – a few links are listed on the related sites page. So why should you use collectd? There are some key differences we think set collectd apart. For one, it's written in C for performance and portability, allowing it to run on systems without scripting language or cron daemon, such as embedded systems. For example, collectd is popular on OpenWrt, a Linux distribution for home routers. At the same time it includes optimizations and features to handle hundreds of thousands of metrics. The daemon comes with over 100 plugins which range from standard cases to very specialized and advanced topics. It provides powerful networking features and is extensible in numerous ways. Last but not least: collectd is actively developed and supported and well documented. A more complete list of features is available.
Limitations

While collectd can do a lot for you and your administrative needs, there are limits to what it does:

    It does not generate graphs. It can write to RRD files, but it cannot generate graphs from these files. There's a tiny sample script included in contrib/, though. Take a look at kcollectd, an X frontend, and drraw, a very generic solution, though. More utility programs are listed on the related projects page.
    Monitoring functionality has been added in version 4.3, but is so far limited to simple threshold checking. The document “Notifications and thresholds” describes collectd's monitoring concept and has some details on the limitations, too. Also, there's a plugin for Nagios, so it can use the values collected by collectd.

Imprint | Facebook | Github | Google+ (Community) | identi.ca | Twitter | Xing




## 架构
![](../../Image/a/x.png)
## 1.安装
### CentOS 6/7
1.安装软件库epel

    yum  install  epel-release
2.安装Collectd  

    yum  install  collectd
### Debian

    apt-get install collectd
## 2.启动
### CentOS 6
    service  collectd  start
    chkconfig collectd on
### CentOS 7
    systemctl start collectd.service
    systemctl enable collectd.service
### Debian
    service collectd start
    chkconfig collectd on


## 前端软件
| Name                 | Type        | Framework                                | Engine            | Flush   |
| -------------------- | ----------- | ---------------------------------------- | ----------------- | ------- |
| Collectd Graph Panel | Web-based   | PHP                                      | RRDtool           | Yes     |
| Collectd Graph Z     | Web-based   | PHP (based on CGP)                       | RRDtool           | Yes     |
| Collectd-web         | Web-based   | CGI                                      | RRDtool           | No      |
| CollectGraph         | Web-based   | MoinMoin wiki                            | unknown           | unknown |
| Collection 3         | Web-based   | CGI                                      | RRDtool           | Yes     |
| Collection 4         | Web-based   | FastCGI                                  | gRaphaël, RRDtool | No      |
| Collectd-carbon      | Web-based   | Django                                   | Graphite/Carbon   | No      |
| collectw             | Web-based   | FastCGI                                  | gRaphaël          | No      |
| EcoStats             | Web-based   | CGI                                      | RRDtool           | No      |
| Facette              | Web-based   | Go http package                          | HighCharts        | Yes     |
| Heymon               | Web-based   | Ruby on Rails                            | RRDtool           | No      |
| Jarmon               | Web-based   | jQuery, Javascript RRD, Flowplayer Tools, (Twisted) | Flot              | No      |
| kcollectd            | Stand-alone | KDE                                      | Qt                | No      |
| Observium            | Web-based   | PHP                                      | RRDtool           | Yes     |
| PerfWatcher          | Web-based   | PHP                                      | RRDtool           | Yes     |
| Visage               | Web-based   | Ruby + Sinatra, MooTools                 | HighCharts (SVG)  | No      |
| Vizir                | Web-based   | Ruby on Rails                            | Rickshaw/D3js     | Yes     |
| Sick Muse            | Web-based   | Python, jQuery, Backbone.js              | Flot              | unknown |
| RRDscout             | Web-based   | Python, Flask                            | RRDtool           | unknown |

Legend

Type  
       Type of front-end. Currently the categories are Web-based and Stand-alone.

Framework  
       Execution framework used.

Engine  
       Program or library used for drawing graphs from the available data.

Flush  
       Whether or not the front-end is able to send a FLUSH command to the daemon before querying the data for the graph. This is interesting when the CacheTimeout option of the RRDtool plugin has been set to a high value.

## Collectd-web
Collectd-web是一款基于RRDtool的Web前端监控工具，能够解读并以图形化方式输出由Collectd服务收集的数据。  
### 安装Collectd-web
1.安装Git  
**Debian / Ubuntu**

    apt-get install git
    apt-get install librrds-perl libjson-perl libhtml-parser-perl
**RedHat/CentOS/Fedora**

    yum install git
    yum install rrdtool rrdtool-devel rrdtool-perl perl-HTML-Parser perl-JSON
2.导入Collectd-Web Git软件库，并修改独立式Python服务器

    cd /usr/local/
    git clone https://github.com/httpdss/collectd-web.git
3.进入到collectd-web目录，修改Python服务器脚本(runserver.py)，为graphdefs.cgi添加执行权限。  

    cd collectd-web/
    chmod +x cgi-bin/graphdefs.cgi
4.Collectd-web独立式Python服务器脚本默认情况下已配置成运行、只绑定回送地址(127.0.0.1)。为了从远程浏览器访问Collectd-web界面，需要编辑runserver.py脚本，并将127.0.1.1 IP地址改成0.0.0.0，那样才能绑定所有的网络接口IP地址。只绑定某个特定的接口，那么使用该接口的IP地址。
nano runserver.py
如果你想使用8888之外的另一个网络端口，修改PORT变量值。
第4步：运行Python CGI独立式服务器，浏览Collectd-web界面
7. 你修改了独立式Python服务器脚本IP地址绑定后，只管启动后台服务器，为此只要执行下面这个命令：
  ./runserver.py &
  另外一个办法就是，你可以调用Python解释器，启动服务器：
  python runserver.py &
8. 想访问Collectd-web界面，并显示关于你主机的统计信息，不妨打开浏览器，使用HTTP协议，让URL指向你服务器的IP地址和端口8888。
  默认情况下，你会看到关于处理器、磁盘使用情况、网络流量、内存、进程及其他系统资源的许多图形，只要点击上Hosts(主机)表单上所显示的主机名称。
  http://192.168.1.211:8888
9. 想停止独立式Python服务器，执行下面这个命令，或者可以按Ctrl+c键来取消或停止脚本：
  killall python
  构建自定义Bash脚本，以管理独立式Python服务器
  想更轻松地管理独立式PyhtonCGIServer脚本(启动、停止和查看状态)，不妨在系统可执行路径下构建下列collectd-server Bash脚本，并使用下列配置：
  nano /usr/local/bin/collectd-server
  将下列内容添加到collectd-server文件。
#!/bin/bash
PORT="8888"
case $1 in
start)
cd /usr/local/collectd-web/
python runserver.py 2> /tmp/collectd.log &
sleep 1
stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
if [[ $PORT -eq $stat ]]; then
sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
echo -e "Server is  still running:\n$sock"
else
echo -e "Server has stopped"
fi
;;
stop)
pid=`ps -x | grep "python runserver.py" | grep -v "color"`
kill -9 $pid 2>/dev/null
stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
if [[ $PORT -eq $stat ]]; then
sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
echo -e "Server is  still running:\n$sock"
else
echo -e "Server has stopped"
fi
;;
status)
stat=`netstat -tlpn 2>/dev/null |grep $PORT| grep "python" | cut -d":" -f2 | cut -d" " -f1`
if [[ $PORT -eq $stat ]]; then
sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
echo -e "Server is running:\n$sock"
else
echo -e "Server is stopped"
fi
;;
*)
echo "Use $0 start|stop|status"
;;
esac

一你更改了runserver.py脚本的PORT变量值，就要确保你相应地对该bash文件更改了端口变量。
11. 一旦你构建了collectd-server脚本，添加执行权限，以便能够运行它。现在唯一剩下来的事情就是，以类似管理系统服务的方式来管理Collectd-web服务器，为此执行下列命令。
# chmod +x /usr/local/bin/collectd-server
# collectd-server start
 collectd-server status
 collectd-server stop
如何安装配置Collectd和Collectd-Web监控服务器资源?
Collectd服务器脚本
第6步：启用Collectd守护程序插件
12. 为了激活Collectd服务方面的插件，你必须进入到其主配置文件，该文件位于/etc/collectd/collectd.conf，打开该文件，即可编辑和取消注释，即可以去掉你想激活的插件名称前面的那个#符号。
   一旦带插件名称的LoadPlugin语句被取消了注释，你就必须深入搜寻整个文件，找到含有运行所需配置的同一个插件名称。
   举例说，下面介绍了如何激活Collectd Apache插件。首先打开Collectd主配置文件，以便编辑：
# nano /etc/collectd/collectd.conf
A. 使用Ctrl+w键，开启nano编辑工具搜索，并在提交搜索的下列终端上输入apache。一旦找到了LoadPlugin apache语句，去掉注释特殊符号#，即可取消注释，如下列屏幕截图示。
Collectd守护程序插件
启用Collectd Apache插件
B. 下一步，键入Ctrl+w键，即可再次搜索，apache应该已经出现在提交的搜索上，按回车键，即可找到插件配置。
一旦找到了apache插件配置(它们看起来类似Apache web服务器语句)，取消下列几行的注释，那样最后的配置应该看起来像这样：
<Plugin apache>
<Instance "example.lan">
                        URL "http://localhost/server-status?auto"  
        #               User "www-user"  
        #               Password "secret"  
        #               VerifyPeer false  
        #               VerifyHost false  
        #               CACert "/etc/ssl/ca.crt"  
        #               Server "apache"  
                </Instance>
        #  
        #       <Instance "bar">
        #               URL "http://some.domain.tld/status?auto"  
        #               Host "some.domain.tld"  
        #               Server "lighttpd"  
        #       </Instance>
        </Plugin>

C. 在你完成文件编辑后，保存文件(Ctrl+o)并关闭文件(Ctrl+x)，然后重启Collectd守护程序，让变更内容生效。清空浏览器缓存，重新装入页面，查看Collectd守护程序到目前为止为Apache Web服务器收集的统计信息。
# /usr/local/bin/collectd-server start
Apache监控
Apache监控
想启用其他插件，请访问Collectd维基页面(https://collectd.org/wiki/index.php/Table_of_Plugins)。
第7步：在整个系统范围启用Collectd守护程序和Collectd-web服务器
13. 为了在系统启动时通过Bash脚本自动启动Collectd-web服务器，打开/etc/rc.local文件以编辑，并在exit 0语句前面添加下面这一行：
   /usr/local/bin/collectd-server start
   启用Collectd守护程序和Collectd-web服务器
   在整个系统范围启用Collectd
   如果你不使用管理Python服务器脚本的collectd-server Bash脚本，就把rc.conf中的上述行换成下面这一行：
# cd /usr/local/collectd-web/ && python runserver.py 2> /tmp/collectd.log &
然后，执行下列命令，启用这两项系统服务：
------------------ On Debian / Ubuntu ------------------
# update-rc.d collectd enable
# update-rc.d rc.local enable
系统启动时启用这项服务的另外一种方法就是，借助sysv-rc-conf程序包：
  ------------------ On Debian / Ubuntu ------------------
# sysv-rc-conf collectd on
# sysv-rc-conf rc.local on
------------------ On RHEL/CentOS 6..x/5.x and Fedora 12-19 ------------------
# chkconfig collectd on
# chkconfig --level 5 collectd on
------------------ On RHEL/CentOS 7.x and Fedora 20 onwards ------------------
# systemctl enable collectd

# 

There are currently two "major versions" of collectd: Version 4 and version 5. This is the first number of the full version number of a release. Version 4 is outdated and should not be used for new setups anymore, so make sure you get a version that starts with "5.*".

To get the executable binaries, you have the choice between two possibilities: Find a binary package or compile the source yourself. We strongly recommend to use a binary package unless you have very specific needs.

##   Get a binary package 

For many Linux distributions there are binary packages. Please make sure not to use the old version 4 (Debian Squeeze ships version 4.10.1, for example). Pointers to available binary packages can be found on the [download page](http://collectd.org/download.shtml).

##   Compiling the sources 

If there is no binary package for your distribution, or the one existing is outdated, you can compile the sources. For that you will need to install the usual C-compiler (most likely called "gcc"), linker, and so on. Debian users can simply install the `build-essential` package:

```
# apt-get install build-essential 

```

The daemon itself doesn't depend on any libraries, but the plugins that collect the actual values will. What libraries are needed for which plugins is documented in the [README](http://git.verplant.org/?p=collectd.git;a=blob;hb=master;f=README) file. Install the necessary libraries:

```
# apt-get install librrd2-dev libsensors-dev libsnmp-dev ...

```

After installing the build dependencies, you need to get and unpack the sources:

```
# cd /tmp/
# wget http://collectd.org/files/collectd-x.y.z.tar.bz2
# tar jxf collectd-x.y.z.tar.bz2
# cd collectd-x.y.z

```

Now configure the sources with the usual:

```
# ./configure 

```

After the `configure` script is done it will display a summary of the libraries it has found (and not found) and which plugins are enabled. Per default, all plugins whose dependencies are met are enabled. If a plugin you want to use is missing, install the required development package and run `configure` again.

Last but not least: Compile and install the program. Per default it will be installed to `/opt/collectd`. If you prefer another directory, call the `configure` script with the `--prefix` option.

```
# make all install
# cd /opt/collectd/

```

#   Configuration 

The configuration will lie in `<prefix>/etc/collectd.conf`. It's manual page is [collectd.conf(5)](http://collectd.org/documentation/manpages/collectd.conf.5.shtml). Open the file and pay particular attention to the `LoadPlugin` lines.

```
# vim etc/collectd.conf

```

##   Loading plugins 


If you built the daemon **from source**, the `configure` script tries hard to provide you with a small, working default configuration. The configuration can usually be found in `etc/collectd.conf`.

For each plugin, there is a `LoadPlugin` line in the configuration. Almost all of those lines are commented out in order to keep the default configuration lean. However, the number of comment characters used is significant:

-  Lines commented out with two hash characters ("##") belong to plugins that have *not* been built. Commenting these lines in will result in an error, because the plugin does not exist.
-  The `LoadPlugin` lines commented out using one hash character ("#") belong to plugins that have been built. You can comment them in / out as you wish.
-  By default the following plugins are *enabled*: [CPU](https://collectd.org/wiki/index.php/Plugin:CPU), [Interface](https://collectd.org/wiki/index.php/Plugin:Interface), [Load](https://collectd.org/wiki/index.php/Plugin:Load), and [Memory](https://collectd.org/wiki/index.php/Plugin:Memory).

By default exactly one write plugin is enabled. The first plugin available will be taken in this order: [RRDtool](https://collectd.org/wiki/index.php/Plugin:RRDtool), [Network](https://collectd.org/wiki/index.php/Plugin:Network), [CSV](https://collectd.org/wiki/index.php/Plugin:CSV).

Likewise only one log plugin is enabled. If available, the [SysLog](https://collectd.org/wiki/index.php/Plugin:SysLog) plugin will be enabled, otherwise the [LogFile](https://collectd.org/wiki/index.php/Plugin:LogFile) plugin is used.

If you installed a **binary package**, the package vendor has hopefully enabled only a small number of standard plugins. Please see the binary package's documentation to find out which other plugins are included and can be enabled. There's a wiki page containing a [table of all plugins](https://collectd.org/wiki/index.php/Table_of_Plugins).

The following is a list of the very basic plugins and a short description:

| Name                                     | Type    | Description                              |
| ---------------------------------------- | ------- | ---------------------------------------- |
| [LogFile](https://collectd.org/wiki/index.php/Plugin:LogFile) | logging | Writes log messages to a file or standard output |
| [SysLog](https://collectd.org/wiki/index.php/Plugin:SysLog) | logging | Writes debug and status information to syslog. |
| [RRDtool](https://collectd.org/wiki/index.php/Plugin:RRDtool) | output  | Writes data to RRD files                 |
| [CSV](https://collectd.org/wiki/index.php/Plugin:CSV) | output  | Writes data to CSV files                 |
| [CPU](https://collectd.org/wiki/index.php/Plugin:CPU) | input   | Collects CPU usage                       |
| [Memory](https://collectd.org/wiki/index.php/Plugin:Memory) | input   | Collects memory usage                    |
| [Interface](https://collectd.org/wiki/index.php/Plugin:Interface) | input   | Collects traffic of network interfaces   |

##   Setting options 

The [Interval](https://collectd.org/wiki/index.php/Interval) setting controls how often values are read. You should set this once and then never touch it again. If you do, **you will have to delete all your RRD files** or know some serious RRDtool magic!

To have the daemon resolve the local *fully qualified host-name* (FQDN) and use this as the name of the current instance, set the [FQDNLookup](https://collectd.org/wiki/index.php/FQDNLookup) option to *true*. The system's host-name must be set correctly for this to work. Using this method is recommended.

Some plugins take an additional configuration. Of interest here are the [LogFile](https://collectd.org/wiki/index.php/Plugin:LogFile) and [RRDtool](https://collectd.org/wiki/index.php/Plugin:RRDtool) plugins. Before setting anything explicitly, please read the relevant part of the [collectd.conf(5)](http://collectd.org/documentation/manpages/collectd.conf.5.shtml) manpage. There are *no* undocumented options. The [RRDtool](https://collectd.org/wiki/index.php/Plugin:RRDtool) plugin is especially prone of mis-configuration, please read the manual page especially careful when configuring this plugin.

#   Starting the daemon 

If you're done configuring, you need to (re-)start the daemon. If you installed a binary package there should be an `init`-script somewhere. Under Debian, the command would be:

```
# /etc/init.d/collectd restart

```

If your system (Fedora, ArchLinux, OpenSUSE, etc.) is using [systemd](http://www.freedesktop.org/wiki/Software/systemd/) for managing services:

```
# systemctl start collectd.service

```

and to enable the service:

```
# systemctl enable collectd.service

```

Alternatively you can start the daemon "by hand". This is done by executing:

```
# /opt/collectd/sbin/collectd

```

or (if you are using a binary package):

```
# /usr/sbin/collectd

```

Some plugins require root privileges to work properly. If you're missing graphs and/or see error messages that indicate insufficient permissions, restart collectd as root.

The daemon should now collect values using the "input" plugins you've loaded and write them to files using the "output" plugin(s). Any problems or interesting behavior is reported using the "log" plugin(s).

Congratulations, as far as collectd is concerned, you're all set! :)

#   Creating graphs 

First off: **It is not collectd's focus to generate graphs!** [Other projects offer this.](https://collectd.org/wiki/index.php/List_of_front-ends) The focus is to collect the values and write it to files or send it to another host over a network. But since we have to visualize the data somehow, too, we have been nice enough to throw a script that's *good enough for us* into the `contrib/` directory. This script, however, is not part of collectd and not supported by us. It just happens to work sometimes.

That being said, here's how it's installed: In the `contrib/` directory (or the directory `/usr/share/doc/collectd/examples/` if you installed the Debian package) you will find a directory named `collection3`. This directory holds all the necessary files for the graph generation, grouped again in subdirectories. Copy the entire directory somewhere, where your web server expects to find something.

```
# cp -r contrib/collection3 /var/www/
# cd /var/www/collection3/

```

In the subdirectory `bin/` are the CGI scripts, which must be executed by the web-server. In the `share/` subdirectory, there are supplementary files, such as style-sheets, which must not be executed. Since execution of files can't be turned off in directories referenced via `ScriptAlias`, using the standard `cgi-bin` directory provided by most distributions is probably problematic.

In some of the subdirectories, you will find files named `.htaccess`. They (try to) configure the web server, so that the appropriate files are executed, others are denied to visitors and so on. Please make sure to set the Apache option `AllowOverride` to an appropriate value or move the configuration to the main Apache configuration.

The script is written in Perl and requires a number of Perl modules to be installed. Many of them are shipped with the standard Perl distributions, but some you will need to install yourself. Here's a (hopefully complete) list:

-  RRDs
-  Config::General
-  HTML::Entities (Debian package `libhtml-parser-perl`)
-  Regexp::Common

```
# sudo apt-get install librrds-perl libconfig-general-perl libhtml-parser-perl  libregexp-common-perl

```

If everything worked out alright, you can now browse your graphs at `http://localhost/collection3/bin/index.cgi`
 or wherever you put the script. If you get an error, check Apache's 
error log. Common errors include wrong permissions on the files in `bin/` (they need to be executable) and `etc/` (needs to be readable by the web server). For web server specific problems, please refer to [this how-to on CGI scripts](http://httpd.apache.org/docs/2.2/howto/cgi.html).

There are also a couple of further, third-party front-ends available with a different focus each. Have a look at the [list of front-ends](https://collectd.org/wiki/index.php/List_of_front-ends) for an overview.