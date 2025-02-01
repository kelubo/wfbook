# 网络细节太多

1. 1. [The players 球员们](https://www.rdoproject.org/networking/networking-in-too-much-detail/#the-players)
   2. [The lay of the land
      土地的布局](https://www.rdoproject.org/networking/networking-in-too-much-detail/#the-lay-of-the-land)
   3. [Compute host: instance networking (A,B,C)
      计算主机：实例网络 （A、B、C）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#compute-host-instance-networking-abc)
   4. [Compute host: integration bridge (D,E)
      计算主机：集成网桥 （D，E）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#compute-host-integration-bridge-de)
   5. [Compute host: tunnel bridge (F,G)
      计算主机：隧道网桥 （F，G）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#compute-host-tunnel-bridge-fg)
   6. [Network host: tunnel bridge (H,I)
      网络主机：隧道网桥 （H，I）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#network-host-tunnel-bridge-hi)
   7. [Network host: integration bridge
      网络主机：集成网桥](https://www.rdoproject.org/networking/networking-in-too-much-detail/#network-host-integration-bridge)
   8. [Network host: DHCP server (O,P)
      网络主机：DHCP 服务器 （O，P）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#network-host-dhcp-server-op)
   9. [Network host: Router (M,N)
      网络主机：路由器 （M，N）](https://www.rdoproject.org/networking/networking-in-too-much-detail/#network-host-router-mn)
   10. Network host: External traffic (K,L)
       网络主机：外部流量 （K，L）
       1. [NAT to host address
          NAT 到主机地址](https://www.rdoproject.org/networking/networking-in-too-much-detail/#nat-to-host-address)
       2. [Direct network connection
          直接网络连接](https://www.rdoproject.org/networking/networking-in-too-much-detail/#direct-network-connection)

## The players 球员们

This document describes the architecture that results from a particular OpenStack configuration, specifically:
本文档描述了由特定 OpenStack 配置产生的架构，具体而言：

- Quantum (or Neutron) networking using GRE tunnels;
  使用GRE隧道的量子（或中子）网络;
- A dedicated network controller;
  专用网络控制器;
- A single instance running on a compute host
  在计算主机上运行的单个实例

Much of the document will be relevant to other configurations, but details  will vary based on your choice of layer 2 connectivity, number of  running instances, and so forth.
本文档的大部分内容将与其他配置相关，但详细信息将根据您选择的第 2 层连接、正在运行的实例数量等而有所不同。

The examples in this document were generated on a system with Quantum  networking but will generally match what you see under Neutron as well,  if you replace `quantum` by `neutron` in names.
本文档中的示例是在具有 Quantum 网络的系统上生成的，但如果将 `quantum` `neutron` 替换为 in 名称，则通常也会与您在 Neutron 下看到的内容相匹配。

IRC NOTE by larsks: Also, I consider  http://blog.oddbit.com/2013/11/14/quantum-in-too-much-detail/ to be the  canonical version of that article. If I ever made any corrections,  that's where you'll find them.
larsks 的 IRC 注释：另外，我认为 http://blog.oddbit.com/2013/11/14/quantum-in-too-much-detail/ 是那篇文章的规范版本。如果我做过任何更正，那就是你会找到它们的地方。

## The lay of the land 土地的布局

This is a simplified architecture diagram of network connectivity in a quantum/neutron managed world:
这是量子/中子管理世界中网络连接的简化架构图：

![neutron_architecture.png](https://www.rdoproject.org/images/neutron_architecture.png?1495114718)

Section names in this document include parenthetical references to the nodes on the map relevant to that particular section.
本文档中的截面名称包括对地图上与该特定截面相关的节点的括号引用。

## Compute host: instance networking (A,B,C) 计算主机：实例网络 （A、B、C）

An outbound packet starts on `eth0` of the virtual instance, which is connected to a `tap` device on the host, `tap7c7ae61e-05`. This `tap` device is attached to a Linux bridge device, `qbr7c7ae61e-05`. What is this bridge device for? From the [OpenStack Networking Administration Guide](http://docs.openstack.org/network-admin/admin/content/under_the_hood_openvswitch.html):
出站数据包从 `eth0` 连接到主机上的 `tap` 设备的虚拟实例开始 `tap7c7ae61e-05` 。此 `tap` 设备连接到 Linux 网桥设备 。 `qbr7c7ae61e-05` 这个桥接设备是做什么用的？摘自《OpenStack Networking Administration Guide》：

> Ideally, the TAP device vnet0 would be connected directly to the integration  bridge, br-int. Unfortunately, this isn't possible because of how  OpenStack security groups are currently implemented. OpenStack uses  iptables rules on the TAP devices such as vnet0 to implement security  groups, and Open vSwitch is not compatible with iptables rules that are  applied directly on TAP devices that are connected to an Open vSwitch  port.
> 理想情况下，TAP 设备 vnet0 将直接连接到集成网桥 br-int。不幸的是，由于OpenStack安全组目前的实现方式，这是不可能的。OpenStack 在 TAP 设备（如 vnet0）上使用 iptables 规则来实现安全组，而 Open vSwitch 与直接应用于连接到 Open  vSwitch 端口的 TAP 设备上的 iptables 规则不兼容。

Because this bridge device exists primarily to support firewall rules, I'm going to refer to it as the "firewall bridge".
由于此网桥设备主要是为了支持防火墙规则而存在的，因此我将其称为“防火墙网桥”。

If you examine the firewall rules on your compute host, you will find that there are several rules associated with this `tap` device:
如果检查计算主机上的防火墙规则，会发现有几个规则与此 `tap` 设备相关联：

```
# iptables -S | grep tap7c7ae61e-05
-A quantum-openvswi-FORWARD -m physdev --physdev-out tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-sg-chain 
-A quantum-openvswi-FORWARD -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-sg-chain 
-A quantum-openvswi-INPUT -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-o7c7ae61e-0 
-A quantum-openvswi-sg-chain -m physdev --physdev-out tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-i7c7ae61e-0 
-A quantum-openvswi-sg-chain -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-o7c7ae61e-0 
```

The `quantum-openvswi-sg-chain` is where `neutron`-managed security groups are realized. The `quantum-openvswi-o7c7ae61e-0` chain controls outbound traffic FROM the instance, and by default looks like this:
 `quantum-openvswi-sg-chain` 是实现托管安全组的地方 `neutron` 。该 `quantum-openvswi-o7c7ae61e-0` 链控制来自实例的出站流量，默认情况下如下所示：

```
-A quantum-openvswi-o7c7ae61e-0 -m mac ! --mac-source FA:16:3E:03:00:E7 -j DROP 
-A quantum-openvswi-o7c7ae61e-0 -p udp -m udp --sport 68 --dport 67 -j RETURN 
-A quantum-openvswi-o7c7ae61e-0 ! -s 10.1.0.2/32 -j DROP 
-A quantum-openvswi-o7c7ae61e-0 -p udp -m udp --sport 67 --dport 68 -j DROP 
-A quantum-openvswi-o7c7ae61e-0 -m state --state INVALID -j DROP 
-A quantum-openvswi-o7c7ae61e-0 -m state --state RELATED,ESTABLISHED -j RETURN 
-A quantum-openvswi-o7c7ae61e-0 -j RETURN 
-A quantum-openvswi-o7c7ae61e-0 -j quantum-openvswi-sg-fallback 
```

The `quantum-openvswi-i7c7ae61e-0` chain controls inbound traffic TO the instance. After opening up port 22 in the default security group:
该 `quantum-openvswi-i7c7ae61e-0` 链控制到实例的入站流量。在默认安全组中打开端口 22 后：

```
# neutron security-group-rule-create --protocol tcp \
  --port-range-min 22 --port-range-max 22 --direction ingress default
```

The rules look like this:
规则如下所示：

```
-A quantum-openvswi-i7c7ae61e-0 -m state --state INVALID -j DROP 
-A quantum-openvswi-i7c7ae61e-0 -m state --state RELATED,ESTABLISHED -j RETURN 
-A quantum-openvswi-i7c7ae61e-0 -p icmp -j RETURN 
-A quantum-openvswi-i7c7ae61e-0 -p tcp -m tcp --dport 22 -j RETURN 
-A quantum-openvswi-i7c7ae61e-0 -p tcp -m tcp --dport 80 -j RETURN 
-A quantum-openvswi-i7c7ae61e-0 -s 10.1.0.3/32 -p udp -m udp --sport 67 --dport 68 -j RETURN 
-A quantum-openvswi-i7c7ae61e-0 -j quantum-openvswi-sg-fallback 
```

A second interface attached to the bridge, `qvb7c7ae61e-05`, attaches the firewall bridge to the integration bridge, typically named `br-int`.
连接到网桥的第二个接口 `qvb7c7ae61e-05` 将防火墙网桥连接到集成网桥，通常命名为 `br-int` 。

## Compute host: integration bridge (D,E) 计算主机：集成网桥 （D，E）

The integration bridge, `br-int`, performs VLAN tagging and un-tagging for traffic coming from and to your instances. At this moment, `br-int` looks something like this:
集成网桥 `br-int` 对进出实例的流量执行 VLAN 标记和取消标记。此时此刻， `br-int` 看起来像这样：

```
# ovs-vsctl show
Bridge br-int
    Port &quot;qvo7c7ae61e-05&quot;
        tag: 1
        Interface &quot;qvo7c7ae61e-05&quot;
    Port patch-tun
        Interface patch-tun
            type: patch
            options: {peer=patch-int}
    Port br-int
        Interface br-int
            type: internal
```

The interface `qvo7c7ae61e-05` is the other end of `qvb7c7ae61e-05`, and carries traffic to and from the firewall bridge. The `tag: 1` you see in the above output integrates that this is an access port  attached to VLAN 1. Untagged outbound traffic from this instance will be assigned VLAN ID 1, and inbound traffic with VLAN ID 1 will stripped of it's VLAN tag and sent out this port.
接口 `qvo7c7ae61e-05` 是 `qvb7c7ae61e-05` 的另一端，用于传输进出防火墙网桥的流量。 `tag: 1` 您在上面的输出中看到的是，这是一个连接到 VLAN 1 的接入端口。来自此实例的未标记出站流量将被分配 VLAN ID 1，VLAN ID 为 1 的入站流量将剥离其 VLAN 标记并发送出此端口。

Each network you create (with `neutron net-create`) will be assigned a different VLAN ID.
您创建的每个网络（使用 `neutron net-create` ）都将分配一个不同的 VLAN ID。

The interface named `patch-tun` connects the integration bridge to the tunnel bridge, `br-tun`.
名为 `patch-tun` 的接口将集成网桥连接到隧道网桥 `br-tun` 。

## Compute host: tunnel bridge (F,G) 计算主机：隧道网桥 （F，G）

The tunnel bridge translates VLAN-tagged traffic from the integration bridge into `GRE` tunnels. The translation between VLAN IDs and tunnel IDs is performed by OpenFlow rules installed on `br-tun`. Before creating any instances, the flow rules on the bridge look like this:
隧道网桥将来自集成网桥的 VLAN 标记流量转换为 `GRE` 隧道。VLAN ID 和隧道 ID 之间的转换由安装在 上的 `br-tun` OpenFlow 规则执行。在创建任何实例之前，网桥上的流规则如下所示：

```
# ovs-ofctl dump-flows br-tun
NXST_FLOW reply (xid=0x4):
 cookie=0x0, duration=871.283s, table=0, n_packets=4, n_bytes=300, idle_age=862, priority=1 actions=drop
```

There is a single rule that causes the bridge to drop all traffic. Afrer you  boot an instance on this compute node, the rules are modified to look  something like:
有一个规则会导致网桥丢弃所有流量。在此计算节点上启动实例后，规则将修改为如下所示：

```
# ovs-ofctl dump-flows br-tun
NXST_FLOW reply (xid=0x4):
 cookie=0x0, duration=422.158s, table=0, n_packets=2, n_bytes=120, idle_age=55, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1
 cookie=0x0, duration=421.948s, table=0, n_packets=64, n_bytes=8337, idle_age=31, priority=3,tun_id=0x2,dl_dst=fa:16:3e:dd:c1:62 actions=mod_vlan_vid:1,NORMAL
 cookie=0x0, duration=422.357s, table=0, n_packets=82, n_bytes=10443, idle_age=31, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
 cookie=0x0, duration=1502.657s, table=0, n_packets=8, n_bytes=596, idle_age=423, priority=1 actions=drop
```

In general, these rules are responsible for mapping traffic between VLAN  ID 1, used by the integration bridge, and tunnel id 2, used by the GRE  tunnel.
通常，这些规则负责在集成网桥使用的 VLAN ID 1 和 GRE 隧道使用的隧道 ID 2 之间映射流量。

The first rule… 第一条规则...

```
 cookie=0x0, duration=422.158s, table=0, n_packets=2, n_bytes=120, idle_age=55, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1
```

…matches all multicast traffic (see [ovs-ofctl(8)](http://openvswitch.org/support/dist-docs/ovs-ofctl.8.txt)) on tunnel id 2 (`tun_id=0x2`), tags the ethernet frame with VLAN ID 1 (`actions=mod_vlan_vid:1`), and sends it out port 1. We can see from `ovs-ofctl show br-tun` that port 1 is `patch-int`:
...匹配隧道 ID 2 （ `tun_id=0x2` ） 上的所有组播流量（参见 ovs-ofctl（8）），使用 VLAN ID 1 （ `actions=mod_vlan_vid:1` ） 标记以太网帧，并将其发送到端口 1。从 `ovs-ofctl show br-tun` 该端口中我们可以看到 1 是 `patch-int` ：

```
# ovs-ofctl show br-tun
OFPT_FEATURES_REPLY (xid=0x2): dpid:0000068df4e44a49
n_tables:254, n_buffers:256
capabilities: FLOW_STATS TABLE_STATS PORT_STATS QUEUE_STATS ARP_MATCH_IP
actions: OUTPUT SET_VLAN_VID SET_VLAN_PCP STRIP_VLAN SET_DL_SRC SET_DL_DST SET_NW_SRC SET_NW_DST SET_NW_TOS SET_TP_SRC SET_TP_DST ENQUEUE
 1(patch-int): addr:46:3d:59:17:df:62
     config:     0
     state:      0
     speed: 0 Mbps now, 0 Mbps max
 2(gre-2): addr:a2:5f:a1:92:29:02
     config:     0
     state:      0
     speed: 0 Mbps now, 0 Mbps max
 LOCAL(br-tun): addr:06:8d:f4:e4:4a:49
     config:     0
     state:      0
     speed: 0 Mbps now, 0 Mbps max
OFPT_GET_CONFIG_REPLY (xid=0x4): frags=normal miss_send_len=0
```

The next rule… 下一条规则...

```
 cookie=0x0, duration=421.948s, table=0, n_packets=64, n_bytes=8337, idle_age=31, priority=3,tun_id=0x2,dl_dst=fa:16:3e:dd:c1:62 actions=mod_vlan_vid:1,NORMAL
```

…matches traffic coming in on tunnel 2 (`tun_id=0x2`) with an ethernet destination of `fa:16:3e:dd:c1:62` (`dl_dst=fa:16:3e:dd:c1:62`) and tags the ethernet frame with VLAN ID 1 (`actions=mod_vlan_vid:1`) before sending it out `patch-int`.
...将隧道 2 （ `tun_id=0x2` ） 上传入的流量与以太网目标 `fa:16:3e:dd:c1:62` （ `dl_dst=fa:16:3e:dd:c1:62` ） 进行匹配，并在发送之前使用 VLAN ID 1 （ `actions=mod_vlan_vid:1` ） 标记以太网帧 `patch-int` 。

The following rule… 以下规则...

```
 cookie=0x0, duration=422.357s, table=0, n_packets=82, n_bytes=10443, idle_age=31, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
```

…matches traffic coming in on port 1 (`in_port=1`) with VLAN ID 1 (`dl_vlan=1`) and set the tunnel id to 2 (`actions=set_tunnel:0x2`) before sending it out the GRE tunnel.
...将端口 1 （ `in_port=1` ） 上传入的流量与 VLAN ID 1 （ `dl_vlan=1` ） 进行匹配，并将隧道 ID 设置为 2 （ `actions=set_tunnel:0x2` ），然后再将其发送到 GRE 隧道。

## Network host: tunnel bridge (H,I) 网络主机：隧道网桥 （H，I）

Traffic arrives on the network host via the GRE tunnel attached to `br-tun`. This bridge has a flow table very similar to `br-tun` on the compute host:
流量通过连接到 的 GRE 隧道到达网络主机 `br-tun` 。此网桥的流表与计算主机 `br-tun` 上的流表非常相似：

```
# ovs-ofctl dump-flows br-tun
NXST_FLOW reply (xid=0x4):
 cookie=0x0, duration=1239.229s, table=0, n_packets=23, n_bytes=4246, idle_age=15, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1
 cookie=0x0, duration=524.477s, table=0, n_packets=15, n_bytes=3498, idle_age=10, priority=3,tun_id=0x2,dl_dst=fa:16:3e:83:69:cc actions=mod_vlan_vid:1,NORMAL
 cookie=0x0, duration=1239.157s, table=0, n_packets=50, n_bytes=4565, idle_age=148, priority=3,tun_id=0x2,dl_dst=fa:16:3e:aa:99:3c actions=mod_vlan_vid:1,NORMAL
 cookie=0x0, duration=1239.304s, table=0, n_packets=76, n_bytes=9419, idle_age=10, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
 cookie=0x0, duration=1527.016s, table=0, n_packets=12, n_bytes=880, idle_age=527, priority=1 actions=drop
```

As on the compute host, the first rule maps multicast traffic on tunnel ID 2 to VLAN 1.
与在计算主机上一样，第一条规则将隧道 ID 2 上的组播流量映射到 VLAN 1。

The second rule… 第二条规则...

```
 cookie=0x0, duration=524.477s, table=0, n_packets=15, n_bytes=3498, idle_age=10, priority=3,tun_id=0x2,dl_dst=fa:16:3e:83:69:cc actions=mod_vlan_vid:1,NORMAL
```

…matches traffic on the tunnel destined for the DHCP server at `fa:16:3e:83:69:cc`. This is a `dnsmasq` process running inside a network namespace, the details of which we will examine shortly.
...匹配发往 DHCP 服务器的隧道上的流量 `fa:16:3e:83:69:cc` 。这是一个 `dnsmasq` 在网络命名空间内运行的进程，我们稍后将研究其详细信息。

The next rule… 下一条规则...

```
 cookie=0x0, duration=1239.157s, table=0, n_packets=50, n_bytes=4565, idle_age=148, priority=3,tun_id=0x2,dl_dst=fa:16:3e:aa:99:3c actions=mod_vlan_vid:1,NORMAL
```

…matches traffic on tunnel ID 2 destined for the router at `fa:16:3e:aa:99:3c`, which is an interface in another network namespace.
...匹配发往路由器的隧道 ID 2 上的流量，该路由器是 `fa:16:3e:aa:99:3c` 另一个网络命名空间中的接口。

The following rule… 以下规则...

```
 cookie=0x0, duration=1239.304s, table=0, n_packets=76, n_bytes=9419, idle_age=10, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
```

…simply maps outbound traffic on VLAN ID 1 to tunnel ID 2.
...只需将 VLAN ID 1 上的出站流量映射到隧道 ID 2。

## Network host: integration bridge 网络主机：集成网桥

The integration bridge on the network controller serves to connect  instances to network services, such as routers and DHCP servers.
网络控制器上的集成网桥用于将实例连接到网络服务，例如路由器和 DHCP 服务器。

```
# ovs-vsctl show
.
.
.
Bridge br-int
    Port patch-tun
        Interface patch-tun
            type: patch
            options: {peer=patch-int}
    Port &quot;tapf14c598d-98&quot;
        tag: 1
        Interface &quot;tapf14c598d-98&quot;
    Port br-int
        Interface br-int
            type: internal
    Port &quot;tapc2d7dd02-56&quot;
        tag: 1
        Interface &quot;tapc2d7dd02-56&quot;
.
.
.
```

It connects to the tunnel bridge, `br-tun`, via a patch interface, `patch-tun`.
它通过补丁接口连接到隧道网桥 `br-tun` `patch-tun` 。

## Network host: DHCP server (O,P) 网络主机：DHCP 服务器 （O，P）

Each network for which DHCP is enabled has a DHCP server running on the network controller. The DHCP server is an instance of [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) running inside a *network namespace*. A *network namespace* is a Linux kernel facility that allows groups of processes to have a  network stack (interfaces, routing tables, iptables rules) distinct from that of the host.
启用了 DHCP 的每个网络都有一台在网络控制器上运行的 DHCP 服务器。DHCP 服务器是在网络命名空间内运行的 dnsmasq  实例。网络命名空间是一种 Linux 内核工具，它允许进程组具有与主机不同的网络堆栈（接口、路由表、iptables 规则）。

You can see a list of network namespace with the `ip netns` command, which in our configuration will look something like this:
您可以使用命令 `ip netns` 查看网络命名空间列表，在我们的配置中，该命令将如下所示：

```
# ip netns
qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264
qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f
```

The first of these (`qdhcp...`) is the DHCP server namespace for our private subnet, while the second (`qrouter...`) is the router.
其中第一个 （ `qdhcp...` ） 是私有子网的 DHCP 服务器命名空间，而第二个 （ `qrouter...` ） 是路由器。

You can run a command inside a network namespace using the `ip netns exec` command. For example, to see the interface configuration inside the DHCP server namespace (`lo` removed for brevity):
您可以使用该命令在网络命名空间内运行命令 `ip netns exec` 。例如，要查看 DHCP 服务器命名空间中的接口配置（为简洁起见 `lo` 已删除）：

```
# ip netns exec qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264 ip addr
71: ns-f14c598d-98: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether fa:16:3e:10:2f:03 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.3/24 brd 10.1.0.255 scope global ns-f14c598d-98
    inet6 fe80::f816:3eff:fe10:2f03/64 scope link 
       valid_lft forever preferred_lft forever
```

Note the MAC address on interface `ns-f14c598d-98`; this matches the MAC address in the flow rule we saw on the tunnel  bridge. This interface connects to the integration bridge via a tap  device:
记下接口 `ns-f14c598d-98` 上的MAC地址;这与我们在隧道网桥上看到的流规则中的 MAC 地址相匹配。此接口通过分流器设备连接到集成网桥：

```
    Port &quot;tapf14c598d-98&quot;
        tag: 1
        Interface &quot;tapf14c598d-98&quot;
```

You can find the `dnsmasq` process associated with this namespace by search the output of `ps` for the id (the number after `qdhcp-` in the namespace name):
您可以通过搜索 id 的输出 `ps` （命名空间名称中后面 `qdhcp-` 的数字）来找到与此命名空间关联的 `dnsmasq` 进程：

```
# ps -fe | grep 88b1609c-68e0-49ca-a658-f1edff54a264
nobody   23195     1  0 Oct26 ?        00:00:00 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-f14c598d-98 --except-interface=lo --pid-file=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/host --dhcp-optsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,10.1.0.0,static,120s --conf-file= --domain=openstacklocal
root     23196 23195  0 Oct26 ?        00:00:00 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-f14c598d-98 --except-interface=lo --pid-file=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/host --dhcp-optsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,10.1.0.0,static,120s --conf-file= --domain=openstacklocal
```

## Network host: Router (M,N) 网络主机：路由器 （M，N）

A Neutron router is a network namespace with a set of routing tables and  iptables rules that performs the routing between subnets. Recall that we saw two network namespaces in our configuration:
Neutron 路由器是一个网络命名空间，具有一组路由表和 iptables 规则，用于执行子网之间的路由。回想一下，我们在配置中看到了两个网络命名空间：

```
# ip netns
qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264
qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f
```

Using the `ip netns exec` command, we can inspect the interfaces associated with the router (`lo` removed for brevity):
使用该 `ip netns exec` 命令，我们可以检查与路由器关联的接口（为简洁起见 `lo` 删除）：

```
# ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f ip addr
66: qg-d48b49e0-aa: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether fa:16:3e:5c:a2:ac brd ff:ff:ff:ff:ff:ff
    inet 172.24.4.227/28 brd 172.24.4.239 scope global qg-d48b49e0-aa
    inet 172.24.4.228/32 brd 172.24.4.228 scope global qg-d48b49e0-aa
    inet6 fe80::f816:3eff:fe5c:a2ac/64 scope link 
       valid_lft forever preferred_lft forever
68: qr-c2d7dd02-56: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether fa:16:3e:ea:64:6e brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global qr-c2d7dd02-56
    inet6 fe80::f816:3eff:feea:646e/64 scope link 
       valid_lft forever preferred_lft forever
```

The first interface, `qg-d48b49e0-aa`, connects the router to the gateway set by the `router-gateway-set` command. The second interface, `qr-c2d7dd02-56`, is what connects the router to the integration bridge:
第一个接口 `qg-d48b49e0-aa` 将路由器连接到 `router-gateway-set` 命令设置的网关。第二个接口 是 `qr-c2d7dd02-56` 将路由器连接到集成网桥的接口：

```
    Port &quot;tapc2d7dd02-56&quot;
        tag: 1
        Interface &quot;tapc2d7dd02-56&quot;
```

Looking at the routing tables inside the router, we see that there is a default gateway pointing to the `.1` address of our external network, and the expected network routes for directly attached networks:
查看路由器内部的路由表，我们看到有一个默认网关指向外部网络 `.1` 的地址，以及直接连接网络的预期网络路由：

```
# ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f ip route
172.24.4.224/28 dev qg-d48b49e0-aa  proto kernel  scope link  src 172.24.4.227 
10.1.0.0/24 dev qr-c2d7dd02-56  proto kernel  scope link  src 10.1.0.1 
default via 172.24.4.225 dev qg-d48b49e0-aa 
```

The netfilter `nat` table inside the router namespace is responsible for associating  floating IP addresses with your instances. For example, after  associating the address `172.24.4.228` with our instance, the `nat` table looks like this:
路由器命名空间内的 netfilter `nat` 表负责将浮动 IP 地址与您的实例相关联。例如，将地址 `172.24.4.228` 与我们的实例关联后， `nat` 该表如下所示：

```
# ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f iptables -t nat -S
-P PREROUTING ACCEPT
-P POSTROUTING ACCEPT
-P OUTPUT ACCEPT
-N quantum-l3-agent-OUTPUT
-N quantum-l3-agent-POSTROUTING
-N quantum-l3-agent-PREROUTING
-N quantum-l3-agent-float-snat
-N quantum-l3-agent-snat
-N quantum-postrouting-bottom
-A PREROUTING -j quantum-l3-agent-PREROUTING 
-A POSTROUTING -j quantum-l3-agent-POSTROUTING 
-A POSTROUTING -j quantum-postrouting-bottom 
-A OUTPUT -j quantum-l3-agent-OUTPUT 
-A quantum-l3-agent-OUTPUT -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
-A quantum-l3-agent-POSTROUTING ! -i qg-d48b49e0-aa ! -o qg-d48b49e0-aa -m conntrack ! --ctstate DNAT -j ACCEPT 
-A quantum-l3-agent-PREROUTING -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 9697 
-A quantum-l3-agent-PREROUTING -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
-A quantum-l3-agent-float-snat -s 10.1.0.2/32 -j SNAT --to-source 172.24.4.228 
-A quantum-l3-agent-snat -j quantum-l3-agent-float-snat 
-A quantum-l3-agent-snat -s 10.1.0.0/24 -j SNAT --to-source 172.24.4.227 
-A quantum-postrouting-bottom -j quantum-l3-agent-snat 
```

There are `SNAT` and `DNAT` rules to map traffic between the floating address, `172.24.4.228`, and the private address `10.1.0.2`:
有 `SNAT` 和 `DNAT` 规则可以映射浮动地址 `172.24.4.228` 和 私有地址 `10.1.0.2` 之间的流量：

```
-A quantum-l3-agent-OUTPUT -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
-A quantum-l3-agent-PREROUTING -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
-A quantum-l3-agent-float-snat -s 10.1.0.2/32 -j SNAT --to-source 172.24.4.228 
```

When you associate a floating ip address with an instance, similar rules will be created in this table.
当您将浮动 IP 地址与实例关联时，此表中将创建类似的规则。

There is also an `SNAT` rule that NATs all outbound traffic from our private network to `172.24.4.227`:
还有一条 `SNAT` 规则是，NAT 将来自我们专用网络的所有出站流量发送到 `172.24.4.227` ：

```
-A quantum-l3-agent-snat -s 10.1.0.0/24 -j SNAT --to-source 172.24.4.227 
```

This permits instances to have outbound connectivity even without a public ip address.
这允许实例具有出站连接，即使没有公有 IP 地址也是如此。

## Network host: External traffic (K,L) 网络主机：外部流量 （K，L）

"External" traffic flows through `br-ex` via the `qg-d48b49e0-aa` interface in the router name space, which connects to `br-ex` as `tapd48b49e0-aa`:
“外部”流量通过路由器名称空间中的接口流过 `br-ex` ，该接口连接到 `br-ex` `tapd48b49e0-aa` ： `qg-d48b49e0-aa` 

```
Bridge br-ex
    Port &quot;tapd48b49e0-aa&quot;
        Interface &quot;tapd48b49e0-aa&quot;
    Port br-ex
        Interface br-ex
            type: internal
```

What happens when traffic gets this far depends on your local configuration.
当流量达到这一步时会发生什么情况取决于您的本地配置。

### NAT to host address NAT 到主机地址

If you assign the gateway address for your public network to `br-ex`:
如果将公用网络 `br-ex` 的网关地址分配给：

```
# ip addr add 172.24.4.225/28 dev br-ex
```

Then you can create forwarding and NAT rules that will cause "external"  traffic from your instances to get rewritten to your network  controller's ip address and sent out on the network:
然后，您可以创建转发和 NAT 规则，这些规则将导致来自实例的“外部”流量重写到网络控制器的 IP 地址并在网络上发送：

```
# iptables -A FORWARD -d 172.24.4.224/28 -j ACCEPT 
# iptables -A FORWARD -s 172.24.4.224/28 -j ACCEPT 
# iptables -t nat -I POSTROUTING 1 -s 172.24.4.224/28 -j MASQUERADE
```

### Direct network connection 直接网络连接

If you have an external router that will act as a gateway for your public  network, you can add an interface on that network to the bridge. For  example, assuming that `eth2` was on the same network as `172.24.4.225`:
如果您有一个外部路由器将充当公共网络的网关，则可以将该网络上的接口添加到网桥中。例如，假设它与 `eth2` `172.24.4.225` ：

```
# ovs-vsctl add-port br-ex eth2
```