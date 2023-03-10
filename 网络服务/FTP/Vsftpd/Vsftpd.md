# vsftpd

[TOC]
## 概述

由于 FTP、HTTP、Telnet 等协议的数据都是使用明文进行传输的，因此从设计上就是不可靠的。为了满足以密文方式传输文件的需求，发明了 vsftpd 服务程序。

vsftpd （very secure FTP daemon），是一个完全免费的、开放源代码的 ftp 服务器软件。具有很高的安全性、传输速度，以及支持虚拟用户验证等其他 FTP 服务程序不具备的特点。在不影响使用的前提下，管理者可以自行决定客户端是采用匿名开放、本地用户还是虚拟用户的验证方式来登录 vsftpd 服务器。


## 安装

1. 安装软件包

   ```bash
   # Ubuntu
   sudo apt-get install vsftpd
   
   # CentOS
   yum install vsftpd
   dnf install vsftpd
   ```
2. 开启服务，同时在下次开机时能够自动开启服务：

   ```bash
   systemctl start vsftpd
   systemctl enable vsftpd
   ```

3. 防火墙打开端口 20 和 21
   ```bash
   # Ubuntu
   sudo ufw allow 20/tcp
   sudo ufw allow 21/tcp
   sudo ufw status
   
   # CentOS
   firewall-cmd --permanent --zone=public --add-service=ftp
   firewall-cmd --reload
   ```

4. 设置 SELinux 对于 FTP 协议的允许策略

   ```bash
   setsebool -P ftpd_connect_all_unreserved=on
   
   setsebool ftpd_full_access 1
   setsebool tftp_home_dir 1

## 配置

主配置文件（ `/etc/vsftpd/vsftpd.conf` ）。

```bash
# Example config file /etc/vsftpd/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
# Allow anonymous FTP? (Beware - allowed by default if you comment this out).
# 是否允许匿名用户访问
anonymous_enable=YES
#
# Uncomment this to allow local users to log in.
# When SELinux is enforcing check for SE bool ftp_home_dir
# 是否允许本地用户登录 FTP
local_enable=YES
#
# Uncomment this to enable any form of FTP write command.
# 启用可以修改文件的 FTP 命令
write_enable=YES           
#
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
# 本地用户创建文件的 umask 值
local_umask=022
#
# Uncomment this to allow the anonymous FTP user to upload files. This only
# has an effect if the above global write enable is activated. Also, you will
# obviously need to create a directory writable by the FTP user.
# When SELinux is enforcing check for SE bool allow_ftpd_anon_write, allow_ftpd_full_access
#anon_upload_enable=YES
#
# Uncomment this if you want the anonymous FTP user to be able to create
# new directories.
#anon_mkdir_write_enable=YES
#
# Activate directory messages - messages given to remote users when they
# go into a certain directory.
# 当用户第一次进入新目录时显示提示消息
dirmessage_enable=YES         
#
# Activate logging of uploads/downloads.
# 一个存有详细的上传和下载信息的日志文件
xferlog_enable=YES            
#
# Make sure PORT transfer connections originate from port 20 (ftp-data).
# 在服务器上针对 PORT 类型的连接使用端口 20（FTP 数据）
connect_from_port_20=YES
#
# If you want, you can arrange for uploaded anonymous files to be owned by
# a different user. Note! Using "root" for uploaded files is not
# recommended!
#chown_uploads=YES
#chown_username=whoever
#
# You may override where the log file goes if you like. The default is shown
# below.
#xferlog_file=/var/log/xferlog
#
# If you want, you can have your log file in standard ftpd xferlog format.
# Note that the default log file location is /var/log/xferlog in this case.
# 保持标准日志文件格式
xferlog_std_format=YES      
#
# You may change the default value for timing out an idle session.
#idle_session_timeout=600
#
# You may change the default value for timing out a data connection.
#data_connection_timeout=120
#
# It is recommended that you define on your system a unique user which the
# ftp server can use as a totally isolated and unprivileged user.
#nopriv_user=ftpsecure
#
# Enable this and the server will recognise asynchronous ABOR requests. Not
# recommended for security (the code is non-trivial). Not enabling it,
# however, may confuse older FTP clients.
#async_abor_enable=YES
#
# By default the server will pretend to allow ASCII mode but in fact ignore
# the request. Turn on the below options to have the server actually do ASCII
# mangling on files when in ASCII mode. The vsftpd.conf(5) man page explains
# the behaviour when these options are disabled.
# Beware that on some FTP servers, ASCII support allows a denial of service
# attack (DoS) via the command "SIZE /big/file" in ASCII mode. vsftpd
# predicted this attack and has always been safe, reporting the size of the
# raw file.
# ASCII mangling is a horrible feature of the protocol.
#ascii_upload_enable=YES
#ascii_download_enable=YES
#
# You may fully customise the login banner string:
#ftpd_banner=Welcome to blah FTP service.
#
# You may specify a file of disallowed anonymous e-mail addresses. Apparently
# useful for combatting certain DoS attacks.
#deny_email_enable=YES
# (default follows)
#banned_email_file=/etc/vsftpd/banned_emails
#
# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().
# (Warning! chroot'ing can be very dangerous. If using chroot, make sure that
# the user does not have write access to the top level directory within the
# chroot)
#chroot_local_user=YES
#chroot_list_enable=YES
# (default follows)
#chroot_list_file=/etc/vsftpd/chroot_list
#
# You may activate the "-R" option to the builtin ls. This is disabled by
# default to avoid remote users being able to cause excessive I/O on large
# sites. However, some broken FTP clients such as "ncftp" and "mirror" assume
# the presence of the "-R" option, so there is a strong case for enabling it.
#ls_recurse_enable=YES
#
# When "listen" directive is enabled, vsftpd runs in standalone mode and
# listens on IPv4 sockets. This directive cannot be used in conjunction
# with the listen_ipv6 directive.
# 是否以独立运行的方式监听服务
# 阻止 vsftpd 在独立模式下运行
listen=NO
#
# This directive enables listening on IPv6 sockets. By default, listening
# on the IPv6 "any" address (::) will accept connections from both IPv6
# and IPv4 clients. It is not necessary to listen on *both* IPv4 and IPv6
# sockets. If you want that (perhaps because you want to listen on specific
# addresses) then you must run two copies of vsftpd with two configuration
# files.
# Make sure, that one of the listen options is commented !!
# vsftpd 将监听 ipv6 而不是 IPv4
listen_ipv6=YES

# vsftpd 将使用的 PAM 验证设备的名字
pam_service_name=vsftpd
# 允许 vsftpd 加载用户名字列表
userlist_enable=YES
# 打开 tcp 包装器
tcp_wrappers=YES            
```

| 参数                                               | 作用                                                         |
| -------------------------------------------------- | ------------------------------------------------------------ |
| listen_address=IP地址                              | 设置要监听的IP地址                                           |
| listen_port=21                                     | 设置FTP服务的监听端口                                        |
| download_enable＝[YES\|NO]                         | 是否允许下载文件                                             |
| userlist_enable=[YES\|NO]  userlist_deny=[YES\|NO] | 设置用户列表为“允许”还是“禁止”操作                           |
| max_clients=0                                      | 最大客户端连接数，0为不限制                                  |
| max_per_ip=0                                       | 同一IP地址的最大连接数，0为不限制                            |
| anon_upload_enable=[YES\|NO]                       | 是否允许匿名用户上传文件                                     |
| anon_umask=022                                     | 匿名用户上传文件的umask值                                    |
| anon_root=/var/ftp                                 | 匿名用户的FTP根目录                                          |
| anon_mkdir_write_enable=[YES\|NO]                  | 是否允许匿名用户创建目录                                     |
| anon_other_write_enable=[YES\|NO]                  | 是否开放匿名用户的其他写入权限（包括重命名、删除等操作权限） |
| anon_max_rate=0                                    | 匿名用户的最大传输速率（字节/秒），0为不限制                 |
| local_root=/var/ftp                                | 本地用户的FTP根目录                                          |
| chroot_local_user=[YES\|NO]                        | 是否将用户权限禁锢在FTP目录，以确保安全                      |
| local_max_rate=0                                   | 本地用户最大传输速率（字节/秒），0为不限制                   |

## Vsftpd 服务程序

允许用户以 3 种认证模式登录 FTP 服务器：

* **匿名开放模式**

  是最不安全的一种认证模式，任何人都可以无须密码验证而直接登录到 FTP 服务器。

* **本地用户模式**

  是通过 Linux 系统本地的账户密码信息进行认证的模式，相较于匿名开放模式更安全，而且配置起来也很简单。但是如果黑客破解了账户的信息，就可以畅通无阻地登录 FTP 服务器，从而完全控制整台服务器。

* **虚拟用户模式**

  更安全的一种认证模式，它需要为 FTP 服务单独建立用户数据库文件，虚拟出用来进行密码验证的账户信息，而这些账户信息在服务器系统中实际上是不存在的，仅供 FTP 服务程序进行认证使用。这样，即使黑客破解了账户信息也无法登录服务器，从而有效降低了破坏范围和影响。

### 匿名访问模式

这种模式一般用来访问不重要的公开文件。

vsftpd 服务程序默认关闭了匿名开放模式。需要做的就是开放匿名用户的上传、下载文件的权限，以及让匿名用户创建、删除、更名文件的权限。需要注意的是，针对匿名用户放开这些权限会带来潜在危险。

| 参数                        | 作用                               |
| --------------------------- | ---------------------------------- |
| anonymous_enable=YES        | 允许匿名访问模式                   |
| anon_umask=022              | 匿名用户上传文件的 umask 值        |
| anon_upload_enable=YES      | 允许匿名用户上传文件               |
| anon_mkdir_write_enable=YES | 允许匿名用户创建目录               |
| anon_other_write_enable=YES | 允许匿名用户修改目录名称或删除目录 |

```bash
anonymous_enable=YES
anon_umask=022
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
```

在 vsftpd 服务程序的匿名开放认证模式下，其账户统一为 anonymous，密码为空。而且在连接 FTP 服务器后，默认访问的是 /var/ftp 目录。该目录内拒绝创建目录。查看该目录的权限得知，只有root管理员才有写入权限。将目录的所有者身份改成系统账户 ftp 。如系统提示“创建目录的操作失败”（Create directory operation failed），是 SELinux 服务的原因。

使用 getsebool 命令查看与 FTP 相关的 SELinux 域策略都有哪些：

```bash
getsebool -a | grep ftp

ftpd_anon_write --> off
ftpd_connect_all_unreserved --> off
ftpd_connect_db --> off
ftpd_full_access --> off
ftpd_use_cifs --> off
ftpd_use_fusefs --> off
ftpd_use_nfs --> off
ftpd_use_passive_mode --> off
httpd_can_connect_ftp --> off
httpd_enable_ftp_server --> off
tftp_anon_write --> off
tftp_home_dir --> off
```

是 ftpd_full_access--> off 策略规则导致了操作失败。修改该策略规则，并且在设置时使用 -P 参数让修改过的策略永久生效，确保在服务器重启后依然能够顺利写入文件。

```bash
setsebool -P ftpd_full_access=on
```

等 SELinux 域策略修改完毕后，就能够顺利执行文件的创建、修改及删除等操作了。

在上面的操作中，由于权限不足，所以我们将 /var/ftp/pub 目录的所有者设置成 ftp 用户本身。除了这种方法，也可以通过设置权限的方法让其他用户获取到写入权限（例如 777 这样的权限）。但是，由于 vsftpd 服务自身带有安全保护机制，因此不要直接修改 /var/ftp 的权限，这有可能导致服务被“安全锁定”而不能登录。一定要记得是对里面的 pub 目录修改权限。

### 本地用户模式

相较于匿名开放模式，本地用户模式要更安全，而且配置起来也很简单。

| 参数                | 作用                                                 |
| ------------------- | ---------------------------------------------------- |
| anonymous_enable=NO | 禁止匿名访问模式                                     |
| local_enable=YES    | 允许本地用户模式                                     |
| write_enable=YES    | 设置可写权限                                         |
| local_umask=022     | 本地用户模式创建文件的 umask 值                      |
| userlist_deny=YES   | 启用“禁止用户名单”，名单文件为 ftpusers 和 user_list |
| userlist_enable=YES | 开启用户作用名单文件功能                             |

默认情况下本地用户所需的参数都已经存在，不需要修改。

```bash
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
```

在使用 root 管理员的身份登录后，系统提示被系统拒绝访问。是因为 vsftpd 服务程序所在的目录中默认存放着两个名为“用户名单”的文件（ ftpusers 和 user_list ）。这两个文件只要里面写有某位用户的名字，就不再允许这位用户登录到 FTP 服务器上。

```bash
cat /etc/vsftpd/user_list 

