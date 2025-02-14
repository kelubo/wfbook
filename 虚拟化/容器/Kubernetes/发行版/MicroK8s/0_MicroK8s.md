# MicroK8s

[TOC]

## 概述                                                   

**MicroK8s** is a low-ops, minimal production Kubernetes.
**MicroK8s** 是一种低作、最小生产 Kubernetes。

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
| 联网                               | Calico, Cilium, CoreDNS, Traefik, Calico、Cilium、CoreDNS、Traefik、NGINX, Ambassador, Multus, MetalLB NGINX、Ambassador、Multus、MetalLB | Flannel, CoreDNS, Traefik, Canal, Klipper             | Calico, Cilium, Flannel, ingress, DNS, Kindnet               |
| 默认存储选项                       | Hostpath storage, OpenEBS, Ceph                              | Hostpath storage, Longhorn                            | Hostpath storage                                             |
| GPU 加速                           | yes                                                          | yes                                                   | yes                                                          |

## 依赖

- 用于运行命令的 Ubuntu 环境（或其他支持 `snapd` 的作系统）。如果没有 Linux 计算机，则可以使用 Multipass 。
- MicroK8s 的内存低至 540MB，但为了适应工作负载，建议使用至少具有 20G 磁盘空间和 4G 内存的系统。
- 互联网连接

**注意：**如果不满足这些要求，还有其他方法可以安装 MicroK8s，包括额外的作系统支持和离线部署。

## 安装

MicroK8s 将安装一个最小的轻量级 Kubernetes，几乎可以在任何机器上运行和使用。它可以通过快速安装：

```bash
snap install microk8s --classic --channel=1.32
```

**Join the group 加入群组**

MicroK8s 会创建一个组，以便无缝使用需要管理员权限的命令。要将当前用户添加到组并获得对 .kube 缓存目录的访问权限，请运行以下三个命令：

```bash
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube
```

需要重新进入会话才能进行组更新：

```bash
su - $USER
```

**检查状态**

MicroK8s 有一个内置命令来显示其状态。在安装过程中，可以使用 **`--wait-ready`** 标志等待 Kubernetes 服务初始化：

```bash
microk8s status --wait-ready
```

**访问 Kubernetes**

MicroK8s 捆绑了自己的 **`kubectl`** 版本来访问 Kubernetes。使用它来运行命令来监视和控制 Kubernetes。例如，要查看节点：

```bash
microk8s kubectl get nodes
```

…或查看正在运行的服务：

```bash
microk8s kubectl get services
```

MicroK8s uses a namespaced kubectl command to prevent conflicts with any  existing installs of kubectl. 
MicroK8s 使用命名空间的 kubectl 命令来防止与任何现有的 kubectl 安装发生冲突。如果没有现有的安装，添加一个别名（附加到 **`~/.bash_aliases`**）会更容易，如下所示：

```bash
alias kubectl='microk8s kubectl'
```

**部署应用程序**

当然，Kubernetes 用于部署应用程序和服务。可以像使用任何 Kubernetes 一样使用 **`kubectl`** 命令来执行此作。尝试安装演示应用程序：

```bash
microk8s kubectl create deployment nginx --image=nginx
```

安装可能需要一两分钟，但可以检查状态：

```bash
microk8s kubectl get pods
```

**使用附加组件**

MicroK8s 使用最少的组件来实现纯轻量级 Kubernetes。但是，使用“附加组件”只需敲击几下键盘即可获得大量额外功能 - 预打包的组件将为您的 Kubernetes 提供额外的功能，从简单的 DNS 管理到使用 Kubeflow 进行机器学习！

首先，建议添加 DNS 管理以促进服务之间的通信。对于需要存储的应用程序，'hostpath-storage' 附加组件在主机上提供目录空间。这些设置很容易：

```bash
microk8s enable dns
microk8s enable hostpath-storage
```

**启动和停止 MicroK8s**

MicroK8s 将继续运行，直到决定停止它。可以使用以下简单命令停止和启动 MicroK8s：

```bash
microk8s stop
```

将停止 MicroK8s 及其服务。可以随时通过运行以下命令重新开始：

```
microk8s start
```

请注意，如果让 MicroK8s 保持运行状态，它将在重新启动后自动重启。如果不希望这种情况发生，只需记住在关闭电源之前运行 `microk8s stop`。