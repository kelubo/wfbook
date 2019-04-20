# LDAP：轻量级目录访问协议
## 适合存放于LDAP中的数据
>* 数据对象相对较小
>* 数据库可被广泛复制与缓存
>* 信息是基于属性的
>* 频繁读取数据，但很少写数据
>* 搜索是一种常用的操作

##LDAP层次结构常见属性
| 属性 | 代表 | 含义 |
|----|----|----|
| o | 机构 | 经常标识一个站点的顶级条目 |
| ou | 机构单元 | 逻辑上的组成部分 |
| cn | 常用名 | 表示条目的最自然的名字 |
| dc | 域名成分 | 用在以DNS为模型建立LDAP层次结构的站点 |
| objectClass | 对象类 | 该条目的属性所遵循的模式 |

## 确定管理信息源的优先级
/etc/nsswitch.conf(AIX:/etc/netsvc.conf)
信息源：nis,nisplus,files,dns,ldap,compat(NIS化的纯文件)  
可在某个信息源后的中括号内明确的定义它“失败”后的动作。例如：  
*hosts: dns [NOTFOUND=xxxx] files*  
*xxxx=[return/continue]*

**失败模式**  

| 条件 | 含义 |
|----|----|
| UNAVAIL | 信息源不存在或者已关闭 |
| NOTFOUND | 信息源存在，但不能回答查询 |
| TRYAGAIN | 信息源存在，但出于忙状态 |
| SUCCESS | 信息源能够回答查询 |
## nscd(name service cache daemon)
过期时间：  
passwd —— 10分钟  
hosts —— 1小时  
group —— 1小时
