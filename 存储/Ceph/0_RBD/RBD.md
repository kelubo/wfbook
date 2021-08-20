# RBD

[TOC]

Ceph 块设备也叫 RBD 或 RADOS 块设备。

![](../../../Image/c/ceph_rados_rbd.jpg)

## 安装 Ceph

1. 确认你使用了合适的内核版本。

   ```bash
   lsb_release -a
   uname -r
   ```

2. 在管理节点上，通过 `ceph-deploy` 把 Ceph 安装到 `ceph-client` 节点。

   ```bash
   ceph-deploy install ceph-client
   ```

3. 在管理节点上，用 `ceph-deploy` 把 Ceph 配置文件和 `ceph.client.admin.keyring` 拷贝到 `ceph-client` 。

   ```bash
   ceph-deploy admin ceph-client
   ```

   `ceph-deploy` 工具会把密钥环复制到 `/etc/ceph` 目录，要确保此密钥环文件有读权限（如 `sudo chmod +r /etc/ceph/ceph.client.admin.keyring` ）。

## 配置块设备

1. 在 `ceph-client` 节点上创建一个块设备 image 。

   ```bash
   rbd create foo --size 4096 [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring]
   ```

2. 在 `ceph-client` 节点上，把 image 映射为块设备。

   ```bash
   sudo rbd map foo --name client.admin [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring]
   ```

3. 在 `ceph-client` 节点上，创建文件系统后就可以使用块设备了。

   ```bash
   sudo mkfs.ext4 -m0 /dev/rbd/rbd/foo
   ```

   此命令可能耗时较长。

4. 在 `ceph-client` 节点上挂载此文件系统。

   ```bash
   sudo mkdir /mnt/ceph-block-device
   sudo mount /dev/rbd/rbd/foo /mnt/ceph-block-device
   cd /mnt/ceph-block-device
   ```
