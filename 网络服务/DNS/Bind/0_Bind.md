# Bind

[TOC]

## 概述

Berkeley Internet Name Domain（BIND）软件为许多操作系统实现了域名服务器。最初是由加州大学伯克利分校开发出来的 BSD UNIX 4.3 中的一部分，目前由 ISC 组织进行维护和开发。

BIND 9 是开源软件，根据 MPL 2.0 许可证获得许可。

它完全符合互联网工程任务 Force (IETF) DNS 标准和草案标准。

配置 BIND9 的方法有很多种。一些最常见的配置包括缓存名称服务器、主服务器和辅助服务器。

- 当配置为缓存名称服务器时，BIND9 将找到名称查询的答案，并在再次查询域时记住答案。
- 区域的权威 DNS 服务器。作为主服务器，BIND9 从其主机上的文件中读取区域的数据，并且对该区域具有权威性。
- 作为辅助服务器，BIND9 从另一个对区域具有权威性的名称服务器获取区域数据。

## 配置文件

DNS 配置文件存储在 `/etc/bind` 目录中。不同的发行版，有所区别。



```bash
# Ubuntu														CentOS
/etc															/etc
  └── bind														  ├── named
       ├── bind.keys											  │    ├── 192.168.1.zone
       ├── db.0													  │    ├── 192.168.4.zone
       ├── db.127												  │    └── vhengdata.local.zone
       ├── db.255                                                 │
       ├── db.empty 											  │
       ├── db.local 											  │
       ├── named.conf											  ├── named.conf
       ├── named.conf.default-zones 							  │
       ├── named.conf.local 									  │
       ├── named.conf.options 									  │
       ├── rndc.key 											  │
       └── zones.rfc1918										  ├── named.rfc1912.zones
        														  └── named.root.key
```

主配置文件是 `/etc/bind/named.conf` ，在包提供的布局中，它只包含以下文件：

- **`/etc/bind/named.conf.options`** ：全局 DNS 选项
- **`/etc/bind/named.conf.local`** ：适用于您的区域
- **`/etc/bind/named.conf.default-zones`**: Default zones such as localhost, its reverse, and the root hints 默认区域，例如 localhost、其反向和 root 提示

根名称服务器曾经在 `/etc/bind/db.root` 文件中描述。现在，它由 `dns-root-data` 软件包附带的 `/usr/share/dns/root.hints` 文件提供，并在上面的 `named.conf.default-zones` 配置文件中引用。

It is possible to configure the same server to be a caching name server,  primary, and secondary: it all depends on the zones it is serving. A  server can be the Start of Authority (SOA) for one zone, while providing secondary service for another zone. All the while providing caching  services for hosts on the local LAN.
可以将同一服务器配置为缓存名称服务器、主服务器和辅助服务器：这完全取决于它所服务的区域。服务器可以是一个区域的授权启动点 （SOA），同时为另一个区域提供辅助服务。同时为本地LAN上的主机提供缓存服务。

## 缓存 DNS 服务器

默认情况下，BIND DNS 服务器解析和缓存成功或失败的查找。随后，服务会从其缓存中应答相同记录的请求。这可显著提高 DNS 查找速度。

1. 编辑 `/etc/named.conf` 文件，并在 `options` 语句中进行以下更改：

   ```ini
   # 更新 listen-on 和 listen-on-v6 语句，以指定 BIND 应该侦听的 IPv4 和 IPv6 接口。
   listen-on port 53 { 127.0.0.1; 192.0.2.1; };
   listen-on-v6 port 53 { ::1; 2001:db8:1::1; };
   
   # 更新 allow-query 语句，以配置哪些 IP 地址和范围客户端可以查询此 DNS 服务器。
   allow-query { localhost; 192.0.2.0/24; 2001:db8:1::/64; };
   
   # 添加 allow-recursion 语句，以定义 BIND 接受递归查询的 IP 地址和范围。
   allow-recursion { localhost; 192.0.2.0/24; 2001:db8:1::/64; };
   ```

   > 警告：
   >
   > 不要在服务器的公共 IP 地址中递归。否则，服务器可能会成为大规模 DNS 扩大攻击的一部分。

   默认情况下，BIND 通过将从根服务器递归查询到权威 DNS 服务器来解析查询。或者，您可以将 BIND 配置为将查询转发到其他 DNS 服务器，比如您的供应商之一。在这种情况下，添加一个带有 BIND 应该转发查询的 DNS 服务器的 IP 地址列表的 `forwarders` 语句：

   ```ini
   forwarders { 198.51.100.1; 203.0.113.5; };
   ```

   作为回退行为，如果转发器服务器没有响应，BIND 会以递归方式解析查询。要禁用此行为，请添加 `forward only;` 语句。

2. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```

   如果命令没有显示输出，则语法为正确的。

3. 更新 `firewalld` 规则，以允许传入的 DNS 流量：

   ```bash
   firewall-cmd --permanent --add-service=dns
   firewall-cmd --reload
   ```

4. 启动并启用 BIND：

   ```bash
   systemctl enable --now named
   ```

   如果要在 change-root 环境中运行 BIND，请使用 `systemctl enable --now named-chroot` 命令启用并启动该服务。

**验证**

1. 使用新设置 DNS 服务器解析域：

   ```bash
   dig @localhost www.example.org
   
   ...
   www.example.org.    86400    IN    A    198.51.100.34
   
   ;; Query time: 917 msec
   ...
   ```

   在第一次查询记录后，BIND 会将条目添加到其缓存中。

2. 重复前面的查询：

   ```bash
   dig @localhost www.example.org
   
   ...
   www.example.org.    85332    IN    A    198.51.100.34
   
   ;; Query time: 1 msec
   ...
   ```

   由于对条目进行了缓存，进一步对相同记录的请求会非常快，直到条目过期为止。 				

配置网络中的客户端来使用此 DNS 服务器。如果 DHCP 服务器向客户端提供 DNS 服务器设置，请相应地更新 DHCP 服务器的配置。

## 配置日志记录

默认 `/etc/named.conf` 文件中的配置（如 `bind` 软件包提供）使用 `default_debug` 通道，并将消息记录到 `/var/named/data/named.run` 文件中。`default_debug` 频道仅在服务器的 debug 级别为零时记录条目。

使用不同的频道和类别，可以将 BIND 配置为将具有定义的严重性的不同事件写入单独的文件。

1. 编辑 `/etc/named.conf` 文件，并将 `category` 和 `channel` 添加到 `logging` 语句中，例如：

   ```ini
   logging {
       ...
   
       category notify { zone_transfer_log; };
       category xfer-in { zone_transfer_log; };
       category xfer-out { zone_transfer_log; };
       channel zone_transfer_log {
           file "/var/named/log/transfer.log" versions 10 size 50m;
           print-time yes;
           print-category yes;
           print-severity yes;
           severity info;
        };
   
        ...
   };
   ```

   使用这个示例配置，BIND 会记录与区域传送相关的消息，到 `/var/named/log/transfer.log`。BIND 创建最多 `10` 个日志文件版本，如果它们达到 `50` MB 的最大大小，则轮转它们。

   `category` 定义了 BIND 向哪些频道发送类别信息。

   `channel` 定义了日志消息的目的地，包括版本数量、最大文件大小以及 BIND 应记录到频道的严重性等级。其他设置（如启用日志的时间戳、类别和严重性）是可选的，但可用于调试目的。

2. 如果不存在，创建日志目录，并为 `named` 用户授予对这个目录的写权限：

   ```bash
   mkdir /var/named/log/
   chown named:named /var/named/log/
   chmod 700 /var/named/log/
   ```

3. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```

   如果命令没有显示输出，则语法为正确的。

4. 重启 BIND：

   ```bash
   systemctl restart named
   ```

   如果在 change-root 环境中运行 BIND，请使用 `systemctl restart named-chroot` 命令来重启该服务。

**验证**

- 显示日志文件的内容：

  ```bash
  cat /var/named/log/transfer.log
  
  ...
  06-Jul-2022 15:08:51.261 xfer-out: info: client @0x7fecbc0b0700 192.0.2.2#36121/key example-transfer-key (example.com): transfer of 'example.com/IN': AXFR started: TSIG example-transfer-key (serial 2022070603)
  06-Jul-2022 15:08:51.261 xfer-out: info: client @0x7fecbc0b0700 192.0.2.2#36121/key example-transfer-key (example.com): transfer of 'example.com/IN': AXFR ended
  ```

## 编写 BIND ACL

控制 BIND 的某些功能的访问可以防止未经授权的访问和攻击，如拒绝服务 (DoS)。BIND 访问控制列表 (`acl`) 语句是 IP 地址和范围的列表。每个 ACL 都有一个别名，可以在几个语句中使用，如 `allow-query` 来引用指定的 IP 地址和范围。

> 警告：
>
> BIND 仅在 ACL 中使用第一个匹配条目。例如，如果您定义了 ACL `{ 192.0.2/24; !192.0.2.1; }` 以及带有 `192.0.2.1` IP 地址的主机的连接，即使第二个条目排除这个地址，也会授予访问权限。

BIND 有以下内置 ACL：

- `none`：不匹配主机。
- `any`: 匹配所有主机。
- `localhost` ：匹配回环地址 `127.0.0.1` 和 `::1`，以及服务器上运行 BIND 的服务器上的所有接口的 IP 地址。
- `localnets` ：匹配回环地址 `127.0.0.1` 和 `::1`，以及运行 BIND 的服务器都直接连接到的所有子网。

1. 编辑 `/etc/named.conf` 文件并进行以下更改：

   1. 将 `acl` 语句添加到文件中。例如，要为 `127.0.0.1`、`192.0.2.0/24` 和 `2001:db8:1::/64` 创建名为 `internal-networks` 的 ACL，请输入：

      ```ini
      acl internal-networks { 127.0.0.1; 192.0.2.0/24; 2001:db8:1::/64; };
      acl dmz-networks { 198.51.100.0/24; 2001:db8:2::/64; };
      ```
      
   2. 在支持它们的声明中使用 ACL 的别名，例如：

      ```ini
      allow-query { internal-networks; dmz-networks; };
      allow-recursion { internal-networks; };
      ```
   
2. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```
   
3. 重新载入 BIND：

   ```bash
   systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

**验证**

