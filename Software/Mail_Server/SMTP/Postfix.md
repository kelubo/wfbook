# Postfix

## 术语

**MTA：** (Mail Transfer Agent) 邮件传输代理，基于 SMTP 协议（简单邮件传输协议）的服务端，比如 Postfix、Exim、Sendmail 等。SMTP 服务端彼此之间进行相互通信。  
**MUA：** (Mail User Agent) 邮件用户代理，本地的邮件客户端，例如 : Evolution、KMail、Claws Mail 或者 Thunderbird。  
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


下面开始用Postfix搭建Linux下的邮件服务器。目标服务器是RedHat Enterprise Linux 4，首先需要停止Sendmail：

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
