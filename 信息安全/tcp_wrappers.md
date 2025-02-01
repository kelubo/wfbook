# TCP_wrappers

[TOC]

## 概述

TCP_wrappers 是 linux 中一个安全机制，外来连接请求首先通过这个安全检测，获得安全认证后才可被系统服务接受，一定程度上限制某种服务的访问权限，防止主机名和主机地址欺骗。

## 受管理服务
检查某种服务是否受 TCP_wrappers 管理：

```bash
ldd `which servername` | grep libwrap
```

如果有这个链接，说明某个服务接受 TCP_wrappers 管理，这种检查不一定正确。

1. 与 xinted 进程关系较紧密。一般而言，受 xinetd 进程管理的服务都可以对其进行 TCP_wrappers 的设置。

   ```bash
   chargen-dgram
   chargen-stream
   cvs
   daytime-dgram
   daytime-stream
   discard-dgram
   discard-stream
   echo-dgram
   echo-stream
   eklogin
   ekrb5-telnet
   gssftp
   klogin
   krb5-telnet
   kshell
   rsync
   tcpmux-server
   telnet
   time-dgram
   time-stream
   ```

2. 一些独立的进程 (daemons) 也受 TCP_wrappers 的管理

   ```bash
   sendmail
   slapd
   sshd
   stunnel
   xinetd
   gdm
   gnone-session
   vsftpd
   portmap
   ```

3. 有些进程不受 TCP_wrappers 管理

   ```bash
   httpd
   smb
   squid 等
   ```

## 与 TCP_wrappers 相关的文件

```bash
/etc/hosts.allow
/etc/hosts.deny
```

这两个文件被整合在 xinetd 中。
## 工作原理
1. 当有请求从远程到达本机时，首先检查 /etc/hosts.allow 。
  * 如有匹配的，就默认允许访问，跳过 /etc/hosts.deny 这个文件。
  * 没有匹配的，就去匹配 /etc/hosts.deny 文件，如果有匹配的，那么就拒绝这个访问。
2. 如果在这两个文件中，都没有匹配到，默认是允许访问的。

## 文件格式

```bash
服务列表:地址列表:操作符
```

1. 服务列表

   如果有多个服务，那么就用逗号隔开。

2. 地址列表

   * 标准IP地址

     例如：192.168.0.254，192.168.0.56 。如果多于一个用，隔开。

   * 主机名称

     例如：www.baidu.com，.example.con匹配整个域

   * 利用掩码192.168.0.0/255.255.255.0 指定整个网段

     注意：TCP_wrappers 的掩码只支持长格式，不能用 192.168.0.0/24

   * 网络名称例如 @mynetwork

3. 操作符

   * ALLOW

     允许操作。

   * DENY

     拒绝操作。

   * EXCEPT

     除了 XXXX ，EXCEPT 后面的内容将会被排除在规则之外。

## 文件中所支持的通配符

* ALL ：              指代所有主机。
* LOCAL ：         指代本地主机，即主机名中没有 “.”。
* KNOWN ：      代表已知的用户和主机。
* UNKNOWN ：代表所有未知的用户和主机。
* PARANOID ： 代表所有主机名与地址不符的主机。

example：

```bash
/etc/hosts.allow
sshd:192.168.0.0

/etc/hosts.deny
sshd:ALL
```

此例子表明：sshd 服务只允许 192.168.0.0 网段的主机访问，其他拒绝。

## 扩展命令

### spawn : 执行某个命令

```bash
vsftpd:192.168.0.0/255.255.255.0 ：spawn echo “login attempt from %c”to %s” | mail –s warning root
```


当 192.168.0.0 网段的主机来访问时，给 root 发一封邮件，邮件主题是：waring ，邮件内容是：客户端主机（%c）试图访问服务端主机（%s) 。

### twist : 中断命令的执行

```bash
vsftpd:192.168.0.0/255.255.255.0: twist echo -e "\n\nWARNING connection not allowed.\n\n"
```

当未经允许的电脑尝试登入主机时， 对方的屏幕上就会显示上面的最后一行。


### 通配符

| 通配符 | 描述                                               |
| ------ | -------------------------------------------------- |
| %a     | 客户端地址。                                       |
| %A     | 服务器端地址。                                     |
| %c     | 客户端信息，例如 user@host，user@address 。        |
| %d     | 服务器进程名称。                                   |
| %s     | 服务信息。                                         |
| %h     | 不可达的客户端主机名或 IP 地址。                   |
| %H     | 不可达的服务器端主机名或 IP 地址。                 |
| %n     | 未知的客户端主机或客户端主机名与 IP 地址不符。     |
| %N     | 未知的服务器端主机或服务器端主机名与 IP 地址不符。 |
| %p     | 服务进程 ID 。                                     |
| %s     | 服务器端信息，例如 daemon@host，daemon@address 。  |
| %u     | 客户端用户名。                                     |
| %%     | 标记 % 。                                          |

七.高级用法
daemaon@host：client_list
对于多块网卡的linux主机，要想用tcp_wrappers做一些控制得基于接口：
如eth0所在的网段：192.168.0.0 eth1所在的网段：192.168.1.0
 则：
   sshd@192.168.0.11:192.168.0.
   sshd@192.168.1.34:192.168.1.
   则两句可以根据需要写到hosts.allow或hosts.deny中

典例：
/etc/hosts.allow
 sshd:ALL EXCEPT .cracker.org EXCEPT trusted.cracker.org
/etc/hosts.deny
 sshd:ALL
此例用到了EXCEPT的嵌套,其意思是：允许所有访问sshd服务，在域.cracker.org的不允许访问
但是trusted.cracker.org除外
sshd：ALL 就是拒绝.cracker.org的访问，因为默认是允许，所以在hosts.deny中必须明确定义。

## 示例

允许 .friendly.domain 中的所有主机访问服务器，其他主机不能访问该服务器。

```bash
/etc/hosts.allow

ALL: .friendly.domain: ALLOW
ALL: ALL: DENY
```

拒绝 .bad.domain 域中的所有主机访问服务器，其他主机允许访问服务器。

```bash
/etc/hosts.allow

ALL: .bad.domain: DENY
ALL: ALL: ALLOW
```

拒绝所有未知主机访问服务器。

```bash
/etc/hosts.deny

ALL: UNKNOWN
```

拒绝所有主机访问服务器。

```bash
/etc/hosts.deny

ALL: ALL
```

允许本地主机及除 client.foobar.edu 外的 foobar.edu 域的其他主机访问服务器。

```bash
/etc/hosts.allow

ALL: LOCAL
ALL: .foobar.edu EXCEPT client.foobar.edu
```

允许本地主机及 foobar.edu 域的主机访问服务器 sshd 服务。

```bash
/etc/hosts.allow

sshd: LOCAL, .foobar.edu
```

只允许 host.domain 域及 my.domain 域的用户访问服务器 FTP 服务，其他服务均不可访问。

```bash
/etc/hosts.deny

ALL EXCEPT vsftpd： host.domain,my.domain
```

