# Manual

[TOC]

## 获取软件

详见 **获取软件包.md**

## 安装软件

要在集群中的每个Ceph节点上安装包。如果要安装 Ceph 对象网关或 QEMU，则应为 RHEL/CentOS 和其他使用 Yum 的发行版安装 Yum Priorities 。

### APT

```bash
sudo apt-get update
sudo apt-get install ceph
```

### RPM

1. 安装 `yum-plugin-priorities`.

   ```bash
   yum install yum-plugin-priorities
   ```

2. 确保 `/etc/yum/pluginconf.d/priorities.conf` 文件存在。

3. Ensure `priorities.conf` enables the plugin.

   ```bash
   [main]
   enabled = 1
   ```

4. Ensure your YUM `ceph.repo` entry includes `priority=2`. 

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
   yum install snappy leveldb gdisk python-argparse gperftools-libs
   ```

6. Once you have added either release or development packages, or added a `ceph.repo` file to `/etc/yum.repos.d`, you can install Ceph packages.

   ```bash
   yum install ceph
   ```

### Installing a Build

如果你从源代码构建 Ceph，你可以通过执行以下命令在用户空间安装 Ceph：

```bash
sudo ninja install
```

如果在本地安装 Ceph，`ninja` 会将可执行文件放在 `usr/local/bin`中。可以将 Ceph 配置文件添加到`usr/local/bin` 目录以从单个目录运行 Ceph。

## Install Virtualization for Block Device

the QEMU/KVM and `libvirt` packages are important for enabling VMs and cloud platforms. Examples of VMs include: QEMU/KVM, XEN, VMWare, LXC, VirtualBox, etc. Examples of Cloud Platforms include OpenStack, CloudStack, OpenNebula, etc.

如果打算使用 Ceph 块设备和 Ceph 存储集群作为虚拟机 (VM) 或云平台的后端，QEMU/KVM 和 `libvirt` 包对于启用  VM 和云平台非常重要。VM 的示例包括：QEMU/KVM、XEN、VMWare、LXC、VirtualBox 等。云平台的示例包括  OpenStack、CloudStack、OpenNebula 等。

![](../../../../Image/c/ceph_vm.png)

### 安装 QEMU

QEMU KVM 可以通过 `librbd`  与 Ceph 块设备交互, 这是在云平台上使用 Ceph 的一个重要特性。

#### Debian Packages

QEMU 软件包已合并到 Ubuntu 12.04 Precise Pangolin 及更高版本中。

```bash
sudo apt-get install qemu
```

#### RPM Packages

```bash
yum update
yum install qemu-kvm qemu-kvm-tools qemu-img
# optional
yum install qemu-guest-agent qemu-guest-agent-win32
```

#### 编译 QEMU

```bash
cd {your-development-directory}
git clone git://git.qemu.org/qemu.git
cd qemu
./configure --enable-rbd
make; make install
```

### 安装 libvirt

要将 libvirt 与 Ceph 一起使用，必须有一个正在运行的 Ceph 存储集群，并且必须已经安装并配置了 QEMU。

#### Debian Packages

`libvirt` 软件包已合并到 Ubuntu 12.04 Precise Pangolin 和更高版本的 Ubuntu 中。

```bash
sudo apt-get update
sudo apt-get install libvirt-bin
```

#### RPM Packages

`libvirt` 软件包已合并到最近的 CentOS/RHEL 发行版中。

```bash
yum install libvirt
```

#### 编译 `libvirt`

To build `libvirt` from source, clone the `libvirt` repository and use [AutoGen](http://www.gnu.org/software/autogen/) to generate the build. Then, execute `make` and `make install` to complete the installation. 

```bash
git clone git://libvirt.org/libvirt.git
cd libvirt
./autogen.sh
make
sudo make install
```

## 部署集群

### MON 引导

引导 MON（理论上是一个Ceph存储集群）需要做很多事情：

- **唯一标识符** 

  fsid是集群的唯一标识符, and stands for File System ID from the days when the Ceph Storage Cluster was principally for the Ceph File System. fsid 是集群的唯一标识符，代表 Ceph 存储集群主要用于 Ceph 文件系统时的文件系统 ID。 Ceph 现在也支持原生接口、块设备和对象存储网关接口，所以 fsid 有点用词不当。

- **集群名称**

  Ceph集群有一个集群名称，是一个没有空格的简单字符串。默认集群名称是 `ceph` ，但可以指定不同的集群名称。Overriding the default cluster name is especially useful when you are working with multiple clusters and you need to clearly understand which cluster your are working with.当您使用多个集群并且需要清楚地了解使用哪个集群时，重写默认集群名称特别有用。

  For example, when you run multiple clusters in a [multisite configuration](https://docs.ceph.com/en/latest/radosgw/multisite/#multisite), the cluster name (e.g., `us-west`, `us-east`) identifies the cluster for the current CLI session. **Note:** To identify the cluster name on the command line interface, specify the Ceph configuration file with the cluster name (e.g., `ceph.conf`, `us-west.conf`, `us-east.conf`, etc.). Also see CLI usage (`ceph --cluster {cluster-name}`).

  例如，在多站点配置中运行多个群集时，群集名称（例如，us west、us  east）标识当前CLI会话的群集。注意：要在命令行界面上标识集群名称，请使用集群名称指定Ceph配置文件（例如。，ceph.conf公司，美国-西.conf，美国-东.conf等）。另请参见CLI用法（ceph--cluster{cluster name}）。

- **MON 名称**

  集群中的每个 MON 实例都有一个唯一的名称。In common practice, the Ceph Monitor name is the host name (we recommend one Ceph Monitor per host, and no commingling of Ceph OSD Daemons with Ceph Monitors). You may retrieve the short hostname with `hostname -s` 。

  通常情况下，Ceph Monitor name是主机名（我们建议每个主机使用一个Ceph Monitor，并且不要将Ceph OSD守护进程与Ceph  Monitor混合使用）。您可以使用hostname-s检索短主机名。

- **Monitor Map**

  Bootstrapping the initial monitor(s) requires you to generate a monitor map. The monitor map requires the `fsid`, the cluster name (or uses the default), and at least one host name and its IP address

  引导初始监视器需要生成监视器映射。监视器映射需要fsid、集群名称（或使用默认名称）以及至少一个主机名及其IP地址。

- **Monitor Keyring**

  Monitors communicate with each other via a secret key. You must generate a keyring with a monitor secret and provide it when bootstrapping the initial monitor(s).监视器密钥环：监视器通过密钥相互通信。您必须生成一个带有监视器机密的密钥环，并在引导初始监视器时提供它。

- **Administrator Keyring**

  To use the `ceph` CLI tools, you must have a `client.admin` user. So you must generate the admin user and keyring, and you must also add the `client.admin` user to the monitor keyring.Administrator Keyring：要使用ceph CLI工具，必须具有客户端管理用户。因此，必须生成admin用户和keyring，还必须添加客户端管理用户到监视器密钥环

You can get and set all of the monitor settings at runtime as well. However, a Ceph Configuration file may contain only those settings that override the default values. When you add settings to a Ceph configuration file, these settings override the default settings. Maintaining those settings in a Ceph configuration file makes it easier to maintain your cluster.您也可以在运行时获取和设置所有监视器设置。但是，Ceph配置文件可能只包含那些覆盖默认值的设置。向Ceph配置文件添加设置时，这些设置将覆盖默认设置。在Ceph配置文件中维护这些设置可以更容易地维护集群。

The procedure is as follows:

1. 登录到初始监控节点：

   ```bash
   ssh {hostname}
   ```

2. 确认有一个目录存放 Ceph 配置文件。默认情况下， Ceph 使用 `/etc/ceph` 。当安装 `ceph` ，安装程序会自动创建该目录。

   ```bash
   ls /etc/ceph
   ```

3. 创建 Ceph 配置文件。默认情况下，Ceph 使用 ceph.conf，其中 ceph 反映集群名称。在配置文件中添加一行包含“[global]”。

   ```bash
   vim /etc/ceph/ceph.conf
   ```

4. 为集群生成唯一 ID（即 fsid）。

   ```bash
   uuidgen
   ```

5. Add the unique ID to your Ceph configuration file.

   ```bash
   fsid = {UUID}
   ```

   For example:

   ```bash
   fsid = a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