- 执行操作，以触发使用配置的 ACL 的功能。例如，此流程中的 ACL 只允许来自定义的 IP 地址的递归查询。在这种情况下，在不属于 ACL 定义的主机上输入以下命令来尝试解析外部域：

  ```bash
  dig +short @192.0.2.1 www.example.com
  ```
  
  如果命令没有返回任何输出，BIND 拒绝访问，且 ACL 可以正常工作。有关客户端的详细输出，请使用不带 `+short` 选项的命令：

  ```bash
  dig @192.0.2.1 www.example.com
  
  ...
  ;; WARNING: recursion requested but not available
  ...
  ```

## 配置区

DNS 区域是包含域空间中特定子树的资源记录的数据库。例如，如果您负责 `example.com` 域，可以在 BIND 中为它设置一个区。因此，客户端可将 `www.example.com` 解析为在这个区中配置的 IP 地址。

### 区域文件中的 SOA 记录

SOA（start of authority）记录在一个 DNS 区中是必必需的记录。例如，如果多个 DNS 服务器对某个区域具有权威，那么此记录非常重要，但也指向 DNS 解析器。

BIND 中的 SOA 记录具有以下语法：

```ini
name class type mname rname serial refresh retry expire minimum
```

为提高可读性，管理员通常将区域文件中的记录分成多行，其中包含以分号(`;`)开头的注释。请注意，如果您分割 SOA 记录，圆括号将记录保留在一起：

```ini
@ IN SOA ns1.example.com. hostmaster.example.com. (
                          2022070601 ; serial number
                          1d         ; refresh period
                          3h         ; retry period
                          3d         ; expire time
                          3h )       ; minimum TTL
```

> 重要：
>
> 注意完全限定域名 (FQDN) 末尾的结尾点。FQDN 包含多个域标签，它们用点分开。由于 DNS root 有一个空标签，所以 FQDN 以点结尾。因此，BIND 在没有结尾点的情况下将区域名称附加到名称中。不含尾部点的主机名（例如 `ns1.example.com`）会被扩展为 `ns1.example.com.example.com.`，对于主域名服务器，这不是正确的地址。

以下是 SOA 记录中的字段：

- `name` ：区域的名称，即所谓的 `源（origin）`。如果将此字段设置为 `@`，BIND 会将其扩展为 `/etc/named.conf` 中定义的区域名称。
- `class` ：在 SOA 记录中，必须将此字段始终设置为 Internet (`IN`) 。
- `type` ：在 SOA 记录中，必须将此字段始终设置为 `SOA` 。
- `mname` （主名称）：此区域的主域名服务器的主机名。
- `rname` (负责名称): 负责此区域的电子邮件地址。请注意，格式不同。您必须将 at 符号 (`@`) 替换为点 (`.`)。
- `serial` ：此区域文件的版本号。次要域名服务器仅在主服务器上的序列号较高时更新其区域副本。格式可以是任意数字值。通常的格式是 `<year><month><day><two-digit-number>`。使用这种格式，在理论上可以每天修改区域文件上百次。
- `refresh`：在检查主服务器更新时，次要服务器应等待的时间。
- `retry` ：当次要服务器在尝试失败后重试查询主服务器的时间长度。
- `expire` ：当所有之前的尝试失败时，次要服务器停止查询主服务器的时间长度。
- `minimum` ：RFC 2308 将此字段的含义改为负缓存时间。兼容解析器使用它来确定缓存 `NXDOMAIN` 名称错误的时间。 					

> 注意：
>
> `refresh`, `retry`, `expire`, 和 `minimum` 项中的值定义了一个时间（以秒为单位）。但是，为了提高可读性，请使用时间后缀，如 `m` 表示分钟、`h` 表示小时，以及 `d` 表示天。例如，`3h` 代表 3 小时。

### 在主服务器上设置转发区

转发区域将名称映射到 IP 地址和其他信息。例如，如果您负责域 `example.com`，您可以在 BIND 中设置转发区来解析名称，如 `www.example.com`。

1. 在 `/etc/named.conf` 文件中添加区定义：

   ```ini
   zone "example.com" {
       type master;
       file "example.com.zone";
       allow-query { any; };
       allow-transfer { none; };
   };
   ```
   
   这些设置定义：

   - 此服务器作为 `example.com` 区域的主服务器 (`type master`)。
   - `/var/named/example.com.zone` 文件是区域文件。如果您设置了相对路径，如本例中所示，这个路径相对于您在 `options` 语句中的目录中创建的 `directory` 相对。
   - 任何主机都可以查询此区域。另外，还可指定 IP 范围或 BIND 访问控制列表 (ACL) 别名来限制访问。
   - 没有主机可以传输区域。仅在设置次要服务器并且仅为次要服务器的 IP 地址时才允许区域传送。			
   
2. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```
   
3. 使用以下内容创建 `/var/named/example.com.zone` 文件：

   ```ini
   $TTL 8h
   @ IN SOA ns1.example.com. hostmaster.example.com. (
                             2022070601 ; serial number
                             1d         ; refresh period
                             3h         ; retry period
                             3d         ; expire time
                             3h )       ; minimum TTL
   
                     IN NS   ns1.example.com.
                     IN MX   10 mail.example.com.
   
   www               IN A    192.0.2.30
   www               IN AAAA 2001:db8:1::30
   ns1               IN A    192.0.2.1
   ns1               IN AAAA 2001:db8:1::1
   mail              IN A    192.0.2.20
   mail              IN AAAA 2001:db8:1::20
   ```
   
   这个区域文件：

   - 将资源记录的默认生存时间 (TTL) 值设置为 8 小时。如果没有时间后缀（例如没有使用 `h` 指定小时），BIND 会将该值解析为秒。
   - 包含所需的 SOA 资源记录，以及有关该区域的详细信息。
   - 将 `ns1.example.com` 设置为此区域的权威 DNS 服务器。要正常工作，区域需要至少一个域名服务器 (`NS`) 记录。但是，若要与 RFC 1912 兼容，您需要至少有两个域名服务器。
   - 将 `mail.example.com` 设置为 `example.com` 域的邮件交换器 (`MX`)。主机名前面的数字值是记录的优先级。较低值的条目具有更高的优先级。
   - 设置 `www.example.com` 的 IPv4 和 IPv6 地址、`mail.example.com` 和 `ns1.example.com`。
   
4. 在区域文件上设置安全权限，仅允许 `named` 组读取它：

   ```bash
   chown root:named /var/named/example.com.zone
   chmod 640 /var/named/example.com.zone
   ```
   
5. 验证 `/var/named/example.com.zone` 文件的语法：

   ```bash
   named-checkzone example.com /var/named/example.com.zone
   
   zone example.com/IN: loaded serial 2022070601
   OK
   ```
   
6. 重新载入 BIND：

   ```bash
   systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

**验证**

- 从 `example.com` 区域查询不同的记录，并验证输出是否与您在区域文件中配置的记录匹配：

  ```bash
  dig +short @localhost AAAA www.example.com
  2001:db8:1::30
  
  dig +short @localhost NS example.com
  ns1.example.com.
  
  dig +short @localhost A ns1.example.com
  192.0.2.1
  ```
  
  本例假定 BIND 在同一主机上运行并响应 `localhost` 接口上的查询。

### 在主服务器中设置反向区

反向区域将 IP 地址映射到名称。例如，如果您负责 IP 范围 `192.0.2.0/24`，您可以在 BIND 中设置反向区域，以将 IP 地址从这个范围内的 IP 地址解析为主机名。

> 注意：
>
> 如果您为整个类网络创建一个反向区域，请相应地命名区域。例如，对于 C network `192.0.2.0/24`，区域的名称是 `2.0.192.in-addr.arpa`。如果您想为不同的网络大小创建反向区域，例如 `190.0.2.0/28`，区的名称为 `28-2.0.192.in-addr.arpa`。

1. 在 `/etc/named.conf` 文件中添加区定义：

   ```ini
   zone "2.0.192.in-addr.arpa" {
       type master;
       file "2.0.192.in-addr.arpa.zone";
       allow-query { any; };
       allow-transfer { none; };
   };
   ```
   
   这些设置定义：

   - 此服务器作为 `2.0.192.in-addr.arpa` 反向区域的主服务器(`type master`)。
   - `/var/named/2.0.192.in-addr.arpa.zone` 文件是区域文件。如果您设置了相对路径，如本例中所示，这个路径相对于您在 `options` 语句中的目录中创建的 `directory` 相对。
   - 任何主机都可以查询此区域。另外，还可指定 IP 范围或 BIND 访问控制列表 (ACL) 别名来限制访问。
   - 没有主机可以传输区域。仅在设置次要服务器并且仅为次要服务器的 IP 地址时才允许区域传送。
   
2. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```
   
3. 使用以下内容创建 `/var/named/2.0.192.in-addr.arpa.zone` 文件：

   ```bash
   $TTL 8h
   @ IN SOA ns1.example.com. hostmaster.example.com. (
                             2022070601 ; serial number
                             1d         ; refresh period
                             3h         ; retry period
                             3d         ; expire time
                             3h )       ; minimum TTL
   
                     IN NS   ns1.example.com.
   
   1                 IN PTR  ns1.example.com.
   30                IN PTR  www.example.com.
   ```
   
   这个区域文件：

   - 将资源记录的默认生存时间 (TTL) 值设置为 8 小时。如果没有时间后缀（例如没有使用 `h` 指定小时），BIND 会将该值解析为秒。
   - 包含所需的 SOA 资源记录，以及有关该区域的详细信息。
   - 将 `ns1.example.com` 设置为此反向区域的权威 DNS 服务器。要正常工作，区域需要至少一个域名服务器 (`NS`) 记录。但是，若要与 RFC 1912 兼容，您需要至少有两个域名服务器。
   - 设置 `192.0.2.1` 和 `192.0.2.30` 地址的指针(`PTR`)记录。 							
   
4. 在区域文件上设置安全权限，仅允许 `named` 组读取它：

   ```bash
   chown root:named /var/named/2.0.192.in-addr.arpa.zone
   chmod 640 /var/named/2.0.192.in-addr.arpa.zone
   ```
   
5. 验证 `/var/named/2.0.192.in-addr.arpa.zone` 文件的语法：

   ```bash
   named-checkzone 2.0.192.in-addr.arpa /var/named/2.0.192.in-addr.arpa.zone
   
   zone 2.0.192.in-addr.arpa/IN: loaded serial 2022070601
   OK
   ```
   
6. 重新载入 BIND：

   ```bash
   systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

**验证**

