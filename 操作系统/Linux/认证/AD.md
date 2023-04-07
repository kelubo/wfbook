# Active Directory

[TOC]

## 简介

Microsoft's Active Directory (AD) is, in most enterprises, the de facto authentication system for Windows systems and for external, LDAP-connected services. It allows you to configure users and groups, access control, permissions, auto-mounting, and more.

在大多数企业中，Microsoft 的 Active Directory（AD）是 Windows 系统和外部 LDAP 连接服务的事实上的身份验证系统。允许您配置用户和组、访问控制、权限、自动装载等。

现在，虽然将 Linux 连接到 AD 集群无法支持上述所有功能，但它可以处理用户、组和访问控制。甚至可以（通过 Linux 端的一些配置调整和 AD 端的一些高级选项）使用 AD 分发 SSH 密钥。

## Discovering and joining AD using SSSD

Note

Throughout this guide, the domain name `ad.company.local` will be used to represent the Active Directory domain. To follow this guide, replace it with the actual domain name your AD domain uses.

The first step along the way to join a Linux system into AD is to discover your AD cluster, to ensure that the network configuration is correct on both sides.

### Preparation[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#preparation)

- Ensure the following ports are open to your Linux host on your domain  controller:

| Service  | Port(s)           | Notes                                                       |
| -------- | ----------------- | ----------------------------------------------------------- |
| DNS      | 53 (TCP+UDP)      |                                                             |
| Kerberos | 88, 464 (TCP+UDP) | Used by `kadmin` for setting & updating passwords           |
| LDAP     | 389 (TCP+UDP)     |                                                             |
| LDAP-GC  | 3268 (TCP)        | LDAP Global Catalog - allows you to source user IDs from AD |

- Ensure you have configured your AD domain controller as a DNS server on your  Rocky Linux host:

**With NetworkManager:**  

```
# where your primary NetworkManager connection is 'System eth0' and your AD
# server is accessible on the IP address 10.0.0.2.
[root@host ~]$ nmcli con mod 'System eth0' ipv4.dns 10.0.0.2
```



**Manually editing the /etc/resolv.conf:**  

```
# Edit the resolv.conf file
[user@host ~]$ sudo vi /etc/resolv.conf
search lan
nameserver 10.0.0.2
nameserver 1.1.1.1 # replace this with your preferred public DNS (as a backup)

# Make the resolv.conf file unwritable, preventing NetworkManager from
# overwriting it.
[user@host ~]$ sudo chattr +i /etc/resolv.conf
```



- Ensure that the time on both sides (AD host and Linux system) is synchronized

**To check the time on Rocky Linux:**  

```
[user@host ~]$ date
Wed 22 Sep 17:11:35 BST 2021
```



- Install the required packages for AD connection on the Linux side:

```
[user@host ~]$ sudo dnf install realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation
```

### Discovery[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#discovery)

Now, you should be able to successfully discover your AD server(s) from your Linux host.

```
[user@host ~]$ realm discover ad.company.local
ad.company.local
  type: kerberos
  realm-name: AD.COMPANY.LOCAL
  domain-name: ad.company.local
  configured: no
  server-software: active-directory
  client-software: sssd
  required-package: oddjob
  required-package: oddjob-mkhomedir
  required-package: sssd
  required-package: adcli
  required-package: samba-common
```

This will be discovered using the relevant SRV records stored in your Active Directory DNS service.

### Joining[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#joining)

Once you have successfully discovered your Active Directory installation from the Linux host, you should be able to use `realmd` to join the domain, which will orchestrate the configuration of `sssd` using `adcli` and some other such tools.

```
[user@host ~]$ sudo realm join ad.company.local
```

If this process complains about encryption with `KDC has no support for encryption type`, try updating the global crypto policy to allow older encryption algorithms:

```
[user@host ~]$ sudo update-crypto-policies --set DEFAULT:AD-SUPPORT
```

