# OpenDaylight

[TOC]

## 概述

最常见的控制器，简称ODL。

## 安装

1. 安装 java 。

   ```bash
   apt install openjdk-8-jdk
   ```

2. 配置环境。

   编辑 `/etc/environment` ，在第二行加入java的环境变量。

   ```bash
   JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
   ```

3. 下载 ODL 编译好的文件。

   ```bash
   wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.6.4-Carbon/distribution-karaf-0.6.4-Carbon.tar.gz
   ```

4. 解压文件。

   ```bash
   tar zvxf distribution-karaf-0.6.4-Carbon.tar.gz
   ```

5. 配置文件。

   ```bash
   /etc/org.apache.karaf.management.cfg
   ```

    ![img](https://img2018.cnblogs.com/blog/1060878/201910/1060878-20191022162621345-1981638863.png)

6. 开启 ODL 控制器。

    ![img](https://img2018.cnblogs.com/blog/1060878/201910/1060878-20191022160106839-1267256542.png)

7. 安装必要的插件。

   全新的ODL只有核心插件，还需要web 页面，openflow支持等插件。 

   ```bash
   opendaylight-user@root>feature:install odl-restconf
   opendaylight-user@root>feature:install odl-l2switch-switch-ui
   opendaylight-user@root>feature:install odl-openflowplugin-flow-services-ui
   opendaylight-user@root>feature:install odl-mdsal-apidocs
   opendaylight-user@root>feature:install odl-dluxapps-applications
   opendaylight-user@root>feature:install odl-faas-all
   ```

8. 查看端口验证 ODL 是否启动成功。

   当 ODL 启动成功之后会监听在 6633 端口，监听交换机的连接。如果 6633 端口有监听，那就说明 ODL 启动是正常的。