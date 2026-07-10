# IPv6实践

## 概述

IPv6是下一代互联网协议，解决了IPv4地址枯竭问题，提供了更多的地址空间和更好的网络特性。

## IPv6特点

- **更大的地址空间**：128位地址，约3.4×10³⁸个地址
- **无状态地址自动配置**：设备自动获取地址
- **简化的报头**：减少路由开销
- **内置安全**：IPsec支持
- **更好的QoS**：流标签支持

## IPv6地址格式

### 表示方法

```
# 完整格式
2001:0db8:85a3:0000:0000:8a2e:0370:7334

# 压缩格式（省略前导零）
2001:db8:85a3:0:0:8a2e:370:7334

# 双冒号压缩（最多一次）
2001:db8:85a3::8a2e:370:7334

# 环回地址
::1

# 链路本地地址
fe80::/10
```

### 地址类型

| 类型 | 前缀 | 说明 |
|------|------|------|
| 全球单播 | 2000::/3 | 可路由的全球地址 |
| 链路本地 | fe80::/10 | 仅在链路内有效 |
| 站点本地 | fc00::/7 | 仅在站点内有效 |
| 组播 | ff00::/8 | 组播地址 |
| 回环 | ::1 | 本地回环 |

## IPv6地址配置

### 静态配置

```bash
# Linux静态配置
sudo ip addr add 2001:db8:1::1/64 dev eth0
sudo ip route add default via 2001:db8:1::254

# Windows静态配置
netsh interface ipv6 add address "以太网" 2001:db8:1::1/64
netsh interface ipv6 add route ::/0 "以太网" 2001:db8:1::254
```

### 动态配置

```bash
# Linux DHCPv6
sudo dhclient -6 eth0

# Windows DHCPv6
netsh interface ipv6 set interface "以太网" dhcp enabled
```

### SLAAC（无状态地址自动配置）

```bash
# Linux SLAAC
sudo sysctl -w net.ipv6.conf.eth0.autoconf=1

# Windows SLAAC
netsh interface ipv6 set interface "以太网" routerdiscovery=enabled
```

## IPv6过渡技术

### 双栈

```
设备同时支持IPv4和IPv6
```

```bash
# Linux双栈配置
sudo ip addr add 192.168.1.10/24 dev eth0
sudo ip addr add 2001:db8:1::10/64 dev eth0
```

### 隧道

#### 6to4隧道

```bash
# Linux 6to4隧道
sudo ip tunnel add tun6to4 mode sit remote any local 192.168.1.10
sudo ip addr add 2002:c0a8:10a::1/16 dev tun6to4
sudo ip route add ::/0 dev tun6to4
sudo ip link set tun6to4 up
```

#### ISATAP隧道

```bash
# Linux ISATAP隧道
sudo ip tunnel add isatap mode isatap remote 192.168.1.254
sudo ip addr add fe80::5efe:c0a8:10a/64 dev isatap
sudo ip link set isatap up
```

#### GRE隧道

```bash
# Linux GRE隧道
sudo ip tunnel add gre6 mode gre6 remote 2001:db8:1::2 local 2001:db8:1::1
sudo ip addr add 10.0.0.1/24 dev gre6
sudo ip link set gre6 up
```

### NAT64

```
IPv6设备访问IPv4资源
```

```bash
# Linux NAT64配置
sudo ip6tables -t nat -A PREROUTING -d 64:ff9b::/96 -j DNAT --to-destination 192.168.1.0/24
sudo ip6tables -t nat -A POSTROUTING -s 2001:db8:1::/64 -j SNAT --to-source 64:ff9b::c0a8:101
```

### DNS64

```
DNS服务器返回IPv6地址映射
```

## IPv6路由

### 静态路由

```bash
# Linux IPv6静态路由
sudo ip route add 2001:db8:2::/64 via 2001:db8:1::254
sudo ip route add default via 2001:db8:1::254
```

### RIPng

```bash
# Linux RIPng配置
sudo apt-get install quagga
```

```
# /etc/quagga/ripngd.conf
interface eth0
  ip ripng authentication mode md5
  ip ripng authentication key-chain RIPNG_KEY

router ripng
  network eth0
  redistribute static
```

### OSPFv3

```bash
# Linux OSPFv3配置
sudo apt-get install quagga
```

```
# /etc/quagga/ospf6d.conf
interface eth0
  ipv6 ospf6 area 0.0.0.0

router ospf6
  router-id 192.168.1.1
  area 0.0.0.0 range 2001:db8::/32
```

### BGP4+

```bash
# Linux BGP4+配置
sudo apt-get install quagga
```

```
# /etc/quagga/bgpd.conf
router bgp 65001
  bgp router-id 192.168.1.1
  address-family ipv6 unicast
    network 2001:db8:1::/64
    neighbor 2001:db8:1::2 remote-as 65002
```

## IPv6安全

### 防火墙

```bash
# Linux IPv6防火墙
sudo ip6tables -F
sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT ACCEPT

# 允许回环
sudo ip6tables -A INPUT -i lo -j ACCEPT

# 允许已建立的连接
sudo ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 允许ICMPv6
sudo ip6tables -A INPUT -p icmpv6 -j ACCEPT

# 允许SSH
sudo ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
```

### IPsec

```bash
# Linux IPsec配置
sudo apt-get install strongswan

# /etc/strongswan/ipsec.conf
conn ipv6-tunnel
  left=2001:db8:1::1
  right=2001:db8:2::1
  leftsubnet=2001:db8:1::/64
  rightsubnet=2001:db8:2::/64
  auto=start
```

## IPv6测试

### 连通性测试

```bash
# ping IPv6地址
ping6 2001:db8:1::1

# ping IPv6主机名
ping6 ipv6.google.com

# 路由追踪
traceroute6 2001:db8:2::1

# IPv6 DNS解析
dig AAAA example.com
```

### 地址检查

```bash
# 查看IPv6地址
ip -6 addr

# 查看IPv6路由
ip -6 route

# 查看IPv6邻居
ip -6 neighbor
```

## IPv6迁移策略

### 阶段一：准备

```
1. 评估网络设备IPv6支持
2. 培训网络管理员
3. 制定IPv6地址规划
```

### 阶段二：试点

```
1. 在测试网络部署IPv6
2. 配置双栈
3. 测试应用兼容性
```

### 阶段三：部署

```
1. 在核心网络部署IPv6
2. 配置路由协议
3. 迁移关键应用
```

### 阶段四：优化

```
1. 监控IPv6流量
2. 优化IPv6性能
3. 逐步淘汰IPv4
```

## 总结

IPv6是互联网的未来，掌握IPv6配置和过渡技术对于网络工程师至关重要。通过双栈、隧道等过渡技术，可以平滑地从IPv4迁移到IPv6。