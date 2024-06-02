# Rocks clusters

[TOC]

## 概述

rocks clusters 是一整套的高性能计算机群操作系统快速部署解决方案。起源于1994年的 Beowulf（贝奥武夫）集群架构，主要功能是利用 kickstart 快速复制计算节点并实现无人值守，把 NFS 网络文件系统作为各节点共享的数据盘，用 SGE 进行任务管理。

主要优缺点是：

- 提供了足够的工具以及调整好的配置。相比自己构建集群架构，管理员不需要懂很多集群架构的知识，只需要做很少的配置即可快速部署非常大规模的集群。简单高效。
- 不足之处是自由度比较低，基本只能用它提供的软件，且只支持 centos，想要更换软件（比如将 SGE 更换为更加好用的 slurm）比较困难而且会带来意料之外的 bug。另一个不足是更新缓慢，可能不能利用最新的硬件特性。

如需折中的方案，可选择 xCAT。

管理节点需要两块网卡，计算节点只需要一块网卡。安装时，管理节点一根网线接入互联网，另外一根与计算节点接入同一个交换机即可。也可以所有网线都连一个交换机，然后交换机连接互联网。

## 部署管理节点（前端节点，Frontend）

- 管理节点硬盘分区：

```bash
#  根据自己的硬盘大小分区，其中/export分区为NFS共享文件夹，所有的软件和其数据都要放到这个文件夹
#  因此rocks的/home文件夹页在/export分区中。rocks默认的文件分区比较老旧，可以参考以下分区方案：
#  swap           50G
#  /	                  500G
#  /export         剩余的空间
```



- 配置Frontend（登入root账户）：

​    1. 服务器一般都有很大的内存，过早地使用交换分区会降低性能，因此需要设置swappiness，关于swappiness的相关知识可以参考[swappiness](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/brownyangyang/p/9175807.html)，具体设置流程为:

```text
# linux默认swappiness为内存使用60%即开始使用交换分区，因此我们需要设置成尽量多地使用内存
#  同时不能让系统杀死进程。
~ vim /etc/sysctl.conf
#  在末尾加上 vm.swappiness = 1
#  使之生效      sysctl -p 
```

​    2. 配置计算节点分区：

```text
#  cd /export/rocks/install/site-profiles/7.0/nodes/
#  cp /export/rocks/install/rocks-dist/x86_64/build/nodes/custom-partition.xml replace-custom-partition.xml
#  vim replace-custom-partition.xml
# 把两个<pre>中间的的内容改为：
<pre>
echo "clearpart --all --initlabel --drives=sda
part / --size 200000 --ondisk sda
part swap --size 100000 --ondisk sda
part /mydata --size 1 --grow --ondisk sda" &gt; /tmp/user_partition_info
</pre>
#  其中数字即为分区大小，单位为MiB。注意自己机器里硬盘的位置为sda还是hda抑或是其他，并做出相应更改。
#  上面的分区为/,swap,/mydata，其中/mydata分区占用剩余空间。注意计算节点不需要/export分区。
```



​    3. rocks默认的kickstart配置为断电重启之后自动重装系统，下面配置不要断电重装：

```text
# cd /export/rocks/install
# cp rocks-dist/x86_64/build/nodes/auto-kickstart.xml site-profiles/7.0/nodes/replace-auto-kickstart.xml

vim site-profiles/7.0/nodes/replace-auto-kickstart.xml
去掉行 <package>rocks-boot-auto<package>
```

​    4. 让以上所有配置生效：

```text
# cd /export/rocks/install
# rocks create distro
```

## 安装计算节点（compute-node)

 计算节点计算机网卡需支持PXE启动

​    1. 在管理节点的终端内输入：insert-ethers，回车。在接下来的界面中选择compute。图片参考上面的网页。

​    2. 设置计算节点boot启动顺序为cd,PXE,硬盘。启动计算节点，然后等待安装完成即可。

​    3. 如计算节点网卡不支持PXE启动，那么可以用之前安装管理节点的U盘或光盘启动，正常情况下不需要配置任何东西，按enter即可自动引导。但我实验没有成功，可能是网卡问题。



- 配置计算节点：

​    1. 在管理节点登入root，然后利用ssh连接计算节点，以第一个计算节点为例。

```bash
ssh compute-0-0
```

​    2. 配置计算节点swappiness，方法同管理节点。

​    3. 挂载Frontend的/export文件夹：

