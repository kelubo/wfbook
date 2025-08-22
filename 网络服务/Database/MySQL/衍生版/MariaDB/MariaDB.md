# MariaDB

[TOC]

## 概述

**MariaDB** 服务器是一个基于 **MySQL** 技术的开源、快速、强大的数据库服务器。

**MariaDB** 是一个关系型数据库，它将数据转换为结构化信息，并为访问数据提供 SQL 接口。它包括多种存储引擎和插件，以及地理信息系统(GIS)和 JavaScript 对象表示法(JSON)功能。

MariaDB 相对于 MYSQL 来讲在功能上有很多扩展特性，比如微秒的支持、线程池、子查询优化、组提交、进度报告等。 	

## 安装

**Ubuntu**  

```bash
sudo apt install mariadb-server
sudo systemctl start mysql.service
sudo systemctl enable mysql.service
```

**CentOS**

```bash
dnf install mariadb-server
systemctl enable --now mariadb.service
```

防火墙

```bash
firewall-cmd --permanent --add-service=mysql
firewall-cmd --reload
```

## 使用容器在单个主机上运行多个 MariaDB 和 MySQL 实例

如果从软件包安装，则只能运行这些服务中的一个，且在同一主机上只运行一个版本。另外，还可以在容器中运行服务来配置以下情况： 		

- 希望在同一主机上运行多个 MariaDB 或 MySQL 实例。 				
- 需要在同一主机上运行 MariaDB 和 MySQL。

**流程**

1. 使用红帽客户门户网站帐户对 `registry.redhat.io` registry 进行身份验证：

   ```bash
   podman login registry.redhat.io
   ```

   如果已登录到容器注册中心，请跳过这一步。

2. 启动要使用的容器： 

   > 重要：
   >
   > 容器名称和两个数据库服务器的主机端口必须不同。

   * MariaDB 10.11 ：

     ```bash
     podman run -d --name <container_name_1> -e MYSQL_ROOT_PASSWORD=<password> -p <host_port_1>:3306 rhel10/mariadb-1011
     ```

   * MySQL 8.4: 

     ```bash
     podman run -d --name <container_name_2> -e MYSQL_ROOT_PASSWORD=<password> -p <host_port_2>:3306 rhel10/mysql-84
     ```

3. 要确保客户端可以访问网络上的数据库服务器，请在防火墙中打开主机端口：

   ```bash
   firewall-cmd --permanent --add-port={<host_port_1>/tcp,<host_port_2>/tcp,...}
   firewall-cmd --reload
   ```

**验证**

1. 连接到数据库服务器，并以 root 用户身份登录： 

   ```bash
   mysql -u root -p -h localhost -P <host_port> --protocol tcp
   ```

2. 可选：显示正在运行的容器的信息：

   ```bash
   podman ps
   ```

## 初始化

1. 设定root用户密码。
2. 删除匿名帐号。
3. 禁止root用户从远程登陆。
4. 删除test数据库并取消对其的访问权限。
5. 刷新授权表，让初始化后的设定立即生效。

```bash
mysql_secure_installation
# 或者 mariadb-secure-installation

Enter current password for root (enter for none): 当前数据库密码为空，直接敲击回车。
Set root password? [Y/n] Y
New password: 输入要为root用户设置的数据库密码。
Re-enter new password: 重复再输入一次密码。
Remove anonymous users? [Y/n] y（删除匿名帐号）
Disallow root login remotely? [Y/n] y(禁止root用户从远程登陆)
Remove test database and access to it? [Y/n] y(删除test数据库并取消对其的访问权限)
Reload privilege tables now? [Y/n] y(刷新授权表，让初始化后的设定立即生效)
```

## 配置网络访问

如果网络中的客户端需要远程访问 MariaDB 服务器，必须将 MariaDB 服务配置为侦听对应的接口。

1. 编辑 `/etc/my.cnf.d/mariadb-server.cnf` 文件的 `[mysqld]` 部分。

   * `bind-address` - 是服务器监听的地址。可能的选项有： 			
     * 主机名 								
     * IPv4 地址 								
     * IPv6 地址 								

   - 								`skip-networking` - 控制服务器是否监听 TCP/IP 连接。可能的值有： 						
     - 										0 - 监听所有客户端 								
     - 										1 - 只监听本地客户端 								
   - 								`port` - 监听 TCP/IP 连接的端口。 						

2. 						重启 `mariadb` 服务： 				

   ```bash
   systemctl restart mariadb.service
   ```


## mysql命令

```mariadb
切换回root用户登陆数据库并进入到mysql数据库中
[root@linuxprobe ~]# mysql -u root -p
MariaDB [(none)]> use mysql;
```

## SQL

```mariadb
用法                                                      	作用
=================================================================================
CREATE database 数据库名称;                                 	  创建新的数据库。
DESCRIBE 表单名称;                                             描述表单。
UPDATE 表单名称 SET attribute=新值 WHERE attribute > 原始值;    更新表单中的数据。
USE 数据库名称;                                                指定使用的数据库。
SHOW databases; 	                                         显示当前已有的数据库。
SHOW tables; 	                                             显示当前数据库中的表单。
SELECT * FROM 表单名称; 	                                   从表单中选中某个记录值。
DELETE FROM 表单名 WHERE attribute=值; 	                      从表单中删除某个记录值。
```


    创建新的数据库表单：
    
    MariaDB [linuxprobe]> create table mybook (name char(15),price int,pages int);
    Query OK, 0 rows affected (0.16 sec)
    
    查看表单的结构描述：
    
    MariaDB [linuxprobe]> describe mybook;
    +-------+----------+------+-----+---------+-------+
    | Field | Type     | Null | Key | Default | Extra |
    +-------+----------+------+-----+---------+-------+
    | name  | char(15) | YES  |     | NULL    |       |
    | price | int(11)  | YES  |     | NULL    |       |
    | pages | int(11)  | YES  |     | NULL    |       |
    +-------+----------+------+-----+---------+-------+
    3 rows in set (0.02 sec)
    
    18.3.3 管理表单数据
    
    向表单内插入新的书籍数据：
    
    MariaDB [linuxprobe]> INSERT INTO mybook(name,price,pages) VALUES('linuxprobe','60',518);
    Query OK, 1 row affected (0.00 sec)
    
    查看表单中的数据值：
    
    MariaDB [linuxprobe]> select * from mybook;
    +------------+-------+-------+
    | name       | price | pages |
    +------------+-------+-------+
    | linuxprobe |    60 |   518 |
    +------------+-------+-------+
    1 rows in set (0.01 sec)
    
    将价格修改为55元：
    
    MariaDB [linuxprobe]> update mybook set price=55 ;
    Query OK, 1 row affected (0.00 sec)
    Rows matched: 1  Changed: 1  Warnings: 0
    
    只看书籍的名字和价格：
    
    MariaDB [linuxprobe]> select name,price  from mybook;
    +------------+-------+
    | name       | price |
    +------------+-------+
    | linuxprobe |    55 |
    +------------+-------+
    1 row in set (0.00 sec)
    
    删除书籍表单中的内容：
    
    MariaDB [linuxprobe]> delete from mybook;
    Query OK, 1 row affected (0.01 sec)
    MariaDB [linuxprobe]> select * from mybook;
    Empty set (0.00 sec)
    
    连续加入4条书籍记录值：
    
    MariaDB [linuxprobe]> INSERT INTO mybook(name,price,pages) VALUES('linuxprobe1','30',518);
    Query OK, 1 row affected (0.05 sec)
    MariaDB [linuxprobe]> INSERT INTO mybook(name,price,pages) VALUES('linuxprobe2','50',518);
    Query OK, 1 row affected (0.05 sec)
    MariaDB [linuxprobe]> INSERT INTO mybook(name,price,pages) VALUES('linuxprobe3','80',518);
    Query OK, 1 row affected (0.01 sec)
    MariaDB [linuxprobe]> INSERT INTO mybook(name,price,pages) VALUES('linuxprobe4','100',518);
    Query OK, 1 row affected (0.00 sec)
    
    where命令用于在数据库匹配查询的条件，可用的条件有：
    参数 	作用
    = 	相等。
    <>或!= 	不相等。
    > 	大于。
    < 	小于。
    >= 	大于或等于。
    <= 	小于或等于。
    BETWEEN 	在某个范围内。
    LIKE 	搜索一个例子。
    IN 	在列中搜索多个值。


    查看价格大于75元的书籍：
    
    MariaDB [linuxprobe]> select * from mybook where price>75;
    +-------------+-------+-------+
    | name        | price | pages |
    +-------------+-------+-------+
    | linuxprobe3 |    80 |   518 |
    | linuxprobe4 |   100 |   518 |
    +-------------+-------+-------+
    2 rows in set (0.06 sec)
    
    搜索价格不等于80元的书籍：
    
    MariaDB [linuxprobe]> select * from mybook where price!=80;
    +-------------+-------+-------+
    | name | price | pages |
    +-------------+-------+-------+
    | linuxprobe1 | 30 | 518 |
    | linuxprobe2 | 50 | 518 |
    | linuxprobe4 | 100 | 518 |
    +-------------+-------+-------+
    3 rows in set (0.01 sec)


​    
​    
​    删除书籍数据库：
​    
​    MariaDB [linuxprobe]> drop database linuxprobe;
​    Query OK, 1 row affected (0.04 sec)
​    MariaDB [(none)]> show databases;
​    +--------------------+
​    | Database           |
​    +--------------------+
​    | information_schema |
​    | mysql              |
​    | performance_schema |
​    +--------------------+
​    3 rows in set (0.02 sec)
​    
​    创建一个空的数据库：
​    
​    MariaDB [(none)]> create database linuxprobe;
​    Query OK, 1 row affected (0.00 sec)
​    
​    导入刚刚备份的数据库：
​    
​    [root@linuxprobe ~]# mysql -u root -p linuxprobe < /root/linuxprobeDB.dump
​    Enter password:
​    
​    果然又看到了刚刚创建的mybook表单：
​    
​    [root@linuxprobe ~]# mysql -u root -p
​    MariaDB [(none)]> use linuxprobe;
​    Reading table information for completion of table and column names
​    You can turn off this feature to get a quicker startup with -A
​    Database changed
​    MariaDB [linuxprobe]> show tables;
​    +----------------------+
​    | Tables_in_linuxprobe |
​    +----------------------+
​    | mybook               |
​    +----------------------+
​    1 row in set (0.05 sec)

​    



使用root用户登陆到数据库中：

[root@linuxprobe ~]# mysql -u root -p
Enter password: 此处输入root用户在数据库中的密码。
Welcome to the MariaDB monitor. Commands end with ; or \g.
Your MariaDB connection id is 5
Server version: 5.5.35-MariaDB MariaDB Server
Copyright (c) 2000, 2013, Oracle, Monty Program Ab and others.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]>

查看当前已有的数据库：

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.01 sec)

修改当前用户在数据库中的密码（示例中的密码为redhat）：

MariaDB [(none)]> set password = password('redhat');
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> exit
Bye

使用旧的密码将不能再登陆到数据库：

[root@linuxprobe ~]# mysql -u root -p
Enter password:
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)

18.3 管理数据库与表单数据

关系型数据库（DataBase）是由一个或多个数据表单(Table)组成的，数据表单则一般会保存着多个数据记录（Record）。
18.3.1 创建用户并授权

