Redis![logo](..\..\..\Image\r\e\redis.png)

[TOC]

## 概述

**REmote DIctionary Server (Redis，远程字典服务器)** 是一个开源的、高性能的、基于键值对的缓存与存储系统，通过提供多种键值数据类型来适应不同场景下的缓存与存储需求。同时 Redis 的诸多高层级功能使其可以胜任消息队列、任务队列等不同的角色。是跨平台的非关系型数据库。

由 Salvatore Sanfilippo 开发。

使用 ANSI C 语言编写、遵守 BSD 协议、支持网络、可基于内存、分布式、可选持久性的键值对(Key-Value)存储数据库，并提供多种语言的 API。

Redis 通常被称为数据结构服务器，因为值（value）可以是字符串(String)、哈希(Hash)、列表(list)、集合(sets)和有序集合(sorted sets)等类型。

### 相关资源

Redis 官网：https://redis.io/

源码地址：https://github.com/redis/redis

### 特点

- Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。 

- Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。

- Redis支持数据的备份，即master-slave模式的数据备份。 

### 优势

- **性能极高：**Redis 以其极高的性能而著称，能够支持每秒数十万次的读写操作。这使得Redis成为处理高并发请求的理想选择，尤其是在需要快速响应的场景中，如缓存、会话管理、排行榜等。Redis能读的速度是110000次/s,写的速度是81000次/s 。
- **丰富的数据类型：**Redis 不仅支持基本的键值存储，还提供了丰富的数据类型，包括字符串、列表、集合、哈希表、有序集合等。这些数据类型为开发者提供了灵活的数据操作能力，使得Redis可以适应各种不同的应用场景。
- **原子性操作：**Redis 的所有操作都是原子性的，这意味着操作要么完全执行，要么完全不执行。这种特性对于确保数据的一致性和完整性至关重要，尤其是在高并发环境下处理事务时。单个操作是原子性的。多个操作也支持事务，即原子性，通过 MULTI 和 EXEC 指令包起来。
- **持久化：**Redis 支持数据的持久化，可以将内存中的数据保存到磁盘中，以便在系统重启后恢复数据。这为 Redis 提供了数据安全性，确保数据不会因为系统故障而丢失。支持两种持久化方式：RDB、AOF
- **支持发布/订阅模式：**Redis 内置了发布/订阅模式（Pub/Sub），允许客户端之间通过消息传递进行通信。这使得 Redis 可以作为消息队列和实时数据传输的平台。
- **单线程模型：**尽管 Redis 是单线程的，但它通过高效的事件驱动模型来处理并发请求，确保了高性能和低延迟。单线程模型也简化了并发控制的复杂性。
- **主从复制：**Redis 支持主从复制，可以通过从节点来备份数据或分担读请求，提高数据的可用性和系统的伸缩性。
- 高可用和分布式
- **应用场景广泛：**Redis 被广泛应用于各种场景，包括但不限于缓存系统、会话存储、排行榜、实时分析、地理空间数据索引等。
- **社区支持：**Redis 拥有一个活跃的开发者社区，提供了大量的文档、教程和第三方库，这为开发者提供了强大的支持和丰富的资源。
- **跨平台兼容性：**Redis 可以在多种操作系统上运行，包括 Linux、macOS 和 Windows，这使得它能够在不同的技术栈中灵活部署。
- 简单稳定 -  代码少；使用单线程模型；不需要依赖于操作系统的类库。
- **丰富的特性集：**Redis 还支持 publish/subscribe（发布/订阅）模式、通知、key 过期等高级特性。这些特性使得 Redis 可以用于消息队列、实时数据分析等复杂的应用场景。
- **支持 Lua 脚本：**Redis 支持使用 Lua 脚本来编写复杂的操作，这些脚本可以在服务器端执行，提供了更多的灵活性和强大的功能。

### Redis 与其他 key-value 存储的不同

- Redis有着更为复杂的数据结构并且提供对他们的原子性操作。Redis的数据类型都是基于基本数据结构的同时对程序员透明，无需进行额外的抽象。
- Redis运行在内存中但是可以持久化到磁盘，所以在对不同数据集进行高速读写时需要权衡内存，因为数据量不能大于硬件内存。在内存数据库方面的另一个优点是，相比在磁盘上相同的复杂的数据结构，在内存中操作起来非常简单，这样Redis可以做很多内部复杂性很强的事情。同时，在磁盘格式方面他们是紧凑的以追加的方式产生的，因为他们并不需要进行随机访问。        

### 支持的语言

 ![img](../../../Image/r/redis_lang)

### 应用场景

1. 会话缓存（最常用）
2. 消息队列，比如支付
3. 活动排行榜或计数器
4. 发布，订阅消息（消息通知）
5. 商品列表，评论列表等
6. 社交网络



## 参数说明

redis.conf 配置项说明如下：

| 序号 | 配置项                                                       | 说明                                                         |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | `daemonize no`                                               | Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用 yes 启用守护进程（Windows 不支持守护线程的配置为 no ） |
| 2    | `pidfile /var/run/redis.pid`                                 | 当 Redis 以守护进程方式运行时，Redis 默认会把 pid 写入 /var/run/redis.pid 文件，可以通过 pidfile 指定 |
| 3    | `port 6379`                                                  | 指定 Redis 监听端口，默认端口为 6379，作者在自己的一篇博文中解释了为什么选用 6379 作为默认端口，因为 6379 在手机按键上 MERZ 对应的号码，而 MERZ 取自意大利歌女 Alessia Merz 的名字 |
| 4    | `bind 127.0.0.1`                                             | 绑定的主机地址                                               |
| 5    | `timeout 300`                                                | 当客户端闲置多长秒后关闭连接，如果指定为 0 ，表示关闭该功能  |
| 6    | `loglevel notice`                                            | 指定日志记录级别，Redis 总共支持四个级别：debug、verbose、notice、warning，默认为 notice |
| 7    | `logfile stdout`                                             | 日志记录方式，默认为标准输出，如果配置 Redis 为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给 /dev/null |
| 8    | `databases 16`                                               | 设置数据库的数量，默认数据库为0，可以使用SELECT 命令在连接上指定数据库id |
| 9    | `save <seconds> <changes>` Redis 默认配置文件中提供了三个条件： **save 900 1** **save 300 10** **save 60 10000** 分别表示 900 秒（15 分钟）内有 1 个更改，300 秒（5 分钟）内有 10 个更改以及 60 秒内有 10000 个更改。 | 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合 |
| 10   | `rdbcompression yes`                                         | 指定存储至本地数据库时是否压缩数据，默认为 yes，Redis 采用 LZF 压缩，如果为了节省 CPU 时间，可以关闭该选项，但会导致数据库文件变的巨大 |
| 11   | `dbfilename dump.rdb`                                        | 指定本地数据库文件名，默认值为 dump.rdb                      |
| 12   | `dir ./`                                                     | 指定本地数据库存放目录                                       |
| 13   | `slaveof <masterip> <masterport>`                            | 设置当本机为 slave 服务时，设置 master 服务的 IP 地址及端口，在 Redis 启动时，它会自动从 master 进行数据同步 |
| 14   | `masterauth <master-password>`                               | 当 master 服务设置了密码保护时，slav 服务连接 master 的密码  |
| 15   | `requirepass foobared`                                       | 设置 Redis 连接密码，如果配置了连接密码，客户端在连接 Redis 时需要通过 AUTH <password> 命令提供密码，默认关闭 |
| 16   | ` maxclients 128`                                            | 设置同一时间最大客户端连接数，默认无限制，Redis 可以同时打开的客户端连接数为 Redis 进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis 会关闭新的连接并向客户端返回 max number of  clients reached 错误信息 |
| 17   | `maxmemory <bytes>`                                          | 指定 Redis 最大内存限制，Redis 在启动时会把数据加载到内存中，达到最大内存后，Redis 会先尝试清除已到期或即将到期的  Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis 新的 vm 机制，会把 Key  存放内存，Value 会存放在 swap 区 |
| 18   | `appendonly no`                                              | 指定是否在每次更新操作后进行日志记录，Redis 在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为  redis 本身同步数据文件是按上面 save 条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为 no |
| 19   | `appendfilename appendonly.aof`                              | 指定更新日志文件名，默认为 appendonly.aof                    |
| 20   | `appendfsync everysec`                                       | 指定更新日志条件，共有 3 个可选值：  **no**：表示等操作系统进行数据缓存同步到磁盘（快）  **always**：表示每次更新操作后手动调用 fsync() 将数据写到磁盘（慢，安全）  **everysec**：表示每秒同步一次（折中，默认值） |
| 21   | `vm-enabled no`                                              | 指定是否启用虚拟内存机制，默认值为 no，简单的介绍一下，VM 机制将数据分页存放，由 Redis 将访问量较少的页即冷数据 swap 到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析 Redis 的 VM 机制） |
| 22   | `vm-swap-file /tmp/redis.swap`                               | 虚拟内存文件路径，默认值为 /tmp/redis.swap，不可多个 Redis 实例共享 |
| 23   | `vm-max-memory 0`                                            | 将所有大于 vm-max-memory 的数据存入虚拟内存，无论 vm-max-memory  设置多小，所有索引数据都是内存存储的(Redis 的索引数据 就是 keys)，也就是说，当 vm-max-memory 设置为 0  的时候，其实是所有 value 都存在于磁盘。默认值为 0 |
| 24   | `vm-page-size 32`                                            | Redis swap 文件分成了很多的 page，一个对象可以保存在多个 page 上面，但一个 page  上不能被多个对象共享，vm-page-size 是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，page 大小最好设置为 32  或者 64bytes；如果存储很大大对象，则可以使用更大的 page，如果不确定，就使用默认值 |
| 25   | `vm-pages 134217728`                                         | 设置 swap 文件中的 page 数量，由于页表（一种表示页面空闲或使用的 bitmap）是在放在内存中的，，在磁盘上每 8 个 pages 将消耗 1byte 的内存。 |
| 26   | `vm-max-threads 4`                                           | 设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4 |
| 27   | `glueoutputbuf yes`                                          | 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启 |
| 28   | `hash-max-zipmap-entries 64 hash-max-zipmap-value 512`       | 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法 |
| 29   | `activerehashing yes`                                        | 指定是否激活重置哈希，默认为开启（后面在介绍 Redis 的哈希算法时具体介绍） |
| 30   | `include /path/to/local.conf`                                | 指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件 |

## 命令行客户端 redis-cli

默认值：127.0.0.1    6379

1. 交互方式

   ```bash
   redis-cli -h {host} -p {port}
   ```

2. 命令方式

   ```bash
   redis-cli -h {host} -p {port} {command}
   ```

### 基本命令

#### 命令返回值

命令的返回值有5种类型。

1. 状态回复

   最简单的一种回复。例如回复状态OK表示设置成功；PING命令的回复PONG。

2. 错误回复

   当出现命令不存在或命令格式有错误等情况时，会返回错误回复。以error开头，并在后面跟上错误信息。

3. 整数回复

   以 integer 开头，并在后面跟上整数数据。

4. 字符串回复

   以双引号包裹。特殊情况是当请求的键值不存在时会得到一个空结果，显示为（nil）。

5. 多行字符串回复

   每行字符串都以一个序号开头。

#### 获取符合规则的键名列表

```bash
KEYS pattern
#需要遍历所有键，当键数量多时会影响性能，不建议在生产环境中使用。
```

`pattern`支持glob风格通配符格式

| 符号 | 含义                                              |
| ---- | ------------------------------------------------- |
| ？   | 匹配一个字符                                      |
| *    | 匹配任意个（包括0个）字符                         |
| [ ]  | 匹配括号间的任一字符，可以使用“-”符号表示一个范围 |
| \x   | 匹配字符x，用于转义符号                           |

#### 判断一个键是否存在

```bash
EXISTS key
# 存在返回1，不存在返回 0
```

#### 删除键

```bash
DEL key [key ...]
# 返回删除的键的个数
# 不支持通配符

# 删除多个(例如删除以user：开头的键)
redis-cli KEYS "user:*" | xargs redis-cli DEL
redis-cli DEL `redis-cli KEYS "user:*"`
```

#### 获得键值的数据类型

```bash
TYPE key
# 返回值：string hash list set zset
```

#### 赋值与取值

```bash
SET key value
GET key
```

#### 整数增加

```bash
INCR key
# 每次加1，当要操作的键不存在时，默认键值为0；当键值不是整数时，会提示错误。
INCRBY key increment
# increment指定增加的数值
```

#### 整数减少

```bash
DECR key
DECRBY key decrement
# increment指定减少的数值
```

#### 浮点数增加

```bash
INCRBYFLOAT key increment
```

#### 向尾部追加值

