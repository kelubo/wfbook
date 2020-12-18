# RGW

[TOC]

网关守护进程内嵌了 Civetweb，无需额外安装 web 服务器或配置 FastCGI。

> Tip
>
> Civetweb 默认使用 `7480` 端口。要么直接打开 `7480` 端口，要么在你的 Ceph 配置文件中设置首选端口（例如 `80` 端口）。

## 安装对象网关

1. 使用 Civetweb 的默认端口 `7480` ，必须通过 `firewall-cmd` 或 `iptables` 来打开它。

2. 从管理节点的工作目录，在 `client-node` 上安装 Ceph 对象网关软件包。例如：

   ```bash
   ceph-deploy install --rgw <client-node> [<client-node> ...]
   ```

## 新建对象网关实例

从管理节点的工作目录，在 `client-node` 上新建一个 Ceph 对象网关实例。例如：

```bash
ceph-deploy rgw create
```

一旦网关开始运行，可以通过 `7480` 端口来访问它（比如 `http://client-node:7480` ）。

## 配置对象网关实例

1. 通过修改 Ceph 配置文件可以更改默认端口（比如改成 `80` ）。增加名为 `[client.rgw.<client-node>]` 的小节，把 `<client-node>` 替换成你自己 Ceph 客户端节点的短名称（即 `hostname -s` 的输出）。例如，你的节点名就是 `client-node` ，在 `[global]` 节后增加一个类似于下面的小节：

   ```bash
   [client.rgw.client-node]
   rgw_frontends = "civetweb port=80"
   ```

   > Note
>
   > 确保在 `rgw_frontends` 键值对的 `port=<port-number>` 中没有空格。

2. 为了使新端口的设置生效，需要重启 Ceph 对象网关。在 RHEL 7 和 Fedora 上 ，执行：

   ```bash
   sudo systemctl restart ceph-radosgw.service
   ```

   在 RHEL 6 和 Ubuntu 上，执行：

   ```bash
   sudo service radosgw restart id=rgw.<short-hostname>
   ```

3. 最后，检查节点的防火墙，确保你所选用的端口（例如 `80` 端口）处于开放状态。如果没有，把该端口加入放行规则并重载防火墙的配置。例如：

   ```bash
   sudo firewall-cmd --list-all sudo firewall-cmd --zone=public --add-port
   80/tcp --permanent
   sudo firewall-cmd --reload
   ```

   应该可以生成一个未授权的请求，并收到应答。例如，一个如下不带参数的请求：

   ```bash
http://<client-node>:80
   ```
   
   应该收到这样的应答：

   ```bash
<?xml version="1.0" encoding="UTF-8"?>
   <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
     <Owner>
       <ID>anonymous</ID>
       <DisplayName></DisplayName>
     </Owner>
     <Buckets>
     </Buckets>
   </ListAllMyBucketsResult>
   ```
   







- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/federated-config/) |
- ​          [previous](http://docs.ceph.org.cn/install/install-ceph-gateway/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 配置 Ceph 对象网关

要配置一个 Ceph 对象网关需要一个运行着的 Ceph 存储集群，以及启用了 FastCGI 模块的 Apache web服务器。

Ceph 对象网关是 Ceph 存储集群的一个客户端，作为 Ceph 存储集群的客户端，它需要：

- 需要为网关实例配置一个名字，在本手册中我们使用 `gateway` .
- 存储集群的一个用户名，并且该用户在keyring中有合适的权限.
- 存储数据的资源池.
- 网关实例的一个数据目录.
- Ceph 配置文件中有一个实例配置入口.
- web 服务器有一个配置文件跟 FastCGI 交互.

## 新建用户和 Keyring

每一个实例必须有一个用户名和key来跟 Ceph  存储集群通信.在下面的步骤中,我们使用管理节点来新建keyring.然后,我们新建一个客户端用户名和key.然后我们将这个key添加到 Ceph 存储集群中.最后,分发这个 key ring到包含这个网关实例的节点.

Monitor Key CAPS

当你给 key 分配 CAPS 的时候,你必须提供读权限.然而,你也可以选择为 monitor 提供写的权限.  这是一个重要的抉择.如果你给 key 分配了写权限, Ceph 对象网关将具备自动新建资源池的能力; 此时,它将会根据默认的 PG  值(不是最合适的)或者你在 Ceph 配置文件中指定的 PG 数. 如果你允许 Ceph 对象网关自动新建资源池，请确保你首先定义好了合理的默认 PG 值. 查看 [资源池配置](http://docs.ceph.org.cn/rados/configuration/pool-pg-config-ref/) 获取详细信息.

关于 Ceph 认证请参考[用户管理](http://docs.ceph.org.cn/rados/operations/user-management)。

1. 为每一个实例生成一个 Ceph 对象网关用户名和key. 举一个典型实例, 我们将使用 `client.radosgw` 后使用 `gateway` 作为用户名:

   ```
   sudo ceph auth get-or-create client.radosgw.gateway osd 'allow rwx' mon 'allow rwx' -o /etc/ceph/ceph.client.radosgw.keyring
   ```

2. 分发生成的keyring到网关实例所在节点.

   ```
   sudo scp /etc/ceph/ceph.client.radosgw.keyring  ceph@{hostname}:/home/ceph
   ssh {hostname}
   sudo mv ceph.client.radosgw.keyring /etc/ceph/ceph.client.radosgw.keyring
   ```

   Note

   如果 `admin node` 就是 `gateway host` ，那第 2 步就没必要。

## 创建存储池

Ceph 对象网关需要 Ceph 存储集群资源池来存储特定的网关数据. 如果你新建的用户有权限, 网关将会自动新建所需资源池. 然而,你需要确保在你的 Ceph 配置文件中给资源池设置了合理的默认 PG 值.

Note

Ceph 对象网关有多个存储池，考虑到所有存储池会共用相同的 CRUSH 分级结构，所以 PG 数不要设置得过大，否则会影响性能。

当使用默认的 region 和 zone 时,资源池的命名规则通常省略了 region 和 zone 的名字，但是你可以使用任何你想要的命名规则. 举例如下:

- `.rgw`
- `.rgw.root`
- `.rgw.control`
- `.rgw.gc`
- `.rgw.buckets`
- `.rgw.buckets.index`
- `.rgw.buckets.extra`
- `.log`
- `.intent-log`
- `.usage`
- `.users`
- `.users.email`
- `.users.swift`
- `.users.uid`

查看 [配置参考——存储池](http://docs.ceph.org.cn/radosgw/config-ref#pools) 获取关于网关默认资源池的详细信息. 查看 [资源池](http://docs.ceph.org.cn/rados/operations/pools) 获取新建资源池的详细信息. 正如前面所说，如果具备写权限,Ceph 对象网关将会自动新建资源池. 如果想手动新建资源池,执行下面的命令:

```
ceph osd pool create {poolname} {pg-num} {pgp-num} {replicated | erasure} [{erasure-code-profile}]  {ruleset-name} {ruleset-number}
```

Tip

Ceph 允许多级 CRUSH 和多种 CRUSH 规则集，这样在配置你自己的网关时就有很大的灵活性。像 `rgw.buckets.index` 这样的存储池就可以利用 SSD 来做存储池以获取高性能；后端存储也可以从更经济的纠删编码的存储中获益，还可利用缓存层提升性能。

完成上述步骤之后，执行下列的命令确认前述存储池都已经创建了：

```
rados lspools
```

## 为 Ceph 新增网关配置

添加 Ceph 对象网关配置到 `admin node` 节点的 Ceph 配置文件中. Ceph 对象网关配置需要你指定 Ceph 对象网关实例. 然后你必须指定你安装有 Ceph  对象网关守护进程的节点的主机名, 一个 keyring (为了使用 cephx), FastCGI 的 socket 路径和日志文件.

对于使用 Apache 2.2 和 Apache 2.4 早期版本 (RHEL 6, Ubuntu 12.04, 14.04 etc) 的发行版, 追加下面的配置到 `admin node` 的文件 `/etc/ceph/ceph.conf` 中:

```
[client.radosgw.gateway]
host = {hostname}
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw socket path = ""
log file = /var/log/radosgw/client.radosgw.gateway.log
rgw frontends = fastcgi socket_port=9000 socket_host=0.0.0.0
rgw print continue = false
```

Note

Apache 2.2 和早期 Apache 2.4 版本不使用 Unix Domain Sockets 而是用 localhost TCP.

对于使用 Apache 2.4.9 或者更新版版本的发行版 (RHEL 7, CentOS 7 等), 追加下面的配置到 `admin node` 的文件 `/etc/ceph/ceph.conf` 中:

```
[client.radosgw.gateway]
host = {hostname}
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
log file = /var/log/radosgw/client.radosgw.gateway.log
rgw print continue = false
```

Note

`Apache 2.4.9` 支持 Unix Domain Socket (UDS) ，但是 `Ubuntu 14.04` 附带的 `Apache 2.4.7` 不支持 UDS ,并且默认配置使用 localhost TCP. 在``Ubuntu 14.04`` 中的 `Apache 2.4.7` 已经发现一个 bug ，并且已经申请一个补丁以支持 UDS. 查看: [Ubuntu Trusty 中支持 UDS 的补丁](https://bugs.launchpad.net/ubuntu/+source/apache2/+bug/1411030)

这里, `{hostname}` 是即将提供网关服务的节点的主机名 ( `hostname -s` 命令的输出), 比如 `gateway host`. 网关实例的 `[client.radosgw.gateway]` 部分标识了 Ceph 配置文件的这个部分是用来配置 Ceph 存储集群的一个客户端的，这个客户端的类型是 Ceph 对象网关 (比如, `radosgw`).

Note

配置文件的最后一行 `rgw print continue = false` 是用来避免 `PUT` 操作可能出现的问题.

一旦你完成了这些安装过程, 如果你所做的配置遇到了问题, 你可以在 Ceph 配置文件的 `[global]` 部分添加调试选项, 然后重启你的网关来帮忙排错,找到可能的配置问题. 举例如下:

```
[global]
#append the following in the global section.
debug ms = 1
debug rgw = 20
```

## 分发更新后的 Ceph 配置文件

更新后的 Ceph 配置文件需要从 `admin node` 分发到 Ceph 集群节点上.

它包含以下步骤:

1. 将更新后 `ceph.conf` 从 `/etc/ceph/` 目录拷贝到管理节点上新建集群时的根目录中 (比如. `my-cluster` 目录). 因此 `my-cluster` 中``ceph.conf`` 将会被覆盖. 为此,执行下面的命令:

   ```
   ceph-deploy --overwrite-conf config pull {hostname}
   ```

   这里, `{hostname}` 是 Ceph 管理节点的精简主机名.

2. 将更新后 `ceph.conf` f文件从管理节点推送到集群中其他所有节点，包含 `gateway host`:

   ```
   ceph-deploy --overwrite-conf config push [HOST] [HOST...]
   ```

   使用其他 Ceph 节点的主机名代替上面命令中的 `[HOST] [HOST...]`.

## 从管理节点拷贝 ceph.client.admin.keyring 到网关主机

因为 `gateway host` 有可能是集群之外的其他节点,所以需要将 `ceph.client.admin.keyring` 从 `admin node` 拷贝到 `gateway host`. 为此,在 `admin node` 上执行下面的命令:

```
sudo scp /etc/ceph/ceph.client.admin.keyring  ceph@{hostname}:/home/ceph
ssh {hostname}
sudo mv ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring
```

Note

如果你的 `admin node` 就是 `gateway host` 则无需执行上面的步骤.

## 新建数据目录

部署脚本不会创建默认的 Ceph 对象网关数据目录. 因此需要为每一个 `radosgw` 守护进程实例新建数据目录. Ceph 配置文件中的 `host` 变量决定了在哪一个主机上运行 `radosgw` 守护进程实例.数据目录的典型命名规则是指定 `radosgw` 守护进程,集群名和守护进程 ID.

执行下面的命令在 `gateway host` 上新建所需的数据目录:

```
sudo mkdir -p /var/lib/ceph/radosgw/ceph-radosgw.gateway
```

## 调整 Socket 目录权限

在一些发行版中, `radosgw` 守护进程是以没有什么权利的 UID 为 `apache` 的用户运行的, 但是这个 UID 必须在运行时写入 socket 文件的目录中具备写权限.

在 `gateway host` 上执行下面的命令来给上述 UID 授予默认 socket 位置的权限:

```
sudo chown apache:apache /var/run/ceph
```

## 改变日志文件所有者

在一些发行版中, `radosgw` 守护进程是以没有什么权利的 UID 为 `apache` 的用户运行的, 但是日志文件默认是 `root` 用户所有的. 你必须日志文件的将所有者修改 `apache` 用户,以便 Apache 可以在这里写入日志文件. 为此，执行下面的命令:

```
sudo chown apache:apache /var/log/radosgw/client.radosgw.gateway.log
```

## 启动 radosgw 服务

Ceph 对象网关守护进程需要启动. 为此，在 `gateway host` 上执行下面的命令:

在基于 Debian 的发行版上:

```
sudo /etc/init.d/radosgw start
```

在基于 RPM 的发行版上:

```
sudo /etc/init.d/ceph-radosgw start
```

## 新建一个网关配置文件

在你安装了 Ceph 对象网关的主机上, 比如 `gateway host`, 新建一个 `rgw.conf` 文件, 对于 `Debian-based` 发行版将该文件放在 `/etc/apache2/conf-available` 目录下,对于 `RPM-based` 发行版则将其放在 `/etc/httpd/conf.d` 目录下. 这个是 `radosgw` 所需的一个 Apache 配置文件. 对于 web 服务器而言这个文件必须是可读的.

按照下面的步骤执行:

1. 新建文件:

   对于基于 Debian 的发行版, 执行:

   ```
   sudo vi /etc/apache2/conf-available/rgw.conf
   ```

   对于基于 RPM 的发行版, 执行:

   ```
   sudo vi /etc/httpd/conf.d/rgw.conf
   ```

2. 对于使用 Apache 2.2 或者 Apache 2.4 早期版本的使用 localhost TCP 并且不支持 Unix Domain Socket 的发行版而言，添加下面的内容到该文件中:

   ```
   <VirtualHost *:80>
   ServerName localhost
   DocumentRoot /var/www/html
   
   ErrorLog /var/log/httpd/rgw_error.log
   CustomLog /var/log/httpd/rgw_access.log combined
   
   # LogLevel debug
   
   RewriteEngine On
   
   RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
   
   SetEnv proxy-nokeepalive 1
   
   ProxyPass / fcgi://localhost:9000/
   
   </VirtualHost>
   ```

   Note

   For Debian-based distros replace `/var/log/httpd/` with `/var/log/apache2`.

3. 对于使用 Apache 2.4.9 或者更新版本的支持 Unix Domain Socket 的发行版而言，添加下面的内容到该文件中 add the following contents to the file:

   ```
   <VirtualHost *:80>
   ServerName localhost
   DocumentRoot /var/www/html
   
   ErrorLog /var/log/httpd/rgw_error.log
   CustomLog /var/log/httpd/rgw_access.log combined
   
   # LogLevel debug
   
   RewriteEngine On
   
   RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
   
   SetEnv proxy-nokeepalive 1
   
   ProxyPass / unix:///var/run/ceph/ceph.radosgw.gateway.fastcgi.sock|fcgi://localhost:9000/
   
   </VirtualHost>
   ```

## 重启 Apache

Apache 服务需要重启来加载新的配置文件.

对于基于 Debian 的发行版, 执行:

```
sudo service apache2 restart
```

对于基于 RPM 的发行版, 执行:

```
sudo service httpd restart
```

或者:

```
sudo systemctl restart httpd
```

## 使用网关

为了使用 REST 接口, 首先需要为 S3 接口初始化一个 Ceph 对象网关用户. 然后为 Swift 接口新建一个子用户. 查看 [管理手册](http://docs.ceph.org.cn/radosgw/admin) 获取有关用户管理的详细信息.

### 为 S3 访问新建一个  radosgw 用户

A `radosgw` 用户需要新建并且赋予访问权限. 命令 `man radosgw-admin` 将展示提供更多额外的命令选项信息.

为了新建用户, 在 `gateway host` 上执行下面的命令:

```
sudo radosgw-admin user create --uid="testuser" --display-name="First User"
```

上述命令的输出结果类似下面这样:

```
{"user_id": "testuser",
"display_name": "First User",
"email": "",
"suspended": 0,
"max_buckets": 1000,
"auid": 0,
"subusers": [],
"keys": [
{ "user": "testuser",
"access_key": "I0PJDPCIYZ665MW88W9R",
"secret_key": "dxaXZ8U90SXydYzyS5ivamEP20hkLSUViiaR+ZDA"}],
"swift_keys": [],
"caps": [],
"op_mask": "read, write, delete",
"default_placement": "",
"placement_tags": [],
"bucket_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"user_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"temp_url_keys": []}
```

Note

`keys->access_key` 和 `keys->secret_key` 两个值在访问时是必需的，用来验证。

### 创建一个 Swift 用户

如果要通过 Swift 访问，必须创建一个 Swift 子用户。需要分两步完成，第一步是创建用户，第二步创建密钥。

在 `gateway host` 主机上进行如下操作：

创建 Swift 用户：

```
sudo radosgw-admin subuser create --uid=testuser --subuser=testuser:swift --access=full
```

此命令的输出类似如下：

```
{ "user_id": "testuser",
"display_name": "First User",
"email": "",
"suspended": 0,
"max_buckets": 1000,
"auid": 0,
"subusers": [
{ "id": "testuser:swift",
"permissions": "full-control"}],
"keys": [
{ "user": "testuser:swift",
"access_key": "3Y1LNW4Q6X0Y53A52DET",
"secret_key": ""},
{ "user": "testuser",
"access_key": "I0PJDPCIYZ665MW88W9R",
"secret_key": "dxaXZ8U90SXydYzyS5ivamEP20hkLSUViiaR+ZDA"}],
"swift_keys": [],
"caps": [],
"op_mask": "read, write, delete",
"default_placement": "",
"placement_tags": [],
"bucket_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"user_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"temp_url_keys": []}
```

创建用户的密钥：

```
sudo radosgw-admin key create --subuser=testuser:swift --key-type=swift --gen-secret
```

此命令的输出类似如下：

```
{ "user_id": "testuser",
"display_name": "First User",
"email": "",
"suspended": 0,
"max_buckets": 1000,
"auid": 0,
"subusers": [
{ "id": "testuser:swift",
"permissions": "full-control"}],
"keys": [
{ "user": "testuser:swift",
"access_key": "3Y1LNW4Q6X0Y53A52DET",
"secret_key": ""},
{ "user": "testuser",
"access_key": "I0PJDPCIYZ665MW88W9R",
"secret_key": "dxaXZ8U90SXydYzyS5ivamEP20hkLSUViiaR+ZDA"}],
"swift_keys": [
{ "user": "testuser:swift",
"secret_key": "244+fz2gSqoHwR3lYtSbIyomyPHf3i7rgSJrF\/IA"}],
"caps": [],
"op_mask": "read, write, delete",
"default_placement": "",
"placement_tags": [],
"bucket_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"user_quota": { "enabled": false,
"max_size_kb": -1,
"max_objects": -1},
"temp_url_keys": []}
```

## 访问验证

然后你得验证一下刚创建的用户是否能访问网关。

### 测试 S3 访问

你需要写一个 Python 测试脚本,并运行它以验证 S3 访问. S3 访问测试脚本将会连接 `radosgw`, 然后新建一个新的 bucket 再列出所有的 buckets.`aws_access_key_id` 和 `aws_secret_access_key` 的值就是前面`radosgw_admin` 命令的返回值中的 `access_key` 和 `secret_key`.

执行下面的步骤:

1. 首先你需要安装 `python-boto` 包.

   对于基于 Debian 的发行版请执行:

   ```
   sudo apt-get install python-boto
   ```

   对于基于 RPM 的发行版请执行:

   ```
   sudo yum install python-boto
   ```

2. 新建 Python 脚本:

   ```
   vi s3test.py
   ```

3. 添加下面的内容到该文件中:

   ```
   import boto
   import boto.s3.connection
   access_key = 'I0PJDPCIYZ665MW88W9R'
   secret_key = 'dxaXZ8U90SXydYzyS5ivamEP20hkLSUViiaR+ZDA'
   conn = boto.connect_s3(
   aws_access_key_id = access_key,
   aws_secret_access_key = secret_key,
   host = '{hostname}',
   is_secure=False,
   calling_format = boto.s3.connection.OrdinaryCallingFormat(),
   )
   bucket = conn.create_bucket('my-new-bucket')
   for bucket in conn.get_all_buckets():
           print "{name}\t{created}".format(
                   name = bucket.name,
                   created = bucket.creation_date,
   )
   ```

   将 `{hostname}` 替换为你配置了网关服务的主机的主机名,比如 `gateway host`.

4. 运行这个脚本:

   ```
   python s3test.py
   ```

   输出类似下面的内容:

   ```
   my-new-bucket 2015-02-16T17:09:10.000Z
   ```

### 测试 swift 访问

Swift 访问能够通过 `swift` 命令行客户端来验证. 命令 `man swift` 将提供更多、 可用命令行选项的详细信息.

执行下面的命令安装``swift`` 客户端:

> 对于基于 Debian 的发行版:
>
> ```
> sudo apt-get install python-setuptools
> sudo easy_install pip
> sudo pip install --upgrade setuptools
> sudo pip install --upgrade python-swiftclient
> ```
>
> 对于基于 RPM 的发行版:
>
> ```
> sudo yum install python-setuptools
> sudo easy_install pip
> sudo pip install --upgrade setuptools
> sudo pip install --upgrade python-swiftclient
> ```

执行下面的命令验证 swift 访问:

```
swift -A http://{IP ADDRESS}/auth/1.0 -U testuser:swift -K ‘{swift_secret_key}’ list
```

将其中的 `{IP ADDRESS}` 替换为网关服务器的外网访问IP地址,将 `{swift_secret_key}` 替换为为 `swift` 用户所执行的 `radosgw-admin key create` 命令的输出.

举例如下:

```
swift -A http://10.19.143.116/auth/1.0 -U testuser:swift -K ‘244+fz2gSqoHwR3lYtSbIyomyPHf3i7rgSJrF/IA’ list
```

输出如下:

```
my-new-bucket
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - 简单配置
    - [新建用户和 Keyring](http://docs.ceph.org.cn/radosgw/config/#keyring)
    - [创建存储池](http://docs.ceph.org.cn/radosgw/config/#id1)
    - [为 Ceph 新增网关配置](http://docs.ceph.org.cn/radosgw/config/#id2)
    - [分发更新后的 Ceph 配置文件](http://docs.ceph.org.cn/radosgw/config/#id3)
    - [从管理节点拷贝 ceph.client.admin.keyring 到网关主机](http://docs.ceph.org.cn/radosgw/config/#ceph-client-admin-keyring)
    - [新建数据目录](http://docs.ceph.org.cn/radosgw/config/#id4)
    - [调整 Socket 目录权限](http://docs.ceph.org.cn/radosgw/config/#socket)
    - [改变日志文件所有者](http://docs.ceph.org.cn/radosgw/config/#id5)
    - [启动 radosgw 服务](http://docs.ceph.org.cn/radosgw/config/#radosgw)
    - [新建一个网关配置文件](http://docs.ceph.org.cn/radosgw/config/#id6)
    - [重启 Apache](http://docs.ceph.org.cn/radosgw/config/#apache)
    - 使用网关
      - [为 S3 访问新建一个  radosgw 用户](http://docs.ceph.org.cn/radosgw/config/#s3-radosgw)
      - [创建一个 Swift 用户](http://docs.ceph.org.cn/radosgw/config/#swift)
    - 访问验证
      - [测试 S3 访问](http://docs.ceph.org.cn/radosgw/config/#s3)
      - [测试 swift 访问](http://docs.ceph.org.cn/radosgw/config/#id9)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/federated-config/) |
- ​          [previous](http://docs.ceph.org.cn/install/install-ceph-gateway/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/config-ref/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/config/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 联盟网关的配置

New in version 0.67: Dumpling

Ceph 从 0.67 Dumpling 起支持加入 [*Ceph 对象网关*](http://docs.ceph.org.cn/glossary/#term-34)联盟，可加入多个 region 、或一个 region 内的多个域。

- **Region**: region 是地理空间的*逻辑*划分，它包含一个或多个域。一个包含多个 region 的集群必须指定一个主 region 。
- **Zone**: 域是一个或多个 Ceph 对象网关例程的*逻辑*分组。每个 region 有一个主域处理客户端请求。

Important

你可以从二级域读取对象，但只能写入 region 内的主域。当前，网关程序不会禁止你写入二级域，但是，**别那样干！**

## 背景

当你部署一个跨地理时区的 [*Ceph 对象存储*](http://docs.ceph.org.cn/glossary/#term-30)服务时，即使 Ceph 对象网关例程运行在不同的地理时区、甚至不同的 Ceph 集群上，使用 Ceph 对象网关 region  功能和元数据同步代理都能实现全局统一的命名空间。如果你想多保留一个（或多个）数据副本，可以把一个 region 内的一或多个 Ceph  对象网关例程拆分到多个逻辑容器，然后配置 Ceph  对象网关域和数据同步代理，这样你就能多拥有一份或多份主域的数据副本了。额外的数据副本对于故障转移、备份和灾难恢复是很重要的。

如果你有低延时的网络连接（并非建议），可以把 Ceph 存储集群配置为联盟模式的单体集群。也可以在每 region 部署一套 Ceph  存储集群，然后把各存储池划分进各个域（典型部署）。如果资源充足、且冗余性要求严格，你也可以在每个域都部署一个独立的 Ceph 存储集群。

## 关于本指南

下面我们将演示如何用两个逻辑步骤配置联盟集群：

- **配置主 region ：** 这一段描述了如何配置起包含多个域的一个 region ，以及如何同步主 region 内的主域和各二级域。
- **配置二级 region ：** 这一段描述了如何重复前一段再配置一个包含多个域的主 region ，这样你就有了两个 region ，而且都实现了 region 内同步。最后，你会了解到如何配置元数据同步代理，以此统一各 region 命名空间。

## 配置主 region

本段提供的典型步骤可帮你配置起包含两个域的 region ，此集群将包含两个网关守护进程例程——每域一个。此 region 将作为主 region 。

### 为主 region 命名

配置集群前，规划良好的 region 、域和例程名字可帮你更好地管理集群。假设此 region 代表美国，那我们就引用她的标准缩写。

- United States: `us`

假设各域分别为美国的东部和西部，为保持连贯性，命名将采用 `{region name}-{zone name}` 格式，但你可以用自己喜欢的命名规则。

- United States, East Region: `us-east`
- United States, West Region: `us-west`

最后，我们假设每个域都配置了至少一个 Ceph 对象网关例程，为保持连贯性，我们将按 `{region name}-{zone name}-{instance}` 格式命名，但你可以用自己喜欢的命名规则。

- United States Region, Master Zone, Instance 1: `us-east-1`
- United States Region, Secondary Zone, Instance 1: `us-west-1`

### 创建存储池

你可以把整个 region 配置为一个 Ceph 存储集群，也可以把各个域都配置为一个 Ceph 存储集群。

为保持连贯性，我们将按照 `{region name}-{zone name}` 格式命名，并把它作为存储池名的前缀，但你可以用自己喜欢的命名规则。例如：

- `.us-east.rgw`
- `.us-east.rgw.root`
- `.us-east.rgw.control`
- `.us-east.rgw.gc`
- `.us-east.rgw.buckets`
- `.us-east.rgw.buckets.index`
- `.us-east.rgw.buckets.extra`
- `.us-east.log`
- `.us-east.intent-log`
- `.us-east.usage`
- `.us-east.users`
- `.us-east.users.email`
- `.us-east.users.swift`
- `.us-east.users.uid`

- `.us-west.rgw`
- `.us-west.rgw.root`
- `.us-west.rgw.control`
- `.us-west.rgw.gc`
- `.us-west.rgw.buckets`
- `.us-west.rgw.buckets.index`
- `.us-west.rgw.buckets.extra`
- `.us-west.log`
- `.us-west.intent-log`
- `.us-west.usage`
- `.us-west.users`
- `.us-west.users.email`
- `.us-west.users.swift`
- `.us-west.users.uid`

关于网关的默认存储池请参考[配置参考——存储池](http://docs.ceph.org.cn/radosgw/config-ref#pools)。关于创建存储池见[存储池](http://docs.ceph.org.cn/rados/operations/pools)。用下列命令创建存储池：

```
ceph osd pool create {poolname} {pg-num} {pgp-num} {replicated | erasure} [{erasure-code-profile}] {ruleset-name} {ruleset-number}
```

Tip

创建大量存储池时，集群回到 `active + clean` 状态可能需要较多的时间。

CRUSH 图

把整个 region 配置为单个 Ceph 存储集群时，请考虑单独为域使用 CRUSH 规则，这样就不会有重叠的故障域了。详情见 [CRUSH 图](http://docs.ceph.org.cn/rados/operations/crush-map)。

Ceph 允许多级 CRUSH 和多种 CRUSH 规则集，这样在配置你自己的网关时就有很大的灵活性。像 `rgw.buckets.index` 这样的存储池就可以利用副本数适当的 SSD 存储池取得高性能；后端存储也可以从更经济的纠删编码的存储中获益，还可能利用缓存层提升性能。

完成这一步后，执行下列命令以确认你已经创建了前述所需的存储池：

```
rados lspools
```

### 创建密钥环

各例程都必须有用户名和密钥才能与 Ceph 存储集群通信。在下面几步，我们用管理节点创建密钥环，然后为各例程创建客户端用户名及其密钥，再把这些密钥加入 Ceph 存储集群，最后，把密钥环分别发布给各网关节点。

1. 创建密钥环。

   ```
   sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.radosgw.keyring
   sudo chmod +r /etc/ceph/ceph.client.radosgw.keyring
   ```

2. 为各例程生成 Ceph 对象网关用户名及其密钥。

   ```
   sudo ceph-authtool /etc/ceph/ceph.client.radosgw.keyring -n client.radosgw.us-east-1 --gen-key
   sudo ceph-authtool /etc/ceph/ceph.client.radosgw.keyring -n client.radosgw.us-west-1 --gen-key
   ```

3. 给各密钥增加能力，允许到监视器的写权限、允许创建存储池，详情见[配置参考——存储池](http://docs.ceph.org.cn/radosgw/config-ref#pools)。

   ```
   sudo ceph-authtool -n client.radosgw.us-east-1 --cap osd 'allow rwx' --cap mon 'allow rwx' /etc/ceph/ceph.client.radosgw.keyring
   sudo ceph-authtool -n client.radosgw.us-west-1 --cap osd 'allow rwx' --cap mon 'allow rwx' /etc/ceph/ceph.client.radosgw.keyring
   ```

4. 创建密钥环及密钥，并授权 Ceph 对象网关访问 Ceph 存储集群之后，还需把各密钥导入存储集群。例如：

   ```
   sudo ceph -k /etc/ceph/ceph.client.admin.keyring auth add client.radosgw.us-east-1 -i /etc/ceph/ceph.client.radosgw.keyring
   sudo ceph -k /etc/ceph/ceph.client.admin.keyring auth add client.radosgw.us-west-1 -i /etc/ceph/ceph.client.radosgw.keyring
   ```

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。创建主 region 和二级 region **后**，你一共会拥有四个用户。

### 安装 Apache 和 FastCGI

每个运行 [*Ceph 对象网关*](http://docs.ceph.org.cn/glossary/#term-34)守护进程例程的 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)都必须安装 Apache 、 FastCGI 、 Ceph 对象网关守护进程（ `radosgw` ），还有 Ceph 对象网关同步代理（ `radosgw-agent` ）。详情见[安装 Ceph 对象网关](http://docs.ceph.org.cn/install/install-ceph-gateway)。

### 创建数据目录

分别为各主机上的各个守护进程例程创建数据目录。

```
ssh {us-east-1}
sudo mkdir -p /var/lib/ceph/radosgw/ceph-radosgw.us-east-1

ssh {us-west-1}
sudo mkdir -p /var/lib/ceph/radosgw/ceph-radosgw.us-west-1
```

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。创建主 region 和二级 region **后**，你一共会拥有四个用户。

### 创建网关配置

在装了 Ceph 对象网关守护进程的主机上，为各例程创建 Ceph 对象网关配置文件，并放到 `/etc/apache2/sites-available` 目录下。典型的网关配置见下文：

```
FastCgiExternalServer /var/www/s3gw.fcgi -socket /{path}/{socket-name}.sock


<VirtualHost *:80>

	ServerName {fqdn}
	<!--Remove the comment. Add a server alias with *.{fqdn} for S3 subdomains-->
	<!--ServerAlias *.{fqdn}-->
	ServerAdmin {email.address}
	DocumentRoot /var/www
	RewriteEngine On
	RewriteRule  ^/(.*) /s3gw.fcgi?%{QUERY_STRING} [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]

	<IfModule mod_fastcgi.c>
   	<Directory /var/www>
			Options +ExecCGI
			AllowOverride All
			SetHandler fastcgi-script
			Order allow,deny
			Allow from all
			AuthBasicAuthoritative Off
		</Directory>
	</IfModule>

	AllowEncodedSlashes On
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
	ServerSignature Off

</VirtualHost>
```

1. 把 `/{path}/{socket-name}` 条目分别替换为套接字的路径和名字，例如 `/var/run/ceph/client.radosgw.us-east-1.sock` ，确保 `ceph.conf` 里也要写入相同的套接字路径和名字。
2. 用服务器的全资域名替换 `{fqdn}` 条目。
3. 用服务器管理员的邮件地址替换 `{email.address}` 条目。
4. 如果你想用 S3 风格的子域，需添加 `ServerAlias` 配置（当然想）。
5. 把这些配置另存到一文件，如 `rgw-us-east.conf` 。

在二级域上重复这些步骤，如 `rgw-us-west.conf` 。

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。创建主 region 和二级 region **后**，你一共会拥有四个用户。

最后，如果你想启用 SSL ，确保端口要设置为 SSL 端口（通常是 443 ），而且配置文件要包含这些：

```
SSLEngine on
SSLCertificateFile /etc/apache2/ssl/apache.crt
SSLCertificateKeyFile /etc/apache2/ssl/apache.key
SetEnv SERVER_PORT_SECURE 443
```

### 启用配置

启用各例程的网关配置、并禁用默认站点。

1. 启用网关站点配置。

   ```
   sudo a2ensite {rgw-conf-filename}
   ```

2. 禁用默认站点。

   ```
   sudo a2dissite default
   ```

Note

默认站点禁用失败会导致其他问题。

### 添加 FastCGI 脚本

要启用 S3 兼容接口，各 Ceph 对象网关例程都需要一个 FastCGI 脚本。按如下过程创建此脚本。

1. 进入 `/var/www` 目录。

   ```
   cd /var/www
   ```

2. 用编辑器打开名为 `s3gw.fcgi` 的文件。**注：**配置文件里也要指定此文件名。

   ```
   sudo vim s3gw.fcgi
   ```

3. 添加 shell 脚本头，然后是 `exec` 、网关的二进制文件、 Ceph 配置文件路径、还有用户名（ `-n` 所指，就是[创建密钥环](http://docs.ceph.org.cn/radosgw/federated-config/#id6)里第二步所创建的），把下面的复制进编辑器。

   ```
   #!/bin/sh
   exec /usr/bin/radosgw -c /etc/ceph/ceph.conf -n client.radosgw.{ID}
   ```

   例如：

   ```
   #!/bin/sh
   exec /usr/bin/radosgw -c /etc/ceph/ceph.conf -n client.radosgw.us-east-1
   ```

4. 保存文件。

5. 增加可执行权限。

   ```
   sudo chmod +x s3gw.fcgi
   ```

在二级域上重复以上步骤。

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。创建主 region 和二级 region **后**，你一共会拥有四个 FastCGI 脚本。

### 把各例程加入 Ceph 配置文件

在管理节点上，把各例程的配置写入 Ceph 存储集群的配置文件。例如：

```
...

[client.radosgw.us-east-1]
rgw region = us
rgw region root pool = .us.rgw.root
rgw zone = us-east
rgw zone root pool = .us-east.rgw.root
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw dns name = {hostname}
rgw socket path = /var/run/ceph/$name.sock
host = {host-name}

[client.radosgw.us-west-1]
rgw region = us
rgw region root pool = .us.rgw.root
rgw zone = us-west
rgw zone root pool = .us-west.rgw.root
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw dns name = {hostname}
rgw socket path = /var/run/ceph/$name.sock
host = {host-name}
```

然后，把更新过的 Ceph 配置文件推送到各 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)如：

```
ceph-deploy --overwrite-conf config push {node1} {node2} {nodex}
```

Note

按照以上步骤配置二级 region 时，需把 region 、存储池和域的名字都从 `us` 替换为 `eu` 。创建主 region 和二级 region **后**，你一共会有四条类似配置。

### 创建 region

1. 为 `us` region 创建个 region 配置文件，名为 `us.json` 。

   把下列实例的内容复制进文本编辑器，把 `is_master` 设置为 `true` ，用终结点的全资域名替换 `{fqdn}` 。这样，主域就是 `us-east` ，另外 `zones` 列表中还会有 `us-west` 。详情见[配置参考——region](http://docs.ceph.org.cn/radosgw/config-ref#regions) 。

   ```
   { "name": "us",
     "api_name": "us",
     "is_master": "true",
     "endpoints": [
           "http:\/\/{fqdn}:80\/"],
     "master_zone": "us-east",
     "zones": [
           { "name": "us-east",
             "endpoints": [
                   "http:\/\/{fqdn}:80\/"],
             "log_meta": "true",
             "log_data": "true"},
           { "name": "us-west",
             "endpoints": [
                   "http:\/\/{fqdn}:80\/"],
             "log_meta": "true",
             "log_data": "true"}],
     "placement_targets": [
      {
        "name": "default-placement",
        "tags": []
      }
     ],
     "default_placement": "default-placement"}
   ```

2. 用刚刚创建的 `us.json` 输入文件创建 `us` region 。

   ```
   radosgw-admin region set --infile us.json --name client.radosgw.us-east-1
   ```

3. 删除默认 region （如果有的话）。

   ```
   rados -p .us.rgw.root rm region_info.default
   ```

4. 把 `us` region 设置为默认 region 。

   ```
   radosgw-admin region default --rgw-region=us --name client.radosgw.us-east-1
   ```

   一套集群只能有一个默认 region 。

5. 更新 region 图。

   ```
   radosgw-admin regionmap update --name client.radosgw.us-east-1
   ```

如果你把 region 配置到不同的 Ceph 存储集群上，可以加 `--name client.radosgw-us-west-1` 选项重复上述的第二、四、五步。也可以从初始网关例程导出 region 图，并按更新步骤导入。

Note

按照以上步骤配置二级 region 时，需把 `us` 替换为 `eu` 。创建主 region 和二级 region **后**，你一共会有两个 region 。

### 创建域

1. 为 `us-east` 域创建名为 `us-east.json` 的配置导入文件。

   把以下实例的内容复制到文本编辑器。本配置里的存储池名字用 region 名和域名作为前缀。关于网关存储池见[配置参考——存储池](http://docs.ceph.org.cn/radosgw/config-ref#pools)，关于域请参考[配置参考——域](http://docs.ceph.org.cn/radosgw/config-ref#zones)。

   ```
   { "domain_root": ".us-east.rgw",
     "control_pool": ".us-east.rgw.control",
     "gc_pool": ".us-east.rgw.gc",
     "log_pool": ".us-east.log",
     "intent_log_pool": ".us-east.intent-log",
     "usage_log_pool": ".us-east.usage",
     "user_keys_pool": ".us-east.users",
     "user_email_pool": ".us-east.users.email",
     "user_swift_pool": ".us-east.users.swift",
     "user_uid_pool": ".us-east.users.uid",
     "system_key": { "access_key": "", "secret_key": ""},
     "placement_pools": [
       { "key": "default-placement",
         "val": { "index_pool": ".us-east.rgw.buckets.index",
                  "data_pool": ".us-east.rgw.buckets",
                  "data_extra_pool": ".us-east.rgw.buckets.extra"}
       }
     ]
   }
   ```

2. 把刚创建的 `us-east` 域的配置文件 `us-east.json` 加入东部和西部的存储池，需分别指定其用户名（即 `--name` ）。

   ```
   radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.us-east-1
   radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.us-west-1
   ```

   重复步骤一，为 `us-west` 创建配置导入文件，然后把 `us-east.json` 加入东部和西部的存储池，需分别指定其用户名（即 `--name` ）。

   ```
   radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.us-east-1
   radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.us-west-1
   ```

3. 删除默认域（如果有的话）。

   ```
   rados -p .rgw.root rm zone_info.default
   ```

4. 更新 region 图。

   ```
   radosgw-admin regionmap update --name client.radosgw.us-east-1
   ```

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。在各 region 创建完主域和二级域**后**，你一共会有四个域。

### 创建域用户

Ceph 对象网关的域用户存储在域存储池中，所以配置完域之后还必须创建域用户。为各用户填充 `access_key` 和 `secret_key` 字段，然后再次更新域配置信息。

```
radosgw-admin user create --uid="us-east" --display-name="Region-US Zone-East" --name client.radosgw.us-east-1 --system --gen-access-key --gen-secret
radosgw-admin user create --uid="us-west" --display-name="Region-US Zone-West" --name client.radosgw.us-west-1 --system --gen-access-key --gen-secret
```

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。在各 region 创建完主域和二级域**后**，你一共会有四个域用户。这些用户不同于[创建密钥环](http://docs.ceph.org.cn/radosgw/federated-config/#id6)那里创建的用户。

### 更新域配置

必须以域用户身份更新域配置，这样同步代理才能通过域的认证。

1. 打开 `us-east.json` 域配置文件，把创建域用户时输出的 `access_key` 和 `secret_key` 的内容粘帖进配置文件的 `system_key` 字段。

   ```
   { "domain_root": ".us-east.rgw",
     "control_pool": ".us-east.rgw.control",
     "gc_pool": ".us-east.rgw.gc",
     "log_pool": ".us-east.log",
     "intent_log_pool": ".us-east.intent-log",
     "usage_log_pool": ".us-east.usage",
     "user_keys_pool": ".us-east.users",
     "user_email_pool": ".us-east.users.email",
     "user_swift_pool": ".us-east.users.swift",
     "user_uid_pool": ".us-east.users.uid",
     "system_key": {
       "access_key": "{paste-access_key-here}",
       "secret_key": "{paste-secret_key-here}"
            },
     "placement_pools": [
       { "key": "default-placement",
         "val": { "index_pool": ".us-east.rgw.buckets.index",
                  "data_pool": ".us-east.rgw.buckets",
                  "data_extra_pool": ".us-east.rgw.buckets.extra"}
       }
     ]
   }
   ```

2. 保存 `us-east.json` 文件，然后更新域配置文件。

   ```
   radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.us-east-1
   radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.us-west-1
   ```

3. 重复步骤一更新 `us-west` 的域配置文件，然后更新域配置。

   ```
   radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.us-east-1
   radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.us-west-1
   ```

Note

按照以上步骤配置二级 region 时，需把 `us-` 替换为 `eu-` 。在各 region 创建完主域和二级域**后**，你一共会有四个域。

### 重启服务

再次发布 Ceph 配置文件后，我们建议重启 Ceph 存储集群和 Apache 例程。

对于 Ubuntu ，可在各 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)上执行此命令：

```
sudo restart ceph-all
```

对于 Red Hat/CentOS 是此命令：

```
sudo /etc/init.d/ceph restart
```

确保所有组件都重载了各自的配置，对于网关例程，我们建议重启 `apache2` 服务，例如：

```
sudo service apache2 restart
```

### 启动网关例程

启动 `radosgw` 服务。

```
sudo /etc/init.d/radosgw start
```

如果你在同一主机上运行了多个例程，那么还必须指定用户名。

```
sudo /etc/init.d/radosgw start --name client.radosgw.us-east-1
```

打开浏览器检查各域的终结点，向其域名发起一个简单的 HTTP 请求应该会得到下面的回应：

```
<ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <Owner>
                <ID>anonymous</ID>
                <DisplayName/>
        </Owner>
        <Buckets/>
</ListAllMyBucketsResult>
```

## 配置二级 region

本段所述的典型步骤可帮你配置起一个拥有多个 region 的集群。配置一个跨 region 集群要求维护一个全局命名空间，这样分布于不同 region 的对象名就不会存在命名空间冲突问题了。

本段对[配置主 region](http://docs.ceph.org.cn/radosgw/federated-config/#region) 里的步骤有所扩展，还更改了 region 名称、修改了一些步骤，详情见下文。

### 为二级 region 命名

配置集群前，规划良好的 region 、域和例程名字可帮你更好地管理集群。假设此 region 代表欧盟，那我们就引用她的标准缩写。

- European Union: `eu`

假设各域分别为欧盟的东部和西部，为保持连贯性，命名将采用 `{region name}-{zone name}` 格式，但你可以用自己喜欢的命名规则。

- European Union, East Region: `eu-east`
- European Union, West Region: `eu-west`

最后，我们假设每个域都配置了至少一个 Ceph 对象网关例程，为保持连贯性，我们将按 `{region name}-{zone name}-{instance}` 格式命名，但你可以用自己喜欢的命名规则。

- European Union Region, Master Zone, Instance 1: `eu-east-1`
- European Union Region, Secondary Zone, Instance 1: `eu-west-1`

### 二级 region 的配置

重复执行[配置主 region](http://docs.ceph.org.cn/radosgw/federated-config/#region) 里的典型步骤，不同之处如下：

1. 按照[为二级 region 命名](http://docs.ceph.org.cn/radosgw/federated-config/#id17)而非[为主 region 命名](http://docs.ceph.org.cn/radosgw/federated-config/#id4)。

2. [创建存储池](http://docs.ceph.org.cn/radosgw/federated-config/#id5)，用 `eu` 取代 `us` 。

3. [创建密钥环](http://docs.ceph.org.cn/radosgw/federated-config/#id6)及对应密钥，并用 `eu` 取代 `us` 。如果你想用同样的密钥环也可以，只要确保给此 region （或 region 和域）创建好密钥就行。

4. [安装 Apache 和 FastCGI](http://docs.ceph.org.cn/radosgw/federated-config/#apache-fastcgi).

5. [创建数据目录](http://docs.ceph.org.cn/radosgw/federated-config/#id7)，用 `eu` 取代 `us` 。

6. [创建网关配置](http://docs.ceph.org.cn/radosgw/federated-config/#id8)，把套接字名称里的 `eu` 替换为 `us` 。

7. [启用配置](http://docs.ceph.org.cn/radosgw/federated-config/#id9)。

8. [添加 FastCGI 脚本](http://docs.ceph.org.cn/radosgw/federated-config/#fastcgi)，把用户名里的 `eu` 替换为 `us` 。

9. [把各例程加入 Ceph 配置文件](http://docs.ceph.org.cn/radosgw/federated-config/#ceph)，把存储池名称里的 `eu` 替换为 `us` 。

10. [创建 region](http://docs.ceph.org.cn/radosgw/federated-config/#id10) ，用 `eu` 取代 `us` 。把 `is_master` 设置为 `false` ，为保持一致性，在二级 region 里也要创建主 region 。

    ```
    radosgw-admin region set --infile us.json --name client.radosgw.eu-east-1
    ```

11. [创建域](http://docs.ceph.org.cn/radosgw/federated-config/#id11)，用 `eu` 取代 `us` 。一定要换成正确的用户名（即 `--name` ），这样才会把域创建到正确的集群。

12. [更新域配置](http://docs.ceph.org.cn/radosgw/federated-config/#id13)，用 `eu` 取代 `us` 。

13. 在（所有？）二级 region 里，创建主 region 的各个域。

    ```
    radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.eu-east-1
    radosgw-admin zone set --rgw-zone=us-east --infile us-east.json --name client.radosgw.eu-west-1
    radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.eu-east-1
    radosgw-admin zone set --rgw-zone=us-west --infile us-west.json --name client.radosgw.eu-west-1
    ```

14. 在主 region 里，创建二级 region 的各个域。

    ```
    radosgw-admin zone set --rgw-zone=eu-east --infile eu-east.json --name client.radosgw.us-east-1
    radosgw-admin zone set --rgw-zone=eu-east --infile eu-east.json --name client.radosgw.us-west-1
    radosgw-admin zone set --rgw-zone=eu-west --infile eu-west.json --name client.radosgw.us-east-1
    radosgw-admin zone set --rgw-zone=eu-west --infile eu-west.json --name client.radosgw.us-west-1
    ```

15. [重启服务](http://docs.ceph.org.cn/radosgw/federated-config/#id14)。

16. [启动网关例程](http://docs.ceph.org.cn/radosgw/federated-config/#id15)。

## 多站点数据复制

数据同步代理会把主域数据复制到二级域。一个 region 的主域会自动选择某 region 的二级域，并作为它的数据源。

![../../_images/zone-sync.png](http://docs.ceph.org.cn/_images/zone-sync.png)

配置同步代理需找出源和目的地的访问密钥、私钥、以及目的 URL 和端口。

你可以用 `radosgw-admin zone list` 获取域名称列表，用 `radosgw-admin zone get` 找出此域的访问密钥和私钥。端口号可以在[创建网关配置](http://docs.ceph.org.cn/radosgw/federated-config/#id8)时创建的网关配置文件里找到。

一例程只需准备主机名和端口号即可（假设一 region 或域内的所有网关例程都访问同一 Ceph 存储集群）；配置文件（如 `cluster-data-sync.conf` ）里的以下这些选项要填上，还要给 `log_file` 指定一个日志文件。

例如：

```
src_access_key: {source-access-key}
src_secret_key: {source-secret-key}
destination: https://zone-name.fqdn.com:port
dest_access_key: {destination-access-key}
dest_secret_key: {destination-secret-key}
log_file: {log.filename}
```

实例类似这样：

```
src_access_key: DG8RE354EFPZBICHIAF0
src_secret_key: i3U0HiRP8CXaBWrcF8bbh6CbsxGYuPPwRkixfFSb
destination: https://us-west.storage.net:80
dest_access_key: U60RFI6B08F32T2PD30G
dest_secret_key: W3HuUor7Gl1Ee93pA2pq2wFk1JMQ7hTrSDecYExl
log_file: /var/log/radosgw/radosgw-sync-us-east-west.log
```

（在哪里执行）要启动数据同步代理，在终端内执行以下命令：

```
radosgw-agent -c region-data-sync.conf
```

同步代理运行时，你应该能从输出里看到数据片段正在同步。

```
INFO:radosgw_agent.sync:Starting incremental sync
INFO:radosgw_agent.worker:17910 is processing shard number 0
INFO:radosgw_agent.worker:shard 0 has 0 entries after ''
INFO:radosgw_agent.worker:finished processing shard 0
INFO:radosgw_agent.worker:17910 is processing shard number 1
INFO:radosgw_agent.sync:1/64 shards processed
INFO:radosgw_agent.worker:shard 1 has 0 entries after ''
INFO:radosgw_agent.worker:finished processing shard 1
INFO:radosgw_agent.sync:2/64 shards processed
...
```

Note

每个源、目的对都要运行代理。

## region 间元数据复制

数据同步代理会把主 region 内主域的元数据复制到二级 region 的主域。元数据包含网关用户和桶信息、但不包含桶内的对象——为确保跨集群统一的命名空间，主 region 内的主域是数据源，它会自动选择二级 region 的主域。

![../../_images/region-sync.png](http://docs.ceph.org.cn/_images/region-sync.png)

按照与[多站点数据复制](http://docs.ceph.org.cn/radosgw/federated-config/#id19)相同的步骤，并把主 region 的主域作为源域、二级 region 的主域作为二级域。启动 `radosgw-agent` 时加上 `--metadata-only` 参数，这样它就只会复制元数据。例如：

```
radosgw-agent -c inter-region-data-sync.conf --metadata-only
```

完成前述各步骤之后，你就会拥有一套包含两个 region 的集群，其内的主 region `us` 和二级 region `eu` 的命名空间是统一的。

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - 异地同步配置
    - [背景](http://docs.ceph.org.cn/radosgw/federated-config/#id2)
    - [关于本指南](http://docs.ceph.org.cn/radosgw/federated-config/#id3)
    - 配置主 region
      - [为主 region 命名](http://docs.ceph.org.cn/radosgw/federated-config/#id4)
      - [创建存储池](http://docs.ceph.org.cn/radosgw/federated-config/#id5)
      - [创建密钥环](http://docs.ceph.org.cn/radosgw/federated-config/#id6)
      - [安装 Apache 和 FastCGI](http://docs.ceph.org.cn/radosgw/federated-config/#apache-fastcgi)
      - [创建数据目录](http://docs.ceph.org.cn/radosgw/federated-config/#id7)
      - [创建网关配置](http://docs.ceph.org.cn/radosgw/federated-config/#id8)
      - [启用配置](http://docs.ceph.org.cn/radosgw/federated-config/#id9)
      - [添加 FastCGI 脚本](http://docs.ceph.org.cn/radosgw/federated-config/#fastcgi)
      - [把各例程加入 Ceph 配置文件](http://docs.ceph.org.cn/radosgw/federated-config/#ceph)
      - [创建 region](http://docs.ceph.org.cn/radosgw/federated-config/#id10)
      - [创建域](http://docs.ceph.org.cn/radosgw/federated-config/#id11)
      - [创建域用户](http://docs.ceph.org.cn/radosgw/federated-config/#id12)
      - [更新域配置](http://docs.ceph.org.cn/radosgw/federated-config/#id13)
      - [重启服务](http://docs.ceph.org.cn/radosgw/federated-config/#id14)
      - [启动网关例程](http://docs.ceph.org.cn/radosgw/federated-config/#id15)
    - 配置二级 region
      - [为二级 region 命名](http://docs.ceph.org.cn/radosgw/federated-config/#id17)
      - [二级 region 的配置](http://docs.ceph.org.cn/radosgw/federated-config/#id18)
    - [多站点数据复制](http://docs.ceph.org.cn/radosgw/federated-config/#id19)
    - [region 间元数据复制](http://docs.ceph.org.cn/radosgw/federated-config/#id20)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/config-ref/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/config/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/admin/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/federated-config/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# Ceph 对象网关配置参考

下列的选项可加入 Ceph 配置文件（一般是 `ceph.conf` ）的 `[client.radosgw.{instance-name}]` 段下，这些选项可能 有默认值.如果你没有指定，自就会自动使用默认值。

```
rgw data
```

| 描述:   | 设置 Ceph 对象网关存储数据文件位置。 |
| ------- | ------------------------------------ |
| 类型:   | String                               |
| 默认值: | `/var/lib/ceph/radosgw/$cluster-$id` |

```
rgw enable apis
```

| 描述:   | 启用指定的 API 。                             |
| ------- | --------------------------------------------- |
| 类型:   | String                                        |
| 默认值: | 所有 API ： `s3, swift, swift_auth, admin` 。 |

```
rgw cache enabled
```

| 描述:   | 是否启用 Ceph 对象网关缓存。 |
| ------- | ---------------------------- |
| 类型:   | Boolean                      |
| 默认值: | `true`                       |

```
rgw cache lru size
```

| 描述:   | Ceph 对象网关缓存的条目限制。 |
| ------- | ----------------------------- |
| 类型:   | Integer                       |
| 默认值: | `10000`                       |

```
rgw socket path
```

| 描述:   | 域套接字的路径， `FastCgiExternalServer` 要使用此套接字。若未指定， Ceph 对象网关就不会以外部服务器的方式运行。这里的路径必须与 `rgw.conf` 里的路径相同。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | N/A                                                          |

```
rgw host
```

| 描述:   | Ceph 对象网关实例所在主机，可以是 IP 地址或者主机名。 |
| ------- | ----------------------------------------------------- |
| 类型:   | String                                                |
| 默认值: | `0.0.0.0`                                             |

```
rgw port
```

| 描述:   | 对象网关实例接受请求的端口。若未指定， Ceph 对象网关将运行外部 FastCGI 。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | None                                                         |

```
rgw dns name
```

| 描述:   | 所服务域的 DNS 名称。请参考 region 配置里的 `hostnames` 选项。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | None                                                         |

```
rgw script uri
```

| 描述:   | 如果请求中没带 `SCRIPT_URI` 变量，这里的设置将作为默认值使用. |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | None                                                         |

```
rgw request uri
```

| 描述:   | 如果请求中没带 `REQUEST_URI` 变量，这里的设置将作为默认值使用。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | None                                                         |

```
rgw print continue
```

| 描述:   | 如果可能的话，启用 `100-continue` 。 |
| ------- | ------------------------------------ |
| 类型:   | Boolean                              |
| 默认值: | `true`                               |

```
rgw remote addr param
```

| 描述:   | 远端地址参数。例如， HTTP 字段或者 `X-Forwarded-For` 地址（如果用了反向代理）。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | `REMOTE_ADDR`                                                |

```
rgw op thread timeout
```

| 描述:   | 运行中线程的超时值。 |
| ------- | -------------------- |
| 类型:   | Integer              |
| 默认值: | 600                  |

```
rgw op thread suicide timeout
```

| 描述:   | Ceph 对象网关进程的超时自杀值（ `timeout` ）。设置为 `0` 时禁用。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Integer                                                      |
| 默认值: | `0`                                                          |

```
rgw thread pool size
```

| 描述:   | 线程池的尺寸。 |
| ------- | -------------- |
| 类型:   | Integer        |
| 默认值: | 100 threads.   |

```
rgw num rados handles
```

| 描述:   | Ceph 对象网关的 [RADOS 集群处理器](http://docs.ceph.org.cn/rados/api/librados-intro/#step-2-configuring-a-cluster-handle)数量。通过配置 RADOS 处理器数量可以使得各种类型的载荷都明显地提升性能，因为各个 RGW 工作线程在其短暂的活跃期内都可以分别挂靠一个 RADOS 处理器。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Integer                                                      |
| 默认值: | `1`                                                          |

```
rgw num control oids
```

| 描述:   | 不同的 `rgw` 实例间用于缓存同步的通知对象数量。 |
| ------- | ----------------------------------------------- |
| 类型:   | Integer                                         |
| 默认值: | `8`                                             |

```
rgw init timeout
```

| 描述:   | Ceph 对象网关放弃初始化前坚持的时间，秒。 |
| ------- | ----------------------------------------- |
| 类型:   | Integer                                   |
| 默认值: | `30`                                      |

```
rgw mime types file
```

| 描述:   | MIME 类型数据库文件的路径，Swift 自动探测对象类型时要用到。 |
| ------- | ----------------------------------------------------------- |
| 类型:   | String                                                      |
| 默认值: | `/etc/mime.types`                                           |

```
rgw gc max objs
```

| 描述:   | 垃圾回收进程在一个处理周期内可处理的最大对象数。 |
| ------- | ------------------------------------------------ |
| 类型:   | Integer                                          |
| 默认值: | `32`                                             |

```
rgw gc obj min wait
```

| 描述:   | 对象可被删除并由垃圾回收器处理前最少等待多长时间。 |
| ------- | -------------------------------------------------- |
| 类型:   | Integer                                            |
| 默认值: | `2 * 3600`                                         |

```
rgw gc processor max time
```

| 描述:   | 两个连续的垃圾回收周期起点的最大时间间隔。 |
| ------- | ------------------------------------------ |
| 类型:   | Integer                                    |
| 默认值: | `3600`                                     |

```
rgw gc processor period
```

| 描述:   | 垃圾回收进程的运行周期。 |
| ------- | ------------------------ |
| 类型:   | Integer                  |
| 默认值: | `3600`                   |

```
rgw s3 success create obj status
```

| 描述:   | `create-obj` 的另一种成功状态响应。 |
| ------- | ----------------------------------- |
| 类型:   | Integer                             |
| 默认值: | `0`                                 |

```
rgw resolve cname
```

| 描述:   | 如果主机名与 `rgw dns name` 不同， `rgw` 是否应该用请求的 hostname 字段的 DNS CNAME 记录。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Boolean                                                      |
| 默认值: | `false`                                                      |

```
rgw obj stripe size
```

| 描述:   | Ceph 对象网关的对象条带尺寸。关于条带化请参考[体系结构](http://docs.ceph.org.cn/architecture#data-striping)。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Integer                                                      |
| 默认值: | `4 << 20`                                                    |

```
rgw extended http attrs
```

| 描述:   | 为实体（用户、桶或对象）新增可设置的属性集。可以在上传实体时把这些额外属性设置在 HTTP 头的字段里、或者用 POST 方法修改；如果设置过，在此实体上执行 GET/HEAD 操作时这些属性就会以 HTTP 头的字段返回。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | String                                                       |
| 默认值: | None                                                         |
| 实例:   | “content_foo, content_bar, x-foo-bar”                        |

```
rgw exit timeout secs
```

| 描述:   | 等待某一进程多长时间（秒）后无条件退出。 |
| ------- | ---------------------------------------- |
| 类型:   | Integer                                  |
| 默认值: | `120`                                    |

```
rgw get obj window size
```

| 描述:   | 为单对象请求预留的窗口大小（字节）。 |
| ------- | ------------------------------------ |
| 类型:   | Integer                              |
| 默认值: | `16 << 20`                           |

```
rgw get obj max req size
```

| 描述:   | 向 Ceph 存储集群发起的一次 GET 请求的最大尺寸。 |
| ------- | ----------------------------------------------- |
| 类型:   | Integer                                         |
| 默认值: | `4 << 20`                                       |

```
rgw relaxed s3 bucket names
```

| 描述:   | 对 US region 的桶启用宽松的桶名规则。 |
| ------- | ------------------------------------- |
| 类型:   | Boolean                               |
| 默认值: | `false`                               |

```
rgw list buckets max chunk
```

| 描述:   | 列举用户桶时，每次检出的最大桶数。 |
| ------- | ---------------------------------- |
| 类型:   | Integer                            |
| 默认值: | `1000`                             |

```
rgw override bucket index max shards
```

| 描述:   | 桶索引对象的分片数量， 0 表示没有分片。我们不建议把这个值设置得太大（比如大于 1000 ），因为这样会增加罗列桶时的开销。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Integer                                                      |
| 默认值: | `0`                                                          |

```
rgw num zone opstate shards
```

| 描述:   | 用于保存 region 间复制进度的最大消息片数。 |
| ------- | ------------------------------------------ |
| 类型:   | Integer                                    |
| 默认值: | `128`                                      |

```
rgw opstate ratelimit sec
```

| 描述:   | 各次上传后状态更新操作的最小间隔时间。 `0` 禁用此限速。 |
| ------- | ------------------------------------------------------- |
| 类型:   | Integer                                                 |
| 默认值: | `30`                                                    |

```
rgw curl wait timeout ms
```

| 描述:   | 某些特定 `curl` 调用的超时值，毫秒。 |
| ------- | ------------------------------------ |
| 类型:   | Integer                              |
| 默认值: | `1000`                               |

```
rgw copy obj progress
```

| 描述:   | 长时间复制操作时允许输出对象进度。 |
| ------- | ---------------------------------- |
| 类型:   | Boolean                            |
| 默认值: | `true`                             |

```
rgw copy obj progress every bytes
```

| 描述:   | 复制进度输出的粒度，字节数。 |
| ------- | ---------------------------- |
| 类型:   | Integer                      |
| 默认值: | `1024 * 1024`                |

```
rgw admin entry
```

| 描述:   | 管理 URL 请求的入口点。 |
| ------- | ----------------------- |
| 类型:   | String                  |
| 默认值: | `admin`                 |

```
rgw content length compat
```

| 描述:   | 允许兼容设置了 CONTENT_LENGTH 和 HTTP_CONTENT_LENGTH 的 FCGI 请求。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Boolean                                                      |
| 默认值: | `false`                                                      |

## region （域组）

Ceph 从 v0.67 版开始，通过 region 概念支持 Ceph 对象网关联盟部署和统一的命名空间。 region 定义了位于一或多个域内的 Ceph 对象网关实例的地理位置。

region 的配置不同于一般配置过程，因为不是所有的配置都放在 Ceph 配置文件中。从 Ceph 0.67 版开始，你可以列出所有 region 、获取 region 配置以及设置 region 配置。

### 列出所有 region

Ceph 集群可包含一系列 region ，可用下列命令列出所有 region

```
sudo radosgw-admin regions list
```

`radosgw-admin` 命令会返回 JSON 格式的 region 列表。

```
{ "default_info": { "default_region": "default"},
  "regions": [
        "default"]}
```

### 获取 region-map

要获取各 region 的详细情况，可执行：

```
sudo radosgw-admin region-map get
```

Note

如果你得到了 `failed to read region map` 错误，先试试 `sudo radosgw-admin region-map update` 。

### 获取单个 region

要查看某 region 的配置，执行：

```
radosgw-admin region get [--rgw-region=<region>]
```

`default` 这个 region 的配置大致如此：

```
{"name": "default",
 "api_name": "",
 "is_master": "true",
 "endpoints": [],
 "hostnames": [],
 "master_zone": "",
 "zones": [
   {"name": "default",
    "endpoints": [],
    "log_meta": "false",
    "log_data": "false"}
  ],
 "placement_targets": [
   {"name": "default-placement",
    "tags": [] }],
 "default_placement": "default-placement"}
```

### 设置一个 region

定义 region 需创建一个 JSON 对象、并提供必需的参数：

1. `name`: region 名字，必需。
2. `api_name`: 此 region 的 API 名字，可选。
3. `is_master`: 决定着此 region 是否为主 region ，必需。**注：**只能有一个主 region 。
4. `endpoints`: region 内的所有结点列表。例如，你可以用多个域名指向同一 region 区，记得在斜杠前加反斜杠进行转义（ `\/` ）。也可以给结点指定端口号（ `fqdn:port` ），可选。
5. `hostnames`: region 内所有主机名的列表。例如，这样你就可以在同一 region 内使用多个域名了。可选配置。此列表会自动包含 `rgw dns name` 配置。更改此配置后需重启所有 `radosgw` 守护进程。
6. `master_zone`: region 的主域，可选。若未指定，则选择默认域。**注：**每个 region 只能有一个主域。
7. `zones`: region 内所有域的列表。各个域都有名字（必需的）、一系列结点（可选的）、以及网关是否要记录元数据和数据操作（默认不记录）。
8. `placement_targets`: 放置目标列表（可选）。每个放置目标都包含此放置目标的名字（必需）、还有一个标签列表（可选），这样只有带这些标签的用户可以使用此放置目标（即用户信息中的 `placement_tags` 字段）。
9. `default_placement`: 对象索引及数据的默认放置目标，默认为 `default-placement` 。你可以在用户信息里给各用户设置一个用户级的默认放置目标。

要配置一个 region ，需创建一个包含必需字段的 JSON 对象，把它存入文件（如 `region.json` ），然后执行下列命令：

```
sudo radosgw-admin region set --infile region.json
```

其中 `region.json` 是你创建的 JSON 文件。

Important

默认 region `default` 的 `is_master` 字段值默认为 `true` 。如果你想新建一 region 并让它作为主 region ，那你必须把 `default` region 的 `is_master` 设置为 `false` ，或者干脆删除 `default` region 。

最后，更新 region map。

```
sudo radosgw-admin region-map update
```

### 配置 region map

配置 region map的过程包括创建含一或多个 region 的 JSON 对象，还有设置集群的主 region `master_region` 。 region map内的各 region 都由键/值对组成，其中 `key` 选项等价于单独配置 region 时的 `name` 选项， `val` 是包含单个 region 完整配置的 JSON 对象。

你可以只有一个 region ，其 `is_master` 设置为 `true` ，而且必须在 region map末尾设置为 `master_region` 。下面的 JSON 对象是默认 region map的实例。

```
{ "regions": [
     { "key": "default",
       "val": { "name": "default",
       "api_name": "",
       "is_master": "true",
       "endpoints": [],
       "hostnames": [],
       "master_zone": "",
       "zones": [
         { "name": "default",
           "endpoints": [],
           "log_meta": "false",
            "log_data": "false"}],
            "placement_targets": [
              { "name": "default-placement",
                "tags": []}],
                "default_placement": "default-placement"
              }
          }
       ],
   "master_region": "default"
}
```

要配置一个 region map，执行此命令：

```
sudo radosgw-admin region-map set --infile regionmap.json
```

其中 `regionmap.json` 是创建的 JSON 文件。确保你创建了 region map里所指的那些域。最后，更新此map。

```
sudo radosgw-admin regionmap update
```

## Zones

从 Ceph v0.67 版起， Ceph 对象网关支持zone概念，它是一或多个 Ceph 对象网关实例组成的逻辑组。

zone的配置不同于典型配置过程，因为并非所有配置都位于 Ceph 配置文件内。从 0.67 版起，你可以列出所有zone、获取zone配置、设置zone配置。

### 列出所有zone

要列出某集群内的所有zone，执行：

```
sudo radosgw-admin zone list
```

### 获取单个zone

要获取某一zone的配置，执行：

```
sudo radosgw-admin zone get [--rgw-zone=<zone>]
```

`default` 这个默认zone的配置大致如此：

```
{ "domain_root": ".rgw",
  "control_pool": ".rgw.control",
  "gc_pool": ".rgw.gc",
  "log_pool": ".log",
  "intent_log_pool": ".intent-log",
  "usage_log_pool": ".usage",
  "user_keys_pool": ".users",
  "user_email_pool": ".users.email",
  "user_swift_pool": ".users.swift",
  "user_uid_pool": ".users.uid",
  "system_key": { "access_key": "", "secret_key": ""},
  "placement_pools": [
      {  "key": "default-placement",
         "val": { "index_pool": ".rgw.buckets.index",
                  "data_pool": ".rgw.buckets"}
      }
    ]
  }
```

### 配置zone

配置zone时需指定一系列的 Ceph 对象网关存储池。为保持一致性，我们建议用region名作为存储池名字的前缀。存储池配置见[存储池](http://docs.ceph.org.cn/radosgw/config-ref/#id7)。

要配置起一个zone，需创建包含存储池的 JSON 对象、并存入文件（如 `zone.json` ）；然后执行下列命令，把 `{zone-name}` 替换为zone名称：

```
sudo radosgw-admin zone set --rgw-zone={zone-name} --infile zone.json
```

其中， `zone.json` 是你创建的 JSON 文件。

## region 和 zone 选项

你可以在 Ceph 配置文件中的各实例 `[client.radosgw.{instance-name}]` 段下设置下列选项。

New in version v.67.

```
rgw zone
```

| 描述:   | 网关例程所在的zone名称。 |
| ------- | ------------------------ |
| 类型:   | String                   |
| 默认值: | None                     |

New in version v.67.

```
rgw region
```

| 描述:   | 网关例程所在的 region 名。 |
| ------- | -------------------------- |
| 类型:   | String                     |
| 默认值: | None                       |

New in version v.67.

```
rgw default region info oid
```

| 描述:   | 用于保存默认 region 的 OID 。我们不建议更改此选项。 |
| ------- | --------------------------------------------------- |
| 类型:   | String                                              |
| 默认值: | `default.region`                                    |

## 存储池

Ceph zone会映射一系列 Ceph 存储集群的存储池。

手动创建存储池与自动生成的存储池对比

如果你给 Ceph 对象网关的用户 key 分配了写权限，此网关就有能力自动创建存储池。这样虽然便捷，但 Ceph 对象存储集群的 PG  数会是默认值（此值也许不太理想）或者 Ceph 配置文件中的自定义配置。如果你想让 Ceph 对象网关自动创建存储池，确保 PG  数的默认值要合理。详情见[存储池配置](http://docs.ceph.org.cn/rados/configuration/pool-pg-config-ref/)，关于创建存储池见[集群存储池](http://docs.ceph.org.cn/rados/operations/pools)。

Ceph 对象网关的默认 zone 的默认存储池有：

- `.rgw`
- `.rgw.control`
- `.rgw.gc`
- `.log`
- `.intent-log`
- `.usage`
- `.users`
- `.users.email`
- `.users.swift`
- `.users.uid`

你应该能够清晰地判断某个 zone 会怎样访问各存储池。你可以为每个 zone 创建一系列存储池，或者让多个 zone  共用同一系列的存储池。作为最佳实践，我们建议分别位于各 region 中的主 zone 和第二 zone  都要有各自的一系列存储池。为某个域创建存储池时，建议默认存储池名以 region 名和 zone 名作为前缀，例如：

- `.region1-zone1.domain.rgw`
- `.region1-zone1.rgw.control`
- `.region1-zone1.rgw.gc`
- `.region1-zone1.log`
- `.region1-zone1.intent-log`
- `.region1-zone1.usage`
- `.region1-zone1.users`
- `.region1-zone1.users.email`
- `.region1-zone1.users.swift`
- `.region1-zone1.users.uid`

Ceph 对象网关会把 bucket 索引（ `index_pool` ）和 bucket 数据（ `data_pool` ）存储到归置存储池，这些可以重叠——也就是你可以把索引和数据存入同一存储池。索引存储池的默认归置地是 `.rgw.buckets.index` ，数据存储池的默认归置地是 `.rgw.buckets` ，给 zone 指定存储池的方法见[Zones](http://docs.ceph.org.cn/radosgw/config-ref/#zones)。

Deprecated since version v.67.

```
rgw cluster root pool
```

| 描述:     | 为此实例存储 `radosgw` 元数据的存储池。从 v0.67 之后不再支持，可改用 `rgw zone root pool` 。 |
| --------- | ------------------------------------------------------------ |
| 类型:     | String                                                       |
| 是否必需: | No                                                           |
| 默认值:   | `.rgw.root`                                                  |
| 替代选项: | `rgw zone root pool`                                         |

New in version v.67.

```
rgw region root pool
```

| 描述:   | 用于存储此 region 所有相关信息的存储池。 |
| ------- | ---------------------------------------- |
| 类型:   | String                                   |
| 默认值: | `.rgw.root`                              |

New in version v.67.

```
rgw zone root pool
```

| 描述:   | 用于存储此 zone 所有相关信息的存储池。 |
| ------- | -------------------------------------- |
| 类型:   | String                                 |
| 默认值: | `.rgw.root`                            |

## Swift 选项

```
rgw enforce swift acls
```

| 描述:   | 强制使用 Swift 的访问控制列表（ ACL ）选项。 |
| ------- | -------------------------------------------- |
| 类型:   | Boolean                                      |
| 默认值: | `true`                                       |

```
rgw swift token expiration
```

| 描述:   | Swift 令牌过期时间，秒。 |
| ------- | ------------------------ |
| 类型:   | Integer                  |
| 默认值: | `24 * 3600`              |

```
rgw swift url
```

| 描述:   | Ceph 对象网关 Swift 接口的 URL 。 |
| ------- | --------------------------------- |
| 类型:   | String                            |
| 默认值: | None                              |

```
rgw swift url prefix
```

| 描述:   | Swift API 的 URL 前缀。 |
| ------- | ----------------------- |
| 默认值: | `swift`                 |
| 实例:   | http://fqdn.com/swift   |

```
rgw swift auth url
```

| 描述:   | 验证 v1 版令牌的默认 URL （如果没用 Swift 内建认证）。 |
| ------- | ------------------------------------------------------ |
| 类型:   | String                                                 |
| 默认值: | None                                                   |

```
rgw swift auth entry
```

| 描述:   | Swift 认证 URL 的入口点。 |
| ------- | ------------------------- |
| 类型:   | String                    |
| 默认值: | `auth`                    |

## 日志记录选项

```
rgw log nonexistent bucket
```

| 描述:   | 让 Ceph 对象网关记录访问不存在的 bucket 的请求。 |
| ------- | ------------------------------------------------ |
| 类型:   | Boolean                                          |
| 默认值: | `false`                                          |

```
rgw log object name
```

| 描述:   | 对象名的记录格式。关于格式说明见 *date* 。 |
| ------- | ------------------------------------------ |
| 类型:   | Date                                       |
| 默认值: | `%Y-%m-%d-%H-%i-%n`                        |

```
rgw log object name utc
```

| 描述:   | 记录的对象名是否需包含 UTC 时间，设置为 `false` 时将使用本地时间。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Boolean                                                      |
| 默认值: | `false`                                                      |

```
rgw usage max shards
```

| 描述:   | 使用率日志的最大可分片数量。 |
| ------- | ---------------------------- |
| 类型:   | Integer                      |
| 默认值: | `32`                         |

```
rgw usage max user shards
```

| 描述:   | 单个用户使用率日志的最大可分片数量。 |
| ------- | ------------------------------------ |
| 类型:   | Integer                              |
| 默认值: | `1`                                  |

```
rgw enable ops log
```

| 描述:   | 允许记录各次成功的 Ceph 对象网关操作。 |
| ------- | -------------------------------------- |
| 类型:   | Boolean                                |
| 默认值: | `false`                                |

```
rgw enable usage log
```

| 描述:   | 允许记录使用率日志。 |
| ------- | -------------------- |
| 类型:   | Boolean              |
| 默认值: | `false`              |

```
rgw ops log rados
```

| 描述:   | 操作日志是否应该写入 Ceph 存储集群后端。 |
| ------- | ---------------------------------------- |
| 类型:   | Boolean                                  |
| 默认值: | `true`                                   |

```
rgw ops log socket path
```

| 描述:   | 用于写入操作日志的 Unix 域套接字。 |
| ------- | ---------------------------------- |
| 类型:   | String                             |
| 默认值: | None                               |

```
rgw ops log data backlog
```

| 描述:   | 最多积攒多少操作日志数据才写入 Unix 域套接字。 |
| ------- | ---------------------------------------------- |
| 类型:   | Integer                                        |
| 默认值: | `5 << 20`                                      |

```
rgw usage log flush threshold
```

| 描述:   | 使用率日志合并过多少条目才刷回。 |
| ------- | -------------------------------- |
| 类型:   | Integer                          |
| 默认值: | 1024                             |

```
rgw usage log tick interval
```

| 描述:   | 每 `n` 秒执行一次使用率日志刷回。 |
| ------- | --------------------------------- |
| 类型:   | Integer                           |
| 默认值: | `30`                              |

```
rgw intent log object name
```

| 描述:   | 意图日志对象名的记录格式。格式的详细说明见 *date* 。 |
| ------- | ---------------------------------------------------- |
| 类型:   | Date                                                 |
| 默认值: | `%Y-%m-%d-%i-%n`                                     |

```
rgw intent log object name utc
```

| 描述:   | 意图日志对象名是否应包含 UTC 时间，设置为 `false` 时使用本地时间。 |
| ------- | ------------------------------------------------------------ |
| 类型:   | Boolean                                                      |
| 默认值: | `false`                                                      |

```
rgw data log window
```

| 描述:   | 数据日志窗口，秒。 |
| ------- | ------------------ |
| 类型:   | Integer            |
| 默认值: | `30`               |

```
rgw data log changes size
```

| 描述:   | 内存中保留的数据变更日志条数。 |
| ------- | ------------------------------ |
| 类型:   | Integer                        |
| 默认值: | `1000`                         |

```
rgw data log num shards
```

| 描述:   | 用于保存数据变更日志的分片（对象）数量。 |
| ------- | ---------------------------------------- |
| 类型:   | Integer                                  |
| 默认值: | `128`                                    |

```
rgw data log obj prefix
```

| 描述:   | 数据日志的对象名前缀。 |
| ------- | ---------------------- |
| 类型:   | String                 |
| 默认值: | `data_log`             |

```
rgw replica log obj prefix
```

| 描述:   | 复制日志的对象名前缀。 |
| ------- | ---------------------- |
| 类型:   | String                 |
| 默认值: | `replica log`          |

```
rgw md log max shards
```

| 描述:   | 用于元数据日志的最大分片数。 |
| ------- | ---------------------------- |
| 类型:   | Integer                      |
| 默认值: | `64`                         |

## Keystone 选项

```
rgw keystone url
```

| 描述:   | Keystone 服务器的 URL 。 |
| ------- | ------------------------ |
| 类型:   | String                   |
| 默认值: | None                     |

```
rgw keystone admin token
```

| 描述:   | Keystone 的管理令牌（共享密钥）。 |
| ------- | --------------------------------- |
| 类型:   | String                            |
| 默认值: | None                              |

```
rgw keystone accepted roles
```

| 描述:   | 要接受请求所需的角色。 |
| ------- | ---------------------- |
| 类型:   | String                 |
| 默认值: | `Member, admin`        |

```
rgw keystone token cache size
```

| 描述:   | 各 Keystone 令牌缓存的最大条数。 |
| ------- | -------------------------------- |
| 类型:   | Integer                          |
| 默认值: | `10000`                          |

```
rgw keystone revocation interval
```

| 描述:   | 令牌有效期查验的周期，秒。 |
| ------- | -------------------------- |
| 类型:   | Integer                    |
| 默认值: | `15 * 60`                  |

```
rgw keystone verify ssl
```

| 描述:   | 将 token 请求发送给 keystone 时验证 SSL 证书. |
| ------- | --------------------------------------------- |
| 类型:   | Boolean                                       |
| 默认值: | `true`                                        |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - 配置参考
    - region （域组）
      - [列出所有 region](http://docs.ceph.org.cn/radosgw/config-ref/#id1)
      - [获取 region-map](http://docs.ceph.org.cn/radosgw/config-ref/#region-map)
      - [获取单个 region](http://docs.ceph.org.cn/radosgw/config-ref/#id2)
      - [设置一个 region](http://docs.ceph.org.cn/radosgw/config-ref/#id3)
      - [配置 region map](http://docs.ceph.org.cn/radosgw/config-ref/#id4)
    - Zones
      - [列出所有zone](http://docs.ceph.org.cn/radosgw/config-ref/#zone)
      - [获取单个zone](http://docs.ceph.org.cn/radosgw/config-ref/#id5)
      - [配置zone](http://docs.ceph.org.cn/radosgw/config-ref/#id6)
    - [region 和 zone 选项](http://docs.ceph.org.cn/radosgw/config-ref/#region-zone)
    - [存储池](http://docs.ceph.org.cn/radosgw/config-ref/#id7)
    - [Swift 选项](http://docs.ceph.org.cn/radosgw/config-ref/#swift)
    - [日志记录选项](http://docs.ceph.org.cn/radosgw/config-ref/#id8)
    - [Keystone 选项](http://docs.ceph.org.cn/radosgw/config-ref/#keystone)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/admin/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/federated-config/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

![img](moz-extension://5a1d5816-2c31-4e04-a168-1359df6f0f8b/assets/img/T.cb83a013.svg)

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/commons/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/purge-temp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# Ceph 对象网关的 S3 兼容 API[¶](http://docs.ceph.org.cn/radosgw/s3/#ceph-s3-api)

Ceph 支持 REST 风格的 API ，它与[亚马逊 S3 API](http://docs.aws.amazon.com/AmazonS3/latest/API/APIRest.html) 的基本数据访问模型兼容。

## API

- [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
- [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
- [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
- [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
- [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
- [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
- [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
- [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
- [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
- [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
- [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
- [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
- [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)

## 功能支持情况

下面的表格列出了对亚马逊 S3 的功能支持情况：

| Feature                       | Status        | Remarks                      |
| ----------------------------- | ------------- | ---------------------------- |
| **List Buckets**              | Supported     |                              |
| **Delete Bucket**             | Supported     |                              |
| **Create Bucket**             | Supported     | Different set of canned ACLs |
| **Bucket Lifecycle**          | Not Supported |                              |
| **Policy (Buckets, Objects)** | Not Supported | ACLs are supported           |
| **Bucket Website**            | Not Supported |                              |
| **Bucket ACLs (Get, Put)**    | Supported     | Different set of canned ACLs |
| **Bucket Location**           | Supported     |                              |
| **Bucket Notification**       | Not Supported |                              |
| **Bucket Object Versions**    | Supported     |                              |
| **Get Bucket Info (HEAD)**    | Supported     |                              |
| **Bucket Request Payment**    | Not Supported |                              |
| **Put Object**                | Supported     |                              |
| **Delete Object**             | Supported     |                              |
| **Get Object**                | Supported     |                              |
| **Object ACLs (Get, Put)**    | Supported     |                              |
| **Get Object Info (HEAD)**    | Supported     |                              |
| **POST Object**               | Supported     |                              |
| **Copy Object**               | Supported     |                              |
| **Multipart Uploads**         | Supported     | (missing Copy Part)          |

## 不支持的 Header 字段

下列的通用请求头部字段尚不支持：

| Nam                      | Type     |
| ------------------------ | -------- |
| **x-amz-security-token** | Request  |
| **Server**               | Response |
| **x-amz-delete-marker**  | Response |
| **x-amz-id-2**           | Response |
| **x-amz-version-id**     | Response |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/commons/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/purge-temp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/authentication/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

# 通用实例



## Bucket 和 主机名

有两种不同的方式访问 bucket。第一个(首选)方法通过URI中的顶级目录 来确认 bucket 。

> GET /mybucket HTTP/1.1 Host: cname.domain.com

第二种方法是通过虚拟的bucket 主机名来确认 bucket。举例如下：

> GET / HTTP/1.1 Host: mybucket.cname.domain.com

Tip

我们更倾向于第一种方法，因为第二种方法需要昂贵的域认证和 DNS 泛域名解析。

## 通用的 Request 请求头

| Request Header   | Description                     |
| ---------------- | ------------------------------- |
| `CONTENT_LENGTH` | Length of the request body.     |
| `DATE`           | Request time and date (in UTC). |
| `HOST`           | The name of the host server.    |
| `AUTHORIZATION`  | Authorization token.            |

## 通用 Response 状态

| HTTP Status | Response Code                   |
| ----------- | ------------------------------- |
| `100`       | Continue                        |
| `200`       | Success                         |
| `201`       | Created                         |
| `202`       | Accepted                        |
| `204`       | NoContent                       |
| `206`       | Partial content                 |
| `304`       | NotModified                     |
| `400`       | InvalidArgument                 |
| `400`       | InvalidDigest                   |
| `400`       | BadDigest                       |
| `400`       | InvalidBucketName               |
| `400`       | InvalidObjectName               |
| `400`       | UnresolvableGrantByEmailAddress |
| `400`       | InvalidPart                     |
| `400`       | InvalidPartOrder                |
| `400`       | RequestTimeout                  |
| `400`       | EntityTooLarge                  |
| `403`       | AccessDenied                    |
| `403`       | UserSuspended                   |
| `403`       | RequestTimeTooSkewed            |
| `404`       | NoSuchKey                       |
| `404`       | NoSuchBucket                    |
| `404`       | NoSuchUpload                    |
| `405`       | MethodNotAllowed                |
| `408`       | RequestTimeout                  |
| `409`       | BucketAlreadyExists             |
| `409`       | BucketNotEmpty                  |
| `411`       | MissingContentLength            |
| `412`       | PreconditionFailed              |
| `416`       | InvalidRange                    |
| `422`       | UnprocessableEntity             |
| `500`       | InternalError                   |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - 通用
        - [Bucket 和 主机名](http://docs.ceph.org.cn/radosgw/s3/commons/#bucket)
        - [通用的 Request 请求头](http://docs.ceph.org.cn/radosgw/s3/commons/#request)
        - [通用 Response 状态](http://docs.ceph.org.cn/radosgw/s3/commons/#response)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/authentication/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/serviceops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/commons/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

# 认证和 ACLs

到 RADOS 网关的 Requests 请求可能已经经过验证也可能没有经 过验证。RGW 假设所有未经验证的请求都是由匿名用户发送的。RGW 支持预置的 ACLs。

## 认证[¶](http://docs.ceph.org.cn/radosgw/s3/authentication/#id1)

对请求进行身份验证需要在它发送到 RGW 服务器之前就包含一个 access 密钥和基于散列消息验证码(HMAC)。RGW 使用兼容 S3 的身份验证方法。

```
HTTP/1.1
PUT /buckets/bucket/object.mpeg
Host: cname.domain.com
Date: Mon, 2 Jan 2012 00:01:01 +0000
Content-Encoding: mpeg
Content-Length: 9999999

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

在上述例子中，使用你自己的 access 密钥代替 `{access-key}` ，在其后跟着加入一个冒 号 (`:`)。将头字符串和 secret 密钥 hash 之后的结果替换 `{hash-of-header-and-secret}` ，这里的 secret 必须是跟你前面使用的 access 配对的密钥。

要生成头字符串和 secret 密钥的 hash 结果，你必须：

1. 获取头字符串
2. 将请求头字符串格式化为规范格式
3. 使用 SHA-1 hashing 算法生成 HMAC 查看 [RFC 2104](http://www.ietf.org/rfc/rfc2104.txt) 和 [HMAC](http://en.wikipedia.org/wiki/HMAC) 获取详细信息
4. 使用 base-64 将 `hmac` 结果再次编码

将请求头字符串格式化为规范格式:

1. 获取所有以 `x-amz-` 开头的所有字段
2. 确保这些字段都是小写字母
3. 按照字母顺序将这些字段排序
4. 将多个实例中相同的字段名称合并到一个单个字段中 在这个字段中使用逗号分隔这些值
5. 将字段的值中的空格和换行符替换为单个空格
6. 删除冒号前后的空格
7. 在每个字段后追加一个空行
8. 将所有字段合并到头字符串中

将 HMAC 字符串使用 base-64编码的结果替换 `{hash-of-header-and-secret}`

## 访问控制列表 (ACLs)

RGW 支持兼容 S3 ACL 的功能。ACL 是一个授权访问控制 列表，它指定了用户针对一个 bucket 或者一个对象能够执 行哪些操作。针对一个 bucket 或者一个对象的每次授权都 有不同的含义:

| Permission     | Bucket                                                 | Object                                       |
| -------------- | ------------------------------------------------------ | -------------------------------------------- |
| `READ`         | Grantee can list the objects in the bucket.            | Grantee can read the object.                 |
| `WRITE`        | Grantee can write or delete objects in the bucket.     | N/A                                          |
| `READ_ACP`     | Grantee can read bucket ACL.                           | Grantee can read the object ACL.             |
| `WRITE_ACP`    | Grantee can write bucket ACL.                          | Grantee can write to the object ACL.         |
| `FULL_CONTROL` | Grantee has full permissions for object in the bucket. | Grantee can read or write to the object ACL. |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - 认证
        - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/#id1)
        - [访问控制列表 (ACLs)](http://docs.ceph.org.cn/radosgw/s3/authentication/#id2)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/serviceops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/commons/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/bucketops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/authentication/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

# 服务操作

## 列出 bucket

`GET /` 会返回执行该操作的用户的 bucket 列表。`GET /` 只返回由经过认证的用户新建的 buckets。你不同提交一个匿名请求。

### 语法

```
GET / HTTP/1.1
Host: cname.domain.com

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

### 请求返回值

| Name                     | Type      | Description                                                |
| ------------------------ | --------- | ---------------------------------------------------------- |
| `Buckets`                | Container | Container for list of buckets.                             |
| `Bucket`                 | Container | Container for bucket information.                          |
| `Name`                   | String    | Bucket name.                                               |
| `CreationDate`           | Date      | UTC time when the bucket was created.                      |
| `ListAllMyBucketsResult` | Container | A container for the result.                                |
| `Owner`                  | Container | A container for the bucket owner’s `ID` and `DisplayName`. |
| `ID`                     | String    | The bucket owner’s ID.                                     |
| `DisplayName`            | String    | The bucket owner’s display name.                           |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - 服务操作
        - 列出 bucket
          - [语法](http://docs.ceph.org.cn/radosgw/s3/serviceops/#id2)
          - [请求返回值](http://docs.ceph.org.cn/radosgw/s3/serviceops/#id3)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/bucketops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/authentication/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/objectops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/serviceops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

# bucket 操作

## PUT Bucket

创建一个新的 bucket。要创建一个 bucket，你必须有一个用户 ID 和一个有效的 AWS 访问密钥 ID 来进行身份验证请求。匿名用户不能创建 bucket。

Note

当前版本我们不支持通过 `PUT /{bucket}` 来请求实例。

### 约束条件

一般而言，bucket 名称应该遵循下述域名命名约束条件

- Bucket 名必须是唯一的
- Bucket 名必须以小写字母开始和结尾
- Bucket 名可以包含破折号 (-).

### 语法

```
PUT /{bucket} HTTP/1.1
Host: cname.domain.com
x-amz-acl: public-read-write

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

### 参数

| Name        | Description  | Valid Values                                                 | Required |
| ----------- | ------------ | ------------------------------------------------------------ | -------- |
| `x-amz-acl` | Canned ACLs. | `private`, `public-read`, `public-read-write`, `authenticated-read` | No       |

### HTTP 响应

如果 bucket 的名称是独一无二的，满足约束条件并且没有被使用，操作就会成功的。 如果已经存在同名的 bucket，并且 bucket 的所有者就是当前请求用户，操作也会返回成功的。 如果 bucket 名称已经被使用，操作将会返回失败。

| HTTP Status | Status Code         | Description                                             |
| ----------- | ------------------- | ------------------------------------------------------- |
| `409`       | BucketAlreadyExists | Bucket already exists under different user’s ownership. |

## 删除 Bucket

删除一个 bucket，得到成功删除 bucket 的返回信息后就可以重用该 bucket 名。

### 语法

```
DELETE /{bucket} HTTP/1.1
Host: cname.domain.com

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

### HTTP 响应

| HTTP Status | Status Code | Description     |
| ----------- | ----------- | --------------- |
| `204`       | No Content  | Bucket removed. |

## 获取 Bucket

返回 bucket 中的对象列表

### 语法

```
GET /{bucket}?max-keys=25 HTTP/1.1
Host: cname.domain.com
```

### 参数

| Name        | Type    | Description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| `prefix`    | String  | Only returns objects that contain the specified prefix.      |
| `delimiter` | String  | The delimiter between the prefix and the rest of the object name. |
| `marker`    | String  | A beginning index for the list of objects returned.          |
| `max-keys`  | Integer | The maximum number of keys to return. Default is 1000.       |

### HTTP 响应

| HTTP Status | Status Code | Description       |
| ----------- | ----------- | ----------------- |
| `200`       | OK          | Buckets retrieved |

### Bucket 响应实例

`GET /{bucket}` 返回一个容器，包含 bucket 的下列字段

| Name               | Type      | Description                                                  |
| ------------------ | --------- | ------------------------------------------------------------ |
| `ListBucketResult` | Entity    | The container for the list of objects.                       |
| `Name`             | String    | The name of the bucket whose contents will be returned.      |
| `Prefix`           | String    | A prefix for the object keys.                                |
| `Marker`           | String    | A beginning index for the list of objects returned.          |
| `MaxKeys`          | Integer   | The maximum number of keys returned.                         |
| `Delimiter`        | String    | If set, objects with the same prefix will appear in the `CommonPrefixes` list. |
| `IsTruncated`      | Boolean   | If `true`, only a subset of the bucket’s contents were returned. |
| `CommonPrefixes`   | Container | If multiple objects contain the same prefix, they will appear in this list. |

### 对象响应实例

`ListBucketResult` 包含很多对象，每个对象都包含一个 `Contents` 容器.

| Name           | Type    | Description                              |
| -------------- | ------- | ---------------------------------------- |
| `Contents`     | Object  | A container for the object.              |
| `Key`          | String  | The object’s key.                        |
| `LastModified` | Date    | The object’s last-modified date/time.    |
| `ETag`         | String  | An MD-5 hash of the object. (entity tag) |
| `Size`         | Integer | The object’s size.                       |
| `StorageClass` | String  | Should always return `STANDARD`.         |

## 获取 Bucket 位置

获取 bucket 的 region。只有 bucket 的所有者才能发起这个请求。一个 bucket 可以在发起 PUT 请求的时候通过指定 `LocationConstraint` 参数来限制它的 region。

### 语法

如下所示在 bucket 资源后面添加 `location` 子资源

```
GET /{bucket}?location HTTP/1.1
Host: cname.domain.com

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

### 响应实例

| Name                 | Type   | Description                                                  |
| -------------------- | ------ | ------------------------------------------------------------ |
| `LocationConstraint` | String | The region where bucket resides, empty string for defult region |

## 获取 Bucket ACL

获取 bucket 的访问控制列表。请求用户需要是该 bucket 的所有者或者已经针对这个 bucket 授权了 `READ_ACP` 权限的用户.

### 语法

如下所示，在 bucket 请求后面添加 `acl` 子资源.

```
GET /{bucket}?acl HTTP/1.1
Host: cname.domain.com

Authorization: AWS {access-key}:{hash-of-header-and-secret}
```

### 响应实例

| Name                  | Type      | Description                                                  |
| --------------------- | --------- | ------------------------------------------------------------ |
| `AccessControlPolicy` | Container | A container for the response.                                |
| `AccessControlList`   | Container | A container for the ACL information.                         |
| `Owner`               | Container | A container for the bucket owner’s `ID` and `DisplayName`.   |
| `ID`                  | String    | The bucket owner’s ID.                                       |
| `DisplayName`         | String    | The bucket owner’s display name.                             |
| `Grant`               | Container | A container for `Grantee` and `Permission`.                  |
| `Grantee`             | Container | A container for the `DisplayName` and `ID` of the user receiving a grant of permission. |
| `Permission`          | String    | The permission given to the `Grantee` bucket.                |

## 设置 Bucket ACL

为一个已经存在的 bucket 设置一个访问控制。请求用户需要是该 bucket 的所有者或者已经针对 这个 bucket 授权了 `WRITE_ACP` 权限的用户.

### 语法

如下所示，在 bucket 请求后面添加 `acl` 子资源.

```
PUT /{bucket}?acl HTTP/1.1
```

### 响应实例

| Name                  | Type      | Description                                                  |
| --------------------- | --------- | ------------------------------------------------------------ |
| `AccessControlPolicy` | Container | A container for the request.                                 |
| `AccessControlList`   | Container | A container for the ACL information.                         |
| `Owner`               | Container | A container for the bucket owner’s `ID` and `DisplayName`.   |
| `ID`                  | String    | The bucket owner’s ID.                                       |
| `DisplayName`         | String    | The bucket owner’s display name.                             |
| `Grant`               | Container | A container for `Grantee` and `Permission`.                  |
| `Grantee`             | Container | A container for the `DisplayName` and `ID` of the user receiving a grant of permission. |
| `Permission`          | String    | The permission given to the `Grantee` bucket.                |

## 列出 Bucket 的分块上传

`GET /?uploads` 返回当前正在进行中的分块上传的列表。比如：应用 程序启动了一个分块上传，但是服务尚未完成所有块的上传。

### 语法

```
GET /{bucket}?uploads HTTP/1.1
```

### 参数

你可以为 `GET /{bucket}?uploads` 指定一些参数，但下面这些参数都不是必须的.

| Name               | Type    | Description                                                  |
| ------------------ | ------- | ------------------------------------------------------------ |
| `prefix`           | String  | Returns in-progress uploads whose keys contains the specified prefix. |
| `delimiter`        | String  | The delimiter between the prefix and the rest of the object name. |
| `key-marker`       | String  | The beginning marker for the list of uploads.                |
| `max-keys`         | Integer | The maximum number of in-progress uploads. The default is 1000. |
| `max-uploads`      | Integer | The maximum number of multipart uploads. The range from 1-1000. The default is 1000. |
| `upload-id-marker` | String  | Ignored if `key-marker` isn’t specified. Specifies the `ID` of first upload to list in lexicographical order at or following the `ID`. |

### 响应实例

| Name                                | Type      | Description                                                  |
| ----------------------------------- | --------- | ------------------------------------------------------------ |
| `ListMultipartUploadsResult`        | Container | A container for the results.                                 |
| `ListMultipartUploadsResult.Prefix` | String    | The prefix specified by the `prefix` request parameter (if any). |
| `Bucket`                            | String    | The bucket that will receive the bucket contents.            |
| `KeyMarker`                         | String    | The key marker specified by the `key-marker` request parameter (if any). |
| `UploadIdMarker`                    | String    | The marker specified by the `upload-id-marker` request parameter (if any). |
| `NextKeyMarker`                     | String    | The key marker to use in a subsequent request if `IsTruncated` is `true`. |
| `NextUploadIdMarker`                | String    | The upload ID marker to use in a subsequent request if `IsTruncated` is `true`. |
| `MaxUploads`                        | Integer   | The max uploads specified by the `max-uploads` request parameter. |
| `Delimiter`                         | String    | If set, objects with the same prefix will appear in the `CommonPrefixes` list. |
| `IsTruncated`                       | Boolean   | If `true`, only a subset of the bucket’s upload contents were returned. |
| `Upload`                            | Container | A container for `Key`, `UploadId`, `InitiatorOwner`, `StorageClass`, and `Initiated` elements. |
| `Key`                               | String    | The key of the object once the multipart upload is complete. |
| `UploadId`                          | String    | The `ID` that identifies the multipart upload.               |
| `Initiator`                         | Container | Contains the `ID` and `DisplayName` of the user who initiated the upload. |
| `DisplayName`                       | String    | The initiator’s display name.                                |
| `ID`                                | String    | The initiator’s ID.                                          |
| `Owner`                             | Container | A container for the `ID` and `DisplayName` of the user who owns the uploaded object. |
| `StorageClass`                      | String    | The method used to store the resulting object. `STANDARD` or `REDUCED_REDUNDANCY` |
| `Initiated`                         | Date      | The date and time the user initiated the upload.             |
| `CommonPrefixes`                    | Container | If multiple objects contain the same prefix, they will appear in this list. |
| `CommonPrefixes.Prefix`             | String    | The substring of the key after the prefix as defined by the `prefix` request parameter. |

## 启用/禁用 BUCKET 版本

`PUT /?versioning` 这个子资源用于设置已有 bucket 的版本化状态。只有 bucket 所有者才能设置这个版本状态。

版本状态可以设置为如下取值之一：

- Enabled : 为 bucket 内的对象启用版本，放入 bucket 内的对象都会收到一个唯一的版本 ID 。
- Suspended : 为 bucket 内的对象禁用版本，放入 bucket 内的对象其版本 ID 都是 null 。

如果从没给某一个 bucket 设置过版本状态，那它就没有版本状态；获取版本的 GET 请求就不会返回版本的状态值。

### 语法

```
PUT  /{bucket}?versioning  HTTP/1.1
```

### 请求实体

| Name                      | Type      | Description                                                  |
| ------------------------- | --------- | ------------------------------------------------------------ |
| `VersioningConfiguration` | Container | A container for the request.                                 |
| `Status`                  | String    | Sets the versioning state of the bucket.  Valid Values: Suspended/Enabled |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - Bucket 操作
        - PUT Bucket
          - [约束条件](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id1)
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id2)
          - [参数](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id3)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/s3/bucketops/#http)
        - 删除 Bucket
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id5)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id6)
        - 获取 Bucket
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id8)
          - [参数](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id9)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id10)
          - [Bucket 响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id11)
          - [对象响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id12)
        - 获取 Bucket 位置
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id14)
          - [响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id15)
        - 获取 Bucket ACL
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id16)
          - [响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id17)
        - 设置 Bucket ACL
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id19)
          - [响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id20)
        - 列出 Bucket 的分块上传
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id22)
          - [参数](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id23)
          - [响应实例](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id24)
        - 启用/禁用 BUCKET 版本
          - [语法](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id26)
          - [请求实体](http://docs.ceph.org.cn/radosgw/s3/bucketops/#id27)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/objectops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/serviceops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/cpp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/bucketops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

# 对象操作

## PUT 对象

添加一个对象到 bucket 中。你必须有这个 bucket 的 WRITE 权限才能执行这个操作.

### 语法

```
PUT /{bucket}/{object} HTTP/1.1
```

### 请求头[¶](http://docs.ceph.org.cn/radosgw/s3/objectops/#id3)

| Name                 | Description                                | Valid Values                                                 | Required |
| -------------------- | ------------------------------------------ | ------------------------------------------------------------ | -------- |
| **content-md5**      | A base64 encoded MD-5 hash of the message. | A string. No defaults or constraints.                        | No       |
| **content-type**     | A standard MIME type.                      | Any MIME type. Default: `binary/octet-stream`                | No       |
| **x-amz-meta-<...>** | User metadata.  Stored with the object.    | A string up to 8kb. No defaults.                             | No       |
| **x-amz-acl**        | A canned ACL.                              | `private`, `public-read`, `public-read-write`, `authenticated-read` | No       |

## 复制对象

要复制一个对象，使用 `PUT` 方法并指定一个目的 bucket 和对象名。

### 语法

```
PUT /{dest-bucket}/{dest-object} HTTP/1.1
x-amz-copy-source: {source-bucket}/{source-object}
```

### 请求头

| Name                               | Description                                    | Valid Values                                                 | Required |
| ---------------------------------- | ---------------------------------------------- | ------------------------------------------------------------ | -------- |
| **x-amz-copy-source**              | The source bucket name + object name.          | {bucket}/{obj}                                               | Yes      |
| **x-amz-acl**                      | A canned ACL.                                  | `private`, `public-read`, `public-read-write`, `authenticated-read` | No       |
| **x-amz-copy-if-modified-since**   | Copies only if modified since the timestamp.   | Timestamp                                                    | No       |
| **x-amz-copy-if-unmodified-since** | Copies only if unmodified since the timestamp. | Timestamp                                                    | No       |
| **x-amz-copy-if-match**            | Copies only if object ETag matches ETag.       | Entity Tag                                                   | No       |
| **x-amz-copy-if-none-match**       | Copies only if object ETag doesn’t match.      | Entity Tag                                                   | No       |

### 响应实体

| Name                 | Type      | Description                                  |
| -------------------- | --------- | -------------------------------------------- |
| **CopyObjectResult** | Container | A container for the response elements.       |
| **LastModified**     | Date      | The last modified date of the source object. |
| **Etag**             | String    | The ETag of the new object.                  |

## 删除对象

要删除一个对象。需要用于具有该 bucket 的 WRITE 权限。

### 语法

```
DELETE /{bucket}/{object} HTTP/1.1
```

## 获取对象

获取 RAODS 中 bucket 一个对象。

### 语法

```
GET /{bucket}/{object} HTTP/1.1
```

### 请求头

| Name                    | Description                                    | Valid Values                   | Required |
| ----------------------- | ---------------------------------------------- | ------------------------------ | -------- |
| **range**               | The range of the object to retrieve.           | Range: bytes=beginbyte-endbyte | No       |
| **if-modified-since**   | Gets only if modified since the timestamp.     | Timestamp                      | No       |
| **if-unmodified-since** | Gets only if not modified since the timestamp. | Timestamp                      | No       |
| **if-match**            | Gets only if object ETag matches ETag.         | Entity Tag                     | No       |
| **if-none-match**       | Gets only if object ETag matches ETag.         | Entity Tag                     | No       |

### 响应头

| Name              | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| **Content-Range** | Data range, will only be returned if the range header field was specified in the request |

## 获取对象信息

返回对象的信息。这个请求会返回跟获取对象 请求相同的头信息，但是只会包含元数据，而 不包含对象数据负载。

### 语法

```
HEAD /{bucket}/{object} HTTP/1.1
```

### 请求头

| Name                    | Description                                    | Valid Values                   | Required |
| ----------------------- | ---------------------------------------------- | ------------------------------ | -------- |
| **range**               | The range of the object to retrieve.           | Range: bytes=beginbyte-endbyte | No       |
| **if-modified-since**   | Gets only if modified since the timestamp.     | Timestamp                      | No       |
| **if-unmodified-since** | Gets only if not modified since the timestamp. | Timestamp                      | No       |
| **if-match**            | Gets only if object ETag matches ETag.         | Entity Tag                     | No       |
| **if-none-match**       | Gets only if object ETag matches ETag.         | Entity Tag                     | No       |

## 获取对象 ACL

### 语法

```
GET /{bucket}/{object}?acl HTTP/1.1
```

### 响应实体

| Name                  | Type      | Description                                                  |
| --------------------- | --------- | ------------------------------------------------------------ |
| `AccessControlPolicy` | Container | A container for the response.                                |
| `AccessControlList`   | Container | A container for the ACL information.                         |
| `Owner`               | Container | A container for the object owner’s `ID` and `DisplayName`.   |
| `ID`                  | String    | The object owner’s ID.                                       |
| `DisplayName`         | String    | The object owner’s display name.                             |
| `Grant`               | Container | A container for `Grantee` and `Permission`.                  |
| `Grantee`             | Container | A container for the `DisplayName` and `ID` of the user receiving a grant of permission. |
| `Permission`          | String    | The permission given to the `Grantee` object.                |

## 设置对象 ACL

### 语法

```
PUT /{bucket}/{object}?acl
```

### 请求实体

| Name                  | Type      | Description                                                  |
| --------------------- | --------- | ------------------------------------------------------------ |
| `AccessControlPolicy` | Container | A container for the response.                                |
| `AccessControlList`   | Container | A container for the ACL information.                         |
| `Owner`               | Container | A container for the object owner’s `ID` and `DisplayName`.   |
| `ID`                  | String    | The object owner’s ID.                                       |
| `DisplayName`         | String    | The object owner’s display name.                             |
| `Grant`               | Container | A container for `Grantee` and `Permission`.                  |
| `Grantee`             | Container | A container for the `DisplayName` and `ID` of the user receiving a grant of permission. |
| `Permission`          | String    | The permission given to the `Grantee` object.                |

## 初始化分块上传

初始化一个分块上传进程.

### 语法

```
POST /{bucket}/{object}?uploads
```

### 请求头

| Name                 | Description                                | Valid Values                                                 | Required |
| -------------------- | ------------------------------------------ | ------------------------------------------------------------ | -------- |
| **content-md5**      | A base64 encoded MD-5 hash of the message. | A string. No defaults or constraints.                        | No       |
| **content-type**     | A standard MIME type.                      | Any MIME type. Default: `binary/octet-stream`                | No       |
| **x-amz-meta-<...>** | User metadata.  Stored with the object.    | A string up to 8kb. No defaults.                             | No       |
| **x-amz-acl**        | A canned ACL.                              | `private`, `public-read`, `public-read-write`, `authenticated-read` | No       |

### 响应实体

| Name                              | Type      | Description                                                  |
| --------------------------------- | --------- | ------------------------------------------------------------ |
| `InitiatedMultipartUploadsResult` | Container | A container for the results.                                 |
| `Bucket`                          | String    | The bucket that will receive the object contents.            |
| `Key`                             | String    | The key specified by the `key` request parameter (if any).   |
| `UploadId`                        | String    | The ID specified by the `upload-id` request parameter identifying the multipart upload (if any). |

## 分块上传之块

### 语法

```
PUT /{bucket}/{object}?partNumber=&uploadId= HTTP/1.1
```

### HTTP 响应

下列 HTTP 响应将会返回:

| HTTP Status | Status Code  | Description                                                  |
| ----------- | ------------ | ------------------------------------------------------------ |
| **404**     | NoSuchUpload | Specified upload-id does not match any initiated upload on this object |

## 列出分块上传的块

### 语法

```
GET /{bucket}/{object}?uploadId=123 HTTP/1.1
```

### 响应实体

| Name                   | Type      | Description                                                  |
| ---------------------- | --------- | ------------------------------------------------------------ |
| `ListPartsResult`      | Container | A container for the results.                                 |
| `Bucket`               | String    | The bucket that will receive the object contents.            |
| `Key`                  | String    | The key specified by the `key` request parameter (if any).   |
| `UploadId`             | String    | The ID specified by the `upload-id` request parameter identifying the multipart upload (if any). |
| `Initiator`            | Container | Contains the `ID` and `DisplayName` of the user who initiated the upload. |
| `ID`                   | String    | The initiator’s ID.                                          |
| `DisplayName`          | String    | The initiator’s display name.                                |
| `Owner`                | Container | A container for the `ID` and `DisplayName` of the user who owns the uploaded object. |
| `StorageClass`         | String    | The method used to store the resulting object. `STANDARD` or `REDUCED_REDUNDANCY` |
| `PartNumberMarker`     | String    | The part marker to use in a subsequent request if `IsTruncated` is `true`. Precedes the list. |
| `NextPartNumberMarker` | String    | The next part marker to use in a subsequent request if `IsTruncated` is `true`. The end of the list. |
| `MaxParts`             | Integer   | The max parts allowed in the response as specified by the `max-parts` request parameter. |
| `IsTruncated`          | Boolean   | If `true`, only a subset of the object’s upload contents were returned. |
| `Part`                 | Container | A container for `Key`, `Part`, `InitiatorOwner`, `StorageClass`, and `Initiated` elements. |
| `PartNumber`           | Integer   | The identification number of the part.                       |
| `ETag`                 | String    | The part’s entity tag.                                       |
| `Size`                 | Integer   | The size of the uploaded part.                               |

## 完成分块上传

组装上传部分并创建一个新对象，从而完成一个多部分上传。

### 语法

```
POST /{bucket}/{object}?uploadId= HTTP/1.1
```

### 请求实体

| Name                      | Type      | Description                                  | Required |
| ------------------------- | --------- | -------------------------------------------- | -------- |
| `CompleteMultipartUpload` | Container | A container consisting of one or more parts. | Yes      |
| `Part`                    | Container | A container for the `PartNumber` and `ETag`. | Yes      |
| `PartNumber`              | Integer   | The identifier of the part.                  | Yes      |
| `ETag`                    | String    | The part’s entity tag.                       | Yes      |

### 响应实体

| Name                              | Type      | Description                                          |
| --------------------------------- | --------- | ---------------------------------------------------- |
| **CompleteMultipartUploadResult** | Container | A container for the response.                        |
| **Location**                      | URI       | The resource identifier (path) of the new object.    |
| **Bucket**                        | String    | The name of the bucket that contains the new object. |
| **Key**                           | String    | The object’s key.                                    |
| **ETag**                          | String    | The entity tag of the new object.                    |

## 取消分块上传

### 语法

```
DELETE /{bucket}/{object}?uploadId= HTTP/1.1
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - 对象操作
        - PUT 对象
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id2)
          - [请求头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id3)
        - 复制对象
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id5)
          - [请求头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id6)
          - [响应实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id7)
        - 删除对象
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id9)
        - 获取对象
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id11)
          - [请求头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id12)
          - [响应头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id13)
        - 获取对象信息
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id15)
          - [请求头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id16)
        - 获取对象 ACL
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id17)
          - [响应实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id18)
        - 设置对象 ACL
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id20)
          - [请求实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id21)
        - 初始化分块上传
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id23)
          - [请求头](http://docs.ceph.org.cn/radosgw/s3/objectops/#id24)
          - [响应实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id25)
        - 分块上传之块
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id27)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/s3/objectops/#http)
        - 列出分块上传的块
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id29)
          - [响应实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id30)
        - 完成分块上传
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id32)
          - [请求实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id33)
          - [响应实体](http://docs.ceph.org.cn/radosgw/s3/objectops/#id34)
        - 取消分块上传
          - [语法](http://docs.ceph.org.cn/radosgw/s3/objectops/#id36)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/cpp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/bucketops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/csharp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/objectops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# S3 的 C++ 接口实例

## 配置

下面的 includes 和 globals 将会在随后的例子中用到:

```
#include "libs3.h"
#include <stdlib.h>
#include <iostream>
#include <fstream>

const char access_key[] = "ACCESS_KEY";
const char secret_key[] = "SECRET_KEY";
const char host[] = "HOST";
const char sample_bucket[] = "sample_bucket";
const char sample_key[] = "hello.txt";
const char sample_file[] = "resource/hello.txt";

S3BucketContext bucketContext =
{
        host,
        sample_bucket,
        S3ProtocolHTTP,
        S3UriStylePath,
        access_key,
        secret_key
};

S3Status responsePropertiesCallback(
                const S3ResponseProperties *properties,
                void *callbackData)
{
        return S3StatusOK;
}

static void responseCompleteCallback(
                S3Status status,
                const S3ErrorDetails *error,
                void *callbackData)
{
        return;
}

S3ResponseHandler responseHandler =
{
        &responsePropertiesCallback,
        &responseCompleteCallback
};
```

## 新建 (和关闭) 一个连接

下面的代码将新建一个连接用来很服务器进行交互.

```
S3_initialize("s3", S3_INIT_ALL, host);
// Do stuff...
S3_deinitialize();
```

## 列出当前用户的所有 Bucket

下面的代码会列出你所有的 bucket 的列表。 这也会打印出每个bucket的 bucket 名、所有者 ID 和显示名称

```
static S3Status listServiceCallback(
                const char *ownerId,
                const char *ownerDisplayName,
                const char *bucketName,
                int64_t creationDate, void *callbackData)
{
        bool *header_printed = (bool*) callbackData;
        if (!*header_printed) {
                *header_printed = true;
                printf("%-22s", "       Bucket");
                printf("  %-20s  %-12s", "     Owner ID", "Display Name");
                printf("\n");
                printf("----------------------");
                printf("  --------------------" "  ------------");
                printf("\n");
        }

        printf("%-22s", bucketName);
        printf("  %-20s  %-12s", ownerId ? ownerId : "", ownerDisplayName ? ownerDisplayName : "");
        printf("\n");

        return S3StatusOK;
}

S3ListServiceHandler listServiceHandler =
{
        responseHandler,
        &listServiceCallback
};
bool header_printed = false;
S3_list_service(S3ProtocolHTTP, access_key, secret_key, host, 0, &listServiceHandler, &header_printed);
```

## 新建一个 Bucket

这会新建一个 bucket。

```
S3_create_bucket(S3ProtocolHTTP, access_key, secret_key, host, sample_bucket, S3CannedAclPrivate, NULL, NULL, &responseHandler, NULL);
```

## 列出 Bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
static S3Status listBucketCallback(
                int isTruncated,
                const char *nextMarker,
                int contentsCount,
                const S3ListBucketContent *contents,
                int commonPrefixesCount,
                const char **commonPrefixes,
                void *callbackData)
{
        printf("%-22s", "      Object Name");
        printf("  %-5s  %-20s", "Size", "   Last Modified");
        printf("\n");
        printf("----------------------");
        printf("  -----" "  --------------------");
        printf("\n");

    for (int i = 0; i < contentsCount; i++) {
        char timebuf[256];
                char sizebuf[16];
        const S3ListBucketContent *content = &(contents[i]);
                time_t t = (time_t) content->lastModified;

                strftime(timebuf, sizeof(timebuf), "%Y-%m-%dT%H:%M:%SZ", gmtime(&t));
                sprintf(sizebuf, "%5llu", (unsigned long long) content->size);
                printf("%-22s  %s  %s\n", content->key, sizebuf, timebuf);
    }

    return S3StatusOK;
}

S3ListBucketHandler listBucketHandler =
{
        responseHandler,
        &listBucketCallback
};
S3_list_bucket(&bucketContext, NULL, NULL, NULL, 0, NULL, &listBucketHandler, NULL);
```

输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除一个 Bucket

Note

Bucket必须为空！否则它不会工作!

```
S3_delete_bucket(S3ProtocolHTTP, S3UriStylePath, access_key, secret_key, host, sample_bucket, NULL, &responseHandler, NULL);
```

## 新建一个对象 (来源于一个文件)

下面的代码会新建一个文件``hello.txt``.

```
#include <sys/stat.h>
typedef struct put_object_callback_data
{
    FILE *infile;
    uint64_t contentLength;
} put_object_callback_data;


static int putObjectDataCallback(int bufferSize, char *buffer, void *callbackData)
{
    put_object_callback_data *data = (put_object_callback_data *) callbackData;

    int ret = 0;

    if (data->contentLength) {
        int toRead = ((data->contentLength > (unsigned) bufferSize) ? (unsigned) bufferSize : data->contentLength);
                ret = fread(buffer, 1, toRead, data->infile);
    }
    data->contentLength -= ret;
    return ret;
}

put_object_callback_data data;
struct stat statbuf;
if (stat(sample_file, &statbuf) == -1) {
        fprintf(stderr, "\nERROR: Failed to stat file %s: ", sample_file);
        perror(0);
        exit(-1);
}

int contentLength = statbuf.st_size;
data.contentLength = contentLength;

if (!(data.infile = fopen(sample_file, "r"))) {
        fprintf(stderr, "\nERROR: Failed to open input file %s: ", sample_file);
        perror(0);
        exit(-1);
}

S3PutObjectHandler putObjectHandler =
{
        responseHandler,
        &putObjectDataCallback
};

S3_put_object(&bucketContext, sample_key, contentLength, NULL, NULL, &putObjectHandler, &data);
```

## 下载一个对象 (到文件)

下面的代码会下载一个文件并打印它的内容.

```
static S3Status getObjectDataCallback(int bufferSize, const char *buffer, void *callbackData)
{
        FILE *outfile = (FILE *) callbackData;
        size_t wrote = fwrite(buffer, 1, bufferSize, outfile);
        return ((wrote < (size_t) bufferSize) ? S3StatusAbortedByCallback : S3StatusOK);
}

S3GetObjectHandler getObjectHandler =
{
        responseHandler,
        &getObjectDataCallback
};
FILE *outfile = stdout;
S3_get_object(&bucketContext, sample_key, NULL, 0, 0, NULL, &getObjectHandler, outfile);
```

## 删除一个对象

下面的代码会删除一个对象.

```
S3ResponseHandler deleteResponseHandler =
{
        0,
        &responseCompleteCallback
};
S3_delete_object(&bucketContext, sample_key, 0, &deleteResponseHandler, 0);
```

## 改变一个对象的 ACL

下面的代码会改变一个对象的 ACL 来授权所有控制给另一个用户.

```
#include <string.h>
char ownerId[] = "owner";
char ownerDisplayName[] = "owner";
char granteeId[] = "grantee";
char granteeDisplayName[] = "grantee";

S3AclGrant grants[] = {
        {
                S3GranteeTypeCanonicalUser,
                {{}},
                S3PermissionFullControl
        },
        {
                S3GranteeTypeCanonicalUser,
                {{}},
                S3PermissionReadACP
        },
        {
                S3GranteeTypeAllUsers,
                {{}},
                S3PermissionRead
        }
};

strncpy(grants[0].grantee.canonicalUser.id, ownerId, S3_MAX_GRANTEE_USER_ID_SIZE);
strncpy(grants[0].grantee.canonicalUser.displayName, ownerDisplayName, S3_MAX_GRANTEE_DISPLAY_NAME_SIZE);

strncpy(grants[1].grantee.canonicalUser.id, granteeId, S3_MAX_GRANTEE_USER_ID_SIZE);
strncpy(grants[1].grantee.canonicalUser.displayName, granteeDisplayName, S3_MAX_GRANTEE_DISPLAY_NAME_SIZE);

S3_set_acl(&bucketContext, sample_key, ownerId, ownerDisplayName, 3, grants, 0, &responseHandler, 0);
```

## 生成对象下载 URL (带签名)

下面的代码会生成一个带签名的有效时间为5分钟的下载URL

```
#include <time.h>
char buffer[S3_MAX_AUTHENTICATED_QUERY_STRING_SIZE];
int64_t expires = time(NULL) + 60 * 5; // Current time + 5 minutes

S3_generate_authenticated_query_string(buffer, &bucketContext, sample_key, expires, NULL);
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - C++
        - [配置](http://docs.ceph.org.cn/radosgw/s3/cpp/#id1)
        - [新建 (和关闭) 一个连接](http://docs.ceph.org.cn/radosgw/s3/cpp/#id2)
        - [列出当前用户的所有 Bucket](http://docs.ceph.org.cn/radosgw/s3/cpp/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/cpp/#id3)
        - [列出 Bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/cpp/#id4)
        - [删除一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/cpp/#id5)
        - [新建一个对象 (来源于一个文件)](http://docs.ceph.org.cn/radosgw/s3/cpp/#id6)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/cpp/#id7)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/cpp/#id8)
        - [改变一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/cpp/#acl)
        - [生成对象下载 URL (带签名)](http://docs.ceph.org.cn/radosgw/s3/cpp/#url)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/csharp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/objectops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/java/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/cpp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# C# S3 样例

## 新建一个连接

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
using System;
using Amazon;
using Amazon.S3;
using Amazon.S3.Model;

string accessKey = "put your access key here!";
string secretKey = "put your secret key here!";

AmazonS3Config config = new AmazonS3Config();
config.ServiceURL = "objects.dreamhost.com";

AmazonS3Client s3Client = new AmazonS3Client(
        accessKey,
        secretKey,
        config
        );
```

## 列出用户的所有 bucket

下面的代码会列出你的 bucket 的列表。 这也会打印出每个bucket的 bucket 名和创建时间。

```
ListBucketsResponse response = client.ListBuckets();
foreach (S3Bucket b in response.Buckets)
{
        Console.WriteLine("{0}\t{1}", b.BucketName, b.CreationDate);
}
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
PutBucketRequest request = new PutBucketRequest();
request.BucketName = "my-new-bucket";
client.PutBucket(request);
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
ListObjectsRequest request = new ListObjectsRequest();
request.BucketName = "my-new-bucket";
ListObjectsResponse response = client.ListObjects(request);
foreach (S3Object o in response.S3Objects)
{
        Console.WriteLine("{0}\t{1}\t{2}", o.Key, o.Size, o.LastModified);
}
```

输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

Note

Bucket必须为空！否则它不会工作!

```
DeleteBucketRequest request = new DeleteBucketRequest();
request.BucketName = "my-new-bucket";
client.DeleteBucket(request);
```

## 强制删除非空 Buckets

Attention

不支持

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
PutObjectRequest request = new PutObjectRequest();
request.BucketName      = "my-new-bucket";
request.Key         = "hello.txt";
request.ContentType = "text/plain";
request.ContentBody = "Hello World!";
client.PutObject(request);
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
PutACLRequest request = new PutACLRequest();
request.BucketName = "my-new-bucket";
request.Key        = "hello.txt";
request.CannedACL  = S3CannedACL.PublicRead;
client.PutACL(request);

PutACLRequest request2 = new PutACLRequest();
request2.BucketName = "my-new-bucket";
request2.Key        = "secret_plans.txt";
request2.CannedACL  = S3CannedACL.Private;
client.PutACL(request2);
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
GetObjectRequest request = new GetObjectRequest();
request.BucketName = "my-new-bucket";
request.Key        = "perl_poetry.pdf";
GetObjectResponse response = client.GetObject(request);
response.WriteResponseStreamToFile("C:\\Users\\larry\\Documents\\perl_poetry.pdf");
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
DeleteObjectRequest request = new DeleteObjectRequest();
request.BucketName = "my-new-bucket";
request.Key        = "goodbye.txt";
client.DeleteObject(request);
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

Note

C# S3 库不支持生成不带签名的URLs，因此下面的实例只会展 示如何生成代签名的 URLs.

```
GetPreSignedUrlRequest request = new GetPreSignedUrlRequest();
request.BucketName = "my-bucket-name";
request.Key        = "secret_plans.txt";
request.Expires    = DateTime.Now.AddHours(1);
request.Protocol   = Protocol.HTTP;
string url = client.GetPreSignedURL(request);
Console.WriteLine(url);
```

输出形式类似下面这样:

```
http://objects.dreamhost.com/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - C#
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/csharp/#id1)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/csharp/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/csharp/#id2)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/csharp/#id3)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/csharp/#id4)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/csharp/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/csharp/#id5)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/csharp/#acl)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/csharp/#id6)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/csharp/#id7)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/csharp/#urls)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/java/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/cpp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/perl/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/csharp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# Java S3 样例

## 设置

下面的样例可能需要一些或者所有这里导入 的 java 类

```
import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.List;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.util.StringUtils;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3ObjectSummary;
```

如果你只是测试 Ceph 对象存储服务，考虑使用 HTTP 协议而不是 HTTPS。

首先，导入 `ClientConfiguration` 和 `Protocol`

```
import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
```

然后，定义客户端配置，并为 S3 客户端添加客户 端配置作为一个参数

```
AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);

