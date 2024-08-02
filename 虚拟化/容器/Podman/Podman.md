# Podman

[TOC]

## 概述

http://podman.io/

Podman 是一个开源容器、Pod 和容器镜像管理引擎。Seamlessly work with containers and Kubernetes from your local environment.从本地环境无缝处理容器和 Kubernetes。

Podman 使查找、运行、构建和共享容器变得容易。

Podman 是作为 libpod 库的一部分提供的实用程序。

* 又快又轻。

- Our UI is  reactive and light on resource usage and won't drag you down.无守护进程，使用最快的技术带来快速的体验。我们的用户界面是反应式的，对资源使用量轻，不会拖累您。

- 安全。

  Rootless containers allow you to contain privileges without compromising  functionality. Trusted by US government agencies for secure HPC at scale [case study](https://www.redhat.com/architect/hpc-containers-scale-using-podman).无根容器允许您在不影响功能的情况下包含权限。受到美国政府机构的信赖，提供大规模安全的 HPC 案例研究。

- Open。

  Podman 首先是开源的，不会把你束缚在里面。Podman Desktop 可以用作管理所有容器的工具，无论容器引擎如何 - 即使不使用 Podman 作为容器引擎。

- Compatible. 相容。

  兼容其他符合 OCI 标准的容器格式，包括 Docker。在 Podman 上运行旧版 Docker 容器（包括 docker-compose 文件）。

- Kubernetes 就绪

  创建、启动、检查和管理 Pod 。Play Kubernetes YAML directly with  Podman, generate Kubernetes YAML from pods, and deploy to existing  Kubernetes environments.直接使用 Podman 玩 Kubernetes YAML，从 Pod 生成 Kubernetes YAML，并部署到现有的 Kubernetes 环境。

## 兼容工具

* Visual Studio code 包括 Podman 支持
* Cirrus CLI 允许使用 Podman 可重复地运行容器化任务
* GitHub Actions 包括对 Podman 的支持，as well as friends buildah and skopeo，以及朋友 buildah 和 skopeo
* Kind's ability to run local Kubernetes clusters via container nodes includes support for Podman
  Kind 通过容器节点运行本地 Kubernetes 集群的能力包括对 Podman 的支持。

## Podman Desktop

Podman Desktop 是 Podman 的图形应用程序，可以轻松地在 Windows、MacOS 和 Linux 上安装和使用 Podman（和其他容器引擎）。

### 管理容器（不仅仅是 Podman）

Podman Desktop 允许您在单个统一视图中列出、查看和管理来自多个受支持的容器引擎的容器。

Gain easy access to a shell inside the container, logs, and basic controls.
轻松访问容器内的 shell、日志和基本控件。

支持的引擎和编排器包括：

* Podman
* Docker
* Lima
* kind
* Red Hat OpenShift
* Red Hat OpenShift Developer Sandbox

### 构建、拉取和推送镜像

从 Dockerfile/Containerfile 构建容器，或从远程仓库拉取镜像以运行。

管理帐户并将映像推送到多个容器注册表。

### Podify containers into pods. 将容器化为 Pod

通过选择要一起运行的容器来创建 Pod。查看 Pod 的统一日志，并检查每个 Pod 中的容器。

在没有 Kubernetes 的情况下，在本地运行 Kubernetes YAML，并从 Pod 生成 Kubernetes YAML。

### 部署到 Kubernetes

Deploy pods from Podman Desktop to local or remote Kubernetes contexts using automatically-generated YAML config.
使用自动生成的 YAML 配置将 Pod 从 Podman Desktop 部署到本地或远程 Kubernetes 上下文。

## Podman 命令行

Podman 的命令行界面允许您查找、运行、构建和共享容器。

### 找到并拉下容器，无论它们在哪里。

- podman search
- podman pull

查找并拉下容器，无论它们是在 dockerhub.io 上还是在 quay.io 上、内部注册表服务器上，还是直接从供应商处获取。

### Run pre-built application or distro containers. 运行预构建的应用程序或发行版容器。

- podman run

查找并拉下容器，无论它们是在 dockerhub.io 上还是在 quay.io 上、内部注册表服务器上，还是直接从供应商处获取。

### 构建

- podman build

### 共享已构建的容器

- podman push

Podman 允许使用单个 podman push 命令将新建的容器推送到您想要的任何位置。

## 安装 Podman

## 获取帮助

### 帮助 & 手册页

有关更多详细信息，您可以查看手册页：

```bash
man podman 
man podman subcommand
```

要获得一些帮助并了解 Podman 的工作方式，可以使用帮助。

```bash
podman --help # get a list of all commands 
podman subcommand --help # get info on a command
```

## 搜索、拉取和列出 Image

```bash
$ podman search httpd 
  INDEX       NAME                                  DESCRIPTION                    STARS OFFICIAL AUTOMATED
  docker.io   docker.io/library/httpd               The Apache HTTP Server Project  3762             [OK]
  docker.io   docker.io/centos/httpd-24-centos7     Platform for running Apache h... 40
  quay.io     quay.io/centos7/httpd-24-centos-7     Platform for running Apache h... 0               [OK]
  docker.io   docker.io/centos/httpd                                                 34              [OK]
  redhat.com  registry.access.redhat.com/ubi8/httpd                                  0
  quay.io     quay.io/redhattraining/httpd-parent                                    0               [OK]
  
$ podman search httpd --filter=is-official
  INDEX       NAME                                  DESCRIPTION                    STARS OFFICIAL AUTOMATED
  docker.io   docker.io/library/httpd               The Apache HTTP Server Project  3762    [OK]
  $ podman pull docker.io/library/httpd
  Trying to pull docker.io/library/httpd:latest...
  Getting image source signatures
  Copying blob ab86dc02235d done  
  Copying blob ba1caf8ba86c done  
  Copying blob eff15d958d66 done  
  Copying blob 635a49ba2501 done  
  Copying blob 600feb748d3c done  
  Copying config d294bb32c2 done  
  Writing manifest to image destination
  Storing signatures
  d294bb32c2073ecb5fb27e7802a1e5bec334af69cac361c27e6cb8546fdd14e7

$ podman images
  REPOSITORY               TAG         IMAGE ID      CREATED       SIZE
  docker.io/library/httpd  latest      d294bb32c207  12 hours ago  148 MB  
```

> **注意：**Podman searches in different registries.
> Podman 在不同的注册表中搜索。因此，建议使用完整的映像名称（docker.io/library/httpd 而不是 httpd），以确保使用正确的映像。

## 运行容器 & 列出正在运行的容器

此示例容器将运行一个非常基本的 httpd 服务器，该服务器仅提供其索引页。

### 运行容器

```bash
$ podman run -dt -p 8080:80/tcp docker.io/library/httpd 
```

> Note: 注意：
>
> Because the container is being run in detached mode, represented by the -d in  the podman run command, Podman will run the container in the background  and print the container ID after it has executed the command. The -t  also adds a pseudo-tty to run arbitrary commands in an interactive  shell.
> 由于容器以分离模式运行（由 podman run 命令中的 -d 表示），因此 Podman 将在后台运行容器，并在执行命令后打印容器 ID。-t 还添加了一个伪 tty，用于在交互式 shell 中运行任意命令。
>
> Also, we use port forwarding to be able to access the HTTP server. For successful running at least **slirp4netns** v0.3.0 is needed.
> 此外，我们使用端口转发来访问 HTTP 服务器。要成功运行，至少需要 slirp4netns v0.3.0。

### 列出正在运行的容器

`podman ps` 命令用于列出已创建和正在运行的容器。

```bash
$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED       STATUS      PORTS                 NAMES
01c44968199f  docker.io/library/httpd:latest  httpd-foreground  1 minute ago  Up 1 minute 0.0.0.0:8080->80/tcp  laughing_bob
```

> Note: 注意：
>
> 如果添加 `-a` 到 `podman ps` 命令中，Podman 将显示所有容器（已创建、已退出、正在运行等）。

### 测试 `httpd` 容器

the container does not have an IP Address  assigned. The container is reachable via its published port on your  local machine.
容器未分配 IP 地址。可以通过其在本地计算机上的已发布端口访问容器。

```bash
$ curl http://localhost:8080
```

在另一台计算机上，需要使用主机的 IP 地址来运行容器。

```bash
$ curl http://<IP_Address>:8080
```

> Note: 
>
> 除了使用 `curl` ，还可以将浏览器指向 `http://localhost:8080` 。