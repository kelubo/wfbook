# unbound

1.概念

DNS （域名解析服务)，使用 TCP&UDP 的53号端口（主从 DNS 之间用 TCP，客户端查询使用 UDP）。它可以完成域名与 IP 地址的互换，可以通过 IP 地址解析到域名，也可以通过域名解析到 IP 地址。

FQDN（完全合格域名），层次化树形结构。通常表现为：主机名.子域.二级域.顶级域.根域. 。例如我们平时访问的网站：“www.linuxprobe.com”就是 FQDN。

DNS的查询方式：

    迭代查询：服务器与服务器之间的查询。本地域名服务器向根域名服务器的查询通常是采用迭代查询（反复查询）。当根域名服务器收到本地域名服务器的迭代查询请求报文时，要么给出所要查询的IP地址，要么告诉本地域名服务器下一步应向那个域名服务器进行查询。然后让本地域名服务器进行后续的查询；
    递归查询：客户端与服务器之间的查询。主机向本地域名服务器的查询一般都是采用递归查询。如果主机所询问的本地域名服务器不知道被查询域名的 IP 地址，那么本地域名服务器就以 DNS 客户的身份，向其他根域名服务器继续发出查询请求报文。最后会给客户端一个准确的返回结果，无论是成功与否。

DNS解析类型：

    正向解析：由 FQDN 解析到 IP 地址；
    反向解析：由 IP 地址解析到 FQDN；

名称解析方式：

    hosts文件（etc/hosts）
    dns
    广播
    解析缓存
    wins（windows 中）等

2.DNS 安装配置

在 RHEL5、6 中 DNS 都是用的是 bind 软件包，而在 RHEL/CentOS 7 用的是 unbound 安装包，配置文件也有了改变。我们来看一下：
2.1.安装：

    [root@linuxprobe ~]# yum -y install unbound
    Loaded plugins: langpacks, product-id, subscription-manager
    This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    Resolving Dependencies
    ---> Running transaction check
    ---> Package unbound.x86_64 0:1.4.20-19.el7 will be installed
    ---> Finished Dependency Resolution
     ·····
    ---------------------------启动服务-----------------------------
    [root@linuxprobe ~]# systemctl restart unbound         //启动DNS服务
    [root@linuxprobe ~]# systemctl enable unbound
    ln -s ‘/usr/lib/systemd/system/unbound.service‘ ‘/etc/systemd/system/multi-user.target.wants/unbound.service‘
                                                          //下次系统重启自动启动DNS服务

2.2.修改配置文件

unbound 安装好之后，缺省配置文件在 /etc/unbound/unbound.conf。
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
