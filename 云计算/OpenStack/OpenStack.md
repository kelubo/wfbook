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

这个示例架构需要至少2个（主机）节点来启动基础服务：term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)virtual machine <virtual machine (VM)>`或者实例。像块存储服务，对象存储服务这一类服务还需要额外的节点

这个示例架构不同于下面这样的最小生产结构

- 网络代理驻留在控制节点上而不是在一个或者多个专用的网络节点上。
- 私有网络的覆盖流量通过管理网络而不是专用网络

关于生产架构的更多信息，参考`Architecture Design Guide <http://docs.openstack.org/arch-design/content/>`__, [Operations Guide `__和`Networking Guide](http://docs.openstack.org/networking-guide/)。

![Hardware requirements](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/hwreqs.png)

**硬件需求**

### 控制器[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#controller)

控制节点上运行身份认证服务，镜像服务，计算服务的管理部分，网络服务的管理部分，多种网络代理以及仪表板。也需要包含一些支持服务，例如：SQL数据库，term:消息队列, and [*NTP*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-ntp)。

可选的，可以在计算节点上运行部分块存储，对象存储，Orchestration 和 Telemetry 服务。

计算节点上需要至少两块网卡。

### 计算[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)

计算节点上运行计算服务中管理实例的管理程序部分。默认情况下，计算服务使用 *KVM*。

你可以部署超过一个计算节点。每个结算节点至少需要两块网卡。

### 块设备存储[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id2)

可选的块存储节点上包含了磁盘，块存储服务和共享文件系统会向实例提供这些磁盘。

为了简单起见，计算节点和本节点之间的服务流量使用管理网络。生产环境中应该部署一个单独的存储网络以增强性能和安全。

你可以部署超过一个块存储节点。每个块存储节点要求至少一块网卡。

### 对象存储[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id3)

可选的对象存储节点包含了磁盘。对象存储服务用这些磁盘来存储账号，容器和对象。

为了简单起见，计算节点和本节点之间的服务流量使用管理网络。生产环境中应该部署一个单独的存储网络以增强性能和安全。

这个服务要求两个节点。每个节点要求最少一块网卡。你可以部署超过两个对象存储节点。

## 网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id4)

从下面的虚拟网络选项中选择一种选项。



### 网络选项1：公共网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#networking-option-1-provider-networks)

公有网络选项使用尽可能简单的方式主要通过layer-2（网桥/交换机）服务以及VLAN网络的分割来部署OpenStack网络服务。本质上，它建立虚拟网络到物理网络的桥，依靠物理网络基础设施提供layer-3服务(路由)。额外地 ，:term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)DHCP`为实例提供IP地址信息。



 

注解



这个选项不支持私有网络，layer-3服务以及一些高级服务，例如:term:LBaaS and [*FWaaS*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-fwaas)。如果你需要这些服务，请考虑私有网络选项

![Networking Option 1: Provider networks - Service layout](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network1-services.png)



### 网络选项2：私有网络[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#networking-option-2-self-service-networks)

私有网络选项扩展了公有网络选项，增加了启用 *self-service`覆盖分段方法的layer-3（路由）服务，比如 :term:`VXLAN*。本质上，它使用 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/overview.html#id1)NAT`路由虚拟网络到物理网络。另外，这个选项也提供高级服务的基础，比如LBaas和FWaaS。

![Networking Option 2: Self-service networks - Service layout](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/network2-services.png)

​                                                                                      

## 环境



这个部分解释如何按示例架构配置控制节点和一个计算节点

尽管大多数环境中包含认证，镜像，计算，至少一个网络服务，还有仪表盘，但是对象存储服务也可以单独操作。如果你的使用情况与涉及到对象存储，你可以在配置完适当的节点后跳到：ref:swift。然而仪表盘要求至少要有镜像服务，计算服务和网络服务。

你必须用有管理员权限的帐号来配置每个节点。可以用 `root` 用户或 `sudo` 工具来执行这些命令。

为获得最好的性能，我们推荐在你的环境中符合或超过在 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment.html#id1)figure-hwreqs`中的硬件要求。

以下最小需求支持概念验证环境，使用核心服务和几个:term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment.html#id1)CirrOS`实例:

- 控制节点: 1 处理器, 4 GB 内存, 及5 GB 存储
- 计算节点: 1 处理器, 2 GB 内存, 及10 GB 存储

由于Openstack服务数量以及虚拟机数量的正常，为了获得最好的性能，我们推荐你的环境满足或者超过基本的硬件需求。如果在增加了更多的服务或者虚拟机后性能下降，请考虑为你的环境增加硬件资源。

为了避免混乱和为OpenStack提供更多资源，我们推荐你最小化安装你的Linux发行版。同时，你必须在每个节点安装你的发行版的64位版本。

每个节点配置一个磁盘分区满足大多数的基本安装。但是，对于有额外服务如块存储服务的，你应该考虑采用 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment.html#id1)Logical Volume Manager (LVM)`进行安装。

对于第一次安装和测试目的，很多用户选择使用 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment.html#id1)virtual machine (VM)`作为主机。使用虚拟机的主要好处有一下几点：

- 一台物理服务器可以支持多个节点，每个节点几乎可以使用任意数目的网络接口。
- 在安装过程中定期进行“快照”并且在遇到问题时可以“回滚”到上一个可工作配置的能力。

但是，虚拟机会降低您实例的性能，特别是如果您的 hypervisor 和/或 进程缺少硬件加速的嵌套虚拟机支持时。



 

注解



如果你选择在虚拟机内安装，请确保你的hypervisor提供了在public网络接口上禁用MAC地址过滤的方法。

