# Client

[TOC]

## 概述

客户机需要一些基本配置来与 Ceph 集群交互。

> **Note：**
>
> 大多数客户端计算机只需要安装 `ceph-common`  软件包及其依赖项。它将提供基本的 `ceph` 和 `rados` 命令，以及 `mount.ceph` 和 `rbd` 等其他命令。

## 配置文件设置

客户机通常需要比完整的集群成员更小的配置文件。要生成最小配置文件，需登录到已配置为客户端或正在运行群集守护程序的主机，然后运行以下命令：

```bash
ceph config generate-minimal-conf

# minimal ceph.conf for 417b1d7a-a0e6-11eb-b940-001a4a000740
[global]
	fsid = 417b1d7a-a0e6-11eb-b940-001a4a000740
	mon_host = [v2:10.74.249.41:3300/0,v1:10.74.249.41:6789/0]
```

该命令生成一个最小的配置文件，告诉客户端如何访问 Ceph MON 。该文件的内容通常应安装在 `/etc/ceph/ceph.conf` 中。


## 设置密钥环

大多数 Ceph 集群在启用身份验证的情况下运行。客户端需要密钥才能与集群计算机通信。为客户端生成带有凭据的密钥环文件 `client.fs` ，登录到正在运行的集群成员并运行以下命令：

```bash
ceph auth get-or-create client.CLIENT_NAME

ceph auth get-or-create client.fs
```

生成的输出被定向到 keyring 文件中，通常是 `/etc/ceph/ceph.keyring` 。

```bash
cat ceph.keyring

[client.fs]
	key = AQAvoH5gkUCsExAATz3xCBLd4n6B6jRv+Z7CVQ==
```
