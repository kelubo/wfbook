# Fail2ban
fail2ban可以监视系统日志，然后匹配日志的错误信息（正则式匹配）执行相应的屏蔽动作（一般情况下是调用防火墙屏蔽）。
  
**特性：**  
1、支持大量服务。如sshd,apache,qmail,proftpd,sasl等等。  
2、支持多种动作。如iptables,tcp-wrapper,shorewall(iptables第三方工具),mail notifications(邮件通知)等等。  
3、在logpath选项中支持通配符。  
4、需要Gamin支持(注：Gamin是用于监视文件和目录是否更改的服务工具)。
5、需要安装python,logwatch,iptables,tcp-wrapper,shorewall,Gamin。如果想要发邮件，那必需安装postfix或sendmail。
## 安装
1.**apt-get**

    apt-get install fail2ban log watch gamin

2.**yum**

    yum install fail2ban logwatch gamin ipset
  如果想接收邮件提醒，安装如下软件包。

    yum install postfix whois fail2ban-sendmail

3.**源代码**

    http://www.fail2ban.org/wiki/index.php/Downloads

安装完成后，fail2ban 的设定档在这里

    # /etc/fail2ban

    fail2ban.conf  fail2ban的配置文件  
    jail.conf      配置里是fail2ban所保护的具体服务的配置。  
    filter.d/      具体过滤规则文件目录 
    action.d/      具体过滤规则检测到后采取相对应措施的目录 

## 设置
### fail2ban.conf
    #默认日志的级别
    loglevel = 3
    #日志的目的
    logtarget = /var/log/fail2ban.log
    #socket的位置
    socket = /tmp/fail2ban.sock

### jail.conf
    [DEFAULT]
    #忽略IP,在这个清单里的IP不会被屏蔽
    ignoreip = 127.0.0.1 172.13.14.15
    #屏蔽时间
    bantime = 600
    #发现时间，在此期间内重试超过规定次数，会激活fail2ban
    findtime = 600
    #尝试次数
    maxretry = 3
    #日志修改检测机制
    backend = auto
    
    [ssh-iptables]
    #激活
    enabled = true
    #filter的名字，在filter.d目录下
    filter = sshd
    #所采用的工作，按照名字可在action.d目录下找到
    action = iptables[name=SSH, port=ssh, protocol=tcp]
    mail-whois[name=SSH, dest=root]
    #目的分析日志
    logpath = /var/log/secure
    #覆盖全局重试次数
    maxretry = 5
    #覆盖全局屏蔽时间
    bantime = 3600
    
## 启动fail2ban
**CentOS 6:**  

    service fail2ban restart

**CentOS 7:**

    systemctl restart fail2ban.service

## 设置开机启动
**CentOS 6:**

    chkconfig fail2ban on

**CentOS 7:**

    systemctl enable fail2ban