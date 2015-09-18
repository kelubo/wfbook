# Logstash
## 安装
安装 Java：

    yum install openjdk-jre
    export JAVA_HOME=/usr/java
    tar zxvf logstash-1.5.1.tar.gz

用 Elasticsearch 官方仓库来直接安装 Logstash：  
**Debian 平台**

    wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
    cat >> /etc/apt/sources.list <<EOF
    deb http://packages.elasticsearch.org/logstash/1.5/debian stable main
    EOF
    apt-get update
    apt-get install logstash

**Redhat 平台**

    rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    cat > /etc/yum.repos.d/logstash.repo <<EOF
    [logstash-1.5]
    name=logstash repository for 1.5.x packages
    baseurl=http://packages.elasticsearch.org/logstash/1.5/   centos
    gpgcheck=1
    gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    enabled=1
    EOF
    yum clean all
    yum install logstash

## 运行示例
在终端中，像下面这样运行命令来启动 Logstash 进程：

    # bin/logstash -e 'input{stdin{}}output{stdout{codec=>rubydebug}}'

会发现终端在等待你的输入。敲入 Hello World，回车，会返回结果：

    {
          "message" => "Hello World",
          "@version" => "1",
        "@timestamp" => "2014-08-07T10:30:59.937Z",
              "host" => "raochenlindeMacBook-Air.local",
    }

### 解释
Logstash 是用不同的线程来实现这些的。运行 top 命令然后按下 H 键，你就可以看到下面这样的输出：

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                          
    21401 root      16   0 1249m 303m  10m S 18.6  0.2 866:25.46 |worker                           
    21467 root      15   0 1249m 303m  10m S  3.7  0.2 129:25.59 >elasticsearch.                   
    21468 root      15   0 1249m 303m  10m S  3.7  0.2 128:53.39 >elasticsearch.                   
    21400 root      15   0 1249m 303m  10m S  2.7  0.2 108:35.80 <file                             
    21403 root      15   0 1249m 303m  10m S  1.3  0.2  49:31.89 >output                           
    21470 root      15   0 1249m 303m  10m S  1.0  0.2  56:24.24 >elasticsearch.

logstash 给每个线程都取了名字，输入的叫xx，过滤的叫|xx  
数据在线程之间以 事件 的形式流传。不要叫行，因为 logstash 可以处理多行事件。  
Logstash 会给事件添加一些额外信息。最重要的就是 @timestamp，用来标记事件的发生时间。使用 filters/date 插件 来管理这个特殊字段。  
此外，大多数时候，还可以见到另外几个：

    host 标记事件发生在哪里。
    type 标记事件的唯一类型。
    tags 标记事件的某方面属性。这是一个数组，一个事件可以有多个标签。

>小贴士：每个 logstash 过滤插件，都会有四个方法叫 add_tag, remove_tag, add_field 和
 remove_field。它们在插件过滤匹配成功时生效。

## 配置语法
Logstash 社区通常习惯用 shipper，broker 和 indexer 来描述数据流中不同进程各自的角色。如下图：
![](../Image/logstash-arch.jpg)
### 语法
#### 区段(section)
用 {} 来定义区域。区域内可以包括插件区域定义，你可以在一个区域内定义多个插件。插件区域内则可以定义键值对设置。示例如下：

    input {
        stdin {}
        syslog {}
    }

#### 数据类型
Logstash 支持少量的数据值类型：  

>* bool

    debug => true

>* string

    host => "hostname"

>* number

    port => 514

>* array

    match => ["datetime", "UNIX", "ISO8601"]

>* hash

    options => {
        key1 => "value1",
        key2 => "value2"
    }

注意：如果你用的版本低于 1.2.0，哈希的语法跟数组是一样的，像下面这样写：

    match => [ "field1", "pattern1", "field2", "pattern2" ]

