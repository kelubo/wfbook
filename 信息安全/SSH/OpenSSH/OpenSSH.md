# OpenSSH

[TOC]

## 概述

OpenSSH 是使用 SSH 协议进行远程登录的首要连接工具。它对所有流量进行加密，以消除窃听、连接劫持和其他攻击。此外，OpenSSH 提供了一整套安全隧道功能、多种身份验证方法和复杂的配置选项。

OpenSSH 由 OpenBSD 项目的几个开发人员开发，并在 BSD 风格的许可证下提供。

OpenSSH 被纳入许多商业产品中，但这些公司中很少有公司为 OpenSSH 提供资金支持。

## 组成

OpenSSH 套件包含以下工具：

- 远程操作。
  - ssh                          远程登录程序（SSH 客户端）
  - scp                          安全的远程文件复制程序 
  - sftp                         安全的文件传输程序
- 密钥管理。
  - ssh-add                  为 `ssh-agent`添加私钥身份
  - ssh-keysign
  - ssh-keyscan          收集 SSH 公共主机密钥
  - ssh-keygen            生成、管理并转换 `ssh` 验证密钥
  - ssh-copy-id            一个在远程 SSH 服务器的 `authorized_keys` 文件中添加本地公钥的脚本
- 服务端
  - sshd                        SSH 守护进程
  - sftp-server
  - ssh-agent               用于缓存私钥的身份验证代理

## 规范文件