- 从反向区查询不同的记录，并验证输出是否与您在区域文件中配置的记录匹配：

  ```bash
  dig +short @localhost -x 192.0.2.1
  ns1.example.com.
  
  dig +short @localhost -x 192.0.2.30
  www.example.com.
  ```
  
  本例假定 BIND 在同一主机上运行并响应 `localhost` 接口上的查询。

### 更新 BIND 区文件

在某些情况下，例如，如果服务器的 IP 地址有变化，您必须更新区域文件。如果多个 DNS 服务器负责某个区，则仅在主服务器中执行这个步骤。存储区域副本的其他 DNS 服务器将通过区域传送接收更新。

1. 可选：识别 `/etc/named.conf` 文件中的区文件的路径：

   ```bash
options {
       ...
       directory       "/var/named";
   }
   
   zone "example.com" {
       ...
       file "example.com.zone";
   };
   ```
   
   可以在区域定义的 `file` 指令中找到到区域文件的路径。相对路径相对于 `options` 语句中的 `directory` 设置的相对路径。

2. 编辑区域文件：

   1. 进行必要的更改。

   2. 在 SOA 记录中递增序列号。 							

      > 重要：
   >
      > 如果序列号等于或低于先前值，次要服务器不会更新其区域的副本。 								

3. 验证区文件的语法：

   ```bash
   named-checkzone example.com /var/named/example.com.zone
   
   zone example.com/IN: loaded serial 2022062802
   OK
   ```
   
4. 重新载入 BIND：

   ```bash
   systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

**验证**

- 查询您添加、修改或删除的记录，例如：

  ```bash
  # dig +short @localhost A ns2.example.com
  192.0.2.2
  ```
  
  本例假定 BIND 在同一主机上运行并响应 `localhost` 接口上的查询。		

### 使用自动密钥生成和区维护功能进行 DNSSEC 区域签名

可以使用域名系统安全扩展 (DNSSEC) 为区域签名，以确保身份验证和数据完整性。此类区域包含额外的资源记录。客户端可以使用它们来验证区域信息的真实性。

如果您为区启用 DNSSEC 策略功能，BIND 会自动执行以下操作：

- 创建密钥。
- 为区域签名。
- 维护区域，包括重新签名并定期替换密钥。

> 重要：
>
> 要启用外部 DNS 服务器以验证区的真实性，您必须在父区中添加该区域的公钥。请联系您的域供应商或 registry，以了解更多有关如何完成此操作的详细信息。

此流程使用 BIND 中的内置 `default` DNSSEC 策略。这个策略使用单一 `ECDSAP256SHA` 密钥签名。另外，还可创建自己的策略来使用自定义密钥、算法和计时。

**前提条件**

- 服务器可将时间与时间服务器同步。对于 DNSSEC 验证，系统时间准确非常重要。

1. 编辑 `/etc/named.conf` 文件，并将 `dnssec-policy default;` 添加到您要启用 DNSSEC 的区域：

   ```ini
   zone "example.com" {
       ...
       dnssec-policy default;
   };
   ```
   
2. 重新载入 BIND：

   ```bash
systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

3. BIND 将公钥存储在 `/var/named/K*<zone_name>*.+*<algorithm>*+*<key_ID>*.key` 文件中。使用此文件显示区的公钥，格式为父区所需的格式：

   - DS 记录格式：

     ```bash
     dnssec-dsfromkey /var/named/Kexample.com.+013+61141.key
     
     example.com. IN DS 61141 13 2 3E184188CF6D2521EDFDC3F07CFEE8D0195AACBD85E68BAE0620F638B4B1B027
     ```
     
   - DNSKEY 格式：
   
     ```bash
     grep DNSKEY /var/named/Kexample.com.+013+61141.key
     
     example.com. 3600 IN DNSKEY 257 3 13 sjzT3jNEp120aSO4mPEHHSkReHUf7AABNnT8hNRTzD5cKMQSjDJin2I3 5CaKVcWO1pm+HltxUEt+X9dfp8OZkg==
     ```
   
4. 请求将区域的公钥添加到父区。请联系您的域供应商或 registry，以了解更多有关如何完成此操作的详细信息。

**验证**

1. 从启用了 DNSSEC 签名的区域查询您自己的 DNS 服务器：

   ```bash
   dig +dnssec +short @localhost A www.example.com
   
   192.0.2.30
   A 13 3 28800 20220718081258 20220705120353 61141 example.com. e7Cfh6GuOBMAWsgsHSVTPh+JJSOI/Y6zctzIuqIU1JqEgOOAfL/Qz474 M0sgi54m1Kmnr2ANBKJN9uvOs5eXYw==
   ```
   
   本例假定 BIND 在同一主机上运行并响应 `localhost` 接口上的查询。
   
2. 在将公钥添加到父区并传播到其他服务器后，验证服务器是否将查询上的身份验证数据(`ad`)标记设置为已签名区域：

   ```bash
   dig @localhost example.com +dnssec
   
   ...
   ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
   ...
   ```

## 在服务器中配置区传输

区域传送可确保所有具有区域副本的 DNS 服务器均使用最新数据。

1. 在现有主服务器中：

   1. 创建一个共享密钥，并将其附加到 `/etc/named.conf` 文件中：

      ```bash
      tsig-keygen example-transfer-key | tee -a /etc/named.conf
      
      key "example-transfer-key" {
              algorithm hmac-sha256;
              secret "q7ANbnyliDMuvWgnKOxMLi313JGcTZB5ydMW5CyUGXQ=";
      };
      ```
      
      这个命令显示 `tsig-keygen` 命令的输出，并自动将其附加到 `/etc/named.conf` 中。稍后，在次要服务器上，您还需要命令的输出。
      
   2. 编辑 `/etc/named.conf` 文件中的区定义：
   
      1. 在 `allow-transfer` 语句中，定义服务器必须提供 `example-transfer-key` 语句中指定的密钥来传输区：
   
         ```ini
      zone "example.com" {
             ...
             allow-transfer { key example-transfer-key; };
         };
         ```
         
         另外，在 `allow-transfer` 语句中使用 BIND 访问控制列表 (ACL) 别名。
   
      2. 默认情况下，在更新区域后，BIND 会通知所有在区中有名称服务器 (`NS`) 记录的域名服务器。如果您不计划为二级服务器添加 `NS` 记录，您可以配置 BIND 通知这个服务器。为此，请将这个次要服务器的 IP 地址添加 `also-notify` 声明到区：
   
         ```ini
         zone "example.com" {
             ...
             also-notify { 192.0.2.2; 2001:db8:1::2; };
         };
         ```
      
   3. 验证 `/etc/named.conf` 文件的语法：
   
      ```bash
      named-checkconf
      ```
      
   4. 重新载入 BIND：
   
      ```bash
      systemctl reload named
      ```
      
      如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。
   
2. 在未来的次要服务器中：

   1. 按如下方式编辑 `/etc/named.conf` 文件：

      1. 添加与主服务器相同的密钥定义：

         ```ini
         key "example-transfer-key" {
                 algorithm hmac-sha256;
                 secret "q7ANbnyliDMuvWgnKOxMLi313JGcTZB5ydMW5CyUGXQ=";
         };
         ```
         
      2. 在 `/etc/named.conf` 文件中添加区定义：

         ```ini
         zone "example.com" {
             type slave;
          file "slaves/example.com.zone";
             allow-query { any; };
             allow-transfer { none; };
             masters {
               192.0.2.1 key example-transfer-key;
               2001:db8:1::1 key example-transfer-key;
             };
         };
         ```
         
         这些设置状态：
      
         - 此服务器是 `example.com` 区域的次要服务器 (`type slave`)。
         - `/var/named/slaves/example.com.zone` 文件是区域文件。如果您设置了相对路径，如本例中所示，这个路径相对于您在 `options` 语句中的目录中创建的 `directory` 相对。要隔离此服务器从属的区域文件，您可以将它们存储在 `/var/named/slaves/` 目录中。
         - 任何主机都可以查询此区域。另外，还可指定 IP 范围或 ACL 别名来限制访问。
         - 没有主机可以从该服务器传输区域。
         - 此区域的主服务器的 IP 地址是 `192.0.2.1` 和 `2001:db8:1::2`。或者，您可以指定 ACL 别名。此次要服务器将使用名为 `example-transfer-key` 的键向主服务器进行身份验证。
      
   2. 验证 `/etc/named.conf` 文件的语法：
   
      ```bash
   named-checkconf
      ```
   
   3. 重新载入 BIND：

      ```bash
      systemctl reload named
      ```
   
      如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

3. 可选：修改主服务器上的区域文件，并为新的次要服务器添加一个 `NS` 记录。

**验证**

在次要服务器中： 			