# vsftpd userlist
# If userlist_deny=NO, only allow users in this file
# If userlist_deny=YES (default), never allow users in this file, and
# do not even prompt for a password.
# Note that the default vsftpd pam config also checks /etc/vsftpd/ftpusers
# for users that are denied.
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
news
uucp
operator
games
nobody

# ===============================================================================

cat /etc/vsftpd/ftpusers 

# Users that are not allowed to login via ftp
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
news
uucp
operator
games
nobody
```

vsftpd 服务程序为了保证服务器的安全性而默认禁止了 root 管理员和大多数系统用户的登录行为，这样可以有效地避免黑客通过 FTP 服务对 root 管理员密码进行暴力破解。

### 虚拟用户模式

虚拟用户模式是这3种模式中最安全的一种认证模式，是专门创建出一个账号来登录 FTP 传输服务的，而且这个账号不能用于以 SSH 方式登录服务器。

**第1步**：创建用于进行FTP认证的用户数据库文件，其中奇数行为账户名，偶数行为密码。例如，分别创建 zhangsan 和 lisi 两个用户，密码均为 redhat ：

```bash
vim /etc/vsftpd/vuser.list

zhangsan
redhat
lisi
redhat
```

由于明文信息既不安全，也不符合让 vsftpd 服务程序直接加载的格式，因此需要使用 db_load 命令用哈希（hash）算法将原始的明文信息文件转换成数据库文件，并且降低数据库文件的权限（避免其他人看到数据库文件的内容），然后再把原始的明文信息文件删除。

```bash
db_load -T -t hash -f vuser.list vuser.db
chmod 600 vuser.db
rm -f vuser.list
```

**第2步**：创建 vsftpd 服务程序用于存储文件的根目录以及用于虚拟用户映射的系统本地用户。vsftpd 服务用于存储文件的根目录指的是，当虚拟用户登录后所访问的默认位置。

由于 Linux 系统中的每一个文件都有所有者、所属组属性，例如使用虚拟账户“张三”新建了一个文件，但是系统中找不到账户“张三”，就会导致这个文件的权限出现错误。为此，需要再创建一个可以映射到虚拟用户的系统本地用户。简单来说，就是让虚拟用户默认登录到与之有映射关系的这个系统本地用户的家目录中。虚拟用户创建的文件的属性也都归属于这个系统本地用户，从而避免 Linux 系统无法处理虚拟用户所创建文件的属性权限。

为了方便管理 FTP 服务器上的数据，可以把这个系统本地用户的家目录设置为 /var 目录（该目录用来存放经常发生改变的数据）。并且为了安全起见，将这个系统本地用户设置为不允许登录 FTP 服务器，这不会影响虚拟用户登录，而且还能够避免黑客通过这个系统本地用户进行登录。

```bash
useradd -d /var/ftproot -s /sbin/nologin virtual

ls -ld /var/ftproot/
drwx------. 3 virtual virtual 74 Jul 14 17:50 /var/ftproot/

chmod -Rf 755 /var/ftproot/
```

**第3步**：建立用于支持虚拟用户的 PAM 文件。

PAM（可插拔认证模块）是一种认证机制，通过一些动态链接库和统一的 API 把系统提供的服务与认证方式分开，使得系统管理员可以根据需求灵活调整服务程序的不同认证方式。

通俗来讲，PAM 是一组安全机制的模块，系统管理员可以用来轻易地调整服务程序的认证方式，而不必对应用程序进行任何修改。PAM 采取了分层设计（应用程序层、应用接口层、鉴别模块层）的思想，其结构如图所示。

 ![](../../../Image/PAM的分层设计结构.jpg)

新建一个用于虚拟用户认证的 PAM 文件 vsftpd.vu ，其中 PAM 文件内的 “db=” 参数为使用 db_load 命令生成的账户密码数据库文件的路径，但不用写数据库文件的后缀：

```bash
vim /etc/pam.d/vsftpd.vu

auth       required     pam_userdb.so db=/etc/vsftpd/vuser
account    required     pam_userdb.so db=/etc/vsftpd/vuser
```

**第4步**：在 vsftpd 服务程序的主配置文件中通过 pam_service_name 参数将 PAM 认证文件的名称修改为 vsftpd.vu 。PAM 作为应用程序层与鉴别模块层的连接纽带，可以让应用程序根据需求灵活地在自身插入所需的鉴别功能模块。当应用程序需要 PAM 认证时，则需要在应用程序中定义负责认证的 PAM 配置文件，实现所需的认证功能。

例如，在vsftpd 服务程序的主配置文件中默认就带有参数 pam_service_name=vsftpd ，表示登录 FTP 服务器时是根据 /etc/pam.d/vsftpd 文件进行安全认证的。现在我们要做的就是把 vsftpd 主配置文件中原有的 PAM 认证文件 vsftpd 修改为新建的 vsftpd.vu 文件即可。该操作中用到的参数以及作用如表所示。

| 参数                       | 作用                                                         |
| -------------------------- | ------------------------------------------------------------ |
| anonymous_enable=NO        | 禁止匿名开放模式                                             |
| local_enable=YES           | 允许本地用户模式                                             |
| guest_enable=YES           | 开启虚拟用户模式                                             |
| guest_username=virtual     | 指定虚拟用户账户                                             |
| pam_service_name=vsftpd.vu | 指定PAM文件                                                  |
| allow_writeable_chroot=YES | 允许对禁锢的 FTP 根目录执行写入操作，而且不拒绝用户的登录请求 |

```bash
anonymous_enable=NO
local_enable=YES
write_enable=YES
guest_enable=YES
guest_username=virtual
allow_writeable_chroot=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd.vu
userlist_enable=YES
```

**第5步**：为虚拟用户设置不同的权限。虽然账户 zhangsan 和 lisi 都是用于 vsftpd 服务程序认证的虚拟账户，但是我们依然想对这两人进行区别对待。比如，允许张三上传、创建、修改、查看、删除文件，只允许李四查看文件。这可以通过 vsftpd 服务程序来实现。只需新建一个目录，在里面分别创建两个以 zhangsan 和 lisi 命名的文件，其中在名为 zhangsan 的文件中写入允许的相关权限（使用匿名用户的参数）：

```bash
mkdir /etc/vsftpd/vusers_dir/
cd /etc/vsftpd/vusers_dir/

touch lisi

