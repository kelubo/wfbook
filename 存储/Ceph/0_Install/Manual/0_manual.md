# Manual

[TOC]

## 获取软件

详见 **获取软件包.md**

## 安装软件

要在集群中的每个 Ceph 节点上安装包。如果要安装 Ceph 对象网关或 QEMU，则应为 RHEL/CentOS 和其他使用 Yum 的发行版安装 Yum Priorities 。

### APT

```bash
apt-get update
apt-get install ceph
```

### RPM

1. 安装 `yum-plugin-priorities`.

   ```bash
   yum install yum-plugin-priorities
   ```

2. 确保 `/etc/yum/pluginconf.d/priorities.conf` 文件存在。

3. 确保 `priorities.conf` 启用了插件。

   ```bash
   [main]
   enabled = 1
   ```

4. 确保 YUM `ceph.repo` 条目包括 `priority=2` 。

   ```bash
   [ceph]
   name=Ceph packages for $basearch
   baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/$basearch
   enabled=1
   priority=2
   gpgcheck=1
   gpgkey=https://download.ceph.com/keys/release.asc
   
   [ceph-noarch]
   name=Ceph noarch packages
   baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
   enabled=1
   priority=2
   gpgcheck=1
   gpgkey=https://download.ceph.com/keys/release.asc
   
   [ceph-source]
   name=Ceph source packages
   baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/SRPMS
   enabled=0
   priority=2
   gpgcheck=1
   gpgkey=https://download.ceph.com/keys/release.asc
   ```

5. 安装必备软件包：
   ```bash
   yum install snappy gdisk python-argparse gperftools-libs
   ```

6. 安装 ceph

   ```bash
   yum install ceph
   ```

### Installing a Build

如果你从源代码构建 Ceph，你可以通过执行以下命令在用户空间安装 Ceph：

```bash
ninja install
```

如果在本地安装 Ceph，`ninja` 会将可执行文件放在 `usr/local/bin`中。可以将 Ceph 配置文件添加到`usr/local/bin` 目录以从单个目录运行 Ceph。

## 部署集群

一旦在节点上安装了 Ceph，就可以手动部署集群。手动过程主要用于使用 Chef 、Juju 、Puppet 等开发部署脚本的示例。

引导初始 MON 是部署 Ceph 存储集群的第一步。MON 部署还为整个群集设置了重要的标准，例如池的副本数量、每个 OSD 的放置组数量、心跳间隔、是否需要身份验证等。这些值中的大多数都是默认设置的，因此在为生产设置群集时了解它们非常有用。

### MON 引导

引导 MON（理论上是一个 Ceph 存储集群）需要做很多事情：

- **唯一标识符** 

  `fsid` 是集群的唯一标识符，代表 Ceph 存储集群主要用于 Ceph 文件系统时的文件系统 ID。 Ceph 现在也支持原生接口、块设备和对象存储网关接口，所以 `fsid` 有点用词不当。

- **集群名称**

  Ceph 集群有一个集群名称，是一个没有空格的简单字符串。默认集群名称是 `ceph` ，但可以指定不同的集群名称。当您使用多个集群并且需要清楚地了解正使用哪个集群时，重写默认集群名称特别有用。

  例如，当在多站点配置中运行多个群集时，群集名称（例如，`us-west`，`us-east`）标识当前 CLI 会话的群集。

  注意：要在命令行界面上标识集群名称，请指定带有集群名称的 Ceph 配置文件（例如，`ceph.conf` 、`us-west.conf` 、`us-east.conf` 等）。

- **MON 名称**

  集群中的每个 MON 实例都有一个唯一的名称。通常情况下，Ceph Monitor 名称是主机名（建议每个主机一个 Ceph Monitor，并且不要将 Ceph OSD 守护程序与 Ceph MON 混淆）。可以使用 `hostname -s` 检索短主机名。

- **Monitor Map**

  引导初始 MON 需要生成一个 MON 映射。MON 映射需要 `fsid`、集群名（或使用默认值）以及至少一个主机名及其 IP 地址。

- **Monitor Keyring**

  MON 通过密钥相互通信。必须生成一个带有 MON 密钥的密钥环，并在引导初始 MON 时提供它。

- **Administrator Keyring**

  要使用 `ceph` CLI 工具，须拥有 `client.admin` 用户。因此必须生成 admin 用户和 keyring ，还必须将 `client.admin` 用户添加到 MON keyring 。

