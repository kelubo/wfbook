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

## 示例的架构

需要至少2个（主机）节点来启动基础服务。像块存储服务，对象存储服务这一类服务还需要额外的节点

这个示例架构不同于下面这样的最小生产结构

- 网络代理驻留在控制节点上而不是在一个或者多个专用的网络节点上。
- 私有网络的覆盖流量通过管理网络而不是专用网络

![Hardware requirements](../../Image/h/hwreqs.png)

## 硬件配置

### 控制器

控制节点上运行身份认证服务，镜像服务，计算服务的管理部分，网络服务的管理部分，多种网络代理以及仪表板。也需要包含一些支持服务，例如：SQL 数据库，消息队列, 和 NTP 。

可选的，可以在计算节点上运行部分块存储，对象存储，Orchestration 和 Telemetry 服务。

计算节点上需要至少两块网卡。

### 计算

计算节点上运行计算服务中管理实例的管理程序部分。默认情况下，计算服务使用 *KVM*。

你可以部署超过一个计算节点。每个结算节点至少需要两块网卡。

### 块设备存储

可选的块存储节点上包含了磁盘，块存储服务和共享文件系统会向实例提供这些磁盘。

为了简单起见，计算节点和本节点之间的服务流量使用管理网络。生产环境中应该部署一个单独的存储网络以增强性能和安全。

你可以部署超过一个块存储节点。每个块存储节点要求至少一块网卡。

### 对象存储

可选的对象存储节点包含了磁盘。对象存储服务用这些磁盘来存储账号，容器和对象。

为了简单起见，计算节点和本节点之间的服务流量使用管理网络。生产环境中应该部署一个单独的存储网络以增强性能和安全。

这个服务要求两个节点。每个节点要求最少一块网卡。你可以部署超过两个对象存储节点。

## 网络

从下面的虚拟网络选项中选择一种选项。

### 网络选项1：公共网络

公有网络选项使用尽可能简单的方式主要通过layer-2（网桥/交换机）服务以及VLAN网络的分割来部署OpenStack网络服务。本质上，它建立虚拟网络到物理网络的桥，依靠物理网络基础设施提供layer-3服务(路由)。额外地 ，DHCP为实例提供IP地址信息。

注解

这个选项不支持私有网络，layer-3服务以及一些高级服务，例如:LBaaS and [*FWaaS*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-fwaas)。如果你需要这些服务，请考虑私有网络选项

![Networking Option 1: Provider networks - Service layout](../../Image/n/network1-services.png)



### 网络选项2：私有网络

私有网络选项扩展了公有网络选项，增加了启用 self-service覆盖分段方法的layer-3（路由）服务，比如 VXLAN。本质上，它使用 NAT路由虚拟网络到物理网络。另外，这个选项也提供高级服务的基础，比如LBaas和FWaaS。

![Networking Option 2: Self-service networks - Service layout](../../Image/n/network2-services.png)

​                                                                                      

## 环境

这部分解释如何按示例架构配置控制节点和一个计算节点。

尽管大多数环境中包含认证，镜像，计算，至少一个网络服务，还有仪表盘，但是对象存储服务也可以单独操作。如果你的使用情况与涉及到对象存储，你可以在配置完适当的节点后跳到：swift。然而仪表盘要求至少要有镜像服务，计算服务和网络服务。

必须用有管理员权限的帐号来配置每个节点。可以用 `root` 用户或 `sudo` 工具来执行这些命令。

为获得最好的性能，推荐在环境中符合或超过在 “硬件配置” 中的硬件要求。

以下最小需求支持概念验证环境，使用核心服务和几个CirrOS实例:

- 控制节点: 1 处理器, 4 GB 内存, 及5 GB 存储
- 计算节点: 1 处理器, 2 GB 内存, 及10 GB 存储

每个节点配置一个磁盘分区满足大多数的基本安装。但是，对于有额外服务如块存储服务的，应该考虑采用Logical Volume Manager (LVM)进行安装。

## 安全

OpenStack 服务支持各种各样的安全方式，包括密码 password、policy 和 encryption，支持的服务包括数据库服务器，且消息 broker 至少支持 password 的安全方式。

为了简化安装过程，本指南只包含了可适用的密码安全。你可以手动创建安全密码，使用`pwgen <http://sourceforge.net/projects/pwgen/>`__工具生成密码或者通过运行下面的命令：

```
$ openssl rand -hex 10
```

对 OpenStack 服务而言，本指南使用``SERVICE_PASS`` 表示服务帐号密码，使用``SERVICE_DBPASS`` 表示数据库密码。

下面的表格给出了需要密码的服务列表以及它们在指南中关联关系：

| 密码名称                 | 描述                                   |
| ------------------------ | -------------------------------------- |
| 数据库密码(不能使用变量) | 数据库的root密码                       |
| `ADMIN_PASS`             | `admin` 用户密码                       |
| `CEILOMETER_DBPASS`      | Telemetry 服务的数据库密码             |
| `CEILOMETER_PASS`        | Telemetry 服务的 `ceilometer` 用户密码 |
| `CINDER_DBPASS`          | 块设备存储服务的数据库密码             |
| `CINDER_PASS`            | 块设备存储服务的 `cinder` 密码         |
| `DASH_DBPASS`            | Database password for the dashboard    |
| `DEMO_PASS`              | `demo` 用户的密码                      |
| `GLANCE_DBPASS`          | 镜像服务的数据库密码                   |
| `GLANCE_PASS`            | 镜像服务的 `glance` 用户密码           |
| `HEAT_DBPASS`            | Orchestration服务的数据库密码          |
| `HEAT_DOMAIN_PASS`       | Orchestration 域的密码                 |
| `HEAT_PASS`              | Orchestration 服务中``heat``用户的密码 |
| `KEYSTONE_DBPASS`        | 认证服务的数据库密码                   |
| `NEUTRON_DBPASS`         | 网络服务的数据库密码                   |
| `NEUTRON_PASS`           | 网络服务的 `neutron` 用户密码          |
| `NOVA_DBPASS`            | 计算服务的数据库密码                   |
| `NOVA_PASS`              | 计算服务中``nova``用户的密码           |
| `RABBIT_PASS`            | RabbitMQ的`guest`用户密码              |
| `SWIFT_PASS`             | 对象存储服务用户``swift``的密码        |

OpenStack和配套服务在安装和操作过程中需要管理员权限。例如，一些OpenStack服务添加root权限 `sudo` 可以与安全策略进行交互。

另外，网络服务设定内核网络参数的默认值并且修改防火墙规则。

## 主机网络

推荐禁用自动网络管理工具并手动编辑相应版本的配置文件。

在大部分情况下，节点应该通过管理网络接口访问互联网。为了更好的突出网络隔离的重要性，示例架构中为管理网络使用`private address space <https://tools.ietf.org/html/rfc1918>`__ 并假定物理网络设备通过NAT或者其他方式提供互联网访问。示例架构使用可路由的IP地址隔离服务商（外部）网络并且假定物理网络设备直接提供互联网访问。

在提供者网络架构中，所有实例直接连接到提供者网络。在自服务（私有）网络架构，实例可以连接到自服务或提供者网络。自服务网络可以完全在openstack环境中或者通过外部网络使用 NAT 提供某种级别的外部网络访问。

![Network layout](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/networklayout.png)

示例架构假设使用如下网络：

- 管理使用 10.0.0.0/24 带有网关 10.0.0.1

  这个网络需要一个网关以为所有节点提供内部的管理目的的访问，例如包的安装、安全更新、 [*DNS*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-dns)，和 [*NTP*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-ntp)。

- 提供者网段 203.0.113.0/24，网关203.0.113.1

  这个网络需要一个网关来提供在环境中内部实例的访问。

可以修改这些范围和网关来以您的特定网络设施进行工作。

除非您打算使用该架构样例中提供的准确配置，否则您必须在本过程中修改网络以匹配您的环境。并且，每个节点除了 IP  地址之外，还必须能够解析其他节点的名称。例如，controller这个名称必须解析为 10.0.0.11，即控制节点上的管理网络接口的 IP  地址。

### 控制节点服务器

**配置网络接口**

1. 将第一个接口配置为管理网络接口：

   IP 地址: 10.0.0.11

   子网掩码: 255.255.255.0 (or /24)

   默认网关: 10.0.0.1

2. 提供者网络接口使用一个特殊的配置，不分配给它IP地址。配置第二块网卡作为提供者网络：

   将其中的 `INTERFACE_NAME`替换为实际的接口名称。例如，*eth1* 或者*ens224*。

   - 编辑``/etc/sysconfig/network-scripts/ifcfg-INTERFACE_NAME``文件包含以下内容：

     不要改变 键``HWADDR`` 和 `UUID` 。

     ```bash
     DEVICE=INTERFACE_NAME
     TYPE=Ethernet
     ONBOOT="yes"
     BOOTPROTO="none"
     ```

3. 重启系统以激活修改。

**配置域名解析**

1. 设置节点主机名为 `controller`。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```bash
   # controller
   10.0.0.11       controller
   # compute1
   10.0.0.31       compute1
   # block1
   10.0.0.41       block1
   # object1
   10.0.0.51       object1
   # object2
   10.0.0.52       object2
   ```
   
   > **警告:**
   >
   > 一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**        

### 计算节点

**配置网络接口**

1. 将第一个接口配置为管理网络接口：

   IP 地址：10.0.0.31

   子网掩码: 255.255.255.0 (or /24)

   默认网关: 10.0.0.1

   > **注:**
>
   > 另外的计算节点应使用 10.0.0.32、10.0.0.33 等等。

2. 提供者网络接口使用一个特殊的配置，不分配给它IP地址。配置第二块网卡作为提供者网络：

   将其中的 INTERFACE_NAME替换为实际的接口名称。例如，*eth1* 或者*ens224*。

   - 编辑``/etc/sysconfig/network-scripts/ifcfg-INTERFACE_NAME``文件包含以下内容：

     不要改变 键``HWADDR`` 和 `UUID` 。

     ```bash
     DEVICE=INTERFACE_NAME
     TYPE=Ethernet
     ONBOOT="yes"
     BOOTPROTO="none"
     ```

3. 重启系统以激活修改。

**配置域名解析**

1. 设置节点主机名为``compute1``。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```bash
   # controller
   10.0.0.11       controller
   # compute1
   10.0.0.31       compute1
   # block1
   10.0.0.41       block1
   # object1
   10.0.0.51       object1
   # object2
   10.0.0.52       object2
   ```
   
   > **警告：**
   >
   > 一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**                    

### 块存储节点（可选）
**配置网络接口**

- 配置管理网络接口：
  - IP 地址： `10.0.0.41`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

**配置域名解析**

1. 设置节点主机名为``block1``。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```bash
   # controller
   10.0.0.11       controller
   # compute1
   10.0.0.31       compute1
   # block1
   10.0.0.41       block1
   # object1
   10.0.0.51       object1
   # object2
   10.0.0.52       object2 
   ```
   
   >**警告:**
   >一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**
3. 重启系统以激活修改。               

### 对象存储节点（可选）

#### 第一个节点
**配置网络接口**

- 配置管理网络接口：
  - IP 地址：`10.0.0.51`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

**配置域名解析**

1. 设置节点主机名为 `object1`。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```bash
   # controller
   10.0.0.11       controller
   # compute1
   10.0.0.31       compute1
   # block1
   10.0.0.41       block1
   # object1
   10.0.0.51       object1
   # object2
   10.0.0.52       object2
   ```
   
   > **警告：**
   >
   > 一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

3. 重启系统以激活修改。

#### 第二个节点

**配置网络接口**

- 配置管理网络接口：
  - IP地址：`10.0.0.52`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

**配置域名解析**

1. 设置节点主机名为``object2``。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```bash
   # controller
   10.0.0.11       controller
   # compute1
   10.0.0.31       compute1
   # block1
   10.0.0.41       block1
   # object1
   10.0.0.51       object1
   # object2
   10.0.0.52       object2
   ```
   
   > **警告:**
   >
   > 一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**


3. 重启系统以激活修改。

#### 验证连通性


我们建议您在继续进行之前，验证到 Internet 和各个节点之间的连通性。

1. 从*controller*节点，测试能否连接到 Internet：

   ```bash
   ping -c 4 openstack.org
   
   PING openstack.org (174.143.194.225) 56(84) bytes of data.
   64 bytes from 174.143.194.225: icmp_seq=1 ttl=54 time=18.3 ms
   64 bytes from 174.143.194.225: icmp_seq=2 ttl=54 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_seq=3 ttl=54 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_seq=4 ttl=54 time=17.4 ms
   
   --- openstack.org ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3022ms
   rtt min/avg/max/mdev = 17.489/17.715/18.346/0.364 ms
   ```

2. 从 *controller* 节点，测试到*compute* 节点管理网络是否连通：

   ```bash
   ping -c 4 compute1
   
   PING compute1 (10.0.0.31) 56(84) bytes of data.
   64 bytes from compute1 (10.0.0.31): icmp_seq=1 ttl=64 time=0.263 ms
   64 bytes from compute1 (10.0.0.31): icmp_seq=2 ttl=64 time=0.202 ms
   64 bytes from compute1 (10.0.0.31): icmp_seq=3 ttl=64 time=0.203 ms
   64 bytes from compute1 (10.0.0.31): icmp_seq=4 ttl=64 time=0.202 ms
   
   --- compute1 ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3000ms
   rtt min/avg/max/mdev = 0.202/0.217/0.263/0.030 ms
   ```

3. 从 *compute* 节点，测试能否连接到 Internet：

   ```bash
   ping -c 4 openstack.org
   
   PING openstack.org (174.143.194.225) 56(84) bytes of data.
   64 bytes from 174.143.194.225: icmp_seq=1 ttl=54 time=18.3 ms
   64 bytes from 174.143.194.225: icmp_seq=2 ttl=54 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_seq=3 ttl=54 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_seq=4 ttl=54 time=17.4 ms
   
   --- openstack.org ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3022ms
   rtt min/avg/max/mdev = 17.489/17.715/18.346/0.364 ms
   ```

4. 从 *compute* 节点，测试到*controller* 节点管理网络是否连通：

   ```bash
   ping -c 4 controller
   
   PING controller (10.0.0.11) 56(84) bytes of data.
   64 bytes from controller (10.0.0.11): icmp_seq=1 ttl=64 time=0.263 ms
   64 bytes from controller (10.0.0.11): icmp_seq=2 ttl=64 time=0.202 ms
   64 bytes from controller (10.0.0.11): icmp_seq=3 ttl=64 time=0.203 ms
   64 bytes from controller (10.0.0.11): icmp_seq=4 ttl=64 time=0.202 ms
   
   --- controller ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3000ms
   rtt min/avg/max/mdev = 0.202/0.217/0.263/0.030 ms
   ```

## 网络时间协议(NTP)

安装Chrony，一个在不同节点同步服务实现 NTP的方案。建议配置控制器节点引用更准确的(lower stratum)NTP服务器，然后其他节点引用控制节点。

### 控制节点服务器

1. 安装软件包：

   ```bash
   yum install chrony
   ```

1. 编辑 `/etc/chrony.conf` 文件，按照你环境的要求，对下面的键进行添加，修改或者删除：

   ```bash
   server NTP_SERVER iburst
   ```

   使用NTP服务器的主机名或者IP地址替换 `NTP_SERVER` 。配置支持设置多个 `server` 值。

   > **注解:**
>
   > 控制节点默认跟公共服务器池同步时间。但是你也可以选择性配置其他服务器，比如你组织中提供的服务器。

2. 为了允许其他节点可以连接到控制节点的 chrony 后台进程，在``/etc/chrony.conf`` 文件添加下面的键：

   ```bash
   allow 10.0.0.0/24
   ```

   如有必要，将 `10.0.0.0/24` 替换成你子网的相应描述。

3. 启动 NTP 服务并将其配置为随系统启动：

   ```bash
   systemctl enable chronyd.service
   systemctl start chronyd.service
   ```

### 其它节点服务器


其他节点会连接控制节点同步时间。


1. 安装软件包：

   ```bash
   yum install chrony
   ```

1. 编辑``/etc/chrony.conf`` 文件并注释除``server`` 值外的所有内容。修改它引用控制节点：

   ```bash
   server controller iburst
   ```

2. 启动 NTP 服务并将其配置为随系统启动：

   ```bash
   systemctl enable chronyd.service
   systemctl start chronyd.service                      
   ```

### 验证操作

1. 在控制节点上执行这个命令：

   ```bash
   chronyc sources
   
     210 Number of sources = 2
     MS Name/IP address         Stratum Poll Reach LastRx Last sample
     ===============================================================================
     ^- 192.0.2.11                    2   7    12   137  -2814us[-3000us] +/-   43ms
     ^* 192.0.2.12                    2   6   177    46    +17us[  -23us] +/-   68ms
   ```

   在 *Name/IP address* 列的内容应显示NTP服务器的主机名或者IP地址。在 *S* 列的内容应该在NTP服务目前同步的上游服务器前显示 `*`。

2. 在所有其他节点执行相同命令：

   ```bash
   chronyc sources
   
     210 Number of sources = 1
     MS Name/IP address         Stratum Poll Reach LastRx Last sample
     ===============================================================================
     ^* controller                    3    9   377   421    +15us[  -87us] +/-   15ms
   
   在 *Name/IP address* 列的内容应显示控制节点的主机名。
   ```

## OpenStack包

**注解:**

禁用或移除所有自动更新的服务，因为它们会影响到您的 OpenStack 环境。

### 先决条件

**警告:**

当使用RDO包时，我们推荐禁用EPEL，原因是EPEL中的更新破坏向后兼容性。或者使用``yum-versionlock``插件指定包版本号。

1. 在RHEL，注册系统使用Red Hat订阅管理，使用您的客户Portal的用户名和密码：

   ```bash
   subscription-manager register --username="USERNAME" --password="PASSWORD"
   ```

2. 为RHEL系统找到授权池包含这些通道：

   ```bash
   subscription-manager list --available
   ```

3. 使用前面步骤找到的池标识绑定您的RHEL授权：

   ```bash
   subscription-manager attach --pool="POOLID"
   ```

4. 启用需要的库：

   ```bash
   subscription-manager repos --enable=rhel-7-server-optional-rpms \
     --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-rh-common-rpms
   ```

### 启用OpenStack库

- 在CentOS中，extras仓库提供用于启用 OpenStack 仓库的RPM包。 CentOS 默认启用``extras``仓库，因此你可以直接安装用于启用OpenStack仓库的包。

   ```bash
  yum install centos-release-openstack-mitaka
  ```

- 在RHEL上，下载和安装RDO仓库RPM来启用OpenStack仓库。

  ```bash
  yum install https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm
  ```

### 完成安装

1. 在主机上升级包：

   ```bash
    yum upgrade
   ```


2. 安装 OpenStack 客户端：

   ```bash
   yum install python-openstackclient
   ```

1. RHEL 和 CentOS 默认启用了 [*SELinux*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-selinux) . 安装 `openstack-selinux` 软件包以便自动管理 OpenStack 服务的安全策略:

   ```bash
   yum install openstack-selinux                      
   ```

## SQL数据库

大多数 OpenStack 服务使用 SQL 数据库来存储信息。 典型地，数据库运行在控制节点上。OpenStack 服务也支持其他 SQL 数据库，包括PostgreSQL 。

1. 安装软件包：

   ```bash
   yum install mariadb mariadb-server python2-PyMySQL
   ```

1. 创建并编辑 `/etc/my.cnf.d/openstack.cnf`，然后完成如下动作：

   - 在 `[mysqld]` 部分，设置 `bind-address`值为控制节点的管理网络IP地址以使得其它节点可以通过管理网络访问数据库：

     ```bash
     [mysqld]
     ...
     bind-address = 10.0.0.11
     ```

   - 在``[mysqld]`` 部分，设置如下键值来启用一起有用的选项和 UTF-8 字符集：

     ```bash
     [mysqld]
     ...
     default-storage-engine = innodb
     innodb_file_per_table
     max_connections = 4096
     collation-server = utf8_general_ci
     character-set-server = utf8
     ```

3. 启动数据库服务，并将其配置为开机自启：

     ```bash
    systemctl enable mariadb.service
    systemctl start mariadb.service
    ```

4. 为了保证数据库服务的安全性，运行``mysql_secure_installation``脚本。特别需要说明的是，为数据库的`root`用户设置一个适当的密码。

    ```bash
    mysql_secure_installation
    ```

## NoSQL 数据库

Telemetry 服务使用 NoSQL 数据库来存储信息，典型地，这个数据库运行在控制节点上。向导中使用MongoDB。

1. 安装MongoDB包：

   ```bash
   yum install mongodb-server mongodb
   ```

1. 编辑文件 `/etc/mongod.conf` 并完成如下动作：

   - 配置 `bind_ip` 使用控制节点管理网卡的IP地址。

     ```bash
     bind_ip = 10.0.0.11
     ```

   - 默认情况下，MongoDB会在``/var/lib/mongodb/journal`` 目录下创建几个 1 GB 大小的日志文件。如果你想将每个日志文件大小减小到128MB并且限制日志文件占用的总空间为512MB，配置 `smallfiles` 的值：

     ```bash
     smallfiles = true
     ```

     你也可以禁用日志。

3. 启动MongoDB 并配置它随系统启动：

   ```bash
   systemctl enable mongod.service
   systemctl start mongod.service
   ```

## 消息队列

OpenStack 使用 [*message queue*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-message-queue) 协调操作和各服务的状态信息。消息队列服务一般运行在控制节点上。OpenStack支持好几种消息队列服务包括 [RabbitMQ](http://www.rabbitmq.com), [Qpid](http://qpid.apache.org), 和 [ZeroMQ](http://zeromq.org)。

1. 安装包：

   ```bash
   yum install rabbitmq-server
   ```

1. 启动消息队列服务并将其配置为随系统启动：

   ```bash
   systemctl enable rabbitmq-server.service
   systemctl start rabbitmq-server.service
   ```

3. 添加 `openstack` 用户：

   ```bash
   rabbitmqctl add_user openstack RABBIT_PASS
   
   Creating user "openstack" ...
   ...done.
   ```

   用合适的密码替换 `RABBIT_DBPASS`。

3. 给``openstack``用户配置写和读权限：

   ```bash
   rabbitmqctl set_permissions openstack ".*" ".*" ".*"
   
   Setting permissions for user "openstack" in vhost "/" ...
   ...done.  
   ```

## Memcached

认证服务认证缓存使用Memcached缓存令牌。缓存服务memecached运行在控制节点。在生产部署中，我们推荐联合启用防火墙、认证和加密保证它的安全。

1. 安装软件包：

   ```bash
   yum install memcached python-memcached
   ```

2. 启动Memcached服务，并且配置它随机启动。

   ```bash
   systemctl enable memcached.service
   systemctl start memcached.service
   ```



## 镜像服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- [镜像服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_image_service.html)
- 安装和配置
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-verify.html)

镜像服务 (glance) 允许用户发现、注册和获取虚拟机镜像。它提供了一个 [*REST*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-restful) API，允许您查询虚拟机镜像的 metadata 并获取一个现存的镜像。您可以将虚拟机镜像存储到各种位置，从简单的文件系统到对象存储系统—-例如 OpenStack 对象存储, 并通过镜像服务使用。



 

重要



简单来说，本指南描述了使用`file``作为后端配置镜像服务，能够上传并存储在一个托管镜像服务的控制节点目录中。默认情况下，这个目录是 /var/lib/glance/images/。

继续进行之前，确认控制节点的该目录有至少几千兆字节的可用空间。

关于后端要求的更多信息，参考`配置参考 <http://docs.openstack.org/mitaka/config-reference/image-service.html>`__。

## 镜像服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack镜像服务是IaaS的核心服务，如同 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_image_service.html#id1)get_started_conceptual_architecture`所示。它接受磁盘镜像或服务器镜像API请求，和来自终端用户或OpenStack计算组件的元数据定义。它也支持包括OpenStack对象存储在内的多种类型仓库上的磁盘镜像或服务器镜像存储。

大量周期性进程运行于OpenStack镜像服务上以支持缓存。同步复制（Replication）服务保证集群中的一致性和可用性。其它周期性进程包括auditors, updaters, 和 reapers。

OpenStack镜像服务包括以下组件：

- glance-api

  接收镜像API的调用，诸如镜像发现、恢复、存储。

- glance-registry

  存储、处理和恢复镜像的元数据，元数据包括项诸如大小和类型。  警告 glance-registry是私有内部服务，用于服务OpenStack Image服务。不要向用户暴露该服务

- 数据库

  存放镜像元数据，用户是可以依据个人喜好选择数据库的，多数的部署使用MySQL或SQLite。

- 镜像文件的存储仓库

  支持多种类型的仓库，它们有普通文件系统、对象存储、RADOS块设备、HTTP、以及亚马逊S3。记住，其中一些仓库仅支持只读方式使用。

- 元数据定义服务

  通用的API，是用于为厂商，管理员，服务，以及用户自定义元数据。这种元数据可用于不同的资源，例如镜像，工件，卷，配额以及集合。一个定义包括了新属性的键，描述，约束以及可以与之关联的资源的类型。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#finalize-installation)

这个部分描述如何在控制节点上安装和配置镜像服务，即 glance。简单来说，这个配置将镜像保存在本地文件系统中。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#prerequisites)

安装和配置镜像服务之前，你必须创建创建一个数据库、服务凭证和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 `glance` 数据库：

     ```
     CREATE DATABASE glance;
     ```

   - 对``glance``数据库授予恰当的权限：

     ```
     GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
       IDENTIFIED BY 'GLANCE_DBPASS';
     GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
       IDENTIFIED BY 'GLANCE_DBPASS';
     ```

     用一个合适的密码替换 `GLANCE_DBPASS`。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 `glance` 用户：

     ```
     $ openstack user create --domain default --password-prompt glance
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | e38230eeff474607805b596c91fa15d9 |
     | name      | glance                           |
     +-----------+----------------------------------+
     ```

   - 添加 `admin` 角色到 `glance` 用户和 `service` 项目上。

     ```
     $ openstack role add --project service --user glance admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建``glance``服务实体：

     ```
     $ openstack service create --name glance \
       --description "OpenStack Image" image
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Image                  |
     | enabled     | True                             |
     | id          | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
     | name        | glance                           |
     | type        | image                            |
     +-------------+----------------------------------+
     ```

4. 创建镜像服务的 API 端点：

   ```
   $ openstack endpoint create --region RegionOne \
     image public http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 340be3625e9b4239a6415d034e98aace |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     image internal http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | a6e4b153c2ae4c919eccfdbb7dceb5d2 |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     image admin http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 0c37ed58103f4300a84ff125a539032d |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-glance
   ```

1. 编辑文件 `/etc/glance/glance-api.conf` 并完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
     ```

     将``GLANCE_DBPASS`` 替换为你为镜像服务选择的密码。

   - 在 `[keystone_authtoken]` 和 `[paste_deploy]` 部分，配置认证服务访问：

     ```
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = glance
     password = GLANCE_PASS
     
     [paste_deploy]
     ...
     flavor = keystone
     ```

     将 `GLANCE_PASS` 替换为你为认证服务中你为 `glance` 用户选择的密码。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[glance_store]` 部分，配置本地文件系统存储和镜像文件位置：

     ```
     [glance_store]
     ...
     stores = file,http
     default_store = file
     filesystem_store_datadir = /var/lib/glance/images/
     ```

2. 编辑文件 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#id1)/etc/glance/glance-registry.conf``并完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
     ```

     将``GLANCE_DBPASS`` 替换为你为镜像服务选择的密码。

   - 在 `[keystone_authtoken]` 和 `[paste_deploy]` 部分，配置认证服务访问：

     ```
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = glance
     password = GLANCE_PASS
     
     [paste_deploy]
     ...
     flavor = keystone
     ```

     将 `GLANCE_PASS` 替换为你为认证服务中你为 `glance` 用户选择的密码。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

1. 写入镜像服务数据库：

   ```
   # su -s /bin/sh -c "glance-manage db_sync" glance
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-install.html#finalize-installation)

- 启动镜像服务、配置他们随机启动：

  ```
  # systemctl enable openstack-glance-api.service \
    openstack-glance-registry.service
  # systemctl start openstack-glance-api.service \
    openstack-glance-registry.service
  ```

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

使用 [`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-verify.html#id1)CirrOS <http://launchpad.net/cirros>`__对镜像服务进行验证，CirrOS是一个小型的Linux镜像可以用来帮助你进行 OpenStack部署测试。

关于如何下载和构建镜像的更多信息，参考`OpenStack Virtual Machine Image Guide <http://docs.openstack.org/image-guide/>`__。关于如何管理镜像的更多信息，参考`OpenStack用户手册 <http://docs.openstack.org/user-guide/common/cli-manage-images.html>`__。



 

注解



在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 下载源镜像：

   ```
   $ wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
   ```

   

    

   注解

   

   如果您的发行版里没有包含wget，请安装它

3. 使用 [*QCOW2*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-qemu-copy-on-write-2-qcow2) 磁盘格式， [*bare*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-bare) 容器格式上传镜像到镜像服务并设置公共可见，这样所有的项目都可以访问它：

   ```
   $ openstack image create "cirros" \
     --file cirros-0.3.4-x86_64-disk.img \
     --disk-format qcow2 --container-format bare \
     --public
   +------------------+------------------------------------------------------+
   | Property         | Value                                                |
   +------------------+------------------------------------------------------+
   | checksum         | 133eae9fb1c98f45894a4e60d8736619                     |
   | container_format | bare                                                 |
   | created_at       | 2015-03-26T16:52:10Z                                 |
   | disk_format      | qcow2                                                |
   | file             | /v2/images/cc5c6982-4910-471e-b864-1098015901b5/file |
   | id               | cc5c6982-4910-471e-b864-1098015901b5                 |
   | min_disk         | 0                                                    |
   | min_ram          | 0                                                    |
   | name             | cirros                                               |
   | owner            | ae7a98326b9c455588edd2656d723b9d                     |
   | protected        | False                                                |
   | schema           | /v2/schemas/image                                    |
   | size             | 13200896                                             |
   | status           | active                                               |
   | tags             |                                                      |
   | updated_at       | 2015-03-26T16:52:10Z                                 |
   | virtual_size     | None                                                 |
   | visibility       | public                                               |
   +------------------+------------------------------------------------------+
   ```

   更多关于命令:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-verify.html#id1)glance image-create`的参数信息，请参考``OpenStack Command-Line Interface Reference``中的`Image service command-line client  <http://docs.openstack.org/cli-reference/openstack.html#openstack-image-create>`部分。

   更多镜像磁盘和容器格式信息，参考 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/glance-verify.html#id1)OpenStack虚拟机镜像指南``中的`镜像的磁盘及容器格式 <http://docs.openstack.org/image-guide/image-formats.html>`__ 部分。

   

    

   注解

   

   OpenStack 是动态生成 ID 的，因此您看到的输出会与示例中的命令行输出不相同。

