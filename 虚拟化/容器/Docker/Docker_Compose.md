# Docker Compose

[TOC]

## 概述

容器的一个最佳实践是每个容器都应该做一件事，并且做得很好。虽然此规则也有例外，但应避免让一个容器执行多项操作。

可以使用多个 `docker run` 命令来启动多个容器。But, you'll soon realize you'll  need to manage networks, all of the flags needed to connect containers  to those networks, and more. 但是，很快就会意识到需要管理网络、将容器连接到这些网络所需的所有标志等等。完成后，清理工作会稍微复杂一些。

使用 Docker Compose，可以在单个 YAML 文件中定义所有容器及其配置。如果将此文件包含在代码存储库中，则克隆存储库的任何人都可以使用单个命令启动并运行。

Compose 是一个声明性工具 - 只需定义它然后使用。You don't always need to recreate everything from  scratch.并不总是需要从头开始重新创建所有内容。如果进行了更改，请再次运行 `docker compose up` ，Compose 将协调文件中的更改并智能地应用它们。

> **Dockerfile 与 Compose 文件**
> 
>Dockerfile 提供构建容器镜像的说明，而 Compose 文件定义正在运行的容器。很多时候，Compose 文件会引用 Dockerfile 来构建用于特定服务的镜像。

## 示例

### 启动应用程序

在系统上运行应用程序。

下载并安装 Docker Desktop。

打开一个终端并克隆此示例应用程序。

```bash
git clone https://github.com/dockersamples/todo-list-app 
```

导航到 `todo-list-app` 目录：

```bash
cd todo-list-app
```

在此目录中，将找到一个名为 `compose.yaml` 的文件。它定义了构成应用程序的所有服务及其配置。每个服务都指定其映像、端口、卷、网络以及其功能所需的任何其他设置。

使用 `docker compose up` 命令启动应用程序：

```bash
docker compose up -d --build
```

运行此命令时，应看到如下所示的输出：

```bash
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

这里发生了很多事情！有几件事需要注意：

- 从 Docker Hub 下载了两个容器镜像 - node 和 MySQL
- 为应用程序创建了一个网络
- 创建一个卷，用于在容器重新启动之间保留数据库文件
- 使用所有必要的配置启动了两个容器

现在一切都启动并运行，可以在浏览器中打开 http://localhost:3000 以查看该站点。

 <img src="../../../Image/t/todo-list-app.webp" style="zoom:50%;" />

如果查看 Docker Desktop GUI，可以看到容器并更深入地了解其配置。

![](../../../Image/t/todo-list-containers.webp)

### 停止应用程序

由于此应用程序是使用 Docker Compose 启动的，因此在完成后很容易将其全部停止。

在 CLI 中，使用命令 `docker compose down` 删除所有内容：

```bash
docker compose down
```

将看到类似于以下内容的输出：

```bash
[+] Running 2/2
✔ Container todo-list-app-mysql-1  Removed        2.9s
✔ Container todo-list-app-app-1    Removed        0.1s
✔ Network todo-list-app_default    Removed        0.1s
```

> **卷持久性**
>
> By default, volumes *aren't* automatically removed when you tear down a Compose stack. The idea is  that you might want the data back if you start the stack again.
> 默认情况下，当您拆除 Compose 堆栈时，卷不会自动删除。这个想法是，如果您再次启动堆栈，可能希望返回数据。
>
> If you do want to remove the volumes, add the `--volumes` flag when running the `docker compose down` command:
> 如果确实要删除卷，请在运行命令 `docker compose down` 时添加标志 `--volumes` ：
>
> ```bash
> docker compose down --volumes
> ```
>
> Alternatively, you can use the Docker Desktop GUI to remove the containers by selecting the application stack and selecting the **Delete** button.
> 或者，可以使用 Docker Desktop GUI 通过选择应用程序堆栈并选择“删除”按钮来删除容器。
>
> ![](../../../Image/t/todo-list-delete.webp)
>
> 请注意，如果在 GUI 中删除 Compose 应用的容器，则只会删除容器。如果需要，则必须手动删除网络和卷。
