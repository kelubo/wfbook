# Docker 容器演示

[TOC]

## 备份

在此场景中，Percona XtraBackup 与兼容 MySQL 的数据库 Percona Server for MySQL 结合使用。要使用 Percona  XtraBackup，请在单独的 Docker 容器中运行它，然后将 Percona XtraBackup 容器连接到 Percona  Server for MySQL 容器。一旦在 Docker 容器中启动 Percona Server for MySQL，并在 Percona Server for MySQL 中创建数据库和表，就可以使用 Percona XtraBackup 备份数据了。

### 创建 Docker 卷

使用 Docker 卷的好处如下：

- 可以确保数据安全且可跨不同容器访问。例如，如果要将数据库映像升级到较新版本，则可以停止旧容器并启动附加了相同卷的新容器，而不会丢失任何数据。
- 可以使用 `docker cp` 命令快速备份和恢复数据，或将卷挂载到另一个容器。

```bash
docker volume create backupvol
```

### 在容器中启动 Percona XtraBackup 8.4，获取并准备备份

`docker run` 命令从镜像创建并运行新容器。该命令使用 options 修改容器的行为。

该命令具有以下选项：

| 选项             | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| `--name`         | 为容器提供名称。如果不使用此选项，Docker 会添加一个随机名称。 |
| `--volumes-from` | 引用 Percona Server for MySQL，并指示使用与 `psmysql` 容器相同的数据。 |
| `-it`            | 与容器交互并成为伪终端。                                     |
| `--user root`    | 在 Percona XtraBackup 容器中将用户设置为 root。访问 MySQL 数据目录并运行 xtrabackup 命令时，需要此选项。 |
| `backup_84`      | 指示容器内存储备份文件的目录。                               |
| `-v`             | 将主机中的卷挂载到正在运行的另一个容器中的卷。在示例中，`-v` 选项将卷从 `psmysql` 容器挂载到主机上的 `backupvol` 卷。 |
| `backupvol`      | 指示数据库的持久性存储。                                     |
| `psmysql`        | 指示 Percona Server for MySQL 容器。                         |
| `--password`     | 提示用户输入 root 用户的密码。为方便起见，可以将 root 用户的密码添加到此选项中，例如 `--password=secret`。然后，在运行命令时将自动传递密码。请注意，如果使用 `--password=secret` 指定密码，则密码在 `docker ps`、`docker ps -a`（docker 历史记录）和常规 ps 命令中可见。 |
| `8.4`            | 使用此标签指定特定版本。避免使用 `latest` 标签。在示例中，我们使用 `8.4` 标签。在 Docker 中，标签是分配给镜像的标签，用于维护镜像的不同版本。 |

