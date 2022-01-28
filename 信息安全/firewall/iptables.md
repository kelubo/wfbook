# iptables
## CentOS 7 替换 Firewalld 为 iptables

    systemctl mask firewalld
    systemctl stop firewalld
    yum install iptables-devel
    yum install iptables-service iptables
    systemctl enable iptables
    yum install iptables-services
    systemctl enable iptables
    systemctl start iptables

# Enabling iptables Firewall[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#enabling-iptables-firewall)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#prerequisites)

- A burning, unquenchable desire to disable the default *firewalld* application, and enable *iptables*.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#introduction)

*firewalld* is now the default firewall on Rocky Linux. *firewalld* **was** nothing more than a dynamic application of *iptables* using xml files that loaded changes without flushing the rules in CentOS 7/RHEL 7.  With CentOS 8/RHEL 8/Rocky 8, *firewalld* is now a wrapper around *nftables*. It is still possible, however, to install and use straight *iptables* if that is your preference. To install and run straight *iptables* without *firewalld* you can do so by following this guide. What this guide will **not** tell you is how to write rules for *iptables*. It is assumed that if you want to get rid of *firewalld*, you must already know how to write rules for *iptables*.

## Disabling firewalld[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#disabling-firewalld)

You can't really run the old *iptables* utilities alongside *firewalld*. They're just not compatible. The best way to get around this is to disable *firewalld* entirely (no need to unistall it unless you want to), and reinstall the *iptables* utilities. Disabling *firewalld* can be done using these commands:

Stop *firewalld*:

```
systemctl stop firewalld
```

Disable *firewalld* so it won't start on boot:

```
systemctl disable firewalld
```

Mask the service so that it can't be found:

```
systemctl mask firewalld
```

## Installing And Enabling iptables Services[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#installing-and-enabling-iptables-services)

Next we need to install the old *iptables* services and utilities. This is done with the following:

```
dnf install iptables-services iptables-utils
```

This will install everything that is needed to run a straight *iptables* rule set.

Now we need to enable the *iptables* service to make sure that it starts on boot:

```
systemctl enable iptables
```

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/#conclusion)

You can return to using straight *iptables* if you prefer it over *firewalld*. You can return to using the default *firewalld* by simply reversing these changes.

## 例子

### 步骤 1 启用 IP 转发

第一步，我们启用 IP 转发。 这一步在 RHEL/CentOS 6 和 7 上是相同的。 运行

```
$ sysctl -w net.ipv4.ip_forward=1
```

但是这样会在系统重启后恢复。要让重启后依然生效需要打开

```
$ vi /etc/sysctl.conf
```

然后输入下面内容，

```
net.ipv4.ip_forward = 1
```

保存并退出。现在系统就启用 IP 转发了。

### 步骤 2 配置 IPtables/Firewalld 的规则

下一步我们需要启动 IPtables/firewalld 服务并配置 NAT 规则，

```
$ systemctl start firewalld (For Centos/RHEL 7)$ service iptables start  (For Centos/RHEL 6)
```

然后运行下面命令来配置防火墙的 NAT 规则：

```
CentOS/RHEL 6$ iptables -t nat -A POSTROUTING -o XXXX -j MASQUERADE$ service iptables restart CentOS/RHEL 7$ firewall-cmd  -permanent -direct -passthrough ipv4 -t nat -I POSTROUTING -o XXXX -j MASQUERADE -s 192.168.1.0/24$ systemctl restart firewalld
```

这里，`XXXX` 是配置有外网 IP 的那个网卡名称。 这就将 Linux 机器配置成了路由器了， 下面我们就可以配置客户端然后测试路由器了。

### 步骤 3 配置客户端

要测试路由器，我们需要在客户端的网关设置成内网 IP， 本例中就是 192.168.1.1。 因此不管客户机是 Windows 还是 Linux， 请先确保网关是 192.168.1.1。 完成后， 打开终端或命令行并 `ping` 一个网站来测试客户端是否能访问互联网了：

```
$ ping google.com
```

我们也可以通过网络浏览器访问网站的方式来检查。



前提基础：
1、当主机收到一个数据包后，数据包先在内核空间中处理，若发现目的地址是自身，则传到用户空间中交给对应的应用程序处理，若发现目的不是自身，则会将包丢弃或进行转发。

2、iptables实现防火墙功能的原理是：在数据包经过内核的过程中有五处关键地方，分别是**PREROUTING、INPUT、OUTPUT、FORWARD、POSTROUTING**，称为钩子函数，iptables这款用户空间的软件可以在这5处地方写规则，对经过的数据包进行处理，规则一般的定义为“如果数据包头符合这样的条件，就这样处理数据包”。

3、iptables中定义有5条链，说白了就是上面说的5个钩子函数，因为每个钩子函数中可以定义多条规则，每当数据包到达一个钩子函数时，iptables就会从钩子函数中第一条规则开始检查，看该数据包是否满足规则所定义的条件。如果满足，系统就会根据该条规则所定义的方法处理该数据包；否则iptables将继续检查下一条规则，如果该数据包不符合钩子函数中任一条规则，iptables就会根据该函数预先定义的默认策略来处理数据包

4、iptables中定义有表，分别表示提供的功能，有filter表（实现包过滤）、nat表（实现网络地址转换）、mangle表（实现包修改）、raw表（实现数据跟踪），这些表具有一定的优先级：**raw-->mangle-->nat-->filter**

------

------

一条链上可定义不同功能的规则，检查数据包时将根据上面的优先级顺序检查

