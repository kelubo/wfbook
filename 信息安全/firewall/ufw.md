# ufw

# Firewalls 防火墙 

## Introduction 介绍 

The Linux kernel includes the *Netfilter* subsystem, which is used to manipulate or decide the fate of network  traffic headed into or through your server. All modern Linux firewall  solutions use this system for packet filtering.
Linux内核包括Netfilter子系统，该子系统用于控制或决定进入或通过服务器的网络流量的命运。所有现代Linux防火墙解决方案都使用此系统进行数据包过滤。

The kernel’s packet filtering system would be of little use to  administrators without a userspace interface to manage it. This is the  purpose of iptables: When a packet reaches your server, it will be  handed off to the Netfilter subsystem for acceptance, manipulation, or  rejection based on the rules supplied to it from userspace via iptables. Thus, iptables is all you need to manage your firewall, if you’re  familiar with it, but many frontends are available to simplify the task.
如果没有用户空间接口来管理内核的包过滤系统，那么它对管理员来说就没有什么用处了。这就是iptables的作用：当一个包到达服务器时，它将被移交给Netfilter子系统，根据用户空间通过iptables提供给它的规则进行接受、操作或拒绝。因此，如果您熟悉iptables，那么它就是您管理防火墙所需的全部，但是许多前端都可以简化任务。 

## ufw - Uncomplicated Firewall ufw -简单的防火墙 

The default firewall configuration tool for Ubuntu is ufw. Developed to  ease iptables firewall configuration, ufw provides a user-friendly way  to create an IPv4 or IPv6 host-based firewall.
Ubuntu的默认防火墙配置工具是ufw。ufw是为了简化iptables防火墙配置而开发的，它提供了一种用户友好的方式来创建基于IPv4或IPv6主机的防火墙。 

ufw by default is initially disabled. From the ufw man page:
默认情况下，最初禁用UFW。来自ufw手册页： 

“ufw is not intended to provide complete firewall functionality via its  command interface, but instead provides an easy way to add or remove  simple rules. It is currently mainly used for host-based firewalls.”
“ufw并不打算通过其命令界面提供完整的防火墙功能，而是提供一种简单的方法来添加或删除简单的规则。它目前主要用于基于主机的防火墙。 

The following are some examples of how to use ufw:
以下是一些如何使用ufw的例子： 

- First, ufw needs to be enabled. From a terminal prompt enter:
  首先，需要启用ufw。在终端提示符下输入： 

  ```
  sudo ufw enable
  ```

- To open a port (SSH in this example):
  打开端口（本例中为SSH）： 

  ```
  sudo ufw allow 22
  ```

- Rules can also be added using a *numbered* format:
  也可以使用编号格式添加规则：

  ```
  sudo ufw insert 1 allow 80
  ```

- Similarly, to close an opened port:
  类似地，要关闭打开的端口： 

  ```
  sudo ufw deny 22
  ```

- To remove a rule, use delete followed by the rule:
  要删除规则，请使用delete，然后使用规则： 

  ```
  sudo ufw delete deny 22
  ```

- It is also possible to allow access from specific hosts or networks to a  port. The following example allows SSH access from host 192.168.0.2 to  any IP address on this host:
  也可以允许从特定主机或网络访问端口。以下示例允许从主机www.example.com到此主机上的任何IP地址进行SSH访问： 

  ```
  sudo ufw allow proto tcp from 192.168.0.2 to any port 22
  ```

  Replace 192.168.0.2 with 192.168.0.0/24 to allow SSH access from the entire subnet.
  将192.168.0.2替换为192.168.0.0/24以允许从整个子网进行SSH访问。 

