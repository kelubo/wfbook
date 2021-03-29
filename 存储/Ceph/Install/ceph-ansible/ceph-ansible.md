# ceph-ansible

[TOC]

##  安装ceph-ansible

支持在线和离线两种安装方式，都仅需在管理节点上进行操作。

```bash
yum -y install ansible
# 在线方式安装
yum -y install git
git config --global http.sslVerify false
# 配置http.sslVerify参数为false，跳过系统证书
git clone -b stable-6.0 https://github.com/ceph/ceph-ansible.git --recursive
#===========================================================================
# 离线方式安装
unzip /root/ceph-ansible-stable-4.0.zip
# 安装ceph-ansible依赖
yum install -y python-pip
pip install --upgrade pip==19.3.1
cd /root/ceph-ansible/
pip install -r requirements.txt
```

## 解决环境依赖问题

所有节点安装依赖。

```bash
yum install -y yum-plugin-priorities
```

解决rpm_key依赖问题

```yml
# 编辑redhat_community_repository.yml
vim /root/ceph-ansible/roles/ceph-common/tasks/installs/redhat_community_repository.yml
# 注释如下内容
- name: configure red hat ceph community repository stable key
  rpm_key:
    key: "{{ ceph_stable_key }}"
    state: present
  register: result
  until: result is succeeded
```

解决grafana依赖问题。

```yml
# 编辑configure_grafana.yml
vim /home/ceph-ansible/roles/ceph-grafana/tasks/configure_grafana.yml
# 注释如下内容
- name: wait for grafana to start
  wait_for:
    host: '{{ grafana_server_addr }}'
    port: '{{ grafana_port }}'
```

## 创建服务节点配置列表

在ceph-ansible目录内新建hosts文件。

```bash
vi /root/ceph-ansible/hosts

[mons]
ceph1

[mgrs]
ceph1

[osds]
ceph1
ceph2

[mdss]
ceph1

[rgws]
ceph1

[clients]
ceph1
ceph2

[grafana-server]
ceph1
```

该操作用于定义集群中的主机，以及每个主机在Ceph集群中扮演的角色。可根据整个集群的需要在集群节点上部署相应的应用。

## 修改ceph-ansible配置文件

需要修改相应的playbook名称，然后修改对应的内容，使之满足集群部署的要求。所有选项及默认配置放在“group_vars”目录下，每种Ceph进程对应相关的配置文件。

```bash
cd /root/ceph-ansible/group_vars/
cp mons.yml.sample mons.yml
cp mgrs.yml.sample mgrs.yml
cp mdss.yml.sample mdss.yml
cp rgws.yml.sample rgws.yml
cp osds.yml.sample osds.yml
cp clients.yml.sample clients.yml
cp all.yml.sample all.yml            
# all.yml.sample是应用于集群所有主机的特殊配置文件
```

### 添加ceph.conf配置参数

`all.yml`文件中，`ceph_conf_overrides` 变量可用于覆盖 `ceph.conf` 中已配置的选项，或是增加新选项。

```yml
vim all.yml
# 添加如下内容
ceph_conf_overrides:
global:
osd_pool_default_pg_num: 64
osd_pool_default_pgp_num: 64
osd_pool_default_size: 2
mon:
mon_allow_pool_create: true 
```

### 定义Ceph集群配置

修改 `group_vars` 目录下 `all.yml` 文件的内容，主要包括：

1. 配置Ceph下载方式，版本信息。
2. 基本的网络信息。
3. OSD类型。

```yml
vim group_vars/all.yml
# 在线安装方式
ceph_origin: repository
ceph_repository: community
ceph_mirror: http://download.ceph.com
ceph_stable_release: nautilus
ceph_stable_repo: "{{ ceph_mirror }}/rpm-{{ ceph_stable_release }}"
ceph_stable_redhat_distro: el7
# 网口设备号
monitor_interface: enp133s0
journal_size: 5120
# Public Network的IP地址和掩码
public_network: 172.19.106.0/0
# Cluster Network的IP地址和掩码
cluster_network: 172.19.106.0/0
osd_objectstore: bluestore
#====================================================================

# 离线安装方式
ceph_origin: distro
ceph_repository: local
ceph_stable_release: nautilus
```

### 定义OSD

