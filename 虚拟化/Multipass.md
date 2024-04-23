# Multipass

[TOC]

It’s  designed for developers who want a fresh Ubuntu environment with a  single command
Multipass 是在 Ubuntu 上创建 Ubuntu VM 的推荐方法。它专为希望使用单个命令的全新 Ubuntu 环境的开发人员而设计，适用于 Linux、Windows 和 macOS。

在 Linux 上，它以 snap 的形式提供：

```bash
sudo snap install multipass
```

如果运行的是未预安装 `snapd` 的旧版本的 Ubuntu ，则需要先安装它：

```bash
sudo apt update
sudo apt install snapd
```

## 查找可用 image

要查找可用的图像 image，可以使用以下 `multipass find` 命令，该命令将生成如下列表：

```bash
Image                       Aliases           Version          Description
snapcraft:core18            18.04             20201111         Snapcraft builder for Core 18
snapcraft:core20            20.04             20210921         Snapcraft builder for Core 20
snapcraft:core22            22.04             20220426         Snapcraft builder for Core 22
snapcraft:devel                               20221128         Snapcraft builder for the devel series
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
18.04                       bionic            20221117         Ubuntu 18.04 LTS
20.04                       focal             20221115.1       Ubuntu 20.04 LTS
22.04                       jammy,lts         20221117         Ubuntu 22.04 LTS
22.10                       kinetic           20221101         Ubuntu 22.10
daily:23.04                 devel,lunar       20221127         Ubuntu 23.04
appliance:adguard-home                        20200812         Ubuntu AdGuard Home Appliance
appliance:mosquitto                           20200812         Ubuntu Mosquitto Appliance
appliance:nextcloud                           20200812         Ubuntu Nextcloud Appliance
appliance:openhab                             20200812         Ubuntu openHAB Home Appliance
appliance:plexmediaserver                     20200812         Ubuntu Plex Media Server Appliance
anbox-cloud-appliance                         latest           Anbox Cloud Appliance
charm-dev                                     latest           A development and testing environment for charmers
docker                                        latest           A Docker environment with Portainer and related tools
jellyfin                                      latest           Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
minikube                                      latest           minikube is local Kubernetes
```

## 启动 Ubuntu Jammy （22.04） LTS 的新实例

可以通过指定列表中的映像名称（在本例中为 22.04）或使用别名（如果映像有别名）来启动新实例。

```bash
$ multipass launch 22.04
Launched: cleansing-guanaco
```

此命令等效于： `multipass launch jammy` 或 `multipass launch lts` 在上面的列表中。它将基于指定的 image 启动一个实例，并为其提供一个随机名称 - 在本例中为 `cleansing-guanaco` .

## 查看正在运行的实例

可以使用“multipass list”命令签出当前正在运行的实例：

```bash
$ multipass list                                                  
Name                    State             IPv4             Image
cleansing-guanaco       Running           10.140.26.17     Ubuntu 22.04 LTS
```

## 详细了解刚刚启动的 VM 实例

可以使用该 `multipass info` 命令查找有关 VM 实例参数的更多详细信息：

```bash
$ multipass info cleansing-guanaco 
Name:           cleansing-guanaco
State:          Running
IPv4:           10.140.26.17
Release:        Ubuntu 22.04.1 LTS
Image hash:     dc5b5a43c267 (Ubuntu 22.04 LTS)
Load:           0.45 0.19 0.07
Disk usage:     1.4G out of 4.7G
Memory usage:   168.3M out of 969.5M
Mounts:         --
```

## 连接到正在运行的实例

若要进入创建的 VM，请使用以下 `shell` 命令：

```bash
$ multipass shell cleansing-guanaco 
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-53-generic x86_64)
(...)
ubuntu@cleansing-guanaco:~$ 
```

### 断开与实例的连接

or you may find yourself heading all the way down the Inception levels…
完成后不要忘记注销（或 Ctrl + D ），否则您可能会发现自己一路走下 Inception 级别......

## Run commands inside an instance from outside 从外部在实例内部运行命令

```bash
$ multipass exec cleansing-guanaco -- lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 22.04.1 LTS
Release:	22.04
Codename:	jammy
```

## 停止或启动实例

可以使用以下 `stop` 命令停止实例以保存资源：

```bash
$ multipass stop cleansing-guanaco
```

可以使用以下 `start` 命令再次启动它：

```bash
$ multipass start cleansing-guanaco
```

## 删除实例

完成实例后，可以按如下方式将其删除：

```bash
$ multipass delete cleansing-guanaco
```

现在，当您使用以下 `list` 命令时，它将显示为已删除：

```bash
$ multipass list
Name                    State             IPv4             Image
cleansing-guanaco       Deleted           --               Not Available
```

当想完全摆脱它（以及任何其他已删除的实例）时，您可以使用以下 `purge` 命令：

```bash
$ multipass purge
```

可以使用以下方法 `list` 再次检查：

```bash
$ multipass list
No instances found.
```

## 与虚拟化的其余部分集成

可能已经有了其他基于 libvirt 的虚拟化，无论是通过使用类似的旧 uvtool 还是通过更常见的 virt-manager。

例如，可能希望这些 guest 位于同一桥上以相互通信，或者由于某种原因需要访问图形输出。

幸运的是，可以通过使用 Multipass 的 libvirt 后端来集成它：

```bash
$ sudo multipass set local.driver=libvirt
```

现在，当启动 guest 时，还可以通过 virt-manager 或 `virsh` 工具访问它：

```bash
$ multipass launch lts
Launched: engaged-amberjack 

$ virsh list
 Id    Name                           State
----------------------------------------------------
 15    engaged-amberjack              running
```

## 获取帮助

可以在 CLI 上使用以下命令：

```bash
multipass help
multipass help <command>
multipass help --all
```