- Adding the *–dry-run* option to a *ufw* command will output the resulting rules, but not apply them. For  example, the following is what would be applied if opening the HTTP  port:
  将-dry-run选项添加到ufw命令将输出结果规则，但不应用它们。例如，以下是打开HTTP端口时将应用的内容：

  ```auto
   sudo ufw --dry-run allow http
  ```

  ```
  *filter
  :ufw-user-input - [0:0]
  :ufw-user-output - [0:0]
  :ufw-user-forward - [0:0]
  :ufw-user-limit - [0:0]
  :ufw-user-limit-accept - [0:0]
  ### RULES ###
  
  ### tuple ### allow tcp 80 0.0.0.0/0 any 0.0.0.0/0
  -A ufw-user-input -p tcp --dport 80 -j ACCEPT
  
  ### END RULES ###
  -A ufw-user-input -j RETURN
  -A ufw-user-output -j RETURN
  -A ufw-user-forward -j RETURN
  -A ufw-user-limit -m limit --limit 3/minute -j LOG --log-prefix "[UFW LIMIT]: "
  -A ufw-user-limit -j REJECT
  -A ufw-user-limit-accept -j ACCEPT
  COMMIT
  Rules updated
  ```

- ufw can be disabled by:
  可通过以下方式禁用ufw： 

  ```
  sudo ufw disable
  ```

- To see the firewall status, enter:
  要查看防火墙状态，请输入： 

  ```
  sudo ufw status
  ```

- And for more verbose status information use:
  对于更详细的状态信息，请使用：用途： 

  ```
  sudo ufw status verbose
  ```

- To view the *numbered* format:
  要查看编号格式，请执行以下操作：

  ```
  sudo ufw status numbered
  ```

> **Note 注意**
>
> If the port you want to open or close is defined in `/etc/services`, you can use the port name instead of the number. In the above examples, replace *22* with *ssh*.
> 如果要打开或关闭的端口在 `/etc/services` 中定义，则可以使用端口名称而不是端口号。在上面的例子中，将22替换为ssh。

This is a quick introduction to using ufw. Please refer to the ufw man page for more information.
这是一个使用ufw的快速介绍。请参考ufw手册页以获取更多信息。 

### ufw Application Integration ufw应用集成 

Applications that open ports can include an ufw profile, which details the ports  needed for the application to function properly. The profiles are kept  in `/etc/ufw/applications.d`, and can be edited if the default ports have been changed.
打开端口的应用程序可以包含ufw配置文件，其中详细说明了应用程序正常运行所需的端口。配置文件保存在 `/etc/ufw/applications.d` 中，如果默认端口已更改，则可以对其进行编辑。

- To view which applications have installed a profile, enter the following in a terminal:
  要查看哪些应用程序已安装配置文件，请在终端中输入以下内容： 

  ```
  sudo ufw app list
  ```

- Similar to allowing traffic to a port, using an application profile is accomplished by entering:
  与允许流量到达端口类似，使用应用程序配置文件的方法是输入： 

  ```
  sudo ufw allow Samba
  ```

- An extended syntax is available as well:
  也可以使用扩展语法： 

  ```
  ufw allow from 192.168.0.0/24 to any app Samba
  ```

  Replace *Samba* and *192.168.0.0/24* with the application profile you are using and the IP range for your network.
  将桑巴舞和192.168.0.0/24替换为您正在使用的应用程序配置文件和网络的IP范围。

  > **Note 注意**
  >
  > There is no need to specify the *protocol* for the application, because that information is detailed in the profile. Also, note that the *app* name replaces the *port* number.
  > 不需要为应用程序指定协议，因为该信息在配置文件中有详细说明。此外，请注意，应用程序名称将替换端口号。

- To view details about which ports, protocols, etc., are defined for an application, enter:
  要查看有关哪些端口、协议等的详细信息，为应用程序定义，请输入： 

  ```
  sudo ufw app info Samba
  ```

Not all applications that require opening a network port come with ufw  profiles, but if you have profiled an application and want the file to  be included with the package, please file a bug against the package in  Launchpad.
并非所有需要打开网络端口的应用程序都带有ufw配置文件，但如果您已经分析了应用程序并希望将文件包含在软件包中，请在Launchpad中针对软件包提交错误。 

```
ubuntu-bug nameofpackage
```

## IP Masquerading IP伪装 

