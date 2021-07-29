# CRUSH

[TOC]

## 编辑 CRUSH map

```bash
# 提取已有的CRUSH map
ceph osd getcrushmap -o crushmap.txt

# 反编译CRUSH map
crushtool -d crushmap.txt -o crushmap-decompile

# 使用编辑器编辑CRUSH map
vim crushmap-decompile

# 重新编译新的CRUSH map
crushtool -c crushmap-decompile -o crushmap-compiled

# 将新的CRUSH map 应用到Ceph集群中
ceph osd setcrushmap -i crushmap-compiled
```



```bash
# 添加新的机架
ceph osd crush add-bucket rack01 rack

# 移动主机到指定的机架
ceph osd crush move ceph-node1 rack=rack01

# 移动机架到默认根下
ceph osd crush move rack03 root=default
```

## 算法总结

CRUSH 与一致性哈希最大的区别在于接受的参数多了 cluster map 和 placement rules ，这样就可以根据目前 cluster 的状态动态调整数据位置，同时通过算法得到一致的结果。

## 算法补充

bucket 根据不同场景有四种类型，分别是 Uniform、List、Tree 和 Straw，它们对应运行数据和数据迁移量有不同的 tradeoff ，目前大家都在用 Straw 因此不太需要关心其他。

目前 erasing code 可以大大减小三备份的数据量，但除了会导致数据恢复慢，部分 ceph 支持的功能也是不能直接用的，而且功能仍在开发中不建议使用。
