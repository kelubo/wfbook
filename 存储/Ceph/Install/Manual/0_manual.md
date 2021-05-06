# Manual

[TOC]

## 获取软件

详见 **获取软件包.md**

## 安装软件

To install packages on each [Ceph Node](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Node) in your cluster, use package management tools. You should install Yum Priorities for RHEL/CentOS and other distributions that use Yum if you intend to install the Ceph Object Gateway or QEMU.要在集群中的每个Ceph节点上安装包，请使用包管理工具。如果要安装Ceph对象网关或QEMU，则应为RHEL/Cent OS和其他使用Yum的发行版安装Yum Priorities。

### APT

```bash
sudo apt-get update
sudo apt-get install ceph
```

### RPM

1. Install `yum-plugin-priorities`.

   ```bash
   yum install yum-plugin-priorities
   ```

2. Ensure `/etc/yum/pluginconf.d/priorities.conf` exists.

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

5. Install pre-requisite packages:
   ```bash
   yum install snappy leveldb gdisk python-argparse gperftools-libs
   ```

6. Once you have added either release or development packages, or added a `ceph.repo` file to `/etc/yum.repos.d`, you can install Ceph packages.

   ```bash
   yum install ceph
   # 貌似上面步骤有问题，按照下方进行
   yum install epel-release
   yum install http://mirrors.ustc.edu.cn/ceph/rpm-octopus/el8/noarch/ceph-release-1-1.el8.noarch.rpm
   yum install ceph
   ```

### Installing a Build

If you build Ceph from source code, you may install Ceph in user space by executing the following:

```bash
sudo ninja install
```

If you install Ceph locally, `ninja` will place the executables in `usr/local/bin`. You may add the Ceph configuration file to the `usr/local/bin` directory to run Ceph from a single directory.

## Install Virtualization for Block Device