vim zhangsan
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
```

然后再次修改 vsftpd 主配置文件，通过添加 user_config_dir 参数来定义这两个虚拟用户不同权限的配置文件所存放的路径。为了让修改后的参数立即生效，需要重启 vsftpd 服务程序并将该服务添加到开机启动项中：

```bash
anonymous_enable=NO
local_enable=YES
write_enable=YES
guest_enable=YES
guest_username=virtual
allow_writeable_chroot=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd.vu
userlist_enable=YES
user_config_dir=/etc/vsftpd/vusers_dir
```

**第6步**：可以使用虚拟用户模式成功登录到FTP服务器，还可以分别使用账户zhangsan和lisi来检验他们的权限。



在使用不同的方式登录文件传输服务器后，默认所在的位置。

| 登录方式 | 默认目录             |
| -------- | -------------------- |
| 匿名公开 | /var/ftp             |
| 本地用户 | 该用户的家目录       |
| 虚拟用户 | 对应映射用户的家目录 |

## FTP 客户端

ftp 是 Linux 系统中以命令行界面的方式来管理FTP传输服务的客户端工具。

```bash
# 安装
dnf install ftp
```

## 配置

配置 VSFTPD ，基于用户列表文件 /etc/vsftpd.userlist 来允许或拒绝用户访问 FTP。

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

​        ftp 192.168.56.102

​        Connected to 192.168.56.102  (192.168.56.102).
​        220 Welcome to TecMint.com FTP service.
​        Name (192.168.56.10:aaronkilik) : aaronkilik
​        331 Please specify the password.
​        Password:
​        230 Login successful.
​        Remote system type is UNIX.
​        Using binary mode to transfer files.
​        ftp> ls







4、创建虚拟用户

（1）选择在根目录或用户目录下创建ftp文件目录：mkdir ftpfile,如/ftpfile,

[root@localhost ~]# cd /

[root@localhost /]# mkdir ftpfile

[root@localhost /]# ls

通过ftp上传时就会传到这个文件夹下

（2）添加匿名用户：useradd ftpuser -d /ftpfile/ -s /sbin/nologin      #添加用户没有登录机器的权限,只有上传ftpfile有权限.

[root@localhost ftpfile]# useradd ftpuser -d /ftpfile/ -s /sbin/nologin

（3）修改ftpfile权限：chown -R ftpuser.ftpuser /ftpfile/ #把创建的用户和创建的文件夹的权限对应上。-R表示遍历，把用户或者用户组赋予到/ftpfile这个文件夹的权限上

[root@localhost ftpfile]# chown -R ftpuser.ftpuser /ftpfile/

查看该文件目录的权限

此时的用户名和用户组的权限都为ftpuser

（4）重设ftpuser密码：passwd ftpuser 123456（这里设置的密码为123456）

[root@localhost /]# passwd ftpuser

（5）在vsftpd文件目录下创建测试文件zxr.txt

[root@localhost /]# cd ftpfile/

 [root@localhost ftpfile]# touch zxr.txt

[root@localhost ftpfile]# ls

zxr.txt

[root@localhost ftpfile]# vi zxr.txt

5、vsftpd服务器的配置

（1）vsftpd.conf文件

查看ftp服务器的安装路径

[root@localhost ftpfile]# whereis vsftpd

进入/etc/vsftpd/目录下

[root@localhost ftpfile]# cd /etc/vsftpd/

编辑vsftpd.conf文件，把创建的用户配置上

修改客户端登录，提示的欢迎信息（vi打开文件输入/然后将banner输入，再点击enter键，能快速找到banner信息）

需要将注释取消掉，改为自己想要的提示信息

还需要添加一些重要的属性节点

local_root=/ftpfile                      #把本地账户指向创建的ftpfile文件夹

anon_root=/ftpfile            #添加匿名账户访问ftpfile目录

use_localtime=YES            #ftp服务器用到的是本地的时间

查找chroot_list节点

#chroot_local_user=YES                    #这个节点为是否锁定创建的/ftpfile为根目录,不解除注释，默认为chroot_local_user=NO，锁定创建的/ftpfile为根目录，如果解除后设置为chroot_local_user=YES，那么就没有锁定创建的/ftpfile为根目录，在命令行是可以访问到/ftpfile的上级目录，也就是系统的根目录，这是绝对不安全的。所以这个节点不用解除注释，或者解除更改为chroot_local_user=NO。

编辑该节点，解除

chroot_list_enable=YES

chroot_list_file=/etc/vsftpd/chroot_list

添加节点

allow_writeable_chroot=YES                     #加上这行解决了无法登陆的问题

两条命令的注释，将新建的用户添上。

查找节点anonymous_enable

将该节点改为anonymous_enable=NO，不允许匿名用户登录

在该文件的末尾添加传输接口的范围，最大接口61001，最大接口62000，限定严格的设置防火墙。

添加范围

pasv_min_port=61001

pasv_max_port=62000

编辑完成保存退出。

（2）配置chroot_list文件

该文件目录的节点在上一步配置vsftpd.conf文件中已解除注释。

进入到/etc/vsftpd/目录下创建文件chroot_list

[root@localhost vsftpd]# cd /etc/vsftpd/

[root@localhost vsftpd]# vi chroot_list                    

#用编辑器打开文件时，如果没有这个文件，会默认自动创建一个该文件。

将用户添加进入该新建的chroot_list文件中

保存退出。

（5）编辑文件/etc/selinux/config文件

[root@localhost vsftpd]# vi /etc/selinux/config

修改为SELINUX=disabled，如果不改的话，匿名账户无法创建文件文件或者文件目录

:wq保存退出

注：如果在验证的时候碰到550拒绝访问请执行：

sudo setsebool -P ftp_home_dir 1

然后重启Linux服务器，执行reboot命令。
6、vsftpd配置文件说明

sudo vi /etc/vsftpd/vsftpd.conf

vsftpd.conf文件的配置文件的添加或更新配置

本项目要用到的配置项：

1）local_root=/ftpfile(当本地用户登入时，将被更换到定义的目录下，默认值为各用户的家目录)

2）anon_root=/ftpfile(使用匿名登入时，所登入的目录)

3）use_localtime=YES(默认是GMT时间，改成使用本机系统时间)

4）anonymous_enable=NO(不允许匿名用户登录)

5）local_enable=YES(允许本地用户登录)

6）write_enable=YES(本地用户可以在自己家目录中进行读写操作)

7）local_umask=022(本地用户新增档案时的umask值)

8）dirmessage_enable=YES(如果启动这个选项，那么使用者第一次进入一个目录时，会检查该目录下是否有.message这个档案，如果有，则会出现此档案的内容，通常这个档案会放置欢迎话语，或是对该目录的说明。默认值为开启)

9）xferlog_enable=YES(是否启用上传/下载日志记录。如果启用，则上传与下载的信息将被完整纪录在xferlog_file 所定义的档案中。预设为开启。)

10）connect_from_port_20=YES(指定FTP使用20端口进行数据传输，默认值为YES)

11）xferlog_std_format=YES(如果启用，则日志文件将会写成xferlog的标准格式)

12）ftpd_banner=Welcome to mmall FTP Server(这里用来定义欢迎话语的字符串)

13）chroot_local_user=NO(用于指定用户列表文件中的用户是否允许切换到上级目录)

14）chroot_list_enable=YES(设置是否启用chroot_list_file配置项指定的用户列表文件)

15）chroot_list_file=/etc/vsftpd/chroot_list(用于指定用户列表文件)

16）listen=YES(设置vsftpd服务器是否以standalone模式运行，以standalone模式运行是一种较好的方式，此时listen必须设置为YES，此为默认值。建议不要更改，有很多与服务器运行相关的配置命令，需要在此模式下才有效，若设置为NO，则vsftpd不是以独立的服务运行，要受到xinetd服务的管控，功能上会受到限制)

17）pam_service_name=vsftpd(虚拟用户使用PAM认证方式，这里是设置PAM使用的名称，默认即可，与/etc/pam.d/vsftpd对应) userlist_enable=YES(是否启用vsftpd.user_list文件，黑名单,白名单都可以

18)pasv_min_port=61001(被动模式使用端口范围最小值)

19)pasv_max_port=62000(被动模式使用端口范围最大值)

20)pasv_enable=YES(pasv_enable=YES/NO（YES）

若设置为YES，则使用PASV工作模式；若设置为NO，则使用PORT模式。默认值为YES，即使用PASV工作模式。
8、vsftpd的验证

（1）执行sudo service vsftpd restart

[root@localhost vsftpd]# service vsftpd restart

注：第一次启动时Shutting down vsftpd是failed不用理会，因为这是重启命令，保证Starting vsftpd for vsftpd是OK即代表vsftpd服务成功。、

service vsftpd stop            #表示关闭vsftpd

（2）执行ifconfig查看运行vsftpd服务器的ip地址

（3）打开浏览器访问：ftp://192.168.244.128/

（4）输入之前创建的ftp匿名用户账号和密码

例如：用户名：ftpuser,密码：123456

（5）看到如图界面代表访问成功

或者通过ftp客户端软件

例如：cuteftp、filezilla、viperftp、flashftp、leapftp等进行连接ftp服务器，进行上传文件、下载验证
9、vsftpd的常用命令

（1）启动：sudo service vsftpd start

（2）关闭：sudo service vsftpd stop

（3）重启：sudo service vsftpd restart
10、反复需要验证ftp身份问题解决

在安装vsftpd的时候如果在浏览器中一直提示需要身份验证，此时在命令行行登录会报530 Login incorrect错误。

在vsftpd的配置文件目录/etc/vsftpd下中的vsftpd.conf文件中会配置有pam_service_name=vsftpd指定pam下的文件在该文件中内容如下：

其中可能导致登录不成功（反复需要身份验证）的问题主要在于以下两个配置

问题配置一

在/etc/vsftpd/ftpusers这个文件中的用户是禁止登录的用户，先检查需要登录的账户是否在该文件中，如果在，就将该账户注释或者从该文件中去除

问题配置二：

该配置是允许用户的shell为 /etc/shells文件内的shell命令时，才能够成功

此处多留意有的系统里面的shells中的bash会多一些，比如

所以就需要查看当前系统shells文件中的内容与创建ftp用户的时候，为了禁止ssh登录，跟上的命令在shells中是否存在；

比如：我当前的shells文件内容为

但是我在创建ftp用户的时候的命令为

[root@localhost ~]# useradd ftpuser -d /ftpfile/ -s /sbin/nologin

所以此时创建用户后-s /sbin/nologin并不是有效的。

这时的解决方案为修改/etc/pam.d/vsftpd文件中的

auth   required   pam_shells.so

修改为auth    required     pam_nologin.so

最后重启vsftpd

[root@localhost ~]# service vsftpd restart



## stand alone和super daemon

stand alone指的是一直运行vsftpd，占用资源，提供ftp服务。super daemon指的是有需要时由xinetd启动vsftpd服务。如果服务器不是那种长期开ftp，提供大量的上传下载服务的话，会选择后者。

## 安装

安装

```
$ sudo apt-get install vsftpd
```

查看是否打开21端口

```
$ sudo netstat -npltu | grep 21
tcp        0      0 0.0.0.0:21              0.0.0.0:*               LISTEN      15601/vsftpd    
```

登录

```
ftp localhost
```

输入Ubuntu的用户名、密码登录

```
ls
```

会显示home目录的文件

## 文件结构

匿名用户根路径

```
/srv/ftp
```

配置文件

```
/etc/vsftpd.conf
```

查阅配置文件详细信息

```
man 5 vsftpd.conf
```

设定log保存位置，默认如下

```
xferlog_file=/var/log/vsftpd.log
```

## 运行

### standalone

最普遍的方式

```
sudo service vsftpd start
```

### super daemon

需要修改vsftpd.conf

```
listen=NO
```

这里若不改成NO，会出现下列错误

```
500 OOPS: could not bind listening IPv4 socket
```

安装xinetd

```
sudo apt-get install xinetd
sudo vi /etc/xinetd.conf
service ftp
{
        socket_type             = stream
        wait                    = no
        user                    = root
        server                  = /usr/sbin/vsftpd
        log_on_success          += DURATION USERID
        log_on_failure          += USERID
        nice                    = 10
        disable                 = no
}
```

停止vsftpd，启动xinetd

```
sudo service vsftpd stop
sudo service xinetd start
```

查看端口

```
$ sudo netstat -npltu | grep 21
tcp        0      0 0.0.0.0:21              0.0.0.0:*               LISTEN      16787/xinetd  
```

## /etc/vsftpd.conf

```
listen=<YES/NO> :设置为YES时vsftpd以独立运行方式启动，设置为NO时以xinetd方式启动（xinetd是管理守护进程的，将服务集中管理，可以减少大量服务的资源消耗）
listen_port=<port> :设置控制连接的监听端口号，默认为21
listen_address=<ip address> :将在绑定到指定IP地址运行，适合多网卡
connect_from_port_20=<YES/NO> :若为YES，则强迫FTP－DATA的数据传送使用port 20，默认YES
pasv_enable=<YES/NO> :是否使用被动模式的数据连接，如果客户机在防火墙后，请开启为YES
pasv_min_port=<n>
pasv_max_port=<m> :设置被动模式后的数据连接端口范围在n和m之间,建议为50000－60000端口
message_file=<filename> :设置使用者进入某个目录时显示的文件内容，默认为 .message
dirmessage_enable=<YES/NO> :设置使用者进入某个目录时是否显示由message_file指定的文件内容
ftpd_banner=<message> :设置用户连接服务器后的显示信息，就是欢迎信息
banner_file=<filename> :设置用户连接服务器后的显示信息存放在指定的filename文件中
connect_timeout=<n> :如果客户机连接服务器超过N秒，则强制断线，默认60
accept_timeout=<n> :当使用者以被动模式进行数据传输时，服务器发出passive port指令等待客户机超过N秒，则强制断线，默认60
accept_connection_timeout=<n> :设置空闲的数据连接在N秒后中断，默认120
data_connection_timeout=<n> : 设置空闲的用户会话在N秒后中断，默认300
max_clients=<n> : 在独立启动时限制服务器的连接数，0表示无限制
max_per_ip=<n> :在独立启动时限制客户机每IP的连接数，0表示无限制（不知道是否跟多线程下载有没干系）
local_enable=<YES/NO> :设置是否支持本地用户帐号访问
guest_enable=<YES/NO> :设置是否支持虚拟用户帐号访问
write_enable=<YES/NO> :是否开放本地用户的写权限
local_umask=<nnn> :设置本地用户上传的文件的生成掩码，默认为077
local_max_rate<n> :设置本地用户最大的传输速率，单位为bytes/sec，值为0表示不限制
local_root=<file> :设置本地用户登陆后的目录，默认为本地用户的主目录
chroot_local_user=<YES/NO> :当为YES时，所有本地用户可以执行chroot
chroot_list_enable=<YES/NO> 
chroot_list_file=<filename> :当chroot_local_user=NO 且 chroot_list_enable=YES时，只有filename文件指定的用户可以执行chroot
anonymous_enable=<YES/NO> :设置是否支持匿名用户访问
anon_max_rate=<n> :设置匿名用户的最大传输速率，单位为B/s，值为0表示不限制
anon_world_readable_only=<YES/NO> 是否开放匿名用户的浏览权限
anon_upload_enable=<YES/NO> 设置是否允许匿名用户上传
anon_mkdir_write_enable=<YES/NO> :设置是否允许匿名用户创建目录
anon_other_write_enable=<YES/NO> :设置是否允许匿名用户其他的写权限（注意，这个在安全上比较重要，一般不建议开，不过关闭会不支持续传）
anon_umask=<nnn> :设置匿名用户上传的文件的生成掩码，默认为077