`osds.yml` 支持两种方式设置OSD（object storage device）盘、WAL（write ahead log）盘和DB（data base）盘。

#### 方法一：ceph-volume lvm batch方式

修改 `groups_vars` 路径下的 `osds.yml` 文件，根据需要指定`devices`，`dedicated_devices` 和 `bluestore_wal_devices` 中的设备：

```yml
# Declare devices to be used as OSDs
# All scenario(except 3rd) inherit from the following device declaration
# Note: This scenario uses the ceph-volume lvm batch method to provision OSDs

devices:
  - /dev/sdd
  - /dev/sde
  - /dev/sdf
  - /dev/sdg
# devices表示系统中的数据盘，可以与osds_per_device选项结合，设置每个磁盘上创建的OSD数量。

#devices: []

# Declare devices to be used as block.db devices

dedicated_devices:
  - /dev/sdb
# dedicated_devices即block.db

#dedicated_devices: []

# Declare devices to be used as block.wal devices

bluestore_wal_devices:
  - /dev/sdc
# bluestore_wal_devices即block.wal

#bluestore_wal_devices: []

# dedicated_devices和bluestore_wal_devices的磁盘不能为相同磁盘
# dedicated_devices和bluestore_wal_devices可以包含一个或多个磁盘
# 系统会根据devices中的磁盘数量，以及osds_per_device，将dedicated_devices和bluestore_wal_devices下的磁盘进行均分
# 单个OSD的block.db大于等于50GB，否则可能会以为block.db过小而安装报错
```

#### 方法二：ceph-volume，从逻辑卷中创建osd

修改 `groups_vars` 路径下的 `osds.yml` 文件，根据需要指定 `lvm_volumes` 属性下的所有OSD设备，包含几种不同的组合场景：

- 只指定数据盘。

- 指定数据盘+WAL。

- 指定数据盘+WAL+DB。

- 指定数据盘+DB。

使用此模式时需要事先在所有集群节点上创建对应的逻辑卷

```bash
vgcreate -s 1G ceph-data /dev/sdd
# -s指定创建逻辑卷的基本单位
lvcreate -l 300 -n osd-data1 ceph-data

lvs
LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
home      centos    -wi-ao---- 839.05g
root      centos    -wi-ao----  50.00g
swap      centos    -wi-a-----   4.00g
osd-data1 ceph-data -wi-ao---- 300.00g
osd-db1   ceph-db   -wi-ao---- 100.00g
osd-wal1  ceph-wal  -wi-ao----  50.00g
```

以下为创建两个OSD，每个OSD都包含DB和WAL盘的场景：

```yml
# Bluestore: Each dictionary must contain at least data. When defining wal or
# db, it must have both the lv name and vg group (db and wal are not required).
# This allows for four combinations: just data, data and wal, data and wal and
# db, data and db.
# For example:
lvm_volumes:
  - data: osd-data1
    data_vg:ceph-data
    wal: osd-wal1
    wal_vg:ceph-wal
    db: osd-db1
    db_vg: ceph-db
  - data: osd-data2
    data_vg:ceph-data
    wal: osd-wal2
    wal_vg:ceph-wal
    db: osd-db2
    db_vg: ceph-db
```

### 块存储配置

块存储场景必须的服务需求包括mons和osds。

```yml
cp site.yml.sample site.yml

vim site.yml
- hosts:
  - mons
  - osds
```

### 文件存储配置

```yml
vim site.yml
- hosts:
  - mons
  - osds
  - mdss
```







通过查找CephFS关键字，修改配置如下。



