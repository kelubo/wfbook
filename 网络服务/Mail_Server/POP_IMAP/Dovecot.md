# Dovecot

[TOC]

## 概述

Dovecot 是一个高性能邮件发送代理（MDA），专注于安全性。可以使用 IMAP 或 POP3 兼容电子邮件客户端连接到 Dovecot 服务器，并读取或下载电子邮件。

Dovecot 的主要特性：

- 设计和实施侧重于安全性
- 对高可用性的双向复制支持以提高大型环境中的性能
- 支持高性能 `dbox` 邮箱格式，但出于兼容性的原因，也支持 `mbox` 和 `Maildir`
- 自我修复功能，如修复有问题的索引文件
- 遵守 IMAP 标准
- 临时解决方案支持绕过 IMAP 和 POP3 客户端中的 bug

## 建立具有 PAM 验证的 Dovecot 服务器

Dovecot 支持名称服务交换机（NSS）接口作为用户数据库，以及可插拔验证模块（PAM）框架作为身份验证后端。使用这个配置，Dovecot 可以通过 NSS 为服务器上的本地用户提供服务。 

以下帐户使用 PAM 身份验证：

- 在 `/etc/passwd` 文件中本地定义的。
- 存储在远程数据库中，但可以通过系统安全服务守护进程（SSSD）或其他 NSS 插件在本地提供。

### 安装 Dovecot

`dovecot` 软件包提供： 			

- `dovecot` 服务以及维护它的工具
- Dovecot 按需启动的服务，如用于身份验证
- 插件，如服务器端的邮件过滤
- `/etc/dovecot/` 目录中的配置文件
- `/usr/share/doc/dovecot/` 目录中的文档

```bash
dnf install dovecot
```

> 注意：
>
> 如果 Dovecot 已安装，并且需要清理配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在不删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。

### 在 Dovecot 服务器上配置 TLS 加密

Dovecot 提供一个安全的默认配置。例如，默认启用 TLS 通过网络来传输加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，只需设置证书和私钥文件的路径。另外，可以通过生成和使用 Diffie-Hellman 参数来提高 TLS  连接的安全性，以提供完美转发保密(PFS)。 			

**先决条件**

- Dovecot 已安装。 					
- 以下文件已复制到服务器上列出的位置： 					
  - 服务器证书：`/etc/pki/dovecot/certs/server.example.com.crt` 							
  - 私钥：`/etc/pki/dovecot/private/server.example.com.key` 							
  - 证书颁发机构(CA)证书：`/etc/pki/dovecot/certs/ca.crt` 							
