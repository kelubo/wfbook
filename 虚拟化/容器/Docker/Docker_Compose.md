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

1. in your browser to see the site. Feel free to add items to the list, check them off, and remove them.
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