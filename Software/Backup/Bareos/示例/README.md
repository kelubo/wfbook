# Bareos 配置文件示例

## 网络拓扑

```
192.168.1.0/24 网络                    172.16.0.0/24 网络
┌─────────────────────────────┐        ┌─────────────────────────────┐
│  192.168.1.10 (Director)   │        │  172.16.0.11 (Storage)     │
│  - 管理端，统一管理两个网络  │        │  - 存储服务器               │
├─────────────────────────────┤        ├─────────────────────────────┤
│  192.168.1.11 (Storage)    │        │  172.16.0.20 (Client)      │
│  - 存储服务器               │        │  172.16.0.21 (Client)      │
├─────────────────────────────┤        │  172.16.0.22 (Client)      │
│  192.168.1.20 (Client)     │        └─────────────────────────────┘
│  192.168.1.21 (Client)     │
│  192.168.1.22 (Client)     │
└─────────────────────────────┘
              │
              └──────────────┬──────────────┘
                             │
                       网络相通
```

## 配置文件列表

### Director 配置 (192.168.1.10)
- `bareos-dir.conf` - 主管理配置文件，包含所有客户端、存储、作业定义

### Storage 配置
- `bareos-sd-192.168.1.11.conf` - 192.168.1.11 存储服务器配置
- `bareos-sd-172.16.0.11.conf` - 172.16.0.11 存储服务器配置

### Client 配置 (192.168.1.0/24)
- `bareos-fd-192.168.1.20.conf` - 客户端 192.168.1.20
- `bareos-fd-192.168.1.21.conf` - 客户端 192.168.1.21
- `bareos-fd-192.168.1.22.conf` - 客户端 192.168.1.22

### Client 配置 (172.16.0.0/24)
- `bareos-fd-172.16.0.20.conf` - 客户端 172.16.0.20
- `bareos-fd-172.16.0.21.conf` - 客户端 172.16.0.21
- `bareos-fd-172.16.0.22.conf` - 客户端 172.16.0.22

### Console 配置
- `bconsole.conf` - 控制台配置文件

## 备份策略

### 备份流向
- **192.168.1.20-22** → 备份到 **192.168.1.11** (同网段存储)
- **172.16.0.20-22** → 备份到 **172.16.0.11** (同网段存储)

### 备份计划
- **每周日 23:00** - 全量备份 (Full)
- **每周二至周五 23:00** - 差异备份 (Differential)
- **每周一至周六 23:00** - 增量备份 (Incremental)

### 存储类型
每个 Storage 服务器配置了以下设备：

| 存储类型 | 设备名称 | 介质类型 | 容量 | 用途 | 保留时间 |
|---------|---------|---------|------|------|---------|
| 磁盘增量 | `FileStorage-xxx-Inc` | `File-Inc` | - | 日常增量备份 | 14天 |
| 磁盘全量 | `FileStorage-xxx-Full` | `File-Full` | - | 每周全量备份 | 30天 |
| DDS4磁带 | `Tape-DDS4-xxx` | `Tape-DDS4` | 20GB | 小型重要数据归档 | 180天 |
| LTO5磁带 | `Tape-LTO5-xxx` | `Tape-LTO5` | 1.5TB | 大型数据归档 | 365天 |
| LTO5磁带库 | `Tape-LTO5-Changer-xxx` | `Tape-LTO5-Changer` | 1.5TB | 自动化大规模归档 | 730天 |
| RDX | `RDX-xxx` | `RDX` | 1TB | 可移动/异地归档 | 90天 |

## 端口配置

| 服务 | 端口 | 说明 |
|------|------|------|
| Director | 9101 | 管理端口 |
| File Daemon | 9102 | 客户端端口 |
| Storage Daemon | 9103 | 存储端口 |

## 数据库备份

### 支持的数据库
- MySQL
- PostgreSQL

### 数据库备份策略

| 数据库 | 文件集名称 | 备份级别 | 存储类型 | 保留时间 |
|--------|-----------|---------|---------|---------|
| MySQL | `MySQL-Backup` | Full | 磁盘/磁带库 | 30天/730天 |
| PostgreSQL | `PostgreSQL-Backup` | Full | 磁盘/磁带库 | 30天/730天 |
| MySQL+PG | `MySQL-PostgreSQL-Backup` | Full | 磁盘 | 30天 |

### 数据库备份作业列表

#### MySQL 备份作业
- `Backup-{client}-MySQL-Disk` - MySQL磁盘全量备份
- `Backup-{client}-MySQL-Changer` - MySQL磁带库归档备份

#### PostgreSQL 备份作业
- `Backup-{client}-PostgreSQL-Disk` - PostgreSQL磁盘全量备份
- `Backup-{client}-PostgreSQL-Changer` - PostgreSQL磁带库归档备份

