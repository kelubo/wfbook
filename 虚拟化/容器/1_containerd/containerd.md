# containerd

[TOC]

## 概述

An industry-standard container runtime with an emphasis on **simplicity**, **robustness** and **portability**
行业标准的容器运行时，强调**简单性**、**健壮性**和**可移植性**

**containerd** is available as a daemon for Linux and Windows. It manages the complete container lifecycle of its host system, from image transfer and storage to container execution and supervision to low-level storage to network  attachments and beyond.
**containerd** 可用作 Linux 和 Windows 的守护程序。它管理其主机系统的整个容器生命周期，从映像传输和存储到容器执行和监督，再到低级存储，再到网络附件等。

![](../../../Image/a/architecture_containerd.png)

## 特征

* OCI Image Spec support

- Image push and pull support
  图像推送和拉取支持
- Network primitives for creation, modification, and deletion of interfaces
  用于创建、修改和删除接口的网络原语
- Multi-tenant supported with CAS storage for global images
  支持多租户，为全局映像提供 CAS 存储

- OCI Runtime Spec support (aka runC)
  OCI 运行时规范支持（又名 runC）
- Container runtime and lifecycle support
  容器运行时和生命周期支持
- Management of network namespaces containers to join existing namespaces
  管理网络命名空间容器以加入现有命名空间

