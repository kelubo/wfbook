# 迁移现有集群到cephadm

[TOC]

可以迁移一些现有的集群，以便使用 `cephadm` 来管理。适用于使用 `ceph-deploy`, `ceph-ansible` 或 `DeepSea` 部署的一些集群。

## 限制

Cephadm 只适用于 BlueStore OSD。

## 准备

1. 确保 `cephadm` 命令行工具在现有集群中的每个主机上都可用。

2. 通过运行以下命令准备每个主机以供 `cephadm` 使用：

   ```bash
   cephadm prepare-host
   ```

3. 选择用于迁移的 Ceph 版本。此程序将适用于 Octopus（15.2.z）或更高版本（含）的任何 Ceph 版本。Ceph 的最新稳定版本是默认版本。在执行转换的同时，您可能正在从早期的 Ceph 版本升级；如果要从早期版本升级，请确保遵循该版本的任何升级相关说明。

   使用以下命令将 image 传递给 cephadm：

   ```bash
   cephadm --image $IMAGE <rest of command goes here>
   ```

   转换开始。

4. 运行 `cephadm ls` 以确认转换正在进行，并确保守护程序的 style 已更改：

   ```bash
   cephadm ls
   ```

   在开始迁移过程之前，`cephadm ls` 显示所有现有守护进程都具有 `legacy` style 。随着迁移过程的进行，迁移的守护进程将以 `cephadm:v1` 的样式出现。

## 迁移过程

1. 确保 ceph 配置已迁移到使用集群配置数据库。如果每台主机上的 `/etc/ceph/ceph.conf` 都相同，那么以下命令可以在一台主机上运行，并且会影响所有主机：

   ```bash
   ceph config assimilate-conf -i /etc/ceph/ceph.conf
   ```

   如果主机之间存在配置差异，则需要在每个主机上重复此命令。在此迁移过程中，通过运行以下命令查看集群的配置以确认它已完成：

   ```bash
   ceph config dump
   ```

2. 迁移每个 MON ：

   ```bash
   cephadm adopt --style legacy --name mon.<hostname>
   ```

   每个旧 MON 都应该停止，作为 cephadm 容器快速重新启动，然后重新加入仲裁。

3. 迁移每个 MGR ：

   ```bash
   cephadm adopt --style legacy --name mgr.<hostname>
   ```

4. 启用 cephadm ：

   ```bash
   ceph mgr module enable cephadm
   ceph orch set backend cephadm
   ```

5. 生成 SSH 密钥：

   ```bash
   ceph cephadm generate-key
   ceph cephadm get-pub-key > ~/ceph.pub
   ```

6. 在群集中的每个主机上安装群集 SSH 密钥：

   ```bash
   ssh-copy-id -f -i ~/ceph.pub root@<host>
   ```

   > **Note：**
   >
   > 也可以导入现有的 SSH 密钥。
   >
   > 也可以让 cephadm 使用非 root 用户 SSH 连接到集群主机。此用户需要具有无密码 sudo 访问权限。使用 `ceph cephadm set-user＜user＞` 并将 SSH 密钥复制到该用户。

7. 告诉 cephadm 要管理哪些主机：

   ```bash
   ceph orch host add <hostname> [ip-address]
   ```

   这将在添加主机之前对每个主机执行 `cephadm check-host` ；此检查可确保主机正常运行。建议使用 IP 地址参数；如果未提供，则将通过 DNS 解析主机名。

8. 验证所迁移的 MON 和 MGR 守护程序是否可见：

   ```bash
   ceph orch ps
   ```

9. 迁移集群中所有的 OSD ：

   ```bash
   cephadm adopt --style legacy --name <name>
   ```

   例如：

   ```bash
   cephadm adopt --style legacy --name osd.1
   cephadm adopt --style legacy --name osd.2
   ```

10. 通过告诉 cephadm 每个文件系统要运行多少个守护程序来重新部署 MDS 守护程序。使用命令 `ceph fs ls` 按名称列出文件系统。在主节点上运行以下命令以重新部署 MDS 守护程序：

    ```bash
    ceph orch apply mds <fs-name> [--placement=<placement>]
    ```

    例如，在具有名为 `foo` 的单个文件系统的集群中：

    ```bash
    ceph fs ls
    name: foo, metadata pool: foo_metadata, data pools: [foo_data ]
    
    ceph orch apply mds foo 2
    ```

    确认新的MDS守护程序已启动：

    ```bash
    ceph orch ps --daemon-type mds
    ```

    最后，停止并删除旧的 MDS 守护程序：

    ```bash
    systemctl stop ceph-mds.target
    rm -rf /var/lib/ceph/mds/ceph-*
    ```

11. 重新部署 RGW 守护程序。Cephadm 按区域管理 RGW 守护程序。对于每个区域，使用 cephadm 部署新的 RGW 守护进程：

    ```bash
    ceph orch apply rgw <svc_id> [--realm=<realm>] [--zone=<zone>] [--port=<port>] [--ssl] [--placement=<placement>]
    ```

    其中 `＜placement＞` 可以是一个简单的守护程序计数，也可以是特定主机的列表，zone 和 realm 参数仅用于多站点设置。

    在守护程序启动并确认其正常运行后，停止并删除旧的守护程序：

    ```bash
    systemctl stop ceph-rgw.target
    rm -rf /var/lib/ceph/radosgw/ceph-*
    ```

12. 检查命令 `ceph health detail` 的输出，查看 cephadm 警告，了解有关未由 cephadm 管理的群集守护进程或主机的信息。
