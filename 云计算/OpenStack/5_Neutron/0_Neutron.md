# Neutron

[TOC]

## 概述

Neutron 服务提供虚拟机实例对网络的连接，其中 plug-ins 能够提供对多种网络设备和软件的支持，使 OpenStack 环境的构建和部署具备更多的灵活性。

## 组件

* neutron-server

  接受 API 请求并将其路由到相应的 OpenStack Networking 插件以执行操作。

* OpenStack Networking plug-in 和 agent

  Plug and unplug ports, create networks or subnets, and provide IP addressing. These plug-ins and agents differ depending on the vendor and technologies used in the particular cloud. OpenStack Networking ships with plug-ins and agents for Cisco virtual and physical switches, NEC OpenFlow products, Open vSwitch, Linux bridging, and the VMware NSX product. 插拔端口，创建网络或子网，并提供 IP 寻址。这些插件和代理因特定云中使用的供应商和技术而异。OpenStack Networking 附带了适用于 Cisco  虚拟和物理交换机、NEC OpenFlow 产品、Open vSwitch、Linux 桥接和 VMware NSX 产品的插件和代理。 The common agents are L3 (layer 3), DHCP (dynamic host IP addressing), and a plug-in agent. 常见的代理包括 L3（第 3 层）、DHCP（动态主机 IP 寻址）和插件代理。

  创建端口（Ports）、网络（Networks）和子网（Subnets），提供 IP 地址。plug-in 和 agent 根据不同的厂商和技术而应用于不同的云环境中。

  plug-in 一般支持：

  * Cisco Virtual and Physical Switches
  * NEC OpenFlow Products
  * Open vSwitch
  * Linux Bridging
  * VMware NSX Product

  agent 包括：

  * L3（Layer 3）
  * DHCP
  * plug-in agent

* Messaging queue 

  在 neutron-server 和 angent 之间路由信息，同时也会作为一个数据库存储 plug-in 的网络连接状态。

## 网络概念

​                                          

OpenStack Networking (neutron) manages all networking facets for the Virtual Networking Infrastructure (VNI) and the access layer aspects of the Physical Networking Infrastructure (PNI) in your OpenStack environment. OpenStack Networking enables projects to create advanced virtual network topologies which may include services such as a firewall, and a virtual private network (VPN).
OpenStack Networking （neutron） 管理 OpenStack 环境中虚拟网络基础设施 （VNI） 的所有网络方面和物理网络基础设施  （PNI） 的访问层方面。OpenStack Networking 使项目能够创建高级虚拟网络拓扑，其中可能包括防火墙和虚拟专用网络 （VPN） 等服务。

Networking provides networks, subnets, and routers as object abstractions. Each abstraction has functionality that mimics its physical counterpart: networks contain subnets, and routers route traffic between different subnets and networks.
网络提供网络、子网和路由器作为对象抽象。每个抽象都具有模仿其物理对应物的功能：网络包含子网，路由器在不同子网和网络之间路由流量。

Any given Networking set up has at least one external network. Unlike the other networks, the external network is not merely a virtually defined network. Instead, it represents a view into a slice of the physical, external network accessible outside the OpenStack installation. IP addresses on the external network are accessible by anybody physically on the outside network.
任何给定的网络设置都至少有一个外部网络。与其他网络不同，外部网络不仅仅是一个虚拟定义的网络。相反，它表示在OpenStack安装外部可访问的物理外部网络切片的视图。外部网络上的任何人都可以访问外部网络上的 IP 地址。

In addition to external networks, any Networking set up has one or more internal networks. These software-defined networks connect directly to the VMs. Only the VMs on any given internal network, or those on subnets connected through interfaces to a similar router, can access VMs connected to that network directly.
除了外部网络之外，任何网络设置都有一个或多个内部网络。这些软件定义的网络直接连接到 VM。只有任何给定内部网络上的 VM 或通过接口连接到类似路由器的子网上的 VM 才能直接访问连接到该网络的 VM。

