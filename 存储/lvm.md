# LVM

LVM（逻辑卷管理器）

![第7章 使用RAID与LVM磁盘阵列技术。第7章 使用RAID与LVM磁盘阵列技术。](https://www.linuxprobe.com/wp-content/uploads/2015/02/逻辑卷.png)

常用的LVM部署命令

| 功能/命令 | 物理卷管理 | 卷组管理  | 逻辑卷管理 |
| --------- | ---------- | --------- | ---------- |
| 扫描      | pvscan     | vgscan    | lvscan     |
| 建立      | pvcreate   | vgcreate  | lvcreate   |
| 显示      | pvdisplay  | vgdisplay | lvdisplay  |
| 删除      | pvremove   | vgremove  | lvremove   |
| 扩展      |            | vgextend  | lvextend   |
| 缩小      |            | vgreduce  | lvreduce   |

**第1步**：让新添加的两块硬盘设备支持LVM技术。

```bash
pvcreate /dev/sdb /dev/sdc
```

**第2步**：把两块硬盘设备加入到卷组中，然后查看卷组的状态。

```bash
vgcreate stor /dev/sdb /dev/sdc
vgdisplay
```

**第3步**：切割出一个逻辑卷设备。

在对逻辑卷进行切割时有两种计量单位。第一种是以容量为ab单位，所使用的参数为-L。另外一种是以基本单元的个数为单位，所使用的参数为-l。每个基本单元的大小默认为4MB。

```bash
lvcreate -n vo -l 37 storage
lvdisplay 
```

**第4步**：把生成好的逻辑卷进行格式化，然后挂载使用。

Linux系统会把LVM中的逻辑卷设备存放在/dev设备目录中（实际上是做了一个符号链接），同时会以卷组的名称来建立一个目录，其中保存了逻辑卷的设备映射文件（即/dev/卷组名称/逻辑卷名称）。

```bash
mkfs.ext4 /dev/stor/vo 
```

**扩容逻辑卷**

卸载

```bash
umount /dev/stor/vo
```

**第1步**：把逻辑卷vo扩展至290MB。

```bash
lvextend -L 290M /dev/storage/vo
```

**第2步**：检查硬盘完整性，并重置硬盘容量。

```bash
e2fsck -f /dev/stor/vo
resize2fs /dev/stor/vo
```

**第3步**：重新挂载硬盘设备并查看挂载状态。

```bash
mount -a
```

**缩小逻辑卷**

相较于扩容逻辑卷，在对逻辑卷进行缩容操作时，其丢失数据的风险更大。

```bash
umount /dev/stor/vo
```

**第1步**：检查文件系统的完整性。

```bash
e2fsck -f /dev/storage/vo
```

**第2步**：把逻辑卷vo的容量减小到120MB。

```
resize2fs /dev/stor/vo 120M
lvreduce -L 120M /dev/stor/vo
```

**第3步**：重新挂载文件系统并查看系统状态。

```
mount -a
```

**逻辑卷快照**

LVM的快照卷功能有两个特点：

> 快照卷的容量必须等同于逻辑卷的容量；
>
> 快照卷仅一次有效，一旦执行还原操作后则会被立即自动删除。

**第1步**：使用-s参数生成一个快照卷，使用-L参数指定切割的大小。

```bash
lvcreate -L 120M -s -n SNAP /dev/stor/vo
lvdisplay
```

**第2步**：在逻辑卷所挂载的目录中创建一个100MB的垃圾文件，然后再查看快照卷的状态。可以发现存储空间占的用量上升了。

**第3步**：为了校验SNAP快照卷的效果，需要对逻辑卷进行快照还原操作。在此之前记得先卸载掉逻辑卷设备与目录的挂载。

```bash
umount /dev/stor/vo
lvconvert --merge /dev/storage/SNAP
```

**第4步**：快照卷会被自动删除掉。

**删除逻辑卷**

**第1步**：取消逻辑卷与目录的挂载关联，删除配置文件中永久生效的设备参数。

```bash
umount /dev/stor/vo
vim /etc/fstab
```

**第2步**：删除逻辑卷设备，需要输入y来确认操作。

```bash
[root@linuxprobe ~]# lvremove /dev/stor/vo 
```

**第3步**：删除卷组，此处只写卷组名称即可，不需要设备的绝对路径。

```bash
vgremove storage
```

**第4步**：删除物理卷设备。

```bash
pvremove /dev/sdb /dev/sdc
```

