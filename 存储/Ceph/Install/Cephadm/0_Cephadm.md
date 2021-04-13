# Cephadm

[TOC]

cephadm 通过SSH将管理器守护进程连接到主机，实现部署和管理Ceph集群。管理守护进程能够添加、删除和更新Ceph容器。cephadm 不依赖于外部配置工具，如Ansible, Rook和Salt。

cephadm 管理Ceph集群的整个生命周期。生命周期开始于引导过程，当cephadm 在单个节点上创建一个微小的Ceph集群。这个集群由一个MON和一个Mgr组成。然后，' cephadm '使用业务流程接口(“day 2”命令)扩展集群，添加所有主机并发放所有Ceph守护进程和服务。这个生命周期的管理可以通过Ceph命令行界面(CLI)或仪表板(GUI)来执行。

Cephadm是Octopus版本中的新功能。

**功能：**

1. 引导一个新的集群
2. 使用运行的Ceph CLI启动一个容器化的shell
3. 帮助调试容器化的Ceph守护进程

**特性：**

- **将所有组件部署在容器中。**
- **与Orchestrator API紧密集成。** `Ceph`的`Orchestrator`界面在`cephadm`的开发过程中得到了广泛的发展，以匹配实现并清晰地抽象出`Rook`中存在的（略有不同）功能。最终结果是不管是看起来还是感觉都像`Ceph`的一部分。
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

## 稳定性

well-supported:

- Monitors
- Managers
- OSDs
- CephFS file systems
- rbd-mirror

documentation is not complete:

- RGW
- dmcrypt OSDs

under development:

- NFS
- iSCSI

## 依赖

- Python 3
- Systemd
- Podman 或 Docker
- 时间同步 (chrony 或 NTP)
- LVM2 for provisioning storage devices

## 安装

### curl-based installation

```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm
chmod +x cephadm
```

该脚本可以直接从当前目录运行:

```bash
./cephadm <arguments...>
```

尽管脚本足以启动集群，但在主机上安装也很方便:

```bash
./cephadm add-repo --release pacific
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
 ```

如果遇到问题，您可以随时通过以下方式暂停cephadm:

```bash
ceph orch pause
```

或使用以下方法完全关闭cephadm

```bash
ceph orch set backend ''
ceph mgr module disable cephadm
```