For the outside network to access VMs, and vice versa, routers between the networks are needed. Each router has one gateway that is connected to an external network and one or more interfaces connected to internal networks. Like a physical router, subnets can access machines on other subnets that are connected to the same router, and machines can access the outside network through the gateway for the router.
要使外部网络访问 VM，反之亦然，需要网络之间的路由器。每个路由器都有一个连接到外部网络的网关，以及连接到内部网络的一个或多个接口。与物理路由器一样，子网可以访问连接到同一路由器的其他子网上的计算机，并且计算机可以通过路由器的网关访问外部网络。

Additionally, you can allocate IP addresses on external networks to ports on the internal network. Whenever something is connected to a subnet, that connection is called a port. You can associate external network IP addresses with ports to VMs. This way, entities on the outside network can access VMs.
此外，还可以将外部网络上的 IP 地址分配给内部网络上的端口。每当某物连接到子网时，该连接都称为端口。可以将外部网络 IP 地址与 VM 的端口相关联。这样，外部网络上的实体就可以访问 VM。

Networking also supports *security groups*. Security groups enable administrators to define firewall rules in groups. A VM can belong to one or more security groups, and Networking applies the rules in those security groups to block or unblock ports, port ranges, or traffic types for that VM.
网络还支持安全组。安全组使管理员能够在组中定义防火墙规则。一个 VM 可以属于一个或多个安全组，网络应用这些安全组中的规则来阻止或取消阻止该 VM 的端口、端口范围或流量类型。

Each plug-in that Networking uses has its own concepts. While not vital to operating the VNI and OpenStack environment, understanding these concepts can help you set up Networking. All Networking installations use a core plug-in and a security group plug-in (or just the No-Op security group plug-in).
网络使用的每个插件都有自己的概念。虽然对操作 VNI 和 OpenStack 环境并不重要，但了解这些概念可以帮助您设置网络。所有网络安装都使用核心插件和安全组插件（或仅使用无操作安全组插件）。

# 安装和配置控制器节点

​                                          

## Prerequisites[¶](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#prerequisites) 先决条件 ¶

Before you configure the OpenStack Networking (neutron) service, you must create a database, service credentials, and API endpoints.
在配置 OpenStack Networking （neutron） 服务之前，必须创建数据库、服务凭证和 API 端点。

1. To create the database, complete these steps:
   若要创建数据库，请完成以下步骤：

   - Use the database access client to connect to the database server as the `root` user:
     使用数据库访问客户端以 `root` 用户身份连接到数据库服务器：

     ```
     $ mysql -u root -p
     ```

   - Create the `neutron` database:
     创建 `neutron` 数据库：

     ```
     MariaDB [(none)] CREATE DATABASE neutron;
     ```

   - Grant proper access to the `neutron` database, replacing `NEUTRON_DBPASS` with a suitable password:
     授予对 `neutron` 数据库的适当访问权限，并替换 `NEUTRON_DBPASS` 为合适的密码：

     ```
     MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
       IDENTIFIED BY 'NEUTRON_DBPASS';
     MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
       IDENTIFIED BY 'NEUTRON_DBPASS';
     ```

   - Exit the database access client.
     退出数据库访问客户端。

2. Source the `admin` credentials to gain access to admin-only CLI commands:
   获取 `admin` 凭据以获取对仅限管理员的 CLI 命令的访问权限：

   ```
   $ . admin-openrc
   ```

