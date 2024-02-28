# Hadoop

[TOC]

官网：http://hadoop.apache.org/

 ![](../../Image/h/hadoop.jpg)

Hadoop 是一款由 Apache 基金会用 Java 语言开发的分布式开源软件框架，用户可以在不了解分布式底层细节的情况下，使用简单的编程模型，开发分布式程序，充分利用集群的能力进行高速运算和存储。它的设计是从单个服务器扩展到数千个机器，每个都提供本地计算和存储。是一种用于管理大数据的基本工具。

Hadoop 的核心部件是 HDFS（Hadoop Distributed File System）和 MapReduce：

- HDFS

  是一个分布式文件系统，可对应用程序数据进行分布式存储和读取。

- MapReduce

  是一个分布式计算框架，MapReduce 的核心思想是把计算任务分配给集群内的服务器执行。通过对计算任务的拆分（Map 计算和 Reduce 计算），再根据任务调度器（JobTracker）对任务进行分布式计算。

## 组件
1. **Hadoop Common (Hadoop Stack)**，Hadoop的基础，包含主要服务和基本进程；包含必要的Java归档文件(jar)和用于启动的脚本；提供了源代码和文档，以及贡献者相关的内容。
2. **HDFS (Hadoop Distributed File System)**，提供一个分布式的文件系统。
3. **MapReduce**，一个编程组件，用于处理和读取大型数据集。
4. **YARN**，是一项用于提供执行应用程序所需的计算资源（CPU,内存等）的框架。
5. **ZooKeeper**，分布式系统环境下的信息保管员。

## 安装

### 安装前准备
#### 支持平台

- GNU/Linux
- Windows

#### 依赖软件

1. Java™

   | Hadoop             | 7    | 8    | 11           |
   | ------------------ | ---- | ---- | ------------ |
   | 3.3 or upper       |      | Y    | runtime only |
   | 3.0.x  ---  3.2.x  |      | Y    |              |
   | 2.7.x  ---  2.10.x | Y    | Y    |              |

   

2. ssh must be installed and sshd must be running to use the Hadoop  scripts that manage remote Hadoop daemons if the optional start and stop scripts are to be used. Additionally, it is recommmended that pdsh also be installed for better ssh resource management.

   如果要使用可选的启动和停止脚本，则必须安装ssh并运行sshd才能使用管理远程Hadoop守护进程的Hadoop脚本。此外，还建议安装pdsh以更好地管理ssh资源。

   ```bash
   # Ubuntu Linux
   sudo apt-get install ssh
   sudo apt-get install pdsh
   
   # CentOS 8
   
   ```

### Single Node Cluster

#### 下载软件包

```bash
wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
```

#### 准备启动 Hadoop Cluster

解压软件包。编辑 `etc/hadoop/hadoop-env.sh` 去定义一些参数：

```bash
# set to the root of your Java installation
export JAVA_HOME=/usr/java/latest
```

Try the following command:

```bash
bin/hadoop
```

This will display the usage documentation for the hadoop script.

Now you are ready to start your Hadoop cluster in one of the three supported modes:

- [Local (Standalone) Mode](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Standalone_Operation)
- [Pseudo-Distributed Mode](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation)
- [Fully-Distributed Mode](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Fully-Distributed_Operation)

#### Standalone Operation

By default, Hadoop is configured to run in a non-distributed mode, as a single Java process. This is useful for debugging.

The following example copies the unpacked conf directory to use as  input and then finds and displays every match of the given regular  expression. Output is written to the given output directory.

```
  $ mkdir input
  $ cp etc/hadoop/*.xml input
  $ bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.2.jar grep input output 'dfs[a-z.]+'
  $ cat output/*
```

#### Pseudo-Distributed Operation

Hadoop can also be run on a single-node in a pseudo-distributed mode where each Hadoop daemon runs in a separate Java process.

### Configuration

Use the following:

etc/hadoop/core-site.xml:

```
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

etc/hadoop/hdfs-site.xml:

```
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
```

### Setup passphraseless ssh

Now check that you can ssh to the localhost without a passphrase:

```
  $ ssh localhost
```

If you cannot ssh to localhost without a passphrase, execute the following commands:

```
  $ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  $ chmod 0600 ~/.ssh/authorized_keys
```

### Execution

The following instructions are to run a MapReduce job locally. If you want to execute a job on YARN, see [YARN on Single Node](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#YARN_on_Single_Node).

1. Format the filesystem:

   ```
     $ bin/hdfs namenode -format
   ```

2. Start NameNode daemon and DataNode daemon:

   ```
     $ sbin/start-dfs.sh
   ```

   The hadoop daemon log output is written to the `$HADOOP_LOG_DIR` directory (defaults to `$HADOOP_HOME/logs`).

3. Browse the web interface for the NameNode; by default it is available at:

   - NameNode - `http://localhost:9870/`

4. Make the HDFS directories required to execute MapReduce jobs:

   ```
     $ bin/hdfs dfs -mkdir /user
     $ bin/hdfs dfs -mkdir /user/<username>
   ```

5. Copy the input files into the distributed filesystem:

   ```
     $ bin/hdfs dfs -mkdir input
     $ bin/hdfs dfs -put etc/hadoop/*.xml input
   ```

6. Run some of the examples provided:

   ```
     $ bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.2.jar grep input output 'dfs[a-z.]+'
   ```

7. Examine the output files: Copy the output files from the distributed filesystem to the local filesystem and examine them:

   ```
     $ bin/hdfs dfs -get output output
     $ cat output/*
   ```

   or

   View the output files on the distributed filesystem:

   ```
     $ bin/hdfs dfs -cat output/*
   ```

8. When you’re done, stop the daemons with:

   ```
     $ sbin/stop-dfs.sh
   ```

### YARN on a Single Node

You can run a MapReduce job on YARN in a pseudo-distributed mode by  setting a few parameters and running ResourceManager daemon and  NodeManager daemon in addition.

The following instructions assume that 1. ~ 4. steps of [the above instructions](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Execution) are already executed.

1. Configure parameters as follows:

   `etc/hadoop/mapred-site.xml`:

   ```
   <configuration>
       <property>
           <name>mapreduce.framework.name</name>
           <value>yarn</value>
       </property>
       <property>
           <name>mapreduce.application.classpath</name>
           <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
       </property>
   </configuration>
   ```

   `etc/hadoop/yarn-site.xml`:

   ```
   <configuration>
       <property>
           <name>yarn.nodemanager.aux-services</name>
           <value>mapreduce_shuffle</value>
       </property>
       <property>
           <name>yarn.nodemanager.env-whitelist</name>
           <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
       </property>
   </configuration>
   ```

2. Start ResourceManager daemon and NodeManager daemon:

   ```
     $ sbin/start-yarn.sh
   ```

3. Browse the web interface for the ResourceManager; by default it is available at:

   - ResourceManager - `http://localhost:8088/`

4. Run a MapReduce job.

5. When you’re done, stop the daemons with:

   ```
     $ sbin/stop-yarn.sh
   ```

#### Fully-Distributed Operation

For information on setting up fully-distributed, non-trivial clusters see [Cluster Setup](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html).

下载Hadoop安装包

解压Hadoop安装包（只在master做）

确保 network 网络已经配置好，使用Xftp等类似工具进行上传，把 hadoop-2.7.5.tar.gz 上传到 /opt/hadoop 目录内。上传完成后，在 master 主机上执行以下代码：

```
cd /opt/hadoop
```

进入/opt/hadoop目录后，执行解压缩命令：

```
tar -zxvf hadoop-2.7.5.tar.gz
```

回车后系统开始解压，屏幕会不断滚动解压过程，执行成功后，系统在hadoop目录自动创建hadoop-2.7.5子目录。

然后修改文件夹名称为“hadoop”，即hadoop安装目录，执行修改文件夹名称命令：

```
mv hadoop-2.7.5 hadoop
```

注意：也可用Xftp查看相应目录是否存在，确保正确完成。

我们进入安装目录，查看一下安装文件，如果显示如图文件列表，说明压缩成功。

配置hadoop之前做好准备工作

1.修改主机名称，我这里创建了三个虚拟主机，分别命名node-1，node-2，node-3，进入 network 文件删掉里面的内容直接写上主机名就可以了

```
vi /etc/sysconfig/network
```

2.映射 IP 和主机名，之后 reboot 重启主机

```
[root@node-1 redis-cluster]# vim /etc/hosts
192.168.0.1 node-1
192.168.0.2 node-2
192.168.0.3 node-3
```

3.检测防火墙（要关闭防火墙），不同系统的防火墙关闭方式不一样，以下做个参考即可

```
1.service iptables stop  关闭
2.chkconfig iptables off  强制关闭  除非手动开启不然不会自动开启
3.chkconfig iptanles  查看
4.service  iptables status 查看防火墙状态
```

4.ssh 免密码登录

输入命令：ssh-keygen -t rsa 然后点击四个回车键，如下图所示：

