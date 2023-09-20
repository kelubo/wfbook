# PostgreSQL

[TOC]

## 概述

 ![](../../../Image/p/postgresql.png)

**官网：**https://www.postgresql.org/

PostgreSQL 是一个对象关系型数据库管理系统（ORDBMS）。在 BSD 许可证下发行。

PostgreSQL 开发者把它念作 `post-gress-Q-L` 。

PostgreSQL 的 Slogan 是 "世界上最先进的开源关系型数据库"。

提供了许多现代特性：

- 复杂查询
- 外键
- 触发器
- 可更新视图
- 事务完整性
- 多版本并发控制

   同样，可以用许多方法扩展，比如，通过增加新的：

- 数据类型
- 函数
- 操作符
- 聚集函数
- 索引方法
- 过程语言

因为自由宽松的许可证，任何人都可以以任何目的免费使用、修改和分发 PostgreSQL ，不管是私用、商用还是学术研究目的。

| 端口 | 管理员用户名 |
| ---- | ------------ |
| 5432 | postgres     |

**优点：**
1、性能更强大，媲美商业数据库，可能是性能最强悍的开源数据库
2、SQL标准语法支持更全面
3、数据类型、统计函数支持更丰富，数组、jsonb等、表继承等等、在做OLAP的统计上更完善
4、索引、序列支持更全面，gist、gin索引
5、集群支持，Greenplum、PostgreSQL-XL

**极限值：**

| 最大单个数据库大小 | 不限                        |
| ------------------ | --------------------------- |
| 最大数据单表大小   | 32 TB                       |
| 单条记录最大       | 1.6 TB                      |
| 单字段最大允许     | 1 GB                        |
| 单表允许最大记录数 | 不限                        |
| 单表最大字段数     | 250 - 1600 (取决于字段类型) |
| 单表最大索引数     | 不限                        |

## 架构

在数据库术语里，PostgreSQL 使用一种客户端/服务器的模型。一次 PostgreSQL 会话由下列相关的进程（程序）组成：     

- 一个服务器进程，它管理数据库文件、接受来自客户端应用与数据库的联接并且代表客户端在数据库上执行操作。 该数据库服务器程序叫做 `postgres`。             
- 那些需要执行数据库操作的用户的客户端（前端）应用。 客户端应用可能本身就是多种多样的：可以是一个面向文本的工具，  也可以是一个图形界面的应用，或者是一个通过访问数据库来显示网页的网页服务器，或者是一个特制的数据库管理工具。 一些客户端应用是和 PostgreSQL发布一起提供的，但绝大部分是用户开发的。

和典型的客户端/服务器应用（ C/S 应用）一样，这些客户端和服务器可以在不同的主机上。 这时它们通过 TCP/IP 网络联接通讯。在客户机上可以访问的文件未必能够在数据库服务器机器上访问（或者只能用不同的文件名进行访问）。

PostgreSQL服务器可以处理来自客户端的多个并发请求。 因此，它为每个连接启动（“forks”）一个新的进程。 从这个时候开始，客户端和新服务器进程就不再经过最初的 `postgres` 进程的干涉进行通讯。 因此，主服务器进程总是在运行并等待着客户端联接， 而客户端和相关联的服务器进程则是起起停停。

# PostgreSQL DELETE 语句

你可以使用 DELETE 语句来删除 PostgreSQL 表中的数据。

### 语法

以下是 DELETE 语句删除数据的通用语法：

```
DELETE FROM table_name WHERE [condition];
```

如果没有指定 WHERE 子句，PostgreSQL 表中的所有记录将被删除。

一般我们需要在 WHERE 子句中指定条件来删除对应的记录，条件语句可以使用 AND 或 OR 运算符来指定一个或多个。

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

以下 SQL 语句将删除 ID 为 2 的数据：

```
runoobdb=# DELETE FROM COMPANY WHERE ID = 2;
```

得到结果如下：

```
 id | name  | age | address     | salary
----+-------+-----+-------------+--------
  1 | Paul  |  32 | California  |  20000
  3 | Teddy |  23 | Norway      |  20000
  4 | Mark  |  25 | Rich-Mond   |  65000
  5 | David |  27 | Texas       |  85000
  6 | Kim   |  22 | South-Hall  |  45000
  7 | James |  24 | Houston     |  10000
(6 rows)
```

从上面结果可以看出，id 为 2 的数据已被删除。

以下语句将删除整张 COMPANY 表：

```
DELETE FROM COMPANY;
```

# PostgreSQL LIKE 子句

在 PostgreSQL 数据库中，我们如果要获取包含某些字符的数据，可以使用 **LIKE** 子句。

在 LIKE 子句中，通常与通配符结合使用，通配符表示任意字符，在 PostgreSQL 中，主要有以下两种通配符：

- 百分号 %
- 下划线 _

如果没有使用以上两种通配符，LIKE 子句和等号 = 得到的结果是一样的。 

### 语法

以下是使用 LIKE 子句搭配百分号 **%** 和下划线 **_** 从数据库中获取数据的通用语法：

```
SELECT FROM table_name WHERE column LIKE 'XXXX%';
或者
SELECT FROM table_name WHERE column LIKE '%XXXX%';
或者
SELECT FROM table_name WHERE column LIKE 'XXXX_';
或者
SELECT FROM table_name WHERE column LIKE '_XXXX';
或者
SELECT FROM table_name WHERE column LIKE '_XXXX_';
```

你可以在 WHERE 子句中指定任何条件。

你可以使用 AND 或者 OR 指定一个或多个条件。

**XXXX** 可以是任何数字或者字符。

### 实例

下面是 LIKE 语句中演示了 % 和 _  的一些差别:

| 实例                            | 描述                                                   |
| :------------------------------ | :----------------------------------------------------- |
| WHERE SALARY::text LIKE '200%'  | 找出 SALARY 字段中以 200 开头的数据。                  |
| WHERE SALARY::text LIKE '%200%' | 找出 SALARY 字段中含有 200 字符的数据。                |
| WHERE SALARY::text LIKE '_00%'  | 找出 SALARY 字段中在第二和第三个位置上有 00 的数据。   |
| WHERE SALARY::text LIKE '2_%_%' | 找出 SALARY 字段中以 2 开头的字符长度大于 3 的数据。   |
| WHERE SALARY::text LIKE '%2'    | 找出 SALARY 字段中以 2 结尾的数据                      |
| WHERE SALARY::text LIKE '_2%3'  | 找出 SALARY 字段中 2 在第二个位置上并且以 3 结尾的数据 |
| WHERE SALARY::text LIKE '2___3' | 找出 SALARY 字段中以 2 开头，3 结尾并且是 5 位数的数据 |

在 PostgreSQL 中，LIKE 子句是只能用于对字符进行比较，因此在上面例子中，我们要将整型数据类型转化为字符串数据类型。

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

下面实例将找出 AGE 以 2 开头的数据：

```
runoobdb=# SELECT * FROM COMPANY WHERE AGE::text LIKE '2%';
```

得到以下结果：

```
id | name  | age | address     | salary
----+-------+-----+-------------+--------
  2 | Allen |  25 | Texas       |  15000
  3 | Teddy |  23 | Norway      |  20000
  4 | Mark  |  25 | Rich-Mond   |  65000
  5 | David |  27 | Texas       |  85000
  6 | Kim   |  22 | South-Hall  |  45000
  7 | James |  24 | Houston     |  10000
  8 | Paul  |  24 | Houston     |  20000
(7 rows)
```

下面实例将找出 address 字段中含有 **-** 字符的数据：

```
runoobdb=# SELECT * FROM COMPANY WHERE ADDRESS  LIKE '%-%';
```

得到结果如下：

```
id | name | age |                      address              | salary
----+------+-----+-------------------------------------------+--------
  4 | Mark |  25 | Rich-Mond                                 |  65000
  6 | Kim  |  22 | South-Hall                                |  45000
(2 rows)
```

# PostgreSQL LIMIT 子句

PostgreSQL 中的 **limit** 子句用于限制 SELECT 语句中查询的数据的数量。

### 语法

带有 LIMIT 子句的 SELECT 语句的基本语法如下：

```
SELECT column1, column2, columnN
FROM table_name
LIMIT [no of rows]
```

下面是 LIMIT 子句与 OFFSET 子句一起使用时的语法：

```
SELECT column1, column2, columnN 
FROM table_name
LIMIT [no of rows] OFFSET [row num]
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

下面实例将找出限定的数量的数据，即读取 4 条数据：

```
runoobdb=# SELECT * FROM COMPANY LIMIT 4;
```

得到以下结果：

```
 id | name  | age | address     | salary
----+-------+-----+-------------+--------
  1 | Paul  |  32 | California  |  20000
  2 | Allen |  25 | Texas       |  15000
  3 | Teddy |  23 | Norway      |  20000
  4 | Mark  |  25 | Rich-Mond   |  65000
(4 rows)
```

但是，在某些情况下，可能需要从一个特定的偏移开始提取记录。

下面是一个实例，从第三位开始提取 3 个记录：

```
runoobdb=# SELECT * FROM COMPANY LIMIT 3 OFFSET 2;
```

得到以下结果：

```
 id | name  | age | address   | salary
----+-------+-----+-----------+--------
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
(3 rows)
```

# PostgreSQL ORDER BY  语句

在 PostgreSQL 中，**ORDER BY** 用于对一列或者多列数据进行升序（ASC）或者降序（DESC）排列。

### 语法

**ORDER BY** 子句的基础语法如下：

```
SELECT column-list
FROM table_name
[WHERE condition]
[ORDER BY column1, column2, .. columnN] [ASC | DESC];
```

您可以在 ORDER BY 中使用一列或者多列，但是必须保证要排序的列必须存在。

**ASC** 表示升序，**DESC** 表示降序。

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

下面实例将对结果根据 AGE 字段值进行升序排列：

```
runoobdb=# SELECT * FROM COMPANY ORDER BY AGE ASC;
```

得到以下结果：

```
 id | name  | age |                      address                       | salary 
----+-------+-----+----------------------------------------------------+--------
  6 | Kim   |  22 | South-Hall                                         |  45000
  3 | Teddy |  23 | Norway                                             |  20000
  7 | James |  24 | Houston                                            |  10000
  4 | Mark  |  25 | Rich-Mond                                          |  65000
  2 | Allen |  25 | Texas                                              |  15000
  5 | David |  27 | Texas                                              |  85000
  1 | Paul  |  32 | California                                         |  20000
(7 rows)
```

下面实例将对结果根据 NAME 字段值和 SALARY 字段值进行升序排序：

```
runoobdb=# SELECT * FROM COMPANY ORDER BY NAME, SALARY ASC;
```

得到以下结果：

```
 id | name  | age |                      address                       | salary 
----+-------+-----+----------------------------------------------------+--------
  2 | Allen |  25 | Texas                                              |  15000
  5 | David |  27 | Texas                                              |  85000
  7 | James |  24 | Houston                                            |  10000
  6 | Kim   |  22 | South-Hall                                         |  45000
  4 | Mark  |  25 | Rich-Mond                                          |  65000
  1 | Paul  |  32 | California                                         |  20000
  3 | Teddy |  23 | Norway                                             |  20000
(7 rows)
```

下面实例将对结果根据NAME字段值进行降序排列：

```
runoobdb=# SELECT * FROM COMPANY ORDER BY NAME DESC;
```

得到以下结果：

```
 id | name  | age |                      address                       | salary 
----+-------+-----+----------------------------------------------------+--------
  3 | Teddy |  23 | Norway                                             |  20000
  1 | Paul  |  32 | California                                         |  20000
  4 | Mark  |  25 | Rich-Mond                                          |  65000
  6 | Kim   |  22 | South-Hall                                         |  45000
  7 | James |  24 | Houston                                            |  10000
  5 | David |  27 | Texas                                              |  85000
  2 | Allen |  25 | Texas                                              |  15000
(7 rows)
```

# PostgreSQL GROUP BY 语句

在 PostgreSQL 中，**GROUP BY** 语句和 SELECT 语句一起使用，用来对相同的数据进行分组。

GROUP BY 在一个 SELECT 语句中，放在 WHRER 子句的后面，ORDER BY 子句的前面。

### 语法

下面给出了 GROUP BY 子句的基本语法:

```
SELECT column-list
FROM table_name
WHERE [ conditions ]
GROUP BY column1, column2....columnN
ORDER BY column1, column2....columnN
```

GROUP BY 子句必须放在 WHERE 子句中的条件之后，必须放在 ORDER BY 子句之前。

在 GROUP BY 子句中，你可以对一列或者多列进行分组，但是被分组的列必须存在于列清单中。

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

下面实例将根据 NAME 字段值进行分组，找出每个人的工资总额：

```
runoobdb=# SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME;
```

得到以下结果：

```
  name  |  sum
 -------+-------
  Teddy | 20000
  Paul  | 20000
  Mark  | 65000
  David | 85000
  Allen | 15000
  Kim   | 45000
  James | 10000
(7 rows)
```

现在我们添加使用下面语句在 CAMPANY 表中添加三条记录：

```
INSERT INTO COMPANY VALUES (8, 'Paul', 24, 'Houston', 20000.00);
INSERT INTO COMPANY VALUES (9, 'James', 44, 'Norway', 5000.00);
INSERT INTO COMPANY VALUES (10, 'James', 45, 'Texas', 5000.00);
```

现在 COMPANY 表中存在重复的名称，数据如下：

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

现在再根据 NAME 字段值进行分组，找出每个客户的工资总额：

```
runoobdb=# SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME ORDER BY NAME;
```

这时的得到的结果如下：

```
name  |  sum
-------+-------
 Allen | 15000
 David | 85000
 James | 20000
 Kim   | 45000
 Mark  | 65000
 Paul  | 40000
 Teddy | 20000
(7 rows)
```

下面实例将 ORDER BY 子句与 GROUP BY 子句一起使用：

```
runoobdb=#  SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME ORDER BY NAME DESC;
```

得到以下结果：

```
name  |  sum
-------+-------
 Teddy | 20000
 Paul  | 40000
 Mark  | 65000
 Kim   | 45000
 James | 20000
 David | 85000
 Allen | 15000
(7 rows)
```

# PostgreSQL WITH 子句

在 PostgreSQL 中，WITH 子句提供了一种编写辅助语句的方法，以便在更大的查询中使用。

WITH 子句有助于将复杂的大型查询分解为更简单的表单，便于阅读。这些语句通常称为通用表表达式（Common Table Express， CTE），也可以当做一个为查询而存在的临时表。

WITH 子句是在多次执行子查询时特别有用，允许我们在查询中通过它的名称(可能是多次)引用它。

WITH 子句在使用前必须先定义。

### 语法

WITH 查询的基础语法如下：

```
WITH
   name_for_summary_data AS (
      SELECT Statement)
   SELECT columns
   FROM name_for_summary_data
   WHERE conditions <=> (
      SELECT column
      FROM name_for_summary_data)
   [ORDER BY columns]
```

**name_for_summary_data** 是 WITH 子句的名称，**name_for_summary_data** 可以与现有的表名相同，并且具有优先级。

可以在 WITH 中使用数据 INSERT, UPDATE 或 DELETE 语句，允许您在同一个查询中执行多个不同的操作。

### WITH 递归

在 WITH 子句中可以使用自身输出的数据。

公用表表达式 (CTE) 具有一个重要的优点，那就是能够引用其自身，从而创建递归 CTE。递归 CTE 是一个重复执行初始 CTE 以返回数据子集直到获取完整结果集的公用表表达式。

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

下面将使用 WITH 子句在上表中查询数据：

```
With CTE AS
(Select
 ID
, NAME
, AGE
, ADDRESS
, SALARY
FROM COMPANY )
Select * From CTE;
```

得到结果如下：

```
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

接下来让我们使用 **RECURSIVE** 关键字和 WITH 子句编写一个查询，查找 **SALARY(工资)** 字段小于 20000 的数据并计算它们的和：

```
WITH RECURSIVE t(n) AS (
   VALUES (0)
   UNION ALL
   SELECT SALARY FROM COMPANY WHERE SALARY < 20000
)
SELECT sum(n) FROM t;
```

得到结果如下：

```
 sum
-------
 25000
(1 row)
```

下面我们建立一张和 COMPANY 表相似的 COMPANY1 表，使用 DELETE 语句和 WITH 子句删除 COMPANY 表中 **SALARY(工资)** 字段大于等于 30000 的数据，并将删除的数据插入 COMPANY1 表，实现将 COMPANY 表数据转移到 COMPANY1 表中：

```
CREATE TABLE COMPANY1(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);


WITH moved_rows AS (
   DELETE FROM COMPANY
   WHERE
      SALARY >= 30000
   RETURNING *
)
INSERT INTO COMPANY1 (SELECT * FROM moved_rows);
```

得到结果如下：

```
INSERT 0 3
```

此时，CAMPANY 表和 CAMPANY1 表的数据如下：

```
runoobdb=# SELECT * FROM COMPANY;
 id | name  | age |  address   | salary
----+-------+-----+------------+--------
  1 | Paul  |  32 | California |  20000
  2 | Allen |  25 | Texas      |  15000
  3 | Teddy |  23 | Norway     |  20000
  7 | James |  24 | Houston    |  10000
(4 rows)


runoobdb=# SELECT * FROM COMPANY1;
 id | name  | age | address | salary
----+-------+-----+-------------+--------
  4 | Mark  |  25 | Rich-Mond   |  65000
  5 | David |  27 | Texas       |  85000
  6 | Kim   |  22 | South-Hall  |  45000
(3 rows)
```

# PostgreSQL HAVING 子句

HAVING 子句可以让我们筛选分组后的各组数据。

WHERE 子句在所选列上设置条件，而 HAVING 子句则在由 GROUP BY 子句创建的分组上设置条件。

### 语法

下面是 HAVING 子句在 SELECT 查询中的位置：

```
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
```

HAVING 子句必须放置于 GROUP BY 子句后面，ORDER BY 子句前面，下面是 HAVING 子句在 SELECT 语句中基础语法：

```
SELECT column1, column2
FROM table1, table2
WHERE [ conditions ]
GROUP BY column1, column2
HAVING [ conditions ]
ORDER BY column1, column2
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

下面实例将找出根据 NAME 字段值进行分组，并且 **name(名称)** 字段的计数少于 2 数据：

```
SELECT NAME FROM COMPANY GROUP BY name HAVING count(name) < 2;
```

得到以下结果：

```
  name
 -------
  Teddy
  Paul
  Mark
  David
  Allen
  Kim
  James
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

下面实例将找出根据 name 字段值进行分组，并且名称的计数大于 1 数据：

```
runoobdb-# SELECT NAME FROM COMPANY GROUP BY name HAVING count(name) > 1;
```

得到结果如下：

```
 name
-------
 Paul
 James
(2 rows)
```

# PostgreSQL DISTINCT 关键字

在 PostgreSQL 中，DISTINCT 关键字与 SELECT 语句一起使用，用于去除重复记录，只获取唯一的记录。

我们平时在操作数据时，有可能出现一种情况，在一个表中有多个重复的记录，当提取这样的记录时，DISTINCT 关键字就显得特别有意义，它只获取唯一一次记录，而不是获取重复记录。

### 语法

用于去除重复记录的 DISTINCT 关键字的基本语法如下：

```
SELECT DISTINCT column1, column2,.....columnN
FROM table_name
WHERE [condition]
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

让我们插入两条数据：

```
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
VALUES (8, 'Paul', 32, 'California', 20000.00 );

INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
VALUES (9, 'Allen', 25, 'Texas', 15000.00 );
```

现在数据如下：

```
 id | name  | age | address    | salary
----+-------+-----+------------+--------
  1 | Paul  |  32 | California |  20000
  2 | Allen |  25 | Texas      |  15000
  3 | Teddy |  23 | Norway     |  20000
  4 | Mark  |  25 | Rich-Mond  |  65000
  5 | David |  27 | Texas      |  85000
  6 | Kim   |  22 | South-Hall |  45000
  7 | James |  24 | Houston    |  10000
  8 | Paul  |  32 | California |  20000
  9 | Allen |  25 | Texas      |  15000
(9 rows)
```

接下来我们找出 COMPANY 表中的所有 NAME：

```
runoobdb=# SELECT name FROM COMPANY;
```

得到结果如下：

```
 name
-------
 Paul
 Allen
 Teddy
 Mark
 David
 Kim
 James
 Paul
 Allen
(9 rows)
```

现在我们在 SELECT 语句中使用 DISTINCT 子句：

```
runoobdb=# SELECT DISTINCT name FROM COMPANY;
```

得到结果如下：

```
name
-------
 Teddy
 Paul
 Mark
 David
 Allen
 Kim
 James
(7 rows)
```

从结果可以看到，重复数据已经被删除。

- 

- 

## 5.1. 表基础



​    关系型数据库中的一个表非常像纸上的一张表：它由行和列组成。列的数量和顺序是固定的，并且每一列拥有一个名字。行的数目是变化的，它反映了在一个给定时刻表中存储的数据量。SQL并不保证表中行的顺序。当一个表被读取时，表中的行将以非特定顺序出现，除非明确地指定需要排序。这些将在[第 7 章](http://www.postgres.cn/docs/13/queries.html)介绍。此外，SQL不会为行分配唯一的标识符，因此在一个表中可能会存在一些完全相同的行。这是SQL之下的数学模型导致的结果，但并不是所期望的。稍后在本章中我们将看到如何处理这种问题。  

​    每一列都有一个数据类型。数据类型约束着一组可以分配给列的可能值，并且它为列中存储的数据赋予了语义，这样它可以用于计算。例如，一个被声明为数字类型的列将不会接受任何文本串，而存储在这样一列中的数据可以用来进行数学计算。反过来，一个被声明为字符串类型的列将接受几乎任何一种的数据，它可以进行如字符串连接的操作但不允许进行数学计算。  

   PostgreSQL包括了相当多的内建数据类型，可以适用于很多应用。用户也可以定义他们自己的数据类型。大部分内建数据类型有着显而易见的名称和语义，所以我们将它们的详细解释放在[第 8 章](http://www.postgres.cn/docs/13/datatype.html)中。一些常用的数据类型是：用于整数的`integer`；可以用于分数的`numeric`；用于字符串的`text`，用于日期的`date`，用于一天内时间的`time`以及可以同时包含日期和时间的`timestamp`。  



   要创建一个表，我们要用到[CREATE TABLE](http://www.postgres.cn/docs/13/sql-createtable.html)命令。在这个命令中 我们需要为新表至少指定一个名字、列的名字及数据类型。例如：

```
CREATE TABLE my_first_table (
    first_column text,
    second_column integer
);
```

   这将创建一个名为`my_first_table`的表，它拥有两个列。第一个列名为`first_column`且数据类型为`text`；第二个列名为`second_column`且数据类型为`integer`。表和列的名字遵循[第 4.1.1 节](http://www.postgres.cn/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS)中解释的标识符语法。类型名称通常也是标识符，但是也有些例外。注意列的列表由逗号分隔并被圆括号包围。  

   当然，前面的例子是非常不自然的。通常，我们为表和列赋予的名称都会表明它们存储着什么类别的数据。因此让我们再看一个更现实的例子：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric
);
```

   （`numeric`类型能够存储小数部分，典型的例子是金额。）  

### 提示

