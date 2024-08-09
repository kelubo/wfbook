# Docker

[TOC]

## 概述

开源的应用容器引擎，基于 Go 语言实现，基于 Linux 内核的 cgroup、namespace 以及 AUFS 类的 UnionFS 等技术，对进程进行封装隔离，属于操作系统层面的虚拟化技术。由于隔离的进程独立于宿主和其他的隔离的进程，因此也称其为容器。

最初实现是基于 LXC，从 0.7 版本后，开始去除 LXC，转而使用自行开发的 libcontainer ，从 1.11 开始，则进一步演进为使用 runC 和 containerd 。

基于 Apache2.0 协议开源。 

Docker 使用 C/S 架构模式，使用远程 API 来管理和创建 Docker 容器。

Docker 容器通过 Docker 镜像来创建。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是容器性能开销极低。

Docker 从 17.03 版本之后分为 CE（Community Edition: 社区版） 和 EE（Enterprise Edition: 企业版）。

Docker 是一个用于开发、发布和运行应用程序的开放平台。Docker 使您能够将应用程序与基础架构分离，以便快速交付软件。使用  Docker，可以采用与管理应用程序相同的方式管理基础架构。通过利用 Docker  的方法来交付、测试和部署代码，可以显著减少编写代码和在生产环境中运行代码之间的延迟。

Docker  提供了在松散隔离的环境（称为容器）中打包和运行应用程序的功能。隔离性和安全性使您可以在给定主机上同时运行多个容器。容器是轻量级的，包含运行应用程序所需的一切，因此无需依赖主机上安装的内容。可以在工作时共享容器，并确保与您共享的每个人都能获得以相同方式工作的同一容器。

Docker 提供工具和平台来管理容器的生命周期：

- 使用容器开发应用程序及其支持组件。
- 容器成为分发和测试应用程序的单元。
- 准备就绪后，将应用程序作为容器或编排服务部署到生产环境中。无论生产环境是本地数据中心、云提供商还是两者的混合体，这都是一样的。

## 优势

* 更高效的利用系统资源。
* 更快速的启动时间。
* 一致的运行环境。
* 持续交付和部署。
* 更轻松的迁移。
* 更轻松的维护和扩展。

## 用途

### 快速、一致地交付应用程序

Docker 允许开发人员使用提供应用程序和服务的本地容器在标准化环境中工作，从而简化了开发生命周期。容器非常适合持续集成和持续交付 （CI/CD） 工作流。

请考虑以下示例方案：

- 开发人员在本地编写代码，并使用 Docker 容器与同事共享他们的工作。
- 使用 Docker 将应用程序推送到测试环境中，并运行自动和手动测试。
- 当开发者发现 bug 时，可以在开发环境中进行修复，并重新部署到测试环境中进行测试和验证。
- 测试完成后，将修复程序发送给客户就像将更新的镜像推送到生产环境一样简单。

### 响应式部署和扩展

Docker 基于容器的平台允许高度可移植的工作负载。Docker 容器可以在开发人员的本地笔记本电脑上运行，也可以在数据中心的物理机或虚拟机上运行，也可以在云提供商上运行，也可以在混合环境中运行。

Docker 的可移植性和轻量级特性也使得动态管理工作负载变得容易，根据业务需求近乎实时地扩展或减少应用程序和服务。

### 在同一硬件上运行更多工作负载

Docker 是轻量级和快速的。It provides a viable, cost-effective alternative to hypervisor-based virtual machines, 它提供了一种基于虚拟机管理程序的虚拟机的可行且经济高效的替代方案，因此可以使用更多的服务器容量来实现业务目标。Docker 非常适合高密度环境以及需要用更少资源完成更多任务的中小型部署。

## 为什么使用容器

想象一下，正在开发一个杀手级 Web 应用程序，它有三个主要组件 - React 前端、Python API 和 PostgreSQL 数据库。如果想做这个项目，你必须安装 Node、Python 和 PostgreSQL。

你如何确保你与团队中的其他开发人员拥有相同的版本？还是您的 CI/CD 系统？或者在生产中使用了什么？

如何确保应用所需的 Python（或 Node 或数据库）版本不受计算机上已有内容的影响？您如何管理潜在的冲突？

Enter containers! 进入集装箱！

什么是容器？简单地说，容器是应用的每个组件的隔离进程。每个组件 - 前端 React 应用程序、Python API 引擎和数据库 - 都在自己的隔离环境中运行，与机器上的其他一切完全隔离。

这就是它们令人敬畏的原因。容器包括：

- 自成一体。每个容器都具有运行所需的一切，而不依赖于主机上任何预安装的依赖项。
- 孤立。由于容器是独立运行的，因此它们对主机和其他容器的影响最小，从而提高了应用程序的安全性。
- 独立。每个容器都是独立管理的。删除一个容器不会影响任何其他容器。
- 便携式。容器可以在任何地方运行！在开发计算机上运行的容器在数据中心或云中的任何地方都将以相同的方式工作！

### 容器与虚拟机

在不深入的情况下，VM 是一个完整的操作系统，具有自己的内核、硬件驱动程序、程序和应用程序。启动 VM 只是为了隔离单个应用程序会带来大量开销。

容器只是一个独立的进程，其中包含它需要运行的所有文件。如果运行多个容器，它们都共享相同的内核，从而允许在较少的基础架构上运行更多应用程序。

> **同时使用 VM 和容器**
>
> 很多时候，会看到容器和虚拟机一起使用。例如，在云环境中，预配的计算机通常是 VM。但是，具有容器运行时的 VM 可以运行多个容器化应用程序，而不是预配一台计算机来运行一个应用程序，从而提高资源利用率并降低成本。

## 架构

Docker 使用客户端-服务器架构。Docker 客户端与 Docker 守护进程通信，Docker 守护进程负责构建、运行和分发 Docker 容器的繁重工作。Docker 客户端和守护进程可以在同一系统上运行，也可以将 Docker 客户端连接到远程 Docker 守护进程。Docker 客户端和守护程序使用 REST API 、UNIX 套接字或网络接口进行通信。另一个 Docker 客户端是 Docker Compose，它允许您使用由一组容器组成的应用程序。

![](../../../Image/d/docker-architecture.webp)

### Docker 守护进程

Docker 守护程序 （ `dockerd` ） 侦听 Docker API 请求并管理 Docker 对象，例如镜像、容器、网络和卷。守护进程还可以与其他守护进程通信以管理 Docker 服务。

### Docker 客户端

Docker 客户端 （ `docker` ） 是许多 Docker 用户与 Docker 交互的主要方式。当使用 `docker run` 之类的命令时，客户端会将这些命令发送到 `dockerd` ，后者会执行这些命令。`docker` 命令使用 Docker API。Docker 客户端可以与多个守护进程进行通信。

### Docker Desktop

Docker Desktop 是一款易于安装的应用程序，适用于 Mac、Windows 或 Linux 环境，使您能够构建和共享容器化应用程序和微服务。Docker Desktop 包括 Docker 守护程序 （ `dockerd` ）、Docker 客户端 （ `docker` ）、Docker Compose、Docker Content Trust、Kubernetes 和 Credential Helper。

### Docker registries

Docker registry 用于存储 Docker 镜像。Docker Hub 是一个任何人都可以使用的公共 registry ，Docker 默认在 Docker Hub 上查找镜像。甚至可以运行自己的私人 registry 。

使用 `docker pull` 和 `docker run` 命令时，Docker 会从配置的 registry 中提取所需的映像。当使用 `docker push` 命令时，Docker 会将您的映像推送到配置的 registry 。

[Docker Hub](https://hub.docker.com) 是用于存储和分发镜像的默认全球市场。它有超过 100,000 个由开发人员创建的镜像，可以在本地运行。可以搜索 Docker Hub 镜像，并直接从 Docker Desktop 运行它们。

Docker Hub provides a variety of Docker-supported and endorsed images known as Docker Trusted Content. These provide fully managed services or great  starters for your own images. These include:
Docker Hub 提供了各种 Docker 支持和认可的镜像，称为 Docker 可信内容。这些为您自己的图像提供完全托管的服务或出色的启动器。这些包括：

- [Docker Official Images](https://hub.docker.com/search?q=&type=image&image_filter=official) - 一组精选的 Docker 仓库，作为大多数用户的起点，并且是 Docker Hub 上最安全的一些镜像。
- [Docker Verified Publishers](https://hub.docker.com/search?q=&image_filter=store) - 来自 Docker 验证的商业发布者的高质量镜像。
- [Docker-Sponsored Open Source](https://hub.docker.com/search?q=&image_filter=open_source) - 由 Docker 赞助的开源项目通过 Docker 的开源计划发布和维护的镜像。

要共享 Docker 镜像，需要一个存储它们的位置。这就是 registry 的用武之地。虽然有许多 registry ，但 Docker Hub  是镜像的默认和首选的 registry 。Docker Hub 提供了一个存储自己的镜像和从其他镜像中查找镜像以运行或用作自己镜像的基础的地方。

Docker Hub 是查找受信任内容的首选 registry 。Docker 提供了一组可信内容，由 Docker 官方镜像、Docker 验证发布者和 Docker 赞助的开源软件组成，可以直接使用或作为您自己镜像的基础。

Docker Hub 提供了一个市场来分发您自己的应用程序。任何人都可以创建帐户并分发镜像。当您公开分发创建的镜像时，私有仓库可以确保只有经过授权的用户才能访问您的镜像。

虽然 Docker Hub 是默认的注册表，但 registry 是通过开放容器计划实现标准化并可互操作的。这使公司和组织可以运行自己的私人 registry 。很多时候，受信任的内容会从 Docker Hub 镜像（或复制）到这些私有 registry 中。

### Docker 对象

当使用 Docker 时，正在创建和使用映像、容器、网络、卷、插件和其他对象。

#### 镜像

镜像是一个只读模板，其中包含创建 Docker 容器的说明。通常，一个镜像基于另一个镜像，并进行一些额外的自定义。例如，可以构建一个基于 `ubuntu` 镜像的镜像，但会安装 Apache Web 服务器和您的应用程序，以及使应用程序运行所需的配置详细信息。

可以创建自己的映像，也可以仅使用其他人创建并在 registry 中发布的映像。要构建自己的镜像，需要创建一个 Dockerfile，其中包含一个简单的语法，用于定义创建和运行镜像所需的步骤。Dockerfile 中的每条指令都会在镜像中创建一个层。当更改 Dockerfile 并重新生成镜像时，只会重新生成已更改的层。与其他虚拟化技术相比，这是使镜像如此轻巧、小巧和快速的部分原因。

#### 容器

容器是镜像的可运行实例。可以使用 Docker API 或 CLI 创建、启动、停止、移动或删除容器。可以将容器连接到一个或多个网络，将存储附加到该网络，甚至根据其当前状态创建新镜像。

默认情况下，容器与其他容器及其主机相对隔离。可以控制容器的网络、存储或其他底层子系统与其他容器或主机的隔离程度。

容器由其镜像以及在创建或启动容器时为其提供的任何配置选项来定义。删除容器后，未存储在持久性存储中的任何对其状态所做的更改都将消失。

## 底层技术

Docker 是用 Go 编程语言编写的，并利用 Linux 内核的几个特性来提供其功能。Docker uses a technology called `namespaces` to provide the isolated workspace called the container. Docker 使用一种称为 `namespaces` 的技术来提供称为容器的隔离工作区。当运行容器时，Docker 会为该容器创建一组命名空间。

这些命名空间提供了一个隔离层。容器的每个方面都在单独的命名空间中运行，其访问权限仅限于该命名空间。



# What is a registry? 什么是注册表？

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#explanation)

Now that you know what a container image is and how it works, you might wonder - where do you store these images?
既然您知道了什么是容器镜像以及它是如何工作的，您可能会想 - 您将这些镜像存储在哪里？

Well, you can store your container images on your computer system, but what  if you want to share them with your friends or use them on another  machine? That's where the image registry comes in.
好吧，您可以将容器图像存储在计算机系统上，但是如果您想与朋友分享它们或在另一台机器上使用它们怎么办？这就是图像注册表的用武之地。

An image registry is a centralized location for storing and sharing your container images. It can be either public or private. [Docker Hub](https://hub.docker.com)

 is a public registry that anyone can use and is the default registry.
镜像仓库是用于存储和共享容器镜像的集中位置。它可以是公共的，也可以是私有的。Docker Hub 是一个任何人都可以使用的公共注册表，并且是默认注册表。

While Docker Hub is a popular option, there are many other available container registries available today, including [Amazon Elastic Container Registry(ECR)](https://aws.amazon.com/ecr/)

, [Azure Container Registry (ACR)](https://azure.microsoft.com/en-in/products/container-registry), and [Google Container Registry (GCR)](https://cloud.google.com/artifact-registry)

. You can even run your private registry on your local system or inside  your organization. For example, Harbor, JFrog Artifactory, GitLab  Container registry etc.
虽然 Docker Hub 是一个流行的选项，但目前还有许多其他可用的容器注册表，包括 Amazon Elastic Container  Registry （ECR）、Azure Container Registry （ACR） 和 Google Container  Registry （GCR）。您甚至可以在本地系统或组织内部运行您的私有注册表。例如，Harbor、JFrog  Artifactory、GitLab Container registry 等。

### [Registry vs. repository 注册表与存储库](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#registry-vs-repository)

While you're working with registries, you might hear the terms *registry* and *repository* as if they're interchangeable. Even though they're related, they're not quite the same thing.
在处理注册表时，您可能会听到注册表和存储库这两个术语，就好像它们是可以互换的一样。尽管它们是相关的，但它们并不完全是一回事。

A *registry* is a centralized location that stores and manages container images, whereas a *repository* is a collection of related container images within a registry. Think of it as a folder where you organize your images based on projects. Each  repository contains one or more container images.
注册表是存储和管理容器映像的集中位置，而存储库是注册表中相关容器映像的集合。将其视为一个文件夹，您可以在其中根据项目组织图像。每个存储库都包含一个或多个容器映像。

The following diagram shows the relationship between a registry, repositories, and images.
下图显示了注册表、存储库和映像之间的关系。



IIIIImmmmmaaaaagggggeeeeeR::R:::eeRpppppppeorrorrrgsoosoooiijjijjjsteeteeetoccocccrrttrtttyy--y---aabbbA::B:::vvvvv12112.....00010

> **Note 注意**
>
> You can create one private repository and unlimited public repositories  using the free version of Docker Hub. For more information, visit the [Docker Hub subscription page](https://www.docker.com/pricing/)

> .
> 您可以使用 Docker Hub 的免费版本创建一个私有仓库和无限的公共仓库。有关更多信息，请访问 Docker Hub 订阅页面。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#try-it-out)

In this hands-on, you will learn how to build and push a Docker image to the Docker Hub repository.
在本实践实践中，您将学习如何构建 Docker 镜像并将其推送到 Docker Hub 存储库。

### [Sign up for a free Docker account 注册一个免费的 Docker 帐户](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#sign-up-for-a-free-docker-account)

1. If you haven't created one yet, head over to the [Docker Hub](https://hub.docker.com)

1.  page to sign up for a new Docker account.
   如果您尚未创建一个，请前往 Docker Hub 页面注册一个新的 Docker 帐户。

   ![Screenshot of the official Docker Hub page showing the Sign up page](https://docs.docker.com/guides/docker-concepts/the-basics/images/dockerhub-signup.webp)

   You can use your Google or GitHub account to authenticate.
   您可以使用 Google 或 GitHub 帐户进行身份验证。

### [Create your first repository 创建您的第一个仓库](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#create-your-first-repository)

1. Sign in to [Docker Hub](https://hub.docker.com)

1. .
   登录到 Docker Hub。

2. Select the **Create repository** button in the top-right corner.
   选择右上角的“创建存储库”按钮。

3. Select your namespace (most likely your username) and enter `docker-quickstart` as the repository name.
   选择您的命名空间（很可能是您的用户名）并输入 `docker-quickstart` 作为存储库名称。

   ![Screenshot of the Docker Hub page that shows how to create a public repository](https://docs.docker.com/guides/docker-concepts/the-basics/images/create-hub-repository.webp)

4. Set the visibility to **Public**.
   将可见性设置为“公开”。

5. Select the **Create** button to create the repository.
   选择“创建”按钮以创建存储库。

That's it. You've successfully created your first repository. 🎉
就是这样。您已成功创建第一个仓库。🎉

This repository is empty right now. You'll now fix this by pushing an image to it.
此存储库现在是空的。现在，您将通过将图像推送到它来修复此问题。

### [Sign in with Docker Desktop 使用 Docker Desktop 登录](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#sign-in-with-docker-desktop)

1. [Download and install](https://www.docker.com/products/docker-desktop/)

1.  Docker Desktop, if not already installed.
   下载并安装 Docker Desktop（如果尚未安装）。
2. In the Docker Desktop GUI, select the **Sign in** button in the top-right corner
   在 Docker Desktop GUI 中，选择右上角的“登录”按钮

### [Clone sample Node.js code 克隆示例Node.js代码](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#clone-sample-nodejs-code)

In order to create an image, you first need a project. To get you started quickly, you'll use a sample Node.js project found at [github.com/dockersamples/helloworld-demo-node](https://github.com/dockersamples/helloworld-demo-node)

. This repository contains a pre-built Dockerfile necessary for building a Docker image.
为了创建图像，您首先需要一个项目。为了让您快速入门，您将使用在 github.com/dockersamples/helloworld-demo-node 找到的示例Node.js项目。此存储库包含构建  Docker 镜像所需的预构建 Dockerfile。

Don't worry about the specifics of the Dockerfile, as you'll learn about that in later sections.
不要担心 Dockerfile 的细节，因为你将在后面的部分中了解这一点。

1. Clone the GitHub repository using the following command:
   使用以下命令克隆 GitHub 存储库：

   

```console
git clone https://github.com/dockersamples/helloworld-demo-node
```

Navigate into the newly created directory.
导航到新创建的目录。



```console
cd helloworld-demo-node
```

Run the following command to build a Docker image, swapping out `YOUR_DOCKER_USERNAME` with your username.
运行以下命令以构建 Docker 镜像， `YOUR_DOCKER_USERNAME` 并替换为您的用户名。



```console
docker build -t YOUR_DOCKER_USERNAME/docker-quickstart .
```

> **Note 注意**
>
> Make sure you include the dot (.) at the end of the `docker build` command. This tells Docker where to find the Dockerfile.
> 请确保在 `docker build` 命令的末尾包含点 （.）。这会告诉 Docker 在哪里可以找到 Dockerfile。

Run the following command to list the newly created Docker image:
运行以下命令以列出新创建的 Docker 镜像：

```console
docker images
```

You will see output like the following:
您将看到如下所示的输出：

```console
REPOSITORY                                 TAG       IMAGE ID       CREATED         SIZE
YOUR_DOCKER_USERNAME/docker-quickstart   latest    476de364f70e   2 minutes ago   170MB
```

Start a container to test the image by running the following command (swap out the username with your own username):
通过运行以下命令启动容器以测试映像（将用户名替换为您自己的用户名）：



```console
docker run -d -p 8080:8080 YOUR_DOCKER_USERNAME/docker-quickstart 
```

You can verify if the container is working by visiting http://localhost:8080

 with your browser.
您可以通过使用浏览器访问 http://localhost:8080 来验证容器是否正常工作。

Use the [`docker tag`](https://docs.docker.com/reference/cli/docker/image/tag/) command to tag the Docker image. Docker tags allow you to label and version your images.
使用该 `docker tag` 命令标记 Docker 映像。Docker 标签允许您对图像进行标记和版本控制。

```console
docker tag YOUR_DOCKER_USERNAME/docker-quickstart YOUR_DOCKER_USERNAME/docker-quickstart:1.0 
```

Finally, it's time to push the newly built image to your Docker Hub repository by using the [`docker push`](https://docs.docker.com/reference/cli/docker/image/push/) command:
最后，是时候使用以下 `docker push` 命令将新构建的映像推送到 Docker Hub 存储库了：



```console
docker push YOUR_DOCKER_USERNAME/docker-quickstart:1.0
```

Open [Docker Hub](https://hub.docker.com)

1.  and navigate to your repository. Navigate to the **Tags** section and see your newly pushed image.
   打开 Docker Hub 并导航到您的存储库。导航到“标签”部分，然后查看新推送的图片。

   ![Screenshot of the Docker Hub page that displays the newly added image tag](https://docs.docker.com/guides/docker-concepts/the-basics/images/dockerhub-tags.webp)

In this walkthrough, you signed up for a Docker account, created your  first Docker Hub repository, and built, tagged, and pushed a container  image to your Docker Hub repository.
在本演练中，您注册了一个 Docker 帐户，创建了第一个 Docker Hub 存储库，并生成、标记了容器映像并将其推送到 Docker Hub 存储库。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#additional-resources)

- [Docker Hub Quickstart Docker Hub 快速入门](https://docs.docker.com/docker-hub/quickstart/)
- [Manage Docker Hub Repositories
  管理 Docker Hub 存储库](https://docs.docker.com/docker-hub/repos/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/#next-steps)

Now that you understand the basics of containers and images, you're ready to learn about Docker Compose.
现在，您已经了解了容器和映像的基础知识，可以学习 Docker Compose。

# 什么是 Docker Compose？

<iframe id="youtube-player-xhcUIK4fGtY" data-video-id="xhcUIK4fGtY" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - What is Docker Compose?" width="100%" height="100%" src="https://www.youtube.com/embed/xhcUIK4fGtY?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-15="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/#explanation)

If you've been following the guides so far, you've been working with  single container applications. But, now you're wanting to do something  more complicated - run databases, message queues, caches, or a variety  of other services. Do you install everything in a single container? Run  multiple containers? If you run multiple, how do you connect them all  together?
如果您到目前为止一直在遵循这些指南，那么您一直在使用单个容器应用程序。但是，现在你想要做一些更复杂的事情 - 运行数据库、消息队列、缓存或各种其他服务。您是否将所有东西都安装在一个容器中？运行多个容器？如果运行多个，如何将它们连接在一起？

One best practice for containers is that each container should do one thing and do it well. While there are exceptions to this rule, avoid the  tendency to have one container do multiple things.
容器的一个最佳实践是每个容器都应该做一件事，并且做得很好。虽然此规则也有例外，但请避免让一个容器执行多项操作的趋势。

You can use multiple `docker run` commands to start multiple containers. But, you'll soon realize you'll  need to manage networks, all of the flags needed to connect containers  to those networks, and more. And when you're done, cleanup is a little  more complicated.
您可以使用多个 `docker run` 命令来启动多个容器。但是，您很快就会意识到您需要管理网络、将容器连接到这些网络所需的所有标志等等。完成后，清理工作会稍微复杂一些。

With Docker Compose, you can define all of your containers and their  configurations in a single YAML file. If you include this file in your  code repository, anyone that clones your repository can get up and  running with a single command.
使用 Docker Compose，您可以在单个 YAML 文件中定义所有容器及其配置。如果将此文件包含在代码存储库中，则克隆存储库的任何人都可以使用单个命令启动并运行。

It's important to understand that Compose is a declarative tool - you simply define it and go. You don't always need to recreate everything from  scratch. If you make a change, run `docker compose up` again and Compose will reconcile the changes in your file and apply them intelligently.
重要的是要明白 Compose 是一个声明性工具 - 您只需定义它然后使用。您并不总是需要从头开始重新创建所有内容。如果您进行了更改，请再次运行 `docker compose up` ，Compose 将协调文件中的更改并智能地应用它们。

> **Dockerfile versus Compose file
> Dockerfile 与 Compose 文件**
>
> A Dockerfile provides instructions to build a container image while a  Compose file defines your running containers. Quite often, a Compose  file references a Dockerfile to build an image to use for a particular  service.
> Dockerfile 提供构建容器镜像的说明，而 Compose 文件定义正在运行的容器。很多时候，Compose 文件会引用 Dockerfile 来构建用于特定服务的镜像。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/#try-it-out)

In this hands-on, you will learn how to use a Docker Compose to run a  multi-container application. You'll use a simple to-do list app built  with Node.js and MySQL as a database server.
在本实践实践中，您将学习如何使用 Docker Compose 运行多容器应用程序。您将使用一个使用 Node.js 和 MySQL 构建的简单待办事项列表应用程序作为数据库服务器。

### [Start the application 启动应用程序](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/#start-the-application)

Follow the instructions to run the to-do list app on your system.
按照说明在您的系统上运行待办事项列表应用程序。

1. [Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

Open a terminal and [clone this sample application](https://github.com/dockersamples/todo-list-app)

.
打开一个终端并克隆此示例应用程序。

```console
git clone https://github.com/dockersamples/todo-list-app 
```

Navigate into the `todo-list-app` directory:
导航到 `todo-list-app` 目录：

```console
cd todo-list-app
```

Inside this directory, you'll find a file named `compose.yaml`. This YAML file is where all the magic happens! It defines all the  services that make up your application, along with their configurations. Each service specifies its image, ports, volumes, networks, and any  other settings necessary for its functionality. Take some time to  explore the YAML file and familiarize yourself with its structure.
在此目录中，您将找到一个名为 `compose.yaml` .这个YAML文件是所有魔术发生的地方！它定义了构成应用程序的所有服务及其配置。每个服务都指定其映像、端口、卷、网络以及其功能所需的任何其他设置。花一些时间浏览 YAML 文件并熟悉其结构。

Use the [`docker compose up`](https://docs.docker.com/reference/cli/docker/compose/up/) command to start the application:
使用以下 `docker compose up` 命令启动应用程序：

```console
docker compose up -d --build
```

When you run this command, you should see an output like this:
运行此命令时，应看到如下所示的输出：

```console
[+] Running 4/4
✔ app 3 layers [⣿⣿⣿]      0B/0B            Pulled           7.1s
  ✔ e6f4e57cc59e Download complete                          0.9s
  ✔ df998480d81d Download complete                          1.0s
  ✔ 31e174fedd23 Download complete                          2.5s
[+] Running 2/4
  ⠸ Network todo-list-app_default           Created         0.3s
  ⠸ Volume "todo-list-app_todo-mysql-data"  Created         0.3s
  ✔ Container todo-list-app-app-1           Started         0.3s
  ✔ Container todo-list-app-mysql-1         Started         0.3s
```

A lot happened here! A couple of things to call out:
这里发生了很多事情！有几件事需要注意：

- Two container images were downloaded from Docker Hub - node and MySQL
  从 Docker Hub 下载了两个容器镜像 - node 和 MySQL
- A network was created for your application
  已为您的应用程序创建了一个网络
- A volume was created to persist the database files between container restarts
  已创建一个卷，用于在容器重新启动之间保留数据库文件
- Two containers were started with all of their necessary config
  启动了两个容器及其所有必要的配置

If this feels overwhelming, don't worry! You'll get there!
如果这让人感到不知所措，请不要担心！你会到达那里的！

With everything now up and running, you can open http://localhost:3000

1.  in your browser to see the site. Feel free to add items to the list, check them off, and remove them.
   现在一切都启动并运行，您可以在浏览器中打开 http://localhost:3000 以查看该站点。随意将项目添加到列表中，检查它们，然后删除它们。

   ![A screenshot of a webpage showing the todo-list application running on port 3000](https://docs.docker.com/guides/docker-concepts/the-basics/images/todo-list-app.webp)

2. If you look at the Docker Desktop GUI, you can see the containers and dive deeper into their configuration.
   如果您查看 Docker Desktop GUI，您可以看到容器并更深入地了解其配置。

   ![A screenshot of Docker Desktop dashboard showing the list of containers running todo-list app](https://docs.docker.com/guides/docker-concepts/the-basics/images/todo-list-containers.webp)

### [Tear it down 把它拆下来](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/#tear-it-down)

Since this application was started using Docker Compose, it's easy to tear it all down when you're done.
由于此应用程序是使用 Docker Compose 启动的，因此在完成后很容易将其全部拆除。

1. In the CLI, use the [`docker compose down`](https://docs.docker.com/reference/cli/docker/compose/down/) command to remove everything:
   在 CLI 中，使用命令 `docker compose down` 删除所有内容：

```console
docker compose down
```

You'll see output similar to the following:
你将看到类似于以下内容的输出：You'll see output similar to the following：



```console
[+] Running 2/2
✔ Container todo-list-app-mysql-1  Removed        2.9s
✔ Container todo-list-app-app-1    Removed        0.1s
✔ Network todo-list-app_default    Removed        0.1s
```

> **Volume persistence 卷持久性**
>
> By default, volumes *aren't* automatically removed when you tear down a Compose stack. The idea is  that you might want the data back if you start the stack again.
> 默认情况下，当您拆除 Compose 堆栈时，卷不会自动删除。这个想法是，如果您再次启动堆栈，您可能希望返回数据。
>
> If you do want to remove the volumes, add the `--volumes` flag when running the `docker compose down` command:
> 如果确实要删除卷，请在运行命令 `docker compose down` 时添加标志 `--volumes` ：

1. > ```console
   > docker compose down --volumes
   > ```

2. Alternatively, you can use the Docker Desktop GUI to remove the containers by selecting the application stack and selecting the **Delete** button.
   或者，您可以使用 Docker Desktop GUI 通过选择应用程序堆栈并选择“删除”按钮来删除容器。

   ![A screenshot of the Docker Desktop GUI showing the containers view with an arrow pointing to the &quot;Delete&quot; button](https://docs.docker.com/guides/docker-concepts/the-basics/images/todo-list-delete.webp)

   > **Using the GUI for Compose stacks
   > 将 GUI 用于 Compose 堆栈**
   >
   > Note that if you remove the containers for a Compose app in the GUI, it's  removing only the containers. You'll have to manually remove the network and volumes if you want to do so.
   > 请注意，如果您在 GUI 中删除 Compose 应用的容器，则只会删除容器。如果需要，则必须手动删除网络和卷。

In this walkthrough, you learned how to use Docker Compose to start and stop a multi-container application.
在本演练中，您学习了如何使用 Docker Compose 启动和停止多容器应用程序。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/#additional-resources)

This page was a brief introduction to Compose. In the following resources,  you can dive deeper into Compose and how to write Compose files.
本页是对 Compose 的简要介绍。在以下资源中，您可以更深入地了解 Compose 以及如何编写 Compose 文件。

- [Overview of Docker Compose
  Docker Compose 概述](https://docs.docker.com/compose/)
- [Overview of Docker Compose CLI
  Docker Compose CLI概述](https://docs.docker.com/compose/reference/)
- [How Compose works Compose 的工作原理](https://docs.docker.com/compose/compose-application-model/)



## 构建镜像

# Understanding the image layers 了解图像层

<iframe id="youtube-player-wJwqtAkmtQA" data-video-id="wJwqtAkmtQA" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Understanding image layers" width="100%" height="100%" src="https://www.youtube.com/embed/wJwqtAkmtQA?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-14="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#explanation)

As you learned in [What is an image?](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-an-image/), container images are composed of layers. And each of these layers, once created, are immutable. But, what does that actually mean? And how are  those layers used to create the filesystem a container can use?
正如您在什么是镜像中所学到的，容器镜像由层组成。这些层中的每一层一旦创建，都是不可变的。但是，这实际上意味着什么？如何使用这些层来创建容器可以使用的文件系统？

### [Image layers 图像层](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#image-layers)

Each layer in an image contains a set of filesystem changes - additions,  deletions, or modifications. Let’s look at a theoretical image:
图像中的每一层都包含一组文件系统更改 - 添加、删除或修改。让我们看一个理论图像：

1. The first layer adds basic commands and a package manager, such as apt.
   第一层添加基本命令和包管理器，例如 apt。
2. The second layer installs a Python runtime and pip for dependency management.
   第二层安装 Python 运行时和 pip 进行依赖项管理。
3. The third layer copies in an application’s specific requirements.txt file.
   第三层复制应用程序的特定requirements.txt文件。
4. The fourth layer installs that application’s specific dependencies.
   第四层安装该应用程序的特定依赖项。
5. The fifth layer copies in the actual source code of the application.
   第五层复制应用程序的实际源代码。

This example might look like:
此示例可能如下所示：

![screenshot of the flowchart showing the concept of the image layers](https://docs.docker.com/guides/docker-concepts/building-images/images/container_image_layers.webp)

This is beneficial because it allows layers to be reused between images. For example, imagine you wanted to create another Python application. Due  to layering, you can leverage the same Python base. This will make  builds faster and reduce the amount of storage and bandwidth required to distribute the images. The image layering might look similar to the  following:
这是有益的，因为它允许在图像之间重复使用图层。例如，假设您想要创建另一个 Python 应用程序。由于分层，您可以利用相同的 Python 基础。这将使构建速度更快，并减少分发图像所需的存储量和带宽。图像分层可能类似于以下内容：

![screenshot of the flowchart showing the benefits of the image layering](https://docs.docker.com/guides/docker-concepts/building-images/images/container_image_layer_reuse.webp)

Layers let you extend images of others by reusing their base layers, allowing  you to add only the data that your application needs.
通过层，您可以通过重用其他层的基础层来扩展其他层的图像，从而仅允许您添加应用程序所需的数据。

### [Stacking the layers 堆叠图层](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#stacking-the-layers)

Layering is made possible by content-addressable storage and union filesystems.  While this will get technical, here’s how it works:
内容可寻址存储和联合文件系统使分层成为可能。虽然这会变得技术性，但以下是它的工作原理：

1. After each layer is downloaded, it is extracted into its own directory on the host filesystem.
   下载每一层后，它被解压缩到主机文件系统上自己的目录中。
2. When you run a container from an image, a union filesystem is created where  layers are stacked on top of each other, creating a new and unified  view.
   当您从映像运行容器时，将创建一个联合文件系统，其中层堆叠在一起，从而创建新的统一视图。
3. When the container starts, its root directory is set to the location of this unified directory, using `chroot`.
   当容器启动时，其根目录将设置为此统一目录的位置，使用 `chroot` .

When the union filesystem is created, in addition to the image layers, a  directory is created specifically for the running container. This allows the container to make filesystem changes while allowing the original  image layers to remain untouched. This enables you to run multiple  containers from the same underlying image.
创建联合文件系统时，除了镜像层之外，还会专门为正在运行的容器创建一个目录。这允许容器进行文件系统更改，同时允许原始图像层保持不变。这使您能够从同一底层映像运行多个容器。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#try-it-out)

In this hands-on guide, you will create new image layers manually using the [`docker container commit`](https://docs.docker.com/reference/cli/docker/container/commit/)

 command. Note that you’ll rarely create images this way, as you’ll normally [use a Dockerfile](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/). But, it makes it easier to understand how it’s all working.
在本实践指南中，您将使用该 `docker container commit` 命令手动创建新的图像图层。请注意，您很少以这种方式创建映像，因为您通常会使用 Dockerfile。但是，它使人们更容易理解这一切是如何工作的。

### [Create a base image 创建基础映像](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#create-a-base-image)

In this first step, you will create your own base image that you will then use for the following steps.
在第一步中，您将创建自己的基础映像，然后将该映像用于后续步骤。

1. [Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

In a terminal, run the following command to start a new container:
在终端中，运行以下命令以启动新容器：

```console
 docker run --name=base-container -ti ubuntu
```

Once the image has been downloaded and the container has started, you should see a new shell prompt. This is running inside your container. It will  look similar to the following (the container ID will vary):
下载映像并启动容器后，您应该会看到一个新的 shell 提示符。它正在您的容器内运行。它看起来类似于以下内容（容器 ID 会有所不同）：



```console
root@d8c5ca119fcd:/#
```

Inside the container, run the following command to install Node.js:
在容器内部，运行以下命令以安装 Node.js：



```console
 apt update && apt install -y nodejs
```

When this command runs, it downloads and installs Node inside the container. In the context of the union filesystem, these filesystem changes occur  within the directory unique to this container.
当此命令运行时，它会在容器内下载并安装 Node。在联合文件系统的上下文中，这些文件系统更改发生在此容器唯一的目录中。

Validate if Node is installed by running the following command:
通过运行以下命令验证是否已安装 Node：

```console
 node -e 'console.log("Hello world!")'
```

You should then see a “Hello world!” appear in the console.
然后，您应该会在控制台中看到“Hello world！”。

Now that you have Node installed, you’re ready to save the changes you’ve  made as a new image layer, from which you can start new containers or  build new images. To do so, you will use the [`docker container commit`](https://docs.docker.com/reference/cli/docker/container/commit/)

 command. Run the following command in a new terminal:
现在，您已安装 Node，可以将所做的更改保存为新的映像层，从中可以启动新容器或构建新映像。为此，您将使用以下 `docker container commit` 命令。在新终端中运行以下命令：



```console
 docker container commit -m "Add node" base-container node-base
```

View the layers of your image using the `docker image history` command:
使用以下 `docker image history` 命令查看图像的层：

```console
 docker image history node-base
```

You will see output similar to the following:
您将看到类似于以下内容的输出：

```console
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
d5c1fca2cdc4   10 seconds ago   /bin/bash                                       126MB     Add node
2b7cc08dcdbb   5 weeks ago      /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
<missing>      5 weeks ago      /bin/sh -c #(nop) ADD file:07cdbabf782942af0…   69.2MB
<missing>      5 weeks ago      /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
<missing>      5 weeks ago      /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
<missing>      5 weeks ago      /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH     0B
<missing>      5 weeks ago      /bin/sh -c #(nop)  ARG RELEASE                  0B
```

Note the “Add node” comment on the top line. This layer contains the Node.js install you just made.
请注意第一行的“添加节点”注释。此层包含您刚刚进行Node.js安装。

To prove your image has Node installed, you can start a new container using this new image:
为了证明您的镜像已安装 Node，您可以使用此新镜像启动一个新容器：



```console
 docker run node-base node -e "console.log('Hello again')"
```

With that, you should get a “Hello again” output in the terminal, showing Node was installed and working.
这样，您应该在终端中得到“Hello again”输出，显示 Node 已安装并正在运行。

Now that you’re done creating your base image, you can remove that container:
现在，您已完成创建基础映像，可以删除该容器：



1. ```console
    docker rm -f base-container
   ```

> **Base image definition 基础镜像定义**
>
> A base image is a foundation for building other images. It's possible to  use any images as a base image. However, some images are intentionally  created as building blocks, providing a foundation or starting point for an application.
> 基础镜像是构建其他镜像的基础。可以将任何图像用作基础图像。但是，有些图像是有意创建的，作为构建基块，为应用程序提供基础或起点。
>
> In this example, you probably won’t deploy this `node-base` image, as it doesn’t actually do anything yet. But it’s a base you can use for other builds.
> 在此示例中，您可能不会部署此 `node-base` 映像，因为它实际上尚未执行任何操作。但它是您可以用于其他构建的基础。

### [Build an app image 构建应用镜像](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#build-an-app-image)

Now that you have a base image, you can extend that image to build additional images.
现在，您已经有了基础映像，可以扩展该映像以构建其他映像。

1. Start a new container using the newly created node-base image:
   使用新创建的节点基础映像启动新容器：

```console
 docker run --name=app-container -ti node-base
```

Inside of this container, run the following command to create a Node program:
在此容器内部，运行以下命令以创建 Node 程序：



```console
 echo 'console.log("Hello from an app")' > app.js
```

To run this Node program, you can use the following command and see the message printed on the screen:
要运行此 Node 程序，您可以使用以下命令并查看屏幕上打印的消息：

```console
 node app.js
```

In another terminal, run the following command to save this container’s changes as a new image:
在另一个终端中，运行以下命令以将此容器的更改另存为新映像：



```console
 docker container commit -c "CMD node app.js" -m "Add app" app-container sample-app
```

This command not only creates a new image named `sample-app`, but also adds additional configuration to the image to set the default  command when starting a container. In this case, you are setting it to  automatically run `node app.js`.
此命令不仅会创建一个名为 `sample-app` 的新镜像，还会向镜像添加额外的配置，以在启动容器时设置默认命令。在这种情况下，您将其设置为自动运行 `node app.js` 。

In a terminal outside of the container, run the following command to view the updated layers:
在容器外部的终端中，运行以下命令以查看更新的层：

```console
 docker image history sample-app
```

You’ll then see output that looks like the following. Note the top layer  comment has “Add app” and the next layer has “Add node”:
然后，你将看到如下所示的输出。请注意，顶层注释包含“添加应用”，下一层包含“添加节点”：

```console
IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
c1502e2ec875   About a minute ago   /bin/bash                                       33B       Add app
5310da79c50a   4 minutes ago        /bin/bash                                       126MB     Add node
2b7cc08dcdbb   5 weeks ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
<missing>      5 weeks ago          /bin/sh -c #(nop) ADD file:07cdbabf782942af0…   69.2MB
<missing>      5 weeks ago          /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
<missing>      5 weeks ago          /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
<missing>      5 weeks ago          /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH     0B
<missing>      5 weeks ago          /bin/sh -c #(nop)  ARG RELEASE                  0B
```

Finally, start a new container using the brand new image. Since you specified  the default command, you can use the following command:
最后，使用全新的图像启动一个新容器。由于您指定了默认命令，因此可以使用以下命令：

```console
 docker run sample-app
```

You should see your greeting appear in the terminal, coming from your Node program.
您应该看到您的问候语出现在终端中，来自您的 Node 程序。

Now that you’re done with your containers, you can remove them using the following command:
现在，您已完成使用容器，可以使用以下命令删除它们：



1. ```console
    docker rm -f app-container
   ```

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#additional-resources)

If you’d like to dive deeper into the things you learned, check out the following resources:
如果您想更深入地了解所学内容，请查看以下资源：

- [docker image history CLI reference
  docker 镜像历史 CLI 参考](https://docs.docker.com/reference/cli/docker/image/history/)
- [docker image layers Docker 镜像层](https://docs.docker.com/build/guide/layers/)
- [`docker container commit`](https://docs.docker.com/reference/cli/docker/container/commit/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/building-images/understanding-image-layers/#next-steps)

As hinted earlier, most image builds don’t use `docker container commit`. Instead, you’ll use a Dockerfile which automates these steps for you.
如前所述，大多数映像构建不使用 `docker container commit` .相反，您将使用 Dockerfile，它为您自动执行这些步骤。

# Writing a Dockerfile 编写 Dockerfile

<iframe id="youtube-player-Jx8zoIhiP4c" data-video-id="Jx8zoIhiP4c" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Writing a Dockerfile" width="100%" height="100%" src="https://www.youtube.com/embed/Jx8zoIhiP4c?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-18="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#explanation)

A Dockerfile is a text-based document that's used to create a container  image. It provides instructions to the image builder on the commands to  run, files to copy, startup command, and more.
Dockerfile 是一个基于文本的文档，用于创建容器镜像。它为映像构建器提供有关要运行的命令、要复制的文件、启动命令等的说明。

As an example, the following Dockerfile would produce a ready-to-run Python application:
例如，以下 Dockerfile 将生成一个随时可以运行的 Python 应用程序：

```dockerfile
FROM python:3.12
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY src ./src
EXPOSE 5000

# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

### [Common instructions 常用说明](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#common-instructions)

Some of the most common instructions in a `Dockerfile` include:
其中 `Dockerfile` 一些最常见的说明包括：

- `FROM <image>` - this specifies the base image that the build will extend.
   `FROM <image>` - 这指定了构建将扩展的基础映像。
- `WORKDIR <path>` - this instruction specifies the "working directory" or the path in the image where files will be copied and commands will be executed.
   `WORKDIR <path>` - 此指令指定了“工作目录”或图像中的路径，将在其中复制文件并执行命令。
- `COPY <host-path> <image-path>` - this instruction tells the builder to copy files from the host and put them into the container image.
   `COPY <host-path> <image-path>` - 此指令告诉构建器从主机复制文件并将它们放入容器镜像中。
- `RUN <command>` - this instruction tells the builder to run the specified command.
   `RUN <command>` - 此指令告诉构建器运行指定的命令。
- `ENV <name> <value>` - this instruction sets an environment variable that a running container will use.
   `ENV <name> <value>` - 此指令设置一个正在运行的容器将使用的环境变量。
- `EXPOSE <port-number>` - this instruction sets configuration on the image that indicates a port the image would like to expose.
   `EXPOSE <port-number>` - 此指令在映像上设置配置，指示映像要公开的端口。
- `USER <user-or-uid>` - this instruction sets the default user for all subsequent instructions.
   `USER <user-or-uid>` - 此指令为所有后续指令设置默认用户。
- `CMD ["<command>", "<arg1>"]` - this instruction sets the default command a container using this image will run.
   `CMD ["<command>", "<arg1>"]` - 此指令设置使用此镜像的容器将运行的默认命令。

To read through all of the instructions or go into greater detail, check out the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

.
要通读所有说明或更详细地了解，请查看 Dockerfile 参考。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#try-it-out)

Just as you saw with the previous example, a Dockerfile typically follows these steps:
正如您在上一个示例中看到的那样，Dockerfile 通常遵循以下步骤：

1. Determine your base image
   确定基础映像
2. Install application dependencies
   安装应用程序依赖项
3. Copy in any relevant source code and/or binaries
   复制任何相关的源代码和/或二进制文件
4. Configure the final image
   配置最终映像

In this quick hands-on guide, you'll write a Dockerfile that builds a  simple Node.js application. If you're not familiar with JavaScript-based applications, don't worry. It isn't necessary for following along with  this guide.
在这个快速动手指南中，你将编写一个 Dockerfile，用于构建一个简单的 Node.js 应用程序。如果您不熟悉基于 JavaScript 的应用程序，请不要担心。无需遵循本指南。

### [Set up 建立](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#set-up)

[Download this ZIP file](https://github.com/docker/getting-started-todo-app/raw/build-image-from-scratch/app.zip)

 and extract the contents into a directory on your machine.
下载此 ZIP 文件并将内容解压缩到计算机上的目录中。

### [Creating the Dockerfile 创建 Dockerfile](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#creating-the-dockerfile)

Now that you have the project, you’re ready to create the `Dockerfile`.
现在，您已经有了项目，可以创建 `Dockerfile` .

1. [Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

Create a file named `Dockerfile` in the same folder as the file `package.json`.
在与文件 `package.json` 相同的文件夹中创建 `Dockerfile` 一个名为的文件。

> **Dockerfile file extensions
> Dockerfile 文件扩展名**
>
> It's important to note that the `Dockerfile` has *no* file extension. Some editors will automatically add an extension to the file (or complain it doesn't have one).
> 需要注意的是，它 `Dockerfile` 没有文件扩展名。一些编辑器会自动向文件添加扩展名（或抱怨它没有扩展名）。

In the `Dockerfile`, define your base image by adding the following line:
在 中， `Dockerfile` 通过添加以下行来定义基础映像：



```dockerfile
FROM node:20-alpine
```

Now, define the working directory by using the `WORKDIR` instruction. This will specify where future commands will run and the  directory files will be copied inside the container image.
现在，使用指令 `WORKDIR` 定义工作目录。这将指定将来命令的运行位置，并将目录文件复制到容器映像中。

```dockerfile
WORKDIR /usr/local/app
```

Copy all of the files from your project on your machine into the container image by using the `COPY` instruction:
使用以下 `COPY` 说明将计算机上项目中的所有文件复制到容器映像中：

```dockerfile
COPY . .
```

Install the app's dependencies by using the `yarn` CLI and package manager. To do so, run a command using the `RUN` instruction:
使用 `yarn` CLI 和包管理器安装应用的依赖项。为此，请使用以下 `RUN` 指令运行命令：



```dockerfile
RUN yarn install --production
```

Finally, specify the default command to run by using the `CMD` instruction:
最后，使用以下指令指定要运行的 `CMD` 默认命令：



```dockerfile
CMD ["node", "./src/index.js"]
```

And with that, you should have the following Dockerfile:
有了这个，你应该有以下的Dockerfile：



1. ```dockerfile
   FROM node:20-alpine
   WORKDIR /app
   COPY . .
   RUN yarn install --production
   CMD ["node", "./src/index.js"]
   ```

> **This Dockerfile isn't production-ready yet
> 此 Dockerfile 尚未准备好用于生产环境**
>
> It's important to note that this Dockerfile is *not* following all of the best practices yet (by design). It will build the app, but the builds won't be as fast as they could be and the image could be made more secure.
> 需要注意的是，此 Dockerfile 尚未遵循所有最佳实践（按设计）。它将构建应用程序，但构建速度不会像它们可能的那样快，并且图像可能会更加安全。
>
> Keep reading to learn more about how to make the image maximize the build cache, run as a non-root user, and multi-stage builds.
> 继续阅读以了解有关如何使映像最大化构建缓存、以非 root 用户身份运行以及多阶段构建的更多信息。

> **Containerize new projects quickly with `docker init`
> 使用以下功能 `docker init` 快速容器化新项目**
>
> The `docker init` command will analyze your project and quickly create a Dockerfile, a `compose.yaml`, and a `.dockerignore`, helping you get up and going. Since you're learning about Dockerfiles specifically here, you won't use it now. But, [learn more about it here](https://docs.docker.com/engine/reference/commandline/init/).
> 该 `docker init` 命令将分析您的项目并快速创建 Dockerfile、a `compose.yaml` 和 a `.dockerignore` ，帮助您开始工作。由于您在这里专门学习 Dockerfiles，因此您现在不会使用它。但是，请在此处了解更多信息。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#additional-resources)

To learn more about writing a Dockerfile, visit the following resources:
若要了解有关编写 Dockerfile 的更多信息，请访问以下资源：

- [Dockerfile reference Dockerfile 参考](https://docs.docker.com/reference/dockerfile/)
- [Dockerfile best practices
  Dockerfile 最佳实践](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Base images 基础图像](https://docs.docker.com/build/building/base-images/)
- [Getting started with Docker Init
  Docker Init 入门](https://docs.docker.com/reference/cli/docker/init/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/#next-steps)

Now that you have created a Dockerfile and learned the basics, it's time to learn about building, tagging, and pushing the images.
现在，您已经创建了 Dockerfile 并学习了基础知识，接下来可以学习如何构建、标记和推送镜像了。

[Build, tag and publish the Image
构建、标记和发布映像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/)

# Build, tag, and publish an image 构建、标记和发布映像

<iframe id="youtube-player-chiiGLlYRlY" data-video-id="chiiGLlYRlY" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Build, tag, and publish an image" width="100%" height="100%" src="https://www.youtube.com/embed/chiiGLlYRlY?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-15="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#explanation)

In this guide, you will learn the following:
在本指南中，您将学习以下内容：

- Building images - the process of building an image based on a `Dockerfile`
  构建镜像 - 基于 `Dockerfile` 
- Tagging images - the process of giving an image a name, which also determines where the image can be distributed
  标记图像 - 为图像命名的过程，这也决定了图像可以分布在哪里
- Publishing images - the process to distribute or share the newly created image using a container registry
  发布映像 - 使用容器注册表分发或共享新创建的映像的过程

### [Building images 构建镜像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#building-images)

Most often, images are built using a Dockerfile. The most basic `docker build` command might look like the following:
大多数情况下，映像是使用 Dockerfile 构建的。最基本 `docker build` 的命令可能如下所示：

```bash
docker build .
```

The final `.` in the command provides the path or URL to the [build context](https://docs.docker.com/build/building/context/#what-is-a-build-context)

. At this location, the builder will find the `Dockerfile` and other referenced files.
命令中的最后一个 `.` 提供生成上下文的路径或 URL。在此位置，构建器将找到 `Dockerfile` 和其他引用的文件。

When you run a build, the builder pulls the base image, if needed, and then runs the instructions specified in the Dockerfile.
运行生成时，生成器会根据需要拉取基础映像，然后运行 Dockerfile 中指定的说明。

With the previous command, the image will have no name, but the output will  provide the ID of the image. As an example, the previous command might  produce the following output:
使用上一个命令时，图像将没有名称，但输出将提供图像的 ID。例如，上一个命令可能会生成以下输出：

```console
 docker build .
[+] Building 3.5s (11/11) FINISHED                                              docker:desktop-linux
 => [internal] load build definition from Dockerfile                                            0.0s
 => => transferring dockerfile: 308B                                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.12                                  0.0s
 => [internal] load .dockerignore                                                               0.0s
 => => transferring context: 2B                                                                 0.0s
 => [1/6] FROM docker.io/library/python:3.12                                                    0.0s
 => [internal] load build context                                                               0.0s
 => => transferring context: 123B                                                               0.0s
 => [2/6] WORKDIR /usr/local/app                                                                0.0s
 => [3/6] RUN useradd app                                                                       0.1s
 => [4/6] COPY ./requirements.txt ./requirements.txt                                            0.0s
 => [5/6] RUN pip install --no-cache-dir --upgrade -r requirements.txt                          3.2s
 => [6/6] COPY ./app ./app                                                                      0.0s
 => exporting to image                                                                          0.1s
 => => exporting layers                                                                         0.1s
 => => writing image sha256:9924dfd9350407b3df01d1a0e1033b1e543523ce7d5d5e2c83a724480ebe8f00    0.0s
```

With the previous output, you could start a container by using the referenced image:
在前面的输出中，可以使用引用的映像启动容器：



```console
docker run sha256:9924dfd9350407b3df01d1a0e1033b1e543523ce7d5d5e2c83a724480ebe8f00
```

That name certainly isn't memorable, which is where tagging becomes useful.
这个名字当然不会令人难忘，这就是标记变得有用的地方。

### [Tagging images 标记图像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#tagging-images)

Tagging images is the method to provide an image with a memorable name.  However, there is a structure to the name of an image. A full image name has the following structure:
标记图像是为图像提供具有令人难忘的名称的方法。但是，图像的名称有一个结构。完整的映像名称具有以下结构：



```text
[HOST[:PORT_NUMBER]/]PATH[:TAG]
```

- `HOST`: The optional registry hostname where the image is located. If no host is specified, Docker's public registry at `docker.io` is used by default.
   `HOST` ：映像所在的可选注册表主机名。如果未指定主机，则默认使用 Docker 的公共注册表 at `docker.io` 。
- `PORT_NUMBER`: The registry port number if a hostname is provided
   `PORT_NUMBER` ：如果提供了主机名，则为注册表端口号
- `PATH`: The path of the image, consisting of slash-separated components. For Docker Hub, the format follows `[NAMESPACE/]REPOSITORY`, where namespace is either a user's or organization's name. If no namespace is specified, `library` is used, which is the namespace for Docker Official Images.
   `PATH` ：图像的路径，由斜杠分隔的组件组成。对于 Docker Hub，格式如下 `[NAMESPACE/]REPOSITORY` ，其中 namespace 是用户或组织的名称。如果未指定命名空间， `library` 则使用命名空间，即 Docker 官方镜像的命名空间。
- `TAG`: A custom, human-readable identifier that's typically used to identify  different versions or variants of an image. If no tag is specified, `latest` is used by default.
   `TAG` ：一种自定义的、人类可读的标识符，通常用于识别图像的不同版本或变体。如果未指定标记， `latest` 则默认使用。

Some examples of image names include:
图像名称的一些示例包括：

- `nginx`, equivalent to `docker.io/library/nginx:latest`: this pulls an image from the `docker.io` registry, the `library` namespace, the `nginx` image repository, and the `latest` tag.
   `nginx` ，等同于 `docker.io/library/nginx:latest` ：这将从 `docker.io` 注册表、 `library` 命名空间、 `nginx` 图像存储库和 `latest` 标签中提取图像。
- `docker/welcome-to-docker`, equivalent to `docker.io/docker/welcome-to-docker:latest`: this pulls an image from the `docker.io` registry, the `docker` namespace, the `welcome-to-docker` image repository, and the `latest` tag
   `docker/welcome-to-docker` ，等效于 `docker.io/docker/welcome-to-docker:latest` ：这将从 `docker.io` 注册表、 `docker` 命名空间、 `welcome-to-docker` 图像仓库和 `latest` 标签中拉取图像
- `ghcr.io/dockersamples/example-voting-app-vote:pr-311`: this pulls an image from the GitHub Container Registry, the `dockersamples` namespace, the `example-voting-app-vote` image repository, and the `pr-311` tag
   `ghcr.io/dockersamples/example-voting-app-vote:pr-311` ：这将从 GitHub 容器注册表、 `dockersamples` 命名空间、 `example-voting-app-vote` 图像仓库和 `pr-311` 标签中提取图像

To tag an image during a build, add the `-t` or `--tag` flag:
要在构建过程中标记图像，请添加 `-t` or `--tag` 标志：

```console
docker build -t my-username/my-image .
```

If you've already built an image, you can add another tag to the image by using the [`docker image tag`](https://docs.docker.com/engine/reference/commandline/image_tag/)

 command:
如果您已构建一个映像，则可以使用以下 `docker image tag` 命令向映像添加另一个标记：



```console
docker image tag my-username/my-image another-username/another-image:v1
```

### [Publishing images 发布图像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#publishing-images)

Once you have an image built and tagged, you're ready to push it to a registry. To do so, use the [`docker push`](https://docs.docker.com/engine/reference/commandline/image_push/)

 command:
一旦您构建并标记了映像，您就可以将其推送到注册表了。为此，请使用以下 `docker push` 命令：



```console
docker push my-username/my-image
```

Within a few seconds, all of the layers for your image will be pushed to the registry.
在几秒钟内，图像的所有层都将被推送到注册表。

> **Requiring authentication 要求身份验证**
>
> Before you're able to push an image to a repository, you will need to be authenticated. To do so, simply use the [docker login](https://docs.docker.com/engine/reference/commandline/login/)

>  command.
> 在将映像推送到存储库之前，您需要进行身份验证。为此，只需使用 docker login 命令即可。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#try-it-out)

In this hands-on guide, you will build a simple image using a provided Dockerfile and push it to Docker Hub.
在本实践指南中，您将使用提供的 Dockerfile 构建一个简单的映像，并将其推送到 Docker Hub。

### [Set up 建立](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#set-up)

1. Get the sample application.
   获取示例应用程序。

   If you have Git, you can clone the repository for the sample application.  Otherwise, you can download the sample application. Choose one of the  following options.
   如果您有 Git，则可以克隆示例应用程序的存储库。否则，您可以下载示例应用程序。选择以下选项之一。

------

Use the following command in a terminal to clone the sample application repository.
在终端中使用以下命令克隆样本应用程序存储库。

```console
 git clone https://github.com/docker/getting-started-todo-app
```

------

[Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

If you don't have a Docker account yet, [create one now](https://hub.docker.com/)

1. . Once you've done that, sign in to Docker Desktop using that account.
   如果您还没有 Docker 帐户，请立即创建一个。完成此操作后，使用该帐户登录到 Docker Desktop。

### [Build an image 构建镜像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#build-an-image)

Now that you have a repository on Docker Hub, it's time for you to build an image and push it to the repository.
现在，您在 Docker Hub 上已经有了一个存储库，是时候构建一个镜像并将其推送到存储库了。

1. Using a terminal in the root of the sample app repository, run the following command. Replace `YOUR_DOCKER_USERNAME` with your Docker Hub username:
   使用示例应用程序存储库根目录中的终端，运行以下命令。替换为 `YOUR_DOCKER_USERNAME` 您的 Docker Hub 用户名：

```console
 docker build -t YOUR_DOCKER_USERNAME/concepts-build-image-demo .
```

As an example, if your username is `mobywhale`, you would run the command:
例如，如果您的用户名是 `mobywhale` ，您将运行以下命令：

```console
 docker build -t mobywhale/concepts-build-image-demo .
```

Once the build has completed, you can view the image by using the following command:
生成完成后，可以使用以下命令查看映像：



```console
 docker image ls
```

The command will produce output similar to the following:
该命令将生成类似于以下内容的输出：

```plaintext
REPOSITORY                             TAG       IMAGE ID       CREATED          SIZE
mobywhale/concepts-build-image-demo    latest    746c7e06537f   24 seconds ago   354MB
```

You can actually view the history (or how the image was created) by using the [docker image history](https://docs.docker.com/reference/cli/docker/image/history/) command:
实际上，您可以使用 docker image history 命令查看历史记录（或映像的创建方式）：

```console
 docker image history mobywhale/concepts-build-image-demo
```

You'll then see output similar to the following:
然后，你将看到类似于以下内容的输出：

1. ```plaintext
   IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
   f279389d5f01   8 seconds ago   CMD ["node" "./src/index.js"]                   0B        buildkit.dockerfile.v0
   <missing>      8 seconds ago   EXPOSE map[3000/tcp:{}]                         0B        buildkit.dockerfile.v0 
   <missing>      8 seconds ago   WORKDIR /app                                    8.19kB    buildkit.dockerfile.v0
   <missing>      4 days ago      /bin/sh -c #(nop)  CMD ["node"]                 0B
   <missing>      4 days ago      /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
   <missing>      4 days ago      /bin/sh -c #(nop) COPY file:4d192565a7220e13…   20.5kB
   <missing>      4 days ago      /bin/sh -c apk add --no-cache --virtual .bui…   7.92MB
   <missing>      4 days ago      /bin/sh -c #(nop)  ENV YARN_VERSION=1.22.19     0B
   <missing>      4 days ago      /bin/sh -c addgroup -g 1000 node     && addu…   126MB
   <missing>      4 days ago      /bin/sh -c #(nop)  ENV NODE_VERSION=20.12.0     0B
   <missing>      2 months ago    /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
   <missing>      2 months ago    /bin/sh -c #(nop) ADD file:d0764a717d1e9d0af…   8.42MB
   ```

   This output shows the layers of the image, highlighting the layers you added and those that were inherited from your base image.
   此输出显示图像的图层，突出显示您添加的图层以及从基础图像继承的图层。

### [Push the image 推送镜像](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#push-the-image)

Now that you have an image built, it's time to push the image to a registry.
现在，您已经构建了一个映像，可以将该映像推送到注册表了。

1. Push the image using the [docker push](https://docs.docker.com/reference/cli/docker/image/push/) command:
   使用 docker push 命令推送镜像：

   

1. ```console
    docker push YOUR_DOCKER_USERNAME/concepts-build-image-demo
   ```

   If you receive a `requested access to the resource is denied`, make sure you are both logged in and that your Docker username is correct in the image tag.
   如果您收到 ， `requested access to the resource is denied` 请确保您都已登录，并且您的 Docker 用户名在图像标记中是正确的。

   After a moment, your image should be pushed to Docker Hub.
   片刻之后，您的镜像应该会被推送到 Docker Hub。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#additional-resources)

To learn more about building, tagging, and publishing images, visit the following resources:
要了解有关构建、标记和发布图像的更多信息，请访问以下资源：

- [What is a build context?
  什么是构建上下文？](https://docs.docker.com/build/building/context/#what-is-a-build-context)
- [docker build reference Docker 构建参考](https://docs.docker.com/engine/reference/commandline/image_build/)
- [docker image tag reference
  Docker 镜像标签参考](https://docs.docker.com/engine/reference/commandline/image_tag/)
- [docker push reference Docker 推送参考](https://docs.docker.com/engine/reference/commandline/image_push/)
- [What is a registry?
  什么是注册表？](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-registry/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/building-images/build-tag-and-publish-an-image/#next-steps)

Now that you have learned about building and publishing images, it's time  to learn how to speed up the build process using the Docker build cache.
现在，您已经了解了如何构建和发布镜像，是时候学习如何使用 Docker 构建缓存来加快构建过程了。

[Using the build cache
](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/)

# Using the build cache 使用构建缓存

<iframe id="youtube-player-Ri6jMknjprY" data-video-id="Ri6jMknjprY" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Using the build cache" width="100%" height="100%" src="https://www.youtube.com/embed/Ri6jMknjprY?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-27="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/#explanation)

Consider the following Dockerfile that you created for the [getting-started](https://docs.docker.com/guides/docker-concepts/building-images/writing-a-dockerfile/) app.
请考虑为入门应用创建的以下 Dockerfile。

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "./src/index.js"]
```

When you run the `docker build` command to create a new image, Docker executes each instruction in your Dockerfile, creating a layer for each command and in the order  specified. For each instruction, Docker checks whether it can reuse the  instruction from a previous build. If it finds that you've already  executed a similar instruction before, Docker doesn't need to redo it.  Instead, it’ll use the cached result. This way, your build process  becomes faster and more efficient, saving you valuable time and  resources.
当您运行命令 `docker build` 以创建新映像时，Docker 会执行 Dockerfile 中的每条指令，并按照指定的顺序为每个命令创建一个层。对于每条指令，Docker  都会检查它是否可以重用先前构建的指令。如果它发现你之前已经执行过类似的指令，Docker  不需要重做它。相反，它将使用缓存的结果。这样，您的构建过程就会变得更快、更高效，从而为您节省宝贵的时间和资源。

Using the build cache effectively lets you achieve faster builds by reusing  results from previous builds and skipping unnecessary work. In order to maximize cache usage and avoid resource-intensive and  time-consuming rebuilds, it's important to understand how cache  invalidation works. Here are a few examples of situations that can cause cache to be  invalidated:
有效地使用生成缓存，可以重复使用先前生成的结果并跳过不必要的工作，从而更快地生成。为了最大限度地提高缓存使用率并避免资源密集型和耗时的重建，了解缓存失效的工作原理非常重要。以下是可能导致缓存失效的一些情况示例：

- Any changes to the command of a `RUN` instruction invalidates that layer. Docker detects the change and invalidates the build cache if there's any modification to a `RUN` command in your Dockerfile.
  对 `RUN` 指令命令的任何更改都会使该层失效。Docker 会检测到更改，如果 Dockerfile 中 `RUN` 的命令有任何修改，则会使构建缓存失效。
- Any changes to files copied into the image with the `COPY` or `ADD` instructions. Docker keeps an eye on any alterations to files within  your project directory. Whether it's a change in content or properties  like permissions, Docker considers these modifications as triggers to  invalidate the cache.
  对复制到图像中的文件进行的任何更改， `COPY` 以及 or `ADD` 说明。Docker 会密切关注项目目录中文件的任何更改。无论是内容更改还是权限等属性的更改，Docker 都会将这些修改视为使缓存失效的触发器。
- Once one layer is invalidated, all following layers are also invalidated. If any previous layer, including the base image or intermediary layers,  has been invalidated due to changes, Docker ensures that subsequent  layers relying on it are also invalidated. This keeps the build process  synchronized and prevents inconsistencies.
  一旦一个图层失效，所有后续图层也将失效。如果任何先前的层（包括基础镜像或中间层）由于更改而失效，Docker 将确保依赖于它的后续层也失效。这样可以使构建过程保持同步，并防止不一致。

When you're writing or editing a Dockerfile, keep an eye out for unnecessary cache misses to ensure that builds run as fast and efficiently as  possible.
在编写或编辑 Dockerfile 时，请留意不必要的缓存未命中，以确保生成尽可能快速有效地运行。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/#try-it-out)

In this hands-on guide, you will learn how to use the Docker build cache effectively for a Node.js application.
在本实践指南中，您将学习如何有效地将 Docker 构建缓存用于 Node.js 应用程序。

### [Build the application 构建应用程序](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/#build-the-application)

1. [Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

Open a terminal and [clone this sample application](https://github.com/dockersamples/todo-list-app)

.
打开一个终端并克隆此示例应用程序。

```console
 git clone https://github.com/dockersamples/todo-list-app
```

Navigate into the `todo-list-app` directory:
导航到 `todo-list-app` 目录：



```console
 cd todo-list-app
```

Inside this directory, you'll find a file named `Dockerfile` with the following content:
在此目录中，您将找到一个名为以下内容的文件 `Dockerfile` ：

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
EXPOSE 3000
CMD ["node", "./src/index.js"]
```

Execute the following command to build the Docker image:
执行以下命令以构建Docker镜像：

```console
 docker build .
```

Here’s the result of the build process:
以下是生成过程的结果：



```console
[+] Building 20.0s (10/10) FINISHED
```

The first line indicates that the entire build process took *20.0 seconds*. The first build may take some time as it installs dependencies.
第一行表示整个生成过程花费了 20.0 秒。第一次构建可能需要一些时间，因为它会安装依赖项。

Rebuild without making changes.
在不进行更改的情况下进行重建。

Now, re-run the `docker build` command without making any change in the source code or Dockerfile as shown:
现在，重新运行该 `docker build` 命令，而不对源代码或 Dockerfile 进行任何更改，如下所示：

```console
 docker build .
```

Subsequent builds after the initial are faster due to the caching mechanism, as  long as the commands and context remain unchanged. Docker caches the  intermediate layers generated during the build process. When you rebuild the image without making any changes to the Dockerfile or the source  code, Docker can reuse the cached layers, significantly speeding up the  build process.
由于缓存机制，只要命令和上下文保持不变，初始之后的后续构建会更快。Docker 会缓存在构建过程中生成的中间层。当您在不对 Dockerfile 或源代码进行任何更改的情况下重新生成映像时，Docker 可以重用缓存的层，从而显著加快构建过程。

```console
[+] Building 1.0s (9/9) FINISHED                                                                            docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                        0.0s
 => => transferring dockerfile: 187B                                                                                        0.0s
 ...
 => [internal] load build context                                                                                           0.0s
 => => transferring context: 8.16kB                                                                                         0.0s
 => CACHED [2/4] WORKDIR /app                                                                                               0.0s
 => CACHED [3/4] COPY . .                                                                                                   0.0s
 => CACHED [4/4] RUN yarn install --production                                                                              0.0s
 => exporting to image                                                                                                      0.0s
 => => exporting layers                                                                                                     0.0s
 => => exporting manifest
```

The subsequent build was completed in just 1.0 second by leveraging the  cached layers. No need to repeat time-consuming steps like installing  dependencies.
通过利用缓存层，随后的构建仅需 1.0 秒即可完成。无需重复耗时的步骤，例如安装依赖项。

| Steps 步骤 | Description 描述                                             | Time Taken(1st Run) 所用时间（第 1 次运行） | Time Taken (2nd Run) 所用时间（第 2 次运行） |
| ---------- | ------------------------------------------------------------ | ------------------------------------------- | -------------------------------------------- |
| 1          | Load build definition from Dockerfile 从 Dockerfile 加载构建定义 | 0.0 seconds 0.0 秒                          | 0.0 seconds 0.0 秒                           |
| 2          | Load metadata for docker.io/library/node:20-alpine 加载 docker.io/library/node:20-alpine 的元数据 | 2.7 seconds 2.7 秒                          | 0.9 seconds 0.9 秒                           |
| 3          | Load .dockerignore 加载 .dockerignore                        | 0.0 seconds 0.0 秒                          | 0.0 seconds 0.0 秒                           |
| 4          | Load build context 加载生成上下文(Context size: 4.60MB) （上下文大小：4.60MB） | 0.1 seconds 0.1 秒                          | 0.0 seconds 0.0 秒                           |
| 5          | Set the working directory (WORKDIR) 设置工作目录（WORKDIR）  | 0.1 seconds 0.1 秒                          | 0.0 seconds 0.0 秒                           |
| 6          | Copy the local code into the container 将本地代码复制到容器中 | 0.0 seconds 0.0 秒                          | 0.0 seconds 0.0 秒                           |
| 7          | Run yarn install --production 运行 yarn install --production | 10.0 seconds 10.0 秒                        | 0.0 seconds 0.0 秒                           |
| 8          | Exporting layers 导出图层                                    | 2.2 seconds 2.2 秒                          | 0.0 seconds 0.0 秒                           |
| 9          | Exporting the final image 导出最终图像                       | 3.0 seconds 3.0 秒                          | 0.0 seconds 0.0 秒                           |

Going back to the `docker image history` output, you see that each command in the Dockerfile becomes a new layer in the image. You might remember that when you made a change to the  image, the `yarn` dependencies had to be reinstalled. Is there a way to fix this? It  doesn't make much sense to reinstall the same dependencies every time  you build, right?
回到输出， `docker image history` 您会看到 Dockerfile 中的每个命令都成为映像中的新层。您可能还记得，当您对映像进行更改时，必须重新安装 `yarn` 依赖项。有没有办法解决这个问题？每次构建时重新安装相同的依赖项没有多大意义，对吧？

To fix this, restructure your Dockerfile so that the dependency cache  remains valid unless it really needs to be invalidated. For Node-based  applications, dependencies are defined in the `package.json` file. You'll want to reinstall the dependencies if that file changes,  but use cached dependencies if the file is unchanged. So, start by  copying only that file first, then install the dependencies, and finally copy everything else. Then, you only need to recreate the yarn  dependencies if there was a change to the `package.json` file.
要解决此问题，请重新构建 Dockerfile，以便依赖项缓存保持有效，除非它确实需要使其失效。对于基于 Node 的应用程序，依赖项在 `package.json` 文件中定义。如果该文件发生更改，则需要重新安装依赖项，但如果文件未更改，则使用缓存的依赖项。因此，首先仅复制该文件，然后安装依赖项，最后复制其他所有内容。然后，如果 `package.json` 文件发生更改，则只需重新创建 yarn 依赖项。

Update the Dockerfile to copy in the `package.json` file first, install dependencies, and then copy everything else in.
更新 Dockerfile 以首先复制该文件 `package.json` ，安装依赖项，然后复制其他所有内容。

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production 
COPY . . 
EXPOSE 3000
CMD ["node", "src/index.js"]
```

Create a file named `.dockerignore` in the same folder as the Dockerfile with the following contents.
在与 Dockerfile 相同的文件夹中创建一个名为的文件 `.dockerignore` ，其中包含以下内容。

```plaintext
node_modules
```

Build the new image:
构建新映像：

```console
 docker build .
```

You'll then see output similar to the following:
然后，你将看到类似于以下内容的输出：

```console
[+] Building 16.1s (10/10) FINISHED
=> [internal] load build definition from Dockerfile                                               0.0s
=> => transferring dockerfile: 175B                                                               0.0s
=> [internal] load .dockerignore                                                                  0.0s
=> => transferring context: 2B                                                                    0.0s
=> [internal] load metadata for docker.io/library/node:21-alpine                                  0.0s
=> [internal] load build context                                                                  0.8s
=> => transferring context: 53.37MB                                                               0.8s
=> [1/5] FROM docker.io/library/node:21-alpine                                                    0.0s
=> CACHED [2/5] WORKDIR /app                                                                      0.0s
=> [3/5] COPY package.json yarn.lock ./                                                           0.2s
=> [4/5] RUN yarn install --production                                                           14.0s
=> [5/5] COPY . .                                                                                 0.5s
=> exporting to image                                                                             0.6s
=> => exporting layers                                                                            0.6s
=> => writing image     
sha256:d6f819013566c54c50124ed94d5e66c452325327217f4f04399b45f94e37d25        0.0s
=> => naming to docker.io/library/node-app:2.0                                                 0.0s
```

You'll see that all layers were rebuilt. Perfectly fine since you changed the Dockerfile quite a bit.
您将看到所有图层都已重建。完全没问题，因为您对 Dockerfile 进行了相当多的更改。

Now, make a change to the `src/static/index.html` file (like change the title to say "The Awesome Todo App").
现在，对 `src/static/index.html` 文件进行更改（例如将标题更改为“The Awesome Todo App”）。

Build the Docker image. This time, your output should look a little different.
构建 Docker 镜像。这一次，您的输出应该看起来略有不同。

```console
 docker build -t node-app:3.0 .
```

You'll then see output similar to the following:
然后，你将看到类似于以下内容的输出：

1. ```console
   [+] Building 1.2s (10/10) FINISHED 
   => [internal] load build definition from Dockerfile                                               0.0s
   => => transferring dockerfile: 37B                                                                0.0s
   => [internal] load .dockerignore                                                                  0.0s
   => => transferring context: 2B                                                                    0.0s
   => [internal] load metadata for docker.io/library/node:21-alpine                                  0.0s 
   => [internal] load build context                                                                  0.2s
   => => transferring context: 450.43kB                                                              0.2s
   => [1/5] FROM docker.io/library/node:21-alpine                                                    0.0s
   => CACHED [2/5] WORKDIR /app                                                                      0.0s
   => CACHED [3/5] COPY package.json yarn.lock ./                                                    0.0s
   => CACHED [4/5] RUN yarn install --production                                                     0.0s
   => [5/5] COPY . .                                                                                 0.5s 
   => exporting to image                                                                             0.3s
   => => exporting layers                                                                            0.3s
   => => writing image     
   sha256:91790c87bcb096a83c2bd4eb512bc8b134c757cda0bdee4038187f98148e2eda       0.0s
   => => naming to docker.io/library/node-app:3.0                                                 0.0s
   ```

   First off, you should notice that the build was much faster. You'll see that  several steps are using previously cached layers. That's good news;  you're using the build cache. Pushing and pulling this image and updates to it will be much faster as well.
   首先，您应该注意到构建速度要快得多。您将看到有几个步骤正在使用以前缓存的图层。这是个好消息;您正在使用生成缓存。推送和拉取此映像及其更新也将快得多。

By following these optimization techniques, you can make your Docker  builds faster and more efficient, leading to quicker iteration cycles  and improved development productivity.
通过遵循这些优化技术，您可以使 Docker 构建更快、更高效，从而缩短迭代周期并提高开发效率。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/#additional-resources)

- [Optimizing builds with cache management
  使用缓存管理优化构建](https://docs.docker.com/build/cache/)
- [Cache Storage Backend 缓存存储后端](https://docs.docker.com/build/cache/backends/)
- [Build cache invalidation
  构建缓存失效](https://docs.docker.com/build/cache/invalidation/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/building-images/using-the-build-cache/#next-steps)

Now that you understand how to use the Docker build cache effectively, you're ready to learn about Multi-stage builds.
现在，您已经了解如何有效地使用 Docker 构建缓存，接下来可以了解多阶段构建了。

# Multi-stage builds 多阶段构建

<iframe id="youtube-player-vR185cjwxZ8" data-video-id="vR185cjwxZ8" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Multi-stage builds" width="100%" height="100%" src="https://www.youtube.com/embed/vR185cjwxZ8?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-15="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#explanation)

In a traditional build, all build instructions are executed in sequence,  and in a single build container: downloading dependencies, compiling  code, and packaging the application. All those layers end up in your  final image. This approach works, but it leads to bulky images carrying  unnecessary weight and increasing your security risks. This is where  multi-stage builds come in.
在传统构建中，所有构建指令都按顺序执行，并在单个构建容器中执行：下载依赖项、编译代码和打包应用程序。所有这些图层最终都会出现在您的最终图像中。这种方法是可行的，但它会导致体积庞大的图像带来不必要的重量，并增加您的安全风险。这就是多阶段构建的用武之地。

Multi-stage builds introduce multiple stages in your Dockerfile, each with a  specific purpose. Think of it like the ability to run different parts of a build in multiple different environments, concurrently. By separating the build environment from the final runtime environment, you can  significantly reduce the image size and attack surface. This is  especially beneficial for applications with large build dependencies.
多阶段构建会在 Dockerfile 中引入多个阶段，每个阶段都有特定的用途。可以把它想象成在多个不同的环境中同时运行构建的不同部分的能力。通过将构建环境与最终运行时环境分开，可以显著减小图像大小和攻击面。这对于具有大型构建依赖项的应用程序尤其有益。

Multi-stage builds are recommended for all types of applications.
对于所有类型的应用程序，建议使用多阶段构建。

- For interpreted languages, like JavaScript or Ruby or Python, you can build and minify your code in one stage, and copy the production-ready files  to a smaller runtime image. This optimizes your image for deployment.
  对于解释型语言（如 JavaScript、Ruby 或 Python），您可以在一个阶段构建和缩小代码，并将生产就绪的文件复制到较小的运行时映像中。这样可以优化映像的部署。
- For compiled languages, like C or Go or Rust, multi-stage builds let you  compile in one stage and copy the compiled binaries into a final runtime image. No need to bundle the entire compiler in your final image.
  对于编译语言，如 C 或 Go 或 Rust，多阶段构建允许您在一个阶段进行编译，并将编译的二进制文件复制到最终的运行时映像中。无需将整个编译器捆绑在最终映像中。

Here's a simplified example of a multi-stage build structure using pseudo-code. Notice there are multiple `FROM` statements and a new `AS <stage-name>`. In addition, the `COPY` statement in the second stage is copying `--from` the previous stage.
下面是使用伪代码的多阶段构建结构的简化示例。请注意，有多个 `FROM` 语句和一个新的 `AS <stage-name>` .此外，第二阶段 `COPY` 的语句正在复制 `--from` 上一阶段。

```dockerfile
# Stage 1: Build Environment
FROM builder-image AS build-stage 
# Install build tools (e.g., Maven, Gradle)
# Copy source code
# Build commands (e.g., compile, package)

# Stage 2: Runtime environment
FROM runtime-image AS final-stage  
#  Copy application artifacts from the build stage (e.g., JAR file)
COPY --from=build-stage /path/in/build/stage /path/to/place/in/final/stage
# Define runtime configuration (e.g., CMD, ENTRYPOINT) 
```

This Dockerfile uses two stages:
此 Dockerfile 使用两个阶段：

- The build stage uses a base image containing build tools needed to compile  your application. It includes commands to install build tools, copy  source code, and execute build commands.
  生成阶段使用一个基础映像，其中包含编译应用程序所需的生成工具。它包括用于安装生成工具、复制源代码和执行生成命令的命令。
- The final stage uses a smaller base image suitable for running your  application. It copies the compiled artifacts (a JAR file, for example)  from the build stage. Finally, it defines the runtime configuration  (using `CMD` or `ENTRYPOINT`) for starting your application.
  最后阶段使用适合运行应用程序的较小基础映像。它从构建阶段复制已编译的工件（例如，JAR 文件）。最后，它定义了用于启动应用程序的运行时配置（使用 `CMD` or `ENTRYPOINT` ）。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#try-it-out)

In this hands-on guide, you'll unlock the power of multi-stage builds to  create lean and efficient Docker images for a sample Java application.  You'll use a simple “Hello World” Spring Boot-based application built  with Maven as your example.
在本实践指南中，您将解锁多阶段构建的强大功能，为示例 Java 应用程序创建精简高效的 Docker 映像。您将使用一个简单的基于 “Hello World” Spring Boot 的应用程序作为示例，该应用程序是使用 Maven 构建的。

1. [Download and install](https://www.docker.com/products/docker-desktop/)

 Docker Desktop.
下载并安装 Docker Desktop。

Open this [pre-initialized project](https://start.spring.io/#!type=maven-project&language=java&platformVersion=3.3.0-M3&packaging=jar&jvmVersion=21&groupId=com.example&artifactId=spring-boot-docker&name=spring-boot-docker&description=Demo project for Spring Boot&packageName=com.example.spring-boot-docker&dependencies=web)

 to generate a ZIP file. Here’s how that looks:
打开这个预先初始化的项目以生成一个 ZIP 文件。这是它的样子：

![A screenshot of Spring Initializr tool selected with Java 21, Spring Web and Spring Boot 3.3.0](https://docs.docker.com/guides/docker-concepts/building-images/images/spring-initializr.webp)

[Spring Initializr](https://start.spring.io/)

 is a quickstart generator for Spring projects. It provides an  extensible API to generate JVM-based projects with implementations for  several common concepts — like basic language generation for Java,  Kotlin, and Groovy.
Spring Initializr 是 Spring 项目的快速启动生成器。它提供了一个可扩展的 API，用于生成基于 JVM 的项目，其中包含几个常见概念的实现，例如 Java、Kotlin 和 Groovy 的基本语言生成。

Select **Generate** to create and download the zip file for this project.
选择“生成”以创建并下载此项目的 zip 文件。

For this demonstration, you’ve paired Maven build automation with Java, a Spring Web dependency, and Java 21 for your metadata.
在本演示中，您已将 Maven 构建自动化与 Java（Spring Web 依赖项）和元数据的 Java 21 配对。

Navigate the project directory. Once you unzip the file, you'll see the following project directory structure:
在项目目录中导航。解压缩文件后，您将看到以下项目目录结构：

```plaintext
spring-boot-docker
├── Dockerfile
├── Dockerfile.multi
├── HELP.md
├── mvnw
├── mvnw.cmd
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── example
    │   │           └── springbootdocker
    │   │               └── SpringBootDockerApplication.java
    │   └── resources
    │       ├── application.properties
    │       ├── static
    │       └── templates
    └── test
        └── java
            └── com
                └── example
                    └── springbootdocker
                        └── SpringBootDockerApplicationTests.java

15 directories, 9 files
```

The `src/main/java` directory contains your project's source code, the `src/test/java` directory
该 `src/main/java` 目录包含项目的源代码，即 `src/test/java` 该目录
contains the test source, and the `pom.xml` file is your project’s Project Object Model (POM).
包含测试源，文件 `pom.xml` 是项目的项目对象模型 （POM）。

The `pom.xml` file is the core of a Maven project's configuration. It's a single configuration file that
该文件 `pom.xml` 是 Maven 项目配置的核心。这是一个单一的配置文件，
contains most of the information needed to build a customized project. The POM is huge and can seem
包含生成自定义项目所需的大部分信息。POM 很大，看起来
daunting. Thankfully, you don't yet need to understand every intricacy to use it effectively.
艰巨。值得庆幸的是，您还不需要了解每一个复杂性即可有效地使用它。

Create a RESTful web service that displays "Hello World!".
创建一个显示“Hello World！”的 RESTful Web 服务。

Under the `src/main/java/com/example/springbootdocker/` directory, you can modify your
在目录下 `src/main/java/com/example/springbootdocker/` ，您可以修改您的
`SpringBootDockerApplication.java` file with the following content:
 `SpringBootDockerApplication.java` 包含以下内容的文件：

1. ```java
   package com.example.springbootdocker;
   
   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.web.bind.annotation.RequestMapping;
   import org.springframework.web.bind.annotation.RestController;
   
   
   @RestController
   @SpringBootApplication
   public class SpringBootDockerApplication {
   
       @RequestMapping("/")
           public String home() {
           return "Hello World";
       }
   
   	public static void main(String[] args) {
   		SpringApplication.run(SpringBootDockerApplication.class, args);
   	}
   
   }
   ```

   The `SpringbootDockerApplication.java` file starts by declaring your `com.example.springbootdocker` package and importing necessary Spring frameworks. This Java file  creates a simple Spring Boot web application that responds with "Hello  World" when a user visits its homepage.
   该文件 `SpringbootDockerApplication.java` 首先声明您的 `com.example.springbootdocker` 包并导入必要的 Spring 框架。此 Java 文件创建了一个简单的 Spring Boot Web 应用程序，当用户访问其主页时，该应用程序会以“Hello World”进行响应。

### [Create the Dockerfile 创建 Dockerfile](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#create-the-dockerfile)

Now that you have the project, you’re ready to create the `Dockerfile`.
现在，您已经有了项目，可以创建 `Dockerfile` .

1. Create a file named `Dockerfile` in the same folder that contains all the other folders and files (like src, pom.xml, etc.).
   在包含所有其他文件夹和文件（如 src、pom.xml 等）的同一文件夹中创建一个命名 `Dockerfile` 的文件。
2. In the `Dockerfile`, define your base image by adding the following line:
   在 中， `Dockerfile` 通过添加以下行来定义基础映像：

```dockerfile
FROM eclipse-temurin:21.0.2_13-jdk-jammy
```

Now, define the working directory by using the `WORKDIR` instruction. This will specify where future commands will run and the  directory files will be copied inside the container image.
现在，使用指令 `WORKDIR` 定义工作目录。这将指定将来命令的运行位置，并将目录文件复制到容器映像中。

```dockerfile
WORKDIR /app
```

Copy both the Maven wrapper script and your project's `pom.xml` file into the current working directory `/app` within the Docker container.
将 `pom.xml` Maven 包装脚本和项目文件复制到 Docker 容器内的当前工作目录中 `/app` 。

```dockerfile
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
```

Execute a command within the container. It runs the `./mvnw dependency:go-offline` command, which uses the Maven wrapper (`./mvnw`) to download all dependencies for your project without building the final JAR file (useful for faster builds).
在容器内执行命令。它运行该 `./mvnw dependency:go-offline` 命令，该命令使用 Maven 包装器 （ `./mvnw` ） 下载项目的所有依赖项，而无需构建最终的 JAR 文件（对于更快的构建很有用）。



```dockerfile
RUN ./mvnw dependency:go-offline
```

Copy the `src` directory from your project on the host machine to the `/app` directory within the container.
将主机上的项目中的 `src` 目录复制到容器内的 `/app` 目录中。

```dockerfile
COPY src ./src
```

Set the default command to be executed when the container starts. This  command instructs the container to run the Maven wrapper (`./mvnw`) with the `spring-boot:run` goal, which will build and execute your Spring Boot application.
设置容器启动时要执行的默认命令。此命令指示容器运行 Maven 包装器 （ `./mvnw` ）， `spring-boot:run` 目标是构建并执行您的 Spring Boot 应用程序。

```dockerfile
CMD ["./mvnw", "spring-boot:run"]
```

And with that, you should have the following Dockerfile:
有了这个，你应该有以下的Dockerfile：

1. ```dockerfile
   FROM eclipse-temurin:21.0.2_13-jdk-jammy
   WORKDIR /app
   COPY .mvn/ .mvn
   COPY mvnw pom.xml ./
   RUN ./mvnw dependency:go-offline
   COPY src ./src
   CMD ["./mvnw", "spring-boot:run"]
   ```

### [Build the container image 构建容器镜像](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#build-the-container-image)

1. Execute the following command to build the Docker image:
   执行以下命令以构建Docker镜像：

   

```console
 docker build -t spring-helloworld .
```

Check the size of the Docker image by using the `docker images` command:
使用以下 `docker images` 命令检查 Docker 映像的大小：

```console
 docker images
```

Doing so will produce output like the following:
这样做将产生如下输出：

1. ```console
   REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
   spring-helloworld   latest    ff708d5ee194   3 minutes ago    880MB
   ```

   This output shows that your image is 880MB in size. It contains the full  JDK, Maven toolchain, and more. In production, you don’t need that in  your final image.
   此输出显示您的图像大小为 880MB。它包含完整的 JDK、Maven 工具链等。在生产环境中，最终映像中不需要它。

### [Run the Spring Boot application 运行 Spring Boot 应用程序](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#run-the-spring-boot-application)

1. Now that you have an image built, it's time to run the container.
   现在，您已经构建了一个映像，可以运行容器了。

```console
 docker run -d -p 8080:8080 spring-helloworld
```

You'll then see output similar to the following in the container log:
然后，你将在容器日志中看到类似于以下内容的输出：You'll then see output similar to the following in the container log：

```plaintext
[INFO] --- spring-boot:3.3.0-M3:run (default-cli) @ spring-boot-docker ---
[INFO] Attaching agents: []
 .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
 ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
 '  |____| .__|_| |_|_| |_\__, | / / / /
  =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::             (v3.3.0-M3)

 2024-04-04T15:36:47.202Z  INFO 42 --- [spring-boot-docker] [           main]       
 c.e.s.SpringBootDockerApplication        : Starting SpringBootDockerApplication using Java    
 21.0.2 with PID 42 (/app/target/classes started by root in /app)
 ….
```

Access your “Hello World” page through your web browser at http://localhost:8080

, or via this curl command:
通过 http://localhost:8080 的 Web 浏览器或以下 curl 命令访问您的“Hello World”页面：



1. ```console
    curl localhost:8080
   Hello World
   ```

### [Use multi-stage builds 使用多阶段构建](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#use-multi-stage-builds)

1. Consider the following Dockerfile:
   请考虑以下 Dockerfile：

```dockerfile
FROM eclipse-temurin:21.0.2_13-jdk-jammy AS builder
WORKDIR /opt/app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY ./src ./src
RUN ./mvnw clean install

FROM eclipse-temurin:21.0.2_13-jre-jammy AS final
WORKDIR /opt/app
EXPOSE 8080
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar
ENTRYPOINT ["java", "-jar", "/opt/app/*.jar"]
```

Notice that this Dockerfile has been split into two stages.
请注意，此 Dockerfile 已分为两个阶段。

- The first stage remains the same as the previous Dockerfile, providing a  Java Development Kit (JDK) environment for building the application.  This stage is given the name of builder.
  第一阶段与之前的 Dockerfile 相同，提供用于构建应用程序的 Java 开发套件 （JDK） 环境。此阶段被命名为 builder。
- The second stage is a new stage named `final`. It uses a slimmer `eclipse-temurin:21.0.2_13-jre-jammy` image, containing just the Java Runtime Environment (JRE) needed to run the application. This image provides a Java Runtime Environment (JRE)  which is enough for running the compiled application (JAR file).
  第二阶段是一个名为 `final` 的新阶段。它使用更 `eclipse-temurin:21.0.2_13-jre-jammy` 纤细的映像，仅包含运行应用程序所需的 Java 运行时环境 （JRE）。此映像提供了一个 Java 运行时环境 （JRE），该环境足以运行已编译的应用程序（JAR 文件）。

> For production use, it's highly recommended that you produce a custom  JRE-like runtime using jlink. JRE images are available for all versions  of Eclipse Temurin, but `jlink` allows you to create a minimal runtime containing only the necessary  Java modules for your application. This can significantly reduce the  size and improve the security of your final image. [Refer to this page](https://hub.docker.com/_/eclipse-temurin)

1. >  for more information.
   > 对于生产用途，强烈建议您使用 jlink 生成类似 JRE 的自定义运行时。JRE 镜像可用于 Eclipse Temurin 的所有版本，但 `jlink` 允许您创建仅包含应用程序所需的 Java 模块的最小运行时。这可以显著减小最终图像的大小并提高其安全性。有关详细信息，请参阅此页面。

With multi-stage builds, a Docker build uses one base image for compilation, packaging, and unit tests and then a separate image for the application runtime. As a result, the final image is smaller in size since it  doesn’t contain any development or debugging tools. By separating the  build environment from the final runtime environment, you can  significantly reduce the image size and increase the security of your  final images.
在多阶段构建中，Docker 构建使用一个基础镜像进行编译、打包和单元测试，然后使用一个单独的镜像用于应用程序运行时。因此，最终图像的尺寸较小，因为它不包含任何开发或调试工具。通过将构建环境与最终运行时环境分开，可以显著减小图像大小并提高最终图像的安全性。

1. Now, rebuild your image and run your ready-to-use production build.
   现在，重新生成映像并运行现成的生产生成版本。

```console
 docker build -t spring-helloworld-builder .
```

This command builds a Docker image named `spring-helloworld-builder` using the final stage from your `Dockerfile` file located in the current directory.
此命令从位于当前目录中的文件构建使用最后阶段 `Dockerfile` 命名 `spring-helloworld-builder` 的 Docker 映像。

> **Note 注意**
>
> In your multi-stage Dockerfile, the final stage (final) is the default  target for building. This means that if you don't explicitly specify a  target stage using the `--target` flag in the `docker build` command, Docker will automatically build the last stage by default. You could use `docker build -t spring-helloworld-builder --target builder .` to build only the builder stage with the JDK environment.
> 在多阶段 Dockerfile 中，最后阶段 （final） 是构建的默认目标。这意味着，如果您没有在 `docker build` 命令中使用标志 `--target` 明确指定目标阶段，Docker 将默认自动构建最后一个阶段。您只能用于 `docker build -t spring-helloworld-builder --target builder .` 在 JDK 环境中构建构建器阶段。

Look at the image size difference by using the `docker images` command:
使用以下 `docker images` 命令查看图像大小差异：



```console
 docker images
```

You'll get output similar to the following:
你将获得类似于以下内容的输出：

1. ```console
   spring-helloworld-builder latest    c5c76cb815c0   24 minutes ago      428MB
   spring-helloworld         latest    ff708d5ee194   About an hour ago   880MB
   ```

   Your final image is just 428 MB, compared to the original build size of 880 MB.
   最终图像仅为 428 MB，而原始构建大小为 880 MB。

   By optimizing each stage and only including what's necessary, you were able to significantly reduce the
   通过优化每个阶段并仅包含必要的内容，您可以显着减少
   overall image size while still achieving the same functionality. This not only improves performance but
   整体图像大小，同时仍实现相同的功能。这不仅提高了性能，而且
   also makes your Docker images more lightweight, more secure, and easier to manage.
   还使您的 Docker 镜像更轻量级、更安全且更易于管理。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/building-images/multi-stage-builds/#additional-resources)

- [Multi-stage builds 多阶段构建](https://docs.docker.com/build/building/multi-stage/)
- [Dockerfile best practices
  Dockerfile 最佳实践](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Base images 基础图像](https://docs.docker.com/build/building/base-images/)
- [Spring Boot Docker](https://spring.io/guides/topicals/spring-boot-docker)

## 运行容器

# Publishing and exposing ports 发布和公开端口

<iframe id="youtube-player-9JnqOmJ96ds" data-video-id="9JnqOmJ96ds" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker Concepts - Publishing ports" width="100%" height="100%" src="https://www.youtube.com/embed/9JnqOmJ96ds?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-17="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#explanation)

If you've been following the guides so far, you understand that containers provide isolated processes for each component of your application. Each component - a React frontend, a Python API, and a Postgres database -  runs in its own sandbox environment, completely isolated from everything else on your host machine. This isolation is great for security and  managing dependencies, but it also means you can’t access them directly. For example, you can’t access the web app in your browser.
如果您到目前为止一直遵循这些指南，那么您就会了解容器为应用程序的每个组件提供隔离的进程。每个组件 - 一个 React 前端、一个 Python API 和一个 Postgres 数据库 -  都在自己的沙盒环境中运行，与主机上的其他一切完全隔离。这种隔离对于安全性和管理依赖项非常有用，但这也意味着您无法直接访问它们。例如，您无法在浏览器中访问 Web 应用。

That’s where port publishing comes in.
这就是端口发布的用武之地。

### [Publishing ports 发布端口](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#publishing-ports)

Publishing a port provides the ability to break through a little bit of networking isolation by setting up a forwarding rule. As an example, you can  indicate that requests on your host’s port `8080` should be forwarded to the container’s port `80`. Publishing ports happens during container creation using the `-p` (or `--publish`) flag with `docker run`. The syntax is:
通过发布端口，可以通过设置转发规则来突破一点网络隔离。例如，您可以指示应将主机端口 `8080` 上的请求转发到容器的端口 `80` 。在容器创建过程中，使用 `-p` 带有 （or ） 标志的 `docker run` （或 `--publish` ） 进行发布端口。语法为：

```console
 docker run -d -p HOST_PORT:CONTAINER_PORT nginx
```

- `HOST_PORT`: The port number on your host machine where you want to receive traffic
   `HOST_PORT` ：主机上要接收流量的端口号
- `CONTAINER_PORT`: The port number within the container that's listening for connections
   `CONTAINER_PORT` ：容器内侦听连接的端口号

For example, to publish the container's port `80` to host port `8080`:
例如，要将容器的端口 `80` 发布到主机端口 `8080` ：

```console
 docker run -d -p 8080:80 nginx
```

Now, any traffic sent to port `8080` on your host machine will be forwarded to port `80` within the container.
现在，发送到主机上的端口 `8080` 的任何流量都将转发到容器内的端口 `80` 。

> **Important 重要**
>
> When a port is published, it's published to all network interfaces by  default. This means any traffic that reaches your machine can access the published application. Be mindful of publishing databases or any  sensitive information. [Learn more about published ports here](https://docs.docker.com/network/#published-ports)

> .
> 发布端口时，默认情况下会将其发布到所有网络接口。这意味着到达您的计算机的任何流量都可以访问已发布的应用程序。请注意发布数据库或任何敏感信息。在此处了解有关已发布端口的更多信息。

### [Publishing to ephemeral ports 发布到临时端口](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#publishing-to-ephemeral-ports)

At times, you may want to simply publish the port but don’t care which  host port is used. In these cases, you can let Docker pick the port for  you. To do so, simply omit the `HOST_PORT` configuration.
有时，您可能只想发布端口，但并不关心使用哪个主机端口。在这些情况下，您可以让 Docker 为您选择端口。为此，只需省略配置即可 `HOST_PORT` 。

For example, the following command will publish the container’s port `80` onto an ephemeral port on the host:
例如，以下命令会将容器的端口 `80` 发布到主机上的临时端口：



```console
 docker run -p 80 nginx
```

Once the container is running, using `docker ps` will show you the port that was chosen:
容器运行后，using `docker ps` 将显示所选的端口：

```console
docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
a527355c9c53   nginx         "/docker-entrypoint.…"   4 seconds ago    Up 3 seconds    0.0.0.0:54772->80/tcp    romantic_williamson
```

In this example, the app is exposed on the host at port `54772`.
在此示例中，应用程序在端口 `54772` 的主机上公开。

### [Publishing all ports 发布所有端口](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#publishing-all-ports)

When creating a container image, the `EXPOSE` instruction is used to indicate the packaged application will use the specified port. These ports aren't published by default.
创建容器镜像时，该 `EXPOSE` 指令用于指示打包的应用程序将使用指定的端口。默认情况下，不会发布这些端口。

With the `-P` or `--publish-all` flag, you can automatically publish all exposed ports to ephemeral  ports. This is quite useful when you’re trying to avoid port conflicts  in development or testing environments.
使用 `-P` or `--publish-all` 标志，您可以自动将所有公开的端口发布到临时端口。当您尝试避免开发或测试环境中的端口冲突时，这非常有用。

For example, the following command will publish all of the exposed ports configured by the image:
例如，以下命令将发布映像配置的所有公开端口：



```console
 docker run -P nginx
```

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#try-it-out)

In this hands-on guide, you'll learn how to publish container ports using  both the CLI and Docker Compose for deploying a web application.
在本实践指南中，您将学习如何使用 CLI 和 Docker Compose 发布容器端口以部署 Web 应用程序。

### [Use the Docker CLI 使用 Docker CLI](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#use-the-docker-cli)

In this step, you will run a container and publish its port using the Docker CLI.
在此步骤中，您将使用 Docker CLI 运行容器并发布其端口。

1. [Download and install](https://docs.docker.com/get-docker/) Docker Desktop.
   下载并安装 Docker Desktop。

2. In a terminal, run the following command to start a new container:
   在终端中，运行以下命令以启动新容器：

   

```console
 docker run -d -p 8080:80 docker/welcome-to-docker
```

The first `8080` refers to the host port. This is the port on your local machine that  will be used to access the application running inside the container. The second `80` refers to the container port. This is the port that the application  inside the container listens on for incoming connections. Hence, the  command binds to port `8080` of the host to port `80` on the container system.
第一个 `8080` 是指主机端口。这是本地计算机上的端口，将用于访问在容器内运行的应用程序。第二个 `80` 是指集装箱港口。这是容器内的应用程序侦听传入连接的端口。因此，该命令将主机的端口 `8080` 绑定到容器系统上的端口 `80` 。

Verify the published port by going to the **Containers** view of the Docker Dashboard.
通过转到 Docker 仪表板的 Containers 视图来验证已发布的端口。

![A screenshot of Docker dashboard showing the published port](https://docs.docker.com/guides/docker-concepts/running-containers/images/published-ports.webp)

Open the website by either selecting the link in the **Port(s)** column of your container or visiting http://localhost:8080

1.  in your browser.
   通过选择容器的“端口”列中的链接或在浏览器中访问 http://localhost:8080 来打开网站。

   ![A screenshot of the landing page of the Nginx web server running in a container](https://docs.docker.com/guides/docker-concepts/the-basics/images/access-the-frontend.webp?border=true)

### [Use Docker Compose 使用 Docker Compose](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#use-docker-compose)

This example will launch the same application using Docker Compose:
此示例将使用 Docker Compose 启动相同的应用程序：

1. Create a new directory and inside that directory, create a `compose.yaml` file with the following contents:
   创建一个新目录，并在该目录中创建一个包含以下内容 `compose.yaml` 的文件：

```yaml
services:
  app:
    image: docker/welcome-to-docker
    ports:
      - 8080:80
```

The `ports` configuration accepts a few different forms of syntax for the port definition. In this case, you’re using the same `HOST_PORT:CONTAINER_PORT` used in the `docker run` command.
该 `ports` 配置接受几种不同形式的端口定义语法。在本例中，您使用的是 `docker run` 命令中使用的相同 `HOST_PORT:CONTAINER_PORT` 内容。

Open a terminal and navigate to the directory you created in the previous step.
打开终端并导航到在上一步中创建的目录。

Use the `docker compose up` command to start the application.
使用命令 `docker compose up` 启动应用程序。

Open your browser to http://localhost:8080

1. .
   打开浏览器进行 http://localhost:8080。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#additional-resources)

If you’d like to dive in deeper on this topic, be sure to check out the following resources:
如果您想更深入地了解此主题，请务必查看以下资源：

- [`docker container port` CLI reference `docker container port` CLI 参考](https://docs.docker.com/reference/cli/docker/container/port/)
- [Published ports 已发布的端口](https://docs.docker.com/network/#published-ports)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/running-containers/publishing-ports/#next-steps)

Now that you understand how to publish and expose ports, you're ready to learn how to override the container defaults using the `docker run` command.
现在，您已了解如何发布和公开端口，接下来可以学习如何使用命令 `docker run` 覆盖容器默认值。

[Overriding container defaults
覆盖容器默认值](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/)

# Overriding container defaults 覆盖容器默认值

<iframe id="youtube-player-PFszWK3BB8I" data-video-id="PFszWK3BB8I" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker concepts - Overriding container defaults" width="100%" height="100%" src="https://www.youtube.com/embed/PFszWK3BB8I?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-15="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#explanation)

When a Docker container starts, it executes an application or command. The  container gets this executable (script or file) from its image’s  configuration. Containers come with default settings that usually work  well, but you can change them if needed. These adjustments help the  container's program run exactly how you want it to.
当 Docker 容器启动时，它会执行应用程序或命令。容器从其映像的配置中获取此可执行文件（脚本或文件）。容器附带的默认设置通常效果很好，但如果需要，您可以更改它们。这些调整有助于容器的程序完全按照您希望的方式运行。

For example, if you have an existing database container that listens on the standard port and you want to run a new instance of the same database  container, then you might want to change the port settings the new  container listens on so that it doesn’t conflict with the existing  container. Sometimes you might want to increase the memory available to  the container if the program needs more resources to handle a heavy  workload or set the environment variables to provide specific  configuration details the program needs to function properly.
例如，如果现有数据库容器侦听标准端口，并且想要运行同一数据库容器的新实例，则可能需要更改新容器侦听的端口设置，以便它不会与现有容器冲突。有时，如果程序需要更多资源来处理繁重的工作负载，或者设置环境变量以提供程序正常运行所需的特定配置详细信息，则可能需要增加容器的可用内存。

The `docker run` command offers a powerful way to override these defaults and tailor the container's behavior to your liking. The command offers several flags  that let you to customize container behavior on the fly.
该 `docker run` 命令提供了一种强大的方法来覆盖这些默认值，并根据您的喜好定制容器的行为。该命令提供了几个标志，使您可以动态自定义容器行为。

Here's a few ways you can achieve this.
您可以通过以下几种方法实现此目的。

### [Overriding the network ports 覆盖网络端口](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#overriding-the-network-ports)

Sometimes you might want to use separate database instances for development and  testing purposes. Running these database instances on the same port  might conflict. You can use the `-p` option in `docker run` to map container ports to host ports, allowing you to run the multiple instances of the container without any conflict.
有时，您可能希望使用单独的数据库实例进行开发和测试。在同一端口上运行这些数据库实例可能会发生冲突。您可以使用 in `docker run` 中的 `-p` 选项将容器端口映射到主机端口，从而允许您运行容器的多个实例而不会发生任何冲突。

```console
 docker run -d -p HOST_PORT:CONTAINER_PORT postgres
```

### [Setting environment variables 设置环境变量](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#setting-environment-variables)

This option sets an environment variable `foo` inside the container with the value `bar`.
此选项在容器内设置一个环境变量 `foo` ，其值 `bar` 为 。

```console
 docker run -e foo=bar postgres env
```

You will see output like the following:
您将看到如下所示的输出：

```console
HOSTNAME=2042f2e6ebe4
foo=bar
```

> **Tip 提示**
>
> The `.env` file acts as a convenient way to set environment variables for your  Docker containers without cluttering your command line with numerous `-e` flags. To use a `.env` file, you can pass `--env-file` option with the `docker run` command.
> 该文件 `.env` 是一种为 Docker 容器设置环境变量的便捷方式，而不会使命令行充满众多 `-e` 标志。要使用 `.env` 文件，您可以在 `docker run` 命令中传递 `--env-file` option。

> ```console
>  docker run --env-file .env postgres env
> ```

### [Restricting the container to consume the resources 限制容器消耗资源](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#restricting-the-container-to-consume-the-resources)

You can use the `--memory` and `--cpus` flags with the `docker run` command to restrict how much CPU and memory a container can use. For  example, you can set a memory limit for the Python API container,  preventing it from consuming excessive resources on your host. Here's  the command:
您可以将 `--memory` and `--cpus` 标志与 `docker run` 命令一起使用，以限制容器可以使用的 CPU 和内存量。例如，您可以为 Python API 容器设置内存限制，以防止其在主机上消耗过多资源。命令如下：



```console
 docker run -e POSTGRES_PASSWORD=secret --memory="512m" --cpus="0.5" postgres
```

This command limits container memory usage to 512 MB and defines the CPU quota of 0.5 for half a core.
此命令将容器内存使用量限制为 512 MB，并将半核的 CPU 配额定义为 0.5。

> **Monitor the real-time resource usage
> 监控实时资源使用情况**
>
> You can use the `docker stats` command to monitor the real-time resource usage of running containers.  This helps you understand whether the allocated resources are sufficient or need adjustment.
> 您可以使用该 `docker stats` 命令来监控正在运行的容器的实时资源使用情况。这有助于您了解分配的资源是否足够或是否需要调整。

By effectively using these `docker run` flags, you can tailor your containerized application's behavior to fit your specific requirements.
通过有效地使用这些 `docker run` 标志，您可以定制容器化应用程序的行为以满足您的特定要求。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#try-it-out)

In this hands-on guide, you'll see how to use the `docker run` command to override the container defaults.
在本实践指南中，你将了解如何使用命令 `docker run` 覆盖容器默认值。

1. [Download and install](https://docs.docker.com/get-docker/) Docker Desktop.
   下载并安装 Docker Desktop。

### [Run multiple instance of the Postgres database 运行 Postgres 数据库的多个实例](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#run-multiple-instance-of-the-postgres-database)

1. Start a container using the [Postgres image](https://hub.docker.com/_/postgres)

 with the following command:
使用以下命令使用 Postgres 镜像启动容器：



```console
 docker run -d -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres
```

This will start the Postgres database in the background, listening on the standard container port `5432` and mapped to port `5432` on the host machine.
这将在后台启动 Postgres 数据库，监听标准容器端口 `5432` 并映射到主机上的端口 `5432` 。

Start a second Postgres container mapped to a different port.
启动映射到不同端口的第二个 Postgres 容器。

1. ```console
    docker run -d -e POSTGRES_PASSWORD=secret -p 5433:5432 postgres
   ```

   This will start another Postgres container in the background, listening on the standard postgres port `5432` in the container, but mapped to port `5433` on the host machine. You override the host port just to ensure that  this new container doesn't conflict with the existing running container.
   这将在后台启动另一个 Postgres 容器，侦听容器中的标准 postgres 端口 `5432` ，但映射到主机上的端口 `5433` 。您可以重写主机端口，以确保此新容器不会与正在运行的现有容器冲突。

2. Verify that both containers are running by going to the **Containers** view in the Docker Dashboard.
   通过转到 Docker 仪表板中的 Containers 视图来验证两个容器是否正在运行。

   ![A screenshot of Docker Dashboard showing the running instances of Postgres containers](https://docs.docker.com/guides/docker-concepts/running-containers/images/running-postgres-containers.webp)

### [Run Postgres container in a controlled network 在受控网络中运行 Postgres 容器](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#run-postgres-container-in-a-controlled-network)

By default, containers automatically connect to a special network called a bridge network when you run them. This bridge network acts like a  virtual bridge, allowing containers on the same host to communicate with each other while keeping them isolated from the outside world and other hosts. It's a convenient starting point for most container  interactions. However, for specific scenarios, you might want more  control over the network configuration.
默认情况下，当您运行容器时，它们会自动连接到称为桥接网络的特殊网络。这种桥接网络的作用类似于虚拟桥接器，允许同一主机上的容器相互通信，同时使它们与外部世界和其他主机隔离。对于大多数容器交互来说，这是一个方便的起点。但是，对于特定方案，您可能希望对网络配置进行更多控制。

Here's where the custom network comes in. You create a custom network by passing `--network` flag with the `docker run` command. All containers without a `--network` flag are attached to the default bridge network.
这就是自定义网络的用武之地。您可以通过使用 `docker run` 命令传递 `--network` 标志来创建自定义网络。所有没有标志的 `--network` 容器都连接到默认的桥接网络。

Follow the steps to see how to connect a Postgres container to a custom network.
按照步骤操作，了解如何将 Postgres 容器连接到自定义网络。

1. Create a new custom network by using the following command:
   使用以下命令创建新的自定义网络：

```console
 docker network create mynetwork
```

Verify the network by running the following command:
通过运行以下命令验证网络：



```console
 docker network ls
```

This command lists all networks, including the newly created "mynetwork".
此命令列出所有网络，包括新创建的“mynetwork”。

Connect Postgres to the custom network by using the following command:
使用以下命令将 Postgres 连接到自定义网络：



1. ```console
    docker run -d -e POSTGRES_PASSWORD=secret -p 5434:5432 --network mynetwork postgres
   ```

   This will start Postgres container in the background, mapped to the host port 5434 and attached to the `mynetwork` network. You passed the `--network` parameter to override the container default by connecting the container to custom Docker network for better isolation and communication with  other containers. You can use `docker network inspect` command to see if the container is tied to this new bridge network.
   这将在后台启动 Postgres 容器，映射到主机端口 5434 并连接到 `mynetwork` 网络。您传递了参数 `--network` ，通过将容器连接到自定义 Docker 网络来覆盖容器默认值，以实现更好的隔离和与其他容器的通信。您可以使用 `docker network inspect` 命令来查看容器是否绑定到此新的桥接网络。

   > **Key difference between default bridge and custom networks
   > 默认网桥和自定义网桥之间的主要区别**
   >
   > 1. DNS resolution: By default, containers connected to the default bridge  network can communicate with each other, but only by IP address. (unless you use `--link` option which is considered legacy). It is not recommended for production use due to the various [technical shortcomings](https://docs.docker.com/network/drivers/bridge/#differences-between-user-defined-bridges-and-the-default-bridge). On a custom network, containers can resolve each other by name or alias.
   >    DNS解析：默认情况下，连接到默认桥接网络的容器可以相互通信，但只能通过IP地址进行通信。（除非您使用 `--link` 被视为旧版的选项）。由于存在各种技术缺陷，不建议在生产中使用。在自定义网络上，容器可以通过名称或别名相互解析。
   > 2. Isolation: All containers without a `--network` specified are attached to the default bridge network, hence can be a  risk, as unrelated containers are then able to communicate. Using a  custom network provides a scoped network in which only containers  attached to that network are able to communicate, hence providing better isolation.
   >    隔离：所有未 `--network` 指定的容器都连接到默认的桥接网络，因此可能会存在风险，因为不相关的容器随后能够进行通信。使用自定义网络可提供一个作用域网络，在该网络中，只有连接到该网络的容器才能进行通信，从而提供更好的隔离。

### [Manage the resources 管理资源](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#manage-the-resources)

By default, containers are not limited in their resource usage. However,  on shared systems, it's crucial to manage resources effectively. It's  important not to let a running container consume too much of the host  machine's memory.
默认情况下，容器的资源使用不受限制。但是，在共享系统上，有效管理资源至关重要。重要的是不要让正在运行的容器消耗过多的主机内存。

This is where the `docker run` command shines again. It offers flags like `--memory` and `--cpus` to restrict how much CPU and memory a container can use.
这是 `docker run` 命令再次闪耀的地方。它提供了诸如 and `--cpus` 之类的 `--memory` 标志来限制容器可以使用的 CPU 和内存量。

```console
 docker run -d -e POSTGRES_PASSWORD=secret --memory="512m" --cpus=".5" postgres
```

The `--cpus` flag specifies the CPU quota for the container. Here, it's set to half a CPU core (0.5) whereas the `--memory` flag specifies the memory limit for the container. In this case, it's set to 512 MB.
该 `--cpus` 标志指定容器的 CPU 配额。在这里，它设置为半个 CPU 核心 （0.5），而 `--memory` 标志指定容器的内存限制。在本例中，它设置为 512 MB。

### [Override the default CMD and ENTRYPOINT in Docker Compose 在 Docker Compose 中覆盖默认的 CMD 和 ENTRYPOINT](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#override-the-default-cmd-and-entrypoint-in-docker-compose)

Sometimes, you might need to override the default commands (`CMD`) or entry points (`ENTRYPOINT`) defined in a Docker image, especially when using Docker Compose.
有时，您可能需要覆盖 Docker 镜像中定义的默认命令 （ `CMD` ） 或入口点 （ `ENTRYPOINT` ），尤其是在使用 Docker Compose 时。

1. Create a `compose.yml` file with the following content:
   创建一个 `compose.yml` 包含以下内容的文件：

```yaml
services:
  postgres:
    image: postgres
    entrypoint: ["docker-entrypoint.sh", "postgres"]
    command: ["-h", "localhost", "-p", "5432"]
    environment:
      POSTGRES_PASSWORD: secret 
```

The Compose file defines a service named `postgres` that uses the official Postgres image, sets an entrypoint script, and starts the container with password authentication.
Compose 文件定义了一个名为的服务， `postgres` 该服务使用官方 Postgres 镜像，设置入口点脚本，并使用密码身份验证启动容器。

Bring up the service by running the following command:
通过运行以下命令来启动服务：

```console
 docker compose up -d
```

This command starts the Postgres service defined in the Docker Compose file.
此命令启动 Docker Compose 文件中定义的 Postgres 服务。

Verify the authentication with Docker Dashboard.
使用 Docker Dashboard 验证身份验证。

Open the Docker Dashboard, select the **Postgres** container and select **Exec** to enter into the container shell. You can type the following command to connect to the Postgres database:
打开 Docker Dashboard，选择 Postgres 容器，然后选择 Exec 以进入容器 shell。您可以键入以下命令以连接到 Postgres 数据库：



1. ```console
    psql -U postgres
   ```

   ![A screenshot of the Docker Dashboard selecting the Postgres container and entering into its shell using EXEC button](https://docs.docker.com/guides/docker-concepts/running-containers/images/exec-into-postgres-container.webp)

   > **Note 注意**
   >
   > The PostgreSQL image sets up trust authentication locally so you may notice a password isn't required when connecting from localhost (inside the  same container). However, a password will be required if connecting from a different host/container.
   > PostgreSQL 映像在本地设置信任身份验证，因此您可能会注意到从 localhost（在同一容器内）连接时不需要密码。但是，如果从不同的主机/容器进行连接，则需要密码。

### [Override the default CMD and ENTRYPOINT with `docker run` 使用以下命令 `docker run` 覆盖默认 CMD 和 ENTRYPOINT](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#override-the-default-cmd-and-entrypoint-with-docker-run)

You can also override defaults directly using the `docker run` command with the following command:
您也可以直接使用以下命令使用命令 `docker run` 覆盖默认值：



```console
 docker run -e POSTGRES_PASSWORD=secret postgres docker-entrypoint.sh -h localhost -p 5432
```

This command runs a Postgres container, sets an environment variable for  password authentication, overrides the default startup commands and  configures hostname and port mapping.
此命令运行 Postgres 容器，设置用于密码身份验证的环境变量，覆盖默认启动命令，并配置主机名和端口映射。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#additional-resources)

- [Ways to set environment variables with Compose
  使用 Compose 设置环境变量的方法](https://docs.docker.com/compose/environment-variables/set-environment-variables/)
- [What is a container
  什么是容器](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-a-container/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/running-containers/overriding-container-defaults/#next-steps)

Now that you have learned about overriding container defaults, it's time to learn how to persist container data.
现在，您已经了解了如何覆盖容器默认值，现在是时候学习如何保留容器数据了。

[Persisting container data
](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/)

# Persisting container data 持久化容器数据

<iframe id="youtube-player-10_2BjqB_Ls" data-video-id="10_2BjqB_Ls" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker Concepts - Persisting container data" width="100%" height="100%" src="https://www.youtube.com/embed/10_2BjqB_Ls?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-14="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#explanation)

When a container starts, it uses the files and configuration provided by the image. Each container is able to create, modify, and delete files and  does so without affecting any other containers. When the container is  deleted, these file changes are also deleted.
当容器启动时，它使用映像提供的文件和配置。每个容器都能够创建、修改和删除文件，并且不会影响任何其他容器。删除容器时，这些文件更改也会被删除。

While this ephemeral nature of containers is great, it poses a challenge when you want to persist the data. For example, if you restart a database  container, you might not want to start with an empty database. So, how  do you persist files?
虽然容器的这种短暂性很好，但当您想要持久保存数据时，它会带来挑战。例如，如果重新启动数据库容器，则可能不希望从空数据库开始。那么，如何持久化文件呢？

### [Container volumes 容器体积](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#container-volumes)

Volumes are a storage mechanism that provide the ability to persist data beyond the lifecycle of an individual container. Think of it like providing a  shortcut or symlink from inside the container to outside the container.
卷是一种存储机制，它提供了在单个容器的生命周期之外持久保存数据的能力。可以把它想象成提供从容器内部到容器外部的快捷方式或符号链接。

As an example, imagine you create a volume named `log-data`.
例如，假设您创建了一个名为 `log-data` 的卷。

```console
 docker volume create log-data
```

When starting a container with the following command, the volume will be mounted (or attached) into the container at `/logs`:
使用以下命令启动容器时，卷将在以下位置 `/logs` 挂载（或附加）到容器中：



```console
 docker run -d -p 80:80 -v log-data:/logs docker/welcome-to-docker
```

If the volume `log-data` doesn't exist, Docker will automatically create it for you.
如果卷 `log-data` 不存在，Docker 将自动为您创建它。

When the container runs, all files it writes into the `/logs` folder will be saved in this volume, outside of the container. If you  delete the container and start a new container using the same volume,  the files will still be there.
当容器运行时，它写入 `/logs` 文件夹的所有文件都将保存在此卷中，即容器外部。如果删除容器并使用同一卷启动新容器，则文件仍将存在。

> **Sharing files using volumes
> 使用卷共享文件**
>
> You can attach the same volume to multiple containers to share files  between containers. This might be helpful in scenarios such as log  aggregation, data pipelines, or other event-driven applications.
> 您可以将同一卷附加到多个容器，以便在容器之间共享文件。这在日志聚合、数据管道或其他事件驱动的应用程序等情况下可能很有帮助。

### [Managing volumes 管理卷](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#managing-volumes)

Volumes have their own lifecycle beyond that of containers and can grow quite  large depending on the type of data and applications you’re using. The  following commands will be helpful to manage volumes:
卷有自己的生命周期，超出了容器的生命周期，并且可能会根据您使用的数据类型和应用程序而变得非常大。以下命令将有助于管理卷：

- `docker volume ls` - list all volumes
   `docker volume ls` - 列出所有卷
- `docker volume rm <volume-name-or-id>` - remove a volume (only works when the volume is not attached to any containers)
   `docker volume rm <volume-name-or-id>` - 删除卷（仅当卷未附加到任何容器时才有效）
- `docker volume prune` - remove all unused (unattached) volumes
   `docker volume prune` - 删除所有未使用（未连接）的卷

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#try-it-out)

In this guide, you’ll practice creating and using volumes to persist data  created by a Postgres container. When the database runs, it stores files into the `/var/lib/postgresql/data` directory. By attaching the volume here, you will be able to restart the container multiple times while keeping the data.
在本指南中，您将练习创建和使用卷来持久保存由 Postgres 容器创建的数据。当数据库运行时，它会将文件存储到目录中 `/var/lib/postgresql/data` 。通过在此处附加卷，您将能够在保留数据的同时多次重新启动容器。

### [Use volumes 使用卷](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#use-volumes)

1. [Download and install](https://docs.docker.com/get-docker/) Docker Desktop.
   下载并安装 Docker Desktop。
2. Start a container using the [Postgres image](https://hub.docker.com/_/postgres)

 with the following command:
使用以下命令使用 Postgres 镜像启动容器：



```console
 docker run --name=db -e POSTGRES_PASSWORD=secret -d -v postgres_data:/var/lib/postgresql/data postgres
```

This will start the database in the background, configure it with a  password, and attach a volume to the directory PostgreSQL will persist  the database files.
这将在后台启动数据库，使用密码对其进行配置，并将卷附加到目录 PostgreSQL 将持久化数据库文件。

Connect to the database by using the following command:
使用以下命令连接到数据库：

```console
 docker exec -ti db psql -U postgres
```

In the PostgreSQL command line, run the following to create a database table and insert two records:
在 PostgreSQL 命令行中，运行以下命令以创建数据库表并插入两条记录：

```text
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    description VARCHAR(100)
);
INSERT INTO tasks (description) VALUES ('Finish work'), ('Have fun');
```

Verify the data is in the database by running the following in the PostgreSQL command line:
通过在 PostgreSQL 命令行中运行以下命令来验证数据是否在数据库中：

```text
SELECT * FROM tasks;
```

You should get output that looks like the following:
您应获得如下所示的输出：

```text
 id | description
----+-------------
  1 | Finish work
  2 | Have fun
(2 rows)
```

Exit out of the PostgreSQL shell by running the following command:
通过运行以下命令退出 PostgreSQL shell：



```console
\q
```

Stop and remove the database container. Remember that, even though the container has been deleted, the data is persisted in the `postgres_data` volume.
停止并删除数据库容器。请记住，即使容器已被删除，数据也会保留在卷中 `postgres_data` 。

```console
 docker stop db
 docker rm db
```

Start a new container by running the following command, attaching the same volume with the persisted data:
通过运行以下命令启动新容器，并使用持久化数据附加同一卷：

```console
 docker run --name=new-db -d -v postgres_data:/var/lib/postgresql/data postgres 
```

You might have noticed that the `POSTGRES_PASSWORD` environment variable has been omitted. That’s because that variable is only used when bootstrapping a new database.
您可能已经注意到， `POSTGRES_PASSWORD` 环境变量已被省略。这是因为该变量仅在引导新数据库时使用。

Verify the database still has the records by running the following command:
通过运行以下命令来验证数据库是否仍包含记录：

1. ```console
    docker exec -ti new-db psql -U postgres -c "SELECT * FROM tasks"
   ```

### [View volume contents 查看音量内容](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#view-volume-contents)

The Docker Dashboard provides the ability to view the contents of any  volume, as well as the ability to export, import, and clone volumes.
Docker Dashboard 提供了查看任何卷内容的功能，以及导出、导入和克隆卷的功能。

1. Open the Docker Dashboard and navigate to the **Volumes** view. In this view, you should see the **postgres_data** volume.
   打开 Docker Dashboard 并导航到 Volumes 视图。在此视图中，您应看到postgres_data卷。
2. Select the **postgres_data** volume’s name.
   选择postgres_data卷的名称。
3. The **Data** tab shows the contents of the volume and provides the ability to  navigate the files. Double-clicking on a file will let you see the  contents and make changes.
   “数据”选项卡显示卷的内容，并提供导航文件的功能。双击文件将让您查看内容并进行更改。
4. Right-click on any file to save it or delete it.
   右键单击任何文件以保存或删除它。

### [Remove volumes 删除卷](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#remove-volumes)

Before removing a volume, it must not be attached to any containers. If you  haven’t removed the previous container, do so with the following command (the `-f` will stop the container first and then remove it):
在删除卷之前，不得将其附加到任何容器。如果尚未删除上一个容器，请使用以下命令执行此操作（将 `-f` 首先停止容器，然后删除它）：



```console
 docker rm -f new-db
```

There are a few methods to remove volumes, including the following:
有几种方法可以删除卷，包括：

- Select the **Delete Volume** option on a volume in the Docker Dashboard.
  在 Docker 仪表板的卷上选择 * 删除卷 * 选项。
- Use the `docker volume rm` command:
  使用以下 `docker volume rm` 命令：

```console
 docker volume rm postgres_data
```

Use the `docker volume prune` command to remove all unused volumes:
使用以下 `docker volume prune` 命令删除所有未使用的卷：



- ```console
   docker volume prune
  ```

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#additional-resources)

The following resources will help you learn more about volumes:
以下资源将帮助您了解有关卷的更多信息：

- [Manage data in Docker
  在 Docker 中管理数据](https://docs.docker.com/storage)
- [Volumes 卷](https://docs.docker.com/storage/volumes)
- [Volume mounts (`docker run` reference)
  卷挂载 （ `docker run` reference）](https://docs.docker.com/engine/reference/run/#volume-mounts)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/#next-steps)

Now that you have learned about persisting container data, it’s time to learn about sharing local files with containers.
现在，您已经了解了如何持久保存容器数据，现在是时候了解如何与容器共享本地文件了。

[Sharing local files with containers
与容器共享本地文件](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/)



# Sharing local files with containers 与容器共享本地文件

<iframe id="youtube-player-2dAzsVg3Dek" data-video-id="2dAzsVg3Dek" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker Concepts: Sharing Container Files Locally" width="100%" height="100%" src="https://www.youtube.com/embed/2dAzsVg3Dek?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-14="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#explanation)

Each container has everything it needs to function with no reliance on any  pre-installed dependencies on the host machine. Since containers run in  isolation, they have minimal influence on the host and other containers. This isolation has a major benefit: containers minimize conflicts with  the host system and other containers. However, this isolation also means containers can't directly access data on the host machine by default.
每个容器都具有运行所需的一切，而不依赖于主机上任何预安装的依赖项。由于容器是独立运行的，因此它们对主机和其他容器的影响很小。这种隔离有一个主要的好处：容器可以最大程度地减少与主机系统和其他容器的冲突。但是，这种隔离也意味着容器默认情况下无法直接访问主机上的数据。

Consider a scenario where you have a web application container that requires  access to configuration settings stored in a file on your host system.  This file may contain sensitive data such as database credentials or API keys. Storing such sensitive information directly within the container  image poses security risks, especially during image sharing. To address  this challenge, Docker offers storage options that bridge the gap  between container isolation and your host machine's data.
请考虑这样一种情况：您有一个 Web 应用程序容器，该容器需要访问存储在主机系统上的文件中的配置设置。此文件可能包含敏感数据，例如数据库凭据或 API  密钥。将此类敏感信息直接存储在容器镜像中会带来安全风险，尤其是在镜像共享期间。为了应对这一挑战，Docker  提供了存储选项，这些选项弥合了容器隔离和主机数据之间的差距。

Docker offers two primary storage options for persisting data and sharing  files between the host machine and containers: volumes and bind mounts.
Docker 提供了两个主要存储选项，用于持久化数据和在主机和容器之间共享文件：卷和绑定挂载。

### [Volume versus bind mounts 卷挂载与绑定挂载](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#volume-versus-bind-mounts)

If you want to ensure that data generated or modified inside the container persists even after the container stops running, you would opt for a  volume. See [Persisting container data](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/) to learn more about volumes and their use cases.
如果要确保容器内生成或修改的数据即使在容器停止运行后仍然存在，则可以选择卷。请参阅持久化容器数据，了解有关卷及其用例的更多信息。

If you have specific files or directories on your host system that you  want to directly share with your container, like configuration files or  development code, then you would use a bind mount. It's like opening a  direct portal between your host and container for sharing. Bind mounts  are ideal for development environments where real-time file access and  sharing between the host and container are crucial.
如果您的主机系统上有想要直接与容器共享的特定文件或目录，例如配置文件或开发代码，则可以使用绑定挂载。这就像在主机和容器之间打开一个用于共享的直接门户。绑定挂载是开发环境的理想选择，在这些环境中，主机和容器之间的实时文件访问和共享至关重要。

### [Sharing files between a host and container 在主机和容器之间共享文件](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#sharing-files-between-a-host-and-container)

Both `-v` (or `--volume`) and `--mount` flags used with the `docker run` command let you share files or directories between your local machine  (host) and a Docker container. However, there are some key differences  in their behavior and usage.
 `-v` 与 `docker run` 命令一起使用的 （or `--volume` ） 和 `--mount` 标志都允许您在本地计算机（主机）和 Docker 容器之间共享文件或目录。但是，它们的行为和使用存在一些关键差异。

The `-v` flag is simpler and more convenient for basic volume or bind mount operations. If the host location doesn’t exist when using `-v` or `--volume`, a directory will be automatically created.
该 `-v` 标志更简单，更方便用于基本卷或绑定挂载操作。如果使用 `-v` or `--volume` 时主机位置不存在，将自动创建一个目录。

Imagine you're a developer working on a project. You have a source directory on your development machine where your code resides. When you compile or  build your code, the generated artifacts (compiled code, executables,  images, etc.) are saved in a separate subdirectory within your source  directory. In the following examples, this subdirectory is `/HOST/PATH`. Now you want these build artifacts to be accessible within a Docker  container running your application. Additionally, you want the container to automatically access the latest build artifacts whenever you rebuild your code.
想象一下，你是一名开发人员，正在做一个项目。您的开发计算机上有一个源目录，您的代码位于其中。编译或构建代码时，生成的工件（编译的代码、可执行文件、图像等）将保存在源目录中的单独子目录中。在以下示例中，此子目录为 `/HOST/PATH` 。现在，你希望可以在运行应用程序的 Docker 容器中访问这些生成项目。此外，你希望容器在重新生成代码时自动访问最新的生成项目。

Here's a way to use `docker run` to start a container using a bind mount and map it to the container file location.
下面是一种使用 `docker run` 绑定挂载启动容器并将其映射到容器文件位置的方法。



```console
 docker run -v /HOST/PATH:/CONTAINER/PATH -it nginx
```

The `--mount` flag offers more advanced features and granular control, making it  suitable for complex mount scenarios or production deployments. If you  use `--mount` to bind-mount a file or directory that doesn't yet exist on the Docker host, the `docker run` command doesn't automatically create it for you but generates an error.
该 `--mount` 标志提供更高级的功能和精细控制，使其适用于复杂的装载方案或生产部署。如果您用于 `--mount` 绑定挂载 Docker 主机上尚不存在的文件或目录，该 `docker run` 命令不会自动为您创建它，而是生成错误。



```console
 docker run --mount type=bind,source=/HOST/PATH,target=/CONTAINER/PATH,readonly nginx
```

> **Note 注意**
>
> Docker recommends using the `--mount` syntax instead of `-v`. It provides better control over the mounting process and avoids potential issues with missing directories.
> Docker 建议使用以下 `--mount` 语法而不是 `-v` .它可以更好地控制挂载过程，并避免丢失目录的潜在问题。

### [File permissions for Docker access to host files Docker 访问主机文件的文件权限](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#file-permissions-for-docker-access-to-host-files)

When using bind mounts, it's crucial to ensure that Docker has the necessary permissions to access the host directory. To grant read/write access,  you can use the `:ro` flag (read-only) or `:rw` (read-write) with the `-v` or `--mount` flag during container creation. For example, the following command grants read-write access permission.
使用绑定挂载时，确保 Docker 具有访问主机目录所需的权限至关重要。要授予读/写访问权限，可以在容器创建过程中将 `:ro` 标志（只读）或 `:rw` （读写）与 `-v` or `--mount` 标志一起使用。例如，以下命令授予读写访问权限。

```console
 docker run -v HOST-DIRECTORY:/CONTAINER-DIRECTORY:rw nginx
```

Read-only bind mounts let the container access the mounted files on the host for  reading, but it can't change or delete the files. With read-write bind  mounts, containers can modify or delete mounted files, and these changes or deletions will also be reflected on the host system. Read-only bind  mounts ensures that files on the host can't be accidentally modified or  deleted by a container.
只读绑定挂载允许容器访问主机上挂载的文件进行读取，但无法更改或删除文件。通过读写绑定挂载，容器可以修改或删除挂载的文件，这些更改或删除也会反映在主机系统上。只读绑定挂载可确保主机上的文件不会被容器意外修改或删除。

> **Synchronised File Share 同步文件共享**
>
> As your codebase grows larger, traditional methods of file sharing like  bind mounts may become inefficient or slow, especially in development  environments where frequent access to files is necessary. [Synchronized file shares](https://docs.docker.com/desktop/synchronized-file-sharing/) improve bind mount performance by leveraging synchronized filesystem  caches. This optimization ensures that file access between the host and  virtual machine (VM) is fast and efficient.
> 随着代码库的增长，传统的文件共享方法（如绑定挂载）可能会变得效率低下或速度缓慢，尤其是在需要频繁访问文件的开发环境中。同步文件共享通过利用同步文件系统缓存来提高绑定挂载性能。此优化可确保主机和虚拟机 （VM） 之间的文件访问快速高效。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#try-it-out)

In this hands-on guide, you’ll practice how to create and use a bind mount to share files between a host and a container.
在本实践指南中，您将练习如何创建和使用绑定挂载在主机和容器之间共享文件。

### [Run a container 运行容器](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#run-a-container)

1. [Download and install](https://docs.docker.com/get-docker/) Docker Desktop.
   下载并安装 Docker Desktop。
2. Start a container using the [httpd](https://hub.docker.com/_/httpd)

 image with the following command:
通过以下命令使用 httpd 镜像启动容器：

```console
 docker run -d -p 8080:80 --name my_site httpd:2.4
```

This will start the `httpd` service in the background, and publish the webpage to port `8080` on the host.
这将在后台启动服务 `httpd` ，并将网页发布到主机上的端口 `8080` 。

Open the browser and access http://localhost:8080

 or use the curl command to verify if it's working fine or not.
打开浏览器并访问 http://localhost:8080 或使用 curl 命令验证它是否运行正常。

1. ```console
    curl localhost:8080
   ```

### [Use a bind mount 使用绑定挂载](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#use-a-bind-mount)

Using a bind mount, you can map the configuration file on your host computer  to a specific location within the container. In this example, you’ll see how to change the look and feel of the webpage by using bind mount:
使用绑定挂载，可以将主机上的配置文件映射到容器中的特定位置。在此示例中，你将了解如何使用绑定挂载更改网页的外观：

1. Delete the existing container by using the Docker Dashboard:
   使用 Docker 仪表板删除现有容器：

   ![A screenshot of Docker dashboard showing how to delete the httpd container](https://docs.docker.com/guides/docker-concepts/running-containers/images/delete-httpd-container.webp)

2. Create a new directory called `public_html` on your host system.
   在主机系统上创建一个名为 `public_html` 的新目录。

```console
 mkdir public_html
```

Change the directory to `public_html` and create a file called `index.html` with the following content. This is a basic HTML document that creates a simple webpage that welcomes you with a friendly whale.
将目录更改为 `public_html` 并创建一个名为以下内容的文件 `index.html` 。这是一个基本的 HTML 文档，它创建了一个简单的网页，以友好的鲸鱼欢迎您。

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title> My Website with a Whale & Docker!</title>
</head>
<body>
<h1>Whalecome!!</h1>
<p>Look! There's a friendly whale greeting you!</p>
<pre id="docker-art">
   ##         .
  ## ## ##        ==
 ## ## ## ## ##    ===
 /"""""""""""""""""\___/ ===
{                       /  ===-
\______ O           __/
\    \         __/
 \____\_______/

Hello from Docker!
</pre>
</body>
</html>
```

It's time to run the container. The `--mount` and `-v` examples produce the same result. You can't run them both unless you remove the `my_site` container after running the first one.
是时候运行容器了。和 `--mount` `-v` 示例产生相同的结果。除非在运行第一个 `my_site` 容器后删除容器，否则无法同时运行它们。



------

```console
 docker run -d --name my_site -p 8080:80 -v .:/usr/local/apache2/htdocs/ httpd:2.4
```

------

> **Tip 提示**
> When using the `-v` or `--mount` flag in Windows PowerShell, you need to provide the absolute path to your directory instead of just `./`. This is because PowerShell handles relative paths differently from bash (commonly used in Mac and Linux environments).
> 在 Windows PowerShell 中使用 `-v` or `--mount` 标志时，您需要提供目录的绝对路径，而不仅仅是 `./` .这是因为 PowerShell 处理相对路径的方式与 bash（通常用于 Mac 和 Linux 环境）不同。

With everything now up and running, you should be able to access the site via http://localhost:8080

1.  and find a new webpage that welcomes you with a friendly whale.
   现在一切都启动并运行，您应该能够通过 http://localhost:8080 访问该网站，并找到一个以友好的鲸鱼欢迎您的新网页。

### [Access the file on the Docker Dashboard 在 Docker 仪表板上访问文件](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#access-the-file-on-the-docker-dashboard)

1. You can view the mounted files inside a container by selecting the container's **Files** tab and then selecting a file inside the `/usr/local/apache2/htdocs/` directory. Then, select **Open file editor**.
   您可以通过选择容器的“文件”选项卡，然后选择 `/usr/local/apache2/htdocs/` 目录中的文件来查看容器内的已装载文件。然后，选择“打开文件编辑器”。

   ![A screenshot of Docker dashboard showing the mounted files inside the a container](https://docs.docker.com/guides/docker-concepts/running-containers/images/mounted-files.webp)

2. Delete the file on the host and verify the file is also deleted in the  container. You will find that the files no longer exist under **Files** in the Docker Dashboard.
   删除主机上的文件，并验证文件是否也在容器中删除。您会发现 Docker 仪表板中的“文件”下的文件已不复存在。

   ![A screenshot of Docker dashboard showing the deleted files inside the a container](https://docs.docker.com/guides/docker-concepts/running-containers/images/deleted-files.webp)

3. Recreate the HTML file on the host system and see that file re-appears under the **Files** tab under **Containers** on the Docker Dashboard. By now, you will be able to access the site too.
   在主机系统上重新创建 HTML 文件，并查看该文件重新显示在 Docker 仪表板上容器下的“文件”选项卡下。到现在为止，您也可以访问该站点。

### [Stop your container 停止容器](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#stop-your-container)

The container continues to run until you stop it.
容器将继续运行，直到您停止它。

1. Go to the **Containers** view in the Docker Dashboard.
   转到 Docker Dashboard 中的 Containers 视图。
2. Locate the container you'd like to stop.
   找到您要停止的容器。
3. Select the **Delete** action in the Actions column.
   在“操作”列中选择“删除”操作。

![A screenshot of Docker dashboard showing how to delete the container](https://docs.docker.com/guides/docker-concepts/running-containers/images/delete-the-container.webp)

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#additional-resources)

The following resources will help you learn more about bind mounts:
以下资源将帮助您了解有关绑定挂载的更多信息：

- [Manage data in Docker
  在 Docker 中管理数据](https://docs.docker.com/storage/)
- [Volumes 卷](https://docs.docker.com/storage/volumes/)
- [Bind mounts 绑定挂载](https://docs.docker.com/storage/bind-mounts/)
- [Running containers 运行容器](https://docs.docker.com/reference/run/)
- [Troubleshoot storage errors
  存储错误疑难解答](https://docs.docker.com/storage/troubleshooting_volume_errors/)
- [Persisting container data
  持久化容器数据](https://docs.docker.com/guides/docker-concepts/running-containers/persisting-container-data/)

## [Next steps 后续步骤](https://docs.docker.com/guides/docker-concepts/running-containers/sharing-local-files/#next-steps)

Now that you have learned about sharing local files with containers, it’s time to learn about multi-container applications.
现在，您已经了解了如何与容器共享本地文件，现在是时候了解多容器应用程序了。

[Multi-container applications
多容器应用程序](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/)



# Multi-container applications 多容器应用程序

<iframe id="youtube-player-1jUwR6F9hvM" data-video-id="1jUwR6F9hvM" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker Concepts - Multi container applications" width="100%" height="100%" src="https://www.youtube.com/embed/1jUwR6F9hvM?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-25="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#explanation)

Starting up a single-container application is easy. For example, a Python script that performs a specific data processing task runs within a container  with all its dependencies. Similarly, a Node.js application serving a  static website with a small API endpoint can be effectively  containerized with all its necessary libraries and dependencies.  However, as applications grow in size, managing them as individual  containers becomes more difficult.
启动单容器应用程序非常简单。例如，执行特定数据处理任务的 Python 脚本在容器及其所有依赖项中运行。同样，为具有小型 API 端点的静态网站提供服务的 Node.js  应用程序可以有效地容器化其所有必要的库和依赖项。但是，随着应用程序大小的增长，将它们作为单个容器进行管理变得更加困难。

Imagine the data processing Python script needs to connect to a database.  Suddenly, you're now managing not just the script but also a database  server within the same container. If the script requires user logins,  you'll need an authentication mechanism, further bloating the container  size.
想象一下 Python 脚本需要连接到数据库的数据处理。突然之间，您现在不仅要管理脚本，还要管理同一容器中的数据库服务器。如果脚本需要用户登录，则需要身份验证机制，这会进一步增加容器大小。

One best practice for containers is that each container should do one thing and do it well. While there are exceptions to this rule, avoid the  tendency to have one container do multiple things.
容器的一个最佳实践是每个容器都应该做一件事，并且做得很好。虽然此规则也有例外，但请避免让一个容器执行多项操作的趋势。

Now you might ask, "Do I need to run these containers separately? If I run  them separately, how shall I connect them all together?"
现在你可能会问，“我需要单独运行这些容器吗？如果我单独运行它们，我该如何将它们连接在一起？

While `docker run` is a convenient tool for launching containers, it becomes difficult to manage a growing application stack with it. Here's why:
虽然 `docker run` 它是启动容器的便捷工具，但使用它管理不断增长的应用程序堆栈变得很困难。原因如下：

- Imagine running several `docker run` commands (frontend, backend, and database) with different  configurations for development, testing, and production environments.  It's error-prone and time-consuming.
  想象一下，使用不同的配置运行多个 `docker run` 命令（前端、后端和数据库），用于开发、测试和生产环境。它容易出错且耗时。
- Applications often rely on each other. Manually starting containers in a specific  order and managing network connections become difficult as the stack  expands.
  应用程序通常相互依赖。随着堆栈的扩展，按特定顺序手动启动容器和管理网络连接变得困难。
- Each application needs its `docker run` command, making it difficult to scale individual services. Scaling the  entire application means potentially wasting resources on components  that don't need a boost.
  每个应用程序都需要其 `docker run` 命令，因此很难扩展单个服务。扩展整个应用程序意味着可能会在不需要提升的组件上浪费资源。
- Persisting data for each application requires separate volume mounts or configurations within each `docker run` command. This creates a scattered data management approach.
  要持久保存每个应用程序的数据，需要在每个 `docker run` 命令中进行单独的卷挂载或配置。这创建了一种分散的数据管理方法。
- Setting environment variables for each application through separate `docker run` commands is tedious and error-prone.
  通过单独的 `docker run` 命令为每个应用程序设置环境变量既繁琐又容易出错。

That's where Docker Compose comes to the rescue.
这就是 Docker Compose 的用武之地。

Docker Compose defines your entire multi-container application in a single YAML file called `compose.yml`. This file specifies configurations for all your containers, their  dependencies, environment variables, and even volumes and networks. With Docker Compose:
Docker Compose 在一个名为 `compose.yml` 的 YAML 文件中定义了整个多容器应用程序。此文件指定了所有容器的配置、其依赖项、环境变量，甚至卷和网络。使用 Docker Compose：

- You don't need to run multiple `docker run` commands. All you need to do is define your entire multi-container  application in a single YAML file. This centralizes configuration and  simplifies management.
  您无需运行多个 `docker run` 命令。您需要做的就是在单个 YAML 文件中定义整个多容器应用程序。这样可以集中配置并简化管理。
- You can run containers in a specific order and manage network connections easily.
  您可以按特定顺序运行容器，并轻松管理网络连接。
- You can simply scale individual services up or down within the  multi-container setup. This allows for efficient allocation based on  real-time needs.
  您可以简单地在多容器设置中扩展或缩减单个服务。这允许根据实时需求进行有效的分配。
- You can implement persistent volumes with ease.
  您可以轻松实现持久性卷。
- It's easy to set environment variables once in your Docker Compose file.
  在 Docker Compose 文件中设置一次环境变量很容易。

By leveraging Docker Compose for running multi-container setups, you can  build complex applications with modularity, scalability, and consistency at their core.
通过利用 Docker Compose 运行多容器设置，您可以构建以模块化、可扩展性和一致性为核心的复杂应用程序。

## [Try it out 尝试一下](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#try-it-out)

In this hands-on guide, you'll first see how to build and run a counter  web application based on Node.js, an Nginx reverse proxy, and a Redis  database using the `docker run` commands. You’ll also see how you can simplify the entire deployment process using Docker Compose.
在本实践指南中，您将首先了解如何使用命令 `docker run` 构建和运行基于 Node.js、Nginx 反向代理和 Redis 数据库的计数器 Web 应用程序。您还将了解如何使用 Docker Compose 简化整个部署过程。

### [Set up 建立](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#set-up)

1. Get the sample application. If you have Git, you can clone the repository  for the sample application. Otherwise, you can download the sample  application. Choose one of the following options.
   获取示例应用程序。如果您有 Git，则可以克隆示例应用程序的存储库。否则，您可以下载示例应用程序。选择以下选项之一。

------

Use the following command in a terminal to clone the sample application repository.
在终端中使用以下命令克隆样本应用程序存储库。



```console
 git clone https://github.com/dockersamples/nginx-node-redis
```

Navigate into the `nginx-node-redis` directory:
导航到 `nginx-node-redis` 目录：

1. ```console
    cd nginx-node-redis
   ```

   Inside this directory, you'll find two sub-directories - `nginx` and `web`.
   在此目录中，您将找到两个子目录 - 和 `nginx` `web` .

   ------

2. [Download and install](https://docs.docker.com/get-docker/) Docker Desktop.
   下载并安装 Docker Desktop。

### [Build the images 构建映像](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#build-the-images)

1. Navigate into the `nginx` directory to build the image by running the following command:
   通过运行以下命令导航到 `nginx` 目录以生成映像：

   

```console
 docker build -t nginx .
```

Navigate into the `web` directory and run the following command to build the first web image:
导航到该 `web` 目录并运行以下命令以构建第一个 Web 映像：

1. ```console
    docker build -t web .
   ```

### [Run the containers 运行容器](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#run-the-containers)

1. Before you can run a multi-container application, you need to create a network for them all to communicate through. You can do so using the `docker network create` command:
   在运行多容器应用程序之前，您需要创建一个网络，以便它们通过它们进行通信。您可以使用以下 `docker network create` 命令执行此操作：

```console
 docker network create sample-app
```

Start the Redis container by running the following command, which will attach it to the previously created network and create a network alias (useful for DNS lookups):
通过运行以下命令启动 Redis 容器，该命令会将其附加到之前创建的网络并创建网络别名（用于 DNS 查找）：

```console
 docker run -d  --name redis --network sample-app --network-alias redis redis
```

Start the first web container by running the following command:
通过运行以下命令启动第一个 Web 容器：



```console
 docker run -d --name web1 -h web1 --network sample-app --network-alias web1 web
```

Start the second web container by running the following:
通过运行以下命令启动第二个 Web 容器：



```console
 docker run -d --name web2 -h web2 --network sample-app --network-alias web2 web
```

Start the Nginx container by running the following command:
通过运行以下命令启动 Nginx 容器：



```console
 docker run -d --name nginx --network sample-app  -p 80:80 nginx
```

> **Note 注意**
>
> Nginx is typically used as a reverse proxy for web applications, routing  traffic to backend servers. In this case, it routes to the Node.js  backend containers (web1 or web2).
> Nginx 通常用作 Web 应用程序的反向代理，将流量路由到后端服务器。在这种情况下，它会路由到Node.js后端容器（web1 或 web2）。

Verify the containers are up by running the following command:
通过运行以下命令来验证容器是否已启动：

```console
 docker ps
```

You will see output like the following:
您将看到如下所示的输出：

```text
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS                NAMES
2cf7c484c144   nginx     "/docker-entrypoint.…"   9 seconds ago        Up 8 seconds        0.0.0.0:80->80/tcp   nginx
7a070c9ffeaa   web       "docker-entrypoint.s…"   19 seconds ago       Up 18 seconds                            web2
6dc6d4e60aaf   web       "docker-entrypoint.s…"   34 seconds ago       Up 33 seconds                            web1
008e0ecf4f36   redis     "docker-entrypoint.s…"   About a minute ago   Up About a minute   6379/tcp             redis
```

If you look at the Docker Dashboard, you can see the containers and dive deeper into their configuration.
如果查看 Docker 仪表板，则可以看到容器并更深入地了解其配置。

![A screenshot of Docker Dashboard showing multi-container applications](https://docs.docker.com/guides/docker-concepts/running-containers/images/multi-container-apps.webp)

With everything up and running, you can open http://localhost

 in your browser to see the site. Refresh the page several times to see  the host that’s handling the request and the total number of requests:
一切启动并运行后，您可以在浏览器中打开 http://localhost 以查看该站点。多次刷新页面，以查看处理请求的主机和请求总数：

1. ```console
   web2: Number of visits is: 9
   web1: Number of visits is: 10
   web2: Number of visits is: 11
   web1: Number of visits is: 12
   ```

   > **Note 注意**
   >
   > You might have noticed that Nginx, acting as a reverse proxy, likely  distributes incoming requests in a round-robin fashion between the two  backend containers. This means each request might be directed to a  different container (web1 and web2) on a rotating basis. The output  shows consecutive increments for both the web1 and web2 containers and  the actual counter value stored in Redis is updated only after the  response is sent back to the client.
   > 您可能已经注意到，Nginx 充当反向代理，可能会在两个后端容器之间以循环方式分发传入的请求。这意味着每个请求可能会轮流定向到不同的容器（web1 和 web2）。输出显示 web1 和 web2 容器的连续增量，并且存储在 Redis 中的实际计数器值仅在响应发送回客户端后才会更新。

2. You can use the Docker Dashboard to remove the containers by selecting the containers and selecting the **Delete** button.
   您可以使用 Docker 仪表板来删除容器，方法是选择容器并选择“删除”按钮。

   ![A screenshot of Docker Dashboard showing how to delete the multi-container applications](https://docs.docker.com/guides/docker-concepts/running-containers/images/delete-multi-container-apps.webp)

## [Simplify the deployment using Docker Compose 使用 Docker Compose 简化部署](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#simplify-the-deployment-using-docker-compose)

Docker Compose provides a structured and streamlined approach for managing  multi-container deployments. As stated earlier, with Docker Compose, you don’t need to run multiple `docker run` commands. All you need to do is define your entire multi-container application in a single YAML file called `compose.yml`. Let’s see how it works.
Docker Compose 提供了一种结构化和简化的方法，用于管理多容器部署。如前所述，使用 Docker Compose，您无需运行多个 `docker run` 命令。您需要做的就是在一个名为 `compose.yml` YAML 的文件中定义整个多容器应用程序。让我们看看它是如何工作的。

Navigate to the root of the project directory. Inside this directory, you'll find a file named `compose.yml`. This YAML file is where all the magic happens. It defines all the  services that make up your application, along with their configurations. Each service specifies its image, ports, volumes, networks, and any  other settings necessary for its functionality.
导航到项目目录的根目录。在此目录中，您将找到一个名为 `compose.yml` .这个 YAML 文件是所有魔术发生的地方。它定义了构成应用程序的所有服务及其配置。每个服务都指定其映像、端口、卷、网络以及其功能所需的任何其他设置。

1. Use the `docker compose up` command to start the application:
   使用以下 `docker compose up` 命令启动应用程序：

```console
 docker compose up -d --build
```

When you run this command, you should see output similar to the following:
运行此命令时，应看到类似于以下内容的输出：

1. ```console
   Running 5/5
   ✔ Network nginx-nodejs-redis_default    Created                                                0.0s
   ✔ Container nginx-nodejs-redis-web1-1   Started                                                0.1s
   ✔ Container nginx-nodejs-redis-redis-1  Started                                                0.1s
   ✔ Container nginx-nodejs-redis-web2-1   Started                                                0.1s
   ✔ Container nginx-nodejs-redis-nginx-1  Started
   ```

2. If you look at the Docker Dashboard, you can see the containers and dive deeper into their configuration.
   如果查看 Docker 仪表板，则可以看到容器并更深入地了解其配置。

   ![A screenshot of Docker Dashboard showing the containers of the application stack deployed using Docker Compose](https://docs.docker.com/guides/docker-concepts/running-containers/images/list-containers.webp)

3. Alternatively, you can use the Docker Dashboard to remove the containers by selecting the application stack and selecting the **Delete** button.
   或者，您可以使用 Docker Dashboard 通过选择应用程序堆栈并选择 Delete 按钮来删除容器。

   ![A screenshot of Docker Dashboard that shows how to remove the containers that you deployed using Docker Compose](https://docs.docker.com/guides/docker-concepts/running-containers/images/delete-containers.webp)

In this guide, you learned how easy it is to use Docker Compose to start and stop a multi-container application compared to `docker run` which is error-prone and difficult to manage.
在本指南中，您了解了使用 Docker Compose 启动和停止多容器应用程序是多么容易，而 `docker run` 多容器应用程序容易出错且难以管理。

## [Additional resources 其他资源](https://docs.docker.com/guides/docker-concepts/running-containers/multi-container-applications/#additional-resources)

- [`docker container run` CLI reference `docker container run` CLI 参考](https://docs.docker.com/reference/cli/docker/container/run/)
- [What is Docker Compose
  什么是Docker Compose](https://docs.docker.com/guides/docker-concepts/the-basics/what-is-docker-compose/)







# Docker for system admins 面向系统管理员的 Docker

Containers are widely used across multiple server workloads (databases and web  servers, for instance), and understanding how to properly set up your  server to run them is becoming more important for systems  administrators. In this explanatory page, we are going to discuss some  of the most important factors a system administrator needs to consider  when setting up the environment to run Docker containers.
容器广泛用于多个服务器工作负载（例如数据库和 Web 服务器），对于系统管理员来说，了解如何正确设置服务器以运行它们变得越来越重要。在这个解释性页面中，我们将讨论系统管理员在设置环境以运行 Docker 容器时需要考虑的一些最重要的因素。

Understanding the options available to run Docker containers is key to optimising the use of computational resources in a given scenario/workload, which  might have specific requirements. Some aspects that are important for  system administrators are: **storage**, **networking** and **logging**. We are going to discuss each of these in the subsequent sections,  presenting how to configure them and interact with the Docker command  line interface (CLI).
了解可用于运行 Docker  容器的选项是在给定场景/工作负载中优化计算资源使用的关键，这可能具有特定要求。对系统管理员很重要的一些方面是：存储、网络和日志记录。我们将在随后的章节中逐一讨论，介绍如何配置它们并与 Docker 命令行界面 （CLI） 进行交互。

## Storage 存储

The first thing we need to keep in mind is that containers are ephemeral,  and, unless configured otherwise, so are their data. Docker images are  composed of one or more layers which are read-only, and once you run a  container based on an image a new writable layer is created on top of  the topmost image layer; the container can manage any type of data  there. The content changes in the writable container layer are not  persisted anywhere, and once the container is gone all the changes  disappear. This behavior presents some challenges to us: How can the  data be persisted? How can it be shared among containers? How can it be  shared between the host and the containers?
我们需要记住的第一件事是，容器是短暂的，除非另有配置，否则它们的数据也是短暂的。Docker  镜像由一个或多个只读层组成，一旦基于镜像运行容器，就会在最顶层镜像层之上创建一个新的可写层;容器可以在那里管理任何类型的数据。可写容器层中的内容更改不会保留在任何地方，一旦容器消失，所有更改都会消失。这种行为给我们带来了一些挑战：如何持久化数据？如何在容器之间共享？如何在主机和容器之间共享？

There are some important concepts in the Docker world that are the answer for some of those problems: they are **volumes**, **bind mounts** and **tmpfs**. Another question is how all those layers that form Docker images and  containers will be stored, and for that we are going to talk about **storage drivers** (more on that later).
Docker 世界中有一些重要概念可以解决其中一些问题：它们是卷、绑定挂载和 tmpfs。另一个问题是如何存储构成 Docker 映像和容器的所有层，为此，我们将讨论存储驱动程序（稍后会详细介绍）。

When we want to persist data we have two options:
当我们想要持久化数据时，我们有两个选择：

- Volumes are the preferred way to persist data generated and used by Docker  containers if your workload will generate a high volume of data, such as a database.
  如果工作负载将生成大量数据（如数据库），则卷是持久保存 Docker 容器生成和使用的数据的首选方式。
- Bind mounts are another option if you need to access files from the host, for example system files.
  如果需要从主机访问文件（例如系统文件），则绑定挂载是另一种选择。

If what you want is to store some sensitive data in memory, like  credentials, and do not want to persist it in either the host or the  container layer, we can use tmpfs mounts.
如果你想要在内存中存储一些敏感数据，比如凭据，并且不想将其保留在主机或容器层中，我们可以使用 tmpfs 挂载。

### Volumes 卷

The recommended way to persist data to and from Docker containers is by  using volumes. Docker itself manages them, they are not OS-dependent and they can provide some interesting features for system administrators:
将数据保存到 Docker 容器或从 Docker 容器保存数据的推荐方法是使用卷。Docker 本身管理它们，它们不依赖于操作系统，它们可以为系统管理员提供一些有趣的功能：

- Easier to back up and migrate when compared to bind mounts;
  与绑定挂载相比，更易于备份和迁移;
- Managed by the Docker CLI or API;
  由 Docker CLI 或 API 管理;
- Safely shared among containers;
  在容器之间安全共享;
- Volume drivers allow one to store data in remote hosts or in public cloud providers (also encrypting the data).
  卷驱动程序允许将数据存储在远程主机或公共云提供商中（也加密数据）。

Moreover, volumes are a better choice than persisting data in the container  layer, because volumes do not increase the size of the container, which  can affect the life-cycle management performance.
此外，卷是比在容器层中持久化数据更好的选择，因为卷不会增加容器的大小，这可能会影响生命周期管理性能。

Volumes can be created before or at the container creation time. There are two  CLI options you can use to mount a volume in the container during its  creation (`docker run` or `docker create`):
可以在容器创建之前或在容器创建时创建卷。有两个 CLI 选项可用于在容器创建期间在容器中挂载卷（ `docker run` 或 `docker create` ）：

- ```
  --mount
  ```

  : it accepts multiple key-value pairs (

  ```
  <key>=<value>
  ```

  ). This is the preferred option to use.

  
   `--mount` ：它接受多个键值对 （ `<key>=<value>` ）。这是首选选项。

  - `type`: for volumes it will always be `volume`;
     `type` ： 对于卷，它将永远是 `volume` ;
  - `source` or `src`: the name of the volume, if the volume is anonymous (no name) this can be omitted;
     `source` 或者 `src` ：卷的名称，如果卷是匿名的（无名称），则可以省略;
  - `destination`, `dst` or `target`: the path inside the container where the volume will be mounted;
     `destination` 或 `dst` `target` ：容器内将挂载卷的路径;
  - `readonly` or `ro` (optional): whether the volume should be mounted as read-only inside the container;
     `readonly` 或 `ro` （可选）：是否应将卷作为只读装载到容器内;
  - `volume-opt` (optional): a comma separated list of options in the format you would pass to the `mount` command.
     `volume-opt` （可选）：以逗号分隔的选项列表，其格式为要传递给命令的 `mount` 格式。

- ```
  -v
  ```

   or 

  ```
  --volume
  ```

  : it accepts 3 parameters separated by colon (

  ```
  :
  ```

  ):

  
   `-v` 或 `--volume` ： 它接受 3 个由冒号 （ 分隔的参数 `:` ）：

  - First, the name of the volume. For the default `local` driver, the name should use only: letters in upper and lower case, numbers, `.`, `_` and `-`;
    首先，卷的名称。对于默认 `local` 驱动程序，名称应仅使用：大写和小写字母、数字 `_` 和 `-` `.` ;
  - Second, the path inside the container where the volume will be mounted;
    第二，容器内将挂载卷的路径;
  - Third (optional), a comma-separated list of options in the format you would pass to the `mount` command, such as `rw`.
    第三个（可选）是逗号分隔的选项列表，其格式为要传递给 `mount` 命令的格式，例如 `rw` 。

Here are a few examples of how to manage a volume using the Docker CLI:
下面是如何使用 Docker CLI 管理卷的几个示例：

```auto
# create a volume
$ docker volume create my-vol
my-vol
# list volumes
$ docker volume ls
DRIVER	VOLUME NAME
local 	my-vol
# inspect volume
$ docker volume inspect my-vol
[
	{
    	"CreatedAt": "2023-10-25T00:53:24Z",
    	"Driver": "local",
    	"Labels": null,
    	"Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
    	"Name": "my-vol",
    	"Options": null,
    	"Scope": "local"
	}
]
# remove a volume
$ docker volume rm my-vol
my-vol
```

Running a container and mounting a volume:
运行容器并挂载卷：

```auto
$ docker run –name web-server -d \
    --mount source=my-vol,target=/app \
    ubuntu/apache2
0709c1b632801fddd767deddda0d273289ba423e9228cc1d77b2194989e0a882
```

After that, you can inspect your container to make sure the volume is mounted correctly:
之后，您可以检查容器以确保卷已正确装载：

```auto
$ docker inspect web-server --format '{{ json .Mounts }}' | jq .
[
  {
	"Type": "volume",
	"Name": "my-vol",
	"Source": "/var/lib/docker/volumes/my-vol/_data",
	"Destination": "/app",
	"Driver": "local",
	"Mode": "z",
	"RW": true,
	"Propagation": ""
  }
]
```

By default, all your volumes will be stored in `/var/lib/docker/volumes`.
默认情况下，所有卷都将存储在 `/var/lib/docker/volumes` .

### Bind mounts 绑定挂载

Bind mounts are another option for persisting data, however, they have some  limitations compared to volumes. Bind mounts are tightly associated with the directory structure and with the OS, but performance-wise they are  similar to volumes in Linux systems.
绑定挂载是持久保存数据的另一种选择，但是，与卷相比，它们有一些限制。绑定挂载与目录结构和操作系统紧密相关，但在性能方面，它们类似于 Linux 系统中的卷。

In a scenario where a container needs to have access to any host system’s  file or directory, bind mounts are probably the best solution. Some  monitoring tools make use of bind mounts when executed as Docker  containers.
在容器需要访问任何主机系统的文件或目录的情况下，绑定挂载可能是最佳解决方案。某些监视工具在作为 Docker 容器执行时会使用绑定挂载。

Bind mounts can be managed via the Docker CLI, and as with volumes there are two options you can use:
绑定挂载可以通过 Docker CLI 进行管理，与卷一样，可以使用两个选项：

- ```
  --mount
  ```

  : it accepts multiple key-value pairs (

  ```
  <key>=<value>
  ```

  ). This is the preferred option to use.

  
   `--mount` ：它接受多个键值对 （ `<key>=<value>` ）。这是首选选项。

  - `type`: for bind mounts it will always be `bind`;
     `type` ：对于绑定挂载，它将始终是 `bind` ;
  - `source` or `src`: path of the file or directory on the host;
     `source` 或 `src` ：主机上文件或目录的路径;
  - `destination`, `dst` or `target`: container’s directory to be mounted;
     `destination` ， `dst` 或者 `target` ：要挂载的容器目录;
  - `readonly` or `ro` (optional): the bind mount is mounted in the container as read-only;
     `readonly` 或 `ro` （可选）：绑定挂载以只读方式挂载到容器中;
  - `volume-opt` (optional): it accepts any `mount` command option;
     `volume-opt` （可选）：它接受任何 `mount` 命令选项;
  - `bind-propagation` (optional): it changes the bind propagation. It can be `rprivate`, `private`, `rshared`, `shared`, `rslave`, `slave`.
     `bind-propagation` （可选）：它更改绑定传播。它可以是 `rprivate` 、 `private` 、 、 `rshared` 、 `shared` `rslave` `slave` 。

- ```
  -v
  ```

   or 

  ```
  --volume
  ```

  : it accepts 3 parameters separated by colon (

  ```
  :
  ```

  ):

  
   `-v` 或 `--volume` ： 它接受 3 个由冒号 （ 分隔的参数 `:` ）：

  - First, path of the file or directory on the host;
    首先，文件或目录在主机上的路径;
  - Second, path of the container where the volume will be mounted;
    第二，将挂载卷的容器的路径;
  - Third (optional), a comma separated of option in the format you would pass to `mount` command, such as `rw`.
    第三个（可选），以要传递给 `mount` 命令的格式分隔选项的逗号，例如 `rw` 。

An example of how you can create a Docker container and bind mount a host directory:
如何创建 Docker 容器并绑定挂载主机目录的示例：

```auto
$ docker run -d \
    --name web-server \
    --mount type=bind,source="$(pwd)",target=/app \
    ubuntu/apache2
6f5378e34d6c6811702e16d047a5a80f18adbd9d8a14b11050ae3c3353bf8d2a
```

After that, you can inspect your container to check for the bind mount:
之后，您可以检查容器以检查绑定挂载：

```auto
$ docker inspect web-server --format '{{ json .Mounts }}' | jq .
[
  {
	"Type": "bind",
	"Source": "/root",
	"Destination": "/app",
	"Mode": "",
	"RW": true,
	"Propagation": "rprivate"
  }
]
```

### Tmpfs

Tmpfs mounts allow users to store data temporarily in RAM memory, not in the  host’s storage (via bind mount or volume) or in the container’s writable layer (with the help of storage drivers). When the container stops, the tmpfs mount will be removed and the data will not be persisted in any  storage.
Tmpfs 挂载允许用户将数据临时存储在 RAM 内存中，而不是存储在主机的存储中（通过绑定挂载或卷）或容器的可写层（借助存储驱动程序）。当容器停止时，tmpfs 挂载将被删除，数据不会保留在任何存储中。

This is ideal for accessing credentials or security-sensitive information.  The downside is that a tmpfs mount cannot be shared with multiple  containers.
这是访问凭据或安全敏感信息的理想选择。缺点是 tmpfs 挂载不能与多个容器共享。

Tmpfs mounts can be managed via the Docker CLI with the following two options:
Tmpfs 挂载可以通过 Docker CLI 使用以下两个选项进行管理：

- ```
  --mount
  ```

  : it accepts multiple key-value pairs (

  ```
  <key>=<value>
  ```

  ). This is the preferred option to use.

  
   `--mount` ：它接受多个键值对 （ `<key>=<value>` ）。这是首选选项。

  - `type`: for volumes it will always be `tmpfs`;
     `type` ： 对于卷，它将永远是 `tmpfs` ;
  - `destination`, `dst` or `target`: container’s directory to be mounted;
     `destination` ， `dst` 或者 `target` ：要挂载的容器目录;
  - `tmpfs-size` and `tmpfs-mode` options (optional). For a full list see the [Docker documentation](https://docs.docker.com/storage/tmpfs/#specify-tmpfs-options).
     `tmpfs-size` 和 `tmpfs-mode` 选项（可选）。有关完整列表，请参阅 Docker 文档。

- `--tmpfs`: it accepts no configurable options, just mount the tmpfs for a standalone container.
   `--tmpfs` ：它不接受任何可配置的选项，只需挂载独立容器的 TMPFS。

An example of how you can create a Docker container and mount a tmpfs:
如何创建 Docker 容器并挂载 tmpfs 的示例：

```auto
$ docker run --name web-server -d \
    --mount type=tmpfs,target=/app \
    ubuntu/apache2
03483cc28166fc5c56317e4ee71904941ec5942071e7c936524f74d732b6a24c
```

After that, you can inspect your container to check for the tmpfs mount:
之后，您可以检查容器以检查 tmpfs 挂载：

```auto
$ docker inspect web-server --format '{{ json .Mounts }}' | jq .
[
  {
    "Type": "tmpfs",
    "Source": "",
    "Destination": "/app",
    "Mode": "",
    "RW": true,
    "Propagation": ""
  }
]
```

### Storage drivers 存储驱动程序

Storage drivers are used to store image layers and to store data in the  writable layer of a container. In general, storage drivers are  implemented trying to optimise the use of space, but write speed might  be lower than native filesystem performance depending on the driver in  use. To better understand the options and make informed decisions, take a look at the Docker documentation on [how layers, images and containers work](https://docs.docker.com/storage/storagedriver/#images-and-layers).
存储驱动程序用于存储图像层，并将数据存储在容器的可写层中。通常，存储驱动程序的实现是为了优化空间的使用，但写入速度可能低于本机文件系统性能，具体取决于正在使用的驱动程序。为了更好地了解这些选项并做出明智的决策，请查看有关层、映像和容器如何工作的 Docker 文档。

The default storage driver is the `overlay2` which is backed by `OverlayFS`. This driver is recommended by upstream for use in production systems.  The following storage drivers are available and are supported in Ubuntu  (as at the time of writing):
默认存储驱动程序是 `overlay2` 支持的 `OverlayFS` 。上游建议将此驱动程序用于生产系统。Ubuntu 支持以下存储驱动程序（截至撰写本文时）：

- **OverlayFS**: it is a modern union filesystem. The Linux kernel driver is called `OverlayFS` and the Docker storage driver is called `overlay2`. **This is the recommended driver**.
  OverlayFS：它是一个现代的联合文件系统。调用 `OverlayFS` Linux 内核驱动程序，调用 Docker 存储驱动程序 `overlay2` 。这是推荐的驱动程序。
- **ZFS**: it is a next generation filesystem that supports many advanced storage  technologies such as volume management, snapshots, checksumming,  compression and deduplication, replication and more. The Docker storage  driver is called `zfs`.
  ZFS：它是下一代文件系统，支持许多高级存储技术，如卷管理、快照、校验和、压缩和重复数据删除、复制等。Docker 存储驱动程序称为 `zfs` 。
- **Btrfs**: it is a copy-on-write filesystem included in the Linux kernel mainline. The Docker storage driver is called `btrfs`.
  Btrfs：它是包含在 Linux 内核主线中的写入时复制文件系统。Docker 存储驱动程序称为 `btrfs` 。
- **Device Mapper**: it is a kernel-based framework that underpins many advanced volume  management technologies on Linux. The Docker storage driver is called `devicemapper`.
  Device Mapper：它是一个基于内核的框架，支持 Linux 上的许多高级卷管理技术。Docker 存储驱动程序称为 `devicemapper` 。
- **VFS**: it is not a union filesystem, instead, each layer is a directory on  disk, and there is no copy-on-write support. To create a new layer, a  “deep copy” is done of the previous layer. This driver does not perform  well compared to the others, however, it is robust, stable and works in  any environment. The Docker storage driver is called `vfs`.
  VFS：它不是一个联合文件系统，而是每一层都是磁盘上的一个目录，并且不支持写入时复制。要创建新图层，需要对前一层进行“深度复制”。与其他驱动程序相比，该驱动程序性能不佳，但是，它强大，稳定并且可以在任何环境中工作。Docker 存储驱动程序称为 `vfs` 。

If you want to use a different storage driver based on your specific requirements, you can add it to `/etc/docker/daemon.json` like in the following example:
如果要根据特定要求使用不同的存储驱动程序，可以将其添加到以下示例中 `/etc/docker/daemon.json` ：

```auto
{
  "storage-driver": "vfs"
}
```

The storage drivers accept some options via `storage-opts`, check [the storage driver documentation](https://docs.docker.com/storage/storagedriver/) for more information. Keep in mind that this is a JSON file and all lines should end with a comma (`,`) except the last one.
存储驱动程序通过 `storage-opts` 接受某些选项，有关详细信息，请查看存储驱动程序文档。请记住，这是一个 JSON 文件，除最后一行外，所有行都应以逗号 （ `,` ） 结尾。

Before changing the configuration above and restarting the daemon, make sure  that the specified filesystem (zfs, btrfs, device mapper) is mounted in `/var/lib/docker`. Otherwise, if you configure the Docker daemon to use a storage driver different from the filesystem backing `/var/lib/docker` a failure will happen. The Docker daemon expects that `/var/lib/docker` is correctly set up when it starts.
在更改上述配置并重新启动守护进程之前，请确保指定的文件系统（zfs、btrfs、设备映射器）挂载到 `/var/lib/docker` .否则，如果将 Docker 守护程序配置为使用与文件系统备份 `/var/lib/docker` 不同的存储驱动程序，则会发生故障。Docker 守护程序期望在启动时正确设置。 `/var/lib/docker` 

## Networking 联网

Networking in the context of containers refers to the ability of containers to  communicate with each other and with non-Docker workloads. The Docker  networking subsystem was implemented in a pluggable way, and we have  different network drivers available to be used in different scenarios:
容器上下文中的网络是指容器相互通信以及与非 Docker 工作负载通信的能力。Docker 网络子系统是以可插拔的方式实现的，我们有不同的网络驱动程序可用于不同的场景：

- **Bridge**: This is the default network driver. This is widely used when containers need to communicate among themselves in the same host.
  网桥：这是默认的网络驱动程序。当容器需要在同一主机中相互通信时，这被广泛使用。
- **Overlay**: It is used to make containers managed by different docker daemons (different hosts) communicate among themselves.
  Overlay：用于使由不同 docker 守护进程（不同主机）管理的容器相互通信。
- **Host**: It is used when the networking isolation between the container and the  host is not desired, the container will use the host’s networking  capabilities directly.
  主机：当不需要容器和主机之间的网络隔离时，容器会直接使用主机的网络功能。
- **IPvlan**: It is used to provide full control over the both IPv4 and IPv6 addressing.
  IPvlan：用于提供对 IPv4 和 IPv6 寻址的完全控制。
- **Macvlan**: It is used to allow the assignment of Mac addresses to containers, making them appear as a physical device in the network.
  Macvlan：它用于允许将 Mac 地址分配给容器，使它们在网络中显示为物理设备。
- **None**: It is used to make the container completely isolated from the host.
  无：用于使容器与主机完全隔离。

This is how you can create a user-defined network using the Docker CLI:
以下是使用 Docker CLI 创建用户定义网络的方法：

```auto
# create network
$ docker network create --driver bridge my-net
D84efaca11d6f643394de31ad8789391e3ddf29d46faecf0661849f5ead239f7
# list networks
$ docker network ls
NETWORK ID 	NAME  	DRIVER	SCOPE
1f55a8891c4a   bridge	bridge	local
9ca94be2c1a0   host  	host  	local
d84efaca11d6   my-net	bridge	local
5d300e6a07b1   none  	null  	local
# inspect the network we created
$ docker network inspect my-net
[
	{
    	"Name": "my-net",
    	"Id": "d84efaca11d6f643394de31ad8789391e3ddf29d46faecf0661849f5ead239f7",
    	"Created": "2023-10-25T22:18:52.972569338Z",
    	"Scope": "local",
    	"Driver": "bridge",
    	"EnableIPv6": false,
    	"IPAM": {
        	"Driver": "default",
        	"Options": {},
        	"Config": [
            	{
                	"Subnet": "172.18.0.0/16",
                	"Gateway": "172.18.0.1"
            	}
        	]
    	},
    	"Internal": false,
    	"Attachable": false,
    	"Ingress": false,
    	"ConfigFrom": {
        	"Network": ""
    	},
    	"ConfigOnly": false,
    	"Containers": {},
    	"Options": {},
    	"Labels": {}
	}
]
```

Containers can connect to a defined network when they are created (via `docker run`) or can be connected to it at any time of its lifecycle:
容器可以在创建时（通过 `docker run` ）连接到定义的网络，也可以在其生命周期的任何时间连接到该网络：

```auto
$ docker run -d --name c1 --network my-net ubuntu/apache2
C7aa78f45ce3474a276ca3e64023177d5984b3df921aadf97e221da8a29a891e
$ docker inspect c1 --format '{{ json .NetworkSettings }}' | jq .
{
  "Bridge": "",
  "SandboxID": "ee1cc10093fdfdf5d4a30c056cef47abbfa564e770272e1e5f681525fdd85555",
  "HairpinMode": false,
  "LinkLocalIPv6Address": "",
  "LinkLocalIPv6PrefixLen": 0,
  "Ports": {
	"80/tcp": null
  },
  "SandboxKey": "/var/run/docker/netns/ee1cc10093fd",
  "SecondaryIPAddresses": null,
  "SecondaryIPv6Addresses": null,
  "EndpointID": "",
  "Gateway": "",
  "GlobalIPv6Address": "",
  "GlobalIPv6PrefixLen": 0,
  "IPAddress": "",
  "IPPrefixLen": 0,
  "IPv6Gateway": "",
  "MacAddress": "",
  "Networks": {
	"my-net": {
  	"IPAMConfig": null,
  	"Links": null,
  	"Aliases": [
    	"c7aa78f45ce3"
  	],
  	"NetworkID": "d84efaca11d6f643394de31ad8789391e3ddf29d46faecf0661849f5ead239f7",
  	"EndpointID": "1cb76d44a484d302137bb4b042c8142db8e931e0c63f44175a1aa75ae8af9cb5",
  	"Gateway": "172.18.0.1",
  	"IPAddress": "172.18.0.2",
  	"IPPrefixLen": 16,
  	"IPv6Gateway": "",
  	"GlobalIPv6Address": "",
  	"GlobalIPv6PrefixLen": 0,
  	"MacAddress": "02:42:ac:12:00:02",
  	"DriverOpts": null
	}
  }
}
# make a running container connect to the network
$ docker run -d --name c2 ubuntu/nginx
Fea22fbb6e3685eae28815f3ad8c8a655340ebcd6a0c13f3aad0b45d71a20935
$ docker network connect my-net c2
$ docker inspect c2 --format '{{ json .NetworkSettings }}' | jq .
{
  "Bridge": "",
  "SandboxID": "82a7ea6efd679dffcc3e4392e0e5da61a8ccef33dd78eb5381c9792a4c01f366",
  "HairpinMode": false,
  "LinkLocalIPv6Address": "",
  "LinkLocalIPv6PrefixLen": 0,
  "Ports": {
	"80/tcp": null
  },
  "SandboxKey": "/var/run/docker/netns/82a7ea6efd67",
  "SecondaryIPAddresses": null,
  "SecondaryIPv6Addresses": null,
  "EndpointID": "490c15cf3bcb149dd8649e3ac96f71addd13f660b4ec826dc39e266184b3f65b",
  "Gateway": "172.17.0.1",
  "GlobalIPv6Address": "",
  "GlobalIPv6PrefixLen": 0,
  "IPAddress": "172.17.0.3",
  "IPPrefixLen": 16,
  "IPv6Gateway": "",
  "MacAddress": "02:42:ac:11:00:03",
  "Networks": {
	"bridge": {
  	"IPAMConfig": null,
  	"Links": null,
  	"Aliases": null,
  	"NetworkID": "1f55a8891c4a523a288aca8881dae0061f9586d5d91c69b3a74e1ef3ad1bfcf4",
  	"EndpointID": "490c15cf3bcb149dd8649e3ac96f71addd13f660b4ec826dc39e266184b3f65b",
  	"Gateway": "172.17.0.1",
  	"IPAddress": "172.17.0.3",
  	"IPPrefixLen": 16,
  	"IPv6Gateway": "",
  	"GlobalIPv6Address": "",
  	"GlobalIPv6PrefixLen": 0,
  	"MacAddress": "02:42:ac:11:00:03",
  	"DriverOpts": null
	},
	"my-net": {
  	"IPAMConfig": {},
  	"Links": null,
  	"Aliases": [
    	"fea22fbb6e36"
  	],
  	"NetworkID": "d84efaca11d6f643394de31ad8789391e3ddf29d46faecf0661849f5ead239f7",
  	"EndpointID": "17856b7f6902db39ff6ab418f127d75d8da597fdb8af0a6798f35a94be0cb805",
  	"Gateway": "172.18.0.1",
  	"IPAddress": "172.18.0.3",
  	"IPPrefixLen": 16,
  	"IPv6Gateway": "",
  	"GlobalIPv6Address": "",
  	"GlobalIPv6PrefixLen": 0,
  	"MacAddress": "02:42:ac:12:00:03",
  	"DriverOpts": {}
	}
  }
}
```

The default network created by the Docker daemon is called `bridge` using the bridge network driver. A system administrator can configure this network by editing `/etc/docker/daemon.json`:
Docker 守护程序创建的默认网络是使用桥接网络驱动程序调用 `bridge` 的。系统管理员可以通过编辑 `/etc/docker/daemon.json` 以下内容来配置此网络：

```auto
{
  "bip": "192.168.1.1/24",
  "fixed-cidr": "192.168.1.0/25",
  "fixed-cidr-v6": "2001:db8::/64",
  "mtu": 1500,
  "default-gateway": "192.168.1.254",
  "default-gateway-v6": "2001:db8:abcd::89",
  "dns": ["10.20.1.2","10.20.1.3"]
}
```

After deciding how you are going to manage the network and selecting the most appropriate driver, there are some specific deployment details that a  system administrator has to bear in mind when running containers.
在决定如何管理网络并选择最合适的驱动程序之后，系统管理员在运行容器时必须牢记一些特定的部署详细信息。

Exposing ports of any system is always a concern, since it increases the surface for malicious attacks. For containers, we also need to be careful,  analysing whether we really need to publish ports to the host. For  instance, if the goal is to allow containers to access a specific port  from another container, there is no need to publish any port to the  host. This can be solved by connecting all the containers to the same  network. You should publish ports of a container to the host only if you want to make it available to non-Docker workloads. When a container is  created no port is published to the host, the option `--publish` (or `-p`) should be passed to `docker run` or `docker create` listing which port will be exposed and how.
暴露任何系统的端口始终是一个问题，因为它增加了恶意攻击的表面。对于容器，我们还需要小心，分析我们是否真的需要将端口发布到主机。例如，如果目标是允许容器从另一个容器访问特定端口，则无需将任何端口发布到主机。这可以通过将所有容器连接到同一网络来解决。仅当希望容器可用于非 Docker 工作负载时，才应将容器的端口发布到主机。创建容器时，不会将端口发布到主机，应将选项 `--publish` （或 `-p` ）传递给 `docker run` 或 `docker create` 列出将公开的端口以及如何公开。

The `--publish` option of Docker CLI accepts the following options:
Docker CLI `--publish` 选项接受以下选项：

- First, the host port that will be used to publish the container’s port. It can also contain the IP address of the host. For example, `0.0.0.0:8080`.
  首先，将用于发布容器端口的主机端口。它还可以包含主机的 IP 地址。例如， `0.0.0.0:8080` .
- Second, the container’s port to be published. For example, `80`.
  第二，要发布的容器端口。例如， `80` .
- Third (optional), the type of port that will be published which can be TCP or UDP. For example, `80/tcp` or `80/udp`.
  第三（可选），将发布的端口类型，可以是 TCP 或 UDP。例如， `80/tcp` 或 `80/udp` .

An example of how to publish port `80` of a container to port `8080` of the host:
如何将容器的端口 `80` 发布到主机的端口 `8080` 的示例：

```auto
$ docker run -d --name web-server --publish 8080:80 ubuntu/nginx
f451aa1990db7d2c9b065c6158e2315997a56a764b36a846a19b1b96ce1f3910
$ docker inspect web-server --format '{{ json .NetworkSettings.Ports }}' | jq .
{
  "80/tcp": [
	{
  	"HostIp": "0.0.0.0",
  	"HostPort": "8080"
	},
	{
  	"HostIp": "::",
  	"HostPort": "8080"
	}
  ]
}
```

The `HostIp` values are `0.0.0.0` (IPv4) and `::` (IPv6), and the service running in the container is accessible to  everyone in the network (reaching the host), if you want to publish the  port from the container and let the service be available just to the  host you can use `--publish 127.0.0.1:8080:80` instead. The published port can be TCP or UDP and one can specify that passing `--publish 8080:80/tcp` or `--publish 8080:80/udp`.
 `HostIp` 值为 `0.0.0.0` （IPv4） 和 `::` （IPv6），如果要从容器发布端口并让服务仅供主机 `--publish 127.0.0.1:8080:80` 使用，则网络中的每个人都可以访问容器中运行的服务（到达主机）。发布的端口可以是 TCP 或 UDP，并且可以指定传递 `--publish 8080:80/tcp` 或 `--publish 8080:80/udp` .

The system administrator might also want to manually set the IP address or  the hostname of the container. To achieve this, one can use the `--ip` (IPv4), `--ip6` (IPv6), and `--hostname` options of the `docker network connect` command to specify the desired values.
系统管理员可能还需要手动设置容器的 IP 地址或主机名。为此，可以使用命令的 `--ip` （IPv4）、 `--ip6` （IPv6） 和 `--hostname` 选项来指定所需的 `docker network connect` 值。

Another important aspect of networking with containers is the DNS service. By  default containers will use the DNS setting of the host, defined in `/etc/resolv.conf`. Therefore, if a container is created and connected to the default `bridge` network it will get a copy of host’s `/etc/resolv.conf`. If the container is connected to a user-defined network, then it will  use Docker’s embedded DNS server. The embedded DNS server forwards  external DNS lookups to the DNS servers configured on the host. In case  the system administrator wants to configure the DNS service, the `docker run` and `docker create` commands have options to allow that, such as `--dns` (IP address of a DNS server) and `--dns-opt` (key-value pair representing a DNS option and its value). For more information, check the manpages of those commands.
与容器联网的另一个重要方面是 DNS 服务。默认情况下，容器将使用主机的 DNS 设置，该设置在 `/etc/resolv.conf` 中定义。因此，如果创建容器并连接到默认 `bridge` 网络，它将获得主机的副本 `/etc/resolv.conf` 。如果容器连接到用户定义的网络，则它将使用 Docker 的嵌入式 DNS 服务器。嵌入式 DNS 服务器将外部 DNS 查找转发到主机上配置的 DNS 服务器。如果系统管理员想要配置 DNS 服务， `docker run` 则 和 `docker create` 命令具有允许这样做的选项，例如 `--dns` （DNS 服务器的 IP 地址） 和 `--dns-opt` （表示 DNS 选项及其值的键值对）。有关详细信息，请查看这些命令的手册页。

## Logging 伐木

Monitoring what is happening in the system is a crucial part of systems  administration, and with Docker containers it is no different. Docker  provides the logging subsystem (which is pluggable) and there are many  drivers that can forward container logs to a file, an external host, a  database, or another logging back-end. The logs are basically everything written to `STDOUT` and `STDERR`. When building a Docker image, the relevant data should be forwarded to those I/O stream devices.
监控系统中发生的事情是系统管理的关键部分，Docker 容器也不例外。Docker 提供日志记录子系统（可插入），并且有许多驱动程序可以将容器日志转发到文件、外部主机、数据库或其他日志记录后端。日志基本上是写入 `STDOUT` 和 `STDERR` 的所有内容。构建 Docker 镜像时，应将相关数据转发到这些 I/O 流设备。

The following storage drivers are available (at the time of writing):
以下存储驱动程序可用（在撰写本文时）：

- **json-file**: it is the default logging driver. It writes logs in a file in JSON format.
  json-file：它是默认的日志记录驱动程序。它以 JSON 格式将日志写入文件中。
- **local**: write logs to an internal storage that is optimised for performance and disk use.
  本地：将日志写入针对性能和磁盘使用情况进行优化的内部存储。
- **journald**: send logs to systemd journal.
  journald：将日志发送到 systemd journal。
- **syslog**: send logs to a syslog server.
  syslog：将日志发送到 syslog 服务器。
- **logentries**: send container logs to the [Logentries](https://logentries.com/) server.
  logentries：将容器日志发送到 Logentries 服务器。
- **gelf**: write logs in a Graylog Extended Format which is understood by many tools, such as [Graylog](https://www.graylog.org/), [Logstash](https://www.elastic.co/products/logstash), and [Fluentd](https://www.fluentd.org).
  gelf：以 Graylog 扩展格式编写日志，该格式可被许多工具（如 Graylog、Logstash 和 Fluentd）理解。
- **awslogs**: send container logs to [Amazon CloudWatch Logs](https://aws.amazon.com/cloudwatch/details/#log-monitoring).
  awslogs：将容器日志发送到 Amazon CloudWatch Logs。
- **etwlogs**: forward container logs as ETW events. ETW stands for Event Tracing in  Windows, and is the common framework for tracing applications in  Windows. Not supported in Ubuntu systems.
  etwlogs：将容器日志作为 ETW 事件转发。ETW 代表 Windows 中的事件跟踪，是 Windows 中跟踪应用程序的通用框架。在 Ubuntu 系统中不受支持。
- **fluentd**: send container logs to the [Fluentd](https://www.fluentd.org) collector as structured log data.
  fluentd：将容器日志作为结构化日志数据发送到 Fluentd 收集器。
- **gcplogs**: send container logs to [Google Cloud Logging](https://cloud.google.com/logging/docs/) Logging.
  gcplogs：将容器日志发送到 Google Cloud Logging Logging。
- **splunk**: sends container logs to [HTTP Event Collector](https://dev.splunk.com/enterprise/docs/devtools/httpeventcollector/) in Splunk Enterprise and Splunk Cloud.
  splunk：将容器日志发送到 Splunk Enterprise 和 Splunk Cloud 中的 HTTP 事件收集器。

The default logging driver is `json-file`, and the system administrator can change it by editing the `/etc/docker/daemon.json`:
默认日志记录驱动程序是 `json-file` ，系统管理员可以通过编辑 来更改它 `/etc/docker/daemon.json` ：

```auto
{
  "log-driver": "journald"
}
```

Another option is specifying the logging driver during container creation time:
另一个选项是在容器创建期间指定日志记录驱动程序：

```auto
$ docker run -d --name web-server --log-driver=journald ubuntu/nginx
1c08b667f32d8b834f0d9d6320721e07de5f22168cfc8a024d6e388daf486dfa
$ docker inspect web-server --format '{{ json .HostConfig.LogConfig }}' | jq .
{
  "Type": "journald",
  "Config": {}
}
$ docker logs web-server
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
```

Depending on the driver you might also want to pass some options. You can do that via the CLI, passing `--log-opt` or in the daemon config file adding the key `log-opts`. For more information check the logging driver documentation.
根据驱动程序的不同，您可能还希望传递一些选项。您可以通过 CLI 执行此操作，传递 `--log-opt` 或在守护程序配置文件中添加密钥 `log-opts` 。有关详细信息，请查看日志记录驱动程序文档。

Docker CLI also provides the `docker logs` and `docker service logs` commands which allows one to check for the logs produced by a given  container or service (set of containers) in the host. However, those two commands are functional only if the logging driver for the containers  is `json-file`, `local` or `journald`. They are useful for debugging in general, but there is the downside of increasing the storage needed in the host.
Docker CLI 还提供 `docker logs` and `docker service logs` 命令，允许检查主机中给定容器或服务（容器集）生成的日志。但是，仅当容器的日志记录驱动程序为 `json-file` 或 `local` `journald` 时，这两个命令才有效。它们通常可用于调试，但缺点是增加主机所需的存储。

The remote logging drivers are useful to store data in an external  service/host, and they also avoid spending more disk space in the host  to store log files. Nonetheless, sometimes, for debugging purposes, it  is important to have log files locally. Considering that, Docker has a  feature called “dual logging”, which is enabled by default, and even if  the system administrator configures a logging driver different from `json-file`, `local` and `journald`, the logs will be available locally to be accessed via the Docker CLI.  If this is not the desired behavior, the feature can be disabled in the `/etc/docker/daemon.json` file:
远程日志记录驱动程序可用于将数据存储在外部服务/主机中，并且还可以避免在主机中花费更多磁盘空间来存储日志文件。尽管如此，有时，出于调试目的，在本地拥有日志文件非常重要。考虑到这一点，Docker 有一个称为“双日志记录”的功能，该功能默认启用，即使系统管理员配置了不同于 `json-file` 和 `local` `journald` 的日志记录驱动程序，日志也将在本地可用，可以通过 Docker CLI 访问。如果这不是所需的行为，则可以在 `/etc/docker/daemon.json` 文件中禁用该功能：

```auto
{
  "log-driver": "syslog",
  "log-opts": {
            “cache-disabled”: “true”,
	"syslog-address": "udp://1.2.3.4:1111"
  }
}
```

The option `cache-disabled` is used to disable the “dual logging” feature. If you try to run `docker logs` with that configuration you will get the following error:
该选项 `cache-disabled` 用于禁用“双日志记录”功能。如果尝试使用该配置运行 `docker logs` ，则会收到以下错误：

```auto
$ docker logs web-server
Error response from daemon: configured logging driver does not support reading
```



## 组成

### 镜像（Image）

只读模板，用于创建 Docker 容器，相当于是一个 root 文件系统。除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。不包含任何动态数据，其内容在构建后不会被改变。

#### 1.base 镜像

不依赖其他镜像，从 scratch 构建。其他镜像可以以之为基础进行扩展。通常都是各种 linux 发行版的镜像。

**镜像小的原因：**

1. Linux 操作系统是由内核空间和用户空间组成。内核空间是 kernel，Linux 刚启动时会加载 bootfs 文件系统，之后被卸载掉。用户空间的文件系统是 rootfs 。对镜像来说，底层直接用 host 的 kernel ，只需要提供 rootfs 。rootfs 可以被精简到很小。
2. base 镜像提供的是最小安装的 Linux 发行版。

**其他事项：**

1. base 镜像只是在用户空间与发行版一致，kernel版本与发行版是可以不同的。
2. 容器只能使用 host 的 kernel ，不能修改。

#### 2.虚悬镜像

特殊的镜像，这个镜像既没有仓库名，也没有标签，均为`<none>` 。这个镜像原本是有镜像名和标签的，随着官方镜像维护，发布了新版本后，重新 docker pull  时，镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了`<none>` 。除了 docker pull 可能导致这种情况， docker build 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 `<none>` 的镜像。这类无标签镜像也被称为虚悬镜像(dangling image) ，显示这类镜像：

```bash
docker image ls -f dangling=true
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的。

#### 3.中间层镜像
为了加速镜像构建、重复利用资源，Docker 会利用 中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像。默认的 docker image ls 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 -a 参数。

```bash
docker image ls -a
```

与虚悬镜像不同，这些无标签的镜像很多都是中间层镜像，是其它镜像所依赖的镜像。不应该删除，否则会导致上层镜像因为依赖丢失而出错。只要删除那些依赖它们的镜像后，这些依赖的中间层镜像也会被连带删除。

### 容器（Container）

是从镜像创建的运行实例，是独立运行的一个或一组应用。容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的命名空间。因此容器可以拥有自己的 root 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。这种特性使得容器封装的应用比直接在宿主运行更加安全。每一个容器运行时，是以镜像为基础层，在其上创建一个当前容器的存储层，称这个为容器运行时读写而准备的存储层为容器存储层。容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失。

按照 Docker 最佳实践的要求，容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。所有的文件写入操作，都应该使用 数据卷Volume）、或者绑定宿主目录，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。数据卷的生存周期独立于容器，容器消亡，数据卷不会消亡。因此，使用数据卷后，容器删除或者重新运行之后，数据却不会丢失。

### 仓库（Repository）

集中存放镜像文件的场所。

一个 Docker Registry 中可以包含多个仓库（ Repository ）；每个仓库可以包含多个标签（ Tag ）；每个标签对应一个镜像。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。可以通过 `<仓库名>:<标签>` 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 `latest` 作为默认标签。

仓库名经常以 两段式路径 形式出现，比如 jwilder/nginx-proxy ，前者往往意味着 Docker Registry 多用户环境下的用户名，后者则往往是对应的软件名。但这并非绝对，取决于所使用的具体 Docker Registry 的软件或服务。

#### 1.公开 Docker Registry
公开服务是开放给用户使用、允许用户管理镜像的 Registry 服务。
最常使用的 Registry 公开服务是官方的 Docker Hub，这也是默认的 Registry，并拥有大量的高质量的官方镜像。除此以外，还有 CoreOS 的 Quay.io，CoreOS 相关的镜像存储在这里；Google 的 Google Container Registry，Kubernetes 的镜像使用的就是这个服务。
国内的一些云服务商提供了针对 Docker Hub 的镜像服务（ Registry Mirror ），这些镜像服务被称为加速器。常见的有 阿里云加速器、DaoCloud 加速器 等。
国内也有一些云服务商提供类似于 Docker Hub 的公开服务。比如 时速云镜像仓库、网易云镜像服务、DaoCloud 镜像市场、阿里云镜像库 等。

#### 2.私有 Docker Registry
用户可以在本地搭建私有 Docker Registry。Docker 官方提供了Docker Registry 镜像，可以直接使用做为私有 Registry 服务。
开源的 Docker Registry 镜像只提供了 Docker Registry API 的服务端实现，足以支持docker 命令，不影响使用。但不包含图形界面，以及镜像维护、用户管理、访问控制等高级功能。在官方的商业化版本 Docker Trusted Registry 中，提供了这些高级功能。
除了官方的 Docker Registry 外，还有第三方软件实现了 Docker Registry API，甚至提供了用户界面以及一些高级功能。比如，VMWare Harbor 和 Sonatype Nexus。

### 客户端 (Client)

通过命令行或者其他工具使用 Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。

最常用的是 `docker` 命令。

```bash
# 连接远程docker主机执行命令
docker -H tcp://192.168.16.212:2376 <COMMAND>
```

### 主机 (Host)

一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。

### Docker daemon

运行在主机上，负责创建、运行、监控容器，构建、存储镜像。默认配置下，只能相应来自本地Host的客户端请求。如要允许远程客户端请求，需在配置文件中打开TCP监听。

```bash
# Server
vim /etc/systemd/system/multi-user.target.wants/docker.service
[Service]
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0

systemctl daemon-reload
systemctl restart docker.service

# Client
docker -H 192.168.1.100 info
# info 查看Docker服务器的信息。
```

### Docker Machine

是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker 。

 ![](../../../Image/a/ab.png)

docker服务端（服务进程，管理着所有的容器）  
docker客户端（远程控制器，控制docker的服务端进程）。

Remote API操作Docker的守护进程，意味着可以通过自己的程序来控制Docker的运行。
客户端和服务端既可以运行在一个机器上，也可通过socket 或者RESTful API 来进行通信

Docker的客户端与守护进程之间的通信，其连接方式为socket连接。主要有三种socket连接方式：

```http
unix:///var/run/docker.sock
tcp://host:port
fd://socketfd
```

## 安装

### Win10

64 位版本的Windows 10 Pro，且必须开启Hyper-V。

安装下载好的Docker for Windows Installer.exe

配置国内镜像加速，在系统右下角托盘Docker 图标内右键菜单选择Settings，打开配置窗口后左侧导航菜单选择Daemon，在Registry mirrors 一栏中填写加速器地址 https://registry.docker-cn.com ，之后点击Apply保存后Docker就会重启并应用配置的镜像地址。

### RHEL/CentOS
RHEL 7 64位 内核版本3.10以上

```shell
yum install docker
systemctl enable docker.service
systemctl start docker.service
```

### Ubuntu
```shell
sudo apt-get update
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo apt-get install docker.io
sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker

# 其他方法，脚本自动安装。
sudo apt install curl
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun

sudo systemctl start docker
sudo systemctl enable docker
```

当要以非root用户(xxxx)可以直接运行docker时，需要执行 `sudo usermod -aG docker xxxx `命令，然后重新登陆。

## 分层存储

镜像包含操作系统完整的 root 文件系统，其体积往往是庞大的，因此在Docker设计时，利用 Union FS 的技术，将其设计为分层存储的架构。镜像并非是像一个ISO 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。

镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。

分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像。

当容器启动时，一个新的可写层被加载到镜像的顶部，这一层通常被称为“容器层”，“容器层”之下都叫“镜像层”。

## Docker指令

### 容器生命周期管理

- run	创建一个新的容器并运行一个命令

  ```bash
  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
  
  -a stdin:                        指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
  -d:                              后台运行容器，并返回容器ID；
  -i,  –interactive=true | false:  以交互模式运行容器，通常与 -t 同时使用；默认为 false
  -P:                              随机端口映射，容器内部端口随机映射到主机的高端口
  -p:                              指定端口映射，格式为：主机(宿主)端口:容器端口 
  -t,  –tty=true | false:          为容器重新分配一个伪输入终端，通常与 -i 同时使用；默认为 false
  --name="xxxx":                   为容器指定一个名称；
  --dns 8.8.8.8:                   指定容器使用的DNS服务器，默认和宿主一致；
  --dns-search example.com:        指定容器DNS搜索域名，默认和宿主一致；
  -h "xxxx":                       指定容器的hostname；
  -e username="xxxxxxx":           设置环境变量；
  --env-file=[]:                   从指定文件读入环境变量；
  --cpuset="0-2"
  --cpuset="0,1,2":                绑定容器到指定CPU运行；
  -m :                             设置容器使用内存最大值；
  --net="bridge":                  指定容器的网络连接类型，支持 bridge/host/none/container；
  --link=[]:                       添加链接到另一个容器；
  --expose=[]:                     开放一个端口或一组端口； 
  --volume , -v:	                 绑定一个卷。host-dir:container-dir:[rw|ro]
  --rm                             容器退出后随之将其删除。
  --restart=always                 无论容器因何种原因（包括正常退出）而停止运行时，自动重启。
  --restart=on-failure:3           如果启动进程退出代码非0，则重启容器，最多重启3次。
  ```
  
- start/stop/restart	停止容器

  ```bash
   docker command id/name
   # stop	 向容器进程发送一个SIGTERM信号。
   # start 会保留容器的第一次启动时的所有参数。
  ```

- kill   停止容器（向容器进程发送SIGKILL信号）

- rm	移除容器，删除容器时，容器必须是停止状态，否则会报错。

  ```bash
  docker rm name
  # 清理掉所有处于终止状态的容器。
  docker container prune
  docker rm -v $(docker ps -aq -f status=exited)
  ```

- pause/unpause    暂停和取消暂停容器的运行。

- create     创建容器

###  容器操作

- ps

  ```bash
  docker ps [-a] [-l]
  -a all 列出所有容器
  -l latest 列出最近的容器
  
  # 输出：
  CONTAINER ID: 容器 ID。
  IMAGE:        使用的镜像。
  COMMAND:      启动容器时运行的命令。
  CREATED:      容器的创建时间。
  STATUS:       容器状态。
  
  状态有7种：
  
  - created       （已创建）
  - restarting    （重启中）
  - running 或 Up （运行中）
  - removing      （迁移中）
  - paused        （暂停）
  - exited        （停止）
  - dead          （死亡）
  
  PORTS:         容器的端口信息和使用的连接类型（tcp\udp）。
  NAMES:         自动分配的容器名称。
  ```
  
- inspect	   查看某一容器的信息

  ```bash
  docker inspect XXXX
  ```

- top

- diff

- attach       直接进入容器，启动命令的终端，不会启动新的进程。

  ​                  适合想直接在终端中查看启动命令的输出。

  ```bash
  docker attach XXXX
  # 通过 Ctrl + p , 然后 Ctrl + q 组合键退出终端。
  ```

  **注意：** 如果从这个容器退出，会导致容器的停止。

- exec      进入容器，在容器中打开新的终端，并且可以启动新的进程。

  ```bash
  docker exec -it XXXX /bin/bash
  # -it  以交互模式打开 pseudo-TTY
  # exit 退出容器
  # 如果从这个容器退出，容器不会停止。
  ```

- events

- logs	查看容器内的标准输出

  ```bash
  docker logs [-f] id
  # -f 类似于 tail -f
  ```

- wait

- export

- rename

- commit

- port	查看网络端口
  ```bash
  docker port id/name
  ```
  
- container

  ```bash
  docker container ls -a     #查看所有容器
  ```

  

### 容器rootfs命令

- commit       从容器创建新镜像

  ```bash
  docker commit id 新的容器名
  ```

- cp

- diff

### 镜像仓库

- login

- pull	下载镜像

  ```bash
  docker pull [OPTIONS] [Docker Registry 地址[:端口号]/]仓库名[:标签]
  ```

- push	发布docker镜像

  ```bash
  docker push XXXX
  ```

- search	搜索可用的docker镜像

  ```bash
  docker search XXXX
  ```

### 本地镜像管理

- images	

  ```bash
  docker images            #显示镜像列表。
  
  docker images COMMAND
  # COMMAND:
  build
  history
  import
  inspect
  load
  
  ls [OPTIONS] <name>|<repo:tag>          列出镜像
      -f,--filter
                   since/before/lable=
      --format
      -q
  
  prune
  pull
  push
  
  rm [OPTIONS] <image>
  
  save
  tag
  ```

- rmi              删除主机中的镜像。

  如果一个镜像对应了多个 tag，只有当最后一个 tag 被删除时，镜像才被真正删除。

- tag               给镜像打 tag 。

- build            从 Dockerfile 构建镜像。

- history         显示镜像构建历史

  ```bash
  docker history image_id
  ```

- save

- load

- import

### info|version
- info	显示系统信息，包括镜像和容器数。

  ```bash
  docker info [OPTIONS]
  
  -f, --format string 	指定返回值的模板文件
  ```

- version	显示版本号

  ```bash
  docker version [OPTIONS]
  
  -f, --format string 	指定返回值的模板文件
  ```

### system

查看镜像、容器和数据卷所占用的空间。

```bash
docker system df
```

## 用户

默认情况下，docker 命令会使用Unix socket 与Docker 引擎通讯。而只有root 用户和docker 组的用户才可以访问Docker 引擎的Unix socket。出于安全考虑，一般Ubuntu系统上不会直接使用root 用户。因此，更好地做法是将需要使用docker 的用户加入docker用户组。

1. 建立docker组

```shell
sudo groupadd docker
```

2. 将当前用户加入docker组

```shell
sudo usermod -aG docker $USER
```

3. 注销当前用户，重新登录Ubuntu，输入docker info，此时可以直接出现信息。

```shell
docker info
```

## 配置国内镜像加速

在/etc/docker/daemon.json 中写入如下内容（如果文件不存在请新建该文件）

```shell
{
    "registry-mirrors": [
        "https://registry.docker-cn.com"
    ]
}
```

重新启动服务

```shell
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 创建镜像

构建镜像的方式：

* 从无到有开始创建。
* 下载并使用他人创建好的镜像。
* 从现有镜像上创建新的镜像。

可以通过以下两种方式对镜像进行更改：

- 从已经创建的容器中更新镜像，并且提交这个镜像。
- 使用 Dockerfile 指令来创建一个新的镜像。

### docker commit

步骤：

* 运行容器
* 修改容器
* 将容器保存为新的镜像。

```bash
docker commit -m="has update" -a="kkkk" e1148edb50161 kkkk/ubuntu:v2
sha256:0fd7c0d81f8f7c70bf18459fc03ac2d7eb29f854c1a8ef0a42a7bdee9545aff8

-m:                提交的描述信息
-a:                指定镜像作者
e1148edb50161：    容器 ID
kkkk/ubuntu:v2:    指定要创建的目标镜像名
```

**不建议使用：**

* 一种手工创建镜像的方式，容易出错，效率低且可重复性弱。
* 无法对镜像进行审计，存在安全隐患。

### docker build

使用 Dockerfile 文件，通过 docker build 命令来构建一个镜像。

```bash
docker build -t kkkk/centos:6.7 .

-t		指定要创建的目标镜像名
.		Dockerfile 文件所在目录，可以指定 Dockerfile 的绝对路径
```

### 设置镜像标签

使用 docker tag 命令，为镜像添加一个新的标签。

```bash
docker tag 279860cd2fec kkkk/centos:dev
```

## Dockerfile

是一个用来构建镜像的文本文件，文本内容包含了一条条构建镜像所需的指令和说明。

每一个指令都会在镜像上创建一个新的层，每一个指令的前缀都必须是大写的。

```dockerfile
FROM ubuntu
# 指定基础镜像。
# 除了选择现有镜像为基础镜像外，还存在一个特殊的镜像，名为 scratch 。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。如以 scratch 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。不以任何系统为基础，直接将可执行文件复制进镜像的做法并不罕见。对于 Linux 下静态编译的程序来说，并不需要有操作系统提供运行时支持，所需的一切库都已经在可执行文件里了，因此直接 FROM scratch 会让镜像体积更加小巧。使用 Go 语言 开发的应用很多会使用这种方式来制作镜像。

MAINTAINER Krupp "wf.ab@126.com"

# ENV 设置环境变量
# 格式1：  ENV <key> <value>
# 格式2：  ENV <key1>=<value1> [<key2>=<value2>...]
ENV VERSION=1.0

# ARG 构建参数
ARG <OPTION_NAME>[=<默认值>]
# ARG 所设置的构建环境的环境变量，仅对 Dockerfile 内有效，在将来容器运行时是不会存在的。在 docker history 中可以看到所有的值。
# 默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖。

# WORKDIR 指定工作目录
WORKDIR <工作目录路径>
# 用 WORKDIR 指定的工作目录，会在构建镜像的每一层中都存在。（WORKDIR 指定的工作目录，必须是提前创建好的）。
# docker build 构建镜像过程中的，每一个 RUN 命令都是新建的一层。只有通过 WORKDIR 创建的目录才会一直存在。

# USER 指定当前用户
USER <用户名>[:<用户组>]
# 用于指定执行后续命令的用户和用户组，只是切换后续命令执行的用户（用户和用户组必须提前已经存在）。

# RUN 执行命令行命令
# 两种模式：
# 1. shell格式：  RUN <COMMAND>
# 2. exec格式：   RUN ["可执行文件","OPTION_1","OPTION_2"]
RUN apt-get update && apt-get purge -y --auto-remove

# CMD 容器启动命令
# 格式：
# shell格式：   CMD <COMMAND>
# exec格式：    CMD ["可执行文件","OPTION_1","OPTION_2"]
# 参数列表格式：  CMD ["OPTION_1","OPTION_2"]    在制定了ENTRYPOINT指令后，用CMD指定具体的参数。
CMD ["nginx","-g","daemon off;"]
# 作用：为启动的容器指定默认要运行的程序，程序运行结束，容器也就结束。
# CMD 指令指定的程序可被 docker run 命令行参数中指定要运行的程序所覆盖。
# 注意：如果 Dockerfile 中存在多个 CMD 指令，仅最后一个生效。

# #############################
# RUN 和 CMD 二者运行的时间点不同:
#     CMD 在docker run 时运行。
#     RUN 是在 docker build。
# #############################

# COPY 复制文件,从上下文目录中复制文件或者目录到容器里指定路径。
# COPY <源路径> <目标路径>
# COPY ["源路径","目标路径"]
# 目标路径不需要事先创建，如不存在，会在复制文件前先行创建。
COPY package.json /usr/src/app/
COPY [--chown=<user>:<group>] <源路径1>...  <目标路径>
COPY [--chown=<user>:<group>] ["<源路径1>",...  "<目标路径>"]
# [--chown=<user>:<group>]       可选参数，用户改变复制到容器内文件的拥有者和属组。
# <源路径>                        源文件或者源目录，可以是通配符表达式，其通配符规则要满足 Go 的 filepath.Match 规则。

# ADD 复制文件（同样需求下，官方推荐使用 COPY）
# 源路径是URL，会自动下载。源路径是tar压缩包，会自动解压缩。
ADD ubuntu-xenial-core-clouding-amd64-root.tar.gz /
# 优点：在执行 <源文件> 为 tar 压缩文件的话，压缩格式为 gzip, bzip2 以及 xz 的情况下，会自动复制并解压到 <目标路径>。
# 缺点：在不解压的前提下，无法复制 tar 压缩文件。会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢。具体是否使用，可以根据是否需要自动解压来决定。

# VOLUME 定义匿名数据卷。
# VOLUME ["路径1","路径2"]
# VOLUME <路径>
VOLUME /data
# 容器运行时应该尽量保持容器存储层不发生写操作，对于需要保存动态数据的应用，其文件应该保存于卷(volume)中。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 Dockerfile 中，可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。运行时可以用-v覆盖这个挂载设置。
# 避免容器不断变大。

# EXPOSE 声明端口
EXPOSE <端口1> [<端口2>...]
EXPOSE 80
# 作用：
# 帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射。
# 在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

# ENTRYPOINT 入口点
# 类似于 CMD 指令，但其不会被 docker run 的命令行参数指定的指令所覆盖，而且这些命令行参数会被当作参数送给 ENTRYPOINT 指令指定的程序。
# 如果运行 docker run 时使用了 --entrypoint 选项，将覆盖 CMD 指令指定的程序。
# 优点：在执行 docker run 的时候可以指定 ENTRYPOINT 运行所需的参数。
# 注意：如果 Dockerfile 中如果存在多个 ENTRYPOINT 指令，仅最后一个生效。
ENTRYPOINT ["<executeable>","<param1>","<param2>",...]
# 可以搭配 CMD 命令使用：一般是变参才会使用 CMD ，这里的 CMD 等于是在给 ENTRYPOINT 传参。

# #################################################################
# 假设已通过 Dockerfile 构建了 nginx:test 镜像：
#
# FROM nginx
# ENTRYPOINT ["nginx", "-c"]      # 定参
# CMD ["/etc/nginx/nginx.conf"]   # 变参 
#
# 1、不传参运行
#    docker run  nginx:test
#    容器内会默认运行以下命令，启动主进程。
#    nginx -c /etc/nginx/nginx.conf
# 
# 2、传参运行
#    docker run  nginx:test -c /etc/nginx/new.conf
#    容器内会默认运行以下命令，启动主进程(/etc/nginx/new.conf:假设容器内已有此文件)
#    nginx -c /etc/nginx/new.conf
# ###################################################################

# HEALTHCHECK 健康检查。用于指定某个程序或者指令来监控 docker 容器服务的运行状态。
# 返回值： 0 - 成功    1 - 失败    2 - 保留
HEALTHCHECK [OPTION] CMD <command>
#    --interval=<间隔>  两次健康检查的间隔，默认为30s
#    --timeout=<时长>   健康检查命令运行超时时间，如超过这个时间，本次健康检查就被视为失败，默认30s
#    --retries=<次数>   当连续失败指定次数后，将容器状态视为unhealthy ，默认3次。
# HEALTHCHECK NONE：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令。

# ONBUILD
# 是一个特殊的指令，它后面跟的是其它指令，比如 RUN , COPY 等，而这些指令，在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。
ONBUILD <其它指令>

# LABEL
# 用来给镜像添加一些元数据（metadata），以键值对的形式，语法格式如下：
LABEL <key>=<value> <key>=<value> <key>=<value> ...
# 比如我们可以添加镜像的作者：
# LABEL org.opencontainers.image.authors="runoob"
```

### 构建

```bash
docker build [OPTIONS] DockerFile_PATH | URL | -

# OPTIONS：
–force-rm=false
–no-cache=false
–pull=false
-q，quite=false，构建时不输出信息
–rm=true
-t，tag=“”，指定输出的镜像名称信息
```

Docker 不是虚拟机，容器中的应用都应该以前台执行，而不是像虚拟机、物理机里面那样，用 upstart/systemd 去启动后台服务，容器内没有后台服务的概念。

### 上下文路径

上下文路径，是指 docker 在构建镜像，有时候想要使用到本机的文件（比如复制），docker build 命令得知这个路径后，会将路径下的所有内容打包。

**解析**：由于 docker 的运行模式是 C/S。本机是 Client，docker 引擎是 Server。实际的构建过程是在 docker 引擎下完成的，所以这个时候无法用到本机的文件。这就需要把本机的指定目录下的文件一起打包提供给 docker 引擎使用。如果未说明最后一个参数，那么默认上下文路径就是 Dockerfile 所在的位置。

**注意**：上下文路径下不要放无用的文件，因为会一起打包发送给 docker 引擎，如果文件过多会造成过程缓慢。







守护式容器

交互式容器在运行完命令退出后即停止，而实际中我们常常需要能够长时间运行，即使退出也能后台运行的容器，而守护式容器具备这一功能。守护式容器具有：

    能够长期运行；
    没有交互式会话；
    适合于运行应用程序和服务。

以守护形式运行容器

我们执行完需要的操作退出容器时，不要使用exit退出，可以利用Ctrl+P Ctrl+Q代替，以守护式形式推出容器。

守护形式运行容器

附加到运行中的容器

退出正在运行的容器，想要再次进入，需要使用attach命令：docker attach name | id

docker attach haha

    1

启动守护式容器

启动守护式容器，可以在后台为我们执行操作：docker run -d IMAGE_NAME [COMMAND] [ARG…]

当命令在后台执行完毕，容器还是会关闭。这里防止容器立刻退出，写一个脚本循环输出“hello world”。

docker run --name hiahia -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"

    1

启动守护式容器

查看容器日志

当守护式容器在后台运行时，我们可以利用docker的日志命令查看其输出：docker logs [-f] [-t] [–tail] IMAGE_NAME

-f –follows=true | false，默认是false，显示更新

-t –timestamps=true | false，默认是false，显示时间戳

–tail=“all” | 行数，显示最新行数的日志

查看容器日志

查看容器内进程

对运行的容器查看其进程：docker top IMAGE_NAME

查看容器内进程

运行中容器启动新进程

Docker的理念是一个容器运行一个服务，但是往往需要对一个服务进行监控，所以也需要在已经运行服务的容器启动新的进程：docker exec [-d] [-i] [-t] IMAGE_NAME [COMMAND] [ARG…]

docker exec -i -t hiahia /bin/bash

    1

启动新进程

停止守护式容器

发送信号停止容器：docker stop 容器名

强制停止：docker kill 容器名
VI. 案例：在容器中部署静态网站
容器的端口映射

命令：run [-P] [-p]

-P，–publish-all=true | false，大写的P表示为容器暴露的所有端口进行映射；

-p，–publish=[]，小写的p表示为容器指定的端口进行映射，有四种形式：

containerPort：只指定容器的端口，宿主机端口随机映射；
hostPort:containerPort：同时指定容器与宿主机端口一一映射；
ip::containerPort：指定ip和容器的端口；
ip:hostPort:containerPort：指定ip、宿主机端口以及容器端口。

例如：

docker run -p 80 -i -t ubuntu /bin/bash
docker run -p 8080:80 -i -t ubuntu /bin/bash
docker run -p 0.0.0.0::80 -i -t ubuntu /bin/bash
docker run -p 0.0.0.0:8080:80 -i -t ubuntu /bin/bash



容器中部署Nginx服务

```bash
# 1. 创建映射80端口的交互式容器
docker run -p 80 --name web -i -t ubuntu /bin/bash

# 2. 更新源
apt-get update

# 3. 安装Nginx
apt-get install -y nginx

# 4. 安装Vim
apt-get install -y vim

# 5.创建静态页面：
mkdir -p /var/www/html
cd /var/www/html
vim index.html

修改Nginx配置文件:

# 查看Nginx安装位置

whereis nginx

# 修改配置文件

vim /etc/nginx/sites-enabled/default

    1
    2
    3
    4

修改Nginx配置文件

运行Nginx:

# 启动nginx

nginx

# 查看进程

ps -ef

运行Nginx

验证网站访问：

# 退出容器

Ctrl+P Ctrl+Q

# 查看容器进程

docker top web

# 查看容器端口映射情况

docker port web

查看进程和端口

通过宿主机地址加映射端口访问：

访问网站
```


VII. 镜像基操
查看删除镜像

    列出镜像：docker images [OPTIONS] [REPOSITORY]
    
    -a，–all=false，显示所有镜像
    
    -f，–filter=[]，显示时过滤条件
    
    –no-trunc=false，指定不使用截断的形式显示数据
    
    -q，–quiet=false，只显示镜像的唯一id
    
    查看镜像
    
    查看镜像：docker inspect [OPTIONS] CONTAINER|IMAGE [CONTAINER|IMAGE]
    
    -f，–format=“”
    
    查看镜像
    
    删除镜像：docker rmi [OPTIONS] IMAGE [IMAGE]
    
    -f，–force=false，强制删除镜像
    
    –no-prune=false，保留未打标签的父镜像
    
    虚悬镜像：既没有仓库名，也没有标签，均为\

获取推送镜像

    查找镜像：docker search [OPTIONS] TEAM
    
    –automated=false，仅显示自动化构建的镜像
    
    –no-trunc=false，不以截断的方式输出
    
    –filter，添加过滤条件
    
    查找ubuntu镜像
    
    拉取镜像：docker pull [OPTIONS] NAME [:TAG]
    
    -a，–all-tags=false，下载所有的镜像（包含所有TAG）
    
    拉取镜像
    
    推送镜像：docker push NAME [:TAG]
    
    Docker允许上传我们自己构建的镜像，需要注册DockerHub的账户。也可以上传到阿里云，地址：https://cr.console.aliyun.com/#/namespace/index


VIII. 镜像迁移

我们制作好的镜像，一般会迁移或分享给其他需要的人。Docker提供了几种将我们的镜像迁移、分享给其他人的方式。推荐镜像迁移应该直接使用Docker Registry，无论是直接使用Docker Hub还是使用内网私有Registry都可以。使用镜像频率不高，镜像数量不多的情况下，我们可以选择以下两种方式。
上传Docker Hub

首先，需要在Docker Hub上申请注册一个帐号（人机验证时需要科学上网）。然后我们需要创建仓库，指定仓库名称。

新建仓库

在终端中登录你的Docker Hub账户，输入docker login，输入用户名密码即可登录成功。

登录docker账户

查看需要上传的镜像，并将选择的镜像打上标签，标签名需和Docker Hub上新建的仓库名称一致，否则上传失败。给镜像打标签的命令如下。

docker tag <existing-image> <hub-user>/<repo-name>[:<tag>]

    1

其中existing-image代表本地待上传的镜像名加tag，后面<hub-user>/<repo-name>[:<tag>]则是为上传更改的标签名，tag不指定则为latest。

打上标签

可以看到，我们重新为ubuntu:16.04的镜像打上标签，观察IMAGE ID可知，同一镜像可以拥有不同的标签名。接下来，我们利用push命令直接上传镜像。

docker push <hub-user>/<repo-name>:<tag>

    1

如图，我们已经上传成功。由于之前介绍的分层存储系统，我们这里是直接对已有的ubuntu镜像进行上传，只是重新打了标签，所以真正上传的只是变化的部分。

上传成功

Hub查看
导出文件互传

Docker 还提供了 docker load 和 docker save 命令，用以将镜像保存为一个tar文件。比如这次我们将ubuntu:latest这个镜像保存为tar文件。

docker save

查看本地磁盘，即可看见名为ubuntu18.04的tar包。我们可以将其拷贝给其他PC，利用load命令重新导入。








Mesos、 Capistrano、 Fabric、 Ansible、 Chef、 Puppet、 SaltStack 等技术。

因此，应用程序不仅具有更好的可扩展性，而且更加可靠。存储应用的容器实例数量的增减，对于前端网站的影响很小。事实证明，这种架构对于非 Docker 化的应用程序已然成功，但是 Docker 自身包含了这种架构方式，使得 Docker 化的应用程序始终遵循这些最佳实践，这也是一件好事。
Docker 工作流程的好处

我们很难把 Docker 的好处一一举例。如果用得好，Docker 能在多个方面为组织，团队，开发者和运营工程师带来帮助。从宿主系统的角度看，所有应用程序的本质是一样的，因此这就决定了 Docker 让架构的选择更加简单。这也让工具的编写和应用程序之间的分享变得更加容易。这世上没有什么只有好处却没有挑战的东西，但是 Docker 似乎就是一个例外。以下是一些我们使用 Docker 能够得到的好处：

使用开发人员已经掌握的技能打包软件

    许多公司为了管理各种工具来为它们支持的平台生成软件包，不得不提供一些软件发布和构建工程师的岗位。像 rpm、mock、 dpkg 和 pbuilder 等工具使用起来并不容易，每一种工具都需要单独学习。而 Docker 则把你所有需要的东西全部打包起来，定义为一个文件。

使用标准化的镜像格式打包应用软件及其所需的文件系统

    过去，不仅需要打包应用程序，还需要包含一些依赖库和守护进程等。然而，我们永远不能百分之百地保证，软件运行的环境是完全一致的。这就使得软件的打包很难掌握，许多公司也不能可靠地完成这项工作。常有类似的事发生，使用 Scientific Linux 的用户试图部署一个来自社区的、仅在 Red Hat Linux 上经过测试的软件包，希望这个软件包足够接近他们的需求。如果使用 Dokcer、只需将应用程序和其所依赖的每个文件一起部署即可。Docker 的分层镜像使得这个过程更加高效，确保应用程序运行在预期的环境中。

测试打包好的构建产物并将其部署到运行任意系统的生产环境

    当开发者将更改提交到版本控制系统的时候，可以构建一个新的 Docker 镜像，然后通过测试，部署到生产环境，整个过程中无需任何的重新编译和重新打包。

将应用软件从硬件中抽象出来，无需牺牲资源

    传统的企业级虚拟化解决方案，例如 VMware，以消耗资源为代价在物理硬件和运行其上的应用软件之间建立抽象层。虚拟机管理程序和每一个虚拟机中运行的内核都要占用一定的硬件系统资源，而这部分资源将不能够被宿主系统的应用程序使用。而容器仅仅是一个能够与 Linux 内核直接通信的进程，因此它可以使用更多的资源，直到系统资源耗尽或者配额达到上限为止。



企业级虚拟化平台（VMware、KVM 等）

    容器并不是传统意义上的虚拟机。虚拟机包含完整的操作系统，运行在宿主操作系统之上。虚拟化平台最大的优点是，一台宿主机上可以使用虚拟机运行多个完全不同的操作系统。而容器是和主机共用同一个内核，这就意味着容器使用更少的系统资源，但必须基于同一个底层操作系统（如 Linux）。

云平台（Openstack、CloudStack 等）

    与企业级虚拟化平台一样，容器和云平台的工作流程表面上有大量的相似之处。从传统意义上看，二者都可以按需横向扩展。但是，Docker 并不是云平台，它只能在预先安装 Docker 的宿主机中部署，运行和管理容器，并能创建新的宿主系统（实例），对象存储，数据块存储以及其他与云平台相关的资源。

配置管理工具（Puppet、Chef 等）

    尽管 Docker 能够显著提高一个组织管理应用程序及其依赖的能力，但不能完全取代传统的配置管理工具。Dockerfile 文件用于定义一个容器构建时内容，但不能持续管理容器运行时的状态和 Docker 的宿主系统。

部署框架（Capistrano、Fabric等）

    Docker 通过创建自成一体的容器镜像，简化了应用程序在所有环境上的部署过程。这些用于部署的容器镜像封装了应用程序的全部依赖。然而 Docker 本身无法执行复杂的自动化部署任务。我们通常使用其他工具一起实现较大的工作流程自动化。

工作负载管理工具（Mesos、Fleet等）

    Docker 服务器没有集群的概念。我们必须使用其他的业务流程工具（如 Docker 自己开发的 Swarm）智能地协调多个 Docker 主机的任务，跟踪所有主机的状态及其资源使用情况，确保运行着足够的容器。

虚拟化开发环境（Vagrant 等）

    对开发者来说，Vagrant 是一个虚拟机管理工具，经常用来模拟与实际生产环境尽量一致的服务器软件栈。此外，Vagrant 可以很容易地让 Mac OS X 和基于 Windows 的工作站运行 Linux 软件。由于 Docker 服务器只能运行在 Linux 上，于是它提供了一个名为 Boot2Docker 的工具允许开发人员在不同的平台上快速运行基于 Linux 的 Docker 容器。Boot2Docker 足以满足很多标准的 Docker 工作流程，但仍然无法支持 Docker Machine 和 Vagrant 的所有功能。

### 导出和导入容器

**导出容器**

如果要导出本地某个容器，可以使用 **docker export** 命令。

```
$ docker export 1e560fca3906 > ubuntu.tar
```

导出容器 1e560fca3906 快照到本地文件  ubuntu.tar。

这样将导出容器快照到本地文件。

**导入容器快照**

可以使用 docker import 从容器快照文件中再导入为镜像，以下实例将快照文件 ubuntu.tar 导入到镜像 test/ubuntu:v1:

```
$ cat docker/ubuntu.tar | docker import - test/ubuntu:v1
```

此外，也可以通过指定 URL 或者某个目录来导入，例如：

```
$ docker import http://example.com/exampleimage.tgz example/imagerepo
```

## 资源限制

### 内存限额

```bash
-m  --memory		# 设置内存的使用限额，例如 1MB , 1GB 。
--memory-swap		# 设置内存 + swap 的使用限额。
# 默认值均为 -1 ，没有限制。
# 在启动容器时，如不指定 --memory-swap ，则 --memory-swap 默认为 -m 的两倍。

docker run -m 200M --memory-swap=400M centos
# 允许该容器最多使用200M内存和200M Swap 。
```

### CPU 限额

```bash
-c  --cpu-shares	# 设置容器使用CPU的权重。默认为1024。
# 通过 -c 设置的 cpu share 并不是CPU资源的绝对数量，而是一个相对的权重值。
# 某个容器最终能分配到的CPU资源取决于它的 cpu share 占所有容器 cpu share 总和的比例。
# 按权重分配 CPU 只会发生在 CPU 资源紧张的情况下。
```

### Block IO 带宽限额

Block IO 指的是磁盘的读写，docker 可通过设置权重、限制 bps 和 iops 的方式限制容器读写磁盘的带宽。目前 Block IO 限额只对 direct IO （不使用文件缓存）有效。

#### block IO 权重

默认情况想，所有容器能平等地读写磁盘。可通过设置 --blkio-weight 参数来改变容器 block IO 优先级。默认值是500 。

```bash
docker run -it --name container_A --blkio-weight 700 centos
```

#### 限制 bps 和 iops

bps (byte per second)，每秒读写的数据量。

iops (io per second)，每秒 IO 的次数。

**参数：**

* --device-read-bps		 限制读某个设备的 bps 。
* --device-write-bps		限制写某个设备的 bps 。
* --device-read-iops		限制读某个设备的 iops 。
* --device-read-bps		 限制写某个设备的 iops 。

```bash
docker run -it --device-write-bps /dev/sdb:10MB centos
```

## 网络

### libnetwork & CNM

libnetwork 是 docker 容器网络库，最核心的内容是其定义的 Container Network Model (CNM) 。这个模型对容器网络进行了抽象，由以下3类组件组成：

* Sandbox

  Sandbox 是容器的网络栈，包含容器的 interface 、路由表和 DNS 设置。Linux Network Namespace 是 Sandbox 的标准实现。Sandbox 可以包含来自不同 Netwok 的 Endpoint 。

* Endpoint

  作用是将 Sandbox 接入 Network 。典型实现是 veth pair 。一个 Endpoint 只能属于一个网络，也只能属于一个 Sandbox 。

* Network

  Network 包含一组 Endpoint ，同一 Network 的 Endpoint 可以直接通信。Network 的实现可以是 Linux Bridge 、VLAN 等。

![](../../../../Image/c/cnm.png)

### 单个 host 上的网络

查看网络：

```bash
docker network ls

NETWORK ID		NAME		DRIVER		SCOPE
cb243ec4eeb5	bridge		bridge		local
f33f4e2abb43	host		host		local
c123be34fd35	none		null		local
```

#### none

无网络。挂在这个网络下的容器除了 lo ，没有其他任何网卡。

创建容器时，通过 `--network=none` 指定使用 none 网络。

```bash
docker run -it --network=none centos
```

#### host

连接到 host 网络的容器共享 Docker host 的网络栈，容器的网络配置与 host 完全一样。

通过 `--network=host` 指定使用 host 网络。

```bash
docker run -it --network=host centos
```

在容器中可以看到 host 所有的网卡，hostname 也是 host 的。需要考虑端口冲突问题。

#### bridge

Docker 安装时，会创建一个命名为 docker0 的 Linux bridge 。如不指定 `--network` ，创建的容器默认都会挂到 docker0 上。docker0 的 IP 为 `172.17.0.1` 。

查看网桥信息：

```bash
docker network inspect bridge
```

veth pair 是一种成对出现的特殊网络设备。

创建容器时，docker 会自动从 `172.17.0.0/16` 中分配一个 IP 。

#### user-defined

用户可以根据业务需要创建 user-defined 网络。

提供3种 user-defined 网络驱动：

* bridge
* overlay
* macvlan

```bash
docker network create --driver bridge my_net
# 指定网段和网关
docker network create --driver bridge --subnet 172.23.16.0/24 --gateway 172.22.16.1 my_net1

docker run -it --network=my_net centos
# 指定容器的IP
# 只有使用 --subnet 创建的网络才能指定静态IP
docker run -it --network=my_net --ip 172.23.16.8 centos
# 将容器连接至网络
docker network connect my_net id
```

### 跨多个 host 的网络

#### user-defined

提供2种 user-defined 网络驱动：

* overlay
* macvlan

##### overlay

使用户可以创建基于 VxLAN 的 overlay 网络。VxLAN 可将二层数据封装到 UDP 进行传输。提供与 VLAN 相同的以太网二层服务，但拥有更强的扩展性和灵活性。

overlay 网络需要一个 key-value 数据库用于保存网络状态信息，包括 Network 、Endpoint 、IP 等。可选软件;

* Consul
* Etcd
* ZooKeeper

```bash
# 示例
# Host:
#	host_consul	192.168.16.101
# 	host1	192.168.16.104
#	host2	192.168.16.105

# host_consul
docker run -d -p 8500:8500 -h consul --name consul progrium/consul --server --bootstrap
# Consul 访问 http://192.168.16.101:8500

# host1 host2
# 修改 docker daemon 配置文件，并重启 docker daemon
# /etc/systemd/system/docker.service
# ExecStart 项，追加：
--cluster-store=consul://192.168.16.101:8500 --cluster-advertise=enp0s1:2376
# --cluster-store		指定 consul 的地址。
# --cluster-advertise	告知 consul 自己的链接地址。
systemctl daemon-reload
systemctl restart docker.service

# host1
# 创建 overlay 网络
docker network create -d overlay ov_net1
# 可指定IP
docker network create -d overlay --subnet 10.16.1.0/24 ov_net1
docker network ls

# host2
# 查看网络
docker network ls

# 创建容器
docker run -itd --name bbox1 --network ov_net1 centos
```

##### macvlan

macvlan 是 Linux kernel 模块，功能是允许同一个物理网卡配置多个 MAC 地址，即多个 interface , 每个 interface 可以配置 IP 。

docker 不为 macvlan 提供 DNS 服务。

```bash
# 示例
# Host:
# 	host1	192.168.16.104
#	host2	192.168.16.105

# host1 host2
# 更改网卡模式
ip link set enp0s1 promisc on
# 创建 macvlan 网络，host1 和 host2 均需要执行。
docker network create -d macvlan --subnet=172.16.50.0/24 --gateway=172.16.50.1 -o parent=enp0s1 mac_net1
# -o parent 指定网络的接口

# 创建容器
docker run -itd --name bbox1 --ip=172.16.50.10 --network mac_net1 centos
docker run -itd --name bbox2 --ip=172.16.50.11 --network mac_net1 centos
```



#### 第三方解决方案

* flannel
* weave
* calico



### 容器间通信

#### 1. IP

创建容器时通过 `--network` 指定相应的网络，或者通过 `docker network connect` 将现有容器加入到指定网络。

#### 2. Docker DNS Server

Docker daemon 实现了一个内嵌的 DNS Server ，使容器可以直接通过“容器名”通信。在启动时用 `--name` 为容器命名即可。

**限制：**只能在 user-defined 网络中使用。默认的 bridge 网络无法使用 DNS 。

#### 3. joined

可以使两个或多个容器共享一个网络栈，共享网卡和配置信息，容器之间可以通过 127.0.0.1 直接通信。

```bash
docker run -d -it --name=web1 httpd
docker run -it --network=container:web1 centos
```

**适用场景：**

* 不同容器中的程序希望通过loopback高效快速的通信，比如 Web Server 和 APP Server 。
* 希望监控其他容器的网络流量，比如运行在独立容器中的网络监控程序。

### 容器与外界通信

#### 容器访问外界

默认允许。通过NAT实现。

```bash
iptables -t nat -S

-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
```

#### 从外界访问容器

通过端口映射。

```bash
docker run -d -p 8080:80 httpd
docker port id
```

每一个映射的端口，host 都会启动一个 docker-proxy 进程来处理访问容器的流量。

## 存储

Docker 为容器提供了两种存放数据的资源：

* 由 storage driver 管理的镜像层和容器层。
* Data Volume

### Storage driver

实现了多层数据的堆叠并未用户提供一个单一的合并之后的统一视图。

适合没有需要持久化数据的容器。

多种storage driver:

* AUFS
* Device Mapper
* Btrfs
* OverlayFS
* VFS
* ZFS

优先使用Linux发行版默认的storage driver。

```bash
# 查看默认driver
docker info
```

> Ubuntu 默认的是AUFS ，底层文件系统是extfs，各层数据存放在/var/lib/docker/aufs 。Redhat/CentOS 默认是Device Mapper 。
> SUSE 默认是 Btrfs 。

### Data Volume

本质上是 Docker Host 文件系统中的目录或文件，能够直接被 mount 到容器的文件系统中。

* Data Volume 是目录或文件，而非没有格式化的磁盘（块设备）。
* 容器可以读写 volume 中的数据。
* volume 数据可以被永久的保存，即使使用它的容器已被销毁。

docker 提供了两种类型的 volume:

* bind mount
* docker managed volume

#### bind mount

将 host 上已存在的目录或文件 mount 到容器。限制了容器的可移植性。

```bash
docker run -d -p 80:80 -v /htdocs:/usr/local/apache2/htdocs httpd

-v <host_path>:<container_path>[:ro]
# [:ro] 设置权限为只读，默认为读写。
```

#### docker managed volume

docker managed volume 不需要指定 mount 源，指明 mount point 即可。

```bash
docker run -d -p 80:80 -v /usr/local/apache2/htdocs httpd
```

volume 位于 `/var/lib/docker/volumes` 

查看 volume :

```bash
# 查看容器信息
docker inspect id
# 查看卷
docker volume ls
# 查看卷信息
docker volume inspect volume_id
```

#### 对比

| 不同点                  | bind mount                   | docker managed volume        |
| ----------------------- | ---------------------------- | ---------------------------- |
| volume 位置             | 可任意指定                   | /var/lib/docker/volumes/     |
| 对已有 mount point 影响 | 隐藏并替换为 volume          | 原有数据复制到 volume        |
| 是否支持单个文件        | 支持                         | 不支持，只能是目录           |
| 权限控制                | 可设置为只读，默认为读写权限 | 无控制，均为读写权限         |
| 移植性                  | 移植性弱，与 host path 绑定  | 移植性强，无需指定 host 目录 |

### 数据共享

#### 容器与 host 共享数据

* bind mount

  直接将要共享的目录 mount 到容器。

* docker managed volume

  由于 volume 位于 host 中的目录，是在容器启动时才生成，所以需要将共享数据复制到volume中。

  ```bash
  docker cp /htdocs/index.html 3a2efadffd14:/usr/local/apache2/htdocs
  
  cp /htdocs/index.html /var/lib/docker/volumes/3a2efadffd14xxxxx
  ```

#### 容器间共享数据

* bind mount

  ```bash
  docker run --name web1 -d -p 80 -v /htdocs:/usr/local/apache2/htdocs httpd
  docker run --name web2 -d -p 80 -v /htdocs:/usr/local/apache2/htdocs httpd
  ```

* volume container

  是专门为其他容器提供 volume 的容器。提供的卷可以是bind mount，也可以是 docker managed volume。

  ```bash
  docker create --name vc_data -v /htdocs:/usr/local/apache2/htdocs centos
  docker run --name web1 -d -p 80 --volumes-from vc_data httpd
  docker run --name web2 -d -p 80 --volumes-from vc_data httpd
  ```

* data-packed volume container

  将数据完全放到 volume container 中。

  ```dockerfile
  # 创建 dockerfile
  FROM centos
  ADD htdocs /usr/local/apache2/htdocs
  VOLUME /usr/local/apache2/htdocs
  
  # build 新镜像
  docker build -t datapacked
  
  docker create --name vc_data datapacked
  docker run --name web1 -d -p 80 --volumes-from vc_data httpd
  ```
### Data Volume 生命周期管理

#### 备份

volume 实际上是 host 文件系统中的目录和文件。备份实际上是对文件系统的备份。

#### 恢复

用之前备份的数据恢复到本地目录中。

#### 迁移

1. 停止原有容器。
2. 启动新容器，并 mount 原有 volume 。

#### 销毁

* bind mount

  docker 不会删除，删除数据的工作由 host 负责。

* docker managed volume

  在执行 docker rm 删除容器时，可用 -v 参数，docker 会将容器使用到的 volume 一并删除。前提是没有其他容器mount 该 volume 。

* docker volume rm

  ```bash
  docker volume rm id
  # 批量删除
  docker volume rm $(docker volume ls -q)
  ```

## 运行一个 web 应用

我们将在docker容器中运行一个 Python Flask 应用来运行一个web应用。

```
runoob@runoob:~# docker pull training/webapp  # 载入镜像
runoob@runoob:~# docker run -d -P training/webapp python app.py
```

![img](https://www.runoob.com/wp-content/uploads/2016/05/docker29.png)

参数说明:

- **-d:**让容器在后台运行。
- **-P:**将容器内部使用的网络端口随机映射到我们使用的主机上。

------

## 查看 WEB 应用容器

使用 docker ps 来查看我们正在运行的容器：

```
runoob@runoob:~#  docker ps
CONTAINER ID        IMAGE               COMMAND             ...        PORTS                 
d3d5e39ed9d3        training/webapp     "python app.py"     ...        0.0.0.0:32769->5000/tcp
```

这里多了端口信息。

```
PORTS
0.0.0.0:32769->5000/tcp
```

Docker 开放了 5000 端口（默认 Python Flask 端口）映射到主机端口 32769 上。

这时我们可以通过浏览器访问WEB应用

![img](https://www.runoob.com/wp-content/uploads/2016/05/docker31.png)

我们也可以通过 -p 参数来设置不一样的端口：

```
runoob@runoob:~$ docker run -d -p 5000:5000 training/webapp python app.py
```

**docker ps**查看正在运行的容器

```
runoob@runoob:~#  docker ps
CONTAINER ID        IMAGE                             PORTS                     NAMES
bf08b7f2cd89        training/webapp     ...        0.0.0.0:5000->5000/tcp    wizardly_chandrasekhar
d3d5e39ed9d3        training/webapp     ...        0.0.0.0:32769->5000/tcp   xenodochial_hoov
```

容器内部的 5000 端口映射到我们本地主机的 5000 端口上。

------

## 网络端口的快捷方式

通过 **docker ps** 命令可以查看到容器的端口映射，**docker** 还提供了另一个快捷方式 **docker port**，使用 **docker port** 可以查看指定 （ID 或者名字）容器的某个确定端口映射到宿主机的端口号。

上面我们创建的 web 应用容器 ID 为 **bf08b7f2cd89**  名字为 **wizardly_chandrasekhar**。

我可以使用 docker port bf08b7f2cd89  或 docker port wizardly_chandrasekhar 来查看容器端口的映射情况。

```
runoob@runoob:~$ docker port bf08b7f2cd89
5000/tcp -> 0.0.0.0:5000
runoob@runoob:~$ docker port wizardly_chandrasekhar
5000/tcp -> 0.0.0.0:5000
```

------

## 查看 WEB 应用程序日志

docker logs [ID或者名字] 可以查看容器内部的标准输出。

```
runoob@runoob:~$ docker logs -f bf08b7f2cd89
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
192.168.239.1 - - [09/May/2016 16:30:37] "GET / HTTP/1.1" 200 -
192.168.239.1 - - [09/May/2016 16:30:37] "GET /favicon.ico HTTP/1.1" 404 -
```

**-f:** 让 **docker logs** 像使用 **tail -f** 一样来输出容器内部的标准输出。

从上面，我们可以看到应用程序使用的是 5000 端口并且能够查看到应用程序的访问日志。

------

## 查看WEB应用程序容器的进程

我们还可以使用 docker top 来查看容器内部运行的进程

```
runoob@runoob:~$ docker top wizardly_chandrasekhar
UID     PID         PPID          ...       TIME                CMD
root    23245       23228         ...       00:00:00            python app.py
```

------

## 检查 WEB 应用程序

使用 **docker inspect** 来查看 Docker 的底层信息。它会返回一个 JSON 文件记录着 Docker 容器的配置和状态信息。

```
runoob@runoob:~$ docker inspect wizardly_chandrasekhar
[
    {
        "Id": "bf08b7f2cd897b5964943134aa6d373e355c286db9b9885b1f60b6e8f82b2b85",
        "Created": "2018-09-17T01:41:26.174228707Z",
        "Path": "python",
        "Args": [
            "app.py"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 23245,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-09-17T01:41:26.494185806Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
......
```

## 重启WEB应用容器

已经停止的容器，我们可以使用命令 docker start 来启动。

```
runoob@runoob:~$ docker start wizardly_chandrasekhar
wizardly_chandrasekhar
```

docker ps -l 查询最后一次创建的容器：

```
#  docker ps -l 
CONTAINER ID        IMAGE                             PORTS                     NAMES
bf08b7f2cd89        training/webapp     ...        0.0.0.0:5000->5000/tcp    wizardly_chandrasekhar
```

正在运行的容器，我们可以使用 docker restart 命令来重启。

------

## 移除WEB应用容器

我们可以使用 docker rm 命令来删除不需要的容器

```
runoob@runoob:~$ docker rm wizardly_chandrasekhar  
wizardly_chandrasekhar
```

删除容器时，容器必须是停止状态，否则会报如下错误

```
runoob@runoob:~$ docker rm wizardly_chandrasekhar
Error response from daemon: You cannot remove a running container bf08b7f2cd897b5964943134aa6d373e355c286db9b9885b1f60b6e8f82b2b85. Stop the container before attempting removal or force remove
```



安装完docker后，执行docker相关命令，出现：

```
”Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.26/images/json: dial unix /var/run/docker.sock: connect: permission denied“
```

**原因**

摘自docker mannual上的一段话：

```
Manage Docker as a non-root user

The docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user root and other users can only access it using sudo. The docker daemon always runs as the root user.

If you don’t want to use sudo when you use the docker command, create a Unix group called docker and add users to it. When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group
```

大概的意思就是：docker进程使用Unix Socket而不是TCP端口。而默认情况下，Unix socket属于root用户，需要root权限才能访问。

**解决方法1**

使用sudo获取管理员权限，运行docker命令

**解决方法2**

docker守护进程启动的时候，会默认赋予名字为docker的用户组读写Unix  socket的权限，因此只要创建docker用户组，并将当前用户加入到docker用户组中，那么当前用户就有权限访问Unix  socket了，进而也就可以执行docker相关命令

```
sudo groupadd docker     #添加docker用户组
sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
newgrp docker     #更新用户组
docker ps    #测试docker命令是否可以使用sudo正常使用
```



## 列出镜像列表

我们可以使用 **docker images** 来列出本地主机上的镜像。

```
runoob@runoob:~$ docker images           
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              14.04               90d5884b1ee0        5 days ago          188 MB
php                 5.6                 f40e9e0f10c8        9 days ago          444.8 MB
nginx               latest              6f8d099c3adc        12 days ago         182.7 MB
mysql               5.6                 f2e8d6c772c0        3 weeks ago         324.6 MB
httpd               latest              02ef73cf1bc0        3 weeks ago         194.4 MB
ubuntu              15.10               4e3b13c8a266        4 weeks ago         136.3 MB
hello-world         latest              690ed74de00f        6 months ago        960 B
training/webapp     latest              6fae60ef3446        11 months ago       348.8 MB
```

各个选项说明:

- **REPOSITORY：**表示镜像的仓库源
- **TAG：**镜像的标签
- **IMAGE ID：**镜像ID
- **CREATED：**镜像创建时间
- **SIZE：**镜像大小

同一仓库源可以有多个 TAG，代表这个仓库源的不同个版本，如 ubuntu 仓库源里，有 15.10、14.04 等多个不同的版本，我们使用 REPOSITORY:TAG 来定义不同的镜像。

所以，我们如果要使用版本为15.10的ubuntu系统镜像来运行容器时，命令如下：

```
runoob@runoob:~$ docker run -t -i ubuntu:15.10 /bin/bash 
root@d77ccb2e5cca:/#
```

参数说明：

- **-i**: 交互式操作。
- **-t**: 终端。
- **ubuntu:15.10**: 这是指用 ubuntu 15.10 版本镜像为基础来启动容器。
- **/bin/bash**：放在镜像名后的是命令，这里我们希望有个交互式 Shell，因此用的是 /bin/bash。

如果要使用版本为 14.04 的 ubuntu 系统镜像来运行容器时，命令如下：

```
runoob@runoob:~$ docker run -t -i ubuntu:14.04 /bin/bash 
root@39e968165990:/# 
```

如果你不指定一个镜像的版本标签，例如你只使用 ubuntu，docker 将默认使用 ubuntu:latest 镜像。

------

## 获取一个新的镜像

当我们在本地主机上使用一个不存在的镜像时 Docker 就会自动下载这个镜像。如果我们想预先下载这个镜像，我们可以使用 docker pull 命令来下载它。

```
Crunoob@runoob:~$ docker pull ubuntu:13.10
13.10: Pulling from library/ubuntu
6599cadaf950: Pull complete 
23eda618d451: Pull complete 
f0be3084efe9: Pull complete 
52de432f084b: Pull complete 
a3ed95caeb02: Pull complete 
Digest: sha256:15b79a6654811c8d992ebacdfbd5152fcf3d165e374e264076aa435214a947a3
Status: Downloaded newer image for ubuntu:13.10
```

下载完成后，我们可以直接使用这个镜像来运行容器。

------

## 查找镜像

我们可以从 Docker Hub 网站来搜索镜像，Docker Hub 网址为： **https://hub.docker.com/**

我们也可以使用 docker search 命令来搜索镜像。比如我们需要一个 httpd 的镜像来作为我们的 web 服务。我们可以通过 docker search 命令搜索 httpd 来寻找适合我们的镜像。

```
runoob@runoob:~$  docker search httpd
```

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/423F2A2C-287A-4B03-855E-6A78E125B346.jpg)](https://www.runoob.com/wp-content/uploads/2016/05/423F2A2C-287A-4B03-855E-6A78E125B346.jpg)

**NAME:** 镜像仓库源的名称

**DESCRIPTION:** 镜像的描述

**OFFICIAL:** 是否 docker 官方发布

**stars:** 类似 Github 里面的 star，表示点赞、喜欢的意思。

**AUTOMATED:** 自动构建。

------

## 拖取镜像

我们决定使用上图中的 httpd 官方版本的镜像，使用命令 docker pull 来下载镜像。

```
runoob@runoob:~$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
8b87079b7a06: Pulling fs layer 
a3ed95caeb02: Download complete 
0d62ec9c6a76: Download complete 
a329d50397b9: Download complete 
ea7c1f032b5c: Waiting 
be44112b72c7: Waiting
```

下载完成后，我们就可以使用这个镜像了。

```
runoob@runoob:~$ docker run httpd
```

## 删除镜像

镜像删除使用 **docker rmi** 命令，比如我们删除 hello-world 镜像：

```
$ docker rmi hello-world
```

![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-rmi-image.png)



# Docker 容器连接

前面我们实现了通过网络端口来访问运行在 docker 容器内的服务。

容器中可以运行一些网络应用，要让外部也可以访问这些应用，可以通过 -P 或 -p 参数来指定端口映射。

下面我们来实现通过端口连接到一个 docker 容器。

------

## 网络端口映射

我们创建了一个 python 应用的容器。

```
runoob@runoob:~$ docker run -d -P training/webapp python app.py
fce072cc88cee71b1cdceb57c2821d054a4a59f67da6b416fceb5593f059fc6d
```

另外，我们可以指定容器绑定的网络地址，比如绑定 127.0.0.1。

我们使用 **-P** 绑定端口号，使用 **docker ps** 可以看到容器端口 5000 绑定主机端口 32768。

```
runoob@runoob:~$ docker ps
CONTAINER ID    IMAGE               COMMAND            ...           PORTS                     NAMES
fce072cc88ce    training/webapp     "python app.py"    ...     0.0.0.0:32768->5000/tcp   grave_hopper
```

我们也可以使用 **-p** 标识来指定容器端口绑定到主机端口。

两种方式的区别是:

- **-P :**是容器内部端口**随机**映射到主机的高端口。
- **-p :** 是容器内部端口绑定到**指定**的主机端口。

```
runoob@runoob:~$ docker run -d -p 5000:5000 training/webapp python app.py
33e4523d30aaf0258915c368e66e03b49535de0ef20317d3f639d40222ba6bc0
runoob@runoob:~$ docker ps
CONTAINER ID        IMAGE               COMMAND           ...           PORTS                     NAMES
33e4523d30aa        training/webapp     "python app.py"   ...   0.0.0.0:5000->5000/tcp    berserk_bartik
fce072cc88ce        training/webapp     "python app.py"   ...   0.0.0.0:32768->5000/tcp   grave_hopper
```

另外，我们可以指定容器绑定的网络地址，比如绑定 127.0.0.1。

```
runoob@runoob:~$ docker run -d -p 127.0.0.1:5001:5000 training/webapp python app.py
95c6ceef88ca3e71eaf303c2833fd6701d8d1b2572b5613b5a932dfdfe8a857c
runoob@runoob:~$ docker ps
CONTAINER ID        IMAGE               COMMAND           ...     PORTS                                NAMES
95c6ceef88ca        training/webapp     "python app.py"   ...  5000/tcp, 127.0.0.1:5001->5000/tcp   adoring_stonebraker
33e4523d30aa        training/webapp     "python app.py"   ...  0.0.0.0:5000->5000/tcp               berserk_bartik
fce072cc88ce        training/webapp     "python app.py"   ...    0.0.0.0:32768->5000/tcp              grave_hopper
```

这样我们就可以通过访问 127.0.0.1:5001 来访问容器的 5000 端口。

上面的例子中，默认都是绑定 tcp 端口，如果要绑定 UDP 端口，可以在端口后面加上 **/udp**。

```
runoob@runoob:~$ docker run -d -p 127.0.0.1:5000:5000/udp training/webapp python app.py
6779686f06f6204579c1d655dd8b2b31e8e809b245a97b2d3a8e35abe9dcd22a
runoob@runoob:~$ docker ps
CONTAINER ID        IMAGE               COMMAND           ...   PORTS                                NAMES
6779686f06f6        training/webapp     "python app.py"   ...   5000/tcp, 127.0.0.1:5000->5000/udp   drunk_visvesvaraya
95c6ceef88ca        training/webapp     "python app.py"   ...    5000/tcp, 127.0.0.1:5001->5000/tcp   adoring_stonebraker
33e4523d30aa        training/webapp     "python app.py"   ...     0.0.0.0:5000->5000/tcp               berserk_bartik
fce072cc88ce        training/webapp     "python app.py"   ...    0.0.0.0:32768->5000/tcp              grave_hopper
```

**docker port** 命令可以让我们快捷地查看端口的绑定情况。

```
runoob@runoob:~$ docker port adoring_stonebraker 5000
127.0.0.1:5001
```

------

## Docker 容器互联

端口映射并不是唯一把 docker 连接到另一个容器的方法。

docker 有一个连接系统允许将多个容器连接在一起，共享连接信息。

docker 连接会创建一个父子关系，其中父容器可以看到子容器的信息。

------

### 容器命名

当我们创建一个容器的时候，docker 会自动对它进行命名。另外，我们也可以使用 **--name** 标识来命名容器，例如：

```
runoob@runoob:~$  docker run -d -P --name runoob training/webapp python app.py
43780a6eabaaf14e590b6e849235c75f3012995403f97749775e38436db9a441
```

我们可以使用 **docker ps** 命令来查看容器名称。

```
runoob@runoob:~$ docker ps -l
CONTAINER ID     IMAGE            COMMAND           ...    PORTS                     NAMES
43780a6eabaa     training/webapp   "python app.py"  ...     0.0.0.0:32769->5000/tcp   runoob
```

### 新建网络

下面先创建一个新的 Docker 网络。

```
$ docker network create -d bridge test-net
```

![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net.png)

参数说明：

**-d**：参数指定 Docker 网络类型，有 bridge、overlay。

其中 overlay 网络类型用于 Swarm mode，在本小节中你可以忽略它。

### 连接容器

运行一个容器并连接到新建的 test-net 网络:

```
$ docker run -itd --name test1 --network test-net ubuntu /bin/bash
```

打开新的终端，再运行一个容器并加入到 test-net 网络:

```
$ docker run -itd --name test2 --network test-net ubuntu /bin/bash
```

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net2.png)](https://www.runoob.com/wp-content/uploads/2016/05/docker-net2.png)

下面通过 ping 来证明 test1 容器和 test2 容器建立了互联关系。

如果 test1、test2 容器内中无 ping 命令，则在容器内执行以下命令安装 ping（即学即用：可以在一个容器里安装好，提交容器到镜像，在以新的镜像重新运行以上俩个容器）。

```
apt-get update
apt install iputils-ping
```

在 test1 容器输入以下命令：

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net3.png)](https://www.runoob.com/wp-content/uploads/2016/05/docker-net3.png)

同理在 test2 容器也会成功连接到:

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net4.png)](https://www.runoob.com/wp-content/uploads/2016/05/docker-net4.png)

这样，test1 容器和 test2 容器建立了互联关系。

如果你有多个容器之间需要互相连接，推荐使用 Docker Compose，后面会介绍。

------

## 配置 DNS

我们可以在宿主机的 /etc/docker/daemon.json 文件中增加以下内容来设置全部容器的 DNS：

```
{
  "dns" : [
    "114.114.114.114",
    "8.8.8.8"
  ]
}
```

设置后，启动容器的 DNS 会自动配置为 114.114.114.114 和 8.8.8.8。

配置完，需要重启 docker 才能生效。

查看容器的 DNS 是否生效可以使用以下命令，它会输出容器的 DNS 信息：

```
$ docker run -it --rm  ubuntu  cat etc/resolv.conf
```

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net5.png)](https://www.runoob.com/wp-content/uploads/2016/05/docker-net5.png)

**手动指定容器的配置**

如果只想在指定的容器设置 DNS，则可以使用以下命令：

```
$ docker run -it --rm -h host_ubuntu  --dns=114.114.114.114 --dns-search=test.com ubuntu
```

参数说明：

**--rm**：容器退出时自动清理容器内部的文件系统。

**-h HOSTNAME 或者 --hostname=HOSTNAME**： 设定容器的主机名，它会被写到容器内的 /etc/hostname 和 /etc/hosts。

**--dns=IP_ADDRESS**： 添加 DNS 服务器到容器的 /etc/resolv.conf 中，让容器用这个服务器来解析所有不在 /etc/hosts 中的主机名。

**--dns-search=DOMAIN**： 设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的主机时，DNS 不仅搜索 host，还会搜索 host.example.com。

点击图片查看大图：

[![img](https://www.runoob.com/wp-content/uploads/2016/05/docker-net6.png)](https://www.runoob.com/wp-content/uploads/2016/05/docker-net6.png)

如果在容器启动时没有指定 **--dns** 和 **--dns-search**，Docker 会默认用宿主主机上的 /etc/resolv.conf 来配置容器的 DNS。

 **解决windows系统无法对docker容器进行端口映射的问题**

1. **1、问题：**

     在Windows家庭版下安装了docker，并尝试在其中运行jupyter notebook等服务，但映射完毕之后，在主机的浏览器中，打开localhost:port无法访问对应的服务。

    **2、问题出现的原因：**

    ```
   The reason you’re having this, is because on Linux, the docker daemon (and your containers) run on the Linux machine itself, so “localhost” is also the host that the container is running on, and the ports are mapped to.
    
   On Windows (and OS X), the docker daemon, and your containers cannot run natively, so only the docker client is running on your Windows machine, but the daemon (and your containers) run in a VirtualBox Virtual Machine, that runs Linux.
   ```

   因为docker是运行在Linux上的，在Windows中运行docker，实际上还是在Windows下先安装了一个Linux环境，然后在这个系统中运行的docker。也就是说，服务中使用的localhost指的是这个Linux环境的地址，而不是我们的宿主环境Windows。

   **3、解决方法：**

   通过命令:

   ```
   docker-machine ip default   # 其中，default 是docker-machine的name，可以通过docker-machine -ls 查看
   ```
   
   找到这个Linux的ip地址，一般情况下这个地址是192.168.99.100，然后在Windows的浏览器中，输入这个地址，加上服务的端口即可启用了。

   比如，首先运行一个docker 容器：

   ```
   docker run -it -p 8888:8888 conda:v1
   ```

   其中，conda:v1是我的容器名称。然后在容器中开启jupyter notebook 服务：
   
   ```
   jupyter notebook --no-browser --port=8888 --ip=172.17.0.2 --allow-root
   ```

   其中的ip参数为我的容器的ip地址，可以通过如下命令获得：

   ```
   docker inspect container_id
   ```

   最后在windows浏览器中测试结果：

   ```
   http://192.168.99.100:8888
   ```

## Docker Compose

### Compose 简介

Compose 是用于定义和运行多容器 Docker 应用程序的工具。通过 Compose，您可以使用 YML 文件来配置应用程序需要的所有服务。然后，使用一个命令，就可以从 YML 文件配置中创建并启动所有服务。

如果你还不了解 YML 文件配置，可以先阅读 [YAML 入门教程](https://www.runoob.com/w3cnote/yaml-intro.html)。

Compose 使用的三个步骤：

- 使用 Dockerfile 定义应用程序的环境。
- 使用 docker-compose.yml 定义构成应用程序的服务，这样它们可以在隔离环境中一起运行。
- 最后，执行 docker-compose up 命令来启动并运行整个应用程序。

docker-compose.yml 的配置案例如下（配置参数参考下文）：

## 实例

\# yaml 配置实例
 version**:** '3'
 services:
  web:
   build**:** .
   ports**:
**   - "5000:5000"
   volumes**:
**   - .:/code
   \- logvolume01:/var/log
   links**:
**   - redis
  redis:
   image**:** redis
 volumes:
  logvolume01**:** {}

------

## Compose 安装

Linux

Linux 上我们可以从 Github 上下载它的二进制包来使用，最新发行的版本地址：https://github.com/docker/compose/releases。

运行以下命令以下载 Docker Compose 的当前稳定版本：

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

要安装其他版本的 Compose，请替换 1.24.1。

将可执行权限应用于二进制文件：

```
$ sudo chmod +x /usr/local/bin/docker-compose
```

创建软链：

```
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

测试是否安装成功：

```
$ docker-compose --version
cker-compose version 1.24.1, build 4667896b
```

**注意**： 对于 alpine，需要以下依赖包： py-pip，python-dev，libffi-dev，openssl-dev，gcc，libc-dev，和 make。

### macOS

Mac 的 Docker 桌面版和 Docker Toolbox 已经包括 Compose 和其他 Docker 应用程序，因此 Mac 用户不需要单独安装 Compose。Docker 安装说明可以参阅 [MacOS Docker 安装](https://www.runoob.com/docker/macos-docker-install.html)。

### windows PC

Windows 的 Docker 桌面版和 Docker Toolbox 已经包括 Compose 和其他 Docker 应用程序，因此 Windows 用户不需要单独安装 Compose。Docker 安装说明可以参阅[ Windows Docker 安装](https://www.runoob.com/docker/windows-docker-install.html)。

------

## 使用

### 1、准备

创建一个测试目录：

```
$ mkdir composetest
$ cd composetest
```

在测试目录中创建一个名为 app.py 的文件，并复制粘贴以下内容：

## composetest/app.py 文件代码

**import** time

 **import** redis
 **from** flask **import** Flask

 app = Flask(__name__)
 cache = redis.Redis(host='redis', port=6379)


 **def** get_hit_count():
   retries = 5
   **while** True:
     **try**:
       **return** cache.incr('hits')
     **except** redis.exceptions.ConnectionError **as** exc:
       **if** retries == 0:
         **raise** exc
       retries -= 1
       time.sleep(0.5)


 @app.route('/')
 **def** hello():
   count = get_hit_count()
   **return** 'Hello World! I have been seen {} times.**\n**'.format(count)

在此示例中，redis 是应用程序网络上的 redis 容器的主机名，该主机使用的端口为 6379。

在 composetest 目录中创建另一个名为 requirements.txt 的文件，内容如下：

```
flask
redis
```

### 2、创建 Dockerfile 文件

在 composetest 目录中，创建一个名为的文件 Dockerfile，内容如下：

```
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run"]
```

**Dockerfile 内容解释：**

- **FROM python:3.7-alpine**: 从 Python 3.7 映像开始构建镜像。

- **WORKDIR /code**: 将工作目录设置为 /code。

- ```
  ENV FLASK_APP app.py
  ENV FLASK_RUN_HOST 0.0.0.0
  ```

  设置 flask 命令使用的环境变量。

- **RUN apk add --no-cache gcc musl-dev linux-headers**: 安装 gcc，以便诸如 MarkupSafe 和 SQLAlchemy 之类的 Python 包可以编译加速。

- ```
  COPY requirements.txt requirements.txt
  RUN pip install -r requirements.txt
  ```

  复制 requirements.txt 并安装 Python 依赖项。

- **COPY . .**: 将 . 项目中的当前目录复制到 . 镜像中的工作目录。

- **CMD ["flask", "run"]**: 容器提供默认的执行命令为：flask run。

### 3、创建 docker-compose.yml

在测试目录中创建一个名为 docker-compose.yml 的文件，然后粘贴以下内容：

## docker-compose.yml 配置文件

\# yaml 配置
 version**:** '3'
 services:
  web:
   build**:** .
   ports**:
**    - "5000:5000"
  redis:
   image**:** "redis:alpine"

该 Compose 文件定义了两个服务：web 和 redis。

- **web**：该 web 服务使用从 Dockerfile 当前目录中构建的镜像。然后，它将容器和主机绑定到暴露的端口 5000。此示例服务使用 Flask Web 服务器的默认端口 5000 。
- **redis**：该 redis 服务使用 Docker Hub 的公共 Redis 映像。

### 4、使用 Compose 命令构建和运行您的应用

在测试目录中，执行以下命令来启动应用程序：

```
docker-compose up
```

如果你想在后台执行该服务可以加上 -d 参数：

```
docker-compose up -d
```

------

## yml 配置指令参考

### version

指定本 yml 依从的 compose 哪个版本制定的。

### build

指定为构建镜像上下文路径：

例如 webapp 服务，指定为从上下文路径 ./dir/Dockerfile 所构建的镜像：

```
version: "3.7"
services:
  webapp:
    build: ./dir
```

或者，作为具有在上下文指定的路径的对象，以及可选的 Dockerfile 和 args：

```
version: "3.7"
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
      args:
        buildno: 1
      labels:
        - "com.example.description=Accounting webapp"
        - "com.example.department=Finance"
        - "com.example.label-with-empty-value"
      target: prod
```

- context：上下文路径。
- dockerfile：指定构建镜像的 Dockerfile 文件名。
- args：添加构建参数，这是只能在构建过程中访问的环境变量。
- labels：设置构建镜像的标签。
- target：多层构建，可以指定构建哪一层。

### cap_add，cap_drop

添加或删除容器拥有的宿主机的内核功能。

```
cap_add:
  - ALL # 开启全部权限

cap_drop:
  - SYS_PTRACE # 关闭 ptrace权限
```

### cgroup_parent

为容器指定父 cgroup 组，意味着将继承该组的资源限制。

```
cgroup_parent: m-executor-abcd
```

### command

覆盖容器启动的默认命令。

```
command: ["bundle", "exec", "thin", "-p", "3000"]
```

### container_name

指定自定义容器名称，而不是生成的默认名称。

```
container_name: my-web-container
```

### depends_on

设置依赖关系。

- docker-compose up ：以依赖性顺序启动服务。在以下示例中，先启动 db 和 redis ，才会启动 web。
- docker-compose up SERVICE ：自动包含 SERVICE 的依赖项。在以下示例中，docker-compose up web 还将创建并启动 db 和 redis。
- docker-compose stop ：按依赖关系顺序停止服务。在以下示例中，web 在 db 和 redis 之前停止。

```
version: "3.7"
services:
  web:
    build: .
    depends_on:
      - db
      - redis
  redis:
    image: redis
  db:
    image: postgres
```

注意：web 服务不会等待 redis db 完全启动 之后才启动。

### deploy

指定与服务的部署和运行有关的配置。只在 swarm 模式下才会有用。

```
version: "3.7"
services:
  redis:
    image: redis:alpine
    deploy:
      mode：replicated
      replicas: 6
      endpoint_mode: dnsrr
      labels: 
        description: "This redis service label"
      resources:
        limits:
          cpus: '0.50'
          memory: 50M
        reservations:
          cpus: '0.25'
          memory: 20M
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
```

可以选参数：

**endpoint_mode**：访问集群服务的方式。

```
endpoint_mode: vip 
# Docker 集群服务一个对外的虚拟 ip。所有的请求都会通过这个虚拟 ip 到达集群服务内部的机器。
endpoint_mode: dnsrr
# DNS 轮询（DNSRR）。所有的请求会自动轮询获取到集群 ip 列表中的一个 ip 地址。
```

**labels**：在服务上设置标签。可以用容器上的 labels（跟 deploy 同级的配置） 覆盖 deploy 下的 labels。

**mode**：指定服务提供的模式。

- **replicated**：复制服务，复制指定服务到集群的机器上。

- **global**：全局服务，服务将部署至集群的每个节点。

- 图解：下图中黄色的方块是 replicated 模式的运行情况，灰色方块是 global 模式的运行情况。

  ![img](https://www.runoob.com/wp-content/uploads/2019/11/docker-composex.png)

**replicas：mode** 为 replicated 时，需要使用此参数配置具体运行的节点数量。

**resources**：配置服务器资源使用的限制，例如上例子，配置 redis 集群运行需要的 cpu 的百分比 和 内存的占用。避免占用资源过高出现异常。

**restart_policy**：配置如何在退出容器时重新启动容器。

- condition：可选 none，on-failure 或者 any（默认值：any）。
- delay：设置多久之后重启（默认值：0）。
- max_attempts：尝试重新启动容器的次数，超出次数，则不再尝试（默认值：一直重试）。
- window：设置容器重启超时时间（默认值：0）。

**rollback_config**：配置在更新失败的情况下应如何回滚服务。

- parallelism：一次要回滚的容器数。如果设置为0，则所有容器将同时回滚。
- delay：每个容器组回滚之间等待的时间（默认为0s）。
- failure_action：如果回滚失败，该怎么办。其中一个 continue 或者 pause（默认pause）。
- monitor：每个容器更新后，持续观察是否失败了的时间 (ns|us|ms|s|m|h)（默认为0s）。
- max_failure_ratio：在回滚期间可以容忍的故障率（默认为0）。
- order：回滚期间的操作顺序。其中一个 stop-first（串行回滚），或者 start-first（并行回滚）（默认 stop-first ）。

**update_config**：配置应如何更新服务，对于配置滚动更新很有用。

- parallelism：一次更新的容器数。
- delay：在更新一组容器之间等待的时间。
- failure_action：如果更新失败，该怎么办。其中一个 continue，rollback 或者pause （默认：pause）。
- monitor：每个容器更新后，持续观察是否失败了的时间 (ns|us|ms|s|m|h)（默认为0s）。
- max_failure_ratio：在更新过程中可以容忍的故障率。
- order：回滚期间的操作顺序。其中一个 stop-first（串行回滚），或者 start-first（并行回滚）（默认stop-first）。

**注**：仅支持 V3.4 及更高版本。

### devices

指定设备映射列表。

```
devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
```

### dns

自定义 DNS 服务器，可以是单个值或列表的多个值。

```
dns: 8.8.8.8

dns:
  - 8.8.8.8
  - 9.9.9.9
```

### dns_search

自定义 DNS 搜索域。可以是单个值或列表。

```
dns_search: example.com

dns_search:
  - dc1.example.com
  - dc2.example.com
```

### entrypoint

覆盖容器默认的 entrypoint。

```
entrypoint: /code/entrypoint.sh
```

也可以是以下格式：

```
entrypoint:
    - php
    - -d
    - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
    - -d
    - memory_limit=-1
    - vendor/bin/phpunit
```

### env_file

从文件添加环境变量。可以是单个值或列表的多个值。

```
env_file: .env
```

也可以是列表格式：

```
env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
```

### environment

添加环境变量。您可以使用数组或字典、任何布尔值，布尔值需要用引号引起来，以确保 YML 解析器不会将其转换为 True 或 False。

```
environment:
  RACK_ENV: development
  SHOW: 'true'
```

### expose

暴露端口，但不映射到宿主机，只被连接的服务访问。

仅可以指定内部端口为参数：

```
expose:
 - "3000"
 - "8000"
```

### extra_hosts

添加主机名映射。类似 docker client --add-host。

```
extra_hosts:
 - "somehost:162.242.195.82"
 - "otherhost:50.31.209.229"
```

以上会在此服务的内部容器中 /etc/hosts 创建一个具有 ip 地址和主机名的映射关系：

```
162.242.195.82  somehost
50.31.209.229   otherhost
```

### healthcheck

用于检测 docker 服务是否健康运行。

```
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"] # 设置检测程序
  interval: 1m30s # 设置检测间隔
  timeout: 10s # 设置检测超时时间
  retries: 3 # 设置重试次数
  start_period: 40s # 启动后，多少秒开始启动检测程序
```

### image

指定容器运行的镜像。以下格式都可以：

```
image: redis
image: ubuntu:14.04
image: tutum/influxdb
image: example-registry.com:4000/postgresql
image: a4bc65fd # 镜像id
```

### logging

服务的日志记录配置。

driver：指定服务容器的日志记录驱动程序，默认值为json-file。有以下三个选项

```
driver: "json-file"
driver: "syslog"
driver: "none"
```

仅在 json-file 驱动程序下，可以使用以下参数，限制日志得数量和大小。

```
logging:
  driver: json-file
  options:
    max-size: "200k" # 单个文件大小为200k
    max-file: "10" # 最多10个文件
```

当达到文件限制上限，会自动删除旧得文件。

syslog 驱动程序下，可以使用 syslog-address 指定日志接收地址。

```
logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.0.42:123"
```

### network_mode

设置网络模式。

```
network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
```

networks

配置容器连接的网络，引用顶级 networks 下的条目 。

```
services:
  some-service:
    networks:
      some-network:
        aliases:
         - alias1
      other-network:
        aliases:
         - alias2
networks:
  some-network:
    # Use a custom driver
    driver: custom-driver-1
  other-network:
    # Use a custom driver which takes special options
    driver: custom-driver-2
```

**aliases** ：同一网络上的其他容器可以使用服务名称或此别名来连接到对应容器的服务。

### restart

- no：是默认的重启策略，在任何情况下都不会重启容器。
- always：容器总是重新启动。
- on-failure：在容器非正常退出时（退出状态非0），才会重启容器。
- unless-stopped：在容器退出时总是重启容器，但是不考虑在Docker守护进程启动时就已经停止了的容器

```
restart: "no"
restart: always
restart: on-failure
restart: unless-stopped
```

注：swarm 集群模式，请改用 restart_policy。

### secrets

存储敏感数据，例如密码：

```
version: "3.1"
services:

mysql:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD_FILE: /run/secrets/my_secret
  secrets:
    - my_secret

secrets:
  my_secret:
    file: ./my_secret.txt
```

### security_opt

修改容器默认的 schema 标签。

```
security-opt：
  - label:user:USER   # 设置容器的用户标签
  - label:role:ROLE   # 设置容器的角色标签
  - label:type:TYPE   # 设置容器的安全策略标签
  - label:level:LEVEL  # 设置容器的安全等级标签
```

### stop_grace_period

指定在容器无法处理 SIGTERM (或者任何 stop_signal 的信号)，等待多久后发送 SIGKILL 信号关闭容器。

```
stop_grace_period: 1s # 等待 1 秒
stop_grace_period: 1m30s # 等待 1 分 30 秒 
```

默认的等待时间是 10 秒。

### stop_signal

设置停止容器的替代信号。默认情况下使用 SIGTERM 。

以下示例，使用 SIGUSR1 替代信号 SIGTERM 来停止容器。

```
stop_signal: SIGUSR1
```

### sysctls

设置容器中的内核参数，可以使用数组或字典格式。

```
sysctls:
  net.core.somaxconn: 1024
  net.ipv4.tcp_syncookies: 0

sysctls:
  - net.core.somaxconn=1024
  - net.ipv4.tcp_syncookies=0
```

### tmpfs

在容器内安装一个临时文件系统。可以是单个值或列表的多个值。

```
tmpfs: /run

tmpfs:
  - /run
  - /tmp
```

### ulimits

覆盖容器默认的 ulimit。

```
ulimits:
  nproc: 65535
  nofile:
    soft: 20000
    hard: 40000
```

### volumes

将主机的数据卷或着文件挂载到容器里。

```
version: "3.7"
services:
  db:
    image: postgres:latest
    volumes:
      - "/localhost/postgres.sock:/var/run/postgres/postgres.sock"
      - "/localhost/data:/var/lib/postgresql/data"
```

## Docker Machine

Docker Machine 是一种可以让您在主机上安装 Docker 的工具，并可以使用 docker-machine 命令来管理主机。主机可以是物理机或虚拟机。

Docker Machine 也可以集中管理所有的 docker 主机，比如快速的给 100 台服务器安装上 docker。

![img](../../../../Image/d/docker_machine_logo.jpg)

使用 docker-machine 命令，您可以启动，检查，停止和重新启动托管主机，也可以升级 Docker 客户端和守护程序，以及配置 Docker 客户端与您的主机进行通信。

![img](../../../../Image/d/docker_machine.jpg)

支持环境：

* 常规Linux操作系统。
* 虚拟化平台 --- VirtualBox   VMWare  Hyper-V  OpenStack
* 公有云 --- Amazon Web Services 、Microsoft Azure 、Google Compute Engine 、 Digital Ocean 等

Docker Machine 为这些环境起了一个统一的名称：provider。对于某个特定的 provider ，Docker Machine 使用对应的 driver 安装和配置 docker host 。

Machine 就是 运行 docker daemon 的主机。

### 安装

安装 Docker Machine 之前需要先安装 Docker。

Docker Machine 可以在多种平台上安装使用，包括 Linux 、MacOS 以及 windows。

#### Linux 安装命令

```bash
base=https://github.com/docker/machine/releases/download/v0.16.0
curl -L $base/docker-machine-$(uname -s)-$(uname -m) > /tmp/docker-machine
mv /tmp/docker-machine /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
```

#### macOS 安装命令

```bash
base=https://github.com/docker/machine/releases/download/v0.16.0
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
```

#### Windows 安装命令

```bash
# Git bash
base=https://github.com/docker/machine/releases/download/v0.16.0
mkdir -p "$HOME/bin"
curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe"
chmod +x "$HOME/bin/docker-machine.exe"
```

查看是否安装成功：

```bash
docker-machine version
```

### 命令

- **docker-machine active**：查看当前激活状态的 Docker 主机。

  ```bash
  docker-machine ls
  
  NAME      ACTIVE   DRIVER         STATE     URL
  dev       -        virtualbox     Running   tcp://192.168.99.103:2376
  staging   *        digitalocean   Running   tcp://203.0.113.81:2376
  
  echo $DOCKER_HOST
  tcp://203.0.113.81:2376
  
  docker-machine active
  staging
  ```

- **config**：查看当前激活状态 Docker 主机的连接信息。

  ```bash
  docker-machine config host1
  ```

- **create**：创建 Docker 主机

  ```bash
  # 创建一台名为 test 的机器。
  docker-machine create --driver generic --generic-ip-address=192.168.16.104 test
  
  --driver：指定用来创建机器的驱动类型。[ generic | virtualbox ]
  --generic-ip-address：指定目标系统的IP
  ```

- **env**：显示连接到某个主机需要的环境变量

  ```bash
  docker-machine env host1
  # 切换到远程主机
  eval $(docker-machine env host1)
  ```

- **inspect**：	以 json 格式输出指定Docker的详细信息

- **ip**：	获取指定 Docker 主机的地址

  ```bash
  docker-machine ip host
  ```

- **kill**：	直接杀死指定的 Docker 主机

- **ls**：	列出所有的管理主机

  ```bash
  docker-machine ls
  
  NAME	ACTIVE	DRIVER	STATE	URL	SWARM	DOCKER	ERRORS
  ```

- **provision**：	重新配置指定主机

- **regenerate-certs**：	为某个主机重新生成 TLS 信息

- **restart**：	重启指定的主机

- **rm**：	删除某台 Docker 主机，对应的虚拟机也会被删除

- **ssh**：	通过 SSH 连接到主机上，执行命令

  ```bash
  docker-machine ssh test
  ```

- **scp**：	在 Docker 主机之间以及 Docker 主机和本地主机之间通过 scp 远程复制数据

  ```bash
  docker-machine scp host1:/tmp/a host2:/tmp/b
  ```

- **mount**：	使用 SSHFS 从计算机装载或卸载目录

- **start**：	启动一个指定的 Docker 主机，如果对象是个虚拟机，该虚拟机将被启动

  ```bash
  docker-machine start test
  ```

- **status**：	获取指定 Docker 主机的状态(包括：Running、Paused、Saved、Stopped、Stopping、Starting、Error)等

- **stop**：	停止一个指定的 Docker 主机

  ```bash
  docker-machine stop test
  ```

- **upgrade**：	将一个指定主机的 Docker 版本更新为最新

  ```bash
  docker-machine upgrade <host1> <host2>
  ```

- **url**：	获取指定 Docker 主机的监听 URL

- **version**：	显示 Docker Machine 的版本或者主机 Docker 版本

- **help**：	显示帮助信息

# Swarm 集群管理

### 简介

Docker Swarm 是 Docker 的集群管理工具。它将 Docker 主机池转变为单个虚拟 Docker 主机。 Docker  Swarm 提供了标准的 Docker API，所有任何已经与 Docker 守护程序通信的工具都可以使用 Swarm 轻松地扩展到多个主机。

支持的工具包括但不限于以下各项：

- Dokku
- Docker Compose
- Docker Machine
- Jenkins

### 原理

如下图所示，swarm 集群由管理节点（manager）和工作节点（work node）构成。

- **swarm mananger**：负责整个集群的管理工作包括集群配置、服务管理等所有跟集群有关的工作。
- **work node**：即图中的 available node，主要负责运行相应的服务来执行任务（task）。

[![img](https://www.runoob.com/wp-content/uploads/2019/11/services-diagram.png)](https://www.runoob.com/wp-content/uploads/2019/11/services-diagram.png)

------

## 使用

以下示例，均以 Docker Machine 和 virtualbox 进行介绍，确保你的主机已安装 virtualbox。

### 1、创建 swarm 集群管理节点（manager）

创建 docker 机器：

```
$ docker-machine create -d virtualbox swarm-manager
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm1.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm1.png)

初始化 swarm 集群，进行初始化的这台机器，就是集群的管理节点。

```
$ docker-machine ssh swarm-manager
$ docker swarm init --advertise-addr 192.168.99.107 #这里的 IP 为创建机器时分配的 ip。
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm2.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm2.png)

以上输出，证明已经初始化成功。需要把以下这行复制出来，在增加工作节点时会用到：

```
docker swarm join --token SWMTKN-1-4oogo9qziq768dma0uh3j0z0m5twlm10iynvz7ixza96k6jh9p-ajkb6w7qd06y1e33yrgko64sk 192.168.99.107:2377
```

### 2、创建 swarm 集群工作节点（worker）

这里直接创建好俩台机器，swarm-worker1 和 swarm-worker2 。

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm3.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm3.png)

分别进入两个机器里，指定添加至上一步中创建的集群，这里会用到上一步复制的内容。

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm4.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm4.png)

以上数据输出说明已经添加成功。

上图中，由于上一步复制的内容比较长，会被自动截断，实际上在图运行的命令如下：

```
docker@swarm-worker1:~$ docker swarm join --token SWMTKN-1-4oogo9qziq768dma0uh3j0z0m5twlm10iynvz7ixza96k6jh9p-ajkb6w7qd06y1e33yrgko64sk 192.168.99.107:2377
```

### 3、查看集群信息

进入管理节点，执行：docker info 可以查看当前集群的信息。

```
$ docker info
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm5.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm5.png)

通过画红圈的地方，可以知道当前运行的集群中，有三个节点，其中有一个是管理节点。

### 4、部署服务到集群中

**注意**：跟集群管理有关的任何操作，都是在管理节点上操作的。

以下例子，在一个工作节点上创建一个名为 helloworld 的服务，这里是随机指派给一个工作节点：

```
docker@swarm-manager:~$ docker service create --replicas 1 --name helloworld alpine ping docker.com
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm6.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm6.png)

### 5、查看服务部署情况

查看 helloworld 服务运行在哪个节点上，可以看到目前是在 swarm-worker1 节点：

```
docker@swarm-manager:~$ docker service ps helloworld
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm7.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm7.png)

查看 helloworld 部署的具体信息：

```
docker@swarm-manager:~$ docker service inspect --pretty helloworld
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm8.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm8.png)

### 6、扩展集群服务

我们将上述的 helloworld 服务扩展到俩个节点。

```
docker@swarm-manager:~$ docker service scale helloworld=2
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm9.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm9.png)

可以看到已经从一个节点，扩展到两个节点。

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm10.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm10.png)

### 7、删除服务

```
docker@swarm-manager:~$ docker service rm helloworld
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm11.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm11.png)

查看是否已删除：

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm12.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm12.png)

### 8、滚动升级服务

以下实例，我们将介绍 redis 版本如何滚动升级至更高版本。

创建一个 3.0.6 版本的 redis。

```
docker@swarm-manager:~$ docker service create --replicas 1 --name redis --update-delay 10s redis:3.0.6
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm13.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm13.png)

滚动升级 redis 。

```
docker@swarm-manager:~$ docker service update --image redis:3.0.7 redis
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm14.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm14.png)

看图可以知道 redis 的版本已经从 3.0.6 升级到了 3.0.7，说明服务已经升级成功。

### 9、停止某个节点接收新的任务

查看所有的节点：

```
docker@swarm-manager:~$ docker node ls
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm16.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm16.png)

可以看到目前所有的节点都是 Active, 可以接收新的任务分配。

停止节点 swarm-worker1：

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm17.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm17.png)

**注意**：swarm-worker1 状态变为 Drain。不会影响到集群的服务，只是 swarm-worker1 节点不再接收新的任务，集群的负载能力有所下降。

可以通过以下命令重新激活节点：

```
docker@swarm-manager:~$  docker node update --availability active swarm-worker1
```

[![img](https://www.runoob.com/wp-content/uploads/2019/11/swarm19.png)](https://www.runoob.com/wp-content/uploads/2019/11/swarm19.png)

 [Docker Machine ](https://www.runoob.com/docker/docker-machine.html) 

[Docker 安装 Ubuntu ](https://www.runoob.com/docker/docker-install-ubuntu.html) 



## 实例

## 安装 PHP 镜像

### 方法一、docker pull php

查找 [Docker Hub](https://hub.docker.com/_/php?tab=tags) 上的 php 镜像:

[![img](https://www.runoob.com/wp-content/uploads/2016/06/0D34717D-1D07-4655-8559-A8661BCB4A3D.jpg)](https://www.runoob.com/wp-content/uploads/2016/06/0D34717D-1D07-4655-8559-A8661BCB4A3D.jpg)

可以通过 Sort by 查看其他版本的 php，默认是最新版本 **php:latest**。

此外，我们还可以用 docker search php 命令来查看可用版本：

```
runoob@runoob:~/php-fpm$ docker search php
NAME                      DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
php                       While designed for web development, the PH...   1232      [OK]       
richarvey/nginx-php-fpm   Container running Nginx + PHP-FPM capable ...   207                  [OK]
phpmyadmin/phpmyadmin     A web interface for MySQL and MariaDB.          123                  [OK]
eboraas/apache-php        PHP5 on Apache (with SSL support), built o...   69                   [OK]
php-zendserver            Zend Server - the integrated PHP applicati...   69        [OK]       
million12/nginx-php       Nginx + PHP-FPM 5.5, 5.6, 7.0 (NG), CentOS...   67                   [OK]
webdevops/php-nginx       Nginx with PHP-FPM                              39                   [OK]
webdevops/php-apache      Apache with PHP-FPM (based on webdevops/php)    14                   [OK]
phpunit/phpunit           PHPUnit is a programmer-oriented testing f...   14                   [OK]
tetraweb/php              PHP 5.3, 5.4, 5.5, 5.6, 7.0 for CI and run...   12                   [OK]
webdevops/php             PHP (FPM and CLI) service container             10                   [OK]
...
```

这里我们拉取官方的镜像,标签为5.6-fpm

```
runoob@runoob:~/php-fpm$ docker pull php:5.6-fpm
```

等待下载完成后，我们就可以在本地镜像列表里查到REPOSITORY为php,标签为5.6-fpm的镜像。

```
runoob@runoob:~/php-fpm$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
php                 5.6-fpm             025041cd3aa5        6 days ago          456.3 MB
```

------

## Nginx + PHP  部署

Nginx 部署可以查看：[Docker 安装 Nginx](https://www.runoob.com/docker/docker-install-nginx.html)，一些 Nginx 的配置参考这篇文章。

启动  PHP：

```
$ docker run --name  myphp-fpm -v ~/nginx/www:/www  -d php:5.6-fpm
```

命令说明：

- **--name  myphp-fpm** : 将容器命名为 myphp-fpm。
- **-v ~/nginx/www:/www** : 将主机中项目的目录 www 挂载到容器的 /www

创建  ~/nginx/conf/conf.d 目录：

```
mkdir ~/nginx/conf/conf.d 
```

在该目录下添加 **~/nginx/conf/conf.d/runoob-test-php.conf** 文件，内容如下：

```
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm index.php;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /www/$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

配置文件说明：

- **php:9000**: 表示 php-fpm 服务的 URL，下面我们会具体说明。
-  **/www/**: 是 **myphp-fpm** 中 php 文件的存储路径，映射到本地的 ~/nginx/www 目录。

启动 nginx：

```
docker run --name runoob-php-nginx -p 8083:80 -d \
    -v ~/nginx/www:/usr/share/nginx/html:ro \
    -v ~/nginx/conf/conf.d:/etc/nginx/conf.d:ro \
    --link myphp-fpm:php \
    nginx
```

- **-p 8083:80**: 端口映射，把 **nginx** 中的 80 映射到本地的 8083 端口。
- **~/nginx/www**: 是本地 html 文件的存储目录，/usr/share/nginx/html 是容器内 html 文件的存储目录。
- **~/nginx/conf/conf.d**: 是本地 nginx 配置文件的存储目录，/etc/nginx/conf.d 是容器内 nginx 配置文件的存储目录。
- **--link myphp-fpm:php**: 把 **myphp-fpm** 的网络并入 ***nginx\***，并通过修改 **nginx** 的 /etc/hosts，把域名 **php** 映射成 127.0.0.1，让 nginx 通过 php:9000 访问 php-fpm。

接下来我们在 ~/nginx/www 目录下创建 index.php，代码如下：

```
<?php
echo phpinfo();
?>
```

浏览器打开 **http://127.0.0.1:8083/index.php**，显示如下：

![img](https://www.runoob.com/wp-content/uploads/2016/06/4CA3D4DE-3883-449C-B2F2-7C80D9A5B384.jpg)



**Docker 配置 nginx、php-fpm、mysql**

**运行环境**

![img](https://www.runoob.com/wp-content/uploads/2018/08/1535703280-4104-20170715125030384-1014271798.png)

**创建目录**

```
mkdir -p /Users/sui/docker/nginx/conf.d && mkdir /Users/sui/www &&  cd /Users/sui/docker/nginx/conf.d && sudo touch default.conf
```

**启动 php-fpm**

解释执行 php 需要 php-fpm，先让它运行起来：

```
docker run --name sui-php -d \
    -v /Users/sui/www:/var/www/html:ro \
    php:7.1-fpm
```

--name sui-php 是容器的名字。

/Users/sui/www 是本地 php 文件的存储目录，/var/www/html 是容器内 php 文件的存储目录，ro 表示只读。

**编辑 nginx 配置文件**

配置文件位置：/Users/sui/docker/nginx/conf.d/default.conf。

```
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /var/www/html/$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

说明：

- php:9000 表示 php-fpm 服务的访问路径，下文还会提及。
- /var/www/html 是 sui***-php\*** 中 php 文件的存储路径，经 docker 映射，变成本地路径 /Users/sui/www（可以再看一眼 php-fpm 启动命令

启动 nginx:

```
docker run --name sui-nginx -p 80:80 -d \
    -v /Users/sui/www:/usr/share/nginx/html:ro \
    -v /Users/sui/docker/nginx/conf.d:/etc/nginx/conf.d:ro \
    --link sui-php:php \
    nginx
```

- -p 80:80 用于添加端口映射，把 ***sui-nginx\*** 中的 80 端口暴露出来。
- /Users/sui/www 是本地 html 文件的存储目录，/usr/share/nginx/html 是容器内 html 文件的存储目录。
- /Users/sui/docker/nginx/conf.d 是本地 nginx 配置文件的存储目录，/etc/nginx/conf.d 是容器内 nginx 配置文件的存储目录。
- --link sui-php:php 把 ***sui-php\*** 的网络并入 ***sui-nginx\***，并通过修改 ***sui-nginx\*** 的 /etc/hosts，把域名 ***php\*** 映射成 127.0.0.1，让 nginx 通过 php:9000 访问 php-fpm。

![img](https://www.runoob.com/wp-content/uploads/2018/08/1036583-20170715131816337-108470072.png)

**测试结果**

在 /Users/sui/www 下放两个文件：index.html index.php

![img](https://www.runoob.com/wp-content/uploads/2018/08/1036583-20170715132145759-1925306861.png)

**mysql 和 phpmyadmin**

mysql 服务器

```
sudo mkdir -p /Users/sui/docker/mysql/data /Users/sui/docker/mysql/logs /Users/sui/docker/mysql/conf
```

- data 目录将映射为 mysql 容器配置的数据文件存放路径
- logs 目录将映射为 mysql 容器的日志目录
- conf 目录里的配置文件将映射为 mysql 容器的配置文件

```
docker run -p 3307:3306 --name sui-mysql -v /Users/sui/docker/mysql/conf:/etc/mysql -v /Users/sui/docker/mysql/logs:/logs -v /Users/sui/docker/mysql/data:/mysql_data -e MYSQL_ROOT_PASSWORD=123456 -d --link sui-php mysql
```

进入mysql客户端:

```
docker run -it --link sui-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

注意：我本地 3306 端口有 mysql, 所以这里用3307端口。

![img](https://www.runoob.com/wp-content/uploads/2018/08/1036583-20170715143730290-1337674791.png)

**phpmyadmin**

```
docker run --name sui-myadmin -d --link sui-mysql:db -p 8080:80 phpmyadmin/phpmyadmin
```

![img](https://www.runoob.com/wp-content/uploads/2018/08/1036583-20170715144105462-703943679.png)

 大功告成:

![img](https://www.runoob.com/wp-content/uploads/2018/08/1535703283-3466-20170715144243790-455471563.png)

[pengqiangsheng](https://www.runoob.com/note/34619)  pengqiangsheng 294***2136@qq.com [ 参考地址](https://www.cnblogs.com/boundless-sky/p/7182410.html?utm_source=itdadao&utm_medium=referral)3年前 (2018-08-31)

​			

  	 	  

​		

# Docker 安装 MySQL

MySQL 是世界上最受欢迎的开源数据库。凭借其可靠性、易用性和性能，MySQL 已成为 Web 应用程序的数据库优先选择。

### 1、查看可用的 MySQL 版本

访问 MySQL 镜像库地址：https://hub.docker.com/_/mysql?tab=tags 。

可以通过 Sort by 查看其他版本的 MySQL，默认是最新版本 **mysql:latest** 。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql1.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql1.png)

你也可以在下拉列表中找到其他你想要的版本：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql2.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql2.png)

此外，我们还可以用  docker search mysql 命令来查看可用版本：

```
$ docker search mysql
NAME                     DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mysql                    MySQL is a widely used, open-source relati...   2529      [OK]       
mysql/mysql-server       Optimized MySQL Server Docker images. Crea...   161                  [OK]
centurylink/mysql        Image containing mysql. Optimized to be li...   45                   [OK]
sameersbn/mysql                                                          36                   [OK]
google/mysql             MySQL server for Google Compute Engine          16                   [OK]
appcontainers/mysql      Centos/Debian Based Customizable MySQL Con...   8                    [OK]
marvambass/mysql         MySQL Server based on Ubuntu 14.04              6                    [OK]
drupaldocker/mysql       MySQL for Drupal                                2                    [OK]
azukiapp/mysql           Docker image to run MySQL by Azuki - http:...   2                    [OK]
...
```

### 2、拉取 MySQL 镜像

这里我们拉取官方的最新版本的镜像：

```
$ docker pull mysql:latest
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql3.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql3.png)

### 3、查看本地镜像

使用以下命令来查看是否已安装了 mysql：

```
$ docker images
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql6.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql6.png)

在上图中可以看到我们已经安装了最新版本（latest）的 mysql 镜像。

### 4、运行容器

安装完成后，我们可以使用以下命令来运行 mysql 容器：

```
$ docker run -itd --name mysql-test -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql
```

参数说明：

- **-p 3306:3306** ：映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 宿主机ip:3306 访问到 MySQL 的服务。
- **MYSQL_ROOT_PASSWORD=123456**：设置 MySQL 服务 root 用户的密码。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql4.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql4.png)

### 5、安装成功

通过 docker ps 命令查看是否安装成功：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql5.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql5.png)

本机可以通过 root 和密码 123456 访问 MySQL 服务。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql7.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mysql7.png)

 [Docker 安装 PHP](https://www.runoob.com/docker/docker-install-php.html) 

[Docker 安装 Tomcat](https://www.runoob.com/docker/docker-install-tomcat.html) 

##      	    	    	        2  篇笔记   写笔记    

1. 

     Brian

    153***2799@qq.com

    97

   最新官方MySQL(5.7.19)的docker镜像在创建时映射的配置文件目录有所不同，在此记录并分享给大家：

   官方原文：

   The MySQL startup configuration is specified in the file `/etc/mysql/my.cnf`, and that file in turn includes any files found in the `/etc/mysql/conf.d` directory that end with `.cnf`. Settings in files in this directory will augment and/or override settings in `/etc/mysql/my.cnf`. If you want to use a customized MySQL configuration, you can create  your alternative configuration file in a directory on the host machine  and then mount that directory location as `/etc/mysql/conf.d` inside the `mysql` container.

   大概意思是说：

   MySQL(5.7.19)的默认配置文件是 /etc/mysql/my.cnf 文件。如果想要自定义配置，建议向 /etc/mysql/conf.d 目录中创建 .cnf  文件。新建的文件可以任意起名，只要保证后缀名是 cnf 即可。新建的文件中的配置项可以覆盖 /etc/mysql/my.cnf 中的配置项。

   具体操作：

   首先需要创建将要映射到容器中的目录以及.cnf文件，然后再创建容器

   ```
   # pwd
   /opt
   # mkdir -p docker_v/mysql/conf
   # cd docker_v/mysql/conf
   # touch my.cnf
   # docker run -p 3306:3306 --name mysql -v /opt/docker_v/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456 -d imageID
   4ec4f56455ea2d6d7251a05b7f308e314051fdad2c26bf3d0f27a9b0c0a71414
   ```

   命令说明：

   - **-p 3306:3306：**将容器的3306端口映射到主机的3306端口
   - **-v /opt/docker_v/mysql/conf:/etc/mysql/conf.d：**将主机/opt/docker_v/mysql/conf目录挂载到容器的/etc/mysql/conf.d
   - **-e MYSQL_ROOT_PASSWORD=123456：**初始化root用户的密码
   - **-d:** 后台运行容器，并返回容器ID
   - **imageID:** mysql镜像ID

   **查看容器运行情况**

   ```
   # docker ps
   CONTAINER ID IMAGE          COMMAND          ... PORTS                    NAMES
   4ec4f56455ea c73c7527c03a  "docker-entrypoint.sh" ... 0.0.0.0:3306->3306/tcp   mysql
   ```

   [Brian](javascript:;)  Brian 153***2799@qq.com4年前 (2017-09-08)

2. 

     liaozesong

    lia***song@yeah.net

    [ 参考地址](http://note.youdao.com/groupshare/?token=AE9F46916C444460B4B4F7F591727871&gid=80144203)

    182

   **docker 安装 mysql 8 版本**

   ```
   # docker 中下载 mysql
   docker pull mysql
   
   #启动
   docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Lzslov123! -d mysql
   
   #进入容器
   docker exec -it mysql bash
   
   #登录mysql
   mysql -u root -p
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'Lzslov123!';
   
   #添加远程登录用户
   CREATE USER 'liaozesong'@'%' IDENTIFIED WITH mysql_native_password BY 'Lzslov123!';
   GRANT ALL PRIVILEGES ON *.* TO 'liaozesong'@'%';
   ```

   [liaozesong](https://www.runoob.com/note/33381)  liaozesong lia***song@yeah.net [ 参考地址](http://note.youdao.com/groupshare/?token=AE9F46916C444460B4B4F7F591727871&gid=80144203)3年前 (2018-07-30)

# Docker 安装 Tomcat

### 方法一、docker pull tomcat

查找 [Docker Hub](https://hub.docker.com/_/tomcat?tab=tags) 上的 Tomcat 镜像:

[![img](https://www.runoob.com/wp-content/uploads/2016/06/F5FE5252-6FD3-4DE3-880B-808477E45676.jpg)](https://www.runoob.com/wp-content/uploads/2016/06/F5FE5252-6FD3-4DE3-880B-808477E45676.jpg)

可以通过 Sort by 查看其他版本的 tomcat，默认是最新版本 **tomcat:latest**。

此外，我们还可以用 docker search tomcat 命令来查看可用版本：

```
runoob@runoob:~/tomcat$ docker search tomcat
NAME                       DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
tomcat                     Apache Tomcat is an open source implementa...   744       [OK]       
dordoka/tomcat             Ubuntu 14.04, Oracle JDK 8 and Tomcat 8 ba...   19                   [OK]
consol/tomcat-7.0          Tomcat 7.0.57, 8080, "admin/admin"              16                   [OK]
consol/tomcat-8.0          Tomcat 8.0.15, 8080, "admin/admin"              14                   [OK]
cloudesire/tomcat          Tomcat server, 6/7/8                            8                    [OK]
davidcaste/alpine-tomcat   Apache Tomcat 7/8 using Oracle Java 7/8 wi...   6                    [OK]
andreptb/tomcat            Debian Jessie based image with Apache Tomc...   4                    [OK]
kieker/tomcat                                                              2                    [OK]
fbrx/tomcat                Minimal Tomcat image based on Alpine Linux      2                    [OK]
jtech/tomcat               Latest Tomcat production distribution on l...   1                    [OK]
```

这里我们拉取官方的镜像：

```
runoob@runoob:~/tomcat$ docker pull tomcat
```

等待下载完成后，我们就可以在本地镜像列表里查到 REPOSITORY 为 tomcat 的镜像。

```
runoob@runoob:~/tomcat$ docker images|grep tomcat
tomcat              latest              70f819d3d2d9        7 days ago          335.8 MB
```

### 方法二、通过 Dockerfile 构建

创建Dockerfile

首先，创建目录tomcat,用于存放后面的相关东西。

```
runoob@runoob:~$ mkdir -p ~/tomcat/webapps ~/tomcat/logs ~/tomcat/conf
```

webapps 目录将映射为 tomcat 容器配置的应用程序目录。

logs 目录将映射为 tomcat 容器的日志目录。

conf 目录里的配置文件将映射为 tomcat 容器的配置文件。

进入创建的 tomcat 目录，创建 Dockerfile。

```
FROM openjdk:8-jre

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# runtime dependencies for Tomcat Native Libraries
# Tomcat Native 1.2+ requires a newer version of OpenSSL than debian:jessie has available
# > checking OpenSSL library version >= 1.0.2...
# > configure: error: Your version of OpenSSL is not compatible with this version of tcnative
# see http://tomcat.10.x6.nabble.com/VOTE-Release-Apache-Tomcat-8-0-32-tp5046007p5046024.html (and following discussion)
# and https://github.com/docker-library/tomcat/pull/31
ENV OPENSSL_VERSION 1.1.0f-3+deb9u2
RUN set -ex; \
    currentVersion="$(dpkg-query --show --showformat '${Version}\n' openssl)"; \
    if dpkg --compare-versions "$currentVersion" '<<' "$OPENSSL_VERSION"; then \
        if ! grep -q stretch /etc/apt/sources.list; then \
# only add stretch if we're not already building from within stretch
            { \
                echo 'deb http://deb.debian.org/debian stretch main'; \
                echo 'deb http://security.debian.org stretch/updates main'; \
                echo 'deb http://deb.debian.org/debian stretch-updates main'; \
            } > /etc/apt/sources.list.d/stretch.list; \
            { \
# add a negative "Pin-Priority" so that we never ever get packages from stretch unless we explicitly request them
                echo 'Package: *'; \
                echo 'Pin: release n=stretch*'; \
                echo 'Pin-Priority: -10'; \
                echo; \
# ... except OpenSSL, which is the reason we're here
                echo 'Package: openssl libssl*'; \
                echo "Pin: version $OPENSSL_VERSION"; \
                echo 'Pin-Priority: 990'; \
            } > /etc/apt/preferences.d/stretch-openssl; \
        fi; \
        apt-get update; \
        apt-get install -y --no-install-recommends openssl="$OPENSSL_VERSION"; \
        rm -rf /var/lib/apt/lists/*; \
    fi

RUN apt-get update && apt-get install -y --no-install-recommends \
        libapr1 \
    && rm -rf /var/lib/apt/lists/*

# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "update.sh" (https://github.com/docker-library/tomcat/blob/master/update.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.32
ENV TOMCAT_SHA512 fc010f4643cb9996cad3812594190564d0a30be717f659110211414faf8063c61fad1f18134154084ad3ddfbbbdb352fa6686a28fbb6402d3207d4e0a88fa9ce

ENV TOMCAT_TGZ_URLS \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
    https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
# if the version is outdated, we might have to pull from the dist/archive :/
    https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV TOMCAT_ASC_URLS \
    https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
# not all the mirrors actually carry the .asc files :'(
    https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
    https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
    https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc

RUN set -eux; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    \
    apt-get install -y --no-install-recommends gnupg dirmngr; \
    \
    export GNUPGHOME="$(mktemp -d)"; \
    for key in $GPG_KEYS; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done; \
    \
    apt-get install -y --no-install-recommends wget ca-certificates; \
    \
    success=; \
    for url in $TOMCAT_TGZ_URLS; do \
        if wget -O tomcat.tar.gz "$url"; then \
            success=1; \
            break; \
        fi; \
    done; \
    [ -n "$success" ]; \
    \
    echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum -c -; \
    \
    success=; \
    for url in $TOMCAT_ASC_URLS; do \
        if wget -O tomcat.tar.gz.asc "$url"; then \
            success=1; \
            break; \
        fi; \
    done; \
    [ -n "$success" ]; \
    \
    gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz; \
    tar -xvf tomcat.tar.gz --strip-components=1; \
    rm bin/*.bat; \
    rm tomcat.tar.gz*; \
    rm -rf "$GNUPGHOME"; \
    \
    nativeBuildDir="$(mktemp -d)"; \
    tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
    apt-get install -y --no-install-recommends \
        dpkg-dev \
        gcc \
        libapr1-dev \
        libssl-dev \
        make \
        "openjdk-${JAVA_VERSION%%[.~bu-]*}-jdk=$JAVA_DEBIAN_VERSION" \
    ; \
    ( \
        export CATALINA_HOME="$PWD"; \
        cd "$nativeBuildDir/native"; \
        gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
        ./configure \
            --build="$gnuArch" \
            --libdir="$TOMCAT_NATIVE_LIBDIR" \
            --prefix="$CATALINA_HOME" \
            --with-apr="$(which apr-1-config)" \
            --with-java-home="$(docker-java-home)" \
            --with-ssl=yes; \
        make -j "$(nproc)"; \
        make install; \
    ); \
    rm -rf "$nativeBuildDir"; \
    rm bin/tomcat-native.tar.gz; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    \
# sh removes env vars it doesn't support (ones with periods)
# https://github.com/docker-library/tomcat/issues/77
    find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +

# verify Tomcat Native is working properly
RUN set -e \
    && nativeLines="$(catalina.sh configtest 2>&1)" \
    && nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" \
    && nativeLines="$(echo "$nativeLines" | sort -u)" \
    && if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
        echo >&2 "$nativeLines"; \
        exit 1; \
    fi

EXPOSE 8080
CMD ["catalina.sh", "run"]
```

通过 Dockerfile 创建一个镜像，替换成你自己的名字：

```
runoob@runoob:~/tomcat$ docker build -t tomcat .
```

创建完成后，我们可以在本地的镜像列表里查找到刚刚创建的镜像：

```
runoob@runoob:~/tomcat$ docker images|grep tomcat
tomcat              latest              70f819d3d2d9        7 days ago          335.8 MB
```

------

## 使用 tomcat 镜像

### 运行容器

```
runoob@runoob:~/tomcat$ docker run --name tomcat -p 8080:8080 -v $PWD/test:/usr/local/tomcat/webapps/test -d tomcat  
acb33fcb4beb8d7f1ebace6f50f5fc204b1dbe9d524881267aa715c61cf75320
runoob@runoob:~/tomcat$
```

命令说明：

**-p 8080:8080：**将主机的 8080 端口映射到容器的 8080 端口。

**-v $PWD/test:/usr/local/tomcat/webapps/test：**将主机中当前目录下的 test 挂载到容器的 /test。

查看容器启动情况

```
runoob@runoob:~/tomcat$ docker ps 
CONTAINER ID    IMAGE     COMMAND               ... PORTS                    NAMES
acb33fcb4beb    tomcat    "catalina.sh run"     ... 0.0.0.0:8080->8080/tcp   tomcat
```

通过浏览器访问

![img](https://www.runoob.com/wp-content/uploads/2016/06/tomcat01.png)

 [Docker 安装 MySQL](https://www.runoob.com/docker/docker-install-mysql.html) 

[Docker 安装](https://www.runoob.com/docker/docker-install-python.html)

# Docker 安装 Python

------

## 方法一、docker pull python:3.5 查找 [Docker Hub](https://hub.docker.com/_/python?tab=tags) 上的 Python 镜像: [![img](https://www.runoob.com/wp-content/uploads/2016/06/B32A6862-3599-4B41-A8EA-05A361000865.jpg)](https://www.runoob.com/wp-content/uploads/2016/06/B32A6862-3599-4B41-A8EA-05A361000865.jpg) 可以通过 Sort by 查看其他版本的 python，默认是最新版本 **python:lastest**。 此外，我们还可以用 docker search python 命令来查看可用版本：

```bash
runoob@runoob:~/python$ docker search python NAME                           DESCRIPTION                        STARS     OFFICIAL   AUTOMATED python                         Python is an interpreted,...       982       [OK]        kaggle/python                  Docker image for Python...         33                   [OK] azukiapp/python                Docker image to run Python ...     3                    [OK] vimagick/python                mini python                                  2          [OK] tsuru/python                   Image for the Python ...           2                    [OK] pandada8/alpine-python         An alpine based python image                 1          [OK] 1science/python                Python Docker images based on ...  1                    [OK] lucidfrontier45/python-uwsgi   Python with uWSGI                  1                    [OK] orbweb/python                  Python image                       1                    [OK] pathwar/python                 Python template for Pathwar levels 1                    [OK] rounds/10m-python              Python, setuptools and pip.        0                    [OK] ruimashita/python              ubuntu 14.04 python                0                    [OK] tnanba/python                  Python on CentOS-7 image.          0                    [OK]` 这里我们拉取官方的镜像,标签为3.5 `runoob@runoob:~/python$ docker pull python:3.5` 等待下载完成后，我们就可以在本地镜像列表里查到 REPOSITORY 为python, 标签为 3.5 的镜像。 `runoob@runoob:~/python$ docker images python:3.5  REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE python              3.5              045767ddf24a        9 days ago          684.1 MB` 方法二、通过 Dockerfile 构建 **创建 Dockerfile<**/p> 首先，创建目录 python，用于存放后面的相关东西。 `runoob@runoob:~$ mkdir -p ~/python ~/python/myapp` myapp 目录将映射为 python 容器配置的应用目录。 进入创建的 python 目录，创建 Dockerfile。 `FROM buildpack-deps:jessie # remove several traces of debian python RUN apt-get purge -y python.* # http://bugs.python.org/issue19846 # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK. ENV LANG C.UTF-8 # gpg: key F73C700D: public key "Larry Hastings <larry@hastings.org>" imported ENV GPG_KEY 97FC712E4C024BBEA48A61ED3A5CA953F73C700D ENV PYTHON_VERSION 3.5.1 # if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'" ENV PYTHON_PIP_VERSION 8.1.2 RUN set -ex \        && curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \        && curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \        && export GNUPGHOME="$(mktemp -d)" \        && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \        && gpg --batch --verify python.tar.xz.asc python.tar.xz \        && rm -r "$GNUPGHOME" python.tar.xz.asc \        && mkdir -p /usr/src/python \        && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \        && rm python.tar.xz \        \        && cd /usr/src/python \        && ./configure --enable-shared --enable-unicode=ucs4 \        && make -j$(nproc) \        && make install \        && ldconfig \        && pip3 install --no-cache-dir --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION \        && find /usr/local -depth \                \( \                    \( -type d -a -name test -o -name tests \) \                    -o \                    \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \                \) -exec rm -rf '{}' + \        && rm -rf /usr/src/python ~/.cache # make some useful symlinks that are expected to exist RUN cd /usr/local/bin \        && ln -s easy_install-3.5 easy_install \        && ln -s idle3 idle \        && ln -s pydoc3 pydoc \        && ln -s python3 python \        && ln -s python3-config python-config CMD ["python3"]` 通过 Dockerfile 创建一个镜像，替换成你自己的名字： `runoob@runoob:~/python$ docker build -t python:3.5 .` 创建完成后，我们可以在本地的镜像列表里查找到刚刚创建的镜像： `runoob@runoob:~/python$ docker images python:3.5  REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE python              3.5              045767ddf24a        9 days ago          684.1 MB`  使用 python 镜像 在 ~/python/myapp 目录下创建一个 helloworld.py 文件，代码如下： `#!/usr/bin/python print("Hello, World!");` 运行容器 `runoob@runoob:~/python$ docker run  -v $PWD/myapp:/usr/src/myapp  -w /usr/src/myapp python:3.5 python helloworld.py` 命令说明： **-v $PWD/myapp:/usr/src/myapp:** 将主机中当前目录下的 myapp 挂载到容器的 /usr/src/myapp。 **-w /usr/src/myapp:**  指定容器的 /usr/src/myapp 目录为工作目录。 **python helloworld.py:** 使用容器的 python 命令来执行工作目录中的 helloworld.py 文件。 输出结果： `Hello, World!		 					 	
```

##  	

# Docker 安装 Redis

Redis 是一个开源的使用 ANSI C 语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value 的 NoSQL 数据库，并提供多种语言的 API。

### 1、查看可用的 Redis 版本

访问 Redis 镜像库地址： https://hub.docker.com/_/redis?tab=tags。

可以通过 Sort by 查看其他版本的 Redis，默认是最新版本 **redis:latest**。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis1.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis1.png)

你也可以在下拉列表中找到其他你想要的版本：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis2.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis2.png)

此外，我们还可以用  docker search redis 命令来查看可用版本：

```
$ docker search  redis
NAME                      DESCRIPTION                   STARS  OFFICIAL  AUTOMATED
redis                     Redis is an open source ...   2321   [OK]       
sameersbn/redis                                         32                   [OK]
torusware/speedus-redis   Always updated official ...   29             [OK]
bitnami/redis             Bitnami Redis Docker Image    22                   [OK]
anapsix/redis             11MB Redis server image ...   6                    [OK]
webhippie/redis           Docker images for redis       4                    [OK]
clue/redis-benchmark      A minimal docker image t...   3                    [OK]
williamyeh/redis          Redis image for Docker        3                    [OK]
unblibraries/redis        Leverages phusion/baseim...   2                    [OK]
greytip/redis             redis 3.0.3                   1                    [OK]
servivum/redis            Redis Docker Image            1                    [OK]
...
```

### 2、取最新版的 Redis 镜像

这里我们拉取官方的最新版本的镜像：

```
$ docker pull redis:latest
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis3.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis3.png)

### 3、查看本地镜像

使用以下命令来查看是否已安装了 redis：

```
$ docker images
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis4.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis4.png)

在上图中可以看到我们已经安装了最新版本（latest）的 redis 镜像。

### 4、运行容器

安装完成后，我们可以使用以下命令来运行 redis 容器：

```
$ docker run -itd --name redis-test -p 6379:6379 redis
```

参数说明：

- **-p 6379:6379**：映射容器服务的 6379 端口到宿主机的 6379 端口。外部可以直接通过宿主机ip:6379 访问到 Redis 的服务。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis5.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis5.png)

### 5、安装成功

最后我们可以通过 **docker ps** 命令查看容器的运行信息：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis6.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis6.png)

接着我们通过 redis-cli 连接测试使用 redis 服务。

```
$ docker exec -it redis-test /bin/bash
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis7.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-redis7.png)

 [Docker 安装 Python](https://www.runoob.com/docker/docker-install-python.html) 

[Docker 安装 Mong](https://www.runoob.com/docker/docker-install-mongodb.html)

# Docker 安装 MongoDB

MongoDB 是一个免费的开源跨平台面向文档的 NoSQL 数据库程序。

### 1、查看可用的 MongoDB 版本

访问 MongoDB 镜像库地址： https://hub.docker.com/_/mongo?tab=tags&page=1。

可以通过 Sort by 查看其他版本的 MongoDB，默认是最新版本 **mongo:latest**。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo1.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo1.png)

你也可以在下拉列表中找到其他你想要的版本：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo2.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo2.png)

此外，我们还可以用  docker search mongo 命令来查看可用版本：

```
$ docker search mongo
NAME                              DESCRIPTION                      STARS     OFFICIAL   AUTOMATED
mongo                             MongoDB document databases ...   1989      [OK]       
mongo-express                     Web-based MongoDB admin int...   22        [OK]       
mvertes/alpine-mongo              light MongoDB container          19                   [OK]
mongooseim/mongooseim-docker      MongooseIM server the lates...   9                    [OK]
torusware/speedus-mongo           Always updated official Mon...   9                    [OK]
jacksoncage/mongo                 Instant MongoDB sharded cluster  6                    [OK]
mongoclient/mongoclient           Official docker image for M...   4                    [OK]
jadsonlourenco/mongo-rocks        Percona Mongodb with Rocksd...   4                    [OK]
asteris/apache-php-mongo          Apache2.4 + PHP + Mongo + m...   2                    [OK]
19hz/mongo-container              Mongodb replicaset for coreos    1                    [OK]
nitra/mongo                       Mongo3 centos7                   1                    [OK]
ackee/mongo                       MongoDB with fixed Bluemix p...  1                    [OK]
kobotoolbox/mongo                 https://github.com/kobotoolb...  1                    [OK]
valtlfelipe/mongo                 Docker Image based on the la...  1                    [OK]
```

### 2、取最新版的 MongoDB 镜像

这里我们拉取官方的最新版本的镜像：

```
$ docker pull mongo:latest
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo3.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo3.png)

### 3、查看本地镜像

使用以下命令来查看是否已安装了 mongo：

```
$ docker images
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo4.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo4.png)

在上图中可以看到我们已经安装了最新版本（latest）的 mongo 镜像。

### 4、运行容器

安装完成后，我们可以使用以下命令来运行 mongo 容器：

```
$ docker run -itd --name mongo -p 27017:27017 mongo --auth
```

参数说明：

- **-p 27017:27017** ：映射容器服务的 27017 端口到宿主机的 27017 端口。外部可以直接通过 宿主机 ip:27017 访问到 mongo 的服务。
- **--auth**：需要密码才能访问容器服务。

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo5.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo5.png)

### 5、安装成功

最后我们可以通过 **docker ps** 命令查看容器的运行信息：

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo6.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo6.png)

接着使用以下命令添加用户和设置密码，并且尝试连接。

```
$ docker exec -it mongo mongo admin
# 创建一个名为 admin，密码为 123456 的用户。
>  db.createUser({ user:'admin',pwd:'123456',roles:[ { role:'userAdminAnyDatabase', db: 'admin'},"readWriteAnyDatabase"]});
# 尝试使用上面创建的用户信息进行连接。
> db.auth('admin', '123456')
```

[![img](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo7.png)](https://www.runoob.com/wp-content/uploads/2016/06/docker-mongo7.png)



### Apache

#### docker pull httpd

```bash
# 拉取官方的镜像
docker pull httpd
```

#### 通过 Dockerfile 构建

```bash
# 创建目录apache,用于存放后面的相关文件
mkdir -p  ~/apache/www ~/apache/logs ~/apache/conf 

# www  目录将映射为 apache 容器配置的应用程序目录。
# logs 目录将映射为 apache 容器的日志目录。
# conf 目录里的配置文件将映射为 apache 容器的配置文件。
```

进入创建的 apache 目录，创建 Dockerfile。

```dockerfile
FROM debian:jessie

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd -r www-data && useradd -r --create-home -g www-data www-data

ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $PATH:$HTTPD_PREFIX/bin
RUN mkdir -p "$HTTPD_PREFIX" \
    && chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX

# install httpd runtime dependencies
# https://httpd.apache.org/docs/2.4/install.html#requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libapr1 \
        libaprutil1 \
        libaprutil1-ldap \
        libapr1-dev \
        libaprutil1-dev \
        libpcre++0 \
        libssl1.0.0 \
    && rm -r /var/lib/apt/lists/*

ENV HTTPD_VERSION 2.4.20
ENV HTTPD_BZ2_URL https://www.apache.org/dist/httpd/httpd-$HTTPD_VERSION.tar.bz2

RUN buildDeps=' \
        ca-certificates \
        curl \
        bzip2 \
        gcc \
        libpcre++-dev \
        libssl-dev \
        make \
    ' \
    set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -r /var/lib/apt/lists/* \
    \
    && curl -fSL "$HTTPD_BZ2_URL" -o httpd.tar.bz2 \
    && curl -fSL "$HTTPD_BZ2_URL.asc" -o httpd.tar.bz2.asc \
# see https://httpd.apache.org/download.cgi#verify
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A93D62ECC3C8EA12DB220EC934EA76E6791485A8 \
    && gpg --batch --verify httpd.tar.bz2.asc httpd.tar.bz2 \
    && rm -r "$GNUPGHOME" httpd.tar.bz2.asc \
    \
    && mkdir -p src \
    && tar -xvf httpd.tar.bz2 -C src --strip-components=1 \
    && rm httpd.tar.bz2 \
    && cd src \
    \
    && ./configure \
        --prefix="$HTTPD_PREFIX" \
        --enable-mods-shared=reallyall \
    && make -j"$(nproc)" \
    && make install \
    \
    && cd .. \
    && rm -r src \
    \
    && sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        "$HTTPD_PREFIX/conf/httpd.conf" \
    \
    && apt-get purge -y --auto-remove $buildDeps

COPY httpd-foreground /usr/local/bin/

EXPOSE 80
CMD ["httpd-foreground"]
```

Dockerfile文件中 COPY httpd-foreground /usr/local/bin/  是将当前目录下的httpd-foreground拷贝到镜像里，作为httpd服务的启动脚本，所以要在本地创建一个脚本文件httpd-foreground 

```bash
#!/bin/bash
set -e

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

exec httpd -DFOREGROUND
```

赋予 httpd-foreground 文件可执行权限。

```bash
chmod +x httpd-foreground
```

通过 Dockerfile 创建一个镜像，替换成你自己的名字。

```bash
docker build -t httpd .
```

创建完成后，我们可以在本地的镜像列表里查找到刚刚创建的镜像。

```bash
runoob@runoob:~/apache$ docker images httpd
REPOSITORY     TAG        IMAGE ID        CREATED           SIZE
httpd          latest     da1536b4ef14    23 seconds ago    195.1 MB
```

#### 使用 apache 镜像

```bash
docker run -p 80:80 -v $PWD/www/:/usr/local/apache2/htdocs/ -v $PWD/conf/httpd.conf:/usr/local/apache2/conf/httpd.conf -v $PWD/logs/:/usr/local/apache2/logs/ -d httpd
```

命令说明：

**-p 80:80:** 将容器的 80 端口映射到主机的 80 端口。

**-v $PWD/www/:/usr/local/apache2/htdocs/:** 将主机中当前目录下的 www 目录挂载到容器的 /usr/local/apache2/htdocs/。

**-v $PWD/conf/httpd.conf:/usr/local/apache2/conf/httpd.conf:** 将主机中当前目录下的 conf/httpd.conf 文件挂载到容器的 /usr/local/apache2/conf/httpd.conf。

**-v $PWD/logs/:/usr/local/apache2/logs/:** 将主机中当前目录下的 logs 目录挂载到容器的 /usr/local/apache2/logs/。

查看容器启动情况：

```
runoob@runoob:~/apache$ docker ps
CONTAINER ID  IMAGE   COMMAND             ... PORTS               NAMES
79a97f2aac37  httpd   "httpd-foreground"  ... 0.0.0.0:80->80/tcp  sharp_swanson
```

## 容器编排引擎

* docker swarm
* kubernetes
* mesos + marathon

## 容器管理平台

* Rancher
* ContainerShip

## 基于容器的Paas

* Deis
* Flynn
* Dokku

## 版本

分为CE 和EE。
CE 即社区版（免费，支持周期三个月）
EE 即企业版，强调安全，付费使用。

Docker在1.13 版本之后，从2017年的3月1日开始，版本命名规则变为如下:

| 项目       | 说明         |
| ---------- | ------------ |
| 版本格式   | YY.MM        |
| Stable版本 | 每个季度发行 |
| Edge版本   | 每个月发行   |

Docker CE 每月发布一个Edge 版本(17.03, 17.04, 17.05…)，每三个月发布一个Stable 版本(17.03, 17.06, 17.09…)，Docker EE 和Stable 版本号保持一致，但每个版本提供一年维护。

## 图形用户界面

* maDocker
* Rancher
* Portainer
* Shipyard [停止更新]
* DockerUI [停止更新]

## 历史

Docker 最初是 dotCloud 公司创始人 Solomon Hykes 在法国期间发起的一个公司内部项目，是基于 dotCloud 公司多年云服务技术的一次革新，并于 2013 年 3 月以 Apache 2.0 授权协议开源，主要项目代码在 GitHub 上进行维护。

Docker 项目后来还加入了 Linux 基金会，并成立推动 开放容器联盟（OCI）。

由于 Docker 项目的火爆，在 2013 年底，dotCloud 公司决定改名为Docker。Docker 最初是在 Ubuntu 12.04 上开发实现的；Red Hat 则从 RHEL 6.5 开始对Docker 进行支持；Google 也在其 PaaS 产品中广泛应用 Docker。