上述要求并不意味着创建 Ceph 配置文件。但是，作为最佳实践，建议创建一个 Ceph 配置文件，并使用 `fsid` 、`mon_initial_numbers` 和 `monhost` 设置对其进行填充。

也可以在运行时获取和设置所有 MON 设置。但是，Ceph 配置文件可能只包含那些覆盖默认值的设置。向 Ceph 配置文件添加设置时，这些设置将覆盖默认设置。在 Ceph 配置文件中维护这些设置可以更容易地维护集群。

过程如下：

1. 登录到初始 MON 节点：

   ```bash
   ssh {hostname}
   ```

2. 确认有一个目录存放 Ceph 配置文件。默认情况下， Ceph 使用 `/etc/ceph` 。当安装 `ceph` ，安装程序会自动创建该目录。

   ```bash
   ls /etc/ceph
   ```

3. 创建 Ceph 配置文件。默认情况下，Ceph 使用 `ceph.conf` ，其中 `ceph` 反映集群名称。在配置文件中添加一行包含“[global]”。

   ```bash
   vim /etc/ceph/ceph.conf
   ```

4. 为集群生成唯一 ID（即 `fsid` ）。

   ```bash
   uuidgen
   ```

5. 将唯一 ID 添加到 Ceph 配置文件中。

   ```bash
   fsid = {UUID}
   ```

   例如：

   ```bash
   fsid = a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

6. 将初始 MON 添加到 Ceph 配置文件中。

   ```bash
   mon_initial_members = {hostname}[,{hostname}]
   ```

   例如：

   ```bash
   mon_initial_members = node1
   ```

7. 将初始 MON 的 IP 地址添加到 Ceph 配置文件中，然后保存该文件。

   ```bash
   mon_host = {ip-address}[,{ip-address}]
   ```

   例如：

   ```bash
   mon_host = 192.168.0.1
   ```

   **Note:** 可以使用 IPv6 地址而不是 IPv4 地址，但必须将 `ms_bind_ipv6` 设置为 `true` 。

8. 为集群创建一个密钥环，并生成一个 MON 密钥。

   ```bash
   ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
   ```

9. 生成管理员密钥环，生成 `client.admin` 用户并将用户添加到密钥环。

   ```bash
   ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
   ```

10. 生成 bootstrap-osd 密钥环，生成 `client.bootstrap-osd` 用户并将用户添加到密钥环。

    ```bash
    ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
    ```

11. 将生成的密钥添加到 `ceph.mon.keyring`.

    ```bash
    ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
    
    ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
    ```

12. 变更 `ceph.mon.keyring` 的所有者。

    ```bash
    chown ceph:ceph /tmp/ceph.mon.keyring
    ```

13. 使用 hostname 、host IP address 和 FSID，生成一个 monitor map ，保存到 `/tmp/monmap` :

    ```bash
    monmaptool --create --add {hostname} {ip-address} --fsid {uuid} /tmp/monmap
    ```

    例如：

    ```bash
    monmaptool --create --add node1 192.168.0.1 --fsid a7f64266-0894-4f1e-a635-d0aeaca0e993 /tmp/monmap
    ```

14. 在 MON 主机上创建默认数据目录。

    ```bash
    mkdir /var/lib/ceph/mon/{cluster-name}-{hostname}
    ```

    例如：

    ```bash
    sudo -u ceph mkdir /var/lib/ceph/mon/ceph-node1
    ```

15. 使用 MON 映射和 keyring 填充 MON 守护进程。

    ```bash
    sudo -u ceph ceph-mon [--cluster {cluster-name}] --mkfs -i {hostname} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

    例如：

    ```bash
    sudo -u ceph ceph-mon --mkfs -i node1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

16. Ceph 配置文件通常包含如下设置：

    ```ini
    [global]
    fsid = {cluster-id}
    mon_initial_members = {hostname}[, {hostname}]
    mon_host = {ip-address}[, {ip-address}]
    public_network = {network}[, {network}]
    cluster_network = {network}[, {network}]
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
    osd_pool_default_size = {n}     # Write an object n times.
    osd_pool_default_min_size = {n} # Allow writing n copies in a degraded state.
    osd_pool_default_pg_num = {n}
    osd_crush_chooseleaf_type = {n}
    ```

    在前面的例子中，配置的 `[global]` 部分可能看起来像这样：

    ```ini
    [global]
    fsid = a7f64266-0894-4f1e-a635-d0aeaca0e993
    mon_initial_members = node1
    mon_host = 192.168.0.1
    public_network = 192.168.0.0/24
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
    osd_pool_default_size = 3
    osd_pool_default_min_size = 2
    osd_pool_default_pg_num = 333
    osd_crush_chooseleaf_type = 1
    ```

17. 启动 MON 服务。

    ```bash
    systemctl start ceph-mon@node1
    ```

18. 确保为 ceph-mon 打开防火墙端口。

    ```bash
    firewall-cmd --zone=public --add-service=ceph-mon
    firewall-cmd --zone=public --add-service=ceph-mon --permanent
    ```

19. 确认 MON 运行状态。

    ```bash
    ceph -s
    ```

    会看到监视器已启动并正在运行的输出，并且应该会看到一个运行状况错误，表明归置组处于非活动状态。

    ```bash
    cluster:
      id:     a7f64266-0894-4f1e-a635-d0aeaca0e993
      health: HEALTH_OK
    
    services:
      mon: 1 daemons, quorum node1
      mgr: node1(active)
      osd: 0 osds: 0 up, 0 in
    
    data:
      pools:   0 pools, 0 pgs
      objects: 0 objects, 0 bytes
      usage:   0 kB used, 0 kB / 0 kB avail
      pgs:
    ```

    **Note:** 添加 OSD 并启动它们后，放置组运行状况错误应该会消失。

### Manager 配置

在运行 MON 的每个节点上，还应该设置一个 MGR 。

### 添加 OSD

初始 MON 运行，应该添加 OSD。除非有足够的 OSD 来处理对象的副本数量（例如，`osd_pool_default_size = 2` 需要至少两个 OSD），否则集群无法达到 `active + clean` 状态。在引导 MON 之后，集群有一个默认的 CRUSH map ；然而，CRUSH map 没有任何映射到 Ceph 节点的 Ceph OSD 。

#### 短格式

Ceph 提供了 `ceph-volume` 实用程序，它可以准备逻辑卷、磁盘或分区以供 Ceph 使用。 `ceph-volume`  实用程序通过增加索引来创建 OSD ID 。另外，`ceph-volume` 会将新的 OSD 添加到主机下的 CRUSH map 中。执行  `ceph-volume -h` 以获取 CLI 详细信息。`ceph-volume` 实用程序自动执行下面长格式的步骤。要使用短格式程序创建前两个 OSD，对每个 OSD 执行以下操作：

创建 OSD ：

```bash
# copy /var/lib/ceph/bootstrap-osd/ceph.keyring from monitor node (mon-node1) to /var/lib/ceph/bootstrap-osd/ceph.keyring on osd node (osd-node1)
ssh {osd node}
ceph-volume lvm create --data {data-path}
```

例如：

```bash
scp -3 root@mon-node1:/var/lib/ceph/bootstrap-osd/ceph.keyring root@osd-node1:/var/lib/ceph/bootstrap-osd/ceph.keyring
ssh osd-node1
ceph-volume lvm create --data /dev/hdd1
```

或者，创建过程可以分为两个阶段（准备和激活）：

1. 准备 OSD ：

   ```bash
   ssh {node-name}
   ceph-volume lvm prepare --data {data-path} {data-path}
   ```

   例如：

   ```bash
   ssh node1
   ceph-volume lvm prepare --data /dev/hdd1
   ```

   准备好后，激活需要 OSD 的 `ID` 和 `FSID` 。可以通过列出当前服务器中的 OSD 来获得：

   ```bash
   ceph-volume lvm list
   ```

2. 激活 OSD ：

   ```bash
   ceph-volume lvm activate {ID} {FSID}
   ```

   例如：

   ```bash
   ceph-volume lvm activate 0 a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