==匿名用户==
先备份
<pre>sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.old
```

打开

```
sudo vi /etc/vsftpd.conf
```

允许匿名访问

```
# Allow anonymous FTP? (Disabled by default)
anonymous_enable=YES
```

### 上传文件

允许匿名上传

```
write_enable=YES
anon_mkdir_write_enable=YES
anon_upload_enable=YES
```

注意2点：

1.匿名用户就是**ftp**，想要匿名用户写入，必须文件夹的权限为ftp可写。

2.匿名用户的根目录不允许**写**，所以根目录的权限绝对不能是ftp可写和**其他用户**可写，如果根目录所有者为ftp的话，所有者的权限也不能写。

所以解决方法是建个单独的public文件夹用于上传文件，设置其为ftp可写或”其他用户可写“

还可建个download文件夹只用于下载，设置其他用户没有写权限便可。

### 重命名、删除文件

开放重命名，删除文件等权限，不开的话没法续传。

```
anon_other_write_enable=YES
```

## 仅能上传，无法下载

```
write_enable=YES
anon_mkdir_write_enable=YES
anon_upload_enable=YES
chown_uploads=YES
chown_username=root
```

上传的文件所有者被改为root，匿名用户的ftp用户就无法读取，下载了。

## 认证FTP配置

设定vsftp认证系统用户，并允许他们上传文件，编辑 /etc/vsftpd.conf：

```
local_enable=YES
write_enable=YES
```

重启vsftp

```
sudo service vsftpd restart
```

系统用户登录ftp便进入他们的home目录

## Chroot

### 限制所有

限制登录用户访问其他目录，改之前登录显示的路径比如是 ~ ，改之后则是 /。

```
效果是像这样的。
注：我的本地用户(local user为yeshuai,home directory为/home/yeshuai)


root@ubuntu:~# ftp localhost
Connected to localhost.
220 (vsFTPd 2.3.2)
Name (localhost:yeshuai): yeshuai

331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> 
ftp> pwd
'''257 "/"'''

看上边，正常情况下，输入pwd时，应该是显示/home/yeshuai.
由于我做了chroot.所以，/home/yeshuai变成 /
chroot_local_user=YES
```

### 开放所有，限制特定

可指定一组用户限制

```
chroot_local_user=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
```

随后创建列表

```
sudo vi  /etc/vsftpd.chroot_list
```

一行一个用户名 重启vsftp

```
sudo service vsftpd restart
```

### 限制所有，开放特定

上面的规则是限制 /etc/vsftpd.chroot_list 中的用户，反过来限制一切，只解禁 /etc/vsftpd.chroot_list 的用户。这样：

```
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
```

## 账号登录

### /etc/ftpusers文件

该文件内的用户一律禁止ftp连接，默认列表包括了root, daemon, nobody等。需要禁止某个用户，添加进来便是。

这个文件是由PAM模块的 /etc/pam.d/vsftpd 指定的

```
qii@ubuntu:~$ sudo cat /etc/pam.d/vsftpd
# Standard behaviour for ftpd(8).
auth    required        pam_listfile.so item=user sense=deny file=/etc/ftpusers onerr=succeed

# Note: vsftpd handles anonymous logins on its own. Do not enable pam_ftp.so.

