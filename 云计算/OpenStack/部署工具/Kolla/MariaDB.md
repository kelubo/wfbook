# MariaDB

[TOC]       

## 备份

Kolla Ansible can facilitate either full or incremental backups of data hosted in MariaDB.

Kolla Ansible 可以促进对 MariaDB 中托管的数据进行完整或增量备份。它使用 Mariabackup 实现了这一点，Mariabackup 是一种旨在实现“热备份”的工具 - 这种方法意味着可以在数据库或云没有任何停机的情况下进行一致的备份。

> 注意：
>
> By default, backups will be performed on the first node in your Galera cluster or on the MariaDB node itself if you just have the one. Backup files are saved to a dedicated Docker volume - `mariadb_backup` - and it’s the contents of this that you should target for transferring backups elsewhere.
> 默认情况下，备份将在Galera集群中的第一个节点上执行，或者在MariaDB节点本身上执行，如果你只有一个节点。备份文件保存到专用的 Docker 卷中 - `mariadb_backup` - 在将备份传输到其他位置时，应以此内容为目标。

### 启用备份功能

为了使备份正常工作，需要对 MariaDB 进行一些重新配置 - 这是为备份客户端启用适当的权限，并创建一个额外的数据库以存储备份信息。

首先，通过 `globals.yml` 启用备份：

```yaml
enable_mariabackup: "yes"
```

然后，启动 MariaDB 的重新配置：

```bash
kolla-ansible -i INVENTORY reconfigure -t mariadb
```

Once that has run successfully, you should then be able to take full and incremental backups as described below.
成功运行后，应该能够进行完整备份和增量备份，如下所述。

### Backup Procedure 备份程序

若要执行完整备份，请运行以下命令：

```bash
kolla-ansible -i INVENTORY mariadb_backup
```

Or to perform an incremental backup:
或者要执行增量备份：

```
kolla-ansible -i INVENTORY mariadb_backup --incremental
```

Kolla doesn’t currently manage the scheduling of these backups, so you’ll need to configure an appropriate scheduler (i.e cron) to run these commands on your behalf should you require regular snapshots of your data. A suggested schedule would be:
Kolla 目前不管理这些备份的计划，因此，如果您需要定期获取数据快照，您需要配置适当的计划程序（即 cron）来代表您运行这些命令。建议的时间表是：

- Daily full, retained for two weeks
  每日饱满，保留两周
- Hourly incremental, retained for one day
  每小时递增，保留一天

Backups are performed on your behalf on the designated database node using permissions defined during the configuration step; no password is required to invoke these commands.
使用在配置步骤中定义的权限代表您在指定的数据库节点上执行备份;调用这些命令不需要密码。

Furthermore, backup actions can be triggered from a node with a minimal installation of Kolla Ansible, specifically one which doesn’t require a copy of `passwords.yml`.  This is of note if you’re looking to implement automated backups scheduled via a cron job.
此外，可以从安装最少 Kolla Ansible 的节点触发备份操作，特别是不需要 `passwords.yml` .如果您希望通过 cron 作业实现计划的自动备份，这一点很重要。

## Restoring backups 恢复备份 ¶

Owing to the way in which Mariabackup performs hot backups, there are some steps that must be performed in order to prepare your data before it can be copied into place for use by MariaDB. This process is currently manual, but the Kolla Mariabackup image includes the tooling necessary to successfully prepare backups. Two examples are given below.
由于Mariabackup执行热备份的方式，必须执行一些步骤才能准备数据，然后才能将其复制到MariaDB使用。此过程目前是手动的，但 Kolla Mariabackup 映像包含成功准备备份所需的工具。下面给出了两个例子。

### Full 完整 ¶

For a full backup, start a new container using the Mariabackup image with the following options on the first database node:
对于完整备份，请在第一个数据库节点上使用具有以下选项的 Mariabackup 映像启动新容器：

```
docker run --rm -it --volumes-from mariadb --name dbrestore \
   --volume mariadb_backup:/backup \
   quay.io/openstack.kolla/centos-source-mariadb-server:master \
   /bin/bash
 
cd /backup
 
rm -rf /backup/restore
 
mkdir -p /backup/restore/full
 
gunzip mysqlbackup-04-10-2018.qp.xbc.xbs.gz
 
mbstream -x -C /backup/restore/full/ < mysqlbackup-04-10-2018.qp.xbc.xbs
 
mariabackup --prepare --target-dir /backup/restore/full
```

