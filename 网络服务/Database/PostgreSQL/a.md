# Install and configure PostgreSQL 安装和配置 PostgreSQL

[PostgreSQL](https://www.postgresql.org/) (commonly referred to as “Postgres”) is an object-relational database  system that has all the features of traditional commercial database  systems, but with enhancements to be found in next-generation database  management systems (DBMS).
PostgreSQL（通常称为“Postgres”）是一个对象关系数据库系统，具有传统商业数据库系统的所有功能，但在下一代数据库管理系统（DBMS）中具有增强功能。

## Install PostgreSQL 安装 PostgreSQL

To install PostgreSQL, run the following command in the command prompt:
若要安装 PostgreSQL，请在命令提示符下运行以下命令：

```bash
sudo apt install postgresql
```

The database service is automatically configured with viable defaults, but can be customised based on your specific needs.
数据库服务会自动配置可行的默认值，但可以根据您的特定需求进行自定义。

## Configure PostgreSQL 配置 PostgreSQL

PostgreSQL supports multiple client authentication methods. In Ubuntu, `peer` is the default authentication method used for `local` connections, while `scram-sha-256` is the default for `host` connections (this used to be `md5` until Ubuntu 21.10). Please refer to the [PostgreSQL Administrator’s Guide](http://www.postgresql.org/docs/current/static/admin.html) if you would like to configure alternatives like Kerberos.
PostgreSQL 支持多种客户端身份验证方法。在 Ubuntu 中， `peer` 是用于 `local` 连接的默认身份验证方法，而 `scram-sha-256` 是连接的 `host` 默认方法（ `md5` 这曾经是 Ubuntu 21.10 之前）。如果您想配置 Kerberos 等替代方案，请参阅 PostgreSQL 管理员指南。

The following discussion assumes that you wish to enable TCP/IP connections and use the MD5 method for client authentication. PostgreSQL  configuration files are stored in the `/etc/postgresql/<version>/main` directory. For example, if you install PostgreSQL 14, the configuration files are stored in the `/etc/postgresql/14/main` directory.
下面的讨论假定您希望启用 TCP/IP 连接并使用 MD5 方法进行客户端身份验证。PostgreSQL 配置文件存储在 `/etc/postgresql/<version>/main` 目录中。例如，如果安装 PostgreSQL 14，则配置文件存储在目录中 `/etc/postgresql/14/main` 。

> **Tip**: 提示：
>  To configure *IDENT* authentication, add entries to the `/etc/postgresql/*/main/pg_ident.conf` file. There are detailed comments in the file to guide you.
> 若要配置 IDENT 身份验证，请向 `/etc/postgresql/*/main/pg_ident.conf` 文件添加条目。文件中有详细的注释来指导您。

By default, only connections from the local system are allowed. To enable  all other computers to connect to your PostgreSQL server, edit the file `/etc/postgresql/*/main/postgresql.conf`. Locate the line: *#listen_addresses = ‘localhost’* and change it to `*`:
默认情况下，仅允许来自本地系统的连接。要使所有其他计算机都连接到您的 PostgreSQL 服务器，请编辑文件 `/etc/postgresql/*/main/postgresql.conf` 。找到行：#listen_addresses = 'localhost' 并将其更改为 `*` ：

```plaintext
listen_addresses = '*'
```

> **Note**: 注意：
>  ‘*’ will allow all available IP interfaces (IPv4 and IPv6), to only listen for IPv4 set `0.0.0.0` while ‘`::`’ allows listening for all IPv6 addresses.
> '*' 将允许所有可用的 IP 接口（IPv4 和 IPv6）仅侦听 IPv4 设置 `0.0.0.0` ，而 ' `::` ' 允许侦听所有 IPv6 地址。

For details on other parameters, refer to the configuration file or to the [PostgreSQL documentation](https://www.postgresql.org/docs/) for information on how they can be edited.
有关其他参数的详细信息，请参阅配置文件或 PostgreSQL 文档，了解如何编辑这些参数。

Now that we can connect to our PostgreSQL server, the next step is to set a password for the `postgres` user. Run the following command at a terminal prompt to connect to the default PostgreSQL template database:
现在我们可以连接到我们的 PostgreSQL 服务器，下一步是为 `postgres` 用户设置密码。在终端提示符下运行以下命令以连接到默认的 PostgreSQL 模板数据库：

```bash
sudo -u postgres psql template1
```

The above command connects to PostgreSQL database `template1` as user `postgres`. Once you connect to the PostgreSQL server, you will be at an SQL prompt. You can run the following SQL command at the `psql` prompt to configure the password for the user `postgres`.
上面的命令以用户 `postgres` 身份连接到 PostgreSQL 数据库 `template1` 。连接到 PostgreSQL 服务器后，您将出现 SQL 提示符。您可以运行以下 SQL 命令，在 `psql` 提示符下为用户 `postgres` 配置密码。

```bash
ALTER USER postgres with encrypted password 'your_password';
```

After configuring the password, edit the file `/etc/postgresql/*/main/pg_hba.conf` to use `scram-sha-256` authentication with the `postgres` user, allowed for the `template1` database, from any system in the local network (which in the example is `192.168.122.1/24`) :
配置密码后，编辑文件 `/etc/postgresql/*/main/pg_hba.conf` 以从本地网络中的任何系统（在本例中为 `192.168.122.1/24` ）对 `postgres` 用户使用 `scram-sha-256` 允许的 `template1` 数据库身份验证：

```plaintext
hostssl template1       postgres        192.168.122.1/24        scram-sha-256
```

> **Note**: 注意：
>  The config statement `hostssl` used here will reject TCP connections that would not use SSL.  PostgreSQL in Ubuntu has the SSL feature built in and configured by  default, so it works right away. On your PostgreSQL server this uses the certificate created by `ssl-cert` package which is great, but for production use you should consider  updating that with a proper certificate from a recognised Certificate  Authority (CA).
> 此处使用的 config 语句 `hostssl` 将拒绝不使用 SSL 的 TCP 连接。Ubuntu 中的 PostgreSQL 内置并默认配置了 SSL 功能，因此它可以立即工作。在您的 PostgreSQL 服务器上，这使用由 `ssl-cert` 包创建的证书，这很好，但对于生产用途，您应该考虑使用来自公认的证书颁发机构 （CA） 的适当证书来更新它。

Finally, you should restart the PostgreSQL service to initialise the new  configuration. From a terminal prompt enter the following to restart  PostgreSQL:
最后，您应该重新启动 PostgreSQL 服务以初始化新配置。在终端提示符下，输入以下命令以重新启动 PostgreSQL：

```bash
sudo systemctl restart postgresql.service
```

> **Warning**: 警告：
>  The above configuration is not complete by any means. Please refer to the [PostgreSQL Administrator’s Guide](http://www.postgresql.org/docs/current/static/admin.html) to configure more parameters.
> 无论如何，上述配置都不完整。请参考 PostgreSQL 管理员指南配置更多参数。

You can test server connections from other machines by using the PostgreSQL client as follows, replacing the domain name with your actual server  domain name or IP address:
您可以使用PostgreSQL客户端测试来自其他机器的服务器连接，如下所示，将域名替换为您的实际服务器域名或IP地址：

```bash
sudo apt install postgresql-client
psql --host your-servers-dns-or-ip --username postgres --password --dbname template1
```

## Streaming replication 流式复制

PostgreSQL has a nice feature called **streaming replication** which provides the ability to continuously ship and apply the Write-Ahead Log [(WAL) XLOG](http://www.postgresql.org/docs/current/static/wal.html) records to some number of standby servers to keep them current. Here is a simple way to replicate a PostgreSQL server (main) to a standby  server.
PostgreSQL有一个很好的功能，称为流式复制，它提供了连续交付和应用预写日志（WAL）XLOG记录的能力，以使它们保持最新状态。以下是将 PostgreSQL 服务器（主服务器）复制到备用服务器的简单方法。

First, create a replication user in the main server, to be used from the standby server:
首先，在主服务器中创建一个复制用户，以便从备用服务器使用：

```bash
sudo -u postgres createuser --replication -P -e replicator
```

Let’s configure the main server to turn on the streaming replication. Open the file `/etc/postgresql/*/main/postgresql.conf` and make sure you have the following lines:
让我们配置主服务器以打开流式复制。打开文件 `/etc/postgresql/*/main/postgresql.conf` ，确保有以下行：

```plaintext
listen_addresses = '*'
wal_level = replica
```

Also edit the file `/etc/postgresql/*/main/pg_hba.conf` to add an extra line to allow the standby server connection for replication (that is a special keyword) using the `replicator` user:
此外，编辑文件 `/etc/postgresql/*/main/pg_hba.conf` 以添加额外的行，以允许备用服务器连接进行复制（这是一个特殊关键字），使用 `replicator` 用户：

```plaintext
host  replication   replicator   <IP address of the standby>      scram-sha-256
```

Restart the service to apply changes:
重新启动服务以应用更改：

```bash
sudo systemctl restart postgresql
```

Now, in the standby server, let’s stop the PostgreSQL service:
现在，在备用服务器中，让我们停止 PostgreSQL 服务：

```bash
sudo systemctl stop postgresql
```

Edit the `/etc/postgresql/*/main/postgresql.conf` to set up hot standby:
编辑 `/etc/postgresql/*/main/postgresql.conf` 以设置热备用：

```plaintext
hot_standby = on
```

Back up the current state of the main server (those commands are still issued on the standby system):
备份主服务器的当前状态（这些命令仍在备用系统上发出）：

```bash
sudo su - postgres
# backup the current content of the standby server (update the version of your postgres accordingly)
cp -R /var/lib/postgresql/14/main /var/lib/postgresql/14/main_bak
# remove all the files in the data directory
rm -rf /var/lib/postgresql/14/main/*
pg_basebackup -h <IP address of the main server> -D /var/lib/postgresql/14/main -U replicator -P -v -R
```

After this, a full single pass will have been completed, copying the content  of the main database onto the local system being the standby. In the `pg_basebackup` command the flags represent the following:
在此之后，将完成完整的单次传递，将主数据库的内容复制到作为备用数据库的本地系统上。在命令中 `pg_basebackup` ，标志表示以下内容：

- `-h`: The hostname or IP address of the main server
   `-h` ：主服务器的主机名或 IP 地址
- `-D`: The data directory
   `-D` ：数据目录
- `-U`: The user to be used in the operation
   `-U` ：操作中使用的用户
- `-P`: Turns on progress reporting
   `-P` ：打开进度报告
- `-v`: Enables verbose mode
   `-v` ：启用详细模式
- `-R`: Creates a `standby.signal` file and appends connection settings to `postgresql.auto.conf`
   `-R` ：创建 `standby.signal` 文件并将连接设置附加到 `postgresql.auto.conf` 

Finally, let’s start the PostgreSQL service on standby server:
最后，让我们在备用服务器上启动 PostgreSQL 服务：

```bash
sudo systemctl start postgresql
```

To make sure it is working, go to the main server and run the following command:
要确保它正常工作，请转到主服务器并运行以下命令：

```bash
sudo -u postgres psql -c "select * from pg_stat_replication;"
```

As mentioned, this is a very simple introduction, there are way more great details in the upstream documentation about the configuration of [replication](https://www.postgresql.org/docs/current/static/runtime-config-replication.html) as well as further [High Availability, Load Balancing, and Replication](https://www.postgresql.org/docs/current/static/high-availability.html).
如前所述，这是一个非常简单的介绍，上游文档中有更多关于复制配置以及进一步的高可用性、负载平衡和复制的细节。

To test the replication you can now create a test database in the main  server and check if it is replicated in the standby server:
若要测试复制，现在可以在主服务器中创建一个测试数据库，并检查它是否在备用服务器中复制：

```bash
sudo -u postgres createdb test # on the main server
sudo -u postgres psql -c "\l" # on the standby server
```

You need to be able to see the `test` database, that was created on the main server, in the standby server.
您需要能够在备用服务器中查看在主服务器上创建的 `test` 数据库。

## Backups 备份

PostgreSQL databases should be backed up regularly. Refer to the [PostgreSQL Administrator’s Guide](http://www.postgresql.org/docs/current/static/backup.html) for different approaches.
PostgreSQL 数据库应定期备份。有关不同的方法，请参阅 PostgreSQL 管理员指南。

## Further reading 延伸阅读

- As mentioned above, the [PostgreSQL Administrator’s Guide](http://www.postgresql.org/docs/current/static/admin.html) is an excellent resource. The guide is also available in the `postgresql-doc` package. Execute the following in a terminal to install the package:
  如上所述，PostgreSQL 管理员指南是一个很好的资源。 `postgresql-doc` 该指南也可在包装中找到。在终端中执行以下命令以安装软件包：

  ```bash
  sudo apt install postgresql-doc
  ```

  This package provides further manpages on PostgreSQL  “dblink” and “server  programming interface” as well as the upstream HTML guide. To view the  guide enter `xdg-open /usr/share/doc/postgresql-doc-*/html/index.html` or point your browser at it.
  该软件包提供了有关PostgreSQL“dblink”和“服务器编程接口”的更多手册页以及上游HTML指南。要查看指南，请输入 `xdg-open /usr/share/doc/postgresql-doc-*/html/index.html` 或将浏览器指向它。

- For general SQL information see the O’Reilly books [Getting Started with SQL: A Hands-On Approach for Beginners](http://shop.oreilly.com/product/0636920044994.do) by Thomas Nield as an entry point and [SQL in a Nutshell](http://shop.oreilly.com/product/9780596518851.do) as a quick reference.
  有关一般 SQL 信息，请参阅 O'Reilly 所著的 Thomas Nield 合著的 Getting Started with SQL： A  Hands-On Approach for Beginners 作为切入点，以及 SQL in a Nutshell 作为快速参考。

------





    
    `varchar(80)`指定了一个可以存储最长 80 个字符的任意字符串的数据类型。`int`是普通的整数类型。`real`是一种用于存储单精度浮点数的类型。   

​    PostgreSQL支持标准的SQL类型`int`、`smallint`、`real`、`double precision`、`char(*`N`*)`、`varchar(*`N`*)`、`date`、`time`、`timestamp`和`interval`，还支持其他的通用功能的类型和丰富的几何类型。PostgreSQL中可以定制任意数量的用户定义数据类型。因而类型名并不是语法关键字，除了SQL标准要求支持的特例外。   

# PostgreSQL 连接(JOIN)

PostgreSQL JOIN 子句用于把来自两个或多个表的行结合起来，基于这些表之间的共同字段。

在 PostgreSQL  中，JOIN 有五种连接类型：

- CROSS JOIN ：交叉连接
- INNER JOIN：内连接
- LEFT OUTER JOIN：左外连接
- RIGHT OUTER JOIN：右外连接
- FULL OUTER JOIN：全外连接

接下来让我们创建两张表 **COMPANY** 和 **DEPARTMENT**。

### 实例

创建 COMPANY 表（[下载 COMPANY SQL 文件](https://static.runoob.com/download/company.sql) ），数据内容如下：

```
runoobdb# select * from COMPANY;
 id | name  | age | address   | salary
----+-------+-----+-----------+--------
  1 | Paul  |  32 | California|  20000
  2 | Allen |  25 | Texas     |  15000
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
  6 | Kim   |  22 | South-Hall|  45000
  7 | James |  24 | Houston   |  10000
(7 rows)
```

我们往表里添加几条数据：

```
INSERT INTO COMPANY VALUES (8, 'Paul', 24, 'Houston', 20000.00);
INSERT INTO COMPANY VALUES (9, 'James', 44, 'Norway', 5000.00);
INSERT INTO COMPANY VALUES (10, 'James', 45, 'Texas', 5000.00);
```

此时，COMPANY 表的记录如下：

```
 id | name  | age | address      | salary
 ----+-------+-----+--------------+--------
   1 | Paul  |  32 | California   |  20000
   2 | Allen |  25 | Texas        |  15000
   3 | Teddy |  23 | Norway       |  20000
   4 | Mark  |  25 | Rich-Mond    |  65000
   5 | David |  27 | Texas        |  85000
   6 | Kim   |  22 | South-Hall   |  45000
   7 | James |  24 | Houston      |  10000
   8 | Paul  |  24 | Houston      |  20000
   9 | James |  44 | Norway       |   5000
  10 | James |  45 | Texas        |   5000
(10 rows)
```

创建一张 DEPARTMENT 表，添加三个字段：

```
CREATE TABLE DEPARTMENT(
   ID INT PRIMARY KEY      NOT NULL,
   DEPT           CHAR(50) NOT NULL,
   EMP_ID         INT      NOT NULL
);
```

向 DEPARTMENT 表插入三条记录：

```
INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (1, 'IT Billing', 1 );

INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (2, 'Engineering', 2 );

INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (3, 'Finance', 7 );
```

此时，DEPARTMENT 表的记录如下：

```
 id | dept        | emp_id
----+-------------+--------
  1 | IT Billing  |  1
  2 | Engineering |  2
  3 | Finance     |  7
```

------

## 交叉连接

交叉连接（CROSS JOIN）把第一个表的每一行与第二个表的每一行进行匹配。如果两个输入表分别有 x 和 y 行，则结果表有 x*y 行。

由于交叉连接（CROSS JOIN）有可能产生非常大的表，使用时必须谨慎，只在适当的时候使用它们。

下面是 CROSS JOIN 的基础语法：

```
SELECT ... FROM table1 CROSS JOIN table2 ...
```

基于上面的表，我们可以写一个交叉连接（CROSS JOIN），如下所示：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY CROSS JOIN DEPARTMENT;
```

得到结果如下：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY CROSS JOIN DEPARTMENT;
 emp_id | name  |       dept
--------+-------+--------------------
      1 | Paul  | IT Billing
      1 | Allen | IT Billing
      1 | Teddy | IT Billing
      1 | Mark  | IT Billing
      1 | David | IT Billing
      1 | Kim   | IT Billing
      1 | James | IT Billing
      1 | Paul  | IT Billing
      1 | James | IT Billing
      1 | James | IT Billing
      2 | Paul  | Engineering
      2 | Allen | Engineering
      2 | Teddy | Engineering
      2 | Mark  | Engineering
      2 | David | Engineering
      2 | Kim   | Engineering
      2 | James | Engineering
      2 | Paul  | Engineering
      2 | James | Engineering
      2 | James | Engineering
      7 | Paul  | Finance
```

------

## 内连接

内连接（INNER JOIN）根据连接谓词结合两个表（table1 和 table2）的列值来创建一个新的结果表。查询会把 table1 中的每一行与 table2  中的每一行进行比较，找到所有满足连接谓词的行的匹配对。

当满足连接谓词时，A 和 B 行的每个匹配对的列值会合并成一个结果行。

内连接（INNER JOIN）是最常见的连接类型，是默认的连接类型。

INNER 关键字是可选的。

下面是内连接（INNER JOIN）的语法：

```
SELECT table1.column1, table2.column2...
FROM table1
INNER JOIN table2
ON table1.common_filed = table2.common_field;
```

基于上面的表，我们可以写一个内连接，如下所示：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT ON COMPANY.ID = DEPARTMENT.EMP_ID;
 emp_id | name  |        dept
--------+-------+--------------
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
(3 rows)
```

------

## 左外连接

外部连接是内部连接的扩展。SQL 标准定义了三种类型的外部连接: LEFT、RIGHT 和 FULL, PostgreSQL 支持所有这些。

对于左外连接，首先执行一个内连接。然后，对于表 T1 中不满足表 T2 中连接条件的每一行，其中 T2 的列中有 null 值也会添加一个连接行。因此，连接的表在 T1 中每一行至少有一行。

下面是左外连接（ LEFT OUTER JOIN ）的基础语法：

```
SELECT ... FROM table1 LEFT OUTER JOIN table2 ON conditional_expression ...
```

基于上面两张表，我们可以写个左外连接，如下：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY LEFT OUTER JOIN DEPARTMENT ON COMPANY.ID = DEPARTMENT.EMP_ID;
 emp_id | name  |      dept
--------+-------+----------------
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
        | James | 
        | David | 
        | Paul  | 
        | Kim   | 
        | Mark  | 
        | Teddy | 
        | James | 
(10 rows)
```

------

## 右外连接

首先，执行内部连接。然后，对于表T2中不满足表T1中连接条件的每一行，其中T1列中的值为空也会添加一个连接行。这与左联接相反;对于T2中的每一行，结果表总是有一行。

下面是右外连接（ RIGHT OUT JOIN）的基本语法：

```
SELECT ... FROM table1 RIGHT OUTER JOIN table2 ON conditional_expression ...
```

基于上面两张表，我们建立一个右外连接：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY RIGHT OUTER JOIN DEPARTMENT ON COMPANY.ID = DEPARTMENT.EMP_ID;
 emp_id | name  |    dept
--------+-------+-----------------
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
(3 rows)
```

------

## 外连接

首先，执行内部连接。然后，对于表 T1 中不满足表 T2 中任何行连接条件的每一行，如果 T2 的列中有 null 值也会添加一个到结果中。此外，对于 T2 中不满足与 T1 中的任何行连接条件的每一行，将会添加 T1 列中包含 null 值的到结果中。

下面是外连接的基本语法：

```
SELECT ... FROM table1 FULL OUTER JOIN table2 ON conditional_expression ...
```

基于上面两张表，可以建立一个外连接：

```
runoobdb=# SELECT EMP_ID, NAME, DEPT FROM COMPANY FULL OUTER JOIN DEPARTMENT ON COMPANY.ID = DEPARTMENT.EMP_ID;
 emp_id | name  |      dept
--------+-------+-----------------
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
        | James | 
        | David | 
        | Paul  | 
        | Kim   | 
        | Mark  | 
        | Teddy | 
        | James | 
(10 rows)
```

# PostgreSQL UNION 操作符

PostgreSQL UNION 操作符合并两个或多个 SELECT 语句的结果。

UNION 操作符用于合并两个或多个 SELECT 语句的结果集。

请注意，UNION 内部的每个 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每个 SELECT 语句中的列的顺序必须相同。

### 语法

UNIONS 基础语法如下：

```
SELECT column1 [, column2 ]
FROM table1 [, table2 ]
[WHERE condition]

UNION

SELECT column1 [, column2 ]
FROM table1 [, table2 ]
[WHERE condition]
```

这里的条件语句可以根据您的需要设置任何表达式。

### 实例

创建 COMPANY 表（[下载 COMPANY SQL 文件](https://static.runoob.com/download/company.sql) ），数据内容如下：

```
runoobdb# select * from COMPANY;
 id | name  | age | address   | salary
----+-------+-----+-----------+--------
  1 | Paul  |  32 | California|  20000
  2 | Allen |  25 | Texas     |  15000
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
  6 | Kim   |  22 | South-Hall|  45000
  7 | James |  24 | Houston   |  10000
(7 rows)
```

创建 DEPARTMENT 表（[下载 DEPARTMENT SQL 文件](https://static.runoob.com/download/department.sql) ），数据内容如下：

```
runoobdb=# SELECT * from DEPARTMENT;
 id | dept        | emp_id
----+-------------+--------
  1 | IT Billing  |      1
  2 | Engineering |      2
  3 | Finance     |      7
  4 | Engineering |      3
  5 | Finance     |      4
  6 | Engineering |      5
  7 | Finance     |      6
(7 rows)
```

现在，我们在 SELECT 语句中使用 UNION  子句将两张表连接起来，如下所示：

```
SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID
   UNION
SELECT EMP_ID, NAME, DEPT FROM COMPANY LEFT OUTER JOIN DEPARTMENT
    ON COMPANY.ID = DEPARTMENT.EMP_ID;
```

得到结果如下：

```
 emp_id | name  |  dept
--------+-------+--------------
      5 | David | Engineering
      6 | Kim   | Finance
      2 | Allen | Engineering
      3 | Teddy | Engineering
      4 | Mark  | Finance
      1 | Paul  | IT Billing
      7 | James | Finance
(7 rows)
```

------

## UNION ALL 子句

UNION ALL 操作符可以连接两个有重复行的 SELECT 语句，默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。

### 语法

UINON ALL 子句基础语法如下：

```
SELECT column1 [, column2 ]
FROM table1 [, table2 ]
[WHERE condition]

UNION ALL

SELECT column1 [, column2 ]
FROM table1 [, table2 ]
[WHERE condition]
```

这里的条件语句可以根据您的需要设置任何表达式。

### 实例

现在，让我们把上面提到的两张表用 SELECT 语句结合 UNION ALL 子句连接起来：

```
SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID
   UNION ALL
SELECT EMP_ID, NAME, DEPT FROM COMPANY LEFT OUTER JOIN DEPARTMENT
    ON COMPANY.ID = DEPARTMENT.EMP_ID;
```

得到结果如下：

```
 emp_id | name  | dept
--------+-------+--------------
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
      3 | Teddy | Engineering
      4 | Mark  | Finance
      5 | David | Engineering
      6 | Kim   | Finance
      1 | Paul  | IT Billing
      2 | Allen | Engineering
      7 | James | Finance
      3 | Teddy | Engineering
      4 | Mark  | Finance
      5 | David | Engineering
      6 | Kim   | Finance
(14 rows)
```

# PostgreSQL NULL 值

NULL 值代表遗漏的未知数据。

默认地，表的列可以存放 NULL 值。

本章讲解 IS NULL 和 IS NOT NULL 操作符。

### 语法

当创建表时，NULL 的基本语法如下：

```
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);
```

这里，NOT NULL 表示强制字段始终包含值。这意味着，如果不向字段添加值，就无法插入新记录或者更新记录。

具有 NULL 值的字段表示在创建记录时可以留空。

在查询数据时，NULL  值可能会导致一些问题，因为一个未知的值去与其他任何值比较，结果永远是未知的。

另外无法比较 NULL 和 0，因为它们是不等价的。

### 实例

### 实例

创建 COMPANY 表（[下载 COMPANY SQL 文件](https://static.runoob.com/download/company.sql) ），数据内容如下：

```
runoobdb# select * from COMPANY;
 id | name  | age | address   | salary
----+-------+-----+-----------+--------
  1 | Paul  |  32 | California|  20000
  2 | Allen |  25 | Texas     |  15000
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
  6 | Kim   |  22 | South-Hall|  45000
  7 | James |  24 | Houston   |  10000
(7 rows)
```

接下来我们用 UPDATE 语句把几个可设置为空的字段设置为 NULL ：

```
runoobdb=# UPDATE COMPANY SET ADDRESS = NULL, SALARY = NULL where ID IN(6,7);
```

现在 COMPANY 表长这样：：

```
runoobdb=# select * from company;
 id | name  | age |         address     | salary 
----+-------+-----+---------------------+--------
  1 | Paul  |  32 | California          |  20000
  2 | Allen |  25 | Texas               |  15000
  3 | Teddy |  23 | Norway              |  20000
  4 | Mark  |  25 | Rich-Mond           |  65000
  5 | David |  27 | Texas               |  85000
  6 | Kim   |  22 |                     |       
  7 | James |  24 |                     |       
(7 rows)
```

**IS NOT NULL**

现在，我们用 IS NOT NULL 操作符把所有 SALARY（薪资） 值不为空的记录列出来：

```
runoobdb=# SELECT  ID, NAME, AGE, ADDRESS, SALARY FROM COMPANY WHERE SALARY IS NOT NULL;
```

得到结果如下：

```
 id | name  | age | address    | salary
----+-------+-----+------------+--------
  1 | Paul  |  32 | California |  20000
  2 | Allen |  25 | Texas      |  15000
  3 | Teddy |  23 | Norway     |  20000
  4 | Mark  |  25 | Rich-Mond  |  65000
  5 | David |  27 | Texas      |  85000
(5 rows)
```

**IS NULL**

IS NULL 用来查找为 NULL 值的字段。

下面是 IS NULL 操作符的用法，列出 SALARY（薪资） 值为空的记录：

```
runoobdb=#  SELECT  ID, NAME, AGE, ADDRESS, SALARY FROM COMPANY WHERE SALARY IS NULL;
```

得到结果如下：

```
id | name  | age | address | salary
----+-------+-----+---------+--------
  6 | Kim   |  22 |         |
  7 | James |  24 |         |
(2 rows)
```

# PostgreSQL 别名

我们可以用 SQL 重命名一张表或者一个字段的名称，这个名称就叫着该表或该字段的别名。

创建别名是为了让表名或列名的可读性更强。

SQL 中 使用 **AS** 来创建别名。

### 语法

表的别名语法:

```
SELECT column1, column2....
FROM table_name AS alias_name
WHERE [condition];
```

列的别名语法:

```
SELECT column_name AS alias_name
FROM table_name
WHERE [condition];
```

### 实例

创建 COMPANY 表（[下载 COMPANY SQL 文件](https://static.runoob.com/download/company.sql) ），数据内容如下：

```
runoobdb# select * from COMPANY;
 id | name  | age | address   | salary
----+-------+-----+-----------+--------
  1 | Paul  |  32 | California|  20000
  2 | Allen |  25 | Texas     |  15000
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
  6 | Kim   |  22 | South-Hall|  45000
  7 | James |  24 | Houston   |  10000
(7 rows)
```

创建 DEPARTMENT 表（[下载 COMPANY SQL 文件](https://static.runoob.com/download/department.sql) ），数据内容如下：

```
runoobdb=# SELECT * from DEPARTMENT;
 id | dept        | emp_id
----+-------------+--------
  1 | IT Billing  |      1
  2 | Engineering |      2
  3 | Finance     |      7
  4 | Engineering |      3
  5 | Finance     |      4
  6 | Engineering |      5
  7 | Finance     |      6
(7 rows)
```

下面我们分别用 C 和 D 表示 COMPANY 表和 DEPAERMENT 表的别名：

```
runoobdb=# SELECT C.ID, C.NAME, C.AGE, D.DEPT FROM COMPANY AS C, DEPARTMENT AS D WHERE  C.ID = D.EMP_ID;
```

得到结果如下：

```
 id | name  | age |  dept
----+-------+-----+------------
  1 | Paul  |  32 | IT Billing
  2 | Allen |  25 | Engineering
  7 | James |  24 | Finance
  3 | Teddy |  23 | Engineering
  4 | Mark  |  25 | Finance
  5 | David |  27 | Engineering
  6 | Kim   |  22 | Finance
(7 rows)
```

下面，我们用 COMPANY_ID 表示 ID 列，COMPANY_NAME 表示 NAME 列，来展示列别名的用法：

```
runoobdb=# SELECT C.ID AS COMPANY_ID, C.NAME AS COMPANY_NAME, C.AGE, D.DEPT  FROM COMPANY AS C, DEPARTMENT AS D WHERE  C.ID = D.EMP_ID;
```

得到结果如下：

```
company_id | company_name | age | dept
------------+--------------+-----+------------
      1     | Paul         |  32 | IT Billing
      2     | Allen        |  25 | Engineering
      7     | James        |  24 | Finance
      3     | Teddy        |  23 | Engineering
      4     | Mark         |  25 | Finance
      5     | David        |  27 | Engineering
      6     | Kim          |  22 | Finance
(7 rows)
```

# PostgreSQL 索引

索引是加速搜索引擎检索数据的一种特殊表查询。简单地说，索引是一个指向表中数据的指针。一个数据库中的索引与一本书的索引目录是非常相似的。

拿汉语字典的目录页（索引）打比方，我们可以按拼音、笔画、偏旁部首等排序的目录（索引）快速查找到需要的字。

索引有助于加快 SELECT 查询和 WHERE 子句，但它会减慢使用 UPDATE 和 INSERT 语句时的数据输入。索引可以创建或删除，但不会影响数据。

使用 CREATE INDEX 语句创建索引，它允许命名索引，指定表及要索引的一列或多列，并指示索引是升序排列还是降序排列。

索引也可以是唯一的，与 UNIQUE 约束类似，在列上或列组合上防止重复条目。

### CREATE INDEX 命令

CREATE INDEX （创建索引）的语法如下：

```
CREATE INDEX index_name ON table_name;
```

### 索引类型

**单列索引**

单列索引是一个只基于表的一个列上创建的索引，基本语法如下：

```
CREATE INDEX index_name
ON table_name (column_name);
```

**组合索引**

组合索引是基于表的多列上创建的索引，基本语法如下：

```
CREATE INDEX index_name
ON table_name (column1_name, column2_name);
```

不管是单列索引还是组合索引，该索引必须是在 WHERE 子句的过滤条件中使用非常频繁的列。

如果只有一列被使用到，就选择单列索引，如果有多列就使用组合索引。

**唯一索引**

使用唯一索引不仅是为了性能，同时也为了数据的完整性。唯一索引不允许任何重复的值插入到表中。基本语法如下：

```
CREATE UNIQUE INDEX index_name
on table_name (column_name);
```

**局部索引**

局部索引 是在表的子集上构建的索引；子集由一个条件表达式上定义。索引只包含满足条件的行。基础语法如下：

```
CREATE INDEX index_name
on table_name (conditional_expression);
```

**隐式索引**

隐式索引 是在创建对象时，由数据库服务器自动创建的索引。索引自动创建为主键约束和唯一约束。

### 实例

下面实例将在 COMPANY 表的 SALARY 列上创建索引：

```
# CREATE INDEX salary_index ON COMPANY (salary);
```

现在，用  **\d company** 命令列出 COMPANY 表的所有索引：

```
# \d company
```

得到的结果如下，company_pkey 是隐式索引 ，是表创建表时创建的：

```
runoobdb=# \d company
                  Table "public.company"
 Column  |     Type      | Collation | Nullable | Default 
---------+---------------+-----------+----------+---------
 id      | integer       |           | not null | 
 name    | text          |           | not null | 
 age     | integer       |           | not null | 
 address | character(50) |           |          | 
 salary  | real          |           |          | 
Indexes:
    "company_pkey" PRIMARY KEY, btree (id)
    "salary_index" btree (salary)
```

你可以使用 \di 命令列出数据库中所有索引：

```
runoobdb=# \di
                    List of relations
 Schema |      Name       | Type  |  Owner   |   Table    
--------+-----------------+-------+----------+------------
 public | company_pkey    | index | postgres | company
 public | department_pkey | index | postgres | department
 public | salary_index    | index | postgres | company
(3 rows)
```

### DROP INDEX （删除索引）

一个索引可以使用 PostgreSQL 的 DROP 命令删除。

```
DROP INDEX index_name;
```

您可以使用下面的语句来删除之前创建的索引：

```
# DROP INDEX salary_index;
```

删除后，可以看到 salary_index 已经在索引的列表中被删除：

```
runoobdb=# \di
                    List of relations
 Schema |      Name       | Type  |  Owner   |   Table    
--------+-----------------+-------+----------+------------
 public | company_pkey    | index | postgres | company
 public | department_pkey | index | postgres | department
(2 rows)
```

### 什么情况下要避免使用索引？

虽然索引的目的在于提高数据库的性能，但这里有几个情况需要避免使用索引。

使用索引时，需要考虑下列准则：

- 索引不应该使用在较小的表上。
- 索引不应该使用在有频繁的大批量的更新或插入操作的表上。
- 索引不应该使用在含有大量的 NULL 值的列上。
- 索引不应该使用在频繁操作的列上。