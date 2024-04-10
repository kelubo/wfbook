#               How to deploy cinder with EMC plug-in 如何使用 EMC 插件部署 cinder            

[![Cinder emc ver2.jpeg](https://wiki.openstack.org/w/images/5/53/Cinder_emc_ver2.jpeg)](https://wiki.openstack.org/wiki/File:Cinder_emc_ver2.jpeg)

## 目录

- [1 **Intro:** 1 简介：](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Intro:)
- 2 **Setup:** 2 设置：
  - [2.1 Example Details: 2.1 示例详细信息：](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Example_Details:)
- 3 **Configuration:** 3 配置：
  - [3.1 Storage (EMC) machine:
    3.1 存储 （EMC） 计算机：](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Storage_.28EMC.29_machine:)
  - [3.2 SMI-S Server: 3.2 SMI-S 服务器：](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#SMI-S_Server:)
- 4 Cinder machine: 4 煤渣机：
  - [4.1 Pre Requirements 4.1 先决条件](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Pre_Requirements)
  - [4.2 Configuration Changes
    4.2 配置更改](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Configuration_Changes)
- [5 **Testing:** 5 测试：](https://wiki.openstack.org/wiki/How_to_deploy_cinder_with_EMC_plug-in#Testing:)

### **Intro: 介绍：**

Cinder is responsible for the management of block storage in OpenStack, and  handles volume management related tasks.  Cinder supports different volume drivers, those drivers allows creation, modification and removal of volumes directly on related storage Vendor  (type),  in our case, EMC driver. 
Cinder 负责 OpenStack 中块存储的管理，并处理与卷管理相关的任务。Cinder 支持不同的卷驱动程序，这些驱动程序允许直接在相关存储供应商（类型）上创建、修改和删除卷，在我们的例子中是 EMC 驱动程序。

- **Note:** that configuration is not that strait-forward, so please make sure to follow all steps required.
  注意：该配置不是那么简单，因此请确保遵循所需的所有步骤。

### **Setup: 设置：**

- Cinder machine installed with RHEL6.4

  
  安装了 RHEL6.4 的 Cinder 机器

  -  Note: we are using basic AIO topology 
    注意：我们使用的是基本的 AIO 拓扑

- Dedicated physical machine installed with RHEL6.4 (64bit)

  
  安装了 RHEL6.4（64 位）的专用物理机

  -  Note: this machine will be used to host the SMI-S server
    注意：本机将用于托管 SMI-S 服务器

-  EMC storage (we are using EMC VNX5300)

  
  EMC 存储（我们使用的是 EMC VNX5300）

  -  Address of both SPA and SPB controllers 
    SPA 和 SPB 控制器的地址
  -  User and password for both controllers 
    两个控制器的用户和密码
  -  Dedicated storage pool (in our example: call it - "OpenStack")
    专用存储池（在我们的示例中：称其为“OpenStack”）

#### Example Details: 示例详细信息：

-  Cinder machine IP address : **1.1.1.1**
  煤渣机IP地址：1.1.1.1
-  SMI-S Provider machine IP address : **1.1.1.10**
  SMI-S 提供程序计算机 IP 地址：1.1.1.10 
-  SPA IP address : **1.1.1.102**
  SPA IP 地址 ： 1.1.1.102
-  SPB IP address : **1.1.1.103**
  SPB IP 地址 ： 1.1.1.103
-  ISCSI target IP address: **1.1.1.104**
  ISCSI 目标 IP 地址：1.1.1.104

### **Configuration: 配置：**

##### Storage (EMC) machine: 存储 （EMC） 计算机：

Using Unisphere, create a new storage pool with name "OpenStack" (make sure pool is a thin-pool). 
使用 Unisphere，创建一个名为“OpenStack”的新存储池（确保池是精简池）。

##### SMI-S Server: SMI-S 服务器：

Install the following packages: 
安装以下软件包：

```
   # yum install -y libgcc_s.so.1 glibc.i686 *pywbem* compat-libstdc++-33.x86_64  libstdc++-devel-*
```

Download SMI-S (solution provider) from EMC site and install it (**kit name:** se7510-Linux-i386-SMI.tar) Unpack and install SMI-S server: 
从 EMC 站点下载 SMI-S（解决方案提供商）并安装它（套件名称：se7510-Linux-i386-SMI.tar） 拆开包装并安装 SMI-S 服务器：

```
   # tar -xvf se7510-Linux-i386-SMI.tar
   # ./se7510_install.sh -install -host
```

Deploy SMI-S server and configure storage Array 
部署 SMI-S 服务器并配置存储阵列

```
  # cd /opt/emc/ECIM/ECOM/bin/
  #  ./TestSmiProvider 
     (localhost:5988) ? addsys
     Add System {y|n} [n]: y
     ArrayType (1=Clar, 2=Symm) [1]: 
     One or more IP address or Hostname or Array ID
     Elements for Addresses
     IP address or hostname or array id 0 (blank to quit): 1.1.1.102
     IP address or hostname or array id 1 (blank to quit): 1.1.1.103
     IP address or hostname or array id 2 (blank to quit): 
     Address types corresponding to addresses specified above.
     (1=URL, 2=IP/Nodename, 3=Array ID) 
     Address Type (0) [default=2]: 
     Address Type (1) [default=2]: 
     User [null]: sysadmin 
     Password [null]: sysadmin
     ++++ EMCAddSystem ++++
```

### Cinder machine: 煤渣机：

#### Pre Requirements 先决条件

```
 # yum install -y libgcc_s.so.1 glibc.i686 *pywbem* compat-libstdc++-33.x86_64  libstdc++-devel-*
```

#### Configuration Changes 配置更改

```
  # Edit /etc/cinder/cinder.conf and append the following configuration:
       iscsi_target_prefix = iqn.1992-04.com.emc
       iscsi_ip_address = 1.1.1.104
       volume_driver = cinder.volume.drivers.emc.emc_smis_iscsi.EMCSMISISCSIDriver
       cinder_emc_config_file = /etc/cinder/cinder_emc_config.xml
  # touch  /etc/cinder/cinder_emc_config.xml
  # Edit  /etc/cinder/cinder_emc_config.xml and append the following configuration:
      <?xml version='1.0' encoding='UTF-8'?>
      <EMC>
      <StorageType>OpenStack</StorageType>
      <EcomServerIp>1.1.1.10</EcomServerIp>
      <EcomServerPort>5985</EcomServerPort>
      <EcomUserName>admin</EcomUserName>
      <EcomPassword>#1Password</EcomPassword>
      </EMC>
```

Restart cinder volume service: 
重新启动煤渣卷服务：

```
    # /etc/init.d/openstack-cinder-volume restart
```

### **Testing: 测试：**

```
   # . ~/keystonerc_admin
   #   cinder create --display-name test 10
   #   cinder list
   +--------------------------------------+-----------+--------------+------+-------------+----------+-------------+
   |                  ID            |   Status  | Display Name | Size | Volume Type | Bootable | Attached to |
   +--------------------------------------+-----------+--------------+------+-------------+----------+-------------+
   | bbc2cc41-5a05-4524-a31f-e6ed76ddab0b | available |    test     |  10   |     None    |  false      |   
   +--------------------------------------+-----------+--------------+------+-------------+----------+-------------+
```

For more information, please refer to the SMI-S Provider Release Notes 
有关更多信息，请参阅 SMI-S 提供商发行说明