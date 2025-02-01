# Packstack

Packstack is an OpenStack deployment tool intended to **install Proof of Concept small environments in a quick and easy way using the RDO distribution on a CentOS Stream hosts**.  For these  cases, you can rely on other recommended tools  such as [TripleO](https://tripleo-docs.readthedocs.io/en/latest/index.html) for an OpenStack Zed or earlier release, [Kolla](https://docs.openstack.org/kolla/latest/) or  [Openstack-Ansible](https://docs.openstack.org/openstack-ansible/latest/).
Packstack 是一个 OpenStack 部署工具，旨在使用 CentOS Stream 主机上的 RDO  发行版，以快速简便的方式安装概念验证小型环境。生产功能，如高可用性、OpenStack 升级或其他 day-2 操作，不在Packstack的范围内。对于这些情况，可以依赖其他推荐的工具，例如用于 OpenStack Zed 或更早版本的 TripleO、Kolla 或 Openstack-Ansible。

使用Packstack安装实用程序在一个节点上启动概念验证云。

These instructions apply to the following Release and Operating Systems -  **Victoria, Wallaby, Xena and Yoga** on CentOS Stream 8, and **Yoga, Zed and Antelope** on CentOS Stream 9.
这些指示适用于以下发行版和操作系统 - CentOS Stream 8 上的 Victoria、Wallaby、Xena 和 Yoga，以及 CentOS Stream 9 上的 Yoga、Zed 和 Antelope。

## WARNING 警告

**Read** this document in full, **then** choose your install path:
完整阅读此文档，然后选择您的安装路径：

Don't just start typing commands at **Summary for the impatient** and proceed downwards through the page.
不要只是在“摘要”中为不耐烦的人键入命令，然后继续向下浏览页面。

## Summary for the impatient 不耐烦的总结

If you are using non-English locale make sure your `/etc/environment` is populated:
如果您使用的是非英语区域设置，请确保已 `/etc/environment` 填充：

```
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
```

If your system meets all the prerequisites mentioned below, proceed with running the following commands.
如果您的系统满足下面提到的所有先决条件，请继续运行以下命令。

- On CentOS Stream 8:
  在 CentOS Stream 8 上：

  ```
  $ sudo dnf update -y
  $ sudo dnf config-manager --enable powertools
  $ sudo dnf install -y centos-release-openstack-yoga # Replace yoga by the desired release name
  $ sudo dnf update -y
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

- On CentOS Stream 9:
  在 CentOS Stream 9 上：

  ```
  $ sudo dnf update -y
  $ sudo dnf config-manager --enable crb
  $ sudo dnf install -y centos-release-openstack-bobcat
  $ sudo setenforce 0
  $ sudo dnf update -y
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

**Note for RHEL:** Although it is expected that RDO works fine on RHEL, it is currently not tested in RHEL OS.
RHEL 注意事项：尽管预计 RDO 在 RHEL 上工作正常，但目前尚未在 RHEL OS 中进行测试。

- On RHEL 8: 在 RHEL 8 上：

  ```
  $ sudo dnf install -y https://www.rdoproject.org/repos/rdo-release.el8.rpm
  $ sudo dnf update -y
  $ subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

## Step 0: 先决条件

### 软件

CentOS Stream 8 是最低推荐版本，或基于 RHEL 的 Linux 发行版（如 Red Hat Enterprise  Linux、Scientific Linux 等）的等效版本。提供了用于 x86_64、aarch64 和 ppc64le 架构的软件包，尽管大多数测试是在 x86_64 上完成的。

### 硬件

计算机至少具有 16GB RAM、具有硬件虚拟化扩展的处理器和至少一个网络适配器。

### Hostname 主机名

Name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.
使用完全限定域名而不是短格式名称命名主机，以避免 Packstack 出现 DNS 问题。

### Network 网络

If you plan on having **external** network access to the server and instances, this is a good moment to  properly configure your network settings. A static IP address to your  network card, and disabling NetworkManager are good ideas.
如果您计划对服务器和实例进行外部网络访问，则这是正确配置网络设置的好时机。网卡的静态 IP 地址和禁用 NetworkManager 是好主意。

在 CentOS Stream 8/RHEL 8 上，network-scripts 已弃用，默认情况下未安装，因此需要显式安装。

```bash
dnf install network-scripts
```

禁用 firewalld 和 NetworkManager

```bash
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network
```

## Step 1: 软件存储库

在 CentOS Stream 8 上，首先需要启用该 `powertools` 仓库。然后， `Extras` 存储库提供启用 OpenStack 存储库的 RPM。 `Extras` 在 CentOS 8 上默认启用，因此只需安装 RPM 即可设置 OpenStack 存储库：

```bash
dnf config-manager --enable powertools
dnf install centos-release-openstack-yoga
```

在 CentOS Stream 9 上，首先需要启用 `crb` 。然后， `extras-common` 存储库提供启用 OpenStack 存储库的 RPM。它默认在 CentOS Stream 9 上启用，因此你只需安装 RPM 即可设置 OpenStack 软件库：

```bash
dnf config-manager --enable crb
dnf install centos-release-openstack-bobcat
```

在 RHEL 8 上，安装 RDO 存储库 RPM 以设置 Openstack 存储库，然后您必须启用 `subscription-manager` 的 `codeready-builder` 选项：

```bash
dnf install https://www.rdoproject.org/repos/rdo-release.el8.rpm
subscription-manager repo --enable codeready-builder-for-rhel-8-x86_64-rpms
```

更新您当前的软件包：

```bash
dnf update
```

## Step 2: 安装 Packstack Installer

```bash
dnf install openstack-packstack
```

## Step 3: 禁用 selinux 强制模式

CentOS Stream 9 中的 selinux 策略和 rabbitmq 存在已知问题。禁用 selinux 强制模式：

```bash
setenforce 0
```

## Step 4: 运行 Packstack 安装 OpenStack

Packstack 省去了手动设置 OpenStack 的工作。它提供了一组选项，用于为每个安装指定所需的服务和配置。您可以使用以下命令列出所有可用参数：

```bash
packstack --help
```

对于一个具有默认选项、简单的单节点 OpenStack 部署，请运行以下命令：

```bash
packstack --allinone
```

The Packstack command line interface accepts an answers file as a mechanism to specify the parameters. 
Packstack 命令行界面接受应答文件作为指定参数的机制。可以使用以下命令创建基本应答文件：

```bash
packstack --gen-answer-file
```

然后可以通过使用 `--answer-file` 选项来使用：

```bash
packstack --answer-file=<path to the answers file>
```

If you have run Packstack previously, there will be a file in your home directory named something like `packstack-answers-20130722-153728.txt` You will probably want to use that file again, using the `--answer-file` option, so that any passwords you have already set (for example, mysql) will be reused.
如果之前运行过 Packstack，主目录中将有一个名为 `packstack-answers-20130722-153728.txt` 您可能希望再次使用该文件的文件，使用 `--answer-file` 该选项，以便您已经设置的任何密码（例如，mysql）将被重用。

安装程序将要求您输入要在网络上安装的每个主机节点的 root 密码，以启用主机的远程配置，以便它可以使用 Puppet 远程配置每个节点。

完成该过程后，您可以通过转到 `http://$YOURIP/dashboard` 登录到 OpenStack Web 界面 Horizon。用户名是 `admin` 。密码可以在控制节点 `/root` 目录中的文件 `keystonerc_admin` 中找到。

# Adding a compute node 添加计算节点

Expanding your single-node OpenStack cloud to include a second compute node  requires a second network adapter, if you want to separate the Neutron  tenant network traffic.
如果要分离 Neutron 租户网络流量，则扩展单节点 OpenStack 云以包含第二个计算节点需要第二个网络适配器。

### Edit the answer file 编辑答案文件

First, edit the "answer file" generated during the initial Packstack setup.  You'll find the file in the directory from which you ran Packstack.
首先，编辑在初始 Packstack 设置期间生成的“应答文件”。您将在运行 Packstack 的目录中找到该文件。

**Note:** By default, `$youranswerfile` is called `packstack-answer-$date-$time.txt`.
注意：默认情况下， `$youranswerfile` 称为 `packstack-answer-$date-$time.txt` 。

```
$EDITOR $youranswerfile
```

Replace `$EDITOR` with your preferred editor.
替换 `$EDITOR` 为您喜欢的编辑器。

#### Adjust network card names 调整网卡名称

You need to set the following option to `eth1` or whatever name your network card uses.
您需要将以下选项设置为 `eth1` 网卡使用的任何名称。

- `CONFIG_NEUTRON_OVN_TUNNEL_IF`, if you set `CONFIG_NEUTRON_L2_AGENT` to `ovn` (default option since the Stein release).
   `CONFIG_NEUTRON_OVN_TUNNEL_IF` ，如果设置为 `CONFIG_NEUTRON_L2_AGENT` `ovn` （自 Stein 版本以来的默认选项）。
- `CONFIG_NEUTRON_OVS_TUNNEL_IF`, if you set `CONFIG_NEUTRON_L2_AGENT` to `openvswitch` (default option for Rocky and earlier releases).
   `CONFIG_NEUTRON_OVS_TUNNEL_IF` ，如果设置为 `CONFIG_NEUTRON_L2_AGENT` `openvswitch` （Rocky 和更早版本的默认选项）。

Note this is not mandatory, but it may be a good idea to separate tunnel traffic through a separate interface.
请注意，这不是强制性的，但通过单独的接口分离隧道流量可能是个好主意。

Your second NIC may have a different name. You can find the names of your devices by running:
第二个 NIC 可能具有不同的名称。您可以通过运行以下命令来查找设备的名称：

```
ip l | grep '^\S' | cut -d: -f2
```

#### Change IP addresses 更改 IP 地址

If you want to have your new node as the only compute node, change the value for `CONFIG_COMPUTE_HOSTS` from the value of your first host IP address to the value of your  second host IP address. You can also have both systems as compute nodes, if you add them as a comma-separated list:
如果要将新节点作为唯一的计算节点，请将 的 `CONFIG_COMPUTE_HOSTS` 值从第一个主机 IP 地址的值更改为第二个主机 IP 地址的值。如果将这两个系统添加为逗号分隔列表，也可以将它们作为计算节点：

```
CONFIG_COMPUTE_HOSTS=<serverIP>,<serverIP>,...
```

Ensure that the key `CONFIG_NETWORK_HOSTS` exists and is set to the IP address of your first host.
确保密钥 `CONFIG_NETWORK_HOSTS` 存在并设置为第一台主机的 IP 地址。

#### Skip installing on an already existing servers 跳过在现有服务器上的安装

In case you do not want to apply any modification on the already  configured servers, add the following parameter to the "answer file":
如果您不想在已配置的服务器上应用任何修改，请将以下参数添加到“应答文件”中：

```
EXCLUDE_SERVERS=<serverIP>,<serverIP>,...
```

You may not want to exclude the existing server if it will stay as a  compute node, since live migration between compute nodes needs to add  the SSH keys to each of them.
如果现有服务器将保留为计算节点，则可能不希望将其排除在外，因为计算节点之间的实时迁移需要向每个节点添加 SSH 密钥。

### Re-run Packstack with the new values 使用新值重新运行 Packstack

Run Packstack again, specifying your modified "answer file":
再次运行 Packstack，指定修改后的“应答文件”：

```
packstack --answer-file=$youranswerfile
```

Packstack will prompt you for the root password for each of your nodes.
Packstack 将提示您输入每个节点的 root 密码。

# Neutron with existing external network 具有现有外部网络的 Neutron

Many people have asked how to use packstack –allinone with an existing  external network. This method should allow any machine on the network to be able to access launched instances via their floating IPs. Also, at  the end of this message, there are some ideas for making this process  better that I thought we could discuss.
许多人问如何在现有的外部网络上使用 packstack –allinone。此方法应允许网络上的任何计算机都能够通过其浮动 IP 访问已启动的实例。此外，在这条消息的末尾，有一些想法可以使这个过程变得更好，我认为我们可以讨论一下。

These instructions have been tested on CentOS 7 and CentOS 8.
这些指令已在 CentOS 7 和 CentOS 8 上测试。

Initially, follow the [Quickstart](https://www.rdoproject.org/install/packstack/) but stop when you see the first "packstack –allinone" at Step 3, instead do:
最初，请按照快速入门进行操作，但在步骤 3 中看到第一个“packstack –allinone”时停止操作，而是执行以下操作：

```
# packstack --allinone --provision-demo=n --os-neutron-ovn-bridge-mappings=extnet:br-ex --os-neutron-ovn-bridge-interfaces=br-ex:eth0
```

Since stein release packstack runs neutron with **ovn** backend by default, if you want to deploy with **ovs** as neutron backend, instead do:
由于 stein release packstack 默认使用 ovn 后端运行 neutron，如果您想使用 ovs 作为 neutron 后端进行部署，请改为：

```
# packstack --allinone --os-neutron-l2-agent=openvswitch --os-neutron-ml2-mechanism-drivers=openvswitch --os-neutron-ml2-tenant-network-types=vxlan --os-neutron-ml2-type-drivers=vxlan,flat --provision-demo=n --os-neutron-ovs-bridge-mappings=extnet:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:eth0
```

This will define a logical name for our external physical L2 segment as  "extnet". Later we will reference to our provider network by the name  when creating external networks.
这将为我们的外部物理 L2 段定义一个逻辑名称为“extnet”。稍后，我们将在创建外部网络时按名称引用我们的提供商网络。

The command also adds 'flat' network type to the list of types supported by the installation. This is needed when your provider network is a simple flat network (the most common setup for PoCs). If you use a VLAN  segment for external connectivity, you should add 'vlan' to the list of  type drivers.
该命令还会将“平面”网络类型添加到安装支持的类型列表中。当您的提供商网络是简单的平面网络（PoC 最常见的设置）时，这是必需的。如果使用 VLAN 分段进行外部连接，则应将“vlan”添加到类型驱动程序列表中。

Note: the command is currently broken for Mitaka:  https://bugzilla.redhat.com/show_bug.cgi?id=1316856, please skip  –os-neutron-ovs-bridge-interfaces=br-ex:eth0 argument for now.
注意：Mitaka的命令目前已损坏：https://bugzilla.redhat.com/show_bug.cgi?id=1316856，请暂时跳过–os-neutron-ovs-bridge-interfaces=br-ex：eth0参数。

(There's an alternate method using packstack –allinone –provision-all-in-one-ovs-bridge=n, but it's more complicated)
（还有另一种使用 packstack –allinone –provision-all-in-one-ovs-bridge=n 的方法，但它更复杂）

After completion, given a single machine with a current IP of 192.168.122.212/24 via DHCP with gateway of 192.168.122.1:
完成后，给定一台当前 IP 为 192.168.122.212/24 的计算机，通过 DHCP 和网关为 192.168.122.1：

Make /etc/sysconfig/network-scripts/ifcfg-br-ex resemble:
使 /etc/sysconfig/network-scripts/ifcfg-br-ex 类似于：

```
DEVICE=br-ex
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
IPADDR=192.168.122.212 # Old eth0 IP since we want the network restart to not 
                       # kill the connection, otherwise pick something outside your dhcp range
NETMASK=255.255.255.0  # your netmask
GATEWAY=192.168.122.1  # your gateway
DNS1=192.168.122.1     # your nameserver
ONBOOT=yes
```

The file above will move the network parameters from eth0 to br-ex.
上面的文件会将网络参数从 eth0 移动到 br-ex。

Make /etc/sysconfig/network-scripts/ifcfg-eth0 resemble (no BOOTPROTO!):
使 /etc/sysconfig/network-scripts/ifcfg-eth0 类似（没有 BOOTPROTO！

Note: if on Centos7, the file could be /etc/sysconfig/network-scripts/ifcfg-enp2s0 and DEVICE should be enp2s0
注意：如果在 Centos7 上，文件可以是 /etc/sysconfig/network-scripts/ifcfg-enp2s0，而 DEVICE 应该是 enp2s0

```
DEVICE=eth0
TYPE=OVSPort
DEVICETYPE=ovs
OVS_BRIDGE=br-ex
ONBOOT=yes
```

It is also possible to use a bond. In that case /etc/sysconfig/network-scripts/ifcfg-bond0 may look like this:
也可以使用债券。在这种情况下，/etc/sysconfig/network-scripts/ifcfg-bond0 可能如下所示：

```
DEVICE=bond0
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-ex
ONBOOT=yes
BONDING_MASTER=yes
BONDING_OPTS="mode=802.3ad"
```

This means, we will bring up the interface and plug it into br-ex OVS bridge as a port, providing the uplink connectivity.
这意味着，我们将调出接口并将其作为端口插入 br-ex OVS 网桥，从而提供上行链路连接。

Restart the network service
重新启动网络服务

```
# reboot
```

or, alternatively: 或者，或者：

```
# service network restart
```

Now, create the external network with Neutron.
现在，使用 Neutron 创建外部网络。

```
# . keystonerc_admin
# neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external
```

Please note: "extnet" is the L2 segment we defined with –os-neutron-ovs-bridge-mappings above.
请注意：“extnet”是我们在上面用 –os-neutron-ovs-bridge-mappings 定义的 L2 段。

You need to create a public subnet with an allocation range outside of your external DHCP range and set the gateway to the default gateway of the  external network.
您需要创建一个分配范围超出外部 DHCP 范围的公有子网，并将网关设置为外部网络的默认网关。

Please note: 192.168.122.1/24 is the router and CIDR we defined in  /etc/sysconfig/network-scripts/ifcfg-br-ex for external connectivity.
请注意：192.168.122.1/24 是我们在 /etc/sysconfig/network-scripts/ifcfg-br-ex 中定义的用于外部连接的路由器和 CIDR。

```
# neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.122.10,end=192.168.122.20 \
                        --gateway=192.168.122.1 external_network 192.168.122.0/24
```

Get a cirros image, not provisioned without demo provisioning:
获取 cirros 映像，无需演示预配即可预置：

```
curl -L http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img | glance \
         image-create --name='cirros image' --visibility=public --container-format=bare --disk-format=qcow2
```

That's all you need to do from admin perspective to allow your users to  connect their private networks to the outside world. Now let's switch to the user.
从管理员的角度来看，这就是您需要做的所有事情，以允许您的用户将其专用网络连接到外部世界。现在让我们切换到用户。

Since you haven't created a user yet:
由于您尚未创建用户：

```
openstack project create --enable internal
openstack user create --project internal --password foo --email bar@corp.com --enable internal
```

Now, let's switch to the newly created user:
现在，让我们切换到新创建的用户：

```
# export OS_USERNAME=internal
# export OS_TENANT_NAME=internal
# export OS_PASSWORD=foo
```

Then create a router and set its gateway using the external network created by the admin in one of previous steps:
然后，使用管理员在上述步骤之一中创建的外部网络创建路由器并设置其网关：

```
# neutron router-create router1
# neutron router-gateway-set router1 external_network
```

Now create a private network and a subnet in it, since demo provisioning has been disabled:
现在创建一个专用网络并在其中创建一个子网，因为演示配置已被禁用：

```
# neutron net-create private_network
# neutron subnet-create --name private_subnet private_network 192.168.100.0/24
```

Finally, connect your new private network to the public network through the router, which will provide floating IP addresses.
最后，通过路由器将新的专用网络连接到公共网络，这将提供浮动 IP 地址。

```
# neutron router-interface-add router1 private_subnet
```

Easiest way to the network and to launch instances is via horizon, which was set up by packstack.
进入网络和启动实例的最简单方法是通过 horizon，它是由 packstack 设置的。

## See also 另请参阅

Watch this video for a demonstration of how to use DHCP on the bridge, including cloning the MAC address from eth0: https://www.youtube.com/watch?v=8zFQG5mKwPk
观看此视频，了解如何在网桥上使用 DHCP，包括从 eth0 克隆 MAC 地址： https://www.youtube.com/watch?v=8zFQG5mKwPk
