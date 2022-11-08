# 安装方法选择

[TOC]

## 建议方法

### Cephadm

是一款全新的容器化部署工具。使用 container 和 systemd 安装和管理 Ceph 集群，并与 CLI 和 dashboard GUI 紧密集成。

cephadm 通过 SSH 将 MGR 守护进程连接到主机，实现部署和管理 Ceph 集群。MGR 能够添加、删除和更新 Ceph 容器。cephadm 不依赖于外部配置工具，如 Ansible , Rook 和 Salt 。然而，这些外部配置工具可以用于自动化 cephadm 本身不执行的操作。

- 只支持 Octopus（v15.2.0）及以上版本。

- cephadm 与新的编排 API 完全集成，并完全支持新的 CLI 和 dashboard 功能来管理集群部署。

- cephadm 需要容器支持（podman 或 docker）和 python3。

cephadm 管理 Ceph 集群的整个生命周期。这个周期从引导过程开始，cephadm 在单个节点上创建一个小型 Ceph 集群。此群集由一个 MON 和一个 MGR 组成。cephadm 然后使用编排接口（“day2”命令）扩展集群，添加所有主机并配置所有 Ceph 守护进程和服务。此生命周期的管理可以通过 Ceph CLI 或 dashboard（GUI）执行。

**功能：**

1. 引导一个新的集群。
2. launch a containerized shell with a working Ceph CLI。启动与 Ceph 命令行界面(CLI)搭配使用的容器化 shell。
3. 帮助调试容器化的 Ceph 守护进程。

**特性：**

- **将所有组件部署在容器中。**
- **与 Orchestrator API 紧密集成。** `Ceph`的`Orchestrator`界面在`cephadm`的开发过程中得到了广泛的发展，以匹配实现并清晰地抽象出`Rook`中存在的（略有不同）功能。最终结果是不管是看起来还是感觉都像`Ceph`的一部分。
- **不依赖管理工具。**
- **最小的操作系统依赖性。** `Cephadm`需要`Python 3`，`LVM`和`container runtime`（`Podman`或`Docker`）。
- **将群集彼此隔离。** 支持多个`Ceph`集群同时存在于同一主机上一直是一个比较小众的场景，但是确实存在，并且以一种健壮，通用的方式将集群彼此隔离，这使得测试和重新部署集群对于开发人员和用户而言都是安全自然的过程。
- **自动升级。** 一旦`Ceph`“拥有”自己的部署方式，它就可以以安全和自动化的方式升级`Ceph`。
- **从“传统”部署工具轻松迁移。** 

### Rook

Rook 部署和管理在 Kubernetes 中运行的 Ceph 集群，同时还支持通过 Kubernetes API 管理存储资源和资源调配。推荐 Rook 作为在 Kubernetes 中运行 Ceph 或者将现有 Ceph 存储集群连接到 Kubernetes 的方法。

- 只支持 Nautilus 及以上版本。

- 是在 Kubernetes 上运行 Ceph 或者将 Kubernetes 集群连接到现有（外部）Ceph 集群的首选方法。

- 支持新的 orchestrator API 。完全支持 CLI 和 dashboard 中新的管理功能。


## 其他方法

### ceph-ansible

https://docs.ceph.com/projects/ceph-ansible/en/latest/

使用 ansible 部署和管理 ceph 集群。

- ceph-ansible 被广泛部署。

- ceph-ansible 没有与 Nautlius 和 Octopus 中引入的新的 orchestrator API 集成，这意味着新的管理特性和 dashboard 集成 (dashboard integration) 不可用。


### ceph-deploy

一个快速部署集群的工具。

**不再被积极维护。没有在比 Nautilus 新的版本上进行测试。不支持 RHEL8、CentOS 8 或更新的操作系统。**

### ceph-salt

https://github.com/ceph/ceph-salt

使用 Salt 和 cephadm 安装 Ceph 。

### jaas.ai/ceph-mon

https://jaas.ai/ceph-mon

使用 Juju 安装 Ceph 。

### Helm+kubernetes

### puppet-ceph

https://github.com/openstack/puppet-ceph

通过 Puppet 安装 Ceph 。

### 手动部署

## Windows

参考文档: [Windows installation guide](https://docs.ceph.com/en/latest/install/windows-install).

