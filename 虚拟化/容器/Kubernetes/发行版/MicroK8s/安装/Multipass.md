# Installing MicroK8s with Multipass 使用 Multipass 安装 MicroK8s

[Multipass](https://multipass.run) is the fastest way to create a complete Ubuntu virtual machine on  Linux, Windows or macOS, and it’s a great base for using MicroK8s.
[Multipass](https://multipass.run) 是在 Linux、Windows 或 macOS 上创建完整 Ubuntu 虚拟机的最快方法，它是使用 MicroK8s 的良好基础。

For snap-capable operating systems, it can be installed with a single command:
对于支持快照的作系统，可以使用单个命令进行安装：

```auto
sudo snap install multipass
```

**Note:** For other platforms, please check out [How to install Multipass](https://multipass.run/docs/install-multipass) on the Multipass website.
**注意：**对于其他平台，请查看 [Multipass 网站上的如何安装 Multipass](https://multipass.run/docs/install-multipass)。

With multipass installed, you can now create a VM to run MicroK8s. At least 4
安装 multipass 后，您现在可以创建一个 VM 来运行 MicroK8s。至少 4
 Gigabytes of RAM and 40G of storage is recommended – we can pass these
建议使用 GB 的 RAM 和 40G 的存储空间 – 我们可以传递这些
 requirements when we launch the VM:
要求：

```bash
multipass launch --name microk8s-vm --mem 4G --disk 40G
```

We can now find the IP address which has been allocated. Running:
我们现在可以找到已分配的 IP 地址。运行：

```bash
multipass list
```

… will return something like:
…将返回如下内容：

```no-highlight
Name                    State             IPv4             Release
microk8s-vm             RUNNING           10.72.145.216    Ubuntu 18.04 LTS
```

Take a note of this IP as services will become available there when accessed
记下此 IP，因为访问时将在那里提供服务
 from the host machine. 从主机。

To work within the VM environment more easily, you can run a shell:
要更轻松地在 VM 环境中工作，您可以运行 shell：

```bash
multipass shell microk8s-vm
```

Then install the  MicroK8s snap and configure the network:
然后安装 MicroK8s snap 并配置网络：

```bash
sudo snap install microk8s --classic --channel=1.30/stable
sudo iptables -P FORWARD ACCEPT
```

The iptables command is necessary to permit traffic between the VM and host.
iptables 命令是允许 VM 和主机之间的流量所必需的。

From within the VM shell, you can now follow along the rest of the
在 VM shell 中，您现在可以按照 VM shell 的其余部分进行作
 [quick start instructions 快速入门说明](https://microk8s.io/docs)

#### Useful Multipass commands 有用的 Multipass 命令

- Get a shell inside the VM:
  在 VM 中获取 shell：

  ```bash
  multipass shell microk8s-vm
  ```

- Shutdown the VM: 关闭 VM：

  ```bash
  multipass stop microk8s-vm
  ```

- Delete and cleanup the VM:
  删除并清理 VM：

  ```bash
  multipass delete microk8s-vm
  multipass purge
  ```