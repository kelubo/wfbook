# OpenStack

Openstack最初是由NASA和Rackspace共同发起的云端计算服务项目，该项目以Apache许可证授权的方式成为了一款开源产品，目的是将多个组件整合后从而实现一个开源的云计算平台。

OpenStack系统由几个关键服务组成，它们可以单独安装。这些服务根据云需求工作在一起。这些服务包括计算服务、认证服务、网络服务、镜像服务、块存储服务、对象存储服务、计量服务、编排服务和数据库服务。可以独立安装这些服务、独自配置它们或者连接成一个整体。

## 服务
Openstack作为一个云平台的管理项目，其功能组件覆盖了网络、虚拟化、操作系统、服务器等多个方面，每个功能组件交由不同的项目委员会来研发和管理，目前核心的项目包括有：

| 功能                          | 项目名称   | 描述                                                         |
| ----------------------------- | ---------- | ------------------------------------------------------------ |
| 计算服务     Compute          | Nova       | 在OpenStack环境中计算实例的生命周期管理。按需响应包括生成、调度、回收虚拟机等操作。负责虚拟机的创建、开关机、挂起、迁移、调整CPU、内存等规则。 |
| 对象存储     Object storage   | Swift      | 用于在大规模可扩展系统中通过内置的冗余及高容差机制实现对象存储的系统。通过一个 [*RESTful*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-restful),基于HTTP的应用程序接口存储和任意检索的非结构化数据对象。它拥有高容错机制，基于数据复制和可扩展架构。它的实现并像是一个文件服务器需要挂载目录。在此种方式下，它写入对象和文件到多个硬盘中，以确保数据是在集群内跨服务器的多份复制。 |
| 镜像服务     Image Service    | Glance     | 用于创建、上传、删除、编辑镜像信息的虚拟机镜像查找及索引系统。存储和检索虚拟机磁盘镜像，OpenStack计算会在实例部署时使用此服务。 |
| 身份服务     Identity Service | Keystone   | 为其他的功能服务提供身份验证、服务规则及服务令牌的功能。为其他OpenStack服务提供认证和授权服务，为所有的OpenStack服务提供一个端点目录。 |
| 网络管理     Network          | Neutron    | 用于为其他服务提供云计算的网络虚拟化技术，可自定义各种网络规则，支持主流的网络厂商技术。   确保为其它OpenStack服务提供网络连接即服务，比如OpenStack计算。为用户提供API定义网络和使用。基于插件的架构其支持众多的网络提供商和技术。 |
| 块存储         Block Storage  | Cinder     | 为虚拟机实例提供稳定的数据块存储的创建、删除、挂载、卸载、管理等服务。为运行实例而提供的持久性块存储。它的可插拔驱动架构的功能有助于创建和管理块存储设备。 |
| 图形界面     Dashboard        | Horizon    | 为用户提供简单易用的Web管理界面，与OpenStack底层服务交互，降低用户对功能服务的操作难度。 |
| 测量服务     metering         | Ceilometer | 收集项目内所有的事件，用于监控、计费或为其他服务提供数据支撑。为OpenStack云的计费、基准、扩展性以及统计等目的提供监测和计量。 |
| 部署编排     orchestration    | Heat       | 实现通过模板方式进行自动化的资源环境部署服务。Orchestration服务支持多样化的综合的云应用，通过调用OpenStack-native REST API和CloudFormation-compatible Query API，支持:term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)HOT <Heat Orchestration Template (HOT)>`格式模板或者AWS CloudFormation格式模板 |
| 数据库服务 database Service   | Trove      | 为用户提供可扩展的关系或非关系性数据库服务。                 |

Openstack服务组件协同工作拓扑：

![](../../Image/openstack_kilo_conceptual_arch.png)

应该考虑按照以下步骤使用生产架构来进行部署

- 确定并补充必要的核心和可选服务，以满足性能和冗余要求。
- 使用诸如防火墙，加密和服务策略的方式来加强安全。
- 使用自动化部署工具，例如Ansible, Chef, Puppet, or Salt来自动化部署，管理生产环境。

## 示例的架构

需要至少2个（主机）节点来启动基础服务或者实例。像块存储服务，对象存储服务这一类服务还需要额外的节点。

| 节点     | 服务                                                         | IP            | 用途                 |
| -------- | ------------------------------------------------------------ | ------------- | -------------------- |
| 控制节点 | MySQL  RabbitMQ  Apache  Horizon  Keystone  Glance  Nova(API/Cert/Scheduler/ConsoleAuth/Conductor/NoVNCporxy)  Neutron(server/LinuxBridge-Agent)  Cinder(API/Scheduler/Volume) | 192.168.1.120 | 控制计算节点         |
| 计算节点 | Nova(Nova-Compute/Libvirt/KVM)  Neutron(LinuxBridge-Agent)   | 192.168.1.121 | 为创建虚拟机的资源池 |



NIST还针对于云计算的服务模式提出了3个服务层次：

> Iaas：提供给用户的是云计算基础设施，包括CPU、内存、存储、网络等其他的资源服务，用户不需要控制存储与网络等基础设施。
>
> Paas：提供给用户的是云计算中的开发和分发应用的解决方案，用户能够部署应用程序，也可以控制相关的托管环境，比如云服务器及操作系统，但用户不需要接触到云计算中的基础设施。
>
> Saas：提供给用户的是云计算基础设施上的应用程序，用户只需要在客户端界面访问即可使用到所需资源，而接触不到云计算的基础设施。

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/云计算服务类型.jpg)


开源社区成员和Linux技术爱好者可以选择使用Openstack  RDO版本，RDO版本允许用户以免费授权的方式来获取openstack软件的使用资格，但是从安装开始便较为复杂（需要自行解决诸多的软件依赖关系），而且没有官方给予的保障及售后服务。

##### **22.3 服务模块组件详解**



**Nova提供计算服务**

Nova可以称作是Openstack云计算平台中最核心的服务组件了，它作为计算的弹性控制器来管理虚拟化、网络及存储等资源，为Openstack的云主机实例提供可靠的支撑，其功能由不同的API来提供。

**Nova-api(API服务器):**

> API服务器用于提供云计算设施与外界交互的接口，也是用户对云计算设施进行管理的唯一通道，用户通过网页来调用各种API接口，再由API服务器通过消息队列把请求传递至目标设置进行处理。

**Rabbit MQ Server(消息队列):**

> Openstack在遵循AMQP高级消息队列协议的基础之上采用了消息队列进行通信，异步通信的方式更是能够减少了用户的等待时间，让整个平台都变得更有效率。

**Nova-compute(运算工作站):**

> 运算工作站通过消息队列接收用户的请求并执行，从而负责对主机实例的整个生命周期中的各种操作进行处理，一般会架设多台计算工作站，根据调度算法来按照实例在任意一个计算工作站上部署。

**Nova-network(网络控制器):**

> 用于处理主机的网络配置，例如分配IP地址，配置项目VLAN，设定安全群组及为计算节点配置网络。

**Nova-Volume(卷工作站):**

> 基于LVM的实例卷能够为一个主机实例创建、删除、附加卷或从主机中分离卷。

**Nova-scheduler(调度器)**

> 调度器以名为"nova-schedule"的守护进程方式进行运行，根据对比CPU架构及负载、内存占用率、子节点的远近等因素，使用调度算法从可用的资源池中选择运算服务器。

**Glance提供镜像服务**

Openstack镜像服务是一套用于主机实例来发现、注册、索引的系统，功能相比较也很简单，具有基于组件的架构、高可用、容错性、开发标准等优良特性，虚拟机的镜像可以被放置到多种存储上。

**Swift提供存储服务**

Swift模块是一种分布式、持续虚拟对象存储，具有跨节点百级对象的存储能力，并且支持内建冗余和失效备援的功能，同时还能够处理数据归档和媒体流，对于超大数据和多对象数量非常高效。
 **Swfit代理服务器：**

> 用于通过Swift-API与代理服务器进行交互，代理服务器能够检查实例位置并路由相关的请求，当实例失效或被转移后则自动故障切换，减少重复路由请求。

**Swift对象服务器：**

> 用于处理处理本地存储中对象数据的存储、索引和删除操作。

**Swift容器服务器：**

> 用于统计容器内包含的对象数量及容量存储空间使用率，默认对象列表将存储为SQLite或者MYSQL文件。

**Swift帐户服务器：**

> 与容器服务器类似，列出容器中的对象。

**Ring索引环：**

> 用户记录着Swift中物理存储对象位置的信息，作为真实物理存储位置的虚拟映射，能够查找及定位不同集群的实体真实物理位置的索引服务，上述的代理、对象、容器、帐户都拥有自己的Ring索引环。

**Keystone提供认证服务**

>  Keystone模块依赖于自身的Identity API系统基于判断动作消息来源者请求的合法性来为Openstack中Swift、Glance、Nove等各个组件提供认证和访问策略服务，

**Horizon提供管理服务**

> Horizon是一个用于管理、控制Openstack云计算平台服务器的Web控制面板，用户能够在网页中管理主机实例、镜像、创建密钥对、管理实例卷、操作Swift容器等操作。

**Quantum提供网络服务**

> 重要的网络管理组件。

**Cinder提供存储管理服务**

> 用于管理主机实例中的存储资源。

**Heat提供软件部署服务**

> 用于在主机实例创建后简化配置操作。

 





| 主机名称                 | IP地址/子网      | DNS地址       |
| ------------------------ | ---------------- | ------------- |
| openstack.linuxprobe.com | 192.168.10.10/24 | 192.168.10.10 |



设置服务器的主机名称：

```bash
vim /etc/hostname

