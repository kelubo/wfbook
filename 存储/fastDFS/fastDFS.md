# fastDFS

[TOC]

## 概述

FastDFS由跟踪服务器（tracker server）、存储服务器（storage server）和客户端（client）三个部分组成，主要解决了海量数据存储问题，特别适合以中小文件（建议范围：4KB < file_size < 500MB）为载体的在线服务。

**Storage server**  

用来存储文件的，以组（group）为单位组织，一个group内包含多台storage机器，数据互为备份，存储空间以group内容量最小的storage为准。  

以group为单位组织存储能方便的进行应用隔离、负载均衡、副本数定制（group内storage server数量即为该group的副本数），比如将不同应用数据存到不同的group就能隔离应用数据，同时还可根据应用的访问特性来将应用分配到不同的group来做负载均衡；缺点是group的容量受单机存储容量的限制，同时当group内有机器坏掉时，数据恢复只能依赖group内地其他机器，使得恢复时间会很长。  

storage接受到写文件请求时，会根据配置文件配置好的规则，选择其中一个存储目录来存储文件。为了避免单个目录下的文件数太多，在storage第一次启动时，会在每个数据存储目录里创建2级子目录，每级256个，总共65536个文件，新写的文件会以hash的方式被路由到其中某个子目录下，然后将文件数据直接作为一个本地文件存储到该目录中。

**Tracker server**  

Tracker是FastDFS的协调者，负责管理所有的storage server和group，每个storage在启动后会连接Tracker，告知自己所属的group等信息，并保持周期性的心跳，tracker根据storage的心跳信息，建立group==>[storage server list]的映射表。  

Tracker需要管理的元信息很少，会全部存储在内存中；另外tracker上的元信息都是由storage汇报的信息生成的，本身不需要持久化任何数据，这样使得tracker非常容易扩展，直接增加tracker机器即可扩展为tracker cluster来服务，cluster里每个tracker之间是完全对等的，所有的tracker都接受stroage的心跳信息，生成元数据信息来提供读写服务。  

当tracker接收到upload file的请求时，会为该文件分配一个可以存储该文件的group，支持如下选择group的规则：  

    1. Round robin，所有的group间轮询
    2. Specified group，指定某一个确定的group
    3. Load balance，剩余存储空间多的group优先

当选定group后，tracker会在group内选择一个storage server给客户端，支持如下选择storage的规则：  

    1. Round robin，在group内的所有storage间轮询
    2. First server ordered by ip，按ip排序
    3. First server ordered by priority，按优先级排序（优先级在storage上配置）

当分配好storage server后，客户端将向storage发送写文件请求，storage将会为文件分配一个数据存储目录，支持如下规则：  

    1. Round robin，多个存储目录间轮询
    2. 剩余存储空间最多的优先

选定存储目录之后，storage会为文件生一个Fileid，由storage server ip、文件创建时间、文件大小、文件crc32和一个随机数拼接而成，然后将这个二进制串进行base64编码，转换为可打印的字符串。  

当文件存储到某个子目录后，即认为该文件存储成功，接下来会为该文件生成一个文件名，文件名由group、存储目录、两级子目录、fileid、文件后缀名（由客户端指定，主要用于区分文件类型）拼接而成。

**文件同步**  

写文件时，客户端将文件写至group内一个storage server即认为写文件成功，storage server写完文件后，会由后台线程将文件同步至同group内其他的storage server。  

每个storage写文件后，同时会写一份binlog，binlog里不包含文件数据，只包含文件名等元信息，这份binlog用于后台同步，storage会记录向group内其他storage同步的进度，以便重启后能接上次的进度继续同步；进度以时间戳的方式进行记录，所以最好能保证集群内所有server的时钟保持同步。  

storage的同步进度会作为元数据的一部分汇报到tracker上，tracke在选择读storage的时候会以同步进度作为参考。

FastDFS在V3.0版本里引入小文件合并存储的机制，可将多个小文件存储到一个大的文件（trunk file），为了支持这个机制，FastDFS生成的文件fileid需要额外增加16个字节。  

    1. trunk file id
    2. 文件在trunk file内部的offset
    3. 文件占用的存储空间大小 （字节对齐及删除空间复用，文件占用存储空间>=文件大小）

**HTTP访问支持**  

FastDFS的tracker和storage都内置了http协议的支持，客户端可以通过http协议来下载文件，tracker在接收到请求时，通过http的redirect机制将请求重定向至文件所在的storage上；除了内置的http协议外，FastDFS还提供了通过apache或nginx扩展模块下载文件的支持。

## tracker安装
**1.安装**  

如果有多个tracker，只需要修改storage.conf与client.conf加多个tracker_serv即可，base_path也要正确设置。  

将代码包解压。  

运行make.sh，确认make成功。  

    [root@tracker FastDFS]# ./make.sh