6. Add the initial monitor(s) to your Ceph configuration file.

   ```bash
   mon initial members = {hostname}[,{hostname}]
   ```

   For example:

   ```bash
   mon initial members = node1
   ```

7. Add the IP address(es) of the initial monitor(s) to your Ceph configuration file and save the file.

   ```bash
   mon host = {ip-address}[,{ip-address}]
   ```

   For example:

   ```bash
   mon host = 192.168.0.1
   ```

   **Note:** You may use IPv6 addresses instead of IPv4 addresses, but you must set `ms bind ipv6` to `true`. 

8. 为集群创建一个密钥环，并生成一个 monitor 密钥。

   ```bash
   ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
   ```

9. 生成管理员密钥环，生成 client.admin 用户并将用户添加到密钥环。

   ```bash
   ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
   ```

10. 生成 bootstrap-osd 密钥环，生成 client.bootstrap-osd 用户并将用户添加到密钥环。

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

13. 使用 hostname 、host IP address 和 FSID，生成一个 monitor map ，保存到 `/tmp/monmap`:

    ```bash
    monmaptool --create --add {hostname} {ip-address} --fsid {uuid} /tmp/monmap
    ```

    For example:

    ```
    monmaptool --create --add node1 192.168.0.1 --fsid a7f64266-0894-4f1e-a635-d0aeaca0e993 /tmp/monmap
    ```

