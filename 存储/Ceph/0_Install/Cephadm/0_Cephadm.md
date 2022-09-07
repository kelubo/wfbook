# Cephadm

[TOC]

cephadm 通过 SSH 将 MGR 守护进程连接到主机，实现部署和管理 Ceph 集群。MGR 能够添加、删除和更新 Ceph 容器。cephadm 不依赖于外部配置工具，如 Ansible , Rook 和 Salt 。

cephadm 管理 Ceph 集群的整个生命周期。这个周期从引导过程开始，cephadm 在单个节点上创建一个小型 Ceph 集群。此群集由一个 MON 和一个 MGR 组成。cephadm 然后使用编排接口（“day2”命令）扩展集群，添加所有主机并配置所有 Ceph 守护进程和服务。此生命周期的管理可以通过 Ceph CLI 或 dashboard（GUI）执行。

**功能：**

1. 引导一个新的集群。
2. launch a containerized shell with a working Ceph CLI。启动与 Ceph 命令行界面(CLI)搭配使用的容器化 shell。
3. 帮助调试容器化的 Ceph 守护进程。

**特性：**

- **将所有组件部署在容器中。**
- **与 Orchestrator API 紧密集成。** `Ceph`的`Orchestrator`界面在`cephadm`的开发过程中得到了广泛的发展，以匹配实现并清晰地抽象出`Rook`中存在的（略有不同）功能。最终结果是不管是看起来还是感觉都像`Ceph`的一部分。
- **不依赖管理工具。**
- **最小的操作系统依赖性。** `Cephadm`需要`Python 3`，`LVM`和`container runtime`（`Podman`或`Docker`）。
- **将群集彼此隔离。** 支持多个`Ceph`集群同时存在于同一主机上一直是一个比较小众的场景，但是确实存在，并且以一种健壮，通用的方式将集群彼此隔离，这使得测试和重新部署集群对于开发人员和用户而言都是安全自然的过程。
- **自动升级。** 一旦`Ceph`“拥有”自己的部署方式，它就可以以安全和自动化的方式升级`Ceph`。
- **从“传统”部署工具轻松迁移。** 

## Podman 兼容性

| Ceph      | Podman |      |      |      |      |
| --------- | ------ | ---- | ---- | ---- | ---- |
|           | 1.9    | 2.0  | 2.1  | 2.2  | 3.0  |
| <= 15.2.5 | T      | F    | F    | F    | F    |
| >= 15.2.6 | T      | T    | T    | F    | F    |
| >= 16.2.1 | F      | T    | T    | F    | T    |

> **注意：**
>
> 只有 2.0.0 及更高版本的 podman 可以与 Ceph Pacific 一起使用，但 podman 版本 2.2.1 除外，它不适用于  Ceph Pacific。众所周知，kubic stable 可以与 Ceph Pacific 一起使用，但它必须使用较新的内核运行。

## 稳定性

Cephadm 正在积极开发中。Please be aware that some functionality is still rough around the edges. 请注意，某些功能的边缘仍然很粗糙。Especially the following components are working with cephadm。特别是下面的组件是用cephadm工作的，但是文档没有我们想的那么完整，近期可能会有一些变化：

- RGW

Cephadm 对以下功能的支持仍在开发中，可能会在未来版本中看到重大变化：

- Ingress
- Cephadm exporter daemon
- cephfs-mirror

## 依赖

- Python 3
- Systemd
- Podman 或 Docker
- 时间同步 ( chrony 或 NTP )
- LVM2

```bash
# CentOS 7
yum install python3 docker
systemctl enable docker
systemctl start docker

# CentOS 8
yum install python3 podman
```

## 安装

### curl-based installation

```bash
# 多次测试，发现官方文档中带有--silent选项，下载不下来。可以去掉。另外，不太容易下载成功。此方法不建议。
curl --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
chmod +x cephadm
```

该脚本可以直接从当前目录运行:

```bash
./cephadm <arguments...>
```

脚本足以启动集群，但在主机上安装也很方便:

```bash
./cephadm add-repo --release quincy
./cephadm install
```

### distribution-specific installations

一些Linux发行版可能已经包含了最新的Ceph包。

 ```bash
# Ubuntu
apt install -y cephadm

# Fedora
dnf -y install cephadm

# SUSE
zypper install -y cephadm

# CentOS 8 / Stream
dnf install --assumeyes centos-release-ceph-quincy
dnf install --assumeyes cephadm
 ```