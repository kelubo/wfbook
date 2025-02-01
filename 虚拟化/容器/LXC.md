# LXC

[TOC]

Containers are a lightweight virtualization technology. They are more akin to an  enhanced chroot than to full virtualization like Qemu or VMware, both  because they do not emulate hardware and because containers share the  same operating system as the host. Containers are similar to Solaris  zones or BSD jails. Linux-vserver and OpenVZ are two pre-existing,  independently developed implementations of containers-like functionality for Linux. In fact, containers came about as a result of the work to  upstream the vserver and OpenVZ functionality.
容器是一种轻量级的虚拟化技术。它们更像是增强的 chroot，而不是像 Qemu 或 VMware 这样的完全虚拟化，因为它们不模拟硬件，也因为容器与主机共享相同的操作系统。容器类似于  Solaris 区域或 BSD 监狱。Linux-vserver 和 OpenVZ 是两个预先存在的、独立开发的类似容器的 Linux  功能实现。事实上，容器的出现是上游虚拟服务器和 OpenVZ 功能的结果。

There are two user-space implementations of containers, each exploiting the  same kernel features. Libvirt allows the use of containers through the  LXC driver by connecting to `lxc:///`. This can be very convenient as it supports the same usage as its other  drivers. The other implementation, called simply ‘LXC’, is not  compatible with libvirt, but is more flexible with more userspace tools. It is possible to switch between the two, though there are  peculiarities which can cause confusion.
容器有两种用户空间实现，每种都利用相同的内核功能。Libvirt 允许通过 LXC 驱动程序连接到 `lxc:///` .这可能非常方便，因为它支持与其他驱动程序相同的用法。另一种实现，简称为“LXC”，与 libvirt 不兼容，但使用更多用户空间工具更灵活。可以在两者之间切换，尽管有一些特殊性可能会引起混淆。

In this document we will mainly describe the `lxc` package. Use of libvirt-lxc is not generally recommended due to a lack of Apparmor protection for libvirt-lxc containers.
在本文档中，我们将主要介绍该 `lxc` 软件包。通常不建议使用 libvirt-lxc，因为 libvirt-lxc 容器缺乏 Apparmor 保护。

In this document, a container name will be shown as CN, C1, or C2.
在本文档中，容器名称将显示为 CN、C1 或 C2。

## 安装

安装 lxc 软件包可以使用

```bash
sudo apt install lxc
```

This will pull in the required and recommended dependencies, as well as set  up a network bridge for containers to use. If you wish to use  unprivileged containers, you will need to ensure that users have  sufficient allocated subuids and subgids, and will likely want to allow  users to connect containers to a bridge (see *Basic unprivileged usage* below).
这将拉取必需和推荐的依赖项，并设置网络网桥供容器使用。如果要使用非特权容器，则需要确保用户具有足够的分配的 subuid 和 subgids，并且可能希望允许用户将容器连接到网桥（请参阅下面的基本非特权用法）。

## 基本用法

LXC can be used in two distinct ways - privileged, by running the lxc  commands as the root user; or unprivileged, by running the lxc commands  as a non-root user. (The starting of unprivileged containers by the root user is possible, but not described here.) Unprivileged containers are  more limited, for instance being unable to create device nodes or mount  block-backed filesystems. However they are less dangerous to the host,  as the root UID in the container is mapped to a non-root UID on the  host.
LXC 可以以两种不同的方式使用 - 特权，以 root 用户身份运行 lxc 命令;或无特权，以非 root 用户身份运行 lxc 命令。（root  用户可以启动非特权容器，但此处未介绍。非特权容器受到更多限制，例如无法创建设备节点或挂载块支持的文件系统。但是，它们对主机的危险性较小，因为容器中的根 UID 映射到主机上的非根 UID。

### Basic privileged usage 基本特权用法

To create a privileged container, you can simply do:
若要创建特权容器，只需执行以下操作：

```auto
sudo lxc-create --template download --name u1
```

or, abbreviated 或者，缩写为

```auto
sudo lxc-create -t download -n u1
```

This will interactively ask for a container root filesystem type to download – in particular the distribution, release, and architecture. To create  the container non-interactively, you can specify these values on the  command line:
这将以交互方式要求下载容器根文件系统类型，特别是发行版、发布版和架构。若要以非交互方式创建容器，可以在命令行上指定以下值：

```auto
sudo lxc-create -t download -n u1 -- --dist ubuntu --release DISTRO-SHORT-CODENAME --arch amd64
```

or

```auto
sudo lxc-create -t download -n u1 -- -d ubuntu -r DISTRO-SHORT-CODENAME -a amd64
```

You can now use `lxc-ls` to list containers, `lxc-info` to obtain detailed container information, `lxc-start` to start and `lxc-stop` to stop the container. `lxc-attach` and `lxc-console` allow you to enter a container, if ssh is not an option. `lxc-destroy` removes the container, including its rootfs. See the manual pages for  more information on each command. An example session might look like:
现在 `lxc-ls` ，您可以使用列出容器、 `lxc-info` 获取详细的容器信息、 `lxc-start` 启动和 `lxc-stop` 停止容器。 `lxc-attach` 并 `lxc-console` 允许您输入容器（如果 SSH 不是一个选项）。 `lxc-destroy` 删除容器，包括其 rootf。有关每个命令的详细信息，请参阅手册页。示例会话可能如下所示：

```auto
sudo lxc-ls --fancy
sudo lxc-start --name u1 --daemon
sudo lxc-info --name u1
sudo lxc-stop --name u1
sudo lxc-destroy --name u1
```

### User namespaces 用户命名空间

Unprivileged containers allow users to create and administer containers without  having any root privilege. The feature underpinning this is called user  namespaces. User namespaces are hierarchical, with privileged tasks in a parent namespace being able to map its ids into child namespaces. By  default every task on the host runs in the initial user namespace, where the full range of ids is mapped onto the full range. This can be seen  by looking at `/proc/self/uid_map` and `/proc/self/gid_map`, which both will show `0 0 4294967295` when read from the initial user namespace. As of Ubuntu 14.04, when new users are created they are by default offered a range of UIDs. The list of assigned ids can be seen in the files `/etc/subuid` and `/etc/subgid` See their respective manpages for more information. Subuids and subgids are by convention started at id 100000 to avoid conflicting with system users.
非特权容器允许用户在没有任何 root 权限的情况下创建和管理容器。支持此功能的功能称为用户命名空间。用户命名空间是分层的，父命名空间中的特权任务能够将其 ID  映射到子命名空间中。默认情况下，主机上的每个任务都在初始用户命名空间中运行，其中 ID 的完整范围映射到整个范围。这可以通过查看 `/proc/self/uid_map` 和 `/proc/self/gid_map` 来查看，从初始用户命名空间读取时，两者都将显示 `0 0 4294967295` 出来。从 Ubuntu 14.04 开始，当创建新用户时，默认会为他们提供一系列 UID。分配的 ID 列表可以在文件中 `/etc/subuid` 查看，有关详细信息 `/etc/subgid` ，请参阅它们各自的手册页。按照惯例，Subuid 和 subgids 从 id 100000 开始，以避免与系统用户发生冲突。