ClientConfiguration clientConfig = new ClientConfiguration();
clientConfig.setProtocol(Protocol.HTTP);

AmazonS3 conn = new AmazonS3Client(credentials, clientConfig);
conn.setEndpoint("endpoint.com");
```

## 新建一个连接

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
String accessKey = "insert your access key here!";
String secretKey = "insert your secret key here!";

AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
AmazonS3 conn = new AmazonS3Client(credentials);
conn.setEndpoint("objects.dreamhost.com");
```

## 列出用户的所有 bucket

下面的代码会列出你的 bucket 的列表。 这也会打印出每个bucket的 bucket 名和创建时间。

```
List<Bucket> buckets = conn.listBuckets();
for (Bucket bucket : buckets) {
        System.out.println(bucket.getName() + "\t" +
                StringUtils.fromDate(bucket.getCreationDate()));
}
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
Bucket bucket = conn.createBucket("my-new-bucket");
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
ObjectListing objects = conn.listObjects(bucket.getName());
do {
        for (S3ObjectSummary objectSummary : objects.getObjectSummaries()) {
                System.out.println(objectSummary.getKey() + "\t" +
                        ObjectSummary.getSize() + "\t" +
                        StringUtils.fromDate(objectSummary.getLastModified()));
        }
        objects = conn.listNextBatchOfObjects(objects);
} while (objects.isTruncated());
```

