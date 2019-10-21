# Linux RAID

## mdadm

用于管理Linux系统中的软件RAID硬盘阵列。

```bash
mdadm [模式] <RAID设备名称> [选项] [成员设备名称]

-a	检测设备名称
-n	指定设备数量
-l	指定RAID级别
-C	创建
-v	显示过程
-f	模拟设备损坏
-r	移除设备
-Q	查看摘要信息
-D	查看详细信息
-S	停止RAID磁盘阵列
```

**实例**

创建阵列，4块硬盘，raid 10

```bash
mdadm -Cv /dev/md0 -a yes -n 4 -l 10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

格式化为ext4格式。

```bash
mkfs.ext4 /dev/md0
```

进行挂载操作。

```bash
mkdir /RAID
mount /dev/md0 /RAID
```

查看/dev/md0磁盘阵列的详细信息，并把挂载信息写入到配置文件中，使其永久生效。

```bash
mdadm -D /dev/md0
echo "/dev/md0 /RAID ext4 defaults 0 0" >> /etc/fstab
```

**损坏磁盘阵列及修复**

确认有一块物理硬盘设备出现损坏不能再继续正常使用后，使用mdadm命令来予以移除：

```bash
#为便于演示，模拟设备损坏
mdadm /dev/md0 -f /dev/sdb
mdadm: set /dev/sdb faulty in /dev/md0

mdadm -D /dev/md0
```

恢复

```bash
umount /RAID
mdadm /dev/md0 -a /dev/sdb
mdadm -D /dev/md0
mount -a
```

**热备盘**

创建一个RAID 5磁盘阵列+备份盘。

```bash
mdadm -Cv /dev/md0 -n 3 -l 5 -x 1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
mdadm -D /dev/md0
```
