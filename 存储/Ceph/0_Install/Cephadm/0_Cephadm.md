# Cephadm

[TOC]

## Podman 版本兼容性

Podman 和 Ceph 有不同的生命终结策略。这意味着必须小心寻找与 Ceph 兼容的 Podman 版本。

| Ceph     | Podman |      |      |      |      |       |
| -------- | ------ | ---- | ---- | ---- | ---- | ----- |
|          | 1.9    | 2.0  | 2.1  | 2.2  | 3.0  | > 3.0 |
| ≤ 15.2.5 | T      | F    | F    | F    | F    | F     |
| ≥ 15.2.6 | T      | T    | T    | F    | F    | F     |
| ≥ 16.2.1 | F      | T    | T    | F    | T    | T     |
| ≥ 17.2.0 | F      | T    | T    | F    | T    | T     |

> **注意：**
>
> 虽然并非所有 podman 版本都针对所有 Ceph 版本进行了主动测试，但将 podman 版本 3.0 或更高版本与Ceph Quincy 及更高版本配合使用时没有已知问题。
>
> 只有 2.0.0 及更高版本的 Podman 可以与 Ceph Pacific 一起使用，但 Podman 版本 2.2.1 除外，它不适用于  Ceph Pacific。
>
> Kubic stable 可以与 Ceph Pacific 一起使用，但它必须使用较新的内核运行。

## 稳定性

Cephadm 相对稳定，但仍在添加新功能。某些功能不完整。

Cephadm 对以下功能的支持仍在开发中：

- ceph-exporter 部署
- stretch mode integration
- monitoring stack（moving towards prometheus service discover and providing TLS向 prometheus 服务发现和提供 TLS ）
- RGW 多站点部署支持（目前需要大量手动步骤）
- cephadm 代理

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

以下这些安装 cephadm 的方法是互斥的。不要试图在一个系统上同时使用这两种方法。

> Note：
>
> cephadm 的最新版本基于源文件的编译。与早期版本的 Ceph 不同，从 Ceph 的 git 树中复制一个源文件并运行它是不够的。如果希望使用开发版本运行 cephadm ，应该创建自己的 cephadm 构建版本。

### curl-based installation

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

If you encounter any issues with running cephadm due to errors including the message `bad interpreter`,如果在运行 cephadm 时遇到任何问题，因为包括 bad interpreter 的错误，那么可能没有安装 Python 或正确版本的 Python 。cephadm 工具需要 Python 3.6 及以上版本。可以使用特定版本的 Python 手动运行 cephadm，方法是将已安装的 Python 版本作为命令前缀。举例来说：

```bash
python3.8 ./cephadm <arguments...>
```

脚本足以启动集群，但在主机上安装会很方便:

```bash
./cephadm add-repo --release reef
./cephadm install
```

### distribution-specific installations

一些 Linux 发行版可能已经包含了最新的 Ceph 包。

 ```bash
# Ubuntu
apt install -y cephadm

# Fedora
dnf -y install cephadm

# SUSE
zypper install -y cephadm

# CentOS 8 / Stream
dnf search release-ceph
#软件包名称会变，先查找一下具体名称。
dnf install --assumeyes centos-release-ceph-reef
dnf install --assumeyes cephadm
 ```