输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

Note

Bucket必须为空！否则它不会工作!

```
conn.deleteBucket(bucket.getName());
```

## 强制删除非空 Buckets

Attention

不支持

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
ByteArrayInputStream input = new ByteArrayInputStream("Hello World!".getBytes());
conn.putObject(bucket.getName(), "hello.txt", input, new ObjectMetadata());
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
conn.setObjectAcl(bucket.getName(), "hello.txt", CannedAccessControlList.PublicRead);
conn.setObjectAcl(bucket.getName(), "secret_plans.txt", CannedAccessControlList.Private);
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
conn.getObject(
        new GetObjectRequest(bucket.getName(), "perl_poetry.pdf"),
        new File("/home/larry/documents/perl_poetry.pdf")
);
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
conn.deleteObject(bucket.getName(), "goodbye.txt");
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

Note

C# S3 库不支持生成不带签名的URLs，因此下面的实例只会展 示如何生成代签名的 URLs.

```
GeneratePresignedUrlRequest request = new GeneratePresignedUrlRequest(bucket.getName(), "secret_plans.txt");
System.out.println(conn.generatePresignedUrl(request));
```

输出形式类似下面这样:

```
https://my-bucket-name.objects.dreamhost.com/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - Java
        - [设置](http://docs.ceph.org.cn/radosgw/s3/java/#id1)
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/java/#id2)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/java/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/java/#id3)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/java/#id4)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/java/#id5)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/java/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/java/#id6)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/java/#acl)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/java/#id7)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/java/#id8)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/java/#urls)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/perl/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/csharp/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/php/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/java/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# Perl S3 样例

## 新建一个连接[¶](http://docs.ceph.org.cn/radosgw/s3/perl/#id1)

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
use Amazon::S3;
my $access_key = 'put your access key here!';
my $secret_key = 'put your secret key here!';

my $conn = Amazon::S3->new({
        aws_access_key_id     => $access_key,
        aws_secret_access_key => $secret_key,
        host                  => 'objects.dreamhost.com',
        secure                => 1,
        retry                 => 1,
});
```