If a user was created on an earlier release, it can be granted a range of ids using `usermod`, as follows:
如果用户是在早期版本上创建的，则可以使用 `usermod` 为其授予一系列 ID，如下所示：

```auto
sudo usermod -v 100000-200000 -w 100000-200000 user1
```

The programs `newuidmap` and `newgidmap` are setuid-root programs in the `uidmap` package, which are used internally by lxc to map subuids and subgids  from the host into the unprivileged container. They ensure that the user only maps ids which are authorized by the host configuration.
程序 `newuidmap` 和 `newgidmap` 是 `uidmap` 包中的 setuid-root 程序，lxc 在内部使用它们将 subuid 和 subgid 从主机映射到非特权容器中。它们确保用户仅映射主机配置授权的 ID。

### Basic unprivileged usage 基本非特权用法

To create unprivileged containers, a few first steps are needed. You will  need to create a default container configuration file, specifying your  desired id mappings and network setup, as well as configure the host to  allow the unprivileged user to hook into the host network. The example  below assumes that your mapped user and group id ranges are  100000–165536. Check your actual user and group id ranges and modify the example accordingly:
若要创建非特权容器，需要执行几个初始步骤。您需要创建一个默认的容器配置文件，指定所需的 ID 映射和网络设置，并将主机配置为允许非特权用户挂接到主机网络。以下示例假定映射的用户和组 ID 范围为  100000–165536。检查您的实际用户和组 ID 范围，并相应地修改示例：

```auto
grep $USER /etc/subuid
grep $USER /etc/subgid
mkdir -p ~/.config/lxc
echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
echo "$USER veth lxcbr0 2" | sudo tee -a /etc/lxc/lxc-usernet
```

After this, you can create unprivileged containers the same way as privileged ones, simply without using sudo.
在此之后，您可以像创建特权容器一样创建非特权容器，只需不使用 sudo。

```auto
lxc-create -t download -n u1 -- -d ubuntu -r DISTRO-SHORT-CODENAME -a amd64
lxc-start -n u1 -d
lxc-attach -n u1
lxc-stop -n u1
lxc-destroy -n u1
```

### Nesting 嵌 套

In order to run containers inside containers - referred to as nested  containers - two lines must be present in the parent container  configuration file:
为了在容器内运行容器（称为嵌套容器），父容器配置文件中必须存在两行：

```auto
lxc.mount.auto = cgroup
lxc.aa_profile = lxc-container-default-with-nesting
```

The first will cause the cgroup manager socket to be bound into the  container, so that lxc inside the container is able to administer  cgroups for its nested containers. The second causes the container to  run in a looser Apparmor policy which allows the container to do the  mounting required for starting containers. Note that this policy, when  used with a privileged container, is much less safe than the regular  policy or an unprivileged container. See the *Apparmor* section for more information.
第一种将导致 cgroup 管理器套接字绑定到容器中，以便容器内的 lxc 能够管理其嵌套容器的 cgroups。第二种情况是使容器在更宽松的  Apparmor  策略中运行，该策略允许容器执行启动容器所需的挂载。请注意，当与特权容器一起使用时，此策略的安全性远低于常规策略或非特权容器。有关详细信息，请参阅 Apparmor 部分。

## Global configuration 全局配置

The following configuration files are consulted by LXC. For privileged use, they are found under `/etc/lxc`, while for unprivileged use they are under `~/.config/lxc`.
LXC 查阅了以下配置文件。对于特权使用，它们位于 下 `/etc/lxc` ，而对于非特权使用，它们位于 `~/.config/lxc` 下。

- `lxc.conf` may optionally specify alternate values for several lxc settings,  including the lxcpath, the default configuration, cgroups to use, a  cgroup creation pattern, and storage backend settings for lvm and zfs.
   `lxc.conf` 可以选择为多个 LXC 设置指定备用值，包括 LXCPATH、默认配置、要使用的 cgroup、cgroup 创建模式以及 LVM 和 ZFS 的存储后端设置。
- `default.conf` specifies configuration which every newly created container should  contain. This usually contains at least a network section, and, for  unprivileged users, an id mapping section
   `default.conf` 指定每个新创建的容器应包含的配置。这通常至少包含一个网络部分，对于非特权用户，还包含一个 id 映射部分
- `lxc-usernet.conf` specifies how unprivileged users may connect their containers to the host-owned network.
   `lxc-usernet.conf` 指定非特权用户如何将其容器连接到主机拥有的网络。

`lxc.conf` and `default.conf` are both under `/etc/lxc` and `$HOME/.config/lxc`, while `lxc-usernet.conf` is only host-wide.
 `lxc.conf` 并且 `default.conf` 都在 和 `$HOME/.config/lxc` 下 `/etc/lxc` ，而 `lxc-usernet.conf` 只是在主机范围内。

By default, containers are located under /var/lib/lxc for the root user.
默认情况下，容器位于 root 用户的 /var/lib/lxc 下。

## Networking 联网

By default LXC creates a private network namespace for each container,  which includes a layer 2 networking stack. Containers usually connect to the outside world by either having a physical NIC or a veth tunnel  endpoint passed into the container. LXC creates a NATed bridge, lxcbr0,  at host startup. Containers created using the default configuration will have one veth NIC with the remote end plugged into the lxcbr0 bridge. A NIC can only exist in one namespace at a time, so a physical NIC passed into the container is not usable on the host.
默认情况下，LXC 会为每个容器创建一个专用网络命名空间，其中包括一个第 2 层网络堆栈。容器通常通过将物理 NIC 或 veth  隧道终结点传递到容器中来连接到外部世界。LXC 在主机启动时创建 NATed 网桥 lxcbr0。使用默认配置创建的容器将具有一个 veth  NIC，其远程端插入 lxcbr0 网桥。NIC 一次只能存在于一个命名空间中，因此传递到容器中的物理 NIC 在主机上不可用。

