# Client

[TOC]

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