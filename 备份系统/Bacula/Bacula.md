# Bacula
## 功能特性
>* 模块化设计
>* 能够备份UNIX、Linux、Windows和Mac OS系统
>* 支持MySQL、PostgreSQL或者SQLite作为后端数据库
>* 支持易用的菜单驱动的命令行控制台
>* 遵守开放源代码许可证
>* 备份可以横跨多个磁带卷
>* 服务器可以在多种平台上运行
>* 可以给备份的每个文件都创建SHA1或者MD5的签名文件
>* 对网络流量和保存在磁带上的数据都可以加密
>* 可以备份超过2GB的文件
>* 支持磁带库和自动换带机
>* 在备份工作前后可以执行脚本或者命令
>* 对整个网络集中做备份管理  

## 模型
![](../../Image/bacula.png)  
控制器：协调备份、恢复和校验操作的守护进程。  
控制台：与控制守护进程交互。  
存储守护进程：读写磁带或者其他备份介质的组件。  
文件守护进程：在美国要备份的系统上运行。  
编目：所备份的每个文件和卷的信息都保存在这个关系数据库中。  
Bacula Rescue CD-ROM  
## 配置步骤
>* 安装Bacula所支持的一种第三方数据库以及Bacula的守护进程。
>* 配置守护进程。
>* 安装和配置客户机上的文件守护进程。
>* 启动守护进程。
>* 用控制台把介质加入存储池。
>* 执行一次备份和恢复模式  

## 配置文件
| 组件 | 文件 | 服务器 |
|----|----|-----|
| 控制守护进程 | bacula-dir.conf | 运行控制守护进程的服务器 |
| 存储守护进程 | bacula-sd.conf | 有存储设备的每台服务器 |
| 文件守护进程 | bacula-fd.conf | 要进行备份的每台客户机 |
| 管理控制台 | bconsole.conf | 用作控制台的每台计算机 |
## 术语
**作业**：job，Bacula运行活动的基本单位。分为两类：备份和恢复。一个作业由一个客户机、一个文件集合、一个存储池和一个计划表共同组成。  
**池**：pool，保存作业的物理介质组。  
**文件集**：fileset，文件系统和单个文件的列表。  
**消息**：message，守护进程之间涉及守护进程和作业状态的通信信息。
## 配置文件
### 公共的配置段
**Director资源**：参数规定了控制器的名字和基本行为。选项设置了其他守护进程与控制器进行通信所采用的通信端口、控制器保存其临时文件的位置，以及控制器一次能处理的并发作业数量。

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
**Messages资源**：

    Message {
    	Name = Standard
    	director = bull-dir = all    
    }
#### 口令
![](../../Image/bacula_passwd.png)
### bacula-dir.conf
**Catalog资源**：将Bacula指向一个特殊的编目数据库。包括一个编目名、一个数据库名和数据库凭证。

    Catalog {
    	Name = MYSQL
    	dbname = "bacula";dbuser = "bacula";dbpassword = "XXXXX"    
    }

**Storage资源**:描述了如何与特定的存储守护进程进行通信,轮到那个存储守护进程负责和它的本地备份设备接口。与硬件无关。

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

**Pool资源**:把备份介质（一般为磁带）划分为给特定备份作业所使用的组。

    Pool {
    	Name = Full_Pool
    	Pool Type = Backup
    	Recycle = yes
    	AutoPrune = yes
    	Storage = TL4000
    	Volume Retention = 365 days
    }

**Schedule资源**：定义了备份作业的时间表。必须要有的参数是名字、日期、和时间说明。

    Schedule {
    	Name = "Nightly"
    	Run = Level=Full Pool=FullPool 1st tue at 20:10
    	Run = Level=Incremental Pool=IncrementalPool wed-mon at 20:10
    }

**Client资源**：标识要备份的计算机。

    Client {
    	Name = harp
    	Address = 192.168.1.28
    	FDPort = 9102
    	Catalog = MYSQL
    	Password = "XXXX"
    }

**FileSet资源**:定义了一个备份作业所包含的或者所排出的文件和目录。

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

**Job资源**:定义了一个特定备份作业默认的参数。

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
### bacula-sd.conf
**Director资源**:控制运行哪些控制器与存储守护进程进行联系。

    Director {
    	Name = bull-dir
    	Password = "XXXXXX"
    }

**Storage资源**：定义了一些基本的工作参数。

    Storage {
	Name = bull-sd
    	SDPort = 9103
    	WorkingDirectory = "/var/bacula/working"
    	Pid Directory = "/var/run"
    	Maximum Concurrent Jobs = 2
    }

**Device资源**:

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

**Autochanger资源**：

    Autochanger {
    	Name = TL4000
    	Device = TL4000-Drive0,TL4000-Driver1
    	Changer Command = "/etc/bacula/mtx-changer %c %o %S %a %d"
    	Changer Device = /dev/changer
    }
### bconsole.conf
    Director {
    	Name = bull-dir
    	DIRport = 9101
    	Address = bull
    	Password = "XXXX"
    }