It is possible to create a container without a private network namespace.  In this case, the container will have access to the host networking like any other application. Note that this is particularly dangerous if the  container is running a distribution with upstart, like Ubuntu, since  programs which talk to init, like `shutdown`, will talk over the abstract Unix domain socket to the host’s upstart, and shut down the host.
可以在没有专用网络命名空间的情况下创建容器。在这种情况下，容器将像任何其他应用程序一样访问主机网络。请注意，如果容器运行的是带有 upstart（如 Ubuntu）的发行版，则这尤其危险，因为与 init 通信的程序（如 `shutdown` ）将通过抽象的 Unix 域套接字与主机的 upstart 进行通信，并关闭主机。

To give containers on lxcbr0 a persistent ip address based on domain name, you can write entries to `/etc/lxc/dnsmasq.conf` like:
要根据 domain name 为 lxcbr0 上的容器提供永久 IP 地址，您可以编写如下 `/etc/lxc/dnsmasq.conf` 条目：

```auto
dhcp-host=lxcmail,10.0.3.100
dhcp-host=ttrss,10.0.3.101
```

If it is desirable for the container to be publicly accessible, there are a few ways to go about it. One is to use `iptables` to forward host ports to the container, for instance
如果希望容器可公开访问，则有几种方法可以解决。例如，一种是用于 `iptables` 将主机端口转发到容器

```auto
iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 587 -j DNAT \
    --to-destination 10.0.3.100:587
```

Then, specify the host’s bridge in the container configuration file in place of lxcbr0, for instance
然后，在容器配置文件中指定主机的网桥来代替 lxcbr0，例如

```auto
lxc.network.type = veth
lxc.network.link = br0
```

Finally, you can ask LXC to use macvlan for the container’s NIC. Note that this  has limitations and depending on configuration may not allow the  container to talk to the host itself. Therefore the other two options  are preferred and more commonly used.
最后，您可以要求 LXC 将 macvlan 用于容器的 NIC。请注意，这有限制，并且根据配置的不同，可能不允许容器与主机本身通信。因此，其他两个选项是首选，并且更常用。

There are several ways to determine the ip address for a container. First, you can use `lxc-ls --fancy` which will print the ip addresses for all running containers, or `lxc-info -i -H -n C1` which will print C1’s ip address. If dnsmasq is installed on the host, you can also add an entry to `/etc/dnsmasq.conf` as follows
有几种方法可以确定容器的 IP 地址。首先，您可以使用哪个将打印所有正在运行的容器的 IP 地址，或者 `lxc-info -i -H -n C1` 哪个 `lxc-ls --fancy` 将打印 C1 的 IP 地址。如果主机上安装了 dnsmasq，您还可以添加一个条目， `/etc/dnsmasq.conf` 如下所示

```auto
server=/lxc/10.0.3.1
```

after which dnsmasq will resolve `C1.lxc` locally, so that you can do:
之后，DNSMASQ 将在本地解析 `C1.lxc` ，以便您可以执行以下操作：

```auto
ping C1
ssh C1
```

For more information, see the `lxc.conf(5)` manpage as well as the example network configurations under `/usr/share/doc/lxc/examples/`.
有关更多信息，请参见 `lxc.conf(5)` 手册页以及 `/usr/share/doc/lxc/examples/` 下的示例网络配置。

## LXC startup LXC 启动

LXC does not have a long-running daemon. However it does have three upstart jobs.
LXC 没有长时间运行的守护程序。然而，它确实有三个暴发户工作。

- `/etc/init/lxc-net.conf:` is an optional job which only runs if `/etc/default/lxc-net` specifies `USE_LXC_BRIDGE` (true by default). It sets up a NATed bridge for containers to use.
   `/etc/init/lxc-net.conf:` 是一个可选作业，仅在指定 `USE_LXC_BRIDGE` 时 `/etc/default/lxc-net` 运行（默认为 true）。它设置了一个 NAT 网桥供容器使用。
- `/etc/init/lxc.conf` loads the lxc apparmor profiles and optionally starts any autostart  containers. The autostart containers will be ignored if LXC_AUTO (true  by default) is set to true in `/etc/default/lxc`. See the lxc-autostart manual page for more information on autostarted containers.
   `/etc/init/lxc.conf` 加载 LXC AppArmor 配置文件，并选择性地启动任何自动启动容器。如果 中的 `/etc/default/lxc` LXC_AUTO（默认为 true）设置为 true，则将忽略自动启动容器。有关自动启动容器的更多信息，请参阅 lxc-autostart 手册页。
- `/etc/init/lxc-instance.conf` is used by `/etc/init/lxc.conf` to autostart a container.
   `/etc/init/lxc-instance.conf` 用于 `/etc/init/lxc.conf` 自动启动容器。

## Backing Stores 后备存储

LXC supports several backing stores for container root filesystems. The  default is a simple directory backing store, because it requires no  prior host customization, so long as the underlying filesystem is large  enough. It also requires no root privilege to create the backing store,  so that it is seamless for unprivileged use. The rootfs for a privileged directory backed container is located (by default) under `/var/lib/lxc/C1/rootfs`, while the rootfs for an unprivileged container is under `~/.local/share/lxc/C1/rootfs`. If a custom lxcpath is specified in `lxc.system.com`, then the container rootfs will be under `$lxcpath/C1/rootfs`.
LXC 支持容器根文件系统的多个后备存储。默认设置是一个简单的目录后备存储，因为它不需要事先进行主机自定义，只要底层文件系统足够大即可。它还不需要  root 权限即可创建后备存储，因此它对于非特权使用是无缝的。默认情况下，特权目录支持的容器的 rootfs 位于 下 `/var/lib/lxc/C1/rootfs` ，而非特权容器的 rootfs 位于 `~/.local/share/lxc/C1/rootfs` 下。如果在 中 `lxc.system.com` 指定了自定义 lxcpath，则容器 rootfs 将位于 `$lxcpath/C1/rootfs` 下。

A snapshot clone C2 of a directory backed container C1 becomes an overlayfs backed container, with a rootfs called `overlayfs:/var/lib/lxc/C1/rootfs:/var/lib/lxc/C2/delta0`. Other backing store types include loop, btrfs, LVM and zfs.
目录支持的容器 C1 的快照克隆 C2 将变成一个 overlayfs 支持的容器，其 rootfs 称为 `overlayfs:/var/lib/lxc/C1/rootfs:/var/lib/lxc/C2/delta0` .其他后备存储类型包括 loop、btrfs、LVM 和 zfs。

A btrfs backed container mostly looks like a directory backed container,  with its root filesystem in the same location. However, the root  filesystem comprises a subvolume, so that a snapshot clone is created  using a subvolume snapshot.
btrfs 支持的容器大多看起来像一个目录支持的容器，其根文件系统位于同一位置。但是，根文件系统包含一个子卷，因此使用子卷快照创建快照克隆。

