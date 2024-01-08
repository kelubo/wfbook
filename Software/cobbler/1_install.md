# 安装

[TOC]

## 概述

设置和运行 cobblerd 不是一件容易的事。需要了解 Apache2 配置（设置 SSL，虚拟主机和 Apache proxy 模块）。证书和一些服务器管理知识也是必需的。

Cobbler 可以通过几种不同的方式安装，通过每个发行版的打包系统或直接从源代码安装。

Cobbler 有明确的和可选的先决条件，基于想要使用的特性。

## 安装前准备

### SELinux

在开始使用 Cobbler 之前，禁用 SELinux 或将其设置为 “permissive” 模式可能会很方便，特别是如果不熟悉 SELinux 故障排除或修改 SELinux 策略时。Cobbler constantly evolves to assist in managing new system technologies, and the policy that ships with your OS can sometimes lag behind the feature-set we provide, resulting in AVC denials that break Cobbler’s functionality.Cobbler 不断发展以帮助管理新的系统技术，操作系统附带的策略有时会落后于我们提供的功能集，导致 AVC 拒绝破坏 Cobbler 的功能。

### Firewall

配置防火墙，开启TCP：80 端口、TCP：25151 端口、UDP：69 端口

禁用firewalld

### 软件包

请注意，通过软件包管理器（如 dnf / yum 或 apt ）安装这里的任何软件包，都可能需要大量的辅助软件包，在这里没有记录。软件包定义应该自动拉入这些软件包，并将它们安装，但是最好在安装 Cobbler 或其任何组件之前验证这些要求是否已经满足。

首先，Cobbler 需要 Python 。从 3.0.0 开始，需要 Python 3 。Cobbler 还需要安装以下软件包：

- 一个可以充当代理的 Web 服务器（如 Apache，Nginx 等）
- wget 或 curl
- createrepo_c
- xorriso
- Gunicorn
- python-cheetah
- python-dns
- python-requests
- python-distro
- python-netaddr
- python-librepo
- python-schema
- python-gunicorn
- PyYAML / python-yaml
- fence-agents
- rsync
- syslinux
- tftp-server / atftpd

在基于 dnf 的系统上，请安装： `dnf-plugins-core`

如果决定使用 LDAP 身份验证，请在任何情况下手动安装：

- python3-ldap (or via PyPi: ldap)

如果决定需要 Windows 自动安装支持，请手动安装：

- python-hivex
- python-pefile

如果在一个基于 apt 的系统上，如果 `aptsources` Python 模块可用，我们的操作可能更适合镜像检测。our operation may be better for mirror detection

Koan 可以与 Cobbler 分开安装。

Cobbler-web only has one other requirement besides Cobbler itself:

- Django / python-django

>Note：
>
>Not installing all required dependencies will lead to stacktraces in your Cobbler installation.
>
>不安装所有必需的依赖项将导致 Cobbler 安装中出现堆栈跟踪。

### Source

> Note：
>
> 请注意，在某些发行版上，python 包的名称不同。在基于 Debian 的系统上，所有名为 `something-devel` 的东西都被命名为 `something-dev` 。另外请记住，某些包的情况略有不同。

> Warning：
>
> It is your responsibility to adjust the package names to Python3.
>
> 一些发行版仍然有 Python 2 可用。您有责任将软件包名称调整为Python 3。

从源代码安装，需要以下附加软件：

- git
- make
- python3-devel (on Debian based distributions `python3-dev`)
- python3-Sphinx
- python3-coverage
- openssl

## 安装并启动相关服务

Cobbler 可通过本地打包系统安装到许多 Linux 变体上。然而，Cobbler 项目也为所有支持的发行版提供了软件包，这是首选的安装方法。

```bash
# 目前新系统，Fedora 37 、 CentOS 8 stream
# 配置epel源
dnf install epel-release
dnf module enable cobbler:3

# CentOS 7
yum -y install cobbler cobbler-web dhcp httpd debmirror pykickstart fence-agents xinetd tftp-server
# CentOS 8
dnf install epel-release
dnf module enable cobbler
dnf install cobbler
# CentOS 8 stream
dnf install cobbler cobbler-web yum-utils fence-agents pykickstart debmirror syslinux dhcp-server tftp-server dnf-plugins-core
# Fedora 37
dnf install cobbler
# openSUSE Tumbleweed | openSUSE Leap 15.x
zypper in cobbler

# CentOS 7
systemctl enable xinetd
systemctl start xinetd
systemctl enable dhcpd
systemctl start dhcpd
systemctl enable httpd
systemctl start httpd
systemctl enable cobblerd.service
systemctl start cobblerd.service
# CentOS 8 stream
systemctl enable --now dhcpd
systemctl enable --now httpd
systemctl enable --now tftp
systemctl enable --now cobblerd.service
```