​    主要参考：[鸟哥的linux私房菜：NFS 服务器](https://link.zhihu.com/?target=http%3A//cn.linux.vbird.org/linux_server/0330nfs.php)

```text
mkdir -p /export
mount -t nfs 10.1.84.1:/export /export
#  配置开机挂载：
vim /etc/rc.d/rc.local 添加下行：
mount -t nfs 10.1.84.1:/export /export
```





## 属性
| 名称 | 类型 | 默认值 |
|--|--|--|
| disableServices | string | kudzu canna cWnn FreeWnn kWnn tWnn mDNSResponder |
| Info_CertificateCountry [a] | string |  |
| Info_CertificateLocality [a] | string |  |
| Info_CertificateOrganization [a] | string |  |
| Info_CertificateState [a] | string |  |
| Info_CertificateContact [a] | string |  |
| Info_CertificateLatLong [a] | string |  |
| Info_CertificateName [a] | string |  |
| Info_CertificateURL [a] | string |  |
| Kickstart_DistroDir [a] | string | /export/rocks |
| Kickstart_Keyboard [a] | string | us |
| Kickstart_Lang [a] | string | en_US |
| Kickstart_Langsupport [a] | string | en_US |
| Kickstart_Mutlicast [a] | string | 226.117.172.185 |
| Kickstart_PrivateAddress [a] | string | 10.1.1.1 |
| Kickstart_PrivateBroadcast [a] | string | 10.1.255.255 |
| Kickstart_PrivateDNSDomain [a] | string | local |
| Kickstart_PrivateDNSServers [a] | string | 10.1.1.1 |
| Kickstart_PrivateGateway [a] | string | 10.1.1.1 |
| Kickstart_PrivateHostname [a] | string |  |
| Kickstart_PrivateKickstartBaseDir [a] | string | install |
| Kickstart_PrivateKickstartCGI [a] | string | sbin/kickstart.cgi |
| Kickstart | string |  |
| _PrivateKickstartHost [a] | string | 10.1.1.1 |
| Kickstart_PrivateNTPHost [a] | string | 10.1.1.1 |
| Kickstart_PrivateNetmask [a] | string | 255.255.0.0 |
| Kickstart_PrivateNetmaskCIDR [a] | string | 16 |
| Kickstart_PrivateNetwork [a] | string | 10.1.0.0 |
| Kickstart_PrivatePortableRootPassword [a] | string |  |
| Kickstart_PrivateRootPassword [a] | string |  |
| Kickstart_PrivateSHARootPassword [a] | string |  |
| Kickstart_PrivateSyslogHost [a] | string | 10.1.1.1 |
| Kickstart_PublicAddress [a] | string |  |
| Kickstart_PublicBroadcast [a] | string |  |
| Kickstart_PublicDNSDomain [a] | string |  |
| Kickstart_PublicDNSServers [a] | string |  |
| Kickstart_PublicGateway [a] | string |  |
| Kickstart_PublicHostname [a] | string |  |
| Kickstart_PublicKickstartHost [a] | string |  |
| Kickstart_PublicNTPHost [a] | string |  |
| Kickstart_PublicNetmask [a] | string |  |
| Kickstart_PublicNetmaskCIDR [a] | string |  |
| Kickstart_PublicNetwork [a] | string |  |
| Kickstart_Timezone [a] | string |  |
| airboss [b] | string | specified on boot line |
| arch [c], [b] | string | i386 | x86_64 |
| dhcp_filename [d] | string | pxelinux.0 |
| dhcp_nextserver [d] | string | 10.1.1.1 |
| hostname [e], [b] | string |  |
| kickstartable [d] | bool | TRUE |
| os [c], [b] | string | linux | solaris |
| rack [e], [b] | int |  |
| rank [e], [b] | int |  |
| rocks_version [a] | string | 6.1.1 |
| rsh [f] | bool | FALSE |
| rocks_autogen_user_keys [f] |	bool | FALSE
| ssh_use_dns [a] | bool | TRUE
| x11 [f] | bool | FALSE

Notes:
a. Default value created using rocks add attr name value and affects all hosts.
b. Default value created using rocks add host attr localhost name value and only affects the frontend appliance.
c. Attribute is for internal use only, and should not be altered by the user. Each time a machine installs this attributed is reset to the default value for that machine (depend on kernel booted).
d. Default value created using rocks add appliance attr appliance name value for the frontend and compute appliances.
e. Attribute cannot by modified. This value is not recorded in the cluster database and is only available as an XML entity during installation.
f. Attribute is referenced but not defined so is treated as FALSE.

** Info_Certificate_{*} **

    The attributes are created during frontend installation. The values are taken from user input on the system installation screens. 
**Kickstart_{*}**

    The attributes are created during frontend installation. The values are taken from user input on the system installation screens. All of these attributes are considered internal to Rocks® and should not be modified directly. 
**airboss**

    Specifies the address of the airboss host. This only applies to virtual machines. 
**arch**

    The CPU architecture of the host. This host-specific attribute is set by the installing machine. User changes to this attribute have no affect. 
**dhcp_filename**

    Name of the PXE file retrieved over TFTP at startup. 
**dhcp_nextserver**

    IP address of the server that servers installation profiles (kickstart, jumpstart). In almost all configuration this should be the frontend machine. 
**kickstartable**

    The attribute must be set to TRUE for all appliances, and FALSE (or undefined) for all unmanaged devices (e.g. network switches). 
**os**

    The OS of the host. This host-specific attribute is set by the installing machine. User changes to this attribute have no affect. 
**rsh**

    If TRUE the machine is configured as an RSH client. This is not recommended, and will still require RSH server configuration on the frontend machine. 
**ssh_use_dns**

    Set to FALSE to disable DNS lookups when connecting to nodes in the cluster over SSH. If establishing an ssh connect is slow the cause may be a faulty (or absent) DNS system. Disabling this lookup will speed up connection establishment, but lowers the security of your system. 
**x11**

    If TRUE X11 is configured and the default runlevel is changed from 3 to 5. X11 is always configure on the frontend and this attribute applies only to the other nodes in the cluster. 
## Installation
处理器

    x86 (ia32, AMD Athlon, etc.)
    x86_64 (AMD Opteron and EM64T) 

Networks

    Ethernet 

Note	
Specialized networks and components (e.g., Myrinet, Infiniband, nVidia GPU) are also supported. Hardware requirements and software (Rocks Rolls) can be found on the respective vendor web sites.
### Minimum Hardware Requirements

Frontend Node

    Disk Capacity: 30 GB
    Memory Capacity: 1 GB
    Ethernet: 2 physical ports (e.g., "eth0" and "eth1")
    BIOS Boot Order: CD, Hard Disk 

Compute Node

    Disk Capacity: 30 GB
    Memory Capacity: 1 GB
    Ethernet: 1 physical port (e.g., "eth0")
    BIOS Boot Order: CD, PXE (Network Boot), Hard Disk 

### 硬件架构
![](../Image/cluster.png)