- Ceph在线下载方式：

  ```
  ceph_origin: repository
  ceph_repository: community
  ceph_mirror: http://download.ceph.com
  ceph_stable_release: nautilus
  ceph_stable_repo: "{{ ceph_mirror }}/rpm-{{ ceph_stable_release }}"
  ceph_stable_redhat_distro: el7
  monitor_interface: enp133s0
  journal_size: 5120
  public_network: 172.19.106.0/0
  cluster_network: 172.19.106.0/0
  osd_objectstore: bluestore
  # CEPHFS 
  # ##########
  cephfs: cephfs # name of the ceph filesystem cephfs_data_pool: name: "{{ cephfs_data if cephfs_data is defined else 'cephfs_data' }}" pg_num: "{{ osd_pool_default_pg_num }}" pgp_num: "{{ osd_pool_default_pg_num }}" rule_name: "replicated_rule" type: 1 #  erasure_profile: "" #  expected_num_objects: "" application: "cephfs" size: "{{ osd_pool_default_size }}" min_size: "{{ osd_pool_default_min_size }}" cephfs_metadata_pool: name: "{{ cephfs_metadata if cephfs_metadata is defined else 'cephfs_metadata' }}" pg_num: "{{ osd_pool_default_pg_num }}" pgp_num: "{{ osd_pool_defaultpg_num }}" rule_name: "replicated_rule" type: 1 #  erasure_profile: "" #  expected_num_objects: "" application: "cephfs" size: "{{ osd_pool_default_size }}" min_size: "{{ osd_pool_default_min_size }}" cephfs_pools: - "{{ cephfs_data_pool }}" - "{{ cephfs_metadata_pool }}" 
  ```
  
  

### 对象存储配置

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 定义Ceph服务需求

1. 进入site.yml文件。

   

   `vim site.yml `





在“hosts”选项下，增加rgws的定义。



```
- hosts: - mons - osds #  - mdss - rgws #  - nfss #  - rbdmirrors - clients - mgrs #  - iscsigws #  - iscsi-gws # for backward compatibility only! #  - grafana-server #  - rgwloadbalancers 
```

1. 

   



#### 定义Ceph集群配置

在all.yml中，设置前端网络类型，端口，每个RGW节点的RGW实例数。

- Ceph在线下载方式：

  `ceph_origin: repository ceph_repository: community ceph_mirror: http://download.ceph.com ceph_stable_release: nautilus ceph_stable_repo: "{{ ceph_mirror }}/rpm-{{ ceph_stable_release }}" ceph_stable_redhat_distro: el7 monitor_interface: enp133s0 journal_size: 5120 public_network: 172.19.106.0/0 cluster_network: 172.19.106.0/0 osd_objectstore: bluestore  ## Rados Gateway options radosgw_frontend_type: beast radosgw_frontend_port: 12345 radosgw_interface: "{{monitor_interface}}" radosgw_num_instances: 3 `



部分参数填写说明如[表1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0007.html#kunpengcephansible_04_0007__table138855004414)所示。



| 参数                  | 说明                                                         |
| --------------------- | ------------------------------------------------------------ |
| monitor_interface     | Public Network的网口设备ID                                   |
| radosgw_frontend_type | RGW前端类型，根据需要选填                                    |
| radosgw_frontend_port | RGW前端端口，根据需要选填                                    |
| radosgw_num_instances | 设置每个节点上RGW的实例个数，此时RGW的访问端口基于radosgw_frontend_port指定的端口号递增 |

Ceph离线下载方式：

```
ceph_origin: distro ceph_repository: local ceph_stable_release: nautilus 
```

- 

#### 设置RGW服务的权限

在rgws.yml文件中设置RGW默认数据池和索引池的pg num和size，以及RGW服务能否访问私有设备的权限。

```
rgw_create_pools: defaults.rgw.buckets.data: pg_num: 8 size: "" defaults.rgw.buckets.index: pg_num: 8 size: "" ########### # SYSTEMD # ########### # ceph_rgw_systemd_overrides will override the systemd settings # for the ceph-rgw services. # For example,to set "PrivateDevices=false" you can specify: ceph_rgw_systemd_overrides: Service: PrivateDevices: False 
```



## Ceph集群部署



`ansible-playbook -i hosts site.yml `



执行结束，在执行页面会有相关的提示，如图所示，所有节点显示failed=0，则处于部署过程中。



查看集群健康状态，显示HEALTH_OK则集群状态健康。



```
ceph health 
```



2. Ceph-ansible部署Ceph集群后检查ceph.conf配置是否成功，配置皆写入ceph.conf则部署成功。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224823291.png)

   



# 集群扩容

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

- **[添加Ceph Monitor](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0010.html)**
- **[添加OSD节点部署](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0011.html)**
- **[添加MDS群组成员](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0014.html)**

​				

### 添加Ceph Monitor

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 前提条件

