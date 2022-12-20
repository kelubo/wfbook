# Bind

[TOC]

## 概述

Berkeley Internet Name Domain（BIND）软件为许多操作系统实现了域名服务器。最初是由加州大学伯克利分校开发出来的 BSD UNIX 中的一部分，目前由 ISC 组织进行维护和开发。

BIND 9 是透明的开源软件，根据 MPL 2.0 许可证获得许可。

## Cache-only DNS 服务器配置

Cache-only DNS 服务器是 DNS 服务器的一部分，本身并不管理任何域名，类似于代理 DNS 服务器，是将所有查询转发给其他 DNS 服务器进行查询。主要是为了加速 DNS 客户端的查询速度。

编辑配置文件：

```c
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
        //listen-on port 53 { 127.0.0.1; };
        listen-on port 53 { any; };
        // 修改为 any ，对外连接。
        //listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        //allow-query     { localhost; };
        allow-query     { any; };
        // 修改为 any ,对外提供服务。

        /*
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable
           recursion.
         - If your recursive DNS server has a public IP address, you MUST enable access
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface
        */
        recursion yes;

        //dnssec-enable yes;
        //dnssec-validation yes;
        // 以上两行 yes 改为 no
        dnssec-enable no;
        dnssec-validation no;
        
        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
        
        forward only;
        // 必须加上，否则 cache only 不生效。
        forwarders {
        			 114.114.114.114;
        };
        // 配置转发服务器。
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```





BIND 9 is a complete implementation of the DNS protocol. BIND 9 can be configured (using its `named.conf` file) as an authoritative name server, a resolver, and, on supported hosts, a stub resolver. While large operators usually dedicate DNS servers to a single function per system, smaller operators will find that BIND 9’s flexible configuration features support multiple functions, such as a single DNS server acting as both an authoritative name server and a resolver.

