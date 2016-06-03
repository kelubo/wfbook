# FreeIPA

## 配置要求
1. RHEL 7 x86_64  
2. Memory:
> 10000 users,100 groups,至少2GB内存和1GB Swap  
> 100000 users,50000 groups,至少16GB内存和4GB Swap

## 安装：

    yum install ipa-server

## Identity
从一个具有CLI, Web UI 或者 RPC access 的中心位置管理域中 Linux 用户和客户机。为所有的系统、服务和应用启用统一身份认证。

## Policy
为你的身份定义 Kerberos 认证和授权策略。控制服务，像 DNS ，SUDO ， SELinux 或者 autofs 。

## Trusts
和其他身份认证管理系统建立相互信任，例如 Microsoft Active Directory 。

## 主要特点
* Integrated security information management solution combining Linux (Fedora), 389 Directory Server, MIT Kerberos, NTP, DNS, Dogtag certificate system, SSSD and others.
* 建立在众所周知的开源组件和标准协议上。
* Strong focus on ease of management and automation of installation and configuration tasks.
* Full multi master replication for higher redundancy and scalability
* 可扩展的管理接口(CLI, Web UI, XMLRPC 和 JSONRPC API) 以及 Python SDK 。


