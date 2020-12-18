Ceph 安装

安装一个管理节点和一个三节点的Ceph 存储集群。

结构图：  

![](../../Image/Ceph-install.png)

**部署方式：**

- 手动部署
- cephadm
- Helm+kubernetes部署
- Ceph-ansible部署
- Ceph-deploy部署

## 手动部署

All Ceph clusters require at least one monitor, and at least as many OSDs as copies of an object stored on the cluster.  Bootstrapping the initial monitor(s) is the first step in deploying a Ceph Storage Cluster. Monitor deployment also sets important criteria for the entire cluster, such as the number of replicas for pools, the number of placement groups per OSD, the heartbeat intervals, whether authentication is required, etc. Most of these values are set by default, so it’s useful to know about them when setting up your cluster for production.

Following the same configuration as [Installation (ceph-deploy)](https://docs.ceph.com/docs/master/install/ceph-deploy), we will set up a cluster with `node1` as  the monitor node, and `node2` and `node3` for OSD nodes.

![img](https://docs.ceph.com/docs/master/_images/ditaa-9e7602f112d68831a1f69f6e1866f714672a7874.png)

## Monitor Bootstrapping

Bootstrapping a monitor (a Ceph Storage Cluster, in theory) requires a number of things:

- **Unique Identifier:** The `fsid` is a unique identifier for the cluster, and stands for File System ID from the days when the Ceph Storage Cluster was principally for the Ceph File System. Ceph now supports native interfaces, block devices, and object storage gateway interfaces too, so `fsid` is a bit of a misnomer.

- **Cluster Name:** Ceph clusters have a cluster name, which is a simple string without spaces. The default cluster name is `ceph`, but you may specify a different cluster name. Overriding the default cluster name is especially useful when you are working with multiple clusters and you need to clearly understand which cluster your are working with.

  For example, when you run multiple clusters in a [multisite configuration](https://docs.ceph.com/docs/master/radosgw/multisite/#multisite), the cluster name (e.g., `us-west`, `us-east`) identifies the cluster for the current CLI session. **Note:** To identify the cluster name on the command line interface, specify the Ceph configuration file with the cluster name (e.g., `ceph.conf`, `us-west.conf`, `us-east.conf`, etc.). Also see CLI usage (`ceph --cluster {cluster-name}`).

- **Monitor Name:** Each monitor instance within a cluster has a unique name. In common practice, the Ceph Monitor name is the host name (we recommend one Ceph Monitor per host, and no commingling of Ceph OSD Daemons with Ceph Monitors). You may retrieve the short hostname with `hostname -s`.

- **Monitor Map:** Bootstrapping the initial monitor(s) requires you to generate a monitor map. The monitor map requires the `fsid`, the cluster name (or uses the default), and at least one host name and its IP address.

- **Monitor Keyring**: Monitors communicate with each other via a secret key. You must generate a keyring with a monitor secret and provide it when bootstrapping the initial monitor(s).

- **Administrator Keyring**: To use the `ceph` CLI tools, you must have a `client.admin` user. So you must generate the admin user and keyring, and you must also add the `client.admin` user to the monitor keyring.

The foregoing requirements do not imply the creation of a Ceph Configuration file. However, as a best practice, we recommend creating a Ceph configuration file and populating it with the `fsid`, the `mon initial members` and the `mon host` settings.

You can get and set all of the monitor settings at runtime as well. However, a Ceph Configuration file may contain only those settings that override the default values. When you add settings to a Ceph configuration file, these settings override the default settings. Maintaining those settings in a Ceph configuration file makes it easier to maintain your cluster.

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

   **Note:** Deployment tools may remove this directory when purging a cluster (e.g., `ceph-deploy purgedata {node-name}`, `ceph-deploy purge {node-name}`).

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

   **Note:** You may use IPv6 addresses instead of IPv4 addresses, but you must set `ms bind ipv6` to `true`. See [Network Configuration Reference](https://docs.ceph.com/docs/master/rados/configuration/network-config-ref) for details about network configuration.

8. Create a keyring for your cluster and generate a monitor secret key.

   ```
   sudo ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
   ```

9. Generate an administrator keyring, generate a `client.admin` user and add the user to the keyring.

   ```
   sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
   ```

10. Generate a bootstrap-osd keyring, generate a `client.bootstrap-osd` user and add the user to the keyring.

    ```
    sudo ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
    ```

11. Add the generated keys to the `ceph.mon.keyring`.

    ```
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

    ```
    sudo -u ceph mkdir /var/lib/ceph/mon/ceph-node1
    ```

    See [Monitor Config Reference - Data](https://docs.ceph.com/docs/master/rados/configuration/mon-config-ref#data) for details.

15. Populate the monitor daemon(s) with the monitor map and keyring.

    ```
    sudo -u ceph ceph-mon [--cluster {cluster-name}] --mkfs -i {hostname} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

    For example:

    ```
    sudo -u ceph ceph-mon --mkfs -i node1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
    ```

16. Consider settings for a Ceph configuration file. Common settings include the following:

    ```
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

    ```
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

    For most distributions, services are started via systemd now:

    ```
    sudo systemctl start ceph-mon@node1
    ```

    For older Debian/CentOS/RHEL, use sysvinit:

    ```
    sudo /etc/init.d/ceph start mon.node1
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

    **Note:** Once you add OSDs and start them, the placement group health errors should disappear. See [Adding OSDs](https://docs.ceph.com/docs/master/install/manual-deployment/#adding-osds) for details.

## Manager daemon configuration

On each node where you run a ceph-mon daemon, you should also set up a ceph-mgr daemon.

See [ceph-mgr administrator’s guide](https://docs.ceph.com/docs/master/mgr/administrator/#mgr-administrator-guide)

## Adding OSDs

Once you have your initial monitor(s) running, you should add OSDs. Your cluster cannot reach an `active + clean` state until you have enough OSDs to handle the number of copies of an object (e.g., `osd pool default size = 2` requires at least two OSDs). After bootstrapping your monitor, your cluster has a default CRUSH map; however, the CRUSH map doesn’t have any Ceph OSD Daemons mapped to a Ceph Node.

### Short Form

Ceph provides the `ceph-volume` utility, which can prepare a logical volume, disk, or partition for use with Ceph. The `ceph-volume` utility creates the OSD ID by incrementing the index. Additionally, `ceph-volume` will add the new OSD to the CRUSH map under the host for you. Execute `ceph-volume -h` for CLI details. The `ceph-volume` utility automates the steps of the [Long Form](https://docs.ceph.com/docs/master/install/manual-deployment/#long-form) below. To create the first two OSDs with the short form procedure, execute the following on  `node2` and `node3`:

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

## Adding MDS

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
   ceph auth add mds.{id} osd "allow rwx" mds "allow" mon "allow profile mds" -i /var/lib/ceph/mds/{cluster}-{id}/keyring
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

8. Now you are ready to [create a Ceph file system](https://docs.ceph.com/docs/master/cephfs/createfs).

## Summary

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

To add (or remove) additional monitors, see [Add/Remove Monitors](https://docs.ceph.com/docs/master/rados/operations/add-or-rm-mons). To add (or remove) additional Ceph OSD Daemons, see [Add/Remove OSDs](https://docs.ceph.com/docs/master/rados/operations/add-or-rm-osds).



​                

​        

### 添加ceph官方yum镜像仓库

```bash
vi /etc/yum.repos.d/ceph.repo
```

```ini
[Ceph]
name=Ceph packages for $basearch
baseurl=http://mirrors.163.com/ceph/rpm-luminous/el7/$basearch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
priority=1

[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://mirrors.163.com/ceph/rpm-luminous/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
priority=1

[ceph-source]
name=Ceph source packages
baseurl=http://mirrors.163.com/ceph/rpm-luminous/el7/SRPMS
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
```

```bash
yum clean all
yum repolist 
yum list all |grep ceph
yum -y install epel-release 
```



### 设置防火墙，放行相关端口

```bash
systemctl start firewalld
systemctl enable firewalld 
firewall-cmd --zone=public --add-port=**6789/tcp** --permanent
firewall-cmd --zone=public --add-port=**6800-7300/tcp** --permanent
firewall-cmd --reload
```

### 安装ceph组件

```bash
yum -y install ceph ceph-mds ceph-mgr ceph-osd ceph-mon

ll /etc/ceph/
rbdmap

ll /var/lib/ceph/
bootstrap-mds
bootstrap-mgr
bootstrap-osd
bootstrap-rbd
bootstrap-rgw
mds
mgr
mon
osd
tmp
```

### 创建集群id

```bash
uidgen
```

用uidgen 生成一个uuid 例如 `ee741368-4233-4cbc-8607-5d36ab314dab`

### 创建ceph主配置文件

```bash
vim /etc/ceph/ceph.conf

[global]
fsid = ee741368-4233-4cbc-8607-5d36ab314dab

mon_initial_members = node01
mon_host = 192.168.1.103
mon_max_pg_per_osd = 300

auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx

osd_pool_default_size = 1
osd_pool_default_min_size = 1
osd_journal_size = 1024
osd_crush_chooseleaf_type = 0

public_network = 192.168.1.0/24
cluster_network = 192.168.1.0/24

[mon]
mon allow pool delete = true
```



### 部署mon

#### 创建mon密钥

```bash
ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
cat /tmp/ceph.mon.keyring
```

#### 创建管理密钥

```bash
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'

ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd'

cat /etc/ceph/ceph.client.admin.keyring
cat /var/lib/ceph/bootstrap-osd/ceph.keyring
```

#### 将管理密钥都导入到mon密钥中

```bash
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
cat /tmp/ceph.mon.keyring
```

#### 创建monitor map

```bash
monmaptool --create --add node01 192.168.1.103 --fsid ee741368-4233-4cbc-8607-5d36ab314dab /tmp/monmap
```

#### 创建mon的目录，启动mon

```bash
mkdir  /var/lib/ceph/mon/ceph-node1
chown -R ceph:ceph /var/lib/ceph/
chown ceph:ceph  /tmp/monmap  /tmp/ceph.mon.keyring
sudo -u ceph ceph-mon --mkfs -i node01 --monmap /tmp/monmap  --keyring /tmp/ceph.mon.keyring
ll /var/lib/ceph/mon/ceph-node01/
```

#### 启动mon服务

```bash
systemctl start ceph-mon@node01.service
systemctl enable ceph-mon@node01.service
systemctl status ceph-mon@node01.service

ceph -s
```



### 部署osd

#### 创建osd

```bash
ceph-volume lvm create --data /dev/sdb
ll /dev/mapper/
ll /var/lib/ceph/osd/ceph-0/
ceph auth list
```

#### 启动osd服务

```bash
systemctl start ceph-osd@0.service
systemctl enable ceph-osd@0.service
systemctl status ceph-osd@0.service

ceph -s
```



### 部署mgr

#### 创建密钥

```bash
mkdir /var/lib/ceph/mgr/ceph-node01
ceph auth get-or-create mgr.node01 mon 'allow profile mgr' osd  'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-node01/keyring

chown -R ceph:ceph /var/lib/ceph/mgr
```

#### 启动mgr服务

```bash
systemctl start ceph-mgr@node01.service
systemctl enable ceph-mgr@node01.service
systemctl status ceph-mgr@node01.service

ceph -s
```

#### 查看mgr模块

```bash
ceph mgr module ls 
```



### 部署mds

#### 创建mds数据目录

```bash
mkdir -p /var/lib/ceph/mds/ceph-node01
```

#### 创建秘钥

```bash
ceph-authtool --create-keyring /var/lib/ceph/mds/ceph-node01/keyring  --gen-key -n  mds.node01
```

#### 导入秘钥

```bash
ceph auth add mds.node01 osd "allow rwx" mds "allow" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-node01/keyring

chown -R ceph:ceph /var/lib/ceph/mds
ceph auth list
```

#### 启动mds服务

```
systemctl start ceph-mds@node01.service
systemctl enable ceph-mds@node01.service
systemctl status ceph-mds@node01.service
```



![img](https://upload-images.jianshu.io/upload_images/12979420-443b68d14f4d677f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

\# ceph osd tree

![img](https://upload-images.jianshu.io/upload_images/12979420-a11b67fc11cf2eb6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/830/format/webp)

 

### 创建Ceph Pool

一个ceph集群可以有多个pool，每个pool是逻辑上的隔离单位，不同的pool可以有完全不一样的数据处理方式，比如Replica Size（副本数）、Placement Groups、CRUSH Rules、快照、所属者等。

**pg_num设置参考：https://ceph.com/pgcalc**

![img](https://upload-images.jianshu.io/upload_images/12979420-4ba634131cbc350a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/502/format/webp)



```bash
ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new cephfs cephfs_metadata cephfs_data
ceph fs ls
ceph -s
ceph --show-config | grep mon_max_pg_per_osd
```

集群osd 数量较少，如果创建了大量的pool，每个pool要占用一些pg ，ceph集群默认每块磁盘都有默认值，为250 pgs，不过这个默认值是可以调整的，但调整得过大或者过小都会对集群的性能产生一定影响。

```bash
vim /etc/ceph/ceph.conf

mon_max_pg_per_osd = 300
```

```bash
systemctl restart ceph-mgr@node01.service
systemctl status ceph-mgr@node01.service

ceph --show-config | grep "mon_max_pg_per_osd"
ceph osd lspools
```

 

### 安装配置cephClient

客户端要挂载使用cephfs的目录，有两种方式：

**1. 使用linux kernel client**

**2. 使用ceph-fuse**

这两种方式各有优劣势，kernel  client的特点在于它与ceph通信大部分都在内核态进行，因此性能要更好，缺点是L版本的cephfs要求客户端支持一些高级特性，ceph  FUSE就是简单一些，还支持配额，缺点就是性能比较差，实测全ssd的集群，性能差不多为kernel client的一半。

**关闭selinux**

\# setenforce 0

\# sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

## 方式一：使用linux kernel client

**在cephSever服务器上获取admin认证key**

\# cat /etc/ceph/ceph.client.admin.keyring

![img](https://upload-images.jianshu.io/upload_images/12979420-ba9acb50bc9054ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/859/format/webp)

默认采用ceph-deploy部署ceph集群是开启了cephx认证，需要挂载secret-keyring，即集群mon节点/etc/ceph/ceph.client.admin.keyring文件中的”key”值，采用secretfile可不用暴露keyring，但有1个bug，始终报错：libceph: bad option at 'secretfile=/etc/ceph/admin.secret'

**Bug地址：[https://bugzilla.redhat.com/show_bug.cgi?id=1030402](https://links.jianshu.com/go?to=https%3A%2F%2Fbugzilla.redhat.com%2Fshow_bug.cgi%3Fid%3D1030402)**

 

\# mount -t ceph **192.168.1.103:6789:/** /mnt -o name=admin,secret=AQDZRfJcn4i0BRAAAHXMjFmkEZX2oO/ron1mRA==

\# mount -l | grep ceph 

\# df -hT 

![img](https://upload-images.jianshu.io/upload_images/12979420-0694ae79ddb3e5c7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

 

## 方式二：使用ceph-fuse

 

**在cephClient上搭建 本地yum源**

将cephDeps.tar.gz拷贝到cephClient)服务器

\# tar -zxf cephDeps.tar.gz 

**# vim build_localrepo.sh** 

\##################################################

\#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

cd "$parent_path"

mkdir /etc/yum.repos.d/backup

mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup

\# create local repositry

rm -rf /tmp/localrepo

mkdir -p /tmp/localrepo

cp -rf ./cephDeps/* /tmp/localrepo

**echo "**

**[localrepo]**

**name=Local Repository**

**baseurl=file:///tmp/localrepo**

**gpgcheck=0**

**enabled=1" > /etc/yum.repos.d/ceph.repo**

yum clean all

\##################################################

\# sh -x build_localrepo.sh 

\# yum repolist 

![img](https://upload-images.jianshu.io/upload_images/12979420-d089773ff56e95fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

**安装ceph-fuse 相关组件**

\# yum -y install ceph-fuse

\# rpm -ql ceph-fuse

![img](https://upload-images.jianshu.io/upload_images/12979420-fff933086b4c8898.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/638/format/webp)

**创建ceph-fuse 相关目录，从cephServer拷贝配置文件和秘钥**

\# mkdir /etc/ceph

**# scp root@192.168.1.103:/etc/ceph/ceph.client.admin.keyring /etc/ceph**

**# scp root@192.168.1.103:/etc/ceph/ceph.conf  /etc/ceph** 

\# chmod 600 /etc/ceph/ceph.client.admin.keyring

**创建ceph-fuse的service文件**

\# cp /usr/lib/systemd/system/ceph-fuse@.service  /etc/systemd/system/ceph-fuse.service

**# vim /etc/systemd/system/ceph-fuse.service** 

\##############################################

[Unit]

Description=Ceph FUSE client

After=network-online.target local-fs.target time-sync.target

Wants=network-online.target local-fs.target time-sync.target

Conflicts=umount.target

PartOf=ceph-fuse.target

[Service]

EnvironmentFile=-/etc/sysconfig/ceph

Environment=CLUSTER=ceph

**ExecStart=/usr/bin/ceph-fuse -f -o rw,noexec,nosuid,nodev /mnt**

TasksMax=infinity

Restart=on-failure

StartLimitInterval=30min

StartLimitBurst=3

[Install]

WantedBy=ceph-fuse.target

\########################################################

![img](https://upload-images.jianshu.io/upload_images/12979420-5a3fdd9388656e8d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/742/format/webp)

**我们将cephfs挂载在客户端/mnt下**

\# systemctl daemon-reload

\# systemctl start ceph-fuse.service

\# systemctl enable ceph-fuse.service

\# systemctl status ceph-fuse.service

![img](https://upload-images.jianshu.io/upload_images/12979420-76fe28d8609b1b33.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

\# systemctl start ceph-fuse.target

\# systemctl enable ceph-fuse.target

\# systemctl status ceph-fuse.target

![img](https://upload-images.jianshu.io/upload_images/12979420-11af91d623095131.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

 

\# df -hT

![img](https://upload-images.jianshu.io/upload_images/12979420-281c4eaead436f56.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/775/format/webp)

**测试写入一个大文件**

\# dd if=/dev/zero of=/mnt/test bs=1M count=10000

\# df -hT

![img](https://upload-images.jianshu.io/upload_images/12979420-00e192c73620ed79.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/792/format/webp)

设置cephFS 挂载子目录

从上面的可以看出，挂载cephfs的时候，源目录使用的是/，如果一个集群只提供给一个用户使用就太浪费了，能不能把集群切分成多个目录，多个用户自己挂载自己的目录进行读写呢？

**# ceph-fuse --help**

![img](https://upload-images.jianshu.io/upload_images/12979420-e304fa232b1bb7b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

使用admin挂载了cephfs的/之后，只需在/中创建目录，这些创建后的目录就成为cephFS的子树，其他用户经过配置，是可以直接挂载这些子树目录的，具体步骤为：

**1. 使用admin挂载了/之后，创建了/ceph**

\# mkdir -p /opt/tmp

\# ceph-fuse /opt/tmp

\# mkdir /opt/tmp/**ceph**

\# umount /opt/tmp

\# rm -rf /opt/tmp

**2. 设置ceph-fuse.service，挂载子目录**

\# vim /etc/systemd/system/ceph-fuse.service

\################################################

[Unit]

Description=Ceph FUSE client

After=network-online.target local-fs.target time-sync.target

Wants=network-online.target local-fs.target time-sync.target

Conflicts=umount.target

PartOf=ceph-fuse.target

[Service]

EnvironmentFile=-/etc/sysconfig/ceph

Environment=CLUSTER=ceph

**ExecStart=/usr/bin/ceph-fuse -f -o rw,noexec,nosuid,nodev /mnt  -r /ceph**

TasksMax=infinity

Restart=on-failure

StartLimitInterval=30min

StartLimitBurst=3

[Install]

WantedBy=ceph-fuse.target



\# systemctl daemon-reload 

\# systemctl start ceph-fuse.service

\# systemctl enable ceph-fuse.service

\# systemctl status ceph-fuse.service



\# systemctl start ceph-fuse.target

\# systemctl enable ceph-fuse.target

\# systemctl status ceph-fuse.target

**# df -hT**

 

## Helm + kubernetes部署



## Ceph-ansible

1. 下载源代码

   ```bash
   git clone https://github.com/ceph/ceph-ansible.git 
   ```

2. 切换到stable-3.1版本

   ```bash
   cd  ceph-ansible             #进入到ceph-ansible目录下
   git branch -r                #查看系统分支
   git fetch origin stable-3.1  #将远端得3.1拉到本地
   git chechout  stable-3.1     #切换到3.1分支
   ```

   | ceph-ansible | ceph            | ansible  |
   | ------------ | --------------- | -------- |
   | stable-3.0   | jewel、luminous | 2.4  2.5 |
   | stable-3.1   | luminous、mimic | 2.4  2.5 |
   | master       | luminous、mimic | 2.5      |

3. 安装ansible，使用pip去安装ansible。

   ```bash
   pip install -r requirements.txt
   ```

4. 创建Inventory列表

   ```ini
   [mons]
   node1
   node2
   node3
   
   [osds]
   node1
   node2
   node3
   
   [rgws]
   node1
   node2
   node3
   
   [clients]
   node1
   node2
   node3
   
   [mgrs]
   node1
   node2
   node3
   ```

5. 拷贝`group_vars/all.yml.sample` 到`group_vars/all.yml`，并修改`all.yml `文件，添加如下参数：

   ```yaml
   cluster: ceph                                # 集群名
   ceph_origin: repository						 # 使用distro，则不会使用公网源
   ceph_repository: community                   # local:被操作节点使用本地的repo文件
   ceph_mirror: https://mirrors.163.com/ceph/
   ceph_stable_release: luminous                #安装版本
   ceph_stable_repo: "{{ ceph_mirror }}/rpm-{{ ceph_stable_release }}"
   ceph_stable_redhat_distro: el7
   monitor_interface: eth1
   journal_size: 1024
   public_network: 192.168.9.0/24
   cluster_network: 192.168.10.0/24
   osd_objectstore: filestore
   radosgw_interface: "{{ monitor_interface }}"
   osd_auto_discovery: true
   ```

6. 拷贝`site.yml.sample` 到`site.yml`（注释掉一些host，效果如下：）

   ```yaml
   - hosts:
     - mons
     - agents
     - osds
    # - mdss
     - rgws
    # - nfss
    # - restapis
    # - rbdmirrors
     - clients
     - mgrs
    # - iscsigws
    # - iscsi-gws # for backward compatibility only!
   ```

7. 执行部署操作

   ```bash
   ansible-playbook -i hosts site.yml
   ```



## ceph-deploy

把 Ceph 仓库添加到 `ceph-deploy` 管理节点，然后安装 `ceph-deploy` 。

### 高级包管理工具（APT）

在 Debian 和 Ubuntu 发行版上，执行下列步骤：

1. 添加 release key ：

   ```
   wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
   ```

2. 添加Ceph软件包源，用Ceph稳定版（如 `cuttlefish` 、 `dumpling` 、 `emperor` 、 `firefly` 等等）替换掉 `{ceph-stable-release}` 。例如：

   ```
   echo deb http://download.ceph.com/debian-{ceph-stable-release}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
   ```

3. 更新你的仓库，并安装 `ceph-deploy` ：

   ```
   sudo apt-get update && sudo apt-get install ceph-deploy
   ```

Note

你也可以从欧洲镜像 eu.ceph.com 下载软件包，只需把 `http://ceph.com/` 替换成 `http://eu.ceph.com/` 即可。

### 红帽包管理工具（RPM）

在 Red Hat （rhel6、rhel7）、CentOS （el6、el7）和 Fedora 19-20 （f19 - f20） 上执行下列步骤：

1. 在 RHEL7 上，用 `subscription-manager` 注册你的目标机器，确认你的订阅， 并启用安装依赖包的“Extras”软件仓库。例如 ：

   ```
   sudo subscription-manager repos --enable=rhel-7-server-extras-rpms
   ```

2. 在 RHEL6 上，安装并启用 Extra Packages for Enterprise Linux (EPEL) 软件仓库。 请查阅 [EPEL wiki](https://fedoraproject.org/wiki/EPEL) 获取更多信息。

3. 在 CentOS 上，可以执行下列命令：

   ```
   sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ && sudo yum install --nogpgcheck -y epel-release && sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && sudo rm /etc/yum.repos.d/dl.fedoraproject.org*
   ```

4. 把软件包源加入软件仓库。用文本编辑器创建一个 YUM (Yellowdog Updater, Modified) 库文件，其路径为 `/etc/yum.repos.d/ceph.repo` 。例如：

   ```
   sudo vim /etc/yum.repos.d/ceph.repo
   ```

   把如下内容粘帖进去，用 Ceph 的最新主稳定版名字替换 `{ceph-stable-release}` （如 `firefly` ），用你的Linux发行版名字替换 `{distro}` （如 `el6` 为 CentOS 6 、 `el7` 为 CentOS 7 、 `rhel6` 为 Red Hat 6.5 、 `rhel7` 为 Red Hat 7 、 `fc19` 是 Fedora 19 、 `fc20` 是 Fedora 20 ）。最后保存到 `/etc/yum.repos.d/ceph.repo` 文件中。

   ```
   [ceph-noarch]
   name=Ceph noarch packages
   baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
   enabled=1
   gpgcheck=1
   type=rpm-md
   gpgkey=https://download.ceph.com/keys/release.asc
   ```

5. 更新软件库并安装 `ceph-deploy` ：

   ```
   sudo yum update && sudo yum install ceph-deploy
   ```

Note

你也可以从欧洲镜像 eu.ceph.com 下载软件包，只需把 `http://ceph.com/` 替换成 `http://eu.ceph.com/` 即可。

### Ceph 节点安装

你的管理节点必须能够通过 SSH 无密码地访问各 Ceph 节点。如果 `ceph-deploy` 以某个普通用户登录，那么这个用户必须有无密码使用 `sudo` 的权限。

#### 安装 NTP

我们建议在所有 Ceph 节点上安装 NTP 服务（特别是 Ceph Monitor 节点），以免因时钟漂移导致故障，详情见[时钟](http://docs.ceph.org.cn/rados/configuration/mon-config-ref#clock)。

在 CentOS / RHEL 上，执行：

```
sudo yum install ntp ntpdate ntp-doc
```

在 Debian / Ubuntu 上，执行：

```
sudo apt-get install ntp
```

确保在各 Ceph 节点上启动了 NTP 服务，并且要使用同一个 NTP 服务器，详情见 [NTP](http://www.ntp.org/) 。

#### 安装 SSH 服务器

在**所有** Ceph 节点上执行如下步骤：

1. 在各 Ceph 节点安装 SSH 服务器（如果还没有）：

   ```
   sudo apt-get install openssh-server
   ```

   或者

   ```
   sudo yum install openssh-server
   ```

2. 确保**所有** Ceph 节点上的 SSH 服务器都在运行。

#### 创建部署 Ceph 的用户

`ceph-deploy` 工具必须以普通用户登录 Ceph 节点，且此用户拥有无密码使用 `sudo` 的权限，因为它需要在安装软件及配置文件的过程中，不必输入密码。

较新版的 `ceph-deploy` 支持用 `--username` 选项提供可无密码使用 `sudo` 的用户名（包括 `root` ，虽然**不建议**这样做）。使用 `ceph-deploy --username {username}` 命令时，指定的用户必须能够通过无密码 SSH 连接到 Ceph 节点，因为 `ceph-deploy` 中途不会提示输入密码。

我们建议在集群内的**所有** Ceph 节点上给 `ceph-deploy` 创建一个特定的用户，但**不要**用 “ceph” 这个名字。全集群统一的用户名可简化操作（非必需），然而你应该避免使用知名用户名，因为黑客们会用它做暴力破解（如 `root` 、 `admin` 、 `{productname}` ）。后续步骤描述了如何创建无 `sudo` 密码的用户，你要用自己取的名字替换 `{username}` 。

Note

从 [Infernalis 版](http://docs.ceph.org.cn/release-notes/#v9-1-0-infernalis-release-candidate)起，用户名 “ceph” 保留给了 Ceph 守护进程。如果 Ceph 节点上已经有了 “ceph” 用户，升级前必须先删掉这个用户。

1. 在各 Ceph 节点创建新用户。

   ```
   ssh user@ceph-server
   sudo useradd -d /home/{username} -m {username}
   sudo passwd {username}
   ```

2. 确保各 Ceph 节点上新创建的用户都有 `sudo` 权限。

   ```
   echo "{username} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/{username}
   sudo chmod 0440 /etc/sudoers.d/{username}
   ```

#### 允许无密码 SSH 登录

正因为 `ceph-deploy` 不支持输入密码，你必须在管理节点上生成 SSH 密钥并把其公钥分发到各 Ceph 节点。 `ceph-deploy` 会尝试给初始 monitors 生成 SSH 密钥对。

1. 生成 SSH 密钥对，但不要用 `sudo` 或 `root` 用户。提示 “Enter passphrase” 时，直接回车，口令即为空：

   ```
   ssh-keygen
   
   Generating public/private key pair.
   Enter file in which to save the key (/ceph-admin/.ssh/id_rsa):
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   Your identification has been saved in /ceph-admin/.ssh/id_rsa.
   Your public key has been saved in /ceph-admin/.ssh/id_rsa.pub.
   ```

2. 把公钥拷贝到各 Ceph 节点，把下列命令中的 `{username}` 替换成前面[创建部署 Ceph 的用户](http://docs.ceph.org.cn/start/quick-start-preflight/#id3)里的用户名。

   ```
   ssh-copy-id {username}@node1
   ssh-copy-id {username}@node2
   ssh-copy-id {username}@node3
   ```

3. （推荐做法）修改 `ceph-deploy` 管理节点上的 `~/.ssh/config` 文件，这样 `ceph-deploy` 就能用你所建的用户名登录 Ceph 节点了，而无需每次执行 `ceph-deploy` 都要指定 `--username {username}` 。这样做同时也简化了 `ssh` 和 `scp` 的用法。把 `{username}` 替换成你创建的用户名。

   ```
   Host node1
      Hostname node1
      User {username}
   Host node2
      Hostname node2
      User {username}
   Host node3
      Hostname node3
      User {username}
   ```

#### 引导时联网

Ceph 的各 OSD 进程通过网络互联并向 Monitors 上报自己的状态。如果网络默认为 `off` ，那么 Ceph 集群在启动时就不能上线，直到你打开网络。

某些发行版（如 CentOS ）默认关闭网络接口。所以需要确保网卡在系统启动时都能启动，这样 Ceph 守护进程才能通过网络通信。例如，在 Red Hat 和 CentOS 上，需进入 `/etc/sysconfig/network-scripts` 目录并确保 `ifcfg-{iface}` 文件中的 `ONBOOT` 设置成了 `yes` 。

#### 确保联通性

用 `ping` 短主机名（ `hostname -s` ）的方式确认网络联通性。解决掉可能存在的主机名解析问题。

Note

主机名应该解析为网络 IP 地址，而非回环接口 IP 地址（即主机名应该解析成非 `127.0.0.1` 的IP地址）。如果你的管理节点同时也是一个 Ceph 节点，也要确认它能正确解析自己的主机名和 IP 地址（即非回环 IP 地址）。

#### 开放所需端口

Ceph Monitors 之间默认使用 `6789` 端口通信， OSD 之间默认用 `6800:7300` 这个范围内的端口通信。详情见[网络配置参考](http://docs.ceph.org.cn/rados/configuration/network-config-ref)。 Ceph OSD 能利用多个网络连接进行与客户端、monitors、其他 OSD 间的复制和心跳的通信。

某些发行版（如 RHEL ）的默认防火墙配置非常严格，你可能需要调整防火墙，允许相应的入站请求，这样客户端才能与 Ceph 节点上的守护进程通信。

对于 RHEL 7 上的 `firewalld` ，要对公共域开放 Ceph Monitors 使用的 `6789` 端口和 OSD 使用的 `6800:7300` 端口范围，并且要配置为永久规则，这样重启后规则仍有效。例如：

```
sudo firewall-cmd --zone=public --add-port=6789/tcp --permanent
```

若使用 `iptables` ，要开放 Ceph Monitors 使用的 `6789` 端口和 OSD 使用的 `6800:7300` 端口范围，命令如下：

```
sudo iptables -A INPUT -i {iface} -p tcp -s {ip-address}/{netmask} --dport 6789 -j ACCEPT
```

在每个节点上配置好 `iptables` 之后要一定要保存，这样重启之后才依然有效。例如：

```
/sbin/service iptables save
```

#### 终端（ TTY ）

在 CentOS 和 RHEL 上执行 `ceph-deploy` 命令时可能会报错。如果你的 Ceph 节点默认设置了 `requiretty` ，执行 `sudo visudo` 禁用它，并找到 `Defaults requiretty` 选项，把它改为 `Defaults:ceph !requiretty` 或者直接注释掉，这样 `ceph-deploy` 就可以用之前创建的用户（[创建部署 Ceph 的用户](http://docs.ceph.org.cn/start/quick-start-preflight/#id3) ）连接了。

Note

编辑配置文件 `/etc/sudoers` 时，必须用 `sudo visudo` 而不是文本编辑器。

#### SELinux

在 CentOS 和 RHEL 上， SELinux 默认为 `Enforcing` 开启状态。为简化安装，我们建议把 SELinux 设置为 `Permissive` 或者完全禁用，也就是在加固系统配置前先确保集群的安装、配置没问题。用下列命令把 SELinux 设置为 `Permissive` ：

```
sudo setenforce 0
```

要使 SELinux 配置永久生效（如果它的确是问题根源），需修改其配置文件 `/etc/selinux/config` 。

#### 优先级/首选项

确保你的包管理器安装了优先级/首选项包且已启用。在 CentOS 上你也许得安装 EPEL ，在 RHEL 上你也许得启用可选软件库。

```
sudo yum install yum-plugin-priorities
```

比如在 RHEL 7 服务器上，可用下列命令安装 `yum-plugin-priorities`并启用 `rhel-7-server-optional-rpms` 软件库：

```
sudo yum install yum-plugin-priorities --enablerepo=rhel-7-server-optional-rpms
```







### Debian/Ubuntu

1.添加发布密钥：

    wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -  
2.添加 Ceph 软件包源，用稳定版 Ceph（如 cuttlefish 、 dumpling 、 emperor 、 firefly 等等）替换掉 {ceph-stable-release} 。  

    echo deb http://ceph.com/debian-{ceph-stable-release}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list

3.更新仓库，并安装 ceph-deploy ：  

    sudo apt-get update && sudo apt-get install ceph-deploy

### RedHat/CentOS/Fedora
创建一个 YUM (Yellowdog Updater, Modified) 库文件，其路径为 /etc/yum.repos.d/ceph.repo  
用最新稳定版 Ceph 名字替换 {ceph-stable-release} （如 firefly ）、用你的发行版名字替换 {distro} （如 el6 为 CentOS 6 、 rhel6.5 为 Red Hat 6 .5、 fc19 是 Fedora 19 、 fc20 是 Fedora 20 。

```shell
[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-{ceph-stable-release}/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
```

更新软件库并安装 ceph-deploy ：

```shell
sudo yum update && sudo yum install ceph-deploy
```

## Ceph 节点准备
管理节点能够通过 SSH 无密码地访问各 Ceph 节点。


### 创建 Ceph 用户
ceph-deploy 工具必须以普通用户登录，且此用户拥有无密码使用 sudo 的权限，因为它需要安装软件及配置文件，中途不能输入密码。  

建议在集群内的所有 Ceph 节点上都创建一个 Ceph 用户。

在各 Ceph 节点创建用户。

    ssh user@ceph-server
    sudo useradd -d /home/{username} -m {username}·
    sudo passwd {username}

确保各 Ceph 节点上所创建的用户都有 sudo 权限。

    echo "{username} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/{username}
    sudo chmod 0440 /etc/sudoers.d/{username}

生成 SSH 密钥对，但不要用 sudo 或 root 用户。口令为空：

    ssh-keygen
    
    Generating public/private key pair.
    Enter file in which to save the key (/ceph-admin/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /ceph-admin/.ssh/id_rsa.
    Your public key has been saved in /ceph-admin/.ssh/id_rsa.pub.

把公钥拷贝到各 Ceph 节点。

    ssh-copy-id {username}@node1
    ssh-copy-id {username}@node2
    ssh-copy-id {username}@node3

（推荐做法）修改 ceph-deploy 管理节点上的 ~/.ssh/config 文件，这样 ceph-deploy 就能用你所建的用户名登录 Ceph 节点了，无需每次执行 ceph-deploy 都指定 --username {username} 。这样做同时也简化了 ssh 和 scp 的用法。

    Host node1
       Hostname node1
       User {username}
    Host node2
       Hostname node2
       User {username}
    Host node3
       Hostname node3
       User {username}

### 引导时联网

Ceph 监视器之间默认用 6789 端口通信， OSD 之间默认用 6800:7810 这个范围内的端口通信。 Ceph OSD 能利用多个网络连接与客户端、监视器、其他副本 OSD 、其它心跳 OSD 分别进行通信。

对于 RHEL 7 上的 firewalld ，要对公共域放通 Ceph 监视器所使用的 6789 端口、以及 OSD 所使用的 6800:7100 ，并且要配置为永久规则，这样重启后规则仍有效。例如：

    sudo firewall-cmd --zone=public --add-port=6789/tcp --permanent

若用 iptables 命令，要放通 Ceph 监视器所用的 6789 端口和 OSD 所用的 6800:7100 端口范围，命令如下：

    sudo iptables -A INPUT -i {iface} -p tcp -s {ip-address}/{netmask} --dport 6789 -j ACCEPT

配置好 iptables 之后要保存配置，这样重启之后才依然有效。

    /sbin/service iptables save

>在 CentOS 和 RHEL 上执行 ceph-deploy 命令时，如果你的 Ceph 节点默认设置了 requiretty 那就会遇到报错。可以这样禁用它，执行 sudo visudo ，找到 Defaults requiretty 选项，把它改为 Defaults:ceph !requiretty 或者干脆注释掉，这样 ceph-deploy 就可以用之前创建的用户（ 创建 Ceph 用户 ）连接了。编辑配置文件 /etc/sudoers 时，必须用 sudo visudo 而不是文本编辑器。

### SELinux

为简化安装，把 SELinux 设置为 Permissive 或者完全禁用，也就是在加固系统配置前先确保集群的安装、配置没问题。用下列命令把 SELinux 设置为 Permissive ：

    sudo setenforce 0

## Ceph 安装
登录管理节点，新建一个工作目录ceph，后面所有操作都在此目录下进行，ceph-deploy工具会在此目录产生各个配置文件，并对所有节点进行安装配置。

### 生成监视器啊密钥
生成一个文件系统ID (FSID)

    ceph-deploy purgedata {ceph-node} [{ceph-node}]
    ceph-deploy forgetkeys

### 创建集群

    ceph-deploy new {ceph-node}

### 安装ceph软件

    ceph-deploy install {ceph-node} [{ceph-node}]

### 组建mon集群：

    ceph-deploy mon create {ceph-node}

启动mon进程：

    ceph-deploy mon create-initial

### 收集密钥

    ceph-deploy gatherkeys {ceph-node}

### 安装OSD
准备OSD

    ceph-deploy osd prepare {ceph-node}:/path/to/directory

激活OSD

    ceph-deploy osd activate {ceph-node}:/path/to/directory

### 复制ceph配置文件和key文件到各个节点

    ceph-deploy admin {ceph-node}

### 检查健康情况

    ceph health

返回active + clean 状态。

### 安装MDS

    ceph-deploy mds create {ceph-node}

# Installing Ceph

There are several different ways to install Ceph.  Choose the method that best suits your needs.

## Recommended methods

[Cephadm](https://docs.ceph.com/docs/master/cephadm/#cephadm) installs and manages a Ceph cluster using containers and systemd, with tight integration with the CLI and dashboard GUI.

- cephadm only supports Octopus and newer releases.
- cephadm is fully integrated with the new orchestration API and fully supports the new CLI and dashboard features to manage cluster deployment.
- cephadm requires container support (podman or docker) and Python 3.

[Rook](https://rook.io/) deploys and manages Ceph clusters running in Kubernetes, while also enabling management of storage resources and provisioning via Kubernetes APIs.  We recommend Rook as the way to run Ceph in Kubernetes or to connect an existing Ceph storage cluster to Kubernetes.

- Rook only supports Nautilus and newer releases of Ceph.
- Rook is the preferred method for running Ceph on Kubernetes, or for connecting a Kubernetes cluster to an existing (external) Ceph cluster.
- Rook supports the new orchestrator API. New management features in the CLI and dashboard are fully supported.

## Other methods

[ceph-ansible](https://docs.ceph.com/ceph-ansible/) deploys and manages Ceph clusters using Ansible.

- ceph-ansible is widely deployed.
- ceph-ansible is not integrated with the new orchestrator APIs, introduced in Nautlius and Octopus, which means that newer management features and dashboard integration are not available.

`ceph-deploy` is a tool for quickly deploying clusters.

> Important
>
> ceph-deploy is no longer actively maintained. It is not tested on  versions of Ceph newer than Nautilus. It does not support RHEL8, CentOS  8, or newer operating systems.

[DeepSea](https://github.com/SUSE/DeepSea) installs Ceph using Salt.

[jaas.ai/ceph-mon](https://jaas.ai/ceph-mon) installs Ceph using Juju.

[github.com/openstack/puppet-ceph](https://github.com/openstack/puppet-ceph)  installs Ceph via Puppet.

Ceph can also be [installed manually](https://docs.ceph.com/docs/master/install/index_manual/#install-manual).

Installing Ceph  There are several different ways to install Ceph.Choose the method that  best suits your needs. Recommended methods  Cephadm installs and manages a Ceph cluster using containers and  systemd, with tight integration with the CLI and dashboard GUI.      cephadm only supports Octopus and newer releases.      cephadm is fully integrated with the new orchestration API and fully supports the new CLI and dashboard features to manage cluster  deployment.      cephadm requires container support (podman or docker) and Python 3.  Rook deploys and manages Ceph clusters running in Kubernetes, while also enabling management of storage resources and provisioning via  Kubernetes APIs.We recommend Rook as the way to run Ceph in Kubernetes  or to connect an existing Ceph storage cluster to Kubernetes.      Rook only supports Nautilus and newer releases of Ceph.      Rook is the preferred method for running Ceph on Kubernetes, or for  connecting a Kubernetes cluster to an existing (external) Ceph cluster.      Rook supports the new orchestrator API.New management features in  the CLI and dashboard are fully supported.  Other methods  ceph-ansible deploys and manages Ceph clusters using Ansible.      ceph-ansible is widely deployed.      ceph-ansible is not integrated with the new orchestrator APIs,  introduced in Nautlius and Octopus, which means that newer management  features and dashboard integration are not available.  ceph-deploy is a tool for quickly deploying clusters.      Important      ceph-deploy is no longer actively maintained.It is not tested on  versions of Ceph newer than Nautilus.It does not support RHEL8, Cent OS  8, or newer operating systems.  Deep Sea installs Ceph using Salt.  jaas.ai/ceph-mon installs Ceph using Juju.  github.com/openstack/puppet-ceph installs Ceph via Puppet.  Ceph can also be installed manually.

安装Ceph 
 
有几种不同的安装Ceph的方法。选择最适合您需求的方法。 
推荐方法 
 
Cephadm使用容器和systemd安装并管理Ceph集群，并与CLI和仪表板GUI紧密集成。 
 
    cephadm仅支持八达通和更高版本。 
 
    cephadm与新的业务流程API完全集成，并完全支持新的CLI和仪表板功能来管理集群部署。 
 
    cephadm需要容器支持（podman或docker）和Python 3。 
 
Rook部署和管理在Kubernetes中运行的Ceph集群，同时还支持管理存储资源和通过Kubernetes API进行配置。我们建议使用Rook作为在Kubernetes中运行Ceph或将现有Ceph存储集群连接到Kubernetes的方式。 
 
    Rook仅支持Nautilus和Ceph的较新版本。 
 
    Rook是在Kubernetes上运行Ceph或将Kubernetes集群连接到现有（外部）Ceph集群的首选方法。 
 
    Rook支持新的Orchestrator API。完全支持CLI和仪表板中的新管理功能。 
 
其他方法 
 
ceph-ansible使用Ansible部署和管理Ceph集群。 
 
    ceph-ansible被广泛部署。 
 
    ceph-ansible未与Nautlius和Octopus中引入的新Orchestrator API集成，这意味着更新的管理功能和仪表板集成不可用。 
 
ceph-deploy是用于快速部署集群的工具。 
 
    重要 
 
    不再积极维护ceph-deploy。未在Nautilus之前的Ceph版本上进行测试。它不支持RHEL8，Cent OS 8或更高版本的操作系统。 
 
Deep Sea使用Salt安装Ceph。 
 
jaas.ai/ceph-mon使用Juju安装Ceph。 
 
github.com/openstack/puppet-ceph通过Puppet安装Ceph。 
 
Ceph也可以手动安装。