运行make.sh install，确认install成功。

    [root@tracker FastDFS]# ./make.sh install
安装完成后，所有可执行文件在/usr/local/bin下，以fdfs开头。所有配置文件在/etc/fdfs下。

**2.配置**  

编辑配置文件目录下的tracker.conf，设置相关信息并保存。  

    [root@tracker FastDFS]# vim /etc/fdfs/tracker.conf
一般只需改动以下几个参数即可。

    disabled=false            #启用配置文件
    port=22122                #设置tracker的端口号
    base_path=/fdfs/tracker   #设置tracker的数据文件和日志目录（需预先创建）
    http.server_port=8080     #设置http端口号

**3.运行**  

启动tracker，确认启动是否成功。（查看是否对应端口22122是否开始监听）

    [root@tracker FastDFS]#/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
    [root@tracker FastDFS]#netstat -unltp | grep fdfs
设置开机自动启动

    [root@tracker FastDFS]# vim /etc/rc.d/rc.local
将运行命令行添加进文件：

    /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
## storage安装
**1.安装**  
运行make.sh，确认make成功。期间如果有错误，可能会是缺少依赖的软件包，需安装后再次make

    [root@storage1FastDFS]# ./make.sh
运行make.sh install，确认install成功。

    [root@storage1FastDFS]# ./make.sh install

**2.配置**  

编辑配置文件目录下的storage.conf，设置相关信息并保存。

    [root@storage1FastDFS]# vim /etc/fdfs/storage.conf
一般只需改动以下几个参数即可：

    disabled=false            #启用配置文件
    group_name=godeye#组名，根据实际情况修改
    port=23000#设置storage的端口号
    base_path=/fdfs/storage#设置storage的日志目录（需预先创建）
    store_path_count=1#存储路径个数，需要和store_path个数匹配
    store_path0=/fdfs/storage#存储路径
    tracker_server=172.16.1.202:22122 #tracker服务器的IP地址和端口号
    http.server_port=8080     #设置http端口号

**3.运行**

启动storage，会根据配置文件的设置自动创建多级存储目录，确认启动是否成功。（查看是否对应端口23000是否开始监听）

    [root@storage1 FastDFS]#/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf restart
确认启动成功后，可以运行fdfs_monitor查看storage服务器是否已经登记到tracker服务器

    [root@storage1 FastDFS]# /usr/local/bin/fdfs_monitor /etc/fdfs/storage.conf
看到“172.16.1.203  ACTIVE”即可确认storage运行正常
设置开机自动启动
[root@storage1 FastDFS]# vim /etc/rc.d/rc.local
将运行命令行添加进文件：

    /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf restart
每个group中所有storage的端口号必须一致。
## 扩容
**1.添加tracker**  

直接增加tracker机器即可.集群中的tracker都是对等的,所有的tracker都接受stroage心跳信息.每个tracker是对等的.由客户端来选择使用哪个tracker.  
如果新增加一台tracker server，storage server连接该tracker server，发现该tracker server返回的本组storage server列表比本机记录的要少，就会将该tracker server上没有的storage server同步给该tracker server。

**2.添加group**  

group直接配置好后启动group中的storage即可.而添加group也是集群扩容的方式.
配置好group后,启动新的group,tracker接受新的stroage心跳信息,来完成添加.


**3.group添加storage**  

fastDFS同group内的storage数据是同步的.storage中由专门的线程根据binlog进行文件同步.
当新添加一台storage,会由已有的一台storage将所有数据同步给新的服务器.
新加入的storage server主动连接tracker server，tracker server发现有新的storage server加入，就会将该组内所有的storage server返回给新加入的storage server，并重新将该组的storage server列表返回给该组内的其他storage server；

storage server有7个状态，如下：

    FDFS_STORAGE_STATUS_INIT :初始化，尚未得到同步已有数据的源服务器
    FDFS_STORAGE_STATUS_WAIT_SYNC :等待同步，已得到同步已有数据的源服务器
    FDFS_STORAGE_STATUS_SYNCING :同步中
    FDFS_STORAGE_STATUS_DELETED :已删除，该服务器从本组中摘除（注：本状态的功能尚未实现）
    FDFS_STORAGE_STATUS_OFFLINE :离线
    FDFS_STORAGE_STATUS_ONLINE :在线，尚不能提供服务
    FDFS_STORAGE_STATUS_ACTIVE :在线，可以提供服务

**4.storage添加空间**  

在storage添加硬盘,然后添加store_path,一个group中各台storage的store_path的数量和配置必须一致.添加完成后重启服务,会自动在新添加的目录创建文件夹.

**数据迁移**  

如果新旧IP地址一一对应，而且是一样的，那非常简单，直接将data目录拷贝过去即可。IP不一样的话，会比较麻烦一些。如果使用了V4的自定义server ID特性，那么比较容易，直接将tracker上的IP和ID映射文件storage_ids.conf修改好即可。storage_ids文件可以再源码目录的conf里面找到示例.