- 服务器证书 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					
- 如果启用了 FIPS 模式，客户端必须支持扩展主 Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。如需更多信息，请参阅红帽知识库解决方案 [强制实施 TLS 扩展"Extended Master Secret"](https://access.redhat.com/solutions/7018256) 。 					

1. 对私钥文件设置安全权限： 					

   ```plaintext
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

2. 使用 Diffie-Hellman 参数生成文件： 					

   ```plaintext
   # openssl dhparam -out /etc/dovecot/dh.pem 4096
   ```

   根据服务器上的硬件和熵，生成 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

3. 在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置证书和私钥文件的路径： 					

   1. 更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

      ```plaintext
      ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
      ssl_key = </etc/pki/dovecot/private/server.example.com.key                     
      ```

   2. 取消 `ssl_ca` 参数的注释，并将其设置为使用 CA 证书的路径： 							

      ```plaintext
      ssl_ca = </etc/pki/dovecot/certs/ca.crt                          
      ```

   3. 取消 `ssl_dh` 参数的注释，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

      ```plaintext
      ssl_dh = </etc/dovecot/dh.pem
      ```

      > 重要：
      >
      > 为确保 Dovecot 从文件中读取参数的值，该路径必须以 `<` 字符开头。

### 准备 Dovecot 以使用虚拟用户                                                                                                                    

默认情况下，Dovecot 以使用服务的用户的身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几点好处：

- Dovecot 以特定的本地用户身份执行文件系统操作，而不使用用户的 ID (UID)。 					
- 用户不需要在服务器上本地提供。 					
- 可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- 用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- 有权访问服务器上文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- 设置复制很简单。

1. 创建 `vmail` 用户： 					

   ```plaintext
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要为此使用 `dovecot` 或 `dovenull` 系统用户。 					

2. 如果您使用与 `/var/mail/` 不同的路径，请对其设置 `mail_spool_t` SELinux 上下文，例如： 					

   ```plaintext
   # semanage fcontext -a -t mail_spool_t "<path>(/.)?"*
   # restorecon -Rv <path>                          
   ```

3. 仅将 `/var/mail/` 的写权限授予 `vmail` 用户： 					

   ```plaintext
   # chown vmail:vmail /var/mail/
   # chmod 700 /var/mail/                          
   ```

4. 取消 `/etc/dovecot/conf.d/10-mail.conf` 文件中 `mail_location` 参数的注释，并将其设置为 mailbox 格式和位置： 					

   ```plaintext
   mail_location = sdbox:/var/mail/%n/
   ```

   使用这个设置： 					

   - Dovecot 在 `single` 模式下使用高性能 `dbox` 邮箱格式。在此模式下，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。
   - Dovecot 将路径中的 `%n` 变量解析为用户名。这需要确保每个用户对其邮箱都有一个单独的目录。

### 使用 PAM 作为 Dovecot 身份验证后端

默认情况下，Dovecot 使用名称服务交换机(NSS)接口作为用户数据库，使用可插拔验证模块(PAM)框架作为身份验证后端。 			

自定义设置，以使 Dovecot 适应您的环境，并使用虚拟用户功能简化管理。 			

**先决条件**

- ​							Dovecot 已安装。 					
- ​							虚拟用户功能已配置。 					

**流程**

1. 更新 `/etc/dovecot/conf.d/10-mail.conf` 文件中的 `first_valid_uid` 参数，以定义可以验证到 Dovecot 的最低用户 ID (UID)： 					

   ```plaintext
   first_valid_uid = 1000
   ```

   ​                

   ​                          

   ​							默认情况下，UID 大于或等于 `1000` 的用户可以进行身份验证。如果需要，您也可以设置 `last_valid_uid` 参数，以定义 Dovecot 允许登录的最高 UID。 					

2. 在 `/etc/dovecot/conf.d/auth-system.conf.ext` 文件中，将 `override_fields` 参数添加到 `userdb` 部分，如下所示： 					

   ```bash
   userdb {
     driver = passwd
     override_fields = uid=vmail gid=vmail home=/var/mail/%n/
   }
   ```

   由于值固定，Dovecot 不会从 `/etc/passwd` 文件查询这些设置。因此，`/etc/passwd` 中定义的主目录不需要存在。 					

### 完成 Dovecot 配置                                                                                                                    

安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动服务。之后，您可以测试服务器。 			

**先决条件**

- 在 Dovecot 中已配置了以下内容： 					
  - TLS 加密 							
  - 身份验证后端 							
- 客户端信任证书颁发机构(CA)证书。

1. 如果您只想向用户提供 IMAP 或 POP3 服务，请取消 `/etc/dovecot/dovecot.conf` 文件中`protocols` 参数的注释，并将其设置为所需的协议。例如，如果您不需要 POP3，请设置： 					

   ```bash
   protocols = imap lmtp
   ```

   默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

2. 在本地防火墙中打开端口。例如，要为 IMAPS、IMAP、POP3S 和 POP3 协议打开端口，请输入： 

   ```
   # firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
   # firewall-cmd --reload			
   ```

3. 启用并启动 `dovecot` 服务： 						

   ```plaintext
   	# systemctl enable --now dovecot
   ```

**验证**

1. 使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot ，并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   | 协议  | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ----- | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP  | 143  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/configuring-and-maintaining-a-dovecot-imap-and-pop3-server#ftn.fn-dovecot-con-settings-normal-pw_dovecot-pam) |
   | IMAPS | 993  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/configuring-and-maintaining-a-dovecot-imap-and-pop3-server#ftn.fn-dovecot-con-settings-normal-pw_dovecot-pam) |
   | POP3  | 110  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/configuring-and-maintaining-a-dovecot-imap-and-pop3-server#ftn.fn-dovecot-con-settings-normal-pw_dovecot-pam) |
   | POP3S | 995  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/configuring-and-maintaining-a-dovecot-imap-and-pop3-server#ftn.fn-dovecot-con-settings-normal-pw_dovecot-pam) |

   [[a\] ](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/configuring-and-maintaining-a-dovecot-imap-and-pop3-server#fn-dovecot-con-settings-normal-pw_dovecot-pam) 客户端通过 TLS 连接传输加密的数据。因此，凭证不会被披露。 

   请注意，这个表不会列出未加密连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接上不接受纯文本身份验证。 					

2. 显示具有非默认值的配置设置： 					

   ```plaintext
   # doveconf -n
   ```



# 设置具有 LDAP 身份验证的 Dovecot 服务器

------

​				如果您的基础架构使用 LDAP 服务器来存储帐户，您可以对其验证 Dovecot 用户。在这种情况下，您可以在目录中集中管理帐户，用户不需要对 Dovecot 服务器上的文件系统进行本地访问。 		

​				如果您计划设置具有复制的多个 Dovecot 服务器，以使您的邮箱具有高可用性，则集中管理的帐户也是一个好处。 		

### [1.2.1. 安装 Dovecot](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#installing-dovecot_dovecot-ldap)                                                                                                                    

​					`dovecot` 软件包提供： 			

- ​							`dovecot` 服务以及维护它的工具 					
- ​							Dovecot 按需启动的服务，如用于身份验证 					
- ​							插件，如服务器端的邮件过滤 					
- ​							`/etc/dovecot/` 目录中的配置文件 					
- ​							`/usr/share/doc/dovecot/` 目录中的文档 					

**流程**

- ​							安装 `dovecot` 软件包： 					

  ```plaintext
  # dnf install dovecot
  ```

  ​                

  ​                          

  ​      

  注意

  ​								如果 Dovecot 已安装，并且需要清理配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在不删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。 						

  ​                      

**后续步骤**

- ​							[在 Dovecot 服务器上配置 TLS 加密](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#configuring-tls-encryption-on-a-dovecot-server_dovecot-ldap)。 					

### [1.2.2. 在 Dovecot 服务器上配置 TLS 加密](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#configuring-tls-encryption-on-a-dovecot-server_dovecot-ldap)                                                                                                                    

​					Dovecot 提供一个安全的默认配置。例如，默认启用 TLS 通过网络来传输加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，您只需设置证书和私钥文件的路径。另外，您可以通过生成和使用 Diffie-Hellman 参数来提高 TLS  连接的安全性，以提供完美转发保密(PFS)。 			

**先决条件**

- ​							Dovecot 已安装。 					
- ​							以下文件已复制到服务器上列出的位置： 					
  - ​									服务器证书：`/etc/pki/dovecot/certs/server.example.com.crt` 							
  - ​									私钥：`/etc/pki/dovecot/private/server.example.com.key` 							
  - ​									证书颁发机构(CA)证书：`/etc/pki/dovecot/certs/ca.crt` 							
- ​							服务器证书 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					
- ​							如果启用了 FIPS 模式，客户端必须支持扩展主 Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。如需更多信息，请参阅红帽知识库解决方案 [强制实施 TLS 扩展"Extended Master Secret"](https://access.redhat.com/solutions/7018256) 。 					

**流程**

1. ​							对私钥文件设置安全权限： 					

   ```plaintext
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

   ​                

   ​                          

2. ​							使用 Diffie-Hellman 参数生成文件： 					

   ```plaintext
   # openssl dhparam -out /etc/dovecot/dh.pem 4096
   ```

   ​                

   ​                          

   ​							根据服务器上的硬件和熵，生成 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

3. ​							在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置证书和私钥文件的路径： 					

   1. ​									更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

      ```plaintext
      ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
      ssl_key = </etc/pki/dovecot/private/server.example.com.key
      ```

      ​                

      ​                          

   2. ​									取消 `ssl_ca` 参数的注释，并将其设置为使用 CA 证书的路径： 							

      ```plaintext
      ssl_ca = </etc/pki/dovecot/certs/ca.crt
      ```

      ​                

      ​                          

   3. ​									取消 `ssl_dh` 参数的注释，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

      ```plaintext
      ssl_dh = </etc/dovecot/dh.pem
      ```

      ​                

      ​                          

   ​      

   重要

   ​								为确保 Dovecot 从文件中读取参数的值，该路径必须以 `<` 字符开头。 						

   ​                      

**后续步骤**

- ​							[准备 Dovecot 以使用虚拟用户](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#preparing-dovecot-to-use-virtual-users_dovecot-ldap) 					

**其它资源**

- ​							`/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt` 					

### [1.2.3. 准备 Dovecot 以使用虚拟用户](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#preparing-dovecot-to-use-virtual-users_dovecot-ldap)                                                                                                                    

​					默认情况下，Dovecot 以使用服务的用户的身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几点好处： 			

- ​							Dovecot 以特定的本地用户身份执行文件系统操作，而不使用用户的 ID (UID)。 					
- ​							用户不需要在服务器上本地提供。 					
- ​							您可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- ​							用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- ​							有权访问服务器上文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- ​							设置复制很简单。 					

**先决条件**

- ​							Dovecot 已安装。 					

**流程**

1. ​							创建 `vmail` 用户： 					

   ```plaintext
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   ​                

   ​                          

   ​							Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要为此使用 `dovecot` 或 `dovenull` 系统用户。 					

2. ​							如果您使用与 `/var/mail/` 不同的路径，请对其设置 `mail_spool_t` SELinux 上下文，例如： 					

   ```plaintext
   # semanage fcontext -a -t mail_spool_t "<path>(/.)?"*
   # restorecon -Rv <path>
   ```

   ​                

   ​                          

3. ​							仅将 `/var/mail/` 的写权限授予 `vmail` 用户： 					

   ```plaintext
   # chown vmail:vmail /var/mail/
   # chmod 700 /var/mail/
   ```

   ​                

   ​                          

4. ​							取消 `/etc/dovecot/conf.d/10-mail.conf` 文件中 `mail_location` 参数的注释，并将其设置为 mailbox 格式和位置： 					

   ```plaintext
   mail_location = sdbox:/var/mail/%n/
   ```

   ​                

   ​                          

   ​							使用这个设置： 					

   - ​									Dovecot 在 `single` 模式下使用高性能 `dbox` 邮箱格式。在此模式下，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。 							
   - ​									Dovecot 将路径中的 `%n` 变量解析为用户名。这需要确保每个用户对其邮箱都有一个单独的目录。 							

**后续步骤**

- ​							[使用 LDAP 作为 Dovecot 身份验证后端](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#using-ldap-as-the-dovecot-authentication-backend). 					

**其它资源**

- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailLocation.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailboxFormat.dbox.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/Variables.txt` 					

### [1.2.4. 使用 LDAP 作为 Dovecot 身份验证后端](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#using-ldap-as-the-dovecot-authentication-backend)                                                                                                                    

​					LDAP 目录中的用户通常可以向目录服务进行身份验证。Dovecot 可在用户登录到 IMAP 和 POP3 服务时使用此来验证它们。这个验证方法有几个优点，例如： 			

- ​							管理员可以在目录中集中管理用户。 					
- ​							LDAP 帐户不需要任何特殊属性。它们只需要能够向 LDAP 服务器进行身份验证。因此，此方法独立于 LDAP 服务器上使用的密码存储方案。 					
- ​							用户不需要通过名称服务交换机(NSS)界面和可插拔验证模块(PAM)框架在服务器上本地提供。 					

**先决条件**

- ​							Dovecot 已安装。 					
- ​							虚拟用户功能已配置。 					
- ​							到 LDAP 服务器的连接支持 TLS 加密。 					
- ​							Dovecot 服务器上的 RHEL 信任 LDAP 服务器的证书颁发机构(CA)证书。 					
- ​							如果用户存储在 LDAP 目录中的不同树中，则存在用于 Dovecot 的专用 LDAP 帐户，以搜索目录。此帐户需要搜索其他用户的可辨识名称(DN)的权限。 					
- ​							如果启用了 FIPS 模式，这个 Dovecot 服务器支持扩展 Master Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。如需更多信息，请参阅红帽知识库解决方案 [强制实施 TLS 扩展"Extended Master Secret"](https://access.redhat.com/solutions/7018256) 。 					

**流程**

1. ​							在 `/etc/dovecot/conf.d/10-auth.conf` 文件中配置身份验证后端： 					

   1. ​									注释掉您不需要的 `auth-*.conf.ext` 身份验证后端配置文件的 `include` 语句，例如： 							

      ```plaintext
      #!include auth-system.conf.ext
      ```

      ​                

      ​                          

   2. ​									通过取消下列行的注释来启用 LDAP 身份验证： 							

      ```plaintext
      !include auth-ldap.conf.ext
      ```

      ​                

      ​                          

2. ​							编辑 `/etc/dovecot/conf.d/auth-ldap.conf.ext` 文件，并按如下所示将 `override_fields` 参数添加到 `userdb` 部分： 					

   ```bash
   userdb {
     driver = ldap
     args = /etc/dovecot/dovecot-ldap.conf.ext
     override_fields = uid=vmail gid=vmail home=/var/mail/%n/
   }
   ```

   ​                

   

   ​                          

   ​                  

   ​							由于值固定，Dovecot 不会从 LDAP 服务器查询这些设置。因此，这些属性也不是必须出现。 					

3. ​							使用以下设置创建 `/etc/dovecot/dovecot-ldap.conf.ext` 文件： 					

   1. ​									根据 LDAP 结构，配置以下之一： 							

      - ​											如果用户存储在 LDAP 目录中的不同树中，请配置动态 DN 查找： 									

        ```bash
        dn = cn=dovecot_LDAP,dc=example,dc=com
        dnpass = <password>
        pass_filter = (&(objectClass=posixAccount)(uid=%n))
        ```

        ​                

        

        ​                          

        ​											Dovecot 使用指定的 DN、密码和过滤器在目录中搜索身份验证用户的 DN。在此搜索中，Dovecot 将过滤器中的 `%n` 替换为用户名。请注意，LDAP 搜索必须只返回一个结果。 									

      - ​											如果所有用户都存储在特定条目下，请配置 DN 模板： 									

        ```plaintext
        auth_bind_userdn = cn=%n,ou=People,dc=example,dc=com
        ```

        ​                

        ​                          

   2. ​									启用绑定到 LDAP 服务器的身份验证以验证 Dovecot 用户： 							

      ```plaintext
      auth_bind = yes
      ```

      ​                

      ​                          

      ​                  

   3. ​									将 URL 设置为 LDAP 服务器： 							

      ```plaintext
      uris = ldaps://LDAP-srv.example.com
      ```

      ​                

      ​                          

      ​                  

      ​									为安全起见，只有通过 LDAP 协议使用 LDAPS 或 `STARTTLS` 命令来使用加密连接。对于后者，在设置中额外添加 `tls = yes`。 							

      ​									对于正常工作的证书验证，LDAP 服务器的主机名必须与其 TLS 证书中使用的主机名匹配。 							

   4. ​									启用 LDAP 服务器的 TLS 证书的验证： 							

      ```plaintext
      tls_require_cert = hard
      ```

      ​                

      ​                          

   5. ​									将基本 DN 设置为要开始搜索用户的 DN： 							

      ```plaintext
      base = ou=People,dc=example,dc=com
      ```

      ​                

      ​                          

   6. ​									设置搜索范围： 							

      ```plaintext
      scope = onelevel
      ```

      ​                

      ​                          

      ​									Dovecot 仅在指定的基本 DN 中使用 `onelevel` 范围搜索，并且也使用子树中的 `subtree` 范围搜索。 							

4. ​							对 `/etc/dovecot/dovecot-ldap.conf.ext` 文件设置安全权限： 					

   ```plaintext
   # chown root:root /etc/dovecot/dovecot-ldap.conf.ext
   # chmod 600 /etc/dovecot/dovecot-ldap.conf.ext
   ```

   ​                

   ​                          

**后续步骤**

- ​							[完成 Dovecot 配置](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#completing-the-dovecot-configuration_dovecot-ldap)。 					

**其它资源**

- ​							`/usr/share/doc/dovecot/example-config/dovecot-ldap.conf.ext` 					
- ​							`/usr/share/doc/dovecot/wiki/UserDatabase.Static.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.AuthBinds.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.PasswordLookups.txt` 					

### [1.2.5. 完成 Dovecot 配置](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#completing-the-dovecot-configuration_dovecot-ldap)                                                                                                                    

​					安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动服务。之后，您可以测试服务器。 			

**先决条件**

- ​							在 Dovecot 中已配置了以下内容： 					
  - ​									TLS 加密 							
  - ​									身份验证后端 							
- ​							客户端信任证书颁发机构(CA)证书。 					

**流程**

1. ​							如果您只想向用户提供 IMAP 或 POP3 服务，请取消 `/etc/dovecot/dovecot.conf` 文件中`protocols` 参数的注释，并将其设置为所需的协议。例如，如果您不需要 POP3，请设置： 					

   ```bash
   protocols = imap lmtp
   ```

   ​                

   ​                          

   ​							默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

2. ​							在本地防火墙中打开端口。例如，要为 IMAPS、IMAP、POP3S 和 POP3 协议打开端口，请输入： 					

   ```plaintext
   # firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
   # firewall-cmd --reload
   ```

   ​                

   ​                          

3. ​							启用并启动 `dovecot` 服务： 					

   ```plaintext
   # systemctl enable --now dovecot
   ```

   ​                

   ​                          

**验证**

1. ​							使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot ，并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   | 协议                                                         | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ------------------------------------------------------------ | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP                                                         | 143  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-ldap) |
   | IMAPS                                                        | 993  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-ldap) |
   | POP3                                                         | 110  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-ldap) |
   | POP3S                                                        | 995  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-ldap) |
   | [[a\] ](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-ldap-authentication#fn-dovecot-con-settings-normal-pw_dovecot-ldap) 											客户端通过 TLS 连接传输加密的数据。因此，凭证不会被披露。 |      |            |                                                              |

   ​							请注意，这个表不会列出未加密连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接上不接受纯文本身份验证。 					

2. ​							显示具有非默认值的配置设置： 					

   ```plaintext
   # doveconf -n
   ```

   ​                

   ​          

**其他资源**

- ​							您系统上的 `firewall-cmd (1)` 手册页 					



# 设置具有 MariaDB SQL 身份验证的 Dovecot 服务器

------

​				如果您将用户和密码存储在 MariaDB SQL 服务器中，您可以将 Dovecot 配置为将其用作用户数据库和身份验证后端。使用这个配置，您可以在数据库中集中管理帐户，用户对 Dovecot 服务器上的文件系统没有本地访问权限。 		

​				如果您计划设置具有复制的多个 Dovecot 服务器，以使您的邮箱具有高可用性，则集中管理的帐户也是一个好处。 		

### [1.3.1. 安装 Dovecot](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#installing-dovecot_dovecot-sql)                                                                                

###           

​					`dovecot` 软件包提供： 			

- ​							`dovecot` 服务以及维护它的工具 					
- ​							Dovecot 按需启动的服务，如用于身份验证 					
- ​							插件，如服务器端的邮件过滤 					
- ​							`/etc/dovecot/` 目录中的配置文件 					
- ​							`/usr/share/doc/dovecot/` 目录中的文档 					

**流程**

- ​							安装 `dovecot` 软件包： 					

  ```plaintext
  # dnf install dovecot
  ```

  ​                

  ​          

- 注意                                             							如果 Dovecot 已安装，并且需要清理配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在不删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。 						                                                            

**后续步骤**

- ​							[在 Dovecot 服务器上配置 TLS 加密](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#configuring-tls-encryption-on-a-dovecot-server_dovecot-sql)。 					

### [1.3.2. 在 Dovecot 服务器上配置 TLS 加密](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#configuring-tls-encryption-on-a-dovecot-server_dovecot-sql)                                                                                

###           

​					Dovecot 提供一个安全的默认配置。例如，默认启用 TLS 通过网络来传输加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，您只需设置证书和私钥文件的路径。另外，您可以通过生成和使用 Diffie-Hellman 参数来提高 TLS  连接的安全性，以提供完美转发保密(PFS)。 			

**先决条件**

- ​							Dovecot 已安装。 					
- ​							以下文件已复制到服务器上列出的位置： 					
  - ​									服务器证书：`/etc/pki/dovecot/certs/server.example.com.crt` 							
  - ​									私钥：`/etc/pki/dovecot/private/server.example.com.key` 							
  - ​									证书颁发机构(CA)证书：`/etc/pki/dovecot/certs/ca.crt` 							
- ​							服务器证书 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					
- ​							如果启用了 FIPS 模式，客户端必须支持扩展主 Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。如需更多信息，请参阅红帽知识库解决方案 [强制实施 TLS 扩展"Extended Master Secret"](https://access.redhat.com/solutions/7018256) 。 					

**流程**

1. ​							对私钥文件设置安全权限： 					

   ```plaintext
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

   ​                

   ​          

​							使用 Diffie-Hellman 参数生成文件： 					

```plaintext
# openssl dhparam -out /etc/dovecot/dh.pem 4096
```

​                

​          

​							根据服务器上的硬件和熵，生成 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

​							在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置证书和私钥文件的路径： 					

1. ​									更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

   ```plaintext
   ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
   ssl_key = </etc/pki/dovecot/private/server.example.com.key
   ```

   ​                

   ​          

​									取消 `ssl_ca` 参数的注释，并将其设置为使用 CA 证书的路径： 							

```plaintext
ssl_ca = </etc/pki/dovecot/certs/ca.crt
```

​                

​          

​									取消 `ssl_dh` 参数的注释，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

```plaintext
ssl_dh = </etc/dovecot/dh.pem
```

​                

​          

1. 重要                                             							为确保 Dovecot 从文件中读取参数的值，该路径必须以 `<` 字符开头。 						                                                            

**后续步骤**

- ​							[准备 Dovecot 以使用虚拟用户](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#preparing-dovecot-to-use-virtual-users_dovecot-sql) 					

**其它资源**

- ​							`/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt` 					

### [1.3.3. 准备 Dovecot 以使用虚拟用户](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#preparing-dovecot-to-use-virtual-users_dovecot-sql)                                                                                

### 复制链接                  

​					默认情况下，Dovecot 以使用服务的用户的身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几点好处： 			

- ​							Dovecot 以特定的本地用户身份执行文件系统操作，而不使用用户的 ID (UID)。 					
- ​							用户不需要在服务器上本地提供。 					
- ​							您可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- ​							用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- ​							有权访问服务器上文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- ​							设置复制很简单。 					

**先决条件**

- ​							Dovecot 已安装。 					

**流程**

1. ​							创建 `vmail` 用户： 					

   ```plaintext
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   ​                

   ​          

​							Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要为此使用 `dovecot` 或 `dovenull` 系统用户。 					

​							如果您使用与 `/var/mail/` 不同的路径，请对其设置 `mail_spool_t` SELinux 上下文，例如： 					

```plaintext
# semanage fcontext -a -t mail_spool_t "<path>(/.)?"*
# restorecon -Rv <path>
```

​                

​          

​							仅将 `/var/mail/` 的写权限授予 `vmail` 用户： 					

```plaintext
# chown vmail:vmail /var/mail/
# chmod 700 /var/mail/
```

​                

​          

​							取消 `/etc/dovecot/conf.d/10-mail.conf` 文件中 `mail_location` 参数的注释，并将其设置为 mailbox 格式和位置： 					

```plaintext
mail_location = sdbox:/var/mail/%n/
```

​                

​          

1. ​							使用这个设置： 					
   - ​									Dovecot 在 `single` 模式下使用高性能 `dbox` 邮箱格式。在此模式下，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。 							
   - ​									Dovecot 将路径中的 `%n` 变量解析为用户名。这需要确保每个用户对其邮箱都有一个单独的目录。 							

**后续步骤**

- ​							[使用 MariaDB SQL 数据库作为 Dovecot 身份验证后端](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#using-a-mariadb-sql-database-as-the-dovecot-authentication-backend) 					

**其它资源**

- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailLocation.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailboxFormat.dbox.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/Variables.txt` 					

### [1.3.4. 使用 MariaDB SQL 数据库作为 Dovecot 身份验证后端](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#using-a-mariadb-sql-database-as-the-dovecot-authentication-backend)                                                                                

###           

​					Dovecot 可以从 MariaDB 数据库读取帐户和密码，并在用户登录到 IMAP 或 POP3 服务时使用它来验证用户。这个验证方法的好处包括： 			

- ​							管理员可以在数据库中集中管理用户。 					
- ​							用户在服务器上没有本地访问权限。 					

**先决条件**

- ​							Dovecot 已安装。 					
- ​							虚拟用户功能已配置。 					
- ​							到 MariaDB 服务器的连接支持 TLS 加密。 					
- ​							MariaDB 中存在 `dovecotDB` 数据库，`users` 表至少包含 `username` 和 `password` 列。 					
- ​							`password` 列包含使用 Dovecot 支持的方案加密的密码。 					
- ​							密码可以使用相同的方案，或者有 `{*pw-storage-scheme*}` 前缀。 					
- ​							`dovecot` MariaDB 用户对 `dovecotDB` 数据库中的 `users` 表有读权限。 					
- ​							发布 MariaDB 服务器的 TLS 证书的证书颁发机构(CA)的证书存储在 Dovecot 服务器上的 `/etc/pki/tls/certs/ca.crt` 文件中。 					
- ​							如果启用了 FIPS 模式，这个 Dovecot 服务器支持扩展 Master Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。如需更多信息，请参阅红帽知识库解决方案 [强制实施 TLS 扩展"Extended Master Secret"](https://access.redhat.com/solutions/7018256) 。 					

**流程**

1. ​							安装 `dovecot-mysql` 软件包： 					

   ```plaintext
   # dnf install dovecot-mysql
   ```

   ​                

   ​          

​							在 `/etc/dovecot/conf.d/10-auth.conf` 文件中配置身份验证后端： 					

1. ​									注释掉您不需要的 `auth-*.conf.ext` 身份验证后端配置文件的 `include` 语句，例如： 							

   ```plaintext
   #!include auth-system.conf.ext
   ```

   ​                

   ​          

​									通过取消以下行的注释来启用 SQL 身份验证： 							

```plaintext
!include auth-sql.conf.ext
```

​                

​          

​							编辑 `/etc/dovecot/conf.d/auth-sql.conf.ext` 文件，并将 `override_fields` 参数添加到 `userdb` 部分，如下所示： 					

```bash
userdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
  override_fields = uid=vmail gid=vmail home=/var/mail/%n/
}
```

​                



​          

​							由于值固定，Dovecot 不会从 SQL 服务器查询这些设置。 					

​							使用以下设置创建 `/etc/dovecot/dovecot-sql.conf.ext` 文件： 					

```plaintext
driver = mysql**
connect = host=mariadb_srv.example.com dbname=dovecotDB user=dovecot password=_<dovecotPW>_ ssl_ca=/etc/pki/tls/certs/ca.crt
default_pass_scheme = SHA512-CRYPT
user_query = SELECT username FROM users WHERE username='%u';
password_query = SELECT username AS user, password FROM users WHERE username='%u';
iterate_query = SELECT username FROM users;
```

​                



​          

​							要对数据库服务器使用 TLS 加密，请将 `ssl_ca` 选项设置为发布 MariaDB 服务器证书的 CA 的证书路径。对于正常工作的证书验证，MariaDB 服务器的主机名必须与其 TLS 证书中使用的主机名匹配。 					

​							如果数据库中的密码值包含 `{ <*pw-storage-scheme>*; }` 前缀，您可以省略 `default_pass_scheme` 设置。 					

​							文件中的查询必须设置如下： 					

- ​									对于 `user_query` 参数，查询必须返回 Dovecot 用户的用户名。查询还必须只返回一个结果。 							
- ​									对于 `password_query` 参数，查询必须返回用户名和密码，并且 Dovecot 必须在 `user` 和 `password` 变量中使用这些值。因此，如果数据库使用不同的列名称，请使用 `AS` SQL 命令重命名结果中的列。 							
- ​									对于 `iterate_query` 参数，查询必须返回所有用户的列表。 							

​							对 `/etc/dovecot/dovecot-sql.conf.ext` 文件设置安全权限： 					

```plaintext
# chown root:root /etc/dovecot/dovecot-sql.conf.ext
# chmod 600 /etc/dovecot/dovecot-sql.conf.ext
```

​                

​          

**后续步骤**

- ​							[完成 Dovecot 配置](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#completing-the-dovecot-configuration_dovecot-sql)。 					

**其它资源**

- ​							`/usr/share/doc/dovecot/example-config/dovecot-sql.conf.ext` 					
- ​							`/usr/share/doc/dovecot/wiki/Authentication.PasswordSchemes.txt` 					

### [1.3.5. 完成 Dovecot 配置](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#completing-the-dovecot-configuration_dovecot-sql)                                                                                

###           

​					安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动服务。之后，您可以测试服务器。 			

**先决条件**

- ​							在 Dovecot 中已配置了以下内容： 					
  - ​									TLS 加密 							
  - ​									身份验证后端 							
- ​							客户端信任证书颁发机构(CA)证书。 					

**流程**

1. ​							如果您只想向用户提供 IMAP 或 POP3 服务，请取消 `/etc/dovecot/dovecot.conf` 文件中`protocols` 参数的注释，并将其设置为所需的协议。例如，如果您不需要 POP3，请设置： 					

   ```bash
   protocols = imap lmtp
   ```

   ​                

   ​          

​							默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

​							在本地防火墙中打开端口。例如，要为 IMAPS、IMAP、POP3S 和 POP3 协议打开端口，请输入： 					

```plaintext
# firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
# firewall-cmd --reload
```

​                

​          

​							启用并启动 `dovecot` 服务： 					

```plaintext
# systemctl enable --now dovecot
```

​                

​          

**验证**

1. ​							使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot ，并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   | 协议                                                         | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ------------------------------------------------------------ | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP                                                         | 143  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-sql) |
   | IMAPS                                                        | 993  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-sql) |
   | POP3                                                         | 110  | STARTTLS   | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-sql) |
   | POP3S                                                        | 995  | SSL/TLS    | PLAIN[[a\]](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#ftn.fn-dovecot-con-settings-normal-pw_dovecot-sql) |
   | [[a\] ](https://docs.redhat.com/zh-cn/documentation/red_hat_enterprise_linux/10/html/deploying_mail_servers/setting-up-a-dovecot-server-with-mariadb-sql-authentication#fn-dovecot-con-settings-normal-pw_dovecot-sql) 											客户端通过 TLS 连接传输加密的数据。因此，凭证不会被披露。 |      |            |                                                              |

   ​							请注意，这个表不会列出未加密连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接上不接受纯文本身份验证。 					

2. ​							显示具有非默认值的配置设置： 					

   ```plaintext
   # doveconf -n
   ```

   ​                

   ​          

**其他资源**

- ​							您系统上的 `firewall-cmd (1)` 手册页 					



# 1.4. 在两个 Dovecot 服务器之间配置复制

------

​				通过双向复制，您可以使 Dovecot 服务器高度可用，而 IMAP 和 POP3 客户端都可以访问这两个服务器上的邮箱。Dovecot 会跟踪每个邮箱的索引日志中的更改，并以安全的方式解决冲突。 		

​				在两个复制合作伙伴上执行这个流程。 		

​      

注意

​					复制只在服务器对之间正常工作。因此，在大型集群中，您需要多个独立的后端对。 			

​                      

**先决条件**

- ​						两个服务器都使用相同的身份验证后端。最好使用 LDAP 或 SQL 来集中维护帐户。 				
- ​						Dovecot 用户数据库配置支持用户列表。使用 `doveadm user '*'` 命令来验证这一点。 				
- ​						Dovecot 以 `vmail` 用户身份而不是用户的 ID (UID)访问文件系统上的邮箱。 				

**流程**

1. ​						创建 `/etc/dovecot/conf.d/10-replication.conf` 文件，并在其中执行以下步骤： 				

   1. ​								启用 `notify` 和 `replication` 插件： 						

      ```plaintext
      mail_plugins = $mail_plugins notify replication
      ```

      ​                

      ​                          

   2. ​								添加 `service replicator` 部分： 						

      ```plaintext
      service replicator {
        process_min_avail = 1
      
        unix_listener replicator-doveadm {
          mode = 0600
          user = vmail
        }
      }
      ```

      ​                

      

      ​                          

      ​								使用这些设置，当 `dovecot` 服务启动时，Dovecot 会至少启动一个 replicator 进程。另外，本节定义了对 `replicator-doveadm` 套接字的设置。 						

   3. ​								添加 `service aggregator` 部分来配置 `replication-notify-fifo` 管道和 `replication-notify` 套接字： 						

      ```plaintext
      service aggregator {
        fifo_listener replication-notify-fifo {
          user = vmail
        }
        unix_listener replication-notify {
          user = vmail
        }
      }
      ```

      ​                

      

      ​                          

   4. ​								添加 `service doveadm` 部分来定义复制服务的端口： 						

      ```plaintext
      service doveadm {
        inet_listener {
          port = 12345
        }
      }
      ```

      ​                

      

      ​                          

   5. ​								设置 `doveadm` 复制服务的密码： 						

      ```bash
      doveadm_password = <replication_password>
      ```

      ​                

      ​                          

      ​								两个服务器上的密码必须相同。 						

   6. ​								配置复制伙伴： 						

      ```plaintext
      plugin {
        mail_replica = tcp:server2.example.com:12345
      }
      ```

      ​                

      

      ​                          

   7. ​								可选：定义并行 `dsync` 进程的最大数量： 						

      ```plaintext
      replication_max_conns = 20
      ```

      ​                

      ​                          

      ​								`replication_max_conns` 的默认值为 `10`。 						

2. ​						对 `/etc/dovecot/conf.d/10-replication.conf` 文件设置安全权限： 				

   ```plaintext
   # chown root:root /etc/dovecot/conf.d/10-replication.conf
   # chmod 600 /etc/dovecot/conf.d/10-replication.conf
   ```

   ​                

   ​                          

3. ​						启用 `nis_enabled` SELinux 布尔值，以允许 Dovecot 打开 `doveadm` 复制端口： 				

   ```plaintext
   # setsebool -P nis_enabled on
   ```

   ​                

   ​                          

4. ​						将 `firewalld` 规则配置为只允许复制伙伴访问复制端口，例如： 				

   ```plaintext
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.0.2.1/32" port protocol="tcp" port="12345" accept"
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv6" source address="2001:db8:2::1/128" port protocol="tcp" port="12345" accept"
   # firewall-cmd --reload
   ```

   ​                

   

   ​                          

   ​						IPv4 的子网掩码 `/32` 和 IPv6 子网掩码 `/128` 限制对指定地址的访问。 				

5. ​						在其他复制伙伴上也执行这个流程。 				

6. ​						重新载入 Dovecot： 				

   ```plaintext
   # systemctl reload dovecot
   ```

   ​                

   ​          

**验证**

1. ​						在一个服务器上的邮箱中执行一个操作，然后验证 Dovecot 是否将更改复制到其他服务器上。 				

2. ​						显示 replicator 状态： 				

   ```plaintext
   # doveadm replicator status
   Queued 'sync' requests        0
   Queued 'high' requests        0
   Queued 'low' requests         0
   Queued 'failed' requests      0
   Queued 'full resync' requests 30
   Waiting 'failed' requests     0
   Total number of known users   75
   ```

   ​                

   

   ​          

​						显示特定用户的 replicator 状态： 				

```plaintext
# doveadm replicator status <user_name>
username        priority  fast sync  full sync  success sync  failed
<user_user>     none      02:05:28   04:19:07   02:05:28      -
```

​                

​          

**其他资源**

- ​						您系统上的 `dsync (1)` 手册页 				
- ​						`/usr/share/doc/dovecot/wiki/Replication.txt` 				



# 1.5. 向 IMAP 邮箱自动订阅用户

------

​				通常，IMAP 服务器管理员希望 Dovecot 自动创建某些邮箱，如 `Sent` 和 `Trash`，并向它们订阅用户。您可以在配置文件中设置它。 		

​				另外，您可以定义 *特殊用途邮箱*。IMAP 客户端通常支持为特殊用途定义邮箱，如用于发送电子邮件。为避免用户必须手动选择和设置正确的邮箱，IMAP 服务器可以在 IMAP `LIST` 命令中发送 `special-use` 属性。然后，客户端可以使用此属性来识别和设置，例如：发送电子邮件的邮箱。 		

**先决条件**

- ​						Dovecot 已配置。 				

**流程**

1. ​						更新 `/etc/dovecot/conf.d/15-mailboxes.conf` 文件中的 `inbox` 命名空间部分： 				

   1. ​								将 `auto = subscribe` 设置添加到应该可供用户使用的每个特殊用途邮箱中，例如： 						

      ```bash
      namespace inbox {
        ...
        mailbox Drafts {
          special_use = \Drafts
          auto = subscribe
        }
      
        mailbox Junk {
          special_use = \Junk
          auto = subscribe
        }
      
        mailbox Trash {
          special_use = \Trash
          auto = subscribe
        }
      
        mailbox Sent {
          special_use = \Sent
          auto = subscribe
        }
        ...
      }
      ```

      ​                

      

      ​          

​								如果您的邮件客户端支持更多特殊用途邮箱，您可以添加类似的条目。`special_use` 参数定义 Dovecot 在 `special-use` 属性中向客户端发送的值。 						

​								可选：如果要定义没有特殊用途的其他邮箱，请在用户的 inbox 中为其添加 `mailbox` 部分，例如： 						

```bash
namespace inbox {
  ...
  mailbox "Important Emails" {
    auto = <value>
  }
  ...
}
```

​                



​          

1. ​								您可以将 `auto` 参数设置为以下值之一： 						
   - ​										`subscribe` ：自动创建邮箱并向其订阅用户。 								
   - ​										`create` ：自动创建邮箱，而无需向其订阅用户。 								
   - ​										`no`（默认）：Dovecot 不会创建邮箱，也不会向其订阅用户。 								

​						重新载入 Dovecot： 				

```plaintext
# systemctl reload dovecot
```

​                

​          

**验证**

- ​						使用 IMAP 客户端访问您的邮箱。 				

  ​						带有 `auto = subscribe` 设置的邮箱会自动可见。如果客户端支持特殊用途的邮箱并定义了用途，客户端会自动使用它们。 				

**其它资源**

- ​						[RFC 6154：用于特殊用途邮箱的 IMAP LIST 扩展](https://www.rfc-editor.org/rfc/rfc6154) 				
- ​						`/usr/share/doc/dovecot/wiki/MailboxSettings.txt` 				



# 1.6. 配置 LMTP 套接字和 LMTPS 侦听器

------

​				SMTP 服务器（如 Postfix）使用本地邮件传输协议(LMTP)向 Dovecot 发送电子邮件。如果 SMTP 服务器运行： 		

- ​						在与 Dovecot 相同的主机上，使用 LMTP 套接字 				

- ​						在其他主机上，使用 LMTP 服务 				

  ​						默认情况下，LMTP 协议没有加密。但是，如果您配置了 TLS 加密，则 Dovecot 会自动对 LMTP 服务使用相同的设置。然后 SMTP 服务器可以使用 LMTPS 协议或 LMTP 上的 `STARTTLS` 命令连接到该协议。 				

**先决条件**

- ​						Dovecot 已安装。 				
- ​						如果要配置 LMTP 服务，TLS 加密会在 Dovecot 中配置。 				

**流程**

1. ​						验证 LMTP 协议是否已启用： 				

   ```plaintext
   # doveconf -a | grep -E "^protocols"
   protocols = imap pop3 lmtp
   ```

   ​                

   ​          

​						如果输出包含 `lmtp`，则该协议已启用。 				

​						如果 `lmtp` 协议被禁用，请编辑 `/etc/dovecot/dovecot.conf` 文件，并将 `lmtp` 附加到 `protocols` 参数中的值： 				

```bash
protocols = ... lmtp
```

​                

​          

​						根据您是否需要 LMTP 套接字或服务，在 `/etc/dovecot/conf.d/10-master.conf` 文件的 `service lmtp` 部分中进行以下更改： 				

- ​								LMTP 套接字：默认情况下，Dovecot 会自动创建 `/var/run/dovecot/lmtp` 套接字。 						

  ​								可选：自定义所有权和权限： 						

  ```bash
  service lmtp {
    ...
    unix_listener lmtp {
      mode = 0600
      user = postfix
      group = postfix
    }
    ...
  }
  ```

  ​                

  

  ​          

​								LMTP 服务：添加一个 `inet_listener` 子部分： 						

```bash
service lmtp {
  ...
  inet_listener lmtp {
    port = 24
  }
  ...
}
```

​                



​          

​						配置 `firewalld` 规则，以只允许 SMTP 服务器访问 LMTP 端口，例如： 				

```plaintext
# firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.0.2.1/32" port protocol="tcp" port="24" accept"
# firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv6" source address="2001:db8:2::1/128" port protocol="tcp" port="24" accept"
# firewall-cmd --reload
```

​                



​          

​						IPv4 的子网掩码 `/32` 和 IPv6 子网掩码 `/128` 限制对指定地址的访问。 				

​						重新载入 Dovecot： 				

```plaintext
# systemctl reload dovecot
```

​                

​          

**验证**

1. ​						如果您配置了 LMTP 套接字，请验证 Dovecot 是否已创建套接字，以及权限是否正确： 				

   ```plaintext
   # ls -l /var/run/dovecot/lmtp
   srw-------. 1 postfix postfix 0 Nov 22 17:17 /var/run/dovecot/lmtp
   ```

   ​                

   ​          

1. ​						配置 SMTP 服务器，以使用 LMTP 套接字或服务向 Dovecot 提交电子邮件。 				

   ​						使用 LMTP 服务时，请确保 SMTP 服务器使用 LMTPS 协议或发送 `STARTTLS` 命令以使用加密连接。 				

**其它资源**

- ​						`/usr/share/doc/dovecot/wiki/LMTP.txt` 				



# 1.7. 在 Dovecot 中禁用 IMAP 或 POP3 服务

------

​				默认情况下，Dovecot 提供 IMAP 和 POP3 服务。如果您只需要其中之一，您可以禁用另一个以减少攻击面。 		

**先决条件**

- ​						Dovecot 已安装。 				

**流程**

1. ​						取消 `/etc/dovecot/dovecot.conf` 文件中 `protocols` 参数的注释，并将它设置为使用所需的协议。例如，如果您不需要 POP3，请设置： 				

   ```plaintext
   protocols = imap lmtp
   ```

   ​                

   ​          

​						默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 				

​						重新载入 Dovecot： 				

```plaintext
# systemctl reload dovecot
```

​                

​          

​						关闭本地防火墙中不再需要的端口。例如，要关闭 POP3S 和 POP3 协议的端口，请输入： 				

```plaintext
# firewall-cmd --remove-service=pop3s --remove-service=pop3
# firewall-cmd --reload
```

​                

​          

**验证**

- ​						显示 `LISTEN` 模式下 `dovecot` 进程打开的所有端口： 				

  ```plaintext
  # ss -tulp | grep dovecot
  tcp  LISTEN 0  100  0.0.0.0:993  0.0.0.0:*  users:(("dovecot",pid=1405,fd=44))
  tcp  LISTEN 0  100  0.0.0.0:143  0.0.0.0:*  users:(("dovecot",pid=1405,fd=42))
  tcp  LISTEN 0  100     [::]:993     [::]:*  users:(("dovecot",pid=1405,fd=45))
  tcp  LISTEN 0  100     [::]:143     [::]:*  users:(("dovecot",pid=1405,fd=43))
  ```

  ​                

  

  ​          

- ​						在本例中，Dovecot 仅侦听 TCP 端口 `993` (IMAPS)和 `143` (IMAP)。 				

  ​						请注意，如果您将服务配置为侦听端口而不使用套接字，则 Dovecot 仅为 LMTP 协议打开端口。 				

**其他资源**

- ​						您系统上的 `firewall-cmd (1)` 手册页 				



# 1.8. 通过在 Dovecot IMAP 服务器上使用 Sieve 启用服务器端电子邮件过滤

------

​				您可以使用 ManageSieve 协议将 Sieve 脚本上传到服务器。Sieve  脚本定义服务器应对传入的电子邮件验证的规则和执行的操作。例如，用户可以使用 Sieve  转发特定发件人的电子邮件，管理员可以创建一个全局过滤器，将垃圾邮件过滤器标记的邮件移到单独的 IMAP 文件夹中。 		

​				`ManageSieve` 插件为 Dovecot IMAP 服务器添加了对 Sieve 脚本和 ManageSieve 协议的支持。 		

​      

警告

​					仅使用支持通过 TLS 连接的 ManageSieve 协议的客户端。禁用此协议的 TLS 会导致客户端通过网络以纯文本形式发送凭证。 			

​                      

**先决条件**

- ​						Dovecot 已配置，并提供 IMAP 邮箱。 				
- ​						TLS 加密在 Dovecot 中已配置。 				
- ​						邮件客户端支持通过 TLS 连接的 ManageSieve 协议。 				

**流程**

1. ​						安装 `dovecot-pigeonhole` 软件包： 				

   ```plaintext
   # dnf install dovecot-pigeonhole
   ```

   ​                

   ​          

​						取消 `/etc/dovecot/conf.d/20-managesieve.conf` 中以下行的注释，以启用 `sieve` 协议： 				

```plaintext
protocols = $protocols sieve
```

​                

​          

​						除了已经启用的其他协议外，此设置还激活 Sieve。 				

​						在 `firewalld` 中打开 ManageSieve 端口： 				

```plaintext
# firewall-cmd --permanent --add-service=managesieve
# firewall-cmd --reload
```

​                

​          

​						重新载入 Dovecot： 				

```plaintext
# systemctl reload dovecot
```

​                

​          

**验证**

1. ​						使用客户端并上传 Sieve 脚本。使用以下连接设置： 				
   - ​								端口：4190 						
   - ​								连接安全：SSL/TLS 						
   - ​								身份验证方法： PLAIN 						
2. ​						向已上传 Sieve 脚本的用户发送电子邮件。如果电子邮件与脚本中的规则匹配，请验证服务器是否执行了定义的操作。 				

**其它资源**

- ​						`/usr/share/doc/dovecot/wiki/Pigeonhole.Sieve.Plugins.IMAPSieve.txt` 				
- ​						`/usr/share/doc/dovecot/wiki/Pigeonhole.Sieve.Troubleshooting.txt` 				
- ​						您系统上的 `firewall-cmd (1)` 手册页 				





# 1.9. Dovecot 如何处理配置文件

------

​				`dovecot` 软件包提供主配置文件 `/etc/dovecot/dovecot.conf` 和 `/etc/dovecot/conf.d/` 目录中的多个配置文件。Dovecot 会在您启动服务时组合文件来构建配置。 		

​				多个配置文件的主要优点是对设置进行分组并提高可读性。如果希望使用单个配置文件，您可以在 `/etc/dovecot/dovecot.conf` 中维护所有设置，并从该文件中删除所有 `include` 和`include_try` 语句。 		

**其它资源**

- ​						`/usr/share/doc/dovecot/wiki/ConfigFile.txt` 				
- ​						`/usr/share/doc/dovecot/wiki/Variables.txt` 				

## Install Dovecot 安装 Dovecot

To install a basic Dovecot server with common POP3 and IMAP functions, run the following command:
若要安装具有常见 POP3 和 IMAP 功能的基本 Dovecot 服务器，请运行以下命令：

```bash
sudo apt install dovecot-imapd dovecot-pop3d
```

There are various other Dovecot modules including `dovecot-sieve` (mail filtering), `dovecot-solr` (full text search), `dovecot-antispam` (spam filter training), `dovecot-ldap` (user directory).
还有各种其他 Dovecot 模块，包括 `dovecot-sieve` （邮件过滤）、 `dovecot-solr` （全文搜索）、 `dovecot-antispam` （垃圾邮件过滤训练）、 `dovecot-ldap` （用户目录）。

## Configure Dovecot 配置 Dovecot

To configure Dovecot, edit the file `/etc/dovecot/dovecot.conf` and its included config files in `/etc/dovecot/conf.d/`. By default, all installed protocols will be enabled via an *include* directive in `/etc/dovecot/dovecot.conf`.
要配置 Dovecot，请在 中 `/etc/dovecot/conf.d/` 编辑文件 `/etc/dovecot/dovecot.conf` 及其包含的配置文件。默认情况下，所有已安装的协议都将通过 中的 `/etc/dovecot/dovecot.conf` include 指令启用。

```plaintext
!include_try /usr/share/dovecot/protocols.d/*.protocol
```

IMAPS and POP3S are more secure because they use SSL encryption to connect. A basic self-signed SSL certificate is automatically set up by package `ssl-cert` and used by Dovecot in `/etc/dovecot/conf.d/10-ssl.conf`.
IMAPS 和 POP3S 更安全，因为它们使用 SSL 加密进行连接。基本的自签名SSL证书由软件包 `ssl-cert` 自动设置，并由Dovecot在 `/etc/dovecot/conf.d/10-ssl.conf` 中使用。

`Mbox` format is configured by default, but you can also use `Maildir` if required. More details can be found in the comments in `/etc/dovecot/conf.d/10-mail.conf`. Also see [the Dovecot web site](https://doc.dovecot.org/admin_manual/mailbox_formats/) to learn about further benefits and details.
 `Mbox` 默认情况下配置格式，但您也可以根据需要使用 `Maildir` 。更多详细信息可以在 中 `/etc/dovecot/conf.d/10-mail.conf` 的评论中找到。另请参阅 Dovecot 网站，了解更多好处和详细信息。

Make sure to also configure your chosen Mail Transport Agent (MTA) to  transfer the incoming mail to the selected type of mailbox.
请确保还要配置所选的邮件传输代理 （MTA） 以将传入邮件传输到所选类型的邮箱。

### Restart the Dovecot daemon 重新启动 Dovecot 守护程序

Once you have configured Dovecot, restart its daemon in order to test your setup using the following command:
配置 Dovecot 后，重新启动其守护程序，以便使用以下命令测试您的设置：

```bash
sudo service dovecot restart
```

Try to log in with the commands `telnet localhost pop3` (for POP3) or `telnet localhost imap2` (for IMAP).  You should see something like the following:
尝试使用命令（对于 POP3）或 `telnet localhost imap2` （对于 IMAP） `telnet localhost pop3` 登录。您应该会看到如下内容：

```plaintext
bhuvan@rainbow:~$ telnet localhost pop3
Trying 127.0.0.1...
Connected to localhost.localdomain.
Escape character is '^]'.
+OK Dovecot ready.
```

## Dovecot SSL configuration Dovecot SSL 配置

By default, Dovecot is configured to use SSL automatically using the package `ssl-cert` which provides a self signed certificate.
默认情况下，Dovecot 配置为使用提供自签名证书的软件包 `ssl-cert` 自动使用 SSL。

You can instead generate your own custom certificate for Dovecot using `openssh`, for example:
您可以改为使用 `openssh` 生成自己的 Dovecot 自定义证书，例如：

```bash
sudo openssl req -new -x509 -days 1000 -nodes -out "/etc/dovecot/dovecot.pem" \
    -keyout "/etc/dovecot/private/dovecot.pem"
```

Next, edit `/etc/dovecot/conf.d/10-ssl.conf` and amend following lines to specify that Dovecot should use these custom certificates :
接下来，编辑 `/etc/dovecot/conf.d/10-ssl.conf` 和修改以下行，以指定 Dovecot 应使用这些自定义证书：

```plaintext
ssl_cert = </etc/dovecot/private/dovecot.pem
ssl_key = </etc/dovecot/private/dovecot.key
```

You can get the SSL certificate from a Certificate Issuing Authority or you can create self-signed one. Once you create the certificate, you will  have a key file and a certificate file that you want to make known in  the config shown above.
您可以从证书颁发机构获取 SSL 证书，也可以创建自签名证书。创建证书后，您将拥有要在上面所示的配置中已知的密钥文件和证书文件。

> **Further reading**: 延伸阅读：
>  For more details on creating custom certificates, see our guide on [security certificates](https://ubuntu.com/server/docs/certificates).
> 有关创建自定义证书的更多详细信息，请参阅我们的安全证书指南。

## Configure a firewall for an email server 为电子邮件服务器配置防火墙

To access your mail server from another computer, you must configure your  firewall to allow connections to the server on the necessary ports.
若要从另一台计算机访问邮件服务器，必须将防火墙配置为允许在必要的端口上连接到服务器。

- IMAP - 143
- IMAPS - 993
- POP3 - 110
- POP3S - 995

## References 引用

- The [Dovecot website](http://www.dovecot.org/) has more general information about Dovecot.
  Dovecot 网站提供有关 Dovecot 的更多一般信息。
- The [Dovecot manual](https://doc.dovecot.org) provides full documentation for Dovecot use.
  Dovecot 手册提供了 Dovecot 使用的完整文档。
- The [Dovecot Ubuntu Wiki](https://help.ubuntu.com/community/Dovecot) page has more details on configuration.
  Dovecot Ubuntu Wiki 页面提供了有关配置的更多详细信息。

# 第 1 章 配置和维护 Dovecot IMAP 和 POP3 服务器

​			Dovecot 是一个高性能邮件发送代理(MDA)，专注于安全性。您可以使用 IMAP 或 POP3 兼容电子邮件客户端连接到 Dovecot 服务器并读取或下载电子邮件。 	

​			Dovecot 的主要特性： 	

- ​					设计和实施侧重于安全性 			
- ​					用于高可用性的双向复制支持以提高大型环境中的性能 			
- ​					支持 high-performance `dbox` 邮箱格式，但出于兼容性的原因，也支持 `mbox` 和 `Maildir` 			
- ​					自我修复功能，如修复有问题的索引文件 			
- ​					遵守 IMAP 标准 			
- ​					临时解决方案支持绕过 IMAP 和 POP3 客户端中的错误 			

## 1.1. 使用 PAM 验证设置 Dovecot 服务器

​				Dovecot 支持名称服务交换机(NSS)接口作为用户数据库，以及可插拔验证模块(PAM)框架作为身份验证后端。使用这个配置，Dovecot 可以为服务器上本地通过 NSS 提供的用户提供服务。 		

​				如果帐户，请使用 PAM 身份验证： 		

- ​						在 `/etc/passwd` 文件中本地定义 				
- ​						存储在远程数据库中，但可以通过系统安全服务守护进程(SSSD)或其他 NSS 插件进行本地使用。 				

### 1.1.1. 安装 Dovecot

​					`dovecot` 软件包提供： 			

- ​							`dovecot` 服务以及维护它的工具 					
- ​							Dovecot 按需启动的服务，如用于身份验证的服务 					
- ​							插件，如服务器端邮件过滤 					
- ​							`/etc/dovecot/` 目录中的配置文件 					
- ​							`/usr/share/doc/dovecot/` 目录中的文档 					

**流程**

- ​							安装 `dovecot` 软件包： 					

  

  ```none
  # dnf install dovecot
  ```

  注意

  ​								如果 Dovecot 已安装并且需要清理的配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。 						

**后续步骤**

- ​							[在 Dovecot 服务器上配置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#configuring-tls-encryption-on-a-dovecot-server_setting-up-a-dovecot-server-with-pam-authentication)。 					

### 1.1.2. 在 Dovecot 服务器上配置 TLS 加密

​					Dovecot 提供安全的默认配置。例如，默认启用 TLS 来传输通过网络加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，您只需要将路径设置为证书和私钥文件。另外，您可以通过生成并使用 Diffie-Hellman 参数来提供完美转发保密(PFS)来提高  TLS 连接的安全性。 			

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							以下文件已复制到服务器中列出的位置： 					
  - ​									服务器证书： `/etc/pki/dovecot/certs/server.example.com.crt` 							
  - ​									私钥： `/etc/pki/dovecot/private/server.example.com.key` 							
  - ​									证书颁发机构(CA)证书： `/etc/pki/dovecot/certs/ca.crt` 							
- ​							服务器证书的 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					

**流程**

1. ​							对私钥文件设置安全权限： 					

   

   ```none
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

2. ​							使用 Diffie-Hellman 参数生成文件： 					

   

   ```none
   # openssl dhparam -out /etc/dovecot/dh.pem 4096
   ```

   ​							根据服务器上的硬件和熵，生成带有 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

3. ​							在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置到证书和私钥文件的路径： 					

   1. ​									更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

      

      ```none
      ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
      ssl_key = </etc/pki/dovecot/private/server.example.com.key
      ```

   2. ​									取消注释 `ssl_ca` 参数，并将其设置为使用 CA 证书的路径： 							

      

      ```none
      ssl_ca = </etc/pki/dovecot/certs/ca.crt
      ```

   3. ​									取消注释 `ssl_dh` 参数，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

      

      ```none
      ssl_dh = </etc/dovecot/dh.pem
      ```

   重要

   ​								为确保 Dovecot 从文件中读取参数的值，该路径必须以前导 < `字符开头`。 						

**后续步骤**

- ​							[准备 Dovecot 以使用虚拟用户](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#preparing-dovecot-to-use-virtual-users_setting-up-a-dovecot-server-with-pam-authentication) 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt` 					

### 1.1.3. 准备 Dovecot 以使用虚拟用户

​					默认情况下，Dovecot 以使用服务的用户身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几项优点： 			

- ​							Dovecot 以特定本地用户执行文件系统操作，而不使用用户的 ID (UID)。 					
- ​							用户不需要在服务器上本地可用。 					
- ​							您可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- ​							用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- ​							有权访问服务器上的文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- ​							设置复制更为简单。 					

**先决条件**

- ​							已安装了 Dovecot。 					

**流程**

1. ​							创建 `vmail` 用户： 					

   

   ```none
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   ​							Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要使用 `dovecot` 或 `dovenull` 系统用户来实现这一目的。 					

2. ​							如果您使用与 `/var/mail/` 不同的路径，请在其上设置 `mail_spool_t` SELinux 上下文，例如： 					

   

   ```none
   # semanage fcontext -a -t mail_spool_t "<path>(/.*)?"
   # restorecon -Rv <path>
   ```

3. ​							仅将 `/var/mail/` 的写入权限授予 `vmail` 用户： 					

   

   ```none
   # chown vmail:vmail /var/mail/
   # chmod 700 /var/mail/
   ```

4. ​							取消注释 `/etc/dovecot/conf.d/10-mail.conf` 文件中的 `mail_location` 参数，并将其设置为 mailbox 格式和位置： 					

   

   ```none
   mail_location = sdbox:/var/mail/%n/
   ```

   ​							使用这个设置： 					

   - ​									Dovecot `在单一` 模式中使用 high-performant `dbox` 邮箱格式。在此模式中，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。 							
   - ​									Dovecot 解析路径中的 `%n` 变量到用户名。这需要确保每个用户在其邮箱中都有单独的目录。 							

**后续步骤**

- ​							[使用 PAM 作为 Dovecot 身份验证后端](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#using-pam-as-the-dovecot-authentication-backend_setting-up-a-dovecot-server-with-pam-authentication)。 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailLocation.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailboxFormat.dbox.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/Variables.txt` 					

### 1.1.4. 使用 PAM 作为 Dovecot 身份验证后端

​					默认情况下，Dovecot 使用名称服务交换机(NSS)接口作为用户数据库，以及可插拔验证模块(PAM)框架作为身份验证后端。 			

​					自定义设置，以将 Dovecot 适应您的环境，并使用虚拟主机功能简化管理。 			

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							虚拟主机功能已配置。 					

**流程**

1. ​							更新 `/etc/dovecot/conf.d/10-mail.conf` 文件中的 `first_valid_uid` 参数，以定义可以对 Dovecot 进行身份验证的最低用户 ID (UID)： 					

   

   ```none
   first_valid_uid = 1000
   ```

   ​							默认情况下，UID 大于或等于 `1000` 的用户可以进行身份验证。如果需要，您也可以设置 `last_valid_uid` 参数，以定义 Dovecot 允许登录的最高 UID。 					

2. ​							在 `/etc/dovecot/conf.d/auth-system.conf.ext` 文件中，将 `override_fields` 参数添加到 `userdb` 部分，如下所示： 					

   

   ```none
   userdb {
     driver = passwd
     override_fields = uid=vmail gid=vmail home=/var/mail/%n/
   }
   ```

   ​							由于固定值，Dovecot 不会从 `/etc/passwd` 文件查询这些设置。因此，`/etc/passwd` 中定义的主目录不需要存在。 					

**后续步骤**

- ​							[完成 Dovecot 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#completing-the-dovecot-configuration_setting-up-a-dovecot-server-with-pam-authentication)。 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/PasswordDatabase.PAM.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.Home.txt` 					

### 1.1.5. 完成 Dovecot 配置

​					安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动该服务。之后，您可以测试服务器。 			

**先决条件**

- ​							在 Dovecot 中配置了以下内容： 					
  - ​									TLS 加密 							
  - ​									身份验证后端 							
- ​							客户端信任证书颁发机构(CA)证书。 					

**流程**

1. ​							如果您只想向用户提供 IMAP 或 POP3 服务，请取消注释 `/etc/dovecot/dovecot.conf` 文件中的 protocol 参数，并将其设置为所需的协议。``例如，如果您不需要 POP3，请设置： 					

   

   ```none
   protocols = imap lmtp
   ```

   ​							默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

2. ​							在本地防火墙中打开端口。例如，要打开 IMAPS、IMAP、POP3S 和 POP3 协议的端口，请输入： 					

   

   ```none
   # firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
   # firewall-cmd --reload
   ```

3. ​							启用并启动 `dovecot` 服务： 					

   

   ```none
   # systemctl enable --now dovecot
   ```

**验证**

1. ​							使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot 并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   表 1.1. 连接设置到 Dovecot 服务器

   | 协议                                                         | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ------------------------------------------------------------ | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP                                                         | 143  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-pam-authentication) |
   | IMAPS                                                        | 993  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-pam-authentication) |
   | POP3                                                         | 110  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-pam-authentication) |
   | POP3S                                                        | 995  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-pam-authentication) |
   | [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-pam-authentication) 											客户端通过 TLS 连接传输数据。因此，凭证不会被披露。 |      |            |                                                              |

   ​							请注意，这个表不会列出未加密的连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接中不接受纯文本身份验证。 					

2. ​							使用非默认值显示配置设置： 					

   

   ```none
   # doveconf -n
   ```

**其他资源**

- ​							`firewall-cmd(1)` 手册页 					

## 1.2. 使用 LDAP 身份验证设置 Dovecot 服务器

​				如果您的基础架构使用 LDAP 服务器来存储帐户，您可以对其验证 Dovecot 用户。在这种情况下，您可以在目录中集中管理帐户，用户不需要对 Dovecot 服务器上的文件系统进行本地访问。 		

​				如果您计划使用复制设置多个 Dovecot 服务器，以使您的邮箱具有高可用性，则集中管理的帐户也是一个好处。 		

### 1.2.1. 安装 Dovecot

​					`dovecot` 软件包提供： 			

- ​							`dovecot` 服务以及维护它的工具 					
- ​							Dovecot 按需启动的服务，如用于身份验证的服务 					
- ​							插件，如服务器端邮件过滤 					
- ​							`/etc/dovecot/` 目录中的配置文件 					
- ​							`/usr/share/doc/dovecot/` 目录中的文档 					

**流程**

- ​							安装 `dovecot` 软件包： 					

  

  ```none
  # dnf install dovecot
  ```

  注意

  ​								如果 Dovecot 已安装并且需要清理的配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。 						

**后续步骤**

- ​							[在 Dovecot 服务器上配置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#configuring-tls-encryption-on-a-dovecot-server_setting-up-a-dovecot-server-with-ldap-authentication)。 					

### 1.2.2. 在 Dovecot 服务器上配置 TLS 加密

​					Dovecot 提供安全的默认配置。例如，默认启用 TLS 来传输通过网络加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，您只需要将路径设置为证书和私钥文件。另外，您可以通过生成并使用 Diffie-Hellman 参数来提供完美转发保密(PFS)来提高  TLS 连接的安全性。 			

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							以下文件已复制到服务器中列出的位置： 					
  - ​									服务器证书： `/etc/pki/dovecot/certs/server.example.com.crt` 							
  - ​									私钥： `/etc/pki/dovecot/private/server.example.com.key` 							
  - ​									证书颁发机构(CA)证书： `/etc/pki/dovecot/certs/ca.crt` 							
- ​							服务器证书的 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					

**流程**

1. ​							对私钥文件设置安全权限： 					

   

   ```none
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

2. ​							使用 Diffie-Hellman 参数生成文件： 					

   

   ```none
   # openssl dhparam -out /etc/dovecot/dh.pem 4096
   ```

   ​							根据服务器上的硬件和熵，生成带有 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

3. ​							在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置到证书和私钥文件的路径： 					

   1. ​									更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

      

      ```none
      ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
      ssl_key = </etc/pki/dovecot/private/server.example.com.key
      ```

   2. ​									取消注释 `ssl_ca` 参数，并将其设置为使用 CA 证书的路径： 							

      

      ```none
      ssl_ca = </etc/pki/dovecot/certs/ca.crt
      ```

   3. ​									取消注释 `ssl_dh` 参数，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

      

      ```none
      ssl_dh = </etc/dovecot/dh.pem
      ```

   重要

   ​								为确保 Dovecot 从文件中读取参数的值，该路径必须以前导 < `字符开头`。 						

**后续步骤**

- ​							[准备 Dovecot 以使用虚拟用户](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#preparing-dovecot-to-use-virtual-users_setting-up-a-dovecot-server-with-ldap-authentication) 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt` 					

### 1.2.3. 准备 Dovecot 以使用虚拟用户

​					默认情况下，Dovecot 以使用服务的用户身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几项优点： 			

- ​							Dovecot 以特定本地用户执行文件系统操作，而不使用用户的 ID (UID)。 					
- ​							用户不需要在服务器上本地可用。 					
- ​							您可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- ​							用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- ​							有权访问服务器上的文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- ​							设置复制更为简单。 					

**先决条件**

- ​							已安装了 Dovecot。 					

**流程**

1. ​							创建 `vmail` 用户： 					

   

   ```none
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   ​							Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要使用 `dovecot` 或 `dovenull` 系统用户来实现这一目的。 					

2. ​							如果您使用与 `/var/mail/` 不同的路径，请在其上设置 `mail_spool_t` SELinux 上下文，例如： 					

   

   ```none
   # semanage fcontext -a -t mail_spool_t "<path>(/.*)?"
   # restorecon -Rv <path>
   ```

3. ​							仅将 `/var/mail/` 的写入权限授予 `vmail` 用户： 					

   

   ```none
   # chown vmail:vmail /var/mail/
   # chmod 700 /var/mail/
   ```

4. ​							取消注释 `/etc/dovecot/conf.d/10-mail.conf` 文件中的 `mail_location` 参数，并将其设置为 mailbox 格式和位置： 					

   

   ```none
   mail_location = sdbox:/var/mail/%n/
   ```

   ​							使用这个设置： 					

   - ​									Dovecot `在单一` 模式中使用 high-performant `dbox` 邮箱格式。在此模式中，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。 							
   - ​									Dovecot 解析路径中的 `%n` 变量到用户名。这需要确保每个用户在其邮箱中都有单独的目录。 							

**后续步骤**

- ​							[使用 LDAP 作为 Dovecot 身份验证后端](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#using-ldap-as-the-dovecot-authentication-backend_setting-up-a-dovecot-server-with-ldap-authentication). 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailLocation.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailboxFormat.dbox.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/Variables.txt` 					

### 1.2.4. 使用 LDAP 作为 Dovecot 身份验证后端

​					LDAP 目录中的用户通常可以对自己的目录服务进行身份验证。Dovecot 可在登录到 IMAP 和 POP3 服务时使用此来验证用户。这个验证方法有很多优点，例如： 			

- ​							管理员可以集中管理目录中的用户。 					
- ​							LDAP 帐户不需要任何特殊属性。它们只需要能够对 LDAP 服务器进行身份验证。因此，此方法独立于 LDAP 服务器上使用的密码存储方案。 					
- ​							用户不需要通过名称服务交换机(NSS)界面和可插拔验证模块(PAM)框架在服务器上本地可用。 					

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							虚拟主机功能已配置。 					
- ​							连接到 LDAP 服务器支持 TLS 加密。 					
- ​							Dovecot 服务器上的 RHEL 信任 LDAP 服务器的证书颁发机构(CA)证书。 					
- ​							如果用户存储在 LDAP 目录中的不同树中，则存在用于 Dovecot 的专用 LDAP 帐户来搜索目录。此帐户需要搜索其他用户的可辨识名称(DN)的权限。 					

**流程**

1. ​							在 `/etc/dovecot/conf.d/10-auth.conf` 文件中配置身份验证后端： 					

   1. ​									注释掉您不需要的 `auth-*.conf.ext` 身份验证后端配置文件的语句，例如： `` 							

      

      ```none
      #!include auth-system.conf.ext
      ```

   2. ​									通过取消注释 LDAP 身份验证来启用 LDAP 身份验证： 							

      

      ```none
      !include auth-ldap.conf.ext
      ```

2. ​							编辑 `/etc/dovecot/conf.d/auth-ldap.conf.ext` 文件，并按如下所示将 `override_fields` 参数添加到 `userdb` 部分： 					

   

   ```none
   userdb {
     driver = ldap
     args = /etc/dovecot/dovecot-ldap.conf.ext
     override_fields = uid=vmail gid=vmail home=/var/mail/%n/
   }
   ```

   ​							由于固定值，Dovecot 不会从 LDAP 服务器查询这些设置。因此，这些属性还必须存在。 					

3. ​							使用以下设置创建 `/etc/dovecot/dovecot-ldap.conf.ext` 文件： 					

   1. ​									根据 LDAP 结构，配置以下之一： 							

      - ​											如果用户存储在 LDAP 目录中的不同树中，请配置动态 DN 查找： 									

        

        ```none
        dn = cn=dovecot_LDAP,dc=example,dc=com
        dnpass = password
        pass_filter = (&(objectClass=posixAccount)(uid=%n))
        ```

        ​											Dovecot 使用指定的 DN、密码和过滤器在目录中搜索身份验证用户的 DN。在此搜索中，Dovecot 将过滤器中的 `%n` 替换为用户名。请注意，LDAP 搜索必须只返回一个结果。 									

      - ​											如果所有用户存储在特定条目下，请配置 DN 模板： 									

        

        ```none
        auth_bind_userdn = cn=%n,ou=People,dc=example,dc=com
        ```

   2. ​									启用到 LDAP 服务器的身份验证绑定以验证 Dovecot 用户： 							

      

      ```none
      auth_bind = yes
      ```

   3. ​									将 URL 设置为 LDAP 服务器： 							

      

      ```none
      uris = ldaps://LDAP-srv.example.com
      ```

      ​									为安全起见，请只使用使用 LDAPS 的加密连接，或通过 LDAP 协议使用 `STARTTLS` 命令。对于后者，在设置中添加 `tls = yes`。 							

      ​									对于正常工作的证书验证，LDAP 服务器的主机名必须与其 TLS 证书中使用的主机名匹配。 							

   4. ​									启用 LDAP 服务器的 TLS 证书的验证： 							

      

      ```none
      tls_require_cert = hard
      ```

   5. ​									将基本 DN 设置为要开始搜索用户的 DN： 							

      

      ```none
      base = ou=People,dc=example,dc=com
      ```

   6. ​									设置搜索范围： 							

      

      ```none
      scope = onelevel
      ```

      ​									Dovecot 仅在指定基本 DN 和 `子树` 范围内搜索一个 `级别范围`。 							

4. ​							对 `/etc/dovecot/dovecot-ldap.conf.ext` 文件设置安全权限： 					

   

   ```none
   # chown root:root /etc/dovecot/dovecot-ldap.conf.ext
   # chmod 600 /etc/dovecot/dovecot-ldap.conf.ext
   ```

**后续步骤**

- ​							[完成 Dovecot 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#completing-the-dovecot-configuration_setting-up-a-dovecot-server-with-ldap-authentication)。 					

**其他资源**

- ​							`/usr/share/doc/dovecot/example-config/dovecot-ldap.conf.ext` 					
- ​							`/usr/share/doc/dovecot/wiki/UserDatabase.Static.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.AuthBinds.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/AuthDatabase.LDAP.PasswordLookups.txt` 					

### 1.2.5. 完成 Dovecot 配置

​					安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动该服务。之后，您可以测试服务器。 			

**先决条件**

- ​							在 Dovecot 中配置了以下内容： 					
  - ​									TLS 加密 							
  - ​									身份验证后端 							
- ​							客户端信任证书颁发机构(CA)证书。 					

**流程**

1. ​							如果您只想向用户提供 IMAP 或 POP3 服务，请取消注释 `/etc/dovecot/dovecot.conf` 文件中的 protocol 参数，并将其设置为所需的协议。``例如，如果您不需要 POP3，请设置： 					

   

   ```none
   protocols = imap lmtp
   ```

   ​							默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

2. ​							在本地防火墙中打开端口。例如，要打开 IMAPS、IMAP、POP3S 和 POP3 协议的端口，请输入： 					

   

   ```none
   # firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
   # firewall-cmd --reload
   ```

3. ​							启用并启动 `dovecot` 服务： 					

   

   ```none
   # systemctl enable --now dovecot
   ```

**验证**

1. ​							使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot 并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   表 1.2. 连接设置到 Dovecot 服务器

   | 协议                                                         | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ------------------------------------------------------------ | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP                                                         | 143  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-ldap-authentication) |
   | IMAPS                                                        | 993  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-ldap-authentication) |
   | POP3                                                         | 110  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-ldap-authentication) |
   | POP3S                                                        | 995  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-ldap-authentication) |
   | [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-ldap-authentication) 											客户端通过 TLS 连接传输数据。因此，凭证不会被披露。 |      |            |                                                              |

   ​							请注意，这个表不会列出未加密的连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接中不接受纯文本身份验证。 					

2. ​							使用非默认值显示配置设置： 					

   

   ```none
   # doveconf -n
   ```

**其他资源**

- ​							`firewall-cmd(1)` 手册页 					

## 1.3. 使用 MariaDB SQL 身份验证设置 Dovecot 服务器

​				如果您将用户和密码存储在 MariaDB SQL 服务器中，您可以将 Dovecot 配置为将其用作用户数据库和身份验证后端。使用这个配置，您可以在数据库中集中管理帐户，用户对 Dovecot 服务器上的文件系统没有本地访问权限。 		

​				如果您计划使用复制设置多个 Dovecot 服务器，以使您的邮箱具有高可用性，则集中管理的帐户也是一个好处。 		

### 1.3.1. 安装 Dovecot

​					`dovecot` 软件包提供： 			

- ​							`dovecot` 服务以及维护它的工具 					
- ​							Dovecot 按需启动的服务，如用于身份验证的服务 					
- ​							插件，如服务器端邮件过滤 					
- ​							`/etc/dovecot/` 目录中的配置文件 					
- ​							`/usr/share/doc/dovecot/` 目录中的文档 					

**流程**

- ​							安装 `dovecot` 软件包： 					

  

  ```none
  # dnf install dovecot
  ```

  注意

  ​								如果 Dovecot 已安装并且需要清理的配置文件，请重命名或删除 `/etc/dovecot/` 目录。之后，重新安装软件包。在删除配置文件的情况下，`dnf reinstall dovecot` 命令不会重置 `/etc/dovecot/` 中的配置文件。 						

**后续步骤**

- ​							[在 Dovecot 服务器上配置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#configuring-tls-encryption-on-a-dovecot-server_setting-up-a-dovecot-server-with-mariadb-sql-authentication)。 					

### 1.3.2. 在 Dovecot 服务器上配置 TLS 加密

​					Dovecot 提供安全的默认配置。例如，默认启用 TLS 来传输通过网络加密的凭证和数据。要在 Dovecot 服务器上配置  TLS，您只需要将路径设置为证书和私钥文件。另外，您可以通过生成并使用 Diffie-Hellman 参数来提供完美转发保密(PFS)来提高  TLS 连接的安全性。 			

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							以下文件已复制到服务器中列出的位置： 					
  - ​									服务器证书： `/etc/pki/dovecot/certs/server.example.com.crt` 							
  - ​									私钥： `/etc/pki/dovecot/private/server.example.com.key` 							
  - ​									证书颁发机构(CA)证书： `/etc/pki/dovecot/certs/ca.crt` 							
- ​							服务器证书的 `Subject DN` 字段中的主机名与服务器的完全限定域名(FQDN)匹配。 					

**流程**

1. ​							对私钥文件设置安全权限： 					

   

   ```none
   # chown root:root /etc/pki/dovecot/private/server.example.com.key
   # chmod 600 /etc/pki/dovecot/private/server.example.com.key
   ```

2. ​							使用 Diffie-Hellman 参数生成文件： 					

   

   ```none
   # openssl dhparam -out /etc/dovecot/dh.pem 4096
   ```

   ​							根据服务器上的硬件和熵，生成带有 4096 位的 Diffie-Hellman 参数可能需要几分钟。 					

3. ​							在 `/etc/dovecot/conf.d/10-ssl.conf` 文件中设置到证书和私钥文件的路径： 					

   1. ​									更新 `ssl_cert` 和 `ssl_key` 参数，并将其设置为使用服务器的证书和私钥的路径： 							

      

      ```none
      ssl_cert = </etc/pki/dovecot/certs/server.example.com.crt
      ssl_key = </etc/pki/dovecot/private/server.example.com.key
      ```

   2. ​									取消注释 `ssl_ca` 参数，并将其设置为使用 CA 证书的路径： 							

      

      ```none
      ssl_ca = </etc/pki/dovecot/certs/ca.crt
      ```

   3. ​									取消注释 `ssl_dh` 参数，并将其设置为使用 Diffie-Hellman 参数文件的路径： 							

      

      ```none
      ssl_dh = </etc/dovecot/dh.pem
      ```

   重要

   ​								为确保 Dovecot 从文件中读取参数的值，该路径必须以前导 < `字符开头`。 						

**后续步骤**

- ​							[准备 Dovecot 以使用虚拟用户](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#preparing-dovecot-to-use-virtual-users_setting-up-a-dovecot-server-with-mariadb-sql-authentication) 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/SSL.DovecotConfiguration.txt` 					

### 1.3.3. 准备 Dovecot 以使用虚拟用户

​					默认情况下，Dovecot 以使用服务的用户身份对文件系统执行许多操作。但是，将 Dovecot 后端配置为使用一个本地用户来执行这些操作有以下几项优点： 			

- ​							Dovecot 以特定本地用户执行文件系统操作，而不使用用户的 ID (UID)。 					
- ​							用户不需要在服务器上本地可用。 					
- ​							您可以将所有邮箱和特定于用户的文件存储在一个根目录中。 					
- ​							用户不需要 UID 和组 ID (GID)，这可以减少管理工作。 					
- ​							有权访问服务器上的文件系统的用户无法破坏其邮箱或索引，因为它们无法访问这些文件。 					
- ​							设置复制更为简单。 					

**先决条件**

- ​							已安装了 Dovecot。 					

**流程**

1. ​							创建 `vmail` 用户： 					

   

   ```none
   # useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail
   ```

   ​							Dovecot 之后将使用此用户来管理邮箱。出于安全考虑，请不要使用 `dovecot` 或 `dovenull` 系统用户来实现这一目的。 					

2. ​							如果您使用与 `/var/mail/` 不同的路径，请在其上设置 `mail_spool_t` SELinux 上下文，例如： 					

   

   ```none
   # semanage fcontext -a -t mail_spool_t "<path>(/.*)?"
   # restorecon -Rv <path>
   ```

3. ​							仅将 `/var/mail/` 的写入权限授予 `vmail` 用户： 					

   

   ```none
   # chown vmail:vmail /var/mail/
   # chmod 700 /var/mail/
   ```

4. ​							取消注释 `/etc/dovecot/conf.d/10-mail.conf` 文件中的 `mail_location` 参数，并将其设置为 mailbox 格式和位置： 					

   

   ```none
   mail_location = sdbox:/var/mail/%n/
   ```

   ​							使用这个设置： 					

   - ​									Dovecot `在单一` 模式中使用 high-performant `dbox` 邮箱格式。在此模式中，服务将每个邮件存储在单独的文件中，类似于 `maildir` 格式。 							
   - ​									Dovecot 解析路径中的 `%n` 变量到用户名。这需要确保每个用户在其邮箱中都有单独的目录。 							

**后续步骤**

- ​							[使用 MariaDB SQL 数据库作为 Dovecot 身份验证后端](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#using-a-mariadb-sql-database-as-the-dovecot-authentication-backend_setting-up-a-dovecot-server-with-mariadb-sql-authentication) 					

**其他资源**

- ​							`/usr/share/doc/dovecot/wiki/VirtualUsers.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailLocation.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/MailboxFormat.dbox.txt` 					
- ​							`/usr/share/doc/dovecot/wiki/Variables.txt` 					

### 1.3.4. 使用 MariaDB SQL 数据库作为 Dovecot 身份验证后端

​					Dovecot 可以从 MariaDB 数据库读取帐户和密码，并在用户登录到 IMAP 或 POP3 服务时使用它来验证用户。这个验证方法的好处包括： 			

- ​							管理员可以在数据库中集中管理用户。 					
- ​							用户在服务器上没有本地访问权限。 					

**先决条件**

- ​							已安装了 Dovecot。 					
- ​							虚拟主机功能已配置。 					
- ​							连接到 MariaDB 服务器支持 TLS 加密。 					
- ​							MariaDB 中存在 `dovecotDB` 数据库，`users` 表至少包含 ` 用户名和密码 ` 列。 					
- ​							`password` 列包含使用 Dovecot 支持的方案加密的密码。 					
- ​							密码可以使用相同的方案，或者具有 `{*pw-storage-scheme*}` 前缀。 					
- ​							`dovecot` MariaDB 用户对 `dovecotDB` 数据库中 `users` 表具有读取权限。 					
- ​							发布 MariaDB 服务器的 TLS 证书的证书颁发机构(CA)的证书存储在 `/etc/pki/tls/certs/ca.crt` 文件中的 Dovecot 服务器上。 					

**流程**

1. ​							安装 `dovecot-mysql` 软件包： 					

   

   ```none
   # dnf install dovecot-mysql
   ```

2. ​							在 `/etc/dovecot/conf.d/10-auth.conf` 文件中配置身份验证后端： 					

   1. ​									注释掉您不需要的 `auth-*.conf.ext` 身份验证后端配置文件的语句，例如： `` 							

      

      ```none
      #!include auth-system.conf.ext
      ```

   2. ​									通过取消注释以下行来启用 SQL 身份验证： 							

      

      ```none
      !include auth-sql.conf.ext
      ```

3. ​							编辑 `/etc/dovecot/conf.d/auth-sql.conf.ext` 文件，并将 `override_fields` 参数添加到 `userdb` 部分，如下所示： 					

   

   ```none
   userdb {
     driver = sql
     args = /etc/dovecot/dovecot-sql.conf.ext
     override_fields = uid=vmail gid=vmail home=/var/mail/%n/
   }
   ```

   ​							由于固定值，Dovecot 不会从 SQL 服务器查询这些设置。 					

4. ​							使用以下设置创建 `/etc/dovecot/dovecot-sql.conf.ext` 文件： 					

   

   ```none
   driver = mysql
   connect = host=mariadb_srv.example.com dbname=dovecotDB user=dovecot password=dovecotPW ssl_ca=/etc/pki/tls/certs/ca.crt
   default_pass_scheme = SHA512-CRYPT
   user_query = SELECT username FROM users WHERE username='%u';
   password_query = SELECT username AS user, password FROM users WHERE username='%u';
   iterate_query = SELECT username FROM users;
   ```

   ​							要将 TLS 加密用于数据库服务器，请将 `ssl_ca` 选项设置为发布 MariaDB 服务器证书的 CA 的证书路径。对于正常工作的证书验证，MariaDB 服务器的主机名必须与其 TLS 证书中使用的主机名匹配。 					

   ​							如果数据库中的密码值包含 `{*pw-storage-scheme*}` 前缀，您可以省略 `default_pass_scheme` 设置。 					

   ​							文件中的查询必须设置如下： 					

   - ​									对于 `user_query` 参数，查询必须返回 Dovecot 用户的用户名。查询还必须只返回一个结果。 							
   - ​									对于 `password_query` 参数，查询必须返回用户名和密码，并且 Dovecot 必须在 `用户和密码` 变量中使用这些值。``因此，如果数据库使用不同的列名称，请使用 `AS` SQL 命令重命名结果中的列。 							
   - ​									对于 `iterate_query` 参数，查询必须返回所有用户的列表。 							

5. ​							对 `/etc/dovecot/dovecot-sql.conf.ext` 文件设置安全权限： 					

   

   ```none
   # chown root:root /etc/dovecot/dovecot-sql.conf.ext
   # chmod 600 /etc/dovecot/dovecot-sql.conf.ext
   ```

**后续步骤**

- ​							[完成 Dovecot 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#completing-the-dovecot-configuration_setting-up-a-dovecot-server-with-mariadb-sql-authentication)。 					

**其他资源**

- ​							`/usr/share/doc/dovecot/example-config/dovecot-sql.conf.ext` 					
- ​							`/usr/share/doc/dovecot/wiki/Authentication.PasswordSchemes.txt` 					

### 1.3.5. 完成 Dovecot 配置

​					安装和配置 Dovecot 后，在 `firewalld` 服务中打开所需的端口，然后启用并启动该服务。之后，您可以测试服务器。 			

**先决条件**

- ​							在 Dovecot 中配置了以下内容： 					
  - ​									TLS 加密 							
  - ​									身份验证后端 							
- ​							客户端信任证书颁发机构(CA)证书。 					

**流程**

1. ​							如果您只想向用户提供 IMAP 或 POP3 服务，请取消注释 `/etc/dovecot/dovecot.conf` 文件中的 protocol 参数，并将其设置为所需的协议。``例如，如果您不需要 POP3，请设置： 					

   

   ```none
   protocols = imap lmtp
   ```

   ​							默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 					

2. ​							在本地防火墙中打开端口。例如，要打开 IMAPS、IMAP、POP3S 和 POP3 协议的端口，请输入： 					

   

   ```none
   # firewall-cmd --permanent --add-service=imaps --add-service=imap --add-service=pop3s --add-service=pop3
   # firewall-cmd --reload
   ```

3. ​							启用并启动 `dovecot` 服务： 					

   

   ```none
   # systemctl enable --now dovecot
   ```

**验证**

1. ​							使用 Mozilla Thunderbird 等邮件客户端连接到 Dovecot 并读取电子邮件。邮件客户端的设置取决于您要使用的协议： 					

   表 1.3. 连接设置到 Dovecot 服务器

   | 协议                                                         | 端口 | 连接安全性 | 身份验证方法                                                 |
   | ------------------------------------------------------------ | ---- | ---------- | ------------------------------------------------------------ |
   | IMAP                                                         | 143  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-mariadb-sql-authentication) |
   | IMAPS                                                        | 993  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-mariadb-sql-authentication) |
   | POP3                                                         | 110  | STARTTLS   | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-mariadb-sql-authentication) |
   | POP3S                                                        | 995  | SSL/TLS    | PLAIN[[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#ftn.fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-mariadb-sql-authentication) |
   | [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/deploying_mail_servers/index#fn-dovecot-con-settings-normal-pw_setting-up-a-dovecot-server-with-mariadb-sql-authentication) 											客户端通过 TLS 连接传输数据。因此，凭证不会被披露。 |      |            |                                                              |

   ​							请注意，这个表不会列出未加密的连接的设置，因为默认情况下，Dovecot 在没有 TLS 的连接中不接受纯文本身份验证。 					

2. ​							使用非默认值显示配置设置： 					

   

   ```none
   # doveconf -n
   ```

**其他资源**

- ​							`firewall-cmd(1)` 手册页 					

## 1.4. 配置两个 Dovecot 服务器之间复制

​				通过双向复制，您可以使 Dovecot 服务器高度可用，而 IMAP 和 POP3 客户端都可以访问这两个服务器上的邮箱。Dovecot 会跟踪每个邮箱的索引日志中的更改，并以安全的方式解决冲突。 		

​				在两个复制合作伙伴上执行这个步骤。 		

注意

​					复制只在服务器对之间正常工作。因此，在大型集群中，您需要多个独立的后端对。 			

**先决条件**

- ​						两个服务器都使用相同的身份验证后端。最好使用 LDAP 或 SQL 来集中维护帐户。 				
- ​						Dovecot 用户数据库配置支持用户列表。使用 `doveadm user '*'` 命令来验证这一点。 				
- ​						Dovecot 以 `vmail` 用户身份而不是用户的 ID (UID)访问文件系统上的邮箱。 				

**流程**

1. ​						创建 `/etc/dovecot/conf.d/10-replication.conf` 文件，并在其中执行以下步骤： 				

   1. ​								启用 `notify` 和 `复制` 插件： 						

      

      ```none
      mail_plugins = $mail_plugins notify replication
      ```

   2. ​								添加 `服务 replicator 部分` ： 						

      

      ```none
      service replicator {
        process_min_avail = 1
      
        unix_listener replicator-doveadm {
          mode = 0600
          user = vmail
        }
      }
      ```

      ​								使用这些设置时，当 `dovecot` 服务启动时，Dovecot 会至少启动一个 replicator 进程。另外，本节定义了 `replicator-doveadm` 套接字的设置。 						

   3. ​								添加 `服务聚合器` 部分来配置 `replication-notify-fifo` 管道和 `replication-notify` 套接字： 						

      

      ```none
      service aggregator {
        fifo_listener replication-notify-fifo {
          user = vmail
        }
        unix_listener replication-notify {
          user = vmail
        }
      }
      ```

   4. ​								添加 `服务 doveadm` 部分以定义复制服务的端口： 						

      

      ```none
      service doveadm {
        inet_listener {
          port = 12345
        }
      }
      ```

   5. ​								设置 `doveadm` 复制服务的密码： 						

      

      ```none
      doveadm_password = replication_password
      ```

      ​								两个服务器上的密码必须相同。 						

   6. ​								配置复制合作伙伴： 						

      

      ```none
      plugin {
        mail_replica = tcp:server2.example.com:12345
      }
      ```

   7. ​								可选：定义并行 `dsync` 进程的最大数量： 						

      

      ```none
      replication_max_conns = 20
      ```

      ​								`replication_max_conns` 的默认值为 `10`。 						

2. ​						对 `/etc/dovecot/conf.d/10-replication.conf` 文件设置安全权限： 				

   

   ```none
   # chown root:root /etc/dovecot/conf.d/10-replication.conf
   # chmod 600 /etc/dovecot/conf.d/10-replication.conf
   ```

3. ​						启用 `nis_enabled` SELinux 布尔值，以允许 Dovecot 打开 `doveadm` 复制端口： 				

   

   ```none
   setsebool -P nis_enabled on
   ```

4. ​						将 `firewalld` 规则配置为只允许复制合作伙伴访问复制端口，例如： 				

   

   ```none
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.0.2.1/32" port protocol="tcp" port="12345" accept"
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv6" source address="2001:db8:2::1/128" port protocol="tcp" port="12345" accept"
   # firewall-cmd --reload
   ```

   ​						IPv4 和 `/128` 用于 IPv6 地址的子网掩码 `/32` 限制对指定地址的访问。 				

5. ​						在其他复制合作伙伴上执行这个步骤。 				

6. ​						重新载入 Dovecot： 				

   

   ```none
   # systemctl reload dovecot
   ```

**验证**

1. ​						在一个服务器上的邮箱中执行操作，然后验证 Dovecot 是否将更改复制到其他服务器。 				

2. ​						显示 replicator 状态： 				

   

   ```none
   # doveadm replicator status
   Queued 'sync' requests        0
   Queued 'high' requests        0
   Queued 'low' requests         0
   Queued 'failed' requests      0
   Queued 'full resync' requests 30
   Waiting 'failed' requests     0
   Total number of known users   75
   ```

3. ​						显示特定用户的 replicator 状态： 				

   

   ```none
   # doveadm replicator status example_user
   username        priority  fast sync  full sync  success sync  failed
   example_user    none      02:05:28   04:19:07   02:05:28      -
   ```

**其他资源**

- ​						`dsync(1)` man page 				
- ​						`/usr/share/doc/dovecot/wiki/Replication.txt` 				

## 1.5. 自动订阅用户至 IMAP 邮箱

​				通常，IMAP 服务器管理员希望 Dovecot 自动创建某些邮箱，如 `Sent` 和 `Trash`，并将用户订阅给他们。您可以在 配置文件中设置它。 		

​				另外，您可以定义 *使用特殊邮箱*。IMAP 客户端通常支持为特殊目的定义邮箱，如用于发送电子邮件。为避免用户必须手动选择和设置正确的邮箱，IMAP 服务器可以在 IMAP `LIST` 命令中发送 `特殊使用` 属性。然后，客户端可以使用此属性来识别和设置，例如：发送电子邮件的邮箱。 		

**先决条件**

- ​						配置了 Dovecot。 				

**流程**

1. ​						更新 `/etc/dovecot/conf.d/15-mailboxes.conf` 文件中的 `inbox` 命名空间部分： 				

   1. ​								将 `auto = subscribe` 设置添加到应该可供用户使用的每个特殊邮箱中，例如： 						

      

      ```none
      namespace inbox {
        ...
        mailbox Drafts {
          special_use = \Drafts
          auto = subscribe
        }
      
        mailbox Junk {
          special_use = \Junk
          auto = subscribe
        }
      
        mailbox Trash {
          special_use = \Trash
          auto = subscribe
        }
      
        mailbox Sent {
          special_use = \Sent
          auto = subscribe
        }
        ...
      }
      ```

      ​								如果您的邮件客户端支持更多特殊用途的邮箱，您可以添加类似的条目。`special_use` 参数定义 Dovecot 在 `special-use` 属性中向客户端发送的值。 						

   2. ​								可选：如果要定义没有特殊目的的其他 `邮箱，请在用户的 inbox 中添加邮箱` 部分，例如： 						

      

      ```none
      namespace inbox {
        ...
        mailbox "Important Emails" {
          auto = <value>
        }
        ...
      }
      ```

      ​								您可以将 `auto` 参数设置为以下值之一： 						

      - ​										`订阅` ：自动创建邮箱并订阅用户。 								
      - ​										`创建` ：自动创建邮箱，而无需订阅用户。 								
      - ​										`No` （默认）： Dovecot 不会创建邮箱，也不会为其订阅用户。 								

2. ​						重新载入 Dovecot： 				

   

   ```none
   # systemctl reload dovecot
   ```

**验证**

- ​						使用 IMAP 客户端访问您的邮箱。 				

  ​						带有 `auto = subscribe` 设置的邮箱会自动可见。如果客户端支持特殊使用的邮箱和定义的目的，客户端会自动使用它们。 				

**其他资源**

- ​						[RFC 6154：用于特殊使用 Mailbox 的 IMAP LIST 扩展](https://www.rfc-editor.org/rfc/rfc6154) 				
- ​						`/usr/share/doc/dovecot/wiki/MailboxSettings.txt` 				

## 1.6. 配置 LMTP 套接字和 LMTPS 侦听器

​				SMTP 服务器（如 Postfix）使用本地邮件传输协议(LMTP)向 Dovecot 发送电子邮件。如果 SMTP 服务器运行： 		

- ​						在与 Dovecot 相同的主机上，使用 LMTP 套接字 				

- ​						在其他主机上，使用 LMTP 服务 				

  ​						默认情况下，LMTP 协议没有加密。但是，如果您配置了 TLS 加密，则 Dovecot 会自动对 LMTP 服务使用相同的设置。然后，SMTP 服务器可以使用 LMTPS 协议或 LMTP 上的 `STARTTLS` 命令连接它。 				

**先决条件**

- ​						已安装了 Dovecot。 				
- ​						如果要配置 LMTP 服务，TLS 加密会在 Dovecot 中配置。 				

**流程**

1. ​						验证 LMTP 协议是否已启用： 				

   

   ```none
   # doveconf -a | egrep "^protocols"
   protocols = imap pop3 lmtp
   ```

   ​						如果输出包含 `lmtp`，则启用该协议。 				

2. ​						如果 `lmtp` 协议被禁用，请编辑 `/etc/dovecot/dovecot.conf` 文件，并将 `lmtp` 附加到 protocol 参数的值： `` 				

   

   ```none
   protocols = ... lmtp
   ```

3. ​						根据您是否需要 LMTP 套接字或服务，在 `/etc/dovecot/conf.d/10-master.conf` 文件中的 `服务 lmtp` 部分中进行以下更改： 				

   - ​								LMTP 套接字：默认情况下，Dovecot 会自动创建 `/var/run/dovecot/lmtp` 套接字。 						

     ​								可选：自定义所有权和权限： 						

     

     ```none
     service lmtp {
       ...
       unix_listener lmtp {
         mode = 0600
         user = postfix
         group = postfix
       }
       ...
     }
     ```

   - ​								LMTP 服务：添加一个 `inet_listener` 子部分： 						

     

     ```none
     service lmtp {
       ...
       inet_listener lmtp {
         port = 24
       }
       ...
     }
     ```

4. ​						将 `firewalld` 规则配置为只允许 SMTP 服务器访问 LMTP 端口，例如： 				

   

   ```none
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.0.2.1/32" port protocol="tcp" port="24" accept"
   # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv6" source address="2001:db8:2::1/128" port protocol="tcp" port="24" accept"
   # firewall-cmd --reload
   ```

   ​						IPv4 和 `/128` 用于 IPv6 地址的子网掩码 `/32` 限制对指定地址的访问。 				

5. ​						重新载入 Dovecot： 				

   

   ```none
   # systemctl reload dovecot
   ```

**验证**

1. ​						如果您配置了 LMTP 套接字，请验证 Dovecot 是否已创建套接字，以及权限是否正确： 				

   

   ```none
   # ls -l /var/run/dovecot/lmtp
   srw-------. 1 postfix postfix 0 Nov 22 17:17 /var/run/dovecot/lmtp
   ```

2. ​						配置 SMTP 服务器，以使用 LMTP 套接字或服务向 Dovecot 提交电子邮件。 				

   ​						使用 LMTP 服务时，请确保 SMTP 服务器使用 LMTPS 协议或发送 `STARTTLS` 命令以使用加密连接。 				

**其他资源**

- ​						`/usr/share/doc/dovecot/wiki/LMTP.txt` 				

## 1.7. 在 Dovecot 中禁用 IMAP 或 POP3 服务

​				默认情况下，Dovecot 提供 IMAP 和 POP3 服务。如果您只需要其中之一，您可以禁用另一个以减少攻击面。 		

**先决条件**

- ​						已安装了 Dovecot。 				

**流程**

1. ​						取消注释 `/etc/dovecot/dovecot.conf` 文件中的 protocol 参数，并将它设置为使用所需的协议。``例如，如果您不需要 POP3，请设置： 				

   

   ```none
   protocols = imap lmtp
   ```

   ​						默认情况下启用 `imap`、`pop3` 和 `lmtp` 协议。 				

2. ​						重新载入 Dovecot： 				

   

   ```none
   # systemctl reload dovecot
   ```

3. ​						关闭本地防火墙中不再需要的端口。例如，要关闭 POP3S 和 POP3 协议的端口，请输入： 				

   

   ```none
   # firewall-cmd --remove-service=pop3s --remove-service=pop3
   # firewall-cmd --reload
   ```

**验证**

- ​						显示 `dovecot` 进程打开的 `LISTEN` 模式中的所有端口： 				

  

  ```none
  # ss -tulp | grep dovecot
  tcp  LISTEN 0  100  0.0.0.0:993  0.0.0.0:*  users:(("dovecot",pid=1405,fd=44))
  tcp  LISTEN 0  100  0.0.0.0:143  0.0.0.0:*  users:(("dovecot",pid=1405,fd=42))
  tcp  LISTEN 0  100     [::]:993     [::]:*  users:(("dovecot",pid=1405,fd=45))
  tcp  LISTEN 0  100     [::]:143     [::]:*  users:(("dovecot",pid=1405,fd=43))
  ```

  ​						在本例中，Dovecot 仅侦听 TCP 端口 `993` (IMAPS)和 `143` (IMAP)。 				

  ​						请注意，如果您将服务配置为侦听端口而不使用套接字，则 Dovecot 仅为 LMTP 协议打开端口。 				

**其他资源**

- ​						`firewall-cmd(1)` 手册页 				

## 1.8. 在 Dovecot IMAP 服务器上使用 Sieve 启用服务器端电子邮件过滤

​				您可以使用 ManageSieve 协议将 Sieve 脚本上传到服务器。Sieve  脚本定义服务器应验证和执行传入电子邮件的规则和操作。例如，用户可以使用 Sieve  从特定发件人转发电子邮件，管理员可以创建一个全局过滤器，将垃圾邮件过滤器标记的邮件移到单独的 IMAP 文件夹中。 		

​				`ManageSieve` 插件为 Dovecot IMAP 服务器添加了对 Sieve 脚本和 ManageSieve 协议的支持。 		

警告

​					仅使用支持通过 TLS 连接使用 ManageSieve 协议的客户端。禁用此协议的 TLS 会导致客户端通过网络以纯文本形式发送凭证。 			

**先决条件**

- ​						Dovecot 被配置并提供 IMAP 邮箱。 				
- ​						TLS 加密在 Dovecot 中配置。 				
- ​						邮件客户端通过 TLS 连接支持 ManageSieve 协议。 				

**流程**

1. ​						安装 `dovecot-pigeonhole` 软件包： 				

   

   ```none
   # dnf install dovecot-pigeonhole
   ```

2. ​						取消注释 `/etc/dovecot/conf.d/20-managesieve.conf` 中的以下行以启用 `sieve` 协议： 				

   

   ```none
   protocols = $protocols sieve
   ```

   ​						除了已经启用的其他协议外，此设置还激活 Sieve。 				

3. ​						在 `firewalld` 中打开 ManageSieve 端口： 				

   

   ```none
   # firewall-cmd --permanent --add-service=managesieve
   # firewall-cmd --reload
   ```

4. ​						重新载入 Dovecot： 				

   

   ```none
   # systemctl reload dovecot
   ```

**验证**

1. ​						使用客户端并上传 Sieve 脚本。使用以下连接设置： 				
   - ​								端口：4190 						
   - ​								连接安全：SSL/TLS 						
   - ​								身份验证方法： PLAIN 						
2. ​						发送电子邮件给 Sieve 脚本上传的用户。如果电子邮件与脚本中的规则匹配，请验证服务器是否执行定义的操作。 				

**其他资源**

- ​						`/usr/share/doc/dovecot/wiki/Pigeonhole.Sieve.Plugins.IMAPSieve.txt` 				
- ​						`/usr/share/doc/dovecot/wiki/Pigeonhole.Sieve.Troubleshooting.txt` 				
- ​						`firewall-cmd(1)` 手册页 				

## 1.9. Dovecot 如何处理配置文件

​				`dovecot` 软件包提供主配置文件 `/etc/dovecot/dovecot.conf` 和 `/etc/dovecot/conf.d/` 目录中的多个配置文件。Dovecot 会在您启动服务时组合文件来构建配置。 		

​				多个配置文件的主要优点是对设置进行分组并提高可读性。如果您希望使用单个配置文件，可以维护 `/etc/dovecot/dovecot.conf` 中的所有设置，并从 `该文件` 中删除所有 `include_try` 语句。 		

**其他资源**

- ​						`/usr/share/doc/dovecot/wiki/ConfigFile.txt` 				
- ​						`/usr/share/doc/dovecot/wiki/Variables.txt` 				