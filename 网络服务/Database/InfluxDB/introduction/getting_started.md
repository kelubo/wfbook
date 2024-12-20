---
title: Getting Started with InfluxDB
---

With [InfluxDB installed](installation.html), you're ready to start doing awesome things. 在本节，我们将使用`influx`命令行界面(CLI)。The CLI is included in all InfluxDB packages and is a lightweight and simple way to interact with the database. The CLI communicates with InfluxDB by making requests to the InfluxDB API. 

> **Note:** The database can also be used by making direct HTTP requests to the API. See [Reading and Writing Data](../concepts/reading_and_writing_data.html) for examples.

## 登录并创建第一个数据库
如果你已经在本地安装了InfluxDB，`influx`命令应该在命令行中可以使用。执行`influx`将开启CLI并且自动连接到本地的InfluxDB实例。如果`influx`不在你的path中，试下`/opt/influxdb/influx`。输出如下：

```sh
$ influx
Connected to http://localhost:8086 version 0.9.0
InfluxDB shell 0.9.0
> 
```

> **Note:** InfluxDB HTTP API默认使用`8086`端口。Therefore, `influx` will connect to port `8086` and `localhost` by default. If you need to alter these defaults run `influx --help` or read the [man page](../clients/shell.html)

The command line is now ready to take input in the form of Influx Query Language (a.k.a InfluxQL) statements.退出InfluxQL shell，键入`exit`并敲击回车键，也可以键入`ctrl` + `D`。

一个全新安装的InfluxDB并没有数据库，所以创建一个是我们第一个任务。Create a database with the `CREATE DATABASE <db-name>` InfluxQL statement, where `<db-name>` is the name of the database you wish to create. Names of databases can contain any unicode character as long as the string is double-quoted. Names can be left unquoted if they contain only ASCII letters, digits, or underscores and do not begin with a digit.

在本指南中，我们将使用数据库名`mydb`。

```sql
> CREATE DATABASE mydb
> 
```

> **Note:** 在键入enter键后，一个新的提示符出现，并且没有其他任何显示。 In the CLI, this means the statement was executed and there were no errors to display. There will always be an error displayed if something went wrong.没有消息就是好消息！
The `SHOW DATABASES` statement can be used to show all existing databases.

```sql
> SHOW DATABASES
name: databases
---------------
name
mydb

> 
```


Unlike `SHOW DATABASES`, most InfluxQL statements must operate against a specific database. You may explicitly name the database with each query, but the CLI provides a convenient statement, `USE <db-name>`, which will automatically set the database for all future requests.

```sql
> USE mydb
Using database mydb
> 
```

## Writing and exploring data

现在我们有了一个数据库，InfluxDB已经准备好接受查询和写入请求。

First a short primer on the datastore. Data in InfluxDB is organized by `time series`, which contain a measured value, like "cpu_load" or "temperature". Time series have zero to many `points`, one for each discrete sample of the metric. Points consist of `time` (a timestamp), a `measurement` ("cpu_load"), at least one key-value `field` (the measured value itself, e.g. "value=0.64" or "15min=0.78"), and zero to many key-value `tags` containing metadata (e.g. "host=server01", "region=EMEA", "dc=Frankfurt"). Conceptually you can think of a `measurement` as an SQL table, with rows where the primary index is always time. `tags` and `fields` are effectively columns in the table. `tags` are indexed, `fields` are not. The difference is that with InfluxDB you can have millions of measurements, you don't have to define schemas up front, and null values aren't stored.

Points are written to InfluxDB using line protocol, which follows the following format:

```
<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]
```

The following lines are all examples of points that can be written to InfluxDB:

```
cpu,host=serverA,region=us_west value=0.64
payment,device=mobile,product=Notepad,method=credit billed=33,licenses=3i 1434067467100293230
stock,symbol=AAPL bid=127.46,ask=127.48
temperature,machine=unit42,type=assembly external=25,internal=37 1434067467000000000
```

> **Note:** Measurements, tags, and field names containing any character other than (A-Z,a-z,0-9,_) or starting with a digit must be double-quoted. More information on the line protocol can be found on the [Reading and Writing Data](../concepts/reading_and_writing_data.html) page.

To insert a single time-series datapoint into InfluxDB using the CLI, enter `INSERT` followed by a point:

```sql
> INSERT cpu,host=serverA,region=us_west value=0.64
>
```

A point with the measurement name of `cpu` and tag `host` has now been written to the database, with the measured value of `0.64`.

Now we will query for the data we just wrote.

```sql
> SELECT * FROM cpu
name: cpu
tags: host=serverA, region=us-west
time                value
----                -----
2015-06-11T16:02:54.830398489Z  0.64

> 
```

> **Note:** We did not supply a timestamp when writing our point. When no timestamp is supplied for a point, InfluxDB assigns the local current timestamp when the point is ingested. That means your timestamp will be different.

Let's try storing a different type of data -- sensor data. Enter the following data in the `Values` textbox:

```sql
> INSERT temperature,machine=unit42,type=assembly external=25,internal=37
>
```

> **Note:** In this example we write two values in the `fields` section. Up to 255 different `fields` can be stored per `measurement`. 

All fields are returned on query:

```sql
> select * from temperature
name: temperature
tags: machine=unit42, type=assembly
time                external    internal
----                --------    --------
2015-06-11T16:04:52.653752331Z  25      37

>
```

InfluxDB supports a sophisticated query language, allowing many different types of queries. For example:

```sql
> SELECT * FROM /.*/ LIMIT 1
--
> SELECT * FROM cpu_load_short
--
> SELECT * FROM cpu_load_short WHERE value > 0.9
```

This is all you need to know to write data into InfluxDB and query it back. Of course, to write significant amounts of data you will want to access the HTTP API directly, or use one of the many client libraries.

> **Note:** All identifiers are case-sensitive

```sql
> show databases
name: databases
---------------
name
mydb
MyDb
MYDB
```

```sql
> show series
name: CaseSensitive
-------------------
_key            TAG1  Tag1  tag1
CaseSensitive             
CaseSensitive,Tag1=key          key 
CaseSensitive,tag1=key            key
CaseSensitive,TAG1=key        key   
CaseSensitive,TAG1=key,tag1=key,Tag1=key  key key key


name: casesensitive
-------------------
_key            TAG1  Tag1  tag1
casesensitive             
casesensitive,Tag1=key          key 
casesensitive,TAG1=key,tag1=key,Tag1=key  key key key
```

```sql
> select * from casesensitive
name: casesensitive
tags: TAG1=, Tag1=, tag1=
time        VALUE Value value
----        ----- ----- -----
2015-06-12T23:08:54.80898266Z     1
2015-06-12T23:10:28.604159664Z  3 2 1
```