如果是用IP地址作为服务器标识，那么需要修改tracker和storage的data目录下的几个数据文件，将旧IP调整为新IP。
注意storage的data目录下有一个.打头的隐藏文件也需要修改。
另外，需要将后缀为mark的IP地址和端口命名的同步位置记录文件名改名。
文件全部调整完成后才能启动集群服务。

tracker server上需要调整的文件列表：

    data/storage_groups_new.dat
    data/storage_servers_new.dat
    data/storage_sync_timestamp.dat

storage server需要调整的文件列表：

    data/.datainit_flag
    data/sync/${ip_addr}${port}.mark：此类文件，需要将文件名中的IP地址调整过来








​             



　　目前项目是tomcat单机部署的，图片、视频也是上传到tomcat目录下，关键是此项目的主要内容还就是针对图片、视频的，这让我非常担忧；文件服务器的应用是必然的，而且时间还不会太久。之前一直有听说fastdfs，但一直没去认真琢磨他，最近才开始去研究它，今天只是去搭建一个简单的单机版，集群版后续再出；至于架构、原理什么我就不写了，网上资料非常多。

## 环境准备

　　系统：Centos6.7

　　fastdfs：到https://github.com/happyfish100下载，都下载最新的：fastdfs-master、libfastcommon-master、fastdfs-nginx-module-master，避免版本问题

　　Linux终端工具：xshell、xftp

​    Linux ip：192.168.1.207

## fastdfs安装

​    上传相关包到/opt下，如图

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609201510699-164925332.png)

### 　　安装zip、unzip

​       [root@fastdfs2 opt]# yum install -y unzip zip

###     解压fastdfs-master.zip

​       [root@fastdfs2 opt]# unzip -o fastdfs-master.zip -d /usr/local

###     编译安装fast

​       [root@fastdfs2 opt]# cd /usr/local/fastdfs-master

​       [root@fastdfs2 fastdfs-master]# ./make.sh

​       报错：./make.sh: line 146: perl: command not found

###     安装perl

​       [root@fastdfs2 fastdfs-master]# yum -y install perl

​       再运行./make.sh，报错：make: cc：命令未找到

###     安装gcc

​       [root@fastdfs2 fastdfs-master]# yum install gcc-c++

​       再运行./make.sh，仍出现如下错误：

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609201706082-20730630.png)

　　　　缺少libfastcommon中的相关基础库

###     安装libfastcommon

​       解压libfastcommon-master.zip

​           [root@fastdfs2 fastdfs-master]# cd /opt

​           [root@fastdfs2 opt]# unzip -o libfastcommon-master.zip -d /usr/local

​       安装libfastcommon

​           [root@fastdfs2 opt]# cd /usr/local/libfastcommon-master/

​           [root@fastdfs2 libfastcommon-master]# ./make.sh

​           [root@fastdfs2 libfastcommon-master]# ./make.sh install

###     再装fastdfs

​       [root@fastdfs2 local]# cd /usr/local/fastdfs-master/

​       [root@fastdfs2 fastdfs-master]# ./make.sh

​       [root@fastdfs2 fastdfs-master]# ./make.sh install

###     拷贝配置文件

​       将fastdfs安装目录下的conf下的文件拷贝到/etc/fdfs/下

​       [root@fastdfs2 fastdfs-master]# cp -r conf/* /etc/fdfs/

​    自此fastdfs安装完成了，接下来配置trackerd和storaged，并启动它们。

### 　　fdfs可执行命令

​    　　[root@fastdfs2 fdfs]# ll /usr/bin/fdfs*

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) View Code

## 配置并启动trackerd

###     修改trackerd.conf

​       不改也可以，但是要保证/home/yuqing/fastdfs路径存在

​       [root@fastdfs2 fdfs]# cd /etc/fdfs/

​       [root@fastdfs2 fdfs]# vi tracker.conf

​       将base_path=/home/yuqing/fastdfs改成base_path=/data/fastdfs

###     创建trackerd数据、日志目录

​       [root@fastdfs2 fdfs]# mkdir -p /data/fastdfs

###     启动trackerd

​       [root@fastdfs2 fdfs]# /usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart

​        查看trackerd进程，如下图：

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202215030-888435762.png)

　　　　说明trackered已经启动起来；其实也可以查看日志：/data/fastdfs/logs/trackerd.log，来判断trackerd是否正常启动起来。

## 配置并启动storaged

###     修改storage.conf

​       [root@fastdfs2 fdfs]# cd /etc/fdfs/

​       [root@fastdfs2 fdfs]# vi storage.conf

​       base_path=/home/yuqing/fastdfs改为：base_path=/data/fastdfs