1. 通过Ansible部署的正常运行的Ceph集群。
2. 在新节点上具有root权限。

#### 操作步骤

1. 在集群的hosts文件的[mons]群组下添加新的Ceph Monitor节点。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0219370340.png)

   

2. 确认Ansible可以连接到节点。

   

   `ansible all -i hosts -m ping `





运行脚本。



- 方法一：

  切换到Ansible主目录，在主目录运行site.yml脚本。

  `ansible-playbook -i hosts site.yml `



方法二：

拷贝infrastructure-playbook/add-mon.yml到主目录下，然后运行脚本。

```
cp infrastructure-playbook/add-mon.yml add-mon.yml ansible-playbook -i hosts add-mon.yml 
```

### 添加OSD节点部署

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

- **[具有相同的磁盘拓扑](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0012.html)**
- **[具有不同的磁盘拓扑](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0013.html)**

**父主题：** [集群扩容](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0009.html)

​					 					 [上一篇：添加Ceph Monitor 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0010.html) 				 				 			

​					 					 [下一篇：具有相同的磁盘拓扑](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0012.html) 				 				 			

# 具有相同的磁盘拓扑

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

Ansible将使用group_vars/osds.yml文件配置OSD。

#### 前提条件

1. 通过Ansible部署的正常运行的Ceph集群。
2. 在新节点上具有root权限。
3. 具有和集群中其他OSD节点相同数量的数据盘的节点。

#### 操作步骤

1. 在“/ceph-ansible/infrastructure-playbooks/”路径下有个add-osd.yml文件，复制到主目录下。

   

   `cp ./infrastructure-playbooks/add-osd.yml ./add-osd.yml `





在集群的hosts文件的[osds]群组下增加新的OSD节点名。



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0219373700.png)



确认Ansible可以连接到节点。



```
ansible all -i hosts -m ping 
```





运行脚本。



```
ansible-playbook -i host add-osd.yml 
```

# 具有不同的磁盘拓扑

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 前提条件

1. 通过Ansible部署的正常运行的Ceph集群。
2. 在新节点上具有root权限。

#### 操作步骤

1. 在集群的hosts文件的[osds]群组下增加新的OSD节点名，并在新增OSD节点名后写入需要的devices信息。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0219376673.png)

   

2. 确认Ansible能够连接节点。

   

   `ansible all -i hosts -m ping `





复制add-osd.yml到主目录。



```
cp ./infrastructure-playbooks/add-osd.yml ./add-osd.yml 
```





运行脚本。



```
ansible-playbook -i host add-osd.yml 
```

1. 

   

**父主题：** [添加OSD节点部署](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0011.html)

### 添加MDS群组成员

​                        更新时间：2021/03/03 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 前提条件

1. 通过Ansible部署的正常工作的Ceph集群。
2. 有安装了Ansible的管理节点。

#### 操作步骤

1. 在集群hosts文件中的[mdss]群组中添加新的MDS节点名。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0219380903.png)

   

2. 修改主目录下site.yml脚本里的mdss配置，将注释符删除。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0219380904.png)

   

