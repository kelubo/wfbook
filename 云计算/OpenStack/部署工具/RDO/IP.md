# Difference between Floating IP and private IP 浮动 IP 和私有 IP 之间的区别

Are you wondering about the difference between a private IP address and a  floating IP address in OpenStack? Here is a short explanation that  should make it clearer.
您是否想知道 OpenStack 中私有 IP 地址和浮动 IP 地址之间的区别？这里有一个简短的解释，应该会更清楚。

(See also: [Setting a floating IP range](https://www.rdoproject.org/networking/floating-ip-range/))
（另请参阅：设置浮动 IP 范围）

## Private IP Address 私有 IP 地址

A private IP address is assigned to an instance's network-interface by  the DHCP server. The address is visible from within the instance by  using a command like “ip a”. The address is typically part of a private  network and is used for communication between instances in the same  broadcast domain via virtual switch (L2 agent on each compute node).  It can also be accessible from instances in other private networks via  virtual router (L3 agent).
私有 IP 地址由 DHCP 服务器分配给实例的网络接口。通过使用类似“ip  a”的命令，该地址在实例中可见。该地址通常是专用网络的一部分，用于通过虚拟交换机（每个计算节点上的 L2  代理）在同一广播域中的实例之间进行通信。也可以通过虚拟路由器（L3 代理）从其他专用网络中的实例访问它。

## Floating IP Address 浮动 IP 地址

A floating IP address is a service provided by Neutron. It's not using  any DHCP service or being set statically within the guest. As a matter  of fact the guest's operating system has no idea that it was assigned a  floating IP address. The delivery of packets to the interface with the  assigned floating address is the responsibility of Neutron's L3 agent.  Instances with an assigned floating IP address can be accessed from the  public network by the floating IP.
浮动 IP 地址是 Neutron 提供的一项服务。它不使用任何 DHCP  服务，也不在客户机中静态设置。事实上，来宾的操作系统并不知道它被分配了一个浮动 IP 地址。将数据包传送到具有分配的浮动地址的接口是  Neutron 的 L3 代理的责任。分配了浮动IP地址的实例可以通过浮动IP从公网访问。

------

A floating IP address and a private IP address can be used at the same  time on a single network-interface. The private IP address is likely to  be used for accessing the instance by other instances in private  networks while the floating IP address would be used for accessing the  instance from public networks. How to configure floating IP range  describes [Floating IP range](https://www.rdoproject.org/networking/floating-ip-range/) document.
浮动 IP 地址和专用 IP 地址可以在单个网络接口上同时使用。私有 IP 地址可能用于内网中其他实例访问实例，而浮动 IP 地址将用于从公共网络访问实例。如何配置浮动 IP 范围介绍了浮动 IP 范围文档。

## Example 例

A setup with 2 compute nodes, one Neutron controller (where the Neutron  service, dhcp agent and l3 agent run), a physical router and a user. Let the physical subnet be 10.0.0.0/24. On the compute nodes instances are  running using the private IP range 192.168.1.0/24. One of the instances  is a webserver that should be reachable from a public network. Network  outline: 
具有 2 个计算节点、一个 Neutron 控制器（Neutron 服务、dhcp 代理和 l3  代理运行的地方）、一个物理路由器和一个用户的设置。物理子网设为 10.0.0.0/24。在计算节点上，实例使用私有 IP 范围  192.168.1.0/24 运行。其中一个实例是应可从公共网络访问的 Web 服务器。网络概要：![fig:neutron_private_floating_ip.png](https://www.rdoproject.org/images/neutron_private_floating_ip.png)

As shown in the picture above, the webserver is running on an instance  with private IP 192.168.1.2. A User from network 10.0.0.0/24 wants to  access the webserver but he's not part of private network  192.168.1.0/24. Using floating IP address 10.0.0.100 enables the user to fetch webpages from the webserver. The destination address is  translated by the NAT table (iptables) within the virtual router  deployed on the controller.
如上图所示，Web服务器运行在私有IP为192.168.1.2的实例上。来自网络 10.0.0.0/24 的用户想要访问 Web 服务器，但他不是专用网络 192.168.1.0/24 的一部分。使用浮动 IP 地址  10.0.0.100 使用户能够从 Web 服务器获取网页。目标地址由控制器上部署的虚拟路由器中的 NAT 表（ iptables ）转换。