If this process succeeds, you should now be able to pull `passwd` information for an Active Directory user.

```
[user@host ~]$ sudo getent passwd administrator@ad.company.local
administrator@ad.company.local:*:1450400500:1450400513:Administrator:/home/administrator@ad.company.local:/bin/bash
```

### Attempting to Authenticate[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#attempting-to-authenticate)

Now your users should be able to authenticate to your Linux host against Active Directory.

**On Windows 10:** (which provides its own copy of OpenSSH)

```
C:\Users\John.Doe> ssh -l john.doe@ad.company.local linux.host
Password for john.doe@ad.company.local:

Activate the web console with: systemctl enable --now cockpit.socket

Last login: Wed Sep 15 17:37:03 2021 from 10.0.10.241
[john.doe@ad.company.local@host ~]$
```

If this succeeds, you have successfully configured Linux to use Active Directory as an authentication source.

### Setting the default domain[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#setting-the-default-domain)

In a completely default setup, you will need to log in with your AD account by specifying the domain in your username (e.g. `john.doe@ad.company.local`). If this is not the desired behaviour, and you instead want to be able to omit the domain name at authentication time, you can configure SSSD to default to a specific domain.

This is actually a relatively simple process, and just requires a configuration tweak in your SSSD configuration file.

```
[user@host ~]$ sudo vi /etc/sssd/sssd.conf
[sssd]
...
default_domain_suffix = ad.company.local
```

By adding the `default_domain_suffix`, you are instructing SSSD to (if no other domain is specified) infer that the user is trying to authenticate as a user from the `ad.company.local` domain. This allows you to authenticate as something like `john.doe` instead of `john.doe@ad.company.local`.

To make this configuration change take effect, you must restart the `sssd.service` unit with `systemctl`.

```
[user@host ~]$ sudo systemctl restart sssd
```

Author: Hayden Young





Note

Throughout this guide, the domain name `ad.company.local` will be used to represent the Active Directory domain. To follow this guide, replace it with the actual domain name your AD domain uses.

The first step along the way to join a Linux system into AD is to discover your AD cluster, to ensure that the network configuration is correct on both sides.

### Preparation[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#preparation)

- Ensure the following ports are open to your Linux host on your domain  controller:

| Service  | Port(s)           | Notes                                                       |
| -------- | ----------------- | ----------------------------------------------------------- |
| DNS      | 53 (TCP+UDP)      |                                                             |
| Kerberos | 88, 464 (TCP+UDP) | Used by `kadmin` for setting & updating passwords           |
| LDAP     | 389 (TCP+UDP)     |                                                             |
| LDAP-GC  | 3268 (TCP)        | LDAP Global Catalog - allows you to source user IDs from AD |

- Ensure you have configured your AD domain controller as a DNS server on your  Rocky Linux host:

**With NetworkManager:**  

```
# where your primary NetworkManager connection is 'System eth0' and your AD
# server is accessible on the IP address 10.0.0.2.
[root@host ~]$ nmcli con mod 'System eth0' ipv4.dns 10.0.0.2
```



- Ensure that the time on both sides (AD host and Linux system) is synchronized (see chronyd)

**To check the time on Rocky Linux:**  

```
[user@host ~]$ date
Wed 22 Sep 17:11:35 BST 2021
```



- Install the required packages for AD connection on the Linux side:

```
[user@host ~]$ sudo dnf install realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation
```

### Discovery[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#discovery)

Now, you should be able to successfully discover your AD server(s) from your Linux host.

```
[user@host ~]$ realm discover ad.company.local
ad.company.local
  type: kerberos
  realm-name: AD.COMPANY.LOCAL
  domain-name: ad.company.local
  configured: no
  server-software: active-directory
  client-software: sssd
  required-package: oddjob
  required-package: oddjob-mkhomedir
  required-package: sssd
  required-package: adcli
  required-package: samba-common
```

