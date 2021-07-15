# 安装方法选择

[TOC]

## 建议方法

### Cephadm

Cephadm 使用 container 和 systemd 安装和管理 Ceph 集群，并与 CLI 和 dashboard GUI 紧密集成。通过 SSH 将 manager 守护进程连接到主机来实现这一点。manager 守护进程能够添加、删除和更新Ceph容器。cephadm 不依赖外部配置工具，如 Ansible、Rook 和 Salt。

- 只支持 Octopus（v15.2.0）和更新版本。

- cephadm 与新的编排 API 完全集成，并完全支持新的 CLI 和 dashboard 功能来管理集群部署。

- cephadm 需要容器支持（podman 或 docker）和 python3。

### Rook

Rook 部署和管理在 Kubernetes 中运行的 Ceph 集群，同时还支持通过 Kubernetes API 管理存储资源和资源调配。推荐 Rook 作为在 Kubernetes 中运行 Ceph 或者将现有 Ceph 存储集群连接到 Kubernetes 的方法。

- 只支持 Nautilus 和 Ceph 的更新版本。

- 是在 Kubernetes 上运行 Ceph 或者将 Kubernetes 集群连接到现有（外部）Ceph 集群的首选方法。

- 支持新的 orchestrator API 。完全支持 CLI 和 dashboard 中新的管理功能。


## 其他方法

### ceph-ansible

使用 ansible 部署和管理 ceph 集群。

- ceph-ansible 被广泛部署。

- ceph-ansible 没有与 Nautlius 和 Octopus 中引入的新的 orchestrator API 集成，这意味着新的管理特性和 dashboard 集成(dashboard integration)不可用。


### ceph-deploy

是一个快速部署集群的工具。

> **Important**
>
> 不再被积极维护。没有在比 Nautilus 新的版本上进行测试。不支持 RHEL8、CentOS 8 或更新的操作系统。

### ceph-salt

 Salt and cephadm安装 Ceph .

[jaas.ai/ceph-mon](https://jaas.ai/ceph-mon) installs Ceph using Juju.

[github.com/openstack/puppet-ceph](https://github.com/openstack/puppet-ceph)  installs Ceph via Puppet.

Ceph can also be [installed manually](https://docs.ceph.com/en/latest/install/index_manual/#install-manual).

### Helm+kubernetes

installs Ceph using Salt and cephadm.

### jaas.ai/ceph-mon

installs Ceph using Juju.

### github.com/openstack/puppet-ceph

installs Ceph via Puppet.

### 手动部署

## Windows

参考文档: [Windows installation guide](https://docs.ceph.com/en/latest/install/windows-install).