4. 确认镜像的上传并验证属性：

   ```
   $ openstack image list
   +--------------------------------------+--------+--------+
   | ID                                   | Name   | Status |
   +--------------------------------------+--------+--------+
   | 38047887-61a7-41ea-9b49-27987d5e8bb9 | cirros | active |
   +--------------------------------------+--------+--------+
   ```

## 计算服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- [计算服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html)
- 安装并配置控制节点
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#finalize-installation)
- 安装和配置计算节点
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-verify.html)

​                      

## 计算服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

使用OpenStack计算服务来托管和管理云计算系统。OpenStack计算服务是基础设施即服务([*IaaS*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-iaas))系统的主要部分，模块主要由Python实现。

OpenStack计算组件请求OpenStack Identity服务进行认证；请求OpenStack  Image服务提供磁盘镜像；为OpenStack  dashboard提供用户与管理员接口。磁盘镜像访问限制在项目与用户上；配额以每个项目进行设定（例如，每个项目下可以创建多少实例）。OpenStack组件可以在标准硬件上水平大规模扩展，并且下载磁盘镜像启动虚拟机实例。

OpenStack计算服务由下列组件所构成：

- `nova-api` 服务

  接收和响应来自最终用户的计算API请求。此服务支持OpenStack计算服务API，Amazon EC2 API，以及特殊的管理API用于赋予用户做一些管理的操作。它会强制实施一些规则，发起多数的编排活动，例如运行一个实例。

