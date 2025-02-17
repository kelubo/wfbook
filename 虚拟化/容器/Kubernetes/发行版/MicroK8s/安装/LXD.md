# MicroK8s in LXD LXD 中的 MicroK8s

MicroK8s can also be installed inside an LXD container. This is a great way, for example, to test out clustered MicroK8s without the need for multiple  physical hosts.
MicroK8s 也可以安装在 LXD 容器内。例如，这是一种无需多个物理主机即可测试集群 MicroK8 的好方法。

## Installing LXD 安装 LXD

You can install [LXD](https://linuxcontainers.org/lxd/introduction/) via snaps:
您可以通过 snap 安装 [LXD](https://linuxcontainers.org/lxd/introduction/)：

```auto
sudo snap install lxd
sudo lxd init
```

## Add the MicroK8s LXD profile 添加 MicroK8s LXD 配置文件

MicroK8s requires some specific settings to work within LXD (these are explained in more detail below). These can be applied using a custom profile. The first step is to create a new profile to use:
MicroK8s 需要一些特定的设置才能在 LXD 中工作（这些设置将在下文中更详细地解释）。这些可以使用自定义配置文件应用。第一步是创建要使用的新配置文件：

```auto
lxc profile create microk8s
```

Once created, we’ll need to add the rules. If you’re using ZFS, you’ll need [this version](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s-zfs.profile) or, if you’re using ext4, you’ll need [this one](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s.profile). There is a section at the end of this document to describe what these rules do.
创建后，我们需要添加规则。如果您使用的是 ZFS，则需要[此版本](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s-zfs.profile)，或者如果您使用的是 ext4，则需要[此](https://github.com/ubuntu/microk8s/blob/master/tests/lxc/microk8s.profile)版本。本文档末尾有一个部分介绍了这些规则的作用。

Download the profile: 下载简介：

```auto
# for ZFS
wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s-zfs.profile -O microk8s.profile

# for ext4
wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s.profile -O microk8s.profile
```

We can now pipe that file into the LXD profile.
现在，我们可以将该文件通过管道传输到 LXD 配置文件中。

```auto
cat microk8s.profile | lxc profile edit microk8s
```

And then clean up. 然后清理。

```auto
rm microk8s.profile
```

## Start an LXD container for MicroK8s 为 MicroK8s 启动 LXD 容器

We can now create the container that MicroK8s will run in.
现在，我们可以创建 MicroK8s 将在其中运行的容器。

```auto
lxc launch -p default -p microk8s ubuntu:20.04 microk8s
```

Note that this command uses the ‘default’ profile, for any existing system  settings (networking, storage, etc.) before also applying the ‘microk8s’ profile - the order is important.
请注意，此命令在应用 'microk8s' 配置文件之前，对于任何现有的系统设置（网络、存储等），使用 'default' 配置文件 - 顺序很重要。

## Install MicroK8s in an LXD container 在 LXD 容器中安装 MicroK8s

First, we’ll need to install MicroK8s within the container.
首先，我们需要在容器内安装 MicroK8s。

```auto
lxc exec microk8s -- sudo snap install microk8s --classic
```

## Load AppArmor profiles on boot 启动时加载 AppArmor 配置文件

When the LXD container boots it needs to load the AppArmor profiles required by MicroK8s or else you may get the error:
当 LXD 容器启动时，它需要加载 MicroK8s 所需的 AppArmor 配置文件，否则您可能会收到错误：

```auto
cannot change profile for the next exec call: No such file or directory
```

To automate the profile loading first enter the LXD container with:
要自动加载配置文件，请首先使用以下命令输入 LXD 容器：

```auto
lxc shell microk8s
```

Then create an `rc.local` file to perform the profile loading:
然后创建一个 `rc.local` 文件来执行配置文件加载：

```auto
cat > /etc/rc.local <<EOF
#!/bin/bash

apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*
exit 0
EOF
```

Make the `rc.local` executable:
使 `rc.local` 可执行：

```auto
chmod +x /etc/rc.local
```

## Accessing MicroK8s Services Within LXD 在 LXD 中访问 MicroK8s 服务

Assuming you left the [default bridged networking](https://ubuntu.com/blog/lxd-networking-lxdbr0-explained) when you initially setup LXD, there is minimal effort required to access MicroK8s services inside the LXD container.
假设您在最初设置 LXD 时保留了[默认的桥接网络](https://ubuntu.com/blog/lxd-networking-lxdbr0-explained)，则访问 LXD 容器内的 MicroK8s 服务所需的工作量很小。

Simply note the eth0 interface IP address from
只需记下 eth0 接口 IP 地址

```auto
lxc list microk8s
```

and use this to access services running inside the container.
并使用它来访问在容器内运行的服务。

### Exposing Services To Node 向 Node 公开服务

You’ll need to expose the deployment or service to the container itself before you can access it via the LXD container’s IP address.  This can be done using `kubectl expose`.  This example will expose the deployment’s port 80 to a port assigned by Kubernetes.
您需要先将部署或服务公开给容器本身，然后才能通过 LXD 容器的 IP 地址访问它。这可以使用 `kubectl expose` 来完成。此示例将部署的端口 80 公开给 Kubernetes 分配的端口。

#### Microbot 微型机器人

In this example, we will use Microbot as it provides a simple HTTP  endpoint to expose.  These steps can be applied to any other deployment.
在此示例中，我们将使用 Microbot，因为它提供了一个简单的 HTTP 端点来公开。这些步骤可应用于任何其他部署。

First, let’s deploy Microbot (please note this image only works on `x86_64`).
首先，让我们部署 Microbot（请注意，此映像仅适用于 `x86_64`）。

```auto
lxc exec microk8s -- sudo microk8s kubectl create deployment microbot --image=dontrebootme/microbot:v1
```

Then check that the deployment has come up.
然后检查部署是否已启动。

```auto
lxc exec microk8s -- sudo microk8s kubectl get all

NAME                            READY   STATUS    RESTARTS   AGE
pod/microbot-6d97548556-hchb7   1/1     Running   0          21m

NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP        21m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/microbot   1/1     1            1           21m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/microbot-6d97548556   1         1         1       21m
```

As we can see, Microbot is running.  Let’s expose it to the LXD container.
正如我们所看到的，Microbot 正在运行。让我们将其公开给 LXD 容器。

```auto
lxc exec microk8s -- sudo microk8s kubectl expose deployment microbot --type=NodePort --port=80 --name=microbot-service
```

We can now get the assigned port.  In this example, it’s `32750`.
我们现在可以获取分配的端口。在此示例中，它是 `32750`。

```auto
lxc exec microk8s -- sudo microk8s kubectl get service microbot-service

NAME               TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
microbot-service   NodePort   10.152.183.188   <none>        80:32750/TCP   27m
```

With this, we can access Microbot from our host but using the container’s address that we noted earlier.
有了这个，我们可以从我们的主机访问 Microbot，但使用我们之前记下的容器地址。

```auto
curl 10.245.108.37:32750
```

#### Dashboard 挡泥板

The dashboard addon has a built in helper.  Start the Kubernetes dashboard
dashboard 插件有一个内置的帮助程序。启动 Kubernetes 仪表板

```auto
lxc exec microk8s -- microk8s dashboard-proxy
```

and replace `127.0.0.1` with the container’s IP address we noted earlier.
并将 `127.0.0.1` 替换为我们之前记下的容器的 IP 地址。

## Explanation of the custom rules 自定义规则说明

- **boot.autostart: “true”**: Always start the container when LXD starts. This is needed to start the container when the host boots.
  **boot.autostart： “true”**： 总是在 LXD 启动时启动容器。这是在主机引导时启动容器所必需的。
- **linux.kernel_modules**: Comma separated list of kernel modules to load before starting the container
  **linux.kernel_modules**：在启动容器之前要加载的内核模块的逗号分隔列表
- **lxc.apparmor.profile=unconfined**: Disable AppArmor. Allow the container to talk to a bunch of subsystems  of the host (eg /sys) (see [1]). By default AppArmor will block nested  hosting of containers, however Kubernetes needs to host Docker  containers. Docker containers need to be confined based on their  profiles thus we rely on confining them and not the hosts. If you can  account for the needs of the Docker containers you could tighten the  AppArmor profile instead of disabling it completely, as suggested in  [1].
  **lxc.apparmor.profile=unconfined**：禁用 AppArmor。允许容器与主机的一组子系统（例如 /sys）通信（参见 [1]）。默认情况下，AppArmor 将阻止容器的嵌套托管，但  Kubernetes 需要托管 Docker 容器。Docker  容器需要根据它们的配置文件进行限制，因此我们依赖于限制它们而不是主机。如果您可以考虑 Docker 容器的需求，您可以收紧 AppArmor  配置文件，而不是完全禁用它，如 [1] 所示。
- **lxc.cap.drop=**: Do not drop any capabilities [2]. For justification see above.
  **lxc.cap.drop=**： 不要丢弃任何功能 [2]。有关理由，请参见上文。
- **lxc.mount.auto=proc:rw sys:rw**: Mount proc and sys rw [3]. For privileged containers, lxc over-mounts  part of /proc as read-only to avoid damage to the host. Kubernetes will  complain with messages like “Failed to start ContainerManager open  /proc/sys/kernel/panic: permission denied”
  **lxc.mount.auto=proc：rw sys：rw**： 挂载 proc 和 sys rw [3]。对于特权容器，lxc 将 /proc  的一部分作为只读覆盖，以避免对主机造成损害。Kubernetes 会抱怨“无法启动 ContainerManager open  /proc/sys/kernel/panic： 权限被拒绝”之类的消息
- **security.nesting: “true”**: Support running LXD (nested) inside the container.
  **security.nesting： “true”**： 支持在容器内运行 LXD（嵌套）。
- **security.privileged: “true”**: Runs the container in privileged mode, not using kernel namespaces [4,  5]. This is needed because hosted Docker containers may need to access  for example storage devices (See comment in [6]).
  **security.privileged： “true”**：以特权模式运行容器，不使用内核命名空间 [4， 5]。这是必需的，因为托管的 Docker 容器可能需要访问例如存储设备（参见 [6] 中的评论）。
- **devices: disable /sys/module/nf_conntrack/parameters/hashsize and /sys/module/apparmor/parameters/enabled**: Hide two files owned by the host from the LXD containers. Containers  cannot disable AppArmor or set the size of the connection tracking  table[7].
  **devices：禁用 /sys/module/nf_conntrack/parameters/hashsize 和 /sys/module/apparmor/parameters/enabled**：从 LXD 容器中隐藏主机拥有的两个文件。容器无法禁用 AppArmor 或设置连接跟踪表的大小[7]。

## Citations 引文

- [1] Container nesting:[ https://stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/](https://stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/).
  [1] 容器嵌套：https://stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/。
- [2] Capabilities[ https://stgraber.org/2014/01/01/lxc-1-0-security-features/](https://stgraber.org/2014/01/01/lxc-1-0-security-features/).
  [2] 功能[ https://stgraber.org/2014/01/01/lxc-1-0-security-features/](https://stgraber.org/2014/01/01/lxc-1-0-security-features/)。
- [3] Mount proc and sys in privileged containers:[ https://github.com/lxc/lxd/issues/3042](https://github.com/lxc/lxd/issues/3042).
  [3] 将 proc 和 sys 挂载到特权容器中：https://github.com/lxc/lxd/issues/3042。
- [4] Unprivileged containers:[ https://unix.stackexchange.com/questions/177030/what-is-an-unprivileged-lxc-container/177031#177031](https://unix.stackexchange.com/questions/177030/what-is-an-unprivileged-lxc-container/177031#177031).
  [4] 非特权容器：https://unix.stackexchange.com/questions/177030/what-is-an-unprivileged-lxc-container/177031#177031。
- [5] Privileged containers:[ http://blog.benoitblanchon.fr/lxc-unprivileged-container/](http://blog.benoitblanchon.fr/lxc-unprivileged-container/).
  [5] 特权容器：http://blog.benoitblanchon.fr/lxc-unprivileged-container/。
- [6] Lxc Security[ https://wiki.ubuntu.com/LxcSecurity](https://wiki.ubuntu.com/LxcSecurity).
  [6] Lxc 安全[ https://wiki.ubuntu.com/LxcSecurity](https://wiki.ubuntu.com/LxcSecurity)。
- [7] Connections tracking:[ https://wiki.khnet.info/index.php/Conntrack_tuning](https://wiki.khnet.info/index.php/Conntrack_tuning).
  [7] 连接跟踪：https://wiki.khnet.info/index.php/Conntrack_tuning。