1. 显示 `named` 服务的 `systemd` 日志条目：

   ```bash
   journalctl -u named
   
   ...
   Jul 06 15:08:51 ns2.example.com named[2024]: zone example.com/IN: Transfer started.
   Jul 06 15:08:51 ns2.example.com named[2024]: transfer of 'example.com/IN' from 192.0.2.1#53: connected using 192.0.2.2#45803
   Jul 06 15:08:51 ns2.example.com named[2024]: zone example.com/IN: transferred serial 2022070101
   Jul 06 15:08:51 ns2.example.com named[2024]: transfer of 'example.com/IN' from 192.0.2.1#53: Transfer status: success
   Jul 06 15:08:51 ns2.example.com named[2024]: transfer of 'example.com/IN' from 192.0.2.1#53: Transfer completed: 1 messages, 29 records, 2002 bytes, 0.003 secs (667333 bytes/sec)
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `journalctl -u named-chroot` 命令显示日志条目。
   
2. 验证 BIND 创建了区域文件：

   ```bash
   ls -l /var/named/slaves/
   
   total 4
   -rw-r--r--. 1 named named 2736 Jul  6 15:08 example.com.zone
   ```
   
   请注意，默认情况下，次要服务器以二进制原始格式存储区域文件。
   
3. 从次要服务器查询传输的区的记录：

   ```bash
   dig +short @192.0.2.2 AAAA www.example.com
   
   2001:db8:1::30
   ```
   

本例假定您在此流程中设置的次要服务器侦听 IP 地址 `192.0.2.2`。

## 配置响应策略区以覆盖 DNS 记录

使用 DNS 块和过滤，管理员可以重写 DNS 响应来阻止对某些域或主机的访问。在 BIND 中，响应策略区域 (RPZ) 提供此功能。您可以为受阻条目配置不同的操作，如返回 `NXDOMAIN` 错误或不响应查询。

如果您的环境中有多个 DNS 服务器，请使用此流程在主服务器上配置 RPZ，稍后配置区传输以在您的次要服务器上提供 RPZ。

1. 编辑 `/etc/named.conf` 文件并进行以下更改： 				

   1. 在 `options` 语句中添加 `response-policy` 定义：

      ```ini
   options {
          ...
      
          response-policy {
              zone "rpz.local";
          };
      
          ...
      }
      ```
      
      可以在 `response-policy` 的 `zone` 语句中为 RPZ 设置自定义名称。但是，在下一步中，您必须在区定义中使用相同的名称。

   2. 为在上一步中设置的 RPZ 添加 `zone` 定义：

      ```ini
      zone "rpz.local" {
          type master;
          file "rpz.local";
          allow-query { localhost; 192.0.2.0/24; 2001:db8:1::/64; };
          allow-transfer { none; };
      };
      ```
      
      这些设置状态：
   
      - 此服务器是名为 `rpz.local` 的 RPZ 的主服务器 (`type master`)。
      - `/var/named/rpz.local` 文件是区域文件。如果您设置了相对路径，如本例中所示，这个路径相对于您在 `options` 语句中的目录中创建的 `directory` 相对。
      - `allow-query` 中定义的任何主机都可以查询此 RPZ。另外，还可指定 IP 范围或 BIND 访问控制列表 (ACL) 别名来限制访问。
      - 没有主机可以传输区域。仅在设置次要服务器并且仅为次要服务器的 IP 地址时才允许区域传送。
   
2. 验证 `/etc/named.conf` 文件的语法：

   ```bash
   named-checkconf
   ```
   
3. 使用以下内容创建 `/var/named/rpz.local` 文件，例如：

   ```bash
   $TTL 10m
   @ IN SOA ns1.example.com. hostmaster.example.com. (
                             2022070601 ; serial number
                             1h         ; refresh period
                             1m         ; retry period
                             3d         ; expire time
                             1m )       ; minimum TTL
   
                    IN NS    ns1.example.com.
   
   example.org      IN CNAME .
   *.example.org    IN CNAME .
   example.net      IN CNAME rpz-drop.
   *.example.net    IN CNAME rpz-drop.
   ```
   
   这个区域文件：

   - 将资源记录的默认生存时间 (TTL) 值设置为 10 分钟。如果没有时间后缀（例如没有使用 `h` 指定小时），BIND 会将该值解析为秒。
   - 包含所需的 SOA 资源记录，以及有关该区域的详细信息。
   - 将 `ns1.example.com` 设置为此区域的权威 DNS 服务器。要正常工作，区域需要至少一个域名服务器 (`NS`) 记录。但是，若要与 RFC 1912 兼容，您需要至少有两个域名服务器。 						
   - 将查询的 `NXDOMAIN` 错误返回给该域中的 `example.org` 和主机。
   - 将查询丢弃至此域中的 `example.net` 和主机。	
   
4. 验证 `/var/named/rpz.local` 文件的语法：

   ```bash
   named-checkzone rpz.local /var/named/rpz.local
   
   zone rpz.local/IN: loaded serial 2022070601
   OK
   ```
   
5. 重新载入 BIND

   ```bash
   systemctl reload named
   ```
   
   如果在 change-root 环境中运行 BIND，请使用 `systemctl reload named-chroot` 命令来重新加载该服务。

**验证**

1. 尝试解析 `example.org` 中的主机，该主机在 RPZ 中配置，以返回 `NXDOMAIN` 错误：

   ```bash
   dig @localhost www.example.org
   
   ...
   ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 30286
   ...
   ```
   
   本例假定 BIND 在同一主机上运行并响应 `localhost` 接口上的查询。
   
2. 尝试解析 `example.net` 域中的主机，该域在 RPZ 中配置以丢弃查询：

   ```bash
   dig @localhost www.example.net
   
   ...
   ;; connection timed out; no servers could be reached
   ...	
   ```

## 保护 BIND

要保护 BIND 安装，可以：

- 运行 `named` 而不需要 change-root 环境。在这种情况下，`enforcing` 模式中的 SELinux 会阻止利用已知的 BIND 安全漏洞。默认情况下，Red Hat Enterprise Linux 在 `enforcing` 模式中使用 SELinux。

  > 重要：
  >
  > 在 SELinux 处于 `enforcing` 模式的 RHEL 上运行 BIND 比在 change-root 环境中运行 BIND 更安全。 					
- 在 change-root 环境中运行 `named-chroot` 服务。

  利用 change-root 功能，管理员可以定义进程的根目录及其子进程与 `/` 目录不同。当您启动 `named-chroot` 服务时，BIND 将其根目录切换到 `/var/named/chroot/`。因此，服务使用 `mount --bind` 命令使 `/etc/named-chroot.files` 中列出的文件和目录保存在 `/var/named/chroot/` 中，并且进程无法访问 `/var/named/chroot/` 以外的文件。



BIND 9 is a complete implementation of the DNS protocol. BIND 9 can be configured (using its `named.conf` file) as an authoritative name server, a resolver, and, on supported hosts, a stub resolver. While large operators usually dedicate DNS servers to a single function per system, smaller operators will find that BIND 9’s flexible configuration features support multiple functions, such as a single DNS server acting as both an authoritative name server and a resolver.

Example configurations of basic [authoritative name servers](https://bind9.readthedocs.io/en/latest/chapter3.html#config-auth-samples) and [resolvers and forwarding resolvers](https://bind9.readthedocs.io/en/latest/chapter3.html#config-resolver-samples), as well as [advanced configurations](https://bind9.readthedocs.io/en/latest/chapter6.html#advanced) and [secure configurations](https://bind9.readthedocs.io/en/latest/chapter7.html#security), are provided.

BIND9是DNS协议的完整实现。BIND9可以配置（使用其named.conf文件）为权威名称服务器、解析器，在支持的主机上，还可以配置为存根解析器。虽然大型运营商通常将DNS服务器专用于每个系统的单个功能，但小型运营商会发现BIND9的灵活配置特性支持多种功能，例如单个DNS服务器同时充当权威名称服务器和解析器。

提供了基本权威名称服务器、解析器和转发解析器的示例配置，以及高级配置和安全配置。

## BIND Uses on the Internet

#### Almost every Internet connection starts with a DNS lookup

Before your mail server sends an email, before  your web browser displays a web page, there is a DNS lookup to resolve a DNS name to an IP address. Watch this [DNS Fundamentals presentation](https://www.youtube.com/watch?v=oeceM-R8DVU&feature=emb_logo) from Eddy Winstead of ISC or read [A Warm Welcome to DNS](https://powerdns.org/hello-dns/) by Bert Hubert of PowerDNS.



#### BIND 9 on the Internet

BIND is used successfully for every application  from publishing the (DNSSEC-signed) DNS root zone and many top-level  domains, to hosting providers who publish very large zone files with  many small zones, to enterprises with both internal (private) and  external zones, to service providers with large resolver farms.

BIND在Internet上的使用

几乎每个Internet连接都以DNS查找开始

在邮件服务器发送电子邮件之前，在web浏览器显示网页之前，会进行DNS查找以将DNS名称解析为IP地址。观看ISC的Eddy Winstead的DNS基础演示，或阅读Power DNS的Bert Hubert的《热烈欢迎使用DNS》。

Internet上的BIND 9

BIND成功地用于每一个应用程序，从发布（DNSSEC签名）DNS根区域和许多顶级域，到发布具有许多小区域的非常大的区域文件的托管提供商，到具有内部（私有）和外部区域的企业，再到具有大型解析器场的服务提供商。

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#prerequisites-and-assumptions)

- A server running Rocky Linux
- Several internal servers that need to be accessed only locally, but not over the Internet
- Several workstations that need access to these same servers that exist on the same network
- A healthy comfort level with entering commands from command line
- Familarity with a command line editor (we are using *vi* in this example)
- Able to use either *firewalld* or *iptables* for creating firewall rules (we are using *iptables* here. If you would like to use *iptables* as well, use the [Enabling Iptables Firewall procedure](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/))

## Introduction[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#introduction)

External, or public, DNS servers are used on the Internet to map host names to IP addresses and, in the case of PTR (known as "pointer" or  "reverse") records, to map the IP to the host name. This is an essential part of the Internet. It makes your mail server, web server, FTP  server, or many other servers and services work as expected no matter  where you are.

On a private network, particularly one that is being used for  developing multiple systems, you can use your Rocky Linux workstation's */etc/hosts* file to map a name to an IP address.

This will work for *your* workstation, but not for any other  machine on your network. If you want to make things universally applied, then the best method is to take some time out and create a local,  private DNS server to handle this for all of your machines.

If you were creating production-level public DNS servers and  resolvers, then this author would probably recommend the more robust [PowerDNS](https://www.powerdns.com/) authoritative and recursive DNS, which is easily installed on Rocky  Linux servers. However, that is simply overkill for a local network that won't be exposing its DNS servers to the outside world. That is why we  have chosen *bind* for this example.

### The DNS Server Components Explained[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#the-dns-server-components-explained)

As stated, DNS separates services into authoritative and recursive  servers. These services are now recommended to be separate from each  other on separate hardware or containers.

The authoritative server is the storage area for all IP addresses and host names, and the recursive server is used to lookup addresses and  host names. In the case of our private DNS server, both the  authoritative and the recursive server services will run together.

## Installing and Enabling Bind[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#installing-and-enabling-bind)

The first step is to install packages. In the case of *bind* we need to execute the following command:

```
dnf install bind bind-utils
```

The service daemon for *bind* is called *named*, and we need to enable this to start on boot:

```
systemctl enable named
```

And then we need to start it:

```
systemctl start named
```

## Configuration[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#configuration)

Before making changes to any configuration file, it is a good idea to make a backup copy of the original installed working file, in this case *named.conf*:

```
cp /etc/named.conf /etc/named.conf.orig
```

That will help in the future if errors are introduced into the configuration file. It is *always* a good idea to make a backup copy before making changes.

These changes require us to edit the named.conf file, to do this, we are using *vi*, but you can substitute your favorite command line editor (the editor `nano` is also installed in Rocky Linux and is easier to use than `vi`):

```
vi /etc/named.conf
```

First thing we want to do is turn off listening on the localhost,  this is done by remarking out with a "#" sign, these two lines in the  "options" section. What this does is to effectively shutdown any  connection to the outside world.

This is helpful, particularly when we go to add this DNS to our  workstations, because we want these DNS server to only respond when the  IP address requesting the service is local, and simply not respond at  all if the service that is being looked up is on the Internet.

This way, the other configured DNS servers will take over nearly immediately to look up the Internet based services:



```
options {
#       listen-on port 53 { 127.0.0.1; };
#       listen-on-v6 port 53 { ::1; };
```

If you are not using IPv6, then it's a good idea to turn off IPv6 in *bind*.



This has to be handled in two places. The first place is in the *named.conf* file that we are already in. If you are using IPv6, then you can (and  should!) skip adding this line. Again, this can just be added anywhere  in the "options" section:

```
filter-aaaa-on-v4 yes;
```

Finally, skip down to the bottom of the *named.conf* file and add a section for your network. Our example is using ourdomain, so sub in what you want to call your LAN hosts:

```
# primary forwward and reverse zones
//forward zone
zone "ourdomain.lan" IN {
     type master;
     file "ourdomain.lan.db";
     allow-update { none; };
    allow-query {any; };
};
//reverse zone
zone "1.168.192.in-addr.arpa" IN {
     type master;
     file "ourdomain.lan.rev";
     allow-update { none; };
    allow-query { any; };
};
```

Now save your changes (for *vi*, `SHIFT:wq!`)

If you are turning off IPv6 for *bind* as noted above, then you will need to make a change to one more file:

```
vi /etc/sysconfig/named
```

And then add this to the bottom of the file:

```
OPTIONS="-4"
```

Now save those changes (again, for *vi*, `SHIFT:wq!`)

Next, we need to create two files in /var/named. These files are the  ones that you will edit if you add machines to your network that you  want to include in the DNS.

The first is the forward file to map our IP address to the hostname.  Again, we are using "ourdomain" as our example here. Note that the IP of our local DNS here is 192.168.1.136. The hosts are added at the bottom  of this file.

```
vi /var/named/ourdomain.lan.db
```

The file will look something like this when you are done:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;IP for Name Server
dns-primary IN A 192.168.1.136

;A Record for IP address to Hostname
wiki IN A 192.168.1.13
www IN A 192.168.1.14
devel IN A 192.168.1.15
```

Add as many hosts as you need to the bottom of the file along with their IP addresses and then save your changes.

Next, we need a reverse file to map our hostname to the IP address,  In this case, the only part of the IP that you need is the last octet  (in an IPv4 address each number separated by a comma, is an octet) of  the host and then the PTR and hostname.

```
vi /var/named/ourdomain.lan.rev
```

And the file should look something like this when you are done.:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)
;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;Reverse lookup for Name Server
100 IN PTR dns-primary.ourdomain.lan.

