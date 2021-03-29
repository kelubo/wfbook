# MongoDB![img](../../../Image/m/mongodb-logo.png)

[TOC]

MongoDB 是一个基于分布式文件存储的开源数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。

MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成。MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。

## 主要特点

- MongoDB 是一个面向文档存储的数据库，操作起来比较简单和容易。

- 可以在MongoDB记录中设置任何属性的索引 (如：FirstName="Sameer",Address="8 Gandhi Road")来实现更快的排序。

- 可以通过本地或者网络创建数据镜像，这使得MongoDB有更强的扩展性。

- 如果负载的增加（需要更多的存储空间和更强的处理能力） ，它可以分布在计算机网络中的其他节点上这就是所谓的分片。

- MongoDB支持丰富的查询表达式。查询指令使用JSON形式的标记，可轻易查询文档中内嵌的对象及数组。 

- MongoDB 使用update()命令可以实现替换完成的文档（数据）或者一些指定的数据字段 。

- MongoDB中的Map/reduce主要是用来对数据进行批量处理和聚合操作。

- Map和Reduce。Map函数调用emit(key,value)遍历集合中所有的记录，将key与value传给Reduce函数进行处理。

- Map函数和Reduce函数是使用Javascript编写的，并可以通过db.runCommand或mapreduce命令来执行MapReduce操作。

- GridFS是MongoDB中的一个内置功能，可以用于存放大量小文件。

- MongoDB允许在服务端执行脚本，可以用Javascript编写某个函数，直接在服务端执行，也可以把函数的定义存储在服务端，下次直接调用即可。

- MongoDB支持各种编程语言:RUBY，PYTHON，JAVA，C++，PHP，C#等多种语言。

- MongoDB安装简单。

## 历史

- 2007年10月，MongoDB由10gen团队所发展。2009年2月首度推出。
- 2012年05月23日，MongoDB2.1 开发分支发布了! 该版本采用全新架构，包含诸多增强。
- 2012年06月06日，MongoDB 2.0.6 发布，分布式文档数据库。
- 2013年04月23日，MongoDB 2.4.3 发布，此版本包括了一些性能优化，功能增强以及bug修复。
- 2013年08月20日，MongoDB 2.4.6 发布。
- 2013年11月01日，MongoDB 2.4.8 发布。

## 支持平台

MonggoDB支持以下平台:

- OS X 32-bit
- OS X 64-bit
- Linux 32-bit
- Linux 64-bit
- Windows 32-bit
- Windows 64-bit
- Solaris i86pc
- Solaris 64

## 语言支持

MongoDB有官方的驱动如下：

