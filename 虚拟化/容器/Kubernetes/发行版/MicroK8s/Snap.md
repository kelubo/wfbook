# Building the MicroK8s snap 构建 MicroK8s 快照

#### On this page 本页内容

​                                                [What you will need 您需要的内容](https://microk8s.io/docs/build-microk8s-snap#what-you-will-need)                                                      [Install LXD if required 如果需要，请安装 LXD](https://microk8s.io/docs/build-microk8s-snap#install-lxd-if-required)                                                      [Install Snapcraft 安装 Snapcraft](https://microk8s.io/docs/build-microk8s-snap#install-snapcraft)                                                      [Fetch the MicroK8s source
获取 MicroK8s 源码](https://microk8s.io/docs/build-microk8s-snap#fetch-the-microk8s-source)                                                      [Make modifications 进行修改](https://microk8s.io/docs/build-microk8s-snap#make-modifications)                                                      [Build the snap 构建快照](https://microk8s.io/docs/build-microk8s-snap#build-the-snap)                                                      [Install the snap 安装 snap](https://microk8s.io/docs/build-microk8s-snap#install-the-snap)                                                      [Iterate over changes 迭代更改](https://microk8s.io/docs/build-microk8s-snap#iterate-over-changes)                                                      [Building offline for air-gapped environments
离线构建气隙环境](https://microk8s.io/docs/build-microk8s-snap#building-offline-for-air-gapped-environments)                                                              

MicroK8s is usually distributed as a snap package, to make it easy to distribute and install securely across a range of operating systems. As MicroK8s  is completely open source, it is possible to modify or customise the  source and build your own snap.
MicroK8s 通常以 snap 包的形式分发，以便于在各种作系统之间安全地分发和安装。由于 MicroK8s 是完全开源的，因此可以修改或自定义源并构建您自己的快照。

### [What you will need 您需要的内容](https://microk8s.io/docs/build-microk8s-snap#what-you-will-need)

- Access to the internet (see section on oflline builds below)
  访问 Internet（请参阅下面的 oflline 构建部分）
- A working [LXD](https://documentation.ubuntu.com/lxd/) environment
  工作中的 [LXD](https://documentation.ubuntu.com/lxd/) 环境
- The latest version of [Snapcraft](https://snapcraft.io/docs/)
  最新版本的 [Snapcraft](https://snapcraft.io/docs/)

### [Install LXD if required 如果需要，请安装 LXD](https://microk8s.io/docs/build-microk8s-snap#install-lxd-if-required)

The Snapcraft build process makes use of an LXD container. This needs to be of a recent, snap-based distribution of LXD.
Snapcraft 构建过程使用 LXD 容器。这需要是最新的、基于 snap 的 LXD 发行版。
 Remove any previous versions of LXD/LXC (be sure to snapshot any running containers first!):
删除任何以前版本的 LXD/LXC（请务必先对任何正在运行的容器进行快照！

```bash
sudo apt-get remove lxd* -y
sudo apt-get remove lxc* -y
```

Then install the LXD snap package
然后安装 LXD snap 软件包

```bash
snap install lxd
```

… and initiate the LXD environment.
…并启动 LXD 环境。

```bash
lxd init
```

For more detailed install instructions, refer to the [LXD documentation](https://documentation.ubuntu.com/lxd/).
有关更详细的安装说明，请参阅 [LXD 文档](https://documentation.ubuntu.com/lxd/)。

### [Install Snapcraft 安装 Snapcraft](https://microk8s.io/docs/build-microk8s-snap#install-snapcraft)

Snapcraft is the tool which builds snap packages. For full installation instrctions, see the [Snapcraft overview](https://snapcraft.io/docs/snapcraft-overview), but for platforms which support snaps, it can be installed simply by running:
Snapcraft 是构建 snap 包的工具。有关完整的安装说明，请参阅 [Snapcraft 概述](https://snapcraft.io/docs/snapcraft-overview)，但对于支持 snap 的平台，只需运行以下命令即可安装：

```bash
sudo snap install snapcraft --classic
```

### [Fetch the MicroK8s source 获取 MicroK8s 源码](https://microk8s.io/docs/build-microk8s-snap#fetch-the-microk8s-source)

MicroK8s source code is located on [Github](https://github.com/canonical/microk8s). To fetch a local copy:
MicroK8s 源代码位于 [Github](https://github.com/canonical/microk8s) 上。要获取本地副本：

```bash
git clone http://github.com/canonical/microk8s
cd ./microk8s/
```

### [Make modifications 进行修改](https://microk8s.io/docs/build-microk8s-snap#make-modifications)

At this stage you can modify any of the code in the repo. Many  modifications may be limited to the ‘recipe’ used to build the snap -  the `snapcraft.yaml` file, which can be found in the `snap`directory. You should again refer to the Snapcraft documentation for the settings  found in this file. It is also useful to know there are a number of  variables which can be set to influence the build process, which can be  set either in the snapcraft.yaml file of the container itself - a list  of these can be found in the [build reference documentation](https://microk8s.io/docs/ref-build-env).
在此阶段，您可以修改 repo 中的任何代码。许多修改可能仅限于用于构建 snap 的 “配方” - `snapcraft.yaml` 文件，该文件可以在 `snap`目录中找到。您应该再次参考 Snapcraft 文档，了解此文件中的设置。知道有许多变量可以设置为影响构建过程也很有用，这些变量可以在容器本身的 snapcraft.yaml 文件中设置 - 这些变量的列表可以在[构建参考文档](https://microk8s.io/docs/ref-build-env)中找到。

### [Build the snap 构建快照](https://microk8s.io/docs/build-microk8s-snap#build-the-snap)

As mentioned there are many settings and options for using snapcraft. the  recommended method for building the MicroK8s snap is to use an LXD  container. You can initiate the build with the command:
如前所述，有许多设置和选项可用于使用 snapcraft。构建 MicroK8s 快照的推荐方法是使用 LXD 容器。您可以使用以下命令启动构建：

```bash
snapcraft --use-lxd
```

This will take some time as the build process fetches dependencies, stages  the ‘parts’ of the snap and creates the snap package itself. the snap  itself will be fetched from the build environment and placed in the  local project directory. Note that the LXD container used for building  will be stopped, but not deleted. This is in case there were any errors  or artefacts you may wish to inspect.
这将需要一些时间，因为构建过程会获取依赖项，暂存 snap 的“部分”并创建 snap 包本身。快照本身将从构建环境中获取并放置在本地项目目录中。请注意，用于构建的 LXD 容器将被停止，但不会被删除。这是为了以防万一您希望检查任何错误或伪影。

### [Install the snap 安装 snap](https://microk8s.io/docs/build-microk8s-snap#install-the-snap)

The snap can then be installed locally by using the ‘–dangerous’ option.  This is a safeguard to make sure the user is aware that the snap is not  signed by the snap store, and is not confined.
然后可以使用 '–dangerous' 选项在本地安装 snap。这是一种保护措施，可确保用户知道快照未由 snap 存储签名，并且不受限制。

```bash
sudo snap install microk8s_v1.27.3_amd64.snap
```

Note: You will not be able to install this snap if there is already a `microk8s`snap installed on your system.
注意：如果您的系统上已经安装了 `microk8s`快照，您将无法安装此快照。

### [Iterate over changes 迭代更改](https://microk8s.io/docs/build-microk8s-snap#iterate-over-changes)

When you are done testing the changes you have made, you can remove the snap:
测试完所做的更改后，您可以删除捕捉：

```bash
sudo snap remove microk8s
```

If you wish you can then make further changes. As noted previously, the  LXD container used for building is not removed and will be reused by  subsequent build instructions. When you are satisfied it is no longer  needed, this container can be removed:
如果您愿意，您可以进行进一步的更改。如前所述，用于构建的 LXD 容器不会被删除，后续构建指令将重复使用。当您满意不再需要它时，可以删除此容器：

```bash
lxc delete snapcraft-microk8s
```

## [Building offline for air-gapped environments 离线构建气隙环境](https://microk8s.io/docs/build-microk8s-snap#building-offline-for-air-gapped-environments)

A common use case is where MicroK8s is used in an airgapped or offline  environment. To be able to build the MicroK8s snap in that environment  requires that the source for the snap and all dependencies are  available, many of which are normally fetched from online resources.
一个常见的用例是在离线或离线环境中使用 MicroK8s。为了能够在该环境中构建 MicroK8s 快照，需要快照的源和所有依赖项都可用，其中许多依赖项通常从在线资源中获取。

In this scenario, it is usually simplest to run through the above steps on a computer which does have access to these resources, and then transfer them to the environment where the build is to be made (following  whatever normal procedures are required in the environment to declare  these resources ‘safe’).
在这种情况下，通常最简单的方法是在可以访问这些资源的计算机上运行上述步骤，然后将它们传输到要进行生成的环境（遵循环境中声明这些资源“安全”所需的任何正常过程）。

This directory can then be examined and copied to the offline environment.  Please note that disconnecting from the source in this way obviously  means you will not receive any, possibly important, updates. See also  the documentation for [installing in an offline environment](https://microk8s.io/docs/install-offline)
然后，可以检查此目录并将其复制到脱机环境。请注意，以这种方式断开与源的连接显然意味着您将不会收到任何可能重要的更新。另请参阅在[离线环境中安装](https://microk8s.io/docs/install-offline)的文档

# Snap refreshes 快照刷新

#### On this page 本页内容

​                                                [Handling refreshes 处理刷新](https://microk8s.io/docs/snap-refreshes#handling-refreshes)                                                              

[Snaps](https://snapcraft.io/about) are app packages for desktop, cloud and IoT that are easy to install,  secure, cross‐platform and dependency‐free and is the preferred way of  installing MicrK8s.
[Snap](https://snapcraft.io/about) 是适用于桌面、云和 IoT 的应用程序包，易于安装、安全、跨平台且无依赖性，是安装 MicrK8s 的首选方式。

The channel specified during installation receives regular updates that include:
安装期间指定的通道将接收定期更新，其中包括：

- Kubernetes patch releases
  Kubernetes 补丁版本
- Regression, bug and security fixes
  回归、错误和安全修复

Consider the case of an installation following the v1.27 release:
请考虑 v1.27 版本之后的安装情况：

```auto
snap install microk8s --classic --channel 1.27/stable
```

At regular intervals, the MicroK8s team releases new snap revisions with  Kubernetes patches (ie 1.27.1, 1.27.2, etc), updates to the Kubernetes  dependencies and any fixes to the add-ons. Such snap refreshes are  available to the 1.27 clusters and by default are applied automatically  with no user notification.
MicroK8s 团队会定期发布带有 Kubernetes 补丁（即 1.27.1、1.27.2 等）、Kubernetes 依赖项更新以及附加组件的任何修复的新快照修订版。此类快速刷新可用于 1.27 集群，默认情况下会自动应用，无需用户通知。

Use the `snap changes` and `snap change <change-id>` commands to see details on what changed during the last refresh. Refer to the [Snap documentation](https://snapcraft.io/docs/keeping-snaps-up-to-date#heading--changes) for more details.
使用 `snap changes` 和 `snap change <change-id>` 命令可查看上次刷新期间更改内容的详细信息。请参阅 [Snap 文档](https://snapcraft.io/docs/keeping-snaps-up-to-date#heading--changes) 以了解更多详细信息。

### [ Handling refreshes 处理刷新](https://microk8s.io/docs/snap-refreshes#handling-refreshes)

By default, snaps check for updates once every six hours. In the event of a new release, MicroK8s automatically refreshes to the latest revision  within the followed channel. However, there are some scenarios where it  may be inconvenient or difficult to refresh the current snap. For those  cases the following options are available:
默认情况下，快照每 6 小时检查一次更新。如果有新版本，MicroK8s 会自动刷新到后续频道中的最新版本。但是，在某些情况下，刷新当前快照可能不方便或困难。对于这些情况，可以使用以下选项：

#### Scheduling snap refreshes at convenient times 在方便的时候安排快照刷新

The `refresh-timer`  setting can be used to configure the *global* refresh schedule for all snaps. The following example sets the refresh  window from 22:00 to 23:00 on the last Friday of the month:
`该 refresh-timer` 设置可用于配置所有快照的*全局*刷新计划。以下示例将刷新时段设置为每月最后一个星期五的 22：00 到 23：00：

```auto
snap set system refresh.timer=fri5,22:00-23:00
```

For more details on the `refresh-timer` option refer to the Snap documentation page on [controlling updates](https://snapcraft.io/docs/keeping-snaps-up-to-date).
有关 `refresh-timer` 选项的更多详细信息，请参阅有关[控制更新的](https://snapcraft.io/docs/keeping-snaps-up-to-date) Snap 文档页面。

#### Block and/or filter out revisions 阻止和/或筛选出修订

Placing a store proxy in front of a  MicroK8s deployment allows new snap  revisions to be ‘held’ while they undergo testing and skipping them if  deemed harmful. Please refer to our [Snap Store Proxy How to page](https://microk8s.io/docs/manage-upgrades-with-a-snap-store-proxy) for detailed instructions on setting up a proxy.
将 store 代理放在 MicroK8s 部署之前，可以在新的快照修订版接受测试时“保留”，如果认为有害，则跳过它们。请参阅我们的 [Snap Store 代理作方法页面](https://microk8s.io/docs/manage-upgrades-with-a-snap-store-proxy)，了解有关设置代理的详细说明。