The root filesystem for an LVM backed container can be any separate LV. The default VG name can be specified in lxc.conf. The filesystem type and  size are configurable per-container using lxc-create.
LVM 支持的容器的根文件系统可以是任何单独的 LV。默认的 VG 名称可以在 lxc.conf 中指定。文件系统类型和大小可使用 lxc-create 按容器配置。

The rootfs for a zfs backed container is a separate zfs filesystem, mounted under the traditional `/var/lib/lxc/C1/rootfs` location. The zfsroot can be specified at lxc-create, and a default can be specified in lxc.system.conf.
zfs 支持的容器的 rootfs 是一个单独的 zfs 文件系统，安装在传统 `/var/lib/lxc/C1/rootfs` 位置下。zfsroot 可以在 lxc-create 中指定，默认值可以在 lxc.system.conf 中指定。

More information on creating containers with the various backing stores can be found in the lxc-create manual page.
有关使用各种后备存储创建容器的更多信息，请参见 lxc-create 手册页。

## Templates 模板

Creating a container generally involves creating a root filesystem for the container. `lxc-create` delegates this work to *templates*, which are generally per-distribution. The lxc templates shipped with lxc can be found under `/usr/share/lxc/templates`, and include templates to create Ubuntu, Debian, Fedora, Oracle, centos, and gentoo containers among others.
创建容器通常涉及为容器创建根文件系统。 `lxc-create` 将这项工作委托给模板，这些模板通常是按发行版进行的。lxc 附带的 lxc 模板可以在 下 `/usr/share/lxc/templates` 找到，包括用于创建 Ubuntu、Debian、Fedora、Oracle、centos 和 gentoo 容器等的模板。

Creating distribution images in most cases requires the ability to create device nodes, often requires tools which are not available in other  distributions, and usually is quite time-consuming. Therefore lxc comes  with a special *download* template, which downloads pre-built container images from a central lxc server. The most important use case is to allow simple creation of  unprivileged containers by non-root users, who could not for instance  easily run the `debootstrap` command.
在大多数情况下，创建分发映像需要能够创建设备节点，通常需要其他分发版中没有的工具，并且通常非常耗时。因此，lxc 附带了一个特殊的下载模板，该模板从中央 lxc 服务器下载预构建的容器映像。最重要的用例是允许非 root  用户轻松创建非特权容器，例如，他们无法轻松运行该 `debootstrap` 命令。

When running `lxc-create`, all options which come after *–* are passed to the template. In the following command, *–name*, *–template* and *–bdev* are passed to `lxc-create`, while *–release* is passed to the template:
运行 `lxc-create` 时，后面的所有选项 – 都会传递给模板。在以下命令中，–name、–template 和 –bdev 传递给 `lxc-create` ，而 –release 传递给模板：

```auto
lxc-create --template ubuntu --name c1 --bdev loop -- --release DISTRO-SHORT-CODENAME
```

You can obtain help for the options supported by any particular container by passing *–help* and the template name to `lxc-create`. For instance, for help with the download template,
您可以通过将 –help 和模板名称传递给 `lxc-create` 来获取任何特定容器支持的选项的帮助。例如，有关下载模板的帮助，

```auto
lxc-create --template download --help
```

## Autostart 自动启动

LXC supports marking containers to be started at system boot. Prior to  Ubuntu 14.04, this was done using symbolic links under the directory `/etc/lxc/auto`. Starting with Ubuntu 14.04, it is done through the container configuration files. An entry
LXC 支持将容器标记为在系统启动时启动。在 Ubuntu 14.04 之前，这是使用目录下的符号链接完成的 `/etc/lxc/auto` 。从 Ubuntu 14.04 开始，它是通过容器配置文件完成的。一个条目

```auto
lxc.start.auto = 1
lxc.start.delay = 5
```

would mean that the container should be started at boot, and the system  should wait 5 seconds before starting the next container. LXC also  supports ordering and grouping of containers, as well as reboot and  shutdown by autostart groups. See the manual pages for lxc-autostart and lxc.container.conf for more information.
这意味着容器应该在启动时启动，系统应该等待 5 秒钟才能启动下一个容器。LXC 还支持容器的排序和分组，以及自动启动组的重启和关闭。有关更多信息，请参阅 lxc-autostart 和 lxc.container.conf 的手册页。

## Apparmor 阿帕莫尔

LXC ships with a default Apparmor profile intended to protect the host from accidental misuses of privilege inside the container. For instance, the container will not be able to write to `/proc/sysrq-trigger` or to most `/sys` files.
LXC 附带了一个默认的 Apparmor 配置文件，旨在保护主机免受容器内权限的意外滥用。例如，容器将无法写入 `/proc/sysrq-trigger` 或写入大多数 `/sys` 文件。

The `usr.bin.lxc-start` profile is entered by running `lxc-start`. This profile mainly prevents `lxc-start` from mounting new filesystems outside of the container’s root filesystem. Before executing the container’s `init`, `LXC` requests a switch to the container’s profile. By default, this profile is the `lxc-container-default` policy which is defined in `/etc/apparmor.d/lxc/lxc-default`. This profile prevents the container from accessing many dangerous paths, and from mounting most filesystems.
通过运行 `lxc-start` 来输入 `usr.bin.lxc-start` 配置文件。此配置文件主要防止 `lxc-start` 在容器的根文件系统之外挂载新文件系统。在执行容器的 `init` 之前， `LXC` 请求切换到容器的配置文件。默认情况下，此配置文件是在 中 `/etc/apparmor.d/lxc/lxc-default` 定义 `lxc-container-default` 的策略。此配置文件可防止容器访问许多危险路径，并阻止挂载大多数文件系统。

Programs in a container cannot be further confined - for instance, MySQL runs  under the container profile (protecting the host) but will not be able  to enter the MySQL profile (to protect the container).
容器中的程序不能进一步限制 - 例如，MySQL在容器配置文件下运行（保护主机），但无法进入MySQL配置文件（保护容器）。

`lxc-execute` does not enter an Apparmor profile, but the container it spawns will be confined.
 `lxc-execute` 不会进入 Apparmor 配置文件，但它生成的容器将被限制。

### Customizing container policies 自定义容器策略

If you find that `lxc-start` is failing due to a legitimate access which is being denied by its  Apparmor policy, you can disable the lxc-start profile by doing:
如果您发现 `lxc-start` 由于合法访问被其 Apparmor 策略拒绝而失败，您可以通过以下操作禁用 lxc-start 配置文件：

