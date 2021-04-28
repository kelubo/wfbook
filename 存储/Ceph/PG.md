# PG

[TOC]

## 计算

```bash
PG总数 = （OSD总数 * 100） / 最大副本数
# 每一个池中的PG总数
PG总数 = （（OSD总数 * 100） / 最大副本数） / 池数
```

## 修改PG和PGP

```bash
# 获取现有的PG和PGP值
ceph osd pool get data pg_num
ceph osd pool get data pgp_num

# 查看池的副本数，rep size 值
ceph osd dump | grep size

# 修改池的PG和PGP
ceph osd pool set data pg_num xxx
ceph osd pool set data pgp_num xxx
```

