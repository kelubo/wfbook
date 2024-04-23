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

![](../../../../Image/a/ab.png)

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

maDocker

Rancher

Portainer

Shipyard [停止更新]

DockerUI [停止更新]

## 历史

Docker 最初是 dotCloud 公司创始人 Solomon Hykes 在法国期间发起的一个公司内部项目，是基于 dotCloud 公司多年云服务技术的一次革新，并于 2013 年 3 月以 Apache 2.0 授权协议开源，主要项目代码在 GitHub 上进行维护。

Docker 项目后来还加入了 Linux 基金会，并成立推动 开放容器联盟（OCI）。

由于 Docker 项目的火爆，在 2013 年底，dotCloud 公司决定改名为Docker。Docker 最初是在 Ubuntu 12.04 上开发实现的；Red Hat 则从 RHEL 6.5 开始对Docker 进行支持；Google 也在其 PaaS 产品中广泛应用 Docker。

## 优势

* 更高效的利用系统资源。
* 更快速的启动时间。
* 一致的运行环境。
* 持续交付和部署。
* 更轻松的迁移。
* 更轻松的维护和扩展。

## Docker 的优点

Docker 是一个用于开发，交付和运行应用程序的开放平台。Docker 使您能够将应用程序与基础架构分开，从而可以快速交付软件。借助  Docker，您可以与管理应用程序相同的方式来管理基础架构。通过利用 Docker  的方法来快速交付，测试和部署代码，您可以大大减少编写代码和在生产环境中运行代码之间的延迟。

### 1、快速，一致地交付您的应用程序

Docker 允许开发人员使用您提供的应用程序或服务的本地容器在标准化环境中工作，从而简化了开发的生命周期。

容器非常适合持续集成和持续交付（CI / CD）工作流程，请考虑以下示例方案：

- 您的开发人员在本地编写代码，并使用 Docker 容器与同事共享他们的工作。
- 他们使用 Docker 将其应用程序推送到测试环境中，并执行自动或手动测试。
- 当开发人员发现错误时，他们可以在开发环境中对其进行修复，然后将其重新部署到测试环境中，以进行测试和验证。
- 测试完成后，将修补程序推送给生产环境，就像将更新的镜像推送到生产环境一样简单。

### 2、响应式部署和扩展

Docker 是基于容器的平台，允许高度可移植的工作负载。Docker 容器可以在开发人员的本机上，数据中心的物理或虚拟机上，云服务上或混合环境中运行。

Docker 的可移植性和轻量级的特性，还可以使您轻松地完成动态管理的工作负担，并根据业务需求指示，实时扩展或拆除应用程序和服务。

### 3、在同一硬件上运行更多工作负载

Docker 轻巧快速。它为基于虚拟机管理程序的虚拟机提供了可行、经济、高效的替代方案，因此您可以利用更多的计算能力来实现业务目标。Docker 非常适合于高密度环境以及中小型部署，而您可以用更少的资源做更多的事情。