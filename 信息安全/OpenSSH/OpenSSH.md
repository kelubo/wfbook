# OpenSSH
## 安全加固
1.强化密码登录  

使用一个密码生成工具，例如 pwgen。pwgen 有几个选项，最有用的就是密码长度的选项（例如，pwgen 12 产生一个12位字符的密码）。  
不要重复使用密码。  
为 SSH 服务开启一个非默认的监听端口。  
使用 Fail2ban 来动态保护服务器，使服务器免于被暴力攻击。  
使用不常用的用户名。绝不能让 root 可以远程登录，并避免用户名为“admin”。

2.解决 Too Many Authentication Failures 报错

在（客户端的） ~/.ssh/config 文件设置强制密码登录。如果这个文件不存在，首先创个 ~/.ssh/ 目录。

    $ mkdir ~/.ssh
    $ chmod 700 ~/.ssh

然后在一个文本编辑器创建 ~/.ssh/confg 文件，输入以下行，使用你自己的远程域名替换 HostName。

    HostName remote.site.com
    PubkeyAuthentication=no

（注：这种错误发生在使用一台 Linux 机器使用 ssh 登录另外一台服务器时，你的 .ssh 目录中存储了过多的私钥文件，而 ssh 客户端在你没有指定 -i 选项时，会默认逐一尝试使用这些私钥来登录远程服务器后才会提示密码登录，如果这些私钥并不能匹配远程主机，显然会触发这样的报错，甚至拒绝连接。因此本条是通过禁用本地私钥的方式来强制使用密码登录——显然这并不可取，如果你确实要避免用私钥登录，那你应该用 -o PubkeyAuthentication=no 选项登录。显然这条和下两条是互相矛盾的，所以请无视本条即可。）

3.使用公钥认证

公钥认证比密码登录安全多了，因为它不受暴力密码攻击的影响，但是并不方便因为它依赖于 RSA 密钥对。首先，你要创建一个公钥/私钥对。下一步，私钥放于你的客户端电脑，并且复制公钥到你想登录的远程服务器。你只能从拥有私钥的电脑登录才能登录到远程服务器。你的私钥就和你的家门钥匙一样敏感；任何人获取到了私钥就可以获取你的账号。你可以给你的私钥加上密码来增加一些强化保护规则。

使用 RSA 密钥对管理多个用户是一种好的方法。当一个用户离开了，只要从服务器删了他的公钥就能取消他的登录。

以下例子创建一个新的 3072 位长度的密钥对，它比默认的 2048 位更安全，而且为它起一个独一无二的名字，这样你就可以知道它属于哪个服务器。

    $ ssh-keygen -t rsa -b 3072 -f id_mailserver

以下创建两个新的密钥, id_mailserver 和 id_mailserver.pub，id_mailserver 是你的私钥--不要传播它！现在用 ssh-copy-id 命令安全地复制你的公钥到你的远程服务器。你必须确保在远程服务器上有可用的 SSH 登录方式。

    $ ssh-copy-id -i  id_rsa.pub user@remoteserver
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    user@remoteserver's password:
    Number of key(s) added: 1
    Now try logging into the machine, with:   "ssh 'user@remoteserver'"
    and check to make sure that only the key(s) you wanted were added.

ssh-copy-id 会确保你不会无意间复制了你的私钥。从上述输出中复制登录命令，记得带上其中的单引号，以测试你的新的密钥登录。

    $ ssh 'user@remoteserver'

它将用你的新密钥登录，如果你为你的私钥设置了密码，它会提示你输入。

4.取消密码登录

一旦你已经测试并且验证了你的公钥可以登录，就可以取消密码登录，这样你的远程服务器就不会被暴力密码攻击。如下设置你的远程服务器的 /etc/sshd_config 文件。

    PasswordAuthentication no

然后重启服务器上的 SSH 守护进程。

5.设置别名 -- 这很快捷而且很有 B 格

你可以为你的远程登录设置常用的别名，来替代登录时输入的命令，例如 ssh -u username -p 2222 remote.site.with.long-name。你可以使用 ssh remote1。你的客户端机器上的 ~/.ssh/config 文件可以参照如下设置

    Host remote1
    HostName remote.site.with.long-name
    Port 2222
    User username
    PubkeyAuthentication no

如果你正在使用公钥登录，可以参照这个：

    Host remote1
    HostName remote.site.with.long-name
    Port 2222
    User username
    IdentityFile  ~/.ssh/id_remoteserver


设置 SSH 免密码登录

