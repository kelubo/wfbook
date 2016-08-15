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
