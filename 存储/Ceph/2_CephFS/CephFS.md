# CephFS

[TOC]

## 准备工作

1. 确认你使用了合适的内核版本。

   ```bash
   lsb_release -a
   uname -r
   ```

2. 在管理节点上，通过 `ceph-deploy` 把 Ceph 安装到 `ceph-client` 节点上。

   ```bash
   ceph-deploy install ceph-client
   ```

3. 确保 Ceph 存储集群在运行，且处于 `active + clean` 状态。同时，确保至少有一个 MON 在运行。

   ```bash
   ceph -s [-m {monitor-ip-address}] [-k {path/to/ceph.client.admin.keyring}]
   ```

## 创建存储池和文件系统

```bash
ceph osd pool create cephfs_data <pg_num>
ceph osd pool create cephfs_metadata <pg_num>
ceph fs new <fs_name> cephfs_metadata cephfs_data
```

## 创建密钥文件

Ceph 存储集群默认启用认证，应该有个包含密钥的配置文件（但不是密钥环本身）。用下述方法获取某一用户的密钥：

1. 在密钥环文件中找到与某用户对应的密钥，例如：

   ```bash
   cat ceph.client.admin.keyring
   ```

2. 找到用于挂载 Ceph 文件系统的用户，复制其密钥。大概看起来如下所示：

   ```bash
   [client.admin]
      key = AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
   ```

3. 打开文本编辑器，把密钥粘帖进去：

   ```bash
   AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
   ```

5. 保存文件，并把其用户名 `name` 作为一个属性（如 `admin.secret` ）。

6. 确保此文件对用户有合适的权限，但对其他用户不可见。

## 内核驱动

把 Ceph FS 挂载为内核驱动。

```bash
sudo mkdir /mnt/mycephfs
sudo mount -t ceph {ip-address-of-monitor}:6789:/ /mnt/mycephfs
```

Ceph 存储集群默认需要认证，所以挂载时需要指定用户名 `name` 和密钥文件 `secretfile` ，例如：

```bash
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs -o name=admin,secretfile=admin.secret
```

## 用户空间文件系统（ FUSE ）

把 Ceph FS 挂载为用户空间文件系统（ FUSE ）。

```bash
sudo mkdir ~/mycephfs
sudo ceph-fuse -m {ip-address-of-monitor}:6789 ~/mycephfs
```

Ceph 存储集群默认要求认证，需指定相应的密钥环文件，除非它在默认位置（即 `/etc/ceph` ）：

```bash
sudo ceph-fuse -k ./ceph.client.admin.keyring -m 192.168.0.1:6789 ~/mycephfs
```