![img](https://img-blog.csdn.net/20180622172808801?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Fzc3N5eXc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

然后通过 ssh-copy-id  对应主机 IP，之后通过“ssh 主机名/IP” 便可以不输入密码即可登录相应的主机系统

![img](https://img-blog.csdn.net/20180622172850796?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Fzc3N5eXc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

开始配置 Hadoop 相关文件

上传 hadoop 安装包解压后进入 hadoop-2.7.6/etc/hadoop 目录下
以下所有的 <property> </property> 都是写在各自相应配置文件末尾的 <configuration> 标签里面

**第一个 hadoop-env.sh

**

```
vi hadoop-env.sh
export JAVA_HOME=/usr/java/jdk1.8.0_171   #JAVA_HOME写上自己jdk 的安装路径
```

**第二个 ：core-site.xml**

```
vi <strong>core-site.xml</strong>
<!-- 指定Hadoop所使用的文件系统schema（URI），HDFS的老大（NameNode）的地址 -->
<property>
	<name>fs.defaultFS</name>
	<value>hdfs://node-1:9000</value>
</property>
<!-- 定Hadoop运行是产生文件的存储目录。默认 -->
<property>
	<name>hadoop.tmp.dir</name>
	<value>/export/data/hddata</value>
</property>
```

**第三个： hdfs-site.xml

**

```
vi <strong>hdfs-site.xml</strong>
<!-- 指定HDFS副本的数量，不修改默认为3个 -->
<property>
	<name>dfs.replication</name>
	<value>2</value>
</property>
<!-- dfs的SecondaryNameNode在哪台主机上 -->
<property>
	<name>dfs.namenode.secondary.http-address</name>
	<value>node-2:50090</value>
</property>
```

**第四个： mapred-site.xml**

```
mv mapred-site.xml.template mapred-site.xml
vi mapred-site.xml

<!-- 指定MapReduce运行是框架，这里指定在yarn上，默认是local -->
<property>
	<name>mapreduce.framework.name</name>
	<value>yarn</value>
</property>
```

**第五个：yarn-site.xml**

```
vi <strong>yarn-site.xml</strong>
<!-- 指定yarn的老大ResourceManager的地址 -->
<property>
	<name>yarn.resourcemanager.hostname</name>
	<value>node-1</value>
</property>


<!-- NodeManager上运行的附属服务。需要配置成mapreduce_shuffle,才可以运行MapReduce程序默认值 -->
<property>
	<name>yarn.nodemanager.aux-services</name>
	<value>mapreduce_shuffle</value>
</property>
```

**第六个：slaves 文件，里面写上从节点所在的主机名字**

```
vi slaves
node-1
node-2
node-3
```

**第七个：将 Hadoop 添加到环境变量**

```
vi /etc/profile
export HADOOP_HOME=/export/server/hadoop-2.7.6
export PATH=$HADOOP_HOME/bin:$PATH
```

然后将 hadoop 安装包远程发送给各个副计算机

```
scp -r /export/server/hadoop-2.7.6/ root@node-2:/export/server/
scp -r /export/server/hadoop-2.7.6/ root@node-3:/export/server/
```

把配置好的环境变量也要远程发送给各个副计算机

```
scp -r /etc/profile root@node-2:/etc/
scp -r /etc/profile root@node-3:/etc/
```

然后试所有的计算机环境变量生效

```
source /etc/profile
```

关于 hadoop的 配置说明
在 hadoop 官网，左下角点击 Documentation 点击相应的版本进去，拉到最左下角有 ***-default.xml
***-default.xml 是默认的配置，如果用户没有修改这些选项将会生效
***-site.xml 是用户自定义的配置
site的配置选项优先级大于 default 的，如果 site 里面有就会覆盖 default 里面的





## Hadoop Hadoop - YARN

## 旧的MapReduce架构

![yarn-old-mapreduce](https://atts.w3cschool.cn/attachments/image/20170808/1502171952954287.jpg)

- **JobTracker:** 负责资源管理，跟踪资源消耗和可用性，作业生命周期管理（调度作业任务，跟踪进度，为任务提供容错）
- **TaskTracker:** 加载或关闭任务，定时报告任务状态

此架构会有以下问题：

1. JobTracker 是 MapReduce 的集中处理点，存在单点故障
2. JobTracker 完成了太多的任务，造成了过多的资源消耗，当 MapReduce job 非常多的时候，会造成很大的内存开销。这也是业界普遍总结出老 Hadoop 的 MapReduce 只能支持 4000 节点主机的上限
3. 在 TaskTracker 端，以 map/reduce task 的数目作为资源的表示过于简单，没有考虑到 cpu/ 内存的占用情况，如果两个大内存消耗的 task 被调度到了一块，很容易出现 OOM
4. 在 TaskTracker 端，把资源强制划分为 map task slot 和 reduce task slot , 如果当系统中只有 map task 或者只有 reduce task 的时候，会造成资源的浪费，也就集群资源利用的问题

总的来说就是**单点问题**和**资源利用率问题**

## YARN架构

![yarn-architecture](https://atts.w3cschool.cn/attachments/image/20170808/1502172142576437.jpg)

![yarn-architecture-physical](https://atts.w3cschool.cn/attachments/image/20170808/1502171959302407.jpg)

YARN就是将 JobTracker  的职责进行拆分，将资源管理和任务调度监控拆分成独立#x7ACB;的进程：一个全局的资源管理和一个每个作业的管理（ApplicationMaster） ResourceManager 和 NodeManager 提供了计算资源的分配和管理，而 ApplicationMaster  则完成应用程序的运行

- **ResourceManager:** 全局资源管理和任务调度
- **NodeManager:** 单个节点的资源管理和监控
- **ApplicationMaster:** 单个作业的资源管理和任务监控
- **Container:** 资源申请的单位和任务运行的容器

## 架构对比

![hadoop-different](https://atts.w3cschool.cn/attachments/image/20170808/1502172212869842.jpg)

YARN架构下形成了一个通用的资源管理平台和一个通用的应用计算^#x5E73;台，避免了旧架构的单点问题和资源利用率问题，同时也让在其上运行的应用不再局限于 MapReduce 形式

## YARN基本流程

![yarn-process](https://atts.w3cschool.cn/attachments/image/20170808/1502172265232242.jpg)

![yarn-process-status-update](https://atts.w3cschool.cn/attachments/image/20170808/1502172270518138.jpg)

**1. Job submission**

从ResourceManager 中获取一个Application ID 检查作业输出配置，计算输入分片 拷贝作业资源（job jar、配置文件、分片信息）到 HDFS，以便后面任务的执行

**2. Job initialization**

ResourceManager 将作业递交给 Scheduler（有很多调度算法，一般是根据优先级）Scheduler 为作业分配一个  Container，ResourceManager 就加载一个 application master process 并交给  NodeManager。

管理 ApplicationMaster 主要是创建一系列的监控进程来跟踪作业的进度，同时获取输入分片，为每一个分片创建一个 Map task 和相应的 reduce task Application Master 还决定如何运行作业，如果作业很小（可配置），则直接在同一个 JVM 下运行

**3. Task assignment**

ApplicationMaster 向 Resource Manager 申请资源（一个个的Container，指定任务分配的资源要求）一般是根据 data locality 来分配资源

**4. Task execution**

ApplicationMaster 根据 ResourceManager 的分配情况，在对应的 NodeManager 中启动 Container 从 HDFS 中读取任务所需资源（job jar，配置文件等），然后执行该任务

**5. Progress and status update**

定时将任务的进度和状态报告给 ApplicationMaster Client 定时向 ApplicationMaster 获取整个任务的进度和状态

**6. Job completion**

Client定时检查整个作业是否完成 作业完成后，会清空临时文件、目录等



## YARN - ResourceManager

负责全局的资源管理和任务调度，把整个集群当成计算资源池，只关注分配，不管应用，且不负责容错

## 资源管理

1. 以前资源是每个节点分成一个个的Map slot和Reduce slot，现在是一个个Container，每个Container可以根据需要运行ApplicationMaster、Map、Reduce或者任意的程序
2. 以前的资源分配是静态的，目前是动态的，资源利用率更高
3. Container是资源申请的单位，一个资源申请格式：<resource-name, priority,  resource-requirement, number-of-containers>,  resource-name：主机名、机架名或*（代表任意机器）, resource-requirement：目前只支持CPU和内存
4. 用户提交作业到ResourceManager，然后在某个NodeManager上分配一个Container来运行ApplicationMaster，ApplicationMaster再根据自身程序需要向ResourceManager申请资源
5. YARN有一套Container的生命周期管理机制，而ApplicationMaster和其Container之间的管理是应用程序自己定义的

## 任务调度

1. 只关注资源的使用情况，根据需求合理分配资源
2. Scheluer可以根据申请的需要，在特定的机器上申请特定的资源（ApplicationMaster负责申请资源时的数据本地化的考虑，ResourceManager将尽量满足其申请需求，在指定的机器上分配Container，从而减少数据移动）

## 内部结构

![yarn-resource-manager](https://atts.w3cschool.cn/attachments/image/20170808/1502172348649444.jpg)

- Client Service: 应用提交、终止、输出信息（应用、队列、集群等的状态信息）
- Adaminstration Service: 队列、节点、Client权限管理
- ApplicationMasterService: 注册、终止ApplicationMaster, 获取ApplicationMaster的资源申请或取消的请求，并将其异步地传给Scheduler, 单线程处理
- ApplicationMaster Liveliness Monitor:  接收ApplicationMaster的心跳消息，如果某个ApplicationMaster在一定时间内没有发送心跳，则被任务失效，其资源将会被回收，然后ResourceManager会重新分配一个ApplicationMaster运行该应用（默认尝试2次）
- Resource Tracker Service: 注册节点, 接收各注册节点的心跳消息
- NodeManagers Liveliness Monitor: 监控每个节点的心跳消息，如果长时间没有收到心跳消息，则认为该节点无效, 同时所有在该节点上的Container都标记成无效，也不会调度任务到该节点运行
- ApplicationManager: 管理应用程序，记录和管理已完成的应用
- ApplicationMaster Launcher: 一个应用提交后，负责与NodeManager交互，分配Container并加载ApplicationMaster，也负责终止或销毁
- YarnScheduler: 资源调度分配， 有FIFO(with Priority)，Fair，Capacity方式
- ContainerAllocationExpirer: 管理已分配但没有启用的Container，超过一定时间则将其回收



## YARN - NodeManager

Node节点下的Container管理

1. 启动时向ResourceManager注册并定时发送心跳消息，等待ResourceManager的指令
2. 监控Container的运行，维护Container的生命周期，监控Container的资源使用情况
3. 启动或停止Container，管理任务运行时的依赖包（根据ApplicationMaster的需要，启动Container之前将需要的程序及其依赖包、配置文件等拷贝到本地）

## 内部结构

![yarn-node-manager](https://atts.w3cschool.cn/attachments/image/20170808/1502172411900611.jpg)

- NodeStatusUpdater: 启动向ResourceManager注册，报告该节点的可用资源情况，通信的端口和后续状态的维护

- ContainerManager: 接收RPC请求（启动、停止），资源本地化（下载应用需要的资源到本地，根据需要共享这些资源）

  PUBLIC: /filecache

  PRIVATE: /usercache//filecache

  APPLICATION: /usercache//appcache//（在程序完成后会被删除）

- ContainersLauncher: 加载或终止Container

- ContainerMonitor: 监控Container的运行和资源使用情况

- ContainerExecutor: 和底层操作系统交互，加载要运行的程序



## YARN - ApplicationMaster

单个作业的资源管理和任务监控

具体功能描述：

1. 计算应用的资源需求，资源可以是静态或动态计算的，静态的一般是Client申请时就指定了，动态则需要ApplicationMaster根据应用的运行状态来决定
2. 根据数据来申请对应位置的资源（Data Locality）
3. 向ResourceManager申请资源，与NodeManager交互进行程序的运行和监控，监控申请的资源的使用情况，监控作业进度
4. 跟踪任务状态和进度，定时向ResourceManager发送心跳消息，报告资源的使用情况和应用的进度信息
5. 负责本作业内的任务的容错

ApplicationMaster可以是用任何语言编写的程序，它和ResourceManager和NodeManager之间是通过ProtocolBuf交互，以前是一个全局的JobTracker负责的，现在每个作业都一个，可伸缩性更强，至少不会因为作业太多，造成JobTracker瓶颈。同时将作业的逻辑放到一个独立的ApplicationMaster中，使得灵活性更加高，每个作业都可以有自己的处理方式，不用绑定到MapReduce的处理模式上

**如何计算资源需求**

一般的MapReduce是根据block数量来定Map和Reduce的计算数量，然后一般的Map或Reduce就占用一个Container

**如何发现数据的本地化**

数据本地化是通过HDFS的block分片信息获取的



## YARN - Container

1. 基本的资源单位（CPU、内存等）
2. Container可以加载任意程序，而且不限于Java
3. 一个Node可以包含多个Container，也可以是一个大的Container
4. ApplicationMaster可以根据需要，动态申请和释放Container



## YARN - Failover

## 失败类型

1. 程序问题
2. 进程崩溃
3. 硬件问题

## 失败处理

### 任务失败

1. 运行时异常或者JVM退出都会报告给ApplicationMaster
2. 通过心跳来检查挂住的任务(timeout)，会检查多次（可配置）才判断该任务是否失效
3. 一个作业的任务失败率超过配置，则认为该作业失败
4. 失败的任务或作业都会有ApplicationMaster重新运行

### ApplicationMaster失败

1. ApplicationMaster定时发送心跳信号到ResourceManager，通常一旦ApplicationMaster失败，则认为失败，但也可以通过配置多次后才失败
2. 一旦ApplicationMaster失败，ResourceManager会启动一个新的ApplicationMaster
3. 新的ApplicationMaster负责恢复之前错误的ApplicationMaster的状态(yarn.app.mapreduce.am.job.recovery.enable=true)，这一步是通过将应用运行状态保存到共享的存储上来实现的，ResourceManager不会负责任务状态的保存和恢复
4. Client也会定时向ApplicationMaster查询进度和状态，一旦发现其失败，则向ResouceManager询问新的ApplicationMaster

### NodeManager失败

1. NodeManager定时发送心跳到ResourceManager，如果超过一段时间没有收到心跳消息，ResourceManager就会将其移除
2. 任何运行在该NodeManager上的任务和ApplicationMaster都会在其他NodeManager上进行恢复
3. 如果某个NodeManager失败的次数太多，ApplicationMaster会将其加入黑名单（ResourceManager没有），任务调度时不在其上运行任务

### ResourceManager失败

1. 通过checkpoint机制，定时将其状态保存到磁盘，然后失败的时候，重新运行
2. 通过zookeeper同步状态和实现透明的HA

可以看出，**一般的错误处理都是由当前模块的父模块进行监控（心跳）和恢复。而最顶端的模块则通过定时保存、同步状态和zookeeper来ֹ实现HA**



## Hadoop - MapReduce

## 简介

一种分布式的计算方式指定一个Map（映#x5C04;）函数，用来把一组键值对映射成一组新的键值对，指定并发的Reduce（归约）函数，用来保证所有映射的键值对中的每一个共享相同的键组

## Pattern

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-pattern.png)

map: (K1, V1) → list(K2, V2) combine: (K2, list(V2)) → list(K2, V2) reduce: (K2, list(V2)) → list(K3, V3)

Map输出格式和Reduce输入格式一定是相同的

## 基本流程

MapReduce主要是先读取文件数据，然后进行Map处理，接着Reduce处理，最后把处理结果写到文件中

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-process-overview.png)

## 详细流程

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-process.png)

## 多节点下的流程

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-process-cluster.png)

## 主要过程

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-data-process.png)

### Map Side

#### Record reader

记录阅读器会翻译由输入格式生成的记录，记录阅读器用于将数据解析给记录，并不分析记录自身。记录读取器的目的是将数据解析成记录，但不分析记录本身。它将数据以键值对的形式传输给mapper。通常键是位置信息，值是构成记录的数据存储块.自定义记录不在本文讨论范围之内.

#### Map

在映射器中用户提供的代码称为中间对。对于键值的具体定义是慎重的，因为定义对于分布式任务的完成具有重要意义.键决定了数据分类的依据，而值决定了处理器中的分析信息.本书的设计模式将会展示大量细节来解释特定键值如何选择. 

#### Shuffle and Sort

ruduce任务以随机和排序步骤开始。此步骤写入输出文件并下载到本地计算机。这些数据采用键进行排序以把等价密钥组合到一起。

#### Reduce

reduce采用分组数据作为输入。该功能传递键和此键相关值的迭代器。可以采用多种方式来汇总、过滤或者合并数据。当reduce功能完成，就会发送0个或多个键值对。

#### 输出格式

输出格式会转换最终的键值对并写入文件。默认情况下键和值以tab分割，各记录以换行符分割。因此可以自定义更多输出格式，最终数据会写入HDFS。类似记录读取，自定义输出格式不在本书范围。



## MapReduce - 读取数据

通过InputFormat决定读取的数据的类型，然后拆分成一个个InputSplit，每个InputSplit对应一个Map处理，RecordReader读取InputSplit的内容给Map

## InputFormat

决定读取数据的格式，可以是文件或数据库等

### 功能

1. 验证作业输入的正确性，如格式等
2. 将输入文件切割成逻辑分片(InputSplit)，一个InputSplit将会被分配给一个独立的Map任务
3. 提供RecordReader实现，读取InputSplit中的"K-V对"供Mapper使用

### 方法

**List getSplits():** 获取由输入文件计算出输入分片(InputSplit)，解决数据或文件分割成片问题

**RecordReader createRecordReader():** 创建RecordReader，从InputSplit中读取数据，解决读取分片中数据问题

### 类结构

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-inputformat.png)

**TextInputFormat:** 输入文件中的每一行就是一个记录，Key是这一行的byte offset，而value是这一行的内容

**KeyValueTextInputFormat:** 输入文件中每一行就是一个记录，第一个分隔符字符切分每行。在分隔符字符之前的内容为Key，在之后的为Value。分隔符变量通过key.value.separator.in.input.line变量设置，默认为(\t)字符。

**NLineInputFormat:** 与TextInputFormat一样，但每个数据块必须保证有且只有Ｎ行，mapred.line.input.format.linespermap属性，默认为１

**SequenceFileInputFormat:**  一个用来读取字符流数据的InputFormat，<key,value>为用户自定义的。字符流数据是Hadoop自定义的压缩的二进制数据格式。它用来优化从一个MapReduce任务的输出到另一个MapReduce任务的输入之间的数据传输过程。</key,value>

## InputSplit

代表一个个逻辑分片，并没有真正存储数据，只是提供了一个如何将数据分片的方法

Split内有Location信息，利于数据局部化

一个InputSplit给一个单独的Map处理

```
public abstract class InputSplit {
      /**
       * 获取Split的大小，支持根据size对InputSplit排序.
       */
      public abstract long getLength() throws IOException, InterruptedException;

      /**
       * 获取存储该分片的数据所在的节点位置.
       */
      public abstract String[] getLocations() throws IOException, InterruptedException;
}
```

## RecordReader

将InputSplit拆分成一个个<key,value>对给Map处理，也是实际的文件读取分隔对象</key,value>

## 问题

### 大量小文件如何处理

CombineFileInputFormat可以将若干个Split打包成一个，目的是避免过多的Map任务（因为Split的数目决定了Map的数目，大量的Mapper Task创建销毁开销将是巨大的）

### 怎么计算split的

通常一个split就是一个block（FileInputFormat仅仅拆分比block大的文件），这样做的好处是使得Map可以在存储有当前数据的节点上运行本地的任务，而不需要通过网络进行跨节点的任务调度

通过mapred.min.split.size， mapred.max.split.size, block.size来控制拆分的大小

如果mapred.min.split.size大于block size，则会将两个block合成到一个split，这样有部分block数据需要通过网络读取

如果mapred.max.split.size小于block size，则会将一个block拆成多个split，增加了Map任务数（Map对split进行计算并且上报结果，关闭当前计算打开新的split均需要耗费资源）

先获取文件在HDFS上的路径和Block信息，然后根据splitSize对文件进行切分（ splitSize =  computeSplitSize(blockSize, minSize, maxSize) ），默认splitSize  就等于blockSize的默认值（64m）

```
public List<InputSplit> getSplits(JobContext job) throws IOException {
    // 首先计算分片的最大和最小值。这两个值将会用来计算分片的大小
    long minSize = Math.max(getFormatMinSplitSize(), getMinSplitSize(job));
    long maxSize = getMaxSplitSize(job);

    // generate splits
    List<InputSplit> splits = new ArrayList<InputSplit>();
    List<FileStatus> files = listStatus(job);
    for (FileStatus file: files) {
        Path path = file.getPath();
        long length = file.getLen();
        if (length != 0) {
              FileSystem fs = path.getFileSystem(job.getConfiguration());
            // 获取该文件所有的block信息列表[hostname, offset, length]
              BlockLocation[] blkLocations = fs.getFileBlockLocations(file, 0, length);
            // 判断文件是否可分割，通常是可分割的，但如果文件是压缩的，将不可分割
              if (isSplitable(job, path)) {
                long blockSize = file.getBlockSize();
                // 计算分片大小
                // 即 Math.max(minSize, Math.min(maxSize, blockSize));
                long splitSize = computeSplitSize(blockSize, minSize, maxSize);

                long bytesRemaining = length;
                // 循环分片。
                // 当剩余数据与分片大小比值大于Split_Slop时，继续分片， 小于等于时，停止分片
                while (((double) bytesRemaining)/splitSize > SPLIT_SLOP) {
                      int blkIndex = getBlockIndex(blkLocations, length-bytesRemaining);
                      splits.add(makeSplit(path, length-bytesRemaining, splitSize, blkLocations[blkIndex].getHosts()));
                      bytesRemaining -= splitSize;
                }
                // 处理余下的数据
                if (bytesRemaining != 0) {
                    splits.add(makeSplit(path, length-bytesRemaining, bytesRemaining, blkLocations[blkLocations.length-1].getHosts()));
                }
            } else {
                // 不可split，整块返回
                splits.add(makeSplit(path, 0, length, blkLocations[0].getHosts()));
            }
        } else {
            // 对于长度为0的文件，创建空Hosts列表，返回
            splits.add(makeSplit(path, 0, length, new String[0]));
        }
    }

    // 设置输入文件数量
    job.getConfiguration().setLong(NUM_INPUT_FILES, files.size());
    LOG.debug("Total # of splits: " + splits.size());
    return splits;
}
```

### 分片间的数据如何处理

split是根据文件大小分割的，而一般处理是根据分隔符进行分割的，这样势必存在一条记录横跨两个split

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-split.png)

解决办法是只要不是第一个split，都会远程读取一条记录。不是第一个split的都忽略到第一条记录

```
public class LineRecordReader extends RecordReader<LongWritable, Text> {
    private CompressionCodecFactory compressionCodecs = null;
    private long start;
    private long pos;
    private long end;
    private LineReader in;
    private int maxLineLength;
    private LongWritable key = null;
    private Text value = null;

    // initialize函数即对LineRecordReader的一个初始化
    // 主要是计算分片的始末位置，打开输入流以供读取K-V对，处理分片经过压缩的情况等
    public void initialize(InputSplit genericSplit, TaskAttemptContext context) throws IOException {
        FileSplit split = (FileSplit) genericSplit;
        Configuration job = context.getConfiguration();
        this.maxLineLength = job.getInt("mapred.linerecordreader.maxlength", Integer.MAX_VALUE);
        start = split.getStart();
        end = start + split.getLength();
        final Path file = split.getPath();
        compressionCodecs = new CompressionCodecFactory(job);
        final CompressionCodec codec = compressionCodecs.getCodec(file);

        // 打开文件，并定位到分片读取的起始位置
        FileSystem fs = file.getFileSystem(job);
        FSDataInputStream fileIn = fs.open(split.getPath());

        boolean skipFirstLine = false;
        if (codec != null) {
            // 文件是压缩文件的话，直接打开文件
            in = new LineReader(codec.createInputStream(fileIn), job);
            end = Long.MAX_VALUE;
        } else {
            // 只要不是第一个split，则忽略本split的第一行数据
            if (start != 0) {
                skipFirstLine = true;
                --start;
                // 定位到偏移位置，下次读取就会从偏移位置开始
                fileIn.seek(start);
            }
            in = new LineReader(fileIn, job);
        }

        if (skipFirstLine) {
            // 忽略第一行数据，重新定位start
            start += in.readLine(new Text(), 0, (int) Math.min((long) Integer.MAX_VALUE, end - start));
        }
        this.pos = start;
    }

    public boolean nextKeyValue() throws IOException {
        if (key == null) {
            key = new LongWritable();
        }
        key.set(pos);// key即为偏移量
        if (value == null) {
            value = new Text();
        }
        int newSize = 0;
        while (pos < end) {
            newSize = in.readLine(value, maxLineLength,    Math.max((int) Math.min(Integer.MAX_VALUE, end - pos), maxLineLength));
            // 读取的数据长度为0，则说明已读完
            if (newSize == 0) {
                break;
            }
            pos += newSize;
            // 读取的数据长度小于最大行长度，也说明已读取完毕
            if (newSize < maxLineLength) {
                break;
            }
            // 执行到此处，说明该行数据没读完，继续读入
        }
        if (newSize == 0) {
            key = null;
            value = null;
            return false;
        } else {
            return true;
        }
    }
}
```

## MapReduce - Mapper

主要是读取InputSplit的每一个Key,Value对并进行处理

```
public class Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    /**
     * 预处理，仅在map task启动时运行一次
     */
    protected void setup(Context context) throws  IOException, InterruptedException {
    }

    /**
     * 对于InputSplit中的每一对<key, value>都会运行一次
     */
    @SuppressWarnings("unchecked")
    protected void map(KEYIN key, VALUEIN value, Context context) throws IOException, InterruptedException {
        context.write((KEYOUT) key, (VALUEOUT) value);
    }

    /**
     * 扫尾工作，比如关闭流等
     */
    protected void cleanup(Context context) throws IOException, InterruptedException {
    }

    /**
     * map task的驱动器
     */
    public void run(Context context) throws IOException, InterruptedException {
        setup(context);
        while (context.nextKeyValue()) {
            map(context.getCurrentKey(), context.getCurrentValue(), context);
        }
        cleanup(context);
    }
}

public class MapContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> extends TaskInputOutputContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    private RecordReader<KEYIN, VALUEIN> reader;
    private InputSplit split;

    /**
     * Get the input split for this map.
     */
    public InputSplit getInputSplit() {
        return split;
    }

    @Override
    public KEYIN getCurrentKey() throws IOException, InterruptedException {
        return reader.getCurrentKey();
    }

    @Override
    public VALUEIN getCurrentValue() throws IOException, InterruptedException {
        return reader.getCurrentValue();
    }

    @Override
    public boolean nextKeyValue() throws IOException, InterruptedException {
        return reader.nextKeyValue();
    }
}
```

## MapReduce - Shuffle

对Map的结果进行排序并传输到Reduce进行处理 Map的结果并不是直接存放到硬盘,而是利用缓存做一些预排序处理  Map会调用Combiner，压缩，按key进行分区、排序等，尽量减少结果的大小  每个Map完成后都会通知Task，然后Reduce就可以进行处理

![img](https://atts.w3cschool.cn/attachments/image/wk/hadoop/mapreduce-process.png)

## Map端

当Map程序开始产生结果的时候，并不是直接写到文件的，而是利用缓存做一些排序方面的预处理操作

每个Map任务都有一个循环内存缓冲区（默认100MB），当缓存的内容达到80%时，后台线程开始将内容写到文件，此时Map任务可以继续输出结果，但如果缓冲区满了，Map任务则需要等待

写文件使用round-robin方式。在写入文件之前，先将数据按照Reduce进行分区。对于每一个分区，都会在内存中根据key进行排序，如果配置了Combiner，则排序后执行Combiner（Combine之后可以减少写入文件和传输的数据）

每次结果达到缓冲区的阀值时，都会创建一个文件，在Map结束时，可能会产生大量的文件。在Map完成前，会将这些文件进行合并和排序。如果文件的数量超过3个，则合并后会再次运行Combiner（1、2个文件就没有必要了）

如果配置了压缩，则最终写入的文件会先进行压缩，这样可以减少写入和传输的数据

一旦Map完成，则通知任务管理器，此时Reduce就可以开始复制结果数据

## Reduce端

Map的结果文件都存放到运行Map任务的机器的本地硬盘中

如果Map的结果很少，则直接放到内存，否则写入文件中

同时后台线程将这些文件进行合并和排序到一个更大的文件中（如果文件是压缩的，则需要先解压）

当所有的Map结果都被复制和合并后，就会调用Reduce方法

Reduce结果会写入到HDFS中

## 调优

一般的原则是给shuffle分配尽可能多的内存，但前提是要保证Map、Reduce任务有足够的内存

对于Map，主要就是避免把文件写入磁盘，例如使用Combiner，增大io.sort.mb的值

对于Reduce，主要是把Map的结果尽可能地保存到内存中，同样也是要避免把中间结果写入磁盘。默认情况下，所有的内存都是分配给Reduce方法的，如果Reduce方法不怎么消耗内存，可以mapred.inmem.merge.threshold设成0，mapred.job.reduce.input.buffer.percent设成1.0

在任务监控中可通过Spilled records counter来监控写入磁盘的数，但这个值是包括map和reduce的

对于IO方面，可以Map的结果可以使用压缩，同时增大buffer size（io.file.buffer.size，默认4kb）

## 配置

|                  属性                   |    默认值    |                             描述                             |
| :-------------------------------------: | :----------: | :----------------------------------------------------------: |
|               io.sort.mb                |     100      |              映射输出分类时所使用缓冲区的大小.               |
|         io.sort.record.percent          |     0.05     | 剩余空间用于映射输出自身记录.在1.X发布后去除此属性.随机代码用于使用映射所有内存并记录信息. |
|          io.sort.spill.percent          |     0.80     |        针对映射输出内存缓冲和记录索引的阈值使用比例.         |
|             io.sort.factor              |      10      | 文件分类时合并流的最大数量。此属性也用于reduce。通常把数字设为100. |
|       min.num.spills.for.combine        |      3       |                组合运行所需最小溢出文件数目.                 |
|       mapred.compress.map.output        |    false     |                        压缩映射输出.                         |
|   mapred.map.output.compression.codec   | DefaultCodec |                 映射输出所需的压缩解编码器.                  |
|      mapred.reduce.parallel.copies      |      5       |             用于向reducer传送映射输出的线程数目.             |
|       mapred.reduce.copy.backoff        |     300      | 时间的最大数量，以秒为单位，这段时间内若reducer失败则会反复尝试传输 |
|             io.sort.factor              |      10      |                组合运行所需最大溢出文件数目.                 |
| mapred.job.shuffle.input.buffer.percent |     0.70     |           随机复制阶段映射输出缓冲器的堆栈大小比例           |
|    mapred.job.shuffle.merge.percent     |     0.66     | 用于启动合并输出进程和磁盘传输的映射输出缓冲器的阀值使用比例 |
|      mapred.inmem.merge.threshold       |     1000     | 用于启动合并输出和磁盘传输进程的映射输出的阀值数目。小于等于0意味着没有门槛，而溢出行为由 mapred.job.shuffle.merge.percent单独管理. |
| mapred.job.reduce.input.buffer.percent  |     0.0      | 用于减少内存映射输出的堆栈大小比例，内存中映射大小不得超出此值。若reducer需要较少内存则可以提高该值. |

## MapReduce - 编程

### 处理

1. select：直接分析输入数据，取出需要的字段数据即可
2. where: 也是对输入数据处理的过程中进行处理，判断是否需要该数据
3. aggregation:min, max, sum
4. group by: 通过Reducer实现
5. sort
6. join: map join, reduce join

### Third-Party Libraries

```
export LIBJARS=$MYLIB/commons-lang-2.3.jar, hadoop jar prohadoop-0.0.1-SNAPSHOT.jar org.aspress.prohadoop.c3. WordCountUsingToolRunner -libjars $LIBJARS
hadoop jar prohadoop-0.0.1-SNAPSHOT-jar-with-dependencies.jar org.aspress.prohadoop.c3. WordCountUsingToolRunner The dependent libraries are now included inside the application JAR file
```

一般还是上面的好，指定依赖可以利用Public Cache，如果是包含依赖，则每次都需要拷贝

### 参考书籍

[MapReduce Design Patterns](http://book.douban.com/subject/11229683/)

## Hadoop - IO

1. 输入文件从HDFS进行读取.
2. 输出文件会存入本地磁盘.
3. Reducer和Mapper间的网络I/O,从Mapper节点得到Reducer的检索文件.
4. 使用Reducer实例从本地磁盘回读数据.
5. Reducer输出- 回传到HDFS.

## 序列化

序列化是指将结构化对象转化为字节流以便在网络上传输或写到磁盘进行永久存储的过程。反序列化是指将字节流转回结构化对象的逆过程。

序列化用于分布式数据处理的两大领域：进程间通信和永久存储

在Hadoop中，系统中多个节点进程间的通信是通过“远程过程调用”（RPC）实现的。RPC协议将消息序列化成二进制流后发送到远程节点，远程节点接着将二进制流反序列化为原始消息。通常情况下，RPC序列化格式如下：

1.紧凑

紧凑格式能充分利用网络带宽（数据中心最稀缺的资源）

2.快速

进程间通信形成了分布式系统的骨架，所以需要尽量减少序列化和反序列化的性能开销，这是基本的。

3.可扩展

为了满足新的需求，协议不断变化。所以在控制客户端和服务期的过程中，需要直接引进相应的协议。例如，需要能够在方法调用的过程中增加新的参数，并且新的服务器需要能够接受来自老客户端的老格式的消息（无新增的参数）。

4.支持互操作

对于系统来说，希望能够支持以不同语言写的客户端与服务器交互，所以需要设计一种特定的格式来满足这一需求。



**Writable 接口**

Writable 接口定义了两个方法：一个将其状态写入 DataOutput 二进制流，另一个从 DataInput二进制流读取状态。

**BytesWritable**

BytesWritable 是对二进制数据数组的封装。它的序列化格式为一个指定所含数据字节数的整数域（4字节），后跟数据内容的本身。例如，长度为2的字节数组包含数值3和5，序列化形式为一个4字节的整数（00000002）和该数组中的两个字节（03和05）

**NullWritable**

NullWritable 是 writable 的特殊类型，它的序列化长度为0。它并不从数据流中读取数据，也不写入数据。它充当占位符。

**ObjectWritable和GenericWritable**

ObjectWritable 是对 java 基本类型（String，enum,Writable,null或这些类型组成的数组）的一个通用封装。它在 Hadoop RPC 中用于对方法的参数和返回类型进行封装和解封装。

**Wriable集合类**

io 软件包共有6个 Writable 集合类，分别是  ArrayWritable，ArrayPrimitiveWritable，TwoDArrayWritable,MapWritable,SortedMapWritable以及EnumMapWritable

ArrayWritable 和 TwoDArrayWritable 是对 Writeble 的数组和两维数组（数组的数组）的实现。ArrayWritable 或  TwoDArrayWritable 中所有元素必须是同一类的实例。ArrayWritable 和 TwoDArrayWritable  都有get() ,set() 和 toArray(）方法，toArray() 方法用于新建该数组的一个浅拷贝。 

ArrayPrimitiveWritable 是对 Java 基本数组类型的一个封装。调用 set() 方法时，可以识别相应组件类型，因而无需通过继承该类来设置类型。

**序列化框架**

尽管大多数 Mapreduce 程序使用的都是 Writable 类型的键和值，但这并不是 MapReduce API 强制要求使用的。事实上，可以使用任何类型，只要能有一个机制对每个类型进行类型与二进制表示的来回转换就可以。

为了支持这个机制，Hadoop 有一个针对可替换序列化框架的 API 。序列化框架用一个 Serialization 实现来表示。Serialization  对象定义了从类型到 Serializer 实例（将对象转换为字节流）和 Deserializer 实例（将字节流转换为对象）的映射方式。

**序列化IDL**

还有许多其他序列化框架从不同的角度来解决问题：不通过代码来定义类型，而是使用接口定义语言以不依赖与具体语言的方式进行声明。由此，系统能够为其他语言生成模型，这种形式能有效提高互操作能力。它们一般还会定义版本控制方案。

两个比较流行的序列化框架 Apache Thrift 和Google的Protocol Buffers，常常用作二进制数据的永久存储格式。Mapreduce  格式对该类的支持有限，但在 Hadoop 内部，部分组件仍使用上述两个序列化框架来实现 RPC 和数据交换。

**基于文件的数据结构**

对于某些应用，我们需要一种特殊的数据结构来存储自己的数据。对于基于 Mapreduce 的数据处理，将每个二进制数据大对象单独放在各自的文件中不能实现可扩展性，所以 Hadoop 为此开发了很多更高层次的容器。

关于 SequenceFile 。

考虑日志文件，其中每一行文本代表一条日志记录。纯文本不适合记录二进制类型的数据。在这种情况下，Hadoop 的 SequenceFile 类非常合适，为二进制键值对提供了一个持久数据结构。将它作为日志文件的存储格式时，你可以自己选择键，以及值可以是  Writable 类型。

SequenceFile 也可以作为小文件的容器。HDFS和Mapreduce 是针对大文件优化的，所以通过 SequenceFile 类型将小文件包装起来，可以获得更高效率的存储和处理。

**SequnceFile的写操作**

通过 createWriter（）静态方法可以创建 SequenceFile 对象，并返回 SequnceFile.Writer  实例。该静态方法有多个重载版本，但都需要制定待写入的数据流，Configuration 对象，以及键和值的类型。存储在 SequenceFIle 中的键和值并不一定是 Writable 类型。只要能够被 Sertialization 序列化和反序列化，任何类型都可以。

**SequenceFile的读操作**

从头到尾读取顺序文件不外乎创建 SequenceFile.reader 实例后反复调用 next() 方法迭代读取记录。读取的是哪条记录与使用的序列化框架有关。如果使用的是  Writable 类型，那么通过键和值作为参数的 next() 方法可以将数据流的下一条键值对读入变量中。 

1.通过命令行接口显示 SequenceFile。

hadoop fs 命令有一个 -text 选项可以以文本形式显示顺序文件。该选项可以查看文件的代码，由此检测出文件的类型并将其转换为相应的文本。该选项可以识别 gzip 压缩文件，顺序文件和 Avro 数据文件；否则，假设输入为纯文本文件。

\2. SequenceFile 的排序和合并。

 Mapreduce 是对多个顺序文件进行排序（或合并）最有效的方法。Mapreduce 本身是并行的，并且可由你制定使用多少个 reducer 。例如，通过制定一个 reducer ，可以得到一个输出文件。

3.SequenceFile 的格式。

顺序文件由文件头和随后的一条或多条记录组成。顺序文件的前三个字节为  SEQ，紧随其后的一个字节表示顺序文件的版本号。文件头还包括其他字段，例如键和值的名称，数据压缩细节，用户定义的元数据以及同步标识。同步标识用于在读取文件时能够从任意位置开始识别记录边界。每个文件都有一个随机生成的同步标识，其值存储在文件头中，位于顺序文件中的记录与记录之间。同步标识的额外存储开销要求小于1%，所以没有必要在每条记录末尾添加该标识。

**关于MapFile**

MapFile 是已经排过序的 SequenceFile ，它有索引，所以可以按键查找。索引本身就是一个 SequenceFile ，包含 map  中的一小部分键。由于索引能够加载进内存，因此可以提供对主数据文件的快速查找。主数据文件则是另一个 SequenceFIle ,包含了所有的  map 条目，这些条目都按照键顺序进行了排序。

其他文件格式和面向列的格式

顺序文件和 map 文件是 Hadoop 中最早的，但并不是仅有的二进制文件格式，事实上，对于新项目而言，有更好的二进制格式可供选择。

Avro 数据文件在某些方面类似顺序文件，是面向大规模数据处理而设计的。但是 Avro  数据文件又是可移植的，它们可以跨越不同的编程语言使用。顺序文件，map 文件和 Avro  数据文件都是面向行的格式，意味着每一行的值在文件中是连续存储的。在面向列的格式中，文件中的行被分割成行的分片，然后每个分片以面向列的形式存储：首先存储每行第一列的值，然后是每行第2列的值，如此以往。

## 压缩

能够减少磁盘的占用空间和网络传输的量，并加速数据在网络和磁盘上的传输。



Hadoop 应用处理的数据集非常大，因此需要借助于压缩。使用哪种压缩格式与待处理的文件的大小，格式和所用的工具有关。比较各种压缩算法的压缩比和性能（从高到低）：

\1. 使用容器文件格式，例如顺序文件， Avro 数据文件。 ORCF 了说 Parquet 文件

\2. 使用支持切分的压缩格式，例如 bzip2 或者通过索引实现切分的压缩格式，例子如LZO。

\3. 在应用中将文件中切分成块，并使用任意一种他所格式为每个数据块建立压缩文件（不论它是否支持切分）。在这种情况下，需要合理选择数据大小，以确保压缩后的数据块的大小近似于HDFS块的大小。

\4. 存储未经压缩的文件。



重点：压缩和拆分一般是冲突的（压缩后的文件的 block 是不能很好地拆分独立运行，很多时候某个文件的拆分点是被拆分到两个压缩文件中，这时 Map  任务就无法处理，所以对于这些压缩，Hadoop 往往是直接使用一个 Map  任务处理整个文件的分析）。对大文件不可使用不支持切分整个文件的压缩格式，会失去数据的特性，从而造成 Mapreduce 应用效率低下。

Map 的输出结果也可以进行压缩，这样可以减少 Map 结果到 Reduce 的传输的数据量，加快传输速率。



**在 Mapreduce 中使用压缩**

```
FileOutputFormat.setCompressOutput(job,true);
FileOutputFormat.setOutputCompressorClass(job,GzipCodec.class);
```

如果输出生成顺序文件，可以设置 mapreduce.output.fileoutputformat.compress.type  属性来控制限制使用压缩格式。默认值是RECORD,即针对每条记录进行压缩。如果将其改为BLOCK，将针对一组记录进行压缩，这是推荐的压缩策略，因为它的压缩效率更高。

## 完整性

- 检测数据是否损坏的常见措施是，在数据第一次引入系统时计算校验和并在数据通过一个不可靠的通道进行传输时再次计算校验和，这样就能发现数据是否损坏，如果计算所得的新校验和和原来的校验和不匹配，我们就认为数据已损坏。但该技术并不能修复数据。常见的错误检测码是 CRC-32（32位循环冗余检验），任何大小的数据输入均计算得到一个32位的整数校验和。
- datanode  负责在收到数据后存储该数据及其校验和之前对数据进行验证。它在收到客户端的数据或复制其他 datanode  的数据时执行这个操作。正在写数据的客户端将数据及其校验和发送到由一系列 datanode 组成的管线，管线中最后一个 datanode  负责验证校验和。如果 datanode 检测到错误，客户端就会收到一个 IOException 异常的子类。
- 客户端从  datanode 读取数据时，也会验证校验和，将它们与 datanode  中存储的校验和进行比较。每个datanode均持久保存有一个验证的校验和日志，所以它知道每个数据块的最后一次验证时间。客户端成功验证一个数据块后，会告诉这个 datanode ， datanode 由此更新日志。保存这些统计信息对于检测损坏的磁盘很有价值。
- 不只是客户端在读取数据块时会验证校验和，每个 datanode 也会在一个后台线程中运行一个 DataBlockScanner ，从而定期验证存储在这个 datanode 上的所有数据块。该项措施是解决物理存储媒体上位损坏的有力措施。
- 由于 HDFS  存储着每个数据块的复本，因此它可以通过数据复本来修复损坏的数据块，进而得到一个新的，完好无损的复本。基本思路是，客户端在读取数据块时，如果检测到错误，首先向 namenode 报告已损坏的数据块及其正在尝试读取操作的这个 datanode ，再抛出 ChecksumException  异常。namenode 将这个数据块复本标记为已损坏，这样它不再将客户端处理请求直接发送到这个节点，或尝试将这个复本复制到另一个  datanode 。之后，它安排这个数据块的一个复本复制到另一个 datanode  ，这样一来，数据块的复本因子又回到期望水平。此后，已损坏的数据块复本便被删除。
- Hadoop的LocalFileSystem 执行客户端的校验和验证。这意味着在你写入一个名为 filename  的文件时，文件系统客户端会明确在包含每个文件快校验和的同一个目录内新建一个 filename.crc  隐藏文件。文件块的大小作为元数据存储在.crc文件中，所以即使文件块大小的设置已经发生变化，仍然可以正确读回文件。在读取文件时需要验证校验和，并且如果检测到错误，LocalFileSystem 还会抛出一个 ChecksumException 异常。



## Hadoop 监控

Log yarn.log-aggregation-enable=true如果显示错误，则日志存储在节点管理器运行节点上。当聚集启用时所有日志进行汇总，任务完成后转移到HDFS。 

Hadoop集群性能监控Ganglia, Nagios

使用Hadoop工具 Ambari管理集群



Hadoop是一个开源框架，它允许在整个集群使用简单编程模型计算机的分布式环境存储并处理大数据。它的目的是从单一的服务器到上千台机器的扩展，每一个台机都可以提供本地计算和存储。

​	“**90％的世界数据在过去的几年中产生**”。

​	由于新技术，设备和类似的社交网站通信装置的出现，人类产生的数据量每年都在迅速增长。美国从一开始的时候到2003年产生的数据量为5十亿千兆字节。如果以堆放的数据磁盘的形式，它可以填补整个足球场。在2011年创建相同数据量只需要两天，在2013年该速率仍在每十分钟极大地增长。虽然生产的所有这些信息是有意义的，处理起来有用的，但是它被忽略了。

## 	什么是大数据？

​	大数据是不能用传统的计算技术处理的大型数据集的集合。它不是一个单一的技术或工具，而是涉及的业务和技术的许多领域。

## 	在大数据会发生什么？

​	大数据包括通过不同的设备和应用程序所产生的数据。下面给出的是一些在数据的框架下的领域。

- ​			黑匣子数据：这是直升机，飞机，喷气机的一个组成部分，它捕获飞行机组的声音，麦克风和耳机的录音，以及飞机的性能信息。
- ​			社会化媒体数据：社会化媒体，如Facebook和Twitter保持信息发布的数百万世界各地的人的意见观点。
- ​			证券交易所数据：交易所数据保存有关的“买入”和“卖出”，客户由不同的公司所占的份额决定的信息。
- ​			电网数据：电网数据保持相对于基站所消耗的特定节点的信息。
- ​			交通运输数据：交通数据包括车辆的型号，容量，距离和可用性。
- ​			搜索引擎数据：搜索引擎获取大量来自不同数据库中的数据。

![Big Data](/uploads/allimg/141227/1-14122GH401A4.jpg)

​	因此，大数据包括体积庞大，高流速和可扩展的各种数据。它的数据为三种类型。

- ​			结构化数据：关系数据。
- ​			半结构化数据：XML数据。
- ​			非结构化数据：Word, PDF, 文本，媒体日志。

## 	大数据的好处

- ​			通过保留了社交网络如Facebook的信息，市场营销机构了解可以他们的活动，促销等广告媒介的响应。
- ​			利用信息计划生产在社会化媒体一样喜好并让消费者对产品的认知，产品企业和零售企业。
- ​			使用关于患者以前的病历资料，医院提供更好的和快速的服务。

## 	大数据技术

​	大数据的技术是在提供更准确的分析，这可能影响更多的具体决策导致更大的运行效率，降低成本，并减少了对业务的风险。

​	为了利用大数据的力量，需要管理和处理的实时结构化和非结构化的海量数据，可以保护数据隐私和安全的基础设施。

​	目前在市场上的各种技术，从不同的供应商，包括亚马逊，IBM，微软等来处理大数据。尽管找到了处理大数据的技术，我们研究了以下两类技术：

### 	操作大数据

​	这些包括像[MongoDB](http://www.yiibai.com/mongodb/)系统，提供业务实时的能力，这里主要是数据捕获和存储互动工作。

​	NoSQL大数据系统的设计充分利用已经出现在过去的十年，而让大量的计算，以廉价，高效地运行新的云计算架构的优势。这使得运营大数据工作负载更容易管理，更便宜，更快的实现。

​	一些NoSQL系统可以提供深入了解基于使用最少的编码无需数据科学家和额外的基础架构的实时数据模式。

### 	分析大数据

​	这些包括，如大规模并行处理（MPP）数据库系统和MapReduce提供用于回顾性和复杂的分析，可能触及大部分或全部数据的分析能力的系统。

​	MapReduce提供分析数据的基础上，MapReduce可以按比例增加从单个服务器向成千上万的高端和低端机的互补SQL提供的功能，这是系统的一种新方法。

​	这两个类技术是互补的，并经常一起部署。

## 	操作与分析系统

|          | 操作           | 分析                  |
| -------- | -------------- | --------------------- |
| 等待时间 | 1 ms - 100 ms  | 1 min - 100 min       |
| 并发     | 1000 - 100,000 | 1 - 10                |
| 访问模式 | 写入和读取     | 读取                  |
| 查询     | 选择           | 非选择性              |
| 数据范围 | 操作           | 回溯                  |
| 最终用户 | 顾客           | 数据科学家            |
| 技术     | NoSQL          | MapReduce, MPP 数据库 |

## 	大数据的挑战

​	大数据相关的主要挑战如下：

- ​		采集数据
- ​		策展
- ​		存储
- ​		搜索
- ​		分享
- ​		传输
- ​		分析
- ​		展示

​	为了实现上述挑战，企业通常需要企业级服务器的帮助。



​								

//原文出自【易百教程】，商业转载请联系作者获得授权，非商业转载请保留原文链接：https://www.yiibai.com/hadoop/ 

# Hadoop大数据解决方案 			

​					作者： 					YeaWind 				**Java技术QQ群：227270512 / Linux QQ群：479429477** 			



​					 				 				 				 			

## 	传统的企业方法

​	在这种方法中，一个企业将有一个计算机存储和处理大数据。对于存储而言，程序员会自己选择的数据库厂商，如Oracle，IBM等的帮助下完成，用户交互使用应用程序进而获取并处理数据存储和分析。

![Big Data Traditional Approach](/uploads/allimg/141227/1420403157-0.jpg)

### 	局限性

​	这种方式能完美地处理那些可以由标准的数据库服务器来存储，或直至处理数据的处理器的限制少的大量数据应用程序。但是，当涉及到处理大量的可伸缩数据，这是一个繁忙的任务，只能通过单一的数据库瓶颈来处理这些数据。

## 	谷歌的解决方案

​	使用一种称为MapReduce的算法谷歌解决了这个问题。这个算法将任务分成小份，并将它们分配到多台计算机，并且从这些机器收集结果并综合，形成了结果数据集。

![Google MapReduce](/uploads/allimg/141227/1420406125-1.jpg)

## 	Hadoop

​	使用谷歌提供的解决方案，Doug Cutting和他的团队开发了一个开源项目叫做HADOOP。

​	Hadoop使用的MapReduce算法运行，其中数据在使用其他并行处理的应用程序。总之，Hadoop用于开发可以执行完整的统计分析大数据的应用程序。

![Hadoop Framework](/uploads/allimg/141227/1420403202-2.jpg)

​	 

//原文出自【易百教程】，商业转载请联系作者获得授权，非商业转载请保留原文链接：https://www.yiibai.com/hadoop/hadoop_big_data_solutions.html#article-start 

Hadoop是使用Java编写，允许分布在集群，使用简单的编程模型的计算机大型数据集处理的Apache的开源框架。 Hadoop框架应用工程提供跨计算机集群的分布式存储和计算的环境。 Hadoop是专为从单一服务器到上千台机器扩展，每个机器都可以提供本地计算和存储。

## 	Hadoop的架构

​	在其核心，Hadoop主要有两个层次，即：

- ​		加工/计算层(MapReduce)，以及
- ​		存储层(Hadoop分布式文件系统)。

![Hadoop Architecture](/uploads/allimg/141227/1F3155322-0.jpg)

### 	MapReduce

​	MapReduce是一种并行编程模型，用于编写普通硬件的设计，谷歌对大量数据的高效处理(多TB数据集)的分布式应用在大型集群(数千个节点)以及可靠的容错方式。 MapReduce程序可在Apache的开源框架Hadoop上运行。

### 	Hadoop分布式文件系统

​	Hadoop分布式文件系统（HDFS）是基于谷歌文件系统（GFS），并提供了一个设计在普通硬件上运行的分布式文件系统。它与现有的分布式文件系统有许多相似之处。来自其他分布式文件系统的差别是显著。它高度容错并设计成部署在低成本的硬件。提供了高吞吐量的应用数据访问，并且适用于具有大数据集的应用程序。

​	除了上面提到的两个核心组件，Hadoop的框架还包括以下两个模块：

- ​			Hadoop通用：这是Java库和其他Hadoop组件所需的实用工具。
- ​			Hadoop YARN ：这是作业调度和集群资源管理的框架。

## 	Hadoop如何工作？

​	建立重配置，处理大规模处理服务器这是相当昂贵的，但是作为替代，可以联系许多普通电脑采用单CPU在一起，作为一个单一功能的分布式系统，实际上，集群机可以平行读取数据集，并提供一个高得多的吞吐量。此外，这样便宜不到一个高端服务器价格。因此使用Hadoop跨越集群和低成本的机器上运行是一个不错不选择。

​	Hadoop运行整个计算机集群代码。这个过程包括以下核心任务由 Hadoop 执行：

- ​		数据最初分为目录和文件。文件分为128M和64M（128M最好）统一大小块。
- ​		然后这些文件被分布在不同的群集节点，以便进一步处理。
- ​		HDFS，本地文件系统的顶端﹑监管处理。
- ​		块复制处理硬件故障。
- ​		检查代码已成功执行。
- ​		执行发生映射之间，减少阶段的排序。
- ​		发送排序的数据到某一计算机。
- ​		为每个作业编写的调试日志。

## 	Hadoop的优势

- ​			Hadoop框架允许用户快速地编写和测试的分布式系统。有效并在整个机器和反过来自动分配数据和工作，利用CPU内核的基本平行度。
- ​			Hadoop不依赖于硬件，以提供容错和高可用性（FTHA），而Hadoop库本身已被设计在应用层可以检测和处理故障。
- ​			服务器可以添加或从集群动态删除，Hadoop可继续不中断地运行。
- ​			Hadoop的的另一大优势在于，除了是开源的，因为它是基于Java并兼容所有的平台。



​							

//原文出自【易百教程】，商业转载请联系作者获得授权，非商业转载请保留原文链接：https://www.yiibai.com/hadoop/hadoop_introduction_to_hadoop.html#article-start 

# Hadoop环境安装设置 			

​					作者： 					小恩- 				**Java技术QQ群：227270512 / Linux QQ群：479429477** 			



​					 				 				 				 			

​	Hadoop由GNU/Linux平台支持(建议)。因此，需要安装一个Linux操作系统并设置Hadoop环境。如果有Linux操作系统等，可以把它安装在VirtualBox(要具备在 VirtualBox内安装Linux经验，没有装过也可以学习试着来)。

## 	安装前设置

​	在安装Hadoop之前，需要进入Linux环境下，连接Linux使用SSH(安全Shell)。按照下面提供的步骤设立Linux环境。

### 	创建一个用

​	在开始时，建议创建一个单独的用户Hadoop以从Unix文件系统隔离Hadoop文件系统。按照下面给出的步骤来创建用户：

- ​		使用 “su” 命令开启root .
- ​		创建用户从root帐户使用命令 “useradd username”.
- ​		现在，可以使用命令打开一个现有的用户帐户“su username”.

​	打开Linux终端，输入以下命令来创建一个用户。

```
$ su 
   password: 
# useradd hadoop 
# passwd hadoop 
   New passwd: 
   Retype new passwd 
```

## 	SSH设置和密钥生成

​	SSH设置需要在集群上做不同的操作，如启动，停止，分布式守护shell操作。认证不同的Hadoop用户，需要一种用于Hadoop用户提供的公钥/私钥对，并用不同的用户共享。

​	下面的命令用于生成使用SSH键值对。复制公钥形成 id_rsa.pub 到authorized_keys 文件中，并提供拥有者具有authorized_keys文件的读写权限。

```
$ ssh-keygen -t rsa 
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
$ chmod 0600 ~/.ssh/authorized_keys 
```

## 	安装Java

​	Java是Hadoop的主要先决条件。首先，应该使用命令“java-version”验证 java 存在在系统中。 Java version 命令的语法如下。

```
$ java -version 
```

​	如果一切顺利，它会给下面的输出。

```
java version "1.7.0_71" 
Java(TM) SE Runtime Environment (build 1.7.0_71-b13) 
Java HotSpot(TM) Client VM (build 25.0-b02, mixed mode)  
```

​	如果Java还未安装在系统中，那么按照下面的给出的步骤来安装Java。

### 	第1步

​	下载Java(JDK<最新版> - X64.tar.gz)通过访问以下链接 [http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads1880260.html.](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads1880260.html)

​	然后JDK-7u71-linux-x64.tar.gz将被下载到系统。

### 	第2步

​	一般来说，在下载文件夹中的Java文件。使用下面的命令提取 jdk-7u71-linux-x64.gz文件。

```
$ cd Downloads/ 
$ ls 
jdk-7u71-linux-x64.gz 
$ tar zxf jdk-7u71-linux-x64.gz 
$ ls 
jdk1.7.0_71   jdk-7u71-linux-x64.gz 
```

### 	第3步

​	为了使Java提供给所有用户，将它移动到目录 “/usr/local/”。打开根目录，键入以下命令。

```
$ su 
password: 
# mv jdk1.7.0_71 /usr/local/ 
# exit 
```

### 	第4步

​	用于设置PATH和JAVA_HOME变量，添加以下命令到~/.bashrc文件。

```
export JAVA_HOME=/usr/local/jdk1.7.0_71 
export PATH=PATH:$JAVA_HOME/bin 
```

​	现在从终端验证 java -version 命令如上述说明。

## 	下载Hadoop

​	下载来自Apache基金会软件，使用下面的命令提取 Hadoop2.4.1。

```
$ su 
password: 
# cd /usr/local 
# wget http://apache.claz.org/hadoop/common/hadoop-2.4.1/ 
hadoop-2.4.1.tar.gz 
# tar xzf hadoop-2.4.1.tar.gz 
# mv hadoop-2.4.1/* to hadoop/ 
# exit 
```

## 	Hadoop操作模式

​	下载 Hadoop 以后，可以操作Hadoop集群以以下三个支持模式之一：

- ​			本地/独立模式：下载Hadoop在系统中，默认情况下之后，它会被配置在一个独立的模式，用于运行Java程序。
- ​			模拟分布式模式：这是在单台机器的分布式模拟。Hadoop守护每个进程，如 hdfs, yarn, MapReduce 等，都将作为一个独立的java程序运行。这种模式对开发非常有用。
- ​			完全分布式模式：这种模式是完全分布式的最小两台或多台计算机的集群。我们使用这种模式在未来的章节中。

## 	在单机模式下安装Hadoop

​	在这里，将讨论 Hadoop2.4.1在独立模式下安装。

​	有单个JVM运行任何守护进程一切都运行。独立模式适合于开发期间运行MapReduce程序，因为它很容易进行测试和调试。

### 	设置Hadoop

​	可以通过附加下面的命令到 ~/.bashrc 文件中设置 Hadoop 环境变量。

```
export HADOOP_HOME=/usr/local/hadoop 
```

​	在进一步讨论之前，需要确保Hadoop工作正常。发出以下命令：

```
$ hadoop version 
```

​	如果设置的一切正常，那么应该看到以下结果：

```
Hadoop 2.4.1 
Subversion https://svn.apache.org/repos/asf/hadoop/common -r 1529768 
Compiled by hortonmu on 2013-10-07T06:28Z 
Compiled with protoc 2.5.0
From source with checksum 79e53ce7994d1628b240f09af91e1af4 
```

​	这意味着Hadoop在独立模式下工作正常。默认情况下，Hadoop被配置为在非分布式模式的单个机器上运行。

### 	示例

​	让我们来看看Hadoop的一个简单例子。 Hadoop安装提供了下列示例 MapReduce jar 文件，它提供了MapReduce的基本功能，并且可以用于计算，像PI值，字计数在文件等等

```
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.2.0.jar 
```

​	有一个输入目录将推送几个文件，要求计算那些文件的单词总数。要计算单词总数，并不需要写MapReduce，提供的.jar文件包含了实现字数。可以尝试其他的例子使用相同的.jar文件; 发出以下命令通过Hadoop hadoop-mapreduce-examples-2.2.0.jar 文件检查支持MapReduce功能的程序。

```
$ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduceexamples-2.2.0.jar 
```

### 	第1步

​	创建输入临时目录的内容文件。可以在任何地方创建此输入目录用来工作。

```
$ mkdir input 
$ cp $HADOOP_HOME/*.txt input 
$ ls -l input 
```

​	它会在输入目录中的给出以下文件：

```
total 24 
-rw-r--r-- 1 root root 15164 Feb 21 10:14 LICENSE.txt 
-rw-r--r-- 1 root root   101 Feb 21 10:14 NOTICE.txt
-rw-r--r-- 1 root root  1366 Feb 21 10:14 README.txt 
```

​	这些文件已从Hadoop安装主目录被复制。为了实验，可以有不同大型的文件集。

### 	第1步

​	让我们启动Hadoop进程计数在所有在输入目录中可用的文件的单词总数，具体如下：

```
$ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduceexamples-2.2.0.jar  wordcount input ouput 
```

### 	第3步

​	步骤2 将做必要的处理并保存输出在output/part-r00000文件中，可以通过查询使用：

```
$cat output/* 
```

​	它会列出了所有的单词以及它们在所有输入目录中的文件提供总计数。

```
"AS      4 
"Contribution" 1 
"Contributor" 1 
"Derivative 1
"Legal 1
"License"      1
"License");     1 
"Licensor"      1
"NOTICE”        1 
"Not      1 
"Object"        1 
"Source”        1 
"Work”    1 
"You"     1 
"Your")   1 
"[]"      1 
"control"       1 
"printed        1 
"submitted"     1 
(50%)     1 
(BIS),    1 
(C)       1 
(Don't)   1 
(ECCN)    1 
(INCLUDING      2 
(INCLUDING,     2 
.............
```

## 	模拟分布式模式安装Hadoop

​	按照下面给出的在伪分布式模式下安装Hadoop2.4.1的步骤。

### 	第1步：设置Hadoop

​	可以通过附加下面的命令到~/.bashrc文件中设置Hadoop环境变量。

```
export HADOOP_HOME=/usr/local/hadoop 
export HADOOP_MAPRED_HOME=$HADOOP_HOME 
export HADOOP_COMMON_HOME=$HADOOP_HOME 
export HADOOP_HDFS_HOME=$HADOOP_HOME 
export YARN_HOME=$HADOOP_HOME 
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin 
export HADOOP_INSTALL=$HADOOP_HOME 
```

​	现在，提交所有更改到当前正在运行的系统。

```
$ source ~/.bashrc 
```

### 	第2步：Hadoop配置

​	可以找到位置“$HADOOP_HOME/etc/hadoop”下找到所有Hadoop配置文件。这是需要根据Hadoop基础架构进行更改这些配置文件。

```
$ cd $HADOOP_HOME/etc/hadoop
```

​	为了使用Java开发Hadoop程序，必须用java在系统中的位置替换JAVA_HOME值并重新设置hadoop-env.sh文件的java环境变量。

```
export JAVA_HOME=/usr/local/jdk1.7.0_71
```

​	以下是必须编辑配置Hadoop的文件列表。

​	**core-site.xml**

​	core-site.xml文件中包含如读/写缓冲器用于Hadoop的实例的端口号的信息，分配给文件系统存储，用于存储所述数据存储器的限制和大小。

​	打开core-site.xml 并在<configuration>，</configuration>标记之间添加以下属性。

```
<configuration>

   <property>
      <name>fs.default.name </name>
      <value> hdfs://localhost:9000 </value> 
   </property>
 
</configuration>
```

​	**hdfs-site.xml**

​	hdfs-site.xml 文件中包含如复制数据的值，NameNode路径的信息，，本地文件系统的数据节点的路径。这意味着是存储Hadoop基础工具的地方。

​	让我们假设以下数据。

```
dfs.replication (data replication value) = 1 
(In the below given path /hadoop/ is the user name. 
hadoopinfra/hdfs/namenode is the directory created by hdfs file system.) 
namenode path = //home/hadoop/hadoopinfra/hdfs/namenode 
(hadoopinfra/hdfs/datanode is the directory created by hdfs file system.) 
datanode path = //home/hadoop/hadoopinfra/hdfs/datanode 
```

​	打开这个文件，并在这个文件中的<configuration></configuration>标签之间添加以下属性。

```
<configuration>

   <property>
      <name>dfs.replication</name>
      <value>1</value>
   </property>
    
   <property>
      <name>dfs.name.dir</name>
      <value>file:///home/hadoop/hadoopinfra/hdfs/namenode </value>
   </property>
    
   <property>
      <name>dfs.data.dir</name> 
      <value>file:///home/hadoop/hadoopinfra/hdfs/datanode </value> 
   </property>
       
</configuration>
```

​	注：在上面的文件，所有的属性值是用户定义的，可以根据自己的Hadoop基础架构进行更改。

​	yarn-site.xml

​	此文件用于配置成yarn在Hadoop中。打开 yarn-site.xml文件，并在文件中的<configuration></configuration>标签之间添加以下属性。

```
<configuration>
 
   <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value> 
   </property>
  
</configuration>
```

​	mapred-site.xml

​	此文件用于指定正在使用MapReduce框架。缺省情况下，包含Hadoop的模板yarn-site.xml。首先，它需要从mapred-site.xml复制。获得mapred-site.xml模板文件使用以下命令。

```
$ cp mapred-site.xml.template mapred-site.xml 
```

​	打开mapred-site.xml文件，并在此文件中的<configuration></configuration>标签之间添加以下属性。

```
<configuration>
 
   <property> 
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>
   
</configuration>
```

## 	验证Hadoop安装

​	下面的步骤用来验证Hadoop安装。

### 	第1步：名称节点设置

​	使用命令“hdfs namenode -format”如下设置名称节点。

```
$ cd ~ 
$ hdfs namenode -format 
```

​	预期的结果如下

```
10/24/14 21:30:55 INFO namenode.NameNode: STARTUP_MSG: 
/************************************************************ 
STARTUP_MSG: Starting NameNode 
STARTUP_MSG:   host = localhost/192.168.1.11 
STARTUP_MSG:   args = [-format] 
STARTUP_MSG:   version = 2.4.1 
...
...
10/24/14 21:30:56 INFO common.Storage: Storage directory 
/home/hadoop/hadoopinfra/hdfs/namenode has been successfully formatted. 
10/24/14 21:30:56 INFO namenode.NNStorageRetentionManager: Going to 
retain 1 images with txid >= 0 
10/24/14 21:30:56 INFO util.ExitUtil: Exiting with status 0 
10/24/14 21:30:56 INFO namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************ 
SHUTDOWN_MSG: Shutting down NameNode at localhost/192.168.1.11 
************************************************************/
```

### 	第2步：验证Hadoop的DFS

​	下面的命令用来启动DFS。执行这个命令将启动Hadoop文件系统。

```
$ start-dfs.sh 
```

​	期望的输出如下所示：

```
10/24/14 21:37:56 
Starting namenodes on [localhost] 
localhost: starting namenode, logging to /home/hadoop/hadoop
2.4.1/logs/hadoop-hadoop-namenode-localhost.out 
localhost: starting datanode, logging to /home/hadoop/hadoop
2.4.1/logs/hadoop-hadoop-datanode-localhost.out 
Starting secondary namenodes [0.0.0.0]
```

### 	第3步：验证Yarn 脚本

​	下面的命令用来启动yarn脚本。执行此命令将启动yarn守护进程。

```
$ start-yarn.sh 
```

​	预期输出如下：

```
starting yarn daemons 
starting resourcemanager, logging to /home/hadoop/hadoop
2.4.1/logs/yarn-hadoop-resourcemanager-localhost.out 
localhost: starting nodemanager, logging to /home/hadoop/hadoop
2.4.1/logs/yarn-hadoop-nodemanager-localhost.out 
```

### 	第4步：在浏览器访问Hadoop

​	访问Hadoop默认端口号为50070，使用以下网址获得浏览器Hadoop的服务。

```
http://localhost:50070/
```

![Accessing Hadoop on Browser](/uploads/allimg/141227/1SJID0-0.jpg)

### 	第5步：验证所有应用程序的集群

​	访问集群中的所有应用程序的默认端口号为8088。使用以下URL访问该服务。

```
http://localhost:8088/
```

![Hadoop Application Cluster](/uploads/allimg/141227/1SJLQ2-1.jpg)

​	 

//原文出自【易百教程】，商业转载请联系作者获得授权，非商业转载请保留原文链接：https://www.yiibai.com/hadoop/hadoop_enviornment_setup.html#article-start 





## 目的

这篇文档的目的是帮助你快速完成单机上的Hadoop安装与使用以便你对[Hadoop分布式文件系统(HDFS)](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html)和Map-Reduce框架有所体会，比如在HDFS上运行示例程序或简单作业等。



## 先决条件



### 支持平台

- ​                GNU/Linux是产品开发和运行的平台。         Hadoop已在有2000个节点的GNU/Linux主机组成的集群系统上得到验证。          
- ​            Win32平台是作为*开发平台*支持的。由于分布式操作尚未在Win32平台上充分测试，所以还不作为一个*生产平台*被支持。          



### 所需软件

Linux和Windows所需软件包括:

1. ​            JavaTM1.5.x，必须安装，建议选择Sun公司发行的Java版本。          
2. ​             **ssh** 必须安装并且保证 **sshd**一直运行，以便用Hadoop     脚本管理远端Hadoop守护进程。          

Windows下的附加软件需求

1. ​               [Cygwin](http://www.cygwin.com/) - 提供上述软件之外的shell支持。             



### 安装软件

如果你的集群尚未安装所需软件，你得首先安装它们。

以Ubuntu Linux为例:

​           $ sudo apt-get install ssh 
​           $ sudo apt-get install rsync        

在Windows平台上，如果安装cygwin时未安装全部所需软件，则需启动cyqwin安装管理器安装如下软件包：

- openssh - *Net* 类



## 下载

​        为了获取Hadoop的发行版，从Apache的某个镜像服务器上下载最近的        [稳定发行版](https://hadoop.apache.org/core/releases.html)。



## 运行Hadoop集群的准备工作

​        解压所下载的Hadoop发行版。编辑        conf/hadoop-env.sh文件，至少需要将JAVA_HOME设置为Java安装根路径。      

​	    尝试如下命令：
​         $ bin/hadoop 
​        将会显示**hadoop** 脚本的使用文档。      

现在你可以用以下三种支持的模式中的一种启动Hadoop集群：      

- 单机模式
- 伪分布式模式
- 完全分布式模式



## 单机模式的操作方法

默认情况下，Hadoop被配置成以非分布式模式运行的一个独立Java进程。这对调试非常有帮助。

​        下面的实例将已解压的 conf 目录拷贝作为输入，查找并显示匹配给定正则表达式的条目。输出写入到指定的output目录。        
​         $ mkdir input 
​         $ cp conf/*.xml input 
​                   $ bin/hadoop jar hadoop-*-examples.jar grep input output 'dfs[a-z.]+'         
​         $ cat output/*      



## 伪分布式模式的操作方法

Hadoop可以在单节点上以所谓的伪分布式模式运行，此时每一个Hadoop守护进程都作为一个独立的Java进程运行。



### 配置

使用如下的 conf/hadoop-site.xml:

| <configuration>                 |
| ------------------------------- |
| <property>                      |
| <name>fs.default.name</name>    |
| <value>localhost:9000</value>   |
| </property>                     |
| <property>                      |
| <name>mapred.job.tracker</name> |
| <value>localhost:9001</value>   |
| </property>                     |
| <property>                      |
| <name>dfs.replication</name>    |
| <value>1</value>                |
| </property>                     |
| </configuration>                |



### 免密码ssh设置

​          现在确认能否不输入口令就用ssh登录localhost:
​           $ ssh localhost        

​          如果不输入口令就无法用ssh登陆localhost，执行下面的命令：
   		   $ ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa 
 	   $ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys 	



### 执行

​          格式化一个新的分布式文件系统：
​           $ bin/hadoop namenode -format        

​		  启动Hadoop守护进程：
​           $ bin/start-all.sh        

Hadoop守护进程的日志写入到         ${HADOOP_LOG_DIR} 目录 (默认是         ${HADOOP_HOME}/logs).

浏览NameNode和JobTracker的网络接口，它们的地址默认为：

- ​             NameNode -             http://localhost:50070/          
- ​             JobTracker -             http://localhost:50030/          

​          将输入文件拷贝到分布式文件系统：
 	   $ bin/hadoop fs -put conf input 	

​          运行发行版提供的示例程序：
​                       $ bin/hadoop jar hadoop-*-examples.jar grep input output 'dfs[a-z.]+'                  

查看输出文件：

​          将输出文件从分布式文件系统拷贝到本地文件系统查看：
​           $ bin/hadoop fs -get output output 
​           $ cat output/*        

 或者 

​          在分布式文件系统上查看输出文件：
​           $ bin/hadoop fs -cat output/*        

​		  完成全部操作后，停止守护进程：
 	   $ bin/stop-all.sh 	



## 完全分布式模式的操作方法

关于搭建完全分布式模式的，有实际意义的集群的资料可以在[这里](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html)找到。

​	     *Java与JNI是Sun Microsystems, Inc.在美国以及其他国家地区的商标或注册商标。*    



# Hadoop集群搭建

- [目的](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#目的)
- [先决条件](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#先决条件)
- [安装](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#安装)
- 配置
  - [配置文件](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#配置文件)
  - 集群配置
    - [配置Hadoop守护进程的运行环境](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#配置Hadoop守护进程的运行环境)
    - [配置Hadoop守护进程的运行参数](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#配置Hadoop守护进程的运行参数)
    - [Slaves](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#Slaves)
    - [日志](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#日志)
- [Hadoop的机架感知](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#Hadoop的机架感知)
- [启动Hadoop](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#启动Hadoop)
- [停止Hadoop](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#停止Hadoop)



## 目的

本文描述了如何安装、配置和管理有实际意义的Hadoop集群，其规模可从几个节点的小集群到几千个节点的超大集群。

如果你希望在单机上安装Hadoop玩玩，从[这里](http://hadoop.apache.org/docs/r1.0.4/cn/quickstart.html)能找到相关细节。



## 先决条件

1. ​          确保在你集群中的每个节点上都安装了所有[必需](http://hadoop.apache.org/docs/r1.0.4/cn/quickstart.html#PreReqs)软件。        
2. ​           [获取](http://hadoop.apache.org/docs/r1.0.4/cn/quickstart.html#下载)Hadoop软件包。        



## 安装

安装Hadoop集群通常要将安装软件解压到集群内的所有机器上。

通常，集群里的一台机器被指定为   NameNode，另一台不同的机器被指定为JobTracker。这些机器是*masters*。余下的机器即作为DataNode*也*作为TaskTracker。这些机器是*slaves*。

我们用HADOOP_HOME指代安装的根路径。通常，集群里的所有机器的HADOOP_HOME路径相同。



## 配置

接下来的几节描述了如何配置Hadoop集群。



### 配置文件

对Hadoop的配置通过conf/目录下的两个重要配置文件完成：

1. ​             [hadoop-default.xml](https://hadoop.apache.org/core/docs/current/hadoop-default.html) - 只读的默认配置。          
2. ​             *hadoop-site.xml* - 集群特有的配置。          

要了解更多关于这些配置文件如何影响Hadoop框架的细节，请看[这里](https://hadoop.apache.org/core/docs/r0.18.2/api/org/apache/hadoop/conf/Configuration.html)。

此外，通过设置conf/hadoop-env.sh中的变量为集群特有的值，你可以对bin/目录下的Hadoop脚本进行控制。



### 集群配置

要配置Hadoop集群，你需要设置Hadoop守护进程的*运行环境*和Hadoop守护进程的*运行参数*。

Hadoop守护进程指NameNode/DataNode         和JobTracker/TaskTracker。



#### 配置Hadoop守护进程的运行环境

管理员可在conf/hadoop-env.sh脚本内对Hadoop守护进程的运行环境做特别指定。

至少，你得设定JAVA_HOME使之在每一远端节点上都被正确设置。

管理员可以通过配置选项HADOOP_*_OPTS来分别配置各个守护进程。          下表是可以配置的选项。          

| 守护进程          | 配置选项                      |
| ----------------- | ----------------------------- |
| NameNode          | HADOOP_NAMENODE_OPTS          |
| DataNode          | HADOOP_DATANODE_OPTS          |
| SecondaryNamenode | HADOOP_SECONDARYNAMENODE_OPTS |
| JobTracker        | HADOOP_JOBTRACKER_OPTS        |
| TaskTracker       | HADOOP_TASKTRACKER_OPTS       |

例如，配置Namenode时,为了使其能够并行回收垃圾（parallelGC），          要把下面的代码加入到hadoop-env.sh :          
           export HADOOP_NAMENODE_OPTS="-XX:+UseParallelGC ${HADOOP_NAMENODE_OPTS}"           

其它可定制的常用参数还包括：

- ​               HADOOP_LOG_DIR - 守护进程日志文件的存放目录。如果不存在会被自动创建。            
- ​               HADOOP_HEAPSIZE - 最大可用的堆大小，单位为MB。比如，1000MB。              这个参数用于设置hadoop守护进程的堆大小。缺省大小是1000MB。            



#### 配置Hadoop守护进程的运行参数

这部分涉及Hadoop集群的重要参数，这些参数在conf/hadoop-site.xml中指定。

| 参数                                           | 取值                                                         | 备注                                                         |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| fs.default.name                                | NameNode的URI。                                              | *hdfs://主机名/*                                             |
| mapred.job.tracker                             | JobTracker的主机（或者IP）和端口。                           | *主机:端口*。                                                |
| dfs.name.dir                                   | NameNode持久存储名字空间及事务日志的本地文件系统路径。       | 当这个值是一个逗号分割的目录列表时，nametable数据将会被复制到所有目录中做冗余备份。 |
| dfs.data.dir                                   | DataNode存放块数据的本地文件系统路径，逗号分割的列表。       | 当这个值是逗号分割的目录列表时，数据将被存储在所有目录下，通常分布在不同设备上。 |
| mapred.system.dir                              | Map/Reduce框架存储系统文件的HDFS路径。比如/hadoop/mapred/system/。 | 这个路径是默认文件系统（HDFS）下的路径， 须从服务器和客户端上均可访问。 |
| mapred.local.dir                               | 本地文件系统下逗号分割的路径列表，Map/Reduce临时数据存放的地方。 | 多路径有助于利用磁盘i/o。                                    |
| mapred.tasktracker.{map\|reduce}.tasks.maximum | 某一TaskTracker上可运行的最大Map/Reduce任务数，这些任务将同时各自运行。 | 默认为2（2个map和2个reduce），可依据硬件情况更改。           |
| dfs.hosts/dfs.hosts.exclude                    | 许可/拒绝DataNode列表。                                      | 如有必要，用这个文件控制许可的datanode列表。                 |
| mapred.hosts/mapred.hosts.exclude              | 许可/拒绝TaskTracker列表。                                   | 如有必要，用这个文件控制许可的TaskTracker列表。              |

通常，上述参数被标记为           [           final](https://hadoop.apache.org/core/docs/r0.18.2/api/org/apache/hadoop/conf/Configuration.html#FinalParams) 以确保它们不被用户应用更改。          



##### 现实世界的集群配置

这节罗列在大规模集群上运行*sort*基准测试(benchmark)时使用到的一些非缺省配置。

- 运行sort900的一些非缺省配置值，sort900即在900个节点的集群上对9TB的数据进行排序：

  | 参数                          | 取值      | 备注                                                        |
  | ----------------------------- | --------- | ----------------------------------------------------------- |
  | dfs.block.size                | 134217728 | 针对大文件系统，HDFS的块大小取128MB。                       |
  | dfs.namenode.handler.count    | 40        | 启动更多的NameNode服务线程去处理来自大量DataNode的RPC请求。 |
  | mapred.reduce.parallel.copies | 20        | reduce启动更多的并行拷贝器以获取大量map的输出。             |
  | mapred.child.java.opts        | -Xmx512M  | 为map/reduce子虚拟机使用更大的堆。                          |
  | fs.inmemory.size.mb           | 200       | 为reduce阶段合并map输出所需的内存文件系统分配更多的内存。   |
  | io.sort.factor                | 100       | 文件排序时更多的流将同时被归并。                            |
  | io.sort.mb                    | 200       | 提高排序时的内存上限。                                      |
  | io.file.buffer.size           | 131072    | SequenceFile中用到的读/写缓存大小。                         |

- 运行sort1400和sort2000时需要更新的配置，即在1400个节点上对14TB的数据进行排序和在2000个节点上对20TB的数据进行排序：

  | 参数                             | 取值      | 备注                                                         |
  | -------------------------------- | --------- | ------------------------------------------------------------ |
  | mapred.job.tracker.handler.count | 60        | 启用更多的JobTracker服务线程去处理来自大量TaskTracker的RPC请求。 |
  | mapred.reduce.parallel.copies    | 50        |                                                              |
  | tasktracker.http.threads         | 50        | 为TaskTracker的Http服务启用更多的工作线程。reduce通过Http服务获取map的中间输出。 |
  | mapred.child.java.opts           | -Xmx1024M | 使用更大的堆用于maps/reduces的子虚拟机                       |



#### Slaves

通常，你选择集群中的一台机器作为NameNode，另外一台不同的机器作为JobTracker。余下的机器即作为DataNode又作为TaskTracker，这些被称之为*slaves*。

在conf/slaves文件中列出所有slave的主机名或者IP地址，一行一个。



#### 日志

Hadoop使用[Apache log4j](http://logging.apache.org/log4j/)来记录日志，它由[Apache Commons Logging](http://commons.apache.org/logging/)框架来实现。编辑conf/log4j.properties文件可以改变Hadoop守护进程的日志配置（日志格式等）。



##### 历史日志

作业的历史文件集中存放在hadoop.job.history.location，这个也可以是在分布式文件系统下的路径，其默认值为${HADOOP_LOG_DIR}/history。jobtracker的web UI上有历史日志的web UI链接。

历史文件在用户指定的目录hadoop.job.history.user.location也会记录一份，这个配置的缺省值为作业的输出目录。这些文件被存放在指定路径下的“_logs/history/”目录中。因此，默认情况下日志文件会在“mapred.output.dir/_logs/history/”下。如果将hadoop.job.history.user.location指定为值none，系统将不再记录此日志。

用户可使用以下命令在指定路径下查看历史日志汇总
             $ bin/hadoop job -history output-dir 
             这条命令会显示作业的细节信息，失败和终止的任务细节。 
            关于作业的更多细节，比如成功的任务，以及对每个任务的所做的尝试次数等可以用下面的命令查看
             $ bin/hadoop job -history all output-dir 

一但全部必要的配置完成，将这些文件分发到所有机器的HADOOP_CONF_DIR路径下，通常是${HADOOP_HOME}/conf。



## Hadoop的机架感知

HDFS和Map/Reduce的组件是能够感知机架的。

NameNode和JobTracker通过调用管理员配置模块中的API[resolve](https://hadoop.apache.org/core/docs/r0.18.2/api/org/apache/hadoop/net/DNSToSwitchMapping.html#resolve(java.util.List))来获取集群里每个slave的机架id。该API将slave的DNS名称（或者IP地址）转换成机架id。使用哪个模块是通过配置项topology.node.switch.mapping.impl来指定的。模块的默认实现会调用topology.script.file.name配置项指定的一个的脚本/命令。 如果topology.script.file.name未被设置，对于所有传入的IP地址，模块会返回/default-rack作为机架id。在Map/Reduce部分还有一个额外的配置项mapred.cache.task.levels，该参数决定cache的级数（在网络拓扑中）。例如，如果默认值是2，会建立两级的cache－ 一级针对主机（主机 -> 任务的映射）另一级针对机架（机架 -> 任务的映射）。      



## 启动Hadoop

启动Hadoop集群需要启动HDFS集群和Map/Reduce集群。

​        格式化一个新的分布式文件系统：
​         $ bin/hadoop namenode -format      

​	在分配的NameNode上，运行下面的命令启动HDFS：
​         $ bin/start-dfs.sh      

bin/start-dfs.sh脚本会参照NameNode上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上启动DataNode守护进程。

​	在分配的JobTracker上，运行下面的命令启动Map/Reduce：
​         $ bin/start-mapred.sh      

bin/start-mapred.sh脚本会参照JobTracker上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上启动TaskTracker守护进程。



## 停止Hadoop

​	在分配的NameNode上，执行下面的命令停止HDFS：
​         $ bin/stop-dfs.sh      

bin/stop-dfs.sh脚本会参照NameNode上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上停止DataNode守护进程。

​	在分配的JobTracker上，运行下面的命令停止Map/Reduce：
​         $ bin/stop-mapred.sh 
​      

bin/stop-mapred.sh脚本会参照JobTracker上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上停止TaskTracker守护进程。



#        Hadoop分布式文件系统：架构和设计    

- [ 引言 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#引言)
-  前提和设计目标 
  - [ 硬件错误 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#硬件错误)
  - [ 流式数据访问 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#流式数据访问)
  - [ 大规模数据集 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#大规模数据集)
  - [ 简单的一致性模型 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#简单的一致性模型)
  - [ “移动计算比移动数据更划算” ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#“移动计算比移动数据更划算”)
  - [ 异构软硬件平台间的可移植性 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#异构软硬件平台间的可移植性)
- [ Namenode 和 Datanode ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#Namenode+和+Datanode)
- [ 文件系统的名字空间 (namespace) ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#文件系统的名字空间+(namespace))
-  数据复制 
  - [ 副本存放: 最最开始的一步 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#副本存放%3A+最最开始的一步)
  - [ 副本选择 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#副本选择)
  - [ 安全模式 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#安全模式)
- [ 文件系统元数据的持久化 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#文件系统元数据的持久化)
- [ 通讯协议 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#通讯协议)
-  健壮性 
  - [ 磁盘数据错误，心跳检测和重新复制 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#磁盘数据错误，心跳检测和重新复制)
  - [ 集群均衡 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#集群均衡)
  - [ 数据完整性 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#数据完整性)
  - [ 元数据磁盘错误 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#元数据磁盘错误)
  - [ 快照 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#快照)
-  数据组织 
  - [ 数据块 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#数据块)
  - [ Staging ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#Staging)
  - [ 流水线复制 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#流水线复制)
-  可访问性 
  - [ DFSShell ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#DFSShell)
  - [ DFSAdmin ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#DFSAdmin)
  - [ 浏览器接口 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#浏览器接口)
-  存储空间回收 
  - [ 文件的删除和恢复 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#文件的删除和恢复)
  - [ 减少副本系数 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#减少副本系数)
- [ 参考资料 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html#参考资料)



##  引言 

​	      Hadoop分布式文件系统(HDFS)被设计成适合运行在通用硬件(commodity  hardware)上的分布式文件系统。它和现有的分布式文件系统有很多共同点。但同时，它和其他的分布式文件系统的区别也是很明显的。HDFS是一个高度容错性的系统，适合部署在廉价的机器上。HDFS能提供高吞吐量的数据访问，非常适合大规模数据集上的应用。HDFS放宽了一部分POSIX约束，来实现流式读取文件系统数据的目的。HDFS在最开始是作为Apache Nutch搜索引擎项目的基础架构而开发的。HDFS是Apache Hadoop Core项目的一部分。这个项目的地址是https://hadoop.apache.org/core/。      



##  前提和设计目标 



###  硬件错误 

​	 硬件错误是常态而不是异常。HDFS可能由成百上千的服务器所构成，每个服务器上存储着文件系统的部分数据。我们面对的现实是构成系统的组件数目是巨大的，而且任一组件都有可能失效，这意味着总是有一部分HDFS的组件是不工作的。因此错误检测和快速、自动的恢复是HDFS最核心的架构目标。       



###  流式数据访问 

运行在HDFS上的应用和普通的应用不同，需要流式访问它们的数据集。HDFS的设计中更多的考虑到了数据批处理，而不是用户交互处理。比之数据访问的低延迟问题，更关键的在于数据访问的高吞吐量。POSIX标准设置的很多硬性约束对HDFS应用系统不是必需的。为了提高数据的吞吐量，在一些关键方面对POSIX的语义做了一些修改。                



###  大规模数据集 

​         运行在HDFS上的应用具有很大的数据集。HDFS上的一个典型文件大小一般都在G字节至T字节。因此，HDFS被调节以支持大文件存储。它应该能提供整体上高的数据传输带宽，能在一个集群里扩展到数百个节点。一个单一的HDFS实例应该能支撑数以千万计的文件。        



###  简单的一致性模型 

​         HDFS应用需要一个“一次写入多次读取”的文件访问模型。一个文件经过创建、写入和关闭之后就不需要改变。这一假设简化了数据一致性问题，并且使高吞吐量的数据访问成为可能。Map/Reduce应用或者网络爬虫应用都非常适合这个模型。目前还有计划在将来扩充这个模型，使之支持文件的附加写操作。         



###  “移动计算比移动数据更划算” 

​         一个应用请求的计算，离它操作的数据越近就越高效，在数据达到海量级别的时候更是如此。因为这样就能降低网络阻塞的影响，提高系统数据的吞吐量。将计算移动到数据附近，比之将数据移动到应用所在显然更好。HDFS为应用提供了将它们自己移动到数据附近的接口。         



###  异构软硬件平台间的可移植性 

​        HDFS在设计的时候就考虑到平台的可移植性。这种特性方便了HDFS作为大规模数据应用平台的推广。        



##  Namenode 和 Datanode 

​       HDFS采用master/slave架构。一个HDFS集群是由一个Namenode和一定数目的Datanodes组成。Namenode是一个中心服务器，负责管理文件系统的名字空间(namespace)以及客户端对文件的访问。集群中的Datanode一般是一个节点一个，负责管理它所在节点上的存储。HDFS暴露了文件系统的名字空间，用户能够以文件的形式在上面存储数据。从内部看，一个文件其实被分成一个或多个数据块，这些块存储在一组Datanode上。Namenode执行文件系统的名字空间操作，比如打开、关闭、重命名文件或目录。它也负责确定数据块到具体Datanode节点的映射。Datanode负责处理文件系统客户端的读写请求。在Namenode的统一调度下进行数据块的创建、删除和复制。      

![HDFS 架构](http://hadoop.apache.org/docs/r1.0.4/cn/images/hdfsarchitecture.gif)

​      Namenode和Datanode被设计成可以在普通的商用机器上运行。这些机器一般运行着GNU/Linux操作系统(OS)。HDFS采用Java语言开发，因此任何支持Java的机器都可以部署Namenode或Datanode。由于采用了可移植性极强的Java语言，使得HDFS可以部署到多种类型的机器上。一个典型的部署场景是一台机器上只运行一个Namenode实例，而集群中的其它机器分别运行一个Datanode实例。这种架构并不排斥在一台机器上运行多个Datanode，只不过这样的情况比较少见。      

​      集群中单一Namenode的结构大大简化了系统的架构。Namenode是所有HDFS元数据的仲裁者和管理者，这样，用户数据永远不会流过Namenode。      



##  文件系统的名字空间 (namespace) 

​       HDFS支持传统的层次型文件组织结构。用户或者应用程序可以创建目录，然后将文件保存在这些目录里。文件系统名字空间的层次结构和大多数现有的文件系统类似：用户可以创建、删除、移动或重命名文件。当前，HDFS不支持用户磁盘配额和访问权限控制，也不支持硬链接和软链接。但是HDFS架构并不妨碍实现这些特性。      

​      Namenode负责维护文件系统的名字空间，任何对文件系统名字空间或属性的修改都将被Namenode记录下来。应用程序可以设置HDFS保存的文件的副本数目。文件副本的数目称为文件的副本系数，这个信息也是由Namenode保存的。      



##  数据复制 

​       HDFS被设计成能够在一个大集群中跨机器可靠地存储超大文件。它将每个文件存储成一系列的数据块，除了最后一个，所有的数据块都是同样大小的。为了容错，文件的所有数据块都会有副本。每个文件的数据块大小和副本系数都是可配置的。应用程序可以指定某个文件的副本数目。副本系数可以在文件创建的时候指定，也可以在之后改变。HDFS中的文件都是一次性写入的，并且严格要求在任何时候只能有一个写入者。       

​      Namenode全权管理数据块的复制，它周期性地从集群中的每个Datanode接收心跳信号和块状态报告(Blockreport)。接收到心跳信号意味着该Datanode节点工作正常。块状态报告包含了一个该Datanode上所有数据块的列表。    

![HDFS Datanodes](http://hadoop.apache.org/docs/r1.0.4/cn/images/hdfsdatanodes.gif)



###  副本存放: 最最开始的一步 

​         副本的存放是HDFS可靠性和性能的关键。优化的副本存放策略是HDFS区分于其他大部分分布式文件系统的重要特性。这种特性需要做大量的调优，并需要经验的积累。HDFS采用一种称为机架感知(rack-aware)的策略来改进数据的可靠性、可用性和网络带宽的利用率。目前实现的副本存放策略只是在这个方向上的第一步。实现这个策略的短期目标是验证它在生产环境下的有效性，观察它的行为，为实现更先进的策略打下测试和研究的基础。         

​	大型HDFS实例一般运行在跨越多个机架的计算机组成的集群上，不同机架上的两台机器之间的通讯需要经过交换机。在大多数情况下，同一个机架内的两台机器间的带宽会比不同机架的两台机器间的带宽大。                

​        通过一个[机架感知](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html#Hadoop的机架感知)的过程，Namenode可以确定每个Datanode所属的机架id。一个简单但没有优化的策略就是将副本存放在不同的机架上。这样可以有效防止当整个机架失效时数据的丢失，并且允许读数据的时候充分利用多个机架的带宽。这种策略设置可以将副本均匀分布在集群中，有利于当组件失效情况下的负载均衡。但是，因为这种策略的一个写操作需要传输数据块到多个机架，这增加了写的代价。         

​         在大多数情况下，副本系数是3，HDFS的存放策略是将一个副本存放在本地机架的节点上，一个副本放在同一机架的另一个节点上，最后一个副本放在不同机架的节点上。这种策略减少了机架间的数据传输，这就提高了写操作的效率。机架的错误远远比节点的错误少，所以这个策略不会影响到数据的可靠性和可用性。于此同时，因为数据块只放在两个（不是三个）不同的机架上，所以此策略减少了读取数据时需要的网络传输总带宽。在这种策略下，副本并不是均匀分布在不同的机架上。三分之一的副本在一个节点上，三分之二的副本在一个机架上，其他副本均匀分布在剩下的机架中，这一策略在不损害数据可靠性和读取性能的情况下改进了写的性能。        

​        当前，这里介绍的默认副本存放策略正在开发的过程中。        



###  副本选择 

​        为了降低整体的带宽消耗和读取延时，HDFS会尽量让读取程序读取离它最近的副本。如果在读取程序的同一个机架上有一个副本，那么就读取该副本。如果一个HDFS集群跨越多个数据中心，那么客户端也将首先读本地数据中心的副本。        



###  安全模式 

​	Namenode启动后会进入一个称为安全模式的特殊状态。处于安全模式的Namenode是不会进行数据块的复制的。Namenode从所有的  Datanode接收心跳信号和块状态报告。块状态报告包括了某个Datanode所有的数据块列表。每个数据块都有一个指定的最小副本数。当Namenode检测确认某个数据块的副本数目达到这个最小值，那么该数据块就会被认为是副本安全(safely  replicated)的；在一定百分比（这个参数可配置）的数据块被Namenode检测确认是安全之后（加上一个额外的30秒等待时间），Namenode将退出安全模式状态。接下来它会确定还有哪些数据块的副本没有达到指定数目，并将这些数据块复制到其他Datanode上。        



##  文件系统元数据的持久化 

​	 Namenode上保存着HDFS的名字空间。对于任何对文件系统元数据产生修改的操作，Namenode都会使用一种称为EditLog的事务日志记录下来。例如，在HDFS中创建一个文件，Namenode就会在Editlog中插入一条记录来表示；同样地，修改文件的副本系数也将往Editlog插入一条记录。Namenode在本地操作系统的文件系统中存储这个Editlog。整个文件系统的名字空间，包括数据块到文件的映射、文件的属性等，都存储在一个称为FsImage的文件中，这个文件也是放在Namenode所在的本地文件系统上。        

​         Namenode在内存中保存着整个文件系统的名字空间和文件数据块映射(Blockmap)的映像。这个关键的元数据结构设计得很紧凑，因而一个有4G内存的Namenode足够支撑大量的文件和目录。当Namenode启动时，它从硬盘中读取Editlog和FsImage，将所有Editlog中的事务作用在内存中的FsImage上，并将这个新版本的FsImage从内存中保存到本地磁盘上，然后删除旧的Editlog，因为这个旧的Editlog的事务都已经作用在FsImage上了。这个过程称为一个检查点(checkpoint)。在当前实现中，检查点只发生在Namenode启动时，在不久的将来将实现支持周期性的检查点。        

​	 Datanode将HDFS数据以文件的形式存储在本地的文件系统中，它并不知道有关HDFS文件的信息。它把每个HDFS数据块存储在本地文件系统的一个单独的文件中。Datanode并不在同一个目录创建所有的文件，实际上，它用试探的方法来确定每个目录的最佳文件数目，并且在适当的时候创建子目录。在同一个目录中创建所有的本地文件并不是最优的选择，这是因为本地文件系统可能无法高效地在单个目录中支持大量的文件。当一个Datanode启动时，它会扫描本地文件系统，产生一个这些本地文件对应的所有HDFS数据块的列表，然后作为报告发送到Namenode，这个报告就是块状态报告。                 



##  通讯协议 

​      所有的HDFS通讯协议都是建立在TCP/IP协议之上。客户端通过一个可配置的TCP端口连接到Namenode，通过ClientProtocol协议与Namenode交互。而Datanode使用DatanodeProtocol协议与Namenode交互。一个远程过程调用(RPC)模型被抽象出来封装ClientProtocol和Datanodeprotocol协议。在设计上，Namenode不会主动发起RPC，而是响应来自客户端或 Datanode 的RPC请求。       



##  健壮性 

​	      HDFS的主要目标就是即使在出错的情况下也要保证数据存储的可靠性。常见的三种出错情况是：Namenode出错, Datanode出错和网络割裂(network partitions)。      



###  磁盘数据错误，心跳检测和重新复制 

​         每个Datanode节点周期性地向Namenode发送心跳信号。网络割裂可能导致一部分Datanode跟Namenode失去联系。Namenode通过心跳信号的缺失来检测这一情况，并将这些近期不再发送心跳信号Datanode标记为宕机，不会再将新的IO请求发给它们。任何存储在宕机Datanode上的数据将不再有效。Datanode的宕机可能会引起一些数据块的副本系数低于指定值，Namenode不断地检测这些需要复制的数据块，一旦发现就启动复制操作。在下列情况下，可能需要重新复制：某个Datanode节点失效，某个副本遭到损坏，Datanode上的硬盘错误，或者文件的副本系数增大。        



###  集群均衡 

​         HDFS的架构支持数据均衡策略。如果某个Datanode节点上的空闲空间低于特定的临界点，按照均衡策略系统就会自动地将数据从这个Datanode移动到其他空闲的Datanode。当对某个文件的请求突然增加，那么也可能启动一个计划创建该文件新的副本，并且同时重新平衡集群中的其他数据。这些均衡策略目前还没有实现。        



###  数据完整性 

​                 从某个Datanode获取的数据块有可能是损坏的，损坏可能是由Datanode的存储设备错误、网络错误或者软件bug造成的。HDFS客户端软件实现了对HDFS文件内容的校验和(checksum)检查。当客户端创建一个新的HDFS文件，会计算这个文件每个数据块的校验和，并将校验和作为一个单独的隐藏文件保存在同一个HDFS名字空间下。当客户端获取文件内容后，它会检验从Datanode获取的数据跟相应的校验和文件中的校验和是否匹配，如果不匹配，客户端可以选择从其他Datanode获取该数据块的副本。        



###  元数据磁盘错误 

​         FsImage和Editlog是HDFS的核心数据结构。如果这些文件损坏了，整个HDFS实例都将失效。因而，Namenode可以配置成支持维护多个FsImage和Editlog的副本。任何对FsImage或者Editlog的修改，都将同步到它们的副本上。这种多副本的同步操作可能会降低Namenode每秒处理的名字空间事务数量。然而这个代价是可以接受的，因为即使HDFS的应用是数据密集的，它们也非元数据密集的。当Namenode重启的时候，它会选取最近的完整的FsImage和Editlog来使用。        

​         Namenode是HDFS集群中的单点故障(single point of failure)所在。如果Namenode机器故障，是需要手工干预的。目前，自动重启或在另一台机器上做Namenode故障转移的功能还没实现。        



###  快照 

​        快照支持某一特定时刻的数据的复制备份。利用快照，可以让HDFS在数据损坏时恢复到过去一个已知正确的时间点。HDFS目前还不支持快照功能，但计划在将来的版本进行支持。        



##  数据组织 



###  数据块 

​         HDFS被设计成支持大文件，适用HDFS的是那些需要处理大规模的数据集的应用。这些应用都是只写入数据一次，但却读取一次或多次，并且读取速度应能满足流式读取的需要。HDFS支持文件的“一次写入多次读取”语义。一个典型的数据块大小是64MB。因而，HDFS中的文件总是按照64M被切分成不同的块，每个块尽可能地存储于不同的Datanode中。        



###  Staging 

​         客户端创建文件的请求其实并没有立即发送给Namenode，事实上，在刚开始阶段HDFS客户端会先将文件数据缓存到本地的一个临时文件。应用程序的写操作被透明地重定向到这个临时文件。当这个临时文件累积的数据量超过一个数据块的大小，客户端才会联系Namenode。Namenode将文件名插入文件系统的层次结构中，并且分配一个数据块给它。然后返回Datanode的标识符和目标数据块给客户端。接着客户端将这块数据从本地临时文件上传到指定的Datanode上。当文件关闭时，在临时文件中剩余的没有上传的数据也会传输到指定的Datanode上。然后客户端告诉Namenode文件已经关闭。此时Namenode才将文件创建操作提交到日志里进行存储。如果Namenode在文件关闭前宕机了，则该文件将丢失。        

​        上述方法是对在HDFS上运行的目标应用进行认真考虑后得到的结果。这些应用需要进行文件的流式写入。如果不采用客户端缓存，由于网络速度和网络堵塞会对吞估量造成比较大的影响。这种方法并不是没有先例的，早期的文件系统，比如AFS，就用客户端缓存来提高性能。为了达到更高的数据上传效率，已经放松了POSIX标准的要求。        



###  流水线复制 

​         当客户端向HDFS文件写入数据的时候，一开始是写到本地临时文件中。假设该文件的副本系数设置为3，当本地临时文件累积到一个数据块的大小时，客户端会从Namenode获取一个Datanode列表用于存放副本。然后客户端开始向第一个Datanode传输数据，第一个Datanode一小部分一小部分(4  KB)地接收数据，将每一部分写入本地仓库，并同时传输该部分到列表中第二个Datanode节点。第二个Datanode也是这样，一小部分一小部分地接收数据，写入本地仓库，并同时传给第三个Datanode。最后，第三个Datanode接收数据并存储在本地。因此，Datanode能流水线式地从前一个节点接收数据，并在同时转发给下一个节点，数据以流水线的方式从前一个Datanode复制到下一个。        



##  可访问性 

​      HDFS给应用提供了多种访问方式。用户可以通过[Java API](https://hadoop.apache.org/core/docs/current/api/)接口访问，也可以通过C语言的封装API访问，还可以通过浏览器的方式访问HDFS中的文件。通过WebDAV协议访问的方式正在开发中。      



###  DFSShell 

​        HDFS以文件和目录的形式组织用户数据。它提供了一个命令行的接口(DFSShell)让用户与HDFS中的数据进行交互。命令的语法和用户熟悉的其他shell(例如 bash, csh)工具类似。下面是一些动作/命令的示例：        

| 动作                                   | 命令                                   |
| -------------------------------------- | -------------------------------------- |
| 创建一个名为 /foodir 的目录            | bin/hadoop dfs -mkdir /foodir          |
| 创建一个名为 /foodir 的目录            | bin/hadoop dfs -mkdir /foodir          |
| 查看名为 /foodir/myfile.txt 的文件内容 | bin/hadoop dfs -cat /foodir/myfile.txt |

​        DFSShell 可以用在那些通过脚本语言和文件系统进行交互的应用程序上。        



###  DFSAdmin 

​		DFSAdmin 命令用来管理HDFS集群。这些命令只有HDSF的管理员才能使用。下面是一些动作/命令的示例：        

| 动作                            | 命令                                           |
| ------------------------------- | ---------------------------------------------- |
| 将集群置于安全模式              | bin/hadoop dfsadmin -safemode enter            |
| 显示Datanode列表                | bin/hadoop dfsadmin -report                    |
| 使Datanode节点 datanodename退役 | bin/hadoop dfsadmin -decommission datanodename |



###  浏览器接口 

​	一个典型的HDFS安装会在一个可配置的TCP端口开启一个Web服务器用于暴露HDFS的名字空间。用户可以用浏览器来浏览HDFS的名字空间和查看文件的内容。       



##  存储空间回收 



###  文件的删除和恢复 

​       当用户或应用程序删除某个文件时，这个文件并没有立刻从HDFS中删除。实际上，HDFS会将这个文件重命名转移到/trash目录。只要文件还在/trash目录中，该文件就可以被迅速地恢复。文件在/trash中保存的时间是可配置的，当超过这个时间时，Namenode就会将该文件从名字空间中删除。删除文件会使得该文件相关的数据块被释放。注意，从用户删除文件到HDFS空闲空间的增加之间会有一定时间的延迟。

只要被删除的文件还在/trash目录中，用户就可以恢复这个文件。如果用户想恢复被删除的文件，他/她可以浏览/trash目录找回该文件。/trash目录仅仅保存被删除文件的最后副本。/trash目录与其他的目录没有什么区别，除了一点：在该目录上HDFS会应用一个特殊策略来自动删除文件。目前的默认策略是删除/trash中保留时间超过6小时的文件。将来，这个策略可以通过一个被良好定义的接口配置。        



###  减少副本系数 

​        当一个文件的副本系数被减小后，Namenode会选择过剩的副本删除。下次心跳检测时会将该信息传递给Datanode。Datanode遂即移除相应的数据块，集群中的空闲空间加大。同样，在调用setReplication API结束和集群中空闲空间增加间会有一定的延迟。



##  参考资料 

​      HDFS Java API:       [          https://hadoop.apache.org/core/docs/current/api/       ](https://hadoop.apache.org/core/docs/current/api/)      

​      HDFS 源代码:       [          https://hadoop.apache.org/core/version_control.html       ](https://hadoop.apache.org/core/version_control.html)      

by Dhruba Borthakur

#       Hadoop分布式文件系统使用指南    

- [目的](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#目的)
- [ 概述 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#概述)
- [ 先决条件 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#先决条件)
- [ Web接口 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#Web接口)
- Shell命令
  - [ DFSAdmin命令 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#DFSAdmin命令)
- [ Secondary NameNode ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#Secondary+NameNode)
- [ Rebalancer ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#Rebalancer)
- [ 机架感知（Rack awareness） ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#机架感知（Rack+awareness）)
- [ 安全模式 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#安全模式)
- [ fsck ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#fsck)
- [ 升级和回滚 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#升级和回滚)
- [ 文件权限和安全性 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#文件权限和安全性)
- [ 可扩展性 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#可扩展性)
- [ 相关文档 ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#相关文档)



## 目的

​	本文档的目标是为Hadoop分布式文件系统（HDFS）的用户提供一个学习的起点，这里的HDFS既可以作为[Hadoop](https://hadoop.apache.org/)集群的一部分，也可以作为一个独立的分布式文件系统。虽然HDFS在很多环境下被设计成是可正确工作的，但是了解HDFS的工作原理对在特定集群上改进HDFS的运行性能和错误诊断都有极大的帮助。      



##  概述 

HDFS是Hadoop应用用到的一个最主要的分布式存储系统。一个HDFS集群主要由一个NameNode和很多个Datanode组成：Namenode管理文件系统的元数据，而Datanode存储了实际的数据。HDFS的体系结构在[这里](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html)有详细的描述。本文档主要关注用户以及管理员怎样和HDFS进行交互。[HDFS架构设计](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html)中的[图解](http://hadoop.apache.org/docs/r1.0.4/cn/images/hdfsarchitecture.gif)描述了Namenode、Datanode和客户端之间的基本的交互操作。基本上，客户端联系Namenode以获取文件的元数据或修饰属性，而真正的文件I/O操作是直接和Datanode进行交互的。      

​      下面列出了一些多数用户都比较感兴趣的重要特性。      

- ​    Hadoop（包括HDFS）非常适合在商用硬件（commodity hardware）上做分布式存储和计算，因为它不仅具有容错性和可扩展性，而且非常易于扩展。[Map-Reduce](http://hadoop.apache.org/docs/r1.0.4/cn/mapred_tutorial.html)框架以其在大型分布式系统应用上的简单性和可用性而著称，这个框架已经被集成进Hadoop中。    
- ​    	HDFS的可配置性极高，同时，它的默认配置能够满足很多的安装环境。多数情况下，这些参数只在非常大规模的集群环境下才需要调整。    
- ​    	用Java语言开发，支持所有的主流平台。    
- ​    	支持类Shell命令，可直接和HDFS进行交互。    
- ​    	NameNode和DataNode有内置的Web服务器，方便用户检查集群的当前状态。    
- ​	新特性和改进会定期加入HDFS的实现中。下面列出的是HDFS中常用特性的一部分：      
  - ​    		文件权限和授权。    	
  - ​    		机架感知（Rack awareness）：在调度任务和分配存储空间时考虑节点的物理位置。    	
  - ​    		安全模式：一种维护需要的管理模式。    	
  - ​    		fsck：一个诊断文件系统健康状况的工具，能够发现丢失的文件或数据块。    	
  - ​    		Rebalancer：当datanode之间数据不均衡时，平衡集群上的数据负载。    	
  - ​    		升级和回滚：在软件更新后有异常发生的情形下，能够回滚到HDFS升级之前的状态。    	
  - ​		Secondary Namenode：对文件系统名字空间执行周期性的检查点，将Namenode上HDFS改动日志文件的大小控制在某个特定的限度下。    	



##  先决条件 

​    下面的文档描述了如何安装和搭建Hadoop集群：    

-  		 [Hadoop快速入门](http://hadoop.apache.org/docs/r1.0.4/cn/quickstart.html) 		针对初次使用者。 	
- ​		 [Hadoop集群搭建](http://hadoop.apache.org/docs/r1.0.4/cn/cluster_setup.html) 		针对大规模分布式集群的搭建。 	

​    文档余下部分假设用户已经安装并运行了至少包含一个Datanode节点的HDFS。就本文目的来说，Namenode和Datanode可以运行在同一个物理主机上。    



##  Web接口 

 	NameNode和DataNode各自启动了一个内置的Web服务器，显示了集群当前的基本状态和信息。在默认配置下NameNode的首页地址是http://namenode-name:50070/。这个页面列出了集群里的所有DataNode和集群的基本状态。这个Web接口也可以用来浏览整个文件系统（使用NameNode首页上的"Browse the file system"链接）。 



## Shell命令

Hadoop包括一系列的类shell的命令，可直接和HDFS以及其他Hadoop支持的文件系统进行交互。bin/hadoop fs -help 命令列出所有Hadoop Shell支持的命令。而 bin/hadoop fs -help command-name 命令能显示关于某个命令的详细信息。这些命令支持大多数普通文件系统的操作，比如复制文件、改变文件权限等。它还支持一些HDFS特有的操作，比如改变文件副本数目。     



###  DFSAdmin命令 

   	 'bin/hadoop dfsadmin' 命令支持一些和HDFS管理相关的操作。bin/hadoop dfsadmin -help 命令能列出所有当前支持的命令。比如：   

-    	     -report：报告HDFS的基本统计信息。有些信息也可以在NameNode Web服务首页看到。    	
-    	     -safemode：虽然通常并不需要，但是管理员的确可以手动让NameNode进入或离开安全模式。   	
-    	     -finalizeUpgrade：删除上一次升级时制作的集群备份。   	



##  Secondary NameNode 

NameNode将对文件系统的改动追加保存到本地文件系统上的一个日志文件（edits）。当一个NameNode启动时，它首先从一个映像文件（fsimage）中读取HDFS的状态，接着应用日志文件中的edits操作。然后它将新的HDFS状态写入（fsimage）中，并使用一个空的edits文件开始正常操作。因为NameNode只有在启动阶段才合并fsimage和edits，所以久而久之日志文件可能会变得非常庞大，特别是对大型的集群。日志文件太大的另一个副作用是下一次NameNode启动会花很长时间。   

​     Secondary  NameNode定期合并fsimage和edits日志，将edits日志文件大小控制在一个限度下。因为内存需求和NameNode在一个数量级上，所以通常secondary NameNode和NameNode运行在不同的机器上。Secondary NameNode通过bin/start-dfs.sh在conf/masters中指定的节点上启动。   

Secondary NameNode的检查点进程启动，是由两个配置参数控制的：

- ​         fs.checkpoint.period，指定连续两次检查点的最大时间间隔，        默认值是1小时。      
- ​         fs.checkpoint.size定义了edits日志文件的最大值，一旦超过这个值会导致强制执行检查点（即使没到检查点的最大时间间隔）。默认值是64MB。      

​     Secondary NameNode保存最新检查点的目录与NameNode的目录结构相同。     所以NameNode可以在需要的时候读取Secondary NameNode上的检查点镜像。   

​     如果NameNode上除了最新的检查点以外，所有的其他的历史镜像和edits文件都丢失了，     NameNode可以引入这个最新的检查点。以下操作可以实现这个功能：   

- ​        在配置参数dfs.name.dir指定的位置建立一个空文件夹；      
- ​        把检查点目录的位置赋值给配置参数fs.checkpoint.dir；      
- ​        启动NameNode，并加上-importCheckpoint。       

​     NameNode会从fs.checkpoint.dir目录读取检查点，     并把它保存在dfs.name.dir目录下。     如果dfs.name.dir目录下有合法的镜像文件，NameNode会启动失败。     NameNode会检查fs.checkpoint.dir目录下镜像文件的一致性，但是不会去改动它。   

​     命令的使用方法请参考[secondarynamenode 命令](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#secondarynamenode).   



##  Rebalancer 

​       HDFS的数据也许并不是非常均匀的分布在各个DataNode中。一个常见的原因是在现有的集群上经常会增添新的DataNode节点。当新增一个数据块（一个文件的数据被保存在一系列的块中）时，NameNode在选择DataNode接收这个数据块之前，会考虑到很多因素。其中的一些考虑的是：    

- ​	将数据块的一个副本放在正在写这个数据块的节点上。      
- ​        尽量将数据块的不同副本分布在不同的机架上，这样集群可在完全失去某一机架的情况下还能存活。      
- ​        一个副本通常被放置在和写文件的节点同一机架的某个节点上，这样可以减少跨越机架的网络I/O。      
- ​        尽量均匀地将HDFS数据分布在集群的DataNode中。      

由于上述多种考虑需要取舍，数据可能并不会均匀分布在DataNode中。HDFS为管理员提供了一个工具，用于分析数据块分布和重新平衡DataNode上的数据分布。[HADOOP-1652](http://issues.apache.org/jira/browse/HADOOP-1652)的附件中的一个[PDF](http://issues.apache.org/jira/secure/attachment/12368261/RebalanceDesign6.pdf)是一个简要的rebalancer管理员指南。    

​     使用方法请参考[balancer 命令](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#balancer).   



##  机架感知（Rack awareness） 

​      通常，大型Hadoop集群是以机架的形式来组织的，同一个机架上不同节点间的网络状况比不同机架之间的更为理想。另外，NameNode设法将数据块副本保存在不同的机架上以提高容错性。Hadoop允许集群的管理员通过配置dfs.network.script参数来确定节点所处的机架。当这个脚本配置完毕，每个节点都会运行这个脚本来获取它的机架ID。默认的安装假定所有的节点属于同一个机架。这个特性及其配置参数在[HADOOP-692](http://issues.apache.org/jira/browse/HADOOP-692)所附的[PDF](http://issues.apache.org/jira/secure/attachment/12345251/Rack_aware_HDFS_proposal.pdf)上有更详细的描述。    



##  安全模式 

​      NameNode启动时会从fsimage和edits日志文件中装载文件系统的状态信息，接着它等待各个DataNode向它报告它们各自的数据块状态，这样，NameNode就不会过早地开始复制数据块，即使在副本充足的情况下。这个阶段，NameNode处于安全模式下。NameNode的安全模式本质上是HDFS集群的一种只读模式，此时集群不允许任何对文件系统或者数据块修改的操作。通常NameNode会在开始阶段自动地退出安全模式。如果需要，你也可以通过'bin/hadoop dfsadmin -safemode'命令显式地将HDFS置于安全模式。NameNode首页会显示当前是否处于安全模式。关于安全模式的更多介绍和配置信息请参考JavaDoc：[setSafeMode()](https://hadoop.apache.org/core/docs/current/api/org/apache/hadoop/dfs/NameNode.html#setSafeMode(org.apache.hadoop.dfs.FSConstants.SafeModeAction))。    



##  fsck 

​          HDFS支持fsck命令来检查系统中的各种不一致状况。这个命令被设计来报告各种文件存在的问题，比如文件缺少数据块或者副本数目不够。不同于在本地文件系统上传统的fsck工具，这个命令并不会修正它检测到的错误。一般来说，NameNode会自动修正大多数可恢复的错误。HDFS的fsck不是一个Hadoop shell命令。它通过'bin/hadoop fsck'执行。 命令的使用方法请参考[fsck命令](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#fsck) fsck可用来检查整个文件系统，也可以只检查部分文件。      



##  升级和回滚 

当在一个已有集群上升级Hadoop时，像其他的软件升级一样，可能会有新的bug或一些会影响到现有应用的非兼容性变更出现。在任何有实际意义的HDSF系统上，丢失数据是不被允许的，更不用说重新搭建启动HDFS了。HDFS允许管理员退回到之前的Hadoop版本，并将集群的状态回滚到升级之前。更多关于HDFS升级的细节在[升级wiki](https://wiki.apache.org/hadoop/Hadoop Upgrade)上可以找到。HDFS在一个时间可以有一个这样的备份。在升级之前，管理员需要用bin/hadoop dfsadmin -finalizeUpgrade（升级终结操作）命令删除存在的备份文件。下面简单介绍一下一般的升级过程：     

- 升级 Hadoop 软件之前，请检查是否已经存在一个备份，如果存在，可执行升级终结操作删除这个备份。通过dfsadmin -upgradeProgress status命令能够知道是否需要对一个集群执行升级终结操作。
- 停止集群并部署新版本的Hadoop。
- 使用-upgrade选项运行新的版本（bin/start-dfs.sh -upgrade）。      
- 在大多数情况下，集群都能够正常运行。一旦我们认为新的HDFS运行正常（也许经过几天的操作之后），就可以对之执行升级终结操作。注意，在对一个集群执行升级终结操作之前，删除那些升级前就已经存在的文件并不会真正地释放DataNodes上的磁盘空间。
- 如果需要退回到老版本， 
  - 停止集群并且部署老版本的Hadoop。
  - 用回滚选项启动集群（bin/start-dfs.h -rollback）。



##  文件权限和安全性 

​                  这里的文件权限和其他常见平台如Linux的文件权限类似。目前，安全性仅限于简单的文件权限。启动NameNode的用户被视为HDFS的超级用户。HDFS以后的版本将会支持网络验证协议（比如Kerberos）来对用户身份进行验证和对数据进行加密传输。具体的细节请参考[权限使用管理指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。     



##  可扩展性 

​      现在，Hadoop已经运行在上千个节点的集群上。[Powered By Hadoop](https://wiki.apache.org/hadoop/PoweredBy)页面列出了一些已将Hadoop部署在他们的大型集群上的组织。HDFS集群只有一个NameNode节点。目前，NameNode上可用内存大小是一个主要的扩展限制。在超大型的集群中，增大HDFS存储文件的平均大小能够增大集群的规模，而不需要增加NameNode的内存。默认配置也许并不适合超大规模的集群。[Hadoop FAQ](https://wiki.apache.org/hadoop/FAQ)页面列举了针对大型Hadoop集群的配置改进。



##  相关文档 

​      这个用户手册给用户提供了一个学习和使用HDSF文件系统的起点。本文档会不断地进行改进，同时，用户也可以参考更多的Hadoop和HDFS文档。下面的列表是用户继续学习的起点：      

- ​         [Hadoop官方主页](https://hadoop.apache.org/)：所有Hadoop相关的起始页。      
- ​         [Hadoop Wiki](https://wiki.apache.org/hadoop/FrontPage)：Hadoop Wiki文档首页。这个指南是Hadoop代码树中的一部分，与此不同，Hadoop Wiki是由Hadoop社区定期编辑的。      
- Hadoop Wiki上的[FAQ](https://wiki.apache.org/hadoop/FAQ)。      
- Hadoop [JavaDoc API](https://hadoop.apache.org/core/docs/current/api/)。
- Hadoop用户邮件列表：[core-user[at\]hadoop.apache.org](mailto:core-user@hadoop.apache.org)。
- 查看conf/hadoop-default.xml文件。这里包括了大多数配置参数的简要描述。
- ​         [命令手册](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html)：命令使用说明。      

#       HDFS权限管理用户指南    

- [概述](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#概述)
- [用户身份](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#用户身份)
- [理解系统的实现](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#理解系统的实现)
- [文件系统API变更](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#文件系统API变更)
- [Shell命令变更](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#Shell命令变更)
- [超级用户](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#超级用户)
- [Web服务器](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#Web服务器)
- [在线升级](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#在线升级)
- [配置参数](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html#配置参数)



## 概述

​		Hadoop分布式文件系统实现了一个和POSIX系统类似的文件和目录的权限模型。每个文件和目录有一个*所有者（owner）*和一个*组（group）*。文件或目录对其所有者、同组的其他用户以及所有其他用户分别有着不同的权限。对文件而言，当读取这个文件时需要有*r*权限，当写入或者追加到文件时需要有*w*权限。对目录而言，当列出目录内容时需要具有*r*权限，当新建或删除子文件或子目录时需要有*w*权限，当访问目录的子节点时需要有*x*权限。不同于POSIX模型，HDFS权限模型中的文件没有*sticky*，*setuid*或*setgid*位，因为这里没有可执行文件的概念。为了简单起见，这里也没有目录的*sticky*，*setuid*或*setgid*位。总的来说，文件或目录的权限就是它的*模式（mode）*。HDFS采用了Unix表示和显示模式的习惯，包括使用八进制数来表示权限。当新建一个文件或目录，它的所有者即客户进程的用户，它的所属组是父目录的组（BSD的规定）。 

​		每个访问HDFS的用户进程的标识分为两个部分，分别是*用户名*和*组名列表*。每次用户进程访问一个文件或目录foo，HDFS都要对其进行权限检查， 

- ​		   如果用户即foo的所有者，则检查所有者的访问权限； 	
- ​		   如果foo关联的组在组名列表中出现，则检查组用户的访问权限； 	
- ​		   否则检查foo其他用户的访问权限。 	

​		如果权限检查失败，则客户的操作会失败。



## 用户身份

在这个版本的Hadoop中，客户端用户身份是通过宿主操作系统给出。对类Unix系统来说，

-    用户名等于`whoami`；
-    组列表等于`bash -c groups`。

将来会增加其他的方式来确定用户身份（比如Kerberos、LDAP等）。期待用上文中提到的第一种方式来防止一个用户假冒另一个用户是不现实的。这种用户身份识别机制结合权限模型允许一个协作团体以一种有组织的形式共享文件系统中的资源。

不管怎样，用户身份机制对HDFS本身来说只是外部特性。HDFS并不提供创建用户身份、创建组或处理用户凭证等功能。



## 理解系统的实现

​	每次文件或目录操作都传递完整的路径名给name node，每一个操作都会对此路径做权限检查。客户框架会隐式地将用户身份和与name  node的连接关联起来，从而减少改变现有客户端API的需求。经常会有这种情况，当对一个文件的某一操作成功后，之后同样的操作却会失败，这是因为文件或路径上的某些目录已经不复存在了。比如，客户端首先开始读一个文件，它向name  node发出一个请求以获取文件第一个数据块的位置。但接下去的获取其他数据块的第二个请求可能会失败。另一方面，删除一个文件并不会撤销客户端已经获得的对文件数据块的访问权限。而权限管理能使得客户端对一个文件的访问许可在两次请求之间被收回。重复一下，权限的改变并不会撤销当前客户端对文件数据块的访问许可。

map-reduce框架通过传递字符串来指派用户身份，没有做其他特别的安全方面的考虑。文件或目录的所有者和组属性是以字符串的形式保存，而不是像传统的Unix方式转换为用户和组的数字ID。

这个发行版本的权限管理特性并不需要改变data node的任何行为。Data node上的数据块上并没有任何*Hadoop*所有者或权限等关联属性。



## 文件系统API变更

​	如果权限检查失败，所有使用一个路径参数的方法都可能抛出AccessControlException异常。

新增方法：

- ​		 public FSDataOutputStream create(Path f,  FsPermission permission, boolean overwrite, int bufferSize, short  replication, long blockSize, Progressable progress) throws IOException； 
- ​		 public boolean mkdirs(Path f, FsPermission permission) throws IOException； 
- ​		 public void setPermission(Path p, FsPermission permission) throws IOException； 
- ​		 public void setOwner(Path p, String username, String groupname) throws IOException； 
- ​		 public FileStatus getFileStatus(Path f) throws IOException； 也会返回路径关联的所有者、组和模式属性。 

新建文件或目录的模式受配置参数umask的约束。当使用之前的 create(path, …) 方法（*没有指定*权限参数）时，新文件的模式是666 & ^umask。当使用新的 create(path, *permission*, …) 方法（*指定了*权限参数*P*）时，新文件的模式是P & ^umask & 666。当使用先前的 mkdirs(path) 方法（*没有指定* 权限参数）新建一个目录时，新目录的模式是777 & ^umask。当使用新的 mkdirs(path, *permission* ) 方法（*指定了*权限参数*P*）新建一个目录时，新目录的模式是P & ^umask & 777。



## Shell命令变更

新增操作：

- chmod [-R] *mode file …*

  ​		只有文件的所有者或者超级用户才有权限改变文件模式。 

- chgrp [-R] *group file …*

  ​		使用chgrp命令的用户必须属于特定的组且是文件的所有者，或者用户是超级用户。 

- chown [-R] *[owner][:[group]] file …*

  ​		文件的所有者的只能被超级用户更改。 

- ls  *file …*

  

- lsr  *file …*

  ​		输出格式做了调整以显示所有者、组和模式。 



## 超级用户

超级用户即运行name node进程的用户。宽泛的讲，如果你启动了name node，你就是超级用户。超级用户干任何事情，因为超级用户能够通过所有的权限检查。没有永久记号保留谁*过去*是超级用户；当name node开始运行时，进程自动判断谁*现在*是超级用户。HDFS的超级用户不一定非得是name node主机上的超级用户，也不需要所有的集群的超级用户都是一个。同样的，在个人工作站上运行HDFS的实验者，不需任何配置就已方便的成为了他的部署实例的超级用户。 

​	另外，管理员可以用配置参数指定一组特定的用户，如果做了设定，这个组的成员也会是超级用户。



## Web服务器

Web服务器的身份是一个可配置参数。Name node并没有*真实*用户的概念，但是Web服务器表现地就像它具有管理员选定的用户的身份（用户名和组）一样。除非这个选定的身份是超级用户，否则会有名字空间中的一部分对Web服务器来说不可见。



## 在线升级

如果集群在0.15版本的数据集（fsimage）上启动，所有的文件和目录都有所有者*O*，组*G*，和模式*M*，这里 *O* 和 *G* 分别是超级用户的用户标识和组名，*M*是一个配置参数。



## 配置参数

- dfs.permissions = true 

  ​		如果是 true，则打开前文所述的权限系统。如果是 false，权限*检查* 就是关闭的，但是其他的行为没有改变。这个配置参数的改变并不改变文件或目录的模式、所有者和组等信息。 	 	 		不管权限模式是开还是关，chmod，chgrp 和 chown *总是* 会检查权限。这些命令只有在权限检查背景下才有用，所以不会有兼容性问题。这样，这就能让管理员在打开常规的权限检查之前可以可靠地设置文件的所有者和权限。 

- dfs.web.ugi = webuser,webgroup

  ​	Web服务器使用的用户名。如果将这个参数设置为超级用户的名称，则所有Web客户就可以看到所有的信息。如果将这个参数设置为一个不使用的用户，则Web客户就只能访问到“other”权限可访问的资源了。额外的组可以加在后面，形成一个用逗号分隔的列表。 

- dfs.permissions.supergroup = supergroup

  ​	超级用户的组名。 

- dfs.upgrade.permission = 777

  ​	升级时的初始模式。文件*永不会*被设置*x*权限。在配置文件中，可以使用十进制数*51110*。 

- dfs.umask = 022

  ​		 umask参数在创建文件和目录时使用。在配置文件中，可以使用十进制数*1810*。 

#       名字空间配额管理指南    

​      Hadoop分布式文件系统(HDFS)允许管理员为每个目录设置配额。      新建立的目录没有配额。      最大的配额是Long.Max_Value。配额为1可以强制目录保持为空。      

​      目录配额是对目录树上该目录下的名字数量做硬性限制。如果创建文件或目录时超过了配额，该操作会失败。重命名不会改变该目录的配额；如果重命名操作会导致违反配额限制，该操作将会失败。如果尝试设置一个配额而现有文件数量已经超出了这个新配额，则设置失败。      

​      配额和fsimage保持一致。当启动时，如果fsimage违反了某个配额限制（也许fsimage被偷偷改变了），则启动失败并生成错误报告。设置或删除一个配额会创建相应的日志记录。      

​      下面的新命令或新选项是用于支持配额的。      前两个是管理员命令。      

- ​       dfsadmin -setquota <N> <directory>...<directory>        
  ​       把每个目录配额设为N。这个命令会在每个目录上尝试，      如果N不是一个正的长整型数，目录不存在或是文件名，      或者目录超过配额，则会产生错误报告。      
- ​       dfsadmin -clrquota <directory>...<director> 
  ​       为每个目录删除配额。这个命令会在每个目录上尝试，如果目录不存在或者是文件，则会产生错误报告。如果目录原来没有设置配额不会报错。      
- ​       fs -count -q <directory>...<directory> 
  ​      使用-q选项，会报告每个目录设置的配额，以及剩余配额。      如果目录没有设置配额，会报告none和inf。      

# 命令手册

- 概述
  - [常规选项](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#常规选项)
-  用户命令 
  - [ archive ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#archive)
  - [ distcp ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#distcp)
  - [ fs ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#fs)
  - [ fsck ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#fsck)
  - [ jar ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#jar)
  - [ job ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)
  - [ pipes ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#pipes)
  - [ version ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#version)
  - [ CLASSNAME ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#CLASSNAME)
- 管理命令
  - [ balancer ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#balancer)
  - [ daemonlog ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#daemonlog)
  - [ datanode](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#datanode)
  - [ dfsadmin ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#dfsadmin)
  - [ jobtracker ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#jobtracker)
  - [ namenode ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#namenode)
  - [ secondarynamenode ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#secondarynamenode)
  - [ tasktracker ](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#tasktracker)



## 概述

​				所有的hadoop命令均由bin/hadoop脚本引发。不指定参数运行hadoop脚本会打印所有命令的描述。 		

​				 用法：hadoop [--config confdir] [COMMAND] [GENERIC_OPTIONS] [COMMAND_OPTIONS] 		

​				Hadoop有一个选项解析框架用于解析一般的选项和运行类。 		

| 命令选项            | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| --config confdir    | 覆盖缺省配置目录。缺省是${HADOOP_HOME}/conf。                |
| GENERIC_OPTIONS     | 多个命令都支持的通用选项。                                   |
| COMMAND   命令选项S | 各种各样的命令和它们的选项会在下面提到。这些命令被分为 		             [用户命令](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#用户命令)  		             [管理命令](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#管理命令)两组。 |



### 常规选项

​				  下面的选项被 			  [dfsadmin](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#dfsadmin),  			  [fs](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#fs), [fsck](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#fsck)和  			  [job](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)支持。  			  应用程序要实现 			  [Tool](https://hadoop.apache.org/core/docs/r0.18.2/api/org/apache/hadoop/util/Tool.html)来支持 			  [ 				  常规选项](https://hadoop.apache.org/core/docs/r0.18.2/api/org/apache/hadoop/util/GenericOptionsParser.html)。 			

| GENERIC_OPTION                    | 描述                                                         |
| --------------------------------- | ------------------------------------------------------------ |
| -conf <configuration file>        | 指定应用程序的配置文件。                                     |
| -D <property=value>               | 为指定property指定值value。                                  |
| -fs <local\|namenode:port>        | 指定namenode。                                               |
| -jt <local\|jobtracker:port>      | 指定job tracker。只适用于[job](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)。 |
| -files <逗号分隔的文件列表>       | 指定要拷贝到map reduce集群的文件的逗号分隔的列表。 		            只适用于[job](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)。 |
| -libjars <逗号分隔的jar列表>      | 指定要包含到classpath中的jar文件的逗号分隔的列表。 		            只适用于[job](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)。 |
| -archives <逗号分隔的archive列表> | 指定要被解压到计算节点上的档案文件的逗号分割的列表。 		            只适用于[job](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#job)。 |



##  用户命令 

hadoop集群用户的常用命令。



###  archive 

​					创建一个hadoop档案文件。参考 [Hadoop Archives](http://hadoop.apache.org/docs/r1.0.4/cn/hadoop_archives.html). 			

​					 用法：hadoop archive -archiveName NAME <src>* <dest> 			

| 命令选项          | 描述                                       |
| ----------------- | ------------------------------------------ |
| -archiveName NAME | 要创建的档案的名字。                       |
| src               | 文件系统的路径名，和通常含正则表达的一样。 |
| dest              | 保存档案文件的目标目录。                   |



###  distcp 

​					递归地拷贝文件或目录。参考[DistCp指南](http://hadoop.apache.org/docs/r1.0.4/cn/distcp.html)以获取等多信息。 			

​					 用法：hadoop distcp <srcurl> <desturl> 			

| 命令选项 | 描述    |
| -------- | ------- |
| srcurl   | 源Url   |
| desturl  | 目标Url |



###  fs 

​					 用法：hadoop fs [[GENERIC_OPTIONS](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#常规选项)]  				[COMMAND_OPTIONS] 			

​					运行一个常规的文件系统客户端。 			

​					各种命令选项可以参考[HDFS Shell指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html)。 			



###  fsck 

​					运行HDFS文件系统检查工具。参考[Fsck](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#fsck)了解更多。 			

用法：hadoop fsck [[GENERIC_OPTIONS](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#常规选项)]  			<path> [-move | -delete | -openforwrite] [-files [-blocks  			[-locations | -racks]]]

| 命令选项      | 描述                            |
| ------------- | ------------------------------- |
| <path>        | 检查的起始目录。                |
| -move         | 移动受损文件到/lost+found       |
| -delete       | 删除受损文件。                  |
| -openforwrite | 打印出写打开的文件。            |
| -files        | 打印出正被检查的文件。          |
| -blocks       | 打印出块信息报告。              |
| -locations    | 打印出每个块的位置信息。        |
| -racks        | 打印出data-node的网络拓扑结构。 |



###  jar 

​					运行jar文件。用户可以把他们的Map Reduce代码捆绑到jar文件中，使用这个命令执行。 			

​					 用法：hadoop jar <jar> [mainClass] args... 			

​					streaming作业是通过这个命令执行的。参考[Streaming examples](http://hadoop.apache.org/docs/r1.0.4/cn/streaming.html#其他例子)中的例子。 			

​					Word count例子也是通过jar命令运行的。参考[Wordcount example](http://hadoop.apache.org/docs/r1.0.4/cn/mapred_tutorial.html#用法)。 			



###  job 

​					用于和Map Reduce作业交互和命令。 			

​					 用法：hadoop job [[GENERIC_OPTIONS](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#常规选项)]  				[-submit <job-file>] | [-status <job-id>] |  				[-counter <job-id> <group-name> <counter-name>] | [-kill <job-id>] |  				[-events <job-id> <from-event-#> <#-of-events>] | [-history [all] <jobOutputDir>] | 				[-list [all]] | [-kill-task <task-id>] | [-fail-task <task-id>] 			

| 命令选项                                      | 描述                                                         |
| --------------------------------------------- | ------------------------------------------------------------ |
| -submit <job-file>                            | 提交作业                                                     |
| -status <job-id>                              | 打印map和reduce完成百分比和所有计数器。                      |
| -counter <job-id> <group-name> <counter-name> | 打印计数器的值。                                             |
| -kill <job-id>                                | 杀死指定作业。                                               |
| -events <job-id> <from-event-#> <#-of-events> | 打印给定范围内jobtracker接收到的事件细节。                   |
| -history [all] <jobOutputDir>                 | -history <jobOutputDir> 打印作业的细节、失败及被杀死原因的细节。更多的关于一个作业的细节比如成功的任务，做过的任务尝试等信息可以通过指定[all]选项查看。 |
| -list [all]                                   | -list all显示所有作业。-list只显示将要完成的作业。           |
| -kill-task <task-id>                          | 杀死任务。被杀死的任务不会不利于失败尝试。                   |
| -fail-task <task-id>                          | 使任务失败。被失败的任务会对失败尝试不利。                   |



###  pipes 

​					运行pipes作业。 			

​					 用法：hadoop pipes [-conf <path>] [-jobconf <key=value>, <key=value>, ...]  				[-input <path>] [-output <path>] [-jar <jar file>] [-inputformat <class>]  				[-map <class>] [-partitioner <class>] [-reduce <class>] [-writer <class>]  				[-program <executable>] [-reduces <num>]  			

| 命令选项                               | 描述                  |
| -------------------------------------- | --------------------- |
| -conf <path>                           | 作业的配置            |
| -jobconf <key=value>, <key=value>, ... | 增加/覆盖作业的配置项 |
| -input <path>                          | 输入目录              |
| -output <path>                         | 输出目录              |
| -jar <jar file>                        | Jar文件名             |
| -inputformat <class>                   | InputFormat类         |
| -map <class>                           | Java Map类            |
| -partitioner <class>                   | Java Partitioner      |
| -reduce <class>                        | Java Reduce类         |
| -writer <class>                        | Java RecordWriter     |
| -program <executable>                  | 可执行程序的URI       |
| -reduces <num>                         | reduce个数            |



###  version 

​					打印版本信息。 			

​					 用法：hadoop version 			



###  CLASSNAME 

​					 hadoop脚本可用于调调用任何类。 			

​					 用法：hadoop CLASSNAME 			

​					 运行名字为CLASSNAME的类。 			



## 管理命令

hadoop集群管理员常用的命令。



###  balancer 

​					运行集群平衡工具。管理员可以简单的按Ctrl-C来停止平衡过程。参考[Rebalancer](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#Rebalancer)了解更多。 			

​					 用法：hadoop balancer [-threshold <threshold>] 			

| 命令选项               | 描述                                   |
| ---------------------- | -------------------------------------- |
| -threshold <threshold> | 磁盘容量的百分比。这会覆盖缺省的阀值。 |



###  daemonlog 

​					 获取或设置每个守护进程的日志级别。 			

​					 用法：hadoop daemonlog  -getlevel <host:port> <name> 
 				 用法：hadoop daemonlog  -setlevel <host:port> <name> <level> 			

| 命令选项                             | 描述                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| -getlevel <host:port> <name>         | 打印运行在<host:port>的守护进程的日志级别。这个命令内部会连接http://<host:port>/logLevel?log=<name> |
| -setlevel <host:port> <name> <level> | 设置运行在<host:port>的守护进程的日志级别。这个命令内部会连接http://<host:port>/logLevel?log=<name> |



###  datanode

​					运行一个HDFS的datanode。 			

​					 用法：hadoop datanode [-rollback] 			

| 命令选项  | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| -rollback | 将datanode回滚到前一个版本。这需要在停止datanode，分发老的hadoop版本之后使用。 |



###  dfsadmin 

​					运行一个HDFS的dfsadmin客户端。 			

​					 用法：hadoop dfsadmin  [[GENERIC_OPTIONS](http://hadoop.apache.org/docs/r1.0.4/cn/commands_manual.html#常规选项)] [-report] [-safemode enter | leave | get | wait] [-refreshNodes] 				 [-finalizeUpgrade] [-upgradeProgress status | details | force] [-metasave filename]  				 [-setQuota <quota> <dirname>...<dirname>] [-clrQuota <dirname>...<dirname>]  				 [-help [cmd]] 			

| 命令选项                                    | 描述                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| -report                                     | 报告文件系统的基本信息和统计信息。                           |
| -safemode enter \| leave \| get \| wait     | 安全模式维护命令。安全模式是Namenode的一个状态，这种状态下，Namenode   				1.  不接受对名字空间的更改(只读)   				2.  不复制或删除块  				Namenode会在启动时自动进入安全模式，当配置的块最小百分比数满足最小的副本数条件时，会自动离开安全模式。安全模式可以手动进入，但是这样的话也必须手动关闭安全模式。 |
| -refreshNodes                               | 重新读取hosts和exclude文件，更新允许连到Namenode的或那些需要退出或入编的Datanode的集合。 |
| -finalizeUpgrade                            | 终结HDFS的升级操作。Datanode删除前一个版本的工作目录，之后Namenode也这样做。这个操作完结整个升级过程。 |
| -upgradeProgress status \| details \| force | 请求当前系统的升级状态，状态的细节，或者强制升级操作进行。   |
| -metasave filename                          | 保存Namenode的主要数据结构到hadoop.log.dir属性指定的目录下的<filename>文件。对于下面的每一项，<filename>中都会一行内容与之对应                         1. Namenode收到的Datanode的心跳信号                         2. 等待被复制的块                         3. 正在被复制的块                         4. 等待被删除的块 |
| -setQuota <quota> <dirname>...<dirname>     | 为每个目录 <dirname>设定配额<quota>。目录配额是一个长整型整数，强制限定了目录树下的名字个数。                 命令会在这个目录上工作良好，以下情况会报错：                 1. N不是一个正整数，或者                 2. 用户不是管理员，或者                 3. 这个目录不存在或是文件，或者                 4. 目录会马上超出新设定的配额。 |
| -clrQuota <dirname>...<dirname>             | 为每一个目录<dirname>清除配额设定。                 命令会在这个目录上工作良好，以下情况会报错：                 1. 这个目录不存在或是文件，或者                 2. 用户不是管理员。                 如果目录原来没有配额不会报错。 |
| -help [cmd]                                 | 显示给定命令的帮助信息，如果没有给定命令，则显示所有命令的帮助信息。 |



###  jobtracker 

​					运行MapReduce job Tracker节点。 			

​					 用法：hadoop jobtracker 			



###  namenode 

​					运行namenode。有关升级，回滚，升级终结的更多信息请参考[升级和回滚](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#升级和回滚)。 			

​					 用法：hadoop namenode [-format] | [-upgrade] | [-rollback] | [-finalize] | [-importCheckpoint] 			

| 命令选项          | 描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| -format           | 格式化namenode。它启动namenode，格式化namenode，之后关闭namenode。 |
| -upgrade          | 分发新版本的hadoop后，namenode应以upgrade选项启动。          |
| -rollback         | 将namenode回滚到前一版本。这个选项要在停止集群，分发老的hadoop版本后使用。 |
| -finalize         | finalize会删除文件系统的前一状态。最近的升级会被持久化，rollback选项将再不可用，升级终结操作之后，它会停掉namenode。 |
| -importCheckpoint | 从检查点目录装载镜像并保存到当前检查点目录，检查点目录由fs.checkpoint.dir指定。 |



###  secondarynamenode 

​					运行HDFS的secondary namenode。参考[Secondary Namenode](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_user_guide.html#Secondary+NameNode)了解更多。  			

​					 用法：hadoop secondarynamenode [-checkpoint [force]] | [-geteditsize] 			

| 命令选项            | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| -checkpoint [force] | 如果EditLog的大小 >= fs.checkpoint.size，启动Secondary namenode的检查点过程。 		            如果使用了-force，将不考虑EditLog的大小。 |
| -geteditsize        | 打印EditLog大小。                                            |



###  tasktracker 

​					运行MapReduce的task Tracker节点。 			

​					 用法：hadoop tasktracker 			





# Hadoop Shell命令

-  FS Shell 
  - [ cat ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#cat)
  - [ chgrp ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#chgrp)
  - [ chmod ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#chmod)
  - [ chown ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#chown)
  - [copyFromLocal](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#copyFromLocal)
  - [ copyToLocal](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#copyToLocal)
  - [ cp ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#cp)
  - [du](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#du)
  - [ dus ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#dus)
  - [ expunge ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#expunge)
  - [ get ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#get)
  - [ getmerge ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#getmerge)
  - [ ls ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#ls)
  - [lsr](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#lsr)
  - [ mkdir ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#mkdir)
  - [ movefromLocal ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#movefromLocal)
  - [ mv ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#mv)
  - [ put ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#put)
  - [ rm ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#rm)
  - [ rmr ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#rmr)
  - [ setrep ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#setrep)
  - [ stat ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#stat)
  - [ tail ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#tail)
  - [ test ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#test)
  - [ text ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#text)
  - [ touchz ](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#touchz)



##  FS Shell 

​      调用文件系统(FS)Shell命令应使用      bin/hadoop fs <args>的形式。      所有的的FS shell命令使用URI路径作为参数。URI格式是*scheme://authority/path*。对HDFS文件系统，scheme是*hdfs*，对本地文件系统，scheme是*file*。其中scheme和authority参数都是可选的，如果未加指定，就会使用配置中指定的默认scheme。一个HDFS文件或目录比如*/parent/child*可以表示成*hdfs://namenode:namenodeport/parent/child*，或者更简单的*/parent/child*（假设你配置文件中的默认值是*namenode:namenodeport*）。大多数FS Shell命令的行为和对应的Unix Shell命令类似，不同之处会在下面介绍各命令使用详情时指出。出错信息会输出到*stderr*，其他信息输出到*stdout*。  



###  cat 

​				 使用方法：hadoop fs -cat URI [URI …] 		

​		   将路径指定文件的内容输出到*stdout*。 	   

示例：

- ​					 hadoop fs -cat hdfs://host1:port1/file1 hdfs://host2:port2/file2  	    			
- ​					 hadoop fs -cat file:///file3 /user/hadoop/file4  			

返回值：
 		    成功返回0，失败返回-1。



###  chgrp 

​				 使用方法：hadoop fs -chgrp [-R] GROUP URI [URI …]            Change group association of files. With -R, make the change recursively through the directory structure. The user  must be the owner of files, or else a super-user. Additional information is in the [Permissions User Guide](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html). --> 		

​	    改变文件所属的组。使用-R将使改变在目录结构下递归进行。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。     



###  chmod 

​				 使用方法：hadoop fs -chmod [-R] <MODE[,MODE]... | OCTALMODE> URI [URI …] 		

​	    改变文件的权限。使用-R将使改变在目录结构下递归进行。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。     



###  chown 

​				 使用方法：hadoop fs -chown [-R] [OWNER][:[GROUP]] URI [URI ] 		

​	    改变文件的拥有者。使用-R将使改变在目录结构下递归进行。命令的使用者必须是超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。     



### copyFromLocal

​				 使用方法：hadoop fs -copyFromLocal <localsrc> URI 		

除了限定源路径是一个本地文件外，和[**put**](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#putlink)命令相似。



###  copyToLocal

​				 使用方法：hadoop fs -copyToLocal [-ignorecrc] [-crc] URI <localdst> 		

除了限定目标路径是一个本地文件外，和[**get**](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#getlink)命令类似。



###  cp 

​				 使用方法：hadoop fs -cp URI [URI …] <dest> 		

​	    将文件从源路径复制到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。     
​     示例：

- ​					 hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2 			
- ​					 hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2 /user/hadoop/dir  			

返回值：

​				 成功返回0，失败返回-1。 		



### du

​				 使用方法：hadoop fs -du URI [URI …] 		

​	     显示目录中所有文件的大小，或者当只指定一个文件时，显示此文件的大小。
​      示例：
 hadoop fs -du /user/hadoop/dir1 /user/hadoop/file1 hdfs://host:port/user/hadoop/dir1 
​      返回值：
 成功返回0，失败返回-1。 



###  dus 

​				 使用方法：hadoop fs -dus <args> 		

​	   显示文件的大小。    



###  expunge 

​				 使用方法：hadoop fs -expunge 		

清空回收站。请参考[HDFS设计](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html)文档以获取更多关于回收站特性的信息。    



###  get 

​				 使用方法：hadoop fs -get [-ignorecrc] [-crc] <src> <localdst> 			 
 		

​	   复制文件到本地文件系统。可用-ignorecrc选项复制CRC校验失败的文件。使用-crc选项复制文件以及CRC信息。   		

示例：

- ​					 hadoop fs -get /user/hadoop/file localfile  			
- ​					 hadoop fs -get hdfs://host:port/user/hadoop/file localfile 			

返回值：

​				 成功返回0，失败返回-1。 		



###  getmerge 

​				 使用方法：hadoop fs -getmerge <src> <localdst> [addnl] 		

​	  接受一个源目录和一个目标文件作为输入，并且将源目录中所有的文件连接成本地目标文件。addnl是可选的，用于指定在每个文件结尾添加一个换行符。    



###  ls 

​				 使用方法：hadoop fs -ls <args> 		

如果是文件，则按照如下格式返回文件信息：
 文件名 <副本数> 文件大小 修改日期 修改时间 权限 用户ID 组ID 
          如果是目录，则返回它直接子文件的一个列表，就像在Unix中一样。目录返回列表的信息如下：
 目录名 <dir> 修改日期 修改时间 权限 用户ID 组ID 
          示例：
 hadoop fs -ls /user/hadoop/file1 /user/hadoop/file2 hdfs://host:port/user/hadoop/dir1 /nonexistentfile 
          返回值：
 成功返回0，失败返回-1。 



### lsr

使用方法：hadoop fs -lsr <args> 
        ls命令的递归版本。类似于Unix中的ls -R。       



###  mkdir 

​				 使用方法：hadoop fs -mkdir <paths> 			 
 		

接受路径指定的uri作为参数，创建这些目录。其行为类似于Unix的mkdir -p，它会创建路径中的各级父目录。

示例：

- ​					 hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2  			
- ​					 hadoop fs -mkdir hdfs://host1:port1/user/hadoop/dir hdfs://host2:port2/user/hadoop/dir    			

返回值：

​				 成功返回0，失败返回-1。 		



###  movefromLocal 

​				 使用方法：dfs -moveFromLocal <src> <dst> 		

输出一个”not implemented“信息。    



###  mv 

​				 使用方法：hadoop fs -mv URI [URI …] <dest> 		

​	    将文件从源路径移动到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。不允许在不同的文件系统间移动文件。     
​     示例：     

- ​					 hadoop fs -mv /user/hadoop/file1 /user/hadoop/file2 			
- ​					 hadoop fs -mv hdfs://host:port/file1 hdfs://host:port/file2 hdfs://host:port/file3 hdfs://host:port/dir1 			

返回值：

​				 成功返回0，失败返回-1。 		



###  put 

​				 使用方法：hadoop fs -put <localsrc> ... <dst> 		

从本地文件系统中复制单个或多个源路径到目标文件系统。也支持从标准输入中读取输入写入目标文件系统。
    

- ​					 hadoop fs -put localfile /user/hadoop/hadoopfile 			
- ​					 hadoop fs -put localfile1 localfile2 /user/hadoop/hadoopdir 			
- ​					 hadoop fs -put localfile hdfs://host:port/hadoop/hadoopfile 			
- hadoop fs -put - hdfs://host:port/hadoop/hadoopfile 
  从标准输入中读取输入。

返回值：

​				 成功返回0，失败返回-1。 		



###  rm 

​				 使用方法：hadoop fs -rm URI [URI …]  		

​	   删除指定的文件。只删除非空目录和文件。请参考rmr命令了解递归删除。
​    示例：    

- ​					 hadoop fs -rm hdfs://host:port/file /user/hadoop/emptydir  			

返回值：

​				 成功返回0，失败返回-1。 		



###  rmr 

​				 使用方法：hadoop fs -rmr URI [URI …] 		

delete的递归版本。
    示例：    

- ​					 hadoop fs -rmr /user/hadoop/dir  			
- ​					 hadoop fs -rmr hdfs://host:port/user/hadoop/dir  			

返回值：

​				 成功返回0，失败返回-1。 		



###  setrep 

​				 使用方法：hadoop fs -setrep [-R] <path> 		

​	   改变一个文件的副本系数。-R选项用于递归改变目录下所有文件的副本系数。   

示例：

- ​					 hadoop fs -setrep -w 3 -R /user/hadoop/dir1  			

返回值：

​				 成功返回0，失败返回-1。 		



###  stat 

​				 使用方法：hadoop fs -stat URI [URI …] 		

​	   返回指定路径的统计信息。    

示例：

- ​					 hadoop fs -stat path  			

返回值：
     成功返回0，失败返回-1。



###  tail 

​				 使用方法：hadoop fs -tail [-f] URI  		

​	   将文件尾部1K字节的内容输出到stdout。支持-f选项，行为和Unix中一致。    

示例：

- ​					 hadoop fs -tail pathname  			

返回值：
     成功返回0，失败返回-1。



###  test 

​				 使用方法：hadoop fs -test -[ezd] URI 		

​	   选项：
​    -e 检查文件是否存在。如果存在则返回0。
​    -z 检查文件是否是0字节。如果是则返回0。 
​    -d 如果路径是个目录，则返回1，否则返回0。

示例：

- ​					 hadoop fs -test -e filename  			



###  text 

​				 使用方法：hadoop fs -text <src> 			 
 		

​	   将源文件输出为文本格式。允许的格式是zip和TextRecordInputStream。   



###  touchz 

​				 使用方法：hadoop fs -touchz URI [URI …] 			 
 		

​	   创建一个0字节的空文件。    

示例：

- ​					 hadoop -touchz pathname  			

返回值：
     成功返回0，失败返回-1。



