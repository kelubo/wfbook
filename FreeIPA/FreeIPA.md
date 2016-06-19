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
 * 10000 users,100 groups,至少2GB内存和1GB Swap
 * 100000 users,50000 groups,至少16GB内存和4GB Swap
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

## FreeIPA 管理用户

 在配置过程中，需要创建两个管理用户。目录管理员,需要用于执行罕见的底层任务。admin 用户，用于常规的管理活动。

对于 admin 用户的身份认证，执行：

    $ kinit admin
    Password for admin@EXAMPLE.COM:
 由此，获得了 Kerberos ticket 。

 ### 添加用户
添加用户：

     ipa user-add

设置密码：

     ipa passwd <user>

 创建一个密码，但它是临时的。在第一次认证的时候，需要更改。出于安全考虑。

使用如下命令，认证用户：

     kinit <user>

 ### Web 用户界面
 确认 administrative ticket ：

     kinit admin

## FreeIPA 帮助系统

ipa 命令：

    $ man ipa

IPA的核心特征之一是它的可扩展性和可插入性。这意味着新的功能可以在现有的、已经运行的服务器上添加。这也意味着帮助系统即 man pages 页面应可插拔和扩展。为了适应这一要求，IPA 含有一个已经超出手册页，允许附加信息的帮助系统。执行：

    $ ipa help topics to get a list of help topics
    $ ipa help <topic> to print help for chosen topic
    $ ipa help <command> to dive into the details of the command or topic