Example configurations of basic [authoritative name servers](https://bind9.readthedocs.io/en/latest/chapter3.html#config-auth-samples) and [resolvers and forwarding resolvers](https://bind9.readthedocs.io/en/latest/chapter3.html#config-resolver-samples), as well as [advanced configurations](https://bind9.readthedocs.io/en/latest/chapter6.html#advanced) and [secure configurations](https://bind9.readthedocs.io/en/latest/chapter7.html#security), are provided.

BIND9是DNS协议的完整实现。BIND9可以配置（使用其named.conf文件）为权威名称服务器、解析器，在支持的主机上，还可以配置为存根解析器。虽然大型运营商通常将DNS服务器专用于每个系统的单个功能，但小型运营商会发现BIND9的灵活配置特性支持多种功能，例如单个DNS服务器同时充当权威名称服务器和解析器。

提供了基本权威名称服务器、解析器和转发解析器的示例配置，以及高级配置和安全配置。

## BIND Uses on the Internet

#### Almost every Internet connection starts with a DNS lookup

Before your mail server sends an email, before  your web browser displays a web page, there is a DNS lookup to resolve a DNS name to an IP address. Watch this [DNS Fundamentals presentation](https://www.youtube.com/watch?v=oeceM-R8DVU&feature=emb_logo) from Eddy Winstead of ISC or read [A Warm Welcome to DNS](https://powerdns.org/hello-dns/) by Bert Hubert of PowerDNS.



#### BIND 9 on the Internet

BIND is used successfully for every application  from publishing the (DNSSEC-signed) DNS root zone and many top-level  domains, to hosting providers who publish very large zone files with  many small zones, to enterprises with both internal (private) and  external zones, to service providers with large resolver farms.

BIND在Internet上的使用

几乎每个Internet连接都以DNS查找开始

在邮件服务器发送电子邮件之前，在web浏览器显示网页之前，会进行DNS查找以将DNS名称解析为IP地址。观看ISC的Eddy Winstead的DNS基础演示，或阅读Power DNS的Bert Hubert的《热烈欢迎使用DNS》。

Internet上的BIND 9

BIND成功地用于每一个应用程序，从发布（DNSSEC签名）DNS根区域和许多顶级域，到发布具有许多小区域的非常大的区域文件的托管提供商，到具有内部（私有）和外部区域的企业，再到具有大型解析器场的服务提供商。

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#prerequisites-and-assumptions)

- A server running Rocky Linux
- Several internal servers that need to be accessed only locally, but not over the Internet
- Several workstations that need access to these same servers that exist on the same network
- A healthy comfort level with entering commands from command line
- Familarity with a command line editor (we are using *vi* in this example)
- Able to use either *firewalld* or *iptables* for creating firewall rules (we are using *iptables* here. If you would like to use *iptables* as well, use the [Enabling Iptables Firewall procedure](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/))

## Introduction[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#introduction)

External, or public, DNS servers are used on the Internet to map host names to IP addresses and, in the case of PTR (known as "pointer" or  "reverse") records, to map the IP to the host name. This is an essential part of the Internet. It makes your mail server, web server, FTP  server, or many other servers and services work as expected no matter  where you are.

On a private network, particularly one that is being used for  developing multiple systems, you can use your Rocky Linux workstation's */etc/hosts* file to map a name to an IP address.

This will work for *your* workstation, but not for any other  machine on your network. If you want to make things universally applied, then the best method is to take some time out and create a local,  private DNS server to handle this for all of your machines.

If you were creating production-level public DNS servers and  resolvers, then this author would probably recommend the more robust [PowerDNS](https://www.powerdns.com/) authoritative and recursive DNS, which is easily installed on Rocky  Linux servers. However, that is simply overkill for a local network that won't be exposing its DNS servers to the outside world. That is why we  have chosen *bind* for this example.

### The DNS Server Components Explained[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#the-dns-server-components-explained)

As stated, DNS separates services into authoritative and recursive  servers. These services are now recommended to be separate from each  other on separate hardware or containers.

The authoritative server is the storage area for all IP addresses and host names, and the recursive server is used to lookup addresses and  host names. In the case of our private DNS server, both the  authoritative and the recursive server services will run together.

## Installing and Enabling Bind[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#installing-and-enabling-bind)

The first step is to install packages. In the case of *bind* we need to execute the following command:

```
dnf install bind bind-utils
```

The service daemon for *bind* is called *named*, and we need to enable this to start on boot:

```
systemctl enable named
```

And then we need to start it:

```
systemctl start named
```

## Configuration[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#configuration)

Before making changes to any configuration file, it is a good idea to make a backup copy of the original installed working file, in this case *named.conf*:

```
cp /etc/named.conf /etc/named.conf.orig
```

That will help in the future if errors are introduced into the configuration file. It is *always* a good idea to make a backup copy before making changes.

These changes require us to edit the named.conf file, to do this, we are using *vi*, but you can substitute your favorite command line editor (the editor `nano` is also installed in Rocky Linux and is easier to use than `vi`):

```
vi /etc/named.conf
```

First thing we want to do is turn off listening on the localhost,  this is done by remarking out with a "#" sign, these two lines in the  "options" section. What this does is to effectively shutdown any  connection to the outside world.

This is helpful, particularly when we go to add this DNS to our  workstations, because we want these DNS server to only respond when the  IP address requesting the service is local, and simply not respond at  all if the service that is being looked up is on the Internet.

This way, the other configured DNS servers will take over nearly immediately to look up the Internet based services:



```
options {
#       listen-on port 53 { 127.0.0.1; };
#       listen-on-v6 port 53 { ::1; };
```

If you are not using IPv6, then it's a good idea to turn off IPv6 in *bind*.



This has to be handled in two places. The first place is in the *named.conf* file that we are already in. If you are using IPv6, then you can (and  should!) skip adding this line. Again, this can just be added anywhere  in the "options" section:

```
filter-aaaa-on-v4 yes;
```

Finally, skip down to the bottom of the *named.conf* file and add a section for your network. Our example is using ourdomain, so sub in what you want to call your LAN hosts:

```
# primary forwward and reverse zones
//forward zone
zone "ourdomain.lan" IN {
     type master;
     file "ourdomain.lan.db";
     allow-update { none; };
    allow-query {any; };
};
//reverse zone
zone "1.168.192.in-addr.arpa" IN {
     type master;
     file "ourdomain.lan.rev";
     allow-update { none; };
    allow-query { any; };
};
```

Now save your changes (for *vi*, `SHIFT:wq!`)

If you are turning off IPv6 for *bind* as noted above, then you will need to make a change to one more file:

```
vi /etc/sysconfig/named
```

And then add this to the bottom of the file:

```
OPTIONS="-4"
```

Now save those changes (again, for *vi*, `SHIFT:wq!`)

Next, we need to create two files in /var/named. These files are the  ones that you will edit if you add machines to your network that you  want to include in the DNS.

The first is the forward file to map our IP address to the hostname.  Again, we are using "ourdomain" as our example here. Note that the IP of our local DNS here is 192.168.1.136. The hosts are added at the bottom  of this file.

```
vi /var/named/ourdomain.lan.db
```

The file will look something like this when you are done:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;IP for Name Server
dns-primary IN A 192.168.1.136

;A Record for IP address to Hostname
wiki IN A 192.168.1.13
www IN A 192.168.1.14
devel IN A 192.168.1.15
```

Add as many hosts as you need to the bottom of the file along with their IP addresses and then save your changes.

Next, we need a reverse file to map our hostname to the IP address,  In this case, the only part of the IP that you need is the last octet  (in an IPv4 address each number separated by a comma, is an octet) of  the host and then the PTR and hostname.

```
vi /var/named/ourdomain.lan.rev
```

And the file should look something like this when you are done.:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)
;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;Reverse lookup for Name Server
100 IN PTR dns-primary.ourdomain.lan.

;PTR Record IP address to HostName
13 IN PTR wiki.ourdomain.lan.
14 IN PTR www.ourdomain.lan.
15 IN PTR devel.ourdomain.lan.
```

Add all of the hostnames that appear in the forward file and then save your changes.

### What All Of This Means[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#what-all-of-this-means)

Now that we have all of this added in and are preparing to restart our *bind* DNS server, let's just explore some of the terminology that is used in these two files.

Just making things work isn't good enough if you don't know what each term means, right?

- **TTL** appears in both files and it stands for "Time  To Live." TTL tells the DNS server how long to keep its cache in place  before requesting a fresh copy. In this case, the TTL is the default  setting for all records unless a specific record TTL is set. The default here is 86400 seconds or 24 hours.
- **IN** stands for Internet. In this case, we aren't actually using the Internet, so think of this as the Intranet.
- **SOA** stands for "Start Of Authority" or what the primary DNS server is for the domain.
- **NS** stands for "name server"
- **Serial** is the value used by the DNS server to verify that the contents of the zone file are up-to-date.
- **Refresh** specifies how often a slave DNS server should do a zone transfer from the master.
- **Retry** specifies the length of time in seconds to wait before trying again on a failed zone transfer.
- **Expire** specifies how long a slave server should wait to answer a query when the master is unreachable.
- **A** Is the host address or forward record and is only in the forward file (above).
- **PTR** Is the pointer record better known as the "reverse" and is only in our reverse file (above).

## Testing Configurations[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#testing-configurations)

Once we have gotten all of our files created, we need to make sure  that the configuration files and zones are in good working order before  we start the *bind* service again.

Check the main configuration:

```
named-checkconf
```

This should return an empty result if everything is OK.

Then check the forward zone:

```
named-checkzone ourdomain.lan /var/named/ourdomain.lan.db
```

This should return something like this if all is well:

```
zone ourdomain.lan/IN: loaded serial 2019061800
OK
```

And finally check the reverse zone:

```
named-checkzone 192.168.1.136 /var/named/ourdomain.lan.rev
```

Which should return something like this if all is well:

```
zone 192.168.1.136/IN: loaded serial 2019061800
OK
```

Assuming that everything looks good, go ahead and restart *bind*:

```
systemctl restart named
```

## Testing Machines[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#testing-machines)

You need to add the DNS server (in our example 192.168.1.136) to each machine that you want to have access to the servers that you added to  your new local DNS. We are only going to show you an example of how to  do this on a Rocky Linux workstation, but there are similar methods for  other Linux distributions, as well as Windows and Mac machines.

Keep in mind that you will want to just add the DNS server in the  list, as you will still need Internet access, which will require your  currently assigned DNS servers. These might be assigned via DHCP  (Dynamic Host Configuration Protocol) or statically assigned.

On a Rocky Linux workstation where the enabled network interface is eth0, you would use:

```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

If your enabled network interface is different, you will need to  substitute that interface name. The configuration file that you open  will look something like this for a statically assigned IP (not DHCP as  mentioned above). In the example below, our machine's IP address is  192.168.1.151:

```
DEVICE=eth0
BOOTPROTO=none
IPADDR=192.168.1.151
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
ONBOOT=yes
HOSTNAME=tender-kiwi
TYPE=Ethernet
MTU=
```

We want to substitute in our new DNS server for the primary (DNS1)  and then move each of the other DNS servers down one so that it like  this:

```
DEVICE=eth0
BOOTPROTO=none
IPADDR=192.168.1.151
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.136
DNS2=8.8.8.8
DNS3=8.8.4.4
ONBOOT=yes
HOSTNAME=tender-kiwi
TYPE=Ethernet
MTU=
```

Once you've made the change, either restart the machine or restart networking with:

```
systemctl restart network
```

Now you should be able to get to anything in the *ourdomain.lan* domain from your workstation, plus still be able to resovle and get to Internet addresses.

## Adding The Firewall Rule[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#adding-the-firewall-rule)

You have two choices for adding the firewall rules for DNS. You can either use the default *firewalld* or you can use *iptables* which is what we are using here. If you want to use *firewalld*, then we are assuming you will know how to translate this rule into *firewalld* syntax. The firewall rules are applied to the new private DNS server.

First, create a file in */etc* called "firewall.conf" that  will contain the following rules. This is a bare minimum rule set, and  you may need to tweak this for your environment:

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
iptables -A INPUT -p tcp -m tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
# dns rules
iptables -A INPUT -p udp -m udp -s 192.168.1.0/24 --dport 53 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

Let's evaluate the rules above:

- The first "iptables" line flushes the rules that are currently loaded (-F).
- Next, we are setting a default policy for the INPUT chain of DROP.  This means, if the traffic is not explicitly allowed here, it is  dropped.
- Next, we have an SSH rule for our local network, so that we can get into the DNS server remotely.
- Then we have our DNS allow rule, only for our local network. Note that DNS uses the UDP protocol (User Datagram Protocol).
- Next we allow INPUT from the local interface.
- Then if you have established a connection for something else, we are allowing related packets in as well.
- And finally we reject everything else.
- The last line tells iptables to save the rules so that when the machine restarts, the rules will load as well.

Once our firewall.conf file is created, we need to make it executable:

```
chmod +x /etc/firewall.conf
```

Then run it:

```
/etc/firewall.conf
```

And this is what you should get in return. If you get something else, take a look at your script for errors:

```
clearing any existing rules and setting default policy..
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
```

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#conclusions)

While using */etc/hosts* on an individual workstation will get you access to a machine on your internal network, you can only use it  on that one machine. By adding a private DNS server using *bind*, you can add hosts to the DNS and as long as the workstations have  access to that private DNS server, they will be able to get to these  local servers.

If you don't need machines to resolve on the Internet, but do need  local access from several machines to local servers, then consider using a private DNS server instead.