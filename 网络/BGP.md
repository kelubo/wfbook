# BGP路由协议

## 概述

BGP（Border Gateway Protocol）是一种外部网关协议（EGP），用于在不同自治系统（AS）之间交换路由信息。

## BGP特点

- **路径向量协议**：基于路径属性选择最优路由
- **无类路由协议**：支持CIDR和VLSM
- **单播路由协议**：只传播单播路由
- **可靠传输**：基于TCP连接
- **策略路由**：支持灵活的路由策略

## BGP类型

### EBGP（外部BGP）

- 不同自治系统之间的BGP连接
- 通常直接物理连接
- 使用AS号标识自治系统

### IBGP（内部BGP）

- 同一自治系统内的BGP连接
- 需要全互联或路由反射器
- 防止路由环路

## BGP邻居建立

### TCP连接

```
1. TCP三次握手建立连接（端口179）
2. 交换OPEN消息建立邻居关系
3. 交换KEEPALIVE消息保持连接
4. 交换UPDATE消息传递路由
5. 交换NOTIFICATION消息报告错误
```

### BGP状态机

```
Idle → Connect → Active → OpenSent → OpenConfirm → Established
```

## BGP路径属性

### 公认必遵属性

- **ORIGIN**：路由来源（IGP、EGP、INCOMPLETE）
- **AS_PATH**：经过的AS列表
- **NEXT_HOP**：下一跳地址

### 公认自选属性

- **LOCAL_PREF**：本地优先级
- **ATOMIC_AGGREGATE**：聚合标志

### 可选传递属性

- **AGGREGATOR**：聚合者信息
- **COMMUNITY**：团体属性
- **MED**：多出口鉴别器

### 可选非传递属性

- **LOCAL_PREF**：本地优先级
- **WEIGHT**：权重（Cisco特有）

## BGP路由选择

### 选择顺序

1. 丢弃下一跳不可达的路由
2. 选择WEIGHT最大的路由（Cisco）
3. 选择LOCAL_PREF最大的路由
4. 选择本地发起的路由
5. 选择AS_PATH最短的路由
6. 选择ORIGIN最优的路由（IGP > EGP > INCOMPLETE）
7. 选择MED最小的路由
8. 选择EBGP路由优先于IBGP路由
9. 选择BGP邻居IP地址最小的路由

## BGP配置

### H3C配置示例

```
# 配置AS号
system-view
bgp 65001

# 配置EBGP邻居
peer 192.168.1.2 as-number 65002

# 配置IBGP邻居
peer 10.0.0.2 as-number 65001

# 宣告网络
network 192.168.0.0 255.255.0.0

# 配置路由反射器
reflector cluster-id 1
peer 10.0.0.2 reflect-client
```

### Cisco配置示例

```
# 配置AS号
router bgp 65001

# 配置EBGP邻居
neighbor 192.168.1.2 remote-as 65002

# 配置IBGP邻居
neighbor 10.0.0.2 remote-as 65001

# 宣告网络
network 192.168.0.0 mask 255.255.0.0

# 配置路由反射器
neighbor 10.0.0.2 route-reflector-client
```

## BGP路由策略

### 前缀列表

```
# H3C配置
ip ip-prefix ALLOW prefix-list 192.168.0.0/16 permit
ip ip-prefix DENY prefix-list 10.0.0.0/8 deny

# 应用到邻居
peer 192.168.1.2 ip-prefix ALLOW export
```

### 路由策略

```
# H3C配置
route-policy ALLOW permit node 10
if-match ip-prefix ALLOW

route-policy DENY deny node 20
if-match ip-prefix DENY

# 应用到邻居
peer 192.168.1.2 route-policy ALLOW export
```

### 团体属性

```
# 设置团体属性
route-policy SET_COMMUNITY permit node 10
apply community 100:1

# 发送团体属性
peer 192.168.1.2 advertise-community
```

## BGP安全

### MD5认证

```
# H3C配置
peer 192.168.1.2 password simple md5_password

# Cisco配置
neighbor 192.168.1.2 password md5_password
```

### TTL安全

```
# H3C配置
peer 192.168.1.2 ttl-security hops 1

# Cisco配置
neighbor 192.168.1.2 ttl-security hops 1
```

### 前缀过滤

```
# 使用前缀列表过滤
peer 192.168.1.2 ip-prefix FILTER import
```

## BGP故障排查

### 查看邻居状态

```
# H3C
display bgp peer

# Cisco
show ip bgp summary
```

### 查看BGP路由

```
# H3C
display bgp routing-table

# Cisco
show ip bgp
```

### 查看AS_PATH

```
# H3C
display bgp routing-table 192.168.0.0

# Cisco
show ip bgp 192.168.0.0
```

## BGP最佳实践

### 路由聚合

```
# H3C配置
aggregate 192.168.0.0 255.255.0.0

# Cisco配置
aggregate-address 192.168.0.0 255.255.0.0
```

### 路由反射器

```
# 配置路由反射器
reflector cluster-id 1
peer 10.0.0.2 reflect-client
peer 10.0.0.3 reflect-client
```

### 联邦

```
# 配置联邦
bgp 65001
confederation id 65000
confederation peer-as 65002 65003
```

## 总结

BGP是互联网核心路由协议，用于自治系统之间的路由交换。理解BGP的路径属性和路由选择机制对于网络设计和故障排查至关重要。