# Standard pam includes
@include common-account
@include common-session
@include common-auth
auth    required        pam_shells.so
```

### userlist_file 文件

vsftpd自订的列表，跟/etc/ftpusers类似，具体文件名和路径是由用户自己指定的。这边设成 /etc/vsftpd.user_list

添加配置文件字段：

```
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd.user_list
```

### 限制一切，开放特定

上述2个方法都是限制列表文件中的用户，如果要反过来，限制一切用户登录，只允许列表文件中的用户，用 userlist_file，这样：

```
userlist_enable=YES
userlist_deny=NO
```

### root登录

之所以限制root这类账号登录就是托上面几个文件，要是你非要用系统账号登录，如上所述，将列表文件中的特定用户名删除便是。

## 主机访问

### tcp_wrappers配置

stand alone模式下提供基于主机的访问控制的配置

tcp_wrappers使用/etc/hosts.allow和/etc/hosts.deny两个配置文件实现访问控制，hosts.allow是一个许可表，hosts.deny是一个拒绝表 在hosts.allow中也可以使用DENY,所以通常可以只使用hosts.allow来实现访问控制。 对vsftpd而言，书写hosts.allow有三种语法形式

```
1： vsftpd:主机表 （设置允许访问的主机表）
2： vsftpd:主机表:DENY （设置拒绝访问的主机表）
3： vsftpd:主机表:setenv VSFTPD_LOAD_CONF 配置文件名 （对指定的主机使用另外的配置）
```

setenv VSFTPD_LOAD_CONF的值为指定的配置文件名，意图是让vsftpd守护进程读取新的配置项来覆盖主配置文件中的项，实现特定待遇 这有一个小例子来说明tcp_wrappers

```
功能：
》1.拒绝192.168.2.0/24访问
》2.对192.168.1.0/24内的所有主机不作连接限制和最大传输速率限制
》3.对其他主机的访问限制为：每ip连接数为1，最大传输速率为10kb/s (在主配置文件中设置就好了)
```

首先保证设定

```
tcp_wrappers=YES
```

然后编辑

```
sudo vi /etc/hosts.allow 
vsftpd:192.168.2.0/24: DENY （阻止192.168.2.0子网的访问）
vsftpd:192.168.1.0/24 （允许192.168.1.0子网的访问）
vsftpd:192.168.1.0/24: setenv VSFTPD_LOAD_CONF /etc/xxx.conf (对192.168.1.0/24指定专有配置文件xxx.conf，xxx可以自己指定文件名，需要建立)
```

然后建立xxx.conf文件，并编辑 （建立文件可以用sudo touch /etc/xxx.conf建立）

### super daemon限制主机访问

#### 只允许指定主机访问

在配置文件/etc/xinetd.d/vsftpd的｛｝中添加如下的配置语句：

```
only_from <主机表> 
```

如 only_from 192.168.1.0 表示只允许192.168.1.0网段内的主机访问。

#### 指定不能访问的主机

```
no_access <主机表> 
```

如：no_access 192.168.1.0 表示只有192.168.1.0网段内的主机不能访问。

#### 主机表

关于主机表的书写形式，见下表：

访问控制表时主机表的书写语法 

```
选项值 含义 
Hostname 可解析的主机名 
IP Address 十进制表示的IP地址 
Net_name 在/etc/networks中定义的网络名 
x.x.x.0 x.x.0.0 x.0.0.0 0.0.0.0 0作为通配符看待。如：191.72.61.0匹配从191.72.61.0到191.72.61.255的所有IP地址。0.0.0.0表示匹配所有的IP地址 
x.x.x.{a,b,.} x.x.{a,b,.} x.{a,b,.} 指定主机表。如：191.72.61.{1,3,123}表示包含地址191.72.61.1、191.72.61.2和191.72.61.123 
IPAddress/netmask 定义要匹配的网络或子网。如：172.19.16/20匹配从172.19.16.0到172.19.31.255 
```

## 限制

### 限制连接数

前者为服务器最大支持连接数，后者为每个ip允许最多连接数。

```
max_clients=数字
max_per_ip=数字
```

错误提示分别是

```
qii@ubuntu:~$ ftp localhost 
Connected to localhost.
421 There are too many connected users, please try later.
qii@ubuntu:~$ ftp localhost 
Connected to localhost.
421 There are too many connections from your internet address.
```

### 限制下载速度

单位是字节，所以需要换算。比如我想让匿名用户和vsFTP上的用户都以80KB下载，所以这个数字应该是1024x80=81920

```
anon_max_rate=数字 #匿名用户下载速度
local_max_rate=数字 #普通用户下载速度
```

### super daemon限制连接数

instances 是服务器最多的连接数，per_source 是单个IP地址最多的连接数。

```
service ftp
{
        socket_type             = stream
        wait                    = no
        user                    = root
        server                  = /usr/sbin/vsftpd
        server_args             = /etc/vsftpd.conf 
        log_on_success          += DURATION USERID
        log_on_failure          += USERID
        nice                    = 10
        disable                 = no
        per_source              = 10   
        instances               = 10  
}
```

错误提示都是

```
qii@ubuntu:~$ ftp localhost 
Connected to localhost.
421 Service not available, remote server has closed connection
```

定制错误提示，添加

```
banner_fail       = /etc/vsftpd.busy_banner
```

编辑提示内容

```
sudo vi /etc/vsftpd.busy_banner
```

比如

```
qii@ubuntu:~$ ftp localhost 
Connected to localhost.
服务器大姨妈中
```

## 欢迎信息

```
dirmessage_enable=YES
```

然后编辑各用户home目录下的.message

```
vi .message
qii@ubuntu:~$ cat .message 
欢迎来到vsftpd
qii@ubuntu:~$ ftp localhost 
Connected to localhost.
220 (vsFTPd 2.2.2)
Name (localhost:qii): qii
331 Please specify the password.
Password:
230-欢迎来到vsftpd
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> 
```

若是匿名用户，就放到

```
/var/ftp
```

## 虚拟路径

比如我的ftp的默认目录是/srv/ftp，我想把/mnt/LinG/WinSoft文件夹，映射到/srv/ftp目录中，我就如下操作 命令：

```
#mount --bind [原有的目录] [新目录]
```

先创建文件夹

```
sudo mkdir /srv/ftp/WinSoft
```

执行mount命令

```
sudo mount --bind /mnt/LinG/WinSoft /srv/ftp/WinSoft
```

## 虚拟用户

- [Vsftpd虚拟用户设置](https://wiki.ubuntu.org.cn/Vsftpd虚拟用户设置)
- [Vsftpd和mysql配置](https://wiki.ubuntu.org.cn/Vsftpd和mysql配置)

## 实例

- [Vsftpd实例](https://wiki.ubuntu.org.cn/Vsftpd实例)
- [Vsftpd实例2(oneleaf的vsftpd配置)](https://forum.ubuntu.com.cn/viewtopic.php?f=24&t=23873)

## 缺陷

Vsftpd的**虚拟用户**无法实现磁盘限额，系统用户倒是可以用quota工具实现磁盘限额。

## 参考

[vsftpd参考小手册](https://forum.ubuntu.com.cn/viewtopic.php?f=54&t=117505)

 

# 四、运行，登录

useradd test

passwd test

ftp localhost

输入账号密码，成功登录。

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/44e24dc8b5514f51b36171f7683cfcde.jpeg)

# 五、局域网测试

Centos下的网卡设置是在/etc/sysconfig/network-s/这个文件夹下，进入该文件夹，前缀为ifcfg-后面跟的就是网卡的名称。

默认的话是开启dhcp的，首先把BOOTPROTO="dhcp"改成BOOTPROTO="static"表示静态获取。之后在写进以下配置：

IPADDR=192.168.1.6

NETMASK=255.255.255.0

GATEWAY=192.168.1.1

DNS1=192.168.1.1

BROADCAST设置的是局域网广播地址，IPADDR就是静态IP，NETMASK是子网掩码， GATEWAY就是网关或者路由地址，DNS就是域名系统地址， 这里用的就是本地网关，也可以设置其它，比如谷歌、360DNS地址。

systemctl restart network //重启网络服务

ip addr或者ifconfig //查看ip地址

接下来在windows平台用FileZilla Client软件登陆。

这里有些朋友会使用虚拟机测试，但是按照上面配置后发现连接不了，那是因为**虚拟机的网络连接模式**的影响。这里有一个简单的方法，就是直接获取虚拟机里面系统的ip地址，然后在FileZilla客户端填入。

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/d6efb47f014e4430ab5d489a1b327b8c.png)

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/d3a64c5e139548eab3395d453ac3526c.png)

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/dcac8481cfe448dab7ce2d7080cfcd82.png)

系统账号默认登陆是在账号的家目录，可以切换到其它目录。

到这里，基本的vsftpd搭建成功。

# 六、认识vsftpd配置文件vsftpd.conf

主程序：/usr/sbin/vsftpd

主配置文件：/etc/vsftpd/vsftpd.conf

数据根目录：/var/ftp

就算是经验丰富的老手也会做好备份工作

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/f59ec7df032e4501af174a39cbde57fe.png)

anonymous_enable=NO //设定不允许匿名访问

local_enable=YES //设定本地用户可以访问

write_enable=YES //设定可以进行写操作

local_umask=022 //设定上传后文件的权限掩码

anon_upload_enable=NO //禁止匿名用户上传

anon_mkdir_write_enable=NO //禁止匿名用户建立目录

dirmessage_enable=YES //设定开启目录标语功能

xferlog_enable=YES //设定开启日志记录功能

connect_from_port_20=YES //设定端口20进行数据连接(主动模式)

chown_uploads=NO //设定禁止上传文件更改宿主

\#chown_username=whoever

xferlog_file=/var/log/xferlog //设定Vsftpd的服务日志保存路径。

xferlog_std_format=YES //设定日志使用标准的记录格式。

\#idle_session_timeout=600 //设定空闲连接超时时间，单位为秒，这里默认

\#data_connection_timeout=120 //设定空闲连接超时时间，单位为秒，这里默认。

\#nopriv_user=ftptest

async_abor_enable=YES //设定支持异步传输功能。

ascii_upload_enable=YES

ascii_download_enable=YES //设定支持ASCII模式的上传和下载功能。

ftpd_banner=Welcome to blah FTP service. //设定Vsftpd的登陆标语。

\#deny_email_enable=YES // (default follows)

\#banned_email_file=/etc/vsftpd/banned_emails

chroot_local_user=YES

chroot_list_enable=YES //禁止用户登出自己的FTP主目录。

chroot_list_file=/etc/vsftpd/chroot_list //这个文件里的用户不受限制，不限制在本目录。

ls_recurse_enable=NO //禁止用户登陆FTP后使用"ls -R"的命令。

该命令会对服务器性能造成巨大开销。

\#listen=NO

\#listen_ipv6=YES

userlist_enable=YES //设定userlist_file中的用户将不得使用FTP。

tcp_wrappers=YES //设定支持TCP Wrappers

allow_writeable_chroot=YES //这个可以解决chroot权限问题

systemctl restart vsftpd //重启vsftpd服务

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/e6ebf0807b154addaae2f64b9b33a926.png)

**注意，“/”在这里就是用户账号的家目录，并不是系统的根目录。**

# 七、vsftpd虚拟用户的使用

vsftpd提供了三种认证方式，分别是：匿名用户认证、本地用户认证和虚拟用户认证。上面test用户就是本地用户。从安全的角度来说，虚拟用户最安全，接下来，我们开始配置虚拟用户。

虚拟用户配置步骤:

1） 建立虚拟FTP用户数据库文件。

2） 创建FTP根目录及虚拟用户映射的系统用户。

3） 建立支持虚拟用户的PAM认证文件。

4） 在vsftpd.conf中添加支持配置。

5） 为虚拟用户设置权限。

6） 虚拟账号登录。

1.建立虚拟FTP用户数据库文件

建立一个虚拟用户名单文件，这个文件就是来记录vsftpd虚拟用户的用户名和口令的数据文件，我这里给它命名为vuser.list，保存在/etc/vsftpd/目录下。

vim vuser.list

一行账号，一行密码

vuser

123456

安装Berkeley DB

yum install db4*

安装后

db_load -T -t hash -f vuser.list vuser.db//生成用户加密文件

chmod 600 vuser.db //敏感文件限制只允许属主读写

2.创建虚拟用户及虚拟用户的家目录

useradd -d /var/vusers -s /sbin/nologin vftp //创建系统用户vftp，并制定其家目录为/var/vusers

chmod -Rf 755 /var/vusers/ //修改目录的权限使得其他用户也可以访问。

3.建立支持虚拟用户的PAM认证文件

vsftpd的pam文件在/etc/pam.d/目录下，先做备份工作。

cp vsftpd vsftpd.bakvim vsftpd

先注释掉所有的内容后添加以下内容：

auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser //此句用于检查用户密码，数据库文件不要写后缀.db

account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser //此句用于检查用户是否在有效期内，数据库支持虚拟用户的PAM认证文件。

4.在vsftpd.conf中添加支持配置

guest_enable=YES //开启虚拟用户模式

guest_username=vftp //指定虚拟用户账号

pam_service_name=vsftpd.virtual //指定pam文件

user_config_dir=/etc/vsftpd/vusers_profile //指定虚拟用户的权限配置目录。

virtual_use_local_privs=NO //虚拟用户和匿名用户有相同的权限

5.为虚拟用户设置不同的权限。

mkdir /etc/vsftpd/vusers_profile //新建虚拟用户目录

vim /etc/vsftpd/vusers_profile/vuser//新建虚拟用户配置文件，文件名要和上面的虚拟用户名单里的账号名字对等。

local_root=/var/vusers/vuser //虚拟账号的家目录

anonymous_enable=NO

local_umask=022

anon_upload_enable=YES //上传权限

anon_mkdir_write_enable //创建文件和目录的权限

anon_other_write_enable //删除文件和目录的权限

anon_world_readable_only=YES //当文件的“其他人”有读权限的时候可以下载

download_enable=YES //下载权限

保存配置，重启服务。

systemctl restart vsftpd

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/4c65bbcdaea040c9a22187f82df49e5d.png)

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/13d4d4a43f79414a98b731117cdf5550.png)

# 八、认识vsftpd传输模式

主动模式

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/ed0daa174ee7401ebdf3ccf58567a63f.png)

在主动模式下，FTP客户端从任意端口5150（端口号>1023）发起一个FTP请求，并携带自己监听的端口号5151（发送的端口号+1=监听端口号）；随后服务器返回确认，然后从服务器本地的20端口主动发起连接请求到客户端的监听端口5151，最后客户端返回确认。

被动模式

![img](http://5b0988e595225.cdn.sohucs.com/images/20181210/792901b1ae4645369f86224998b8c093.png)

在被动模式中，命令连接和数据连接都由客户端来发起，如上图所示，客户端用随机命令端口5150向服务器的21命令端口发送一个PASV请求，然后服务器返回数据端口3267，告诉客户端我在哪个端口监听数据连接。然后客户端向服务器的监听端口3268发起数据连接，最后服务器回复确认。

**vsftpd默认是被动模式。**所以客户端要设置被动模式连接，如果到现在还没连接成功的看客户端有没有设置被动传输模式。

# 九、500 OOPS:priv_sock_get_cmd错误

网上很多说是selinux设置问题，我按照他们的都改了，但是还是不行。最后我发现问题是出在pam文件里。

auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser

account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser

如果你是64位，你需要添加的**/lib64/**,我遇到的问题就这么的解决了。

如果哪里有写错的，请指出来,谢谢。



**一、FTP简介
**File Server:ftp,nfs,samba
   ftp:file transfer Protocol,21/tcp,20/tcp
   明文协议:认证以及数据传输都是明文
**1.服务端和client端实现   
**服务端:vsftpd,pureftpd,proftpd,..,FileZilla Server
客户端实现:
   Linux:ftp,lftp
   windows:cureftp,filezilla,Flashfxp
**2.ftp的传输模式：ASCII传输模式和二进制数据传输模式。
**   1.ASCII传输方式：假定用户正在拷贝的文件包含的简单ASCII码文本，如果在远程机器上运行的不是UNIX，当文件传输时ftp通常会自动地调整文件的内容以便于把文件解释成另外那台计算机存储文本文件的格式。
   2.二进制模式：在二进制传输中，保存文件的位序，以便原始和拷贝的是逐位一一对应的。
**3.FTP的工作模式
**   FTP支持两种模式，一种方式叫做Standard (也就是 PORT方式，主动方式)，一种是 Passive (也就是PASV，被动方式)。 Standard模式 FTP的客户端发送 PORT 命令到FTP服务器。Passive模式FTP的客户端发送 PASV命令到 FTP  Server。
   //21为命令端口，20位数据端口
Port模式：主动模式
   1.被动模式：c用任意的非特殊端口（N>1023）向服务器端（21）发送数据传输请求。
     然后c监听在N+1(N+1>1024),并通过N+1端口发送命令给s。服务器反过来会连接c的端口。
     服务器端端口:半随机,不再固定使用20/tcp,服务器在响应c命令连接请求的时候，已经回复本次通信使用的端口
   FTP服务器命令（21）端口接受客户端任意端口（客户端初始连接）
   FTP服务器命令（21）端口到客户端端口（>1023）（服务器响应客户端命令）
   FTP服务器数据（20）端口到客户端端口（>1023）（服务器初始化数据连接到客户端数据端口）
   FTP服务器数据（20）端口接受客户端端口（>1023）（客户端发送ACK包到服务器的数据端口）
如图一：
![vsftpd详解_ftp](http://s1.51cto.com/images/20180124/1516805917172223.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)  

  在第1步中，客户端的命令端口与FTP服务器的命令端口建立连接，并发送命令“PORT  1027”。然后在第2步中，FTP服务器给客户端的命令端口返回一个"ACK"。在第3步中，FTP服务器发起一个从它自己的数据端口（20）到客户端先前指定的数据端口（1027）的连接，最后客户端在第4步中给服务器端返回一个"ACK"。
   主动方式FTP的主要问题实际上在于客户端。FTP的客户端并没有实际建立一个到服务器数据端口的连接，它只是简单的告诉服务器自己监听的端口号，服务器再回来连接客户端这个指定的端口。对于客户端的防火墙来说，这是从外部系统建立到内部客户端的连接，这是通常会被阻塞的。

Pasv模式：被动模式 //当客户端通知服务器它处于被动模式时才启用。
   当开启一个FTP连接时，c打开两个任意的非特权本地端口（N >;  1024和N+1）。第一个端口连接服务器的21端口，但与主动方式的FTP不同，c不会提交PORT命令并允许服务器来回连它的数据端口，而是提交PASV命令。这样做的结果是服务器会开启一个任意的非特权端口（P >; 1024），并发送PORT P命令给客户端。然后客户端发起从本地端口N+1到服务器的端口P的连接用来传送数据。   
   FTP服务器命令（21）端口接受客户端任意端口（客户端初始连接）
   FTP服务器命令（21）端口到客户端端口（>1023）（服务器响应客户端命令）
   FTP服务器数据端口（>1023）接受客户端端口（>1023）（客户端初始化数据连接到服务器指定的任意端口）
   FTP服务器数据端口（>1023）到客户端端口（>1023）（服务器发送ACK响应和数据到客户端的数据端口）
如图二：

![vsftpd详解_ftp_02](http://s1.51cto.com/images/20180124/1516805937201420.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)  

  在第1步中，客户端的命令端口与服务器的命令端口建立连接，并发送命令“PASV”。然后在第2步中，服务器返回命令"PORT  2024"，告诉客户端（服务器）用哪个端口侦听数据连接。在第3步中，客户端初始化一个从自己的数据端口到服务器端指定的数据端口的数据连接。最后服务器在第4 步中给客户端的数据端口返回一个"ACK"响应。
　　被动方式的FTP解决了客户端的许多问题，但同时给服务器端带来了更多的问题。最大的问题是需要允许从任意远程终端到服务器高位端口的连接。幸运的是，许多FTP守护程序，包括流行的WU-FTPD允许管理员指定FTP服务器使用的端口范围。详细内容参看附录1。 
　　第二个问题是客户端有的支持被动模式，有的不支持被动模式，必须考虑如何能支持这些客户端，以及为他们提供解决办法。例如，Solaris提供的FTP命令行工具就不支持被动模式，需要第三方的FTP客户端，比如ncftp。

下面是主动与被动FTP优缺点的简要总结： 
　　主动FTP对FTP服务器的管理有利，但对客户端的管理不利。因为FTP服务器企图与客户端的高位随机端口建立连接，而这个端口很有可能被客户端的防火墙阻塞掉。被动FTP对FTP客户端的管理有利，但对服务器端的管理不利。因为客户端要与服务器端建立两个连接，其中一个连到一个高位随机端口，而这个端口很有可能被服务器端的防火墙阻塞掉。
　　幸运的是，有折衷的办法。既然FTP服务器的管理员需要他们的服务器有最多的客户连接，那么必须得支持被动FTP。我们可以通过为FTP服务器指定一个有限的端口范围来减小服务器高位端口的暴露。这样，不在这个范围的任何端口会被服务器的防火墙阻塞。虽然这没有消除所有针对服务器的危险，但它大大减少了危险。   

主动FTP：
   命令连接：客户端 >1023端口 -> 服务器 21端口
   数据连接：客户端 >1023端口 <- 服务器 20端口 
被动FTP：
   命令连接：客户端 >1023端口 -> 服务器 21端口
   数据连接：客户端 >1023端口 -> 服务器 >1023端口 
ftp缺陷:
   1.支持系统用户，可能导致数据泄露
   2.明文传输

**二、vsftp介绍
**vsftpd:very secure ftp daemon
用户:资源位于用户的家目录下
   匿名用户(映射到某一固定的系统用户)：例如ftp,vsftpd /目标访问的资源，就是用户的家目录,/var/ftp
   本地用户(系统用户);root及系统用户(0-999);每个用户都可以通过ftp访问自己的家目录
   虚拟用户()

中间框架:
   名称解析:nsswitch(name service switch)名称服务转换 //数字名称和字符串名称中间的转换，例如uid和用户名的转换，port和protocol等
   密码认证:pam(plugable authentication modules) 
vsftpd实现的名称解析，借助于pam实现，但是httpd不是
   ssh就支持pam，vsftpd也支持pam，不是必须得使用pam

**1.安装
**yum install vsftpd -y
id ftp //家目录是/var/ftp ,是系统用户
程序:/usr/sbin/vsftpd
配置文件:/etc/vsftpd/vsftpd.conf
CentOS 6:
   /etc/rc.d/vsftpd
CentOS 7:
   /usr/lib/systemd/system/vsftpd.service
   systemctl enable vsftpd
   systemctl start vsftpd
浏览器:ftp://192.168.4.118/
lftp:lftp -u wolf,wolf 192.168.4.118 //默认用户可以直接登录自己的家目录
   lcd /etc/
   put fstab //可以直接上传文件

配置：/etc/vsftpd/vsftpd.conf
1)匿名服务器的连接

```bash
anonymous_enable=yes (允许匿名登陆)
dirmessage_enable=YES //切换目录显示的提示信息，默认该目录下的".message"
message_file   //可以手动指定消息文件，lftp命令不会显示，ftp命令可以显示
local_umask=022 (FTP上本地的文件权限，默认是077)
connect_from_port_20=YES //服务器是否能够工作于主动模式,并不影响真正使用的模式，服务器工作于主动还是被动，取决于client端 *
xferlog_enable=yes （激活上传和下传的日志）
xferlog_std_format=yes (使用标准的日志格式)
ftpd_banner=XXXXX （欢迎信息）
pam_service_name=vsftpd （验证方式）*
listen=yes （独立的VSFTPD服务器）*
listen_ipv6=YES1.2.3.4.5.6.7.8.9.10.11.
```

功能：只能连接FTP服务器，不能上传和下传
注：其中所有和日志欢迎信息相关连的都是可选项,打了星号的无论什么帐户都要添加，是属于FTP的基本选项

2)开启匿名FTP服务器上传权限

```bash
Anon_upload_enable=yes (开放上传权限) //即使启用了也不会生效，因为/var/ftp/的属主和属组是root，只有属主有写权限    ，匿名使用的是ftp用户的权限
    //修改fs权限，即可setfacl,或者修改目录的权限,//setfacl -m u:ftp:rwx /var/ftp/anon,或者
