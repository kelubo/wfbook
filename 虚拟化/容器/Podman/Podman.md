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

Podman 是一个无守护进程的开源 Linux 原生工具，旨在使用 Open Containers Initiative（OCI）容器和容器镜像轻松查找、运行、构建、共享和部署应用程序。Podman 提供了一个命令行界面（CLI），任何使用过 Docker 容器引擎的人都熟悉它。大多数用户可以简单地将 Docker 别名为 Podman（alias docker=podman），没有任何问题。与其他常见的容器引擎（Docker、CRI-O、containerd）类似，Podman 依赖于符合 OCI 的容器运行时（runc、crun、runv 等）来与操作系统交互并创建正在运行的容器。这使得 Podman  创建的正在运行的容器与任何其他常见容器引擎创建的容器几乎没有区别。

Podman specializes in all of the commands and functions that  help you to maintain and modify OCI container images, such as pulling  and tagging. It allows you to create, run, and maintain those containers and container images in a production environment.
在 Podman 控制下的容器可以由 root 用户运行，也可以由非特权用户运行。Podman 使用 libpod 库管理整个容器生态系统，包括  pod、容器、容器镜像和容器卷。Podman 专注于帮助您维护和修改 OCI  容器镜像的所有命令和函数，例如拉取和标记。它允许您在生产环境中创建、运行和维护这些容器和容器映像。

There is a RESTFul API to manage containers.  We also have a remote Podman client that can interact with the RESTFul service.  We currently support clients on Linux, Mac, and Windows.  The RESTFul service is only supported on Linux.
有一个 RESTFul API 来管理容器。我们还有一个远程 Podman 客户端，可以与 RESTFul 服务进行交互。我们目前支持 Linux、Mac 和 Windows 上的客户端。RESTFul 服务仅在 Linux 上受支持。



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

## 获取帮助

### 帮助 & 手册页

有关更多详细信息，您可以查看手册页：

```bash
man podman 
man podman-<subcommand>
```

要获得一些帮助并了解 Podman 的工作方式，可以使用帮助。

```bash
podman --help # get a list of all commands 
podman <subcommand> --help # get info on a command
```

## 搜索、拉取和列出 Image

```bash
# Podman 可以使用一些简单的关键字在远程注册表上搜索图像。
$ podman search <search_term>
$ podman search httpd 
  INDEX       NAME                                  DESCRIPTION                    STARS OFFICIAL AUTOMATED
  docker.io   docker.io/library/httpd               The Apache HTTP Server Project  3762             [OK]
  docker.io   docker.io/centos/httpd-24-centos7     Platform for running Apache h... 40
  quay.io     quay.io/centos7/httpd-24-centos-7     Platform for running Apache h... 0               [OK]
  docker.io   docker.io/centos/httpd                                                 34              [OK]
  redhat.com  registry.access.redhat.com/ubi8/httpd                                  0
  quay.io     quay.io/redhattraining/httpd-parent                                    0               [OK]

# 可以使用过滤器来增强搜索效果
$ podman search httpd --filter=is-official
  INDEX       NAME                                  DESCRIPTION                    STARS OFFICIAL AUTOMATED
  docker.io   docker.io/library/httpd               The Apache HTTP Server Project  3762    [OK]

# 下载（拉取）图像
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

# 列出计算机上存在的所有图像。
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

### 检查正在运行的容器

可以“检查”正在运行的容器的元数据和有关其自身的详细信息。 `podman inspect` 将提供许多有用的信息，如环境变量、网络设置或分配的资源。

Since, the container is running in **rootless** mode, 由于容器以无根模式运行，因此不会为容器分配 IP 地址。

```bash
$ podman inspect -l | grep IPAddress
            "IPAddress": "",
```

> **Note**:
>
> The `-l` is a convenience argument for **latest container**. You can also use the container's ID or name instead of `-l` or the long argument `--latest`.
> 这是 `-l` 最新容器的便利参数。您也可以使用容器的 ID 或名称来代替 `-l` or long 参数 `--latest` 。
>
> **Note**: If you are running remote Podman client, including Mac and Windows (excluding WSL2) machines,
> 注意：如果您正在运行远程 Podman 客户端，包括 Mac 和 Windows（不包括 WSL2）计算机，则 `-l` 选项不可用。

### 查看容器的日志

```bash
$ podman logs -l

127.0.0.1 - - [04/May/2020:08:33:48 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:50 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:51 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:51 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:52 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:52 +0000] "GET / HTTP/1.1" 200 45
```

### 查看容器的 pid

可以使用 `podman top` 在容器中观察 httpd 的 pid 。

```bash
$ podman top -l