openstack.linuxprobe.com
```

使用vim编辑器写入主机名（域名）与IP地址的映射文件：

```bash
vim /etc/hosts

127.0.0.1      localhost localhost.localdomain localhost4 localhost4.localdomain4
::1            localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.10.10  openstack.linuxprobe.com openstack
```

将服务器网卡IP地址配置成"192.168.10.10"后测试主机连通状态：

```bash
ping $HOSTNAME

PING openstack.linuxprobe.com (192.168.10.10) 56(84) bytes of data.
64 bytes from openstack.linuxprobe.com (192.168.10.10): icmp_seq=1 ttl=64 time=0.099 ms
64 bytes from openstack.linuxprobe.com (192.168.10.10): icmp_seq=2 ttl=64 time=0.107 ms
64 bytes from openstack.linuxprobe.com (192.168.10.10): icmp_seq=3 ttl=64 time=0.070 ms
64 bytes from openstack.linuxprobe.com (192.168.10.10): icmp_seq=4 ttl=64 time=0.075 ms
^C
--- openstack.linuxprobe.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3001ms
rtt min/avg/max/mdev = 0.070/0.087/0.107/0.019 ms
```

创建系统镜像的挂载目录：

```bash
mkdir -p /media/cdrom
```

写入镜像与挂载点的信息：

```bash
vim /etc/fstab