- [C](http://github.com/mongodb/mongo-c-driver)
- [C++](http://github.com/mongodb/mongo)
- [C# / .NET](http://www.mongodb.org/display/DOCS/CSharp+Language+Center)
- [Erlang](https://github.com/TonyGen/mongodb-erlang)
- [Haskell](http://hackage.haskell.org/package/mongoDB)
- [Java](http://github.com/mongodb/mongo-java-driver)
- [JavaScript](http://www.mongodb.org/display/DOCS/Javascript+Language+Center)
- [Lisp](https://github.com/fons/cl-mongo)
- [node.JS](http://github.com/mongodb/node-mongodb-native)
- [Perl](http://github.com/mongodb/mongo-perl-driver)
- [PHP](http://github.com/mongodb/mongo-php-driver)
- [Python](http://github.com/mongodb/mongo-python-driver)
- [Ruby](http://github.com/mongodb/mongo-ruby-driver)
- [Scala](https://github.com/mongodb/casbah)

## MongoDB 工具

### 监控

MongoDB提供了网络和系统监控工具Munin，它作为一个插件应用于MongoDB中。

Gangila是MongoDB高性能的系统监视的工具，它作为一个插件应用于MongoDB中。

基于图形界面的开源工具 Cacti, 用于查看CPU负载, 网络带宽利用率,它也提供了一个应用于监控 MongoDB 的插件。

### GUI

- Fang of Mongo – 网页式,由Django和jQuery所构成。
- Futon4Mongo – 一个CouchDB Futon web的mongodb山寨版。
- Mongo3 – Ruby写成。
- MongoHub – 适用于OSX的应用程序。
- Opricot – 一个基于浏览器的MongoDB控制台, 由PHP撰写而成。
- Database Master — Windows的mongodb管理工具
- RockMongo — 最好的PHP语言的MongoDB管理工具，轻量级, 支持多国语言.

## MongoDB 应用案例

下面列举一些公司MongoDB的实际应用：

- Craiglist上使用MongoDB的存档数十亿条记录。
- FourSquare，基于位置的社交网站，在Amazon EC2的服务器上使用MongoDB分享数据。
- Shutterfly，以互联网为基础的社会和个人出版服务，使用MongoDB的各种持久性数据存储的要求。
- bit.ly, 一个基于Web的网址缩短服务，使用MongoDB的存储自己的数据。
- spike.com，一个MTV网络的联营公司， spike.com使用MongoDB的。
- Intuit公司，一个为小企业和个人的软件和服务提供商，为小型企业使用MongoDB的跟踪用户的数据。
- sourceforge.net，资源网站查找，创建和发布开源软件免费，使用MongoDB的后端存储。
- etsy.com ，一个购买和出售手工制作物品网站，使用MongoDB。
- 纽约时报，领先的在线新闻门户网站之一，使用MongoDB。
- CERN，著名的粒子物理研究所，欧洲核子研究中心大型强子对撞机的数据使用MongoDB。 

## 安装MongoDB

安装前我们需要安装各个 Linux 平台依赖包。

**Red Hat/CentOS：**

```bash
yum install libcurl openssl
```

**Ubuntu 18.04 LTS ("Bionic")/Debian 10 "Buster"：**

```bash
sudo apt-get install libcurl4 openssl
```

**Ubuntu 16.04 LTS ("Xenial")/Debian 9 "Stretch"：**

```bash
sudo apt-get install libcurl3 openssl
```

MongoDB 源码下载地址：https://www.mongodb.com/download-center#community

这里我们选择 tgz 下载，下载完安装包，并解压 **tgz**（以下演示的是 64 位 Linux上的安装） 。

```
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.2.8.tgz    # 下载
tar -zxvf mongodb-linux-x86_64-ubuntu1604-4.2.8.tgz                                    # 解压
mv mongodb-src-r4.2.8  /usr/local/mongodb4                          # 将解压包拷贝到指定目录
```

MongoDB 的可执行文件位于 bin 目录下，所以可以将其添加到 **PATH** 路径中：

```
export PATH=<mongodb-install-directory>/bin:$PATH
```

**<mongodb-install-directory>** 为你 MongoDB 的安装路径。如本文的 **/usr/local/mongodb4** 。

```
export PATH=/usr/local/mongodb4/bin:$PATH
```

### CentOS 8

1. 创建源配置文件

   ```bash
   vim /etc/yum.repos.d/mongodb-org-4.4.repo
   
   [mongodb-org-4.4]
   name=MongoDB Repository
   baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
   gpgcheck=1
   enabled=1
   gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
   ```

2. 安装MongoDB

   ```bash
   yum makecache
   yum install -y mongodb-org
   ```

## 创建数据库目录

默认情况下 MongoDB 启动后会初始化以下两个目录：

- 数据存储目录：/var/lib/mongodb
- 日志文件目录：/var/log/mongodb

我们在启动前可以先创建这两个目录并设置当前用户有读写权限：

```
sudo mkdir -p /var/lib/mongo
sudo mkdir -p /var/log/mongodb
sudo chown `whoami` /var/lib/mongo     # 设置权限
sudo chown `whoami` /var/log/mongodb   # 设置权限
```

## 启动 Mongodb 服务

```
mongod --dbpath /var/lib/mongo --logpath /var/log/mongodb/mongod.log --fork
```

打开 /var/log/mongodb/mongod.log 文件看到以下信息，说明启动成功。

```
tail -10f /var/log/mongodb/mongod.log

2020-07-09T12:20:17.391+0800 I  NETWORK  [listener] Listening on /tmp/mongodb-27017.sock
2020-07-09T12:20:17.392+0800 I  NETWORK  [listener] Listening on 127.0.0.1
2020-07-09T12:20:17.392+0800 I  NETWORK  [listener] waiting for connections on port 27017
```



------

## MongoDB 后台管理 Shell

如果你需要进入 mongodb 后台管理，你需要先打开 mongodb 装目录的下的 bin 目录，然后执行 mongo 命令文件。

MongoDB Shell 是 MongoDB 自带的交互式 Javascript shell，用来对 MongoDB 进行操作和管理的交互式环境。

当你进入 mongoDB 后台后，它默认会链接到 test 文档（数据库）：

```
$ cd /usr/local/mongodb4/bin
$ ./mongo
MongoDB shell version v4.2.8
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("2cfdafc4-dd56-4cfc-933a-187b887119b3") }
MongoDB server version: 4.2.8
Welcome to the MongoDB shell.
……
```

由于它是一个JavaScript shell，您可以运行一些简单的算术运算:

```
> 2+2
4
> 3+6
9
```

现在让我们插入一些简单的数据，并对插入的数据进行检索：

```
> db.runoob.insert({x:10})
WriteResult({ "nInserted" : 1 })
> db.runoob.find()
{ "_id" : ObjectId("5f069bdb4e02f8baf90f1184"), "x" : 10 }
> 
```

第一个命令将数字 10 插入到 runoob 集合的 x 字段中。

如果要停止 mongodb 可以使用以下命令：

```
mongod --dbpath /var/lib/mongo --logpath /var/log/mongodb/mongod.log --shutdown
```

也可以在 mongo 的命令出口中实现：

```
> use admin
switched to db admin
> db.shutdownServer()
```

更多安装方法可以参考官网：https://docs.mongodb.com/manual/administration/install-on-linux/

## MongoDB  概念解析 

不管我们学习什么数据库都应该学习其中的基础概念，在mongodb中基本的概念是文档、集合、数据库，下面我们挨个介绍。

下表将帮助您更容易理解Mongo中的一些概念：

| SQL术语/概念 | MongoDB术语/概念 | 解释/说明                           |
| ------------ | ---------------- | ----------------------------------- |
| database     | database         | 数据库                              |
| table        | collection       | 数据库表/集合                       |
| row          | document         | 数据记录行/文档                     |
| column       | field            | 数据字段/域                         |
| index        | index            | 索引                                |
| table joins  |                  | 表连接,MongoDB不支持                |
| primary key  | primary key      | 主键,MongoDB自动将_id字段设置为主键 |

通过下图实例，我们也可以更直观的了解Mongo中的一些概念：

![img](https://www.runoob.com/wp-content/uploads/2013/10/Figure-1-Mapping-Table-to-Collection-1.png)

------

## 数据库

一个mongodb中可以建立多个数据库。

MongoDB的默认数据库为"db"，该数据库存储在data目录中。

MongoDB的单个实例可以容纳多个独立的数据库，每一个都有自己的集合和权限，不同的数据库也放置在不同的文件中。

**"show dbs"** 命令可以显示所有数据的列表。

```
$ ./mongo
MongoDB shell version: 3.0.6
connecting to: test
> show dbs
local  0.078GB
test   0.078GB
> 
```

执行 **"db"** 命令可以显示当前数据库对象或集合。

```
$ ./mongo
MongoDB shell version: 3.0.6
connecting to: test
> db
test
> 
```

运行"use"命令，可以连接到一个指定的数据库。

```
> use local
switched to db local
> db
local
> 
```

以上实例命令中，"local" 是你要链接的数据库。

在下一个章节我们将详细讲解MongoDB中命令的使用。

数据库也通过名字来标识。数据库名可以是满足以下条件的任意UTF-8字符串。

- 不能是空字符串（"")。
- 不得含有' '（空格)、.、$、/、\和\0 (空字符)。
- 应全部小写。
- 最多64字节。

有一些数据库名是保留的，可以直接访问这些有特殊作用的数据库。

- **admin**： 从权限的角度来看，这是"root"数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。
- **local:** 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合
- **config**: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息。

------

## 文档(Document)

文档是一组键值(key-value)对(即 BSON)。MongoDB 的文档不需要设置相同的字段，并且相同的字段不需要相同的数据类型，这与关系型数据库有很大的区别，也是 MongoDB 非常突出的特点。

一个简单的文档例子如下：

```
{"site":"www.runoob.com", "name":"菜鸟教程"}
```

下表列出了 RDBMS 与 MongoDB 对应的术语：

|       RDBMS        | MongoDB                            |
| :----------------: | ---------------------------------- |
|       数据库       | 数据库                             |
|        表格        | 集合                               |
|         行         | 文档                               |
|         列         | 字段                               |
|       表联合       | 嵌入文档                           |
|        主键        | 主键 (MongoDB 提供了 key  为 _id ) |
| 数据库服务和客户端 |                                    |
|   Mysqld/Oracle    | mongod                             |
|   mysql/sqlplus    | mongo                              |

需要注意的是：

1. 文档中的键/值对是有序的。
2. 文档中的值不仅可以是在双引号里面的字符串，还可以是其他几种数据类型（甚至可以是整个嵌入的文档)。
3. MongoDB区分类型和大小写。
4. MongoDB的文档不能有重复的键。
5. 文档的键是字符串。除了少数例外情况，键可以使用任意UTF-8字符。

文档键命名规范：

- 键不能含有\0 (空字符)。这个字符用来表示键的结尾。
- .和$有特别的意义，只有在特定环境下才能使用。
- 以下划线"_"开头的键是保留的(不是严格要求的)。

------

## 集合

集合就是 MongoDB 文档组，类似于 RDBMS （关系数据库管理系统：Relational Database Management System)中的表格。

集合存在于数据库中，集合没有固定的结构，这意味着你在对集合可以插入不同格式和类型的数据，但通常情况下我们插入集合的数据都会有一定的关联性。



比如，我们可以将以下不同数据结构的文档插入到集合中：

```
{"site":"www.baidu.com"}
{"site":"www.google.com","name":"Google"}
{"site":"www.runoob.com","name":"菜鸟教程","num":5}
```

当第一个文档插入时，集合就会被创建。

### 合法的集合名

- 集合名不能是空字符串""。
- 集合名不能含有\0字符（空字符)，这个字符表示集合名的结尾。
- 集合名不能以"system."开头，这是为系统集合保留的前缀。
- 用户创建的集合名字不能含有保留字符。有些驱动程序的确支持在集合名里面包含，这是因为某些系统生成的集合中包含该字符。除非你要访问这种系统创建的集合，否则千万不要在名字里出现$。　

如下实例：

```
db.col.findOne()
```

### capped collections

Capped collections 就是固定大小的collection。

它有很高的性能以及队列过期的特性(过期按照插入的顺序). 有点和 "RRD" 概念类似。

Capped collections 是高性能自动的维护对象的插入顺序。它非常适合类似记录日志的功能和标准的 collection  不同，你必须要显式的创建一个capped collection，指定一个 collection 的大小，单位是字节。collection  的数据存储空间值提前分配的。

Capped collections  可以按照文档的插入顺序保存到集合中，而且这些文档在磁盘上存放位置也是按照插入顺序来保存的，所以当我们更新Capped collections  中文档的时候，更新后的文档不可以超过之前文档的大小，这样话就可以确保所有文档在磁盘上的位置一直保持不变。

由于 Capped collection 是按照文档的插入顺序而不是使用索引确定插入位置，这样的话可以提高增添数据的效率。MongoDB 的操作日志文件 oplog.rs 就是利用 Capped Collection 来实现的。

要注意的是指定的存储大小包含了数据库的头信息。

```
db.createCollection("mycoll", {capped:true, size:100000})
```

- 在 capped collection 中，你能添加新的对象。
- 能进行更新，然而，对象不会增加存储空间。如果增加，更新就会失败 。
- 使用 Capped Collection 不能删除一个文档，可以使用 drop() 方法删除 collection 所有的行。
- 删除之后，你必须显式的重新创建这个 collection。
- 在32bit机器中，capped collection 最大存储为 1e9( 1X109)个字节。

------

## 元数据

数据库的信息是存储在集合中。它们使用了系统的命名空间：

```
dbname.system.*
```

在MongoDB数据库中名字空间 <dbname>.system.* 是包含多种系统信息的特殊集合(Collection)，如下:

| 集合命名空间             | 描述                                      |
| ------------------------ | ----------------------------------------- |
| dbname.system.namespaces | 列出所有名字空间。                        |
| dbname.system.indexes    | 列出所有索引。                            |
| dbname.system.profile    | 包含数据库概要(profile)信息。             |
| dbname.system.users      | 列出所有可访问数据库的用户。              |
| dbname.local.sources     | 包含复制对端（slave）的服务器信息和状态。 |

对于修改系统集合中的对象有如下限制。

在{{system.indexes}}插入数据，可以创建索引。但除此之外该表信息是不可变的(特殊的drop index命令将自动更新相关信息)。 

{{system.users}}是可修改的。 {{system.profile}}是可删除的。

------

## MongoDB 数据类型

下表为MongoDB中常用的几种数据类型。

| 数据类型           | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| String             | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。 |
| Integer            | 整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。 |
| Boolean            | 布尔值。用于存储布尔值（真/假）。                            |
| Double             | 双精度浮点值。用于存储浮点值。                               |
| Min/Max keys       | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。 |
| Array              | 用于将数组或列表或多个值存储为一个键。                       |
| Timestamp          | 时间戳。记录文档修改或添加的具体时间。                       |
| Object             | 用于内嵌文档。                                               |
| Null               | 用于创建空值。                                               |
| Symbol             | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。 |
| Date               | 日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。 |
| Object ID          | 对象 ID。用于创建文档的 ID。                                 |
| Binary Data        | 二进制数据。用于存储二进制数据。                             |
| Code               | 代码类型。用于在文档中存储 JavaScript 代码。                 |
| Regular expression | 正则表达式类型。用于存储正则表达式。                         |

下面说明下几种重要的数据类型。

### ObjectId

ObjectId 类似唯一主键，可以很快的去生成和排序，包含 12 bytes，含义是：

- 前 4 个字节表示创建 **unix** 时间戳,格林尼治时间 **UTC** 时间，比北京时间晚了 8 个小时
- 接下来的 3 个字节是机器标识码
- 紧接的两个字节由进程 id 组成 PID
- 最后三个字节是随机数

![img](https://www.runoob.com/wp-content/uploads/2013/10/2875754375-5a19268f0fd9b_articlex.jpeg)

MongoDB 中存储的文档必须有一个 _id 键。这个键的值可以是任何类型的，默认是个 ObjectId 对象

由于 ObjectId 中保存了创建的时间戳，所以你不需要为你的文档保存时间戳字段，你可以通过 getTimestamp 函数来获取文档的创建时间:

```
> var newObject = ObjectId()
> newObject.getTimestamp()
ISODate("2017-11-25T07:21:10Z")
```

ObjectId 转为字符串

```
> newObject.str
5a1919e63df83ce79df8b38f
```

### 字符串

**BSON 字符串都是 UTF-8 编码。**

### 时间戳

BSON 有一个特殊的时间戳类型用于 MongoDB 内部使用，与普通的 日期 类型不相关。 时间戳值是一个 64 位的值。其中：

- 前32位是一个 time_t 值（与Unix新纪元相差的秒数）
- 后32位是在某秒中操作的一个递增的`序数`

在单个 mongod 实例中，时间戳值通常是唯一的。

在复制集中， oplog 有一个 ts 字段。这个字段中的值使用BSON时间戳表示了操作时间。

> BSON 时间戳类型主要用于 MongoDB 内部使用。在大多数情况下的应用开发中，你可以使用 BSON 日期类型。

### 日期

表示当前距离 Unix新纪元（1970年1月1日）的毫秒数。日期类型是有符号的, 负数表示 1970 年之前的日期。

```
> var mydate1 = new Date()     //格林尼治时间
> mydate1
ISODate("2018-03-04T14:58:51.233Z")
> typeof mydate1
object
> var mydate2 = ISODate() //格林尼治时间
> mydate2
ISODate("2018-03-04T15:00:45.479Z")
> typeof mydate2
object
```

这样创建的时间是日期类型，可以使用 JS 中的 Date 类型的方法。

返回一个时间类型的字符串：

```
> var mydate1str = mydate1.toString()
> mydate1str
Sun Mar 04 2018 14:58:51 GMT+0000 (UTC) 
> typeof mydate1str
string
```

或者

```
> Date()
Sun Mar 04 2018 15:02:59 GMT+0000 (UTC)   
```

## MongoDB 备份(mongodump)与恢复(mongorestore)

### MongoDB数据备份

在Mongodb中我们使用mongodump命令来备份MongoDB数据。该命令可以导出所有数据到指定目录中。

 mongodump命令可以通过参数指定导出的数据量级转存的服务器。

### 语法

mongodump命令脚本语法如下：

```
>mongodump -h dbhost -d dbname -o dbdirectory
```

- -h：

  MongDB所在服务器地址，例如：127.0.0.1，当然也可以指定端口号：127.0.0.1:27017

- -d：

  需要备份的数据库实例，例如：test

- -o：

  备份的数据存放位置，例如：c:\data\dump，当然该目录需要提前建立，在备份完成后，系统自动在dump目录下建立一个test目录，这个目录里面存放该数据库实例的备份数据。

### 实例

在本地使用 27017 启动你的mongod服务。打开命令提示符窗口，进入MongoDB安装目录的bin目录输入命令mongodump:

```
>mongodump
```

执行以上命令后，客户端会连接到ip为 127.0.0.1 端口号为 27017 的MongoDB服务上，并备份所有数据到 bin/dump/ 目录中。命令输出结果如下：

![MongoDB数据备份](https://www.runoob.com/wp-content/uploads/2013/12/mongodump.png)

mongodump 命令可选参数列表如下所示：

| 语法                                              | 描述                           | 实例                                             |
| ------------------------------------------------- | ------------------------------ | ------------------------------------------------ |
| mongodump --host HOST_NAME --port PORT_NUMBER     | 该命令将备份所有MongoDB数据    | mongodump --host runoob.com --port 27017         |
| mongodump --dbpath DB_PATH --out BACKUP_DIRECTORY |                                | mongodump --dbpath /data/db/ --out /data/backup/ |
| mongodump --collection COLLECTION --db DB_NAME    | 该命令将备份指定数据库的集合。 | mongodump --collection mycol --db test           |

### MongoDB数据恢复

mongodb使用 mongorestore 命令来恢复备份的数据。

### 语法

mongorestore命令脚本语法如下：

```
>mongorestore -h <hostname><:port> -d dbname <path>
```

- --host <:port>, -h <:port>：

  MongoDB所在服务器地址，默认为： localhost:27017

- --db , -d ：

  需要恢复的数据库实例，例如：test，当然这个名称也可以和备份时候的不一样，比如test2

- --drop：

  恢复的时候，先删除当前数据，然后恢复备份的数据。就是说，恢复后，备份后添加修改的数据都会被删除，慎用哦！

- <path>：

   mongorestore 最后的一个参数，设置备份数据所在位置，例如：c:\data\dump\test。

  你不能同时指定 <path> 和 --dir 选项，--dir也可以设置备份目录。

- --dir：

  指定备份的目录

  你不能同时指定 <path> 和 --dir 选项。

接下来我们执行以下命令:

```
>mongorestore
```

执行以上命令输出结果如下：

![MongoDB数据恢复](https://www.runoob.com/wp-content/uploads/2013/12/mongorestore.png)

​			

## MongoDB 监控

在你已经安装部署并允许MongoDB服务后，你必须要了解MongoDB的运行情况，并查看MongoDB的性能。这样在大流量得情况下可以很好的应对并保证MongoDB正常运作。

MongoDB中提供了mongostat 和 mongotop 两个命令来监控MongoDB的运行情况。

------

### mongostat 命令

mongostat是mongodb自带的状态检测工具，在命令行下使用。它会间隔固定时间获取mongodb的当前运行状态，并输出。如果你发现数据库突然变慢或者有其他问题的话，你第一手的操作就考虑采用mongostat来查看mongo的状态。

启动你的Mongod服务，进入到你安装的MongoDB目录下的bin目录， 然后输入mongostat命令，如下所示：

```
D:\set up\mongodb\bin>mongostat
```

以上命令输出结果如下：

![img](https://www.runoob.com/wp-content/uploads/2013/12/mongostat.png)

### mongotop 命令

mongotop也是mongodb下的一个内置工具，mongotop提供了一个方法，用来跟踪一个MongoDB的实例，查看哪些大量的时间花费在读取和写入数据。 mongotop提供每个集合的水平的统计数据。默认情况下，mongotop返回值的每一秒。

启动你的Mongod服务，进入到你安装的MongoDB目录下的bin目录， 然后输入mongotop命令，如下所示：

```
D:\set up\mongodb\bin>mongotop
```

以上命令执行输出结果如下：

![img](https://www.runoob.com/wp-content/uploads/2013/12/mongotop.png)

带参数实例

```
 E:\mongodb-win32-x86_64-2.2.1\bin>mongotop 10
```

 ![img](https://www.runoob.com/wp-content/uploads/2013/12/29122412-e32a9f09e46e496a8833433fdb421311.gif) 

 后面的10是*<sleeptime>*参数 ，可以不使用，等待的时间长度，以秒为单位，mongotop等待调用之间。通过的默认mongotop返回数据的每一秒。 

```
 E:\mongodb-win32-x86_64-2.2.1\bin>mongotop --locks
```

报告每个数据库的锁的使用中，使用mongotop - 锁，这将产生以下输出：  

 ![img](https://www.runoob.com/wp-content/uploads/2013/12/29122706-bfdd58e62c404b948f8039c489f8be81.gif) 

输出结果字段说明：

- ns：

  包含数据库命名空间，后者结合了数据库名称和集合。

- **db：**

  包含数据库的名称。名为 . 的数据库针对全局锁定，而非特定数据库。

- **total：**

  mongod花费的时间工作在这个命名空间提供总额。 

- **read：**

  提供了大量的时间，这mongod花费在执行读操作，在此命名空间。 

- **write：**

  提供这个命名空间进行写操作，这mongod花了大量的时间。