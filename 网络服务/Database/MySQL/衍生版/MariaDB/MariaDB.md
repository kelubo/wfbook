# MariaDB
## 安装
**Ubuntu**  

    $ sudo apt install mariadb-server
    $ sudo systemctl start mysql.service
    $ sudo systemctl enable mysql.service

**CentOS**

    # yum install mariadb mariadb-server  
    # systemctl start mariadb.service  
    # systemctl enable mariadb.service  

## 初始化
第1步：设定root用户密码。  
第2步：删除匿名帐号。  
第3步：禁止root用户从远程登陆。  
第4步：删除test数据库并取消对其的访问权限。  
第5步：刷新授权表，让初始化后的设定立即生效。

    初始化数据库服务程序：

    [root@linuxprobe ~]# mysql_secure_installation
    /usr/bin/mysql_secure_installation: line 379: find_mysql_client: command not found
    NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
          SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!
    In order to log into MariaDB to secure it, we'll need the current
    password for the root user.  If you've just installed MariaDB, and
    you haven't set the root password yet, the password will be blank,
    so you should just press enter here.
    Enter current password for root (enter for none): 当前数据库密码为空，直接敲击回车。
    OK, successfully used password, moving on...
    Setting the root password ensures that nobody can log into the MariaDB
    root user without the proper authorisation.
    Set root password? [Y/n] y
    New password: 输入要为root用户设置的数据库密码。
    Re-enter new password: 重复再输入一次密码。
    Password updated successfully!
    Reloading privilege tables..
     ... Success!
    By default, a MariaDB installation has an anonymous user, allowing anyone
    to log into MariaDB without having to have a user account created for
    them.  This is intended only for testing, and to make the installation
    go a bit smoother.  You should remove them before moving into a
    production environment.
    Remove anonymous users? [Y/n] y（删除匿名帐号）
     ... Success!
    Normally, root should only be allowed to connect from 'localhost'.  This
    ensures that someone cannot guess at the root password from the network.
    Disallow root login remotely? [Y/n] y(禁止root用户从远程登陆)
     ... Success!
    By default, MariaDB comes with a database named 'test' that anyone can
    access.  This is also intended only for testing, and should be removed
    before moving into a production environment.
    Remove test database and access to it? [Y/n] y(删除test数据库并取消对其的访问权限)
     - Dropping test database...
     ... Success!
     - Removing privileges on test database...
     ... Success!
    Reloading the privilege tables will ensure that all changes made so far
    will take effect immediately.
    Reload privilege tables now? [Y/n] y(刷新授权表，让初始化后的设定立即生效)
     ... Success!
    Cleaning up...
    All done!  If you've completed all of the above steps, your MariaDB
    installation should now be secure.
    Thanks for using MariaDB!

    设置防火墙对数据库服务的允许策略：

    [root@linuxprobe ~]# firewall-cmd --permanent --add-service=mysql
    success
    [root@linuxprobe ~]# firewall-cmd --reload
    success

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


    切换回root用户登陆数据库并进入到mysql数据库中：

    [root@linuxprobe ~]# mysql -u root -p
    MariaDB [(none)]> use mysql;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    Database changed

    给予luke用户对user表单的查询、更新、删除、插入权限：

    MariaDB [mysql]> GRANT SELECT,UPDATE,DELETE,INSERT on mysql.user to luke@localhost;
    Query OK, 0 rows affected (0.00 sec)

    查看luke用户当前的授权：
    MariaDB [(none)]&gt; show grants for luke@localhost;
    +-------------------------------------------------------------------------------------------------------------+
    | Grants for luke@localhost |
    +-------------------------------------------------------------------------------------------------------------+
    | GRANT USAGE ON *.* TO 'luke'@'localhost' IDENTIFIED BY PASSWORD '*55D9962586BE75F4B7D421E6655973DB07D6869F' |
    | GRANT SELECT, INSERT, UPDATE, DELETE ON `mysql`.`user` TO 'luke'@'localhost' |
    +-------------------------------------------------------------------------------------------------------------+
    2 rows in set (0.00 sec)

    再次切换到luke用户后查看可用的数据库：

    [root@linuxprobe ~]# mysql -u luke -p
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    +--------------------+
    2 rows in set (0.01 sec)

    进入到mysql数据库中看到user表单了：

    MariaDB [(none)]> use mysql
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    Database changed
    MariaDB [mysql]> show tables;
    +-----------------+
    | Tables_in_mysql |
    +-----------------+
    | user            |
    +-----------------+
    1 row in set (0.01 sec)

    切换回root用户后取消刚刚全部的授权：

    MariaDB [(none)]> revoke SELECT,UPDATE,DELETE,INSERT on mysql.user from luke@localhost;
    Query OK, 0 rows affected (0.00 sec)

    再次查看luke用户的授权：
    MariaDB [(none)]&gt; show grants for luke@localhost;
    +-------------------------------------------------------------------------------------------------------------+
    | Grants for luke@localhost |
    +-------------------------------------------------------------------------------------------------------------+
    | GRANT USAGE ON *.* TO 'luke'@'localhost' IDENTIFIED BY PASSWORD '*55D9962586BE75F4B7D421E6655973DB07D6869F' |
    +-------------------------------------------------------------------------------------------------------------+
    1 row in set (0.00 sec)

    出现问题?大胆提问!

        因读者们硬件不同或操作错误都可能导致实验配置出错，请耐心再仔细看看操作步骤吧，不要气馁~

        Linux技术交流请加A群：560843(满)，B群：340829(推荐)，点此查看全国群。

        *本群特色：通过口令验证确保每一个群员都是《Linux就该这么学》的读者，答疑更有针对性，不定期免费领取定制礼品。

    18.3.2 创建数据库与表单

    常用的数据库表单管理命令有：
    用法 	作用
    CREATE database 数据库名称。 	创建新的数据库。
    DESCRIBE 表单名称; 	描述表单。
    UPDATE 表单名称 SET attribute=新值 WHERE attribute > 原始值; 	更新表单中的数据。
    USE 数据库名称; 	指定使用的数据库。
    SHOW databases; 	显示当前已有的数据库。
    SHOW tables; 	显示当前数据库中的表单。
    SELECT * FROM 表单名称; 	从表单中选中某个记录值。
    DELETE FROM 表单名 WHERE attribute=值; 	从表单中删除某个记录值。


    创建一个新的数据库：

    MariaDB [(none)]> create database linuxprobe;
    Query OK, 1 row affected (0.00 sec)

    查看当前已有的数据库：

    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | information_schema |
    | linuxprobe |
    | mysql |
    | performance_schema |
    +--------------------+
    4 rows in set (0.04 sec)

    切换到指定的数据库：

    MariaDB [(none)]> use linuxprobe;
    Database changed

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

    18.3.4 数据库的备份与恢复
    mysqldump命令用于备份数据库数据，格式为：“mysqldump [参数] [数据库名称]”。
    参数 	作用
    -u 	数据库的用户名称。
    -p 	密码提示符。
    --no-data 	至备份数据库的描述结构，而不要数据。
    --lock-all-tables 	备份完成后将不再允许修改数据。

    将书籍数据库文件（即linuxprobe）导出到家目录：

    [root@linuxprobe ~]# mysqldump -u root -p linuxprobe > /root/linuxprobeDB.dump
    Enter password:

    删除书籍数据库：

    MariaDB [linuxprobe]> drop database linuxprobe;
    Query OK, 1 row affected (0.04 sec)
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    +--------------------+
    3 rows in set (0.02 sec)

    创建一个空的数据库：

    MariaDB [(none)]> create database linuxprobe;
    Query OK, 1 row affected (0.00 sec)

    导入刚刚备份的数据库：

    [root@linuxprobe ~]# mysql -u root -p linuxprobe < /root/linuxprobeDB.dump
    Enter password:

    果然又看到了刚刚创建的mybook表单：

    [root@linuxprobe ~]# mysql -u root -p
    MariaDB [(none)]> use linuxprobe;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    Database changed
    MariaDB [linuxprobe]> show tables;
    +----------------------+
    | Tables_in_linuxprobe |
    +----------------------+
    | mybook               |
    +----------------------+
    1 row in set (0.05 sec)