The purpose of IP Masquerading is to allow machines with private,  non-routable IP addresses on your network to access the Internet through the machine doing the masquerading. Traffic from your private network  destined for the Internet must be manipulated for replies to be routable back to the machine that made the request. To do this, the kernel must  modify the *source* IP address of each packet so that replies will be routed back to it,  rather than to the private IP address that made the request, which is  impossible over the Internet. Linux uses *Connection Tracking* (conntrack) to keep track of which connections belong to which machines and reroute each return packet accordingly. Traffic leaving your  private network is thus “masqueraded” as having originated from your  Ubuntu gateway machine. This process is referred to in Microsoft  documentation as Internet Connection Sharing.
IP伪装的目的是允许网络上具有私有、不可路由IP地址的机器通过进行伪装的机器访问Internet。必须对专用网络中发往Internet的流量进行处理，以使回复可路由回发出请求的计算机。要做到这一点，内核必须修改每个数据包的源IP地址，以便将回复路由回它，而不是发送请求的私有IP地址，这在Internet上是不可能的。Linux使用连接跟踪（conntrack）来跟踪哪些连接属于哪些机器，并相应地重新路由每个返回数据包。离开您的专用网络的流量因此被“伪装”为源自您的Ubuntu网关机器。此过程在Microsoft文档中称为Internet连接共享。

### ufw Masquerading ufw伪装 

IP Masquerading can be achieved using custom ufw rules. This is possible  because the current back-end for ufw is iptables-restore with the rules  files located in `/etc/ufw/*.rules`. These files are a great place to add legacy iptables rules used without ufw, and rules that are more network gateway or bridge related.
IP伪装可以使用自定义ufw规则来实现。这是可能的，因为ufw的当前后端是iptables-restore，规则文件位于 `/etc/ufw/*.rules` 。这些文件是添加不使用ufw的遗留iptables规则以及与网关或网桥相关的规则的好地方。

The rules are split into two different files, rules that should be executed before ufw command line rules, and rules that are executed after ufw  command line rules.
这些规则分为两个不同的文件，一个是应在ufw命令行规则之前执行的规则，另一个是在ufw命令行规则之后执行的规则。 

- First, packet forwarding needs to be enabled in ufw. Two configuration files will need to be adjusted, in `/etc/default/ufw` change the *DEFAULT_FORWARD_POLICY* to “ACCEPT”:
  首先，需要在ufw中启用数据包转发。需要调整两个配置文件，在 `/etc/default/ufw` 中将DEFAULT_FORWARD_POLICY更改为“ACCEPT”：

  ```
  DEFAULT_FORWARD_POLICY="ACCEPT"
  ```

  Then edit `/etc/ufw/sysctl.conf` and uncomment:
  然后编辑 `/etc/ufw/sysctl.conf` 并取消注释：

  ```
  net/ipv4/ip_forward=1
  ```

  Similarly, for IPv6 forwarding uncomment:
  类似地，对于IPv6转发取消注释： 

  ```
  net/ipv6/conf/default/forwarding=1
  ```

- Now add rules to the `/etc/ufw/before.rules` file. The default rules only configure the *filter* table, and to enable masquerading the *nat* table will need to be configured. Add the following to the top of the file just after the header comments:
  现在将规则添加到 `/etc/ufw/before.rules` 文件。默认规则只配置过滤器表，要启用伪装，需要配置nat表。将以下内容添加到文件顶部的头注释之后：

  ```
  # nat Table rules
  *nat
  :POSTROUTING ACCEPT [0:0]
  
  # Forward traffic from eth1 through eth0.
  -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
  
  # don't delete the 'COMMIT' line or these nat table rules won't be processed
  COMMIT
  ```

  The comments are not strictly necessary, but it is considered good practice to document your configuration. Also, when modifying any of the *rules* files in `/etc/ufw`, make sure these lines are the last line for each table modified:
  这些注释并不是绝对必要的，但记录您的配置被认为是一种良好的做法。此外，在修改 `/etc/ufw` 中的任何规则文件时，请确保这些行是修改的每个表的最后一行：

  ```
  # don't delete the 'COMMIT' line or these rules won't be processed
  COMMIT
  ```

  For each *Table* a corresponding *COMMIT* statement is required. In these examples only the *nat* and *filter* tables are shown, but you can also add rules for the *raw* and *mangle* tables.
  每个表都需要一个相应的COMMIT语句。在这些示例中，只显示了nat和filter表，但您也可以为raw和mangle表添加规则。

  > **Note 注意**
  >
  > In the above example replace *eth0*, *eth1*, and *192.168.0.0/24* with the appropriate interfaces and IP range for your network.
  > 在上面的示例中，将eth0、eth1和192.168.0.0/24替换为您网络的相应接口和IP范围。