# HEADER: This file was autogenerated at 2016-01-28 00:57:19 +0800
# HEADER: by puppet.  While it can still be managed manually, it
# HEADER: is definitely not recommended.

#
# /etc/fstab
# Created by anaconda on Wed Jan 27 15:24:00 2016
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/rhel-root   /       xfs     defaults        1       1
UUID=c738dff6-b025-4333-9673-61b10eaf2268       /boot   xfs     defaults        1       2
/dev/mapper/rhel-swap   swap    swap    defaults        0       0
/dev/cdrom      /media/cdrom    iso9660 defaults        0       0
```

挂载系统镜像设备：

```bash
mount -a

mount: /dev/sr0 is write-protected, mounting read-only
```

写入基本的yum仓库配置信息：

```bash
vim /etc/yum.repos.d/rhel.repo

[base]
name=base
baseurl=file:///media/cdrom
enabled=1
gpgcheck=0
```

您可以点此下载**EPEL仓库源**以及**Openstack-juno**的软件安装包，并上传至服务器的/media目录中：

> **软件资源下载地址：**https://www.linuxprobe.com/tools/
>
> **Openstack Juno——云计算平台软件**
>
> Openstack云计算软件能够将诸如计算能力、存储、网络和软件等资源抽象成服务，以便让用户可以通过互联网远程来享用，付费的形式也变得因需而定，拥有极强的虚拟可扩展性。
>
> **EPEL——系统的软件源仓库**
>
> EPEL是企业版额外的资源包，提供了默认不提供的软件安装包
>
> **Cirros——精简的操作系统**
>
> Cirros是一款极为精简的操作系统，一般用于灌装到Openstack服务平台中。

```bash
cd /media
ls
cdrom epel.tar.bz2 openstack-juno.tar.bz2
```

分别解压文件：

```bash
tar xjf epel.tar.bz2
tar xjf openstack-juno.tar.bz2
```

分别写入EPEL与openstack的yum仓库源信息：

```bash
vim /etc/yum.repos.d/openstack.repo

[openstack]
name=openstack
baseurl=file:///media/openstack-juno
enabled=1
gpgcheck=0

vim /etc/yum.repos.d/epel.repo

[epel]
name=epel
baseurl=file:///media/EPEL
enabled=1
gpgcheck=0
```

将/dev/sdb创建成逻辑卷，卷组名称为cinder-volumes：

```bash
pvcreate /dev/sdb
Physical volume "/dev/sdb" successfully created

vgcreate cinder-volumes /dev/sdb
Volume group "cinder-volumes" successfully created
```

重启系统：

```bash
reboot
```

安装Openstack的应答文件：

```bash
yum install openstack-packstack

