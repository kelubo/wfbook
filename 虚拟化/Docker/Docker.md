# Docker

一个开源的应用容器引擎，基于 Go 语言 并遵从Apache2.0协议开源。  
Docker 使用客户端-服务器 (C/S) 架构模式，使用远程API来管理和创建Docker容器。  
Docker 容器通过 Docker 镜像来创建。
![](../../Image/a/ab.png)

## 与Linux虚拟机的比较

| 特性 | 容器 | 虚拟机 |
|----|----|-----|
| 启动速度 | 秒级 | 分钟级 |
| 硬盘使用 | 一般为MB | 一般为GB |
| 性能 | 接近原生 | 弱于 |
| 系统支持量 | 单机支持上千个容器 | 一般几十个 |
| 隔离性 | 安全隔离 | 完全隔离 |

## 基本概念

* **镜像**（Image），只读模板，用于创建Docker容器。
* **容器**（Container），是从镜像创建的运行实例，是独立运行的一个或一组应用。
* **仓库**（Repository），集中存放镜像文件的场所。
* **客户端** (Client)，通过命令行或者其他工具使用 Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。
* **主机** (Host)，一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。
* **Docker Machine** ,是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker 。

## 组成
docker服务端（服务进程，管理着所有的容器）  
docker客户端（远程控制器，控制docker的服务端进程）。

## 安装

### RHEL/CentOS
RHEL 7 64位 内核版本3.10以上

    yum install docker
    systemctl enable docker.service
    systemctl start docker.service

### Ubuntu
Docker 支持以下的 Ubuntu 版本(内核版本高于 3.10)：

    Ubuntu Precise 12.04 (LTS)
    Ubuntu Trusty 14.04 (LTS)
    Ubuntu Wily 15.10
    其他更新的版本……

安装：

    apt-get update
    apt-get install docker.io
    ln -sf /usr/bin/docker.io /usr/local/bin/docker
    service docker start

当要以非root用户可以直接运行docker时，需要执行 `sudo usermod -aG docker runoob `命令，然后重新登陆。

## 检查Docker版本
     $ docker version

## 搜索可用的docker镜像
    $ docker search XXXX

## 下载镜像
    $ docker pull XXXX

## 运行
    $ docker run 镜像名 命令
    参数解析：
        -t:在新容器内指定一个伪终端或终端。
        -i:允许你对容器内的标准输入 (STDIN) 进行交互。
        -d:让容器在后台运行。
        -P:将容器内部使用的网络端口映射到我们使用的主机上。

## 停止容器

     docker stop id/name

## 列出本地镜像
    $ docker images

## 保存对容器的修改

    $ docker ps -l
    $ docker commit id 新的容器名

## 检查运行中的镜像
    $ docker ps             //查看正在运行中的容器列表
    $ docker inspect XXXX   //查看某一容器的信息

## 查看容器内的标准输出
    $ docker logs id

## 发布docker镜像
    $ docker images         //列出所有安装过的镜像
    $ docker push XXXX      //将某一个镜像发布到官方网站

## 查看网络端口

    docker port id/name

## 移除容器

    $ docker rm name

删除容器时，容器必须是停止状态，否则会报如下错误

## docker 命令
