# 安装

[TOC]

介绍如何在 Linux 操作系统上快速搭建 Hadoop 伪分布式环境。

## 前提条件

- 已在ECS实例安全组的入方向中放行了Hadoop所需的8088和50070端口。

## 步骤一：安装JDK

1. 远程连接已创建的ECS实例。

   具体操作，请参见[连接方式概述](https://help.aliyun.com/zh/ecs/user-guide/connection-methods#concept-tmr-pgx-wdb)。

2. 执行以下命令，下载JDK 1.8安装包。

   ​        

   ​                        

   ```shell
   wget https://download.java.net/openjdk/jdk8u41/ri/openjdk-8u41-b04-linux-x64-14_jan_2020.tar.gz
   ```

3. 执行以下命令，解压下载的JDK 1.8安装包。

   ​        

   ​                        

   ```shell
   tar -zxvf openjdk-8u41-b04-linux-x64-14_jan_2020.tar.gz
   ```

4. 执行以下命令，移动并重命名JDK安装包。

   本示例中将JDK安装包重命名为`java8`，您可以根据需要使用其他名称。

   ​        

   ​                        

   ```shell
   mv java-se-8u41-ri/ /usr/java8
   ```

5. 执行以下命令，配置Java环境变量。

   如果您将JDK安装包重命名为其他名称，需将以下命令中的`java8`替换为实际的名称。

   ​        

   ​                        

   ```shell
   echo 'export JAVA_HOME=/usr/java8' >> /etc/profile
   echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile
   source /etc/profile
   ```

6. 执行以下命令，查看Java是否成功安装。     

   ```shell
   java -version
   ```

   如果返回以下信息，则表示Java已安装成功。

## 步骤二：安装Hadoop

1. 执行以下命令，下载Hadoop安装包。

   ​        

   ​                        

   ```shell
   wget https://mirrors.bfsu.edu.cn/apache/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz
   ```

2. 执行以下命令，解压Hadoop安装包至/opt/hadoop。

   ​        

   ​                        

   ```shell
   tar -zxvf hadoop-2.10.1.tar.gz -C /opt/
   mv /opt/hadoop-2.10.1 /opt/hadoop
   ```

3. 执行以下命令，配置Hadoop环境变量。

   ​        

   ​                        

   ```shell
   echo 'export HADOOP_HOME=/opt/hadoop/' >> /etc/profile
   echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> /etc/profile
   echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> /etc/profile
   source /etc/profile    
   ```

4. 执行以下命令，修改配置文件yarn-env.sh和hadoop-env.sh。

   ​        

   ​                        

   ```shell
   echo "export JAVA_HOME=/usr/java8" >> /opt/hadoop/etc/hadoop/yarn-env.sh
   echo "export JAVA_HOME=/usr/java8" >> /opt/hadoop/etc/hadoop/hadoop-env.sh
   ```

5. 执行以下命令，测试Hadoop是否安装成功。

   ​        

   ​                        

   ```shell
   hadoop version
   ```

   如果返回以下信息，则表示安装成功。

   ​        

   ​                        

   ```shell
   Hadoop 2.10.1
   Subversion https://github.com/apache/hadoop -r 1827467c9a56f133025f28557bfc2c562d78e816
   Compiled by centos on 2020-09-14T13:17Z
   Compiled with protoc 2.5.0
   From source with checksum 3114edef868f1f3824e7d0f68be03650
   This command was run using /opt/hadoop/share/hadoop/common/hadoop-common-2.10.1.jar
   ```

## 步骤三：配置Hadoop

1. 修改Hadoop配置文件core-site.xml。

   1. 执行以下命令，进入编辑页面。

      ​        

      ​                        

      ```shell
      vim /opt/hadoop/etc/hadoop/core-site.xml
      ```

   2. 输入`i`，进入编辑模式。

   3. 在`<configuration></configuration>`节点内，插入如下内容。

      ​        

      ​                        

      ```shell
          <property>
              <name>hadoop.tmp.dir</name>
              <value>file:/opt/hadoop/tmp</value>
              <description>location to store temporary files</description>
          </property>
          <property>
              <name>fs.defaultFS</name>
              <value>hdfs://localhost:9000</value>
          </property>
      ```

   4. 按`Esc`，退出编辑模式，并输入`:wq`保存并退出。

2. 修改Hadoop配置文件hdfs-site.xml。

   1. 执行以下命令，进入编辑页面。

      ​        

      ​                        

      ```shell
      vim /opt/hadoop/etc/hadoop/hdfs-site.xml
      ```

   2. 输入`i`，进入编辑模式。

   3. 在`<configuration></configuration>`节点内，插入如下内容。

      ​        

      ​                        

      ```shell
          <property>
              <name>dfs.replication</name>
              <value>1</value>
          </property>
          <property>
              <name>dfs.namenode.name.dir</name>
              <value>file:/opt/hadoop/tmp/dfs/name</value>
          </property>
          <property>
              <name>dfs.datanode.data.dir</name>
              <value>file:/opt/hadoop/tmp/dfs/data</value>
          </property>
      ```

   4. 按`Esc`，退出编辑模式，并输入`:wq`后保存并退出。

## 步骤五：启动Hadoop

1. 执行以下命令，初始化`namenode `。

   ​        

   ​                        

   ```shell
   hadoop namenode -format
   ```

2. 依次执行以下命令，启动Hadoop。

   ​        

   ​                        

   ```shell
   start-dfs.sh
   ```

   在弹出的提示中，依次输入`yes`。![adada](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/4468389461/p429411.png)

   ​        

   ​                        

   ```shell
   start-yarn.sh
   ```

   回显信息如下所示。

   ​        

   ​                        

   ```shell
   [root@iZbp1chrrv37a2kts7s**** .ssh]# start-yarn.sh
   starting yarn daemons
   starting resourcemanager, logging to /opt/hadoop/logs/yarn-root-resourcemanager-iZbp1chrrv37a2kts7sydsZ.out
   localhost: starting nodemanager, logging to /opt/hadoop/logs/yarn-root-nodemanager-iZbp1chrrv37a2kts7sydsZ.out
   ```

3. 执行以下命令，可查看成功启动的进程。

   ​        

   ​                        

   ```shell
   jps
   ```

   成功启动的进程如下所示。

   ​        

   ​                        

   ```shell
   [root@iZbp1chrrv37a2kts7s**** .ssh]# jps
   11620 DataNode
   11493 NameNode
   11782 SecondaryNameNode
   11942 ResourceManager
   12344 Jps
   12047 NodeManager
   ```

4. 打开浏览器访问`http://<ECS公网IP>:8088`和`http://<ECS公网IP>:50070`。

   显示如下界面，则表示Hadoop伪分布式环境已搭建完成。

   **重要** 

   需确保在ECS实例所在安全组的入方向中放行Hadoop所需的8088和50070端口，否则无法访问。

   ![application](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/8368611361/p111710.png)