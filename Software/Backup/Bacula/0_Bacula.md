# Bacula
Bacula 是一组计算机程序，允许系统管理员管理不同类型计算机网络中计算机数据的备份，恢复和验证。Bacula 还可以完全在一台计算机上运行，并可以备份到各种类型的介质，包括磁带和磁盘。

从技术上讲，它是一个基于网络客户端/服务器的备份程序。Bacula 相对易于使用和高效，同时提供许多高级存储管理功能，可以轻松查找和恢复丢失或损坏的文件。由于其模块化设计，Bacula 可从小型单计算机系统扩展到由位于大型网络上的数百台计算机组成的系统。

 If you are currently using a program such as tar, dump, or bru to backup your computer data, and you would like a network solution, more flexibility, or catalog services, Bacula will most likely provide the additional features you want. However, if  you are new to Unix systems or do not have offsetting experience with a  sophisticated backup package, the Bacula project does not recommend using Bacula as it is much more difficult to setup and use than tar or dump. 

如果您目前正在使用tar、dump或bru等程序来备份计算机数据，并且您想要网络解决方案、更大的灵活性或目录服务，Bacula很可能会提供您想要的其他功能。但是，如果你是Unix系统的新手，或者没有复杂备份包的补偿经验，Bacula项目不建议使用Bacula，因为它比tar或dump更难安装和使用。

如果你想让Bacula像上面提到的简单程序一样工作，并写在你放在驱动器中的任何磁带上，那么你会发现使用Bacula很困难。Bacula旨在按照您指定的规则保护您的数据，这意味着只有在万不得已时才重用磁带。可以“强制”Bacula重写驱动器中的任何磁带，但是使用更简单的程序进行这种操作更容易和更有效。

如果您想要一个可以写入多个卷的备份程序（即不受磁带驱动器容量的限制），Bacula很可能可以满足您的需求。此外，相当多的Bacula用户报告说，Bacula比其他等效程序更容易安装和使用。

