# TCP_wrappers
tcp_wrappers是linux中一个安全机制，一定程度上限制某种服务的访问权限。  
## 受管理服务
检查某种服务是否受tcp_wrappers 管理：

    ldd `which servername` | grep libwrap
       
如果有这个链接，说明某个服务接受tcp_wrappers管理，这种检查不一定正确。  
1.一般只要某些进程归xinetd管理，那么这个服务就一定接受tcp_wrappers的管理

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

2.一些独立的进程(daemons)也受tcp_wrappers的管理

     sendmail
     slapd
     sshd
     stunnel
     xinetd
     gdm
     gnone-session
     vsftpd
     portmap

3.注意：有些进程不受tcp_wrappers管理

     httpd
     smb
     squid 等

## 与tcp_wrappers相关的文件

    /etc/hosts.allow
    /etc/hosts.deny

这两个文件被整合在xinetd中.
## 工作原理
1. 当有请求从远程到达本机的时候
首先检查/etc/hosts.allow
如有匹配的，就默认允许访问,跳过 /etc/hosts.deny这个文件
没有匹配的,就去匹配/etc/hosts.deny 文件,如果有匹配的，那么就拒绝这个访问
2. 如果在这两个文件中，都没有匹配到，默认是允许访问的
四. 这两个文件格式
服务列表 ：地址列表 ：选项
A. 服务列表格式：如果有多个服务，那么就用逗号隔开
B. 地址列表格式：
1. 标准IP地址：例如：192.168.0.254，192.168.0.56如果多于一个用，隔开
2. 主机名称：例如：www.baidu.com，　.example.con匹配整个域
3. 利用掩码：192.168.0.0/255.255.255.0指定整个网段
   注意：tcp_wrappers的掩码只支持长格式，不能用：192.168.0.0/24
4. 网络名称：例如 @mynetwork
五.宏定义
ALL ：指代所有主机
LOCAL ：指代本地主机
KNOWN ：能够解析的
UNKNOWN ：不能解析的
PARANOID ：
  example：
    /etc/hosts.allow
 sshd:192.168.0.0
    /etc/hosts.deny
 sshd:ALL
 此例子表明：sshd服务只允许192.168.0.0网段的主机访问，其他拒绝。

六. 扩展选项：
spawn : 执行某个命令
 如：
vsftpd:192.168.0.0/255.255.255.0 ：spawn echo “login attempt from %c”to %s” | mail –s warning root
 其意是党192.168.0.0网段的主机来访问时，给root发一封邮件，邮件主题是：waring，邮件内容是：客户端主机（%c）试图访问服务端主机（%s)
twist : 中断命令的执行：
vsftpd:192.168.0.0/255.255.255.0: twist echo -e "\n\nWARNING connection not allowed.\n\n"
 其意是当未经允许的电脑尝试登入你的主机时， 对方的萤幕上就会显示上面的最后一行
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