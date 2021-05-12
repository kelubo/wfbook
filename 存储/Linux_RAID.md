# Linux RAID

[TOC]

## mdadm

用于管理Linux系统中的软件RAID硬盘阵列。

```bash
mdadm [模式] <RAID设备名称> [选项] [成员设备名称]

-a	               #Adds a disk into a current array
-C, —create        #Creates a new RAID array
-D, —detail        #Prints the details of an array
-G, —grow          #Changes the size or shape of an active array
-f                 #Fails a disk in the array
-l, —level         #Specifies level (type) of RAID array to create
-n, —raid-devices  #Specifies the devices in the RAID array
-q, —quiet         #Species not to show output
-S, —stop          #Stops an array
-v, —verbose       #Provides verbose output

-r	移除设备
-Q	查看摘要信息
```

### 创建阵列

```bash
# RAID 10，4块硬盘
mdadm -Cv /dev/md0 -a yes -n 4 -l 10 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# RAID 1
mdadm -Cv /dev/md0 -l 1 -n 2 /dev/sdc /dev/sdd
```

格式化为ext4格式；进行挂载操作。

```bash
mkfs.ext4 /dev/md0
mkdir /RAID
mount /dev/md0 /RAID
```

查看/dev/md0磁盘阵列的详细信息，并把挂载信息写入到配置文件中，使其永久生效。

```bash
mdadm -D /dev/md0
echo "/dev/md0 /RAID ext4 defaults 0 0" >> /etc/fstab
```

### 损坏磁盘阵列及修复

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

## Other

查看新创建的 RAID 设备：

    cat /proc/mdstat
    Personalities : [raid1]
    md0 : active raid1 sdd1[1] sdc1[0]
    1044181 blocks super 1.2 [2/2] [UU]
    
    unused devices: <none>