```bash
APPEND key value
```

#### 获取字符串长度

```bash
STRLEN key
```

#### 同时获得/设置多个键值

```bash
MGET key1 [key2 ...]
MSET key1 value1 [key2 value2 ...]
```

#### 位操作

```bash
# 获得一个字符串类型键指定位置的二进制位的值
GETBIT key offset
# 设置字符串类型键指定位置的二进制的值，返回值是改外置的旧值。
SETBIT key offset value
# 获得字符串类型键中值是1的二进制位个数。
BITCOUNT key [start] [end]
# 对多个字符串类型键进行位操作，结果存储在destkey指定的键中。
# operation: AND OR XOR NOT
BITOP operation destkey key [key ...]
# 获得指定键的第一个位值是0或者1的位置。可指定范围，以字节为单位。偏移量是从头开始算起。
BITPOS key bit_value [byte_start] [byte_end]
```



#### PING	

测试客户端与服务器的连接是否正常。

#### SAVE	

同步地执行快照操作。在执行过程中会阻塞所有来自客户端的请求。尽量避免在生产环境中使用。

#### BGSAVE

异步地进行快照操作。快照的同时还可以继续相应来自客户端的请求。通过LASTSAVE命令获取最近一次成功执行快照的时间，返回结果Unix时间戳。

## 数据类型

支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

### String（字符串）

最基本的数据类型，一个键对应一个值，二进制安全的，可以包含任何数据。比如jpg图片或者序列化的对象。

值最大能存储 512MB。

```bash
redis 127.0.0.1:6379> SET runa "hello"
OK
redis 127.0.0.1:6379> GET runa
"hello"
redis 127.0.0.1:6379> DEL runa
```

### Hash（哈希）

hash 是一个键值(key=>value)对集合。是一个 string 类型的 field 和 value 的映射表，不支持其他数据类型。hash 特别适合用于存储对象。

使用 Redis **HMSET, HGET** 命令，**HMSET** 设置了两个 field=>value 对, HGET 获取对应 **field** 对应的 **value**。

每个 hash 可以存储 2^32 -1 键值对（40多亿）。

```bash
# 给字段赋值。不区分插入和更新操作，修改数据时不用事先判断字段是否存在。当执行插入操作是，返回1；执行更新操作时，返回0。当键本身不存在时，自动创建。
HSET key field value
# 获取字段的值。
HGET key field
# 同时设置多个字段的值。
HMSET key field1 value1 [field2 value2 ...]
# 同时获取多个字段的值。
HMGET key filed1 [field2 ...]
# 查看所有键值
HGETALL key
# 判断一个字段是否存在。存在 - 1，不存在 - 0。
HEXISTS key field
# 当字段不存在时赋值。
HSETNX key field value
# 增加数字。返回值是增值后的字段值。
HINCRBY key field increment
# 删除字段。返回值是被删除的字段个数。
HDEL key field1 [field2 ...]
# 只获取字段名
HKEYS key
# 只获取字段值
HVALS key
# 获得字段数量
HLEN key

##################################################

redis 127.0.0.1:6379> HMSET runa field1 "Hello" field2 "World"
"OK"
redis 127.0.0.1:6379> HGET runa field1
"Hello"
redis 127.0.0.1:6379> HGET runa field2
"World"
```

### List（列表）

列表是简单的字符串列表，按照插入顺序排序。可以添加一个元素到列表的头部（左边）或者尾部（右边）。列表内部是使用双向链表实现的。向列表两端添加元素的时间复杂度为O，获取越接近两端的元素速度越快。

列表最多可存储  2^32 - 1 元素 (4294967295, 每个列表可存储40多亿)。

```bash
# 向列表两端增加元素。返回值表示增加元素后列表的长度。
LPUSH key value1 [value2 ...]
RPUSH key value1 [value2 ...]
# 从列表两端弹出元素
LPOP key
RPOP key
# 获取列表中元素的个数。当键不存在时，返回0。
LLEN key
# 获取列表片段。返回值包含最右边的元素。
# 获取所有值 LRANGE key 0 -1
LRANGE key start stop
# 删除列表中指定的值。删除列表中前count个值为value的元素。返回值是实际删除的元素个数。
# count > 0 ,从列表左边开始删除前count个值为value的元素。
# count < 0 ,从列表右边开始删除前 | count | 个值为value的元素。
# count = 0 ,删除所有值为value的元素。
LREM key count value
# 获得/设置指定索引的元素值
LINDEX key index
LSET key index value
# 只保留列表指定片段
LTRIM key start end
# 向列表中插入元素。返回值是插入后列表的元素个数。
LINSERT key BEFORE|AFTER pivot value
# 将元素从一个列表转到另一个列表
RPOPLPUSH source destination

##################################################

redis 127.0.0.1:6379> lpush runa redis
(integer) 1
redis 127.0.0.1:6379> lpush runa mongodb
(integer) 2
redis 127.0.0.1:6379> lpush runa rabbitmq
(integer) 3
redis 127.0.0.1:6379> lrange runa 0 10
1) "rabbitmq"
2) "mongodb"
3) "redis"
redis 127.0.0.1:6379>
```

### Set（集合）

Set 是 string 类型的无序集合，不可重复。

集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 0。

#### sadd 命令

 添加一个 string 元素到 key 对应的 set 集合中，成功返回 1，如果元素已经在集合中返回 0。

```bash
sadd key member
```



```bash
redis 127.0.0.1:6379> sadd runa redis
(integer) 1
redis 127.0.0.1:6379> sadd runa mongodb
(integer) 1
redis 127.0.0.1:6379> sadd runa rabbitmq
(integer) 1
redis 127.0.0.1:6379> sadd runa rabbitmq
(integer) 0
redis 127.0.0.1:6379> smembers runa

1) "redis"
2) "rabbitmq"
3) "mongodb"
```

**注意：**以上实例中 rabbitmq 添加了两次，但根据集合内元素的唯一性，第二次插入的元素将被忽略。

集合中最大的成员数为  2^32  - 1(4294967295, 每个集合可存储40多亿个成员)。

### zset(sorted set：有序集合)

Redis  zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。

不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序，如果多个元素有相同的分数，则以字典序进行升序排序，sorted set因此非常适合实现排名。

zset的成员是唯一的,但分数(score)却可以重复。

#### zadd 命令

添加元素到集合，元素在集合中存在则更新对应score

```bash
zadd key score member 
```

```bash
redis 127.0.0.1:6379> zadd runa 0 redis
(integer) 1
redis 127.0.0.1:6379> zadd runa 0 mongodb
(integer) 1
redis 127.0.0.1:6379> zadd runa 0 rabbitmq
(integer) 1
redis 127.0.0.1:6379> zadd runa 0 rabbitmq
(integer) 0
redis 127.0.0.1:6379> ZRANGEBYSCORE runa 0 1000
1) "mongodb"
2) "rabbitmq"
3) "redis"
```

### 各个数据类型应用场景

| 类型       | 简介                                                   | 特性                                                         | 场景                                                         |
| ---------- | ------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| String     | 二进制安全                                             | 可以包含任何数据,比如jpg图片或者序列化的对象,一个键最大能存储512M | ---                                                          |
| Hash       | 键值对集合,即编程语言中的Map类型                       | 适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值(Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去) | 存储、读取、修改用户属性                                     |
| List       | 链表(双向链表)                                         | 增删快,提供了操作某一段元素的API                             | 1,最新消息排行等功能(比如朋友圈的时间线) 2,消息队列，日志    |
| Set        | 哈希表实现,元素不重复                                  | 1、添加、删除,查找的复杂度都是O 2、为集合提供了求交集、并集、差集等操作 | 1、共同好友 2、利用唯一性,统计访问网站的所有独立ip 3、好友推荐时,根据tag求交集,大于某个阈值就可以推荐 |
| Sorted Set | 将Set中的元素增加一个权重参数score,元素按score有序排列 | 数据插入集合时,已经进行天然排序                              | 1、排行榜 2、带权重的消息队列                                |

## 数据库

Redis支持多个数据库，并且每个数据库的数据是隔离的不能共享，基于单机才有，集群没有数据库的概念。

Redis是一个字典结构的存储服务器，一个Redis实例提供了多个用来存储数据的字典，客户端可以指定将数据存储在哪个字典中。

每个数据库对外都是一个从0开始的递增数字命名，Redis默认支持16个数据库（可以通过配置文件支持更多，无上限），可以通过配置databases来修改这一数字。客户端与Redis建立连接后会自动选择0号数据库，可以随时使用SELECT命令更换数据库，如要选择1号数据库：

   ```bash
redis> SELECT 1
OK
redis [1] > GET foo
(nil)
   ```

Redis不支持自定义数据库的名字，每个数据库都以编号命名。

Redis不支持为每个数据库设置不同的访问密码，所以一个客户端要么可以访问全部数据库，要么连一个数据库也没有权限访问。

多个数据库之间并不是完全隔离的，比如`FLUSHALL`命令可以清空一个Redis实例中所有数据库中的数据。

这些数据库更像是一种命名空间，而不适宜存储不同应用程序的数据。比如可以使用0号数据库存储某个应用生产环境中的数据，使用1号数据库存储测试环境中的数据，但不适宜使用0号数据库存储A应用的数据而使用1号数据库B应用的数据，不同的应用应该使用不同的Redis实例存储数据。由于Redis非常轻量级，一个空Redis实例占用的内在只有1M左右，不用担心多个Redis实例会额外占用很多内存。

## 发布与订阅

redis的发布与订阅（发布/订阅）是它的一种消息通信模式，发送者 (pub) 发送消息，订阅者 (sub) 接收消息。

Redis 客户端可以订阅任意数量的频道。

三个客户端同时订阅同一个频道：
![img](../../../Image/r/e/订阅1.jpg)

有新信息发送给频道1时，就会将消息发送给订阅它的三个客户端:
![img](../../../Image/r/e/订阅2.jpg)

### 命令

```bash
PSUBSCRIBE pattern [pattern ...]                   #订阅一个或多个符合给定模式的频道。
PUBSUB subcommand [argument [argument ...]]        #查看订阅与发布系统状态。
PUBLISH channel message                            #将信息发送到指定的频道。
PUNSUBSCRIBE [pattern [pattern ...]]               #退订所有给定模式的频道。
SUBSCRIBE channel [channel ...]                    #订阅给定的一个或多个频道的信息。
UNSUBSCRIBE [channel [channel ...]]                #指退订给定的频道。
```

### 实例

以下实例演示了发布订阅，需要开启两个 redis-cli 客户端。

在实例中创建了订阅频道名为 **rChat**:

**第一个 redis-cli 客户端**

```bash
redis 127.0.0.1:6379> SUBSCRIBE rChat

Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redisChat"
3) (integer) 1
```

**第二个 redis-cli 客户端**

```bash
redis 127.0.0.1:6379> PUBLISH rChat "Redis PUBLISH test"
(integer) 1

redis 127.0.0.1:6379> PUBLISH rChat "Learn redis by rb.com"
(integer) 1
```

## 持久化

2种持久化方式：**快照（RDB）**，**仅附加文件（AOF）**。

### 快照 RDB

根据指定的规则“定时”将内存中的数据以快照的方式写入二进制文件中，如默认dump.rdb中。

对数据进行快照的情况：

1. 根据配置规则进行自动快照。

   在配置文件内自定义快照条件，符合条件时，自动执行快照操作。由两个参数构成：时间窗口M和改动的键的个数N。例如，`save  900  1`
   可以有多行，之间是“或”的关系。

2. 用户执行 SAVE 或 BGSAVE 命令。

3. 执行 FLUSHALL 命令。

   只要自动快照条件不为空，就会执行一次快照操作。

4. 执行复制（replication）时。

   即使没有定义自动快照条件，并且没有手动执行过快照操作，也会生成RDB快照文件。

### 仅附加文件 AOF

在每次执行写命令后将命令本身记录下来（appendonly.aof）。对性能有影响，默认不开启。

```bash
appendonly yes  
#开启AOF持久化存储方式 
appendfsync always 
#收到写命令后就立即写入磁盘，效率最差，效果最好
appendfsync everysec
#每秒写入磁盘一次，效率与效果居中
appendfsync no 
#完全依赖操作系统，效率最佳，效果没法保证
```

### 备份

Redis **SAVE** 命令用于创建当前数据库的备份。

```bash
redis 127.0.0.1:6379> SAVE 
```

该命令将在 redis 安装目录中创建dump.rdb文件。

创建 redis 备份文件也可以使用命令 **BGSAVE**，该命令在后台执行。

```bash
127.0.0.1:6379> BGSAVE
Background saving started
```

### 恢复

要恢复数据，需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。获取 redis 目录可以使用 **CONFIG** 命令，如下所示：

