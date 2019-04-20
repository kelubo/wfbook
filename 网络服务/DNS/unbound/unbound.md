# unbound

## 安装

    yum -y install unbound

    systemctl restart unbound         //启动DNS服务
    systemctl enable unbound          //下次系统重启自动启动DNS服务

## 配置文件

缺省配置文件在 /etc/unbound/unbound.conf。
2.2.1.修改端口监听地址

相当于 RHEL6 配置文件中的：listen-on port 53 { any; };

    -----------------------查看默认监听地址--------------------------
    [root@linuxprobe ~]# netstat -tunlp |grep unbound
    tcp 0 0 127.0.0.1:53 0.0.0.0:* LISTEN 3333/unbound
    tcp 0 0 127.0.0.1:8953 0.0.0.0:* LISTEN 3333/unbound
    tcp6 0 0 ::1:53 :::* LISTEN 3333/unbound
    tcp6 0 0 ::1:8953 :::* LISTEN 3333/unbound
    udp 0 0 127.0.0.1:53 0.0.0.0:* 3333/unbound
    udp6 0 0 ::1:53 :::* 3333/unbound
    //默认监听本地回环地址，也就是现在只有自己能访问DNS服务，其它主机不能访问本机的DNS服务
    -------------------------修改监听地址----------------------------
    [root@linuxprobe ~]# vim /etc/unbound/unbound.conf
    ……
    38 # interface: 0.0.0.0
    39 interface: 0.0.0.0
    ……
    //找到38行，复制去掉注释行，打开监听全网功能。
    --------------------------重启服务查看--------------------------------
    [root@linuxprobe ~]# systemctl restart unbound
    [root@linuxprobe ~]# netstat -tunlp |grep unbound
    tcp 0 0 0.0.0.0:53 0.0.0.0:* LISTEN 3461/unbound
    tcp 0 0 127.0.0.1:8953 0.0.0.0:* LISTEN 3461/unbound
    tcp6 0 0 ::1:8953 :::* LISTEN 3461/unbound
    udp 0 0 0.0.0.0:53 0.0.0.0:* 3461/unbound
    //现在53号端口监听的是0.0.0.0，即所有网段都监听。

2.2.2.修改允许查询的范围

在 RHEL6 中，DNS 配置文件中有这样一句：allow-query { localhost; };。此句定义的是允许向本机查询（迭代 & 递归）的主机范围，localhost 代表只有本机可以向本机查询。而在配置中，经常改 localhost 为 any，让所有主机能够向本机查询 DNS。所以，在 RHEL7 中，也要做这样的修改，只不过修改内容不同而已，如下：

    [root@linuxprobe ~]# vim /etc/unbound/unbound.conf
    ……
    177 # access-control: 0.0.0.0/0 refuse
    178 access-control: 0.0.0.0/0 allow
    179 # access-control: 127.0.0.0/8 allow
    ……
    找到配置文件/etc/unbound/unbound.conf的第177行，缺省为注释行，把内容改为允许访问，然后保存退出，重启服务即可。

2.2.3.创建解析文件