创建一个新的数据库用户：

    创建数据库用户的命令:CREATE USER 用户名@主机名 IDENTIFIED BY '密码';

MariaDB [(none)]> create user luke@localhost IDENTIFIED BY 'linuxprobe';
Query OK, 0 rows affected (0.00 sec)

进入到mysql数据库中：

MariaDB [(none)]> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

查看新创建的用户、主机、姓名与密码信息：

MariaDB [mysql]> select host,user,password from user where user="luke";
+-----------+------+-------------------------------------------+
| host      | user | password                                  |
+-----------+------+-------------------------------------------+
| localhost | luke | *55D9962586BE75F4B7D421E6655973DB07D6869F |
+-----------+------+-------------------------------------------+
1 row in set (0.00 sec)

退出数据库后使用新用户登陆：

MariaDB [mysql]> exit
Bye
[root@linuxprobe ~]# mysql -u luke -p
Enter password: 此处输入luke用户的数据库密码
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 6
Server version: 5.5.35-MariaDB MariaDB Server
Copyright (c) 2000, 2013, Oracle, Monty Program Ab and others.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

此时只能查看到一个数据库：

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
+--------------------+
1 row in set (0.03 sec)

数据库GRANT命令的授权操作常用方案：
命令 	作用
GRANT 权限 ON 数据库.表单名称 TO 用户名@主机名 	对某个特定数据库中的特定表单给予授权。
GRANT 权限 ON 数据库.* TO 用户名@主机名 	对某个特定数据库中的所有表单给予授权。
GRANT 权限 ON *.* TO 用户名@主机名 	对所有数据库及所有表单给予授权。
GRANT 权限1,权限2 ON 数据库.* TO 用户名@主机名 	对某个数据库中的所有表单给予多个授权。
GRANT ALL PRIVILEGES ON *.* TO 用户名@主机名 	对所有数据库及所有表单给予全部授权，（谨慎操作）。

## 备份/还原

mysqldump命令用于备份数据库数据，格式为：

```bash
mysqldump [参数] [数据库名称]

参数 	              作用
-u 	                数据库的用户名称。
-p 	                密码提示符。
--no-data 	        只备份数据库的描述结构，而不要数据。
--lock-all-tables 	备份完成后将不再允许修改数据。
```

eg:

将书籍数据库文件（即linuxprobe）导出到家目录：

[root@linuxprobe ~]# mysqldump -u root -p linuxprobe > /root/linuxprobeDB.dump
Enter password:







The *mariadb-server* and it's client *mariadb* are the open source alternatives to *mysql-server* and *mysql*, and they share command structure. *mariadb-server* can be found running on many web servers, due to the popular [Wordpress CMS](https://wordpress.org/) which requires it. This database, though, has many other uses.

If you'd like to use this along with other tools for hardening a web server, refer back to the [Apache Hardened Web Server guide](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/). 



## Securing mariadb-server[¶](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/#securing-mariadb-server)

To strengthen the security of *mariadb-server* we need to run a script, but before we do, we need to enable and start mariadb:

```
systemctl enable mariadb
```

And then: 

```
systemctl start mariadb
```

Next, run this command:

```
mysql_secure_installation
```

This brings up a dialog:

```
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
```

Since this is a brand new installation, there is no root password set. So just hit enter here.

The next part of the dialog continues:

```
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] 
```

You absolutely *do* want to have a root password set. You'll  want to figure out what this should be and document it in a password  manager somewhere so that you can pull it up if necessary. Start by  hitting 'Enter' to accept the default "Y". This will bring up the  password dialog:

```
New password: 
Re-enter new password:
```

Enter your chosen password and then confirm it by entering it again. If this is successful, you will get the following dialog:

```
Password updated successfully!
Reloading privilege tables..
 ... Success!
```

Next the dialog deals with the anonymous user:

```
By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] 
```

The answer here is "Y" so just hit 'Enter' to accept the default.

The dialog proceeds to the section dealing with allowing the root user to login remotely:

```
... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]
```

root should only be needed locally on the machine. So accept this default as well by hitting 'Enter'.

The dialog then moves on to the 'test' database that is automatically installed with *mariadb-server*:

```
... Success!


By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] 
```

Again, the answer here is the default, so just hit 'Enter' to remove it.

Finally, the dialog ask you if you want to reload the privileges:

```
- Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] 
```

Again, simply hit 'Enter' to do this. If all goes well, you should receive this message:

```
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

MariaDB should now be ready to use.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/#conclusion)

A database server, such as *mariadb-server*, can be used for  many purposes. Because of the popularity of the Wordpress CMS, it is  often found on web servers. Before we run the database in production,  however, it is a good idea to strengthen its security. 

## 在服务器上设置 TLS 加密

默认情况下，MariaDB 使用未加密的连接。对于安全连接，在 MariaDB 服务器上启用 TLS 支持，并将客户端配置为建立加密连接。 

### 将 CA 证书、服务器证书和私钥放在服务器上

在服务器中启用 TLS 加密前，先在服务器上存储证书颁发机构 (CA) 证书、服务器证书和私钥。 			

**先决条件**

以下 Privacy Enhanced Mail (PEM) 格式的文件已复制到服务器：

- 服务器的私钥：`server.example.com.key.pem` 							
- 服务器证书：`server.example.com.crt.pem` 							
- 证书颁发机构 (CA) 证书：`ca.crt.pem` 					

**流程**

1. 将 CA 和服务器证书存储在 `/etc/pki/tls/certs/` 目录中：

   ```bash
   mv <path>/server.example.com.crt.pem /etc/pki/tls/certs/
   mv <path>/ca.crt.pem /etc/pki/tls/certs/
   ```

2. 设置 CA 和服务器证书的权限，使服务器能够读取文件： 					

   ```bash
   chmod 644 /etc/pki/tls/certs/server.example.com.crt.pem /etc/pki/tls/certs/ca.crt.pem
   ```

   由于证书是建立安全连接前通信的一部分，因此任何客户端都可以在不需要身份验证的情况下检索它们。因此，您不需要对 CA 和服务器证书文件设置严格的权限。 					

3. 将服务器的私钥存储在 `/etc/pki/tls/private/` 目录中：

   ```bash
   mv <path>/server.example.com.key.pem /etc/pki/tls/private/
   ```

4. 对服务器的私钥设置安全权限： 					

   ```bash
   chmod 640 /etc/pki/tls/private/server.example.com.key.pem
   chgrp mysql /etc/pki/tls/private/server.example.com.key.pem
   ```

   如果未授权的用户可以访问私钥，因此到服务器的连接不再是安全的。 

5. 恢复 SELinux 上下文： 			

   ```bash
   restorecon -Rv /etc/pki/tls/
   ```

### 在 MariaDB 服务器上配置 TLS

**先决条件**

- **MariaDB** 服务器已安装。 					
- `mariadb` 服务正在运行。 					
- 服务器上存在 Privacy Enhanced Mail(PEM) 格式的以下文件，并可由 `mysql` 用户读取： 					
  - 服务器的私钥：`/etc/pki/tls/private/server.example.com.key.pem` 							
  - 服务器证书：`/etc/pki/tls/certs/server.example.com.crt.pem` 							
  - 证书颁发机构(CA)证书 `/etc/pki/tls/certs/ca.crt.pem` 							
- 主题可识别名称(DN)或服务器证书中的主题备用名称(SAN)字段与服务器的主机名相匹配。 
- 如果启用了 FIPS 模式，客户端必须支持扩展主 Secret (EMS)扩展或使用 TLS 1.3。没有 EMS 的 TLS 1.2 连接会失败。					

**流程**

1. 创建 `/etc/my.cnf.d/mariadb-server-tls.cnf` 文件： 					

   1. ​									添加以下内容来配置到私钥、服务器和 CA 证书的路径： 							

      

      ```none
      [mariadb]
      ssl_key = /etc/pki/tls/private/server.example.com.key.pem
      ssl_cert = /etc/pki/tls/certs/server.example.com.crt.pem
      ssl_ca = /etc/pki/tls/certs/ca.crt.pem
      ```

   2. ​									如果您有一个证书撤销列表(CRL)，则将 **MariaDB** 服务器配置为使用它： 							

      

      ```none
      ssl_crl = /etc/pki/tls/certs/example.crl.pem
      ```

   3. ​									可选：拒绝未加密的连接尝试。要启用此功能，请附加： 							

      

      ```none
      require_secure_transport = on
      ```

   4. ​									可选：设置服务器应支持的 TLS 版本。例如，要支持 TLS 1.2 和 TLS 1.3，请附加： 							

      

      ```none
      tls_version = TLSv1.2,TLSv1.3
      ```

      ​									默认情况下，服务器支持 TLS 1.1、TLS 1.2 和 TLS 1.3。 							

2. ​							重启 `mariadb` 服务： 					

   

   ```none
   # systemctl restart mariadb
   ```

**验证**

​						要简化故障排除，请在将本地客户端配置为使用 TLS 加密之前在 **MariaDB** 服务器上执行以下步骤： 				

1. ​							验证 **MariaDB** 现在是否启用了 TLS 加密： 					

   

   ```none
   # mysql -u root -p -e "SHOW GLOBAL VARIABLES LIKE 'have_ssl';"
   +---------------+-----------------+
   | Variable_name | Value           |
   +---------------+-----------------+
   | have_ssl      | YES             |
   +---------------+-----------------+
   ```

   ​							如果 `have_ssl` 变量设置为 `yes`，则启用 TLS 加密。 					

2. ​							如果您将 **MariaDB** 服务配置为只支持特定的 TLS 版本，则显示 `tls_version` 变量： 					

   

   ```none
   # mysql -u root -p -e "SHOW GLOBAL VARIABLES LIKE 'tls_version';"
   +---------------+-----------------+
   | Variable_name | Value           |
   +---------------+-----------------+
   | tls_version   | TLSv1.2,TLSv1.3 |
   +---------------+-----------------+
   ```

**其他资源**

- ​							[将 CA 证书、服务器证书和私钥放在 MariaDB 服务器上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_placing-the-ca-certificate-server-certificate-and-private-key-on-the-mariadb-server_assembly_setting-up-tls-encryption-on-a-mariadb-server) 					

### 2.4.3. 对特定的用户帐户需要 TLS 加密连接

​					可以访问敏感数据的用户应始终使用 TLS 加密连接，以避免通过网络发送未加密的数据。 			

​					如果您无法在服务器上配置所有连接都需要安全传输(`require_secure_transport = on`)，请将单个用户帐户配置为需要 TLS 加密。 			

**先决条件**

- ​							**MariaDB** 服务器启用了 TLS 支持。 					
- ​							您配置为需要安全传输的用户已存在。 					

**流程**

1. ​							以管理员用户身份连接到 **MariaDB** 服务器： 					

   

   ```none
   # mysql -u root -p -h server.example.com
   ```

   ​							如果您的管理用户没有远程访问服务器的权限，请在 **MariaDB** 服务器上执行命令，并连接到 `localhost`。 					

2. ​							使用 `REQUIRE SSL` 子句强制用户必须使用 TLS 加密连接进行连接： 					

   

   ```none
   MariaDB [(none)]> **ALTER USER __'example__'@__'%'__ REQUIRE SSL;**
   ```

**验证**

1. ​							使用 TLS 加密，以 `example` 用户身份连接到服务器： 					

   

   ```none
   # mysql -u example -p -h server.example.com --ssl
   ...
   MariaDB [(none)]>
   ```

   ​							如果没有显示错误，且您可以访问交互式 **MariaDB** 控制台，则与 TLS 的连接成功。 					

2. ​							尝试以禁用 TLS 的 `example` 用户身份进行连接： 					

   

   ```none
   # mysql -u example -p -h server.example.com --skip-ssl
   ERROR 1045 (28000): Access denied for user 'example'@'server.example.com' (using password: YES)
   ```

   ​							服务器拒绝登录尝试，因为此用户需要 TLS，但已禁用(`--skip-ssl`)。 					

**其他资源**

- ​							[在 MariaDB 服务器上配置 TLS](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#assembly_setting-up-tls-encryption-on-a-mariadb-server_using-mariadb) 		







### 在服务器上配置 TLS

要提高安全性，请在 **MariaDB** 服务器上启用 TLS 支持。因此，客户端可以使用 TLS 加密与服务器传输数据。 			

**先决条件**

- MariaDB 服务器已安装。 					
- `mariadb` 服务正在运行。 					
- 服务器上存在 Privacy Enhanced Mail(PEM)格式的以下文件，并可由 `mysql` 用户读取： 					
  - 服务器的私钥：`/etc/pki/tls/private/server.example.com.key.pem` 							
  - 服务器证书：`/etc/pki/tls/certs/server.example.com.crt.pem` 							
  - 证书颁发机构(CA)证书 `/etc/pki/tls/certs/ca.crt.pem` 							
- 主题可识别名称(DN)或服务器证书中的主题备用名称(SAN)字段与服务器的主机名相匹配。 					

**流程**

1. 创建 `/etc/my.cnf.d/mariadb-server-tls.cnf` 文件： 					

   1. 添加以下内容来配置到私钥、服务器和 CA 证书的路径：

      ```bash
      [mariadb]
      ssl_key = /etc/pki/tls/private/server.example.com.key.pem
      ssl_cert = /etc/pki/tls/certs/server.example.com.crt.pem
      ssl_ca = /etc/pki/tls/certs/ca.crt.pem
      ```

   2. 如果您有一个证书撤销列表(CRL)，则将服务器配置为使用它：

      ```bash
      ssl_crl = /etc/pki/tls/certs/example.crl.pem
      ```

   3. 可选：拒绝未加密的连接尝试。要启用此功能，请附加：

      ```bash
      require_secure_transport = on
      ```

   4. 可选：设置服务器应支持的 TLS 版本。例如，要支持 TLS 1.2 和 TLS 1.3，请附加： 							

      ```bash
      tls_version = TLSv1.2,TLSv1.3
      ```

      默认情况下，服务器支持 TLS 1.1、TLS 1.2 和 TLS 1.3。

2. 重启 `mariadb` 服务： 					

   ```bash
   systemctl restart mariadb
   ```

**验证**

要简化故障排除，请在将本地客户端配置为使用 TLS 加密之前在 **MariaDB** 服务器上执行以下步骤： 				

1. 验证 **MariaDB** 现在是否启用了 TLS 加密： 					

   ```bash
   mysql -u root -p -e "SHOW GLOBAL VARIABLES LIKE 'have_ssl';"
   +---------------+-----------------+
   | Variable_name | Value           |
   +---------------+-----------------+
   | have_ssl      | YES             |
   +---------------+-----------------+
   ```

   如 `have_ssl` 变量设置为 `yes`，则启用 TLS 加密。 					

2. 如果您将 **MariaDB** 服务配置为只支持特定的 TLS 版本，则显示 `tls_version` 变量： 					

   ```bash
   mysql -u root -p -e "SHOW GLOBAL VARIABLES LIKE 'tls_version';"
   +---------------+-----------------+
   | Variable_name | Value           |
   +---------------+-----------------+
   | tls_version   | TLSv1.2,TLSv1.3 |
   +---------------+-----------------+
   ```

### 对特定的用户帐户需要 TLS 加密连接

可以访问敏感数据的用户应始终使用 TLS 加密连接，以避免通过网络发送未加密的数据。 			

如果您无法在服务器上配置所有连接都需要安全传输(`require_secure_transport = on`)，请将单个用户帐户配置为需要 TLS 加密。 			

**先决条件**

- **MariaDB** 服务器启用了 TLS 支持。 					
- 配置为需要安全传输的用户已存在。 					

**流程**

1. 以管理员用户身份连接到 **MariaDB** 服务器： 					

   ```bash
   mysql -u root -p -h server.example.com
   ```

   如果您的管理用户没有远程访问服务器的权限，请在 **MariaDB** 服务器上执行命令，并连接到 `localhost`。 					

2. 使用 `REQUIRE SSL` 子句强制用户必须使用 TLS 加密连接进行连接： 					

   ```sql
   MariaDB [(none)]> ALTER USER 'example'@'%' REQUIRE SSL;
   ```

**验证**

1. 使用 TLS 加密，以 `example` 用户身份连接到服务器： 					

   ```bash
   mysql -u example -p -h server.example.com --ssl
   ...
   MariaDB [(none)]>
   ```

   如果没有显示错误，且您可以访问交互式 **MariaDB** 控制台，则与 TLS 的连接成功。 					

2. 尝试以禁用 TLS 的 `example` 用户身份进行连接： 					

   ```bash
   mysql -u example -p -h server.example.com --skip-ssl
   ERROR 1045 (28000): Access denied for user 'example'@'server.example.com' (using password: YES)
   ```

   服务器拒绝登录尝试，因为此用户需要 TLS，但已禁用(`--skip-ssl`)。 					

## 在客户端中全局启用 TLS 加密

如果您的 **MariaDB** 服务器支持 TLS 加密，请将客户端配置为仅建立安全连接，并验证服务器证书。这个流程描述了如何为服务器上的所有用户启用 TLS 支持。 		

### 将客户端配置为默认使用 TLS 加密

在 RHEL 上，您可以全局配置 **MariaDB** 客户端使用 TLS 加密，并验证服务器证书中的通用名称(CN)与用户连接的主机名匹配。这可防止中间人攻击。 			

**先决条件**

- **MariaDB** 服务器启用了 TLS 支持。 					
- 如果 RHEL 不信任发布服务器证书的证书颁发机构(CA)，则 CA 证书已被复制到客户端。 					

**流程**

1. 如果 RHEL 不信任发布服务器证书的 CA： 					

   1. 将 CA 证书复制到 `/etc/pki/ca-trust/source/anchors/` 目录中： 							

      ```bash
      cp <path>/ca.crt.pem /etc/pki/ca-trust/source/anchors/
      ```

   2. 设置允许所有用户读取 CA 证书文件的权限： 							

      ```bash
      chmod 644 /etc/pki/ca-trust/source/anchors/ca.crt.pem
      ```

   3. 重建 CA 信任数据库： 							

      ```bash
      update-ca-trust
      ```

2. 使用以下内容创建 `/etc/my.cnf.d/mariadb-client-tls.cnf` 文件： 					

   ```ini
   [client-mariadb]
   ssl
   ssl-verify-server-cert
   ```

   这些设置定义 **MariaDB** 客户端使用 TLS 加密(`ssl`)，并且客户端将主机名与服务器证书中的 CN(`ssl-verify-server-cert`)进行比较。

**验证**

- 使用主机名连接到服务器，并显示服务器的状态： 					

  ```bash
  mysql -u root -p -h server.example.com -e status
  ...
  SSL:        Cipher in use is TLS_AES_256_GCM_SHA384
  ```

  如果 `SSL` 条目包含 `Cipher in use is…`，代表连接已加密。

  请注意，您在这个命令中使用的用户具有远程身份验证的权限。

  如果您连接的主机名与服务器的 TLS 证书中的主机名不匹配，则 `ssl-verify-server-cert` 参数会导致连接失败。例如，如果您连接到 `localhost` ： 					

  ```bash
  mysql -u root -p -h localhost -e status
  ERROR 2026 (HY000): SSL connection error: Validation of SSL server certificate failed
  ```

## 备份

在 Red Hat Enterprise Linux 9 中从 **MariaDB** 数据库备份数据主要有两种方法： 		

- 逻辑备份 				
- 物理备份 				

**逻辑备份** 由恢复数据所需的 SQL 语句组成。这种类型的备份以纯文本文件的形式导出信息和记录。 		

与物理备份相比，逻辑备份的主要优势在于可移植性和灵活性。数据可以在其他硬件配置上恢复，**MariaDB** 版本或数据库管理系统(DBMS)上恢复，这些系统无法进行物理备份。 		

请注意，如果 `mariadb.service` 正在运行，则可以执行逻辑备份。逻辑备份不包括日志和配置文件。 		

**物理备份**由保存内容的文件和目录副本组成。 		

与逻辑备份相比，物理备份具有以下优点： 		

- 输出更为紧凑。 				
- 备份的大小会较小。 				
- 备份和恢复速度更快。 				
- 备份包括日志和配置文件。 				

请注意，当 `mariadb.service` 没有运行或者数据库中的所有表都被锁定以防止备份期间更改时，必须执行物理备份。 		

您可以使用以下一种 **MariaDB** 备份方法，来从 **MariaDB** 数据库备份数据： 		

- 使用 `mariadb-dump` 的逻辑备份 				
- 使用 `Mariabackup` 工具的物理在线备份 				
- 文件系统备份 				
- 作为备份解决方案复制 				

### 使用 mariadb-dump 执行逻辑备份

**mariadb-dump** 客户端是一种备份实用程序，可用于转储数据库或数据库集合，用于备份或传输到其他数据库服务器。**mariadb-dump** 的输出通常由 SQL 语句组成，用于重新创建服务器表结构、生成表的数据。**mariadb-dump** 也可以以其他格式生成文件，包括 XML 和分隔的文本格式，如 CSV。 			

要执行 **mariadb-dump** 备份，您可以使用以下选项之一： 			

- 备份一个或多个所选的数据库 					
- 备份所有数据库 					
- 从一个数据库备份表子集 					

**流程**

- 要转储单个数据库，请运行： 					

  ```none
  # mariadb-dump [options] --databases db_name > backup-file.sql
  ```

- 要一次转储多个数据库，请运行： 					

  ```none
  # mariadb-dump [options] --databases db_name1 [db_name2 …] > backup-file.sql
  ```

- 要转储所有数据库，请运行： 					

  ```none
  # mariadb-dump [options] --all-databases > backup-file.sql
  ```

- 要将一个或多个转储的完整数据库加载回服务器，请运行： 					

  ```none
  # mariadb < backup-file.sql
  ```

- 要将数据库加载到远程 **MariaDB** 服务器，请运行： 					

  ```none
  # mariadb --host=remote_host < backup-file.sql
  ```

- 要从一个数据库转储表子集，请在 `mariadb-dump` 命令末尾添加所选表的列表： 					

  ```none
  # mariadb-dump [options] db_name [tbl_name …] > backup-file.sql
  ```

- 要载入从一个数据库转储的表的子集，请运行： 					

  ```none
  # mariadb db_name < backup-file.sql
  ```

  注意

  此时，*db_name* 数据库必须存在。 						

- 要查看 **mariadb-dump** 支持的选项列表，请运行： 					

  ```none
  $ mariadb-dump --help
  ```

**其他资源**

- [MariaDB 文档 - **mariadb-dump**](https://mariadb.com/kb/en/library/mysqldump/). 					

### 使用 Mariabackup 工具执行物理在线备份

**mariabackup** 是一个基于 Percona XtraBackup 技术的工具，能够执行 InnoDB、Aria 和 MyISAM 表的物理在线备份。这个工具是由 AppStream 存储库中的 `mariadb-backup` 软件包提供的。 			

**mariabackup** 支持对 **MariaDB** 服务器的全备份功能，其中包括加密和压缩的数据。 			

**先决条件**

- `mariadb-backup` 软件包已在系统中安装： 					

  ```none
  # dnf install mariadb-backup
  ```

- 您必须为 **Mariabackup** 提供要在其下运行备份的用户的凭证。您可以在命令行中或通过配置文件来提供凭证。 					
- **Mariabackup** 的用户必须具有 `RELOAD`、`LOCK TABLES` 和 `REPLICATION CLIENT` 特权。 					

要使用 **Mariabackup** 创建数据库备份，请使用以下流程： 			

**流程**

- 要在在命令行上提供凭证的同时创建备份，请运行： 					

  ```none
  $ mariabackup --backup --target-dir <backup_directory> --user <backup_user> --password <backup_passwd>
  ```

  `target-dir` 选项定义存储备份文件的目录。如果要执行全备份，目标目录必是空或者不存在。 					

  `user` 和 `password` 选项允许您配置用户名和密码。 					

- 要使用配置文件中设置的凭证创建备份： 					

  1. 在 `/etc/my.cnf.d/` 目录中创建配置文件，例如 `/etc/my.cnf.d/mariabackup.cnf`。 							

  2. 将以下行添加到新文件的 `[xtrabackup]` 或 `[mysqld]` 部分中： 

     ```none
     [xtrabackup]
     user=myuser
     password=mypassword
     ```

  3. 执行备份： 							

     ```none
     $ mariabackup --backup --target-dir <backup_directory>
     ```

重要

**mariabackup** 不读取配置文件 `[mariadb]` 部分中的选项。如果在 **MariaDB** 服务器上指定了非默认数据目录，那么您必须在配置文件的 `[xtrabackup]` 或 `[mysqld]` 部分中指定此目录，以便 **Mariabackup** 能够找到数据目录。 				

要指定非默认数据目录，请在 **MariaDB** 配置文件的 `[xtrabackup]` 或 `[mysqld]` 部分中包含以下行： 				

```none
datadir=/var/mycustomdatadir
```

### 使用 Mariabackup 工具恢复数据

备份完成后，您可以使用 `mariabackup` 命令及以下一个选项来从备份中恢复数据： 			

- `--copy-back` 允许您保存原始的备份文件。 					
- `--move-back` 将备份文件移到数据目录中，并删除原始的备份文件。 					

要使用 **Mariabackup** 工具来恢复数据，请使用以下流程： 			

**先决条件**

- 确保 `mariadb` 服务没有运行： 					

  ```none
  # systemctl stop mariadb.service
  ```

- 确保数据目录为空。 					

- **Mariabackup** 的用户必须具有 `RELOAD`、`LOCK TABLES` 和 `REPLICATION CLIENT` 特权。 					

**流程**

1. 运行 `mariabackup` 命令： 					

   - 要恢复数据并保留原始备份文件，请使用 `--copy-back` 选项： 

     ```none
     $ mariabackup --copy-back --target-dir=/var/mariadb/backup/
     ```

   - 要恢复数据并删除原始备份文件，请使用 `--move-back` 选项： 

     ```none
     $ mariabackup --move-back --target-dir=/var/mariadb/backup/
     ```

2. 修复文件权限。 					

   恢复数据库时，**Mariabackup** 会保留备份的文件和目录特权。但是，**Mariabackup** 以恢复数据库的用户和组的身份将文件写入磁盘。恢复备份后，您可能需要调整数据目录的所有者，以匹配 **MariaDB** 服务器的用户和组，通常两者都为 `mysql`。 					

   例如，要递归地将文件的所有权改为 `mysql` 用户和组： 					

   ```none
   # chown -R mysql:mysql /var/lib/mysql/
   ```

3. 启动 `mariadb` 服务： 					

   ```none
   # systemctl start mariadb.service			
   ```

### 执行文件系统备份

​					要创建 **MariaDB** 数据文件的文件系统备份，请将 **MariaDB** 数据目录的内容复制到您的备份位置。 			

​					要同时备份当前的配置或日志文件，请使用以下流程的可选步骤： 			

**流程**

1. ​							停止 `mariadb` 服务： 					

   ```none
   # systemctl stop mariadb.service
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
   # cp /var/log/mariadb/* /backup-location/logs
   ```

5. ​							启动 `mariadb` 服务： 					

   ```none
   # systemctl start mariadb.service
   ```

6. ​							将备份位置的备份数据加载到 `/var/lib/mysql` 目录时，请确保 `mysql:mysql` 是 `/var/lib/mysql` 中所有数据的所有者： 					

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

### 作为备份解决方案复制

复制是源服务器的一个替代的备份解决方案。如果源服务器复制到副本服务器，备份可以在副本上运行，而不会对源造成任何影响。当您关闭副本，并从副本备份数据时，源仍然可以运行。 			

警告

复制本身并不是一个足够的备份解决方案。复制可以防止源服务器出现硬件故障，但它不能确保防止数据的丢失。建议您将对副本的任何其他备份解决方案与此方法一起使用。 				

**其他资源**

- 有关使用 **MariaDB Galera 集群** 复制 **MariaDB** 数据库的信息说明，请参考 [使用Galera 复制 MariaDB](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#replicating-mariadb-with-galera_using-mariadb)。 					
- 有关复制作为备份解决方案的更多信息，请参阅 [MariaDB 文档](https://mariadb.com/kb/en/library/replication-as-a-backup-solution/)。 					

## 迁移到 MariaDB 10.5

在 RHEL 8 中，提供了 **MariaDB** 服务器版本 10.3 和 10.5，分别由单独的模块流提供。RHEL 9 提供 **MariaDB 10.5** 和 **MySQL 8.0。**这部分论述了从 RHEL 8 中的 **MariaDB 10.3** 版本迁移到 RHEL 9 中的 **MariaDB 10.5** 版本。 		

### MariaDB 10.3 和 MariaDB 10.5 之间的显著区别

**MariaDB 10.3** 和 **MariaDB 10.5** 之间的显著变化包括： 			

- **MariaDB** 现在默认使用 `unix_socket` 身份验证插件。该插件允许用户在通过本地 Unix 套接字文件连接到 **MariaDB** 时使用操作系统凭证。 					

- `MariaDB` 添加了以 `mariadb-*` 命名的二进制代码，`mysql*` 符号链接指向 `mariadb-*` 的二进制代码。例如，`mysqladmin`、`mysqlaccess` 和 `mysqlshow` 分别指向 `mariadb-admin`、`mariadb-access` 和 `mariadb-show` 二进制代码。 					

- `SUPER` 特权已被分成几个特权，以更好地与每个用户角色保持一致。因此，某些语句已更改了所需的权限。 					

- 在并行 `复制中，slave_parallel_mode` 现在被默认设置为 `静态`。 					

- 在 **InnoDB** 存储引擎 中，以下变量的默认值已发生变化：`innodb_adaptive_hash_index ` 变为 `OFF`，`innodb_checksum_algorithm` 变为 `full_crc32`。 					

- **MariaDB** 现在使用用于管理 **MariaDB** 命令历史记录（the `.mysql_history` 文件）的底层软件的 `libedit` 实施，而不是之前使用的 `readline` 库。此更改会影响直接使用 `.mysql_history` 文件的用户。注意 `.mysql_history` 是一个由 **MariaDB** 或 **MySQL** 应用管理的文件，用户不应直接使用该文件。人类可读的外表是巧合。 

  注意

  要提高安全性，您可以考虑不维护历史记录文件。禁用记录命令历史记录： 						

  1. 删除 `.mysql_history` 文件（如果存在的话）。 					

  2. 使用以下任一方法： 								

     - 将 `MYSQL_HISTFILE` 变量设置为 `/dev/null`，并将此设置包含在您的任何 shell 启动文件中。 										

     - 将 `.mysql_history` 文件更改为指向 `/dev/null` 的符号链接： 										

       ```none
       $ ln -s /dev/null $HOME/.mysql_history
       ```

**MariaDB Galera 集群** 已升级到版本 4，有以下显著变化： 			

- **Galera** 添加了一个新的流复制特性，其支持复制无限大小的事务。在执行流复制的过程中，集群以小片段复制事务。 					
- **Galera** 现在完全支持全球交易 ID(GTID)。 					
- `/etc/my.cnf.d/galera.cnf` 文件中的 `wsrep_on` 选项的默认值已从 `1` 改为 `0`，以防止最终用户在没有配置所需的附加选项的情况下启动 `wsrep` 复制。 					

对**MariaDB 10.5** 中 PAM 插件的更改包括： 			

- **MariaDB 10.5** 添加了可插拔验证模块(PAM)插件的一个新版本。PAM 插件版本 2.0 使用单独的 `setuid root` 助手二进制文件来执行 PAM 身份验证，这使得 **MariaDB** 可以使用其他 PAM 模块。 					
- 帮助程序二进制文件只能由 `mysql` 组中的用户执行。默认情况下，组只包含 `mysql` 用户。红帽建议管理员不要向 `mysql` 组添加更多用户，以防止无需通过这个助手工具进行节流或记录的情况下的密码猜测攻击。 					
- 在 **MariaDB 10.5** 中，可插拔验证模块(PAM)插件及其相关文件已移至新的软件包 `mariadb-pam`。因此，在不使用对 `MariaDB` 进行PAM 验证的系统中不会引入新的 `setuid root` 二进制文件。 					
- `mariadb-pam` 软件包包含两个 PAM 插件版本：版本 2.0 是默认值，版本 1.0 作为 `auth_pam_v1` 共享对象库提供。 					
- 默认情况下，`mariadb-pam` 软件包不与 **MariaDB** 服务器一起安装 。要在 **MariaDB 10.5** 中提供 PAM 身份验证插件，请手动安装 `mariadb-pam` 软件包。 					

### 从 RHEL 8 的 MariaDB 10.3 迁移到 RHEL 9 版本的 MariaDB 10.5

这个步骤描述了使用 `mariadb-upgrade` 程序从 **MariaDB 10.3** 迁移到 **MariaDB 10.5**。 			

`mariadb-upgrade` 实用程序由 `mariadb-server-utils` 子软件包提供，该子软件包作为 `mariadb-server` 软件包的依赖项安装。 			

**先决条件**

- 在执行升级前，备份存储在 **MariaDB** 数据库中的所有数据。

**流程**

1. 确定在 RHEL 9 系统中安装了 `mariadb-server` 软件包： 					

   ```none
   # dnf install mariadb-server
   ```

2. 确保 `mariadb` 服务在复制数据时没有在源和目标系统上运行：

   ```none
   # systemctl stop mariadb.service
   ```

3. 将源位置的数据复制到 RHEL 9 目标系统的 `/var/lib/mysql/` 目录中。 					

4. 对目标系统上复制的文件设置适当的权限和 SELinux 上下文： 

   ```none
   # restorecon -vr /var/lib/mysql
   ```

5. 确保 `mysql:mysql` 是 `/var/lib/mysql` 目录中所有数据的所有者： 

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

6. 调整配置，以便位于 `/etc/my.cnf.d/` 中的选项文件只包含对 **MariaDB 10.5** 有效的选项。详情请参阅 [MariaDB 10.4](https://mariadb.com/kb/en/upgrading-from-mariadb-103-to-mariadb-104/#options-that-have-changed-default-values) 和 [MariaDB 10.5](https://mariadb.com/kb/en/upgrading-from-mariadb-104-to-mariadb-105/#options-that-have-been-removed-or-renamed) 的上游文档。 					

7. 在目标系统中启动 **MariaDB** 服务器。 					

   - 在升级独立运行的数据库时： 							

     ```none
     # systemctl start mariadb.service
     ```

   - 在升级 **Galera** 集群节点时： 							

     ```none
     # galera_new_cluster
     ```

     `mariadb` 服务将自动启动。 							

8. 执行 **mariadb-upgrade** 工具来检查和修复内部表。 					

   - 在升级独立运行的数据库时： 							

     ```none
     $ mariadb-upgrade
     ```

   - 在升级 **Galera** 集群节点时： 							

     ```none
     $ mariadb-upgrade --skip-write-binlog
     ```

重要

有一些与原位升级相关的风险和已知问题。例如，一些查询可能无法正常工作，或者它们会以与升级前不同的顺序运行。有关这些风险和问题的更多信息，以及有关原位升级的常规信息，请参阅 [MariaDB 10.5 发行注记](https://mariadb.com/kb/en/release-notes-mariadb-105-series/)。 

## 使用 Galera 复制 MariaDB		

### MariaDB Galera 集群介绍

Galera 复制是基于由多个 **MariaDB** 服务器组成的同步多源 **MariaDB Galera 集群** 的创建。与传统的主/备设置不同，副本通常是只读的，**MariaDB Galera 集群** 中的节点可以是全部可写。 			

Galera 复制和 **MariaDB** 数据库之间的接口由写集复制 API(**wsrep API**) 定义的。 			

**MariaDB Galera 集群** 的主要特性是 ： 			

- 同步复制 					
- 主动-主动多源拓扑 					
- 对任何集群节点的读和写 					
- 自动成员资格控制，故障节点从集群中删除 					
- 自动节点加入 					
- 行一级的并行复制 					
- 直接客户端连接：用户可以登录到集群节点，并在复制运行时直接使用这些节点 					

同步复制意味着服务器在提交时复制事务，方法是将与事务关联的写入集合广播到集群中的每个节点。客户端（用户应用程序）直接连接到数据库管理系统(DBMS)，可以体验类似于原生 **MariaDB** 的行为。 			

同步复制保证集群中一个节点上的更改会同时在集群中的其他节点上发生。 			

因此，与异步复制相比，同步复制具有以下优势： 			

- 在特定集群节点间传播更改没有延迟 					
- 所有集群节点始终一致 					
- 如果其中一个集群节点崩溃，则不会丢失最新的更改 					
- 所有集群节点上的事务都会并行执行 					
- 整个集群的因果关系			

### 构建 MariaDB Galera 集群的组件

​					要构建 **MariaDB Galera 集群**，您必须在您的系统上安装以下软件包： 			

- ​							`mariadb-server-galera` - 包含 **MariaDB Galera 集群** 的支持文件和脚本。 					
- ​							`MariaDB-server` - 由 **MariaDB** 上游打补丁，以包含写入集复制 API(**wsrep API**)。此 API 提供 **Galera** 复制和 **MariaDB** 之间的接口。 					
- ​							`Galera` - 由 **MariaDB** 上游打补丁，以添加对 **MariaDB** 的完全支持。`galera` 软件包包含以下内容： 					
  - ​									**Galera Replication 程序库** 提供整个复制功能。 							
  - ​									**Galera Arbitrator** 工具可用作参与脑裂场景的集群成员。但是，**Galera Arbitrator** 无法参与实际的复制。 							
  - ​									**Galera Systemd 服务** 和 **Galera 打包程序脚本**，它们用于部署 Galera Arbitrator 工具。RHEL 9 提供这些文件的上游版本，位于 `/usr/lib/systemd/system/garbd.service` 和 `/usr/sbin/garb-systemd`。 			

### 部署 MariaDB Galera 集群

**先决条件**

- 安装 **MariaDB Galera Cluster** 软件包。例如： 					

  ```none
  # dnf install galera
  ```

  因此，会安装以下软件包： 					

  - `mariadb-server-galera` 							

  - `mariadb-server` 							

  - `galera` 							

    `mariadb-server-galera` 软件包将 `mariadb-server` 和 `galera` 软件包作为其依赖项。

- 在系统首次添加到集群前，必须更新 **MariaDB** 服务器复制配置。 	

  默认配置在 `/etc/my.cnf.d/galera.cnf` 文件中。 					

  在部署 **MariaDB Galera 集群** 之前，请将所有节点上的 `/etc/my.cnf.d/galera.cnf` 文件中的 `wsrep_cluster_address` 选项设置为以以下字符串开头： 					

  ```none
  gcomm://
  ```

  - 对于初始节点，可以将 `wsrep_cluster_address` 设置为空列表： 							

    ```none
    wsrep_cluster_address="gcomm://"
    ```

  - 对于所有其他节点，将 `wsrep_cluster_address` 设置为包含已属于正在运行的集群的一部分的任何节点的地址。例如：

    ```none
    wsrep_cluster_address="gcomm://10.0.0.10"
    ```


**流程**

1. 通过在该节点上运行以下 wrapper 来引导新集群的第一个节点：

   ```none
   # galera_new_cluster
   ```

   这个打包程序可确保 **MariaDB** 服务器守护进程(`mariadbd`)通过 `--wsrep-new-cluster` 选项运行。此选项提供了没有要连接的现有群集的信息。因此，节点会创建一个新的 UUID 来识别新集群。

   注意

   `mariadb` 服务支持 systemd 方法来与多个 **MariaDB** 服务器进程进行交互。因此，在有多个 **MariaDB** 服务器运行的情况下，您可以通过将实例名称指定为后缀来引导特定的实例： 						

   ```none
   # galera_new_cluster mariadb@node1
   ```

2. 在每个节点上运行以下命令将其他节点连接到集群： 					

   ```none
   # systemctl start mariadb
   ```

   因此，节点连接到集群，并将自己与集群的状态同步。			

### 在 MariaDB Galera 集群中添加新节点

要在 **MariaDB Galera 集群** 中添加新节点，请使用以下步骤。 			

请注意，您也可以使用此流程重新连接已存在的节点。 			

**流程**

- 在特定节点上，在 `/etc/my.cnf.d/galera.cnf` 配置文件的 `[mariadb]` 部分的 `wsrep_cluster_address` 选项中为一个或多个现有群集成员提供一个地址： 					

  ```none
  [mariadb]
  wsrep_cluster_address="gcomm://192.168.0.1"
  ```

  当新节点连接到现有群集节点中的一个时，就可以看到集群中的所有节点。

  但是，最好在 `wsrep_cluster_address` 中列出集群的所有节点。

  因此，任何节点都可以通过连接到任何其他群集节点来加入群集，即使一个或多个群集节点停机了也没关系。当所有成员就成员资格达成一致时，集群的状态将会改变。如果新节点的状态与集群状态不同，新节点需要请求增加状态转移(IST)或状态快照传输(SST)，来确保与其他节点保持一致。				

### 重启 MariaDB Galera 集群

如果同时关闭了所有的节点，就终止了集群，正在运行的集群将不再存在。但是，集群的数据仍然存在。 			

要重启集群，请引导第一个节点，如 [第 2.8.3 节 “部署 MariaDB Galera 集群”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#configuring-mariadb-galera-cluster_replicating-mariadb-with-galera) 所述 			

警告

如果集群没有启动，并且第一个节点上的 `mariadbd` 只是通过 `systemctl start mariadb` 命令来启动的，那么节点会尝试连接到 `/etc/my.cnf.d/galera.cnf` 文件 `wsrep_cluster_address` 选项中列出的至少一个节点。如果当前没有节点运行，那么重启失败。

## Introduction[¶](https://docs.rockylinux.org/guides/database/database_mariadb-server/#introduction)

The *mariadb-server* and it's client *mariadb* are the open source alternatives to *mysql-server* and *mysql*, and they share command structure. *mariadb-server* can be found running on many web servers, due to the popular [Wordpress CMS](https://wordpress.org/) which requires it. This database, though, has many other uses.

If you'd like to use this along with other tools for hardening a web server, refer back to the [Apache Hardened Web Server guide](https://docs.rockylinux.org/guides/web/apache_hardened_webserver/).

## Securing mariadb-server[¶](https://docs.rockylinux.org/guides/database/database_mariadb-server/#securing-mariadb-server)

To strengthen the security of *mariadb-server* we need to run a script, but before we do, we need to enable and start mariadb:

```
systemctl enable mariadb
```

And then:

```
systemctl start mariadb
```

Next, run this command:

```
mysql_secure_installation
```

Tip

The version of mariadb-server that comes enabled by default in Rocky  Linux 8.5 is 10.3.32. You can install 10.5.13 by enabling the module:

```
dnf module enable mariadb:10.5
```

And then installing `mariadb`. As of version 10.4.6 of MariaDB, MariaDB specific commands are available that you can use instead of the old `mysql` prefixed commands. These include the previously mentioned `mysql_secure_installation` which can now be called with the MariaDB version `mariadb-secure-installation`.

This brings up a dialog:

```
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none):
```

Since this is a brand new installation, there is no root password set. So just hit enter here.

The next part of the dialog continues:

```
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n]
```

You absolutely *do* want to have a root password set. You'll  want to figure out what this should be and document it in a password  manager somewhere so that you can pull it up if necessary. Start by  hitting 'Enter' to accept the default "Y". This will bring up the  password dialog:

```
New password:
Re-enter new password:
```

Enter your chosen password and then confirm it by entering it again. If this is successful, you will get the following dialog:

```
Password updated successfully!
Reloading privilege tables..
 ... Success!