```
redis 127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/usr/local/redis/bin"
```

以上命令 **CONFIG GET dir** 输出的 redis 安装目录为 /usr/local/redis/bin。


## 集群

### 复制

一个master，一个或多个slave 。slave 一般为只读。

```bash
示例：
一台master,两台slave，在同一主机上演示，采用不同端口号。
#Master 6379
redis-server

#Slave 6380 + 6381
redis-server --port 6380 --slaveof 127.0.0.1 6379
redis-server --port 6381 --slaveof 127.0.0.1 6379

#确认
redis-cli -p 63xx
redis x> INFO replication
```

命令：

SLAVEOF

SLAVEOF  NO  ONE	使当前数据库停止接收其他数据库的同步，并转换为主数据库。

### 哨兵

配置文件sentinel.conf

```bash
sentinel monitor mymaster 127.0.0.1 6379 1
#mymaster	要监控的主数据库名字，仅由大小写字母、数字和“. - _”三个字符组成。
#127.0.0.1 6379	主数据库的IP和端口号
#1	quorum,最低通过票数,执行故障恢复操作前，至少需要几个哨兵节点同意。
```

启动哨兵

```bash
redis-sentinel	/path/to/sentinel.conf
```
## 安全

通过 redis 的配置文件设置密码参数，这样客户端连接到 redis 服务就需要密码验证，让 redis 服务更安全。

查看是否设置了密码验证：

```bash
127.0.0.1:6379> CONFIG get requirepass
1) "requirepass"
2) ""
```

默认情况下 requirepass 参数是空的，这就意味着无需通过密码验证就可以连接到 redis 服务。

通过以下命令来修改该参数：

```bash
127.0.0.1:6379> CONFIG set requirepass "rb"
OK
127.0.0.1:6379> CONFIG get requirepass
1) "requirepass"
2) "rb"
```

设置密码后，客户端连接 redis 服务就需要密码验证，否则无法执行命令。

### 语法

**AUTH** 命令基本语法格式如下：

```bash
127.0.0.1:6379> AUTH password
```

### 实例

```bash
127.0.0.1:6379> AUTH "runoob"
OK
```



**redis的性能测试**

自带相关测试工具

