# neo4j

[TOC]

## 概述

## 安装

### CentOS

#### 二进制包

1. 安装jdk11

2. 上传neo4j安装包到服务器/opt目录下，并解压

   ```bash
   tar -zxvf neo4j-community-3.5.13-unix.tar.gz
   ```

3. 修改neo4j配置文件 `conf/neo4j.conf`，只需要修改使neo4j可以外网访问即可，其他按默认配置。

   ```ini
   dbms.connectors.default_listen_address=0.0.0.0
   ```

4. 进入neo4j安装程序bin目录，启动neo4j

   ```bash
   ./neo4j start
   ```

5. 到页面浏览 http://localhost:7474 如果出现页面表示neo4j安装成功，初始化账号密码为neo4j/neo4j

##### 设置neo4j开机启动

1. 进入 neo4j 安装目录，并创建脚本 start.sh 和 stop.sh，其中 JAVA_HOME 按照实际路径填写

   ```bash
   #!/bin/bash
   # start.sh
   
   export JAVA_HOME=/opt/jdk1.8.0_161
   export PATH=$JAVA_HOME/bin:$PATH
   
   sh /opt/neo4j-enterprise-3.5.3/bin/neo4j start
   ```

   ```bash
   #!/bin/bash
   # stop.sh
   
   export JAVA_HOME=/opt/jdk1.8.0_161
   export PATH=$JAVA_HOME/bin:$PATH
   
   sh /opt/neo4j-enterprise-3.5.3/bin/neo4j stop
   ```

2. 创建开机启动脚本 neo4j.service 。进入 /usr/lib/systemd/system 目录，创建 neo4j.service 文件。

   ```bash
   cd /usr/lib/systemd/system && vim neo4j.service
   ```

   ```bash
   [Unit]
   Description=neo4j
   After=network.target remote-fs.target nss-lookup.target
   
   [Service]
   Type=forking
   ExecStart=/opt/neo4j-enterprise-3.5.3/bin/start.sh
   ExecStop=/opt/neo4j-enterprise-3.5.3/bin/stop.sh
   PrivateTpm=true
   
   [Install]
   WantedBy=multi-user.target
   ```

3. 设置neo4j开机启动，重启服务器

   ```bash
   systemctl enable neo4j.service
   reboot
   ```



