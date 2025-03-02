# Kubeadm
[TOC]
## 安装 kubeadm

### 准备开始

- 一台兼容的 Linux 主机。Kubernetes 项目为基于 Debian 和 Red Hat 的 Linux 发行版以及一些不提供包管理器的发行版提供通用的指令。
- 每台机器 2 GB 或更多的 RAM（如果少于这个数字将会影响你应用的运行内存）。
- CPU 2 核心及以上。
- 集群中的所有机器的网络彼此均能相互连接（公网和内网都可以）。
- 节点之中不可以有重复的主机名、MAC 地址或 product_uuid。
- 开启机器上的某些端口。
- 禁用交换分区。为了保证 kubelet 正常工作，你**必须**禁用交换分区。

### 确保每个节点上 MAC 地址和 product_uuid 的唯一性

- 你可以使用命令 `ip link` 或 `ifconfig -a` 来获取网络接口的 MAC 地址
- 可以使用 `sudo cat /sys/class/dmi/id/product_uuid` 命令对 product_uuid 校验

一般来讲，硬件设备会拥有唯一的地址，但是有些虚拟机的地址可能会重复。 Kubernetes 使用这些值来唯一确定集群中的节点。 如果这些值在每个节点上不唯一，可能会导致安装[失败](https://github.com/kubernetes/kubeadm/issues/31)。

### 检查网络适配器

如果你有一个以上的网络适配器，同时你的 Kubernetes 组件通过默认路由不可达，我们建议你预先添加 IP 路由规则， 这样 Kubernetes 集群就可以通过对应的适配器完成连接。

### 检查所需端口

启用这些[必要的端口](https://kubernetes.io/zh-cn/docs/reference/networking/ports-and-protocols/)后才能使 Kubernetes 的各组件相互通信。 可以使用 netcat 之类的工具来检查端口是否启用，例如：

```shell
nc 127.0.0.1 6443
```

你使用的 Pod 网络插件 (详见后续章节) 也可能需要开启某些特定端口。 由于各个 Pod 网络插件的功能都有所不同，请参阅他们各自文档中对端口的要求。

### 安装容器运行时

为了在 Pod 中运行容器，Kubernetes 使用 [容器运行时（Container Runtime）](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes)。

默认情况下，Kubernetes 使用 [容器运行时接口（Container Runtime Interface，CRI）](https://kubernetes.io/zh-cn/docs/concepts/overview/components/#container-runtime) 来与你所选择的容器运行时交互。

如果你不指定运行时，kubeadm 会自动尝试通过扫描已知的端点列表来检测已安装的容器运行时。

如果检测到有多个或者没有容器运行时，kubeadm 将抛出一个错误并要求你指定一个想要使用的运行时。

> **说明：**
>
> Docker Engine 没有实现 [CRI](https://kubernetes.io/zh-cn/docs/concepts/architecture/cri/)， 而这是容器运行时在 Kubernetes 中工作所需要的。 为此，必须安装一个额外的服务 [cri-dockerd](https://github.com/Mirantis/cri-dockerd)。 cri-dockerd 是一个基于传统的内置 Docker 引擎支持的项目， 它在 1.24 版本从 kubelet 中[移除](https://kubernetes.io/zh-cn/dockershim)。

下面的表格包括被支持的操作系统的已知端点。

- Linux

  | 运行时                            | Unix 域套接字                                |
  | --------------------------------- | -------------------------------------------- |
  | containerd                        | `unix:///var/run/containerd/containerd.sock` |
  | CRI-O                             | `unix:///var/run/crio/crio.sock`             |
  | Docker Engine（使用 cri-dockerd） | `unix:///var/run/cri-dockerd.sock`           |

- Windows

  | 运行时                            | Windows 命名管道路径                     |
  | --------------------------------- | ---------------------------------------- |
  | containerd                        | `npipe:////./pipe/containerd-containerd` |
  | Docker Engine（使用 cri-dockerd） | `npipe:////./pipe/cri-dockerd`           |

### 安装 kubeadm、kubelet 和 kubectl

需要在每台机器上安装以下的软件包：

- `kubeadm`：用来初始化集群的指令。
- `kubelet`：在集群中的每个节点上用来启动 Pod 和容器等。
- `kubectl`：用来与集群通信的命令行工具。

kubeadm **不能**帮你安装或者管理 `kubelet` 或 `kubectl`， 所以你需要确保它们与通过 kubeadm 安装的控制平面的版本相匹配。 如果不这样做，则存在发生版本偏差的风险，可能会导致一些预料之外的错误和问题。 然而，控制平面与 kubelet 之间可以存在**一个**次要版本的偏差，但 kubelet 的版本不可以超过 API 服务器的版本。 例如，1.7.0 版本的 kubelet 可以完全兼容 1.8.0 版本的 API 服务器，反之则不可以。

> **警告：**
>
> 这些指南不包括系统升级时使用的所有 Kubernetes 程序包。这是因为 kubeadm 和 Kubernetes 有[特殊的升级注意事项](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)。

#### 基于 Debian 的发行版

1. 更新 `apt` 包索引并安装使用 Kubernetes `apt` 仓库所需要的包：

   ```bash
   sudo apt-get update
   sudo apt-get install -y apt-transport-https ca-certificates curl
   ```

2. 下载 Google Cloud 公开签名秘钥：

   ```bash
   sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
   ```

3. 添加 Kubernetes `apt` 仓库：

   ```bash
   echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   ```

4. 更新 `apt` 包索引，安装 kubelet、kubeadm 和 kubectl，并锁定其版本：

   ```bash
   sudo apt-get update
   sudo apt-get install -y kubelet kubeadm kubectl
   sudo apt-mark hold kubelet kubeadm kubectl
   ```

> **说明：**
>
> 在低于 Debian 12 和 Ubuntu 22.04 的发行版本中，`/etc/apt/keyrings` 默认不存在。 如有需要，你可以创建此目录，并将其设置为对所有人可读，但仅对管理员可写。

#### 基于 Red Hat 的发行版

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet
```

**请注意：**

- 通过运行命令 `setenforce 0` 和 `sed ...` 将 SELinux 设置为 permissive 模式可以有效地将其禁用。 这是允许容器访问主机文件系统所必需的，而这些操作是为了例如 Pod 网络工作正常。

  你必须这么做，直到 kubelet 做出对 SELinux 的支持进行升级为止。

- 如果你知道如何配置 SELinux 则可以将其保持启用状态，但可能需要设定 kubeadm 不支持的部分配置

- 如果由于该 Red Hat 的发行版无法解析 `basearch` 导致获取 `baseurl` 失败，请将 `\$basearch` 替换为你计算机的架构。 输入 `uname -m` 以查看该值。 例如，`x86_64` 的 `baseurl` URL 可以是：`https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64`。

#### 无包管理器的情况

安装 CNI 插件（大多数 Pod 网络都需要）：

```bash
CNI_PLUGINS_VERSION="v1.1.1"
ARCH="amd64"
DEST="/opt/cni/bin"
sudo mkdir -p "$DEST"
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGINS_VERSION}/cni-plugins-linux-${ARCH}-${CNI_PLUGINS_VERSION}.tgz" | sudo tar -C "$DEST" -xz
```

定义要下载命令文件的目录。

> **说明：**
>
> `DOWNLOAD_DIR` 变量必须被设置为一个可写入的目录。 如果你在运行 Flatcar Container Linux，可设置 `DOWNLOAD_DIR="/opt/bin"`。

```bash
DOWNLOAD_DIR="/usr/local/bin"
sudo mkdir -p "$DOWNLOAD_DIR"
```

安装 crictl（kubeadm/kubelet 容器运行时接口（CRI）所需）

```bash
CRICTL_VERSION="v1.25.0"
ARCH="amd64"
curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz" | sudo tar -C $DOWNLOAD_DIR -xz
```

安装 `kubeadm`、`kubelet`、`kubectl` 并添加 `kubelet` 系统服务：

```bash
RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
ARCH="amd64"
cd $DOWNLOAD_DIR
sudo curl -L --remote-name-all https://dl.k8s.io/release/${RELEASE}/bin/linux/${ARCH}/{kubeadm,kubelet}
sudo chmod +x {kubeadm,kubelet}

RELEASE_VERSION="v0.4.0"
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service" | sed "s:/usr/bin:${DOWNLOAD_DIR}:g" | sudo tee /etc/systemd/system/kubelet.service
sudo mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf" | sed "s:/usr/bin:${DOWNLOAD_DIR}:g" | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

请参照[安装工具页面](https://kubernetes.io/zh-cn/docs/tasks/tools/#kubectl)的说明安装 `kubelet`。 激活并启动 `kubelet`：

```bash
systemctl enable --now kubelet
```

> **说明：**
>
> Flatcar Container Linux 发行版会将 `/usr/` 目录挂载为一个只读文件系统。 在启动引导你的集群之前，你需要执行一些额外的操作来配置一个可写入的目录。 参见 [kubeadm 故障排查指南](https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#usr-mounted-read-only/) 以了解如何配置一个可写入的目录。

kubelet 现在每隔几秒就会重启，因为它陷入了一个等待 kubeadm 指令的死循环。

#### 配置 cgroup 驱动程序

容器运行时和 kubelet 都具有名字为 ["cgroup driver"](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/) 的属性，该属性对于在 Linux 机器上管理 CGroups 而言非常重要。

> **警告：**
>
> 你需要确保容器运行时和 kubelet 所使用的是相同的 cgroup 驱动，否则 kubelet 进程会失败。


## 对 kubeadm 进行故障排查

与任何程序一样，你可能会在安装或者运行 kubeadm 时遇到错误。 本文列举了一些常见的故障场景，并提供可帮助你理解和解决这些问题的步骤。

如果你的问题未在下面列出，请执行以下步骤：

- 如果你认为问题是 kubeadm 的错误：
  - 转到 [github.com/kubernetes/kubeadm](https://github.com/kubernetes/kubeadm/issues) 并搜索存在的问题。
  - 如果没有问题，请 [打开](https://github.com/kubernetes/kubeadm/issues/new) 并遵循问题模板。
- 如果你对 kubeadm 的工作方式有疑问，可以在 [Slack](https://slack.k8s.io/) 上的 `#kubeadm` 频道提问， 或者在 [StackOverflow](https://stackoverflow.com/questions/tagged/kubernetes) 上提问。 请加入相关标签，例如 `#kubernetes` 和 `#kubeadm`，这样其他人可以帮助你。

### 由于缺少 RBAC，无法将 v1.18 Node 加入 v1.17 集群

自从 v1.18 后，如果集群中已存在同名 Node，kubeadm 将禁止 Node 加入集群。 这需要为 bootstrap-token 用户添加 RBAC 才能 GET Node 对象。

但这会导致一个问题，v1.18 的 `kubeadm join` 无法加入由 kubeadm v1.17 创建的集群。

要解决此问题，你有两种选择：

使用 kubeadm v1.18 在控制平面节点上执行 `kubeadm init phase bootstrap-token`。 请注意，这也会启用 bootstrap-token 的其余权限。

或者，也可以使用 `kubectl apply -f ...` 手动应用以下 RBAC：

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kubeadm:get-nodes
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubeadm:get-nodes
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubeadm:get-nodes
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: system:bootstrappers:kubeadm:default-node-token
```

### 在安装过程中没有找到 `ebtables` 或者其他类似的可执行文件

如果在运行 `kubeadm init` 命令时，遇到以下的警告

```console
[preflight] WARNING: ebtables not found in system path
[preflight] WARNING: ethtool not found in system path
```

那么或许在你的节点上缺失 `ebtables`、`ethtool` 或者类似的可执行文件。 你可以使用以下命令安装它们：

- 对于 Ubuntu/Debian 用户，运行 `apt install ebtables ethtool` 命令。
- 对于 CentOS/Fedora 用户，运行 `yum install ebtables ethtool` 命令。

### 在安装过程中，kubeadm 一直等待控制平面就绪

如果你注意到 `kubeadm init` 在打印以下行后挂起：

```console
[apiclient] Created API client, waiting for the control plane to become ready
```

这可能是由许多问题引起的。最常见的是：

- 网络连接问题。在继续之前，请检查你的计算机是否具有全部联通的网络连接。
- 容器运行时的 cgroup 驱动不同于 kubelet 使用的 cgroup 驱动。要了解如何正确配置 cgroup 驱动， 请参阅[配置 cgroup 驱动](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)。
- 控制平面上的 Docker 容器持续进入崩溃状态或（因其他原因）挂起。你可以运行 `docker ps` 命令来检查以及 `docker logs` 命令来检视每个容器的运行日志。 对于其他容器运行时，请参阅[使用 crictl 对 Kubernetes 节点进行调试](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/crictl/)。

### 当删除托管容器时 kubeadm 阻塞

如果容器运行时停止并且未删除 Kubernetes 所管理的容器，可能发生以下情况：

```shell
sudo kubeadm reset
[preflight] Running pre-flight checks
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Removing kubernetes-managed containers
(block)
```

一个可行的解决方案是重新启动 Docker 服务，然后重新运行 `kubeadm reset`： 你也可以使用 `crictl` 来调试容器运行时的状态。 参见[使用 CRICTL 调试 Kubernetes 节点](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/crictl/)。

### Pod 处于 `RunContainerError`、`CrashLoopBackOff` 或者 `Error` 状态

在 `kubeadm init` 命令运行后，系统中不应该有 Pod 处于这类状态。

- 在 `kubeadm init` 命令执行完后，如果有 Pod 处于这些状态之一，请在 kubeadm 仓库提起一个 issue。`coredns` (或者 `kube-dns`) 应该处于 `Pending` 状态， 直到你部署了网络插件为止。
- 如果在部署完网络插件之后，有 Pod 处于 `RunContainerError`、`CrashLoopBackOff` 或 `Error` 状态之一，并且 `coredns` （或者 `kube-dns`）仍处于 `Pending` 状态， 那很可能是你安装的网络插件由于某种原因无法工作。你或许需要授予它更多的 RBAC 特权或使用较新的版本。请在 Pod Network 提供商的问题跟踪器中提交问题， 然后在此处分类问题。

### `coredns` 停滞在 `Pending` 状态

这一行为是 **预期之中** 的，因为系统就是这么设计的。kubeadm 的网络供应商是中立的， 因此管理员应该选择[安装 Pod 的网络插件](https://kubernetes.io/zh-cn/docs/concepts/cluster-administration/addons/)。 你必须完成 Pod 的网络配置，然后才能完全部署 CoreDNS。 在网络被配置好之前，DNS 组件会一直处于 `Pending` 状态。

### `HostPort` 服务无法工作

此 `HostPort` 和 `HostIP` 功能是否可用取决于你的 Pod 网络配置。请联系 Pod 网络插件的作者， 以确认 `HostPort` 和 `HostIP` 功能是否可用。

已验证 Calico、Canal 和 Flannel CNI 驱动程序支持 HostPort。

有关更多信息，请参考 [CNI portmap 文档](https://github.com/containernetworking/plugins/blob/master/plugins/meta/portmap/README.md).

如果你的网络提供商不支持 portmap CNI 插件，你或许需要使用 [NodePort 服务的功能](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/#type-nodeport) 或者使用 `HostNetwork=true`。

### 无法通过其服务 IP 访问 Pod

- 许多网络附加组件尚未启用 [hairpin 模式](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-application/debug-service/#a-pod-fails-to-reach-itself-via-the-service-ip) 该模式允许 Pod 通过其服务 IP 进行访问。这是与 [CNI](https://github.com/containernetworking/cni/issues/476) 有关的问题。 请与网络附加组件提供商联系，以获取他们所提供的 hairpin 模式的最新状态。
- 如果你正在使用 VirtualBox (直接使用或者通过 Vagrant 使用)，你需要 确保 `hostname -i` 返回一个可路由的 IP 地址。默认情况下，第一个接口连接不能路由的仅主机网络。 解决方法是修改 `/etc/hosts`，请参考示例 [Vagrantfile](https://github.com/errordeveloper/k8s-playground/blob/22dd39dfc06111235620e6c4404a96ae146f26fd/Vagrantfile#L11)。

### TLS 证书错误

以下错误说明证书可能不匹配。

```none
# kubectl get pods
Unable to connect to the server: x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
```

- 验证 `$HOME/.kube/config` 文件是否包含有效证书， 并在必要时重新生成证书。在 kubeconfig 文件中的证书是 base64 编码的。 该 `base64 --decode` 命令可以用来解码证书，`openssl x509 -text -noout` 命令可以用于查看证书信息。

- 使用如下方法取消设置 `KUBECONFIG` 环境变量的值：

  ```shell
  unset KUBECONFIG
  ```

  或者将其设置为默认的 `KUBECONFIG` 位置：

  ```shell
  export KUBECONFIG=/etc/kubernetes/admin.conf
  ```

- 另一个方法是覆盖 `kubeconfig` 的现有用户 "管理员"：

  ```shell
  mv  $HOME/.kube $HOME/.kube.bak
  mkdir $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```

### Kubelet 客户端证书轮换失败

默认情况下，kubeadm 使用 `/etc/kubernetes/kubelet.conf` 中指定的 `/var/lib/kubelet/pki/kubelet-client-current.pem` 符号链接来配置 kubelet 自动轮换客户端证书。如果此轮换过程失败，你可能会在 kube-apiserver 日志中看到诸如 `x509: certificate has expired or is not yet valid` 之类的错误。要解决此问题，你必须执行以下步骤：

1. 从故障节点备份和删除 `/etc/kubernetes/kubelet.conf` 和 `/var/lib/kubelet/pki/kubelet-client*`。
2. 在集群中具有 `/etc/kubernetes/pki/ca.key` 的、正常工作的控制平面节点上 执行 `kubeadm kubeconfig user --org system:nodes --client-name system:node:$NODE > kubelet.conf`。 `$NODE` 必须设置为集群中现有故障节点的名称。 手动修改生成的 `kubelet.conf` 以调整集群名称和服务器端点， 或传递 `kubeconfig user --config`（此命令接受 `InitConfiguration`）。 如果你的集群没有 `ca.key`，你必须在外部对 `kubelet.conf` 中的嵌入式证书进行签名。

1. 将得到的 `kubelet.conf` 文件复制到故障节点上，作为 `/etc/kubernetes/kubelet.conf`。
2. 在故障节点上重启 kubelet（`systemctl restart kubelet`），等待 `/var/lib/kubelet/pki/kubelet-client-current.pem` 重新创建。

1. 手动编辑 `kubelet.conf` 指向轮换的 kubelet 客户端证书，方法是将 `client-certificate-data` 和 `client-key-data` 替换为：

   ```yaml
   client-certificate: /var/lib/kubelet/pki/kubelet-client-current.pem
   client-key: /var/lib/kubelet/pki/kubelet-client-current.pem
   ```

1. 重新启动 kubelet。
2. 确保节点状况变为 `Ready`。

### 在 Vagrant 中使用 flannel 作为 Pod 网络时的默认 NIC

以下错误可能表明 Pod 网络中出现问题：

```console
Error from server (NotFound): the server could not find the requested resource
```

- 如果你正在 Vagrant 中使用 flannel 作为 Pod 网络，则必须指定 flannel 的默认接口名称。

  Vagrant 通常为所有 VM 分配两个接口。第一个为所有主机分配了 IP 地址 `10.0.2.15`，用于获得 NATed 的外部流量。

  这可能会导致 flannel 出现问题，它默认为主机上的第一个接口。这导致所有主机认为它们具有相同的公共 IP 地址。为防止这种情况，传递 `--iface eth1` 标志给 flannel 以便选择第二个接口。

### 容器使用的非公共 IP

在某些情况下 `kubectl logs` 和 `kubectl run` 命令或许会返回以下错误，即便除此之外集群一切功能正常：

```console
Error from server: Get https://10.19.0.41:10250/containerLogs/default/mysql-ddc65b868-glc5m/mysql: dial tcp 10.19.0.41:10250: getsockopt: no route to host
```

- 这或许是由于 Kubernetes 使用的 IP 无法与看似相同的子网上的其他 IP 进行通信的缘故， 可能是由机器提供商的政策所导致的。

- DigitalOcean 既分配一个共有 IP 给 `eth0`，也分配一个私有 IP 在内部用作其浮动 IP 功能的锚点， 然而 `kubelet` 将选择后者作为节点的 `InternalIP` 而不是公共 IP。

  使用 `ip addr show` 命令代替 `ifconfig` 命令去检查这种情况，因为 `ifconfig` 命令 不会显示有问题的别名 IP 地址。或者指定的 DigitalOcean 的 API 端口允许从 droplet 中 查询 anchor IP：

  ```sh
  curl http://169.254.169.254/metadata/v1/interfaces/public/0/anchor_ipv4/address
  ```

  解决方法是通知 `kubelet` 使用哪个 `--node-ip`。当使用 DigitalOcean 时，可以是公网IP（分配给 `eth0` 的）， 或者是私网IP（分配给 `eth1` 的）。私网 IP 是可选的。 [kubadm `NodeRegistrationOptions` 结构](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/#kubeadm-k8s-io-v1beta3-NodeRegistrationOptions) 的 `KubeletExtraArgs` 部分被用来处理这种情况。

  然后重启 `kubelet`：

  ```shell
  systemctl daemon-reload
  systemctl restart kubelet
  ```

### `coredns` Pod 有 `CrashLoopBackOff` 或者 `Error` 状态

如果有些节点运行的是旧版本的 Docker，同时启用了 SELinux，你或许会遇到 `coredns` Pod 无法启动的情况。 要解决此问题，你可以尝试以下选项之一：

- 升级到 [Docker 的较新版本](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#docker)。
- [禁用 SELinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-enabling_and_disabling_selinux-disabling_selinux).
- 修改 `coredns` 部署以设置 `allowPrivilegeEscalation` 为 `true`：

```shell
kubectl -n kube-system get deployment coredns -o yaml | \
  sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | \
  kubectl apply -f -
```

CoreDNS 处于 `CrashLoopBackOff` 时的另一个原因是当 Kubernetes 中部署的 CoreDNS Pod 检测到环路时。 [有许多解决方法](https://github.com/coredns/coredns/tree/master/plugin/loop#troubleshooting-loops-in-kubernetes-clusters) 可以避免在每次 CoreDNS 监测到循环并退出时，Kubernetes 尝试重启 CoreDNS Pod 的情况。

**警告：**

禁用 SELinux 或设置 `allowPrivilegeEscalation` 为 `true` 可能会损害集群的安全性。

### etcd Pod 持续重启

如果你遇到以下错误：

```console
rpc error: code = 2 desc = oci runtime error: exec failed: container_linux.go:247: starting container process caused "process_linux.go:110: decoding init error from pipe caused \"read parent: connection reset by peer\""
```

如果你使用 Docker 1.13.1.84 运行 CentOS 7 就会出现这种问题。 此版本的 Docker 会阻止 kubelet 在 etcd 容器中执行。

为解决此问题，请选择以下选项之一：

- 回滚到早期版本的 Docker，例如 1.13.1-75

  ```shell
  yum downgrade docker-1.13.1-75.git8633870.el7.centos.x86_64 docker-client-1.13.1-75.git8633870.el7.centos.x86_64 docker-common-1.13.1-75.git8633870.el7.centos.x86_64
  ```

- 安装较新的推荐版本之一，例如 18.06:

  ```shell
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum install docker-ce-18.06.1.ce-3.el7.x86_64
  ```

### 无法将以逗号分隔的值列表传递给 `--component-extra-args` 标志内的参数

`kubeadm init` 标志例如 `--component-extra-args` 允许你将自定义参数传递给像 kube-apiserver 这样的控制平面组件。然而，由于解析 (`mapStringString`) 的基础类型值，此机制将受到限制。

如果你决定传递一个支持多个逗号分隔值（例如 `--apiserver-extra-args "enable-admission-plugins=LimitRanger,NamespaceExists"`）参数， 将出现 `flag: malformed pair, expect string=string` 错误。 发生这种问题是因为参数列表 `--apiserver-extra-args` 预期的是 `key=value` 形式， 而这里的 `NamespacesExists` 被误认为是缺少取值的键名。

一种解决方法是尝试分离 `key=value` 对，像这样： `--apiserver-extra-args "enable-admission-plugins=LimitRanger,enable-admission-plugins=NamespaceExists"` 但这将导致键 `enable-admission-plugins` 仅有值 `NamespaceExists`。

已知的解决方法是使用 kubeadm [配置文件](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/)。

### 在节点被云控制管理器初始化之前，kube-proxy 就被调度了

在云环境场景中，可能出现在云控制管理器完成节点地址初始化之前，kube-proxy 就被调度到新节点了。 这会导致 kube-proxy 无法正确获取节点的 IP 地址，并对管理负载平衡器的代理功能产生连锁反应。

在 kube-proxy Pod 中可以看到以下错误：

```console
server.go:610] Failed to retrieve node IP: host IP unknown; known addresses: []
proxier.go:340] invalid nodeIP, initializing kube-proxy with 127.0.0.1 as nodeIP
```

一种已知的解决方案是修补 kube-proxy DaemonSet，以允许在控制平面节点上调度它， 而不管它们的条件如何，将其与其他节点保持隔离，直到它们的初始保护条件消除：

```shell
kubectl -n kube-system patch ds kube-proxy -p='{ "spec": { "template": { "spec": { "tolerations": [ { "key": "CriticalAddonsOnly", "operator": "Exists" }, { "effect": "NoSchedule", "key": "node-role.kubernetes.io/control-plane" } ] } } } }'
```

此问题的跟踪[在这里](https://github.com/kubernetes/kubeadm/issues/1027)。

### 节点上的 `/usr` 被以只读方式挂载

在类似 Fedora CoreOS 或者 Flatcar Container Linux 这类 Linux 发行版本中， 目录 `/usr` 是以只读文件系统的形式挂载的。 在支持 [FlexVolume](https://github.com/kubernetes/community/blob/ab55d85/contributors/devel/sig-storage/flexvolume.md)时， 类似 kubelet 和 kube-controller-manager 这类 Kubernetes 组件使用默认路径 `/usr/libexec/kubernetes/kubelet-plugins/volume/exec/`， 而 FlexVolume 的目录 **必须是可写入的**，该功能特性才能正常工作。 （**注意**：FlexVolume 在 Kubernetes v1.23 版本中已被弃用）

为了解决这个问题，你可以使用 kubeadm 的[配置文件](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/) 来配置 FlexVolume 的目录。

在（使用 `kubeadm init` 创建的）主控制节点上，使用 `--config` 参数传入如下文件：

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    volume-plugin-dir: "/opt/libexec/kubernetes/kubelet-plugins/volume/exec/"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
controllerManager:
  extraArgs:
    flex-volume-plugin-dir: "/opt/libexec/kubernetes/kubelet-plugins/volume/exec/"
```

在加入到集群中的节点上，使用下面的文件：

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
nodeRegistration:
  kubeletExtraArgs:
    volume-plugin-dir: "/opt/libexec/kubernetes/kubelet-plugins/volume/exec/"
```

或者，你要可以更改 `/etc/fstab` 使得 `/usr` 目录能够以可写入的方式挂载， 不过请注意这样做本质上是在更改 Linux 发行版的某种设计原则。

### `kubeadm upgrade plan` 输出错误信息 `context deadline exceeded`

在使用 `kubeadm` 来升级某运行外部 etcd 的 Kubernetes 集群时可能显示这一错误信息。 这并不是一个非常严重的一个缺陷，之所以出现此错误信息，原因是老的 kubeadm 版本会对外部 etcd 集群执行版本检查。你可以继续执行 `kubeadm upgrade apply ...`。

这一问题已经在 1.19 版本中得到修复。

### `kubeadm reset` 会卸载 `/var/lib/kubelet`

如果已经挂载了 `/var/lib/kubelet` 目录，执行 `kubeadm reset` 操作的时候会将其卸载。

要解决这一问题，可以在执行了 `kubeadm reset` 操作之后重新挂载 `/var/lib/kubelet` 目录。

这是一个在 1.15 中引入的故障，已经在 1.20 版本中修复。

### 无法在 kubeadm 集群中安全地使用 metrics-server

在 kubeadm 集群中可以通过为 [metrics-server](https://github.com/kubernetes-sigs/metrics-server) 设置 `--kubelet-insecure-tls` 来以不安全的形式使用该服务。 建议不要在生产环境集群中这样使用。

如果你需要在 metrics-server 和 kubelet 之间使用 TLS，会有一个问题， kubeadm 为 kubelet 部署的是自签名的服务证书。这可能会导致 metrics-server 端报告下面的错误信息：

```console
x509: certificate signed by unknown authority
x509: certificate is valid for IP-foo not IP-bar
```

参见[为 kubelet 启用签名的服务证书](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#kubelet-serving-certs) 以进一步了解如何在 kubeadm 集群中配置 kubelet 使用正确签名了的服务证书。

## 使用 kubeadm 创建集群



## 使用 kubeadm API 定制组件



## 高可用拓扑选项



## 利用 kubeadm 创建高可用集群



## 使用 kubeadm 创建一个高可用 etcd 集群



## 使用 kubeadm 配置集群中的每个 kubelet



## 使用 kubeadm 支持双协议栈













## 安装 kubelet、kubeadm 和 kubectl

在所有节点上安装。

* kubelet 运行在 Cluster 所有节点，负责启动 Pod 和容器。
* kubeadm 用于初始化 Cluster 。
* kubectl 是 Kubernetes 命令行工具。

```bash
# all hosts
# Ubuntu
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

## 创建 Cluster

### 初始化 Master

```bash
# k8s-master
kubeadm init --apiserver-advertise-address 192.168.16.105 --pod-network-cidr=10.244.0.0/16

# --apiserver-advertise-address 指明用 Master 的那个 interface 与 Cluster 的其他节点通信。
# --pod-network-cidr            指定 Pod 网络的范围。此处使用 flannel 网络方案。

kubeadm init --apiserver-advertise-address=192.168.3.200 --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
```

### 配置 kubectl

```bash
# k8s-master
# Ubuntu
su - krupp	# 建议用普通用户
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 安装 Pod 网络

```bash
# k8s-master
# flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### 添加 node 节点

```bash
# node hosts
kubeadm join --token d38a01.134532add343c1883 192.168.16.105:6443\

# 如丢失 token ,可通过如下命令查看、
kubeadm token list

# 查看节点状态
kubectl get nodes
# 状态在所有组件未完成启动前，应该是NotReady

# 查看 Pod 状态。
kubectl get pod --all-namespaces

# 查看某个 Pod 具体情况。
kubectl describe pod pod_name --namespace=kube-system

# 查看集群信息
kubectl cluster-info

Kubernetes control plane is running at https://127.0.0.1:8443
KubeDNS is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
KubeDNSUpstream is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/kube-dns-upstream:dns/proxy
Metrics-server is running at https://127.0.0.1:8443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## 