#### 组合备份作业
- `Backup-{client}-DB-Combined` - MySQL+PostgreSQL组合备份

### 客户端数据库备份脚本配置

在客户端服务器上创建数据库备份脚本，将备份文件输出到 `/var/lib/mysql/backup` 或 `/var/lib/pgsql/backup` 目录。

#### MySQL 备份脚本 (`/etc/bareos/scripts/mysql_backup.sh`)

```bash
#!/bin/bash
# MySQL数据库备份脚本

MYSQL_USER="backup"
MYSQL_PASSWORD="backup_password"
MYSQL_HOST="localhost"
BACKUP_DIR="/var/lib/mysql/backup"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份所有数据库
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST --all-databases --single-transaction | gzip > $BACKUP_DIR/mysql_all_databases_$DATE.sql.gz

# 备份单个数据库（可选）
# mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST --databases db1 db2 | gzip > $BACKUP_DIR/mysql_db1_db2_$DATE.sql.gz

# 清理7天前的备份
find $BACKUP_DIR -name "mysql_*.sql.gz" -mtime +7 -delete

exit 0
```

#### PostgreSQL 备份脚本 (`/etc/bareos/scripts/postgresql_backup.sh`)

```bash
#!/bin/bash
# PostgreSQL数据库备份脚本

PG_USER="postgres"
PG_HOST="localhost"
BACKUP_DIR="/var/lib/pgsql/backup"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

# 获取所有数据库列表
DATABASES=$(psql -U $PG_USER -h $PG_HOST -l -t | cut -d'|' -f1 | sed -e 's/ //g' | grep -v '^$' | grep -v 'template')

# 备份所有数据库
for db in $DATABASES; do
    pg_dump -U $PG_USER -h $PG_HOST -F c $db > $BACKUP_DIR/postgresql_${db}_${DATE}.dump
    gzip $BACKUP_DIR/postgresql_${db}_${DATE}.dump
done

# 备份全局对象（角色、表空间等）
pg_dumpall -U $PG_USER -h $PG_HOST -g | gzip > $BACKUP_DIR/postgresql_global_$DATE.sql.gz

# 清理7天前的备份
find $BACKUP_DIR -name "postgresql_*.dump.gz" -mtime +7 -delete
find $BACKUP_DIR -name "postgresql_global_*.sql.gz" -mtime +7 -delete

exit 0
```

#### 设置脚本权限

```bash
chmod +x /etc/bareos/scripts/mysql_backup.sh
chmod +x /etc/bareos/scripts/postgresql_backup.sh
chown bareos:bareos /etc/bareos/scripts/*.sh
```

#### 在客户端配置中添加前置作业脚本

编辑 `bareos-fd.conf`，添加以下配置：

```
FileDaemon {
  Name = bareos-fd
  FDport = 9102
  WorkingDirectory = "/var/lib/bareos"
  PidDirectory = "/var/run/bareos"
  Maximum Concurrent Jobs = 20
}

Director {
  Name = bareos-dir
  Password = "ClientPassword123"
}

Messages {
  Name = Standard
  director = bareos-dir = all, !skipped, !restored
  append = "/var/log/bareos/bareos-fd.log" = all, !skipped
}

# 数据库备份前置脚本
ClientRunBeforeJob = "/etc/bareos/scripts/mysql_backup.sh && /etc/bareos/scripts/postgresql_backup.sh"
```

### MySQL 数据库用户配置

```sql
-- 创建备份用户
CREATE USER 'backup'@'localhost' IDENTIFIED BY 'backup_password';

-- 授予备份权限
GRANT SELECT, SHOW VIEW, LOCK TABLES, RELOAD ON *.* TO 'backup'@'localhost';
GRANT PROCESS ON *.* TO 'backup'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;
```

### PostgreSQL 数据库用户配置

编辑 `/var/lib/pgsql/.pgpass` 文件：

```
localhost:5432:*:postgres:postgres_password
```

设置权限：

```bash
chmod 600 /var/lib/pgsql/.pgpass
chown postgres:postgres /var/lib/pgsql/.pgpass
```

## 安装步骤

### 1. 安装 Director (192.168.1.10)

```bash
# 安装 Bareos Director 和数据库
yum install bareos-director bareos-database-postgresql

# 初始化数据库
su - postgres -c "createdb bareos"
su - postgres -c "createuser bareos"
su - postgres -c "psql -c \"ALTER USER bareos WITH ENCRYPTED PASSWORD 'DatabasePassword123';\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE bareos TO bareos;\""

# 导入配置
cp bareos-dir.conf /etc/bareos/bareos-dir.conf

# 初始化 Bareos 数据库
su bareos -s /bin/bash -c "/usr/lib/bareos/scripts/create_bareos_database"
su bareos -s /bin/bash -c "/usr/lib/bareos/scripts/make_bareos_tables"
su bareos -s /bin/bash -c "/usr/lib/bareos/scripts/grant_bareos_privileges"

# 启动服务
systemctl start bareos-dir
systemctl enable bareos-dir
```