This will be discovered using the relevant SRV records stored in your Active Directory DNS service.

### Joining[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#joining)

Once you have successfully discovered your Active Directory installation from the Linux host, you should be able to use `realmd` to join the domain, which will orchestrate the configuration of `sssd` using `adcli` and some other such tools.

```
[user@host ~]$ sudo realm join ad.company.local
```

If this process complains about encryption with `KDC has no support for encryption type`, try updating the global crypto policy to allow older encryption algorithms:

```
[user@host ~]$ sudo update-crypto-policies --set DEFAULT:AD-SUPPORT
```

If this process succeeds, you should now be able to pull `passwd` information for an Active Directory user.

```
[user@host ~]$ sudo getent passwd administrator@ad.company.local
administrator@ad.company.local:*:1450400500:1450400513:Administrator:/home/administrator@ad.company.local:/bin/bash
```

Note

`getent` get entries from Name Service Switch libraries (NSS). It means that, contrary to `passwd` or `dig` for example, it will query different databases, including `/etc/hosts` for `getent hosts` or from `sssd` in the `getent passwd` case.

`realm` provides some interesting options that you can use:

| Option                                                     | Observation                              |
| ---------------------------------------------------------- | ---------------------------------------- |
| --computer-ou='OU=LINUX,OU=SERVERS,dc=ad,dc=company.local' | The OU where to store the server account |
| --os-name='rocky'                                          | Specify the OS name stored in the AD     |
| --os-version='8'                                           | Specify the OS version stored in the AD  |
| -U admin_username                                          | Specify an admin account                 |

### Attempting to Authenticate[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#attempting-to-authenticate)

Now your users should be able to authenticate to your Linux host against Active Directory.

**On Windows 10:** (which provides its own copy of OpenSSH)

```
C:\Users\John.Doe> ssh -l john.doe@ad.company.local linux.host
Password for john.doe@ad.company.local:

Activate the web console with: systemctl enable --now cockpit.socket

Last login: Wed Sep 15 17:37:03 2021 from 10.0.10.241
[john.doe@ad.company.local@host ~]$
```

If this succeeds, you have successfully configured Linux to use Active Directory as an authentication source.

### Setting the default domain[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#setting-the-default-domain)

In a completely default setup, you will need to log in with your AD account by specifying the domain in your username (e.g. `john.doe@ad.company.local`). If this is not the desired behaviour, and you instead want to be able to omit the domain name at authentication time, you can configure SSSD to default to a specific domain.

This is actually a relatively simple process, and just requires a configuration tweak in your SSSD configuration file.

```
[user@host ~]$ sudo vi /etc/sssd/sssd.conf
[sssd]
...
default_domain_suffix = ad.company.local
```

By adding the `default_domain_suffix`, you are instructing SSSD to (if no other domain is specified) infer that the user is trying to authenticate as a user from the `ad.company.local` domain. This allows you to authenticate as something like `john.doe` instead of `john.doe@ad.company.local`.

To make this configuration change take effect, you must restart the `sssd.service` unit with `systemctl`.

```
[user@host ~]$ sudo systemctl restart sssd
```

In the same way, if you don't want your home directories to be suffixed by the domain name,  you can add those options into your configuration file `/etc/sssd/sssd.conf`:

```
[domain/ad.company.local]
use_fully_qualified_names = False
override_homedir = /home/%u
```

Don't forget to restart the `sssd` service.

### Restrict to certain users[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#restrict-to-certain-users)

There are various methods to restrict access to the server to a limited list of users, but this, as the name suggests, is certainly the simplest:

Add those options into your configuration file `/etc/sssd/sssd.conf` and restart the service:

```
access_provider = simple
simple_allow_groups = group1, group2
simple_allow_users = user1, user2
```

Now, only users from group1 and group2, or user1 and user2 will be able to connect to the server using sssd!

## Interact with the AD using `adcli`[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#interact-with-the-ad-using-adcli)