```auto
sudo apparmor_parser -R /etc/apparmor.d/usr.bin.lxc-start
sudo ln -s /etc/apparmor.d/usr.bin.lxc-start /etc/apparmor.d/disabled/
```

This will make `lxc-start` run unconfined, but continue to confine the container itself. If you  also wish to disable confinement of the container, then in addition to  disabling the `usr.bin.lxc-start` profile, you must add:
这将使 `lxc-start` 运行不受限制，但继续限制容器本身。如果您还希望禁用容器的限制，那么除了禁用 `usr.bin.lxc-start` 配置文件之外，还必须添加：

```auto
lxc.aa_profile = unconfined
```

to the container’s configuration file.
添加到容器的配置文件中。

LXC ships with a few alternate policies for containers. If you wish to run  containers inside containers (nesting), then you can use the  lxc-container-default-with-nesting profile by adding the following line  to the container configuration file
LXC 附带了一些容器的备用策略。如果您希望在容器内运行容器（嵌套），则可以通过将以下行添加到容器配置文件来使用 lxc-container-default-with-nesting 配置文件

```auto
lxc.aa_profile = lxc-container-default-with-nesting
```

If you wish to use libvirt inside containers, then you will need to edit that policy (which is defined in `/etc/apparmor.d/lxc/lxc-default-with-nesting`) by uncommenting the following line:
如果您希望在容器中使用 libvirt，则需要通过取消注释以下行来编辑该策略（在 `/etc/apparmor.d/lxc/lxc-default-with-nesting` 中定义）：

```auto
mount fstype=cgroup -> /sys/fs/cgroup/**,
```

and re-load the policy.
并重新加载策略。

Note that the nesting policy with privileged containers is far less safe  than the default policy, as it allows containers to re-mount `/sys` and `/proc` in nonstandard locations, bypassing apparmor protections. Unprivileged  containers do not have this drawback since the container root cannot  write to root-owned `proc` and `sys` files.
请注意，具有特权容器的嵌套策略远不如默认策略安全，因为它允许容器重新挂载 `/sys` 并在 `/proc` 非标准位置，绕过 apparmor 保护。非特权容器没有此缺点，因为容器根目录无法写入 root 用户拥有 `proc` 的文件。 `sys` 

Another profile shipped with lxc allows containers to mount block filesystem  types like ext4. This can be useful in some cases like maas  provisioning, but is deemed generally unsafe since the superblock  handlers in the kernel have not been audited for safe handling of  untrusted input.
lxc 附带的另一个配置文件允许容器挂载块文件系统类型，如 ext4。这在某些情况下（如 maas 配置）可能很有用，但通常被认为是不安全的，因为内核中的超级块处理程序尚未经过审计，无法安全处理不受信任的输入。

If you need to run a container in a custom profile, you can create a new profile under `/etc/apparmor.d/lxc/`. Its name must start with `lxc-` in order for `lxc-start` to be allowed to transition to that profile. The `lxc-default` profile includes the re-usable abstractions file `/etc/apparmor.d/abstractions/lxc/container-base`. An easy way to start a new profile therefore is to do the same, then add extra permissions at the bottom of your policy.
如果需要在自定义配置文件中运行容器，可以在 `/etc/apparmor.d/lxc/` 下创建新的配置文件。其名称必须以 开头 `lxc-` ，才能 `lxc-start` 被允许转换为该配置文件。该 `lxc-default` 配置文件包括可重用的抽象文件 `/etc/apparmor.d/abstractions/lxc/container-base` 。因此，启动新配置文件的一种简单方法是执行相同的操作，然后在策略底部添加额外权限。

After creating the policy, load it using:
创建策略后，使用以下命令加载策略：

```auto
sudo apparmor_parser -r /etc/apparmor.d/lxc-containers
```

The profile will automatically be loaded after a reboot, because it is sourced by the file `/etc/apparmor.d/lxc-containers`. Finally, to make container `CN` use this new `lxc-CN-profile`, add the following line to its configuration file:
重新启动后，配置文件将自动加载，因为它是由文件 `/etc/apparmor.d/lxc-containers` .最后，要使容器 `CN` 使用这个新 `lxc-CN-profile` 容器，请在其配置文件中添加以下行：

```auto
lxc.aa_profile = lxc-CN-profile
```

## Control Groups 控制组

Control groups (cgroups) are a kernel feature providing hierarchical task  grouping and per-cgroup resource accounting and limits. They are used in containers to limit block and character device access and to freeze  (suspend) containers. They can be further used to limit memory use and  block i/o, guarantee minimum cpu shares, and to lock containers to  specific cpus.
控制组 （cgroups） 是一种内核功能，提供分层任务分组和每个 cgroup  的资源核算和限制。它们在容器中用于限制块和字符设备访问以及冻结（挂起）容器。它们可以进一步用于限制内存使用和阻止 I/O，保证最小 CPU  份额，以及将容器锁定到特定的 CPU。

By default, a privileged container CN will be assigned to a cgroup called `/lxc/CN`. In the case of name conflicts (which can occur when using custom  lxcpaths) a suffix “-n”, where n is an integer starting at 0, will be  appended to the cgroup name.
默认情况下，特权容器 CN 将分配给名为 `/lxc/CN` 的 cgroup。在名称冲突的情况下（使用自定义 lxcpaths 时可能发生），后缀“-n”（其中 n 是从 0 开始的整数）将附加到 cgroup 名称中。

By default, a privileged container CN will be assigned to a cgroup called `CN` under the cgroup of the task which started the container, for instance `/usr/1000.user/1.session/CN`. The container root will be given group ownership of the directory (but  not all files) so that it is allowed to create new child cgroups.
默认情况下，特权容器 CN 将分配给在启动容器的任务的 cgroup 下调用 `CN` 的 cgroup，例如 `/usr/1000.user/1.session/CN` 。容器根目录将获得目录（但不是所有文件）的组所有权，以便允许它创建新的子 cgroups。

As of Ubuntu 14.04, LXC uses the cgroup manager (cgmanager) to administer  cgroups. The cgroup manager receives D-Bus requests over the Unix socket `/sys/fs/cgroup/cgmanager/sock`. To facilitate safe nested containers, the line
从 Ubuntu 14.04 开始，LXC 使用 cgroup 管理器 （cgmanager） 来管理 cgroup。cgroup 管理器通过 Unix 套接字接收 D-Bus 请求 `/sys/fs/cgroup/cgmanager/sock` 。为了便于安全嵌套容器，该行

```auto
lxc.mount.auto = cgroup
```