If you intend to use Ceph Block Devices and the Ceph Storage Cluster as a backend for Virtual Machines (VMs) or  [Cloud Platforms](https://docs.ceph.com/en/latest/glossary/#term-Cloud-Platforms) the QEMU/KVM and `libvirt` packages are important for enabling VMs and cloud platforms. Examples of VMs include: QEMU/KVM, XEN, VMWare, LXC, VirtualBox, etc. Examples of Cloud Platforms include OpenStack, CloudStack, OpenNebula, etc.

![../../_images/695c571bee8be98d46d62725013224a2902df18dc52481d7b7572c4a8a91119d.png](https://docs.ceph.com/en/latest/_images/695c571bee8be98d46d62725013224a2902df18dc52481d7b7572c4a8a91119d.png)

### Install QEMU

QEMU KVM can interact with Ceph Block Devices via `librbd`, which is an important feature for using Ceph with cloud platforms. Once you install QEMU, see [QEMU and Block Devices](https://docs.ceph.com/en/latest/rbd/qemu-rbd) for usage.

#### Debian Packages

QEMU packages are incorporated into Ubuntu 12.04 Precise Pangolin and later versions. To  install QEMU, execute the following:

```
sudo apt-get install qemu
```

#### RPM Packages

To install QEMU, execute the following:

1. Update your repositories.

   ```
   sudo yum update
   ```

2. Install QEMU for Ceph.

   ```
   sudo yum install qemu-kvm qemu-kvm-tools qemu-img
   ```

3. Install additional QEMU packages (optional):

   ```
   sudo yum install qemu-guest-agent qemu-guest-agent-win32
   ```

#### Building QEMU

To build QEMU from source, use the following procedure:

```
cd {your-development-directory}
git clone git://git.qemu.org/qemu.git
cd qemu
./configure --enable-rbd
make; make install
```

### Install libvirt

To use `libvirt` with Ceph, you must have a running Ceph Storage Cluster, and you must have installed and configured QEMU. See [Using libvirt with Ceph Block Device](https://docs.ceph.com/en/latest/rbd/libvirt) for usage.

#### Debian Packages

`libvirt` packages are incorporated into Ubuntu 12.04 Precise Pangolin and later versions of Ubuntu. To install `libvirt` on these distributions, execute the following:

```
sudo apt-get update && sudo apt-get install libvirt-bin
```

#### RPM Packages

To use `libvirt` with a Ceph Storage Cluster, you must  have a running Ceph Storage Cluster and you must also install a version of QEMU with `rbd` format support.  See [Install QEMU](https://docs.ceph.com/en/latest/install/install-vm-cloud/#install-qemu) for details.

`libvirt` packages are incorporated into the recent CentOS/RHEL distributions. To install `libvirt`, execute the following:

```
sudo yum install libvirt
```

#### Building `libvirt`

To build `libvirt` from source, clone the `libvirt` repository and use [AutoGen](http://www.gnu.org/software/autogen/) to generate the build. Then, execute `make` and `make install` to complete the installation. For example:

```
git clone git://libvirt.org/libvirt.git
cd libvirt
./autogen.sh
make
sudo make install
```

See [libvirt Installation](http://www.libvirt.org/compiling.html) for details.

## 部署集群

### MON 引导

引导 MON（理论上是一个Ceph存储集群）需要做很多事情：

- **唯一标识符:** fsid是集群的唯一标识符, and stands for File System ID from the days when the Ceph Storage Cluster was principally for the Ceph File System. Ceph now supports native interfaces, block devices, and object storage gateway interfaces too, so `fsid` is a bit of a misnomer.

  代表Ceph存储集群主要用于Ceph文件系统时的文件系统ID。Ceph现在也支持本机接口、块设备和对象存储网关接口，因此fsid有点用词不当。

- **集群名称:** Ceph集群有一个集群名称，是一个没有空格的简单字符串。默认集群名称是 `ceph` ，但可以指定不同的集群名称。Overriding the default cluster name is especially useful when you are working with multiple clusters and you need to clearly understand which cluster your are working with.当您使用多个集群并且需要清楚地了解使用哪个集群时，重写默认集群名称特别有用。

  For example, when you run multiple clusters in a [multisite configuration](https://docs.ceph.com/en/latest/radosgw/multisite/#multisite), the cluster name (e.g., `us-west`, `us-east`) identifies the cluster for the current CLI session. **Note:** To identify the cluster name on the command line interface, specify the Ceph configuration file with the cluster name (e.g., `ceph.conf`, `us-west.conf`, `us-east.conf`, etc.). Also see CLI usage (`ceph --cluster {cluster-name}`).

  例如，在多站点配置中运行多个群集时，群集名称（例如，us west、us  east）标识当前CLI会话的群集。注意：要在命令行界面上标识集群名称，请使用集群名称指定Ceph配置文件（例如。，ceph.conf公司，美国-西.conf，美国-东.conf等）。另请参见CLI用法（ceph--cluster{cluster name}）。

- **MON 名称:** 集群中的每个 MON 实例都有一个唯一的名称。In common practice, the Ceph Monitor name is the host name (we recommend one Ceph Monitor per host, and no commingling of Ceph OSD Daemons with Ceph Monitors). You may retrieve the short hostname with `hostname -s` 。

  通常情况下，Ceph Monitor name是主机名（我们建议每个主机使用一个Ceph Monitor，并且不要将Ceph OSD守护进程与Ceph  Monitor混合使用）。您可以使用hostname-s检索短主机名。

- **Monitor Map:** Bootstrapping the initial monitor(s) requires you to generate a monitor map. The monitor map requires the `fsid`, the cluster name (or uses the default), and at least one host name and its IP address

  引导初始监视器需要生成监视器映射。监视器映射需要fsid、集群名称（或使用默认名称）以及至少一个主机名及其IP地址。

- **Monitor Keyring**: Monitors communicate with each other via a secret key. You must generate a keyring with a monitor secret and provide it when bootstrapping the initial monitor(s).监视器密钥环：监视器通过密钥相互通信。您必须生成一个带有监视器机密的密钥环，并在引导初始监视器时提供它。

- **Administrator Keyring**: To use the `ceph` CLI tools, you must have a `client.admin` user. So you must generate the admin user and keyring, and you must also add the `client.admin` user to the monitor keyring.Administrator Keyring：要使用ceph CLI工具，必须具有客户端管理用户。因此，必须生成admin用户和keyring，还必须添加客户端管理用户到监视器密钥环

You can get and set all of the monitor settings at runtime as well. However, a Ceph Configuration file may contain only those settings that override the default values. When you add settings to a Ceph configuration file, these settings override the default settings. Maintaining those settings in a Ceph configuration file makes it easier to maintain your cluster.您也可以在运行时获取和设置所有监视器设置。但是，Ceph配置文件可能只包含那些覆盖默认值的设置。向Ceph配置文件添加设置时，这些设置将覆盖默认设置。在Ceph配置文件中维护这些设置可以更容易地维护集群。

The procedure is as follows:

1. Log in to the initial monitor node(s):

   ```
   ssh {hostname}
   ```

   For example:

   ```
   ssh node1
   ```

2. Ensure you have a directory for the Ceph configuration file. By default, Ceph uses `/etc/ceph`. When you install `ceph`, the installer will create the `/etc/ceph` directory automatically.

   ```
   ls /etc/ceph
   ```

3. Create a Ceph configuration file. By default, Ceph uses `ceph.conf`, where `ceph` reflects the cluster name.

   ```
   sudo vim /etc/ceph/ceph.conf
   ```

4. Generate a unique ID (i.e., `fsid`) for your cluster.

   ```
   uuidgen
   ```

5. Add the unique ID to your Ceph configuration file.

   ```
   fsid = {UUID}
   ```

   For example:

   ```
   fsid = a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

6. Add the initial monitor(s) to your Ceph configuration file.

   ```
   mon initial members = {hostname}[,{hostname}]
   ```

   For example:

   ```
   mon initial members = node1
   ```

7. Add the IP address(es) of the initial monitor(s) to your Ceph configuration file and save the file.

   ```
   mon host = {ip-address}[,{ip-address}]
   ```

   For example:

   ```
   mon host = 192.168.0.1
   ```

   **Note:** You may use IPv6 addresses instead of IPv4 addresses, but you must set `ms bind ipv6` to `true`. See [Network Configuration Reference](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref) for details about network configuration.

8. Create a keyring for your cluster and generate a monitor secret key.

   ```bash
   sudo ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
   ```

9. Generate an administrator keyring, generate a `client.admin` user and add the user to the keyring.

   ```bash
   sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
   ```

10. Generate a bootstrap-osd keyring, generate a `client.bootstrap-osd` user and add the user to the keyring.

    ```bash
    sudo ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
    ```

11. Add the generated keys to the `ceph.mon.keyring`.

    ```bash
    sudo ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
    sudo ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
    ```

12. Change the owner for `ceph.mon.keyring`.

    ```
    sudo chown ceph:ceph /tmp/ceph.mon.keyring
    ```

13. Generate a monitor map using the hostname(s), host IP address(es) and the FSID. Save it as `/tmp/monmap`:

    ```
    monmaptool --create --add {hostname} {ip-address} --fsid {uuid} /tmp/monmap
    ```

    For example:

    ```
    monmaptool --create --add node1 192.168.0.1 --fsid a7f64266-0894-4f1e-a635-d0aeaca0e993 /tmp/monmap
    ```

14. Create a default data directory (or directories) on the monitor host(s).

    ```
    sudo mkdir /var/lib/ceph/mon/{cluster-name}-{hostname}
    ```

    For example:

    ```bash
    sudo -u ceph mkdir /var/lib/ceph/mon/ceph-node1
    ```

15. Populate the monitor daemon(s) with the monitor map and keyring.

    ```
    sudo -u ceph ceph-mon [--cluster {cluster-name}] --mkfs -i {hostname} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

    For example:

    ```
    sudo -u ceph ceph-mon --mkfs -i node1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

16. Consider settings for a Ceph configuration file. Common settings include the following:

    ```bash
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
    osd pool default size = {n}  # Write an object n times.
    osd pool default min size = {n} # Allow writing n copies in a degraded state.
    osd pool default pg num = {n}
    osd pool default pgp num = {n}
    osd crush chooseleaf type = {n}
    ```

    In the foregoing example, the `[global]` section of the configuration might look like this:

    ```bash
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

17. Start the monitor(s).

    Start the service with systemd:

    ```
    sudo systemctl start ceph-mon@node1
    ```

18. Verify that the monitor is running.

    ```
    sudo ceph -s
    ```

    You should see output that the monitor you started is up and running, and you should see a health error indicating that placement groups are stuck inactive. It should look something like this:

    ```
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

    **Note:** Once you add OSDs and start them, the placement group health errors should disappear. See [Adding OSDs](https://docs.ceph.com/en/latest/install/manual-deployment/#adding-osds) for details.

### Manager daemon configuration

On each node where you run a ceph-mon daemon, you should also set up a ceph-mgr daemon.

See [ceph-mgr administrator’s guide](https://docs.ceph.com/en/latest/mgr/administrator/#mgr-administrator-guide)

### Adding OSDs

Once you have your initial monitor(s) running, you should add OSDs. Your cluster cannot reach an `active + clean` state until you have enough OSDs to handle the number of copies of an object (e.g., `osd pool default size = 2` requires at least two OSDs). After bootstrapping your monitor, your cluster has a default CRUSH map; however, the CRUSH map doesn’t have any Ceph OSD Daemons mapped to a Ceph Node.

### Short Form

Ceph provides the `ceph-volume` utility, which can prepare a logical volume, disk, or partition for use with Ceph. The `ceph-volume` utility creates the OSD ID by incrementing the index. Additionally, `ceph-volume` will add the new OSD to the CRUSH map under the host for you. Execute `ceph-volume -h` for CLI details. The `ceph-volume` utility automates the steps of the [Long Form](https://docs.ceph.com/en/latest/install/manual-deployment/#long-form) below. To create the first two OSDs with the short form procedure, execute the following on  `node2` and `node3`:

#### bluestore

1. Create the OSD.

   ```
   ssh {node-name}
   sudo ceph-volume lvm create --data {data-path}
   ```

   For example:

   ```
   ssh node1
   sudo ceph-volume lvm create --data /dev/hdd1
   ```

Alternatively, the creation process can be split in two phases (prepare, and activate):

1. Prepare the OSD.

   ```
   ssh {node-name}
   sudo ceph-volume lvm prepare --data {data-path} {data-path}
   ```

   For example:

   ```
   ssh node1
   sudo ceph-volume lvm prepare --data /dev/hdd1
   ```

   Once prepared, the `ID` and `FSID` of the prepared OSD are required for activation. These can be obtained by listing OSDs in the current server:

   ```
   sudo ceph-volume lvm list
   ```

2. Activate the OSD:

   ```
   sudo ceph-volume lvm activate {ID} {FSID}
   ```

   For example:

   ```
   sudo ceph-volume lvm activate 0 a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

#### filestore

1. Create the OSD.

   ```
   ssh {node-name}
   sudo ceph-volume lvm create --filestore --data {data-path} --journal {journal-path}
   ```

   For example:

   ```
   ssh node1
   sudo ceph-volume lvm create --filestore --data /dev/hdd1 --journal /dev/hdd2
   ```

Alternatively, the creation process can be split in two phases (prepare, and activate):

1. Prepare the OSD.

   ```
   ssh {node-name}
   sudo ceph-volume lvm prepare --filestore --data {data-path} --journal {journal-path}
   ```

   For example:

   ```
   ssh node1
   sudo ceph-volume lvm prepare --filestore --data /dev/hdd1 --journal /dev/hdd2
   ```

   Once prepared, the `ID` and `FSID` of the prepared OSD are required for activation. These can be obtained by listing OSDs in the current server:

   ```
   sudo ceph-volume lvm list
   ```

2. Activate the OSD:

   ```
   sudo ceph-volume lvm activate --filestore {ID} {FSID}
   ```

   For example:

   ```
   sudo ceph-volume lvm activate --filestore 0 a7f64266-0894-4f1e-a635-d0aeaca0e993
   ```

### Long Form

Without the benefit of any helper utilities, create an OSD and add it to the cluster and CRUSH map with the following procedure. To create the first two OSDs with the long form procedure, execute the following steps for each OSD.

Note

This procedure does not describe deployment on top of dm-crypt making use of the dm-crypt ‘lockbox’.

1. Connect to the OSD host and become root.

   ```
   ssh {node-name}
   sudo bash
   ```

2. Generate a UUID for the OSD.

   ```
   UUID=$(uuidgen)
   ```

3. Generate a cephx key for the OSD.

   ```
   OSD_SECRET=$(ceph-authtool --gen-print-key)
   ```

4. Create the OSD. Note that an OSD ID can be provided as an additional argument to `ceph osd new` if you need to reuse a previously-destroyed OSD id. We assume that the `client.bootstrap-osd` key is present on the machine.  You may alternatively execute this command as `client.admin` on a different host where that key is present.:

   ```
   ID=$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" | \
      ceph osd new $UUID -i - \
      -n client.bootstrap-osd -k /var/lib/ceph/bootstrap-osd/ceph.keyring)
   ```

   It is also possible to include a `crush_device_class` property in the JSON to set an initial class other than the default (`ssd` or `hdd` based on the auto-detected device type).

5. Create the default directory on your new OSD.

   ```
   mkdir /var/lib/ceph/osd/ceph-$ID
   ```

6. If the OSD is for a drive other than the OS drive, prepare it for use with Ceph, and mount it to the directory you just created.

   ```
   mkfs.xfs /dev/{DEV}
   mount /dev/{DEV} /var/lib/ceph/osd/ceph-$ID
   ```

7. Write the secret to the OSD keyring file.

   ```
   ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring \
        --name osd.$ID --add-key $OSD_SECRET
   ```

8. Initialize the OSD data directory.

   ```
   ceph-osd -i $ID --mkfs --osd-uuid $UUID
   ```

9. Fix ownership.

   ```
   chown -R ceph:ceph /var/lib/ceph/osd/ceph-$ID
   ```

10. After you add an OSD to Ceph, the OSD is in your configuration. However, it is not yet running. You must start your new OSD before it can begin receiving data.

    For modern systemd distributions:

    ```
    systemctl enable ceph-osd@$ID
    systemctl start ceph-osd@$ID
    ```

    For example:

    ```
    systemctl enable ceph-osd@12
    systemctl start ceph-osd@12
    ```

### Adding MDS

In the below instructions, `{id}` is an arbitrary name, such as the hostname of the machine.

1. Create the mds data directory.:

   ```
   mkdir -p /var/lib/ceph/mds/{cluster-name}-{id}
   ```

2. Create a keyring.:

   ```
   ceph-authtool --create-keyring /var/lib/ceph/mds/{cluster-name}-{id}/keyring --gen-key -n mds.{id}
   ```

3. Import the keyring and set caps.:

   ```
   ceph auth add mds.{id} osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/{cluster}-{id}/keyring
   ```

4. Add to ceph.conf.:

   ```
   [mds.{id}]
   host = {id}
   ```

5. Start the daemon the manual way.:

   ```
   ceph-mds --cluster {cluster-name} -i {id} -m {mon-hostname}:{mon-port} [-f]
   ```

6. Start the daemon the right way (using ceph.conf entry).:

   ```
   service ceph start
   ```

7. If starting the daemon fails with this error:

   ```
   mds.-1.0 ERROR: failed to authenticate: (22) Invalid argument
   ```

   Then make sure you do not have a keyring set in ceph.conf in the  global section; move it to the client section; or add a keyring setting  specific to this mds daemon. And verify that you see the same key in the mds data directory and `ceph auth get mds.{id}` output.

8. Now you are ready to [create a Ceph file system](https://docs.ceph.com/en/latest/cephfs/createfs).

### Summary

Once you have your monitor and two OSDs up and running, you can watch the placement groups peer by executing the following:

```
ceph -w
```

To view the tree, execute the following:

```
ceph osd tree
```

You should see output that looks something like this:

```
# id    weight  type name       up/down reweight
-1      2       root default
-2      2               host node1
0       1                       osd.0   up      1
-3      1               host node2
1       1                       osd.1   up      1
```

To add (or remove) additional monitors, see [Add/Remove Monitors](https://docs.ceph.com/en/latest/rados/operations/add-or-rm-mons). To add (or remove) additional Ceph OSD Daemons, see [Add/Remove OSDs](https://docs.ceph.com/en/latest/rados/operations/add-or-rm-osds).

