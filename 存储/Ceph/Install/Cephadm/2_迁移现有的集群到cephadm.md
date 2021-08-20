# 迁移现有集群到cephadm

[TOC]

可以迁移一些现有集群，以便使用 `cephadm` 管理它们。适用于使用 `ceph-deploy`, `ceph-ansible` 或 `DeepSea` 部署的一些集群。

本节说明如何确定集群是否可以转换为cephadm可以管理的状态，以及如何执行这些转换。

## 限制

Cephadm只适用于 BlueStore OSD。不能使用 cephadm 管理群集中的 FileStore OSD 。

## Preparation

1. 确保 cephadm 命令行工具在现有集群中的每个主机上都可用。

2. 通过运行以下命令准备每个主机以供cephadm使用：

   ```bash
   cephadm prepare-host
   ```

3. 选择用于迁移的 Ceph 版本。Ceph的最新稳定版本是默认版本。

   使用以下命令将 image 传递给cephadm：

   ```bash
   cephadm --image $IMAGE <rest of command goes here>
   ```

4. Confirm that the conversion is underway by running `cephadm ls` and making sure that the style of the daemons is changed:运行 `cephadm ls` 以确认转换正在进行，并确保守护程序的 style 已更改：

   ```bash
   cephadm ls
   ```

   在开始迁移过程之前，`cephadm ls` 显示所有现有守护进程都具有 `legacy` style 。As the adoption process progresses, adopted daemons will appear with a style of `cephadm:v1`.

## Adoption process

1. Make sure that the ceph configuration has been migrated to use the cluster config database.  If the `/etc/ceph/ceph.conf` is identical on each host, then the following command can be run on one single host and will affect all hosts:

   ```bash
   ceph config assimilate-conf -i /etc/ceph/ceph.conf
   ```

   If there are configuration variations between hosts, you will need to repeat this command on each host. During this adoption process, view the cluster’s configuration to confirm that it is complete by running the following command:

   ```bash
   ceph config dump
   ```

2. Adopt each monitor:

   ```bash
   cephadm adopt --style legacy --name mon.<hostname>
   ```

   Each legacy monitor should stop, quickly restart as a cephadm container, and rejoin the quorum.

3. Adopt each manager:

   ```bash
   cephadm adopt --style legacy --name mgr.<hostname>
   ```

4. Enable cephadm:

   ```bash
   ceph mgr module enable cephadm
   ceph orch set backend cephadm
   ```

5. Generate an SSH key:

   ```bash
   ceph cephadm generate-key
   ceph cephadm get-pub-key > ~/ceph.pub
   ```

6. Install the cluster SSH key on each host in the cluster:

   ```bash
   ssh-copy-id -f -i ~/ceph.pub root@<host>
   ```

   > **Note**
>
   > It is also possible to import an existing ssh key. See [ssh errors](https://docs.ceph.com/en/latest/cephadm/troubleshooting/#cephadm-ssh-errors) in the troubleshooting document for instructions that describe how to import existing ssh keys.

7. Tell cephadm which hosts to manage:

   ```bash
   ceph orch host add <hostname> [ip-address]
   ```

   This will perform a `cephadm check-host` on each host before adding it; this check ensures that the host is functioning properly. The IP address argument is required only if DNS does not allow you to connect to each host by its short name.

8. Verify that the adopted monitor and manager daemons are visible:

   ```bash
   ceph orch ps
   ```

9. Adopt all OSDs in the cluster:

   ```bash
   cephadm adopt --style legacy --name <name>
   ```

   For example:

   ```bash
   cephadm adopt --style legacy --name osd.1
   cephadm adopt --style legacy --name osd.2
   ```

10. Redeploy MDS daemons by telling cephadm how many daemons to run for each file system. List file systems by name with the command `ceph fs ls`. Run the following command on the master nodes to redeploy the MDS daemons:

    ```bash
    ceph orch apply mds <fs-name> [--placement=<placement>]
    ```

    For example, in a cluster with a single file system called foo:

    ```bash
    ceph fs ls
    ```

    ```bash
    name: foo, metadata pool: foo_metadata, data pools: [foo_data ]
    ```

    ```bash
    ceph orch apply mds foo 2
    ```

    Confirm that the new MDS daemons have started:

    ```bash
    ceph orch ps --daemon-type mds
    ```

    Finally, stop and remove the legacy MDS daemons:

    ```bash
    systemctl stop ceph-mds.target
    rm -rf /var/lib/ceph/mds/ceph-*
    ```

11. Redeploy RGW daemons. Cephadm manages RGW daemons by zone. For each zone, deploy new RGW daemons with cephadm:

    ```bash
    ceph orch apply rgw <svc_id> [--realm=<realm>] [--zone=<zone>] [--port=<port>] [--ssl] [--placement=<placement>]
    ```

    where *<placement>* can be a simple daemon count, or a list of specific hosts (see [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec)), and the zone and realm arguments are needed only for a multisite setup.

    After the daemons have started and you have confirmed that they are functioning, stop and remove the old, legacy daemons:

    ```bash
    systemctl stop ceph-rgw.target
    rm -rf /var/lib/ceph/radosgw/ceph-*
    ```

12. Check the output of the command `ceph health detail` for cephadm warnings about stray cluster daemons or hosts that are not yet managed by cephadm.