3. 在主目录下运行脚本。

   

   `ansible-playbook -i hosts site.yml


# 删除集群

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

该操作仅需要在ceph1执行。

1. 执行删除命令。

   

   `ansible-playbook -i hosts infrastructure-playbooks/purge-cluster.yml `





输入yes确认删除。



```
Are you sure you want to purge the cluster? [no]:yes
```

# 更多资源

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 



#### repo源压缩包制作

1. 通过reposync命令批量下载EPEL repo镜像源的所有文件到主机。

   

   1. 下载

      epel.repo镜像库的文件

      。

      `reposync -r epel -p /opt/EPEL `



下载CentOS-Base.repo镜像库的文件。

```
reposync -r CentOS-Base -p /opt/CentOS-Base 
```



下载ceph.repo镜像库的文件。

```
reposync -r ceph -p /opt/ceph 
```

1. 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

/opt/epel、/opt/CentOS-Base、/opt/ceph是下载目的路径，如果不指定路径则保存在当前目录。



分别在“/opt/EPEL”、“/opt/CentOS-Base”和“/opt/ceph”目录下生成repodata文件。



```
yum install createrepo cd /opt/EPEL createrepo . cd /opt/CentOS-Base createrepo . cd /opt/ceph createrepo . 
```





把“/opt/EPEL”、“/opt/CentOS-Base”和“/opt/ceph”打包。



```
zip -r EPEL.zip /opt/EPEL zip -r CentOS-Base.zip /opt/CentOS-Base zip -r ceph.zip /opt/ceph 
```





通过刻盘或者移动存储介质将镜像源文件（EPEL.zip、CentOS-Base.zip和ceph.zip）转存到本地，搭建本地镜像库。









## Releases

The following branches should be used depending on your requirements. The `stable-*` branches have been QE tested and sometimes recieve backport fixes throughout their lifecycle. The `master` branch should be considered experimental and used with caution.

- `stable-3.0` Supports Ceph versions `jewel` and `luminous`. This branch requires Ansible version `2.4`.
- `stable-3.1` Supports Ceph versions `luminous` and `mimic`. This branch requires Ansible version `2.4`.
- `stable-3.2` Supports Ceph versions `luminous` and `mimic`. This branch requires Ansible version `2.6`.
- `stable-4.0` Supports Ceph version `nautilus`. This branch requires Ansible version `2.8`.
- `stable-5.0` Supports Ceph version `octopus`. This branch requires Ansible version `2.9`.
- `master` Supports the master branch of Ceph. This branch requires Ansible version `2.8`.

Note

`stable-3.0` and `stable-3.1` branches of ceph-ansible are deprecated and no longer maintained.

## Configuration and Usage

This project assumes you have a basic knowledge of how Ansible works and have already prepared your hosts for configuration by Ansible.

After you’ve cloned the `ceph-ansible` repository, selected your branch and installed Ansible then you’ll need to create your inventory file, playbook and configuration for your Ceph cluster.

### Inventory

The Ansible inventory file defines the hosts in your cluster and what roles each host plays in your Ceph cluster. The default location for an inventory file is `/etc/ansible/hosts` but this file can be placed anywhere and used with the `-i` flag of `ansible-playbook`.

An example inventory file would look like:

```
[mons]
mon1
mon2
mon3

[osds]
osd1
osd2
osd3
```

Note

For more information on Ansible inventories please refer to the Ansible documentation: http://docs.ansible.com/ansible/latest/intro_inventory.html

### Playbook

You must have a playbook to pass to the `ansible-playbook` command when deploying your cluster. There is a sample playbook at the root of the `ceph-ansible` project called `site.yml.sample`. This playbook should work fine for most usages, but it does include by default every daemon group which might not be appropriate for your cluster setup. Perform the following steps to prepare your playbook:

- Rename the sample playbook: `mv site.yml.sample site.yml`
- Modify the playbook as necessary for the requirements of your cluster

Note

It’s important the playbook you use is placed at the root of the `ceph-ansible` project. This is how Ansible will be able to find the roles that `ceph-ansible` provides.

### Configuration Validation

The `ceph-ansible` project provides config validation through the `ceph-validate` role. If you are using one of the provided playbooks this role will be run early in the deployment as to ensure you’ve given `ceph-ansible` the correct config. This check is only making sure that you’ve provided the proper config settings for your cluster, not that the values in them  will produce a healthy cluster. For example, if you give an incorrect  address for `monitor_address` then the mon will still fail to join the cluster.

An example of a validation failure might look like:

```
TASK [ceph-validate : validate provided configuration] *************************
task path: /Users/andrewschoen/dev/ceph-ansible/roles/ceph-validate/tasks/main.yml:3
Wednesday 02 May 2018  13:48:16 -0500 (0:00:06.984)       0:00:18.803 *********
 [ERROR]: [mon0] Validation failed for variable: osd_objectstore

 [ERROR]: [mon0] Given value for osd_objectstore: foo

 [ERROR]: [mon0] Reason: osd_objectstore must be either 'bluestore' or 'filestore'

 fatal: [mon0]: FAILED! => {
     "changed": false
     }
