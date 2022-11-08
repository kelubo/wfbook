# Cephadm

[TOC]

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