如果您目前正在使用复杂的商业软件包，如Legato Networker。ArcserveIT、Arkeia或PerfectBackup+，您可能会对Bacula感兴趣，它提供了许多相同的功能，并且是根据Affero GPL版本3软件许可证提供的免费软件。

 If you want Bacula to behave like the above mentioned simple programs and write over any tape that you  put in the drive, then you will find working with Bacula difficult. Bacula is designed to protect your data following the rules you specify, and  this means reusing a tape only as the last resort. It is possible to “force” Bacula to write over any tape in the drive, but it is easier and more efficient to use a simpler program for that kind of operation. 

 If you would like a backup program that can write to multiple volumes (i.e. is not limited by your tape drive capacity), Bacula can most likely fill your needs. In addition, quite a number of Bacula users report that Bacula is simpler to setup and use than other equivalent programs. 

 If you are currently using a sophisticated commercial package  such as Legato Networker. ARCserveIT, Arkeia, or PerfectBackup+, you may be interested in Bacula, which provides many of the same features and is free software available under the Affero [GPL](https://www.bacula.org/13.0.x-manuals/en/main/Acronyms.html#bacronyms_gpl) Version 3 software license. 

## 功能特性

* 模块化设计
* 能够备份 UNIX、Linux、Windows 和 Mac OS 系统
* 支持 MySQL、PostgreSQL 或者 SQLite 作为后端数据库
* 支持易用的菜单驱动的命令行控制台
* 遵守开放源代码许可证
* 备份可以横跨多个磁带卷
* 服务器可以在多种平台上运行
* 可以给备份的每个文件都创建 SHA1 或者 MD5 的签名文件
* 对网络流量和保存在磁带上的数据都可以加密
* 可以备份超过 2GB 的文件
* 支持磁带库和自动换带机
* 在备份工作前后可以执行脚本或者命令
* 对整个网络集中做备份管理

## 模型
 ![](../../../Image/bacula.png)

**控制器 Director (DIR)：** 协调备份、恢复和校验操作的守护进程。  
**控制台 Console：** 与控制守护进程交互。  
**存储守护进程 Storage Daemon (SD)：** 读写磁带或者其他备份介质的组件。  
**文件守护进程 File Daemon (FD)：** 在每个要备份的系统上运行。  
**编目 Catalog：** 所备份的每个文件和卷的信息都保存在这个关系数据库中。  
**Bacula Rescue CD-ROM**  

## 术语
**作业**：job，Bacula运行活动的基本单位。分为两类：备份和恢复。一个作业由一个客户机、一个文件集合、一个存储池和一个计划表共同组成。  
**池**：pool，保存作业的物理介质组。  
**文件集**：fileset，文件系统和单个文件的列表。  
**消息**：message，守护进程之间涉及守护进程和作业状态的通信信息。

## 配置文件
| 组件 | 文件 | 服务器 |
|----|----|-----|
| 控制守护进程 | bacula-dir.conf | 运行控制守护进程的服务器 |
| 存储守护进程 | bacula-sd.conf | 有存储设备的每台服务器 |
| 文件守护进程 | bacula-fd.conf | 要进行备份的每台客户机 |
| 管理控制台 | bconsole.conf | 用作控制台的每台计算机 |

## 安装步骤
1.配置主机名

```bash
bacula.private.example.com
```

2.关闭 selinux

3.安装 Bacula 和 MariaDB Server

```bash
yum install bacula-director bacula-storage bacula-console bacula-client
yum install mariadb-server
```

4.启动 MySQL

```bash
systemctl start mariadb
```

5.创建 Bacula database user 和 tables

```bash
/usr/libexec/bacula/grant_mysql_privileges
/usr/libexec/bacula/create_mysql_database -u root
/usr/libexec/bacula/make_mysql_tables -u bacula
```

6.运行交互脚本

```bash
mysql_secure_installation
```

7.设置 Bacula database user 密码

```sql
mysql -u root -p
UPDATE mysql.user SET Password=PASSWORD('bacula_db_password') WHERE User='bacula';
FLUSH PRIVILEGES;
exit
```

8.设置 MariaDB 开机自启动

```bash
systemctl enable mariadb
```

9.设置 Bacula 使用 MySQL Library

默认情况下，Bacula 使用 PostgreSQL library 。修改成使用 MySQL library 。

```bash
alternatives --config libbaccats.so
```

显示如下提示，键入１
```bash
There are 3 programs which provide 'libbaccats.so'.
Selection    Command
-----------------------------------------------
  1           /usr/lib64/libbaccats-mysql.so
  2           /usr/lib64/libbaccats-sqlite3.so
*+3           /usr/lib64/libbaccats-postgresql.so`

Enter to keep the current selection[+], or type selection number:
```
10.创建备份和还原目录

```bash
sudo mkdir -p /bacula/backup /bacula/restore
sudo chown -R bacula:bacula /bacula
sudo chmod -R 700 /bacula
```

11.配置Bacula Director
```bash
Director {                            # define myself
  Name = bacula-dir
  DIRport = 9101                # where we listen for UA connections
  QueryFile = "/etc/bacula/query.sql"
  WorkingDirectory = "/var/spool/bacula"
  PidDirectory = "/var/run"
  Maximum Concurrent Jobs = 1
  Password = "@@DIR_PASSWORD@@"         # Console password
  messages = Daemon
  DirAddress = 127.0.0.1    #添加这一行
}
```
Update Storage Address
```bash
Storage {
  Name = File
# Do not use "localhost" here
  Address =  backup_server_private_FQDN                # N.B. Use a fully qualified name here
  SDPort = 9103
  Password = "@@SD_PASSWORD@@"
  Device = FileStorage
  Media Type = File
}
```
配置 Catalog Connection
```bash
# Generic catalog service
Catalog {
  Name = MyCatalog
# Uncomment the following line if you want the dbi driver
# dbdriver = "dbi:postgresql"; dbaddress = 127.0.0.1; dbport =
  dbname = "bacula"; dbuser = "bacula"; dbpassword = " bacula_db_password"
}
```
配置Pool
```bash
# File Pool definition
Pool {
  Name = File
  Pool Type = Backup
   Label Format = Local-
  Recycle = yes                       # Bacula can automatically recycle    Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}
```
检查Director的配置
```bash
bacula-dir -tc /etc/bacula/bacula-dir.conf
```
12.Storage Daemon

```bash
Storage {                             # definition of myself
  Name = BackupServer-sd
  SDPort = 9103                  # Director's port
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/var/run/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = backup_server_private_FQDN
}
```
配置Storage Device
```bash
Device {
  Name = FileStorage
  Media Type = File
  Archive Device =  /bacula/backup
  LabelMedia = yes;                   # lets Bacula label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
}
```
验证Storage Daemon配置文件
```bash
bacula-sd -tc /etc/bacula/bacula-sd.conf
```
13.设置Bacula组件的密码

 ![](../../../Image/bacula_passwd.png)

生成Director的密码
```bash
DIR_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
sed -i "s/@@DIR_PASSWORD@@/${DIR_PASSWORD}/" /etc/bacula/bacula-dir.conf
sed -i "s/@@DIR_PASSWORD@@/${DIR_PASSWORD}/" /etc/bacula/bconsole.conf
```
配置Storage Daemon的密码
```bash
SD_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
sed -i "s/@@SD_PASSWORD@@/${SD_PASSWORD}/" /etc/bacula/bacula-sd.conf
sed -i "s/@@SD_PASSWORD@@/${SD_PASSWORD}/" /etc/bacula/bacula-dir.conf
```
配置本地File Daemon(Bacula客户端)的密码
```bash
FD_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
sed -i "s/@@FD_PASSWORD@@/${FD_PASSWORD}/" /etc/bacula/bacula-dir.conf
sed -i "s/@@FD_PASSWORD@@/${FD_PASSWORD}/" /etc/bacula/bacula-fd.conf
```
14.启动Bacula组件

```bash
systemctl start bacula-dir
systemctl start bacula-sd
systemctl start bacula-fd
```
开机自动启动
```bash
systemctl enable bacula-dir
systemctl enable bacula-sd
systemctl enable bacula-fd
```
15.测试备份任务

```bash
bconsole
```
创建Label
```bash
label
```
会提示输入一个卷名
```bash
Enter new Volume name: MyVolume
```
选择使用哪个_Pool_,选择2
```bash
Select the Pool (1-3):
2
```
手动运行备份任务
```bash
run
```
会提示你选择一个任务.我们要执行的是"BackupLocalFiles",选择"1"就好了:
```bash
Select Job resource (1-3):
1
```
在"Run Backup job"这个环节,检查下详细信息,然后输入"yes"来运行这个任务:
```bash
yes
```
使用下面的命令检查消息:
```bash
messages
```
另一个查看任务状态的方法是检查Director的状态.在bconsole里执行:
```bash
status director
```
如果运行正常,你应该可以看到你的任务正在运行.像下面这样:
```bash
Running Jobs:
Console connected at 09-Apr-15 12:16
 JobId Level   Name                       Status
======================================================================
     3 Full    BackupLocalFiles.2015-04-09_12.31.41_06 is  running
====
```
当任务完成,它会移到已终止任务(Terminated Jobs)的报告里面,像下面这样:
```bash
Terminated Jobs:
 JobId  Level    Files      Bytes   Status   Finished        Name
====================================================================
     3  Full    161,124    877.5 M   OK       09-Apr-15 12:34 BackupLocalFiles
```
16.测试恢复任务
```bash
restore all
```
出现一个有很多选项的菜单,来确认那个是需要被恢复的.
```bash
Select item (1-13):
5
```
接下来讲问你选择哪个FileSet.选择"Full set",即选择2:
```bash
Select FileSet resource (1-2):
2
```
微调自己的选择,可以通过"cd"和"ls"命令切换目录和列出文件,使用"mask"标记要被恢复的,"unmask"标记不被恢复.可以通过键入"help"查看完整的命令列表.
完成选择之后.敲入:
```
done
```
确认你想要运行这个恢复任务:
```
OK to run? (yes/mod/no):
yes
```
查看消息和状态
```
messages
```
查看Director状态是一种很好的方式用来查看恢复任务的状况:
```
status director
```
键入_exit_退出Bacula Console:
```
exit
```

## 配置文件

### 公共的配置段
**Director资源**：参数规定了控制器的名字和基本行为。选项设置了其他守护进程与控制器进行通信所采用的通信端口、控制器保存其临时文件的位置，以及控制器一次能处理的并发作业数量。

```bash
Director {
	Name = bull-dir
	DIRport = 9101
	Query File = "/etc/bacula/query.sql"
	Working Directory = "/var/Bacula/working"
	Pid Directory = "/var/run"
	Maximum Concurrent Jobs = 1
	Password = "XXXX"
	Messages = Standard
}
```
**Messages资源**：

```bash
Message {
	Name = Standard
	director = bull-dir = all    
}
```

### bacula-dir.conf
**Catalog资源**：将Bacula指向一个特殊的编目数据库。包括一个编目名、一个数据库名和数据库凭证。

```bash
Catalog {
	Name = MYSQL
	dbname = "bacula";dbuser = "bacula";dbpassword = "XXXXX"    
}
```

**Storage资源**:描述了如何与特定的存储守护进程进行通信,轮到那个存储守护进程负责和它的本地备份设备接口。与硬件无关。

```bash
Storage {
	Name = TL4000
	Address = bull
	SDPort = 9103
	Password = "XXXXX"
	Device = TL4000
	Autochanger = yes
	Maximum Concurrent Jobs = 2
	Media Type = LTO-3
}
```

**Pool资源**:把备份介质（一般为磁带）划分为给特定备份作业所使用的组。

```bash
Pool {
	Name = Full_Pool
	Pool Type = Backup
	Recycle = yes
	AutoPrune = yes
	Storage = TL4000
	Volume Retention = 365 days
}
```

**Schedule资源**：定义了备份作业的时间表。必须要有的参数是名字、日期、和时间说明。

```bash
Schedule {
	Name = "Nightly"
	Run = Level=Full Pool=FullPool 1st tue at 20:10
	Run = Level=Incremental Pool=IncrementalPool wed-mon at 20:10
}
```

**Client资源**：标识要备份的计算机。

```bash
Client {
	Name = harp
	Address = 192.168.1.28
	FDPort = 9102
	Catalog = MYSQL
	Password = "XXXX"
}
```

**FileSet资源**:定义了一个备份作业所包含的或者所排出的文件和目录。

```bash
FileSet {
	Name = "harp"
	Include {
		Options {
			signature=SHA1
			compression=GZIP
		}
		File = "/"
		File = "/boot"
		File = "/var"
	}
	Exclude = {/proc /tmp /.journal /.fsck}
}
```

**Job资源**:定义了一个特定备份作业默认的参数。

```bash
Job {
	Name = "harp"
	JobDefs = DefaultJob
	Level = Full
	Write Bootstrap = "/bacula/bootstraps/harp.bsr"
	Client = harp
	FileSet = harp
	Pool = Full_Pool
	Incremental Backup Pool = Incremental_Pool
	Schedule = "Nightly"
	Prefer Mounted Volume = no
	Max Run Time = 36000
}
```
### bacula-sd.conf
**Director资源**:控制运行哪些控制器与存储守护进程进行联系。

```bash
Director {
	Name = bull-dir
	Password = "XXXXXX"
}
```

**Storage资源**：定义了一些基本的工作参数。

```bash
Storage {
Name = bull-sd
	SDPort = 9103
	WorkingDirectory = "/var/bacula/working"
	Pid Directory = "/var/run"
	Maximum Concurrent Jobs = 2
}
```

**Device资源**:

```bash
Device {
	Name = TL4000-Drive0
	Media Type = LTO-3
	Archive Device = /dev/nst0
	AutomaticMount = yes
	AlwaysOpen = yes
	RemovableMedia = yes
	RandomAccess = no
	Autochanger = yes
}
```

**Autochanger资源**：

```bash
Autochanger {
	Name = TL4000
	Device = TL4000-Drive0,TL4000-Driver1
	Changer Command = "/etc/bacula/mtx-changer %c %o %S %a %d"
	Changer Device = /dev/changer
}
```
### bconsole.conf
```bash
Director {
	Name = bull-dir
	DIRport = 9101
	Address = bull
	Password = "XXXX"
}
```
