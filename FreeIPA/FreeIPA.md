# FreeIPA

## Identity
从一个具有CLI, Web UI 或者 RPC access 的中心位置管理域中 Linux 用户和客户机。为所有的系统、服务和应用启用统一身份认证。

## Policy
为你的身份定义 Kerberos 认证和授权策略。控制服务，像 DNS ，SUDO ， SELinux 或者 autofs 。

## Trusts
和其他身份认证管理系统建立相互信任，例如 Microsoft Active Directory 。

## 主要特点
* 集成的安全信息管理解决方案，结合了 Linux (Fedora)，389 Directory Server， MIT Kerberos， NTP， DNS， Dogtag certificate system， SSSD 和其他。
* 建立在众所周知的开源组件和标准协议上。
* Strong focus on ease of management and automation of installation and configuration tasks.
* Full multi master replication for higher redundancy and scalability
* 可扩展的管理接口(CLI, Web UI, XMLRPC 和 JSONRPC API) 以及 Python SDK 。

## 组件
* **MIT KDC** - core of the FreeIPA's authentication.
* **389 Directory Server** - back end where FreeIPA keeps all data.
* **Dogtag Certificate System** - FreeIPA includes CA & RA for certificate management functions.
* **SSSD** - client side component that integrates FreeIPA as a authentication and identity provider in a better way than traditional NSS & PAM.

## 部署

### 配置要求
1. RHEL 7 x86_64
2. Memory:
> 10000 users,100 groups,至少2GB内存和1GB Swap
> 100000 users,50000 groups,至少16GB内存和4GB Swap
3. 固定的 Hostname
4. DNS 规则
DNS domain 在安装完成后，不可修改。  
hostname 不能是 localhost 或者 localhost6 。  
hostname 必须是 fully-qualified (ipa.example.com)。
hostname 必须能够被解析。
The reverse of address that it resolves to must match the hostname.

### 安装 FreeIPA server

    # yum install freeipa-server

### 配置 FreeIPA server

    # ipa-server-install

Administrative users in FreeIPA

To be able to perform any administrative task you need to authenticate to the server. During the configuration step you have been prompted to create two users. The first one Directory Manager is the superuser that needs to be used to perform rare low level tasks. For the normal administrative activity an administrative account admin has been created.

To authenticate as the admin, just run:

$ kinit admin
Password for admin@EXAMPLE.COM:

You will be prompted for the password. Use the password that you specified during the configuration step for the admin user. As a result of this operation you acquire Kerberos ticket (more info).
Help system in FreeIPA

You can use the ticket acquired as a result of the operation described above to perform different administrative tasks. The first task that we will do is add a user via command line. To do that we will first inspect the command line interface by reading man pages of the ipa command:

$ man ipa

One of the core features of IPA is its extensibility and pluggability. This means that new functionality can be added later on top of the existing, already running server. This also means that the help system i.e. man pages should be pluggable and extensible. To accommodate this requirement the ipa has a help system beyond man pages that allows addition of the information. To get more information, run:

    $ ipa help topics to get a list of help topics
    $ ipa help <topic> to print help for chosen topic
    $ ipa help <command> to dive into the details of the command or topic

Adding your first user

Run ipa help user to see help on the user operations. Keep in mind that the password management is a separate step and operation so after a user is created the password for him should be set using ipa passwd command otherwise the newly created user would not be able to authenticate.

To create a user run

ipa user-add

command with or without additional parameters. If you omit any of the required parameters or all of them the interface will prompt you for the information.

After adding user add a password for him:

ipa passwd <user>

This will create a password, but it will be a temporary one. The one that you need to change on the first authentication. This is done on purpose so that administrator can reset a password for a user but would not be able to take advantage of that knowledge since user would has to change the password on the first login.

You can now authenticate as the new user with

kinit <user>

command. This will prompt you for a password and the immediately request a password change.
Web User Interface

Next step is to try the web UI. Make sure that your administrative ticket is valid by running

kinit admin

command. Run firefox in the same command window. It will start an instance of the firefox. In the address bar type the name of the FreeIPA server machine (e.g. ipa.example.com).

As the first step the FreeIPA server via browser will ask you to accept a certificate for a secure SSL communication between your client (browser) and the server (ipa). Follow the prompts and accept the exception. Be sure that imported certificate is comes from FreeIPA server and not from attacker!

When certificate is accepted, Web UI will most likely detect that it does not have any Kerberos credentials available and will show up user and password login screen. To properly configure the browser, you can follow a link on the log in screen to run the configuration tool.