## 列出用户的所有 bucket

下面的代码会获取你拥有的 [Amazon::S3::Bucket](http://search.cpan.org/~tima/Amazon-S3-0.441/lib/Amazon/S3/Bucket.pm) 类型的对象列表。 这也会打印出每个bucket的 bucket 名和创建时间。

```
my @buckets = @{$conn->buckets->{buckets} || []};
foreach my $bucket (@buckets) {
        print $bucket->bucket . "\t" . $bucket->creation_date . "\n";
}
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
my $bucket = $conn->add_bucket({ bucket => 'my-new-bucket' });
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
my @keys = @{$bucket->list_all->{keys} || []};
foreach my $key (@keys) {
        print "$key->{key}\t$key->{size}\t$key->{last_modified}\n";
}
```

输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

Note

Bucket必须为空！否则它不会工作!

```
$conn->delete_bucket($bucket);
```

## 强制删除非空 Buckets

Attention

perl 模块 [Amazon::S3](http://search.cpan.org/~tima/Amazon-S3-0.441/lib/Amazon/S3.pm) 不支持

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
$bucket->add_key(
        'hello.txt', 'Hello World!',
        { content_type => 'text/plain' },
);
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
$bucket->set_acl({
        key       => 'hello.txt',
        acl_short => 'public-read',
});
$bucket->set_acl({
        key       => 'secret_plans.txt',
        acl_short => 'private',
});
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
$bucket->get_key_filename('perl_poetry.pdf', undef,
        '/home/larry/documents/perl_poetry.pdf');
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
$bucket->delete_key('goodbye.txt');
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

Note

[Amazon::S3](http://search.cpan.org/~tima/Amazon-S3-0.441/lib/Amazon/S3.pm) 模块还不支持生成下载 URL ,所以 我们要使用另一个模块。不幸的是，大多数生成这些  URL 的模块都假设你使用的是亚马逊，所以我们不得不 使用一个更模糊的模块 [Muck::FS::S3](http://search.cpan.org/~mike/Muck-0.02/) 。这应该和 Amazon S3 的 perl 模块的样例一样，但是这个样例模 块不在CPAN 中。所以，你可以使用CPAN安装 [Muck::FS::S3](http://search.cpan.org/~mike/Muck-0.02/)，或手动安装 Amazon 的 S3模块示例。如果你遵循手册的 路线，你可以在下面的示例中删除 `Muck::FS::`。

```
use Muck::FS::S3::QueryStringAuthGenerator;
my $generator = Muck::FS::S3::QueryStringAuthGenerator->new(
        $access_key,
        $secret_key,
        0, # 0 means use 'http'. set this to 1 for 'https'
        'objects.dreamhost.com',
);

my $hello_url = $generator->make_bare_url($bucket->bucket, 'hello.txt');
print $hello_url . "\n";

$generator->expires_in(3600); # 1 hour = 3600 seconds
my $plans_url = $generator->get($bucket->bucket, 'secret_plans.txt');
print $plans_url . "\n";
```

输出形式类似下面这样:

```
http://objects.dreamhost.com:80/my-bucket-name/hello.txt
http://objects.dreamhost.com:80/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - Perl
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/perl/#id1)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/perl/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/perl/#id2)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/perl/#id3)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/perl/#id4)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/perl/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/perl/#id5)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/perl/#acl)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/perl/#id6)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/perl/#id7)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/perl/#urls)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/php/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/java/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/python/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/perl/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# PHP S3 样例

## 新建一个连接

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
<?php
define('AWS_KEY', 'place access key here');
define('AWS_SECRET_KEY', 'place secret key here');
define('AWS_CANONICAL_ID', 'your DHO Username');
define('AWS_CANONICAL_NAME', 'Also your DHO Username!');
$HOST = 'objects.dreamhost.com';

// require the amazon sdk for php library
require_once 'AWSSDKforPHP/sdk.class.php';

// Instantiate the S3 class and point it at the desired host
$Connection = new AmazonS3(array(
        'key' => AWS_KEY,
        'secret' => AWS_SECRET_KEY,
        'canonical_id' => AWS_CANONICAL_ID,
        'canonical_name' => AWS_CANONICAL_NAME,
));
$Connection->set_hostname($HOST);
$Connection->allow_hostname_override(false);

// Set the S3 class to use objects.dreamhost.com/bucket
// instead of bucket.objects.dreamhost.com
$Connection->enable_path_style();
```

## 列出用户的所有 bucket

下面的代码会生成 CFSimpleXML 类型的对象列表，它代表你拥有的bucket。这也会打印出每个bucket 的 bucket 名和创建时间。

```
<?php
$ListResponse = $Connection->list_buckets();
$Buckets = $ListResponse->body->Buckets->Bucket;
foreach ($Buckets as $Bucket) {
        echo $Bucket->Name . "\t" . $Bucket->CreationDate . "\n";
}
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket，并返回一个 `CFResponse` 对象

Note

这个命令需要指定 region 作为第二个参数， 所以我们使用 `AmazonS3::REGION_US_E1`, 因为它的内容是 `''`

```
<?php
$Connection->create_bucket('my-new-bucket', AmazonS3::REGION_US_E1);
```

## 列出 bucket 的内容

下面的代码会输出 `CFSimpleXML` 对象的一个数组，它代表了bucket内的对象。这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
<?php
$ObjectsListResponse = $Connection->list_objects($bucketname);
$Objects = $ObjectsListResponse->body->Contents;
foreach ($Objects as $Object) {
        echo $Object->Key . "\t" . $Object->Size . "\t" . $Object->LastModified . "\n";
}
```

Note

如果在这个 bucket 中有超过1000个对象，你需要检查  $ObjectListResponse->body->isTruncated 的值，然后使用列出的最后一个 key  的名字再次运行。一直这样 做直到 isTruncated 的值不再是 true。

如果该 bucket 内有文件，输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

下面的代码会删除名为 `my-old-bucket` 的 bucket，并返回一个 `CFResponse` 对象。

Note

Bucket必须为空！否则它不会工作!

```
<?php
$Connection->delete_bucket('my-old-bucket');
```

## 强制删除非空 Buckets

下面的代码会删除一个 bucket 即使它不是空的。

```
<?php
$Connection->delete_bucket('my-old-bucket', 1);
```

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
<?php
$Connection->create_object('my-bucket-name', 'hello.txt', array(
        'body' => "Hello World!",
));
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
<?php
$Connection->set_object_acl('my-bucket-name', 'hello.txt', AmazonS3::ACL_PUBLIC);
$Connection->set_object_acl('my-bucket-name', 'secret_plans.txt', AmazonS3::ACL_PRIVATE);
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
<?php
$Connection->delete_object('my-bucket-name', 'goodbye.txt');
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
<?php
$FileHandle = fopen('/home/larry/documents/poetry.pdf', 'w+');
$Connection->get_object('my-bucket-name', 'poetry.pdf', array(
        'fileDownload' => $FileHandle,
));
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下 载URL。这个操作会生效是因为前面我们已经设置 `hello.txt` 的ACL 为公开可读。下面的代码同时会 为 `secret_plans.txt` 生成一个有效时间是一个小 时的带签名的下载 URL。带签名的下载URL 在这个时间内 是可用的，即使对象的权限是私有(当时间到期后URL 将不 可用)。

```
<?php
my $plans_url = $Connection->get_object_url('my-bucket-name', 'hello.txt');
echo $plans_url . "\n";
my $secret_url = $Connection->get_object_url('my-bucket-name', 'secret_plans.txt', '1 hour');
echo $secret_url . "\n";
```

输出形式类似下面这样:

```
http://objects.dreamhost.com/my-bucket-name/hello.txt
http://objects.dreamhost.com/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - PHP
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/php/#id1)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/php/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/php/#id2)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/php/#id3)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/php/#id4)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/php/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/php/#id5)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/php/#acl)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/php/#id6)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/php/#id7)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/php/#urls)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/python/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/perl/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/ruby/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/php/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# Python S3 样例

## 新建一个连接

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
import boto
import boto.s3.connection
access_key = 'put your access key here!'
secret_key = 'put your secret key here!'

conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,
        host = 'objects.dreamhost.com',
        #is_secure=False,               # uncomment if you are not using ssl
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )
```

## 列出用户的所有 bucket

下面的代码会列出你的 bucket 的列表。 这也会打印出每个bucket的 bucket 名和创建时间。

```
for bucket in conn.get_all_buckets():
        print "{name}\t{created}".format(
                name = bucket.name,
                created = bucket.creation_date,
        )
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
bucket = conn.create_bucket('my-new-bucket')
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
for key in bucket.list():
        print "{name}\t{size}\t{modified}".format(
                name = key.name,
                size = key.size,
                modified = key.last_modified,
                )
```

输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

Note

Bucket必须为空！否则它不会工作!

```
conn.delete_bucket(bucket.name)
```

## 强制删除非空 Buckets

Attention

不支持

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
key = bucket.new_key('hello.txt')
key.set_contents_from_string('Hello World!')
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
hello_key = bucket.get_key('hello.txt')
hello_key.set_canned_acl('public-read')
plans_key = bucket.get_key('secret_plans.txt')
plans_key.set_canned_acl('private')
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
key = bucket.get_key('perl_poetry.pdf')
key.get_contents_to_filename('/home/larry/documents/perl_poetry.pdf')
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
bucket.delete_key('goodbye.txt')
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

```
hello_key = bucket.get_key('hello.txt')
hello_url = hello_key.generate_url(0, query_auth=False, force_http=True)
print hello_url

plans_key = bucket.get_key('secret_plans.txt')
plans_url = plans_key.generate_url(3600, query_auth=True, force_http=True)
print plans_url
```

输出形式类似下面这样:

```
http://objects.dreamhost.com/my-bucket-name/hello.txt
http://objects.dreamhost.com/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - Python
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/python/#id1)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/python/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/python/#id2)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/python/#id3)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/python/#id4)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/python/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/python/#id5)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/python/#acl)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/python/#id6)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/python/#id7)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/python/#urls)
      - [Ruby AWS::SDK 样例 (aws-sdk gem ~>2)](http://docs.ceph.org.cn/radosgw/s3/ruby/)
      - [Ruby AWS::S3 样例 (aws-s3 gem)](http://docs.ceph.org.cn/radosgw/s3/ruby/#ruby-aws-s3-aws-s3-gem)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/ruby/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/php/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/python/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »



# Ruby [AWS::SDK](http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html) 样例 (aws-sdk gem ~>2)

## 设置

你可以用全局方法配置连接：

```
Aws.config.update(
        endpoint: 'https://objects.dreamhost.com.',
        access_key_id: 'my-access-key',
        secret_access_key: 'my-secret-key',
        force_path_style: true,
        region: 'us-east-1'
)
```

并把客户端对象实例化：

```
s3_client = Aws::S3::Client.new
```

## 列出用户的所有 bucket

下面的代码会列出你的 bucket 的列表。 这也会打印出每个bucket的 bucket 名和创建时间。

```
s3_client.list_buckets.buckets.each do |bucket|
        puts "#{bucket.name}\t#{bucket.creation_date}"
end
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
s3_client.create_bucket(bucket: 'my-new-bucket')
```

如果你想要新建一个私有bucket:

acl 选项接收的参数有: # private, public-read, public-read-write, authenticated-read

```
s3_client.create_bucket(bucket: 'my-new-bucket', acl: 'private')
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
s3_client.get_objects(bucket: 'my-new-bucket').contents.each do |object|
        puts "#{object.key}\t#{object.size}\t#{object.last-modified}"
end
```

如果 bucket 内有文件，输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.j‰g 262518  2011-08-08T21:38:01.000Z
```

## 删除桶

Note

Bucket必须为空！否则它不会工作!

```
s3_client.delete_bucket(bucket: 'my-new-bucket')
```

## 强行删除非空 bucket

首先，你需要清空这个 bucket:

```
Aws::S3::Bucket.new('my-new-bucket', client: s3_client).clear!
```

然后删除这个 bucket

```
s3_client.delete_bucket(bucket: 'my-new-bucket')
```

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
s3_client.put_object(
        key: 'hello.txt',
        body: 'Hello World!',
        bucket: 'my-new-bucket',
        content_type: 'text/plain'
)
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
s3_client.put_object_acl(bucket: 'my-new-bucket', key: 'hello.txt', acl: 'public-read')

s3_client.put_object_acl(bucket: 'my-new-bucket', key: 'private.txt', acl: 'private')
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
s3_client.get_object(bucket: 'my-new-bucket', key: 'poetry.pdf', response_target: '/home/larry/documents/poetry.pdf')
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
s3_client.delete_object(key: 'goodbye.txt', bucket: 'my-new-bucket')
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

```
puts Aws::S3::Object.new(
        key: 'hello.txt',
        bucket_name: 'my-new-bucket',
        client: s3_client
).public_url

puts Aws::S3::Object.new(
        key: 'secret_plans.txt',
        bucket_name: 'hermes_ceph_gem',
        client: s3_client
).presigned_url(:get, expires_in: 60 * 60)
```

输出形式类似下面这样:

```
http://objects.dreamhost.com/my-bucket-name/hello.txt
http://objects.dreamhost.com/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

# Ruby [AWS::S3](http://amazon.rubyforge.org/) 样例 (aws-s3 gem)

## 新建一个连接

下面的代码会新建一个连接，这样你就可以和服务器交互.

```
AWS::S3::Base.establish_connection!(
        :server            => 'objects.dreamhost.com',
        :use_ssl           => true,
        :access_key_id     => 'my-access-key',
        :secret_access_key => 'my-secret-key'
)
```

## 列出用户的所有 bucket

下面的代码会列出一个 [AWS::S3::Bucket](http://amazon.rubyforge.org/doc/)  对象类型的列表，这代 表你拥有的bucket。这也会打印出每个bucket的 bucket 名和创建时间。

```
AWS::S3::Service.buckets.each do |bucket|
        puts "#{bucket.name}\t#{bucket.creation_date}"
end
```

输出形式类似下面这样:

```
mahbuckat1   2011-04-21T18:05:39.000Z
mahbuckat2   2011-04-21T18:05:48.000Z
mahbuckat3   2011-04-21T18:07:18.000Z
```

## 新建一个 Bucket

下面的代码会新建一个名为 `my-new-bucket` 的bucket。

```
AWS::S3::Bucket.create('my-new-bucket')
```

## 列出 bucket 的内容

下面的代码会输出 bucket 内的所有对象列表。 这也会打印出每一个对象的名字、文件尺寸和最近修改时间。

```
new_bucket = AWS::S3::Bucket.find('my-new-bucket')
new_bucket.each do |object|
        puts "#{object.key}\t#{object.about['content-length']}\t#{object.about['last-modified']}"
end
```

如果 bucket 内有文件，输出形式类似下面这样:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 删除 Bucket

Note

Bucket必须为空！否则它不会工作!

```
AWS::S3::Bucket.delete('my-new-bucket')
```

## 强制删除非空 Buckets

```
AWS::S3::Bucket.delete('my-new-bucket', :force => true)
```

## 新建一个对象

下面的代码会新建一个内容是字符串``”Hello World!”`` 的文件 `hello.txt`。

```
AWS::S3::S3Object.store(
        'hello.txt',
        'Hello World!',
        'my-new-bucket',
        :content_type => 'text/plain'
)
```

## 修改一个对象的 ACL

下面的代码会将对象 `hello.txt` 的权限变为公开可读，而将 `secret_plans.txt` 的权限设为私有。

```
policy = AWS::S3::S3Object.acl('hello.txt', 'my-new-bucket')
policy.grants = [ AWS::S3::ACL::Grant.grant(:public_read) ]
AWS::S3::S3Object.acl('hello.txt', 'my-new-bucket', policy)

policy = AWS::S3::S3Object.acl('secret_plans.txt', 'my-new-bucket')
policy.grants = []
AWS::S3::S3Object.acl('secret_plans.txt', 'my-new-bucket', policy)
```

## 下载一个对象 (到文件)

下面的代码会下载对象 `perl_poetry.pdf` 并将它存到位置 `C:\Users\larry\Documents`

```
open('/home/larry/documents/poetry.pdf', 'w') do |file|
        AWS::S3::S3Object.stream('poetry.pdf', 'my-new-bucket') do |chunk|
                file.write(chunk)
        end
end
```

## 删除一个对象

下面的代码会删除对象 `goodbye.txt`

```
AWS::S3::S3Object.delete('goodbye.txt', 'my-new-bucket')
```

## 生成对象的下载 URLs (带签名和不带签名)

下面的代码会为 `hello.txt` 生成一个无签名为下载URL。 这个操作是生效是因为前面我们已经设置 `hello.txt` 的 ACL 为公开可读。下面的代码同时会为 `secret_plans.txt` 生成一个有效时间是一个小时的带签名的下载 URL。带签名的下载 URL 在这个时间内是可用的，即使对象的权限是私有(当时间到期后 URL 将不可用)。

```
puts AWS::S3::S3Object.url_for(
        'hello.txt',
        'my-new-bucket',
        :authenticated => false
)

puts AWS::S3::S3Object.url_for(
        'secret_plans.txt',
        'my-new-bucket',
        :expires_in => 60 * 60
)
```

输出形式类似下面这样:

```
http://objects.dreamhost.com/my-bucket-name/hello.txt
http://objects.dreamhost.com/my-bucket-name/secret_plans.txt?Signature=XXXXXXXXXXXXXXXXXXXXXXXXXXX&Expires=1316027075&AWSAccessKeyId=XXXXXXXXXXXXXXXXXXX
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - S3 API
    - API
      - [通用](http://docs.ceph.org.cn/radosgw/s3/commons/)
      - [认证](http://docs.ceph.org.cn/radosgw/s3/authentication/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/s3/serviceops/)
      - [Bucket 操作](http://docs.ceph.org.cn/radosgw/s3/bucketops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/s3/objectops/)
      - [C++](http://docs.ceph.org.cn/radosgw/s3/cpp/)
      - [C#](http://docs.ceph.org.cn/radosgw/s3/csharp/)
      - [Java](http://docs.ceph.org.cn/radosgw/s3/java/)
      - [Perl](http://docs.ceph.org.cn/radosgw/s3/perl/)
      - [PHP](http://docs.ceph.org.cn/radosgw/s3/php/)
      - [Python](http://docs.ceph.org.cn/radosgw/s3/python/)
      - Ruby AWS::SDK 样例 (aws-sdk gem ~>2)
        - [设置](http://docs.ceph.org.cn/radosgw/s3/ruby/#id1)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#bucket)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#id2)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/ruby/#id3)
        - [删除桶](http://docs.ceph.org.cn/radosgw/s3/ruby/#id4)
        - [强行删除非空 bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#id5)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/ruby/#id6)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/ruby/#acl)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/ruby/#id7)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/ruby/#id8)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/ruby/#urls)
      - Ruby AWS::S3 样例 (aws-s3 gem)
        - [新建一个连接](http://docs.ceph.org.cn/radosgw/s3/ruby/#id9)
        - [列出用户的所有 bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#id10)
        - [新建一个 Bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#id11)
        - [列出 bucket 的内容](http://docs.ceph.org.cn/radosgw/s3/ruby/#id12)
        - [删除 Bucket](http://docs.ceph.org.cn/radosgw/s3/ruby/#id13)
        - [强制删除非空 Buckets](http://docs.ceph.org.cn/radosgw/s3/ruby/#buckets)
        - [新建一个对象](http://docs.ceph.org.cn/radosgw/s3/ruby/#id14)
        - [修改一个对象的 ACL](http://docs.ceph.org.cn/radosgw/s3/ruby/#id15)
        - [下载一个对象 (到文件)](http://docs.ceph.org.cn/radosgw/s3/ruby/#id16)
        - [删除一个对象](http://docs.ceph.org.cn/radosgw/s3/ruby/#id17)
        - [生成对象的下载 URLs (带签名和不带签名)](http://docs.ceph.org.cn/radosgw/s3/ruby/#id18)
    - [功能支持情况](http://docs.ceph.org.cn/radosgw/s3/#id1)
    - [不支持的 Header 字段](http://docs.ceph.org.cn/radosgw/s3/#header)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/python/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关的 S3 兼容 API](http://docs.ceph.org.cn/radosgw/s3/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/auth/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/ruby/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# Ceph 对象网关 Swift API[¶](http://docs.ceph.org.cn/radosgw/swift/#ceph-swift-api)

Ceph 支持 REST 风格的 API ，它与 [Swift API](http://developer.openstack.org/api-ref-objectstorage-v1.html) 的基本访问模型兼容。

## API

- [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
- [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
- [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
- [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
- [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
- [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
- [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
- [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
- [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)

## 功能支持

下面的表格描述了对当前 Swift 功能的支持情况：

| 功能                          | 状态   | 备注               |
| ----------------------------- | ------ | ------------------ |
| **Authentication**            | 支持   |                    |
| **Get Account Metadata**      | 支持   |                    |
| **Swift ACLs**                | 支持   | 支持部分 Swift ACL |
| **List Containers**           | 支持   |                    |
| **Delete Container**          | 支持   |                    |
| **Create Container**          | 支持   |                    |
| **Get Container Metadata**    | 支持   |                    |
| **Update Container Metadata** | 支持   |                    |
| **Delete Container Metadata** | 支持   |                    |
| **List Objects**              | 支持   |                    |
| **Static Website**            | 不支持 |                    |
| **Create Object**             | 支持   |                    |
| **Create Large Object**       | 支持   |                    |
| **Delete Object**             | 支持   |                    |
| **Get Object**                | 支持   |                    |
| **Copy Object**               | 支持   |                    |
| **Get Object Metadata**       | 支持   |                    |
| **Update Object Metadata**    | 支持   |                    |
| **Expiring Objects**          | 支持   |                    |
| **Object Versioning**         | 不支持 |                    |
| **CORS**                      | 不支持 |                    |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/auth/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/s3/ruby/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/serviceops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# 认证

需要认证的 Swift API 请求必须在请求头里带上 `X-Storage-Token` 认证令牌。此令牌可以从 RADOS 网关、或别的认证器获取，要从 RADOS 网 关获取的话需创建用户，例如：

```
sudo radosgw-admin user create --uid="{username}" --display-name="{Display Name}"
```

For details on RADOS Gateway administration, see [radosgw-admin](http://docs.ceph.org.cn/man/8/radosgw-admin/).

## 获取认证

To authenticate a user, make a request containing an `X-Auth-User` and a `X-Auth-Key` in the header. 要对用户进行身份认证，需要构建一个请求头中有 `X-Auth-User` 和 `X-Auth-Key` 的请求

### 语法

```
GET /auth HTTP/1.1
Host: swift.radosgwhost.com
X-Auth-User: johndoe
X-Auth-Key: R7UUOLFDI2ZI9PRCQ53K
```

### 请求头

```
X-Auth-User
```

| 描述:     | 用来认证的 RADOS 网关用户的用户名 |
| --------- | --------------------------------- |
| 类型:     | String                            |
| 是否必需: | Yes                               |

```
X-Auth-Key
```

| 描述:     | RADOS 网关用户的密钥 |
| --------- | -------------------- |
| 类型:     | String               |
| 是否必需: | Yes                  |

### 响应头

服务器的响应应该包含一个 `X-Auth-Token` 值。响应也可能包含一个 `X-Storage-Url` ，它提供 `{api version}/{account}` 前缀，在整个API 文档的其他请求中指定的前缀。

```
X-Storage-Token
```

| 描述: | 在请求中 `X-Auth-User` 指定的用户的认证令牌 |
| ----- | ------------------------------------------- |
| 类型: | String                                      |

```
X-Storage-Url
```

| 描述: | URL 和为用户准备的 `{api version}/{account}` 路径. |
| ----- | -------------------------------------------------- |
| 类型: | String                                             |

一个典型的响应类似下面这样:

```
HTTP/1.1 204 No Content
Date: Mon, 16 Jul 2012 11:05:33 GMT
Server: swift
X-Storage-Url: https://swift.radosgwhost.com/v1/ACCT-12345
X-Auth-Token: UOlCCC8TahFKlWuv9DB09TWHF0nDjpPElha0kAa
Content-Length: 0
Content-Type: text/plain; charset=UTF-8
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - 认证
        - 获取认证
          - [语法](http://docs.ceph.org.cn/radosgw/swift/auth/#id3)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/auth/#id4)
          - [响应头](http://docs.ceph.org.cn/radosgw/swift/auth/#id5)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/serviceops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/containerops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/auth/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# 服务操作

要从我们的兼容 Swift 的服务中获取数据，你可以执行 `GET` 请求，在身份验证期间使用 `X-Storage-Url` 的值来获取。

## 列出所有容器

一个指定API版本和帐户的 `GET` 请求将返回特定 用户帐户的容器列表。因为这个请求返回一个特定用户 的容器，所以该请求需要一个身份验证令牌。这种请求 不能匿名。

### 语法

```
GET /{api version}/{account} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### 请求参数

```
limit
```

| 描述:     | 限制特定值的结果的数目 |
| --------- | ---------------------- |
| 类型:     | Integer                |
| 是否必需: | No                     |

```
format
```

| 描述:     | 定义结果的格式 |
| --------- | -------------- |
| 类型:     | String         |
| 有效值:   | `json` | `xml` |
| 是否必需: | No             |

```
marker
```

| 描述:     | 返回大于 marker 值的结果的列表 |
| --------- | ------------------------------ |
| 类型:     | String                         |
| 是否必需: | No                             |

### 响应实体

响应包含容器列表，或者返回一个 204 HTTP 响应代码。

```
account
```

| 描述: | 账户信息的列表 |
| ----- | -------------- |
| 类型: | Container      |

```
container
```

| 描述: | 容器列表  |
| ----- | --------- |
| 类型: | Container |

```
name
```

| 描述: | 容器名 |
| ----- | ------ |
| 类型: | String |

```
bytes
```

| 描述: | 容器空间大小 |
| ----- | ------------ |
| 类型: | Integer      |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - 服务操作
        - 列出所有容器
          - [语法](http://docs.ceph.org.cn/radosgw/swift/serviceops/#id3)
          - [请求参数](http://docs.ceph.org.cn/radosgw/swift/serviceops/#id4)
          - [响应实体](http://docs.ceph.org.cn/radosgw/swift/serviceops/#id5)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/containerops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/auth/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/objectops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/serviceops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# 容器操作

一个容器是一种用来存储数据对象的机制。一个帐户可 以有很多容器，但容器名称必须是唯一的。这个API允  许客户端创建一个容器，设置访问控制和元数据，检索 一个容器的内容，和删除一个容器。因为这个 API 的  请求涉及到一个特定用户的帐户相关信息，因此在这个 API 中的所有请求都必须经过身份验证，除非一个容器  的访问控制故意设置为公开访问。(即允许匿名的请求)。

Note

Amazon S3 API 使用 ‘bucket’ 这个词来描述一个 数据容器。当你听到有人在 Swift API 中提到一个 ‘bucket’ 时，’bucket’ 这个词可以被理解为相当于术语 ‘container‘ 。

对象存储的一个特点就是它不支持分层路径或目录。相反，它支持由一个或者多个容器组成一个层级，其中每个容器包 含若干对象。RADOS 网关的  兼容 Swift API支持 ‘pseudo-hierarchical containers’  的概念，就是一个使用对象的命名方式来模拟一个容器(或目录)实际 上没有实现一个存储系统层次。你可以使用 pseudo-hierarchical  名字来给对象命名。 (比如：photos/buildings/empire-state.jpg)，但容 器的名字不能包含一个正斜杠 (`/`) 字符。

## 新建一个容器

要创建一个新容器，需要构建一个 `PUT` 请求，带上 API 版本、账户和新容器的名称。容器名称必须是唯一的，不能包含斜杠 (/)字符，且应该小于256字节。在请求头信  息中你也可以包括访问控制和元数据等头信息。这个操作是 幂等的，也就是说,如果你构建一个请求来创建一个已经存在 的容器，它将返回一个 HTTP  202 返回代码，但不会创建另 一个容器。

### 语法

```
PUT /{api version}/{account}/{container} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
X-Container-Read: {comma-separated-uids}
X-Container-Write: {comma-separated-uids}
X-Container-Meta-{key}: {value}
```

### 头信息

```
X-Container-Read
```

| 描述:     | 有该容器的读权限的用户的 IDs |
| --------- | ---------------------------- |
| 类型:     | 逗号分隔的用户 ID 字符串值.  |
| 是否必需: | No                           |

```
X-Container-Write
```

| 描述:     | 有该容器的写权限的用户的 IDs |
| --------- | ---------------------------- |
| 类型:     | 逗号分隔的用户 ID 字符串值.  |
| 是否必需: | No                           |

```
X-Container-Meta-{key}
```

| 描述:     | 用户定义元数据的 key，一个任意的字符串值。 |
| --------- | ------------------------------------------ |
| 类型:     | String                                     |
| 是否必需: | No                                         |

### HTTP 响应

如果具有相同名称的容器已经存在，并且该用户是 该容器的所有者，则这个操作会成功。否则操作将 会失败。

```
409
```

| 描述:   | 容器已经存在，且归一个不同的用户的所有 |
| ------- | -------------------------------------- |
| 状态码: | `BucketAlreadyExists`                  |

## 列出容器内的对象

要列出一个容器内的所有对象，构建一个 `GET` 请求，带有 API 版本、帐户和容器的名称。您可以指定查询参数来过滤完整 列表，或置空该参数以返回该容器内存储的前10000个对象的名称 的列表。

### 语法

```
GET /{api version}/{container} HTTP/1.1
     Host: {fqdn}
     X-Auth-Token: {auth-token}
```

### 参数

```
format
```

| 描述:     | 定义结果的格式 |
| --------- | -------------- |
| 类型:     | String         |
| 有效值:   | `json` | `xml` |
| 是否必需: | No             |

```
prefix
```

| 描述:     | 限制所有结果的对象名以这个指定的前缀开始 |
| --------- | ---------------------------------------- |
| 类型:     | String                                   |
| 是否必需: | No                                       |

```
marker
```

| 描述:     | 返回的结果的列表大于 marker 的值 |
| --------- | -------------------------------- |
| 类型:     | String                           |
| 是否必需: | No                               |

```
limit
```

| 描述:     | 限制返回的结果的列表为这个指定的值 |
| --------- | ---------------------------------- |
| 类型:     | Integer                            |
| 有效范围: | 0 - 10,000                         |
| 是否必需: | No                                 |

```
delimiter
```

| 描述:     | 前缀和剩余对象名之间的分隔符 |
| --------- | ---------------------------- |
| 类型:     | String                       |
| 是否必需: | No                           |

```
path
```

| 描述:     | 对象的 pseudo-hierarchical 路径 |
| --------- | ------------------------------- |
| 类型:     | String                          |
| 是否必需: | No                              |

### 响应实体

```
container
```

| 描述: | 容器.     |
| ----- | --------- |
| 类型: | Container |

```
object
```

| 描述: | 容器内的对象 |
| ----- | ------------ |
| 类型: | Container    |

```
name
```

| 描述: | 容器内的对象的名称 |
| ----- | ------------------ |
| 类型: | String             |

```
hash
```

| 描述: | 对象内容的 hash 代码 |
| ----- | -------------------- |
| 类型: | String               |

```
last_modified
```

| 描述: | T对象内容的最近修改时间 |
| ----- | ----------------------- |
| 类型: | Date                    |

```
content_type
```

| 描述: | 对象内容的类型 |
| ----- | -------------- |
| 类型: | String         |

## 更新一个容器的 ACLs

当用户创建一个容器的时候，默认情况下用户有读和写这个容器 的权限。要允许其他用户读一个容器的内容或者写如对象到一个 容器，必须专门为该用户启用相关权限。你也可以在 `X-Container-Read` 或者  `X-Container-Write` 设置中指定他们的值为 `*` 。这样可以有效地使所有用户都可以读或写这个容器。设置 `*` 使得容器变为公开。也就是说允许匿名用户从容器中读取或想容器 写入到数据。

### 语法

```
POST /{api version}/{account}/{container} HTTP/1.1
Host: {fqdn}
     X-Auth-Token: {auth-token}
     X-Container-Read: *
     X-Container-Write: {uid1}, {uid2}, {uid3}
```

### 请求头

```
X-Container-Read
```

| 描述:     | 有该容器的读权限的用户的 IDs |
| --------- | ---------------------------- |
| 类型:     | 逗号分隔的用户 ID 字符串值.  |
| 是否必需: | No                           |

```
X-Container-Write
```

| 描述:     | 有该容器的写权限的用户的 IDs |
| --------- | ---------------------------- |
| 类型:     | 逗号分隔的用户 ID 字符串值.  |
| 是否必需: | No                           |

## 添加/更新容器元数据

要向容器添加元数据，需要构建一个 `POST` 请求，带上 API 版本、账户和容器的名字。你必须有对你想 添加或者更新元数据的容器的写权限。

### 语法

```
POST /{api version}/{account}/{container} HTTP/1.1
Host: {fqdn}
     X-Auth-Token: {auth-token}
     X-Container-Meta-Color: red
     X-Container-Meta-Taste: salty
```

### 请求头

```
X-Container-Meta-{key}
```

| 描述:     | 用户定义的元数据的 key,一个任意的字符串值。 |
| --------- | ------------------------------------------- |
| 类型:     | String                                      |
| 是否必需: | No                                          |

## 删除一个容器

要删除一个容器，构建一个使 `DELETE` 请求，带上 API 版本、账户和容器的名称。容器必须是空的。如果你 想检查容器是否为空，对容器执行一个 `HEAD` 请求。一旦你确认成功删除了容器，就可以重用容器的名字。

### 语法

```
DELETE /{api version}/{account}/{container} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### HTTP 响应

```
204
```

| 描述:   | 容器已经被删除 |
| ------- | -------------- |
| 状态码: | `NoContent`    |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - 容器操作
        - 新建一个容器
          - [语法](http://docs.ceph.org.cn/radosgw/swift/containerops/#id3)
          - [头信息](http://docs.ceph.org.cn/radosgw/swift/containerops/#id4)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/swift/containerops/#http)
        - 列出容器内的对象
          - [语法](http://docs.ceph.org.cn/radosgw/swift/containerops/#id6)
          - [参数](http://docs.ceph.org.cn/radosgw/swift/containerops/#id7)
          - [响应实体](http://docs.ceph.org.cn/radosgw/swift/containerops/#id8)
        - 更新一个容器的 ACLs
          - [语法](http://docs.ceph.org.cn/radosgw/swift/containerops/#id9)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/containerops/#id10)
        - 添加/更新容器元数据
          - [语法](http://docs.ceph.org.cn/radosgw/swift/containerops/#id12)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/containerops/#id13)
        - 删除一个容器
          - [语法](http://docs.ceph.org.cn/radosgw/swift/containerops/#id15)
          - [HTTP 响应](http://docs.ceph.org.cn/radosgw/swift/containerops/#id16)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/objectops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/serviceops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/tempurl/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/containerops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# 对象操作

对象是一个用于存储数据和元数据的容器。一个容器可以包 含很多对象，但是对象的名字必须唯一。这个 API 允许客  户端创建对象、设置访问权限及元数据、读取对象的数据和 元数据、以及删除对象。因为此 API 发出的请求是与用户 帐户信息相关的，所以此 API  内的所有请求都必须经过认 证，除非容器或对象的访问控制权限被故意设置成了可公开 访问（即允许匿名请求）。

## 创建或更新对象

要创建新对象，需发送带有 API 版本、帐户、容 器名和新对象名称的 `PUT` 请求。还必须有对 应容器的写权限才能创建或更新对象。容器内的对 象名字必须唯一。`PUT` 请求不会预先检测，所 以你要是没用唯一的名字，此请求就会更新对象。 然而你可以在对象名中用 pseudo-hierarchical 来区分同名、但位于不同 pseudo-hierarchical 目录的对象。你可以在请求头里加上访问控制和元数 据信息。

### 语法

```
PUT /{api version}/{account}/{container}/{object} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### 请求头

```
ETag
```

| 描述:     | 对象内容的 MD5 哈希值，建议设置。 |
| --------- | --------------------------------- |
| 类型:     | 字符串                            |
| 是否必需: | 否                                |

```
Content-Type
```

| 描述:     | 对象所包含内容的类型。 |
| --------- | ---------------------- |
| 类型:     | 字符串                 |
| 是否必需: | 否                     |

```
Transfer-Encoding
```

| 描述:     | 用于标识此对象是否是更大的聚合对象的一部分。 |
| --------- | -------------------------------------------- |
| 类型:     | 字符串                                       |
| 有效取值: | `chunked`                                    |
| 是否必需: | 否                                           |

## 复制对象

对象复制方法允许你在服务器端创建对象副本，这样你就不必先下载、再上传到另一个容器或名 字了。要把一对象的内容复制到另一对象，你可 以发送 `PUT` 请求或 `COPY` 请求，要 携带 API 版本、帐户、和容器名。发送 `PUT` 请求时，请求内容为目标容器和对象名，源容器 和源对象名在请求头里设置；对于 `COPY` 请 求，请求内容为源容器和源对象名，目标容器和 对象在请求头里。要复制对象，你必须有写权限；目标对象名在其容器内也必须唯一。此请求不会  预先检查，所以如果名字不唯一，它就会更新目 标对象。然而你可以在对象名中用 pseudo-hierarchical 语法来区分同名、但位于不同  pseudo-hierarchical 目录的对象。你可以在请求头里加上访问控制和 元数据头。

### 语法

```
PUT /{api version}/{account}/{dest-container}/{dest-object} HTTP/1.1
X-Copy-From: {source-container}/{source-object}
Host: {fqdn}
X-Auth-Token: {auth-token}
```

或者这样：

```
COPY /{api version}/{account}/{source-container}/{source-object} HTTP/1.1
Destination: {dest-container}/{dest-object}
```

### 请求头

```
X-Copy-From
```

| 描述:     | 用于在 `PUT` 请求中定义源容器或对象的路径。 |
| --------- | ------------------------------------------- |
| 类型:     | 字符串                                      |
| 是否必需: | 用 `PUT` 方法时必需                         |

```
Destination
```

| 描述:     | 用于在 `COPY` 请求中定义目标容器或对象的路径。 |
| --------- | ---------------------------------------------- |
| 类型:     | 字符串                                         |
| 是否必需: | 用 `COPY` 方法时必需                           |

```
If-Modified-Since
```

| 描述:     | 如果从源对象的 `last_modified` 属性记录的时间起修改过，那就复制。 |
| --------- | ------------------------------------------------------------ |
| 类型:     | 日期                                                         |
| 是否必需: | 否                                                           |

```
If-Unmodified-Since
```

| 描述:     | 如果从源对象的 `last_modified` 属性记录的时间起没有修改过，那就复制。 |
| --------- | ------------------------------------------------------------ |
| 类型:     | 日期                                                         |
| 是否必需: | 否                                                           |

```
Copy-If-Match
```

| 描述:     | 请求中的 ETag 与源对象的 ETag 属性相同时才复制。 |
| --------- | ------------------------------------------------ |
| 类型:     | ETag.                                            |
| 是否必需: | 否                                               |

```
Copy-If-None-Match
```

| 描述:     | 请求中的 ETag 与源对象的 ETag 属性不同时才复制。 |
| --------- | ------------------------------------------------ |
| 类型:     | ETag.                                            |
| 是否必需: | 否                                               |

## 删除对象

要删除对象，可发送带有 API 版本、帐户、容器和对象名的 `DELETE` 请求。此帐户必须有容器的写权限，才能删除其内的对象。成功删除对象后，你就能重用对象名了。

### 语法

```
DELETE /{api version}/{account}/{container}/{object} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

## 获取一对象

要获取一对象，需发出带有 API 版本、帐户、容器和对象名的 `GET` 请求，而且必须有此容器的读权限，才能读取其内的对象。

### 语法

```
GET /{api version}/{account}/{container}/{object} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### 请求头

```
range
```

| 描述:     | 要获取某一对象内容的一部分，你可以指定字节范围。 |
| --------- | ------------------------------------------------ |
| 类型:     | 日期（译者：应为整数？）                         |
| 是否必需: | 否                                               |

```
If-Modified-Since
```

| 描述:     | 如果从源对象的 `last_modified` 属性记录的时间起修改过，那就下载。 |
| --------- | ------------------------------------------------------------ |
| 类型:     | 日期                                                         |
| 是否必需: | 否                                                           |

```
If-Unmodified-Since
```

| 描述:     | 如果从源对象的 `last_modified` 属性记录的时间起没有修改过，那就下载。 |
| --------- | ------------------------------------------------------------ |
| 类型:     | 日期                                                         |
| 是否必需: | 否                                                           |

```
Copy-If-Match
```

| 描述:     | 请求中的 ETag 与源对象的 ETag 属性相同时才下载。 |
| --------- | ------------------------------------------------ |
| 类型:     | ETag.                                            |
| 是否必需: | 否                                               |

```
Copy-If-None-Match
```

| 描述:     | 请求中的 ETag 与源对象的 ETag 属性不同时才下载。 |
| --------- | ------------------------------------------------ |
| 类型:     | ETag.                                            |
| 是否必需: | No                                               |

### 响应头

```
Content-Range
```

| 描述: | 此区间表示对象内容的子集。只有在请求头中有 range 字段时才会返回此字段。 |
| ----- | ------------------------------------------------------------ |
|       |                                                              |

## 获取对象元数据

要查看一对象的元数据，可发送带有 API 版本、帐户、容器和对象名的 `HEAD` 头。你还必须有此容器的读权限才能其内对象的元数据。此请求会返回和获取对象本身时相同的头信息，只是不返回对象的数据而已。

### 语法

```
HEAD /{api version}/{account}/{container}/{object} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

## 增加或更新对象元数据

要给对象增加元数据需发送 `POST` 请求，要带上 API 版本、帐户、容器和对象名。你还必须有父容器的写权限才能增加或更新元数据。

### 语法

```
POST /{api version}/{account}/{container}/{object} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### 请求头

```
X-Object-Meta-{key}
```

| 描述:     | 一个用户定义的元数据关键字，其值为任意字符串。 |
| --------- | ---------------------------------------------- |
| 类型:     | 字符串                                         |
| 是否必需: | 否                                             |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - 对象操作
        - 创建或更新对象
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id3)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/objectops/#id4)
        - 复制对象
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id6)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/objectops/#id7)
        - 删除对象
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id9)
        - 获取一对象
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id11)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/objectops/#id12)
          - [响应头](http://docs.ceph.org.cn/radosgw/swift/objectops/#id13)
        - 获取对象元数据
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id15)
        - 增加或更新对象元数据
          - [语法](http://docs.ceph.org.cn/radosgw/swift/objectops/#id17)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/objectops/#id18)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/tempurl/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/containerops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/tutorial/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/objectops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# Temp URL 操作

为做到无需共享凭据也能临时允许访问（比如用于 GET 请求）对象， radosgw 末端的 swift 也支持临时 URL 功能。要用此功能，需设置 X-Account-Meta-Temp-URL-Key 或可选项 X-Account-Meta-Temp-URL-Key-2 的初始值。 Temp URL 功能需要这些密钥的 HMAC-SHA1 签名。

## POST Temp-URL 密钥

向 swift 帐户发送一个带有所需 Key 的 `POST` 请求，就能给此帐户设置临时 URL 私钥，这样就可向其他帐户提供临时 URL 访问了。最多支持两个密钥，两个密钥的签名都要检查，如果没问题，密钥就可以继续使用、临时 URL 也不会失效。

### 语法

```
POST /{api version}/{account} HTTP/1.1
Host: {fqdn}
X-Auth-Token: {auth-token}
```

### 请求头

```
X-Account-Meta-Temp-URL-Key
```

| 描述:     | 用户定义的密钥，可以是任意字符串。 |
| --------- | ---------------------------------- |
| 类型:     | String                             |
| 是否必需: | Yes                                |

```
X-Account-Meta-Temp-URL-Key-2
```

| 描述:     | 用户定义的密钥，可以是任意字符串。 |
| --------- | ---------------------------------- |
| 类型:     | String                             |
| 是否必需: | No                                 |

## 获取 Temp-URL 对象

临时 URL 用密码学 HMAC-SHA1 签名，它包含下列要素：

1. 请求方法的值，如 “GET”
2. 过期时间，格式为纪元以来的秒数，即 Unix 时间
3. 从 “v1” 起的请求路径

上述条目将用新行格式化，并用之前上传的临时 URL 密钥通过 SHA-1 哈希算法生成一个 HMAC 。

下面的 Python 脚本演示了上述过程：

```
import hmac
from hashlib import sha1
from time import time

method = 'GET'
host = 'https://objectstore.example.com'
duration_in_seconds = 300  # Duration for which the url is valid
expires = int(time() + duration_in_seconds)
path = '/v1/your-bucket/your-object'
key = 'secret'
hmac_body = '%s\n%s\n%s' % (method, expires, path)
hmac_body = hmac.new(key, hmac_body, sha1).hexdigest()
sig = hmac.new(key, hmac_body, sha1).hexdigest()
rest_uri = "{host}{path}?temp_url_sig={sig}&temp_url_expires={expires}".format(
        host=host, path=path, sig=sig, expires=expires)
print rest_uri

# Example Output
# https://objectstore.example.com/v1/your-bucket/your-object?temp_url_sig=ff4657876227fc6025f04fcf1e82818266d022c6&temp_url_expires=1423200992
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - 临时 URL 操作
        - POST Temp-URL 密钥
          - [语法](http://docs.ceph.org.cn/radosgw/swift/tempurl/#id1)
          - [请求头](http://docs.ceph.org.cn/radosgw/swift/tempurl/#id2)
        - [获取 Temp-URL 对象](http://docs.ceph.org.cn/radosgw/swift/tempurl/#id3)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/tutorial/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/objectops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/java/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/tempurl/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

# Tutorial

The Swift-compatible API tutorials follow a simple container-based object lifecycle. The first step requires you to setup a connection between your client and the RADOS Gateway server. Then, you may follow a natural container and object lifecycle, including adding and retrieving object metadata. See example code for the following languages:

- [Java](http://docs.ceph.org.cn/radosgw/swift/java)
- [Python](http://docs.ceph.org.cn/radosgw/swift/python)
- [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby)

![img](http://docs.ceph.org.cn/_images/ditaa-e7715454848e7aa8a367408543c1e1a17bfb3951.png)

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/java/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/tempurl/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/python/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/tutorial/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »



# Java Swift Examples

## Setup

The following examples may require some or all of the following Java classes to be imported:

```
import java.io.File;
import java.util.List;
import java.util.Map;
import com.rackspacecloud.client.cloudfiles.FilesClient;
import com.rackspacecloud.client.cloudfiles.FilesConstants;
import com.rackspacecloud.client.cloudfiles.FilesContainer;
import com.rackspacecloud.client.cloudfiles.FilesContainerExistsException;
import com.rackspacecloud.client.cloudfiles.FilesObject;
import com.rackspacecloud.client.cloudfiles.FilesObjectMetaData;
```

## Create a Connection

This creates a connection so that you can interact with the server:

```
String username = "USERNAME";
String password = "PASSWORD";
String authUrl  = "https://objects.dreamhost.com/auth";

FilesClient client = new FilesClient(username, password, authUrl);
if (!client.login()) {
        throw new RuntimeException("Failed to log in");
}
```

## Create a Container

This creates a new container called `my-new-container`:

```
client.createContainer("my-new-container");
```

## Create an Object

This creates an object `foo.txt` from the file named `foo.txt` in the container `my-new-container`:

```
File file = new File("foo.txt");
String mimeType = FilesConstants.getMimetype("txt");
client.storeObject("my-new-container", file, mimeType);
```

## Add/Update Object Metadata

This adds the metadata key-value pair `key`:`value` to the object named `foo.txt` in the container `my-new-container`:

```
FilesObjectMetaData metaData = client.getObjectMetaData("my-new-container", "foo.txt");
metaData.addMetaData("key", "value");

Map<String, String> metamap = metaData.getMetaData();
client.updateObjectMetadata("my-new-container", "foo.txt", metamap);
```

## List Owned Containers

This gets a list of Containers that you own. This also prints out the container name.

```
List<FilesContainer> containers = client.listContainers();
for (FilesContainer container : containers) {
        System.out.println("  " + container.getName());
}
```

The output will look something like this:

```
mahbuckat1
mahbuckat2
mahbuckat3
```

## List a Container’s Content

This gets a list of objects in the container `my-new-container`; and, it also prints out each object’s name, the file size, and last modified date:

```
List<FilesObject> objects = client.listObjects("my-new-container");
for (FilesObject object : objects) {
        System.out.println("  " + object.getName());
}
```

The output will look something like this:

```
myphoto1.jpg
myphoto2.jpg
```

## Retrieve an Object’s Metadata

This retrieves metadata and gets the MIME type for an object named `foo.txt` in a container named `my-new-container`:

```
FilesObjectMetaData metaData =  client.getObjectMetaData("my-new-container", "foo.txt");
String mimeType = metaData.getMimeType();
```

## Retrieve an Object

This downloads the object `foo.txt` in the container `my-new-container` and saves it in `./outfile.txt`:

```
FilesObject obj;
File outfile = new File("outfile.txt");

List<FilesObject> objects = client.listObjects("my-new-container");
for (FilesObject object : objects) {
        String name = object.getName();
        if (name.equals("foo.txt")) {
                obj = object;
                obj.writeObjectToFile(outfile);
        }
}
```

## Delete an Object

This deletes the object `goodbye.txt` in the container “my-new-container”:

```
client.deleteObject("my-new-container", "goodbye.txt");
```

## Delete a Container

This deletes a container named “my-new-container”:

```
client.deleteContainer("my-new-container");
```

Note

The container must be empty! Otherwise it won’t work!

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - Java
        - [Setup](http://docs.ceph.org.cn/radosgw/swift/java/#setup)
        - [Create a Connection](http://docs.ceph.org.cn/radosgw/swift/java/#create-a-connection)
        - [Create a Container](http://docs.ceph.org.cn/radosgw/swift/java/#create-a-container)
        - [Create an Object](http://docs.ceph.org.cn/radosgw/swift/java/#create-an-object)
        - [Add/Update Object Metadata](http://docs.ceph.org.cn/radosgw/swift/java/#add-update-object-metadata)
        - [List Owned Containers](http://docs.ceph.org.cn/radosgw/swift/java/#list-owned-containers)
        - [List a Container’s Content](http://docs.ceph.org.cn/radosgw/swift/java/#list-a-container-s-content)
        - [Retrieve an Object’s Metadata](http://docs.ceph.org.cn/radosgw/swift/java/#retrieve-an-object-s-metadata)
        - [Retrieve an Object](http://docs.ceph.org.cn/radosgw/swift/java/#retrieve-an-object)
        - [Delete an Object](http://docs.ceph.org.cn/radosgw/swift/java/#delete-an-object)
        - [Delete a Container](http://docs.ceph.org.cn/radosgw/swift/java/#delete-a-container)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/python/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/tutorial/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/ruby/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/java/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »



# Python Swift 实例

## 新建连接

这里先建立一个连接，这样你就能与服务器交互了：

```
import swiftclient
user = 'account_name:username'
key = 'your_api_key'

conn = swiftclient.Connection(
        user=user,
        key=key,
        authurl='https://objects.dreamhost.com/auth',
)
```

## 创建容器

下面创建一个名为 `my-new-container` 的新容器：

```
container_name = 'my-new-container'
conn.put_container(container_name)
```

## 创建对象

下面从名为 `my_hello.txt` 的本地文件创建一个名为 `hello.txt` 的文件：

```
with open('my_hello.txt', 'r') as hello_file:
        conn.put_object(container_name, 'hello.txt',
                        contents=hello_file.read(),
                        content_type='text/plain')
```

## 罗列自己拥有的容器

下面获取你拥有的容器列表，并打印容器名：

```
for container in conn.get_account()[1]:
        print container['name']
```

其输出大致如此：

```
mahbuckat1
mahbuckat2
mahbuckat3
```

## 罗列一容器的内容

获取容器中对象的列表，并打印各对象的名字、文件尺寸、和最后修改时间：

```
for data in conn.get_container(container_name)[1]:
        print '{0}\t{1}\t{2}'.format(data['name'], data['bytes'], data['last_modified'])
```

其输出大致如此：

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## 检索一个对象

下载对象 `hello.txt` 并保存为 `./my_hello.txt` ：

```
obj_tuple = conn.get_object(container_name, 'hello.txt')
with open('my_hello.txt', 'w') as my_hello:
        my_hello.write(obj_tuple[1])
```

## 删除对象

删除对象 `goodbye.txt` ：

```
conn.delete_object(container_name, 'hello.txt')
```

## 删除一个容器

Note

容器必须是空的！否则请求不会成功！

```
conn.delete_container(container_name)
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - Python
        - [新建连接](http://docs.ceph.org.cn/radosgw/swift/python/#id2)
        - [创建容器](http://docs.ceph.org.cn/radosgw/swift/python/#id3)
        - [创建对象](http://docs.ceph.org.cn/radosgw/swift/python/#id4)
        - [罗列自己拥有的容器](http://docs.ceph.org.cn/radosgw/swift/python/#id5)
        - [罗列一容器的内容](http://docs.ceph.org.cn/radosgw/swift/python/#id6)
        - [检索一个对象](http://docs.ceph.org.cn/radosgw/swift/python/#id7)
        - [删除对象](http://docs.ceph.org.cn/radosgw/swift/python/#id8)
        - [删除一个容器](http://docs.ceph.org.cn/radosgw/swift/python/#id9)
      - [Ruby](http://docs.ceph.org.cn/radosgw/swift/ruby/)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/swift/ruby/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/java/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/adminops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/python/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »



# Ruby Swift Examples[¶](http://docs.ceph.org.cn/radosgw/swift/ruby/#ruby-swift-examples)

## Create a Connection

This creates a connection so that you can interact with the server:

```
require 'cloudfiles'
username = 'account_name:user_name'
api_key  = 'your_secret_key'

conn = CloudFiles::Connection.new(
        :username => username,
        :api_key  => api_key,
        :auth_url => 'http://objects.dreamhost.com/auth'
)
```

## Create a Container

This creates a new container called `my-new-container`

```
container = conn.create_container('my-new-container')
```

## Create an Object

This creates a file `hello.txt` from the file named `my_hello.txt`

```
obj = container.create_object('hello.txt')
obj.load_from_filename('./my_hello.txt')
obj.content_type = 'text/plain'
```

## List Owned Containers

This gets a list of Containers that you own, and also prints out the container name:

```
conn.containers.each do |container|
        puts container
end
```

The output will look something like this:

```
mahbuckat1
mahbuckat2
mahbuckat3
```

## List a Container’s Contents

This gets a list of objects in the container, and prints out each object’s name, the file size, and last modified date:

```
require 'date'  # not necessary in the next version

container.objects_detail.each do |name, data|
        puts "#{name}\t#{data[:bytes]}\t#{data[:last_modified]}"
end
```

The output will look something like this:

```
myphoto1.jpg 251262  2011-08-08T21:35:48.000Z
myphoto2.jpg 262518  2011-08-08T21:38:01.000Z
```

## Retrieve an Object

This downloads the object `hello.txt` and saves it in `./my_hello.txt`:

```
obj = container.object('hello.txt')
obj.save_to_filename('./my_hello.txt')
```

## Delete an Object

This deletes the object `goodbye.txt`:

```
container.delete_object('goodbye.txt')
```

## Delete a Container

Note

The container must be empty! Otherwise the request won’t work!

```
container.delete_container('my-new-container')
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - Swift API
    - API
      - [认证](http://docs.ceph.org.cn/radosgw/swift/auth/)
      - [服务操作](http://docs.ceph.org.cn/radosgw/swift/serviceops/)
      - [容器操作](http://docs.ceph.org.cn/radosgw/swift/containerops/)
      - [对象操作](http://docs.ceph.org.cn/radosgw/swift/objectops/)
      - [临时 URL 操作](http://docs.ceph.org.cn/radosgw/swift/tempurl/)
      - [指导手册](http://docs.ceph.org.cn/radosgw/swift/tutorial/)
      - [Java](http://docs.ceph.org.cn/radosgw/swift/java/)
      - [Python](http://docs.ceph.org.cn/radosgw/swift/python/)
      - Ruby
        - [Create a Connection](http://docs.ceph.org.cn/radosgw/swift/ruby/#create-a-connection)
        - [Create a Container](http://docs.ceph.org.cn/radosgw/swift/ruby/#create-a-container)
        - [Create an Object](http://docs.ceph.org.cn/radosgw/swift/ruby/#create-an-object)
        - [List Owned Containers](http://docs.ceph.org.cn/radosgw/swift/ruby/#list-owned-containers)
        - [List a Container’s Contents](http://docs.ceph.org.cn/radosgw/swift/ruby/#list-a-container-s-contents)
        - [Retrieve an Object](http://docs.ceph.org.cn/radosgw/swift/ruby/#retrieve-an-object)
        - [Delete an Object](http://docs.ceph.org.cn/radosgw/swift/ruby/#delete-an-object)
        - [Delete a Container](http://docs.ceph.org.cn/radosgw/swift/ruby/#delete-a-container)
    - [功能支持](http://docs.ceph.org.cn/radosgw/swift/#id1)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/adminops/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/python/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »
- [Ceph 对象网关 Swift API](http://docs.ceph.org.cn/radosgw/swift/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/keystone/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/ruby/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 管理操作

An admin API request will be done on a URI that starts with the configurable ‘admin’ resource entry point. Authorization for the admin API duplicates the S3 authorization mechanism. Some operations require that the user holds special administrative capabilities. The response entity type (XML or JSON) may be specified as the ‘format’ option in the request and defaults to JSON if not specified.

## Get Usage

请求带宽利用率信息。

| caps: | usage=read |
| ----- | ---------- |
|       |            |

### 语法

```
GET /{admin}/usage?format=json HTTP/1.1
Host: {fqdn}
```

### 请求参数

```
uid
```

| Description: | The user for which the information is requested. If not specified will apply to all users. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `foo_user`                                                   |
| Required:    | No                                                           |

```
start
```

| Description: | Date and (optional) time that specifies the start time of the requested data. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `2012-09-25 16:00:00`                                        |
| Required:    | No                                                           |

```
end
```

| Description: | Date and (optional) time that specifies the end time of the requested data (non-inclusive). |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `2012-09-25 16:00:00`                                        |
| Required:    | No                                                           |

```
show-entries
```

| Description: | Specifies whether data entries should be returned. |
| ------------ | -------------------------------------------------- |
| Type:        | Boolean                                            |
| Example:     | True [False]                                       |
| Required:    | No                                                 |

```
show-summary
```

| Description: | Specifies whether data summary should be returned. |
| ------------ | -------------------------------------------------- |
| Type:        | Boolean                                            |
| Example:     | True [False]                                       |
| Required:    | No                                                 |

### Response Entities

If successful, the response contains the requested information.

```
usage
```

| Description: | A container for the usage information. |
| ------------ | -------------------------------------- |
| Type:        | Container                              |

```
entries
```

| Description: | A container for the usage entries information. |
| ------------ | ---------------------------------------------- |
| Type:        | Container                                      |

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
owner
```

| Description: | The name of the user that owns the buckets. |
| ------------ | ------------------------------------------- |
| Type:        | String                                      |

```
bucket
```

| Description: | The bucket name. |
| ------------ | ---------------- |
| Type:        | String           |

```
time
```

| Description: | Time lower bound for which data is being specified (rounded to the beginning of the first relevant hour). |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |

```
epoch
```

| Description: | The time specified in seconds since 1/1/1970. |
| ------------ | --------------------------------------------- |
| Type:        | String                                        |

```
categories
```

| Description: | A container for stats categories. |
| ------------ | --------------------------------- |
| Type:        | Container                         |

```
entry
```

| Description: | A container for stats entry. |
| ------------ | ---------------------------- |
| Type:        | Container                    |

```
category
```

| Description: | Name of request category for which the stats are provided. |
| ------------ | ---------------------------------------------------------- |
| Type:        | String                                                     |

```
bytes_sent
```

| Description: | Number of bytes sent by the RADOS Gateway. |
| ------------ | ------------------------------------------ |
| Type:        | Integer                                    |

```
bytes_received
```

| Description: | Number of bytes received by the RADOS Gateway. |
| ------------ | ---------------------------------------------- |
| Type:        | Integer                                        |

```
ops
```

| Description: | Number of operations. |
| ------------ | --------------------- |
| Type:        | Integer               |

```
successful_ops
```

| Description: | Number of successful operations. |
| ------------ | -------------------------------- |
| Type:        | Integer                          |

```
summary
```

| Description: | A container for stats summary. |
| ------------ | ------------------------------ |
| Type:        | Container                      |

```
total
```

| Description: | A container for stats summary aggregated total. |
| ------------ | ----------------------------------------------- |
| Type:        | Container                                       |

### Special Error Responses

TBD.

## Trim Usage

Remove usage information. With no dates specified, removes all usage information.

| caps: | usage=write |
| ----- | ----------- |
|       |             |

### Syntax

```
DELETE /{admin}/usage?format=json HTTP/1.1
Host: {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user for which the information is requested. If not specified will apply to all users. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `foo_user`                                                   |
| Required:    | No                                                           |

```
start
```

| Description: | Date and (optional) time that specifies the start time of the requested data. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `2012-09-25 16:00:00`                                        |
| Required:    | No                                                           |

```
end
```

| Description: | Date and (optional) time that specifies the end time of the requested data (none inclusive). |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `2012-09-25 16:00:00`                                        |
| Required:    | No                                                           |

```
remove-all
```

| Description: | Required when uid is not specified, in order to acknowledge multi user data removal. |
| ------------ | ------------------------------------------------------------ |
| Type:        | Boolean                                                      |
| Example:     | True [False]                                                 |
| Required:    | No                                                           |

### Special Error Responses

TBD.

## Get User Info

Get user information. If no user is specified returns the list of all users along with suspension information.

| caps: | users=read |
| ----- | ---------- |
|       |            |

### Syntax

```
GET /{admin}/user?format=json HTTP/1.1
Host: {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user for which the information is requested. |
| ------------ | ------------------------------------------------ |
| Type:        | String                                           |
| Example:     | `foo_user`                                       |
| Required:    | No                                               |

### Response Entities

If successful, the response contains the user information.

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
user_id
```

| Description: | The user id. |
| ------------ | ------------ |
| Type:        | String       |
| Parent:      | `user`       |

```
display_name
```

| Description: | Display name for the user. |
| ------------ | -------------------------- |
| Type:        | String                     |
| Parent:      | `user`                     |

```
suspended
```

| Description: | True if the user is suspended. |
| ------------ | ------------------------------ |
| Type:        | Boolean                        |
| Parent:      | `user`                         |

```
max_buckets
```

| Description: | The maximum number of buckets to be owned by the user. |
| ------------ | ------------------------------------------------------ |
| Type:        | Integer                                                |
| Parent:      | `user`                                                 |

```
subusers
```

| Description: | Subusers associated with this user account. |
| ------------ | ------------------------------------------- |
| Type:        | Container                                   |
| Parent:      | `user`                                      |

```
keys
```

| Description: | S3 keys associated with this user account. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |
| Parent:      | `user`                                     |

```
swift_keys
```

| Description: | Swift keys associated with this user account. |
| ------------ | --------------------------------------------- |
| Type:        | Container                                     |
| Parent:      | `user`                                        |

```
caps
```

| Description: | User capabilities. |
| ------------ | ------------------ |
| Type:        | Container          |
| Parent:      | `user`             |

### Special Error Responses

None.

## Create User

Create a new user. By Default, a S3 key pair will be created automatically and returned in the response. If only one of `access-key` or `secret-key` is provided, the omitted key will be automatically generated. By default, a generated key is added to the keyring without replacing an existing key pair. If `access-key` is specified and refers to an existing key owned by the user then it will be modified.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
PUT /{admin}/user?format=json HTTP/1.1
Host: {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to be created. |
| ------------ | -------------------------- |
| Type:        | String                     |
| Example:     | `foo_user`                 |
| Required:    | Yes                        |

```
display-name
```

| Description: | The display name of the user to be created. |
| ------------ | ------------------------------------------- |
| Type:        | String                                      |
| Example:     | `foo user`                                  |
| Required:    | Yes                                         |

```
email
```

| Description: | The email address associated with the user. |
| ------------ | ------------------------------------------- |
| Type:        | String                                      |
| Example:     | `foo@bar.com`                               |
| Required:    | No                                          |

```
key-type
```

| Description: | Key type to be generated, options are: swift, s3 (default). |
| ------------ | ----------------------------------------------------------- |
| Type:        | String                                                      |
| Example:     | `s3` [`s3`]                                                 |
| Required:    | No                                                          |

```
access-key
```

| Description: | Specify access key.    |
| ------------ | ---------------------- |
| Type:        | String                 |
| Example:     | `ABCD0EF12GHIJ2K34LMN` |
| Required:    | No                     |

```
secret-key
```

| Description: | Specify secret key.                        |
| ------------ | ------------------------------------------ |
| Type:        | String                                     |
| Example:     | `0AbCDEFg1h2i34JklM5nop6QrSTUV+WxyzaBC7D8` |
| Required:    | No                                         |

```
user-caps
```

| Description: | User capabilities.              |
| ------------ | ------------------------------- |
| Type:        | String                          |
| Example:     | `usage=read, write; users=read` |
| Required:    | No                              |

```
generate-key
```

| Description: | Generate a new key pair and add to the existing keyring. |
| ------------ | -------------------------------------------------------- |
| Type:        | Boolean                                                  |
| Example:     | True [True]                                              |
| Required:    | No                                                       |

```
max-buckets
```

| Description: | Specify the maximum number of buckets the user can own. |
| ------------ | ------------------------------------------------------- |
| Type:        | Integer                                                 |
| Example:     | 500 [1000]                                              |
| Required:    | No                                                      |

```
suspended
```

| Description: | Specify whether the user should be suspended. |
| ------------ | --------------------------------------------- |
| Type:        | Boolean                                       |
| Example:     | False [False]                                 |
| Required:    | No                                            |

### Response Entities

If successful, the response contains the user information.

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
user_id
```

| Description: | The user id. |
| ------------ | ------------ |
| Type:        | String       |
| Parent:      | `user`       |

```
display_name
```

| Description: | Display name for the user. |
| ------------ | -------------------------- |
| Type:        | String                     |
| Parent:      | `user`                     |

```
suspended
```

| Description: | True if the user is suspended. |
| ------------ | ------------------------------ |
| Type:        | Boolean                        |
| Parent:      | `user`                         |

```
max_buckets
```

| Description: | The maximum number of buckets to be owned by the user. |
| ------------ | ------------------------------------------------------ |
| Type:        | Integer                                                |
| Parent:      | `user`                                                 |

```
subusers
```

| Description: | Subusers associated with this user account. |
| ------------ | ------------------------------------------- |
| Type:        | Container                                   |
| Parent:      | `user`                                      |

```
keys
```

| Description: | S3 keys associated with this user account. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |
| Parent:      | `user`                                     |

```
swift_keys
```

| Description: | Swift keys associated with this user account. |
| ------------ | --------------------------------------------- |
| Type:        | Container                                     |
| Parent:      | `user`                                        |

```
caps
```

| Description: | User capabilities. |
| ------------ | ------------------ |
| Type:        | Container          |
| Parent:      | `user`             |

### Special Error Responses

```
UserExists
```

| Description: | Attempt to create existing user. |
| ------------ | -------------------------------- |
| Code:        | 409 Conflict                     |

```
InvalidAccessKey
```

| Description: | Invalid access key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
InvalidSecretKey
```

| Description: | Invalid secret key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
KeyExists
```

| Description: | Provided access key exists and belongs to another user. |
| ------------ | ------------------------------------------------------- |
| Code:        | 409 Conflict                                            |

```
EmailExists
```

| Description: | Provided email address exists. |
| ------------ | ------------------------------ |
| Code:        | 409 Conflict                   |

```
InvalidCap
```

| Description: | Attempt to grant invalid admin capability. |
| ------------ | ------------------------------------------ |
| Code:        | 400 Bad Request                            |

## Modify User

Modify a user.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
POST /{admin}/user?format=json HTTP/1.1
Host: {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to be modified. |
| ------------ | --------------------------- |
| Type:        | String                      |
| Example:     | `foo_user`                  |
| Required:    | Yes                         |

```
display-name
```

| Description: | The display name of the user to be modified. |
| ------------ | -------------------------------------------- |
| Type:        | String                                       |
| Example:     | `foo user`                                   |
| Required:    | No                                           |

```
email
```

| Description: | The email address to be associated with the user. |
| ------------ | ------------------------------------------------- |
| Type:        | String                                            |
| Example:     | `foo@bar.com`                                     |
| Required:    | No                                                |

```
generate-key
```

| Description: | Generate a new key pair and add to the existing keyring. |
| ------------ | -------------------------------------------------------- |
| Type:        | Boolean                                                  |
| Example:     | True [False]                                             |
| Required:    | No                                                       |

```
access-key
```

| Description: | Specify access key.    |
| ------------ | ---------------------- |
| Type:        | String                 |
| Example:     | `ABCD0EF12GHIJ2K34LMN` |
| Required:    | No                     |

```
secret-key
```

| Description: | Specify secret key.                        |
| ------------ | ------------------------------------------ |
| Type:        | String                                     |
| Example:     | `0AbCDEFg1h2i34JklM5nop6QrSTUV+WxyzaBC7D8` |
| Required:    | No                                         |

```
key-type
```

| Description: | Key type to be generated, options are: swift, s3 (default). |
| ------------ | ----------------------------------------------------------- |
| Type:        | String                                                      |
| Example:     | `s3`                                                        |
| Required:    | No                                                          |

```
user-caps
```

| Description: | User capabilities.              |
| ------------ | ------------------------------- |
| Type:        | String                          |
| Example:     | `usage=read, write; users=read` |
| Required:    | No                              |

```
max-buckets
```

| Description: | Specify the maximum number of buckets the user can own. |
| ------------ | ------------------------------------------------------- |
| Type:        | Integer                                                 |
| Example:     | 500 [1000]                                              |
| Required:    | No                                                      |

```
suspended
```

| Description: | Specify whether the user should be suspended. |
| ------------ | --------------------------------------------- |
| Type:        | Boolean                                       |
| Example:     | False [False]                                 |
| Required:    | No                                            |

### Response Entities

If successful, the response contains the user information.

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
user_id
```

| Description: | The user id. |
| ------------ | ------------ |
| Type:        | String       |
| Parent:      | `user`       |

```
display_name
```

| Description: | Display name for the user. |
| ------------ | -------------------------- |
| Type:        | String                     |
| Parent:      | `user`                     |

```
suspended
```

| Description: | True if the user is suspended. |
| ------------ | ------------------------------ |
| Type:        | Boolean                        |
| Parent:      | `user`                         |

```
max_buckets
```

| Description: | The maximum number of buckets to be owned by the user. |
| ------------ | ------------------------------------------------------ |
| Type:        | Integer                                                |
| Parent:      | `user`                                                 |

```
subusers
```

| Description: | Subusers associated with this user account. |
| ------------ | ------------------------------------------- |
| Type:        | Container                                   |
| Parent:      | `user`                                      |

```
keys
```

| Description: | S3 keys associated with this user account. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |
| Parent:      | `user`                                     |

```
swift_keys
```

| Description: | Swift keys associated with this user account. |
| ------------ | --------------------------------------------- |
| Type:        | Container                                     |
| Parent:      | `user`                                        |

```
caps
```

| Description: | User capabilities. |
| ------------ | ------------------ |
| Type:        | Container          |
| Parent:      | `user`             |

### Special Error Responses

```
InvalidAccessKey
```

| Description: | Invalid access key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
InvalidSecretKey
```

| Description: | Invalid secret key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
KeyExists
```

| Description: | Provided access key exists and belongs to another user. |
| ------------ | ------------------------------------------------------- |
| Code:        | 409 Conflict                                            |

```
EmailExists
```

| Description: | Provided email address exists. |
| ------------ | ------------------------------ |
| Code:        | 409 Conflict                   |

```
InvalidCap
```

| Description: | Attempt to grant invalid admin capability. |
| ------------ | ------------------------------------------ |
| Code:        | 400 Bad Request                            |

## Remove User

Remove an existing user.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
DELETE /{admin}/user?format=json HTTP/1.1
Host: {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to be removed. |
| ------------ | -------------------------- |
| Type:        | String                     |
| Example:     | `foo_user`                 |
| Required:    | Yes.                       |

```
purge-data
```

| Description: | When specified the buckets and objects belonging to the user will also be removed. |
| ------------ | ------------------------------------------------------------ |
| Type:        | Boolean                                                      |
| Example:     | True                                                         |
| Required:    | No                                                           |

### Response Entities

None

### Special Error Responses

None.

## Create Subuser

Create a new subuser (primarily useful for clients using the Swift API). Note that either `gen-subuser` or `subuser` is required for a valid request. Note that in general for a subuser to be useful, it must be granted permissions by specifying `access`. As with user creation if `subuser` is specified without `secret`, then a secret key will be automatically generated.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
PUT /{admin}/user?subuser&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID under which a subuser is to  be created. |
| ------------ | ---------------------------------------------------- |
| Type:        | String                                               |
| Example:     | `foo_user`                                           |
| Required:    | Yes                                                  |

```
subuser
```

| Description: | Specify the subuser ID to be created. |
| ------------ | ------------------------------------- |
| Type:        | String                                |
| Example:     | `sub_foo`                             |
| Required:    | No                                    |

```
secret-key
```

| Description: | Specify secret key.                        |
| ------------ | ------------------------------------------ |
| Type:        | String                                     |
| Example:     | `0AbCDEFg1h2i34JklM5nop6QrSTUV+WxyzaBC7D8` |
| Required:    | No                                         |

```
key-type
```

| Description: | Key type to be generated, options are: swift (default), s3. |
| ------------ | ----------------------------------------------------------- |
| Type:        | String                                                      |
| Example:     | `swift` [`swift`]                                           |
| Required:    | No                                                          |

```
access
```

| Description: | Set access permissions for sub-user, should be one of `read, write, readwrite, full`. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `read`                                                       |
| Required:    | No                                                           |

```
generate-secret
```

| Description: | Generate the secret key. |
| ------------ | ------------------------ |
| Type:        | Boolean                  |
| Example:     | True [False]             |
| Required:    | No                       |

### Response Entities

If successful, the response contains the subuser information.

```
subusers
```

| Description: | Subusers associated with the user account. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
id
```

| Description: | Subuser id. |
| ------------ | ----------- |
| Type:        | String      |
| Parent:      | `subusers`  |

```
permissions
```

| Description: | Subuser access to user account. |
| ------------ | ------------------------------- |
| Type:        | String                          |
| Parent:      | `subusers`                      |

### Special Error Responses

```
SubuserExists
```

| Description: | Specified subuser exists. |
| ------------ | ------------------------- |
| Code:        | 409 Conflict              |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
InvalidSecretKey
```

| Description: | Invalid secret key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidAccess
```

| Description: | Invalid subuser access specified. |
| ------------ | --------------------------------- |
| Code:        | 400 Bad Request                   |

## Modify Subuser

Modify an existing subuser

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
POST /{admin}/user?subuser&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID under which the subuser is to be modified. |
| ------------ | ------------------------------------------------------ |
| Type:        | String                                                 |
| Example:     | `foo_user`                                             |
| Required:    | Yes                                                    |

```
subuser
```

| Description: | The subuser ID to be modified. |
| ------------ | ------------------------------ |
| Type:        | String                         |
| Example:     | `sub_foo`                      |
| Required:    | Yes                            |

```
generate-secret
```

| Description: | Generate a new secret key for the subuser, replacing the existing key. |
| ------------ | ------------------------------------------------------------ |
| Type:        | Boolean                                                      |
| Example:     | True [False]                                                 |
| Required:    | No                                                           |

```
secret
```

| Description: | Specify secret key.                        |
| ------------ | ------------------------------------------ |
| Type:        | String                                     |
| Example:     | `0AbCDEFg1h2i34JklM5nop6QrSTUV+WxyzaBC7D8` |
| Required:    | No                                         |

```
key-type
```

| Description: | Key type to be generated, options are: swift (default), s3 . |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `swift` [`swift`]                                            |
| Required:    | No                                                           |

```
access
```

| Description: | Set access permissions for sub-user, should be one of `read, write, readwrite, full`. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `read`                                                       |
| Required:    | No                                                           |

### Response Entities

If successful, the response contains the subuser information.

```
subusers
```

| Description: | Subusers associated with the user account. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |

```
id
```

| Description: | Subuser id. |
| ------------ | ----------- |
| Type:        | String      |
| Parent:      | `subusers`  |

```
permissions
```

| Description: | Subuser access to user account. |
| ------------ | ------------------------------- |
| Type:        | String                          |
| Parent:      | `subusers`                      |

### Special Error Responses

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
InvalidSecretKey
```

| Description: | Invalid secret key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidAccess
```

| Description: | Invalid subuser access specified. |
| ------------ | --------------------------------- |
| Code:        | 400 Bad Request                   |

## Remove Subuser

Remove an existing subuser

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
DELETE /{admin}/user?subuser&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID under which the subuser is to be removed. |
| ------------ | ----------------------------------------------------- |
| Type:        | String                                                |
| Example:     | `foo_user`                                            |
| Required:    | Yes                                                   |

```
subuser
```

| Description: | The subuser ID to be removed. |
| ------------ | ----------------------------- |
| Type:        | String                        |
| Example:     | `sub_foo`                     |
| Required:    | Yes                           |

```
purge-keys
```

| Description: | Remove keys belonging to the subuser. |
| ------------ | ------------------------------------- |
| Type:        | Boolean                               |
| Example:     | True [True]                           |
| Required:    | No                                    |

### Response Entities

None.

### Special Error Responses

None.

## Create Key

Create a new key. If a `subuser` is specified then by default created keys will be swift type. If only one of `access-key` or `secret-key` is provided the committed key will be automatically generated, that is if only `secret-key` is specified then `access-key` will be automatically generated. By default, a generated key is added to the keyring without replacing an existing key pair. If `access-key` is specified and refers to an existing key owned by the user then it will be modified. The response is a container listing all keys of the same type as the key created. Note that when creating a swift key, specifying the option `access-key` will have no effect. Additionally, only one swift key may be held by each user or subuser.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
PUT /{admin}/user?key&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to receive the new key. |
| ------------ | ----------------------------------- |
| Type:        | String                              |
| Example:     | `foo_user`                          |
| Required:    | Yes                                 |

```
subuser
```

| Description: | The subuser ID to receive the new key. |
| ------------ | -------------------------------------- |
| Type:        | String                                 |
| Example:     | `sub_foo`                              |
| Required:    | No                                     |

```
key-type
```

| Description: | Key type to be generated, options are: swift, s3 (default). |
| ------------ | ----------------------------------------------------------- |
| Type:        | String                                                      |
| Example:     | `s3` [`s3`]                                                 |
| Required:    | No                                                          |

```
access-key
```

| Description: | Specify the access key. |
| ------------ | ----------------------- |
| Type:        | String                  |
| Example:     | `AB01C2D3EF45G6H7IJ8K`  |
| Required:    | No                      |

```
secret-key
```

| Description: | Specify the secret key.                    |
| ------------ | ------------------------------------------ |
| Type:        | String                                     |
| Example:     | `0ab/CdeFGhij1klmnopqRSTUv1WxyZabcDEFgHij` |
| Required:    | No                                         |

```
generate-key
```

| Description: | Generate a new key pair and add to the existing keyring. |
| ------------ | -------------------------------------------------------- |
| Type:        | Boolean                                                  |
| Example:     | True [`True`]                                            |
| Required:    | No                                                       |

### Response Entities

```
keys
```

| Description: | Keys of type created associated with this user account. |
| ------------ | ------------------------------------------------------- |
| Type:        | Container                                               |

```
user
```

| Description: | The user account associated with the key. |
| ------------ | ----------------------------------------- |
| Type:        | String                                    |
| Parent:      | `keys`                                    |

```
access-key
```

| Description: | The access key. |
| ------------ | --------------- |
| Type:        | String          |
| Parent:      | `keys`          |

```
secret-key
```

| Description: | The secret key |
| ------------ | -------------- |
| Type:        | String         |
| Parent:      | `keys`         |

### Special Error Responses

```
InvalidAccessKey
```

| Description: | Invalid access key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
InvalidSecretKey
```

| Description: | Invalid secret key specified. |
| ------------ | ----------------------------- |
| Code:        | 400 Bad Request               |

```
InvalidKeyType
```

| Description: | Invalid key type specified. |
| ------------ | --------------------------- |
| Code:        | 400 Bad Request             |

```
KeyExists
```

| Description: | Provided access key exists and belongs to another user. |
| ------------ | ------------------------------------------------------- |
| Code:        | 409 Conflict                                            |

## Remove Key

Remove an existing key.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
DELETE /{admin}/user?key&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
access-key
```

| Description: | The S3 access key belonging to the S3 key pair to remove. |
| ------------ | --------------------------------------------------------- |
| Type:        | String                                                    |
| Example:     | `AB01C2D3EF45G6H7IJ8K`                                    |
| Required:    | Yes                                                       |

```
uid
```

| Description: | The user to remove the key from. |
| ------------ | -------------------------------- |
| Type:        | String                           |
| Example:     | `foo_user`                       |
| Required:    | No                               |

```
subuser
```

| Description: | The subuser to remove the key from. |
| ------------ | ----------------------------------- |
| Type:        | String                              |
| Example:     | `sub_foo`                           |
| Required:    | No                                  |

```
key-type
```

| Description: | Key type to be removed, options are: swift, s3. NOTE: Required to remove swift key. |
| ------------ | ------------------------------------------------------------ |
| Type:        | String                                                       |
| Example:     | `swift`                                                      |
| Required:    | No                                                           |

### Special Error Responses

None.

### Response Entities

None.

## Get Bucket Info

Get information about a subset of the existing buckets. If `uid` is specified without `bucket` then all buckets beloning to the user will be returned. If `bucket` alone is specified, information for that particular bucket will be retrieved.

| caps: | buckets=read |
| ----- | ------------ |
|       |              |

### Syntax

```
GET /{admin}/bucket?format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to return info on. |
| ------------ | ----------------------------- |
| Type:        | String                        |
| Example:     | `foo_bucket`                  |
| Required:    | No                            |

```
uid
```

| Description: | The user to retrieve bucket information for. |
| ------------ | -------------------------------------------- |
| Type:        | String                                       |
| Example:     | `foo_user`                                   |
| Required:    | No                                           |

```
stats
```

| Description: | Return bucket statistics. |
| ------------ | ------------------------- |
| Type:        | Boolean                   |
| Example:     | True [False]              |
| Required:    | No                        |

### Response Entities

If successful the request returns a buckets container containing the desired bucket information.

```
stats
```

| Description: | Per bucket information. |
| ------------ | ----------------------- |
| Type:        | Container               |

```
buckets
```

| Description: | Contains a list of one or more bucket containers. |
| ------------ | ------------------------------------------------- |
| Type:        | Container                                         |

```
bucket
```

| Description: | Container for single bucket information. |
| ------------ | ---------------------------------------- |
| Type:        | Container                                |
| Parent:      | `buckets`                                |

```
name
```

| Description: | The name of the bucket. |
| ------------ | ----------------------- |
| Type:        | String                  |
| Parent:      | `bucket`                |

```
pool
```

| Description: | The pool the bucket is stored in. |
| ------------ | --------------------------------- |
| Type:        | String                            |
| Parent:      | `bucket`                          |

```
id
```

| Description: | The unique bucket id. |
| ------------ | --------------------- |
| Type:        | String                |
| Parent:      | `bucket`              |

```
marker
```

| Description: | Internal bucket tag. |
| ------------ | -------------------- |
| Type:        | String               |
| Parent:      | `bucket`             |

```
owner
```

| Description: | The user id of the bucket owner. |
| ------------ | -------------------------------- |
| Type:        | String                           |
| Parent:      | `bucket`                         |

```
usage
```

| Description: | Storage usage information. |
| ------------ | -------------------------- |
| Type:        | Container                  |
| Parent:      | `bucket`                   |

```
index
```

| Description: | Status of bucket index. |
| ------------ | ----------------------- |
| Type:        | String                  |
| Parent:      | `bucket`                |

### Special Error Responses

```
IndexRepairFailed
```

| Description: | Bucket index repair failed. |
| ------------ | --------------------------- |
| Code:        | 409 Conflict                |

## Check Bucket Index

Check the index of an existing bucket. NOTE: to check multipart object accounting with `check-objects`, `fix` must be set to True.

| caps: | buckets=write |
| ----- | ------------- |
|       |               |

### Syntax

```
GET /{admin}/bucket?index&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to return info on. |
| ------------ | ----------------------------- |
| Type:        | String                        |
| Example:     | `foo_bucket`                  |
| Required:    | Yes                           |

```
check-objects
```

| Description: | Check multipart object accounting. |
| ------------ | ---------------------------------- |
| Type:        | Boolean                            |
| Example:     | True [False]                       |
| Required:    | No                                 |

```
fix
```

| Description: | Also fix the bucket index when checking. |
| ------------ | ---------------------------------------- |
| Type:        | Boolean                                  |
| Example:     | False [False]                            |
| Required:    | No                                       |

### Response Entities

```
index
```

| Description: | Status of bucket index. |
| ------------ | ----------------------- |
| Type:        | String                  |

### Special Error Responses

```
IndexRepairFailed
```

| Description: | Bucket index repair failed. |
| ------------ | --------------------------- |
| Code:        | 409 Conflict                |

## Remove Bucket

Delete an existing bucket.

| caps: | buckets=write |
| ----- | ------------- |
|       |               |

### Syntax

```
DELETE /{admin}/bucket?format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to remove. |
| ------------ | --------------------- |
| Type:        | String                |
| Example:     | `foo_bucket`          |
| Required:    | Yes                   |

```
purge-objects
```

| Description: | Remove a buckets objects before deletion. |
| ------------ | ----------------------------------------- |
| Type:        | Boolean                                   |
| Example:     | True [False]                              |
| Required:    | No                                        |

### Response Entities

None.

### Special Error Responses

```
BucketNotEmpty
```

| Description: | Attempted to delete non-empty bucket. |
| ------------ | ------------------------------------- |
| Code:        | 409 Conflict                          |

```
ObjectRemovalFailed
```

| Description: | Unable to remove objects. |
| ------------ | ------------------------- |
| Code:        | 409 Conflict              |

## Unlink Bucket

Unlink a bucket from a specified user. Primarily useful for changing bucket ownership.

| caps: | buckets=write |
| ----- | ------------- |
|       |               |

### Syntax

```
POST /{admin}/bucket?format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to unlink. |
| ------------ | --------------------- |
| Type:        | String                |
| Example:     | `foo_bucket`          |
| Required:    | Yes                   |

```
uid
```

| Description: | The user ID to unlink the bucket from. |
| ------------ | -------------------------------------- |
| Type:        | String                                 |
| Example:     | `foo_user`                             |
| Required:    | Yes                                    |

### Response Entities

None.

### Special Error Responses

```
BucketUnlinkFailed
```

| Description: | Unable to unlink bucket from specified user. |
| ------------ | -------------------------------------------- |
| Code:        | 409 Conflict                                 |

## Link Bucket

Link a bucket to a specified user, unlinking the bucket from any previous user.

| caps: | buckets=write |
| ----- | ------------- |
|       |               |

### Syntax

```
PUT /{admin}/bucket?format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to unlink. |
| ------------ | --------------------- |
| Type:        | String                |
| Example:     | `foo_bucket`          |
| Required:    | Yes                   |

```
uid
```

| Description: | The user ID to link the bucket to. |
| ------------ | ---------------------------------- |
| Type:        | String                             |
| Example:     | `foo_user`                         |
| Required:    | Yes                                |

### Response Entities

```
bucket
```

| Description: | Container for single bucket information. |
| ------------ | ---------------------------------------- |
| Type:        | Container                                |

```
name
```

| Description: | The name of the bucket. |
| ------------ | ----------------------- |
| Type:        | String                  |
| Parent:      | `bucket`                |

```
pool
```

| Description: | The pool the bucket is stored in. |
| ------------ | --------------------------------- |
| Type:        | String                            |
| Parent:      | `bucket`                          |

```
id
```

| Description: | The unique bucket id. |
| ------------ | --------------------- |
| Type:        | String                |
| Parent:      | `bucket`              |

```
marker
```

| Description: | Internal bucket tag. |
| ------------ | -------------------- |
| Type:        | String               |
| Parent:      | `bucket`             |

```
owner
```

| Description: | The user id of the bucket owner. |
| ------------ | -------------------------------- |
| Type:        | String                           |
| Parent:      | `bucket`                         |

```
usage
```

| Description: | Storage usage information. |
| ------------ | -------------------------- |
| Type:        | Container                  |
| Parent:      | `bucket`                   |

```
index
```

| Description: | Status of bucket index. |
| ------------ | ----------------------- |
| Type:        | String                  |
| Parent:      | `bucket`                |

### Special Error Responses

```
BucketUnlinkFailed
```

| Description: | Unable to unlink bucket from specified user. |
| ------------ | -------------------------------------------- |
| Code:        | 409 Conflict                                 |

```
BucketLinkFailed
```

| Description: | Unable to link bucket to specified user. |
| ------------ | ---------------------------------------- |
| Code:        | 409 Conflict                             |

## Remove Object

Remove an existing object. NOTE: Does not require owner to be non-suspended.

| caps: | buckets=write |
| ----- | ------------- |
|       |               |

### Syntax

```
DELETE /{admin}/bucket?object&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket containing the object to be removed. |
| ------------ | ----------------------------------------------- |
| Type:        | String                                          |
| Example:     | `foo_bucket`                                    |
| Required:    | Yes                                             |

```
object
```

| Description: | The object to remove. |
| ------------ | --------------------- |
| Type:        | String                |
| Example:     | `foo.txt`             |
| Required:    | Yes                   |

### Response Entities

None.

### Special Error Responses

```
NoSuchObject
```

| Description: | Specified object does not exist. |
| ------------ | -------------------------------- |
| Code:        | 404 Not Found                    |

```
ObjectRemovalFailed
```

| Description: | Unable to remove objects. |
| ------------ | ------------------------- |
| Code:        | 409 Conflict              |

## Get Bucket or Object Policy

Read the policy of an object or bucket.

| caps: | buckets=read |
| ----- | ------------ |
|       |              |

### Syntax

```
GET /{admin}/bucket?policy&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
bucket
```

| Description: | The bucket to read the policy from. |
| ------------ | ----------------------------------- |
| Type:        | String                              |
| Example:     | `foo_bucket`                        |
| Required:    | Yes                                 |

```
object
```

| Description: | The object to read the policy from. |
| ------------ | ----------------------------------- |
| Type:        | String                              |
| Example:     | `foo.txt`                           |
| Required:    | No                                  |

### Response Entities

If successful, returns the object or bucket policy

```
policy
```

| Description: | Access control policy. |
| ------------ | ---------------------- |
| Type:        | Container              |

### Special Error Responses

```
IncompleteBody
```

| Description: | Either bucket was not specified for a bucket policy request or bucket and object were not specified for an object policy request. |
| ------------ | ------------------------------------------------------------ |
| Code:        | 400 Bad Request                                              |

## Add A User Capability

Add an administrative capability to a specified user.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
PUT /{admin}/user?caps&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to add an administrative capability to. |
| ------------ | --------------------------------------------------- |
| Type:        | String                                              |
| Example:     | `foo_user`                                          |
| Required:    | Yes                                                 |

```
user-caps
```

| Description: | The administrative capability to add to the user. |
| ------------ | ------------------------------------------------- |
| Type:        | String                                            |
| Example:     | `usage=read, write`                               |
| Required:    | Yes                                               |

### Response Entities

If successful, the response contains the user’s capabilities.

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |
| Parent:      | `user`                                     |

```
user_id
```

| Description: | The user id. |
| ------------ | ------------ |
| Type:        | String       |
| Parent:      | `user`       |

```
caps
```

| Description: | User capabilities. |
| ------------ | ------------------ |
| Type:        | Container          |
| Parent:      | `user`             |

### Special Error Responses

```
InvalidCap
```

| Description: | Attempt to grant invalid admin capability. |
| ------------ | ------------------------------------------ |
| Code:        | 400 Bad Request                            |

### Example Request

```
PUT /{admin}/user?caps&format=json HTTP/1.1
Host: {fqdn}
Content-Type: text/plain
Authorization: {your-authorization-token}

usage=read
```

## Remove A User Capability

Remove an administrative capability from a specified user.

| caps: | users=write |
| ----- | ----------- |
|       |             |

### Syntax

```
DELETE /{admin}/user?caps&format=json HTTP/1.1
Host {fqdn}
```

### Request Parameters

```
uid
```

| Description: | The user ID to remove an administrative capability from. |
| ------------ | -------------------------------------------------------- |
| Type:        | String                                                   |
| Example:     | `foo_user`                                               |
| Required:    | Yes                                                      |

```
user-caps
```

| Description: | The administrative capabilities to remove from the user. |
| ------------ | -------------------------------------------------------- |
| Type:        | String                                                   |
| Example:     | `usage=read, write`                                      |
| Required:    | Yes                                                      |

### Response Entities

If successful, the response contains the user’s capabilities.

```
user
```

| Description: | A container for the user data information. |
| ------------ | ------------------------------------------ |
| Type:        | Container                                  |
| Parent:      | `user`                                     |

```
user_id
```

| Description: | The user id. |
| ------------ | ------------ |
| Type:        | String       |
| Parent:      | `user`       |

```
caps
```

| Description: | User capabilities. |
| ------------ | ------------------ |
| Type:        | Container          |
| Parent:      | `user`             |

### Special Error Responses

```
InvalidCap
```

| Description: | Attempt to remove an invalid admin capability. |
| ------------ | ---------------------------------------------- |
| Code:        | 400 Bad Request                                |

```
NoSuchCap
```

| Description: | User does not possess specified capability. |
| ------------ | ------------------------------------------- |
| Code:        | 404 Not Found                               |

### Special Error Responses

None.

## Quotas

The Admin Operations API enables you to set quotas on users and on bucket owned by users. See [Quota Management](http://docs.ceph.org.cn/radosgw/admin#quota-management) for additional details. Quotas include the maximum number of objects in a bucket and the maximum storage size in megabytes.

To view quotas, the user must have a `users=read` capability. To set, modify or disable a quota, the user must have `users=write` capability. See the [Admin Guide](http://docs.ceph.org.cn/radosgw/admin) for details.

Valid parameters for quotas include:

- **Bucket:** The `bucket` option allows you to specify a quota for buckets owned by a user.
- **Maximum Objects:** The `max-objects` setting allows you to specify the maximum number of objects. A negative value disables this setting.
- **Maximum Size:** The `max-size` option allows you to specify a quota for the maximum number of bytes. A negative value disables this setting.
- **Quota Scope:** The `quota-scope` option sets the scope for the quota. The options are `bucket` and `user`.

### Get User Quota

To get a quota, the user must have `users` capability set with `read` permission.

```
GET /admin/user?quota&uid=<uid>&quota-type=user
```

### Set User Quota

To set a quota, the user must have `users` capability set with `write` permission.

```
PUT /admin/user?quota&uid=<uid>&quota-type=user
```

The content must include a JSON representation of the quota settings as encoded in the corresponding read operation.

### Get Bucket Quota

To get a quota, the user must have `users` capability set with `read` permission.

```
GET /admin/user?quota&uid=<uid>&quota-type=bucket
```

### Set Bucket Quota

To set a quota, the user must have `users` capability set with `write` permission.

```
PUT /admin/user?quota&uid=<uid>&quota-type=bucket
```

The content must include a JSON representation of the quota settings as encoded in the corresponding read operation.

## Standard Error Responses

```
AccessDenied
```

| Description: | Access denied. |
| ------------ | -------------- |
| Code:        | 403 Forbidden  |

```
InternalError
```

| Description: | Internal server error.    |
| ------------ | ------------------------- |
| Code:        | 500 Internal Server Error |

```
NoSuchUser
```

| Description: | User does not exist. |
| ------------ | -------------------- |
| Code:        | 404 Not Found        |

```
NoSuchBucket
```

| Description: | Bucket does not exist. |
| ------------ | ---------------------- |
| Code:        | 404 Not Found          |

```
NoSuchKey
```

| Description: | No such access key. |
| ------------ | ------------------- |
| Code:        | 404 Not Found       |

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - 管理操作 API
    - Get Usage
      - [语法](http://docs.ceph.org.cn/radosgw/adminops/#id2)
      - [请求参数](http://docs.ceph.org.cn/radosgw/adminops/#id3)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#response-entities)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#special-error-responses)
    - Trim Usage
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#syntax)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#request-parameters)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id4)
    - Get User Info
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id5)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id6)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id7)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id8)
    - Create User
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id9)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id10)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id11)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id12)
    - Modify User
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id13)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id14)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id15)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id16)
    - Remove User
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id17)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id18)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id19)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id20)
    - Create Subuser
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id21)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id22)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id23)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id24)
    - Modify Subuser
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id25)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id26)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id27)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id28)
    - Remove Subuser
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id29)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id30)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id31)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id32)
    - Create Key
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id33)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id34)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id35)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id36)
    - Remove Key
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id37)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id38)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id39)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id40)
    - Get Bucket Info
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id41)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id42)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id43)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id44)
    - Check Bucket Index
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id45)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id46)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id47)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id48)
    - Remove Bucket
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id49)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id50)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id51)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id52)
    - Unlink Bucket
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id53)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id54)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id55)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id56)
    - Link Bucket
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id57)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id58)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id59)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id60)
    - Remove Object
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id61)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id62)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id63)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id64)
    - Get Bucket or Object Policy
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id65)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id66)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id67)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id68)
    - Add A User Capability
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id69)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id70)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id71)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id72)
      - [Example Request](http://docs.ceph.org.cn/radosgw/adminops/#example-request)
    - Remove A User Capability
      - [Syntax](http://docs.ceph.org.cn/radosgw/adminops/#id73)
      - [Request Parameters](http://docs.ceph.org.cn/radosgw/adminops/#id74)
      - [Response Entities](http://docs.ceph.org.cn/radosgw/adminops/#id75)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id76)
      - [Special Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#id77)
    - Quotas
      - [Get User Quota](http://docs.ceph.org.cn/radosgw/adminops/#get-user-quota)
      - [Set User Quota](http://docs.ceph.org.cn/radosgw/adminops/#set-user-quota)
      - [Get Bucket Quota](http://docs.ceph.org.cn/radosgw/adminops/#get-bucket-quota)
      - [Set Bucket Quota](http://docs.ceph.org.cn/radosgw/adminops/#set-bucket-quota)
    - [Standard Error Responses](http://docs.ceph.org.cn/radosgw/adminops/#standard-error-responses)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/keystone/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/swift/ruby/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/man/8/radosgw/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/adminops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 与 OpenStack Keystone 对接[¶](http://docs.ceph.org.cn/radosgw/keystone/#openstack-keystone)

It is possible to integrate the Ceph Object Gateway with Keystone, the OpenStack identity service. This sets up the gateway to accept Keystone as the users authority. A user that Keystone authorizes to access the gateway will also be automatically created on the Ceph Object Gateway (if didn’t exist beforehand). A token that Keystone validates will be considered as valid by the gateway.

The following configuration options are available for Keystone integration:

```
[client.radosgw.gateway]
rgw keystone url = {keystone server url:keystone server admin port}
rgw keystone admin token = {keystone admin token}
rgw keystone accepted roles = {accepted user roles}
rgw keystone token cache size = {number of tokens to cache}
rgw keystone revocation interval = {number of seconds before checking revoked tickets}
rgw s3 auth use keystone = true
nss db path = {path to nss db}
```

A Ceph Object Gateway user is mapped into a Keystone `tenant`. A Keystone user has different roles assigned to it on possibly more than a single tenant. When the Ceph Object Gateway gets the ticket, it looks at the tenant, and the user roles that are assigned to that ticket, and accepts/rejects the request according to the `rgw keystone accepted roles` configurable.

## Kilo 之前

Keystone 自身作为对象存储服务的入口（ endpoint ），需要配置为指向 Ceph 对象网关。

```
keystone service-create --name swift --type object-store
keystone endpoint-create --service-id <id> \
        --publicurl   http://radosgw.example.com/swift/v1 \
        --internalurl http://radosgw.example.com/swift/v1 \
        --adminurl    http://radosgw.example.com/swift/v1
```

## 从 Kilo 起

Keystone 自身作为对象存储服务的入口（ endpoint ），需要配置为指向 Ceph 对象网关。

```
openstack service create --name=swift \
                         --description="Swift Service" \
                         object-store
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Swift Service                    |
| enabled     | True                             |
| id          | 37c4c0e79571404cb4644201a4a6e5ee |
| name        | swift                            |
| type        | object-store                     |
+-------------+----------------------------------+

openstack endpoint create --region RegionOne \
     --publicurl   "http://radosgw.example.com:8080/swift/v1" \
     --adminurl    "http://radosgw.example.com:8080/swift/v1" \
     --internalurl "http://radosgw.example.com:8080/swift/v1" \
     swift
+--------------+------------------------------------------+
| Field        | Value                                    |
+--------------+------------------------------------------+
| adminurl     | http://radosgw.example.com:8080/swift/v1 |
| id           | e4249d2b60e44743a67b5e5b38c18dd3         |
| internalurl  | http://radosgw.example.com:8080/swift/v1 |
| publicurl    | http://radosgw.example.com:8080/swift/v1 |
| region       | RegionOne                                |
| service_id   | 37c4c0e79571404cb4644201a4a6e5ee         |
| service_name | swift                                    |
| service_type | object-store                             |
+--------------+------------------------------------------+

$ openstack endpoint show object-store
+--------------+------------------------------------------+
| Field        | Value                                    |
+--------------+------------------------------------------+
| adminurl     | http://radosgw.example.com:8080/swift/v1 |
| enabled      | True                                     |
| id           | e4249d2b60e44743a67b5e5b38c18dd3         |
| internalurl  | http://radosgw.example.com:8080/swift/v1 |
| publicurl    | http://radosgw.example.com:8080/swift/v1 |
| region       | RegionOne                                |
| service_id   | 37c4c0e79571404cb4644201a4a6e5ee         |
| service_name | swift                                    |
| service_type | object-store                             |
+--------------+------------------------------------------+
```

The keystone URL is the Keystone admin RESTful API URL. The admin token is the token that is configured internally in Keystone for admin requests.

The Ceph Object Gateway will query Keystone periodically for a list of revoked tokens. These requests are encoded and signed. Also, Keystone may be configured to provide self-signed tokens, which are also encoded and signed. The gateway needs to be able to decode and verify these signed messages, and the process requires that the gateway be set up appropriately. Currently, the Ceph Object Gateway will only be able to perform the procedure if it was compiled with `--with-nss`. Configuring the Ceph Object Gateway to work with Keystone also requires converting the OpenSSL certificates that Keystone uses for creating the requests to the nss db format, for example:

```
mkdir /var/ceph/nss

openssl x509 -in /etc/keystone/ssl/certs/ca.pem -pubkey | \
        certutil -d /var/ceph/nss -A -n ca -t "TCu,Cu,Tuw"
openssl x509 -in /etc/keystone/ssl/certs/signing_cert.pem -pubkey | \
        certutil -A -d /var/ceph/nss -n signing_cert -t "P,P,P"
```

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - 与 OpenStack Keystone 集成
    - [Kilo 之前](http://docs.ceph.org.cn/radosgw/keystone/#kilo)
    - [从 Kilo 起](http://docs.ceph.org.cn/radosgw/keystone/#id1)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/man/8/radosgw/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/adminops/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/man/8/radosgw-admin/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/keystone/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# radosgw – rados REST 风格的网关

## 提纲

**radosgw**

## 描述

**radosgw** 是 RADOS 对象存储的一个 HTTP REST 网关，是 Ceph 分布式存储系统的一部分。它是用 libfcgi 实现的一个 FastCGI 模块，可联合任何支持 FastCGI 功能的网页服务器使用。

## 选项

- `-c`` ceph.conf``, ``--conf``=ceph.conf`

  用指定的 `ceph.conf` 配置文件而非默认的 `/etc/ceph/ceph.conf` 来确定启动时所需的监视器地址。

- `-m`` monaddress[:port]`

  连接到指定监视器，而非通过 `ceph.conf` 查询。

- `-i`` ID``, ``--id`` ID`

  设置 radosgw 名字的 ID 部分。

- `-n`` TYPE.ID``, ``--name`` TYPE.ID`

  设置网关的 rados 用户名（如 client.radosgw.gateway ）。

- `--cluster`` NAME`

  设置集群名称（默认： ceph ）

- `-d```

  在前台运行，日志记录到标准错误

- `-f```

  在前台运行，日志记录到正常位置

- `--rgw-socket-path``=path`

  指定 Unix 域套接字的路径

- `--rgw-region``=region`

  radosgw 所在 region

- `--rgw-zone``=zone`

  radosgw 所在的区域

## 配置

先前的 RADOS 网关配置依赖 `Apache` 和 `mod_fastcgi` ；现在则用 `mod_proxy_fcgi` 替换了 `mod_fastcgi` ，因为后者使用了非自由许可证。 `mod_proxy_fcgi` 不同于传统的 FastCGI 模块，它需要 `mod_proxy` 模块所支持的 FastCGI 协议。所以，要处理 FastCGI 协议，服务器需同时有 `mod_proxy` 和 `mod_proxy_fcgi` 模块。不像 `mod_fastcgi` ， `mod_proxy_fcgi` 不能启动应用进程。某些平台提供了 `fcgistarter` 来实现此功能。然而， FastCGI 应用框架有可能具备外部启动或进程管理功能。

`Apache` 可以通过本机 TCP 连接或 Unix 域套接字使用 `mod_proxy_fcgi` 模块。不支持 Unix 域套接字的 `mod_proxy_fcgi` ，像 Apache 2.2 和 2.4 的早期版本，必需通过本机 TCP 连接。

1. 更改 `/etc/ceph/ceph.conf` 文件，让 radosgw 使用 TCP 而非 Unix 域套接字。

   ```
   [client.radosgw.gateway]
   host = {hostname}
   keyring = /etc/ceph/ceph.client.radosgw.keyring
   rgw socket path = ""
   log file = /var/log/ceph/client.radosgw.gateway.log
   rgw frontends = fastcgi socket_port=9000 socket_host=0.0.0.0
   rgw print continue = false
   ```

2. 把下列内容加入网关配置文件：

   在 Debian/Ubuntu 上，加入 `/etc/apache2/conf-available/rgw.conf`

   ```
   <VirtualHost *:80>
   ServerName localhost
   DocumentRoot /var/www/html
   
   ErrorLog /var/log/apache2/rgw_error.log
   CustomLog /var/log/apache2/rgw_access.log combined
   
   # LogLevel debug
   
   RewriteEngine On
   
   RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
   
   SetEnv proxy-nokeepalive 1
   
   ProxyPass / fcgi://localhost:9000/
   
   </VirtualHost>
   ```

   在 CentOS/RHEL 上，加入 `/etc/httpd/conf.d/rgw.conf`:

   ```
   <VirtualHost *:80>
   ServerName localhost
   DocumentRoot /var/www/html
   
   ErrorLog /var/log/httpd/rgw_error.log
   CustomLog /var/log/httpd/rgw_access.log combined
   
   # LogLevel debug
   
   RewriteEngine On
   
   RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
   
   SetEnv proxy-nokeepalive 1
   
   ProxyPass / fcgi://localhost:9000/
   
   </VirtualHost>
   ```

3. 对于搭载了支持 Unix 域套接字的 Apache 2.4.9 及更高版的发行版，可使用下列配置：

   ```
   [client.radosgw.gateway]
   host = {hostname}
   keyring = /etc/ceph/ceph.client.radosgw.keyring
   rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
   log file = /var/log/ceph/client.radosgw.gateway.log
   rgw print continue = false
   ```

4. 把下列内容加入网关配置文件中：

   在 CentOS/RHEL 上，加入 `/etc/httpd/conf.d/rgw.conf`:

   ```
   <VirtualHost *:80>
   ServerName localhost
   DocumentRoot /var/www/html
   
   ErrorLog /var/log/httpd/rgw_error.log
   CustomLog /var/log/httpd/rgw_access.log combined
   
   # LogLevel debug
   
   RewriteEngine On
   
   RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
   
   SetEnv proxy-nokeepalive 1
   
   ProxyPass / unix:///var/run/ceph/ceph.radosgw.gateway.fastcgi.sock|fcgi://localhost:9000/
   
   </VirtualHost>
   ```

   Ubuntu 14.04 自带 `Apache 2.4.7` ，它不支持 Unix 域套接字，所以必须配置成本机 TCP 。 Unix 域套接字支持存在于 `Apache 2.4.9` 及其后续版本中。已经有人提交了申请，要求把 UDS 支持移植到 `Ubuntu 14.04` 的 `Apache 2.4.7` 。在这里：https://bugs.launchpad.net/ubuntu/+source/apache2/+bug/1411030

5. 给 radosgw 生成一个密钥，用于到集群认证。

   ```
   ceph-authtool -C -n client.radosgw.gateway --gen-key /etc/ceph/keyring.radosgw.gateway
   ceph-authtool -n client.radosgw.gateway --cap mon 'allow rw' --cap osd 'allow rwx' /etc/ceph/keyring.radosgw.gateway
   ```

6. 把密钥导入集群。

   ```
   ceph auth add client.radosgw.gateway --in-file=keyring.radosgw.gateway
   ```

7. 启动 Apache 和 radosgw 。

   Debian/Ubuntu:

   ```
   sudo /etc/init.d/apache2 start
   sudo /etc/init.d/radosgw start
   ```

   CentOS/RHEL:

   ```
   sudo apachectl start
   sudo /etc/init.d/ceph-radosgw start
   ```

## 记录使用日志

**radosgw** 会异步地维护使用率日志，它会累积用户操作统计并周期性地刷回。可用 **radosgw-admin** 访问和管理日志。

记录的信息包括数据传输总量、操作总量、成功操作总量。这些数据是按小时记录到桶所有者名下的，除非操作是针对服务的（如罗列桶时），这时会记录到操作用户名下。

下面是个配置实例：

```
[client.radosgw.gateway]
rgw enable usage log = true
rgw usage log tick interval = 30
rgw usage log flush threshold = 1024
rgw usage max shards = 32
rgw usage max user shards = 1
```

碎片总数决定着总共需要多少对象来保存使用日志信息。每用户碎片数确定了为单个用户保存使用信息需多少对象。 tick interval 可配置刷回日志的间隔秒数， flush threshold 决定了保留的日志条数达到多少才调用异步刷回。

## 使用范围

**radosgw** 是 Ceph 的一部分，这是个伸缩力强、开源、分布式的存储系统，更多信息参见 http://ceph.com/docs 。

## 参考

[*ceph*](http://docs.ceph.org.cn/man/8/ceph/)(8) [*radosgw-admin*](http://docs.ceph.org.cn/man/8/radosgw-admin/)(8)

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - radosgw 手册页
    - [提纲](http://docs.ceph.org.cn/man/8/radosgw/#id1)
    - [描述](http://docs.ceph.org.cn/man/8/radosgw/#id2)
    - [选项](http://docs.ceph.org.cn/man/8/radosgw/#id3)
    - [配置](http://docs.ceph.org.cn/man/8/radosgw/#id4)
    - [记录使用日志](http://docs.ceph.org.cn/man/8/radosgw/#id5)
    - [使用范围](http://docs.ceph.org.cn/man/8/radosgw/#id6)
    - [参考](http://docs.ceph.org.cn/man/8/radosgw/#id7)
  - [radosgw-admin 手册页](http://docs.ceph.org.cn/man/8/radosgw-admin/)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/man/8/radosgw-admin/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/keystone/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/api/) |
- ​          [previous](http://docs.ceph.org.cn/man/8/radosgw/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# radosgw-admin – rados REST 网关的用户管理工具

## 提纲

**radosgw-admin** *command* [ *options* *...* ]

## 描述

**radosgw-admin** 是 RADOS 网关用户管理工具，可用于创建和修改用户。

## 命令

**radosgw-admin** 工具有很多命令，可完成各种管理任务：

- **user create**

  创建一个新用户。

- **user modify**

  修改一个用户。

- **user info**

  显示用户信息，以及可能存在的子用户和密钥。

- **user rm**

  删除一个用户。

- **user suspend**

  暂停某用户。

- **user enable**

  重新允许暂停的用户。

- **user check**

  检查用户信息。

- **user stats**

  显示配额子系统统计的用户状态。

- **caps add**

  给用户分配能力。

- **caps rm**

  删除用户能力。

- **subuser create**

  新建一个子用户（适合使用 Swift API 的客户端）。

- **subuser modify**

  修改子用户。

- **subuser rm**

  删除子用户

- **key create**

  新建访问密钥。

- **key rm**

  删除访问密钥。

- **bucket list**

  罗列所有桶。

- **bucket link**

  把桶关联到指定用户。

- **bucket unlink**

  取消指定用户和桶的关联。

- **bucket stats**

  返回桶的统计信息。

- **bucket rm**

  删除一个桶。

- **bucket check**

  检查桶的索引信息。

- **object rm**

  删除一个对象。

- **object unlink**

  从桶索引里去掉对象。

- **quota set**

  设置配额参数。

- **quota enable**

  启用配额。

- **quota disable**

  禁用配额。

- **region get**

  显示 region 信息。

- **regions list**

  列出本集群配置的所有 region 。

- **region set**

  设置 region 信息（需要输入文件）。

- **region default**

  设置默认 region 。

- **region-map get**

  显示 region-map 。

- **region-map set**

  设置 region-map （需要输入文件）。

- **zone get**

  显示区域集群参数。

- **zone set**

  设置区域集群参数（需要输入文件）。

- **zone list**

  列出本集群内配置的所有区域。

- **pool add**

  增加一个已有存储池用于数据归置。

- **pool rm**

  从数据归置集删除一个已有存储池。

- **pools list**

  罗列归置活跃集。

- **policy**

  显示桶或对象相关的策略。

- **log list**

  罗列日志对象。

- **log show**

  显示指定对象内（或指定桶、日期、桶标识符）的日志。

- **log rm**

  删除日志对象。

- **usage show**

  查看使用率信息（可选选项有用户和数据范围）。

- **usage trim**

  修剪使用率信息（可选选项有用户和数据范围）。

- **temp remove**

  删除指定日期（时间可选）之前创建的临时对象。

- **gc list**

  显示过期的垃圾回收对象（加 –include-all 选项罗列所有条目，包括未过期的）。

- **gc process**

  手动处理垃圾。

- **metadata get**

  读取元数据信息。

- **metadata put**

  设置元数据信息。

- **metadata rm**

  删除元数据信息。

- **metadata list**

  罗列元数据信息。

- **mdlog list**

  罗列元数据日志。

- **mdlog trim**

  裁截元数据日志。

- **bilog list**

  罗列桶索引日志。

- **bilog trim**

  裁截桶索引日志（需要起始标记、结束标记）。

- **datalog list**

  罗列数据日志。

- **datalog trim**

  裁截数据日志。

- **opstate list**

  罗列含状态操作（需要 client_id 、 op_id 、对象）。

- **opstate set**

  设置条目状态（需指定 client_id 、 op_id 、对象、状态）。

- **opstate renew**

  更新某一条目的状态（需指定 client_id 、 op_id 、对象）。

- **opstate rm**

  删除条目（需指定 client_id 、 op_id 、对象）。

- **replicalog get**

  读取复制元数据日志条目。

- **replicalog delete**

  删除复制元数据日志条目。

## 选项

- `-c`` ceph.conf``, ``--conf``=ceph.conf`

  用指定的 `ceph.conf` 配置文件而非默认的 `/etc/ceph/ceph.conf` 来确定启动时所需的监视器地址。

- `-m`` monaddress[:port]`

  连接到指定监视器，而非通过 ceph.conf 查询。

- `--uid``=uid`

  radosgw 用户的 ID 。

- `--subuser``=<name>`

  子用户名字。

- `--email``=email`

  用户的电子邮件地址。

- `--display-name``=name`

  配置用户的显示名称（昵称）

- `--access-key``=<key>`

  S3 访问密钥。

- `--gen-access-key```

  生成随机访问密钥（给 S3 ）。

- `--secret``=secret`

  指定密钥的密文。

- `--gen-secret```

  生成随机密钥。

- `--key-type``=<type>`

  密钥类型，可用的有： swift 、 S3 。

- `--temp-url-key``[-2]=<key>`

  临时 URL 密钥。

- `--system```

  给用户设置系统标识。

- `--bucket``=bucket`

  指定桶名

- `--object``=object`

  指定对象名

- `--date``=yyyy-mm-dd`

  某些命令所需的日期

- `--start-date``=yyyy-mm-dd`

  某些命令所需的起始日期

- `--end-date``=yyyy-mm-dd`

  某些命令所需的终结日期

- `--shard-id``=<shard-id>`

  执行 `mdlog list` 时为可选项。对 `mdlog trim` 、 `replica mdlog get/delete` 、 `replica datalog get/delete` 来说是必须的。

- `--auth-uid``=auid`

  librados 认证所需的 auid 。

- `--purge-data```

  删除用户前先删除用户数据。

- `--purge-keys```

  若加了此选项，删除子用户时将一起删除其所有密钥。

- `--purge-objects```

  删除桶前先删除其内所有对象。

- `--metadata-key``=<key>`

  用 `metadata get` 检索元数据时用的密钥。

- `--rgw-region``=<region>`

  radosgw 所在的 region 。

- `--rgw-zone``=<zone>`

  radosgw 所在的区域。

- `--fix```

  除了检查桶索引，还修复它。

- `--check-objects```

  检查桶：根据对象的实际状态重建桶索引。

- `--format``=<format>`

  为某些操作指定输出格式： xml 、 json 。

- `--sync-stats```

  `user stats` 的选项，收集用户的桶索引状态、并同步到用户状态。

- `--show-log-entries``=<flag>`

  执行 `log show` 时，显示或不显示日志条目。

- `--show-log-sum``=<flag>`

  执行 `log show` 时，显示或不显示日志汇总。

- `--skip-zero-entries```

  让 `log show` 只显示数字字段非零的日志。

- `--infile```

  设置时指定要读取的文件。

- `--state``=<state string>`

  给 `opstate set` 命令指定状态。

- `--replica-log-type```

  复制日志类型（ metadata 、 data 、 bucket ），操作复制日志时需要。

- `--categories``=<list>`

  逗号分隔的一系列类目，显示使用情况时需要。

- `--caps``=<caps>`

  能力列表，如 “usage=read, write; user=read” 。

- `--yes-i-really-mean-it```

  某些特定操作需要。

## 配额选项

- `--bucket```

  为配额命令指定桶。

- `--max-objects```

  指定最大对象数（负数为禁用）。

- `--max-size```

  指定最大尺寸（单位为字节，负数为禁用）。

- `--quota-scope```

  配额有效范围（桶、用户）。

## 实例

生成一新用户：

```
$ radosgw-admin user create --display-name="johnny rotten" --uid=johnny
{ "user_id": "johnny",
  "rados_uid": 0,
  "display_name": "johnny rotten",
  "email": "",
  "suspended": 0,
  "subusers": [],
  "keys": [
        { "user": "johnny",
          "access_key": "TCICW53D9BQ2VGC46I44",
          "secret_key": "tfm9aHMI8X76L3UdgE+ZQaJag1vJQmE6HDb5Lbrz"}],
  "swift_keys": []}
```

删除一用户：

```
$ radosgw-admin user rm --uid=johnny
```

删除一个用户和与他相关的桶及内容：

```
$ radosgw-admin user rm --uid=johnny --purge-data
```

删除一个桶：

```
$ radosgw-admin bucket unlink --bucket=foo
```

显示一个桶从 2012 年 4 月 1 日起的日志：

```
$ radosgw-admin log show --bucket=foo --date=2012-04-01
```

显示某用户 2012 年 3 月 1 日（不含）到 4 月 1 日期间的使用情况：

```
$ radosgw-admin usage show --uid=johnny \
                --start-date=2012-03-01 --end-date=2012-04-01
```

只显示所有用户的使用情况汇总：

```
$ radosgw-admin usage show --show-log-entries=false
```

裁剪掉某用户 2012 年 4 月 1 日之前的使用信息：

```
$ radosgw-admin usage trim --uid=johnny --end-date=2012-04-01
```

## 使用范围

**radosgw-admin** 是 Ceph 的一部分，这是个伸缩力强、开源、分布式的存储系统，更多信息参见 http://ceph.com/docs 。

## 参考

[*ceph*](http://docs.ceph.org.cn/man/8/ceph/)(8) [*radosgw*](http://docs.ceph.org.cn/man/8/radosgw/)(8)

[               ![Logo](http://docs.ceph.org.cn/_static/logo.png)             ](http://docs.ceph.org.cn/)

### [Table Of Contents](http://docs.ceph.org.cn/)

- [Ceph 简介](http://docs.ceph.org.cn/start/intro/)
- [安装（快速）](http://docs.ceph.org.cn/start/)
- [安装（手动）](http://docs.ceph.org.cn/install/)
- [Ceph 存储集群](http://docs.ceph.org.cn/rados/)
- [Ceph 文件系统](http://docs.ceph.org.cn/cephfs/)
- [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd/)
- Ceph 对象网关
  - [手动安装](http://docs.ceph.org.cn/install/install-ceph-gateway/)
  - [简单配置](http://docs.ceph.org.cn/radosgw/config/)
  - [异地同步配置](http://docs.ceph.org.cn/radosgw/federated-config/)
  - [配置参考](http://docs.ceph.org.cn/radosgw/config-ref/)
  - [管理指南](http://docs.ceph.org.cn/radosgw/admin/)
  - [清除临时数据](http://docs.ceph.org.cn/radosgw/purge-temp/)
  - [S3 API](http://docs.ceph.org.cn/radosgw/s3/)
  - [Swift API](http://docs.ceph.org.cn/radosgw/swift/)
  - [管理操作 API](http://docs.ceph.org.cn/radosgw/adminops/)
  - [与 OpenStack Keystone 集成](http://docs.ceph.org.cn/radosgw/keystone/)
  - [radosgw 手册页](http://docs.ceph.org.cn/man/8/radosgw/)
  - radosgw-admin 手册页
    - [提纲](http://docs.ceph.org.cn/man/8/radosgw-admin/#id1)
    - [描述](http://docs.ceph.org.cn/man/8/radosgw-admin/#id2)
    - [命令](http://docs.ceph.org.cn/man/8/radosgw-admin/#id3)
    - [选项](http://docs.ceph.org.cn/man/8/radosgw-admin/#id4)
    - [配额选项](http://docs.ceph.org.cn/man/8/radosgw-admin/#id5)
    - [实例](http://docs.ceph.org.cn/man/8/radosgw-admin/#id6)
    - [使用范围](http://docs.ceph.org.cn/man/8/radosgw-admin/#id7)
    - [参考](http://docs.ceph.org.cn/man/8/radosgw-admin/#id8)
- [API 文档](http://docs.ceph.org.cn/api/)
- [体系结构](http://docs.ceph.org.cn/architecture/)
- [开发文档](http://docs.ceph.org.cn/dev/)
- [Release Notes](http://docs.ceph.org.cn/release-notes/)
- [Ceph 版本](http://docs.ceph.org.cn/releases/)
- [Ceph 术语](http://docs.ceph.org.cn/glossary/)

- [Index](http://docs.ceph.org.cn/genindex/)

### Quick search

​            

​                

​    Enter search terms or a module, class or function name.    

- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/api/) |
- ​          [previous](http://docs.ceph.org.cn/man/8/radosgw/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    