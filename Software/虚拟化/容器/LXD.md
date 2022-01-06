# LXD
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
