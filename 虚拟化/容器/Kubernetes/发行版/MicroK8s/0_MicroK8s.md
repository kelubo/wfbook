# MicroK8s

[TOC]

## 概述                                                   

**MicroK8s** is a low-ops, minimal production Kubernetes.
**MicroK8s** 是一种低作、最小生产 Kubernetes。

Zero-ops, pure-upstream, HA Kubernetes,
零操作、纯上游、HA Kubernetes、
从开发人员工作站到生产。

MicroK8s 是一个开源系统，用于自动部署、扩展和管理容器化应用程序。它提供核心 Kubernetes 组件的功能，占用空间小，可从单个节点扩展到高可用性生产集群。

MicroK8s 是一个轻量级的 Kubernetes 发行版。在您的笔记本电脑、Raspberry Pi 或 Intel NUC 或任何公共云中运行企业级 Kubernetes ，同时消耗最少的资源。 

通过减少运行 Kubernetes 所需的资源承诺，MicroK8s 可以将 Kubernetes 引入新的环境，例如：

- 将 Kubernetes 转变为轻量级开发工具
- 使 Kubernetes 可用于最小的环境，例如 GitHub CI
- 使 Kubernetes 适应小型设备 IoT 应用程序

开发人员使用 MicroK8s 作为新想法的廉价试验场。在生产中，ISV 受益于较低的开销和资源需求以及更短的开发周期，使他们能够比以往更快地交付设备。

MicroK8s 生态系统包括数十个有用的**插件** - 提供额外功能和特性的扩展。

## 特点 

* 高可用性（HA） 

  HA Kubernetes 集群可以承受任何组件上的故障，并在不中断的情况下继续为工作负载提供服务。 

  MicroK8s delivers a production-grade Kubernetes cluster simply by adding more  MicroK8s nodes. There is no extra configuration required - install  MicroK8s on three machines, run the join command to link them together  and in moments, you have a production-grade Kubernetes cluster with HA  enabled automatically.
  MicroK 8 s 只需添加更多 MicroK 8 s 节点即可提供生产级 Kubernetes 集群。不需要额外的配置-在三台机器上安装 MicroK  8，运行 join 命令将它们链接在一起，很快，您就拥有了一个自动启用 HA 的生产级 Kubernetes 集群。 

  * Autonomous HA Kubernetes 自治 HA Kubernetes 

    Autonomy combined with high availability delivers a full Kubernetes with minimal setup, able to support mission-critical workloads with operational  efficiency.
    自治与高可用性相结合，以最少的设置提供完整的 Kubernetes，能够以运营效率支持关键任务工作负载。 

    MicroK8s uses Dqlite, a high-availability SQLite, as its datastore. As soon as  the cluster includes three or more nodes, Dqlite is resilient and the  API services are distributed on all of them. If one node should fail or  be restarted, Kubernetes keeps running and will recover itself back to  full HA when the node becomes available again, with no administrative  action. 
    MicroK8s 使用 Dqlite，一种高可用性的 SQLite，作为其扩展。只要集群包含三个或更多节点，Dqlite 就具有弹性，并且 API  服务分布在所有节点上。如果一个节点发生故障或重新启动，Kubernetes 将继续运行，并在节点再次可用时恢复到完全 HA 状态，无需管理操作。

* Strict confinement 严格监禁 



------



------

## 

Get isolation and minimise risk with strict confinement. Run sophisticated  and otherwise high-risk internet of things (IoT) workloads while  vulnerabilities are limited to a single application. 
获得隔离，并通过严格的限制将风险降至最低。运行复杂且高风险的物联网（IoT）工作负载，而漏洞仅限于单个应用程序。 

With strict confinement enabled, the system ensures that MicroK8s and its  container workloads can only access files, system resources, and  hardware for which access has been granted.
启用严格限制后，系统可确保 MicroK8 及其容器工作负载只能访问已授予访问权限的文件、系统资源和硬件。 

By restricting Kubernetes to the absolutely necessary permissions, strict  confinement eliminates vulnerable interactions both within the host  device and externally, greatly reducing the attack surface.
通过将 Kubernetes 限制为绝对必要的权限，严格的限制消除了主机设备内部和外部的脆弱交互，大大减少了攻击面。 