14. Create a default data directory (or directories) on the monitor host(s).

    ```
    mkdir /var/lib/ceph/mon/{cluster-name}-{hostname}
    ```

    For example:

    ```bash
    mkdir /var/lib/ceph/mon/ceph-node1
    ```

15. Populate the monitor daemon(s) with the monitor map and keyring.

    ```bash
    sudo -u ceph ceph-mon [--cluster {cluster-name}] --mkfs -i {hostname} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

    For example:

    ```bash
    sudo -u ceph ceph-mon --mkfs -i node1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

16. Ceph configuration file 通常包含如下设置：

    ```ini
    [global]
    fsid = {cluster-id}
    mon initial members = {hostname}[, {hostname}]
    mon host = {ip-address}[, {ip-address}]
    public network = {network}[, {network}]
    cluster network = {network}[, {network}]
    auth cluster required = cephx
    auth service required = cephx
    auth client required = cephx
    osd journal size = {n}
    osd pool default size = {n}     # Write an object n times.
    osd pool default min size = {n} # Allow writing n copies in a degraded state.
    osd pool default pg num = {n}
    osd pool default pgp num = {n}
    osd crush chooseleaf type = {n}
    ```

    In the foregoing example, the `[global]` section of the configuration might look like this:

    ```ini
    [global]
    fsid = a7f64266-0894-4f1e-a635-d0aeaca0e993
    mon initial members = node1
    mon host = 192.168.0.1
    public network = 192.168.0.0/24
    auth cluster required = cephx
    auth service required = cephx
    auth client required = cephx
    osd journal size = 1024
    osd pool default size = 3
    osd pool default min size = 2
    osd pool default pg num = 333
    osd pool default pgp num = 333
    osd crush chooseleaf type = 1
    ```

17. 启动 MON 服务。

    ```bash
    systemctl start ceph-mon@node1
    ```
    