​    当我们创建很多相关的表时，最好为表和列选择一致的命名模式。例如，一种选择是用单数或复数名词作为表名，每一种都受到一些理论家支持。   

   一个表能够拥有的列的数据是有限的，根据列的类型，这个限制介于250和1600之间。但是，极少会定义一个接近这个限制的表，即便有也是一个值的商榷的设计。  



   如果我们不再需要一个表，我们可以通过使用[DROP TABLE](http://www.postgres.cn/docs/13/sql-droptable.html)命令来移除它。例如：

```
DROP TABLE my_first_table;
DROP TABLE products;
```

   尝试移除一个不存在的表会引起错误。然而，在SQL脚本中在创建每个表之前无条件地尝试移除它的做法是很常见的，即使发生错误也会忽略之，因此这样的脚本可以在表存在和不存在时都工作得很好（如果你喜欢，可以使用`DROP TABLE IF EXISTS`变体来防止出现错误消息，但这并非标准SQL）。  

   如果我们需要修改一个已经存在的表，请参考本章稍后的[第 5.6 节](http://www.postgres.cn/docs/13/ddl-alter.html)。  

   利用到目前为止所讨论的工具，我们可以创建一个全功能的表。本章的后续部分将集中于为表定义增加特性来保证数据完整性、安全性或方便。如果你希望现在就去填充你的表，你可以跳过这些直接去[第 6 章](http://www.postgres.cn/docs/13/dml.html)。  

## 5.2. 默认值



   一个列可以被分配一个默认值。当一个新行被创建且没有为某些列指定值时，这些列将会被它们相应的默认值填充。一个数据操纵命令也可以显式地要求一个列被置为它的默认值，而不需要知道这个值到底是什么（数据操纵命令详见[第 6 章](http://www.postgres.cn/docs/13/dml.html)）。  

​      如果没有显式指定默认值，则默认值是空值。这是合理的，因为空值表示未知数据。  

   在一个表定义中，默认值被列在列的数据类型之后。例如：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric DEFAULT 9.99
);
```

  

   默认值可以是一个表达式，它将在任何需要插入默认值的时候被实时计算（*不*是表创建时）。一个常见的例子是为一个`timestamp`列指定默认值为`CURRENT_TIMESTAMP`，这样它将得到行被插入时的时间。另一个常见的例子是为每一行生成一个“序列号” 。这在PostgreSQL可以按照如下方式实现：

```
CREATE TABLE products (
    product_no integer DEFAULT nextval('products_product_no_seq'),
    ...
);
```

   这里`nextval()`函数从一个*序列对象*[第 9.16 节](http://www.postgres.cn/docs/13/functions-sequence.html)）。还有一种特别的速写：

```
CREATE TABLE products (
    product_no SERIAL,
    ...
);
```

   `SERIAL`速写将在[第 8.1.4 节](http://www.postgres.cn/docs/13/datatype-numeric.html#DATATYPE-SERIAL)进一步讨论。  

## 5.3. 生成列



   生成的列是一个特殊的列，它总是从其他列计算而来。因此说，它对于列就像视图对于表一样。生成列有两种:存储列和虚拟列。   存储生成列在写入(插入或更新)时计算，并且像普通列一样占用存储空间。虚拟生成列不占用存储空间并且在读取时进行计算。   如此看来，虚拟生成列类似于视图，存储生成列类似于物化视图(除了它总是自动更新之外)。   PostgreSQL目前只实现了存储生成列。  

   建立一个生成列，在 `CREATE TABLE`中使用 `GENERATED ALWAYS AS` 子句, 例如:

```
CREATE TABLE people (
    ...,
    height_cm numeric,
    height_in numeric GENERATED ALWAYS AS (height_cm / 2.54) STORED
);
```

   必须指定关键字 `STORED` 以选择存储类型的生成列。更多细节请参见 [CREATE TABLE](http://www.postgres.cn/docs/13/sql-createtable.html) 。  

   生成列不能被直接写入.     在`INSERT` 或 `UPDATE` 命令中, 不能为生成列指定值, 但是可以指定关键字`DEFAULT`。  

   考虑列缺省情况和生成列之间的差异。   如果没有提供其他值，列缺省情况下在行被首次插入时计算一次;生成列则在行每次改变时进行更新，并且不能被取代。   列缺省情况下不能引用表的其他列；生成表达式通常会这样做。   列缺省情况下可以使用易失性函数，例如`random()`或引用当前时间函数; 而对于生成列这是不允许的。  

   生成列和涉及生成列的表的定义有几个限制:    

- ​      生成表达式只能使用不可变函数，并且不能使用子查询或以任何方式引用当前行以外的任何内容。     
- ​      生成表达式不能引用另一个生成列。     
- ​      生成表达式不能引用系统表，除了 `tableoid`。     
- ​      生成列不能具有列默认或标识定义。     
- ​      生成列不能是分区键的一部分。     
- ​      外部表可以有生成列.  更多细节请参见 [CREATE FOREIGN TABLE](http://www.postgres.cn/docs/13/sql-createforeigntable.html) .     

  

   使用生成列的其他注意事项。   

- ​      生成列保留着有别于其下层的基础列的访问权限。因此，可以对其进行排列以便于从生成列中读取特定的角色，而不是从下层基础列。     
- ​      从概念上讲，生成列在`BEFORE` 触发器运行后更新。      因此，`BEFORE` 触发器中的基础列所做的变更将反映在生成列中。       但相反，不允许访问`BEFORE` 触发器中的生成列。     

## 5.4. 约束

- [5.4.1. 检查约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-CHECK-CONSTRAINTS)
- [5.4.2. 非空约束](http://www.postgres.cn/docs/13/ddl-constraints.html#id-1.5.4.6.6)
- [5.4.3. 唯一约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS)
- [5.4.4. 主键](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-PRIMARY-KEYS)
- [5.4.5. 外键](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-FK)
- [5.4.6. 排他约束](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-EXCLUSION)



​    数据类型是一种限制能够存储在表中数据类别的方法。但是对于很多应用来说，它们提供的约束太粗糙。例如，一个包含产品价格的列应该只接受正值。但是没有任何一种标准数据类型只接受正值。另一个问题是我们可能需要根据其他列或行来约束一个列中的数据。例如，在一个包含产品信息的表中，对于每个产品编号应该只有一行。  

   到目前为止，SQL允许我们在列和表上定义约束。约束让我们能够根据我们的愿望来控制表中的数据。如果一个用户试图在一个列中保存违反一个约束的数据，一个错误会被抛出。即便是这个值来自于默认值定义，这个规则也同样适用。  

### 5.4.1. 检查约束



​    一个检查约束是最普通的约束类型。它允许我们指定一个特定列中的值必须要满足一个布尔表达式。例如，为了要求正值的产品价格，我们可以使用：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric CHECK (price > 0)
);
```

   

​    如你所见，约束定义就和默认值定义一样跟在数据类型之后。默认值和约束之间的顺序没有影响。一个检查约束有关键字`CHECK`以及其后的包围在圆括号中的表达式组成。检查约束表达式应该涉及到被约束的列，否则该约束也没什么实际意义。   



​    我们也可以给与约束一个独立的名称。这会使得错误消息更为清晰，同时也允许我们在需要更改约束时能引用它。语法为：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric CONSTRAINT positive_price CHECK (price > 0)
);
```

​    要指定一个命名的约束，请在约束名称标识符前使用关键词`CONSTRAINT`，然后把约束定义放在标识符之后（如果没有以这种方式指定一个约束名称，系统将会为我们选择一个）。   

​    一个检查约束也可以引用多个列。例如我们存储一个普通价格和一个打折后的价格，而我们希望保证打折后的价格低于普通价格：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric CHECK (price > 0),
    discounted_price numeric CHECK (discounted_price > 0),
    CHECK (price > discounted_price)
);
```

   

​    前两个约束看起来很相似。第三个则使用了一种新语法。它并没有依附在一个特定的列，而是作为一个独立的项出现在逗号分隔的列列表中。列定义和这种约束定义可以以混合的顺序出现在列表中。   

​    我们将前两个约束称为列约束，而第三个约束为表约束，因为它独立于任何一个列定义。列约束也可以写成表约束，但反过来不行，因为一个列约束只能引用它所依附的那一个列（PostgreSQL并不强制要求这个规则，但是如果我们希望表定义能够在其他数据库系统中工作，那就应该遵循它）。上述例子也可以写成：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric,
    CHECK (price > 0),
    discounted_price numeric,
    CHECK (discounted_price > 0),
    CHECK (price > discounted_price)
);
```

​    甚至是：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric CHECK (price > 0),
    discounted_price numeric,
    CHECK (discounted_price > 0 AND price > discounted_price)
);
```

​    这只是口味的问题。   

​    表约束也可以用列约束相同的方法来指定名称：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric,
    CHECK (price > 0),
    discounted_price numeric,
    CHECK (discounted_price > 0),
    CONSTRAINT valid_discount CHECK (price > discounted_price)
);
```

   



​    需要注意的是，一个检查约束在其检查表达式值为真或空值时被满足。因为当任何操作数为空时大部分表达式将计算为空值，所以它们不会阻止被约束列中的空值。为了保证一个列不包含空值，可以使用下一节中的非空约束。   

### 注意

​     PostgreSQL不支持引用表数据以外的要检查的新增或更新的行的`CHECK`约束。     虽然违反此规则的`CHECK`约束在简单测试中看起来能工作，它不能保证数据库不会达到约束条件为假(false)的状态（由于涉及的其他行随后发生了更改）。     这将导致数据库转储和重新加载失败。 即使完整的数据库状态与约束一致，重新加载也可能失败，因为行未按照满足约束的顺序加载。      如果可能的话，使用`UNIQUE`, `EXCLUDE`,或 `FOREIGN KEY`约束以表示跨行和跨表限制。    

​     如果你希望的是在插入行时的时候对其他行进行一次性检查，而不是持续维护的一致性保证，一个自定义的 [trigger](http://www.postgres.cn/docs/13/triggers.html) 可以用于实现这个功能。     （此方法避免了转储/重新加载问题，因为pg_dump不会重新安装触发器直到重新加载数据之后，因此不会在转储/重新加载期间强制执行检查。）    

### 注意

​     PostgreSQL假定`CHECK`约束的条件是不可变的，也就是说，它们始终为同一输入行提供相同的结果。     这个假设是仅在插入或更新行时,而不是在其他时间检查`CHECK`约束的原因。      （上面关于不引用其他表数据的警告实际上是此限制的特殊情况。）    

​     打破此假设的常见方法的一个示例是在 `CHECK`表达式中引用用户定义的函数，然后更改该函数的行为。     PostgreSQL不会禁止那样，但它不会注意到现在表中是否有行违反了`CHECK`约束。这将导致后续数据库转储和重新加载失败。     处理此类更改的建议方法是删除约束（使用`ALTER TABLE`），调整函数定义，然后重新添加约束，从而对所有表行进行重新检查。    

### 5.4.2. 非空约束



​    一个非空约束仅仅指定一个列中不会有空值。语法例子：

```
CREATE TABLE products (
    product_no integer NOT NULL,
    name text NOT NULL,
    price numeric
);
```

   

​    一个非空约束总是被写成一个列约束。一个非空约束等价于创建一个检查约束`CHECK (*`column_name`*    IS NOT NULL)`，但在PostgreSQL中创建一个显式的非空约束更高效。这种方式创建的非空约束的缺点是我们无法为它给予一个显式的名称。   

​    当然，一个列可以有多于一个的约束，只需要将这些约束一个接一个写出：

```
CREATE TABLE products (
    product_no integer NOT NULL,
    name text NOT NULL,
    price numeric NOT NULL CHECK (price > 0)
);
```

​    约束的顺序没有关系，因为并不需要决定约束被检查的顺序。   

​    `NOT NULL`约束有一个相反的情况：`NULL`约束。这并不意味着该列必须为空，进而肯定是无用的。相反，它仅仅选择了列可能为空的默认行为。SQL标准中并不存在`NULL`约束，因此它不能被用于可移植的应用中（PostgreSQL中加入它是为了和某些其他数据库系统兼容）。但是某些用户喜欢它，因为它使得在一个脚本文件中可以很容易的进行约束切换。例如，初始时我们可以：

```
CREATE TABLE products (
    product_no integer NULL,
    name text NULL,
    price numeric NULL
);
```

​    然后可以在需要的地方插入`NOT`关键词。   

### 提示

​     在大部分数据库中多数列应该被标记为非空。    

### 5.4.3. 唯一约束



​    唯一约束保证\在一列中或者一组列中保存的数据在表中所有行间是唯一的。写成一个列约束的语法是：

```
CREATE TABLE products (
    product_no integer UNIQUE,
    name text,
    price numeric
);
```

​    写成一个表约束的语法是：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric,
    UNIQUE (product_no)
);
```

​    当写入表约束时。   

​    要为一组列定义一个唯一约束，把它写作一个表级约束，列名用逗号分隔：

```
CREATE TABLE example (
    a integer,
    b integer,
    c integer,
    UNIQUE (a, c)
);
```

​    这指定这些列的组合值在整个表的范围内是唯一的，但其中任意一列的值并不需要是（一般也不是）唯一的。   

​    我们可以通常的方式为一个唯一索引命名：

```
CREATE TABLE products (
    product_no integer CONSTRAINT must_be_different UNIQUE,
    name text,
    price numeric
);
```

   