#### 长格式

在没有任何辅助工具的情况下，创建一个 OSD 并将其添加到集群和 CRUSH 映射。要使用长格式过程创建前两个 OSD，请对每个 OSD 执行以下步骤。

> Note
>
> 此过程不描述使用dm-crypt“lockbox”在dm-crypt之上进行部署。

1. 连接到 OSD 主机并切换为 root 用户：

   ```bash
   ssh {node-name}
   sudo bash
   ```

2. 为 OSD 生成 UUID 。

   ```bash
   UUID=$(uuidgen)
   ```

3. 为 OSD 生成一个 cephx 密钥。

   ```bash
   OSD_SECRET=$(ceph-authtool --gen-print-key)
   ```

4. 创建 OSD 。请注意，如果需要重用以前销毁的 OSD ID ，可以将 OSD ID 作为 `ceph osd new` 的附加参数提供。假设计算机上存在 `client.bootstrap-osd` 密钥。也可以在存在该密钥的其他主机上以 `client.admin` 的身份执行此命令。

   ```bash
   ID=$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" | \
      ceph osd new $UUID -i - \
      -n client.bootstrap-osd -k /var/lib/ceph/bootstrap-osd/ceph.keyring)
   ```

   也可以在 JSON 中包含 `crush_device_class` 属性，以设置默认值以外的初始类（基于自动检测的设备类型的 `ssd` 或 `hdd` ）。

