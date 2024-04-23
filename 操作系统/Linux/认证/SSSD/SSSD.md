# SSSD

# How to set up SSSD with Active Directory 如何使用 Active Directory 设置 SSSD

This section describes the use of SSSD to authenticate user logins against  an Active Directory via using SSSD’s “ad” provider. At the end, Active  Directory users will be able to log in on the host using their AD  credentials. Group membership will also be maintained.
本节介绍如何使用 SSSD 通过使用 SSSD 的“广告”提供程序对 Active Directory 的用户登录进行身份验证。最后，Active Directory 用户将能够使用其 AD 凭据登录主机。组成员资格也将保持不变。

## Group Policies for Ubuntu Ubuntu 的组策略

SSSD manages user authentication and sets initial security policies.
SSSD 管理用户身份验证并设置初始安全策略。

ADSys serves as a Group Policy client for Ubuntu, streamlining the  configuration of Ubuntu systems within a Microsoft Active Directory  environment. If you are interested in Group Policies support for Ubuntu, detailed information can be found in the [ADSys documentation](https://canonical-adsys.readthedocs-hosted.com/en/stable/).
ADSys 充当 Ubuntu 的组策略客户端，简化 Microsoft Active Directory 环境中 Ubuntu 系统的配置。如果您对 Ubuntu 的组策略支持感兴趣，可以在 ADSys 文档中找到详细信息。

## Prerequisites and assumptions 先决条件和假设

This guide does not explain Active Directory, how it works, how to set one  up, or how to maintain it. It assumes that a working Active Directory  domain is already configured and you have access to the credentials to  join a machine to that domain.
本指南不介绍 Active Directory、它的工作原理、如何设置或如何维护它。它假定已配置有效的 Active Directory 域，并且您有权访问将计算机加入该域的凭据。

- The domain controller is:

  
  域控制器是：

  - Acting as an authoritative DNS server for the domain.
    充当域的权威 DNS 服务器。
  - The primary DNS resolver (check with `systemd-resolve --status`).
    主 DNS 解析器（使用 `systemd-resolve --status` 检查）。

- System time is correct and in sync, maintained via a service like `chrony` or `ntp`.
  系统时间正确且同步，通过 or `ntp` 等 `chrony` 服务进行维护。

- The domain used in this example is `ad1.example.com` .
  此示例中使用的域是 `ad1.example.com` 。

## Install necessary software 安装必要的软件

Install the following packages:
安装以下软件包：

```bash
sudo apt install sssd-ad sssd-tools realmd adcli
```

## Join the domain 加入域

We will use the `realm` command, from the `realmd` package, to join the domain and create the SSSD configuration.
我们将使用 `realmd` 包中 `realm` 的命令加入域并创建 SSSD 配置。

Let’s verify the domain is discoverable via DNS:
让我们验证域是否可通过 DNS 发现：

```bash
$ sudo realm -v discover ad1.example.com
 * Resolving: _ldap._tcp.ad1.example.com
 * Performing LDAP DSE lookup on: 10.51.0.5
 * Successfully discovered: ad1.example.com
ad1.example.com
  type: kerberos
  realm-name: AD1.EXAMPLE.COM
  domain-name: ad1.example.com
  configured: no
  server-software: active-directory
  client-software: sssd
  required-package: sssd-tools
  required-package: sssd
  required-package: libnss-sss
  required-package: libpam-sss
  required-package: adcli
  required-package: samba-common-bin
```

This performs several checks and determines the best software stack to use with SSSD. SSSD can install the missing packages via `packagekit`, but we already installed them in the previous step.
这将执行多项检查，并确定用于 SSSD 的最佳软件堆栈。SSSD 可以通过 `packagekit` 安装缺少的软件包，但我们在上一步中已经安装了它们。

Now let’s join the domain:
现在让我们加入域：

```bash
$ sudo realm join ad1.example.com
Password for Administrator: 
```

That was quite uneventful. If you want to see what it was doing, pass the `-v` option:
这很平静。如果您想查看它在做什么，请传递以下 `-v` 选项：

```bash
$ sudo realm join -v ad1.example.com
 * Resolving: _ldap._tcp.ad1.example.com
 * Performing LDAP DSE lookup on: 10.51.0.5
 * Successfully discovered: ad1.example.com
Password for Administrator: 
 * Unconditionally checking packages
 * Resolving required packages
 * LANG=C /usr/sbin/adcli join --verbose --domain ad1.example.com --domain-realm AD1.EXAMPLE.COM --domain-controller 10.51.0.5 --login-type user --login-user Administrator --stdin-password
 * Using domain name: ad1.example.com
 * Calculated computer account name from fqdn: AD-CLIENT
 * Using domain realm: ad1.example.com
 * Sending NetLogon ping to domain controller: 10.51.0.5
 * Received NetLogon info from: SERVER1.ad1.example.com
 * Wrote out krb5.conf snippet to /var/cache/realmd/adcli-krb5-hUfTUg/krb5.d/adcli-krb5-conf-hv2kzi
 * Authenticated as user: Administrator@AD1.EXAMPLE.COM
 * Looked up short domain name: AD1
 * Looked up domain SID: S-1-5-21-2660147319-831819607-3409034899
 * Using fully qualified name: ad-client.ad1.example.com
 * Using domain name: ad1.example.com
 * Using computer account name: AD-CLIENT
 * Using domain realm: ad1.example.com
 * Calculated computer account name from fqdn: AD-CLIENT
 * Generated 120 character computer password
 * Using keytab: FILE:/etc/krb5.keytab
 * Found computer account for AD-CLIENT$ at: CN=AD-CLIENT,CN=Computers,DC=ad1,DC=example,DC=com
 * Sending NetLogon ping to domain controller: 10.51.0.5
 * Received NetLogon info from: SERVER1.ad1.example.com
 * Set computer password
 * Retrieved kvno '3' for computer account in directory: CN=AD-CLIENT,CN=Computers,DC=ad1,DC=example,DC=com
 * Checking RestrictedKrbHost/ad-client.ad1.example.com
 *    Added RestrictedKrbHost/ad-client.ad1.example.com
 * Checking RestrictedKrbHost/AD-CLIENT
 *    Added RestrictedKrbHost/AD-CLIENT
 * Checking host/ad-client.ad1.example.com
 *    Added host/ad-client.ad1.example.com
 * Checking host/AD-CLIENT
 *    Added host/AD-CLIENT
 * Discovered which keytab salt to use
 * Added the entries to the keytab: AD-CLIENT$@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: host/AD-CLIENT@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: host/ad-client.ad1.example.com@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: RestrictedKrbHost/AD-CLIENT@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: RestrictedKrbHost/ad-client.ad1.example.com@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * /usr/sbin/update-rc.d sssd enable
 * /usr/sbin/service sssd restart
 * Successfully enrolled machine in realm
```

By default, `realm` will use the “Administrator” account of the domain to request the join. If you need to use another account, pass it to the tool with the `-U` option.
默认情况下， `realm` 将使用域的“管理员”帐户请求加入。如果您需要使用其他帐户，请将其传递给带有选项的工具 `-U` 。

Another popular way of joining a domain is using a One Time Password (OTP) token. For that, use the `--one-time-password` option.
加入域的另一种流行方式是使用一次性密码 （OTP） 令牌。为此，请使用该 `--one-time-password` 选项。

## SSSD configuration SSSD 配置

The `realm` tool already took care of creating an SSSD configuration, adding the PAM and NSS modules, and starting the necessary services.
该 `realm` 工具已经负责创建 SSSD 配置、添加 PAM 和 NSS 模块以及启动必要的服务。

Let’s take a look at `/etc/sssd/sssd.conf`:
让我们来看看 `/etc/sssd/sssd.conf` ：

```plaintext
[sssd]
domains = ad1.example.com
config_file_version = 2
services = nss, pam
	
[domain/ad1.example.com]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = AD1.EXAMPLE.COM
realmd_tags = manages-system joined-with-adcli 
id_provider = ad
fallback_homedir = /home/%u@%d
ad_domain = ad1.example.com
use_fully_qualified_names = True
ldap_id_mapping = True
access_provider = ad
```

> **Note**: 注意：
>  Something very important to remember is that this file must have permissions `0600` and ownership `root:root`, or else SSSD won’t start!
> 要记住的非常重要的一点是，此文件必须具有权限 `0600` 和所有权 `root:root` ，否则SSSD将无法启动！

Let’s highlight a few things from this config file:
让我们从这个配置文件中突出显示一些内容：

- **`cache_credentials`**: This allows logins when the AD server is unreachable
   `cache_credentials` ：这允许在无法访问 AD 服务器时登录
- **`fallback_homedir`**: The home directory. By default, `/home/<user>@<domain>`. For example, the AD user *john* will have a home directory of */home/john@ad1.example.com*.
   `fallback_homedir` ：主目录。默认情况下， `/home/<user>@<domain>` .例如，AD 用户 john 的主目录为 /home/john@ad1.example.com。
- **`use_fully_qualified_names`**: Users will be of the form `user@domain`, not just `user`. This should only be changed if you are certain no other domains will  ever join the AD forest, via one of the several possible trust  relationships.
   `use_fully_qualified_names` ：用户将具有 `user@domain` 的形式，而不仅仅是 `user` 。仅当您确定没有其他域会通过几种可能的信任关系之一加入 AD 林时，才应更改此设置。

## Automatic home directory creation 自动创建主目录

What the `realm` tool didn’t do for us is setup `pam_mkhomedir`, so that network users can get a home directory when they login. This  remaining step can be done by running the following command:
该 `realm` 工具没有为我们做的是 `pam_mkhomedir` 设置 ，以便网络用户在登录时可以获取主目录。可以通过运行以下命令来完成剩余步骤：

```bash
sudo pam-auth-update --enable mkhomedir
```

## Testing our setup 测试我们的设置

You should now be able to fetch information about AD users. In this example, `John Smith` is an AD user:
现在，您应该能够获取有关 AD 用户的信息。在此示例中， `John Smith` 是 AD 用户：

```bash
$ getent passwd john@ad1.example.com
john@ad1.example.com:*:1725801106:1725800513:John Smith:/home/john@ad1.example.com:/bin/bash
```

Let’s see his groups:
让我们看看他的小组：

```bash
$ groups john@ad1.example.com
john@ad1.example.com : domain users@ad1.example.com engineering@ad1.example.com
```

> **Note**: 注意：
>  If you just changed the group membership of a user, it may be a while before SSSD notices due to caching.
> 如果刚刚更改了用户的组成员身份，则由于缓存，SSSD 可能需要一段时间才会发出通知。

Finally, how about we try a login:
最后，我们尝试登录怎么样：

```bash
$ sudo login
ad-client login: john@ad1.example.com
Password: 
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
...
Creating directory '/home/john@ad1.example.com'.
john@ad1.example.com@ad-client:~$ 
```

Notice how the home directory was automatically created.
请注意主目录是如何自动创建的。

You can also use SSH, but note that the command will look a bit funny because of the multiple `@` signs:
您也可以使用 SSH，但请注意，由于有多个 `@` 符号，该命令看起来有点滑稽：

```bash
$ ssh john@ad1.example.com@10.51.0.11
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Last login: Thu Apr 16 21:22:55 2020
john@ad1.example.com@ad-client:~$ 
```

> **Note**: 注意：
>  In the SSH example, public key authentication was used, so no password  was required. Remember that SSH password authentication is disabled by  default in `/etc/ssh/sshd_config`.
> 在 SSH 示例中，使用了公钥身份验证，因此不需要密码。请记住，SSH 密码身份验证在 中 `/etc/ssh/sshd_config` 默认处于禁用状态。

## Kerberos tickets Kerberos 票证

If you install `krb5-user`, your AD users will also get a Kerberos ticket upon logging in:
如果安装 `krb5-user` ，您的 AD 用户在登录时还将获得 Kerberos 票证：

```bash
john@ad1.example.com@ad-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1725801106_9UxVIz
Default principal: john@AD1.EXAMPLE.COM

Valid starting     Expires            Service principal
04/16/20 21:32:12  04/17/20 07:32:12  krbtgt/AD1.EXAMPLE.COM@AD1.EXAMPLE.COM
	renew until 04/17/20 21:32:12
```

> **Note**: 注意：
>  `realm` also configured `/etc/krb5.conf` for you, so there should be no further configuration prompts when installing `krb5-user`.
>  `realm` 也为您配置 `/etc/krb5.conf` 了，因此在安装 `krb5-user` 时应该没有进一步的配置提示。

Let’s test with `smbclient` using Kerberos authentication to list the shares of the domain controller:
让我们使用 `smbclient` Kerberos 身份验证来列出域控制器的份额：

```bash
john@ad1.example.com@ad-client:~$ smbclient -k -L server1.ad1.example.com

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	NETLOGON        Disk      Logon server share 
	SYSVOL          Disk      Logon server share 
SMB1 disabled -- no workgroup available
```

Notice how we now have a ticket for the `cifs` service, which was used for the share list above:
请注意，我们现在有一张 `cifs` 服务票证，该票证用于上面的共享列表：

```bash
john@ad1.example.com@ad-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1725801106_9UxVIz
Default principal: john@AD1.EXAMPLE.COM

Valid starting     Expires            Service principal
04/16/20 21:32:12  04/17/20 07:32:12  krbtgt/AD1.EXAMPLE.COM@AD1.EXAMPLE.COM
	renew until 04/17/20 21:32:12
04/16/20 21:32:21  04/17/20 07:32:12  cifs/server1.ad1.example.com@AD1.EXAMPLE.COM
```

## Ubuntu Desktop authentication Ubuntu 桌面身份验证

The desktop login only shows local users in the list to pick from, and that’s on purpose.
桌面登录仅显示列表中的本地用户以供选择，这是故意的。

To login with an Active Directory user for the first time, follow these steps:
若要首次使用 Active Directory 用户登录，请按照下列步骤操作：

- Click on the “Not listed?” option:
  点击“未列出”选项：

![Click "not listed"](https://assets.ubuntu.com/v1/291d9ae9-not_listed.png)

- Type in the login name followed by the password:
  输入登录名，后跟密码：

![Type in username](https://assets.ubuntu.com/v1/6940e589-login.png)

- Next time you login, the AD user will be listed as if it was a local user:
  下次登录时，AD 用户将被列为本地用户：

![Next time](https://assets.ubuntu.com/v1/9c174441-local_user.png)

## Known issues 已知问题

When logging in on a system joined with an Active Directory domain, `sssd` (the package responsible for this integration) will try to apply Group  Policies by default. There are cases where if a specific policy is  missing, the login will be denied.
在加入 Active Directory 域的系统上登录时，默认情况下（ `sssd` 负责此集成的包）将尝试应用组策略。在某些情况下，如果缺少特定策略，登录将被拒绝。

This is being tracked in [bug #1934997](https://bugs.launchpad.net/ubuntu/+source/sssd/+bug/1934997). Until the fix becomes available, please see [comment #5](https://bugs.launchpad.net/ubuntu/+source/sssd/+bug/1934997/comments/5) in that bug report for existing workarounds.
这是在错误 #1934997 中跟踪的。在修复程序可用之前，请参阅该错误报告中的评论 #5 了解现有解决方法。

## Further reading 延伸阅读

- [GitHub SSSD Project GitHub SSSD 项目](https://github.com/SSSD/sssd)
- [Active Directory DNS Zone Entries
  Active Directory DNS 区域条目](https://technet.microsoft.com/en-us/library/cc759550(v=ws.10).aspx)

# How to set up SSSD with LDAP 如何使用 LDAP 设置 SSSD

SSSD can also use LDAP for authentication, authorisation, and user/group  information. In this section we will configure a host to authenticate  users from an OpenLDAP directory.
SSSD 还可以将 LDAP 用于身份验证、授权和用户/组信息。在本节中，我们将配置主机以对来自 OpenLDAP 目录的用户进行身份验证。

## Prerequisites and assumptions 先决条件和假设

For this setup, we need:
对于此设置，我们需要：

- An existing OpenLDAP server with SSL enabled and using the RFC2307 schema for users and groups
  启用了 SSL 并为用户和组使用 RFC2307 架构的现有 OpenLDAP 服务器
- A client host where we will install the necessary tools and login as a user from the LDAP server
  一个客户端主机，我们将在其中安装必要的工具并以用户身份从LDAP服务器登录

## Install necessary software 安装必要的软件

Install the following packages:
安装以下软件包：

```bash
sudo apt install sssd-ldap ldap-utils
```

## Configure SSSD 配置 SSSD

Create the `/etc/sssd/sssd.conf` configuration file, with permissions `0600` and ownership `root:root`, and add the following content:
创建具有权限 `0600` 和所有权 `root:root` 的 `/etc/sssd/sssd.conf` 配置文件，并添加以下内容：

```plaintext
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://ldap01.example.com
cache_credentials = True
ldap_search_base = dc=example,dc=com
```

Make sure to start the `sssd` service:
确保启动 `sssd` 服务：

```bash
sudo systemctl start sssd.service
```

> **Note**: 注意：
>  `sssd` will use `START_TLS` by default for authentication requests against the LDAP server (the **`auth_provider`**), but not for the **`id_provider`**. If you want to also enable `START_TLS` for the `id_provider`, specify `ldap_id_use_start_tls = true`.
>  `sssd` 默认情况下，将用于 `START_TLS` 针对 LDAP 服务器 （的 `auth_provider` ） 的身份验证请求，但不用于 `id_provider` 。如果还想启用 `START_TLS` `id_provider` ，请指定 `ldap_id_use_start_tls = true` 。

## Automatic home directory creation 自动创建主目录

To enable automatic home directory creation, run the following command:
若要启用自动主目录创建，请运行以下命令：

```bash
sudo pam-auth-update --enable mkhomedir
```

## Check SSL setup on the client 检查客户端上的 SSL 设置

The client must be able to use `START_TLS` when connecting to the LDAP server, with full certificate checking. This means:
客户端在连接到 LDAP 服务器时必须能够使用 `START_TLS` ，并进行完整的证书检查。这意味着：

- The client host knows and trusts the CA that signed the LDAP server certificate,
  客户端主机知道并信任对 LDAP 服务器证书进行签名的 CA，
- The server certificate was issued for the correct host (`ldap01.example.com` in this guide),
  服务器证书已颁发给正确的主机（在本指南 `ldap01.example.com` 中），
- The time is correct on all hosts performing the TLS connection, and
  在执行 TLS 连接的所有主机上，时间都是正确的，并且
- That neither certificate (CA or server’s) expired.
  证书（CA 或服务器的证书）均未过期。

If using a custom CA, an easy way to have a host trust it is to place it in `/usr/local/share/ca-certificates/` with a `.crt` extension and run `sudo update-ca-certificates`.
如果使用自定义 CA，让主机信任它的一种简单方法是将其与 `.crt` 扩展一起放入 `/usr/local/share/ca-certificates/` 并运行 `sudo update-ca-certificates` 。

Alternatively, you can edit `/etc/ldap/ldap.conf` and point `TLS_CACERT` to the CA public key file.
或者，您可以编辑 `/etc/ldap/ldap.conf` 并指向 `TLS_CACERT` CA 公钥文件。

> **Note**: 注意：
>  You may have to restart `sssd` after these changes: `sudo systemctl restart sssd`
>  `sssd` 在进行以下更改后，您可能需要重新启动： `sudo systemctl restart sssd` 

Once that is all done, check that you can connect to the LDAP server using verified SSL connections:
完成所有操作后，请检查您是否可以使用经过验证的SSL连接连接到LDAP服务器：

```bash
$ ldapwhoami -x -ZZ -H ldap://ldap01.example.com
anonymous
```

and for `ldaps` (if enabled in `/etc/default/slapd`):
和 for `ldaps` （如果在 ： `/etc/default/slapd` 

```bash
$ ldapwhoami -x -H ldaps://ldap01.example.com
```

The `-ZZ` parameter tells the tool to use `START_TLS`, and that it must not fail. If you have LDAP logging enabled on the server, it will show something like this:
该 `-ZZ` 参数指示工具使用 `START_TLS` ，并且它不能失败。如果在服务器上启用了 LDAP 日志记录，它将显示如下内容：

```auto
slapd[779]: conn=1032 op=0 STARTTLS
slapd[779]: conn=1032 op=0 RESULT oid= err=0 text=
slapd[779]: conn=1032 fd=15 TLS established tls_ssf=256 ssf=256
slapd[779]: conn=1032 op=1 BIND dn="" method=128
slapd[779]: conn=1032 op=1 RESULT tag=97 err=0 text=
slapd[779]: conn=1032 op=2 EXT oid=1.3.6.1.4.1.4203.1.11.3
slapd[779]: conn=1032 op=2 WHOAMI
slapd[779]: conn=1032 op=2 RESULT oid= err=0 text=
```

`START_TLS` with `err=0` and `TLS established` is what we want to see there, and, of course, the `WHOAMI` extended operation.
 `START_TLS` with `err=0` 和 `TLS established` 是我们希望在那里看到的，当然还有 `WHOAMI` 扩展操作。

## Final verification 最终验证

In this example, the LDAP server has the following user and group entry we are going to use for testing:
在此示例中，LDAP 服务器具有以下用户和组条目，我们将用于测试：

```auto
dn: uid=john,ou=People,dc=example,dc=com
uid: john
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Smith
sn: Smith
givenName: John
mail: john@example.com
userPassword: johnsecret
uidNumber: 10001
gidNumber: 10001
loginShell: /bin/bash
homeDirectory: /home/john

dn: cn=john,ou=Group,dc=example,dc=com
cn: john
objectClass: posixGroup
gidNumber: 10001
memberUid: john

dn: cn=Engineering,ou=Group,dc=example,dc=com
cn: Engineering
objectClass: posixGroup
gidNumber: 10100
memberUid: john
```

The user `john` should be known to the system:
系统应知道用户 `john` ：

```bash
ubuntu@ldap-client:~$ getent passwd john
john:*:10001:10001:John Smith:/home/john:/bin/bash

ubuntu@ldap-client:~$ id john
uid=10001(john) gid=10001(john) groups=10001(john),10100(Engineering)
```

And we should be able to authenticate as `john`:
我们应该能够验证为 `john` ：

```bash
ubuntu@ldap-client:~$ sudo login
ldap-client login: john
Password:
Welcome to Ubuntu Focal Fossa (development branch) (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Creating directory '/home/john'.
john@ldap-client:~$
```

------

​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [                   Previous 以前                   SSSD with Active Directory
使用 Active Directory 的 SSSD                 ](https://ubuntu.com/server/docs/how-to-set-up-sssd-with-active-directory)

# How to set up SSSD with LDAP and Kerberos 如何使用 LDAP 和 Kerberos 设置 SSSD

With SSSD we can create a setup that is very similar to Active Directory in  terms of the technologies used: using LDAP for users and groups, and  Kerberos for authentication.
使用 SSSD，我们可以创建一个在所使用技术方面与 Active Directory 非常相似的设置：将 LDAP 用于用户和组，并使用 Kerberos 进行身份验证。

## Prerequisites and assumptions 先决条件和假设

For this setup, we will need:
对于此设置，我们将需要：

- An existing [OpenLDAP server](https://ubuntu.com/server/docs/install-and-configure-ldap) using the RFC2307 schema for users and groups. SSL support is  recommended, but not strictly necessary because authentication in this  setup is being done via Kerberos, and not LDAP.
  对用户和组使用RFC2307模式的现有 OpenLDAP 服务器。建议使用 SSL 支持，但不是绝对必要的，因为此设置中的身份验证是通过 Kerberos 而不是 LDAP 完成的。
- A [Kerberos server](https://ubuntu.com/server/docs/how-to-install-a-kerberos-server). It doesn’t have to be [using the OpenLDAP backend](https://ubuntu.com/server/docs/how-to-set-up-kerberos-with-openldap-backend).
  Kerberos 服务器。它不必使用 OpenLDAP 后端。
- A client host where we will install and configure SSSD.
  我们将在其中安装和配置 SSSD 的客户端主机。

## Install necessary software 安装必要的软件

On the client host, install the following packages:
在客户端主机上，安装以下软件包：

```bash
sudo apt install sssd-ldap sssd-krb5 ldap-utils krb5-user
```

You may be asked about the default Kerberos realm. For this guide, we are using `EXAMPLE.COM`.
您可能会被问到默认的 Kerberos 领域。在本指南中，我们使用 `EXAMPLE.COM` .

At this point, you should already be able to obtain tickets from your Kerberos server, assuming DNS records point at it:
此时，您应该已经能够从 Kerberos 服务器获取票证，假设 DNS 记录指向它：

```bash
$ kinit ubuntu
Password for ubuntu@EXAMPLE.COM:

ubuntu@ldap-krb-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1000
Default principal: ubuntu@EXAMPLE.COM

Valid starting     Expires            Service principal
04/17/20 19:51:06  04/18/20 05:51:06  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 04/18/20 19:51:05
```

But we want to be able to login as an LDAP user, authenticated via Kerberos. Let’s continue with the configuration.
但是我们希望能够以 LDAP 用户身份登录，并通过 Kerberos 进行身份验证。让我们继续配置。

## Configure SSSD 配置 SSSD

Create the `/etc/sssd/sssd.conf` configuration file, with permissions `0600` and ownership `root:root`, and add the following content:
创建具有权限 `0600` 和所有权 `root:root` 的 `/etc/sssd/sssd.conf` 配置文件，并添加以下内容：

```bash
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
ldap_uri = ldap://ldap01.example.com
ldap_search_base = dc=example,dc=com
auth_provider = krb5
krb5_server = kdc01.example.com,kdc02.example.com
krb5_kpasswd = kdc01.example.com
krb5_realm = EXAMPLE.COM
cache_credentials = True
```

This example uses two KDCs, which made it necessary to also specify the `krb5_kpasswd` server because the second KDC is a replica and is not running the admin server.
此示例使用两个 KDC，因此还需要指定服务器， `krb5_kpasswd` 因为第二个 KDC 是副本，并且未运行管理服务器。

Start the `sssd` service:
启动 `sssd` 服务：

```bash
sudo systemctl start sssd.service
```

## Automatic home directory creation 自动创建主目录

To enable automatic home directory creation, run the following command:
若要启用自动主目录创建，请运行以下命令：

```bash
sudo pam-auth-update --enable mkhomedir
```

## Final verification 最终验证

In this example, the LDAP server has the following user and group entry we are going to use for testing:
在此示例中，LDAP 服务器具有以下用户和组条目，我们将用于测试：

```auto
dn: uid=john,ou=People,dc=example,dc=com
uid: john
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Smith
sn: Smith
givenName: John
mail: john@example.com
uidNumber: 10001
gidNumber: 10001
loginShell: /bin/bash
homeDirectory: /home/john

dn: cn=john,ou=Group,dc=example,dc=com
cn: john
objectClass: posixGroup
gidNumber: 10001
memberUid: john

dn: cn=Engineering,ou=Group,dc=example,dc=com
cn: Engineering
objectClass: posixGroup
gidNumber: 10100
memberUid: john
```

Note how the user `john` has no `userPassword` attribute.
请注意用户 `john` 如何没有 `userPassword` 属性。

The user `john` should be known to the system:
系统应知道用户 `john` ：

```bash
ubuntu@ldap-client:~$ getent passwd john
john:*:10001:10001:John Smith:/home/john:/bin/bash

ubuntu@ldap-client:~$ id john
uid=10001(john) gid=10001(john) groups=10001(john),10100(Engineering)
```

Let’s try a login as this user:
让我们尝试以此用户身份登录：

```bash
ubuntu@ldap-krb-client:~$ sudo login
ldap-krb-client login: john
Password: 
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Creating directory '/home/john'.

john@ldap-krb-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_10001_BOrxWr
Default principal: john@EXAMPLE.COM

Valid starting     Expires            Service principal
04/17/20 20:29:50  04/18/20 06:29:50  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 04/18/20 20:29:50
john@ldap-krb-client:~$
```

We logged in using the Kerberos password, and user/group information from the LDAP server.
我们使用 Kerberos 密码和 LDAP 服务器中的用户/组信息登录。

## SSSD and KDC spoofing SSSD 和 KDC 欺骗

When using SSSD to manage Kerberos logins on a Linux host, there is an attack scenario you should be aware of: KDC spoofing.
使用 SSSD 管理 Linux 主机上的 Kerberos 登录时，应注意一种攻击场景：KDC 欺骗。

The objective of the attacker is to login on a workstation that is using Kerberos authentication. Let’s say they know `john` is a valid user on that machine.
攻击者的目标是登录使用 Kerberos 身份验证的工作站。假设他们知道 `john` 是该计算机上的有效用户。

The attacker first deploys a rogue Key Distribution Center (KDC) server in the network, and creates the `john` principal there with a password of the attacker’s choosing. What they  must do now is have their rogue KDC respond to the login request from  the workstation, before (or instead of) the real KDC. If the workstation isn’t authenticating the KDC, it will accept the reply from the rogue  server and let `john` in.
攻击者首先在网络中部署一个恶意密钥分发中心 （KDC） 服务器，并使用攻击者选择的密码在其中创建 `john` 主体。他们现在必须做的是让他们的流氓 KDC 在真正的 KDC 之前（或代替）响应来自工作站的登录请求。如果工作站未对 KDC 进行身份验证，它将接受来自恶意服务器的回复并允许 `john` 进入。

There is a configuration parameter that can be set to protect the workstation from this type of attack. It will have SSSD authenticate the KDC, and  block the login if the KDC cannot be verified. This option is called `krb5_validate`, and it’s `false` by default.
可以设置一个配置参数来保护工作站免受此类攻击。它将让 SSSD 对 KDC 进行身份验证，如果无法验证 KDC，则阻止登录。此选项称为 `krb5_validate` ， `false` 默认情况下为 。

To enable it, edit `/etc/sssd/sssd.conf` and add this line to the domain section:
要启用它，请编辑 `/etc/sssd/sssd.conf` 以下行并将其添加到域部分：

```plaintext
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
...
krb5_validate = True
```

The second step is to create a `host` principal on the KDC for this workstation. This is how the KDC’s  authenticity is verified. It’s like a “machine account”, with a shared  secret that the attacker cannot control and replicate in the rogue KDC.  The `host` principal has the format `host/<fqdn>@REALM`.
第二步是在 KDC 上为此工作站创建 `host` 主体。这就是验证KDC真实性的方式。它就像一个“机器帐户”，具有攻击者无法控制的共享密钥，也无法在流氓 KDC 中复制。 `host` 主体的格式 `host/<fqdn>@REALM` 为 。

After the host principal is created, its keytab needs to be stored on the  workstation. This two step process can be easily done on the workstation itself via `kadmin` (not `kadmin.local`) to contact the KDC remotely:
创建主机主体后，需要将其密钥表存储在工作站上。这个两步过程可以通过 `kadmin` （不是 `kadmin.local` ）远程联系KDC在工作站上轻松完成：

```bash
$ sudo kadmin -p ubuntu/admin
kadmin:  addprinc -randkey host/ldap-krb-client.example.com@EXAMPLE.COM
WARNING: no policy specified for host/ldap-krb-client.example.com@EXAMPLE.COM; defaulting to no policy
Principal "host/ldap-krb-client.example.com@EXAMPLE.COM" created.

kadmin:  ktadd -k /etc/krb5.keytab host/ldap-krb-client.example.com
Entry for principal host/ldap-krb-client.example.com with kvno 6, encryption type aes256-cts-hmac-sha1-96 added to keytab WRFILE:/etc/krb5.keytab.
Entry for principal host/ldap-krb-client.example.com with kvno 6, encryption type aes128-cts-hmac-sha1-96 added to keytab WRFILE:/etc/krb5.keytab.
```

Then exit the tool and make sure the permissions on the keytab file are tight:
然后退出该工具，并确保密钥表文件的权限是严格的：

```bash
sudo chmod 0600 /etc/krb5.keytab
sudo chown root:root /etc/krb5.keytab
```

You can also do it on the KDC itself using `kadmin.local`, but you will have to store the keytab temporarily in another file and securely copy it over to the workstation.
您也可以在 KDC 本身上使用 `kadmin.local` ，但您必须将密钥表临时存储在另一个文件中，并将其安全地复制到工作站。

Once these steps are complete, you can restart SSSD on the workstation and  perform the login. If the rogue KDC notices the attempt and replies, it  will fail the host verification. With debugging we can see this  happening on the workstation:
完成这些步骤后，可以在工作站上重新启动 SSSD 并执行登录。如果恶意 KDC 注意到尝试并回复，则主机验证将失败。通过调试，我们可以看到这种情况发生在工作站上：

```auto
==> /var/log/sssd/krb5_child.log <==
(Mon Apr 20 19:43:58 2020) [[sssd[krb5_child[2102]]]] [validate_tgt] (0x0020): TGT failed verification using key for [host/ldap-krb-client.example.com@EXAMPLE.COM].
(Mon Apr 20 19:43:58 2020) [[sssd[krb5_child[2102]]]] [get_and_save_tgt] (0x0020): 1741: [-1765328377][Server host/ldap-krb-client.example.com@EXAMPLE.COM not found in Kerberos database]
```

And the login is denied. If the real KDC picks it up, however, the host verification succeeds:
并且登录被拒绝。但是，如果真正的 KDC 选取它，则主机验证成功：

```auto
==> /var/log/sssd/krb5_child.log <==
(Mon Apr 20 19:46:22 2020) [[sssd[krb5_child[2268]]]] [validate_tgt] (0x0400): TGT verified using key for [host/ldap-krb-client.example.com@EXAMPLE.COM].
```

And the login is accepted.
并接受登录。

# Troubleshooting SSSD SSSD 疑难解答

Here are some tips to help troubleshoot SSSD.
以下是一些有助于解决 SSSD 问题的提示。

## `debug_level`

The debug level of SSSD can be changed on-the-fly via `sssctl`, from the `sssd-tools` package:
SSSD 的调试级别可以通过 `sssd-tools` 软件包中通过 `sssctl` 即时更改：

```bash
sudo apt install sssd-tools
sssctl debug-level <new-level>
```

Or add it to the config file and restart SSSD:
或者将其添加到配置文件并重新启动 SSSD：

```plaintext
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
debug_level = 6
...
```

Either approach will yield more logs in `/var/log/sssd/*.log` and can help identify what is happening. The `sssctl` approach has the clear advantage of not having to restart the service.
无论哪种方法都会产生更多的登录， `/var/log/sssd/*.log` 并有助于确定正在发生的事情。该 `sssctl` 方法具有无需重新启动服务的明显优势。

## Caching 缓存

Caching is useful to speed things up, but it can get in the way big time when  troubleshooting. It’s useful to be able to remove the cache while  chasing down a problem. This can also be done with the `sssctl` tool from the `sssd-tools` package.
缓存对于加快速度很有用，但在故障排除时可能会占用大量时间。在追查问题时能够删除缓存非常有用。这也可以使用 `sssd-tools` 软件包中 `sssctl` 的工具来完成。

You can either remove the whole cache:
您可以删除整个缓存：

```bash
# sssctl cache-remove
Creating backup of local data...
SSSD backup of local data already exists, override? (yes/no) [no] yes
Removing cache files...
SSSD= needs to be running. Start SSSD now? (yes/no) [yes] yes
```

Or just one element:
或者只是一个元素：

```bash
sssctl cache-expire -u john
```

Or expire everything: 或者让所有内容都过期：

```bash
sssctl cache-expire -E
```

## DNS

Kerberos is quite sensitive to DNS issues. If you suspect something related to DNS, here are two suggestions:
Kerberos 对 DNS 问题非常敏感。如果您怀疑与 DNS 有关，这里有两个建议：

### FQDN hostname FQDN 主机名

Make sure `hostname -f` returns a fully qualified domain name (FQDN). Set it in `/etc/hostname` if necessary, and use `sudo hostnamectl set-hostname <fqdn>` to set it at runtime.
确保 `hostname -f` 返回完全限定的域名 （FQDN）。如有必要，请将其设置 `/etc/hostname` ，并用于 `sudo hostnamectl set-hostname <fqdn>` 在运行时进行设置。

### Reverse name lookup 反向名称查找

You can try disabling a default reverse name lookup, which the `krb5` libraries do, by editing (or creating) `/etc/krb5.conf` and setting `rdns = false` in the `[libdefaults]` section:
您可以尝试通过编辑（或创建）并在以下 `[libdefaults]` 部分中设置 `rdns = false` 来禁用默认的反向名称查找，这是库执行的 `krb5` ： `/etc/krb5.conf` 

```plaintext
[libdefaults]
rdns = false
```



系统安全服务守护进程(System Security Services Daemon)  

红帽企业版Linux6中加入的一个守护进程，可以用来访问多种验证服务器，如LDAP，Kerberos等，并提供授权。是介于本地用户和数据存储之间的进程，本地客户端首先连接SSSD，再由SSSD联系外部资源提供者(一台远程服务器)。  

**优势：**  
1.避免了本地每个客户端程序对认证服务器大量连接，所有本地程序仅联系SSSD，由SSSD连接认证服务器或SSSD缓存，有效的降低了负载。  
2.允许离线授权。SSSD可以缓存远程服务器的用户认证身份，这允许在远程认证服务器宕机时，继续成功授权用户访问必要的资源。  

SSSD无需特殊设置即可运行，当配置完system-configure-authentication后该服务会自己运行。
SSSD默认配置文件位于/etc/sssd/sssd.conf，你可以通过命令使得SSSD以指定的配置文件运行：

    # sssd  --c  /etc/sssd/customfile.conf

配置文件格式如下:

    关键字=键值
    #####################################################
    ##  [section]                                      ##
    ##  key1 = value1                                  ##
    ##  key2 = value2,value3                           ##
    #####################################################

管理SSSD进程

    service  sssd  start 开启
    service  sssd  stop 关闭

使用authconfig命令开启SSSD：

    # authconfig  --enablesssd  --update

使用systemctl命令开启SSSD：

    # systemctl  enable  sssd