![img](https://img-blog.csdnimg.cn/20181224163405438)

实际测试同时执行100万的请求

![img](https://img-blog.csdnimg.cn/20181224163405456)





问题
(一)缓存和数据库双写一致性问题
(二)缓存雪崩问题
(三)缓存击穿问题
(四)缓存的并发竞争问题

## 问题

**1.单线程的redis快，原因？**

主要是以下几点

1. 纯内存操作
2. 单线程操作，避免了频繁的上下文切换
3. 采用了非阻塞I/O多路复用机制
4. C语言实现



redis的数据类型，以及每种数据类型的使用场景

分析：是不是觉得这个问题很基础，其实我也这么觉得。然而根据面试经验发现，至少百分八十的人答不上这个问题。建议，在项目中用到后，再类比记忆，体会更深，不要硬记。基本上，一个合格的程序员，五种类型都会用到。
回答：一共五种



(一)String
这个其实没啥好说的，最常规的set/get操作，value可以是String也可以是数字。一般做一些复杂的计数功能的缓存。

(二)hash
这里value存放的是结构化的对象，比较方便的就是操作其中的某个字段。博主在做单点登录的时候，就是用这种数据结构存储用户信息，以cookieId作为key，设置30分钟为缓存过期时间，能很好的模拟出类似session的效果。

(三)list
使用List的数据结构，可以做简单的消息队列的功能。另外还有一个就是，可以利用lrange命令，做基于redis的分页功能，性能极佳，用户体验好。

(四)set
因为set堆放的是一堆不重复值的集合。所以可以做全局去重的功能。为什么不用JVM自带的Set进行去重？因为我们的系统一般都是集群部署，使用JVM自带的Set，比较麻烦，难道为了一个做一个全局去重，再起一个公共服务，太麻烦了。
另外，就是利用交集、并集、差集等操作，可以计算共同喜好，全部的喜好，自己独有的喜好等功能。

(五)sorted set

sorted set多了一个权重参数score,集合中的元素能够按score进行排列。可以做排行榜应用，取TOP N操作。另外，参照另一篇《分布式之延时任务方案解析》，该文指出了sorted set可以用来做延时任务。最后一个应用就是可以做范围查找。

###  

### 5、redis的过期策略以及内存淘汰机制

分析:这个问题其实相当重要，到底redis有没用到家，这个问题就可以看出来。比如你redis只能存5G数据，可是你写了10G，那会删5G的数据。怎么删的，这个问题思考过么？还有，你的数据已经设置了过期时间，但是时间到了，内存占用率还是比较高，有思考过原因么?
回答:
redis采用的是定期删除+惰性删除策略。
为什么不用定时删除策略?
定时删除,用一个定时器来负责监视key,过期则自动删除。虽然内存及时释放，但是十分消耗CPU资源。在大并发请求下，CPU要将时间应用在处理请求，而不是删除key,因此没有采用这一策略.
定期删除+惰性删除是如何工作的呢?
定期删除，redis默认每个100ms检查，是否有过期的key,有过期key则删除。需要说明的是，redis不是每个100ms将所有的key检查一次，而是随机抽取进行检查(如果每隔100ms,全部key进行检查，redis岂不是卡死)。因此，如果只采用定期删除策略，会导致很多key到时间没有删除。
于是，惰性删除派上用场。也就是说在你获取某个key的时候，redis会检查一下，这个key如果设置了过期时间那么是否过期了？如果过期了此时就会删除。
采用定期删除+惰性删除就没其他问题了么?
不是的，如果定期删除没删除key。然后你也没即时去请求key，也就是说惰性删除也没生效。这样，redis的内存会越来越高。那么就应该采用内存淘汰机制。
在redis.conf中有一行配置

```
# maxmemory-policy volatile-lru
```

该配置就是配内存淘汰策略的(什么，你没配过？好好反省一下自己)
1）noeviction：当内存不足以容纳新写入数据时，新写入操作会报错。应该没人用吧。
2）allkeys-lru：当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的key。推荐使用，目前项目在用这种。
3）allkeys-random：当内存不足以容纳新写入数据时，在键空间中，随机移除某个key。应该也没人用吧，你不删最少使用Key,去随机删。
4）volatile-lru：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的key。这种情况一般是把redis既当缓存，又做持久化存储的时候才用。不推荐
5）volatile-random：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，随机移除某个key。依然不推荐
6）volatile-ttl：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的key优先移除。不推荐
ps：如果没有设置 expire 的key, 不满足先决条件(prerequisites); 那么 volatile-lru, volatile-random 和 volatile-ttl 策略的行为, 和 noeviction(不删除) 基本上一致。

###  

### 6、redis和数据库双写一致性问题

分析:一致性问题是分布式常见问题，还可以再分为最终一致性和强一致性。数据库和缓存双写，就必然会存在不一致的问题。答这个问题，先明白一个前提。就是如果对数据有强一致性要求，不能放缓存。我们所做的一切，只能保证最终一致性。另外，我们所做的方案其实从根本上来说，只能说降低不一致发生的概率，无法完全避免。因此，有强一致性要求的数据，不能放缓存。
回答:《分布式之数据库和缓存双写一致性方案解析》给出了详细的分析，在这里简单的说一说。首先，采取正确更新策略，先更新数据库，再删缓存。其次，因为可能存在删除缓存失败的问题，提供一个补偿措施即可，例如利用消息队列。

###  

### 7、如何应对缓存穿透和缓存雪崩问题

分析:这两个问题，说句实在话，一般中小型传统软件企业，很难碰到这个问题。如果有大并发的项目，流量有几百万左右。这两个问题一定要深刻考虑。
回答:如下所示



缓存穿透，即黑客故意去请求缓存中不存在的数据，导致所有的请求都怼到数据库上，从而数据库连接异常。



解决方案:
(一)利用互斥锁，缓存失效的时候，先去获得锁，得到锁了，再去请求数据库。没得到锁，则休眠一段时间重试
(二)采用异步更新策略，无论key是否取到值，都直接返回。value值中维护一个缓存失效时间，缓存如果过期，异步起一个线程去读数据库，更新缓存。需要做缓存预热(项目启动前，先加载缓存)操作。
(三)提供一个能迅速判断请求是否有效的拦截机制，比如，利用布隆过滤器，内部维护一系列合法有效的key。迅速判断出，请求所携带的Key是否合法有效。如果不合法，则直接返回。



缓存雪崩，即缓存同一时间大面积的失效，这个时候又来了一波请求，结果请求都怼到数据库上，从而导致数据库连接异常。



解决方案:
(一)给缓存的失效时间，加上一个随机值，避免集体失效。
(二)使用互斥锁，但是该方案吞吐量明显下降了。
(三)双缓存。我们有两个缓存，缓存A和缓存B。缓存A的失效时间为20分钟，缓存B不设失效时间。自己做缓存预热操作。然后细分以下几个小点

- I 从缓存A读数据库，有则直接返回
- II A没有数据，直接从B读数据，直接返回，并且异步启动一个更新线程。
- III 更新线程同时更新缓存A和缓存B。

###  

### 8、如何解决redis的并发竞争key问题

分析:这个问题大致就是，同时有多个子系统去set一个key。这个时候要注意什么呢？大家思考过么。需要说明一下，博主提前百度了一下，发现答案基本都是推荐用redis事务机制。博主不推荐使用redis的事务机制。因为我们的生产环境，基本都是redis集群环境，做了数据分片操作。你一个事务中有涉及到多个key操作的时候，这多个key不一定都存储在同一个redis-server上。因此，redis的事务机制，十分鸡肋。



回答:如下所示
(1)如果对这个key操作，不要求顺序
这种情况下，准备一个分布式锁，大家去抢锁，抢到锁就做set操作即可，比较简单。
(2)如果对这个key操作，要求顺序
假设有一个key1,系统A需要将key1设置为valueA,系统B需要将key1设置为valueB,系统C需要将key1设置为valueC.
期望按照key1的value值按照 valueA-->valueB-->valueC的顺序变化。这种时候我们在数据写入数据库的时候，需要保存一个时间戳。假设时间戳如下

```
系统A key 1 {valueA  3:00}系统B key 1 {valueB  3:05}系统C key 1 {valueC  3:10}
```

那么，假设这会系统B先抢到锁，将key1设置为{valueB 3:05}。接下来系统A抢到锁，发现自己的valueA的时间戳早于缓存中的时间戳，那就不做set操作了。以此类推。

其他方法，比如利用队列，将set方法变成串行访问也可以。总之，灵活变通。

## 历史

* 2008 年，意大利公司 Merzia 推出基于 MySQL 的网站实时统计系统 LLOOGG ，创始人 Salvatore Sanfilippo 开始对 MySQL 的性能不满意，于 2009 年实现一新的数据库。
* 2009 年，Redis 开源，开发者 Salvatore Sanfilippo 和 Pieter Noordhuis 。
* 2010 年，VMware 公司开始赞助开发。
* 2015 年，发布 3.0.0 版本。

## Redis 命令

LPUSH 向指定的列表类型键中增加一个元素，如果键不存在则创建它。

## 在远程服务上执行命令

如果需要在远程 redis 服务上执行命令，同样我们使用的也是 **redis-cli** 命令。

### 语法

```
$ redis-cli -h host -p port -a password
```

### 实例

以下实例演示了如何连接到主机为 127.0.0.1，端口为 6379 ，密码为 mypass 的 redis 服务上。

```
$redis-cli -h 127.0.0.1 -p 6379 -a "mypass"
redis 127.0.0.1:6379>
redis 127.0.0.1:6379> PING

PONG
```

1. 

   有时候会有中文乱码。

   要在 redis-cli 后面加上 --raw

   ```
   redis-cli --raw
   ```

   就可以避免中文乱码了。


# Redis 键(key)

Redis 键命令用于管理 redis 的键。

### 语法

 Redis 键命令的基本语法如下：

```
redis 127.0.0.1:6379> COMMAND KEY_NAME
```

### 实例

```
redis 127.0.0.1:6379> SET runoobkey redis
OK
redis 127.0.0.1:6379> DEL runoobkey
(integer) 1
```

在以上实例中 **DEL** 是一个命令， **runoobkey** 是一个键。 如果键被删除成功，命令执行后输出 **(integer) 1**，否则将输出 **(integer) 0**

------

## Redis keys 命令

下表给出了与 Redis 键相关的基本命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [DEL key](https://www.runoob.com/redis/keys-del.html) 该命令用于在 key 存在时删除  key。 |
| 2    | [DUMP key](https://www.runoob.com/redis/keys-dump.html)  序列化给定 key ，并返回被序列化的值。 |
| 3    | [EXISTS key](https://www.runoob.com/redis/keys-exists.html)  检查给定 key 是否存在。 |
| 4    | [EXPIRE key](https://www.runoob.com/redis/keys-expire.html) seconds 为给定 key 设置过期时间，以秒计。 |
| 5    | [EXPIREAT key timestamp](https://www.runoob.com/redis/keys-expireat.html)  EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)。 |
| 6    | [PEXPIRE key milliseconds](https://www.runoob.com/redis/keys-pexpire.html)  设置 key 的过期时间以毫秒计。 |
| 7    | [PEXPIREAT key milliseconds-timestamp](https://www.runoob.com/redis/keys-pexpireat.html)  设置 key 过期时间的时间戳(unix timestamp) 以毫秒计 |
| 8    | [KEYS pattern](https://www.runoob.com/redis/keys-keys.html)  查找所有符合给定模式( pattern)的 key 。 |
| 9    | [MOVE key db](https://www.runoob.com/redis/keys-move.html)  将当前数据库的 key 移动到给定的数据库 db 当中。 |
| 10   | [PERSIST key](https://www.runoob.com/redis/keys-persist.html)  移除 key 的过期时间，key 将持久保持。 |
| 11   | [PTTL key](https://www.runoob.com/redis/keys-pttl.html)  以毫秒为单位返回 key 的剩余的过期时间。 |
| 12   | [TTL key](https://www.runoob.com/redis/keys-ttl.html)  以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。 |
| 13   | [RANDOMKEY](https://www.runoob.com/redis/keys-randomkey.html)  从当前数据库中随机返回一个 key 。 |
| 14   | [RENAME key newkey](https://www.runoob.com/redis/keys-rename.html)  修改 key 的名称 |
| 15   | [RENAMENX key newkey](https://www.runoob.com/redis/keys-renamenx.html)  仅当 newkey 不存在时，将 key 改名为 newkey 。 |
| 16   | [SCAN cursor [MATCH pattern\] [COUNT count]](https://www.runoob.com/redis/keys-scan.html)  迭代数据库中的数据库键。 |
| 17   | [TYPE key](https://www.runoob.com/redis/keys-type.html)  返回 key 所储存的值的类型。 |

更多命令请参考：https://redis.io/commands

# Redis 字符串(String)

Redis 字符串数据类型的相关命令用于管理 redis 字符串值，基本语法如下：

### 语法

```
redis 127.0.0.1:6379> COMMAND KEY_NAME
```

### 实例

```
redis 127.0.0.1:6379> SET runoobkey redis
OK
redis 127.0.0.1:6379> GET runoobkey
"redis"
```

在以上实例中我们使用了 **SET** 和 **GET** 命令，键为 **runoobkey**。

------

## Redis 字符串命令

下表列出了常用的 redis 字符串命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [SET key value](https://www.runoob.com/redis/strings-set.html)  设置指定 key 的值 |
| 2    | [GET key](https://www.runoob.com/redis/strings-get.html)  获取指定 key 的值。 |
| 3    | [GETRANGE key start end](https://www.runoob.com/redis/strings-getrange.html)  返回 key 中字符串值的子字符 |
| 4    | [GETSET key value](https://www.runoob.com/redis/strings-getset.html) 将给定 key 的值设为 value ，并返回 key 的旧值(old value)。 |
| 5    | [GETBIT key offset](https://www.runoob.com/redis/strings-getbit.html) 对 key 所储存的字符串值，获取指定偏移量上的位(bit)。 |
| 6    | [MGET key1 [key2..\]](https://www.runoob.com/redis/strings-mget.html) 获取所有(一个或多个)给定 key 的值。 |
| 7    | [SETBIT key offset value](https://www.runoob.com/redis/strings-setbit.html) 对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)。 |
| 8    | [SETEX key seconds value](https://www.runoob.com/redis/strings-setex.html) 将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位)。 |
| 9    | [SETNX key value](https://www.runoob.com/redis/strings-setnx.html) 只有在 key 不存在时设置 key 的值。 |
| 10   | [SETRANGE key offset value](https://www.runoob.com/redis/strings-setrange.html) 用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。 |
| 11   | [STRLEN key](https://www.runoob.com/redis/strings-strlen.html) 返回 key 所储存的字符串值的长度。 |
| 12   | [MSET key value [key value ...\]](https://www.runoob.com/redis/strings-mset.html) 同时设置一个或多个 key-value 对。 |
| 13   | [MSETNX key value [key value ...\]](https://www.runoob.com/redis/strings-msetnx.html)  同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。 |
| 14   | [PSETEX key milliseconds value](https://www.runoob.com/redis/strings-psetex.html) 这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位。 |
| 15   | [INCR key](https://www.runoob.com/redis/strings-incr.html) 将 key 中储存的数字值增一。 |
| 16   | [INCRBY key increment](https://www.runoob.com/redis/strings-incrby.html) 将 key 所储存的值加上给定的增量值（increment） 。 |
| 17   | [INCRBYFLOAT key increment](https://www.runoob.com/redis/strings-incrbyfloat.html) 将 key 所储存的值加上给定的浮点增量值（increment） 。 |
| 18   | [DECR key](https://www.runoob.com/redis/strings-decr.html) 将 key 中储存的数字值减一。 |
| 19   | [DECRBY key decrement](https://www.runoob.com/redis/strings-decrby.html)  key 所储存的值减去给定的减量值（decrement） 。 |
| 20   | [APPEND key value](https://www.runoob.com/redis/strings-append.html) 如果 key 已经存在并且是一个字符串， APPEND 命令将指定的 value 追加到该 key 原来值（value）的末尾。 |

更多命令请参考：https://redis.io/commands

# Redis 哈希(Hash)

Redis hash 是一个 string 类型的 field（字段） 和 value（值） 的映射表，hash 特别适合用于存储对象。

Redis 中每个 hash 可以存储 232 - 1 键值对（40多亿）。

### 实例

```
127.0.0.1:6379>  HMSET runoobkey name "redis tutorial" description "redis basic commands for caching" likes 20 visitors 23000
OK
127.0.0.1:6379>  HGETALL runoobkey
1) "name"
2) "redis tutorial"
3) "description"
4) "redis basic commands for caching"
5) "likes"
6) "20"
7) "visitors"
8) "23000"
```

在以上实例中，我们设置了 redis 的一些描述信息(name, description, likes, visitors) 到哈希表的 **runoobkey** 中。

------

## Redis hash 命令

下表列出了 redis hash 基本的相关命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [HDEL key field1 [field2\]](https://www.runoob.com/redis/hashes-hdel.html)  删除一个或多个哈希表字段 |
| 2    | [HEXISTS key field](https://www.runoob.com/redis/hashes-hexists.html)  查看哈希表 key 中，指定的字段是否存在。 |
| 3    | [HGET key field](https://www.runoob.com/redis/hashes-hget.html)  获取存储在哈希表中指定字段的值。 |
| 4    | [HGETALL key](https://www.runoob.com/redis/hashes-hgetall.html)  获取在哈希表中指定 key 的所有字段和值 |
| 5    | [HINCRBY key field increment](https://www.runoob.com/redis/hashes-hincrby.html)  为哈希表 key 中的指定字段的整数值加上增量 increment 。 |
| 6    | [HINCRBYFLOAT key field increment](https://www.runoob.com/redis/hashes-hincrbyfloat.html)  为哈希表 key 中的指定字段的浮点数值加上增量 increment 。 |
| 7    | [HKEYS key](https://www.runoob.com/redis/hashes-hkeys.html)  获取所有哈希表中的字段 |
| 8    | [HLEN key](https://www.runoob.com/redis/hashes-hlen.html)  获取哈希表中字段的数量 |
| 9    | [HMGET key field1 [field2\]](https://www.runoob.com/redis/hashes-hmget.html)  获取所有给定字段的值 |
| 10   | [HMSET key field1 value1 [field2 value2 \]](https://www.runoob.com/redis/hashes-hmset.html)  同时将多个 field-value (域-值)对设置到哈希表 key 中。 |
| 11   | [HSET key field value](https://www.runoob.com/redis/hashes-hset.html)  将哈希表 key 中的字段 field 的值设为 value 。 |
| 12   | [HSETNX key field value](https://www.runoob.com/redis/hashes-hsetnx.html)  只有在字段 field 不存在时，设置哈希表字段的值。 |
| 13   | [HVALS key](https://www.runoob.com/redis/hashes-hvals.html)  获取哈希表中所有值。 |
| 14   | [HSCAN key cursor [MATCH pattern\] [COUNT count]](https://www.runoob.com/redis/hashes-hscan.html)  迭代哈希表中的键值对。 |

更多命令请参考：https://redis.io/commands

# Redis 列表(List)

Redis列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）

一个列表最多可以包含 232 - 1 个元素 (4294967295, 每个列表超过40亿个元素)。

### 实例

```
redis 127.0.0.1:6379> LPUSH runoobkey redis
(integer) 1
redis 127.0.0.1:6379> LPUSH runoobkey mongodb
(integer) 2
redis 127.0.0.1:6379> LPUSH runoobkey mysql
(integer) 3
redis 127.0.0.1:6379> LRANGE runoobkey 0 10

1) "mysql"
2) "mongodb"
3) "redis"
```

在以上实例中我们使用了 **LPUSH** 将三个值插入了名为 **runoobkey** 的列表当中。

### Redis 列表命令

下表列出了列表相关的基本命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [BLPOP key1 [key2 \] timeout](https://www.runoob.com/redis/lists-blpop.html)  移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 2    | [BRPOP key1 [key2 \] timeout](https://www.runoob.com/redis/lists-brpop.html)  移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 3    | [BRPOPLPUSH source destination timeout](https://www.runoob.com/redis/lists-brpoplpush.html)  从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 4    | [LINDEX key index](https://www.runoob.com/redis/lists-lindex.html)  通过索引获取列表中的元素 |
| 5    | [LINSERT key BEFORE\|AFTER pivot value](https://www.runoob.com/redis/lists-linsert.html)  在列表的元素前或者后插入元素 |
| 6    | [LLEN key](https://www.runoob.com/redis/lists-llen.html)  获取列表长度 |
| 7    | [LPOP key](https://www.runoob.com/redis/lists-lpop.html)  移出并获取列表的第一个元素 |
| 8    | [LPUSH key value1 [value2\]](https://www.runoob.com/redis/lists-lpush.html)  将一个或多个值插入到列表头部 |
| 9    | [LPUSHX key value](https://www.runoob.com/redis/lists-lpushx.html)  将一个值插入到已存在的列表头部 |
| 10   | [LRANGE key start stop](https://www.runoob.com/redis/lists-lrange.html)  获取列表指定范围内的元素 |
| 11   | [LREM key count value](https://www.runoob.com/redis/lists-lrem.html)  移除列表元素 |
| 12   | [LSET key index value](https://www.runoob.com/redis/lists-lset.html)  通过索引设置列表元素的值 |
| 13   | [LTRIM key start stop](https://www.runoob.com/redis/lists-ltrim.html)  对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。 |
| 14   | [RPOP key](https://www.runoob.com/redis/lists-rpop.html)  移除列表的最后一个元素，返回值为移除的元素。 |
| 15   | [RPOPLPUSH source destination](https://www.runoob.com/redis/lists-rpoplpush.html)  移除列表的最后一个元素，并将该元素添加到另一个列表并返回 |
| 16   | [RPUSH key value1 [value2\]](https://www.runoob.com/redis/lists-rpush.html)  在列表中添加一个或多个值 |
| 17   | [RPUSHX key value](https://www.runoob.com/redis/lists-rpushx.html)  为已存在的列表添加值 |

​			

# Redis 集合(Set)

Redis 的 Set 是 String 类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据。

Redis 中集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。

 集合中最大的成员数为 232  - 1 (4294967295, 每个集合可存储40多亿个成员)。 

### 实例

```
redis 127.0.0.1:6379> SADD runoobkey redis
(integer) 1
redis 127.0.0.1:6379> SADD runoobkey mongodb
(integer) 1
redis 127.0.0.1:6379> SADD runoobkey mysql
(integer) 1
redis 127.0.0.1:6379> SADD runoobkey mysql
(integer) 0
redis 127.0.0.1:6379> SMEMBERS runoobkey

1) "mysql"
2) "mongodb"
3) "redis"
```

在以上实例中我们通过 **SADD** 命令向名为 **runoobkey** 的集合插入的三个元素。

------

## Redis 集合命令

下表列出了 Redis 集合基本命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [SADD key member1 [member2\]](https://www.runoob.com/redis/sets-sadd.html)  向集合添加一个或多个成员 |
| 2    | [SCARD key](https://www.runoob.com/redis/sets-scard.html)  获取集合的成员数 |
| 3    | [SDIFF key1 [key2\]](https://www.runoob.com/redis/sets-sdiff.html)  返回第一个集合与其他集合之间的差异。 |
| 4    | [SDIFFSTORE destination key1 [key2\]](https://www.runoob.com/redis/sets-sdiffstore.html)  返回给定所有集合的差集并存储在 destination 中 |
| 5    | [SINTER key1 [key2\]](https://www.runoob.com/redis/sets-sinter.html)  返回给定所有集合的交集 |
| 6    | [SINTERSTORE destination key1 [key2\]](https://www.runoob.com/redis/sets-sinterstore.html)  返回给定所有集合的交集并存储在 destination 中 |
| 7    | [SISMEMBER key member](https://www.runoob.com/redis/sets-sismember.html)  判断 member 元素是否是集合 key 的成员 |
| 8    | [SMEMBERS key](https://www.runoob.com/redis/sets-smembers.html)  返回集合中的所有成员 |
| 9    | [SMOVE source destination member](https://www.runoob.com/redis/sets-smove.html)  将 member 元素从 source 集合移动到 destination 集合 |
| 10   | [SPOP key](https://www.runoob.com/redis/sets-spop.html)  移除并返回集合中的一个随机元素 |
| 11   | [SRANDMEMBER key [count\]](https://www.runoob.com/redis/sets-srandmember.html)  返回集合中一个或多个随机数 |
| 12   | [SREM key member1 [member2\]](https://www.runoob.com/redis/sets-srem.html)  移除集合中一个或多个成员 |
| 13   | [SUNION key1 [key2\]](https://www.runoob.com/redis/sets-sunion.html)  返回所有给定集合的并集 |
| 14   | [SUNIONSTORE destination key1 [key2\]](https://www.runoob.com/redis/sets-sunionstore.html)  所有给定集合的并集存储在 destination 集合中 |
| 15   | [SSCAN key cursor [MATCH pattern\] [COUNT count]](https://www.runoob.com/redis/sets-sscan.html)  迭代集合中的元素 |

​			

# Redis 有序集合(sorted set)

Redis 有序集合和集合一样也是 string 类型元素的集合,且不允许重复的成员。

不同的是每个元素都会关联一个 double 类型的分数。redis 正是通过分数来为集合中的成员进行从小到大的排序。

有序集合的成员是唯一的,但分数(score)却可以重复。

集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。 

### 实例

```
redis 127.0.0.1:6379> ZADD runoobkey 1 redis
(integer) 1
redis 127.0.0.1:6379> ZADD runoobkey 2 mongodb
(integer) 1
redis 127.0.0.1:6379> ZADD runoobkey 3 mysql
(integer) 1
redis 127.0.0.1:6379> ZADD runoobkey 3 mysql
(integer) 0
redis 127.0.0.1:6379> ZADD runoobkey 4 mysql
(integer) 0
redis 127.0.0.1:6379> ZRANGE runoobkey 0 10 WITHSCORES

1) "redis"
2) "1"
3) "mongodb"
4) "2"
5) "mysql"
6) "4"
```

在以上实例中我们通过命令 **ZADD** 向 redis 的有序集合中添加了三个值并关联上分数。

------

## Redis 有序集合命令

下表列出了 redis 有序集合的基本命令:

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [ZADD key score1 member1 [score2 member2\]](https://www.runoob.com/redis/sorted-sets-zadd.html)  向有序集合添加一个或多个成员，或者更新已存在成员的分数 |
| 2    | [ZCARD key](https://www.runoob.com/redis/sorted-sets-zcard.html)  获取有序集合的成员数 |
| 3    | [ZCOUNT key min max](https://www.runoob.com/redis/sorted-sets-zcount.html)  计算在有序集合中指定区间分数的成员数 |
| 4    | [ZINCRBY key increment member](https://www.runoob.com/redis/sorted-sets-zincrby.html)  有序集合中对指定成员的分数加上增量 increment |
| 5    | [ZINTERSTORE destination numkeys key [key ...\]](https://www.runoob.com/redis/sorted-sets-zinterstore.html)  计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 destination 中 |
| 6    | [ZLEXCOUNT key min max](https://www.runoob.com/redis/sorted-sets-zlexcount.html)  在有序集合中计算指定字典区间内成员数量 |
| 7    | [ZRANGE key start stop [WITHSCORES\]](https://www.runoob.com/redis/sorted-sets-zrange.html)  通过索引区间返回有序集合指定区间内的成员 |
| 8    | [ZRANGEBYLEX key min max [LIMIT offset count\]](https://www.runoob.com/redis/sorted-sets-zrangebylex.html)  通过字典区间返回有序集合的成员 |
| 9    | [ZRANGEBYSCORE key min max [WITHSCORES\] [LIMIT]](https://www.runoob.com/redis/sorted-sets-zrangebyscore.html)  通过分数返回有序集合指定区间内的成员 |
| 10   | [ZRANK key member](https://www.runoob.com/redis/sorted-sets-zrank.html)  返回有序集合中指定成员的索引 |
| 11   | [ZREM key member [member ...\]](https://www.runoob.com/redis/sorted-sets-zrem.html)  移除有序集合中的一个或多个成员 |
| 12   | [ZREMRANGEBYLEX key min max](https://www.runoob.com/redis/sorted-sets-zremrangebylex.html)  移除有序集合中给定的字典区间的所有成员 |
| 13   | [ZREMRANGEBYRANK key start stop](https://www.runoob.com/redis/sorted-sets-zremrangebyrank.html)  移除有序集合中给定的排名区间的所有成员 |
| 14   | [ZREMRANGEBYSCORE key min max](https://www.runoob.com/redis/sorted-sets-zremrangebyscore.html)  移除有序集合中给定的分数区间的所有成员 |
| 15   | [ZREVRANGE key start stop [WITHSCORES\]](https://www.runoob.com/redis/sorted-sets-zrevrange.html)  返回有序集中指定区间内的成员，通过索引，分数从高到低 |
| 16   | [ZREVRANGEBYSCORE key max min [WITHSCORES\]](https://www.runoob.com/redis/sorted-sets-zrevrangebyscore.html)  返回有序集中指定分数区间内的成员，分数从高到低排序 |
| 17   | [ZREVRANK key member](https://www.runoob.com/redis/sorted-sets-zrevrank.html)  返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序 |
| 18   | [ZSCORE key member](https://www.runoob.com/redis/sorted-sets-zscore.html)  返回有序集中，成员的分数值 |
| 19   | [ZUNIONSTORE destination numkeys key [key ...\]](https://www.runoob.com/redis/sorted-sets-zunionstore.html)  计算给定的一个或多个有序集的并集，并存储在新的 key 中 |
| 20   | [ZSCAN key cursor [MATCH pattern\] [COUNT count]](https://www.runoob.com/redis/sorted-sets-zscan.html)  迭代有序集合中的元素（包括元素成员和元素分值） |



原文中说，**集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)**其实不太准确。

其实在redis sorted sets里面当items内容大于64的时候同时使用了hash和skiplist两种设计实现。这也会为了排序和查找性能做的优化。所以如上可知： 

添加和删除都需要修改skiplist，所以复杂度为O(log(n))。 

但是如果仅仅是查找元素的话可以直接使用hash，其复杂度为O(1) 

其他的range操作复杂度一般为O(log(n))

当然如果是小于64的时候，因为是采用了ziplist的设计，其时间复杂度为O(n)

[麻酱](javascript:;)  麻酱 gwa***hunlei@gmail.com3年前 (2017-12-03)

补充测试结果:

```
127.0.0.1:6379> ZADD SDATA 1 S1
(integer) 1
127.0.0.1:6379> ZADD SDATA 2 S2
(integer) 1
127.0.0.1:6379> ZADD SDATA 3 S3
(integer) 1
127.0.0.1:6379> ZADD SDATA 4 A1
(integer) 1
127.0.0.1:6379> ZADD SDATA 4 A2
(integer) 1
127.0.0.1:6379> ZADD SDATA 4 A3
(integer) 1
127.0.0.1:6379> ZADD SDATA 4 A4
(integer) 1
127.0.0.1:6379> ZRANGE SDATA 0 10 WITHSCORES
 1) "S1"
 2) "1"
 3) "S2"
 4) "2"
 5) "S3"
 6) "3"
 7) "A1"
 8) "4"
 9) "A2"
10) "4"
11) "A3"
12) "4"
13) "A4"
14) "4"
```

[张小三](javascript:;)  张小三 576***737@qq.com2年前 (2018-12-05)

​			

  	Redis HyperLogLog

Redis 在 2.8.9 版本添加了 HyperLogLog 结构。

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。

------

## 什么是基数?

比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素)为5。 基数估计就是在误差可接受的范围内，快速计算基数。

------

## 实例

以下实例演示了 HyperLogLog 的工作过程：

```
redis 127.0.0.1:6379> PFADD runoobkey "redis"

1) (integer) 1

redis 127.0.0.1:6379> PFADD runoobkey "mongodb"

1) (integer) 1

redis 127.0.0.1:6379> PFADD runoobkey "mysql"

1) (integer) 1

redis 127.0.0.1:6379> PFCOUNT runoobkey

(integer) 3
```

------

## Redis HyperLogLog 命令

下表列出了 redis HyperLogLog 的基本命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [PFADD key element [element ...\]](https://www.runoob.com/redis/hyperloglog-pfadd.html)  添加指定元素到 HyperLogLog 中。 |
| 2    | [PFCOUNT key [key ...\]](https://www.runoob.com/redis/hyperloglog-pfcount.html)  返回给定 HyperLogLog 的基数估算值。 |
| 3    | [PFMERGE destkey sourcekey [sourcekey ...\]](https://www.runoob.com/redis/hyperloglog-pfmerge.html)  将多个 HyperLogLog 合并为一个 HyperLogLog |

# 

​			

# Redis 事务

Redis 事务可以一次执行多个命令， 并且带有以下三个重要的保证：

- 批量操作在发送 EXEC 命令前被放入队列缓存。
- 收到 EXEC 命令后进入事务执行，事务中任意命令执行失败，其余的命令依然被执行。
- 在事务执行过程，其他客户端提交的命令请求不会插入到事务执行命令序列中。

一个事务从开始到执行会经历以下三个阶段：

- 开始事务。
- 命令入队。
- 执行事务。

------

## 实例

以下是一个事务的例子， 它先以 **MULTI** 开始一个事务， 然后将多个命令入队到事务中， 最后由 **EXEC** 命令触发事务， 一并执行事务中的所有命令：

```
redis 127.0.0.1:6379> MULTI
OK

redis 127.0.0.1:6379> SET book-name "Mastering C++ in 21 days"
QUEUED

redis 127.0.0.1:6379> GET book-name
QUEUED

redis 127.0.0.1:6379> SADD tag "C++" "Programming" "Mastering Series"
QUEUED

redis 127.0.0.1:6379> SMEMBERS tag
QUEUED

redis 127.0.0.1:6379> EXEC
1) OK
2) "Mastering C++ in 21 days"
3) (integer) 3
4) 1) "Mastering Series"
   2) "C++"
   3) "Programming"
```

单个 Redis 命令的执行是原子性的，但 Redis 没有在事务上增加任何维持原子性的机制，所以 Redis 事务的执行并不是原子性的。

事务可以理解为一个打包的批量执行脚本，但批量指令并非原子化的操作，中间某条指令的失败不会导致前面已做指令的回滚，也不会造成后续的指令不做。

> **这是官网上的说明  From redis docs on [transactions](http://redis.io/topics/transactions):**  
>
> It's important to note that even when a command fails, all the  other commands in the queue are processed – Redis will not stop the  processing of commands. 

比如：

```
redis 127.0.0.1:7000> multi
OK
redis 127.0.0.1:7000> set a aaa
QUEUED
redis 127.0.0.1:7000> set b bbb
QUEUED
redis 127.0.0.1:7000> set c ccc
QUEUED
redis 127.0.0.1:7000> exec
1) OK
2) OK
3) OK
```

如果在 set b bbb 处失败，set a 已成功不会回滚，set c 还会继续执行。

------

## Redis 事务命令

下表列出了 redis 事务的相关命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [DISCARD](https://www.runoob.com/redis/transactions-discard.html)  取消事务，放弃执行事务块内的所有命令。 |
| 2    | [EXEC](https://www.runoob.com/redis/transactions-exec.html)  执行所有事务块内的命令。 |
| 3    | [MULTI](https://www.runoob.com/redis/transactions-multi.html)  标记一个事务块的开始。 |
| 4    | [UNWATCH](https://www.runoob.com/redis/transactions-unwatch.html)  取消 WATCH 命令对所有 key 的监视。 |
| 5    | [WATCH key [key ...\]](https://www.runoob.com/redis/transactions-watch.html)  监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。 |

​			

# Redis 脚本

Redis 脚本使用 Lua 解释器来执行脚本。 Redis 2.6 版本通过内嵌支持 Lua 环境。执行脚本的常用命令为 **EVAL**。

### 语法

Eval 命令的基本语法如下：

```
redis 127.0.0.1:6379> EVAL script numkeys key [key ...] arg [arg ...]
```

### 实例

以下实例演示了 redis 脚本工作过程：

```
redis 127.0.0.1:6379> EVAL "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second

1) "key1"
2) "key2"
3) "first"
4) "second"
```

------

## Redis 脚本命令

下表列出了 redis 脚本常用命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [EVAL script numkeys key [key ...\] arg [arg ...]](https://www.runoob.com/redis/scripting-eval.html)  执行 Lua 脚本。 |
| 2    | [EVALSHA sha1 numkeys key [key ...\] arg [arg ...]](https://www.runoob.com/redis/scripting-evalsha.html)  执行 Lua 脚本。 |
| 3    | [SCRIPT EXISTS script [script ...\]](https://www.runoob.com/redis/scripting-script-exists.html)  查看指定的脚本是否已经被保存在缓存当中。 |
| 4    | [SCRIPT FLUSH](https://www.runoob.com/redis/scripting-script-flush.html)  从脚本缓存中移除所有脚本。 |
| 5    | [SCRIPT KILL](https://www.runoob.com/redis/scripting-script-kill.html)  杀死当前正在运行的 Lua 脚本。 |
| 6    | [SCRIPT LOAD script](https://www.runoob.com/redis/scripting-script-load.html)  将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本。 |

# Redis 连接

Redis 连接命令主要是用于连接 redis 服务。

### 实例

以下实例演示了客户端如何通过密码验证连接到 redis 服务，并检测服务是否在运行：

```
redis 127.0.0.1:6379> AUTH "password"
OK
redis 127.0.0.1:6379> PING
PONG
```

------

## Redis 连接命令

下表列出了 redis 连接的基本命令：

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [AUTH password](https://www.runoob.com/redis/connection-auth.html)  验证密码是否正确 |
| 2    | [ECHO message](https://www.runoob.com/redis/connection-echo.html)  打印字符串 |
| 3    | [PING](https://www.runoob.com/redis/connection-ping.html)  查看服务是否运行 |
| 4    | [QUIT](https://www.runoob.com/redis/connection-quit.html)  关闭当前连接 |
| 5    | [SELECT index](https://www.runoob.com/redis/connection-select.html)  切换到指定的数据库 |

# Redis 服务器

Redis 服务器命令主要是用于管理 redis 服务。

### 实例

以下实例演示了如何获取 redis 服务器的统计信息：

```
redis 127.0.0.1:6379> INFO

# Server
redis_version:2.8.13
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:c2238b38b1edb0e2
redis_mode:standalone
os:Linux 3.5.0-48-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.7.2
process_id:3856
run_id:0e61abd297771de3fe812a3c21027732ac9f41fe
tcp_port:6379
uptime_in_seconds:11554
uptime_in_days:0
hz:10
lru_clock:16651447
config_file:

# Clients
connected_clients:1
client-longest_output_list:0
client-biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:589016
used_memory_human:575.21K
used_memory_rss:2461696
used_memory_peak:667312
used_memory_peak_human:651.67K
used_memory_lua:33792
mem_fragmentation_ratio:4.18
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:3
rdb_bgsave_in_progress:0
rdb_last_save_time:1409158561
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:24
total_commands_processed:294
instantaneous_ops_per_sec:0
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:41
keyspace_misses:82
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:264

# Replication
role:master
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:10.49
used_cpu_user:4.96
used_cpu_sys_children:0.00
used_cpu_user_children:0.01

# Keyspace
db0:keys=94,expires=1,avg_ttl=41638810
db1:keys=1,expires=0,avg_ttl=0
db3:keys=1,expires=0,avg_ttl=0
```

------

## Redis 服务器命令

下表列出了 redis 服务器的相关命令:

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [BGREWRITEAOF](https://www.runoob.com/redis/server-bgrewriteaof.html)  异步执行一个 AOF（AppendOnly File） 文件重写操作 |
| 2    | [BGSAVE](https://www.runoob.com/redis/server-bgsave.html)  在后台异步保存当前数据库的数据到磁盘 |
| 3    | [CLIENT KILL [ip:port\] [ID client-id]](https://www.runoob.com/redis/server-client-kill.html)   关闭客户端连接 |
| 4    | [CLIENT LIST](https://www.runoob.com/redis/server-client-list.html)  获取连接到服务器的客户端连接列表 |
| 5    | [CLIENT GETNAME](https://www.runoob.com/redis/server-client-getname.html)  获取连接的名称 |
| 6    | [CLIENT PAUSE timeout](https://www.runoob.com/redis/server-client-pause.html)  在指定时间内终止运行来自客户端的命令 |
| 7    | [CLIENT SETNAME connection-name](https://www.runoob.com/redis/server-client-setname.html)  设置当前连接的名称 |
| 8    | [CLUSTER SLOTS](https://www.runoob.com/redis/server-cluster-slots.html)  获取集群节点的映射数组 |
| 9    | [COMMAND](https://www.runoob.com/redis/server-command.html)  获取 Redis 命令详情数组 |
| 10   | [COMMAND COUNT](https://www.runoob.com/redis/server-command-count.html)  获取 Redis 命令总数 |
| 11   | [COMMAND GETKEYS](https://www.runoob.com/redis/server-command-getkeys.html)  获取给定命令的所有键 |
| 12   | [TIME](https://www.runoob.com/redis/server-time.html)  返回当前服务器时间 |
| 13   | [COMMAND INFO command-name [command-name ...\]](https://www.runoob.com/redis/server-command-info.html)  获取指定 Redis 命令描述的数组 |
| 14   | [CONFIG GET parameter](https://www.runoob.com/redis/server-config-get.html)  获取指定配置参数的值 |
| 15   | [CONFIG REWRITE](https://www.runoob.com/redis/server-config-rewrite.html)  对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写 |
| 16   | [CONFIG SET parameter value](https://www.runoob.com/redis/server-config-set.html)  修改 redis 配置参数，无需重启 |
| 17   | [CONFIG RESETSTAT](https://www.runoob.com/redis/server-config-resetstat.html)  重置 INFO 命令中的某些统计数据 |
| 18   | [DBSIZE](https://www.runoob.com/redis/server-dbsize.html)  返回当前数据库的 key 的数量 |
| 19   | [DEBUG OBJECT key](https://www.runoob.com/redis/server-debug-object.html)  获取 key 的调试信息 |
| 20   | [DEBUG SEGFAULT](https://www.runoob.com/redis/server-debug-segfault.html)  让 Redis 服务崩溃 |
| 21   | [FLUSHALL](https://www.runoob.com/redis/server-flushall.html)  删除所有数据库的所有key |
| 22   | [FLUSHDB](https://www.runoob.com/redis/server-flushdb.html)  删除当前数据库的所有key |
| 23   | [INFO [section\]](https://www.runoob.com/redis/server-info.html)  获取 Redis 服务器的各种信息和统计数值 |
| 24   | [LASTSAVE](https://www.runoob.com/redis/server-lastsave.html)  返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示 |
| 25   | [MONITOR](https://www.runoob.com/redis/server-monitor.html)  实时打印出 Redis 服务器接收到的命令，调试用 |
| 26   | [ROLE](https://www.runoob.com/redis/server-role.html)  返回主从实例所属的角色 |
| 27   | [SAVE](https://www.runoob.com/redis/server-save.html)  同步保存数据到硬盘 |
| 28   | [SHUTDOWN [NOSAVE\] [SAVE]](https://www.runoob.com/redis/server-shutdown.html)  异步保存数据到硬盘，并关闭服务器 |
| 29   | [SLAVEOF host port](https://www.runoob.com/redis/server-slaveof.html)  将当前服务器转变为指定服务器的从属服务器(slave server) |
| 30   | [SLOWLOG subcommand [argument\]](https://www.runoob.com/redis/server-showlog.html)  管理 redis 的慢日志 |
| 31   | [SYNC](https://www.runoob.com/redis/server-sync.html)   用于复制功能(replication)的内部命令 |

# Redis GEO

Redis GEO 主要用于存储地理位置信息，并对存储的信息进行操作，该功能在 Redis 3.2 版本新增。

Redis GEO 操作方法有：

- geoadd：添加地理位置的坐标。
- geopos：获取地理位置的坐标。
- geodist：计算两个位置之间的距离。
- georadius：根据用户给定的经纬度坐标来获取指定范围内的地理位置集合。
- georadiusbymember：根据储存在位置集合里面的某个地点获取指定范围内的地理位置集合。
- geohash：返回一个或多个位置对象的 geohash 值。

### geoadd

geoadd 用于存储指定的地理空间位置，可以将一个或多个经度(longitude)、纬度(latitude)、位置名称(member)添加到指定的 key 中。

geoadd 语法格式如下：

```
GEOADD key longitude latitude member [longitude latitude member ...]
```

以下实例中 key 为 Sicily，Palermo 和 Catania 为位置名称 ：

## 实例

redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
 **(**integer**)** 2
 redis**>** GEODIST Sicily Palermo Catania
 "166274.1516"
 redis**>** GEORADIUS Sicily 15 37 100 km
 1**)** "Catania"
 redis**>** GEORADIUS Sicily 15 37 200 km
 1**)** "Palermo"
 2**)** "Catania"
 redis**>**

### geopos

geopos 用于从给定的 key 里返回所有指定名称(member)的位置（经度和纬度），不存在的返回 nil。

geopos 语法格式如下：

```
GEOPOS key member [member ...]
```

## 实例

redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
 **(**integer**)** 2
 redis**>** GEOPOS Sicily Palermo Catania NonExisting
 1**)** 1**)** "13.36138933897018433"
   2**)** "38.11555639549629859"
 2**)** 1**)** "15.08726745843887329"
   2**)** "37.50266842333162032"
 3**)** **(**nil**)**
 redis**>** 

### geodist

geodist 用于返回两个给定位置之间的距离。

geodist 语法格式如下：

```
GEODIST key member1 member2 [m|km|ft|mi]
```

member1 member2 为两个地理位置。

最后一个距离单位参数说明：

- m  ：米，默认单位。

- km  ：千米。

- mi ：英里。

- ft ：英尺。

- \> 计算 Palermo 与 Catania 之间的距离：

- 

- ## 实例

- redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
   **(**integer**)** 2
   redis**>** GEODIST Sicily Palermo Catania
   "166274.1516"
   redis**>** GEODIST Sicily Palermo Catania km
   "166.2742"
   redis**>** GEODIST Sicily Palermo Catania mi
   "103.3182"
   redis**>** GEODIST Sicily Foo Bar
   **(**nil**)**
   redis**>** 

- ### georadius、georadiusbymember

- georadius 以给定的经纬度为中心， 返回键包含的位置元素当中， 与中心的距离不超过给定最大距离的所有位置元素。

- georadiusbymember 和 GEORADIUS 命令一样， 都可以找出位于指定范围内的元素， 但是 georadiusbymember 的中心点是由给定的位置元素决定的， 而不是使用经度和纬度来决定中心点。

- georadius 与 georadiusbymember 语法格式如下：

- ```
  GEORADIUS key longitude latitude radius m|km|ft|mi [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
  GEORADIUSBYMEMBER key member radius m|km|ft|mi [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
  ```

- 参数说明：

- - m  ：米，默认单位。
  - km  ：千米。
  - mi ：英里。
  - ft ：英尺。
  - WITHDIST: 在返回位置元素的同时， 将位置元素与中心之间的距离也一并返回。 
  - WITHCOORD: 将位置元素的经度和维度也一并返回。
  - WITHHASH: 以 52 位有符号整数的形式， 返回位置元素经过原始 geohash 编码的有序集合分值。 这个选项主要用于底层应用或者调试， 实际中的作用并不大。
  - COUNT 限定返回的记录数。
  - ASC: 查找结果根据距离从近到远排序。
  - DESC: 查找结果根据从远到近排序。

- georadius 实例：

- ## 实例

- redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
   **(**integer**)** 2
   redis**>** GEORADIUS Sicily 15 37 200 km WITHDIST
   1**)** 1**)** "Palermo"
     2**)** "190.4424"
   2**)** 1**)** "Catania"
     2**)** "56.4413"
   redis**>** GEORADIUS Sicily 15 37 200 km WITHCOORD
   1**)** 1**)** "Palermo"
     2**)** 1**)** "13.36138933897018433"
      2**)** "38.11555639549629859"
   2**)** 1**)** "Catania"
     2**)** 1**)** "15.08726745843887329"
      2**)** "37.50266842333162032"
   redis**>** GEORADIUS Sicily 15 37 200 km WITHDIST WITHCOORD
   1**)** 1**)** "Palermo"
     2**)** "190.4424"
     3**)** 1**)** "13.36138933897018433"
      2**)** "38.11555639549629859"
   2**)** 1**)** "Catania"
     2**)** "56.4413"
     3**)** 1**)** "15.08726745843887329"
      2**)** "37.50266842333162032"
   redis**>** 

- georadiusbymember 实例：

- ## 实例

- redis**>** GEOADD Sicily 13.583333 37.316667 "Agrigento"
   **(**integer**)** 1
   redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
   **(**integer**)** 2
   redis**>** GEORADIUSBYMEMBER Sicily Agrigento 100 km
   1**)** "Agrigento"
   2**)** "Palermo"
   redis**>** 

- ### geohash

- Redis GEO 使用 geohash 来保存地理位置的坐标。

- geohash 用于获取一个或多个位置元素的 geohash 值。

- geohash 语法格式如下：

- ```
  GEOHASH key member [member ...]
  ```

- 实例：

- ## 实例

- redis**>** GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
   **(**integer**)** 2
   redis**>** GEOHASH Sicily Palermo Catania
   1**)** "sqc8b49rny0"
   2**)** "sqdtr74hyu0"
   redis**>** 

​			

# Redis Stream

Redis Stream 是 Redis 5.0 版本新增加的数据结构。

Redis Stream 主要用于消息队列（MQ，Message Queue），Redis 本身是有一个 Redis 发布订阅 (pub/sub) 来实现消息队列的功能，但它有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。

简单来说发布订阅 (pub/sub) 可以分发消息，但无法记录历史消息。

而 Redis Stream 提供了消息的持久化和主备复制功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失。

Redis Stream 的结构如下所示，它有一个消息链表，将所有加入的消息都串起来，每个消息都有一个唯一的 ID 和对应的内容：

![img](https://www.runoob.com/wp-content/uploads/2020/09/en-us_image_0167982791.png)

每个 Stream 都有唯一的名称，它就是 Redis 的 key，在我们首次使用 xadd 指令追加消息时自动创建。

上图解析：

- **Consumer Group** ：消费组，使用 XGROUP CREATE 命令创建，一个消费组有多个消费者(Consumer)。
- **last_delivered_id** ：游标，每个消费组会有个游标 last_delivered_id，任意一个消费者读取了消息都会使游标 last_delivered_id 往前移动。
- **pending_ids** ：消费者(Consumer)的状态变量，作用是维护消费者的未确认的 id。 pending_ids 记录了当前已经被客户端读取的消息，但是还没有 ack (Acknowledge character：确认字符）。

**消息队列相关命令：**

- **XADD** - 添加消息到末尾
- **XTRIM** - 对流进行修剪，限制长度
- **XDEL** - 删除消息
- **XLEN** - 获取流包含的元素数量，即消息长度
- **XRANGE** - 获取消息列表，会自动过滤已经删除的消息 
- **XREVRANGE** -  反向获取消息列表，ID 从大到小
- **XREAD** - 以阻塞或非阻塞方式获取消息列表

   **消费者组相关命令：**

- **XGROUP CREATE** - 创建消费者组
- **XREADGROUP GROUP** - 读取消费者组中的消息
- **XACK** - 将消息标记为"已处理"
- **XGROUP SETID** - 为消费者组设置新的最后递送消息ID
- **XGROUP DELCONSUMER** - 删除消费者
- **XGROUP DESTROY** - 删除消费者组
- **XPENDING** - 显示待处理消息的相关信息
- **XCLAIM** - 转移消息的归属权
- **XINFO** - 查看流和消费者组的相关信息；
- **XINFO GROUPS** - 打印消费者组的信息；
-   **XINFO STREAM** - 打印流信息

### XADD

使用 XADD 向队列添加消息，如果指定的队列不存在，则创建一个队列，XADD 语法格式：

```
XADD key ID field value [field value ...]
```

- **key** ：队列名称，如果不存在就创建
- **ID** ：消息 id，我们使用 * 表示由 redis 生成，可以自定义，但是要自己保证递增性。
- **field value** ： 记录。

## 实例

redis**>** XADD mystream ***** name Sara surname OConnor
 "1601372323627-0"
 redis**>** XADD mystream ***** field1 value1 field2 value2 field3 value3
 "1601372323627-1"
 redis**>** XLEN mystream
 **(**integer**)** 2
 redis**>** XRANGE mystream - +
 1**)** 1**)** "1601372323627-0"
   2**)** 1**)** "name"
    2**)** "Sara"
    3**)** "surname"
    4**)** "OConnor"
 2**)** 1**)** "1601372323627-1"
   2**)** 1**)** "field1"
    2**)** "value1"
    3**)** "field2"
    4**)** "value2"
    5**)** "field3"
    6**)** "value3"
 redis**>** 

### XTRIM

使用 XTRIM 对流进行修剪，限制长度， 语法格式：

```
XTRIM key MAXLEN [~] count
```

- **key** ：队列名称
- **MAXLEN** ：长度
- **count** ：数量

## 实例

127.0.0.1:6379**>** XADD mystream ***** field1 A field2 B field3 C field4 D
 "1601372434568-0"
 127.0.0.1:6379**>** XTRIM mystream MAXLEN 2
 **(**integer**)** 0
 127.0.0.1:6379**>** XRANGE mystream - +
 1**)** 1**)** "1601372434568-0"
   2**)** 1**)** "field1"
    2**)** "A"
    3**)** "field2"
    4**)** "B"
    5**)** "field3"
    6**)** "C"
    7**)** "field4"
    8**)** "D"
 127.0.0.1:6379**>** 

 redis**>** 

### XDEL

使用 XDEL 删除消息，语法格式：

```
XDEL key ID [ID ...]
```

- **key**：队列名称
- **ID** ：消息 ID

## 实例

**>** XADD mystream ***** a 1
 1538561698944-0
 **>** XADD mystream ***** b 2
 1538561700640-0
 **>** XADD mystream ***** c 3
 1538561701744-0
 **>** XDEL mystream 1538561700640-0
 **(**integer**)** 1
 127.0.0.1:6379**>** XRANGE mystream - +
 1**)** 1**)** 1538561698944-0
   2**)** 1**)** "a"
    2**)** "1"
 2**)** 1**)** 1538561701744-0
   2**)** 1**)** "c"
    2**)** "3"

### XLEN

使用 XLEN 获取流包含的元素数量，即消息长度，语法格式：

```
XLEN key
```

- **key**：队列名称

## 实例

redis**>** XADD mystream ***** item 1
 "1601372563177-0"
 redis**>** XADD mystream ***** item 2
 "1601372563178-0"
 redis**>** XADD mystream ***** item 3
 "1601372563178-1"
 redis**>** XLEN mystream
 **(**integer**)** 3
 redis**>** 

### XRANGE

使用 XRANGE 获取消息列表，会自动过滤已经删除的消息 ，语法格式：

```
XRANGE key start end [COUNT count]
```

- **key** ：队列名
- **start** ：开始值， - 表示最小值
- **end** ：结束值， + 表示最大值
- **count** ：数量

## 实例

redis**>** XADD writers ***** name Virginia surname Woolf
 "1601372577811-0"
 redis**>** XADD writers ***** name Jane surname Austen
 "1601372577811-1"
 redis**>** XADD writers ***** name Toni surname Morrison
 "1601372577811-2"
 redis**>** XADD writers ***** name Agatha surname Christie
 "1601372577812-0"
 redis**>** XADD writers ***** name Ngozi surname Adichie
 "1601372577812-1"
 redis**>** XLEN writers
 **(**integer**)** 5
 redis**>** XRANGE writers - + COUNT 2
 1**)** 1**)** "1601372577811-0"
   2**)** 1**)** "name"
    2**)** "Virginia"
    3**)** "surname"
    4**)** "Woolf"
 2**)** 1**)** "1601372577811-1"
   2**)** 1**)** "name"
    2**)** "Jane"
    3**)** "surname"
    4**)** "Austen"
 redis**>** 

### XREVRANGE

使用 XREVRANGE 获取消息列表，会自动过滤已经删除的消息 ，语法格式：

```
XREVRANGE key end start [COUNT count]
```

- **key** ：队列名
- **end** ：结束值， + 表示最大值
- **start** ：开始值， - 表示最小值
- **count** ：数量

## 实例

redis**>** XADD writers ***** name Virginia surname Woolf
 "1601372731458-0"
 redis**>** XADD writers ***** name Jane surname Austen
 "1601372731459-0"
 redis**>** XADD writers ***** name Toni surname Morrison
 "1601372731459-1"
 redis**>** XADD writers ***** name Agatha surname Christie
 "1601372731459-2"
 redis**>** XADD writers ***** name Ngozi surname Adichie
 "1601372731459-3"
 redis**>** XLEN writers
 **(**integer**)** 5
 redis**>** XREVRANGE writers + - COUNT 1
 1**)** 1**)** "1601372731459-3"
   2**)** 1**)** "name"
    2**)** "Ngozi"
    3**)** "surname"
    4**)** "Adichie"
 redis**>** 

### XREAD

使用 XREAD 以阻塞或非阻塞方式获取消息列表 ，语法格式：

```
XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] id [id ...]
```

- **count** ：数量
- **milliseconds** ：可选，阻塞毫秒数，没有设置就是非阻塞模式
- **key** ：队列名
- **id** ：消息 ID

## 实例

*# 从 Stream 头部读取两条消息*
 **>** XREAD COUNT 2 STREAMS mystream writers 0-0 0-0
 1**)** 1**)** "mystream"
   2**)** 1**)** 1**)** 1526984818136-0
      2**)** 1**)** "duration"
       2**)** "1532"
       3**)** "event-id"
       4**)** "5"
       5**)** "user-id"
       6**)** "7782813"
    2**)** 1**)** 1526999352406-0
      2**)** 1**)** "duration"
       2**)** "812"
       3**)** "event-id"
       4**)** "9"
       5**)** "user-id"
       6**)** "388234"
 2**)** 1**)** "writers"
   2**)** 1**)** 1**)** 1526985676425-0
      2**)** 1**)** "name"
       2**)** "Virginia"
       3**)** "surname"
       4**)** "Woolf"
    2**)** 1**)** 1526985685298-0
      2**)** 1**)** "name"
       2**)** "Jane"
       3**)** "surname"
       4**)** "Austen"


### XGROUP CREATE

使用 XGROUP CREATE 创建消费者组，语法格式：

```
XGROUP [CREATE key groupname id-or-$] [SETID key groupname id-or-$] [DESTROY key groupname] [DELCONSUMER key groupname consumername]
```

- **key** ：队列名称，如果不存在就创建
- **groupname** ：组名。
- **$** ： 表示从尾部开始消费，只接受新消息，当前 Stream 消息会全部忽略。

从头开始消费:

```
XGROUP CREATE mystream consumer-group-name 0-0  
```

从尾部开始消费:

```
XGROUP CREATE mystream consumer-group-name $
```

### XREADGROUP GROUP

使用 XREADGROUP GROUP 读取消费组中的消息，语法格式：

```
XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS key [key ...] ID [ID ...]
```

- **group** ：消费组名
- **consumer** ：消费者名。
- **count** ： 读取数量。
- **milliseconds** ： 阻塞毫秒数。
- **key** ： 队列名。
- **ID** ： 消息 ID。

```
XREADGROUP GROUP consumer-group-name consumer-name COUNT 1 STREAMS mystream >
```



 

**redis的服务相关的命令**

![img](https://img-blog.csdnimg.cn/20181224163405380)

slect＃选择数据库（数据库编号0-15）
 退出＃退出连接
 信息＃获得服务的信息与统计
 monitor＃实时监控
 config get＃获得服务配置
 flushdb＃删除当前选择的数据库中的key
 flushall＃删除所有数据库中的键

 

# Redis 性能测试

Redis 性能测试是通过同时执行多个命令实现的。

### 语法

redis 性能测试的基本命令如下：

```
redis-benchmark [option] [option value]
```

**注意**：该命令是在 redis 的目录下执行的，而不是 redis 客户端的内部指令。

### 实例

以下实例同时执行 10000 个请求来检测性能：

```
$ redis-benchmark -n 10000  -q

PING_INLINE: 141043.72 requests per second
PING_BULK: 142857.14 requests per second
SET: 141442.72 requests per second
GET: 145348.83 requests per second
INCR: 137362.64 requests per second
LPUSH: 145348.83 requests per second
LPOP: 146198.83 requests per second
SADD: 146198.83 requests per second
SPOP: 149253.73 requests per second
LPUSH (needed to benchmark LRANGE): 148588.42 requests per second
LRANGE_100 (first 100 elements): 58411.21 requests per second
LRANGE_300 (first 300 elements): 21195.42 requests per second
LRANGE_500 (first 450 elements): 14539.11 requests per second
LRANGE_600 (first 600 elements): 10504.20 requests per second
MSET (10 keys): 93283.58 requests per second
```

redis 性能测试工具可选参数如下所示：

| 序号 | 选项      | 描述                                       | 默认值    |
| ---- | --------- | ------------------------------------------ | --------- |
| 1    | **-h**    | 指定服务器主机名                           | 127.0.0.1 |
| 2    | **-p**    | 指定服务器端口                             | 6379      |
| 3    | **-s**    | 指定服务器 socket                          |           |
| 4    | **-c**    | 指定并发连接数                             | 50        |
| 5    | **-n**    | 指定请求数                                 | 10000     |
| 6    | **-d**    | 以字节的形式指定 SET/GET 值的数据大小      | 2         |
| 7    | **-k**    | 1=keep alive 0=reconnect                   | 1         |
| 8    | **-r**    | SET/GET/INCR 使用随机 key, SADD 使用随机值 |           |
| 9    | **-P**    | 通过管道传输 <numreq> 请求                 | 1         |
| 10   | **-q**    | 强制退出 redis。仅显示 query/sec 值        |           |
| 11   | **--csv** | 以 CSV 格式输出                            |           |
| 12   | **-l**    | 生成循环，永久执行测试                     |           |
| 13   | **-t**    | 仅运行以逗号分隔的测试命令列表。           |           |
| 14   | **-I**    | Idle 模式。仅打开 N 个 idle 连接并等待。   |           |

### 实例

以下实例我们使用了多个参数来测试 redis 性能：

```
$ redis-benchmark -h 127.0.0.1 -p 6379 -t set,lpush -n 10000 -q

SET: 146198.83 requests per second
LPUSH: 145560.41 requests per second
```

以上实例中主机为 127.0.0.1，端口号为 6379，执行的命令为 set,lpush，请求数为 10000，通过 -q 参数让结果只显示每秒执行的请求数。

​			

# Redis 客户端连接

Redis 通过监听一个 TCP 端口或者 Unix socket 的方式来接收来自客户端的连接，当一个连接建立后，Redis 内部会进行以下一些操作：

- 首先，客户端 socket 会被设置为非阻塞模式，因为 Redis 在网络事件处理上采用的是非阻塞多路复用模型。
- 然后为这个 socket 设置 TCP_NODELAY 属性，禁用 Nagle 算法
- 然后创建一个可读的文件事件用于监听这个客户端 socket 的数据发送

------

## 最大连接数

在 Redis2.4 中，最大连接数是被直接硬编码在代码里面的，而在2.6版本中这个值变成可配置的。

maxclients 的默认值是 10000，你也可以在 redis.conf 中对这个值进行修改。

```
config get maxclients

1) "maxclients"
2) "10000"
```

### 实例

以下实例我们在服务启动时设置最大连接数为 100000：

```
redis-server --maxclients 100000
```

------

## 客户端命令

| S.N. | 命令               | 描述                                       |
| ---- | ------------------ | ------------------------------------------ |
| 1    | **CLIENT LIST**    | 返回连接到 redis 服务的客户端列表          |
| 2    | **CLIENT SETNAME** | 设置当前连接的名称                         |
| 3    | **CLIENT GETNAME** | 获取通过 CLIENT SETNAME 命令设置的服务名称 |
| 4    | **CLIENT PAUSE**   | 挂起客户端连接，指定挂起的时间以毫秒计     |
| 5    | **CLIENT KILL**    | 关闭客户端连接                             |

# Redis 管道技术

Redis是一种基于客户端-服务端模型以及请求/响应协议的TCP服务。这意味着通常情况下一个请求会遵循以下步骤：

- 客户端向服务端发送一个查询请求，并监听Socket返回，通常是以阻塞模式，等待服务端响应。
- 服务端处理命令，并将结果返回给客户端。

------

## Redis 管道技术

Redis 管道技术可以在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。

### 实例

查看 redis 管道，只需要启动 redis 实例并输入以下命令：

```
$(echo -en "PING\r\n SET runoobkey redis\r\nGET runoobkey\r\nINCR visitor\r\nINCR visitor\r\nINCR visitor\r\n"; sleep 10) | nc localhost 6379

+PONG
+OK
redis
:1
:2
:3
```

以上实例中我们通过使用 **PING** 命令查看redis服务是否可用， 之后我们设置了 runoobkey 的值为 redis，然后我们获取 runoobkey 的值并使得 visitor 自增 3 次。

在返回的结果中我们可以看到这些命令一次性向 redis 服务提交，并最终一次性读取所有服务端的响应

------

## 管道技术的优势

管道技术最显著的优势是提高了 redis 服务的性能。

### 一些测试数据

在下面的测试中，我们将使用Redis的Ruby客户端，支持管道技术特性，测试管道技术对速度的提升效果。

```
require 'rubygems' 
require 'redis'
def bench(descr) 
start = Time.now 
yield 
puts "#{descr} #{Time.now-start} seconds" 
end
def without_pipelining 
r = Redis.new 
10000.times { 
    r.ping 
} 
end
def with_pipelining 
r = Redis.new 
r.pipelined { 
    10000.times { 
        r.ping 
    } 
} 
end
bench("without pipelining") { 
    without_pipelining 
} 
bench("with pipelining") { 
    with_pipelining 
}
```

从处于局域网中的Mac OS X系统上执行上面这个简单脚本的数据表明，开启了管道操作后，往返延时已经被改善得相当低了。

```
without pipelining 1.185238 seconds 
with pipelining 0.250783 seconds
```

如你所见，开启管道后，我们的速度效率提升了5倍。

​			

# Redis 分区

分区是分割数据到多个Redis实例的处理过程，因此每个实例只保存key的一个子集。

### 分区的优势

- 通过利用多台计算机内存的和值，允许我们构造更大的数据库。
- 通过多核和多台计算机，允许我们扩展计算能力；通过多台计算机和网络适配器，允许我们扩展网络带宽。

### 分区的不足

redis的一些特性在分区方面表现的不是很好：

- 涉及多个key的操作通常是不被支持的。举例来说，当两个set映射到不同的redis实例上时，你就不能对这两个set执行交集操作。
- 涉及多个key的redis事务不能使用。
- 当使用分区时，数据处理较为复杂，比如你需要处理多个rdb/aof文件，并且从多个实例和主机备份持久化文件。
- 增加或删除容量也比较复杂。redis集群大多数支持在运行时增加、删除节点的透明数据平衡的能力，但是类似于客户端分区、代理等其他系统则不支持这项特性。然而，一种叫做presharding的技术对此是有帮助的。

------

## 分区类型

Redis 有两种类型分区。 假设有4个Redis实例 R0，R1，R2，R3，和类似user:1，user:2这样的表示用户的多个key，对既定的key有多种不同方式来选择这个key存放在哪个实例中。也就是说，有不同的系统来映射某个key到某个Redis服务。

### 范围分区

最简单的分区方式是按范围分区，就是映射一定范围的对象到特定的Redis实例。

比如，ID从0到10000的用户会保存到实例R0，ID从10001到 20000的用户会保存到R1，以此类推。

这种方式是可行的，并且在实际中使用，不足就是要有一个区间范围到实例的映射表。这个表要被管理，同时还需要各 种对象的映射表，通常对Redis来说并非是好的方法。

### 哈希分区

另外一种分区方法是hash分区。这对任何key都适用，也无需是object_name:这种形式，像下面描述的一样简单：

- 用一个hash函数将key转换为一个数字，比如使用crc32 hash函数。对key foobar执行crc32(foobar)会输出类似93024922的整数。
- 对这个整数取模，将其转化为0-3之间的数字，就可以将这个整数映射到4个Redis实例中的一个了。93024922 % 4 = 2，就是说key foobar应该被存到R2实例中。注意：取模操作是取除的余数，通常在多种编程语言中用%操作符实现。

## Java 使用 Redis

### 安装 redis 驱动

- 首先你需要下载驱动包 [**下载 jedis.jar**](https://mvnrepository.com/artifact/redis.clients/jedis)，确保下载最新驱动包。
- 在你的 classpath 中包含该驱动包。

### 连接到 redis 服务

```java
import redis.clients.jedis.Jedis;
public class RedisJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        // 如果 Redis 服务设置来密码，需要下面这行，没有就不需要
        // jedis.auth("123456");
        System.out.println("连接成功");
        //查看服务是否运行
        System.out.println("服务正在运行: "+jedis.ping());
    }
}
```

### String(字符串) 实例

```java
import redis.clients.jedis.Jedis;
public class RedisStringJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
        //设置 redis 字符串数据
        jedis.set("rbkey", "www.rb.com");
        // 获取存储的数据并输出
        System.out.println("redis 存储的字符串为: "+ jedis.get("rbkey"));
    }
}
```

### List(列表) 实例

```java
import java.util.List;
import redis.clients.jedis.Jedis;
public class RedisListJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
        //存储数据到列表中
        jedis.lpush("site-list", "Rb");
        jedis.lpush("site-list", "Google");
        jedis.lpush("site-list", "Taobao");
        // 获取存储的数据并输出
        List<String> list = jedis.lrange("site-list", 0 ,2);
        for(int i=0; i<list.size(); i++) {
            System.out.println("列表项为: "+list.get(i));
        }
    }
}
```

### Keys 实例

```java
import java.util.Iterator;
import java.util.Set;
import redis.clients.jedis.Jedis;
public class RedisKeyJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
        // 获取数据并输出
        Set<String> keys = jedis.keys("*");
        Iterator<String> it=keys.iterator() ;
        while(it.hasNext()){
            String key = it.next();
            System.out.println(key);
        }
    }
}
```

## PHP 使用 Redis

### 安装redis扩展

```bash
wget https://github.com/phpredis/phpredis/archive/3.1.4.tar.gz
cd phpredis-3.1.4                      # 进入 phpredis 目录
/usr/local/php/bin/phpize              # php安装后的路径
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
```

### 修改php.ini文件

```bash
vi /usr/local/php/lib/php.ini

extension_dir = "/usr/local/php/lib/php/extensions/no-debug-zts-20090626"
extension=redis.so
```

### 连接到 redis 服务

```php
<?php
    //连接本地的 Redis 服务
   $redis = new Redis();
   $redis->connect('127.0.0.1', 6379);
   echo "Connection to server successfully";
         //查看服务是否运行
   echo "Server is running: " . $redis->ping();
?>
```

执行脚本，输出结果为：

```bash
Connection to server sucessfully
Server is running: PONG
```

### String(字符串) 实例

```php
<?php
   //连接本地的 Redis 服务
   $redis = new Redis();
   $redis->connect('127.0.0.1', 6379);
   echo "Connection to server successfully";
   //设置 redis 字符串数据
   $redis->set("tutorial-name", "Redis tutorial");
   // 获取存储的数据并输出
   echo "Stored string in redis:: " . $redis->get("tutorial-name");
?>
```

执行脚本，输出结果为：

```bash
Connection to server sucessfully
Stored string in redis:: Redis tutorial
```

### List(列表) 实例

```php
<?php
   //连接本地的 Redis 服务
   $redis = new Redis();
   $redis->connect('127.0.0.1', 6379);
   echo "Connection to server successfully";
   //存储数据到列表中
   $redis->lpush("tutorial-list", "Redis");
   $redis->lpush("tutorial-list", "Mongodb");
   $redis->lpush("tutorial-list", "Mysql");
   // 获取存储的数据并输出
   $arList = $redis->lrange("tutorial-list", 0 ,5);
   echo "Stored string in redis";
   print_r($arList);
?>
```

执行脚本，输出结果为：

```bash
Connection to server sucessfully
Stored string in redis
Mysql
Mongodb
Redis
```

### Keys 实例

```php
<?php
   //连接本地的 Redis 服务
   $redis = new Redis();
   $redis->connect('127.0.0.1', 6379);
   echo "Connection to server successfully";
   // 获取数据并输出
   $arList = $redis->keys("*");
   echo "Stored keys in redis:: ";
   print_r($arList);
?>
```

执行脚本，输出结果为：

```bash
Connection to server sucessfully
Stored string in redis::
tutorial-name
tutorial-list
```

​			