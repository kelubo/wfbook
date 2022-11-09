# Neutron

[TOC]

## 概述

Neutron 服务提供虚拟机实例对网络的连接，其中 plug-ins 能够提供对多种网络设备和软件的支持，使 OpenStack 环境的构建和部署具备更多的灵活性。

## 组件

* neutron-server

  接收和路由 API 请求到 OpenStack 中的网络 plug-in 。

* OpenStack Networking plug-in 和 agent

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

  在 neutron-server 和 angent 直接路由信息，同时也会作为一个数据库存储 plug-in 的网络连接状态。







`/etc/sysctl.conf`

```bash
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0s
```

