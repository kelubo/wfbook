# Client

[TOC]

​			作为存储管理员，您必须设置具有基本配置的客户端计算机，以便与存储集群交互。大多数客户端计算机只需要安装 `ceph-common 软件包` 及其依赖项。它将提供基本的 `ceph` 和 `rados` 命令，以及 `mount.ceph` 和 `rbd` 等其他命令。 	

## 9.1. 在客户端机器上配置文件设置

​				客户端计算机通常需要比具备完整存储群集成员的配置文件小。您可以生成一个最小的配置文件，向客户端提供详细信息，以访问 Ceph 监视器。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						对节点的 root 访问权限. 				

**流程**

1. ​						在您要设置文件的节点上，在 `/etc` 文件夹中创建 `ceph` 目录： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# mkdir /etc/ceph/
   ```

2. ​						进入 `/etc/ceph` 目录： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cd /etc/ceph/
   ```

3. ​						在 `ceph` 目录中生成配置文件： 				

   **示例**

   ​							

   ```none
   [root@host01 ceph]# ceph config generate-minimal-conf
   
   # minimal ceph.conf for 417b1d7a-a0e6-11eb-b940-001a4a000740
   [global]
   	fsid = 417b1d7a-a0e6-11eb-b940-001a4a000740
   	mon_host = [v2:10.74.249.41:3300/0,v1:10.74.249.41:6789/0]
   ```

   ​						此文件的内容应当安装在 `/etc/ceph/ceph.conf` 路径中。您可以使用此配置文件来访问 Ceph 监视器。 				

# 设置密钥环

​				大多数 Ceph 集群在启用身份验证的情况下运行，客户端需要密钥才能与集群计算机通信。您可以生成密钥环，向客户端提供详细信息，以访问 Ceph 监视器。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						对节点的 root 访问权限. 				

**流程**

1. ​						在您要设置密钥环的节点上，在 `/etc` 文件夹中创建 `ceph` 目录： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# mkdir /etc/ceph/
   ```

2. ​						进入 `ceph` 目录中的 `/etc/ceph` 目录： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cd /etc/ceph/
   ```

3. ​						为客户端生成密钥环： 				

   **语法**

   ​							

   ```none
   ceph auth get-or-create client.CLIENT_NAME -o /etc/ceph/NAME_OF_THE_FILE
   ```

   **示例**

   ​							

   ```none
   [root@host01 ceph]# ceph auth get-or-create client.fs -o /etc/ceph/ceph.keyring
   ```

4. ​						验证 `ceph.keyring` 文件中的输出： 				

   **示例**

   ​							

   ```none
   [root@host01 ceph]# cat ceph.keyring
   
   [client.fs]
   	key = AQAvoH5gkUCsExAATz3xCBLd4n6B6jRv+Z7CVQ==
   ```

   ​						生成的输出应当放入密钥环文件中，如 `/etc/ceph/ceph.keyring`。 				

Client 主机需要一些基本的配置信息与集群进行交互：

*  Ceph 配置文件或集群名称（通常是ceph）和 MON 地址。
* Pool 名称。
* 用户名和密钥的路径。

Most client machines only need the ceph-common package and its dependencies installed. That will supply the basic ceph and rados commands, as well as other commands like mount.ceph and rbd.

## 配置文件设置
Client machines can generally get away with a smaller config file than a full-fledged cluster member. To generate a minimal config file, log into a host that is already configured as a client or running a cluster daemon, and then run

```bash
ceph config generate-minimal-conf
```

This will generate a minimal config file that will tell the client how to reach the Ceph Monitors. The contents of this file should typically be installed in /etc/ceph/ceph.conf.

## Keyring 设置

Most Ceph clusters are run with authentication enabled, and the client will need keys in order to communicate with cluster machines. To generate a keyring file with credentials for client.fs, log into an extant cluster member and run

```bash
ceph auth get-or-create client.fs
```

The resulting output should be put into a keyring file, typically /etc/ceph/ceph.keyring.