`adcli` is a CLI to perform actions on an Active Directory domain.

- If not yet installed, install the required package

```
[user@host ~]$ sudo dnf install adcli
```

- Test if you have ever joined an Active Directory domain:

```
[user@host ~]$ sudo adcli testjoin
Successfully validated join to domain ad.company.local
```

- Get more advanced informations about the domain:

```
[user@host ~]$ adcli info ad.company.local
[domain]
domain-name = ad.company.local
domain-short = AD
domain-forest = ad.company.local
domain-controller = dc1.ad.company.local
domain-controller-site = site1
domain-controller-flags = gc ldap ds kdc timeserv closest writable full-secret ads-web
domain-controller-usable = yes
domain-controllers = dc1.ad.company.local dc2.ad.company.local
[computer]
computer-site = site1
```

- More than a consulting tool, you can use adcli to interact with your domain: manage users or groups, change password, etc. 

Example: use `adcli` to get information about a computer:

Note

This time we will provide an admin username thanks to the `-U` option

```
[user@host ~]$ adcli show-computer pctest -U admin_username
Password for admin_username@AD: 
sAMAccountName:
 pctest$
userPrincipalName:
 - not set -
msDS-KeyVersionNumber:
 9
msDS-supportedEncryptionTypes:
 24
dNSHostName:
 pctest.ad.company.local
servicePrincipalName:
 RestrictedKrbHost/pctest.ad.company.local
 RestrictedKrbHost/pctest
 host/pctest.ad.company.local
 host/pctest
operatingSystem:
 Rocky
operatingSystemVersion:
 8
operatingSystemServicePack:
 - not set -
pwdLastSet:
 133189248188488832
userAccountControl:
 69632
description:
 - not set -
```

Example: use `adcli` to change user's password:

```
[user@host ~]$ adcli passwd-user user_test -U admin_username
Password for admin_username@AD: 
Password for user_test: 
[user@host ~]$ 
```

## Troubleshooting[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#troubleshooting)

Sometimes, the network service will start after SSSD, that cause trouble with authentication.

No AD users will be able to connect until you restarted the service.

In that case, you will have to override the systemd's service file to manage this problem.

Copy this content into `/etc/systemd/system/sssd.service`:

```
[Unit]
Description=System Security Services Daemon
# SSSD must be running before we permit user sessions
Before=systemd-user-sessions.service nss-user-lookup.target
Wants=nss-user-lookup.target
After=network-online.target


[Service]
Environment=DEBUG_LOGGER=--logger=files
EnvironmentFile=-/etc/sysconfig/sssd
ExecStart=/usr/sbin/sssd -i ${DEBUG_LOGGER}
Type=notify
NotifyAccess=main
PIDFile=/var/run/sssd.pid

[Install]
WantedBy=multi-user.target
```

The next reboot, the service will start after its requirements, and everything will go well.

## Leaving the Active Directory[¶](https://docs.rockylinux.org/zh/guides/security/authentication/active_directory_authentication/#leaving-the-active-directory)

Sometimes, it's necessary to leave the AD.

You can, once again, proceed with `realm` and then remove the packages that are no longer required:

```
[user@host ~]$ sudo realm leave ad.company.local
[user@host ~]$ sudo dnf remove realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation
```

------

使用SSSD¶发现和加入AD

笔记

在本指南中，域名ad.company.local将用于表示Active Directory域。若要遵循此指南，请将其替换为AD域使用的实际域名。

将Linux系统加入AD的第一步是发现您的AD集群，以确保双方的网络配置都是正确的。

准备¶

确保域控制器上的Linux主机已打开以下端口：

服务端口注释

DNS 53（TCP+UDP）

Kerberos 88464（TCP+UDP）kadmin用于设置和更新密码

LDAP 389（TCP+UDP）

LDAP-GC 3268（TCP）LDAP全局编录-允许您从AD中获取用户ID

