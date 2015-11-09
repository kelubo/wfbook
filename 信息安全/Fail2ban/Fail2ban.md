# Fail2ban
fail2ban可以监视系统日志，然后匹配日志的错误信息（正则式匹配）执行相应的屏蔽动作（一般情况下是调用防火墙屏蔽）。
  
**特性：**  
1、支持大量服务。如sshd,apache,qmail,proftpd,sasl等等。  
2、支持多种动作。如iptables,tcp-wrapper,shorewall(iptables第三方工具),mail notifications(邮件通知)等等。  
3、在logpath选项中支持通配符。  
4、需要Gamin支持(注：Gamin是用于监视文件和目录是否更改的服务工具)。
5、需要安装python,logwatch,iptables,tcp-wrapper,shorewall,Gamin。如果想要发邮件，那必需安装postfix或sendmail。
## 安装
**apt-get**

    apt-get install fail2ban log watch gamin

**yum**

    yum install fail2ban logwatch gamin

**源代码**

    http://www.fail2ban.org/wiki/index.php/Downloads

安装完成后，fail2ban 的设定档在这里

    # /etc/fail2ban

    fail2ban.conf  ail2ban的配置文件  
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

Fail2ban with FirewallD

Fail2ban is a service that monitors logfiles to detect potential intrusion attempts and places bans using a variety of methods. In Fedora 20, the default firewall service FirewallD can be used as a ban action.
Contents [hide] 

    1 Setup
    2 Configuration
        2.1 bantime
        2.2 banaction
        2.3 backend
        2.4 sender
        2.5 destemail
        2.6 action
        2.7 Jails
    3 Running the service

Setup

First, install Fail2ban and requirements for utilizing FirewallD (This tutorial requires Fail2ban 0.9.0 or higher):

sudo yum install fail2ban ipset

If you wish to have Fail2ban send mail notifications, install these packages as well (sendmail can be used instead of postfix):

sudo yum install postfix whois fail2ban-sendmail

If you did not already have postfix (or sendmail) set up, you must enable the service:

sudo systemctl enable postfix
sudo systemctl start postfix

Configuration

Fail2ban is configured by the file /etc/fail2ban/jail.conf, but you should not modify this file directly. Instead, create a local configuration file at /etc/fail2ban/jail.d/local.conf. Here is an example local.conf that will send an email to root when IPs are banned:

[DEFAULT]
bantime = 3600
banaction = firewallcmd-ipset
backend = systemd
sender = fail2ban@example.com
destemail = root
action = %(action_mwl)s

[sshd]
enabled = true

bantime

Default time in seconds to ban the possible intruder. Common values are 3600 (1 hour) or 86400 (1 day).
banaction

Configures Fail2ban to use FirewallD as the default ban action.
backend

Configures Fail2ban to use SystemD to monitor logfiles. If you are not using SystemD for logging, you can leave out this option.
sender

Default "sender" email address when sending mail notifications of Fail2ban actions.
destemail

Destination email address for mail notifications.
action

Action to take when a possible intruder is detected. Default is %(action_)s which will only ban the IP. With %(action_mwl)s it will ban the IP and send a mail notification including whois data and log entries. See comments in /etc/fail2ban/jail.conf for more information.
Jails

By enabling the sshd jail, fail2ban will monitor ssh connection attempts for IPs to ban. There are many other jails you can enable as well, such as apache-auth to monitor the HTTPD error log for authentication failures, and jails for authentication to various FTP, IMAP, SMTP and database servers. See /etc/fail2ban/jail.conf for a full list of defined jails, or define your own.
Running the service

Once configured, start the service:

sudo systemctl start fail2ban

And enable it to run on system startup:

sudo systemctl enable fail2ban

Check the status:

systemctl status fail2ban

Check the log file:

sudo tail /var/log/fail2ban.log
