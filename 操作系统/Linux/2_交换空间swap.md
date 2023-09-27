# 交换空间

交换空间是受Linux内核内存管理子系统控制的磁盘区域。内核使用交换空间，通过保存不活动的内存页面来补充系统RAM。系统RAM和交换空间组合在一起称为虚拟内存。

当系统上的内存使用量超过定义的限制时，内核将搜索RAM，寻找已分配给进程但空闲的内存页。内核将空闲的内存页写入到交换区，并向其他进程重新分配RAM页面。如果某个程序需要访问磁盘上的页面，则内核会找到另一个空闲的内存页，将其写入到磁盘，然后从交换区重新调用所需的页面。

由于交换区位于磁盘上，与RAM相比，交换会比较慢。虽然是用于增加系统RAM，但对于RAM不足以满足工作负载需求的问题，不应将交换空间视为可持续性的解决方案。

| RAM          | 交换空间 | 允许Hibernate时的交换空间 |
| ------------ | -------- | ------------------------- |
| 2GiB或以下   | 2倍RAM   | 3倍RAM                    |
| 2GiB ~ 8GiB  | 同等RAM  | 2倍RAM                    |
| 8GiB ~ 64GiB | 至少4GiB | 1.5倍RAM                  |
| 64GiB以上    | 至少4GiB | 不建议Hibernate           |

> 笔记本电脑和台式机的Hibernate功能会在关闭系统电源之前使用交换空间来保存RAM内容。重新打开系统时，内核将从交换空间恢复RAM内容，无需完全启动系统。交换空间需要超过RAM量。

## 创建交换空间

```bash
parted /dev/vdb
mkpart
Partition name?  []?		swap1
File system type? [ext2]?	linux-swap
Start?						1001MB
End?						1257MB
quit

udevadm settle
```

## 格式化设备

```bash
# 向设备应用交换签名。与其他格式化实用程序不同，mkswap在设备开头写入单个数据块，而将设备的其余部分保留为格式化。
mkswap /dev/vdb2
```

## 激活/关闭交换空间

```bash
swapon /dev/vdb2

swapon -a
# 激活/etc/fstab文件中列出的所有交换空间。

# 持久激活交换空间/etc/fstab
UUID=39e2556b-9358-42fc-9442-c4c734604772	swap	swap	defaults	0 0
# 重启systemctl
systemctl daemon-reload

swapoff
# 停用交换空间。如交换空间具有写入的页面，会尝试将这些页面移动到其他活动交换空间或将其写回到内存中。
```

## 检查可用交换空间

```bash
swapon --show

free
```

## 设置交换空间优先级

默认情况下，系统会按顺序使用交换空间。可以设置优先级，强制按照数据使用交换空间。

在 `/etc/fstab` 中使用 `pri` 选项。默认优先级为-2。数值越大，优先级越高。当交换空间具有相同的优先级时，内核会轮循方式向其中写入。

```bash
UUID=39e2556b-9358-42fc-9442-c4c734604772	swap	swap	pri=4	0 0
```

显示交换空间的优先级

```bash
swapon --show
```