#### 字段引用(field reference)
字段是 Logstash::Event 对象的属性。  
如果你想在 Logstash 配置中使用字段的值，只需要把字段的名字写在中括号 [] 里就行了，这就叫字段引用。  
对于 嵌套字段(也就是多维哈希表，或者叫哈希的哈希)，每层的字段名都写在 [] 里就可以了。比如，你可以从 geoip 里这样获取 longitude 值(是的，这是个笨办法，实际上有单独的字段专门存这个数据的)：

    [geoip][location][0]

小贴士：logstash 的数组也支持倒序下标，即 [geoip][location][-1] 可以获取数组最后一个元素的值。  
Logstash 还支持变量内插，在字符串里使用字段引用的方法是这样：

    "the longitude is %{[geoip][location][0]}"

#### 条件判断(condition)
表达式支持下面这些操作符：

    equality, etc: ==, !=, <, >, <=, >=
    regexp: =~, !~
    inclusion: in, not in
    boolean: and, or, nand, xor
    unary: !()

通常来说，你都会在表达式里用到字段引用。比如：

    if "_grokparsefailure" not in [tags] {
    } else if [status] !~ /^2\d\d/ and [url] == "/noc.gif" {
    } else {
    }

### 命令行参数
Logstash 提供了一个 shell 脚本叫 logstash 方便快速运行。它支持一下参数：

    -e

意即执行。这个参数的默认值是下面这样：

input {
    stdin { }
}
output {
    stdout { }
}

    --config 或 -f

意即文件。此外，logstash 还提供一个方便我们规划和书写配置的小功能。你可以直接用 bin/logstash -f /etc/logstash.d/ 来运行。logstash 会自动读取 /etc/logstash.d/ 目录下所有的文本文件，然后在自己内存里拼接成一个完整的大配置文件，再去执行。

    --configtest 或 -t

意即测试。用来测试 Logstash 读取到的配置文件语法是否能正常解析。Logstash 配置语法是用 grammar.treetop 定义的。

    --log 或 -l

意即日志。Logstash 默认输出日志到标准错误。生产环境下你可以通过 bin/logstash -l logs/logstash.log 命令来统一存储日志。

    --filterworkers 或 -w

意即工作线程。Logstash 会运行多个线程。你可以用 bin/logstash -w 5 这样的方式强制 Logstash 为过滤插件运行 5 个线程。  
注意：Logstash目前还不支持输入插件的多线程。而输出插件的多线程需要在配置内部设置，这个命令行参数只是用来设置过滤插件的！  
提示：Logstash 目前不支持对过滤器线程的监测管理。如果 filterworker 挂掉，Logstash 会处于一个无 filter 的僵死状态。这种情况在使用 filter/ruby 自己写代码时非常需要注意，很容易碰上 NoMethodError: undefined method '*' for nil:NilClass 错误。需要妥善处理，提前判断。

    --pluginpath 或 -P

可以写自己的插件，然后用 bin/logstash --pluginpath /path/to/own/plugins 加载它们。  
小贴士：如果你使用的 Logstash 版本高于 1.5.0-rc3，该参数已经被取消，请阅读插件开发章节，改成本地 gem 插件安装形式。

    --verbose

输出一定的调试日志。  
小贴士：如果你使用的 Logstash 版本低于 1.3.0，你只能用 bin/logstash -v 来代替。

    --debug

输出更多的调试日志。  
小贴士：如果你使用的 Logstash 版本低于 1.3.0，你只能用 bin/logstash -vv 来代替。
## plugin的安装
从 logstash 1.5.0 版本开始，logstash 将所有的插件都独立拆分成 gem 包。这样，每个插件都可以独立更新，不用等待 logstash 自身做整体更新的时候才能使用了。  
为了达到这个目标，logstash 配置了专门的 plugins 管理命令。
### plugin 用法说明

    Usage:
        bin/plugin [OPTIONS] SUBCOMMAND [ARG] ...

    Parameters:
        SUBCOMMAND                    subcommand
        [ARG] ...                     subcommand arguments

    Subcommands:
        install                       Install a plugin
        uninstall                     Uninstall a plugin
        update                        Install a plugin
        list                          List all installed plugins

    Options:
        -h, --help                    print help

