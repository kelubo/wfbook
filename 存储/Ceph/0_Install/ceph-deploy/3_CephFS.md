# CephFS

[TOC]

## 建立MDS服务器

```bash
ceph-deploy mds create node1
```

## 创建两个池

```bash
ceph osd pool create test1 256
ceph osd pool create test2 256
# 最后的数字是PG的数量
```

## 创建cephfs文件系统

```bash
ceph fs new cephfs test2 test1
# 默认第一个池会存储元数据
# 一个ceph只能创建一个cephfs
```

## cephfs的删除

remove所有节点上的ceph

```bash
ceph-deploy purge node{1..4}
```

清除所有数据

```bash
ceph-deploy purgedata node{1..4}
```

清除所有秘钥文件

```bash
ceph-deploy forgetkeys
```
