# vsftpd

[TOC]


## 安装

1.安装软件包

```bash
sudo apt-get update
sudo apt-get install vsftpd
```

2.开启服务，同时在下次开机时能够自动开启服务：

```bash
------------- On SystemD -------------
systemctl start vsftpd
systemctl enable vsftpd
------------- On SysVInit -------------
service vsftpd start
chkconfig --level 35 vsftpd on
```

3.UFW 防火墙（默认情况下不启用），打开端口 20 和 21

```bash
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
sudo ufw status
```

4.创建一个原始配置文件 /etc/vsftpd/vsftpd.conf 的备份文件：

```bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
```

5.打开 vsftpd 配置文件。

```bash
sudo vi /etc/vsftpd.conf
# OR
sudo nano /etc/vsftpd.conf
```

下面的这些选项添加/改成所展示的值：

```bash
anonymous_enable=NO             # 关闭匿名登录
local_enable=YES                # 允许本地用户登录
write_enable=YES                # 启用可以修改文件的 FTP 命令
local_umask=022                 # 本地用户创建文件的 umask 值
dirmessage_enable=YES           # 当用户第一次进入新目录时显示提示消息
xferlog_enable=YES              # 一个存有详细的上传和下载信息的日志文件
connect_from_port_20=YES        # 在服务器上针对 PORT 类型的连接使用端口 20（FTP 数据）
xferlog_std_format=YES          # 保持标准日志文件格式
listen=NO                       # 阻止 vsftpd 在独立模式下运行
listen_ipv6=YES                 # vsftpd 将监听 ipv6 而不是 IPv4，你可以根据你的网络情况设置
pam_service_name=vsftpd         # vsftpd 将使用的 PAM 验证设备的名字
userlist_enable=YES             # 允许 vsftpd 加载用户名字列表
tcp_wrappers=YES                # 打开 tcp 包装器
```

6.配置 VSFTPD ，基于用户列表文件 /etc/vsftpd.userlist 来允许或拒绝用户访问 FTP。

注意，在默认情况下，如果通过 userlist_enable=YES 启用了用户列表，且设置 userlist_deny=YES 时，那么，用户列表文件 /etc/vsftpd.userlist 中的用户是不能登录访问的。

但是，选项 userlist_deny=NO 则反转了默认设置，这种情况下只有用户名被明确列出在 /etc/vsftpd.userlist 中的用户才允许登录到 FTP 服务器。

```bash
userlist_enable=YES                   # vsftpd 将会从所给的用户列表文件中加载用户名字列表
userlist_file=/etc/vsftpd.userlist    # 存储用户名字的列表
userlist_deny=NO
```

重要的是，当用户登录 FTP 服务器以后，他们将进入 chrooted 环境，即当在 FTP 会话时，其 root 目录将是其 home 目录。

接下来，我们来看一看两种可能的途径来设置 chrooted（本地 root）目录，正如下面所展示的。

7.这时，让我们添加/修改/取消这两个选项来将 FTP 用户限制在其 home 目录

```bash
chroot_local_user=YES
allow_writeable_chroot=YES
```

选项 chroot_local_user=YES 意味着本地用户将进入 chroot 环境，当登录以后默认情况下是其 home 目录。

并且我们要知道，默认情况下，出于安全原因，VSFTPD 不允许 chroot 目录具有可写权限。然而，我们可以通过选项 allow_writeable_chroot=YES 来改变这个设置

保存文件然后关闭。现在我们需要重启 VSFTPD 服务从而使上面的这些更改生效：

```bash
------------- On SystemD -------------
systemctl restart vsftpd
------------- On SysVInit -------------
service vsftpd restart
```

8.现在，我们通过使用下面展示的 useradd 命令创建一个 FTP 用户来测试 FTP 服务器：

```bash
sudo useradd -m -c "Aaron Kili, Contributor" -s /bin/bash aaronkilik
sudo passwd aaronkilik
```

然后，我们需要像下面这样使用 echo 命令和 tee 命令来明确地列出文件 /etc/vsftpd.userlist 中的用户 aaronkilik：

