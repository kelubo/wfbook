# OpenSSH

[TOC]

## 概述

OpenSSH(Open Secure Shell,开放安全Shell)

## 安装

```bash
# CentOS
yum install openssh-server openssh openssh-clients openssh-askpass
systemctl start sshd
systemctl enable sshd
```

## SSH 公钥和私钥

### 生成密钥的过程

```bash
ssh-keygen -t rsa
```

将显示以下内容：

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
```

按 Enter 键表示保存在默认位置。接下来，系统将显示：

```bash
Enter passphrase (empty for no passphrase):
```

只需按 Enter 键。最后，系统将要求您重新输入密码：

```bash
Enter same passphrase again:
```

最后再按一次 Enter 键。

现在，.ssh 目录中应该有一个 RSA 类型的公钥和私钥对：

```bash
ls -a .ssh/
.  ..  id_rsa  id_rsa.pub
```

需要将公钥（id_rsa.pub）发送到将要访问的每台计算机上。在执行此操作前，需要确保可以通过 SSH 连接到服务器。

可以使用 DNS 名称或 IP 地址通过 SSH 访问它们。对于每台服务器，尝试以 SSH 登入，并为每台计算机打开终端窗口：

```bash
ssh -l root web.ourourdomain.com
```

假设顺利登录到计算机上，那么下一步就是将公钥发送到每个服务器：

```bash
scp .ssh/id_rsa.pub root@web.ourourdomain.com:/root/
```

对每台计算机重复此步骤。

在每个打开的终端窗口中，输入以下命令，您应该看到 *id_rsa.pub*：

```bash
ls -a | grep id_rsa.pub
```

如果正确，现在准备在每台服务器的 *.ssh* 目录中创建或添加 *authorized_keys* 文件。在每台服务器上，输入以下命令：

```bash
ls -a .ssh
```

**重要！请务必仔细阅读以下内容。如果您不确定是否会破坏某些内容，那么在继续之前，请在每台计算机上创建 authorized_keys（如果存在）的备份副本。**

如果没有列出 *authorized_keys* 文件，那么通过在 */root* 目录中输入以下命令来创建它：

```
cat id_rsa.pub > .ssh/authorized_keys
```

如果 *authorized_keys* 已存在，那么只需要将新的公钥附加到已存在的公钥上：

```
cat id_rsa.pub >> .ssh/authorized_keys
```

将密钥添加到 *authorized_keys* 或创建的 *authorized_keys* 文件后，请再次尝试从 Rocky Linux 工作站通过 SSH 连接到服务器。此时将没有提示您输入密码。

确认无需密码即可进行 SSH 登录后，请从每台计算机的 */root* 目录中删除 id_rsa.pub 文件。

```
rm id_rsa.pub
```

### 目录和 authorized_keys 安全

在每台目标计算机上，确保应用了以下权限：

```
chmod 700 .ssh/` `chmod 600 .ssh/authorized_keys
```

## 服务器

**/etc/ssh/sshd_config** 

```bash
#	$OpenBSD: sshd_config,v 1.100 2016/08/15 12:32:04 naddy Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
# 默认端口22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
# 设定sshd服务端监听的IP地址

#Hostkey /etc/ssh/ssh_host_key
HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

#ServerKeyBits 1024
# 设置服务器密钥的位数。最小值为512，默认值为1024。

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH

#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
# 设置如果用户不能成功登录，在切断连接之前，服务器需要等待的时间。
#PermitRootLogin yes
# 是否允许root用户直接登录
#StrictModes yes
# 设置在接收登录请求前是否检查用户主目录和rhosts文件的权限和所有权。建议开启。
#MaxAuthTries 6
# 最大密码尝试次数
#MaxSessions 10
# 最大终端数量

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
# 设置是否在进行RhostsRSAAuthentication安全认证的时候忽略用户的~/.ssh/known_hosts。
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
# 设置RhostsRSA验证和Host-based验证的时候是否使用.rhosts和.shosts文件。
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PermitEmptyPasswords no
# 禁止使用空密码登录


# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# and ChallengeResponseAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Red Hat Enterprise Linux and may cause several
# problems.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
# 是否在用户登录的时候显示/etc/motd文件中的信息。
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation sandbox
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
#UseDNS yes
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

UseDNS no
AddressFamily inet
# 在记录来自sshd的消息时，是否给出设备代码。
SyslogFacility AUTHPRIV
PermitRootLogin yes
PasswordAuthentication no
# 不使用密码验证
```

## 客户端
查看版本号

```bash
ssh -v
```



## 安全加固
1. 强化密码登录

   使用一个密码生成工具，例如 pwgen。pwgen 有几个选项，最有用的就是密码长度的选项（例如，pwgen 12 产生一个12位字符的密码）。 
   不要重复使用密码。

2. 为 SSH 服务开启一个非默认的监听端口。  
3. 使用 Fail2ban 来动态保护服务器，使服务器免于被暴力攻击。  
4. 使用不常用的用户名。绝不能让 root 可以远程登录，并避免用户名为“admin”。



2.解决 Too Many Authentication Failures 报错

在（客户端的） ~/.ssh/config 文件设置强制密码登录。如果这个文件不存在，首先创个 ~/.ssh/ 目录。

    $ mkdir ~/.ssh
    $ chmod 700 ~/.ssh

然后在一个文本编辑器创建 ~/.ssh/confg 文件，输入以下行，使用你自己的远程域名替换 HostName。

    HostName remote.site.com
    PubkeyAuthentication=no

（注：这种错误发生在使用一台 Linux 机器使用 ssh 登录另外一台服务器时，你的 .ssh 目录中存储了过多的私钥文件，而 ssh 客户端在你没有指定 -i 选项时，会默认逐一尝试使用这些私钥来登录远程服务器后才会提示密码登录，如果这些私钥并不能匹配远程主机，显然会触发这样的报错，甚至拒绝连接。因此本条是通过禁用本地私钥的方式来强制使用密码登录——显然这并不可取，如果你确实要避免用私钥登录，那你应该用 -o PubkeyAuthentication=no 选项登录。显然这条和下两条是互相矛盾的，所以请无视本条即可。）

## 使用公钥认证

公钥认证比密码登录安全多了，因为它不受暴力密码攻击的影响。可以给你的私钥加上密码来增加一些强化保护规则。

使用 RSA 密钥对管理多个用户是一种好的方法。当一个用户离开了，只要从服务器删了他的公钥就能取消他的登录。

以下例子创建一个新的 3072 位长度的密钥对，它比默认的 2048 位更安全，而且为它起一个独一无二的名字。

```bash
ssh-keygen -t rsa -b 3072 -f keyname
```

创建两个新的密钥, id_mailserver 和 id_mailserver.pub，id_mailserver 是私钥。用 ssh-copy-id 命令安全地复制公钥到远程服务器。

```bash
ssh-copy-id -i  id_rsa.pub user@remoteserver

ssh-keyscan remoteserver >> ~/.ssh/known_hosts
#不提示保存密钥
```

ssh-copy-id 会确保你不会无意间复制了你的私钥。

```bash
ssh 'user@remoteserver'
```

取消密码登录

设置远程服务器的 /etc/sshd_config 文件。

```bash
sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
# 禁用密码登录

systemctl restart sshd
```



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

```bash


sed -i "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
# 强制使用ssh v2

systemctl restart sshd
```

