

jaas.ai/ceph-mon使用Juju安装ceph。

github.com/openstack/puppet-ceph通过puppet安装ceph。

Ceph也可以手动安装。

窗户

有关Windows安装，请参阅以下文档：Windows安装指南。

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

>>>>>>> 5658cd99704bab4f76b71fa564725144fec43e33

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


| 节点  | IP           | 组件 |
| ----- | ------------ | ---- |
| node1 | 192.168.1.10 | MON1 |
| node2 | 192.168.1.11 | OSD1 |
| node3 | 192.168.1.12 | OSD2 |

## 手动安装

# 安装（手动）

## 获取软件

获取 Ceph 软件的方法有多种，最简单、通用的[获取软件包](http://docs.ceph.org.cn/install/get-packages)方法是添加软件源之后通过包管理工具（像 APT 、 YUM ）操作；也可以直接从 Ceph 仓库下载预编译软件包；最后，你可以下载源码包或克隆 Ceph 源码库、并自行编译。

- [     获取二进制包](http://docs.ceph.org.cn/install/get-packages/)
- [     获取源码包](http://docs.ceph.org.cn/install/get-tarballs/)
- [     克隆源码](http://docs.ceph.org.cn/install/clone-source/)
- [     构建 Ceph](http://docs.ceph.org.cn/install/build-ceph/)

## 安装软件

获取到（或者软件库里有） Ceph 软件包之后，安装很简单。要在集群内的各[*节点*](http://docs.ceph.org.cn/glossary/#term-)安装，你可以用 `ceph-deploy` 、或者包管理工具。如果你想安装 Ceph 对象网关、或 QEMU ，那么对于使用 `yum` 的发行版，你应该设置软件库优先级。

- [     安装 ceph-deploy](http://docs.ceph.org.cn/install/install-ceph-deploy/)
- [     安装 Ceph 存储集群](http://docs.ceph.org.cn/install/install-storage-cluster/)
- [     安装 Ceph 对象网关](http://docs.ceph.org.cn/install/install-ceph-gateway/)
- [     作为虚拟化的块设备](http://docs.ceph.org.cn/install/install-vm-cloud/)

## 手动部署集群

把 Ceph 二进制包安装到各节点后，你也可以手动部署集群。手动过程主要是让部署脚本（如 Chef、Juju、Puppet 等）的开发者们验证程序的。

- 手动部署
  - [监视器的自举引导](http://docs.ceph.org.cn/install/manual-deployment/#id2)
  - 添加 OSD
    - [精简型](http://docs.ceph.org.cn/install/manual-deployment/#id3)
    - [细致型](http://docs.ceph.org.cn/install/manual-deployment/#id4)
  - [总结](http://docs.ceph.org.cn/install/manual-deployment/#id5)

## 升级软件

随着新版 Ceph 的发布，你也许想升级集群以使用新功能，升级集群前请参考升级文档。有时候，升级 Ceph 需要严格按照升级顺序进行。

- 升级 Ceph
  - [概述](http://docs.ceph.org.cn/install/upgrading-ceph/#id1)
  - [ceph-deploy 工具](http://docs.ceph.org.cn/install/upgrading-ceph/#ceph-deploy)
  - [Argonaut 到 Bobtail](http://docs.ceph.org.cn/install/upgrading-ceph/#argonaut-bobtail)
  - [Argonaut 到 Cuttlefish](http://docs.ceph.org.cn/install/upgrading-ceph/#argonaut-cuttlefish)
  - [Bobtail 到 Cuttlefish](http://docs.ceph.org.cn/install/upgrading-ceph/#bobtail-cuttlefish)
  - [Cuttlefish 到 Dumpling](http://docs.ceph.org.cn/install/upgrading-ceph/#cuttlefish-dumpling)
  - [Dumpling 到 Emperor](http://docs.ceph.org.cn/install/upgrading-ceph/#dumpling-emperor)
  - [Dumpling 到 Firefly](http://docs.ceph.org.cn/install/upgrading-ceph/#dumpling-firefly)
  - [Emperor 到 Firefly](http://docs.ceph.org.cn/install/upgrading-ceph/#emperor-firefly)
  - [升级过程](http://docs.ceph.org.cn/install/upgrading-ceph/#id15)
  - [迁移到 ceph-deploy](http://docs.ceph.org.cn/install/upgrading-ceph/#id19)

# 获取二进制包

要安装 Ceph 及其依赖软件，你需要参考本手册从 Ceph 软件库下载，然后继续看[安装 Ceph 对象存储](http://docs.ceph.org.cn/install/install-storage-cluster)。

## 获取软件包

有两种方法获取软件包：

- **增加源：** 增加源是获取二进制包的最简方法，因为多数情况下包管理工具都能自动下载、并解决依赖关系。然而，这种方法要求各 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)都能连接互联网。
- **手动下载：** 如果你的环境不允许 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)访问互联网，手动下载软件包安装 Ceph 也不复杂。

## 准备工作

所有 Ceph 部署都需要 Ceph 软件包（除非是开发），你应该安装相应的密钥和推荐的软件包。

- **密钥：（推荐）** 不管你是用仓库还是手动下载，你都需要用密钥校验软件包。如果你没有密钥，就会收到安全警告。有两个密钥：一个用于发布（常用）、一个用于开发（仅适用于程序员和 QA ），请按需选择，详情见[安装密钥](http://docs.ceph.org.cn/install/get-packages/#id4)。
- **Ceph:（必要）** 所有 Ceph 部署都需要 Ceph 发布的软件包，除非你部署开发版软件包（仅有开发版、 QA 、和尖端部署）。详情见[添加 Ceph 库](http://docs.ceph.org.cn/install/get-packages/#ceph)。
- **Ceph Development:（可选）** 如果你在做 Ceph 开发、为 Ceph 做构建测试、或者急需开发版中的尖端功能，可以安装开发版软件包，详情见 [添加 Ceph 开发库](http://docs.ceph.org.cn/install/get-packages/#id7) 。
- **Apache/FastCGI:（可选）** 如果你想部署 [*Ceph 对象存储*](http://docs.ceph.org.cn/glossary/#term-30)服务，那么必须安装 Apache 和 FastCGI 。 Ceph 库提供的 Apache 和 FastCGI 二进制包和来自 Apache 的是一样的，但它打开了 100-continue 支持。如果你想启用 [*Ceph 对象网关*](http://docs.ceph.org.cn/glossary/#term-34)、且支持 100-continue ，那必须从 Ceph 库下载 Apache/FastCGI 软件包。详情见[添加 Apache/CGI 源](http://docs.ceph.org.cn/install/get-packages/#apache-cgi)。

如果你想手动下载二进制包，请参考[下载软件包](http://docs.ceph.org.cn/install/get-packages/#id12)。

## 安装密钥

把密钥加入你系统的可信密钥列表内，以消除安全告警。对主要发行版（如 `dumpling` 、 `emperor` 、 `firefly` ）和开发版（如 `release-name-rc1` 、 `release-name-rc2` ）应该用 `release.asc` 密钥；开发中的测试版应使用 `autobuild.asc` 密钥（开发者和 QA ）。

### APT

执行下列命令安装 `release.asc` 内的密钥：

```
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
```

执行下列命令安装 `autobuild.asc` 密钥（仅适用于 QA 和开发者）：

```
wget -q -O- 'https://download.ceph.com/keys/autobuild.asc' | sudo apt-key add -
```

### RPM

执行下列命令安装 `release.asc` 密钥：

```
sudo rpm --import 'https://download.ceph.com/keys/release.asc'
```

执行下列命令安装 `autobuild.asc` 密钥（仅对 QA 和开发者）：

```
sudo rpm --import 'https://download.ceph.com/keys/autobuild.asc'
```



## 镜像

为提升用户体验，世界各地有多个 Ceph 镜像。

这些镜像位于如下地点：

- **EU**: http://eu.ceph.com/
- **AU**: http://au.ceph.com/

你可以把所有的 ceph.com URL 替换成任意镜像，例如：

> http://download.ceph.com/debian-hammer

可以改成：

> http://eu.ceph.com/debian-hammer

## 添加 Ceph 库

发布库用 `release.asc` 公钥校验软件包。要通过 APT 或 YUM 安装 Ceph 二进制包，必须先配置库。

适合 Debian/Ubuntu 的包位于：

```
http://download.ceph.com/debian-{release-name}
```

适合 CentOS/RHEL 和其他发行版（通过 YUM 安装）的包位于：

```
http://download.ceph.com/rpm-{release-name}
```

Ceph 的主要发布包括：

- **Hammer:** 是最新的，也是 Ceph 的第八个重要发布。这些包适合于生产环境，重要的缺陷修正会移植回来、并在必要时发布修正版。
- **Giant:** 是 Ceph 的第六个重要发布。这些包适合于生产环境，重要的缺陷修正会移植回来、并在必要时发布修正版。
- **Firefly:** 是 Ceph 的第六个重要发布。这些包适合于生产环境，重要的缺陷修正会移植回来、并在必要时发布修正版。
- **Emperor:** 是 Ceph 的第五个重要发布。这些包比较老了，而且已不再维护了，所以我们建议升级到 Firefly 。
- **Argonaut, Bobtail, Cuttlefish, Dumpling:** 这些是 Ceph 的前 4 个主要发布，它们都很老了，且不再维护，所以请升级到近期版本。

Tip

对国际用户来说，在全球有很多镜像可用。请参考 [*镜像*](http://docs.ceph.org.cn/install/get-packages/#mirrors) 。

### Debian 二进制包

把 Ceph 库加入系统级 APT 源列表。在较新版本的 Debian/Ubuntu 上，用命令 `lsb_release -sc` 可获取短代码名，然后用它替换下列命令里的 `{codename}` 。

```
sudo apt-add-repository 'deb http://download.ceph.com/debian-firefly/ {codename} main'
```

对于早期 Linux 发行版，你可以执行下列命令：

```
echo deb http://download.ceph.com/debian-firefly/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

对于早期 Ceph 发布，可用 Ceph 发布名替换 `{release-name}` 。用命令 `lsb_release -sc` 可获取短代码名，然后用它替换下列命令里的 `{codename}` 。

```
sudo apt-add-repository 'deb http://download.ceph.com/debian-{release-name}/ {codename} main'
```

对较老的 Linux 发行版，用发布名替换 `{release-name}` 。

```
echo deb http://download.ceph.com/debian-{release-name}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

要在 ARM 处理器上运行 Ceph 的话，需要 Google 的内存剖析工具（ `google-perftools` ）， Ceph 库里有： http://download.ceph.com/packages/google-perftools/debian 。

```
echo deb http://download.ceph.com/packages/google-perftools/debian  $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/google-perftools.list
```

对于开发版，把我们的软件库加入 APT 源。这里 [Debian 测试版软件库](http://download.ceph.com/debian-testing/dists) 是已支持的 Debian/Ubuntu 列表。

```
echo deb http://download.ceph.com/debian-testing/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

Tip

对国际用户来说，在全球有很多镜像可用。请参考 [*镜像*](http://docs.ceph.org.cn/install/get-packages/#mirrors) 。

### RPM 二进制包

对于主要发布，你可以在 `/etc/yum.repos.d/` 目录下新增一个 Ceph 库：创建 `ceph.repo` 。在下例中，需要用 Ceph 主要发布名（如 `dumpling` 、 `emperor` ）替换 `{ceph-release}` 、用 Linux 发行版名（ `el6` 、 `rhel6` 等）替换 `{distro}` 。你可以到 http://download.ceph.com/rpm-{ceph-release}/ 看看 Ceph 支持哪些发行版。有些 Ceph 包（如 EPEL ）必须优先于标准包，所以你必须确保设置了 `priority=2` 。

```
[ceph]
name=Ceph packages for $basearch
baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
```

如果想用开发版，你也可以用相应配置：

```
[ceph]
name=Ceph packages for $basearch/$releasever
baseurl=http://download.ceph.com/rpm-testing/{distro}/$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://download.ceph.com/rpm-testing/{distro}/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://download.ceph.com/rpm-testing/{distro}/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
```

对于某些包，你可以通过名字直接下载。按照我们的开发进度，每 3-4 周会发布一次。这些包的变动比主要发布频繁，开发版会迅速地集成新功能，然而这些新功能需要几周时间的质检才会发布。

软件库包会把软件库的具体配置安装到本机，以便 `yum` 或 `up2date` 使用。把 `{distro}` 替换成你的 Linux 发行版名字，把 `{release}` 换成 Ceph 的某个发布名。

```
su -c 'rpm -Uvh http://download.ceph.com/rpms/{distro}/x86_64/ceph-{release}.el6.noarch.rpm'
```

你可以从这个地址直接下载 RPM ：

```
http://download.ceph.com/rpm-testing
```

Tip

对国际用户来说，在全球有很多镜像可用。请参考 [*镜像*](http://docs.ceph.org.cn/install/get-packages/#mirrors) 。

## 添加 Ceph 开发库

开发库用 `autobuild.asc` 密钥校验软件包。如果你在参与 Ceph 开发，想要部署并测试某个分支，确保先删除（或禁用）主要版本库的配置文件。

### Debian 二进制包

我们自动为 Debian 和 Ubuntu 构建 Ceph 当前分支的二进制包，这些包只适合开发者和质检人员。

把此仓库加入 APT 源，用你要测试的分支名（如 chef-3 、 wip-hack 、 master ）替换 `{BRANCH}` 。我们所构建的完整分支列表在 [the gitbuilder page](http://gitbuilder.ceph.com) 。

```
echo deb http://gitbuilder.ceph.com/ceph-deb-$(lsb_release -sc)-x86_64-basic/ref/{BRANCH} $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

### RPM 二进制包

对于当前开发分支，你可以在 `/etc/yum.repos.d/` 目录下创建 `ceph.repo` 文件，内容如下，用你的 Linux 发行版名字（ `centos6` 、 `rhel6` 等）替换 `{distro}` 、用你想安装的分支名替换 `{branch}` 。

```
[ceph-source]
name=Ceph source packages
baseurl=http://gitbuilder.ceph.com/ceph-rpm-{distro}-x86_64-basic/ref/{branch}/SRPMS
enabled=0
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc
```

你可以到 http://gitbuilder.ceph.com 查看 Ceph 支持哪些发行版。

## 添加 Apache/CGI 源

Ceph 对象存储与普通的 Apache 和 FastCGI 库对接，只是 Ceph 要求 Apache 和 FastCGI 支持 100-continue 功能。请配置相应的软件库，以使用对应的 Apache 和 FastCGI 包。

### Debian 二进制包

如果想要 100-continue 功能，请把我们的源加入 APT 源列表。

```
echo deb http://gitbuilder.ceph.com/apache2-deb-$(lsb_release -sc)-x86_64-basic/ref/master $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph-apache.list
echo deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-$(lsb_release -sc)-x86_64-basic/ref/master $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph-fastcgi.list
```

### RPM 二进制包

你可以在 `/etc/yum.repos.d/` 目录下创建 `ceph-apache.repo` 文件，内容如下，用你的 Linux 发行版名字（如 `el6` 、 `rhel6` ）替换 `{distro}` ， http://gitbuilder.ceph.com 列出了支持的发行版。

```
[apache2-ceph-noarch]
name=Apache noarch packages for Ceph
baseurl=http://gitbuilder.ceph.com/apache2-rpm-{distro}-x86_64-basic/ref/master
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc

[apache2-ceph-source]
name=Apache source packages for Ceph
baseurl=http://gitbuilder.ceph.com/apache2-rpm-{distro}-x86_64-basic/ref/master
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc
```

仿照前述步骤创建 `ceph-fastcgi.repo` 文件。

```
[fastcgi-ceph-basearch]
name=FastCGI basearch packages for Ceph
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-{distro}-x86_64-basic/ref/master
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc

[fastcgi-ceph-noarch]
name=FastCGI noarch packages for Ceph
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-{distro}-x86_64-basic/ref/master
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc

[fastcgi-ceph-source]
name=FastCGI source packages for Ceph
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-{distro}-x86_64-basic/ref/master
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/autobuild.asc
```

## 下载软件包

如果你位于防火墙之内，不能访问互联网，那你必须先下载齐所需软件包（镜像所有依赖）。

### Debian 二进制包

Ceph 依赖这些第三方库。

- libaio1
- libsnappy1
- libcurl3
- curl
- libgoogle-perftools4
- google-perftools
- libleveldb1

这个软件库包会装好所需的 `apt` 软件库的配置文件。需用最新 Ceph 发布替换掉 `{release}` 、用最新 Ceph 版本号替换 `{version}` 、用自己的 Linux 发行版代号替换 `{distro}` 、用自己的 CPU 架构替换 `{arch}` 。

```
wget -q http://download.ceph.com/debian-{release}/pool/main/c/ceph/ceph_{version}{distro}_{arch}.deb
```

### RPM 二进制包

Ceph 依赖一些第三方库。执行下列命令添加 EPEL 库：

```
su -c 'rpm -Uvh http://download.ceph.com/rpm-firefly/{distro}/noarch/ceph-{version}.{distro}.noarch.rpm'
```

Ceph依赖下列包：

- snappy
- leveldb
- gdisk
- python-argparse
- gperftools-libs

当前，我们为这些平台 RHEL/CentOS6 （ `el6` ）、 Fedora 18 和 19 （ `f18` 和 `f19` ）、 OpenSUSE 12.2 （ `opensuse12.2` ）和 SLES （ `sles11` ）分别构建二进制包，仓库包会在本地系统上装好 Ceph 库配置文件，这样 `yum` 或 `up2date` 就可以使用这些配置文件自动安装了。用自己的发行版名字替换 `{distro}` 。

```
su -c 'rpm -Uvh http://download.ceph.com/rpm-firefly/{distro}/noarch/ceph-{version}.{distro}.noarch.rpm'
```

例如，对于 CentOS 6 （ `el6` ）：

```
su -c 'rpm -Uvh http://download.ceph.com/rpm-firefly/el6/noarch/ceph-release-1-0.el6.noarch.rpm'
```

你可以从这里直接下载RPM包：

```
http://download.ceph.com/rpm-firefly
```

对较老的 Ceph 发布，用 Ceph 发布名替换 `{release-name}` ，你可以执行 `lsb_release -sc` 命令获取发行版代号。

```
su -c 'rpm -Uvh http://download.ceph.com/rpm-{release-name}/{distro}/noarch/ceph-{version}.{distro}.noarch.rpm'
```

# 下载 Ceph 源码包

随着 Ceph 开发的推进， Ceph 团队会不断发布源码，你可以在以下这些地方下载发布的源码：

[Ceph 发布的源码包](http://ceph.com/download/)

[Ceph 发布的源码包（欧洲镜像）](http://eu.ceph.com/download/)

# 克隆 Ceph 源码库

你可以去[位于 github 的 Ceph 源码库](https://github.com/ceph/ceph)克隆某个 Ceph 分支，先选择一个分支（默认是 `master` ），然后点击 **Download ZIP** 按钮。

要克隆整个 git 源码库，你得先安装、配置 `git` 。

## 安装 Git

在 Debian/Ubuntu 上执行下列命令安装 `git` ：

```
sudo apt-get install git
```

在 CentOS/RHEL 上执行下列命令安装 `git` ：

```
sudo yum install git
```

相应地，你必须有 `github` 帐户。如果你还没有，去 [github.com](http://github.com) 注册一个，然后按照[设置 Git](http://help.github.com/linux-set-up-git) 指引配置 git 。

## 添加 SSH 密钥（可选）

如果你计划向 Ceph 贡献代码、或者想通过 SSH 克隆（ `git@github.com:ceph/ceph.git` ），你必须生成一个 SSH 密钥对。

Tip

如果你只是想克隆，不需要 SSH 密钥也可用 `git clone --recursive https://github.com/ceph/ceph.git` 克隆。

执行如下命令生成 SSH 密钥对用于 `github` ：

```
ssh-keygen
```

把此密钥对的公钥加入 `github` 帐户（本例假设用了默认路径）：

```
cat .ssh/id_rsa.pub
```

复制公钥。

进入 `github` 帐户，点击 “Account Settings” （即 `tools` 图标），然后点击导航条左边的 “SSH Keys” 。

点击 “SSH Keys” 列表里的 “Add SSH key” ，给密钥起个名字，把复制的公钥粘帖进去，最后点击 “Add key” 按钮。

## 克隆源码

执行下列命令克隆源码库：

```
git clone --recursive https://github.com/ceph/ceph.git
```

`git clone` 完成后，你应该已经得到了一份完整的 Ceph 源码库。

Tip

确保你获取到的源码库之内的各子模块都是最新的，运行 `git status` 确认。

```
cd ceph
git status
```

如果你的子模块过时了，运行：

```
git submodule update --force --init --recursive
```

## 选择分支

克隆完源码和子模块后，你的源码库将默认位于 `master` 分支上，这是个不稳定开发分支，你也可以切换到其他分支上。

- `master`: 不稳定开发分支；
- `stable`: 缺陷修正分支；
- `next`: 发布候选分支。

```
git checkout master
```

# 构建 Ceph

你可以下载 Ceph 源码并自行构建。首先，你得准备开发环境、编译 Ceph 、然后安装到用户区或者构建二进制包并安装。

## 构建依赖

Tip

对照本段检查下你的 Linux/Unix 发行版是否满足这些依赖。

构建 Ceph 源码前，你得先安装几个库和工具：

```
./install-deps.sh
```

Note

在某些支持 Google 内存剖析工具的发行版上，名字未必如此（如 `libgoogle-perftools4` ）。

## 构建 Ceph

Ceph 用 `automake` 和 `configure` 脚本简化构建过程。先进入刚克隆的 Ceph 源码库，执行下列命令开始构建：

```
cd ceph
./autogen.sh
./configure
make
```

超线程

你可以根据自己的硬件配置情况用 `make -j` 并行编译，比如在双核处理器上用 `make -j4` 可能会编译得快些。

参考[安装自构建软件](http://docs.ceph.org.cn/install/install-storage-cluster#installing-a-build)把构建好的软件安装到用户区。

## 构建 Ceph 安装包

要构建安装包，你必须克隆 [Ceph](http://docs.ceph.org.cn/install/clone-source) 源码库。用 `dpkg-buildpackage` 基于最新代码为 Debian/Ubuntu 创建安装包；用 `rpmbuild` 为 RPM 包管理器创建安装包。

Tip

在多核 CPU 上构建时，用参数 `-j` 、再加上核心数的 2 倍数，例如在双核处理器上用 `-j4` 来加速构建。

### 高级打包工具（ APT ）

要为 Debian/Ubuntu 创建 `.deb` 安装包，先要克隆 Ceph 源码库、安装好必要的[构建依赖](http://docs.ceph.org.cn/install/build-ceph/#id1)和 `debhelper` 。

```
sudo apt-get install debhelper
```

装好 `debhelper` 之后就可以开始构建安装包了：

```
sudo dpkg-buildpackage
```

在多核处理器上可以用 `-j` 加快构建速度。

### RPM 包管理器

要创建 `.rpm` 包，先得克隆 [Ceph](http://docs.ceph.org.cn/install/clone-source) 源码库、安装必要的[构建依赖](http://docs.ceph.org.cn/install/build-ceph/#id1)、安装好 `rpm-build` 和 `rpmdevtools` ：

```
yum install rpm-build rpmdevtools
```

安装完这些工具后，设置 RPM 编译环境：

```
rpmdev-setuptree
```

下载源码包，编译 RPM 时需要：

```
wget -P ~/rpmbuild/SOURCES/ http://ceph.com/download/ceph-<version>.tar.bz2
```

或者从欧洲镜像下载：

```
wget -P ~/rpmbuild/SOURCES/ http://eu.ceph.com/download/ceph-<version>.tar.bz2
```

提取规范文件：

```
tar --strip-components=1 -C ~/rpmbuild/SPECS/ --no-anchored -xvjf ~/rpmbuild/SOURCES/ceph-<version>.tar.bz2 "ceph.spec"
```

开始构建 RPM 包：

```
rpmbuild -ba ~/rpmbuild/SPECS/ceph.spec
```

在多核处理器上可以用 `-j` 加快构建速度。

# 安装 ceph-deploy

`ceph-deploy` 工具可用来装配起或拆除 Ceph 集群，方便了开发、测试和概念验证项目。

## APT

要用 `apt` 安装 `ceph-deploy` ，用此命令：

```
sudo apt-get update && sudo apt-get install ceph-deploy
```

## RPM

要用 `yum` 安装 `ceph-deploy` ，用此命令：

```
sudo yum install ceph-deploy
```

# 安装 Ceph 存储集群

本指南说明了如何手动安装 Ceph 软件包，此方法只适用于那些没采用部署工具（如 `ceph-deploy` 、 `chef` 、 `juju` 等）的用户。

Tip

你也可以用 `ceph-deploy` 安装 Ceph 软件包，也许它更方便，因为只需一个命令就可以把 `ceph` 安装到多台主机。

## 用 APT 安装

只要把正式版或开发版软件包源加入了 APT ，你就可以更新 APT 数据库并安装 Ceph 了：

```
sudo apt-get update && sudo apt-get install ceph ceph-mds
```

## 用 RPM 安装

要用 RPM 安装 Ceph ，可按如下步骤进行：

1. 安装 `yum-plugin-priorities` 。

   ```
   sudo yum install yum-plugin-priorities
   ```

2. 确认 `/etc/yum/pluginconf.d/priorities.conf` 文件存在。

3. 确认 `priorities.conf` 里面打开了插件支持。

   ```
   [main]
   enabled = 1
   ```

4. 确认你的 YUM `ceph.repo` 库文件条目包含 `priority=2` ，详情见[获取软件包](http://docs.ceph.org.cn/install/get-packages)：

   ```
   [ceph]
   name=Ceph packages for $basearch
   baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/$basearch
   enabled=1
   priority=2
   gpgcheck=1
   type=rpm-md
   gpgkey=https://download.ceph.com/keys/release.asc
   
   [ceph-noarch]
   name=Ceph noarch packages
   baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
   enabled=1
   priority=2
   gpgcheck=1
   type=rpm-md
   gpgkey=https://download.ceph.com/keys/release.asc
   
   [ceph-source]
   name=Ceph source packages
   baseurl=http://download.ceph.com/rpm-{ceph-release}/{distro}/SRPMS
   enabled=0
   priority=2
   gpgcheck=1
   type=rpm-md
   gpgkey=https://download.ceph.com/keys/release.asc
   ```

5. 安装依赖的的软件包：

   ```
   sudo yum install snappy leveldb gdisk python-argparse gperftools-libs
   ```

成功添加正式版或开发版软件包的库文件之后，或把 `ceph.repo` 文件放入 `/etc/yum.repos.d` 之后，你就可以安装 Ceph 软件包了。

```
sudo yum install ceph
```

## 从源码安装

如果你是从源码构建的 Ceph ，可以用下面的命令安装到用户区：

```
sudo make install
```

如果你是本地安装的， `make` 会把可执行文件放到 `usr/local/bin` 里面。你可以把 Ceph 配置文件放到 `usr/local/bin` 目录下，这样就能从这个目录运行 Ceph 了。



### 共同配置

#### 1. ceph安装

```bash
# Ubuntu
wget -q -O- https://raw.github.com/ceph/ceph/master/keys/release.asc > cephkey.asc
sudo apt-key add cephkey.asc
sudo echo deb http://ceph.newdream.net/debian precise main | sudo tee /etc/apt/sources.list.d/ceph.list
sudo apt update
sudo apt install ceph
```

#### 2. 创建hosts文件

```bash
# 追加内容：
192.168.1.10	node1
192.168.1.11	node2
192.168.1.12	node3
```

#### 3.

## ceph-deploy 部署工具安装

=======
![img](https://upload-images.jianshu.io/upload_images/12979420-fff933086b4c8898.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/638/format/webp)

>>>>>>> 5658cd99704bab4f76b71fa564725144fec43e33

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

 



