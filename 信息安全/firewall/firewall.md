# Firewall

[TOC]

## 概述

允许用户通过定义一组防火墙规则来控制主机上的入站网络流量。这些规则用于对进入的流量进行排序，并可以阻断或允许流量。 

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