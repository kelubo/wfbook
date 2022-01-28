# Postfix

## 安装（CentOS 8）

- 系统：CentOS 8 服务器
- IP 地址：192.168.1.13
- 主机名：server1.crazytechgeek.info（确保域名指向服务器的 IP）

**更新系统**

```bash
dnf update
```

**删除其他MTA Sendmail**

```bash
dnf remove sendmail
```

**设置主机名并更新 /etc/hosts**

使用下面的 `hostnamectl` 命令在系统上设置主机名：

```
# hostnamectl set-hostname server1.crazytechgeek.info  # exec bash
```

此外，你需要在 `/etc/hosts` 中添加系统的主机名和 IP：

```
# vim /etc/hosts192.168.1.13   server1.crazytechgeek.info
```

保存并退出文件。

**安装 Postfix 邮件服务器**

```
# dnf install postfix
```

![Install-Postfix-Centos8](https://img.linux.net.cn/data/attachment/album/201911/21/072858z06i6mz66qil576w.png)

*Install-Postfix-Centos8*

**启动并启用 Postfix 服务**

成功安装 Postfix 后，运行以下命令启动并启用 Postfix 服务：

```
systemctl start postfix# systemctl enable postfix
```

要检查 Postfix 状态，请运行以下 `systemctl` 命令：

```
systemctl status postfix
```

**安装 mailx 邮件客户端**

在配置 Postfix 服务器之前，我们需要安装 `mailx`，要安装它，请运行以下命令：

```
dnf install mailx
```

### 步骤 6）配置 Postfix 邮件服务器

Postfix 的配置文件位于 `/etc/postfix/main.cf` 中。

```
vi /etc/postfix/main.cf
```

更改以下几行：

```
myhostname = server1.crazytechgeek.info
mydomain = crazytechgeek.info
myorigin = $mydomain  ## 取消注释并将 inet_interfaces 设置为 all##inet_interfaces = all## 更改为 all ##inet_protocols = all## 注释 ###mydestination = $myhostname, localhost.$mydomain, localhost## 取消注释 ##mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain## 取消注释并添加 IP 范围 ##mynetworks = 192.168.1.0/24, 127.0.0.0/8## 取消注释 ##home_mailbox = Maildir/
```

完成后，保存并退出配置文件。重新启动 postfix 服务以使更改生效：

```
# systemctl restart postfix
```

**测试 Postfix 邮件服务器**

测试我们的配置是否有效，首先，创建一个测试用户。

```
useradd postfixuser# passwd postfixuser
```

接下来，运行以下命令，从本地用户 `pkumar` 发送邮件到另一个用户 `postfixuser`。

```
telnet localhost smtp或者# telnet localhost 25
```

如果未安装 telnet 服务，那么可以使用以下命令进行安装：

```
# dnf install telnet -y
```

如前所述运行命令时，应获得如下输出：

```
[root@linuxtechi ~]# telnet localhost 25Trying 127.0.0.1...Connected to localhost.Escape character is '^]'.220 server1.crazytechgeek.info ESMTP Postfix
```

上面的结果确认与 postfix 邮件服务器的连接正常。接下来，输入命令：

```
# ehlo localhost
```

输出看上去像这样：

```
250-server1.crazytechgeek.info250-PIPELINING250-SIZE 10240000250-VRFY250-ETRN250-STARTTLS250-ENHANCEDSTATUSCODES250-8BITMIME250-DSN250 SMTPUTF8
```

接下来，运行橙色高亮的命令，例如 `mail from`、`rcpt to`、`data`，最后输入 `quit`：

```
mail from:<pkumar>250 2.1.0 Okrcpt to:<postfixuser>250 2.1.5 Okdata354 End data with <CR><LF>.<CR><LF>Hello, Welcome to my mailserver (Postfix).250 2.0.0 Ok: queued as B56BF1189BECquit221 2.0.0 ByeConnection closed by foreign host
```

完成 `telnet` 命令可从本地用户 `pkumar` 发送邮件到另一个本地用户 `postfixuser`，如下所示：

![Send-email-with-telnet-centos8](https://img.linux.net.cn/data/attachment/album/201911/21/072901f78s7ht7bzmkk747.png)

*Send-email-with-telnet-centos8*

如果一切都按计划进行，那么你应该可以在新用户的家目录中查看发送的邮件：

```
# ls /home/postfixuser/Maildir/new1573580091.Vfd02I20050b8M635437.server1.crazytechgeek.info#
```

要阅读邮件，只需使用 cat 命令，如下所示：

```
# cat /home/postfixuser/Maildir/new/1573580091.Vfd02I20050b8M635437.server1.crazytechgeek.info
```

![Read-postfix-email-linux](https://img.linux.net.cn/data/attachment/album/201911/21/072903kpvvrg53bmcbmx5u.png)

*Read-postfix-email-linux*

### Postfix 邮件服务器日志

Postfix 邮件服务器邮件日志保存在文件 `/var/log/maillog` 中，使用以下命令查看实时日志，

```
# tail -f /var/log/maillog
```

![postfix-maillogs-centos8](https://img.linux.net.cn/data/attachment/album/201911/21/072905l7zsofxsoocmxxpr.png)

*postfix-maillogs-centos8*

### 保护 Postfix 邮件服务器

建议始终确保客户端和 Postfix 服务器之间的通信安全，这可以使用 SSL 证书来实现，它们可以来自受信任的权威机构或自签名证书。在本教程中，我们将使用 `openssl` 命令生成用于 Postfix 的自签名证书，

我假设 `openssl` 已经安装在你的系统上，如果未安装，请使用以下 `dnf` 命令：

```
# dnf install openssl -y
```

使用下面的 `openssl` 命令生成私钥和 CSR（证书签名请求）：

```
# openssl req -nodes -newkey rsa:2048 -keyout mail.key -out mail.csr
```

![Postfix-Key-CSR-CentOS8](https://img.linux.net.cn/data/attachment/album/201911/21/072906uugozol5vr5rdsur.png)

*Postfix-Key-CSR-CentOS8*

现在，使用以下 openssl 命令生成自签名证书：

```
# openssl x509 -req -days 365 -in mail.csr -signkey mail.key -out mail.crtSignature oksubject=C = IN, ST = New Delhi, L = New Delhi, O = IT, OU = IT, CN = server1.crazytechgeek.info, emailAddress = root@linuxtechiGetting Private key#
```

现在将私钥和证书文件复制到 `/etc/postfix` 目录下：

```
# cp mail.key mail.crt /etc/postfix
```

在 Postfix 配置文件中更新私钥和证书文件的路径：

```
# vi /etc/postfix/main.cf………smtpd_use_tls = yessmtpd_tls_cert_file = /etc/postfix/mail.crtsmtpd_tls_key_file = /etc/postfix/mail.keysmtpd_tls_security_level = may………
```

重启 Postfix 服务以使上述更改生效：

```
# systemctl restart postfix
```

让我们尝试使用 `mailx` 客户端将邮件发送到内部本地域和外部域。

从 `pkumar` 发送内部本地邮件到 `postfixuser` 中：

```
# echo "test email" | mailx -s "Test email from Postfix MailServer" -r root@linuxtechi root@linuxtechi
```

使用以下命令检查并阅读邮件：

```
# cd /home/postfixuser/Maildir/new/

# ll
total 8
-rw-------. 1 postfixuser postfixuser 476 Nov 12 17:34 1573580091.Vfd02I20050b8M635437.server1.crazytechgeek.info
-rw-------. 1 postfixuser postfixuser 612 Nov 13 02:40 1573612845.Vfd02I20050bbM466643.server1.crazytechgeek.info

# cat 1573612845.Vfd02I20050bbM466643.server1.crazytechgeek.info
```

![Read-Postfixuser-Email-CentOS8](https://img.linux.net.cn/data/attachment/album/201911/21/072908u11ytm69g69tdtfl.png)

*Read-Postfixuser-Email-CentOS8*

从 `postfixuser` 发送邮件到外部域（`root@linuxtechi.com`）：

```
# echo "External Test email" | mailx -s "Postfix MailServer" -r root@linuxtechi root@linuxtechi
```

注意：如果你的 IP 没有被任何地方列入黑名单，那么你发送到外部域的邮件将被发送，否则它将被退回，并提示你的 IP 被 spamhaus 之类的数据库列入黑名单。

### 检查 Postfix 邮件队列

使用 `mailq` 命令列出队列中的邮件：

```
# mailqMail queue is empty#
```





Postfix 是由 Wietse Zweitze Venema ([http://www.porcupine.org/wietse](http://www.porcupine.org/wietse/)) 所发展的。不過，Venema 博士覺得 sendmail 雖然很好用，但是畢竟不夠安全，尤其效能上面並不十分的理想，最大的困擾是...sendmail 的設定檔 sendmail.cf 真的是太難懂了！對於網管人員來說，要設定好 sendmail.cf 這個檔案，真不是人作的工作。

為了改善這些問題， Venema 博士就在 1998 年利用他老大在 IBM 公司的第一個休假年進行一個計畫：『 設計一個可以取代 sendmail 的軟體套件，可以提供網站管理員一個更快速、更安全、而且**完全相容**於 sendmail 的 mail server 軟體！』這個計畫還真的成功了！ 而且也成功的使用在 IBM 內部，在 IBM 內可以說是完全取代了 sendmail 這個郵件伺服器！在這個計畫成功之後，Venema 博士也在 1998 年首次釋出這個自行發展的郵件伺服器，並定名為 VMailer。

不過，IBM 的律師卻發現一件事，那就是 VMailer 這個名字與其他已註冊的商標很類似，這樣可能會引起一些註冊上面的困擾。為了避免這個問題，所以 Venema 博士就將這個郵件軟體名稱改為Postfix ！『Post 有在什麼什麼之後』的意思，『fix 則是修訂』的意思，所以 postfix 有『在修訂之後』的意思。

## 术语

**MTA：** (Mail Transfer Agent) 邮件传输代理，基于 SMTP 协议（简单邮件传输协议）的服务端，比如 Postfix、Exim、Sendmail 等。SMTP 服务端彼此之间进行相互通信。  
**MUA：** (Mail User Agent) 邮件用户代理，本地的邮件客户端，例如 : Evolution、KMail、Claws Mail 或者 Thunderbird。接收邮件主机的电子邮件，提供使用者浏览与编写邮件的功能。  
**MDA：** (Mail Delivery Agent) 邮件投递代理，邮件到达MDA后，就存放在某个文件或特殊的数据库里，我们将这个长期保存邮件的地方称之为邮箱。  
**POP3：** 邮局协议版本 3，将邮件从 SMTP 服务器传输到你的邮件客户端的的最简单的协议。POP 服务端是非常简单小巧的，单一的一台机器可以为数以千计的用户提供服务。  
**IMAP：** 交互式消息访问协议，许多企业使用这个协议因为邮件可以被保存在服务器上，而用户不必担心会丢失消息。IMAP 服务器需要大量的内存和存储空间。  
**TLS：** 传输套接层是 SSL（安全套接层）的改良版，为 SASL 身份认证提供了加密的传输服务层。
**SASL：** 简单身份认证与安全层，用于认证用户。SASL进行身份认证，而上面说的 TLS 提供认证数据的加密传输。  
**StartTLS:** 也被称为伺机 TLS 。如果服务器双方都支持 SSL/TLS，StartTLS 就会将纯文本连接升级为加密连接（TLS 或 SSL）。如果有一方不支持加密，则使用明文传输。StartTLS 会使用标准的未加密端口 25 （SMTP）、 110（POP3）和 143 （IMAP）而不是对应的加密端口 465（SMTP）、995（POP3） 和 993 （IMAP）。

## 安装

    apt-get install postfix

Ubuntu 系统会为 Postfix 创建一个配置文件，并启动三个守护进程 : master、qmgr 和 pickup，这里没用一个叫 Postfix 的命令或守护进程。（LCTT 译注：名为 postfix 的命令是管理命令。）

    $ ps ax
     6494 ? Ss 0:00 /usr/lib/postfix/master
     6497 ? S 0:00 pickup -l -t unix -u -c
     6498 ? S 0:00 qmgr -l -t unix -u

你可以使用 Postfix 内置的配置语法检查来测试你的配置文件，如果没用发现语法错误，不会输出任何内容。

    $ sudo postfix check
    [sudo] password for carla:

使用 netstat 来验证 postfix 是否正在监听 25 端口。

    $ netstat -ant
    tcp 0 0 0.0.0.0:25 0.0.0.0:* LISTEN
    tcp6 0 0 :::25  :::*  LISTEN

现在让我们再操起古老的 telnet 来进行测试 :

    $ telnet myserver 25
    Trying 127.0.1.1...
    Connected to myserver.
    Escape character is '^]'.
    220 myserver ESMTP Postfix (Ubuntu)
    EHLO myserver
    250-myserver
    250-PIPELINING
    250-SIZE 10240000
    250-VRFY
    250-ETRN
    250-STARTTLS
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250 DSN
    ^]
    telnet>

嘿，我们已经验证了我们的服务器名，而且 Postfix 正在监听 SMTP 的 25 端口而且响应了我们键入的命令。

按下 ^] 终止连接，返回 telnet。输入 quit 来退出 telnet。输出的 ESMTP（扩展的 SMTP ） 250 状态码如下。 （LCTT 译注： ESMTP (Extended SMTP)，即扩展 SMTP，就是对标准 SMTP 协议进行的扩展。详情请阅读维基百科）

    PIPELINING 允许多个命令流式发出，而不必对每个命令作出响应。
    SIZE 表示服务器可接收的最大消息大小。
    VRFY 可以告诉客户端某一个特定的邮箱地址是否存在，这通常应该被取消，因为这是一个安全漏洞。
    ETRN 适用于非持久互联网连接的服务器。这样的站点可以使用 ETRN 从上游服务器请求邮件投递，Postfix 可以配置成延迟投递邮件到 ETRN 客户端。
    STARTTLS （详情见上述说明）。
    ENHANCEDSTATUSCODES，服务器支撑增强型的状态码和错误码。
    8BITMIME，支持 8 位 MIME，这意味着完整的 ASCII 字符集。最初，原始的 ASCII 是 7 位。
    DSN，投递状态通知，用于通知你投递时的错误。

Postfix 的主配置文件是： /etc/postfix/main.cf，这个文件是安装程序创建的，可以参考这个资料来查看完整的 main.cf 参数列表， /etc/postfix/postfix-files 这个文件描述了 Postfix 完整的安装文件。






在第一部分中，我们安装并测试了 Postfix SMTP 服务器。Postfix 或任何 SMTP 服务器都不是一个完整的邮件服务器，因为它所做的只是在 SMTP 服务器之间移动邮件。我们需要 Dovecot 将邮件从 Postfix 服务器移动到用户的收件箱中。

Dovecot 支持两种标准邮件协议：IMAP（Internet 邮件访问协议）和 POP3（邮局协议）。 IMAP 服务器会在服务器上保留所有邮件。您的用户可以选择将邮件下载到计算机或仅在服务器上访问它们。 IMAP 对于有多台机器的用户是方便的。但对你而言需要更多的工作，因为你必须确保你的服务器始终可用，而且 IMAP 服务器需要大量的存储和内存。

POP3 是较旧的协议。POP3 服务器可以比 IMAP 服务器服务更多的用户，因为邮件会下载到用户的计算机。大多数邮件客户端可以选择在服务器上保留一定天数的邮件，因此 POP3 的行为有点像 IMAP。但它又不是 IMAP，当你像 IMAP 那样（在多台计算机上使用它时）那么常常会下载多次或意外删除。
安装 Dovecot

启动你的 Ubuntu 系统并安装 Dovecot：

    $ sudo apt-get install dovecot-imapd dovecot-pop3d

它会安装可用的配置，并在完成后自动启动，你可以用 ps ax | grep dovecot 确认：

    $ ps ax | grep dovecot
    15988 ?  Ss 0:00 /usr/sbin/dovecot
    15990 ?  S  0:00 dovecot/anvil
    15991 ?  S  0:00 dovecot/log

打开你的 Postfix 配置文件 /etc/postfix/main.cf，确保配置了maildir 而不是 mbox 的邮件存储方式，mbox 是给每个用户一个单一大文件，而 maildir 是每条消息都存储为一个文件。大量的小文件比一个庞大的文件更稳定且易于管理。添加如下两行，第二行告诉 Postfix 你需要 maildir 格式，并且在每个用户的家目录下创建一个 .Mail 目录。你可以取任何名字，不一定要是 .Mail：

    mail_spool_directory = /var/mail
    home_mailbox = .Mail/

现在调整你的 Dovecot 配置。首先把原始的 dovecot.conf 文件重命名放到一边，因为它会调用存放在 conf.d 中的文件，在你刚刚开始学习时把配置放一起更简单些：

    $ sudo mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot-oldconf

现在创建一个新的 /etc/dovecot/dovecot.conf：

    disable_plaintext_auth = no
    mail_location = maildir:~/.Mail
    namespace inbox {
      inbox = yes
      mailbox Drafts {
        special_use = \Drafts
      }
      mailbox Sent {
        special_use = \Sent
      }
      mailbox Trash {
        special_use = \Trash
      }
    }
    passdb {
      driver = pam
    }
    protocols = " imap pop3"
    ssl = no
    userdb {
      driver = passwd
    }

注意 mail_location = maildir 必须和 main.cf 中的 home_mailbox 参数匹配。保存你的更改并重新加载 Postfix 和 Dovecot 配置：

    $ sudo postfix reload
    $ sudo dovecot reload

快速导出配置

使用下面的命令来快速查看你的 Postfix 和 Dovecot 配置：

    $ postconf -n
    $ doveconf -n

测试 Dovecot

现在再次启动 telnet，并且给自己发送一条测试消息。粗体显示的是你输入的命令。studio 是我服务器的主机名，因此你必须用自己的：

    $ telnet studio 25
    Trying 127.0.1.1...
    Connected to studio.
    Escape character is '^]'.
    220 studio.router ESMTP Postfix (Ubuntu)
    EHLO studio
    250-studio.router
    250-PIPELINING
    250-SIZE 10240000
    250-VRFY
    250-ETRN
    250-STARTTLS
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250-DSN
    250 SMTPUTF8
    mail from: tester@test.net
    250 2.1.0 Ok
    rcpt to: carla@studio
    250 2.1.5 Ok
    data
    354 End data with .Date: November 25, 2016
    From: tester
    Message-ID: first-test
    Subject: mail server test
    Hi carla,
    Are you reading this? Let me know if you didn't get this.
    .
    250 2.0.0 Ok: queued as 0C261A1F0F
    quit
    221 2.0.0 Bye                                                                   
    Connection closed by foreign host.

现在请求 Dovecot 来取回你的新消息，使用你的 Linux 用户名和密码登录：

    $ telnet studio 110                                            
    Trying 127.0.0.1...                                                             
    Connected to studio.                                                         
    Escape character is '^]'.                                                       
    +OK Dovecot ready.                                                              
    user carla
    +OK
    pass password
    +OK Logged in.
    stat
    +OK 2 809
    list
    +OK 2 messages:
    1 383
    2 426
    .
    retr 2
    +OK 426 octets
    Return-Path: <tester@test.net>
    X-Original-To: carla@studio
    Delivered-To: carla@studio
    Received: from studio (localhost [127.0.0.1])
            by studio.router (Postfix) with ESMTP id 0C261A1F0F
            for <carla@studio>; Wed, 30 Nov 2016 17:18:57 -0800 (PST)
    Date: November 25, 2016
    From: tester@studio.router
    Message-ID: first-test
    Subject: mail server test
    Hi carla,
    Are you reading this? Let me know if you didn't get this.
    .
    quit
    +OK Logging out.
    Connection closed by foreign host.

花一点时间比较第一个例子中输入的消息和第二个例子中接收的消息。 返回地址和日期是很容易伪造的，但 Postfix 不会被愚弄。大多数邮件客户端默认显示一个最小的标头集，但是你需要读取完整的标头才能查看真实的回溯。

你也可以在你的 ~/Mail/cur 目录中查看你的邮件，它们是普通文本，我已经有两封测试邮件：

    $ ls .Mail/cur/
    1480540325.V806I28e0229M351743.studio:2,S
    1480555224.V806I28e000eM41463.studio:2,S

测试 IMAP

我们 Dovecot 同时启用了 POP3 和 IMAP 服务，因此让我们使用 telnet 测试 IMAP。

    $ telnet studio imap2   
    Trying 127.0.1.1...
    Connected to studio.
    Escape character is '^]'.
    * OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS
    ID ENABLE IDLE AUTH=PLAIN] Dovecot ready.
    A1 LOGIN carla password
    A1 OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS
    ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS
    THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT
    CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE
    QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS
    BINARY MOVE SPECIAL-USE] Logged in
    A2 LIST "" "*"
    * LIST (\HasNoChildren) "." INBOX
    A2 OK List completed (0.000 + 0.000 secs).
    A3 EXAMINE INBOX
    * FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
    * OK [PERMANENTFLAGS ()] Read-only mailbox.
    * 2 EXISTS
    * 0 RECENT
    * OK [UIDVALIDITY 1480539462] UIDs valid
    * OK [UIDNEXT 3] Predicted next UID
    * OK [HIGHESTMODSEQ 1] Highest
    A3 OK [READ-ONLY] Examine completed (0.000 + 0.000 secs).
    A4 logout
    * BYE Logging out
    A4 OK Logout completed.
    Connection closed by foreign host



## 安装

首先需要停止Sendmail：

# /etc/init.d/sendmail stop

并从启动组里移除：

# chkconfig sendmail off

然后，通过rpm包安装Postfix：

# rpm -Uvh postfix-2.x.x.xxx.rpm

Postfix只有一个/etc/postfix/main.cf需要修改，其他配置文件可以直接使用默认设置。

第一个需要修改的参数是myhostname，指向真正的域名，例如：

myhostname = mail.example.com

mydomain参数指向根域：

mydomain = example.com

myorigin和mydestination都可以指向mydomain：

myorigin = $mydomain
mydestination = $mydomain

Postfix默认只监听本地地址，如果要与外界通信，就需要监听网卡的所有IP：

inet_interfaces = all

Postfix默认将子网内的机器设置为可信任机器，如果只信任本机，就设置为host：

mynetworks_style = host

配置哪些地址的邮件能够被Postfix转发，当然是mydomain的才能转发，否则其他人都可以用这台邮件服务器转发垃圾邮件了：

relay_domains = $mydomain

现在，Postfix已经基本配置完成，我们需要对邮件的发送进行控制：

    对于外域到本域的邮件，必须接收，否则，收不到任何来自外部的邮件；
    对于本域到外域的邮件，只允许从本机发出，否则，其他人通过伪造本域地址就可以向外域发信；
    对于外域到外域的邮件，直接拒绝，否则我们的邮件服务器就是Open Relay，将被视为垃圾邮件服务器。

先设置发件人的规则：

smtpd_sender_restrictions = permit_mynetworks, check_sender_access hash:/etc/postfix/sender_access, permit

以上规则先判断是否是本域地址，如果是，允许，然后再从sender_access文件里检查发件人是否存在，拒绝存在的发件人，最后允许其他发件人。

然后设置收件人规则：

smtpd_recipient_restrictions = permit_mynetworks, check_recipient_access hash:/etc/postfix/recipient_access, reject

以上规则先判断是否是本域地址，如果是，允许，然后再从recipient_access文件里检查收件人是否存在，允许存在的收件人，最后拒绝其他收件人。

/etc/postfix/sender_access的内容：

example.com REJECT

目的是防止其他用户从外部以xxx@example.com身份发送邮件，但登录到本机再发送则不受影响，因为第一条规则permit_mynetworks允许本机登录用户发送邮件。

/etc/postfix/recipient_access的内容：

postmaster@example.com OK
webmaster@example.com OK

因此，外域只能发送给以上两个Email地址，其他任何地址都将被拒绝。但本机到本机发送不受影响。

最后用postmap生成hash格式的文件：

# postmap sender_access
# postmap recipient_access

启动Postfix：

# /etc/init.d/postfix start

设置到启动组里：

# chkconfig postfix on

现在就可以通过telnet来测试了：（红色是输入的命令）

220 mail.example.com ESMTP Postfix

helo localhost

250 mail.example.com

mail from:test@gmail.com

250 Ok

rcpt to:webmaster@example.com

250 Ok

data

354 End data with<CR><LF>.<CR><LF>

hello!!!!!!

.

250 Ok: queued as D68E41407D0

mail from:test@gmail.com

250 Ok

rcpt to:haha@example.com

554<haha@example.com>: Recipient address rejected: Access denied

quit

221 Bye

如果配置了SMTP认证，就可以让用户远程发送时能通过认证后再发送邮件，目前还没有配置，准备继续研究后再配置。需要注意的是，配置SMTP认证后，设置规则应该是：

    外域->本域：不需认证，允许，否则将接受不到任何外部邮件；
    本域->外域：需要认证，否则拒绝。

因为我们作为发送服务器的MTA和转发的MTA实际上是由一个MTA完成的，所以需要以上规则。对于大型邮件服务商，发送服务器的MTA和转发的MTA是分别部署的，例如，sina的发送服务器是smtp.sina.com，需要经过用户认证，而转发服务器是mx???.sina.com，不需要认证，否则无法转发邮件。

最后不要忘了在DNS的MX记录中将域名mail.example.com添上。

## 配置

### 配置文件

- /etc/postfix/main.cf
  主要的 postfix 配置文件。
- /etc/postfix/master.cf
  主要规定了 postfix 每个程序的运作参数。通常不需要更改。
- /etc/postfix/access (利用 postmap 處理)
  可以設定開放 Relay 或拒絕連線的來源或目標位址等資訊的外部設定檔，不過這個檔案要生效還需要在 /etc/postfix/main.cf 啟動這個檔案的用途才行。且設定完畢後需要以 postmap 來處理成為資料庫檔案呢！
- /etc/aliases (利用 postalias 或 newaliases 均可)
  做為郵件別名的用途，也可以作為郵件群組的設定喔！

### 执行文件
- /usr/sbin/postconf (查閱 postfix 的設定資料)
這個指令可以列出目前你的 postfix 的詳細設定資料，包括系統預設值也會被列出來。如果你在 main.cf 裡面曾經修改過某些預設參數的話，想要僅列出非預設值的設定資料，則可以使用『postconf -n』這個選項即可。
- /usr/sbin/postfix (主要的 daemon 指令)
[root@www ~]# postfix check   <==檢查 postfix 相關的檔案、權限等是否正確！
[root@www ~]# postfix start   <==開始 postfix 的執行 
[root@www ~]# postfix stop    <==關閉 postfix
[root@www ~]# postfix flush   <==強制將目前正在郵件佇列的郵件寄出！ 
[root@www ~]# postfix reload  <==重新讀入設定檔，也就是 /etc/postfix/main.cf 
- /usr/sbin/postalias
	設定別名資料庫的指令，因為 MTA 讀取資料庫格式的檔案效能較佳，所以我們都會將 ASCII 格式的檔案重建為資料庫。在 postfix 當中，這個指令主要在轉換 /etc/aliases 成為/etc/aliases.db 囉！用法為：
	[root@www ~]# postalias hash:/etc/aliases b   #hash 為一種資料庫的格式，然後那個 /etc/aliases.db 就會自動被更新囉！

- /usr/sbin/postcat
主要用在檢查放在 queue (佇列) 當中的信件內容。由於佇列當中的信件內容是給 MTA 看的，所以格式並不是一般我們人類看的懂的文字資料。所以這個時候你得要用 postcat 才可以看出該信件的內容。在 /var/spool/postfix 內有相當多的目錄，假設內有一個檔案名為 /deferred/abcfile ， 那你可以利用底下的方式來查詢該檔案的內容喔：
[root@www ~]# postcat /var/spool/postfix/deferred/abcfile

- /usr/sbin/postmap
這個指令的用法與 postalias 類似，不過他主要在轉換 access 這個檔案的資料庫啦！用法為：
[root@www ~]# postmap hash:/etc/postfix/access

- /usr/sbin/postqueue
類似 mailq 的輸出結果，例如你可以輸入『postqueue -p』看看就知道了！

### 配置文件详解

- myhostname：設定主機名稱，需使用 FQDN

  這個項目在於設定你的主機名稱，且這個設定值會被後續很多其他的參數所引用，所以必須要設定正確才行。要設定成為完整的主機名稱。除了這個設定值之外，還有一個 mydomain 的設定項目，這個項目預設會取 $myhostname 第一個『.』之後的名稱。

- myorigin ：發信時所顯示的『發信源主機』項目

  這個項目在設定『郵件標頭上面的 mail from 的那個位址』， 就是代表本 MTA 傳出去的信件將以此設定值為準喔！如果你在本機寄信時忘記加上 Mail from 字樣的話，那麼就以此值為準了。

- inet_interfaces ：設定 postfix 的監聽介面 (極重要)

  在預設的情況下你的 Postfix 只會監聽本機介面的 lo (127.0.0.1) 而已，如果你想要監聽整個 Internet 的話，請開放成為對外的介面，或者是開放給全部的介面，常見的設定方法為：		inet_interfaces = all 才對！

- inet_protocols ：設定 postfix 的監聽 IP 協定

  預設 CentOS 的 postfix 會去同時監聽 IPv4, IPv6 兩個版本的 IP，如果你的網路環境裡面僅有 IPv4 時，那可以直接指定inet_protocols = ipv4 就會避免看到 :::1 之類的 IP 出現呦！

- mydestination ：設定『能夠收信的主機名稱』 (極重要)

  這個設定項目很重要喔！因為我們的主機有非常多的名字，那麼對方填寫的 mail to 到底要寫哪個主機名字我們才能將該信件收下？ 就是在這裡規範的！也就是說，你的許多主機名稱當中，僅有寫入這個設定值的名稱才能作為 email 的主機位址。

  如果你想要將此設定值移動到外部檔案，那可以使用類似底下的作法：	mydestination = /etc/postfix/local-host-names ，然後在 local-host-names裡面將可收信的主機名稱寫入即可。一般來說，不建議你額外建立 local-host-names 這個檔案啦，直接寫入 main.cf 即可說！特別留意的是，如果你的 DNS 裡頭的設定有 MX 標誌的話，那麼請將 MX 指向的那個主機名稱一定要寫在這個 mydestination 內，否則很容易出現錯誤訊息喔！一般來說，使用者最常發生錯誤的地方就在這個設定裡頭呢！ 

- mynetworks_style ：設定『信任網域』的一項指標

  這個設定值在規定『與主機在同一個網域的可信任用戶端』的意思！舉例來說，鳥哥的主機 IP 是 		192.168.100.254，如果我相信整個區域網路內 (192.168.100.0/24) 的用戶的話，那我可規定此設定值為『 subnet 』吶！ 不過，一般來說，因為底下的 mynetworks 會取代這個設定值， 所以不設定也沒有關係喔！如果要設定的話，最好設定成為 host 即可 (亦即僅信任這部 MTA 主機而已)。

- mynetworks ：規定信任的用戶端 (極重要)

  你的 MTA 能不能幫忙進行 Relay 與這個設定值最有關係！舉例來說，我要開放本機與內部網域的 IP 時，就可以這樣進行設定：mynetworks = 127.0.0.0/8, 192.168.100.0/24。如果你想要以 /etc/postfix/access 這個檔案來控制 relay 的用戶時，那鳥哥可以建議你將上述的資料改寫成這樣： 		mynetworks = 127.0.0.0/8, 192.168.100.0/24, hash:/etc/postfix/access 然後你只要再建立 access 之後重整成資料庫後，嘿嘿！就能夠設定 Relay 的用戶囉！

- relay_domains ：規範可以幫忙 relay 的下一部 MTA 主機位址

  相對於 mynetworks 是針對『信任的用戶端』而設定的，這個 relay_domains 則可以視為『針對下游 MTA 伺服器』而設定的。舉例來說，如果你這部主機是 www.niki.centos.vbird 的 MX 主機時， 		那你就得要在 relay_domains 設定針對整個 niki.centos.vbird 這個領域的目標信件進行轉遞才行。 		在預設的情況下，這個設定值是 $mydestination 而已啦。你必需要注意的『Postfix 預設並不會轉遞 MX 主機的信件』，意思就是說：如果你有兩部主機，一部是上游的 MTAup ，一部是下游的 MTAdown ，而 MTAdown 規範的 MX 主機是 MTAup，我們知道任何想要寄給 MTAdown 主機的信件， 都會先經過 MTAup 來轉遞才行！此時如果那部 MTAup 沒有開啟幫 MTAdown 進行 relay 的權限時，那麼任何傳給 MTAdown 的信件將『全部都被 MTAup 所退回』！從此 MTAdown 就無法收到任何信件了。

- alias_maps ：設定郵件別名

  就是設定郵件別名的設定項目。

### 配置示例

在瞭解上述的設定後，以鳥哥的範例來看的話，鳥哥有更動過或註明重要的設定值以及相關檔案

是這樣處理的：

```
`[root@www ~]# vim /etc/postfix/main.cf myhostname = www.centos.vbird          <==約在第  77 行 myorigin = $myhostname                 <==約在第  99 行 inet_interfaces = all                  <==約在第 114 行，117 行要註解掉 inet_protocols = ipv4                  <==約在第 120 行 mydestination = $myhostname, localhost.$mydomain, localhost,   linux.centos.vbird, ftp.centos.vbird <==約在第 165,166 行 mynetworks = 127.0.0.0/8, 192.168.100.0/24, hash:/etc/postfix/access <==約在269行 relay_domains = $mydestination         <==約在第 299 行 alias_maps = hash:/etc/aliases alias_database = hash:/etc/aliases     <==約在第 389, 400 行 # 其他的設定值就先保留預設值即可啊！  [root@www ~]# postmap hash:/etc/postfix/access [root@www ~]# postalias hash:/etc/aliases `
```

因為 main.cf 當中我們有額外加入兩個外部設定檔 (mynetworks 及 alias_maps) ，所以才會額外進行 postmap 及  		postalias。然後準備來啟動啦！你可以這樣處理喔：

```
`# 1. 先檢查設定檔的語法是否有錯誤 [root@www ~]# /etc/init.d/postfix check   <==沒有訊息，表示沒有問題。  # 2. 啟動與觀察 port number [root@www ~]# /etc/init.d/postfix restart [root@www ~]# netstat -tlunp | grep ':25' Proto Recv-Q Send-Q Local Address  Foreign Address   State   PID/Program name tcp        0      0 0.0.0.0:25     0.0.0.0:*         LISTEN  13697/master `
```







|      |                                                              |      |
| ---- | ------------------------------------------------------------ | ---- |
|      | 當一封郵件要傳送出去時，郵件主機會先分析那封信的『目標主機的 DNS 』，先取得 MX 標誌 (注意，MX 標誌可能會有多部主機喔) 		然後以最優先 MX 主機為準將信發送出去。看不懂嗎？沒關係，我們以底下這個 DNS 範例來說：  `xyz.com.vbird  IN  MX 10 mail.xyz.com.vbird xyz.com.vbird  IN  MX 20 mail2.xyz.com.vbird xyz.com.vbird  IN  A     aaa.bbb.ccc.ddd `  		假如上述的 DNS 設定是正常的，那麼：  		 		當有一封信要傳給 user@xyz.com.vbird 時，由於 MX 標誌最低者優先，所以該封信會先傳送到  			mail.xyz.com.vbird 那部主機。 		如果 mail.xyz.com.vbird 由於種種原因，導致無法收下該封信時，該封信將以次要 MX 主機來傳送，那就是傳送到 			mail2.xyz.com.vbird 那部主機上頭； 		如果兩部 MX 主機都無法負責的話，那麼該封信會直接以 A 的標誌，亦即直接傳送到 aaa.bbb.ccc.ddd 那個 IP 上頭去， 			也就是 xyz.com.vbird 本身啦！ 		  		在這個過程當中，你必需要注意到：mail.xyz.com.vbird 及 mail2.xyz.com.vbird 必需要是可以幫 xyz.com.vbird  		轉信的主機才行，也就是說，那兩部主機通常是你公司的最上游的郵件主機， 		並不是你隨意填寫的！那兩部主機還需要針對你的 xyz.com.vbird 來設定『郵件轉遞』才行！ 		否則你的信會被踢掉的。  		由於現在的很多郵件伺服器會去搜尋 MX 這個標誌來判斷目標郵件伺服器是否為合法，所以你要架設 Mail server  		雖然不必自行設定 DNS 伺服器，不過你最好要申請一個 MX 的標誌才行。此外，MX 		標誌一定要設定正確，否則你的信件將可能會直接被 MX 伺服器踢掉。為了要設定 MX  		但是我們沒有上層郵件伺服器時，所以你可以指定 MX 為自己，利用自己當  		MX 伺服器即可。  		那麼你或許會想，這個 MX 有啥好處啊？一般來說，如果目標主機掛點時，你的郵件通常會直接退還給原發信者， 		但如果有 MX 主機時，這部 MX 主機會先將該封信放在他的佇列 (queue) 當中，等到你的目標主機重新提供郵件服務後， 		MX 主機會將你的信件傳送給目標主機，如此一來你的信件就比較不會遺失啊！這樣說，您可以瞭解吧！ ^_^    		Email 的位址寫法  		剛剛上頭說過 email 通常是『帳號@主機名稱』的方式來處理，舉例來說鳥哥的 www.centos.vbird 主機上面有個 dmtsai 		的使用者，則我的 email 將會成為：『dmtsai@www.centos.vbird』，當有人要寄信給我時， 		他會分析 @ 後面的主機名稱，亦即 www.centos.vbird 的 MX/A 標誌等等，然後再透過剛剛說明的流程來傳出信件。 		而當我的 www.centos.vbird. 收到這封信時，他會將信放到 dmtsai 的信箱當中啦！底下我們就來談一談這個流程吧！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.1.3 郵件傳輸所需要的元件  	(MTA, MUA, MDA) 以及相關協定  	 		在開始介紹郵件的傳送過程之前，我們先來想一想，你是如何寄出電子郵件的？假設你要寄信給一個使用者， 		他的電子郵件是『a_user@gmail.com』好了，也就是說，你要寄一封信到 gmail.com 這個主機上的意思。 		那你的桌上型電腦 (舉例來說， Windows 系統) 是否能夠將這封信『直接』透過網路送給 gmail.com 那個主機上？ 		當然不行啦！你得要設定幫你轉信的郵件伺服器才行！也就是說，你必需要先向某一部郵件伺服器註冊， 		以取得一個合法的電子郵件使用權限後，才能夠發送郵件出去的。  		所以說，你要寄出一封信件時是需要很多介面的幫忙的，底下列出一個簡單的圖示來說明：  		 		![電子郵件的『傳送』過程示意圖](http://linux.vbird.org/linux_server/0380mail//mail_comps.gif)  		圖 22.1-1、電子郵件的『傳送』過程示意圖   		我們先來解釋一些專有名詞吧！然後再來說明傳送的流程：  		 		 		MUA (Mail User Agent)：    		顧名思義 MUA 就是『郵件使用者代理人』的意思，因為除非你可以直接利用類似 telnet  		之類的軟體登入郵件伺服器來主動發出信件，否則您就得要透過 MUA 來幫你送信到郵件伺服器上頭去。 		最常見的 MUA 像是 [Mozilla](http://moztw.org/) 推出的 		[Thunderbird (雷鳥)](http://moztw.org/thunderbird/) 自由軟體， 		或者是 Linux 桌面 KDE 常見的 Kmail ，及 Windows 內件的 Outlook Express (OE) 等。 		MUA 主要的功能就是收受郵件主機的電子郵件，以及提供使用者瀏覽與編寫郵件的功能！ 		    		MTA (Mail Transfer Agent)：    		MUA 幫用戶傳送郵件到郵件主機上，那這部郵件主機如果能夠幫用戶將這封信寄出去，那他就是一部郵件傳送主機  		(MTA) 啦！這個 MTA 就是『郵件傳送代理人』的意思。也來顧名思義一下，既然是『傳送代理人』， 		那麼使用者寄出的信，幫使用者將屬於該用戶的信件收下時，就是找它 (MTA) 就對啦！基本上，MTA 的功能有這些：    		 		收受信件：使用簡單郵件傳送協定(SMTP)  		MTA 主機最主要的功能就是：將來自用戶端或者是其他 MTA 的來信收下來，這個時候 MTA 使用的是  		Simple Mail Transfer Protocol (SMTP)，他使用的是 port 25 啦！   		轉遞信件：  		如果該封信件的目的地並不是本身的用戶，且該封信的相關資料符合使用 MTA 的權力， 		那麼咱們的 MTA 就會將該封信再傳送到下一部主機上。這即是所謂的轉遞 (Relay) 的功能。   		  		總之，我們一般提到的 Mail Server 就是 MTA 啦！而嚴格來說， MTA 其實僅是指 SMTP 這個協定而已。而達成 MTA 的 SMTP  		功能的主要軟體包括老牌的 sendmail，後起之秀的 postfix，還有 qmail 等等。底下我們來看看，那麼在 MTA  		上頭還有哪些重要的功能。    		MDA (Mail Delivery Agent)：    		字面上的意思是『郵件遞送代理人』的意思。事實上，這個 MDA 是掛在 MTA 底下的一個小程式， 		最主要的功能就是：分析由 MTA 所收到的信件表頭或內容等資料， 		來決定這封郵件的去向。所以說，上面提到的 MTA 的信件轉遞功能，其實是由 MDA 達成的。 		舉例來說，如果 MTA 所收到的這封信目標是自己，那麼 MDA 會將這封信給他轉到使用者的信箱 (Mailbox) 去， 		如果不是呢？那就準備要轉遞出去了。此外，MDA 還有分析與過濾郵件的功能喔！舉例來說：   		 		過濾垃圾信件：  		可以根據該封郵件的表頭資料，或者是特定的信件內容來加以分析過濾。例如某個廣告信的主題都是固定的， 		如『AV情色...』等等，那就可以透過 MDA 來過濾並去除該郵件。   		自動回覆：  		如果您出差了導致某一段時間內無法立即回信時，就可以透過 MDA 的功能讓郵件主機可以自動發出回覆信件， 		如此您的朋友就不會認為你太大牌！^_^ 		   		各主要的 MTA 程式 (sendmail,postfix...) 都有自己的 MDA 功能，不過有些外掛的程式功能更強大，舉例來說 procmail  		就是一個過濾的好幫手，另外 Mailscanner + Spamassassion 也是可以使用的一些 MDA 喔。    		Mailbox：   		就是電子郵件信箱嘛！簡單的說，就是某個帳號專用的信件收受檔案囉。我們的 Linux 		系統預設的信箱都是放在 /var/spool/mail/使用者帳號 中！ 		若 MTA 所收到的信件是本機的使用者，MDA 就會將信件送到該 mailbox 當中去囉！   		  		好了，那麼來想一想，你如何透過 MUA 來將信件送到對方的郵件信箱 (Mailbox) 去呢？  		 		Step 0：取得某部 MTA 的使用權限：   		就如[圖 22.1-1](http://linux.vbird.org/linux_server/0380mail.php#fig22.1-1) 所示，我們本地端的 MUA 想要使用 MTA 來傳出信件時， 		當然需要取得 MTA 的使用權限。通常就是說：我們必須要向 MTA 註冊一組可使用 email 的帳號與密碼才行。    		Step 1：使用者在 MUA 上編寫信件後，傳送至 MTA 上頭：   		使用者在 MUA 上面編寫信件，信件的資料主要有：   		 		信件標頭：包括寄件者與收件者的 email 位址，還有該封信件的主旨 (subject) 等； 		信件內容：就是你要跟對方說明的內容啦！ 		  		編寫完畢之後只要按下傳送鈕，該封信就會送至你的 MTA 伺服器上面了，注意：是你的 MTA 而不是對方的 MTA ！ 		如果你確定可以使用該部 MTA，那麼你的這封信就會被放置到 MTA 的佇列 (queue) 當中並等待傳送出去了。    		Step 2.1：如果該封信的目標是本地端 MTA 自己的帳號   		你是可以寄信給你自己的，所以如果你的 MTA 收到該封信件的目標是自己的用戶時，那就會透過 MDA  		將這封信送到 Mailbox 去囉！    		Step 2.2：如果該封信目的為其他 MTA ，則開始轉遞 (Relay) 的流程：   		那如果這封信的目標是其他的主機呢？這個時候我們的 MTA 就會開始分析該封信是否具有合法的使用權限， 		若具有使用權限時，則我們的 MDA 會開始進行郵件轉遞，亦即該封信件會透過我們的 MTA 向下一部 MTA 的 smtp (port 25) 		發送出去。如果該封信件順利的發送出去了，那麼該封信件就會由佇列當中移除掉了。    		Step 3：對方 MTA 伺服器收受信件   		如果一切都沒有問題的話，遠端的 MTA 會收到我們 MTA 所發出的那封信，並將該信件放置到正確的使用者信箱當中， 		等待使用者登入來讀取或下載。 		  		在這整個過程當中，你會發現你的信件是由我們的 MTA 幫忙發送出去的，此時  		MTA 提供的協定是簡單郵件傳輸協定 (Simple Mail Transfer Protocol, smtp)， 		並且該封信最終是停留在對方主機的 MTA 上頭！並不是你朋友的 MUA 上頭啊！  		**Tips:** 		為何特別強調這一點？因為以前有個朋有跟我說：『鳥哥啊，你要寄 email 給我的時候記得跟我講， 		那我下班前將電腦開著，以免你信寄不到我的信箱』，此時額頭三條線突然跑出來～很不好意思～ 		所以這裡才要特別強調，你的 MUA 不必開著啦！要收信時再打開即可。 		![鳥哥的圖示](http://linux.vbird.org/images/vbird_face.gif) 		瞭解了傳送信件時 MTA 需要啟動 smtp (port 25) 之後，再來我們得要談談那這封信件對方要如何接收啊？ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.1.4  	使用者收信時伺服器端所提供的相關協定： MRA  	 		那使用者如果想要收信時，當然也可以透過 MUA 直接來連線取得自己的郵件信箱內的資料啊！整個過程有點像底下這樣：  		 		![用戶端透過 MRA 收回信件的流程示意圖](http://linux.vbird.org/linux_server/0380mail//mail_comps_mra.gif)  		圖 22.1-2、用戶端透過 MRA 收回信件的流程示意圖   		在上述的圖示中，多了一個郵件元件，那就是 MRA：  		 		MRA (Mail Retrieval Agent)：    		使用者可以透過 MRA 伺服器提供的郵政服務協定 (Post Office Protocol, POP) 來收下自己的信件， 		也可以透過 IMAP (Internet Message Access Protocol) 協定將自己的信件保留在郵件主機上面， 		並進一步建立郵件資料匣等進階工作。也就是說，當用戶端收受信件時，使用的是 MRA 的 POP3, IMAP 等通訊協定，並非 MTA  		的 SMTP 喔！ 		  		我們先談一談 POP3 的收信方式吧：  		 		MUA 透過 POP3 (Post Office Protocol version 3) 的協定連接到 MRA 的 port 110， 		並且輸入帳號與密碼來取得正確的認證與授權； 		MRA 確認該使用者帳號/密碼沒有問題後，會前往該使用者的 Mailbox (/var/spool/mail/使用者帳號) 		取得使用者的信件並傳送給使用者的 MUA 軟體上； 		當所有的信件傳送完畢後，使用者的 mailbox 內的資料將會被刪除！ 		  		在上述的流程當中我們知道 MRA 必須要啟動 POP3 這個協定才行，不過這個協定的收件方式比較有趣， 		因為使用者收信是由第一封信件開始收下直到最後一封信件傳輸完畢為止。不過由於某些 MUA  		程式撰寫的問題，若有些郵件有病毒的可能性時，透過防毒軟體將可能導致該 MUA 軟體的斷線！ 		如此一來由於傳輸沒有完畢，因此 MRA 主機並不會將使用者的信件刪除。 		此時如果使用者又再一次的按下接收按鍵，呵呵！原來已接收的信件又會重複收到，而沒有收到的還是收不到！  		這個時候或許你可以透過登入主機利用 mail 這個指令來處理你有問題的郵件， 		或許換一種 MUA 也是個不錯的思考方向，又或者暫時將防毒軟體關掉也是可以考慮的手段之一。 		轉頭過來想一想，因為 POP3 的協定預設會將信件刪除，那如果我今天在辦公室將我的信收到辦公室的電腦中， 		當我回家時再度啟動 MUA 時，是否能夠收到已經被接收的信件？當然不行，對吧！  		或許你需要更有幫助的協定，亦即 IMAP (Internet Messages Access Protocol) ， 		這個協定可以讓你將 mailbox 的資料轉存到你主機上的家目錄，亦即 /home/帳號/ 那個目錄下， 		那你不但可以建立郵件資料匣，也可以針對信件分類管理，而且在任何一個可連上網路的地方你只要登入主機， 		原本的信件就還是存在吶！真是好啊！  		不過，使用 IMAP 時，使用者的目錄最好能夠加點限制，例如利用 quota 來管理使用者的硬碟使用權限， 		否則因為信件都在主機上頭，如果使用者過多且誤用時，你的硬碟空間會被吃光光喔！注意注意！  		OK！透過上面的說明你要知道，要架設一部可以使用 MUA 進行收發信件的 MTA, MRA 		伺服器，你至少也需要啟動 SMTP 以及 POP3 這兩個協定才行！而這兩個協定的啟動程式並不相同， 		所以架設上還是得要小心注意啊！    		pop3s, imap2 與 SMTP 的困擾  		郵件資料在網際網路上面傳輸時，透過的 SMTP, POP3, IMAP 等通訊協定，通通是明碼傳輸的！尤其 POP3, IMAP 		這兩個通訊協定中，使用者必須要輸入帳號/密碼才能收受信件！因為涉及帳密，所以當然加密這兩個通訊協定的資料較佳！ 		於是就有了 POP3s, IMAPs 通訊協定出現了！透過 SSL 加密嘛！那你會問，既然已經有 pop3s, imaps 了， 		那有沒有 smtps 呢？答案是，當然有！只不過沒人用！  		從[圖 22.1-1](http://linux.vbird.org/linux_server/0380mail.php#fig22.1-1) 及[圖 22.1-2](http://linux.vbird.org/linux_server/0380mail.php#fig22.1-2) 的流程來看，POP3, IMAP 只與 MRA 		及自己的用戶有關，因此你只要跟你的用戶說，你伺服器使用的 MRA 協定為何，通知你的用戶改變即可，並不會影響到其他的伺服器。 		但是 MTA 就不同了！因為 MTA 必須與其他的 MTA 溝通，因此，若你使用了 smtps ，那麼全世界與你的 MTA 溝通者， 		通通需要改變為 smtps 通訊協定才行！這個工程實在太浩大了！目前還沒有任何一家 ISP 有能力進行！ 		所以，就造成目前沒有 SMTPs 的協定囉。  		那麼難道你的資料就一定要是明碼嗎？那倒不見得～既然你的 MTA 無法加密，那麼你就自己將郵件資料加密後，再交由 		MTA 傳送即可！這也是目前很多急需加密資料的郵件用戶所使用的手段啦！^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.1.5 Relay 與認證機制的重要性  	 		當你需要 MTA 幫你將信寄送到下一部 MTA 去時，這個動作就稱為郵件轉遞 (Relay) 囉，那就是[圖 22.1-1](http://linux.vbird.org/linux_server/0380mail.php#fig22.1-1)當中的 Step 2.2 那個動作啦。那麼我們來想一想，如果『所有的人都可以藉由這一部 MTA 幫忙進行 Relay 時， 		這個情況稱之為 Open Relay 的動作』。當你的 MTA 發生 Open Relay 時，會有什麼問題？ 		問題可就大了！  		當你的 MTA 由於設定不良的關係導致具有 Open Relay 的狀況，加上你的 MTA 確實是連上網際網路時， 		由於網際網路上面用 port scan 軟體的閒人太多，你的 MTA 具有 Open Relay 的功能這件事情， 		將會在短時間內就被很多人察覺，此時那些不法的廣告信、色情垃圾信業者將會利用你的這部 Open Relay MTA  		發送他們的廣告，所以你會發生的問題至少有：  		 		你主機所在的網域正常使用的連線速度將會變慢，因為網路頻寬都被廣告、垃圾信吃光了； 		你的主機可能由於大量發送信件導致主機資源被耗盡，容易產生不明原因當機之類的問題； 		你的 MTA 將會被網際網路社會定義為『黑名單』，從此很多正常的郵件就會無法收發； 		你 MTA 所在的這個 IP 將會被上層 ISP 所封鎖，直到你解決這個 Open Relay 的問題為止； 		某些用戶將會對你的能力產生質疑，對您公司或者是你個人將會有信心障礙！甚至可能流失客源； 		如果你的 MTA 被利用來發黑函，你是找不到原發信者的，所以你這部 MTA 將會被追蹤為最終站！ 		  		問題很大呦！所以啊，目前所有的 distributions 都一樣，幾乎都將 MTA 預設啟動為僅監聽內部迴圈介面 (lo) 		而已，而且也將 Open Relay 的功能取消了。既然取消 Open Relay 的功能，那麼怎麼使用這部 		MTA 的 Relay 來幫忙轉信啊？呵呵！所以我們在上頭才會一直說，你『必需』取得合法使用該 MTA 的權限啊！ 		這也就是說，設定誰可以使用 Relay 的功能就是我們管理員的任務啦！通常設定 Relay 的方法有這幾種：  		 		規定某一個特定用戶端的 IP 或網段，例如規定內部 LAN 的 192.168.1.0/24 可使用 Relay； 		若用戶端的 IP 不固定時 (例如撥接取得的非固定 IP) 可以利用認證機制來處理。 		將 MUA 架設在 MTA 上面，例如 OpenWebMail 之類的 web 介面的 MUA 功能。 		  		認證機制上面常見的有 SMTP 郵件認證機制，以及 SMTP after POP 兩種，不論是哪一種機制， 		基本上都是透過讓使用者輸入認證用的帳號與密碼，來確定他有合法使用該 MTA 的權限，然後針對通過認證者開啟 Relay  		的支援就是了。如此一來你的 MTA 不再啟動 Open Relay  ，並且用戶端還是可以正常的利用認證機制來收發信件， 		身為管理員的你可就輕鬆多囉！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.1.6 電子郵件的資料內容  	 		看過上頭的資料後，您應該對於 Mail server 有一些程度的認識了。再來要談的是，那麼一封 email  		的內容有哪些部分呢？就跟人類社會的郵件有信封袋以及內部的信紙一樣，email 也有所謂的標頭 (header) 以及內容 (body)  		兩部份喔！  		email 的標頭部分 (類似郵件信封) 會有幾個重要資訊，包括：這封信來自那個 MTA、是由誰所發送出來的、要送給誰、 		主旨為何等等，至於內容 (類似信封內的信紙) 則是發信者所填寫的一些說明囉。如果你使用 dmtsai 的身份下達這個指令：  `[dmtsai@www ~]$ echo "HaHa.." | mail -s "from vbird" dmtsai `  		然後將自己的信箱內容叫出來，如下所示：  `[dmtsai@www ~]$ cat /var/spool/mail/dmtsai From dmtsai@www.centos.vbird  Mon Aug  8 18:53:32 2011  <==發信者的 email Return-Path: <dmtsai@www.centos.vbird>                  <==這封信的來源 X-Original-To: dmtsai Delivered-To: dmtsai@www.centos.vbird Received: by www.centos.vbird (Postfix, from userid 2007)         id 6D1C8366A; Mon,  8 Aug 2011 18:53:32 +0800 (CST) <==郵件ID # 這部份主要在講這封 email 的來源與目標收件者 MTA 在哪裡的資訊～ Date: Mon, 08 Aug 2011 18:53:32 +0800     <==收到信件的日期 To: dmtsai@www.centos.vbird               <==收件者是誰啊！ Subject: from vbird                       <==就是信件標題 User-Agent: Heirloom mailx 12.4 7/29/08 MIME-Version: 1.0 Content-Type: text/plain; charset=us-ascii Content-Transfer-Encoding: 7bit Message-Id: <20110808105332.6D1C8366A@www.centos.vbird> <==給機器看的郵件ID From: dmtsai@www.centos.vbird             <==發信者是誰啊！  HaHa.. `  		由原本的信件內容我們可以看到 email 確實是兩部份，在標頭部分記錄了比較詳細的收、發件者資料， 		以及相關的來源、目標之 MTA 資訊等等。但你要注意的是，那個『Received:...』那一行資料是『會變動的』， 		如同前面談到的 MX 標誌，如果一封信由 MUA 傳送到 MTA 在由 MTA 傳送到 MX 主機後，才傳送到最終的 MTA 時， 		那麼這個 Received: 的資料將會記錄每一部經手過的 MTA 資訊喔！所以你可以藉著這個記錄資料慢慢的找回這封信的傳遞方向呢！  		此外，這個郵件的標頭以及內容的分析部分，你還可以藉由某些分析軟體來進行過濾， 		這部份我們將在後頭再慢慢的介紹給大家瞭解喔！ ^_^！您先知道一封郵件至少有這些資料，以後咱們再慢慢的解釋囉！ 	    ![大標題的圖示](http://linux.vbird.org/images/penguin-m.gif)22.2 MTA 伺服器： Postfix 基礎設定   	可達成 MTA 的伺服器軟體非常多，例如我們的 CentOS 預設就提供了數十年老牌子的 sendmail  	(<http://www.sendmail.org>) 以及近期以來很熱門的 	Postfix (<http://www.postfix.org>)。雖然 sendmail 曾是最為廣泛使用的  	mail server 軟體，但由於 sendmail 的設定檔太過於難懂，以及早期的程式漏洞問題導致的主機安全性缺失；加上 sendmail  	將所有的功能都統合在 /usr/sbin/sendmail 這個程式當中，導致程式太大可能會有效能方面的疑慮等等， 	所以新版的 CentOS 已經將預設的 mail server 調整為 postfix 囉！我們這裡也主要介紹  	postfix。當然啦，原理方面都一樣，您也可以自己玩玩其他的 mail server。    	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.1 Postfix 的開發  	 		Postfix 是由 Wietse Zweitze Venema 先生([http://www.porcupine.org/wietse](http://www.porcupine.org/wietse/))所發展的。早期的 mail server 都是使用 sendmail  		架設的，還真的是『僅此一家，絕無分號』！不過，Venema 博士覺得 sendmail  		雖然很好用，但是畢竟不夠安全，尤其效能上面並不十分的理想，最大的困擾是...sendmail 的設定檔  		sendmail.cf 真的是太難懂了！對於網管人員來說，要設定好 sendmail.cf 這個檔案，真不是人作的工作。  		為了改善這些問題， Venema 博士就在 1998 年利用他老大在 IBM 公司的第一個休假年進行一個計畫：『 		設計一個可以取代 sendmail 的軟體套件，可以提供網站管理員一個更快速、 		更安全、而且**完全相容**於 sendmail 的 mail server 軟體！』這個計畫還真的成功了！ 		而且也成功的使用在 IBM 內部，在 IBM 內可以說是完全取代了 sendmail 這個郵件伺服器！在這個計畫成功之後，  		Venema 博士也在 1998 年首次釋出這個自行發展的郵件伺服器，並定名為 VMailer。  		不過，IBM 的律師卻發現一件事，那就是 VMailer 這個名字與其他已註冊的商標很類似， 		這樣可能會引起一些註冊上面的困擾。為了避免這個問題，所以 Venema 博士就將這個郵件軟體名稱改為  		Postfix ！『Post 有在什麼什麼之後』的意思，『fix 則是修訂』的意思，所以 postfix 有 		『在修訂之後』的意思。  		鳥哥個人認為， Venema 先生最早的構想並不是想要『創造一個全新的 Mail server 軟體，而是想要製造一個可以完全相容於 		sendmail 的軟體』，所以，Venema 先生認為他自行發展的軟體應該是『改良 sendmail 的缺失』，所以才稱為 Postfix 吧！取其意為： 		『改良了 sendmail 之後的郵件伺服器軟體！』  		所以啦， Postfix 設計的理念上面，主要是針對『想要完全相容於  		sendmail』所設計出來的一款『內在部分完全新穎』的一個郵件伺服器軟體。就是由於這個理念，因此 		Postfix 改善了 sendmail 安全性上面的問題，改良了 mail server 的工作效率， 		且讓設定檔內容更具親和力！因此，你可以輕易的由 sendmail 轉換到 Postfix 上面！這也是當初  		Venema 博士的最初構想啊！  		就是基於這個構想，所以 Postfix 在外部設定檔案的支援度，與 sendmail 幾乎沒有兩樣，同樣的支援  		aliases 這個檔案，同樣的支援 ~/.forward 這個檔案，也同樣的支援 SASL 的 SMTP 郵件認證功能等等！ 		所以，呵呵！趕緊來學一學怎樣架設 Postfix 這個相當出色的郵件伺服器吧！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.2 所需要的軟體與軟體結構  	 		由於 CentOS 6.x 預設就是提供 postfix 的！所以根本無須調整啥咚咚～直接來使用吧！ 		那麼 postfix 有哪些重要的設定檔呢？他主要的設定檔都在 /etc/postfix/ 當中，詳細的檔案內容就讓我們來談談：  		 		/etc/postfix/main.cf  		這就是主要的 postfix 設定檔囉，幾乎所有的設定參數都是在這個檔案內規範的！ 		這個檔案預設就是一個完整的說明檔了，你可以參考這個檔案的內容就設定好屬於你的 postfix MTA 呢！ 		只要修改過這個檔案，記得要重新啟動 postfix 喔！    		/etc/postfix/master.cf  		主要規定了 postfix 每個程序的運作參數，也是很重要的一個設定檔。不過這個檔案預設已經很 OK  		了，通常不需要更改他。    		/etc/postfix/access (利用 postmap 處理)  		可以設定開放 Relay 或拒絕連線的來源或目標位址等資訊的外部設定檔，不過這個檔案要生效還需要在 /etc/postfix/main.cf  		啟動這個檔案的用途才行。且設定完畢後需要以 postmap 來處理成為資料庫檔案呢！    		/etc/aliases (利用 postalias 或 newaliases 均可)  		做為郵件別名的用途，也可以作為郵件群組的設定喔！ 		  		至於常見的執行檔則有底下這些：  		 		/usr/sbin/postconf (查閱 postfix 的設定資料)  		這個指令可以列出目前你的 postfix 的詳細設定資料，包括系統預設值也會被列出來， 		所以資料量相當的龐大！如果你在 main.cf 裡面曾經修改過某些預設參數的話，想要僅列出非預設值的設定資料， 		則可以使用『postconf -n』這個選項即可。    		/usr/sbin/postfix (主要的 daemon 指令)  		此為 postfix 的主要執行檔，你可以簡單的使用他來啟動或重新讀取設定檔：   `[root@www ~]# postfix check   <==檢查 postfix 相關的檔案、權限等是否正確！ [root@www ~]# postfix start   <==開始 postfix 的執行 [root@www ~]# postfix stop    <==關閉 postfix [root@www ~]# postfix flush   <==強制將目前正在郵件佇列的郵件寄出！ [root@www ~]# postfix reload  <==重新讀入設定檔，也就是 /etc/postfix/main.cf `  		要注意的是，每次更動過 main.cf 後，務必重新啟動 postfix，可簡單的使用『postfix  		reload』即可。不過老實說，鳥哥還是習慣使用 /etc/init.d/postfix reload..    		/usr/sbin/postalias  		設定別名資料庫的指令，因為 MTA 讀取資料庫格式的檔案效能較佳，所以我們都會將 ASCII 格式的檔案重建為資料庫。 		在 postfix 當中，這個指令主要在轉換 /etc/aliases 成為 /etc/aliases.db 囉！用法為：   `[root@www ~]# postalias hash:/etc/aliases # hash 為一種資料庫的格式，然後那個 /etc/aliases.db 就會自動被更新囉！ `  		/usr/sbin/postcat  		主要用在檢查放在 queue (佇列) 當中的信件內容。由於佇列當中的信件內容是給 MTA 看的， 		所以格式並不是一般我們人類看的懂的文字資料。所以這個時候你得要用 postcat 才可以看出該信件的內容。 		在 /var/spool/postfix 內有相當多的目錄，假設內有一個檔案名為 /deferred/abcfile ， 		那你可以利用底下的方式來查詢該檔案的內容喔：   `[root@www ~]# postcat /var/spool/postfix/deferred/abcfile `  		/usr/sbin/postmap  		這個指令的用法與 postalias 類似，不過他主要在轉換 access 這個檔案的資料庫啦！用法為：   `[root@www ~]# postmap hash:/etc/postfix/access `  		/usr/sbin/postqueue  		類似 mailq 的輸出結果，例如你可以輸入『postqueue -p』看看就知道了！ 		  		整個 postfix 的軟體結構大致上是這個樣子的，接下來讓我們先來簡單的處理一下 postfix 的收發信件功能吧！ 	   	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.3 一個郵件伺服器的設定案例  	 		前面談到 mail server 與 DNS 系統有很大的相關性，所以如果你想要架設一部可以連上 Internet 的郵件伺服器時， 		你必需要已經取得合法的 A 與 MX 主機名稱，而且最好反解也已經向您的 ISP 申請修改設定了， 		這可是個大前提！不要忽略他！在底下的練習當中鳥哥以之前[十九章 DNS](http://linux.vbird.org/linux_server/0350dns.php) 		內的設定為依據，主要的參數是這樣的：  		 		郵件伺服器的主要名稱為： www.centos.vbird 		郵件伺服器尚有別名為 linux.centos.vbird 及 ftp.centos.vbird 也可以收發信件； 		此郵件伺服器已有 MX 設定，直接指向自己 (www.centos.vbird) 		這個 www.centos.vbird 有個 A 的標誌指向 192.168.100.254。 		  		在實際的郵件伺服器設定當中，上述的幾個標誌是很重要的，請自行參考 DNS 章節的介紹吧！底下就讓我們來實際設定 		postfix 伺服器囉！ 	   	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.4 讓 Postfix 可監聽  	Internet 來收發信件  	 		在預設的情況下，CentOS 6.x 的 MTA 僅針對本機進行監聽，不相信嗎？測測看：  `[root@www ~]# netstat -tlnp | grep :25 Proto Recv-Q Send-Q Local Address   Foreign Address   State    PID/Program name tcp        0      0 127.0.0.1:25    0.0.0.0:*         LISTEN   3167/master `  		所以如果你要對整個 Internet 開放的話，就得要努力的搞定幾個簡單的設定囉！而幾乎所有的設定你都可已經由  		/etc/postfix/main.cf 這個檔案搞定！修改前你需要注意的項目有：  		 		『 # 』符號是註解的意思； 		所有設定值以類似『變數』的設定方法來處理，例如 myhostname = www.centos.vbird，請注意等號的兩邊要給予空白字元喔， 		且第一個字元不可以是空白，亦即『my..』要由行首寫起； 		可以使用『 $ 』來延伸使用變數設定，例如 myorigin = $myhostname，會等於 myorigin = www.centos.vbird； 		如果該變數支援兩個以上的資料，則使用空白字元來分隔，不過建議使用逗號加空白字元『, 』來處理。 		例如： mydestination = $myhostname,  $mydomain, linux.centos.vbird，意指 mydestination 支援三個資料內容之意。 		可使用多行來表示同一個設定值，只要在第一行最後有逗號，且第二行開頭為空白字元， 			即可將資料延伸到第二行繼續書寫 (所以剛剛第二點才說，開頭不能留白！)； 		**若重複設定某一項目，則以較晚出現的設定值為準！** 		  		要讓你的 postfix 可以收發信件時，你必需要啟動的設定資料有底下這些喔：    		 		myhostname：設定主機名稱，需使用 FQDN 喔    		這個項目在於設定你的主機名稱，且這個設定值會被後續很多其他的參數所引用，所以必須要設定正確才行。 		你應該要設定成為完整的主機名稱。在鳥哥的這個練習當中，應該設定為： 		 myhostname = www.centos.vbird 才對。 		除了這個設定值之外，還有一個 mydomain 的設定項目，這個項目預設會取 $myhostname 第一個『.』之後的名稱。 		舉例來說上頭設定完畢後，預設的 mydomain 就是 centos.vbird 囉！你也可以自行設定他。    		myorigin ：發信時所顯示的『發信源主機』項目    		這個項目在設定『郵件標頭上面的 mail from 的那個位址』， 		也就是代表本 MTA 傳出去的信件將以此設定值為準喔！如果你在本機寄信時忘記加上 Mail from 字樣的話， 		那麼就以此值為準了。預設這個項目以 $myhostname 為主的，例如： myorigin =  		$myhostname    		inet_interfaces ：設定 postfix 的監聽介面 (極重要)    		在預設的情況下你的 Postfix 只會監聽本機介面的 lo (127.0.0.1) 而已，如果你想要監聽整個 Internet 的話， 		請開放成為對外的介面，或者是開放給全部的介面，常見的設定方法為：  		inet_interfaces = all 才對！ 		由於如果有重複設定項目時，會以最晚出現的設定值為準，所以最好只保留一組 inet_interfaces 的設定喔！    		inet_protocols ：設定 postfix 的監聽 IP 協定    		預設 CentOS 的 postfix 會去同時監聽 IPv4, IPv6 兩個版本的 IP，如果你的網路環境裡面僅有 IPv4 時，那可以直接指定 		inet_protocols = ipv4 就會避免看到 :::1 之類的 IP 出現呦！    		mydestination ：設定『能夠收信的主機名稱』 (極重要)    		這個設定項目很重要喔！因為我們的主機有非常多的名字，那麼對方填寫的 mail to 到底要寫哪個主機名字我們才能將該信件收下？ 		就是在這裡規範的！也就是說，你的許多主機名稱當中，僅有寫入這個設定值的名稱才能作為 email 的主機位址。 		在我們這個練習當中這部主機有三個名字，所以寫法為：  		mydestination = $myhostname, localhost, linux.centos.vbird,  		ftp.centos.vbird    		如果你想要將此設定值移動到外部檔案，那可以使用類似底下的作法： 		mydestination = /etc/postfix/local-host-names ，然後在 local-host-names 		裡面將可收信的主機名稱寫入即可。一般來說，不建議你額外建立 local-host-names 這個檔案啦， 		直接寫入 main.cf 即可說！特別留意的是，如果你的 DNS 裡頭的設定有 MX  		標誌的話，那麼請將 MX 指向的那個主機名稱一定要寫在這個 mydestination 內， 		否則很容易出現錯誤訊息喔！一般來說，使用者最常發生錯誤的地方就在這個設定裡頭呢！ 		    		mynetworks_style ：設定『信任網域』的一項指標    		這個設定值在規定『與主機在同一個網域的可信任用戶端』的意思！舉例來說，鳥哥的主機 IP 是 		192.168.100.254，如果我相信整個區域網路內 (192.168.100.0/24) 的用戶的話，那我可規定此設定值為『 subnet 』吶！ 		不過，一般來說，因為底下的 mynetworks 會取代這個設定值， 		所以不設定也沒有關係喔！如果要設定的話，最好設定成為 host 即可 (亦即僅信任這部 MTA 主機而已)。    		mynetworks ：規定信任的用戶端 (極重要)    		你的 MTA 能不能幫忙進行 Relay 與這個設定值最有關係！舉例來說，我要開放本機與內部網域的 IP 時，就可以這樣進行設定： 		mynetworks = 127.0.0.0/8, 192.168.100.0/24。如果你想要以 /etc/postfix/access 		這個檔案來控制 relay 的用戶時，那鳥哥可以建議你將上述的資料改寫成這樣： 		mynetworks = 127.0.0.0/8, 192.168.100.0/24, hash:/etc/postfix/access 		然後你只要再建立 access 之後重整成資料庫後，嘿嘿！就能夠設定 Relay 的用戶囉！    		relay_domains ：規範可以幫忙 relay 的下一部 MTA 主機位址    		相對於 mynetworks 是針對『信任的用戶端』而設定的，這個 relay_domains  		則可以視為『針對下游 MTA 伺服器』而設定的。舉例來說，如果你這部主機是 www.niki.centos.vbird 的 MX 主機時， 		那你就得要在 relay_domains 設定針對整個 niki.centos.vbird 這個領域的目標信件進行轉遞才行。 		在預設的情況下，這個設定值是 $mydestination 而已啦。    		你必需要注意的『Postfix 預設並不會轉遞 MX 主機的信件』，意思就是說：如果你有兩部主機，一部是上游的 		MTAup ，一部是下游的 MTAdown ，而 MTAdown 規範的 MX 主機是 MTAup，由 		[22.1.2 談到的 DNS 的 MX 設定值與信件傳遞方向](http://linux.vbird.org/linux_server/0380mail.php#whatmail_dns)，我們知道任何想要寄給 MTAdown 主機的信件， 		都會先經過 MTAup 來轉遞才行！此時如果那部 MTAup 沒有開啟幫 MTAdown 進行 relay 的權限時， 		那麼任何傳給 MTAdown 的信件將『全部都被 MTAup 所退回』！從此 MTAdown 就無法收到任何信件了。    		上一段的說明請您特別再想一想，因為如果你在大公司服務而且你的公司上、下游均有 mail server 時， 		並且也有設定 MX 的狀況下，嘿嘿！這個 relay_domains 就很重要啦！上游的 MTA 主機必需要啟動這個設定。 		一般來說除非你是某部 MTA 主機的 MX 源頭，否則這個設定項目可以忽略不設定他。 		而如果你想要幫你的用戶端轉遞信件到某部特定的 MTA 主機時，這個設定項目也是可以設定的啦。 		預設請您保留預設值即可。    		alias_maps ：設定郵件別名    		就是設定郵件別名的設定項目，只要指定到正確的檔案去即可，這個設定值可以保留預設值啊：    		  		 		在瞭解上述的設定後，以鳥哥的範例來看的話，鳥哥有更動過或註明重要的設定值以及相關檔案是這樣處理的：  `[root@www ~]# vim /etc/postfix/main.cf myhostname = www.centos.vbird          <==約在第  77 行 myorigin = $myhostname                 <==約在第  99 行 inet_interfaces = all                  <==約在第 114 行，117 行要註解掉 inet_protocols = ipv4                  <==約在第 120 行 mydestination = $myhostname, localhost.$mydomain, localhost,   linux.centos.vbird, ftp.centos.vbird <==約在第 165,166 行 mynetworks = 127.0.0.0/8, 192.168.100.0/24, hash:/etc/postfix/access <==約在269行 relay_domains = $mydestination         <==約在第 299 行 alias_maps = hash:/etc/aliases alias_database = hash:/etc/aliases     <==約在第 389, 400 行 # 其他的設定值就先保留預設值即可啊！  [root@www ~]# postmap hash:/etc/postfix/access [root@www ~]# postalias hash:/etc/aliases `  		因為 main.cf 當中我們有額外加入兩個外部設定檔 (mynetworks 及 alias_maps) ，所以才會額外進行 postmap 及  		postalias。然後準備來啟動啦！你可以這樣處理喔：  `# 1. 先檢查設定檔的語法是否有錯誤 [root@www ~]# /etc/init.d/postfix check   <==沒有訊息，表示沒有問題。  # 2. 啟動與觀察 port number [root@www ~]# /etc/init.d/postfix restart [root@www ~]# netstat -tlunp | grep ':25' Proto Recv-Q Send-Q Local Address  Foreign Address   State   PID/Program name tcp        0      0 0.0.0.0:25     0.0.0.0:*         LISTEN  13697/master `  		很簡單吧！這樣就設定妥當了。假設你的防火牆已經處理完畢，那你的 Postfix  		已經可以開放用戶端進行轉遞，並且也可以收受信件囉！不過，到底在預設的情況下我們的 postfix  		可以收下哪些信件？又可以針對哪些設定值的內容進行轉遞呢？這就得要參考下一小節的說明了。 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.5 信件傳送流程與收信、relay  	等重要觀念  	 		我想，您對於 MTA 的設定與收發信件應該有一定程度的概念了，不過要妥善設定好你的 MTA 時， 		尤其是想要瞭解到整部 MTA 是如何收、發信件時，你最好還是要知道『我這部  		MTA 如何接受來源主機所傳來的信件，以及將信件轉遞到下一部主機去』的整個流程啊。 		一般來說一封郵件傳送會經過許多的流程為：  		 		送信端與收信端兩部主機間會先經過一個握手 (ehlo) 的階段，此時送信端被記錄為發信來源(而不是 mail from)。 		通過握手後就可以進行信件標頭 (header) 的傳送；   		此時收信端主機會分析標頭的資訊，若信件之 Mail to: 主機名稱為收信端主機，且該名稱符合  		mydestination 的設定，則該信件會開始被收下至佇列，並進一步送到 mailbox 當中； 		若不符合 mydestination 的設定，則終止連線且不會進行信件內容 (body) 的傳送；   		若 Mail to: 主機名稱非為收信端本身，則開始進行轉遞 (relay) 的分析。   		轉遞過程首先分析該信件的來源是否符合信任的用戶端 (這個用戶端為步驟 1 所記錄的發信主機喔)，亦即來源是否符合 		 mynetworks 的設定值，若符合則開始收下信件至佇列中，並等待 MDA 將信件再轉遞出去，若不符 mynetworks  		則繼續下一步；   		分析信件來源或目標是否符合 relay_domains 的設定，若符合則信件將被收下至佇列，並等待 MDA  		將信件再轉遞出去；   		若這封信的標頭資料都不合乎上述的規範，則終止連線，並不會接受信件的內容資料的。 		  		整個流程有點像底下這樣：  		![在本機 MTA 當中的信件分析過程](http://linux.vbird.org/linux_server/0380mail//mail-flow.gif)  		圖 22.2-1、在本機 MTA 當中的信件分析過程   		也就是說標頭分析通過後，你的信件內容才會開始上傳到主機的佇列，然後透過 MDA 來處理該信件的流向。 		而不是將信件完整的傳送到主機後才開始分析的喔！這個得要特別注意吶！而透過上述的流程後， 		在暫不考慮 access 以及 MDA 的分析機制中，一部 MTA 想要正確的收、發信件時，電子郵件必需要符合：  		 		收信方面：必需符合底下需求： 			 			發信端必需符合 $inet_interfaces 的設定； 			信件標頭之收件者主機名稱必需符合 $mydestination 的設定， 			或者收件主機名稱需要符合 $virtual_maps (與虛擬主機有關) 的設定；   		轉遞方面 (Relay)：必需符合底下需求： 			 			發信端必需符合 $inet_interfaces 的設定； 			發信端來源必需為 $mynetworks 的設定；發信端來源或信件標頭之收件者主機名稱符合 			$relay_domains 之設定內容。 		  		同樣的原理與想法你可以將他用在 sendmail 的設定當中喔！ ^_^！不過很多垃圾信卻是藉由這個預設的收發管道來發送， 		怎麼說呢？請看底下的分析：   例題： 在我的主機上面竟然發現這樣的廣告信，那就是『利用我的主機發送廣告信給我自己！』為什麼這樣也可以呢？  答： 首先，你必需要熟悉一下上述的流程，在第 2 個步驟當中我們知道，當主機收到一封信且這封信的目標是自己， 並且也符合 mydestination 的設定時，該信件就會被收下來而不必驗證用戶端是否來自於 mynetworks 了。 所以說，任何人都可以用這個流程來寄信給你啊。不過，你的 MTA 並不是 open relay 啦，不會幫人家發送廣告信的，不用擔心。      例題： 我的主機明明沒有 Open relay ，但很多其他的 MTA 管理員發信給我，說我的主機的某個帳號持續發送廣告信， 但是我的主機明明沒有那個帳號啊！這是怎麼回事？  答： 仔細看一下流程的步驟 1 與 2 ，確認該封信能否被收下來與發信端及收信端主機名稱有關。 而我們知道在郵件的 header 裡面還有一個 mail from 的標頭設定項目，這個標頭設定是我們在查閱郵件時看到的『回郵位址』， 這個資料是可以偽造的！而且他與收發信件的資料無關！所以，您應該要告知對方 MTA 管理員， 請他提供詳細的 log 資料，才能夠判斷該封信是否由你的主機所發送出去的。   一般來說，目前的廣告業者很多都是利用這種欺敵的方式來處理的，所以您必需要請對方提供詳細的 log file 資料以供查驗才行喔！    	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.6 設定郵件主機使用權限與過濾機制 	/etc/postfix/access  	 		基本上，指定了 Postfix 的 mynetworks 的信任來源就能夠讓使用者 relay  		了，不過如果你依照[鳥哥上述的方式 (22.2.4)](http://linux.vbird.org/linux_server/0380mail.php#postfix_basic_case) 來設定你的 mynetworks  		的話，那麼我們還可以利用 access 這個檔案來額外管理我們的信件過濾呢！基本的 access 語法為：  `規範的範圍或規則               Postfix 的動作 (範例如下) IP/部分IP/主機名/Email等       OK/REJECT `  		假設你想要讓 120.114.141.60 還有 .edu.tw 可以使用這部 MTA 來轉遞信件，且不許 av.com 以及 		192.168.2.0/24 這個網域的使用時，可以這樣做：  `[root@www ~]# vim /etc/postfix/access 120.114.141.60		OK .edu.tw			OK av.com			REJECT 192.168.2.  		REJECT # OK 表示可接受，而 REJECT 則表示拒絕。  [root@www ~]# postmap hash:/etc/postfix/access [root@www ~]# ls -l /etc/postfix/access* -rw-r--r--. 1 root root 19648 2011-08-09 14:05 /etc/postfix/access -rw-r--r--. 1 root root 12288 2011-08-09 14:08 /etc/postfix/access.db # 你會發現有個 access.db 的檔案才會同步更新！這才是 postfix 實際讀取的！ `  		用這個檔案設定最大的好處是，你不必重新啟動 postfix，只要將資料庫建立好， 		立刻就生效了！這個檔案還有其它的進階功能，你可以自行進入該檔案查閱就知道了。但是進階設定還需要 main.cf  		內的其他參數有設定才行！如果只有之前 $mynetworks 的設定值時，你只能利用 access.db 的方式來開放 relay  		的能力而已。不過，至少他可以讓我們的設定簡化囉！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.7 設定郵件別名： /etc/aliases,  	~/.forward  	 		想一想，你的主機裡面不是有很多系統帳號嗎？例如 named, apache, mysql...， 		那麼以這些帳號執行的程式若有訊息發生時，他會將該訊息以 email 的方式傳給誰？應該就是傳給 named, apache... 等帳號自己吧。 		不過，你會發現其實這些系統帳號的資訊都是丟給 root！ 		這是因為其他的系統帳號並沒有密碼可登入，自然也就無法接收任何郵件了，所以若有郵件就給系統管理員囉。不過，咱們的 MTA  		怎麼知道這些信件要傳給 root ？這就得要 aliases 這個郵件別名設定檔來處理啦！    		郵件別名設定檔： /etc/aliases  		在你的 /etc/aliases 檔案內，你會發現類似底下的字樣：  `[root@www ~]# vim /etc/aliases mailer-daemon:  postmaster postmaster:     root bin:            root daemon:         root ....(底下省略).... `  		左邊是『別名』右邊是『實際存在的使用者帳號或者是 email address』！ 		就是透過這個設定值，所以讓我們可以將所有系統帳號所屬的信件通通丟給 root 啊！好，我們現在將他擴大化，假如你的 MTA  		內有一個實際的帳號名稱為 dmtsai ，這個使用者還想要使用 dermintsai 這個名稱來收他的信件， 		那麼你可以這樣做：  `[root@www ~]# vim /etc/aliases dermintsai:     dmtsai # 左邊是你額外所設定的，右邊則是實際接收這封信的帳號！  [root@www ~]# postalias hash:/etc/aliases [root@www ~]# ll /etc/aliases* -rw-r--r--. 1 root root  1535 2011-08-09 14:10 /etc/aliases -rw-r--r--. 1 root root 12288 2011-08-09 14:10 /etc/aliases.db `  		從此之後不論是 dmtsai@www.centos.vbird 還是 dermintsai@www.centos.vbird 都會將信件丟到 		/var/spool/mail/dmtsai 這個信箱當中喔！很方便吧！    		/etc/aliases 實際應用一：讓一般帳號可接收 root 的信  		假設你是系統管理員，而你常用的一般帳號為 dmtsai，但是系統出錯時的重要信件都是寄給 root 啊， 		偏偏 root 的信件不能被直接讀取....所以說，如果能夠將『給 root 的信也轉寄一份給 dmtsai 』的話， 		那就太好了！可以達到嗎？當然可以！你可以這樣做：  `[root@www ~]# vim /etc/aliases root:		root,dmtsai  <==鳥哥建議這種寫法！ # 信件會傳給 root 與 dmtsai 這兩個帳號！  root:		dmtsai       <==如果 dmtsai 不再是管理員怎辦？ # 從此 root 收不到信了，都由 dmtsai 來接受！  [root@www ~]# postalias hash:/etc/aliases `  		上面那兩行你可以擇一使用，看看 root 要不要保留他的信件都可以的！鳥哥建議使用第一種方式，因為這樣一來， 		你的 dmtsai 可以收到 root 的信，且 root 自己也可以『備份』一份在他的信箱內，比較安全啦！    		/etc/aliases 實際應用二：發送群組寄信功能  		想像一個情況，如果你是學校的老師，你雖然只帶一班導生，但是『每年都一班』時，如果有一天你要將信發給所有的學生， 		那在寫 email 的標頭時，可能就會頭昏昏的了 (因為聯絡人名單太多了)！這個時候你可以這樣做： 		(假設主機上學生的帳號為 std001, std002... )  `[root@www ~]# vim /etc/aliases student2011:	std001,std002,std003,std004...  [root@www ~]# postalias hash:/etc/aliases `  		如此一來只要寄信到這部主機的 student2011 這個不存在的帳號時，該封信就會被分別存到各個帳號裡頭去， 		管理上面是否很方便啊！ ^_^！事實上，郵件別名除了填寫自己主機上面的實體用戶之外，其實你可以填寫外部主機的 email 喔！ 		例如你要將本機的 dermintsai 那個不存在的用戶的信件除了傳給 dmtsai 之外，還要外傳到 		dmtsai@mail.niki.centos.vbird 時，可以這樣做：  `[root@www ~]# vim /etc/aliases dermintasi:	dmtsai,dmtsai@mail.niki.centos.vbird  [root@www ~]# postalias hash:/etc/aliases `  		很方便吧！更多的功能就期待您自行發掘囉！  		**Tips:** 		在這本書裡面，dmtai 的家目錄並非在正規的 /home 底下，而是放置於 /winhome 當中 (參考第十六章的練習)，所以實際操作  		mail 指令會出錯！這是因為 SELinux 的關係！請參考 /var/log/messages 底下的建議動作去處理即可！ 		![鳥哥的圖示](http://linux.vbird.org/images/vbird_face.gif) 		個人化的郵件轉遞： ~/.forward  		雖然 /etc/aliases 可以幫我們達到郵件別名設定的好處，不過 /etc/aliases 是只有 root 才能修改的檔案權限， 		那我們一般使用者如果也想要進行郵件轉遞時，該如何是好？沒關係，可以透過自己家目錄下的 .forward 這個檔案喔！ 		舉例來說，我的 dmtsai 這個帳號所接收到的信件除了自己要保留一份之外，還要傳給本機上的 vbird 以及 		dmtsai@mail.niki.centos.vbird 時，那你可以這樣做設定：  `[dmtsai@www ~]$ vim .forward # 注意！我現在的身份現在是 dmtsai 這個一般身份，而且在他的家目錄下！ dmtsai vbird dmtsai@mail.niki.centos.vbird  [dmtsai@www ~]$ chmod 644 .forward `  		記得這個檔案內容是一行一個帳號 (或 email) ，而且權限方面非常重要：  		 		該檔案所在使用者家目錄權限，其 group、other 不可以有寫入權限。 		.forward 檔案權限，其 group、other 不可以有寫入權限。 		 		如此一來這封信就會開始轉遞囉！有趣吧！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.8 察看信件佇列資訊： postqueue, 	mailq  	 		說實話，設定到此為止咱們的 postfix 應該可以應付一般小型企業之 mail server 的用途了！ 		不過，有的時候畢竟因為網路的問題或者是對方主機的問題，可能導致某些信件無法送出而被暫存在佇列中， 		那我們如何瞭解佇列當中有哪些郵件呢？還有，在佇列當中等待送出的信件是如何送出的呢？  		 		如果該封信在五分鐘之內無法寄出，則通常系統會發出一封『警告信』給原發信者， 			告知該封郵件尚無法被寄送出去，不過，系統仍會持續的嘗試寄出該封郵件； 		如果在四小時候仍無法寄出，系統會再次的發出警告信給原發信者； 		如果持續進行五天都無法將信件送出，那麼該封郵件就會退回給原發信者了！ 		  		當然啦，某些 MTA 已經取消了警告信的寄發，不過原則上，如果信件無法即時寄出去的話 MTA 還是會努力嘗試 5  		天的，如果接下來的 5 天都無法送出時，才會將原信件退回給發信者。 		一般來說，如果 MTA 設定正確且網路沒有問題時，應該是不可能會有信件被放在佇列當中而傳不出去的， 		所以如果發現有信件在佇列時，當然得要仔細的瞧一瞧囉！檢查佇列內容的方法可以使用 mailq ， 		也可以使用 postqueue -p 來檢查的：  `[root@www ~]# postqueue -p Mail queue is empty `  		若您的郵件如此顯示時，恭喜您，沒有什麼問題郵件在佇列當中。不過如果你將 postfix 關閉， 		並嘗試發一封信給任何人，那就可能會出現如下的畫面啦：  `[root@www ~]# /etc/init.d/postfix stop [root@www ~]# echo "test" | mail -s "testing queue" root [root@www ~]# postqueue -p postqueue: warning: Mail system is down -- accessing queue directly -Queue ID- --Size-- ----Arrival Time---- -Sender/Recipient------- 5CFBB21DB       284 Tue Aug  9 06:21:58  root                                          root -- 0 Kbytes in 1 Request. # 第一行就說明了無法寄出的原因為 Mail system is down 啦！ # 然後才出現無法寄出的信件資訊！包括來源與目標喔！ `  		輸出的資訊主要為：  		 		Queue ID：表示此封郵件佇列的代表號 (ID)，這個號碼是給 MTA 看的，我們看不懂不要緊； 		Size ：這封信有多大容量 (bytes) 的意思； 		Arrival Time：這封信什麼時候進入佇列的，並且可能會說明無法立即傳送出去的原因； 		Sender/Recipient：送信與收信者的電子郵件囉！  		  		事實上這封信是放置在 /var/spool/postfix 裡面，由於信件內容已經編碼為給 MTA 看的資料排列， 		所以你可以使用 postcat 來讀出原信件的內容喔！例如這樣做 (注意看檔名與 Queue ID 的對應！)：  `[root@www ~]# cd /var/spool/postfix/maildrop [root@www maildrop]# postcat 5CFBB21DB  <==這個檔名就是 Queue ID *** ENVELOPE RECORDS 5CFBB21DB ***     <==說明佇列的編號啊 message_arrival_time: Tue Aug  9 14:21:58 2011 named_attribute: rewrite_context=local <==分析 named (DNS) 的特性來自本機 sender_fullname: root                  <==發信者的大名與 email sender: root recipient: root                        <==就是收件者囉！ *** MESSAGE CONTENTS 5CFBB21DB ***     <==底下則是信件的實際內容啊！ Date: Tue, 09 Aug 2011 14:21:58 +0800 To: root Subject: testing queue User-Agent: Heirloom mailx 12.4 7/29/08 MIME-Version: 1.0 Content-Type: text/plain; charset=us-ascii Content-Transfer-Encoding: 7bit  test *** HEADER EXTRACTED 5CFBB21DB *** *** MESSAGE FILE END 5CFBB21DB *** `  		如此一來你就知道目前我們的 MTA 主機有多少未送出的信件，還有未送出信件的內容你也可以追蹤的到了！ 		很不錯，對吧！不過，如果你想要我們的 postfix 立刻嘗試將這些在佇列當中的信件寄出去，那又該如何是好？ 		你有幾個作法啦，可以重新啟動 postfix ，也可以透過 postfix 的動作來處理，例如：  `[root@www ~]# /etc/init.d/postfix restart [root@www ~]# postfix flush `  		鳥哥個人比較建議使用 postfix flush 囉！自行參考看看先！ ^_^！接下來，讓我們先來處理一下收信的 MRA 伺服器， 		搞定後再來處理用戶端的使用者介面吧！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.2.9 防火牆設置  	 		因為整個 MTA 主要是透過 SMTP (port 25) 進行信件傳送的任務，因此，針對 postfix 來說，只要放行 port 25 即可呦！ 		修改一下 [iptables.rule](http://linux.vbird.org/linux_server/0250simple_firewall.php#local_script) 吧！  `[root@www ~]# vim /usr/local/virus/iptables/iptables.rule # 找到底下這一行，並且將它註解拿掉！ iptables -A INPUT -p TCP -i $EXTIF --dport  25  --sport 1024:65534 -j ACCEPT  [root@www ~]# /usr/local/virus/iptables/iptables.rule `  		這樣就放行整個 Internet 對您伺服器的 port 25 的讀取囉！簡單！搞定！ 	    ![大標題的圖示](http://linux.vbird.org/images/penguin-m.gif)22.3 MRA 伺服器： dovecot 設定   	除非你想要架設 webmail 在你的 MTA 上頭，否則，你的 MTA 收下了信件，你總得連上 MTA 去收信吧？那麼收信要用的是哪個通訊協定？ 	就是 [22.1.4](http://linux.vbird.org/linux_server/0380mail.php#whatmail_pop) 裡面談到的 pop3 以及 imap 囉！這就是所謂的 MRA 伺服器！我們的 CentOS 6.x 	使用的是 dovecot 這個軟體來達成 MRA 的相關通訊協定的！但由於 pop3/imap 還有資料加密的版本，底下我們就依據是否加密 (SSL) 	來設定 dovecot 吧！    	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.3.1 基礎的 POP3/IMAP 設定  	 		啟動單純的 pop3/imap 是很簡單的啦，你得要先確定已經安裝了 dovecot 這個軟體。而這個軟體的設定檔只有一個，就是  		/etc/dovecot/dovecot.conf 。我們僅要啟動 pop3/imap 而已，所以可以這樣設定即可：  `[root@www ~]# yum install dovecot [root@www ~]# vim /etc/dovecot/dovecot.conf # 找到底下這一行，大約是在第 25 行左右的地方，複製新增一行內容如下： #protocols = imap pop3 lmtp protocols = imap pop3  [root@www ~]# vim /etc/dovecot/conf.d/10-ssl.conf ssl = no   <==將第 6 行改成這樣！ `  		改完之後你就可以啟動 dovecot 囉！並且檢查看看 port 110/143 (pop3/imap) 有沒有啟動啊？  `[root@www ~]# /etc/init.d/dovecot start [root@www ~]# chkconfig dovecot on [root@www ~]# netstat -tlnp | grep dovecot Proto Recv-Q Send-Q Local Address   Foreign Address   State    PID/Program name tcp        0      0 :::110          :::*              LISTEN   14343/dovecot tcp        0      0 :::143          :::*              LISTEN   14343/dovecot `  		耶！搞定！這樣就可以提供使用者來收信件啦！真是不錯啊！不過記得喔，這裡只提供基本的明碼 pop3/imap 傳輸而已， 		如果想要啟動其他如 pop3s (傳輸加密機制) 協定時，就得要額外的設定囉！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.3.2 加密的 POP3s/IMAPs 設定  	 		如果擔心資料在傳輸過程會被竊取，或者是你的登入資訊 (帳號與密碼) 在使用 pop3/imap 時會被竊聽， 		那麼這個 pop3s/imaps 就顯的重要啦！與之前的 Apache 相似的，其實我們都是透過 openssl 這個軟體提供的 SSL 		加密機制來進行資料的加密傳輸。方式很簡單呢！預設的情況下，CentOS 已經提供了 SSL 憑證範例檔給我們使用了。 		如果你一點都不想要使用預設的憑證，那麼我們就來自己建一個吧！  `# 1. 建立憑證：到系統提供的 /etc/pki/tls/certs/ 目錄下建立所需要的 pem 憑證檔： [root@www ~]# cd /etc/pki/tls/certs/ [root@www certs]# make vbirddovecot.pem ....(前面省略).... Country Name (2 letter code) [XX]:TW State or Province Name (full name) []:Taiwan Locality Name (eg, city) [Default City]:Tainan Organization Name (eg, company) [Default Company Ltd]:KSU Organizational Unit Name (eg, section) []:DIC Common Name (eg, your name or your server's hostname) []:www.centos.vbird Email Address []:dmtsai@www.centos.vbird  # 2. 因為擔心 SELinux 的問題，所以建議將 pem 檔案放置到系統預設的目錄去較佳！ [root@www certs]# mv vbirddovecot.pem ../../dovecot/ [root@www certs]# restorecon -Rv ../../dovecot  # 3. 開始處理 dovecot.conf，只要 pop3s, imaps 不要明碼傳輸的咯！ [root@www certs]# vim /etc/dovecot/conf.d/10-auth.conf disable_plaintext_auth = yes  <==第 9 行改成這樣！取消註解！  [root@www certs]# vim /etc/dovecot/conf.d/10-ssl.conf ssl = required                                <==第 6 行改成這樣 ssl_cert = </etc/pki/dovecot/vbirddovecot.pem <==12, 13 行變這樣 ssl_key =  </etc/pki/dovecot/vbirddovecot.pem  [root@www certs]# vim /etc/dovecot/conf.d/10-master.conf   inet_listener imap {     port = 0     <== 15 行改成這樣   }   inet_listener pop3 {     port = 0     <== 36 行改成這樣   }  # 4. 處理額外的 mail_location 設定值！很重要！否則網路收信會失敗： [root@www certs]# vim /etc/dovecot/conf.d/10-mail.conf mail_location = mbox:~/mail:INBOX=/var/mail/%u <==第 30 行改這樣  # 5. 重新啟動 dovecot 並且觀察 port 的變化： [root@www certs]# /etc/init.d/dovecot restart [root@www certs]# netstat -tlnp | grep dovecot Proto Recv-Q Send-Q Local Address  Foreign Address   State    PID/Program name tcp        0      0 :::993         :::*              LISTEN   14527/dovecot tcp        0      0 :::995         :::*              LISTEN   14527/dovecot `  		最終你看到的 993 是 imaps 而 995 則是 pop3s 囉！這樣一來，你收信的時候，輸入的帳號密碼就不怕被竊聽了！ 		反正是加密後的資料囉！很簡單吧！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.3.3 防火牆設置  	 		因為上面的練習中，我們將 pop3/imap 關閉，轉而打開 pop3s/imaps 了，因此防火牆啟動的埠口會不一樣！ 		請依據您實際的案例來設定你所需要的防火牆才好。我們這裡主要是開放 993, 995 兩個埠口呦！ 		處理的方法與 22.2.9 相當類似：  `[root@www ~]# vim /usr/local/virus/iptables/iptables.rule # 大約在 180 行左右，新增底下兩行去！ iptables -A INPUT -p TCP -i $EXTIF --dport 993  --sport 1024:65534 -j ACCEPT iptables -A INPUT -p TCP -i $EXTIF --dport 995  --sport 1024:65534 -j ACCEPT  [root@www ~]# /usr/local/virus/iptables/iptables.rule `  		 如果你的 pop3/imap 還是決定不加密的話，請將上面的 993/995 改成 143/110 即可！ 	    ![大標題的圖示](http://linux.vbird.org/images/penguin-m.gif)22.4 MUA 軟體：用戶端的收發信軟體   	設定 Mail server 不是拿來好看的，當然是要好好的應用他囉！應用 mail server 有兩種主要的方式，你可以直接登入 Linux  	主機來操作 MTA ，當然也可以透過用戶端的 MUA 軟體來收發信件，底下我們分別介紹這兩種方式囉！    	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.4.1 Linux mail  	 		在 Unix like 的作業系統當中都會存有一支可以進行收發信件的軟體，那就是『 mail 』這個指令。這個指令是由 mailx  		這個軟體所提供的，所以您得要先安裝這個軟體才行。另外，由於 mail 是 Linux 系統的功能，所以即使你的 port 25  		(smtp) 沒有啟動，他還是可以使用的，只是該封郵件就只會被放到佇列，而無法寄出去囉！^_^！底下我們來談一談最簡單的  		mail 用法吧    		用 mail 直接編輯文字郵件與寄信  		mail 的用法很簡單，就是利用『 mail [email address] 』的方式來將信件寄出去， 		那個 [email address] 可以是對外的郵件位址，也可以是本機的帳號。如果是本機帳號的話，可以直接加帳號名稱即可。 		例如：『 mail root 』或『 mail somebody@his.host.name 』。如果是對外寄信的時候， 		信件預設的『 Mail from 』就會填寫 main.cf 內那個 myorigin 變數的主機名稱囉！ 		先來試看看吧！寄給 dmtsai@www.centos.vbird 先：  `[root@www ~]# mail dmtsai@www.centos.vbird Subject: Just test        <==這裡填寫信件標題 This is a test email.     <==底下為信件的內容！ bye bye ! .                         <==注意，這一行只有小數點！代表結束輸入之意！ `  		這樣就可以將信件寄出去了！另外，早期的 mail server 是可以接受 IP 寄信的，舉例來說： 		mail dmtsai@[192.168.100.254] ，記得 IP 要用中括號包起來。不過由於受到垃圾郵件的影響， 		現在這種方式幾乎都無法成功的將信件寄出了。    		利用已經處理完畢的『純文字檔』寄出信件  		這可不是『附件夾帶』的方式！因為在 mail 這個程式裡面編輯信件是個很痛苦的差事， 		你不能夠按上下左右鍵來回到剛剛編輯有錯誤的地方，很傷腦筋。此時我們可以透過標準輸入來處理！ 		如果你忘記『 < 』代表的意義，請回到[基礎篇的第十一章 bash shell](http://linux.vbird.org/linux_basic/0320bash.php)中的資料流重導向瞧瞧先！舉例來說你要將家目錄的 .bashrc  		寄給別人，可以這樣做：  `[root@www ~]# mail -s 'My bashrc' dmtsai < ~/.bashrc `  		開始查閱接收的信件  		寄信還比較簡單，那麼收信呢？同樣的收信還是使用 mail。直接在提示字元之後輸入 mail 時，會主動的捉取使用者在  		/var/spool/mail 底下的郵件信箱 (mailbox)，例如我 dmtsai 這個帳號在輸入 mail 後，就會將  		/var/spool/mail/dmtsai 這個檔案的內容讀出來並顯示到螢幕上，結果如下：  `# 注意喔！底下的身份使用的是 dmtsai 這個用戶來操作 mail 這個指令的呦！ [dmtsai@www ~]$ mail Heirloom Mail version 12.4 7/29/08.  Type ? for help. "/var/spool/mail/dmtsai": 10 messages 10 new <==信箱來源與新信件數 >N  1 dmtsai@www.centos.vb  Mon Aug  8 18:53  18/579   "from vbird" ....(中間省略)....  N  9 root                  Tue Aug  9 15:04  19/618   "Just test"  N 10 root                  Tue Aug  9 15:04  29/745   "My bashrc" &  <==這個是 mail 軟體的提示字元，可以輸入 ? 來察看可用指令 `  		在上面的畫面中，顯示 dmtsai 有一封信，且會附上該信件的發信者與標題及收信時間等。你可以用的指令有這些：  		 		讀信： (直接按 Enter 或輸入數字後 enter)  		有看到『 > 』那個符號吧！那表示目前 mail 所在的郵件位置，你可以直接輸入 Enter 即可看到該封信件的內容！ 		另外，你也可以在『&』之後的游標位置輸入號碼，就可以看該封信件的內容了！(註：如果持續按  		Enter，則會自『 > 』符號所在的郵件逐次向後讀取每封信件內容！)    		顯示標題： (直接數入 h 或輸入 h 數字)  		例如有 100 封信，要看 90 封左右的信件標題，就輸入『 h90 』即可。    		回覆郵件： (直接輸入 R )  		如果要回覆目前『 > 』符號所在的郵件，直接按下『 R 』即可進入剛剛前面介紹過的 mail  		文字編輯畫面囉！你可以編輯信件後傳回去囉！    		刪除郵件： (輸入 d 數字)  		按下『 d## 』即可刪除郵件！例如我要刪除掉第 2 封郵件，可以輸入『 d2 』如果是要刪除第 10-50 		封郵件，可以輸入『 d10-50 』來刪除喔！請記得，如果有刪除郵件的話，離開 mail box 時，要使用『 q 		』才行！    		儲存郵件到檔案： (輸入 s 數字 檔名)  		如果要將郵件資料存下來，可以輸入『 s ## filename 』，例如我要將上面第 10 封郵件存下來，可以輸入『 s 10 text.txt 		』即可將第一封郵件內容存成 text.txt 這個檔案！    		離開 mail： (輸入 q 或 x )  		要離開 mail 可以輸入 q 或者是 x，請注意『輸入 x 可以在不更動 mail box 的情況下離開 mail  		程式，不管你剛剛有沒有使用 d 刪除資料；使用 q 才會將刪除的資料移除。』也就是說，如果你不想更動 mail box  		那就使用 x 或 exit 離開，如果想要使剛剛移除的動作生效，就要使用 q 啦！    		請求協助： 關於 mail 更詳細的用法可以輸入  		help 就可以顯現目前的 mail 所有功能！ 		  		上面是簡易的 mail 收信功能！不過，我們曾經將信件轉存下來的話，那該如何讀取該信件呢？例如讀取剛剛記錄的 text.txt 		郵件信箱。其實可以簡單的使用這個方式來讀取：  `[dmtsai@www ~]$ mail -f ~/text.txt `  		以『附件夾帶』的方式寄信  		前面提到的都是信件的內容，那麼有沒有可能以『附件』的方式來傳遞檔案？是可以的，不過你需要  		uuencode 這個指令的幫忙，在 CentOS 當中這個指令屬於 sharutils ，請先利用 yum  		來安裝他吧！接下來你可以這樣使用：  `[root@www ~]# [利用 uuencode 編碼 ] | [利用 mail 寄出去] [root@www ~]# uuencode [實際檔案] [信件中的檔名] | mail -s '標題' email  # 1. 將 /etc/hosts 以附件夾帶的方式寄給 dmtsai [root@www ~]# uuencode /etc/hosts myhosts | mail -s 'test encode' dmtsai `  		這樣就能寄出去了，不過，如果收下這封信件呢？同樣的我們得要透過解碼器來解碼啊！ 		你得先將該檔案存下來，然後這樣做：  `# 底下的身份可是 dmtsai 這個用戶喔！ [dmtsai@www ~]$ mail Heirloom Mail version 12.4 7/29/08.  Type ? for help. "/var/spool/mail/dmtsai": 11 messages 1 new 8 unread     1 dmtsai@www.centos.vb  Mon Aug  8 18:53  19/590   "from vbird" ....(中間省略)....  U 10 root                  Tue Aug  9 15:04  30/755   "My bashrc" >N 11 root                  Tue Aug  9 15:12  29/1121  "test encode" & s 11 test_encode "test_encode" [New file] 31/1141 & exit  [dmtsai@www ~]$ uudecode test_encode -o decode                              加密檔         輸出檔 [dmtsai@www ~]$ ll *code* -rw-r--r--. 1 dmtsai dmtsai  380 Aug  9 15:15 decode      <==解碼後的正確資料 -rw-rw-r--. 1 dmtsai dmtsai 1121 Aug  9 15:13 test_encode <==內文會有亂碼 `  		雖然 mail 這個指令不是挺好用的，不過至少他可以提供我們在 Linux 純文字模式下的一個簡單的收發信件功能！ 		不過，目前有個更棒的替代方案，那就是 mutt 這玩意兒囉！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.4.2 Linux mutt  	 		mutt 除了可以模擬 mail 這個指令之外，他還能夠透過 pop3/imap 之類的協定去讀取外部的信件喔！所以這傢伙真的很不賴！ 		讓我們來玩玩 mutt 這個好物吧！在開始底下的動作前，請使用 yum install mutt 安裝好它吧！    		直接以 mutt 進行寄送信件的動作：含快速附件夾帶檔  		mutt 的功能也很多，我們先來看看 mutt 的基本語法好了，再來開始進行練習吧！  `[root@www ~]# mutt [-a 附加檔] [-i 內文檔] [-b 秘密副本] [-c 一般副本] \ >  [-s 信件標題] email位址 選項與參數： -a 附加檔：後面就是你想要傳送給朋友的檔案，是附加檔案，不是信件內容喔！ -i 內文檔：就是信件的內文部分，先編寫成為檔案而已； -b 秘密副本：原收件者不知道這封信還會寄給後面的那個秘密副本收件者； -c 一般副本：原收件者會看到這封信還有傳給哪位收件者； -s 信件標題：這還需要解釋嗎？這封信的標頭！ email位址：就是原收件者的 email 囉！  # 1. 直接線上編寫信件，然後寄給 dmtsai@www.centos.vbird 這個用戶 [root@www ~]# mutt -s '一封測試信' dmtsai@www.centos.vbird /root/Mail 不存在。建立嗎？ ([yes]/no): y  <==第一次用才會出現這個訊息 To: dmtsai@www.centos.vbird Subject: 一封測試信 隨便寫寫！隨便看看～！  <==會進入 vi 畫面編輯！很棒！  y:寄出  q:中斷  t:To  c:CC  s:Subj  a:附加檔案  d:敘述  ?:求助 <==按下 y 寄出     From: root <root@www.centos.vbird>       To: dmtsai@www.centos.vbird       Cc:      Bcc:  Subject: 一封測試信 Reply-To:      Fcc: ~/sent Security: 清除  -- 附件 - I     1 /tmp/mutt-www-2784-0      [text/plain, 8bit, utf-8, 0.1K]  # 2. 將 /etc/hosts 當成信件內容寄給 dmtsai@www.centos.vbird 這個用戶 [root@www ~]# mutt -s 'hosts' -i /etc/hosts dmtsai@www.centos.vbird # 記得最終在 vim 底下要按下 :wq 來儲存寄出喔！ `  		與 mail 線上編寫文字不一樣，mutt 竟然會呼叫 vi 讓你去編輯你的信件！如此一來，當然不需要預先編寫信件內文了！ 		這真是讓人感到非常的開心啊！而且整個畫面非常的直覺化！相當容易處理呢！那麼如果需要附件夾帶呢？尤其是夾帶 		binary program 時，可以這樣做：  `# 1. 將 /usr/bin/passwd 當成附件夾帶，寄給 dmtsai@www.centos.vbird 用戶 [root@www ~]# mutt -s '附件' -a /usr/bin/passwd -- dmtsai@www.centos.vbird To: dmtsai@www.centos.vbird Subject: 附件 不過是個附件測試！  y:寄出  q:中斷  t:To  c:CC  s:Subj  a:附加檔案  d:敘述  ?:求助  <==按 y 送出     From: root <root@www.centos.vbird>       To: dmtsai@www.centos.vbird       Cc:      Bcc:  Subject: 附件 Reply-To:      Fcc: ~/sent Security: 清除  -- 附件 - I   1 /tmp/mutt-www-2839-0       [text/plain, 8bit, utf-8, 0.1K] <==內文檔   A   2 /usr/bin/passwd          [applica/octet-stre, base64, 31K] <==附加檔 `  		看到上表中的附件底下那兩行嗎？I 代表的是直接附在信件內的內文，A 才是附加檔案！這樣看懂了嗎？ 		不過你想要使用 mutt 來附加檔案時，必須要有底下的注意事項才行： 		 		『 -a filename 』這個選項必須是在指令的最後面，如果上述的指令改寫成：『 mutt -a /usr/bin/passwd -s "附件" ... 		』就不行！會失敗的！ 		在檔名與 email 位址之間需要加上兩個連續減號『 -- 』才行！如同上面測試的指令模樣！   		  		以 mutt 來讀不同通訊協定的信箱  		與 mail 比較之下，mutt 可以直接透過網路的 pop3, imap 等通訊協定來讀信，是相當優秀的一個功能呦！ 		至少鳥哥覺得真好用！底下同樣的，先來瞧瞧可以使用的語法，然後再來看看一些練習。  `[root@www ~]# mutt [-f 信箱位置] 選項與參數： -f 信箱位置：如果是 imaps 的信箱，可以這樣：『 -f imaps://伺服器的IP 』  # 1. 直接用 dmtsai 的身份讀取本機的信箱內容： [dmtsai@www ~]$ mutt q:離開  d:刪除  u:反刪除  s:儲存  m:信件  r:回覆  g:群組  ?:求助                 ....(中間省略)....   11 O + Aug 09 root            (  12) test encode   12 O + Aug 09 root            (   1) 一封測試信   13 O + Aug 09 root            (   8) hosts   14 O + Aug 09 root            ( 604) 附件                                       ---Mutt: /var/spool/mail/dmtsai [Msgs:14 Old:11 74K]---(date/date)-------(all)--  # 2. 在上面的信件 14 號內容反白後，直接按下 Enter 會出現如下畫面！： i:離開  -:上一頁  <Space>:下一頁 v:顯示附件。  d:刪除  r:回覆  j:下一個 ?:求助   Date: Tue, 9 Aug 2011 15:24:34 +0800 From: root <root@www.centos.vbird> To: dmtsai@www.centos.vbird Subject: 附件 User-Agent: Mutt/1.5.20 (2009-12-10)  [-- 附件 #1 --] [-- 種類：textplain，編碼：8bit，大小：0.1K --]  不過是個附件測試！          <==信件的內文部分   [-- 附件 #2: passwd --]     <==說明信件的附件夾帶部分 [-- 種類：applicationoctet-stream，編碼：base64，大小：41K --]  [-- application/octet-stream 尚未支援 （按 'v' 來顯示這部份） --]  -O +- 14/14: root                   附件                                -- (all)  # 3. 在上面畫面按下 v 後，會出現相關的附件資料： q:離開  s:儲存  |:管線  p:顯示  ?:求助   I     1 <no description>                        [text/plain, 8bit, utf-8, 0.1K]   A     2 passwd                                [applica/octet-stre, base64, 41K] # 反白處按下 s 就能夠儲存附加檔案囉！ `  		最後離開時，一直按下 q ，然後參考出現的資訊來處理即可這就是本機信件的收信方式！非常簡單！ 		附加檔案的儲存方面也很容易，真是非常開心啊！那如果是外部信箱呢？舉例來說，我用 root 的身份去收 dmtsai 		的 imaps 信件，會是怎樣的情況呢？  `# 1. 在伺服器端必須要讓 mail 這個群組能夠使用 dmtsai 的家目錄，所以要這樣： [dmtsai@www ~]$ chmod a+x ~  # 2. 開始在用戶端登入 imaps 伺服器取得 dmtsai 的新郵件與郵件資料夾 [root@www ~]# mutt -f imaps://www.centos.vbird q:離開  ?:求助                                                             這個驗証屬於：    www.centos.vbird  dmtsai@www.centos.vbird    KSU    DIC    Tainan  Taiwan  TW  這個驗証的派發者：    www.centos.vbird  dmtsai@www.centos.vbird    KSU    DIC    Tainan  Taiwan  TW  這個驗証有效    由 Tue, 9 Aug 2011 06:45:32 UTC      至 Wed, 8 Aug 2012 06:45:32 UTC SHA1 Fingerprint: E86B 5364 2371 CD28 735C 9018 533F 4BC0 9166 FD03 MD5 Fingerprint: 54F5 CA4E 86E1 63CD 25A9 707E B76F 5B52  -- Mutt: SSL Certificate check (certificate 1 of 1 in chain)               (1)不接受，(2)只是這次接受，(3)永遠接受 <==這裡要填寫 2 或 3 才行！ 在 www.centos.vbird 的使用者名稱：dmtsai dmtsai@www.centos.vbird 的密碼： `  		最終在密碼設定正確後，你就會看到剛剛我們所看到的信件了！不過要注意的是，如果你的用戶家目錄在非正規目錄， 		那麼可能會出現 SELinux 的錯誤，這時就得要重新修訂一下你的 SELinux 安全本文的類型囉！ 		如此一來，我們就直接以文字模式來取得網路郵件信箱！器的進階設定   	時至今日，郵件攻擊主要的問題已經不是病毒與木馬了，大多數的垃圾郵件多是釣魚以及色情廣告。 	網路釣魚的問題在於使用者的莫名好奇心以及較糟糕的操作習慣，這部份很難處理。色情廣告則是防不勝防，你想出一個過濾機制， 	他就使用另一個機制來丟你！用嚴格的過濾機制嗎？又可能將正常的信件抵擋掉，真是要命啊！所以，還是請用戶直接刪除比較好。 	因此，在這一個小節當中，關於收信的過濾機制方面，鳥哥移除了前一版介紹的病毒掃瞄以及自動學習廣告機制了。 	如果你還是有相關的需要，可能得要自行查查相關的官方網站囉！不好意思啦！  	另外，底下主要針對 postfix 的郵件收下過濾處理，以及重新發送的 Relay 過程進行介紹。這兩個過程在 postfix 	的設定中，主要有幾個重要的項目管理：  	 	smtpd_recipient_restrictions：recipient  	是收件者的意思，這個設定值主要在管理『由本機所收下的信件』的功能，因此大部分的設定都是在進行郵件過濾以及是否為可信任郵件的意思。 	來源可以是 MTA 或 MUA 的意思；   	smtpd_client_restrictions：client 是用戶端的意思，因此主要在管理用戶端的來源是否可信任。 	可以將非正規的 mail server 來信拒絕掉的！來源當然就是 MUA 囉；   	smtpd_sender_restrictions：sender 是寄件人的意思，可以針對信件來源 (對方郵件伺服器)  	來進行分析過濾的動作。來源理論上就是 MTA 啦！ 	   	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.1 郵件過濾一：用 postgrey 進行非正規  	mail server 的垃圾信抵擋  	 		早期的廣告信很多都是藉由僵屍電腦 (已經被當作跳板但管理員卻沒有發現或沒有處理的主機) 來發送的， 		這些僵屍電腦所發送的信件有個很明顯的特色，就是『他只會嘗試傳送該封電子郵件一次， 		不論有無成功，該封信就算發出去了，故該信件將被移出佇列中。』 		不過，合法的 mail server 運作流程就如 [22.2.8](http://linux.vbird.org/linux_server/0380mail.php#postfix_mailq) 		分析的一般，在郵件無法順利寄出時該郵件會暫時放置到佇列中一段時間， 		並一直嘗試將信件寄出的動作，預設直到五天後若還是無法寄出才會將信件退回。  		根據這個合法與非法的郵件伺服器運作流程而發展出一套所謂的曙光 (postgrey) 軟體， 		你可以參考底下的幾個說明來瞭解這個軟體：  		 		<http://isg.ee.ethz.ch/tools/postgrey/> 		<http://www.postfix.org/SMTPD_POLICY_README.html> 		  		基本上 postgrey 主要的功能是在記錄發信來源而已，若發信來源同一封信第一次寄來時， 		postgrey 預設會抵擋他，並且將來源位址記錄起來，在約 5 分鐘後，若該信件又傳來一次時， 		則該信件會被收下來。如此則可以杜絕非發郵件伺服器單次發送的問題喔！ ^_^！ 		但對於你確定合法的主機則可以開放所謂的『白名單 (whitelist) 』來優先通過而不抵擋。 		所以說，他主要是這樣進行的：(參考<http://projects.puremagic.com/greylisting/whitepaper.html>)  		 		確認發信來源是否在白名單中，若是則予以通過； 		確認收信者是否在白名單中，若是則予以通過； 		確定這封信是否已經被記錄起來呢？放行的依據是：  		 		若無此信件的記錄，則將發信位址記錄起來，並將信件退回； 		若有此信件的記錄，但是記錄的時間尚未超過指定的時間 (預設 5 分鐘)，則依舊退回信件； 		若有信件的記錄，且記錄時間已超過指定的時間，則予以通過； 		 		  		整個過程簡單的來說就是這樣而已。不過為了要快速的達成 postgrey 的『記錄』能力，所以資料庫系統又是不可避免的東西。 		且 postgrey 是由 perl 寫成的，你可能也需要加入很多相依的 perl 模組才行。總的來說，你需要的軟體至少要有：  		 		BerkeleyDB： 包括 db4, db4-utils, db4-devel 等軟體： 		Perl： 使用 yum install perl 即可； 		Perl 模組： perl-Net-DNS 是 CentOS 本身有提供的，其他沒有提供的可以到 		<http://rpmfind.net/>去搜尋下載。 		   		安裝流程：  		因為 CentOS 官方已經提供了一個連結可以找到所有的線上 yum 安裝方式，你可以參考：  		 		官網介紹：<http://wiki.centos.org/HowTos/postgrey> 		線上安裝軟體：<http://wiki.centos.org/AdditionalResources/Repositories/RPMForge> 		  		鳥哥假設你已經下載了 http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm 		這個軟體且放置到 /root 底下，然後這樣做：  `[root@www ~]# rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt [root@www ~]# rpm -ivh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm [root@www ~]# yum install postgrey `  		上述的動作在進行數位簽章檔案的安裝、yum 設定檔的建置，以及最終將 postgrey 透過網路安裝起來而已！ 		整個流程簡單到不行呢！最重要的是，找到適合你的 yum 設定檔軟體來安裝就是了！    		啟動與設定方式：  		因為 postgrey 是額外的一個軟體，因此我們還是得要將它視為一個服務來啟動，同時 postgrey 		是本機的 socket 服務而非網路服務，他只提供給本機的 postfix 來作為一個外掛，因此觀察的方式並不是觀察 TCP/UDP 		之類的連線喔！底下讓我們來瞧瞧啟動與觀察的過程吧！  `[root@www ~]# /etc/init.d/postgrey start [root@www ~]# chkconfig postgrey on [root@www ~]# netstat -anlp | grep postgrey Active UNIX domain sockets (servers and established) Proto RefCnt Type    State      PID/Program  Path unix  2      STREAM  LISTENING  17823/socket /var/spool/postfix/postgrey/socket `  		上表中最重要的就是那個輸出的 path 項目啦！/var/spool/postfix/postgrey/socket 是用來做為程式之間的資料交換， 		這也是我們的 postfix 要將信件交給 postgrey 處理的一個相當重要的介面！有了這個資料後，接下來我們才能夠開始修改 		postfix 的 main.cf 囉！  `[root@www ~]# vim /etc/postfix/main.cf # 1. 更改 postfix 的 main.cf 主設定檔資料： # 一般來說，smtpd_recipient_restrictions 得要手動加入才會更動預設值： smtpd_recipient_restrictions =    permit_mynetworks,               <==預設值，允許來自 mynetworks 設定值的來源    reject_unknown_sender_domain,    <==拒絕不明的來源網域 (限制來源 MTA )    reject_unknown_recipient_domain, <==拒絕不明的收件者 (限制目標 MTA)    reject_unauth_destination,       <==預設值，拒絕不信任的目標    **check_policy_service unix:/var/spool/postfix/postgrey/socket** # 重點是最後面那一行！就是指定使用 unix socket 來連接到 postgrey 之意。 # 後續我們還有一些廣告信的抵擋機制，特別建議您將這個 postgrey 的設定值寫在最後， # 因為他可以算是我們最後一個檢驗的機制喔！  # 2. 更改 postgrey 的抵擋秒數，建議將原本的 300 秒 (五分鐘) 改為 60 秒較佳： [root@www ~]# vim /etc/sysconfig/postgrey  <==預設不存在，請手動建立 OPTIONS="--unix=/var/spool/postfix/postgrey/socket --delay=60" # 重點是 --delay 要抵擋幾秒鐘，預設值為 300 秒，我們這裡改為 60 秒等待。  [root@www ~]# /etc/init.d/postfix restart [root@www ~]# /etc/init.d/postgrey restart `  		由於過往的經驗指出，等待 5 分鐘有時候會讓某些正常的 mail server 也會被拒絕好久，對於緊急的信件來說，這樣有點不妥。 		因此，CentOS 官網也建議將這個數值改小一點，例如 60 秒即可。反正，不正常的信件第一次寄就會被拒絕， 		等多久似乎也不是這麼重要了。然後，在 postfix 的設定中，預設值僅有允許本機設定 (permit_mynetworks) 以及拒絕非信任的目標 		(reject_unauth_destination)，鳥哥根據經驗，先加入拒絕寄件者 (MTA) 的不明網域以及拒絕收件者的不明網域的信件了， 		這樣也能夠減少一堆不明的廣告信件。最終才加入 postgrey 的分析。  		要注意的是，smtpd_recipient_restrictions 裡面的設定是有順序之分的！以上面的流程來說， 		只要來自信任用戶，該封信件就會被收下會轉遞，然後不明的來源與目標會被拒絕，不受信任的目標也會被拒絕， 		這些流程完畢之後，才開始正常信件的 postgrey 機制處理！這樣其實已經可以克服一堆廣告信了！ 		接下來，讓我們測試看看 postgrey 有沒有正常運作！請在外部寄一封信到本機來吧！例如寄給 dmtsai@www.centos.vbird， 		然後查一下 /var/log/maillog 的內容看看：   Aug 10 02:15:44 www postfix/smtpd[18041]: NOQUEUE: reject: RCPT from vbirdwin7[192.168.100.30]: 450 4.2.0  <dmtsai@www.centos.vbird>: Recipient address rejected: Greylisted,  see http://postgrey.schweikert.ch/help/www.centos.vbird.html; from=<dmtsai@www.centos.vbird>  to=<dmtsai@www.centos.vbird> proto=ESMTP helo=<[192.168.100.30]>   		鳥哥事先取消 permit_mynetworks 之後才開始測試，測試完畢後又將 permit_mynetworks 加回來才好！這樣才能看到上述的資料。 		這表示 postgrey 已經開始順利運作了！並且來源主機的相關記錄也已經記載在 /var/spool/postfix/postgrey/ 		目錄下囉！如此一來您的 postfix 將可以透過 postgrey 來擋掉一些莫名其妙的廣告信囉！    		設定不受管制的白名單：  		不過 postgrey 也是有缺點的，怎麼說呢？因為 postgrey 預設會先將信件退回去，所以你的信件就可能會發生延遲的問題， 		延遲的時間可能是數分鐘到數小時，端看你的 MTA 設定而定。如果你想要讓『某些信任的郵件主機不需要經過 postgrey  		的抵擋機制』時，就得要開放白名單囉！  		白名單的開啟也很簡單啊，直接編寫 /etc/postfix/postgrey_whitelist_clients 這個檔案即可。 		假設你要讓鳥哥的郵件伺服器可以自由的將信寄到你的 MTA 的話，那麼你可以在這個檔案內加入這一行：  `[root@www ~]# vim /etc/postfix/postgrey_whitelist_clients mail.vbird.idv.tw www.centos.vbird # 將主機名稱寫進去吧！  [root@www ~]# /etc/init.d/postgrey restart `  		如果你還有更多信任的 MTA 伺服器的話，將他寫入這個檔案當中！那他就可以略過 postgrey 的分析囉！ 		更進階的用法就得要靠您自己去發掘囉！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.2 郵件過濾二：關於黑名單的抵擋機制  	 		還記得 22.1.5 講到的 [Open Relay](http://linux.vbird.org/linux_server/0380mail.php#whatmail_relay) 的問題吧？你的 MTA 可千萬不能成為 Open Relay 		的狀況，否則對你的網路與『信用』影響很大喔！一般來說，只要是 Open Relay 的郵件 MTA 都會被列入黑名單當中， 		例如台灣地區的學術網路黑名單以及網際網路社會上提供的黑名單資料庫：  		 		<http://rs.edu.tw/tanet/spam.html> 		<http://cbl.abuseat.org/> 		  		既然黑名單資料庫裡面的 mail server 本身就是有問題的郵件主機，那麼當黑名單裡面的主機想要跟我的 		mail server 連線時，我當然可以『合理的懷疑該信件是有問題的！』您說是吧！ 		所以來自黑名單或者是要送至黑名單的信件最好是不要接受啦！  		您當然可以自行前往該網站將有問題的主機列表給他加入自己的郵件主機抵擋機制當中， 		不過就是不太人性化！既然網際網路社會已經提供了黑名單資料庫了，我們就可以利用這個資料庫來抵擋嘛！ 		在決定是否進行 Relay 之前，先要求我們的 postfix 前往追蹤黑名單的資料庫， 		若目標的 IP 或主機名稱是黑名單的一員，則我們就將該信件拒絕囉！  		Postfix 設定黑名單檢驗真的很簡單，你只要這樣做即可：  `[root@www ~]# vim /etc/postfix/main.cf smtpd_recipient_restrictions =    permit_mynetworks,    reject_unknown_sender_domain,    reject_unknown_recipient_domain,    reject_unauth_destination,    reject_rbl_client cbl.abuseat.org,    reject_rbl_client bl.spamcop.net,    reject_rbl_client cblless.anti-spam.org.cn,    reject_rbl_client sbl-xbl.spamhaus.org,    check_policy_service unix:/var/spool/postfix/postgrey/socket # 請注意整個設定值的順序才好！在 postgrey 之前先檢查是否為黑名單！  smtpd_client_restrictions =      check_client_access hash:/etc/postfix/access,      reject_rbl_client cbl.abuseat.org,      reject_rbl_client bl.spamcop.net,      reject_rbl_client cblless.anti-spam.org.cn,      reject_rbl_client sbl-xbl.spamhaus.org # 這個設定項目則是與用戶端有關的設定！拒絕用戶端本身就是黑名單的一員！  smtpd_sender_restrictions = reject_non_fqdn_sender,    reject_unknown_sender_domain # 此項目則在抵擋不明的送件者主機網域囉！與 DNS 有關係的哪！  [root@www ~]# /etc/init.d/postfix restart `  		上表當中的特殊字體部分『reject_rbl_client』是 postfix 內的一個設定項目，後面可以接網際網路上提供的黑名單！ 		您得要注意的是，這個黑名單資料庫可能會持續的變動，請您先以 dig 的方式檢查每個資料庫是否真的存在， 		如果存在才加以設定在您的主機上頭啊！(因為網際網路上頭很多文獻所提供的黑名單資料庫似乎已經不再持續服務的樣子！) 		    		檢查你的郵件伺服器是否在黑名單當中？  		既然黑名單資料庫所記錄的是不受歡迎的來源與目標 MTA ，那麼您的 MTA 當然最好不要在該資料庫中嘛！ 		同時這些資料庫通常也都有提供檢測的功能，所以你也可以用該功能來檢查你的主機是否『記錄有案』呢？ 		你可以這樣處理的：  		 		是否已在黑名單資料庫中：  		確認的方法很簡單，直接到『<http://cbl.abuseat.org/lookup.cgi> 』輸入您的主機名稱或者是 IP  		，就可以檢查是否已經在黑名單當中；    		是否具有 Open Relay：  		如果要測試你的主機有沒有 Open Relay ，直接到『<http://rs.edu.tw/tanet/spam.html> 』這個網頁， 		在這個網頁的最下方可以輸入你的 IP 來檢查，注意喔，不要使用別人的 email IP 吶！ 		此時該主機會發出一封 mail 的測試信看看你的 mail server 會不會主動的代轉， 		然後將結果回報給您。要注意的是，回傳的網頁可能有編碼的問題，如果出現亂碼時，請調整為 big5 編碼即可。    		如何移除：  		如果被檢查出，您的主機已經在黑名單當中，那麼請立刻將 Open Relay 的功能關閉，改善你的  		Mail Server 之後，你可能還要到各個主要的 Open Relay 網站進行移除的工作。如果是學術網路的話， 		請與您單位的管理員聯絡。至於一般常見的黑名單資料庫則通常會主動的幫您移除，只不過需要一些時間的測試就是了。 		  		總之您必須要確定你不在黑名單當中，且最好將黑名單的來源給拒絕掉！搞定！ ^_^ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.3 郵件過濾三：基礎的郵件過濾機制  	 		在整封信的傳送流程當中，用戶端若通過主機的重重限制後，最終應該可以到達郵件佇列當中。 		而由佇列當中要送出去或者是直接送到 mailbox 就得要透過 MDA 的處理。MDA 可以加掛很多機制呢！ 		尤其是他可以過濾某些特殊字眼的廣告信件或病毒信件呢！ 		MDA 可以透過分析整封信件的內容 (包括標頭以及內文) 來擷取有問題的關鍵字，然後決定這封信的『命運』說！  		咱們的 postfix 已經有內建可以分析標頭或者是內文的過濾機制了，那就是 /etc/postfix/ 目錄下的 		header_checks 以及 body_checks 這兩個檔案啊！在預設的情況下這兩個檔案不會被 postfix 使用， 		你必需要用底下的設定來啟用他：  `[root@www ~]# vim /etc/postfix/main.cf header_checks = regexp:/etc/postfix/header_checks body_checks = regexp:/etc/postfix/body_checks # 那個 regexp 代表的是『使用正規表示法』的意思啦！  [root@www ~]# touch /etc/postfix/header_checks [root@www ~]# touch /etc/postfix/body_checks [root@www ~]# /etc/init.d/postfix restart `  		接下來你必需要自行處理 header_checks 以及 body_checks 的規則設定，在設定前請您確認『 		你對於[正規表示法](http://linux.vbird.org/linux_basic/0330regularex.php)是熟悉的 		』才行！因為很多資訊都必需要透過正規表示法來處理啦！然後開始設定的依據是：  		 		只要是 # 代表該行為註解，系統或直接略過； 		在預設的規則當中，大小寫是視為相同的； 		規則的設定方法為：  			`/規則/   動作   顯示在登錄檔裡面的訊息` 		請注意，要使用兩個斜線『 / 』將規則包起來喔！舉個例子來說明：例如我想要  		(1)抵擋掉標題為 A funny game 的信件，(2)並且在登錄檔裡面顯示 drop header deny，則可以在 		header_chekcs 檔案中可以這樣寫：  			`/^Subject:.*A funny game/   DISCARD  drop header deny` 		關於動作有底下幾個動作： 		REJECT ：將該封信件退回給原發信者； 		WARN   ：將信件收下來，但是將該封信的基本資料記錄在登錄檔內； 		DISCARD：將該封信件丟棄，並不給予原發信者回應！ 		  		鳥哥自己有作一些規則的比對，只不過.....效能不好！如果您有興趣的話，可以自行下載來看看， 		不過，使用的後果請自行評估！因為每個人的環境都不一樣嘛！  		 		header: <http://linux.vbird.org/linux_server/0380mail/header_checks> 		body: <http://linux.vbird.org/linux_server/0380mail/body_checks> 		  		記得，如果你自行修改過這兩個檔案後，務必要檢查一下語法才行！  `[root@www ~]# postmap -q - regexp:/etc/postfix/body_checks \ >  < /etc/postfix/body_checks `  		如果沒有出現任何錯誤，那就表示您的設定值應該沒有問題啦！另外，你也可以使用 procmail 這個抵擋的小程式來處理。 		不過，鳥哥覺得 procmail 在大型郵件主機當中，分析的過程太過於繁雜，會消耗很多 CPU 資源，因此後來都沒有使用這玩意兒了。 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.4 非信任來源的 Relay：開放 SMTP  	身份認證  	 		在[圖 22.1-1](http://linux.vbird.org/linux_server/0380mail.php#fig22.1-1) 的流程當中，由 MUA 透過 MTA 來寄發信件時 (具有 Relay 的動作時)，理論上 MTA  		必需要開放信任用戶來源才行，這就是為啥我們必需要在 main.cf 裡頭設定 smtpd_recipient_restrictions  		那個設定項目的原因了 (mynetworks)！不過人總有不方便的時候，舉例來說，如果你的用戶端使用的是撥接制的 ADSL  		所以每次取得的 IP 都非固定，那如何讓你的用戶使用你的 MTA ？很麻煩是吧？這個時候 SMTP 認證或許有點幫助。  		什麼是 SMTP 呢？就是讓你在想要使用 MTA 的 port 25 (SMTP 協定)  		時，得要輸入帳號密碼才能夠使用的意思！既然有了這個認證的功能，於是乎，你就可以不用設定 MTA  		的信任用戶項目！舉例來說，在本章提到的環境下，你可以不用設定 mynetworks 這個設定值啊！啟動 SMTP  		認證，讓你的用戶需要輸入帳密才能 Relay 囉！那如何讓 SMTP 支援身份認證？咱們的 CentOS 已經有提供內建的認證模組，那就是  		Cyrus SASL 這個軟體的幫忙啦！  		Cyrus SASL (<http://cyrusimap.web.cmu.edu/>)  		是 Cyrus Simple Authentication and Security Layer 的縮寫，他是一個輔助的軟體。在 SMTP 認證方面，Cyrus 主要提供了  		saslauthd 這個服務來進行帳號密碼的比對動作！也就是說：當有任何人想要進行郵件轉遞功能時， 		Postfix 會聯絡 saslauthd 請其代為檢查帳號密碼，若比對通過則允許用戶端開始轉寄信件。  		好了，如果你想要使用最簡單的方式，就是直接透過 Linux 自己的帳密來進行 SMTP 認證功能，而不使用其他如 SQL  		資料庫的身份認證時，在 CentOS 當中你應該要這樣做：  		 		安裝 cyrus-sasl, cyrus-sasl-plain, cyrus-sasl-md5 等軟體； 		啟動 saslauthd 這個服務； 		設定 main.cf 讓 postfix 可以與 saslauthd 聯繫； 		用戶端必需要在寄信時設定『郵件主機認證』功能。 		  		如此一來用戶端才能夠啟動 SMTP AUTH 喔！關於軟體安裝方面，請使用 yum 直接安裝吧！不再多囉唆！底下我們由啟動  		saslauthd 這個服務開始談起吧！    		啟動 saslauthd 服務：進行 SMTP 明碼身份驗證功能  		saslauthd 是 Cyrus-SASL 提供的一個帳號密碼管理機制，他能夠進行挺多的資料庫驗證功能， 		不過這裡我們僅使用最單純簡單的明碼驗證 (PLAIN)！如果我們想要直接使用 Linux 系統上面的使用者資訊， 		也就是 /etc/passwd, /etc/shadow 所記載的帳號密碼相關資訊時，可以使用 saslauthd 提供的『 shadow 』這個機制， 		當然也能使用『 pam 』啦！更多的 saslauthd 連線至 MTA 的機制請『 man saslauthd 』來查閱吧。 		由於我們的帳密可能來自網路其他類似 NIS 伺服器，因此這裡建議可以使用 pam 模組喔！  		saslauthd 的啟動真是好簡單，首先你必需要選擇密碼管理機制，這個可以使用底下的方式處理：  `# 1. 先瞭解你的 saslauthd 有支援哪些密碼管理機制： [root@www ~]# saslauthd -v saslauthd 2.1.23 authentication mechanisms: getpwent kerberos5 pam rimap shadow ldap # 上列的特殊字體部分就是有支援的！我們要直接用 Linux 本機的使用者資訊， # 所以用 pam 即可，當然也能夠使用 shadow 啦。  # 2. 在 saslauthd 設定檔中，選定 pam 的驗證機制： [root@www ~]# vim /etc/sysconfig/saslauthd MECH=pam  <==其實這也是預設值啊！ # 這也是預設值，有的朋友喜歡單純的 shadow 機制，也可以啦！  # 3. 那就啟動吧！ [root@www ~]# /etc/init.d/saslauthd start [root@www ~]# chkconfig saslauthd on `  		之後我們必需要告知 Cyrus 這個咚咚使用來提供 SMTP 服務的程序為 saslauthd 才行，設定的方法很簡單：  `[root@www ~]# vim /etc/sasl2/smtpd.conf log_level: 3                <==登錄檔資訊等級的設定，設定 3 即可 pwcheck_method: saslauthd   <==就是選擇什麼服務來負責密碼的比對啊 mech_list: plain login      <==那麼支援的機制有哪些之意！ `  		我們可以使用 mech_list 列出特定支援的機制。而且 saslauthd  		是個很簡單的帳號密碼管理服務，你幾乎不需要進行什麼額外的設定，直接啟動他就生效了！真是好方便！ ^_^    		更改 main.cf 的設定項目：讓 postfix 支援 SMTP 身份驗證  		那我們的 postfix 該如何處理呢？其實設定真的很簡單，只要這樣做就好了：  `[root@www ~]# vim /etc/postfix/main.cf # 在本檔案最後面增加這些與 SASL 有關的設定資料： smtpd_sasl_auth_enable = yes smtpd_sasl_security_options = noanonymous broken_sasl_auth_clients = yes # 然後找到跟 relay 有關的設定項目，增加一段允許 SMTP 認證的字樣： smtpd_recipient_restrictions =      permit_mynetworks,      permit_sasl_authenticated,  <==重點在這裡！注意順序！      reject_unknown_sender_domain,      reject_unknown_recipient_domain,      reject_unauth_destination,      reject_rbl_client cbl.abuseat.org,      reject_rbl_client bl.spamcop.net,      reject_rbl_client cblless.anti-spam.org.cn,      reject_rbl_client sbl-xbl.spamhaus.org,      check_policy_service unix:/var/spool/postfix/postgrey/socket  [root@www ~]# /etc/init.d/postfix restart `  		上面關於 SASL 的各個項目的意義是這樣的：  		 		smtpd_sasl_auth_enable  		就是設定是否要啟動 sasl 認證的意思，如果設定啟動後 postfix 會主動去載入 cyrus sasl 的函式庫， 		而該函式庫會依據 /etc/sasl2/smtpd.conf 的設定來連結到正確的管理帳號與密碼的服務。    		smtpd_sasl_security_options  		由於不想要讓匿名者可以登入使用 SMTP 的 Relay 功能，於是這個項目中只要設定 noanonymous 即可。    		broken_sasl_auth_clients  		這個是針對早期非正規 MUA 的設定項目，因為早期軟體開發商在開發 MUA 時沒有參考通訊協定標準， 		所以造成在 SMTP 認證時可能會發生的一些困擾。這些有問題的 MUA 例如 MS 的 outlook express 第四版就是這樣！ 		後來的版本應該沒有這個問題。所以這個設定值你也可以不要設定！    		smtpd_recipient_restrictions  		最重要的就是這裡啦！我們的 sasl 認證可以放在第二行，在區域網路這個可信任區域的後面加以認證。 		上表的設定意義是：區域網路內的 MUA 不需要認證也能夠進行 relay ，而非區網內的其他來源才需要進行 SMTP 認證之意。 		  		設定完畢也重新啟動 postfix 之後，我們先來測試看看是否真的提供認證了？  `[root@www ~]# telnet localhost 25 Trying 127.0.0.1... Connected to localhost.localdomain (127.0.0.1). Escape character is '^]'. 220 www.centos.vbird ESMTP Postfix ehlo localhost 250-www.centos.vbird 250-PIPELINING 250-SIZE 10240000 250-VRFY 250-ETRN 250-AUTH LOGIN PLAIN    <==你得要看到這兩行才行呦！ 250-AUTH=LOGIN PLAIN 250-ENHANCEDSTATUSCODES 250-8BITMIME 250 DSN quit 221 2.0.0 Bye `   		在用戶端啟動支援 SMTP 身份驗證的功能：以 thunderbird 設定為例  		既然已經在 MTA 設定了 SMTP 身份驗證，那麼我們 MUA 當然要傳送帳號、密碼給 MTA 才能通過 SMTP 的驗證嘛！ 		所以，在 MUA 上面就得要加上一些額外的設定才行。我們依舊以 Thunderbird 來作為介紹，請打開  		thunderbird，選擇『工具』-->『帳號設定』後會出現如下畫面：  		![在 Thunderbird 軟體中設定支援 SMTP 驗證的方式](http://linux.vbird.org/linux_server/0380mail//thunderbird_5_smtp_01.gif)  		圖 22.5-1、在 Thunderbird 軟體中設定支援 SMTP 驗證的方式   		請依據上圖的箭頭號碼來指定，先選擇 (1)SMTP 寄件伺服器；，然後選擇所需要的寄件 SMTP 伺服器後，點選 (3)編輯， 		就會出現上圖中的視窗項目。選擇 (4)不安全傳輸的密碼後，在 (5)填入你要使用的帳號即可。 		如果要測試的話，記得此用戶端不要在區域網路內，否則將不會經過認證的階段，因為我們的設定以信任網域為優先嘛！  		如果一切都順利的話，那麼當用戶端以 SMTP 來驗證時，你的登錄檔應該會出現類似底下的訊息才是：  `[root@www ~]# tail -n 100 /var/log/maillog | grep PLAIN Aug 10 02:37:37 www postfix/smtpd[18655]: 01CD43712: client=vbirdwin7 [192.168.100.30], sasl_method=PLAIN, sasl_username=dmtsai `  	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.5 非固定 IP 郵件伺服器的春天： 	relayhost  	 		我們上面提到，如果你要架設一部合法的 MTA 最好還是得要申請固定的 IP 以及正確對應的反解比較恰當。 		但如果你一定要用浮動 IP 來架設你的 MTA 的話，也不是不可以啦，尤其今年 (2011) 光纖到府已經可達 50M/5Mbps  		的下載/上傳速度了！你當然可以用家庭網路來架站啊！只不過你就得要透過上層 ISP 所提供的 relay  		權限囉！這是怎麼回事啊？讓我們來看看一個實際的案例：  		![Relayhost：利用 ISP 的 MTA 進行郵件轉遞](http://linux.vbird.org/linux_server/0380mail//relayhost.gif)  		圖 22.5-2、Relayhost：利用 ISP 的 MTA 進行郵件轉遞   		當你的 MTA 要傳信件給目標 MTA 時，如果直接傳給目標 MTA，由於你的 IP 可能是非固定的，因此對方 MTA 		恐怕會把你當成是垃圾來源！那如果我們可以透過 ISP 進行轉遞呢？從上面的圖示來看，當你要傳給目標 MTA 時：  		(1)先將信件交給妳的 ISP，因為你是 ISP 的客戶，通常來信都會被 ISP 接受，因此這個時候這封信就會被你的 ISP 給 relay 出去； 		(2)被 ISP 所 relay 的信件到目標 MTA 時，對方會判斷是來自那部 ISP 的 MTA，當然是合法的 mail server， 		所以該封信件就毫無疑問的被收下囉！ ^_^  		不過想要以此架構來架設你的 MTA 仍有許多需要注意的地方：  		 		你還是得要有一個合法的主機名稱，若要省錢，可以使用 DDNS 來處理； 		你上層的 ISP 所提供的 MTA 必需要有提供你所在 IP 的 relay 權限； 		你不能使用自訂的內部 DNS 架構了，因為所有 relay 的信都會被送至 ISP 的 MTA 		  		尤其是最後一點，因為所有外送的信件全部都會被送到 ISP 處，所以像我們之前自己玩的 		centos.vbird 這種非合法的領域資料就沒用了！為什麼呢？你想想看，如果你要將信件送給 www.centos.vbird， 		但由於上述 relayhost 的功能，所以這封信會被傳到 ISP 的 MTA 來處理，但 ISP 的 MTA  		會不會認識你的 centos.vbird？這樣說，可以理解了吧？  		說是挺難的，做起來卻很簡單，只要在 main.cf 裡面加設一段資料即可。 		假設你的環境是台灣地區的 hinet 所提供的用戶，而 hinet 提供的郵件主機為 ms1.hinet.net ， 		則你可以直接這樣設定：  `[root@www ~]# vim /etc/postfix/main.cf # 加入底下這一行就對啦！注意那個中括號！ relayhost = [ms1.hinet.net]  [root@www ~]# /etc/init.d/postfix restart `  		之後你只要嘗試寄一封信出去看看，就會瞭解這封信是如何寄送的了。看一下登錄檔的內容會像這樣：  `[root@www ~]# tail -n 20 /var/log/maillog Aug 10 02:41:01 www postfix/smtp[18775]: AFCA53713: to=<qdd@mail.ksu.edu.tw>,  relay=ms1.hinet.net[168.95.4.10]:25, delay=0.34, delays=0.19/0.09/0.03/0.03,  dsn=2.0.0, status=sent (250 2.0.0 Ok: queued as F0528233811) `  		是吧！經由上層 ISP 來轉寄啦！如此一來，你的 MTA 感覺上就似乎是部合法的 MTA 囉！ 		不過，可別利用這個權限來濫發廣告信啊！因為您所透過的那個 ISP 郵件主機可是有記錄你的 IP 來源， 		如果你亂來的話，後果可是不堪設想喔！切記切記！ 	  	![小標題的圖示](http://linux.vbird.org/images/penguin-s.gif)22.5.6 其他設定小技巧  	 		除了之前談到的幾個主要的設定之外， postfix 還有提供一些不錯的設定要給大家使用的喔！ 		我們可以一個一個來來看看：    		 		單封信件與單個郵件信箱的大小限制  		在預設的情況下，postfix 可接受的單封信件最大容量為 10MBytes ，不過這個數值我們是可以更改的， 		動作很簡單：  `[root@www ~]# vim /etc/postfix/main.cf message_size_limit =   40000000 [root@www ~]# postfix reload `  		上面的單位是 bytes，所以我將單封信件可接受大小改為 40MByte 的意思啦！請按照你的環境來規定這個數值。 		而從前我們要管制 /var/spool/mail/account 大多是使用檔案系統內的 quota 來達成， 		現在的 postfix 不需要啦！可以這樣做：  `[root@www ~]# vim /etc/postfix/main.cf mailbox_size_limit = 1000000000 [root@www ~]# postfix reload `  		我給每個人 1GB 的空間啊！^_^    		 		寄件備份：SMTP 自動轉寄一份到備份匣  		收件備份我們知道可以使用 /etc/aliases 來處理的，但是如果想要送件也備份呢？利用底下的方式即可：  `[root@www ~]# vim /etc/postfix/main.cf always_bcc = some@host.name [root@www ~]# postfix reload `  		如此一來任何人寄出的信件都會複製一份給 some@host.name 那個信箱。不過，除非您的公司很重視一些商業機密， 		並且已經公告過所有同仁，否則進行這個設定值，鳥哥個人認為侵犯隱私權很嚴重！    		設定檔的權限問題：權限錯誤會不能啟動 postfix  		這部份我們以 Sendmail 官方網站的建議來說明喔！其實也適用於 postfix 的啦！ 		其中，大部分是在於『目錄與檔案權限』的設定要求上面：  		 		請確定 /etc/aliases 這個檔案的權限，僅能由系統信任的帳號來修改，通常其權限為 644 ； 		請確定 Mail server 讀取的資料庫 (多半在 /etc/mail/ 或 /etc/postfix/ 底下的 *.db 檔案)，例如  		mailertable, access, virtusertable 等等，僅能由系統信任的使用者讀取，其他一概不能讀取，通常權限為 640 ； 		系統的佇列目錄 (/var/spool/mqueue 或 /var/spool/postfix) 僅允許系統讀取，通常權限為 700 ； 		請確定 ~/.forward 這個檔案的權限也不能設定成為任何人均可查閱的權限，否則您的 e-mail 資料可能會被竊取～ 		總之，一般用戶能夠不用 ~/.forward 與 aliases 的功能，就不要使用！ 		  		不過整體的使用上還是需要身為網站管理員的您多費心！多多觀察登錄檔啊！    		備份資料：與 mail 有關的目錄是哪些？  		不管什麼時候，備份總是重要的！那麼如果我是單純的 Mail Server 而已，我需要的備份資料有哪些呢？ 		 		/etc/passwd, /etc/shadow, /etc/group 等與帳號有關的資料； 		/etc/mail, /etc/postfix/ 底下的所有檔案資料； 		/etc/aliases 等等 MTA 相關檔案； 		/home 底下的所有使用者資料； 		/var/spool/mail 底下的檔案與 /var/spool/postfix 郵件佇列檔案； 		其他如廣告軟體、病毒掃瞄軟體等等的設定與定義檔。 		   		 		錯誤檢查：查出不能啟動 postfix 的問題流程  		雖然 Mail 很方便，但是仍然會有無法將信件寄出的時候！如果您已經設定好 MTA  		了，但是總是無法將郵件寄出去，那可能是什麼問題呢？你可以這樣追蹤看看：  		 		關於硬體配備：  		例如，是否沒有驅動網卡？是否數據機出問題？是否 hub 熱當啦？是否路由器停止服務等等的！    		關於網路參數的問題：  		如果連不上 Internet ，那麼哪裡來的 Mail Server 呢？所以請先確認你的網路已經正常的啟用了！ 		關於網路的確認問題，請查閱[第六章網路偵錯](http://linux.vbird.org/linux_server/0150detect_network.php)來處理。    		關於服務的問題：  		請務必確認與 mail server 有關的埠口已經順利啟動！例如 port 25, 110, 143, 993, 995 等等，使用 netstat  		指令即可瞭解是否已經啟動該服務！    		關於防火牆的問題：  		很多時候，很多朋友使用 Red Hat 或者其他 Linux distribution 提供的防火牆設定軟體，結果忘了啟動 port 25  		與 port 110 的設定，導致無法收發信件！請特別留意這個問題喔！可以使用 iptables 來檢查是否已經啟用該  		port 呢！   		關於設定檔的問題：  		在啟動 postfix 或者是 sendmail 之後，在登錄檔當中仔細看看有無錯誤訊息發生？ 		通常如果設定資料不對，在登錄檔當中都會有記載錯誤的地方。    		其他檔案的設定問題：  		(1)如果發現只有某個 domain 可以收信，其他的同一主機的 domain 無法收信，需要檢查 $mydestination 的設定值才行； 		(2)如果發現郵件被擋下來了！而且老是顯示 reject 的字樣，那麼可能被 access 擋住了； 		(3)如果發現郵件佇列 (mailq) 存在很多的郵件，可能是 DNS 死掉了，請檢查 /etc/resolv.conf 的設定是否正確！ 		    		其他可能的問題：  		最常發生的就是認證的問題了！這是由於使用者沒有在 MUA 上面設定『我的郵件需要認證』的選項啦！ 		請叫你的用戶趕緊勾選吧！    		還是不知道問題的解決方案：  		如果還是查不出問題的話，那麼請務必檢查您的 /var/log/maillog (有的時候是 /var/log/mail ，這個要看  		/etc/syslog.conf 的設定)，當你寄出一封信的時候，例如 dmtsai 寄給 bird2@www.centos.vbird 時，那麼  		maillog 檔案裡面會顯示出兩行，一行為 from dmtsai 一行為 to bird2@www.centos.vbird， 		也就是『我由哪裡收到信，而這封信會寄到哪裡去！』的意思，由這兩行就可以瞭解問題了！尤其是 to  		的那一行，裡面包含了相當多的有用資訊，包括郵件無法傳送的錯誤原因的紀錄！ |      |
|      |                                                              |      |





# Postfix For Server Process Reporting[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#using-postfix-for-server-process-reporting)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#prerequisites)

- Complete comfort operating from the command line on a Rocky Linux server
- Familiarity with an editor of your choice (this document uses the *vi* editor, but you can substitute in your favorite editor)
- An understanding of DNS (the Domain Name System) and host names
- The ability to assign variables in a bash script
- Knowledge of what the *tail*, *more*, *grep*, and *date* commands do

## Introduction[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#introduction)

Many Rocky Linux server administrators write scripts to perform  specific tasks, like backups or file synchronization, and many of these  scripts generate logs that have useful and sometimes very important  information. Just having the logs, though, is not enough. If a process  fails and logs that failure, but the busy administrator does not review  the log, then a catastrophe could be in the making.

This document shows you how to use the *postfix* MTA (mail  transfer agent) to grab log details from a particular process, and send  them to you via email. It also touches on date formats in logs, and  helps you identify which format you need to use in the reporting  procedure.

Keep in mind, though, that this is just the tip of the iceberg as far as what can be done with reporting via postfix. Please note, too, that  it is always a good security move to limit running processes to only  those that you will need all the time.

This document shows you how to enable postfix only for the reporting you need it to do, and then shut it down again.

## Postfix Defined[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#postfix-defined)

postfix is a server daemon used for sending email. It is more secure  and simpler than sendmail, another MTA that was the default go-to MTA  for years. It can be used as part of a full-featured mail server.

## Installing postfix[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#installing-postfix)

Aside from postfix, we will need *mailx* for testing our  ability to send emails. To install both, and any dependencies required,  enter the following on the Rocky Linux server command line:

```
dnf install postfix mailx
```

## Testing And Configuring Postfix[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#testing-and-configuring-postfix)

### Testing Mail First[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#testing-mail-first)

Before we configure postfix, we need to find out how mail will look  when it leaves the server, because we will probably want to change this. To do this, start postfix:

```
systemctl start postfix
```

Then test it using mail command that is installed with mailx:

```
mail -s "Testing from server" myname@mydomain.com
```

This will bring up a blank line. Simply type your testing message in here:

```
testing from the server
```

Now hit enter, and enter a single period:

```
.
```

The system will respond with:

```
EOT
```

Our purpose for doing this is to check to see how our mail looks to  the outside world, which we can get a feel for from the maillog that  goes active with the starting of postfix.

Use this command to see the output of the log file:

```
tail /var/log/maillog
```

You should see something like this, although the log file may have different domains for the email address, etc:



```
Mar  4 16:51:40 hedgehogct postfix/postfix-script[735]: starting the Postfix mail system
Mar  4 16:51:40 hedgehogct postfix/master[737]: daemon started -- version 3.3.1, configuration /etc/postfix
Mar  4 16:52:04 hedgehogct postfix/pickup[738]: C9D42EC0ADD: uid=0 from=<root>
Mar  4 16:52:04 hedgehogct postfix/cleanup[743]: C9D42EC0ADD: message-id=<20210304165204.C9D42EC0ADD@somehost.localdomain>
Mar  4 16:52:04 hedgehogct postfix/qmgr[739]: C9D42EC0ADD: from=<root@somehost.localdomain>, size=457, nrcpt=1 (queue active)
Mar  4 16:52:05 hedgehogct postfix/smtp[745]: connect to gmail-smtp-in.l.google.com[2607:f8b0:4001:c03::1a]:25: Network is unreachable
Mar  4 16:52:06 hedgehogct postfix/smtp[745]: C9D42EC0ADD: to=<myname@mydomain.com>, relay=gmail-smtp-in.l.google.com[172.217.212.26]
:25, delay=1.4, delays=0.02/0.02/0.99/0.32, dsn=2.0.0, status=sent (250 2.0.0 OK  1614876726 z8si17418573ilq.142 - gsmtp)
Mar  4 16:52:06 hedgehogct postfix/qmgr[739]: C9D42EC0ADD: removed
```

The "somehost.localdomain" shows us that we need to make some changes, so stop the postfix daemon first:



```
systemctl stop postfix
```

## Configuring Postfix[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#configuring-postfix)

Since we aren't setting up a complete, fully functional mail server,  the configuration options that we will be using are not as extensive.  The first thing we need to do is to modify the *main.cf* file (literally the main configuration file for postfix), so let's make a backup first:

```
cp /etc/postifix/main.cf /etc/postfix/main.cf.bak
```

Then edit it:

```
vi /etc/postfix/main.cf
```

In our example, our server name is going to be "bruno" and our domain name is going to be "ourdomain.com". Find the line in the file:

```
#myhostname = host.domain.tld
```

You can either remove the remark (#) or you can add a new line under this line. Based on our example, the line would read:

```
myhostname = bruno.ourdomain.com
```

Next, find the line for the domain name:

```
#mydomain = domain.tld
```

Either remove the remark and change it, or add a new line:

```
mydomain = ourdomain.com
```

Finally, go to the bottom of the file and add this line:

```
smtp_generic_maps = hash:/etc/postfix/generic
```

Save your changes (in vi, that will be `Shift : wq!`) and exit the file.

Before we continue editing the generic file, we need to see how email will look. Specifically, we want to create the "generic" file that we  referenced in the *main.cf* file above:

```
vi /etc/postfix/generic
```

This file tells postfix how any email coming from this server should  look. Remember our test email and the log file? This is where we fix all of that:



```
root@somehost.localdomain       root@bruno.ourdomain.com
@somehost.localdomain           root@bruno.ourdomain.com
```

Now we need to tell postfix to use all of our changes. This is done with the postmap command:



```
postmap /etc/postfix/generic
```

Now start postfix and test your email again using the same procedure  as above. You should now see that all of the "localdomain" instances  have been changed to your actual domain.

### The date Command and a Variable Called today[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#the-date-command-and-a-variable-called-today)

Not every application will use the same logging format for the date.  This means that you may have to get creative with any script you write  for reporting by date.

Let's say that you want to look at your system log as an example and  pull everything that has to do with dbus-daemon for today's date, and  email it to yourself. (It's probably not the greatest example, but it  will give you an idea of how we would do this.)

We need to use a a variable in our script that we will call "today"  and we want it to relate to output from the "date" command and format it in a specific way, so that we can get the data we need from our system  log (in */var/log/messages*). To start with, let's do some investigative work.  

First, enter the date command in the command line:

```
date
```

This should give you the default system date output, which could be something like this:

```
Thu Mar  4 18:52:28 UTC 2021
```

Now let's check our system log and see how it records information. To do this, we will use the "more" and "grep" commands:

```
more /var/log/messages | grep dbus-daemon
```

Which should give you something like this:

```
Mar  4 18:23:53 hedgehogct dbus-daemon[60]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Mar  4 18:50:41 hedgehogct dbus-daemon[60]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service' requested by ':1.1' (uid=0 pid=61 comm="/usr/sbin/NetworkManager --no-daemon " label="unconfined")
Mar  4 18:50:41 hedgehogct dbus-daemon[60]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher
```

The date and log outputs need to be exactly the same in our script,  so let's look at how to format the date using a variable called "today".

First, let's look at what we need to do with the date to get the same output as the system log. You can reference the [Linux man page](https://man7.org/linux/man-pages/man1/date.1.html) or type `man date` on the command line to pull up the date manual page to get the information you need.

What you will find is that in order to format the date the same way that */var/log/messages* has it, we need to use the %b and %e format strings, with %b being the 3 character month and %e being the space-padded day.

### The Script[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#the-script)

For our bash script, we can see that we are going to use the date  command and a variable called "today". (Keep in mind that "today" is  arbitrary. You could call this variable "late_for_dinner" if you  wanted!). We will call our script in this example, test.sh and place it  in */usr/local/sbin*:

```
vi /usr/local/sbin/test.sh
```

Let's start with, well, the beginning of our script. Note that even  though the comment in our file says we are sending these messages to  email, for now, we are just sending them to a standard log output so  that we can verify that they are correct.

Also, in our first attempt, we are grabbing all of the messages for  the current date, not just the dbus-daemon messages. We will deal with  that shortly.

Another thing to be aware of is that the grep command will return the filename in the output, which we don't want in this case, so we have  added the "-h" option to grep to remove the prefix of the filename. In  addition, once the variable "today" is set, we need to look for the  entire variable as a string, so we need it all in quotes:

```
#!/bin/bash

# set the date string to match /var/log/messages
today=`date +"%b %e"`

# grab the dbus-daemon messages and send them to email
grep -h "$today" /var/log/messages
```

That's it for now, so save your changes and then make the script executable:

```
chmod +x /usr/local/sbin/test.sh
```

And then let's test it:

```
/usr/local/sbin/test.sh
```

If all works correctly, you should get a long list of all of the  messages in /var/log/messages from today, including but not limited to  the dbus-daemon messages.  If so, then the next step is to limit the  messages to the dbus-daemon messages. So let's modify our script again:

```
vi /usr/local/sbin/test.sh
#!/bin/bash

# set the date string to match /var/log/messages
today=`date +"%b %e"`

# grab the dbus-daemon messages and send them to email
grep -h "$today" /var/log/messages | grep dbus-daemon
```

Running the script again, should get you only the dbus-daemon  messages and only the ones that occurred today (whenever you're  following this guide).

There's one final step, however. Remember, we need to get this  emailed to the administrator for review. Also, because we are only using *postfix* on this server for reporting, we don't want to leave  the service running, so we will start it at the beginning of the script  and then stop it at the end. We'll introduce the *sleep* command here to pause for 20 seconds to make sure that the email has been sent before shutting *postfix* down again.  This final edit, adds the stop, start, and sleep issues  just discussed, and also pipes the content to the administrator's email.

```
vi /usr/local/sbin/test.sh
```

And modify the script:

```
#!/bin/bash

# start postfix
/usr/bin/systemctl start postfix

# set the date string to match /var/log/messages
today=`date +"%b %e"`

# grab the dbus-daemon messages and send them to email
grep -h "$today" /var/log/messages | grep dbus-daemon | mail -s "dbus-daemon messages for today" myname@mydomain.com

# make sure the email has finished before continuing
sleep 20

# stop postfix
/usr/bin/systemctl stop postfix
```

Run the script again, and you should now have an email from the server with the dbus-daemon message.

You can now use [a crontab](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/) to schedule this to run at a specific time.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/#conclusion)

Using postfix can help you keep track of process logs that you want  to monitor. You can use it along with bash scripting to gain a firm  grasp of your system processes and be informed if there is trouble.