确保已将AD域控制器配置为Rocky Linux主机上的DNS服务器：

使用Network Manager：

\#其中您的主要Network Manager连接是“System eth0”和您的AD

\#可以在IP地址10.0.0.2上访问服务器。

[root@host~]$nmcli con mod“系统eth0”ipv4.dns 10.0.0.2

确保双方（AD主机和Linux系统）的时间同步（请参阅chronyd）

要在Rocky Linux上检查时间：

[user@host~]$日期

9月22日星期三17:11:35英国夏令时2021

在Linux端安装AD连接所需的软件包：

[user@host~]$sudo dnf install realmd oddjoboddjob mkhomedir sssd adcli krb5工作站

发现¶

现在，您应该能够从Linux主机成功地发现您的AD服务器。

[user@host~]$realm发现广告.company.local

广告公司本地

类型：kerberos

领域名称：AD.COMPANY.LOCAL

域名：ad.company.local

已配置：否

服务器软件：active directory

客户端软件：sssd

所需程序包：oddjob

所需的程序包：oddjob mkhomedir

必需的程序包：sssd

必需的软件包：adcli

必需的软件包：samba common

这将使用存储在Active Directory DNS服务中的相关SRV记录来发现。

加入¶

在Linux主机上成功发现Active Directory安装后，您应该能够使用realmd加入域，该域将使用adcli和其他一些类似工具协调sssd的配置。

[user@host~]$sudo领域加入ad.company.local

如果此进程抱怨KDC不支持加密类型的加密，请尝试更新全局加密策略以允许较旧的加密算法：

[user@host~]$sudo更新加密策略--设置DEFAULT:AD-SUPPORT

如果此过程成功，您现在应该能够提取Active Directory用户的密码信息。

[user@host~]$sudo获取密码administrator@ad.company.local

administrator@ad.company.local：*：1450400500:1450040513:管理员：/home/administrator@ad.company.local：/bin/bash

笔记

getent从名称服务交换机库（NSS）中获取条目。这意味着，与passwd或dig相反，例如，它将查询不同的数据库，包括/etc/hosts的getent hosts，或者在getent passwd的情况下从sssd查询。

realm提供了一些有趣的选项，您可以使用这些选项：

期权观察

--computer ou='ou=LINUX，ou=SERVERS，dc=ad，dc=company.local'存储服务器帐户的ou

--os name='locky'指定存储在AD中的操作系统名称

--操作系统版本='8'指定存储在AD中的操作系统版本

-U管理员用户名指定管理员帐户

尝试验证¶

现在，您的用户应该能够通过Active Directory向您的Linux主机进行身份验证。

在Windows 10上：（它提供自己的Open SSH副本）

C： \用户\ John.Doe>ssh-ljohn.doe@ad.company.locallinux主机

的密码john.doe@ad.company.local:

使用：systemctl enable--now cockpit.socket激活web控制台

上次登录时间：9月15日星期三17:37:03 2021 10:10.241

[john.doe@ad.company.local@主机~]$

如果成功，则表示您已成功将Linux配置为使用Active Directory作为身份验证源。

设置默认域¶

在完全默认的设置中，您需要通过在用户名中指定域（例如。john.doe@ad.company.local). 如果这不是所需的行为，并且您希望能够在身份验证时省略域名，则可以将SSSD配置为默认为特定域。

这实际上是一个相对简单的过程，只需要在SSSD配置文件中进行配置调整。

[user@host~]$sudo vi/etc/sssd/sssd.conf

[sssd]

...

默认域后缀=ad.company.local

通过添加默认的域后缀，您指示SSSD（如果没有指定其他域）推断用户正试图从ad.company.local域验证为用户。这允许您以类似john.doe的身份进行身份验证，而不是john.doe@ad.company.local.

要使此配置更改生效，必须使用systemctl重新启动sssd.service单元。

[user@host~]$sudo系统