# Installing MicroK8s on macOS 在 macOS 上安装 MicroK8s

**Note:** Installing MicroK8s with Multipass requires *macOS Yosemite*, version    10.10.3 or later installed on hardware from 2010 onwards. It will also require at least 4GB of available RAM and 40GB of storage.
**注意：**安装带有 Multipass 的 MicroK8s 需要从 2010 年开始在硬件上安装 *macOS Yosemite* 版本 10.10.3 或更高版本。它还需要至少 4GB 的可用 RAM 和 40GB 的存储空间。

**Note:**  Some users, who have upgraded to Big Sur, have experienced issues with Homebrew and Python when installing MicroK8s. To fix this, run `brew reinstall python`.
**注意：**一些已升级到 Big Sur 的用户在安装 MicroK8s 时遇到了 Homebrew 和 Python 问题。要解决此问题，请运行 `brew reinstall python`。

The installer for MicroK8s uses HomeBrew. If you don’t have the `brew` command you can install  it from the [Homebrew website](http://brew.sh/).
MicroK8s 的安装程序使用 HomeBrew。如果您没有 `brew` 命令，可以从 [Homebrew 网站](http://brew.sh/)安装它。

1. Download the MicroK8s installer
   下载 MicroK8s 安装程序
    `brew install ubuntu/microk8s/microk8s`

2. Run the installer 运行安装程序
    `microk8s install`
   `microk8s 安装`

3. Check the status while Kubernetes starts
   在 Kubernetes 启动时检查状态
    `microk8s status --wait-ready`
   `microk8s 状态 --wait-ready`

4. Turn on the services you want
   开启您想要的服务

   ```auto
   microk8s enable dashboard
   microk8s enable dns
   microk8s enable registry
   microk8s enable istio
   ```

Try `microk8s enable --help` for a list of available services built in.  The `microk8s disable` command turns off a service.
尝试 `microk8s enable --help` 以获取内置可用服务的列表。`microk8s disable` 命令关闭服务。

1. Start using Kubernetes! 开始使用 Kubernetes！
    `microk8s kubectl get all --all-namespaces`
2. Access the Kubernetes dashboard
   访问 Kubernetes 仪表板
    `microk8s dashboard-proxy`
3. Start and stop Kubernetes
   启动和停止 Kubernetes
    Kubernetes is a collection of system services that talk to each other  all the time. If you don’t need them running in the background then you  will save battery/resources by stopping them.  the `microk8s start` and `microk8s stop` commands will do the work for you.
   Kubernetes 是始终相互通信的系统服务的集合。如果您不需要它们在后台运行，那么您可以通过停止它们来节省电池/资源。 `microk8s start` 和 `microk8s stop` 命令将为您完成工作。