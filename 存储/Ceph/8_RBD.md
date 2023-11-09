# RBD

[TOC]

## 概述

Ceph 块设备也叫 RBD 或 RADOS 块设备。

块是一个字节序列（通常为 512）。基于块的存储接口，是一种成熟而常见的在介质（包括 HDD、SSD、CD、软盘甚至磁带）上存储数据的方法。块设备接口的普遍性非常适合与包括 Ceph 在内的海量数据存储进行交互。

Ceph 块设备是精简配置的，可调整大小，并在多个 OSD 上存储条带化数据。Ceph 块设备利用 RADOS 功能，包括快照、复制和强一致性。Ceph 块存储客户端通过内核模块或 librbd 库与 Ceph 集群通信。

 ![img](../../Image/d/ditaa-9c4dce3fc347721433a81021ea03daac92997c1a.png)

> Note:
>
> 内核模块可以使用 Linux 页面缓存。对于基于 librbd 的应用程序，Ceph 支持 RBD 缓存。

Ceph 的块设备为内核模块或 KVM（如 QEMU ）以及基于云的计算系统（如 OpenStack 和 CloudStack ）提供了高性能和巨大的可扩展性，这些系统依赖于 libvirt 和 QEMU 与 Ceph 块设备集成。

 ![](../../Image/c/ceph_rados_rbd.jpg)

rbd 命令允许您创建、列出、内省introspect和删除块设备映像。还可以使用它克隆镜像、创建快照、rollback an image to a snapshot将镜像回滚到快照、查看快照等。

## 创建块设备池

1. 在管理节点，使用 `ceph` 工具创建池。

   ```bash
   ceph osd pool create {pool-name}
   ```

2. 在管理节点，使用 `rbd` 工具初始化池以供 RBD 使用：

   ```bash
   rbd pool init <pool-name>
   ```

> Note：
>
> 未提供池的名称时，rbd 工具假定默认池名为 “`rbd`” 。

## 创建块设备用户

除非另有说明，否则 rbd 命令将使用 ID 为 `admin` 的用户访问 Ceph 集群。此 ID 允许对群集进行完全管理访问。建议尽可能使用更受限的用户。将此非管理 Ceph 用户 ID 称为 “块设备用户” 或 “Ceph 用户”。

要创建 Ceph 用户，请使用 `ceph auth get-or-create` 命令指定 Ceph 用户 ID 名称、MON caps（功能）和 OSD caps（功能）：

```bash
ceph auth get-or-create client.{ID} mon 'profile rbd' osd 'profile {profile name} [pool={pool-name}][, profile ...]' mgr 'profile rbd [pool={pool-name}]'
```

例如要创建一个名为 `qemu` 的 Ceph 用户 ID ，该用户 ID 对池 `vms` 具有读写访问权限，对池 `images` 具有只读访问权限，请运行以下命令：

```bash
ceph auth get-or-create client.qemu mon 'profile rbd' osd 'profile rbd pool=vms, profile rbd-read-only pool=images' mgr 'profile rbd pool=images'
```

`ceph auth get-or-create` 命令的输出将是指定用户的 keyring ，可以写入到 `/etc/ceph/ceph.client.{ID}.keyring` 。

> Note:
>
> 使用 rbd 命令时，可以通过提供 `--id {id}` 可选参数来指定用户 ID 。

## 创建块设备 Image

在将块设备添加到节点之前，必须先在 Ceph 存储群集中为其创建映像 image 。要创建块设备映像，请执行以下操作：

```bash
rbd create --size {megabytes} {pool-name}/{image-name}
```

例如，要创建名为 `bar` 的 1GB 映像，该映像将信息存储在名为 `swimingpool` 的池中，请执行以下操作：

```bash
rbd create --size 1024 swimmingpool/bar
```

如果在创建映像时未指定池，则它将存储在默认池 rbd 中。例如，要创建存储在默认池 rbd 中名为 foo 的 1GB 映像，请执行以下操作：

```bash
rbd create --size 1024 foo
```

> Note
>
> 必须先创建池，然后才能将其指定为源。

## 列出块设备 Image

要列出 rbd 池中的块设备，请执行以下操作（即 rbd 是默认池名称）：

```bash
rbd ls
```

要列出特定池中的块设备，请执行以下操作，但将 {poolname} 替换为池的名称：

```bash
rbd ls {poolname}

rbd ls swimmingpool
```