作为系统管理员，你计划在 Linux 上使用 OpenSSH，完成日常工作的自动化，比如文件传输、备份数据库转储文件到另一台服务器等。为实现该目标，你需要从主机 A 能自动登录到主机 B。自动登录也就是说，要在 shell 脚本中使用ssh，而无需要输入任何密码。

    本文会告诉你怎样在 CentOS/RHEL 上设置 SSH 免密码登录。自动登录配置好以后，你可以通过它使用 SSH （Secure Shell）和安全复制 （SCP）来移动文件。

    SSH 是开源的，是用于远程登录的最为可靠的网络协议。系统管理员用它来执行命令，以及通过 SCP 协议在网络上向另一台电脑传输文件。

    通过配置 SSH 免密码登录，你可以享受到如下的便利：

        用脚本实现日常工作的自动化。
        增强 Linux 服务器的安全性。这是防范虚拟专用服务器（VPS）遭受暴力破解攻击的一个推荐的方法，SSH 密钥单凭暴力破解是几乎不可攻破的。

    什么是 ssh-keygen

    ssh-keygen 是一个用来生成、创建和管理 SSH 认证用的公私钥的工具。通过 ssh-keygen 命令，用户可以创建支持SSH1 和 SSH2 两个协议的密钥。ssh-keygen 为 SSH1 协议创建 RSA 密钥，SSH2 则可以是 RSA 或 DSA。
    什么是 ssh-copy-id

    ssh-copy-id 是用来将本地公钥拷贝到远程的 authorized_keys 文件的脚本命令，它还会将身份标识文件追加到远程机器的 ~/.ssh/authorized_keys 文件中，并给远程主机的用户主目录适当的的权限。
    SSH 密钥

    SSH 密钥为登录 Linux 服务器提供了更好且安全的机制。运行 ssh-keygen 后，将会生成公私密钥对。你可以将公钥放置到任意服务器，从持有私钥的客户端连接到服务器的时，会用它来解锁。两者匹配时，系统无需密码就能解除锁定。
    在 CentOS 和 RHEL 上设置免密码登录 SSH

    以下步骤在 CentOS 5/6/7、RHEL 5/6/7 和 Oracle Linux 6/7 上测试通过。

    节点1 : 192.168.0.9 节点2 : 192.168.l.10
    步骤1 :

    测试节点1到节点2的连接和访问：

        [root@node1 ~]# ssh root@192.168.0.10
        The authenticity of host '192.168.0.10 (192.168.0.10)' can't be established.
        RSA key fingerprint is 6d:8f:63:9b:3b:63:e1:72:b3:06:a4:e4:f4:37:21:42.
        Are you sure you want to continue connecting (yes/no)? yes
        Warning: Permanently added '192.168.0.10' (RSA) to the list of known hosts.
        root@192.168.0.10's password:
        Last login: Thu Dec 10 22:04:55 2015 from 192.168.0.1
        [root@node2 ~]#

    步骤二：

    使用 ssh-key-gen 命令生成公钥和私钥，这里要注意的是可以对私钥进行加密保护以增强安全性。

        [root@node1 ~]# ssh-keygen
        Generating public/private rsa key pair.
        Enter file in which to save the key (/root/.ssh/id_rsa):
        Enter passphrase (empty for no passphrase):
        Enter same passphrase again:
        Your identification has been saved in /root/.ssh/id_rsa.
        Your public key has been saved in /root/.ssh/id_rsa.pub.
        The key fingerprint is:
        b4:51:7e:1e:52:61:cd:fb:b2:98:4b:ad:a1:8b:31:6d root@node1.ehowstuff.local
        The key's randomart image is:
        +--[ RSA 2048]----+
        |          . ++   |
        |         o o  o  |
        |        o o o  . |
        |       . o + ..  |
        |        S   .  . |
        |         .   .. .|
        |        o E oo.o |
        |         = ooo.  |
        |        . o.o.   |
        +-----------------+

    步骤三：

    用 ssh-copy-id 命令将公钥复制或上传到远程主机，并将身份标识文件追加到节点2的 ~/.ssh/authorized_keys 中：

        [root@node1 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.0.10
        root@192.168.0.10's password:
        Now try logging into the machine, with "ssh '192.168.0.10'", and check in:
        .ssh/authorized_keys
        to make sure we haven't added extra keys that you weren't expecting.

    步骤四：

    验证免密码 SSH 登录节点2：

        [root@node1 ~]# ssh root@192.168.0.10
        Last login: Sun Dec 13 14:03:20 2015 from www.ehowstuff.local
