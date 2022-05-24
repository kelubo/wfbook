# Client

[TOC]

## 概述

大多数客户端计算机只需要安装 `ceph-common 软件包` 及其依赖项。它将提供基本的 `ceph` 和 `rados` 命令，以及 `mount.ceph` 和 `rbd` 等其他命令。

## 配置文件设置

Client 主机需要一些基本的配置信息与集群进行交互：

*  Ceph 配置文件或集群名称（通常是ceph）和 MON 地址。
*  Pool 名称。
*  用户名和密钥的路径。

## 客户端上的配置文件设置

客户端计算机通常需要一个比具备完整存储群集成员小的配置文件。

Client machines can generally get away with a smaller config file than a full-fledged cluster member.

可以生成一个最小的配置文件，向客户端提供详细信息，以访问 Ceph 监视器。

1. 在集群管理节点上执行命令，生成最小化的配置文件。

   ```bash
   ceph config generate-minimal-conf
   
   # minimal ceph.conf for 417b1d7a-a0e6-11eb-b940-001a4a000740
   [global]
   	fsid = 417b1d7a-a0e6-11eb-b940-001a4a000740
   	mon_host = [v2:10.74.249.41:3300/0,v1:10.74.249.41:6789/0]	
   ```

2. 在客户端节点上，创建 `ceph` 目录：

   ```bash
   mkdir /etc/ceph/
   ```

3. 进入 `/etc/ceph` 目录：							

   ```bash
   cd /etc/ceph/
   ```

4. 将生成的配置文件`/etc/ceph/ceph.conf` 复制到客户端   `/etc/ceph` 目录。


## 设置密钥环

大多数 Ceph 集群在启用身份验证的情况下运行，客户端需要密钥才能与集群计算机通信。可以生成密钥环，向客户端提供详细信息，以访问 Ceph 监视器。

1. 登录管理节点，为客户端生成密钥环：

   ```bash
   ceph auth get-or-create client.CLIENT_NAME -o /etc/ceph/NAME_OF_THE_FILE
   
   ceph auth get-or-create client.fs -o /etc/ceph/ceph.keyring
   ```

2. 验证 `ceph.keyring` 文件中的输出：

   ```bash
   cat ceph.keyring
   
   [client.fs]
   	key = AQAvoH5gkUCsExAATz3xCBLd4n6B6jRv+Z7CVQ==
   ```

   生成的输出应当放入密钥环文件中，如 `/etc/ceph/ceph.keyring`。
