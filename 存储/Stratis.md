# Stratis

[TOC]

## 概述

Stratis 是基于 XFS 和 LVM 的组合构建的卷管理器。Stratis 的目的是模拟卷管理文件系统（如 Btrfs 和 ZFS）所提供的功能。可以手动构建此堆栈，但 Stratis 可减少配置的复杂度、实施最佳实践并整合错误信息。

可以在隐藏用户复杂性的同时执行重要的存储管理操作：

- 卷管理
- 创建池
- 精简存储池
- 快照
- 自动读取缓存

Stratis 提供强大的功能，但目前缺乏其他产品（如 Btrfs 或 ZFS）的某些功能。最值得注意的是，它不支持带自我修复的 CRC。

![](../Image/s/stratis.png)

Stratis使用存储的元数据来识别所管理的池、卷和文件系统。绝不应该对Stratis创建的文件系统进行手动重新格式化或重新配置；只应使用Stratis工具和命令对他们进行管理。手动配置Stratis文件系统可能会导致该元数据丢失，并阻止Stratis识别它已创建的文件系统。

每个池最多可以创建2^24个文件系统。

## 安装

```bash
yum install stratis-cli stratisd

systemctl enable --now stratisd
```

## 使用

每个池都是 `/stratis` 目录下的一个子目录。

```bash
# 创建存储池，可以多个设备
stratis pool create pool01 /dev/vdb

# 查看可用池的列表
stratis pool list

# 向池中添加额外的块设备
stratis pool add-data pool01 /dev/vdc

# 查看池的块设备
stratis blockdev list pool01

# 创建动态、灵活的文件系统
stratis filesystem create pool01 filesystem01
# 文件系统的链接位于 /stratis/pool01 目录中

# 创建文件系统快照
stratis filesystem snapshot pool01 filesystem01 snapshot01

# 销毁文件系统或文件系统快照
stratis filesystem destroy filesystem01 snapshot01

# 查看可用文件系统列表
stratis filesystem list
```

## 持久性挂载

```bash
lsblk --output=UUID /stratis/pool01/filesystem01

/etc/fstab
UUID=23b6...8ce2 /dir1 xfs defaults,x-systemd.requires=stratisd.service 0 0
# 未使用x-systemd.requires=stratisd.service挂载选项，会导致计算机在下一次重启时引导至emergency.target。
```