- Finally, disable and re-enable ufw to apply the changes:
  最后，禁用并重新启用ufw以应用更改： 

  ```
  sudo ufw disable && sudo ufw enable
  ```

IP Masquerading should now be enabled. You can also add any additional FORWARD rules to the `/etc/ufw/before.rules`. It is recommended that these additional rules be added to the *ufw-before-forward* chain.
现在应启用IP伪装。您还可以将任何其他FORWARD规则添加到 `/etc/ufw/before.rules` 。建议将这些附加规则添加到ufw前转发链中。

### iptables Masquerading iptables伪装 

iptables can also be used to enable Masquerading.
iptables也可以用于启用伪装。 

- Similar to ufw, the first step is to enable IPv4 packet forwarding by editing `/etc/sysctl.conf` and uncomment the following line:
  与ufw类似，第一步是通过编辑 `/etc/sysctl.conf` 并取消注释以下行来启用IPv4数据包转发：

  ```
  net.ipv4.ip_forward=1
  ```

  If you wish to enable IPv6 forwarding also uncomment:
  如果您希望启用IPv6转发，请取消注释： 

  ```
  net.ipv6.conf.default.forwarding=1
  ```

- Next, execute the sysctl command to enable the new settings in the configuration file:
  接下来，执行sysctl命令以启用配置文件中的新设置： 

  ```
  sudo sysctl -p
  ```

- IP Masquerading can now be accomplished with a single iptables rule, which may differ slightly based on your network configuration:
  IP伪装现在可以通过一个iptables规则来完成，根据您的网络配置可能会略有不同： 

  ```
  sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

  The above command assumes that your private address space is 192.168.0.0/16 and that your Internet-facing device is ppp0. The syntax is broken down as follows:
  上面的命令假设您的私有地址空间是www.example.com，并且您的面向Internet的设备是ppp 0。语法如下： 

  - -t nat – the rule is to go into the nat table
    -t nat -规则是进入nat表 
  - -A POSTROUTING – the rule is to be appended (-A) to the POSTROUTING chain
    -A POSTROUTING -规则将被附加（-A）到POSTROUTING链 
  - -s 192.168.0.0/16 – the rule applies to traffic originating from the specified address space
    -s 192.168.0.0/16 
  - -o ppp0 – the rule applies to traffic scheduled to be routed through the specified network device
    -o ppp 0-规则适用于计划通过指定网络设备路由的流量 
  - -j MASQUERADE – traffic matching this rule is to “jump” (-j) to the MASQUERADE target to be manipulated as described above
    -j MASQUERADE -与此规则匹配的流量将“跳转”（-j）到MASQUERADE目标，以如上所述进行操作 

- Also, each chain in the filter table (the default table, and where most or all packet filtering occurs) has a default *policy* of ACCEPT, but if you are creating a firewall in addition to a gateway  device, you may have set the policies to DROP or REJECT, in which case  your masqueraded traffic needs to be allowed through the FORWARD chain  for the above rule to work:
  此外，过滤器表（默认表，以及大多数或所有数据包过滤发生的地方）中的每个链都有一个默认策略ACCEPT，但如果您除了创建网关设备外还创建了防火墙，则可能已将策略设置为DROP或RESISTANCE，在这种情况下，需要允许伪装的流量通过FORWARD链，以使上述规则生效：

  ```
  sudo iptables -A FORWARD -s 192.168.0.0/16 -o ppp0 -j ACCEPT
  sudo iptables -A FORWARD -d 192.168.0.0/16 -m state \
  --state ESTABLISHED,RELATED -i ppp0 -j ACCEPT
  ```

  The above commands will allow all connections from your local network to  the Internet and all traffic related to those connections to return to  the machine that initiated them.
  上述命令将允许从本地网络到Internet的所有连接以及与这些连接相关的所有流量返回到启动它们的计算机。 

- If you want masquerading to be enabled on reboot, which you probably do, edit `/etc/rc.local` and add any commands used above. For example add the first command with no filtering:
  如果您希望在重新引导时启用伪装，您可能会这样做，请编辑 `/etc/rc.local` 并添加上面使用的任何命令。例如，添加第一个不带过滤的命令：

  ```
  iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