can be added to the container configuration causing the `/sys/fs/cgroup/cgmanager` directory to be bind-mounted into the container. The container in turn  should start the cgroup management proxy (done by default if the  cgmanager package is installed in the container) which will move the `/sys/fs/cgroup/cgmanager` directory to `/sys/fs/cgroup/cgmanager.lower`, then start listening for requests to proxy on its own socket `/sys/fs/cgroup/cgmanager/sock`. The host cgmanager will ensure that nested containers cannot escape  their assigned cgroups or make requests for which they are not  authorized.
可以添加到容器配置中，从而将 `/sys/fs/cgroup/cgmanager` 目录绑定装载到容器中。反过来，容器应该启动 cgroup 管理代理（如果容器中安装了 cgmanager 包，则默认执行），该代理会将 `/sys/fs/cgroup/cgmanager` 目录移动到 `/sys/fs/cgroup/cgmanager.lower` ，然后开始在自己的套接字上侦听代理请求 `/sys/fs/cgroup/cgmanager/sock` 。主机 cgmanager 将确保嵌套容器无法转义其分配的 cgroup 或发出未经授权的请求。

## Cloning 克隆

For rapid provisioning, you may wish to customize a canonical container  according to your needs and then make multiple copies of it. This can be done with the `lxc-clone` program.
为了快速预配，您可能希望根据需要自定义规范容器，然后创建该容器的多个副本。这可以通过 `lxc-clone` 程序来完成。

Clones are either snapshots or copies of another container. A copy is a new  container copied from the original, and takes as much space on the host  as the original. A snapshot exploits the underlying backing store’s  snapshotting ability to make a copy-on-write container referencing the  first. Snapshots can be created from btrfs, LVM, zfs, and directory  backed containers. Each backing store has its own peculiarities - for  instance, LVM containers which are not thinpool-provisioned cannot  support snapshots of snapshots; zfs containers with snapshots cannot be  removed until all snapshots are released; LVM containers must be more  carefully planned as the underlying filesystem may not support growing;  btrfs does not suffer any of these shortcomings, but suffers from  reduced fsync performance causing dpkg and apt to be slower.
克隆是另一个容器的快照或副本。副本是从原始容器复制的新容器，在主机上占用的空间与原始容器一样多。快照利用基础后备存储的快照功能，使写入时复制容器引用第一个容器。可以从 btrfs、LVM、zfs 和目录支持的容器创建快照。每个后备存储都有自己的特点 - 例如，未预配精简池的 LVM  容器不支持快照的快照;在释放所有快照之前，无法删除带有快照的 ZFS 容器;LVM  容器必须更仔细地规划，因为底层文件系统可能不支持增长;BTRFS 没有这些缺点，但 fsync 性能下降，导致 dpkg 和 apt 变慢。

Snapshots of directory-packed containers are created using the overlay  filesystem. For instance, a privileged directory-backed container C1  will have its root filesystem under `/var/lib/lxc/C1/rootfs`. A snapshot clone of C1 called C2 will be started with C1’s rootfs mounted readonly under `/var/lib/lxc/C2/delta0`. Importantly, in this case C1 should not be allowed to run or be removed while C2 is running. It is advised instead to consider C1 a *canonical* base container, and to only use its snapshots.
目录打包容器的快照是使用覆盖文件系统创建的。例如，特权目录支持的容器 C1 的根文件系统将位于 `/var/lib/lxc/C1/rootfs` 下。C1 的快照克隆 C2 将在 C1 的 rootfs 只读安装在 下 `/var/lib/lxc/C2/delta0` 启动。重要的是，在这种情况下，不应允许 C1 在 C2 运行时运行或删除。建议将 C1 视为规范基础容器，并仅使用其快照。

Given an existing container called C1, a copy can be created using:
给定一个名为 C1 的现有容器，可以使用以下命令创建副本：

```auto
sudo lxc-clone -o C1 -n C2
```

A snapshot can be created using:
可以使用以下方法创建快照：

```auto
sudo lxc-clone -s -o C1 -n C2
```

See the lxc-clone manpage for more information.
有关更多信息，请参见 lxc-clone 手册页。

### Snapshots 快照

To more easily support the use of snapshot clones for iterative container development, LXC supports *snapshots*. When working on a container C1, before making a potentially dangerous or hard-to-revert change, you can create a snapshot
为了更轻松地支持使用快照克隆进行迭代容器开发，LXC 支持快照。在处理容器 C1 时，在进行潜在危险或难以还原的更改之前，可以创建快照

```auto
sudo lxc-snapshot -n C1
```

which is a snapshot-clone called ‘snap0’ under /var/lib/lxcsnaps or  $HOME/.local/share/lxcsnaps. The next snapshot will be called ‘snap1’,  etc. Existing snapshots can be listed using `lxc-snapshot -L -n C1`, and a snapshot can be restored - erasing the current C1 container - using `lxc-snapshot -r snap1 -n C1`. After the restore command, the snap1 snapshot continues to exist, and  the previous C1 is erased and replaced with the snap1 snapshot.
这是在 /var/lib/lxcsnaps 或 $HOME/.local/share/lxcsnaps 下名为“snap0”的快照克隆。下一个快照将称为“snap1”，依此类推。可以使用 列出 `lxc-snapshot -L -n C1` 现有快照，并且可以使用 还原快照 - 擦 `lxc-snapshot -r snap1 -n C1` 除当前 C1 容器。在执行恢复命令后，snap1 快照将继续存在，并且之前的 C1 将被擦除并替换为 snap1 快照。

Snapshots are supported for btrfs, lvm, zfs, and overlayfs containers. If  lxc-snapshot is called on a directory-backed container, an error will be logged and the snapshot will be created as a copy-clone. The reason for this is that if the user creates an overlayfs snapshot of a  directory-backed container and then makes changes to the  directory-backed container, then the original container changes will be  partially reflected in the snapshot. If snapshots of a directory backed  container C1 are desired, then an overlayfs clone of C1 should be  created, C1 should not be touched again, and the overlayfs clone can be  edited and snapshotted at will, as such
btrfs、lvm、zfs 和 overlayfs 容器支持快照。如果在支持目录的容器上调用  lxc-snapshot，则会记录错误，并将快照创建为复制克隆。这样做的原因是，如果用户创建了目录支持的容器的 overlayfs  快照，然后对目录支持的容器进行了更改，则原始容器更改将部分反映在快照中。如果需要目录支持的容器 C1 的快照，则应创建 C1 的  overlayfs 克隆，不应再次触及 C1，并且可以随意编辑和快照 overlayfs 克隆