18. 确认 MON 运行状态。

    ```bash
    sudo ceph -s
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

    **Note:** Once you add OSDs and start them, the placement group health errors should disappear.

### Manager 配置

在运行 MON 的每个节点上，还应该设置一个 MGR 。

### 添加 OSD

After bootstrapping your monitor, your cluster has a default CRUSH map; however, the CRUSH map doesn’t have any Ceph OSD Daemons mapped to a Ceph Node.一旦初始 MON 运行，应该添加 OSD。除非您有足够的 OSD 来处理对象的副本数量（例如，osd pool default size = 2 需要至少两个 OSD），否则集群无法达到 active + clean 状态。在引导 MON 之后，集群有一个默认的 CRUSH map ；然而，CRUSH map 没有任何映射到 Ceph 节点的 Ceph OSD 。

#### Short Form

Ceph 提供了 ceph-volume 实用程序，它可以准备逻辑卷、磁盘或分区以供 Ceph 使用。 ceph-volume  实用程序通过增加索引来创建 OSD ID。另外，ceph-volume 会将新的 OSD 添加到主机下的 CRUSH map 中。执行  `ceph-volume -h` 以获取 CLI 详细信息。 ceph-volume 实用程序自动执行下面长格式的步骤。要使用短格式程序创建前两个 OSD，对每个 OSD 执行以下操作：

##### bluestore

创建 OSD 。

```bash
# copy /var/lib/ceph/bootstrap-osd/ceph.keyring from monitor node (mon-node1) to /var/lib/ceph/bootstrap-osd/ceph.keyring on osd node (osd-node1)
ssh {osd node}
ceph-volume lvm create --data {data-path}
```

For example:

```bash
scp -3 root@mon-node1:/var/lib/ceph/bootstrap-osd/ceph.keyring root@osd-node1:/var/lib/ceph/bootstrap-osd/ceph.keyring
ssh osd-node1
ceph-volume lvm create --data /dev/hdd1
```

或者，创建过程可以分为两个阶段（准备和激活）：

1. Prepare the OSD.

   ```bash
   ssh {node-name}
   ceph-volume lvm prepare --data {data-path} {data-path}
   ```

   For example:

   ```bash
   ssh node1
   ceph-volume lvm prepare --data /dev/hdd1
   ```

   准备好后，激活需要 OSD 的 ID 和 FSID。可以通过列出当前服务器中的 OSD 来获得：

   ```bash
   ceph-volume lvm list
   ```

2. Activate the OSD:

   ```bash
   ceph-volume lvm activate {ID} {FSID}
   ```

   For example:

   ```bash
   ceph-volume lvm activate 0 a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

##### filestore

Create the OSD.

```bash
ssh {node-name}
ceph-volume lvm create --filestore --data {data-path} --journal {journal-path}
```

For example:

```bash
ssh node1
sudo ceph-volume lvm create --filestore --data /dev/hdd1 --journal /dev/hdd2
```

或者，创建过程可以分为两个阶段（准备和激活）：

1. Prepare the OSD.

   ```bash
   ssh {node-name}
   ceph-volume lvm prepare --filestore --data {data-path} --journal {journal-path}
   ```

   For example:

   ```bash
   ssh node1
   ceph-volume lvm prepare --filestore --data /dev/hdd1 --journal /dev/hdd2
   ```

   Once prepared, the `ID` and `FSID` of the prepared OSD are required for activation. These can be obtained by listing OSDs in the current server:

   ```bash
   ceph-volume lvm list
   ```

