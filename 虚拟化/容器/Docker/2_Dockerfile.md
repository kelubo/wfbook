# Dockerfile

[TOC]

## 概述

Dockerfile 是一个基于文本的文档，用于创建容器镜像。它为镜像构建器提供有关要运行的命令、要复制的文件、启动命令等的说明。

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

## 常用说明

`Dockerfile` 一些最常见的说明包括：

- `FROM <image>` - 这指定了构建将扩展的基础映像。

- `WORKDIR <path>` - this instruction specifies the "working directory" or the path in the image where files will be copied and commands will be executed.此指令指定了“工作目录”或镜像中的路径（将在其中复制文件并执行命令）。

- `COPY <host-path> <image-path>` - 此指令告诉构建器从主机复制文件并将它们放入容器镜像中。

- `RUN <command>` - 此指令告诉构建器运行指定的命令。

- `ENV <name> <value>` - 此指令设置一个正在运行的容器将使用的环境变量。

- `EXPOSE <port-number>` - this instruction sets configuration on the image that indicates a port the image would like to expose.

  此指令在映像上设置配置，指示映像要公开的端口。

- `USER <user-or-uid>` - 此指令为所有后续指令设置默认用户。
  
- `CMD ["<command>", "<arg1>"]` - 此指令设置使用此镜像的容器将运行的默认命令。

## 示例

Dockerfile 通常遵循以下步骤：

1. 确定基础映像
2. 安装应用程序依赖项
3. 复制任何相关的源代码和/或二进制文件
4. 配置最终映像

在这个指南中，将编写一个 Dockerfile，用于构建一个简单的 Node.js 应用程序。

### 下载程序

下载此 [ZIP](https://github.com/docker/getting-started-todo-app/raw/build-image-from-scratch/app.zip) 文件并将内容解压缩到计算机上的目录中。

### 创建 Dockerfile

现在，已经有了项目，可以创建 `Dockerfile` .

在与文件 `package.json` 相同的文件夹中创建一个名为 `Dockerfile` 的文件。

> **Dockerfile 文件扩展名**
> 
>需要注意的是，`Dockerfile` 没有文件扩展名。一些编辑器会自动向文件添加扩展名（或抱怨它没有扩展名）。

在  `Dockerfile`  中，通过添加以下行来定义基础映像：

```dockerfile
FROM node:20-alpine
```

现在，使用指令 `WORKDIR` 定义工作目录。这将指定将来命令的运行位置，并将目录文件复制到容器映像中。

```dockerfile
WORKDIR /usr/local/app
```

使用 `COPY` 将计算机上项目中的所有文件复制到容器映像中：

```dockerfile
COPY . .
```

使用 `yarn` CLI 和包管理器安装应用的依赖项。为此，请使用以下 `RUN` 指令运行命令：

```dockerfile
RUN yarn install --production
```

最后，使用 `CMD` 指令指定要运行的默认命令：

```dockerfile
CMD ["node", "./src/index.js"]
```

应该有以下的Dockerfile：

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "./src/index.js"]
```

> **此 Dockerfile 尚未准备好用于生产环境**
> 
>It's important to note that this Dockerfile is *not* following all of the best practices yet (by design). It will build the app, but the builds won't be as fast as they could be and the image could be made more secure.
> 需要注意的是，此 Dockerfile 尚未遵循所有最佳实践（按设计）。它将构建应用程序，但构建速度不会像它们可能的那样快，并且镜像可能会更加安全。
> 
>Keep reading to learn more about how to make the image maximize the build cache, run as a non-root user, and multi-stage builds.
> 继续阅读以了解有关如何使映像最大化构建缓存、以非 root 用户身份运行以及多阶段构建的更多信息。

> **Containerize new projects quickly with `docker init`
> 使用以下功能 `docker init` 快速容器化新项目**
>
> The `docker init` command will analyze your project and quickly create a Dockerfile, a `compose.yaml`, and a `.dockerignore`, helping you get up and going. Since you're learning about Dockerfiles specifically here, you won't use it now. But, [learn more about it here](https://docs.docker.com/engine/reference/commandline/init/).
> 该 `docker init` 命令将分析您的项目并快速创建 Dockerfile、a `compose.yaml` 和 a `.dockerignore` ，帮助您开始工作。由于您在这里专门学习 Dockerfiles，因此您现在不会使用它。但是，请在此处了解更多信息。