## Logs 日志 

Firewall logs are essential for recognizing attacks, troubleshooting your  firewall rules, and noticing unusual activity on your network. You must  include logging rules in your firewall for them to be generated, though, and logging rules must come before any applicable terminating rule (a  rule with a target that decides the fate of the packet, such as ACCEPT,  DROP, or REJECT).
防火墙日志对于识别攻击、对防火墙规则进行故障排除以及注意网络上的异常活动至关重要。但是，您必须在防火墙中包含日志规则才能生成日志规则，并且日志规则必须位于任何适用的终止规则（具有决定数据包命运的目标的规则，例如ACCEPT，DROP或RETURN）之前。 

If you are using ufw, you can turn on logging by entering the following in a terminal:
如果您使用ufw，您可以通过在终端中输入以下内容来打开日志记录： 

```
sudo ufw logging on
```

To turn logging off in ufw, simply replace *on* with *off* in the above command.
要在ufw中关闭日志记录，只需将上面命令中的on替换为off。

If using iptables instead of ufw, enter:
如果使用iptables而不是ufw，请输入： 

```
sudo iptables -A INPUT -m state --state NEW -p tcp --dport 80 \
-j LOG --log-prefix "NEW_HTTP_CONN: "
```

A request on port 80 from the local machine, then, would generate a log  in dmesg that looks like this (single line split into 3 to fit this  document):
然后，来自本地机器的端口80上的请求将在dmesg中生成如下所示的日志（单行分为3行以适应此文档）： 

```
[4304885.870000] NEW_HTTP_CONN: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00
SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=58288 DF PROTO=TCP
SPT=53981 DPT=80 WINDOW=32767 RES=0x00 SYN URGP=0
```

The above log will also appear in `/var/log/messages`, `/var/log/syslog`, and `/var/log/kern.log`. This behavior can be modified by editing `/etc/syslog.conf` appropriately or by installing and configuring ulogd and using the ULOG target instead of LOG. The ulogd daemon is a userspace server that  listens for logging instructions from the kernel specifically for  firewalls, and can log to any file you like, or even to a PostgreSQL or  MySQL database. Making sense of your firewall logs can be simplified by  using a log analyzing tool such as logwatch, fwanalog, fwlogwatch, or  lire.
上述日志也将出现在 `/var/log/messages` 、 `/var/log/syslog` 和 `/var/log/kern.log` 中。可以通过适当地编辑 `/etc/syslog.conf`  或通过安装和配置ulogd并使用Ulogd目标而不是Ulogd来修改此行为。ulogd守护进程是一个用户空间服务器，它专门为防火墙监听来自内核的日志记录指令，可以记录到任何你喜欢的文件，甚至可以记录到PostgreSQL或MySQL数据库。通过使用日志分析工具，如logwatch、fwanwatch、fwlogwatch或lire，可以简化对防火墙日志的理解。

## Other Tools 其他工具 