2. Activate the OSD:

   ```bash
   ceph-volume lvm activate --filestore {ID} {FSID}
   ```

   For example:

   ```bash
   ceph-volume lvm activate --filestore 0 a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

#### Long Form

在没有任何帮助实用程序的情况下，创建一个 OSD 并将其添加到集群和 CRUSH 映射中，步骤如下。要使用长格式程序创建前两个 OSD，请为每个 OSD 执行以下步骤。

> Note
>
> This procedure does not describe deployment on top of dm-crypt making use of the dm-crypt ‘lockbox’.此过程不描述使用 dm-crypt “密码箱”在 dm-crypt 之上的部署。

1. Connect to the OSD host and become root.

   ```bash
   ssh {node-name}
   sudo bash
   ```

2. Generate a UUID for the OSD.

   ```bash
   UUID=$(uuidgen)
   ```

3. Generate a cephx key for the OSD.

   ```bash
   OSD_SECRET=$(ceph-authtool --gen-print-key)
   ```

4. Create the OSD. Note that an OSD ID can be provided as an additional argument to `ceph osd new` if you need to reuse a previously-destroyed OSD id. We assume that the `client.bootstrap-osd` key is present on the machine.  You may alternatively execute this command as `client.admin` on a different host where that key is present.:

   ```bash
   ID=$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" | \
      ceph osd new $UUID -i - \
      -n client.bootstrap-osd -k /var/lib/ceph/bootstrap-osd/ceph.keyring)
   ```

   It is also possible to include a `crush_device_class` property in the JSON to set an initial class other than the default (`ssd` or `hdd` based on the auto-detected device type).

5. Create the default directory on your new OSD.

   ```bash
   mkdir /var/lib/ceph/osd/ceph-$ID
   ```

6. If the OSD is for a drive other than the OS drive, prepare it for use with Ceph, and mount it to the directory you just created.

   ```bash
   mkfs.xfs /dev/{DEV}
   mount /dev/{DEV} /var/lib/ceph/osd/ceph-$ID
   ```

7. Write the secret to the OSD keyring file.

   ```bash
   ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring \
        --name osd.$ID --add-key $OSD_SECRET
   ```

8. Initialize the OSD data directory.

   ```bash
   ceph-osd -i $ID --mkfs --osd-uuid $UUID
   ```

9. Fix ownership.

   ```bash
   chown -R ceph:ceph /var/lib/ceph/osd/ceph-$ID
   ```

10. After you add an OSD to Ceph, the OSD is in your configuration. However, it is not yet running. You must start your new OSD before it can begin receiving data.

    For modern systemd distributions:

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

In the below instructions, `{id}` is an arbitrary name, such as the hostname of the machine.

1. Create the mds data directory.:

   ```bash
   mkdir -p /var/lib/ceph/mds/{cluster-name}-{id}
   ```

2. Create a keyring.:

   ```bash
   ceph-authtool --create-keyring /var/lib/ceph/mds/{cluster-name}-{id}/keyring --gen-key -n mds.{id}
   ```

3. Import the keyring and set caps.:

   ```bash
   ceph auth add mds.{id} osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/{cluster}-{id}/keyring
   ```

4. Add to ceph.conf.:

   ```ini
   [mds.{id}]
   host = {id}
   ```

5. Start the daemon the manual way.:

   ```bash
   ceph-mds --cluster {cluster-name} -i {id} -m {mon-hostname}:{mon-port} [-f]
   ```

6. Start the daemon the right way (using ceph.conf entry).:

   ```bash
   service ceph start
   ```

7. If starting the daemon fails with this error:

   ```bash
   mds.-1.0 ERROR: failed to authenticate: (22) Invalid argument
   ```

   Then make sure you do not have a keyring set in ceph.conf in the  global section; move it to the client section; or add a keyring setting  specific to this mds daemon. And verify that you see the same key in the mds data directory and `ceph auth get mds.{id}` output.

8. Now you are ready to [create a Ceph file system](https://docs.ceph.com/en/latest/cephfs/createfs).

### Summary

Once you have your monitor and two OSDs up and running, you can watch the placement groups peer by executing the following:

```bash
ceph -w
```

To view the tree, execute the following:

```bash
ceph osd tree
```

You should see output that looks something like this:

```bash
# id    weight  type name       up/down reweight
-1      2       root default
-2      2               host node1
0       1                       osd.0   up      1
-3      1               host node2
1       1                       osd.1   up      1
```