要列出 rbd 池中的延迟删除deferred delete 块设备，请执行以下操作：

```bash
rbd trash ls
```

要列出特定池中的延迟删除deferred delete 块设备，请执行以下操作，但将 {poolname} 替换为池的名称：

```bash
rbd trash ls {poolname}

rbd trash ls swimmingpool
```

## 检索 Image 信息

要从特定 image 检索信息，请执行以下操作，但将 `{image-name}` 替换为 image 的名称：

```bash
rbd info {image-name}

rbd info foo
```

从池中的 image 中检索信息，执行以下操作，但将 `{image-name}` 替换为映像的名称，并将 {pool name} 替换为池的名称：

```bash
rbd info {pool-name}/{image-name}

rbd info swimmingpool/bar
```

> 注意
>
> 其他命名约定也是可能的，并且可能与这里描述的命名约定冲突。例如，`userid/<uuid>` 是 RBD image 的一个可能的名称，这样的名称可能（至少）令人困惑。

## 调整块设备 Image 的大小

Ceph 块设备映像 image 是精简配置的。在开始向它们保存数据之前，它们实际上不会使用任何物理存储。

但是，它们确实有一个最大容量，可以使用 `--size` 选项设置。如果要增大（或减小）Ceph 块设备映像的最大大小，请执行以下操作：

```bash
# 增加
rbd resize --size 2048 foo
# 减少
rbd resize --size 2048 foo --allow-shrink
```

## 删除块设备 Image

要删除块设备，请执行以下操作，但将 `{image-name}` 替换为要删除的 image 的名称：

```bash
rbd rm {image-name}

rbd rm foo
```

要从池中删除块设备，请执行以下操作，但将 `{image-name}` 替换为要删除的映像的名称，并将 `{pool-name}` 替换为池的名称：

```bash
rbd rm {pool-name}/{image-name}

rbd rm swimmingpool/bar
```

要延迟从池中删除块设备，请执行以下操作，但将 {image-name} 替换为要移动的映像的名称，并将 {pool-name} 替换为池的名称：

```bash
rbd trash mv {pool-name}/{image-name}

rbd trash mv swimmingpool/bar
```

要从池中删除延迟块设备，请执行以下操作，但将 {image-id} 替换为要删除的映像的 id ，并将 {pool-name} 替换为池的名称：

```bash
rbd trash rm {pool-name}/{image-id}

rbd trash rm swimmingpool/2bf4474b0dc51
```

> Note
>
> * 即使映像具有快照或正被克隆使用，也可以将其移到垃圾箱中。但是，不能在这些条件下将其从垃圾箱中删除。
> * 可以使用 `--expires-at` 设置延迟时间（默认为 now ）。如果延迟时间还没有到，不能删除，除非使用 `--force` 。

## 恢复块设备 Image

要恢复 rbd 池中的延迟删除块设备，请执行以下操作，但将 `{image-id}` 替换为映像的 id：

```bash
rbd trash restore {image-id}

rbd trash restore 2bf4474b0dc51
```

要从池中恢复延迟删除块设备，请执行以下操作，但将 `{image-id}` 替换为映像的 id，并将 {pool-name} 替换为池的名称：

```bash
rbd trash restore {pool-name}/{image-id}

rbd trash restore swimmingpool/2bf4474b0dc51
```

可以使用 `--image` 在还原 images 时进行重命名。

```bash
rbd trash restore swimmingpool/2bf4474b0dc51 --image new-name
```

## RBD Replay

RBD Replay is a set of tools for capturing and replaying RADOS Block Device (RBD) workloads. To capture an RBD workload, `lttng-tools` must be installed on the client, and `librbd` on the client must be the v0.87 (Giant) release or later. To replay an RBD workload, `librbd` on the client must be the Giant release or later.

Capture and replay takes three steps:

1. Capture the trace.  Make sure to capture `pthread_id` context:

   ```
   mkdir -p traces
   lttng create -o traces librbd
   lttng enable-event -u 'librbd:*'
   lttng add-context -u -t pthread_id
   lttng start
   # run RBD workload here
   lttng stop
   ```