### 软件包

我们将打包留给下游；这意味着必须检查发行版供应商提供的存储库。但是，为以下系统提供 docker 文件，

- Fedora 37
- openSUSE Leap 15.3
- openSUSE Tumbleweed
- Rocky Linux 8
- Debian 10 Buster
- Debian 11 Bullseye

which will give you packages which will work better then building from source yourself.这将给你给予软件包，这些软件包将比你自己从源代码构建更好地工作。

> Note：
>
> 如果你仔细看看我们的 `docker` 文件夹，可能会看到更多的文件夹和文件，但它们是用于测试或其他目的的。请忽略它们，此页面始终对齐并保持最新。this page is always aligned and up to date.

要构建包，需要在克隆的存储库的根文件夹中执行以下操作：

- Fedora 37: `./docker/rpms/build-and-install-rpms.sh fc37 docker/rpms/Fedora_37/Fedora37.dockerfile`
- CentOS 8: `./docker/rpms/build-and-install-rpms.sh el8 docker/rpms/CentOS_8/CentOS8.dockerfile`
- Debian 10: `./docker/debs/build-and-install-debs.sh deb10 docker/debs/Debian_10/Debian10.dockerfile`
- Debian 11: `./docker/debs/build-and-install-debs.sh deb11 docker/debs/Debian_11/Debian11.dockerfile`

在执行脚本后，应该有一个在构建过程中创建的 `root` 所拥有的文件夹。它被称为 `rpm-build` 或 `deb-build` 。在这些目录中，应该可以找到构建的包。它们显然是未签名的，因此将生成与该事实有关的警告。

### 来自源代码的软件包

对于某些平台，也可以直接从源代码树构建软件包。

### RPM

```bash
$ make rpms
... (lots of output) ...
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.src.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/koan-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-web-3.0.0-1.fc20.noarch.rpm
```

如您所见，Cobbler 的每个组件都输出一个 RPM 以及一个源 RPM 。此命令在运行 Fedora 20 的系统上运行，因此 RPM 名称中的 fc20，将根据运行的发行版而有所不同。

### DEB

要在基于 Debian 的系统上从源代码安装 Cobbler ，需要执行以下步骤（在 Debian Buster 上测试）：

```bash
$ a2enmod proxy
$ a2enmod proxy_http
$ a2enmod rewrite

$ ln -s /srv/tftp /var/lib/tftpboot

$ systemctl restart apache2
$ make debs
```

Change all `/var/www/cobbler` in `/etc/apache2/conf.d/cobbler.conf` to `/usr/share/cobbler/webroot/` Init script: 

将 `/etc/apache2/conf.d/cobbler.conf` 中的所有 `/var/www/cobbler` 更改为 `/usr/share/cobbler/webroot/`  Init 脚本：

- add Required-Stop line
- path needs to be `/usr/local/...` or fix the install location

### Multi-Build 多构建模式

在仓库根目录中有一个名为 `docker-compose.yml` 的文件。如果已经安装了 `docker-compose` ，可以使用它在一次运行中为多个发行版构建软件包。只需执行：

```bash
$ docker-compose up -d
```

一段时间后，所有容器都应该退出，你应该看到两个新的文件夹，分别是 `root` 所有的 `rpm-build` 和 `deb-build` 。剩下的 docker 容器是用来测试和玩的，如果你不需要这个游乐场，可以用以下方法清理：

```bash
$ docker-compose down
```

### Source

> Warning：
>
> Cobbler is not suited to be run outside of custom paths or being installed into a virtual environment. We are working hard to get there but it is not possible yet. If you try this and it works, please report to our GitHub repository and tell us what is left to support this conveniently.
>
> Cobbler 不适合在自定义路径之外运行或安装到虚拟环境中。我们正在努力实现这一目标，但目前还不可能。如果你尝试了这个方法，并且成功了，请向我们的GitHub仓库报告，并告诉我们还有什么可以方便地支持这个方法。

#### 安装

最新的源代码可以通过 git 获得：

```bash
$ git clone https://github.com/cobbler/cobbler.git
$ cd cobbler
```

release30 分支对应于 3.0.x 系列的正式发布版本。master 分支是发展系列The master branch is the development series。

