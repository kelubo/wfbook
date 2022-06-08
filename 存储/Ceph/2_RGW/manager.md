- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/purge-temp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/config-ref/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 管理手册

一旦你的 Ceph 对象存储服务成功启动并运行, 你就可以实现管理服务, 比如用户管理、访问控制、限额和用量跟踪等功能。

## 用户管理

Ceph 对象存储用户管理是指 Ceph 对象存储服务的用户(即：这里讲 的并不是 Ceph 对象网关是作为 Ceph  存储集群的一个用户)。你必须 创建一个用户, 生成 access 和 access 秘钥以使得最终用户能够与 Ceph 对象网关服务进行交互。

有两种类型的用户:

- **用户:** ‘用户’ 这个表示这个是使用 S3 接口的一个用户.
- **子用户:**  ‘子用户’ 这个词表示使用的是 Swift 接口的一个用户. 一个子用户 是和一个用户关联的.

![img](http://docs.ceph.org.cn/_images/ditaa-b4d57ecd6d1bf334f8d70e716c0870738a375d5a.png)

对于用户和子用户，你可以执行新建、修改、查看、停用和删除操作。除了用户和 子用户的  ID，你还需要给用户添加一个显示名称和邮件地址。你可以手动指定 access 和 secret 密钥，  或者选择自动生成。当你生成或者指定密钥的时候，请注意，用户的 ID 是跟 S3 类型的密钥 关联而子用户的 ID 则是跟 Swift  类型的密钥关联。Swift 密钥也拥有 `read`, `write`, `readwrite` 和 `full` 这几种访问级别。

### 新建一个用户

执行下面的命令新建一个用户 (S3 接口):

```
radosgw-admin user create --uid={username} --display-name="{display-name}" [--email={email}]
```

实例如下:

```
radosgw-admin user create --uid=johndoe --display-name="John Doe" --email=john@example.com
{ "user_id": "johndoe",
  "display_name": "John Doe",
  "email": "john@example.com",
  "suspended": 0,
  "max_buckets": 1000,
  "auid": 0,
  "subusers": [],
  "keys": [
        { "user": "johndoe",
          "access_key": "11BS02LGFB6AL6H1ADMW",
          "secret_key": "vzCEkuryfn060dfee4fgQPqFrncKEIkh3ZcdOANY"}],
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

新建用户的时候也同时会生成 `access_key` 和 `secret_key` 入口，以便任何兼容 S3 API 的客户端能够使用。

Important

仔细检查命令输出的密钥。有时 `radosgw-admin` 会生成一个 JSON转义字 符(`\`),但是有些客户端不道如何处理JSON 转义字符。补救措施包括将JSON转义字符(`\`) 删除，将这些字符串封装在引号内，重新生成密钥 直到确定没有JSON转义字符存在或手动指定所需的 密钥。

### 新建一个子用户

为了给用户新建一个子用户 (Swift 接口) ，你必须为该子用户指定用户的 ID(`--uid={username}`)，子用户的 ID 以及访问级别:

```
radosgw-admin subuser create --uid={uid} --subuser={uid} --access=[ read | write | readwrite | full ]
```

实例如下:

```
radosgw-admin subuser create --uid=johndoe --subuser=johndoe:swift --access=full
```

Note

`full` 并不表示 `readwrite`, 因为它还包括访问权限策略.

```
{ "user_id": "johndoe",
  "display_name": "John Doe",
  "email": "john@example.com",
  "suspended": 0,
  "max_buckets": 1000,
  "auid": 0,
  "subusers": [
        { "id": "johndoe:swift",
          "permissions": "full-control"}],
  "keys": [
        { "user": "johndoe",
          "access_key": "11BS02LGFB6AL6H1ADMW",
          "secret_key": "vzCEkuryfn060dfee4fgQPqFrncKEIkh3ZcdOANY"}],
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

### 获取用户信息

要获取一个用户的信息，你必须使用 `user info` 子命令并且制定一个用户 ID(`--uid={username}`) .

```
radosgw-admin user info --uid=johndoe
```

### 修改用户信息

要修改一个用户的信息，你必须指定用户的 ID (`--uid={username}`)，还有 你想要修改的属性值。典型的修改项主要是 access 和secret 密钥，邮件地址，显 示名称和访问级别。举例如下:

```
radosgw-admin user modify --uid=johndoe --display-name="John E. Doe"
```

要修改子用户的信息, 使用 `subuser modify` 子命令并且执行子用户的 ID. 举例如下:

```
radosgw-admin subuser modify --uid=johndoe:swift --access=full
```

### 用户 启用/停用

当你创建了一个用户，用户默认情况下是处于启用状态的。然而，你可以暂停用户权 限并在以后随时重新启用它们。暂停一个用户，使用 `user suspend`  子命令 然后哦指定用户的 ID:

```
radosgw-admin user suspend --uid=johndoe
```

要重新启用已经被停用的用户，使用 `user enable` 子命令并指明用户的 ID.

```
radosgw-admin user enable --uid=johndoe
```

Note

停用一个用户后，它的子用户也会一起被停用.

### 删除用户

删除用户时，这个用户以及他的子用户都会被删除。当然，如果你愿意，可以只删除子用户。要删除用户（及其子用户），可使用 `user rm` 子命令并指明用户 ID ：

```
radosgw-admin user rm --uid=johndoe
```

只想删除子用户时，可使用 `subuser rm` 子命令并指明子用户 ID 。

```
radosgw-admin subuser rm --subuser=johndoe:swift
```

其它可选操作：

- **Purge Data:** 加 `--purge-data` 选项可清除与此 UID 相关的所有数据。
- **Purge Keys:** 加 `--purge-keys` 选项可清除与此 UID 相关的所有密钥。

### 删除子用户

在你删除子用户的同时，也失去了 Swift 接口的访问方式，但是这个用户在系统 中还存在。要删除子用户，可使用 `subuser rm` 子命令并指明子用户 ID ：

```
radosgw-admin subuser rm --subuser=johndoe:swift
```

其它可选操作：

- **Purge Keys:** 加 `--purge-keys` 选项可清除与此 UID 相关的所有密钥。

### 新建一个密钥

要为用户新建一个密钥，你需要使用 `key create` 子命令。对于用户来说，需要指明用户的 ID 以及新建的密钥类型为 `s3` 。要为子用户新建一个密钥，则需要指明子用户的 ID以及密钥类型为 `swift` 。实例如下:

```
radosgw-admin key create --subuser=johndoe:swift --key-type=swift --gen-secret
{ "user_id": "johndoe",
  "rados_uid": 0,
  "display_name": "John Doe",
  "email": "john@example.com",
  "suspended": 0,
  "subusers": [
     { "id": "johndoe:swift",
       "permissions": "full-control"}],
  "keys": [
    { "user": "johndoe",
      "access_key": "QFAMEDSJP5DEKJO0DDXY",
      "secret_key": "iaSFLDVvDdQt6lkNzHyW4fPLZugBAI1g17LO0+87"}],
  "swift_keys": [
    { "user": "johndoe:swift",
      "secret_key": "E9T2rUZNu2gxUjcwUBO8n\/Ev4KX6\/GprEuH4qhu1"}]}
```

### 新建/删除 Access 密钥

用户和子用户要能使用 S3 和Swift 接口，必须有 access 密钥。在你新 建用户或者子用户的时候，如果没有指明 access 和 secret 密钥，这两 个密钥会自动生成。你可能需要新建 access 和/或 secret 密钥，不管是  手动指定还是自动生成的方式。你也可能需要删除一个 access 和 secret 。可用的选项有：

- `--secret=<key>` 指明一个 secret 密钥 (e.即手动生成).
- `--gen-access-key` 生成一个随机的 access 密钥 (新建 S3 用户的默认选项).
- `--gen-secret` 生成一个随机的 secret 密钥.
- `--key-type=<type>` 指定密钥类型. 这个选项的值可以是: swift, s3

要新建密钥，需要指明用户 ID.

```
radosgw-admin key create --uid=johndoe --key-type=s3 --gen-access-key --gen-secret
```

你也可以使用指定 access 和 secret 密钥的方式.

要删除一个 access 密钥, 也需要指定用户 ID.

```
radosgw-admin key rm --uid=johndoe
```

### 添加/删除 管理权限

Ceph 存储集群提供了一个管理API，它允许用户通过 REST API 执行管理功能。默认情况下，用户没有访问 这个 API 的权限。要启用用户的管理功能，需要为用 户提供管理权限。

执行下面的命令为一个用户添加管理权限:

```
radosgw-admin caps add --uid={uid} --caps={caps}
```

你可以给一个用户添加对用户、bucket、元数据和用量(存储使用信息)等数据的 读、写或者所有权限。举例如下:

```
--caps="[users|buckets|metadata|usage|zone]=[*|read|write|read, write]"
```

实例如下:

```
radosgw-admin caps add --uid=johndoe --caps="users=*"
```

要删除某用户的管理权限，可用下面的命令：

```
radosgw-admin caps rm --uid=johndoe --caps={caps}
```

## 配额管理

Ceph对象网关允许你在用户级别、用户拥有的 bucket 级别设置配额。配额包括一个 bucket 内允许的最大对象数和最大存储容量，大小单位 是兆字节。

- **Bucket:** 选项 `--bucket` 允许你为用户的某一个 bucket 设置配额。
- **Maximum Objects:**  选项 `--max-objects` 允许 你设置最大对象数。负数表示不启用这个设置。
- **Maximum Size:** 选项 `--max-size` 允许你设置一个 最大存储用量的配额。负数表示不启用这个设置。
- **Quota Scope:** 选项 `--quota-scope` 表示这个配额 生效的范围。这个参数的值是 `bucket` 和 `user`. Bucket 配额作用于用户的某一个 bucket。而用户配额作用于一个用户。

### 设置用户配额

在你启用用户的配额前 ，你需要先设置配额参数。 例如:

```
radosgw-admin quota set --quota-scope=user --uid=<uid> [--max-objects=<num objects>] [--max-size=<max size>]
```

实例如下:

```
radosgw-admin quota set --quota-scope=user --uid=johndoe --max-objects=1024 --max-size=1024
```

最大对象数和最大存储用量的值是负数则表示不启用指定的 配额参数。

### 启用/禁用用户配额

在你设置了用户配额之后，你可以启用这个配额。实例如下:

```
radosgw-admin quota enable --quota-scope=user --uid=<uid>
```

你也可以禁用已经启用了配额的用户的配额。 举例如下:

```
radosgw-admin quota-disable --quota-scope=user --uid=<uid>
```

### 设置 Bucket 配额

Bucket 配额作用于用户的某一个 bucket，通过 `uid` 指定用户。这些配额设置是独立于用户之外的。:

```
radosgw-admin quota set --uid=<uid> --quota-scope=bucket [--max-objects=<num objects>] [--max-size=<max size]
```

最大对象数和最大存储用量的值是负数则表示不启用指定的 配额参数。

### 启用/禁用 bucket 配额

在你设置了 bucket 配额之后，你可以启用这个配额。实例如下:

```
radosgw-admin quota enable --quota-scope=bucket --uid=<uid>
```

你也可以禁用已经启用了配额的 bucket 的配额。 举例如下:

```
radosgw-admin quota-disable --quota-scope=bucket --uid=<uid>
```

### 获取配额信息

你可以通过用户信息 API 来获取每一个用户的配额 设置。通过 CLI 接口读取用户的配额设置信息，请 执行下面的命令:

```
radosgw-admin user info --uid=<uid>
```

### 更新配额统计信息

配额的统计数据的同步是异步的。你也可以通过手动获 取最新的配额统计数据为所有用户和所有 bucket 更 新配额统计数据:

```
radosgw-admin user stats --uid=<uid> --sync-stats
```

### 获取用户用量统计信息

执行下面的命令获取当前用户已经消耗了配额的多少:

```
radosgw-admin user stats --uid=<uid>
```

Note

你应该在执行 `radosgw-admin user stats` 的时候带上 `--sync-stats` 参数来获取最新的数据.

### 读取/设置全局配额

你可以在 region map中读取和设置配额。执行下面的命 令来获取 region map:

```
radosgw-admin regionmap get > regionmap.json
```

要为整个 region 设置配额，只需要简单的修改 region map 中的配额设置。然后使用 `region set` 来更新 region map即可:

```
radosgw-admin region set < regionmap.json
```

Note

在更新 region map 后，你必须重启网关.

## 用量

Ceph 对象网关会为每一个用户记录用量数据。你也可以通过指定 日期范围来跟踪用户的用量数据。

可用选项如下:

- **Start Date:** 选项 `--start-date` 允许你指定一个起始日期来过滤用量数据 (**format:** `yyyy-mm-dd[HH:MM:SS]`).
- **End Date:** 选项 `--end-date` 允许你指定一个截止日期来过滤用量数据 (**format:** `yyyy-mm-dd[HH:MM:SS]`).
- **Log Entries:** 选项 `--show-log-entries` 允许你 指明显示用量数据的时候是否要包含日志条目。 (选项值: `true` | `false`).

Note

你可以指定时间为分钟和秒，但是数据存储是以一个小时 

的间隔存储的.

### 展示用量信息

显示用量统计数据，使用 `usage show` 子命令。显示某一个特定 用户的用量数据，你必须指定该用户的 ID。你也可以指定开始日期、结 束日期以及是否显示日志条目。:

```
radosgw-admin usage show --uid=johndoe --start-date=2012-03-01 --end-date=2012-04-01
```

通过去掉用户的 ID，你也可以获取所有用户的汇总的用量信息

```
radosgw-admin usage show --show-log-entries=false
```

### 删除用量信息

对于大量使用的集群而言，用量日志可能会占用大量存储空间。你 可以为所有用户或者一个特定的用户删除部分用量日志。你也可以 为删除操作指定日期范围。:

```
radosgw-admin usage trim --start-date=2010-01-01 --end-date=2010-12-31
radosgw-admin usage trim --uid=johndoe
radosgw-admin usage trim --uid=johndoe --end-date=2013-12-31
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
  - 管理指南
    - 用户管理
      - [新建一个用户](http://docs.ceph.org.cn/radosgw/admin/#id3)
      - [新建一个子用户](http://docs.ceph.org.cn/radosgw/admin/#id4)
      - [获取用户信息](http://docs.ceph.org.cn/radosgw/admin/#id5)
      - [修改用户信息](http://docs.ceph.org.cn/radosgw/admin/#id6)
      - [用户 启用/停用](http://docs.ceph.org.cn/radosgw/admin/#id7)
      - [删除用户](http://docs.ceph.org.cn/radosgw/admin/#id8)
      - [删除子用户](http://docs.ceph.org.cn/radosgw/admin/#id9)
      - [新建一个密钥](http://docs.ceph.org.cn/radosgw/admin/#id10)
      - [新建/删除 Access 密钥](http://docs.ceph.org.cn/radosgw/admin/#access)
      - [添加/删除 管理权限](http://docs.ceph.org.cn/radosgw/admin/#id11)
    - 配额管理
      - [设置用户配额](http://docs.ceph.org.cn/radosgw/admin/#id13)
      - [启用/禁用用户配额](http://docs.ceph.org.cn/radosgw/admin/#id14)
      - [设置 Bucket 配额](http://docs.ceph.org.cn/radosgw/admin/#bucket)
      - [启用/禁用 bucket 配额](http://docs.ceph.org.cn/radosgw/admin/#id15)
      - [获取配额信息](http://docs.ceph.org.cn/radosgw/admin/#id16)
      - [更新配额统计信息](http://docs.ceph.org.cn/radosgw/admin/#id17)
      - [获取用户用量统计信息](http://docs.ceph.org.cn/radosgw/admin/#id18)
      - [读取/设置全局配额](http://docs.ceph.org.cn/radosgw/admin/#id19)
    - 用量
      - [展示用量信息](http://docs.ceph.org.cn/radosgw/admin/#id21)
      - [删除用量信息](http://docs.ceph.org.cn/radosgw/admin/#id22)
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
- ​          [next](http://docs.ceph.org.cn/radosgw/purge-temp/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/config-ref/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    



- ​          [index](http://docs.ceph.org.cn/genindex/)
- ​          [modules](http://docs.ceph.org.cn/py-modindex/) |
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/admin/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

# 清除临时数据

Deprecated since version 0.52.

When you delete objects (and buckets/containers), the Gateway marks the  data for removal, but it is still available to users until it is purged. Since data still resides in storage until it is purged, it may take up available storage space. To ensure that data marked for deletion isn’t taking up a significant amount of storage space, you should run the following command periodically:

```
radosgw-admin temp remove
```

Important

Data marked for deletion may still be read. So consider executing the foregoing command a reasonable interval after data was marked for deletion.

Tip

Consider setting up a `cron` job to purge data.

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
- ​          [next](http://docs.ceph.org.cn/radosgw/s3/) |
- ​          [previous](http://docs.ceph.org.cn/radosgw/admin/) |
- [Ceph Documentation](http://docs.ceph.org.cn/) »
- [Ceph 对象网关](http://docs.ceph.org.cn/radosgw/) »

​        © Copyright 2010-2014, Inktank Storage, Inc. and contributors. Licensed under Creative Commons BY-SA.    