如果不添加标签，Docker 将使用 `latest` 作为默认标签，并从 [Docker Hub 上的 percona/percona-xtrabackup](https://hub.docker.com/r/percona/percona-xtrabackup) 下载最新的镜像。此映像可能属于与您的预期不同的系列或版本，因为最新的映像会随时间而变化。如果您使用的是 8.4 之前的 Percona  XtraBackup 版本，请使用标签以确保您使用的 Percona Server for MySQL 和 Percona XtraBackup [版本兼容](https://docs.percona.com/percona-xtrabackup/8.4/server-backup-version-comparison.html)。

Percona Server for MySQL 和 Percona XtraBackup 的 CPU 架构或平台应该是相同的。如果要使用其他平台，可以添加以下命令：

| 平台                  | 描述                               |
| --------------------- | ---------------------------------- |
| –platform linux/amd64 | 在 AMD64 计算机上运行 AMD64 平台。 |
| –platform linux/arm64 | 在 ARM64 计算机上运行 ARM64 平台。 |

可以运行 Docker ARM64 版本的 Percona XtraBackup。使用 `8.4-aarch64` 标签而不是 `8.4` 。

### 将 Percona XtraBackup 容器连接到 Percona Server 容器

建议在 Docker 命令中使用 `–-user root` 选项。运行 Docker 容器示例

```bash
$ docker run --name pxb --volumes-from psmysql -v backupvol:/backup_84 -it --user root percona/percona-xtrabackup:8.4 /bin/bash -c "xtrabackup --backup --datadir=/var/lib/mysql/ --target-dir=/backup_84 --user=root --password; xtrabackup --prepare --target-dir=/backup_84"
```

系统将提示您输入密码。在我们的示例中，密码是 `secret`。

```bash
2024-10-07T13:55:47.640100-00:00 0 [Note] [MY-011825] [Xtrabackup] recognized server arguments: --datadir=/var/lib/mysql/
2024-10-07T13:55:47.641887-00:00 0 [Note] [MY-011825] [Xtrabackup] recognized client arguments: --backup=1 --target-dir=/backup_84 --user=root --password
Enter password:
```

在此预期输出示例中，提供备份日志的第一部分和最后一部分，并使用省略号而不是整个备份日志。

```bash
xtrabackup version 8.4.0-1 based on MySQL server 8.4.0 Linux (x86_64) (revision id: 3792f907)
2024-10-07T13:55:51.255518-00:00 0 [Note] [MY-011825] [Xtrabackup] perl binary not found. Skipping the version check
2024-10-07T13:55:51.256080-00:00 0 [Note] [MY-011825] [Xtrabackup] Connecting to MySQL server host: localhost, user: root, password: set, port: not set, socket: not set
2024-10-07T13:55:51.270222-00:00 0 [Note] [MY-011825] [Xtrabackup] Using server version 8.4.0-1
2024-10-07T13:55:51.272839-00:00 0 [Note] [MY-011825] [Xtrabackup] Executing LOCK TABLES FOR BACKUP

...

2024-10-07T13:55:55.550829-00:00 0 [Note] [MY-011825] [Xtrabackup] completed OK!
```

该命令从 `percona/percona-xtrabackup:8.4` 镜像运行一个 Docker 容器 `pxb` 并挂载两个卷：一个来自另一个名为 `psmysql` 的容器，其中包含 Percona Server 数据目录，另一个名为 `backupvol`，用于存储备份文件。该命令还将用户设置为 root 并提示用户输入密码。

然后，该命令执行两个步骤：

- 运行带有 `--backup` 选项的 `xtrabackup`，将数据文件从 `/var/lib/mysql/` 复制到 `/backup_8034`
- 使用 `--prepare` 选项运行 `xtrabackup` 以应用日志文件并使备份一致并准备好进行还原

可以使用 `docker container logs <container-name>` 命令检查 Xtrabackup 日志。

例如：

```bash
docker container logs pxb
```

## 恢复备份

以下步骤描述了如何将备份还原到另一个 Percona Server 容器并检查数据是否可用。

创建另一个 Docker 卷

```bash
docker volume create myvol2
```

运行另一个 Percona Server 容器以便将备份恢复到此处。

| 选项     | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| `--name` | 为容器提供名称。如果不使用此选项，Docker 会添加一个随机名称。 |
| `-d`     | 分离容器。容器在后台运行。                                   |
| `-e`     | 添加环境变量。此示例添加 `MYSQL_ROOT_PASSWORD` 环境变量。如果未添加环境变量，则实例拒绝初始化。如果需要，请选择更安全的密码。 |
| `myvol2` | 指示数据库的持久性存储。                                     |
| `8.4`    | 使用此标签指定特定版本。                                     |

必须提供至少一个环境变量才能访问数据库，例如 `MYSQL_ROOT_PASSWORD`、`MYSQL_DATABASE`、`MYSQL_USER` 和 `MYSQL_PASSWORD`，否则实例拒绝初始化。

在本文档中，使用 `8.4` 标签。在 Docker 中，标签是分配给镜像的标签。标签用于维护映像的不同版本。如果没有添加标签，Docker 将使用 `latest` 作为默认标签，并从 [Docker Hub 上的 percona/percona-server] 下载最新的镜像。

要将 Docker 卷用于数据库的持久性存储，请指定数据库在容器内存储数据的路径，通常为 `/var/lib/mysql`。

运行 Docker 容器示例

```bash
$ docker run -d -p 3307:3306 --name psmysql2 -e MYSQL_ROOT_PASSWORD=secret -v myvol2:/var/lib/mysql percona/percona-server:8.4
```

停止 `psmysql2` 容器

```bash
$ docker stop psmysql2
```

删除 `myvol2` 中所有创建的文件，以允许 xtrabackup 将数据恢复到 `myvol2`

`--rm` 选项会在容器退出后自动删除从 percona/percona-xtrabackup:8.0.34 镜像创建的临时容器。

```bash
$ docker run --volumes-from psmysql2 -v backupvol:/backup_84 -it --rm --user root percona/percona-xtrabackup:8.4 /bin/bash -c "rm -rf /var/lib/mysql/*"
```

如果命令成功执行，则预期输出为空。

将 `psmysql` 的备份从 `backupvol` 还原到新的 `psmysql2` 实例。

```bash
$ docker run --platform linux/amd64 --volumes-from psmysql2 -v backupvol:/backup_84 -it --rm --user root percona/percona-xtrabackup:8.4 /bin/bash -c "xtrabackup --copy-back --datadir=/var/lib/mysql/ --target-dir=/backup_84" 
```

This command restores the backup files from the `backup_8034` volume to the `psmysql2` container. It uses the `percona/percona-xtrabackup:8.0.34` image to run a temporary container with root privileges. It executes the xtrabackup tool with the `--copy-back` option, which copies the files from the `backup_8034` volume to the /`var/lib/mysql/` directory in the `psmysql2` container. The command uses –rm option to delete the temporary container after it exits.
此命令将备份文件从 `backup_8034` 卷还原到 `psmysql2` 容器。它使用 `percona/percona-xtrabackup:8.0.34` 镜像来运行具有 root 权限的临时容器。它使用 `--copy-back` 选项执行 xtrabackup 工具，该工具将文件从 `backup_8034` 卷复制到 `psmysql2` 容器中的 /`var/lib/mysql/` 目录。该命令使用 `--rm` 选项在临时容器退出后将其删除。

### 验证备份

假设您使用 `employees` 表备份了 `mydb` 数据库。验证步骤可能因您的数据集而异。

将 `myvol2` 中文件的所有者从 `root` 更改为 `mysql`

为避免在运行 `psmysql2` 容器时出现权限问题，需要更改所有者，因为文件是由 `root` 用户恢复的，`并且 psmysql2` 将使用 `mysql` 用户。

```bash
$ docker run --volumes-from psmysql2 -v backupvol:/backup_84 -it --rm --user root percona/percona-xtrabackup:8.4 /bin/bash -c "chown -R mysql:mysql /var/lib/mysql/" 
```

如果命令成功执行，则预期输出为空。

启动 `psmysql2` 容器

```bash
$ docker start psmysql2
```

连接到数据库实例。

对于此示例，有以下选项：

| 选项       | 描述                   |
| ---------- | ---------------------- |
| `-it`      | 与容器交互并成为伪终端 |
| `psmysql2` | 正在运行的容器名称     |
| `mysql`    | 连接到数据库实例       |
| `-u`       | 指定用于连接的用户帐户 |
| `-p`       | 连接时使用此密码       |

连接到数据库实例示例

```bash
$ docker exec -it psmysql2 mysql -uroot -p
```

系统将提示您输入密码，该密码是 `secret`。

```bash
Enter password:
```

检查数据库列表，确保备份的 `mydb` 数据库在列表中。

```mysql
mysql> show databases; 
```

使用 `mydb` 数据库。

```mysql
mysql> use mydb; 
```

检查表是否包含数据

```mysql
mysql> SELECT * FROM employees; 
```