There are many tools available to help you construct a complete firewall  without intimate knowledge of iptables. A command-line tool with  plain-text configuration files:
有许多工具可以帮助您构建一个完整的防火墙，而无需深入了解iptables。带有纯文本配置文件的命令行工具： 

- [Shorewall](http://www.shorewall.net/) is a very powerful solution to help you configure an advanced firewall for any network.
   Shorewall是一个非常强大的解决方案，可以帮助您为任何网络配置高级防火墙。

## References 引用 

- The [Ubuntu Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) wiki page contains information on the development of ufw.
  Ubuntu防火墙wiki页面包含有关ufw开发的信息。
- Also, the ufw manual page contains some very useful information: `man ufw`.
  此外，ufw手册页包含一些非常有用的信息： `man ufw` 。
- See the [packet-filtering-HOWTO](http://www.netfilter.org/documentation/HOWTO/packet-filtering-HOWTO.html) for more information on using iptables.
  有关使用iptables的更多信息，请参阅packet-filtering-HOWTO。
- The [nat-HOWTO](http://www.netfilter.org/documentation/HOWTO/NAT-HOWTO.html) contains further details on masquerading.
  nat-HOWTO包含关于伪装的更多细节。
- The [IPTables HowTo](https://help.ubuntu.com/community/IptablesHowTo) in the Ubuntu wiki is a great resource.
  Ubuntu wiki中的IPTables HowTo是一个很好的资源。





UFW是一个 Arch Linux、Debian 或 Ubuntu 中管理防火墙规则的前端。

## 安装

关闭

    $ sudo service ufw stop

禁用

    $ sudo ufw disable

UFW 默认包含在 Ubuntu 中，但在 Arch 和 Debian 中需要安装。 Debian 将自动启用 UFW 的 systemd 单元，并使其在重新启动时启动，但 Arch 不会。 这与告诉 UFW 启用防火墙规则不同，因为使用 systemd 或者 upstart 启用 UFW 仅仅是告知 init 系统打开 UFW 守护程序。

    默认情况下，UFW 的规则集为空，因此即使守护程序正在运行，也不会强制执行任何防火墙规则。 强制执行防火墙规则集的部分在下面。
    Arch Linux
    
    1、 安装 UFW：
    
        sudo pacman -S ufw
    
    2、 启动并启用 UFW 的 systemd 单元：
    
        sudo systemctl start ufw
        sudo systemctl enable ufw
    
    Debian / Ubuntu
    
    1、 安装 UFW
    
        sudo apt-get install ufw
    
    使用 UFW 管理防火墙规则
    设置默认规则
    
    大多数系统只需要打开少量的端口接受传入连接，并且关闭所有剩余的端口。 从一个简单的规则基础开始，ufw default命令可以用于设置对传入和传出连接的默认响应动作。 要拒绝所有传入并允许所有传出连接，那么运行：
    
        sudo ufw default allow outgoing
        sudo ufw default deny incoming
    
    ufw default 也允许使用 reject 参数。
    
        警告：
    
        除非明确设置允许规则，否则配置默认 deny 或 reject 规则会锁定你的服务器。确保在应用默认 deny 或 reject 规则之前，已按照下面的部分配置了 SSH 和其他关键服务的允许规则。
    
    添加规则
    
    可以有两种方式添加规则：用端口号或者服务名表示。
    
    要允许 SSH 的 22 端口的传入和传出连接，你可以运行：
    
        sudo ufw allow ssh
    
    你也可以运行：
    
        sudo ufw allow 22
    
    相似的，要在特定端口（比如 111）上 deny 流量，你需要运行：
    
        sudo ufw deny 111
    
    为了更好地调整你的规则，你也可以允许基于 TCP 或者 UDP 的包。下面例子会允许 80 端口的 TCP 包：
    
        sudo ufw allow 80/tcp
        sudo ufw allow http/tcp
    
    这个会允许 1725 端口上的 UDP 包：
    
        sudo ufw allow 1725/udp
    
    高级规则
    
    除了基于端口的允许或阻止，UFW 还允许您按照 IP 地址、子网和 IP 地址/子网/端口的组合来允许/阻止。
    
    允许从一个 IP 地址连接：
    
        sudo ufw allow from 123.45.67.89
    
    允许特定子网的连接：
    
        sudo ufw allow from 123.45.67.89/24
    
    允许特定 IP/ 端口的组合：
    
        sudo ufw allow from 123.45.67.89 to any port 22 proto tcp
    
    proto tcp 可以删除或者根据你的需求改成 proto udp，所有例子的 allow 都可以根据需要变成 deny。
    删除规则
    
    要删除一条规则，在规则的前面加上 delete。如果你希望不再允许 HTTP 流量，你可以运行：
    
        sudo ufw delete allow 80
    
    删除规则同样可以使用服务名。
    编辑 UFW 的配置文件
    
    虽然可以通过命令行添加简单的规则，但仍有可能需要添加或删除更高级或特定的规则。 在运行通过终端输入的规则之前，UFW 将运行一个文件 before.rules，它允许回环接口、ping 和 DHCP 等服务。要添加或改变这些规则，编辑 /etc/ufw/before.rules 这个文件。 同一目录中的 before6.rules 文件用于 IPv6 。
    
    还存在一个 after.rule 和 after6.rule 文件，用于添加在 UFW 运行你通过命令行输入的规则之后需要添加的任何规则。
    
    还有一个配置文件位于 /etc/default/ufw。 从此处可以禁用或启用 IPv6，可以设置默认规则，并可以设置 UFW 以管理内置防火墙链。
    UFW 状态
    
    你可以在任何时候使用命令：sudo ufw status 查看 UFW 的状态。这会显示所有规则列表，以及 UFW 是否处于激活状态：
    
        Status: active
        To                         Action      From
        --                         ------      ----
        22                         ALLOW       Anywhere
        80/tcp                     ALLOW       Anywhere
        443                        ALLOW       Anywhere
        22 (v6)                    ALLOW       Anywhere (v6)
        80/tcp (v6)                ALLOW       Anywhere (v6)
        443 (v6)                   ALLOW       Anywhere (v6)
    
    启用防火墙
    
    随着你选择规则完成，你初始运行 ufw status 可能会输出 Status: inactive。 启用 UFW 并强制执行防火墙规则：
    
        sudo ufw enable
    
    相似地，禁用 UFW 规则：
    
        sudo ufw disable
    
        UFW 会继续运行，并且在下次启动时会再次启动。
    
    日志记录
    
    你可以用下面的命令启动日志记录：
    
        sudo ufw logging on
    
    可以通过运行 sudo ufw logging low|medium|high 设计日志级别，可以选择 low、 medium 或者 high。默认级别是 low。
    
    常规日志类似于下面这样，位于 /var/logs/ufw：
    
        Sep 16 15:08:14 <hostname> kernel: [UFW BLOCK] IN=eth0 OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:00:00 SRC=123.45.67.89 DST=987.65.43.21 LEN=40 TOS=0x00 PREC=0x00 TTL=249 ID=8475 PROTO=TCP SPT=48247 DPT=22 WINDOW=1024 RES=0x00 SYN URGP=0
    
    前面的值列出了你的服务器的日期、时间、主机名。剩下的重要信息包括：
    
        [UFW BLOCK]：这是记录事件的描述开始的位置。在此例中，它表示阻止了连接。
        IN：如果它包含一个值，那么代表该事件是传入事件
        OUT：如果它包含一个值，那么代表事件是传出事件
        MAC：目的地和源 MAC 地址的组合
        SRC：包源的 IP
        DST：包目的地的 IP
        LEN：数据包长度
        TTL：数据包 TTL，或称为 time to live。 在找到目的地之前，它将在路由器之间跳跃，直到它过期。
        PROTO：数据包的协议
        SPT：包的源端口
        DPT：包的目标端口
        WINDOW：发送方可以接收的数据包的大小
        SYN URGP：指示是否需要三次握手。 0 表示不需要。
