## Linux

以 Ubuntu 24.04 为例。

MicroK8s 将安装一个最小的轻量级 Kubernetes，几乎可以在任何机器上运行和使用。它可以通过快速安装：

```bash
snap install microk8s --classic --channel=1.32
```

**加入组**

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

MicroK8s 捆绑了自己的 **`kubectl`** 版本来访问 Kubernetes。使用它来运行命令来监视和控制 Kubernetes 。例如，要查看节点：

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

MicroK8s 使用最少的组件来实现纯轻量级 Kubernetes。但是，使用”附加组件”只需敲击几下键盘即可获得大量额外功能——预打包的组件将为您的 Kubernetes 提供额外的功能，从简单的 DNS 管理到使用 Kubeflow 进行机器学习！

首先，建议添加 DNS 管理以促进服务之间的通信。对于需要存储的应用程序，'hostpath-storage' 附加组件在主机上提供目录空间。这些设置很容易：

```bash
microk8s enable dns
microk8s enable hostpath-storage
```

**访问仪表板**

```bash
microk8s enable dashboard
microk8s dashboard-proxy
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