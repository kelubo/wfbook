# MicroK8s

[TOC]

## 概述                                                   

**MicroK8s** is a low-ops, minimal production Kubernetes.
**MicroK8s** 是一种低作、最小生产 Kubernetes。

Zero-ops, pure-upstream, HA Kubernetes,
零操作、纯上游、HA Kubernetes、
从开发人员工作站到生产。

MicroK8s 是一个开源系统，用于自动部署、扩展和管理容器化应用程序。它提供核心 Kubernetes 组件的功能，占用空间小，可从单个节点扩展到高可用性生产集群。

通过减少运行 Kubernetes 所需的资源承诺，MicroK8s 可以将 Kubernetes 引入新的环境，例如：

- 将 Kubernetes 转变为轻量级开发工具
- 使 Kubernetes 可用于最小的环境，例如 GitHub CI
- 使 Kubernetes 适应小型设备 IoT 应用程序

开发人员使用 MicroK8s 作为新想法的廉价试验场。在生产中，ISV 受益于较低的开销和资源需求以及更短的开发周期，使他们能够比以往更快地交付设备。

MicroK8s 生态系统包括数十个有用的**插件** - 提供额外功能和特性的扩展。

## 比较功能

| 特征                               | ![MicroK8s](https://assets.ubuntu.com/v1/78679228-microk8s.svg) | ![K3s](https://assets.ubuntu.com/v1/d07473a1-k3s.svg) | ![minikube](https://assets.ubuntu.com/v1/268abf4b-minikube-on-grey.png) |
| ---------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------- | ------------------------------------------------------------ |
| CNCF 认证                          | yes                                                          | yes                                                   | yes                                                          |
| Vanilla Kubernetes 原版 Kubernetes | yes                                                          | –                                                     | yes                                                          |
| 架构支持                           | x86, ARM64, s390x, POWER9                                    | x86, ARM64, ARMhf                                     | x86, ARM64, ARMv7, ppc64,  s390x                             |
| 企业支持                           | yes                                                          | yes                                                   | –                                                            |
| 单节点支持                         | yes                                                          | yes                                                   | yes                                                          |
| 多节点集群支持                     | yes                                                          | yes                                                   | –                                                            |
| 自动高可用性                       | yes                                                          | yes                                                   | –                                                            |
| 自动更新                           | yes                                                          | yes                                                   | –                                                            |
| 内存要求                           | 540 MB                                                       | 512 MB                                                | 644 MB  644 兆字节                                           |
| 附加组件功能                       | yes                                                          | –                                                     | yes                                                          |
| 容器运行时                         | containerd, kata                                             | CRI-O, containerd                                     | Docker, containerd, CRI-O                                    |
| 联网                               | Calico, Cilium, CoreDNS, Traefik, NGINX, Ambassador, Multus, MetalLB | Flannel, CoreDNS, Traefik, Canal, Klipper             | Calico, Cilium, Flannel, ingress, DNS, Kindnet               |
| 默认存储选项                       | Hostpath storage, OpenEBS, Ceph                              | Hostpath storage, Longhorn                            | Hostpath storage                                             |
| GPU 加速                           | yes                                                          | yes                                                   | yes                                                          |

## 依赖

- 用于运行命令的 Ubuntu 环境（或其他支持 `snapd` 的作系统）。如果没有 Linux 计算机，则可以使用 Multipass 。
- MicroK8s 的内存低至 540MB，但为了适应工作负载，建议使用至少具有 20G 磁盘空间和 4G 内存的系统。
- 互联网连接

**注意：**如果不满足这些要求，还有其他方法可以安装 MicroK8s，包括额外的作系统支持和离线部署。

