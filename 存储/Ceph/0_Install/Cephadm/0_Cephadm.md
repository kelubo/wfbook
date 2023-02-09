# Cephadm

[TOC]

## Podman 版本兼容性

Podman 和 Ceph 有不同的生命终结策略。这意味着必须小心寻找与 Ceph 兼容的 Podman 版本。

| Ceph     | Podman |      |      |      |      |
| -------- | ------ | ---- | ---- | ---- | ---- |
|          | 1.9    | 2.0  | 2.1  | 2.2  | 3.0  |
| ≤ 15.2.5 | T      | F    | F    | F    | F    |
| ≥ 15.2.6 | T      | T    | T    | F    | F    |
| ≥ 16.2.1 | F      | T    | T    | F    | T    |

> **注意：**
>
> 只有 2.0.0 及更高版本的 Podman 可以与 Ceph Pacific 一起使用，但 Podman 版本 2.2.1 除外，它不适用于  Ceph Pacific。
>
> Kubic stable 可以与 Ceph Pacific 一起使用，但它必须使用较新的内核运行。

## 稳定性

Cephadm 正在开发中。某些功能不完整。请注意，Ceph 的某些组件可能无法与 Cephadm 完美配合。其中包括：

- RGW

Cephadm 对以下功能的支持仍在开发中：

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
dnf search release-ceph
#软件包名称会变，先查找一下具体名称。
dnf install --assumeyes centos-release-ceph-quincy
dnf install --assumeyes cephadm
 ```