更多关于系统要求的信息，查看 [OpenStack Operations Guide](http://docs.openstack.org/ops/).

- [安全](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-security.html)
- [主机网络](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking.html)
- [网络时间协议(NTP)](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp.html)
- [OpenStack包](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html)
- [SQL数据库](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html)
- [NoSQL 数据库](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html)
- [消息队列](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-messaging.html)
- [Memcached](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-memcached.html)

## 安全

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

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
| `RABBIT_PASS`            | RabbitMQ的guest用户密码                |
| `SWIFT_PASS`             | 对象存储服务用户``swift``的密码        |

OpenStack和配套服务在安装和操作过程中需要管理员权限。在很多情况下，服务可以与自动化部署工具如 Ansible， Chef,和 Puppet进行交互，对主机进行修改。例如，一些OpenStack服务添加root权限 `sudo` 可以与安全策略进行交互。更多信息，可以参考 [`管理员参考`__](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-security.html#id2) 。

另外，网络服务设定内核网络参数的默认值并且修改防火墙规则。为了避免你初始化安装的很多问题，我们推荐在你的主机上使用支持的发行版本。不管怎样，如果你选择自动化部署你的主机，在进一步操作前检查它们的配置和策略。

## 主机网络

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



在你按照你选择的架构，完成各个节点操作系统安装以后，你必须配置网络接口。我们推荐你禁用自动网络管理工具并手动编辑你相应版本的配置文件。更多关于如何配置你版本网络信息内容，参考 [documentation](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_Command_Line_Interface.html) 。

出于管理目的，例如：安装包，安全更新， *DNS`和 :term:`NTP*，所有的节点都需要可以访问互联网。在大部分情况下，节点应该通过管理网络接口访问互联网。为了更好的突出网络隔离的重要性，示例架构中为管理网络使用`private address space <https://tools.ietf.org/html/rfc1918>`__ 并假定物理网络设备通过 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking.html#id1)NAT`或者其他方式提供互联网访问。示例架构使用可路由的IP地址隔离服务商（外部）网络并且假定物理网络设备直接提供互联网访问。

在提供者网络架构中，所有实例直接连接到提供者网络。在自服务（私有）网络架构，实例可以连接到自服务或提供者网络。自服务网络可以完全在openstack环境中或者通过外部网络使用:term:NAT 提供某种级别的外部网络访问。

![Network layout](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/_images/networklayout.png)

示例架构假设使用如下网络：

- 管理使用 10.0.0.0/24 带有网关 10.0.0.1

  这个网络需要一个网关以为所有节点提供内部的管理目的的访问，例如包的安装、安全更新、 [*DNS*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-dns)，和 [*NTP*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-ntp)。

- 提供者网段 203.0.113.0/24，网关203.0.113.1

  这个网络需要一个网关来提供在环境中内部实例的访问。

您可以修改这些范围和网关来以您的特定网络设施进行工作。

网络接口由发行版的不同而有各种名称。传统上，接口使用 “eth” 加上一个数字序列命名。为了覆盖到所有不同的名称，本指南简单地将数字最小的接口引用为第一个接口，第二个接口则为更大数字的接口。

除非您打算使用该架构样例中提供的准确配置，否则您必须在本过程中修改网络以匹配您的环境。并且，每个节点除了 IP  地址之外，还必须能够解析其他节点的名称。例如，controller这个名称必须解析为 10.0.0.11，即控制节点上的管理网络接口的 IP  地址。



 

警告



重新配置网络接口会中断网络连接。我们建议使用本地终端会话来进行这个过程。



 

注解



你的发行版本默认启用了限制 [*firewall*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-firewall) 。在安装过程中，有些步骤可能会失败，除非你允许或者禁用了防火墙。更多关于安全的资料，参考 [OpenStack Security Guide](http://docs.openstack.org/sec/)。

- [控制节点服务器](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-controller.html)
- [计算节点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-compute.html)
- [块存储节点（可选）](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-cinder.html)
- [对象存储节点（可选）](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html)
- [验证连通性](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-verify.html)

## 控制节点服务器

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置网络接口](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-controller.html#configure-network-interfaces)
  - [配置域名解析](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-controller.html#configure-name-resolution)

## 配置网络接口[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-controller.html#configure-network-interfaces)

1. 将第一个接口配置为管理网络接口：

   IP 地址: 10.0.0.11

   子网掩码: 255.255.255.0 (or /24)

   默认网关: 10.0.0.1

2. 提供者网络接口使用一个特殊的配置，不分配给它IP地址。配置第二块网卡作为提供者网络：

   将其中的 INTERFACE_NAME替换为实际的接口名称。例如，*eth1* 或者*ens224*。

   - 编辑``/etc/sysconfig/network-scripts/ifcfg-INTERFACE_NAME``文件包含以下内容：

     不要改变 键``HWADDR`` 和 `UUID` 。

     ```
     DEVICE=INTERFACE_NAME
     TYPE=Ethernet
     ONBOOT="yes"
     BOOTPROTO="none"
     ```

3. 重启系统以激活修改。

## 配置域名解析[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-controller.html#configure-name-resolution)

1. 设置节点主机名为 `controller`。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```
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

   

    

   警告

   

   一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

   

    

   注解

   

   为了减少本指南的复杂性，不管你选择怎么部署它们，我们为可选服务增加了主机条目。

​                      

## 计算节点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置网络接口](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-compute.html#configure-network-interfaces)
  - [配置域名解析](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-compute.html#configure-name-resolution)

## 配置网络接口[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-compute.html#configure-network-interfaces)

1. 将第一个接口配置为管理网络接口：

   IP 地址：10.0.0.31

   子网掩码: 255.255.255.0 (or /24)

   默认网关: 10.0.0.1

   

    

   注解

   

   另外的计算节点应使用 10.0.0.32、10.0.0.33 等等。

2. 提供者网络接口使用一个特殊的配置，不分配给它IP地址。配置第二块网卡作为提供者网络：

   将其中的 INTERFACE_NAME替换为实际的接口名称。例如，*eth1* 或者*ens224*。

   - 编辑``/etc/sysconfig/network-scripts/ifcfg-INTERFACE_NAME``文件包含以下内容：

     不要改变 键``HWADDR`` 和 `UUID` 。

     ```
     DEVICE=INTERFACE_NAME
     TYPE=Ethernet
     ONBOOT="yes"
     BOOTPROTO="none"
     ```

3. 重启系统以激活修改。

## 配置域名解析[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-compute.html#configure-name-resolution)

1. 设置节点主机名为``compute1``。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```
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

   

    

   警告

   

   一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

   

    

   注解

   

   为了减少本指南的复杂性，不管你选择怎么部署它们，我们为可选服务增加了主机条目。

​                      

## 块存储节点（可选）

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [配置网络接口](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-cinder.html#configure-network-interfaces)
  - [配置域名解析](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-cinder.html#configure-name-resolution)

如果你想布署块存储节点，需要配置一个额外的存储节点。

## 配置网络接口[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-cinder.html#configure-network-interfaces)

- 配置管理网络接口：
  - IP 地址： `10.0.0.41`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

## 配置域名解析[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-cinder.html#configure-name-resolution)

1. 设置节点主机名为``block1``。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```
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

   

    

   警告

   

   一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

   

    

   注解

   

   为了减少本指南的复杂性，不管你选择怎么部署它们，我们为可选服务增加了主机条目。

3. 重启系统以激活修改。

​                      

## 对象存储节点（可选）

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - 第一个节点
    - [配置网络接口](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#configure-network-interfaces)
    - [配置域名解析](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#configure-name-resolution)
  - 第二个节点
    - [配置网络接口](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#id1)
    - [配置域名解析](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#id2)

如果你想部署对象存储服务，需要额外配置2个存储节点。

## 第一个节点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#first-node)

### 配置网络接口[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#configure-network-interfaces)

- 配置管理网络接口：
  - IP 地址：`10.0.0.51`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

### 配置域名解析[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#configure-name-resolution)

1. 设置节点主机名为 `object1`。

2. 编辑 `/etc/hosts` 文件包含以下内容：

   ```
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

   

    

   警告

   

   一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

   

    

   注解

   

   为了减少本指南的复杂性，不管你选择怎么部署它们，我们为可选服务增加了主机条目。

3. 重启系统以激活修改。

## 第二个节点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#second-node)

### 配置网络接口[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#id1)

- 配置管理网络接口：
  - IP地址：`10.0.0.52`
  - 掩码： `255.255.255.0` (or `/24`)
  - 默认网关： `10.0.0.1`

### 配置域名解析[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-networking-storage-swift.html#id2)

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

   

    

   警告

   

   一些发行版本在``/etc/hosts``文件中添加了附加条目解析实际主机名到另一个IP地址如 `127.0.1.1`。为了防止域名解析问题，你必须注释或者删除这些条目。**不要删除127.0.0.1条目。**

   

    

   注解

   

   为了减少本指南的复杂性，不管你选择怎么部署它们，我们为可选服务增加了主机条目。

3. 重启系统以激活修改。

## 验证连通性

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

我们建议您在继续进行之前，验证到 Internet 和各个节点之间的连通性。

1. 从*controller*节点，测试能否连接到 Internet：

   ```bash
   # ping -c 4 openstack.org
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
   # ping -c 4 compute1
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
   # ping -c 4 openstack.org
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
   # ping -c 4 controller
   PING controller (10.0.0.11) 56(84) bytes of data.
   64 bytes from controller (10.0.0.11): icmp_seq=1 ttl=64 time=0.263 ms
   64 bytes from controller (10.0.0.11): icmp_seq=2 ttl=64 time=0.202 ms
   64 bytes from controller (10.0.0.11): icmp_seq=3 ttl=64 time=0.203 ms
   64 bytes from controller (10.0.0.11): icmp_seq=4 ttl=64 time=0.202 ms
   
   --- controller ping statistics ---
   4 packets transmitted, 4 received, 0% packet loss, time 3000ms
   rtt min/avg/max/mdev = 0.202/0.217/0.263/0.030 ms
   ```



 

注解



你的发行版本默认启用了限制 [*firewall*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-firewall) 。在安装过程中，有些步骤可能会失败，除非你允许或者禁用了防火墙。更多关于安全的资料，参考 [OpenStack Security Guide](http://docs.openstack.org/sec/)。

## 网络时间协议(NTP)

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



你应该安装Chrony，一个在不同节点同步服务实现 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp.html#id1)NTP`的方案。我们建议你配置控制器节点引用更准确的(lower stratum)NTP服务器，然后其他节点引用控制节点。

- [控制节点服务器](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-controller.html)
- [其它节点服务器](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-other.html)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-verify.html)

## 控制节点服务器

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-controller.html#install-and-configure-components)



在控制节点上执行这些步骤。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-controller.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install chrony
   ```

1. 编辑 `/etc/chrony.conf` 文件，按照你环境的要求，对下面的键进行添加，修改或者删除：

   ```
   server NTP_SERVER iburst
   ```

   使用NTP服务器的主机名或者IP地址替换 `NTP_SERVER` 。配置支持设置多个 `server` 值。

   

    

   注解

   

   控制节点默认跟公共服务器池同步时间。但是你也可以选择性配置其他服务器，比如你组织中提供的服务器。

2. 为了允许其他节点可以连接到控制节点的 chrony 后台进程，在``/etc/chrony.conf`` 文件添加下面的键：

   ```
   allow 10.0.0.0/24
   ```

   如有必要，将 `10.0.0.0/24` 替换成你子网的相应描述。

3. 启动 NTP 服务并将其配置为随系统启动：

   ```
   # systemctl enable chronyd.service
   # systemctl start chronyd.service
   ```

## 其它节点服务器

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-other.html#install-and-configure-components)



其他节点会连接控制节点同步时间。在所有其他节点执行这些步骤。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-ntp-other.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install chrony
   ```

1. 编辑``/etc/chrony.conf`` 文件并注释除``server`` 值外的所有内容。修改它引用控制节点：

   ```
   server controller iburst
   ```

2. 启动 NTP 服务并将其配置为随系统启动：

   ```
   # systemctl enable chronyd.service
   # systemctl start chronyd.service
   ```

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 



我们建议您在继续进一步的操作之前验证 NTP 的同步。有些节点，特别是哪些引用了控制节点的，需要花费一些时间去同步。

1. 在控制节点上执行这个命令：

   ```bash
   # chronyc sources
     210 Number of sources = 2
     MS Name/IP address         Stratum Poll Reach LastRx Last sample
     ===============================================================================
     ^- 192.0.2.11                    2   7    12   137  -2814us[-3000us] +/-   43ms
     ^* 192.0.2.12                    2   6   177    46    +17us[  -23us] +/-   68ms
   ```

   在 *Name/IP address* 列的内容应显示NTP服务器的主机名或者IP地址。在 *S* 列的内容应该在NTP服务目前同步的上游服务器前显示 ***。

2. 在所有其他节点执行相同命令：

   ```bash
   # chronyc sources
     210 Number of sources = 1
     MS Name/IP address         Stratum Poll Reach LastRx Last sample
     ===============================================================================
     ^* controller                    3    9   377   421    +15us[  -87us] +/-   15ms
   ```

   在 *Name/IP address* 列的内容应显示控制节点的主机名。

​                      

## OpenStack包

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#prerequisites)
  - [启用OpenStack库](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#id1)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#finalize-the-installation)

由于不同的发布日程，发行版发布 OpenStack 的包作为发行版的一部分，或使用其他方式。请在所有节点上执行这些程序。



 

警告



在你进行更多步骤前，你的主机必须包含最新版本的基础安装软件包。



 

注解



禁用或移除所有自动更新的服务，因为它们会影响到您的 OpenStack 环境。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#prerequisites)



 

警告



当使用RDO包时，我们推荐禁用EPEL，原因是EPEL中的更新破坏向后兼容性。或者使用``yum-versionlock``插件指定包版本号。



 

注解



CentOS不需要以下步骤。

1. 在RHEL，注册系统使用Red Hat订阅管理，使用您的客户Portal的用户名和密码：

   ```
   # subscription-manager register --username="USERNAME" --password="PASSWORD"
   ```

2. 为RHEL系统找到授权池包含这些通道：

   ```
   # subscription-manager list --available
   ```

3. 使用前面步骤找到的池标识绑定您的RHEL授权：

   ```
   # subscription-manager attach --pool="POOLID"
   ```

4. 启用需要的库：

   ```
   # subscription-manager repos --enable=rhel-7-server-optional-rpms \
     --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-rh-common-rpms
   ```

## 启用OpenStack库[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#id1)

- 在CentOS中， [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#id1)extras``仓库提供用于启用 OpenStack 仓库的RPM包。 CentOS 默认启用``extras``仓库，因此你可以直接安装用于启用OpenStack仓库的包。

  ```
  # yum install centos-release-openstack-mitaka
  ```

- 在RHEL上，下载和安装RDO仓库RPM来启用OpenStack仓库。

  ```
  # yum install https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm
  ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-packages.html#finalize-the-installation)

1. 在主机上升级包：

   ```
   # yum upgrade
   ```

   

    

   注解

   

   如果更新了一个新内核，重启主机来使用新内核。

2. 安装 OpenStack 客户端：

   ```
   # yum install python-openstackclient
   ```

1. RHEL 和 CentOS 默认启用了 [*SELinux*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-selinux) . 安装 `openstack-selinux` 软件包以便自动管理 OpenStack 服务的安全策略:

   ```
   # yum install openstack-selinux
   ```

​                      

## SQL数据库

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html#finalize-installation)

大多数 OpenStack 服务使用 SQL 数据库来存储信息。 典型地，数据库运行在控制节点上。指南中的步骤依据不同的发行版使用MariaDB或 MySQL。OpenStack 服务也支持其他 SQL 数据库，包括`PostgreSQL <http://www.postgresql.org/>`__.

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install mariadb mariadb-server python2-PyMySQL
   ```

1. 创建并编辑 `/etc/my.cnf.d/openstack.cnf`，然后完成如下动作：

   - 在 `[mysqld]` 部分，设置 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html#id1)bind-address``值为控制节点的管理网络IP地址以使得其它节点可以通过管理网络访问数据库：

     ```
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

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-sql-database.html#finalize-installation)

1. 启动数据库服务，并将其配置为开机自启：

   ```
   # systemctl enable mariadb.service
   # systemctl start mariadb.service
   ```

1. 为了保证数据库服务的安全性，运行``mysql_secure_installation``脚本。特别需要说明的是，为数据库的root用户设置一个适当的密码。

   ```
   # mysql_secure_installation
   ```

## NoSQL 数据库

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#finalize-installation)



Telemetry 服务使用 NoSQL 数据库来存储信息，典型地，这个数据库运行在控制节点上。向导中使用MongoDB。



 

注解



只有按照文档 :ref:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#id1)install_ceilometer`安装Telemetry服务时，才需要安装NoSQL数据库服务。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#install-and-configure-components)

1. 安装MongoDB包：

   ```
   # yum install mongodb-server mongodb
   ```

1. 编辑文件 `/etc/mongod.conf` 并完成如下动作：

   - 配置 `bind_ip` 使用控制节点管理网卡的IP地址。

     ```
     bind_ip = 10.0.0.11
     ```

   - 默认情况下，MongoDB会在``/var/lib/mongodb/journal`` 目录下创建几个 1 GB 大小的日志文件。如果你想将每个日志文件大小减小到128MB并且限制日志文件占用的总空间为512MB，配置 `smallfiles` 的值：

     ```
     smallfiles = true
     ```

     你也可以禁用日志。更多信息，可以参考 [`MongoDB 手册`__](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#id1)。

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-nosql-database.html#finalize-installation)

- 启动MongoDB 并配置它随系统启动：

  ```bash
  # systemctl enable mongod.service
  # systemctl start mongod.service
  ```

​                      

## 消息队列

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-messaging.html#install-and-configure-components)

OpenStack 使用 [*message queue*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-message-queue) 协调操作和各服务的状态信息。消息队列服务一般运行在控制节点上。OpenStack支持好几种消息队列服务包括 [RabbitMQ](http://www.rabbitmq.com), [Qpid](http://qpid.apache.org), 和 [ZeroMQ](http://zeromq.org)。不过，大多数发行版本的OpenStack包支持特定的消息队列服务。本指南安装 RabbitMQ 消息队列服务，因为大部分发行版本都支持它。如果你想安装不同的消息队列服务，查询与之相关的文档。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-messaging.html#install-and-configure-components)

1. 安装包：

   ```bash
   # yum install rabbitmq-server
   ```

1. 启动消息队列服务并将其配置为随系统启动：

   ```bash
   # systemctl enable rabbitmq-server.service
   # systemctl start rabbitmq-server.service
   ```

2. 添加 `openstack` 用户：

   ```bash
   # rabbitmqctl add_user openstack RABBIT_PASS
   Creating user "openstack" ...
   ...done.
   ```

   用合适的密码替换 `RABBIT_DBPASS`。

3. 给``openstack``用户配置写和读权限：

   ```bash
   # rabbitmqctl set_permissions openstack ".*" ".*" ".*"
   Setting permissions for user "openstack" in vhost "/" ...
   ...done.
   ```

​                      

## Memcached

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-memcached.html#install-and-configure-components)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-memcached.html#finalize-installation)

认证服务认证缓存使用Memcached缓存令牌。缓存服务memecached运行在控制节点。在生产部署中，我们推荐联合启用防火墙、认证和加密保证它的安全。

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-memcached.html#install-and-configure-components)

1. 安装软件包：

   ```
   # yum install memcached python-memcached
   ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/environment-memcached.html#finalize-installation)

- 启动Memcached服务，并且配置它随机启动。

  ```
  # systemctl enable memcached.service
  # systemctl start memcached.service
  ```

## 认证服务

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

- [认证服务概览](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_identity.html)
- 安装和配置
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#install-and-configure-components)
  - [配置 Apache HTTP 服务器](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#configure-the-apache-http-server)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#finalize-the-installation)
- 创建服务实体和API端点
  - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#prerequisites)
  - [创建服务实体和API端点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)
- [创建域、项目、用户和角色](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html)
- [验证操作](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-verify.html)
- 创建 OpenStack 客户端环境脚本
  - [创建脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#creating-the-scripts)
  - [使用脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#using-the-scripts)

## 认证服务概览

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

OpenStack:term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/get_started_identity.html#id1)Identity  service`为认证管理，授权管理和服务目录服务管理提供单点整合。其它OpenStack服务将身份认证服务当做通用统一API来使用。此外，提供用户信息但是不在OpenStack项目中的服务（如LDAP服务）可被整合进先前存在的基础设施中。

为了从identity服务中获益，其他的OpenStack服务需要与它合作。当某个OpenStack服务收到来自用户的请求时，该服务询问Identity服务，验证该用户是否有权限进行此次请求

身份服务包含这些组件：

- 服务器

  一个中心化的服务器使用RESTful 接口来提供认证和授权服务。

- 驱动

  驱动或服务后端被整合进集中式服务器中。它们被用来访问OpenStack外部仓库的身份信息, 并且它们可能已经存在于OpenStack被部署在的基础设施（例如，SQL数据库或LDAP服务器）中。

- 模块

  中间件模块运行于使用身份认证服务的OpenStack组件的地址空间中。这些模块拦截服务请求，取出用户凭据，并将它们送入中央是服务器寻求授权。中间件模块和OpenStack组件间的整合使用Python Web服务器网关接口。

当安装OpenStack身份服务，用户必须将之注册到其OpenStack安装环境的每个服务。身份服务才可以追踪那些OpenStack服务已经安装，以及在网络中定位它们。

## 安装和配置

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#prerequisites)
  - [安全并配置组件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#install-and-configure-components)
  - [配置 Apache HTTP 服务器](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#configure-the-apache-http-server)
  - [完成安装](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#finalize-the-installation)



这一章描述如何在控制节点上安装和配置OpenStack身份认证服务，代码名称keystone。出于性能原因，这个配置部署Fernet令牌和Apache HTTP服务处理请求。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#prerequisites)

在你配置 OpenStack 身份认证服务前，你必须创建一个数据库和管理员令牌。

1. 完成下面的步骤以创建数据库：

   - 用数据库连接客户端以 `root` 用户连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - 创建 `keystone` 数据库：

     ```
     CREATE DATABASE keystone;
     ```

   - 对``keystone``数据库授予恰当的权限：

     ```bash
     GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
       IDENTIFIED BY 'KEYSTONE_DBPASS';
     GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
       IDENTIFIED BY 'KEYSTONE_DBPASS';
     ```

     用合适的密码替换 `KEYSTONE_DBPASS` 。

   - 退出数据库客户端。

2. 生成一个随机值在初始的配置中作为管理员的令牌。

   ```
   $ openssl rand -hex 10
   ```

## 安全并配置组件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#install-and-configure-components)



 

注解



默认配置文件在各发行版本中可能不同。你可能需要添加这些部分，选项而不是修改已经存在的部分和选项。另外，在配置片段中的省略号(`...`)表示默认的配置选项你应该保留。



 

注解



教程使用带有``mod_wsgi``的Apache HTTP服务器来服务认证服务请求，端口为5000和35357。缺省情况下，Kestone服务仍然监听这些端口。然而，本教程手动禁用keystone服务。

1. 运行以下命令来安装包。

   ```
   # yum install openstack-keystone httpd mod_wsgi
   ```

1. 编辑文件 `/etc/keystone/keystone.conf` 并完成如下动作：

   - 在``[DEFAULT]``部分，定义初始管理令牌的值：

     ```
     [DEFAULT]
     ...
     admin_token = ADMIN_TOKEN
     ```

     使用前面步骤生成的随机数替换``ADMIN_TOKEN`` 值。

   - 在 `[database]` 部分，配置数据库访问：

     ```
     [database]
     ...
     connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
     ```

     将``KEYSTONE_DBPASS``替换为你为数据库选择的密码。

   - 在``[token]``部分，配置Fernet UUID令牌的提供者。

     ```
     [token]
     ...
     provider = fernet
     ```

1. 初始化身份认证服务的数据库：

   ```
   # su -s /bin/sh -c "keystone-manage db_sync" keystone
   ```

   

    

   注解

   

   忽略输出中任何不推荐使用的信息。

2. 初始化Fernet keys：

   ```
   # keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
   ```

## 配置 Apache HTTP 服务器[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#configure-the-apache-http-server)

1. 编辑``/etc/httpd/conf/httpd.conf`` 文件，配置``ServerName`` 选项为控制节点：

   ```
   ServerName controller
   ```

2. 用下面的内容创建文件 `/etc/httpd/conf.d/wsgi-keystone.conf`。

   ```bash
   Listen 5000
   Listen 35357
   
   <VirtualHost *:5000>
       WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
       WSGIProcessGroup keystone-public
       WSGIScriptAlias / /usr/bin/keystone-wsgi-public
       WSGIApplicationGroup %{GLOBAL}
       WSGIPassAuthorization On
       ErrorLogFormat "%{cu}t %M"
       ErrorLog /var/log/httpd/keystone-error.log
       CustomLog /var/log/httpd/keystone-access.log combined
   
       <Directory /usr/bin>
           Require all granted
       </Directory>
   </VirtualHost>
   
   <VirtualHost *:35357>
       WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
       WSGIProcessGroup keystone-admin
       WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
       WSGIApplicationGroup %{GLOBAL}
       WSGIPassAuthorization On
       ErrorLogFormat "%{cu}t %M"
       ErrorLog /var/log/httpd/keystone-error.log
       CustomLog /var/log/httpd/keystone-access.log combined
   
       <Directory /usr/bin>
           Require all granted
       </Directory>
   </VirtualHost>
   ```

## 完成安装[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-install.html#finalize-the-installation)

- 启动 Apache HTTP 服务并配置其随系统启动：

  ```bash
  # systemctl enable httpd.service
  # systemctl start httpd.service
  ```

## 创建服务实体和API端点

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [先决条件](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#prerequisites)
  - [创建服务实体和API端点](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)

身份认证服务提供服务的目录和他们的位置。每个你添加到OpenStack环境中的服务在目录中需要一个 [*service*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-service) 实体和一些 [*API endpoints*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-api-endpoint) 。

## 先决条件[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#prerequisites)

默认情况下，身份认证服务数据库不包含支持传统认证和目录服务的信息。你必须使用:doc:keystone-install 章节中为身份认证服务创建的临时身份验证令牌用来初始化的服务实体和API端点。

你必须使用``–os-token``参数将认证令牌的值传递给:command:openstack 命令。类似的，你必须使用``–os-url`` 参数将身份认证服务的 URL传递给 **openstack** 命令或者设置OS_URL环境变量。本指南使用环境变量以缩短命令行的长度。



 

警告



因为安全的原因，，除非做必须的认证服务初始化，不要长时间使用临时认证令牌。

1. 配置认证令牌：

   ```bash
   $ export OS_TOKEN=ADMIN_TOKEN
   ```

   将``ADMIN_TOKEN``替换为你在 :doc:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)keystone-install`章节中生成的认证令牌。例如：

   ```bash
   $ export OS_TOKEN=294a4c8a8a475f9b9836
   ```

2. 配置端点URL：

   ```bash
   $ export OS_URL=http://controller:35357/v3
   ```

3. 配置认证 API 版本：

   ```bash
   $ export OS_IDENTITY_API_VERSION=3
   ```

## 创建服务实体和API端点[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-services.html#id1)

1. 在你的Openstack环境中，认证服务管理服务目录。服务使用这个目录来决定您的环境中可用的服务。

   创建服务实体和身份认证服务：

   ```bash
   $ openstack service create \
     --name keystone --description "OpenStack Identity" identity
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | OpenStack Identity               |
   | enabled     | True                             |
   | id          | 4ddaae90388b4ebc9d252ec2252d8d10 |
   | name        | keystone                         |
   | type        | identity                         |
   +-------------+----------------------------------+
   ```

   

    

   注解

   

   OpenStack 是动态生成 ID 的，因此您看到的输出会与示例中的命令行输出不相同。

2. 身份认证服务管理了一个与您环境相关的 API 端点的目录。服务使用这个目录来决定如何与您环境中的其他服务进行通信。

   OpenStack使用三个API端点变种代表每种服务：admin，internal和public。默认情况下，管理API端点允许修改用户和租户而公共和内部APIs不允许这些操作。在生产环境中，处于安全原因，变种为了服务不同类型的用户可能驻留在单独的网络上。对实例而言，公共API网络为了让顾客管理他们自己的云在互联网上是可见的。管理API网络在管理云基础设施的组织中操作也是有所限制的。内部API网络可能会被限制在包含OpenStack服务的主机上。此外，OpenStack支持可伸缩性的多区域。为了简单起见，本指南为所有端点变种和默认``RegionOne``区域都使用管理网络。

   创建认证服务的 API 端点：

   ```bash
   $ openstack endpoint create --region RegionOne \
     identity public http://controller:5000/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 30fff543e7dc4b7d9a0fb13791b78bf4 |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c8c0927262a45ad9066cfe70d46892c |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:5000/v3        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     identity internal http://controller:5000/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 57cfa543e7dc4b712c0ab137911bc4fe |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 6f8de927262ac12f6066cfe70d99ac51 |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:5000/v3        |
   +--------------+----------------------------------+
   
   $ openstack endpoint create --region RegionOne \
     identity admin http://controller:35357/v3
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 78c3dfa3e7dc44c98ab1b1379122ecb1 |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 34ab3d27262ac449cba6cfe704dbc11f |
   | service_name | keystone                         |
   | service_type | identity                         |
   | url          | http://controller:35357/v3       |
   +--------------+----------------------------------+
   ```

   

    

   注解

   

   每个添加到OpenStack环境中的服务要求一个或多个服务实体和三个认证服务中的API 端点变种。

## 创建域、项目、用户和角色

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

身份认证服务为每个OpenStack服务提供认证服务。认证服务使用 T [*domains*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-domain)， [*projects*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-project) (tenants)， :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id1)users<user>`和 :term:[`](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id3)roles<role>`的组合。

1. 创建域``default``：

   ```bash
   $ openstack domain create --description "Default Domain" default
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | Default Domain                   |
   | enabled     | True                             |
   | id          | e0353a670a9e496da891347c589539e9 |
   | name        | default                          |
   +-------------+----------------------------------+
   ```

2. 在你的环境中，为进行管理操作，创建管理的项目、用户和角色：

   - 创建 `admin` 项目：

     ```
     $ openstack project create --domain default \
       --description "Admin Project" admin
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Admin Project                    |
     | domain_id   | e0353a670a9e496da891347c589539e9 |
     | enabled     | True                             |
     | id          | 343d245e850143a096806dfaefa9afdc |
     | is_domain   | False                            |
     | name        | admin                            |
     | parent_id   | None                             |
     +-------------+----------------------------------+
     ```

     

      

     注解

     

     OpenStack 是动态生成 ID 的，因此您看到的输出会与示例中的命令行输出不相同。

   - 创建 `admin` 用户：

     ```bash
     $ openstack user create --domain default \
       --password-prompt admin
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | ac3377633149401296f6c0d92d79dc16 |
     | name      | admin                            |
     +-----------+----------------------------------+
     ```

   - 创建 `admin` 角色：

     ```bash
     $ openstack role create admin
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | cd2cb9a39e874ea69e5d4b896eb16128 |
     | name      | admin                            |
     +-----------+----------------------------------+
     ```

   - 添加``admin`` 角色到 `admin` 项目和用户上：

     ```bash
     $ openstack role add --project admin --user admin admin
     ```

     

      

     注解

     

     这个命令执行后没有输出。

     

      

     注解

     

     你创建的任何角色必须映射到每个OpenStack服务配置文件目录下的``policy.json`` 文件中。默认策略是给予“admin“角色大部分服务的管理访问权限。更多信息，参考 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-users.html#id1)Operations Guide - Managing Projects and Users <http://docs.openstack.org/ops-guide/ops-projects-users.html>`__.

3. 本指南使用一个你添加到你的环境中每个服务包含独有用户的service 项目。创建``service``项目：

   ```bash
   $ openstack project create --domain default \
     --description "Service Project" service
   +-------------+----------------------------------+
   | Field       | Value                            |
   +-------------+----------------------------------+
   | description | Service Project                  |
   | domain_id   | e0353a670a9e496da891347c589539e9 |
   | enabled     | True                             |
   | id          | 894cdfa366d34e9d835d3de01e752262 |
   | is_domain   | False                            |
   | name        | service                          |
   | parent_id   | None                             |
   +-------------+----------------------------------+
   ```

4. 常规（非管理）任务应该使用无特权的项目和用户。作为例子，本指南创建 `demo` 项目和用户。

   - 创建``demo`` 项目：

     ```bash
     $ openstack project create --domain default \
       --description "Demo Project" demo
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | Demo Project                     |
     | domain_id   | e0353a670a9e496da891347c589539e9 |
     | enabled     | True                             |
     | id          | ed0b60bf607743088218b0a533d5943f |
     | is_domain   | False                            |
     | name        | demo                             |
     | parent_id   | None                             |
     +-------------+----------------------------------+
     ```

     

      

     注解

     

     当为这个项目创建额外用户时，不要重复这一步。

   - 创建``demo`` 用户：

     ```bash
     $ openstack user create --domain default \
       --password-prompt demo
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | 58126687cbcc4888bfa9ab73a2256f27 |
     | name      | demo                             |
     +-----------+----------------------------------+
     ```

   - 创建 `user` 角色：

     ```bash
     $ openstack role create user
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | None                             |
     | id        | 997ce8d05fc143ac97d83fdfb5998552 |
     | name      | user                             |
     +-----------+----------------------------------+
     ```

   - 添加 `user``角色到 ``demo` 项目和用户：

     ```bash
     $ openstack role add --project demo --user demo user
     ```

     

      

     注解

     

     这个命令执行后没有输出。



 

注解



你可以重复此过程来创建额外的项目和用户。

​                      

## 验证操作

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- 

在安装其他服务之前确认身份认证服务的操作。



 

注解



在控制节点上执行这些命令。

1. 因为安全性的原因，关闭临时认证令牌机制：

   编辑 `/etc/keystone/keystone-paste.ini` 文件，从``[pipeline:public_api]``，`[pipeline:admin_api]``和``[pipeline:api_v3]``部分删除``admin_token_auth` 。

1. 重置``OS_TOKEN``和``OS_URL`` 环境变量：

   ```bash
   $ unset OS_TOKEN OS_URL
   ```

2. 作为 `admin` 用户，请求认证令牌：

   ```bash
   $ openstack --os-auth-url http://controller:35357/v3 \
     --os-project-domain-name default --os-user-domain-name default \
     --os-project-name admin --os-username admin token issue
   Password:
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:14:07.056119Z                                     |
   | id         | gAAAAABWvi7_B8kKQD9wdXac8MoZiQldmjEO643d-e_j-XXq9AmIegIbA7UHGPv |
   |            | atnN21qtOMjCFWX7BReJEQnVOAj3nclRQgAYRsfSU_MrsuWb4EDtnjU7HEpoBb4 |
   |            | o6ozsA_NmFWEpLeKy0uNn_WeKbAhYygrsmQGA49dclHVnz-OMVLiyM9ws       |
   | project_id | 343d245e850143a096806dfaefa9afdc                                |
   | user_id    | ac3377633149401296f6c0d92d79dc16                                |
   +------------+-----------------------------------------------------------------+
   ```

   

    

   注解

   

   这个命令使用``admin``用户的密码。

3. 作为``demo`` 用户，请求认证令牌：

   ```bash
   $ openstack --os-auth-url http://controller:5000/v3 \
     --os-project-domain-name default --os-user-domain-name default \
     --os-project-name demo --os-username demo token issue
   Password:
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:15:39.014479Z                                     |
   | id         | gAAAAABWvi9bsh7vkiby5BpCCnc-JkbGhm9wH3fabS_cY7uabOubesi-Me6IGWW |
   |            | yQqNegDDZ5jw7grI26vvgy1J5nCVwZ_zFRqPiz_qhbq29mgbQLglbkq6FQvzBRQ |
   |            | JcOzq3uwhzNxszJWmzGC7rJE_H0A_a3UFhqv8M4zMRYSbS2YF0MyFmp_U       |
   | project_id | ed0b60bf607743088218b0a533d5943f                                |
   | user_id    | 58126687cbcc4888bfa9ab73a2256f27                                |
   +------------+-----------------------------------------------------------------+
   ```

   

    

   注解

   

   这个命令使用``demo`` 用户的密码和API端口5000，这样只会允许对身份认证服务API的常规（非管理）访问。

## 创建 OpenStack 客户端环境脚本

​                              

updated: 2017-06-12 11:14

##### [Contents](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)

- - [创建脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#creating-the-scripts)
  - [使用脚本](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#using-the-scripts)

前一节中使用环境变量和命令选项的组合通过``openstack``客户端与身份认证服务交互。为了提升客户端操作的效率，OpenStack支持简单的客户端环境变量脚本即OpenRC 文件。这些脚本通常包含客户端所有常见的选项，当然也支持独特的选项。更多信息，请参考`OpenStack End User Guide <http://docs.openstack.org/user-guide/common/ cli_set_environment_variables_using_openstack_rc.html>`__。

## 创建脚本[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#creating-the-scripts)

创建 `admin` 和 [``](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#id1)demo``项目和用户创建客户端环境变量脚本。本指南的接下来的部分会引用这些脚本，为客户端操作加载合适的的凭证。

1. 编辑文件 `admin-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=default
   export OS_USER_DOMAIN_NAME=default
   export OS_PROJECT_NAME=admin
   export OS_USERNAME=admin
   export OS_PASSWORD=ADMIN_PASS
   export OS_AUTH_URL=http://controller:35357/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `ADMIN_PASS` 替换为你在认证服务中为 `admin` 用户选择的密码。

2. 编辑文件 `demo-openrc` 并添加如下内容：

   ```bash
   export OS_PROJECT_DOMAIN_NAME=default
   export OS_USER_DOMAIN_NAME=default
   export OS_PROJECT_NAME=demo
   export OS_USERNAME=demo
   export OS_PASSWORD=DEMO_PASS
   export OS_AUTH_URL=http://controller:5000/v3
   export OS_IDENTITY_API_VERSION=3
   export OS_IMAGE_API_VERSION=2
   ```

   将 `DEMO_PASS` 替换为你在认证服务中为 `demo` 用户选择的密码。

## 使用脚本[¶](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/keystone-openrc.html#using-the-scripts)

使用特定租户和用户运行客户端，你可以在运行之前简单地加载相关客户端脚本。例如：

1. 加载``admin-openrc``文件来身份认证服务的环境变量位置和``admin``项目和用户证书：

   ```bash
   $ . admin-openrc
   ```

2. 请求认证令牌:

   ```bash
   $ openstack token issue
   +------------+-----------------------------------------------------------------+
   | Field      | Value                                                           |
   +------------+-----------------------------------------------------------------+
   | expires    | 2016-02-12T20:44:35.659723Z                                     |
   | id         | gAAAAABWvjYj-Zjfg8WXFaQnUd1DMYTBVrKw4h3fIagi5NoEmh21U72SrRv2trl |
   |            | JWFYhLi2_uPR31Igf6A8mH2Rw9kv_bxNo1jbLNPLGzW_u5FC7InFqx0yYtTwa1e |
   |            | eq2b0f6-18KZyQhs7F3teAta143kJEWuNEYET-y7u29y0be1_64KYkM7E       |
   | project_id | 343d245e850143a096806dfaefa9afdc                                |
   | user_id    | ac3377633149401296f6c0d92d79dc16                                |
   +------------+-----------------------------------------------------------------+
   ```

​                      