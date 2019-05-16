# Redis

Redis 官网：https://redis.io/

Redis 在线测试：http://try.redis.io/

REmote DIctionary Server(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。

是一个开源的使用ANSI C语言编写、遵守BSD协议、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。可用于缓存，事件发布或订阅，高速队列等场景。支持网络，提供字符串，哈希，列表，队列，集合结构直接存取，基于内存，可持久化。

通常被称为数据结构服务器，因为值（value）可以是 字符串(String), 哈希(Hash), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型。

了解基本的数据结构，例如以下几种：

    String: 字符串
    Hash: 散列
    List: 列表
    Set: 集合
    Sorted Set: 有序集合

**支持的语言**

![img](https://img-blog.csdnimg.cn/20181224163405267)

 

**redis的应用场景**

1. 会话缓存（最常用）
2. 消息队列，比如支付
3. 活动排行榜或计数
4. 发布，订阅消息（消息通知）
5. 商品列表，评论列表等

**redis数据类型**
支持五种数据类：string（字符串），hash（哈希），list（列表），set（集合）和zset（sorted set有序集合）。

（1）字符串（字符串）
 它是redis的最基本的数据类型，一个键对应一个值，需要注意是一个键值最大存储512MB。

![img](https://img-blog.csdnimg.cn/20181224163405288)

（2）hash（哈希）
 redis hash是一个键值对的集合，是一个string类型的field和value的映射表，适合用于存储对象

![img](https://img-blog.csdnimg.cn/20181224163405306)

（3）表（列表）
 是redis的简单的字符串列表，它按插入顺序排序

![img](https://img-blog.csdnimg.cn/20181224163405324)

（4）组（集合）
 是字符串类型的无序集合，也不可重复

![img](https://img-blog.csdnimg.cn/20181224163405342)

（5）zset（sorted set有序集合）
 是string类型的有序集合，也不可重复
 有序集合中的每个元素都需要指定一个分数，根据分数对元素进行升序排序，如果多个元素有相同的分数，则以字典序进行升序排序，sorted set因此非常适合实现排名

![img](https://img-blog.csdnimg.cn/20181224163405363)

 

**redis的服务相关的命令**

![img](https://img-blog.csdnimg.cn/20181224163405380)

slect＃选择数据库（数据库编号0-15）
 退出＃退出连接
 信息＃获得服务的信息与统计
 monitor＃实时监控
 config get＃获得服务配置
 flushdb＃删除当前选择的数据库中的key
 flushall＃删除所有数据库中的键

 

**redis的发布与订阅**

redis的发布与订阅（发布/订阅）是它的一种消息通信模式，一方发送信息，一方接收信息。
 下图是三个客户端同时订阅同一个频道

![img](https://img-blog.csdnimg.cn/20181224163405400)

下图是有新信息发送给频道1时，就会将消息发送给订阅它的三个客户端
![img](https://img-blog.csdnimg.cn/20181224163405417)

 

 

**redis的持久化**

redis持久有两种方式：快照（快照），仅附加文件（AOF）

快照（快照）

1，将存储在内存的数据以快照的方式写入二进制文件中，如默认dump.rdb中
 2，保存900 1 

＃900秒内如果超过1个Key被修改，则启动快照保存
 3，保存300 10 

＃300秒内如果超过10个Key被修改，则启动快照保存
 4，保存60 10000 

＃60秒内如果超过10000个重点被修改，则启动快照保存


仅附加文件（AOF）

1，使用AOF持久时，服务会将每个收到的写命令通过写函数追加到文件中（appendonly.aof）
 2，AOF持久化存储方式参数说明
     appendonly yes  

​           ＃开启AOF持久化存储方式 
​     appendfsync always 

​         ＃收到写命令后就立即写入磁盘，效率最差，效果最好
​     appendfsync everysec

​         ＃每秒写入磁盘一次，效率与效果居中
​     appendfsync no 

​         ＃完全依赖操作系统，效率最佳，效果没法保证

 

**redis的性能测试**

自带相关测试工具

![img](https://img-blog.csdnimg.cn/20181224163405438)

实际测试同时执行100万的请求

![img](https://img-blog.csdnimg.cn/20181224163405456)