Stop the MariaDB instance on all nodes:
停止所有节点上的 MariaDB 实例：

```
kolla-ansible -i multinode stop -t mariadb --yes-i-really-really-mean-it
```

Delete the old data files (or move them elsewhere), and copy the backup into place, again on the first node:
删除旧数据文件（或将它们移动到其他位置），并在第一个节点上再次将备份复制到位：

```
docker run --rm -it --volumes-from mariadb --name dbrestore \
   --volume mariadb_backup:/backup \
   quay.io/openstack.kolla/centos-source-mariadb-server:master \
   /bin/bash
 
rm -rf /var/lib/mysql/*
 
rm -rf /var/lib/mysql/\.[^\.]*
 
mariabackup --copy-back --target-dir /backup/restore/full
```

Then you can restart MariaDB with the restored data in place.
然后，您可以在还原的数据就位的情况下重新启动MariaDB。

For single node deployments:
对于单节点部署：

```
docker start mariadb
docker logs mariadb
81004 15:48:27 mysqld_safe WSREP: Running position recovery with --log_error='/var/lib/mysql//wsrep_recovery.BDTAm8' --pid-file='/var/lib/mysql//scratch-recover.pid'
181004 15:48:30 mysqld_safe WSREP: Recovered position 9388319e-c7bd-11e8-b2ce-6e9ec70d9926:58
```

For multinode deployment restores, a MariaDB recovery role should be run, pointing to the first node of the cluster:
对于多节点部署还原，应运行 MariaDB 恢复角色，指向集群的第一个节点：

```
kolla-ansible -i multinode mariadb_recovery -e mariadb_recover_inventory_name=controller1
```

The above procedure is valid also for a disaster recovery scenario. In such case, first copy MariaDB backup file from the external source into `mariadb_backup` volume on the first node of the cluster. From there, use the same steps as mentioned in the procedure above.
上述过程也适用于灾难恢复方案。在这种情况下，首先将 MariaDB 备份文件从外部源复制到 `mariadb_backup` 集群第一个节点上的卷中。从那里，使用上述过程中提到的相同步骤。

### Incremental 增量 ¶

This starts off similar to the full backup restore procedure above, but we must apply the logs from the incremental backups first of all before doing the final preparation required prior to restore. In the example below, I have a full backup - `mysqlbackup-06-11-2018-1541505206.qp.xbc.xbs`, and an incremental backup, `incremental-11-mysqlbackup-06-11-2018-1541505223.qp.xbc.xbs`.
这与上面的完整备份还原过程类似，但我们必须首先应用增量备份中的日志，然后再进行还原前所需的最后准备工作。在下面的示例中，我有一个完整备份 - `mysqlbackup-06-11-2018-1541505206.qp.xbc.xbs` 和一个增量备份 `incremental-11-mysqlbackup-06-11-2018-1541505223.qp.xbc.xbs` 。

```
docker run --rm -it --volumes-from mariadb --name dbrestore \
   --volume mariadb_backup:/backup --tmpfs /backup/restore \
   quay.io/openstack.kolla/centos-source-mariadb-server:master \
   /bin/bash
 
cd /backup
 
rm -rf /backup/restore
 
mkdir -p /backup/restore/full
 
mkdir -p /backup/restore/inc
 
gunzip mysqlbackup-06-11-2018-1541505206.qp.xbc.xbs.gz
 
gunzip incremental-11-mysqlbackup-06-11-2018-1541505223.qp.xbc.xbs.gz
 
mbstream -x -C /backup/restore/full/ < mysqlbackup-06-11-2018-1541505206.qp.xbc.xbs
 
mbstream -x -C /backup/restore/inc < incremental-11-mysqlbackup-06-11-2018-1541505223.qp.xbc.xbs
 
mariabackup --prepare --target-dir /backup/restore/full
 
mariabackup --prepare --incremental-dir=/backup/restore/inc --target-dir /backup/restore/full
```

At this point the backup is prepared and ready to be copied back into place, as per the previous example.
此时，备份已准备就绪，可以复制回原位，如上例所示。