```auto
lxc-clone -s -o C1 -n C2
lxc-start -n C2 -d # make some changes
lxc-stop -n C2
lxc-snapshot -n C2
lxc-start -n C2 # etc
```

### Ephemeral Containers 临时容器

While snapshots are useful for longer-term incremental development of images, ephemeral containers utilize snapshots for quick, single-use throwaway  containers. Given a base container C1, you can start an ephemeral  container using
虽然快照对于图像的长期增量开发很有用，但临时容器将快照用于快速、一次性的一次性容器。给定一个基本容器 C1，您可以使用

```auto
lxc-start-ephemeral -o C1
```

The container begins as a snapshot of C1. Instructions for logging into the container will be printed to the console. After shutdown, the ephemeral container will be destroyed. See the lxc-start-ephemeral manual page  for more options.
容器以 C1 的快照开始。登录容器的说明将打印到控制台。关闭后，临时容器将被销毁。有关更多选项，请参阅 lxc-start-ephemeral 手册页。

## Lifecycle management hooks 生命周期管理挂钩

Beginning with Ubuntu 12.10, it is possible to define hooks to be executed at specific points in a container’s lifetime:
从 Ubuntu 12.10 开始，可以定义要在容器生命周期中的特定时间点执行的钩子：

- Pre-start hooks are run in the host’s namespace before the container ttys,  consoles, or mounts are up. If any mounts are done in this hook, they  should be cleaned up in the post-stop hook.
  在容器 tty、控制台或挂载启动之前，在主机的命名空间中运行预启动挂钩。如果在此挂钩中进行了任何安装，则应在停止后挂钩中清理它们。
- Pre-mount hooks are run in the container’s namespaces, but before the root  filesystem has been mounted. Mounts done in this hook will be  automatically cleaned up when the container shuts down.
  预挂载钩子在容器的命名空间中运行，但在挂载根文件系统之前运行。当容器关闭时，在此挂钩中完成的安装将自动清理。
- Mount hooks are run after the container filesystems have been mounted, but before the container has called `pivot_root` to change its root filesystem.
  挂载挂钩在挂载容器文件系统之后运行，但在容器调用 `pivot_root` 以更改其根文件系统之前运行。
- Start hooks are run immediately before executing the container’s init. Since  these are executed after pivoting into the container’s filesystem, the  command to be executed must be copied into the container’s filesystem.
  启动挂钩在执行容器的 init 之前立即运行。由于这些命令是在透视到容器的文件系统后执行的，因此必须将要执行的命令复制到容器的文件系统中。
- Post-stop hooks are executed after the container has been shut down.
  停止后钩子在容器关闭后执行。

If any hook returns an error, the container’s run will be aborted. Any *post-stop* hook will still be executed. Any output generated by the script will be logged at the debug priority.
如果任何挂钩返回错误，则容器的运行将被中止。任何停止后钩子仍将执行。脚本生成的任何输出都将记录在调试优先级下。

Please see the `lxc.container.conf(5)` manual page for the configuration file format with which to specify  hooks. Some sample hooks are shipped with the lxc package to serve as an example of how to write and use such hooks.
请参阅 `lxc.container.conf(5)` 手册页，了解用于指定钩子的配置文件格式。lxc 软件包附带了一些示例钩子，作为如何编写和使用此类钩子的示例。

## Consoles 机

Containers have a configurable number of consoles. One always exists on the container’s `/dev/console`. This is shown on the terminal from which you ran `lxc-start`, unless the *-d* option is specified. The output on `/dev/console` can be redirected to a file using the *-c console-file* option to `lxc-start`. The number of extra consoles is specified by the `lxc.tty` variable, and is usually set to 4. Those consoles are shown on `/dev/ttyN` (for 1 <= N <= 4). To log into console 3 from the host, use:
容器具有可配置数量的控制台。一个始终存在于容器的 `/dev/console` .这将显示在您运行 `lxc-start` 的终端上，除非指定了 -d 选项。可以使用 -c console-file 选项将 `lxc-start` 输出 `/dev/console` 重定向到文件。额外控制台的数量由 `lxc.tty` 变量指定，通常设置为 4。这些控制台显示在 `/dev/ttyN` （对于 1 <= N <= 4）。要从主机登录控制台 3，请使用：

```auto
sudo lxc-console -n container -t 3
```

or if the `-t N` option is not specified, an unused console will be automatically chosen. To exit the console, use the escape sequence `Ctrl-a q`. Note that the escape sequence does not work in the console resulting from `lxc-start` without the `-d` option.
或者，如果未指定该 `-t N` 选项，则将自动选择未使用的控制台。要退出控制台，请使用转义序列 `Ctrl-a q` 。请注意， `lxc-start` 如果没有该 `-d` 选项，转义序列在控制台中不起作用。

Each container console is actually a Unix98 pty in the host’s (not the guest’s) pty mount, bind-mounted over the guest’s `/dev/ttyN` and `/dev/console`. Therefore, if the guest unmounts those or otherwise tries to access the actual character device `4:N`, it will not be serving getty to the LXC consoles. (With the default  settings, the container will not be able to access that character device and getty will therefore fail.) This can easily happen when a boot  script blindly mounts a new `/dev`.
每个容器控制台实际上是主机（而不是客户机）的 pty 挂载中的 Unix98 pty，绑定挂载在 guest 的 `/dev/ttyN` 和 `/dev/console` 上。因此，如果客户机卸载这些设备或以其他方式尝试访问实际的角色设备 `4:N` ，它将不会向 LXC 控制台提供 getty。（使用默认设置，容器将无法访问该角色设备，因此 getty 将失败。当引导脚本盲目挂载新的 `/dev` .

## Troubleshooting 故障 排除

### Logging 伐木

If something goes wrong when starting a container, the first step should be to get full logging from LXC:
如果在启动容器时出现问题，第一步应该是从 LXC 获取完整日志记录：

```auto
sudo lxc-start -n C1 -l trace -o debug.out
```

This will cause lxc to log at the most verbose level, `trace`, and to output log information to a file called ‘debug.out’. If the file `debug.out` already exists, the new log information will be appended.
这将导致 lxc 在最详细的级别进行日志记录， `trace` 并将日志信息输出到名为“debug.out”的文件中。如果文件 `debug.out` 已存在，则将附加新的日志信息。

### Monitoring container status 监控容器状态