anon_mkdir_write_enable=yes （可创建目录的同时可以在此目录中上传文件）
write_enable=yes (开放本地用户写的权限)
anon_other_write_enable=yes (匿名帐号可以有删除的权限)1.2.3.4.5.
```

3)开启匿名服务器下传的权限
anon_world_readable_only=no //只读
注：要注意文件夹的属性，匿名帐户是其它（other）用户要开启它的读写执行的权限
（R）读-----下传 （W）写----上传 （X）执行----如果不开FTP的目录都进不去 

4)普通用户FTP服务器的连接（独立服务器）

```bash
local_enble=yes （本地帐户能够登陆） //所有非匿名用户和虚拟用户，要想能使用，必须启用该项
write_enable=no （本地帐户登陆后无权删除和修改文件）
local_umask=022 //本地用户上传文件的权限，匿名用户上传文件的权限默认是umask=077
write_enable=YES //全局配置1.2.3.4.
```

功能：可以用本地帐户登陆vsftpd服务器，有下载上传的权限
注：在禁止匿名登陆的信息后匿名服务器照样可以登陆但不可以上传下传 

5)用户登陆限制进其它的目录，只能进它的主目录

```bash
chroot_local_user=yes （本地所有帐户都只能在自家目录） //禁锢所用本地用户，注意要求用户对家目录不能有写权限，ftp也是如此
设置指定用户执行chroot
chroot_list_enable=yes （文件中的名单可以调用）// 这两项不用同时使用
chroot_list_file=/任意指定的路径/vsftpd.chroot_list  
    #chroot_list_file=/etc/vsftpd/chroot_list //文件中，只需要写用户名即可1.2.3.4.5.
```

注意：vsftpd.chroot_list 是没有创建的需要自己添加，要想控制帐号就直接在文件中加帐号即可 

6)限制本地用户访问FTP

```bash
userlist_enable=YES    //启用时，vsftpd将加载一个由userlist_指令指定的用户列表文件；此文件中的用户是否能访问vsftpd服务取决于userlist_deny指令
                    //默认为NO
userlist_deny=no (名单中的人不允许访问)
userlist_file=/指定文件存放的路径/ （文件放置的路径）1.2.3.4.
```

注：开启userlist_enable=yes匿名帐号不能登陆 

7)安全选项

```bash
idle_session_timeout=600(秒) （用户会话空闲后10分钟）
data_connection_timeout=120（秒） （将数据连接空闲2分钟断）
accept_timeout=60（秒） （将客户端空闲1分钟后断）
connect_timeout=60（秒） （中断1分钟后又重新连接）
local_max_rate=50000（bite） （本地用户传输率50K） //0表示不受限制
anon_max_rate=30000（bite） （匿名用户传输率30K）
pasv_min_port=50000 （将客户端的数据连接端口改在
pasv_max_port=60000 50000—60000之间）
max_clients=200 （FTP的最大连接数）
max_per_ip=4 （每IP的最大连接数）
listen_port=5555 （从5555端口进行数据连接）//默认211.2.3.4.5.6.7.8.9.10.11.
```

8)修改匿名用户上传的文件属性

```bash
#chown_uploads=YES     //是否更改
#chown_username=whoever //启用chown_uploads指令时，将文件的属主修改为指定的用户，默认是root用户    
chown_uploads_mode //匿名用户上传的文件的权限，默认06001.2.3.
```

9)日志信息:

```bash
xferlog_enable=YES//默认/var/log/vsftpd.log
xferlog_file=/var/log/xferlog //指定日志目录，传输日志
xferlog_std_format=YES //是否使用，默认日志记录格式
vsftpd_log_file= 定义默认日志记录位置1.2.3.4.
```

10)其他

```bash
#nopriv_user=ftpsecure    
#nopriv_user=ftpsecure    
#async_abor_enable=YES    
#ascii_upload_enable=YES   //设定以anscii上传，和下载
#ascii_download_enable=YES
#deny_email_enable=YES    //拒绝使用邮箱登录
#banned_email_file=/etc/vsftpd/banned_emails //邮箱登录的标语    
#ls_recurse_enable=YES    listen=NO  //enable将使用独立守护进程
pam_service_name=vsftpd
    userlist_deny=YES //表示此列表(user_list)为黑名单,默认为YES,默认文件/etc/vsftpd/user_list
    userlist_deny=NO //表示此列表(user_list)为白名单
userlist_file  //默认为/etc/vsftpd/user_list,
    # If userlist_deny=NO, only allow users in this file
    # If userlist_deny=YES (default), never allow users in this file
        用户列表,/etc/vsftpd/user_list,和ftpusers
        //ftpuser:是黑名单，禁止用户登录名单,user_list:是允许登录的用户1.2.3.4.5.6.7.8.9.10.11.12.13.14.15.16.
```

tcp_wrappers=YES
   查看man vsftpd.conf 查看所有配置指令

tcpwrapper
   任何以xinetd管理的服务都可以通过TcpWrapper来设置防火墙。
   ldd ｀which sshd ` | grep wrap
   可以看出ssh服务确实添加了wrapper模块。
   /etc/hosts.allow 、/etc/hosts.deny 这两个文件的关系为allow文件优先，
     若分析到的没有记录在allow文件当中，则以deny文件来判断。
   daemon list : client list [:option[:option]]
   例如：telnet
  in.telnetd(进程名字) : 10.0.0.66 : spawn echo 'date' %c to %s >/var/log/wra.log

**三、实验
****实验一：修改默认ftp监听端口号
**1、编辑/etc/vsftpd/vsftpd.conf 文件，在该配置文件中添加此行：listen_port=811
2、编辑/etc/services 文件，将其中的
ftp 21/tcp 改为 ftp 811/tcp ,
ftp 21/udp 改为 ftp 811/tcp
3、执行/etc/init.d/vsftpd restart 重新启动vsftpd 服务。启动完成后可以使用
netstat -tnulp | grep vsftpd

**实验二：匿名用户启用
**anonymous_enable=yes
anon_upload_enable=YES
anon_mkdir_write_enable=YES
并且chmod a+wx 对其他人对该目录有写入的权限

**实验三：Localuser
**chroot_local_user=yes #是否将所有用户限制在主目录,YES为启用 NO禁用.(该项默认值是NO,即在安装vsftpd后不做配置的话，ftp用户是可以向上切换到要目录之外的)
或者如下两个指令都可以实现chroot本地用户，但是对于lcd命令无效，限制的是cd命令
chroot_list_enable #是否启动限制用户的名单 YES为启用 NO禁用(包括注释掉也为禁用)
chroot_list_file=/etc/vsftpd/chroot_list #是否限制在主目录下的用户名单，至于是限制名单还是排除名单，这取决于chroot_local_user的值，我们可以这样记忆：  chroot_local_user总是一个全局性的设定，其为YES时，全部用户被锁定于主目录，其为NO时，全部用户不被锁定于主目录。那么我们势必需要在全局设定下能做出一些“微调”，即，我们总是需要一种“例外机制"，所以当chroot_list_enable=YES时，表示我们“需要例外”。而”例外“的含义总是有一个上下文的，即，当”全部用户被锁定于主目录“时（即chroot_local_user=YES），"例外"就是：不被锁定的用户是哪些；当"全部用户不被锁定于主目录"时（即chroot_local_user=NO），"例外"“就是：要被锁定的用户是哪些。这样解释和记忆两者之间的关系就很清晰了！
如图：

问题：Login failed: 500 OOPS: vsftpd: refusing to run with writable root inside chroot()
allow_writeable_chroot=YES //添加这个选项


**四、虚拟用户
**虚拟用户:
   1.基于db文件来存放 
     奇数行:用户名
     偶数行:密码
   2.基于mysql服务
     //vsftpd实现用户认证，需要基于pam实现，但是pam不支持到mysql中
     /lib64/security/目录中有很多pam模块，并没有pam关于mysql的库
     pam-mysql.sourceforge.net

