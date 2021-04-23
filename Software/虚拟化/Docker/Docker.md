# Docker

[TOC]

开源的应用容器引擎，基于 Go 语言实现，基于Linux内核的cgroup、namespace以及AUFS类的UnionFS等技术，对进程进行封装隔离，属于操作系统层面的虚拟化技术。由于隔离的进程独立于宿主和其他的隔离的进程，因此也称其为容器。最初实现是基于LXC，从0.7版本后，开始去除LXC，转而使用自行开发的libcontainer，从1.11开始，则进一步演进为使用runC和containerd。基于Apache2.0协议开源。 
Docker 使用 C/S 架构模式，使用远程API来管理和创建Docker容器。
Docker 容器通过 Docker 镜像来创建。

## 与Linux虚拟机的比较

| 特性 | 容器 | 虚拟机 |
|----|----|-----|
| 启动速度 | 秒级 | 分钟级 |
| 硬盘使用 | 一般为MB | 一般为GB |
| 性能 | 接近原生 | 弱于 |
| 系统支持量 | 单机支持上千个容器 | 一般几十个 |
| 隔离性 | 安全隔离 | 完全隔离 |

## 组成

### 镜像（Image）

只读模板，用于创建Docker容器，相当于是一个root文件系统。除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。不包含任何动态数据，其内容在构建后不会被改变。

#### 虚悬镜像
特殊的镜像，这个镜像既没有仓库名，也没有标签，均为`<none>` 。这个镜像原本是有镜像名和标签的，随着官方镜像维护，发布了新版本后，重新 docker pull  时，镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了`<none>` 。除了 docker pull 可能导致这种情况， docker build 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 `<none>` 的镜像。这类无标签镜像也被称为虚悬镜像(dangling image) ，显示这类镜像：

```bash
docker image ls -f dangling=true
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的。

#### 中间层镜像
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

一个 Docker Registry 中可以包含多个仓库（ Repository ）；每个仓库可以包含多个标签（ Tag ）；每个标签对应一个镜像。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。可以通过 <仓库名>:<标签> 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 latest 作为默认标签。
仓库名经常以 两段式路径 形式出现，比如 jwilder/nginx-proxy ，前者往往意味着 Docker Registry 多用户环境下的用户名，后者则往往是对应的软件名。但这并非绝对，取决于所使用的具体 Docker Registry 的软件或服务。

#### 公开 Docker Registry
公开服务是开放给用户使用、允许用户管理镜像的 Registry 服务。
最常使用的 Registry 公开服务是官方的 Docker Hub，这也是默认的 Registry，并拥有大量的高质量的官方镜像。除此以外，还有 CoreOS 的 Quay.io，CoreOS 相关的镜像存储在这里；Google 的 Google Container Registry，Kubernetes 的镜像使用的就是这个服务。
国内的一些云服务商提供了针对 Docker Hub 的镜像服务（ Registry Mirror ），这些镜像服务被称为加速器。常见的有 阿里云加速器、DaoCloud 加速器 等。
国内也有一些云服务商提供类似于 Docker Hub 的公开服务。比如 时速云镜像仓库、网易云镜像服务、DaoCloud 镜像市场、阿里云镜像库 等。

#### 私有 Docker Registry
用户可以在本地搭建私有 Docker Registry。Docker 官方提供了Docker Registry 镜像，可以直接使用做为私有 Registry 服务。
开源的 Docker Registry 镜像只提供了 Docker Registry API 的服务端实现，足以支持docker 命令，不影响使用。但不包含图形界面，以及镜像维护、用户管理、访问控制等高级功能。在官方的商业化版本 Docker Trusted Registry 中，提供了这些高级功能。
除了官方的 Docker Registry 外，还有第三方软件实现了 Docker Registry API，甚至提供了用户界面以及一些高级功能。比如，VMWare Harbor 和 Sonatype Nexus。

### 客户端 (Client)

通过命令行或者其他工具使用 Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。

### 主机 (Host)

一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。

### Docker Machine

是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker 。

![](../../../Image/a/ab.png)

docker服务端（服务进程，管理着所有的容器）  
docker客户端（远程控制器，控制docker的服务端进程）。

Remote API操作Docker的守护进程，意味着我们可以通过自己的程序来控制Docker的运行。
客户端和服务端既可以运行在一个机器上，也可通过socket 或者RESTful API 来进行通信

Docker的客户端与守护进程之间的通信，其连接方式为socket连接。主要有三种socket连接方式：

```
unix:///var/run/docker.sock
tcp://host:port
fd://socketfd
```

## 分层存储

镜像包含操作系统完整的root 文件系统，其体积往往是庞大的，因此在Docker设计时，利用Union FS 的技术，将其设计为分层存储的架构。镜像并非是像一个ISO 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。

镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。

分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像。

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

## Docker指令

### 容器生命周期管理

- run	创建一个新的容器并运行一个命令

  ```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
  
  -a stdin:                 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
  -d:                       后台运行容器，并返回容器ID；
-i,  –interactive=true | false:  以交互模式运行容器，通常与 -t 同时使用；默认为 false
  -P:                       随机端口映射，容器内部端口随机映射到主机的高端口