2. Process the trace with [rbd-replay-prep](https://docs.ceph.com/en/latest/man/8/rbd-replay-prep):

   ```
   rbd-replay-prep traces/ust/uid/*/* replay.bin
   ```

3. Replay the trace with [rbd-replay](https://docs.ceph.com/en/latest/man/8/rbd-replay). Use read-only until you know it’s doing what you want:

   ```
   rbd-replay --read-only replay.bin
   ```

Important

`rbd-replay` will destroy data by default.  Do not use against an image you wish to keep, unless you use the `--read-only` option.

The replayed workload does not have to be against the same RBD image or even the same cluster as the captured workload. To account for differences, you may need to use the `--pool` and `--map-image` options of `rbd-replay`.        

# Block Device Quick Start

Ensure your [Ceph Storage Cluster](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Storage-Cluster) is in an `active + clean` state before working with the [Ceph Block Device](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Block-Device).

Note

The Ceph Block Device is also known as [RBD](https://docs.ceph.com/en/latest/glossary/#term-RBD) or [RADOS](https://docs.ceph.com/en/latest/glossary/#term-RADOS) Block Device.

You may use a virtual machine for your `ceph-client` node, but do not execute the following procedures on the same physical node as your Ceph Storage Cluster nodes (unless you use a VM). See [FAQ](http://wiki.ceph.com/How_Can_I_Give_Ceph_a_Try) for details.

## Create a Block Device Pool

1. On the admin node, use the `ceph` tool to [create a pool](https://docs.ceph.com/en/latest/rados/operations/pools/#create-a-pool) (we recommend the name ‘rbd’).

2. On the admin node, use the `rbd` tool to initialize the pool for use by RBD:

   ```
   rbd pool init <pool-name>
   ```

## Configure a Block Device

1. On the `ceph-client` node, create a block device image.

   ```
   rbd create foo --size 4096 --image-feature layering [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring] [-p {pool-name}]
   ```

2. On the `ceph-client` node, map the image to a block device.

   ```
   sudo rbd map foo --name client.admin [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring] [-p {pool-name}]
   ```

3. Use the block device by creating a file system on the `ceph-client` node.

   ```
   sudo mkfs.ext4 -m0 /dev/rbd/{pool-name}/foo
   
   This may take a few moments.
   ```

4. Mount the file system on the `ceph-client` node.

   ```
   sudo mkdir /mnt/ceph-block-device
   sudo mount /dev/rbd/{pool-name}/foo /mnt/ceph-block-device
   cd /mnt/ceph-block-device
   ```

5. Optionally configure the block device to be automatically mapped and mounted at boot (and unmounted/unmapped at shutdown) - see the [rbdmap manpage](https://docs.ceph.com/en/latest/man/8/rbdmap).

See [block devices](https://docs.ceph.com/en/latest/rbd) for additional details.

# Configuring the iSCSI Initiators

- [iSCSI Initiator for Linux](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-linux)

- [iSCSI Initiator for Microsoft Windows](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-win)

- [iSCSI Initiator for VMware ESX](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-esx)

  > Warning
  >
  > Applications that use SCSI persistent group reservations (PGR) and SCSI 2 based reservations are not supported when exporting a RBD image through more than one iSCSI gateway.

# iSCSI Initiator for Linux

**Prerequisite:**

- Package `iscsi-initiator-utils`
- Package `device-mapper-multipath`

**Installing:**

Install the iSCSI initiator and multipath tools:

> ```
> # yum install iscsi-initiator-utils
> # yum install device-mapper-multipath
> ```

**Configuring:**

1. Create the default `/etc/multipath.conf` file and enable the `multipathd` service:

   ```
   # mpathconf --enable --with_multipathd y
   ```

2. Add the following to `/etc/multipath.conf` file:

   ```
   devices {
           device {
                   vendor                 "LIO-ORG"
                   product                "TCMU device"
                   hardware_handler       "1 alua"
                   path_grouping_policy   "failover"
                   path_selector          "queue-length 0"
                   failback               60
                   path_checker           tur
                   prio                   alua
                   prio_args              exclusive_pref_bit
                   fast_io_fail_tmo       25
                   no_path_retry          queue
           }
   }
   ```

3. Restart the `multipathd` service:

   ```
   # systemctl reload multipathd
   ```

**iSCSI Discovery and Setup:**

1. Enable CHAP authentication and provide the initiator CHAP username and password by uncommenting and setting the following options in `/etc/iscsi/iscsid.conf` file:

   ```
   node.session.auth.authmethod = CHAP
   node.session.auth.username = myusername
   node.session.auth.password = mypassword
   ```

   If mutual (bidirectional) authentication is used, also provide the target CHAP username and password:

   ```
   node.session.auth.username_in = mytgtusername
   node.session.auth.password_in = mytgtpassword
   ```

2. Discover the target portals:

   ```
   # iscsiadm -m discovery -t st -p 192.168.56.101
   192.168.56.101:3260,1 iqn.2003-01.org.linux-iscsi.rheln1
   192.168.56.102:3260,2 iqn.2003-01.org.linux-iscsi.rheln1
   ```

3. Login to target:

   ```
   # iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.rheln1 -l
   ```

**Multipath IO Setup:**

The multipath daemon (`multipathd`), will set up devices automatically based on the `multipath.conf` settings. Running the `multipath` command show devices setup in a failover configuration with a priority group for each path.

```
# multipath -ll
mpathbt (360014059ca317516a69465c883a29603) dm-1 LIO-ORG ,IBLOCK
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='queue-length 0' prio=50 status=active
| `- 28:0:0:1 sde  8:64  active ready running
`-+- policy='queue-length 0' prio=10 status=enabled
  `- 29:0:0:1 sdc  8:32  active ready running
```

You should now be able to use the RBD image like you would a normal multipath’d iSCSI disk.

1. Logout from target:

   ```
   # iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.rheln1 -u
   ```

# iSCSI Initiator for Microsoft Windows

**Prerequisite:**

- Microsoft Windows Server 2016 or later

**iSCSI Initiator, Discovery and Setup:**

1. Install the iSCSI initiator driver and MPIO tools.
2. Launch the MPIO program, click on the “Discover Multi-Paths” tab, check the “Add support for iSCSI devices” box, and click “Add”. This will require a reboot.
3. On the iSCSI Initiator Properties window, on the “Discovery” tab, add a target portal. Enter the IP address or DNS name and Port of the Ceph iSCSI gateway.
4. On the “Targets” tab, select the target and click on “Connect”.
5. On the “Connect To Target” window, select the “Enable multi-path” option, and click the “Advanced” button.
6. Under the “Connet using” section, select a “Target portal IP” . Select the “Enable CHAP login on” and enter the “Name” and “Target secret” values from the Ceph iSCSI Ansible client credentials section, and click OK.
7. Repeat steps 5 and 6 for each target portal defined when setting up the iSCSI gateway.

**Multipath IO Setup:**

Configuring the MPIO load balancing policy, setting the timeout and retry options are using PowerShell with the `mpclaim` command. The rest is done in the iSCSI Initiator tool.

Note

It is recommended to increase the `PDORemovePeriod` option to 120 seconds from PowerShell. This value might need to be adjusted based on the application. When all paths are down, and 120 seconds expires, the operating system will start failing IO requests.

```
Set-MPIOSetting -NewPDORemovePeriod 120
mpclaim.exe -l -m 1
mpclaim -s -m
MSDSM-wide Load Balance Policy: Fail Over Only
```

1. Using the iSCSI Initiator tool, from the “Targets” tab, click on the “Devices…” button.
2. From the Devices window, select a disk and click the “MPIO…” button.
3. On the “Device Details” window the paths to each target portal is displayed. If using the `ceph-ansible` setup method, the iSCSI gateway will use ALUA to tell the iSCSI initiator which path and iSCSI gateway should be used as the primary path. The Load Balancing Policy “Fail Over Only” must be selected

```
mpclaim -s -d $MPIO_DISK_ID
```

Note

For the `ceph-ansible` setup method, there will be one Active/Optimized path which is the path to the iSCSI gateway node that owns the LUN, and there will be an Active/Unoptimized path for each other iSCSI gateway node.

**Tuning:**

Consider using the following registry settings:

- Windows Disk Timeout

  ```
  HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Disk
  ```

  ```
  TimeOutValue = 65
  ```

- Microsoft iSCSI Initiator Driver

  ```
  HKEY_LOCAL_MACHINE\\SYSTEM\CurrentControlSet\Control\Class\{4D36E97B-E325-11CE-BFC1-08002BE10318}\<Instance_Number>\Parameters
  ```

  ```
  LinkDownTime = 25
  SRBTimeoutDelta = 15
  ```

# iSCSI Initiator for VMware ESX

**Prerequisite:**

- VMware ESX 6.5 or later using Virtual Machine compatibility 6.5 with VMFS 6.

**iSCSI Discovery and Multipath Device Setup:**

The following instructions will use the default vSphere web client and esxcli.

1. Enable Software iSCSI

   

   Click on “Storage” from “Navigator”, and select the “Adapters” tab. From there right click “Configure iSCSI”.

2. Set Initiator Name

   

   If the initiator name in the “Name & alias” section is not the same name used when creating the client during gwcli setup or the initiator name used in the ansible client_connections client variable, then ssh to the ESX host and run the following esxcli commands to change the name.

   Get the adapter name for Software iSCSI:

   ```
   > esxcli iscsi adapter list
   > Adapter  Driver     State   UID            Description
   > -------  ---------  ------  -------------  ----------------------
   > vmhba64  iscsi_vmk  online  iscsi.vmhba64  iSCSI Software Adapter
   ```

   In this example the software iSCSI adapter is vmhba64 and the initiator name is iqn.1994-05.com.redhat:rh7-client:

   > ```
   > > esxcli iscsi adapter set -A vmhba64 -n iqn.1994-05.com.redhat:rh7-client
   > ```

3. Setup CHAP

   

   Expand the CHAP authentication section, select “Do not use CHAP unless required by target” and enter the CHAP credentials used in the gwcli auth command or ansible client_connections credentials variable.

   The Mutual CHAP authentication section should have “Do not use CHAP” selected.

   Warning: There is a bug in the web client where the requested CHAP settings are not always used initially. On the iSCSI gateway kernel logs you will see the error:

   > ```
   > > kernel: CHAP user or password not set for Initiator ACL
   > > kernel: Security negotiation failed.
   > > kernel: iSCSI Login negotiation failed.
   > ```

   To workaround this set the CHAP settings with the esxcli command. Here authname is the username and secret is the password used in previous examples:

   ```
   > esxcli iscsi adapter auth chap set --direction=uni --authname=myiscsiusername --secret=myiscsipassword --level=discouraged -A vmhba64
   ```

4. Configure iSCSI Settings

   

   Expand Advanced settings and set the “RecoveryTimeout” to 25.

5. Set the discovery address

   

   In the Dynamic targets section, click “Add dynamic target” and under Addresses add one of the gateway IP addresses added during the iSCSI gateway setup stage in the gwcli section or an IP set in the ansible gateway_ip_list variable. Only one address needs to be added as the gateways have been setup so all the iSCSI portals are returned during discovery.

   Finally, click the “Save configuration” button. In the Devices tab, you should see the RBD image.

   The LUN should be automatically configured and using the ALUA SATP and MRU PSP. Other SATPs and PSPs must not be used. This can be verified with the esxcli command:

   ```
   > esxcli storage nmp path list -d eui.your_devices_id
   ```

**Prerequisite:**

- VMware ESX 6.5 or later using Virtual Machine compatibility 6.5 with VMFS 6.

**iSCSI Discovery and Multipath Device Setup:**

The following instructions will use the default vSphere web client and esxcli.

1. Enable Software iSCSI

   

   Click on “Storage” from “Navigator”, and select the “Adapters” tab. From there right click “Configure iSCSI”.

2. Set Initiator Name

   

   If the initiator name in the “Name & alias” section is not the same name used when creating the client during gwcli setup or the initiator name used in the ansible client_connections client variable, then ssh to the ESX host and run the following esxcli commands to change the name.

   Get the adapter name for Software iSCSI:

   ```
   > esxcli iscsi adapter list
   > Adapter  Driver     State   UID            Description
   > -------  ---------  ------  -------------  ----------------------
   > vmhba64  iscsi_vmk  online  iscsi.vmhba64  iSCSI Software Adapter
   ```

   In this example the software iSCSI adapter is vmhba64 and the initiator name is iqn.1994-05.com.redhat:rh7-client:

   > ```
   > > esxcli iscsi adapter set -A vmhba64 -n iqn.1994-05.com.redhat:rh7-client
   > ```

3. Setup CHAP

   

   Expand the CHAP authentication section, select “Do not use CHAP unless required by target” and enter the CHAP credentials used in the gwcli auth command or ansible client_connections credentials variable.

   The Mutual CHAP authentication section should have “Do not use CHAP” selected.

   Warning: There is a bug in the web client where the requested CHAP settings are not always used initially. On the iSCSI gateway kernel logs you will see the error:

   > ```
   > > kernel: CHAP user or password not set for Initiator ACL
   > > kernel: Security negotiation failed.
   > > kernel: iSCSI Login negotiation failed.
   > ```

   To workaround this set the CHAP settings with the esxcli command. Here authname is the username and secret is the password used in previous examples:

   ```
   > esxcli iscsi adapter auth chap set --direction=uni --authname=myiscsiusername --secret=myiscsipassword --level=discouraged -A vmhba64
   ```

4. Configure iSCSI Settings

   

   Expand Advanced settings and set the “RecoveryTimeout” to 25.

5. Set the discovery address

   

   In the Dynamic targets section, click “Add dynamic target” and under Addresses add one of the gateway IP addresses added during the iSCSI gateway setup stage in the gwcli section or an IP set in the ansible gateway_ip_list variable. Only one address needs to be added as the gateways have been setup so all the iSCSI portals are returned during discovery.

   Finally, click the “Save configuration” button. In the Devices tab, you should see the RBD image.

   The LUN should be automatically configured and using the ALUA SATP and MRU PSP. Other SATPs and PSPs must not be used. This can be verified with the esxcli command:

   ```
   > esxcli storage nmp path list -d eui.your_devices_id
   ```

# Monitoring Ceph iSCSI gateways

Ceph provides a tool for iSCSI gateway environments to monitor performance of exported RADOS Block Device (RBD) images.

The `gwtop` tool is a `top`-like tool that displays aggregated performance metrics of RBD images that are exported to clients over iSCSI. The metrics are sourced from a Performance Metrics Domain Agent (PMDA). Information from the Linux-IO target (LIO) PMDA is used to list each exported RBD image, the connected client, and its associated I/O metrics.

**Requirements:**

- A running Ceph iSCSI gateway

**Installing:**

1. As `root`, install the `ceph-iscsi-tools` package on each iSCSI gateway node:

   ```
   # yum install ceph-iscsi-tools
   ```

2. As `root`, install the performance co-pilot package on each iSCSI gateway node:

   ```
   # yum install pcp
   ```

3. As `root`, install the LIO PMDA package on each iSCSI gateway node:

   ```
   # yum install pcp-pmda-lio
   ```

4. As `root`, enable and start the performance co-pilot service on each iSCSI gateway node:

   ```
   # systemctl enable pmcd
   # systemctl start pmcd
   ```

5. As `root`, register the `pcp-pmda-lio` agent:

   ```
   cd /var/lib/pcp/pmdas/lio
   ./Install
   ```

By default, `gwtop` assumes the iSCSI gateway configuration object is stored in a RADOS object called `gateway.conf` in the `rbd` pool. This configuration defines the iSCSI gateways to contact for gathering the performance statistics. This can be overridden by using either the `-g` or `-c` flags. See `gwtop --help` for more details.

The LIO configuration determines which type of performance statistics to extract from performance co-pilot. When `gwtop` starts it looks at the LIO configuration, and if it find user-space disks, then `gwtop` selects the LIO collector automatically.

**Example ``gwtop`` Outputs**

```
gwtop  2/2 Gateways   CPU% MIN:  4 MAX:  5    Network Total In:    2M  Out:    3M   10:20:00
Capacity:   8G    Disks:   8   IOPS:  503   Clients:  1   Ceph: HEALTH_OK          OSDs:   3
Pool.Image       Src    Size     iops     rMB/s     wMB/s   Client
iscsi.t1703             500M        0      0.00      0.00
iscsi.testme1           500M        0      0.00      0.00
iscsi.testme2           500M        0      0.00      0.00
iscsi.testme3           500M        0      0.00      0.00
iscsi.testme5           500M        0      0.00      0.00
rbd.myhost_1      T       4G      504      1.95      0.00   rh460p(CON)
rbd.test_2                1G        0      0.00      0.00
rbd.testme              500M        0      0.00      0.00
```

In the *Client* column, `(CON)` means the iSCSI initiator (client) is currently logged into the iSCSI gateway. If `-multi-` is displayed, then multiple clients are mapped to the single RBD image.

## Cephx

当启用 cephx 身份验证时（默认情况下），必须指定用户名或 ID 以及指向包含相应密钥的密钥环的路径。还可以设置 CEPH_ARGS 环境变量，以避免重新输入这些参数。

```bash
rbd --id {user-ID} --keyring=/path/to/secret [commands]
rbd --name {username} --keyring=/path/to/secret [commands]

rbd --id admin --keyring=/etc/ceph/ceph.keyring [commands]
rbd --name client.admin --keyring=/etc/ceph/ceph.keyring [commands]
```

> Tip：
>
> 将 user 和 secret 添加到 CEPH_ARGS 环境变量中，这样就不需要每次都输入它们。

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
