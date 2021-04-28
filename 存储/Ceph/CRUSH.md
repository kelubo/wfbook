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