**1.安装pam-mysql驱动
**   yum -y install pam-devel mariadb-server mariadb-devel openssl-devel
   //pam链接msyql的时候，可能需要ssl进行链接
   ./configure --with-mysql=/usr/local/mysql --with-openssl --with-pam=/usr --with-pam-mods-dir=/usr/lib64/security/
   make && make install
   ls /usr/lib64/security/ //将会生成pam_mysql.so,pam_mysql.la

**2.配置vsftpd
**1）配置mariadb，
   vsftpd库:
   MariaDB [vsftpd]> create table users (
     -> id int auto_increment not null primary key,
     -> name char(30) not null,
     -> password char(48) binary not null );
insert into users (name,password) value ('jerry',password('jerry'));
insert into users (name,password) value ('tom',password('tom'));
grant all privileges on vsftpd.* to 'vsftpd'@'127.0.0.1' identified by 'vsftpdusers';
flush privileges;

mysql -uvsftpd -p -h127.0.0.1

2）配置pam
cat /etc/vsftpd/vsftpd.conf
   pam_service_name=vsftpd.mysql //vsftpd将要使用哪一个pam文件实现认证，相对路径，相对于/etc/pam.d目录
vim /etc/pam.d/vsftpd.mysql //自己建立一个pam文件
   auth required pam_mysql.so user=vsftpd passwd=vsftpdusers  host=127.0.0.1 db=vsftpd table=users usercolumn=name  passwdcolumn=password crypt=2
   account required pam_mysql.so  user=vsftpd passwd=vsftpdusers host=127.0.0.1 db=vsftpd table=users  usercolumn=name passwdcolumn=password crypt=2
   //一个用于验证账户，一个验证密码，都必须满足才通过认证，编译目录中有README文件说明了用法

创建一个系统用户，用来映射虚拟用户
useradd -s /sbin/nologin -d /ftproot vuser
chmod go+rx /ftproot/  //让其他用户能读

3）修改配置文件：
vim /etc/vsftpd/vsftpd.conf
   pam_service_name=vsftpd.mysql
   guest_enable=YES //启动来宾账户
   guest_username=vuser  

   anonymous_enable=YES //这几个都保证yes，这样用于虚拟账户才能用
   local_enable=YES
   write_enable=YES
systemctl restart vsftpd
   chmod -w /ftproot/
注:实验中虚拟用户，只能使用没有写权限的/ftproot
   虚拟用户用的是匿名用户的权限，匿名为vuser
   //匿名用户，也就是来宾用户，需要映射为一个系统用户

**3.匿名用户添加写权限
**   mkdir /ftproot/{pub,upload}
   chown vuser /ftproot/upload/  //fs级别的权限
   vim /etc/vsftpd/vsftpd.conf
     anon_upload_enable=YES
   ftp //tom登录
   cd upload //只有在该目录中有权限
   lcd /etc  
   put fstab //tom和jerry用户都有上传的权限
**4.区分tom和jerry的权限，//不同匿名用户，匿名为同一系统用户，分配不同权限
**   cd /etc/vsftpd/
   vim vsftpd.conf
     anon_upload_enable=YES //关闭该权限
   mkdir vuser.conf.d ;cd vuser.conf.d
   vim tom
     anon_upload_enable=YES
   vim jerry
     anon_upload_enable=NO
   vim ../vsftpd.conf
     user_config_dir=/etc/vsftpd/vuser.conf.d/
   systemctl restart vsftpd
   ftp 192.168.4.118 //分别使用tom和jerry测试
     
小结:
   ftp:命令连接，数据连接(port,pasv)
   vsftpd:/etc/vsftpd/vsftpd.conf
   用户类型:
     匿名用户:
     本地用户:
       禁锢本地用户
       黑名单
       白名单
     虚拟用户
       权限

**实验四：虚拟用户（pam_userdb.so）
**

```bash
[root@localhost vsftpd]# mkdir /etc/vsftpd/virtual/
[root@localhost vsftpd]# touch /etc/vsftpd/vuer.txt
[root@localhost vsftpd]# cat /etc/vsftpd/vuer.txt
ftpuser1
ftpuser1
ftpuser2
ftpuser2
[root@localhost vsftpd]# db_load -T -t hash -f /etc/vsftpd/vuer.txt /etc/vsftpd/vuser.db //yum install db4-utils db4-devel db4-4.3
[root@localhost vsftpd]# vim /etc/pam.d/vsftpd  //之前有的加注释
auth    required    pam_userdb.so    db=/etc/vsftpd/vuser
account    required    pam_userdb.so    db=/etc/vsftpd/vuser
[root@localhost vsftpd]# chmod 700 vuser.db 
[root@localhost vsftpd]# useradd -d /ftpdir vuser
[root@localhost vsftpd]# chown vuser.vuser /ftpdir/
[root@localhost vsftpd]# usermod -s /sbin/nologin vuser
[root@localhost vsftpd]# vim /etc/vsftpd/vsftpd.conf 
guest_enable=YES                ####激活虚拟账户  
guest_username=vuser           ####把虚拟账户绑定为系统账户vuser  
pam_service_name=vsftpd        ####使用PAM验证  
user_config_dir=/etc/vsftpd/vsftpd_user_conf  
设置用户虚拟用户配置文件，与虚拟用户同名
[root@localhost ~]# touch  /etc/vsftpd/vsftpd_user_conf/ftpuser1
[root@localhost ~]# touch  /etc/vsftpd/vsftpd_user_conf/ftpuser2
文件内容：//随意填写
    anon_world_readable_only=NO               ###浏览FTP目录和下载  
    anon_upload_enable=YES                      ###允许上传  
    anon_mkdir_write_enable=YES                ###建立和删除目录  
    anon_other_write_enable=YES                ####改名和删除文件  
    local_root=/ftpdir/                    #### 指定虚拟用户在系统用户下面的路径，限制虚拟用户的家目录，虚拟用户登录后的主目录。
```

vsftpd是什么？

答：ftp（File Transfer Protocol）文件传输协议。（实现不同操作系统之间文件的传输）

vsftpd是一个基于ftp协议的文件传输服务器软件。



问题2：vsftpd作用是什么？

答：传输文件。（跨平台、跨操作系统）



问题3：如何使用？

答：服务端：在linux安装vsftpd软件，开启服务。

客户端：通过FtpClient客户端建立和服务器的连接，向服务器发送请求。



[]**实现步骤说明**]()

（1）在Linux上安装vsftpd服务。

（2）根据图片的地址访问图片。（最终保存到数据库的是图片的路径）

（3）web工程中实现图片上传。

[**实现步骤**]()

[**第一部分：在Linux上部署vsftpd服务**]()

思路：（1）安装软件

（2）测试服务是否可用



**第一步：安装vsftpd软件**

[root@node0719 ~]# yum -y install vsftpd



