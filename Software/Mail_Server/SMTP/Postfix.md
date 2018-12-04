# Postfix

Postfix 是由 Wietse Zweitze Venema ([http://www.porcupine.org/wietse](http://www.porcupine.org/wietse/)) 所发展的。早期的 mail server 都是使用 sendmail架設的，還真的是『僅此一家，絕無分號』！不過，Venema 博士覺得 sendmail 雖然很好用，但是畢竟不夠安全，尤其效能上面並不十分的理想，最大的困擾是...sendmail 的設定檔 sendmail.cf 真的是太難懂了！對於網管人員來說，要設定好 sendmail.cf 這個檔案，真不是人作的工作。

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

