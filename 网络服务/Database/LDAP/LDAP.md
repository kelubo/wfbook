# LDAP：轻量级目录访问协议

目录是一个专门的数据库，用于搜索和浏览，另外也支持基本的查询和更新功能。

LDAP表示轻型目录访问协议。是一个轻量级协议，用于访问目录服务，特别是基于X.500的目录服务。 LDAP运行在TCP / IP或其他面向连接的传输服务。 LDAP是一个IETF标准跟踪协议，在“轻量级目录访问协议（ LDAP ）技术规范路线图”RFC4510中被指定。

LDAP信息模型是基于条目的. 一个条目是一个属性的集合，有一个全球唯一的识别名（ DN ）. DN用于明白无误地标识条目. 每个条目的属性有一个类型和一个或多个值. 该类型通常是可记忆的字符串，如“ cn ”就是标识通用名称，或“mail”就是电子邮件地址。 值的语法依赖于属性类型。

在LDAP, 目录条目都被排列在一个分层树形结构。传统上，这种结构反映了地域和/或组织界限. 代表国家的条目出现在树的顶端。它们下面是代表州和国家组织的条目. 再下面可能是代表组织单位,人,打印机,文档,或只是任何你你能想象到的东西。LDAP 目录树 (传统的命名)
![](D:/CVS/Git/wfbook/Image/intro_tree.png)

树也可以根据互联网域名组织。它允许使用DNS为目录服务定位 。LDAP 目录树(Internet命名)
![](D:/CVS/Git/wfbook/Image/intro_dctree.png)

通过使用一种特殊属性objectClass，可以让LDAP控制在一个条目中哪个属性是必需的和允许的。objectClass属性的值确定条目必须遵守的架构规则。

LDAP采用C/S模式。包含在一个或多个LDAP服务器中的数据组成了目录信息树(DIT)。

LDAP采用树状结构存储数据（类似于前面学习的DNS服务程序），用于在IP网络层面实现对分布式目录的访问和管理操作，**条目**是LDAP协议中最基本的元素，可以想象成字典中的单词或者数据库中的记录，通常对LDAP服务程序的添加、删除、更改、搜索都是以条目为基本对象的。
 ![第23章 使用OpenLDAP部署目录服务。第23章 使用OpenLDAP部署目录服务。](https://www.linuxprobe.com/wp-content/uploads/2015/09/ldap存储结构1.png)

**LDAP树状结构存储数据**

> dn:每个条目的唯一标识符，如上图中linuxprobe的dn值是：
>
> ```
> cn=linuxprobe,ou=marketing,ou=people,dc=mydomain,dc=org
> ```
>
> rdn:一般为dn值中最左侧的部分，如上图中linuxprobe的rdn值是：
>
> ```
> cn=linuxprobe
> ```
>
> base DN:此为基准DN值，表示顶层的根部，上图中的base DN值是：
>
> ```
> dc=mydomain,dc=org
> ```

而每个条目可以有多个属性（如姓名、地址、电话等），每个属性中会保存着对象名称与对应值，LDAP已经为运维人员对常见的对象定义了属性，其中有：

| 属性名称               | 属性别名 | 语法             | 描述             | 值（举例）           |
| ---------------------- | -------- | ---------------- | ---------------- | -------------------- |
| commonName             | cn       | Directory String | 名字             | sean                 |
| surname                | sn       | Directory String | 姓氏             | Chow                 |
| organizationalUnitName | ou       | Directory String | 单位（部门）名称 | IT_SECTION           |
| organization           | o        | Directory String | 组织（公司）名称 | linuxprobe           |
| telephoneNumber        |          | Telephone Number | 电话号码         | 911                  |
| objectClass            |          |                  | 内置属性         | organizationalPerson |




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