3. To create the service credentials, complete these steps:
   要创建服务凭据，请完成以下步骤：

   - Create the `neutron` user:
     创建 `neutron` 用户：

     ```
     $ openstack user create --domain default --password-prompt neutron
     
     User Password:
     Repeat User Password:
     +---------------------+----------------------------------+
     | Field               | Value                            |
     +---------------------+----------------------------------+
     | domain_id           | default                          |
     | enabled             | True                             |
     | id                  | fdb0f541e28141719b6a43c8944bf1fb |
     | name                | neutron                          |
     | options             | {}                               |
     | password_expires_at | None                             |
     +---------------------+----------------------------------+
     ```

   - Add the `admin` role to the `neutron` user:
     将 `admin` 角色添加到 `neutron` 用户：

     ```
     $ openstack role add --project service --user neutron admin
     ```

     

      

     Note 注意

     

     This command provides no output.
     此命令不提供任何输出。

   - Create the `neutron` service entity:
     创建 `neutron` 服务实体：

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

4. Create the Networking service API endpoints:
   创建网络服务 API 端点：

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

## Configure networking options[¶](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#configure-networking-options) 配置网络选项 ¶

You can deploy the Networking service using one of two architectures represented by options 1 and 2.
可以使用选项 1 和 2 表示的两种体系结构之一来部署网络服务。

Option 1 deploys the simplest possible architecture that only supports attaching instances to provider (external) networks. No self-service (private) networks, routers, or floating IP addresses. Only the `admin` or other privileged user can manage provider networks.
选项 1 部署最简单的架构，仅支持将实例附加到提供商（外部）网络。没有自助服务（专用）网络、路由器或浮动 IP 地址。只有 `admin` 或其他特权用户才能管理提供商网络。

Option 2 augments option 1 with layer-3 services that support attaching instances to self-service networks. The `demo` or other unprivileged user can manage self-service networks including routers that provide connectivity between self-service and provider networks. Additionally, floating IP addresses provide connectivity to instances using self-service networks from external networks such as the Internet.
选项 2 通过支持将实例附加到自助服务网络的第 3 层服务来增强选项 1。或其他 `demo` 非特权用户可以管理自助服务网络，包括在自助服务和提供商网络之间提供连接的路由器。此外，浮动 IP 地址使用自助服务网络从外部网络（如 Internet）提供与实例的连接。

Self-service networks typically use overlay networks. Overlay network protocols such as VXLAN include additional headers that increase overhead and decrease space available for the payload or user data. Without knowledge of the virtual network infrastructure, instances attempt to send packets using the default Ethernet maximum transmission unit (MTU) of 1500 bytes. The Networking service automatically provides the correct MTU value to instances via DHCP. However, some cloud images do not use DHCP or ignore the DHCP MTU option and require configuration using metadata or a script.
自助服务网络通常使用叠加网络。覆盖网络协议（如  VXLAN）包含额外的标头，这些标头会增加开销并减少有效负载或用户数据的可用空间。在不了解虚拟网络基础架构的情况下，实例会尝试使用默认的以太网最大传输单元 （MTU） 1500 字节发送数据包。联网服务通过 DHCP 自动向实例提供正确的 MTU 值。但是，某些云映像不使用 DHCP 或忽略  DHCP MTU 选项，并且需要使用元数据或脚本进行配置。



 

Note 注意



Option 2 also supports attaching instances to provider networks.
选项 2 还支持将实例附加到提供商网络。