Two commands are available to monitor container state changes. `lxc-monitor` monitors one or more containers for any state changes. It takes a container name as usual with the *-n* option, but in this case the container name can be a posix regular  expression to allow monitoring desirable sets of containers. `lxc-monitor` continues running as it prints container changes. `lxc-wait` waits for a specific state change and then exits. For instance,
有两个命令可用于监视容器状态更改。 `lxc-monitor` 监视一个或多个容器的任何状态更改。它像往常一样使用 -n 选项采用容器名称，但在这种情况下，容器名称可以是 posix 正则表达式，以允许监视所需的容器集。 `lxc-monitor` 在打印容器更改时继续运行。 `lxc-wait` 等待特定状态更改，然后退出。例如

```auto
sudo lxc-monitor -n cont[0-5]*
```

would print all state changes to any containers matching the listed regular expression, whereas
将所有状态更改打印到与列出的正则表达式匹配的任何容器，而

```auto
sudo lxc-wait -n cont1 -s 'STOPPED|FROZEN'
```

will wait until container cont1 enters state STOPPED or state FROZEN and then exit.
将等到容器 cont1 进入状态 STOPPED 或状态 FROZEN 然后退出。

### Attach 附加

As of Ubuntu 14.04, it is possible to attach to a container’s namespaces. The simplest case is to simply do
从 Ubuntu 14.04 开始，可以附加到容器的命名空间。最简单的情况是简单地做

```auto
sudo lxc-attach -n C1
```

which will start a shell attached to C1’s namespaces, or, effectively inside  the container. The attach functionality is very flexible, allowing  attaching to a subset of the container’s namespaces and security  context. See the manual page for more information.
这将启动一个附加到 C1 命名空间的 shell，或者有效地在容器内。附加功能非常灵活，允许附加到容器命名空间和安全上下文的子集。有关详细信息，请参阅手册页。

### Container init verbosity 容器初始化详细程度

If LXC completes the container startup, but the container init fails to  complete (for instance, no login prompt is shown), it can be useful to  request additional verbosity from the init process. For an upstart  container, this might be:
如果 LXC 完成了容器启动，但容器 init 无法完成（例如，未显示登录提示），则从 init 进程请求额外的详细内容可能很有用。对于新贵容器，这可能是：

```auto
sudo lxc-start -n C1 /sbin/init loglevel=debug
```

You can also start an entirely different program in place of init, for instance
例如，您还可以启动一个完全不同的程序来代替 init

```auto
sudo lxc-start -n C1 /bin/bash
sudo lxc-start -n C1 /bin/sleep 100
sudo lxc-start -n C1 /bin/cat /proc/1/status
```

## LXC API LXC 接口

Most of the LXC functionality can now be accessed through an API exported by `liblxc` for which bindings are available in several languages, including Python, lua, ruby, and go.
现在，大多数 LXC 功能都可以通过导出 `liblxc` 的 API 进行访问，该 API 的绑定以多种语言提供，包括 Python、lua、ruby 和 go。

Below is an example using the python bindings (which are available in the  python3-lxc package) which creates and starts a container, then waits  until it has been shut down:
下面是一个使用 python 绑定（在 python3-lxc 包中提供）的示例，该绑定创建并启动一个容器，然后等待它关闭：

```auto
# sudo python3
Python 3.2.3 (default, Aug 28 2012, 08:26:03)
[GCC 4.7.1 20120814 (prerelease)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import lxc
__main__:1: Warning: The python-lxc API isn't yet stable and may change at any point in the future.
>>> c=lxc.Container("C1")
>>> c.create("ubuntu")
True
>>> c.start()
True
>>> c.wait("STOPPED")
True
```

## Security 安全

A namespace maps ids to resources. By not providing a container any id  with which to reference a resource, the resource can be protected. This  is the basis of some of the security afforded to container users. For  instance, IPC namespaces are completely isolated. Other namespaces,  however, have various *leaks* which allow privilege to be inappropriately exerted from a container into another container or to the host.
命名空间将 ID 映射到资源。通过不向容器提供任何用于引用资源的 ID，可以保护资源。这是为容器用户提供的一些安全性的基础。例如，IPC 命名空间是完全隔离的。但是，其他命名空间具有各种泄漏，允许将权限从一个容器不恰当地施加到另一个容器或主机。

By default, LXC containers are started under a Apparmor policy to restrict some actions. The details of AppArmor integration with lxc are in  section *Apparmor*. Unprivileged containers go further by mapping root in the container to an unprivileged host UID. This prevents access to `/proc` and `/sys` files representing host resources, as well as any other files owned by root on the host.
默认情况下，LXC 容器在 Apparmor 策略下启动，以限制某些操作。AppArmor 与 lxc 集成的详细信息在 Apparmor 部分。非特权容器通过将容器中的根映射到非特权主机 UID 来走得更远。这将阻止访问 `/proc` 表示 `/sys` 主机资源的文件，以及主机上 root 拥有的任何其他文件。

### Exploitable system calls 可利用的系统调用

It is a core container feature that containers share a kernel with the  host. Therefore if the kernel contains any exploitable system calls the  container can exploit these as well. Once the container controls the  kernel it can fully control any resource known to the host.
容器与主机共享内核是容器的核心功能。因此，如果内核包含任何可利用的系统调用，容器也可以利用这些调用。一旦容器控制了内核，它就可以完全控制主机已知的任何资源。

In general to run a full distribution container a large number of system  calls will be needed. However for application containers it may be  possible to reduce the number of available system calls to only a few.  Even for system containers running a full distribution security gains  may be had, for instance by removing the 32-bit compatibility system  calls in a 64-bit container. See the lxc.container.conf manual page for  details of how to configure a container to use seccomp. By default, no  seccomp policy is loaded.
通常，要运行完整的分发容器，需要大量的系统调用。但是，对于应用程序容器，可以将可用的系统调用次数减少到只有几个。即使对于运行完整分发的系统容器，也可以获得安全收益，例如通过删除 64 位容器中的 32 位兼容性系统调用。有关如何配置容器以使用 seccomp 的详细信息，请参见 lxc.container.conf  手册页。默认情况下，不加载任何 seccomp 策略。

## Resources 资源

- The DeveloperWorks article [LXC: Linux container tools](https://developer.ibm.com/tutorials/l-lxc-containers/) was an early introduction to the use of containers.
  DeveloperWorks 文章 LXC：Linux 容器工具是容器使用的早期介绍。
- The [Secure Containers Cookbook](http://www.ibm.com/developerworks/linux/library/l-lxc-security/index.html) demonstrated the use of security modules to make containers more secure.
  《安全容器手册》演示了如何使用安全模块使容器更加安全。
- The upstream LXC project is hosted at [linuxcontainers.org](http://linuxcontainers.org).
  上游 LXC 项目托管在 linuxcontainers.org。