-p:                       指定端口映射，格式为：主机(宿主)端口:容器端口 
  -t,  –tty=true | false:   为容器重新分配一个伪输入终端，通常与 -i 同时使用；默认为 false
  --name="xxxx":            为容器指定一个名称；
  --dns 8.8.8.8:            指定容器使用的DNS服务器，默认和宿主一致；
  --dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
  -h "xxxx":                指定容器的hostname；
  -e username="xxxxxxx":    设置环境变量；
  --env-file=[]:            从指定文件读入环境变量；
  --cpuset="0-2"
  --cpuset="0,1,2":         绑定容器到指定CPU运行；
  -m :                      设置容器使用内存最大值；
  --net="bridge":           指定容器的网络连接类型，支持 bridge/host/none/container；
  --link=[]:                添加链接到另一个容器；
  --expose=[]:              开放一个端口或一组端口； 
  --volume , -v:	          绑定一个卷。host-dir:container-dir:[rw|ro]
  --rm                      容器退出后随之将其删除。
  ```
  
- start/stop/restart	停止容器

  ```bash
   docker stop id/name
  ```

- [kill](https://www.runoob.com/docker/docker-kill-command.html)

- rm	移除容器，删除容器时，容器必须是停止状态，否则会报错。

  ```
  docker rm name
  ```

- [pause/unpause](https://www.runoob.com/docker/docker-pause-unpause-command.html)

- [create](https://www.runoob.com/docker/docker-create-command.html)

- [exec](https://www.runoob.com/docker/docker-exec-command.html)

###  容器操作

- ps

  ```bash
  docker ps [-a] [-l]
  -a all 列出所有容器
  -l latest 列出最近的容器
  ```

- inspect	   查看某一容器的信息

  ```bash
  docker inspect XXXX
  ```

- top

- diff

- attach

- events

- logs	查看容器内的标准输出

  ```bash
  docker logs id
  ```

- [wait](https://www.runoob.com/docker/docker-wait-command.html)

- [export](https://www.runoob.com/docker/docker-export-command.html)

- commit

- port	查看网络端口

  ```bash
  docker port id/name
  ```



### 容器rootfs命令

- commit	保存对容器的修改

  ```bash
  docker commit id 新的容器名
  ```

- [cp](https://www.runoob.com/docker/docker-cp-command.html)

- [diff](https://www.runoob.com/docker/docker-diff-command.html)

### 镜像仓库

- [login](https://www.runoob.com/docker/docker-login-command.html)

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

- [rmi](https://www.runoob.com/docker/docker-rmi-command.html)

- [tag](https://www.runoob.com/docker/docker-tag-command.html)

- [build](https://www.runoob.com/docker/docker-build-command.html)

- [history](https://www.runoob.com/docker/docker-history-command.html)

- [save](https://www.runoob.com/docker/docker-save-command.html)

- [load](https://www.runoob.com/docker/docker-load-command.html)

- [import](https://www.runoob.com/docker/docker-import-command.html)

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

### history

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

构建镜像

构建Docker镜像，可以保存对容器的修改，并且再次使用。构建镜像提供了自定义镜像的能力，以软件的形式打包并分发服务及其运行环境。Docker中提供了两种方式来构建镜像：

    通过容器构建：docker commit
    通过Dockerfile：docker build

使用commit命令构建镜像

命令：docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]

参数：-a，–author=“”，指定镜像的作者信息

 -m，–message=“”，提交信息

 -p，–pause=true，commit时是否暂停容器

commit命令构建镜像

使用Dockerfile文件构建镜像

Docker允许我们利用一个类似配置文件的形式来进行构建自定义镜像，在文件中可以指定原始的镜像，自定义镜像的维护人信息，对原始镜像采取的操作以及暴露的端口等信息。比如：

## Dockerfile

```dockerfile
FROM ubuntu
# 指定基础镜像。
# 除了选择现有镜像为基础镜像外，还存在一个特殊的镜像，名为 scratch 。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。如以 scratch 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。不以任何系统为基础，直接将可执行文件复制进镜像的做法并不罕见。对于 Linux 下静态编译的程序来说，并不需要有操作系统提供运行时支持，所需的一切库都已经在可执行文件里了，因此直接 FROM scratch 会让镜像体积更加小巧。使用 Go 语言 开发的应用很多会使用这种方式来制作镜像。

MAINTAINER Krupp "wf.ab@126.com"

# ENV 设置环境变量
# 格式1：  ENV <key> <value>
# 格式2：  ENV <key1>=<value1>
ENV VERSION=1.0

# ARG 构建参数
# ARG <OPTION_NAME>[=<默认值>]
# ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在的。在 docker history 中可以看到所有的值。
# 默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖。

# RUN 执行命令
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

# COPY 复制文件
# COPY <源路径> <目标路径>
# COPY ["源路径","目标路径"]
# 目标路径不需要事先创建，如不存在，会在复制文件前先行创建。
COPY package.json /usr/src/app/

# ADD 复制文件
# 源路径是URL，会自动下载。源路径是tar压缩包，会自动解压缩。
ADD ubuntu-xenial-core-clouding-amd64-root.tar.gz /

# VOLUME 定义匿名卷
# VOLUME ["路径1","路径2"]
# VOLUME <路径>
VOLUME /data
# 容器运行时应该尽量保持容器存储层不发生写操作，对于需要保存动态数据的应用，其文件应该保存于卷(volume)中。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在Dockerfile 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。运行时可以用-v覆盖这个挂载设置。
EXPOSE 80



# ENTRYPOINT 入口点

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