​          [Read the whitepaper about strict confinement ›
 阅读有关严格限制的白皮书› ](https://ubuntu.com/engage/secure-kubernetes-at-the-edge)        

------

## Automated cluster creation and management 自动化集群创建和管理 

MicroK8s supports automated cluster creation and life cycle management with ClusterAPI (CAPI).
MicroK 8 s 支持自动化集群创建和生命周期管理，并支持 CAPI。 

CAPI abstracts away the details of infrastructure provisioning, networking,  and other low-level tasks, so users can define their desired cluster  configuration using simple YAML manifests. 
CAPI 抽象了基础设施配置、网络和其他低级任务的详细信息，因此用户可以使用简单的 YAML 清单定义所需的集群配置。 

MicroK8s and CAPI allow you to easily provision clusters and deploy them behind proxies.
MicroK 8 和 CAPI 允许您轻松地配置群集并将其部署在代理之后。 

Rolling upgrades for high-availability (HA) clusters and worker notes mean you  can upgrade clusters with no downtime. It also supports in-place  upgrades for non-HA control planes.
高可用性（HA）群集和工作人员笔记的滚动升级意味着您可以在不停机的情况下升级群集。它还支持非 HA 控制平面的就地升级。 

​          [Learn how to deploy MicroK8s with CAPI ›
 了解如何使用 CAPI 部署 MicroK 8 › ](https://microk8s.io/docs/capi-provision)        

------

## NVIDIA GPU support, ideal for AI/ML and HPC NVIDIA GPU 支持，是 AI/ML 和 HPC 的理想选择 

Enable the MicroK8s GPU addon, and your Kubernetes workloads will be able to  run on containers optimised for AI/ML workloads or High Performance  computing (HPC) tasks.
启用 MicroK 8 s GPU 插件，您的 Kubernetes 工作负载将能够在针对 AI/ML 工作负载或高性能计算（HPC）任务优化的容器上运行。 

MicroK8s uses the NVIDIA GPU Operator to support the necessary drivers,  configuration and container runtimes. For the most effective use of your NVIDIA hardware, this includes support for Multi-instance GPUs (MIG).
MicroK8s 使用 NVIDIA GPU Operator 来支持必要的驱动程序、配置和容器运行时。为了最有效地使用 NVIDIA 硬件，这包括对多实例 GPU（GPU）的支持。 

​          [Learn more about NVIDIA GPU support on MicroK8s ›
 了解有关 MicroK8s 上的 NVIDIA GPU 支持的更多信息› ](https://microk8s.io/docs/addon-gpu)        

------

## Custom launch configurations 自定义启动配置 

MicroK8s was always simple to install, but now it's simple to install, the way  you want it. Use a custom Container Network Interface (CNI), set  specific service options, configure registries, and enable the add-ons  you want - all without an extra keystroke. Brilliant for automated,  repeatable, reliable deployment and especially useful for air-gapped  instals, embedded applications, and integration with public clouds.
MicroK 8 s  的安装一直很简单，但现在它的安装很简单，可以按照您想要的方式进行。使用自定义容器网络接口（CNI），设置特定的服务选项，配置注册表，并启用您想要的附加组件-所有这些都无需额外的插件。非常适合自动化、可重复、可靠的部署，尤其适用于气隙安装、嵌入式应用程序以及与公共云的集成。 

​          [Perform a complicated custom K8s setup in seconds ›
 在几秒钟内执行复杂的自定义 K8s 设置› ](https://microk8s.io/docs/explain-launch-config)        

------

## Better user experience with addons 通过插件获得更好的用户体验 

To keep MicroK8s light and flexible, the standard install only has the  components needed to deploy Kubernetes. Depending on the use case, there are plenty of additional Kubernetes services or operators that would be nice to have.
为了保持 MicroK8 的轻便和灵活性，标准安装只包含部署 Kubernetes 所需的组件。根据用例的不同，有很多额外的 Kubernetes 服务或操作符是很好的选择。 

MicroK8s addresses this with addons — extra services that can easily be added to MicroK8s. You can enable or disable addons at any time. Most are  pre-configured to 'just work' without any further set up.
MicroK 8 通过插件解决了这个问题-可以轻松添加到 MicroK 8 的额外服务。您可以随时启用或禁用插件。大多数都是预先配置为“只是工作”，没有任何进一步的设置。 

There are addons specifically created and supported by the MicroK8s team and a large selection of addons made by our community and partners. If your  favourite is missing, you can easily make your own.
MicroK 8 s 团队专门创建和支持的插件以及我们的社区和合作伙伴制作的大量插件。如果您最喜欢的东西不见了，您可以轻松地制作自己的。 

​          [Check out all available addons ›
 查看所有可用的插件› ](https://microk8s.io/docs/addons)        

------

## MicroK8s and Ubuntu Core MicroK8s 和 Ubuntu Core 

Both MicroK8s and Ubuntu Core focus on reliability and security, with  features such as self-healing, high availability and automatic OTA  updates.
MicroK8 和 Ubuntu Core 都专注于可靠性和安全性，具有自我修复，高可用性和自动 OTA 更新等功能。 

Combining Ubuntu Core and MicroK8s streamlines and embeds Kubernetes, with  optimisations for size and performance in IoT and Edge applications.
结合 Ubuntu Core 和 MicroK8s 简化和嵌入 Kubernetes，优化物联网和边缘应用程序的大小和性能。 

​          [Get started with MicroK8s on Ubuntu Core ›
 在 Ubuntu Core 上开始使用 MicroK8s › ](https://ubuntu.com/tutorials/getting-started-with-microk8s-on-ubuntu-core#1-introduction)        

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

