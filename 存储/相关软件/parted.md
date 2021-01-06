# Parted

[TOC]

由GNU组织开发的一款功能强大的磁盘分区和分区大小调整工具，与fdisk不同，支持调整分区的大小。作为一种设计用于Linux的工具，它没有构建成处理与fdisk关联的多种分区类型，但是，它可以处理最常见的分区格式，包括：ext2、ext3、fat16、fat32、NTFS、ReiserFS、JFS、XFS、UFS、HFS以及Linux交换分区。

`fdisk`创建操作大于2T的分区，可使用`parted`命令。

**2 种模式：**

- 交互式
   手动按序交互式的创建。
- 命令行模式
   可将命令行写在脚本中，运行脚本实现一键创建；适用于远程批量管理多台主机的场景。


## 向新磁盘写入分区表

要对新驱动器进行分区，必须先为其写入磁盘标签。磁盘标签指示了所用的分区方案。

> 可擦除现有分区表。仅当想重复使用磁盘而不考虑现有数据时使用。如新标签更改了分区边界，现有文件系统中的所有数据都将无法访问。

```bash
# MBR
parted /dev/vdb mklabel msdos
# GPT
parted /dev/vdb mklabel gpt
```

## 创建分区

```bash
mkpart PART-TYPE [FSTYPE] START END
# PART-TYPE 是以下类型之一：
#    1. primary （主分区）
#    2. extended（扩展分区）
#    3. logical （逻辑分区）

# FS-TYPE(文件系统类型)
#    1. ext4
#    2. ext3
#    3. ext2
#    4. xfs
#    5. 其他

# START 和 END 是新分区开始和结束的具体位置。

# START
#  设定磁盘分区起始点；可以为0，numberMiB/GiB/TiB；
#   0   设定当前分区的起始点为磁盘的第一个扇区
#   1G  设定当前分区的起始点为磁盘的1G处开始

# END
#  设定磁盘分区结束点；
#  -1   设定当前分区的结束点为磁盘的最后一个扇区
#  10G  设定当前分区的结束点为磁盘的10G处
```

### 创建MBR分区

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

### 创建GPT分区

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
rm n
# 退出parted
quit
```
## 查询
```bash
# 显示磁盘上的分区表
parted /dev/vda print

print [free|NUMBER|all]
# 显示分区表, 指定编号的分区, 或所有设备的分区表

# 获取受支持的文件系统类型列表
parted /dev/vdb help mkpart
```

默认情况下，parted显示以10的幂次方表示的所有空间大小（KB、MB、GB）。可以使用unit子命令来改变默认设置。

```bash
unit UNIT
# 设置默认输出时表示磁盘大小的单位为 UNIT
# UNIT 的常用取值可以为：
#     B                字节
#     MB、GB、TB        10的幂次方
#     MIB、GiB、TiB     2的幂次方
#     %                占整个磁盘设备的百分之多少
#     compact          人类易读方式，类似于 df 命令中 -h 参数的作用
#     s                扇区
#     cyl              柱面
#     chs              柱面cylinders:磁头heads:扇区sectors 的地址
```



## 帮助选项

```bash
-h, --help                    #显示此求助信息 
help [COMMAND]                #打印通用求助信息，或关于 COMMAND 的信息
-l, --list                    #列出所有设别的分区信息
-i, --interactive             #在必要时，提示用户 
-s, --script                  #从不提示用户 
-v, --version                 #显示版本
```

## 其他命令

```bash
cp [FROM-DEVICE] FROM-MINOR TO-MINOR            #将文件系统复制到另一个分区 
mkfs MINOR 文件系统类型                           #在 MINOR 创建类型为“文件系统类型”的文件系统 
move MINOR 起始点 终止点                         #移动编号为 MINOR 的分区 
name MINOR 名称                                 #将编号为 MINOR 的分区命名为“名称”  
quit                                           #退出程序 
select 设备                                     #选择要编辑的设备 
```



| **命令  **                             | **说明**                                                     |
| -------------------------------------- | ------------------------------------------------------------ |
| set NUMBER FLAG STATE                  | 对指定编号 NUMBER 的分区设置分区标记 FLAG。对于 PC 常用的 msdos 分区表来说，分区标记 FLAG  可有如下值：”boot”（引导）, “hidden”（隐藏）, “raid”（软RAID磁盘阵）, “lvm”（逻辑卷）, “lba”  （LBA，Logic Block Addressing模式）。 状态STATE 的取值是：on 或 off |
| mkfs NUMBER FS-TYPE                    | 对指定编号 NUMBER 的分区创建指定类型 FS-TYPE 的文件系 统。   |
| mkpartfs PART-TYPE FSTYPE START END    | 创建新分区同时创建文件系统。FS-TYPE 是以下类型一：ext2、fat16、fat32、linuxswap、NTFS、reiserfs、ufs 等 |
| cp [FROM-DEVICE] FROM-NUMBER TO-NUMBER | 将分区 FROM-NUMBER 上的文件系统完整地复制到分区TO-NUMBER 中，作为可选项还可以指定一个来源硬盘的设备名称FROM-DEVICE，若省略则在当前设备上进行复制。 |
| move NUMBER START END                  | 将指定编号 NUMBER 的分区移动到从 START 开始 END 结束的位置上。注意：（1）只能将分区移动到空闲空间中。（2）虽然分区被移动了，但它的分区编号是不会改变的 |
| resize NUMBER START END                | 对指定编号 NUMBER 的分区调整大小。分区的开始位置和结束位置由 START 和 END 决定 |
| check NUMBER                           | 检查指定编号 NUMBER 分区中的文件系统是否有什么错误           |
| rescue START END                       | 恢复靠近位置 START 和 END 之间的分区                         |
| mklabel,mktable LABELTYPE              | 创建一个新的 LABEL-TYPE 类型的空磁盘分区表，对于PC而言 msdos 是常用的 LABELTYPE。 若是用 GUID 分区表，LABEL-TYPE 应该为 gpt |

 


## 设定分区label(非必要)

```bash
e2label /dev/sdb1 /gfsdata01
```

