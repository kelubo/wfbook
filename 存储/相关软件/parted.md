# Parted

## 向新磁盘写入分区表

要对新驱动器进行分区，必须先为其写入磁盘标签。磁盘标签指示了所用的分区方案。

> 可擦除现有分区表。仅当想重复使用磁盘而不考虑现有数据时使用。如新标签更改了分区边界，现有文件系统中的所有数据都将无法访问。

```bash
# MBR
parted /dev/vdb mklabel msdos
# GPT
parted /dev/vdb mklabel gpt
```

## 创建MBR分区

```bash
# 指定要在其上创建分区的磁盘设备
parted /dev/vdb
# 创建新的主分区或扩展分区
mkpart
Partition type? primary/extended?	primary
File system type? [ext2]?			xfs
# 指定要在分区上创建的文件系统类型。并不会再分区上创建文件系统，仅指示分区类型。
Start?								2048s
# s后缀提供了扇区的值。可以使用MIB、GiB、TiB、MB、GB和TB后缀。如未提供，默认为MB。可以舍入所提供的值，满足磁盘的限制条件。
# parted启动时，会检索设备的磁盘拓扑。利用这些信息，可以确保所提供的起始位置能让分区与磁盘结构对齐，对于获得最佳性能至关重要。对于大多数磁盘，假设起始扇区为2048的倍数较为安全。
End?								1000MB
# 指定应结束新分区的磁盘扇区。
quit
# 退出
udevadm settle
# 此命令会等待系统检测新分区并在/dev目录下创建关联的设备文件，只有在完成上述操作后，才会返回。

# 交互模式实现
parted /dev/vdb mkpart primary xfs 2048s 1000MB
```

## 创建GPT分区

```bash
# 指定要在其上创建分区的磁盘设备
parted /dev/vdb
# 创建新的主分区或扩展分区
mkpart
Partition name? []?					usersdata
# 每个分区都会获得一个名称。
File system type? [ext2]?			xfs
# 指定要在分区上创建的文件系统类型。并不会再分区上创建文件系统，仅指示分区类型。
Start?								2048s
# s后缀提供了扇区的值。可以使用MIB、GiB、TiB、MB、GB和TB后缀。如未提供，默认为MB。可以舍入所提供的值，满足磁盘的限制条件。
End?								1000MB
# 指定应结束新分区的磁盘扇区。
quit
# 退出
udevadm settle
# 此命令会等待系统检测新分区并在/dev目录下创建关联的设备文件，只有在完成上述操作后，才会返回。

# 交互模式实现
parted /dev/vdb mkpart usersdata xfs 2048s 1000MB
```

## 删除分区

```bash
# 指定包含要删除的分区的磁盘
parted /dev/vdb
# 确定要删除的分区的分区编号
print
# 删除分区
rm 1
# 退出parted
quit
```

```bash
# 显示磁盘上的分区表
parted /dev/vda print
# 获取受支持的文件系统类型列表
parted /dev/vdb help mkpart
```

默认情况下，parted显示以10的幂次方表示的所有空间大小（KB、MB、GB）。可以使用unit子命令来改变默认设置，接受以下参数：

* s	                          扇区
* B                             字节
* MIB、GiB、TiB     2的幂次方
* MB、GB、TB        10的幂次方