```

Next the dialog deals with the anonymous user:

```
By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n]
```

The answer here is "Y" so just hit 'Enter' to accept the default.

The dialog proceeds to the section dealing with allowing the root user to login remotely:

```
... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]
```

root should only be needed locally on the machine. So accept this default as well by hitting 'Enter'.

The dialog then moves on to the 'test' database that is automatically installed with *mariadb-server*:

```
... Success!


By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n]
```

Again, the answer here is the default, so just hit 'Enter' to remove it.

Finally, the dialog ask you if you want to reload the privileges:

```
- Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n]
```

Again, simply hit 'Enter' to do this. If all goes well, you should receive this message:

```
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

MariaDB should now be ready to use.

### Rocky Linux 9.0 Changes[¶](https://docs.rockylinux.org/guides/database/database_mariadb-server/#rocky-linux-90-changes)

Rocky Linux 9.0 uses `mariadb-server-10.5.13-2` as the  default mariadb-server version. As of version 10.4.3, a new plugin is  automatically enabled in the server which changes the `mariadb-secure-installation` dialog. That plugin is `unix-socket` authentication. [This article](https://mariadb.com/kb/en/authentication-plugin-unix-socket/) explains the new feature well. Essentially, using `unix-socket` authentication uses the credentials of the logged in user to access the database. It makes it so that if the root user, for example, logs in  and then uses `mysqladmin` to create or delete a database (or any other function) that no password is needed for access. Same works with `mysql`. It also means there is no password to compromise remotely. This depends on the security of the users setup on the server for all of the  protection of the database.

The second dialog during the `mariadb-secure-installation` after the password is set for the administrative user is:

```
Switch to unix_socket authentication Y/n
```

Obviously, the default here is "Y", but even if you answer "n", with  the plugin enabled, no password is requested for the user, at least not  from the command line interface. You can specify either password or no  password and they both work:

```
mysql

MariaDB [(none)]>
mysql -p
Enter password:

MariaDB [(none)]>
```

For more information on this feature, refer to the link above. There  is a way to switch off this plugin and go back to having the password as a required field, which is also detailed within that link.

## Conclusion[¶](https://docs.rockylinux.org/guides/database/database_mariadb-server/#conclusion)

A database server, such as *mariadb-server*, can be used for  many purposes. Because of the popularity of the Wordpress CMS, it is  often found on web servers. Before we run the database in production,  however, it is a good idea to strengthen its security.



## 2.1. MariaDB 入门

​				**MariaDB** 是一个关系型数据库，它将数据转换为结构化信息，并为访问数据提供 SQL 接口。它包括多种存储引擎和插件，以及地理信息系统(GIS)和 JavaScript 对象表示法(JSON)功能。 		

​				对于 Red Hat Enterprise Linux 9，这部分描述了： 		

- ​						如何在安装 **MariaDB** 过程中 [安装 MariaDB](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#installing-mariadb_using-mariadb) 服务器。 				
- ​						如何在配置 **MariaDB** 过程中调整 [MariaDB](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#configuring-mariadb_using-mariadb) 配置。 				
- ​						如何在 MariaDB 上设置 TLS 加密，以在 **MariaDB** 中[设置 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#assembly_setting-up-tls-encryption-on-a-mariadb-server_using-mariadb)。 				
- ​						如何在 **MariaDB** 客户端中全局启用 TLS 加密，在 [MariaDB 客户端中启用 TLS 加密](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#assembly_globally-enabling-tls-encryption-in-mariadb-clients_using-mariadb)。 				
- ​						如何在 [备份 MariaDB 数据](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#backing-up-mariadb-data_using-mariadb) 过程中备份 **MariaDB** 数据。 				
- ​						如何在迁移到 **MariaDB 10.5** 时，从 RHEL 8 的 **MariaDB 10.3** 迁移到 RHEL 9 版本的 [MariaDB 10.5](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#proc_migrating-to-mariadb-10-5_using-mariadb)。 				
- ​						在 [复制带有 Galera 的 MariaDB ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#replicating-mariadb-with-galera_using-mariadb) 中，如何使用 **MariaDB Galera 集群** 复制数据库。 				

## 2.2. 安装 MariaDB

​				RHEL 9.0 提供 **MariaDB 10.5** 作为此 Application Stream 的初始版本，可作为 RPM 软件包轻松安装。在以后的 RHEL 9 次要发行本中，其他 **MariaDB** 版本将会作为模块提供较短的生命周期。 		

​				要安装 **MariaDB**，请使用以下流程： 		

**流程**

1. ​						安装 **MariaDB** 服务器软件包： 				

   

   ```none
   # dnf install mariadb-server
   ```

2. ​						启动 `mariadb` 服务： 				

   

   ```none
   # systemctl start mariadb.service
   ```

3. ​						启用 `mariadb` 服务，使其在引导时启动： 				

   

   ```none
   # systemctl enable mariadb.service
   ```

注意

​					由于 RPM 软件包有冲突，所以在 RHEL 9 中无法并行安装 **MariaDB** 和 **MySQL** 数据库服务器。在 RHEL 9 中，可以在容器中使用不同版本的数据库服务器。 			

## 2.3. 配置 MariaDB

​				要为联网配置 **MariaDB** 服务器，请使用以下流程： 		

**流程**

1. ​						编辑`/etc/my.cnf.d/mariadb-server.cnf`文件的`[mysqld]`部分。您可以设置以下配置指令： 				

   - ​								`bind-address` - 是服务器监听的地址。可能的选项有： 						
     - ​										主机名 								
     - ​										IPv4 地址 								
     - ​										IPv6 地址 								
   - ​								`skip-networking` - 控制服务器是否监听 TCP/IP 连接。可能的值有： 						
     - ​										0 - 监听所有客户端 								
     - ​										1 - 只监听本地客户端 								
   - ​								`port` - **MariaDB** 监听 TCP/IP 连接的端口。 						

2. ​						重启 `mariadb` 服务： 				

   

   ```none
   # systemctl restart mariadb.service
   ```

- ​			

## 2.5. 在 MariaDB 客户端中全局启用 TLS 加密

​				如果您的 **MariaDB** 服务器支持 TLS 加密，请将客户端配置为仅建立安全连接，并验证服务器证书。这个流程描述了如何为服务器上的所有用户启用 TLS 支持。 		

### 2.5.1. 将 MariaDB 客户端配置为默认使用 TLS 加密

​					在 RHEL 上，您可以全局配置 **MariaDB** 客户端使用 TLS 加密，并验证服务器证书中的通用名称(CN)与用户连接的主机名匹配。这可防止中间人攻击。 			

**先决条件**

- ​							**MariaDB** 服务器启用了 TLS 支持。 					
- ​							如果 RHEL 不信任发布服务器证书的证书颁发机构(CA)，则 CA 证书已被复制到客户端。 					

**流程**

1. ​							如果 RHEL 不信任发布服务器证书的 CA： 					

   1. ​									将 CA 证书复制到 `/etc/pki/ca-trust/source/anchors/` 目录中： 							

      

      ```none
      # cp <path>/ca.crt.pem /etc/pki/ca-trust/source/anchors/
      ```

   2. ​									设置允许所有用户读取 CA 证书文件的权限： 							

      

      ```none
      # chmod 644 /etc/pki/ca-trust/source/anchors/ca.crt.pem
      ```

   3. ​									重建 CA 信任数据库： 							

      

      ```none
      # update-ca-trust
      ```

2. ​							使用以下内容创建 `/etc/my.cnf.d/mariadb-client-tls.cnf` 文件： 					

   

   ```none
   [client-mariadb]
   ssl
   ssl-verify-server-cert
   ```

   ​							这些设置定义 **MariaDB** 客户端使用 TLS 加密(`ssl`)，并且客户端将主机名与服务器证书中的 CN(`ssl-verify-server-cert`)进行比较。 					

**验证**

- ​							使用主机名连接到服务器，并显示服务器的状态： 					

  

  ```none
  # mysql -u root -p -h server.example.com -e status
  ...
  SSL:        Cipher in use is TLS_AES_256_GCM_SHA384
  ```

  ​							如果 `SSL` 条目包含 `Cipher in use is…`，代表连接已加密。 					

  ​							请注意，您在这个命令中使用的用户具有远程身份验证的权限。 					

  ​							如果您连接的主机名与服务器的 TLS 证书中的主机名不匹配，则 `ssl-verify-server-cert` 参数会导致连接失败。例如，如果您连接到 `localhost` ： 					

  

  ```none
  # mysql -u root -p -h localhost -e status
  ERROR 2026 (HY000): SSL connection error: Validation of SSL server certificate failed
  ```

**其他资源**

- ​							`mysql(1)` 手册页中的 `--ssl*` 参数描述。 					

## 2.6. 备份 MariaDB 数据

​				在 Red Hat Enterprise Linux 9 中从 **MariaDB** 数据库备份数据主要有两种方法： 		

- ​						逻辑备份 				
- ​						物理备份 				

​				**逻辑备份** 由恢复数据所需的 SQL 语句组成。这种类型的备份以纯文本文件的形式导出信息和记录。 		

​				与物理备份相比，逻辑备份的主要优势在于可移植性和灵活性。数据可以在其他硬件配置上恢复，**MariaDB** 版本或数据库管理系统(DBMS)上恢复，这些系统无法进行物理备份。 		

​				请注意，如果 `mariadb.service` 正在运行，则可以执行逻辑备份。逻辑备份不包括日志和配置文件。 		

​				**物理备份**由保存内容的文件和目录副本组成。 		

​				与逻辑备份相比，物理备份具有以下优点： 		

- ​						输出更为紧凑。 				
- ​						备份的大小会较小。 				
- ​						备份和恢复速度更快。 				
- ​						备份包括日志和配置文件。 				

​				请注意，当 `mariadb.service` 没有运行或者数据库中的所有表都被锁定以防止备份期间更改时，必须执行物理备份。 		

​				您可以使用以下一种 **MariaDB** 备份方法，来从 **MariaDB** 数据库备份数据： 		

- ​						使用 `mariadb-dump` 的逻辑备份 				
- ​						使用 `Mariabackup` 工具的物理在线备份 				
- ​						文件系统备份 				
- ​						作为备份解决方案复制 				

### 2.6.1. 使用 mariadb-dump 执行逻辑备份

​					**mariadb-dump** 客户端是一种备份实用程序，可用于转储数据库或数据库集合，用于备份或传输到其他数据库服务器。**mariadb-dump** 的输出通常由 SQL 语句组成，用于重新创建服务器表结构、生成表的数据。**mariadb-dump** 也可以以其他格式生成文件，包括 XML 和分隔的文本格式，如 CSV。 			

​					要执行 **mariadb-dump** 备份，您可以使用以下选项之一： 			

- ​							备份一个或多个所选的数据库 					
- ​							备份所有数据库 					
- ​							从一个数据库备份表子集 					

**流程**

- ​							要转储单个数据库，请运行： 					

  

  ```none
  # mariadb-dump [options] --databases db_name > backup-file.sql
  ```

- ​							要一次转储多个数据库，请运行： 					

  

  ```none
  # mariadb-dump [options] --databases db_name1 [db_name2 ...] > backup-file.sql
  ```

- ​							要转储所有数据库，请运行： 					

  

  ```none
  # mariadb-dump [options] --all-databases > backup-file.sql
  ```

- ​							要将一个或多个转储的完整数据库加载回服务器，请运行： 					

  

  ```none
  # mariadb < backup-file.sql
  ```

- ​							要将数据库加载到远程 **MariaDB** 服务器，请运行： 					

  

  ```none
  # mariadb --host=remote_host < backup-file.sql
  ```

- ​							要从一个数据库转储表子集，请在 `mariadb-dump` 命令末尾添加所选表的列表： 					

  

  ```none
  # mariadb-dump [options] db_name [tbl_name ...] > backup-file.sql
  ```

- ​							要载入从一个数据库转储的表的子集，请运行： 					

  

  ```none
  # mariadb db_name < backup-file.sql
  ```

  注意

  ​								此时，*db_name* 数据库必须存在。 						

- ​							要查看 **mariadb-dump** 支持的选项列表，请运行： 					

  

  ```none
  $ mariadb-dump --help
  ```

**其他资源**

- ​							[MariaDB 文档 - mariadb-dump](https://mariadb.com/kb/en/library/mysqldump/) 					

### 2.6.2. 使用 Mariabackup 工具执行物理在线备份

​					**mariabackup** 是一个基于 Percona XtraBackup 技术的工具，能够执行 InnoDB、Aria 和 MyISAM 表的物理在线备份。这个工具是由 AppStream 存储库中的 `mariadb-backup` 软件包提供的。 			

​					**mariabackup** 支持对 **MariaDB** 服务器的全备份功能，其中包括加密和压缩的数据。 			

**先决条件**

- ​							`mariadb-backup` 软件包已在系统中安装： 					

  

  ```none
  # dnf install mariadb-backup
  ```

- ​							您必须为 **Mariabackup** 提供要在其下运行备份的用户的凭证。您可以在命令行中或通过配置文件来提供凭证。 					
- ​							**Mariabackup** 的用户必须具有 `RELOAD`、`LOCK TABLES` 和 `REPLICATION CLIENT` 特权。 					

​					要使用 **Mariabackup** 创建数据库备份，请使用以下流程： 			

**流程**

- ​							要在在命令行上提供凭证的同时创建备份，请运行： 					

  

  ```none
  $ mariabackup --backup --target-dir <backup_directory> --user <backup_user> --password <backup_passwd>
  ```

  ​							`target-dir` 选项定义存储备份文件的目录。如果要执行全备份，目标目录必是空或者不存在。 					

  ​							`user` 和 `password` 选项允许您配置用户名和密码。 					

- ​							要使用配置文件中设置的凭证创建备份： 					

  1. ​									在 `/etc/my.cnf.d/` 目录中创建配置文件，例如 `/etc/my.cnf.d/mariabackup.cnf`。 							

  2. ​									将以下行添加到新文件的 `[xtrabackup]` 或 `[mysqld]` 部分中： 							

     

     ```none
     [xtrabackup]
     user=myuser
     password=mypassword
     ```

  3. ​									执行备份： 							

     

     ```none
     $ mariabackup --backup --target-dir <backup_directory>
     ```

重要

​						**mariabackup** 不读取配置文件 `[mariadb]` 部分中的选项。如果在 **MariaDB** 服务器上指定了非默认数据目录，那么您必须在配置文件的 `[xtrabackup]` 或 `[mysqld]` 部分中指定此目录，以便 **Mariabackup** 能够找到数据目录。 				

​						要指定非默认数据目录，请在 **MariaDB** 配置文件的 `[xtrabackup]` 或 `[mysqld]` 部分中包含以下行： 				



```none
datadir=/var/mycustomdatadir
```

**其他资源**

- ​							[使用 Mariabackup 的完整备份和恢复](https://mariadb.com/kb/en/library/full-backup-and-restore-with-mariadb-backup/) 					

### 2.6.3. 使用 Mariabackup 工具恢复数据

​					备份完成后，您可以使用 `mariabackup` 命令及以下一个选项来从备份中恢复数据： 			

- ​							`--copy-back` 允许您保存原始的备份文件。 					
- ​							`--move-back` 将备份文件移到数据目录中，并删除原始的备份文件。 					

​					要使用 **Mariabackup** 工具来恢复数据，请使用以下流程： 			

**先决条件**

- ​							验证 `mariadb` 服务没有运行： 					

  

  ```none
  # systemctl stop mariadb.service
  ```

- ​							验证数据目录是否为空。 					

- ​							**Mariabackup** 的用户必须具有 `RELOAD`、`LOCK TABLES` 和 `REPLICATION CLIENT` 特权。 					

**流程**

1. ​							运行 `mariabackup` 命令： 					

   - ​									要恢复数据并保留原始备份文件，请使用 `--copy-back` 选项： 							

     

     ```none
     $ mariabackup --copy-back --target-dir=/var/mariadb/backup/
     ```

   - ​									要恢复数据并删除原始备份文件，请使用 `--move-back` 选项： 							

     

     ```none
     $ mariabackup --move-back --target-dir=/var/mariadb/backup/
     ```

2. ​							修复文件权限。 					

   ​							恢复数据库时，**Mariabackup** 会保留备份的文件和目录特权。但是，**Mariabackup** 以恢复数据库的用户和组的身份将文件写入磁盘。恢复备份后，您可能需要调整数据目录的所有者，以匹配 **MariaDB** 服务器的用户和组，通常两者都为 `mysql`。 					

   ​							例如，要递归地将文件的所有权改为 `mysql` 用户和组： 					

   

   ```none
   # chown -R mysql:mysql /var/lib/mysql/
   ```

3. ​							启动 `mariadb` 服务： 					

   

   ```none
   # systemctl start mariadb.service
   ```

**其他资源**

- ​							[使用 Mariabackup 的完整备份和恢复](https://mariadb.com/kb/en/library/full-backup-and-restore-with-mariabackup/) 					

### 2.6.4. 执行文件系统备份

​					要创建 **MariaDB** 数据文件的文件系统备份，请将 **MariaDB** 数据目录的内容复制到您的备份位置。 			

​					要同时备份当前的配置或日志文件，请使用以下流程的可选步骤： 			

**流程**

1. ​							停止 `mariadb` 服务： 					

   

   ```none
   # systemctl stop mariadb.service
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
   # cp /var/log/mariadb/ /backup-location/logs*
   ```

5. ​							启动 `mariadb` 服务： 					

   

   ```none
   # systemctl start mariadb.service
   ```

6. ​							将备份位置的备份数据加载到 `/var/lib/mysql` 目录时，请确保 `mysql:mysql` 是 `/var/lib/mysql` 中所有数据的所有者： 					

   

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

### 2.6.5. 作为备份解决方案复制

​					复制是源服务器的一个替代的备份解决方案。如果源服务器复制到副本服务器，备份可以在副本上运行，而不会对源造成任何影响。当您关闭副本，并从副本备份数据时，源仍然可以运行。 			

警告

​						复制本身并不是一个足够的备份解决方案。复制可以防止源服务器出现硬件故障，但它不能确保防止数据的丢失。建议您将对副本的任何其他备份解决方案与此方法一起使用。 				

**其他资源**

- ​							[使用 Galera 复制 MariaDB](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#replicating-mariadb-with-galera_using-mariadb) 					
- ​							[作为备份解决方案复制](https://mariadb.com/kb/en/library/replication-as-a-backup-solution/) 					

## 2.7. 迁移到 MariaDB 10.5

​				在 RHEL 8 中，提供了 **MariaDB** 服务器版本 10.3 和 10.5，分别由单独的模块流提供。RHEL 9 提供 **MariaDB 10.5** 和 **MySQL 8.0。**这部分论述了从 RHEL 8 中的 **MariaDB 10.3** 版本迁移到 RHEL 9 中的 **MariaDB 10.5** 版本。 		

### 2.7.1. MariaDB 10.3 和 MariaDB 10.5 之间的显著区别

​					**MariaDB 10.3** 和 **MariaDB 10.5** 之间的显著变化包括： 			

- ​							**MariaDB** 现在默认使用 `unix_socket` 身份验证插件。该插件允许用户在通过本地 UNIX 套接字文件连接到 **MariaDB** 时使用操作系统凭证。 					

- ​							`MariaDB` 添加了以 `mariadb-*` 命名的二进制代码，`mysql*` 符号链接指向 `mariadb-*` 的二进制代码。例如，`mysqladmin`、`mysqlaccess` 和 `mysqlshow` 分别指向 `mariadb-admin`、`mariadb-access` 和 `mariadb-show` 二进制代码。 					

- ​							`SUPER` 特权已被分成几个特权，以更好地与每个用户角色保持一致。因此，某些语句已更改了所需的权限。 					

- ​							在并行 `复制中，slave_parallel_mode` 现在被默认设置为 `静态`。 					

- ​							在 **InnoDB** 存储引擎 中，以下变量的默认值已发生变化：`innodb_adaptive_hash_index ` 变为 `OFF`，`innodb_checksum_algorithm` 变为 `full_crc32`。 					

- ​							**MariaDB** 现在使用用于管理 **MariaDB** 命令历史记录（the `.mysql_history` 文件）的底层软件的 `libedit` 实施，而不是之前使用的 `readline` 库。此更改会影响直接使用 `.mysql_history` 文件的用户。注意 `.mysql_history` 是一个由 **MariaDB** 或 **MySQL** 应用管理的文件，用户不应直接使用该文件。人类可读的外表是巧合。 					

  注意

  ​								要提高安全性，您可以考虑不维护历史记录文件。禁用记录命令历史记录： 						

  1. ​										删除 `.mysql_history` 文件（如果存在的话）。 								

  2. ​										使用以下任一方法： 								

     - ​												将 `MYSQL_HISTFILE` 变量设置为 `/dev/null`，并将此设置包含在您的任何 shell 启动文件中。 										

     - ​												将 `.mysql_history` 文件更改为指向 `/dev/null` 的符号链接： 										

       

       ```none
       $ ln -s /dev/null $HOME/.mysql_history
       ```

​					**MariaDB Galera 集群** 已升级到版本 4，有以下显著变化： 			

- ​							**Galera** 添加了一个新的流复制特性，其支持复制无限大小的事务。在执行流复制的过程中，集群以小片段复制事务。 					
- ​							**Galera** 现在完全支持全球交易 ID(GTID)。 					
- ​							`/etc/my.cnf.d/galera.cnf` 文件中的 `wsrep_on` 选项的默认值已从 `1` 改为 `0`，以防止最终用户在没有配置所需的附加选项的情况下启动 `wsrep` 复制。 					

​					对**MariaDB 10.5** 中 PAM 插件的更改包括： 			

- ​							**MariaDB 10.5** 添加了可插拔验证模块(PAM)插件的一个新版本。PAM 插件版本 2.0 使用单独的 `setuid root` 帮助程序二进制文件来执行 PAM 身份验证，这使得 **MariaDB** 可以使用额外的 PAM 模块。 					
- ​							帮助程序二进制文件只能由 `mysql` 组中的用户执行。默认情况下，组只包含 `mysql` 用户。红帽建议管理员不要向 `mysql` 组添加更多用户，以防止无需通过这个助手工具进行节流或记录的情况下的密码猜测攻击。 					
- ​							在 **MariaDB 10.5** 中，可插拔验证模块(PAM)插件及其相关文件已移至新的软件包 `mariadb-pam`。因此，在不使用对 `MariaDB` 进行PAM 验证的系统中不会引入新的 `setuid root` 二进制文件。 					
- ​							`mariadb-pam` 软件包包含两个 PAM 插件版本：版本 2.0 是默认值，版本 1.0 作为 `auth_pam_v1` 共享对象库提供。 					
- ​							默认情况下，`mariadb-pam` 软件包不与 **MariaDB** 服务器一起安装 。要在 **MariaDB 10.5** 中提供 PAM 身份验证插件，请手动安装 `mariadb-pam` 软件包。 					

### 2.7.2. 从 RHEL 8 的 MariaDB 10.3 迁移到 RHEL 9 版本的 MariaDB 10.5

​					这个步骤描述了使用 `mariadb-upgrade` 程序从 **MariaDB 10.3** 迁移到 **MariaDB 10.5**。 			

​					`mariadb-upgrade` 实用程序由 `mariadb-server-utils` 子软件包提供，该子软件包作为 `mariadb-server` 软件包的依赖项安装。 			

**先决条件**

- ​							在执行升级前，备份存储在 **MariaDB** 数据库中的所有数据。 					

**流程**

1. ​							确定在 RHEL 9 系统中安装了 `mariadb-server` 软件包： 					

   

   ```none
   # dnf install mariadb-server
   ```

2. ​							确保 `mariadb` 服务在复制数据时没有在源和目标系统上运行： 					

   

   ```none
   # systemctl stop mariadb.service
   ```

3. ​							将源位置的数据复制到 RHEL 9 目标系统的 `/var/lib/mysql/` 目录中。 					

4. ​							对目标系统上复制的文件设置适当的权限和 SELinux 上下文： 					

   

   ```none
   # restorecon -vr /var/lib/mysql
   ```

5. ​							确保 `mysql:mysql` 是 `/var/lib/mysql` 目录中所有数据的所有者： 					

   

   ```none
   # chown -R mysql:mysql /var/lib/mysql
   ```

6. ​							调整配置，以便位于 `/etc/my.cnf.d/` 中的选项文件只包含对 **MariaDB 10.5** 有效的选项。详情请参阅 [MariaDB 10.4](https://mariadb.com/kb/en/upgrading-from-mariadb-103-to-mariadb-104/#options-that-have-changed-default-values) 和 [MariaDB 10.5](https://mariadb.com/kb/en/upgrading-from-mariadb-104-to-mariadb-105/#options-that-have-been-removed-or-renamed) 的上游文档。 					

7. ​							在目标系统中启动 **MariaDB** 服务器。 					

   - ​									在升级独立运行的数据库时： 							

     

     ```none
     # systemctl start mariadb.service
     ```

   - ​									在升级 **Galera** 集群节点时： 							

     

     ```none
     # galera_new_cluster
     ```

     ​									`mariadb` 服务将自动启动。 							

8. ​							执行 **mariadb-upgrade** 工具来检查和修复内部表。 					

   - ​									在升级独立运行的数据库时： 							

     

     ```none
     $ mariadb-upgrade
     ```

   - ​									在升级 **Galera** 集群节点时： 							

     

     ```none
     $ mariadb-upgrade --skip-write-binlog
     ```

重要

​						有一些与原位升级相关的风险和已知问题。例如，一些查询可能无法正常工作，或者它们会以与升级前不同的顺序运行。有关这些风险和问题的更多信息，以及有关原位升级的常规信息，请参阅 [MariaDB 10.5 发行注记](https://mariadb.com/kb/en/release-notes-mariadb-105-series/)。 				

## 2.8. 使用 Galera 复制 MariaDB

​				这部分论述了如何在 Red Hat Enterprise Linux 9 中使用 Galera 解决方案复制 MariaDB 数据库。 		

### 2.8.1. MariaDB Galera 集群介绍

​					Galera 复制是基于同步多源 **MariaDB Galera集群** 的创建，该群集由多个 MariaDB 服务器组成。与传统的主/副本设置(副本通常是只读的)不同，MariaDB Galera 群集中的节点都是可写的。 			

​					Galera 复制和 **MariaDB** 数据库之间的接口由写集复制 API(**wsrep API**) 定义的。 			

​					**MariaDB Galera 集群** 的主要特性是 ： 			

- ​							同步复制 					
- ​							主动-主动多源拓扑 					
- ​							对任何集群节点的读和写 					
- ​							自动成员资格控制，故障节点从集群中删除 					
- ​							自动节点加入 					
- ​							行一级的并行复制 					
- ​							直接客户端连接：用户可以登录到集群节点，并在复制运行时直接使用这些节点 					

​					同步复制意味着服务器在提交时复制事务，方法是将与事务关联的写入集合广播到集群中的每个节点。客户端（用户应用程序）直接连接到数据库管理系统(DBMS)，可以体验类似于原生 **MariaDB** 的行为。 			

​					同步复制保证集群中一个节点上的更改会同时在集群中的其他节点上发生。 			

​					因此，与异步复制相比，同步复制具有以下优势： 			

- ​							在特定集群节点间传播更改没有延迟 					
- ​							所有集群节点始终一致 					
- ​							如果其中一个集群节点崩溃，则不会丢失最新的更改 					
- ​							所有集群节点上的事务都会并行执行 					
- ​							整个集群的因果关系 					

**其他资源**

- ​							[关于 Galera 复制](https://mariadb.com/kb/en/library/about-galera-replication/) 					
- ​							[什么是 MariaDB Galera 集群](https://mariadb.com/kb/en/library/what-is-mariadb-galera-cluster/) 					
- ​							[MariaDB Galera 集群入门](https://mariadb.com/kb/en/library/getting-started-with-mariadb-galera-cluster/) 					

### 2.8.2. 构建 MariaDB Galera 集群的组件

​					要构建 **MariaDB Galera 集群**，您必须在您的系统上安装以下软件包： 			

- ​							`mariadb-server-galera` - 包含 **MariaDB Galera 集群** 的支持文件和脚本。 					
- ​							`MariaDB-server` - 由 **MariaDB** 上游打补丁，以包含写入集复制 API(**wsrep API**)。此 API 提供 **Galera** 复制和 **MariaDB** 之间的接口。 					
- ​							`Galera` - 由 **MariaDB** 上游打补丁，以添加对 **MariaDB** 的完全支持。`galera` 软件包包含以下内容： 					
  - ​									**Galera Replication 程序库** 提供整个复制功能。 							
  - ​									**Galera Arbitrator** 工具可用作参与脑裂场景的集群成员。但是，**Galera Arbitrator** 无法参与实际的复制。 							
  - ​									**Galera Systemd 服务** 和 **Galera 打包程序脚本**，它们用于部署 Galera Arbitrator 工具。RHEL 9 提供这些文件的上游版本，位于 `/usr/lib/systemd/system/garbd.service` 和 `/usr/sbin/garb-systemd`。 							

**其他资源**

- ​							[Galera 复制程序](https://mariadb.com/kb/en/library/about-galera-replication/#generic-replication-library) 					
- ​							[Galera Arbitrator](https://galeracluster.com/library/documentation/arbitrator.html) 					
- ​							[MySQL-wsrep 项目](https://github.com/codership/mysql-wsrep) 					

### 2.8.3. 部署 MariaDB Galera 集群

​					您可以部署 **MariaDB Galera 集群** 软件包并更新配置。要组成新集群，您必须引导集群的第一个节点。 			

**先决条件**

- ​							安装 **MariaDB Galera 集群** 软件包： 					

  

  ```none
  # dnf install mariadb-server-galera
  ```

  ​							因此，以下软件包会与依赖项一起安装： 					

  - ​									`mariadb-server-galera` 							

  - ​									`mariadb-server` 							

  - ​									`galera` 							

    ​									有关构建 **MariaDB Galera** 集群的软件包要求的更多信息，请参阅 [组件来构建 MariaDB 集群](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#components-to-build-mariadb-galera-cluster_replicating-mariadb-with-galera)。 							

- ​							在系统首次添加到集群前，必须更新 **MariaDB** 服务器复制配置。 					

  ​							默认配置在 `/etc/my.cnf.d/galera.cnf` 文件中。 					

  ​							在部署 **MariaDB Galera 集群** 之前，请将所有节点上的 `/etc/my.cnf.d/galera.cnf` 文件中的 `wsrep_cluster_address` 选项设置为以以下字符串开头： 					

  

  ```none
  gcomm://
  ```

  - ​									对于初始节点，可以将 `wsrep_cluster_address` 设置为空列表： 							

    

    ```none
    wsrep_cluster_address="gcomm://"
    ```

  - ​									对于所有其他节点，将 `wsrep_cluster_address` 设置为包含已属于正在运行的集群的一部分的任何节点的地址。例如： 							

    

    ```none
    wsrep_cluster_address="gcomm://10.0.0.10"
    ```

    ​									有关如何设置 Galera 集群地址的更多信息，请参阅 [Galera 集群地址](https://mariadb.com/kb/en/library/galera-cluster-address/)。 							

**流程**

1. ​							通过在该节点上运行以下 wrapper 来引导新集群的第一个节点： 					

   

   ```none
   # galera_new_cluster
   ```

   ​							这个打包程序可确保 **MariaDB** 服务器守护进程(`mariadbd`)通过 `--wsrep-new-cluster` 选项运行。此选项提供了没有要连接的现有群集的信息。因此，节点会创建一个新的 UUID 来识别新集群。 					

   注意

   ​								`mariadb` 服务支持 systemd 方法来与多个 **MariaDB** 服务器进程进行交互。因此，在有多个 **MariaDB** 服务器运行的情况下，您可以通过将实例名称指定为后缀来引导特定的实例： 						

   

   ```none
   # galera_new_cluster mariadb@node1
   ```

2. ​							在每个节点上运行以下命令将其他节点连接到集群： 					

   

   ```none
   # systemctl start mariadb
   ```

   ​							因此，节点连接到集群，并将自己与集群的状态同步。 					

**其他资源**

- ​							[MariaDB Galera 集群入门](https://mariadb.com/kb/en/library/getting-started-with-mariadb-galera-cluster/) 					

### 2.8.4. 在 MariaDB Galera 集群中添加新节点

​					要在 **MariaDB Galera 集群** 中添加新节点，请使用以下步骤。 			

​					请注意，您也可以使用此流程重新连接已存在的节点。 			

**流程**

- ​							在特定节点上，在 `/etc/my.cnf.d/galera.cnf` 配置文件的 `[mariadb]` 部分的 `wsrep_cluster_address` 选项中为一个或多个现有群集成员提供一个地址： 					

  

  ```none
  [mariadb]
  wsrep_cluster_address="gcomm://192.168.0.1"
  ```

  ​							当新节点连接到现有群集节点中的一个时，就可以看到集群中的所有节点。 					

  ​							但是，最好在 `wsrep_cluster_address` 中列出集群的所有节点。 					

  ​							 因此，任何节点都可以通过连接到任何其他群集节点来加入群集，即使一个或多个群集节点停机了也没关系。当所有成员就成员资格达成一致时，集群的状态将会改变。如果新节点的状态与集群状态不同，新节点需要请求增加状态转移(IST)或状态快照传输(SST)，来确保与其他节点保持一致。 					

**其他资源**

- ​							[MariaDB Galera 集群入门](https://mariadb.com/kb/en/library/getting-started-with-mariadb-galera-cluster/) 					
- ​							[State Snapshot Transfers 简介](https://mariadb.com/kb/en/library/documentation/replication/galera-cluster/state-snapshot-transfers-ssts-in-galera-cluster/introduction-to-state-snapshot-transfers-ssts/) 					

### 2.8.5. 重启 MariaDB Galera 集群

​					如果您同时关闭所有节点，您将停止集群，正在运行的集群不再存在。但是，集群的数据仍然存在。 			

​					要重启集群，请引导第一个节点，如 [配置 MariaDB Galera 集群](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#configuring-mariadb-galera-cluster_replicating-mariadb-with-galera) 所述。 			

警告

​						如果集群没有启动，并且第一个节点上的 `mariadbd` 只是通过 `systemctl start mariadb` 命令来启动的，那么节点会尝试连接到 `/etc/my.cnf.d/galera.cnf` 文件 `wsrep_cluster_address` 选项中列出的至少一个节点。如果当前没有节点运行，那么重启失败。 				

**其他资源**

- ​							[MariaDB Galera 集群入门](https://mariadb.com/kb/en/library/getting-started-with-mariadb-galera-cluster/)。 					