………………省略部分安装过程………………
Installing:
openstack-packstack noarch 2014.2-0.4.dev1266.g63d9c50.el7.centos openstack 210 k
Installing for dependencies:
libyaml x86_64 0.1.4-10.el7 base 55 k
openstack-packstack-puppet noarch 2014.2-0.4.dev1266.g63d9c50.el7.centos openstack 43 k
openstack-puppet-modules noarch 2014.2.1-0.5.el7.centos openstack 1.3 M
perl x86_64 4:5.16.3-283.el7 base 8.0 M
perl-Carp noarch 1.26-244.el7 base 19 k
perl-Encode x86_64 2.51-7.el7 base 1.5 M
perl-Exporter noarch 5.68-3.el7 base 28 k
perl-File-Path noarch 2.09-2.el7 base 27 k
perl-File-Temp noarch 0.23.01-3.el7 base 56 k
perl-Filter x86_64 1.49-3.el7 base 76 k
perl-Getopt-Long noarch 2.40-2.el7 base 56 k
perl-HTTP-Tiny noarch 0.033-3.el7 base 38 k
perl-PathTools x86_64 3.40-5.el7 base 83 k
perl-Pod-Escapes noarch 1:1.04-283.el7 base 50 k
perl-Pod-Perldoc noarch 3.20-4.el7 base 87 k
perl-Pod-Simple noarch 1:3.28-4.el7 base 216 k
perl-Pod-Usage noarch 1.63-3.el7 base 27 k
perl-Scalar-List-Utils x86_64 1.27-248.el7 base 36 k
perl-Socket x86_64 2.010-3.el7 base 49 k
perl-Storable x86_64 2.45-3.el7 base 77 k
perl-Text-ParseWords noarch 3.29-4.el7 base 14 k
perl-Time-Local noarch 1.2300-2.el7 base 24 k
perl-constant noarch 1.27-2.el7 base 19 k
perl-libs x86_64 4:5.16.3-283.el7 base 686 k
perl-macros x86_64 4:5.16.3-283.el7 base 42 k
perl-parent noarch 1:0.225-244.el7 base 12 k
perl-podlators noarch 2.5.1-3.el7 base 112 k
perl-threads x86_64 1.87-4.el7 base 49 k
perl-threads-shared x86_64 1.43-6.el7 base 39 k
python-netaddr noarch 0.7.12-1.el7.centos openstack 1.3 M
ruby x86_64 2.0.0.353-20.el7 base 66 k
ruby-irb noarch 2.0.0.353-20.el7 base 87 k
ruby-libs x86_64 2.0.0.353-20.el7 base 2.8 M
rubygem-bigdecimal x86_64 1.2.0-20.el7 base 78 k
rubygem-io-console x86_64 0.4.2-20.el7 base 49 k
rubygem-json x86_64 1.7.7-20.el7 base 74 k
rubygem-psych x86_64 2.0.0-20.el7 base 76 k
rubygem-rdoc noarch 4.0.0-20.el7 base 317 k
rubygems noarch 2.0.14-20.el7 base 211 k
………………省略部分安装过程………………
Complete!
```

安装openstack服务程序：

```bash
[root@openstack ~]# packstack --allinone --provision-demo=n --nagios-install=n
Welcome to Installer setup utility
Packstack changed given value to required value /root/.ssh/id_rsa.pub
Installing:
Clean Up [ DONE ]
Setting up ssh keys [ DONE ]
Discovering hosts' details [ DONE ]
Adding pre install manifest entries [ DONE ]
Preparing servers [ DONE ]
Adding AMQP manifest entries [ DONE ]
Adding MySQL manifest entries [ DONE ]
Adding Keystone manifest entries [ DONE ]
Adding Glance Keystone manifest entries [ DONE ]
Adding Glance manifest entries [ DONE ]
Adding Cinder Keystone manifest entries [ DONE ]
Adding Cinder manifest entries [ DONE ]
Checking if the Cinder server has a cinder-volumes vg[ DONE ]
Adding Nova API manifest entries [ DONE ]
Adding Nova Keystone manifest entries [ DONE ]
Adding Nova Cert manifest entries [ DONE ]
Adding Nova Conductor manifest entries [ DONE ]
Creating ssh keys for Nova migration [ DONE ]
Gathering ssh host keys for Nova migration [ DONE ]
Adding Nova Compute manifest entries [ DONE ]
Adding Nova Scheduler manifest entries [ DONE ]
Adding Nova VNC Proxy manifest entries [ DONE ]
Adding Openstack Network-related Nova manifest entries[ DONE ]
Adding Nova Common manifest entries [ DONE ]
Adding Neutron API manifest entries [ DONE ]
Adding Neutron Keystone manifest entries [ DONE ]
Adding Neutron L3 manifest entries [ DONE ]
Adding Neutron L2 Agent manifest entries [ DONE ]
Adding Neutron DHCP Agent manifest entries [ DONE ]
Adding Neutron LBaaS Agent manifest entries [ DONE ]
Adding Neutron Metering Agent manifest entries [ DONE ]
Adding Neutron Metadata Agent manifest entries [ DONE ]
Checking if NetworkManager is enabled and running [ DONE ]
Adding OpenStack Client manifest entries [ DONE ]
Adding Horizon manifest entries [ DONE ]
Adding Swift Keystone manifest entries [ DONE ]
Adding Swift builder manifest entries [ DONE ]
Adding Swift proxy manifest entries [ DONE ]
Adding Swift storage manifest entries [ DONE ]
Adding Swift common manifest entries [ DONE ]
Adding MongoDB manifest entries [ DONE ]
Adding Ceilometer manifest entries [ DONE ]
Adding Ceilometer Keystone manifest entries [ DONE ]
Adding post install manifest entries [ DONE ]
Installing Dependencies [ DONE ]
Copying Puppet modules and manifests [ DONE ]
Applying 192.168.10.10_prescript.pp
192.168.10.10_prescript.pp: [ DONE ]
Applying 192.168.10.10_amqp.pp
Applying 192.168.10.10_mysql.pp
192.168.10.10_amqp.pp: [ DONE ]
192.168.10.10_mysql.pp: [ DONE ]
Applying 192.168.10.10_keystone.pp
Applying 192.168.10.10_glance.pp
Applying 192.168.10.10_cinder.pp
192.168.10.10_keystone.pp: [ DONE ]
192.168.10.10_cinder.pp: [ DONE ]
192.168.10.10_glance.pp: [ DONE ]
Applying 192.168.10.10_api_nova.pp
192.168.10.10_api_nova.pp: [ DONE ]
Applying 192.168.10.10_nova.pp
192.168.10.10_nova.pp: [ DONE ]
Applying 192.168.10.10_neutron.pp
192.168.10.10_neutron.pp: [ DONE ]
Applying 192.168.10.10_neutron_fwaas.pp
Applying 192.168.10.10_osclient.pp
Applying 192.168.10.10_horizon.pp
192.168.10.10_neutron_fwaas.pp: [ DONE ]
192.168.10.10_osclient.pp: [ DONE ]
192.168.10.10_horizon.pp: [ DONE ]
Applying 192.168.10.10_ring_swift.pp
192.168.10.10_ring_swift.pp: [ DONE ]
Applying 192.168.10.10_swift.pp
192.168.10.10_swift.pp: [ DONE ]
Applying 192.168.10.10_mongodb.pp
192.168.10.10_mongodb.pp: [ DONE ]
Applying 192.168.10.10_ceilometer.pp
192.168.10.10_ceilometer.pp: [ DONE ]
Applying 192.168.10.10_postscript.pp
192.168.10.10_postscript.pp: [ DONE ]
Applying Puppet manifests [ DONE ]
Finalizing [ DONE ]

