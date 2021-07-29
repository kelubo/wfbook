# CRUSH

[TOC]

## 简介

CRUSH (Controlled Replication Under Scalable Hashing)，是一种数据分发算法，类似于哈希和一致性哈希。哈希的问题在于数据增长时不能动态加 Bucket，一致性哈希的问题在于加 Bucket 时数据迁移量比较大，其他数据分发算法依赖中心的 Metadata 服务器来存储元数据，效率较低，CRUSH 则是通过计算、接受多维参数的来解决动态数据分发的场景。

## 算法基础

CRUSH 算法接受的参数包括 cluster map，也就是硬盘分布的逻辑位置，例如这有多少个机房、多少个机柜、硬盘是如何分布的等等。cluster map 是类似树的多层结果，子节点是真正存储数据的 device，每个 device 都有 id 和权重，中间节点是 bucket，bucket 有多种类型用于不同的查询算法，例如一个机柜一个机架一个机房就是 bucket。

另一个参数是 placement rules，它指定了一份数据有多少备份，数据的分布有什么限制条件，例如同一份数据不能放在同一个机柜里等的功能。每个rule就是一系列操作，take 操作就是就是选一个 bucket，select 操作就是选择 n 个类型是 t 的项，emit 操作就是提交最后的返回结果。select 要考虑的东西主要包括是否冲突、是否有失败和负载问题。

算法的还有一个输入是整数 x，输出则是一个包含 n 个目标的列表 R，例如三备份的话输出可能是 [1, 3, 5] 。

## 算法解读

![](../../Image/c/crush_algorithm.png)

这里是三个操作的伪代码，take 和 emit 很好理解，select 主要是遍历当前bucket，如果出现重复、失败或者超载就跳过，其中稍微复杂的 “first n” 部分是一旦遇到失败，第一种情况是直接使用多备份，第二种情况是使用 erasing code基本可以忽略。

![](D:/Git/ceph_from_scratch/architecture/crush_algorithm_easy.png)

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
