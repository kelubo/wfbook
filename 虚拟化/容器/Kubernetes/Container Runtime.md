# Container Runtime

[TOC]

> **说明：**
>
> 自 1.24 版起，Dockershim 已从 Kubernetes 项目中移除。

需要在集群内每个节点上安装一个 Container Runtime 以使 Pod 可以运行在上面。Kubernetes 1.30 要求使用符合[容器运行时接口](https://kubernetes.io/zh-cn/docs/concepts/overview/components/#container-runtime)（CRI）的运行时。

在 Kubernetes 中几个常见的容器运行时：

- [containerd](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#containerd)
- [CRI-O](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#cri-o)
- [Docker Engine](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#docker)
- [Mirantis Container Runtime](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#mcr)

> **说明：**
>
> v1.24 之前的 Kubernetes 版本直接集成了 Docker Engine 的一个组件，名为 **dockershim** 。 这种特殊的直接整合不再是 Kubernetes 的一部分 （这次删除被作为 v1.20 发行版本的一部分[宣布](https://kubernetes.io/zh-cn/blog/2020/12/08/kubernetes-1-20-release-announcement/#dockershim-deprecation)）。

## 安装和配置先决条件

默认情况下，Linux 内核不允许 IPv4 数据包在接口之间路由。大多数 Kubernetes 集群网络实现都会更改此设置（如果需要），但有些人可能希望管理员为他们执行此操作。

### 启用 IPv4 数据包转发

手动启用 IPv4 数据包转发：

```bash
# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# 应用 sysctl 参数而不重新启动
sudo sysctl --system
```

使用以下命令验证 `net.ipv4.ip_forward` 是否设置为 1：

```bash
sysctl net.ipv4.ip_forward
```

## cgroup 驱动

在 Linux 上，[控制组（CGroup）](https://kubernetes.io/zh-cn/docs/reference/glossary/?all=true#term-cgroup)用于限制分配给进程的资源。

[kubelet](https://kubernetes.io/docs/reference/generated/kubelet) 和底层容器运行时都需要对接控制组来强制执行 [为 Pod 和容器管理资源](https://kubernetes.io/zh-cn/docs/concepts/configuration/manage-resources-containers/) 并为诸如 CPU、内存这类资源设置请求和限制。若要对接控制组，kubelet 和容器运行时需要使用一个 **cgroup 驱动**。 关键的一点是 kubelet 和容器运行时需使用相同的 cgroup 驱动并且采用相同的配置。

可用的 cgroup 驱动有两个：

- [`cgroupfs`](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#cgroupfs-cgroup-driver)
- [`systemd`](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)

### cgroupfs 驱动

`cgroupfs` 驱动是 [kubelet 中默认的 cgroup 驱动](https://kubernetes.io/zh-cn/docs/reference/config-api/kubelet-config.v1beta1)。 当使用 `cgroupfs` 驱动时， kubelet 和容器运行时将直接对接 cgroup 文件系统来配置 cgroup。

当 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 是初始化系统时， **不** 推荐使用 `cgroupfs` 驱动，因为 systemd 期望系统上只有一个 cgroup 管理器。 此外，如果你使用 [cgroup v2](https://kubernetes.io/zh-cn/docs/concepts/architecture/cgroups)， 则应用 `systemd` cgroup 驱动取代 `cgroupfs`。

### systemd cgroup 驱动

当某个 Linux 系统发行版使用 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 作为其初始化系统时，初始化进程会生成并使用一个 root 控制组（`cgroup`），并充当 cgroup 管理器。

systemd 与 cgroup 集成紧密，并将为每个 systemd 单元分配一个 cgroup。 因此，如果你 `systemd` 用作初始化系统，同时使用 `cgroupfs` 驱动，则系统中会存在两个不同的 cgroup 管理器。

同时存在两个 cgroup 管理器将造成系统中针对可用的资源和使用中的资源出现两个视图。某些情况下， 将 kubelet 和容器运行时配置为使用 `cgroupfs`、但为剩余的进程使用 `systemd` 的那些节点将在资源压力增大时变得不稳定。

当 systemd 是选定的初始化系统时，缓解这个不稳定问题的方法是针对 kubelet 和容器运行时将 `systemd` 用作 cgroup 驱动。

要将 `systemd` 设置为 cgroup 驱动，需编辑 [`KubeletConfiguration`](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubelet-config-file/) 的 `cgroupDriver` 选项，并将其设置为 `systemd`。例如：

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
...
cgroupDriver: systemd
```

#### 说明：

从 v1.22 开始，在使用 kubeadm 创建集群时，如果用户没有在 `KubeletConfiguration` 下设置 `cgroupDriver` 字段，kubeadm 默认使用 `systemd`。

在 Kubernetes v1.28 中，启用 `KubeletCgroupDriverFromCRI` [特性门控](https://kubernetes.io/zh-cn/docs/reference/command-line-tools-reference/feature-gates/)结合支持 `RuntimeConfig` CRI RPC 的容器运行时，kubelet 会自动从运行时检测适当的 Cgroup 驱动程序，并忽略 kubelet 配置中的 `cgroupDriver` 设置。

如果你将 `systemd` 配置为 kubelet 的 cgroup 驱动，你也必须将 `systemd` 配置为容器运行时的 cgroup 驱动。参阅容器运行时文档，了解指示说明。例如：

- [containerd](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#containerd-systemd)
- [CRI-O](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#cri-o)

#### 注意：

注意：更改已加入集群的节点的 cgroup 驱动是一项敏感的操作。 如果 kubelet 已经使用某 cgroup 驱动的语义创建了 Pod，更改运行时以使用别的 cgroup 驱动，当为现有 Pod 重新创建 PodSandbox 时会产生错误。 重启 kubelet 也可能无法解决此类问题。

如果你有切实可行的自动化方案，使用其他已更新配置的节点来替换该节点， 或者使用自动化方案来重新安装。

### 将 kubeadm 管理的集群迁移到 `systemd` 驱动

如果你希望将现有的由 kubeadm 管理的集群迁移到 `systemd` cgroup 驱动， 请按照[配置 cgroup 驱动](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)操作。

## CRI 版本支持

你的容器运行时必须至少支持 v1alpha2 版本的容器运行时接口。

Kubernetes [从 1.26 版本开始](https://kubernetes.io/blog/2022/11/18/upcoming-changes-in-kubernetes-1-26/#cri-api-removal)**仅适用于** v1 版本的容器运行时（CRI）API。早期版本默认为 v1 版本， 但是如果容器运行时不支持 v1 版本的 API， 则 kubelet 会回退到使用（已弃用的）v1alpha2 版本的 API。

## 容器运行时

**说明：** 本部分链接到提供 Kubernetes 所需功能的第三方项目。Kubernetes 项目作者不负责这些项目。此页面遵循[CNCF 网站指南](https://github.com/cncf/foundation/blob/master/website-guidelines.md)，按字母顺序列出项目。要将项目添加到此列表中，请在提交更改之前阅读[内容指南](https://kubernetes.io/zh-cn/docs/contribute/style/content-guide/#third-party-content)。

### containerd

本节概述了使用 containerd 作为 CRI 运行时的必要步骤。

要在系统上安装 containerd，请按照[开始使用 containerd](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) 的说明进行操作。创建有效的 `config.toml` 配置文件后返回此步骤。

- [Linux](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#finding-your-config-toml-file-0)
- [Windows](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#finding-your-config-toml-file-1)



你可以在路径 `/etc/containerd/config.toml` 下找到此文件。

在 Linux 上，containerd 的默认 CRI 套接字是 `/run/containerd/containerd.sock`。 在 Windows 上，默认 CRI 端点是 `npipe://./pipe/containerd-containerd`。

#### 配置 `systemd` cgroup 驱动

结合 `runc` 使用 `systemd` cgroup 驱动，在 `/etc/containerd/config.toml` 中设置：

```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

如果你使用 [cgroup v2](https://kubernetes.io/zh-cn/docs/concepts/architecture/cgroups)，则推荐 `systemd` cgroup 驱动。

#### 说明：

如果你从软件包（例如，RPM 或者 `.deb`）中安装 containerd，你可能会发现其中默认禁止了 CRI 集成插件。

你需要启用 CRI 支持才能在 Kubernetes 集群中使用 containerd。 要确保 `cri` 没有出现在 `/etc/containerd/config.toml` 文件中 `disabled_plugins` 列表内。如果你更改了这个文件，也请记得要重启 `containerd`。

如果你在初次安装集群后或安装 CNI 后遇到容器崩溃循环，则随软件包提供的 containerd 配置可能包含不兼容的配置参数。考虑按照 [getting-started.md](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#advanced-topics) 中指定的 `containerd config default > /etc/containerd/config.toml` 重置 containerd 配置，然后相应地设置上述配置参数。

如果你应用此更改，请确保重新启动 containerd：

```shell
sudo systemctl restart containerd
```

当使用 kubeadm 时，请手动配置 [kubelet 的 cgroup 驱动](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver)。

在 Kubernetes v1.28 中，你可以启用 Cgroup 驱动程序的自动检测的 Alpha 级别特性。 详情参阅 [systemd cgroup 驱动](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)。

#### 重载沙箱（pause）镜像

在你的 [containerd 配置](https://github.com/containerd/containerd/blob/main/docs/cri/config.md)中， 你可以通过设置以下选项重载沙箱镜像：

```toml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.2"
```

一旦你更新了这个配置文件，可能就同样需要重启 `containerd`：`systemctl restart containerd`。

请注意，声明匹配的 `pod-infra-container-image` 是 kubelet 的最佳实践。 如果未配置，kubelet 可能会尝试对 `pause` 镜像进行垃圾回收。 [containerd 固定 pause 镜像](https://github.com/containerd/containerd/issues/6352)的工作正在进行中， 将不再需要在 kubelet 上进行此设置。

### CRI-O

本节包含安装 CRI-O 作为容器运行时的必要步骤。

要安装 CRI-O，请按照 [CRI-O 安装说明](https://github.com/cri-o/packaging/blob/main/README.md#usage)执行操作。

#### cgroup 驱动

CRI-O 默认使用 systemd cgroup 驱动，这对你来说可能工作得很好。 要切换到 `cgroupfs` cgroup 驱动，请编辑 `/etc/crio/crio.conf` 或在 `/etc/crio/crio.conf.d/02-cgroup-manager.conf` 中放置一个插入式配置，例如：

```toml
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "cgroupfs"
```

你还应该注意当使用 CRI-O 时，并且 CRI-O 的 cgroup 设置为 `cgroupfs` 时，必须将 `conmon_cgroup` 设置为值 `pod`。 通常需要保持 kubelet 的 cgroup 驱动配置（通常通过 kubeadm 完成）和 CRI-O 同步。

在 Kubernetes v1.28 中，你可以启用 Cgroup 驱动程序的自动检测的 Alpha 级别特性。 详情参阅 [systemd cgroup 驱动](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)。

对于 CRI-O，CRI 套接字默认为 `/var/run/crio/crio.sock`。

#### 重载沙箱（pause）镜像

在你的 [CRI-O 配置](https://github.com/cri-o/cri-o/blob/main/docs/crio.conf.5.md)中， 你可以设置以下配置值：

```toml
[crio.image]
pause_image="registry.k8s.io/pause:3.6"
```

这一设置选项支持动态配置重加载来应用所做变更：`systemctl reload crio`。 也可以通过向 `crio` 进程发送 `SIGHUP` 信号来实现。

### Docker Engine

#### 说明：

以下操作假设你使用 [`cri-dockerd`](https://mirantis.github.io/cri-dockerd/) 适配器来将 Docker Engine 与 Kubernetes 集成。

1. 在你的每个节点上，遵循[安装 Docker Engine](https://docs.docker.com/engine/install/#server) 指南为你的 Linux 发行版安装 Docker。

1. 请按照文档中的安装部分指示来安装 [`cri-dockerd`](https://mirantis.github.io/cri-dockerd/usage/install)。

对于 `cri-dockerd`，默认情况下，CRI 套接字是 `/run/cri-dockerd.sock`。

### Mirantis 容器运行时

[Mirantis Container Runtime](https://docs.mirantis.com/mcr/20.10/overview.html) (MCR) 是一种商用容器运行时，以前称为 Docker 企业版。 你可以使用 MCR 中包含的开源 [`cri-dockerd`](https://mirantis.github.io/cri-dockerd/) 组件将 Mirantis Container Runtime 与 Kubernetes 一起使用。

要了解有关如何安装 Mirantis Container Runtime 的更多信息， 请访问 [MCR 部署指南](https://docs.mirantis.com/mcr/20.10/install.html)。

检查名为 `cri-docker.socket` 的 systemd 单元以找出 CRI 套接字的路径。

#### 重载沙箱（pause）镜像

`cri-dockerd` 适配器能够接受指定用作 Pod 的基础容器的容器镜像（“pause 镜像”）作为命令行参数。 要使用的命令行参数是 `--pod-infra-container-image`。











## Cgroup 驱动程序

控制组用来约束分配给进程的资源。

当某个 Linux 系统发行版使用 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 作为其初始化系统时，初始化进程会生成并使用一个 root 控制组 (`cgroup`), 并充当 cgroup 管理器。 Systemd 与 cgroup 集成紧密，并将为每个 systemd 单元分配一个 cgroup。 也可以配置容器运行时和 kubelet 使用 `cgroupfs`。 连同 systemd 一起使用 `cgroupfs` 意味着将有两个不同的 cgroup 管理器。

单个 cgroup 管理器将简化分配资源的视图，并且默认情况下将对可用资源和使用中的资源具有更一致的视图。 当有两个管理器共存于一个系统中时，最终将对这些资源产生两种视图。在此领域人们已经报告过一些案例，某些节点配置让 kubelet 和 docker 使用 `cgroupfs`，而节点上运行的其余进程则使用 systemd; 这类节点在资源压力下会变得不稳定。

更改设置，令 Container Runtime 和 kubelet 使用 `systemd` 作为 cgroup 驱动，以此使系统更为稳定。 对于 Docker, 设置 `native.cgroupdriver=systemd` 选项。

**注意：**更改已加入集群的节点的 cgroup 驱动是一项敏感的操作。 如果 kubelet 已经使用某 cgroup 驱动的语义创建了 pod，更改运行时以使用 别的 cgroup 驱动，当为现有 Pods 重新创建 PodSandbox 时会产生错误。 重启 kubelet 也可能无法解决此类问题。 如果你有切实可行的自动化方案，使用其他已更新配置的节点来替换该节点， 或者使用自动化方案来重新安装。

## Cgroup v2

Cgroup v2 是 cgroup Linux API 的下一个版本。与 cgroup v1 不同的是， Cgroup v2 只有一个层次结构，而不是每个控制器有一个不同的层次结构。

新版本对 cgroup v1 进行了多项改进，其中一些改进是：

- 更简洁、更易于使用的 API
- 可将安全子树委派给容器
- 更新的功能，如压力失速信息（Pressure Stall Information）

尽管内核支持混合配置，即其中一些控制器由 cgroup v1 管理，另一些由 cgroup v2 管理， Kubernetes 仅支持使用同一 cgroup 版本来管理所有控制器。

如果 systemd 默认不使用 cgroup v2，你可以通过在内核命令行中添加 `systemd.unified_cgroup_hierarchy=1` 来配置系统去使用它。

```bash
dnf install -y grubby && \
  sudo grubby \
  --update-kernel=ALL \
  --args=”systemd.unified_cgroup_hierarchy=1"
```

要应用配置，必须重新启动节点。

切换到 cgroup v2 时，用户体验不应有任何明显差异， 除非用户直接在节点上或在容器内访问 cgroup 文件系统。 为了使用它，CRI 运行时也必须支持 cgroup v2。

### 将 kubeadm 托管的集群迁移到 `systemd` 驱动

如果你想迁移到现有 kubeadm 托管集群中的 `systemd` cgroup 驱动程序， 遵循此[迁移指南](https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver)。

## Container Runtime

### containerd

安装和配置的先决条件：

```shell
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 设置必需的 sysctl 参数，这些参数在重新启动后仍然存在。
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# 应用 sysctl 参数而无需重新启动
sudo sysctl --system
```

安装和配置 containerd:

```bash
# Linux
1.从官方Docker仓库安装 containerd.io 软件包。

2.配置 containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

3.重新启动 containerd
sudo systemctl restart containerd

# Windows (PowerShell)
1.启动 Powershell 会话，将 $Version 设置为所需的版本（例如：$Version=1.4.3）。

2.下载 containerd：
curl.exe -L https://github.com/containerd/containerd/releases/download/v$Version/containerd-$Version-windows-amd64.tar.gz -o containerd-windows-amd64.tar.gz
tar.exe xvf .\containerd-windows-amd64.tar.gz

3.提取并配置：
Copy-Item -Path ".\bin\" -Destination "$Env:ProgramFiles\containerd" -Recurse -Force
cd $Env:ProgramFiles\containerd\
.\containerd.exe config default | Out-File config.toml -Encoding ascii

# 检查配置。根据你的配置，可能需要调整：
# - sandbox_image (Kubernetes pause 镜像)
# - cni bin_dir 和 conf_dir 位置
Get-Content config.toml

# (可选 - 不过强烈建议) 禁止 Windows Defender 扫描 containerd
Add-MpPreference -ExclusionProcess "$Env:ProgramFiles\containerd\containerd.exe"

4.启动 containerd:
.\containerd.exe --register-service
Start-Service containerd
```

#### 使用 `systemd` cgroup 驱动程序

结合 `runc` 使用 `systemd` cgroup 驱动，在 `/etc/containerd/config.toml` 中设置

```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

如果应用此更改，请确保再次重新启动 containerd：

```bash
sudo systemctl restart containerd
```

当使用 kubeadm 时，请手动配置 [kubelet 的 cgroup 驱动](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-control-plane-node).

### CRI-O

> **说明：**
>
> CRI-O 的主要以及次要版本必须与 Kubernetes 的主要和次要版本相匹配。 更多信息请查阅 [CRI-O 兼容性列表](https://github.com/cri-o/cri-o#compatibility-matrix-cri-o--kubernetes)。

安装并配置前置环境：

```shell
# 创建 .conf 文件以在启动时加载模块
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 配置 sysctl 参数，这些配置在重启之后仍然起作用
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

安装和配置：

```bash
# Debian
1.在下列操作系统上安装 CRI-O, 使用下表中合适的值设置环境变量 OS:
操作系统             $OS
Debian Unstable 	Debian_Unstable
Debian Testing 	    Debian_Testing

2.将 $VERSION 设置为与你的 Kubernetes 相匹配的 CRI-O 版本。 例如，如果你要安装 CRI-O 1.20, 请设置 VERSION=1.20.也可以安装一个特定的发行版本。 例如要安装 1.20.0 版本，设置 VERSION=1.20.0:1.20.0.

3.执行:

cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

sudo apt-get update
sudo apt-get install cri-o cri-o-runc

# Ubuntu
1.在下列操作系统上安装 CRI-O, 使用下表中合适的值设置环境变量 OS:
操作系统 	     $OS
Ubuntu 20.04 	xUbuntu_20.04
Ubuntu 19.10 	xUbuntu_19.10
Ubuntu 19.04 	xUbuntu_19.04
Ubuntu 18.04 	xUbuntu_18.04

2.将 $VERSION 设置为与你的 Kubernetes 相匹配的 CRI-O 版本。 例如，如果你要安装 CRI-O 1.20, 请设置 VERSION=1.20. 你也可以安装一个特定的发行版本。 例如要安装 1.20.0 版本，设置 VERSION=1.20:1.20.0.

3.然后执行
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg add -

sudo apt-get update
sudo apt-get install cri-o cri-o-runc

# CentOS
1.在下列操作系统上安装 CRI-O, 使用下表中合适的值设置环境变量 OS:
操作系统 	         $OS
Centos 8 	        CentOS_8
Centos 8 Stream 	CentOS_8_Stream
Centos 7 	        CentOS_7

2.将 $VERSION 设置为与你的 Kubernetes 相匹配的 CRI-O 版本。 例如，如果你要安装 CRI-O 1.20, 请设置 VERSION=1.20. 你也可以安装一个特定的发行版本。 例如要安装 1.20.0 版本，设置 VERSION=1.20:1.20.0.

3.然后执行
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
sudo yum install cri-o

# openSUSE Tumbleweed
sudo zypper install cri-o

# Fedora
1.将 $VERSION 设置为与你的 Kubernetes 相匹配的 CRI-O 版本。 例如，如果要安装 CRI-O 1.20，请设置 VERSION=1.20。 可以用下列命令查找可用的版本：

sudo dnf module list cri-o

2.CRI-O 不支持在 Fedora 上固定到特定的版本。执行
sudo dnf module enable cri-o:$VERSION
sudo dnf install cri-o --now
```

启动 CRI-O：

```bash
sudo systemctl daemon-reload
sudo systemctl enable crio --now
```

#### cgroup 驱动

默认情况下，CRI-O 使用 systemd cgroup 驱动程序。要切换到 `cgroupfs` 驱动程序，或者编辑 `/ etc / crio / crio.conf` 或放置一个插件 在 `/etc/crio/crio.conf.d/02-cgroup-manager.conf` 中的配置，例如：

```toml
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "cgroupfs"
```

另请注意更改后的 `conmon_cgroup`，将 CRI-O 与 `cgroupfs` 一起使用时， 必须将其设置为 `pod`。通常有必要保持 kubelet 的 cgroup 驱动程序配置 （通常透过 kubeadm 完成）和 CRI-O 一致。

### Docker

1.安装

```bash
# all hosts
# Ubuntu
apt-get update && apt-get install docker.io
```

2.配置 Docker 守护程序，尤其是使用 systemd 来管理容器的 cgroup。

```bash
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```

> **说明：**
>
> 对于运行 Linux 内核版本 4.0 或更高版本，或使用 3.10.0-51 及更高版本的 RHEL 或 CentOS 的系统，`overlay2`是首选的存储驱动程序。

3.重新启动 Docker 并在启动时启用：

```bash
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```