[**第二步：关闭匿名访问**

修改vsftpd配置文件  vim /etc/vsftpd/vsftpd.conf





**第三步：添加一个FTP用户**

创建一个用户，专门用来访问vsftpd服务。

[root@node0719 ~]# useradd ftpuser

[root@node0719 ~]# passwd ftpuser



**第四步：设置防火墙**

vsftpd服务默认端口号为21，修改防火墙，开放此端口，**重启防火墙。**

[root@node0719 ~]# vim /etc/sysconfig/iptables

[root@node0719 ~]# service iptables restart



**第五步：修改selinux（Linux安全内核系统）**

（1）先查看selinux，默认是禁用了ftp访问的。

[root@bogon ~]# getsebool -a | grep ftp  

allow_ftpd_anon_write --> off

allow_ftpd_full_access --> off

allow_ftpd_use_cifs --> off

allow_ftpd_use_nfs --> off

ftp_home_dir --> off

ftpd_connect_db --> off

ftpd_use_passive_mode --> off

httpd_enable_ftp_server --> off

tftp_anon_write --> off



（2）修改selinux，开放ftp访问权限

[root@bogon ~]# setsebool -P allow_ftpd_full_access on

[root@bogon ~]# setsebool -P ftp_home_dir on



**第六步：启动vsftpd服务**

[root@node0719 vsftpd]# service vsftpd start

为vsftpd 启动 vsftpd：                   [确定]

**第****七****步****：****通过浏览器访问测试**

访问地址：[ftp://192.168.23.12:21](https://links.jianshu.com/go?to=ftp%3A%2F%2F192.168.23.12%2F)，发现无法访问。

原因：被动模式下，数据传输服务被防火墙拦截了。

（1）被动模式

第二次请求过程中，客户端跟服务端建立数据通道；

服务端被动将数据响应给客户端。

第二次请求数据传输，会随机生成一个服务端口。被防火墙禁用。

（2）主动模式

服务端主动向客户端发送数据，会被客户端的防火墙禁掉。

多数客户端不支持主动模式，不安全。

**第八步：配置被动模式**

（1）编辑/etc/vsftpd/vsftpd.conf文件

[root@bogon ~]# vim /etc/vsftpd/vsftpd.conf

（2）添加防火墙范围设置（在文件尾部添加即可）：

pasv_min_port=30000

pasv_max_port=30999

（3）修改防火墙，开启**30000:30999**之间所有的端口。

（4）重启防火墙。

（5）重启vsftpd服务

再次访问浏览器，发现可以正常连接了。



作者：深拥_66e2
链接：https://www.jianshu.com/p/e8b1f6ec5a51
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



一：vsftp服务器简介

由于FTP服务器是明码传输，所以FTP服务是不安全的，于是vsftpd应运而生。vsftpd的全名是Very Secure FTP Daemon的意思。vsftpd的发展理念就是构建一个以安全为重的FTP服务器；。

vsftpd是针对操作系统的程序权限(privilege)的概念来设计的，程序在系统上面执行都会有一个进程ID，我们称之为PID，这个PID在系统上面能进行的任务与其拥有的权限有关。PID权限等级越高，能够拥有的权限也就越多，反之，如果此PID被黑客攻陷，那么对系统的危险也就越大；所以，程序的安全性是重中之重；    

二：vsftpd所具备的特点：

1：vsftpd这个服务的启动者为一般用户，所以对与Linux系统的权限较低，对于Linux系统的危害就相对降低，此时，vsftpd亦利用chroot()这个函数进行改换根目录的动作，使得系统工具不会被vsftpd这支服务所误用；

2：任何需要具有较高执行权限的vsftpd指令均以一支特殊的上层程序所控制，该上层程序享有较高执行权限功能已经被限制的相当的低，并不影响Linux本身的系统为准；

3：绝大多数FTP会使用的指令功能(dir,ls,cd……)都已经被整合到vsftpd主程序中了，因此vsftpd不需要使用到系统提供的额外指令，所以在chroot的情况下，vsftpd不但可以顺利运用，且不需要额外功能，对系统来说比较安全。

4：所有来自客户端且指令，如果想要使用这支上层程序所提供的较高执行权限，均被视为不可信任的要求来处理，必须要经过相当程度的身份确认后，方可利用该上层程序的功能。

5：上面提到的上层程序，依然使用chroot()的功能来限制用户的执行权限。

三：vsftpd的安装：

1：vsftpd的安装非常简单。Linux的yum仓库具有vsftpd的安装命令：

yum -y install vsftpd

![img](https://pics4.baidu.com/feed/203fb80e7bec54e7eb56332253cd06554ec26a4b.jpeg?token=bfd587f5cbc71d6650616bb4d1fd3555&s=89459342FBA0BB601455840F0000F0C3)图一

四：vsftpd相关文件

1：/etc/vsftpd/vsftpd.conf

此文件是vsftpd的配置文件，文件内部使用【参数=设定值】来设定。注意，等号两边不能有空白。详细的vsftpd.conf可以使用【man 5 vsftpd.conf】详查；

![img](https://pics7.baidu.com/feed/d1160924ab18972b6871ab640f38e68c9c510ad4.jpeg?token=8a1e9dcb979b82f09d6b76c633fd5f8a&s=81DD33C2D5C589720ED03F1D0200E046)图二

2：/etc/pam.d/vsftd

vsftpd使用PAM模块时的相关配置文件。主要用来作为身份认证，还有一些身份的抵挡功能；

![img](https://pics0.baidu.com/feed/d62a6059252dd42a14e6a422eacec6b0cbeab843.jpeg?token=ecd4736813341b7fdf7595c0f733cd78&s=C9F523C2CBA59F705AD4480D000060C7)图三

图中标红的地方所标志的文件里边所记载的用户是无法登陆FTP服务器的。

3：/etc/vsftpd/ftpusers

是PAM模块，也就是上一个文件中所标志的配置文件。这个文件中记录了禁止登陆FTP服务器的账号；

4：/etc/vsftpd/user_list

这个文件能否生效与vsftpd.conf内的两个参数有关，分别是userlist_enable，userlist_deny。这个文件是vsftpd自定义的抵挡用户。这个文件和前边的的/etc/vsftpd/ftpusers几乎一模一样。

5：/etc/vsftpd/chroot_list

这个文件默认是不存在的，必须手动自行创建。主要功能是将某些账号的使用者chroot到他们的家目录，能够限制其中账户只能在他们的家目录，不能去其他目录下边。这个文件是否生效与vsftpd.conf中的chroot_list_enable和chroot_list_file有关。

6：/usr/sbin/vsftpd

这个是vsftpd的主要执行文件，也就是可执行文件；

![img](https://pics1.baidu.com/feed/d4628535e5dde7112f2f35d94d1a531e9c16611f.jpeg?token=22ff2751180e8143cb18e35240d01c8e&s=C1ED23E2CD0C1F721ED8E30902007047)图四

7：/var/ftp/

这个是vsftpd的默认匿名者登录的根目录。
=======
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

*vsftpd* is the  Very Secure FTP Daemon (FTP being the file  transfer protocol). It has been available for many years now, and is  actually the default FTP daemon in Rocky Linux, as well as many other  Linux distributions.

*vsftpd* allows for the use of virtual users with pluggable  authentication modules (PAM). These virtual users don't exist in the  system, and have no other permissions except to use FTP. This means that if a virtual user gets compromised, the person with those credentials  would have no other permissions once they gained access. Using this  setup is very secure indeed, but does require a bit of extra work.

Consider `sftp`

Even with the security settings used here to set up `vsftpd`, you may want to consider `sftp` instead. `sftp` will encrypt the entire connection stream and is more secure for this reason. We've created a document [here](https://docs.rockylinux.org/guides/file_sharing/sftp) that deals with setting up `sftp` and the locking down SSH. 

## Installing vsftpd[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#installing-vsftpd)

We also need to make sure *openssl* is installed. If you are running a web server, this probably **is** already installed, but just to make sure, you can run:

```
dnf install vsftpd openssl
```

You will also want to enable the vsftpd service:

```
systemctl enable vsftpd
```

But *don't start the service just yet.*

## Configuring vsftpd[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#configuring-vsftpd)

We want to make sure that some settings are disabled and that others are enabled. Generally, when you install *vsftpd*, it comes with the most sane options already set, but it is a good idea to make sure.

To check the configuration file and make changes as necessary, run:

```
vi /etc/vsftpd/vsftpd.conf
```

Look for the line "anonymous_enable=" and make sure that it is set to "NO" and that it is **NOT** remarked/commented out. (Remarking out this line will enable anonymous  logins).  The line should look like this when it is correct:

```
anonymous_enable=NO
```

Make sure that local_enable is set to yes:

```
local_enable=YES
```

Add a line for the local root user. If the server that you are  installing this on is a web server, we assume that you will be using the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/guides/web/apache-sites-enabled/), and that your local root will reflect that. If your setup is different, or if this is not a web server, adjust the local_root setting:

```
local_root=/var/www/sub-domains
```

Make sure that write_enable is set to yes as well:

```
write_enable=YES
```

Find the line to "chroot_local_users", and remove the remark. Then add two lines below so that it looks like this:

```
chroot_local_user=YES
allow_writeable_chroot=YES
hide_ids=YES
```

Beneath this, we want to add an entirely new section that will deal with virtual users:

```
# Virtual User Settings
user_config_dir=/etc/vsftpd/vsftpd_user_conf
guest_enable=YES
virtual_use_local_privs=YES
pam_service_name=vsftpd
nopriv_user=vsftpd
guest_username=vsftpd
```

We need to add a section near the bottom of the file to force passwords sent over the internet to be encrypted. We need *openssl* installed and we will need to create the certificate file for this as well.

Start by adding these lines at the bottom of the file:

```
rsa_cert_file=/etc/vsftpd/vsftpd.pem
rsa_private_key_file=/etc/vsftpd/vsftpd.key
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO

pasv_min_port=7000
pasv_max_port=7500
```

Now save your configuration. (That's `SHIFT:wq` if using *vi*.)

## Setting Up The RSA Certificate[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#setting-up-the-rsa-certificate)

We need to create the *vsftpd* RSA certificate file. The  author generally figures that a server is good for 4 or 5 years, so set  the number of days for this certificate based on the number of years you believe you'll have the server up and running on this hardware.

Edit the number of days as you see fit, and then use the below format of the command to create the certificate and private key files:

```
openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout /etc/vsftpd/vsftpd.key -out /etc/vsftpd/vsftpd.pem
```

Like all certificate creation processes, this will start a script  that will ask you for some information. This is not a difficult process. Many fields can be left blank.

The first field is the country code field, fill this one in with your country two letter code:

```
Country Name (2 letter code) [XX]:
```

Next comes the state or province, fill this in by typing the whole name, not the abbreviation:

```
State or Province Name (full name) []:
```

Next is the locality name. This is your city:

```
Locality Name (eg, city) [Default City]:
```

Next is the company or organizational name. You can leave this blank or fill it in as you see fit:

```
Organization Name (eg, company) [Default Company Ltd]:
```

Next is the organizational unit name. You can fill this in if the server is for a specific division, or leave it blank:

```
Organizational Unit Name (eg, section) []:
```

The next field should be filled in, however you can decide how you  want to fill it in. This is the common name of your server. Example: `webftp.domainname.ext`:

```
Common Name (eg, your name or your server's hostname) []:
```

Finally, there is the email field, which you can certainly leave blank without issue:

```
Email Address []:
```

Once you have completed the form, the certificate will be created.

## Setting Up Virtual Users[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#setting-up-virtual-users)

As stated earlier, using virtual users for *vsftpd* is much  more secure, because they have no system privileges at all. That said,  we need to add a user for the virtual users to use. We also need to add a group:

```
groupadd nogroup
```

And then:

```
useradd --home-dir /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd
```

The user must match the `guest_username=` line in the vsftpd.conf file.

Now navigate to the configuration directory for *vsftpd*:

```
cd /etc/vsftpd
```

We need to create a new password database that will be used to  authenticate our virtual users. We need to create a file to read the  virtual users and passwords from. This will create the database.

In the future, when adding new users, we will want to duplicate this process as well:

```
vi vusers.txt
```

The user and password are line separated, so simply type the user,  hit enter, and then type the password. Continue until you have added all of the users you currently want to have access to the system. Example:

```
user_name_a
user_password_a
user_name_b
user_password_b
```

Once the text file is created, we now want to generate the password database that *vsftpd* will use for the virtual users. This is done with *db_load*. *db_load* is provided by *libdb-utils* which should be loaded on your system, but if it is not, you can simply install it with:

```
dnf install libdb-utils
```

Create the database from the text file with:

```
db_load -T -t hash -f vusers.txt vsftpd-virtual-user.db
```

We need to take just a moment here to reference what *db_load* is doing here:

- The -T is used to easily allow the import of a text file into the database.
- The -t says to specify the underlying access method.
- The *hash* is the underlying access method we are specifying.
- The -f says to read from a specified file.
- The specified file is *vusers.txt* .
- And the database we are creating or adding to is *vsftpd-virtual-user.db*.

Change the default permissions of the database file:

```
chmod 600 vsftpd-virtual-user.db
```

And remove the vusers.txt file:

```
rm vusers.txt
```

When adding new users, simply use *vi* to create a new vusers.txt file, and re-run the *db_load* command, which will add the new user/s to the database.

## Setting Up PAM[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#setting-up-pam)

*vsftpd* installs a default pam file when you install the package. We are going to replace this with our own content, so **always** make a backup copy of the old file first.

Make a directory for your backup file in /root:

```
mkdir /root/backup_vsftpd_pam
```

Then copy the pam file to this directory:

```
cp /etc/pam.d/vsftpd /root/backup_vsftpd_pam/
```

Now edit the original file:

```
vi /etc/pam.d/vsftpd
```

Remove everything in this file except the "#%PAM-1.0" and then add in the following lines:

```
auth       required     pam_userdb.so db=/etc/vsftpd/vsftpd-virtual-user
account    required     pam_userdb.so db=/etc/vsftpd/vsftpd-virtual-user
session    required     pam_loginuid.so
```

Save your changes and exit (`SHIFT:wq` in *vi*).

This will enable login for your virtual users defined in `vsftpd-virtual-user.db`, and will disable local logins.

## Setting Up The Virtual User's Configuration[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#setting-up-the-virtual-users-configuration)

Each virtual user has their own configuration file, which specifies  their own local_root directory. This local root must be owned by the  user "vsftpd" and the group "nogroup".

Remember that this was set up in the [Setting Up Virtual Users section above.](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#virtualusers) To change the ownership for the directory, simply type this at the command line:

```
chown vsftpd.nogroup /var/www/sub-domains/whatever_the_domain_name_is/html
```

We need to create the file that contains the virtual user's configuration:

```
mkdir /etc/vsftpd/vsftpd_user_conf
vi /etc/vsftpd/vsftpd_user_conf/username
```

This will have a single line in it that specifies the virtual user's local_root:

```
local_root=/var/www/sub-domains/com.testdomain/html
```

This file path is specified in the "Virtual User" section of the vsftpd.conf file.

## Starting vsftpd[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#starting-vsftpd)

Once all of this is completed, start the *vsftpd* service and then test your users, assuming that the service starts correctly:

```
systemctl restart vsftpd
```

### Testing vsftpd[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#testing-vsftpd)

You can test your setup using the command line on a machine and test  access to the machine using FTP. That said, the easiest way to test is  to test with an FTP client, such as [FileZilla](https://filezilla-project.org/).

When you test with a virtual user to the server running *vsftpd*, you should get an SSL certificate trust message. This trust message is  saying to the person using the FTP client that the server uses a  certificate and asks them to approve the certificate before continuing.  Once connected as a virtual user, you should be able to place files in  the "local_root" folder that we setup for that user.

If you are unable to upload a file, then you may need to go back and  make sure that each of the above steps is completed. For instance, it  could be that the ownership permissions for the "local_root" have not  been set to the "vsftpd" user and the "nogroup" group.

## Conclusion[¶](https://docs.rockylinux.org/guides/file_sharing/secure_ftp_server_vsftpd/#conclusion)

*vsftpd* is a popular and common ftp server and can be set up as a stand alone server, or as part of an [Apache Hardened Web Server](https://docs.rockylinux.org/guides/web/apache_hardened_webserver/). If set up to use virtual users and a certificate, it is quite secure.

While there are quite a number of steps to setting up *vsftpd* as outlined in this document, taking the extra time to set it up  correctly will ensure that your server is as secure as it can be.