Choose one of the following networking options to configure services specific to it. Afterwards, return here and proceed to [Configure the metadata agent](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#neutron-controller-metadata-agent-obs).
选择以下网络选项之一来配置特定于它的服务。然后，返回此处并继续配置元数据代理。

- [Networking Option 1: Provider networks
  网络选项 1：提供商网络](https://docs.openstack.org/neutron/yoga/install/controller-install-option1-obs.html)
- [Networking Option 2: Self-service networks
  网络选项 2：自助服务网络](https://docs.openstack.org/neutron/yoga/install/controller-install-option2-obs.html)



## Configure the metadata agent[¶](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#configure-the-metadata-agent) 配置元数据代理 ¶

The metadata agent provides configuration information such as credentials to instances.
元数据代理提供配置信息，例如实例的凭证。

- Edit the `/etc/neutron/metadata_agent.ini` file and complete the following actions:
  编辑 `/etc/neutron/metadata_agent.ini` 文件并完成以下操作：

  - In the `[DEFAULT]` section, configure the metadata host and shared secret:
    在该部分中，配置元数据主机和共享密钥：In the `[DEFAULT]` section， configure the metadata host and shared secret：

    ```
    [DEFAULT]
    # ...
    nova_metadata_host = controller
    metadata_proxy_shared_secret = METADATA_SECRET
    ```

    Replace `METADATA_SECRET` with a suitable secret for the metadata proxy.
    替换 `METADATA_SECRET` 为元数据代理的合适密钥。

## Configure the Compute service to use the Networking service[¶](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#configure-the-compute-service-to-use-the-networking-service) 配置计算服务以使用网络服务 ¶



 

Note 注意



The Nova compute service must be installed to complete this step. For more details see the compute install guide found under the Installation Guides section of the [docs website](https://docs.openstack.org).
必须安装 Nova 计算服务才能完成此步骤。有关详细信息，请参阅文档网站的“安装指南”部分下的计算安装指南。

- Edit the `/etc/nova/nova.conf` file and perform the following actions:
  编辑 `/etc/nova/nova.conf` 文件并执行以下操作：

  - In the `[neutron]` section, configure access parameters, enable the metadata proxy, and configure the secret:
    在 `[neutron]` 本节中，配置访问参数、启用元数据代理和配置密钥：

    ```
    [neutron]
    # ...
    auth_url = http://controller:5000
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    service_metadata_proxy = true
    metadata_proxy_shared_secret = METADATA_SECRET
    ```

    Replace `NEUTRON_PASS` with the password you chose for the `neutron` user in the Identity service.
    替换 `NEUTRON_PASS` 为您在 Identity 服务中为用户选择的 `neutron` 密码。

    Replace `METADATA_SECRET` with the secret you chose for the metadata proxy.
    替换 `METADATA_SECRET` 为您为元数据代理选择的密钥。

    See the [compute service configuration guide](https://docs.openstack.org/nova/yoga/configuration/config.html#neutron) for the full set of options including overriding the service catalog endpoint URL if necessary.
    有关完整的选项集，请参阅计算服务配置指南，包括在必要时覆盖服务目录终结点 URL。

## Finalize installation[¶](https://docs.openstack.org/neutron/yoga/install/controller-install-obs.html#finalize-installation) 完成安装 ¶



 

Note 注意



SLES enables apparmor by default and restricts dnsmasq. You need to either completely disable apparmor or disable only the dnsmasq profile:
SLES 默认启用 apparmor 并限制 dnsmasq。您需要完全禁用 apparmor 或仅禁用 dnsmasq 配置文件：

```
# ln -s /etc/apparmor.d/usr.sbin.dnsmasq /etc/apparmor.d/disable/
# systemctl restart apparmor
```

1. Restart the Compute API service:
   重新启动计算 API 服务：

   ```
   # systemctl restart openstack-nova-api.service
   ```

2. Start the Networking services and configure them to start when the system boots.
   启动网络服务并将其配置为在系统启动时启动。

   For both networking options:
   对于这两个网络选项：

   ```
   # systemctl enable openstack-neutron.service \
     openstack-neutron-linuxbridge-agent.service \
     openstack-neutron-dhcp-agent.service \
     openstack-neutron-metadata-agent.service
   # systemctl start openstack-neutron.service \
     openstack-neutron-linuxbridge-agent.service \
     openstack-neutron-dhcp-agent.service \
     openstack-neutron-metadata-agent.service
   ```

   For networking option 2, also enable and start the layer-3 service:
   对于网络选项 2，同时启用并启动第 3 层服务：

   ```
   # systemctl enable openstack-neutron-l3-agent.service
   # systemctl start openstack-neutron-l3-agent.service
   ```

​                      



`/etc/sysctl.conf`

```bash
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0s
```