### 2. 安装 Storage (192.168.1.11 和 172.16.0.11)

每个 Storage 服务器配置了以下设备：
- **磁盘存储**：用于日常增量备份
- **磁带机**：用于全量备份和长期归档
- **磁带库**：用于自动化大规模归档
- **RDX**：用于可移动/异地归档

```bash
# 安装 Bareos Storage Daemon
yum install bareos-storage

# 创建磁盘备份目录
mkdir -p /backup/bareos-192/inc   # 增量备份目录
mkdir -p /backup/bareos-192/full  # 全量备份目录
mkdir -p /backup/bareos-192/rdx   # RDX备份目录

# 设置权限
chown bareos:bareos /backup/bareos-192 -R

# 配置磁带机
# 检查磁带机设备
ls -la /dev/st0
ls -la /dev/nst0

# 如果使用磁带库，可能需要安装 mt-st 工具
yum install mt-st

# 测试磁带机
mt -f /dev/st0 status

# 配置磁带库（如果使用）
# 检查SG设备
ls -la /dev/sg*

# 导入配置
# 192.168.1.11:
cp bareos-sd-192.168.1.11.conf /etc/bareos/bareos-sd.conf

# 172.16.0.11:
cp bareos-sd-172.16.0.11.conf /etc/bareos/bareos-sd.conf

# 启动服务
systemctl start bareos-sd
systemctl enable bareos-sd
```

### 3. 安装 File Daemon (所有客户端)

```bash
# 安装 Bareos File Daemon
yum install bareos-filedaemon

# 根据客户端 IP 导入对应的配置
# 例如 192.168.1.20:
cp bareos-fd-192.168.1.20.conf /etc/bareos/bareos-fd.conf

# 创建数据库备份脚本目录
mkdir -p /etc/bareos/scripts

# 复制数据库备份脚本（见上文）
# mysql_backup.sh 和 postgresql_backup.sh

# 创建数据库备份目录
mkdir -p /var/lib/mysql/backup
mkdir -p /var/lib/pgsql/backup
chown bareos:bareos /var/lib/mysql/backup /var/lib/pgsql/backup

# 启动服务
systemctl start bareos-fd
systemctl enable bareos-fd
```

### 4. 安装控制台

```bash
# 在 Director 服务器上安装控制台
yum install bareos-console

# 导入配置
cp bconsole.conf /etc/bareos/bconsole.conf

# 连接到 Director
bconsole
```

## 验证配置

```bash
# 在 Director 服务器上测试配置
su bareos -s /bin/sh -c "/usr/sbin/bareos-dir -t"

# 在 Storage 服务器上测试配置
su bareos -s /bin/sh -c "/usr/sbin/bareos-sd -t"

# 在 Client 上测试配置
bareos-fd -t
```

## 常用命令

```bash
# 启动备份作业
bconsole
run job=Backup-192-168-1-20-Disk-Inc

# 启动数据库备份作业
run job=Backup-192-168-1-20-MySQL-Disk

# 查看作业状态
status jobs

# 查看存储状态
status storage

# 查看客户端状态
status client

# 列出所有作业
list jobs

# 列出文件集
list filesets

# 恢复文件
restore

# 查看数据库备份内容
list files jobid=123
```

## 磁带机规格说明

| 磁带类型 | 原生容量 | 压缩后容量 | 速度 | 接口 | 用途 |
|---------|---------|-----------|------|------|------|
| DDS4 | 20GB | 40GB | 3MB/s | SCSI/LVD | 小型重要数据归档 |
| LTO5 | 1.5TB | 3TB | 140MB/s | SAS/SCSI | 大型数据长期归档 |

## 注意事项

1. **密码安全**: 配置文件中的密码仅为示例，请在生产环境中使用强密码
2. **防火墙**: 确保防火墙允许端口 9101, 9102, 9103 的通信
3. **网络连通性**: 确保 Director (192.168.1.10) 可以访问所有存储和客户端
4. **存储空间**: 确保存储服务器有足够的磁盘空间
5. **数据库**: Director 服务器需要安装 PostgreSQL 数据库
6. **数据库备份**: 确保客户端上已安装 mysqldump 和 pg_dump 工具
7. **数据库用户**: 确保备份用户具有足够的权限
8. **备份脚本**: 确保备份脚本可执行且具有正确的权限
9. **磁带库**: 使用磁带库时需要安装 mt-st 工具并配置 SG 设备
10. **RDX**: 使用 RDX 时需要确保设备已正确挂载