![linux iptables详解--个人笔记](https://s1.51cto.com/images/blog/201804/03/d2510f96d6c026c5d07f5421374a4b92.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)
1、目的地址是本地，则发送到INPUT，让INPUT决定是否接收下来送到用户空间，流程为①--->②;

2、若满足PREROUTING的nat表上的转发规则，则发送给FORWARD，然后再经过POSTROUTING发送出去，流程为： ①--->③--->④--->⑥

主机发送数据包时，流程则是⑤--->⑥

iptables安装配置

linux一般默认都已经安装iptables，只需要开启服务即可

service iptables start                //启动

service iptables restart             //重启

service iptables stop                //关闭

iptables规则书写：

基本语法：**iptables [-t 表]  [操作命令]  [链]  [规则匹配器]  [-j 目标动作]**

| 表            | 说明                                               | 支持的链                        |
| ------------- | -------------------------------------------------- | ------------------------------- |
| raw           | 一般是为了不再让iptables对数据包进行跟踪，提高性能 | PREROUTING、OUTPUT              |
| mangle        | 对数据包进行修改                                   | 五个链都可以                    |
| nat           | 进行地址转换                                       | PREROUTING、OUTPUT、POSTROUTING |
| filter(默认） | 对包进行过滤                                       | INPUT、FORWARD、OUTPUT          |

------

| 常用操作命令 | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| -A           | 在指定链尾部添加规则                                         |
| -D           | 删除匹配的规则                                               |
| -R           | 替换匹配的规则                                               |
| -I           | 在指定位置插入规则(例：iptables -I INPUT 1 --dport 80 -j ACCEPT（将规则插入到filter表INPUT链中的第一位上） |
| -L/S         | 列出指定链或所有链的规则                                     |
| -F           | 删除指定链或所有链的规则                                     |
| -N           | 创建用户自定义链[例：iptables -N allowed]                    |
| -X           | 删除指定的用户自定义链                                       |
| -P           | 为指定链设置默认规则策略，对自定义链不起作用                 |
| -Z           | 将指定链或所有链的计数器清零                                 |
| -E           | 更改自定义链的名称[例：iptables -E allowed disallowed]       |
| -n           | ip地址和端口号以数字方式显示[例：iptables -nL]               |

------

| 常用规则匹配器        | 说明                                                         |
| --------------------- | ------------------------------------------------------------ |
| -p tcp/udp/icmp/all   | 匹配协议，all会匹配所有协议                                  |
| -s addr[/mask]        | 匹配源地址                                                   |
| -d addr[/mask]        | 匹配目标地址                                                 |
| --sport port1[:port2] | 匹配源端口(可指定连续的端口）                                |
| --dport port1[:port2] | 匹配目的端口(可指定连续的端口）                              |
| -o interface          | 匹配出口网卡，只适用FORWARD、POSTROUTING、OUTPUT(例：iptables -A FORWARD -o eth0) |
| -i interface          | 匹配入口网卡，只使用PREROUTING、INPUT、FORWARD。             |
| --icmp-type           | 匹配icmp类型（使用iptables -p icmp -h可查看可用的ICMP类型）  |
| --tcp-flags mask comp | 匹配TCP标记，mask表示检查范围，comp表示匹配mask中的哪些标记。（例：iptables -A FORWARD -p tcp --tcp-flags ALL SYN，ACK -j ACCEPT   表示匹配SYN和ACK标记的数据包） |

------

| 目标动作 | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| ACCEPT   | 允许数据包通过                                               |
| DROP     | 丢弃数据包                                                   |
| REJECT   | 丢弃数据包，并且将拒绝信息发送给发送方                       |
| SNAT     | 源地址转换（在nat表上）例：iptables -t nat -A POSTROUTING -d 192.168.0.102 -j SNAT --to 192.168.0.1 |
| DNAT     | 目标地址转换（在nat表上）例：iptables -t nat -A PREROUTING -d 202.202.202.2 -j DNAT --to-destination 192.168.0.102 |
| REDIRECT | 目标端口转换（在nat表上）例：iptables -t nat -D PREROUTING -p tcp --dport 8080 -i eth2.2 -j REDIRECT --to 80 |
| MARK     | 将数据包打上标记;例：iptables -t mangle -A PREROUTING -s 192.168.1.3 -j MARK --set-mark 60 |

PS： 
1、目标地址转换一般在PREROUTING链上操作
2、源地址转换一般在POSTROUTING链上操作

------

------

保存和恢复iptables规则

使用iptables-save可以保存到特定文件中

iptables-save >/etc/sysconfig/iptables_save

使用iptables-restore可以恢复规则

iptables-restore</etc/sysconfig/iptables_save

------

------

iptables的进阶使用
1、limit限制流量：
-m limit  --limit 1000/s              #设置最大平均匹配速率
-m limit --limit-burst 15            #设置一开始匹配的最大数据包数量
-m  limit --limit 5/m --limit-burst 15      #表示一开始能匹配的数据包数量为15个，每匹配到一个，limit-burst的值减1,所以匹配到15个时，该值为0,以后每过12s，limit-burst的值会加1,表示又能匹配1个数据包
例子：

iptables -A INPUT -i eth0 -m limit --limit 5/m --limit-burst 15 -j ACCEPT  

iptables -A INPUT -i eth0 -j DROP

注意要点：

A、--limit-burst的值要比--limit的大

B、limit本身没有丢弃数据包的功能，因此，需要第二条规则一起才能实现限速的功能

2、time ：在特定时间内匹配

| -m time                 | 说明                                    |
| ----------------------- | --------------------------------------- |
| --monthdays day1[,day2] | 在每个月的特定天匹配                    |
| --timestart hh:mm:ss    | 在每天的指定时间开始匹配                |
| --timestop hh:mm:ss     | 在每天的指定时间停止匹配                |
| --weekdays day1[,day2]  | 在每个星期的指定工作日匹配，值可以是1-7 |

例子：

iptables -A INPUT -i eth0 -m time --weekdays 1,2,3,4 -jACCEPT

iptables -A INPUT -i eth0 -j DROP

3、ttl：匹配符合规则的ttl值的数据包

| 参数          | 说明                     |
| ------------- | ------------------------ |
| --ttl -eq 100 | 匹配TTL值为100的数据包   |
| --ttl -gt 100 | 匹配TTL值大于100的数据包 |
| --ttl -lt 100 | 匹配TTL值小于100的数据包 |

例子：

iptables -A OUTPUT -m ttl --ttl-eq 100 -j ACCEPT

4、multiport：匹配离散的多个端口

| 参数                         | 说明                 |
| ---------------------------- | -------------------- |
| --sports port1[,port2,port3] | 匹配源端口           |
| --dports port1[,port2,port3] | 匹配目的端口         |
| --ports port1[,port2,port3]  | 匹配源端口或目的端口 |

例子：

iptables -A INPUT -m multiport --sports 22，80，8080 -j DROP

5、state：匹配指定的状态数据包

| 参数          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| --state value | value可以为NEW、RELATED（有关联的）、ESTABLISHED、INVALID（未知连接） |

例子：

iptables -A INPUT -m state --state NEW，ESTABLISHED -j ACCEPT

6、mark：匹配带有指定mark值的数据包

| 参数         | 说明                        |
| ------------ | --------------------------- |
| --mark value | 匹配mark标记为value的数据包 |

例子：

iptables -t mangle -A INPUT -m mark --mark 1 -j DROP

7、mac：匹配特定的mac地址

例子：

iptables -A FORWARD -m mac --mac-source 00:0C:24:FA:19:80 -j DROP

------

------

- [网站首页](https://www.linuxprobe.com/)
- [开始读书](https://www.linuxprobe.com/chapter-00.html)  
- [下载](https://www.linuxprobe.com/tools)  
- [Linux资讯](https://www.linuxprobe.com/news)
- [Linux命令](https://www.linuxcool.com/)
- [技术干货](https://www.linuxprobe.com/thread)
- [投稿](https://www.linuxprobe.com/tougao)
- [Linux培训](https://www.linuxprobe.com/training)
- [培训记录](https://www.linuxprobe.com/train)
- [红帽认证](https://www.linuxprobe.com/redhat-certificate)  
- [加入我们](https://www.linuxprobe.com/team)  
- [登录](https://www.linuxprobe.com/login)



# [第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/chapter-08.html)

 		

[![img](https://www.linuxprobe.com/imgs/peixun.jpg)](https://www.linuxprobe.com/training)

**Linux系统技术交流QQ群（3026356）验证问题答案：刘遄**[![Linux就该这么学](https://www.linuxprobe.com/wp-content/uploads/2018/02/QQ群.png)](https://shang.qq.com/wpa/qunwpa?idkey=8e97c63c10714729b6fbc61f433d0964f25ee48e63b05be4e1c3161082d47a08)

**《Linux就该这么学》最新正式版已出版上市，同学们可在线上京东网、当当网、淘宝网及亚马逊等电商平台购买。**

***亦可就近在新华书店购买\***

**章节简述：**

保障数据的安全性是继保障数据的可用性之后最为重要的一项工作。防火墙作为公网与内网之间的保护屏障，在保障数据的安全性方面起着至关重要的作用。考虑到大家还不了解RHEL 7中新增的firewalld防火墙与先前版本中iptables防火墙之间的区别，[刘遄](https://www.linuxprobe.com/)老师决定先带领读者从理论层面和实际层面正确地认识在这两款防火墙之间的关系。

本章将分别使用iptables、firewall-cmd、firewall-config和TCP  Wrappers等防火墙策略配置服务来完成数十个根据真实工作需求而设计的防火墙策略配置实验。在学习完这些实验之后，各位读者不仅可以熟练地过滤请求的流量，还可以基于服务程序的名称对流量进行允许和拒绝操作，确保[Linux系统](https://www.linuxprobe.com/)的安全性万无一失。

本章目录结构 [[收起](https://www.linuxprobe.com/chapter-08.html#)]

- [8.1 防火墙管理工具](https://www.linuxprobe.com/chapter-08.html#81)
- 8.2 Iptables
  - [8.2.1 策略与规则链](https://www.linuxprobe.com/chapter-08.html#821)
  - [8.2.2 基本的命令参数](https://www.linuxprobe.com/chapter-08.html#822)
- 8.3 Firewalld
  - [8.3.1 终端管理工具](https://www.linuxprobe.com/chapter-08.html#831)
  - [8.3.2 图形管理工具](https://www.linuxprobe.com/chapter-08.html#832)
- [8.4 服务的访问控制列表](https://www.linuxprobe.com/chapter-08.html#84)

##### **8.1 防火墙管理工具**

众所周知，相较于企业内网，外部的公网环境更加恶劣，罪恶丛生。在公网与企业内网之间充当保护屏障的防火墙（见图8-1）虽然有软件或硬件之分，但主要功能都是依据策略对穿越防火墙自身的流量进行过滤。防火墙策略可以基于流量的源目地址、端口号、协议、应用等信息来定制，然后防火墙使用预先定制的策略规则监控出入的流量，若流量与某一条策略规则相匹配，则执行相应的处理，反之则丢弃。这样一来，就可以保证仅有合法的流量在企业内网和外部公网之间流动了。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/防火墙拓扑.png)

图8-1  防火墙作为公网与内网之间的保护屏障

在RHEL 7系统中，firewalld防火墙取代了iptables防火墙。对于接触[Linux系统](https://www.linuxprobe.com/)比较早或学习过RHEL  6系统的读者来说，当他们发现曾经掌握的知识在RHEL  7中不再适用，需要全新学习firewalld时，难免会有抵触心理。其实，iptables与firewalld都不是真正的防火墙，它们都只是用来定义防火墙策略的防火墙管理工具而已，或者说，它们只是一种服务。iptables服务会把配置好的防火墙策略交由内核层面的netfilter网络过滤器来处理，而firewalld服务则是把配置好的防火墙策略交由内核层面的nftables包过滤框架来处理。换句话说，当前在Linux系统中其实存在多个防火墙管理工具，旨在方便运维人员管理Linux系统中的防火墙策略，我们只需要配置妥当其中的一个就足够了。虽然这些工具各有优劣，但它们在防火墙策略的配置思路上是保持一致的。大家甚至可以不用完全掌握本章介绍的内容，只要在这多个防火墙管理工具中任选一款并将其学透，就足以满足日常的工作需求了。

##### **8.2 Iptables**

在早期的Linux系统中，默认使用的是iptables防火墙管理服务来配置防火墙。尽管新型的firewalld防火墙管理服务已经被投入使用多年，但是大量的企业在生产环境中依然出于各种原因而继续使用iptables。考虑到iptables在当前生产环境中还具有顽强的生命力，以及为了使大家在求职面试过程中被问到iptables的相关知识时能胸有成竹，[刘遄](https://www.linuxprobe.com/)老师觉得还是有必要在本书中好好地讲解一下这项技术。更何况前文也提到，各个防火墙管理工具的配置思路是一致的，在掌握了iptables后再学习其他防火墙管理工具时，也有借鉴意义。

###### **8.2.1 策略与规则链**

防火墙会从上至下的顺序来读取配置的策略规则，在找到匹配项后就立即结束匹配工作并去执行匹配项中定义的行为（即放行或阻止）。如果在读取完所有的策略规则之后没有匹配项，就去执行默认的策略。一般而言，防火墙策略规则的设置有两种：一种是“通”（即放行），一种是“堵”（即阻止）。当防火墙的默认策略为拒绝时（堵），就要设置允许规则（通），否则谁都进不来；如果防火墙的默认策略为允许时，就要设置拒绝规则，否则谁都能进来，防火墙也就失去了防范的作用。

iptables服务把用于处理或过滤流量的策略条目称之为规则，多条规则可以组成一个规则链，而规则链则依据数据包处理位置的不同进行分类，具体如下：

> 在进行路由选择前处理数据包（PREROUTING）；
>
> 处理流入的数据包（INPUT）；
>
> 处理流出的数据包（OUTPUT）；
>
> 处理转发的数据包（FORWARD）；
>
> 在进行路由选择后处理数据包（POSTROUTING）。

一般来说，从内网向外网发送的流量一般都是可控且良性的，因此我们使用最多的就是INPUT规则链，该规则链可以增大黑客人员从外网入侵内网的难度。

比如在您居住的社区内，物业管理公司有两条规定：禁止小商小贩进入社区；各种车辆在进入社区时都要登记。显而易见，这两条规定应该是用于社区的正门的（流量必须经过的地方），而不是每家每户的防盗门上。根据前面提到的防火墙策略的匹配顺序，可能会存在多种情况。比如，来访人员是小商小贩，则直接会被物业公司的保安拒之门外，也就无需再对车辆进行登记。如果来访人员乘坐一辆汽车进入社区正门，则“禁止小商小贩进入社区”的第一条规则就没有被匹配到，因此按照顺序匹配第二条策略，即需要对车辆进行登记。如果是社区居民要进入正门，则这两条规定都不会匹配到，因此会执行默认的放行策略。

但是，仅有策略规则还不能保证社区的安全，保安还应该知道采用什么样的动作来处理这些匹配的流量，比如“允许”、“拒绝”、“登记”、“不理它”。这些动作对应到iptables服务的术语中分别是ACCEPT（允许流量通过）、REJECT（拒绝流量通过）、LOG（记录日志信息）、DROP（拒绝流量通过）。“允许流量通过”和“记录日志信息”都比较好理解，这里需要着重讲解的是REJECT和DROP的不同点。就DROP来说，它是直接将流量丢弃而且不响应；REJECT则会在拒绝流量后再回复一条“您的信息已经收到，但是被扔掉了”信息，从而让流量发送方清晰地看到数据被拒绝的响应信息。

我们来举一个例子，让各位读者更直观地理解这两个拒绝动作的不同之处。比如有一天您正在家里看电视，突然听到有人敲门，您透过防盗门的猫眼一看是推销商品的，便会在不需要的情况下开门并拒绝他们（REJECT）。但如果您看到的是债主带了十几个小弟来讨债，此时不仅要拒绝开门，还要默不作声，伪装成自己不在家的样子（DROP）。

当把Linux系统中的防火墙策略设置为REJECT拒绝动作后，流量发送方会看到端口不可达的响应：

```
[root@linuxprobe ~]# ping -c 4 192.168.10.10
PING 192.168.10.10 (192.168.10.10) 56(84) bytes of data.
From 192.168.10.10 icmp_seq=1 Destination Port Unreachable
From 192.168.10.10 icmp_seq=2 Destination Port Unreachable
From 192.168.10.10 icmp_seq=3 Destination Port Unreachable
From 192.168.10.10 icmp_seq=4 Destination Port Unreachable
--- 192.168.10.10 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3002ms
```

而把Linux系统中的防火墙策略修改成DROP拒绝动作后，流量发送方会看到响应超时的提醒。但是流量发送方无法判断流量是被拒绝，还是接收方主机当前不在线：

```
[root@linuxprobe ~]# ping -c 4 192.168.10.10
PING 192.168.10.10 (192.168.10.10) 56(84) bytes of data.

--- 192.168.10.10 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3000ms
```

###### **8.2.2 基本的命令参数**

iptables是一款基于[命令](https://www.linuxcool.com/)行的防火墙策略管理工具，具有大量参数，学习难度较大。好在对于日常的防火墙策略配置来讲，大家无需深入了解诸如“四表五链”的理论概念，只需要掌握常用的参数并做到灵活搭配即可，这就足以应对日常工作了。

iptables命令可以根据流量的源地址、目的地址、传输协议、服务类型等信息进行匹配，一旦匹配成功，iptables就会根据策略规则所预设的动作来处理这些流量。另外，再次提醒一下，防火墙策略规则的匹配顺序是从上至下的，因此要把较为严格、优先级较高的策略规则放到前面，以免发生错误。表8-1总结归纳了常用的iptables命令参数。再次强调，我们无需死记硬背这些参数，只需借助下面的实验来理解掌握即可。

表8-1                                           iptables中常用的参数以及作用

| 参数        | 作用                                         |
| ----------- | -------------------------------------------- |
| -P          | 设置默认策略                                 |
| -F          | 清空规则链                                   |
| -L          | 查看规则链                                   |
| -A          | 在规则链的末尾加入新规则                     |
| -I num      | 在规则链的头部加入新规则                     |
| -D num      | 删除某一条规则                               |
| -s          | 匹配来源地址IP/MASK，加叹号“!”表示除这个IP外 |
| -d          | 匹配目标地址                                 |
| -i 网卡名称 | 匹配从这块网卡流入的数据                     |
| -o 网卡名称 | 匹配从这块网卡流出的数据                     |
| -p          | 匹配协议，如TCP、UDP、ICMP                   |
| --dport num | 匹配目标端口号                               |
| --sport num | 匹配来源端口号                               |



**在iptables命令后添加-L参数查看已有的防火墙规则链：**

```
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
ACCEPT all -- anywhere anywhere ctstate RELATED,ESTABLISHED
ACCEPT all -- anywhere anywhere 
INPUT_direct all -- anywhere anywhere 
INPUT_ZONES_SOURCE all -- anywhere anywhere 
INPUT_ZONES all -- anywhere anywhere 
ACCEPT icmp -- anywhere anywhere 
REJECT all -- anywhere anywhere reject-with icmp-host-prohibited
………………省略部分输出信息………………
```

**在iptables命令后添加-F参数清空已有的防火墙规则链：**

```
[root@linuxprobe ~]# iptables -F
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
………………省略部分输出信息………………
```

**把INPUT规则链的默认策略设置为拒绝：**

```
[root@linuxprobe ~]# iptables -P INPUT DROP
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy DROP)
target prot opt source destination 
…………省略部分输出信息………………
```

如前面所提到的防火墙策略设置无非有两种方式，一种是“通”，一种是“堵”，当把INPUT链设置为默认拒绝后，就要往里面写入允许策略了，否则所有流入的数据包都会被默认拒绝掉，同学们需要留意规则链的默认策略拒绝动作只能是DROP，而不能是REJECT。

**向INPUT链中添加允许ICMP流量进入的策略规则：**

在日常运维工作中，经常会使用ping命令来检查对方主机是否在线，而向防火墙的INPUT规则链中添加一条允许ICMP流量进入的策略规则就默认允许了这种ping命令检测行为。

```
[root@linuxprobe ~]# iptables -I INPUT -p icmp -j ACCEPT
[root@linuxprobe ~]# ping -c 4 192.168.10.10
PING 192.168.10.10 (192.168.10.10) 56(84) bytes of data.
64 bytes from 192.168.10.10: icmp_seq=1 ttl=64 time=0.156 ms
64 bytes from 192.168.10.10: icmp_seq=2 ttl=64 time=0.117 ms
64 bytes from 192.168.10.10: icmp_seq=3 ttl=64 time=0.099 ms
64 bytes from 192.168.10.10: icmp_seq=4 ttl=64 time=0.090 ms
--- 192.168.10.10 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2999ms
rtt min/avg/max/mdev = 0.090/0.115/0.156/0.027 ms
```

**删除INPUT规则链中刚刚加入的那条策略（允许ICMP流量），并把默认策略设置为允许：**

```
[root@linuxprobe ~]# iptables -D INPUT 1
[root@linuxprobe ~]# iptables -P INPUT ACCEPT
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination
………………省略部分输出信息………………
```

**将INPUT规则链设置为只允许指定网段的主机访问本机的22端口，拒绝来自其他所有主机的流量**：

```
[root@linuxprobe ~]# iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j ACCEPT
[root@linuxprobe ~]# iptables -A INPUT -p tcp --dport 22 -j REJECT
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
ACCEPT tcp -- 192.168.10.0/24 anywhere tcp dpt:ssh
REJECT tcp -- anywhere anywhere tcp dpt:ssh reject-with icmp-port-unreachable
………………省略部分输出信息………………
```

再次重申，防火墙策略规则是按照从上到下的顺序匹配的，因此一定要把允许动作放到拒绝动作前面，否则所有的流量就将被拒绝掉，从而导致任何主机都无法访问我们的服务。另外，这里提到的22号端口是ssh服务使用的（有关ssh服务，请见下一章），刘遄老师先在这里挖坑，等大家学完第9章后可再验证这个实验的效果。

在设置完上述INPUT规则链之后，我们使用IP地址在192.168.10.0/24网段内的主机访问服务器（即前面提到的设置了INPUT规则链的主机）的22端口，效果如下：

```
[root@Client A ~]# ssh 192.168.10.10
The authenticity of host '192.168.10.10 (192.168.10.10)' can't be established.
ECDSA key fingerprint is 70:3b:5d:37:96:7b:2e:a5:28:0d:7e:dc:47:6a:fe:5c.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.10.10' (ECDSA) to the list of known hosts.
root@192.168.10.10's password: 
Last login: Sun Feb 12 01:50:25 2017
[root@Client A ~]#
```

然后，我们再使用IP地址在192.168.20.0/24网段内的主机访问服务器的22端口（虽网段不同，但已确认可以相互通信），效果如下，就会提示连接请求被拒绝了（Connection failed）：

```
[root@Client B ~]# ssh 192.168.10.10
Connecting to 192.168.10.10:22...
Could not connect to '192.168.10.10' (port 22): Connection failed.
```

**向INPUT规则链中添加拒绝所有人访问本机12345端口的策略规则**：

```
[root@linuxprobe ~]# iptables -I INPUT -p tcp --dport 12345 -j REJECT
[root@linuxprobe ~]# iptables -I INPUT -p udp --dport 12345 -j REJECT
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
REJECT udp -- anywhere anywhere udp dpt:italk reject-with icmp-port-unreachable
REJECT tcp -- anywhere anywhere tcp dpt:italk reject-with icmp-port-unreachable
ACCEPT tcp -- 192.168.10.0/24 anywhere tcp dpt:ssh
REJECT tcp -- anywhere anywhere tcp dpt:ssh reject-with icmp-port-unreachable
………………省略部分输出信息………………
```

**向INPUT规则链中添加拒绝192.168.10.5主机访问本机80端口（Web服务）的策略规则**：

```
[root@linuxprobe ~]# iptables -I INPUT -p tcp -s 192.168.10.5 --dport 80 -j REJECT
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
REJECT tcp -- 192.168.10.5 anywhere tcp dpt:http reject-with icmp-port-unreachable
REJECT udp -- anywhere anywhere udp dpt:italk reject-with icmp-port-unreachable
REJECT tcp -- anywhere anywhere tcp dpt:italk reject-with icmp-port-unreachable
ACCEPT tcp -- 192.168.10.0/24 anywhere tcp dpt:ssh
REJECT tcp -- anywhere anywhere tcp dpt:ssh reject-with icmp-port-unreachable
………………省略部分输出信息………………
```

**向INPUT规则链中添加拒绝所有主机访问本机1000**～**1024****端口的策略规则**：

```
[root@linuxprobe ~]# iptables -A INPUT -p tcp --dport 1000:1024 -j REJECT
[root@linuxprobe ~]# iptables -A INPUT -p udp --dport 1000:1024 -j REJECT
[root@linuxprobe ~]# iptables -L
Chain INPUT (policy ACCEPT)
target prot opt source destination 
REJECT tcp -- 192.168.10.5 anywhere tcp dpt:http reject-with icmp-port-unreachable
REJECT udp -- anywhere anywhere udp dpt:italk reject-with icmp-port-unreachable
REJECT tcp -- anywhere anywhere tcp dpt:italk reject-with icmp-port-unreachable
ACCEPT tcp -- 192.168.10.0/24 anywhere tcp dpt:ssh
REJECT tcp -- anywhere anywhere tcp dpt:ssh reject-with icmp-port-unreachable
REJECT tcp -- anywhere anywhere tcp dpts:cadlock2:1024 reject-with icmp-port-unreachable
REJECT udp -- anywhere anywhere udp dpts:cadlock2:1024 reject-with icmp-port-unreachable
………………省略部分输出信息………………
```

有关iptables命令的知识讲解到此就结束了，大家是不是意犹未尽？考虑到Linux防火墙的发展趋势，大家只要能把上面的实例吸收消化，就可以完全搞定日常的iptables配置工作了。但是请特别注意，使用iptables命令配置的防火墙规则默认会在系统下一次重启时失效，如果想让配置的防火墙策略永久生效，还要执行保存命令：

```
[root@linuxprobe ~]# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables: [ OK ]
```

**出现问题?大胆提问!**

> 因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~
>
> Linux技术交流请加A群：560843(**满**)，B群：340829(推荐)，C群：463590（**推荐**），[点此查看全国群](https://www.linuxprobe.com/club)。
>
> *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

##### **8.3 Firewalld**

RHEL 7系统中集成了多款防火墙管理工具，其中firewalld（Dynamic Firewall Manager of Linux  systems，Linux系统的动态防火墙管理器）服务是默认的防火墙配置管理工具，它拥有基于CLI（命令行界面）和基于GUI（图形用户界面）的两种管理方式。

相较于传统的防火墙管理配置工具，firewalld支持动态更新技术并加入了区域（zone）的概念。简单来说，区域就是firewalld预先准备了几套防火墙策略集合（策略模板），用户可以根据生产场景的不同而选择合适的策略集合，从而实现防火墙策略之间的快速切换。例如，我们有一台笔记本电脑，每天都要在办公室、咖啡厅和家里使用。按常理来讲，这三者的安全性按照由高到低的顺序来排列，应该是家庭、公司办公室、咖啡厅。当前，我们希望为这台笔记本电脑指定如下防火墙策略规则：在家中允许访问所有服务；在办公室内仅允许访问文件共享服务；在咖啡厅仅允许上网浏览。在以往，我们需要频繁地手动设置防火墙策略规则，而现在只需要预设好区域集合，然后只需轻点鼠标就可以自动切换了，从而极大地提升了防火墙策略的应用效率。firewalld中常见的区域名称（默认为public）以及相应的策略规则如表8-2所示。

表8-2                                     firewalld中常用的区域名称及策略规则

| 区域     | 默认规则策略                                                 |
| -------- | ------------------------------------------------------------ |
| trusted  | 允许所有的数据包                                             |
| home     | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许流量 |
| internal | 等同于home区域                                               |
| work     | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许流量 |
| public   | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许流量 |
| external | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量 |
| dmz      | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量 |
| block    | 拒绝流入的流量，除非与流出的流量相关                         |
| drop     | 拒绝流入的流量，除非与流出的流量相关                         |



###### **8.3.1 终端管理工具**

第2章在讲解[Linux命令](https://www.linuxprobe.com/)时曾经听到，命令行终端是一种极富效率的工作方式，firewall-cmd是firewalld防火墙配置管理工具的CLI（命令行界面）版本。它的参数一般都是以“长格式”来提供的，大家不要一听到长格式就头大，因为RHEL   7系统支持部分命令的参数补齐，其中就包含这条命令（很酷吧）。也就是说，现在除了能用Tab键自动补齐命令或文件名等内容之外，还可以用Tab键来补齐表8-3中所示的长格式参数了（这太棒了）。

表8-3                                   firewall-cmd命令中使用的参数以及作用

| 参数                          | 作用                                                 |
| ----------------------------- | ---------------------------------------------------- |
| --get-default-zone            | 查询默认的区域名称                                   |
| --set-default-zone=<区域名称> | 设置默认的区域，使其永久生效                         |
| --get-zones                   | 显示可用的区域                                       |
| --get-services                | 显示预先定义的服务                                   |
| --get-active-zones            | 显示当前正在使用的区域与网卡名称                     |
| --add-source=                 | 将源自此IP或子网的流量导向指定的区域                 |
| --remove-source=              | 不再将源自此IP或子网的流量导向某个指定区域           |
| --add-interface=<网卡名称>    | 将源自该网卡的所有流量都导向某个指定区域             |
| --change-interface=<网卡名称> | 将某个网卡与区域进行关联                             |
| --list-all                    | 显示当前区域的网卡配置参数、资源、端口以及服务等信息 |
| --list-all-zones              | 显示所有区域的网卡配置参数、资源、端口以及服务等信息 |
| --add-service=<服务名>        | 设置默认区域允许该服务的流量                         |
| --add-port=<端口号/协议>      | 设置默认区域允许该端口的流量                         |
| --remove-service=<服务名>     | 设置默认区域不再允许该服务的流量                     |
| --remove-port=<端口号/协议>   | 设置默认区域不再允许该端口的流量                     |
| --reload                      | 让“永久生效”的配置规则立即生效，并覆盖当前的配置规则 |
| --panic-on                    | 开启应急状况模式                                     |
| --panic-off                   | 关闭应急状况模式                                     |



与Linux系统中其他的防火墙策略配置工具一样，使用firewalld配置的防火墙策略默认为运行时（Runtime）模式，又称为当前生效模式，而且随着系统的重启会失效。如果想让配置策略一直存在，就需要使用永久（Permanent）模式了，方法就是在用firewall-cmd命令正常设置防火墙策略时添加--permanent参数，这样配置的防火墙策略就可以永久生效了。但是，永久生效模式有一个“不近人情”的特点，就是使用它设置的策略只有在系统重启之后才能自动生效。如果想让配置的策略立即生效，需要手动执行firewall-cmd  --reload命令。

接下来的实验都很简单，但是提醒大家一定要仔细查看刘遄老师使用的是Runtime模式还是Permanent模式。如果不关注这个细节，就算是正确配置了防火墙策略，也可能无法达到预期的效果。

查看firewalld服务当前所使用的区域：

```
[root@linuxprobe ~]# firewall-cmd --get-default-zone
public
```

查询eno16777728网卡在firewalld服务中的区域：

```
[root@linuxprobe ~]# firewall-cmd --get-zone-of-interface=eno16777728
public
```

把firewalld服务中eno16777728网卡的默认区域修改为external，并在系统重启后生效。分别查看当前与永久模式下的区域名称：

```
[root@linuxprobe ~]# firewall-cmd --permanent --zone=external --change-interface=eno16777728
success
[root@linuxprobe ~]# firewall-cmd --get-zone-of-interface=eno16777728
public
[root@linuxprobe ~]# firewall-cmd --permanent --get-zone-of-interface=eno16777728
external
```

把firewalld服务的当前默认区域设置为public：

```
[root@linuxprobe ~]# firewall-cmd --set-default-zone=public
success
[root@linuxprobe ~]# firewall-cmd --get-default-zone 
public
```

启动/关闭firewalld防火墙服务的应急状况模式，阻断一切网络连接（当远程控制服务器时请慎用）：

```
[root@linuxprobe ~]# firewall-cmd --panic-on
success
[root@linuxprobe ~]# firewall-cmd --panic-off
success
```

查询public区域是否允许请求SSH和HTTPS协议的流量：

```
[root@linuxprobe ~]# firewall-cmd --zone=public --query-service=ssh
yes
[root@linuxprobe ~]# firewall-cmd --zone=public --query-service=https
no
```

把firewalld服务中请求HTTPS协议的流量设置为永久允许，并立即生效：

```
[root@linuxprobe ~]# firewall-cmd --zone=public --add-service=https
success
[root@linuxprobe ~]# firewall-cmd --permanent --zone=public --add-service=https
success
[root@linuxprobe ~]# firewall-cmd --reload
success
```

把firewalld服务中请求HTTP协议的流量设置为永久拒绝，并立即生效：

```
[root@linuxprobe ~]# firewall-cmd --permanent --zone=public --remove-service=http 
success
[root@linuxprobe ~]# firewall-cmd --reload 
success
```

把在firewalld服务中访问8080和8081端口的流量策略设置为允许，但仅限当前生效：

```
[root@linuxprobe ~]# firewall-cmd --zone=public --add-port=8080-8081/tcp
success
[root@linuxprobe ~]# firewall-cmd --zone=public --list-ports 
8080-8081/tcp
```

把原本访问本机888端口的流量转发到22端口，要且求当前和长期均有效：

> 流量转发命令格式为firewall-cmd --permanent --zone=**<区域>** --add-forward-port=port=<源端口号>:proto=**<协议>**:toport=**<目标端口号>**:toaddr=**<目标IP地址>**

```
[root@linuxprobe ~]# firewall-cmd --permanent --zone=public --add-forward-port=port=888:proto=tcp:toport=22:toaddr=192.168.10.10
success
[root@linuxprobe ~]# firewall-cmd --reload
success
```

在客户端使用ssh命令尝试访问192.168.10.10主机的888端口：

```
[root@client A ~]# ssh -p 888 192.168.10.10
The authenticity of host '[192.168.10.10]:888 ([192.168.10.10]:888)' can't be established.
ECDSA key fingerprint is b8:25:88:89:5c:05:b6:dd:ef:76:63:ff:1a:54:02:1a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[192.168.10.10]:888' (ECDSA) to the list of known hosts.
root@192.168.10.10's password:此处输入远程root管理员的密码
Last login: Sun Jul 19 21:43:48 2017 from 192.168.10.10
```

firewalld中的富规则表示更细致、更详细的防火墙策略配置，它可以针对系统服务、端口号、源地址和目标地址等诸多信息进行更有针对性的策略配置。它的优先级在所有的防火墙策略中也是最高的。比如，我们可以在firewalld服务中配置一条富规则，使其拒绝192.168.10.0/24网段的所有用户访问本机的ssh服务（22端口）：

```
[root@linuxprobe ~]# firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.10.0/24" service name="ssh" reject"
success
[root@linuxprobe ~]# firewall-cmd --reload
success
```

在客户端使用ssh命令尝试访问192.168.10.10主机的ssh服务（22端口）：

```
[root@client A ~]# ssh 192.168.10.10
Connecting to 192.168.10.10:22...
Could not connect to '192.168.10.10' (port 22): Connection failed.
```

###### **8.3.2 图形管理工具**

在各种版本的Linux系统中，几乎没有能让刘遄老师欣慰并推荐的图形化工具，但是firewall-config做到了。它是firewalld防火墙配置管理工具的GUI（图形用户界面）版本，几乎可以实现所有以命令行来执行的操作。毫不夸张的说，即使读者没有扎实的Linux命令基础，也完全可以通过它来妥善配置RHEL  7中的防火墙策略。firewall-config的界面如图8-2所示，其功能具体如下。

> **1：**选择运行时（Runtime）模式或永久（Permanent）模式的配置。
>
> **2**：可选的策略集合区域列表。
>
> **3**：常用的系统服务列表。
>
> **4**：当前正在使用的区域。
>
> **5**：管理当前被选中区域中的服务。
>
> **6**：管理当前被选中区域中的端口。
>
> **7**：开启或关闭SNAT（源地址转换协议）技术。
>
> **8**：设置端口转发策略。
>
> **9**：控制请求icmp服务的流量。
>
> **10**：管理防火墙的富规则。
>
> **11**：管理网卡设备。
>
> **12**：被选中区域的服务，若勾选了相应服务前面的复选框，则表示允许与之相关的流量。
>
> **13**：firewall-config工具的运行状态。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/firewall-config界面.png)

图8-2  firewall-config的界面

刘遄老师再啰嗦几句。在使用firewall-config工具配置完防火墙策略之后，无须进行二次确认，因为只要有修改内容，它就自动进行保存。下面进行动手实践环节。

我们先将当前区域中请求http服务的流量设置为允许，但仅限当前生效。具体配置如图8-3所示。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/允许其他主机访问http服务.png)

图8-3  放行请求http服务的流量

尝试添加一条防火墙策略规则，使其放行访问8080～8088端口（TCP协议）的流量，并将其设置为永久生效，以达到系统重启后防火墙策略依然生效的目的。在按照图8-4所示的界面配置完毕之后，还需要在Options菜单中单击Reload  Firewalld命令，让配置的防火墙策略立即生效（见图8-5）。这与在命令行中执行--reload参数的效果一样。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/允许其他主机访问8080-8088端口.png)

图8-4  放行访问8080～8088端口的流量

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/重启后依然有效.png)

图8-5  让配置的防火墙策略规则立即生效

前面在讲解firewall-config工具的功能时，曾经提到了SNAT（Source Network Address  Translation，源网络地址转换）技术。SNAT是一种为了解决IP地址匮乏而设计的技术，它可以使得多个内网中的用户通过同一个外网IP接入Internet。该技术的应用非常广泛，甚至可以说我们每天都在使用，只不过没有察觉到罢了。比如，当我们通过家中的网关设备（比如无线路由器）访问本书配套站点[www.linuxprobe.com](https://www.linuxprobe.com/)时，就用到了SNAT技术。

大家可以看一下在网络中不使用SNAT技术（见图8-6）和使用SNAT技术（见图8-7）时的情况。在图8-6所示的局域网中有多台PC，如果网关服务器没有应用SNAT技术，则互联网中的网站服务器在收到PC的请求数据包，并回送响应数据包时，将无法在网络中找到这个私有网络的IP地址，所以PC也就收不到响应数据包了。在图8-7所示的局域网中，由于网关服务器应用了SNAT技术，所以互联网中的网站服务器会将响应数据包发给网关服务器，再由后者转发给局域网中的PC。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/未用SNAT1.png)

图8-6  没有使用SNAT技术的网络

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/使用SNAT1.png)

图8-7  使用SNAT技术处理过的网络

使用iptables命令实现SNAT技术是一件很麻烦的事情，但是在firewall-config中却是小菜一碟了。用户只需按照图8-8进行配置，并选中Masquerade zone复选框，就自动开启了SNAT技术。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/开启伪装功能.png)

图8-8  开启防火墙的SNAT技术

为了让大家直观查看不同工具在实现相同功能的区别，这里使用firewall-config工具重新演示了前面使用firewall-cmd来配置防火墙策略规则，将本机888端口的流量转发到22端口，且要求当前和长期均有效，具体如图8-9和图8-10所示。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/将向本机888端口的请求转发至本机的22端口.png)

图8-9  配置本地的端口转发

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/reload立即生效.png)

图8-10  让防火墙效策略规则立即生效

配置富规则，让192.168.10.20主机访问到本机的1234端口号，如图8-11所示。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/仅允许192.168.10.20主机访问本机的1234端口.png)

图8-11 配置防火墙富规则策略

如果生产环境中的服务器有多块网卡在同时提供服务（这种情况很常见），则对内网和对外网提供服务的网卡要选择的防火墙策略区域也是不一样的。也就是说，可以把网卡与防火墙策略区域进行绑定（见图8-12），这样就可以使用不同的防火墙区域策略，对源自不同网卡的流量进行针对性的监控，效果会更好。

最后，刘遄老师想说的是，firewall-config工具真的非常实用，很多原本复杂的长命令被用图形化按钮替代，设置规则也简单明了，足以应对日常工作。所以再次向大家强调配置防火墙策略的原则—只要能实现所需的功能，用什么工具请随君便。

![第8章 Iptables与Firewalld防火墙。第8章 Iptables与Firewalld防火墙。](https://www.linuxprobe.com/wp-content/uploads/2015/03/查看网卡设备信息.png)

图8-12  把网卡与防火墙策略区域进行绑定

##### **8.4 服务的访问控制列表**

TCP Wrappers是RHEL  7系统中默认启用的一款流量监控程序，它能够根据来访主机的地址与本机的目标服务程序作出允许或拒绝的操作。换句话说，Linux系统中其实有两个层面的防火墙，第一种是前面讲到的基于TCP/IP协议的流量过滤工具，而TCP  Wrappers服务则是能允许或禁止Linux系统提供服务的防火墙，从而在更高层面保护了Linux系统的安全运行。

TCP  Wrappers服务的防火墙策略由两个控制列表文件所控制，用户可以编辑允许控制列表文件来放行对服务的请求流量，也可以编辑拒绝控制列表文件来阻止对服务的请求流量。控制列表文件修改后会立即生效，系统将会先检查允许控制列表文件（/etc/hosts.allow），如果匹配到相应的允许策略则放行流量；如果没有匹配，则去进一步匹配拒绝控制列表文件（/etc/hosts.deny），若找到匹配项则拒绝该流量。如果这两个文件全都没有匹配到，则默认放行流量。

TCP Wrappers服务的控制列表文件配置起来并不复杂，常用的参数如表8-4所示。

表8-4                            TCP Wrappers服务的控制列表文件中常用的参数

| 客户端类型     | 示例                       | 满足示例的客户端列表               |
| -------------- | -------------------------- | ---------------------------------- |
| 单一主机       | 192.168.10.10              | IP地址为192.168.10.10的主机        |
| 指定网段       | 192.168.10.                | IP段为192.168.10.0/24的主机        |
| 指定网段       | 192.168.10.0/255.255.255.0 | IP段为192.168.10.0/24的主机        |
| 指定DNS后缀    | .linuxprobe.com            | 所有DNS后缀为.linuxprobe.com的主机 |
| 指定主机名称   | www.linuxprobe.com         | 主机名称为www.linuxprobe.com的主机 |
| 指定所有客户端 | ALL                        | 所有主机全部包括在内               |



在配置TCP Wrappers服务时需要遵循两个原则：

1. 编写拒绝策略规则时，填写的是服务名称，而非协议名称；
2. 建议先编写拒绝策略规则，再编写允许策略规则，以便直观地看到相应的效果。

下面编写拒绝策略规则文件，禁止访问本机sshd服务的所有流量（无须/etc/hosts.deny文件中修改原有的注释信息）：

```
[root@linuxprobe ~]# vim /etc/hosts.deny
#
# hosts.deny This file contains access rules which are used to
# deny connections to network services that either use
# the tcp_wrappers library or that have been
# started through a tcp_wrappers-enabled xinetd.
#
# The rules in this file can also be set up in
# /etc/hosts.allow with a 'deny' option instead.
#
# See 'man 5 hosts_options' and 'man 5 hosts_access'
# for information on rule syntax.
# See 'man tcpd' for information on tcp_wrappers
sshd:*
[root@linuxprobe ~]# ssh 192.168.10.10
ssh_exchange_identification: read: Connection reset by peer
```

接下来，在允许策略规则文件中添加一条规则，使其放行源自192.168.10.0/24网段，访问本机sshd服务的所有流量。可以看到，服务器立刻就放行了访问sshd服务的流量，效果非常直观：

```
[root@linuxprobe ~]# vim /etc/hosts.allow
#
# hosts.allow This file contains access rules which are used to
# allow or deny connections to network services that
# either use the tcp_wrappers library or that have been
# started through a tcp_wrappers-enabled xinetd.
#
# See 'man 5 hosts_options' and 'man 5 hosts_access'
# for information on rule syntax.
# See 'man tcpd' for information on tcp_wrappers
sshd:192.168.10.

[root@linuxprobe ~]# ssh 192.168.10.10
The authenticity of host '192.168.10.10 (192.168.10.10)' can't be established.
ECDSA key fingerprint is 70:3b:5d:37:96:7b:2e:a5:28:0d:7e:dc:47:6a:fe:5c.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.10.10' (ECDSA) to the list of known hosts.
root@192.168.10.10's password: 
Last login: Wed May 4 07:56:29 2017
[root@linuxprobe ~]# 
```

**出现问题?大胆提问!**

> 因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~
>
> Linux技术交流请加A群：560843(**满**)，B群：340829(推荐)，C群：463590（**推荐**），[点此查看全国群](https://www.linuxprobe.com/club)。
>
> *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

**本章节的复习作业(答案就在问题的下一行哦，用鼠标选中即可看到的~)**

 

1．在RHEL 7系统中，iptables是否已经被firewalld服务彻底取代？

**答：**没有，iptables和firewalld服务均可用于RHEL 7系统。

2．请简述防火墙策略规则中DROP和REJECT的不同之处。

**答：**DROP的动作是丢包，不响应；REJECT是拒绝请求，同时向发送方回送拒绝信息。

3．如何把iptables服务的INPUT规则链默认策略设置为DROP？

**答：**执行命令iptables -P INPUT DROP即可。

4．怎样编写一条防火墙策略规则，使得iptables服务可以禁止源自192.168.10.0/24网段的流量访问本机的sshd服务（22端口）？

**答：**执行命令iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j REJECT即可。

5．请简述firewalld中区域的作用。

**答：**可以依据不同的工作场景来调用不同的firewalld区域，实现大量防火墙策略规则的快速切换。

6．如何在firewalld中把默认的区域设置为dmz？

**答：**执行命令firewall-cmd --set-default-zone=dmz即可。

7．如何让firewalld中以永久（Permanent）模式配置的防火墙策略规则立即生效？

**答：**执行命令firewall-cmd --reload。

8．使用SNAT技术的目的是什么？

**答：**SNAT是一种为了解决IP地址匮乏而设计的技术，它可以使得多个内网中的用户通过同一个外网IP接入Internet（互联网）。

9． TCP Wrappers服务分别有允许策略配置文件和拒绝策略配置文件，请问匹配顺序是怎么样的？

**答：**TCP Wrappers会先依次匹配允许策略配置文件，然后再依次匹配拒绝策略配置文件，如果都没有匹配到，则默认放行流量。

本文原创地址：https://www.linuxprobe.com/chapter-08.html编辑：刘遄，审核员：暂无



### 为您推荐一些与本文相关的文章：

- [苹果将在PC端没落，Linux崛起](https://www.linuxprobe.com/iphone-pc.html)
- [高度安全的live Linux发行版——TENS](https://www.linuxprobe.com/the-highly-secure.html)
- [Linux Powershell 安装教程](https://www.linuxprobe.com/linux-powershell-installation.html)
- [苹果股价下跌会迎来iPhone最黑暗时刻吗？](https://www.linuxprobe.com/iphone-intelligent-mac.html)
- [女孩吐槽 IT 男：有钱自大无聊 约会竟爱谈工作](https://www.linuxprobe.com/american-girls-hate-itboy.html)
- [NVIDIA发布使用《圣歌》开启DLSS后 性能最高提升40%](https://www.linuxprobe.com/increase-in-performance.html)
- [开源软件Wannakey可恢复被加密数据](https://www.linuxprobe.com/open-sources-wannakey.html)
- [OpenRASP自我保护方案](https://www.linuxprobe.com/safe-openrasp.html)
- [了解ansible的Inventory与Patterns](https://www.linuxprobe.com/ansible-inventory-patterns.html)
- [安装CentOS7出现dracut:/#……time解决办法](https://www.linuxprobe.com/install-centos7-dracut-time.html)

​            相关文章[[点此投稿](https://www.linuxprobe.com/tougao)]      

-  					       [![第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/wp-content/uploads/2015/09/第23章-使用OpenLDAP部署目录服务。.jpg)](https://www.linuxprobe.com/chapter-23.html) 					   

      					       [第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/chapter-23.html)  					       2015-09-30 					       [3 个评论](https://www.linuxprobe.com/chapter-23.html#SOHUCS) 					   

-  					       [![第0章 咱们先来谈谈学习方法和红帽系统。](https://www.linuxprobe.com/wp-content/uploads/2016/03/第0章.jpg)](https://www.linuxprobe.com/chapter-00.html) 					   

      					       [第0章 咱们先来谈谈学习方法和红帽系统。](https://www.linuxprobe.com/chapter-00.html)  					       2016-03-09 					       [23 个评论](https://www.linuxprobe.com/chapter-00.html#SOHUCS) 					   

-  					       [![捷讯：李超12月26日北京顺利通过RHCE认证。](https://www.linuxprobe.com/wp-content/uploads/2018/12/19期_内蒙_李超-2.png)](https://www.linuxprobe.com/lichao.html) 					   

      					       [捷讯：李超12月26日北京顺利通过RHCE认证。](https://www.linuxprobe.com/lichao.html)  					       2018-12-30 					       [0 个评论](https://www.linuxprobe.com/lichao.html#SOHUCS) 					   

-  					       [![第19章 使用PXE+Kickstart无人值守安装服务。](https://www.linuxprobe.com/wp-content/uploads/2015/10/第19章.jpg)](https://www.linuxprobe.com/chapter-19.html) 					   

      					       [第19章 使用PXE+Kickstart无人值守安装服务。](https://www.linuxprobe.com/chapter-19.html)  					       2015-10-07 					       [12 个评论](https://www.linuxprobe.com/chapter-19.html#SOHUCS) 					   

-  					       [![第18章 使用MariaDB数据库管理系统。](https://www.linuxprobe.com/wp-content/uploads/2015/10/第18章.jpg)](https://www.linuxprobe.com/chapter-18.html) 					   

      					       [第18章 使用MariaDB数据库管理系统。](https://www.linuxprobe.com/chapter-18.html)  					       2015-10-08 					       [8 个评论](https://www.linuxprobe.com/chapter-18.html#SOHUCS) 					   

-  					       [![第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/wp-content/uploads/2015/09/第23章-使用OpenLDAP部署目录服务。.jpg)](https://www.linuxprobe.com/chapter-23.html) 					   

      					       [第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/chapter-23.html)  					       2015-09-30 					       [3 个评论](https://www.linuxprobe.com/chapter-23.html#SOHUCS) 					   

-  					       [![第0章 咱们先来谈谈学习方法和红帽系统。](https://www.linuxprobe.com/wp-content/uploads/2016/03/第0章.jpg)](https://www.linuxprobe.com/chapter-00.html) 					   

      					       [第0章 咱们先来谈谈学习方法和红帽系统。](https://www.linuxprobe.com/chapter-00.html)  					       2016-03-09 					       [23 个评论](https://www.linuxprobe.com/chapter-00.html#SOHUCS) 					   

- [Previous](https://www.linuxprobe.com/chapter-08.html#)
- [Next](https://www.linuxprobe.com/chapter-08.html#)

 转载必需保留本文链接: 				https://www.linuxprobe.com/chapter-08.html

本文依据CC-BY-NC-SA 3.0协议发布,竭诚为读者提供Linux视频教程、Linux学习资料以及红帽考试资料等优质学习