在 OpenSSH 中实现的 SSH2 协议由 IETF secsh 工作组标准化，并在多个 RFC 和草案中指定。The overall structure of SSH2 is described in the [architecture](https://www.ietf.org/rfc/rfc4251.txt) RFC.体系结构RFC中描述了SSH2的总体结构。它由三层组成：

- 传输层提供算法协商和密钥交换。The key exchange includes server authentication and results in a cryptographically secured connection密钥交换包括服务器身份验证和加密安全连接：它提供完整性、机密性和可选压缩。
- 用户认证层使用建立的连接并依赖于传输层提供的服务。它提供了几种用户身份验证机制。包括传统的密码认证以及公钥或基于主机的认证机制。
-  The [connection layer](https://www.ietf.org/rfc/rfc4254.txt) multiplexes many different concurrent channels over the authenticated connection and allows tunneling of login sessions and TCP-forwarding. 连接层在经过认证的连接上多路复用许多不同的并发通道，并允许登录会话的隧道和 TCP 转发。它为这些通道提供流量控制服务。Additionally, various channel-specific options can be negotiated.此外，可以协商各种渠道特定选项。

其他文件规定：

- The [interactive authentication](https://www.ietf.org/rfc/rfc4256.txt) RFC provides support for new authentication schemes like S/Key or TIS authentication.
- 交互式身份验证RFC支持新的身份验证方案，如S/Key或TIS身份验证。
- 在 [filexfer](http://www.openssh.com/txt/draft-ietf-secsh-filexfer-02.txt) 草稿中指定了 SFTP 文件传输协议。OpenSSH 实现了 SFTP 客户端和服务器。
-  A file format for public keys is specified in the [publickeyfile](http://www.openssh.com/txt/draft-ietf-secsh-publickeyfile-02.txt) draft. The command [ssh-keygen(1)](https://man.openbsd.org/ssh-keygen) can be used to convert an OpenSSH public key to this file format.
- 公钥的文件格式在公钥文件草稿中指定。命令ssh-keygen（1）可用于将OpenSSH公钥转换为此文件格式。
- [Diffie-Hellman Group Exchange](https://www.ietf.org/rfc/rfc4419.txt) 允许客户端为 Diffie-Hellman 密钥交换请求更安全的组。
- OpenSSH implemented a compression method "zlib@openssh.com" that delays    starting compression until after user authentication, to eliminate the    risk of pre-authentication attacks against the compression code. It is    described in    [draft-miller-secsh-compression-delayed-00.txt](http://www.openssh.com/txt/draft-miller-secsh-compression-delayed-00.txt).
- Open  SSH实现了一种压缩方法“zlib@openssh.com“它将开始压缩延迟到用户身份验证之后，以消除对压缩代码进行预身份验证攻击的风险。”draft-miller-secsh-compression-delayed-00.txt中对此进行了描述。
- OpenSSH implements an additional MAC (Message Authentication Code)    "umac-64@openssh.com", which has superior performance to the ones specified    in RFC 4253. [draft-miller-secsh-umac-01.txt](http://www.openssh.com/txt/draft-miller-secsh-umac-01.txt) 中对其进行了描述。
- Open SSH实现了额外的MAC（消息验证码）“umac-64@openssh.com“，其性能优于RFC 4253中规定的性能。
- The authentication agent protocol used by    [ssh-agent](https://man.openbsd.org/ssh-agent) is documented in the    [PROTOCOL.agent](https://cvsweb.openbsd.org/src/usr.bin/ssh/PROTOCOL.agent?rev=HEAD) file.
- ssh代理使用的身份验证代理协议记录在protocol.agent文件中。
- OpenSSH makes various other minor extensions to and divergences from the    standard SSH protocols. 
- OpenSSH 对标准 SSH 协议进行了各种其他次要扩展，并与标准 SSH 协议有所不同。这些记录在 [PROTOCOL](https://cvsweb.openbsd.org/src/usr.bin/ssh/PROTOCOL?rev=HEAD) 文件中。





## [ *Open***SSH**](http://www.openssh.com/) Goals

------

Our goal is simple: Since telnet and rlogin are insecure, all operating systems should ship with support for the SSH protocol included.

The SSH protocol is available in two incompatible varieties: SSH 1 and SSH 2.

The older SSH 1 protocol comes in two major sub-variants: protocol 1.3 and protocol 1.5.  Support for both has been removed from OpenSSH as of the [7.6 release](http://www.openssh.com/txt/release-7.6). Both of them used the asymmetric cryptography algorithm [RSA](https://man.openbsd.org/RSA_generate_key) (for which the USA patent has expired, allowing full use by everyone) for key negotiation and authentication, 3DES and [Blowfish](https://man.openbsd.org/blowfish) for privacy. It used a simple CRC for data integrity, which turns out to be flawed.

The second major variety of SSH is the SSH 2 protocol.  SSH 2 was invented to avoid the patent issues regarding RSA (patent issues which no longer apply, since the patent has expired), to fix the CRC data integrity problem that SSH1 has, and for a number of other technical reasons.  By requiring only the asymmetric [DSA](https://man.openbsd.org/DSA_generate_key) and [DH](https://man.openbsd.org/DH_generate_key) algorithms, protocol 2 avoids all patents. The CRC problem is also solved by using a real [HMAC](https://man.openbsd.org/HMAC) algorithm. The SSH 2 protocol supports many other choices for symmetric and asymmetric ciphers, as well as many other new features.

OpenSSH relies on the [LibreSSL](https://www.libressl.org) library for some of its cryptographic routines, AES-GCM being one example.

Continuing that trend, the OpenBSD project members who worked on OpenSSH made a push at supporting the SSH 2 protocol as well.  This work was primarily done by Markus Friedl.  Around May 4, 2000, the SSH 2 protocol support was implemented sufficiently to be usable.

打开SSH目标

我们的目标很简单：由于telnet和rlogin是不安全的，所以所有操作系统都应该提供对SSH协议的支持。

SSH协议有两种不兼容的类型：SSH 1和SSH 2。

较旧的SSH  1协议有两个主要的子变体：协议1.3和协议1.5。自7.6版本起，OpenSSH中已删除对这两种功能的支持。两人都使用非对称密码算法RSA（美国专利已过期，允许所有人充分使用）进行密钥协商和认证，3DES和Blowfish用于隐私。它使用了一个简单的CRC来保证数据的完整性，结果证明这是有缺陷的。

SSH的第二个主要种类是SSH2协议。SSH  2的发明是为了避免与RSA有关的专利问题（由于专利已过期，不再适用的专利问题），解决SSH1存在的CRC数据完整性问题，以及其他一些技术原因。由于只需要非对称DSA和DH算法，协议2避免了所有专利。CRC问题也通过使用真实的HMAC算法来解决。SSH 2协议支持对称和非对称密码的许多其他选择，以及许多其他新特性。

OpenSSH的一些加密例程依赖于LibreSSL库，AES-GCM就是一个例子。

继续这一趋势，开发OpenSSH的OpenBSD项目成员也努力支持SSH2协议。这项工作主要由马库斯·弗里德尔完成。2000年5月4日左右，SSH 2协议支持被充分实现，可以使用。



​		

现有两个 SSH 版本： 版本 1 和较新的版本 2。Red Hat Enterprise Linux 8 中的 `OpenSSH` 套件只支持 SSH 版本 2，其增强的密钥交换算法不会受到版本 1 中已知漏洞的影响。 

`OpenSSH`，作为 RHEL 核心加密子系统之一使用系统范围的加密策略。这样可确保在默认配置中禁用弱密码套件和加密算法。要调整策略，管理员必须使用 `update-crypto-policies` 命令更严格或者更松一些设置，或者手动选择不使用系统范围的加密策略。 

`OpenSSH` 套件使用两组不同的配置文件：用于客户端程序（即 `ssh`、`scp` 和 `sftp`）的配置文件，和用于服务器（`sshd` 守护进程）的配置文件。系统范围的 SSH 配置信息保存在 `/etc/ssh/` 目录中。用户特定的 SSH 配置信息保存在用户主目录中的 `~/.ssh/` 中。

Red Hat Enterprise Linux 8 包括基本的 `OpenSSH` 软件包：

* openssh
* openssh-server
* openssh-clients
* openssl-libs

主机密钥验证使用 SSH 协议的主机。主机密钥是首次安装 `OpenSSH` 时或主机第一次引导时自动生成的加密密钥。 				

**其它资源**

- 						使用 man `-k ssh 命令列出 man page`。 				
- 						[使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 				
=======
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

1. ​						要为 `/etc/ssh/sshd_config` 配置文件中的 `ListenAddress` 指令指定默认地址 `0.0.0.0`（IPv4）或 `::` （IPv6），并使用较慢的动态网络配置，将 `network-online.target` 目标单元的依赖关系添加到 `sshd.service` 单元文件中。要做到这一点，使用以下内容创建 `/etc/systemd/system/sshd.service.d/local.conf` 文件： 				

   ```none
   [Unit]
   Wants=network-online.target
   After=network-online.target
   ```

2. ​						查看 `/etc/ssh/sshd_config` 配置文件中的 `OpenSSH` 服务器设置是否满足您的情况要求。 				

3. ​						另外，还可通过编辑 `/etc/issue` 文件来更改您的 `OpenSSH` 服务器在客户端验证前显示的欢迎信息，例如： 				

   ```none
   Welcome to ssh-server.example.com
   Warning: By accessing this server, you agree to the referenced terms and conditions.
   ```

   ​						确保 `/etc/ssh/sshd_config` 中未注释掉 `Banner` 选项，其值包含 `/etc/issue` ： 				

   ```none
   # less /etc/ssh/sshd_config | grep Banner
   Banner /etc/issue
   ```

   ​						请注意：要在成功登录后改变显示的信息，您必须编辑服务器上的 `/etc/motd` 文件。详情请查看 `pam_motd` man page。 				

4. ​						重新载入 `systemd` 配置并重启 `sshd` 以应用更改： 				

   ```none
   # systemctl daemon-reload
   # systemctl restart sshd
   ```

**验证**

1. ​						检查 `sshd` 守护进程是否正在运行： 				

   ```none
   # systemctl status sshd
   ● sshd.service - OpenSSH server daemon
      Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
      Active: active (running) since Mon 2019-11-18 14:59:58 CET; 6min ago
        Docs: man:sshd(8)
              man:sshd_config(5)
    Main PID: 1149 (sshd)
       Tasks: 1 (limit: 11491)
      Memory: 1.9M
      CGroup: /system.slice/sshd.service
              └─1149 /usr/sbin/sshd -D -oCiphers=aes128-ctr,aes256-ctr,aes128-cbc,aes256-cbc -oMACs=hmac-sha2-256,>
   
   Nov 18 14:59:58 ssh-server-example.com systemd[1]: Starting OpenSSH server daemon...
   Nov 18 14:59:58 ssh-server-example.com sshd[1149]: Server listening on 0.0.0.0 port 22.
   Nov 18 14:59:58 ssh-server-example.com sshd[1149]: Server listening on :: port 22.
   Nov 18 14:59:58 ssh-server-example.com systemd[1]: Started OpenSSH server daemon.
   ```

2. ​						使用 SSH 客户端连接到 SSH 服务器。 				

   ```none
   # ssh user@ssh-server-example.com
   ECDSA key fingerprint is SHA256:dXbaS0RG/UzlTTku8GtXSz0S1++lPegSy31v3L/FAEc.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added 'ssh-server-example.com' (ECDSA) to the list of known hosts.
   
   user@ssh-server-example.com's password:
   ```



- ​						已安装 `openssh-server` 软件包。 				
- ​						`sshd` 守护进程正在服务器中运行。 				

**流程**

1. ​						在文本编辑器中打开 `/etc/ssh/sshd_config` 配置，例如： 				

   ```none
   # vi /etc/ssh/sshd_config
   ```

2. ​						将 `PasswordAuthentication` 选项改为 `no`: 				

   ```none
   PasswordAuthentication no
   ```

   ​						在新默认安装以外的系统中，检查 `PubkeyAuthentication` 没有被设置，并且将 `ChallengeResponseAuthentication` 指令设为 `no`。如果您要进行远程连接，而不使用控制台或带外访问，在禁用密码验证前测试基于密钥的登录过程。 				

3. ​						要在 NFS 挂载的主目录中使用基于密钥的验证，启用 `use_nfs_home_dirs` SELinux 布尔值： 				

   ```none
   # setsebool -P use_nfs_home_dirs 1
   ```

4. ​						重新载入 `sshd` 守护进程以应用更改： 				

   ```none
   # systemctl reload sshd
   ```

**其它资源**

- ​						`sshd(8)`, `sshd_config(5)` 和 `setsebool(8)` 手册页。 				

# 1.4. 生成 SSH 密钥对

​				使用这个流程在本地系统中生成 SSH 密钥对，并将生成的公钥复制到 `OpenSSH` 服务器中。如果正确配置了服务器，您可以在不提供任何密码的情况下登录到 `OpenSSH` 服务器。 		

重要

​					如果以 `root` 用户身份完成以下步骤，则只有 `root` 用户可以使用密钥。 			

**流程**

1. ​						为 SSH 协议的版本 2 生成 ECDSA 密钥对： 				

   ```none
   $ ssh-keygen -t ecdsa
   Generating public/private ecdsa key pair.
   Enter file in which to save the key (/home/joesec/.ssh/id_ecdsa):
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   Your identification has been saved in /home/joesec/.ssh/id_ecdsa.
   Your public key has been saved in /home/joesec/.ssh/id_ecdsa.pub.
   The key fingerprint is:
   SHA256:Q/x+qms4j7PCQ0qFd09iZEFHA+SqwBKRNaU72oZfaCI joesec@localhost.example.com
   The key's randomart image is:
   +---[ECDSA 256]---+
   |.oo..o=++        |
   |.. o .oo .       |
   |. .. o. o        |
   |....o.+...       |
   |o.oo.o +S .      |
   |.=.+.   .o       |
   |E.*+.  .  . .    |
   |.=..+ +..  o     |
   |  .  oo*+o.      |
   +----[SHA256]-----+
   ```

   ​						您还可以通过输入 `ssh-keygen -t ed25519` 命令，在 `ssh-keygen` 命令或 Ed25519 密钥对中使用 `-t rsa` 选项生成 RSA 密钥对。 				

2. ​						要将公钥复制到远程机器中： 				

   ```none
   $ ssh-copy-id joesec@ssh-server-example.com
   /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
   joesec@ssh-server-example.com's password:
   ...
   Number of key(s) added: 1
   
   Now try logging into the machine, with: "ssh 'joesec@ssh-server-example.com'" and check to make sure that only the key(s) you wanted were added.
   ```

   ​						如果您没有在会话中使用 `ssh-agent` 程序，上一个命令会复制最新修改的 `~/.ssh/id*.pub` 公钥。要指定另一个公钥文件，或在 `ssh-agent` 内存中缓存的密钥优先选择文件中的密钥，使用带有 `-i` 选项的 `ssh-copy-id` 命令。 				

注意

​					如果重新安装您的系统并希望保留之前生成的密钥对，备份 `~/.ssh/` 目录。重新安装后，将其复制到主目录中。您可以为系统中的所有用户（包括 `root` 用户）进行此操作。 			

**验证**

1. ​						在不提供任何密码的情况下登录到 OpenSSH 服务器： 				

   ```none
   $ ssh joesec@ssh-server-example.com
   Welcome message.
   ...
   Last login: Mon Nov 18 18:28:42 2019 from ::1
   ```

**其它资源**

- ​						`ssh-keygen(1)和` `ssh-copy-id(1)` man page. 				

# 1.5. 使用保存在智能卡中的 SSH 密钥

​				Red Hat Enterprise Linux 可让您使用保存在 OpenSSH 客户端智能卡中的 RSA 和 ECDSA 密钥。使用这个步骤使用智能卡而不是使用密码启用验证。 		

**先决条件**

- ​						在客户端中安装了 `opensc` 软件包，`pcscd` 服务正在运行。 				

**流程**

1. ​						列出所有由 OpenSC PKCS #11 模块提供的密钥，包括其 PKCS #11 URIs，并将输出保存到 *key.pub* 文件： 				

   ```none
   $ ssh-keygen -D pkcs11: > keys.pub
   $ ssh-keygen -D pkcs11:
   ssh-rsa AAAAB3NzaC1yc2E...KKZMzcQZzx pkcs11:id=%02;object=SIGN%20pubkey;token=SSH%20key;manufacturer=piv_II?module-path=/usr/lib64/pkcs11/opensc-pkcs11.so
   ecdsa-sha2-nistp256 AAA...J0hkYnnsM= pkcs11:id=%01;object=PIV%20AUTH%20pubkey;token=SSH%20key;manufacturer=piv_II?module-path=/usr/lib64/pkcs11/opensc-pkcs11.so
   ```

2. ​						要使用远程服务器上的智能卡（*example.com*）启用验证，将公钥传送到远程服务器。使用带有上一步中创建的 *key.pub* 的 `ssh-copy-id` 命令： 				

   ```none
   $ ssh-copy-id -f -i keys.pub username@example.com
   ```

3. ​						要使用在第 1 步的 `ssh-keygen -D` 命令输出中的 ECDSA 密钥连接到 *example.com*，您只能使用 URI 中的一个子集，它是您的密钥的唯一参考，例如： 				

   ```none
   $ ssh -i "pkcs11:id=%01?module-path=/usr/lib64/pkcs11/opensc-pkcs11.so" example.com
   Enter PIN for 'SSH key':
   [example.com] $
   ```

4. ​						您可以使用 `~/.ssh/config` 文件中的同一 URI 字符串使配置持久： 				

   ```none
   $ cat ~/.ssh/config
   IdentityFile "pkcs11:id=%01?module-path=/usr/lib64/pkcs11/opensc-pkcs11.so"
   $ ssh example.com
   Enter PIN for 'SSH key':
   [example.com] $
   ```

   ​						因为 OpenSSH 使用 `p11-kit-proxy` wrapper 和 OpenSC PKCS #11 模块注册到 PKCS#11 Kit，所以您可以简化前面的命令： 				

   ```none
   $ ssh -i "pkcs11:id=%01" example.com
   Enter PIN for 'SSH key':
   [example.com] $
   ```

​				如果您跳过 PKCS #11 URI 的 `id=` 部分，则 OpenSSH 会加载代理模块中可用的所有密钥。这可减少输入所需的数量： 		

```none
$ ssh -i pkcs11: example.com
Enter PIN for 'SSH key':
[example.com] $
```

**其它资源**

- ​						[Fedora 28：OpenSSH 中出色的智能卡支持](https://fedoramagazine.org/fedora-28-better-smart-card-support-openssh/)。 				
- ​						`p11-kit(8)`、`opensc.conf(5)`、`pcd(8)`、`ssh(1)和 ssh` `-keygen(1)` 手册页. 				

# 1.6. 使 OpenSSH 更安全

​				以下提示可帮助您在使用 OpenSSH 时提高安全性。请注意，`/etc/ssh/sshd_config` OpenSSH 配置文件的更改需要重新载入 `sshd` 守护进程才能生效： 		

```none
# systemctl reload sshd
```

重要

​					大多数安全强化配置更改降低了与不支持最新算法或密码套件的客户端的兼容性。 			

**禁用不安全的连接协议**

- ​						要使 SSH 生效，防止使用由 `OpenSSH` 套件替代的不安全连接协议。否则，用户的密码可能只会在一个会话中被 SSH 保护，可能会在以后使用 Telnet 登录时被捕获。因此，请考虑禁用不安全的协议，如 telnet、rsh、rlogin 和 ftp。 				

**启用基于密钥的身份验证并禁用基于密码的身份验证**

- ​						禁用密码验证并只允许密钥对可减少安全攻击面，还可节省用户的时间。在客户端中，使用 `ssh-keygen` 工具生成密钥对，并使用 `ssh-copy-id` 工具从 `OpenSSH` 服务器的客户端复制公钥。要在 OpenSSH 服务器中禁用基于密码的验证，请编辑 `/etc/ssh/sshd_config`，并将 `PasswordAuthentication` 选项改为 `no`: 				

  ```none
  PasswordAuthentication no
  ```

**密钥类型**

- ​						虽然 `ssh-keygen` 命令会默认生成一组 RSA 密钥，但您可以使用 `-t` 选项指定它生成 ECDSA 或者 Ed25519 密钥。ECDSA(Elliptic Curve Digital Signature  Algorithm)能够以等效的对称密钥强度比 RSA 提供更好的性能。它还会生成较短的密钥。Ed25519 公钥算法是 TWisted  Edwards 曲线的实现，其安全性也比 RSA、DSA 和 ECDSA 更快。 				

  ​						如果没有这些密钥，OpenSSH 会自动创建 RSA、ECDSA 和 Ed25519 服务器主机密钥。要在 RHEL 8 中配置主机密钥创建，使用 `sshd-keygen@.service` 实例化服务。例如，禁用自动创建 RSA 密钥类型： 				

  ```none
  # systemctl mask sshd-keygen@rsa.service
  ```

- ​						要排除 SSH 连接的特定密钥类型，注释 `/etc/ssh/sshd_config` 中的相关行，并重新载入 `sshd` 服务。例如，只允许 Ed25519 主机密钥： 				

  ```none
  # HostKey /etc/ssh/ssh_host_rsa_key
  # HostKey /etc/ssh/ssh_host_ecdsa_key
  HostKey /etc/ssh/ssh_host_ed25519_key
  ```

**非默认端口**

- ​						默认情况下，`sshd` 守护进程侦听 TCP 端口 22。更改此端口可降低系统因自动网络扫描而受到攻击的风险，并可以提高安全性。您可以使用 `/etc/ssh/sshd_config` 配置文件中的 `Port` 指令指定端口。 				

  ​						您还必须更新默认 SELinux 策略以允许使用非默认端口。要做到这一点，使用 `policycoreutils-python-utils` 软件包中的 `semanage` 工具： 				

  ```none
  # semanage port -a -t ssh_port_t -p tcp port_number
  ```

  ​						另外，更新 `firewalld` 配置： 				

  ```none
  # firewall-cmd --add-port port_number/tcp
  # firewall-cmd --runtime-to-permanent
  ```

  ​						在前面的命令中，将 *port_number* 替换为使用 `Port` 指令指定的新端口号。 				

**没有 root 登录**

- ​						如果您的特定用例不需要作为 root 用户登录，应该考虑在 `/etc/ssh/sshd_config` 文件中将 `PermitRootLogin` 配置指令设置为 `no`。通过禁止以 root 用户身份登录，管理员可以审核哪些用户在以普通用户身份登录后运行哪些特权命令，然后获得 root 权限。 				

  ​						或者，将 `PermitRootLogin` 设置为 `prohibit-password`： 				

  ```none
  PermitRootLogin prohibit-password
  ```

  ​						这强制使用基于密钥的身份验证，而不使用密码以 root 身份登录，并通过防止暴力攻击来降低风险。 				

**使用 ⁠X 安全扩展**

- ​						Red Hat Enterprise Linux 客户端中的 X 服务器不提供 X 安全性扩展。因此，当连接到带有 X11 转发的不可信 SSH 服务器时，客户端无法请求另一个安全层。大多数应用程序都无法在启用此扩展时运行。 				

  ​						默认情况下，`/etc/ssh/ssh_config.d/05-redhat.conf` 文件中的 `ForwardX 11Trusted` 选项被设置为 `yes`，且 `ssh -X remote_machine` （不信任主机）和 `ssh -Y remote_machine` （可信主机）命令之间没有区别。 				

  ​						如果您的场景根本不需要 X11 转发功能，请将 `/etc/ssh/sshd_config` 配置文件中的 `X11Forwarding` 指令设置为 `no`。 				

**限制对特定用户、组群或者域的访问**

- ​						`/etc/ssh/sshd_config` 配置文件服务器中的 `AllowUsers` 和 `AllowGroups` 指令可让您只允许某些用户、域或组连接到您的 OpenSSH 服务器。您可以组合 `AllowUsers 和 Allow` `Groups` 来更精确地限制访问，例如： 				

  ```none
  AllowUsers *@192.168.1.*,*@10.0.0.*,!*@192.168.1.2
  AllowGroups example-group
  ```

  ​						以上配置行接受来自 192.168.1.* 和 10.0.0.* 子网中所有用户的连接，但具有 192.168.1.2 地址的系统除外。所有用户都必须位于 `example-group` 组。OpenSSH 服务器拒绝所有其他连接。 				

  ​						请注意，使用允许列表（以 Allow 开头的指令）比使用 blocklists 更安全（以 Deny 开始的选项），因为 allowlists 也会阻止新的未授权用户或组。 				

**更改系统范围的加密策略**

- ​						`OpenSSH` 使用 RHEL 系统范围的加密策略，默认的系统范围的加密策略级别为当前威胁模型提供了安全设置。要使您的加密设置更严格，请更改当前的策略级别： 				

  ```none
  # update-crypto-policies --set FUTURE
  Setting system policy to FUTURE
  ```

- ​						要为您的 `OpenSSH` 服务器选择不使用系统范围的加密策略，请使用 `/etc/sysconfig/sshd` 文件中的 `CRYPTO_POLICY=` 变量取消注释这一行。更改后，您在 `/etc/ssh/sshd_config` 文件中的 `Ciphers` `、MAC` `、KexAlgoritm s 和 GSSAPIKexAlgorithms` 部分指定的值不会被覆盖。请注意，此任务在配置加密选项时需要深入了解。 				

- ​						如需更多信息，请参阅 [RHEL 8 安全强化](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/)文档中的[使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 				

**其它资源**

- ​						`sshd_config(5)`、`ssh-keygen(1)、` crypto `-policies(7)` 和 `update-crypto-policies(8)man` page. 				

# 1.7. 使用 SSH 跳过主机连接到远程服务器

​				使用这个步骤通过中间服务器（也称为跳过主机）将本地系统连接到远程服务器。 		

**先决条件**

- ​						跳过主机接受来自本地系统的 SSH 连接。 				
- ​						远程服务器只接受来自跳过主机的 SSH 连接。 				

**流程**

1. ​						通过编辑本地系统中的 `~/.ssh/config` 文件来定义跳过主机，例如： 				

   ```none
   Host jump-server1
     HostName jump1.example.com
   ```

   - ​								`Host` 参数定义您可以在 `ssh` 命令中使用的主机的名称或别名。该值可以匹配真实的主机名，但也可以是任意字符串。 						
   - ​								`HostName` 参数设置跳过主机的实际主机名或 IP 地址。 						

2. ​						使用 `ProxyJump` 指令将远程服务器跳过配置添加到本地系统上的 `~/.ssh/config` 文件中，例如： 				

   ```none
   Host remote-server
     HostName remote1.example.com
     ProxyJump jump-server1
   ```

3. ​						使用您的本地系统通过跳过服务器连接到远程服务器： 				

   ```none
   $ ssh remote-server
   ```

   ​						如果省略了配置步骤 1 和 2，则上一命令等同于 `ssh -J skip-server1 remote-server` 命令。 				

注意

​					您可以指定更多跳过服务器，您也可以在提供其完整主机名时跳过在配置文件中添加主机定义，例如： 			

```none
$ ssh -J jump1.example.com,jump2.example.com,jump3.example.com remote1.example.com
```

​					如果跳过服务器上的用户名或 SSH 端口与远程服务器上的名称和端口不同，请更改上一命令中的主机名或 SSH 端口，例如： 			

```none
$ ssh -J johndoe@jump1.example.com:75,johndoe@jump2.example.com:75,johndoe@jump3.example.com:75 joesec@remote1.example.com:220
```

**其它资源**

- ​						`ssh_config(5)` 和 `ssh(1)` 手册页. 				

# 1.8. 使用 ssh-agent 使用 SSH 密钥连接到远程机器

​				为了避免每次发起 SSH 连接时输入密语，您可以使用 `ssh-agent` 实用程序缓存 SSH 私钥。私钥和密语保持安全。 		

**先决条件**

- ​						您有一个远程主机正在运行 SSH 守护进程，并可通过网络访问。 				
- ​						您知道登录到远程主机的 IP 地址或者主机名以及凭证。 				
- ​						您已用密码生成了 SSH 密钥对，并将公钥传送到远程机器。如需更多信息，请参阅 [生成 SSH 密钥对](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/using-secure-communications-between-two-systems-with-openssh_securing-networks.xml#generating-ssh-key-pairs_using-secure-communications-between-two-systems-with-openssh)。 				

**流程**

1. ​						可选：验证您可以使用密钥在远程主机中进行身份验证： 				

   1. ​								使用 SSH 连接到远程主机： 						

      ```none
      $ ssh example.user1@198.51.100.1 hostname
      ```

   2. ​								输入您在创建密钥时设定的密码短语以授予对私钥的访问权限。 						

      ```none
      $ ssh example.user1@198.51.100.1 hostname
       host.example.com
      ```

2. ​						启动 `ssh-agent`。 				

   ```none
   $ eval $(ssh-agent)
   Agent pid 20062
   ```

3. ​						将密钥添加到 `ssh-agent`。 				

   ```none
   $ ssh-add ~/.ssh/id_rsa
   Enter passphrase for ~/.ssh/id_rsa:
   Identity added: ~/.ssh/id_rsa (example.user0@198.51.100.12)
   ```

**验证**

- ​						可选：使用 SSH 登录到主机机器。 				

  ```none
  $ ssh example.user1@198.51.100.1
  
  Last login: Mon Sep 14 12:56:37 2020
  ```

  ​						请注意您不必输入密码短语。 				

# 1.9. 其它资源

- ​						`sshd(8)`、`ssh(1)、` `sftp(1)、` `sftp(1)、` ssh `-keygen(1)、ssh` `-copy-id(1)、ssh` `_config(5)`、ssh `_config(5)`、update `-crypto-policies(8)和` `crypto-policies(7)` man page. 				
- ​						[OpenSSH 主页](http://www.openssh.com/) 。 				
- ​						[为使用非标准配置的应用程序和服务配置 SELinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/using_selinux/index#configuring-selinux-for-applications-and-services-with-non-standard-configurations_using-selinux)。 				
- ​						[使用 firewalld 控制网络流量](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/securing_networks/index#controlling-network-traffic-using-firewalld_using-and-configuring-firewalls)。 				

# 第 2 章 使用 SSH 系统角色配置安全通信

​			作为管理员，您可以使用 SSHD 系统角色来配置 SSH 服务器，使用 SSH 系统角色来通过Red Hat Ansible Automation Platform 在任意数量的 RHEL 系统上同时配置 SSH 客户端。 	

## 2.1. SSHD 系统角色变量

​				在 SSHD 系统角色 playbook 中，您可以根据您的偏好和限制来定义 SSH 配置文件的参数。 		

​				如果没有配置这些变量，系统角色会生成一个与 RHEL 默认值匹配的 `sshd_config` 文件。 		

​				在所有情况下，布尔值在 `sshd` 配置中都正确呈现为 `yes` 和 `no`。您可以使用 list 来定义多行配置项。例如： 		

```none
sshd_ListenAddress:
  - 0.0.0.0
  - '::'
```

​				呈现为： 		

```none
ListenAddress 0.0.0.0
ListenAddress ::
```

**SSHD 系统角色的变量**

- `sshd_enable`

  ​							如果设置为 `False`，则角色将被完全禁用。默认值为 `True`。 					

- `sshd_skip_defaults`

  ​							如果设置为 `True`，则系统角色不会应用默认值。相反，您可以使用 `sshd` dict 或 `sshd_Key` 变量来指定完整的配置默认值集合。默认值为 `False`。 					

- `sshd_manage_service`

  ​							如果设置为 `False`，则服务不会被管理，这意味着它不会在引导时启用，也不会启动或重新加载。除非在容器内或 AIX 中运行，否则默认为 `True`，因为 Ansible 服务模块目前不支持对 AIX 的 `启用` 。 					

- `sshd_allow_reload`

  ​							如果设置为 `False`，则`sshd` 不会在配置更改后重新加载。这可帮助进行故障排除。要应用更改后的配置，请手动重新加载 `sshd`。默认为与 `sshd_manage_service` 相同的值，但 AIX 除外，其中 `sshd_manage_service` 默认为 `False`，但 `sshd_allow_reload` 默认为 `True`。 					

- `sshd_install_service`

  ​							如果设置为 `True`，该角色将为 `sshd` 服务安装服务文件。这会覆盖操作系统中提供的文件。除非您要配置第二个实例，否则不要设置为 `True`，您也可以更改 `sshd_service` 变量，。默认值为 `False`。 					 						该角色使用以下变量指向的文件作为模板： 					`sshd_service_template_service (default: templates/sshd.service.j2) sshd_service_template_at_service (default: templates/sshd@.service.j2) sshd_service_template_socket (default: templates/sshd.socket.j2)`

- `sshd_service`

  ​							此变量更改 `sshd` 服务名称，这对于配置第二个 `sshd` 服务实例非常有用。 					

- `sshd`

  ​							包含配置的字典。例如： 					`sshd:  Compression: yes  ListenAddress:    - 0.0.0.0`

- `sshd*_OptionName*`

  ​							您可以使用由 `sshd_` 前缀和选项名称而不是 dict 组成的简单变量来定义选项。简单的变量覆盖 `sshd` 字典中的值。例如： 					`sshd_Compression: no`

- `sshd_match` 和 `sshd_match_1` 到 `sshd_match_9`

  ​							字典列表或 只是匹配部分的字典。请注意，这些变量不会覆盖 `sshd` 字典中定义的匹配块。所有源都会反映在生成的配置文件中。 					

**SSHD 系统角色的辅助变量**

​					您可以使用这些变量来覆盖与每个支持的平台对应的默认值。 			

- `sshd_packages`

  ​							您可以使用此变量来覆盖安装的软件包的默认列表。 					

- `sshd_config_owner`、`sshd_config_group` 和 `sshd_config_mode`

  ​							您可以使用这些变量为该角色生成的 `openssh` 配置文件设置所有权和权限。 					

- `sshd_config_file`

  ​							此角色保存生成的 `openssh` 服务器配置的路径。 					

- `sshd_binary`

  ​							`openssh` 的 `sshd` 可执行文件的路径。 					

- `sshd_service`

  ​							`sshd` 服务的名称。默认情况下，此变量包含目标平台所使用的 `sshd` 服务的名称。当角色使用 `sshd_install_service` 变量时，您还可以使用它来设置自定义 `sshd` 服务的名称。 					

- `sshd_verify_hostkeys`

  ​							默认值为 `auto`。当设置为 `auto` 时，这将列出生成的配置文件中存在的所有主机密钥，并生成所有不存在的路径。此外，权限和文件所有者被设置为默认值。如果该角色用于部署阶段来确保服务能够在第一次尝试时启动，则这非常有用。若要禁用此检查，可将此变量设置为空列表 `[]`。 					

- `sshd_hostkey_owner`,`sshd_hostkey_group`,`sshd_hostkey_mode`

  ​							使用这些变量来设置 `sshd_verify_hostkeys` 的主机密钥的所有权和权限。 					

- `sshd_sysconfig`

  ​							在基于 RHEL 的系统上，这个变量配置 `sshd` 服务的其它详细信息。如果设置为 `true`，则此角色还会根据以下配置来管理 `/etc/sysconfig/sshd` 配置文件：默认值为 `false`。 					

- `sshd_sysconfig_override_crypto_policy`

  ​							在 RHEL 8 中，当设置为 `true` 时，这个变量会覆盖系统范围的加密策略。默认值为 `false`。 					

- `sshd_sysconfig_use_strong_rng`

  ​							在基于 RHEL 的系统上，此变量可以强制 `sshd` 使用给定的字节数作为参数来重新设置 `openssl` 随机数字生成器的种子。默认值为 `0`，它会禁用此功能。如果系统没有硬件随机数字生成器，请不要打开此选项。 					

# 2.2. 使用 SSHD 系统角色来配置 OpenSSH 服务器

**先决条件**

- ​						可以访问一个或多个 *受管节点*，它们是您要使用 SSHD 系统角色来配置的系统。 				

- ​						*对控制节点的访问和权限*，这是 Red Hat Ansible Engine 配置其他系统的系统。 				

  ​						在控制节点上： 				

  - ​								Red Hat Ansible Engine 已安装。 						
  - ​								`rhel-system-roles` 软件包已安装。 						
  - ​								列出受管节点的清单文件。 						

**流程**

1. ​						为 SSHD 系统角色复制示例 playbook: 				

   ```none
   # cp /usr/share/doc/rhel-system-roles/sshd/example-root-login-playbook.yml path/custom-playbook.yml
   ```

2. ​						使用文本编辑器打开复制的 playbook，例如： 				

   ```none
   # vim path/custom-playbook.yml
   
   ---
   - hosts: all
     tasks:
     - name: Configure sshd to prevent root and password login except from particular subnet
       include_role:
         name: rhel-system-roles.sshd
       vars:
         sshd:
           # root login and password login is enabled only from a particular subnet
           PermitRootLogin: no
           PasswordAuthentication: no
           Match:
           - Condition: "Address 192.0.2.0/24"
             PermitRootLogin: yes
             PasswordAuthentication: yes
   ```

   ​						playbook 将受管节点配置为 SSH 服务器，以便： 				

   - ​								禁用密码和 `root` 用户登录 						
   - ​								只对子网 `192.0.2.0/24` 启用密码和 `root` 用户登录 						

   ​						您可以根据您的偏好修改变量。如需了解更多详细信息，请参阅 [SSHD 服务器系统角色变量](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/some-guide/sshd-system-role-variables_configuring-secure-communication-with-the-sshd-system-role)。 				

3. ​						可选：验证 playbook 语法。 				

   ```none
   # ansible-playbook --syntax-check path/custom-playbook.yml
   ```

4. ​						在清单文件上运行 playbook: 				

   ```none
   # ansible-playbook -i inventory_file path/custom-playbook.yml
   
   ...
   
   PLAY RECAP
   **************************************************
   
   localhost : ok=12 changed=2 unreachable=0 failed=0
   skipped=10 rescued=0 ignored=0
   ```

**验证**

1. ​						登录到 SSH 服务器： 				

   ```none
   $ ssh user1@10.1.1.1
   ```

   ​						其中： 				

   - ​								`*user1*` 是 SSH 服务器上的用户。 						
   - ​								`*10.1.1.1*` 是 SSH 服务器的 IP 地址。 						

2. ​						检查 SSH 服务器上的 `sshd_config` 文件的内容： 				

   ```none
   $ vim /etc/ssh/sshd_config
   
   # Ansible managed
   HostKey /etc/ssh/ssh_host_rsa_key
   HostKey /etc/ssh/ssh_host_ecdsa_key
   HostKey /etc/ssh/ssh_host_ed25519_key
   AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
   AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
   AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
   AcceptEnv XMODIFIERS
   AuthorizedKeysFile .ssh/authorized_keys
   ChallengeResponseAuthentication no
   GSSAPIAuthentication yes
   GSSAPICleanupCredentials no
   PasswordAuthentication no
   PermitRootLogin no
   PrintMotd no
   Subsystem sftp /usr/libexec/openssh/sftp-server
   SyslogFacility AUTHPRIV
   UsePAM yes
   X11Forwarding yes
   Match Address 192.0.2.0/24
     PasswordAuthentication yes
     PermitRootLogin yes
   ```

3. ​						检查您是否可以以 root 用户身份从 `192.0.2.0/24` 子网连接到服务器： 				

   1. ​								确定您的 IP 地址： 						

      ```none
      $ hostname -I
      192.0.2.1
      ```

      ​								如果 IP 地址在 `192.0.2.1` - `192.0.2.254` 范围内，您可以连接到服务器。 						

   2. ​								以 `root` 用户身份连接到服务器： 						

      ```none
      $ ssh root@10.1.1.1
      ```

**其它资源**

- ​						`/usr/share/doc/rhel-system-roles/sshd/README.md` 文件。 				
- ​						`ansible-playbook(1)` 手册页 				

# 2.3. SSH 系统角色变量

​				在 SSH 系统角色 playbook 中，您可以根据您的偏好和限制来为客户端 SSH 配置文件定义参数。 		

​				如果没有配置这些变量，系统角色会生成一个与 RHEL 默认值匹配的全局 `ssh_config` 文件。 		

​				在所有情况下，布尔值在 `ssh` 配置中都正确地呈现为 `yes` 或 `no`。您可以使用 list 来定义多行配置项。例如： 		

```none
LocalForward:
  - 22 localhost:2222
  - 403 localhost:4003
```

​				呈现为： 		

```none
LocalForward 22 localhost:2222
LocalForward 403 localhost:4003
```

注意

​					配置选项区分大小写。 			

**SSH 系统角色的变量**

- `ssh_user`

  ​							您可以定义一个现有用户名，系统角色可以为其修改用户特定的配置。用户特定配置保存在给定用户的 `~/.ssh/config` 中。默认值为 null，它会修改所有用户的全局配置。 					

- `ssh_skip_defaults`

  ​							默认值为 `auto`。如果设置为 `auto`，系统角色将会对系统范围的配置文件 `/etc/ssh/ssh_config` 进行写操作，并保留其中定义的 RHEL 默认值。例如，通过定义 `ssh_drop_in_name` 变量来创建一个 drop-in 配置文件，将自动禁用 `ssh_skip_defaults` 变量。 					

- `ssh_drop_in_name`

  ​							定义 drop-in 配置文件的名称，该文件放在系统范围的 drop-in 目录中。该名称在模板 `/etc/ssh/ssh_config.d/{ssh_drop_in_name}.conf` 中使用，以引用要修改的配置文件。如果系统不支持 drop-in 目录，则默认值为 null。如果系统支持 drop-in 目录，则默认值为 `00-ansible`。 					警告 							如果系统不支持 drop-in 目录，设置此选项将使 play 失败。 						 						建议的格式是 `NN-name`，其中 `NN` 是用于订购配置文件的两位数字，`name` 是内容或文件所有者的任何描述性名称。 					

- `ssh`

  ​							包含配置选项和其相应值的字典。 					

- `ssh*_OptionName*`

  ​							您可以使用由 `ssh_` 前缀和选项名称而不是字典组成的简单变量来定义选项。简单的变量覆盖 `ssh` 字典中的值。 					

- `ssh_additional_packages`

  ​							此角色会自动安装 `openssh` 和 `openssh-clients` 软件包，这是最常见用例所需要的。如果您需要安装其他软件包，例如 `openssh-keysign` 以用于基于主机的身份验证，您可以在此变量中指定它们。 					

- `ssh_config_file`

  ​							角色保存产生的配置文件的路径。默认值： 					 								如果系统有一个 drop-in 目录，则默认值通过模板 `/etc/ssh/ssh_config.d/{ssh_drop_in_name}.conf` 来定义。 							 								如果系统没有 drop-in 目录，则默认值为 `/etc/ssh/ssh_config`。 							 								如果定义了 `ssh_user` 变量，则默认值为 `~/.ssh/config`。 							

- `ssh_config_owner`,`ssh_config_group`,`ssh_config_mode`

  ​							所创建的配置文件的所有者、组和模式。默认情况下，文件的所有者是 `root:root`，模式是 `0644`。如果定义了 `ssh_user`，则模式为 `0600`，所有者和组派生自 `ssh_user` 变量中指定的用户名。 					

# 2.4. 使用 SSH 系统角色来配置 OpenSSH 客户端

​				您可以通过运行 Ansible playbook，使用 SSH 系统角色来配置多个 SSH 客户端。 		

**先决条件**

- ​						可以访问一个或多个 *受管节点*，它们是您要使用 SSH 系统角色来配置的系统。 				

- ​						*对控制节点的访问和权限*，这是 Red Hat Ansible Engine 配置其他系统的系统。 				

  ​						在控制节点上： 				

  - ​								Red Hat Ansible Engine 已安装。 						
  - ​								`rhel-system-roles` 软件包已安装。 						
  - ​								列出受管节点的清单文件。 						

**流程**

1. ​						使用以下内容创建新 `*playbook.yml*` 文件： 				

   ```none
   ---
   - hosts: all
     tasks:
     - name: "Configure ssh clients"
       include_role:
         name: rhel-system-roles.ssh
       vars:
         ssh_user: root
         ssh:
           Compression: true
           GSSAPIAuthentication: no
           ControlMaster: auto
           ControlPath: ~/.ssh/.cm%C
           Host:
             - Condition: example
               Hostname: example.com
               User: user1
         ssh_ForwardX11: no
   ```

   ​						此 playbook 使用以下配置在受管节点上配置 `root` 用户的 SSH 客户端首选项： 				

   - ​								压缩已启用。 						
   - ​								ControlMaster 多路复用设置为 `auto`。 						
   - ​								连接到 `*example.com*` 主机的`*example*` 别名是 `*user1*`。 						
   - ​								`*example*` 主机别名已创建，它表示使用 `*user1*` 用户名连接到 `*example.com*` 主机。 						
   - ​								X11 转发被禁用。 						

   ​						另外，您还可以根据您的偏好修改这些变量。如需了解更多详细信息，请参阅 [SSH 客户端角色变量](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/ssh-system-role-variables_configuring-secure-communication-with-the-ssh-system-role)。 				

2. ​						可选：验证 playbook 语法。 				

   ```none
   # ansible-playbook --syntax-check path/custom-playbook.yml
   ```

3. ​						在清单文件上运行 playbook: 				

   ```none
   # ansible-playbook -i inventory_file path/custom-playbook.yml
   ```

**验证**

- ​						通过在文本编辑器中打开 SSH 配置文件来验证受管节点是否具有正确的配置，例如： 				

  ```none
  # vi ~root/.ssh/config
  ```

  ​						在应用了上述示例 playbook 后，配置文件应具有以下内容： 				

  ```none
  # Ansible managed
  Compression yes
  ControlMaster auto
  ControlPath ~/.ssh/.cm%C
  ForwardX11 no
  GSSAPIAuthentication no
  Host example
    Hostname example.com
    User user1
  ```



# 第 3 章 计划并使用 TLS

​			 TLS（传输层安全）是用来保护网络通信的加密协议。在通过配置首选密钥交换协议、身份验证方法和加密算法来强化系统安全设置时，需要记住支持的客户端的范围越广，产生的安全性就越低。相反，严格的安全设置会导致与客户端的兼容性受限，这可能导致某些用户被锁定在系统之外。请确保以最严格的可用配置为目标，并且仅在出于兼容性原因需要时才放宽配置。 	

## 3.1. SSL 和 TLS 协议

​				安全套接字层(SSL)协议最初使由 Netscape 公司开发的，以提供一种在互联网上进行安全通信的机制。因此，该协议被互联网工程任务组(IETF)采纳，并重命名为传输层安全(TLS)。 		

​				TLS 协议位于应用协议层和可靠的传输层之间，例如 TCP/IP。它独立于应用程序协议,因此可在很多不同的协议下分层，如 HTTP、FTP、SMTP 等等。 		

| 协议版本 | 用法建议                                                     |
| -------- | ------------------------------------------------------------ |
| SSL v2   | 不要使用。具有严重的安全漏洞。从 RHEL 7 开始从核心加密库中删除了。 |
| SSL v3   | 不要使用。具有严重的安全漏洞。从 RHEL 8 开始从核心加密库中删除了。 |
| TLS 1.0  | 不建议使用。已知的无法以保证互操作性方式缓解的问题，且不支持现代密码套件。只在 `LEGACY` 系统范围的加密策配置文件中启用。 |
| TLS 1.1  | 在需要时用于互操作性.不支持现代加密套件。只在 `LEGACY` 策略中启用。 |
| TLS 1.2  | 支持现代 AEAD 密码组合。此版本在所有系统范围的加密策略中启用，但此协议的可选部分包含漏洞，TLS 1.2 也允许过时的算法。 |
| TLS 1.3  | 推荐的版本。TLS 1.3 删除了已知有问题的选项，通过加密更多协商握手来提供额外的隐私，由于使用了更有效的现代加密算法，所以可以更快。在所有系统范围的加密策略中也启用了 TLS 1.3。 |

**其它资源**

- ​						[IETF：传输层安全(TLS)协议版本 1.3](https://tools.ietf.org/html/rfc8446)。 				



# 3.2. RHEL 8 中 TLS 的安全注意事项

​				在 RHEL 8 中，由于系统范围的加密策略，与加密相关的注意事项大大简化了。`DEFAULT` 加密策略只允许 TLS 1.2 和 1.3。要允许您的系统使用早期版本的 TLS 来协商连接，您需要选择不使用应用程序中的以下加密策略，或使用 `update-crypto-policies` 命令切换到 `LEGACY` 策略。如需更多信息，请参阅[使用系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 		

​				RHEL 8 中包含的库提供的默认设置足以满足大多数部署的需要。TLS  实现尽可能使用安全算法，而不阻止来自或到旧客户端或服务器的连接。在具有严格安全要求的环境中应用强化设置，在这些环境中，不支持安全算法或协议的旧客户端或服务器不应连接或不允许连接。 		

​				强化 TLS 配置的最简单方法是使用 `update-crypto-policies --set FUTURE` 命令将系统范围的加密策略级别切换到 `FUTURE` 。 		

​				如果您决定不遵循 RHEL 系统范围的加密策略，请在自定义配置中对首选协议、密码套件和密钥长度使用以下建议： 		

### 3.2.1. 协议

​					TLS 的最新版本提供了最佳安全机制。除非有充分的理由包含对旧版本的 TLS 的支持，否则请允许您的系统使用至少 TLS 版本 1.2 来协商连接。请注意，虽然 RHEL 8 支持 TLS 版本 1.3，但 RHEL 8 组件并不完全支持此协议的所有功能。例如，Apache 或 Nginx web 服务器尚不完全支持 0-RTT(Zero Round Trip Time)功能，该功能可降低连接延迟。 			



# 3.2.2. 密码套件

​					现代、更安全的密码套件应该优先于旧的不安全密码套件。一直禁止 eNULL 和 aNULL  密码套件的使用，它们根本不提供任何加密或身份验证。如果有可能，基于 RC4 或 HMAC-MD5  的密码套件也必须被禁用。这同样适用于所谓的出口密码套件，它们被有意地弱化了，因此很容易被破解。 			

​					虽然不会立即变得不安全，但提供安全性少于 128 位的密码套件在它们的短使用期中不应该被考虑。使用 128  位或者更高安全性的算法可以预期在至少数年内不会被破坏，因此我们强烈推荐您使用此算法。请注意，虽然 3DES 密码公告使用 168  位但它们实际只提供了 112 位的安全性。 			

​					始终优先使用支持(完美)转发保密(PFS)的密码套件，这样可确保加密数据的机密性，以防服务器密钥被泄露。此规则排除了快速 RSA 密钥交换，但允许使用 ECDHE 和 DHE。在两者中，ECDHE 更快，因此是首选。 			

​					您还应该在 CBC 模式密码之前优先使用 AEAD 密码，如 AES-GCM，因为它们不易受到 padding oracle 攻击。此外，在很多情况下，在 CBC 模式下，AES-GCM 比 AES 快，特别是当硬件具有 AES 加密加速器时。 			

​					另请注意，在使用带有 ECDSA 证书的 ECDHE 密钥交换时，事务的速度甚至比纯 RSA  密钥交换要快。为了给旧客户端提供支持，您可以在服务器上安装两对证书和密钥：一对带有 ECDSA 密钥（用于新客户端），另一对带有 RSA  密钥（用于旧密钥）。 			

# 3.2.3. 公钥长度

​					在使用 RSA 密钥时，总是首选使用至少由 SHA-256 签名的 3072 位的密钥长度，对于真实的 128 位安全性来说，这个值已经足够大。 			

警告

​						您的系统安全性仅与链中最弱的连接相同。例如，只是一个强大的密码不能保证良好安全性。密钥和证书以及认证机构(CA)用来签署您的密钥的哈希功能和密钥同样重要。 				

**其它资源**

- ​							[RHEL 8 中的系统范围的加密策略](https://access.redhat.com/articles/3666211)。 					
- ​							`update-crypto-policies(8)` man page。 					

# 3.3. 在应用程序中强化 TLS 配置

​				在 Red Hat Enterprise Linux 8 中，[系统范围的加密策略](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening) 提供了一种便捷的方法，以确保使用加密库的应用程序不允许使用已知不安全的协议、密码或算法。 		

​				如果要使用自定义加密设置来强化与 TLS 相关的配置，您可以使用本节中描述的加密配置选项，并以最少的需求量覆盖系统范围的加密策略。 		

​				无论您选择使用什么配置，请始终确保您的服务器应用程序强制实施 *服务器端密码顺序*，以便使用的密码套件由您配置的顺序来决定。 		

### 3.3.1. 配置 `Apache HTTP 服务器`

​					`Apache HTTP 服务器` 可以使用 `OpenSSL` 和 `NSS` 库来满足其 TLS 的需求。Red Hat Enterprise Linux 8 通过 eponymous 软件包提供 `mod_ssl` 功能： 			

```none
# yum install mod_ssl
```

​					`mod_ssl` 软件包将安装 `/etc/httpd/conf.d/ssl.conf` 配置文件，该文件可用来修改 `Apache HTTP 服务器` 与 TLS 相关的设置。 			

​					安装 `httpd-manual` 软件包以获取 `Apache HTTP 服务器` 的完整文档，包括 TLS 配置。`/etc/httpd/conf.d/ssl.conf` 配置文件中的指令在 [ /usr/share/httpd/manual/mod_ssl.html](file:///usr/share/httpd/manual/mod/mod_ssl.html) 中有详细介绍。各种设置示例位于 [/usr/share/httpd/manual/ssl/ssl_howto.html](file:///usr/share/httpd/manual/ssl/ssl_howto.html)。 			

​					修改 `/etc/httpd/conf.d/ssl.conf` 配置文件中的设置时，请确保至少考虑以下三个指令： 			

- `SSLProtocol`

  ​								使用这个指令指定您要允许的 TLS 或者 SSL 版本。 						

- `SSLCipherSuite`

  ​								使用这个指令来指定您首选的密码套件或禁用您要禁止的密码套件。 						

- `SSLHonorCipherOrder`

  ​								取消注释并将此指令设置为 `on`，以确保连接的客户端遵循您指定的密码顺序。 						

​					例如，只使用 TLS 1.2 和 1.3 协议： 			

```none
SSLProtocol             all -SSLv3 -TLSv1 -TLSv1.1
```

​					如需更多信息，请参阅 [部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/index) 文档中的 [在 Apache HTTP 服务器上配置 TLS 加密](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/setting-apache-http-server_deploying-different-types-of-servers#configuring-tls-encryption-on-an-apache-http-server_setting-apache-http-server) 一章。 			

# 3.3.2. 配置 Nginx HTTP 和代理服务器

​					要在 `Nginx` 中启用 TLS 1.3 支持，请将 `TLSv1.3` 值添加到 `/etc/nginx/nginx.conf` 配置文件的 `server` 部分的 `ssl_protocols` 选项： 			

```none
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ....
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers
    ....
}
```

​					如需更多信息，请参阅 [部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/index) 文档中的 [向 Nginx web 服务器添加 TLS 加密](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/setting-up-and-configuring-nginx_deploying-different-types-of-servers#adding-tls-encryption-to-an-nginx-web-server_setting-up-and-configuring-nginx) 一章。 			

# 3.3.3. 配置 Dovecot 邮件服务器

​					要将 `Dovecot` 邮件服务器的安装配置为使用 TLS，请修改 `/etc/dovecot/conf.d/10-ssl.conf` 配置文件。您可以在 [/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt](https://access.redhat.com/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt) 文件中找到其提供的一些基本配置指令的说明，该文件与 `Dovecot` 的标准安装一起安装。 			

​					修改 `/etc/dovecot/conf.d/10-ssl.conf` 配置文件中的设置时，请确保至少考虑以下三个指令： 			

- `ssl_protocols`

  ​								使用这个指令指定您要允许或者禁用的 TLS 或者 SSL 版本。 						

- `ssl_cipher_list`

  ​								使用这个指令指定您首选的密码套件或禁用您要禁止的密码套件。 						

- `ssl_prefer_server_ciphers`

  ​								取消注释并将此指令设置为 `yes`，以确保连接的客户端遵循您指定的密码顺序。 						

​					例如，`/etc/dovecot/conf.d/10-ssl.conf` 中的以下行只允许 TLS 1.1 及之后的版本： 			

```none
ssl_protocols = !SSLv2 !SSLv3 !TLSv1
```

**其它资源**

- ​							[在 RHEL 8 上部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/index) 					
- ​							`config(5)` 和 `ciphers(1)` 手册页。 					
- ​							[安全使用传输层安全性(TLS)和数据报传输层安全性(DTLS)的建议](https://tools.ietf.org/html/rfc7525)。 					
- ​							[Mozilla SSL 配置生成器](https://mozilla.github.io/server-side-tls/ssl-config-generator/)。 					
- ​							[SSL 服务器测试](https://www.ssllabs.com/ssltest/) 。 					

## CentOS 通过 yum 升级 Openssh8.x

仅 Openssh 8.8p1 经过测试。

### 制作 RPM 包

```bash
# 安装相关依赖
yum install rpm-build zlib-devel openssl-devel gcc perl-devel pam-devel unzip -y

# 创建所需目录
mkdir -p /root/rpmbuild/{SOURCES,SPECS}
cd /root/rpmbuild/SOURCES

# 下载源码包
wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz
wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz

tar -xvzf openssh-8.8p1.tar.gz
tar -xvzf x11-ssh-askpass-1.2.4.1.tar.gz

# 修改配置文件
cp openssh-8.4p1/contrib/redhat/openssh.spec /root/rpmbuild/SPECS/
cd /root/rpmbuild/SPECS/

sed -i -e "s/%define no_x11_askpass 0/%define no_x11_askpass 1/g" openssh.spec
sed -i -e "s/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g" openssh.spec

# 构建
rpmbuild -ba openssh.spec

# 构建成功结果如下：
Wrote: /root/rpmbuild/SRPMS/openssh-8.4p1-1.el7.src.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-8.4p1-1.el7.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-clients-8.4p1-1.el7.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-server-8.4p1-1.el7.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-askpass-8.4p1-1.el7.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-askpass-gnome-8.4p1-1.el7.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/openssh-debuginfo-8.4p1-1.el7.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.pshj6r
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd openssh-8.4p1
+ rm -rf /root/rpmbuild/BUILDROOT/openssh-8.4p1-1.el7.x86_64
+ exit 0

# 验证软件包
ls /root/rpmbuild/RPMS/x86_64/
openssh-8.4p1-1.el7.x86_64.rpm                openssh-clients-8.4p1-1.el7.x86_64.rpm
openssh-askpass-8.4p1-1.el7.x86_64.rpm        openssh-debuginfo-8.4p1-1.el7.x86_64.rpm
openssh-askpass-gnome-8.4p1-1.el7.x86_64.rpm  openssh-server-8.4p1-1.el7.x86_64.rpm

# 构建过程报错解决
# 错误1：
error: Failed build dependencies: 	openssl-devel < 1.1 is needed by openssh-8.4p1-1.el7.x86_64
# 注释`BuildRequires: openssl-devel < 1.1`这一行
sed -i 's/BuildRequires: openssl-devel < 1.1/#&/' openssh.spec

# 错误2：
error: Failed build dependencies: 	/usr/include/X11/Xlib.h is needed by openssh-8.4p1-1.el7.x86_64
# 安装`libXt-devel imake gtk2-devel openssl-libs`
yum install libXt-devel imake gtk2-devel openssl-libs -y 
```

### 开始升级

```bash
# 备份配置文件
cp /etc/pam.d/{sshd,sshd.bck}
cp /etc/ssh/{sshd_config,sshd_config.bck}

# 安装新版本
yum update ./openssh* -y
```

### 启动ssh服务

```bash
# 恢复备份的配置文件，并重启sshd
mv /etc/ssh/sshd_config.bck /etc/ssh/sshd_config
mv /etc/pam.d/sshd.bck /etc/pam.d/sshd

sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/g" /etc/ssh/sshd_config

chmod 600 /etc/ssh/*
systemctl restart sshd
```

### 验证登陆

> **注意：**请勿关闭当前窗口，另外新开窗口连接没问题，再关闭。

### 验证当前版本

```bash
ssh -V
OpenSSH_8.8p1, OpenSSL 1.0.2k-fips  26 Jan 2017
```

### build脚本

> 该脚本用于制作`openssh rpm`包
>
> 使用方法：`rpmbuild_openssh.sh 8.4`

```bash
#!/usr/bin/env bash
# @Date   :2021/1/1 15:13
# @Author :ives
# @Email  :381347268@qq.com
# @File   :rpmbuild_openssh.sh
# @Desc   :制作openssh rpm软件包，通过tar包build

openssh_version=$1
#判断是否传入正确的软件包
if [ "${openssh_version}" ] ;then
    echo -e "\033[41;37m当前build的openssh版本为: ${openssh_version}\033[0m"
else
    echo "常用版本有：8.0, 8.1, 8.2, 8.3, 8.4"
    echo
    echo -e "   请输入需要build的openssh版本号  示例: \033[36;1m$0 8.4\033[0m"
    exit 1
fi

# 安装依赖
function install_dependency() {
    yum install -y wget rpm-build zlib-devel openssl-devel gcc perl-devel pam-devel unzip libXt-devel imake gtk2-devel openssl-libs >> /dev/null && sleep 3
}

# 下载软件包
function download_package() {
    mkdir -p /root/rpmbuild/{SOURCES,SPECS}
    cd /root/rpmbuild/SOURCES
    echo -e "\033[34;1m开始下载软件包：openssh-${openssh_version}p1.tar.gz  \033[0m"
    wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${openssh_version}p1.tar.gz >> /dev/null && echo "openssh-${version}p1.tar.gz下载成功..."
    if [ $? -ne 0 ]; then
        echo "openssh-${openssh_version}p1.tar.gz下载失败...请检查网络环境或版本是否存在"
         exit 2
    else
        echo -e "\033[34;1m开始下载软件包：x11-ssh-askpass-1.2.4.1.tar.gz  \033[0m"
        wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz >> /dev/null && echo "x11-ssh-askpass-1.2.4.1.tar.gz下载成功..." && sleep 3
        if [ $? -ne 0 ]; then
            echo "x11-ssh-askpass-1.2.4.1.tar.gz下载失败...请检查网络环境是否正常"
            exit 2
        else
            tar -xf openssh-8.4p1.tar.gz && tar -xf x11-ssh-askpass-1.2.4.1.tar.gz
        fi
    fi
}

# 修改配置文件和build
function config_and_build() {
    cp openssh-8.4p1/contrib/redhat/openssh.spec /root/rpmbuild/SPECS/
    sed -i -e "s/%define no_x11_askpass 0/%define no_x11_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
    sed -i -e "s/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
    sed -i 's/BuildRequires: openssl-devel < 1.1/#&/' /root/rpmbuild/SPECS/openssh.spec
    cd /root/rpmbuild/SPECS
    echo -e "\033[34;1m开始制作 openssh${openssh_version} 相关rpm软件包  \033[0m"
    rpmbuild -ba openssh.spec
    if [ $? -eq 0 ]; then
        echo -e "\033[34;1mopenssh${openssh_version} 相关rpm软件包制作成功，生成的软件包信息如下：  \033[0m"
        echo
        echo -e "\033[33;1m软件包存放路径：/root/rpmbuild/RPMS/x86_64/ \033[0m" && ls /root/rpmbuild/RPMS/x86_64/
    else
        echo -e "\033[33;1mopenssh${openssh_version} 相关rpm软件包制作失败，请根据报错信息进行解决，再重新进行编译 \033[0m"
    fi
}

function main() {
    install_dependency
    download_package
    config_and_build
}
main
```

# Rocky Linux - SSH 公钥和私钥[¶](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/#rocky-linux-ssh)

## 准备工作[¶](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/#_1)

- 熟悉命令行操作。

- 安装有 

  openssh

   的 Rocky Linux 服务器或工作站。

  - 从技术上讲，本文所述的过程在任何已安装 openssh 的 Linux 系统上都可以运行。

- 可选：熟悉 linux 文件和目录权限。

# 简介[¶](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/#_2)

SSH 是一种协议，通常用于通过命令行从一台计算机访问另一台计算机。使用 SSH，您可以在远程计算机和服务器上运行命令、发送文件，通常还可以从一个位置管理您所做的一切。

当您在多个位置使用多个 Rocky Linux 服务器时，或者只是想节省访问这些服务器的时间，则可以使用 SSH 公钥和私钥对。密钥对从根本上使登录远程计算机和运行命令变得更容易。

本文将指导您完成创建密钥，并设置服务器以易于访问。

### 生成密钥的过程[¶](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/#_3)

以下命令都是在 Rocky Linux 工作站的命令行中执行：

```
ssh-keygen -t rsa
```

将显示以下内容：

```
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
```

按 Enter 键表示保存在默认位置。接下来，系统将显示：

```
Enter passphrase (empty for no passphrase):
```

因此，只需按 Enter 键。最后，系统将要求您重新输入密码：

```
Enter same passphrase again:
```

最后再按一次 Enter 键。

现在，您的 .ssh 目录中应该有一个 RSA 类型的公钥和私钥对：

```
ls -a .ssh/
.  ..  id_rsa  id_rsa.pub
```

现在，需要将公钥（id_rsa.pub）发送到将要访问的每台计算机上。在执行此操作前，需要确保可以通过 SSH 连接到服务器。本示例将仅使用三台服务器。

您可以使用 DNS 名称或 IP 地址通过 SSH 访问它们，本示例将使用 DNS 名称。示例服务器是 Web、邮件和门户。对于每台服务器，尝试以 SSH 登入，并为每台计算机打开终端窗口：

```
ssh -l root web.ourourdomain.com
```

假设顺利登录到三台计算机上，那么下一步就是将公钥发送到每个服务器：

```
scp .ssh/id_rsa.pub root@web.ourourdomain.com:/root/
```

对每台计算机重复此步骤。

在每个打开的终端窗口中，输入以下命令，您应该看到 *id_rsa.pub*：

```
ls -a | grep id_rsa.pub
```

如果正确，现在准备在每台服务器的 *.ssh* 目录中创建或添加 *authorized_keys* 文件。在每台服务器上，输入以下命令：

```
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

### 目录和 authorized_keys 安全[¶](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/#authorized_keys)

在每台目标计算机上，确保应用了以下权限：

```
chmod 700 .ssh/` `chmod 600 .ssh/authorized_keys
```