RHEL/CentOS 5、6系统中，DNS 的解析文件分正向和反向两个解析文件，并且有解析文件的模板文件。但是在 RHEL7中，正反向解析文件合并为一个，并且无模板文件，需自己创建，路径可以在主配置文件中查看：

    [root@linuxprobe ~]# vim /etc/unbound/unbound.conf
    ……
    453 # You can add locally served data with
    454 # local-zone: "local." static
    455 # local-data: "mycomputer.local. IN A 192.0.2.51"
                                        //正向解析可参考语法
    456 # local-data: ‘mytext.local TXT "content of text record"‘
    457 #
    458 # You can override certain queries with
    459 # local-data: "adserver.example.com A 127.0.0.1"
    460 #
    461 # You can redirect a domain to a fixed address with
    462 # (this makes example.com, www.example.com, etc, all go to 192.0.2.3)
    463 # local-zone: "example.com" redirect
    464 # local-data: "example.com A 192.0.2.3"
    465 #
    # Shorthand to make PTR records, "IPv4 name" or "IPv6 name".
    467 # You can also add PTR records using local-data directly, but then
    468 # you need to do the reverse notation yourself.
    469 # local-data-ptr: "192.0.2.3 www.example.com"
                                     //反向解析参考语法
    470
    471 include: /etc/unbound/local.d/*.conf
    472
    473 # service clients over SSL (on the TCP sockets), with plain DNS inside
    ……
    ---------------------------------查看本机FQDN---------------------------
    [root@linuxprobe ~]# hostname
    linuxprobe.example.com
    //由此可知，域名为example.com
    --------------------------------创建解析文件-----------------------------
    [root@linuxprobe ~]# vim /etc/unbound/local.d/example.conf
    local-zone: "example.com." static
    local-data: "example.com. 86400 IN SOA ns.example.com. root 1 1D 1H 1W 1H"
    local-data: "ns.example.com. IN A 192.168.10.10"
    local-data: "linuxprobe.example.com. IN A 192.168.10.10"
    local-data-ptr: "192.168.10.10 ns.example.com."
    local-data-ptr: "192.168.10.10 linuxprobe.example.com."
    ------------------------查看RHEL6上解析文件以作对比--------------------
    [root@linuxprobe ~]# vim /var/named/named.localhost
    $TTL 1D          
    @ IN SOA @ rname.invalid. (     
    0 ; serial
    1D ; refresh
    1H ; retry
    1W ; expire
    3H ) ; minimum
    NS @
    A 127.0.0.1
    AAAA ::1

2.3.禁用服务用户

每个服务都是有其专用的服务用户，DNS 的服务用户为 unbound，实际情况下服务用户的启用有可能有安全隐患，这里要禁用服务用户。

    [root@linuxprobe ~]# vim /etc/unbound/unbound.conf
    ······
    211 # if given, user privileges are dropped (after binding port),
    212 # and the given username is assumed. Default is user "unbound".
    213 # If you give "" no privileges are dropped.
    214 #username: "unbound"
    215 username: " "
    216
    217 # the working directory. The relative files in this config
    ······
    如上，找到配置文件的第214行，删除unbound即可，删除后为：username ” “。

2.4.验证

    [root@linuxprobe ~]# unbound-checkconf
    unbound-checkconf: no errors in /etc/unbound/unbound.conf
    验证无配置问题，即可重启服务
    [root@linuxprobe ~]# systemctl restart unbound
    dns验证：
    -------------------------修改本机DNS------------------------
    [root@linuxprobe ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
    HWADDR=00:0C:29:70:····
    TYPE=Ethernet
    ····
    IPADDR="192.168.10.10"
    PREFIX="24"
    ···
    DNS1=192.168.10.10
    NAME=eth0
    ONBOOT=no
    [root@linuxprobe ~]# systemctl restart network
    ----------------------------------------------------nslookup验证--------------------------------------------
    [root@linuxprobe ~]# nslookup
    linuxprobe.example.com.
    192.168.10.10
    ok dns设置成功

PS：关闭防火墙

在本次实验中我们关闭了 linux 的3大防火墙。当没有关闭防火墙时，远程主机验证可能出现故障，这时需要在 DNS 服务器防火墙上开放 DNS 服务。我们以 firewall 防火墙为例，修改一下：

    [root@linuxprobe ~]# systemctl stop iptables
    [root@linuxprobe ~]# systemctl stop ebtables
    [root@linuxprobe ~]# systemctl disable iptables
    [root@linuxprobe ~]# systemctl disable ebtables
    [root@linuxprobe ~]# firewall-cmd --add-service=dns --permanent
    success
    [root@linuxprobe ~]# firewall-cmd --reload
    success
    [root@linuxprobe ~]# firewall-cmd --list-all
    public (default, active)
    interfaces: eth0
    sources:
    services: dhcpv6-client dns ssh
    ports:
    masquerade: no
    forward-ports:
    icmp-blocks:
    rich rules:
    //DNS服务器上Firewall开放DNS访问ok






unbound dns安装手记

    yum install -y wget

    wget http://www.unbound.net/downloads/unbound-latest.tar.gz

    tar zxvf unbound-latest.tar.gz

    安装需要的插件

    yum install gcc openssl-devel expat-devel

    我没有自己定义安装就是直接使用了默认的安装目录

    cd unbound-1.5.7/
    ./configure && make && make install

    添加用户名和用户组

    groupadd unbound
    useradd -m -g unbound -s /bin/false unbound

    编辑配置文件

    vi /usr/local/etc/unbound/unbound.conf
    verbosity: 1
    interface: 0.0.0.0
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    access-control: 0.0.0.0/0 allow
    local-data: "xxx.xx A 10.10.10.10"
    forward-zone:
            name: "."
            forward-addr: 119.29.29.29
            forward-addr: 114.114.114.114

    配置文件很简单大多数默认就可以了。如果有需要的话可以自己查看配置文件。都有恨详细的说明

    local-data: 这个部分可以添加多条 每条的格式都是这样

    local-data: "xxx.xx A 10.10.10.10"

    这里是监听所有的网络，要是你有多张网卡配置了不同的ip 可以修改成你想对外服务的那个IP地址
    interface: 0.0.0.0

    access-control: 0.0.0.0/0 allow
    这部分是对那些ip地址提供服务，如果只想给特定的ip地址段如192.168.0.0/24 这样的 修改一下就好

    还有一个就是防火墙的问题，centos7 默认的防火墙是firewall 不是iptables。开始的时候没有注意这个。检查没有安装iptables 就没有去管最后导致只能本地访问。可以都检查下。

    systemctl stop firewalld

    启动服务

    unbound-checkconf
    unbound

    unbound-checkconf 这个是用来检查配置文件 unbound.conf有没有错误的。

    最后测试下

    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    ping qq.com

    如果正常解析就说明服务器正常了