```

#### Supported Validation

The `ceph-validate` role currently supports validation of the proper config for the following osd scenarios:

- `collocated`
- `non-collocated`
- `lvm`

The following install options are also validated by the `ceph-validate` role:

- `ceph_origin` set to `distro`
- `ceph_origin` set to `repository`
- `ceph_origin` set to `local`
- `ceph_repository` set to `rhcs`
- `ceph_repository` set to `dev`
- `ceph_repository` set to `community`

### Installation methods

Ceph can be installed through several methods.

- [Installation methods](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/installation/methods.html)

### Configuration

The configuration for your Ceph cluster will be set by the use of ansible variables that `ceph-ansible` provides. All of these options and their default values are defined in the `group_vars/` directory at the root of the `ceph-ansible` project. Ansible will use configuration in a `group_vars/` directory that is relative to your inventory file or your playbook. Inside of the `group_vars/` directory there are many sample Ansible configuration files that relate to each of the Ceph daemon groups by their filename. For example, the `osds.yml.sample` contains all the default configuation for the OSD daemons. The `all.yml.sample` file is a special `group_vars` file that applies to all hosts in your cluster.

Note

For more information on setting group or host specific configuration refer to the Ansible documentation: http://docs.ansible.com/ansible/latest/intro_inventory.html#splitting-out-host-and-group-specific-data

At the most basic level you must tell `ceph-ansible` what version of Ceph you wish to install, the method of installation, your clusters network settings and how you want your OSDs configured. To begin your configuration rename each file in `group_vars/` you wish to use so that it does not include the `.sample` at the end of the filename, uncomment the options you wish to change and provide your own value.

An example configuration that deploys the upstream `octopus` version of Ceph with lvm batch method would look like this in `group_vars/all.yml`:

```
ceph_origin: repository
ceph_repository: community
ceph_stable_release: octopus
public_network: "192.168.3.0/24"
cluster_network: "192.168.4.0/24"
monitor_interface: eth1
devices:
  - '/dev/sda'
  - '/dev/sdb'
```

The following config options are required to be changed on all  installations but there could be other required options depending on  your OSD scenario selection or other aspects of your cluster.

- `ceph_origin`
- `ceph_stable_release`
- `public_network`
- `monitor_interface` or `monitor_address`

When deploying RGW instance(s) you are required to set the `radosgw_interface` or `radosgw_address` config option.

### `ceph.conf` Configuration File

The supported method for defining your `ceph.conf` is to use the `ceph_conf_overrides` variable. This allows you to specify configuration options using an INI format. This variable can be used to override sections already defined in `ceph.conf` (see: `roles/ceph-config/templates/ceph.conf.j2`) or to provide new configuration options.

The following sections in `ceph.conf` are supported:

- `[global]`
- `[mon]`
- `[osd]`
- `[mds]`
- `[client.rgw.{instance_name}]`

An example:

```
ceph_conf_overrides:
   global:
     foo: 1234
     bar: 5678
   osd:
     osd_mkfs_type: ext4
```

Note

We will no longer accept pull requests that modify the `ceph.conf` template unless it helps the deployment. For simple configuration tweaks please use the `ceph_conf_overrides` variable.

Full documentation for configuring each of the Ceph daemon types are in the following sections.

### OSD Configuration

OSD configuration was used to be set by selecting an OSD scenario and providing the configuration needed for that scenario. As of nautilus in stable-4.0, the only scenarios available is `lvm`.

- [OSD Scenario](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/osds/scenarios.html)

### Day-2 Operations

ceph-ansible provides a set of playbook in `infrastructure-playbooks` directory in order to perform some basic day-2 operations.

- [Adding osd(s)](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/day-2/osds.html)
- [Shrinking osd(s)](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/day-2/osds.html#shrinking-osd-s)
- [Purging the cluster](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/day-2/purge.html)
- [Upgrading the ceph cluster](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/day-2/upgrade.html)

## Contribution

See the following section for guidelines on how to contribute to `ceph-ansible`.

- [Contribution Guidelines](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/dev/index.html)

## Testing

Documentation for writing functional testing scenarios for `ceph-ansible`.

- [Testing with ceph-ansible](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/testing/index.html)
- [Glossary](https://docs.ceph.com/projects/ceph-ansible/en/stable-5.0/testing/glossary.html)

## Demos

### Vagrant Demo

Deployment from scratch on vagrant machines: https://youtu.be/E8-96NamLDo

### Bare metal demo

Deployment from scratch on bare metal machines: https://youtu.be/dv_PEp9qAqg