**** Installation completed successfully ******
Additional information:
* A new answerfile was created in: /root/packstack-answers-20160128-004334.txt
* Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
* Did not create a cinder volume group, one already existed
* File /root/keystonerc_admin has been created on OpenStack client host 192.168.10.10. To use the command line tools you need to source the file.
* To access the OpenStack Dashboard browse to http://192.168.10.10/dashboard .
Please, find your login credentials stored in the keystonerc_admin in your home directory.
* Because of the kernel update the host 192.168.10.10 requires reboot.
* The installation log file is available at: /var/tmp/packstack/20160128-004334-tNBVhA/openstack-setup.log
* The generated manifests are available at: /var/tmp/packstack/20160128-004334-tNBVhA/manifests
```

创建云平台的网卡配置文件：

```bash
[root@openstack ~]# vim /etc/sysconfig/network-scripts/ifcfg-br-ex
DEVICE=br-ex
IPADDR=192.168.10.10
NETMASK=255.255.255.0
BOOTPROTO=static
DNS1=192.168.10.1
GATEWAY=192.168.10.1
BROADCAST=192.168.10.254
NM_CONTROLLED=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
ONBOOT=yes
DEVICETYPE=ovs
TYPE="OVSIntPort"
OVS_BRIDGE=br-ex
```

修改网卡参数信息为：

```bash
[root@openstack ~]# vim /etc/sysconfig/network-scripts/ifcfg-eno16777728 
DEVICE="eno16777728"
ONBOOT=yes
TYPE=OVSPort
DEVICETYPE=ovs
OVS_BRIDGE=br-ex
NM_CONTROLLED=no
IPV6INIT=no
```

将网卡设备添加到OVS网络中：

```bash
[root@openstack ~]# ovs-vsctl add-port br-ex eno16777728 
[root@openstack ~]# ovs-vsctl show
55501ff1-856c-46f1-8a00-5c61e48bb64d
    Bridge br-ex
        Port br-ex
            Interface br-ex
                type: internal
        Port "eno16777728"
            Interface "eno16777728"
    Bridge br-int
        fail_mode: secure
        Port br-int
            Interface br-int
                type: internal
        Port patch-tun
            Interface patch-tun
                type: patch
                options: {peer=patch-int}
    Bridge br-tun
        Port patch-int
            Interface patch-int
                type: patch
                options: {peer=patch-tun}
        Port br-tun
            Interface br-tun
                type: internal
    ovs_version: "2.1.3"
```

重启系统让网络设备同步：

```bash
reboot
```

执行身份认证[脚本](https://www.linuxcool.com/)：

```bash
source keystonerc_admin

