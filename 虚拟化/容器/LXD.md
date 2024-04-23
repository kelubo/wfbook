# LXD

# LXD containers LXD 容器

[LXD](https://ubuntu.com/lxd) (pronounced lex-dee) is the lightervisor, or lightweight container  hypervisor. LXC (lex-see) is a program which creates and administers  “containers” on a local system. It also provides an API to allow higher  level managers, such as LXD, to administer containers. In a sense, one  could compare LXC to QEMU, while comparing LXD to libvirt.
LXD（发音为  lex-dee）是轻量级容器管理程序或轻量级容器虚拟机管理程序。LXC（lex-see）是一个在本地系统上创建和管理“容器”的程序。它还提供了一个 API，允许更高级别的经理（如 LXD）管理容器。从某种意义上说，我们可以将 LXC 与 QEMU 进行比较，同时将 LXD 与  libvirt 进行比较。

The LXC API deals with a ‘container’. The LXD API deals with ‘remotes’,  which serve images and containers. This extends the LXC functionality  over the network, and allows concise management of tasks like container  migration and container image publishing.
LXC API 处理“容器”。LXD API 处理“远程”，为映像和容器提供服务。这扩展了网络上的 LXC 功能，并允许对容器迁移和容器映像发布等任务进行简洁管理。

LXD uses LXC under the covers for some container management tasks. However, it keeps its own container configuration information and has its own  conventions, so that it is best not to use classic LXC commands by hand  with LXD containers. This document will focus on how to configure and  administer LXD on Ubuntu systems.
LXD 在后台使用 LXC 来执行某些容器管理任务。但是，它保留自己的容器配置信息并具有自己的约定，因此最好不要在 LXD 容器中手动使用经典的 LXC 命令。本文档将重点介绍如何在 Ubuntu 系统上配置和管理 LXD。

## Online Resources 在线资源

There is excellent documentation for [getting started with LXD](https://documentation.ubuntu.com/lxd/en/latest/getting_started/). Stephane Graber also has an [excellent blog series](https://www.stgraber.org/2016/03/11/lxd-2-0-blog-post-series-012/) on LXD 2.0. Finally, there is great documentation on how to [drive LXD using Juju](https://docs.jujucharms.com/devel/en/clouds-lxd).
有很好的 LXD 入门文档。Stephane Graber 也有一个关于 LXD 2.0 的优秀博客系列。最后，还有关于如何使用 Juju 驱动 LXD 的精彩文档。

This document will offer an Ubuntu Server-specific view of LXD, focusing on administration.
本文档将提供特定于 Ubuntu Server 的 LXD 视图，重点介绍管理。

## Installation 安装

LXD is pre-installed on Ubuntu Server cloud images. On other systems, the `lxd` package can be installed using:
LXD 预装在 Ubuntu Server 云映像上。在其他系统上，可以使用以下方法安装软件 `lxd` 包：

```auto
sudo snap install lxd
```

This will install the self-contained LXD snap package.
这将安装独立的 LXD 快照包。

## Kernel preparation 果仁制备

In general, Ubuntu should have all the desired features enabled by  default. One exception to this is that in order to enable swap  accounting the boot argument `swapaccount=1` must be set. This can be done by appending it to the `GRUB_CMDLINE_LINUX_DEFAULT=`variable in /etc/default/grub, then running ‘update-grub’ as root and rebooting.
通常，默认情况下，Ubuntu 应该启用所有所需的功能。一个例外是，为了启用掉期记帐，必须设置引导参数 `swapaccount=1` 。这可以通过将其附加到 /etc/default/grub 中的 `GRUB_CMDLINE_LINUX_DEFAULT=` 变量，然后以 root 身份运行“update-grub”并重新启动来完成。

## Configuration 配置

In order to use LXD, some basic settings need to be configured first. This is done by running `lxd init`, which will allow you to choose:
为了使用 LXD，需要先配置一些基本设置。这是通过运行 `lxd init` 来完成的，这将允许您选择：

- Directory or [ZFS](http://open-zfs.org) container backend. If you choose ZFS, you can choose which block devices to use, or the size of a file to use as backing store.
  目录或 ZFS 容器后端。如果选择 ZFS，那么可以选择要使用的块设备，或者选择用作后备存储的文件大小。
- Availability over the network.
  通过网络的可用性。
- A ‘trust password’ used by remote clients to vouch for their client certificate.
  远程客户端用于担保其客户端证书的“信任密码”。

You must run ‘lxd init’ as root. ‘lxc’ commands can be run as any user who  is a member of group lxd. If user joe is not a member of group ‘lxd’,  you may run:
您必须以 root 身份运行“lxd init”。“lxc”命令可以作为组 lxd 成员的任何用户运行。如果用户 joe 不是组“lxd”的成员，则可以运行：

```auto
adduser joe lxd
```

as root to change it. The new membership will take effect on the next login, or after running `newgrp lxd` from an existing login.
作为 root 来更改它。新成员资格将在下次登录时生效，或从现有登录名运行 `newgrp lxd` 后生效。

See [How to initialize LXD](https://documentation.ubuntu.com/lxd/en/latest/howto/initialize/) in the LXD documentation for more information on the configuration  settings. Also, refer to the definitive configuration provided with the  source code for the server, container, profile, and device  configuration.
有关配置设置的更多信息，请参阅 LXD 文档中的如何初始化 LXD。此外，请参阅服务器、容器、配置文件和设备配置的源代码随附的最终配置。

## Creating your first container 创建第一个容器

This section will describe the simplest container tasks.
本节将介绍最简单的容器任务。

### Creating a container 创建容器

Every new container is created based on either an image, an existing  container, or a container snapshot. At install time, LXD is configured  with the following image servers:
每个新容器都是基于映像、现有容器或容器快照创建的。在安装时，LXD 配置了以下映像服务器：

- `ubuntu`: this serves official Ubuntu server cloud image releases.
   `ubuntu` ：这为官方的 Ubuntu 服务器云映像版本提供服务。
- `ubuntu-daily`: this serves official Ubuntu server cloud images of the daily development releases.
   `ubuntu-daily` ：这为每日开发版本的官方 Ubuntu 服务器云映像提供服务。
- `images`: this is a default-installed alias for [images.linuxcontainers.org](http://images.linuxcontainers.org). This is serves classical lxc images built using the same images which  the LXC ‘download’ template uses. This includes various distributions  and minimal custom-made Ubuntu images. This is not the recommended  server for Ubuntu images.
   `images` ：这是 images.linuxcontainers.org 的默认安装别名。这为使用LXC“下载”模板使用的相同图像构建的经典 lxc 图像提供服务。这包括各种发行版和最少的定制 Ubuntu 映像。这不是 Ubuntu 映像的推荐服务器。

The command to create and start a container is
创建和启动容器的命令是

```auto
lxc launch remote:image containername
```

Images are identified by their hash, but are also aliased. The `ubuntu` remote knows many aliases such as `18.04` and `bionic`. A list of all images available from the Ubuntu Server can be seen using:
图像通过其哈希标识，但也有别名。遥控器 `ubuntu` 知道许多别名，例如 `18.04` `bionic` 和 。可以使用以下方式查看 Ubuntu Server 中可用的所有映像的列表：

```auto
lxc image list ubuntu:
```

To see more information about a particular image, including all the aliases it is known by, you can use:
要查看有关特定图像的详细信息，包括其已知的所有别名，您可以使用：

```auto
lxc image info ubuntu:bionic
```

You can generally refer to an Ubuntu image using the release name (`bionic`) or the release number (`18.04`). In addition, `lts` is an alias for the latest supported LTS release. To choose a different architecture, you can specify the desired architecture:
您通常可以使用版本名称 （ `bionic` ） 或版本号 （ `18.04` ） 来引用 Ubuntu 映像。此外， `lts` 是最新支持的 LTS 版本的别名。若要选择其他体系结构，可以指定所需的体系结构：

```auto
lxc image info ubuntu:lts/arm64
```

Now, let’s start our first container:
现在，让我们开始我们的第一个容器：

```auto
lxc launch ubuntu:bionic b1
```

This will download the official current Bionic cloud image for your current architecture, then create a container named `b1` using that image, and finally start it. Once the command returns, you can see it using:
这将下载您当前架构的官方当前仿生云映像，然后使用该映像创建一个名为 `b1` 容器，最后启动它。命令返回后，您可以看到它使用：

```auto
lxc list
lxc info b1
```

and open a shell in it using:
并使用以下命令在其中打开一个 shell：

```auto
lxc exec b1 -- bash
```

A convenient alias for the command above is:
上述命令的一个方便的别名是：

```auto
lxc shell b1
```

The try-it page mentioned above gives a full synopsis of the commands you can use to administer containers.
上面提到的试用页面提供了可用于管理容器的命令的完整概要。

Now that the `bionic` image has been downloaded, it will be kept in sync until no new  containers have been created based on it for (by default) 10 days. After that, it will be deleted.
下载 `bionic` 映像后，它将保持同步，直到（默认）10 天内没有基于它创建新容器。之后，它将被删除。

## LXD Server Configuration LXD 服务器配置

By default, LXD is socket activated and configured to listen only on a  local UNIX socket. While LXD may not be running when you first look at  the process listing, any LXC command will start it up. For instance:
默认情况下，LXD 已激活套接字，并配置为仅侦听本地 UNIX 套接字。当您第一次查看进程列表时，LXD 可能未运行，但任何 LXC 命令都将启动它。例如：

```auto
lxc list
```

This will create your client certificate and contact the LXD server for a  list of containers. To make the server accessible over the network you  can set the http port using:
这将创建您的客户端证书，并与 LXD 服务器联系以获取容器列表。要使服务器可通过网络访问，您可以使用以下命令设置 http 端口：

```auto
lxc config set core.https_address :8443
```

This will tell LXD to listen to port 8443 on all addresses.
这将告诉 LXD 侦听所有地址上的端口 8443。

### Authentication 认证

By default, LXD will allow all members of group `lxd` to talk to it over the UNIX socket. Communication over the network is authorized using server and client certificates.
默认情况下，LXD 将允许组 `lxd` 的所有成员通过 UNIX 套接字与它通信。通过网络进行通信是使用服务器和客户端证书授权的。

Before client `c1` wishes to use remote `r1`, `r1` must be registered using:
在客户 `c1` 希望使用远程 `r1` 之前， `r1` 必须使用以下方式注册：

```auto
lxc remote add r1 r1.example.com:8443
```

The fingerprint of r1’s certificate will be shown, to allow the user at c1  to reject a false certificate. The server in turn will verify that c1  may be trusted in one of two ways. The first is to register it in  advance from any already-registered client, using:
将显示 r1 证书的指纹，以允许 c1 的用户拒绝虚假证书。反过来，服务器将验证 c1 是否可以通过以下两种方式之一进行信任。第一种是从任何已经注册的客户端提前注册它，使用：

```auto
lxc config trust add r1 certfile.crt
```

Now when the client adds r1 as a known remote, it will not need to provide a password as it is already trusted by the server.
现在，当客户端将 r1 添加为已知远程时，它不需要提供密码，因为它已被服务器信任。

The other step is to configure a ‘trust password’ with `r1`, either at initial configuration using `lxd init`, or after the fact using:
另一个步骤是配置“ `r1` 信任密码”，无论是在初始配置 `lxd init` 时使用 ，还是在事后使用：

```auto
lxc config set core.trust_password PASSWORD
```

The password can then be provided when the client registers `r1` as a known remote.
然后，当客户端 `r1` 注册为已知远程时，可以提供密码。

### Backing store 后备存储

LXD supports several backing stores. The recommended and the default backing store is `zfs`. If you already have a ZFS pool configured, you can tell LXD to use it during the `lxd init` procedure, otherwise a file-backed zpool will be created automatically. With ZFS, launching a new container is fast because the filesystem  starts as a copy on write clone of the images’ filesystem. Note that  unless the container is privileged (see below) LXD will need to change  ownership of all files before the container can start, however this is  fast and change very little of the actual filesystem data.
LXD 支持多个后备存储。推荐的默认后备存储是 `zfs` 。如果已经配置了 ZFS 池，则可以告诉 LXD 在此过程中 `lxd init` 使用它，否则将自动创建文件支持的 zpool。使用  ZFS，启动新容器的速度很快，因为文件系统在映像文件系统的写入克隆时作为副本启动。请注意，除非容器具有特权（见下文），否则 LXD  需要在容器启动之前更改所有文件的所有权，但这速度很快，并且对实际文件系统数据的更改非常少。

The other supported backing stores are described in detail in the [Storage configuration](https://documentation.ubuntu.com/lxd/en/latest/explanation/storage/) section of the LXD documentation.
LXD 文档的“存储配置”部分详细介绍了其他支持的后备存储。

## Container configuration 容器配置

Containers are configured according to a set of profiles, described in the next  section, and a set of container-specific configuration. Profiles are  applied first, so that container specific configuration can override  profile configuration.
容器是根据一组配置文件（在下一节中介绍）和一组特定于容器的配置来配置的。首先应用配置文件，以便特定于容器的配置可以覆盖配置文件配置。

Container configuration includes properties like the architecture, limits on  resources such as CPU and RAM, security details including apparmor  restriction overrides, and devices to apply to the container.
容器配置包括架构等属性、CPU 和 RAM 等资源限制、安全详细信息（包括 apparmor 限制覆盖）以及要应用于容器的设备。

Devices can be of several types, including UNIX character, UNIX block, network  interface, or disk. In order to insert a host mount into a container, a  ‘disk’ device type would be used. For instance, to mount `/opt` in container `c1` at `/opt`, you could use:
设备可以有多种类型，包括 UNIX 字符、UNIX 块、网络接口或磁盘。为了将主机挂载插入容器中，将使用“磁盘”设备类型。例如，要 `/opt` 挂载到 `/opt` 的容器 `c1` 中，可以使用：

```auto
lxc config device add c1 opt disk source=/opt path=opt
```

See: 看：

```auto
lxc help config
```

for more information about editing container configurations. You may also use:
有关编辑容器配置的详细信息。您还可以使用：

```auto
lxc config edit c1
```

to edit the whole of `c1`’s configuration. Comments at the top of the configuration will show  examples of correct syntax to help administrators hit the ground  running. If the edited configuration is not valid when the editor is  exited, then the editor will be restarted.
编辑整个 `c1` 的配置。配置顶部的注释将显示正确语法的示例，以帮助管理员快速上手。如果退出编辑器时编辑的配置无效，则编辑器将重新启动。

## Profiles 配置 文件

Profiles are named collections of configurations which may be applied to more  than one container. For instance, all containers created with `lxc launch`, by default, include the `default` profile, which provides a network interface `eth0`.
配置文件是可应用于多个容器的配置的命名集合。例如，默认情况下，所有使用 `lxc launch` 创建的容器都包含配置文件，该 `default` 配置文件提供网络接口 `eth0` 。

To mask a device which would be inherited from a profile but which should  not be in the final container, define a device by the same name but of  type ‘none’:
若要屏蔽将从配置文件继承但不应位于最终容器中的设备，请使用相同名称但类型为“none”的设备定义设备：

```auto
lxc config device add c1 eth1 none
```

## Nesting 嵌 套

Containers all share the same host kernel. This means that there is always an  inherent trade-off between features exposed to the container and host  security from malicious containers. Containers by default are therefore  restricted from features needed to nest child containers. In order to  run lxc or lxd containers under a lxd container, the `security.nesting` feature must be set to true:
容器都共享同一个主机内核。这意味着，在暴露给容器的功能和恶意容器的主机安全性之间始终存在固有的权衡。因此，默认情况下，容器受到嵌套子容器所需功能的限制。要在 lxd 容器下运行 lxc 或 lxd 容器，必须将 `security.nesting` 该功能设置为 true：

```auto
lxc config set container1 security.nesting true
```

Once this is done, `container1` will be able to start sub-containers.
完成此操作后， `container1` 将能够启动子容器。

In order to run unprivileged (the default in LXD) containers nested under  an unprivileged container, you will need to ensure a wide enough UID  mapping. Please see the ‘UID mapping’ section below.
为了运行嵌套在非特权容器下的非特权（LXD 中的默认）容器，您需要确保足够宽的 UID 映射。请参阅下面的“UID 映射”部分。

## Limits 限制

LXD supports flexible constraints on the resources which containers can consume. The limits come in the following categories:
LXD 支持对容器可以使用的资源进行灵活约束。限制分为以下几类：

- CPU: limit cpu available to the container in several ways.
  CPU：以多种方式限制容器可用的 CPU。
- Disk: configure the priority of I/O requests under load
  磁盘：配置负载下的I/O请求优先级
- RAM: configure memory and swap availability
  RAM：配置内存和交换可用性
- Network: configure the network priority under load
  网络：配置负载下的网络优先级
- Processes: limit the number of concurrent processes in the container.
  进程数：限制容器中的并发进程数。

For a full list of limits known to LXD, see [the configuration documentation](https://documentation.ubuntu.com/lxd/en/latest/reference/instance_options/).
有关 LXD 已知限制的完整列表，请参阅配置文档。

## UID mappings and Privileged containers UID 映射和特权容器

By default, LXD creates unprivileged containers. This means that root in  the container is a non-root UID on the host. It is privileged against  the resources owned by the container, but unprivileged with respect to  the host, making root in a container roughly equivalent to an  unprivileged user on the host. (The main exception is the increased  attack surface exposed through the system call interface)
默认情况下，LXD 创建非特权容器。这意味着容器中的根是主机上的非根 UID。它对容器拥有的资源具有特权，但对主机没有特权，因此容器中的根大致等同于主机上的非特权用户。（主要例外是通过系统调用接口暴露的攻击面增加）

Briefly, in an unprivileged container, 65536 UIDs are ‘shifted’ into the  container. For instance, UID 0 in the container may be 100000 on the  host, UID 1 in the container is 100001, etc, up to 165535. The starting  value for UIDs and GIDs, respectively, is determined by the ‘root’ entry the `/etc/subuid` and `/etc/subgid` files. (See the [subuid(5)](http://manpages.ubuntu.com/manpages/xenial/en/man5/subuid.5.html) man page.)
简而言之，在非特权容器中，65536 个 UID 被“转移”到容器中。例如，容器中的 UID 0 在主机上可能是 100000，容器中的 UID 1 是 100001，等等，最多 165535。UID 和 GID 的起始值分别由 `/etc/subuid` “根”条目 和 `/etc/subgid` files 确定。（参见 subuid（5） 手册页。

It is possible to request a container to run without a UID mapping by setting the `security.privileged` flag to true:
可以通过将 `security.privileged` 标志设置为 true 来请求容器在没有 UID 映射的情况下运行：

```auto
lxc config set c1 security.privileged true
```

Note however that in this case the root user in the container is the root user on the host.
但请注意，在这种情况下，容器中的 root 用户是主机上的 root 用户。

## Apparmor 阿帕莫尔

LXD confines containers by default with an apparmor profile which protects  containers from each other and the host from containers. For instance  this will prevent root in one container from signaling root in another  container, even though they have the same uid mapping. It also prevents  writing to dangerous, un-namespaced files such as many sysctls and ` /proc/sysrq-trigger`.
默认情况下，LXD 使用 apparmor 配置文件来限制容器，该配置文件可保护容器彼此之间以及主机免受容器的影响。例如，这将防止一个容器中的 root  向另一个容器中的 root 发出信号，即使它们具有相同的 uid 映射。它还可以防止写入危险的未命名空间文件，例如许多 sysctls 和 ` /proc/sysrq-trigger` .

If the apparmor policy for a container needs to be modified for a container `c1`, specific apparmor policy lines can be added in the `raw.apparmor` configuration key.
如果需要为容器 `c1` 修改容器的 apparmor 策略，则可以在 `raw.apparmor` 配置键中添加特定的 apparmor 策略行。

## Seccomp

All containers are confined by a default seccomp policy. This policy  prevents some dangerous actions such as forced umounts, kernel module  loading and unloading, kexec, and the `open_by_handle_at` system call. The seccomp configuration cannot be modified, however a  completely different seccomp policy – or none – can be requested using `raw.lxc` (see below).
所有容器都受默认 seccomp 策略的限制。此策略可防止某些危险操作，例如强制 umount、内核模块加载和卸载、kexec 和 `open_by_handle_at` 系统调用。无法修改 seccomp 配置，但可以使用完全不同的 seccomp 策略（或无策略）请求 `raw.lxc` （见下文）。

## Raw LXC configuration 原始 LXC 配置

LXD configures containers for the best balance of host safety and container usability. Whenever possible it is highly recommended to use the  defaults, and use the LXD configuration keys to request LXD to modify as needed. Sometimes, however, it may be necessary to talk to the  underlying lxc driver itself. This can be done by specifying LXC  configuration items in the ‘raw.lxc’ LXD configuration key. These must  be valid items as documented in [the lxc.container.conf(5) manual page](http://manpages.ubuntu.com/manpages/focal/en/man5/lxc.container.conf.5.html).
LXD 配置容器，以实现主机安全性和容器可用性的最佳平衡。强烈建议尽可能使用默认值，并使用 LXD 配置键请求 LXD  根据需要进行修改。但是，有时可能需要与底层 lxc 驱动程序本身进行通信。这可以通过在“raw.lxc”LXD 配置键中指定 LXC  配置项来完成。这些必须是 lxc.container.conf（5） 手册页中记载的有效项目。

### Snapshots 快照

Containers can be renamed and live-migrated using the `lxc move` command:
可以使用以下 `lxc move` 命令重命名容器并实时迁移容器：

```auto
lxc move c1 final-beta
```

They can also be snapshotted:
它们也可以被快照：

```auto
lxc snapshot c1 YYYY-MM-DD
```

Later changes to c1 can then be reverted by restoring the snapshot:
然后，可以通过恢复快照来恢复对 c1 的后续更改：

```auto
lxc restore u1 YYYY-MM-DD
```

New containers can also be created by copying a container or snapshot:
还可以通过复制容器或快照来创建新容器：

```auto
lxc copy u1/YYYY-MM-DD testcontainer
```

### Publishing images 发布图像

When a container or container snapshot is ready for consumption by others, it can be published as a new image using;
当容器或容器快照可供其他人使用时，可以使用;

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0
```

The published image will be private by default, meaning that LXD will not  allow clients without a trusted certificate to see them. If the image is safe for public viewing (i.e. contains no private information), then  the ‘public’ flag can be set, either at publish time using
默认情况下，已发布的映像将是私有的，这意味着 LXD 将不允许没有受信任证书的客户端查看它们。如果图像可以安全地供公众查看（即不包含私人信息），则可以在发布时使用

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0 public=true
```

or after the fact using
或事后使用

```auto
lxc image edit foo-2.0
```

and changing the value of the public field.
以及更改公共字段的值。

### Image export and import 图像导出和导入

Image can be exported as, and imported from, tarballs:
图像可以导出为 tarball，也可以从 tarball 导入：

```auto
lxc image export foo-2.0 foo-2.0.tar.gz
lxc image import foo-2.0.tar.gz --alias foo-2.0 --public
```

## Troubleshooting 故障 排除

To view debug information about LXD itself, on a systemd based host use
要在基于 systemd 的主机上查看有关 LXD 本身的调试信息，请使用

```auto
journalctl -u lxd
```

Container logfiles for container c1 may be seen using:
可以看到容器 c1 的容器日志文件使用：

```auto
lxc info c1 --show-log
```

The configuration file which was used may be found under ` /var/log/lxd/c1/lxc.conf` while apparmor profiles can be found in ` /var/lib/lxd/security/apparmor/profiles/c1` and seccomp profiles in ` /var/lib/lxd/security/seccomp/c1`.
使用的配置文件可以在 下 ` /var/log/lxd/c1/lxc.conf` 找到，而 apparmor 配置文件可以在 ` /var/lib/lxd/security/apparmor/profiles/c1` 中找到，seccomp 配置文件可以在 ` /var/lib/lxd/security/seccomp/c1` 中找到。

# LXD Server[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#creating-a-full-lxd-server)

## Introduction[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#introduction)

LXD is best described on the [official website](https://linuxcontainers.org/lxd/introduction/), but think of it as a container system that provides the benefits of  virtual servers in a container, or a container on steroids.

It is very powerful, and with the right hardware and set up, can be  leveraged to run a lot of server instances on a single piece of  hardware. If you pair that with a snapshot server, you also have a set  of containers that you can spin up almost immediately in the event that  your primary server goes down.

(You should not think of this as a traditional backup. You still need a regular backup system of some sort, like [rsnapshot](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/).)

The learning curve for LXD can be a bit steep, but this document will attempt to give you a wealth of knowledge at your fingertips, to help  you deploy and use LXD on Rocky Linux.

## Prerequisites And Assumptions[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#prerequisites-and-assumptions)

- One Rocky Linux server, nicely configured. You should consider a  separate hard drive for ZFS disk space (you have to if you are using  ZFS) in a production environment. And yes, we are assuming this is a  bare metal server, not a VPS.
- This should be considered an advanced topic, but we have tried our  best to make it as easy to understand as possible for everyone. That  said, knowing a few basic things about container management will take  you a long way.
- You should be very comfortable at the command line on your machine(s), and fluent in a command line editor. (We are using *vi* throughout this example, but you can substitute in your favorite editor.)
- You need to be an unprivileged user for the bulk of the LXD  processes. Except where noted, enter LXD commands as your unprivileged  user. We are assuming that you are logged in as a user named "lxdadmin"  for LXD commands. The bulk of the set up *is*, done as root until you get past the LXD initialization. We will have you create the "lxdadmin" user later in the process.
- For ZFS, make sure that UEFI secure boot is NOT enabled. Otherwise,  you will end up having to sign the ZFS module in order to get it to  load.
- We will, for the moment, be using CentOS-based containers, as LXC  does not yet have Rocky Linux images. Stay tuned for updates, because  this will likely change with time.

Note

This has changed! Feel free to substitute in Rocky Linux containers in the examples below.

## Part 1 : Getting The Environment Ready[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part-1-getting-the-environment-ready)

Throughout "Part 1" you will need to be the root user or you will need to be able to *sudo* to root.

### Install EPEL and OpenZFS Repositories[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#install-epel-and-openzfs-repositories)

LXD requires the EPEL (Extra Packages for Enterprise Linux) repository, which is easy to install using:

```
dnf install epel-release
```

Once installed, check for updates:

```
dnf update
```

If you're using ZFS, install the OpenZFS repository with:

```
dnf install https://zfsonlinux.org/epel/zfs-release.el8_3.noarch.rpm
```

We also need the GPG key, so use this command to get that:

```
gpg --import --import-options show-only /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
```

If there were kernel updates during the update process above, reboot your server

### Install snapd, dkms And vim[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#install-snapd-dkms-and-vim)

LXD must be installed from a snap for Rocky Linux. For this reason,  we need to install snapd (and a few other useful programs) with:

```
dnf install snapd dkms vim
```

And now enable and start snapd:

```
systemctl enable snapd
```

And then run:

```
systemctl start snapd
```

Reboot the server before continuing here.

### Install LXD[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#install-lxd)

Installing LXD requires the use of the snap command. At this point, we are just installing it, we are doing no set up:

```
sudo snap install lxd
```

### Install OpenZFS[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#install-openzfs)

```
dnf install kernel-devel zfs
```

###  Environment Set up[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#environment-set-up)

Most server kernel settings are not sufficient to run a large number  of containers. If we assume from the beginning that we will be using our server in production, then we need to make these changes up front to  avoid errors such as "Too many open files" from occurring.

Luckily, tweaking the settings for LXD is easy with a few file modifications and a reboot.

#### Modifying limits.conf[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#modifying-limitsconf)

The first file we need to modify is the limits.conf file. This file  is self-documented, so look at the explanations in the file as to what  this file does. To make our modifications type:

```
vi /etc/security/limits.conf
```

This entire file is remarked/commented out and, at the bottom, shows  the current default settings. In the blank space above the end of file  marker (#End of file) we need to add our custom settings. The end of the file will look like this when you are done:

```
# Modifications made for LXD

*               soft    nofile           1048576
*               hard    nofile           1048576
root            soft    nofile           1048576
root            hard    nofile           1048576
*               soft    memlock          unlimited
*               hard    memlock          unlimited
```

Save your changes and exit. (`SHIFT:wq!` for *vi*)

#### Modifying sysctl.conf With 90-lxd.override.conf[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#modifying-sysctlconf-with-90-lxdoverrideconf)

With *systemd*, we can make changes to our system's overall configuration and kernel options *without* modifying the main configuration file. Instead, we'll put our settings  in a separate file that will simply override the particular settings we  need.

To make these kernel changes, we are going to create a file called *90-lxd-override.conf* in /etc/sysctl.d. To do this type:

```
vi /etc/sysctl.d/90-lxd-override.conf
```

Place the following content in that file. Note that if you are  wondering what we are doing here, the file content below is  self-documenting:

```
## The following changes have been made for LXD ##

# fs.inotify.max_queued_events specifies an upper limit on the number of events that can be queued to the corresponding inotify instance
 - (default is 16384)

fs.inotify.max_queued_events = 1048576

# fs.inotify.max_user_instances This specifies an upper limit on the number of inotify instances that can be created per real user ID -
(default value is 128)

fs.inotify.max_user_instances = 1048576

# fs.inotify.max_user_watches specifies an upper limit on the number of watches that can be created per real user ID - (default is 8192)

fs.inotify.max_user_watches = 1048576

# vm.max_map_count contains the maximum number of memory map areas a process may have. Memory map areas are used as a side-effect of cal
ling malloc, directly by mmap and mprotect, and also when loading shared libraries - (default is 65530)

vm.max_map_count = 262144

# kernel.dmesg_restrict denies container access to the messages in the kernel ring buffer. Please note that this also will deny access t
o non-root users on the host system - (default is 0)

kernel.dmesg_restrict = 1

# This is the maximum number of entries in ARP table (IPv4). You should increase this if you create over 1024 containers.

net.ipv4.neigh.default.gc_thresh3 = 8192

# This is the maximum number of entries in ARP table (IPv6). You should increase this if you plan to create over 1024 containers.Not nee
ded if not using IPv6, but...

net.ipv6.neigh.default.gc_thresh3 = 8192

# This is a limit on the size of eBPF JIT allocations which is usually set to PAGE_SIZE * 40000.

net.core.bpf_jit_limit = 3000000000

# This is the maximum number of keys a non-root user can use, should be higher than the number of containers

kernel.keys.maxkeys = 2000

# This is the maximum size of the keyring non-root users can use

kernel.keys.maxbytes = 2000000

# This is the maximum number of concurrent async I/O operations. You might need to increase it further if you have a lot of workloads th
at use the AIO subsystem (e.g. MySQL)

fs.aio-max-nr = 524288
```

At this point you should reboot the server.

#### Checking *sysctl.conf* Values[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#checking-sysctlconf-values)

Once the reboot has been completed, log back in as to the server. We  need to spot check that our override file has actually done the job.

This is easy to do. There's no need to check every setting unless you want to, but checking a few will verify that the settings have been  changed. This is done with the *sysctl* command:

```
sysctl net.core.bpf_jit_limit
```

Which should show you:

```
net.core.bpf_jit_limit = 3000000000
```

Do the same with a few other settings in the override file (above) to verify that changes have been made.

### Enabling ZFS And Setting Up The Pool[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#enabling-zfs-and-setting-up-the-pool)

If you have UEFI secure boot turned off, this should be fairly easy.  First, load the ZFS module with modprobe:

```
/sbin/modprobe zfs
```

This should not return an error, it should simply return to the  command prompt when done. If you get an error, stop now and begin  troubleshooting. Again, make sure that secure boot is off as that will  be the most likely culprit.

Next we need to take a look at the disks on our system, determine  what has the OS loaded on it, and what is available to use for the ZFS  pool. We will do this with *lsblk*:

```
lsblk
```

Which should return something like this (your system will be different!):

```
AME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0  32.3M  1 loop /var/lib/snapd/snap/snapd/11588
loop1    7:1    0  55.5M  1 loop /var/lib/snapd/snap/core18/1997
loop2    7:2    0  68.8M  1 loop /var/lib/snapd/snap/lxd/20037
sda      8:0    0 119.2G  0 disk
├─sda1   8:1    0   600M  0 part /boot/efi
├─sda2   8:2    0     1G  0 part /boot
├─sda3   8:3    0  11.9G  0 part [SWAP]
├─sda4   8:4    0     2G  0 part /home
└─sda5   8:5    0 103.7G  0 part /
sdb      8:16   0 119.2G  0 disk
├─sdb1   8:17   0 119.2G  0 part
└─sdb9   8:25   0     8M  0 part
sdc      8:32   0 149.1G  0 disk
└─sdc1   8:33   0 149.1G  0 part
```

In this listing, we can see that */dev/sda* is in use by the operating system, so we are going to use */dev/sdb* for our zpool. Note that if you have multiple free hard drives, you may wish to consider using raidz (a software raid specifically for ZFS).

That falls outside the scope of this document, but should definitely  be a consideration for production, as it offers better performance and  redundancy. For now, let's create our pool on the single device we have  identified:

```
zpool create storage /dev/sdb
```

What this says is to create a pool called "storage" that is ZFS on the device */dev/sdb*.

Once the pool is created, it's a good idea to reboot the server again at this point.

### LXD Initialization[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#lxd-initialization)

Now that the environment is all set up, we are ready to initialize  LXD. This is an automated script that asks a series of questions to get  your LXD instance up and running:

```
lxd init
```

Here are the questions and our answers for the script, with a little explanation where warranted:

```
Would you like to use LXD clustering? (yes/no) [default=no]:
```

If you are interested in clustering, do some additional research on that [here](https://lxd.readthedocs.io/en/latest/clustering/)

```
Do you want to configure a new storage pool? (yes/no) [default=yes]:
```

This may seem counter-intuitive, since we have already created our  ZFS pool, but it will be resolved in a later question. Accept the  default.

```
Name of the new storage pool [default=default]: storage
```

You could leave this as default if you wanted to, but we have chosen to use the same name we gave our ZFS pool.

```
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]:
```

Obviously we want to accept the default.

```
Create a new ZFS pool? (yes/no) [default=yes]: no
```

Here's where the earlier question about creating a storage pool is resolved.

```
Name of the existing ZFS pool or dataset: storage
Would you like to connect to a MAAS server? (yes/no) [default=no]:
```

Metal As A Service (MAAS) is outside the scope of this document.

```
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: none
```

If you want to use IPv6 on your LXD containers, you can turn on this option. That is up to you.

```
Would you like the LXD server to be available over the network? (yes/no) [default=no]: yes
```

This is necessary to snapshot the server, so answer "yes" here.

```
Address to bind LXD to (not including port) [default=all]:
Port to bind LXD to [default=8443]:
Trust password for new clients:
Again:
```

This trust password is how you will connect to the snapshot server or back from the snapshot server, so set this with something that makes  sense in your environment. Save this entry to a secure location, such as a password manager.

```
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

#### Setting Up User Privileges[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#setting-up-user-privileges)

Before we continue on, we need to create our "lxdadmin" user and make sure that it has the privileges it needs. We need the "lxdadmin" user  to be able to *sudo* to root and we need it to be a member of the lxd group. To add the user and make sure it is a member of both groups do:

```
useradd -G wheel,lxd lxdadmin
```

Then set the password:

```
passwd lxdadmin
```

As with the other passwords, save this to a secure location.

### Firewall Set Up[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#firewall-set-up)

Before continuing, you will want a firewall set up on your server. This example is using *iptables* and [this procedure](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/) to disable *firewalld*. If you prefer to use *firewalld*, simply substitute in *firewalld* rules.

Create your firewall.conf script:

```
vi /etc/firewall.conf
```

We are assuming an LXD server on a LAN network of 192.168.1.0/24  below. Note, too, that we are accepting all traffic from our bridged  interface. This is important if you want your containers to get IP  addresses from the bridge.

This firewall script makes no other assumptions about the network  services needed. There is an SSH rule to allow our LAN network IP's to  SSH into the server. You can very easily have many more rules needed  here, depending on your environment. Later, we will be adding a rule for bi-directional traffic between our production server and the snapshot  server.

```
#!/bin/sh
#
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
iptables -A INPUT -i lxdbr0 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
# dns rules
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

This completes Part 1. You can either continue on to Part 2, or return to the [menu](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#menu). If you are working on the snapshot server, you can head down to [Part 5](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part5) now.

## Part 2 : Setting Up And Managing Images[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part-2-setting-up-and-managing-images)

Throughout Part 2, and from here on out unless otherwise noted, you  will be running commands as your unprivileged user. ("lxdadmin" if you  are following along with this document).

### List Available Images[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#list-available-images)

Once you have your server environment set up, you'll probably be itching to get started with a container. There are a *lot* of container OS possibilities. To get a feel for how many possibilities, enter this command:

```
lxc image list images: | more
```

Hit the space bar to page through the list. This list of containers  and virtual machines continues to grow. For now, we are sticking with  containers.

The last thing you want to do is to page through looking for a  container image to install, particularly if you know the image that you  want to create. Let's modify the command above to show only CentOS Linux install options:

```
lxc image list images: | grep centos/8
```

This brings up a much more manageable list:

```
| centos/8 (3 more)                    | 98b4dbef0c29 | yes    | Centos 8 amd64 (20210427_07:08)              | x86_64       | VIRTUAL-MACHINE | 517.44MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8 (3 more)                    | 0427669ebee4 | yes    | Centos 8 amd64 (20210427_07:08)              | x86_64       | CONTAINER       | 125.58MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream (3 more)             | 961170f8934f | yes    | Centos 8-Stream amd64 (20210427_07:08)       | x86_64       | VIRTUAL-MACHINE | 586.44MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream (3 more)             | e507fdc8935a | yes    | Centos 8-Stream amd64 (20210427_07:08)       | x86_64       | CONTAINER       | 130.33MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/arm64 (1 more)       | e5bf98409ac6 | yes    | Centos 8-Stream arm64 (20210427_10:33)       | aarch64      | CONTAINER       | 126.56MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/cloud (1 more)       | 5751ca14bf8f | yes    | Centos 8-Stream amd64 (20210427_07:08)       | x86_64       | CONTAINER       | 144.75MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/cloud (1 more)       | ccf0bb20b0ca | yes    | Centos 8-Stream amd64 (20210427_07:08)       | x86_64       | VIRTUAL-MACHINE | 593.31MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/cloud/arm64          | db3d915d12fd | yes    | Centos 8-Stream arm64 (20210427_07:08)       | aarch64      | CONTAINER       | 140.60MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/cloud/ppc64el        | 11aa2ab878b2 | yes    | Centos 8-Stream ppc64el (20210427_07:08)     | ppc64le      | CONTAINER       | 149.45MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8-Stream/ppc64el (1 more)     | a27665203e47 | yes    | Centos 8-Stream ppc64el (20210427_07:08)     | ppc64le      | CONTAINER       | 134.52MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/arm64 (1 more)              | d64396d47fa7 | yes    | Centos 8 arm64 (20210427_07:08)              | aarch64      | CONTAINER       | 121.83MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/cloud (1 more)              | 84803ca6e32d | yes    | Centos 8 amd64 (20210427_07:08)              | x86_64       | CONTAINER       | 140.42MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/cloud (1 more)              | c98196cd9eec | yes    | Centos 8 amd64 (20210427_07:08)              | x86_64       | VIRTUAL-MACHINE | 536.00MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/cloud/arm64                 | 9d06684a9a4e | yes    | Centos 8 arm64 (20210427_10:33)              | aarch64      | CONTAINER       | 136.49MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/cloud/ppc64el               | 18c13c448349 | yes    | Centos 8 ppc64el (20210427_07:08)            | ppc64le      | CONTAINER       | 144.66MB  | Apr 27, 2021 at 12:00am (UTC) |
| centos/8/ppc64el (1 more)            | 130c1c83c36c | yes    | Centos 8 ppc64el (20210427_07:08)            | ppc64le      | CONTAINER       | 129.53MB  | Apr 27, 2021 at 12:00am (UTC) |
```

### Installing, Renaming, And Listing Images[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#installing-renaming-and-listing-images)

For the first container, we are going to choose centos/8. To install it, we *could* use:

```
lxc launch images:centos/8 centos-test
```

That will create a CentOS-based containter named "centos-test". You  can rename a container after it has been created, but you first need to  stop the container, which starts automatically when it is launched.

To start the container manually, use:

```
lxc start centos-test
```

For the purposes of this guide, go ahead and install one more image for now:

```
lxc launch images:ubuntu/20.10 ubuntu-test
```

Now let's take a look at what we have so far by listing our images:

```
lxc list
```

which should return something like this:

```
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING | 10.199.182.72 (eth0)  |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

### LXD Profiles[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#lxd-profiles)

You get a default profile when you install LXD, and this profile  cannot be removed or modified. That said, you can use the default  profile to create new profiles to use with your containers.

If you look at our container listing (above) you will notice that the IP address in each case is assigned from the bridged interface. In a  production environment, you may want to use something else. This might  be a DHCP assigned address from your LAN interface or even a statically  assigned address from your WAN.

If you configure your LXD server with two interfaces, and assign each an IP on your WAN and LAN, then it is possible to assign your  containers IP addresses based on which interface the container needs to  be facing.

As of version 8 of Rocky Linux (and really any bug for bug copy of  Red Hat Enterprise Linux, such as CentOS in our listing above) the  method for assigning IP addresses statically or dynamically using the  profiles below, is broken out of the gate.

There are ways to get around this, but it is annoying, as the feature that is broken *should be* part of the Linux kernel. That feature is macvlan. Macvlan allows you  to create multiple interfaces with different Layer 2 addresses.

For now, just be aware that what we are going to suggest next has drawbacks when choosing container images based on RHEL.

#### Creating A macvlan Profile And Assigning It[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#creating-a-macvlan-profile-and-assigning-it)

To create our macvlan profile, simply use this command:

```
lxc profile create macvlan
```

Keep in mind that if we were on a multi-interface machine and wanted  more than one macvlan template based on which network we wanted to  reach, we could use "lanmacvlan" or "wanmacvlan" or any other name that  we wanted to use to identify the profile. In other words, using  "macvlan" in our profile create statement is totally up to you.

Once the profile is created, we now need to modify it to do what we  want. First, we need to make sure that the server's default editor is  what we want to use. If we don't do this step, the editor will be  whatever the default editor is. We are choosing *vim* for our editor here:

```
export EDITOR=/usr/bin/vim
```

Now we want to modify the macvlan interface, but before we do, we  need to know what the parent interface is for our LXD server. This will  be the interface that has a LAN (in this case) assigned IP. To determine which interface that is, use:

```
ip addr
```

And then look for the interface with the LAN IP assignment in the 192.168.1.0/24 network:

```
2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 40:16:7e:a9:94:85 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.106/24 brd 192.168.1.255 scope global dynamic noprefixroute enp3s0
       valid_lft 4040sec preferred_lft 4040sec
    inet6 fe80::a308:acfb:fcb3:878f/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

So in this case, the interface would be "enp3s0".

Now let's modify the profile:

```
lxc profile edit macvlan
```

This file will be self-documented at the top. What we need to do is modify the file as follows below the commented section:

```
config: {}
description: ""
devices:
  eth0:
   name: eth0
   nictype: macvlan
   parent: enp3s0
   type: nic
name: macvlan
used_by: []
```

Obviously, you can use profiles for lots of other things, but  assigning a static IP to a container, or using your own DHCP server as a source for an address are very common needs.

To assign the macvlan profile to centos-test we need to do the following:

```
lxc profile assign centos-test default,macvlan
```

This simply says, we want the default profile, and then we want to apply the macvlan profile as well.

####  CentOS macvlan[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#centos-macvlan)

In the CentOS implementation of Network Manager, they have managed to break the functionality of macvlan in the kernel, or at least in the  kernel applied to their LXD image. This has been this way since CentOS 8 was released and no one appears to be at all concerned about a fix.

Simply put, if you want to run CentOS 8 containers (or any other RHEL 1-for-1 release, such as Rocky Linux), you've got to jump through some  additional hoops to get macvlan to work. macvlan is part of the kernel,  so it should work without the below fixes, but it doesn't.

##### CentOS macvlan - The DHCP Fix[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#centos-macvlan-the-dhcp-fix)

Having the profile assigned, however, doesn't change the default configuration, which is set to DHCP by default.

To test this, simply do the following:

```
lxc stop centos-test
```

And then:

```
lxc start centos-test
```

Now list your containers again and note that centos-test does not have an IP address anymore:

```
lxc list
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING |                       |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

To further demonstrate the problem here, we need to execute `dhclient` on the container. You can do this with:

```
lxc exec centos-test dhclient
```

A new listing using `lxc list` now shows the following:

```
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING | 192.168.1.138 (eth0)  |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

That should have happened with a simple stop and start of the  container, but it does not. Assuming that we want to use a DHCP assigned IP address every time, then we can fix this with a simple crontab  entry. To do this, we need to gain shell access to the container by  entering:

```
lxc exec centos-test bash
```

Next, lets determine the complete path to `dhclient`:

```
which dhclient
```

which should return:

```
/usr/sbin/dhclient
```

Next, let's modify root's crontab:

```
crontab -e
```

And add this line:

```
@reboot    /usr/sbin/dhclient
```

The crontab command entered above, uses *vi* so to save your changes and exit simply use:

```
SHIFT:wq!
```

Now exit the container and stop centos-test:

```
lxc stop centos-test
```

and then start it again:

```
lxc start centos-test
```

A new listing will reveal that the container has been assigned the DHCP address:

```
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING | 192.168.1.138 (eth0)  |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

##### CentOS macvlan - The Static IP Fix[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#centos-macvlan-the-static-ip-fix)

To statically assign an IP address, things get even more convoluted.  The process of setting a static IP address on a CentOS container is  through the network-scripts, which we will do now. The IP we will  attempt to assign is 192.168.1.200.

To do this, we need to gain shell access to the container again:

```
lxc exec centos-test bash
```

The next thing we need to do is to manually modify the interface  labelled "eth0", and set our IP address. To modify our configuration, do the following:

```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

Which will return this:

```
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
HOSTNAME=centos-test
TYPE=Ethernet
MTU=
DHCP_HOSTNAME=centos-test
IPV6INIT=yes
```

We need to modify this file so that it looks like this:

```
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.200
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
HOSTNAME=centos-test
TYPE=Ethernet
MTU=
DHCP_HOSTNAME=centos-test
IPV6INIT=yes
```

This says we want to set the boot protocol to none (used for static  IP assignments), set the IP address to 192.168.1.200, that this address  is part of a CLASS C (PREFIX=24) address, that the gateway for this  network is 192.168.1.1 and then that we want to use Google's open DNS  servers for name resolution.

Save your file (`SHIFT:wq!`).

We also need to remove our crontab for root, as this isn't what we want for a static IP. To do this, simply `crontab -e` and remark out the @reboot line with a "#", save your changes and exit the container.

Stop the container with:

```
lxc stop centos-test
```

and start it again:

```
lxc start centos-test
```

Just like our DHCP assigned address, the statically assigned address will not be assigned when we list the container:

```
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING |                       |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

To fix this requires breaking Network Manager on the container. The following works-at least for now:

```
lxc exec centos-test dhclient
```

Then get into the container:

```
lxc exec centos-test bash
```

Install the old network scripts:

```
dnf install network-scripts
```

Nuke Network Manager:

```
systemctl stop NetworkManager` `systemctl disable NetworkManager
```

Enable the old Network service:

```
systemctl enable network.service
```

Exit the container and then stop and start the container again:

```
lxc stop centos-test
```

And then run:

```
lxc start centos-test
```

When the container starts, a new listing will show the correct statically assigned IP:

```
+-------------+---------+-----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+-----------+-----------+
| centos-test | RUNNING | 192.168.1.200 (eth0)  |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 10.199.182.236 (eth0) |      | CONTAINER | 0         |
+-------------+---------+-----------------------+------+-----------+-----------+
```

The issue with macvlan shown in both of these examples is directly  related to containers based on Red Hat Enterprise Linux (Centos 8, Rocky Linux 8).

#### Ubuntu macvlan[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#ubuntu-macvlan)

Luckily, In Ubuntu's implementation of Network Manager, the macvlan stack is NOT broken, so it is much easier to deploy!

First, just like with our centos-test container, we need to assign the template to our container:

```
lxc profile assign ubuntu-test default,macvlan
```

That should be all that is necessary to get a DHCP assigned address. To find out, stop and then start the container again:

```
lxc stop ubuntu-test
```

And then run:

```
lxc start ubuntu-test
```

Then list the containers again:

```
+-------------+---------+----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4         | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+----------------------+------+-----------+-----------+
| centos-test | RUNNING | 192.168.1.200 (eth0) |      | CONTAINER | 0         |
+-------------+---------+----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 192.168.1.139 (eth0) |      | CONTAINER | 0         |
+-------------+---------+----------------------+------+-----------+-----------+
```

Success!

Configuring the Static IP is just a little different, but not at all  hard. We need to modify the .yaml file associated with the container's  connection (/10-lxc.yaml). For this static IP, we will use  192.168.1.201:

```
vi /etc/netplan/10-lxc.yaml
```

And change what is there to the following:

```
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses: [192.168.1.201/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
```

Save your changes (`SHFT:wq!`) and exit the container.

Now stop and start the container:

```
lxc stop ubuntu-test
```

And then run:

```
lxc start ubuntu-test
```

When you list your containers again, you should see our new static IP:

```
+-------------+---------+----------------------+------+-----------+-----------+
|    NAME     |  STATE  |         IPV4         | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+----------------------+------+-----------+-----------+
| centos-test | RUNNING | 192.168.1.200 (eth0) |      | CONTAINER | 0         |
+-------------+---------+----------------------+------+-----------+-----------+
| ubuntu-test | RUNNING | 192.168.1.201 (eth0) |      | CONTAINER | 0         |
+-------------+---------+----------------------+------+-----------+-----------+
```

Success!

In the examples used in Part 2, we have intentionally chosen a hard  container to configure, and an easy one. There are obviously many more  versions of Linux available in the image listing. If you have a  favorite, try installing it, assigning the macvlan template, and setting IP's.

This completes Part 2. You can either continue on to Part 3, or return to the [menu](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#menu).

## Part 3 : Container Configuration Options[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part-3-container-configuration-options)

There are a wealth of options for configuring the container once you  have it installed. Before we get into how to see those, however, let's  take a look at the info command for a container. In this example, we  will use the ubuntu-test container:

```
lxc info ubuntu-test
```

This shows something like the following:

```
Name: ubuntu-test
Location: none
Remote: unix://
Architecture: x86_64
Created: 2021/04/26 15:14 UTC
Status: Running
Type: container
Profiles: default, macvlan
Pid: 584710
Ips:
  eth0:    inet    192.168.1.201    enp3s0
  eth0:    inet6    fe80::216:3eff:fe10:6d6d    enp3s0
  lo:    inet    127.0.0.1
  lo:    inet6    ::1
Resources:
  Processes: 13
  Disk usage:
    root: 85.30MB
  CPU usage:
    CPU usage (in seconds): 1
  Memory usage:
    Memory (current): 99.16MB
    Memory (peak): 110.90MB
  Network usage:
    eth0:
      Bytes received: 53.56kB
      Bytes sent: 2.66kB
      Packets received: 876
      Packets sent: 36
    lo:
      Bytes received: 0B
      Bytes sent: 0B
      Packets received: 0
      Packets sent: 0
```

There's a lot of good information there, from the profiles applied, to the memory in use, disk space in use, and more.

#### A Word About Configuration And Some Options[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#a-word-about-configuration-and-some-options)

By default, LXD will allocate the required system memory, disk space, CPU cores, etc., to the container. But what if we want to be more  specific? That is totally possible.

There are trade-offs to doing this, though. For instance, if we  allocate system memory and the container doesn't actually use it all,  then we have kept it from another container that might actually need it. The reverse, though, can happen. If a container is a complete pig on  memory, then it can keep other containers from getting enough, thereby  pinching their performance.

Just keep in mind that every action you make to configure a container *can* have negative effects somewhere else.

Rather than run through all of the options for configuration, use the tab auto-complete to see the options available:

`lxc config set ubuntu-test` and then hit TAB.

This shows you all of the options for configuring a container. If you have questions about what one of the configuration options does, head  up to the [official documentation for LXD](https://lxd.readthedocs.io/en/stable-4.0/instances/) and do a search for the configuration parameter, or Google the entire  string, such as "lxc config set limits.memory" and take a look at the  results of the search.

We will look at a few of the most used configuration options. For  example, if you want to set the max amount of memory that a container  can use:

```
lxc config set ubunt-test limits.memory 2GB
```

That says that as long as the memory is available to use, in other  words there is 2GB of memory free, then the container can actually use  more than 2GB if it's available. It's a soft limit, in other words.

```
lxc config set ubuntu-test limits.memory.enforce 2GB
```

That says that the container can never use more than 2GB of memory,  whether it's currently available or not. In this case it's a hard limit.

```
lxc config set ubuntu-test limits.cpu 2
```

That says to limit the number of cpu cores that the container can use to 2.

Remember when we set up our storage pool in the [Enabling zfs And Setting Up The Pool](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#zfssetup) above?  We named the pool "storage," but we could have named it anything. If we want to look at this, we can use this command:

```
lxc storage show storage
```

This shows the following:

```
config:
  source: storage
  volatile.initial_source: storage
  zfs.pool_name: storage
description: ""
name: storage
driver: zfs
used_by:
- /1.0/images/0cc65b6ca6ab61b7bc025e63ca299f912bf8341a546feb8c2f0fe4e83843f221
- /1.0/images/4f0019aee1515c109746d7da9aca6fb6203b72f252e3ee3e43d50b942cdeb411
- /1.0/images/9954953f2f5bf4047259bf20b9b4f47f64a2c92732dbc91de2be236f416c6e52
- /1.0/instances/centos-test
- /1.0/instances/ubuntu-test
- /1.0/profiles/default
status: Created
locations:
- none
```

This shows that all of our containers are using our zfs storage pool. When using ZFS, you can also set a disk quota on a container. Let's do  this by setting a 2GB disk quota on the ubuntu-test container. You do  this with:

```
lxc config device override ubuntu-test root size=2GB
```

As stated earlier, you should use configuration options sparingly,  unless you've got a container that wants to use way more than its share  of resources. LXD, for the most part, will manage the environment well  on its own.

There are, of course, many more options that may be of interest to  some people. You should do your own research to find out if any of those are of value in your environment.

This completes Part 3. You can either continue on to Part 4, or return to the [menu](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#menu).

## Part 4: Container Snapshots[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part-4-container-snapshots)

Container snapshots, along with a snapshot server (which we will get  to more later), are probably the most important aspect of running a  production LXD server. Snapshots ensure quick recovery, and can be used  for safety when you are, say, updating the primary software that runs on a particular container. If something happens during the update that  breaks that application, you simply restore the snapshot and you are  back up and running with only a few seconds worth of downtime.

The author used LXD containers for PowerDNS public facing servers,  and the process of updating those applications became so much more  worry-free, since you can snapshot the container first before  continuing.

You can even snapshot a container while it is running. We'll start by getting a snapshot of the ubuntu-test container by using this command:

```
lxc snapshot ubuntu-test ubuntu-test-1
```

Here, we are calling the snapshot "ubuntu-test-1", but it can be  called anything you like. To make sure that you have the snapshot, do an "lxc info" of the container:

```
lxc info ubuntu-test
```

We've looked at an info screen already, so if you scroll to the bottom, you should see:

```
Snapshots:
  ubuntu-test-1 (taken at 2021/04/29 15:57 UTC) (stateless)
```

Success! Our snapshot is in place.

Now, get into the ubuntu-test container:

```
lxc exec ubuntu-test bash
```

And create an empty file with the *touch* command:

```
touch this_file.txt
```

Now exit the container.

Before we restore the container as it was prior to creating the file, the safest way to restore a container, particularly if there have been a lot of changes, is to stop it first:

```
lxc stop ubuntu-test
```

Then restore it:

```
lxc restore ubuntu-test ubuntu-test-1
```

Then start the container again:

```
lxc start ubuntu-test
```

If you get back into the container again and look, our "this_file.txt" that we created is now gone.

Once you don't need a snapshot anymore, you can delete it:

```
lxc delete ubuntu-test/ubuntu-test-1
```

**Important:** You should always delete snapshots with the container running. Why? Well the *lxc delete* command also works to delete the entire container. If we had  accidentally hit enter after "ubuntu-test" in the command above, AND, if the container was stopped, the container would be deleted. No warning  is given, it simply does what you ask.

If the container is running, however, you will get this message:

```
Error: The instance is currently running, stop it first or pass --force
```

So always delete snapshots with the container running.

The process of creating snapshots automatically, setting expiration  of the snapshot so that it goes away after a certain length of time, and auto refreshing the snapshots to the snapshot server will be covered in detail in the section dealing with the snapshot server.

This completes Part 4. You can either continue on to Part 5, or return to the [menu](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#menu).

## Part 5: The Snapshot Server[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part-5-the-snapshot-server)

As noted at the beginning, the snapshot server for LXD should be a  mirror of the production server in every way possible. The reason is  that you may need to take it to production in the event of a hardware  failure, and having not only backups, but a quick way to bring up  production containers, keeps those systems administrator panic phone  calls and text messages to a minimum. THAT is ALWAYS good!

So the process of building the snapshot server is exactly like the  production server. To fully emulate our production server set up, do all of [Part 1](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#part1) again, and when completed, return to this spot.

You're back!! Congratulations, this must mean that you have  successfully completed Part 1 for the snapshot server. That's great  news!!

### Setting Up The Primary and Snapshot Server Relationship[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#setting-up-the-primary-and-snapshot-server-relationship)

We've got some housekeeping to do before we continue. First, if you  are running in a production environment, you probably have access to a  DNS server that you can use for setting up IP to name resolution.

In our lab, we don't have that luxury. Perhaps you've got the same  scenario running. For this reason, we are going to add both servers IP  addresses and names to the /etc/hosts file on BOTH the primary and the  snapshot server. You'll need to do this as your root (or *sudo*) user.

In our lab, the primary LXD server is running on 192.168.1.106 and  the snapshot LXD server is running on 192.168.1.141. We will SSH into  both servers and add the following to the /etc/hosts file:



```
192.168.1.106 lxd-primary
192.168.1.141 lxd-snapshot
```

Next, we need to allow all traffic between the two servers. To do this,  we are going to modify the /etc/firewall.conf file with the following.  First, on the lxd-primary server, add this line:



```
IPTABLES -A INPUT -s 192.168.1.141 -j ACCEPT
```

And on the lxd-snapshot server, add this line:

```
IPTABLES -A INPUT -s 192.168.1.106 -j ACCEPT
```

This allows bi-directional traffic of all types to travel between the two servers.

Next, as the "lxdadmin" user, we need to set the trust relationship  between the two machines. This is done by executing the following on  lxd-primary:

```
lxc remote add lxd-snapshot
```

This will display the certificate to accept, so do that, and then it  will prompt for your password. This is the "trust password" that you set up when doing the [LXD initialization](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#lxdinit) step. Hopefully, you are securely keeping track of all of these  passwords. Once you enter the password, you should receive this:

```
Client certificate stored at server:  lxd-snapshot
```

It does not hurt to have this done in reverse as well. In other  words, set the trust relationship on the lxd-snapshot server so that, if needed, snapshots can be sent back to the lxd-primary server. Simply  repeat the steps and substitute in "lxd-primary" for "lxd-snapshot."

### Migrating Our First Snapshot[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#migrating-our-first-snapshot)

Before we can migrate our first snapshot, we need to have any  profiles created on lxd-snapshot that we have created on the  lxd-primary. In our case, this is the "macvlan" profile.

You'll need to create this for lxd-snapshot, so go back to [LXD Profiles](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#profiles) and create the "macvlan" profile on lxd-snapshot. If your two servers  have identical parent interface names ("enp3s0" for example) then you  can copy the "macvlan" profile over to lxd-snapshot without recreating  it:

```
lxc profile copy macvlan lxd-snapshot
```

Now that we have all of the relationships and profiles set up, the  next step is to actually send a snapshot from lxd-primary over to  lxd-snapshot. If you've been following along exactly, you've probably  deleted all of your snapshots, so let's create a new one:

```
lxc snapshot centos-test centos-snap1
```

If you run the "info" sub-command for lxc, you can see the new snapshot on the bottom of our listing:

```
lxc info centos-test
```

Which will show something like this at the bottom:

```
centos-snap1 (taken at 2021/05/13 16:34 UTC) (stateless)
```

OK, fingers crossed! Let's try to migrate our snapshot:

```
lxc copy centos-test/centos-snap1 lxd-snapshot:centos-test
```

What this command says is, that within the container centos-test, we  want to send the snapshot, centos-snap1 over to lxd-snapshot and copy it as centos-test.

After a short period of time has expired, the copy will be complete.  Want to find out for sure?  Do an "lxc list" on the lxd-snapshot server. Which should return the following:

```
+-------------+---------+------+------+-----------+-----------+
|    NAME     |  STATE  | IPV4 | IPV6 |   TYPE    | SNAPSHOTS |
+-------------+---------+------+------+-----------+-----------+
| centos-test | STOPPED |      |      | CONTAINER | 0         |
+-------------+---------+------+------+-----------+-----------+
```

Success! Now let's try starting it. Because we are starting it on the lxd-snapshot server, we need to stop it first on the lxd-primary  server:

```
lxc stop centos-test
```

And on the lxd-snapshot server:

```
lxc start centos-test
```

Assuming all of this works without error, stop the container on lxd-snapshot and start it again on lxd-primary.

### The Snapshot Server - Setting boot.autostart To Off For Containers[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#the-snapshot-server-setting-bootautostart-to-off-for-containers)

The snapshots copied to lxd-snapshot will be down when they are  migrated, but if you have a power event or need to reboot the snapshot  server because of updates or something, you will end up with a problem  as those containers will attempt to start on the snapshot server.

To eliminate this, we need to set the migrated containers so that  they will not start on reboot of the server. For our newly copied  centos-test container, this is done with the following:

```
lxc config set centos-test boot.autostart 0
```

Do this for each snapshot on the lxd-snapshot server.

### Automating The Snapshot Process[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#automating-the-snapshot-process)

Ok, so it's great that you can create snapshots when you need to, and sometimes you *do* need to manually create a snapshot. You might even want to manually  copy it over to lxd-snapshot. BUT, once you've got things going and  you've got 25 to 30 containers or more running on your lxd-primary  machine, the very last thing you want to do is spend an afternoon  deleting snapshots on the snapshot server, creating new snapshots and  sending them over.

The first thing we need to do is schedule a process to automate  snapshot creation on lxd-primary. This has to be done for each container on the lxd-primary server, but once it is set up, it will take care of  itself. This is done with the following syntax. Note the similarities to a crontab entry for the timestamp:

```
lxc config set [container_name] snapshots.schedule "50 20 * * *"
```

What this is saying is, do a snapshot of the container name every day at 8:50 PM.

To apply this to our centos-test container:

```
lxc config set centos-test snapshots.schedule "50 20 * * *"
```

We also want to set up the name of the snapshot to be meaningful by  our date. LXD uses UTC everywhere, so our best bet to keep track of  things, is to set the snapshot name with a date/time stamp that is in a  more understandable format:

```
lxc config set centos-test snapshots.pattern "centos-test-{{ creation_date|date:'2006-01-02_15-04-05' }}"
```

GREAT, but we certainly don't want a new snapshot every day without  getting rid of an old one, right?  We'd fill up the drive with  snapshots. So next we run:

```
lxc config set centos-test snapshots.expiry 1d
```

### Automating The Snapshot Copy Process[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#automating-the-snapshot-copy-process)

Again, this process is performed on lxd-primary. First thing we need  to do is create a script that will be run by cron in /usr/local/sbin  called "refresh-containers" :

```
sudo vi /usr/local/sbin/refreshcontainers.sh
```

The script is pretty simple:

```
#!/bin/bash
# This script is for doing an lxc copy --refresh against each container, copying
# and updating them to the snapshot server.

for x in $(/var/lib/snapd/snap/bin/lxc ls -c n --format csv)
        do echo "Refreshing $x"
        /var/lib/snapd/snap/bin/lxc copy --refresh $x lxd-snapshot:$x
        done
```

Make it executable:

```
sudo chmod +x /usr/local/sbin/refreshcontainers.sh
```

Change the ownership of this script to your lxdadmin user and group:

```
sudo chown lxdadmin.lxdadmin /usr/local/sbin/refreshcontainers.sh
```

Set up the crontab for the lxdadmin user to run this script, in this case at 10 PM:

```
crontab -e
```

And your entry will look like this:

```
00 22 * * * /usr/local/sbin/refreshcontainers.sh > /home/lxdadmin/refreshlog 2>&1
```

Save your changes and exit.

This will create a log in lxdadmin's home directory called  "refreshlog" which will give you knowledge of whether your process  worked or not. Very important!

The automated procedure will fail sometimes. This generally happens  when a particular container fails to refresh. You can manually re-run  the refresh with the following command (assuming centos-test here, as  our container):

```
lxc copy --refresh centos-test lxd-snapshot:centos-test
```

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#conclusions)

There is a great deal to installing and effectively using LXD. You  can certainly install it on your laptop or workstation without all the  fuss, as it makes a great developing and testing platform. If you want a more serious approach using production containers, then a primary and  snapshot server approach is your best bet.

Even though we've touched on a lot of features and settings, we have  only scratched the surface of what you can do with LXD. The best way to  learn this system, is to install it and try it out with things that you  will use. If you find LXD useful, consider installing it in the fashion  described in this document for the best possible leveraging of hardware  for Linux containers. Rocky Linux works very well for this!

You can now exit this document, or return to the [menu](https://docs.rockylinux.org/zh/guides/containers/lxd_server/#menu). You know, if you want.

LXD 就是一个提供了 REST API 的 LXC 容器管理器。

LXD 和 Docker/Rkt 又有什么关系呢 ?

这是一个最常被问起的问题，现在就让我们直接指出其中的不同吧。

LXD 聚焦于系统容器，通常也被称为架构容器。这就是说 LXD 容器实际上如在裸机或虚拟机上运行一般运行了一个完整的 Linux 操作系统。

这些容器一般基于一个干净的发布镜像并会长时间运行。传统的配置管理工具和部署工具可以如在虚拟机、云实例和物理机器上一样与 LXD 一起使用。

相对的， Docker 关注于短期的、无状态的、最小化的容器，这些容器通常并不会升级或者重新配置，而是作为一个整体被替换掉。这就使得 Docker 及类似项目更像是一种软件发布机制，而不是一个机器管理工具。

这两种模型并不是完全互斥的。你完全可以使用 LXD 为你的用户提供一个完整的 Linux 系统，然后他们可以在 LXD 内安装 Docker 来运行他们想要的软件。
为什么要用 LXD?

我们已经持续开发并改进 LXC 好几年了。 LXC 成功的实现了它的目标，它提供了一系列很棒的用于创建和管理容器的底层工具和库。

然而这些底层工具的使用界面对用户并不是很友好。使用它们需要用户有很多的基础知识以理解它们的工作方式和目的。同时，向后兼容旧的容器和部署策略也使得 LXC 无法默认使用一些安全特性，这导致用户需要进行更多人工操作来实现本可以自动完成的工作。

我们把 LXD 作为解决这些缺陷的一个很好的机会。作为一个长时间运行的守护进程， LXD 可以绕开 LXC 的许多限制，比如动态资源限制、无法进行容器迁移和高效的在线迁移；同时，它也为创造新的默认体验提供了机会：默认开启安全特性，对用户更加友好。
LXD 的主要组件

LXD 是由几个主要组件构成的，这些组件都出现在 LXD 目录结构、命令行客户端和 API 结构体里。
容器

LXD 中的容器包括以下及部分：

    根文件系统（rootfs）
    配置选项列表，包括资源限制、环境、安全选项等等
    设备：包括磁盘、unix 字符/块设备、网络接口
    一组继承而来的容器配置文件
    属性（容器架构、暂时的还是持久的、容器名）
    运行时状态（当用 CRIU 来中断/恢复时）

快照

容器快照和容器是一回事，只不过快照是不可修改的，只能被重命名，销毁或者用来恢复系统，但是无论如何都不能被修改。

值得注意的是，因为我们允许用户保存容器的运行时状态，这就有效的为我们提供了“有状态”的快照的功能。这就是说我们可以使用快照回滚容器的状态，包括快照当时的 CPU 和内存状态。
镜像

LXD 是基于镜像实现的，所有的 LXD 容器都是来自于镜像。容器镜像通常是一些纯净的 Linux 发行版的镜像，类似于你们在虚拟机和云实例上使用的镜像。

所以可以「发布」一个容器：使用容器制作一个镜像并在本地或者远程 LXD 主机上使用。

镜像通常使用全部或部分 sha256 哈希码来区分。因为输入长长的哈希码对用户来说不方便，所以镜像可以使用几个自身的属性来区分，这就使得用户在镜像商店里方便搜索镜像。也可以使用别名来一对一地将一个用户好记的名字映射到某个镜像的哈希码上。

LXD 安装时已经配置好了三个远程镜像服务器（参见下面的远程一节）：

    “ubuntu”：提供稳定版的 Ubuntu 镜像
    “ubuntu-daily”：提供 Ubuntu 的每日构建镜像
    “images”： 社区维护的镜像服务器，提供一系列的其它 Linux 发布版，使用的是上游 LXC 的模板

LXD 守护进程会从镜像上次被使用开始自动缓存远程镜像一段时间（默认是 10 天），超过时限后这些镜像才会失效。

此外， LXD 还会自动更新远程镜像（除非指明不更新），所以本地的镜像会一直是最新版的。
配置

配置文件是一种在一个地方定义容器配置和容器设备，然后将其应用到一系列容器的方法。

一个容器可以被应用多个配置文件。当构建最终容器配置时（即通常的扩展配置），这些配置文件都会按照他们定义顺序被应用到容器上，当有重名的配置键或设备时，新的会覆盖掉旧的。然后本地容器设置会在这些基础上应用，覆盖所有来自配置文件的选项。

LXD 自带两种预配置的配置文件：

    “default”配置是自动应用在所有容器之上，除非用户提供了一系列替代的配置文件。目前这个配置文件只做一件事，为容器定义 eth0 网络设备。
    “docker”配置是一个允许你在容器里运行 Docker 容器的配置文件。它会要求 LXD 加载一些需要的内核模块以支持容器嵌套并创建一些设备。

远程

如我之前提到的， LXD 是一个基于网络的守护进程。附带的命令行客户端可以与多个远程 LXD 服务器、镜像服务器通信。

默认情况下，我们的命令行客户端会与下面几个预定义的远程服务器通信：

    local：默认的远程服务器，使用 UNIX socket 和本地的 LXD 守护进程通信
    ubuntu：Ubuntu 镜像服务器，提供稳定版的 Ubuntu 镜像
    ubuntu-daily：Ubuntu 镜像服务器，提供 Ubuntu 的每日构建版
    images：images.linuxcontainers.org 的镜像服务器

所有这些远程服务器的组合都可以在命令行客户端里使用。

你也可以添加任意数量的远程 LXD 主机，并配置它们监听网络。匿名的开放镜像服务器，或者通过认证可以管理远程容器的镜像服务器，都可以添加进来。

正是这种远程机制使得与远程镜像服务器交互及在主机间复制、移动容器成为可能。
安全性

我们设计 LXD 时的一个核心要求，就是在不修改现代 Linux 发行版的前提下，使容器尽可能的安全。

LXD 通过使用 LXC 库实现的主要安全特性有：

    内核名字空间。尤其是用户名字空间，它让容器和系统剩余部分完全分离。LXD 默认使用用户名字空间（和 LXC 相反），并允许用户在需要的时候以容器为单位关闭（将容器标为“特权的”）。
    Seccomp 系统调用。用来隔离潜在危险的系统调用。
    AppArmor。对 mount、socket、ptrace 和文件访问提供额外的限制。特别是限制跨容器通信。
    Capabilities。阻止容器加载内核模块，修改主机系统时间，等等。
    CGroups。限制资源使用，防止针对主机的 DoS 攻击。

为了对用户友好，LXD 构建了一个新的配置语言把大部分的这些特性都抽象封装起来，而不是如 LXC 一般直接将这些特性暴露出来。举了例子，一个用户可以告诉 LXD 把主机设备放进容器而不需要手动检查他们的主/次设备号来手动更新 CGroup 策略。

和 LXD 本身通信是基于使用 TLS 1.2 保护的链路，只允许使用有限的几个被允许的密钥算法。当和那些经过系统证书认证之外的主机通信时， LXD 会提示用户验证主机的远程指纹（SSH 方式），然后把指纹缓存起来以供以后使用。
REST 接口

LXD 的工作都是通过 REST 接口实现的。在客户端和守护进程之间并没有其他的通讯渠道。

REST 接口可以通过本地的 unix socket 访问，这只需要经过用户组认证，或者经过 HTTP 套接字使用客户端认证进行通信。

REST 接口的结构能够和上文所说的不同的组件匹配，是一种简单、直观的使用方法。

当需要一种复杂的通信机制时， LXD 将会进行 websocket 协商完成剩余的通信工作。这主要用于交互式终端会话、容器迁移和事件通知。

LXD 2.0 附带了 1.0 版的稳定 API。虽然我们在 1.0 版 API 添加了额外的特性，但是这不会在 1.0 版 API 端点里破坏向后兼容性，因为我们会声明额外的 API 扩展使得客户端可以找到新的接口。
容器规模化

虽然 LXD 提供了一个很好的命令行客户端，但是这个客户端并不能管理多个主机上大量的容器。在这种使用情况下，我们可以使用 OpenStack 的 nova-lxd 插件，它可以使 OpenStack 像使用虚拟机一样使用 LXD 容器。

这就允许在大量的主机上部署大量的 LXD 容器，然后使用 OpenStack 的 API 来管理网络、存储以及负载均衡。
额外信息

LXD 的主站在: https://linuxcontainers.org/lxd

LXD 的 GitHub 仓库: https://github.com/lxc/lxd

LXD 的邮件列表: https://lists.linuxcontainers.org

LXD 的 IRC 频道: #lxcontainers on irc.freenode.net

如果你不想或者不能在你的机器上安装 LXD ，你可以在 web 上试试在线版的 LXD 。

via: https://www.stgraber.org/2016/03/11/lxd-2-0-introduction-to-lxd-112/


安装篇

有很多种办法可以获得 LXD。我们推荐你配合最新版的 LXC 和 Linux 内核使用 LXD，这样就可以享受到它的全部特性。需要注意的是，我们现在也在慢慢的降低对旧版本 Linux 发布版的支持。
Ubuntu 标准版

所有新发布的 LXD 都会在发布几分钟后上传到 Ubuntu 开发版的安装源里。这个安装包然后就会作为 Ubuntu 用户的其他安装包源的种子。

如果使用 Ubuntu 16.04，可以直接安装：

    sudo apt install lxd

如果运行的是 Ubuntu 14.04，则可以这样安装：

    sudo apt -t trusty-backports install lxd

Ubuntu Core

使用 Ubuntu Core 稳定版的用户可以使用下面的命令安装 LXD：

    sudo snappy install lxd.stgraber

Ubuntu 官方 PPA

使用其他 Ubuntu 发布版 —— 比如 Ubuntu 15.10 —— 的用户可以添加下面的 PPA（Personal Package Archive）来安装：

    sudo apt-add-repository ppa:ubuntu-lxc/stable
    sudo apt update
    sudo apt dist-upgrade
    sudo apt install lxd

Gentoo

Gentoo 已经有了最新的 LXD 包，你可以直接安装：

    sudo emerge --ask lxd

使用源代码安装

如果你曾经编译过 Go 语言的项目，那么从源代码编译 LXD 并不是十分困难。然而注意，你需要 LXC 的开发头文件。为了运行 LXD， 你的发布版需也要使用比较新的内核（最起码是 3.13）、比较新的 LXC （1.1.4 或更高版本）、LXCFS 以及支持用户子 uid/gid 分配的 shadow 文件。

从源代码编译 LXD 的最新教程可以在上游 README里找到。
Ubuntu 上的网络配置

Ubuntu 的安装包会很方便的给你提供一个“lxdbr0”网桥。这个网桥默认是没有配置过的，只提供通过 HTTP 代理的 IPv6 的本地连接。

要配置这个网桥并添加 IPv4 、 IPv6 子网，你可以运行下面的命令：

    sudo dpkg-reconfigure -p medium lxd

或者直接通过 LXD 初始化命令一步一步的配置：

    sudo lxd init

存储后端

LXD 提供了几种存储后端。在开始使用 LXD 之前，你应该决定将要使用的后端，因为我们不支持在后端之间迁移已经生成的容器。

各个后端特性比较表可以在这里找到。
ZFS

我们的推荐是 ZFS， 因为它能支持 LXD 的全部特性，同时提供最快和最可靠的容器体验。它包括了以容器为单位的磁盘配额、即时快照和恢复、优化后的迁移（发送/接收），以及快速从镜像创建容器的能力。它同时也被认为要比 btrfs 更成熟。

要和 LXD 一起使用 ZFS ，你需要首先在你的系统上安装 ZFS。

如果你是用的是 Ubuntu 16.04 ， 你只需要简单的使用命令安装：

    sudo apt install zfsutils-linux

在 Ubuntu 15.10 上你可以这样安装：

    sudo apt install zfsutils-linux zfs-dkms

如果是更旧的版本，你需要从 zfsonlinux PPA 安装：

    sudo apt-add-repository ppa:zfs-native/stable
    sudo apt update
    sudo apt install ubuntu-zfs

配置 LXD 只需要执行下面的命令：

    sudo lxd init

这条命令接下来会向你提问一些 ZFS 的配置细节，然后为你配置好 ZFS。
btrfs

如果 ZFS 不可用，那么 btrfs 可以提供相同级别的集成，但不能正确地报告容器内的磁盘使用情况（虽然配额仍然可用）。

btrfs 同时拥有很好的嵌套属性，而这是 ZFS 所不具有的。也就是说如果你计划在 LXD 中再使用 LXD，那么 btrfs 就很值得你考虑。

使用 btrfs 的话，LXD 不需要进行任何的配置，你只需要保证 /var/lib/lxd 保存在 btrfs 文件系统中，然后 LXD 就会自动为你使用 btrfs 了。
LVM

如果 ZFS 和 btrfs 都不是你想要的，你还可以考虑使用 LVM 以获得部分特性。 LXD 会以自动精简配置的方式使用 LVM，为每个镜像和容器创建 LV，如果需要的话也会使用 LVM 的快照功能。

要配置 LXD 使用 LVM，需要创建一个 LVM 卷组，然后运行：

    lxc config set storage.lvm_vg_name "THE-NAME-OF-YOUR-VG"

默认情况下 LXD 使用 ext4 作为全部逻辑卷的文件系统。如果你喜欢的话可以改成 XFS：

    lxc config set storage.lvm_fstype xfs

简单目录

如果上面全部方案你都不打算使用，LXD 依然能在不使用任何高级特性情况下工作。它会为每个容器创建一个目录，然后在创建每个容器时解压缩镜像的压缩包，并在容器拷贝和快照时进行一次完整的文件系统拷贝。

除了磁盘配额以外的特性都是支持的，但是很浪费磁盘空间，并且非常慢。如果你没有其他选择，这还是可以工作的，但是你还是需要认真的考虑一下上面的几个替代方案。
配置篇

LXD 守护进程的完整配置项列表可以在这里找到。
网络配置

默认情况下 LXD 不会监听网络。和它通信的唯一办法是通过 /var/lib/lxd/unix.socket 使用本地 unix 套接字进行通信。

要让 LXD 监听网络，下面有两个有用的命令：

    lxc config set core.https_address [::]
    lxc config set core.trust_password some-secret-string

第一条命令将 LXD 绑定到 IPv6 地址 “::”，也就是监听机器的所有 IPv6 地址。你可以显式的使用一个特定的 IPv4 或者 IPv6 地址替代默认地址，如果你想绑定某个 TCP 端口（默认是 8443）的话可以在地址后面添加端口号即可。

第二条命令设置了密码，用于让远程客户端把自己添加到 LXD 可信证书中心。如果已经给主机设置了密码，当添加 LXD 主机时会提示输入密码，LXD 守护进程会保存他们的客户端证书以确保客户端是可信的，这样就不需要再次输入密码（可以随时设置和取消）。

你也可以选择不设置密码，而是人工验证每个新客户端是否可信——让每个客户端发送“client.crt”（来自于 ~/.config/lxc）文件，然后把它添加到你自己的可信证书中心：

    lxc config trust add client.crt

代理配置

大多数情况下，你会想让 LXD 守护进程从远程服务器上获取镜像。

如果你处在一个必须通过 HTTP(s) 代理链接外网的环境下，你需要对 LXD 做一些配置，或保证已在守护进程的环境中设置正确的 PROXY 环境变量。

    lxc config set core.proxy_http http://squid01.internal:3128
    lxc config set core.proxy_https http://squid01.internal:3128
    lxc config set core.proxy_ignore_hosts image-server.local

以上代码使所有 LXD 发起的数据传输都使用 squid01.internal HTTP 代理，但与在 image-server.local 的服务器的数据传输则是例外。
镜像管理

LXD 使用动态镜像缓存。当从远程镜像创建容器的时候，它会自动把镜像下载到本地镜像商店，同时标志为已缓存并记录来源。几天后（默认 10 天）如果某个镜像没有被使用过，那么它就会自动地被删除。每隔几小时（默认是 6 小时）LXD 还会检查一下这个镜像是否有新版本，然后更新镜像的本地拷贝。

所有这些都可以通过下面的配置选项进行配置：

    lxc config set images.remote_cache_expiry 5
    lxc config set images.auto_update_interval 24
    lxc config set images.auto_update_cached false

这些命令让 LXD 修改了它的默认属性，缓存期替换为 5 天，更新间隔为 24 小时，而且只更新那些标记为自动更新（–auto-update）的镜像（lxc 镜像拷贝被标记为 –auto-update）而不是 LXD 自动缓存的镜像。


创建并启动一个新的容器

正如我在先前的文章中提到的一样，LXD 命令行客户端预配置了几个镜像源。Ubuntu 的所有发行版和架构平台全都提供了官方镜像，但是对于其他的发行版也有大量的非官方镜像，那些镜像都是由社区制作并且被 LXC 上游贡献者所维护。
Ubuntu

如果你想要支持最为完善的 Ubuntu 版本，你可以按照下面的去做：

    lxc launch ubuntu:

注意，这里意味着会随着 Ubuntu LTS 的发布而变化。因此，如果用于脚本，你需要指明你具体安装的版本（参见下面）。
Ubuntu14.04 LTS

得到最新更新的、已经测试过的、稳定的 Ubuntu 14.04 LTS 镜像，你可以简单的执行：

    lxc launch ubuntu:14.04

在该模式下，会指定一个随机的容器名。

如果你更喜欢指定一个你自己的名字，你可以这样做：

    lxc launch ubuntu:14.04 c1

如果你想要指定一个特定的体系架构（非主流平台），比如 32 位 Intel 镜像，你可以这样做：

    lxc launch ubuntu:14.04/i386 c2

当前的 Ubuntu 开发版本

上面使用的“ubuntu:”远程仓库只会给你提供官方的并经过测试的 Ubuntu 镜像。但是如果你想要未经测试过的日常构建版本，开发版可能对你来说是合适的，你需要使用“ubuntu-daily:”远程仓库。

    lxc launch ubuntu-daily:devel c3

在这个例子中，将会自动选中最新的 Ubuntu 开发版本。

你也可以更加精确，比如你可以使用代号名：

    lxc launch ubuntu-daily:xenial c4

最新的Alpine Linux

Alpine 镜像可以在“Images:”远程仓库中找到，通过如下命令执行：

    lxc launch images:alpine/3.3/amd64 c5

其他

全部的 Ubuntu 镜像列表可以这样获得：

    lxc image list ubuntu:
    lxc image list ubuntu-daily:

全部的非官方镜像：

    lxc image list images:

某个给定的原程仓库的全部别名（易记名称）可以这样获得（比如对于“ubuntu:”远程仓库）：

    lxc image alias list ubuntu:

创建但不启动一个容器

如果你想创建一个容器或者一批容器，但是你不想马上启动它们，你可以使用lxc init替换掉lxc launch。所有的选项都是相同的，唯一的不同就是它并不会在你创建完成之后启动容器。

    lxc init ubuntu:

关于你的容器的信息
列出所有的容器

要列出你的所有容器，你可以这样这做：

    lxc list

有大量的选项供你选择来改变被显示出来的列。在一个拥有大量容器的系统上，默认显示的列可能会有点慢（因为必须获取容器中的网络信息），你可以这样做来避免这种情况：

    lxc list --fast

上面的命令显示了另外一套列的组合，这个组合在服务器端需要处理的信息更少。

你也可以基于名字或者属性来过滤掉一些东西：

    stgraber@dakara:~$ lxc list security.privileged=true
    +------+---------+---------------------+-----------------------------------------------+------------+-----------+
    | NAME |  STATE  |        IPV4         |                       IPV6                    |    TYPE    | SNAPSHOTS |
    +------+---------+---------------------+-----------------------------------------------+------------+-----------+
    | suse | RUNNING | 172.17.0.105 (eth0) | 2607:f2c0:f00f:2700:216:3eff:fef2:aff4 (eth0) | PERSISTENT | 0         |
    +------+---------+---------------------+-----------------------------------------------+------------+-----------+

在这个例子中，只有那些特权容器（禁用了用户命名空间）才会被列出来。

    stgraber@dakara:~$ lxc list --fast alpine
    +-------------+---------+--------------+----------------------+----------+------------+
    |    NAME     |  STATE  | ARCHITECTURE |      CREATED AT      | PROFILES |    TYPE    |
    +-------------+---------+--------------+----------------------+----------+------------+
    | alpine      | RUNNING | x86_64       | 2016/03/20 02:11 UTC | default  | PERSISTENT |
    +-------------+---------+--------------+----------------------+----------+------------+
    | alpine-edge | RUNNING | x86_64       | 2016/03/20 02:19 UTC | default  | PERSISTENT |
    +-------------+---------+--------------+----------------------+----------+------------+

在这个例子中，只有在名字中带有“alpine”的容器才会被列出来（也支持复杂的正则表达式）。
获取容器的详细信息

由于 list 命令显然不能以一种友好的可读方式显示容器的所有信息，因此你可以使用如下方式来查询单个容器的信息：

    lxc info <container>

例如：

    stgraber@dakara:~$ lxc info zerotier
    Name: zerotier
    Architecture: x86_64
    Created: 2016/02/20 20:01 UTC
    Status: Running
    Type: persistent
    Profiles: default
    Pid: 31715
    Processes: 32
    Ips:
     eth0: inet 172.17.0.101
     eth0: inet6 2607:f2c0:f00f:2700:216:3eff:feec:65a8
     eth0: inet6 fe80::216:3eff:feec:65a8
     lo: inet 127.0.0.1
     lo: inet6 ::1
     lxcbr0: inet 10.0.3.1
     lxcbr0: inet6 fe80::c0a4:ceff:fe52:4d51
     zt0: inet 29.17.181.59
     zt0: inet6 fd80:56c2:e21c:0:199:9379:e711:b3e1
     zt0: inet6 fe80::79:e7ff:fe0d:5123
    Snapshots:
     zerotier/blah (taken at 2016/03/08 23:55 UTC) (stateless)

生命周期管理命令

这些命令对于任何容器或者虚拟机管理器或许都是最普通的命令，但是它们仍然需要讲到。

所有的这些命令在批量操作时都能接受多个容器名。
启动

启动一个容器就向下面一样简单：

    lxc start <container>

停止

停止一个容器可以这样来完成：

    lxc stop <container>

如果容器不合作（即没有对发出的 SIGPWR 信号产生回应），这时候，你可以使用下面的方式强制执行：

    lxc stop <container> --force

重启

通过下面的命令来重启一个容器：

    lxc restart <container>

如果容器不合作（即没有对发出的 SIGINT 信号产生回应），你可以使用下面的方式强制执行：

    lxc restart <container> --force

暂停

你也可以“暂停”一个容器，在这种模式下，所有的容器任务将会被发送相同的 SIGSTOP 信号，这也意味着它们将仍然是可见的，并且仍然会占用内存，但是它们不会从调度程序中得到任何的 CPU 时间片。

如果你有一个很占用 CPU 的容器，而这个容器需要一点时间来启动，但是你却并不会经常用到它。这时候，你可以先启动它，然后将它暂停，并在你需要它的时候再启动它。

    lxc pause <container>

删除

最后，如果你不需要这个容器了，你可以用下面的命令删除它：

    lxc delete <container>

注意，如果容器还处于运行状态时你将必须使用“-force”。
容器的配置

LXD 拥有大量的容器配置设定，包括资源限制，容器启动控制以及对各种设备是否允许访问的配置选项。完整的清单因为太长所以并没有在本文中列出，但是，你可以从[这里]获取它。

就设备而言，LXD 当前支持下面列出的这些设备类型：

    磁盘 既可以是一块物理磁盘，也可以只是一个被挂挂载到容器上的分区，还可以是一个来自主机的绑定挂载路径。
    网络接口卡 一块网卡。它可以是一块桥接的虚拟网卡，或者是一块点对点设备，还可以是一块以太局域网设备或者一块已经被连接到容器的真实物理接口。
    unix 块设备 一个 UNIX 块设备，比如 /dev/sda
    unix 字符设备 一个 UNIX 字符设备，比如 /dev/kvm
    none 这种特殊类型被用来隐藏那种可以通过配置文件被继承的设备。

配置 profile 文件

所有可用的配置文件列表可以这样获取：

    lxc profile list

为了看到给定配置文件的内容，最简单的方式是这样做：

    lxc profile show <profile>

你可能想要改变文件里面的内容，可以这样做：

    lxc profile edit <profile>

你可以使用如下命令来改变应用到给定容器的配置文件列表：

    lxc profile apply <container> <profile1>,<profile2>,<profile3>,...

本地配置

有些配置是某个容器特定的，你并不想将它放到配置文件中，你可直接对容器设置它们：

    lxc config edit <container>

上面的命令做的和“profile edit”命令是一样。

如果不想在文本编辑器中打开整个文件的内容，你也可以像这样修改单独的配置：

    lxc config set <container> <key> <value>

或者添加设备，例如：

    lxc config device add my-container kvm unix-char path=/dev/kvm

上面的命令将会为名为“my-container”的容器设置一个 /dev/kvm 项。

对一个配置文件使用lxc profile set和lxc profile device add命令也能实现上面的功能。
读取配置

你可以使用如下命令来读取容器的本地配置：

    lxc config show <container>

或者得到已经被展开了的配置（包含了所有的配置值）：

    lxc config show --expanded <container>

例如：

    stgraber@dakara:~$ lxc config show --expanded zerotier
    name: zerotier
    profiles:
    - default
    config:
     security.nesting: "true"
     user.a: b
     volatile.base_image: a49d26ce5808075f5175bf31f5cb90561f5023dcd408da8ac5e834096d46b2d8
     volatile.eth0.hwaddr: 00:16:3e:ec:65:a8
     volatile.last_state.idmap: '[{"Isuid":true,"Isgid":false,"Hostid":100000,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":100000,"Nsid":0,"Maprange":65536}]'
    devices:
     eth0:
      name: eth0
      nictype: macvlan
      parent: eth0
      type: nic
      limits.ingress: 10Mbit
      limits.egress: 10Mbit
     root:
      path: /
      size: 30GB
      type: disk
     tun:
      path: /dev/net/tun
      type: unix-char
    ephemeral: false

这样做可以很方便的检查有哪些配置属性被应用到了给定的容器。
实时配置更新

注意，除非在文档中已经被明确指出，否则所有的配置值和设备项的设置都会对容器实时发生影响。这意味着在不重启正在运行的容器的情况下，你可以添加和移除某些设备或者修改安全配置文件。
获得一个 shell

LXD 允许你直接在容器中执行任务。最常用的做法是在容器中得到一个 shell 或者执行一些管理员任务。

和 SSH 相比，这样做的好处是你不需要容器是网络可达的，也不需要任何软件和特定的配置。
执行环境

与 LXD 在容器内执行命令的方式相比，有一点是不同的，那就是 shell 并不是在容器中运行。这也意味着容器不知道使用的是什么样的 shell，以及设置了什么样的环境变量和你的家目录在哪里。

通过 LXD 来执行命令总是使用最小的路径环境变量设置，并且 HOME 环境变量必定为 /root，以容器的超级用户身份来执行（即 uid 为 0，gid 为 0）。

其他的环境变量可以通过命令行来设置，或者在“environment.”配置中设置成永久环境变量。
执行命令

在容器中获得一个 shell 可以简单的执行下列命令得到：

    lxc exec <container> bash

当然，这样做的前提是容器内已经安装了 bash。

更复杂的命令要求使用分隔符来合理分隔参数。

    lxc exec <container> -- ls -lh /

如果想要设置或者重写变量，你可以使用“-env”参数，例如：

    stgraber@dakara:~$ lxc exec zerotier --env mykey=myvalue env | grep mykey
    mykey=myvalue

管理文件

因为 LXD 可以直接访问容器的文件系统，因此，它可以直接读取和写入容器中的任意文件。当我们需要提取日志文件或者与容器传递文件时，这个特性是很有用的。
从容器中取回一个文件

想要从容器中获得一个文件，简单的执行下列命令：

    lxc file pull <container>/<path> <dest>

例如：

    stgraber@dakara:~$ lxc file pull zerotier/etc/hosts hosts

或者将它读取到标准输出：

    stgraber@dakara:~$ lxc file pull zerotier/etc/hosts -
    127.0.0.1 localhost
    # The following lines are desirable for IPv6 capable hosts
    ::1 ip6-localhost ip6-loopback
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ff02::3 ip6-allhosts

向容器发送一个文件

发送以另一种简单的方式完成：

    lxc file push <source> <container>/<path>

直接编辑一个文件

编辑是一个方便的功能，其实就是简单的提取一个给定的路径，在你的默认文本编辑器中打开它，在你关闭编辑器时会自动将编辑的内容保存到容器。

    lxc file edit <container>/<path>

快照管理

LXD 允许你对容器执行快照功能并恢复它。快照包括了容器在某一时刻的完整状态（如果-stateful被使用的话将会包括运行状态），这也意味着所有的容器配置，容器设备和容器文件系统也会被保存。
创建一个快照

你可以使用下面的命令来执行快照功能：

    lxc snapshot <container>

命令执行完成之后将会生成名为snapX（X 为一个自动增长的数）的记录。

除此之外，你还可以使用如下命令命名你的快照：

    lxc snapshot <container> <snapshot name>

列出所有的快照

一个容器的所有快照的数量可以使用lxc list来得到，但是具体的快照列表只能执行lxc info命令才能看到。

    lxc info <container>

恢复快照

为了恢复快照，你可以简单的执行下面的命令：

    lxc restore <container> <snapshot name>

给快照重命名

可以使用如下命令来给快照重命名：

    lxc move <container>/<snapshot name> <container>/<new snapshot name>

从快照中创建一个新的容器

你可以使用快照来创建一个新的容器，而这个新的容器除了一些可变的信息将会被重置之外（例如 MAC 地址）其余所有信息都将和快照完全相同。

    lxc copy <source container>/<snapshot name> <destination container>

删除一个快照

最后，你可以执行下面的命令来删除一个快照：

    lxc delete <container>/<snapshot name>

克隆并重命名

得到一个纯净的发行版镜像总是让人感到愉悦，但是，有时候你想要安装一系列的软件到你的容器中，这时，你需要配置它然后将它分支成多个其他的容器。
复制一个容器

为了复制一个容器并有效的将它克隆到一个新的容器中，你可以执行下面的命令：

    lxc copy <source container> <destination container>

目标容器在所有方面将会完全和源容器等同。除了新的容器没有任何源容器的快照以及一些可变值将会被重置之外（例如 MAC 地址）。
移动一个快照

LXD 允许你复制容器并在主机之间移动它。但是，关于这一点将在后面的文章中介绍。

现在，“move”命令将会被用作给容器重命名。

    lxc move <old name> <new name>

唯一的要求就是当容器应该被停止，容器内的任何事情都会被保存成它本来的样子，包括可变化的信息（类似 MAC 地址等）。
结论

这篇如此长的文章介绍了大多数你可能会在日常操作中使用到的命令。

可用资源限制

LXD 提供了各种资源限制。其中一些与容器本身相关，如内存配额、CPU 限制和 I/O 优先级。而另外一些则与特定设备相关，如 I/O 带宽或磁盘用量限制。

与所有 LXD 配置一样，资源限制可以在容器运行时动态更改。某些可能无法启用，例如，如果设置的内存值小于当前内存用量，但 LXD 将会试着设置并且报告失败。

所有的限制也可以通过配置文件继承，在这种情况下每个受影响的容器将受到该限制的约束。也就是说，如果在默认配置文件中设置 limits.memory=256MB，则使用默认配置文件（通常是全都使用）的每个容器的内存限制为 256MB。

我们不支持资源限制池，将其中的限制由一组容器共享，因为我们没有什么好的方法通过现有的内核 API 实现这些功能。
磁盘

这或许是最需要和最明显的需求。只需设置容器文件系统的大小限制，并对容器强制执行。

LXD 确实可以让你这样做！

不幸的是，这比它听起来复杂得多。 Linux 没有基于路径的配额，而大多数文件系统只有基于用户和组的配额，这对容器没有什么用处。

如果你正在使用 ZFS 或 btrfs 存储后端，这意味着现在 LXD 只能支持磁盘限制。也有可能为 LVM 实现此功能，但这取决于与它一起使用的文件系统，并且如果结合实时更新那会变得棘手起来，因为并不是所有的文件系统都允许在线增长，而几乎没有一个允许在线收缩。
CPU

当涉及到 CPU 的限制，我们支持 4 种不同的东西：

    只给我 X 个 CPU 核心
    
    在这种模式下，你让 LXD 为你选择一组核心，然后为更多的容器和 CPU 的上线/下线提供负载均衡。
    
    容器只看到这个数量的 CPU 核心。
    
    给我一组特定的 CPU 核心（例如，核心1、3 和 5）
    
    类似于第一种模式，但是不会做负载均衡，你会被限制在那些核心上，无论它们有多忙。
    
    给我你拥有的 20％ 处理能力
    
    在这种模式下，你可以看到所有的 CPU，但调度程序将限制你使用 20％ 的 CPU 时间，但这只有在负载状态才会这样！所以如果系统不忙，你的容器可以跑得很欢。而当其他的容器也开始使用 CPU 时，它会被限制用量。
    
    每测量 200ms，给我 50ms（并且不超过）
    
    此模式与上一个模式类似，你可以看到所有的 CPU，但这一次，无论系统可能是多么空闲，你只能使用你设置的极限时间下的尽可能多的 CPU 时间。在没有过量使用的系统上，这可使你可以非常整齐地分割 CPU，并确保这些容器的持续性能。

另外还可以将前两个中的一个与最后两个之一相结合，即请求一组 CPU，然后进一步限制这些 CPU 的 CPU 时间。

除此之外，我们还有一个通用的优先级调节方式，可以告诉调度器当你处于负载状态时，两个争夺资源的容器谁会取得胜利。
内存

内存听起来很简单，就是给我多少 MB 的内存！

它绝对可以那么简单。 我们支持这种限制以及基于百分比的请求，比如给我 10％ 的主机内存！

另外我们在上层支持一些额外的东西。 例如，你可以选择在每个容器上打开或者关闭 swap，如果打开，还可以设置优先级，以便你可以选择哪些容器先将内存交换到磁盘！

内存限制默认是“hard”。 也就是说，当内存耗尽时，内核将会开始杀掉你的那些进程。

或者，你可以将强制策略设置为“soft”，在这种情况下，只要没有别的进程的情况下，你将被允许使用尽可能多的内存。一旦别的进程想要这块内存，你将无法分配任何内存，直到你低于你的限制或者主机内存再次有空余。
网络 I/O

网络 I/O 可能是我们看起来最简单的限制，但是相信我，实现真的不简单！

我们支持两种限制。 第一个是对网络接口的速率限制。你可以设置入口和出口的限制，或者只是设置“最大”限制然后应用到出口和入口。这个只支持“桥接”和“p2p”类型接口。

第二种是全局网络 I/O 优先级，仅当你的网络接口趋于饱和的时候再使用。
块 I/O

我把最古怪的放在最后。对于用户看起来它可能简单，但有一些情况下，它的结果并不会和你的预期一样。

我们在这里支持的基本上与我在网络 I/O 中描述的相同。

你可以直接设置磁盘的读写 IO 的频率和速率，并且有一个全局的块 I/O 优先级，它会通知 I/O 调度程序更倾向哪个。

古怪的是如何设置以及在哪里应用这些限制。不幸的是，我们用于实现这些功能的底层使用的是完整的块设备。这意味着我们不能为每个路径设置每个分区的 I/O 限制。

这也意味着当使用可以支持多个块设备映射到指定的路径（带或者不带 RAID）的 ZFS 或 btrfs 时，我们并不知道这个路径是哪个块设备提供的。

这意味着，完全有可能，实际上确实有可能，容器使用的多个磁盘挂载点（绑定挂载或直接挂载）可能来自于同一个物理磁盘。

这就使限制变得很奇怪。为了使限制生效，LXD 具有猜测给定路径所对应块设备的逻辑，这其中包括询问 ZFS 和 btrfs 工具，甚至可以在发现一个文件系统中循环挂载的文件时递归地找出它们。

这个逻辑虽然不完美，但通常会找到一组应该应用限制的块设备。LXD 接着记录并移动到下一个路径。当遍历完所有的路径，然后到了非常奇怪的部分。它会平均你为相应块设备设置的限制，然后应用这些。

这意味着你将在容器中“平均”地获得正确的速度，但这也意味着你不能对来自同一个物理磁盘的“/fast”和一个“/slow”目录应用不同的速度限制。 LXD 允许你设置它，但最后，它会给你这两个值的平均值。
它怎么工作？

除了网络限制是通过较旧但是良好的“tc”实现的，上述大多数限制是通过 Linux 内核的 cgroup API 来实现的。

LXD 在启动时会检测你在内核中启用了哪些 cgroup，并且将只应用你的内核支持的限制。如果你缺少一些 cgroup，守护进程会输出警告，接着你的 init 系统将会记录这些。

在 Ubuntu 16.04 上，默认情况下除了内存交换审计外将会启用所有限制，内存交换审计需要你通过swapaccount = 1这个内核引导参数来启用。
应用这些限制

上述所有限制都能够直接或者用某个配置文件应用于容器。容器范围的限制可以使用：

    lxc config set CONTAINER KEY VALUE

或对于配置文件设置：

    lxc profile set PROFILE KEY VALUE

当指定特定设备时：

    lxc config device set CONTAINER DEVICE KEY VALUE

或对于配置文件设置：

    lxc profile device set PROFILE DEVICE KEY VALUE

有效配置键、设备类型和设备键的完整列表可以看这里。
CPU

要限制使用任意两个 CPU 核心可以这么做：

    lxc config set my-container limits.cpu 2

要指定特定的 CPU 核心，比如说第二和第四个：

    lxc config set my-container limits.cpu 1,3

更加复杂的情况还可以设置范围：

    lxc config set my-container limits.cpu 0-3,7-11

限制实时生效，你可以看下面的例子：

    stgraber@dakara:~$ lxc exec zerotier -- cat /proc/cpuinfo | grep ^proces
    processor : 0
    processor : 1
    processor : 2
    processor : 3
    stgraber@dakara:~$ lxc config set zerotier limits.cpu 2
    stgraber@dakara:~$ lxc exec zerotier -- cat /proc/cpuinfo | grep ^proces
    processor : 0
    processor : 1

注意，为了避免完全混淆用户空间，lxcfs 会重排 /proc/cpuinfo 中的条目，以便没有错误。

就像 LXD 中的一切，这些设置也可以应用在配置文件中：

    stgraber@dakara:~$ lxc exec snappy -- cat /proc/cpuinfo | grep ^proces
    processor : 0
    processor : 1
    processor : 2
    processor : 3
    stgraber@dakara:~$ lxc profile set default limits.cpu 3
    stgraber@dakara:~$ lxc exec snappy -- cat /proc/cpuinfo | grep ^proces
    processor : 0
    processor : 1
    processor : 2

要限制容器使用 10% 的 CPU 时间，要设置下 CPU allowance：

    lxc config set my-container limits.cpu.allowance 10%

或者给它一个固定的 CPU 时间切片：

    lxc config set my-container limits.cpu.allowance 25ms/200ms

最后，要将容器的 CPU 优先级调到最低：

    lxc config set my-container limits.cpu.priority 0

内存

要直接应用内存限制运行下面的命令：

    lxc config set my-container limits.memory 256MB

（支持的后缀是 KB、MB、GB、TB、PB、EB）

要关闭容器的内存交换（默认启用）：

    lxc config set my-container limits.memory.swap false

告诉内核首先交换指定容器的内存：

    lxc config set my-container limits.memory.swap.priority 0

如果你不想要强制的内存限制：

    lxc config set my-container limits.memory.enforce soft

磁盘和块 I/O

不像 CPU 和内存，磁盘和 I/O 限制是直接作用在实际的设备上的，因此你需要编辑原始设备或者屏蔽某个具体的设备。

要设置磁盘限制（需要 btrfs 或者 ZFS）：

    lxc config device set my-container root size 20GB

比如：

    stgraber@dakara:~$ lxc exec zerotier -- df -h /
    Filesystem                        Size Used Avail Use% Mounted on
    encrypted/lxd/containers/zerotier 179G 542M  178G   1% /
    stgraber@dakara:~$ lxc config device set zerotier root size 20GB
    stgraber@dakara:~$ lxc exec zerotier -- df -h /
    Filesystem                       Size  Used Avail Use% Mounted on
    encrypted/lxd/containers/zerotier 20G  542M   20G   3% /

要限制速度，你可以：

    lxc config device set my-container root limits.read 30MB
    lxc config device set my-container root.limits.write 10MB

或者限制 IO 频率：

    lxc config device set my-container root limits.read 20Iops
    lxc config device set my-container root limits.write 10Iops

最后你在一个过量使用的繁忙系统上，你或许想要：

    lxc config set my-container limits.disk.priority 10

将那个容器的 I/O 优先级调到最高。
网络 I/O

只要机制可用，网络 I/O 基本等同于块 I/O。

比如：

    stgraber@dakara:~$ lxc exec zerotier -- wget http://speedtest.newark.linode.com/100MB-newark.bin -O /dev/null
    --2016-03-26 22:17:34-- http://speedtest.newark.linode.com/100MB-newark.bin
    Resolving speedtest.newark.linode.com (speedtest.newark.linode.com)... 50.116.57.237, 2600:3c03::4b
    Connecting to speedtest.newark.linode.com (speedtest.newark.linode.com)|50.116.57.237|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 104857600 (100M) [application/octet-stream]
    Saving to: '/dev/null'
    /dev/null 100%[===================>] 100.00M 58.7MB/s in 1.7s
    2016-03-26 22:17:36 (58.7 MB/s) - '/dev/null' saved [104857600/104857600]
    stgraber@dakara:~$ lxc profile device set default eth0 limits.ingress 100Mbit
    stgraber@dakara:~$ lxc profile device set default eth0 limits.egress 100Mbit
    stgraber@dakara:~$ lxc exec zerotier -- wget http://speedtest.newark.linode.com/100MB-newark.bin -O /dev/null
    --2016-03-26 22:17:47-- http://speedtest.newark.linode.com/100MB-newark.bin
    Resolving speedtest.newark.linode.com (speedtest.newark.linode.com)... 50.116.57.237, 2600:3c03::4b
    Connecting to speedtest.newark.linode.com (speedtest.newark.linode.com)|50.116.57.237|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 104857600 (100M) [application/octet-stream]
    Saving to: '/dev/null'
    /dev/null 100%[===================>] 100.00M 11.4MB/s in 8.8s
    2016-03-26 22:17:56 (11.4 MB/s) - '/dev/null' saved [104857600/104857600]

这就是如何将一个千兆网的连接速度限制到仅仅 100Mbit/s 的！

和块 I/O 一样，你可以设置一个总体的网络优先级：

    lxc config set my-container limits.network.priority 5

获取当前资源使用率

LXD API 可以导出目前容器资源使用情况的一点信息，你可以得到：

    内存：当前、峰值、目前内存交换和峰值内存交换
    磁盘：当前磁盘使用率
    网络：每个接口传输的字节和包数。

另外如果你使用的是非常新的 LXD（在写这篇文章时的 git 版本），你还可以在lxc info中得到这些信息：

    stgraber@dakara:~$ lxc info zerotier
    Name: zerotier
    Architecture: x86_64
    Created: 2016/02/20 20:01 UTC
    Status: Running
    Type: persistent
    Profiles: default
    Pid: 29258
    Ips:
     eth0: inet 172.17.0.101
     eth0: inet6 2607:f2c0:f00f:2700:216:3eff:feec:65a8
     eth0: inet6 fe80::216:3eff:feec:65a8
     lo: inet 127.0.0.1
     lo: inet6 ::1
     lxcbr0: inet 10.0.3.1
     lxcbr0: inet6 fe80::f0bd:55ff:feee:97a2
     zt0: inet 29.17.181.59
     zt0: inet6 fd80:56c2:e21c:0:199:9379:e711:b3e1
     zt0: inet6 fe80::79:e7ff:fe0d:5123
    Resources:
     Processes: 33
     Disk usage:
      root: 808.07MB
     Memory usage:
      Memory (current): 106.79MB
      Memory (peak): 195.51MB
      Swap (current): 124.00kB
      Swap (peak): 124.00kB
     Network usage:
      lxcbr0:
       Bytes received: 0 bytes
       Bytes sent: 570 bytes
       Packets received: 0
       Packets sent: 0
      zt0:
       Bytes received: 1.10MB
       Bytes sent: 806 bytes
       Packets received: 10957
       Packets sent: 10957
      eth0:
       Bytes received: 99.35MB
       Bytes sent: 5.88MB
       Packets received: 64481
       Packets sent: 64481
      lo:
       Bytes received: 9.57kB
       Bytes sent: 9.57kB
       Packets received: 81
       Packets sent: 81
    Snapshots:
     zerotier/blah (taken at 2016/03/08 23:55 UTC) (stateless)

总结

LXD 团队花费了几个月的时间来迭代我们使用的这些限制的语言。 它是为了在保持强大和功能明确的基础上同时保持简单。

实时地应用这些限制和通过配置文件继承，使其成为一种非常强大的工具，可以在不影响正在运行的服务的情况下实时管理服务器上的负载。

# Building a Network of Websites/Web Servers With LXD, for Beginners[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#building-a-network-of-websitesweb-servers-with-lxd-for-beginners)

## Introduction[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#introduction)

Okay, so we already have [a guide on installing LXD/LXC on Rocky Linux](https://docs.rockylinux.org/books/lxd_server/00-toc/), but that was written by someone who knows what he’s doing, and wanted  to build a containerized network of servers and/or apps on a physical  machine on his local network. It’s great, and I’ll be straight up  stealing bits of it so I don’t have to write as much.

But, if you’ve just heard about Linux Containers, and don’t really  understand how they work yet, but you want to host some websites, this  is the guide for you. *This tutorial will teach you how to host basic websites with LXD and LXC on any system, including virtual private  servers and cloud hosting.*

So first, what’s a Linux Container? Well, for the absolute beginner,  it’s a way to make one computer pretend that it’s actually a lot more  computers. These “containers” each house a basic—usually  stripped-down—version of an operating system you choose. You can use  each container like an individual server; put *nginx* on one, *Apache* on another, and even use a third as a database server.

The basic advantage is that if one app or website inside its own  container experiences severe bugs, a hack, or other problems, it’s  unlikely to affect the rest of your server or the other apps and  websites. Also, containers are super easy to snapshot, back up, and  restore.

In this case, we’ll be running Rocky Linux in our containers, on top of our “host” system, which is also Rocky Linux.

Conceptually, it’s something like this:

![A graph showing how one computer can pretend to be several](https://docs.rockylinux.org/guides/images/lxd-web-server-01.png)

If you’ve ever played with VirtualBox to run some Windows apps, it’s  like that, but not. Unlike virtual machines, Linux Containers don’t  emulate an entire hardware environment for each container. Rather, they  all share a few virtual devices by default for networking and storage,  though you can add more virtual devices. As a result, they require a lot less overhead (processing power and RAM) than a virtual machine.

For those Docker fiends out there (Docker being another container-based system, *not* a VM system), Linux Containers are less ephemeral than what you’re used to. All data in every container instance is persistent, and any changes you make are permanent unless you revert to a backup. In short,  shutting down the container won’t erase your sins.

Heh.

LXD, specifically, is a command-line application that helps you to  set up and manage Linux Containers. That's what we're going to be  installing on our Rocky Linux host server today. I'm going to be writing LXC/LXD a lot though, as there's a lot of old documentation which  refers to LXC only, and I'm trying to make it easier for people to find  updated guides like this one.

Note

There was a precursor app to LXD which was also called "LXC". As it stands today: LXC is the technology, LXD is the app.

We’ll be using them both to create an environment that works something like this:

![A diagram of the intended Linux Container structure](https://docs.rockylinux.org/guides/images/lxd-web-server-02.png)

Specifically, I’m going to show you how to set up simple Nginx and  Apache web servers inside of your server containers, and use another  container with Nginx as a reverse proxy. Again, this setup should work  in any environment: from local networks to virtual private servers.

Note

A reverse proxy is a program that takes incoming connections from the internet (or your local network) and routes them to the right server,  container, or app. There are also dedicated tools for this job like  HaProxy... but weirdly enough, I find Nginx a lot easier to use.

## Prerequisites And Assumptions[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#prerequisites-and-assumptions)

- Basic familiarity with the Linux command line interface. You should  know how to use SSH if you’re installing LXC/LXD on a remote server.
- An internet-connected server, physical or virtual, with Rocky Linux already running on it.
- Two domain names pointed right at your server with an A record.
  - Two subdomains would also work just as well. One domain with a  wildcard subdomain record would also, or a custom LAN domain... you get  the picture.
- A command-line text editor. *nano* will do, *micro* is my favorite, but use whatever makes you comfortable.
- You *can* follow this whole tutorial as the root user, but  you probably shouldn’t. After the initial installation of LXC/LXD, we’ll guide you in creating an unprivileged user specifically for operating  LXD commands.
- We now have Rocky Linux images to base your containers on, and they’re awesome.
- If you're not too familiar with Nginx or Apache, you **will** need to check out some of our other guides if you want to get a full  productions server up and running. Don't worry, I'll link them below.

## Setting Up The Host Server Environment[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#setting-up-the-host-server-environment)

So here’s where I’m going to copy and paste bits from the other LXD  guide, for your convenience and mine. All credit for most of this part  goes to Steven Spencer.

### Install the EPEL Repository[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#install-the-epel-repository)

LXD requires the EPEL (Extra Packages for Enterprise Linux) repository, which is easy to install using:

```
dnf install epel-release
```

Once installed, check for updates:

```
dnf update
```

If there were kernel updates during the update process above, reboot your server

### Install snapd[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#install-snapd)

LXD must be installed from a snap* package for Rocky Linux. For this reason, we need to install snapd with:

```
dnf install snapd
```

And now enable the snapd service to auto-start when your server reboots, and start it running now:

```
systemctl enable snapd
```

And then run:

```
systemctl start snapd
```

Reboot the server before continuing here. You can do this with the `reboot` command, or from your VPS/cloud hosting admin panel.

\* *snap* is a method of packaging applications so they come  with all of the dependencies they need, and can run on almost any Linux  system.

### Install LXD[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#install-lxd)

Installing LXD requires the use of the snap command. At this point, we are just installing it, we are doing no set up:

```
snap install lxd
```

If you’re running LXD on a physical (AKA “bare metal”) server, you  should probably go back to the other guide and read the “Environment  Setup” section there. There’s a lot of good stuff about kernels and file systems, and so much more.

If you’re running LXD in a virtual environment, just reboot and read on.

### LXD Initialization[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#lxd-initialization)

Now that the environment is all set up, we are ready to initialize  LXD. This is an automated script that asks a series of questions to get  your LXD instance up and running:

```
lxd init
```

Here are the questions and our answers for the script, with a little explanation where warranted:

```
Would you like to use LXD clustering? (yes/no) [default=no]:
```

If you are interested in clustering, do some additional research on that [here](https://linuxcontainers.org/lxd/docs/master/clustering/). Otherwise, just press “Enter” to accept the default option.

```
Do you want to configure a new storage pool? (yes/no) [default=yes]:
```

Accept the default.

```
Name of the new storage pool [default=default]: server-storage
```

Choose a name for your storage pool. I like to name it after the  server LXD is running on. (A storage pool is basically a set amount of  hard drive space set aside for your containers.)

```
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]: lvm
```

The above question is about what sort of file system you want to use  for storage, and the default may vary depending on what’s available on  your system. If you're on a bare metal server, and want to use ZFS,  again, refer back to the guide linked above.

In a virtual environment, I have found that “LVM” works fine, and  it’s usually what I use. You can accept the default on the next  question.

```
Create a new LVM pool? (yes/no) [default=yes]:
```

If you have a specific hard drive or partition you’d like to use for  the whole storage pool, write “yes” next. If you’re doing all of this on a VPS, you’ll probably *have* to choose “no”.

```
`Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]:`
```

Metal As A Service (MAAS) is outside the scope of this document. Accept the defaults for this next bit.

```
Would you like to connect to a MAAS server? (yes/no) [default=no]:
```

And more defaults. It's all good.

```
Would you like to create a new local network bridge? (yes/no) [default=yes]:

What should the new bridge be called? [default=lxdbr0]: `

What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
```

If you want to use IPv6 on your LXD containers, you can turn on this  next option. That is up to you, but you mostly shouldn’t need to. I  think. I tend to leave it on out of laziness.

```
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
```

This is necessary to easily back up the server, and can allow you to  manage your LXD install from other computers. If that all sounds good to you, answer "yes" here

```
Would you like the LXD server to be available over the network? (yes/no) [default=no]: yes
```

If you did say yes to the last questions, take the defaults here:

```
Address to bind LXD to (not including port) [default=all]:

Port to bind LXD to [default=8443]:
```

Now you'll be asked for a trust password. That's  how you will  connect to the LXC host server from other computers and servers, so set  this with something that makes sense in your environment. Save this  password to a secure location, such as a password manager.

```
Trust password for new clients:

Again:
```

And then keep taking the defaults from here on out:

```
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]

Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

#### Setting Up User Privileges[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#setting-up-user-privileges)

Before we continue on, we need to create our "lxdadmin" user and make sure that it has the privileges it needs. We need the "lxdadmin" user  to be able to use *sudo* for access to root commands, and we need it to be a member of the “lxd” group. To add the user and make sure it  is a member of both groups, run:

```
useradd -G wheel,lxd lxdadmin
```

Then set the password:

```
passwd lxdadmin
```

As with the other passwords, save this to a secure location.

## Setting Up Your Firewall[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#setting-up-your-firewall)

Before we do anything else with containers, you need to be able to  access your proxy server from the outside. If your firewall is blocking  port 80 (the default port used for HTTP/web traffic), or port 443 (used  for HTTPS/*secure* web traffic), then you won’t be doing much of anything server-wise.

The other LXD guide will show you how to do this with the *iptables* firewall, if that’s what you want to do. I tend to use the CentOS default firewall: *firewalld*. So that’s what we’re doing, this time.

`firewalld` is configured via the `firewall-cmd` command. **The absolute first thing we want to do,** before we open any ports, is make sure that your containers can be assigned their IP addresses automatically:

```
firewall-cmd --zone=trusted --permanent --change-interface=lxdbr0
```

Warning

If you don't do that last step, your containers will not be able to  properly access the internet, or each other. This is crazy-essential,  and knowing it will save you *ages* of frustration.

Now, to add a new port, just run this:

```
firewall-cmd --permanent --zone=public --add-port=80/tcp
```

Let’s break this down:

- The `-–permanent` flag tells the firewall to make sure  this configuration is used every time the firewall is restarted, and  when the server itself is restarted.
- `–-zone=public` tells the firewall to take incoming connections to this port from everyone.
- Lastly, `–-add-port=80/tcp` tells the firewall to accept  incoming connections over port 80, as long as they’re using the  Transmission Control Protocol, which is what you want in this case.

To repeat the process for HTTPS traffic, just run the command again, and change the number.

```
firewall-cmd --permanent --zone=public --add-port=443/tcp
```

These configurations won’t take effect until you force the issue. To do that, tell *firewalld* to reload its configurations, like so:

```
firewall-cmd --reload
```

Now, there’s a very small chance that this won’t work. In those rare cases, make *firewalld* do your bidding with the old turn-it-off-and-turn-it-on-again.

```
systemctl restart firewalld
```

To make sure the ports have been added properly, run `firewall-cmd --list-all`. A properly-configured firewall will look a bit like this (I have a few extra ports open on my local server, ignore them):

```
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp9s0
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 81/tcp 444/tcp 15151/tcp 80/tcp 443/tcp
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

And that should be everything you need, firewall-wise.

## Setting Up The Containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#setting-up-the-containers)

Actually managing containers is pretty easy. Just think of it as  being able to conjure up a whole computer on command, and start or stop  it at will. You can also log into said “computer” and run any commands  you like, just as you would with your host server.

Note

From here on out, every command should be run as the `lxdadmin` user, or whatever you decided to call it, though some will require the use of *sudo* for temporary root privileges.

You’re going to need three containers for this tutorial: the reverse  proxy server, a test Nginx server, and a test Apache server, all running on Rocky-based containers.

If for some reason you need a fully privileged container (and you mostly shouldn’t), you can run all of these commands as root.

For this tutorial, you’ll need three containers:

We’ll call them “proxy-server” (for the container that will be  directing web traffic to the other two containers), “nginx-server”, and  “apache-server”. Yes, I’ll be showing you how to reverse proxy to both *nginx* and *apache*-based servers. Things like *docker* or NodeJS apps we can wait with until I figure that out myself.

We’ll start by figuring out which image we want to base our  containers on. For this tutorial, we’re just using Rocky Linux. Using  Alpine Linux, for example, can result in much smaller containers (if  storage is a concern), but that’s beyond the scope of this particular  document.

### Finding the Image You Want[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#finding-the-image-you-want)

Here’s the short, short method for starting a container with Rocky Linux:

```
lxc launch images:rockylinux/8/amd64 my-container
```

Of course, that “my-container” bit at the end should be renamed to  whatever container name you want, eg. “proxy-server”. The “/amd64” part  should be changed to “arm64”  if you’re doing all of this on something  like a Raspberry Pi.

Now here’s the long version: to find the images you want, you can use this command to list every available image in the main LXC  repositories:

```
lxc image list images: | more
```

Then just press “Enter” to scroll down a massive list of images, and press “Control-C” to get out of the list-viewing mode.

Or, you could simplify your life, and specify what kind of Linux you want, like so:

```
lxc image list images: | grep rockylinux
```

That should print out a much shorter list that looks like this:

```
| rockylinux/8 (3 more)                    | 4e6beda70200 | yes    | Rockylinux 8 amd64 (20220129_03:44)          | x86_64       | VIRTUAL-MACHINE | 612.19MB  | Jan 29, 2022 at 12:00am (UTC) |
| rockylinux/8 (3 more)                    | c04dd2bcf20b | yes    | Rockylinux 8 amd64 (20220129_03:44)          | x86_64       | CONTAINER       | 127.34MB  | Jan 29, 2022 at 12:00am (UTC) |
| rockylinux/8/arm64 (1 more)              | adc0561d6330 | yes    | Rockylinux 8 arm64 (20220129_03:44)          | aarch64      | CONTAINER       | 124.03MB  | Jan 29, 2022 at 12:00am (UTC) |
| rockylinux/8/cloud (1 more)              | 2591d9716b04 | yes    | Rockylinux 8 amd64 (20220129_03:43)          | x86_64       | CONTAINER       | 147.04MB  | Jan 29, 2022 at 12:00am (UTC) |
| rockylinux/8/cloud (1 more)              | c963253fcea9 | yes    | Rockylinux 8 amd64 (20220129_03:43)          | x86_64       | VIRTUAL-MACHINE | 630.56MB  | Jan 29, 2022 at 12:00am (UTC) |
| rockylinux/8/cloud/arm64                 | 9f49e80afa5b | yes    | Rockylinux 8 arm64 (20220129_03:44)          | aarch64      | CONTAINER       | 143.15MB  | Jan 29, 2022 at 12:00am (UTC) |
```

### Creating the Containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#creating-the-containers)

Note

Below, is a quick way to create all of these containers. You may want to wait before creating the proxy-server container. There's a trick  I'll show you down below that could save you time.

Once you’ve found the image you want, use the `lxc launch` command as shown above. To make the containers we want for this  tutorial, run these commands (modifying them as needed) in succession:

```
lxc launch images:rockylinux/8/amd64 proxy-server
lxc launch images:rockylinux/8/amd64 nginx-server
lxc launch images:rockylinux/8/amd64 apache-server
```

As you run each command, you should get a notification that your  containers have been created, and even started. Then, you’ll want to  check on all of them.

Run this command to see that they’re all up and running:

```
lxc list
```

That should give you output that looks a bit like this (though, if you opted to use IPv6, it’s going to be a lot more text):

```
+---------------+---------+-----------------------+------+-----------+-----------+
|     NAME      |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+---------------+---------+-----------------------+------+-----------+-----------+
| proxy-server  | RUNNING | 10.199.182.231 (eth0) |      | CONTAINER | 0         |
+---------------+---------+-----------------------+------+-----------+-----------+
| nginx-server  | RUNNING | 10.199.182.232 (eth0) |      | CONTAINER | 0         |
+---------------+---------+-----------------------+------+-----------+-----------+
| apache-server | RUNNING | 10.199.182.233 (eth0) |      | CONTAINER | 0         |
+---------------+---------+-----------------------+------+-----------+-----------+
```

#### A Word on Container Networking[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#a-word-on-container-networking)

So the other guide linked at the beginning of this one has a whole  tutorial on how to set LXC/LXD up to work with Macvlan. This is  especially useful if you’re running a local server, and you want each  container to have an IP address visible on the local network.

When you’re running on a VPS, you don’t often have that option. In  fact, you might only have one single IP address that you’re allowed to  work with. No biggie. The default networking configuration is designed  to accommodate this sort of limitation; answering the `lxd init` questions as I specified above *should* take care of everything.

Basically, LXD creates a virtual network device called a bridge  (usually named “lxdbr0”), and all containers get connected to that  bridge by default. Through it, they can connect to the internet via your host’s default network device (ethernet, wi-fi, or a virtual network  device provided by your VPS). Somewhat more importantly, all of the  containers can connect to each other.

To ensure this inter-container connection, *every container gets an internal domain name*. By default, this is just the name of the container plus “.lxd”. So the  “proxy-server” container is available to all the other containers at  “proxy-server.lxd”. But here’s the *really* important thing to know: by **default “.lxd” domains are only available inside the containers themselves.**

If you run `ping proxy-server.lxd` on the host OS (or  anywhere else), you’ll get nothing. Those internal domains are going to  come in super handy later on, though.

You can technically change this, and make the container’s internal  domains available on the host… but I never actually figured that out.  It’s probably best to put your reverse proxy server in a container  anyway, so you can snapshot and back it up with ease.

### Managing Your Containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#managing-your-containers)

Some things you should know before going forward:

#### Starting & Stopping[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#starting-stopping)

All containers can be started, stopped, and restarted as needed with the following commands:

```
lxc start mycontainer
lxc stop mycontainer
lxc restart mycontainer
```

Hey, even Linux needs to reboot sometimes. And heck, you can actually start, stop, and restart all containers at once with the following  commands.

```
lxc start --all
lxc stop --all
lxc restart --all
```

That `restart --all` option comes in real handy for some of the more obscure temporary bugs.

#### Doing Stuff Inside Your Containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#doing-stuff-inside-your-containers)

You can control the operating system inside your container in two  ways: you can just run commands inside them from the host OS, or you can open a shell.

Here’s what I mean. To run a command inside a container, maybe to install *Apache*, just use `lxc exec`, like so:

```
lxc exec my-container dnf install httpd -y
```

That will make *Apache* install on its own, and you will see the output of the command on your host’s terminal.

To open a shell (where you can just run all the commands you want as root), use this:

```
lxc exec my-container bash
```

If you’re like me, valuing convenience over storage space, and have installed an alternate shell like *fish* in all of your containers, just change the command like so:

```
lxc exec my-container fish
```

In almost all instances, you’ll automatically be placed on the root account, and in the `/root` directory.

Finally, if you've opened a shell into a container, you leave it the same way you leave any shell: with a simple `exit` command.

#### Copying Containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#copying-containers)

Now, if you have a container you’d like to replicate with minimal  effort, you don’t need to start a brand new one and install all of your  base applications again. That’d be silly. Just run:

```
lxc copy my-container my-other-container
```

An exact copy of “my-container” will be created with the name  “my-other-container”. It may not start automatically though, so make any changes you might want to make to your new container’s configuration,  then run:

```
lxc start my-other-container
```

At this point, you may want to make some changes, like changing the container’s internal hostname, or something.

#### Configuring Storage & CPU Limits[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#configuring-storage-cpu-limits)

LXC/LXD usually defines how much storage space a container gets, and  generally manages resources, but you might want control over that. If  you’re worried about keeping your containers small, you can use the `lxc config` command to shrink and stretch them as needed.

The following command will set a “soft” limit of 2GB on a container. A soft limit is actually more of a “minimum storage”, and the container  will use more storage if it’s available. As always, change  “my-container” to the name of the actual container.

```
lxc config set my-container limits.memory 2GB
```

You can set a hard limit like so:

```
lxc config set my-container limits.memory.enforce 2GB
```

And if you want to make sure that any given container can’t take over all the processing power available to your server, you can limit the  CPU cores it has access to with this command. Just change the number of  CPU cores at the end as you see fit.

```
lxc config set my-container limits.cpu 2
```

#### Deleting Containers (and How to Keep That From Happening)[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#deleting-containers-and-how-to-keep-that-from-happening)

Lastly, you can delete containers by running this command:

```
lxc delete my-container
```

You won’t be able to delete the container if it’s running, so you can either stop it first, or use the `-–force` flag to skip that part.

```
lxc delete my-container --force
```

Now, thanks to tab -command-completion, user error, and the fact that “d” sits next to “s” on most keyboards, you can accidentally delete  containers. This is known, in the business, as THE BIG OOPS. (Or at  least it’ll be known as THE BIG OOPS when I’m done here.)

To defend against that, you can set any container to be “protected”  (making the process of deleting them take an extra step) with this  command:

```
lxc config set my-container security.protection.delete true
```

To un-protect the container, just run the command again, but change “true” to “false”.

## Setting Up The Servers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#setting-up-the-servers)

Okay, now that your containers are up and running, it’s time to  install what you need. First, make sure all of them are updated with the following commands (skip the “proxy-server” container if you haven’t  created it yet):

```
lxc exec proxy-server dnf update -y
lxc exec nginx-server dnf update -y
lxc exec apache-server dnf update -y
```

Then, jump into each container, and get cracking.

You’ll also need a text editor for every container. By default, Rocky Linux comes with *vi*, but if you want to simplify your life, *nano* will do. You can install it in each container before you open them up.

```
lxc exec proxy-server dnf install nano -y
lxc exec nginx-server dnf install nano -y
lxc exec apache-server dnf install nano -y
```

I’ll be using *nano* in all of the text-editor-related commands going forward, but you do you.

### The Apache website server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#the-apache-website-server)

We're going to keep this short, for learning and testing purposes. Look below for a link to your full Apache guides.

First, open up a shell into your container. Note that by default,  containers will drop you into the root account. For our purposes, that's fine, though you may want to create a specific web server user for  actual production purposes.

```
lxc exec apache-server bash
```

Once you’re logged in, just install *Apache* the easy way:

```
dnf install httpd
```

Now, you could follow our [Apache Web Server Multi-Site Setup guide](https://docs.rockylinux.org/guides/web/apache-sites-enabled/) from here on out, but that’s actually kind of overkill for our  purposes. We don’t usually want to set up Apache for multiple websites  in a containerized environment like this. The whole point of containers  is a separation of concerns, after all.

Also, the SSL certificates are going on the proxy server, so we’re going to keep things simple.

Once *Apache* is installed, make sure it’s running, and can keep running on reboot:

```
systemctl enable --now httpd
```

The `--now` flag lets you skip the command to start the actual server. For reference, that would be:

```
systemctl start httpd
```

If you have `curl` installed on your server host, you can make sure the default web page is up and running with:

```
curl [container-ip-address]
```

Remember, you can see all container IPs with `lxc list`. And if you install curl on all your containers, you *could* just run:

```
curl localhost
```

#### Getting real user IPs from the proxy server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#getting-real-user-ips-from-the-proxy-server)

Now here's a step that you'll need to do to prepare Apache for using  the reverse proxy. By default, the actual IP addresses of users will not be logged by the servers in your web server containers. You want those  IP addresses to go through because some web apps need user IPs for  things like moderation, banning, and troubleshooting.

To make your visitor's IP addresses get past the proxy server, you  need two parts: the right settings in the proxy server (we'll cover that later), and a simple configuration file for the Apache server.

A big thanks goes out to Linode and [their own LXD guide](https://www.linode.com/docs/guides/beginners-guide-to-lxd-reverse-proxy) for the templates for these config files.

Make a new config file:

```
nano /etc/httpd/conf.d/real-ip.conf
```

And add this text to it:

```
RemoteIPHeader X-Real-IP
RemoteIPTrustedProxy proxy-server.lxd
```

Remember to change `proxy-server.lxd` to whatever you called your actual proxy container, if necessary. Now **don't restart the Apache server just yet.** That configuration file we added could cause problems *until* we get the proxy server up and running.

Exit the shell for now, and let's start on the Nginx server.

Note

While this technique *does* work (your web apps and websites will get the users' real IPs), Apache's own access logs *will not show the right IPs.* They'll usually show the IP of the container that your reverse proxy is in. This is apparently a problem with how Apache logs things.

I've found loads of solutions on Google, and none of them have  actually worked for me. Watch this space for someone much smarter than I am to figure it out. In the meantime, you can check the proxy server's  access logs if you need to see the IP addresses yourself, or check the  logs of whatever web app you're installing.

### The Nginx website server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#the-nginx-website-server)

Again, we're keeping this short. If you want to use the latest (and recommended) version of Nginx in production, check out our [beginner's guide to installing Nginx](https://docs.rockylinux.org/guides/web/nginx-mainline/). That covers the full install guide, and some best practices for configuring your server.

For testing and learning, you *could* just install Nginx normally, but I recommend installing the latest version, which is called the "mainline" branch.

First, log into the container's shell:

```
lxc exec nginx-server bash
```

Then, install the `epel-release` repository so you can install the latest version of Nginx:

```
dnf install epel-release
```

Once that's done, search for the latest version of Nginx with:

```
dnf module list nginx
```

That should get you a list that looks like this:

```
Rocky Linux 8 - AppStream
Name       Stream        Profiles        Summary
nginx      1.14 [d]      common [d]      nginx webserver
nginx      1.16          common [d]      nginx webserver
nginx      1.18          common [d]      nginx webserver
nginx      1.20          common [d]      nginx webserver
nginx      mainline      common [d]      nginx webserver
```

The one you want is, you guessed it: the mainline branch. Enable the module with this command:

```
dnf enable module nginx:mainline
```

You'll be asked if you're sure you want to do this, so just choose `Y` as usual. Then, use the default command to install Nginx:

```
dnf install nginx
```

Then, enable and start Nginx:

```
dnf enable --now nginx
```

Note

Remember when I said to wait before creating the proxy container?  Here's why: at this point, you can save yourself some time by leaving  the "nginx-server" container, and copying it to make the "proxy-server"  container:

```
lxc copy nginx-server proxy-server
```

Make sure to start the proxy container with `lxc start proxy-server`, and add the proxy ports to the container as detailed below.

Again, you can make sure the container is working from the host with:

```
curl [your-container-ip]
```

#### Getting real user IPs from the proxy server (again)[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#getting-real-user-ips-from-the-proxy-server-again)

The logs *should* work this time. Should. To do this, we're putting a very similar file in `/etc/nginx/conf.d`:

```
nano /etc/nginx/conf.d/real-ip.conf
```

Then put this text in it:

```
real_ip_header    X-Real-IP;
set_real_ip_from  proxy-server.lxd;
```

Lastly, **don't restart the server yet**. Again, that config file could cause problems until the proxy server is set up.

### The Reverse Proxy Server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#the-reverse-proxy-server)

So remember when I said you'd need two domains or subdomains? This is where you need them. The subdomains I'm using for this tutorial are:

- apache.server.test
- nginx.server.test

Change them in all the files and instructions as needed.

If you copied the "proxy-server" container from your "nginx-server"  container, and you've added your proxy devices to it, just jump on into  the shell. If you created the container earlier, you'll need to repeat  all the steps for installing Nginx in the "proxy-server" container.

Once it's installed and you know it runs okay, you just need to set  up a couple of configuration files to direct traffic from your chosen  domains to the actual website servers.

Before you do that, make sure you can access both servers via their internal domains:

```
curl apache-server.lxd
curl nginx-server.lxd
```

If those two commands load the HTML of the default server welcome  pages in your terminal, then everything has been set up correctly.

#### *Essential Step:* Configuring the “proxy-server” Container to Take all Incoming Server Traffic[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#essential-step-configuring-the-proxy-server-container-to-take-all-incoming-server-traffic)

Again, you might want to do this later when you actually create the proxy server, but here are the instructions you'll need:

Remember when we opened up ports 80 and 443 in the firewall? Here’s  where we make the “proxy-server” container listen to those ports, and  take all the traffic directed at them.

Just run these two commands in succession:

```
lxc config device add proxy-server myproxy80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
lxc config device add proxy-server myproxy443 proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:443
```

Let’s break that down. Each command is adding a virtual “device” to  the proxy-server container. Those devices are set to listen on the host  OS’ port 80 and port 443, and bind them to the container’s port 80 and  port 443. Each device needs a name, so I’ve chosen “myproxy80”, and  “myproxy443”.

The “listen” option is the port on the host OS, and if I’m not  mistaken, 0.0.0.0 is the IP address for the host on the “lxdbr0” bridge. The “connect” option is the local IP address and ports being connected  to.

Note

Once these devices have been set up, you should reboot all the containers, just to be sure.

These virtual device should ideally be unique. It's usually best not  to add a “myport80” device to another container that's currently  running; it’ll have to be called something else. 

*Likewise, only one container can listen on any specific host OS port at a time.*

#### Directing traffic to the Apache server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#directing-traffic-to-the-apache-server)

In the "proxy-server" container, create a configuration file called `apache-server.conf` in `/etc/nginx/conf.d/`:

```
nano /etc/nginx/conf.d/apache-server.conf
```

Then paste this test in, change the domain name as necessary, and save it:

```
upstream apache-server {
    server apache-server.lxd:80;
}

server {
    listen 80 proxy_protocol;
    listen [::]:80 proxy_protocol;
    server_name apache.server.test; #< Your domain goes here

    location / {
        proxy_pass http://apache-server;

        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Let's break that down a little:

- The `upstream` section is defining exactly where the  reverse proxy is going to send all its traffic. Specifically, it's  sending traffic to the "apache-server" container's internal domain name: `apache-server.lxd`.
- The two lines that start with `listen` are telling the  server to listen to traffic coming in on port 80 with the proxy  protocol. The first via IPv4, and the second via IPv6.
- The `server_name` function takes all the traffic that's specifically coming to "apache.server.test" and routes it through the reverse proxy.
- The `proxy-pass` function is the part that actually directs all traffic captured by the `server_name` variable, and sends it to the server defined in the `upstream` section.
- The `proxy_redirect` function can apparently interfere with reverse proxies, so we're making sure it's turned off.
- All of the `proxy-set-header` options are sending information like the user's IP and more to the web server.

Warning

The `proxy_protocol` bit in the `listen` variables is *essential* for the proxy server to work. Never leave it out.

For every LXD/website configuration file, you'll need to change the `upstream`, `server`, `server_name`, and `proxy_pass` settings accordingly. The text after "http://" in `proxy-pass` must match the txt that comes after the `upstream` text.

Reload the server with `systemctl restart nginx`, then point your browser at whatever domain you're using instead of `apache.server.test`. If you see a page that looks like this, you're golden:

![A screenshot of the default Rocky Linux Apache welcome page](https://docs.rockylinux.org/guides/images/lxd-web-server-03.png)

Note

You can name the config files whatever you like. I'm using simplified names for the tutorials, but some sysadmins recommend names based on  the actual domain, but backwards. It's an alphabetical order-based  organization thing.

eg. "apache.server.test" would get a configuration file named `test.server.apache.conf`.

#### Directing traffic to the Nginx server[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#directing-traffic-to-the-nginx-server)

Just kinda repeat the process. Create a file just like before:

```
nano /etc/nginx/conf.d/nginx-server.conf
```

Add the approriate text:

```
upstream nginx-server {
    server rocky-nginx.lxd:80;
}

server {
    listen 80 proxy_protocol;
    listen [::]:80 proxy_protocol;
    server_name nginx.server.test; #< Your domain goes here

    location / {
        proxy_pass http://nginx-server;

        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Again, reload the proxy server, point your browser at the appropriate address, and hope to whatever deity your prefer that you see this:

![A screenshot of the default Rocky Linux Nginx welcome page](https://docs.rockylinux.org/guides/images/lxd-web-server-04.png)

#### Restart the servers in your web server containers[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#restart-the-servers-in-your-web-server-containers)

Exit back out of the "proxy-server" container, and restart the servers in your other two containers with one simple command:

```
lxc exec apache-server systemctl restart httpd && lxc exec nginx-server restart nginx
```

That will apply the "real-ip.conf" files we made to their respective server configurations.

#### Getting SSL certificates for your websites[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#getting-ssl-certificates-for-your-websites)

Getting official, proper SSL certificates is easiest with Let's  Encrypt, and a little application called certbot. certbot will  automatically detect your websites, get SSL certificates for them, and  configure the sites themselves. It will even renew the certificates for  you every 30 days or so, without any intervention from you or cron jobs.

This all has to be done from the "proxy-server" container, so log  into that shell. Once there, install the EPEL repositories, just like  you did on the host. Make sure the container is updated first:

```
dnf update
```

Then, add the EPEL repository:

```
dnf install epel-release
```

Then you just need to install certbot and its Nginx module:

```
dnf install certbot python3-certbot-nginx
```

Once installed, as long as you already have a couple of websites configured, just run:

```
certbot --nginx
```

Certbot will read your Nginx configuration, and figure out how many  websites you have and if they need SSL certificates. At this point,  you'll be asked a few questions. Do you accept the terms of service, do  you want emails, etc?

The most important questions are as follows. Enter your email address when you see this:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel):
```

Here you can choose which websites get certificates. Just hit enter to get certificates for all of them.

```
Which names would you like to activate HTTPS for?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: apache.server.test
2: nginx.server.test
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel):
```

You'll see a bunch of confirmation text, and it'll be done. But if  you go to your websites, you might find that they don't work. This is  because when certbot creates the updated configuration, it forgets one  very important thing.

Go into your `apache-server.conf` and `nginx-server.conf` files, and find the following two lines:

```
listen [::]:443 ssl ipv6only=on; # managed by Certbot
listen 443 ssl; # managed by Certbot
```

Yep, they're missing the `proxy_protocol` setting, and that's bad. Add it in yourself.

```
listen proxy_protocol [::]:443 ssl ipv6only=on; # managed by Certbot
listen proxy_protocol 443 ssl; # managed by Certbot
```

Save the file, restart the server, and your websites should load without any issue.

## Notes[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#notes)

1. In this tutorial, I didn't mention configuring the actual web  servers much. The very least you should do, in production, is change the domains names in the server config files in your actual web server  containers, and not just the proxy container. And maybe set up a web  server user in each.
2. If you want to know a bit more about managing SSL certificates and SSL server configurations manually, check out [our guide to installing certbot and generating SSL certificates](https://docs.rockylinux.org/guides/security/generating_ssl_keys_lets_encrypt/).
3. Apps like Nextcloud will require some extra configuration (for  security reasons) if you put them in an LXD container behind a proxy.

## Conclusion[¶](https://docs.rockylinux.org/guides/containers/lxd_web_servers/#conclusion)

There's a lot more to learn about LXC/LXD, containerization, web  servers, and running websites, but that should honestly give you a good  start. Once you learn how everything should be set up, and how to  configure things the way you like, you can even begin to automate the  process.

You might use Ansible, or you might be like me, and just have a  custom-written set of scripts that you run to make everything go faster. You can even create small "template containers" with all of your  favorite software preinstalled, then just copy them and expand their  storage capacity as needed.

Okay. This is done. I'm off to play video games. Have fun!