从源代码构建时，请确保具有正确的先决条件。Makefile 使用一个名为 `distro_build_configs.sh` 的脚本来设置正确的环境变量。如果不使用 Makefile，请确保 source 它。

如果满足所有先决条件，可以使用以下命令安装 Cobbler：

```bash
$ make install
```

如果已经安装了 Cobbler（无论是通过软件包安装还是从旧的源代码树安装），此命令将重写系统上的所有配置文件。

要保留现有的配置文件、代码段和自动安装文件，请运行以下命令：

```bash
$ make devinstall
```

要安装 Cobbler，在两种情况下完成安装，请使用以下步骤：

1. 将 cobblerd 的 systemd service 文件从 `/etc/cobbler/cobblerd.service` 复制到systemd unit 目录（`/etc/systemd/system`）。
2. 安装 `python3-gunicorn` or the package responsible for your distro.或负责你的发行版的软件包。
3. 获取 systemd service 文件 `cobblerd-gunicorn-service` 并将其复制到 unit 目录中。
4. 启用 Apache2 的 proxy 模块 (`a2enmod proxy` 或其他类似的)。
5. 重启 Apache, `cobblerd` 和 `cobblerd-gunicorn` 。

根据发行版 FHS 实现，可能需要在 `cobblerd.service` 文件中将 `ExecStart` 从 `/usr/bin/cobblerd` 调整为 `/usr/local/bin/cobblerd` 。

请注意，我们没有将服务文件复制到正确的目录中，并且根据系统上二进制文件的位置，二进制文件的路径可能是错误的。手动执行此操作，然后应该可以正常运行。这同样适用于 Apache Web 服务器配置。

To install the Cobbler web GUI, use this command:

```
$ make webtest
```

This will do a full install, not just the web GUI. `make webtest` is a wrapper around `make devinstall`, so your configuration files will also be saved when running this command. Be adviced that we don’t copy the service file into the correct directory and that the path to the binary may be wrong depending on the location of the binary on your system. Do this manually and then you should be good to go. The same is valid for the Apache2 webserver config.

Also note that this is not enough to run Cobbler-Web. Cobbler web needs the directories `/usr/share/cobbler/web` with the file `cobbler.wsgi` in it. This is currently a manual step. Also remember to manually enter a value for `SECRET_KEY` in `settings.py` and copy that to above mentioned directory as well as the templates directory.

#### 卸载服务

1. 停止 `cobblerd` 和 `apache2` 守护进程。
2. 从以下路径中删除 Cobbler 相关文件：
   1. `/usr/lib/python3.x/site-packages/cobbler/`
   2. `/etc/apache2/`
   3. `/etc/cobbler/`
   4. `/etc/systemd/system/`
   5. `/usr/local/bin/`
   6. `/var/lib/cobbler/`
   7. `/var/log/cobbler/`
3. 执行 `systemctl daemon-reload` 。

## 重新定位安装位置

通常没有一个非常大的 `/var` 分区，这是 Cobbler 默认用于镜像安装树等的分区。

会注意到可以通过进入 `/etc/cobbler/settings` 来重新配置 webdir 的位置，但是这并不是最好的方法--especially as the packaging process does include some files and directories in the stock path. 尤其是打包过程中包含了一些文件和目录在 stock 路径中。这意味着，对于升级和类似的操作，会在某种程度上破坏一些东西。推荐的操作过程非常简单，相比尝试重新配置 Cobbler、Apache 配置、文件权限和 SELinux 规则。

1. 将 `/var/www/cobbler` 中的所有内容复制到另一个位置-例如， `/opt/cobbler_data`
2. Now just create a symlink or bind mount at `/var/www/cobbler` that points to `/opt/cobbler_data`.现在只需在/var/www/cobbler上创建一个指向/opt/cobbler_data的符号链接或绑定挂载。

如果决定通过 NFS 访问 Cobbler 的数据存储（不推荐），那么确实需要在 `/var/www/cobbler` 上挂载NFS，并将 SELinux 上下文作为参数传入，to mount versus the symlink以挂载符号链接。可能还需要处理与 rootsquash 相关的问题。However if you are making a mirror of a Cobbler server for a multi-site setup, mounting read only is OK there.但是，如果正在为多站点设置制作 Cobbler 服务器的镜像，则可以在那里安装只读。

另请注意： `/var/lib/cobbler` 不能存在于 NFS 上，因为这会干扰 Cobbler 对存储文件的锁定（“flock”）。as this interferes with locking (“flock”) Cobbler does around it’s storage files.