5. 在新 OSD 上创建默认目录。

   ```bash
   mkdir /var/lib/ceph/osd/ceph-$ID
   ```

6. 如果 OSD 用于操作系统驱动器以外的驱动器，请准备它与 Ceph 一起使用，并将其挂载到刚刚创建的目录。

   ```bash
   mkfs.xfs /dev/{DEV}
   mount /dev/{DEV} /var/lib/ceph/osd/ceph-$ID
   ```

7. 将密码写入 OSD 密钥环文件。

   ```bash
   ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring \
        --name osd.$ID --add-key $OSD_SECRET
   ```

8. 初始化 OSD 数据目录。

   ```bash
   ceph-osd -i $ID --mkfs --osd-uuid $UUID
   ```

9. 修复所有权。

   ```bash
   chown -R ceph:ceph /var/lib/ceph/osd/ceph-$ID
   ```

10. 将 OSD 添加到 Ceph 后，OSD 就在您的配置中了。然而，它还没有运行。必须先启动新 OSD ，然后它才能开始接收数据。

    ```bash
    systemctl enable ceph-osd@$ID
    systemctl start ceph-osd@$ID
    ```

    For example:

    ```bash
    systemctl enable ceph-osd@12
    systemctl start ceph-osd@12
    ```

### 添加 MDS

在下面的说明中，`{id}` 是一个任意名称，例如计算机的主机名。

1. 创建 mds 数据目录：

   ```bash
   mkdir -p /var/lib/ceph/mds/{cluster-name}-{id}
   ```

2. 创建密钥环：

   ```bash
   ceph-authtool --create-keyring /var/lib/ceph/mds/{cluster-name}-{id}/keyring --gen-key -n mds.{id}
   ```

3. Import the keyring and set caps:导入密钥环并设置帽：

   ```bash
   ceph auth add mds.{id} osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/{cluster}-{id}/keyring
   ```

4. 添加到 ceph.conf ：

   ```ini
   [mds.{id}]
   host = {id}
   ```

5. 以手动方式启动守护进程：

   ```bash
   ceph-mds --cluster {cluster-name} -i {id} -m {mon-hostname}:{mon-port} [-f]
   ```

6. 以正确的方式启动守护进程（使用 ceph.conf 条目）：

   ```bash
   service ceph start
   ```

7. 如果启动守护程序失败并出现以下错误：

   ```bash
   mds.-1.0 ERROR: failed to authenticate: (22) Invalid argument
   ```

   Then make sure you do not have a keyring set in ceph.conf in the  global section; move it to the client section; or add a keyring setting  specific to this mds daemon. And verify that you see the same key in the mds data directory and `ceph auth get mds.{id}` output.

   然后确保没有在 global 部分的 ceph.conf 中设置 keyring ;将其移动到 client 部分;或者添加特定于此 mds 守护进程的 keyring 设置。并验证在 mds 数据目录中和 `ceph auth get mds.{id}`  输出中看到相同的密钥。

8. 现在，已经准备好创建 Ceph 文件系统。

### 总结

一旦启动并运行了 MON 和两个 OSD ，就可以通过执行以下操作来监视放置组对等：

```bash
ceph -w
```

要查看树，请执行以下操作：

```bash
ceph osd tree
```

您应该会看到如下所示的输出：

```bash
# id    weight  type name              up/down  reweight
-1      2       root default
-2      2               host node1
0       1                       osd.0   up       1
-3      1               host node2
1       1                       osd.1   up       1
```

