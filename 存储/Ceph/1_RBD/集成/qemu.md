# Qemu

[TOC]

## 使用Qemu

官方Qemu已经支持librbd，使用Qemu创建镜像前需要安装工具。

```bash
apt-get install -y qemu-utils
```

## 创建镜像

使用`qemu-img`命令，注意目前RBD只支持raw格式镜像。

```bash
qemu-img create -f raw rbd:rbd/test_image3 1G
```

## 修改镜像大小

```bash
qemu-img resize rbd:rbd/test_image3 2G
```

## 查看镜像信息

```bash
qemu-img info rbd:rbd/test_image3
```