​       store_path0=/home/yuqing/fastdfs改为：store_path0=/data/fastdfs/storage

​       tracker_server=192.168.209.121:22122改为：tracker_server=192.168.1.207:22122，这个ip改成自己的

###     创建storaged数据、日志目录

​       [root@fastdfs2 fdfs]# mkdir -p /data/fastdfs/storage

###     启动storaged

​       [root@fastdfs2 fdfs]# /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart

​       查看storaged进程，如下图：

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202323907-1189816790.png)

　　　　说明storaged已经启动起来；其实也可以查看日志：/data/fastdfs/logs/storaged.log来判断storaged是否正常启动起来。

## 上传图片测试

###     本地（win环境）安装fastdfs连接驱动

​       从https://github.com/happyfish100/fastdfs-client-java下载源码，我下载的是zip包，解压后目录如下图：

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202423398-356656185.png)

　　　　maven本地安装：mvn clean install

　　　　![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202507601-250740295.png)

　　　　当然也可以用ant构建：ant clean package

### 　　书写测试代码

　　　　代码结构如图

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202605404-1146694492.png)

　　　　fdfs_client_mine.conf：

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) View Code

​       FastdfsClientTest.java：

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) View Code

###     上传图片：mygirl.jpg

​       执行测试代码，当输出如下信息时，表示上传成功：

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) View Code

　　　　我们到服务器上看看，图片确实已经上传了，如下图：

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609202841621-1325463032.png)

　　　　由于现在还没有和nginx整合无法使用http下载。

## FastDFS 和nginx整合

###     fastdfs-nginx-module安装

​       解压

​           [root@fastdfs2 00]# cd /opt

​           [root@fastdfs2 opt]# unzip -o fastdfs-nginx-module-master.zip -d /usr/local

​       拷贝配置文件

​           [root@fastdfs2 opt]# cd /usr/local/fastdfs-nginx-module-master/src

​           [root@fastdfs2 src]# cp mod_fastdfs.conf /etc/fdfs/

​       编辑配置文件

​           [root@fastdfs2 src]# cd /etc/fdfs/

​           [root@fastdfs2 fdfs]# vi mod_fastdfs.conf

​           base_path=/tmp改成：base_path=/data/fastdfs

​           tracker_server=tracker:22122改成：tracker_server=192.168.1.207:22122

​           url_have_group_name = false改成：url_have_group_name = true；#url中包含group名称

​           store_path0=/home/yuqing/fastdfs改成：store_path0=/data/fastdfs/storage

###     nginx安装

​        nginx依赖包安装

​           [root@fastdfs2 fdfs]# cd /opt

​           [root@fastdfs2 opt]# yum -y install zlib zlib-devel openssl openssl--devel pcre pcre-devel

​       解压nginx

​           [root@fastdfs2 opt]# tar -zxvf nginx-1.13.12.tar.gz

​       安装nginx并添加fastdfs模块

​           [root@fastdfs2 opt]# cd nginx-1.13.12

​           [root@fastdfs2 nginx-1.13.12]# ./configure  --prefix=/usr/local/nginx  --add-module=/usr/local/fastdfs-nginx-module-master/src

​           [root@fastdfs2 nginx-1.13.12]# make

​           [root@fastdfs2 nginx-1.13.12]# make install

​       检查nginx模块

​           [root@fastdfs2 nginx-1.13.12]# cd /usr/local/nginx/sbin/

​           [root@fastdfs2 sbin]# ./nginx -V

```
nginx version: nginx/1.13.12
uilt by gcc 4.4.7 20120313 (Red Hat 4.4.7-18) (GCC)
configure arguments: --prefix=/usr/local/nginx --add-module=/usr/local/fastdfs-nginx-module-master/src
```

​           已经把fastdfs模块添加进去了。

​       配置nginx配置文件

​           [root@fastdfs2 sbin]# cd /usr/local/nginx/conf

​           [root@fastdfs2 conf]# vi nginx-fdfs.conf

​           内容如下，ip注意改成自己的：

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) View Code

### 　　启动nginx

​           [root@fastdfs2 conf]# cd /usr/local/nginx/sbin/

​           [root@fastdfs2 sbin]# ./nginx -c /usr/local/nginx/conf/nginx-fdfs.conf

###     访问图片

​       文件路径在上面的上传图片的测试代码中有输入，我们进行拼装下：

​       http://192.168.1.207/group1/M00/00/00/wKgBz1salX-ATR4PAABHO7x65CM553.jpg

![img](https://images2018.cnblogs.com/blog/747662/201806/747662-20180609203328261-1908252066.png)

##  总结

　　1、fastdfs相关包推荐直接到官网下载，能避免因为版本而造成的问题

　　2、上传成功而访问却出现nginx：400问题，极有可能url_have_group_name = false没有改成：url_have_group_name = true；