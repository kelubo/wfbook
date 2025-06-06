# Cephadm

[TOC]

## Podman 版本兼容性

Podman 和 Ceph 有不同的生命周期终止策略。这意味着必须小心寻找与 Ceph 兼容的 Podman 版本。

<table border="1">
    <tr>
        <th rowspan="2">Ceph</th>
        <th colspan="6">Podman</th>
    </tr>
    <tr>
        <td>1.9</td>
        <td>2.0</td>
        <td>2.1</td>
        <td>2.2</td>
        <td>3.0</td>
        <td>>3.0</td>
    </tr>
    <tr>
        <td>≤ 15.2.5</td>
        <td>T</td>
        <td>F</td>
        <td>F</td>
        <td>F</td>
        <td>F</td>
        <td>F</td>
    </tr>
    <tr>
        <td>≥ 15.2.6</td>
        <td>T</td>
        <td>T</td>
        <td>T</td>
        <td>F</td>
        <td>F</td>
        <td>F</td>
    </tr>
    <tr>
        <td>≥ 16.2.1</td>
        <td>F</td>
        <td>T</td>
        <td>T</td>
        <td>F</td>
        <td>T</td>
        <td>T</td>
    </tr>
    <tr>
        <td>≥ 17.2.0</td>
        <td>F</td>
        <td>T</td>
        <td>T</td>
        <td>F</td>
        <td>T</td>
        <td>T</td>
    </tr>
</table>

> **注意：**
>
> 虽然并非所有 podman 版本都针对所有 Ceph 版本进行了主动测试，但将 podman 3.0 或更高版本与 Ceph Quincy 及更高版本配合使用时，没有已知问题。
>
> 只有 2.0.0 及更高版本的 Podman 可以与 Ceph Pacific 一起使用，但 Podman 版本 2.2.1 除外，它不适用于  Ceph Pacific 。
>
> Kubic stable 可以与 Ceph Pacific 一起使用，但它必须使用较新的内核运行。

## 稳定性

Cephadm 相对稳定，但仍在添加新功能，偶尔会发现一些错误。如果发现问题，请在 Orchestrator 组件下打开跟踪器问题（https：//tracker.ceph.com/projects/Orchestrator/issues）。

Cephadm 对以下功能的支持仍在开发中：

- ceph-exporter 部署
- stretch mode integration 拉伸模式集成
- monitoring stack（moving towards prometheus service discover and providing TLS向 prometheus 服务发现和提供 TLS ）
- RGW 多站点部署支持（目前需要大量手动步骤）
- cephadm 代理

## 依赖

- Python 3
- Systemd
- Podman 或 Docker
- 时间同步 ( Chrony 或 ntpd )
- 用于配置存储设备的 LVM2

```bash
# CentOS 7
yum install python3 docker
systemctl enable docker
systemctl start docker

# CentOS 8
yum install python3 podman
```

## 安装

安装 cephadm 时，有两个关键步骤：首先，需要获取 cephadm 的初始副本，然后，第二步是确保拥有最新的 cephadm。有两种方法可以获取初始 `cephadm`：

1. [特定于发行版的安装方法](https://docs.ceph.com/en/latest/cephadm/install/#cephadm-install-distros)
2. [基于 curl 的安装](https://docs.ceph.com/en/latest/cephadm/install/#cephadm-install-curl)方法

> 这些安装 cephadm 的方法是互斥的。不要试图在一个系统上同时使用这两种方法。

> Note：
>
> 最新版本的 cephadm 作为从源代码编译的可执行文件分发。与早期版本的 Ceph 不同，从 Ceph 的 git  树中复制单个脚本并运行它已经不够了。如果希望使用开发版本运行 cephadm ，应该创建自己的 cephadm 构建版本。

### 使用 curl 安装

首先，确定需要的 Ceph 版本。

使用 `curl` 获取该版本的 cephadm 构建版本。

```bash
# 多次测试，发现官方文档中带有--silent选项，下载不下来。可以去掉。另外，不太容易下载成功。此方法不建议。
CEPH_RELEASE=18.2.0
curl --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
chmod +x cephadm
```

该脚本可以直接从当前目录运行:

```bash
./cephadm <arguments...>
```

如果在运行 cephadm 时遇到任何问题，因为包括 `bad interpreter` 信息的错误，那么可能没有安装 Python 或正确版本的 Python 。cephadm 工具需要 Python 3.6 及以上版本。可以使用特定版本的 Python 手动运行 cephadm，方法是将已安装的 Python 版本作为命令前缀。举例来说：

```bash
python3.8 ./cephadm <arguments...>
```

脚本足以启动集群，但在主机上安装会很方便:

```bash
./cephadm add-repo --release squid
./cephadm install
```

### 特定于发行版的安装

一些 Linux 发行版可能已经包含了最新的 Ceph 包。在这种情况下，您可以直接安装 cephadm 。

 ```bash
# Ubuntu
apt install -y cephadm

# Fedora
dnf -y install cephadm

# SUSE
zypper install -y cephadm

# CentOS Stream
dnf search release-ceph
#软件包名称会变，先查找一下具体名称。
dnf install --assumeyes centos-release-ceph-squid
dnf install --assumeyes cephadm
 ```