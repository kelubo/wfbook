# Firewall

[TOC]

## 概述

防火墙是一个网络安全系统，它可根据配置的安全规则监控并控制进入和离开的网络流量。防火墙通常在可信内部网络和其它网络间建立一个屏障。 

## 分类

* 包过滤防火墙 **`packet filtering`**
* 应用代理防火墙 **`application proxy`**
* 状态检测防火墙 **`stateful inspection`**

## 实例

商业

| 厂商    | 名称           | 英文名称                    | 缩写 |
| ------- | -------------- | --------------------------- | ---- |
| Cisco   | 自适应安全设备 | Adaptive Security Appliance | ASA  |
| Juniper | 安全业务网关   | Secure Services Gateway     | SSG  |
| HUAWEI  | 统一安全网关   | Unified Security Gateway    | USG  |

开源

| OS          | Version | Firewall  |
| ----------- | ------- | --------- |
| RHEL/CentOS | 7       | firewalld |
| RHEL        |         | iptables  |
| RHEL        |         | ip6tables |
| RHEL        |         | ebtables  |
| Ubuntu      | 14.04   | ufw       |
| FreeBSD     |         | IPFW      |
| FreeBSD     |         | PF        |
|             |         | ipfwadm   |
|             |         | ipchains  |

## 局限性

* 不能防止自然或者人为的故意破坏。
* 不能防止受病毒感染的文件的传输。
* 不能解决来自内部网络的攻击和安全问题。
* 不能防止策略配置不当或者配置错误引起的安全威胁。
* 不能防止网络防火墙自身的安全漏洞所带来的威胁。

2、firewalld、iptables和nftables关系

在centos7及之前版本中，iptables也提供了类似firewalld的daemon，用户可以选择iptables或firewalld daemon其一。centos8已弃用iptables，只用nftables。

nftables和iptables负责的应该属于数据包过滤框架。nftables是从linux内核3.13开始出现，旨在替代现存的 {ip,ip6,arp,eb}_tables（本文统称为iptables）。

*![img](https://img2018.cnblogs.com/i-beta/1900252/201912/1900252-20191218102353915-1460990091.png)*

 （上图中有处错误，nft指令错写成ntf指令）