```bash
echo "aaronkilik" | sudo tee -a /etc/vsftpd.userlist
cat /etc/vsftpd.userlist
```

9.现在，是时候来测试上面的配置是否具有我们想要的功能了。我们首先测试匿名登录；我们可以从下面的输出中很清楚的看到，在这个 FTP 服务器中是不允许匿名登录的：

```bash
# ftp 192.168.56.102
Connected to 192.168.56.102  (192.168.56.102).
220 Welcome to TecMint.com FTP service.
Name (192.168.56.102:aaronkilik) : anonymous
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.
```

10.接下来，我们将测试，如果用户的名字没有在文件 /etc/vsftpd.userlist 中，是否能够登录。从下面的输出中，我们看到，这是不可以的：

```bash
# ftp 192.168.56.102
Connected to 192.168.56.102  (192.168.56.102).
220 Welcome to TecMint.com FTP service.
Name (192.168.56.10:root) : user1
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.
```

11.现在，我们将进行最后一项测试，来确定列在文件 /etc/vsftpd.userlist 文件中的用户登录以后，是否实际处于 home 目录。从下面的输出中可知，是这样的：

```bash
# ftp 192.168.56.102
Connected to 192.168.56.102  (192.168.56.102).
220 Welcome to TecMint.com FTP service.
Name (192.168.56.102:aaronkilik) : aaronkilik
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
```

警告：设置选项 allow_writeable_chroot=YES 是很危险的，特别是如果用户具有上传权限，或者可以 shell 访问的时候，很可能会出现安全问题。只有当你确切的知道你在做什么的时候，才可以使用这个选项。

我们需要注意，这些安全问题不仅会影响到 VSFTPD，也会影响让本地用户进入 chroot 环境的 FTP daemon。

因为这些原因，在下一步中，我将阐述一个更安全的方法，来帮助用户设置一个非可写本地 root 目录。
第四步：在 Ubuntu 中配置 FTP 用户的 Home 目录

12.现在，再次打开 VSFTPD 配置文件。

```bash
sudo vi /etc/vsftpd.conf
#  OR
sudo nano /etc/vsftpd.conf
```

然后像下面这样用 # 把不安全选项注释了：

```bash
#allow_writeable_chroot=YES
```

接下来，为用户创建一个替代的本地 root 目录（aaronkilik，你的可能和这不一样），然后设置目录权限，取消其他所有用户对此目录的写入权限：

```bash
sudo mkdir /home/aaronkilik/ftp
sudo chown nobody:nogroup /home/aaronkilik/ftp
sudo chmod a-w /home/aaronkilik/ftp
```

13.然后，在本地 root 目录下创建一个具有合适权限的目录，用户将在这儿存储文件：

```bash
sudo mkdir /home/aaronkilik/ftp/files
sudo chown -R aaronkilk:aaronkilik /home/aaronkilik/ftp/files
sudo chmod -R 0770 /home/aaronkilik/ftp/files/
```

之后，将 VSFTPD 配置文件中的下面这些选项添加/修改为相应的值：

```bash
user_sub_token=$USER          # 在本地 root 目录中插入用户名
local_root=/home/$USER/ftp    # 定义各个用户的本地 root 目录
```

保存文件并关闭。然后重启 VSFTPD 服务来使上面的设置生效：

```bash
------------- On SystemD -------------
systemctl restart vsftpd
------------- On SysVInit -------------
service vsftpd restart
```

14.现在，让我们来最后检查一下，确保用户的本地 root 目录是我们在他的 Home 目录中创建的 FTP 目录。

```bash
# ftp 192.168.56.102
Connected to 192.168.56.102  (192.168.56.102).
220 Welcome to TecMint.com FTP service.
Name (192.168.56.10:aaronkilik) : aaronkilik
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
```

## other

默认设置为禁止root账户登录,开启的方式如下：

1. 编辑/etc/vsftpd/user_list和/etc/vsftpd/ftpusers两个设置文件脚本，将root账户前加上#号变为注释。（即让root账户从禁止登录的用户列表中排除）
2. 重新开启vsftpd   service vsftpd reload