- `nova-api-metadata` 服务

  接受来自虚拟机发送的元数据请求。[``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova-api-metadata``服务一般在安装``nova-network``服务的多主机模式下使用。更详细的信息，请参考OpenStack管理员手册中的链接`Metadata service <http://docs.openstack.org/admin-guide/compute-networking-nova.html#metadata-service>`__ in the OpenStack Administrator Guide。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova-compute``服务

  一个持续工作的守护进程，通过Hypervior的API来创建和销毁虚拟机实例。例如： XenServer/XCP 的 XenAPI KVM 或 QEMU 的 libvirt VMware 的 VMwareAPI  过程是蛮复杂的。最为基本的，守护进程同意了来自队列的动作请求，转换为一系列的系统命令如启动一个KVM实例，然后，到数据库中更新它的状态。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova-scheduler``服务

  拿到一个来自队列请求虚拟机实例，然后决定那台计算服务器主机来运行它。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova-conductor``模块

  媒介作用于``nova-compute``服务与数据库之间。它排除了由``nova-compute``服务对云数据库的直接访问。nova-conductor模块可以水平扩展。但是，不要将它部署在运行``nova-compute``服务的主机节点上。参考Configuration Reference Guide <http://docs.openstack.org/mitaka/config-reference/compute/conductor.html>`__。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova-cert``模块

  服务器守护进程向Nova Cert服务提供X509证书。用来为``euca-bundle-image``生成证书。仅仅是在EC2 API的请求中使用

- `nova-network worker` 守护进程

  与``nova-compute``服务类似，从队列中接受网络任务，并且操作网络。执行任务例如创建桥接的接口或者改变IPtables的规则。

- `nova-consoleauth` 守护进程

  授权控制台代理所提供的用户令牌。详情可查看``nova-novncproxy``和 `nova-xvpvncproxy`。该服务必须为控制台代理运行才可奏效。在集群配置中你可以运行二者中任一代理服务而非仅运行一个nova-consoleauth服务。更多关于nova-consoleauth的信息，请查看`About nova-consoleauth <http://docs.openstack.org/admin-guide/compute-remote-console-access.html#about-nova-consoleauth>`__。

- `nova-novncproxy` 守护进程

  提供一个代理，用于访问正在运行的实例，通过VNC协议，支持基于浏览器的novnc客户端。

- `nova-spicehtml5proxy` 守护进程

  提供一个代理，用于访问正在运行的实例，通过 SPICE 协议，支持基于浏览器的 HTML5 客户端。

- `nova-xvpvncproxy` 守护进程

  提供一个代理，用于访问正在运行的实例，通过VNC协议，支持OpenStack特定的Java客户端。

- `nova-cert` 守护进程

  X509 证书。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_compute.html#id1)nova``客户端

  用于用户作为租户管理员或最终用户来提交命令。

- 队列

  一个在守护进程间传递消息的中央集线器。常见实现有`RabbitMQ <http://www.rabbitmq.com/>`__ , 以及如`Zero MQ <http://www.zeromq.org/>`__等AMQP消息队列。

- SQL数据库

  存储构建时和运行时的状态，为云基础设施，包括有： 可用实例类型 使用中的实例 可用网络 项目  理论上，OpenStack计算可以支持任何和SQL-Alchemy所支持的后端数据库，通常使用SQLite3来做测试可开发工作，MySQL和PostgreSQL 作生产环境。

​                      

## 安装并配置控制节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#finalize-installation)

这个部分将描述如何在控制节点上安装和配置 Compute 服务，即 nova。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#prerequisites)

在安装和配置 Compute 服务前，你必须创建数据库服务的凭据以及 API endpoints。

1. 为了创建数据库，必须完成这些步骤：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 `nova_api` 和 `nova` 数据库：

     ```
     CREATE DATABASE nova_api;
     CREATE DATABASE nova;
     ```

   - 对数据库进行正确的授权：

     ```
     GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
       IDENTIFIED BY 'NOVA_DBPASS';
     GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
       IDENTIFIED BY 'NOVA_DBPASS';
     GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
       IDENTIFIED BY 'NOVA_DBPASS';
     GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
       IDENTIFIED BY 'NOVA_DBPASS';
     ```

     用合适的密码代替 `NOVA_DBPASS`。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 `nova` 用户：

     ```
     $ openstack user create --domain default \
       --password-prompt nova
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | 8c46e4760902464b889293a74a0c90a8 |
     | name      | nova                             |
     +-----------+----------------------------------+
     ```

   - 给 `nova` 用户添加 `admin` 角色：

     ```
     $ openstack role add --project service --user nova admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建 `nova` 服务实体：

     ```
     $ openstack service create --name nova \
       --description "OpenStack Compute" compute
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Compute                |
     | enabled     | True                             |
     | id          | 060d59eac51b4594815603d75a00aba2 |
     | name        | nova                             |
     | type        | compute                          |
     +-------------+----------------------------------+
     ```

4. 创建 Compute 服务 API 端点 ：

   ```
   $ openstack endpoint create --region RegionOne \
     compute public http://controller:8774/v2.1/%\(tenant_id\)s
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | 3c1caa473bfe4390a11e7177894bcc7b          |
   | interface    | public                                    |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1/%(tenant_id)s |
   +--------------+-------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     compute internal http://controller:8774/v2.1/%\(tenant_id\)s
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | e3c918de680746a586eac1f2d9bc10ab          |
   | interface    | internal                                  |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1/%(tenant_id)s |
   +--------------+-------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     compute admin http://controller:8774/v2.1/%\(tenant_id\)s
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | 38f7af91666a47cfb97b4dc790b94424          |
   | interface    | admin                                     |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1/%(tenant_id)s |
   +--------------+-------------------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-nova-api openstack-nova-conductor \
     openstack-nova-console openstack-nova-novncproxy \
     openstack-nova-scheduler
   ```

1. 编辑``/etc/nova/nova.conf``文件并完成下面的操作：

   - 在``[DEFAULT]``部分，只启用计算和元数据API：

     ```
     [DEFAULT]
     ...
     enabled_apis = osapi_compute,metadata
     ```

   - 在``[api_database]``和``[database]``部分，配置数据库的连接：

     ```
     [api_database]
     ...
     connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api
     
     [database]
     ...
     connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova
     ```

     用你为 Compute 数据库选择的密码来代替 `NOVA_DBPASS`。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = nova
     password = NOVA_PASS
     ```

     使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[DEFAULT` 部分，配置``my_ip`` 来使用控制节点的管理接口的IP 地址。

     ```
     [DEFAULT]
     ...
     my_ip = 10.0.0.11
     ```

   - 在  `[DEFAULT]` 部分，使能 Networking 服务：

     ```
     [DEFAULT]
     ...
     use_neutron = True
     firewall_driver = nova.virt.firewall.NoopFirewallDriver
     ```

     

      

     注解

     

     默认情况下，计算服务使用内置的防火墙服务。由于网络服务包含了防火墙服务，你必须使用``nova.virt.firewall.NoopFirewallDriver``防火墙服务来禁用掉计算服务内置的防火墙服务

   - 在``[vnc]``部分，配置VNC代理使用控制节点的管理接口IP地址 ：

     ```
     [vnc]
     ...
     vncserver_listen = $my_ip
     vncserver_proxyclient_address = $my_ip
     ```

   - 在 `[glance]` 区域，配置镜像服务 API 的位置：

     ```
     [glance]
     ...
     api_servers = http://controller:9292
     ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/nova/tmp
     ```

1. 同步Compute 数据库：

   ```
   # su -s /bin/sh -c "nova-manage api_db sync" nova
   # su -s /bin/sh -c "nova-manage db sync" nova
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-controller-install.html#finalize-installation)

- 启动 Compute 服务并将其设置为随系统启动：

  ```
  # systemctl enable openstack-nova-api.service \
    openstack-nova-consoleauth.service openstack-nova-scheduler.service \
    openstack-nova-conductor.service openstack-nova-novncproxy.service
  # systemctl start openstack-nova-api.service \
    openstack-nova-consoleauth.service openstack-nova-scheduler.service \
    openstack-nova-conductor.service openstack-nova-novncproxy.service
  ```

​                      

## 安装和配置计算节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#finalize-installation)

这部分描述如何在计算节点上安装并配置计算服务。计算服务支持多种虚拟化方式 [*hypervisors*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-hypervisor) to deploy [*instances*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-instance) or [*VMs*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-virtual-machine-vm). For simplicity, this configuration uses the [*QEMU*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-quick-emulator-qemu) hypervisor with the :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#id1)KVM <kernel-based VM (KVM)>`计算节点需支持对虚拟化的硬件加速。对于传统的硬件，本配置使用generic qumu的虚拟化方式。你可以根据这些说明进行细微的调整，或者使用额外的计算节点来横向扩展你的环境。



 

注解



这部分假设你已经一步一步的按照之前的向导配置好了第一个计算节点。如果你想要配置额外的计算节点，像:ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#id1)example architectures <overview-example-architectures>`部分中第一个计算节点那样准备好。每个额外的计算节点都需要一个唯一的IP地址。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-nova-compute
   ```

1. 编辑``/etc/nova/nova.conf``文件并完成下面的操作：

   - 在``[DEFAULT]`` 和 [oslo_messaging_rabbit]部分，配置``RabbitMQ``消息队列的连接：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = nova
     password = NOVA_PASS
     ```

     使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[DEFAULT]` 部分，配置 `my_ip` 选项：

     ```
     [DEFAULT]
     ...
     my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     ```

     将其中的 `MANAGEMENT_INTERFACE_IP_ADDRESS` 替换为计算节点上的管理网络接口的IP 地址，例如 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#id1)example architecture <overview-example-architectures>`中所示的第一个节点 10.0.0.31 。

   - 在  `[DEFAULT]` 部分，使能 Networking 服务：

     ```
     [DEFAULT]
     ...
     use_neutron = True
     firewall_driver = nova.virt.firewall.NoopFirewallDriver
     ```

     

      

     注解

     

     缺省情况下，Compute 使用内置的防火墙服务。由于 Networking 包含了防火墙服务，所以你必须通过使用 `nova.virt.firewall.NoopFirewallDriver` 来去除 Compute 内置的防火墙服务。

   - 在``[vnc]``部分，启用并配置远程控制台访问：

     ```
     [vnc]
     ...
     enabled = True
     vncserver_listen = 0.0.0.0
     vncserver_proxyclient_address = $my_ip
     novncproxy_base_url = http://controller:6080/vnc_auto.html
     ```

     服务器组件监听所有的 IP 地址，而代理组件仅仅监听计算节点管理网络接口的 IP 地址。基本的 URL 指示您可以使用 web 浏览器访问位于该计算节点上实例的远程控制台的位置。

     

      

     注解

     

     如果你运行浏览器的主机无法解析``controller`` 主机名，你可以将 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#id1)controller``替换为你控制节点管理网络的IP地址。

   - 在 `[glance]` 区域，配置镜像服务 API 的位置：

     ```
     [glance]
     ...
     api_servers = http://controller:9292
     ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/nova/tmp
     ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/nova-compute-install.html#finalize-installation)

1. 确定您的计算节点是否支持虚拟机的硬件加速。

   ```
   $ egrep -c '(vmx|svm)' /proc/cpuinfo
   ```

   如果这个命令返回了 `one or greater` 的值，那么你的计算节点支持硬件加速且不需要额外的配置。

   如果这个命令返回了 `zero` 值，那么你的计算节点不支持硬件加速。你必须配置 `libvirt` 来使用 QEMU 去代替 KVM

   - 在 `/etc/nova/nova.conf` 文件的  `[libvirt]` 区域做出如下的编辑：

     ```
     [libvirt]
     ...
     virt_type = qemu
     ```

1. 启动计算服务及其依赖，并将其配置为随系统自动启动：

   ```
   # systemctl enable libvirtd.service openstack-nova-compute.service
   # systemctl start libvirtd.service openstack-nova-compute.service
   ```

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

验证计算服务的操作。



 

注解



在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出服务组件，以验证是否成功启动并注册了每个进程：

   ```
   $ openstack compute service list
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   | Id | Binary             | Host       | Zone     | Status  | State | Updated At                 |
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   |  1 | nova-consoleauth   | controller | internal | enabled | up    | 2016-02-09T23:11:15.000000 |
   |  2 | nova-scheduler     | controller | internal | enabled | up    | 2016-02-09T23:11:15.000000 |
   |  3 | nova-conductor     | controller | internal | enabled | up    | 2016-02-09T23:11:16.000000 |
   |  4 | nova-compute       | compute1   | nova     | enabled | up    | 2016-02-09T23:11:20.000000 |
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   ```

   

    

   注解

   

   该输出应该显示三个服务组件在控制节点上启用，一个服务组件在计算节点上启用。

## Networking 服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



- [网络服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_networking.html)
- [网络（neutron）概念](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-concepts.html)
- [安装并配置控制节点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html)
- [安装和配置计算节点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-next-steps.html)

本章节结束如何安装并配置网络服务（neutron）采用:ref:provider networks <选项1>`或:ref:`self-service networks <选项2>

更多关于网络服务的信息，包括虚拟网络组件，结构以及数据流，请参见`Networking Guide <http://docs.openstack.org/mitaka/networking-guide/>`__.

## 网络服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack Networking（neutron），允许创建、插入接口设备，这些设备由其他的OpenStack服务管理。插件式的实现可以容纳不同的网络设备和软件，为OpenStack架构与部署提供了灵活性。

它包含下列组件：

- neutron-server

  接收和路由API请求到合适的OpenStack网络插件，以达到预想的目的。

- OpenStack网络插件和代理

  插拔端口，创建网络和子网，以及提供IP地址，这些插件和代理依赖于供应商和技术而不同，OpenStack网络基于插件和代理为Cisco 虚拟和物理交换机、NEC OpenFlow产品，Open vSwitch,Linux bridging以及VMware NSX 产品穿线搭桥。 常见的代理L3(3层)，DHCP(动态主机IP地址)，以及插件代理。

- 消息队列

  大多数的OpenStack Networking安装都会用到，用于在neutron-server和各种各样的代理进程间路由信息。也为某些特定的插件扮演数据库的角色，以存储网络状态

OpenStack网络主要和OpenStack计算交互，以提供网络连接到它的实例。

## 网络（neutron）概念

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack网络（neutron）管理OpenStack环境中所有虚拟网络基础设施（VNI），物理网络基础设施（PNI）的接入层。OpenStack网络允许租户创建包括像 [*firewall*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-firewall)， :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-concepts.html#id1)load balancer`和 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-concepts.html#id3)virtual private network (VPN)`等这样的高级虚拟网络拓扑。

网络服务提供网络，子网以及路由这些对象的抽象概念。每个抽象概念都有自己的功能，可以模拟对应的物理设备：网络包括子网，路由在不同的子网和网络间进行路由转发。

对于任意一个给定的网络都必须包含至少一个外部网络。不像其他的网络那样，外部网络不仅仅是一个定义的虚拟网络。相反，它代表了一种OpenStack安装之外的能从物理的，外部的网络访问的视图。外部网络上的IP地址可供外部网络上的任意的物理设备所访问

外部网络之外，任何 Networking 设置拥有一个或多个内部网络。这些软件定义的网络直接连接到虚拟机。仅仅在给定网络上的虚拟机，或那些在通过接口连接到相近路由的子网上的虚拟机，能直接访问连接到那个网络上的虚拟机。

如果外部网络想要访问实例或者相反实例想要访问外部网络，那么网络之间的路由就是必要的了。每一个路由都配有一个网关用于连接到外部网络，以及一个或多个连接到内部网络的接口。就像一个物理路由一样，子网可以访问同一个路由上其他子网中的机器，并且机器也可以访问路由的网关访问外部网络。

另外，你可以将外部网络的IP地址分配给内部网络的端口。不管什么时候一旦有连接连接到子网，那个连接被称作端口。你可以给实例的端口分配外部网络的IP地址。通过这种方式，外部网络上的实体可以访问实例.

网络服务同样支持安全组。安全组允许管理员在安全组中定义防火墙规则。一个实例可以属于一个或多个安全组，网络为这个实例配置这些安全组中的规则，阻止或者开启端口，端口范围或者通信类型。

每一个Networking使用的插件都有其自有的概念。虽然对操作VNI和OpenStack环境不是至关重要的，但理解这些概念能帮助你设置Networking。所有的Networking安装使用了一个核心插件和一个安全组插件(或仅是空操作安全组插件)。另外，防火墙即服务(FWaaS)和负载均衡即服务(LBaaS)插件是可用的。

## 安装并配置控制节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#prerequisites)
  - [配置网络选项](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-networking-options)
  - [配置元数据代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-the-metadata-agent)
  - [为计算节点配置网络服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-compute-to-use-networking)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#finalize-installation)

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#prerequisites)

在你配置OpenStack网络（neutron）服务之前，你必须为其创建一个数据库，服务凭证和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建``neutron`` 数据库：

     ```
     CREATE DATABASE neutron;
     ```

   - 对``neutron`` 数据库授予合适的访问权限，使用合适的密码替换``NEUTRON_DBPASS``：

     ```
     GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
       IDENTIFIED BY 'NEUTRON_DBPASS';
     GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
       IDENTIFIED BY 'NEUTRON_DBPASS';
     ```

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建``neutron``用户：

     ```
     $ openstack user create --domain default --password-prompt neutron
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | b20a6692f77b4258926881bf831eb683 |
     | name      | neutron                          |
     +-----------+----------------------------------+
     ```

   - 添加``admin`` 角色到``neutron`` 用户：

     ```
     $ openstack role add --project service --user neutron admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建``neutron``服务实体：

     ```
     $ openstack service create --name neutron \
       --description "OpenStack Networking" network
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Networking             |
     | enabled     | True                             |
     | id          | f71529314dab4a4d8eca427e701d209e |
     | name        | neutron                          |
     | type        | network                          |
     +-------------+----------------------------------+
     ```

4. 创建网络服务API端点：

   ```
   $ openstack endpoint create --region RegionOne \
     network public http://controller:9696
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 85d80a6d02fc4b7683f611d7fc1493a3 |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | f71529314dab4a4d8eca427e701d209e |
   | service_name | neutron                          |
   | service_type | network                          |
   | url          | http://controller:9696           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     network internal http://controller:9696
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 09753b537ac74422a68d2d791cf3714f |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | f71529314dab4a4d8eca427e701d209e |
   | service_name | neutron                          |
   | service_type | network                          |
   | url          | http://controller:9696           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     network admin http://controller:9696
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 1ee14289c9374dffb5db92a5c112fc4e |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | f71529314dab4a4d8eca427e701d209e |
   | service_name | neutron                          |
   | service_type | network                          |
   | url          | http://controller:9696           |
   +--------------+----------------------------------+
   ```

## 配置网络选项[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-networking-options)

您可以部署网络服务使用选项1和选项2两种架构中的一种来部署网络服务。

选项1采用尽可能简单的架构进行部署，只支持实例连接到公有网络（外部网络）。没有私有网络（个人网络），路由器以及浮动IP地址。只有``admin``或者其他特权用户才可以管理公有网络

选项2在选项1的基础上多了layer－3服务，支持实例连接到私有网络。[``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#id1)demo``或者其他没有特权的用户可以管理自己的私有网络，包含连接公网和私网的路由器。另外，浮动IP地址可以让实例使用私有网络连接到外部网络，例如互联网

典型的私有网络一般使用覆盖网络。覆盖网络，例如VXLAN包含了额外的数据头，这些数据头增加了开销，减少了有效内容和用户数据的可用空间。在不了解虚拟网络架构的情况下，实例尝试用以太网 *最大传输单元 (MTU)* 1500字节发送数据包。网络服务会自动给实例提供正确的MTU的值通过DHCP的方式。但是，一些云镜像并没有使用DHCP或者忽视了DHCP MTU选项，要求使用元数据或者脚本来进行配置



 

注解



选项2同样支持实例连接到公共网络

从以下的网络选项中选择一个来配置网络服务。之后，返回到这里，进行下一步:ref:neutron-controller-metadata-agent。

- [网络选项1：公共网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html)
- [网络选项2：私有网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html)



## 配置元数据代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-the-metadata-agent)

The :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#id1)metadata agent <Metadata agent>`负责提供配置信息，例如：访问实例的凭证

- 编辑``/etc/neutron/metadata_agent.ini``文件并完成以下操作：

  - 在``[DEFAULT]`` 部分，配置元数据主机以及共享密码：

    ```
    [DEFAULT]
    ...
    nova_metadata_ip = controller
    metadata_proxy_shared_secret = METADATA_SECRET
    ```

    用你为元数据代理设置的密码替换 `METADATA_SECRET`。

## 为计算节点配置网络服务[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#configure-compute-to-use-networking)

- 编辑``/etc/nova/nova.conf``文件并完成以下操作：

  - 在``[neutron]``部分，配置访问参数，启用元数据代理并设置密码：

    ```
    [neutron]
    ...
    url = http://controller:9696
    auth_url = http://controller:35357
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    
    service_metadata_proxy = True
    metadata_proxy_shared_secret = METADATA_SECRET
    ```

    将 `NEUTRON_PASS` 替换为你在认证服务中为 `neutron` 用户选择的密码。

    使用你为元数据代理设置的密码替换``METADATA_SECRET``

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#finalize-installation)

1. 网络服务初始化脚本需要一个超链接 `/etc/neutron/plugin.ini``指向ML2插件配置文件`/etc/neutron/plugins/ml2/ml2_conf.ini``。如果超链接不存在，使用下面的命令创建它：

   ```
   # ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
   ```

2. 同步数据库：

   ```
   # su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
     --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
   ```

   

    

   注解

   

   数据库的同步发生在 Networking 之后，因为脚本需要完成服务器和插件的配置文件。

3. 重启计算API 服务：

   ```
   # systemctl restart openstack-nova-api.service
   ```

4. 当系统启动时，启动  Networking 服务并配置它启动。

   对于两种网络选项：

   ```
   # systemctl enable neutron-server.service \
     neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
     neutron-metadata-agent.service
   # systemctl start neutron-server.service \
     neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
     neutron-metadata-agent.service
   ```

   对于网络选项2，同样启用layer－3服务并设置其随系统自启动

   ```
   # systemctl enable neutron-l3-agent.service
   # systemctl start neutron-l3-agent.service
   ```

​                      

## 网络选项1：公共网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安装组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#install-the-components)
  - [配置服务组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#id1)
  - [配置 Modular Layer 2 (ML2) 插件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-modular-layer-2-ml2-plug-in)
  - [配置Linuxbridge代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-linux-bridge-agent)
  - [配置DHCP代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-dhcp-agent)

在controller节点上安装并配置网络组件

## 安装组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#install-the-components)

```
# yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables
```

## 配置服务组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#id1)

Networking 服务器组件的配置包括数据库、认证机制、消息队列、拓扑变化通知和插件。



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

- 编辑``/etc/neutron/neutron.conf`` 文件并完成如下操作：

  - 在 `[database]` 部分，配置数据库访问：

    ```
    [database]
    ...
    connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron
    ```

    使用你设置的数据库密码替换 `NEUTRON_DBPASS` 。

  - 在``[DEFAULT]``部分，启用ML2插件并禁用其他插件：

    ```
    [DEFAULT]
    ...
    core_plugin = ml2
    service_plugins =
    ```

  - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列的连接：

    ```
    [DEFAULT]
    ...
    rpc_backend = rabbit
    
    [oslo_messaging_rabbit]
    ...
    rabbit_host = controller
    rabbit_userid = openstack
    rabbit_password = RABBIT_PASS
    ```

    用你在RabbitMQ中为``openstack``选择的密码替换 “RABBIT_PASS”。

  - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

    ```
    [DEFAULT]
    ...
    auth_strategy = keystone
    
    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000
    auth_url = http://controller:35357
    memcached_servers = controller:11211
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    ```

    将 `NEUTRON_PASS` 替换为你在认证服务中为 `neutron` 用户选择的密码。

    

     

    注解

    

    在 `[keystone_authtoken]` 中注释或者删除其他选项。

  - 在``[DEFAULT]``和``[nova]``部分，配置网络服务来通知计算节点的网络拓扑变化：

    ```
    [DEFAULT]
    ...
    notify_nova_on_port_status_changes = True
    notify_nova_on_port_data_changes = True
    
    [nova]
    ...
    auth_url = http://controller:35357
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = nova
    password = NOVA_PASS
    ```

    使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

  - 在 `[oslo_concurrency]` 部分，配置锁路径：

    ```
    [oslo_concurrency]
    ...
    lock_path = /var/lib/neutron/tmp
    ```

## 配置 Modular Layer 2 (ML2) 插件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-modular-layer-2-ml2-plug-in)

ML2插件使用Linuxbridge机制来为实例创建layer－2虚拟网络基础设施

- 编辑``/etc/neutron/plugins/ml2/ml2_conf.ini``文件并完成以下操作：

  - 在``[ml2]``部分，启用flat和VLAN网络：

    ```
    [ml2]
    ...
    type_drivers = flat,vlan
    ```

  - 在``[ml2]``部分，禁用私有网络：

    ```
    [ml2]
    ...
    tenant_network_types =
    ```

  - 在``[ml2]``部分，启用Linuxbridge机制：

    ```
    [ml2]
    ...
    mechanism_drivers = linuxbridge
    ```

    

     

    警告

    

    在你配置完ML2插件之后，删除可能导致数据库不一致的``type_drivers``项的值。

  - 在``[ml2]`` 部分，启用端口安全扩展驱动：

    ```
    [ml2]
    ...
    extension_drivers = port_security
    ```

  - 在``[ml2_type_flat]``部分，配置公共虚拟网络为flat网络

    ```
    [ml2_type_flat]
    ...
    flat_networks = provider
    ```

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#id1)[securitygroup]``部分，启用 [*ipset*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-ipset) 增加安全组规则的高效性：

    ```
    [securitygroup]
    ...
    enable_ipset = True
    ```

## 配置Linuxbridge代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-linux-bridge-agent)

Linuxbridge代理为实例建立layer－2虚拟网络并且处理安全组规则。

- 编辑``/etc/neutron/plugins/ml2/linuxbridge_agent.ini``文件并且完成以下操作：

  - 在``[linux_bridge]``部分，将公共虚拟网络和公共物理网络接口对应起来：

    ```
    [linux_bridge]
    physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
    ```

    将``PUBLIC_INTERFACE_NAME`` 替换为底层的物理公共网络接口。请查看：ref:environment-networking for more information。

  - 在``[vxlan]``部分，禁止VXLAN覆盖网络：

    ```
    [vxlan]
    enable_vxlan = False
    ```

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#id1)[securitygroup]``部分，启用安全组并配置 Linuxbridge [*iptables*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-iptables) firewall driver:

    ```
    [securitygroup]
    ...
    enable_security_group = True
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
    ```

## 配置DHCP代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option1.html#configure-the-dhcp-agent)

The [*DHCP agent*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-dhcp-agent) provides DHCP services for virtual networks.

- 编辑``/etc/neutron/dhcp_agent.ini``文件并完成下面的操作：

  - 在``[DEFAULT]``部分，配置Linuxbridge驱动接口，DHCP驱动并启用隔离元数据，这样在公共网络上的实例就可以通过网络来访问元数据

    ```
    [DEFAULT]
    ...
    interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
    dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
    enable_isolated_metadata = True
    ```

返回 [*Networking controller node configuration*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#neutron-controller-metadata-agent)。

​                      

## 网络选项2：私有网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安装组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#install-the-components)
  - [配置服务组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-server-component)
  - [配置 Modular Layer 2 (ML2) 插件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-modular-layer-2-ml2-plug-in)
  - [配置Linuxbridge代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-linux-bridge-agent)
  - [配置layer－3代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-layer-3-agent)
  - [配置DHCP代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-dhcp-agent)

在controller节点上安装并配置网络组件

## 安装组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#install-the-components)

```
# yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables
```

## 配置服务组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-server-component)

- 编辑``/etc/neutron/neutron.conf`` 文件并完成如下操作：

  - 在 `[database]` 部分，配置数据库访问：

    ```
    [database]
    ...
    connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron
    ```

    使用你设置的数据库密码替换 `NEUTRON_DBPASS` 。

  - 在``[DEFAULT]``部分，启用Modular  Layer 2 (ML2)插件，路由服务和重叠的IP地址：

    ```
    [DEFAULT]
    ...
    core_plugin = ml2
    service_plugins = router
    allow_overlapping_ips = True
    ```

  - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列的连接：

    ```
    [DEFAULT]
    ...
    rpc_backend = rabbit
    
    [oslo_messaging_rabbit]
    ...
    rabbit_host = controller
    rabbit_userid = openstack
    rabbit_password = RABBIT_PASS
    ```

    用你在RabbitMQ中为``openstack``选择的密码替换 “RABBIT_PASS”。

  - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

    ```
    [DEFAULT]
    ...
    auth_strategy = keystone
    
    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000
    auth_url = http://controller:35357
    memcached_servers = controller:11211
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    ```

    将 `NEUTRON_PASS` 替换为你在认证服务中为 `neutron` 用户选择的密码。

    

     

    注解

    

    在 `[keystone_authtoken]` 中注释或者删除其他选项。

  - 在``[DEFAULT]``和``[nova]``部分，配置网络服务来通知计算节点的网络拓扑变化：

    ```
    [DEFAULT]
    ...
    notify_nova_on_port_status_changes = True
    notify_nova_on_port_data_changes = True
    
    [nova]
    ...
    auth_url = http://controller:35357
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = nova
    password = NOVA_PASS
    ```

    使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

  - 在 `[oslo_concurrency]` 部分，配置锁路径：

    ```
    [oslo_concurrency]
    ...
    lock_path = /var/lib/neutron/tmp
    ```

## 配置 Modular Layer 2 (ML2) 插件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-modular-layer-2-ml2-plug-in)

ML2插件使用Linuxbridge机制来为实例创建layer－2虚拟网络基础设施

- 编辑``/etc/neutron/plugins/ml2/ml2_conf.ini``文件并完成以下操作：

  - 在``[ml2]``部分，启用flat，VLAN以及VXLAN网络：

    ```
    [ml2]
    ...
    type_drivers = flat,vlan,vxlan
    ```

  - 在``[ml2]``部分，启用VXLAN私有网络：

    ```
    [ml2]
    ...
    tenant_network_types = vxlan
    ```

  - 在``[ml2]``部分，启用Linuxbridge和layer－2机制：

    ```
    [ml2]
    ...
    mechanism_drivers = linuxbridge,l2population
    ```

    

     

    警告

    

    在你配置完ML2插件之后，删除可能导致数据库不一致的``type_drivers``项的值。

    

     

    注解

    

    Linuxbridge代理只支持VXLAN覆盖网络。

  - 在``[ml2]`` 部分，启用端口安全扩展驱动：

    ```
    [ml2]
    ...
    extension_drivers = port_security
    ```

  - 在``[ml2_type_flat]``部分，配置公共虚拟网络为flat网络

    ```
    [ml2_type_flat]
    ...
    flat_networks = provider
    ```

  - 在``[ml2_type_vxlan]``部分，为私有网络配置VXLAN网络识别的网络范围：

    ```
    [ml2_type_vxlan]
    ...
    vni_ranges = 1:1000
    ```

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#id1)[securitygroup]``部分，启用 [*ipset*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-ipset) 增加安全组规则的高效性：

    ```
    [securitygroup]
    ...
    enable_ipset = True
    ```

## 配置Linuxbridge代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-linux-bridge-agent)

Linuxbridge代理为实例建立layer－2虚拟网络并且处理安全组规则。

- 编辑``/etc/neutron/plugins/ml2/linuxbridge_agent.ini``文件并且完成以下操作：

  - 在``[linux_bridge]``部分，将公共虚拟网络和公共物理网络接口对应起来：

    ```
    [linux_bridge]
    physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
    ```

    将``PUBLIC_INTERFACE_NAME`` 替换为底层的物理公共网络接口。请查看：ref:environment-networking for more information。

  - 在``[vxlan]``部分，启用VXLAN覆盖网络，配置覆盖网络的物理网络接口的IP地址，启用layer－2 population：

    ```
    [vxlan]
    enable_vxlan = True
    local_ip = OVERLAY_INTERFACE_IP_ADDRESS
    l2_population = True
    ```

    将``OVERLAY_INTERFACE_IP_ADDRESS``  替换为处理覆盖网络的底层物理网络接口的IP地址。这个示例架构中使用管理网络接口与其他节点建立流量隧道。因此，将``OVERLAY_INTERFACE_IP_ADDRESS``替换为控制节点的管理网络的IP地址。请查看：ref:environment-networking for more information。

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#id1)[securitygroup]``部分，启用安全组并配置 Linuxbridge [*iptables*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-iptables) firewall driver:

    ```
    [securitygroup]
    ...
    enable_security_group = True
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
    ```

## 配置layer－3代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-layer-3-agent)

Layer-3代理为私有虚拟网络提供路由和NAT服务

- 编辑``/etc/neutron/l3_agent.ini``文件并完成以下操作：

  - 在``[DEFAULT]``部分，配置Linuxbridge接口驱动和外部网络网桥：

    ```
    [DEFAULT]
    ...
    interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
    external_network_bridge =
    ```

    

     

    注解

    

    [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#id1)external_network_bridge``选项特意设置成缺省值，这样就可以在一个代理上允许多种外部网络

## 配置DHCP代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install-option2.html#configure-the-dhcp-agent)

The [*DHCP agent*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-dhcp-agent) provides DHCP services for virtual networks.

- 编辑``/etc/neutron/dhcp_agent.ini``文件并完成下面的操作：

  - 在``[DEFAULT]``部分，配置Linuxbridge驱动接口，DHCP驱动并启用隔离元数据，这样在公共网络上的实例就可以通过网络来访问元数据

    ```
    [DEFAULT]
    ...
    interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
    dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
    enable_isolated_metadata = True
    ```

返回 [*Networking controller node configuration*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-controller-install.html#neutron-controller-metadata-agent)。

​                      

## 安装和配置计算节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安装组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#install-the-components)
  - [配置通用组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-the-common-component)
  - [配置网络选项](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-networking-options)
  - [为计算节点配置网络服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-compute-to-use-networking)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#finalize-installation)

计算节点处理实例的连接和 *安全组* 。

## 安装组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#install-the-components)

```
# yum install openstack-neutron-linuxbridge ebtables ipset
```

## 配置通用组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-the-common-component)

Networking 通用组件的配置包括认证机制、消息队列和插件。



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

- 编辑``/etc/neutron/neutron.conf`` 文件并完成如下操作：

  - 在``[database]`` 部分，注释所有``connection`` 项，因为计算节点不直接访问数据库。

  - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列的连接：

    ```
    [DEFAULT]
    ...
    rpc_backend = rabbit
    
    [oslo_messaging_rabbit]
    ...
    rabbit_host = controller
    rabbit_userid = openstack
    rabbit_password = RABBIT_PASS
    ```

    用你在RabbitMQ中为``openstack``选择的密码替换 “RABBIT_PASS”。

  - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

    ```
    [DEFAULT]
    ...
    auth_strategy = keystone
    
    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000
    auth_url = http://controller:35357
    memcached_servers = controller:11211
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    ```

    将 `NEUTRON_PASS` 替换为你在认证服务中为 `neutron` 用户选择的密码。

    

     

    注解

    

    在 `[keystone_authtoken]` 中注释或者删除其他选项。

  - 在 `[oslo_concurrency]` 部分，配置锁路径：

    ```
    [oslo_concurrency]
    ...
    lock_path = /var/lib/neutron/tmp
    ```

## 配置网络选项[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-networking-options)

选择与您之前在控制节点上选择的相同的网络选项。之后，回到这里并进行下一步：[*为计算节点配置网络服务*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#neutron-compute-compute)。

- [网络选项1：公共网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option1.html)
- [网络选项2：私有网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option2.html)



## 为计算节点配置网络服务[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#configure-compute-to-use-networking)

- 编辑``/etc/nova/nova.conf``文件并完成下面的操作：

  - 在``[neutron]`` 部分，配置访问参数：

    ```
    [neutron]
    ...
    url = http://controller:9696
    auth_url = http://controller:35357
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    ```

    将 `NEUTRON_PASS` 替换为你在认证服务中为 `neutron` 用户选择的密码。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install.html#finalize-installation)

1. 重启计算服务：

   ```
   # systemctl restart openstack-nova-compute.service
   ```

2. 启动Linuxbridge代理并配置它开机自启动：

   ```
   # systemctl enable neutron-linuxbridge-agent.service
   # systemctl start neutron-linuxbridge-agent.service
   ```

## 网络选项1：公共网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置Linuxbridge代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option1.html#configure-the-linux-bridge-agent)

在计算节点上配置网络组件

## 配置Linuxbridge代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option1.html#configure-the-linux-bridge-agent)

Linuxbridge代理为实例建立layer－2虚拟网络并且处理安全组规则。

- 编辑``/etc/neutron/plugins/ml2/linuxbridge_agent.ini``文件并且完成以下操作：

  - 在``[linux_bridge]``部分，将公共虚拟网络和公共物理网络接口对应起来：

    ```
    [linux_bridge]
    physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
    ```

    将``PUBLIC_INTERFACE_NAME`` 替换为底层的物理公共网络接口。请查看：ref:environment-networking for more information。

  - 在``[vxlan]``部分，禁止VXLAN覆盖网络：

    ```
    [vxlan]
    enable_vxlan = False
    ```

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option1.html#id1)[securitygroup]``部分，启用安全组并配置 Linuxbridge [*iptables*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-iptables) firewall driver:

    ```
    [securitygroup]
    ...
    enable_security_group = True
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
    ```

跳转到：ref:Networking compute node configuration <neutron-compute-compute>。

## 网络选项2：私有网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置Linuxbridge代理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option2.html#configure-the-linux-bridge-agent)

在计算节点上配置网络组件

## 配置Linuxbridge代理[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option2.html#configure-the-linux-bridge-agent)

Linuxbridge代理为实例建立layer－2虚拟网络并且处理安全组规则。

- 编辑``/etc/neutron/plugins/ml2/linuxbridge_agent.ini``文件并且完成以下操作：

  - 在``[linux_bridge]``部分，将公共虚拟网络和公共物理网络接口对应起来：

    ```
    [linux_bridge]
    physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
    ```

    将``PUBLIC_INTERFACE_NAME`` 替换为底层的物理公共网络接口。请查看：ref:environment-networking for more information。

  - 在``[vxlan]``部分，启用VXLAN覆盖网络，配置覆盖网络的物理网络接口的IP地址，启用layer－2 population：

    ```
    [vxlan]
    enable_vxlan = True
    local_ip = OVERLAY_INTERFACE_IP_ADDRESS
    l2_population = True
    ```

    将``OVERLAY_INTERFACE_IP_ADDRESS``  替换为处理覆盖网络的底层物理网络接口的IP地址。这个示例架构中使用管理网络接口与其他节点建立流量隧道。因此，将``OVERLAY_INTERFACE_IP_ADDRESS``替换为控制节点的管理网络的IP地址。请查看：ref:environment-networking for more information。

  - 在 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-compute-install-option2.html#id1)[securitygroup]``部分，启用安全组并配置 Linuxbridge [*iptables*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-iptables) firewall driver:

    ```
    [securitygroup]
    ...
    enable_security_group = True
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
    ```

跳转到：ref:Networking compute node configuration <neutron-compute-compute>。

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



 

注解



在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出加载的扩展来验证``neutron-server``进程是否正常启动：

   ```
   $ neutron ext-list
   +---------------------------+-----------------------------------------------+
   | alias                     | name                                          |
   +---------------------------+-----------------------------------------------+
   | default-subnetpools       | Default Subnetpools                           |
   | network-ip-availability   | Network IP Availability                       |
   | network_availability_zone | Network Availability Zone                     |
   | auto-allocated-topology   | Auto Allocated Topology Services              |
   | ext-gw-mode               | Neutron L3 Configurable external gateway mode |
   | binding                   | Port Binding                                  |
   | agent                     | agent                                         |
   | subnet_allocation         | Subnet Allocation                             |
   | l3_agent_scheduler        | L3 Agent Scheduler                            |
   | tag                       | Tag support                                   |
   | external-net              | Neutron external network                      |
   | net-mtu                   | Network MTU                                   |
   | availability_zone         | Availability Zone                             |
   | quotas                    | Quota management support                      |
   | l3-ha                     | HA Router extension                           |
   | flavors                   | Neutron Service Flavors                       |
   | provider                  | Provider Network                              |
   | multi-provider            | Multi Provider Network                        |
   | address-scope             | Address scope                                 |
   | extraroute                | Neutron Extra Route                           |
   | timestamp_core            | Time Stamp Fields addition for core resources |
   | router                    | Neutron L3 Router                             |
   | extra_dhcp_opt            | Neutron Extra DHCP opts                       |
   | dns-integration           | DNS Integration                               |
   | security-group            | security-group                                |
   | dhcp_agent_scheduler      | DHCP Agent Scheduler                          |
   | router_availability_zone  | Router Availability Zone                      |
   | rbac-policies             | RBAC Policies                                 |
   | standard-attr-description | standard-attr-description                     |
   | port-security             | Port Security                                 |
   | allowed-address-pairs     | Allowed Address Pairs                         |
   | dvr                       | Distributed Virtual Router                    |
   +---------------------------+-----------------------------------------------+
   ```

   

    

   注解

   

   实际的输出结果也许与本例有细微的差异。

使用网络部分你选择的验证部分来进行部署

- [网络选项1：公共网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-verify-option1.html)
- [网络选项2：私有网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/neutron-verify-option2.html)

​                      

## 网络选项1：公共网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

列出代理以验证启动 neutron 代理是否成功：

```
$ neutron agent-list
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
| id                                   | agent_type         | host       | alive | admin_state_up | binary                    |
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
| 08905043-5010-4b87-bba5-aedb1956e27a | Linux bridge agent | compute1   | :-)   | True           | neutron-linuxbridge-agent |
| 27eee952-a748-467b-bf71-941e89846a92 | Linux bridge agent | controller | :-)   | True           | neutron-linuxbridge-agent |
| dd3644c9-1a3a-435a-9282-eb306b4b0391 | DHCP agent         | controller | :-)   | True           | neutron-dhcp-agent        |
| f49a4b81-afd6-4b3d-b923-66c8f0517099 | Metadata agent     | controller | :-)   | True           | neutron-metadata-agent    |
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
```

输出结果应该包括控制节点上的三个代理和每个计算节点上的一个代理。

​                      

## 网络选项2：私有网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

列出代理以验证启动 neutron 代理是否成功：

```
$ neutron agent-list
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
| id                                   | agent_type         | host       | alive | admin_state_up | binary                    |
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
| 08905043-5010-4b87-bba5-aedb1956e27a | Linux bridge agent | compute1   | :-)   | True           | neutron-linuxbridge-agent |
| 27eee952-a748-467b-bf71-941e89846a92 | Linux bridge agent | controller | :-)   | True           | neutron-linuxbridge-agent |
| 830344ff-dc36-4956-84f4-067af667a0dc | L3 agent           | controller | :-)   | True           | neutron-l3-agent          |
| dd3644c9-1a3a-435a-9282-eb306b4b0391 | DHCP agent         | controller | :-)   | True           | neutron-dhcp-agent        |
| f49a4b81-afd6-4b3d-b923-66c8f0517099 | Metadata agent     | controller | :-)   | True           | neutron-metadata-agent    |
+--------------------------------------+--------------------+------------+-------+----------------+---------------------------+
```

输出结果应该包括控制节点上的四个代理和每个计算节点上的一个代理。

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

现在你的 OpenStack 环境包含了启动一个基本实例所必须的核心组件。你可以参考 :launch-instance 或者添加更多的 OpenStack 服务到你的环境中。

## 块存储服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



- [块存储服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_block_storage.html)
- 安装并配置控制节点
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#install-and-configure-components)
  - [配置计算节点以使用块设备存储](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#configure-compute-to-use-block-storage)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#finalize-installation)
- 安装并配置一个存储节点
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-next-steps.html)

块存储服务（cinder）为实例提供块存储。存储的分配和消耗是由块存储驱动器，或者多后端配置的驱动器决定的。还有很多驱动程序可用：NAS/SAN，NFS，ISCSI，Ceph等。

典型情况下，块服务API和调度器服务运行在控制节点上。取决于使用的驱动，卷服务器可以运行在控制节点、计算节点或单独的存储节点。

想获取更多信息，请查看：[配置参考](http://docs.openstack.org/mitaka/config-reference/block-storage/volume-drivers.html)。



 

注解



本章节省略了备份管理，因为它是基于对象存储服务的。

​                      

## 块存储服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack块存储服务(cinder)为虚拟机添加持久的存储，块存储提供一个基础设施为了管理卷，以及和OpenStack计算服务交互，为实例提供卷。此服务也会激活管理卷的快照和卷类型的功能。

块存储服务通常包含下列组件：

- cinder-api

  接受API请求，并将其路由到``cinder-volume``执行。

- cinder-volume

  与块存储服务和例如``cinder-scheduler``的进程进行直接交互。它也可以与这些进程通过一个消息队列进行交互。[``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_block_storage.html#id1)cinder-volume``服务响应送到块存储服务的读写请求来维持状态。它也可以和多种存储提供者在驱动架构下进行交互。

- cinder-scheduler守护进程

  选择最优存储提供节点来创建卷。其与``nova-scheduler``组件类似。

- cinder-backup守护进程

  [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_block_storage.html#id1)cinder-backup``服务提供任何种类备份卷到一个备份存储提供者。就像``cinder-volume``服务，它与多种存储提供者在驱动架构下进行交互。

- 消息队列

  在块存储的进程之间路由信息。

## 安装并配置控制节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#install-and-configure-components)
  - [配置计算节点以使用块设备存储](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#configure-compute-to-use-block-storage)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#finalize-installation)



这个部分描述如何在控制节点上安装和配置块设备存储服务，即 cinder。这个服务需要至少一个额外的存储节点，以向实例提供卷。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#prerequisites)

在你安装和配置块存储服务之前，你必须创建数据库、服务证书和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 `cinder` 数据库：

     ```
     CREATE DATABASE cinder;
     ```

   - 允许 `cinder` 数据库合适的访问权限：

     ```
     GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
       IDENTIFIED BY 'CINDER_DBPASS';
     GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
       IDENTIFIED BY 'CINDER_DBPASS';
     ```

     用合适的密码替换 `CINDER_DBPASS`

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建一个 `cinder` 用户：

     ```
     $ openstack user create --domain default --password-prompt cinder
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | bb279f8ffc444637af38811a5e1f0562 |
     | name      | cinder                           |
     +-----------+----------------------------------+
     ```

   - 添加 `admin` 角色到 `cinder` 用户上。

     ```
     $ openstack role add --project service --user cinder admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建 `cinder` 和 `cinderv2` 服务实体：

     ```
     $ openstack service create --name cinder \
       --description "OpenStack Block Storage" volume
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Block Storage          |
     | enabled     | True                             |
     | id          | ab3bbbef780845a1a283490d281e7fda |
     | name        | cinder                           |
     | type        | volume                           |
     +-------------+----------------------------------+
     ```

     ```
     $ openstack service create --name cinderv2 \
       --description "OpenStack Block Storage" volumev2
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Block Storage          |
     | enabled     | True                             |
     | id          | eb9fd245bdbc414695952e93f29fe3ac |
     | name        | cinderv2                         |
     | type        | volumev2                         |
     +-------------+----------------------------------+
     ```

   

    

   注解

   

   块设备存储服务要求两个服务实体。

4. 创建块设备存储服务的 API 入口点：

   ```
   $ openstack endpoint create --region RegionOne \
     volume public http://controller:8776/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | 03fa2c90153546c295bf30ca86b1344b        |
     | interface    | public                                  |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | ab3bbbef780845a1a283490d281e7fda        |
     | service_name | cinder                                  |
     | service_type | volume                                  |
     | url          | http://controller:8776/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     volume internal http://controller:8776/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | 94f684395d1b41068c70e4ecb11364b2        |
     | interface    | internal                                |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | ab3bbbef780845a1a283490d281e7fda        |
     | service_name | cinder                                  |
     | service_type | volume                                  |
     | url          | http://controller:8776/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     volume admin http://controller:8776/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | 4511c28a0f9840c78bacb25f10f62c98        |
     | interface    | admin                                   |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | ab3bbbef780845a1a283490d281e7fda        |
     | service_name | cinder                                  |
     | service_type | volume                                  |
     | url          | http://controller:8776/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   ```

   ```
   $ openstack endpoint create --region RegionOne \
     volumev2 public http://controller:8776/v2/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | 513e73819e14460fb904163f41ef3759        |
   | interface    | public                                  |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | eb9fd245bdbc414695952e93f29fe3ac        |
   | service_name | cinderv2                                |
   | service_type | volumev2                                |
   | url          | http://controller:8776/v2/%(tenant_id)s |
   +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     volumev2 internal http://controller:8776/v2/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | 6436a8a23d014cfdb69c586eff146a32        |
   | interface    | internal                                |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | eb9fd245bdbc414695952e93f29fe3ac        |
   | service_name | cinderv2                                |
   | service_type | volumev2                                |
   | url          | http://controller:8776/v2/%(tenant_id)s |
   +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     volumev2 admin http://controller:8776/v2/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | e652cf84dd334f359ae9b045a2c91d96        |
   | interface    | admin                                   |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | eb9fd245bdbc414695952e93f29fe3ac        |
   | service_name | cinderv2                                |
   | service_type | volumev2                                |
   | url          | http://controller:8776/v2/%(tenant_id)s |
   +--------------+-----------------------------------------+
   ```

   

    

   注解

   

   块设备存储服务每个服务实体都需要端点。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install openstack-cinder
   ```

1. 编辑 `/etc/cinder/cinder.conf`，同时完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder
     ```

     用你为块设备存储数据库选择的密码替换 `CINDER_DBPASS`。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = cinder
     password = CINDER_PASS
     ```

     将 `CINDER_PASS` 替换为你在认证服务中为 `cinder` 用户选择的密码。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[DEFAULT` 部分，配置``my_ip`` 来使用控制节点的管理接口的IP 地址。

     ```
     [DEFAULT]
     ...
     my_ip = 10.0.0.11
     ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/cinder/tmp
     ```

1. 初始化块设备服务的数据库：

   ```
   # su -s /bin/sh -c "cinder-manage db sync" cinder
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 配置计算节点以使用块设备存储[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#configure-compute-to-use-block-storage)

- 编辑文件 `/etc/nova/nova.conf` 并添加如下到其中：

  ```
  [cinder]
  os_region_name = RegionOne
  ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-controller-install.html#finalize-installation)

1. 重启计算API 服务：

   ```
   # systemctl restart openstack-nova-api.service
   ```

2. 启动块设备存储服务，并将其配置为开机自启：

   ```
   # systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
   # systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
   ```

​                      

## 安装并配置一个存储节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#finalize-installation)



这个部分描述怎样为块存储服务安装并配置存储节点。为简单起见，这里配置一个有一个空的本地块存储设备的存储节点。这个向导用的是 `/dev/sdb`，但是你可以为你特定的节点中替换成不同的值。

该服务在这个设备上使用：term：LVM <Logical Volume Manager (LVM)> 提供逻辑卷，并通过：term：[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#id1)iSCSI`协议提供给实例使用。您可以根据这些小的修改指导，添加额外的存储节点来增加您的环境规模。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#prerequisites)

在你安装和配置块存储服务之前，你必须准备好存储设备。



 

注解



在存储节点实施这些步骤。

1. 安装支持的工具包：

   - 安装 LVM 包：

     ```
     # yum install lvm2
     ```

   - 启动LVM的metadata服务并且设置该服务随系统启动：

     ```
     # systemctl enable lvm2-lvmetad.service
     # systemctl start lvm2-lvmetad.service
     ```

   

    

   注解

   

   一些发行版默认包含了LVM。

2. 创建LVM 物理卷 `/dev/sdb`：

   ```
   # pvcreate /dev/sdb
   Physical volume "/dev/sdb" successfully created
   ```

3. 创建 LVM 卷组 `cinder-volumes`：

   ```
   # vgcreate cinder-volumes /dev/sdb
   Volume group "cinder-volumes" successfully created
   ```

   块存储服务会在这个卷组中创建逻辑卷。

4. 只有实例可以访问块存储卷组。不过，底层的操作系统管理这些设备并将其与卷关联。默认情况下，LVM卷扫描工具会扫描``/dev``  目录，查找包含卷的块存储设备。如果项目在他们的卷上使用LVM，扫描工具检测到这些卷时会尝试缓存它们，可能会在底层操作系统和项目卷上产生各种问题。您必须重新配置LVM，让它只扫描包含``cinder-volume``卷组的设备。编辑``/etc/lvm/lvm.conf``文件并完成下面的操作：

   - 在``devices``部分，添加一个过滤器，只接受``/dev/sdb``设备，拒绝其他所有设备：

     ```
     devices {
     ...
     filter = [ "a/sdb/", "r/.*/"]
     ```

     每个过滤器组中的元素都以``a``开头，即为 **accept**，或以 `r` 开头，即为**reject**，并且包括一个设备名称的正则表达式规则。过滤器组必须以``r/.*/[``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#id1)结束，过滤所有保留设备。您可以使用 [:命令:`vgs -vvvv`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#id3) 来测试过滤器。

     

      

     警告

     

     如果您的存储节点在操作系统磁盘上使用了 LVM，您还必需添加相关的设备到过滤器中。例如，如果 `/dev/sda` 设备包含操作系统：

     ```
     filter = [ "a/sda/", "a/sdb/", "r/.*/"]
     ```

     类似地，如果您的计算节点在操作系统磁盘上使用了 LVM，您也必需修改这些节点上 `/etc/lvm/lvm.conf` 文件中的过滤器，将操作系统磁盘包含到过滤器中。例如，如果``/dev/sda`` 设备包含操作系统：

     ```
     filter = [ "a/sda/", "r/.*/"]
     ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install openstack-cinder targetcli python-keystone
   ```

1. 编辑 `/etc/cinder/cinder.conf`，同时完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder
     ```

     用你为块设备存储数据库选择的密码替换 `CINDER_DBPASS`。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = cinder
     password = CINDER_PASS
     ```

     将 `CINDER_PASS` 替换为你在认证服务中为 `cinder` 用户选择的密码。

     

      

     注解

     

     在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[DEFAULT]` 部分，配置 `my_ip` 选项：

     ```
     [DEFAULT]
     ...
     my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     ```

     将其中的``MANAGEMENT_INTERFACE_IP_ADDRESS``替换为存储节点上的管理网络接口的IP 地址，例如样例架构 <overview-example-architectures>中所示的第一台节点 10.0.0.41 。

   - 在``[lvm]``部分，配置LVM后端以LVM驱动结束，卷组``cinder-volumes`` ，iSCSI 协议和正确的 iSCSI服务:

     ```
     [lvm]
     ...
     volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
     volume_group = cinder-volumes
     iscsi_protocol = iscsi
     iscsi_helper = lioadm
     ```

   - 在 `[DEFAULT]` 部分，启用 LVM 后端：

     ```
     [DEFAULT]
     ...
     enabled_backends = lvm
     ```

     

      

     注解

     

     后端名字是任意的。比如，本教程使用驱动的名字作为后端的名字。

   - 在 `[DEFAULT]` 区域，配置镜像服务 API 的位置：

     ```
     [DEFAULT]
     ...
     glance_api_servers = http://controller:9292
     ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/cinder/tmp
     ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/cinder-storage-install.html#finalize-installation)

- 启动块存储卷服务及其依赖的服务，并将其配置为随系统启动：

  ```
  # systemctl enable openstack-cinder-volume.service target.service
  # systemctl start openstack-cinder-volume.service target.service
  ```

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



验证块设备存储服务的操作。



 

注解



在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出服务组件以验证是否每个进程都成功启动：

   ```
   $ cinder service-list
   +------------------+------------+------+---------+-------+----------------------------+-----------------+
   |      Binary      |    Host    | Zone |  Status | State |         Updated_at         | Disabled Reason |
   +------------------+------------+------+---------+-------+----------------------------+-----------------+
   | cinder-scheduler | controller | nova | enabled |   up  | 2014-10-18T01:30:54.000000 |       None      |
   | cinder-volume    | block1@lvm | nova | enabled |   up  | 2014-10-18T01:30:57.000000 |       None      |
   +------------------+------------+------+---------+-------+----------------------------+-----------------+
   ```

​                      

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



你的 OpenStack 环境现在已经包含了块设备存储服务。你可以查看 [*launch an instance*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html) 或者在接下来的章节中添加更多的服务到你的环境中。

## 文件共享系统服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



- [共享文件系统服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_shared_file_systems.html)
- 安装并配置控制节点
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#finalize-installation)
- 安装并配置一个分享节点
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#install-and-configure-components)
  - 配置共享服务器管理支持选项
    - 文件共享系统选项1：没有支持文件共享服务器管理的驱动
      - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#prerequisites)
      - [配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#configure-components)
    - 文件共享系统选项2：有驱动支持的文件共享服务器管理
      - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#prerequisites)
      - [配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-next-steps.html)

文件共享系统服务（manila）用于协调共享文件系统或分布式文件系统。提供或使用哪种方法取决于文件共享服务器或者多驱动器中驱动器的配置。也有很多支持NFS，CIFS，HDFS协议的驱动器。

一般情况下，文件共享系统的API和调度服务运行在控制节点上。依赖于运行在控制节点，计算节点或者存储节点上的共享服务驱动器。

想获取更多信息，请查看：[`配置参考`__](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila.html#id1).

## 共享文件系统服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack共享文件系统服务(manila)为虚机提供文件存储。共享文件系统服务为管理和配置共享文件提供基础设施。如果驱动支持快照，该服务也可管理共享快照的共享文件类型。

共享文件系统服务包含以下组件：

- manila-api

  一个WSGI应用通过共享文件系统服务来认证和路由请求，同事也支持OpenStack的APIs

- manila-data

  一个单一服务的功能包括了接受请求、处理数据操作例如拷贝、迁移、备份，当操作完成以后发送一个返回的响应

- manila-scheduler

  把请求调度和路由到合适的共享服务端点。调度器用可配置的过滤器和权重计算器来路由请求。过滤调度器是默认的模式，它可以对很多对象进行过滤，比如：容量，可用区，共享类型，当然也可以自定义一些自己的过滤器。

- manila-share

  这个共享节点支持两种模式，带有和不带有共享服务器处理两种模式。这种模式依赖于驱动器的支持

- 消息队列

  在共享文件系统进程之间的路由信息

For more information, see [Configuration Reference Guide](http://docs.openstack.org/mitaka/config-reference/shared-file-systems/overview.html).

## 安装并配置控制节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#finalize-installation)



这个部分描述如何在控制节点上安装和配置文件共享服务，即manila。这个服务需要至少一个额外的共享节点用来管理文件存储驱动。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#prerequisites)

安装和配置文件共享服务之前，你必须创建创建一个数据库、服务凭证和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建``manila``数据库：

     ```
     CREATE DATABASE manila;
     ```

   - 对``manila``数据库授予恰当的访问权限：

     ```
     GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'localhost' \
       IDENTIFIED BY 'MANILA_DBPASS';
     GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'%' \
       IDENTIFIED BY 'MANILA_DBPASS';
     ```

     用合适的密码替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#id1)MANILA_DBPASS [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#id3)。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建``manila``用户：

     ```
     $ openstack user create --domain default --password-prompt manila
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | 83a3990fc2144100ba0e2e23886d8acc |
     | name      | manila                           |
     +-----------+----------------------------------+
     ```

   - 给 `manila` 用户添加 `admin` 角色：

     ```
     $ openstack role add --project service --user manila admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建``manila`` 和 `manilav2` 服务实体：

     ```
     $ openstack service create --name manila \
       --description "OpenStack Shared File Systems" share
       +-------------+----------------------------------+
       | Field       | Value                            |
       +-------------+----------------------------------+
       | description | OpenStack Shared File Systems    |
       | enabled     | True                             |
       | id          | 82378b5a16b340aa9cc790cdd46a03ba |
       | name        | manila                           |
       | type        | share                            |
       +-------------+----------------------------------+
     ```

     ```
     $ openstack service create --name manilav2 \
       --description "OpenStack Shared File Systems" sharev2
       +-------------+----------------------------------+
       | Field       | Value                            |
       +-------------+----------------------------------+
       | description | OpenStack Shared File Systems    |
       | enabled     | True                             |
       | id          | 30d92a97a81a4e5d8fd97a32bafd7b88 |
       | name        | manilav2                         |
       | type        | sharev2                          |
       +-------------+----------------------------------+
     ```

     

      

     注解

     

     文件分享服务需要2个服务实体。

4. 创建文件分享服务的API endpoint：

   ```
   $ openstack endpoint create --region RegionOne \
     share public http://controller:8786/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | 0bd2bbf8d28b433aaea56a254c69f69d        |
     | interface    | public                                  |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 82378b5a16b340aa9cc790cdd46a03ba        |
     | service_name | manila                                  |
     | service_type | share                                   |
     | url          | http://controller:8786/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     share internal http://controller:8786/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | a2859b5732cc48b5b083dd36dafb6fd9        |
     | interface    | internal                                |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 82378b5a16b340aa9cc790cdd46a03ba        |
     | service_name | manila                                  |
     | service_type | share                                   |
     | url          | http://controller:8786/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     share admin http://controller:8786/v1/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | f7f46df93a374cc49c0121bef41da03c        |
     | interface    | admin                                   |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 82378b5a16b340aa9cc790cdd46a03ba        |
     | service_name | manila                                  |
     | service_type | share                                   |
     | url          | http://controller:8786/v1/%(tenant_id)s |
     +--------------+-----------------------------------------+
   ```

   ```
   $ openstack endpoint create --region RegionOne \
     sharev2 public http://controller:8786/v2/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | d63cc0d358da4ea680178657291eddc1        |
     | interface    | public                                  |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 30d92a97a81a4e5d8fd97a32bafd7b88        |
     | service_name | manilav2                                |
     | service_type | sharev2                                 |
     | url          | http://controller:8786/v2/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     sharev2 internal http://controller:8786/v2/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | afc86e5f50804008add349dba605da54        |
     | interface    | internal                                |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 30d92a97a81a4e5d8fd97a32bafd7b88        |
     | service_name | manilav2                                |
     | service_type | sharev2                                 |
     | url          | http://controller:8786/v2/%(tenant_id)s |
     +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     sharev2 admin http://controller:8786/v2/%\(tenant_id\)s
     +--------------+-----------------------------------------+
     | Field        | Value                                   |
     +--------------+-----------------------------------------+
     | enabled      | True                                    |
     | id           | e814a0cec40546e98cf0c25a82498483        |
     | interface    | admin                                   |
     | region       | RegionOne                               |
     | region_id    | RegionOne                               |
     | service_id   | 30d92a97a81a4e5d8fd97a32bafd7b88        |
     | service_name | manilav2                                |
     | service_type | sharev2                                 |
     | url          | http://controller:8786/v2/%(tenant_id)s |
     +--------------+-----------------------------------------+
   ```

   

    

   注解

   

   文件分享服务的每个服务实体都需要创建endpoint。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install openstack-manila python-manilaclient
   ```

1. 编辑``/etc/manila/manila.conf``文件并完成下列操作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://manila:MANILA_DBPASS@controller/manila
     ```

     使用你为manila数据库设置的密码来替换``MANILA_DBPASS``

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在``[DEFAULT]``选项卡部分，设置成如下值：

     ```
     [DEFAULT]
     ...
     default_share_type = default_share_type
     rootwrap_config = /etc/manila/rootwrap.conf
     ```

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     memcached_servers = controller:11211
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = manila
     password = MANILA_PASS
     ```

     使用你在身份认证服务中选择的 `manila` 用户密码来替换 `MANILA_PASS` 。

   - 在 `[DEFAULT` 部分，配置``my_ip`` 来使用控制节点的管理接口的IP 地址。

     ```
     [DEFAULT]
     ...
     my_ip = 10.0.0.11
     ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/manila/tmp
     ```

1. 同步文件分享系统的数据库：

   ```
   # su -s /bin/sh -c "manila-manage db sync" manila
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-controller-install.html#finalize-installation)

- 启动文件分享服务并设置为随系统启动：

  ```
  # systemctl enable openstack-manila-api.service openstack-manila-scheduler.service
  # systemctl start openstack-manila-api.service openstack-manila-scheduler.service
  ```

​                      

## 安装并配置一个分享节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#install-and-configure-components)
  - [配置共享服务器管理支持选项](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#configure-share-server-management-support-options)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#finalize-installation)



这部分描述了如何安装并配置一个共享文件系统服务的共享节点

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-manila-share python2-PyMySQL
   ```

2. 编辑``/etc/manila/manila.conf``文件并完成下列操作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql://manila:MANILA_DBPASS@controller/manila
     ```

     使用你为manila数据库设置的密码来替换``MANILA_DBPASS``

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在``[DEFAULT]``选项卡部分，设置成如下值：

     ```
     [DEFAULT]
     ...
     default_share_type = default_share_type
     rootwrap_config = /etc/manila/rootwrap.conf
     ```

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     memcached_servers = controller:11211
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = manila
     password = MANILA_PASS
     ```

     使用你在身份认证服务中选择的 `manila` 用户密码来替换 `MANILA_PASS` 。

   - 在 `[DEFAULT]` 部分，配置 `my_ip` 选项：

     ```
     [DEFAULT]
     ...
     my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     ```

     将其中的``MANAGEMENT_INTERFACE_IP_ADDRESS``替换为共享节点上的管理网络接口的IP 地址，典型的情况下，第一个节点为 10.0.0.41 ，正如 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#id1)example architecture <overview-example-architectures>`中所示。

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```
     [oslo_concurrency]
     ...
     lock_path = /var/lib/manila/tmp
     ```

## 配置共享服务器管理支持选项[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#configure-share-server-management-support-options)

这个共享节点支持两种模式，带有和不带有共享服务器处理两种模式。这种模式依赖于驱动器的支持

选项1部署服务不包含对共享管理的驱动支持。这种模式下，服务不需要任何和网络有关的部署。操作者必须确保实例和NFS服务器之间的连接。本选项使用需要包含LVM和NFS包以及一个额外的命名为``manila-share``的LVM卷组的LVM驱动器

选项2部署服务包含对共享管理的驱动支持。这种模式下，服务需要计算（nova），网络（neutron），块存储（cinder）服务来管理共享服务器。这部分信息用于创建共享服务器，就像创建共享网络一样。本选项使用支持共享服务处理的generic驱动器，并且需要一个连接到路由的私网``selfservice``



 

警告



在同一个共享节点上，不管是选项1还是选项2，都存在着一个bug。想获取更多信息，请查看LVM驱动器配置参考部分<http://docs.openstack.org/mitaka/config-reference/content/section_share-drivers.html>`__.

选择以下选项中的任意一个选项来配置共享驱动器。之后，返回这里并且继续：ref:manila-share-finalize-install。

- [文件共享系统选项1：没有支持文件共享服务器管理的驱动](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html)
- [文件共享系统选项2：有驱动支持的文件共享服务器管理](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html)



## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install.html#finalize-installation)

- 启动文件共享系统服务及其依赖的服务，并将其配置为随系统启动：

  ```
  # systemctl enable openstack-manila-share.service
  # systemctl start openstack-manila-share.service
  ```

## 文件共享系统选项1：没有支持文件共享服务器管理的驱动

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#prerequisites)
  - [配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#configure-components)

为简单起见，块存储服务这部分配置使用同一个存储节点。但是，LVM驱动器需要一个单独的空的本地存储设备来避免与块存储服务产生冲突。这个向导使用 `/dev/sdb`，但是你可以为你特定的节点中替换成不同的值。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#prerequisites)



 

注解



在存储节点实施这些步骤。

1. 安装支持的工具包：

   - 安装LVM和NFS包：

     ```
     # yum install lvm2 nfs-utils nfs4-acl-tools portmap
     ```

   - 启动LVM的metadata服务并且设置该服务随系统启动：

     ```
     # systemctl enable lvm2-lvmetad.service
     # systemctl start lvm2-lvmetad.service
     ```

2. 创建LVM 物理卷 `/dev/sdc`：

   ```
   # pvcreate /dev/sdc
   Physical volume "/dev/sdc" successfully created
   ```

3. 创建LVM卷组``manila-volumes``:

   ```
   # vgcreate manila-volumes /dev/sdc
   Volume group "manila-volumes" successfully created
   ```

   文件共享系统服务会在这个卷组里创建物理卷。

4. 只有实例可以访问文件共享系统服务的卷组。但是，底层的操作系统也可以管理这些设备并将其与卷关联。默认情况下，LVM卷扫描工具会扫描``/dev``  目录，查找包含卷的块存储设备。如果在他们的卷上有使用LVM的项目，扫描工具检测到这些卷时会尝试缓存它们，这可能会在底层操作系统和项目卷上产生各种问题。您必须重新配置LVM，让它只扫描包含``cinder-volume``和``manila-volumes``卷组的设备。编辑``/etc/lvm/lvm.conf``文件并完成下面的操作：

   - 在``devices``部分，添加一个过滤器，只接受``/dev/sdb``设备，拒绝其他所有设备：

     ```
     devices {
     ...
     filter = [ "a/sdb/", "a/sdc", "r/.*/"]
     ```

     

      

     警告

     

     如果您的存储节点在操作系统磁盘上使用了 LVM，您还必需添加相关的设备到过滤器中。例如，如果 `/dev/sda` 设备包含操作系统：

     ```
     filter = [ "a/sda/", "a/sdb/", "a/sdc", "r/.*/"]
     ```

     类似地，如果您的计算节点在操作系统磁盘上使用了 LVM，您也必需修改这些节点上 `/etc/lvm/lvm.conf` 文件中的过滤器，将操作系统磁盘包含到过滤器中。例如，如果``/dev/sda`` 设备包含操作系统：

     ```
     filter = [ "a/sda/", "r/.*/"]
     ```

## 配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-false-option1.html#configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 编辑``/etc/manila/manila.conf``文件并完成下列操作：

   - 在 `[DEFAULT]` 部分，启用LVM driver和NFS/CIFS协议：

     ```
     [DEFAULT]
     ...
     enabled_share_backends = lvm
     enabled_share_protocols = NFS,CIFS
     ```

     

      

     注解

     

     Backend的名字是任意的。例如，本教程使用driver这个名字。

   - 在 `[lvm]` 部分，配置LVM驱动:

     ```
     [lvm]
     share_backend_name = LVM
     share_driver = manila.share.drivers.lvm.LVMShareDriver
     driver_handles_share_servers = False
     lvm_share_volume_group = manila-volumes
     lvm_share_export_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     ```

     将其中的``MANAGEMENT_INTERFACE_IP_ADDRESS``替换为存储节点上的管理网络接口的IP 地址，例如样例架构 <overview-example-architectures>中所示的第一台节点 10.0.0.41 。

跳转到：Finalize installation <manila-share-finalize-install>。

## 文件共享系统选项2：有驱动支持的文件共享服务器管理

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#prerequisites)
  - [配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#configure-components)

为了简单起见，本配置文档使用和块存储服务中存储节点相同的配置



 

注解



本部分向导描述如何配置使用支持DHSS的``generic``驱动器来配置文件共享系统服务。这种模式需要计算（nova），网络（neutron），块存储（cinder）服务来管理文件共享服务器。这部分信息用来创建共享服务器，就像创建共享网络一样。支持DHSS功能的Generic驱动器同样需要能够连接到公共路由的网络。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#prerequisites)

在你进行下一步之前，验证计算，网络，块存储服务。本选项需要网络选项2的补充，同样也需要在存储节点上安装一些网络服务组件。

- 安装网络服务组件：

  ```
  # yum install openstack-neutron openstack-neutron-linuxbridge ebtables
  ```

## 配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 编辑``/etc/manila/manila.conf``文件并完成下列操作：

   - 在 `[DEFAULT]` 部分，启用generic driver和NFS/CIFS协议：

     ```
     [DEFAULT]
     ...
     enabled_share_backends = generic
     enabled_share_protocols = NFS,CIFS
     ```

     

      

     注解

     

     Backend的名字是任意的。例如，本教程使用driver这个名字。

   - 在``[neutron]``, `[nova]`, and [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/manila-share-install-dhss-true-option2.html#id1)[cinder]``部分，允许对这些服务的认证：

     ```
     [neutron]
     ...
     url = http://controller:9696
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     region_name = RegionOne
     project_name = service
     username = neutron
     password = NEUTRON_PASS
     
     [nova]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     region_name = RegionOne
     project_name = service
     username = nova
     password = NOVA_PASS
     
     [cinder]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     region_name = RegionOne
     project_name = service
     username = cinder
     password = CINDER_PASS
     ```

   - 在``[generic]``部分，配置generic driver:

     ```
     [generic]
     share_backend_name = GENERIC
     share_driver = manila.share.drivers.generic.GenericShareDriver
     driver_handles_share_servers = True
     service_instance_flavor_id = 100
     service_image_name = manila-service-image
     service_instance_user = manila
     service_instance_password = manila
     interface_driver = manila.network.linux.interface.BridgeInterfaceDriver
     ```

     

      

     注解

     

     你也可以使用SSH密钥而不是密码认证的方式来创建服务实例认证

跳转到：Finalize installation <manila-share-finalize-install>。

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



验证文件共享系统服务的安装



 

注解



在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出服务组件以验证是否每个进程都成功启动：

   对于选项1的部署：

   ```
   $ manila service-list
   +----+------------------+-------------+------+---------+-------+----------------------------+
   | Id | Binary           | Host        | Zone | Status  | State | Updated_at                 |
   +----+------------------+-------------+------+---------+-------+----------------------------+
   | 1  | manila-scheduler | controller  | nova | enabled | up    | 2016-03-30T20:17:28.000000 |
   | 2  | manila-share     | storage@lvm | nova | enabled | up    | 2016-03-30T20:17:29.000000 |
   +----+------------------+-------------+------+---------+-------+----------------------------+
   ```

   对于选项2的部署：

   ```
   $ manila service-list
   +----+------------------+-----------------+------+---------+-------+----------------------------+
   | Id | Binary           | Host            | Zone | Status  | State | Updated_at                 |
   +----+------------------+-----------------+------+---------+-------+----------------------------+
   | 1  | manila-scheduler | controller      | nova | enabled | up    | 2016-03-30T20:17:28.000000 |
   | 2  | manila-share     | storage@generic | nova | enabled | up    | 2016-03-30T20:17:29.000000 |
   +----+------------------+-----------------+------+---------+-------+----------------------------+
   ```

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



你的 OpenStack 环境现在已经包含了文件共享服务。你可以查看 [*launch an instance*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html) 或者在接下来的章节中添加更多的服务到你的环境中。

## 对象存储服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



- [对象存储服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_object_storage.html)
- [安装并配置控制器节点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html)
- [安装和配置存储节点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html)
- [创建，分发并初始化rings](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html)
- [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-finalize-installation.html)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-next-steps.html)

对象存储服务（swift）提供对象存储及恢复通过:term:REST API <RESTful>

你的环境中至少需要包含身份认证服务(keystone)来部署对象存储

## 对象存储服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack对象存储是一个多租户的对象存储系统，它支持大规模扩展，可以以低成本来管理大型的非结构化数据，通过RESTful HTTP 应用程序接口。

它包含下列组件：

- 代理服务器(swift-proxy-server)

  接收OpenStack对象存储API和纯粹的HTTP请求以上传文件，更改元数据，以及创建容器。它可服务于在web浏览器下显示文件和容器列表。为了改进性能，代理服务可以使用可选的缓存，通常部署的是memcache。

- 账户服务器 (swift-account-server)

  管理由对象存储定义的账户。

- 容器服务器 (swift-container-server)

  管理容器或文件夹的映射，对象存储内部。

- 对象服务器 (swift-object-server)

  在存储节点上管理实际的对象，比如：文件。

- 各种定期进程

  为了驾驭大型数据存储的任务，复制服务需要在集群内确保一致性和可用性，其他定期进程有审计，更新和reaper。

- WSGI中间件

  掌控认证，使用OpenStack认证服务。

- swift 客户端

  用户可以通过此命令行客户端来向REST API提交命令，授权的用户角色可以是管理员用户，经销商用户，或者是swift用户。

- swift-init

  初始化环链文件生成的脚本，将守护进程名称当作参数并提供命令。归档于http://docs.openstack.org/developer/swift/admin_guide.html#managing-services。

- swift-recon

  一个被用于检索多种关于一个集群的度量和计量信息的命令行接口工具已被swift-recon中间件采集。

- swift-ring-builder

  存储环链建立并重平衡实用程序。归档于http://docs.openstack.org/developer/swift/admin_guide.html#managing-the-rings。

## 安装并配置控制器节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html#install-and-configure-components)



本章节描述如何安装和配置在存储节点上处理account，container和object服务请求的代理服务。为了简单起见，本指南在控制节点安装和配置代理服务。不过，你可以在任何与存储节点网络联通的节点上运行代理服务。另外，你可以在多个节点安装和配置代理服务提高性能和冗余。更多信息，参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html#prerequisites)

代理服务依赖于诸如身份认证服务所提供的认证和授权机制。但是，与其他服务不同，它也提供了一个内部机制可以在没有任何其他OpenStack服务的情况下运行。不过为了简单起见，本指南引用:doc:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html#id1)keystone`中的身份认证服务。在你配置对象存储服务前，你必须创建服务凭证和API端点。



 

注解



对象存储服务不使用控制节点上的SQL数据库。而是使用在每个存储节点的分布式SQLite数据库。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 要创建身份认证服务的凭证，完成这些步骤：

   - 创建 `swift` 用户：

     ```
     $ openstack user create --domain default --password-prompt swift
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | d535e5cbd2b74ac7bfb97db9cced3ed6 |
     | name      | swift                            |
     +-----------+----------------------------------+
     ```

   - 给 `swift` 用户添加 `admin` 角色：

     ```
     $ openstack role add --project service --user swift admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建  `swift` 服务条目：

     ```
     $ openstack service create --name swift \
       --description "OpenStack Object Storage" object-store
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Object Storage         |
     | enabled     | True                             |
     | id          | 75ef509da2c340499d454ae96a2c5c34 |
     | name        | swift                            |
     | type        | object-store                     |
     +-------------+----------------------------------+
     ```

3. 创建对象存储服务 API 端点：

   ```
   $ openstack endpoint create --region RegionOne \
     object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s
   +--------------+----------------------------------------------+
   | Field        | Value                                        |
   +--------------+----------------------------------------------+
   | enabled      | True                                         |
   | id           | 12bfd36f26694c97813f665707114e0d             |
   | interface    | public                                       |
   | region       | RegionOne                                    |
   | region_id    | RegionOne                                    |
   | service_id   | 75ef509da2c340499d454ae96a2c5c34             |
   | service_name | swift                                        |
   | service_type | object-store                                 |
   | url          | http://controller:8080/v1/AUTH_%(tenant_id)s |
   +--------------+----------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s
   +--------------+----------------------------------------------+
   | Field        | Value                                        |
   +--------------+----------------------------------------------+
   | enabled      | True                                         |
   | id           | 7a36bee6733a4b5590d74d3080ee6789             |
   | interface    | internal                                     |
   | region       | RegionOne                                    |
   | region_id    | RegionOne                                    |
   | service_id   | 75ef509da2c340499d454ae96a2c5c34             |
   | service_name | swift                                        |
   | service_type | object-store                                 |
   | url          | http://controller:8080/v1/AUTH_%(tenant_id)s |
   +--------------+----------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     object-store admin http://controller:8080/v1
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | ebb72cd6851d4defabc0b9d71cdca69b |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 75ef509da2c340499d454ae96a2c5c34 |
   | service_name | swift                            |
   | service_type | object-store                     |
   | url          | http://controller:8080/v1        |
   +--------------+----------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-controller-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-swift-proxy python-swiftclient \
     python-keystoneclient python-keystonemiddleware \
     memcached
   ```

   

    

   注解

   

   完整的 OpenStack 环境已经包含了这些包的其中一部分。

1. 从对象存储的仓库源中获取代理服务的配置文件：

   ```
   # curl -o /etc/swift/proxy-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/mitaka
   ```

1. 编辑文件 `/etc/swift/proxy-server.conf` 并完成如下动作：

   - 在  `[DEFAULT]` 部分，配置绑定端口，用户和配置目录。

     ```
     [DEFAULT]
     ...
     bind_port = 8080
     user = swift
     swift_dir = /etc/swift
     ```

   - 在``[pipeline:main]``部分，删除``tempurl``和``tempauth``模块并增加``authtoken``和``keystoneauth``模块

     ```
     [pipeline:main]
     pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server
     ```

     

      

     注解

     

     不要改变模块的顺序。

     

      

     注解

     

     更多关于启用其他模块的额外功能的信息，请参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。

   - 在 `[app:proxy-server]` 部分，启动自动账户创建。

     ```
     [app:proxy-server]
     use = egg:swift#proxy
     ...
     account_autocreate = True
     ```

   - 在 `[filter:keystoneauth]` 部分，配置操作员角色。

     ```
     [filter:keystoneauth]
     use = egg:swift#keystoneauth
     ...
     operator_roles = admin,user
     ```

   - 在  `[filter:authtoken]` 部分，配置认证服务访问。

     ```
     [filter:authtoken]
     paste.filter_factory = keystonemiddleware.auth_token:filter_factory
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = swift
     password = SWIFT_PASS
     delay_auth_decision = True
     ```

     使用你在身份认证服务中选择的 `swift` 用户密码来替换 `SWIFT_PASS` 。

     

      

     注解

     

     注释或者删除掉在 `[filter:authtoken]` 部分的所有其他的内容。

   - 在 `[filter:cache]` 部分，配置 `memcached` 的位置：

     ```
     [filter:cache]
     use = egg:swift#memcache
     ...
     memcache_servers = controller:11211
     ```

​                      

## 安装和配置存储节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#install-and-configure-components)



本章节描述怎样为操作帐号，容器和对象服务安装和配置存储节点。为简单起见，这里配置两个存储节点，每个包含两个空本地块存储设备。这个向导用的是 `/dev/sdb``和 ``/dev/sdc`，但是你可以用不同的值代替您的特定节点。

尽管对象存储通过 [:term:`extended  attributes (xattr)`支持所有文件系统，但测试表明使用 :term:`XFS`时性能最好可靠性最高。  更多关于横向扩展你环境的信息，参考 `Deployment Guide  `_](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#prerequisites)

在你在存储节点上安装和配置对象存储服务之前，你必须准备好存储设备。



 

注解



在每个存储节点上执行这些步骤。

1. 安装支持的工具包：

   ```
   # yum install xfsprogs rsync
   ```

2. 使用XFS格式化``/dev/sdb``和``/dev/sdc``设备：

   ```
   # mkfs.xfs /dev/sdb
   # mkfs.xfs /dev/sdc
   ```

3. 创建挂载点目录结构：

   ```
   # mkdir -p /srv/node/sdb
   # mkdir -p /srv/node/sdc
   ```

4. 编辑``/etc/fstab``文件并添加以下内容：

   ```
   /dev/sdb /srv/node/sdb xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
   /dev/sdc /srv/node/sdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
   ```

5. 挂载设备：

   ```
   # mount /srv/node/sdb
   # mount /srv/node/sdc
   ```

6. 创建并编辑``/etc/rsyncd.conf``文件并包含以下内容：

   ```
   uid = swift
   gid = swift
   log file = /var/log/rsyncd.log
   pid file = /var/run/rsyncd.pid
   address = MANAGEMENT_INTERFACE_IP_ADDRESS
   
   [account]
   max connections = 2
   path = /srv/node/
   read only = False
   lock file = /var/lock/account.lock
   
   [container]
   max connections = 2
   path = /srv/node/
   read only = False
   lock file = /var/lock/container.lock
   
   [object]
   max connections = 2
   path = /srv/node/
   read only = False
   lock file = /var/lock/object.lock
   ```

   替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)MANAGEMENT_INTERFACE_IP_ADDRESS`为存储节点管理网络的IP地址。

   

    

   注解

   

   [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)rsync``服务不需要认证，所以考虑将它安装在私有网络的环境中

1. 启动 “rsyncd” 服务和配置它随系统启动：

   ```
   # systemctl enable rsyncd.service
   # systemctl start rsyncd.service
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。



 

注解



在每个存储节点上执行这些步骤。

1. 安装软件包：

   ```
   # yum install openstack-swift-account openstack-swift-container \
     openstack-swift-object
   ```

1. 从对象存储源仓库中获取accounting, container以及object服务配置文件

   ```
   # curl -o /etc/swift/account-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/mitaka
   # curl -o /etc/swift/container-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/mitaka
   # curl -o /etc/swift/object-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/mitaka
   ```

2. 编辑 `/etc/swift/account-server.conf` 文件并完成下面操作：

   - 在``[DEFAULT]`` 部分，配置绑定IP地址，绑定端口，用户，配置目录和挂载目录：

     ```
     [DEFAULT]
     ...
     bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     bind_port = 6002
     user = swift
     swift_dir = /etc/swift
     devices = /srv/node
     mount_check = True
     ```

     替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)MANAGEMENT_INTERFACE_IP_ADDRESS`为存储节点管理网络的IP地址。

   - 在``[pipeline:main]``部分，启用合适的模块：

     ```
     [pipeline:main]
     pipeline = healthcheck recon account-server
     ```

     

      

     注解

     

     更多关于启用其他模块的额外功能的信息，请参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。

   - 在``[filter:recon]``部分，配置recon （meters）缓存目录：

     ```
     [filter:recon]
     use = egg:swift#recon
     ...
     recon_cache_path = /var/cache/swift
     ```

3. 编辑``/etc/swift/container-server.conf``文件并完成下列操作：

   - 在``[DEFAULT]`` 部分，配置绑定IP地址，绑定端口，用户，配置目录和挂载目录：

     ```
     [DEFAULT]
     ...
     bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     bind_port = 6001
     user = swift
     swift_dir = /etc/swift
     devices = /srv/node
     mount_check = True
     ```

     替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)MANAGEMENT_INTERFACE_IP_ADDRESS`为存储节点管理网络的IP地址。

   - 在``[pipeline:main]``部分，启用合适的模块：

     ```
     [pipeline:main]
     pipeline = healthcheck recon container-server
     ```

     

      

     注解

     

     更多关于启用其他模块的额外功能的信息，请参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。

   - 在``[filter:recon]``部分，配置recon （meters）缓存目录：

     ```
     [filter:recon]
     use = egg:swift#recon
     ...
     recon_cache_path = /var/cache/swift
     ```

4. 编辑``/etc/swift/object-server.conf``文件并完成下列操作：

   - 在``[DEFAULT]`` 部分，配置绑定IP地址，绑定端口，用户，配置目录和挂载目录：

     ```
     [DEFAULT]
     ...
     bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
     bind_port = 6000
     user = swift
     swift_dir = /etc/swift
     devices = /srv/node
     mount_check = True
     ```

     替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-storage-install.html#id1)MANAGEMENT_INTERFACE_IP_ADDRESS`为存储节点管理网络的IP地址。

   - 在``[pipeline:main]``部分，启用合适的模块：

     ```
     [pipeline:main]
     pipeline = healthcheck recon object-server
     ```

     

      

     注解

     

     更多关于启用其他模块的额外功能的信息，请参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。

   - 在``[filter:recon]``部分，配置recon（meters）缓存和lock目录：

     ```
     [filter:recon]
     use = egg:swift#recon
     ...
     recon_cache_path = /var/cache/swift
     recon_lock_path = /var/lock
     ```

5. 确认挂载点目录结构是否有合适的所有权：

   ```
   # chown -R swift:swift /srv/node
   ```

6. 创建 “recon” 目录和确保它有合适的所有权：

   ```
   # mkdir -p /var/cache/swift
   # chown -R root:swift /var/cache/swift
   # chmod -R 775 /var/cache/swift
   ```

## 创建，分发并初始化rings

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建账户ring](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-account-ring)
  - [创建容器ring](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-container-ring)
  - [创建对象ring](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-object-ring)
  - [分发环配置文件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#distribute-ring-configuration-files)

在开始启动对象存储服务前，你必须创建初始化account，container和object rings。ring  builder创建每个节点用户决定和部署存储体系的配置文件。简单的说，这个指南使用一个region和包括两个最多2^10 (1024)  个分区的zone，每个对象3个副本和在移动分区超过1次时最少1小时时间。对对象存储，一个分区意味着存储设备的一个目录而不是传统的分区表。更多信息，参考`Deployment Guide <http://docs.openstack.org/developer/swift/deployment_guide.html>`__。



 

注解



在控制节点上执行这些步骤。

## 创建账户ring[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-account-ring)

帐户服务器使用帐户 ring 来维护一个容器的列表。

1. 切换到 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#id1)/etc/swift``目录。

2. 创建基本 `account.builder` 文件：

   ```
   # swift-ring-builder account.builder create 10 3 1
   ```

   

    

   注解

   

   这个命令执行后没有输出。

3. 添加每个节点到 ring 中：

   ```
   # swift-ring-builder account.builder \
     add --region 1 --zone 1 --ip STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS --port 6002 \
     --device DEVICE_NAME --weight DEVICE_WEIGHT
   ```

   将 `STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS` 替换为存储节点管理网络的IP地址。将 `DEVICE_NAME``替换为同一个存储节点存储设备名称。例如，使用 :ref:`swift-storage` 中的第一个存储节点的 ``/dev/sdb` 存储设备，大小为100：

   ```
   # swift-ring-builder account.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6002 --device sdb --weight 100
   ```

   在每个存储节点上面重复执行这个命令。在这个例子的架构中，使用该命令的四个变量：

   ```
   # swift-ring-builder account.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6002 --device sdb --weight 100
   Device d0r1z1-10.0.0.51:6002R10.0.0.51:6002/sdb_"" with 100.0 weight got id 0
   # swift-ring-builder account.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6002 --device sdc --weight 100
   Device d1r1z2-10.0.0.51:6002R10.0.0.51:6002/sdc_"" with 100.0 weight got id 1
   # swift-ring-builder account.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6002 --device sdb --weight 100
   Device d2r1z3-10.0.0.52:6002R10.0.0.52:6002/sdb_"" with 100.0 weight got id 2
   # swift-ring-builder account.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6002 --device sdc --weight 100
   Device d3r1z4-10.0.0.52:6002R10.0.0.52:6002/sdc_"" with 100.0 weight got id 3
   ```

4. 验证 ring 的内容：

   ```
   # swift-ring-builder account.builder
   account.builder, build version 4
   1024 partitions, 3.000000 replicas, 1 regions, 2 zones, 4 devices, 100.00 balance, 0.00 dispersion
   The minimum number of hours before a partition can be reassigned is 1
   The overload factor is 0.00% (0.000000)
   Devices:    id  region  zone      ip address  port  replication ip  replication port      name weight partitions balance meta
                0       1     1       10.0.0.51  6002       10.0.0.51              6002      sdb  100.00          0 -100.00
                1       1     1       10.0.0.51  6002       10.0.0.51              6002      sdc  100.00          0 -100.00
                2       1     2       10.0.0.52  6002       10.0.0.52              6002      sdb  100.00          0 -100.00
                3       1     2       10.0.0.52  6002       10.0.0.52              6002      sdc  100.00          0 -100.00
   ```

5. 平衡 ring：

   ```
   # swift-ring-builder account.builder rebalance
   Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
   ```

## 创建容器ring[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-container-ring)

容器服务器使用容器环来维护对象的列表。但是，它不跟踪对象的位置。

1. 切换到 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#id1)/etc/swift``目录。

2. 创建基本``container.builder``文件：

   ```
   # swift-ring-builder container.builder create 10 3 1
   ```

   

    

   注解

   

   这个命令执行后没有输出。

3. 添加每个节点到 ring 中：

   ```
   # swift-ring-builder container.builder \
     add --region 1 --zone 1 --ip STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS --port 6001 \
     --device DEVICE_NAME --weight DEVICE_WEIGHT
   ```

   将 `STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS` 替换为存储节点管理网络的IP地址。将 `DEVICE_NAME``替换为同一个存储节点存储设备名称。例如，使用 :ref:`swift-storage` 中的第一个存储节点的 ``/dev/sdb` 存储设备，大小为100：

   ```
   # swift-ring-builder container.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6001 --device sdb --weight 100
   ```

   在每个存储节点上面重复执行这个命令。在这个例子的架构中，使用该命令的四个变量：

   ```
   # swift-ring-builder container.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6001 --device sdb --weight 100
   Device d0r1z1-10.0.0.51:6001R10.0.0.51:6001/sdb_"" with 100.0 weight got id 0
   # swift-ring-builder container.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6001 --device sdc --weight 100
   Device d1r1z2-10.0.0.51:6001R10.0.0.51:6001/sdc_"" with 100.0 weight got id 1
   # swift-ring-builder container.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6001 --device sdb --weight 100
   Device d2r1z3-10.0.0.52:6001R10.0.0.52:6001/sdb_"" with 100.0 weight got id 2
   # swift-ring-builder container.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6001 --device sdc --weight 100
   Device d3r1z4-10.0.0.52:6001R10.0.0.52:6001/sdc_"" with 100.0 weight got id 3
   ```

4. 验证 ring 的内容：

   ```
   # swift-ring-builder container.builder
   container.builder, build version 4
   1024 partitions, 3.000000 replicas, 1 regions, 2 zones, 4 devices, 100.00 balance, 0.00 dispersion
   The minimum number of hours before a partition can be reassigned is 1
   The overload factor is 0.00% (0.000000)
   Devices:    id  region  zone      ip address  port  replication ip  replication port      name weight partitions balance meta
                0       1     1       10.0.0.51  6001       10.0.0.51              6001      sdb  100.00          0 -100.00
                1       1     1       10.0.0.51  6001       10.0.0.51              6001      sdc  100.00          0 -100.00
                2       1     2       10.0.0.52  6001       10.0.0.52              6001      sdb  100.00          0 -100.00
                3       1     2       10.0.0.52  6001       10.0.0.52              6001      sdc  100.00          0 -100.00
   ```

5. 平衡 ring：

   ```
   # swift-ring-builder container.builder rebalance
   Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
   ```

## 创建对象ring[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#create-object-ring)

对象服务器使用对象环来维护对象在本地设备上的位置列表。

1. 切换到 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#id1)/etc/swift``目录。

2. 创建基本``object.builder``文件：

   ```
   # swift-ring-builder object.builder create 10 3 1
   ```

   

    

   注解

   

   这个命令执行后没有输出。

3. 添加每个节点到 ring 中：

   ```
   # swift-ring-builder object.builder \
     add --region 1 --zone 1 --ip STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS --port 6000 \
     --device DEVICE_NAME --weight DEVICE_WEIGHT
   ```

   将 `STORAGE_NODE_MANAGEMENT_INTERFACE_IP_ADDRESS` 替换为存储节点管理网络的IP地址。将 `DEVICE_NAME``替换为同一个存储节点存储设备名称。例如，使用 :ref:`swift-storage` 中的第一个存储节点的 ``/dev/sdb` 存储设备，大小为100：

   ```
   # swift-ring-builder object.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6000 --device sdb --weight 100
   ```

   在每个存储节点上面重复执行这个命令。在这个例子的架构中，使用该命令的四个变量：

   ```
   # swift-ring-builder object.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6000 --device sdb --weight 100
   Device d0r1z1-10.0.0.51:6000R10.0.0.51:6000/sdb_"" with 100.0 weight got id 0
   # swift-ring-builder object.builder add \
     --region 1 --zone 1 --ip 10.0.0.51 --port 6000 --device sdc --weight 100
   Device d1r1z2-10.0.0.51:6000R10.0.0.51:6000/sdc_"" with 100.0 weight got id 1
   # swift-ring-builder object.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6000 --device sdb --weight 100
   Device d2r1z3-10.0.0.52:6000R10.0.0.52:6000/sdb_"" with 100.0 weight got id 2
   # swift-ring-builder object.builder add \
     --region 1 --zone 2 --ip 10.0.0.52 --port 6000 --device sdc --weight 100
   Device d3r1z4-10.0.0.52:6000R10.0.0.52:6000/sdc_"" with 100.0 weight got id 3
   ```

4. 验证 ring 的内容：

   ```
   # swift-ring-builder object.builder
   object.builder, build version 4
   1024 partitions, 3.000000 replicas, 1 regions, 2 zones, 4 devices, 100.00 balance, 0.00 dispersion
   The minimum number of hours before a partition can be reassigned is 1
   The overload factor is 0.00% (0.000000)
   Devices:    id  region  zone      ip address  port  replication ip  replication port      name weight partitions balance meta
                0       1     1       10.0.0.51  6000       10.0.0.51              6000      sdb  100.00          0 -100.00
                1       1     1       10.0.0.51  6000       10.0.0.51              6000      sdc  100.00          0 -100.00
                2       1     2       10.0.0.52  6000       10.0.0.52              6000      sdb  100.00          0 -100.00
                3       1     2       10.0.0.52  6000       10.0.0.52              6000      sdc  100.00          0 -100.00
   ```

5. 平衡 ring：

   ```
   # swift-ring-builder object.builder rebalance
   Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
   ```

## 分发环配置文件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/swift-initial-rings.html#distribute-ring-configuration-files)

- 复制``account.ring.gz``，`container.ring.gz``和``object.ring.gz` 文件到每个存储节点和其他运行了代理服务的额外节点的 `/etc/swift` 目录。

​                      

## 完成安装

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 从对象存储源仓库中获取 `/etc/swift/swift.conf` 文件：

   ```
   # curl -o /etc/swift/swift.conf \
     https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/mitaka
   ```

2. 编辑 `/etc/swift/swift.conf` 文件并完成以下动作：

   - 在``[swift-hash]``部分，为你的环境配置哈希路径前缀和后缀：

     ```
     [swift-hash]
     ...
     swift_hash_path_suffix = HASH_PATH_SUFFIX
     swift_hash_path_prefix = HASH_PATH_PREFIX
     ```

     将其中的 HASH_PATH_PREFIX和 HASH_PATH_SUFFIX替换为唯一的值。

     

      

     警告

     

     这些值要保密，并且不要修改或丢失。

   - 在``[storage-policy:0]``部分，配置默认存储策略：

     ```
     [storage-policy:0]
     ...
     name = Policy-0
     default = yes
     ```

3. 复制``swift.conf`` 文件到每个存储节点和其他允许了代理服务的额外节点的 `/etc/swift` 目录。

1. 在所有节点上，确认配置文件目录是否有合适的所有权：

   ```
   # chown -R root:swift /etc/swift
   ```

2. 在控制节点和其他运行了代理服务的节点上，启动对象存储代理服务及其依赖服务，并将它们配置为随系统启动：

   ```
   # systemctl enable openstack-swift-proxy.service memcached.service
   # systemctl start openstack-swift-proxy.service memcached.service
   ```

3. 在存储节点上，启动对象存储服务，并将其设置为随系统启动：

   ```
   # systemctl enable openstack-swift-account.service openstack-swift-account-auditor.service \
     openstack-swift-account-reaper.service openstack-swift-account-replicator.service
   # systemctl start openstack-swift-account.service openstack-swift-account-auditor.service \
     openstack-swift-account-reaper.service openstack-swift-account-replicator.service
   # systemctl enable openstack-swift-container.service \
     openstack-swift-container-auditor.service openstack-swift-container-replicator.service \
     openstack-swift-container-updater.service
   # systemctl start openstack-swift-container.service \
     openstack-swift-container-auditor.service openstack-swift-container-replicator.service \
     openstack-swift-container-updater.service
   # systemctl enable openstack-swift-object.service openstack-swift-object-auditor.service \
     openstack-swift-object-replicator.service openstack-swift-object-updater.service
   # systemctl start openstack-swift-object.service openstack-swift-object-auditor.service \
     openstack-swift-object-replicator.service openstack-swift-object-updater.service
   ```

   验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

验证对象存储服务的操作。



 

注解



在控制节点上执行这些步骤。



 

警告



如果其中的一项或多项步骤没有正确执行，请在``/var/log/audit/audit.log``文件中检查SELinux的关于禁止``swift``过程的信息。如果该文件存在的话，将``/srv/node``目录下``swift_data_t`` type, `object_r` role 和the `system_u` user关于安全等级的信息设置成最低安全等级（s0）

```
# chcon -R system_u:object_r:swift_data_t:s0 /srv/node
```

1. 导入``demo``凭证

   ```
   $ . demo-openrc
   ```

2. 显示服务状态：

   ```
   $ swift stat
                           Account: AUTH_ed0b60bf607743088218b0a533d5943f
                        Containers: 0
                           Objects: 0
                             Bytes: 0
   Containers in policy "policy-0": 0
      Objects in policy "policy-0": 0
        Bytes in policy "policy-0": 0
       X-Account-Project-Domain-Id: default
                       X-Timestamp: 1444143887.71539
                        X-Trans-Id: tx1396aeaf17254e94beb34-0056143bde
                      Content-Type: text/plain; charset=utf-8
                     Accept-Ranges: bytes
   ```

3. 创建``container1``容器

   ```
   $ openstack container create container1
   +---------------------------------------+------------+------------------------------------+
   | account                               | container  | x-trans-id                         |
   +---------------------------------------+------------+------------------------------------+
   | AUTH_ed0b60bf607743088218b0a533d5943f | container1 | tx8c4034dc306c44dd8cd68-0056f00a4a |
   +---------------------------------------+------------+------------------------------------+
   ```

4. 上传一个测试文件到``container1``容器

   ```
   $ openstack object create container1 FILE
   +--------+------------+----------------------------------+
   | object | container  | etag                             |
   +--------+------------+----------------------------------+
   | FILE   | container1 | ee1eca47dc88f4879d8a229cc70a07c6 |
   +--------+------------+----------------------------------+
   ```

   用本地要上传到 `container1` 容器的文件名替换 `FILE`。

5. 列出``container1``容器里的所有文件

   ```
   $ openstack object list container1
   +------+
   | Name |
   +------+
   | FILE |
   +------+
   ```

6. 从``container1``容器里下载一个测试文件

   ```
   $ openstack object save container1 FILE
   ```

   用上传到 `container1` 容器的文件名替换 `FILE`。

   

    

   注解

   

   这个命令执行后没有输出。

​                                         

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

你的 Openstack 环境现在已经包含了对象存储。你可参考 [*启动一个实例*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#launch-instance) 或者添加更多的服务到你的环境中。

## 编排服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- [编排服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_orchestration.html)
- 安装和配置
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-next-steps.html)

The Orchestration service (heat) uses a [Heat Orchestration Template (HOT)](http://docs.openstack.org/developer/heat/template_guide/hot_guide.html) to create and manage cloud resources.

## 编排服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

编排服务通过运行调用生成运行中云应用程序的OpenStack  API为描述云应用程序提供基于模板的编排。该软件将其他OpenStack核心组件整合进一个单文件模板系统。模板允许你创建很多种类的OpenStack资源，如实例，浮点IP，云硬盘，安全组和用户。它也提供高级功能，如实例高可用，实例自动缩放，和嵌套栈。这使得OpenStack的核心项目有着庞大的用户群。

服务使部署人员能够直接或者通过定制化插件来与编排服务集成

编排服务包含以下组件：

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_orchestration.html#id1)heat``命令行客户端

  一个命令行工具，和``heat-api``通信，以运行:term:AWS CloudFormation API，最终开发者可以直接使用Orchestration REST API。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_orchestration.html#id1)heat-api``组件

  一个OpenStack本地 REST API ,发送API请求到heat-engine，通过远程过程调用(RPC)。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_orchestration.html#id1)heat-api-cfn``组件

  AWS 队列API，和AWS CloudFormation兼容，发送API请求到``heat-engine``，通过远程过程调用。

- `heat-engine`

  启动模板和提供给API消费者回馈事件。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#finalize-installation)



这个部分将描述如何在控制节点上安装及配置  Orchestration 服务，即heat。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#prerequisites)

在你安装和配置流程服务之前，你必须创建数据库，服务凭证和API端点。流程同时需要在认证服务中添加额外信息。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 `heat` 数据库：

     ```
     CREATE DATABASE heat;
     ```

   - 对``heat``数据库授予恰当的权限：

     ```
     GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' \
       IDENTIFIED BY 'HEAT_DBPASS';
     GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' \
       IDENTIFIED BY 'HEAT_DBPASS';
     ```

     使用合适的密码替换``HEAT_DBPASS``。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建``heat`` 用户：

     ```
     $ openstack user create --domain default --password-prompt heat
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | ca2e175b851943349be29a328cc5e360 |
     | name      | heat                             |
     +-----------+----------------------------------+
     ```

   - 添加 `admin` 角色到 `heat` 用户上。

     ```
     $ openstack role add --project service --user heat admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建``heat`` 和 `heat-cfn` 服务实体：

     ```
     $ openstack service create --name heat \
       --description "Orchestration" orchestration
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Orchestration                    |
     | enabled     | True                             |
     | id          | 727841c6f5df4773baa4e8a5ae7d72eb |
     | name        | heat                             |
     | type        | orchestration                    |
     +-------------+----------------------------------+
     
     $ openstack service create --name heat-cfn \
       --description "Orchestration"  cloudformation
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Orchestration                    |
     | enabled     | True                             |
     | id          | c42cede91a4e47c3b10c8aedc8d890c6 |
     | name        | heat-cfn                         |
     | type        | cloudformation                   |
     +-------------+----------------------------------+
     ```

4. 创建 Orchestration 服务的 API 端点：

   ```
   $ openstack endpoint create --region RegionOne \
     orchestration public http://controller:8004/v1/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | 3f4dab34624e4be7b000265f25049609        |
   | interface    | public                                  |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb        |
   | service_name | heat                                    |
   | service_type | orchestration                           |
   | url          | http://controller:8004/v1/%(tenant_id)s |
   +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     orchestration internal http://controller:8004/v1/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | 9489f78e958e45cc85570fec7e836d98        |
   | interface    | internal                                |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb        |
   | service_name | heat                                    |
   | service_type | orchestration                           |
   | url          | http://controller:8004/v1/%(tenant_id)s |
   +--------------+-----------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     orchestration admin http://controller:8004/v1/%\(tenant_id\)s
   +--------------+-----------------------------------------+
   | Field        | Value                                   |
   +--------------+-----------------------------------------+
   | enabled      | True                                    |
   | id           | 76091559514b40c6b7b38dde790efe99        |
   | interface    | admin                                   |
   | region       | RegionOne                               |
   | region_id    | RegionOne                               |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb        |
   | service_name | heat                                    |
   | service_type | orchestration                           |
   | url          | http://controller:8004/v1/%(tenant_id)s |
   +--------------+-----------------------------------------+
   ```

   ```
   $ openstack endpoint create --region RegionOne \
     cloudformation public http://controller:8000/v1
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | b3ea082e019c4024842bf0a80555052c |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | c42cede91a4e47c3b10c8aedc8d890c6 |
   | service_name | heat-cfn                         |
   | service_type | cloudformation                   |
   | url          | http://controller:8000/v1        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     cloudformation internal http://controller:8000/v1
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 169df4368cdc435b8b115a9cb084044e |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | c42cede91a4e47c3b10c8aedc8d890c6 |
   | service_name | heat-cfn                         |
   | service_type | cloudformation                   |
   | url          | http://controller:8000/v1        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     cloudformation admin http://controller:8000/v1
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 3d3edcd61eb343c1bbd629aa041ff88b |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | c42cede91a4e47c3b10c8aedc8d890c6 |
   | service_name | heat-cfn                         |
   | service_type | cloudformation                   |
   | url          | http://controller:8000/v1        |
   +--------------+----------------------------------+
   ```

5. 为了管理栈，在认证服务中Orchestration需要更多信息。为了添加这些信息，完成下面的步骤：

   - 为栈创建 `heat` 包含项目和用户的域：

     ```
     $ openstack domain create --description "Stack projects and users" heat
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Stack projects and users         |
     | enabled     | True                             |
     | id          | 0f4d1bd326f2454dacc72157ba328a47 |
     | name        | heat                             |
     +-------------+----------------------------------+
     ```

   - 在 `heat` 域中创建管理项目和用户的``heat_domain_admin``用户：

     ```
     $ openstack user create --domain heat --password-prompt heat_domain_admin
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | 0f4d1bd326f2454dacc72157ba328a47 |
     | enabled   | True                             |
     | id        | b7bd1abfbcf64478b47a0f13cd4d970a |
     | name      | heat_domain_admin                |
     +-----------+----------------------------------+
     ```

   - 添加``admin``角色到 `heat` 域 中的``heat_domain_admin``用户，启用``heat_domain_admin``用户管理栈的管理权限：

     ```
     $ openstack role add --domain heat --user-domain heat --user heat_domain_admin admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建 `heat_stack_owner` 角色：

     ```
     $ openstack role create heat_stack_owner
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | 15e34f0c4fed4e68b3246275883c8630 |
     | name      | heat_stack_owner                 |
     +-----------+----------------------------------+
     ```

   - 添加``heat_stack_owner`` 角色到``demo`` 项目和用户，启用``demo`` 用户管理栈。

     ```
     $ openstack role add --project demo --user demo heat_stack_owner
     ```

     

      

     注解

     

     这个命令执行后没有输出。

     

      

     注解

     

     你必须添加 `heat_stack_owner` 角色到每个管理栈的用户。

   - 创建 `heat_stack_user` 角色：

     ```
     $ openstack role create heat_stack_user
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | 88849d41a55d4d1d91e4f11bffd8fc5c |
     | name      | heat_stack_user                  |
     +-----------+----------------------------------+
     ```

     

      

     注解

     

     Orchestration 自动地分配 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#id1)heat_stack_user``角色给在 stack 部署过程中创建的用户。默认情况下，这个角色会限制 [*API*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-application-programming-interface-api) 的操作。为了避免冲突，请不要为用户添加 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#id3)heat_stack_owner``角色。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-heat-api openstack-heat-api-cfn \
     openstack-heat-engine
   ```

1. 编辑文件 `/etc/heat/heat.conf` 并完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://heat:HEAT_DBPASS@controller/heat
     ```

     将 `HEAT_DBPASS` 替换为你为 Orchestration 数据库选择的密码。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在``[keystone_authtoken]``， `[trustee]`，`[clients_keystone]``和 ``[ec2authtoken]` 部分，配置认证服务访问：

     ```
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = heat
     password = HEAT_PASS
     
     [trustee]
     ...
     auth_plugin = password
     auth_url = http://controller:35357
     username = heat
     password = HEAT_PASS
     user_domain_name = default
     
     [clients_keystone]
     ...
     auth_uri = http://controller:35357
     
     [ec2authtoken]
     ...
     auth_uri = http://controller:5000/v2.0
     ```

     将``HEAT_PASS`` 替换为你在认证服务中为 `heat` 用户选择的密码。

   - 在``[DEFAULT]`` 部分，配置元数据和 等待条件URLs：

     ```
     [DEFAULT]
     ...
     heat_metadata_server_url = http://controller:8000
     heat_waitcondition_server_url = http://controller:8000/v1/waitcondition
     ```

   - 在 `[DEFAULT]` 部分，配置栈域与管理凭据：

     ```
     [DEFAULT]
     ...
     stack_domain_admin = heat_domain_admin
     stack_domain_admin_password = HEAT_DOMAIN_PASS
     stack_user_domain_name = heat
     ```

     将 `HEAT_DOMAIN_PASS` 替换为你在认证服务中为``heat_domain_admin`` 用户选择的密码。

1. 同步Orchestration数据库：

   ```
   # su -s /bin/sh -c "heat-manage db_sync" heat
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/heat-install.html#finalize-installation)

- 启动 Orchestration 服务并将其设置为随系统启动：

  ```
  # systemctl enable openstack-heat-api.service \
    openstack-heat-api-cfn.service openstack-heat-engine.service
  # systemctl start openstack-heat-api.service \
    openstack-heat-api-cfn.service openstack-heat-engine.service
  ```

​                                                                                      

updated: 2017-06-12 11:14

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



验证Orchestration服务的相关操作。



 

注解



在控制节点上执行这些命令。

1. source 租户``admin`的凭证脚本：

   ```
   $ . admin-openrc
   ```

2. 列出服务组件，以验证是否成功启动并注册了每个进程：

   ```
   $ openstack orchestration service list
   +------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
   | hostname   | binary      | engine_id                            | host       | topic  | updated_at                 | status |
   +------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
   | controller | heat-engine | 3e85d1ab-a543-41aa-aa97-378c381fb958 | controller | engine | 2015-10-13T14:16:06.000000 | up     |
   | controller | heat-engine | 45dbdcf6-5660-4d5f-973a-c4fc819da678 | controller | engine | 2015-10-13T14:16:06.000000 | up     |
   | controller | heat-engine | 51162b63-ecb8-4c6c-98c6-993af899c4f7 | controller | engine | 2015-10-13T14:16:06.000000 | up     |
   | controller | heat-engine | 8d7edc6d-77a6-460d-bd2a-984d76954646 | controller | engine | 2015-10-13T14:16:06.000000 | up     |
   +------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
   ```

   

    

   注解

   

   该输出显示表明在控制节点上有应该四个``heat-engine``组件。

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



您的 OpenStack 环境现在已经包含了 Orchestration。您可以 [*启动一个实例*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#launch-instance) 或根据以下章节添加更多服务到您的环境中。

## Telemetry服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



- Telemetry服务概述
  - [Telemetry数据收集服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-data-collection-service)
  - [检查告警服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-alarming-service)
- 安装和配置
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#finalize-installation)
- 启用镜像服务计量
  - [配置镜像服务使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#configure-the-image-service-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#finalize-installation)
- 启用计算服务计量
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#install-and-configure-components)
  - [配置计算使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#configure-compute-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#finalize-installation)
- 启用块存储计量
  - [配置卷使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#configure-cinder-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#finalize-installation)
- 启用对象计量
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#prerequisites)
  - [安装组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#install-components)
  - [配置对象存储使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#configure-object-storage-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#finalize-installation)
- 警告服务
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-next-steps.html)

## Telemetry服务概述

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [Telemetry数据收集服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-data-collection-service)
  - [检查告警服务](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-alarming-service)

## Telemetry数据收集服务[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-data-collection-service)

计量数据收集（Telemetry）服务提供如下功能：

- 相关OpenStack服务的有效调查计量数据。
- 通过监测通知收集来自各个服务发送的事件和计量数据。
- 发布收集来的数据到多个目标，包括数据存储和消息队列。

Telemetry服务包含以下组件：

- 计算代理 (`ceilometer-agent-compute`)

  运行在每个计算节点中，推送资源的使用状态，也许在未来会有其他类型的代理，但是目前来说社区专注于创建计算节点代理。

- 中心代理 (`ceilometer-agent-central`)

  运行在中心管理服务器以推送资源使用状态，既不捆绑到实例也不在计算节点。代理可启动多个以横向扩展它的服务。

- ceilometer通知代理；

  运行在中心管理服务器(s)中，获取来自消息队列(s)的消息去构建事件和计量数据。

- ceilometor收集器（负责接收信息进行持久化存储）

  运行在中心管理服务器(s),分发收集的telemetry数据到数据存储或者外部的消费者，但不会做任何的改动。

- API服务器 (`ceilometer-api`)

  运行在一个或多个中心管理服务器，提供从数据存储的数据访问。

## 检查告警服务[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_telemetry.html#telemetry-alarming-service)

当收集的度量或事件数据打破了界定的规则时，计量报警服务会出发报警。

计量报警服务包含以下组件：

- API服务器 (`aodh-api`)

  运行于一个或多个中心管理服务器上提供访问存储在数据中心的警告信息。

- 报警评估器 (`aodh-evaluator`)

  运行在一个或多个中心管理服务器，当警告发生是由于相关联的统计趋势超过阈值以上的滑动时间窗口，然后作出决定。

- 通知监听器 (`aodh-listener`)

  运行在一个中心管理服务器上，来检测什么时候发出告警。根据对一些事件预先定义一些规则，会产生相应的告警，同时能够被Telemetry数据收集服务的通知代理捕获到。

- 报警通知器 (`aodh-notifier`)

  运行在一个或多个中心管理服务器，允许警告为一组收集的实例基于评估阀值来设置。

这些服务使用OpenStack消息总线来通信，只有收集者和API服务可以访问数据存储。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#finalize-installation)

本节描述如何在控制节点上安装和配置代号ceilometer的Telemetry服务。Telemetry服务收集OpenStack大部分服务的测量结果，可选的触发告警。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#prerequisites)

安装和配置Telemetry服务之前，你必须创建创建一个数据库、服务凭证和API端点。但是，不像其他服务，Telemetry服务使用NoSQL 数据库。在进一步处理之前查看 ref:environment-nosql-database 来安装和配置MongoDB。

1. 创建 `ceilometer` 数据库：

   ```
   # mongo --host controller --eval '
     db = db.getSiblingDB("ceilometer");
     db.createUser({user: "ceilometer",
     pwd: "CEILOMETER_DBPASS",
     roles: [ "readWrite", "dbAdmin" ]})'
   
   MongoDB shell version: 2.6.x
   connecting to: controller:27017/test
   Successfully added user: { "user" : "ceilometer", "roles" : [ "readWrite", "dbAdmin" ] }
   ```

   用合适的密码替换 `CEILOMETER_DBPASS`。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 要创建服务证书，完成这些步骤：

   - 创建 `ceilometer` 用户：

     ```
     $ openstack user create --domain default --password-prompt ceilometer
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | c859c96f57bd4989a8ea1a0b1d8ff7cd |
     | name      | ceilometer                       |
     +-----------+----------------------------------+
     ```

   - 添加 `admin` 角色到 `ceilometer` 用户上。

     ```
     $ openstack role add --project service --user ceilometer admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建 `ceilometer` 服务实体：

     ```
     $ openstack service create --name ceilometer \
       --description "Telemetry" metering
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Telemetry                        |
     | enabled     | True                             |
     | id          | 5fb7fd1bb2954fddb378d4031c28c0e4 |
     | name        | ceilometer                       |
     | type        | metering                         |
     +-------------+----------------------------------+
     ```

3. 创建Telemetry服务API端点

   ```
   $ openstack endpoint create --region RegionOne \
     metering public http://controller:8777
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | b808b67b848d443e9eaaa5e5d796970c |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 5fb7fd1bb2954fddb378d4031c28c0e4 |
   | service_name | ceilometer                       |
   | service_type | metering                         |
   | url          | http://controller:8777           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     metering internal http://controller:8777
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | c7009b1c2ee54b71b771fa3d0ae4f948 |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 5fb7fd1bb2954fddb378d4031c28c0e4 |
   | service_name | ceilometer                       |
   | service_type | metering                         |
   | url          | http://controller:8777           |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     metering admin http://controller:8777
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | b2c00566d0604551b5fe1540c699db3d |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 5fb7fd1bb2954fddb378d4031c28c0e4 |
   | service_name | ceilometer                       |
   | service_type | metering                         |
   | url          | http://controller:8777           |
   +--------------+----------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install openstack-ceilometer-api \
     openstack-ceilometer-collector openstack-ceilometer-notification \
     openstack-ceilometer-central python-ceilometerclient
   ```

1. 编辑 `/etc/ceilometer/ceilometer.conf`，同时完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mongodb://ceilometer:CEILOMETER_DBPASS@controller:27017/ceilometer
     ```

     用你选择的Telemtry服务数据库密码替换 `CEILOMETER_DBPASS`。按照RFC2396，你必须参考`RFC2396 <https://www.ietf.org/rfc/rfc2396.txt>`_，在连接字符串转义特殊字符，如：’:’，’/’，’+’和’@’。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = ceilometer
     password = CEILOMETER_PASS
     ```

     用你在认证服务中为 “ceilometer” 选择的密码替换 “CEILOMETER_PASS”。

   - 在 “[service_credentials]” 部分，配置服务证书：

     ```
     [service_credentials]
     ...
     auth_type = password
     auth_url = http://controller:5000/v3
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = ceilometer
     password = CEILOMETER_PASS
     interface = internalURL
     region_name = RegionOne
     ```

     用你在认证服务中为 “ceilometer” 选择的密码替换 “CEILOMETER_PASS”。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-install.html#finalize-installation)

- 启动Telemetry服务并将其配置为随系统启动：

  ```
  # systemctl enable openstack-ceilometer-api.service \
    openstack-ceilometer-notification.service \
    openstack-ceilometer-central.service \
    openstack-ceilometer-collector.service
  # systemctl start openstack-ceilometer-api.service \
    openstack-ceilometer-notification.service \
    openstack-ceilometer-central.service \
    openstack-ceilometer-collector.service
  ```

​                      

## 启用镜像服务计量

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置镜像服务使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#configure-the-image-service-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#finalize-installation)

Telemetry使用通知收集镜像服务计量信息。在控制节点上执行这些步骤。

## 配置镜像服务使用Telemetry[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#configure-the-image-service-to-use-telemetry)

- 编辑 “/etc/glance/glance-api.conf” 和 “/etc/glance/glance-registry.conf”，同时完成如下动作：

  - 在``[DEFAULT]``, [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#id1)[oslo_messaging_notifications]``和 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#id3)[oslo_messaging_rabbit]``部分，配置通知和RabbitMQ消息队列访问：

    ```
    [DEFAULT]
    ...
    rpc_backend = rabbit
    
    [oslo_messaging_notifications]
    ...
    driver = messagingv2
    
    [oslo_messaging_rabbit]
    ...
    rabbit_host = controller
    rabbit_userid = openstack
    rabbit_password = RABBIT_PASS
    ```

    用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-glance.html#finalize-installation)

- 重启镜像服务：

  ```
  # systemctl restart openstack-glance-api.service openstack-glance-registry.service
  ```

## 启用计算服务计量

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#install-and-configure-components)
  - [配置计算使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#configure-compute-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#finalize-installation)

Telemetry 通过结合使用通知和代理来收集Computer度量值。在每个计算节点上执行这些步骤。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install openstack-ceilometer-compute python-ceilometerclient python-pecan
   ```

1. 编辑 `/etc/ceilometer/ceilometer.conf`，同时完成如下动作：

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = ceilometer
     password = CEILOMETER_PASS
     ```

     用你为 Telemetry 服务数据库选择的密码替换  `CEILOMETER_PASS`。

   - 在 “[service_credentials]” 部分，配置服务证书：

     ```
     [service_credentials]
     ...
     auth_type = password
     auth_url = http://controller:5000/v3
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = ceilometer
     password = CEILOMETER_PASS
     interface = internalURL
     region_name = RegionOne
     ```

     用你在认证服务中为 “ceilometer” 选择的密码替换 “CEILOMETER_PASS”。

## 配置计算使用Telemetry[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#configure-compute-to-use-telemetry)

- 编辑 `/etc/nova/nova.conf` 和在 `[DEFAULT]` 配置提醒：

  ```
  [DEFAULT]
  ...
  instance_usage_audit = True
  instance_usage_audit_period = hour
  notify_on_state_change = vm_and_task_state
  notification_driver = messagingv2
  ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-nova.html#finalize-installation)

1. 启动代理和配置它随系统一起启动：

   ```
   # systemctl enable openstack-ceilometer-compute.service
   # systemctl start openstack-ceilometer-compute.service
   ```

1. 重启计算服务：

   ```
   # systemctl restart openstack-nova-compute.service
   ```

## 启用块存储计量

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置卷使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#configure-cinder-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#finalize-installation)

Telemetry使用通知收集块存储服务计量。在控制节点和块存储节点上执行这些步骤。



 

注解



您的环境必须包含块存储服务。

## 配置卷使用Telemetry[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#configure-cinder-to-use-telemetry)

编辑 `/etc/cinder/cinder.conf`，同时完成如下动作：

- 在 `[oslo_messaging_notifications]` 部分，配置提醒：

  ```
  [oslo_messaging_notifications]
  ...
  driver = messagingv2
  ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-cinder.html#finalize-installation)

1. 重启控制节点上的块设备存储服务：

   ```
   # systemctl restart openstack-cinder-api.service openstack-cinder-scheduler.service
   ```

2. 重启存储节点上的块设备存储服务：

   ```
   # systemctl restart openstack-cinder-volume.service
   ```

1. 在块存储节点上使用``cinder-volume-usage-audit``命令按需检索度量值。 更多信息，请查看`管理员指南 <http://docs.openstack.org/admin-guide/ telemetry-data-collection.html#block-storage-audit-script-setup-to-get- notifications>`__。

## 启用对象计量

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#prerequisites)
  - [安装组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#install-components)
  - [配置对象存储使用Telemetry](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#configure-object-storage-to-use-telemetry)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#finalize-installation)

Telemetry结合使用代理和通知收集对象存储计量。



 

注解



您的环境必须包含对象存储服务。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#prerequisites)

Telemetry 服务要求用 `ResellerAdmin` 的角色来访问对象存储服务。在控制节点实施这些步骤。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限。

   ```
   $ . admin-openrc
   ```

2. 创建 `ResellerAdmin` 角色：

   ```
   $ openstack role create ResellerAdmin
   +-----------+----------------------------------+
   | Field     | Value                            |
   +-----------+----------------------------------+
   | domain_id | None                             |
   | id        | 462fa46c13fd4798a95a3bfbe27b5e54 |
   | name      | ResellerAdmin                    |
   +-----------+----------------------------------+
   ```

3. 给``ceilometer``用户添加``ResellerAdmin``角色：

   ```
   $ openstack role add --project service --user ceilometer ResellerAdmin
   ```

   

    

   注解

   

   这个命令执行后没有输出。

## 安装组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#install-components)

- 安装软件包：

  ```
  # yum install python-ceilometermiddleware
  ```

## 配置对象存储使用Telemetry[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#configure-object-storage-to-use-telemetry)

在控制节点上执行这些步骤，在其他节点上运行对象存储的代理服务。

- 编辑文件 `/etc/swift/proxy-server.conf` 并完成如下动作：

  - 在 `[filter:keystoneauth]` 部分， 添加 `ResellerAdmin` 角色：

    ```
    [filter:keystoneauth]
    ...
    operator_roles = admin, user, ResellerAdmin
    ```

  - 在 `[pipeline:main]` 部分，添加 `ceilometer`：

    ```
    [pipeline:main]
    pipeline = ceilometer catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server
    ```

  - 在 `[filter:ceilometer]` 部分，配置提醒：

    ```
    [filter:ceilometer]
    paste.filter_factory = ceilometermiddleware.swift:filter_factory
    ...
    control_exchange = swift
    url = rabbit://openstack:RABBIT_PASS@controller:5672/
    driver = messagingv2
    topic = notifications
    log_level = WARN
    ```

    用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-swift.html#finalize-installation)

- 重启对象存储的代理服务：

  ```
  # systemctl restart openstack-swift-proxy.service
  ```

 警告服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#finalize-installation)



这个部分描述怎样安装和配置 Telemetry 警告服务（代码名aodh）。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#prerequisites)

在安装和配置警告服务之前，你必须创建一个数据库，服务凭证和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#id1)aodh``数据库：

     ```
     CREATE DATABASE aodh;
     ```

   - 对``aodh``数据库授予恰当的访问权限：

     ```
     GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'localhost' \
       IDENTIFIED BY 'AODH_DBPASS';
     GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'%' \
       IDENTIFIED BY 'AODH_DBPASS';
     ```

     用合适的密码替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#id1)AODH_DBPASS [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#id3)。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#id1)aodh``用户：

     ```
     $ openstack user create --domain default \
       --password-prompt aodh
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | b7657c9ea07a4556aef5d34cf70713a3 |
     | name      | aodh                             |
     +-----------+----------------------------------+
     ```

   - 添加``admin`` 角色到 `aodh` 用户：

     ```
     $ openstack role add --project service --user aodh admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建 `aodh` 服务实体：

     ```
     $ openstack service create --name aodh \
       --description "Telemetry" alarming
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Telemetry                        |
     | enabled     | True                             |
     | id          | 3405453b14da441ebb258edfeba96d83 |
     | name        | aodh                             |
     | type        | alarming                         |
     +-------------+----------------------------------+
     ```

4. 创建警告服务API端点：

   ```
   $ openstack endpoint create --region RegionOne \
     alarming public http://controller:8042
     +--------------+----------------------------------+
     | Field        | Value                            |
     +--------------+----------------------------------+
     | enabled      | True                             |
     | id           | 340be3625e9b4239a6415d034e98aace |
     | interface    | public                           |
     | region       | RegionOne                        |
     | region_id    | RegionOne                        |
     | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
     | service_name | aodh                             |
     | service_type | alarming                         |
     | url          | http://controller:8042           |
     +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     alarming internal http://controller:8042
     +--------------+----------------------------------+
     | Field        | Value                            |
     +--------------+----------------------------------+
     | enabled      | True                             |
     | id           | 340be3625e9b4239a6415d034e98aace |
     | interface    | internal                         |
     | region       | RegionOne                        |
     | region_id    | RegionOne                        |
     | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
     | service_name | aodh                             |
     | service_type | alarming                         |
     | url          | http://controller:8042           |
     +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     alarming admin http://controller:8042
     +--------------+----------------------------------+
     | Field        | Value                            |
     +--------------+----------------------------------+
     | enabled      | True                             |
     | id           | 340be3625e9b4239a6415d034e98aace |
     | interface    | admin                            |
     | region       | RegionOne                        |
     | region_id    | RegionOne                        |
     | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
     | service_name | aodh                             |
     | service_type | alarming                         |
     | url          | http://controller:8042           |
     +--------------+----------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#install-and-configure-components)



 

注解



默认的配置文件根据不同发行版本而不同。有可能需要增加这些部分或是选项，而不是修改现有的部分或是选项。另外，配置文件代码段中的省略号(...)表明这可能是你需要保留的默认配置选项。

1. 安装软件包：

   ```
   # yum install openstack-aodh-api \
     openstack-aodh-evaluator openstack-aodh-notifier \
     openstack-aodh-listener openstack-aodh-expirer \
     python-ceilometerclient
   ```

1. 编辑``/etc/aodh/aodh.conf``文件并完成以下操作：

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://aodh:AODH_DBPASS@controller/aodh
     ```

     用你选择的Telemetry Alarming模型数据库密码替换``AODH_DBPASS``。你必须遵循`RFC2396 <https://www.ietf.org/rfc/rfc2396.txt>`_，在链接字符串里转移特殊字数，如：’:’，’/’，’+’，和 ‘@’。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = aodh
     password = AODH_PASS
     ```

     将``AODH_PASS``替换成你在认证服务里为``aodh``用户选择的密码。

   - 在 “[service_credentials]” 部分，配置服务证书：

     ```
     [service_credentials]
     ...
     auth_type = password
     auth_url = http://controller:5000/v3
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = aodh
     password = AODH_PASS
     interface = internalURL
     region_name = RegionOne
     ```

     将``AODH_PASS``替换成你在认证服务里为``aodh``用户选择的密码。

1. 初始化告警数据库：

   ```
   # su -s /bin/sh -c "aodh-dbsync" aodh
   ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/ceilometer-aodh.html#finalize-installation)

- 启动Alarming服务并将其配置为随系统启动：

  ```
  # systemctl enable openstack-aodh-api.service \
    openstack-aodh-evaluator.service \
    openstack-aodh-notifier.service \
    openstack-aodh-listener.service
  # systemctl start openstack-aodh-api.service \
    openstack-aodh-evaluator.service \
    openstack-aodh-notifier.service \
    openstack-aodh-listener.service
  ```

​                                                                                      

updated: 2017-06-12 11:14                     

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

验证Telemetry服务操作。为了简单些，下面的这些步骤只包括了镜像服务计量信息。如果环境中ceilometer集成了其他服务会包含更多计量信息。



 

注解



在控制节点上执行这些步骤。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出可用的 meters：

   ```
   $ ceilometer meter-list
   +--------------+-------+-------+--------------------------------------+---------+------------+
   | Name         | Type  | Unit  | Resource ID                          | User ID | Project ID |
   +--------------+-------+-------+--------------------------------------+---------+------------+
   | image        | gauge | image | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   | image.size   | gauge | B     | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   +--------------+-------+-------+--------------------------------------+---------+------------+
   ```

3. 从镜像服务下载CirrOS镜像：

   ```
   $ IMAGE_ID=$(glance image-list | grep 'cirros' | awk '{ print $2 }')
   $ glance image-download $IMAGE_ID > /tmp/cirros.img
   ```

4. 再次列出可用的 meters 以验证镜像下载的检查：

   ```
   $ ceilometer meter-list
   +----------------+-------+-------+--------------------------------------+---------+------------+
   | Name           | Type  | Unit  | Resource ID                          | User ID | Project ID |
   +----------------+-------+-------+--------------------------------------+---------+------------+
   | image          | gauge | image | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   | image.download | delta | B     | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   | image.serve    | delta | B     | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   | image.size     | gauge | B     | acafc7c0-40aa-4026-9673-b879898e1fc2 | None    | cf12a15... |
   +----------------+-------+-------+--------------------------------------+---------+------------+
   ```

5. 从 `image.download` 表读取使用量统计值。

   ```
   $ ceilometer statistics -m image.download -p 60
   +--------+---------------------+---------------------+------------+------------+------------+------------+-------+----------+----------------------------+----------------------------+
   | Period | Period Start        | Period End          | Max        | Min        | Avg        | Sum        | Count | Duration | Duration Start             | Duration End               |
   +--------+---------------------+---------------------+------------+------------+------------+------------+-------+----------+----------------------------+----------------------------+
   | 60     | 2015-04-21T12:21:45 | 2015-04-21T12:22:45 | 13200896.0 | 13200896.0 | 13200896.0 | 13200896.0 | 1     | 0.0      | 2015-04-21T12:22:12.983000 | 2015-04-21T12:22:12.983000 |
   +--------+---------------------+---------------------+------------+------------+------------+------------+-------+----------+----------------------------+----------------------------+
   ```

6. 删除之前下载的镜像文件 `/tmp/cirros.img`：

   ```
   $ rm /tmp/cirros.img
   ```

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

你的 Openstack 环境现在已经包含了 Telemetry. 你可参考：’launch-instance’ 或者添加更多的服务到你的环境中。

## 数据库服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- [数据库服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html)
- 安装和配置
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#finalize-installation)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-verify.html)
- [下一步](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-next-steps.html)

数据库服务（trove）为数据库引擎提供了云部署的功能。

## 数据库服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

数据库服务提供可扩展性和可靠的云部署关系型和非关系性数据库引擎的功能。用户可以快速和轻松使用数据库的特性而无须掌控复杂的管理任务，云用户和数据库管理员可以按需部署和管理多个数据库实例。

数据库服务在高性能层次上提供了资源的隔离，以及自动化了复杂的管理任务，诸如部署、配置、打补丁、备份、恢复以及监控。

**Process flow example**

此例子是一个为使用数据库服务的高级别的流程：

1. OpenStack管理员使用下面的步骤来配置基本的基础设施：

   1. 安装数据库服务。
   2. 为每种类型的数据库制作各自的镜像。例如，一个是MySQL,一个是MongoDB。
   3. 使用:command:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove-manage`命令导入镜像并提供给租户。

2. OpenStack最终用户使用下列步骤部署数据库服务:

   1. 使用 :command:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove create`命令来创建数据库服务实例。

   2. 使用:command:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove list`命令获取实例的ID，之后可使用`trove show`命令获取实例IP地址。

   3. 使用典型的数据库访问命令来访问数据库服务实例。例如，对于 MYSQL：

      ```
      $ mysql -u myuser -p -h TROVE_IP_ADDRESS mydb
      ```

**Components**

数据库服务包含下列组件：

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)python-troveclient``命令行客户端

  一个与 `trove-api` 组件通信的命令行界面。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove-api``组件

  提供OpenStack本地的RESTful API，支持JSON格式的部署和管理Trove实例。

- `trove-conductor` 服务

  运行在主机上，接收来自guest实例的消息，然后将之更新在主机上。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove-taskmanager``服务

  能够支持部署实例，管理实例的生命周期，以及对实例的日常操作等复杂系统流的服务。

- [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_database_service.html#id1)trove-guestagent``服务

  运行在guest实例内部，管理和执行数据库自身的操作。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#finalize-installation)



这部分用来描述如何在控制节点上安装并配置数据库服务，即trove

这部分假设你的OpenStack工作环境中至少已经安装了以下组件：计算，镜像，身份认证服务

- 如果你想要备份以及恢复，你同样需要对象存储
- 如果你想要在块存储卷组上提供数据存储功能，你同样需要对象存储

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#prerequisites)

安装和配置数据库服务之前，你必须创建创建一个数据库、服务凭证和API端点。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id1)trove [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id3)数据库：

     ```
     CREATE DATABASE trove;
     ```

   - 对``trove [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id1)数据库授予恰当的访问权限：

     ```
     GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'localhost' \
       IDENTIFIED BY 'TROVE_DBPASS';
     GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'%' \
       IDENTIFIED BY 'TROVE_DBPASS';
     ```

     用合适的密码替换 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id1)TROVE_DBPASS [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id3)。

   - 退出数据库客户端。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ source admin-openrc.sh
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id1)trove [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id3)用户：

     ```
     $ openstack user create --domain default --password-prompt trove
     User Password:
     Repeat User Password:
     +-----------+-----------------------------------+
     | Field     | Value                             |
     +-----------+-----------------------------------+
     | domain_id | default                           |
     | enabled   | True                              |
     | id        | ca2e175b851943349be29a328cc5e360  |
     | name      | trove                             |
     +-----------+-----------------------------------+
     ```

   - 给 `trove `` 用户添加 ``admin` 角色：

     ```
     $ openstack role add --project service --user trove admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

   - 创建``trove``服务实体：

     ```
     $ openstack service create --name trove \
       --description "Database" database
     +-------------+-----------------------------------+
     | Field       | Value                             |
     +-------------+-----------------------------------+
     | description | Database                          |
     | enabled     | True                              |
     | id          | 727841c6f5df4773baa4e8a5ae7d72eb  |
     | name        | trove                             |
     | type        | database                          |
     +-------------+-----------------------------------+
     ```

4. 创建数据库服务API端点：

   ```
   $ openstack endpoint create --region RegionOne \
     database public http://controller:8779/v1.0/%\(tenant_id\)s
   +--------------+----------------------------------------------+
   | Field        | Value                                        |
   +--------------+----------------------------------------------+
   | enabled      | True                                         |
   | id           | 3f4dab34624e4be7b000265f25049609             |
   | interface    | public                                       |
   | region       | RegionOne                                    |
   | region_id    | RegionOne                                    |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb             |
   | service_name | trove                                        |
   | service_type | database                                     |
   | url          | http://controller:8779/v1.0/%\(tenant_id\)s  |
   +--------------+----------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     database internal http://controller:8779/v1.0/%\(tenant_id\)s
   +--------------+----------------------------------------------+
   | Field        | Value                                        |
   +--------------+----------------------------------------------+
   | enabled      | True                                         |
   | id           | 9489f78e958e45cc85570fec7e836d98             |
   | interface    | internal                                     |
   | region       | RegionOne                                    |
   | region_id    | RegionOne                                    |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb             |
   | service_name | trove                                        |
   | service_type | database                                     |
   | url          | http://controller:8779/v1.0/%\(tenant_id\)s  |
   +--------------+----------------------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     database admin http://controller:8779/v1.0/%\(tenant_id\)s
   +--------------+----------------------------------------------+
   | Field        | Value                                        |
   +--------------+----------------------------------------------+
   | enabled      | True                                         |
   | id           | 76091559514b40c6b7b38dde790efe99             |
   | interface    | admin                                        |
   | region       | RegionOne                                    |
   | region_id    | RegionOne                                    |
   | service_id   | 727841c6f5df4773baa4e8a5ae7d72eb             |
   | service_name | trove                                        |
   | service_type | database                                     |
   | url          | http://controller:8779/v1.0/%\(tenant_id\)s  |
   +--------------+----------------------------------------------+
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。

1. 安装软件包：

   ```
   # yum install openstack-trove python-troveclient
   ```

1. 在``/etc/trove``目录下，编辑``trove.conf``, [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#id1)trove-taskmanager.conf``以及``trove-conductor.conf``文件并完成以下步骤：

   - 为以下的设置提供合适的值：

     ```
     [DEFAULT]
     log_dir = /var/log/trove
     trove_auth_url = http://controller:5000/v2.0
     nova_compute_url = http://controller:8774/v2
     cinder_url = http://controller:8776/v1
     swift_url = http://controller:8080/v1/AUTH_
     notifier_queue_hostname = controller
     ...
     [database]
     connection = mysql://trove:TROVE_DBPASS@controller/trove
     ```

   - 通过在每个文件中设置以下选项来配置数据库服务使用``RabbitMQ``消息队列

     ```
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

2. 验证``api-paste.ini``文件是否存在于``/etc/trove``目录下

   如果文件不存在，你可以从以下这个地址获得它：<http://git.openstack.org/cgit/openstack/trove/plain/etc/trove/api-paste.ini?h=stable/mitaka>`__.

3. 编辑``trove.conf``文件，像下面展示的那样为其设置合适的值

   ```
   [DEFAULT]
   auth_strategy = keystone
   ...
   # Config option for showing the IP address that nova doles out
   add_addresses = True
   network_label_regex = ^NETWORK_LABEL$
   ...
   api_paste_config = /etc/trove/api-paste.ini
   ...
   [keystone_authtoken]
   ...
   auth_uri = http://controller:5000
   auth_url = http://controller:35357
   auth_type = password
   project_domain_name = default
   user_domain_name = default
   project_name = service
   username = trove
   password = TROVE_PASS
   ```

4. 编辑``trove-taskmanager.conf``文件，像下面展示的那样，设置其连接到OpenStack计算服务：

   ```
   [DEFAULT]
   ...
   # Configuration options for talking to nova via the novaclient.
   # These options are for an admin user in your keystone config.
   # It proxy's the token received from the user to send to nova
   # via this admin users creds,
   # basically acting like the client via that proxy token.
   nova_proxy_admin_user = admin
   nova_proxy_admin_pass = ADMIN_PASS
   nova_proxy_admin_tenant_name = service
   taskmanager_manager = trove.taskmanager.manager.Manager
   ```

5. 编辑``/etc/trove/trove-guestagent.conf``文件，让之后的trove的guests能够连接到你的OpenStack环境：

   ```
   rabbit_host = controller
   rabbit_password = RABBIT_PASS
   nova_proxy_admin_user = admin
   nova_proxy_admin_pass = ADMIN_PASS
   nova_proxy_admin_tenant_name = service
   trove_auth_url = http://controller:35357/v2.0
   ```

6. 同步你之前创建的trove数据库：

   ```
   # su -s /bin/sh -c "trove-manage db_sync" trove
     ...
     2016-04-06 22:00:17.771 10706 INFO trove.db.sqlalchemy.migration [-]
     Upgrading mysql://trove:dbaasdb@controller/trove to version latest
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/trove-install.html#finalize-installation)

1. 启动数据库服务并配置随系统启动：

   ```
   # systemctl enable openstack-trove-api.service \
     openstack-trove-taskmanager.service \
     openstack-trove-conductor.service
   
   # systemctl start openstack-trove-api.service \
     openstack-trove-taskmanager.service \
     openstack-trove-conductor.service
   ```

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



验证数据库服务的安装。



 

注解



在你安装trove的节点上执行以下命令。

1. source 租户``admin`的凭证脚本：

   ```
   $ source admin-openrc.sh
   ```

2. 执行``trove list``命令。你可以看到类似于下面的输出：

   ```
   $ trove list
   +----+------+-----------+-------------------+--------+-----------+------+
   | id | name | datastore | datastore_version | status | flavor_id | size |
   +----+------+-----------+-------------------+--------+-----------+------+
   +----+------+-----------+-------------------+--------+-----------+------+
   ```

3. 增加一个数据库到trove：

   - - [Create a trove image](http://docs.openstack.org/developer/trove/dev/building_guest_images.html)。

       为您要使用的类型的数据库创建一个镜像，例如，MySQL、MongoDB、Cassandra。 这个镜像必须安装trove guest agent

   - 上传镜像到glance。例如：

     ```
     $ glance image-create --name "mysqlTest" --disk-format qcow2 \
       --container-format bare \
       --file mysql-5.6.qcow2
     +------------------+--------------------------------------+
     | Property         | Value                                |
     +------------------+--------------------------------------+
     | checksum         | 51a8e6e5ff10b08f2c2ec2953f0a8086     |
     | container_format | bare                                 |
     | created_at       | 2016-04-08T15:15:41Z                 |
     | disk_format      | qcow2                                |
     | id               | 5caa76dd-f44b-4d01-a3b4-a111e27896be |
     | min_disk         | 0                                    |
     | min_ram          | 0                                    |
     | name             | mysqlTest                            |
     | owner            | 0c0bd5e850c24893b48c4cc01e2a7986     |
     | protected        | False                                |
     | size             | 533790720                            |
     | status           | active                               |
     | tags             | []                                   |
     | updated_at       | 2016-04-08T15:15:51Z                 |
     | virtual_size     | None                                 |
     | visibility       | private                              |
     +------------------+--------------------------------------+
     ```

   - 创建一个数据库。你需要为你想使用的每一种数据库单独创建一个数据数据存储。例如，MySQL, MongoDB, Cassandra。下面的例子向你展示如何为MySQL数据库创建一个数据存储：

     ```
     # su -s /bin/sh -c "trove-manage \
       --config-file /etc/trove/trove.conf \
       datastore_update mysql ''" trove
     ...
     Datastore 'mysql' updated.
     ```

4. 使用新的镜像更新数据库

   该实例展示给你如何更新MySQL 5.6数据库：

   ```
   # su -s /bin/sh -c "trove-manage --config-file /etc/trove/trove.conf \
     datastore_version_update \
     mysql mysql-5.6 mysql glance_image_ID '' 1" trove
   ...
   Datastore version 'mysql-5.6' updated.
   ```

5. 创建数据库实例 <http://docs.openstack.org/user-guide/create-db.html>`_.

## 下一步

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



你的OpenStack环境现在已经包含了数据库服务：

## 启动一个实例

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建虚拟网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#create-virtual-networks)
  - [创建m1.nano规格的主机](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#create-m1-nano-flavor)
  - [生成一个键值对](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#generate-a-key-pair)
  - [增加安全组规则](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#add-security-group-rules)
  - [启动一个实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#id1)
  - [块设备存储](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#block-storage)
  - [编排](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#orchestration)
  - [共享文件系统](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#shared-file-systems)



这部分创建了必要的虚拟网络来支持创建实例。网络选项1包含一个使用公共虚拟网络（外部网络）的实例。网络选项2包含一个使用公共虚拟网络的实例、一个使用私有虚拟网络（私有网络）的实例。这部分教程在控制节点上使用命令行(CLI)工具。CLI工具的更多信息，参考 [OpenStack 用户手册](http://docs.openstack.org/user-guide/cli-launch-instances.html)。使用控制台，参考`OpenStack用户手册 <http://docs.openstack.org/user-guide/dashboard.html>`__.



## 创建虚拟网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#create-virtual-networks)

根据你在网络选项中的选择来创建虚拟网络。如果你选择选项1，只需创建一个公有网络。如果你选择选项2，同时创建一个公有网络和一个私有网络

- [提供者网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html)
- [私有网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html)

在你完成自己环境中合适网络的创建后，你可以继续后面的步骤来准备创建实例。

## 创建m1.nano规格的主机[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#create-m1-nano-flavor)

默认的最小规格的主机需要512 MB内存。对于环境中计算节点内存不足4 GB的，我们推荐创建只需要64 MB的``m1.nano``规格的主机。若单纯为了测试的目的，请使用``m1.nano``规格的主机来加载CirrOS镜像

```
$ openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
+----------------------------+---------+
| Field                      | Value   |
+----------------------------+---------+
| OS-FLV-DISABLED:disabled   | False   |
| OS-FLV-EXT-DATA:ephemeral  | 0       |
| disk                       | 1       |
| id                         | 0       |
| name                       | m1.nano |
| os-flavor-access:is_public | True    |
| ram                        | 64      |
| rxtx_factor                | 1.0     |
| swap                       |         |
| vcpus                      | 1       |
+----------------------------+---------+
```

## 生成一个键值对[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#generate-a-key-pair)

大部分云镜像支持公共密钥认证而不是传统的密码认证。在启动实例前，你必须添加一个公共密钥到计算服务。

1. 导入租户``demo``的凭证

   ```
   $ . demo-openrc
   ```

2. 生成和添加秘钥对：

   ```
   $ ssh-keygen -q -N ""
   $ openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
   +-------------+-------------------------------------------------+
   | Field       | Value                                           |
   +-------------+-------------------------------------------------+
   | fingerprint | ee:3d:2e:97:d4:e2:6a:54:6d:0d:ce:43:39:2c:ba:4d |
   | name        | mykey                                           |
   | user_id     | 58126687cbcc4888bfa9ab73a2256f27                |
   +-------------+-------------------------------------------------+
   ```

   

    

   注解

   

   另外，你可以跳过执行 `ssh-keygen` 命令而使用已存在的公钥。

3. 验证公钥的添加：

   ```
   $ openstack keypair list
   +-------+-------------------------------------------------+
   | Name  | Fingerprint                                     |
   +-------+-------------------------------------------------+
   | mykey | ee:3d:2e:97:d4:e2:6a:54:6d:0d:ce:43:39:2c:ba:4d |
   +-------+-------------------------------------------------+
   ```

## 增加安全组规则[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#add-security-group-rules)

默认情况下， [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#id1)default``安全组适用于所有实例并且包括拒绝远程访问实例的防火墙规则。对诸如CirrOS这样的Linux镜像，我们推荐至少允许ICMP (ping) 和安全shell(SSH)规则。

- 添加规则到 `default` 安全组。

  - 允许 [*ICMP*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-icmp) (ping)：

    ```
    $ openstack security group rule create --proto icmp default
    +-----------------------+--------------------------------------+
    | Field                 | Value                                |
    +-----------------------+--------------------------------------+
    | id                    | a1876c06-7f30-4a67-a324-b6b5d1309546 |
    | ip_protocol           | icmp                                 |
    | ip_range              | 0.0.0.0/0                            |
    | parent_group_id       | b0d53786-5ebb-4729-9e4a-4b675016a958 |
    | port_range            |                                      |
    | remote_security_group |                                      |
    +-----------------------+--------------------------------------+
    ```

  - 允许安全 shell (SSH) 的访问：

    ```
    $ openstack security group rule create --proto tcp --dst-port 22 default
    +-----------------------+--------------------------------------+
    | Field                 | Value                                |
    +-----------------------+--------------------------------------+
    | id                    | 3d95e59c-e98d-45f1-af04-c750af914f14 |
    | ip_protocol           | tcp                                  |
    | ip_range              | 0.0.0.0/0                            |
    | parent_group_id       | b0d53786-5ebb-4729-9e4a-4b675016a958 |
    | port_range            | 22:22                                |
    | remote_security_group |                                      |
    +-----------------------+--------------------------------------+
    ```

## 启动一个实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#id1)

如果选择网络选项1，你只能在公网创建实例。如果选择网络选项2，你可以在公网或私网创建实例。

- [在公有网络上创建实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html)
- [在私有网络上创建实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html)



## 块设备存储[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#block-storage)

如果你的环境包含块存储服务，你可以创建一个卷并连接到一个实例上。

- [块设备存储](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html)

## 编排[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#orchestration)

如果你的环境包括云编排服务，你可以创建一个栈来自动化创建一个实例。

- [编排](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html)

## 共享文件系统[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#shared-file-systems)

如果你的环境包括文件共享服务，你可以创建一个共享点，并且挂载到一个实例上：

- [共享文件系统](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html)

## 提供者网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建提供者网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html#create-the-provider-network)



在启动实例之前，您必须创建必须的虚拟机网络设施。对于网络选项1，实例使用提供者（外部）网络，提供者网络通过L2（桥/交换机）设备连接到物理网络。这个网络包括为实例提供IP地址的DHCP服务器。

[``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html#id1)admin``或者其他权限用户必须创建这个网络，因为它直接连接到物理网络设施。



 

注解



下面的说明和框图使用示例IP 地址范围。你必须依据你的实际环境修改它们。

![Networking Option 1: Provider networks - Overview](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network1-overview.png)

**网络选项1：提供者网络-概述**

![Networking Option 1: Provider networks - Connectivity](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network1-connectivity.png)

**网络选项1: 提供者网络-连接性**

## 创建提供者网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html#create-the-provider-network)

1. 在控制节点上，加载 `admin` 凭证来获取管理员能执行的命令访问权限：

   ```
   $ . admin-openrc
   ```

2. 创建网络：

   ```
   $ neutron net-create --shared --provider:physical_network provider \
     --provider:network_type flat provider
   Created a new network:
   +---------------------------+--------------------------------------+
   | Field                     | Value                                |
   +---------------------------+--------------------------------------+
   | admin_state_up            | True                                 |
   | id                        | 0e62efcd-8cee-46c7-b163-d8df05c3c5ad |
   | mtu                       | 1500                                 |
   | name                      | provider                             |
   | port_security_enabled     | True                                 |
   | provider:network_type     | flat                                 |
   | provider:physical_network | provider                             |
   | provider:segmentation_id  |                                      |
   | router:external           | False                                |
   | shared                    | True                                 |
   | status                    | ACTIVE                               |
   | subnets                   |                                      |
   | tenant_id                 | d84313397390425c8ed50b2f6e18d092     |
   +---------------------------+--------------------------------------+
   ```

   [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html#id1)–shared``选项允许所有项目使用虚拟网络。

   The `--provider:physical_network provider` and `--provider:network_type flat` options connect the flat virtual network to the flat (native/untagged) physical network on the `eth1` interface on the host using information from the following files:

   `ml2_conf.ini`:

   ```
   [ml2_type_flat]
   flat_networks = provider
   ```

   `linuxbridge_agent.ini`:

   ```
   [linux_bridge]
   physical_interface_mappings = provider:eth1
   ```

3. 在网络上创建一个子网：

   ```
   $ neutron subnet-create --name provider \
     --allocation-pool start=START_IP_ADDRESS,end=END_IP_ADDRESS \
     --dns-nameserver DNS_RESOLVER --gateway PROVIDER_NETWORK_GATEWAY \
     provider PROVIDER_NETWORK_CIDR
   ```

   使用提供者物理网络的子网CIDR标记替换``PROVIDER_NETWORK_CIDR``。

   将``START_IP_ADDRESS``和``END_IP_ADDRESS``使用你想分配给实例的子网网段的第一个和最后一个IP地址。这个范围不能包括任何已经使用的IP地址。

   将 `DNS_RESOLVER` 替换为DNS解析服务的IP地址。在大多数情况下，你可以从主机``/etc/resolv.conf`` 文件选择一个使用。

   将``PUBLIC_NETWORK_GATEWAY`` 替换为公共网络的网关，一般的网关IP地址以 ”.1” 结尾。

   **例子**

   公共网络203.0.113.0/24的网关为203.0.113.1。DHCP服务为每个实例分配IP，IP从203.0.113.101 到 203.0.113.200。所有实例的DNS使用8.8.4.4。

   ```
   $ neutron subnet-create --name provider \
     --allocation-pool start=203.0.113.101,end=203.0.113.250 \
     --dns-nameserver 8.8.4.4 --gateway 203.0.113.1 \
     provider 203.0.113.0/24
   Created a new subnet:
   +-------------------+----------------------------------------------------+
   | Field             | Value                                              |
   +-------------------+----------------------------------------------------+
   | allocation_pools  | {"start": "203.0.113.101", "end": "203.0.113.250"} |
   | cidr              | 203.0.113.0/24                                     |
   | dns_nameservers   | 8.8.4.4                                            |
   | enable_dhcp       | True                                               |
   | gateway_ip        | 203.0.113.1                                        |
   | host_routes       |                                                    |
   | id                | 5cc70da8-4ee7-4565-be53-b9c011fca011               |
   | ip_version        | 4                                                  |
   | ipv6_address_mode |                                                    |
   | ipv6_ra_mode      |                                                    |
   | name              | provider                                           |
   | network_id        | 0e62efcd-8cee-46c7-b163-d8df05c3c5ad               |
   | subnetpool_id     |                                                    |
   | tenant_id         | d84313397390425c8ed50b2f6e18d092                   |
   +-------------------+----------------------------------------------------+
   ```

跳转到 [:链接:`创建实例 - 创建虚拟网络 <创建网络实例>`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-provider.html#id1)。

​                      

## 私有网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建自服务网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#create-the-self-service-network)
  - [创建路由](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#create-a-router)
  - [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#verify-operation)



如果你选择网络选项2，你还可以创建一个私有网络通过NAT连接到物理网络设施。这个网络包括一个DHCP服务器为实例分配IP地址。在这个网络上的实例可以自动连接到外部网络如互联网。不过，从互联网这样的外部网络访问实例需要配置 :浮动IP。

`demo` 或者其他非管理员用户也可以创建这个网络，因为它只在 [`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#id1)demo``项目中提供对实例的访问。



 

警告



在创建私有项目网络前，你必须 :完成<创建公共网络实例>选项卡中的创建公有网络provider 。



 

注解



下面的说明和框图使用示例IP 地址范围。你必须依据你的实际环境修改它们。

![Networking Option 2: Self-service networks - Overview](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network2-overview.png)

**网络选项2：自服务网络-概述**

![Networking Option 2: Self-service networks - Connectivity](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network2-connectivity.png)

**网络选项2：自服务网络-连接**

## 创建自服务网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#create-the-self-service-network)

1. 在控制节点上，获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . demo-openrc
   ```

2. 创建网络：

   ```
   $ neutron net-create selfservice
   Created a new network:
   +-----------------------+--------------------------------------+
   | Field                 | Value                                |
   +-----------------------+--------------------------------------+
   | admin_state_up        | True                                 |
   | id                    | 7c6f9b37-76b4-463e-98d8-27e5686ed083 |
   | mtu                   | 0                                    |
   | name                  | selfservice                          |
   | port_security_enabled | True                                 |
   | router:external       | False                                |
   | shared                | False                                |
   | status                | ACTIVE                               |
   | subnets               |                                      |
   | tenant_id             | f5b2ccaa75ac413591f12fcaa096aa5c     |
   +-----------------------+--------------------------------------+
   ```

   非特权用户一般不能在这个命令制定更多参数。服务会自动从下面的文件中的信息选择参数：

   `ml2_conf.ini`:

   ```
   [ml2]
   tenant_network_types = vxlan
   
   [ml2_type_vxlan]
   vni_ranges = 1:1000
   ```

3. 在网络上创建一个子网：

   ```
   $ neutron subnet-create --name selfservice \
     --dns-nameserver DNS_RESOLVER --gateway SELFSERVICE_NETWORK_GATEWAY \
     selfservice SELFSERVICE_NETWORK_CIDR
   ```

   将 `DNS_RESOLVER` 替换为DNS解析服务的IP地址。在大多数情况下，你可以从主机``/etc/resolv.conf`` 文件选择一个使用。

   将``PRIVATE_NETWORK_GATEWAY`` 替换为私有网络的网关，网关IP形如 ”.1”。

   将 `PRIVATE_NETWORK_CIDR` 替换为私有网络的子网。你可以使用任意值，但是我们推荐遵从`RFC 1918 <https://tools.ietf.org/html/rfc1918>`_的网络。

   **例子**

   自服务网络使用172.16.1.0/24 网关172.16.1.1。DHCP服务负责为每个实例从172.16.1.2 到172.16.1.254中分配IP地址。所有实例使用8.8.4.4作为DNS。

   ```
   $ neutron subnet-create --name selfservice \
     --dns-nameserver 8.8.4.4 --gateway 172.16.1.1 \
     selfservice 172.16.1.0/24
   Created a new subnet:
   +-------------------+------------------------------------------------+
   | Field             | Value                                          |
   +-------------------+------------------------------------------------+
   | allocation_pools  | {"start": "172.16.1.2", "end": "172.16.1.254"} |
   | cidr              | 172.16.1.0/24                                  |
   | dns_nameservers   | 8.8.4.4                                        |
   | enable_dhcp       | True                                           |
   | gateway_ip        | 172.16.1.1                                     |
   | host_routes       |                                                |
   | id                | 3482f524-8bff-4871-80d4-5774c2730728           |
   | ip_version        | 4                                              |
   | ipv6_address_mode |                                                |
   | ipv6_ra_mode      |                                                |
   | name              | selfservice                                    |
   | network_id        | 7c6f9b37-76b4-463e-98d8-27e5686ed083           |
   | subnetpool_id     |                                                |
   | tenant_id         | f5b2ccaa75ac413591f12fcaa096aa5c               |
   +-------------------+------------------------------------------------+
   ```

## 创建路由[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#create-a-router)

私有网络通过虚拟路由来连接到公有网络，以双向NAT最为典型。每个路由包含至少一个连接到私有网络的接口以及一个连接到公有网络的网关的接口

公有提供网络必须包括 `router: external``选项，用来使路由连接到外部网络，比如互联网。``admin``或者其他权限用户在网络创建时必须包括这个选项，也可以之后在添加。在这个环境里，我们把``public``公有网络设置成 ``router: external`。

1. 在控制节点上，加载 `admin` 凭证来获取管理员能执行的命令访问权限：

   ```
   $ . admin-openrc
   ```

2. 添加’ router:external ‘ 到’ provider’ 网络

   ```
   $ neutron net-update provider --router:external
   Updated network: provider
   ```

3. 加载 `demo` 证书获得用户能执行的命令访问权限：

   ```
   $ . demo-openrc
   ```

4. 创建路由：

   ```
   $ neutron router-create router
   Created a new router:
   +-----------------------+--------------------------------------+
   | Field                 | Value                                |
   +-----------------------+--------------------------------------+
   | admin_state_up        | True                                 |
   | external_gateway_info |                                      |
   | id                    | 89dd2083-a160-4d75-ab3a-14239f01ea0b |
   | name                  | router                               |
   | routes                |                                      |
   | status                | ACTIVE                               |
   | tenant_id             | f5b2ccaa75ac413591f12fcaa096aa5c     |
   +-----------------------+--------------------------------------+
   ```

5. 给路由器添加一个私网子网的接口：

   ```
   $ neutron router-interface-add router selfservice
   Added interface bff6605d-824c-41f9-b744-21d128fc86e1 to router router.
   ```

6. 给路由器设置公有网络的网关：

   ```
   $ neutron router-gateway-set router provider
   Set gateway for router router
   ```

## 验证操作[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#verify-operation)

我们推荐您在操作之前，确认并修复问题。以下步骤将使用网络和子网创建示例中的IP地址。

1. 在控制节点上，加载 `admin` 凭证来获取管理员能执行的命令访问权限：

   ```
   $ . admin-openrc
   ```

2. 列出网络命名空间。你应该可以看到一个’ qrouter ‘命名空间和两个’qdhcp ‘ 命名空间

   ```
   $ ip netns
   qrouter-89dd2083-a160-4d75-ab3a-14239f01ea0b
   qdhcp-7c6f9b37-76b4-463e-98d8-27e5686ed083
   qdhcp-0e62efcd-8cee-46c7-b163-d8df05c3c5ad
   ```

3. 列出路由器上的端口来确定公网网关的IP 地址：

   ```
   $ neutron router-port-list router
   +--------------------------------------+------+-------------------+------------------------------------------+
   | id                                   | name | mac_address       | fixed_ips                                |
   +--------------------------------------+------+-------------------+------------------------------------------+
   | bff6605d-824c-41f9-b744-21d128fc86e1 |      | fa:16:3e:2f:34:9b | {"subnet_id":                            |
   |                                      |      |                   | "3482f524-8bff-4871-80d4-5774c2730728",  |
   |                                      |      |                   | "ip_address": "172.16.1.1"}              |
   | d6fe98db-ae01-42b0-a860-37b1661f5950 |      | fa:16:3e:e8:c1:41 | {"subnet_id":                            |
   |                                      |      |                   | "5cc70da8-4ee7-4565-be53-b9c011fca011",  |
   |                                      |      |                   | "ip_address": "203.0.113.102"}           |
   +--------------------------------------+------+-------------------+------------------------------------------+
   ```

4. 从控制节点或任意公共物理网络上的节点Ping这个IP地址：

   ```
   $ ping -c 4 203.0.113.102
   PING 203.0.113.102 (203.0.113.102) 56(84) bytes of data.
   64 bytes from 203.0.113.102: icmp_req=1 ttl=64 time=0.619 ms
   64 bytes from 203.0.113.102: icmp_req=2 ttl=64 time=0.189 ms
   64 bytes from 203.0.113.102: icmp_req=3 ttl=64 time=0.165 ms
   64 bytes from 203.0.113.102: icmp_req=4 ttl=64 time=0.216 ms
   
   --- 203.0.113.102 ping statistics ---
   rtt min/avg/max/mdev = 0.165/0.297/0.619/0.187 ms
   ```

跳转到 [:链接:`创建实例 - 创建虚拟网络 <创建网络实例>`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-networks-selfservice.html#id1)。

​                      

## 在公有网络上创建实例

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [确定实例选项](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#determine-instance-options)
  - [创建实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#launch-the-instance)
  - [使用虚拟控制台访问实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#access-the-instance-using-the-virtual-console)
  - [验证能否远程访问实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#access-the-instance-remotely)



## 确定实例选项[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#determine-instance-options)

启动一台实例，您必须至少指定一个类型、镜像名称、网络、安全组、密钥和实例名称。

1. 在控制节点上，获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . demo-openrc
   ```

2. 一个实例指定了虚拟机资源的大致分配，包括处理器、内存和存储。

   列出可用类型：

   ```
   $ openstack flavor list
   +----+-----------+-------+------+-----------+-------+-----------+
   | ID | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
   +----+-----------+-------+------+-----------+-------+-----------+
   | 1  | m1.tiny   |   512 |    1 |         0 |     1 | True      |
   | 2  | m1.small  |  2048 |   20 |         0 |     1 | True      |
   | 3  | m1.medium |  4096 |   40 |         0 |     2 | True      |
   | 4  | m1.large  |  8192 |   80 |         0 |     4 | True      |
   | 5  | m1.xlarge | 16384 |  160 |         0 |     8 | True      |
   +----+-----------+-------+------+-----------+-------+-----------+
   ```

   这个实例使用``m1.tiny``规格的主机。如果你创建了``m1.nano``这种主机规格，使用``m1.nano``来代替``m1.tiny``。

   

    

   注解

   

   您也可以以 ID 引用类型。

3. 列出可用镜像：

   ```
   $ openstack image list
   +--------------------------------------+--------+--------+
   | ID                                   | Name   | Status |
   +--------------------------------------+--------+--------+
   | 390eb5f7-8d49-41ec-95b7-68c0d5d54b34 | cirros | active |
   +--------------------------------------+--------+--------+
   ```

   这个实例使用``cirros``镜像。

4. 列出可用网络：

   ```
   $ openstack network list
   +--------------------------------------+--------------+--------------------------------------+
   | ID                                   | Name         | Subnets                              |
   +--------------------------------------+--------------+--------------------------------------+
   | 4716ddfe-6e60-40e7-b2a8-42e57bf3c31c | selfservice  | 2112d5eb-f9d6-45fd-906e-7cabd38b7c7c |
   | b5b6993c-ddf9-40e7-91d0-86806a42edb8 | provider     | 310911f6-acf0-4a47-824e-3032916582ff |
   +--------------------------------------+--------------+--------------------------------------+
   ```

   这个实例使用 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#id1)provider``公有网络。 你必须使用ID而不是名称才可以使用这个网络。

   

    

   注解

   

   如果你选择选项2，输出信息应该也包含私网``selfservice``的信息。

5. 列出可用的安全组：

   ```
   $ openstack security group list
   +--------------------------------------+---------+------------------------+
   | ID                                   | Name    | Description            |
   +--------------------------------------+---------+------------------------+
   | dd2b614c-3dad-48ed-958b-b155a3b38515 | default | Default security group |
   +--------------------------------------+---------+------------------------+
   ```

   这个实例使用 `default` 安全组。

## 创建实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#launch-the-instance)

1. 启动实例：

   使用``provider``公有网络的ID替换``PUBLIC_NET_ID``。

   

    

   注解

   

   如果你选择选项1并且你的环境只有一个网络，你可以省去``–nic`` 选项因为OpenStack会自动选择这个唯一可用的网络。

   ```
   $ openstack server create --flavor m1.tiny --image cirros \
     --nic net-id=PROVIDER_NET_ID --security-group default \
     --key-name mykey provider-instance
   
   +--------------------------------------+-----------------------------------------------+
   | Property                             | Value                                         |
   +--------------------------------------+-----------------------------------------------+
   | OS-DCF:diskConfig                    | MANUAL                                        |
   | OS-EXT-AZ:availability_zone          | nova                                          |
   | OS-EXT-STS:power_state               | 0                                             |
   | OS-EXT-STS:task_state                | scheduling                                    |
   | OS-EXT-STS:vm_state                  | building                                      |
   | OS-SRV-USG:launched_at               | -                                             |
   | OS-SRV-USG:terminated_at             | -                                             |
   | accessIPv4                           |                                               |
   | accessIPv6                           |                                               |
   | adminPass                            | hdF4LMQqC5PB                                  |
   | config_drive                         |                                               |
   | created                              | 2015-09-17T21:58:18Z                          |
   | flavor                               | m1.tiny (1)                                   |
   | hostId                               |                                               |
   | id                                   | 181c52ba-aebc-4c32-a97d-2e8e82e4eaaf          |
   | image                                | cirros (38047887-61a7-41ea-9b49-27987d5e8bb9) |
   | key_name                             | mykey                                         |
   | metadata                             | {}                                            |
   | name                                 | provider-instance                             |
   | os-extended-volumes:volumes_attached | []                                            |
   | progress                             | 0                                             |
   | security_groups                      | default                                       |
   | status                               | BUILD                                         |
   | tenant_id                            | f5b2ccaa75ac413591f12fcaa096aa5c              |
   | updated                              | 2015-09-17T21:58:18Z                          |
   | user_id                              | 684286a9079845359882afc3aa5011fb              |
   +--------------------------------------+-----------------------------------------------+
   ```

2. 检查实例的状态：

   ```
   $ openstack server list
   +--------------------------------------+-------------------+--------+---------------------------------+
   | ID                                   | Name              | Status | Networks                        |
   +--------------------------------------+-------------------+--------+---------------------------------+
   | 181c52ba-aebc-4c32-a97d-2e8e82e4eaaf | provider-instance | ACTIVE | provider=203.0.113.103 |
   +--------------------------------------+-------------------+--------+---------------------------------+
   ```

   当构建过程完全成功后，状态会从 `BUILD``变为``ACTIVE`。

## 使用虚拟控制台访问实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#access-the-instance-using-the-virtual-console)

1. 获取你实例的 [*Virtual Network Computing (VNC)*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-virtual-network-computing-vnc) 会话URL并从web浏览器访问它：

   ```
   $ openstack console url show provider-instance
   +-------+---------------------------------------------------------------------------------+
   | Field | Value                                                                           |
   +-------+---------------------------------------------------------------------------------+
   | type  | novnc                                                                           |
   | url   | http://controller:6080/vnc_auto.html?token=5eeccb47-525c-4918-ac2a-3ad1e9f1f493 |
   +-------+---------------------------------------------------------------------------------+
   ```

   

    

   注解

   

   如果你运行浏览器的主机无法解析``controller`` 主机名，你可以将 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#id1)controller``替换为你控制节点管理网络的IP地址。

   CirrOS 镜像包含传统的用户名/密码认证方式并需在登录提示中提供这些这些认证。登录到 CirrOS 后，我们建议您验证使用``ping``验证网络的连通性。

2. 验证能否ping通公有网络的网关：

   ```
   $ ping -c 4 203.0.113.1
   PING 203.0.113.1 (203.0.113.1) 56(84) bytes of data.
   64 bytes from 203.0.113.1: icmp_req=1 ttl=64 time=0.357 ms
   64 bytes from 203.0.113.1: icmp_req=2 ttl=64 time=0.473 ms
   64 bytes from 203.0.113.1: icmp_req=3 ttl=64 time=0.504 ms
   64 bytes from 203.0.113.1: icmp_req=4 ttl=64 time=0.470 ms
   
   --- 203.0.113.1 ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 2998ms
   rtt min/avg/max/mdev = 0.357/0.451/0.504/0.055 ms
   ```

3. 验证能否连接到互联网

   ```
   $ ping -c 4 openstack.org
   PING openstack.org (174.143.194.225) 56(84) bytes of data.
   64 bytes from 174.143.194.225: icmp_req=1 ttl=53 time=17.4 ms
   64 bytes from 174.143.194.225: icmp_req=2 ttl=53 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_req=3 ttl=53 time=17.7 ms
   64 bytes from 174.143.194.225: icmp_req=4 ttl=53 time=17.5 ms
   
   --- openstack.org ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3003ms
   rtt min/avg/max/mdev = 17.431/17.575/17.734/0.143 ms
   ```

## 验证能否远程访问实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-provider.html#access-the-instance-remotely)

1. 验证控制节点或者其他公有网络上的主机能否ping通实例：

   ```
   $ ping -c 4 203.0.113.103
   PING 203.0.113.103 (203.0.113.103) 56(84) bytes of data.
   64 bytes from 203.0.113.103: icmp_req=1 ttl=63 time=3.18 ms
   64 bytes from 203.0.113.103: icmp_req=2 ttl=63 time=0.981 ms
   64 bytes from 203.0.113.103: icmp_req=3 ttl=63 time=1.06 ms
   64 bytes from 203.0.113.103: icmp_req=4 ttl=63 time=0.929 ms
   
   --- 203.0.113.103 ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3002ms
   rtt min/avg/max/mdev = 0.929/1.539/3.183/0.951 ms
   ```

2. 在控制节点或其他公有网络上的主机使用 SSH远程访问实例：

   ```
   $ ssh cirros@203.0.113.103
   The authenticity of host '203.0.113.102 (203.0.113.102)' can't be established.
   RSA key fingerprint is ed:05:e9:e7:52:a0:ff:83:68:94:c7:d1:f2:f8:e2:e9.
   Are you sure you want to continue connecting (yes/no)? yes
   Warning: Permanently added '203.0.113.102' (RSA) to the list of known hosts.
   $
   ```

如果你的实例无法启动或者没有像你希望的那样正常工作，参考OpenStack Operations Guide下` Instance Boot Failures<http://docs.openstack.org/ops-guide/ops-maintenance-compute.html#instances>`章节获取更多信息或者使用 [*many other options*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/app_support.html) 来寻找帮助。我们希望你第一次安装就可以正常工作！

返回 [*Launch an instance*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#launch-instance-complete)。

​                      

## 在私有网络上创建实例

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [确定实例选项](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#determine-instance-options)
  - [使用虚拟控制台访问实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#access-the-instance-using-a-virtual-console)
  - [验证能否远程访问实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#access-the-instance-remotely)



## 确定实例选项[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#determine-instance-options)

启动一台实例，您必须至少指定一个类型、镜像名称、网络、安全组、密钥和实例名称。

1. 在控制节点上，获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```
   $ . demo-openrc
   ```

2. 一个实例指定了虚拟机资源的大致分配，包括处理器、内存和存储。

   列出可用类型：

   ```
   $ openstack flavor list
   +----+-----------+-------+------+-----------+-------+-----------+
   | ID | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
   +----+-----------+-------+------+-----------+-------+-----------+
   | 1  | m1.tiny   |   512 |    1 |         0 |     1 | True      |
   | 2  | m1.small  |  2048 |   20 |         0 |     1 | True      |
   | 3  | m1.medium |  4096 |   40 |         0 |     2 | True      |
   | 4  | m1.large  |  8192 |   80 |         0 |     4 | True      |
   | 5  | m1.xlarge | 16384 |  160 |         0 |     8 | True      |
   +----+-----------+-------+------+-----------+-------+-----------+
   ```

   这个实例使用``m1.tiny``规格的主机。如果你创建了``m1.nano``这种主机规格，使用``m1.nano``来代替``m1.tiny``。

   

    

   注解

   

   您也可以以 ID 引用类型。

3. 列出可用镜像：

   ```
   $ openstack image list
   +--------------------------------------+--------+--------+
   | ID                                   | Name   | Status |
   +--------------------------------------+--------+--------+
   | 390eb5f7-8d49-41ec-95b7-68c0d5d54b34 | cirros | active |
   +--------------------------------------+--------+--------+
   ```

   这个实例使用``cirros``镜像。

4. 列出可用网络：

   ```
   $ openstack network list
   +--------------------------------------+-------------+--------------------------------------+
   | ID                                   | Name        | Subnets                              |
   +--------------------------------------+-------------+--------------------------------------+
   | 4716ddfe-6e60-40e7-b2a8-42e57bf3c31c | selfservice | 2112d5eb-f9d6-45fd-906e-7cabd38b7c7c |
   | b5b6993c-ddf9-40e7-91d0-86806a42edb8 | provider    | 310911f6-acf0-4a47-824e-3032916582ff |
   +--------------------------------------+-------------+--------------------------------------+
   ```

   这个实例使用 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#id1)self-service``私有网络。 你必须使用ID而不是名称才可以使用这个网络。

5. 列出可用的安全组：

   ```
   $ openstack security group list
   +--------------------------------------+---------+------------------------+
   | ID                                   | Name    | Description            |
   +--------------------------------------+---------+------------------------+
   | dd2b614c-3dad-48ed-958b-b155a3b38515 | default | Default security group |
   +--------------------------------------+---------+------------------------+
   ```

   这个实例使用 `default` 安全组。

6. 启动实例：

   使用``selfservice [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#id1)网络的ID替换``SELFSERVICE_NET_ID [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#id3)。

   ```
   $ openstack server create --flavor m1.tiny --image cirros \
     --nic net-id=SELFSERVICE_NET_ID --security-group default \
     --key-name mykey selfservice-instance
   +--------------------------------------+---------------------------------------+
   | Field                                | Value                                 |
   +--------------------------------------+---------------------------------------+
   | OS-DCF:diskConfig                    | MANUAL                                |
   | OS-EXT-AZ:availability_zone          |                                       |
   | OS-EXT-STS:power_state               | 0                                     |
   | OS-EXT-STS:task_state                | scheduling                            |
   | OS-EXT-STS:vm_state                  | building                              |
   | OS-SRV-USG:launched_at               | None                                  |
   | OS-SRV-USG:terminated_at             | None                                  |
   | accessIPv4                           |                                       |
   | accessIPv6                           |                                       |
   | addresses                            |                                       |
   | adminPass                            | 7KTBYHSjEz7E                          |
   | config_drive                         |                                       |
   | created                              | 2016-02-26T14:52:37Z                  |
   | flavor                               | m1.tiny (1)                           |
   | hostId                               |                                       |
   | id                                   | 113c5892-e58e-4093-88c7-e33f502eaaa4  |
   | image                                | cirros (390eb5f7-8d49-41ec-95b7-68c0d |
   |                                      | 5d54b34)                              |
   | key_name                             | mykey                                 |
   | name                                 | selfservice-instance                  |
   | os-extended-volumes:volumes_attached | []                                    |
   | progress                             | 0                                     |
   | project_id                           | ed0b60bf607743088218b0a533d5943f      |
   | properties                           |                                       |
   | security_groups                      | [{u'name': u'default'}]               |
   | status                               | BUILD                                 |
   | updated                              | 2016-02-26T14:52:38Z                  |
   | user_id                              | 58126687cbcc4888bfa9ab73a2256f27      |
   +--------------------------------------+---------------------------------------+
   ```

7. 检查实例的状态：

   ```
   $ openstack server list
   +--------------------------------------+----------------------+--------+---------------------------------+
   | ID                                   | Name                 | Status | Networks                        |
   +--------------------------------------+----------------------+--------+---------------------------------+
   | 113c5892-e58e-4093-88c7-e33f502eaaa4 | selfservice-instance | ACTIVE | selfservice=172.16.1.3 |
   | 181c52ba-aebc-4c32-a97d-2e8e82e4eaaf | provider-instance    | ACTIVE | provider=203.0.113.103 |
   +--------------------------------------+----------------------+--------+---------------------------------+
   ```

   当构建过程完全成功后，状态会从 `BUILD``变为``ACTIVE`。

## 使用虚拟控制台访问实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#access-the-instance-using-a-virtual-console)

1. 获取你实例的 [*Virtual Network Computing (VNC)*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-virtual-network-computing-vnc) 会话URL并从web浏览器访问它：

   ```
   $ openstack console url show selfservice-instance
   +-------+---------------------------------------------------------------------------------+
   | Field | Value                                                                           |
   +-------+---------------------------------------------------------------------------------+
   | type  | novnc                                                                           |
   | url   | http://controller:6080/vnc_auto.html?token=5eeccb47-525c-4918-ac2a-3ad1e9f1f493 |
   +-------+---------------------------------------------------------------------------------+
   ```

   

    

   注解

   

   如果你运行浏览器的主机无法解析``controller`` 主机名，你可以将 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#id1)controller``替换为你控制节点管理网络的IP地址。

   CirrOS 镜像包含传统的用户名/密码认证方式并需在登录提示中提供这些这些认证。登录到 CirrOS 后，我们建议您验证使用``ping``验证网络的连通性。

2. 验证能否ping通私有网络的网关：

   ```
   $ ping -c 4 172.16.1.1
   PING 172.16.1.1 (172.16.1.1) 56(84) bytes of data.
   64 bytes from 172.16.1.1: icmp_req=1 ttl=64 time=0.357 ms
   64 bytes from 172.16.1.1: icmp_req=2 ttl=64 time=0.473 ms
   64 bytes from 172.16.1.1: icmp_req=3 ttl=64 time=0.504 ms
   64 bytes from 172.16.1.1: icmp_req=4 ttl=64 time=0.470 ms
   
   --- 172.16.1.1 ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 2998ms
   rtt min/avg/max/mdev = 0.357/0.451/0.504/0.055 ms
   ```

3. 验证能否连接到互联网

   ```
   $ ping -c 4 openstack.org
   PING openstack.org (174.143.194.225) 56(84) bytes of data.
   64 bytes from 174.143.194.225: icmp_req=1 ttl=53 time=17.4 ms
   64 bytes from 174.143.194.225: icmp_req=2 ttl=53 time=17.5 ms
   64 bytes from 174.143.194.225: icmp_req=3 ttl=53 time=17.7 ms
   64 bytes from 174.143.194.225: icmp_req=4 ttl=53 time=17.5 ms
   
   --- openstack.org ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3003ms
   rtt min/avg/max/mdev = 17.431/17.575/17.734/0.143 ms
   ```

## 验证能否远程访问实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-selfservice.html#access-the-instance-remotely)

1. 在公有网络上创建浮动IP地址池：

   ```
   $ openstack ip floating create provider
   +-------------+--------------------------------------+
   | Field       | Value                                |
   +-------------+--------------------------------------+
   | fixed_ip    | None                                 |
   | id          | 3d05a9b1-b1af-4884-be1c-833a69744449 |
   | instance_id | None                                 |
   | ip          | 203.0.113.104                        |
   | pool        | provider                             |
   +-------------+--------------------------------------+
   ```

2. 为实例分配浮动IP：

   ```
   $ openstack ip floating add 203.0.113.104 selfservice-instance
   ```

   

    

   注解

   

   这个命令执行后没有输出。

3. 检查这个浮动 IP 地址的状态：

   ```
   $ openstack server list
   +--------------------------------------+----------------------+--------+---------------------------------------+
   | ID                                   | Name                 | Status | Networks                              |
   +--------------------------------------+----------------------+--------+---------------------------------------+
   | 113c5892-e58e-4093-88c7-e33f502eaaa4 | selfservice-instance | ACTIVE | selfservice=172.16.1.3, 203.0.113.104 |
   | 181c52ba-aebc-4c32-a97d-2e8e82e4eaaf | provider-instance    | ACTIVE | provider=203.0.113.103                |
   +--------------------------------------+----------------------+--------+---------------------------------------+
   ```

4. 验证控制节点或者其他公有网络上的主机通过浮动IP地址ping通实例：

   ```
   $ ping -c 4 203.0.113.104
   PING 203.0.113.104 (203.0.113.104) 56(84) bytes of data.
   64 bytes from 203.0.113.104: icmp_req=1 ttl=63 time=3.18 ms
   64 bytes from 203.0.113.104: icmp_req=2 ttl=63 time=0.981 ms
   64 bytes from 203.0.113.104: icmp_req=3 ttl=63 time=1.06 ms
   64 bytes from 203.0.113.104: icmp_req=4 ttl=63 time=0.929 ms
   
   --- 203.0.113.104 ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3002ms
   rtt min/avg/max/mdev = 0.929/1.539/3.183/0.951 ms
   ```

5. 在控制节点或其他公有网络上的主机使用 SSH远程访问实例：

   ```
   $ ssh cirros@203.0.113.104
   The authenticity of host '203.0.113.104 (203.0.113.104)' can't be established.
   RSA key fingerprint is ed:05:e9:e7:52:a0:ff:83:68:94:c7:d1:f2:f8:e2:e9.
   Are you sure you want to continue connecting (yes/no)? yes
   Warning: Permanently added '203.0.113.104' (RSA) to the list of known hosts.
   $
   ```

如果你的实例无法启动或者没有像你希望的那样正常工作，参考OpenStack Operations Guide下` Instance Boot Failures<http://docs.openstack.org/ops-guide/ops-maintenance-compute.html#instances>`章节获取更多信息或者使用 [*many other options*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/app_support.html) 来寻找帮助。我们希望你第一次安装就可以正常工作！

返回 [*Launch an instance*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance.html#launch-instance-complete)。

​                      

## 块设备存储

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [新建卷](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#create-a-volume)
  - [附加卷到一个实例上](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#attach-the-volume-to-an-instance)



## 新建卷[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#create-a-volume)

1. 加载 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#id1)demo``证书，作为非管理员项目执行下面的步骤：

   ```
   $ . demo-openrc
   ```

2. 创建一个 1 GB 的卷：

   ```
   $ openstack volume create --size 1 volume1
   +---------------------+--------------------------------------+
   | Field               | Value                                |
   +---------------------+--------------------------------------+
   | attachments         | []                                   |
   | availability_zone   | nova                                 |
   | bootable            | false                                |
   | consistencygroup_id | None                                 |
   | created_at          | 2016-03-08T14:30:48.391027           |
   | description         | None                                 |
   | encrypted           | False                                |
   | id                  | a1e8be72-a395-4a6f-8e07-856a57c39524 |
   | multiattach         | False                                |
   | name                | volume1                              |
   | properties          |                                      |
   | replication_status  | disabled                             |
   | size                | 1                                    |
   | snapshot_id         | None                                 |
   | source_volid        | None                                 |
   | status              | creating                             |
   | type                | None                                 |
   | updated_at          | None                                 |
   | user_id             | 684286a9079845359882afc3aa5011fb     |
   +---------------------+--------------------------------------+
   ```

3. 过会，卷状态应该从``creating`` 变成``available``：

   ```
   $ openstack volume list
   +--------------------------------------+--------------+-----------+------+-------------+
   | ID                                   | Display Name | Status    | Size | Attached to |
   +--------------------------------------+--------------+-----------+------+-------------+
   | a1e8be72-a395-4a6f-8e07-856a57c39524 | volume1      | available |    1 |             |
   +--------------------------------------+--------------+-----------+------+-------------+
   ```

## 附加卷到一个实例上[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#attach-the-volume-to-an-instance)

1. 附加卷到一个实例上：

   ```
   $ openstack server add volume INSTANCE_NAME VOLUME_NAME
   ```

   使用实例名称替换 `INSTANCE_NAME` 并使用你想要附加卷的名称替换``VOLUME_NAME [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html#id1)。

   **例子**

   附加 `volume1 ``卷到 ``provider-instance` 云主机：

   ```
   $ openstack server add volume provider-instance volume1
   ```

   

    

   注解

   

   这个命令执行后没有输出。

2. 列出卷：

   ```
   $ openstack volume list
   +--------------------------------------+--------------+--------+------+--------------------------------------------+
   | ID                                   | Display Name | Status | Size | Attached to                                |
   +--------------------------------------+--------------+--------+------+--------------------------------------------+
   | a1e8be72-a395-4a6f-8e07-856a57c39524 | volume1      | in-use |    1 | Attached to provider-instance on /dev/vdb  |
   +--------------------------------------+--------------+--------+------+--------------------------------------------+
   ```

3. 使用SSH方式访问你的实力，并使用``fdisk`` 命令验证`/dev/vdb`块存储设备作为卷存在。

   ```
    $ sudo fdisk -l
   
    Disk /dev/vda: 1073 MB, 1073741824 bytes
    255 heads, 63 sectors/track, 130 cylinders, total 2097152 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000
   
       Device Boot      Start         End      Blocks   Id  System
   /dev/vda1   *       16065     2088449     1036192+  83  Linux
   
    Disk /dev/vdb: 1073 MB, 1073741824 bytes
    16 heads, 63 sectors/track, 2080 cylinders, total 2097152 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000
   
    Disk /dev/vdb doesn't contain a valid partition table
   ```

   

    

   注解

   

   你必须在设备上创建文件系统并挂载它，才能使用这个卷。

想了解更多关于如何管理卷， 请参考OpenStack终端用户手册里的`Manage volumes  <http://docs.openstack.org/user-guide/common/cli-manage-volumes.html>`__

返回到：ref: launch-instance。

​                                                                                      

updated: 2017-06-12 11:14

[  ![Creative Commons Attribution 3.0 License](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_static/images/docs/license.png) ](https://creativecommons.org/licenses/by/3.0/)

 Except where otherwise noted, this document is licensed under [Creative Commons  Attribution 3.0 License](https://creativecommons.org/licenses/by/3.0/). See all [  OpenStack Legal Documents](http://www.openstack.org/legal).

​                          [ found an error? report a bug](https://bugs.launchpad.net/openstack-i18n/+filebug?field.title=块设备存储 in Installation Guide&field.comment=  This bug tracker is for errors with the documentation, use the following as a template and remove or add fields as you see fit. Convert [ ] into [x] to check boxes: - [ ] This doc is inaccurate in this way: ______ - [ ] This is a doc addition request. - [ ] I have a fix to the document that I can paste below including example: input and output.  If you have a troubleshooting or support issue, use the following  resources:  - Ask OpenStack: http://ask.openstack.org - The mailing list: http://lists.openstack.org - IRC: 'openstack' channel on Freenode ----------------------------------- Release: 0.1 on 2017-06-12 11:14 SHA: 1865f28305fdb1eb6b5e1a434ac7e292c3421513 Source: http://git.openstack.org/cgit/openstack/openstack-manuals/tree/doc/install-guide/source/launch-instance-cinder.rst URL: https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-cinder.html&field.tags=install-guide)              [ questions?](http://ask.openstack.org)            

## 编排

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建一个模板](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html#create-a-template)
  - [创建一个stack](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html#create-a-stack)



## 创建一个模板[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html#create-a-template)

Orchestration服务使用模版来描述栈。想要学习模版语言，参考`Heat developer documentation <http://docs.openstack.org/developer/heat/template_guide/index.html>`__中的`the Template Guide <http://docs.openstack.org/developer/heat/index.html>`__ 。

- 使用下面的内容创建``demo-template.yml``文件：

  ```
  heat_template_version: 2015-10-15
  description: Launch a basic instance with CirrOS image using the
               ``m1.tiny`` flavor, ``mykey`` key,  and one network.
  
  parameters:
    NetID:
      type: string
      description: Network ID to use for the instance.
  
  resources:
    server:
      type: OS::Nova::Server
      properties:
        image: cirros
        flavor: m1.tiny
        key_name: mykey
        networks:
        - network: { get_param: NetID }
  
  outputs:
    instance_name:
      description: Name of the instance.
      value: { get_attr: [ server, name ] }
    instance_ip:
      description: IP address of the instance.
      value: { get_attr: [ server, first_address ] }
  ```

## 创建一个stack[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html#create-a-stack)

使用``demo-template.yml`` 模版创建一个栈。

1. 加载 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-heat.html#id1)demo``证书，作为非管理员项目执行下面的步骤：

   ```
   $ . demo-openrc
   ```

2. 检测可用网络。

   ```
   $ openstack network list
   +--------------------------------------+-------------+--------------------------------------+
   | ID                                   | Name        | Subnets                              |
   +--------------------------------------+-------------+--------------------------------------+
   | 4716ddfe-6e60-40e7-b2a8-42e57bf3c31c | selfservice | 2112d5eb-f9d6-45fd-906e-7cabd38b7c7c |
   | b5b6993c-ddf9-40e7-91d0-86806a42edb8 | provider    | 310911f6-acf0-4a47-824e-3032916582ff |
   +--------------------------------------+-------------+--------------------------------------+
   ```

   

    

   注解

   

   这个输出可能跟你的环境有所不同。

3. 设置”NET_ID”环境变量表示网络ID。例如，使用提供者网络：

   ```
   $ export NET_ID=$(openstack network list | awk '/ provider / { print $2 }')
   ```

4. 在提供者网络上创建一个CirrOS实例的栈：

   ```
   $ openstack stack create -t demo-template.yml --parameter "NetID=$NET_ID" stack
   +--------------------------------------+------------+--------------------+---------------------+--------------+
   | ID                                   | Stack Name | Stack Status       | Creation Time       | Updated Time |
   +--------------------------------------+------------+--------------------+---------------------+--------------+
   | dbf46d1b-0b97-4d45-a0b3-9662a1eb6cf3 | stack      | CREATE_IN_PROGRESS | 2015-10-13T15:27:20 | None         |
   +--------------------------------------+------------+--------------------+---------------------+--------------+
   ```

5. 等一小段时间，验证stack的创建是否成功：

   ```
   $ openstack stack list
   +--------------------------------------+------------+-----------------+---------------------+--------------+
   | ID                                   | Stack Name | Stack Status    | Creation Time       | Updated Time |
   +--------------------------------------+------------+-----------------+---------------------+--------------+
   | dbf46d1b-0b97-4d45-a0b3-9662a1eb6cf3 | stack      | CREATE_COMPLETE | 2015-10-13T15:27:20 | None         |
   +--------------------------------------+------------+-----------------+---------------------+--------------+
   ```

6. 查看实例的名称和IP地址并和OpenStack client的输出比较：

   ```
   $ openstack stack output show --all stack
   [
     {
       "output_value": "stack-server-3nzfyfofu6d4",
       "description": "Name of the instance.",
       "output_key": "instance_name"
     },
     {
       "output_value": "10.4.31.106",
       "description": "IP address of the instance.",
       "output_key": "instance_ip"
     }
   ]
   ```

   ```
   $ openstack server list
   +--------------------------------------+---------------------------+--------+---------------------------------+
   | ID                                   | Name                      | Status | Networks                        |
   +--------------------------------------+---------------------------+--------+---------------------------------+
   | 0fc2af0c-ae79-4d22-8f36-9e860c257da5 | stack-server-3nzfyfofu6d4 | ACTIVE | public=10.4.31.106              |
   +--------------------------------------+---------------------------+--------+---------------------------------+
   ```

7. 删除stack。

   ```
   $ openstack stack delete --yes stack
   ```

## 共享文件系统

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建service镜像](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#create-the-service-image)
  - [启动服务镜像的实例](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#launch-an-instance-of-the-service-image)
  - [创建共享](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#create-a-share)



## 创建service镜像[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#create-the-service-image)



 

注解



在典型部署结构中，您需要从支持网络共享文件系统比如NFS/CIFS的镜像创建一个实例，用于评估共享文件系统服务。这个教程应该使用CirrOS镜像创建实例来降低评估的资源需求。然而，CirrOS镜像缺少网络文件系统的支持。为了评估共享文件系统服务，这个教程使用``manila-share-service``镜像创建了一个常规实例，这是因为它支持网络文件系统，使用 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#id1)manila-service-flavor``类型限制资源消耗，使用计算节点上的256M内存。

1. 下载共享服务器的源镜像：

   ```
   $ wget http://tarballs.openstack.org/manila-image-elements/images/manila-service-image-master.qcow2
   ```

2. 添加镜像到镜像服务里：

   ```
   # openstack image create "manila-service-image" \
   --file manila-service-image-master.qcow2 \
   --disk-format qcow2 \
   --container-format bare \
   --public
   +------------------+------------------------------------------------------+
   | Field            | Value                                                |
   +------------------+------------------------------------------------------+
   | checksum         | abb1fdf972162c7214db9fad43229dad                     |
   | container_format | bare                                                 |
   | created_at       | 2016-03-16T23:37:51Z                                 |
   | disk_format      | qcow2                                                |
   | file             | /v2/images/dcec8c7f-4c59-4223-a06f-220231b49c0c/file |
   | id               | dcec8c7f-4c59-4223-a06f-220231b49c0c                 |
   | min_disk         | 0                                                    |
   | min_ram          | 0                                                    |
   | name             | manila-service-image                                 |
   | owner            | fd4a657caa054ca99d8b4179722f49de                     |
   | protected        | False                                                |
   | schema           | /v2/schemas/image                                    |
   | size             | 324665344                                            |
   | status           | active                                               |
   | tags             |                                                      |
   | updated_at       | 2016-03-16T23:37:55Z                                 |
   | virtual_size     | None                                                 |
   | visibility       | public                                               |
   +------------------+------------------------------------------------------+
   ```

3. 创建一个新的支持服务镜像的类型：

   ```
   # openstack flavor create manila-service-flavor --id 100 --ram 256 --disk 0 --vcpus 1
   +----------------------------+-----------------------+
   | Field                      | Value                 |
   +----------------------------+-----------------------+
   | OS-FLV-DISABLED:disabled   | False                 |
   | OS-FLV-EXT-DATA:ephemeral  | 0                     |
   | disk                       | 0                     |
   | id                         | 100                   |
   | name                       | manila-service-flavor |
   | os-flavor-access:is_public | True                  |
   | ram                        | 256                   |
   | rxtx_factor                | 1.0                   |
   | swap                       |                       |
   | vcpus                      | 1                     |
   +----------------------------+-----------------------+
   ```

   

    

   注解

   

   类型是镜像规格，镜像直接可以不同。

## 启动服务镜像的实例[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#launch-an-instance-of-the-service-image)



 

注解



这个章节使用``manila-service-image``镜像创建一个实例用于挂载共享。

1. 使用``manila-service-image`` 和 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#id1)manila-service-flavor``启动一个实例。
2. 使用``manila``作为用户和密码登陆到实例。

## 创建共享[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila.html#create-a-share)

创建一个共享文件系统服务选项，选项参见:ref:manila-storage。

- [选项1 在没有服务管理的支持下创建共享](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html)
- [选项2：在共享服务管理支持下创建共享](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html)

## 选项1 在没有服务管理的支持下创建共享

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建一个共享类型](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#create-a-share-type)
  - [创建共享](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#create-a-share)
  - [从实例挂载共享点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#mount-the-share-from-an-instance)



## 创建一个共享类型[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#create-a-share-type)

在使用LVM驱动创建共享之前禁用DHSS。

1. 获取只有管理能执行命令的管理权限:

   ```
   $ . admin-openrc
   ```

2. 创建一个禁用DHSS的共享类型：

   ```
   $ manila type-create default_share_type False
   +----------------------+--------------------------------------+
   | Property             | Value                                |
   +----------------------+--------------------------------------+
   | required_extra_specs | driver_handles_share_servers : False |
   | Name                 | default_share_type                   |
   | Visibility           | public                               |
   | is_default           | -                                    |
   | ID                   | 3df065c8-6ca4-4b80-a5cb-e633c0439097 |
   | optional_extra_specs | snapshot_support : True              |
   +----------------------+--------------------------------------+
   ```

## 创建共享[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#create-a-share)

1. 加载 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#id1)demo``证书，作为非管理员项目执行下面的步骤：

   ```
   $ . demo-openrc
   ```

2. 创建NFS共享：

   ```
   $ manila create NFS 1 --name share1
   +-----------------------------+--------------------------------------+
   | Property                    | Value                                |
   +-----------------------------+--------------------------------------+
   | status                      | creating                             |
   | share_type_name             | default_share_type                   |
   | description                 | None                                 |
   | availability_zone           | None                                 |
   | share_network_id            | None                                 |
   | host                        |                                      |
   | access_rules_status         | active                               |
   | snapshot_id                 | None                                 |
   | is_public                   | False                                |
   | task_state                  | None                                 |
   | snapshot_support            | True                                 |
   | id                          | 55c401b3-3112-4294-aa9f-3cc355a4e361 |
   | size                        | 1                                    |
   | name                        | share1                               |
   | share_type                  | c6dfcfc6-9920-420e-8b0a-283d578efef5 |
   | has_replicas                | False                                |
   | replication_type            | None                                 |
   | created_at                  | 2016-03-30T19:10:33.000000           |
   | share_proto                 | NFS                                  |
   | consistency_group_id        | None                                 |
   | source_cgsnapshot_member_id | None                                 |
   | project_id                  | 3a46a53a377642a284e1d12efabb3b5a     |
   | metadata                    | {}                                   |
   +-----------------------------+--------------------------------------+
   ```

3. 过会，共享状态将由``创建中`` 变为 `可用`：

   ```
   $ manila list
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   | ID                                   | Name   | Size | Share Proto | Status    | Is Public | Share Type Name    | Host                        | Availability Zone |
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   | 55c401b3-3112-4294-aa9f-3cc355a4e361 | share1 | 1    | NFS         | available | False     | default_share_type | storage@lvm#lvm-single-pool | nova              |
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   ```

4. 检测导出的共享IP地址：

   ```
   $ manila show share1
   +-----------------------------+------------------------------------------------------------------------------------+
   | Property                    | Value                                                                              |
   +-----------------------------+------------------------------------------------------------------------------------+
   | status                      | available                                                                          |
   | share_type_name             | default_share_type                                                                 |
   | description                 | None                                                                               |
   | availability_zone           | nova                                                                               |
   | share_network_id            | None                                                                               |
   | export_locations            |                                                                                    |
   |                             | path = 10.0.0.41:/var/lib/manila/mnt/share-8e13a98f-c310-41df-ac90-fc8bce4910b8    |
   |                             | id = 3c8d0ada-cadf-48dd-85b8-d4e8c3b1e204                                          |
   |                             | preferred = False                                                                  |
   | host                        | storage@lvm#lvm-single-pool                                                        |
   | access_rules_status         | active                                                                             |
   | snapshot_id                 | None                                                                               |
   | is_public                   | False                                                                              |
   | task_state                  | None                                                                               |
   | snapshot_support            | True                                                                               |
   | id                          | 55c401b3-3112-4294-aa9f-3cc355a4e361                                               |
   | size                        | 1                                                                                  |
   | name                        | share1                                                                             |
   | share_type                  | c6dfcfc6-9920-420e-8b0a-283d578efef5                                               |
   | has_replicas                | False                                                                              |
   | replication_type            | None                                                                               |
   | created_at                  | 2016-03-30T19:10:33.000000                                                         |
   | share_proto                 | NFS                                                                                |
   | consistency_group_id        | None                                                                               |
   | source_cgsnapshot_member_id | None                                                                               |
   | project_id                  | 3a46a53a377642a284e1d12efabb3b5a                                                   |
   | metadata                    | {}                                                                                 |
   +-----------------------------+------------------------------------------------------------------------------------+
   ```

5. 在尝试通过网络挂载时，配置用户访问这个新的共享：

   ```
   $ manila access-allow share1 ip INSTANCE_IP_ADDRESS
   +--------------+--------------------------------------+
   | Property     | Value                                |
   +--------------+--------------------------------------+
   | share_id     | 55c401b3-3112-4294-aa9f-3cc355a4e361 |
   | access_type  | ip                                   |
   | access_to    | 10.0.0.41                            |
   | access_level | rw                                   |
   | state        | new                                  |
   | id           | f88eab01-7197-44bf-ad0f-d6ca6f99fc96 |
   +--------------+--------------------------------------+
   ```

   使用实例IP地址替换``INSTANCE_IP_ADDRESS`` 。

   

    

   注解

   

   在存储节点上，实例必须直接连通管理网IP地址。

## 从实例挂载共享点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-false-option1.html#mount-the-share-from-an-instance)

1. 创建一个挂载点目录：

   ```
   $ mkdir ~/test_folder
   ```

2. 在实例中，使用共享导出的目录挂载NFS共享：

   ```
   # mount -t nfs 10.0.0.41:/var/lib/manila/mnt/share-b94a4dbf-49e2-452c-b9c7-510277adf5c6 ~/test_folder
   ```

想了解更多关于如何管理共享， 请参考OpenStack终端用户手册里的`Manage shares <http://docs.openstack.org/user-guide/cli-manage-shares.html>`__

返回到：ref: launch-instance。

## 选项2：在共享服务管理支持下创建共享

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建一个共享类型](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share-type)
  - [新建共享网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share-network)
  - [创建共享](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share)
  - [从实例挂载共享点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#mount-the-share-from-an-instance)



在能够创建共享之前，启用DHSS模式的普通驱动至少需要一个镜像、一个类型，一个网络和一个共享网络，共享网络用于创建NFS/CIFS服务运行的共享服务器。

## 创建一个共享类型[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share-type)

在创建使用普通驱动的共享之前，启用DHSS。

1. 获取只有管理能执行命令的管理权限:

   ```
   $ . admin-openrc
   ```

2. 创建启用DHSS的缺省共享类型：

   ```
   $ manila type-create generic_share_type True
   +----------------------+--------------------------------------+
   | Property             | Value                                |
   +----------------------+--------------------------------------+
   | required_extra_specs | driver_handles_share_servers : True  |
   | Name                 | generic_share_type                   |
   | Visibility           | public                               |
   | is_default           | -                                    |
   | ID                   | 3df065c8-6ca4-4b80-a5cb-e633c0439097 |
   | optional_extra_specs | snapshot_support : True              |
   +----------------------+--------------------------------------+
   ```

## 新建共享网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share-network)

1. 加载 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#id1)demo``证书，作为非管理员项目执行下面的步骤：

   ```
   $ . demo-openrc
   ```

2. 为``selfservice``网络，列出可用网络获取网络和子网ID：

   ```
   $ neutron net-list
   +--------------------------------------+-------------+-----------------------------------------------------+
   | id                                   | name        | subnets                                             |
   +--------------------------------------+-------------+-----------------------------------------------------+
   | b72d8561-aceb-4e79-938f-df3a45fdeaa3 | provider    | 072dd25f-e049-454c-9b11-359c910e6668 203.0.113.0/24 |
   | 4e963f5b-b5f3-4db1-a935-0d34c8629e7b | selfservice | 005bf8d1-798e-450f-9efe-72bc0c3be491 172.16.1.0/24  |
   +--------------------------------------+-------------+-----------------------------------------------------+
   ```

3. 使用``selfservice``和子网IDs创建共享网络：

   ```
   $ manila share-network-create --name selfservice-net-share1 \
     --neutron-net-id 4e963f5b-b5f3-4db1-a935-0d34c8629e7b \
     --neutron-subnet-id 005bf8d1-798e-450f-9efe-72bc0c3be491
   +-------------------+--------------------------------------+
   | Property          | Value                                |
   +-------------------+--------------------------------------+
   | name              | selfservice-net-share1               |
   | segmentation_id   | None                                 |
   | created_at        | 2016-03-31T13:25:39.052439           |
   | neutron_subnet_id | 005bf8d1-798e-450f-9efe-72bc0c3be491 |
   | updated_at        | None                                 |
   | network_type      | None                                 |
   | neutron_net_id    | 4e963f5b-b5f3-4db1-a935-0d34c8629e7b |
   | ip_version        | None                                 |
   | nova_net_id       | None                                 |
   | cidr              | None                                 |
   | project_id        | 3a46a53a377642a284e1d12efabb3b5a     |
   | id                | 997a1a0a-4f4d-4aa3-b7ae-8ae6d9aaa828 |
   | description       | None                                 |
   +-------------------+--------------------------------------+
   ```

## 创建共享[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#create-a-share)

1. 加载 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#id1)demo``证书，作为非管理员项目执行下面的步骤：

   ```
   $ . demo-openrc
   ```

2. 使用共享网络创建NFS共享：

   ```
   $ manila create NFS 1 --name share2 \
     --share-network selfservice-net-share1 \
     --share-type generic_share_type
   +-----------------------------+--------------------------------------+
   | Property                    | Value                                |
   +-----------------------------+--------------------------------------+
   | status                      | creating                             |
   | share_type_name             | generic_share_type                   |
   | description                 | None                                 |
   | availability_zone           | None                                 |
   | share_network_id            | 997a1a0a-4f4d-4aa3-b7ae-8ae6d9aaa828 |
   | host                        |                                      |
   | access_rules_status         | active                               |
   | snapshot_id                 | None                                 |
   | is_public                   | False                                |
   | task_state                  | None                                 |
   | snapshot_support            | True                                 |
   | id                          | 6a711b95-9e03-4547-8769-74e34676cb3e |
   | size                        | 1                                    |
   | name                        | share2                               |
   | share_type                  | 8698ed92-2a1c-4c9f-aab4-a35dccd88c8f |
   | has_replicas                | False                                |
   | replication_type            | None                                 |
   | created_at                  | 2016-03-31T13:45:18.000000           |
   | share_proto                 | NFS                                  |
   | consistency_group_id        | None                                 |
   | source_cgsnapshot_member_id | None                                 |
   | project_id                  | 3a46a53a377642a284e1d12efabb3b5a     |
   | metadata                    | {}                                   |
   +-----------------------------+--------------------------------------+
   ```

3. 过会，共享状态将由``创建中`` 变为 `可用`：

   ```
   $ manila list
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   | ID                                   | Name   | Size | Share Proto | Status    | Is Public | Share Type Name    | Host                        | Availability Zone |
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   | 5f8a0574-a95e-40ff-b898-09fd8d6a1fac | share2 | 1    | NFS         | available | False     | default_share_type | storage@generic#GENERIC     | nova              |
   +--------------------------------------+--------+------+-------------+-----------+-----------+--------------------+-----------------------------+-------------------+
   ```

4. 检测导出的共享IP地址：

   ```
   $ manila show share2
   +-----------------------------+------------------------------------------------------------------------------------+
   | Property                    | Value                                                                              |
   +-----------------------------+------------------------------------------------------------------------------------+
   | status                      | available                                                                          |
   | share_type_name             | generic_share_type                                                                 |
   | description                 | None                                                                               |
   | availability_zone           | nova                                                                               |
   | share_network_id            | None                                                                               |
   | export_locations            |                                                                                    |
   |                             | path = 10.254.0.6:/shares/share-0bfd69a1-27f0-4ef5-af17-7cd50bce6550               |
   |                             | id = 3c8d0ada-cadf-48dd-85b8-d4e8c3b1e204                                          |
   |                             | preferred = False                                                                  |
   | host                        | storage@generic#GENERIC                                                            |
   | access_rules_status         | active                                                                             |
   | snapshot_id                 | None                                                                               |
   | is_public                   | False                                                                              |
   | task_state                  | None                                                                               |
   | snapshot_support            | True                                                                               |
   | id                          | 5f8a0574-a95e-40ff-b898-09fd8d6a1fac                                               |
   | size                        | 1                                                                                  |
   | name                        | share2                                                                             |
   | share_type                  | 8a35da28-0f74-490d-afff-23664ecd4f01                                               |
   | has_replicas                | False                                                                              |
   | replication_type            | None                                                                               |
   | created_at                  | 2016-03-30T19:10:33.000000                                                         |
   | share_proto                 | NFS                                                                                |
   | consistency_group_id        | None                                                                               |
   | source_cgsnapshot_member_id | None                                                                               |
   | project_id                  | 3a46a53a377642a284e1d12efabb3b5a                                                   |
   | metadata                    | {}                                                                                 |
   +-----------------------------+------------------------------------------------------------------------------------+
   ```

5. 在尝试通过网络挂载时，配置用户访问这个新的共享：

   ```
   $ manila access-allow share2 ip INSTANCE_IP_ADDRESS
   +--------------+--------------------------------------+
   | Property     | Value                                |
   +--------------+--------------------------------------+
   | share_id     | 55c401b3-3112-4294-aa9f-3cc355a4e361 |
   | access_type  | ip                                   |
   | access_to    | 172.16.1.5                           |
   | access_level | rw                                   |
   | state        | new                                  |
   | id           | f88eab01-7197-44bf-ad0f-d6ca6f99fc96 |
   +--------------+--------------------------------------+
   ```

   使用实例IP地址替换``INSTANCE_IP_ADDRESS`` 。

   

    

   注解

   

   该云主机必须使用``selfservice``网络。

## 从实例挂载共享点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/launch-instance-manila-dhss-true-option2.html#mount-the-share-from-an-instance)

1. 创建一个挂载点目录：

   ```
   $ mkdir ~/test_folder
   ```

2. 在实例中，使用共享导出的目录挂载NFS共享：

   ```
   # mount -t nfs 10.254.0.6:/shares/share-0bfd69a1-27f0-4ef5-af17-7cd50bce6550 ~/test_folder
   ```

想了解更多关于如何管理共享， 请参考OpenStack终端用户手册里的`Manage shares <http://docs.openstack.org/user-guide/cli-manage-shares.html>`__

返回到：ref: launch-instance。

​                                            