openstack-status

 == Nova services ==
 openstack-nova-api: active
 openstack-nova-cert: active
 openstack-nova-compute: active
 openstack-nova-network: inactive (disabled on boot)
 openstack-nova-scheduler: active
 openstack-nova-volume: inactive (disabled on boot)
 openstack-nova-conductor: active
 == Glance services ==
 openstack-glance-api: active
 openstack-glance-registry: active
 == Keystone service ==
 openstack-keystone: active
 == Horizon service ==
 openstack-dashboard: active
 == neutron services ==
 neutron-server: active
 neutron-dhcp-agent: active
 neutron-l3-agent: active
 neutron-metadata-agent: active
 neutron-lbaas-agent: inactive (disabled on boot)
 neutron-openvswitch-agent: active
 neutron-linuxbridge-agent: inactive (disabled on boot)
 neutron-ryu-agent: inactive (disabled on boot)
 neutron-nec-agent: inactive (disabled on boot)
 neutron-mlnx-agent: inactive (disabled on boot)
 == Swift services ==
 openstack-swift-proxy: active
 openstack-swift-account: active
 openstack-swift-container: active
 openstack-swift-object: active
 == Cinder services ==
 openstack-cinder-api: active
 openstack-cinder-scheduler: active
 openstack-cinder-volume: active
 openstack-cinder-backup: active
 == Ceilometer services ==
 openstack-ceilometer-api: active
 openstack-ceilometer-central: active
 openstack-ceilometer-compute: active
 openstack-ceilometer-collector: active
 openstack-ceilometer-alarm-notifier: active
 openstack-ceilometer-alarm-evaluator: active
 == Support services ==
 libvirtd: active
 openvswitch: active
 dbus: active
 tgtd: inactive (disabled on boot)
 rabbitmq-server: active
 memcached: active
 == Keystone users ==
 +----------------------------------+------------+---------+----------------------+
 | id | name | enabled | email |
 +----------------------------------+------------+---------+----------------------+
 | 7f1f43a0002e4fb9a04b9b1480294e08  | admin     | True | test@test.com       |
 | c7570a0d3e264f0191d8108359100cdd  | ceilometer | True | ceilometer@localhost |
 | 9d3d1b46599341638771c33bcebe17fc   | cinder     | True | cinder@localhost     |
 | 52a803edcc4e479ea147e69ca2966f46   | glance     | True | glance@localhost     |
 | 8b0bcd19b11f49059bc100d260f39d50  | neutron    | True | neutron@localhost   |
 | 953e01b228ef480db551dd05d43eb6d1 | nova       | True | nova@localhost      |
 | 16ced2f73c034e58a0951e46f22eddc8   | swift       | True | swift@localhost      |
 +----------------------------------+------------+---------+----------------------+
 == Glance images ==
 +----+------+-------------+------------------+------+--------+
 | ID | Name | Disk Format | Container Format | Size | Status |
 +----+------+-------------+------------------+------+--------+
 +----+------+-------------+------------------+------+--------+
 == Nova managed services ==
 +----+------------------+--------------------------+----------+---------+-------+----------------------------+-----------------+
 | Id | Binary | Host | Zone | Status | State | Updated_at | Disabled Reason |
 +----+------------------+--------------------------+----------+---------+-------+----------------------------+-----------------+
 | 1 | nova-consoleauth  | openstack.linuxprobe.com | internal | enabled | up | 2016-01-29T04:36:20.000000 | - |
 | 2 | nova-scheduler    | openstack.linuxprobe.com | internal | enabled | up | 2016-01-29T04:36:20.000000 | - |
 | 3 | nova-conductor   | openstack.linuxprobe.com | internal | enabled  | up | 2016-01-29T04:36:20.000000 | - |
 | 4 | nova-compute    | openstack.linuxprobe.com | nova    | enabled  | up | 2016-01-29T04:36:16.000000 | - |
 | 5 | nova-cert      | openstack.linuxprobe.com | internal | enabled  | up | 2016-01-29T04:36:20.000000 | - |
 +----+------------------+--------------------------+----------+---------+-------+----------------------------+-----------------+
 == Nova networks ==
 +----+-------+------+
 | ID | Label | Cidr |
 +----+-------+------+
 +----+-------+------+
 == Nova instance flavors ==
 +----+-----------+-----------+------+-----------+------+-------+-------------+-----------+
 | ID | Name | Memory_MB | Disk | Ephemeral | Swap | VCPUs | RXTX_Factor | Is_Public |
 +----+-----------+-----------+------+-----------+------+-------+-------------+-----------+
 | 1 | m1.tiny       | 512    | 1   | 0 | | 1 | 1.0 | True |
 | 2 | m1.small     | 2048   | 20  | 0 | | 1 | 1.0 | True |
 | 3 | m1.medium   | 4096   | 40  | 0 | | 2 | 1.0 | True |
 | 4 | m1.large      | 8192   | 80  | 0 | | 4 | 1.0 | True |
 | 5 | m1.xlarge     | 16384 | 160 | 0 | | 8 | 1.0 | True |
 +----+-----------+-----------+------+-----------+------+-------+-------------+-----------+
 == Nova instances ==
 +----+------+--------+------------+-------------+----------+
 | ID | Name | Status | Task State | Power State | Networks |
 +----+------+--------+------------+-------------+----------+
 +----+------+--------+------------+-------------+----------+
