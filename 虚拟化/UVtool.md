# UVtool

[TOC]

the availability of stable and secure cloud images has become very important.
随着 Ubuntu 成为许多云平台上最流行的操作系统之一，稳定和安全的云映像的可用性变得非常重要。从 Ubuntu 12.04 开始，云基础架构之外的云映像的使用得到了改进，因此现在可以使用这些映像创建虚拟机，而无需完整安装。

从 Ubuntu 14.04 LTS 开始，一个名为 `uvtool` 的工具极大地促进了使用云映像创建虚拟机 （VM）。 `uvtool` 提供了一种简单的机制，用于在本地同步云映像，并使用它们在几分钟内创建新的 VM。

## 安装 `uvtool` 软件包

需要以下包及其依赖项才能使用 `uvtool` ：

- `uvtool`
- `uvtool-libvirt`

要安装 `uvtool` ，请运行：

```bash
sudo apt -y install uvtool
```

这将安装 `uvtool` 的 main 命令、 `uvt-simplestreams-libvirt` 和 `uvt-kvm` 。

## 使用 `uvt-simplestreams-libvirt` 获取 Ubuntu 云映像

这是 `uvtool` 提供的主要简化之一。它知道在哪里可以找到云映像，因此只需要一个命令即可获取新的云映像。例如，如果要同步 amd64 架构的所有云映像，则 `uvtool` 命令为：

```bash
uvt-simplestreams-libvirt --verbose sync arch=amd64
```

从 Internet 下载所有映像后，将拥有一整套本地存储的云映像。若要查看已下载的内容，请使用以下命令：

```bash
uvt-simplestreams-libvirt query
```

这将为您提供如下列表：

```bash
release=bionic arch=amd64 label=daily (20191107)
release=focal arch=amd64 label=daily (20191029)
...
```

如果只想同步一个特定的云镜像，则需要使用 `release=` 和 `arch=` 过滤器来识别需要同步的镜像。

```bash
uvt-simplestreams-libvirt sync release=DISTRO-SHORT-CODENAME arch=amd64
```

此外，可以提供用于从中获取 image 的替代 URL。一个常见的情况是每日映像，它可以帮助获取最新的映像，或者如果需要访问尚未发布的 Ubuntu 开发版本。举个例子：

```bash
uvt-simplestreams-libvirt sync --source http://cloud-images.ubuntu.com/daily [... further options]
```

## 创建有效的 SSH 密钥

若要在创建虚拟机后连接到虚拟机，必须首先为 Ubuntu 用户提供有效的 SSH 密钥。如果环境没有 SSH 密钥，可以使用以下 `ssh-keygen` 命令创建一个 SSH 密钥，这将生成与以下类似的输出：

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.
The key fingerprint is:
4d:ba:5d:57:c9:49:ef:b5:ab:71:14:56:6e:2b:ad:9b ubuntu@DISTRO-SHORT-CODENAMES
The key's randomart image is:
+--[ RSA 2048]----+
|               ..|
|              o.=|
|          .    **|
|         +    o+=|
|        S . ...=.|
|         o . .+ .|
|        . .  o o |
|              *  |
|             E   |
+-----------------+
```

## 使用 `uvt-kvm` 创建 VM 

若要使用 `uvtool` 创建新的虚拟机，请在终端中运行以下命令：

```bash
uvt-kvm create firsttest
```

这将使用当前本地可用的 LTS 云映像创建名为“firsttest”的 VM。如果要指定用于创建 VM 的版本，则需要使用 `release=` 筛选器和版本的短代号，例如“jammy”：

```bash
uvt-kvm create secondtest release=DISTRO-SHORT-CODENAME
```

该 `uvt-kvm wait` 命令可用于等待 VM 的创建完成：

```bash
uvt-kvm wait secondttest
```

### 连接到正在运行的 VM

虚拟机创建完成后，可以使用 SSH 连接到它：

```bash
uvt-kvm ssh secondtest
```

还可以使用 VM 的 IP 地址，通过常规 SSH 会话连接到 VM。可以使用以下命令查询地址：

```bash
$ uvt-kvm ip secondtest
192.168.122.199
$ ssh -i ~/.ssh/id_rsa ubuntu@192.168.122.199
[...]
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@secondtest:~$ 
```

## 获取正在运行的 VM 的列表

可以使用该 `uvt-kvm list` 命令获取系统上运行的 VM 列表。

## 销毁 VM

完成 VM 后，可以使用以下方法销毁它：

```bash
uvt-kvm destroy secondtest
```

> **Note**: 注意：
> 与 libvirt 的`destroy` 或 `undefine` 操作不同，这将（默认情况下）删除关联的虚拟存储文件。

## 更多 `uvt-kvm` 选项

以下选项可用于更改正在创建的 VM 的某些特征：

- `--memory` : RAM 量（以兆字节为单位）。默认值：512。
- `--disk` : 操作系统磁盘的大小（以 GB 为单位）。默认值：8。
- `--cpu` : CPU 内核数。默认值：1。

其他一些参数将对 cloud-init 配置产生影响：

- `--password <password>` : 允许使用 Ubuntu 帐户和提供的密码登录到 VM。
- `--run-script-once <script_file>` : 首次启动 VM 时以 root 身份在 VM 上运行 `script_file` ，但不会再运行。
- `--packages <package_list>` : 首次启动时安装 `package_list` 指定的逗号分隔的软件包。