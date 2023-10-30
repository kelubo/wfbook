# 添加客户端（Bareos 文件守护程序）

[TOC]

## 概述

假设，以下是有关您要添加到备份环境中的计算机的设置：

| 名称          | 描述                      |
| ------------- | ------------------------- |
| 主机名 (FQDN) | client2.example.com       |
| IP Address    | 192.168.0.2               |
| OS            | Linux（否则路径可能不同） |

必须在服务器端（Bareos Director）和客户端进行更改。

### Client: 安装软件

需要在另一台计算机上安装的唯一部分是 Bareos filedaemon 。

### Director: 配置客户端

Bareos Version >= 16.2.4 提供了 `configure add` 命令来向 Bareos Director 添加资源。

启动 `bconsole` 并使用 `configure add client` 命令。地址必须是 DNS 可解析名称或 IP 地址。

```bash
*configure add client name=client2-fd address=192.168.0.2 password=secret
Created resource config file "/etc/bareos/bareos-dir.d/client/client2-fd.conf":
Client {
  Name = client2-fd
  Address = 192.168.0.2
  Password = secret
}
```

这将创建两个资源配置文件：

- `/etc/bareos/bareos-dir.d/client/client2-fd.conf`

- `/etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf` 

  （假设控制器资源名为bareos-dir **bareos-dir**）

`/etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf` 是 Bareos 文件守护程序所需的必需资源。可以将其复制到目的地：

```
scp /etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf root@client2.example.com:/etc/bareos/bareos-fd.d/director/
```

#### 手动配置

或者，可以手动配置资源。在 Bareos Director 上创建文件 `bareos-dir.d/client/client2-fd.conf` :

```bash
Client {
  Name = client2-fd
  Address = 192.168.0.2
  Password = secret
}
```

重新加载或重新启动 Bareos Director：

```bash
*reload
reloaded
```

相应的 Bareos File Daemon director 资源可以直接在客户端上创建，参见下文。

### Client: 配置

软件包 `bareos-filedaemon`  Version >= 16.2.4带来了几个配置文件：

- `/etc/bareos/bareos-fd.d/client/myself.conf`
- `/etc/bareos/bareos-fd.d/director/bareos-dir.conf`
- `/etc/bareos/bareos-fd.d/director/bareos-mon.conf`
- `/etc/bareos/bareos-fd.d/messages/Standard.conf`

具体如下：

- `client/myself.conf`

  定义客户端的名称。默认值为 `<hostname>-fd` 。只有想使用另一个名字或禁用特殊的 Bareos 文件守护程序功能时，才需要进行更改。

- `director/bareos-dir.conf`

  使 Bareos Director 完全访问此 Bareos File Daemon 。在安装过程中，`Password (Fd->Director)` 设置为随机默认值。调整名称和/或密码以适应您的 Bareos Director 。(名称 `bareos-dir` 是自 Bareos >= 16.2.4 以来的默认 Bareos 控制器名称。）

- `director/bareos-mon.conf`

  使 Bareos Director （bareos-mon） 限制访问此 Bareos File Daemon。在安装过程中，`Password (Fd->Director)` 设置为随机值。此资源旨在由本地 `bareos-tray-monitor` 使用。

- `messages/Standard.conf`

  定义应如何处理消息。默认情况下，将所有相关消息发送到 Bareos Director 。

如果您的 Bareos Director 名为 `bareos-dir` ，则 `/etc/bareos/bareos-fd.d/director/bareos-dir.conf` 可能已被您从 Bareos Director 复制的文件覆盖。如果您的 Director 有其他名称，则会存在一个附加资源文件。可以在 Bareos 文件守护程序配置中定义任意数量的 Bareos Director 。但是，通常您只有一个 `Director (Fd)` 完全控制您的 Bareos 文件守护程序和可选的一个 `Director (Fd)` 用于监视（由 Bareos Traymonitor 使用）。

无论如何，资源看起来类似于这样（`bareos-fd.d/director/bareos-dir.conf`）：

```bash
Director {
  Name = bareos-dir
  Password = "[md5]5ebe2294ecd0e0f08eab7690d2a6ee69"
}
```

After a restart of the Bareos File Daemon to reload the configuration this resource allows the access for a Bareos Director with name **bareos-dir** and password **secret** (stored in MD5 format).

在重新启动 Bareos 文件守护程序以重新加载配置后，此资源允许使用名称 `bareos-dir` 和密码 `secret`（以MD5 格式存储）访问 Bareos Director。

```bash
service bareos-fd restart

systemctl restart bareos-fd.service
```

#### 手动配置

如果您尚未通过 `configure` 创建 `Director (Fd)` ，也可以手动创建。如果您的 Bareos Director 也命名为 `bareos-dir` ，请修改或创建文件 `/etc/bareos/bareos-fd.d/director/bareos-dir.conf` ：

```bash
Director {
  Name = "bareos-dir"   # Name of your Bareos Director
  Password = "secret"   # Password (cleartext or MD5) must be identical
                        # to the password of your client reosurce in the Direcotr
                        # (bareos-dir.d/client/client2-fd.conf)
}
```

如果您没有使用子目录配置方案（Subdirectory Configuration Scheme），请确保此资源文件包含在 Bareos 文件守护程序配置中。您可以通过以下方式进行验证：

```bash
bareos-fd -xc
```

修改文件后，你必须重新启动 Bareos 文件守护程序：

```bash
service bareos-fd restart
```

### Director: 测试客户端，添加作业

下面的示例演示如何：

- 验证从 Bareos Director 到 Bareos File Daemon 的网络连接。
- 添加作业资源。
- 试运行作业（estimate listing估计列表）。
- 运行作业。
- 等待工作完成。
- 验证作业。

```bash
*status client=client2-fd
...
*configure add job name=client2-job client=client2-fd jobdefs=DefaultJob
Created resource config file "/etc/bareos/bareos-dir.d/job/client2-job.conf":
Job {
  Name = client2-job
  Client = client2-fd
  JobDefs = DefaultJob
}
*estimate listing job=client2-job
...
*run job=client2-job
...
*wait jobid=...
...
*list joblog jobid=...
...
*list files jobid=...
...
*list volumes
...
```
