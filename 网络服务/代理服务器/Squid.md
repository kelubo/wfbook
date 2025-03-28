# 配置 Squid 缓存代理服务器



# How to install a Squid server 如何安装 Squid 服务器

Squid is a filtering and caching mechanism for web servers that can optimise  bandwidth and performance. For more information about Squid proxy  servers, [refer to this guide](https://ubuntu.com/server/docs/about-squid-proxy-servers).
Squid 是一种用于 Web 服务器的过滤和缓存机制，可以优化带宽和性能。有关 Squid 代理服务器的更多信息，请参阅本指南。

## Install Squid 安装 Squid

At a terminal prompt, enter the following command to install the Squid server:
在终端提示符下，输入以下命令以安装 Squid 服务器：

```bash
sudo apt install squid
```

## Configure Squid 配置 Squid

Squid is configured by editing directives in the `/etc/squid/squid.conf` configuration file. The following examples illustrate a sample of  directives that can be modified to configure the Squid server’s  behavior. For more in-depth configuration details, see the links at the  bottom of the page.
Squid 是通过编辑 `/etc/squid/squid.conf` 配置文件中的指令来配置的。以下示例说明了可以修改以配置 Squid 服务器行为的指令示例。有关更深入的配置详细信息，请参阅页面底部的链接。

### Protect the original config file 保护原始配置文件

Before editing the configuration file, you should make a copy of the original  and protect it from writing. You will then have the original settings as a reference, and can reuse it when needed. Run the following commands  to make a copy of the original configuration file and protect it from  being written to:
在编辑配置文件之前，您应该复制原始文件并防止其写入。然后，您将拥有原始设置作为参考，并可以在需要时重复使用它。运行以下命令以创建原始配置文件的副本并防止其被写入：

```bash
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.original
sudo chmod a-w /etc/squid/squid.conf.original
```

### Change TCP port 更改 TCP 端口

To set your Squid server to listen on TCP port 8888 instead of the default TCP port 3128, change the **http_port** directive as such:
要将 Squid 服务器设置为侦听 TCP 端口 8888 而不是默认的 TCP 端口 3128，请按以下方式更改 http_port 指令：

```plaintext
http_port 8888
```

### Set the hostname 设置主机名

Change the **visible_hostname** directive to give the Squid server a specific hostname. This hostname  does not need to be the same as the computer’s hostname. In this example it is set to `weezie`:
更改 visible_hostname 指令以为 Squid 服务器提供特定的主机名。此主机名不需要与计算机的主机名相同。在此示例中， `weezie` 它设置为：

```plaintext
visible_hostname weezie
```

### Configure on-disk cache 配置磁盘缓存

The default setting is to use on-memory cache. By changing the **cache_dir** directive you can configure use of an on-disk cache. The `cache_dir` directive takes the following arguments:
默认设置是使用内存缓存。通过更改 cache_dir 指令，可以配置磁盘缓存的使用。该 `cache_dir` 指令采用以下参数：

```plaintext
cache_dir <Type> <Directory-Name> <Fs-specific-data> [options]
```

In the config file you can find the default `cache_dir` directive commented out:
在配置文件中，您可以找到注释掉的默认 `cache_dir` 指令：

```plaintext
# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256
```

You can use the default option but you can also customise your cache directory, by changing the `<Type>` of this directory. It can be one of the following options:
您可以使用默认选项，但也可以通过更改此目录来自 `<Type>` 定义缓存目录。它可以是以下选项之一：

- `ufs`: This is the common Squid storage format.
   `ufs` ：这是常见的 Squid 存储格式。
- `aufs`: Uses the same storage format as `ufs`, using POSIX-threads to avoid blocking the main Squid process on disk-I/O. This was formerly known in Squid as `async-io`.
   `aufs` ：使用与 `ufs` 相同的存储格式，使用 POSIX-threads 以避免阻塞磁盘 I/O 上的主 Squid 进程。这在 Squid 中以前被称为 `async-io` .
- `diskd`: Uses the same storage format as `ufs`, using a separate process to avoid blocking the main Squid process on disk-I/O.
   `diskd` ：使用与 `ufs` 相同的存储格式，使用单独的进程来避免阻塞磁盘 I/O 上的主 Squid 进程。
- `rock`: This is a database-style storage. All cached entries are stored in a  “database” file, using fixed-size slots. A single entry occupies one or  more slots.
   `rock` ：这是数据库样式的存储。所有缓存的条目都存储在“数据库”文件中，使用固定大小的插槽。单个条目占用一个或多个插槽。

If you want to use a different directory type please take a look at their different options.
如果您想使用不同的目录类型，请查看它们的不同选项。

### Access control 存取控制

Using Squid’s access control, you can configure use of Squid-proxied Internet services to be available only to users with certain Internet Protocol  (IP) addresses. For example, we will illustrate access by users of the `192.168.42.0/24` subnetwork only:
使用 Squid 的访问控制，您可以将 Squid 代理的 Internet 服务配置为仅对具有特定 Internet 协议 （IP） 地址的用户可用。例如，我们将仅说明 `192.168.42.0/24` 子网用户的访问：

- Add the following to the **bottom** of the ACL section of your `/etc/squid/squid.conf` file:
  将以下内容添加到 `/etc/squid/squid.conf` 文件的 ACL 部分的底部：

  ```plaintext
  acl fortytwo_network src 192.168.42.0/24
  ```

- Then, add the following to the **top** of the http_access section of your `/etc/squid/squid.conf` file:
  然后，将以下内容添加到 `/etc/squid/squid.conf` 文件的http_access部分的顶部：

  ```plaintext
  http_access allow fortytwo_network
  ```

Using Squid’s access control features, you can configure Squid-proxied  Internet services to only be available during normal business hours. As  an example, we’ll illustrate access by employees of a business which is  operating between 9:00AM and 5:00PM, Monday through Friday, and which  uses the `10.1.42.0/24` subnetwork:
使用 Squid 的访问控制功能，您可以将 Squid 代理的 Internet 服务配置为仅在正常工作时间可用。例如，我们将说明在周一至周五上午 9：00 至下午 5：00 之间运营且使用 `10.1.42.0/24` 子网的企业的员工的访问权限：

- Add the following to the **bottom** of the ACL section of your `/etc/squid/squid.conf` file:
  将以下内容添加到 `/etc/squid/squid.conf` 文件的 ACL 部分的底部：

  ```plaintext
  acl biz_network src 10.1.42.0/24
  acl biz_hours time M T W T F 9:00-17:00
  ```

- Then, add the following to the **top** of the `http_access` section of your `/etc/squid/squid.conf` file:
  然后，将以下内容添加到 `/etc/squid/squid.conf` 文件 `http_access` 部分的顶部：

  ```plaintext
  http_access allow biz_network biz_hours
  ```

## Restart the Squid server 重新启动 Squid 服务器

After making any changes to the `/etc/squid/squid.conf` file, you will need to save the file and restart the squid server  application. You can restart the server using the following command:
对 `/etc/squid/squid.conf` 文件进行任何更改后，您需要保存文件并重新启动 squid 服务器应用程序。您可以使用以下命令重新启动服务器：

```bash
sudo systemctl restart squid.service
```

> **Note**: 注意：
>  If a formerly customised squid3 was used to set up the spool at `/var/log/squid3` to be a mountpoint, but otherwise kept the default configuration, the  upgrade will fail. The upgrade tries to rename/move files as needed, but it can’t do so for an active mountpoint. In that case you will need to  adapt either the mountpoint or the config in `/etc/squid/squid.conf` so that they match.
> 如果使用以前自定义的 squid3 将假脱机 `/var/log/squid3` 设置为挂载点，但在其他方面保持默认配置，则升级将失败。升级会尝试根据需要重命名/移动文件，但无法对活动挂载点执行此操作。在这种情况下，您需要调整挂载点或配置， `/etc/squid/squid.conf` 以使它们匹配。
>  The same applies if the **include** config statement was used to pull in more files from the old path at `/etc/squid3/`. In those cases you should move and adapt your configuration accordingly.
> 如果使用 include config 语句从旧路径 中 `/etc/squid3/` 提取更多文件，则同样适用。在这些情况下，您应该相应地移动和调整您的配置。

## Further reading 延伸阅读

- [The Squid Website The Squid 网站](http://www.squid-cache.org/)
- [Ubuntu Wiki page on Squid](https://help.ubuntu.com/community/Squid).
  Squid 上的 Ubuntu Wiki 页面。

------



​			Squid 是一个代理服务器，可缓存内容以减少带宽并更快地加载 Web 页面。本章论述了如何将 Squid 设置为 HTTP、HTTPS 和 FTP 协议的代理，以及验证和限制访问。 	

## 3.1. 将 Squid 设置为没有身份验证的缓存代理

​				这部分论述了 Squid 的基本配置在没有身份验证的情况下作为缓存代理。此流程会根据 IP 范围限制对代理的访问。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				

**步骤**

1. ​						安装 `squid` 软件包： 				

   

   ```none
   # yum install squid
   ```

2. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								调整 `localnet` 访问控制列表(ACL)，使其与允许使用代理的 IP 范围匹配： 						

      

      ```none
      acl localnet src 192.0.2.0/24
      acl localnet 2001:db8:1::/64
      ```

      ​								默认情况下，`/etc/squid/squid.conf` 文件包含 `http_access allow localnet` 规则，允许使用 `localnet` ACL 中指定的所有 IP 范围内的代理。请注意，您必须在 `http_access allow localnet` 规则之前指定所有 `localnet` ACL。 						

      重要

      ​									删除所有与您的环境不匹配的现有的 `acl localnet` 条目。 							

   2. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      

      ```none
      acl SSL_ports port port_number
      ```

   3. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了拒绝访问`Safe_ports` ACL 中未定义的端口。 						

   4. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

3. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

4. ​						在防火墙中打开 `3128` 端口： 				

   

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

5. ​						启用并启动 `squid` 服务： 				

   

   ```none
   # systemctl enable --now squid
   ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			



```none
# curl -O -L "https://www.redhat.com/index.html" -x "proxy.example.com:3128"
```

​				如果 `curl` 没有显示任何错误，并且 `index.html` 文件可以下载到当前目录中，那么代理工作正常。 		

## 3.2. 使用 LDAP 身份验证将 Squid 设置为缓存代理

​				本节描述了 Squid 作为使用 LDAP 验证用户身份的缓存代理的基本配置。此流程配置仅经过身份验证的用户可以使用代理。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				
- ​						LDAP 目录中存在一个服务用户，例如 `uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com`。Squid 只使用此帐户搜索验证用户。如果存在身份验证用户，Squid 会以此用户的身份绑定到该目录以验证身份验证。 				

**步骤**

1. ​						安装 `squid` 软件包： 				

   

   ```none
   # yum install squid
   ```

2. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								要配置 `basic_ldap_auth` 助手工具，请在 `/etc/squid/squid.conf` 顶部添加以下配置条目： 						

      

      ```none
      auth_param basic program /usr/lib64/squid/basic_ldap_auth -b "cn=users,cn=accounts,dc=example,dc=com" -D "uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com" -W /etc/squid/ldap_password -f "(&(objectClass=person)(uid=%s))" -ZZ -H ldap://ldap_server.example.com:389
      ```

      ​								下面描述了传递给上例中 `basic_ldap_auth` helper 工具的参数： 						

      - ​										`-b *base_DN*` 设置 LDAP 搜索基础。 								

      - ​										`-d *proxy_service_user_DN*` 设置帐户 Squid 的可分辨名称(DN)，用于在 目录中搜索用户身份验证。 								

      - ​										`-W *path_to_password_file*` 设置包含代理服务用户密码的文件的路径。使用密码文件可防止在操作系统的进程列表中看到密码。 								

      - ​										`-f *LDAP_filter*` 指定 LDAP 搜索过滤器。Squid 将 `%s` 变量替换为身份验证用户提供的用户名。 								

        ​										示例中的 `(&(objectClass=person)(uid=%s))` 过滤器定义用户名必须与 `uid` 属性中设置的值匹配，并且目录条目包含 `person` 对象类。 								

      - ​										`-ZZ` 使用 `STARTTLS` ，通过 LDAP 协议强制实施 TLS 加密连接。在以下情况下省略 `-ZZ` ： 								

        - ​												LDAP 服务器不支持加密的连接。 										
        - ​												URL 中指定的端口使用 LDAPS 协议。 										

      - ​										-H LDAP_URL 参数指定协议、主机名或 IP 地址以及 LDAP 服务器的端口，格式为 URL。 								

   2. ​								添加以下 ACL 和规则来配置 Squid 只允许经过身份验证的用户使用代理： 						

      

      ```none
      acl ldap-auth proxy_auth REQUIRED
      http_access allow ldap-auth
      ```

      重要

      ​									在 `http_access deny` 所有规则之前指定这些设置。 							

   3. ​								删除以下规则，以禁用从 `localnet` ACL 中指定的 IP 范围绕过代理身份验证： 						

      

      ```none
      http_access allow localnet
      ```

   4. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      

      ```none
      acl SSL_ports port port_number
      ```

   5. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了访问拒绝 `Safe_ports` ACL 中未定义的端口。 						

   6. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

3. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

4. ​						将 LDAP 服务用户的密码存储在 `/etc/squid/ldap_password` 文件中，并为该文件设置适当的权限： 				

   

   ```none
   # echo "password" > /etc/squid/ldap_password
   # chown root:squid /etc/squid/ldap_password
   # chmod 640 /etc/squid/ldap_password
   ```

5. ​						在防火墙中打开 `3128` 端口： 				

   

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

6. ​						启用并启动 `squid` 服务： 				

   

   ```none
   # systemctl enable --now squid
   ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			



```none
# curl -O -L "https://www.redhat.com/index.html" -x "user_name:password@proxy.example.com:3128"
```

​				如果 curl 没有显示任何错误，并且 `index.html` 文件可下载到当前目录中，那么代理工作正常。 		

**故障排除步骤**

​					验证 helper 工具是否正常工作： 			

1. ​						使用您在 `auth_param` 参数中使用的相同设置来手动启动助手工具： 				

   

   ```none
   # /usr/lib64/squid/basic_ldap_auth -b "cn=users,cn=accounts,dc=example,dc=com" -D "uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com" -W /etc/squid/ldap_password -f "(&(objectClass=person)(uid=%s))" -ZZ -H ldap://ldap_server.example.com:389
   ```

2. ​						输入一个有效的用户名和密码，然后按 **Enter** 键： 				

   

   ```none
   user_name password
   ```

   ​						如果帮助程序返回 `OK`，则身份验证成功。 				

## 3.3. 将 Squid 设置为带有 kerberos 身份验证的缓存代理

​				这部分描述了 Squid 作为缓存代理的基本配置，它使用 Kerberos 向 Active Directory(AD)验证用户。此流程配置仅经过身份验证的用户可以使用代理。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				
- ​						要安装 Squid 的服务器是 AD 域的成员。详情请查看在 Red Hat Enterprise Linux 8 上`部署不同类型的服务器` 文档中的 [将 Samba 设置为域成员 ](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/assembly_using-samba-as-a-server_deploying-different-types-of-servers#assembly_setting-up-samba-as-an-ad-domain-member-server_assembly_using-samba-as-a-server)。 				

**步骤**

1. ​						安装以下软件包： 				

   

   ```none
   # yum install squid krb5-workstation
   ```

2. ​						以 AD 域管理员身份进行身份验证： 				

   

   ```none
   # kinit administrator@AD.EXAMPLE.COM
   ```

3. ​						为 Squid 创建一个 keytab，并将其存储在 `/etc/squid/HTTP.keytab` 文件中： 				

   

   ```none
   # export KRB5_KTNAME=FILE:/etc/squid/HTTP.keytab
   # net ads keytab CREATE -U administrator
   ```

4. ​						在 keytab 中添加 `HTTP` 服务主体： 				

   

   ```none
   # net ads keytab ADD HTTP -U administrator
   ```

5. ​						将 keytab 文件的所有者设置为 `squid` 用户： 				

   

   ```none
   # chown squid /etc/squid/HTTP.keytab
   ```

6. ​						另外，验证 keytab 文件是否包含代理服务器的完全限定域名(FQDN)的 `HTTP` 服务主体： 				

   

   ```none
     klist -k /etc/squid/HTTP.keytab
   Keytab name: FILE:/etc/squid/HTTP.keytab
   KVNO Principal
   ---- ---------------------------------------------------
   ...
      2 HTTP/proxy.ad.example.com@AD.EXAMPLE.COM
   ...
   ```

7. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								要配置 `negotiate_kerberos_auth` 助手工具，请在 `/etc/squid/squid.conf` 的顶部添加以下配置条目： 						

      

      ```none
      auth_param negotiate program /usr/lib64/squid/negotiate_kerberos_auth -k /etc/squid/HTTP.keytab -s HTTP/proxy.ad.example.com@AD.EXAMPLE.COM
      ```

      ​								下面描述了在上例中传给 `negotiate_kerberos_auth` 助手工具的参数： 						

      - ​										`-K *file*` 设置密钥选项卡文件的路径。请注意，squid 用户必须拥有这个文件的读取权限。 								

      - ​										`-s HTTP/*host_name*@*kerberos_realm*` 设置 Squid 使用的 Kerberos 主体。 								

        ​										另外，您可以通过将以下一个或多个参数传递给帮助程序来启用日志： 								

      - ​										`-i` 记录信息，如验证用户。 								

      - ​										`-d` 启用调试日志记录。 								

        ​										Squid 将助手工具中的调试信息记录到 `/var/log/squid/cache.log` 文件。 								

   2. ​								添加以下 ACL 和规则来配置 Squid 只允许经过身份验证的用户使用代理： 						

      

      ```none
      acl kerb-auth proxy_auth REQUIRED
      http_access allow kerb-auth
      ```

      重要

      ​									在`http_access deny all`之前指定这些设置。 							

   3. ​								删除以下规则，以禁用从 `localnet` ACL 中指定的 IP 范围绕过代理身份验证： 						

      

      ```none
      http_access allow localnet
      ```

   4. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      

      ```none
      acl SSL_ports port port_number
      ```

   5. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了拒绝访问`Safe_ports` ACL 中未定义的端口。 						

   6. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

8. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

9. ​						在防火墙中打开 `3128` 端口： 				

   

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

10. ​						启用并启动 `squid` 服务： 				

    

    ```none
    # systemctl enable --now squid
    ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			



```none
# curl -O -L "https://www.redhat.com/index.html" --proxy-negotiate -u : -x "proxy.ad.example.com:3128"
```

​				如果 `curl` 没有显示任何错误，并且 `index.html` 文件存在于当前目录中，那么代理工作正常。 		

**故障排除步骤**

​					手动测试 Kerberos 身份验证： 			

1. ​						为 AD 帐户获取 Kerberos ticket： 				

   

   ```none
   # kinit user@AD.EXAMPLE.COM
   ```

2. ​						显示 ticket（可选）： 				

   

   ```none
   # klist
   ```

3. ​						使用 `talk_kerberos_auth_test` 工具来测试身份验证： 				

   

   ```none
   # /usr/lib64/squid/negotiate_kerberos_auth_test proxy.ad.example.com
   ```

   ​						如果助手工具返回令牌，则身份验证成功： 				

   

   ```none
   Token: YIIFtAYGKwYBBQUCoIIFqDC...
   ```

## 3.4. 在 Squid 中配置域拒绝列表

​				通常,管理员想要阻止对特定域的访问。这部分论述了如何在 Squid 中配置域拒绝列表。 		

**先决条件**

- ​						squid 被配置，用户可以使用代理。 				

**步骤**

1. ​						编辑 `/etc/squid/squid.conf` 文件，并添加以下设置： 				

   

   ```none
   acl domain_deny_list dstdomain "/etc/squid/domain_deny_list.txt"
   http_access deny all domain_deny_list
   ```

   重要

   ​							在允许访问用户或客户端的第一个 `http_access allow` 语句前面添加这些条目。 					

2. ​						创建 `/etc/squid/domain_deny_list.txt` 文件，并添加您要阻止的域。例如，要阻止对包括子域的 `example.com` 的访问，并阻止对 `example.net` 的访问，请添加： 				

   

   ```none
   .example.com
   example.net
   ```

   重要

   ​							如果您在 squid 配置中引用了 `/etc/squid/domain_deny_list.txt` 文件，则此文件不能为空。如果文件为空，Squid 无法启动。 					

3. ​						重启 `squid` 服务： 				

   

   ```none
   # systemctl restart squid
   ```

## 3.5. 将 Squid 服务配置为监听特定端口或 IP 地址

​				默认情况下，Squid 代理服务监听所有网络接口上的 `3128` 端口。这部分论述了如何更改端口并配置 Squid 在特定 IP 地址中监听。 		

**先决条件**

- ​						`squid` 软件包已安装。 				

**步骤**

1. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   - ​								要设置 Squid 服务监听的端口，请在 `http_port` 参数中设置端口号。例如，要将端口设置为 `8080`，请设置： 						

     

     ```none
     http_port 8080
     ```

   - ​								要配置 Squid 服务监听的 IP 地址，请在 `http_port` 参数中设置 IP 地址和端口号。例如，要配置 Squid 只监听 `192.0.2.1` IP 地址的 `3128` 端口，请设置： 						

     

     ```none
     http_port 192.0.2.1:3128
     ```

     ​								在配置文件中添加多个 `http_port` 参数，来配置 Squid 监听多个端口和 IP 地址： 						

     

     ```none
     http_port 192.0.2.1:3128
     http_port 192.0.2.1:8080
     ```

2. ​						如果您配置了 Squid 使用不同的端口作为默认值(`3128)`： 				

   1. ​								在防火墙中打开端口： 						

      

      ```none
      # firewall-cmd --permanent --add-port=port_number/tcp
      # firewall-cmd --reload
      ```

   2. ​								如果您在 enforcing 模式下运行 SELinux，请将端口分配给 `squid_port_t` 端口类型定义： 						

      

      ```none
      # semanage port -a -t squid_port_t -p tcp port_number
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

3. ​						重启 `squid` 服务： 				

   

   ```none
   # systemctl restart squid
   ```

## 3.6. 其他资源

- ​						配置参数 `usr/share/doc/squid-<version>/squid.conf.documented` 				

​                

# 配置 Squid 缓存代理服务器

​			Squid 是一个代理服务器，可缓存内容以减少带宽并更快地加载 Web 页面。本章论述了如何将 Squid 设置为 HTTP、HTTPS 和 FTP 协议的代理，以及验证和限制访问。 	

## 3.1. 将 Squid 设置为没有身份验证的缓存代理

​				这部分论述了 Squid 的基本配置在没有身份验证的情况下作为缓存代理。此流程会根据 IP 范围限制对代理的访问。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				

**步骤**

1. ​						安装 `squid` 软件包： 				

   ```none
   # dnf install squid
   ```

2. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								调整 `localnet` 访问控制列表(ACL)，使其与允许使用代理的 IP 范围匹配： 						

      ```none
      acl localnet src 192.0.2.0/24
      acl localnet 2001:db8:1::/64
      ```

      ​								默认情况下，`/etc/squid/squid.conf` 文件包含 `http_access allow localnet` 规则，允许使用 `localnet` ACL 中指定的所有 IP 范围内的代理。请注意，您必须在 `http_access allow localnet` 规则之前指定所有 `localnet` ACL。 						

      重要

      ​									删除所有与您的环境不匹配的现有的 `acl localnet` 条目。 							

   2. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      ```none
      acl SSL_ports port port_number
      ```

   3. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了拒绝访问`Safe_ports` ACL 中未定义的端口。 						

   4. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

3. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

4. ​						在防火墙中打开 `3128` 端口： 				

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

5. ​						启用并启动 `squid` 服务： 				

   ```none
   # systemctl enable --now squid
   ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			

```none
# curl -O -L "https://www.redhat.com/index.html" -x "proxy.example.com:3128"
```

​				如果 `curl` 没有显示任何错误，并且 `index.html` 文件可以下载到当前目录中，那么代理工作正常。 		

## 3.2. 使用 LDAP 身份验证将 Squid 设置为缓存代理

​				本节描述了 Squid 作为使用 LDAP 验证用户身份的缓存代理的基本配置。此流程配置仅经过身份验证的用户可以使用代理。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				
- ​						LDAP 目录中存在一个服务用户，例如 `uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com`。Squid 只使用此帐户搜索验证用户。如果存在身份验证用户，Squid 会以此用户的身份绑定到该目录以验证身份验证。 				

**步骤**

1. ​						安装 `squid` 软件包： 				

   ```none
   # dnf install squid
   ```

2. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								要配置 `basic_ldap_auth` 助手工具，请在 `/etc/squid/squid.conf` 顶部添加以下配置条目： 						

      ```none
      auth_param basic program /usr/lib64/squid/basic_ldap_auth -b "cn=users,cn=accounts,dc=example,dc=com" -D "uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com" -W /etc/squid/ldap_password -f "(&(objectClass=person)(uid=%s))" -ZZ -H ldap://ldap_server.example.com:389
      ```

      ​								下面描述了传递给上例中 `basic_ldap_auth` helper 工具的参数： 						

      - ​										`-b *base_DN*` 设置 LDAP 搜索基础。 								

      - ​										`-d *proxy_service_user_DN*` 设置帐户 Squid 的可分辨名称(DN)，用于在 目录中搜索用户身份验证。 								

      - ​										`-W *path_to_password_file*` 设置包含代理服务用户密码的文件的路径。使用密码文件可防止在操作系统的进程列表中看到密码。 								

      - ​										`-f *LDAP_filter*` 指定 LDAP 搜索过滤器。Squid 将 `%s` 变量替换为身份验证用户提供的用户名。 								

        ​										示例中的 `(&(objectClass=person)(uid=%s))` 过滤器定义用户名必须与 `uid` 属性中设置的值匹配，并且目录条目包含 `person` 对象类。 								

      - ​										`-ZZ` 使用 `STARTTLS` ，通过 LDAP 协议强制实施 TLS 加密连接。在以下情况下省略 `-ZZ` ： 								

        - ​												LDAP 服务器不支持加密的连接。 										
        - ​												URL 中指定的端口使用 LDAPS 协议。 										

      - ​										-H LDAP_URL 参数指定协议、主机名或 IP 地址以及 LDAP 服务器的端口，格式为 URL。 								

   2. ​								添加以下 ACL 和规则来配置 Squid 只允许经过身份验证的用户使用代理： 						

      ```none
      acl ldap-auth proxy_auth REQUIRED
      http_access allow ldap-auth
      ```

      重要

      ​									在 `http_access deny` 所有规则之前指定这些设置。 							

   3. ​								删除以下规则，以禁用从 `localnet` ACL 中指定的 IP 范围绕过代理身份验证： 						

      ```none
      http_access allow localnet
      ```

   4. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      ```none
      acl SSL_ports port port_number
      ```

   5. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了访问拒绝 `Safe_ports` ACL 中未定义的端口。 						

   6. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

3. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

4. ​						将 LDAP 服务用户的密码存储在 `/etc/squid/ldap_password` 文件中，并为该文件设置适当的权限： 				

   ```none
   # echo "password" > /etc/squid/ldap_password
   # chown root:squid /etc/squid/ldap_password
   # chmod 640 /etc/squid/ldap_password
   ```

5. ​						在防火墙中打开 `3128` 端口： 				

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

6. ​						启用并启动 `squid` 服务： 				

   ```none
   # systemctl enable --now squid
   ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			

```none
# curl -O -L "https://www.redhat.com/index.html" -x "user_name:password@proxy.example.com:3128"
```

​				如果 curl 没有显示任何错误，并且 `index.html` 文件可下载到当前目录中，那么代理工作正常。 		

**故障排除步骤**

​					验证 helper 工具是否正常工作： 			

1. ​						使用您在 `auth_param` 参数中使用的相同设置来手动启动助手工具： 				

   ```none
   # /usr/lib64/squid/basic_ldap_auth -b "cn=users,cn=accounts,dc=example,dc=com" -D "uid=proxy_user,cn=users,cn=accounts,dc=example,dc=com" -W /etc/squid/ldap_password -f "(&(objectClass=person)(uid=%s))" -ZZ -H ldap://ldap_server.example.com:389
   ```

2. ​						输入一个有效的用户名和密码，然后按 **Enter** 键： 				

   ```none
   user_name password
   ```

   ​						如果帮助程序返回 `OK`，则身份验证成功。 				

## 3.3. 将 Squid 设置为带有 kerberos 身份验证的缓存代理

​				这部分描述了 Squid 作为缓存代理的基本配置，它使用 Kerberos 向 Active Directory(AD)验证用户。此流程配置仅经过身份验证的用户可以使用代理。 		

**先决条件**

- ​						该流程假定 `/etc/squid/squid.conf` 文件是由 `squid` 软件包提供的。如果您在之前编辑了这个文件，请删除该文件并重新安装该软件包。 				
- ​						要安装 Squid 的服务器是 AD 域的成员。 				

**步骤**

1. ​						安装以下软件包： 				

   ```none
   dnf install squid krb5-workstation
   ```

2. ​						以 AD 域管理员身份进行身份验证： 				

   ```none
   # kinit administrator@AD.EXAMPLE.COM
   ```

3. ​						为 Squid 创建一个 keytab，并将其存储在 `/etc/squid/HTTP.keytab` 文件中： 				

   ```none
   # export KRB5_KTNAME=FILE:/etc/squid/HTTP.keytab
   # net ads keytab CREATE -U administrator
   ```

4. ​						在 keytab 中添加 `HTTP` 服务主体： 				

   ```none
   # net ads keytab ADD HTTP -U administrator
   ```

5. ​						将 keytab 文件的所有者设置为 `squid` 用户： 				

   ```none
   # chown squid /etc/squid/HTTP.keytab
   ```

6. ​						另外，验证 keytab 文件是否包含代理服务器的完全限定域名(FQDN)的 `HTTP` 服务主体： 				

   ```none
     klist -k /etc/squid/HTTP.keytab
   Keytab name: FILE:/etc/squid/HTTP.keytab
   KVNO Principal
   ---- ---------------------------------------------------
   ...
      2 HTTP/proxy.ad.example.com@AD.EXAMPLE.COM
   ...
   ```

7. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   1. ​								要配置 `negotiate_kerberos_auth` 助手工具，请在 `/etc/squid/squid.conf` 的顶部添加以下配置条目： 						

      ```none
      auth_param negotiate program /usr/lib64/squid/negotiate_kerberos_auth -k /etc/squid/HTTP.keytab -s HTTP/proxy.ad.example.com@AD.EXAMPLE.COM
      ```

      ​								下面描述了在上例中传给 `negotiate_kerberos_auth` 助手工具的参数： 						

      - ​										`-K *file*` 设置密钥选项卡文件的路径。请注意，squid 用户必须拥有这个文件的读取权限。 								

      - ​										`-s HTTP/*host_name*@*kerberos_realm*` 设置 Squid 使用的 Kerberos 主体。 								

        ​										另外，您可以通过将以下一个或多个参数传递给帮助程序来启用日志： 								

      - ​										`-i` 记录信息，如验证用户。 								

      - ​										`-d` 启用调试日志记录。 								

        ​										Squid 将助手工具中的调试信息记录到 `/var/log/squid/cache.log` 文件。 								

   2. ​								添加以下 ACL 和规则来配置 Squid 只允许经过身份验证的用户使用代理： 						

      ```none
      acl kerb-auth proxy_auth REQUIRED
      http_access allow kerb-auth
      ```

      重要

      ​									在`http_access deny all`之前指定这些设置。 							

   3. ​								删除以下规则，以禁用从 `localnet` ACL 中指定的 IP 范围绕过代理身份验证： 						

      ```none
      http_access allow localnet
      ```

   4. ​								以下 ACL 存在于默认配置中，并将 `443` 定义为使用 HTTPS 协议的端口： 						

      ```none
      acl SSL_ports port 443
      ```

      ​								如果用户也可以在其它端口上使用 HTTPS 协议，请为每个端口添加 ACL： 						

      ```none
      acl SSL_ports port port_number
      ```

   5. ​								更新 `acl Safe_ports` 规则列表，以配置 Squid 可以建立连接的端口。例如，若要配置使用代理的客户端只能访问端口 21(FTP)、80(HTTP)和 443(HTTPS)上的资源，在配置中仅保留以下 `acl Safe_ports` 语句： 						

      ```none
      acl Safe_ports port 21
      acl Safe_ports port 80
      acl Safe_ports port 443
      ```

      ​								默认情况下，配置中包含 `http_access deny !Safe_ports` 规则，该规则定义了拒绝访问`Safe_ports` ACL 中未定义的端口。 						

   6. ​								在 `cache_dir` 参数中配置缓存类型、缓存目录的路径、缓存大小以及其它缓存类型的设置： 						

      ```none
      cache_dir ufs /var/spool/squid 10000 16 256
      ```

      ​								使用这些设置： 						

      - ​										Squid使用 `ufs` 缓存类型. 								

      - ​										Squid 将其缓存存储在 `/var/spool/squid/` 目录中。 								

      - ​										缓存增长到 `10000` MB。 								

      - ​										Squid 在`/var/spool/squid/`目录中创建`16` 个一级子目录。 								

      - ​										Squid 在每个一级目录中创建 `256`个子目录。 								

        ​										如果您没有设置 `cache_dir` 指令，Squid 会将缓存存储在内存中。 								

8. ​						如果您在 `cache_dir` 参数中设置了与 `/var/spool/squid/` 不同的缓存目录： 				

   1. ​								创建缓存目录： 						

      ```none
      # mkdir -p path_to_cache_directory
      ```

   2. ​								配置缓存目录的权限： 						

      ```none
      # chown squid:squid path_to_cache_directory
      ```

   3. ​								如果您在 `enforcing` 模式中运行 SELinux，请为缓存目录设置 `squid_cache_t` 上下文： 						

      ```none
      # semanage fcontext -a -t squid_cache_t "path_to_cache_directory(/.*)?"
      # restorecon -Rv path_to_cache_directory
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

9. ​						在防火墙中打开 `3128` 端口： 				

   ```none
   # firewall-cmd --permanent --add-port=3128/tcp
   # firewall-cmd --reload
   ```

10. ​						启用并启动 `squid` 服务： 				

    ```none
    # systemctl enable --now squid
    ```

**验证步骤**

​					要验证代理是否正常工作，请使用 `curl` 工具下载网页： 			

```none
# curl -O -L "https://www.redhat.com/index.html" --proxy-negotiate -u : -x "proxy.ad.example.com:3128"
```

​				如果 `curl` 没有显示任何错误，并且 `index.html` 文件存在于当前目录中，那么代理工作正常。 		

**故障排除步骤**

​					手动测试 Kerberos 身份验证： 			

1. ​						为 AD 帐户获取 Kerberos ticket： 				

   ```none
   # kinit user@AD.EXAMPLE.COM
   ```

2. ​						显示 ticket（可选）： 				

   ```none
   # klist
   ```

3. ​						使用 `talk_kerberos_auth_test` 工具来测试身份验证： 				

   ```none
   # /usr/lib64/squid/negotiate_kerberos_auth_test proxy.ad.example.com
   ```

   ​						如果助手工具返回令牌，则身份验证成功： 				

   ```none
   Token: YIIFtAYGKwYBBQUCoIIFqDC...
   ```

## 3.4. 在 Squid 中配置域拒绝列表

​				通常,管理员想要阻止对特定域的访问。这部分论述了如何在 Squid 中配置域拒绝列表。 		

**先决条件**

- ​						squid 被配置，用户可以使用代理。 				

**步骤**

1. ​						编辑 `/etc/squid/squid.conf` 文件，并添加以下设置： 				

   ```none
   acl domain_deny_list dstdomain "/etc/squid/domain_deny_list.txt"
   http_access deny all domain_deny_list
   ```

   重要

   ​							在允许访问用户或客户端的第一个 `http_access allow` 语句前面添加这些条目。 					

2. ​						创建 `/etc/squid/domain_deny_list.txt` 文件，并添加您要阻止的域。例如，要阻止对包括子域的 `example.com` 的访问，并阻止对 `example.net` 的访问，请添加： 				

   ```none
   .example.com
   example.net
   ```

   重要

   ​							如果您在 squid 配置中引用了 `/etc/squid/domain_deny_list.txt` 文件，则此文件不能为空。如果文件为空，Squid 无法启动。 					

3. ​						重启 `squid` 服务： 				

   ```none
   # systemctl restart squid
   ```

## 3.5. 将 Squid 服务配置为监听特定端口或 IP 地址

​				默认情况下，Squid 代理服务监听所有网络接口上的 `3128` 端口。这部分论述了如何更改端口并配置 Squid 在特定 IP 地址中监听。 		

**先决条件**

- ​						`squid` 软件包已安装。 				

**步骤**

1. ​						编辑 `/etc/squid/squid.conf` 文件： 				

   - ​								要设置 Squid 服务监听的端口，请在 `http_port` 参数中设置端口号。例如，要将端口设置为 `8080`，请设置： 						

     ```none
     http_port 8080
     ```

   - ​								要配置 Squid 服务监听的 IP 地址，请在 `http_port` 参数中设置 IP 地址和端口号。例如，要配置 Squid 只监听 `192.0.2.1` IP 地址的 `3128` 端口，请设置： 						

     ```none
     http_port 192.0.2.1:3128
     ```

     ​								在配置文件中添加多个 `http_port` 参数，来配置 Squid 监听多个端口和 IP 地址： 						

     ```none
     http_port 192.0.2.1:3128
     http_port 192.0.2.1:8080
     ```

2. ​						如果您配置了 Squid 使用不同的端口作为默认值(`3128)`： 				

   1. ​								在防火墙中打开端口： 						

      ```none
      # firewall-cmd --permanent --add-port=port_number/tcp
      # firewall-cmd --reload
      ```

   2. ​								如果您在 enforcing 模式下运行 SELinux，请将端口分配给 `squid_port_t` 端口类型定义： 						

      ```none
      # semanage port -a -t squid_port_t -p tcp port_number
      ```

      ​								如果您的系统中没有 `semanage` 工具，请安装 `policycoreutils-python-utils` 软件包。 						

3. ​						重启 `squid` 服务： 				

   ```none
   # systemctl restart squid
   ```

## 3.6. 其他资源

- ​						有关您可以在`/etc/squid/squid/squid.conf.conf`文件中设置的所有配置参数的列表以及详细描述，请参阅`usr/share/doc/squid-<version>/squid.confdocumented`文件。 				