### 示例
首先，你可以通过 bin/plugin list 查看本机现在有多少插件可用。(其实就在 vendor/bundle/jruby/1.9/gems/ 目录下)  
然后，假如你看到 https://github.com/logstash-plugins/ 下新发布了一个 logstash-output-webhdfs 模块(当然目前还没有)。打算试试，就只需要运行：

    bin/plugin install logstash-output-webhdfs

同样，假如是升级，只需要运行：

    bin/plugin update logstash-input-tcp

### 本地插件安装
bin/plugin 不单可以通过 rubygems 平台安装插件，还可以读取本地路径的 gem 文件。这对自定义插件或者无外接网络的环境都非常有效：

    bin/plugin install /path/to/logstash-filter-crash.gem

执行成功以后。你会发现，logstash-1.5.0 目录下的 Gemfile 文件最后会多出一段内容：

    gem "logstash-filter-crash", "1.1.0", :path => "vendor/local_gems/d354312c/logstash-filter-mweibocrash-1.1.0"

同时 Gemfile.jruby-1.9.lock 文件开头也会多出一段内容：

    PATH
      remote: vendor/local_gems/d354312c/logstash-filter-crash-1.1.0
      specs:
        logstash-filter-crash (1.1.0)
          logstash-core (>= 1.4.0, < 2.0.0)

## 长期运行
### 标准的 service 方式
采用 RPM、DEB 发行包安装的读者，推荐采用这种方式。发行包内，都自带有 sysV 或者 systemd 风格的启动程序/配置，你只需要直接使用即可。  
以 RPM 为例，/etc/init.d/logstash 脚本中，会加载 /etc/init.d/functions 库文件，利用其中的 daemon 函数，将 logstash 进程作为后台程序运行。  
所以，你只需把自己写好的配置文件，统一放在 /etc/logstash/ 目录下(注意目录下所有配置文件都应该是 .conf 结尾，且不能有其他文本文件存在。因为 logstash agent 启动的时候是读取全文件夹的)，然后运行 service logstash start 命令即可。
### 最基础的 nohup 方式
想要维持一个长期后台运行的 logstash，你需要同时在命令前面加 nohup，后面加 &。
### 更优雅的 SCREEN 方式
通过 screen 命令创建的环境下运行的终端命令，其父进程不是 sshd 登录会话，而是 screen 。这样就可以即避免用户退出进程消失的问题，又随时能重新接管回终端继续操作。  
创建独立的 screen 命令如下：

    screen -dmS elkscreen_1

接管连入创建的 elkscreen_1 命令如下：

    screen -r elkscreen_1

然后你可以看到一个一模一样的终端，运行 logstash 之后，不要按 Ctrl+C，而是按 Ctrl+A+D 键，断开环境。想重新接管，依然 screen -r elkscreen_1 即可。  
如果创建了多个 screen，查看列表命令如下：

    screen -list

### 最推荐的 daemontools 方式
对于需要长期后台运行的大量程序(注意大量，如果就一个进程，还是学习一下怎么写 init 脚本吧)，推荐大家使用一款 daemontools 工具。  
daemontools 是一个软件名称，不过配置略复杂。所以这里我其实是用其名称来指代整个同类产品，包括但不限于 python 实现的 supervisord，perl 实现的 ubic，ruby 实现的 god 等。  
以 supervisord 为例，因为这个出来的比较早，可以直接通过 EPEL 仓库安装。

    yum -y install supervisord --enablerepo=epel

在 /etc/supervisord.conf 配置文件里添加内容，定义你要启动的程序：

    [program:elkpro_1]
    environment=LS_HEAP_SIZE=5000m
    directory=/opt/logstash
    command=/opt/logstash/bin/logstash -f /etc/logstash/pro1.conf -w 10 -l /var/log/logstash/pro1.log
    [program:elkpro_2]
    environment=LS_HEAP_SIZE=5000m
    directory=/opt/logstash
    command=/opt/logstash/bin/logstash -f /etc/logstash/pro2.conf -w 10 -l /var/log/logstash/pro2.log