USER     PID   PPID   %CPU    ELAPSED            TTY     TIME   COMMAND
root     1     0      0.000   22m13.33281018s    pts/0   0s     httpd -DFOREGROUND
daemon   3     1      0.000   22m13.333132179s   pts/0   0s     httpd -DFOREGROUND
daemon   4     1      0.000   22m13.333276305s   pts/0   0s     httpd -DFOREGROUND
daemon   5     1      0.000   22m13.333818476s   pts/0   0s     httpd -DFOREGROUND
```

### 停止容器

```bash
$ podman stop -l
```

You can check the status of one or more containers using the `podman ps` command. In this case, you should use the `-a` argument to list all containers.
可以使用 `podman ps` 命令检查一个或多个容器的状态。在这种情况下，应该使用参数 `-a` 列出所有容器。

```bash
$ podman ps -a
```

### 删除容器

```bash
$ podman rm -l
```

可以通过运行 `podman ps -a` 来验证容器的删除。

## 网络



## Checkpoint检查点、迁移和恢复容器

Checkpointing a container stops the container while writing the state of all processes in the container to disk. With this, a container can later be migrated and restored, running at exactly the same point in time as the checkpoint. 
对容器执行检查点操作会停止容器，同时将容器中所有进程的状态写入磁盘。这样，容器以后可以迁移和还原，在与检查点完全相同的时间点运行。

## 集成测试



## Podman Python 文档





[Containers](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.j2uq93kgxe0e) simplify the production, distribution, discoverability, and usage of  applications with all of their dependencies and default configuration  files. Users test drive or deploy a new application with one or two  commands instead of following pages of installation instructions. Here’s how to find your first [Container Image](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw):
容器简化了应用程序及其所有依赖项和默认配置文件的生产、分发、可发现性和使用。用户使用一两个命令来试用或部署新应用程序，而不是按照安装说明的页面进行操作。以下是查找第一个容器映像的方法：

```
podman search docker.io/busybox
```

Output: 输出：

```
NAME                                         DESCRIPTION
docker.io/library/busybox                    Busybox base image.
docker.io/rancher/busybox
docker.io/openebs/busybox-client
docker.io/antrea/busybox
docker.io/hugegraph/busybox                  test image
...
```

The previous command returned a list of publicly available container images on DockerHub. These container images are easy to consume, but of  differing levels of quality and maintenance. Let’s use the first one  listed because it seems to be well maintained.
上一个命令返回了 DockerHub 上公开可用的容器映像的列表。这些容器镜像易于使用，但质量和维护级别各不相同。让我们使用列出的第一个，因为它似乎得到了很好的维护。

To run the busybox container image, it’s just a single command:
要运行 busybox 容器镜像，只需一个命令：

```
podman run -it docker.io/library/busybox
```

Output: 输出：

```
/ #
```

You can poke around in the busybox container for a while, but you’ll  quickly find that running small container with a few Linux utilities in  it provides limited value, so exit out:
你可以在busybox容器中闲逛一会儿，但你很快就会发现，运行包含一些Linux实用程序的小容器提供的价值有限，所以退出吧：

```
exit
```

There’s an old saying that “nobody runs an operating system just to run an  operating system” and the same is true with containers. It’s the  workload running on top of an operating system or in a container that’s  interesting and valuable.
有句老话说“没有人只是为了运行操作系统而运行操作系统”，容器也是如此。它是在操作系统顶部或容器中运行的工作负载，既有趣又有价值。

Sometimes we can find a publicly available container image for the exact workload we’re looking for and it will already be packaged exactly how we want.  But, more often than not, there’s something that we want to add, remove, or customize. It can be as simple as a configuration setting for  security or performance, or as complex as adding a complex workload.  Either way, containers make it fairly easy to make the changes we need.
有时，我们可以为正在寻找的确切工作负载找到一个公开可用的容器镜像，并且它已经完全按照我们想要的方式打包。但是，通常情况下，我们想要添加、删除或自定义某些内容。它可以像安全性或性能的配置设置一样简单，也可以像添加复杂的工作负载一样复杂。无论哪种方式，容器都使得进行我们需要的更改变得相当容易。

Container Images aren’t actually images, they’re repositories often made up of  multiple layers. These layers can easily be added, saved, and shared  with others by using a Containerfile (Dockerfile). This single file  often contains all the instructions needed to build a new container  image and can easily be shared with others publicly using tools like  GitHub.
容器镜像实际上并不是镜像，它们是通常由多个层组成的仓库。可以使用 Containerfile （Dockerfile）  轻松添加、保存这些层并与他人共享这些层。此单个文件通常包含构建新容器映像所需的所有说明，并且可以使用 GitHub 等工具轻松地与他人公开共享。

Here’s an example of how to build a Nginx web server on top of a Debian base  image using the Dockerfile maintained by Nginx and published in GitHub:
下面是一个示例，说明如何使用由 Nginx 维护并在 GitHub 上发布的 Dockerfile 在 Debian 基础镜像之上构建 Nginx Web 服务器：

```
podman build -t nginx https://git.io/Jf8ol
```

Once, the image build completes, it’s easy to run the new image from our local cache:
一旦镜像构建完成，就可以轻松地从我们的本地缓存运行新镜像：

```
podman run -d -p 8080:80 nginx
curl localhost:8080
```

Output: 输出：

```
...
<p><em>Thank you for using nginx.</em></p>
...
```

Building new images is great, but sharing our work with others lets them review  our work, critique how we built them, and offer improved versions. Our  newly built Nginx image can be published at quay.io or docker.io to  share it with the world. Everything needed to run the Nginx application  is provided in the container image. Others can easily pull it down and  use it, or make improvements to it.
构建新镜像固然很棒，但与他人分享我们的工作可以让他们回顾我们的工作，批评我们构建它们的方式，并提供改进的版本。我们新建的 Nginx 镜像可以在 quay.io 或 docker.io 发布，与世界分享。运行 Nginx  应用程序所需的一切都在容器镜像中提供。其他人可以很容易地将其拉下来并使用它，或者对其进行改进。

Standardizing on container images and [Container Registries](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq) enable a new level of collaboration through simple consumption. This  simple consumption model is possible because every major Container  Engine and Registry Server uses the Open Containers Initiative ([OCI](https://www.opencontainers.org/)) format. This allows users to find, run, build, share and deploy containers anywhere they want. Podman and other [Container Engines](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) like CRI-O, Docker, or containerd can create and consume container  images from docker.io, quay.io, an on premise registry or even one  provided by a cloud provider. The OCI image format facilitates this  ecosystem through a single standard.
容器镜像和容器注册表的标准化通过简单的使用实现了新的协作水平。这种简单的消费模型是可能的，因为每个主要的容器引擎和注册表服务器都使用开放容器倡议 （OCI） 格式。这使用户可以在他们想要的任何地方查找、运行、构建、共享和部署容器。Podman 和其他容器引擎（如 CRI-O、Docker 或 containerd）可以从 docker.io、quay.io、本地注册表甚至云提供商提供的容器镜像中创建和使用容器镜像。OCI  镜像格式通过单一标准促进了这一生态系统。

For example, if we wanted to share our newly built Nginx container image on quay.io it’s easy. First log in to quay:
例如，如果我们想在 quay.io 上分享我们新建的 Nginx 容器镜像，这很容易。首次登录码头：

```
podman login quay.io
```

Input: 输入：

```
Username: USERNAME
Password: ********
Login Succeeded!
```

Next, tag the image so that we can push it into our user account:
接下来，标记图像，以便我们可以将其推送到我们的用户帐户中：

```
podman tag localhost/nginx quay.io/USERNAME/nginx
```

Finally, push the image:
最后，推送镜像：

```
podman push quay.io/USERNAME/nginx
```

Output: 输出：

```
Getting image source signatures
Copying blob 38c40d6c2c85 done
Copying blob fee76a531659 done
Copying blob c2adabaecedb done
Copying config 7f3589c0b8 done
Writing manifest to image destination
Copying config 7f3589c0b8 done
Writing manifest to image destination
Storing signatures
```

Notice that we pushed four layers to our registry and now it’s available for others to share. Take a quick look:
请注意，我们在注册表中推送了四个层，现在其他人可以共享它。快速浏览一下：

```
podman inspect quay.io/USERNAME/nginx
```

Output: 输出：

```
[
    {
        "Id": "7f3589c0b8849a9e1ff52ceb0fcea2390e2731db9d1a7358c2f5fad216a48263",
        "Digest": "sha256:7822b5ba4c2eaabdd0ff3812277cfafa8a25527d1e234be028ed381a43ad5498",
        "RepoTags": [
            "quay.io/USERNAME/nginx:latest",
...
```

To summarize, Podman makes it easy to find, run, build and share containers.
总而言之，Podman 使查找、运行、构建和共享容器变得容易。

- Find: whether finding a container on dockerhub.io or quay.io, an internal  registry server, or directly from a vendor, a couple of [podman search](http://docs.podman.io/en/latest/markdown/podman-search.1.html), and [podman pull](http://docs.podman.io/en/latest/markdown/podman-pull.1.html) commands make it easy
  查找：无论是在 dockerhub.io 或 quay.io、内部注册表服务器上查找容器，还是直接从供应商处查找容器，几个 podman 搜索和 podman pull 命令都可以轻松实现
- Run: it’s easy to consume pre-built images with everything needed to run an  entire application, or start from a Linux distribution base image with  the [podman run](http://docs.podman.io/en/latest/markdown/podman-run.1.html) command
  运行：可以轻松使用预构建的镜像以及运行整个应用程序所需的一切，或者使用 podman run 命令从 Linux 发行版基础镜像开始
- Build: creating new layers with small tweaks, or major overhauls is easy with [podman build](http://docs.podman.io/en/latest/markdown/podman-build.1.html)
  构建：使用 podman build 可以轻松通过小的调整或大修来创建新层
- Share: Podman lets you push your newly built containers anywhere you want with a single [podman push](http://docs.podman.io/en/latest/markdown/podman-push.1.html) command
  分享：Podman 允许您使用单个 podman push 命令将新构建的容器推送到您想要的任何地方

If you are running on a Mac or Windows PC, you should instead follow the [Mac and Windows tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/mac_win_client.md) to set up the remote Podman client.
如果您在 Mac 或 Windows PC 上运行，则应按照 Mac 和 Windows 教程设置远程 Podman 客户端。

**NOTE**: the code samples are intended to be run as a non-root user, and use `sudo` where root escalation is required.
注意：代码示例旨在以非 root 用户身份运行，并在需要 root 升级的情况下使用 `sudo` 。

## Installing Podman 安装 Podman



For installing or building Podman, see the [installation instructions](https://podman.io/getting-started/installation).
有关安装或构建 Podman 的信息，请参阅安装说明。

## Familiarizing yourself with Podman 熟悉 Podman



### Running a sample container 运行示例容器



This sample container will run a very basic httpd server (named basic_httpd) that serves only its index page.
此示例容器将运行一个非常基本的 httpd 服务器（名为 basic_httpd），该服务器仅提供其索引页。

```
podman run --name basic_httpd -dt -p 8080:80/tcp docker.io/nginx
```

​    

Because the container is being run in detached mode, represented by the *-d* in the `podman run` command, Podman will print the container ID after it has run. Note that we use port forwarding to be able to access the HTTP server. For successful running at least slirp4netns v0.3.0 is needed.
由于容器以分离模式运行（由 `podman run` 命令中的 -d 表示），因此 Podman 将在运行后打印容器 ID。请注意，我们使用端口转发来访问 HTTP 服务器。要成功运行，至少需要 slirp4netns v0.3.0。

### Listing running containers 列出正在运行的容器



The Podman *ps* command is used to list creating and running containers.
Podman ps 命令用于列出创建和运行的容器。

```
podman ps
```

​    

Note: If you add *-a* to the *ps* command, Podman will show all containers.
注意：如果在 ps 命令中添加 -a，Podman 将显示所有容器。

### Inspecting a running container 检查正在运行的容器



You can "inspect" a running container for metadata and details about  itself.  We can even use the inspect subcommand to see what IP address was assigned to the  container. As the container is running in rootless mode, an IP address  is not assigned and the value will be listed as "none" in the output  from inspect.
您可以“检查”正在运行的容器的元数据和有关其自身的详细信息。我们甚至可以使用 inspect 子命令来查看分配给容器的 IP 地址。由于容器在无根模式下运行，因此不会分配 IP 地址，并且该值将在 inspect 的输出中列为“none”。

```
podman inspect basic_httpd | grep IPAddress\":
            "SecondaryIPAddresses": null,
            "IPAddress": "",
```

​    

### Testing the httpd server 测试 httpd 服务器



As we do not have the IP address of the container, we can test the network communication between the host operating system and the container using curl. The following command should display the index page of our containerized httpd server.
由于我们没有容器的 IP 地址，我们可以使用 curl 测试主机操作系统和容器之间的网络通信。以下命令应显示容器化 httpd 服务器的索引页。

```
curl http://localhost:8080
```

​    

### Viewing the container's logs 查看容器的日志



You can view the container's logs with Podman as well:
您也可以使用 Podman 查看容器的日志：

```
podman logs <container_id>
10.88.0.1 - - [07/Feb/2018:15:22:11 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.55.1" "-"
10.88.0.1 - - [07/Feb/2018:15:22:30 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.55.1" "-"
10.88.0.1 - - [07/Feb/2018:15:22:30 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.55.1" "-"
10.88.0.1 - - [07/Feb/2018:15:22:31 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.55.1" "-"
10.88.0.1 - - [07/Feb/2018:15:22:31 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.55.1" "-"
```

​    

### Viewing the container's pids 查看容器的 pid



And you can observe the httpd pid in the container with *top*.
你可以在带有顶部的容器中观察到 httpd pid。

```
podman top <container_id>
  UID   PID  PPID  C STIME TTY          TIME CMD
    0 31873 31863  0 09:21 ?        00:00:00 nginx: master process nginx -g daemon off;
  101 31889 31873  0 09:21 ?        00:00:00 nginx: worker process
```

​    

### Checkpointing the container 对容器进行检查点



Checkpointing a container stops the container while writing the state of all  processes in the container to disk. With this a container can later be restored and continue running at  exactly the same point in time as the checkpoint. This capability requires CRIU 3.11 or later installed on the system. This feature is not supported as rootless; as such, if you wish to try  it, you'll need to re-create your container as root, using the same  command but with sudo.
对容器执行检查点操作会停止容器，同时将容器中所有进程的状态写入磁盘。这样，容器可以稍后恢复，并在与检查点完全相同的时间点继续运行。此功能要求在系统上安装 CRIU 3.11 或更高版本。此功能不支持为无根;因此，如果您想尝试一下，您需要以 root 身份重新创建容器，使用相同的命令，但使用  sudo。

To checkpoint the container use:
要对容器执行检查点操作，请使用：

```
sudo podman container checkpoint <container_id>
```

​    

### Restoring the container 还原容器



Restoring a container is only possible for a previously checkpointed container. The restored container will continue to run at exactly the same point in time it was checkpointed. To restore the container use:
只有对先前检查点的容器才能还原容器。还原的容器将继续在它被检查点的同一时间点运行。要还原容器，请使用：

```
sudo podman container restore <container_id>
```

​    

After being restored, the container will answer requests again as it did before checkpointing.
还原后，容器将再次响应请求，就像在检查点之前一样。

```
curl http://<IP_address>:8080
```

​    

### Migrate the container 迁移容器



To live migrate a container from one host to another the container is checkpointed on the source system of the migration, transferred to the destination system and then restored on the destination system. When transferring the checkpoint, it is possible to specify an output-file.
要将容器从一台主机实时迁移到另一台主机，请在迁移的源系统上检查容器，然后转移到目标系统，然后在目标系统上还原。传输检查点时，可以指定输出文件。

On the source system:
在源系统上：

```
sudo podman container checkpoint <container_id> -e /tmp/checkpoint.tar.gz
scp /tmp/checkpoint.tar.gz <destination_system>:/tmp
```

​    

On the destination system:
在目标系统上：

```
sudo podman container restore -i /tmp/checkpoint.tar.gz
```

​    

After being restored, the container will answer requests again as it did before checkpointing. This time the container will continue to run on the destination system.
还原后，容器将再次响应请求，就像在检查点之前一样。这一次，容器将继续在目标系统上运行。

```
curl http://<IP_address>:8080
```

​    

### Stopping the container 停止容器



To stop the httpd container:
要停止 httpd 容器，请执行以下操作：

```
podman stop <container_id>
```

​    

You can also check the status of one or more containers using the *ps* subcommand. In this case, we should use the *-a* argument to list all containers.
您还可以使用 ps 子命令检查一个或多个容器的状态。在这种情况下，我们应该使用 -a 参数来列出所有容器。

```
podman ps -a
```

​    

### Removing the container 卸下容器



To remove the httpd container:
要删除 httpd 容器，请执行以下操作：

```
podman rm <container_id>
```

​    

You can verify the deletion of the container by running *podman ps -a*.
您可以通过运行 podman ps -a 来验证容器的删除。

## Integration Tests 集成测试



For more information on how to set up and run the integration tests in your environment, checkout the Integration Tests [README.md](https://github.com/containers/podman/blob/main/test/README.md)
有关如何在环境中设置和运行集成测试的更多信息，请查看集成测试 README.md

## More information 更多信息



For more information on Podman and its subcommands, checkout the asciiart demos on the [README.md](https://github.com/containers/podman/blob/main/README.md#commands) page.
有关 Podman 及其子命令的更多信息，请查看 README.md 页面上的 asciiart 演示。



# Basic Setup and Use of Podman in a Rootless environment. 在无根环境中基本设置和使用 Podman。



Prior to allowing users without root privileges to run Podman, the  administrator must install or build Podman and complete the following  configurations.
在允许没有root权限的用户运行Podman之前，管理员必须安装或构建Podman并完成以下配置。

## Administrator Actions 管理员操作



### Installing Podman 安装 Podman



For installing Podman, see the [installation instructions](https://podman.io/getting-started/installation).
有关安装 Podman 的信息，请参阅安装说明。

### Building Podman 构建 Podman



For building Podman, see the [build instructions](https://podman.io/getting-started/installation#building-from-scratch).
有关构建 Podman 的信息，请参阅构建说明。

### Install `slirp4netns` 安装 `slirp4netns` 



The [slirp4netns](https://github.com/rootless-containers/slirp4netns) package provides user-mode networking for unprivileged network  namespaces and must be installed on the machine in order for Podman to  run in a rootless environment.  The package is available on most Linux  distributions via their package distribution software such as `yum`, `dnf`, `apt`, `zypper`, etc.  If the package is not available, you can build and install `slirp4netns` from [GitHub](https://github.com/rootless-containers/slirp4netns).
slirp4netns 软件包为非特权网络命名空间提供用户模式网络，并且必须安装在计算机上才能使 Podman 在无根环境中运行。该包在大多数 Linux 发行版上都可以通过其包分发软件（如 `yum` 、 `dnf` 、 `apt` 等 `zypper` ）获得。如果包不可用，可以从 GitHub 生成和安装 `slirp4netns` 。

### `/etc/subuid` and `/etc/subgid` configuration  `/etc/subuid` 和 `/etc/subgid` 配置



Rootless Podman requires the user running it to have a range of UIDs listed in the files `/etc/subuid` and `/etc/subgid`.  The `shadow-utils` or `newuid` package provides these files on different distributions and they must  be installed on the system.  Root privileges are required to add or  update entries within these files.  The following is a summary from the [How does rootless Podman work?](https://opensource.com/article/19/2/how-does-rootless-podman-work) article by Dan Walsh on [opensource.com](https://opensource.com)
Rootless Podman 要求运行它的用户在文件 `/etc/subuid` 和 `/etc/subgid` 中列出一系列 UID。 `shadow-utils` or `newuid` 包在不同的发行版上提供这些文件，它们必须安装在系统上。需要 root 权限才能在这些文件中添加或更新条目。以下是《无根 Podman 如何工作？丹·沃尔什（Dan Walsh）在 opensource.com 上的文章

For each user that will be allowed to create containers, update `/etc/subuid` and `/etc/subgid` for the user with fields that look like the following.  Note that the  values for each user must be unique.  If there is overlap, there is a  potential for a user to use another user's namespace and they could  corrupt it.
对于将被允许创建容器的每个用户，请使用如下所示的字段进行更新 `/etc/subuid` 。 `/etc/subgid` 请注意，每个用户的值必须是唯一的。如果存在重叠，则用户可能会使用另一个用户的命名空间，并且他们可能会破坏它。

```
# cat /etc/subuid
johndoe:100000:65536
test:165536:65536
```

​    

The format of this file is `USERNAME:UID:RANGE`
此文件的格式为 `USERNAME:UID:RANGE` 

- username as listed in `/etc/passwd` or in the output of [`getpwent`](https://man7.org/linux/man-pages/man3/getpwent.3.html).
  用户名，如 的输出中 `/etc/passwd` 或输出中所列。 `getpwent` 
- The initial UID allocated for the user.
  为用户分配的初始 UID。
- The size of the range of UIDs allocated for the user.
  为用户分配的 UID 范围的大小。

This means the user `johndoe` is allocated UIDs 100000-165535 as well as their standard UID in the `/etc/passwd` file.  NOTE: this is not currently supported with network installs;  these files must be available locally to the host machine.  It is not  possible to configure this with LDAP or Active Directory.
这意味着为用户 `johndoe` 分配了 UID 100000-165535 以及 `/etc/passwd` 文件中的标准 UID。注意：网络安装目前不支持此功能;这些文件必须在主机本地可用。无法使用 LDAP 或 Active Directory 进行配置。

Rather than updating the files directly, the `usermod` program can be used to assign UIDs and GIDs to a user.
该 `usermod` 程序可用于将 UID 和 GID 分配给用户，而不是直接更新文件。

```
# usermod --add-subuids 100000-165535 --add-subgids 100000-165535 johndoe
grep johndoe /etc/subuid /etc/subgid
/etc/subuid:johndoe:100000:65536
/etc/subgid:johndoe:100000:65536
```

​    

If you update either `/etc/subuid` or `/etc/subgid`, you need to stop all the running containers owned by the user and kill  the pause process that is running on the system for that user.  This can be done automatically by running [`podman system migrate`](https://github.com/containers/podman/blob/main/docs/source/markdown/podman-system-migrate.1.md) as that user.
如果更新 either `/etc/subuid` 或 `/etc/subgid` ，则需要停止用户拥有的所有正在运行的容器，并终止该用户在系统上运行的暂停进程。这可以通过以该用户身份运行 `podman system migrate` 来自动完成。

#### Giving access to additional groups 向其他组授予访问权限



Users can fully map additional groups to a container namespace if those groups subordinated to the user:
如果这些组从属于用户，则用户可以将其他组完全映射到容器命名空间：

```
# usermod --add-subgids 2000-2000 johndoe
grep johndoe /etc/subgid
```

​    

This means the user `johndoe` can "impersonate" the group `2000` inside the container. Note that it is usually not a good idea to subordinate active user ids to other users, because it would allow user impersonation.
这意味着用户可以 `johndoe` “模拟”容器内的组 `2000` 。请注意，将活动用户 ID 从属于其他用户通常不是一个好主意，因为这会允许用户模拟。

`johndoe` can use `--group-add keep-groups` to preserve the additional groups, and `--gidmap="+g102000:@2000"` to map the group `2000` in the host to the group `102000` in the container:
 `johndoe` 可用于 `--group-add keep-groups` 保留其他组，并将 `--gidmap="+g102000:@2000"` 主机中的组 `2000` 映射到容器中的组 `102000` ：

```
$ podman run \
  --rm \
  --group-add keep-groups \
  --gidmap="+g102000:@2000" \
  --volume "$PWD:/data:ro" \
  --workdir /data \
  alpine ls -lisa
```

​    

### Enable unprivileged `ping` 启用无特权 `ping` 



(It is very unlikely that you will need to do this on a modern distro).
（您不太可能需要在现代发行版上执行此操作）。

Users running in a non-privileged container may not be able to use the `ping` utility from that container.
在非特权容器中运行的用户可能无法使用该容器中的 `ping` 实用程序。

If this is required, the administrator must verify that the UID of the user is part of the range in the `/proc/sys/net/ipv4/ping_group_range` file.
如果需要，管理员必须验证用户的 UID 是否属于 `/proc/sys/net/ipv4/ping_group_range` 文件中的范围。

To change its value the administrator can use a call similar to: `sysctl -w "net.ipv4.ping_group_range=0 2000000"`.
要更改其值，管理员可以使用类似于以下内容的调用。 `sysctl -w "net.ipv4.ping_group_range=0 2000000"` 

To make the change persist, the administrator will need to add a file with the `.conf` file extension in `/etc/sysctl.d` that contains `net.ipv4.ping_group_range=0 $MAX_GID`, where `$MAX_GID` is the highest assignable GID of the user running the container.
要使更改持续存在，管理员需要添加一个 `.conf` 文件扩展名为 `/etc/sysctl.d` `net.ipv4.ping_group_range=0 $MAX_GID` 的文件，其中包含 ，其中 `$MAX_GID` 是运行容器的用户的最高可分配 GID。

## User Actions 用户操作



The majority of the work necessary to run Podman in a rootless environment is on the shoulders of the machine’s administrator.
在无根环境中运行 Podman 所需的大部分工作都落在了机器管理员的肩上。

Once the Administrator has completed the setup on the machine and then the configurations for the user in `/etc/subuid` and `/etc/subgid`, the user can just start using any Podman command that they wish.
一旦管理员在计算机上完成了设置，然后在 和 `/etc/subgid` 中 `/etc/subuid` 完成了用户的配置，用户就可以开始使用他们想要的任何 Podman 命令。

### User Configuration Files 用户配置文件



The Podman configuration files for root reside in `/usr/share/containers` with overrides in `/etc/containers`.  In the rootless environment they reside in `${XDG_CONFIG_HOME}/containers` and are owned by each individual user.
root 的 Podman 配置文件位于 中 `/usr/share/containers` ，覆盖位于 `/etc/containers` 中。在无根环境中，它们驻留在每个用户中 `${XDG_CONFIG_HOME}/containers` 并由每个单独的用户拥有。

Note: in environments without `XDG` environment variables, Podman internally sets the following defaults:
注意：在没有 `XDG` 环境变量的环境中，Podman 会在内部设置以下默认值：

- `$XDG_CONFIG_HOME` = `$HOME/.config`

- `$XDG_DATA_HOME` = `$HOME/.local/share`

- ```
  $XDG_RUNTIME_DIR
  ```

   =

  - `/run/user/$UID` on `systemd` environments
     `/run/user/$UID` 关于 `systemd` 环境
  - `$TMPDIR/podman-run-$UID` otherwise `$TMPDIR/podman-run-$UID` 否则

The three main configuration files are [containers.conf](https://github.com/containers/common/blob/main/docs/containers.conf.5.md), [storage.conf](https://github.com/containers/storage/blob/main/docs/containers-storage.conf.5.md) and [registries.conf](https://github.com/containers/image/blob/main/docs/containers-registries.conf.5.md). The user can modify these files as they wish.
三个主要的配置文件是 containers.conf、storage.conf 和 registries.conf。用户可以根据需要修改这些文件。

#### containers.conf containers.conf 文件



Podman reads Podman 读取

1. `/usr/share/containers/containers.conf`
2. `/etc/containers/containers.conf`
3. `${XDG_CONFIG_HOME}/containers/containers.conf`

if they exist, in that order. Each file can override the previous for particular fields.
如果它们存在，则按此顺序。对于特定字段，每个文件都可以覆盖前一个文件。

#### storage.conf storage.conf 文件



For `storage.conf` the order is
对于 `storage.conf` 订单是

1. `/etc/containers/storage.conf`
2. `${XDG_CONFIG_HOME}/containers/storage.conf`

In rootless Podman, certain fields in `/etc/containers/storage.conf` are ignored. These fields are:
在无根 Podman 中，某些 `/etc/containers/storage.conf` 字段将被忽略。这些字段包括：

```
graphroot=""
 container storage graph dir (default: "/var/lib/containers/storage")
 Default directory to store all writable content created by container storage programs.

runroot=""
 container storage run dir (default: "/run/containers/storage")
 Default directory to store all temporary writable content created by container storage programs.
```

​    

In rootless Podman these fields default to
在无根 Podman 中，这些字段默认为

```
graphroot="${XDG_DATA_HOME}/containers/storage"
runroot="${XDG_RUNTIME_DIR}/containers"
```

​    

[$XDG_RUNTIME_DIR](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables) defaults on most systems to `/run/user/$UID`.
$XDG_RUNTIME_DIR 在大多数系统上默认为 `/run/user/$UID` 。

#### registries 登记处



Registry configuration is read in this order
注册表配置按此顺序读取

1. `/etc/containers/registries.conf`
2. `/etc/containers/registries.d/*`
3. `${XDG_CONFIG_HOME}/containers/registries.conf`

The files in the home directory should be used to configure rootless Podman for personal needs. These files are not created by default. Users can  copy the files from `/usr/share/containers` or `/etc/containers` and modify them.
主目录中的文件应该用于配置无根 Podman 以满足个人需求。默认情况下不会创建这些文件。用户可以从 `/usr/share/containers` 中复制文件或 `/etc/containers` 修改文件。

#### Authorization files 授权文件



The default authorization file used by the `podman login` and `podman logout` commands is `${XDG_RUNTIME_DIR}/containers/auth.json`.
 `podman login` and `podman logout` 命令使用的缺省授权文件是 `${XDG_RUNTIME_DIR}/containers/auth.json` 。

### Using volumes 使用卷



Rootless Podman is not, and will never be, root; it's not a `setuid` binary, and gains no privileges when it runs. Instead, Podman makes use of a user namespace to shift the UIDs and GIDs of a block of users it  is given access to on the host (via the `newuidmap` and `newgidmap` executables) and your own user within the containers that Podman creates.
无根的 Podman 不是，也永远不会是根;它不是 `setuid` 二进制文件，在运行时不会获得任何权限。取而代之的是，Podman 利用用户命名空间来移动它在主机上有权访问的用户块的 UID 和 GID（通过 `newuidmap` 和 `newgidmap` 可执行文件）以及 Podman 创建的容器中的您自己的用户。

If your container runs with the root user, then `root` in the container is actually your user on the host. UID/GID 1 is the first UID/GID specified in your user's mapping in `/etc/subuid` and `/etc/subgid`, etc. If you mount a directory from the host into a container as a  rootless user, and create a file in that directory as root in the  container, you'll see it's actually owned by your user on the host.
如果您的容器使用 root 用户运行，则 `root` 容器中实际上是主机上的用户。UID/GID 1 是用户在 `/etc/subuid` 和 `/etc/subgid` 等中的映射中指定的第一个 UID/GID。如果您以无根用户的身份将主机中的目录挂载到容器中，并以容器中的 root 身份在该目录中创建一个文件，您将看到它实际上由主机上的用户拥有。

So, for example, 因此，例如，

```
host$ whoami
john

# a folder which is empty
host$ ls /home/john/folder
host$ podman run -it -v /home/john/folder:/container/volume mycontainer /bin/bash

# Now I'm in the container
root@container# whoami
root
root@container# touch /container/volume/test
root@container# ls -l /container/volume
total 0
-rw-r--r-- 1 root root 0 May 20 21:47 test
root@container# exit

# I check again
host$ ls -l /home/john/folder
total 0
-rw-r--r-- 1 john john 0 May 20 21:47 test
```

​    

We do recognize that this doesn't really match how many people intend to  use rootless Podman - they want their UID inside and outside the  container to match. Thus, we provide the `--userns=keep-id` flag, which ensures that your user is mapped to its own UID and GID inside the container.
我们确实认识到，这与有多少人打算使用无根 Podman 并不真正匹配 - 他们希望容器内外的 UID 匹配。因此，我们提供了标志 `--userns=keep-id` ，可确保您的用户在容器内映射到其自己的 UID 和 GID。

It is also helpful to distinguish between running Podman as a rootless  user, and a container which is built to run rootless. If the container  you're trying to run has a `USER` which is not root, then when mounting volumes you **must** use `--userns=keep-id`. This is because the container user would not be able to become `root` and access the mounted volumes.
区分作为无根用户运行的 Podman 和为运行无根而构建的容器也很有帮助。如果您尝试运行的容器具有 `USER` 不是 root 的容器，则在挂载卷时必须使用 `--userns=keep-id` .这是因为容器用户无法成为 `root` 和访问已装载的卷。

Another consideration in regards to volumes:
关于数量的另一个考虑因素：

- When providing the path of a directory you'd like to bind-mount, the path needs to be provided as an absolute path or a relative path that starts with `.` (a dot), otherwise the string will be interpreted as the name of a named volume.
  在提供要绑定挂载的目录的路径时，需要将路径提供为绝对路径或以 `.` （点）开头的相对路径，否则字符串将被解释为命名卷的名称。

## More information 更多信息



If you are still experiencing problems running Podman in a rootless environment, please refer to the [Shortcomings of Rootless Podman](https://github.com/containers/podman/blob/main/rootless.md) page which lists known issues and solutions to known issues in this environment.
如果您在无根环境中运行 Podman 时仍然遇到问题，请参考 Rootless Podman 的缺点页面，其中列出了此环境中的已知问题和已知问题的解决方案。

For more information on Podman and its subcommands, follow the links on the main [README.md](https://github.com/containers/podman/blob/main/README.md#podman-information-for-developers) page or the [podman.io](https://podman.io) web site.
有关 Podman 及其子命令的更多信息，请访问 README.md 主页或 podman.io 网站上的链接。



# Podman for Windows Podman针对于Windows



While "containers are Linux," Podman also runs on Mac and Windows, where it provides a native CLI and embeds a guest Linux system to launch your containers. This guest is referred to as a Podman machine and is managed with the `podman machine` command. On Windows, each Podman machine is backed by a virtualized Windows Subsystem for Linux (WSLv2) distribution. The podman command can be run directly from your Windows PowerShell (or CMD) prompt, where it remotely communicates with the podman service running in the WSL environment. Alternatively, you can access Podman directly from the WSL instance if you prefer a Linux prompt and Linux tooling. In addition to command-line access, Podman also listens for Docker API clients, supporting direct usage of Docker-based tools and programmatic access from your language of choice.
虽然“容器是 Linux”，但 Podman 也可以在 Mac 和 Windows 上运行，它提供了一个原生 CLI 并嵌入了一个客户 Linux 系统来启动您的容器。此客户机称为 Podman 计算机，并使用 `podman machine` 命令进行管理。在 Windows 上，每台 Podman 计算机都由适用于 Linux 的虚拟化 Windows 子系统 （WSLv2）  分发版提供支持。podman 命令可以直接从 Windows PowerShell（或 CMD）提示符运行，在该提示符中，它与在 WSL  环境中运行的 podman 服务进行远程通信。或者，如果您更喜欢 Linux 提示符和 Linux 工具，则可以直接从 WSL 实例访问  Podman。除了命令行访问外，Podman 还监听 Docker API 客户端，支持直接使用基于 Docker  的工具以及从您选择的语言进行编程访问。

## Prerequisites 先决条件



Since Podman uses WSL, you need a recent release of Windows 10 or Windows 11. On x64, WSL requires build 18362 or later, and 19041 or later is required for arm64 systems. Internally, WSL uses virtualization, so your system must support and have hardware virtualization enabled. If you are running Windows on a VM, you must have a VM that supports nested virtualization.
由于 Podman 使用 WSL，因此您需要最新版本的 Windows 10 或 Windows 11。在 x64 上，WSL 需要生成 18362 或更高版本，而 arm64 系统需要 19041 或更高版本。在内部，WSL 使用虚拟化，因此系统必须支持并启用硬件虚拟化。如果在 VM  上运行 Windows，则必须具有支持嵌套虚拟化的 VM。

It is also recommended to install the modern "Windows Terminal," which provides a superior user experience to the standard PowerShell and CMD prompts, as well as a WSL prompt, should you want it.
还建议安装现代的“Windows 终端”，它为标准 PowerShell 和 CMD 提示以及 WSL 提示符（如果需要）提供卓越的用户体验。

You can install it by searching the Windows Store or by running the following `winget` command:
您可以通过搜索 Windows 应用商店或运行以下 `winget` 命令来安装它：

```
winget install Microsoft.WindowsTerminal
```

## Installing Podman 安装 Podman



Installing the Windows Podman client begins by downloading the Podman Windows installer. The Windows installer is built with each Podman release and can be downloaded from the official [GitHub release page](https://github.com/containers/podman/releases). Be sure to download a 4.1 or later release for the capabilities discussed in this guide.
安装 Windows Podman 客户端首先要下载 Podman Windows 安装程序。Windows 安装程序是随每个 Podman 版本一起构建的，可以从官方 GitHub 发布页面下载。请务必下载 4.1 或更高版本，了解本指南中讨论的功能。

[![Installing Podman 4.1.0](https://github.com/containers/podman/raw/main/docs/tutorials/podman-win-install.jpg)](https://github.com/containers/podman/blob/main/docs/tutorials/podman-win-install.jpg)

Once downloaded, simply run the EXE file, and relaunch a new terminal. After this point, podman.exe will be present on your PATH, and you will be able to run the `podman machine init` command to create your first machine.
下载后，只需运行EXE文件，然后重新启动新终端。在此之后，podman.exe将出现在您的 PATH 上，您将能够运行命令 `podman machine init` 来创建您的第一台计算机。

```
PS C:\Users\User> podman machine init
```

## Automatic WSL Installation 自动 WSL 安装



If WSL has not been installed on your system, the first machine init command will prompt a dialog to begin an automated install. If accepted, this process will install the necessary Windows components, restart the system, and after login, relaunch the machine creation process in a terminal window. Be sure to wait a minute or two for the relaunch to occur, as Windows has a delay before executing startup items. Alternatively, you can decline automatic installation and install WSL manually. However, this will require additional download and setup time.
如果系统上尚未安装 WSL，则第一个计算机初始化命令将提示一个对话框以开始自动安装。如果被接受，此过程将安装必要的 Windows  组件，重新启动系统，并在登录后，在终端窗口中重新启动计算机创建过程。请务必等待一两分钟以重新启动，因为 Windows  在执行启动项之前会有延迟。或者，可以拒绝自动安装并手动安装 WSL。但是，这将需要额外的下载和设置时间。

## Machine Init Process 机器初始化进程



After WSL is installed, the init command will install a minimal installation of Fedora, customizing it to run podman.
安装 WSL 后，init 命令将安装 Fedora 的最小安装，并对其进行自定义以运行 podman。

```
PS C:\Users\User> podman machine init
Extracting compressed file
Importing operating system into WSL (this may take 5+ minutes on a new WSL install)...
Installing packages (this will take a while)...
Complete!
Configuring system...
Generating public/private ed25519 key pair.
Your identification has been saved in podman-machine-default
Your public key has been saved in podman-machine-default.pub
The key fingerprint is:
SHA256:RGTGg2Q/LX7ijN+mzu8+BzcS3cEWP6Hir6pYllJtceA root@WINPC
Machine init complete
To start your machine run:

        podman machine start
```

​    

## Starting Machine 起动机



After the machine init process completes, it can then be started and stopped as desired:
在计算机初始化过程完成后，可以根据需要启动和停止它：

```
PS C:\Users\User> podman machine start

Starting machine "podman-machine-default"

This machine is currently configured in rootless mode. If your containers
require root permissions (e.g. ports < 1024), or if you run into compatibility
issues with non-podman clients, you can switch using the following command:

        podman machine set --rootful

API forwarding listening on: npipe:////./pipe/docker_engine

Docker API clients default to this address. You do not need to set DOCKER_HOST.
Machine "podman-machine-default" started successfully
```

​    

## First Podman Command 第一个 Podman 命令



From this point on, podman commands operate similarly to how they would on Linux.
从现在开始，podman 命令的操作方式与在 Linux 上的操作方式类似。

For a quick working example with a small image, you can run the Linux date command on PowerShell.
对于使用小图像的快速工作示例，可以在 PowerShell 上运行 Linux date 命令。

```
PS C:\Users\User> podman run ubi8-micro date
Thu May 5 21:56:42 UTC 2022
```

​    

## Port Forwarding 端口转发



Port forwarding also works as expected; ports will be bound against localhost (127.0.0.1). Note: When running as rootless (the default), you must use a port greater than 1023. See the Rootful and Rootless section for more details.
端口转发也按预期工作;端口将绑定到 localhost （127.0.0.1）。注意：以无根（默认）运行时，必须使用大于 1023 的端口。有关更多详细信息，请参阅 Rootful 和 Rootless 部分。

To launch httpd, you can run:
要启动 httpd，您可以运行：

```
PS C:\Users\User> podman run --rm -d -p 8080:80 --name httpd docker.io/library/httpd
f708641300564a6caf90c145e64cd852e76f77f6a41699478bb83a162dceada9
```

​    

A curl command against localhost on the PowerShell prompt will return a successful HTTP response:
在 PowerShell 提示符下针对 localhost 的 curl 命令将返回成功的 HTTP 响应：

```
PS C:\Users\User> curl http://localhost:8080/ -UseBasicParsing

StatusCode : 200
StatusDescription : OK
Content : <html><body><h1>It works!</h1></body></html>
```

​    

As with Linux, to stop, run:
与 Linux 一样，要停止，请运行：

```
podman stop httpd
```

## Using API Forwarding 使用 API 转发



API forwarding allows Docker API tools and clients to use podman as if it was Docker. Provided there is no other service listening on the Docker API pipe; no special settings will be required.
API 转发允许 Docker API 工具和客户端像使用 Docker 一样使用 podman。前提是 Docker API 管道上没有其他服务监听;无需特殊设置。

```
PS C:\Users\User> .\docker.exe run -it fedora echo "Hello Podman!"
Hello Podman!
```

​    

Otherwise, after starting the machine, you will be notified of an environment variable you can set for tools to point to podman. Alternatively, you can shut down both the conflicting service and podman, then finally run `podman machine start` to restart, which should grab the Docker API address.
否则，在启动机器后，您将收到一个环境变量的通知，您可以为工具设置指向 podman。或者，您可以关闭冲突的服务和 podman，然后最后运行 `podman machine start` 以重新启动，这应该会获取 Docker API 地址。

```
Another process was listening on the default Docker API pipe address.
You can still connect Docker API clients by setting DOCKER HOST using the
following PowerShell command in your terminal session:

        $Env:DOCKER_HOST = 'npipe:////./pipe/podman-machine-default'

Or in a classic CMD prompt:

        set DOCKER_HOST=npipe:////./pipe/podman-machine-default

Alternatively, terminate the other process and restart podman machine.
Machine "podman-machine-default" started successfully

PS C:\Users\User> $Env:DOCKER_HOST = 'npipe:////./pipe/podman-machine-default'
PS C:\Users\User>.\docker.exe version --format '{{(index .Server.Components 0).Name}}'
Podman Engine
```

​    

## Rootful & Rootless 有根的和无根的



On the embedded WSL Linux distro, podman can either be run under the root user (rootful) or a non-privileged user (rootless). For behavioral consistency with Podman on Linux, rootless is the default. Note: Rootful and Rootless containers are distinct and isolated from one another. Podman commands against one (e.g., podman ps) will not represent results/state for the other.
在嵌入式 WSL Linux 发行版上，podman 可以在 root 用户 （rootful） 或非特权用户 （rootless） 下运行。为了与  Linux 上的 Podman 保持一致，默认为 rootless。注意：Rootful 和 Rootless  容器是不同的，并且彼此隔离。针对一个的 Podman 命令（例如，podman ps）不会表示另一个的结果/状态。

While most containers run fine in a rootless setting, you may find a case where the container only functions with root privileges. If this is the case, you can switch the machine to rootful by stopping it and using the set command:
虽然大多数容器在无根设置中运行良好，但您可能会发现容器仅以 root 权限运行的情况。如果是这种情况，您可以通过停止机器并使用 set 命令将机器切换到 rootful：

```
podman machine stop
podman machine set --rootful
```

​    

To restore rootless execution, set rootful to false:
要恢复无根执行，请将 rootful 设置为 false：

```
podman machine stop
podman machine set --rootful=false
```

​    

Another case in which you may wish to use rootful execution is binding a port less than 1024. However, future versions of podman will likely drop this to a lower number to improve compatibility with defaults on system port services (such as MySQL)
您可能希望使用 rootful 执行的另一种情况是绑定小于 1024 的端口。但是，podman 的未来版本可能会将其降低到较低的数字，以提高与系统端口服务（例如 MySQL）上的默认值的兼容性

## Volume Mounting 卷挂载



New in Podman v4.1 is the ability to perform volume mounts from Windows paths into a Linux container. This supports several notation schemes, including:
Podman v4.1 的新功能是能够从 Windows 路径到 Linux 容器中执行卷挂载。这支持多种表示法方案，包括：

Windows Style Paths: Windows 样式路径：

```
podman run --rm -v c:\Users\User\myfolder:/myfolder ubi8-micro ls /myfolder
```

Unixy Windows Paths: Unixy Windows 路径：

```
podman run --rm -v /c/Users/User/myfolder:/myfolder ubi8-micro ls /myfolder
```

Linux paths local to the WSL filesystem:
WSL 文件系统的本地 Linux 路径：

```
podman run --rm -v /var/myfolder:/myfolder ubi-micro ls /myfolder
```

All of the above conventions work, whether running on a Windows prompt or the WSL Linux shell. Although when using Windows paths on Linux, appropriately quote or escape the Windows path portion of the argument.
无论是在 Windows 提示符下运行还是在 WSL Linux shell 上运行，上述所有约定都有效。尽管在 Linux 上使用 Windows 路径时，请适当地引用或转义参数的 Windows 路径部分。

## Listing Podman Machine(s) 列出 Podman 机器



To list the available podman machine instances and their current resource usage, use the `podman machine ls` command:
要列出可用的 podman 计算机实例及其当前资源使用情况，请使用以下 `podman machine ls` 命令：

```
PS C:\Users\User> podman machine ls


NAME                    VM TYPE     CREATED      LAST UP            CPUS        MEMORY      DISK SIZE
podman-machine-default  wsl         2 hours ago  Currently running  4           331.1MB     768MB
```

​    

Since WSL shares the same virtual machine and Linux kernel across multiple distributions, the CPU and Memory values represent the total resources shared across running systems. The opposite applies to the Disk value. It is independent and represents the amount of storage for each individual distribution.
由于 WSL 在多个分发版中共享相同的虚拟机和 Linux 内核，因此 CPU 和内存值表示在正在运行的系统中共享的总资源。相反的情况适用于 Disk 值。它是独立的，表示每个单独分布的存储量。

## Accessing the Podman Linux Environment 访问 Podman Linux 环境



While using the podman.exe client on the Windows environment provides a seamless native experience supporting the usage of local desktop tools and APIs, there are a few scenarios in which you may wish to access the Linux environment:
虽然在 Windows 环境中使用 podman.exe 客户端可提供支持本地桌面工具和 API 的无缝本机体验，但在以下几种情况下，您可能希望访问 Linux 环境：

- Updating to the latest stable packages on the embedded Fedora instance
  在嵌入式 Fedora 实例上更新到最新的稳定程序包
- Using Linux development tools directly
  直接使用 Linux 开发工具
- Using a workflow that relies on EXT4 filesystem performance or behavior semantics
  使用依赖于 EXT4 文件系统性能或行为语义的工作流

There are three mechanisms to access the embedded WSL distribution:
有三种机制可以访问嵌入式 WSL 分发版：

1. SSH using `podman machine ssh` 使用 SSH `podman machine ssh` 
2. WSL command on the Windows PowerShell prompt
   Windows PowerShell 提示符上的 WSL 命令
3. Windows Terminal Integration
   Windows 终端集成

### Using SSH 使用 SSH



SSH access provides a similar experience as Podman on Mac. It immediately drops you into the appropriate user based on your machine's rootful/rootless configuration (root in the former, 'user' in the latter). The --username option can be used to override with a specific user.
SSH 访问提供与 Mac 上的 Podman 类似的体验。它会立即根据您机器的有根/无根配置（前者为 root，后者为“user”）将您放入适当的用户。--username 选项可用于覆盖特定用户。

An example task using SSH is updating your Linux environment to pull down the latest OS bugfixes:
使用 SSH 的一个示例任务是更新 Linux 环境以拉取最新的操作系统错误修复：

```
podman machine ssh sudo dnf upgrade -y
```

### Using the WSL Command 使用 WSL 命令



The `wsl` command provides direct access to the Linux system but enters the shell as root first. This is due to design limitations of WSL, where running systemd (Linux's system services) requires the usage of a privileged process namespace.
该 `wsl` 命令提供对 Linux 系统的直接访问，但首先以 root 身份进入 shell。这是由于 WSL 的设计限制，其中运行 systemd（Linux 的系统服务）需要使用特权进程命名空间。

Unless you have no other distributions of WSL installed, it's recommended to use the `-d` option with the name of your podman machine (podman-machine-default is the default)
除非未安装其他 WSL 发行版，否则建议将该 `-d` 选项与 podman 计算机的名称一起使用（默认为 podman-machine-default）

```
PS C:\Users\User> wsl -d podman-machine-default
```

​    

You will be automatically entered into a nested process namespace where systemd is running. If you need to access the parent namespace, hit `ctrl-d` or type exit. This also means to log out, you need to exit twice.
您将自动进入运行 systemd 的嵌套进程命名空间。如果需要访问父命名空间，请点击 `ctrl-d` 或键入 exit。这也意味着要注销，您需要退出两次。

```
[root@WINPC /]# podman --version
podman version 4.1.0
```

​    

To access commands as the non-privileged user (rootless podman), you must first type `su user`. Alternatively, you can prefix the `wsl` command to use the special `enterns`:
要以非特权用户 （无根 podman） 身份访问命令，必须先键入 `su user` 。或者，您可以在 `wsl` 命令前面加上前缀以使用特殊 `enterns` ：

```
wsl -d podman-machine-default enterns su user
[user@WINPC /]$ id
uid=1000(user) gid=1000(user) groups=1000(user),10(wheel)
```

​    

Likewise, running commands as root without entering a prompt should also be prefixed with `enterns`.
同样，在不输入提示符的情况下以 root 身份运行命令也应以 `enterns` 为前缀。

```
wsl -d podman-machine-default enterns systemctl status
```

Accessing the WSL instance as a specific user using `wsl -u` or using inline commands without `enterns` is not recommended since commands will execute against the incorrect namespace.
不建议使用 `wsl -u` 内联命令作为特定用户访问 WSL 实例，也不建议使用内联命令，因为 `enterns` 命令将针对不正确的命名空间执行。

### Using Windows Terminal Integration 使用 Windows 终端集成



Entering WSL as root is a 2-click operation. Simply click the drop-down tag, and pick 'podman-machine-default,' where you will be entered directly as root.
以 root 身份输入 WSL 只需单击 2 次即可。只需单击下拉标签，然后选择“podman-machine-default”，您将直接以 root 身份输入。

[![Using WSL in Windows Terminal](https://github.com/containers/podman/raw/main/docs/tutorials/podman-wsl-term.jpg)](https://github.com/containers/podman/blob/main/docs/tutorials/podman-wsl-term.jpg)

As before, to switch to a non-privileged user for rootless podman commands, type `su user`.
和以前一样，要切换到无根 podman 命令的非特权用户，请键入 `su user` 。

```
[root@WINPC /]# su user
[user@WINPC /]$ podman info --format '{{.Store.RunRoot}}'
/run/user/1000/containers
```

​    

## Stopping a Podman Machine 停止 Podman 计算机



To stop a running podman machine, use the `podman machine stop` command:
要停止正在运行的 podman 计算机，请使用以下 `podman machine stop` 命令：

```
PS C:\Users\User> podman machine stop
Machine "podman-machine-default" stopped successfully
```

​    

## Removing a Podman Machine 卸下 Podman 机器



To remove a machine, use the `podman machine rm` command:
要删除计算机，请使用以下 `podman machine rm` 命令：

```
PS C:\Users\User> podman machine rm

The following files will be deleted:

C:\Users\User\.ssh\podman-machine-default
C:\Users\User\.ssh\podman-machine-default.pub
C:\Users\User\.local\share\containers\podman\machine\wsl\podman-machine-default_fedora-35-x86_64.tar
C:\Users\User\.config\containers\podman\machine\wsl\podman-machine-default.json
C:\Users\User\.local\share\containers\podman\machine\wsl\wsldist\podman-machine-default


Are you sure you want to continue? [y/N] y
```

​    

## Troubleshooting 故障 排除



Recovering from a failed auto-installation of WSL
从失败的 WSL 自动安装中恢复

If auto-install fails and retrying is unsuccessful, you can attempt to reset your WSL system state and perform a manual WSL installation using the `wsl --install` command. To do so, perform the following steps:
如果自动安装失败且重试不成功，则可以尝试重置 WSL 系统状态，并使用 `wsl --install` 命令执行手动 WSL 安装。为此，请执行以下步骤：

1. Launch PowerShell as administrator

   
   以管理员身份启动 PowerShell

   ```
   Start-Process powershell -Verb RunAs
   ```

   ​    

Disable WSL Features 禁用 WSL 功能

```
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
```

​    

Reboot 重新启动

Run manual WSL install 
运行手动 WSL 安装

```
wsl --install
```

​    

1. Continue with podman machine init
   继续使用 podman machine init

# Install Certificate Authority 安装证书颁发机构



Instructions for installing a CA certificate can be found [here](https://github.com/containers/podman/blob/main/docs/tutorials/podman-install-certificate-authority.md).
可以在此处找到安装 CA 证书的说明。





# Podman Remote clients for macOS and Windows 适用于 macOS 和 Windows 的 Podman 远程客户端



------

***NOTE:\*** For running Podman on Windows, refer to the [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md) guide, which uses the recommended approach of a Podman-managed Linux backend. For Mac, see the [Podman installation instructions](https://podman.io/getting-started/installation). This guide covers the advanced usage of Podman with a custom Linux VM or a remote external Linux system.
注意：要在 Windows 上运行 Podman，请参阅 Podman for Windows 指南，该指南使用 Podman 管理的 Linux  后端的推荐方法。对于 Mac，请参阅 Podman 安装说明。本指南介绍了 Podman 在自定义 Linux VM 或远程外部 Linux  系统中的高级用法。

------

## Introduction 介绍



The core Podman runtime environment can only run on Linux operating  systems.  But other operating systems can use the “remote client” to  manage their containers to a Linux backend.  This remote client is  nearly identical to the standard Podman program.  Certain functions that do not make sense for remote clients have been removed.  For example,  the “--latest” switch for container commands has been removed.
核心 Podman 运行时环境只能在 Linux 操作系统上运行。但其他操作系统可以使用“远程客户端”来管理其容器到 Linux  后端。此远程客户端与标准 Podman 程序几乎相同。某些对远程客户端没有意义的功能已被删除。例如，已删除容器命令的“--latest”开关。

### Brief architecture 简要架构



The remote client uses a client-server model. You need Podman installed on a Linux machine or VM that also has the SSH daemon running. On the local  operating system, when you execute a Podman command, Podman connects to  the server via SSH. It then connects to the Podman service by using  systemd socket activation. The Podman commands are executed on the  server. From the client's point of view, it seems like Podman runs  locally.
远程客户端使用客户端-服务器模型。您需要在还运行 SSH 守护程序的 Linux 计算机或 VM 上安装 Podman。在本地操作系统上，当您执行 Podman 命令时，Podman 会通过  SSH 连接到服务器。然后，它使用 systemd 套接字激活连接到 Podman 服务。Podman  命令在服务器上执行。从客户的角度来看，Podman 似乎在本地运行。

## Obtaining and installing Podman 获取并安装 Podman



### Windows 窗户



Installing the Windows Podman client begins by downloading the Podman Windows  installer. The Windows installer is built with each Podman release and  is downloadable from its [release description page](https://github.com/containers/podman/releases/latest). The Windows installer file is named `podman-#.#.#-setup.exe`, where the `#` symbols represent the version number of Podman.
安装 Windows Podman 客户端首先要下载 Podman Windows 安装程序。Windows 安装程序随每个 Podman 版本一起构建，可从其版本描述页面下载。Windows 安装程序文件名为 `podman-#.#.#-setup.exe` ，其中符号 `#` 表示 Podman 的版本号。

Once you have downloaded the installer to your Windows host, simply double  click the installer and Podman will be installed.  The path is also set  to put `podman` in the default user path.
将安装程序下载到 Windows 主机后，只需双击安装程序，Podman 就会被安装。该路径还设置为放入 `podman` 默认用户路径。

Podman must be run at a command prompt using the Windows Command Prompt (`cmd.exe`) or PowerShell (`pwsh.exe`) applications.
Podman 必须使用 Windows 命令提示符 （ `cmd.exe` ） 或 PowerShell （ `pwsh.exe` ） 应用程序在命令提示符下运行。

### macOS macOS操作系统



The Mac Client is available through [Homebrew](https://brew.sh/). You can download homebrew via the instructions on their site. Install podman using:
Mac 客户端可通过 Homebrew 获得。您可以通过他们网站上的说明下载自制软件。使用以下方法安装 podman：

```
$ brew install podman
```

​    

## Creating the first connection 创建第一个连接



### Enable the Podman service on the server machine. 在服务器计算机上启用 Podman 服务。



Before performing any  Podman client commands, you must enable the podman.sock SystemD service on the Linux server.  In these examples, we are running Podman as a normal, unprivileged user, also known as a rootless user.   By default, the rootless socket listens at  `/run/user/${UID}/podman/podman.sock`.  You can enable and start this socket permanently, using the following commands:
在执行任何 Podman 客户端命令之前，您必须在 Linux 服务器上启用 podman.sock SystemD 服务。在这些示例中，我们以普通的无特权用户（也称为无根用户）身份运行 Podman。默认情况下，无根套接字侦听 `/run/user/${UID}/podman/podman.sock` 。您可以使用以下命令永久启用和启动此套接字：

```
$ systemctl --user enable --now podman.socket
```

​    

You will need to enable linger for this user in order for the socket to work when the user is not logged in.
您需要为此用户启用 linger，以便在用户未登录时套接字能够正常工作。

```
sudo loginctl enable-linger $USER
```

​    

You can verify that the socket is listening with a simple Podman command.
您可以使用简单的 Podman 命令来验证套接字是否正在侦听。

```
$ podman --remote info
host:
  arch: amd64
  buildahVersion: 1.16.0-dev
  cgroupVersion: v2
  conmon:
	package: conmon-2.0.19-1.fc32.x86_64
```

​    

#### Enable sshd 启用 sshd



In order for the client to communicate with the server you need to enable  and start the SSH daemon on your Linux machine, if it is not currently  enabled.
为了让客户端与服务器通信，您需要在 Linux 计算机上启用并启动 SSH 守护程序（如果当前未启用）。

```
sudo systemctl enable --now sshd
```

​    

#### Setting up SSH 设置 SSH



Remote podman uses SSH to communicate between the client and server. The  remote client works considerably smoother using SSH keys. To set up your ssh connection, you need to generate an ssh key pair from your client  machine.
远程 podman 使用 SSH 在客户端和服务器之间进行通信。使用 SSH 密钥，远程客户端的工作要流畅得多。要设置 ssh 连接，您需要从客户端计算机生成 ssh 密钥对。

```
$ ssh-keygen
```

​    

Your public key by default should be in your home directory under  .ssh\id_rsa.pub. You then need to copy the contents of id_rsa.pub and  append it into  ~/.ssh/authorized_keys on the Linux  server. On a Mac,  you can automate this using ssh-copy-id.
默认情况下，您的公钥应位于主目录中的 .ssh\id_rsa.pub 下。然后，您需要复制 id_rsa.pub 的内容，并将其附加到 Linux 服务器上的  ~/.ssh/authorized_keys。在 Mac 上，您可以使用 ssh-copy-id 自动执行此操作。

If you do not wish to use SSH keys, you will be prompted with each Podman command for your login password.
如果您不想使用 SSH 密钥，系统将提示您输入每个 Podman 命令的登录密码。

## Using the client 使用客户端



The first step in using the Podman remote client is to configure a connection..
使用 Podman 远程客户端的第一步是配置连接。

You can add a connection by using the `podman system connection add` command.
您可以使用以下 `podman system connection add` 命令添加连接。

```
C:\Users\baude> podman system connection add baude --identity c:\Users\baude\.ssh\id_rsa ssh://192.168.122.1/run/user/1000/podman/podman.sock
```

​    

This will add a remote connection to Podman and if it is the first  connection added, it will mark the connection as the default.  You can  observe your connections with `podman system connection list`
这将向 Podman 添加一个远程连接，如果它是第一个添加的连接，它会将该连接标记为默认连接。您可以观察您的联系 `podman system connection list` 

```
C:\Users\baude> podman system connection list
Name	Identity 	URI
baude*	id_rsa	       ssh://baude@192.168.122.1/run/user/1000/podman/podman.sock
```

​    

Now we can test the connection with `podman info`.
现在我们可以测试与 `podman info` 的连接。

```
C:\Users\baude> podman info
host:
  arch: amd64
  buildahVersion: 1.16.0-dev
  cgroupVersion: v2
  conmon:
	package: conmon-2.0.19-1.fc32.x86_64
```

​    

Podman has also introduced a “--connection” flag where you can use other  connections you have defined.  If no connection is provided, the default connection will be used.
Podman 还引入了一个“--connection”标志，您可以在其中使用已定义的其他连接。如果未提供任何连接，将使用默认连接。

```
C:\Users\baude> podman system connection --help
```

​    

## Wrap up 㯱



You can use the podman remote clients to manage your containers running on a Linux server.  The communication between client and server relies  heavily on SSH connections and the use of SSH keys are encouraged.  Once you have Podman installed on your remote client, you should set up a  connection using   `podman system connection add` which will then be used by subsequent Podman commands.
您可以使用 podman 远程客户端来管理在 Linux 服务器上运行的容器。客户端和服务器之间的通信严重依赖于 SSH 连接，并且鼓励使用 SSH 密钥。在远程客户端上安装 Podman 后，您应该设置一个连接，然后后续的 Podman 命令将使用 `podman system connection add` 该连接。

## History 历史



Originally published on [Red Hat Enable Sysadmin](https://www.redhat.com/sysadmin/podman-clients-macos-windows)
最初发表于 Red Hat Enable Sysadmin



# How to sign and distribute container images using Podman 如何使用 Podman 对容器镜像进行签名和分发



Signing container images originates from the motivation of trusting only dedicated image providers to mitigate man-in-the-middle (MITM) attacks or attacks on container registries. One way to sign images is to utilize a GNU Privacy Guard ([GPG](https://gnupg.org)) key. This technique is generally compatible with any OCI compliant container registry like [Quay.io](https://quay.io). It is worth mentioning that the OpenShift integrated container registry supports this signing mechanism out of the box, which makes separate signature storage unnecessary.
对容器镜像进行签名源于仅信任专用镜像提供商的动机，以缓解中间人 （MITM） 攻击或对容器注册表的攻击。对图像进行签名的一种方法是使用 GNU 隐私卫士 （GPG） 密钥。此技术通常与任何符合 OCI  的容器注册表（如 Quay.io）兼容。值得一提的是，OpenShift 集成容器注册表支持这种开箱即用的签名机制，使得不需要单独的签名存储。

From a technical perspective, we can utilize Podman to sign the image before pushing it into a remote registry. After that, all systems running Podman have to be configured to retrieve the signatures from a remote server, which can be any simple web server. This means that every unsigned image will be rejected during an image pull operation. But how does this work?
从技术角度来看，我们可以利用 Podman 对图像进行签名，然后再将其推送到远程注册表中。之后，必须将所有运行 Podman  的系统配置为从远程服务器检索签名，该服务器可以是任何简单的 Web  服务器。这意味着在图像拉取操作期间，每个未签名的图像都将被拒绝。但是这是如何工作的呢？

First of all, we have to create a GPG key pair or select an already locally available one. To generate a new GPG key, just run `gpg --full-gen-key` and follow the interactive dialog. Now we should be able to verify that the key exists locally:
首先，我们必须创建一个 GPG 密钥对或选择一个已经在本地可用的密钥对。要生成新的 GPG 密钥，只需运行 `gpg --full-gen-key` 并按照交互式对话框进行操作即可。现在，我们应该能够验证密钥是否存在于本地：

```
> gpg --list-keys sgrunert@suse.com
pub   rsa2048 2018-11-26 [SC] [expires: 2020-11-25]
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
uid           [ultimate] Sascha Grunert <sgrunert@suse.com>
sub   rsa2048 2018-11-26 [E] [expires: 2020-11-25]
```

​    

Now let’s assume that we run a container registry. For example we could simply start one on our local machine:
现在，我们假设我们运行一个容器注册表。例如，我们可以简单地在本地机器上启动一个：

```
sudo podman run -d -p 5000:5000 docker.io/registry
```

​    

The registry does not know anything about image signing, it just provides the remote storage for the container images. This means if we want to sign an image, we have to take care of how to distribute the signatures.
注册表对图像签名一无所知，它只是为容器图像提供远程存储。这意味着，如果我们想对图像进行签名，我们必须注意如何分发签名。

Let’s choose a standard `alpine` image for our signing experiment:
让我们为签名实验选择一个标准 `alpine` 图像：

```
sudo podman pull docker://docker.io/alpine:latest
```

​    

```
sudo podman images alpine
REPOSITORY                 TAG      IMAGE ID       CREATED       SIZE
docker.io/library/alpine   latest   e7d92cdc71fe   6 weeks ago   5.86 MB
```

​    

Now we can re-tag the image to point it to our local registry:
现在，我们可以重新标记图像以将其指向本地注册表：

```
sudo podman tag alpine localhost:5000/alpine
```

​    

```
sudo podman images alpine
REPOSITORY                 TAG      IMAGE ID       CREATED       SIZE
localhost:5000/alpine      latest   e7d92cdc71fe   6 weeks ago   5.86 MB
docker.io/library/alpine   latest   e7d92cdc71fe   6 weeks ago   5.86 MB
```

​    

Podman would now be able to push the image and sign it in one command. But to let this work, we have to modify our system-wide registries configuration at `/etc/containers/registries.d/default.yaml`:
Podman 现在能够在一个命令中推送图像并对其进行签名。但要让它工作，我们必须在以下位置 `/etc/containers/registries.d/default.yaml` 修改我们的系统范围的注册表配置：

```
default-docker:
  sigstore: http://localhost:8000 # Added by us
  sigstore-staging: file:///var/lib/containers/sigstore
```

​    

We can see that we have two signature stores configured:
我们可以看到，我们配置了两个签名存储：

- `sigstore`: referencing a web server for signature reading
   `sigstore` ：引用 Web 服务器进行签名读取
- `sigstore-staging`: referencing a file path for signature writing
   `sigstore-staging` ：引用文件路径进行签名写入

Now, let’s push and sign the image:
现在，让我们对图像进行推送和签名：

```
sudo -E GNUPGHOME=$HOME/.gnupg \
    podman push \
    --tls-verify=false \
    --sign-by sgrunert@suse.com \
    localhost:5000/alpine
…
Storing signatures
```

​    

If we now take a look at the systems signature storage, then we see that there is a new signature available, which was caused by the image push:
如果我们现在看一下系统签名存储，那么我们会看到有一个新的签名可用，这是由图像推送引起的：

```
sudo ls /var/lib/containers/sigstore
'alpine@sha256=e9b65ef660a3ff91d28cc50eba84f21798a6c5c39b4dd165047db49e84ae1fb9'
```

​    

The default signature store in our edited version of `/etc/containers/registries.d/default.yaml` references a web server listening at `http://localhost:8000`. For our experiment, we simply start a new server inside the local staging signature store:
在我们编辑的 `/etc/containers/registries.d/default.yaml` 版本中，默认签名存储引用了监听 的 `http://localhost:8000` Web 服务器。对于我们的实验，我们只需在本地暂存签名存储中启动一个新服务器：

```
sudo bash -c 'cd /var/lib/containers/sigstore && python3 -m http.server'
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

​    

Let’s remove the local images for our verification test:
让我们删除用于验证测试的本地图像：

```
sudo podman rmi docker.io/alpine localhost:5000/alpine
```

​    

We have to write a policy to enforce that the signature has to be valid. This can be done by adding a new rule in `/etc/containers/policy.json`. From the below example, copy the `"docker"` entry into the `"transports"` section of your `policy.json`.
我们必须编写一个策略来强制签名必须有效。这可以通过在 `/etc/containers/policy.json` 中添加新规则来完成。在下面的示例中，将 `"docker"` 该条目 `"transports"` 复制到 . `policy.json` 

```
{
  "default": [{ "type": "insecureAcceptAnything" }],
  "transports": {
    "docker": {
      "localhost:5000": [
        {
          "type": "signedBy",
          "keyType": "GPGKeys",
          "keyPath": "/tmp/key.gpg"
        }
      ]
    }
  }
}
```

​    

The `keyPath` does not exist yet, so we have to put the GPG key there:
目前还 `keyPath` 不存在，因此我们必须将 GPG 密钥放在那里：

```
gpg --output /tmp/key.gpg --armor --export sgrunert@suse.com
```

​    

If we now pull the image:
如果我们现在拉取图像：

```
sudo podman pull --tls-verify=false localhost:5000/alpine
…
Storing signatures
e7d92cdc71feacf90708cb59182d0df1b911f8ae022d29e8e95d75ca6a99776a
```

​    

Then we can see in the logs of the web server that the signature has been accessed:
然后我们可以在 Web 服务器的日志中看到签名已被访问：

```
127.0.0.1 - - [04/Mar/2020 11:18:21] "GET /alpine@sha256=e9b65ef660a3ff91d28cc50eba84f21798a6c5c39b4dd165047db49e84ae1fb9/signature-1 HTTP/1.1" 200 -
```

​    

As a counterpart example, if we specify the wrong key at `/tmp/key.gpg`:
作为对应的例子，如果我们在以下位置 `/tmp/key.gpg` 指定了错误的键：

```
gpg --output /tmp/key.gpg --armor --export mail@saschagrunert.de
File '/tmp/key.gpg' exists. Overwrite? (y/N) y
```

​    

Then a pull is not possible any more:
那么拉动就再也不可能了：

```
sudo podman pull --tls-verify=false localhost:5000/alpine
Trying to pull localhost:5000/alpine...
Error: pulling image "localhost:5000/alpine": unable to pull localhost:5000/alpine: unable to pull image: Source image rejected: Invalid GPG signature: …
```

​    

So in general there are four main things to be taken into consideration when signing container images with Podman and GPG:
因此，一般来说，在使用 Podman 和 GPG 签署容器镜像时，需要考虑四个主要事项：

1. We need a valid private GPG key on the signing machine and corresponding public keys on every system which would pull the image
   我们需要在签名机上有一个有效的 GPG 私钥，并且每个系统上都需要相应的公钥来拉取镜像
2. A web server has to run somewhere which has access to the signature storage
   Web 服务器必须运行在可以访问签名存储的地方
3. The web server has to be configured in any `/etc/containers/registries.d/*.yaml` file
   必须在任何 `/etc/containers/registries.d/*.yaml` 文件中配置 Web 服务器
4. Every image pulling system has to be configured to contain the enforcing policy configuration via `policy.conf`
   每个图像拉取系统都必须配置为包含通过以下方式 `policy.conf` 执行策略的配置

That’s it for image signing and GPG. The cool thing is that this setup works out of the box with [CRI-O](https://cri-o.io) as well and can be used to sign container images in Kubernetes environments.
这就是图像签名和 GPG 的全部内容。很酷的是，这种设置也可以与 CRI-O 一起开箱即用，并且可用于在 Kubernetes 环境中签署容器镜像。





# Podman remote-client tutorial Podman remote-client 教程



## Introduction 介绍



The purpose of the Podman remote-client is to allow users to interact with a Podman "backend" while on a separate client.  The command line  interface of the remote client is exactly the same as the regular Podman commands with the exception of some flags being removed as they do not  apply to the remote-client.
Podman 远程客户端的目的是允许用户在单独的客户端上与 Podman“后端”进行交互。远程客户端的命令行界面与常规的 Podman 命令完全相同，只是删除了一些标志，因为它们不适用于远程客户端。

The remote client takes advantage of a client-server model. You need Podman installed on a Linux machine or VM that also has the SSH daemon  running. On the local operating system, when you execute a Podman  command, Podman connects to the server via SSH. It then connects to the  Podman service by using systemd socket activation, and hitting our [Rest API](https://docs.podman.io/en/latest/_static/api.html). The Podman commands are executed on the server. From the client's point of view, it seems like Podman runs locally.
远程客户端利用客户端-服务器模型。您需要在还运行 SSH 守护程序的 Linux 计算机或 VM 上安装 Podman。在本地操作系统上，当您执行 Podman 命令时，Podman 会通过  SSH 连接到服务器。然后，它通过使用 systemd 套接字激活并点击我们的 Rest API 连接到 Podman 服务。Podman  命令在服务器上执行。从客户的角度来看，Podman 似乎在本地运行。

This tutorial is for running Podman remotely on Linux. If you are using a Mac or a Windows PC, please follow the [Mac and Windows tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/mac_win_client.md)
本教程用于在 Linux 上远程运行 Podman。如果您使用的是 Mac 或 Windows PC，请按照 Mac 和 Windows 教程进行操作

## Obtaining and installing Podman 获取并安装 Podman



### Client machine 客户端计算机



You will need either Podman or the podman-remote client. The difference  between the two is that the compiled podman-remote client can only act  as a remote client connecting to a backend, while Podman can run local,  standard Podman commands, as well as act as a remote client (using `podman --remote`)
您将需要 Podman 或 podman-remote 客户端。两者的区别在于，编译好的 podman-remote 客户端只能作为连接到后端的远程客户端，而 Podman 可以运行本地、标准的 Podman 命令，也可以充当远程客户端（使用 `podman --remote` ）

If you already have Podman installed, you do not need to install podman-remote.
如果您已经安装了 Podman，则无需安装 podman-remote。

You can find out how to [install Podman here](https://podman.io/getting-started/installation)
您可以在此处了解如何安装 Podman

If you would like to install only the podman-remote client, it is downloadable from its [release description page](https://github.com/containers/podman/releases/latest).  You can also build it from source using the `make podman-remote`
如果您只想安装 podman-remote 客户端，可以从其发布描述页面下载它。您也可以使用以下命令从源代码构建它。 `make podman-remote` 

### Server Machine 服务器机器



You will need to [install Podman](https://podman.io/getting-started/installation) on your server machine.
您需要在服务器计算机上安装 Podman。

## Creating the first connection 创建第一个连接



### Enable the Podman service on the server machine. 在服务器计算机上启用 Podman 服务。



Before performing any Podman client commands, you must enable the podman.sock  SystemD service on the Linux server.  In these examples, we are running  Podman as a normal, unprivileged user, also known as a rootless user.   By default, the rootless socket listens at `/run/user/${UID}/podman/podman.sock`.  You can enable this socket permanently using the following command:
在执行任何 Podman 客户端命令之前，您必须在 Linux 服务器上启用 podman.sock SystemD 服务。在这些示例中，我们以普通的无特权用户（也称为无根用户）身份运行 Podman。默认情况下，无根套接字侦听 `/run/user/${UID}/podman/podman.sock` 。您可以使用以下命令永久启用此套接字：

```
systemctl --user enable --now podman.socket
```

​    

You will need to enable linger for this user in order for the socket to work when the user is not logged in:
您需要为此用户启用 linger，以便在用户未登录时套接字正常工作：

```
sudo loginctl enable-linger $USER
```

​    

This is only required if you are not running Podman as root.
仅当您未以 root 身份运行 Podman 时，才需要这样做。

You can verify that the socket is listening with a simple Podman command.
您可以使用简单的 Podman 命令来验证套接字是否正在侦听。

```
podman --remote info
host:
  arch: amd64
  buildahVersion: 1.16.0-dev
  cgroupVersion: v2
  conmon:
	package: conmon-2.0.19-1.fc32.x86_64
```

​    

#### Enable sshd 启用 sshd



In order for the Podman client to communicate with the server you need to  enable and start the SSH daemon on your Linux machine, if it is not  currently enabled.
为了让 Podman 客户端与服务器通信，您需要在 Linux 计算机上启用并启动 SSH 守护程序（如果当前未启用）。

```
sudo systemctl enable --now sshd
```

​    

#### Setting up SSH 设置 SSH



Remote Podman uses SSH to communicate between the client and server. The  remote client works considerably smoother using SSH keys. To set up your ssh connection, you need to generate an ssh key pair from your client  machine. *NOTE:* in some instances, using a `rsa` key will cause connection issues, be sure to create an `ed25519` key.
远程 Podman 使用 SSH 在客户端和服务器之间进行通信。使用 SSH 密钥，远程客户端的工作要流畅得多。要设置 ssh 连接，您需要从客户端计算机生成 ssh 密钥对。注意：在某些情况下，使用 `rsa` 密钥会导致连接问题，请务必创建 `ed25519` 密钥。

```
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

​    

Your public key by default should be in your home directory under `~/.ssh/id_ed25519.pub`. You then need to copy the contents of `id_ed25519.pub` and append it into `~/.ssh/authorized_keys` on the Linux server. You can automate this using `ssh-copy-id`:
默认情况下，您的公钥应位于主目录下的 `~/.ssh/id_ed25519.pub` .然后，您需要复制 的内容 `id_ed25519.pub` 并将其附加到 `~/.ssh/authorized_keys` Linux 服务器上。您可以使用以下命令 `ssh-copy-id` 自动执行此操作：

```
ssh-copy-id -i ~/.ssh/id_ed25519.pub 192.168.122.1
```

​    

If you do not wish to use SSH keys, you will be prompted with each Podman command for your login password.
如果您不想使用 SSH 密钥，系统将提示您输入每个 Podman 命令的登录密码。

## Using the client 使用客户端



Note: `podman-remote` is equivalent to `podman --remote` here, depending on what you have chosen to install.
注意： `podman-remote` 等同 `podman --remote` 于此处，具体取决于您选择安装的内容。

The first step in using the Podman remote client is to configure a connection.
使用 Podman 远程客户端的第一步是配置连接。

You can add a connection by using the `podman-remote system connection add` command.
您可以使用以下 `podman-remote system connection add` 命令添加连接。

```
podman-remote system connection add myuser --identity ~/.ssh/id_ed25519 ssh://myuser@192.168.122.1/run/user/1000/podman/podman.sock
```

​    

This will add a remote connection to Podman and if it is the first  connection added, it will mark the connection as the default.  You can  observe your connections with `podman-remote system connection list`:
这将向 Podman 添加一个远程连接，如果它是第一个添加的连接，它会将该连接标记为默认连接。您可以观察您的连接 `podman-remote system connection list` ：

```
podman-remote system connection list
Name	  Identity 	       URI
myuser*	  id_ed25519	   ssh://myuser@192.168.122.1/run/user/1000/podman/podman.sock
```

​    

Now we can test the connection with `podman info`:
现在我们可以用以下命令 `podman info` 测试连接：

```
podman-remote info
host:
  arch: amd64
  buildahVersion: 1.16.0-dev
  cgroupVersion: v2
  conmon:
	package: conmon-2.0.19-1.fc32.x86_64
```

​    

Podman-remote has also introduced a “--connection” flag where you can use other  connections you have defined.  If no connection is provided, the default connection will be used.
Podman-remote 还引入了一个 “--connection” 标志，您可以在其中使用您定义的其他连接。如果未提供任何连接，将使用默认连接。

```
podman-remote system connection --help
```

​    

## Wrap up 㯱



You can use the Podman remote clients to manage your containers running on a Linux server.  The communication between client and server relies  heavily on SSH connections and the use of SSH keys are encouraged.  Once you have Podman installed on your remote client, you should set up a  connection using `podman-remote system connection add` which will then be used by subsequent Podman commands.
您可以使用 Podman 远程客户端来管理在 Linux 服务器上运行的容器。客户端和服务器之间的通信严重依赖于 SSH 连接，并且鼓励使用 SSH 密钥。在远程客户端上安装 Podman 后，您应该设置一个连接，然后后续的 Podman 命令将使用 `podman-remote system connection add` 该连接。

# Troubleshooting 故障 排除



See the [Troubleshooting](https://github.com/containers/podman/blob/main/troubleshooting.md) document if you run into issues.
如果遇到问题，请参阅故障排除文档。

## History 历史



Adapted from the [Mac and Windows tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/mac_win_client.md)
改编自 Mac 和 Windows 教程





# How to use libpod for custom/derivative projects 如何使用 libpod 进行自定义/衍生项目



libpod today is a Golang library and a CLI.  The choice of interface you make has advantages and disadvantages.
今天的 libpod 是一个 Golang 库和一个 CLI。您选择的界面有优点也有缺点。

## Using the REST API 使用 REST API



Advantages: 优势：

- Stable, versioned API 稳定的、版本化的 API
- Language-agnostic 与语言无关
- [Well-documented](http://docs.podman.io/en/latest/_static/api.html) API 有据可查的 API

Disadvantages: 弊：

- Error handling is less verbose than Golang API
  错误处理比 Golang API 更详细
- May be slower 可能速度较慢

## Running as a subprocess 作为子进程运行



Advantages: 优势：

- Many commands output JSON
  许多命令输出 JSON
- Works with languages other than Golang
  适用于 Golang 以外的语言
- Easy to get started
  易于上手

Disadvantages: 弊：

- Error handling is harder
  错误处理更难
- May be slower 可能速度较慢
- Can't hook into or control low-level things like how images are pulled
  无法挂钩或控制低级事物，例如图像的拉取方式

## Vendoring into a Go project 向 Go 项目提供供应商



Advantages: 优势：

- Significant power and control
  强大的动力和控制力

Disadvantages: 弊：

- You are now on the hook for container runtime security updates (partially, `runc`/`crun` are separate)
  您现在正处于容器运行时安全更新的钩子上（部分， `runc` / `crun` 是单独的）
- Binary size 二进制大小
- Potential skew between multiple libpod versions operating on the same storage can cause problems
  在同一存储上运行的多个 libpod 版本之间可能存在的偏差可能会导致问题

## Making the choice 做出选择



A good question to ask first is: Do you want users to be able to use `podman` to manipulate the containers created by your project? If so, that makes it more likely that you want to run `podman` as a subprocess or using the HTTP API.  If you want a separate image store and a fundamentally different experience; if what you're doing with containers is quite different from those created by the `podman` CLI, that may drive you towards vendoring.
首先要问的一个好问题是：您是否希望用户能够用来 `podman` 操作您的项目创建的容器？如果是这样，那么您更有可能希望作为子进程或使用 HTTP API 运行 `podman` 。如果您想要一个单独的图片商店和根本不同的体验;如果您使用容器的操作与 CLI 创建的 `podman` 容器完全不同，这可能会促使您转向供应商。





# Podman Golang bindings Podman Golangs



The Podman Go bindings are a set of functions to allow developers to  execute Podman operations from within their Go based application. The Go bindings connect to a Podman service which can run locally or on a remote  machine. You can perform many operations including pulling and listing  images, starting, stopping or inspecting containers. Currently, the Podman repository has  bindings available for operations on images, containers, pods, networks and manifests among others.
Podman Go 绑定是一组函数，允许开发人员从其基于 Go 的应用程序内执行 Podman 操作。Go 绑定连接到 Podman  服务，该服务可以在本地运行，也可以在远程计算机上运行。您可以执行许多操作，包括拉取和列出图像、启动、停止或检查容器。目前，Podman  存储库具有可用于对映像、容器、Pod、网络和清单等进行操作的绑定。

## Quick Start 快速上手



The bindings require that the Podman system service is running for the specified user.  This can be done with systemd using the `systemctl` command or manually by calling the service directly.
绑定要求 Podman 系统服务正在为指定用户运行。这可以通过 systemd 使用命令来完成， `systemctl` 也可以通过直接调用服务来手动完成。

### Starting the service with system 使用系统启动服务



The command to start the Podman service differs slightly depending on the  user that is running the service.  For a rootful service, start the service like this:
启动 Podman 服务的命令会略有不同，具体取决于运行该服务的用户。对于 rootful 服务，请像这样启动服务：

```
# systemctl start podman.socket
```

​    

For a non-privileged, aka rootless, user, start the service like this:
对于非特权用户（也称为无根用户），请像这样启动服务：

```
$ systemctl start --user podman.socket
```

​    

### Starting the service manually 手动启动服务



It can be handy to run the system service manually.  Doing so allows you to enable debug messaging.
手动运行系统服务可以很方便。这样，您就可以启用调试消息传递。

```
$ podman --log-level=debug system service -t0
```

​    

If you do not provide a specific path for the socket, a default is provided.  The location of that socket for rootful connections is `/run/podman/podman.sock` and for rootless it is `/run/user/USERID#/podman/podman.sock`. For more information about the Podman system service, see `man podman-system-service`.
如果未为套接字提供特定路径，则提供默认值。对于有根连接的套接字的位置是 `/run/podman/podman.sock` ，对于无根连接，它是 `/run/user/USERID#/podman/podman.sock` 。有关 Podman 系统服务的更多信息，请参阅 `man podman-system-service` 。

### Creating a connection 创建连接



Ensure the [required dependencies](https://podman.io/getting-started/installation#build-and-run-dependencies) are installed, as they will be required to compile a Go program making use of the bindings.
确保已安装所需的依赖项，因为编译使用绑定的 Go 程序将需要它们。

The first step for using the bindings is to create a connection to the socket.  As mentioned earlier, the destination of the socket depends on the user who owns it. In this case, a rootful connection is made.
使用绑定的第一步是创建与套接字的连接。如前所述，套接字的目标取决于拥有它的用户。在这种情况下，将建立根连接。

```
import (
	"context"
	"fmt"
	"os"

	"github.com/containers/podman/v5/pkg/bindings"
)

func main() {
	conn, err := bindings.NewConnection(context.Background(), "unix:///run/podman/podman.sock")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

}
```

​    

The `conn` variable returned from the `bindings.NewConnection` function can then be used in subsequent function calls to interact with containers.
然后，可以在后续函数调用中使用从函数返回的 `conn`  `bindings.NewConnection` 变量来与容器进行交互。

### Examples 例子



The following examples build upon the connection example from above.  They are all rootful connections as well.
以下示例基于上面的连接示例。它们也是根深蒂固的联系。

Note: Optional arguments to the bindings methods are set using With*() methods on *Option structures. Composite types are not duplicated rather the address is used. As such, you should not change an underlying field between initializing the *Option structure and calling the bindings method.
注意：绑定方法的可选参数是在 *Option 结构上使用 With*（） 方法设置的。复合类型不会重复，而是使用地址。因此，不应在初始化 *Option 结构和调用绑定方法之间更改基础字段。

#### Inspect a container 检查容器



The following example obtains the inspect information for a container named `foorbar` and then prints the container's ID. Note the use of optional inspect options for size.
以下示例获取名为 `foorbar` 该容器的 inspect 信息，然后打印该容器的 ID。 请注意，使用可选的 inspect 选项来衡量大小。

```
import (
	"context"
	"fmt"
	"os"

	"github.com/containers/podman/v5/pkg/bindings"
	"github.com/containers/podman/v5/pkg/bindings/containers"
)

func main() {
	conn, err := bindings.NewConnection(context.Background(), "unix:///run/podman/podman.sock")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	inspectData, err := containers.Inspect(conn, "foobar", new(containers.InspectOptions).WithSize(true))
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	// Print the container ID
	fmt.Println(inspectData.ID)
}
```

​    

#### Pull an image 拉取镜像



The following example pulls the image `quay.ioo/libpod/alpine_nginx` to the local image store.
以下示例将图像 `quay.ioo/libpod/alpine_nginx` 拉取到本地图像存储中。

```
import (
	"context"
	"fmt"
	"os"

	"github.com/containers/podman/v5/pkg/bindings"
	"github.com/containers/podman/v5/pkg/bindings/images"
)

func main() {
	conn, err := bindings.NewConnection(context.Background(), "unix:///run/podman/podman.sock")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	_, err = images.Pull(conn, "quay.io/libpod/alpine_nginx", nil)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
```

​    

#### Pull an image, create a container, and start the container 拉取镜像，创建容器，并启动容器



The following example pulls the `quay.io/libpod/alpine_nginx` image and then creates a container named `foobar` from it.  And finally, it starts the container.
以下示例拉取映像， `quay.io/libpod/alpine_nginx` 然后从该映像创建一个名为该映像的 `foobar` 容器。最后，它启动容器。

```
import (
	"context"
	"fmt"
	"os"

	"github.com/containers/podman/v5/pkg/bindings"
	"github.com/containers/podman/v5/pkg/bindings/containers"
	"github.com/containers/podman/v5/pkg/bindings/images"
	"github.com/containers/podman/v5/pkg/specgen"
)

func main() {
	conn, err := bindings.NewConnection(context.Background(), "unix:///run/podman/podman.sock")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	_, err = images.Pull(conn, "quay.io/libpod/alpine_nginx", nil)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	s := specgen.NewSpecGenerator("quay.io/libpod/alpine_nginx", false)
	s.Name = "foobar"
	createResponse, err := containers.CreateWithSpec(conn, s, nil)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Container created.")
	if err := containers.Start(conn, createResponse.ID, nil); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Container started.")
}
```

​    

## Debugging tips  调试提示



To debug in a development setup, you can start the Podman system service in debug mode like:
要在开发设置中进行调试，您可以在调试模式下启动 Podman 系统服务，如下所示：

```
$ podman --log-level=debug system service -t 0
```

​    

The `--log-level=debug` echoes all the logged requests and is useful to trace the execution path at a finer granularity. A snippet of a sample run looks like:
回 `--log-level=debug` 显所有记录的请求，对于更精细地跟踪执行路径非常有用。示例运行的代码片段如下所示：

```
INFO[0000] podman filtering at log level debug
DEBU[0000] Called service.PersistentPreRunE(podman --log-level=debug system service -t0)
DEBU[0000] Ignoring libpod.conf EventsLogger setting "/home/lsm5/.config/containers/containers.conf". Use "journald" if you want to change this setting and remove libpod.conf files.
DEBU[0000] Reading configuration file "/usr/share/containers/containers.conf"
DEBU[0000] Merged system config "/usr/share/containers/containers.conf": {Editors note: the remainder of this line was removed due to Jekyll formatting errors.}
DEBU[0000] Using conmon: "/usr/bin/conmon"
DEBU[0000] Initializing boltdb state at /home/lsm5/.local/share/containers/storage/libpod/bolt_state.db
DEBU[0000] Overriding run root "/run/user/1000/containers" with "/run/user/1000" from database
DEBU[0000] Using graph driver overlay
DEBU[0000] Using graph root /home/lsm5/.local/share/containers/storage
DEBU[0000] Using run root /run/user/1000
DEBU[0000] Using static dir /home/lsm5/.local/share/containers/storage/libpod
DEBU[0000] Using tmp dir /run/user/1000/libpod/tmp
DEBU[0000] Using volume path /home/lsm5/.local/share/containers/storage/volumes
DEBU[0000] Set libpod namespace to ""
DEBU[0000] Not configuring container store
DEBU[0000] Initializing event backend file
DEBU[0000] using runtime "/usr/bin/runc"
DEBU[0000] using runtime "/usr/bin/crun"
WARN[0000] Error initializing configured OCI runtime kata: no valid executable found for OCI runtime kata: invalid argument
DEBU[0000] using runtime "/usr/bin/crun"
INFO[0000] Setting parallel job count to 25
INFO[0000] podman filtering at log level debug
DEBU[0000] Called service.PersistentPreRunE(podman --log-level=debug system service -t0)
DEBU[0000] Ignoring libpod.conf EventsLogger setting "/home/lsm5/.config/containers/containers.conf". Use "journald" if you want to change this setting and remove libpod.conf files.
DEBU[0000] Reading configuration file "/usr/share/containers/containers.conf"
```

​    

If the Podman system service has been started via systemd socket activation, you can view the logs using journalctl. The logs after a sample run look like:
如果 Podman 系统服务是通过 systemd 套接字激活启动的，则可以使用 journalctl 查看日志。样本运行后的日志如下所示：

```
$ journalctl --user --no-pager -u podman.socket
-- Reboot --
Jul 22 13:50:40 nagato.nanadai.me systemd[1048]: Listening on Podman API Socket.
$
```

​    

```
$ journalctl --user --no-pager -u podman.service
Jul 22 13:50:53 nagato.nanadai.me systemd[1048]: Starting Podman API Service...
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume 38480630a8bdaa3e1a0ebd34c94038591b0d7ad994b37be5b4f2072bb6ef0879: error acquiring lock 0 for volume 38480630a8bdaa3e1a0ebd34c94038591b0d7ad994b37be5b4f2072bb6ef0879: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume 47d410af4d762a0cc456a89e58f759937146fa3be32b5e95a698a1d4069f4024: error acquiring lock 0 for volume 47d410af4d762a0cc456a89e58f759937146fa3be32b5e95a698a1d4069f4024: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume 86e73f082e344dad38c8792fb86b2017c4f133f2a8db87f239d1d28a78cf0868: error acquiring lock 0 for volume 86e73f082e344dad38c8792fb86b2017c4f133f2a8db87f239d1d28a78cf0868: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume 9a16ea764be490a5563e384d9074ab0495e4d9119be380c664037d6cf1215631: error acquiring lock 0 for volume 9a16ea764be490a5563e384d9074ab0495e4d9119be380c664037d6cf1215631: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume bfd6b2a97217f8655add13e0ad3f6b8e1c79bc1519b7a1e15361a107ccf57fc0: error acquiring lock 0 for volume bfd6b2a97217f8655add13e0ad3f6b8e1c79bc1519b7a1e15361a107ccf57fc0: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: time="2020-07-22T13:50:54-04:00" level=error msg="Error refreshing volume f9b9f630982452ebcbed24bd229b142fbeecd5d4c85791fca440b21d56fef563: error acquiring lock 0 for volume f9b9f630982452ebcbed24bd229b142fbeecd5d4c85791fca440b21d56fef563: file exists"
Jul 22 13:50:54 nagato.nanadai.me podman[1527]: Trying to pull registry.fedoraproject.org/fedora:latest...
Jul 22 13:50:55 nagato.nanadai.me podman[1527]: Getting image source signatures
Jul 22 13:50:55 nagato.nanadai.me podman[1527]: Copying blob sha256:dd9f43919ba05f05d4f783c31e83e5e776c4f5d29dd72b9ec5056b9576c10053
Jul 22 13:50:55 nagato.nanadai.me podman[1527]: Copying config sha256:00ff39a8bf19f810a7e641f7eb3ddc47635913a19c4996debd91fafb6b379069
Jul 22 13:50:55 nagato.nanadai.me podman[1527]: Writing manifest to image destination
Jul 22 13:50:55 nagato.nanadai.me podman[1527]: Storing signatures
Jul 22 13:50:55 nagato.nanadai.me systemd[1048]: podman.service: unit configures an IP firewall, but not running as root.
Jul 22 13:50:55 nagato.nanadai.me systemd[1048]: (This warning is only shown for the first unit using IP firewalling.)
Jul 22 13:51:15 nagato.nanadai.me systemd[1048]: podman.service: Succeeded.
Jul 22 13:51:15 nagato.nanadai.me systemd[1048]: Finished Podman API Service.
Jul 22 13:51:15 nagato.nanadai.me systemd[1048]: podman.service: Consumed 1.339s CPU time.
$
```

​    

You can also verify that the information being passed back and forth is correct by putting with a tool like `socat`, which can dump what the socket is seeing.
您还可以通过使用类似 `socat` 的工具来验证来回传递的信息是否正确，该工具可以转储套接字所看到的内容。

## Reducing Binary Size with "remote" Build Tag 使用“远程”构建标签减小二进制文件大小



When building a program that uses the Podman Go bindings, you can reduce the binary size by passing the "remote" build tag to the go build command.  This tag excludes code related to local Podman operations, which is not needed for applications that only interact with Podman over a network.
在构建使用 Podman Go 绑定的程序时，您可以通过将“remote”构建标记传递给 go build 命令来减小二进制文件的大小。此标记不包括与本地 Podman 操作相关的代码，对于仅通过网络与 Podman 交互的应用程序来说，不需要这些代码。



# Basic Networking Guide for Podman Podman 基本网络指南



It seems once people understand the basics of containers, networking is one of the first aspects they begin experimenting with.  And regarding networking, it takes very little experimentation before ending up on the deep end of the pool.  The following guide shows the most common network setups for Podman rootful and rootless containers. Each setup is supported with an example.
似乎一旦人们了解了容器的基础知识，网络就是他们开始尝试的第一个方面。关于网络，在最终进入游泳池的深处之前，只需要很少的实验。以下指南显示了 Podman 有根和无根容器的最常见网络设置。每个设置都通过一个示例得到支持。

## Differences between rootful and rootless container networking 有根容器网络和无根容器网络的区别



One of the guiding factors on networking for containers with Podman is going to be whether or not the container is run by a root user or not. This is because unprivileged users cannot create networking interfaces on the host. Therefore, for rootless containers, the default network mode is slirp4netns. Because of the limited privileges, slirp4netns lacks some of the features of networking compared to rootful Podman's networking; for example, slirp4netns cannot give containers a routable IP address. The default networking mode for rootful containers on the other side is netavark, which allows a container to have a routable IP address.
使用 Podman 对容器进行联网的指导因素之一是容器是否由 root  用户运行。这是因为非特权用户无法在主机上创建网络接口。因此，对于无根容器，默认的网络模式是 slirp4netns。由于权限有限，与  rootful Podman 的网络相比，slirp4netns 缺少一些网络功能;例如，slirp4netns 无法为容器提供可路由的 IP  地址。另一边的rootful容器的默认组网模式是netavark，它允许容器有一个可路由的IP地址。

## Firewalls 防火墙



The role of a firewall will not impact the setup and configuration of networking, but it will impact traffic on those networks.  The most obvious is inbound network traffic to the container host, which is being passed onto containers usually with port mapping.  Depending on the firewall implementation, we have observed firewall ports being opened automatically due to running a container with a port mapping (for example).  If container traffic does not seem to work properly, check the firewall and allow traffic on ports the container is using. A common problem is that reloading the firewall deletes the netavark iptables rules resulting in a loss of network connectivity for rootful containers. Podman v3 provides the podman network reload command to restore this without having to restart the container.
防火墙的角色不会影响网络的设置和配置，但会影响这些网络上的流量。最明显的是到容器主机的入站网络流量，该流量通常通过端口映射传递到容器上。根据防火墙的实现，我们观察到防火墙端口由于运行具有端口映射的容器（例如）而自动打开。如果容器流量似乎无法正常工作，请检查防火墙并允许容器正在使用的端口上的流量。一个常见的问题是，重新加载防火墙会删除 netavark iptables 规则，从而导致 rootful 容器的网络连接丢失。Podman v3 提供了 podman  network reload 命令来恢复此命令，而无需重新启动容器。

## Basic Network Setups 基本网络设置



Most containers and pods being run with Podman adhere to a couple of simple scenarios. By default, rootful Podman will create a bridged network.  This is the most straightforward and preferred network setup for Podman. Bridge networking creates an interface for the container on an internal bridge network, which is then connected to the internet via Network Address Translation(NAT).  We also see users wanting to use `macvlan` for networking as well. The `macvlan` plugin forwards an entire network interface from the host into the container, allowing it access to the network the host is connected to. And finally, the default network configuration for rootless containers is slirp4netns. The slirp4netns network mode has limited capabilities but can be run on users without root privileges. It creates a tunnel from the host into the container to forward traffic.
使用 Podman 运行的大多数容器和 Pod 都遵循几个简单的场景。默认情况下，rootful Podman 将创建一个桥接网络。这是  Podman 最直接和首选的网络设置。桥接网络在内部桥接网络上为容器创建一个接口，然后通过网络地址转换 （NAT） 将其连接到  Internet。我们还看到用户也想用于 `macvlan` 网络。该 `macvlan` 插件将整个网络接口从主机转发到容器中，从而允许其访问主机所连接的网络。最后，无根容器的默认网络配置是 slirp4netns。slirp4netns 网络模式的功能有限，但可以在没有 root 权限的用户上运行。它创建一条从主机到容器的隧道，以转发流量。

### Bridge 桥



A bridge network is defined as an internal network is created where both the container and host are attached.  Then this network is capable of allowing the containers to communicate outside the host.
桥接网络被定义为创建内部网络，其中容器和主机都连接在一起。然后，该网络能够允许容器在主机外部进行通信。

[![bridge_network](https://github.com/containers/podman/raw/main/docs/tutorials/podman_bridge.png)](https://github.com/containers/podman/blob/main/docs/tutorials/podman_bridge.png)

Consider the above illustration.  It depicts a laptop user running two containers: a web and db instance.  These two containers are on the virtual network with the host.  Additionally, by default, these containers can initiate communications outside the laptop (to the Internet for example).  The containers on the virtual network typically have non-routable, also known as private IP addresses.
请看上面的插图。它描绘了一个笔记本电脑用户运行两个容器：一个 Web 实例和 DB 实例。这两个容器与主机位于虚拟网络上。此外，默认情况下，这些容器可以在笔记本电脑外部启动通信（例如，到  Internet）。虚拟网络上的容器通常具有不可路由的 IP 地址，也称为专用 IP 地址。

When dealing with communication that is being initiated outside the host, the outside client typically must address the laptop’s external network interface and given port number.  Assuming the host allows incoming traffic, the host will know to forward the incoming traffic on that port to the specific container.  To accomplish this, firewall rules are added to forward traffic when a container requests a specific port be forwarded.
在处理在主机外部启动的通信时，外部客户端通常必须对笔记本电脑的外部网络接口和给定的端口号进行寻址。假设主机允许传入流量，则主机将知道将该端口上的传入流量转发到特定容器。为了实现这一点，添加了防火墙规则，以便在容器请求转发特定端口时转发流量。

Bridge networking is the default for Podman containers created as root. Podman provides a default bridge network, but you can create others using the `podman network create` command. Containers can be joined to a network when they are created with the `--network` flag, or after they are created via the `podman network connect` and `podman network disconnect` commands.
桥接网络是以 root 身份创建的 Podman 容器的默认设置。Podman 提供了一个默认的桥接网络，但您可以使用该 `podman network create` 命令创建其他桥接网络。当容器是使用 `--network` 标志创建容器时，或者在通过 `podman network connect` and `podman network disconnect` 命令创建容器后，可以将其加入网络。

As mentioned earlier, slirp4netns is the default network configuration for rootless users.  But as of Podman version 4.0, rootless users can also use netavark. The user experience of rootless netavark is very akin to a rootful netavark, except that there is no default network configuration provided.  You simply need to create a network, and the one will be created as a bridge network. If you would like to switch from CNI networking to netavark, you must issue the `podman system reset --force` command. This will delete all of your images, containers, and custom networks.
如前所述，slirp4netns 是无根用户的默认网络配置。但从 Podman 4.0 版本开始，无根用户也可以使用 netavark。无根 netavark  的用户体验与有根的 netavark 非常相似，不同之处在于没有提供默认的网络配置。您只需要创建一个网络，该网络将被创建为桥接网络。如果要从  CNI 网络切换到 netavark，则必须发出命令 `podman system reset --force` 。这将删除您的所有映像、容器和自定义网络。

```
$ podman network create
```

​    

When rootless containers are run, network operations will be executed inside an extra network namespace. To join this namespace, use `podman unshare --rootless-netns`.
当运行无根容器时，网络操作将在额外的网络命名空间内执行。要加入此命名空间，请使用 `podman unshare --rootless-netns` .

#### Default Network 默认网络



The default network `podman` with netavark is memory-only.  It does not support dns resolution  because of backwards compatibility with Docker.  To change settings,  export the in-memory network and change the file.
netavark 的默认网络 `podman` 是仅内存网络。由于与 Docker 的向后兼容性，它不支持 dns 解析。要更改设置，请导出内存中网络并更改文件。

For the default rootful network use
对于默认的 rootful 网络使用

```
podman network inspect podman | jq .[] > /etc/containers/networks/podman.json
```

​    

And for the rootless network use
而对于无根网络使用

```
podman network inspect podman | jq .[] > ~/.local/share/containers/storage/networks/podman.json
```

​    

#### Example 例



By default, rootful containers use the netavark for its default network if you have not migrated from Podman v3. In this case, no network name must be passed to Podman.  However, you can create additional bridged networks with the podman create command.
默认情况下，如果您尚未从 Podman v3 迁移，则 rootful 容器将使用 netavark 作为其默认网络。在这种情况下，无需将网络名称传递给 Podman。但是，您可以使用 podman create 命令创建其他桥接网络。

The following example shows how to set up a web server and expose it to the network outside the host as both rootful and rootless.  It will also show how an outside client can connect to the container.
以下示例演示如何设置 Web 服务器，并将其作为 rootful 和 rootless 公开给主机外部的网络。它还将展示外部客户端如何连接到容器。

```
(rootful) $ sudo podman run -dt --name webserver -p 8080:80 quay.io/libpod/banner
00f3440c7576aae2d5b193c40513c29c7964e96bf797cf0cc352c2b68ccbe66a
```

​    

Now run the container.
现在运行容器。

```
$ podman run -dt --name webserver --net podman1 -p 8081:80 quay.io/libpod/banner
269fd0d6b2c8ed60f2ca41d7beceec2471d72fb9a33aa8ca45b81dc9a0abbb12
```

​    

Note in the above run command, the container’s port 80 (where the Nginx server is running) was mapped to the host’s port 8080.  Port 8080 was chosen to demonstrate how the host and container ports can be mapped for external access.  The port could very well have been 80 as well (except for rootless users).
注意在上面的运行命令中，容器的端口 80（运行 Nginx 服务器的地方）映射到了主机的端口 8080。选择端口 8080 是为了演示如何映射主机和容器端口以进行外部访问。端口很可能也是 80（无根用户除外）。

To connect from an outside client to the webserver, simply point an HTTP client to the host’s IP address at port 8080 for rootful and port 8081 for rootless.
要从外部客户端连接到 Web 服务器，只需将 HTTP 客户端指向主机的 IP 地址，端口 8080 用于 rootful，端口 8081 用于无根。

```
(outside_host): $ curl 192.168.99.109:8080
   ___           __
  / _ \___  ___/ /_ _  ___ ____
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/

(outside_host): $ curl 192.168.99.109:8081
   ___           __
  / _ \___  ___/ /_ _  ___ ____
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

​    

### Macvlan 麦克夫兰



With macvlan, the container is given access to a physical network interface on the host. This interface can configure multiple subinterfaces.  And each subinterface is capable of having its own MAC and IP address.  In the case of Podman containers, the container will present itself as if it is on the same network as the host.
使用 macvlan，容器可以访问主机上的物理网络接口。该接口可以配置多个子接口。每个子接口都能够拥有自己的 MAC 和 IP 地址。在 Podman 容器的情况下，容器将呈现为与主机位于同一网络上。

[![macvlan_network](https://github.com/containers/podman/raw/main/docs/tutorials/podman_macvlan.png)](https://github.com/containers/podman/blob/main/docs/tutorials/podman_macvlan.png)

In the illustration, outside clients will be able to access the web container by its IP address directly.  Usually the network information, including IP address, is leased from a DHCP server like most other network clients on the network.  If the laptop is running a firewall, such as firewalld, then accommodations will need to be made for proper access.
在图中，外部客户端将能够直接通过其 IP 地址访问 Web 容器。通常，网络信息（包括 IP 地址）是从 DHCP 服务器租用的，就像网络上的大多数其他网络客户端一样。如果笔记本电脑运行的是防火墙，例如 firewalld，则需要进行调整以确保正确访问。

Note that Podman has to be run as root in order to use macvlan.
请注意，Podman 必须以 root 身份运行才能使用 macvlan。

#### Example 例



The following example demonstrates how to set up a web container on a macvlan and how to access that container from outside the host.  First, create the macvlan network. You need to know the network interface on the host that connects to the routable network.  In the example case, it is eth0.
以下示例演示了如何在 macvlan 上设置 Web 容器，以及如何从主机外部访问该容器。首先，创建 macvlan 网络。您需要知道连接到可路由网络的主机上的网络接口。在本例中，它是 eth0。

```
$ sudo podman network create -d macvlan -o parent=eth0 webnetwork
webnetwork
```

​    

The next step is to ensure that the DHCP service is running. This handles the DHCP leases from the network. If DHCP is not needed, the `--subnet` option can be used to assign a static subnet in the `network create` command above.
下一步是确保DHCP服务正在运行。这将处理来自网络的 DHCP 租约。如果不需要 DHCP，则可以使用该 `--subnet` 选项在上述 `network create` 命令中分配静态子网。

CNI and netavark both use their own DHCP service; therefore, you need to know what backend you are using. To see what you are using, run this command:
CNI 和 netavark 都使用自己的 DHCP 服务;因此，您需要知道您正在使用的后端。要查看您正在使用的内容，请运行以下命令：

```
$ sudo podman info --format {{.Host.NetworkBackend}}
```

​    

If this command does not work, you are using an older version prior to Podman v4.0 which means you are using CNI. If the netavark backend is used, at least Podman v4.5 with netavark v1.6 is required to use DHCP.
如果此命令不起作用，则您正在使用 Podman v4.0 之前的旧版本，这意味着您正在使用 CNI。如果使用 netavark 后端，至少需要 Podman v4.5 和 netavark v1.6 才能使用 DHCP。

For netavark use: 对于 netavark 使用：

```
$ sudo systemctl enable --now netavark-dhcp-proxy.socket
```

​    

Or if the system doesn't use systemd, start the daemon manually:
或者，如果系统不使用 systemd，请手动启动守护进程：

```
$ /usr/libexec/podman/netavark dhcp-proxy --activity-timeout 0
```

​    

With CNI use: 使用 CNI 时：

```
$ sudo systemctl enable --now cni-dhcp.socket
```

​    

Or if the system doesn't use systemd, start the daemon manually:
或者，如果系统不使用 systemd，请手动启动守护进程：

```
$ sudo /usr/libexec/cni/dhcp daemon
```

​    

Note that depending on the distribution, the binary location may differ.
请注意，根据分布的不同，二进制位置可能会有所不同。

Now run the container and be certain to attach it to the network we created earlier.
现在运行容器，并确保将其连接到我们之前创建的网络。

```
$ sudo podman run -dt --name webserver --network webnetwork quay.io/libpod/banner
03d82083c434d7e937fc0b87c25401f46ab5050007df403bf988e25e52c5cc40
[baude@localhost ~]$ sudo podman exec webserver ip address show eth0
2: eth0@if3: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state
UP
link/ether 0a:3c:e2:eb:87:0f brd ff:ff:ff:ff:ff:ff
inet 192.168.99.186/24 brd 192.168.99.255 scope global eth0
valid_lft forever preferred_lft forever
inet6 fe80::83c:e2ff:feeb:870f/64 scope link
valid_lft forever preferred_lft forever
```

​    

Because the container has a routable IP address (on this network) and is not being managed by firewalld, no change to the firewall is needed.
由于容器具有可路由的 IP 地址（在此网络上）并且不受 firewalld 管理，因此无需更改防火墙。

```
(outside_host): $ curl http://192.168.99.186
   ___           __
  / _ \___  ___/ /_ _  ___ ____
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

​    

### Slirp4netns



Slirp4netns is the default network setup for rootless containers and pods.  It was invented because unprivileged users are not allowed to make network interfaces on the host.  Slirp4netns creates a TAP device in the container’s network namespace and connects to the usermode TCP/IP stack.  Consider the following illustration.
Slirp4netns 是无根容器和 Pod 的默认网络设置。之所以发明它，是因为不允许非特权用户在主机上建立网络接口。Slirp4netns 在容器的网络命名空间中创建一个 TAP 设备，并连接到用户模式 TCP/IP 堆栈。请看下图。

[![slirp_network](https://github.com/containers/podman/raw/main/docs/tutorials/podman_rootless_default.png)](https://github.com/containers/podman/blob/main/docs/tutorials/podman_rootless_default.png)

The unprivileged user on this laptop has created two containers: a DB container and a web container.  Both of these containers have the ability to access content on networks outside the laptop.  And outside clients can access the containers if the container is bound to a host port and the laptop firewall allows it.  Remember, unprivileged users must use ports 1024 through 65535 as lower ports require root privileges. (CAP_NET_BIND_SERVICE) Note: this can be adjusted using the `sysctl net.ipv4.ip_unprivileged_port_start`
此笔记本电脑上的非特权用户创建了两个容器：DB 容器和 Web  容器。这两个容器都能够访问笔记本电脑外部网络上的内容。如果容器绑定到主机端口并且笔记本电脑防火墙允许，则外部客户端可以访问容器。请记住，非特权用户必须使用端口 1024 到 65535，因为较低端口需要 root 权限。（CAP_NET_BIND_SERVICE）注意：这可以使用 `sysctl net.ipv4.ip_unprivileged_port_start` 

One of the drawbacks of slirp4netns is that the containers are completely isolated from each other.  Unlike the bridge approach, there is no virtual network.  For containers to communicate with each other, they can use the port mappings with the host system, or they can be put into a Pod where they share the same network namespace. See [Communicating between containers and pods](https://github.com/containers/podman/blob/main/docs/tutorials/basic_networking.md#Communicating-between-containers-and-pods) for more information.
slirp4netns 的一个缺点是容器彼此完全隔离。与桥接方法不同，没有虚拟网络。为了让容器能够相互通信，它们可以使用与主机系统的端口映射，或者可以将它们放入共享相同网络命名空间的 Pod 中。有关更多信息，请参阅容器和 Pod 之间的通信。

#### Example 例



The following example will show how two rootless containers can communicate with each other where one is a web server.  Then it will show how a client on the host’s network can communicate with the rootless web server.
以下示例将展示两个无根容器如何相互通信，其中一个是 Web 服务器。然后，它将展示主机网络上的客户端如何与无根 Web 服务器进行通信。

First, run the rootless web server and map port 80 from the container to a non-privileged port like 8080.
首先，运行无根 Web 服务器，并将容器中的端口 80 映射到非特权端口（如 8080）。

```
$ podman run -dt --name webserver -p 8080:80 quay.io/libpod/banner
17ea33ccd7f55ff45766b3ec596b990a5f2ba66eb9159cb89748a85dc3cebfe0
```

​    

Because rootless containers cannot communicate with each other directly with TCP/IP via IP addresses, the host and the port mapping are used.  To do so, the IP address of the host (interface) must be known.
由于无根容器无法通过 IP 地址直接与 TCP/IP 通信，因此使用主机和端口映射。为此，必须知道主机（接口）的 IP 地址。

```
$ ip address show eth0
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group
default qlen 1000
link/ether 3c:e1:a1:c1:7a:3f brd ff:ff:ff:ff:ff:ff
altname eth0
inet 192.168.99.109/24 brd 192.168.99.255 scope global dynamic noprefixroute eth0
valid_lft 78808sec preferred_lft 78808sec
inet6 fe80::5632:6f10:9e76:c33/64 scope link noprefixroute
valid_lft forever preferred_lft forever
```

​    

From another rootless container, use the host’s IP address and port to communicate between the two rootless containers successfully.
在另一个无根容器中，使用主机的 IP 地址和端口在两个无根容器之间成功通信。

```
$ podman run -it quay.io/libpod/banner curl http://192.168.99.109:8080
   ___           __
  / _ \___  ___/ /_ _  ___ ____
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

​    

From a client outside the host, the IP address and port can also be used:
在主机外部的客户端中，还可以使用 IP 地址和端口：

```
(outside_host): $ curl http://192.168.99.109:8080
   ___           __
  / _ \___  ___/ /_ _  ___ ____
 / ___/ _ \/ _  /  ' \/ _ `/ _ \
/_/   \___/\_,_/_/_/_/\_,_/_//_/
```

​    

## Communicating between containers and pods 容器和 Pod 之间的通信



Most users of containers have a decent understanding of how containers communicate with each other and the rest of the world.  Usually each container has its own IP address and networking information.  They communicate amongst each other using regular TCP/IP means like IP addresses or, in many cases, using DNS names often based on the container name.  But pods are a collection of one or more containers, and with that, some uniqueness is inherited.
大多数容器用户对容器之间以及世界其他地方如何通信有很好的理解。通常，每个容器都有自己的 IP 地址和网络信息。它们使用常规的 TCP/IP 方式（如 IP 地址）相互通信，或者在许多情况下，使用通常基于容器名称的 DNS  名称进行通信。但是 Pod 是一个或多个容器的集合，因此，继承了一些独特性。

By definition, all containers in a Podman pod share the same network namespace. This fact means that they will have the same IP address, MAC addresses, and port mappings. You can conveniently communicate between containers in a pod by using localhost.
根据定义，Podman pod 中的所有容器共享相同的网络命名空间。这一事实意味着它们将具有相同的 IP 地址、MAC 地址和端口映射。您可以使用 localhost 方便地在 Pod 中的容器之间进行通信。

[![slirp_network](https://github.com/containers/podman/raw/main/docs/tutorials/podman_pod.png)](https://github.com/containers/podman/blob/main/docs/tutorials/podman_pod.png)

The above illustration describes a Pod on a bridged network.  As depicted, the Pod has two containers “inside” it: a DB and a Web container.  Because they share the same network namespace, the DB and Web container can communicate with each other using localhost (127.0.0.1).  Furthermore, they are also both addressable by the IP address (and DNS name if applicable) assigned to the Pod itself.
上图描述了桥接网络上的一个 Pod。如图所示，Pod “内部”有两个容器：一个 DB 和一个 Web 容器。由于它们共享相同的网络命名空间，因此 DB 和 Web  容器可以使用 localhost （127.0.0.1） 相互通信。此外，它们还可以通过分配给 Pod 本身的 IP 地址（和 DNS  名称，如果适用）进行寻址。

For more information on container to container networking, see [Configuring container networking with Podman](https://www.redhat.com/sysadmin/container-networking-podman).
有关容器到容器网络的更多信息，请参阅使用 Podman 配置容器网络。





# Podman socket activation Podman 套接字激活



Socket activation conceptually works by having systemd create a socket (e.g. TCP, UDP or Unix socket). As soon as a client connects to the socket, systemd will start the systemd service that is configured for the socket. The newly started program inherits the file descriptor of the socket and can then accept the incoming connection (in other words run the system call `accept()`). This description corresponds to the default systemd socket configuration [`Accept=no`](https://www.freedesktop.org/software/systemd/man/systemd.socket.html#Accept=) that lets the service accept the socket.
从概念上讲，套接字激活的工作原理是让 systemd 创建一个套接字（例如 TCP、UDP 或 Unix 套接字）。一旦客户端连接到套接字，systemd 就会启动为套接字配置的  systemd 服务。新启动的程序继承套接字的文件描述符，然后可以接受传入的连接（换句话说，运行系统调用 `accept()` ）。此描述对应于默认的 systemd 套接字配置，该配置 `Accept=no` 允许服务接受套接字。

Podman supports two forms of socket activation:
Podman 支持两种形式的套接字激活：

- Socket activation of the API service
  API 服务的套接字激活
- Socket activation of containers
  容器的套接字激活

## Socket activation of the API service API 服务的套接字激活



The architecture looks like this
体系结构如下所示

      stateDiagram-v2
    [*] --> systemd: first client connects
    systemd --> podman: socket inherited via fork/exec

<details class="details-reset details-overlay details-overlay-dark" style="display: contents" data-immersive-translate-walked="241bad50-b8ef-4573-8e2e-f5fc9633d1d5">
      
    </details>

<iframe title="File display" role="presentation" class="render-viewer" sandbox="allow-scripts allow-same-origin allow-top-navigation allow-popups" src="https://viewscreen.githubusercontent.com/markdown/mermaid?docs_host=https%3A%2F%2Fdocs.github.com&amp;color_mode=light#e5418b59-f6af-4d3e-8837-e3dcaaeeaa8c" name="e5418b59-f6af-4d3e-8837-e3dcaaeeaa8c" data-content="{&quot;data&quot;:&quot;stateDiagram-v2\n    [*] --&amp;gt; systemd: first client connects\n    systemd --&amp;gt; podman: socket inherited via fork/exec\n&quot;}">
      </iframe>

The file */usr/lib/systemd/user/podman.socket* on a Fedora system defines the Podman API socket for rootless users:
Fedora 系统上的文件 /usr/lib/systemd/user/podman.socket 为无根用户定义了 Podman API 套接字：

```
$ cat /usr/lib/systemd/user/podman.socket
[Unit]
Description=Podman API Socket
Documentation=man:podman-system-service(1)

[Socket]
ListenStream=%t/podman/podman.sock
SocketMode=0660

[Install]
WantedBy=sockets.target
```

​    

The socket is configured to be a Unix socket and can be started like this
套接字配置为 Unix 套接字，可以像这样启动

```
$ systemctl --user start podman.socket
$ ls $XDG_RUNTIME_DIR/podman/podman.sock
/run/user/1000/podman/podman.sock
$
```

​    

The socket can later be used by for instance **docker-compose** that needs a Docker-compatible API
例如，需要与 Docker 兼容的 API 的 docker-compose 稍后可以使用该套接字

```
$ export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
$ docker-compose up
```

​    

When **docker-compose** or any other client connects to the UNIX socket `$XDG_RUNTIME_DIR/podman/podman.sock`, the service *podman.service* is started. See its definition in the file */usr/lib/systemd/user/podman.service*.
当 docker-compose 或任何其他客户端连接到 UNIX 套接字时 `$XDG_RUNTIME_DIR/podman/podman.sock` ，服务 podman.service 将启动。请参阅文件 /usr/lib/systemd/user/podman.service 中的定义。

## Socket activation of containers 容器的套接字激活



Since version 3.4.0 Podman supports socket activation of containers, i.e.,  passing a socket-activated socket to the container. Thanks to the fork/exec model of Podman, the socket will be first inherited by conmon and then by the OCI runtime and finally by the container as can be seen in the following diagram:
从版本 3.4.0 开始，Podman 支持容器的套接字激活，即将套接字激活的套接字传递给容器。由于 Podman 的 fork/exec 模型，套接字将首先由 conmon 继承，然后由 OCI 运行时继承，最后由容器继承，如下图所示：

        stateDiagram-v2
    [*] --> systemd: first client connects
    systemd --> podman: socket inherited via fork/exec
    state "OCI runtime" as s2
    podman --> conmon: socket inherited via double fork/exec
    conmon --> s2: socket inherited via fork/exec
    s2 --> container: socket inherited via exec      

<details class="details-reset details-overlay details-overlay-dark" style="display: contents" data-immersive-translate-walked="241bad50-b8ef-4573-8e2e-f5fc9633d1d5">
      
    </details>

<iframe title="File display" role="presentation" class="render-viewer" sandbox="allow-scripts allow-same-origin allow-top-navigation allow-popups" src="https://viewscreen.githubusercontent.com/markdown/mermaid?docs_host=https%3A%2F%2Fdocs.github.com&amp;color_mode=light#0ff51efd-4c22-4808-9b17-2220ebbcf208" name="0ff51efd-4c22-4808-9b17-2220ebbcf208" data-content="{&quot;data&quot;:&quot;stateDiagram-v2\n    [*] --&amp;gt; systemd: first client connects\n    systemd --&amp;gt; podman: socket inherited via fork/exec\n    state \&quot;OCI runtime\&quot; as s2\n    podman --&amp;gt; conmon: socket inherited via double fork/exec\n    conmon --&amp;gt; s2: socket inherited via fork/exec\n    s2 --&amp;gt; container: socket inherited via exec\n&quot;}">
      </iframe>

This type of socket activation can be used in systemd services that are generated from container unit files (see [podman-systemd.unit(5)](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)) (Note, quadlet requires the use of cgroup v2) or from the command [`podman generate systemd`](https://docs.podman.io/en/latest/markdown/podman-generate-systemd.1.html). The container must also support socket activation. Not all software daemons support socket activation but it's getting more popular. For instance Apache HTTP server, MariaDB, DBUS, PipeWire, Gunicorn, CUPS all have socket activation support.
这种类型的套接字激活可以在从容器单元文件生成的 systemd 服务中使用（参见 podman-systemd.unit（5））（注意，quadlet 需要使用 cgroup v2） 或从命令 `podman generate systemd` 。容器还必须支持套接字激活。并非所有软件守护进程都支持套接字激活，但它越来越受欢迎。例如，Apache HTTP 服务器、MariaDB、DBUS、PipeWire、Gunicorn、CUPS 都支持套接字激活。

### Example: socket-activated echo server container in a systemd service 示例：systemd 服务中套接字激活的 echo 服务器容器



This example shows how to run the socket-activated echo server [socket-activate-echo](https://github.com/eriksjolund/socket-activate-echo/pkgs/container/socket-activate-echo) in a systemd user service. Podman version 4.4.0 or higher is required.
此示例说明如何在 systemd 用户服务中运行套接字激活的回显服务器 socket-activate-echo。需要 Podman 版本 4.4.0 或更高版本。

Enable lingering for your regular user
为普通用户启用延迟

```
$ loginctl enable-linger $USER
```

​    

The command has these effects on your enabled systemd user units:
该命令对已启用的 systemd 用户单元具有以下效果：

- the units are automatically started after a reboot
  重新启动后，设备将自动启动
- the units are not automatically stopped after you log out
  注销后，这些设备不会自动停止

Create directories 创建目录

```
$ mkdir -p ~/.config/systemd/user
$ mkdir -p ~/.config/containers/systemd
```

​    

Create the file *~/.config/containers/systemd/echo.container* with the file contents:
使用文件内容创建文件 ~/.config/containers/systemd/echo.container：

```
[Unit]
Description=Example echo service
Requires=echo.socket
After=echo.socket

[Container]
Image=ghcr.io/eriksjolund/socket-activate-echo
Network=none

[Install]
WantedBy=default.target
```

​    

The file follows the syntax described in [**podman-systemd.unit**(5)](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html).
该文件遵循 podman-systemd.unit（5） 中描述的语法。

The `[Install]` section is optional. If you remove the two last lines, the *echo.service* will not be automatically started after a reboot. Instead, the *echo.service* is started when the first client connects to the socket.
该 `[Install]` 部分是可选的。如果删除最后两行，则 echo.service 将不会在重新启动后自动启动。相反，当第一个客户端连接到套接字时，echo.service 将启动。

The line `Network=none` is optional. It improves security by removing network connectivity for the container. The container can still be serving the internet because `Network=none` has no effect on activated sockets.
该行 `Network=none` 是可选的。它通过删除容器的网络连接来提高安全性。容器仍然可以为 Internet 提供服务，因为 `Network=none` 对激活的套接字没有影响。

A socket-activated service also requires a systemd socket unit. Create the file *~/.config/systemd/user/echo.socket* that defines the sockets that the container should use
套接字激活的服务还需要一个 systemd 套接字单元。创建文件 ~/.config/systemd/user/echo.socket，用于定义容器应使用的套接字

```
[Unit]
Description=Example echo socket

[Socket]
ListenStream=127.0.0.1:3000
ListenDatagram=127.0.0.1:3000
ListenStream=[::1]:3000
ListenDatagram=[::1]:3000
ListenStream=%h/echo_stream_sock

# VMADDR_CID_ANY (-1U) = 2^32 -1 = 4294967295
# See "man vsock"
ListenStream=vsock:4294967295:3000

[Install]
WantedBy=sockets.target
```

​    

`%h` is a systemd specifier that expands to the user's home directory.
 `%h` 是一个 systemd 说明符，可扩展到用户的主目录。

After editing the unit files, systemd needs to reload its configuration.
编辑单元文件后，systemd 需要重新加载其配置。

```
$ systemctl --user daemon-reload
```

​    

While reloading its configuration systemd generates the unit *echo.service* from the file *~/.config/containers/systemd/echo.container* by executing the unit generator `/usr/lib/systemd/system-generators/podman-system-generator`.
在重新加载其配置时，systemd 通过执行单元生成器从文件 ~/.config/containers/systemd/echo.container 生成单元 echo.service `/usr/lib/systemd/system-generators/podman-system-generator` 。

Optional: View the generated *echo.service* to see the `podman run` command that will be run.
可选：查看生成的 echo.service 以查看将要运行 `podman run` 的命令。

```
$ systemctl --user cat echo.service
```

​    

Configure systemd to automatically start *echo.socket* after reboots.
配置 systemd 在重启后自动启动 echo.socket。

```
$ systemctl --user enable echo.socket
```

​    

Pull the container image beforehand
事先拉取容器镜像

```
$ podman pull ghcr.io/eriksjolund/socket-activate-echo
```

​    

Start the socket unit
启动插座单元

```
$ systemctl --user start echo.socket
```

​    

Test the echo server with the program **socat**
使用程序 socat 测试 echo 服务器

```
$ echo hello | socat -t 30 - tcp4:127.0.0.1:3000
hello
$ echo hello | socat -t 30 - tcp6:[::1]:3000
hello
$ echo hello | socat -t 30 - udp4:127.0.0.1:3000
hello
$ echo hello | socat -t 30 - udp6:[::1]:3000
hello
$ echo hello | socat -t 30 - unix:$HOME/echo_stream_sock
hello
$ echo hello | socat -t 30 - VSOCK-CONNECT:1:3000
hello
```

​    

The option `-t 30` configures socat to use a timeout of 30 seconds when socat reads from the socket awaiting to get an EOF (End-Of-File). As the container image has already been pulled, such a long timeout is not really needed.
该选项 `-t 30` 将 socat 配置为在 socat 从套接字读取等待获取 EOF（文件结束）时使用 30 秒的超时。由于容器镜像已经被拉取，因此实际上并不需要这么长的超时。

The echo server works as expected. It replies *"hello"* after receiving the text *"hello"*.
回显服务器按预期工作。它在收到文本“你好”后回复“你好”。

### Example: socket activate an Apache HTTP server with systemd-socket-activate 示例：使用 systemd-socket-activate socket 激活 Apache HTTP 服务器



Instead of setting up a systemd service to test out socket activation, an alternative is to use the command-line tool [**systemd-socket-activate**](https://www.freedesktop.org/software/systemd/man/systemd-socket-activate.html#).
另一种方法是使用命令行工具 systemd-socket-activate，而不是设置 systemd 服务来测试套接字激活。

Let's build a container image for the Apache HTTP server that is configured to support socket activation on port 8080.
让我们为 Apache HTTP 服务器构建一个容器镜像，该镜像配置为支持端口 8080 上的套接字激活。

Create a new directory *ctr* and a file *ctr/Containerfile* with this contents
创建一个新的目录 ctr 和一个文件 ctr/Containerfile 包含此内容

```
FROM docker.io/library/fedora
RUN dnf -y update && dnf install -y httpd && dnf clean all
RUN sed -i "s/Listen 80/Listen 127.0.0.1:8080/g" /etc/httpd/conf/httpd.conf
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
```

​    

Build the container image
构建容器镜像

```
$ podman build -t socket-activate-httpd ctr
```

​    

In one shell, start **systemd-socket-activate**.
在一个 shell 中，启动 systemd-socket-activate。

```
$ systemd-socket-activate -l 8080 podman run --rm --network=none localhost/socket-activate-httpd
```

​    

The TCP port number 8080 is given as an option to **systemd-socket-activate**. The  **--publish** (**-p**) option for `podman run` is not used.
TCP 端口号 8080 作为 systemd-socket-activate 的一个选项提供。未使用 的 --publish （-p） 选项 `podman run` 。

In another shell, fetch a web page from *localhost:8080*
在另一个 shell 中，从 localhost：8080 获取网页

```
$ curl -s localhost:8080 | head -6
<!doctype html>
<html>
  <head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<title>Test Page for the HTTP Server on Fedora</title>
$
```

​    

### Disabling the network with *--network=none* 使用 --network=none 禁用网络



If the container only needs to communicate over the socket-activated socket, it's possible to disable the network by passing **--network=none** to `podman run`. This improves security because the container then runs with less privileges.
如果容器只需要通过套接字激活的套接字进行通信，则可以通过将 --network=none 传递给 `podman run` 来禁用网络。这样可以提高安全性，因为容器会以较少的权限运行。

### Native network performance over the socket-activated socket 通过套接字激活的套接字实现的本机网络性能



When using rootless Podman, network traffic is normally passed through slirp4netns. This comes with a performance penalty. Fortunately, communication over the socket-activated socket does not pass through slirp4netns so it has the same performance characteristics as the normal network on the host.
使用无根 Podman 时，网络流量通常通过 slirp4netns 传递。这会带来性能损失。幸运的是，通过套接字激活的套接字进行的通信不会通过 slirp4netns，因此它具有与主机上的正常网络相同的性能特征。

### Starting a socket-activated service 启动套接字激活的服务



There is a delay when the first connection is made because the container needs to start up. To minimize this delay, consider passing **--pull=never** to `podman run` and instead pull the container image beforehand. Instead of waiting for the start of the service to be triggered by the first client connecting to it, the service can also be explicitly started (`systemctl --user start echo.service`).
由于容器需要启动，因此在建立第一个连接时会出现延迟。为了最大程度地减少这种延迟，请考虑将 --pull=never 传递给 `podman run` ，而是事先拉取容器镜像。也可以显式启动服务，而不是等待连接到它的第一个客户端触发服务启动 （ `systemctl --user start echo.service` ）。

### Stopping a socket-activated service 停止套接字激活的服务



Some services run a command (configured by the systemd directive **ExecStart**) that exits after some time of inactivity. Depending on the restart configuration for the service (systemd directive [**Restart**](https://www.freedesktop.org/software/systemd/man/systemd.service.html#Restart=)), it may then be stopped. An example of this is *podman.service* that stops after some time of inactivity. The service will be started again when the next client connects to the socket.
某些服务会运行一个命令（由 systemd 指令 ExecStart 配置），该命令会在一段时间不活动后退出。根据服务的重新启动配置（systemd 指令  Restart），它可能会被停止。这方面的一个例子是  podman.service，它在一段时间不活动后停止。当下一个客户端连接到套接字时，该服务将再次启动。