;PTR Record IP address to HostName
13 IN PTR wiki.ourdomain.lan.
14 IN PTR www.ourdomain.lan.
15 IN PTR devel.ourdomain.lan.
```

Add all of the hostnames that appear in the forward file and then save your changes.

### What All Of This Means[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#what-all-of-this-means)

Now that we have all of this added in and are preparing to restart our *bind* DNS server, let's just explore some of the terminology that is used in these two files.

Just making things work isn't good enough if you don't know what each term means, right?

- **TTL** appears in both files and it stands for "Time  To Live." TTL tells the DNS server how long to keep its cache in place  before requesting a fresh copy. In this case, the TTL is the default  setting for all records unless a specific record TTL is set. The default here is 86400 seconds or 24 hours.
- **IN** stands for Internet. In this case, we aren't actually using the Internet, so think of this as the Intranet.
- **SOA** stands for "Start Of Authority" or what the primary DNS server is for the domain.
- **NS** stands for "name server"
- **Serial** is the value used by the DNS server to verify that the contents of the zone file are up-to-date.
- **Refresh** specifies how often a slave DNS server should do a zone transfer from the master.
- **Retry** specifies the length of time in seconds to wait before trying again on a failed zone transfer.
- **Expire** specifies how long a slave server should wait to answer a query when the master is unreachable.
- **A** Is the host address or forward record and is only in the forward file (above).
- **PTR** Is the pointer record better known as the "reverse" and is only in our reverse file (above).

## Testing Configurations[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#testing-configurations)

Once we have gotten all of our files created, we need to make sure  that the configuration files and zones are in good working order before  we start the *bind* service again.

Check the main configuration:

```
named-checkconf
```

This should return an empty result if everything is OK.

Then check the forward zone:

```
named-checkzone ourdomain.lan /var/named/ourdomain.lan.db
```

This should return something like this if all is well:

```
zone ourdomain.lan/IN: loaded serial 2019061800
OK
```

And finally check the reverse zone:

```
named-checkzone 192.168.1.136 /var/named/ourdomain.lan.rev
```

Which should return something like this if all is well:

```
zone 192.168.1.136/IN: loaded serial 2019061800
OK
```

Assuming that everything looks good, go ahead and restart *bind*:

```
systemctl restart named
```

## Testing Machines[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#testing-machines)

You need to add the DNS server (in our example 192.168.1.136) to each machine that you want to have access to the servers that you added to  your new local DNS. We are only going to show you an example of how to  do this on a Rocky Linux workstation, but there are similar methods for  other Linux distributions, as well as Windows and Mac machines.

Keep in mind that you will want to just add the DNS server in the  list, as you will still need Internet access, which will require your  currently assigned DNS servers. These might be assigned via DHCP  (Dynamic Host Configuration Protocol) or statically assigned.

On a Rocky Linux workstation where the enabled network interface is eth0, you would use:

```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

If your enabled network interface is different, you will need to  substitute that interface name. The configuration file that you open  will look something like this for a statically assigned IP (not DHCP as  mentioned above). In the example below, our machine's IP address is  192.168.1.151:

```
DEVICE=eth0
BOOTPROTO=none
IPADDR=192.168.1.151
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
ONBOOT=yes
HOSTNAME=tender-kiwi
TYPE=Ethernet
MTU=
```

We want to substitute in our new DNS server for the primary (DNS1)  and then move each of the other DNS servers down one so that it like  this:

```
DEVICE=eth0
BOOTPROTO=none
IPADDR=192.168.1.151
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.136
DNS2=8.8.8.8
DNS3=8.8.4.4
ONBOOT=yes
HOSTNAME=tender-kiwi
TYPE=Ethernet
MTU=
```

Once you've made the change, either restart the machine or restart networking with:

```
systemctl restart network
```

Now you should be able to get to anything in the *ourdomain.lan* domain from your workstation, plus still be able to resovle and get to Internet addresses.

## Adding The Firewall Rule[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#adding-the-firewall-rule)

You have two choices for adding the firewall rules for DNS. You can either use the default *firewalld* or you can use *iptables* which is what we are using here. If you want to use *firewalld*, then we are assuming you will know how to translate this rule into *firewalld* syntax. The firewall rules are applied to the new private DNS server.

First, create a file in */etc* called "firewall.conf" that  will contain the following rules. This is a bare minimum rule set, and  you may need to tweak this for your environment:

```
#!/bin/sh
#
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
# dns rules
iptables -A INPUT -p udp -m udp -s 192.168.1.0/24 --dport 53 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

Let's evaluate the rules above:

- The first "iptables" line flushes the rules that are currently loaded (-F).
- Next, we are setting a default policy for the INPUT chain of DROP.  This means, if the traffic is not explicitly allowed here, it is  dropped.
- Next, we have an SSH rule for our local network, so that we can get into the DNS server remotely.
- Then we have our DNS allow rule, only for our local network. Note that DNS uses the UDP protocol (User Datagram Protocol).
- Next we allow INPUT from the local interface.
- Then if you have established a connection for something else, we are allowing related packets in as well.
- And finally we reject everything else.
- The last line tells iptables to save the rules so that when the machine restarts, the rules will load as well.

Once our firewall.conf file is created, we need to make it executable:

```
chmod +x /etc/firewall.conf
```

Then run it:

```
/etc/firewall.conf
```

And this is what you should get in return. If you get something else, take a look at your script for errors:

```
clearing any existing rules and setting default policy..
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
```

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/#conclusions)

While using */etc/hosts* on an individual workstation will get you access to a machine on your internal network, you can only use it  on that one machine. By adding a private DNS server using *bind*, you can add hosts to the DNS and as long as the workstations have  access to that private DNS server, they will be able to get to these  local servers.

If you don't need machines to resolve on the Internet, but do need  local access from several machines to local servers, then consider using a private DNS server instead.

# Private DNS Server Using Bind[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#private-dns-server-using-bind)

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#prerequisites-and-assumptions)

- A server running Rocky Linux
- Several internal servers that need to be accessed only locally, but not over the Internet
- Several workstations that need access to these same servers that exist on the same network
- A healthy comfort level with entering commands from command line
- Familiarity with a command line editor (we are using *vi* in this example)
- Able to use either *firewalld* or *iptables* for creating firewall rules. We've provided both *iptables* and *firewalld* options. If you plan to use *iptables*, use the [Enabling Iptables Firewall procedure](https://docs.rockylinux.org/guides/security/enabling_iptables_firewall/)

## Introduction[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#introduction)

External, or public, DNS servers are used on the Internet to map host names to IP addresses and, in the case of PTR (known as "pointer" or  "reverse") records, to map the IP to the host name. This is an essential part of the Internet. It makes your mail server, web server, FTP  server, or many other servers and services work as expected no matter  where you are.

On a private network, particularly one that is being used for  developing multiple systems, you can use your Rocky Linux workstation's */etc/hosts* file to map a name to an IP address.

This will work for *your* workstation, but not for any other  machine on your network. If you want to make things universally applied, then the best method is to take some time out and create a local,  private DNS server to handle this for all of your machines.

If you were creating production-level public DNS servers and  resolvers, then this author would probably recommend the more robust [PowerDNS](https://www.powerdns.com/) authoritative and recursive DNS, which is easily installed on Rocky  Linux servers. However, that is simply overkill for a local network that won't be exposing its DNS servers to the outside world. That is why we  have chosen *bind* for this example.

### The DNS Server Components Explained[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#the-dns-server-components-explained)

As stated, DNS separates services into authoritative and recursive  servers. These services are now recommended to be separate from each  other on separate hardware or containers.

The authoritative server is the storage area for all IP addresses and host names, and the recursive server is used to lookup addresses and  host names. In the case of our private DNS server, both the  authoritative and the recursive server services will run together.

## Installing and Enabling Bind[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#installing-and-enabling-bind)

The first step is to install packages. In the case of *bind* we need to execute the following command:

```
dnf install bind bind-utils
```

The service daemon for *bind* is called *named*, and we need to enable this to start on boot:

```
systemctl enable named
```

And then we need to start it:

```
systemctl start named
```

## Configuration[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#configuration)

Before making changes to any configuration file, it is a good idea to make a backup copy of the original installed working file, in this case *named.conf*:

```
cp /etc/named.conf /etc/named.conf.orig
```

That will help in the future if errors are introduced into the configuration file. It is *always* a good idea to make a backup copy before making changes.

These changes require us to edit the named.conf file, to do this, we are using *vi*, but you can substitute your favorite command line editor (the editor `nano` is also installed in Rocky Linux and is easier to use than `vi`):

```
vi /etc/named.conf
```

First thing we want to do is turn off listening on the localhost,  this is done by remarking out with a "#" sign, these two lines in the  "options" section. What this does is to effectively shut down any  connection to the outside world.

This is helpful, particularly when we go to add this DNS to our  workstations, because we want the DNS server to only respond when the IP address requesting the service is local, and simply not respond at all  if the service that is being looked up is on the Internet.

This way, the other configured DNS servers will take over nearly immediately to look up the Internet based services:

```
options {
#       listen-on port 53 { 127.0.0.1; };
#       listen-on-v6 port 53 { ::1; };
```

Finally, skip down to the bottom of the *named.conf* file and add a section for your network. Our example is using ourdomain, so sub in what you want to call your LAN hosts:

```
# primary forwward and reverse zones
//forward zone
zone "ourdomain.lan" IN {
     type master;
     file "ourdomain.lan.db";
     allow-update { none; };
    allow-query {any; };
};
//reverse zone
zone "1.168.192.in-addr.arpa" IN {
     type master;
     file "ourdomain.lan.rev";
     allow-update { none; };
    allow-query { any; };
};
```

Now save your changes (for *vi*, `SHIFT:wq!`)

## The Forward and Reverse Records[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#the-forward-and-reverse-records)

Next, we need to create two files in `/var/named`. These files are the ones that you will edit if you add machines to your network that you want to include in the DNS.

The first is the forward file to map our IP address to the hostname.  Again, we are using "ourdomain" as our example here. Note that the IP of our local DNS here is 192.168.1.136. The hosts are added at the bottom  of this file.

```
vi /var/named/ourdomain.lan.db
```

The file will look something like this when you are done:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;IP for Name Server
dns-primary IN A 192.168.1.136

;A Record for IP address to Hostname
wiki IN A 192.168.1.13
www IN A 192.168.1.14
devel IN A 192.168.1.15
```

Add as many hosts as you need to the bottom of the file along with their IP addresses and then save your changes.

Next, we need a reverse file to map our hostname to the IP address,  In this case, the only part of the IP that you need is the last octet  (in an IPv4 address each number separated by a period, is an octet) of  the host and then the PTR and hostname.

```
vi /var/named/ourdomain.lan.rev
```

And the file should look something like this when you are done.:

```
$TTL 86400
@ IN SOA dns-primary.ourdomain.lan. admin.ourdomain.lan. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)
;Name Server Information
@ IN NS dns-primary.ourdomain.lan.

;Reverse lookup for Name Server
136 IN PTR dns-primary.ourdomain.lan.

;PTR Record IP address to HostName
13 IN PTR wiki.ourdomain.lan.
14 IN PTR www.ourdomain.lan.
15 IN PTR devel.ourdomain.lan.
```

Add all of the hostnames that appear in the forward file and then save your changes.

### What All Of This Means[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#what-all-of-this-means)

Now that we have all of this added in and are preparing to restart our *bind* DNS server, let's just explore some of the terminology that is used in these two files.

Just making things work isn't good enough if you don't know what each term means, right?

- **TTL** appears in both files and it stands for "Time  To Live". TTL tells the DNS server how long to keep its cache in place  before requesting a fresh copy. In this case, the TTL is the default  setting for all records unless a specific record TTL is set. The default here is 86400 seconds or 24 hours.
- **IN** stands for Internet. In this case, we aren't actually using the Internet, so think of this as the Intranet.
- **SOA** stands for "Start Of Authority" or what the primary DNS server is for the domain.
- **NS** stands for "name server"
- **Serial** is the value used by the DNS server to verify that the contents of the zone file are up-to-date.
- **Refresh** specifies how often a slave DNS server should do a zone transfer from the master.
- **Retry** specifies the length of time in seconds to wait before trying again on a failed zone transfer.
- **Expire** specifies how long a slave server should wait to answer a query when the master is unreachable.
- **A** Is the host address or forward record and is only in the forward file (above).
- **PTR** Is the pointer record better known as the "reverse" and is only in our reverse file (above).

## Testing Configurations[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#testing-configurations)

Once we have gotten all of our files created, we need to make sure  that the configuration files and zones are in good working order before  we start the *bind* service again.

Check the main configuration:

```
named-checkconf
```

This should return an empty result if everything is OK.

Then check the forward zone:

```
named-checkzone ourdomain.lan /var/named/ourdomain.lan.db
```

This should return something like this if all is well:

```
zone ourdomain.lan/IN: loaded serial 2019061800
OK
```

And finally check the reverse zone:

```
named-checkzone 192.168.1.136 /var/named/ourdomain.lan.rev
```

Which should return something like this if all is well:

```
zone 192.168.1.136/IN: loaded serial 2019061800
OK
```

Assuming that everything looks good, go ahead and restart *bind*:

```
systemctl restart named
```

98

## 9 Using IPv4 On Your LAN[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#9-using-ipv4-on-your-lan)

In order to use ONLY IPv4 on your LAN, you need to make one change in `/etc/sysconfig/named`:



```
vi /etc/sysconfig/named
```

and then add this at the bottom of the file:



```
OPTIONS="-4"
```

Now save those changes (again, for *vi*, `SHIFT:wq!`)

## 9 Testing Machines[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#9-testing-machines)

You need to add the DNS server (in our example 192.168.1.136) to each machine that you want to have access to the servers that you added to  your local DNS. We are only going to show you an example of how to do  this on a Rocky Linux workstation, but there are similar methods for  other Linux distributions, as well as Windows and Mac machines.

Keep in mind that you will want to just add the DNS servers to the  list, not replace what is currently there, as you will still need  Internet access, which will require your currently assigned DNS servers. These might be assigned via DHCP (Dynamic Host Configuration Protocol)  or statically assigned.

We will add our local DNS with `nmcli` and then restart the connection. 

<details class="warning">
<summary>Stupid Profile Names</summary>









</details>

Assuming that your connection profile name is "enp0s3", we will  include the already configured DNS but add our local DNS server first:

```
nmcli con mod enp0s3 ipv4.dns '192.168.1.138,192.168.1.1'
```

You can have more DNS servers, and for a machine configured with  public DNS servers, say Google's open DNS, you can have something like  this instead:

```
nmcli con mod enp0s3 ipv4.dns '192.168.1.138,8.8.8.8,8.8.4.4'
```

Once you've added the DNS servers that you want to the connection, you should be able to resolve hosts in *ourdomain.lan*, as well as Internet hosts.

## 9 Firewall Rules - `firewalld`[¶](https://docs.rockylinux.org/guides/dns/private_dns_server_using_bind/#9-firewall-rules-firewalld)

`firewalld` By Default

With Rocky Linux 9.0 and above, using `iptables` rules is deprecated. You should use `firewalld` instead.

We aren't making any assumptions about the network or services that  might be needed, except that we are turning on SSH access and DNS access for our LAN network only. For this, we will use the `firewalld` built-in zone, "trusted". We will also have to make some service  changes to the "public" zone in order to limit SSH access to the LAN.

The first step is to add our LAN network to the "trusted" zone:

```
firewall-cmd --zone=trusted --add-source=192.168.1.0/24 --permanent
```

Next, we need to add our two services to the "trusted" zone:

```
firewall-cmd --zone=trusted --add-service=ssh --permanent
firewall-cmd --zone=trusted --add-service=dns --permanent
```

Finally, we need to remove the SSH service from our "public" zone, which is on by default:

```
firewall-cmd --zone=public --remove-service=ssh --permanent
```

Next, reload the firewall and then list out the zones that we've made changes to:

```
firewall-cmd --reload
firewall-cmd --zone=trusted --list-all
```

Which should show that you have correctly added the services and the source network:

```
trusted (active)
    target: ACCEPT
    icmp-block-inversion: no
    interfaces:
    sources: 192.168.1.0/24
    services: dns ssh
    ports:
    protocols:
    forward: no
    masquerade: no
    forward-ports:
    source-ports:
    icmp-blocks:
    rich rules:
```

Listing out the "public" zone should show that SSH access is no-longer allowed:

```
firewall-cmd --zone=public --list-all
```

Which should show you:

```
public
    target: default
    icmp-block-inversion: no
    interfaces:
    sources:
    services: cockpit dhcpv6-client
    ports:
    protocols:
    forward: no
    masquerade: no
    forward-ports:
    source-ports:
    icmp-blocks:
    rich rules:
```

These rules should get you DNS resolution on your private DNS server  from hosts on the 192.168.1.0/24 network. In addition, you should be  able to SSH from any of those hosts into your private DNS server.

## Conclusions

While using */etc/hosts* on an individual workstation will get you access to a machine on your internal network, you can only use it  on that one machine. By adding a private DNS server using *bind*, you can add hosts to the DNS and as long as the workstations have  access to that private DNS server, they will be able to get to these  local servers.

If you don't need machines to resolve on the Internet, but do need  local access from several machines to local servers, then consider using a private DNS server instead.











## [Set up a caching nameserver 设置缓存名称服务器](https://ubuntu.com/server/docs/domain-name-service-dns#set-up-a-caching-nameserver)

The default configuration acts as a caching server. Simply uncomment and edit `/etc/bind/named.conf.options` to set the IP addresses of your ISP’s DNS servers:
默认配置充当缓存服务器。只需取消注释并编辑 `/etc/bind/named.conf.options` 即可设置 ISP 的 DNS 服务器的 IP 地址：

```auto
forwarders {
    1.2.3.4;
    5.6.7.8;
};
```

> **Note**: 注意：
>  Replace `1.2.3.4` and `5.6.7.8` with the IP addresses of actual nameservers.
> 将 和 `5.6.7.8` 替换 `1.2.3.4` 为实际名称服务器的 IP 地址。

To enable the new configuration, restart the DNS server. From a terminal prompt, run:
若要启用新配置，请重新启动 DNS 服务器。在终端提示符下，运行：

```bash
sudo systemctl restart bind9.service
```

## [Set up a primary server 设置主服务器](https://ubuntu.com/server/docs/domain-name-service-dns#set-up-a-primary-server)

In this section BIND9 will be configured as the primary server for the domain `example.com`. You can replace `example.com` with your FQDN (Fully Qualified Domain Name).
在本节中，BIND9 将配置为域 `example.com` 的主服务器。您可以替换 `example.com` 为 FQDN（完全限定域名）。

### [Forward zone file 转发区域文件](https://ubuntu.com/server/docs/domain-name-service-dns#forward-zone-file)

To add a DNS zone to BIND9, turning BIND9 into a primary server, first edit `/etc/bind/named.conf.local`:
要向 BIND9 添加 DNS 区域，将 BIND9 转换为主服务器，请先编辑 `/etc/bind/named.conf.local` ：

```auto
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
};
```

> **Note**: 注意：
>  If BIND will be receiving automatic updates to the file as with DDNS, then use `/var/lib/bind/db.example.com` rather than `/etc/bind/db.example.com` both here and in the copy command below.
> 如果 BIND 将像 DDNS 一样接收文件的自动更新，则在此处和下面的 copy 命令中使用 `/etc/bind/db.example.com` 而不是同时使用 `/var/lib/bind/db.example.com` 。

Now use an existing zone file as a template to create the `/etc/bind/db.example.com` file:
现在使用现有区域文件作为模板来创建 `/etc/bind/db.example.com` 文件：

```bash
sudo cp /etc/bind/db.local /etc/bind/db.example.com
```

Edit the new zone file `/etc/bind/db.example.com` and change `localhost.` to the FQDN of your server, including the additional `.` at the end. Change `127.0.0.1` to the nameserver’s IP address and `root.localhost` to a valid email address, but with a `.` instead of the usual `@` symbol, again including the `.` at the end. Change the comment to indicate the domain that this file is for.
编辑新的区域文件 `/etc/bind/db.example.com` 并更改 `localhost.` 为服务器的 FQDN，包括末尾的其他 `.` FQDN。更改 `127.0.0.1` 为名称服务器的 IP 地址和 `root.localhost` 有效的电子邮件地址，但使用一个 `.` 而不是通常 `@` 的符号，再次在末尾包含 。 `.` 更改注释以指示此文件所针对的域。

Create an **A record** for the base domain, `example.com`. Also, create an **A record** for `ns.example.com`, the name server in this example:
为基域创建 A 记录 `example.com` 。此外，在此示例中，为 `ns.example.com` 名称服务器创建 A 记录：

```auto
;
; BIND data file for example.com
;
$TTL    604800
@       IN      SOA     example.com. root.example.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

@       IN      NS      ns.example.com.
@       IN      A       192.168.1.10
@       IN      AAAA    ::1
ns      IN      A       192.168.1.10
```

You must increment the `Serial Number` every time you make changes to the zone file. If you make multiple changes before restarting BIND9, only increment `Serial` once.
每次对区域文件进行更改时，都必须递增 。 `Serial Number` 如果在重新启动 BIND9 之前进行了多次更改，则只能递增 `Serial` 一次。

Now, you can add DNS records to the bottom of the zone file. See [Common Record Types](https://ubuntu.com/server/docs/domain-name-service-dns) for details.
现在，您可以将 DNS 记录添加到区域文件的底部。有关详细信息，请参阅常见记录类型。

> **Note**: 注意：
>  Many admins like to use the “last edited” date as the Serial of a zone, such as **2020012100** which is **yyyymmddss** (where **ss** is the Serial Number)
> 许多管理员喜欢使用“上次编辑”日期作为区域的序列号，例如 2020012100 是 yyyymmddss（其中 ss 是序列号）

Once you have made changes to the zone file, BIND9 needs to be restarted for the changes to take effect:
对区域文件进行更改后，需要重新启动 BIND9 才能使更改生效：

```bash
sudo systemctl restart bind9.service
```

### [Reverse zone file 反转区域文件](https://ubuntu.com/server/docs/domain-name-service-dns#reverse-zone-file)

Now that the zone is set up and resolving names to IP Addresses, a **reverse zone** needs to be added to allows DNS to resolve an address to a name.
现在，区域已设置好，并将名称解析为 IP 地址，需要添加一个反向区域，以允许 DNS 将地址解析为名称。

Edit `/etc/bind/named.conf.local` and add the following:
编辑 `/etc/bind/named.conf.local` 并添加以下内容：

```auto
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192";
};
```

> **Note**: 注意：
>  Replace `1.168.192` with the first three octets of whatever network you are using. Also, name the zone file `/etc/bind/db.192` appropriately. It should match the first octet of your network.
> 替换 `1.168.192` 为您正在使用的任何网络的前三个八位字节。此外，请适当地命名区域文件 `/etc/bind/db.192` 。它应该与网络的第一个八位字节匹配。

Now create the `/etc/bind/db.192` file:
现在创建 `/etc/bind/db.192` 文件：

```bash
sudo cp /etc/bind/db.127 /etc/bind/db.192
```

Next edit `/etc/bind/db.192`, changing the same options as `/etc/bind/db.example.com`:
接下来编辑 `/etc/bind/db.192` ，更改与以下 `/etc/bind/db.example.com` 相同的选项：

```auto
;
; BIND reverse data file for local 192.168.1.XXX net
;
$TTL    604800
@       IN      SOA     ns.example.com. root.example.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.
10      IN      PTR     ns.example.com.
```

The `Serial Number` in the reverse zone needs to be incremented on each change as well. For each **A record** you configure in `/etc/bind/db.example.com` that is for a different address, you will need to create a **PTR record** in `/etc/bind/db.192`.
 `Serial Number` 在反向区域中也需要在每次更改时递增。对于您在其中配置的用于不同地址的每条 A 记录 `/etc/bind/db.example.com` ，您需要在 中 `/etc/bind/db.192` 创建一个 PTR 记录。

After creating the reverse zone file restart BIND9:
创建反向区域文件后，重新启动 BIND9：

```bash
sudo systemctl restart bind9.service
```

## [Set up a secondary server 设置辅助服务器](https://ubuntu.com/server/docs/domain-name-service-dns#set-up-a-secondary-server)

Once a primary server has been configured, a **secondary server** is highly recommended. This will maintain the availability of the domain if the primary becomes unavailable.
配置主服务器后，强烈建议使用辅助服务器。如果主服务器不可用，这将保持域的可用性。

First, on the primary server, the zone transfer needs to be allowed. Add the `allow-transfer` option to the example **Forward** and **Reverse** zone definitions in `/etc/bind/named.conf.local`:
首先，在主服务器上，需要允许区域传输。将 `allow-transfer` 该选项添加到示例中的“正向”和“反向区域定义”中 `/etc/bind/named.conf.local` ：

```auto
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
    allow-transfer { 192.168.1.11; };
};
    
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192";
    allow-transfer { 192.168.1.11; };
};
```

> **Note**: 注意：
>  Replace `192.168.1.11` with the IP address of your secondary nameserver.
> 替换 `192.168.1.11` 为辅助名称服务器的 IP 地址。

Restart BIND9 on the primary server:
在主服务器上重新启动 BIND9：

```bash
sudo systemctl restart bind9.service
```

Next, on the secondary server, install the `bind9` package the same way as on the primary. Then edit the `/etc/bind/named.conf.local` and add the following declarations for the Forward and Reverse zones:
接下来，在辅助服务器上，以与在主服务器上相同的方式安装 `bind9` 软件包。然后，为“前进 `/etc/bind/named.conf.local` ”和“反向”区域编辑并添加以下声明：

```auto
zone "example.com" {
    type secondary;
    file "db.example.com";
    masters { 192.168.1.10; };
};        
          
zone "1.168.192.in-addr.arpa" {
    type secondary;
    file "db.192";
    masters { 192.168.1.10; };
};
```

Once again, replace `192.168.1.10` with the IP address of your primary nameserver, then restart BIND9 on the secondary server:
再次替换 `192.168.1.10` 为主名称服务器的 IP 地址，然后在辅助服务器上重新启动 BIND9：

```bash
sudo systemctl restart bind9.service
```

In `/var/log/syslog` you should see something similar to the following (some lines have been split to fit the format of this document):
在 `/var/log/syslog` 中，您应该看到类似于以下内容的内容（某些行已被拆分以适应本文档的格式）：

```plaintext
client 192.168.1.10#39448: received notify for zone '1.168.192.in-addr.arpa'
zone 1.168.192.in-addr.arpa/IN: Transfer started.
transfer of '100.18.172.in-addr.arpa/IN' from 192.168.1.10#53:
 connected using 192.168.1.11#37531
zone 1.168.192.in-addr.arpa/IN: transferred serial 5
transfer of '100.18.172.in-addr.arpa/IN' from 192.168.1.10#53:
 Transfer completed: 1 messages, 
6 records, 212 bytes, 0.002 secs (106000 bytes/sec)
zone 1.168.192.in-addr.arpa/IN: sending notifies (serial 5)
    
client 192.168.1.10#20329: received notify for zone 'example.com'
zone example.com/IN: Transfer started.
transfer of 'example.com/IN' from 192.168.1.10#53: connected using 192.168.1.11#38577
zone example.com/IN: transferred serial 5
transfer of 'example.com/IN' from 192.168.1.10#53: Transfer completed: 1 messages, 
8 records, 225 bytes, 0.002 secs (112500 bytes/sec)
```

> **Note**: 注意：
>  A zone is only transferred if the `Serial Number` on the primary is larger than the one on the secondary. If you want to  have your primary DNS notify other secondary DNS servers of zone  changes, you can add `also-notify { ipaddress; };` to `/etc/bind/named.conf.local` as shown in the example below:
> 仅当主节点 `Serial Number` 上的区域大于辅助节点上的区域时，才会传输区域。如果要让主 DNS 将区域更改通知其他辅助 DNS 服务器，可以添加 `also-notify { ipaddress; };` 到 `/etc/bind/named.conf.local` ，如以下示例所示：

```auto
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
    allow-transfer { 192.168.1.11; };
    also-notify { 192.168.1.11; }; 
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192";
    allow-transfer { 192.168.1.11; };
    also-notify { 192.168.1.11; }; 
};
    
```

> **Note**: 注意：
>  The default directory for non-authoritative zone files is `/var/cache/bind/`. This directory is also configured in AppArmor to allow the named daemon to write to it. See this page for [more information on AppArmor](https://ubuntu.com/server/docs/apparmor).
> 非权威区域文件的默认目录是 `/var/cache/bind/` 。此目录也在 AppArmor 中配置，以允许命名守护程序写入该目录。有关 AppArmor 的更多信息，请参阅此页面。

## [Testing your setup 测试您的设置](https://ubuntu.com/server/docs/domain-name-service-dns#testing-your-setup)

### [resolv.conf](https://ubuntu.com/server/docs/domain-name-service-dns#resolvconf)

The first step in testing BIND9 is to add the nameserver’s IP address to a **hosts resolver**. The Primary nameserver should be configured as well as another host to double check things. Refer to [DNS client configuration](https://ubuntu.com/server/docs/configuring-networks) for details on adding nameserver addresses to your network clients. In the end your `nameserver` line in `/etc/resolv.conf` should be pointing at `127.0.0.53` and you should have a `search` parameter for your domain. Something like this:
测试 BIND9 的第一步是将名称服务器的 IP 地址添加到主机解析器。应配置主名称服务器以及另一台主机以仔细检查内容。有关向网络客户端添加名称服务器地址的详细信息，请参阅 DNS 客户端配置。最后，您的 `nameserver` 行 `/etc/resolv.conf` 应该指向 `127.0.0.53` ，并且您应该为您的域设置一个 `search` 参数。像这样的东西：

```plaintext
nameserver  127.0.0.53
search example.com
```

To check which DNS server your local resolver is using, run:
若要检查本地解析程序使用的是哪个 DNS 服务器，请运行：

```bash
resolvectl status
```

> **Note**: 注意：
>  You should also add the IP address of the secondary nameserver to your  client configuration in case the primary becomes unavailable.
> 您还应该将辅助名称服务器的 IP 地址添加到客户端配置中，以防主名称服务器不可用。

### [dig 挖](https://ubuntu.com/server/docs/domain-name-service-dns#dig)

If you installed the `dnsutils` package you can test your setup using the DNS lookup utility `dig`:
如果您安装了 `dnsutils` 该软件包，则可以使用DNS查找实用程序 `dig` 测试您的设置：

After installing BIND9 use `dig` against the loopback interface to make sure it is listening on port 53. From a terminal prompt:
安装 BIND9 后，对环回接口使用 `dig` ，以确保它正在侦听端口 53。在终端提示符下：

```bash
dig -x 127.0.0.1
```

You should see lines similar to the following in the command output:
您应该在命令输出中看到类似于以下内容的行：

```auto
;; Query time: 1 msec
;; SERVER: 192.168.1.10#53(192.168.1.10)
```

If you have configured BIND9 as a caching nameserver, “dig” an outside domain to check the query time:
如果已将 BIND9 配置为缓存名称服务器，请“挖掘”外部域以检查查询时间：

```bash
dig ubuntu.com
```

Note the query time toward the end of the command output:
请注意命令输出末尾的查询时间：

```auto
;; Query time: 49 msec
```

After a second `dig` there should be improvement:
一秒钟 `dig` 后，应该会有所改善：

```auto
;; Query time: 1 msec
```

### [ping 乒](https://ubuntu.com/server/docs/domain-name-service-dns#ping)

Now let’s demonstrate how applications make use of DNS to resolve a host name, by using the `ping` utility to send an ICMP echo request:
现在，让我们演示应用程序如何利用 DNS 来解析主机名，方法是使用 `ping` 实用程序发送 ICMP 回显请求：

```bash
ping example.com
```

This tests if the nameserver can resolve the name `ns.example.com` to an IP address. The command output should resemble:
这将测试名称服务器是否可以将名称 `ns.example.com` 解析为 IP 地址。命令输出应如下所示：

```auto
PING ns.example.com (192.168.1.10) 56(84) bytes of data.
64 bytes from 192.168.1.10: icmp_seq=1 ttl=64 time=0.800 ms
64 bytes from 192.168.1.10: icmp_seq=2 ttl=64 time=0.813 ms
```

### [named-checkzone 命名检查区](https://ubuntu.com/server/docs/domain-name-service-dns#named-checkzone)

A great way to test your zone files is by using the `named-checkzone` utility installed with the `bind9` package. This utility allows you to make sure the configuration is correct before restarting BIND9 and making the changes live.
测试区域文件的一个好方法是使用随软件包一起安装的 `named-checkzone`  `bind9` 实用程序。此实用程序允许您在重新启动 BIND9 并进行更改之前确保配置正确。

To test our example forward zone file, enter the following from a command prompt:
若要测试示例转发区域文件，请在命令提示符下输入以下命令：

```bash
named-checkzone example.com /etc/bind/db.example.com
```

If everything is configured correctly you should see output similar to:
如果所有内容都配置正确，您应该会看到类似于以下内容的输出：

```auto
zone example.com/IN: loaded serial 6
OK
```

Similarly, to test the reverse zone file enter the following:
同样，要测试反向区域文件，请输入以下命令：

```auto
named-checkzone 1.168.192.in-addr.arpa /etc/bind/db.192
```

The output should be similar to:
输出应类似于：

```auto
zone 1.168.192.in-addr.arpa/IN: loaded serial 3
OK
```

> **Note**: 注意：
>  The Serial Number of your zone file will probably be different.
> 区域文件的序列号可能会有所不同。

### [Quick temporary query logging 快速临时查询日志记录](https://ubuntu.com/server/docs/domain-name-service-dns#quick-temporary-query-logging)

With the `rndc` tool, you can quickly turn query logging on and off, without restarting the service or changing the configuration file.
使用该 `rndc` 工具，您可以快速打开和关闭查询日志记录，而无需重新启动服务或更改配置文件。

To turn query logging on, run:
若要打开查询日志记录，请运行：

```bash
sudo rndc querylog on
```

Likewise, to turn it off, run:
同样，要将其关闭，请运行：

```bash
sudo rndc querylog off
```

The logs will be sent to `syslog` and will show up in `/var/log/syslog` by default:
默认情况下，日志将发送到 `syslog` 并显示在 `/var/log/syslog` ：

```auto
Jan 20 19:40:50 new-n1 named[816]: received control channel command 'querylog on'
Jan 20 19:40:50 new-n1 named[816]: query logging is now on
Jan 20 19:40:57 new-n1 named[816]: client @0x7f48ec101480 192.168.1.10#36139 (ubuntu.com): query: ubuntu.com IN A +E(0)K (192.168.1.10)
```

> **Note**: 注意：
>  The amount of logs generated by enabling `querylog` could be huge!
> 启用 `querylog` 后生成的日志量可能很大！

## [Logging 伐木](https://ubuntu.com/server/docs/domain-name-service-dns#logging)

BIND9 has a wide variety of logging configuration options available, but the two main ones are **channel** and **category**, which configure where logs go, and what information gets logged, respectively.
BIND9 提供了多种日志记录配置选项，但两个主要选项是 channel 和 category，它们分别配置日志的去向和记录的信息。

If no logging options are configured the default configuration is:
如果未配置日志记录选项，则默认配置为：

```auto
logging {
     category default { default_syslog; default_debug; };
     category unmatched { null; };
};
```

Let’s instead configure BIND9 to send **debug** messages related to DNS queries to a separate file.
让我们改为配置 BIND9 以将与 DNS 查询相关的调试消息发送到单独的文件。

We need to configure a **channel** to specify which file to send the messages to, and a **category**. In this example, the category will log all queries. Edit `/etc/bind/named.conf.local` and add the following:
我们需要配置一个通道来指定将消息发送到哪个文件和一个类别。在此示例中，类别将记录所有查询。编辑 `/etc/bind/named.conf.local` 并添加以下内容：

```auto
logging {
    channel query.log {
        file "/var/log/named/query.log";
        severity debug 3;
    };
    category queries { query.log; };
};
```

> **Note**: 注意：
>  The `debug` option can be set from 1 to 3. If a level isn’t specified, level 1 is the default.
> 该 `debug` 选项可以在 1 到 3 之间设置。如果未指定级别，则级别 1 为默认值。

Since the **named daemon** runs as the `bind` user, the `/var/log/named` directory must be created and the ownership changed:
由于命名守护程序以 `bind` 用户身份运行，因此必须创建 `/var/log/named` 目录并更改所有权：

```bash
sudo mkdir /var/log/named
sudo chown bind:bind /var/log/named
```

Now restart BIND9 for the changes to take effect:
现在重新启动 BIND9 以使更改生效：

```bash
sudo systemctl restart bind9.service
```

You should see the file `/var/log/named/query.log` fill with query information. This is a simple example of the BIND9  logging options. For coverage of advanced options see the “Further  Reading” section at the bottom of this page.
您应该会看到文件 `/var/log/named/query.log` 填充了查询信息。这是 BIND9 日志记录选项的简单示例。有关高级选项的介绍，请参阅本页底部的“延伸阅读”部分。

## [Common record types 常见记录类型](https://ubuntu.com/server/docs/domain-name-service-dns#common-record-types)

This section covers some of the most common DNS record types.
本部分介绍一些最常见的 DNS 记录类型。

- **`A` record `A` 记录**
   This record maps an IP address to a hostname.
  此记录将 IP 地址映射到主机名。

  ```auto
  www      IN    A      192.168.1.12
  ```

- **`CNAME` record `CNAME` 记录**
   Used to create an alias to an existing A record. You cannot create a `CNAME` record pointing to another `CNAME` record.
  用于创建现有 A 记录的别名。不能创建指向另一 `CNAME` 条记录的记录 `CNAME` 。

  ```auto
  web     IN    CNAME  www
  ```

- **`MX` record `MX` 记录**
   Used to define where emails should be sent to. Must point to an `A` record, not a `CNAME`.
  用于定义电子邮件应发送到的位置。必须指向记录 `A` ，而不是 `CNAME` .

  ```auto
  @       IN    MX  1   mail.example.com.
  mail    IN    A       192.168.1.13
  ```

- **`NS` record `NS` 记录**
   Used to define which servers serve copies of a zone. It must point to an `A` record, not a `CNAME`. This is where primary and secondary servers are defined.
  用于定义哪些服务器提供区域的副本。它必须指向记录 `A` ，而不是 `CNAME` .这是定义主服务器和辅助服务器的地方。

  ```auto
  @       IN    NS     ns.example.com.
  @       IN    NS     ns2.example.com.
  ns      IN    A      192.168.1.10
  ns2     IN    A      192.168.1.11
  ```





