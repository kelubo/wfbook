# MySQL

[TOC]

## 概述

一个关系型数据库管理系统。由瑞典 MySQL AB 公司开发。2008 年被 SUN 收购，目前属于 Oracle 公司（2010.4.20，Oracle 收购 SUN）。

是一种关联数据库管理系统，关联数据库将数据保存在不同的表中，而不是将所有数据放在一个大仓库内，这样增加了速度并提高了灵活性。

MySQL 之父 Michael Monty Widenius 。

MySQL 支持大型数据库，支持 5000 万条记录的数据仓库，32 位系统表文件最大可支持 4GB，64 位系统支持最大的表文件为8TB。

MySQL  软件采用了双授权政策，分为以下版本：

* 社区版          Community
* 企业版          Enterprise
* 集群版          MySQL Cluster
* 高级集群版  MySQL Cluster CGE

基本信息：

* 端口号	3306

特性：

* 使用 C 和 C++ 编写，并使用了多种编译器进行测试，保证了源代码的可移植性。
* 支持 AIX、FreeBSD、HP-UX、Linux、Mac OS、Novell Netware、OpenBSD、OS/2 Wrap、Solaris、Windows 等多种操作系统。
* 为多种编程语言（C、C++、Python、Java、Perl、PHP、Eiffel、Ruby,.NET和 Tcl 等）提供了 API 。
* 支持多线程，充分利用 CPU 资源。
* 优化的 SQL 查询算法，有效地提高查询速度。
* 既能作为一个单独的应用程序应用在客户端服务器网络环境中，也能够作为一个库而嵌入到其他的软件中。
* 提供多语言支持，常见的编码如中文的 GB2312、BIG5，日文的 Shift_JIS 等都可以用作数据表名和数据列名。
* 提供 TCP/IP、ODBC 和 JDBC 等多种数据库连接途径。
* 提供用于管理、检查、优化数据库操作的管理工具。
* 支持大型的数据库。可以处理拥有上千万条记录的大型数据库。
* 支持多种存储引擎。
* 使用标准的 SQL 数据语言形式。
* 是可以定制的，采用了 GPL 协议。
* 在线 DDL/更改功能，数据架构支持动态应用程序和开发人员灵活性（5.6新增）
* 复制全局事务标识，可支持自我修复式集群（5.6新增）
* 复制无崩溃从机，可提高可用性（5.6新增）
* 复制多线程从机，可提高性能（5.6新增）
* 3倍更快的性能（5.7新增）
* 新的优化器（5.7新增）
* 原生 JSON （5.7新增）
* 多源复制（5.7新增）
* GIS 的空间扩展（5.7新增）

表结构:

- **表头(header): **每一列的名称;
- **列(col): **具有相同数据类型的数据的集合;
- **行(row):** 每一行用来描述某条记录的具体信息;
- **值(value): **行的具体信息, 每个值必须与该列的数据类型相同;
- **键(key)**: 键的值在当前列中具有唯一性。

## 安装

### CentOS

推荐使用 RPM 包来安装 MySQL 。

- **MySQL**               - MySQL 服务器。如果不是只想连接运行在另一台机器上的 MySQL 服务器，请选择该选项。
- **MySQL-client**   - MySQL 客户端程序，用于连接并操作 MySQL 服务器。
- **MySQL-devel**   - 库和包含文件，如果要编译其它如 Perl 模块等 MySQL 客户端，则需要安装该 RPM 包。
- **MySQL-shared** - 包含某些语言和应用程序使用 MySQL，需要动态装载的共享库 (libmysqlclient.so*) 。
- **MySQL-bench**  - MySQL 数据库服务器的基准和性能测试工具。

```bash
# 检测系统是否自带安装 MySQL
rpm -qa | grep mysql
# 如果系统有安装，可以选择进行卸载
rpm -e mysql
# 普通删除模式
rpm -e --nodeps mysql
# 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除

# 配置软件源
# CentOS 7
yum install https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
# CentOS 8
yum install https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm

# 选择版本
# CentOS 8 不需执行此项。
yum-config-manager --disable mysql80-community && yum-config-manager --enable  mysql57-community
yum makecache && yum update

#安装MySQL,启动。
#CentOS 7
yum install -y mysql-community-server && systemctl start mysqld && systemctl enable mysqld
#CentOS 8
yum install -y mysql-server && systemctl start mysqld && systemctl enable mysqld              

#获取临时密码初始化
#CentOS 8 不需执行此项。
grep root@localhost /var/log/mysqld.log | awk -F: '{print $4}'                

#执行初始化。
mysql_secure_installation

#修改数据文件存储路径
systemctl stop mysqld

sed -i "s#datadir=/var/lib/mysql#datadir=/data/mysql#g" /etc/my.cnf

mkdir -p /data/mysql && chown -R mysql:mysql /data/mysql && mv /var/lib/mysql/* /data/mysql/

systemctl start mysqld
```

### Debian



### Docker

1. 拉取官方镜像

   ```bash
   docker pull mysql       # 拉取最新版mysql镜像
   ```

2. 运行容器

   ```bash
   docker run -p 3306:3306 --name mysql \
   -v /usr/local/docker/mysql/conf:/etc/mysql/conf.d \
   -v /usr/local/docker/mysql/logs:/var/log/mysql \
   -v /usr/local/docker/mysql/data:/var/lib/mysql \
   -e MYSQL_ROOT_PASSWORD=123456 \
   -d mysql
   
   # -e：配置信息，配置 root 用户的登陆密码
   ```

3. 检查容器是否正确运行

   ```bash
   docker container ls
   ```

### Windows

双击 setup.exe 文件，接下来你需要安装默认的配置点击"next"即可，默认情况下安装信息会在C:\mysql目录中。

接下来可以通过"开始" =》在搜索框中输入 " cmd" 命令 =》 在命令提示符上切换到 C:\mysql\bin 目录，并输入一下命令：

```bash
mysqld.exe --console
```

如果安装成功以上命令将输出一些MySQL启动及InnoDB信息。

### Other

- 防火墙

  ```shell
  # 开放端口：
  systemctl status firewalld
  firewall-cmd  --zone=public --add-port=3306/tcp -permanent
  firewall-cmd  --reload
  # 关闭防火墙：
  systemctl stop firewalld
  ```

- 其他启动及停止服务的方式

  ```bash
  # 启动
  safe_mysqld &
  
  # 关闭
mysqladmin -u root -p shutdown
  Enter password: ******
  ```
```
  
- 需要进入docker本地客户端设置远程访问账号

  ```shell
  docker exec -it mysql bash
  mysql -uroot -p123456
  mysql> grant all privileges on *.* to root@'%' identified by "password";
```

  原理：

  ```bash
  # mysql使用mysql数据库中的user表来管理权限，修改user表就可以修改权限（只有root账号可以修改）
  
  mysql> use mysql;
  Database changed
  
  mysql> select host,user,password from user;
  +--------------+------+-------------------------------------------+
  | host                    | user      | password                                                                 |
  +--------------+------+-------------------------------------------+
  | localhost              | root     | *A731AEBFB621E354CD41BAF207D884A609E81F5E      |
  | 192.168.1.1            | root     | *A731AEBFB621E354CD41BAF207D884A609E81F5E      |
  +--------------+------+-------------------------------------------+
  2 rows in set (0.00 sec)
  
  mysql> grant all privileges  on *.* to root@'%' identified by "password";
  Query OK, 0 rows affected (0.00 sec)
  
  mysql> flush privileges;
  Query OK, 0 rows affected (0.00 sec)
  
  mysql> select host,user,password from user;
  +--------------+------+-------------------------------------------+
  | host                    | user      | password                                                                 |
  +--------------+------+-------------------------------------------+
  | localhost              | root      | *A731AEBFB621E354CD41BAF207D884A609E81F5E     |
  | 192.168.1.1            | root      | *A731AEBFB621E354CD41BAF207D884A609E81F5E     |
  | %                       | root      | *A731AEBFB621E354CD41BAF207D884A609E81F5E     |
  +--------------+------+-------------------------------------------+
  3 rows in set (0.00 sec)
  ```

## 验证 MySQL 安装

使用 mysqladmin 命令检查服务器的版本。

```bash
mysqladmin --version
```

 linux上该命令将输出以下结果：

```bash
mysqladmin  Ver 8.23 Distrib 5.0.9-0, for redhat-linux-gnu on i386
```

## 存储引擎

存储引擎是对于数据库文件的一种存取机制，如何实现存储数据，如何为存储的数据建立索引以及如何更新，查询数据等技术实现的方法。

| 存储特性       | MyISAM | InnoDB | MEMORY |
| -------------- | ------ | ------ | ------ |
| 存储限制       | 有     | 64TB   | 有     |
| 事务安全       | 不支持 | 支持   | 不支持 |
| 锁机制         | 表锁   | 行锁   | 表锁   |
| B树索引        | 支持   | 支持   | 支持   |
| 哈希索引       | 不支持 | 不支持 | 支持   |
| 全文索引       | 支持   | 不支持 | 不支持 |
| 集群索引       | 不支持 | 支持   | 不支持 |
| 数据缓存       |        | 支持   | 支持   |
| 索引缓存       | 支持   | 支持   | 支持   |
| 数据可压缩     | 支持   | 不支持 | 不支持 |
| 空间使用       | 低     | 高     | N/A    |
| 内存使用       | 低     | 高     | 中等   |
| 批量插入的速度 | 高     | 低     | 高     |
| 支持外键       | 不支持 | 支持   | 不支持 |

* MyISAM

  MySQL 5.0 之前的默认数据库引擎，最为常用。拥有较高的插入，查询速度，但不支持事务。

* InnoDB

  事务型数据库的首选引擎，支持 ACID 事务，支持行级锁定，MySQL 5.5 起成为默认数据库引擎。

* BDB

  源自 Berkeley DB，事务型数据库的另一种选择，支持 Commit 和 Rollback 等其他事务特性。

* Memory

  所有数据置于内存的存储引擎，拥有极高的插入，更新和查询效率。但是会占用和数据量成正比的内存空间。并且其内容会在 MySQL 重新启动时丢失。

* Merge

  将一定数量的 MyISAM 表联合而成一个整体，在超大规模数据存储时很有用。

* Archive

  非常适合存储大量的独立的，作为历史记录的数据。因为它们不经常被读取。Archive 拥有高效的插入速度，但其对查询的支持相对较差。

* Federated

  将不同的 MySQL 服务器联合起来，逻辑上组成一个完整的数据库。非常适合分布式应用。

* Cluster / NDB

  高冗余的存储引擎，用多台数据机器联合提供服务以提高整体性能和安全性。适合数据量大，安全和性能要求高的应用。

* CSV

  逻辑上由逗号分割数据的存储引擎。会在数据库子目录里为每个数据表创建一个 .csv 文件。是一种普通文本文件，每个数据行占用一个文本行。CSV 存储引擎不支持索引。

* BlackHole

  黑洞引擎，写入的任何数据都会消失，一般用于记录 binlog 做复制的中继。

* EXAMPLE

  存储引擎是一个不做任何事情的存根引擎。它的目的是作为 MySQL 源代码中的一个例子，用来演示如何开始编写一个新存储引擎。同样，它的主要兴趣是对开发者。EXAMPLE  存储引擎不支持编索引。另外，MySQL 的存储引擎接口定义良好。有兴趣的开发者可以通过阅读文档编写自己的存储引擎。

查询默认存储引擎：

```mysql
show variables like '%storage_engine%';
```

## MySQL Client

```
mysql -h 主机名 -P 端口号 -u 用户名 -p
```

参数说明：

-  **-h** : 指定客户端所要登录的 MySQL 主机名, 登录本机(localhost 或 127.0.0.1)该参数可以省略。
-  **-u** : 登录的用户名。
-  **-p** : 告诉服务器将会使用一个密码来登录, 如果所要登录的用户名密码为空, 可以忽略此选项。
-  **-P** : 指定端口号, 如未修改过端口号，可以忽略此选项。

SQL 语句可以以 `;` 、`\g` 或 `\G` 结尾。

* `;` 或 `\g`     对应的输出水平显示。
* `\G`               对应的输出垂直显示。

## 用户相关设置

 MySQL 安装成功后，默认的root用户密码为空，使用以下命令来创建root用户的密码：

```bash
mysqladmin -u root password "new_password";
```

 添加 MySQL 用户，在 mysql 数据库中的 user 表添加新用户即可。

以下为添加用户的的实例，用户名为guest，密码为guest123，并授权用户可进行 SELECT, INSERT 和 UPDATE操作权限： 

```mysql
mysql -u root -p
Enter password:*******
mysql> use mysql;
Database changed