然后启动 service supervisord start 即可。  
logstash 会以 supervisord 子进程的身份运行，你还可以使用 supervisorctl 命令，单独控制一系列 logstash 子进程中某一个进程的启停操作：

    supervisorctl stop elkpro_2

## 输入插件(Input)
### collectd简述
collectd 是一个守护(daemon)进程，用来收集系统性能和提供各种存储方式来存储不同值的机制。它会在系统运行和存储信息时周期性的统计系统的相关统计信息。利用这些信息有助于查找当前系统性能瓶颈（如作为性能分析 performance analysis）和预测系统未来的 load（如能力部署capacity planning）等  
下面简单介绍一下: collectd的部署以及与logstash对接的相关配置实例
#### collectd的安装
解决依赖

    rpm -ivh "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
    yum -y install libcurl libcurl-devel rrdtool rrdtool-devel perl-rrdtool rrdtool-prel libgcrypt-devel gcc make gcc-c++ liboping liboping-devel perl-CPAN net-snmp net-snmp-devel

源码安装collectd

    wget http://collectd.org/files/collectd-5.4.1.tar.gz
    tar zxvf collectd-5.4.1.tar.gz
    cd collectd-5.4.1
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib --mandir=/usr/share/man --enable-all-plugins
    make && make install

安装启动脚本

    cp contrib/redhat/init.d-collectd /etc/init.d/collectd
    chmod +x /etc/init.d/collectd

启动collectd

    service collectd start

#### collectd的配置

以下配置可以实现对服务器基本的CPU、内存、网卡流量、磁盘 IO 以及磁盘空间占用情况的监控:

    Hostname "host.example.com"
    LoadPlugin interface
    LoadPlugin cpu
    LoadPlugin memory
    LoadPlugin network
    LoadPlugin df
    LoadPlugin disk
    <Plugin interface>
        Interface "eth0"
        IgnoreSelected false
    </Plugin>
    <Plugin network>
        <Server "10.0.0.1" "25826"> ## logstash 的 IP 地址和 collectd 的数据接收端口号
        </Server>
    </Plugin>

#### logstash的配置

