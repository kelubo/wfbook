# Xen

[TOC]

## 概念

* 域

  一个正在运行的虚拟机。

* dom0

  享有对硬件的全部访问权限，负责管理其他的域，运行所有的设备驱动程序。

* domU

  没有特权的域。

## 管理工具
* Xen Tools
* MLN(Manage Large Networks)
* ConVirt
* xm

## 组件
| 路径 | 用途 |
|----|----|
| /etc/xen | 主要配置文件 |
| /etc/xen/xend-config.sxp | 顶级的xend配置文件 |
| /etc/xen/auto | guest操作系统的配置文件，在引导时刻自动启动这个操作系统 |
| /etc/xen/scripts | 创建网络接口等的工具脚本 |
| /var/log/xen | Xen的日志文件 |
| /usr/sbin/xend | 掌握Xen的控制守护进程 |
| /usr/sbin/xm | Xen的guest域管理工具 |

## 技术分类

* XenServer

  开源，有 Citrix 的商业支持。

* Xen Cloud Platform (XCP)

  开源版本，等同于 XenServer 。

* XenAPI

  管理 XenServer 和 XCP 的 API 程序。

* XAPI

  XenServer 和 XCP 的主守护进程，于 XenAPI 直接通信。

* 基于 Libvirt 的 Xen

  Xen 虚拟化技术使用 Libvirt 驱动。