mysql> INSERT INTO user 
          (host, user, password, 
           select_priv, insert_priv, update_priv) 
           VALUES ('localhost', 'guest', 
           PASSWORD('guest123'), 'Y', 'Y', 'Y');
Query OK, 1 row affected (0.20 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 1 row affected (0.01 sec)

mysql> SELECT host, user, password FROM user WHERE user = 'guest';
+-----------+---------+------------------+
| host      | user    | password         |
+-----------+---------+------------------+
| localhost | guest | 6f8c114b58f2ce9e |
+-----------+---------+------------------+
1 row in set (0.00 sec)
```

 在添加用户时，注意使用MySQL提供的 PASSWORD() 函数来对密码进行加密。 

 **注意：**

* 在 MySQL5.7 中 user 表的 password 已换成了**authentication_string**。
* password() 加密函数已经在 8.0.11 中移除了，可以使用 MD5() 函数代替。
* 需要执行 **FLUSH PRIVILEGES** 语句。 这个命令执行后会重新载入授权表。 

可以在创建用户时，为用户指定权限，在对应的权限列中，在插入语句中设置为 'Y' 即可，用户权限列表如下：

- Select_priv

- Insert_priv

- Update_priv

- Delete_priv

- Create_priv

- Drop_priv

- Reload_priv

- Shutdown_priv

- Process_priv

- File_priv

- Grant_priv

- References_priv

- Index_priv

- Alter_priv

  

另外一种添加用户的方法为通过SQL的 GRANT  命令，以下命令会给指定数据库TUTORIALS添加用户 zara ，密码为 zara123 。

```mysql
root@host# mysql -u root -p
Enter password:*******
mysql> use mysql;
Database changed

mysql> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP
    -> ON TUTORIALS.*
    -> TO 'zara'@'localhost'
    -> IDENTIFIED BY 'zara123';
```

 以上命令会在mysql数据库中的user表创建一条用户信息记录。 

## GUI Client

| 软件 | 厂商 | 网站 | 价格 | 许可 | 支持平台 |
|---|---|---|---|---|---|
| DBeaver |  |  |  |  | Windows,Mac,Linux |
| SQLyog | | ||||
| MySQL Query Browser | | ||||
| mysqldumper | | https://www.mysqldumper.de/ |||Web|
| Workbench | Oracle | https://dev.mysql.com/downloads/workbench/ | 免费 | GPL | Windows,Mac,Linux  |
| Navicat | PremiumSoft CyberTech Ltd. | http://www.navicat.com/en/products/navicat_mysql/mysql_overview.html | 30天试用版 | Commercial | Windows,Mac,Linux |
| Sequel Pro | The Sequel Pro Project | http://www.sequelpro.com | 免费 | GPL 2.0 | Mac OS X Tiger Universal Build |
| HeidiSQL | Ansgar Becker | http://www.heidisql.com | 免费 | GPL | Windows |
| phpMyAdmin | The phpMyAdmin Project | http://www.phpmyadmin.net/home_page | 免费 | GPL 2.0 | Windows,Mac,Linux |
| SQL Maestro MySQL Tools Family | SQL Maestro Group | http://www.sqlmaestro.com/products/mysql |  |  | Windows |
| SQLWave | Nerocode | http://www.nerocode.com | $99 | shareware | Windows |
| dbForge Studio | devart | http://www.devart.com/dbforge/mysql/studio |  |  | Windows |
| DBTools Manager |  | http://www.dbtools.com.br/EN/dbmanagepro |  |  | Windows |
| MyDB Stuido | H2LSoft,Inc. | http://www.mydb-studio.com | 免费 |  | Windows |
| MySQL Administrator |  |  |  | |  |

## CLI Client

* mysql client
* mysladmin tool
* mysqlshow tool

## MySQL 连接

### 使用mysql二进制方式连接

```bash
mysql -u root -p
Enter password:******
```

 退出 mysql> 命令提示窗口可以使用 exit 命令：

```sql
mysql> exit
Bye
```

### 使用 PHP 脚本连接 MySQL

 PHP 提供了 mysqli_connect() 函数来连接数据库。该函数有 6 个参数，在成功链接到 MySQL 后返回连接标识，失败返回 FALSE 。 

```php
mysqli_connect(host,username,password,dbname,port,socket);
```

**参数说明：**

| 参数       | 描述                                        |
| ---------- | ------------------------------------------- |
| *host*     | 可选。规定主机名或 IP 地址。                |
| *username* | 可选。规定 MySQL 用户名。                   |
| *password* | 可选。规定 MySQL 密码。                     |
| *dbname*   | 可选。规定默认使用的数据库。                |
| *port*     | 可选。规定尝试连接到 MySQL 服务器的端口号。 |
| *socket*   | 可选。规定 socket 或要使用的已命名 pipe。   |

 你可以使用 PHP 的 mysqli_close() 函数来断开与 MySQL 数据库的链接。该函数只有一个参数为 mysqli_connect() 函数创建连接成功后返回的 MySQL 连接标识符。

```
bool mysqli_close ( mysqli $link )
```

 本函数关闭指定的连接标识所关联的到 MySQL 服务器的非持久连接。如果没有指定 link_identifier，则关闭上一个打开的连接。

**提示：**通常不需要使用 mysqli_close()，因为已打开的非持久连接会在脚本执行完毕后自动关闭。

**实例**

```php
<?php
  $dbhost = 'localhost';  // mysql服务器主机地址
  $dbuser = 'root';       // mysql用户名
  $dbpass = '123456';     // mysql用户名密码
  $conn = mysqli_connect($dbhost, $dbuser, $dbpass);
  if(! $conn )
  {
     die('Could not connect: ' . mysqli_error());
  }
  echo '数据库连接成功！';
  mysqli_close($conn);
?>
```

## MySQL调优

### 警告

1. 假设要调整的数据库是为一个“典型”的 Web 网站服务的，优先考虑的是快速查询、良好的用户体验以及处理大量的流量。
2. 在对服务器进行优化之前，做好数据库备份！

### 1、 使用 InnoDB 存储引擎

 它们是如何利用物理内存的：

- MyISAM：仅在内存中保存索引。
- InnoDB：在内存中保存索引**和**数据。

结论：保存在内存的内容访问速度要比磁盘上的更快。

下面是如何在你的表上去转换存储引擎的命令：

```
ALTER TABLE table_name ENGINE=InnoDB;
```

*注意：你已经创建了所有合适的索引，对吗？为了更好的性能，创建索引永远是第一优先考虑的事情。*

### 2、 让 InnoDB 使用所有的内存

你可以在 `my.cnf` 文件中编辑你的 MySQL 配置。使用 `innodb_buffer_pool_size` 参数去配置在你的服务器上允许 InnoDB 使用物理内存数量。

对此（假设你的服务器*仅仅*运行 MySQL），公认的“经验法则”是设置为你的服务器物理内存的 80%。在保证操作系统不使用交换分区而正常运行所需要的足够内存之后 ，尽可能多地为 MySQL 分配物理内存。

因此，如果你的服务器物理内存是 32 GB，可以将那个参数设置为多达 25 GB。

```
innodb_buffer_pool_size = 25600M
```

*注意：（1）如果你的服务器内存较小并且小于 1 GB。为了适用本文的方法，你应该去升级你的服务器。 （2） 如果你的服务器内存特别大，比如，它有 200 GB，那么，根据一般常识，你也没有必要为操作系统保留多达 40 GB 的内存。 *

### 3、 让 InnoDB 多任务运行

如果服务器上的参数 `innodb_buffer_pool_size` 的配置是大于 1 GB，将根据参数 `innodb_buffer_pool_instances` 的设置， 将 InnoDB 的缓冲池划分为多个。

拥有多于一个的缓冲池的好处有：

> 在多线程同时访问缓冲池时可能会遇到瓶颈。你可以通过启用多缓冲池来最小化这种争用情况：

对于缓冲池数量的官方建议是：

> 为了实现最佳的效果，要综合考虑 `innodb_buffer_pool_instances` 和 `innodb_buffer_pool_size` 的设置，以确保每个实例至少有不小于 1 GB 的缓冲池。

因此，在我们的示例中，将参数 `innodb_buffer_pool_size` 设置为 25 GB 的拥有 32 GB 物理内存的服务器上。一个合适的设置为 25600M / 24 = 1.06 GB

```
innodb_buffer_pool_instances = 24
```

### 注意！

在修改了 `my.cnf` 文件后需要重启 MySQL 才能生效：

```
sudo service mysql restart
```

还有更多更科学的方法来优化这些参数，但是这几点可以作为一个通用准则来应用，将使你的 MySQL 服务器性能更好。

### 服务器物理硬件的优化
1、磁盘寻道能力（磁盘I/O）。使用RAID1+0磁盘阵列，不要尝试RAID5。
2、CPU选择运算能力强悍的CPU。
3、内存不要小于2GB，推荐使用4GB以上的物理内存。

### MySQL应采用编译方式安装
源码包的编译参数会默认以Debug模式生成二进制代码，而Debug模式给MySQL带来的性能损失是比较大的，所以编译准备安装的产品代码时，一定不要忘记使用--without-debug参数禁止Debug模式。如果把--with-mysqld-ldflags和--with-client-ld-flags两个编译参数设置为--all-static的话，可以告诉编译器以静态的方式编译，编译结果将得到最高的性能。使用静态编译和使用动态编译的代码相比，性能差距可能会达到5%至10%之多。

### MySQL配置文件

    [client]
    #password = your_passwd               #设置用户登录密码。登录时不再需要输入密码。
    port   = 3306                         #客户端端口号为3306
    socket  =/data/3306/mysql.sock
    default-character-set = utf8          #客户端字符集,(控制character_set_client、character_set_connection、character_set_results)
    
    [mysql]
    no-auto-rehash                        #关闭自动补全
    
    [mysqld]                              #包括了mysqld服务启动的参数，其中有MySQL的目录和文件，通信、网络、信息安全，内存管理、优化、查询缓存区，还有MySQL日志设置等。
    user    = mysql                       #mysql_safe脚本使用MySQL运行用户(编译时--user=mysql指定),推荐使用mysql用户。
    port    = 3306                        #MySQL服务运行时的端口号。建议更改默认端口,默认容易遭受攻击。
    socket  =/data/3306/mysql.sock        #socket文件是在Linux/Unix环境下特有的，用户在Linux/Unix环境下客户端连接可以不通过TCP/IP网络而直接使用unix socket连接MySQL。
    basedir = /application/mysql          #mysql程序所存放路径,常用于存放mysql启动、配置文件、日志等
    datadir = /data/3306/data             #MySQL数据存放文件(极其重要)
    character-set-server = utf8           #数据库和数据库表的默认字符集。(推荐utf8,以免导致乱码)
    log-error=/data/3306/mysql_xuliangwei.err     #mysql错误日志存放路径及名称(启动出现错误一定要看错误日志,百分之百都能通过错误日志排插解决。)
    pid-file=/data/3306/mysql_xuliangwei.pid      #MySQL_pid文件记录的是当前mysqld进程的pid，pid亦即ProcessID。
    skip-locking                                  #避免MySQL的外部锁定，减少出错几率，增强稳定性。
    skip-name-resolv                              #禁止MySQL对外部连接进行DNS解析，使用这一选项可以消除MySQL进行DNS解析的时候。
                                                  但是需要注意的是，如果开启该选项，则所有远程主机连接授权都要使用IP地址方式了，否则MySQL将无法正常处理连接请求！
    skip-networking                     #开启该选项可以彻底关闭MySQL的TCP/IP连接方式，如果Web服务器是以远程连接的方式访问MySQL数据库服务器的，则不要开启该选项，否则无法正常连接！
    open_files_limit    = 1024          #MySQLd能打开文件的最大个数,如果出现too mant openfiles之类的就需要调整该值了。
    back_log = 384                      #back_log参数是值指出在MySQL暂时停止响应新请求之前，短时间内的多少个请求可以被存在堆栈中。如果系统在短时间内有很多连接，则需要增加该参数
                                        的值，该参数值指定到来的TCP/IP连接的监听队列的大小。不同的操作系统在这个队列的大小上有自己的限制。如果试图将back_log设置得高于操作系统的
                                        限制将是无效的，其默认值为50.对于Linux系统而言，推荐设置为小于512的整数。
    max_connections = 800               #指定MySQL允许的最大连接进程数。如果在访问博客时经常出现 Too Many Connections的错误提示，则需要增大该参数值。
    max_connect_errors = 6000           #设置每个主机的连接请求异常中断的最大次数，当超过该次数，MySQL服务器将禁止host的连接请求，直到MySQL服务器重启或通过flush hosts命令清空此
                                        host的相关信息。
wait_timeout = 120  #指定一个请求的最大连接时间，对于4GB左右内存的服务器来说，可以将其设置为5~10。
table_cache = 614K  #table_cache指示表高速缓冲区的大小。当MySQL访问一个表时，如果在MySQL缓冲区还有空间，那么这个表就被打开并放入表缓冲区，这样做的好处是可以更快速地访问表中的内容。一般来说，可以查看数据库运行峰值时间的状态值Open_tables和Open_tables，用以判断是否需要增加table_cache的值，即如果Open_tables接近table_cache的时候，并且Opened_tables这个值在逐步增加，那就要考虑增加这个值的大小了。
external-locking = FALSE  #MySQL选项可以避免外部锁定。True为开启。
max_allowed_packet =16M  #服务器一次能处理最大的查询包的值，也是服务器程序能够处理的最大查询
sort_buffer_size = 1M  #设置查询排序时所能使用的缓冲区大小，系统默认大小为2MB。
注意：该参数对应的分配内存是每个连接独占的，如果有100个连接，那么实际分配的总排序缓冲区大小为100 x6=600MB。所以，对于内存在4GB左右的服务器来说，推荐将其设置为6MB~8MB
join_buffer_size = 8M #联合查询操作所能使用的缓冲区大小，和sort_buffer_size一样，该参数对应的分配内存也是每个连接独享。
thread_cache_size = 64 #设置Thread Cache池中可以缓存的连接线程最大数量，可设置为0~16384，默认为0.这个值表示可以重新利用保存在缓存中线程的数量，当断开连接时如果缓存中还有空间，那么客户端的线程将被放到缓存中;如果线程重新被请求，那么请求将从缓存中读取,如果缓存中是空的或者是新的请求，那么这个线程将被重新创建，如果有很多线程，增加这个值可以改善系统性能。通过比较Connections和Threads_created状态的变量，可以看到这个变量的作用。我们可以根据物理内存设置规则如下:1GB内存我们配置为8,2GB内存我们配置为16,3GB我们配置为32,4GB或4GB以上我们给此值为64或更大的值。

thread_concurrency = 8  #该参数取值为服务器逻辑CPU数量x 2，在本例中，服务器有两个物理CPU，而每个物理CPU又支持H.T超线程，所以实际取值为4 x 2 = 8。这也是双四核主流服务器的配置。

query_cache_size = 64M #指定MySQL查询缓冲区的大小。可以通过在MySQL控制台观察，如果Qcache_lowmem_prunes的值非常大，则表明经常出现缓冲不够的情况;如果Qcache_hits的值非常大，则表明查询缓冲使用得非常频繁。另外如果改值较小反而会影响效率，那么可以考虑不用查询缓冲。对于Qcache_free_blocks，如果该值非常大，则表明缓冲区中碎片很多。

query_cache_limit = 2M  #只有小于此设置值的结果才会被缓存

query_cache_min_res_unit = 2k  #设置查询缓存分配内存的最小单位，要适当第设置此参数，可以做到为减少内存快的申请和分配次数，但是设置过大可能导致内存碎片数值上升。默认值为4K，建议设置为1K~16K。

default_table_type = InnoDB  #默认表的类型为InnoDB

thread_stack = 256K  #设置MySQL每个线程的堆栈大小，默认值足够大，可满足普通操作。可设置范围为128KB至4GB，默认为192KB

#transaction_isolation = Level #数据库隔离级别 (READ UNCOMMITTED(读取未提交内容) READ COMMITTED(读取提交内容) REPEATABLE READ(可重读) SERIALIZABLE(可串行化))

tmp_table_size = 64M  #设置内存临时表最大值。如果超过该值，则会将临时表写入磁盘，其范围1KB到4GB。

max_heap_table_size = 64M  #独立的内存表所允许的最大容量。

table_cache = 614 #给经常访问的表分配的内存，物理内存越大，设置就越大。调大这个值，一般情况下可以降低磁盘IO，但相应的会占用更多的内存,这里设置为614。

table_open_cache = 512  #设置表高速缓存的数目。每个连接进来，都会至少打开一个表缓存。因此， table_cache 的大小应与 max_connections 的设置有关。例如，对于200 个并行运行的连接，应该让表的缓存至少有 200 × N ，这里 N 是应用可以执行的查询的一个联接中表的最大数量。此外，还需要为临时表和文件保留一些额外的文件描述符。

long_query_time = 1  #慢查询的执行用时上限,默认设置是10s,推荐(1s~2s)

log_long_format  #没有使用索引的查询也会被记录。(推荐,根据业务来调整)

log-slow-queries = /data/3306/slow.log  #慢查询日志文件路径(如果开启慢查询,建议打开此日志)

log-bin = /data/3306/mysql-bin #logbin数据库的操作日志,例如update、delete、create等都会存储到binlog日志,通过logbin可以实现增量恢复

relay-log = /data/3306/relay-bin #relay-log日志记录的是从服务器I/O线程将主服务器的二进制日志读取过来记录到从服务器本地文件,然后SQL线程会读取relay-log日志的内容并应用到从服务器

relay-log-info-file = /data/3306/relay-log.info  #从服务器用于记录中继日志相关信息的文件,默认名为数据目录中的relay-log.info。

binlog_cache_size = 4M  #在一个事务中binlog为了记录sql状态所持有的cache大小，如果你经常使用大的，多声明的事务，可以增加此值来获取更大的性能，所有从事务来的状态都被缓冲在binlog缓冲中，然后再提交后一次性写入到binlog中，如果事务比此值大，会使用磁盘上的临时文件来替代，此缓冲在每个链接的事务第一次更新状态时被创建。

max_binlog_cache_size = 8M  #最大的二进制Cache日志缓冲尺寸。

max_binlog_size = 1G  #二进制日志文件的最大长度(默认设置1GB)一个二进制文件信息超过了这个最大长度之前,MySQL服务器会自动提供一个新的二进制日志文件接续上。

expire_logs_days = 7  #超过7天的binlog,mysql程序自动删除(如果数据重要,建议不要开启该选项)

key_buffer_size = 256M  #指定用于索引的缓冲区大小，增加它可得到更好的索引处理性能。对于内存在4GB左右的服务器来说，该参数可设置为256MB或384MB。

注意：如果该参数值设置得过大反而会使服务器的整体效率降低！

read_buffer_size = 4M  #读查询操作所能使用的缓冲区大小。和sort_buffer_size一样，该参数对应的分配内存也是每个连接独享。

read_rnd_buffer_size = 16M #设置进行随机读的时候所使用的缓冲区。此参数和read_buffer_size所设置的Buffer相反，一个是顺序读的时候使用，一个是随机读的时候使用。但是两者都是针对与线程的设置，每个线程都可以产生两种Buffer中的任何一个。默认值256KB，最大值4GB。

bulk_insert_buffer_size = 8M  #如果经常性的需要使用批量插入的特殊语句来插入数据,可以适当调整参数至16MB~32MB,建议8MB。

#myisam_sort_buffer_size = 8M #设置在REPAIR Table或用Create index创建索引或 Alter table的过程中排序索引所分配的缓冲区大小，可设置范围4Bytes至4GB，默认为8MB

lower_case_table_names = 1  #实现MySQL不区分大小。(发开需求-建议开启)

slave-skip-errors = 1032,1062 #从库可以跳过的错误数字值(mysql错误以数字代码反馈,全的mysql错误代码大全,以后会发布至博客)。

replicate-ignore-db=mysql  #在做主从的情况下,设置不需要同步的库。

server-id = 1  #表示本机的序列号为1,如果做主从，或者多实例,serverid一定不能相同。

myisam_sort_buffer_size = 128M  #当需要对于执行REPAIR, OPTIMIZE, ALTER 语句重建索引时，MySQL会分配这个缓存，以及LOAD DATA INFILE会加载到一个新表，它会根据最大的配置认真的分配的每个线程。 

myisam_max_sort_file_size = 10G #当重新建索引（REPAIR，ALTER，TABLE，或者LOAD，DATA，TNFILE）时，MySQL被允许使用临时文件的最大值。

myisam_repair_threads = 1 #如果一个表拥有超过一个索引, MyISAM 可以通过并行排序使用超过一个线程去修复他们.

myisam_recover #自动检查和修复没有适当关闭的 MyISAM 表.

innodb_additional_mem_pool_size = 4M #用来设置InnoDB存储的数据目录信息和其他内部数据结构的内存池大小。应用程序里的表越多，你需要在这里面分配越多的内存。对于一个相对稳定的应用，这个参数的大小也是相对稳定的，也没有必要预留非常大的值。如果InnoDB用广了这个池内的内存，InnoDB开始从操作系统分配内存，并且往MySQL错误日志写警告信息。默认为1MB，当发现错误日志中已经有相关的警告信息时，就应该适当的增加该参数的大小。

innodb_buffer_pool_size = 64M #InnoDB使用一个缓冲池来保存索引和原始数据，设置越大，在存取表里面数据时所需要的磁盘I/O越少。强烈建议不要武断地将InnoDB的Buffer Pool值配置为物理内存的50%~80%，应根据具体环境而定。

innodb_data_file_path = ibdata1:128M:autoextend  #设置配置一个可扩展大小的尺寸为128MB的单独文件，名为ibdata1.没有给出文件的位置，所以默认的是在MySQL的数据目录内。

innodb_file_io_threads = 4  #InnoDB中的文件I/O线程。通常设置为4，如果是windows可以设置更大的值以提高磁盘I/O

innodb_thread_concurrency = 8 #你的服务器有几个CPU就设置为几，建议用默认设置，一般设为8。

innodb_flush_log_at_trx_commit = 1 #设置为0就等于innodb_log_buffer_size队列满后在统一存储，默认为1，也是最安全的设置。

innodb_log_buffer_size = 2M  #默认为1MB，通常设置为8~16MB就足够了。

innodb_log_file_size = 32M  #确定日志文件的大小，更大的设置可以提高性能，但也会增加恢复数据库的时间。

innodb_log_files_in_group = 3 #为提高性能,MySQL可以以循环方式将日志文件写到多个文件。推荐设置为3。

innodb_max_dirty_pages_pct = 90 #InnoDB主线程刷新缓存池中的数据。

innodb_lock_wait_timeout = 120 #InnoDB事务被回滚之前可以等待一个锁定的超时秒数。InnoDB在它自己的锁定表中自动检测事务死锁并且回滚事务。InnoDB用locak tables 语句注意到锁定设置。默认值是50秒。

innodb_file_per_table = 0  #InnoDB为独立表空间模式，每个数据库的每个表都会生成一个数据空间。0关闭，1开启。

独立表空间优点：

1、每个表都有自己独立的表空间。

2、每个表的数据和索引都会存在自己的表空间中。

3、可以实现单表在不同的数据库中移动。

4、空间可以回收（除drop table操作处，表空不能自己回收。）

[mysqldump]

quick

max_allowed_packet = 2M  #设定在网络传输中一次消息传输量的最大值。系统默认值为1MB，最大值是1GB，必须设置为1024的倍数。单位为字节。

 

[mysqld_safe]

值得注意：

    强烈建议不要武断地将InnoDB的Buffer Pool值配置为物理内存的50%~80%，应根据具体环境而定。
    
    如果key_reads太大，则应该把my.cnf中的key_buffer_size变大，保持key_reads/key_read_re-quests至少在1/100以上，越小越好。
    
    如果qcache_lowmem_prunes很大，就要增加query_cache_size的值。

不过很多时候需要具体情况具体分析，其他参数的变更我们可以等MySQL上线稳定一段时间后在根据status值进行调整。
电商MySQL数据库配置文件

这是一份电子商务网站MySQL数据库调整后所运行的配置文件/etc/my.cnf(服务器为DELL R710、16GB内存、RAID10)，大家可以根据实际的MySQL数据库硬件情况进行调整配置文件如下：

[client]

port            = 3306

socket          =/data/3306/mysql.sock

default-character-set = utf8

 

[mysqld]

user    = mysql

port    = 3306

character-set-server = utf8

socket  =/data/3306/mysql.sock

basedir = /application/mysql

datadir = /data/3306/data

log-error=/data/3306/mysql_err.log

pid-file=/data/3306/mysql.pid

 

log_slave_updates = 1

log-bin = /data/3306/mysql-bin

binlog_format = mixed

binlog_cache_size = 4M

max_binlog_cache_size = 8M

max_binlog_size = 1G

expire_logs_days = 90

binlog-ignore - db = mysql

binlog-ignore - db = information_schema

 

key_buffer_size = 384M

sort_buffer_size = 2M

read_buffer_size = 2M

read_rnd_buffer_size = 16M

join_buffer_size = 2M

thread_cache_size = 8

query_cache_size = 32M

query_cache_limit = 2M

query_cache_min_res_unit = 2k

thread_concurrency = 32

 

table_cache = 614

table_open_cache = 512

open_files_limit    = 10240

back_log = 600

max_connections = 5000

max_connect_errors = 6000

external-locking = FALSE

 

max_allowed_packet =16M

thread_stack = 192K

transaction_isolation = READ-COMMITTED

tmp_table_size = 256M

max_heap_table_size = 512M

 

bulk_insert_buffer_size = 64M

myisam_sort_buffer_size = 64M

myisam_max_sort_file_size = 10G

myisam_repair_threads = 1

myisam_recover

 

long_query_time = 2

slow_query_log

slow_query_log_file = /data/3306/slow.log

skip-name-resolv

skip-locking

skip-networking

server-id = 1

 

innodb_additional_mem_pool_size = 16M

innodb_buffer_pool_size = 512M

innodb_data_file_path = ibdata1:256M:autoextend

innodb_file_io_threads = 4

innodb_thread_concurrency = 8

innodb_flush_log_at_trx_commit = 2

innodb_log_buffer_size = 16M

innodb_log_file_size = 128M

innodb_log_files_in_group = 3

innodb_max_dirty_pages_pct = 90

innodb_lock_wait_timeout = 120

innodb_file_per_table = 0

 

[mysqldump]

quick

max_allowed_packet = 64M

 

[mysql]

no – auto - rehash
MySQL上线后根据status状态进行优化

MySQL数据库上线后，可以等其稳定运行一段时间后再根据服务器的status状态进行适当优化，我们可以用如下命令列出MySQL服务器运行的各种状态值：

mysql > show global status;

我个人比较喜欢的用法是 show status like '查询%';
1.慢查询

有时我们为了定位系统中效率比较低下的Query语法，需要打开慢查询日志，也就是Slow Que-ry log。打开慢查询日志的相关命令如下：

mysql> show variableslike '%slow%';

+---------------------+-----------------------------------------+

| Variable_name       |Value                                   |

+---------------------+-----------------------------------------+

| log_slow_queries    | ON                                     |

| slow_launch_time    | 2                                       |

+---------------------+-----------------------------------------+

 

mysql> show globalstatus like '%slow%';

+---------------------+-------+

| Variable_name       | Value|

+---------------------+-------+

| Slow_launch_threads | 0    |

| Slow_queries        | 2128   |

+---------------------+-------+

打开慢查询日志可能会对系统性能有一点点影响，如果你的MySQL是主从结构，可以考虑打开其中一台从服务器的慢查询日志，这样既可以监控慢查询，对系统性能影响也会很小。另外，可以用MySQL自带的命令mysqldumpslow进行查询。比如：下面的命令可以查出访问次数最多的20个SQL语句：

mysqldumpslow-s c -t 20 host-slow.log
2.连接数

我们如果经常遇见MySQL：ERROR1040：Too manyconnections的情况，一种情况是访问量确实很高，MySQL服务器扛不住了，这个时候就要考虑增加从服务器分散读压力。另外一种情况是MySQL配置文件中max_connections的值过小。来看一个例子。

mysql>show variables like'max_connections';

+-----------------+-------+

| Variable_name   | Value |

+-----------------+-------+

| max_connections | 800   |

+-----------------+-------+

这台服务器最大连接数是256，然后查询一下该服务器响应的最大连接数；

mysql> show global status like 'Max_used_connections';

+----------------------+-------+

| Variable_name        | Value|

+----------------------+-------+

| Max_used_connections | 245   |

+----------------------+-------+

MySQL服务器过去的最大连接数是245，没有达到服务器连接数的上线800，不会出现1040错误。

Max_used_connections/max_connections * 100% = 85%

最大连接数占上限连接数的85%左右,如果发现比例在10%以下，则说明MySQL服务器连接数的上限设置得过高了。
3.key_buffer_size

key_buffer_size是设置MyISAM表索引缓存空间的大小，此参数对MyISAM表性能影响最大。下面是一台MyISAM为主要存储引擎服务器的配置：

mysql> show variables like 'key_buffer_size';

+-----------------+-----------+

| Variable_name   | Value   |

+-----------------+-----------+

| key_buffer_size | 536870912 |

+-----------------+-----------+

从上面可以看出，分配了512MB内存给key_buffer_size。再来看key_buffer_size的使用情况：

mysql> show global status like 'key_read%';

+-------------------+--------------+

| Variable_name     | Value |

+-------------------+-------+

| Key_read_requests | 27813678766 |

| Key_reads          |  6798830      |

+-------------------+--------------+

一共有27813678766个索引读取请求，有6798830个请求在内存中没有找到，直接从硬盘读取索引。

key_cache_miss_rate = key_reads /key_read_requests * 100%

比如上面的数据，key_cache_miss_rate为0.0244%，4000%个索引读取请求才有一个直接读硬盘，效果已经很好了，key_cache_miss_rate在0.1%以下都很好，如果key_cache_miss_rate在0.01%以下的话，则说明key_buffer_size分配得过多，可以适当减少。
4.临时表

当执行语句时，关于已经被创建了隐含临时表的数量，我们可以用如下命令查询其具体情况：

mysql> show global status like 'created_tmp%';

+-------------------------+----------+

| Variable_name           |Value |

+-------------------------+----------+

| Created_tmp_disk_tables | 21119   |

| Created_tmp_files       |6     |

| Created_tmp_tables      |17715532  |

+-------------------------+----------+

每次创建临时表时，Created_tmp_table都会增加，如果磁盘上创建临时表，Created_tmp_disk_tables也会增加。Created_tmp_files表示MySQL服务创建的临时文件数，比较理想的配置是：

Created_tmp_disk_tables/ Created_tmp_files * 100% <= 25%

比如上面的服务器Created_tmp_disk_tables/ Created_tmp_files * 100% =1.20%，就相当不错。我们在看一下MySQL服务器对临时表的配置：

mysql> show variables where Variable_name in('tmp_table_size','max_heap_table_size');

+---------------------+---------+

| Variable_name       |Value   |

+---------------------+---------+

| max_heap_table_size | 2097152 |

| tmp_table_size      |2097152 |

+---------------------+---------+
5.打开表的情况

Open_tables表示打开表的数量，Opened_tables表示打开过的表数量，我们可以用如下命令查看其具体情况：

mysql> show global status like 'open%tables%';

+---------------+-------+

| Variable_name | Value |

+---------------+-------+

| Open_tables   | 351   |

| Opened_tables | 1455 |

如果Opened_tables数量过大，说明配置中table_open_cache的值可能太小。我们查询下服务器table_open_cache;

mysql> show variables like 'table_open_cache'; 

+------------------+-------+

| Variable_name    | Value |

+------------------+-------+

| table_open_cache | 2048  |

+------------------+-------+

比较合适的值为：

open_tables/ opened_tables* 100% > = 85%

open_tables/ table_open_cache* 100% < = 95%
6.进程使用情况

如果我们在MySQL服务器的配置文件中设置了thread_cache_size，当客户端断开时，服务器处理此客户请求的线程将会缓存起来以响应一下客户而不是销毁(前提是缓存数未达上线)Thread_created表示创建过的线程数，我们可以用如下命令查看：

mysql> show global status like 'thread%';

+-------------------+-------+

| Variable_name     | Value |

+-------------------+-------+

| Threads_cached    | 40    |

| Threads_connected | 1     |

| Threads_created   | 330   |

| Threads_running   | 1     |

+-------------------+-------+

如果发现Threads_created的值过大的话，表明MySQL服务器一直在创建线程，这也是比较耗费资源的，可以适当增大配置文件中thread_cache_size的值。查询服务器thread_cache_size配置如下：

mysql> show variables like 'thread_cache_size';

+-------------------+-------+

| Variable_name     | Value |

+-------------------+-------+

| thread_cache_size | 100   |

+-------------------+-------+

示例中的MySQL服务器还是挺健康的。
7.查询缓存(querycache)

它主要涉及两个参数，query_cache_size是设置MySQL的Query Cache大小，query_cache_type是设置使用查询缓存的类型，我们可以用如下命令查看其具体情况：

mysql> show global status like 'qcache%';

+-------------------------+-----------+

| Variable_name           |Value  |

+-------------------------+-----------+

| Qcache_free_blocks      |22756     |

| Qcache_free_memory      |76764704  |

| Qcache_hits             | 213028692   |

| Qcache_inserts          |208894227   |

| Qcache_lowmem_prunes    |4010916    |

| Qcache_not_cached       |13385031    |

| Qcache_queries_in_cache | 43560    |

| Qcache_total_blocks     |111212    |

+-------------------------+-----------+

 

MySQL查询缓存变量的相关解释如下：

Qcache_free_blocks： 缓存中相领内存快的个数。数目大说明可能有碎片。flush query cache会对缓存中的碎片进行整理，从而得到一个空间块。

Qcache_free_memory：缓存中的空闲空间。

Qcache_hits：多少次命中。通过这个参数可以查看到Query Cache的基本效果。

Qcache_inserts：插入次数，没插入一次查询时就增加1。命中次数除以插入次数就是命中比率。

Qcache_lowmem_prunes：多少条Query因为内存不足而被清楚出Query Cache。通过Qcache_lowmem_prunes和Query_free_memory相互结合，能够更清楚地了解到系统中Query Cache的内存大小是否真的足够，是否非常频繁地出现因为内存不足而有Query被换出的情况。   

Qcache_not_cached：不适合进行缓存的查询数量，通常是由于这些查询不是select语句或用了now()之类的函数。

Qcache_queries_in_cache：当前缓存的查询和响应数量。

Qcache_total_blocks：缓存中块的数量。

 

我们在查询一下服务器上关于query_cache的配置命令：

mysql> show variables like 'query_cache%';

+------------------------------+---------+

| Variable_name               | Value   |

+------------------------------+---------+

| query_cache_limit           | 1048576 |

| query_cache_min_res_unit    | 2048    |

| query_cache_size            | 2097152 |

| query_cache_type            | ON      |

| query_cache_wlock_invalidate | OFF     |

+------------------------------+---------+

字段解释如下：

query_cache_limit：超过此大小的查询将不缓存。

query_cache_min_res_unit：缓存块的最小值。

query_cache_size：查询缓存大小。

query_cache_type：缓存类型，决定缓存什么样的查询，示例中表示不缓存select sql_no_cache查询。

query_cache_wlock_invalidat：表示当有其他客户端正在对MyISAM表进行写操作，读请求是要等WRITELOCK释放资源后再查询还是允许直接从Query Cache中读取结果，默认为OFF（可以直接从Query Cache中取得结果。）

 

query_cache_min_res_unit的配置是一柄双刃剑，默认是4KB，设置值大对大数据查询有好处，但如果你的查询都是小数据查询，就容易造成内存碎片和浪费。

 

查询缓存碎片率 =Qcache_free_blocks /Qcache_total_blocks * 100%

如果查询碎片率超过20%，可以用 flushquery cache 整理缓存碎片，或者试试减少query_cache_min_res_unit，如果你查询都是小数据库的话。

 

查询缓存利用率 =(Qcache_free_size – Qcache_free_memory)/query_cache_size * 100%

查询缓存利用率在25%一下的话说明query_cache_size设置得过大，可适当减少;查询缓存利用率在80%以上而且Qcache_lowmem_prunes> 50的话则说明query_cache_size可能有点小，不然就是碎片太多。

 

查询命中率 = (Qcache_hits- Qcache_insert)/Qcache)hits * 100%

示例服务器中的查询缓存碎片率等于20%左右，查询缓存利用率在50%，查询命中率在2%，说明命中率很差，可能写操作比较频繁，而且可能有些碎片。
8.排序使用情况

它表示系统中对数据进行排序时所用的Buffer，我们可以用如下命令查看：

mysql> show global status like 'sort%';

+-------------------+----------+

| Variable_name     | Value |

+-------------------+----------+

| Sort_merge_passes | 10        |

| Sort_range        | 37431240   |

| Sort_rows         | 6738691532|

| Sort_scan         | 1823485     |

+-------------------+----------+

Sort_merge_passes包括如下步骤：MySQL首先会尝试在内存中做排序，使用的内存大小由系统变量sort_buffer_size来决定，如果它不够大则把所有的记录都读在内存中，而MySQL则会把每次在内存中排序的结果存到临时文件中，等MySQL找到所有记录之后，再把临时文件中的记录做一次排序。这次再排序就会增加sort_merge_passes。实际上，MySQL会用另外一个临时文件来存储再次排序的结果，所以我们通常会看到sort_merge_passes增加的数值是建临时文件数的两倍。因为用到了临时文件，所以速度可能会比较慢，增大sort_buffer_size会减少sort_merge_passes和创建临时文件的次数，但盲目地增大sort_buffer_size并不一定能提高速度。
9.文件打开数(open_files)

我们现在处理MySQL故障时，发现当Open_files大于open_files_limit值时，MySQL数据库就会发生卡住的现象，导致Nginx服务器打不开相应页面。这个问题大家在工作中应注意，我们可以用如下命令查看其具体情况：

show global status like 'open_files';

+---------------+-------+

| Variable_name | Value |

+---------------+-------+

| Open_files    | 1481   |

+---------------+-------+

mysql> show global status like 'open_files_limit';

+------------------+-------+

| Variable_name    | Value |

+------------------+--------+

| Open_files_limit | 4509 |

+------------------+--------+

比较合适的设置是：Open_files/ Open_files_limit * 100% < = 75%
10.InnoDB_buffer_pool_cache合理设置

InnoDB存储引擎的缓存机制和MyISAM的最大区别就在于，InnoDB不仅仅缓存索引，同时还会缓存实际的数据。此参数用来设置InnoDB最主要的Buffer的大小，也就是缓存用户表及索引数据的最主要缓存空间，对InnoDB整体性能影响也最大。

无论是MySQL官方手册还是网络上许多人分享的InnoDB优化建议，都是简单地建议将此值设置为整个系统物理内存的50%~80%。这种做法其实不妥，我们应根据实际的运行场景来正确设置此项参数。
MySQL优化小思想

很多时候我们会发现，通过参数设置进行性能优化所带来的性能提升，并不如许多人想象的那样会产生质的飞跃，除非是之前的设置存在严重不合理的情况。我们不能将性能调优完全依托与通过DBA在数据库上线后进行参数调整，而应该在系统设计和开发阶段就尽可能减少性能问题。(重点在于前期架构合理的设计及开发的程序合理)
MySQL数据库的可扩展架构方案

如果凭借MySQL的优化任无法顶住压力，这个时候我们就必须考虑MySQL的可扩展性架构了(有人称为MySQL集群)它有以下明显的优势：

    成本低，很容易通过价格低廉Pc server搭建出一个处理能力非常强大的计算机集群。
    
    不太容易遇到瓶颈，因为很容易通过添加主机来增加处理能力。
    
    单节点故障对系统的整体影响较小。

目前可行的方案如下：

（1）MySQL Cluter

其特点为可用性非常高，性能非常好。每份数据至少可在不同主机上存一份副本，且冗余数据拷贝实时同步。但它的维护非常复杂，存在部分Bug，目前还不适合比较核心的线上系统，所以暂时不推荐。

（2）DRBD磁盘网络镜像方案

其特点为软件功能强大，数据可在底层快设备级别跨物理主机镜像，且可根据性能可靠性要求配置不同级别的同步。I/O操作会保持顺序，可满足数据库对数据一致性的苛刻要求。但非分布式文件系统环境无法支持镜像数据同时可见，性能和可靠性两者互相矛盾，无法适用于性能和可靠性要求都比较苛刻的环境，维护成本高于MySQL Replication。另外，DRBD是官方推荐的可用于MySQL的搞可用方案之一，大家可根据实际环境来考虑是否部署。

（3）MySQL Replication

在工作中，此种MySQL搞可用、高扩展性架构也是用得最多的，一主多从、双主多从是生产环境常见的高可用架构方案。

安装MySQL 5.7版本，官网http://dev.mysql.com/downloads/repo/yum/ 

```
rpm -Uvh  http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
```

可以看到已经有了，并且5.7版本已经启用，可以直接安装：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
root@192 yum.repos.d]# yum repolist all | grep mysql
mysql-connectors-community/x86_64 MySQL Connectors Community         启用:    24
mysql-connectors-community-source MySQL Connectors Community - Sourc 禁用
mysql-tools-community/x86_64      MySQL Tools Community              启用:    38
mysql-tools-community-source      MySQL Tools Community - Source     禁用
mysql-tools-preview/x86_64        MySQL Tools Preview                禁用
mysql-tools-preview-source        MySQL Tools Preview - Source       禁用
mysql55-community/x86_64          MySQL 5.5 Community Server         禁用
mysql55-community-source          MySQL 5.5 Community Server - Sourc 禁用
mysql56-community/x86_64          MySQL 5.6 Community Server         禁用
mysql56-community-source          MySQL 5.6 Community Server - Sourc 禁用
mysql57-community/x86_64          MySQL 5.7 Community Server         启用:   146
mysql57-community-source          MySQL 5.7 Community Server - Sourc 禁用
mysql80-community/x86_64          MySQL 8.0 Community Server         禁用
mysql80-community-source          MySQL 8.0 Community Server - Sourc 禁用
[root@192 yum.repos.d]# 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

如果没有开启，或者你想要选择需要的版本进行安装，修改 /etc/yum.repos.d/mysql-community.repo，选择需要的版本把enable改为1即可，其它的改为0：

![img](https://images2015.cnblogs.com/blog/847828/201610/847828-20161023210820279-947159587.png)

修改好后查看可用的安装版本：

```
[root@192 yum.repos.d]# yum repolist enabled | grep mysql
mysql-connectors-community/x86_64 MySQL Connectors Community                  24
mysql-tools-community/x86_64      MySQL Tools Community                       38
mysql57-community/x86_64          MySQL 5.7 Community Server                 146
```

不用犹豫，开始安装吧！

```
yum -y install mysql-community-server
```

 ……经过漫长的等待后，看到下图所示：

![img](https://images2015.cnblogs.com/blog/847828/201610/847828-20161023225326373-589477115.png)

开始启动mysql：

```
service mysqld start
Redirecting to /bin/systemctl start  mysqld.service
```

看下mysql的启动状态：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@192 yum.repos.d]# service mysqld status
Redirecting to /bin/systemctl status  mysqld.service
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since 日 2016-10-23 22:51:48 CST; 3min 14s ago
  Process: 36884 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS (code=exited, status=0/SUCCESS)
  Process: 36810 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 36887 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─36887 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

10月 23 22:51:45 192.168.0.14 systemd[1]: Starting MySQL Server...
10月 23 22:51:48 192.168.0.14 systemd[1]: Started MySQL Server.
10月 23 22:52:24 192.168.0.14 systemd[1]: Started MySQL Server.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

开机启动设置：

```
systemctl enable mysqld
systemctl daemon-reload
```

mysql安装完成之后，在/var/log/mysqld.log文件中给root生成了一个默认密码。通过下面的方式找到root默认密码，然后登录mysql进行修改：

```
[root@192 yum.repos.d]# grep 'temporary password' /var/log/mysqld.log
2016-10-23T14:51:45.705458Z 1 [Note] A temporary password is generated for root@localhost: a&sqr7dou7N_mysql -uroot -p
```

修改root密码：

```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewPassWord!';
```

 注意：mysql5.7默认安装了密码安全检查插件，默认密码检查策略要求密码必须包含：大小写字母、数字和特殊符号，并且长度不能少于8位。否则会提示ERROR  1819 (HY000): Your password does not satisfy the current policy  requirements错误，如下图所示：

![img](https://images2015.cnblogs.com/blog/847828/201610/847828-20161023230329748-764210032.png)

通过msyql环境变量可以查看密码策略的相关信息：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
mysql> show variables like '%password%';
+---------------------------------------+--------+
| Variable_name                         | Value  |
+---------------------------------------+--------+
| default_password_lifetime             | 0      |
| disconnect_on_expired_password        | ON     |
| log_builtin_as_identified_by_password | OFF    |
| mysql_native_password_proxy_users     | OFF    |
| old_passwords                         | 0      |
| report_password                       |        |
| sha256_password_proxy_users           | OFF    |
| validate_password_check_user_name     | OFF    |
| validate_password_dictionary_file     |        |
| validate_password_length              | 8      |
| validate_password_mixed_case_count    | 1      |
| validate_password_number_count        | 1      |
| validate_password_policy              | MEDIUM |
| validate_password_special_char_count  | 1      |
+---------------------------------------+--------+
14 rows in set (0.00 sec)
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

validate_password_policy：密码策略，默认为MEDIUM策略 
validate_password_dictionary_file：密码策略文件，策略为STRONG才需要 
validate_password_length：密码最少长度 
validate_password_mixed_case_count：大小写字符长度，至少1个 
validate_password_number_count ：数字至少1个 
validate_password_special_char_count：特殊字符至少1个 
*上述参数是默认策略MEDIUM的密码检查规则。*

### 修改密码策略

如果想修改密码策略，在/etc/my.cnf文件添加validate_password_policy配置：

```
# 选择0（LOW），1（MEDIUM），2（STRONG）其中一种，选择2需要提供密码字典文件
validate_password_policy=0
```

## 配置默认编码为utf8

修改/etc/my.cnf配置文件，在[mysqld]下添加编码配置，如下所示：

```
[mysqld]
character_set_server=utf8
init_connect='SET NAMES utf8'
```

重新启动mysql服务使配置生效：

```
systemctl restart mysqld
```

## 添加远程登录用户

默认只允许root帐户在本地登录，如果要在其它机器上连接mysql，必须修改root允许远程连接，或者添加一个允许远程连接的帐户，为了安全起见，我们添加一个新的帐户：

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'evai'@'%' IDENTIFIED BY '@evai2016' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
```

这样远程就可以用账户名为evai，密码为@evai2016来登录数据库了，运行 select host, user from mysql.user 查看下：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
mysql> select host,user from mysql.user;
+-----------+-----------+
| host      | user      |
+-----------+-----------+
| %         | evai      |
| localhost | mysql.sys |
| localhost | root      |
+-----------+-----------+
3 rows in set (0.00 sec)
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

​			**MySQL** 服务器是一个开源、快速且强大的数据库服务器。这部分描述了如何在 RHEL 系统上安装和配置 **MySQL**，如何备份 **MySQL** 数据、如何从较早的 **MySQL** 版本迁移，以及如何复制 **MySQL**。 	

## 3.1. MySQL 入门

​				**MySQL** 是一个关系型数据库，其将数据转换为结构化的信息，并提供 SQL 接口来访问数据。它包括多种存储引擎和插件，以及地理信息系统(GIS)和 JavaScript 对象表示法(JSON)功能。 		

​				这部分描述了： 		

- ​						如何在 **安装 MySQL** 中安装 [MySQL](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#installing-mysql_assembly_using-mysql) 服务器。 				
- ​						如何在 **配置 MySQL** 中调整 [MySQL](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#configuring-mysql_assembly_using-mysql) 配置。 				
- ​						如何在 [备份 MySQL 数据](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#backing-up-mysql-data_assembly_using-mysql) 中备份 **MySQL** 数据。 				
- ​						如何将 RHEL 8 版本从 **MySQL 8.0** 迁移到 RHEL 9 的 **MySQL 8.0** 版本，以 [迁移到 MySQL 8.0 的 RHEL 9 版本](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_proc_migrating-to-a-rhel-9-version-of-mysql-8-0_assembly_using-mysql)。 				
- ​						如何在 **复制 MySQL** 中复制 [MySQL](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#replicating-mysql_assembly_using-mysql) 数据库。 				

## 3.2. 安装 MySQL

​				RHEL 9.0 提供 **MySQL 8.0**，作为此 Application Stream 的初始版本，您可以作为 RPM 软件包轻松安装。 		

​				要安装 **MySQL**，请使用以下流程。 		

**流程**

1. ​						安装 **MySQL** 服务器软件包： 				

   ```none
   # dnf install mysql-server
   ```

2. ​						启动 `mysqld` 服务： 				

   ```none
   # systemctl start mysqld.service
   ```

3. ​						在引导时启用 `mysqld` 服务： 				

   ```none
   # systemctl enable mysqld.service
   ```

4. ​						*建议：*要在安装 **MySQL** 时提高安全性，请运行以下命令： 				

   ```none
   $ mysql_secure_installation
   ```

   ​						此命令启动一个完全交互的脚本，该脚本会提示过程中的每一步。该脚本可让您通过以下方法提高安全性： 				

   - ​								为 root 帐户设置密码 						
   - ​								删除匿名用户 						
   - ​								禁止远程 root 登录（在本地主机之外） 						

注意

​					由于 RPM 软件包有冲突，因此 **MySQL** 和 **MariaDB** 数据库服务器无法在 RHEL 9 中并行安装。在 RHEL 9 中，可以在容器中使用不同版本的数据库服务器。 			

## 3.3. 配置 MySQL

​				要为网络配置 **MySQL** 服务器，请使用以下流程。 		

**流程**

1. ​						编辑 `/etc/my.cnf.d/mysql-server.cnf` 文件的 `[mysqld]` 部分。您可以设置以下配置指令： 				

   - ​								`bind-address` - 是服务器监听的地址。可能的选项有： 						
     - ​										主机名 								
     - ​										IPv4 地址 								
     - ​										IPv6 地址 								
   - ​								`skip-networking` - 控制服务器是否监听 TCP/IP 连接。可能的值有： 						
     - ​										0 - 监听所有客户端 								
     - ​										1 - 只监听本地客户端 								
   - ​								`端口` - **MySQL** 侦听 TCP/IP 连接的端口。 						

2. ​						重启 `mysqld` 服务： 				

   ```none
   # systemctl restart mysqld.service
   ```

## 3.4. 备份 MySQL 数据

​				在 Red Hat Enterprise Linux 9 中，备份 **MySQL** 数据库数据有两个主要方法： 		

- ​						逻辑备份 				
- ​						物理备份 				

​				**逻辑备份** 由恢复数据所需的 SQL 语句组成。这种类型的备份以纯文本文件的形式导出信息和记录。 		

​				与物理备份相比，逻辑备份的主要优势在于可移植性和灵活性。数据可以在其他硬件配置、**MySQL** 版本或数据库管理系统(DBMS)上恢复，而这些数据无法进行物理备份。 		

​				请注意，如果 `mysqld.service` 正在运行，也可以执行逻辑备份。逻辑备份不包括日志和配置文件。 		

​				**物理备份**由保存内容的文件和目录副本组成。 		

​				与逻辑备份相比，物理备份具有以下优点： 		

- ​						输出更为紧凑。 				
- ​						备份的大小会较小。 				
- ​						备份和恢复速度更快。 				
- ​						备份包括日志和配置文件。 				

​				请注意，当 `mysqld.service` 没有运行或数据库中的所有表被锁住时，才能执行物理备份，以防在备份过程中数据有更改。 		

​				您可以使用以下 **MySQL** 备份方法之一从 **MySQL** 数据库备份数据： 		

- ​						使用 `mysqldump` 的逻辑备份 				
- ​						文件系统备份 				
- ​						作为备份解决方案复制 				

### 3.4.1. 使用 mysqldump 执行逻辑备份

​					**mysqldump** 客户端是一种备份实用程序，可用于转储数据库或数据库集合，用于备份或传输到其他数据库服务器。**mysqldump** 的输出通常由 SQL 语句组成，用于重新创建服务器表结构，生成表的数据。**mysqldump** 也可以以其他格式生成文件，包括 XML 和分隔的文本格式，如 CSV。 			

​					要执行 **mysqldump** 备份，您可以使用以下一种选项： 			

- ​							备份一个或多个所选的数据库 					
- ​							备份所有数据库 					
- ​							从一个数据库备份表子集 					

**流程**

- ​							要转储单个数据库，请运行： 					

  ```none
  # mysqldump [options] --databases db_name > backup-file.sql
  ```

- ​							要一次转储多个数据库，请运行： 					

  ```none
  # mysqldump [options] --databases db_name1 [db_name2 ...] > backup-file.sql
  ```

- ​							要转储所有数据库，请运行： 					

  ```none
  # mysqldump [options] --all-databases > backup-file.sql
  ```

- ​							要将一个或多个转储的完整数据库加载回服务器，请运行： 					

  ```none
  # mysql < backup-file.sql
  ```

- ​							要将数据库加载到远程 **MySQL** 服务器，请运行： 					

  ```none
  # mysql --host=remote_host < backup-file.sql
  ```

- ​							要转储一个数据库中的表的子集，请在 `mysqldump` 命令的末尾添加所选表的列表： 					

  ```none
  # mysqldump [options] db_name [tbl_name ...] > backup-file.sql
  ```

- ​							要载入从一个数据库转储的表的子集，请运行： 					

  ```none
  # mysql db_name < backup-file.sql
  ```

  注意

  ​								此时，*db_name* 数据库必须存在。 						

- ​							要查看 **mysqldump** 支持的选项列表，请运行： 					

  ```none
  $ mysqldump --help
  ```

**其他资源**

- ​							[使用 mysqldump 的逻辑备份](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html) 					

### 3.4.2. 执行文件系统备份

​					要创建 **MySQL** 数据文件的文件系统备份，请将 **MySQL** 数据目录的内容复制到您的备份位置。 			

​					要同时备份当前的配置或日志文件，请使用以下流程的可选步骤： 			

**流程**

1. ​							停止 `mysqld` 服务： 					

   ```none
   # systemctl stop mysqld.service
   ```

2. ​							将数据文件复制到所需位置： 					

   ```none
   # cp -r /var/lib/mysql /backup-location
   ```

3. ​							（可选）将配置文件复制到所需位置： 					

   ```none
   # cp -r /etc/my.cnf /etc/my.cnf.d /backup-location/configuration
   ```

4. ​							（可选）将日志文件复制到所需位置： 					

   ```none
   # cp /var/log/mysql/* /backup-location/logs
   ```

5. ​							启动 `mysqld` 服务： 					

   ```none
   # systemctl start mysqld.service
   ```

6. ​							将备份位置的备份数据加载到 `/var/lib/mysql` 目录时，请确保 `mysql:mysql` 是 `/var/lib/mysql` 中所有数据的所有者： 					

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

### 3.4.3. 作为备份解决方案复制

​					复制是源服务器的一个替代的备份解决方案。如果源服务器复制到副本服务器，备份可以在副本上运行，而不会对源造成任何影响。当您关闭副本，并从副本备份数据时，源仍然可以运行。 			

​					有关如何复制 **MySQL** 数据库的说明，请参阅 [复制 MySQL](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#replicating-mysql_assembly_using-mysql)。 			

警告

​						复制本身并不是一个足够的备份解决方案。复制可以防止源服务器出现硬件故障，但它不能确保防止数据的丢失。建议您将对副本的任何其他备份解决方案与此方法一起使用。 				

**其他资源**

- ​							[MySQL 复制文档](https://dev.mysql.com/doc/refman/8.0/en/replication.html) 					

## 3.5. 迁移到 RHEL 9 版本的 MySQL 8.0

​				RHEL 8 包含 **MySQL 8.0**、**MariaDB 10.3**，以及来自 MySQL 数据库系列服务器的 **MariaDB 10.5** 实施。RHEL 9 提供 **MySQL 8.0** 和 **MariaDB 10.5**。 		

​				此流程描述了使用 `mysql_upgrade` 程序从 RHEL 8 的 **MySQL 8.0** 版本迁移到 **MySQL 8.0** 的 RHEL 9 版本。`mysql_upgrade` 工具由 `mysql-server` 软件包提供。 		

**先决条件**

- ​						在进行升级前，请备份存储在 **MySQL** 数据库中的所有数据。请参阅[备份 MySQL 数据](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#backing-up-mysql-data_assembly_using-mysql)。 				

**流程**

1. ​						确定在 RHEL 9 系统中安装了 `mysql-server` 软件包： 				

   ```none
   # dnf install mysql-server
   ```

2. ​						确保在复制数据时 `mysqld` 服务不在源或目标系统上运行： 				

   ```none
   # systemctl stop mysqld.service
   ```

3. ​						将源位置的数据复制到 RHEL 9 目标系统的 `/var/lib/mysql/` 目录中。 				

4. ​						对目标系统上复制的文件设置适当的权限和 SELinux 上下文： 				

   ```none
   # restorecon -vr /var/lib/mysql
   ```

5. ​						确保 `mysql:mysql` 是 `/var/lib/mysql` 目录中所有数据的所有者： 				

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

6. ​						在目标系统上启动 **MySQL** 服务器： 				

   ```none
   # systemctl start mysqld.service
   ```

   ​						备注：在较早版本的 **MySQL** 中，需要 `mysql_upgrade` 命令来检查和修复内部表。现在，当您启动服务器时会自动完成此操作。 				

## 3.6. 复制 MySQL

​				**MySQL** 为复制提供各种配置选项，范围从基本到高级。这部分论述了使用全局事务标识符(GTID)在新安装的 **MySQL** 上复制 MySQL 的事务方式。使用 GTID 简化了事务识别和一致性验证。 		

​				要在 **MySQL** 中设置复制，您必须： 		

- ​						[配置源服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_configuring-a-mysql-source-server_replicating-mysql) 				
- ​						[配置副本服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_configuring-a-mysql-replica-server_replicating-mysql) 				
- ​						[在源服务器上创建复制用户](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_creating-a-replication-user-on-the-mysql-source-server_replicating-mysql) 				
- ​						[将副本服务器连接到源服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_connecting-the-replica-server-to-the-source-server_replicating-mysql) 				

重要

​					如果要使用现有的 **MySQL** 服务器进行复制，您必须首先同步数据。如需更多信息，请参阅 [上游文档](https://dev.mysql.com/doc/mysql-replication-excerpt/8.0/en/replication-howto.html)。 			

### 3.6.1. 配置 MySQL 源服务器

​					这部分描述了 **MySQL** 源服务器正确运行并复制数据库服务器上所做的所有更改所需的配置选项。 			

**先决条件**

- ​							源服务器已安装。 					

**流程**

1. ​							包括 `/etc/my.cnf.d/mysql-server.cnf` 文件中 `[mysqld]` 部分下的以下选项： 					

   - ​									`bind-address=*source_ip_adress*` 							

     ​									从副本到源的连接需要这个选项。 							

   - ​									`server-id=*id*` 							

     ​									*id* 必须是唯一的。 							

   - ​									`log_bin=*path_to_source_server_log*` 							

     ​									此选项定义 **MySQL** 源服务器的二进制日志文件的路径。例如：`log_bin=/var/log/mysql/mysql-bin.log`。 							

   - ​									`gtid_mode=ON` 							

     ​									此选项在服务器上启用全局事务标识符(GTID)。 							

   - ​									`enforce-gtid-consistency=ON` 							

     ​									服务器通过仅允许执行可使用 GTID 进行安全记录的语句来强制实施 GTID 一致性。 							

   - ​									*可选:* `binlog_do_db=*db_name*` 							

     ​									如果您只想复制所选的数据库，则使用这个选项。要复制多个所选的数据库，请分别指定每个数据库： 							

     ```none
     binlog_do_db=db_name1
     binlog_do_db=db_name2
     binlog_do_db=db_name3
     ```

   - ​									*可选:* `binlog_ignore_db=*db_name*` 							

     ​									使用此选项从复制中排除特定的数据库。 							

2. ​							重启 `mysqld` 服务： 					

   ```none
   # systemctl restart mysqld.service
   ```

### 3.6.2. 配置 MySQL 副本服务器

​					本节介绍了 **MySQL** 副本服务器所需的配置选项，以确保成功复制。 			

**先决条件**

- ​							副本服务器已安装。 					

**流程**

1. ​							包括 `/etc/my.cnf.d/mysql-server.cnf` 文件中 `[mysqld]` 部分下的以下选项： 					

   - ​									`server-id=*id*` 							

     ​									*id* 必须是唯一的。 							

   - ​									`relay-log=*path_to_replica_server_log*` 							

     ​									中继日志是在复制过程中由 **MySQL** 副本服务器创建的一组日志文件。 							

   - ​									`log_bin=*path_to_replica_sever_log*` 							

     ​									此选项定义了 **MySQL** 副本服务器的二进制日志文件的路径。例如：`log_bin=/var/log/mysql/mysql-bin.log`。 							

     ​									副本中不需要这个选项，但强烈建议使用。 							

   - ​									`gtid_mode=ON` 							

     ​									此选项在服务器上启用全局事务标识符(GTID)。 							

   - ​									`enforce-gtid-consistency=ON` 							

     ​									服务器通过仅允许执行可使用 GTID 进行安全记录的语句来强制实施 GTID 一致性。 							

   - ​									`log-replica-updates=ON` 							

     ​									这个选项可确保从源服务器接收的更新记录在副本的二进制日志中。 							

   - ​									`skip-replica-start=ON` 							

     ​									此选项可确保在副本服务器启动时不启动复制线程。 							

   - ​									*可选:* `binlog_do_db=*db_name*` 							

     ​									如果您只想复制某些数据库，则使用这个选项。要复制多个数据库，请分别指定每个数据库： 							

     ```none
     binlog_do_db=db_name1
     binlog_do_db=db_name2
     binlog_do_db=db_name3
     ```

   - ​									*可选:* `binlog_ignore_db=*db_name*` 							

     ​									使用此选项从复制中排除特定的数据库。 							

2. ​							重启 `mysqld` 服务： 					

   ```none
   # systemctl restart mysqld.service
   ```

### 3.6.3. 在 MySQL 源服务器上创建复制用户

​					您必须创建一个复制用户，并授予这个用户所需的复制流量的权限。此流程演示了如何创建具有适当权限的复制用户。仅在源服务器上执行这些步骤。 			

**先决条件**

- ​							源服务器已安装并配置，如 [配置 MySQL 源服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_configuring-a-mysql-source-server_replicating-mysql) 中所述。 					

**流程**

1. ​							创建复制用户： 					

   ```none
   mysql> CREATE USER 'replication_user'@'replica_server_ip' IDENTIFIED WITH mysql_native_password BY 'password';
   ```

2. ​							授予用户复制权限： 					

   ```none
   mysql> GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'replica_server_ip';
   ```

3. ​							重新载入 **MySQL** 数据库中的授权表： 					

   ```none
   mysql> FLUSH PRIVILEGES;
   ```

4. ​							将源服务器设置为只读状态： 					

   ```none
   mysql> SET @@GLOBAL.read_only = ON;
   ```

### 3.6.4. 将副本服务器连接到源服务器

​					在 **MySQL** 副本服务器上，您必须配置凭证和源服务器的地址。使用以下流程实现副本服务器。 			

**先决条件**

- ​							源服务器已安装并配置，如 [配置 MySQL 源服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_configuring-a-mysql-source-server_replicating-mysql) 中所述。 					
- ​							副本服务器已安装并配置，如 [配置 MySQL 副本服务器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_configuring-a-mysql-replica-server_replicating-mysql) 中所述。 					
- ​							您已创建了复制用户。请参阅 [在 MySQL 源服务器上创建复制用户](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_creating-a-replication-user-on-the-mysql-source-server_replicating-mysql)。 					

**流程**

1. ​							将副本服务器设置为只读状态： 					

   ```none
   mysql> SET @@GLOBAL.read_only = ON;
   ```

2. ​							配置复制源： 					

   ```none
   mysql> CHANGE REPLICATION SOURCE TO
       -> SOURCE_HOST='source_ip_address',
       -> SOURCE_USER='replication_user',
       -> SOURCE_PASSWORD='password',
       -> SOURCE_AUTO_POSITION=1;
   ```

3. ​							在 **MySQL** 副本服务器中启动副本线程： 					

   ```none
   mysql> START REPLICA;
   ```

4. ​							在源和目标服务器上取消只读状态的设置： 					

   ```none
   mysql> SET @@GLOBAL.read_only = OFF;
   ```

5. ​							*可选：*检查副本服务器的状态以进行调试： 					

   ```none
   mysql> SHOW REPLICA STATUS\G;
   ```

   注意

   ​								如果复制服务器启动或连接失败，您可以跳过 `SHOW MASTER STATUS` 命令的输出中显示的二进制日志文件位置后的某些事件。例如，从定义的位置跳过第一个事件： 						

   ```none
   mysql> SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1;
   ```

   ​								尝试再次启动副本服务器。 						

6. ​							*可选：*停止副本服务器中的副本线程： 					

   ```none
   mysql> STOP REPLICA;
   ```

### 3.6.5. 验证步骤

1. ​							在源服务器上创建一个示例数据库： 					

   ```none
   mysql> CREATE DATABASE test_db_name;
   ```

2. ​							验证 `*test_db_name*` 数据库是否在副本服务器上进行复制。 					

3. ​							在源或副本服务器上执行以下命令，显示 **MySQL** 服务器的二进制日志文件的状态信息： 					

   ```none
   mysql> SHOW MASTER STATUS;
   ```

   ​							`Executed_Gtid_Set` 列，针对在源上执行的事务显示一组 GTID，它不能为空。 					

   注意

   ​								当在副本服务器上使用 `SHOW SLAVE STATUS` 时，`Executed_Gtid_Set` 行中会显示相同的 GTID。 						

### 3.6.6. 其他资源

- ​							[MySQL 复制文档](https://dev.mysql.com/doc/refman/8.0/en/replication.html) 					
- ​							[如何在 MySQL 中设置复制](https://www.digitalocean.com/community/tutorials/how-to-set-up-replication-in-mysql) 					
- ​							[带有全局事务标识符的复制](https://dev.mysql.com/doc/refman/8.0/en/replication-gtids.html) 					

## 历史

* 1979 年，Michael Widenius 用 BASIC 设计了一个报表工具 Unireg ，这是一个很底层的面向报表的存储引擎，是存储引擎算法的前身，但不支持 SQL 。
* 1985 年，David Axmark、Allan Larsson 和 Micheal Widenius 成立了一家公司，曾是 MySQL AB 的前身。设计了一个利用索引顺序存取数据的方法，也就是 ISAM （Indexed Sequential Access Method）存储引擎算法的前身。
* 1996 年，Micheal Widenius 和 David Axmark 一起协作写出了 MySQL 的第一个版本，此时还只是小范围使用，几个月后直接发布了 3.11 版本。
* 1998 年，CX Datakonsult 公司真是更名为 MySQL AB 公司。同年，MySQL 官方网站完成建立（www.mysql.com）。
* 1999 年，MySQL 与 Sleepcat 公司合作，MySQL 提供了支持事务的 Berkeley DB 存储引擎。后来由于这个引擎的许多问题，MySQL 5.1 以后不对这个引擎提供支持了。
* 2000 年，ISAM 华丽转身为 MyISAM 存储引擎，同年 MySQL 开放了自己的源代码，并且基于 GPL 许可协议。
* 2001 年，MySQL 开始集成 InnoDB 存储引擎。
* 2003 年，MySQL 发布 4.0 版本，与 InnoDB 正式结合。
* 2005 年，MySQL 发布 5.0 版本。这是一个里程碑的版本。同年 5 月，Oracle 收购了开发 InnoDB 存储引擎的 Innobase Oy 公司，预示着不久后对 MySQL 的收购。
* 2008 年，MySQL AB 公司被 SUN 公司以 10 亿美金收购。
* 2009 年，Oracle 公司以 74 亿美金收购 SUN 公司。
* 2010 年，MySQL 5.5 发布，InnoDB 存储引擎成为 MySQL 默认存储引擎。
* 2013 年，MySQL 5.6 GA 版本发布。
* 2015 年，MySQL 5.7 GA 版本发布。
* 2016 年，MySQL 8.0.0 版本发布。
* 2018 年，MySQL 8.0.11 GA 版本发布。