```


 打开浏览器进入http://192.168.10.10/dashboard：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/Openstack登陆页面.png)
 查看登录的帐号密码：

```bash
[root@openstack ~]# cat keystonerc_admin 
export OS_USERNAME=admin
export OS_TENANT_NAME=admin
export OS_PASSWORD=14ad1e723132440c
export OS_AUTH_URL=http://192.168.10.10:5000/v2.0/
export PS1='[\u@\h \W(keystone_admin)]\$ '
```

输入帐号密码后进入到Openstack管理中心：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/登陆Openstack管理平台.png)

##### **22.5 使用Openstack服务**

###### **22.5.1 配置虚拟网络**

要想让云平台中的虚拟实例机能够互相通信，并且让外部的用户访问到里面的数据，我们首先就必需配置好云平台中的网络环境。

Openstack创建网络：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/Openstack创建网络.jpg)
 编辑网络配置：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/Openstack编辑网络配置.png)
 点击创建子网：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建子网.png)
 创建子网信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建子网信息.jpg)
 填写子网详情(DHCP地址池中的IP地址用逗号间隔)：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写子网详情.png)
 子网详情：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/子网详情.png)
 创建私有网络：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建私有网络.png)
 创建网络：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建网络.png)
 填写网络信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写网络信息.jpg)
 设置网络详情：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/设置网络详情.jpg)
 查看网络信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/Openstack网络信息.png)
 添加路由信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/添加路由信息.png)
 填写路由名称：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写路由名称-3.png)
 设置路由的网关信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/设置路由的网关信息.png)
 设置网关：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/设置网关.png)
 在网络拓扑中添加接口：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/在网络拓扑中添加接口.png)
 添加接口信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/添加接口信息.png)
 路由的接口信息(需要等待几秒钟后，内部接口的状态会变成ACTIVE)：

[![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/路由的接口信息-1.png)](https://www.linuxprobe.com/wp-content/uploads/2016/01/路由的接口信息-1.png)

###### **22.5.2 创建云主机类型**

我们可以预先设置多个云主机类型的模板，这样可以灵活的满足用户的需求，先来创建云主机类型：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建云主机类型.png)
 填写云主机的基本信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写云主机的信息.png)
 创建上传镜像：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建上传镜像.png)

Cirros是一款极为精简的操作系统，非常小巧精简的[Linux系统](https://www.linuxprobe.com/)镜像，一般会在搭建Openstack后测试云计算平台可用性的系统，特点是体积小巧，速度极快，那么来上传Cirros系统镜像吧：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/上传系统镜像文件.png)
 查看已上传的镜像(Cirros系统上传速度超级快吧!)：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看已上传的系统镜像.png)

###### **22.5.3 创建主机实例**

创建云主机实例：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建实例主机.png)
 填写云主机的详情(云主机类型可以选择前面自定义创建的)：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/第1步：填写云主机的详情.png)
 查看云主机的访问与安全规则：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/第2步：查看云主机的访问与安全规则.png)
 将私有网络网卡添加到云主机：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/第3步：将私有网络网卡添加到云主机.png)
 查看安装后的[脚本](https://www.linuxcool.com/)数据：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/第4步：查看安装后的脚本数据.jpg)
 查看磁盘的分区方式：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/第5步：查看磁盘的分区方式.png)
 主机实例的孵化过程大约需要10-30秒，然后查看已经运行的实例：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看已经运行的实例.png)查看实例主机的网络拓扑（当前仅在内网中）：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看网络拓扑.png)

为实例主机绑定浮动IP地址：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/为实例主机绑定浮动IP.png)

为主机实例添加浮动IP

[![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/为主机实例添加浮动IP.png)](https://www.linuxprobe.com/wp-content/uploads/2016/01/为主机实例添加浮动IP.png)

选择绑定的IP地址：

[![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/选择绑定的IP地址-1.png)](https://www.linuxprobe.com/wp-content/uploads/2016/01/选择绑定的IP地址-1.png)

将主机实例与IP地址关联：

[![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/将主机与IP地址关联-1.png)](https://www.linuxprobe.com/wp-content/uploads/2016/01/将主机与IP地址关联-1.png)

此时再查看实例的信息，IP地址段就多了一个数据值（192.168.10.51）：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看实例的信息.png)

尝试从外部ping云主机实例（结果是失败的）：

```bash
[root@openstack ~]# ping 192.168.10.51
PING 192.168.10.51 (192.168.10.51) 56(84) bytes of data.
From 192.168.10.10 icmp_seq=1 Destination Host Unreachable
From 192.168.10.10 icmp_seq=2 Destination Host Unreachable
From 192.168.10.10 icmp_seq=3 Destination Host Unreachable
From 192.168.10.10 icmp_seq=4 Destination Host Unreachable
^C
--- 192.168.10.51 ping statistics ---
6 packets transmitted, 0 received, +4 errors, 100% packet loss, time 5001ms
pipe 4
```

原因是我们没有设置安全组规则那，需要让外部流量允许进入到主机实例中：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建安全策略组.png)

填写策略组的名称与描述：

[![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写策略组的信息.png)](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写策略组的信息.png)

管理安全组的规则：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/管理安全组的规则-1.png)

添加安全规则：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/添加安全规则.png)

允许所有的ICMP数据包流入（当然根据工作有时还需要选择TCP或UDP协议，此时仅为验证网络连通性）：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/允许所有的icmp数据包流入.png)

编辑实例的安全策略组：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/编辑实例的安全策略组.png)

将新建的安全组策略作用到主机实例上：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/添加新的安全策略组-1.png)

再次尝试从外部ping虚拟实例主机：

```bash
[root@openstack ~]# ping 192.168.10.51
PING 192.168.10.51 (192.168.10.51) 56(84) bytes of data.
64 bytes from 192.168.10.51: icmp_seq=1 ttl=63 time=2.47 ms
64 bytes from 192.168.10.51: icmp_seq=2 ttl=63 time=0.764 ms
64 bytes from 192.168.10.51: icmp_seq=3 ttl=63 time=1.44 ms
64 bytes from 192.168.10.51: icmp_seq=4 ttl=63 time=1.30 ms
^C
--- 192.168.10.51 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 0.764/1.497/2.479/0.622 ms
```

###### **22.5.5 添加云硬盘**

云计算平台的特性就是要能够灵活的，弹性的调整主机实例使用的资源，我们可以来为主机实例多挂载一块云硬盘，首先来创建云硬盘设备：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/创建云硬盘设备.png)

填写云硬盘的信息（以10GB为例）：

![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/填写云硬盘的信息.png)
 编辑挂载设备到主机云实例：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/编辑挂载设备到主机云实例.png)
 将云硬盘挂载到主机实例中：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/将云硬盘挂载到主机实例中.png)
 查看云主机实例中的硬盘信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看云主机实例中的硬盘信息.png)

##### **22.6 控制云主机实例**

经过上面的一系列配置，我们此时已经创建出了一台能够交付给用户使用的云主机实例了，查看下云平台的信息：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/查看云平台的使用信息.png)
 编辑安全策略，允许TCP和UDP协议的数据流入到云主机实例中：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/编辑安全策略.png)
 分别添加TCP和UDP的允许规则：
 ![第22章 使用openstack部署云计算服务环境。第22章 使用openstack部署云计算服务环境。](https://www.linuxprobe.com/wp-content/uploads/2016/01/分别添加TCP和UDP的允许规则.png)
 成功登录到云主机实例中（默认帐号为"**cirros**"，密码为："**cubswin:)**"）：

```bash
[root@openstack ~]# ssh cirros@192.168.10.52
The authenticity of host '192.168.10.52 (192.168.10.52)' can't be established.
RSA key fingerprint is 12:ef:c7:fb:57:70:fc:60:88:8c:96:13:38:b1:f6:65.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.10.52' (RSA) to the list of known hosts.
cirros@192.168.10.52's password: 
$
```

查看云主机实例的网络情况：

```bash
$ ip a 
1: lo:  mtu 16436 qdisc noqueue 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0:  mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether fa:16:3e:4f:1c:97 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.51/24 brd 10.10.10.255 scope global eth0
    inet6 fe80::f816:3eff:fe4f:1c97/64 scope link 
       valid_lft forever preferred_lft forever
```

挂载刚刚创建的云硬盘设备：

```bash
$ df -h
Filesystem                Size      Used Available Use% Mounted on
/dev                    494.3M         0    494.3M   0% /dev
/dev/vda1                23.2M     18.0M      4.0M  82% /
tmpfs                   497.8M         0    497.8M   0% /dev/shm
tmpfs                   200.0K     68.0K    132.0K  34% /run
$ mkdir disk
$ sudo mkfs.ext4 /dev/vdb
mke2fs 1.42.2 (27-Mar-2012)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
655360 inodes, 2621440 blocks
131072 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2684354560
80 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done 
$ sudo mount /dev/vdb disk/
$ df -h
Filesystem                Size      Used Available Use% Mounted on
/dev                    494.3M         0    494.3M   0% /dev
/dev/vda1                23.2M     18.0M      4.0M  82% /
tmpfs                   497.8M         0    497.8M   0% /dev/shm
tmpfs                   200.0K     68.0K    132.0K  34% /run
/dev/vdb                  9.8G    150.5M      9.2G   2% /home/cirros/disk
```