以下配置实现通过 logstash 监听 25826 端口,接收从 collectd 发送过来的各项检测数据:
示例一：

    input {
    collectd {
        port => 25826 ## 端口号与发送端对应
        type => collectd
    }

示例二：（推荐）

    udp {
        port => 25826
        buffer_size => 1452
        workers => 3          # Default is 2
        queue_size => 30000   # Default is 2000
        codec => collectd { }
        type => "collectd"
    }

运行结果  
下面是简单的一个输出结果：

    {
      "_index": "logstash-2014.12.11",
      "_type": "collectd",
      "_id": "dS6vVz4aRtK5xS86kwjZnw",
      "_score": null,
      "_source": {
        "host": "host.example.com",
        "@timestamp": "2014-12-11T06:28:52.118Z",
        "plugin": "interface",
        "plugin_instance": "eth0",
        "collectd_type": "if_packets",
        "rx": 19147144,
        "tx": 3608629,
        "@version": "1",
        "type": "collectd",
        "tags": [
          "_grokparsefailure"
        ]
      },
      "sort": [
        1418279332118
      ]
    }

#### 参考资料

    collectd支持收集的数据类型： http://git.verplant.org/?p=collectd.git;a=blob;hb=master;f=README

    collectd收集各数据类型的配置参考资料： http://collectd.org/documentation/manpages/collectd.conf.5.shtml

    collectd简单配置文件示例： https://gist.github.com/untergeek/ab85cb86a9bf39f1fc6d

### 读取文件(File)
用 logstash 来处理日志文件。  
Logstash 使用一个名叫 FileWatch 的 Ruby Gem 库来监听文件变化。这个库支持 glob 展开文件路径，而且会记录一个叫 .sincedb 的数据库文件来跟踪被监听的日志文件的当前读取位置。所以，不要担心 logstash 会漏过你的数据。  
sincedb 文件中记录了每个被监听的文件的 inode, major number, minor number 和 pos。
#### 配置示例

    input {
        file {
            path => ["/var/log/*.log", "/var/log/message"]
            type => "system"
            start_position => "beginning"
        }
    }

#### 解释
有一些比较有用的配置项，可以用来指定 FileWatch 库的行为：

    discover_interval

logstash 每隔多久去检查一次被监听的 path 下是否有新文件。默认值是 15 秒。

    exclude

不想被监听的文件可以排除出去，这里跟 path 一样支持 glob 展开。

    sincedb_path

如果你不想用默认的 $HOME/.sincedb(Windows 平台上在 C:\Windows\System32\config\systemprofile\.sincedb)，可以通过这个配置定义 sincedb 文件到其他位置。

    sincedb_write_interval

logstash 每隔多久写一次 sincedb 文件，默认是 15 秒。

    stat_interval

logstash 每隔多久检查一次被监听文件状态（是否有更新），默认是 1 秒。

    start_position

logstash 从什么位置开始读取文件数据，默认是结束位置，也就是说 logstash 进程会以类似 tail -F 的形式运行。如果你是要导入原有数据，把这个设定改成 "beginning"，logstash 进程就从头开始读取，有点类似 cat，但是读到最后一行不会终止，而是继续变成 tail -F。
#### 注意
通常你要导入原有数据进 Elasticsearch 的话，你还需要 filter/date 插件来修改默认的"@timestamp" 字段值。  
FileWatch 只支持文件的绝对路径，而且会不自动递归目录。所以有需要的话，请用数组方式都写明具体哪些文件。  
LogStash::Inputs::File 只是在进程运行的注册阶段初始化一个 FileWatch 对象。所以它不能支持类似 fluentd 那样的 path => "/path/to/%{+yyyy/MM/dd/hh}.log" 写法。达到相同目的，你只能写成 path => "/path/to/*/*/*/*.log"。FileWatch 模块提供了一个稍微简单一点的写法：/path/to/**/*.log，用 ** 来缩写表示递归全部子目录。  
start_position 仅在该文件从未被监听过的时候起作用。如果 sincedb 文件中已经有这个文件的 inode 记录了，那么 logstash 依然会从记录过的 pos 开始读取数据。所以重复测试的时候每回需要删除 sincedb 文件。  
因为 windows 平台上没有 inode 的概念，Logstash 某些版本在 windows 平台上监听文件不是很靠谱。windows 平台上，推荐考虑使用 nxlog 作为收集端。
### 标准输入(Stdin)
#### 配置示例

    input {
        stdin {
            add_field => {"key" => "value"}
            codec => "plain"
            tags => ["add"]
            type => "std"
        }
    }

#### 运行结果
用上面的新 stdin 设置重新运行一次最开始的 hello world 示例。我建议大家把整段配置都写入一个文本文件，然后运行命令：bin/logstash -f stdin.conf。输入 "hello world" 并回车后，你会在终端看到如下输出：

{
       "message" => "hello world",
      "@version" => "1",
    "@timestamp" => "2014-08-08T06:48:47.789Z",
          "type" => "std",
          "tags" => [
        [0] "add"
    ],
           "key" => "value",
          "host" => "raochenlindeMacBook-Air.local"
}

#### 解释
type 和 tags 是 logstash 事件中两个特殊的字段。通常来说我们会在输入区段中通过 type 来标记事件类型。而 tags 则是在数据处理过程中，由具体的插件来添加或者删除的。
最常见的用法是像下面这样：

    input {
        stdin {
            type => "web"
        }
    }
    filter {
        if [type] == "web" {
            grok {
                match => ["message", %{COMBINEDAPACHELOG}]
            }
        }
    }
    output {
        if "_grokparsefailure" in [tags] {
            nagios_nsca {
                nagios_status => "1"
            }
        } else {
            elasticsearch {
            }
        }
    }

### 读取 Syslog 数据

syslog 可能是运维领域最流行的数据传输协议了。当你想从设备上收集系统日志的时候，syslog 应该会是你的第一选择。尤其是网络设备，比如思科 —— syslog 几乎是唯一可行的办法。

我们这里不解释如何配置你的 syslog.conf, rsyslog.conf 或者 syslog-ng.conf 来发送数据，而只讲如何把 logstash 配置成一个 syslog 服务器来接收数据。

有关 rsyslog 的用法，稍后的类型项目一节中，会有更详细的介绍。
#### 配置示例

input {
  syslog {
    port => "514"
  }
}

#### 运行结果

作为最简单的测试，我们先暂停一下本机的 syslogd (或 rsyslogd )进程，然后启动 logstash 进程（这样就不会有端口冲突问题）。现在，本机的 syslog 就会默认发送到 logstash 里了。我们可以用自带的 logger 命令行工具发送一条 "Hello World"信息到 syslog 里（即 logstash 里）。看到的 logstash 输出像下面这样：

{
           "message" => "Hello World",
          "@version" => "1",
        "@timestamp" => "2014-08-08T09:01:15.911Z",
              "host" => "127.0.0.1",
          "priority" => 31,
         "timestamp" => "Aug  8 17:01:15",
         "logsource" => "raochenlindeMacBook-Air.local",
           "program" => "com.apple.metadata.mdflagwriter",
               "pid" => "381",
          "severity" => 7,
          "facility" => 3,
    "facility_label" => "system",
    "severity_label" => "Debug"
}

#### 解释

Logstash 是用 UDPSocket, TCPServer 和 LogStash::Filters::Grok 来实现 LogStash::Inputs::Syslog 的。所以你其实可以直接用 logstash 配置实现一样的效果：

input {
  tcp {
    port => "8514"
  }
}
filter {
  grok {
    match => ["message", "%{SYSLOGLINE}" ]
  }
  syslog_pri { }
}

#### 最佳实践

建议在使用 LogStash::Inputs::Syslog 的时候走 TCP 协议来传输数据。

因为具体实现中，UDP 监听器只用了一个线程，而 TCP 监听器会在接收每个连接的时候都启动新的线程来处理后续步骤。

如果你已经在使用 UDP 监听器收集日志，用下行命令检查你的 UDP 接收队列大小：

    # netstat -plnu | awk 'NR==1 || $4~/:514$/{print $2}'
Recv-Q
228096

228096 是 UDP 接收队列的默认最大大小，这时候 linux 内核开始丢弃数据包了！

强烈建议使用LogStash::Inputs::TCP和 LogStash::Filters::Grok 配合实现同样的 syslog 功能！

虽然 LogStash::Inputs::Syslog 在使用 TCPServer 的时候可以采用多线程处理数据的接收，但是在同一个客户端数据的处理中，其 grok 和 date 是一直在该线程中完成的，这会导致总体上的处理性能几何级的下降 —— 经过测试，TCPServer 每秒可以接收 50000 条数据，而在同一线程中启用 grok 后每秒只能处理 5000 条，再加上 date 只能达到 500 条！

才将这两步拆分到 filters 阶段后，logstash 支持对该阶段插件单独设置多线程运行，大大提高了总体处理性能。在相同环境下， logstash -f tcp.conf -w 20 的测试中，总体处理性能可以达到每秒 30000 条数据！

注：测试采用 logstash 作者提供的 yes "<44>May 19 18:30:17 snack jls: foo bar 32" | nc localhost 3000 命令。出处见：https://github.com/jordansissel/experiments/blob/master/ruby/jruby-netty/syslog-server/Makefile
#### 小贴士

如果你实在没法切换到 TCP 协议，你可以自己写程序，或者使用其他基于异步 IO 框架(比如 libev )的项目。下面是一个简单的异步 IO 实现 UDP 监听数据输入 Elasticsearch 的示例：

https://gist.github.com/chenryn/7c922ac424324ee0d695