​    增加一个唯一约束会在约束中列出的列或列组上自动创建一个唯一B-tree索引。只覆盖某些行的唯一性限制不能被写为一个唯一约束，但可以通过创建一个唯一的[部分索引](http://www.postgres.cn/docs/13/indexes-partial.html)来强制这种限制。   



​     通常，如果表中有超过一行在约束所包括列上的值相同，将会违反唯一约束。但是在这种比较中，两个空值被认为是不同的。这意味着即便存在一个唯一约束，也可以存储多个在至少一个被约束列中包含空值的行。这种行为符合SQL标准，但我们听说一些其他SQL数据库可能不遵循这个规则。所以在开发需要可移植的应用时应注意这一点。   

### 5.4.4. 主键



​    一个主键约束表示可以用作表中行的唯一标识符的一个列或者一组列。这要求那些值都是唯一的并且非空。因此，下面的两个表定义接受相同的数据：

```
CREATE TABLE products (
    product_no integer UNIQUE NOT NULL,
    name text,
    price numeric
);
```



```
CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);
```

   

​    主键也可以包含多于一个列，其语法和唯一约束相似：

```
CREATE TABLE example (
    a integer,
    b integer,
    c integer,
    PRIMARY KEY (a, c)
);
```

   

​    增加一个主键将自动在主键中列出的列或列组上创建一个唯一B-tree索引。并且会强制这些列被标记为`NOT NULL`。   

​    一个表最多只能有一个主键（可以有任意数量的唯一和非空约束，它们可以达到和主键几乎一样的功能，但只能有一个被标识为主键）。关系数据库理论要求每一个表都要有一个主键。但PostgreSQL中并未强制要求这一点，但是最好能够遵循它。   

​    主键对于文档和客户端应用都是有用的。例如，一个允许修改行值的 GUI 应用可能需要知道一个表的主键，以便能唯一地标识行。如果定义了主键，数据库系统也有多种方法来利用主键。例如，主键定义了外键要引用的默认目标列。   

### 5.4.5. 外键



​    一个外键约束指定一列（或一组列）中的值必须匹配出现在另一个表中某些行的值。我们说这维持了两个关联表之间的*引用完整性*。   

​    例如我们有一个使用过多次的产品表：

```
CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);
```

​    让我们假设我们还有一个存储这些产品订单的表。我们希望保证订单表中只包含真正存在的产品的订单。因此我们在订单表中定义一个引用产品表的外键约束：

```
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    product_no integer REFERENCES products (product_no),
    quantity integer
);
```

​    现在就不可能创建包含不存在于产品表中的`product_no`值（非空）的订单。   

​    我们说在这种情况下，订单表是*引用*表而产品表是*被引用*表。相应地，也有引用和被引用列的说法。   

​    我们也可以把上述命令简写为：

```
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    product_no integer REFERENCES products,
    quantity integer
);
```

​    因为如果缺少列的列表，则被引用表的主键将被用作被引用列。   

​    一个外键也可以约束和引用一组列。照例，它需要被写成表约束的形式。下面是一个例子：

```
CREATE TABLE t1 (
  a integer PRIMARY KEY,
  b integer,
  c integer,
  FOREIGN KEY (b, c) REFERENCES other_table (c1, c2)
);
```

​    当然，被约束列的数量和类型应该匹配被引用列的数量和类型。   

​    按照前面的方式，我们可以为一个外键约束命名。   

​    一个表可以有超过一个的外键约束。这被用于实现表之间的多对多关系。例如我们有关于产品和订单的表，但我们现在希望一个订单能包含多种产品（这在上面的结构中是不允许的）。我们可以使用这种表结构：

```
CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    shipping_address text,
    ...
);

CREATE TABLE order_items (
    product_no integer REFERENCES products,
    order_id integer REFERENCES orders,
    quantity integer,
    PRIMARY KEY (product_no, order_id)
);
```

​    注意在最后一个表中主键和外键之间有重叠。   



​    我们知道外键不允许创建与任何产品都不相关的订单。但如果一个产品在一个引用它的订单创建之后被移除会发生什么？SQL允许我们处理这种情况。直观上，我们有几种选项：    

- 不允许删除一个被引用的产品
- 同时也删除引用产品的订单
- 其他？

   

​    为了说明这些，让我们在上面的多对多关系例子中实现下面的策略：当某人希望移除一个仍然被一个订单引用（通过`order_items`）的产品时 ，我们组织它。如果某人移除一个订单，订单项也同时被移除：

```
CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name text,
    price numeric
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    shipping_address text,
    ...
);

CREATE TABLE order_items (
    product_no integer REFERENCES products ON DELETE RESTRICT,
    order_id integer REFERENCES orders ON DELETE CASCADE,
    quantity integer,
    PRIMARY KEY (product_no, order_id)
);
```

   

​    限制删除或者级联删除是两种最常见的选项。`RESTRICT`阻止删除一个被引用的行。`NO ACTION`表示在约束被检察时如果有任何引用行存在，则会抛出一个错误，这是我们没有指定任何东西时的默认行为（这两种选择的本质不同在于`NO ACTION`允许检查被推迟到事务的最后，而`RESTRICT`则不会）。`CASCADE`指定当一个被引用行被删除后，引用它的行也应该被自动删除。还有其他两种选项：`SET NULL`和`SET DEFAULT`。这些将导致在被引用行被删除后，引用行中的引用列被置为空值或它们的默认值。注意这些并不会是我们免于遵守任何约束。例如，如果一个动作指定了`SET DEFAULT`，但是默认值不满足外键约束，操作将会失败。   

​    与`ON DELETE`相似，同样有`ON UPDATE`可以用在一个被引用列被修改（更新）的情况，可选的动作相同。在这种情况下，`CASCADE`意味着被引用列的更新值应该被复制到引用行中。   

​    正常情况下，如果一个引用行的任意一个引用列都为空，则它不需要满足外键约束。如果在外键定义中加入了`MATCH FULL`，一个引用行只有在它的所有引用列为空时才不需要满足外键约束（因此空和非空值的混合肯定会导致`MATCH FULL`约束失败）。如果不希望引用行能够避开外键约束，将引用行声明为`NOT NULL`。   

​    一个外键所引用的列必须是一个主键或者被唯一约束所限制。这意味着被引用列总是拥有一个索引（位于主键或唯一约束之下的索引），因此在其上进行的一个引用行是否匹配的检查将会很高效。由于从被引用表中`DELETE`一行或者`UPDATE`一个被引用列将要求对引用表进行扫描以得到匹配旧值的行，在引用列上建立合适的索引也会大有益处。由于这种做法并不是必须的，而且创建索引也有很多种选择，所以外键约束的定义并不会自动在引用列上创建索引。   

​    更多关于更新和删除数据的信息请见[第 6 章](http://www.postgres.cn/docs/13/dml.html)。外键约束的语法描述请参考[CREATE TABLE](http://www.postgres.cn/docs/13/sql-createtable.html)。   

### 5.4.6. 排他约束



​    排他约束保证如果将任何两行的指定列或表达式使用指定操作符进行比较，至少其中一个操作符比较将会返回否或空值。语法是：

```
CREATE TABLE circles (
    c circle,
    EXCLUDE USING gist (c WITH &&)
);
```

   

​    详见[`CREATE     TABLE ... CONSTRAINT ... EXCLUDE`](http://www.postgres.cn/docs/13/sql-createtable.html#SQL-CREATETABLE-EXCLUDE)。   

​    增加一个排他约束将在约束声明所指定的类型上自动创建索引。   

## 5.5. 系统列

   每一个表都拥有一些由系统隐式定义的*system columns*。因此，这些列的名字不能像用户定义的列一样使用（注意这种限制与名称是否为关键词没有关系，即便用引号限定一个名称也无法绕过这种限制）。 事实上用户不需要关心这些列，只需要知道它们存在即可。  



- `tableoid`

  ​      包含这一行的表的OID。该列是特别为从继承层次（见[第 5.10 节](http://www.postgres.cn/docs/13/ddl-inherit.html)）中选择的查询而准备，因为如果没有它将很难知道一行来自于哪个表。`tableoid`可以与`pg_class`的`oid`列进行连接来获得表的名称。     

- `xmin`

  ​      插入该行版本的事务身份（事务ID）。一个行版本是一个行的一个特别版本，对一个逻辑行的每一次更新都将创建一个新的行版本。     

- `cmin`

  ​      插入事务中的命令标识符（从0开始）。     

- `xmax`

  ​      删除事务的身份（事务ID），对于未删除的行版本为0。对于一个可见的行版本，该列值也可能为非零。这通常表示删除事务还没有提交，或者一个删除尝试被回滚。     

- `cmax`

  ​      删除事务中的命令标识符，或者为0。     

- `ctid`

  ​      行版本在其表中的物理位置。注意尽管`ctid`可以被用来非常快速地定位行版本，但是一个行的`ctid`会在被更新或者被`VACUUM FULL`移动时改变。因此，`ctid`不能作为一个长期行标识符。      应使用主键来标识逻辑行。     

​    事务标识符也是32位量。在一个历时长久的数据库中事务ID同样会绕回。但如果采取适当的维护过程，这不会是一个致命的问题，详见[第 24 章](http://www.postgres.cn/docs/13/maintenance.html)。但是，长期（超过10亿个事务）依赖事务ID的唯一性是不明智的。   

​    命令标识符也是32位量。这对一个事务中包含的SQL命令设置了一个硬极限：    232（40亿）。在实践中，该限制并不是问题 — 注意该限制只是针对SQL命令的数目而不是被处理的行数。同样，只有真正    修改了数据库内容的命令才会消耗一个命令标识符。   

## 5.6. 修改表

- [5.6.1. 增加列](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-ADDING-A-COLUMN)
- [5.6.2. 移除列](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-REMOVING-A-COLUMN)
- [5.6.3. 增加约束](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-ADDING-A-CONSTRAINT)
- [5.6.4. 移除约束](http://www.postgres.cn/docs/13/ddl-alter.html#DDL-ALTER-REMOVING-A-CONSTRAINT)
- [5.6.5. 更改列的默认值](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.9)
- [5.6.6. 修改列的数据类型](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.10)
- [5.6.7. 重命名列](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.11)
- [5.6.8. 重命名表](http://www.postgres.cn/docs/13/ddl-alter.html#id-1.5.4.8.12)



   当我们已经创建了一个表并意识到犯了一个错误或者应用需求发生改变时，我们可以移除表并重新创建它。但如果表中已经被填充数据或者被其他数据库对象引用（例如有一个外键约束），这种做法就显得很不方便。因此，PostgreSQL提供了一族命令来对已有的表进行修改。注意这和修改表中所包含的数据是不同的，这里要做的是对表的定义或者说结构进行修改。  

   利用这些命令，我们可以：   

- 增加列
- 移除列
- 增加约束
- 移除约束
- 修改默认值
- 修改列数据类型
- 重命名列
- 重命名表

   所有这些动作都由[ALTER TABLE](http://www.postgres.cn/docs/13/sql-altertable.html)命令执行，其参考页面中包含更详细的信息。  

### 5.6.1. 增加列



​    要增加一个列，可以使用这样的命令：

```
ALTER TABLE products ADD COLUMN description text;
```

​    新列将被默认值所填充（如果没有指定`DEFAULT`子句，则会填充空值）。   

### 提示

​     从 PostgreSQL 11开始，添加一个具有常量默认值的列不再意味着在执行`ALTER TABLE` 语句时需要更新表的每一行。     相反，默认值将在下次访问该行时返回，并在表被重写时应用，从而使得`ALTER TABLE`即使在大表上也非常快。    

​     但是，如果默认值是可变的（例如`clock_timestamp()`），则每一行需要被`ALTER TABLE`被执行时计算的值更新。     为避免潜在的长时间的更新操作，特别是如果你想要用大多数非默认值填充列，那么最好添加没有默认值的列，再用 `UPDATE`插入正确的值，然后按照下面所述添加任何期望的默认值。    

​    也可以同时为列定义约束，语法：

```
ALTER TABLE products ADD COLUMN description text CHECK (description <> '');
```

​    事实上`CREATE TABLE`中关于一列的描述都可以应用在这里。记住不管怎样，默认值必须满足给定的约束，否则`ADD`将会失败。也可以先将新列正确地填充好，然后再增加约束（见后文）。   

### 5.6.2. 移除列



​    为了移除一个列，使用如下的命令：

```
ALTER TABLE products DROP COLUMN description;
```

​    列中的数据将会消失。涉及到该列的表约束也会被移除。然而，如果该列被另一个表的外键所引用，PostgreSQL不会安静地移除该约束。我们可以通过增加`CASCADE`来授权移除任何依赖于被删除列的所有东西：

```
ALTER TABLE products DROP COLUMN description CASCADE;
```

​    关于这个操作背后的一般性机制请见[第 5.14 节](http://www.postgres.cn/docs/13/ddl-depend.html)。   

### 5.6.3. 增加约束



​    为了增加一个约束，可以使用表约束的语法，例如：

```
ALTER TABLE products ADD CHECK (name <> '');
ALTER TABLE products ADD CONSTRAINT some_name UNIQUE (product_no);
ALTER TABLE products ADD FOREIGN KEY (product_group_id) REFERENCES product_groups;
```

​    要增加一个不能写成表约束的非空约束，可使用语法：

```
ALTER TABLE products ALTER COLUMN product_no SET NOT NULL;
```

   

​    该约束会立即被检查，所以表中的数据必须在约束被增加之前就已经符合约束。   

### 5.6.4. 移除约束



​    为了移除一个约束首先需要知道它的名称。如果在创建时已经给它指定了名称，那么事情就变得很容易。否则约束的名称是由系统生成的，我们必须先找出这个名称。psql的命令`\d    *`表名`*`将会对此有所帮助，其他接口也会提供方法来查看表的细节。因此命令是：

```
ALTER TABLE products DROP CONSTRAINT some_name;
```

​    （如果处理的是自动生成的约束名称，如`$2`，别忘了用双引号使它变成一个合法的标识符。）   

​    和移除一个列相似，如果需要移除一个被某些别的东西依赖的约束，也需要加上`CASCADE`。一个例子是一个外键约束依赖于被引用列上的一个唯一或者主键约束。   

​    这对除了非空约束之外的所有约束类型都一样有效。为了移除一个非空约束可以用：

```
ALTER TABLE products ALTER COLUMN product_no DROP NOT NULL;
```

​    （回忆一下，非空约束是没有名称的，所以不能用第一种方式。）   

### 5.6.5. 更改列的默认值



​    要为一个列设置一个新默认值，使用命令：

```
ALTER TABLE products ALTER COLUMN price SET DEFAULT 7.77;
```

​    注意这不会影响任何表中已经存在的行，它只是为未来的`INSERT`命令改变了默认值。   

​    要移除任何默认值，使用：

```
ALTER TABLE products ALTER COLUMN price DROP DEFAULT;
```

​    这等同于将默认值设置为空值。相应的，试图删除一个未被定义的默认值并不会引发错误，因为默认值已经被隐式地设置为空值。   

### 5.6.6. 修改列的数据类型



​    为了将一个列转换为一种不同的数据类型，使用如下命令：

```
ALTER TABLE products ALTER COLUMN price TYPE numeric(10,2);
```

​    只有当列中的每一个项都能通过一个隐式造型转换为新的类型时该操作才能成功。如果需要一种更复杂的转换，应该加上一个`USING`子句来指定应该如何把旧值转换为新值。   

​    PostgreSQL将尝试把列的默认值转换为新类型，其他涉及到该列的任何约束也是一样。但是这些转换可能失败或者产生奇特的结果。因此最好在修改类型之前先删除该列上所有的约束，然后在修改完类型后重新加上相应修改过的约束。   

### 5.6.7. 重命名列



​    要重命名一个列：

```
ALTER TABLE products RENAME COLUMN product_no TO product_number;
```

   

### 5.6.8. 重命名表



​    要重命名一个表：

```
ALTER TABLE products RENAME TO items;
```

## 5.7. 权限



   一旦一个对象被创建，它会被分配一个所有者。所有者通常是执行创建语句的角色。对于大部分类型的对象，初始状态下只有所有者（或者超级用户）能够对该对象做任何事情。为了允许其他角色使用它，必须分配*权限*。  

   有多种不同的权限：`SELECT`、`INSERT`、`UPDATE`、`DELETE`、`TRUNCATE`、`REFERENCES`、`TRIGGER`、`CREATE`、`CONNECT`、`TEMPORARY`、`EXECUTE`以及`USAGE`。可以应用于一个特定对象的权限随着对象的类型（表、函数等）而不同。   有关这些权限含义的更多详细信息请参阅下文。后续的章节将介绍如何使用这些权限。  

   修改或销毁一个对象的权力通常是只有所有者才有的权限。  

   一个对象可以通过该对象类型相应的`ALTER`命令来重新分配所有者，例如

```
ALTER TABLE table_name OWNER TO new_owner;
```

   超级用户总是可以做到这点，普通角色只有同时是对象的当前所有者（或者是拥有角色的一个成员）以及新拥有角色的一个成员时才能做同样的事。  

   要分配权限，可以使用[GRANT](http://www.postgres.cn/docs/13/sql-grant.html)命令。例如，如果`joe`是一个已有角色，而`accounts`是一个已有表，更新该表的权限可以按如下方式授权：

```
GRANT UPDATE ON accounts TO joe;
```

   用`ALL`取代特定权限会把与对象类型相关的所有权限全部授权。  

   一个特殊的名为`PUBLIC`的“角色”可以用来向系统中的每一个角色授予一个权限。同时，在数据库中有很多用户时可以设置“组”角色来帮助管理权限。详见[第 21 章](http://www.postgres.cn/docs/13/user-manag.html)。  

   为了撤销一个权限，使用[REVOKE](http://www.postgres.cn/docs/13/sql-revoke.html) 命令：

```
REVOKE ALL ON accounts FROM PUBLIC;
```

   对象拥有者的特殊权限（即执行`DROP`、`GRANT`、`REVOKE`等的权力）总是隐式地属于拥有者，并且不能被授予或撤销。但是对象拥有者可以选择撤销他们自己的普通权限，例如把一个表变得对他们自己和其他人只读。  

   一般情况下，只有对象拥有者（或者超级用户）可以授予或撤销一个对象上的权限。但是可以在授予权限时使用“with grant option”来允许接收人将权限转授给其他人。如果后来授予选项被撤销，则所有从接收人那里获得的权限（直接或者通过授权链获得）都将被撤销。更多详情请见[GRANT](http://www.postgres.cn/docs/13/sql-grant.html)和[REVOKE](http://www.postgres.cn/docs/13/sql-revoke.html)参考页。  

   有效的权限如下:    

- `SELECT`

  ​       允许 [SELECT](http://www.postgres.cn/docs/13/sql-select.html) 从任何列、或特定的列、表、视图、物化视图、或其他类似表格的对象。       也允许使用 [COPY](http://www.postgres.cn/docs/13/sql-copy.html) TO.       还需要这个权限来引用[UPDATE](http://www.postgres.cn/docs/13/sql-update.html) 或 [DELETE](http://www.postgres.cn/docs/13/sql-delete.html)中现有的列值。       对于序列，这个权限还允许使用`currval` 函数。对于大对象，此权限允许读取对象。      

- `INSERT`

  ​       允许将新行的 [INSERT](http://www.postgres.cn/docs/13/sql-insert.html) 加入表、视图等等。       可以在特定列上授予，在这种情况下`INSERT`命令中只有那些列可以被分配（其他列将因此而收到默认值）。       还允许使用[COPY](http://www.postgres.cn/docs/13/sql-copy.html) FROM。      

- `UPDATE`

  ​       允许 [UPDATE](http://www.postgres.cn/docs/13/sql-update.html) 更新任何列、或指定列、表、视图等等。       (实际上，任何有效的`UPDATE`命令也需要`SELECT`权限，因为它必须引用表列来确定要更新的行，和/或计算列的新值。)       `SELECT ... FOR UPDATE`和`SELECT ... FOR SHARE`除了`SELECT`权限外，还需要至少一列上的这个权限。       对于序列，这个权限允许使用 `nextval` 和 `setval` 函数。对于大对象，此权限允许写入或截断对象。      

- `DELETE`

  ​       允许 [DELETE](http://www.postgres.cn/docs/13/sql-delete.html) 从表、视图等等中删除行.       (实际上，任何有效的`DELETE`命令也需要`SELECT`权限，因为它必须引用表列来确定要删除的行。)      

- `TRUNCATE`

  ​       允许在表、视图等等上 [TRUNCATE](http://www.postgres.cn/docs/13/sql-truncate.html) 。      

- `REFERENCES`

  ​       允许创建引用表或表的特定列的外键约束。      

- `TRIGGER`

  ​       允许在表、视图等等上创建触发器。      

- `CREATE`

  ​       对于数据库，允许在数据库中创建新的模式和发布。             对于模式，允许在模式中创建新对象。要重命名现有对象，你必须拥有对象 *and*所包含模式的此权限。             对于表空间，允许在表空间中创建表、索引和临时文件，并允许创建将表空间作为默认表空间的数据库。（注意，撤销此特权不会更改已有对象的位置。）      

- `CONNECT`

  ​       允许受让者连接到数据库。此权限在连接启动时进行检查(加之`pg_hba.conf`施加的任何约束).      

- `TEMPORARY`

  ​       允许在使用数据库时创建临时表。      

- `EXECUTE`

  ​       允许调用函数或过程，包括使用在函数之上实现的任何运算符。这是适用于函数和过程的唯一权限类型。      

- `USAGE`

  ​       对于程序语言，允许使用语言来创建该语言的函数。 这是适用于过程语言的唯一权限类型。             对于模式，允许访问模式中包含的对象（假设对象自己的权限要求也已得到满足）。        从本质上讲，这允许受让者“look up”模式中的对象。如果没有此权限，仍可以看到对象名称，例如通过查询系统目录。       此外，在撤消此权限后，现有会话可能还具有以前执行过此查找的语句，因此这不是阻止对象访问的彻底安全的方法。             对于序列, 允许使用`currval` 和 `nextval` 函数.             对于类型和域，允许在创建表、函数和其他模式对象时使用类型或域。       （注意，此权限不控制类型的全部 “usage” ，例如查询中出现的类型的值。 它仅防止创建依赖于类型的对象。        此权限的主要目的是控制哪些用户可以对类型创建依赖项，这可能会防止所有者以后更改类型。	）                对于外部数据包装器，允许使用外部数据包装器创建新服务器。             对于外部服务器，允许使用服务器创建外部表。受让者还可以创建、更改或删除与该服务器关联的自己的用户映射。      

   其他命令所需的权限罗列在相应命令的参考页上。  

   在创建对象时，PostgreSQL默认将某些类型对象的权限授予`PUBLIC`。   默认情况下，在表、表列、序列、外部数据包装器、外部服务器、大型对象、模式或表空间上，不向`PUBLIC`授予权限。   对于其他类型的对象，授予 `PUBLIC`的默认权限如下所示：   针对数据库的`CONNECT`和`TEMPORARY`（创建临时表）权限;   针对函数和程序的`EXECUTE`权限;以及针对语言和数据类型（包括域）的`USAGE`权限。   当然，对象所有者可以`REVOKE`默认权限和特别授予的权限。   （为了最大程度的安全性，在创建对象的同一事务中发出`REVOKE`;那么就没有其他用户能够使用该对象的窗口。）   此外，可以使用[ALTER DEFAULT PRIVILEGES](http://www.postgres.cn/docs/13/sql-alterdefaultprivileges.html)命令取代这些默认权限设置。  

   [表 5.1](http://www.postgres.cn/docs/13/ddl-priv.html#PRIVILEGE-ABBREVS-TABLE)显示了*ACL*（访问控制列表）值中用于这些权限类型的单字母缩写。   你将在下面列出的 [psql](http://www.postgres.cn/docs/13/app-psql.html) 命令的输出中，或者在查看系统目录的 ACL 列时看到这些字母。  

**表 5.1. ACL 权限缩写**

| 权限         | 缩写         | 适用对象类型                                                 |
| ------------ | ------------ | ------------------------------------------------------------ |
| `SELECT`     | `r` (“读”)   | `LARGE OBJECT`,       `SEQUENCE`,       `TABLE` (and table-like objects),       table column |
| `INSERT`     | `a` (“增补”) | `TABLE`, table column                                        |
| `UPDATE`     | `w` (“写”)   | `LARGE OBJECT`,       `SEQUENCE`,       `TABLE`,       table column |
| `DELETE`     | `d`          | `TABLE`                                                      |
| `TRUNCATE`   | `D`          | `TABLE`                                                      |
| `REFERENCES` | `x`          | `TABLE`, table column                                        |
| `TRIGGER`    | `t`          | `TABLE`                                                      |
| `CREATE`     | `C`          | `DATABASE`,       `SCHEMA`,       `TABLESPACE`               |
| `CONNECT`    | `c`          | `DATABASE`                                                   |
| `TEMPORARY`  | `T`          | `DATABASE`                                                   |
| `EXECUTE`    | `X`          | `FUNCTION`, `PROCEDURE`                                      |
| `USAGE`      | `U`          | `DOMAIN`,       `FOREIGN DATA WRAPPER`,       `FOREIGN SERVER`,       `LANGUAGE`,       `SCHEMA`,       `SEQUENCE`,       `TYPE` |



   [表 5.2](http://www.postgres.cn/docs/13/ddl-priv.html#PRIVILEGES-SUMMARY-TABLE) 使用上面所示的缩写总结了每种类型 SQL 对象可用的权限.   它还显示可用于检查每种对象类型的特权设置的 psql 命令。  

**表 5.2. 访问权限摘要**

| 对象类型                         | 所有权限  | 默认 `PUBLIC` 权限 | psql 命令 |
| -------------------------------- | --------- | ------------------ | --------- |
| `DATABASE`                       | `CTc`     | `Tc`               | `\l`      |
| `DOMAIN`                         | `U`       | `U`                | `\dD+`    |
| `FUNCTION` or `PROCEDURE`        | `X`       | `X`                | `\df+`    |
| `FOREIGN DATA WRAPPER`           | `U`       | none               | `\dew+`   |
| `FOREIGN SERVER`                 | `U`       | none               | `\des+`   |
| `LANGUAGE`                       | `U`       | `U`                | `\dL+`    |
| `LARGE OBJECT`                   | `rw`      | none               |           |
| `SCHEMA`                         | `UC`      | none               | `\dn+`    |
| `SEQUENCE`                       | `rwU`     | none               | `\dp`     |
| `TABLE` (and table-like objects) | `arwdDxt` | none               | `\dp`     |
| Table column                     | `arwx`    | none               | `\dp`     |
| `TABLESPACE`                     | `C`       | none               | `\db+`    |
| `TYPE`                           | `U`       | `U`                | `\dT+`    |



​      已授予特定对象的权限显示为`aclitem`项的列表，其中每个`aclitem`项描述了特定授予者授予给一个被授与者的权限。       例如，`calvin=r*w/hobbes` 指明角色`calvin`具有`SELECT`（`r`）权限和授予选项（`*`）以及不可授予权限`UPDATE`（`w`），均由角色`hobbes`授予。   如果`calvin`对由其他授予人授予的同一对象也具有一些权限，那将显示为单独的`aclitem`条目。   `aclitem` 中的空受赠方字段代表`PUBLIC`。  

   例如，假设用户`miriam`创建了表`mytable`并且:

```
GRANT SELECT ON mytable TO PUBLIC;
GRANT SELECT, UPDATE, INSERT ON mytable TO admin;
GRANT SELECT (col1), UPDATE (col1) ON mytable TO miriam_rw;
```

   则 psql的 `\dp` 命令将显示:

```
=> \dp mytable
                                  Access privileges
 Schema |  Name   | Type  |   Access privileges   |   Column privileges   | Policies
-−-−-−-−+-−-−-−-−-+-−-−-−-+-−-−-−-−-−-−-−-−-−-−-−-+-−-−-−-−-−-−-−-−-−-−-−-+-−-−-−-−-−
 public | mytable | table | miriam=arwdDxt/miriam+| col1:                +|
        |         |       | =r/miriam            +|   miriam_rw=rw/miriam |
        |         |       | admin=arw/miriam      |                       |
(1 row)
```

  

   如果“Access privileges”列对于给定对象为空，则表示该对象具有默认权限（也就是说，它在相关系统目录中的权限条目为空）。    默认权限始终包含所有者的所有权限，并且可以包括 `PUBLIC` 的一些权限，具体取决于对象类型，如上所述。    对象上的第一个`GRANT`或`REVOKE`将实例化默认权限（例如，生成`miriam_arwdDxt/miriam`），然后根据指定的请求修改它们。    类似的，只有具有非默认特权的列的条目才显示在“Column privileges”中。（注意：为此目的，“default privileges”始终表示对象类型的内置缺省权限。其权限受`ALTER DEFAULT PRIVILEGES` 命令影响的对象将始终显示一个显式权限条目，其中包含 `ALTER`。）  

   注意所有者的隐式授予选项没有在访问权限显示中标记。仅当授予选项被显式授予给某人时才会出现`*`。  

## 5.8. 行安全性策略



   除可以通过[GRANT](http://www.postgres.cn/docs/13/sql-grant.html)使用 SQL 标准的   [特权系统](http://www.postgres.cn/docs/13/ddl-priv.html)之外，表还可以具有   *行安全性策略*，它针对每一个用户限制哪些行可以   被普通的查询返回或者可以被数据修改命令插入、更新或删除。这种   特性也被称为*行级安全性*。默认情况下，表不具有   任何策略，这样用户根据 SQL 特权系统具有对表的访问特权，对于   查询或更新来说其中所有的行都是平等的。  

   当在一个表上启用行安全性时（使用   [ALTER TABLE ... ENABLE ROW LEVEL    SECURITY](http://www.postgres.cn/docs/13/sql-altertable.html)），所有对该表选择行或者修改行的普通访问都必须被一条   行安全性策略所允许（不过，表的拥有者通常不服从行安全性策略）。如果   表上不存在策略，将使用一条默认的否定策略，即所有的行都不可见或者不能   被修改。应用在整个表上的操作不服从行安全性，例如`TRUNCATE`和   `REFERENCES`。  

   行安全性策略可以针对特定的命令、角色或者两者。一条策略可以被指定为   适用于`ALL`命令，或者`SELECT`、   `INSERT`、`UPDATE`、或者`DELETE`。   可以为一条给定策略分配多个角色，并且通常的角色成员关系和继承规则也适用。  

   要指定哪些行根据一条策略是可见的或者是可修改的，需要一个返回布尔结果   的表达式。对于每一行，在计算任何来自用户查询的条件或函数之前，先会计   算这个表达式（这条规则的唯一例外是`leakproof`函数，   它们被保证不会泄露信息，优化器可能会选择在行安全性检查之前应用这类   函数）。使该表达式不返回`true`的行将不会被处理。可以指定   独立的表达式来单独控制哪些行可见以及哪些行被允许修改。策略表达式会作   为查询的一部分运行并且带有运行该查询的用户的特权，但是安全性定义者函数   可以被用来访问对调用用户不可用的数据。  

   具有`BYPASSRLS`属性的超级用户和角色在访问一个表时总是   可以绕过行安全性系统。表拥有者通常也能绕过行安全性，不过表拥有者   可以选择用[ALTER    TABLE ... FORCE ROW LEVEL SECURITY](http://www.postgres.cn/docs/13/sql-altertable.html)来服从行安全性。  

   启用和禁用行安全性以及向表增加策略是只有表拥有者具有的特权。  

   策略的创建可以使用[CREATE POLICY](http://www.postgres.cn/docs/13/sql-createpolicy.html)命令，策略的修改   可以使用[ALTER POLICY](http://www.postgres.cn/docs/13/sql-alterpolicy.html)命令，而策略的删除可以使用   [DROP POLICY](http://www.postgres.cn/docs/13/sql-droppolicy.html)命令。要为一个给定表启用或者禁用行   安全性，可以使用[ALTER TABLE](http://www.postgres.cn/docs/13/sql-altertable.html)命令。  

   每一条策略都有名称并且可以为一个表定义多条策略。由于策略是表相   关的，一个表的每一条策略都必须有一个唯一的名称。不同的表可以拥有   相同名称的策略。  

   当多条策略适用于一个给定的查询时，会把它们用`OR`（对宽容性策略，默认的策略类型）或者`AND`（对限制性策略）组合在一起。这和给定角色拥有它作为成员的所有角色的特权的规则类似。宽容性策略和限制性策略在下文将会进一步讨论。  

   作为一个简单的例子，这里是如何在`account`关系上   创建一条策略以允许只有`managers`角色的成员能访问行，   并且只能访问它们账户的行：  

```
CREATE TABLE accounts (manager text, company text, contact_email text);

ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY account_managers ON accounts TO managers
    USING (manager = current_user);
```

   上面的策略隐含地提供了一个与其该约束适用于被一个命令选择的行（这样一个经理不能`SELECT`、`UPDATE`或者`DELETE`属于其他经理的已有行）以及被一个命令修改的行（这样属于其他经理的行不能通过`INSERT`或者`UPDATE`创建）。  

   如果没有指定角色或者使用了特殊的用户名`PUBLIC`，   则该策略适用于系统上所有的用户。要允许所有用户访问`users`   表中属于他们自己的行，可以使用一条简单的策略：  

```
CREATE POLICY user_policy ON users
    USING (user_name = current_user);
```

   这个例子的效果和前一个类似。  

   为了对增加到表中的行使用与可见行不同的策略，可以组合多条策略。这一对策略将允许所有用户查看`users`表中的所有行，但只能修改他们自己的行：  

```
CREATE POLICY user_sel_policy ON users
    FOR SELECT
    USING (true);
CREATE POLICY user_mod_policy ON users
    USING (user_name = current_user);
```

   在一个`SELECT`命令中，这两条规则被用`OR`组合在一起，最终的效应就是所有的行都能被选择。在其他命令类型中，只有第二条策略适用，这样其效果就和以前相同。  

   也可以用`ALTER TABLE`命令禁用行安全性。禁用行安全性   不会移除定义在表上的任何策略，它们只是被简单地忽略。然后该表中的所有   行都是可见的并且可修改，服从于标准的 SQL 特权系统。  

   下面是一个较大的例子，它展示了这种特性如何被用于生产环境。表   `passwd`模拟了一个 Unix 口令文件：  

```
-− 简单的口令文件例子
CREATE TABLE passwd (
  user_name             text UNIQUE NOT NULL,
  pwhash                text,
  uid                   int  PRIMARY KEY,
  gid                   int  NOT NULL,
  real_name             text NOT NULL,
  home_phone            text,
  extra_info            text,
  home_dir              text NOT NULL,
  shell                 text NOT NULL
);

CREATE ROLE admin;  -− 管理员
CREATE ROLE bob;    -− 普通用户
CREATE ROLE alice;  -− 普通用户

-− 填充表
INSERT INTO passwd VALUES
  ('admin','xxx',0,0,'Admin','111-222-3333',null,'/root','/bin/dash');
INSERT INTO passwd VALUES
  ('bob','xxx',1,1,'Bob','123-456-7890',null,'/home/bob','/bin/zsh');
INSERT INTO passwd VALUES
  ('alice','xxx',2,1,'Alice','098-765-4321',null,'/home/alice','/bin/zsh');

-− 确保在表上启用行级安全性
ALTER TABLE passwd ENABLE ROW LEVEL SECURITY;

-− 创建策略
-− 管理员能看见所有行并且增加任意行
CREATE POLICY admin_all ON passwd TO admin USING (true) WITH CHECK (true);
-− 普通用户可以看见所有行
CREATE POLICY all_view ON passwd FOR SELECT USING (true);
-− 普通用户可以更新它们自己的记录，但是限制普通用户可用的 shell
CREATE POLICY user_mod ON passwd FOR UPDATE
  USING (current_user = user_name)
  WITH CHECK (
    current_user = user_name AND
    shell IN ('/bin/bash','/bin/sh','/bin/dash','/bin/zsh','/bin/tcsh')
  );

-− 允许管理员有所有普通权限
GRANT SELECT, INSERT, UPDATE, DELETE ON passwd TO admin;
-− 用户只在公共列上得到选择访问
GRANT SELECT
  (user_name, uid, gid, real_name, home_phone, extra_info, home_dir, shell)
  ON passwd TO public;
-− 允许用户更新特定行
GRANT UPDATE
  (pwhash, real_name, home_phone, extra_info, shell)
  ON passwd TO public;
```

   对于任意安全性设置来说，重要的是测试并确保系统的行为符合预期。   使用上述的例子，下面展示了权限系统工作正确：  

```
-− admin 可以看到所有的行和域
postgres=> set role admin;
SET
postgres=> table passwd;
 user_name | pwhash | uid | gid | real_name |  home_phone  | extra_info | home_dir    |   shell
-−-−-−-−-−-+-−-−-−-−+-−-−-+-−-−-+-−-−-−-−-−-+-−-−-−-−-−-−-−+-−-−-−-−-−-−+-−-−-−-−-−-−-+-−-−-−-−-−-
 admin     | xxx    |   0 |   0 | Admin     | 111-222-3333 |            | /root       | /bin/dash
 bob       | xxx    |   1 |   1 | Bob       | 123-456-7890 |            | /home/bob   | /bin/zsh
 alice     | xxx    |   2 |   1 | Alice     | 098-765-4321 |            | /home/alice | /bin/zsh
(3 rows)

-− 测试 Alice 能做什么
postgres=> set role alice;
SET
postgres=> table passwd;
ERROR:  permission denied for relation passwd
postgres=> select user_name,real_name,home_phone,extra_info,home_dir,shell from passwd;
 user_name | real_name |  home_phone  | extra_info | home_dir    |   shell
-−-−-−-−-−-+-−-−-−-−-−-+-−-−-−-−-−-−-−+-−-−-−-−-−-−+-−-−-−-−-−-−-+-−-−-−-−-−-
 admin     | Admin     | 111-222-3333 |            | /root       | /bin/dash
 bob       | Bob       | 123-456-7890 |            | /home/bob   | /bin/zsh
 alice     | Alice     | 098-765-4321 |            | /home/alice | /bin/zsh
(3 rows)

postgres=> update passwd set user_name = 'joe';
ERROR:  permission denied for relation passwd
-− Alice 被允许更改她自己的 real_name，但不能改其他的
postgres=> update passwd set real_name = 'Alice Doe';
UPDATE 1
postgres=> update passwd set real_name = 'John Doe' where user_name = 'admin';
UPDATE 0
postgres=> update passwd set shell = '/bin/xx';
ERROR:  new row violates WITH CHECK OPTION for "passwd"
postgres=> delete from passwd;
ERROR:  permission denied for relation passwd
postgres=> insert into passwd (user_name) values ('xxx');
ERROR:  permission denied for relation passwd
-− Alice 可以更改她自己的口令；行级安全性会悄悄地阻止更新其他行
postgres=> update passwd set pwhash = 'abc';
UPDATE 1
```

   目前为止所有构建的策略都是宽容性策略，也就是当多条策略都适用时会被适用“OR”布尔操作符组合在一起。而宽容性策略可以被用来仅允许在预计情况中对行的访问，这比将宽容性策略与限制性策略（记录必须通过这类策略并且它们会被“AND”布尔操作符组合起来）组合在一起更简单。在上面的例子之上，我们增加一条限制性策略要求通过一个本地Unix套接字连接过来的管理员访问`passwd`表的记录：  

```
CREATE POLICY admin_local_only ON passwd AS RESTRICTIVE TO admin
    USING (pg_catalog.inet_client_addr() IS NULL);
```

   然后，由于这条限制性规则的存在，我们可以看到从网络连接进来的管理员将无法看到任何记录：  

```
=> SELECT current_user;
 current_user 
-−-−-−-−-−-−-−
 admin
(1 row)

=> select inet_client_addr();
 inet_client_addr 
-−-−-−-−-−-−-−-−-−
 127.0.0.1
(1 row)

=> SELECT current_user;
 current_user 
-−-−-−-−-−-−-−
 admin
(1 row)

=> TABLE passwd;
 user_name | pwhash | uid | gid | real_name | home_phone | extra_info | home_dir | shell
-−-−-−-−-−-+-−-−-−-−+-−-−-+-−-−-+-−-−-−-−-−-+-−-−-−-−-−-−+-−-−-−-−-−-−+-−-−-−-−-−+-−-−-−-
(0 rows)

=> UPDATE passwd set pwhash = NULL;
UPDATE 0
```

   参照完整性检查（例如唯一或逐渐约束和外键引用）总是会绕过行级安全性以   保证数据完整性得到维护。在开发模式和行级安全性时必须小心避免   “隐通道”通过这类参照完整性检查泄露信息。  

   在某些环境中确保行安全性没有被应用很重要。例如，在做备份时，如果   行安全性悄悄地导致某些行被从备份中忽略掉，这会是灾难性的。在这类   情况下，你可以设置[row_security](http://www.postgres.cn/docs/13/runtime-config-client.html#GUC-ROW-SECURITY)配置参数为   `off`。这本身不会绕过行安全性，它所做的是如果任何结果会   被一条策略过滤掉，就会抛出一个错误。然后错误的原因就可以被找到并且   修复。  

   在上面的例子中，策略表达式只考虑了要被访问的行中的当前值。这是最简   单并且表现最好的情况。如果可能，最好设计行安全性应用以这种方式工作。   如果需要参考其他行或者其他表来做出策略的决定，可以在策略表达式中通过   使用子-`SELECT`或者包含`SELECT`的函数   来实现。不过要注意这类访问可能会导致竞争条件，在不小心的情况下这可能   会导致信息泄露。作为一个例子，考虑下面的表设计：  

```
-− 特权组的定义
CREATE TABLE groups (group_id int PRIMARY KEY,
                     group_name text NOT NULL);

INSERT INTO groups VALUES
  (1, 'low'),
  (2, 'medium'),
  (5, 'high');

GRANT ALL ON groups TO alice;  -− alice 是管理员
GRANT SELECT ON groups TO public;

-− 用户的特权级别的定义
CREATE TABLE users (user_name text PRIMARY KEY,
                    group_id int NOT NULL REFERENCES groups);

INSERT INTO users VALUES
  ('alice', 5),
  ('bob', 2),
  ('mallory', 2);

GRANT ALL ON users TO alice;
GRANT SELECT ON users TO public;

-− 保存要被保护的信息的表
CREATE TABLE information (info text,
                          group_id int NOT NULL REFERENCES groups);

INSERT INTO information VALUES
  ('barely secret', 1),
  ('slightly secret', 2),
  ('very secret', 5);

ALTER TABLE information ENABLE ROW LEVEL SECURITY;

-− 对于安全性 group_id 大于等于一行的 group_id 的用户，
-− 这一行应该是可见的/可更新的
CREATE POLICY fp_s ON information FOR SELECT
  USING (group_id <= (SELECT group_id FROM users WHERE user_name = current_user));
CREATE POLICY fp_u ON information FOR UPDATE
  USING (group_id <= (SELECT group_id FROM users WHERE user_name = current_user));

-− 我们只依赖于行级安全性来保护信息表
GRANT ALL ON information TO public;
```

   现在假设`alice`希望更改“有一点点秘密”   的信息，但是觉得`mallory`不应该看到该行中的新   内容，因此她这样做：  

```
BEGIN;
UPDATE users SET group_id = 1 WHERE user_name = 'mallory';
UPDATE information SET info = 'secret from mallory' WHERE group_id = 2;
COMMIT;
```

   这看起来是安全的，没有窗口可供`mallory`看到   “对 mallory 保密”的字符串。不过，这里有一种   竞争条件。如果`mallory`正在并行地做：

```
SELECT * FROM information WHERE group_id = 2 FOR UPDATE;
```

   并且她的事务处于`READ COMMITTED`模式，她就可能看到   “s对 mallory 保密”的东西。如果她的事务在`alice`   做完之后就到达`信息`行，这就会发生。它会阻塞等待   `alice`的事务提交，然后拜`FOR UPDATE`子句所赐   取得更新后的行内容。不过，对于来自`users`的隐式   `SELECT`，它*不会*取得一个已更新的行，   因为子-`SELECT`没有`FOR UPDATE`，相反   会使用查询开始时取得的快照读取`users`行。因此，   策略表达式会测试`mallory`的特权级别的旧值并且允许她看到   被更新的行。  

   有多种方法能解决这个问题。一种简单的答案是在行安全性策略中的   子-`SELECT`里使用`SELECT ... FOR SHARE`。   不过，这要求在被引用表（这里是`users`）上授予   `UPDATE`特权给受影响的用户，这可能不是我们想要的（   但是另一条行安全性策略可能被应用来阻止它们实际使用这个特权，或者   子-`SELECT`可能被嵌入到一个安全性定义者函数中）。   还有，在被引用的表上过多并发地使用行共享锁可能会导致性能问题，   特别是表更新比较频繁时。另一种解决方案（如果被引用表上的更新   不频繁就可行）是在更新被引用表时对它取一个排他锁，这样就没有   并发事务能够检查旧的行值了。或者我们可以在提交对被引用表的更新   之后、在做依赖于新安全性情况的更改之前等待所有并发事务结束。  

   更多细节请见[CREATE POLICY](http://www.postgres.cn/docs/13/sql-createpolicy.html)   和[ALTER TABLE](http://www.postgres.cn/docs/13/sql-altertable.html)。  



## 继承

- [5.10.1. 警告](http://www.postgres.cn/docs/13/ddl-inherit.html#DDL-INHERIT-CAVEATS)



   PostgreSQL实现了表继承，这对数据库设计者来说是一种有用的工具（SQL:1999及其后的版本定义了一种类型继承特性，但和这里介绍的继承有很大的不同）。  

​    让我们从一个例子开始：假设我们要为城市建立一个数据模型。每一个州有很多城市，但是只有一个首府。我们希望能够快速地检索任何特定州的首府城市。这可以通过创建两个表来实现：一个用于州首府，另一个用于不是首府的城市。然而，当我们想要查看一个城市的数据（不管它是不是一个首府）时会发生什么？继承特性将有助于解决这个问题。我们可以将`capitals`表定义为继承自`cities`表：

```
CREATE TABLE cities (
    name            text,
    population      float,
    altitude        int     -− in feet
);

CREATE TABLE capitals (
    state           char(2)
) INHERITS (cities);
```

   在这种情况下，`capitals`表*继承*了它的父表`cities`的所有列。州首府还有一个额外的列`state`用来表示它所属的州。  

   在PostgreSQL中，一个表可以从0个或者多个其他表继承，而对一个表的查询则可以引用一个表的所有行或者该表的所有行加上它所有的后代表。默认情况是后一种行为。例如，下面的查询将查找所有海拔高于500尺的城市的名称，包括州首府：

```
SELECT name, altitude
    FROM cities
    WHERE altitude > 500;
```

   对于来自PostgreSQL教程（见[第 2.1 节](http://www.postgres.cn/docs/13/tutorial-sql-intro.html)）的例子数据，它将返回：

```
   name    | altitude
-−-−-−-−-−-+-−-−-−-−-−
 Las Vegas |     2174
 Mariposa  |     1953
 Madison   |      845
```

  

   在另一方面，下面的查询将找到海拔超过500尺且不是州首府的所有城市：

```
SELECT name, altitude
    FROM ONLY cities
    WHERE altitude > 500;

   name    | altitude
-−-−-−-−-−-+-−-−-−-−-−
 Las Vegas |     2174
 Mariposa  |     1953
```

  

   这里的`ONLY`关键词指示查询只被应用于`cities`上，而其他在继承层次中位于`cities`之下的其他表都不会被该查询涉及。很多我们已经讨论过的命令（如`SELECT`、`UPDATE`和`DELETE`）都支持`ONLY`关键词。  

   我们也可以在表名后写上一个`*`来显式地将后代表包括在查询范围内：

```
SELECT name, altitude
    FROM cities*
    WHERE altitude > 500;
```

   写`*`不是必需的，因为这种行为总是默认的。不过，为了兼容可以修改默认值的较老版本，现在仍然支持这种语法。  

   在某些情况下，我们可能希望知道一个特定行来自于哪个表。每个表中的系统列`tableoid`可以告诉我们行来自于哪个表：

```
SELECT c.tableoid, c.name, c.altitude
FROM cities c
WHERE c.altitude > 500;
```

   将会返回：

```
 tableoid |   name    | altitude
-−-−-−-−-−+-−-−-−-−-−-+-−-−-−-−-−
   139793 | Las Vegas |     2174
   139793 | Mariposa  |     1953
   139798 | Madison   |      845
```

   （如果重新生成这个结果，可能会得到不同的OID数字。）通过与`pg_class`进行连接可以看到实际的表名：

```
SELECT p.relname, c.name, c.altitude
FROM cities c, pg_class p
WHERE c.altitude > 500 AND c.tableoid = p.oid;
```

   将会返回：

```
 relname  |   name    | altitude
-−-−-−-−-−+-−-−-−-−-−-+-−-−-−-−-−
 cities   | Las Vegas |     2174
 cities   | Mariposa  |     1953
 capitals | Madison   |      845
```

  

   另一种得到同样效果的方法是使用`regclass`别名类型，   它将象征性地打印出表的 OID：

```
SELECT c.tableoid::regclass, c.name, c.altitude
FROM cities c
WHERE c.altitude > 500;
```

  

   继承不会自动地将来自`INSERT`或`COPY`命令的数据传播到继承层次中的其他表中。在我们的例子中，下面的`INSERT`语句将会失败：

```
INSERT INTO cities (name, population, altitude, state)
VALUES ('Albany', NULL, NULL, 'NY');
```

   我们也许希望数据能被以某种方式被引入到`capitals`表中，但是这不会发生：`INSERT`总是向指定的表中插入。在某些情况下，可以通过使用一个规则（见[第 40 章](http://www.postgres.cn/docs/13/rules.html)）来将插入动作重定向。但是这对上面的情况并没有帮助，因为`cities`表根本就不包含`state`列，因而这个命令将在触发规则之前就被拒绝。  

   父表上的所有检查约束和非空约束都将自动被它的后代所继承，除非显式地指定了`NO INHERIT`子句。其他类型的约束（唯一、主键和外键约束）则不会被继承。  

   一个表可以从超过一个的父表继承，在这种情况下它拥有父表们所定义的列的并集。任何定义在子表上的列也会被加入到其中。如果在这个集合中出现重名列，那么这些列将被“合并”，这样在子表中只会有一个这样的列。重名列能被合并的前提是这些列必须具有相同的数据类型，否则会导致错误。可继承的检查约束和非空约束会以类似的方式被合并。例如，如果合并成一个合并列的任一列定义被标记为非空，则该合并列会被标记为非空。如果检查约束的名称相同，则他们会被合并，但如果它们的条件不同则合并会失败。  

   表继承通常是在子表被创建时建立，使用[CREATE TABLE](http://www.postgres.cn/docs/13/sql-createtable.html)语句的`INHERITS`子句。一个已经被创建的表也可以另外一种方式增加一个新的父亲关系，使用[ALTER TABLE](http://www.postgres.cn/docs/13/sql-altertable.html)的`INHERIT`变体。要这样做，新的子表必须已经包括和父表相同名称和数据类型的列。子表还必须包括和父表相同的检查约束和检查表达式。相似地，一个继承链接也可以使用`ALTER TABLE`的 `NO INHERIT`变体从一个子表中移除。动态增加和移除继承链接可以用于实现表划分（见[第 5.11 节](http://www.postgres.cn/docs/13/ddl-partitioning.html)）。  

   一种创建一个未来将被用做子女的新表的方法是在`CREATE   TABLE`中使用`LIKE`子句。这将创建一个和源表具有相同列的新表。如果源表上定义有任何`CHECK`约束，`LIKE`的`INCLUDING CONSTRAINTS`选项可以用来让新的子表也包含和父表相同的约束。  

   当有任何一个子表存在时，父表不能被删除。当子表的列或者检查约束继承于父表时，它们也不能被删除或修改。如果希望移除一个表和它的所有后代，一种简单的方法是使用`CASCADE`选项删除父表（见[第 5.14 节](http://www.postgres.cn/docs/13/ddl-depend.html)）。  

   [ALTER TABLE](http://www.postgres.cn/docs/13/sql-altertable.html)将会把列的数据定义或检查约束上的任何变化沿着继承层次向下传播。同样，删除被其他表依赖的列只能使用`CASCADE`选项。`ALTER TABLE`对于重名列的合并和拒绝遵循与`CREATE TABLE`同样的规则。  

   继承的查询仅在附表上执行访问权限检查。例如，在`cities`表上授予`UPDATE`权限也隐含着通过`cities`访问时在`capitals`表中更新行的权限。   这保留了数据（也）在父表中的样子。但是如果没有额外的授权，则不能直接更新`capitals`表。   此规则的两个例外是`TRUNCATE` 和 `LOCK TABLE`，总是检查子表的权限，不管它们是直接处理还是通过在父表上执行的那些命令递归处理。  

   以类似的方式，父表的行安全性策略（见[第 5.8 节](http://www.postgres.cn/docs/13/ddl-rowsecurity.html)）适用于继承查询期间来自于子表的行。   只有当子表在查询中被明确提到时，其策略（如果有）才会被应用，在那种情况下，附着在其父表上的任何策略都会被忽略。  

   外部表（见[第 5.12 节](http://www.postgres.cn/docs/13/ddl-foreign-data.html)）也可以是继承层次   中的一部分，即可以作为父表也可以作为子表，就像常规表一样。如果   一个外部表是继承层次的一部分，那么任何不被该外部表支持的操作也   不被整个层次所支持。  

### 5.10.1. 警告

   注意并非所有的SQL命令都能工作在继承层次上。用于数据查询、数据修改或模式修改（例如`SELECT`、`UPDATE`、`DELETE`、大部分`ALTER TABLE`的变体，但`INSERT`或`ALTER TABLE ... RENAME`不在此列）的命令会默认将子表包含在内并且支持`ONLY`记号来排除子表。负责数据库维护和调整的命令（如`REINDEX`、`VACUUM`）只工作在独立的、物理的表上并且不支持在继承层次上的递归。每个命令相应的行为请参见它们的参考页（[SQL 命令](http://www.postgres.cn/docs/13/sql-commands.html)）。  

   继承特性的一个严肃的限制是索引（包括唯一约束）和外键约束值应用在单个表上而非它们的继承子女。在外键约束的引用端和被引用端都是这样。因此，按照上面的例子：    

- ​      如果我们声明`cities`.`name`为`UNIQUE`或者`PRIMARY KEY`，这将不会阻止`capitals`表中拥有和`cities`中城市同名的行。而且这些重复的行将会默认显示在`cities`的查询中。事实上，`capitals`在默认情况下是根本不能拥有唯一约束的，并且因此能够包含多个同名的行。我们可以为`capitals`增加一个唯一约束，但这无法阻止相对于`cities`的重复。     
- ​      相似地，如果我们指定`cities`.`name` `REFERENCES`某个其他表，该约束不会自动地传播到`capitals`。在此种情况下，我们可以变通地在`capitals`上手工创建一个相同的`REFERENCES`约束。     
- ​      指定另一个表的列`REFERENCES cities(name)`将允许其他表包含城市名称，但不会包含首府名称。这对于这个例子不是一个好的变通方案。     

   某些未为继承层次结构实现的功能是为声明性分区实现的。在决定使用旧继承进行分区是否对应用程序有用时，需要非常小心。  



## 5.12. 外部数据



​    PostgreSQL实现了部分的SQL/MED规定，允许我们使用普通SQL查询来访问位于PostgreSQL之外的数据。这种数据被称为*外部数据*（注意这种用法不要和外键混淆，后者是数据库中的一种约束）。   

​    外部数据可以在一个*外部数据包装器*的帮助下被访问。一个外部数据包装器是一个库，它可以与一个外部数据源通讯，并隐藏连接到数据源和从它获取数据的细节。在`contrib`模块中有一些外部数据包装器，参见[附录 F](http://www.postgres.cn/docs/13/contrib.html)。其他类型的外部数据包装器可以在第三方产品中找到。如果这些现有的外部数据包装器都不能满足你的需要，可以自己编写一个，参见[第 56 章](http://www.postgres.cn/docs/13/fdwhandler.html)。   

​    要访问外部数据，我们需要建立一个*外部服务器*对象，它根据它所支持的外部数据包装器所使用的一组选项定义了如何连接到一个特定的外部数据源。接着我们需要创建一个或多个*外部表*，它们定义了外部数据的结构。一个外部表可以在查询中像一个普通表一样地使用，但是在PostgreSQL服务器中外部表没有存储数据。不管使用什么外部数据包装器，PostgreSQL会要求外部数据包装器从外部数据源获取数据，或者在更新命令的情况下传送数据到外部数据源。   

​    访问远程数据可能需要在外部数据源的授权。这些信息通过一个*用户映射*提供，它基于当前的PostgreSQL角色提供了附加的数据例如用户名和密码。   

​    更多信息请见    [CREATE FOREIGN DATA WRAPPER](http://www.postgres.cn/docs/13/sql-createforeigndatawrapper.html)、    [CREATE SERVER](http://www.postgres.cn/docs/13/sql-createserver.html)、    [CREATE USER MAPPING](http://www.postgres.cn/docs/13/sql-createusermapping.html)、    [CREATE FOREIGN TABLE](http://www.postgres.cn/docs/13/sql-createforeigntable.html)、以及    [IMPORT FOREIGN SCHEMA](http://www.postgres.cn/docs/13/sql-importforeignschema.html)。   

## 5.13. 其他数据库对象

   表是一个关系型数据库结构中的核心对象，因为它们承载了我们的数据。但是它们并不是数据库中的唯一一种对象。有很多其他种类的对象可以被创建来使得数据的使用和刮泥更加方便或高效。在本章中不会讨论它们，但是我们在会给出一个列表：  

- ​     视图    
- ​     函数、过程和操作符    
- ​     数据类型和域    
- ​     触发器和重写规则    

   这些主题的详细信息请见[第 V 部分](http://www.postgres.cn/docs/13/server-programming.html)。  

## 5.14. 依赖跟踪



   当我们创建一个涉及到很多具有外键约束、视图、触发器、函数等的表的复杂数据库结构时，我们隐式地创建了一张对象之间的依赖关系网。例如，具有一个外键约束的表依赖于它所引用的表。  

   为了保证整个数据库结构的完整性，PostgreSQL确保我们无法删除仍然被其他对象依赖的对象。例如，尝试删除[第 5.4.5 节](http://www.postgres.cn/docs/13/ddl-constraints.html#DDL-CONSTRAINTS-FK)中的产品表会导致一个如下的错误消息，因为有订单表依赖于产品表：

```
DROP TABLE products;

ERROR:  cannot drop table products because other objects depend on it
DETAIL:  constraint orders_product_no_fkey on table orders depends on table products
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
```

   该错误消息包含了一个有用的提示：如果我们不想一个一个去删除所有的依赖对象，我们可以执行：

```
DROP TABLE products CASCADE;
```

   这样所有的依赖对象将被移除，同样依赖于它们的任何对象也会被递归删除。在这种情况下，订单表不会被移除，但是它的外键约束会被移除。之所以在这里会停下，是因为没有什么依赖着外键约束（如果希望检查`DROP ... CASCADE`会干什么，运行不带`CASCADE`的`DROP`并阅读`DETAIL`输出）。  

   PostgreSQL中的几乎所有`DROP`命令都支持`CASCADE`。当然，其本质的区别随着对象的类型而不同。我们也可以用`RESTRICT`代替`CASCADE`来获得默认行为，它将阻止删除任何被其他对象依赖的对象。  

### 注意

​    根据SQL标准，在`DROP`命令中指定`RESTRICT`或`CASCADE`是被要求的。但没有哪个数据库系统真正强制了这个规则，但是不同的系统中两种默认行为都是可能的。   

   如果一个`DROP`命令列出了多个对象，只有在存在指定对象构成的组之外的依赖关系时才需要`CASCADE`。例如，如果发出命令`DROP TABLE tab1, tab2`且存在从`tab2`到`tab1`的外键引用，那么就不需要`CASCADE`即可成功执行。  

   对于用户定义的函数，PostgreSQL会追踪与函数外部可见性质相关的依赖性，例如它的参数和结果类型，但*不*追踪检查函数体才能知道的依赖性。例如，考虑这种情况：

```
CREATE TYPE rainbow AS ENUM ('red', 'orange', 'yellow',
                             'green', 'blue', 'purple');

CREATE TABLE my_colors (color rainbow, note text);

CREATE FUNCTION get_color_note (rainbow) RETURNS text AS
  'SELECT note FROM my_colors WHERE color = $1'
  LANGUAGE SQL;
```

   （SQL语言函数的解释见[第 37.5 节](http://www.postgres.cn/docs/13/xfunc-sql.html)）。PostgreSQL将会注意到`get_color_note`函数依赖于`rainbow`类型：删掉该类型会强制删除该函数，因为该函数的参数类型就无法定义了。但是PostgreSQL不会认为`get_color_note`依赖于`my_colors`表，因此即使该表被删除也不会删除这个函数。虽然这种方法有缺点，但是也有好处。如果该表丢失，这个函数在某种程度上仍然是有效的，但是执行它会导致错误。创建一个同名的新表将允许该函数重新有效。  

## 第 6 章 数据操纵

**目录**

- [6.1. 插入数据](http://www.postgres.cn/docs/13/dml-insert.html)
- [6.2. 更新数据](http://www.postgres.cn/docs/13/dml-update.html)
- [6.3. 删除数据](http://www.postgres.cn/docs/13/dml-delete.html)
- [6.4. 从修改的行中返回数据](http://www.postgres.cn/docs/13/dml-returning.html)

  前面的章节讨论了如何创建表和其他结构来保存你的数据。现在是时候给表填充数据了。本章涉及如何插入、更新和删除表数据。在接下来的一章将最终解释如何把你丢失已久的数据从数据库中抽取出来。 

## 6.1. 插入数据



   当一个表被创建后，它不包含数据。在数据库可以有点用之前要做的第一件事就是向里面插入数据。数据在概念上是以每次一行地方式被插入的。你当然可以每次插入多行，但是却没有办法一次插入少于一行的数据。即使你只知道几个列的值，那么你也必须创建一个完整的行。  

   要创建一个新行，使用[INSERT](http://www.postgres.cn/docs/13/sql-insert.html)命令。这条命令要求提供表的名字和其中列的值。例如，考虑[第 5 章](http://www.postgres.cn/docs/13/ddl.html)中的产品表：

```
CREATE TABLE products (
    product_no integer,
    name text,
    price numeric
);
```

   一个插入一行的命令将是：

```
INSERT INTO products VALUES (1, 'Cheese', 9.99);
```

   数据的值是按照这些列在表中出现的顺序列出的，并且用逗号分隔。通常，数据的值是文字（常量），但也允许使用标量表达式。  

   上面的语法的缺点是你必须知道表中列的顺序。要避免这个问题，你也可以显式地列出列。例如，下面的两条命令都有和上文那条 命令一样的效果：

```
INSERT INTO products (product_no, name, price) VALUES (1, 'Cheese', 9.99);
INSERT INTO products (name, price, product_no) VALUES ('Cheese', 9.99, 1);
```

   许多用户认为明确列出列的名字是个好习惯。  

   如果你没有获得所有列的值，那么你可以省略其中的一些。在这种情况下，这些列将被填充为它们的缺省值。例如：

```
INSERT INTO products (product_no, name) VALUES (1, 'Cheese');
INSERT INTO products VALUES (1, 'Cheese');
```

   第二种形式是PostgreSQL的一个扩展。它从使用给出的值从左开始填充列，有多少个给出的列值就填充多少个列，其他列的将使用缺省值。  

   为了保持清晰，你也可以显式地要求缺省值，用于单个的列或者用于整个行：

```
INSERT INTO products (product_no, name, price) VALUES (1, 'Cheese', DEFAULT);
INSERT INTO products DEFAULT VALUES;
```

  

   你可以在一个命令中插入多行：

```
INSERT INTO products (product_no, name, price) VALUES
    (1, 'Cheese', 9.99),
    (2, 'Bread', 1.99),
    (3, 'Milk', 2.99);
```

  

   也可以插入查询的结果（可能没有行、一行或多行）：

```
INSERT INTO products (product_no, name, price)
  SELECT product_no, name, price FROM new_products
    WHERE release_date = 'today';
```

   这提供了用于计算要插入的行的SQL查询机制（[第 7 章](http://www.postgres.cn/docs/13/queries.html)）的全部功能。  

### 提示

​    在一次性插入大量数据时，考虑使用[COPY](http://www.postgres.cn/docs/13/sql-copy.html)命令。它不如[INSERT](http://www.postgres.cn/docs/13/sql-insert.html)命令那么灵活，但是更高效。 参考[第 14.4 节](http://www.postgres.cn/docs/13/populate.html)获取更多有关批量装载性能的信息。   

## 6.2. 更新数据



   修改已经存储在数据库中的数据的行为叫做更新。你可以更新单个行，也可以更新表中所有的行，还可以更新其中的一部分行。 我们可以独立地更新每个列，而其他的列则不受影响。  

   要更新现有的行，使用[UPDATE](http://www.postgres.cn/docs/13/sql-update.html)命令。这需要提供三部分信息：   

1. 表的名字和要更新的列名
2. 列的新值
3. 要更新的是哪（些）行

  

   我们在[第 5 章](http://www.postgres.cn/docs/13/ddl.html)里说过，SQL  通常并不为行提供唯一标识符。因此我们无法总是直接指定需要更新哪一行。但是，我们可以通过指定一个被更新的行必须满足的条件。只有在表里面存在主键的时候（不管你声明它还是不声明它），我们才能可靠地通过选择一个匹配主键的条件来指定一个独立的行。图形化的数据库访问工具就靠这允许我们独立地更新某些行。  

   例如，这条命令把所有价格为5的产品的价格更新为10：

```
UPDATE products SET price = 10 WHERE price = 5;
```

​    这样做可能导致零行、一行或者更多行被更新。如果我们试图做一个不匹配任何行的更新，那也不算错误。  

   让我们仔细看看这个命令。首先是关键字`UPDATE`， 然后跟着表名字。和平常一样，表名字也可以是用模式限定的， 否则会从路径中查找它。然后是关键字`SET`， 后面跟着列名、一个等号以及新的列值。新的列值可以是任意标量表达式， 而不仅仅是常量。例如，如果你想把所有产品的价格提高 10%，你可以用：

```
UPDATE products SET price = price * 1.10;
```

   如你所见，用于新值的表达式也可以引用行中现有的值。我们还忽略了`WHERE`子句。如果我们忽略了这个子句， 那么就意味着表中的所有行都要被更新。如果出现了`WHERE`子句， 那么只有匹配它后面的条件的行被更新。请注意在`SET`子句中的等号是一个赋值， 而在`WHERE`子句中的等号是比较，不过这样并不会导致任何歧义。当然`WHERE`条件不一定非得是等值测试。许多其他操作符也都可以使用（参阅[第 9 章](http://www.postgres.cn/docs/13/functions.html)）。但是表达式必须得出一个布尔结果。  

   你还可以在一个`UPDATE`命令中更新更多的列， 方法是在`SET`子句中列出更多赋值。例如：

```
UPDATE mytable SET a = 5, b = 3, c = 1 WHERE a > 0;
```

## 6.3. 删除数据



​    到目前为止我们已经解释了如何向表中增加数据以及如何改变数据。剩下的是讨论如何删除不再需要的数据。和前面增加数据一样，你也只能从表中整行整行地删除数据。在前面的一节里我们解释了 SQL  不提供直接访问单个行的方法。因此，删除行只能是通过指定被删除行必须匹配的条件进行。如果你在表上有一个主键，那么你可以指定准确的行。但是你也可以删除匹配条件的一组行，或者你可以一次从表中删除所有的行。  

   可以使用[DELETE](http://www.postgres.cn/docs/13/sql-delete.html)命令删除行，它的语法和`UPDATE`命令非常类似。例如，要从产品表中删除所有价格为 10 的产品，使用：

```
DELETE FROM products WHERE price = 10;
```

  

   如果你只是写：

```
DELETE FROM products;
```

   那么表中所有行都会被删除！程序员一定要注意。  

## 6.4. 从修改的行中返回数据



   有时在修改行的操作过程中获取数据很有用。`INSERT`、   `UPDATE`和`DELETE`命令都有一个支持这个的可选的   `RETURNING`子句。使用`RETURNING`   可以避免执行额外的数据库查询来收集数据，并且在否则难以可靠地识别修改的行时尤其有用。  

   所允许的`RETURNING`子句的内容与`SELECT`命令的输出列表相同   （请参阅[第 7.3 节](http://www.postgres.cn/docs/13/queries-select-lists.html)）。它可以包含命令的目标表的列名，   或者包含使用这些列的值表达式。一个常见的简写是`RETURNING *`，   它按顺序选择目标表的所有列。  

   在`INSERT`中，可用于`RETURNING`的数据是插入的行。   这在琐碎的插入中并不是很有用，因为它只会重复客户端提供的数据。   但依赖于计算出的默认值时可以非常方便。例如，当使用   [`serial`](http://www.postgres.cn/docs/13/datatype-numeric.html#DATATYPE-SERIAL)列来提供唯一标识符时，   `RETURNING`可以返回分配给新行的ID：

```
CREATE TABLE users (firstname text, lastname text, id serial primary key);

INSERT INTO users (firstname, lastname) VALUES ('Joe', 'Cool') RETURNING id;
```

   `RETURNING`子句对于`INSERT ... SELECT`也非常有用。  

   在`UPDATE`中，可用于`RETURNING`的数据是被修改行的新内容。   例如：

```
UPDATE products SET price = price * 1.10
  WHERE price <= 99.99
  RETURNING name, price AS new_price;
```

  

   在`DELETE`中，可用于`RETURNING`的数据是删除行的内容。例如：

```
DELETE FROM products
  WHERE obsoletion_date = 'today'
  RETURNING *;
```

  

   如果目标表上有触发器([第 38 章](http://www.postgres.cn/docs/13/triggers.html))，可用于`RETURNING`   的数据是被触发器修改的行。因此，检查由触发器计算的列是   `RETURNING`的另一个常见用例。  

## 第 7 章 查询

**目录**

- [7.1. 概述](http://www.postgres.cn/docs/13/queries-overview.html)

- [7.2. 表表达式](http://www.postgres.cn/docs/13/queries-table-expressions.html)

  [7.2.1. `FROM`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-FROM)[7.2.2. `WHERE`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-WHERE)[7.2.3. `GROUP BY`和`HAVING`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-GROUP)[7.2.4. `GROUPING SETS`、`CUBE`和`ROLLUP`](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-GROUPING-SETS)[7.2.5. 窗口函数处理](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-WINDOW)

- [7.3. 选择列表](http://www.postgres.cn/docs/13/queries-select-lists.html)

  [7.3.1. 选择列表项](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-SELECT-LIST-ITEMS)[7.3.2. 列标签](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-COLUMN-LABELS)[7.3.3. `DISTINCT`](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-DISTINCT)

- [7.4. 组合查询](http://www.postgres.cn/docs/13/queries-union.html)

- [7.5. 行排序](http://www.postgres.cn/docs/13/queries-order.html)

- [7.6. `LIMIT`和`OFFSET`](http://www.postgres.cn/docs/13/queries-limit.html)

- [7.7. `VALUES`列表](http://www.postgres.cn/docs/13/queries-values.html)

- [7.8. `WITH`查询（公共表表达式）](http://www.postgres.cn/docs/13/queries-with.html)

  [7.8.1. `WITH`中的`SELECT`](http://www.postgres.cn/docs/13/queries-with.html#QUERIES-WITH-SELECT)[7.8.2. `WITH`中的数据修改语句](http://www.postgres.cn/docs/13/queries-with.html#QUERIES-WITH-MODIFYING)



  前面的章节解释了如何创建表、如何用数据填充它们 以及如何操纵那些数据。现在我们终于可以讨论如何从数据库中检索数据了。 

## 7.1. 概述

   从数据库中检索数据的过程或命令叫做*查询*。在 SQL 里[SELECT](http://www.postgres.cn/docs/13/sql-select.html)命令用于指定查询。 `SELECT`命令的一般语法是

```
[WITH with_queries] SELECT select_list FROM table_expression [sort_specification]
```

   下面几个小节描述选择列表、表表达式和排序声明的细节。`WITH`查询等高级特性将在最后讨论。  

   一个简单类型的查询的形式：

```
SELECT * FROM table1;
```

  假设有一个表叫做`table1`，这条命令将`table1`中检索所有行和所有用户定义的列（检索的方法取决于客户端应用。例如，psql程序将在屏幕上显示一个 ASCII 形式的表格， 而客户端库将提供函数来从检索结果中抽取单个值）。 选择列表声明`*`意味着所有表表达式提供的列。 一个选择列表也可以选择可用列的一个子集或者在使用它们之前对列进行计算。例如，如果`table1`有叫做`a`、`b`和`c`的列（可能还有其他），那么你可以用下面的查询：

```
SELECT a, b + c FROM table1;
```

  （假设`b`和`c`都是数字数据类型）。 参阅[第 7.3 节](http://www.postgres.cn/docs/13/queries-select-lists.html)获取更多细节。 

  `FROM table1`是一种非常简单的表表达式：它只读取了一个表。通常，表表达式可以是基本表、连接和子查询组成的复杂结构。 但你也可以省略整个表表达式而把`SELECT`命令当做一个计算器：

```
SELECT 3 * 4;
```

  如果选择列表里的表达式返回变化的结果，那么这就更有用了。例如，你可以用这种方法调用函数：

```
SELECT random();
```

## 7.2. 表表达式

- [7.2.1. `FROM`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-FROM)
- [7.2.2. `WHERE`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-WHERE)
- [7.2.3. `GROUP BY`和`HAVING`子句](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-GROUP)
- [7.2.4. `GROUPING SETS`、`CUBE`和`ROLLUP`](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-GROUPING-SETS)
- [7.2.5. 窗口函数处理](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-WINDOW)



   *表表达式*计算一个表。该表表达式包含一个`FROM`子句，该子句后面可以根据需要选用`WHERE`、`GROUP BY`和`HAVING`子句。最简单的表表达式只是引用磁盘上的一个表，一个所谓的基本表，但是我们可以用更复杂的表表达式以多种方法修改或组合基本表。  

   表表达式里可选的`WHERE`、`GROUP BY`和`HAVING`子句指定一系列对源自`FROM`子句的表的转换操作。所有这些转换最后生成一个虚拟表，它提供行传递给选择列表计算查询的输出行。  

### 7.2.1. `FROM`子句

​    [`FROM` 子句](http://www.postgres.cn/docs/13/sql-select.html#SQL-FROM)从一个用逗号分隔的表引用列表中的一个或更多个其它表中生成一个表。

```
FROM table_reference [, table_reference [, ...]]
```

​    表引用可以是一个表名字（可能有模式限定）或者是一个生成的表， 例如子查询、一个`JOIN`结构或者这些东西的复杂组合。如果在`FROM`子句中引用了多于一个表， 那么它们被交叉连接（即构造它们的行的笛卡尔积，见下文）。`FROM`列表的结果是一个中间的虚拟表，该表可以进行由`WHERE`、`GROUP BY`和`HAVING`子句指定的转换，并最后生成全局的表表达式结果。   



​    如果一个表引用是一个简单的表名字并且它是表继承层次中的父表，那么该表引用将产生该表和它的后代表中的行，除非你在该表名字前面放上`ONLY`关键字。但是，这种引用只会产生出现在该命名表中的列 — 在子表中增加的列都会被忽略。   

​    除了在表名前写`ONLY`，你可以在表名后面写上`*`来显式地指定要包括所有的后代表。没有实际的理由再继续使用这种语法，因为搜索后代表现在总是默认行为。不过，为了保持与旧版本的兼容性，仍然支持这种语法。   

#### 7.2.1.1. 连接表



​     一个连接表是根据特定的连接类型的规则从两个其它表（真实表或生成表）中派生的表。目前支持内连接、外连接和交叉连接。一个连接表的一般语法是：

```
T1 join_type T2 [ join_condition ]
```

​     所有类型的连接都可以被链在一起或者嵌套：*`T1`*和*`T2`*都可以是连接表。在`JOIN`子句周围可以使用圆括号来控制连接顺序。如果不使用圆括号，`JOIN`子句会从左至右嵌套。    

**连接类型**

- 交叉连接                    

  `*`T1`* CROSS JOIN *`T2`* `        对来自于*`T1`*和*`T2`*的行的每一种可能的组合（即笛卡尔积），连接表将包含这样一行：它由所有*`T1`*里面的列后面跟着所有*`T2`*里面的列构成。如果两个表分别有 N 和 M 行，连接表将有 N * M 行。               `FROM *`T1`* CROSS JOIN *`T2`*`等效于`FROM *`T1`* INNER JOIN *`T2`* ON TRUE`（见下文）。它也等效于`FROM *`T1`*,*`T2`*`。        注意         当多于两个表出现时，后一种等效并不严格成立，因为`JOIN`比逗号绑得更紧。例如`FROM *`T1`* CROSS JOIN *`T2`* INNER JOIN *`T3`* ON *`condition`*`和`FROM *`T1`*,*`T2`* INNER JOIN *`T3`* ON *`condition`*`并不完全相同，因为第一种情况中的*`condition`*可以引用*`T1`*，但在第二种情况中却不行。               

- 条件连接                    

  `*`T1`* { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN *`T2`* ON *`boolean_expression`* *`T1`* { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN *`T2`* USING ( *`join column list`* ) *`T1`* NATURAL { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN *`T2`* `        `INNER`和`OUTER`对所有连接形式都是可选的。`INNER`是缺省；`LEFT`、`RIGHT`和`FULL`指示一个外连接。               *连接条件*在`ON`或`USING`子句中指定， 或者用关键字`NATURAL`隐含地指定。连接条件决定来自两个源表中的哪些行是“匹配”的，这些我们将在后文详细解释。               可能的条件连接类型是：        `INNER JOIN`           对于 T1 的每一行 R1，生成的连接表都有一行对应 T2 中的每一个满足和 R1 的连接条件的行。          `LEFT OUTER JOIN`                                       首先，执行一次内连接。然后，为 T1 中每一个无法在连接条件上匹配 T2 里任何一行的行返回一个连接行，该连接行中 T2 的列用空值补齐。因此，生成的连接表里为来自 T1 的每一行都至少包含一行。          `RIGHT OUTER JOIN`                                       首先，执行一次内连接。然后，为 T2 中每一个无法在连接条件上匹配 T1 里任何一行的行返回一个连接行，该连接行中 T1 的列用空值补齐。因此，生成的连接表里为来自 T2 的每一行都至少包含一行。          `FULL OUTER JOIN`           首先，执行一次内连接。然后，为 T1 中每一个无法在连接条件上匹配 T2 里任何一行的行返回一个连接行，该连接行中 T2  的列用空值补齐。同样，为 T2 中每一个无法在连接条件上匹配 T1 里任何一行的行返回一个连接行，该连接行中 T1 的列用空值补齐。                        `ON`子句是最常见的连接条件的形式：它接收一个和`WHERE`子句里用的一样的布尔值表达式。 如果两个分别来自*`T1`*和*`T2`*的行在`ON`表达式上运算的结果为真，那么它们就算是匹配的行。               `USING`是个缩写符号，它允许你利用特殊的情况：连接的两端都具有相同的连接列名。它接受共享列名的一个逗号分隔列表，并且为其中每一个共享列构造一个包含等值比较的连接条件。例如用`USING (a, b)`连接*`T1`*和*`T2`*会产生连接条件`ON *`T1`*.a = *`T2`*.a AND *`T1`*.b = *`T2`*.b`。               更进一步，`JOIN USING`的输出会废除冗余列：不需要把匹配上的列都打印出来，因为它们必须具有相等的值。不过`JOIN ON`会先产生来自*`T1`*的所有列，后面跟上所有来自*`T2`*的列；而`JOIN USING`会先为列出的每一个列对产生一个输出列，然后先跟上来自*`T1`*的剩余列，最后跟上来自*`T2`*的剩余列。                               最后，`NATURAL`是`USING`的缩写形式：它形成一个`USING`列表， 该列表由那些在两个表里都出现了的列名组成。和`USING`一样，这些列只在输出表里出现一次。如果不存在公共列，`NATURAL JOIN`的行为将和`JOIN ... ON TRUE`一样产生交叉集连接。       注意         `USING`对于连接关系中的列改变是相当安全的，因为只有被列出的列会被组合成连接条件。`NATURAL`的风险更大，因为如果其中一个关系的模式改变会导致出现一个新的匹配列名，就会导致连接将新列也组合成连接条件。        

​     为了解释这些问题，假设我们有一个表`t1`：

```
 num | name
-----+------
   1 | a
   2 | b
   3 | c
```

​     和`t2`：

```
 num | value
-----+-------
   1 | xxx
   3 | yyy
   5 | zzz
```

​     然后我们用不同的连接方式可以获得各种结果：

```
=> SELECT * FROM t1 CROSS JOIN t2;
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   1 | a    |   3 | yyy
   1 | a    |   5 | zzz
   2 | b    |   1 | xxx
   2 | b    |   3 | yyy
   2 | b    |   5 | zzz
   3 | c    |   1 | xxx
   3 | c    |   3 | yyy
   3 | c    |   5 | zzz
(9 rows)

=> SELECT * FROM t1 INNER JOIN t2 ON t1.num = t2.num;
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   3 | c    |   3 | yyy
(2 rows)

=> SELECT * FROM t1 INNER JOIN t2 USING (num);
 num | name | value
-----+------+-------
   1 | a    | xxx
   3 | c    | yyy
(2 rows)

=> SELECT * FROM t1 NATURAL INNER JOIN t2;
 num | name | value
-----+------+-------
   1 | a    | xxx
   3 | c    | yyy
(2 rows)

=> SELECT * FROM t1 LEFT JOIN t2 ON t1.num = t2.num;
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |   3 | yyy
(3 rows)

=> SELECT * FROM t1 LEFT JOIN t2 USING (num);
 num | name | value
-----+------+-------
   1 | a    | xxx
   2 | b    |
   3 | c    | yyy
(3 rows)

=> SELECT * FROM t1 RIGHT JOIN t2 ON t1.num = t2.num;
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   3 | c    |   3 | yyy
     |      |   5 | zzz
(3 rows)

=> SELECT * FROM t1 FULL JOIN t2 ON t1.num = t2.num;
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |   3 | yyy
     |      |   5 | zzz
(4 rows)
```

​    

​     用`ON`指定的连接条件也可以包含与连接不直接相关的条件。这种功能可能对某些查询很有用，但是需要我们仔细想清楚。例如：

```
=> SELECT * FROM t1 LEFT JOIN t2 ON t1.num = t2.num AND t2.value = 'xxx';
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |     |
(3 rows)
```

​     注意把限制放在`WHERE`子句中会产生不同的结果：

```
=> SELECT * FROM t1 LEFT JOIN t2 ON t1.num = t2.num WHERE t2.value = 'xxx';
 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
(1 row)
```

​     这是因为放在`ON`子句中的一个约束在连接*之前*被处理，而放在`WHERE`子句中的一个约束是在连接*之后*被处理。这对内连接没有关系，但是对于外连接会带来麻烦。    

#### 7.2.1.2. 表和列别名



​     你可以给一个表或复杂的表引用指定一个临时的名字，用于剩下的查询中引用那些派生的表。这被叫做*表别名*。    

​     要创建一个表别名，我们可以写：

```
FROM table_reference AS alias
```

​     或者

```
FROM table_reference alias
```

​     `AS`关键字是可选的。*`别名`*可以是任意标识符。    

​     表别名的典型应用是给长表名赋予比较短的标识符， 好让连接子句更易读。例如：

```
SELECT * FROM some_very_long_table_name s JOIN another_fairly_long_name a ON s.id = a.num;
```

​    

​     到这里，别名成为当前查询的表引用的新名称 — 我们不再能够用该表最初的名字引用它了。因此，下面的用法是不合法的：

```
SELECT * FROM my_table AS m WHERE my_table.a > 5;    -- 错误
```

​    

​     表别名主要用于简化符号，但是当把一个表连接到它自身时必须使用别名，例如：

```
SELECT * FROM people AS mother JOIN people AS child ON mother.id = child.mother_id;
```

​     此外，如果一个表引用是一个子查询，则必须要使用一个别名（见[第 7.2.1.3 节](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-SUBQUERIES)）。    

​     圆括弧用于解决歧义。在下面的例子中，第一个语句将把别名`b`赋给`my_table`的第二个实例，但是第二个语句把别名赋给连接的结果：

```
SELECT * FROM my_table AS a CROSS JOIN my_table AS b ...
SELECT * FROM (my_table AS a CROSS JOIN my_table) AS b ...
```

​    

​     另外一种给表指定别名的形式是给表的列赋予临时名字，就像给表本身指定别名一样：

```
FROM table_reference [AS] alias ( column1 [, column2 [, ...]] )
```

​     如果指定的列别名比表里实际的列少，那么剩下的列就没有被重命名。这种语法对于自连接或子查询特别有用。    

​     如果用这些形式中的任何一种给一个`JOIN`子句的输出附加了一个别名， 那么该别名就在`JOIN`的作用下隐去了其原始的名字。例如：

```
SELECT a.* FROM my_table AS a JOIN your_table AS b ON ...
```

​     是合法 SQL，但是：

```
SELECT a.* FROM (my_table AS a JOIN your_table AS b ON ...) AS c
```

​     是不合法的：表别名`a`在别名`c`外面是看不到的。    

#### 7.2.1.3. 子查询



​     子查询指定了一个派生表，它必须被包围在圆括弧里并且*必须*被赋予一个表别名（参阅[第 7.2.1.2 节](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-TABLE-ALIASES)）。例如：

```
FROM (SELECT * FROM table1) AS alias_name
```

​    

​     这个例子等效于`FROM table1 AS alias_name`。更有趣的情况是在子查询里面有分组或聚集的时候， 子查询不能被简化为一个简单的连接。    

​     一个子查询也可以是一个`VALUES`列表：

```
FROM (VALUES ('anne', 'smith'), ('bob', 'jones'), ('joe', 'blow'))
     AS names(first, last)
```

​     再次的，这里要求一个表别名。为`VALUES`列表中的列分配别名是可选的，但是选择这样做是一个好习惯。更多信息可参见[第 7.7 节](http://www.postgres.cn/docs/13/queries-values.html)。    

#### 7.2.1.4. 表函数



​     表函数是那些生成一个行集合的函数，这个集合可以是由基本数据类型（标量类型）组成， 也可以是由复合数据类型（表行）组成。它们的用法类似一个表、视图或者在查询的`FROM`子句里的子查询。表函数返回的列可以像一个表列、视图或者子查询那样被包含在`SELECT`、`JOIN`或`WHERE`子句里。    

​     也可以使用`ROWS FROM`语法将平行列返回的结果组合成表函数；     这种情况下结果行的数量是最大一个函数结果的数量，较小的结果会用空值来填充。    

```
function_call [WITH ORDINALITY] [[AS] table_alias [(column_alias [, ... ])]]
ROWS FROM( function_call [, ... ] ) [WITH ORDINALITY] [[AS] table_alias [(column_alias [, ... ])]]
```

​     如果指定了`WITH ORDINALITY`子句，一个额外的     `bigint`类型的列将会被增加到函数的结果列中。这个列对     函数结果集的行进行编号，编号从 1 开始（这是对 SQL 标准语法     `UNNEST ... WITH ORDINALITY`的一般化）。默认情     况下，序数列被称为`ordinality`，但也可以通过使用一个     `AS`子句给它分配一个不同的列名。    

​     调用特殊的表函数`UNNEST`可以使用任意数量的数组参数，     它会返回对应的列数，就好像在每一个参数上单独调用     `UNNEST`（[第 9.18 节](http://www.postgres.cn/docs/13/functions-array.html)）并且使用     `ROWS FROM`结构把它们组合起来。    

```
UNNEST( array_expression [, ... ] ) [WITH ORDINALITY] [[AS] table_alias [(column_alias [, ... ])]]
```

​     如果没有指定*`table_alias`*，该函数名将被用作     表名。在`ROWS FROM()`结构的情况中，会使用第一个函数名。    

​     如果没有提供列的别名，那么对于一个返回基数据类型的函数，列名也与该函数     名相同。对于一个返回组合类型的函数，结果列会从该类型的属性得到名称。    

​     例子：

```
CREATE TABLE foo (fooid int, foosubid int, fooname text);

CREATE FUNCTION getfoo(int) RETURNS SETOF foo AS $$
    SELECT * FROM foo WHERE fooid = $1;
$$ LANGUAGE SQL;

SELECT * FROM getfoo(1) AS t1;

SELECT * FROM foo
    WHERE foosubid IN (
                        SELECT foosubid
                        FROM getfoo(foo.fooid) z
                        WHERE z.fooid = foo.fooid
                      );

CREATE VIEW vw_getfoo AS SELECT * FROM getfoo(1);

SELECT * FROM vw_getfoo;
```

​    

​     有时侯，定义一个能够根据它们被调用方式返回不同列集合的表函数是很有用的。为了支持这些，表函数可以被声明为返回伪类型`record`。 如果在查询里使用这样的函数，那么我们必须在查询中指定所预期的行结构，这样系统才知道如何分析和规划该查询。这种语法是这样的：     

```
function_call [AS] alias (column_definition [, ... ])
function_call AS [alias] (column_definition [, ... ])
ROWS FROM( ... function_call AS (column_definition [, ... ]) [, ... ] )
```

​     在没有使用`ROWS FROM()`语法时，     *`column_definition`*列表会取代无法附着在     `FROM`项上的列别名列表，列定义中的名称就起到列别名的作用。     在使用`ROWS FROM()`语法时，     可以为每一个成员函数单独附着一个     *`column_definition`*列表；或者在只有一个成员     函数并且没有`WITH ORDINALITY`子句的情况下，可以在     `ROWS FROM()`后面写一个     *`column_definition`*列表来取代一个列别名列表。    

​     考虑下面的例子：

```
SELECT *
    FROM dblink('dbname=mydb', 'SELECT proname, prosrc FROM pg_proc')
      AS t1(proname name, prosrc text)
    WHERE proname LIKE 'bytea%';
```

​     [dblink](http://www.postgres.cn/docs/13/contrib-dblink-function.html)函数（[dblink](http://www.postgres.cn/docs/13/dblink.html)模块的一部分）执行一个远程的查询。它被声明为返回`record`，因为它可能会被用于任何类型的查询。 实际的列集必须在调用它的查询中指定，这样分析器才知道类似`*`这样的东西应该扩展成什么样子。    

#### 7.2.1.5. `LATERAL`子查询



​     可以在出现于`FROM`中的子查询前放置关键词`LATERAL`。这允许它们引用前面的`FROM`项提供的列（如果没有`LATERAL`，每一个子查询将被独立计算，并且因此不能被其他`FROM`项交叉引用）。    

​     出现在`FROM`中的表函数的前面也可以被放上关键词`LATERAL`，但对于函数该关键词是可选的，在任何情况下函数的参数都可以包含对前面的`FROM`项提供的列的引用。    

​     一个`LATERAL`项可以出现在`FROM`列表顶层，或者出现在一个`JOIN`树中。在后一种情况下，如果它出现在`JOIN`的右部，那么它也可以引用 在`JOIN`左部的任何项。    

​     如果一个`FROM`项包含`LATERAL`交叉引用，计算过程如下：对于提供交叉引用列的`FROM`项的每一行，或者多个提供这些列的多个`FROM`项的行集合，`LATERAL`项将被使用该行或者行集中的列值进行计算。得到的结果行将和它们被计算出来的行进行正常的连接。对于来自这些列的源表的每一行或行集，该过程将重复。    

​     `LATERAL`的一个简单例子：

```
SELECT * FROM foo, LATERAL (SELECT * FROM bar WHERE bar.id = foo.bar_id) ss;
```

​     这不是非常有用，因为它和一种更简单的形式得到的结果完全一样：

```
SELECT * FROM foo, bar WHERE bar.id = foo.bar_id;
```

​     在必须要使用交叉引用列来计算那些即将要被连接的行时，`LATERAL`是最有用的。一种常用的应用是为一个返回集合的函数提供一个参数值。例如，假设`vertices(polygon)`返回一个多边形的顶点集合，我们可以这样标识存储在一个表中的多边形中靠近的顶点：

```
SELECT p1.id, p2.id, v1, v2
FROM polygons p1, polygons p2,
     LATERAL vertices(p1.poly) v1,
     LATERAL vertices(p2.poly) v2
WHERE (v1 <-> v2) < 10 AND p1.id != p2.id;
```

​     这个查询也可以被写成：

```
SELECT p1.id, p2.id, v1, v2
FROM polygons p1 CROSS JOIN LATERAL vertices(p1.poly) v1,
     polygons p2 CROSS JOIN LATERAL vertices(p2.poly) v2
WHERE (v1 <-> v2) < 10 AND p1.id != p2.id;
```

​     或者写成其他几种等价的公式（正如以上提到的，`LATERAL`关键词在这个例子中并不是必不可少的，但是我们在这里使用它是为了使表述更清晰）。    

​     有时候也会很特别地把`LEFT JOIN`放在一个`LATERAL`子查询的前面，这样即使`LATERAL`子查询对源行不产生行，源行也会出现在结果中。例如，如果`get_product_names()`返回一个制造商制造的产品的名字，但是某些制造商在我们的表中目前没有制造产品，我们可以找出哪些制造商是这样：

```
SELECT m.name
FROM manufacturers m LEFT JOIN LATERAL get_product_names(m.id) pname ON true
WHERE pname IS NULL;
```

​    

### 7.2.2. `WHERE`子句



​    [`WHERE` 子句](http://www.postgres.cn/docs/13/sql-select.html#SQL-WHERE)的语法是

```
WHERE search_condition
```

​    这里的*`search_condition`*是任意返回一个`boolean`类型值的值表达式（参阅[第 4.2 节](http://www.postgres.cn/docs/13/sql-expressions.html)）。   

​    在完成对`FROM`子句的处理之后，生成的虚拟表的每一行都会对根据搜索条件进行检查。 如果该条件的结果是真，那么该行被保留在输出表中；否则（也就是说，如果结果是假或空）就把它抛弃。搜索条件通常至少要引用一些在`FROM`子句里生成的列；虽然这不是必须的，但如果不引用这些列，那么`WHERE`子句就没什么用了。   

### 注意

​     内连接的连接条件既可以写在`WHERE`子句也可以写在`JOIN`子句里。例如，这些表表达式是等效的：

```
FROM a, b WHERE a.id = b.id AND b.val > 5
```

​     和：

```
FROM a INNER JOIN b ON (a.id = b.id) WHERE b.val > 5
```

​     或者可能还有：

```
FROM a NATURAL JOIN b WHERE b.val > 5
```

​     你想用哪个只是一个风格问题。`FROM`子句里的`JOIN`语法可能不那么容易移植到其它SQL数据库管理系统中。 对于外部连接而言没有选择：它们必须在`FROM`子句中完成。 外部连接的`ON`或`USING`子句*不*等于`WHERE`条件，因为它导致最终结果中行的增加（对那些不匹配的输入行）和减少。    

​    这里是一些`WHERE`子句的例子：

```
SELECT ... FROM fdt WHERE c1 > 5

SELECT ... FROM fdt WHERE c1 IN (1, 2, 3)

SELECT ... FROM fdt WHERE c1 IN (SELECT c1 FROM t2)

SELECT ... FROM fdt WHERE c1 IN (SELECT c3 FROM t2 WHERE c2 = fdt.c1 + 10)

SELECT ... FROM fdt WHERE c1 BETWEEN (SELECT c3 FROM t2 WHERE c2 = fdt.c1 + 10) AND 100

SELECT ... FROM fdt WHERE EXISTS (SELECT c1 FROM t2 WHERE c2 > fdt.c1)
```

​    在上面的例子里，`fdt`是从FROM子句中派生的表。 那些不符合`WHERE`子句的搜索条件的行会被从`fdt`中删除。请注意我们把标量子查询当做一个值表达式来用。 和任何其它查询一样，子查询里可以使用复杂的表表达式。同时还请注意`fdt`在子查询中也被引用。只有在`c1`也是作为子查询输入表的生成表的列时，才必须把`c1`限定成`fdt.c1`。但限定列名字可以增加语句的清晰度，即使有时候不是必须的。这个例子展示了一个外层查询的列名范围如何扩展到它的内层查询。   

### 7.2.3. `GROUP BY`和`HAVING`子句



​    在通过了`WHERE`过滤器之后，生成的输入表可以使用`GROUP BY`子句进行分组，然后用`HAVING`子句删除一些分组行。   

```
SELECT select_list
    FROM ...
    [WHERE ...]
    GROUP BY grouping_column_reference [, grouping_column_reference]...
```

​    [`GROUP BY` 子句](http://www.postgres.cn/docs/13/sql-select.html#SQL-GROUPBY)被用来把表中在所列出的列上具有相同值的行分组在一起。 这些列的列出顺序并没有什么关系。其效果是把每组具有相同值的行组合为一个组行，它代表该组里的所有行。 这样就可以删除输出里的重复和/或计算应用于这些组的聚集。例如：

```
=> SELECT * FROM test1;
 x | y
---+---
 a | 3
 c | 2
 b | 5
 a | 1
(4 rows)

=> SELECT x FROM test1 GROUP BY x;
 x
---
 a
 b
 c
(3 rows)
```

   

​    在第二个查询里，我们不能写成`SELECT * FROM test1 GROUP BY x`， 因为列`y`里没有哪个值可以和每个组相关联起来。被分组的列可以在选择列表中引用是因为它们在每个组都有单一的值。   

​    通常，如果一个表被分了组，那么没有在`GROUP BY`中列出的列都不能被引用，除非在聚集表达式中被引用。 一个用聚集表达式的例子是：

```
=> SELECT x, sum(y) FROM test1 GROUP BY x;
 x | sum
---+-----
 a |   4
 b |   5
 c |   2
(3 rows)
```

​    这里的`sum`是一个聚集函数，它在整个组上计算出一个单一值。有关可用的聚集函数的更多信息可以在[第 9.20 节](http://www.postgres.cn/docs/13/functions-aggregate.html)。   

### 提示

​     没有聚集表达式的分组实际上计算了一个列中可区分值的集合。我们也可以用`DISTINCT`子句实现（参阅[第 7.3.3 节](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-DISTINCT)）。    

​    这里是另外一个例子：它计算每种产品的总销售额（而不是所有产品的总销售额）：

```
SELECT product_id, p.name, (sum(s.units) * p.price) AS sales
    FROM products p LEFT JOIN sales s USING (product_id)
    GROUP BY product_id, p.name, p.price;
```

​    在这个例子里，列`product_id`、`p.name`和`p.price`必须在`GROUP BY`子句里， 因为它们都在查询的选择列表里被引用到（但见下文）。列`s.units`不必在`GROUP BY`列表里，因为它只是在一个聚集表达式（`sum(...)`）里使用，它代表一组产品的销售额。对于每种产品，这个查询都返回一个该产品的所有销售额的总和行。   



​    如果产品表被建立起来，例如`product_id`是主键，那么在上面的例子中用`product_id`来分组就够了，因为名称和价格都是*函数依赖*于产品ID，并且关于为每个产品ID分组返回哪个名称和价格值就不会有歧义。   

​    在严格的 SQL 里，`GROUP BY`只能对源表的列进行分组，但PostgreSQL把这个扩展为也允许`GROUP BY`去根据选择列表中的列分组。也允许对值表达式进行分组，而不仅是简单的列名。   



​    如果一个表已经用`GROUP BY`子句分了组，然后你又只对其中的某些组感兴趣， 那么就可以用`HAVING`子句，它很象`WHERE`子句，用于从结果中删除一些组。其语法是：

```
SELECT select_list FROM ... [WHERE ...] GROUP BY ... HAVING boolean_expression
```

​    在`HAVING`子句中的表达式可以引用分组的表达式和未分组的表达式（后者必须涉及一个聚集函数）。   

​    例子：

```
=> SELECT x, sum(y) FROM test1 GROUP BY x HAVING sum(y) > 3;
 x | sum
---+-----
 a |   4
 b |   5
(2 rows)

=> SELECT x, sum(y) FROM test1 GROUP BY x HAVING x < 'c';
 x | sum
---+-----
 a |   4
 b |   5
(2 rows)
```

   

​    再次，一个更现实的例子：

```
SELECT product_id, p.name, (sum(s.units) * (p.price - p.cost)) AS profit
    FROM products p LEFT JOIN sales s USING (product_id)
    WHERE s.date > CURRENT_DATE - INTERVAL '4 weeks'
    GROUP BY product_id, p.name, p.price, p.cost
    HAVING sum(p.price * s.units) > 5000;
```

​    在上面的例子里，`WHERE`子句用那些非分组的列选择数据行（表达式只是对那些最近四周发生的销售为真）。 而`HAVING`子句限制输出为总销售收入超过 5000 的组。请注意聚集表达式不需要在查询中的所有地方都一样。   

​    如果一个查询包含聚集函数调用，但是没有`GROUP BY`子句，分组仍然会发生：结果是一个单一行（或者根本就没有行，如果该单一行被`HAVING`所消除）。它包含一个`HAVING`子句时也是这样，即使没有任何聚集函数调用或者`GROUP BY`子句。   

### 7.2.4. `GROUPING SETS`、`CUBE`和`ROLLUP`



​    使用*分组集*的概念可以实现比上述更加复杂的分组操作。由    `FROM`和`WHERE`子句选出的数据被按照每一个指定    的分组集单独分组，按照简单`GROUP BY`子句对每一个分组计算    聚集，然后返回结果。例如：

```
=> SELECT * FROM items_sold;
 brand | size | sales
-------+------+-------
 Foo   | L    |  10
 Foo   | M    |  20
 Bar   | M    |  15
 Bar   | L    |  5
(4 rows)

=> SELECT brand, size, sum(sales) FROM items_sold GROUP BY GROUPING SETS ((brand), (size), ());
 brand | size | sum
-------+------+-----
 Foo   |      |  30
 Bar   |      |  20
       | L    |  15
       | M    |  35
       |      |  50
(5 rows)
```

   

​    `GROUPING SETS`的每一个子列表可以指定一个或者多个列或者表达式，    它们将按照直接出现在`GROUP BY`子句中同样的方式被解释。一个空的    分组集表示所有的行都要被聚集到一个单一分组（即使没有输入行存在也会被输出）    中，这就像前面所说的没有`GROUP BY`子句的聚集函数的情况一样。   

​    对于分组列或表达式没有出现在其中的分组集的结果行，对分组列或表达式的引用会    被空值所替代。要区分一个特定的输出行来自于哪个分组，请见    [表 9.59](http://www.postgres.cn/docs/13/functions-aggregate.html#FUNCTIONS-GROUPING-TABLE)。   

​    PostgreSQL 中提供了一种简化方法来指定两种常用类型的分组集。下面形式的子句

```
ROLLUP ( e1, e2, e3, ... )
```

​    表示给定的表达式列表及其所有前缀（包括空列表），因此它等效于

```
GROUPING SETS (
    ( e1, e2, e3, ... ),
    ...
    ( e1, e2 ),
    ( e1 ),
    ( )
)
```

​    这通常被用来分析历史数据，例如按部门、区和公司范围计算的总薪水。   

​    下面形式的子句

```
CUBE ( e1, e2, ... )
```

​    表示给定的列表及其可能的子集（即幂集）。因此

```
CUBE ( a, b, c )
```

​    等效于

```
GROUPING SETS (
    ( a, b, c ),
    ( a, b    ),
    ( a,    c ),
    ( a       ),
    (    b, c ),
    (    b    ),
    (       c ),
    (         )
)
```

   

​    `CUBE`或`ROLLUP`子句中的元素可以是表达式或者    圆括号中的元素子列表。在后一种情况中，对于生成分组集的目的来说，子列    表被当做单一单元来对待。例如：

```
CUBE ( (a, b), (c, d) )
```

​    等效于

```
GROUPING SETS (
    ( a, b, c, d ),
    ( a, b       ),
    (       c, d ),
    (            )
)
```

​    并且

```
ROLLUP ( a, (b, c), d )
```

​    等效于

```
GROUPING SETS (
    ( a, b, c, d ),
    ( a, b, c    ),
    ( a          ),
    (            )
)
```

   

​    `CUBE`和`ROLLUP`可以被直接用在    `GROUP BY`子句中，也可以被嵌套在一个    `GROUPING SETS`子句中。如果一个    `GROUPING SETS`子句被嵌套在另一个同类子句中，    效果和把内层子句的所有元素直接写在外层子句中一样。   

​    如果在一个`GROUP BY`子句中指定了多个分组项，那么最终的    分组集列表是这些项的叉积。例如：

```
GROUP BY a, CUBE (b, c), GROUPING SETS ((d), (e))
```

​    等效于

```
GROUP BY GROUPING SETS (
    (a, b, c, d), (a, b, c, e),
    (a, b, d),    (a, b, e),
    (a, c, d),    (a, c, e),
    (a, d),       (a, e)
)
```

   

### 注意

​    在表达式中，结构`(a, b)`通常被识别为一个    a [行构造器](http://www.postgres.cn/docs/13/sql-expressions.html#SQL-SYNTAX-ROW-CONSTRUCTORS)。在    `GROUP BY`子句中，这不会在表达式的顶层应用，并且    `(a, b)`会按照上面所说的被解析为一个表达式的列表。如果出于    某种原因你在分组表达式中*需要*一个行构造器，请使用    `ROW(a, b)`。   

### 7.2.5. 窗口函数处理



​    如果查询包含任何窗口函数（见[第 3.5 节](http://www.postgres.cn/docs/13/tutorial-window.html)、[第 9.21 节](http://www.postgres.cn/docs/13/functions-window.html)和[第 4.2.8 节](http://www.postgres.cn/docs/13/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)），这些函数将在任何分组、聚集和`HAVING`过滤被执行之后被计算。也就是说如果查询使用了任何聚集、`GROUP BY`或`HAVING`，则窗口函数看到的行是分组行而不是来自于`FROM`/`WHERE`的原始表行。   

​    当多个窗口函数被使用，所有在窗口定义中有句法上等效的`PARTITION BY`和`ORDER BY`子句的窗口函数被保证在数据上的同一趟扫描中计算。因此它们将会看到相同的排序顺序，即使`ORDER BY`没有唯一地决定一个顺序。但是，对于具有不同`PARTITION BY`或`ORDER BY`定义的函数的计算没有这种保证（在这种情况中，在多个窗口函数计算之间通常要求一个排序步骤，并且并不保证保留行的顺序，即使它的`ORDER BY`把这些行视为等效的）。   

​    目前，窗口函数总是要求排序好的数据，并且这样查询的输出总是被根据窗口函数的`PARTITION BY`/`ORDER BY`子句的一个或者另一个排序。但是，我们不推荐依赖于此。如果你希望确保结果以特定的方式排序，请显式使用顶层的`ORDER BY`子句。   

## 7.3. 选择列表

- [7.3.1. 选择列表项](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-SELECT-LIST-ITEMS)
- [7.3.2. 列标签](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-COLUMN-LABELS)
- [7.3.3. `DISTINCT`](http://www.postgres.cn/docs/13/queries-select-lists.html#QUERIES-DISTINCT)



   如前面的小节说明的那样， 在`SELECT`命令里的表表达式构造了一个中间的虚拟表， 方法可能有组合表、视图、消除行、分组等等。这个表最后被*选择列表*传递下去处理。选择列表判断中间表的哪个*列*是实际输出。  

### 7.3.1. 选择列表项



​    最简单的选择列表类型是`*`，它发出表表达式生成的所有列。否则，一个选择列表是一个逗号分隔的值表达式的列表（和在[第 4.2 节](http://www.postgres.cn/docs/13/sql-expressions.html)里定义的一样）。 例如，它可能是一个列名的列表：

```
SELECT a, b, c FROM ...
```

​     列名字`a`、`b`和`c`要么是在`FROM`子句里引用的表中列的实际名字，要么是像[第 7.2.1.2 节](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-TABLE-ALIASES)里解释的那样的别名。在选择列表里可用的名字空间和在`WHERE`子句里的一样， 除非你使用了分组，这时候它和`HAVING`子句一样。   

​    如果超过一个表有同样的列名，那么你还必须给出表名字，如：

```
SELECT tbl1.a, tbl2.a, tbl1.b FROM ...
```

​    在使用多个表时，要求一个特定表的所有列也是有用的：

```
SELECT tbl1.*, tbl2.a FROM ...
```

​    更多有关*`table_name`*`.*`记号的内容请参考[第 8.16.5 节](http://www.postgres.cn/docs/13/rowtypes.html#ROWTYPES-USAGE)。   

​    如果将任意值表达式用于选择列表，那么它在概念上向返回的表中增加了一个新的虚拟列。 值表达式为结果的每一行进行一次计算，对任何列引用替换行的值。 不过选择列表中的这个表达式并非一定要引用来自`FROM`子句中表表达式里面的列，例如它也可以是任意常量算术表达式。   

### 7.3.2. 列标签



​    选择列表中的项可以被赋予名字，用于进一步的处理。 例如为了在一个`ORDER BY`子句中使用或者为了客户端应用显示。例如：

```
SELECT a AS value, b + c AS sum FROM ...
```

   

​    如果没有使用`AS`指定输出列名，那么系统会分配一个缺省的列名。对于简单的列引用， 它是被引用列的名字。对于函数调用，它是函数的名字。对于复杂表达式，系统会生成一个通用的名字。   

​    只有在新列无法匹配任何PostgreSQL关键词（见[附录 C](http://www.postgres.cn/docs/13/sql-keywords-appendix.html)）时，`AS`关键词是可选的。为了避免一个关键字的意外匹配，你可以使用双引号来修饰列名。例如，`VALUE`是一个关键字，所以下面的语句不会工作：

```
SELECT a value, b + c AS sum FROM ...
```

​    但是这个可以：

```
SELECT a "value", b + c AS sum FROM ...
```

​    为了防止未来可能的关键词增加，我们推荐总是写`AS`或者用双引号修饰输出列名。   

### 注意

​     输出列的命名和在`FROM`子句里的命名是不一样的 （参阅[第 7.2.1.2 节](http://www.postgres.cn/docs/13/queries-table-expressions.html#QUERIES-TABLE-ALIASES)）。 它实际上允许你对同一个列命名两次，但是在选择列表中分配的名字是要传递下去的名字。    

### 7.3.3. `DISTINCT`



​    在处理完选择列表之后，结果表可以可选的删除重复行。我们可以直接在`SELECT`后面写上`DISTINCT`关键字来指定：

```
SELECT DISTINCT select_list ...
```

​    （如果不用`DISTINCT`你可以用`ALL`关键词来指定获得的所有行的缺省行为）。   



​    显然，如果两行里至少有一个列有不同的值，那么我们认为它是可区分的。空值在这种比较中被认为是相同的。   

​    另外，我们还可以用任意表达式来判断什么行可以被认为是可区分的：

```
SELECT DISTINCT ON (expression [, expression ...]) select_list ...
```

​    这里*`expression`*是任意值表达式，它为所有行计算。如果一个行集合里所有表达式的值是一样的， 那么我们认为它们是重复的并且因此只有第一行保留在输出中。请注意这里的一个集合的“第一行”是不可预料的， 除非你在足够多的列上对该查询排了序，保证到达`DISTINCT`过滤器的行的顺序是唯一的（`DISTINCT ON`处理是发生在`ORDER BY`排序后面的）。   

​    `DISTINCT ON`子句不是 SQL 标准的一部分， 有时候有人认为它是一个糟糕的风格，因为它的结果是不可判定的。 如果有选择的使用`GROUP BY`和在`FROM`中的子查询，那么我们可以避免使用这个构造， 但是通常它是更方便的候选方法。   

## 7.4. 组合查询



   两个查询的结果可以用集合操作并、交、差进行组合。语法是

```
query1 UNION [ALL] query2
query1 INTERSECT [ALL] query2
query1 EXCEPT [ALL] query2
```

   *`query1`*和*`query2`*都是可以使用以上所有特性的查询。集合操作也可以嵌套和级连，例如

```
query1 UNION query2 UNION query3
```

   实际执行的是：

```
(query1 UNION query2) UNION query3
```

  

   `UNION`有效地把*`query2`*的结果附加到*`query1`*的结果上（不过我们不能保证这就是这些行实际被返回的顺序）。此外，它将删除结果中所有重复的行， 就象`DISTINCT`做的那样，除非你使用了`UNION ALL`。  

   `INTERSECT`返回那些同时存在于*`query1`*和*`query2`*的结果中的行，除非声明了`INTERSECT ALL`， 否则所有重复行都被消除。  

   `EXCEPT`返回所有在*`query1`*的结果中但是不在*`query2`*的结果中的行（有时侯这叫做两个查询的*差*）。同样的，除非声明了`EXCEPT ALL`，否则所有重复行都被消除。  

   为了计算两个查询的并、交、差，这两个查询必须是“并操作兼容的”，也就意味着它们都返回同样数量的列， 并且对应的列有兼容的数据类型，如[第 10.5 节](http://www.postgres.cn/docs/13/typeconv-union-case.html)中描述的那样。  

## 7.5. 行排序



   在一个查询生成一个输出表之后（在处理完选择列表之后），还可以选择性地对它进行排序。如果没有选择排序，那么行将以未指定的顺序返回。  这时候的实际顺序将取决于扫描和连接计划类型以及行在磁盘上的顺序，但是肯定不能依赖这些东西。一种特定的顺序只能在显式地选择了排序步骤之后才能被保证。  

   `ORDER BY`子句指定了排序顺序：

```
SELECT select_list
    FROM table_expression
    ORDER BY sort_expression1 [ASC | DESC] [NULLS { FIRST | LAST }]
             [, sort_expression2 [ASC | DESC] [NULLS { FIRST | LAST }] ...]
```

   排序表达式可以是任何在查询的选择列表中合法的表达式。一个例子是：

```
SELECT a, b FROM table1 ORDER BY a + b, c;
```

   当多于一个表达式被指定，后面的值将被用于排序那些在前面值上相等的行。每一个表达式后可以选择性地放置一个`ASC`或`DESC`关键词来设置排序方向为升序或降序。`ASC`顺序是默认值。升序会把较小的值放在前面，而“较小”则由`<`操作符定义。相似地，降序则由`>`操作符定义。    [[5\]](http://www.postgres.cn/docs/13/queries-order.html#ftn.id-1.5.6.9.5.10)  

   `NULLS FIRST`和`NULLS LAST`选项将可以被用来决定在排序顺序中，空值是出现在非空值之前或者出现在非空值之后。默认情况下，排序时空值被认为比任何非空值都要大，即`NULLS FIRST`是`DESC`顺序的默认值，而不是`NULLS LAST`的默认值。  

   注意顺序选项是对每一个排序列独立考虑的。例如`ORDER BY x, y DESC`表示`ORDER BY x ASC, y DESC`，而和`ORDER BY x DESC, y DESC`不同。  

   一个*`sort_expression`*也可以是列标签或者一个输出列的编号，如：

```
SELECT a + b AS sum, c FROM table1 ORDER BY sum;
SELECT a, max(b) FROM table1 GROUP BY a ORDER BY 1;
```

   两者都根据第一个输出列排序。注意一个输出列的名字必须孤立，即它不能被用在一个表达式中 — 例如，这是*不*正确的：

```
SELECT a + b AS sum, c FROM table1 ORDER BY sum + c;          -- 错误
```

   该限制是为了减少混淆。如果一个`ORDER BY`项是一个单一名字并且匹配一个输出列名或者一个表表达式的列，仍然会出现混淆。在这种情况中输出列将被使用。只有在你使用`AS`来重命名一个输出列来匹配某些其他表列的名字时，这才会导致混淆。  

   `ORDER BY`可以被应用于`UNION`、`INTERSECT`或`EXCEPT`组合的结果，但是在这种情况中它只被允许根据输出列名或编号排序，而不能根据表达式排序。  



------

[[5\] ](http://www.postgres.cn/docs/13/queries-order.html#id-1.5.6.9.5.10)      事实上，PostgreSQL为表达式的数据类型使用*默认B-tree操作符类*来决定`ASC`和`DESC`的排序顺序。照惯例，数据类型将被建立，这样`<`和`>`操作符负责这个排序顺序，但是一个用户定义的数据类型的设计者可以选择做些不同的设置。     

## 7.6. `LIMIT`和`OFFSET`



   `LIMIT`和`OFFSET`允许你只检索查询剩余部分产生的行的一部分：

```
SELECT select_list
    FROM table_expression
    [ ORDER BY ... ]
    [ LIMIT { number | ALL } ] [ OFFSET number ]
```

  

   如果给出了一个限制计数，那么会返回数量不超过该限制的行（但可能更少些，因为查询本身可能生成的行数就比较少）。`LIMIT ALL`的效果和省略`LIMIT`子句一样，就像是`LIMIT`带有 NULL 参数一样。  

   `OFFSET`说明在开始返回行之前忽略多少行。`OFFSET 0`的效果和省略`OFFSET`子句是一样的，并且`LIMIT NULL`的效果和省略`LIMIT`子句一样，就像是`OFFSET`带有 NULL 参数一样。  

   如果`OFFSET`和`LIMIT`都出现了， 那么在返回`LIMIT`个行之前要先忽略`OFFSET`行。  

   如果使用`LIMIT`，那么用一个`ORDER BY`子句把结果行约束成一个唯一的顺序是很重要的。否则你就会拿到一个不可预料的该查询的行的子集。你要的可能是第十到第二十行，但以什么顺序的第十到第二十？除非你指定了`ORDER BY`，否则顺序是不知道的。  

   查询优化器在生成查询计划时会考虑`LIMIT`，因此如果你给定`LIMIT`和`OFFSET`，那么你很可能收到不同的规划（产生不同的行顺序）。因此，使用不同的`LIMIT`/`OFFSET`值选择查询结果的不同子集*将生成不一致的结果*，除非你用`ORDER BY`强制一个可预测的顺序。这并非bug， 这是一个很自然的结果，因为 SQL 没有许诺把查询的结果按照任何特定的顺序发出，除非用了`ORDER BY`来约束顺序。  

   被`OFFSET`子句忽略的行仍然需要在服务器内部计算；因此，一个很大的`OFFSET`的效率可能还是不够高。  

## 7.7. `VALUES`列表



   `VALUES`提供了一种生成“常量表”的方法，它可以被使用在一个查询中而不需要实际在磁盘上创建一个表。语法是：

```
VALUES ( expression [, ...] ) [, ...]
```

   每一个被圆括号包围的表达式列表生成表中的一行。列表都必须具有相同数据的元素（即表中列的数目），并且在每个列表中对应的项必须具有可兼容的数据类型。分配给结果的每一列的实际数据类型使用和`UNION`相同的规则确定（参见[第 10.5 节](http://www.postgres.cn/docs/13/typeconv-union-case.html)）。  

   一个例子：

```
VALUES (1, 'one'), (2, 'two'), (3, 'three');
```

   将会返回一个有两列三行的表。它实际上等效于：

```
SELECT 1 AS column1, 'one' AS column2
UNION ALL
SELECT 2, 'two'
UNION ALL
SELECT 3, 'three';
```

   在默认情况下，PostgreSQL将`column1`、`column2`等名字分配给一个`VALUES`表的列。这些列名不是由SQL标准指定的，并且不同的数据库系统的做法也不同，因此通常最好使用表别名列表来重写这些默认的名字，像这样：

```
=> SELECT * FROM (VALUES (1, 'one'), (2, 'two'), (3, 'three')) AS t (num,letter);
 num | letter
-----+--------
   1 | one
   2 | two
   3 | three
(3 rows)
```

  

   在句法上，后面跟随着表达式列表的`VALUES`列表被视为和

```
SELECT select_list FROM table_expression
```

   一样，并且可以出现在`SELECT`能出现的任何地方。例如，你可以把它用作`UNION`的一部分，或者附加一个*`sort_specification`*（`ORDER BY`、`LIMIT`和/或`OFFSET`）给它。`VALUES`最常见的用途是作为一个`INSERT`命令的数据源，以及作为一个子查询。  

   更多信息请见[VALUES](http://www.postgres.cn/docs/13/sql-values.html)。  

## 7.8. `WITH`查询（公共表表达式）

- [7.8.1. `WITH`中的`SELECT`](http://www.postgres.cn/docs/13/queries-with.html#QUERIES-WITH-SELECT)
- [7.8.2. `WITH`中的数据修改语句](http://www.postgres.cn/docs/13/queries-with.html#QUERIES-WITH-MODIFYING)



   `WITH`提供了一种方式来书写在一个大型查询中使用的辅助语句。这些语句通常被称为公共表表达式或CTE，它们可以被看成是定义只在一个查询中存在的临时表。在`WITH`子句中的每一个辅助语句可以是一个`SELECT`、`INSERT`、`UPDATE`或`DELETE`，并且`WITH`子句本身也可以被附加到一个主语句，主语句也可以是`SELECT`、`INSERT`、`UPDATE`或`DELETE`。  

### 7.8.1. `WITH`中的`SELECT`

   `WITH`中`SELECT`的基本价值是将复杂的查询分解称为简单的部分。一个例子：

```
WITH regional_sales AS (
    SELECT region, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region
), top_regions AS (
    SELECT region
    FROM regional_sales
    WHERE total_sales > (SELECT SUM(total_sales)/10 FROM regional_sales)
)
SELECT region,
       product,
       SUM(quantity) AS product_units,
       SUM(amount) AS product_sales
FROM orders
WHERE region IN (SELECT region FROM top_regions)
GROUP BY region, product;
```

   它只显示在高销售区域每种产品的销售总额。`WITH`子句定义了两个辅助语句`regional_sales`和`top_regions`，其中`regional_sales`的输出用在`top_regions`中而`top_regions`的输出用在主`SELECT`查询。这个例子可以不用`WITH`来书写，但是我们必须要用两层嵌套的子`SELECT`。使用这种方法要更简单些。  

​      可选的`RECURSIVE`修饰符将`WITH`从单纯的句法便利变成了一种在标准SQL中不能完成的特性。通过使用`RECURSIVE`，一个`WITH`查询可以引用它自己的输出。一个非常简单的例子是计算从1到100的整数合的查询：

```
WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t;
```

   一个递归`WITH`查询的通常形式总是一个*非递归项*，然后是`UNION`（或者`UNION ALL`），再然后是一个*递归项*，其中只有递归项能够包含对于查询自身输出的引用。这样一个查询可以被这样执行：  

**递归查询求值**

1. ​     计算非递归项。对`UNION`（但不对`UNION ALL`），抛弃重复行。把所有剩余的行包括在递归查询的结果中，并且也把它们放在一个临时的*工作表*中。    
2. ​     只要工作表不为空，重复下列步骤：    
   1. ​       计算递归项，用当前工作表的内容替换递归自引用。对`UNION`（不是`UNION ALL`），抛弃重复行以及那些与之前结果行重复的行。将剩下的所有行包括在递归查询的结果中，并且也把它们放在一个临时的*中间表*中。      
   2. ​       用中间表的内容替换工作表的内容，然后清空中间表。      

### 注意

​    严格来说，这个处理是迭代而不是递归，但是`RECURSIVE`是SQL标准委员会选择的术语。   

   在上面的例子中，工作表在每一步只有一个行，并且它在连续的步骤中取值从1到100。在第100步，由于`WHERE`子句导致没有输出，因此查询终止。  

   递归查询通常用于处理层次或者树状结构的数据。一个有用的例子是这个用于找到一个产品的直接或间接部件的查询，只要给定一个显示了直接包含关系的表：

```
WITH RECURSIVE included_parts(sub_part, part, quantity) AS (
    SELECT sub_part, part, quantity FROM parts WHERE part = 'our_product'
  UNION ALL
    SELECT p.sub_part, p.part, p.quantity
    FROM included_parts pr, parts p
    WHERE p.part = pr.sub_part
)
SELECT sub_part, SUM(quantity) as total_quantity
FROM included_parts
GROUP BY sub_part
```

  

   在使用递归查询时，确保查询的递归部分最终将不返回元组非常重要，否则查询将会无限循环。在某些时候，使用`UNION`替代`UNION ALL`可以通过抛弃与之前输出行重复的行来达到这个目的。不过，经常有循环不涉及到完全重复的输出行：它可能只需要检查一个或几个域来看相同点之前是否达到过。处理这种情况的标准方法是计算一个已经访问过值的数组。例如，考虑下面这个使用`link`域搜索表`graph`的查询：

```
WITH RECURSIVE search_graph(id, link, data, depth) AS (
    SELECT g.id, g.link, g.data, 1
    FROM graph g
  UNION ALL
    SELECT g.id, g.link, g.data, sg.depth + 1
    FROM graph g, search_graph sg
    WHERE g.id = sg.link
)
SELECT * FROM search_graph;
```

   如果`link`关系包含环，这个查询将会循环。因为我们要求一个“depth”输出，仅仅将`UNION ALL` 改为`UNION`不会消除循环。反过来在我们顺着一个特定链接路径搜索时，我们需要识别我们是否再次到达了一个相同的行。我们可以项这个有循环倾向的查询增加两个列`path`和`cycle`：

```
WITH RECURSIVE search_graph(id, link, data, depth, path, cycle) AS (
    SELECT g.id, g.link, g.data, 1,
      ARRAY[g.id],
      false
    FROM graph g
  UNION ALL
    SELECT g.id, g.link, g.data, sg.depth + 1,
      path || g.id,
      g.id = ANY(path)
    FROM graph g, search_graph sg
    WHERE g.id = sg.link AND NOT cycle
)
SELECT * FROM search_graph;
```

   除了阻止环，数组值对于它们自己的工作显示到达任何特定行的“path”也有用。  

   在通常情况下如果需要检查多于一个域来识别一个环，请用行数组。例如，如果我们需要比较域`f1`和`f2`：

```
WITH RECURSIVE search_graph(id, link, data, depth, path, cycle) AS (
    SELECT g.id, g.link, g.data, 1,
      ARRAY[ROW(g.f1, g.f2)],
      false
    FROM graph g
  UNION ALL
    SELECT g.id, g.link, g.data, sg.depth + 1,
      path || ROW(g.f1, g.f2),
      ROW(g.f1, g.f2) = ANY(path)
    FROM graph g, search_graph sg
    WHERE g.id = sg.link AND NOT cycle
)
SELECT * FROM search_graph;
```

  

### 提示

​    在通常情况下只有一个域需要被检查来识别一个环，可以省略`ROW()`语法。这允许使用一个简单的数组而不是一个组合类型数组，可以获得效率。   

### 提示

​    递归查询计算算法使用宽度优先搜索顺序产生它的输出。你可以通过让外部查询`ORDER BY`一个以这种方法构建的“path”，用来以深度优先搜索顺序显示结果。   

   当你不确定查询是否可能循环时，一个测试查询的有用技巧是在父查询中放一个`LIMIT`。例如，这个查询没有`LIMIT`时会永远循环：

```
WITH RECURSIVE t(n) AS (
    SELECT 1
  UNION ALL
    SELECT n+1 FROM t
)
SELECT n FROM t LIMIT 100;
```

   这会起作用，因为PostgreSQL的实现只计算`WITH`查询中被父查询实际取到的行。不推荐在生产中使用这个技巧，因为其他系统可能以不同方式工作。同样，如果你让外层查询排序递归查询的结果或者把它们连接成某种其他表，这个技巧将不会起作用，因为在这些情况下外层查询通常将尝试取得`WITH`查询的所有输出。  

   `WITH`查询的一个有用的特性是在每一次父查询的执行中它们通常只被计算一次，即使它们被父查询或兄弟`WITH`查询引用了超过一次。   因此，在多个地方需要的昂贵计算可以被放在一个`WITH`查询中来避免冗余工作。另一种可能的应用是阻止不希望的多个函数计算产生副作用。   但是，从另一方面来看，优化器不能将来自父查询的约束下推到乘法引用`WITH`查询，因为当他应该只影响一个时它可能会影响所有使用`WITH`查询的输出的使用。   乘法引用`WITH`查询通常将会被按照所写的方式计算，而不抑制父查询以后可能会抛弃的行（但是，如上所述，如果对查询的引用只请求有限数目的行，计算可能会提前停止）。  

   但是，如果 `WITH` 查询是非递归和边际效应无关的（就是说，它是一个`SELECT`包含没有可变函数），则它可以合并到父查询中，允许两个查询级别的联合优化。    默认情况下，这发生在如果父查询仅引用 `WITH`查询一次的时候，而不是它引用`WITH`查询多于一次时。    你可以超越控制这个决策，通过指定 `MATERIALIZED` 来强制分开计算 `WITH` 查询，或者通过指定 `NOT MATERIALIZED`来强制它被合并到父查询中。   后一种选择存在重复计算`WITH`查询的风险，但它仍然能提供净节省，如果`WITH`查询的每个使用只需要`WITH`查询的完整输出的一小部分。  

   这些规则的一个简单示例是

```
WITH w AS (
    SELECT * FROM big_table
)
SELECT * FROM w WHERE key = 123;
```

   这个 `WITH` 查询将被合并，生成相同的执行计划为

```
SELECT * FROM big_table WHERE key = 123;
```

   特别是，如果在`key`上有一个索引，它可能只用于获取具有 `key = 123`的行。 另一方面，在

```
WITH w AS (
    SELECT * FROM big_table
)
SELECT * FROM w AS w1 JOIN w AS w2 ON w1.key = w2.ref
WHERE w2.key = 123;
```

   `WITH`查询将被物化，生成一个`big_table`的临时拷贝，然后与其自身 — 联合，这样将不能从索引上获得任何好处。   如果写成下面的形式，这个查询将被执行得更有效率。

```
WITH w AS NOT MATERIALIZED (
    SELECT * FROM big_table
)
SELECT * FROM w AS w1 JOIN w AS w2 ON w1.key = w2.ref
WHERE w2.key = 123;
```

   所以父查询的限制可以直接应用于`big_table`的扫描。  

   一个`NOT MATERIALIZED` 可能不理想的例子为

```
WITH w AS (
    SELECT key, very_expensive_function(val) as f FROM some_table
)
SELECT * FROM w AS w1 JOIN w AS w2 ON w1.f = w2.f;
```

   在这里，`WITH`查询的物化确保`very_expensive_function`每个表行只计算一次，而不是两次。  

   以上的例子只展示了和`SELECT`一起使用的`WITH`，但是它可以被以相同的方式附加在`INSERT`、`UPDATE`或`DELETE`上。在每一种情况中，它实际上提供了可在主命令中引用的临时表。  

### 7.8.2. `WITH`中的数据修改语句

​    你可以在`WITH`中使用数据修改语句（`INSERT`、`UPDATE`或`DELETE`）。这允许你在同一个查询中执行多个而不同操作。一个例子：

```
WITH moved_rows AS (
    DELETE FROM products
    WHERE
        "date" >= '2010-10-01' AND
        "date" < '2010-11-01'
    RETURNING *
)
INSERT INTO products_log
SELECT * FROM moved_rows;
```

​    这个查询实际上从`products`把行移动到`products_log`。`WITH`中的`DELETE`删除来自`products`的指定行，以它的`RETURNING`子句返回它们的内容，并且接着主查询读该输出并将它插入到`products_log`。   

​    上述例子中好的一点是`WITH`子句被附加给`INSERT`，而没有附加给`INSERT`的子`SELECT`。这是必需的，因为数据修改语句只允许出现在附加给顶层语句的`WITH`子句中。不过，普通`WITH`可见性规则应用，这样才可能从子`SELECT`中引用到`WITH`语句的输出。   

​    正如上述例子所示，`WITH`中的数据修改语句通常具有`RETURNING`子句（见[第 6.4 节](http://www.postgres.cn/docs/13/dml-returning.html)）。它是`RETURNING`子句的输出，*不是*数据修改语句的目标表，它形成了剩余查询可以引用的临时表。如果一个`WITH`中的数据修改语句缺少一个`RETURNING`子句，则它形不成临时表并且不能在剩余的查询中被引用。但是这样一个语句将被执行。一个非特殊使用的例子：

```
WITH t AS (
    DELETE FROM foo
)
DELETE FROM bar;
```

​    这个例子将从表`foo`和`bar`中移除所有行。被报告给客户端的受影响行的数目可能只包括从`bar`中移除的行。   

​    数据修改语句中不允许递归自引用。在某些情况中可以采取引用一个递归`WITH`的输出来操作这个限制，例如：

```
WITH RECURSIVE included_parts(sub_part, part) AS (
    SELECT sub_part, part FROM parts WHERE part = 'our_product'
  UNION ALL
    SELECT p.sub_part, p.part
    FROM included_parts pr, parts p
    WHERE p.part = pr.sub_part
)
DELETE FROM parts
  WHERE part IN (SELECT part FROM included_parts);
```

​    这个查询将会移除一个产品的所有直接或间接子部件。   

​    `WITH`中的数据修改语句只被执行一次，并且总是能结束，而不管主查询是否读取它们所有（或者任何）的输出。注意这和`WITH`中`SELECT`的规则不同：正如前一小节所述，直到主查询要求`SELECT`的输出时，`SELECT`才会被执行。   

​    The sub-statements in `WITH`中的子语句被和每一个其他子语句以及主查询并发执行。因此在使用`WITH`中的数据修改语句时，指定更新的顺序实际是以不可预测的方式发生的。所有的语句都使用同一个*snapshot*执行（参见[第 13 章](http://www.postgres.cn/docs/13/mvcc.html)），因此它们不能“看见”在目标表上另一个执行的效果。这减轻了行更新的实际顺序的不可预见性的影响，并且意味着`RETURNING`数据是在不同`WITH`子语句和主查询之间传达改变的唯一方法。其例子

```
WITH t AS (
    UPDATE products SET price = price * 1.05
    RETURNING *
)
SELECT * FROM products;
```

​    外层`SELECT`可以返回在`UPDATE`动作之前的原始价格，而在

```
WITH t AS (
    UPDATE products SET price = price * 1.05
    RETURNING *
)
SELECT * FROM t;
```

​    外部`SELECT`将返回更新过的数据。   

​     在一个语句中试图两次更新同一行是不被支持的。只会发生一次修改，但是该办法不能很容易地（有时是不可能）可靠地预测哪一个会被执行。这也应用于删除一个已经在同一个语句中被更新过的行：只有更新被执行。因此你通常应该避免尝试在一个语句中尝试两次修改同一个行。尤其是防止书写可能影响被主语句或兄弟子语句修改的相同行。这样一个语句的效果将是不可预测的。   

​    当前，在`WITH`中一个数据修改语句中被用作目标的任何表不能有条件规则、`ALSO`规则或`INSTEAD`规则，这些规则会扩展成为多个语句。   



## 管理软件

pgAdmin

### psql

```bash
$ psql mydb
```

如果不提供数据库名字，它的缺省值就是用户账号名字。

```bash
psql (12.2)
Type "help" for help.

mydb=>
```

最后一行也可能是：

```bash
mydb=#
```

这个提示符意味着你是数据库超级用户。       

```sql
mydb=> SELECT version();
                                         version
------------------------------------------------------------------------------------------
 PostgreSQL 12.2 on x86_64-pc-linux-gnu, compiled by gcc (Debian 4.9.2-10) 4.9.2, 64-bit
(1 row)

mydb=> SELECT current_date;
    date
------------
 2016-01-07
(1 row)

mydb=> SELECT 2 + 2;
 ?column?
----------
        4
(1 row)
```

`psql`程序有一些不属于SQL命令的内部命令。它们以反斜线开头，“`\`”。

```bash
\copyright	#显示发行条款
\h			#显示SQL命令的说明
\?			#显示pgsql命令的说明
\g			#或者以分号(;)结尾以执行查询
\q			#退出
```

```
$ cd ..../tutorial
$ psql -s mydb

...


mydb=> \i basics.sql
```

​    `\i`命令从指定的文件中读取命令。`psql`的`-s`选项把你置于单步模式，它在向服务器发送每个语句之前暂停。 

​			 				





1. ​	4.3. PostgreSQL 用户


​				PostgreSQL 用户为以下类型： 		

- ​						`postgres` UNIX 系统用户 - 应该仅用于运行 **PostgreSQL** 服务器和客户端应用程序，如 `pg_dump`。不要将 `postgres` 系统用户用于 **PostgreSQL** 管理的任何交互式工作，如数据库创建和用户管理。 				
- ​						数据库超级用户 - 默认的 `postgres` **PostgreSQL** 超级用户与 `postgres` 系统用户无关。您可以在 `pg_hba.conf` 文件中限制 `postgres` 超级用户的权限，否则没有其他权限限制。您也可以创建其他数据库超级用户。 				
- ​						具有特定数据库访问权限的角色： 				
  - ​								数据库用户 - 默认具有登录权限 						
  - ​								一组用户 - 启用整个组的管理权限 						

​				角色可以拥有数据库对象（如表和函数），并且可以使用 SQL 命令将对象特权分配给其他角色。 		

​				标准数据库管理特权包括 `SELECT`、`INSERT`、`UPDATE`、`DELETE`、`TRUNCATE`、`REFERENCES`、`TRIGGER`、`CREATE`、`CONNECT`、`TEMPORARY`、`EXECUTE` 和 `USAGE`。 		

​				角色属性是特殊的特权，如 `LOGIN`、`SUPERUSER`、`CREATEDB` 和 `CREATEROLE`。 		

重要

​					红帽建议以不是超级用户的角色身份执行大部分任务。常见的做法是创建一个具有 `CREATEDB` 和 `CREATEROLE` 特权的角色，并将此角色用于所有数据库和角色的日常管理。 			

## 配置 PostgreSQL

​				在 **PostgreSQL** 数据库中，所有数据和配置文件都存储在一个名为database cluster的目录中。红帽建议将所有数据存储在默认的 `/var/lib/pgsql/data/` 目录中。 		

​				**PostgreSQL** 配置由以下文件组成： 		

- ​						`PostgreSQL.conf` - 用于设置数据库集群参数。 				
- ​						`PostgreSQL.auto.conf` - 包含与 `postgresql.conf` 类似的基本 **PostgreSQL** 设置。但是这个文件由服务器控制。它由 `ALTER SYSTEM` 查询来编辑，无法手动编辑。 				
- ​						`pg_ident.conf` - 用于将来自外部身份验证机制的用户身份映射到 **PostgreSQL** 用户身份。 				
- ​						`pg_hba.conf` - 用于为 **PostgreSQL** 数据库配置客户端身份验证。 				

​				要修改 **PostgreSQL** 配置，请使用以下流程： 		

**流程**

1. ​						编辑相应的配置文件，如 `/var/lib/pgsql/data/postgresql.conf`。 				

2. ​						重启 `postgresql` 服务，以使修改生效： 				

   ```none
   # systemctl restart postgresql.service
   ```

**例 4.1. 配置 PostgreSQL 数据库集群参数**

​					本例展示了 `/var/lib/pgsql/data/postgresql.conf` 文件中数据库集群参数的基本设置。 			

```none
# This is a comment
log_connections = yes
log_destination = 'syslog'
search_path = '"$user", public'
shared_buffers = 128MB
```

**例 4.2. 在 PostgreSQL 中设置客户端身份验证**

​					本例演示了如何在 `/var/lib/pgsql/data/pg_hba.conf` 文件中设置客户端身份验证。 			

```none
# TYPE    DATABASE       USER        ADDRESS              METHOD
local     all            all                              trust
host      postgres       all         192.168.93.0/24      ident
host      all            all         .example.com         scram-sha-256
```



​			

## 4.2. 安装 PostgreSQL

​				RHEL 9.0 提供 **PostgreSQL 13** 作为此 Application Stream 的初始版本，可作为 RPM 软件包轻松安装。在以后的 RHEL 9 次版本中，将提供额外的 **PostgreSQL** 版本作为带有较短生命周期的模块提供。 		

​				要安装 **PostgreSQL**，请使用以下流程： 		

**流程**

1. ​						安装 **PostgreSQL** 服务器软件包： 				

   

   ```none
   # dnf install postgresql-server
   ```

   ​						`postgres` 超级用户会自动创建。 				

2. ​						初始化数据库集群： 				

   

   ```none
   # postgresql-setup --initdb
   ```

   ​						红帽建议将数据存储在默认的 `/var/lib/pgsql/data` 目录中。 				

3. ​						启动 `postgresql` 服务： 				

   

   ```none
   # systemctl start postgresql.service
   ```

4. ​						启用 `postgresql` 服务，以便在引导时启动： 				

   

   ```none
   # systemctl enable postgresql.service
   ```

## 4.3. 创建 PostgreSQL 用户

​				PostgreSQL 用户为以下类型： 		

- ​						`postgres` UNIX 系统用户 - 应该仅用于运行 **PostgreSQL** 服务器和客户端应用程序，如 `pg_dump`。不要将 `postgres` 系统用户用于 **PostgreSQL** 管理的任何交互式工作，如数据库创建和用户管理。 				
- ​						数据库超级用户 - 默认的 `postgres` **PostgreSQL** 超级用户与 `postgres` 系统用户无关。您可以在 `pg_hba.conf` 文件中限制 `postgres` 超级用户的权限，否则没有其他权限限制。您也可以创建其他数据库超级用户。 				
- ​						具有特定数据库访问权限的角色： 				
  - ​								数据库用户 - 默认具有登录权限 						
  - ​								一组用户 - 启用整个组的管理权限 						

​				角色可以拥有数据库对象（如表和函数），并且可以使用 SQL 命令将对象特权分配给其他角色。 		

​				标准数据库管理特权包括 `SELECT`、`INSERT`、`UPDATE`、`DELETE`、`TRUNCATE`、`REFERENCES`、`TRIGGER`、`CREATE`、`CONNECT`、`TEMPORARY`、`EXECUTE` 和 `USAGE`。 		

​				角色属性是特殊的特权，如 `LOGIN`、`SUPERUSER`、`CREATEDB` 和 `CREATEROLE`。 		

重要

​					红帽建议以不是超级用户的角色身份执行大部分任务。常见的做法是创建一个具有 `CREATEDB` 和 `CREATEROLE` 特权的角色，并将此角色用于所有数据库和角色的日常管理。 			

**先决条件**

- ​						已安装 **PostgreSQL** 服务器。 				
- ​						初始化数据库集群。 				

**流程**

- ​						要创建用户，请为用户设置密码，并为该用户分配 `CREATEROLE` 和 `CREATEDB` 权限： 				

  

  ```none
  postgres=# CREATE USER mydbuser WITH PASSWORD 'mypasswd' CREATEROLE CREATEDB;
  ```

  ​						将 *mydbuser* 替换为用户名，*mypasswd* 替换为用户的密码。 				

**其他资源**

- ​						[PostgreSQL 数据库角色](https://www.postgresql.org/docs/current/user-manag.html) 				
- ​						[PostgreSQL 权限](https://www.postgresql.org/docs/current/ddl-priv.html) 				
- ​						[配置 PostgreSQL](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#configuring-postgresql_using-postgresql) 				

例 4.1. 初始化、创建和连接到 PostgreSQL 数据库

​					本例演示如何初始化 PostgreSQL 数据库，创建具有例行数据库管理特权的数据库用户，以及如何创建可通过具有管理特权的任何系统帐户访问的数据库帐户。 			

1. ​							安装 PosgreSQL 服务器： 					

   

   ```none
   # dnf install postgresql-server
   ```

2. ​							初始化数据库集群： 					

   

   ```none
   # postgresql-setup --initdb
   * Initializing database in '/var/lib/pgsql/data'
   * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
   ```

3. ​							将密码哈希算法设置为 `scram-sha-256`。 					

   1. ​									在 `/var/lib/pgsql/data/postgresql.conf` 文件中，更改以下行： 							

      

      ```none
      #password_encryption = md5              # md5 or scram-sha-256
      ```

      ​									改为： 							

      

      ```none
      password_encryption = scram-sha-256
      ```

   2. ​									在 `/var/lib/pgsql/data/pg_hba.conf` 文件中，更改 IPv4 本地连接的以下行： 							

      

      ```none
      host    all             all             127.0.0.1/32            ident
      ```

      ​									改为： 							

      

      ```none
      host    all             all             127.0.0.1/32            scram-sha-256
      ```

4. ​							启动 postgresql 服务： 					

   

   ```none
   # systemctl start postgresql.service
   ```

5. ​							以名为 `postgres` 的系统用户登录： 					

   

   ```none
   # su - postgres
   ```

6. ​							启动 **PostgreSQL** 互动终端： 					

   

   ```none
   $ psql
   psql (13.7)
   Type "help" for help.
   
   postgres=#
   ```

7. ​							可选：获取有关当前数据库连接的信息： 					

   

   ```none
   postgres=# \conninfo
   You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
   ```

8. ​							创建名为 `mydbuser` 的用户，为 `mydbuser` 设置密码，并为 `mydbuser` 分配 `CREATEROLE` 和 `CREATEDB` 权限： 					

   

   ```none
   postgres=# CREATE USER mydbuser WITH PASSWORD 'mypasswd' CREATEROLE CREATEDB;
   CREATE ROLE
   ```

   ​							`mydbuser` 用户现在可以执行日常数据库管理操作：创建数据库并管理用户索引。 					

9. ​							使用 `\q` meta 命令从互动终端注销： 					

   

   ```none
   postgres=# \q
   ```

10. ​							注销 `postgres` 用户会话： 					

    

    ```none
    $ logout
    ```

11. ​							以 `mydbuser` 用户身份登录 **PostgreSQL** 终端，指定主机名并连接到默认的 `postgres` 数据库，该数据库在初始化过程中创建： 					

    

    ```none
    # psql -U mydbuser -h 127.0.0.1 -d postgres
    Password for user mydbuser:
    Type the password.
    psql (13.7)
    Type "help" for help.
    
    postgres=>
    ```

12. ​							创建名为 `mydatabase` 的数据库： 					

    

    ```none
    postgres=> CREATE DATABASE mydatabase;
    CREATE DATABASE
    postgres=>
    ```

13. ​							从会话注销： 					

    

    ```none
    postgres=# \q
    ```

14. ​							以 `mydbuser` 用户身份连接到 mydatabase： 					

    

    ```none
    # psql -U mydbuser -h 127.0.0.1 -d mydatabase
    Password for user mydbuser:
    psql (13.7)
    Type "help" for help.
    mydatabase=>
    ```

15. ​							可选：获取有关当前数据库连接的信息： 					

    

    ```none
    mydatabase=> \conninfo
    You are connected to database "mydatabase" as user "mydbuser" on host "127.0.0.1" at port "5432".
    ```

## 4.4. 配置 PostgreSQL

​				在 **PostgreSQL** 数据库中，所有数据和配置文件都存储在一个名为database cluster的目录中。红帽建议将所有数据（包括配置文件）存储在默认的 `/var/lib/pgsql/data/` 目录中。 		

​				**PostgreSQL** 配置由以下文件组成： 		

- ​						`PostgreSQL.conf` - 用于设置数据库集群参数。 				
- ​						`PostgreSQL.auto.conf` - 包含与 `postgresql.conf` 类似的基本 **PostgreSQL** 设置。但是这个文件由服务器控制。它由 `ALTER SYSTEM` 查询来编辑，无法手动编辑。 				
- ​						`pg_ident.conf` - 用于将来自外部身份验证机制的用户身份映射到 **PostgreSQL** 用户身份。 				
- ​						`pg_hba.conf` - 用于为 **PostgreSQL** 数据库配置客户端身份验证。 				

​				要修改 **PostgreSQL** 配置，请使用以下流程： 		

**流程**

1. ​						编辑相应的配置文件，如 `/var/lib/pgsql/data/postgresql.conf`。 				

2. ​						重启 `postgresql` 服务，以使修改生效： 				

   

   ```none
   # systemctl restart postgresql.service
   ```

例 4.2. 配置 PostgreSQL 数据库集群参数

​					本例展示了 `/var/lib/pgsql/data/postgresql.conf` 文件中数据库集群参数的基本设置。 			



```none
# This is a comment
log_connections = yes
log_destination = 'syslog'
search_path = '"$user", public'
shared_buffers = 128MB
password_encryption = scram-sha-256
```

例 4.3. 在 PostgreSQL 中设置客户端身份验证

​					本例演示了如何在 `/var/lib/pgsql/data/pg_hba.conf` 文件中设置客户端身份验证。 			



```none
# TYPE    DATABASE       USER        ADDRESS              METHOD
local     all            all                              trust
host      postgres       all         192.168.93.0/24      ident
host      all            all         .example.com         scram-sha-256
```

## 4.5. 在 PostgreSQL 服务器中配置 TLS 加密

​				默认情况下，**PostgreSQL** 使用未加密的连接。如需更多安全连接，您可以在 **PostgreSQL** 服务器中启用传输层安全(TLS)支持，并将客户端配置为建立加密连接。 		

**先决条件**

- ​						已安装 **PostgreSQL** 服务器。 				
- ​						初始化数据库集群。 				

**流程**

1. ​						安装 OpenSSL 库： 				

   

   ```none
   # dnf install openssl
   ```

2. ​						生成 TLS 证书和密钥： 				

   

   ```none
   # openssl req -new -x509 -days 365 -nodes -text -out server.crt \
     -keyout server.key -subj "/CN=dbhost.yourdomain.com"
   ```

   ​						将 *dbhost.yourdomain.com* 替换为您的数据库主机和域名。 				

3. ​						将签名的证书和私钥复制到数据库服务器的所需位置： 				

   

   ```none
   # cp server.{key,crt} /var/lib/pgsql/data/.
   ```

4. ​						将签名证书的所有者和组所有权改为 `postgres` 用户： 				

   

   ```none
   # chown postgres:postgres /var/lib/pgsql/data/server.{key,crt}
   ```

5. ​						限制私钥的权限，使其只可由所有者读取： 				

   

   ```none
   # chmod 0400 /var/lib/pgsql/data/server.key
   ```

6. ​						通过在 `/var/lib/pgsql/data/postgresql.conf` 文件中更改以下行，将密码哈希算法设置为 `scram-sha-256` ： 				

   

   ```none
   #password_encryption = md5              # md5 or scram-sha-256
   ```

   ​						改为： 				

   

   ```none
   password_encryption = scram-sha-256
   ```

7. ​						通过在 `/var/lib/pgsql/data/postgresql.conf` 文件中更改以下行，将 PostgreSQL 配置为使用 SSL/TLS： 				

   

   ```none
   #ssl = off
   ```

   ​						改为： 				

   

   ```none
   ssl=on
   ```

8. ​						通过更改 `/var/lib/pgsql/data/pg_hba.conf` 文件中的 IPv4 本地连接，将所有数据库的访问限制为只使用 TLS 的客户端的连接： 				

   

   ```none
   host		all		all		127.0.0.1/32		ident
   ```

   ​						改为： 				

   

   ```none
   hostssl 	all		all		127.0.0.1/32		scram-sha-256
   ```

   ​						另外，您可以通过添加以下新行来限制单个数据库和用户的访问： 				

   

   ```none
   hostssl	mydatabase	mydbuser	127.0.0.1/32		scram-sha-256
   ```

   ​						将 *mydatabase* 替换为数据库名称，并将 *mydbuser* 替换为用户名。 				

9. ​						通过重启 `postgresql` 服务来有效地进行更改： 				

   

   ```none
   # systemctl restart postgresql.service
   ```

**验证**

- ​						手动验证连接是否已加密： 				

  1. ​								以 *mydbuser* 用户身份连接 **PostgreSQL** 数据库，指定主机名和数据库名称： 						

     

     ```none
     $ psql -U mydbuser -h 127.0.0.1 -d mydatabase
     Password for user mydbuser:
     ```

     ​								将 *mydatabase* 替换为数据库名称，并将 *mydbuser* 替换为用户名。 						

  2. ​								获取有关当前数据库连接的信息： 						

     

     ```none
     mydbuser=> \conninfo
     You are connected to database "mydatabase" as user "mydbuser" on host "127.0.0.1" at port "5432".
     SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
     ```

- ​						您可以编写一个简单的应用程序，验证与 **PostgreSQL** 的连接是否已加密。本例演示了使用 C 编写的那些使用 `libpq` 客户端库（由 `libpq-devel` 软件包提供）的应用程序： 				

  

  ```none
  #include <stdio.h>
  #include <stdlib.h>
  #include <libpq-fe.h>
  
  int main(int argc, char* argv[])
  {
  //Create connection
  PGconn* connection = PQconnectdb("hostaddr=127.0.0.1 password=mypassword port=5432 dbname=mydatabase user=mydbuser");
  
  if (PQstatus(connection) ==CONNECTION_BAD)
      {
      printf("Connection error\n");
      PQfinish(connection);
      return -1; //Execution of the program will stop here
      }
      printf("Connection ok\n");
      //Verify TLS
      if (PQsslInUse(connection)){
       printf("TLS in use\n");
       printf("%s\n", PQsslAttribute(connection,"protocol"));
      }
      //End connection
      PQfinish(connection);
      printf("Disconnected\n");
      return 0;
  }
  ```

  ​						将 *mypassword* 替换为密码，将 *mydatabase* 替换为数据库名称，并将 *mydbuser* 替换为用户名。 				

  注意

  ​							您必须使用 `-lpq` 选项为编译加载 `pq` 库。例如，使用 GCC 编译器编译应用程序： 					

  

  ```none
  $ gcc source_file.c -lpq -o myapplication
  ```

  ​							其中 *source_file.c* 包含上面的示例代码，*myapplication* 是应用程序的名称，用于验证安全的 **PostgreSQL** 连接。 					

例 4.4. 使用 TLS 加密初始化、创建和连接到 PostgreSQL 数据库

​					本例演示如何初始化 PostgreSQL 数据库，创建数据库用户和数据库，以及如何使用安全连接连接到数据库。 			

1. ​							安装 PosgreSQL 服务器： 					

   

   ```none
   # dnf install postgresql-server
   ```

2. ​							初始化数据库集群： 					

   

   ```none
   # postgresql-setup --initdb
   * Initializing database in '/var/lib/pgsql/data'
   * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
   ```

3. ​							安装 OpenSSL 库： 					

   

   ```none
   # dnf install openssl
   ```

4. ​							生成 TLS 证书和密钥： 					

   

   ```none
   # openssl req -new -x509 -days 365 -nodes -text -out server.crt \
     -keyout server.key -subj "/CN=dbhost.yourdomain.com"
   ```

   ​							将 *dbhost.yourdomain.com* 替换为您的数据库主机和域名。 					

5. ​							将签名的证书和私钥复制到数据库服务器的所需位置： 					

   

   ```none
   # cp server.{key,crt} /var/lib/pgsql/data/.
   ```

6. ​							将签名证书的所有者和组所有权改为 `postgres` 用户： 					

   

   ```none
   # chown postgres:postgres /var/lib/pgsql/data/server.{key,crt}
   ```

7. ​							限制私钥的权限，使其只可由所有者读取： 					

   

   ```none
   # chmod 0400 /var/lib/pgsql/data/server.key
   ```

8. ​							将密码哈希算法设置为 `scram-sha-256`。在 `/var/lib/pgsql/data/postgresql.conf` 文件中，更改以下行： 					

   

   ```none
   #password_encryption = md5              # md5 or scram-sha-256
   ```

   ​							改为： 					

   

   ```none
   password_encryption = scram-sha-256
   ```

9. ​							将 PostgreSQL 配置为使用 SSL/TLS。在 `/var/lib/pgsql/data/postgresql.conf` 文件中，更改以下行： 					

   

   ```none
   #ssl = off
   ```

   ​							改为： 					

   

   ```none
   ssl=on
   ```

10. ​							启动 `postgresql` 服务： 					

    

    ```none
    # systemctl start postgresql.service
    ```

11. ​							以名为 `postgres` 的系统用户登录： 					

    

    ```none
    # su - postgres
    ```

12. ​							以 `postgres` 用户身份启动 **PostgreSQL** 互动终端： 					

    

    ```none
    $ psql -U postgres
    psql (13.7)
    Type "help" for help.
    
    postgres=#
    ```

13. ​							创建名为 `mydbuser` 的用户，再为 `mydbuser` 设置一个密码： 					

    

    ```none
    postgres=# CREATE USER mydbuser WITH PASSWORD 'mypasswd';
    CREATE ROLE
    postgres=#
    ```

14. ​							创建名为 `mydatabase` 的数据库： 					

    

    ```none
    postgres=# CREATE DATABASE mydatabase;
    CREATE DATABASE
    postgres=#
    ```

15. ​							为 `mydbuser` 用户授予所有权限： 					

    

    ```none
    postgres=# GRANT ALL PRIVILEGES ON DATABASE mydatabase TO mydbuser;
    GRANT
    postgres=#
    ```

16. ​							从互动终端注销： 					

    

    ```none
    postgres=# \q
    ```

17. ​							注销 `postgres` 用户会话： 					

    

    ```none
    $ logout
    ```

18. ​							通过更改 `/var/lib/pgsql/data/pg_hba.conf` 文件中的 IPv4 本地连接，将所有数据库的访问限制为只使用 TLS 的客户端的连接： 					

    

    ```none
    host		all		all		127.0.0.1/32		ident
    ```

    ​							改为： 					

    

    ```none
    hostssl 	all		all		127.0.0.1/32		scram-sha-256
    ```

19. ​							通过重启 `postgresql` 服务来有效地进行更改： 					

    

    ```none
    # systemctl restart postgresql.service
    ```

20. ​							以 `mydbuser` 用户身份连接 **PostgreSQL** 数据库，指定主机名和数据库名称： 					

    

    ```none
    $ psql -U mydbuser -h 127.0.0.1 -d mydatabase
    Password for user mydbuser:
    psql (13.7)
    SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
    Type "help" for help.
    
    mydatabase=>
    ```

- 

## 4.7. 迁移到 RHEL 9 的 PostgreSQL 版本

​				Red Hat Enterprise Linux 8 在多个模块流中提供 **PostgreSQL** ：**PostgreSQL 10** （默认的 postgresql 流）、**PostgreSQL 9.6**、**PostgreSQL 12** 和 **PostgreSQL 13**。在 RHEL 9 中，**PostgreSQL 13** 可用。 		

​				在 RHEL 中，您可以为数据库文件使用两个 **PostgreSQL** 迁移路径： 		

- ​						[使用 pg_upgrade 工具快速升级](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#fast-upgrade-using-the-pg_upgrade-tool_migrating-to-a-rhel-9-version-of-postgresql) 				
- ​						[转储和恢复升级](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#dump-and-restore-upgrade_migrating-to-a-rhel-9-version-of-postgresql) 				

​				快速升级方法比转储和恢复过程要快。然而，在某些情况下，快速升级无法正常工作，例如，当跨架构升级时，只能使用转储和恢复过程。 		

​				迁移到更新版本的 **PostgreSQL** 的先决条件是备份所有 **PostgreSQL** 数据库。 		

​				转储和恢复过程需要转储数据库并执行SQL文件备份，建议使用快速升级方法。 		

​				在迁移到 **PostgreSQL** 的后续版本之前，请参阅您要迁移的 **PostgreSQL** 版本的[上游兼容性说明](https://www.postgresql.org/docs/13/release.html)，以及您要迁移的版本与目标版本之间所有跳过的 **PostgreSQL** 版本。 		

### 4.7.1. 使用 pg_upgrade 工具快速升级

​					作为系统管理员，您可以使用快速升级方法升级到 **PostgreSQL** 的最新版本。要执行快速升级，您必须将二进制数据文件复制到 `/var/lib/pgsql/data/` 目录中，并使用 `pg_upgrade` 工具。 			

​					以下流程描述了使用快速升级方法从 RHEL 8 版本的 **PostgreSQL 12** 迁移到 RHEL 9 版本的 **PostgreSQL 13**。对于从 `12` 以外的 `postgresql` 流进行迁移，请使用以下方法之一： 			

- ​							将 RHEL 8 上的 **PostgreSQL** 服务器更新至版本 12，然后使用 `pg_upgrade` 程序执行一个到 RHEL 9 版本的 **PostgreSQL 13** 的快速升级。如需更多信息，请参阅 [迁移到 PostgreSQL 的 RHEL 9 版本](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_using_database_servers/index#migrating-to-a-rhel-9-version-of-postgresql_using-postgresql)。 					
- ​							使用转储并在 RHEL 9 中的任何 RHEL 8 版本的 **PostgreSQL** 和 **PostgreSQL 13** 之间直接恢复升级。 					

**先决条件**

- ​							在执行升级前，请备份存储在 **PostgreSQL** 数据库中的所有数据。默认情况下，所有数据都存储在 RHEL 8 和 RHEL 9 系统的 `/var/lib/pgsql/data/` 目录中。 					

**流程**

1. ​							在 RHEL 9 系统中，安装 `postgresql-server` 和 `postgresql-upgrade` 软件包： 					

   

   ```none
   # dnf install postgresql-server postgresql-upgrade
   ```

   ​							另外，如果您在 RHEL 8 上使用了任何 **PostgreSQL** 服务器模块，那么也可以在 RHEL 9 系统上安装该模块的两个版本，分别针对 **PostgreSQL 12** （作为 `postgresql-upgrade` 软件包安装）和 **PostgreSQL 13** 的目标版本（作为 `postgresql-server` 软件包安装）进行编译。如果您需要编译第三方**PostgreSQL**服务器模块，请根据`postgresql-devel`和`postgresql-upgrade-devel`软件包来构建它。 					

2. ​							检查以下项： 					

   - ​									基本配置：在 RHEL 9 系统中，检查您的服务器是否使用默认 `/var/lib/pgsql/data` 目录，且数据库已正确初始化并启用。此外，数据文件必须存储在 `/usr/lib/systemd/system/postgresql.service` 文件中提及的相同路径。 							
   - ​									**PostgreSQL** 服务器：您的系统可以运行多个 **PostgreSQL** 服务器。确保所有这些服务器的数据目录都是独立处理的。 							
   - ​									**PostgreSQL** 服务器模块：确保在 RHEL 8 中使用的 **PostgreSQL** 服务器模块也安装在 RHEL 9 系统中。请注意，插件安装在 `/usr/lib64/pgsql/` 目录中。 							

3. ​							确保 `postgresql` 服务在复制数据时未在源和目标系统上运行。 					

   

   ```none
   # systemctl stop postgresql.service
   ```

4. ​							将源位置中的数据库文件复制到 RHEL 9 系统上的 `/var/lib/pgsql/data/` 目录中。 					

5. ​							以 **PostgreSQL** 用户身份运行以下命令来执行升级过程： 					

   

   ```none
   # postgresql-setup --upgrade
   ```

   ​							这会在后台启动 `pg_upgrade` 进程。 					

   ​							在出现故障时，`postgresql-setup` 会提供一条说明性的错误消息。 					

6. ​							将之前的配置从 `/var/lib/pgsql/data-old` 复制到新集群。 					

   ​							请注意，快速升级不会在较新的数据栈中重用之前的配置，配置是从零开始生成的。如果要手动组合旧配置和新配置，请使用数据目录中的 *.conf 文件。 					

7. ​							启动新的 **PostgreSQL** 服务器： 					

   

   ```none
   # systemctl start postgresql.service
   ```

8. ​							运行 **PostgreSQL** 主目录中的 `analyze_new_cluster.sh` 脚本： 					

   

   ```none
   su postgres -c '~/analyze_new_cluster.sh'
   ```

9. ​							如果您希望新 **PostgreSQL** 服务器在引导时自动启动，请运行： 					

   

   ```none
   # systemctl enable postgresql.service
   ```

### 4.7.2. 转储和恢复升级

​					使用转储和恢复升级时，您必须将所有的数据库内容转储到 SQL 文件转储文件中。请注意，转储和恢复升级比快速升级方法慢，可能需要在生成的 SQL 文件中进行一些手动修复。 			

​					您可以使用此方法将数据从任何 RHEL 8 版本的 **PostgreSQL** 迁移到 RHEL 9 版本的 **PostgreSQL 13**。 			

​					在 RHEL 8 和 RHEL 9 系统中，**PostgreSQL** 数据默认存储在 `/var/lib/pgsql/data/` 目录中。 			

​					要执行转储和恢复升级，请将用户改为 `root`。 			

​					以下流程描述了从 RHEL 8 的默认 **Postgreql 10** 迁移到 RHEL 9 的 **PostgreSQL 13**。 			

**流程**

1. ​							在 RHEL 8 系统中，启动 **PostgreSQL 10** 服务器： 					

   

   ```none
   # systemctl start postgresql.service
   ```

2. ​							在 RHEL 8 系统中，将所有数据库内容转储到 `pgdump_file.sql` 文件中： 					

   

   ```none
   su - postgres -c "pg_dumpall > ~/pgdump_file.sql"
   ```

3. ​							确保正确转储数据库： 					

   

   ```none
   su - postgres -c 'less "$HOME/pgdump_file.sql"'
   ```

   ​							结果显示的转储的 sql 文件的路径为：`/var/lib/pgsql/pgdump_file.sql`。 					

4. ​							在 RHEL 9 系统中，安装 `postgresql-server` 软件包： 					

   

   ```none
   # dnf install postgresql-server
   ```

   ​							另外，如果您在 RHEL 8 中使用了任何 **PostgreSQL** 服务器模块，也需要在 RHEL 9 系统中安装它们。如果您需要编译第三方 **PostgreSQL** 服务器模块，请根据 `postgresql-devel` 软件包进行构建。 					

5. ​							在 RHEL 9 系统中，初始化新 **PostgreSQL** 服务器的数据目录： 					

   

   ```none
   # postgresql-setup --initdb
   ```

6. ​							在 RHEL 9 系统中，将 `pgdump_file.sql` 复制到 **PostgreSQL** 主目录中，并检查是否已正确复制该文件： 					

   

   ```none
   su - postgres -c 'test -e "$HOME/pgdump_file.sql" && echo exists'
   ```

7. ​							复制 RHEL 8 系统中的配置文件： 					

   

   ```none
   su - postgres -c 'ls -1 $PGDATA/.conf'*
   ```

   ​							要复制的配置文件包括： 					

   - ​									`/var/lib/pgsql/data/pg_hba.conf` 							
   - ​									`/var/lib/pgsql/data/pg_ident.conf` 							
   - ​									`/var/lib/pgsql/data/postgresql.conf` 							

8. ​							在 RHEL 9 系统中，启动新的 **PostgreSQL** 服务器： 					

   

   ```none
   # systemctl start postgresql.service
   ```

9. ​							在 RHEL 9 系统中，从转储的 sql 文件中导入数据： 					

   

   ```none
   su - postgres -c 'psql -f ~/pgdump_file.sql postgres'
   ```