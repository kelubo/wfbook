# CLI

[TOC]

## ceph

```bash
ceph mds <COMMAND>
    dump		   #查看MDS map
ceph mon <COMMAND>
    dump        #查看monitor map
    stat        #查看monitor状态

ceph mon_status #查看monitor状态

ceph osd <COMMAND>
    crush dump                             #查看CRUSH map
    ls                                     #查看所有OSD的ID
    dump                                   #查看OSD map
    pool create pool_name pg_num pgp_num   #创建池
         set pool_name size n              #设置副本数
         rename pool_name new_name         #重命名池
    stat                                   #检查OSD map和状态
    tree                                   #检查OSD树形图

ceph pg <COMMAND>
    dump        #查看PG map
```

## rados

```bash
rados [OPTION] COMMAND

    df					#查看集群空间的使用情况
    lspools				#查看RADOS池
    -p <pool_name> ls	#查看池中的对象
```

## service

```bash
service ceph status <COMMAND>
    mon   #检查monitor服务的状态
    osd   #检查单个节点上OSD的状态

# 检查整个集群上OSD的状态,ceph.conf文件必须有所有OSD的所有信息。
service ceph -a status osd
```

