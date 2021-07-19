# Ceph 集群关闭

[TOC]

## 关闭

先在admin节点执行以下命令关闭集群流量。

```bash
ceph osd set noout
ceph osd set norecover
ceph osd set norebalance
ceph osd set nobackfill
ceph osd set nodown
ceph osd set pause
```

先关闭OSD节点，再关闭monitor节点。

## 开机

先开monitor节点 再开osd节点

所有osd都in后，取消标签。

```bash
ceph osd unset noout
ceph osd unset norecover
ceph osd unset norebalance
ceph osd unset nobackfill
ceph osd unset nodown
ceph osd unset pause
```