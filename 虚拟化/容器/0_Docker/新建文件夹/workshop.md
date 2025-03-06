# Overview of the Docker workshop Docker 研讨会概述

This 45-minute workshop contains step-by-step instructions on how to get started with Docker. This workshop shows you how to:
这个 45 分钟的研讨会包含有关如何开始使用 Docker 的分步说明。本次研讨会向您展示如何：

- Build and run an image as a container.
  将映像生成并作为容器运行。
- Share images using Docker Hub.
  使用 Docker Hub 共享图像。
- Deploy Docker applications using multiple containers with a database.
  使用具有数据库的多个容器部署 Docker 应用程序。
- Run applications using Docker Compose.
  使用 Docker Compose 运行应用程序。

> **Note 注意**
>
> For a quick introduction to Docker and the benefits of containerizing your applications, see [Getting started](https://docs.docker.com/guides/getting-started/).
> 有关 Docker 的简要介绍以及容器化应用程序的好处，请参阅入门。

## [What is a container? 什么是容器？](https://docs.docker.com/guides/workshop/#what-is-a-container)

A container is a sandboxed process running on a host machine that is  isolated from all other processes running on that host machine. That  isolation leverages [kernel namespaces and cgroups](https://medium.com/@saschagrunert/demystifying-containers-part-i-kernel-space-2c53d6979504)

, features that have been in Linux for a long time. Docker makes these  capabilities approachable and easy to use. To summarize, a container:
容器是在主机上运行的沙盒进程，它与该主机上运行的所有其他进程隔离。这种隔离利用了内核命名空间和 cgroups，这些特性在 Linux 中已经存在了很长时间。Docker 使这些功能易于访问且易于使用。总而言之，一个容器：

- Is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI.
  是图像的可运行实例。您可以使用 Docker API 或 CLI 创建、启动、停止、移动或删除容器。
- Can be run on local machines, virtual machines, or deployed to the cloud.
  可以在本地计算机、虚拟机上运行，也可以部署到云端。
- Is portable (and can be run on any OS).
  是可移植的（可以在任何操作系统上运行）。
- Is isolated from other containers and runs its own software, binaries, configurations, etc.
  与其他容器隔离，并运行自己的软件、二进制文件、配置等。

If you're familiar with `chroot`, then think of a container as an extended version of `chroot`. The filesystem comes from the image. However, a container adds additional isolation not available when using chroot.
如果您熟悉 `chroot` ，则可以将容器视为 `chroot` 的扩展版本。文件系统来自镜像。但是，容器会增加使用 chroot 时不可用的额外隔离。

## [What is an image? 什么是图像？](https://docs.docker.com/guides/workshop/#what-is-an-image)

A running container uses an isolated filesystem. This isolated filesystem is provided by an image, and the image must contain everything needed  to run an application - all dependencies, configurations, scripts,  binaries, etc. The image also contains other configurations for the  container, such as environment variables, a default command to run, and  other metadata.
正在运行的容器使用隔离的文件系统。这个隔离的文件系统由镜像提供，镜像必须包含运行应用程序所需的一切 - 所有依赖项、配置、脚本、二进制文件等。该映像还包含容器的其他配置，例如环境变量、要运行的默认命令和其他元数据。

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/#next-steps)

In this section, you learned about containers and images.
在本节中，您学习了有关容器和映像的信息。

Next, you'll containerize a simple application and get hands-on with the concepts.
接下来，您将容器化一个简单的应用程序，并亲身体验这些概念。

# Containerize an application 容器化应用程序

For the rest of this guide, you'll be working with a simple todo list manager that runs on Node.js. If you're not familiar with Node.js, don't worry. This guide doesn't require any prior experience with JavaScript.
在本指南的其余部分，您将使用在 Node.js上运行的简单待办事项列表管理器。如果您不熟悉Node.js，请不要担心。本指南不需要任何 JavaScript 经验。

## [Prerequisites 先决条件](https://docs.docker.com/guides/workshop/02_our_app/#prerequisites)

- You have installed the latest version of [Docker Desktop](https://docs.docker.com/get-docker/).
  您已安装最新版本的 Docker Desktop。
- You have installed a [Git client](https://git-scm.com/downloads)

.
您已安装 Git 客户端。

You have an IDE or a text editor to edit files. Docker recommends using [Visual Studio Code](https://code.visualstudio.com/)

- .
  您有一个 IDE 或文本编辑器来编辑文件。Docker 建议使用 Visual Studio Code。

## [Get the app 获取应用程序](https://docs.docker.com/guides/workshop/02_our_app/#get-the-app)

Before you can run the application, you need to get the application source code onto your machine.
在运行应用程序之前，您需要将应用程序源代码获取到您的计算机上。

1. Clone the [getting-started-app repository](https://github.com/docker/getting-started-app/tree/main)

 using the following command:
使用以下命令克隆 getting-started-app 存储库：

```console
 git clone https://github.com/docker/getting-started-app.git
```

View the contents of the cloned repository. You should see the following files and sub-directories.
查看克隆存储库的内容。您应看到以下文件和子目录。

1. ```text
   ├── getting-started-app/
   │ ├── .dockerignore
   │ ├── package.json
   │ ├── README.md
   │ ├── spec/
   │ ├── src/
   │ └── yarn.lock
   ```

## [Build the app's image 构建应用的映像](https://docs.docker.com/guides/workshop/02_our_app/#build-the-apps-image)

To build the image, you'll need to use a Dockerfile. A Dockerfile is  simply a text-based file with no file extension that contains a script  of instructions. Docker uses this script to build a container image.
若要生成映像，需要使用 Dockerfile。Dockerfile 只是一个基于文本的文件，没有文件扩展名，包含指令脚本。Docker 使用此脚本来构建容器镜像。

1. In the `getting-started-app` directory, the same location as the `package.json` file, create a file named `Dockerfile`. You can use the following commands to create a Dockerfile based on your operating system.
   在 `getting-started-app` 目录中，与 `package.json` 文件相同的位置，创建一个名为 `Dockerfile` 的文件。您可以使用以下命令根据您的操作系统创建 Dockerfile。

------

In the terminal, run the following commands.
在终端中，运行以下命令。

Make sure you're in the `getting-started-app` directory. Replace `/path/to/getting-started-app` with the path to your `getting-started-app` directory.
确保您位于 `getting-started-app` 目录中。替换为 `/path/to/getting-started-app` 目录 `getting-started-app` 的路径。



```console
 cd /path/to/getting-started-app
```

Create an empty file named `Dockerfile`.
创建一个名为 `Dockerfile` 的空文件。



```console
 touch Dockerfile
```

------

Using a text editor or code editor, add the following contents to the Dockerfile:
使用文本编辑器或代码编辑器，将以下内容添加到 Dockerfile：

```dockerfile
# syntax=docker/dockerfile:1

FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```

Build the image using the following commands:
使用以下命令构建映像：

In the terminal, make sure you're in the `getting-started-app` directory. Replace `/path/to/getting-started-app` with the path to your `getting-started-app` directory.
在终端中，确保您位于 `getting-started-app` 目录中。替换为 `/path/to/getting-started-app` 目录 `getting-started-app` 的路径。

```console
 cd /path/to/getting-started-app
```

Build the image.
生成映像。



1. ```console
    docker build -t getting-started .
   ```

   The `docker build` command uses the Dockerfile to build a new image. You might have  noticed that Docker downloaded a lot of "layers". This is because you  instructed the builder that you wanted to start from the `node:18-alpine` image. But, since you didn't have that on your machine, Docker needed to download the image.
   该 `docker build` 命令使用 Dockerfile 构建新映像。您可能已经注意到 Docker 下载了很多“层”。这是因为您指示构建器要从 `node:18-alpine` 映像开始。但是，由于您的计算机上没有该映像，因此 Docker 需要下载该映像。

   After Docker downloaded the image, the instructions from the Dockerfile copied in your application and used `yarn` to install your application's dependencies. The `CMD` directive specifies the default command to run when starting a container from this image.
   Docker 下载映像后，Dockerfile 中的说明会复制到您的应用程序中，并用于 `yarn` 安装应用程序的依赖项。该 `CMD` 指令指定从此映像启动容器时要运行的默认命令。

   Finally, the `-t` flag tags your image. Think of this as a human-readable name for the final image. Since you named the image `getting-started`, you can refer to that image when you run a container.
   最后，该 `-t` 标志会标记您的图像。将其视为最终图像的人类可读名称。由于您命名了映像 `getting-started` ，因此您可以在运行容器时引用该映像。

   The `.` at the end of the `docker build` command tells Docker that it should look for the `Dockerfile` in the current directory.
    `docker build` 命令末尾的 告诉 `.` Docker 它应该在当前目录中查找。 `Dockerfile` 

## [Start an app container 启动应用容器](https://docs.docker.com/guides/workshop/02_our_app/#start-an-app-container)

Now that you have an image, you can run the application in a container using the `docker run` command.
现在，您已经有了映像，可以使用命令 `docker run` 在容器中运行应用程序。

1. Run your container using the `docker run` command and specify the name of the image you just created:
   使用命令 `docker run` 运行容器，并指定刚创建的映像的名称：

```console
 docker run -dp 127.0.0.1:3000:3000 getting-started
```

The `-d` flag (short for `--detach`) runs the container in the background. This means that Docker starts your container and returns you to the terminal prompt. You can verify that a container is running by viewing it in Docker Dashboard under **Containers**, or by running `docker ps` in the terminal.
 `-d` 标志（） `--detach` 在后台运行容器。这意味着 Docker 会启动您的容器并将您返回到终端提示符。您可以通过在 Docker Dashboard 的 Containers 下查看容器来验证容器是否正在运行，或者在终端中运行 `docker ps` 。

The `-p` flag (short for `--publish`) creates a port mapping between the host and the container. The `-p` flag takes a string value in the format of `HOST:CONTAINER`, where `HOST` is the address on the host, and `CONTAINER` is the port on the container. The command publishes the container's port 3000 to `127.0.0.1:3000` (`localhost:3000`) on the host. Without the port mapping, you wouldn't be able to access the application from the host.
 `-p` 标志（）的缩写 `--publish` 在主机和容器之间创建端口映射。该 `-p` 标志采用 格式为 `HOST:CONTAINER` 的字符串值，其中 `HOST` 是主机上的地址， `CONTAINER` 是容器上的端口。该命令将容器的端口 3000 发布到 `127.0.0.1:3000` 主机上的 （ `localhost:3000` ）。如果没有端口映射，您将无法从主机访问应用程序。

After a few seconds, open your web browser to http://localhost:3000

1. . You should see your app.
   几秒钟后，打开 Web 浏览器进行 http://localhost:3000。您应该看到您的应用程序。

   ![Empty todo list](https://docs.docker.com/guides/workshop/images/todo-list-empty.webp)

2. Add an item or two and see that it works as you expect. You can mark items  as complete and remove them. Your frontend is successfully storing items in the backend.
   添加一两个项目，看看它是否按预期工作。您可以将项目标记为已完成并删除它们。您的前端正在成功地在后端存储项目。

At this point, you have a running todo list manager with a few items.
此时，您有一个正在运行的待办事项列表管理器，其中包含几个项目。

If you take a quick look at your containers, you should see at least one container running that's using the `getting-started` image and on port `3000`. To see your containers, you can use the CLI or Docker Desktop's graphical interface.
如果您快速查看一下您的容器，您应该看到至少有一个容器正在运行，该容器正在使用映像 `getting-started` 并在端口 `3000` 上。要查看容器，可以使用 CLI 或 Docker Desktop 的图形界面。

------

Run the following `docker ps` command in a terminal to list your containers.
在终端中运行以下 `docker ps` 命令以列出容器。

```console
 docker ps
```

Output similar to the following should appear.
应显示类似于以下内容的输出。



```console
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
df784548666d        getting-started     "docker-entrypoint.s…"   2 minutes ago       Up 2 minutes        127.0.0.1:3000->3000/tcp   priceless_mcclintock
```

------

## [Summary 总结](https://docs.docker.com/guides/workshop/02_our_app/#summary)

In this section, you learned the basics about creating a Dockerfile to  build an image. Once you built an image, you started a container and saw the running app.
在本节中，您学习了有关创建 Dockerfile 以构建映像的基础知识。生成映像后，您启动了一个容器并看到了正在运行的应用。

Related information: 相关信息：

- [Dockerfile reference Dockerfile 参考](https://docs.docker.com/reference/dockerfile/)
- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)
- [Build with Docker guide
  使用 Docker 构建指南](https://docs.docker.com/build/guide/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/02_our_app/#next-steps)

Next, you're going to make a modification to your app and learn how to update your running application with a new image. Along the way, you'll learn a few other useful commands.

# Update the application 更新应用程序

In [part 2](https://docs.docker.com/guides/workshop/02_our_app/), you containerized a todo application. In this part, you'll update the  application and image. You'll also learn how to stop and remove a  container.
在第 2 部分中，您容器化了一个待办事项应用程序。在本部分中，您将更新应用程序和映像。您还将学习如何停止和移除容器。

## [Update the source code 更新源代码](https://docs.docker.com/guides/workshop/03_updating_app/#update-the-source-code)

In the following steps, you'll change the "empty text" when you don't have any todo list items to "You have no todo items yet! Add one above!"
在以下步骤中，您将在没有任何待办事项列表项时将“空文本”更改为“您还没有待办事项！在上面加一个！

1. In the `src/static/js/app.js` file, update line 56 to use the new empty text.
   在 `src/static/js/app.js` 文件中，更新第 56 行以使用新的空文本。

```diff
- <p className="text-center">No items yet! Add one above!</p>
+ <p className="text-center">You have no todo items yet! Add one above!</p>
```

Build your updated version of the image, using the `docker build` command.
使用命令 `docker build` 构建映像的更新版本。

```console
 docker build -t getting-started .
```

Start a new container using the updated code.
使用更新的代码启动新容器。

1. ```console
    docker run -dp 127.0.0.1:3000:3000 getting-started
   ```

You probably saw an error like this:
您可能看到过如下错误：

```console
docker: Error response from daemon: driver failed programming external connectivity on endpoint laughing_burnell 
(bb242b2ca4d67eba76e79474fb36bb5125708ebdabd7f45c8eaf16caaabde9dd): Bind for 127.0.0.1:3000 failed: port is already allocated.
```

The error occurred because you aren't able to start the new container while your old container is still running. The reason is that the old  container is already using the host's port 3000 and only one process on  the machine (containers included) can listen to a specific port. To fix  this, you need to remove the old container.
发生此错误的原因是，在旧容器仍在运行时，无法启动新容器。原因是旧容器已经在使用主机的端口 3000，并且机器上只有一个进程（包括容器）可以监听特定端口。要解决此问题，您需要删除旧容器。

## [Remove the old container 移除旧容器](https://docs.docker.com/guides/workshop/03_updating_app/#remove-the-old-container)

To remove a container, you first need to stop it. Once it has stopped, you can remove it. You can remove the old container using the CLI or Docker Desktop's graphical interface. Choose the option that you're most  comfortable with.
要删除容器，首先需要停止它。一旦它停止，您可以将其删除。您可以使用 CLI 或 Docker Desktop 的图形界面删除旧容器。选择您最熟悉的选项。

------

### [Remove a container using the CLI 使用 CLI 删除容器](https://docs.docker.com/guides/workshop/03_updating_app/#remove-a-container-using-the-cli)

1. Get the ID of the container by using the `docker ps` command.
   使用命令 `docker ps` 获取容器的 ID。

```console
 docker ps
```

Use the `docker stop` command to stop the container. Replace `<the-container-id>` with the ID from `docker ps`.
使用命令 `docker stop` 停止容器。替换为 `<the-container-id>` 中的 `docker ps` ID。

```console
 docker stop <the-container-id>
```

Once the container has stopped, you can remove it by using the `docker rm` command.
容器停止后，可以使用命令 `docker rm` 将其删除。



1. ```console
    docker rm <the-container-id>
   ```

> **Note 注意**
>
> You can stop and remove a container in a single command by adding the `force` flag to the `docker rm` command. For example: `docker rm -f <the-container-id>`
> 您可以通过向 `docker rm` 命令添加 `force` 标志来在单个命令中停止和删除容器。例如： `docker rm -f <the-container-id>` 

------

### [Start the updated app container 启动更新的应用容器](https://docs.docker.com/guides/workshop/03_updating_app/#start-the-updated-app-container)

1. Now, start your updated app using the `docker run` command.
   现在，使用命令启动更新的应用程序 `docker run` 。

```console
 docker run -dp 127.0.0.1:3000:3000 getting-started
```

Refresh your browser on http://localhost:3000

1.  and you should see your updated help text.
   在 http://localhost:3000 上刷新浏览器，您应该会看到更新的帮助文本。

## [Summary 总结](https://docs.docker.com/guides/workshop/03_updating_app/#summary)

In this section, you learned how to update and rebuild a container, as well as how to stop and remove a container.
在本部分中，您学习了如何更新和重建容器，以及如何停止和删除容器。

Related information: 相关信息：

- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/03_updating_app/#next-steps)

Next, you'll learn how to share images with others.
接下来，您将学习如何与他人共享图像。

[Share the application 共享应用程序](https://docs.docker.com/guides/workshop/04_sharing_app/)

# Share the application 共享应用程序

Now that you've built an image, you can share it. To share Docker images, you have to use a Docker registry. The default registry is Docker Hub and is where all of the images you've used have come from.
现在，您已经构建了映像，可以共享它。要共享 Docker 镜像，您必须使用 Docker 注册表。默认注册表是 Docker Hub，您使用的所有映像都来自此。

> **Docker ID**
>
> A Docker ID lets you access Docker Hub, which is the world's largest library and community for container images. Create a [Docker ID](https://hub.docker.com/signup)

>  for free if you don't have one.
> Docker ID 允许您访问 Docker Hub，这是世界上最大的容器镜像库和社区。如果您没有 Docker ID，可以免费创建一个 Docker ID。

## [Create a repository 创建仓库](https://docs.docker.com/guides/workshop/04_sharing_app/#create-a-repository)

To push an image, you first need to create a repository on Docker Hub.
要推送镜像，首先需要在 Docker Hub 上创建一个仓库。

1. [Sign up](https://www.docker.com/pricing?utm_source=docker&utm_medium=webreferral&utm_campaign=docs_driven_upgrade)

 or Sign in to [Docker Hub](https://hub.docker.com)

1. .
   注册或登录 Docker Hub。
2. Select the **Create Repository** button.
   选择“创建存储库”按钮。
3. For the repository name, use `getting-started`. Make sure the **Visibility** is **Public**.
   对于存储库名称，请使用 `getting-started` 。确保“可见性”为“公开”。
4. Select **Create**. 选择“创建”。

In the following image, you can see an example Docker command from Docker Hub. This command will push to this repository.
在下图中，您可以看到 Docker Hub 中的示例 Docker 命令。此命令将推送到此存储库。

![Docker command with push example](https://docs.docker.com/guides/workshop/images/push-command.webp)

## [Push the image 推送镜像](https://docs.docker.com/guides/workshop/04_sharing_app/#push-the-image)

1. In the command line, run the `docker push` command that you see on Docker Hub. Note that your command will have your Docker ID, not "docker". For example, `docker push YOUR-USER-NAME/getting-started`.
   在命令行中，运行在 Docker Hub 上看到 `docker push` 的命令。请注意，您的命令将具有您的 Docker ID，而不是“docker”。例如， `docker push YOUR-USER-NAME/getting-started` .

   

```console
 docker push docker/getting-started
The push refers to repository [docker.io/docker/getting-started]
An image does not exist locally with the tag: docker/getting-started
```

Why did it fail? The push command was looking for an image named `docker/getting-started`, but didn't find one. If you run `docker image ls`, you won't see one either.
为什么会失败？push 命令正在查找名为 `docker/getting-started` 的图像，但没有找到。如果你跑， `docker image ls` 你也不会看到一个。

To fix this, you need to tag your existing image you've built to give it another name.
要解决此问题，您需要标记已构建的现有图像，以为其指定另一个名称。

Sign in to Docker Hub using the command `docker login -u YOUR-USER-NAME`.
使用命令 `docker login -u YOUR-USER-NAME` 登录到 Docker Hub。

Use the `docker tag` command to give the `getting-started` image a new name. Replace `YOUR-USER-NAME` with your Docker ID.
使用该 `docker tag` 命令为 `getting-started` 映像指定新名称。替换为 `YOUR-USER-NAME` 您的 Docker ID。



```console
 docker tag getting-started YOUR-USER-NAME/getting-started
```

Now run the `docker push` command again. If you're copying the value from Docker Hub, you can drop the `tagname` part, as you didn't add a tag to the image name. If you don't specify a tag, Docker uses a tag called `latest`.
现在再次运行该 `docker push` 命令。如果要从 Docker Hub 复制值，则可以删除该 `tagname` 部分，因为您没有向映像名称添加标记。如果未指定标签，Docker 将使用名为 `latest` 的标签。

1. ```console
    docker push YOUR-USER-NAME/getting-started
   ```

## [Run the image on a new instance 在新实例上运行映像](https://docs.docker.com/guides/workshop/04_sharing_app/#run-the-image-on-a-new-instance)

Now that your image has been built and pushed into a registry, try running your app on a brand new instance that has never seen this container image. To do this, you will use Play with Docker.
现在，您的映像已生成并推送到注册表中，请尝试在从未见过此容器映像的全新实例上运行您的应用。为此，您将使用 Play with Docker。

> **Note 注意**
>
> Play with Docker uses the amd64 platform. If you are using an ARM based Mac  with Apple silicon, you will need to rebuild the image to be compatible  with Play with Docker and push the new image to your repository.
> Play with Docker 使用 amd64 平台。如果您使用的是带有 Apple 芯片的基于 ARM 的 Mac，则需要重建映像以与 Play with Docker 兼容，并将新映像推送到您的存储库。
>
> To build an image for the amd64 platform, use the `--platform` flag.
> 要为 amd64 平台构建映像，请使用 `--platform` 该标志。

> ```console
>  docker build --platform linux/amd64 -t YOUR-USER-NAME/getting-started .
> ```
>
> Docker buildx also supports building multi-platform images. To learn more, see [Multi-platform images](https://docs.docker.com/build/building/multi-platform/).
> Docker buildx 还支持构建多平台镜像。若要了解详细信息，请参阅多平台映像。

1. Open your browser to [Play with Docker](https://labs.play-with-docker.com/)

.
打开浏览器以使用 Docker。

Select **Login** and then select **docker** from the drop-down list.
选择“登录”，然后从下拉列表中选择“docker”。

Sign in with your Docker Hub account and then select **Start**.
使用 Docker Hub 帐户登录，然后选择“开始”。

Select the **ADD NEW INSTANCE** option on the left side bar. If you don't see it, make your browser a  little wider. After a few seconds, a terminal window opens in your  browser.
在左侧栏上选择 ADD NEW INSTANCE 选项。如果您看不到它，请将浏览器变宽一些。几秒钟后，浏览器中会打开一个终端窗口。

![Play with Docker add new instance](https://docs.docker.com/guides/workshop/images/pwd-add-new-instance.webp)

In the terminal, start your freshly pushed app.
在终端中，启动您新推送的应用程序。



1. ```console
    docker run -dp 0.0.0.0:3000:3000 YOUR-USER-NAME/getting-started
   ```

   You should see the image get pulled down and eventually start up.
   您应该看到图像被拉下并最终启动。

   > **Tip 提示**
   >
   > You may have noticed that this command binds the port mapping to a different IP address. Previous `docker run` commands published ports to `127.0.0.1:3000` on the host. This time, you're using `0.0.0.0`.
   > 您可能已经注意到，此命令将端口映射绑定到不同的 IP 地址。先前 `docker run` 的命令将端口发布到 `127.0.0.1:3000` 主机上。这一次，您正在使用 `0.0.0.0` .
   >
   > Binding to `127.0.0.1` only exposes a container's ports to the loopback interface. Binding to `0.0.0.0`, however, exposes the container's port on all interfaces of the host, making it available to the outside world.
   > 绑定到 `127.0.0.1` 仅将容器的端口公开给环回接口。但是，绑定到 `0.0.0.0` ，会在主机的所有接口上公开容器的端口，使其对外部世界可用。
   >
   > For more information about how port mapping works, see [Networking](https://docs.docker.com/network/#published-ports).
   > 有关端口映射工作原理的详细信息，请参阅网络。

2. Select the 3000 badge when it appears.
   当 3000 标志出现时，请选择它。

   If the 3000 badge doesn't appear, you can select **Open Port** and specify `3000`.
   如果未显示 3000 标志，您可以选择“打开端口”并指定 `3000` 。

## [Summary 总结](https://docs.docker.com/guides/workshop/04_sharing_app/#summary)

In this section, you learned how to share your images by pushing them to a registry. You then went to a brand new instance and were able to run the freshly pushed image. This is quite common in CI pipelines, where the pipeline will create the image and push it to a registry and then the production environment can use the latest version of the image.
在本节中，您学习了如何通过将图像推送到注册表来共享图像。然后，您转到了一个全新的实例，并能够运行新推送的图像。这在 CI 管道中很常见，其中管道将创建映像并将其推送到注册表，然后生产环境可以使用最新版本的映像。

Related information: 相关信息：

- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)
- [Multi-platform images 多平台图像](https://docs.docker.com/build/building/multi-platform/)
- [Docker Hub overview Docker Hub 概述](https://docs.docker.com/docker-hub/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/04_sharing_app/#next-steps)

In the next section, you'll learn how to persist data in your containerized application.
在下一节中，您将学习如何在容器化应用程序中保留数据。

[Persist the DB 持久化数据库](https://docs.docker.com/guides/workshop/05_persisting_data/)

# Persist the DB 持久化数据库

In case you didn't notice, your todo list is empty every single time you launch the container. Why is this? In this part, you'll dive into how the container is working.
如果你没有注意到，每次启动容器时，你的待办事项列表都是空的。为什么会这样？在这一部分中，您将深入了解容器的工作原理。

## [The container's filesystem 容器的文件系统](https://docs.docker.com/guides/workshop/05_persisting_data/#the-containers-filesystem)

When a container runs, it uses the various layers from an image for its filesystem. Each container also gets its own "scratch space" to create/update/remove files. Any changes won't be seen in another container, even if they're using the same image.
当容器运行时，它使用图像中的各个层作为其文件系统。每个容器还拥有自己的“暂存空间”来创建/更新/删除文件。任何更改都不会在另一个容器中看到，即使它们使用相同的图像也是如此。

### [See this in practice 在实践中看到这一点](https://docs.docker.com/guides/workshop/05_persisting_data/#see-this-in-practice)

To see this in action, you're going to start two containers. In one  container, you'll create a file. In the other container, you'll verify  the file exists. What you'll see is that the file created in one container isn't  available in another.
要查看此操作，您将启动两个容器。在一个容器中，您将创建一个文件。在另一个容器中，您将验证文件是否存在。您将看到的是，在一个容器中创建的文件在另一个容器中不可用。

1. Start an Alpine container and access its shell.
   启动 Alpine 容器并访问其 shell。

   

```console
 docker run -ti --name=mytest alpine
```

In the container, create a `greeting.txt` file with `hello` inside.
在容器中，创建一个 `greeting.txt` 包含 `hello` inside 的文件。

```console
/ # echo "hello" > greeting.txt
```

Exit the container. 退出容器。



```console
/ # exit
```

Run a new Alpine container and use the `cat` command to verify that the file does not exist.
运行新的 Alpine 容器，并使用命令 `cat` 验证该文件不存在。



```console
 docker run alpine cat greeting.txt
```

You should see output similar to the following that indicates the file does not exist in the new container.
您应该会看到类似于以下内容的输出，该输出指示文件在新容器中不存在。

1. ```console
   cat: can't open 'greeting.txt': No such file or directory
   ```

2. Go ahead and remove the containers using `docker ps --all` to get the IDs, and then `docker rm -f <container-id>` to remove the containers.
   继续删除用于获取 ID 的容器 `docker ps --all` ，然后 `docker rm -f <container-id>` 删除容器。

## [Container volumes 容器体积](https://docs.docker.com/guides/workshop/05_persisting_data/#container-volumes)

With the previous experiment, you saw that each container starts from the image definition each time it starts. While containers can create, update, and delete files, those changes are lost when you remove the container and Docker isolates all changes to that container. With volumes, you can change all of this.
在上一个实验中，你看到每个容器每次启动时都从映像定义开始。虽然容器可以创建、更新和删除文件，但在删除容器时，这些更改会丢失，并且 Docker 会隔离对该容器的所有更改。使用卷，您可以更改所有这些。

[Volumes](https://docs.docker.com/storage/volumes/) provide the ability to connect specific filesystem paths of the container back to the host machine. If you mount a directory in the container, changes in that directory are also seen on the host machine. If you mount that same directory across container restarts, you'd see the same files.
卷提供了将容器的特定文件系统路径连接回主机的功能。如果在容器中挂载目录，则在主机上也会看到该目录中的更改。如果在容器重启时挂载同一目录，则会看到相同的文件。

There are two main types of volumes. You'll eventually use both, but you'll start with volume mounts.
有两种主要类型的卷。您最终将同时使用两者，但您将从卷装载开始。

## [Persist the todo data 保留待办事项数据](https://docs.docker.com/guides/workshop/05_persisting_data/#persist-the-todo-data)

By default, the todo app stores its data in a SQLite database at `/etc/todos/todo.db` in the container's filesystem. If you're not familiar with SQLite, no  worries! It's simply a relational database that stores all the data in a single file. While this isn't the best for large-scale applications, it works for small demos. You'll learn how to switch this to a different database engine later.
默认情况下，todo 应用将其数据存储在容器文件系统 `/etc/todos/todo.db` 中的 SQLite 数据库中。如果您不熟悉SQLite，不用担心！它只是一个关系数据库，将所有数据存储在一个文件中。虽然这对于大型应用程序来说不是最好的，但它适用于小型演示。稍后，您将学习如何将其切换到不同的数据库引擎。

With the database being a single file, if you can persist that file on the host and make it available to the next container, it should be able to pick up where the last one left off. By creating a volume and attaching (often called "mounting") it to the directory where you stored the data, you can persist the data. As your container writes to the `todo.db` file, it will persist the data to the host in the volume.
由于数据库是单个文件，如果可以将该文件保留在主机上，并使其可用于下一个容器，则它应该能够从最后一个中断的地方继续。通过创建卷并将其附加（通常称为“挂载”）到存储数据的目录，您可以持久保存数据。当容器写入 `todo.db` 文件时，它会将数据保存到卷中的主机。

As mentioned, you're going to use a volume mount. Think of a volume mount as an opaque bucket of data. Docker fully manages the volume, including the storage location on disk. You only need to remember the name of the volume.
如前所述，您将使用卷挂载。将卷挂载视为不透明的数据桶。Docker 完全管理卷，包括磁盘上的存储位置。您只需要记住卷的名称。

### [Create a volume and start the container 创建卷并启动容器](https://docs.docker.com/guides/workshop/05_persisting_data/#create-a-volume-and-start-the-container)

You can create the volume and start the container using the CLI or Docker Desktop's graphical interface.
您可以使用 CLI 或 Docker Desktop 的图形界面创建卷并启动容器。

------

1. Create a volume by using the `docker volume create` command.
   使用命令 `docker volume create` 创建卷。

   

```console
 docker volume create todo-db
```

Stop and remove the todo app container once again with `docker rm -f <id>`, as it is still running without using the persistent volume.
使用 `docker rm -f <id>` 再次停止并删除 todo 应用容器，因为它仍在运行而不使用持久卷。

Start the todo app container, but add the `--mount` option to specify a volume mount. Give the volume a name, and mount it to `/etc/todos` in the container, which captures all files created at the path.
启动 todo 应用容器，但添加用于 `--mount` 指定卷装载的选项。为卷命名，并将其装载到 `/etc/todos` 容器中，该容器会捕获在路径中创建的所有文件。

```console
 docker run -dp 127.0.0.1:3000:3000 --mount type=volume,src=todo-db,target=/etc/todos getting-started
```

> **Note 注意**
>
> If you're using Git Bash, you must use different syntax for this command.
> 如果您使用的是 Git Bash，则必须对此命令使用不同的语法。

1. > ```console
   >  docker run -dp 127.0.0.1:3000:3000 --mount type=volume,src=todo-db,target=//etc/todos getting-started
   > ```
   >
   > For more details about Git Bash's syntax differences, see [Working with Git Bash](https://docs.docker.com/desktop/troubleshoot/topics/#working-with-git-bash).
   > 有关 Git Bash 语法差异的更多详细信息，请参阅使用 Git Bash。

------

### [Verify that the data persists 验证数据是否仍然存在](https://docs.docker.com/guides/workshop/05_persisting_data/#verify-that-the-data-persists)

1. Once the container starts up, open the app and add a few items to your todo list.
   容器启动后，打开应用程序并将一些项目添加到您的待办事项列表中。

   ![Items added to todo list](https://docs.docker.com/guides/workshop/images/items-added.webp)

2. Stop and remove the container for the todo app. Use Docker Desktop or `docker ps` to get the ID and then `docker rm -f <id>` to remove it.
   停止并删除待办事项应用的容器。 使用 Docker Desktop 或 `docker ps` 获取 ID，然后 `docker rm -f <id>` 将其删除。

3. Start a new container using the previous steps.
   使用前面的步骤启动一个新容器。

4. Open the app. You should see your items still in your list.
   打开应用程序。您应该看到您的项目仍在列表中。

5. Go ahead and remove the container when you're done checking out your list.
   在完成签出列表后，继续删除容器。

You've now learned how to persist data.
现在，您已经学习了如何持久保存数据。

## [Dive into the volume 深入了解该卷](https://docs.docker.com/guides/workshop/05_persisting_data/#dive-into-the-volume)

A lot of people frequently ask "Where is Docker storing my data when I use a volume?" If you want to know, you can use the `docker volume inspect` command.
很多人经常问“当我使用卷时，Docker 在哪里存储我的数据？如果你想知道，你可以使用命令 `docker volume inspect` 。



```console
 docker volume inspect todo-db
```

You should see output like the following:
您应看到如下所示的输出：

```console
[
    {
        "CreatedAt": "2019-09-26T02:18:36Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/todo-db/_data",
        "Name": "todo-db",
        "Options": {},
        "Scope": "local"
    }
]
```

The `Mountpoint` is the actual location of the data on the disk. Note that on most machines, you will need to have root access to access this directory from the host.
是 `Mountpoint` 数据在磁盘上的实际位置。请注意，在大多数计算机上，您需要具有 root 访问权限才能从主机访问此目录。

## [Summary 总结](https://docs.docker.com/guides/workshop/05_persisting_data/#summary)

In this section, you learned how to persist container data.
在本节中，您学习了如何保留容器数据。

Related information: 相关信息：

- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)
- [Volumes 卷](https://docs.docker.com/storage/volumes/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/05_persisting_data/#next-steps)

Next, you'll learn how you can develop your app more efficiently using bind mounts.
接下来，您将学习如何使用绑定挂载更高效地开发应用程序。

# Use bind mounts 使用绑定挂载

In [part 5](https://docs.docker.com/guides/workshop/05_persisting_data/), you used a volume mount to persist the data in your database. A volume mount is a great choice when you need somewhere persistent to store your application data.
在第 5 部分中，您使用卷挂载将数据持久化到数据库中。当您需要某个持久的位置来存储应用程序数据时，卷挂载是一个不错的选择。

A bind mount is another type of mount, which lets you share a directory from the host's filesystem into the container. When working on an application, you can use a bind mount to mount source code into the container. The container sees the changes you make to the code immediately, as soon as you save a file. This means that you can run processes in the container that watch for filesystem changes and respond to them.
绑定挂载是另一种类型的挂载，它允许您将主机文件系统中的目录共享到容器中。在处理应用程序时，可以使用绑定挂载将源代码挂载到容器中。一旦您保存文件，容器就会立即看到您对代码所做的更改。这意味着您可以在容器中运行进程，这些进程监视文件系统更改并响应它们。

In this chapter, you'll see how you can use bind mounts and a tool called [nodemon](https://npmjs.com/package/nodemon)

 to watch for file changes, and then restart the application automatically. There are equivalent tools in most other languages and frameworks.
在本章中，您将了解如何使用绑定挂载和名为 nodemon 的工具来监视文件更改，然后自动重新启动应用程序。在大多数其他语言和框架中都有等效的工具。

## [Quick volume type comparisons 快速卷类型比较](https://docs.docker.com/guides/workshop/06_bind_mounts/#quick-volume-type-comparisons)

The following are examples of a named volume and a bind mount using `--mount`:
以下是命名卷和绑定挂载的示例 `--mount` ：

- Named volume: `type=volume,src=my-volume,target=/usr/local/data` 命名卷： `type=volume,src=my-volume,target=/usr/local/data` 
- Bind mount: `type=bind,src=/path/to/data,target=/usr/local/data` 绑定挂载： `type=bind,src=/path/to/data,target=/usr/local/data` 

The following table outlines the main differences between volume mounts and bind mounts.
下表概述了卷挂载和绑定挂载之间的主要区别。

|                                                              | Named volumes 命名卷       | Bind mounts 绑定挂载 |
| ------------------------------------------------------------ | -------------------------- | -------------------- |
| Host location 主机位置                                       | Docker chooses Docker 选择 | You decide 由您决定  |
| Populates new volume with container contents 使用容器内容填充新卷 | Yes 是的                   | No 不                |
| Supports Volume Drivers 支持音量驱动程序                     | Yes 是的                   | No 不                |

## [Trying out bind mounts 尝试绑定挂载](https://docs.docker.com/guides/workshop/06_bind_mounts/#trying-out-bind-mounts)

Before looking at how you can use bind mounts for developing your application, you can run a quick experiment to get a practical understanding of how bind mounts work.
在了解如何使用绑定挂载来开发应用程序之前，您可以运行一个快速实验，以实际了解绑定挂载的工作原理。

1. Verify that your `getting-started-app` directory is in a directory defined in Docker Desktop's file sharing setting. This setting defines which parts of your filesystem you can share with containers. For details about accessing the setting, see the topic for [Mac](https://docs.docker.com/desktop/settings/mac/#file-sharing), [Windows](https://docs.docker.com/desktop/settings/windows/#file-sharing), or [Linux](https://docs.docker.com/desktop/settings/linux/#file-sharing).
   验证您的 `getting-started-app` 目录是否位于 Docker Desktop 的文件共享设置中定义的目录中。此设置定义了文件系统的哪些部分可以与容器共享。有关访问设置的详细信息，请参阅适用于 Mac、Windows 或 Linux 的主题。
2. Open a terminal and change directory to the `getting-started-app` directory.
   打开一个终端，将目录更改为该 `getting-started-app` 目录。
3. Run the following command to start `bash` in an `ubuntu` container with a bind mount.
   运行以下命令，在具有绑定挂载的 `ubuntu` 容器中启动 `bash` 。

------



```console
 docker run -it --mount type=bind,src="$(pwd)",target=/src ubuntu bash
```

------

The `--mount type=bind` option tells Docker to create a bind mount, where `src` is the current working directory on your host machine (`getting-started-app`), and `target` is where that directory should appear inside the container (`/src`).
该 `--mount type=bind` 选项告诉 Docker 创建一个绑定挂载， `src` 其中主机上的当前工作目录 （ `getting-started-app` ） 以及 `target` 该目录应出现在容器内的位置 （ `/src` ）。

After running the command, Docker starts an interactive `bash` session in the root directory of the container's filesystem.
运行该命令后，Docker 会在容器文件系统的根目录中启动交互式 `bash` 会话。



```console
root@ac1237fad8db:/# pwd
/
root@ac1237fad8db:/# ls
bin   dev  home  media  opt   root  sbin  srv  tmp  var
boot  etc  lib   mnt    proc  run   src   sys  usr
```

Change directory to the `src` directory.
将目录更改为目录 `src` 。

This is the directory that you mounted when starting the container. Listing the contents of this directory displays the same files as in the `getting-started-app` directory on your host machine.
这是您在启动容器时挂载的目录。列出此目录的内容将显示与主机上目录中 `getting-started-app` 的文件相同的文件。

```console
root@ac1237fad8db:/# cd src
root@ac1237fad8db:/src# ls
Dockerfile  node_modules  package.json  spec  src  yarn.lock
```

Create a new file named `myfile.txt`.
创建一个名为 `myfile.txt` 的新文件。

```console
root@ac1237fad8db:/src# touch myfile.txt
root@ac1237fad8db:/src# ls
Dockerfile  myfile.txt  node_modules  package.json  spec  src  yarn.lock
```

Open the `getting-started-app` directory on the host and observe that the `myfile.txt` file is in the directory.
在主机上打开该 `getting-started-app` 目录，并观察 `myfile.txt` 该文件是否位于该目录中。



```text
├── getting-started-app/
│ ├── Dockerfile
│ ├── myfile.txt
│ ├── node_modules/
│ ├── package.json
│ ├── spec/
│ ├── src/
│ └── yarn.lock
```

From the host, delete the `myfile.txt` file.
在主机中，删除该文件 `myfile.txt` 。

In the container, list the contents of the `app` directory once more. Observe that the file is now gone.
在容器中，再次列出 `app` 目录的内容。请注意，该文件现在已消失。



1. ```console
   root@ac1237fad8db:/src# ls
   Dockerfile  node_modules  package.json  spec  src  yarn.lock
   ```

2. Stop the interactive container session with `Ctrl` + `D`.
   使用 + `D` 停止 `Ctrl` 交互式容器会话。

That's all for a brief introduction to bind mounts. This procedure demonstrated how files are shared between the host and the container, and how changes are immediately reflected on both sides. Now you can use bind mounts to develop software.
以上就是对绑定挂载的简要介绍。此过程演示了如何在主机和容器之间共享文件，以及如何立即在两端反映更改。现在，您可以使用绑定挂载来开发软件。

## [Development containers 开发容器](https://docs.docker.com/guides/workshop/06_bind_mounts/#development-containers)

Using bind mounts is common for local development setups. The advantage is  that the development machine doesn’t need to have all of the build tools and environments installed. With a single docker run command, Docker  pulls dependencies and tools.
对于本地开发设置，使用绑定挂载是很常见的。优点是开发计算机不需要安装所有生成工具和环境。使用单个 docker run 命令，Docker 可以拉取依赖项和工具。

### [Run your app in a development container 在开发容器中运行应用](https://docs.docker.com/guides/workshop/06_bind_mounts/#run-your-app-in-a-development-container)

The following steps describe how to run a development container with a bind mount that does the following:
以下步骤介绍如何使用绑定挂载运行开发容器，该容器执行以下操作：

- Mount your source code into the container
  将源代码挂载到容器中
- Install all dependencies 安装所有依赖项
- Start `nodemon` to watch for filesystem changes
  开始 `nodemon` 监视文件系统更改

You can use the CLI or Docker Desktop to run your container with a bind mount.
您可以使用 CLI 或 Docker Desktop 通过绑定挂载来运行容器。

------

1. Make sure you don't have any `getting-started` containers currently running.
   请确保当前没有正在运行任何 `getting-started` 容器。

2. Run the following command from the `getting-started-app` directory.
   从目录 `getting-started-app` 运行以下命令。

   

```console
 docker run -dp 127.0.0.1:3000:3000 \
    -w /app --mount type=bind,src="$(pwd)",target=/app \
    node:18-alpine \
    sh -c "yarn install && yarn run dev"
```

The following is a breakdown of the command:
以下是该命令的细分：

- `-dp 127.0.0.1:3000:3000` - same as before. Run in detached (background) mode and create a port mapping
   `-dp 127.0.0.1:3000:3000` - 和以前一样。在分离（后台）模式下运行并创建端口映射
- `-w /app` - sets the "working directory" or the current directory that the command will run from
   `-w /app` - 设置“工作目录”或运行命令的当前目录
- `--mount type=bind,src="$(pwd)",target=/app` - bind mount the current directory from the host into the `/app` directory in the container
   `--mount type=bind,src="$(pwd)",target=/app` - 将主机上的当前目录挂载到容器中的 `/app` 目录中进行绑定
- `node:18-alpine` - the image to use. Note that this is the base image for your app from the Dockerfile
   `node:18-alpine` - 要使用的图像。请注意，这是 Dockerfile 中应用的基础图像
- `sh -c "yarn install && yarn run dev"` - the command. You're starting a shell using `sh` (alpine doesn't have `bash`) and running `yarn install` to install packages and then running `yarn run dev` to start the development server. If you look in the `package.json`, you'll see that the `dev` script starts `nodemon`.
   `sh -c "yarn install && yarn run dev"` - 命令。您正在使用 `sh` （alpine没有 `bash` ）启动shell并运行 `yarn install` 以安装包，然后运行 `yarn run dev` 以启动开发服务器。如果你查看 `package.json` ，你会看到脚本开始 `nodemon` 。 `dev` 

You can watch the logs using `docker logs <container-id>`. You'll know you're ready to go when you see this:
您可以使用 查看日志 `docker logs <container-id>` 。当你看到这个时，你就会知道你已经准备好了：

1. ```console
    docker logs -f <container-id>
   nodemon -L src/index.js
   [nodemon] 2.0.20
   [nodemon] to restart at any time, enter `rs`
   [nodemon] watching path(s): *.*
   [nodemon] watching extensions: js,mjs,json
   [nodemon] starting `node src/index.js`
   Using sqlite database at /etc/todos/todo.db
   Listening on port 3000
   ```

   When you're done watching the logs, exit out by hitting `Ctrl`+`C`.
   当您看完日志后，点击 `Ctrl` + `C` 退出。

------

### [Develop your app with the development container 使用开发容器开发应用](https://docs.docker.com/guides/workshop/06_bind_mounts/#develop-your-app-with-the-development-container)

Update your app on your host machine and see the changes reflected in the container.
在主机上更新应用，并查看容器中反映的更改。

1. In the `src/static/js/app.js` file, on line 109, change the "Add Item" button to simply say "Add":
   在 `src/static/js/app.js` 文件的第 109 行，将“添加项目”按钮更改为“添加”：

   

```diff
- {submitting ? 'Adding...' : 'Add Item'}
+ {submitting ? 'Adding...' : 'Add'}
```

Save the file. 保存文件。

Refresh the page in your web browser, and you should see the change reflected almost immediately because of the bind mount. Nodemon detects the change and restarts the server. It might take a few seconds for the Node server to restart. If you get an error, try refreshing after a few seconds.
在 Web 浏览器中刷新页面，由于绑定挂载，您应该几乎立即看到更改。Nodemon 检测到更改并重新启动服务器。Node 服务器可能需要几秒钟才能重新启动。如果出现错误，请在几秒钟后尝试刷新。

![Screenshot of updated label for Add button](https://docs.docker.com/guides/workshop/images/updated-add-button.webp)

Feel free to make any other changes you'd like to make. Each time you make a change and save a file, the change is reflected in the container because of the bind mount. When Nodemon detects a change, it restarts the app inside the container automatically. When you're done, stop the container and build your new image using:
您可以随意进行您想要进行的任何其他更改。每次进行更改并保存文件时，由于绑定挂载，更改都会反映在容器中。当 Nodemon 检测到更改时，它会自动重新启动容器内的应用程序。完成后，停止容器并使用以下方法生成新映像：

1. ```console
    docker build -t getting-started .
   ```

## [Summary 总结](https://docs.docker.com/guides/workshop/06_bind_mounts/#summary)

At this point, you can persist your database and see changes in your app as you develop without rebuilding the image.
此时，您可以保留数据库，并在开发过程中查看应用中的更改，而无需重新生成映像。

In addition to volume mounts and bind mounts, Docker also supports other mount types and storage drivers for handling more complex and specialized use cases.
除了卷挂载和绑定挂载之外，Docker 还支持其他挂载类型和存储驱动程序，以处理更复杂和专业的用例。

Related information: 相关信息：

- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)
- [Manage data in Docker
  在 Docker 中管理数据](https://docs.docker.com/storage/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/06_bind_mounts/#next-steps)

In order to prepare your app for production, you need to migrate your database from working in SQLite to something that can scale a little better. For simplicity, you'll keep using a relational database and switch your application to use MySQL. But, how should you run MySQL? How do you allow the containers to talk to each other? You'll learn about that in the next section.
为了让您的应用程序为生产做好准备，您需要将数据库从在 SQLite 中工作迁移到可以更好地扩展的内容。为简单起见，您将继续使用关系数据库，并将应用程序切换为使用 MySQL。但是，你应该如何运行MySQL？如何让容器相互通信？您将在下一部分中了解这一点。

[Multi container apps 多容器应用](https://docs.docker.com/guides/workshop/07_multi_container/)

# Multi container apps 多容器应用

Up to this point, you've been working with single container apps. But, now you will add MySQL to the application stack. The following question often arises - "Where will  MySQL run? Install it in the same container or run it separately?" In general, each container should do  one thing and do it well. The following are a few reasons to run the  container separately:
到目前为止，你一直在使用单个容器应用。但是，现在您需要将 MySQL 添加到应用程序堆栈中。以下问题经常出现 - “MySQL将在哪里运行？将其安装在同一个容器中还是单独运行？一般来说，每个容器都应该做一件事，并且做得很好。以下是单独运行容器的几个原因：

- There's a good chance you'd have to scale APIs and front-ends differently than databases.
  很有可能您必须以不同于数据库的方式扩展 API 和前端。
- Separate containers let you version and update versions in isolation.
  通过单独的容器，您可以独立地对版本进行版本控制和更新。
- While you may use a container for the database locally, you may want to use a managed service for the database in production. You don't want to ship your database engine with your app then.
  虽然您可以在本地对数据库使用容器，但您可能希望在生产环境中对数据库使用托管服务。那时，您不想将数据库引擎与应用程序一起发布。
- Running multiple processes will require a process manager (the container only  starts one process), which adds complexity to container  startup/shutdown.
  运行多个进程将需要一个进程管理器（容器只启动一个进程），这增加了容器启动/关闭的复杂性。

And there are more reasons. So, like the following diagram, it's best to run your app in multiple containers.
还有更多原因。因此，如下图所示，最好在多个容器中运行应用。

![Todo App connected to MySQL container](https://docs.docker.com/guides/workshop/images/multi-container.webp)

## [Container networking 容器网络](https://docs.docker.com/guides/workshop/07_multi_container/#container-networking)

Remember that containers, by default, run in isolation and don't know anything about other processes or containers on the same machine. So, how do you allow one container to talk to another? The answer is networking. If you place the two containers on the same network, they can talk to each other.
请记住，默认情况下，容器是独立运行的，并且对同一台计算机上的其他进程或容器一无所知。那么，如何让一个容器与另一个容器通信呢？答案是网络。如果将两个容器放在同一个网络上，它们可以相互通信。

## [Start MySQL 启动 MySQL](https://docs.docker.com/guides/workshop/07_multi_container/#start-mysql)

There are two ways to put a container on a network:
有两种方法可以将容器放在网络上：

- Assign the network when starting the container.
  在启动容器时分配网络。
- Connect an already running container to a network.
  将已运行的容器连接到网络。

In the following steps, you'll create the network first and then attach the MySQL container at startup.
在以下步骤中，您将首先创建网络，然后在启动时附加 MySQL 容器。

1. Create the network. 创建网络。

```console
 docker network create todo-app
```

Start a MySQL container and attach it to the network. You're also going to  define a few environment variables that the database will use to initialize the database. To learn more about the  MySQL environment variables, see the "Environment Variables" section in  the [MySQL Docker Hub listing](https://hub.docker.com/_/mysql/)

.
启动 MySQL 容器并将其连接到网络。您还将定义一些环境变量，数据库将使用这些变量来初始化数据库。要了解有关 MySQL 环境变量的更多信息，请参阅 MySQL Docker Hub 列表中的“环境变量”部分。

------

```console
 docker run -d \
    --network todo-app --network-alias mysql \
    -v todo-mysql-data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=todos \
    mysql:8.0
```

------

In the previous command, you can see the `--network-alias` flag. In a later section, you'll learn more about this flag.
在上一个命令中，您可以看到标志 `--network-alias` 。在后面的部分中，你将了解有关此标志的详细信息。

> **Tip 提示**
>
> You'll notice a volume named `todo-mysql-data` in the above command that is mounted at `/var/lib/mysql`, which is where MySQL stores its data. However, you never ran a `docker volume create` command. Docker recognizes you want to use a named volume and creates one automatically for you.
> 您会注意到上述命令中命名 `todo-mysql-data` 的卷挂载在 `/var/lib/mysql` ，这是 MySQL 存储其数据的地方。但是，您从未运行过命令 `docker volume create` 。Docker 会识别出您想要使用命名卷，并自动为您创建一个命名卷。

To confirm you have the database up and running, connect to the database and verify that it connects.
若要确认数据库已启动并运行，请连接到数据库并验证它是否已连接。

```console
 docker exec -it <mysql-container-id> mysql -u root -p
```

When the password prompt comes up, type in `secret`. In the MySQL shell, list the databases and verify you see the `todos` database.
当密码提示出现时，输入 `secret` 。在 MySQL shell 中，列出数据库并验证是否看到了该 `todos` 数据库。



```console
mysql> SHOW DATABASES;
```

You should see output that looks like this:
您应看到如下所示的输出：

```plaintext
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| todos              |
+--------------------+
5 rows in set (0.00 sec)
```

Exit the MySQL shell to return to the shell on your machine.
退出 MySQL shell 以返回到计算机上的 shell。

1. ```console
   mysql> exit
   ```

   You now have a `todos` database and it's ready for you to use.
   现在，您已经有了一个 `todos` 数据库，可供您使用。

## [Connect to MySQL 连接到 MySQL](https://docs.docker.com/guides/workshop/07_multi_container/#connect-to-mysql)

Now that you know MySQL is up and running, you can use it. But, how do you use it? If you run another container on the same network, how do you find the container? Remember that each container has its own IP address.
现在您知道 MySQL 已启动并运行，您可以使用它。但是，你如何使用它？如果在同一网络上运行另一个容器，如何找到该容器？请记住，每个容器都有自己的 IP 地址。

To answer the questions above and better understand container networking, you're going to make use of the [nicolaka/netshoot](https://github.com/nicolaka/netshoot)

 container, which ships with a lot of tools that are useful for troubleshooting or debugging networking issues.
为了回答上述问题并更好地理解容器网络，您将使用 nicolaka/netshoot 容器，该容器附带了许多可用于故障排除或调试网络问题的工具。

1. Start a new container using the nicolaka/netshoot image. Make sure to connect it to the same network.
   使用 nicolaka/netshoot 镜像启动一个新容器。确保将其连接到同一网络。

   

```console
 docker run -it --network todo-app nicolaka/netshoot
```

Inside the container, you're going to use the `dig` command, which is a useful DNS tool. You're going to look up the IP address for the hostname `mysql`.
在容器内部，您将使用该 `dig` 命令，这是一个有用的 DNS 工具。您将查找主机名 `mysql` 的 IP 地址。



```console
 dig mysql
```

You should get output like the following.
您应该得到如下所示的输出。

1. ```text
   ; <<>> DiG 9.18.8 <<>> mysql
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32162
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
   
   ;; QUESTION SECTION:
   ;mysql.				IN	A
   
   ;; ANSWER SECTION:
   mysql.			600	IN	A	172.23.0.2
   
   ;; Query time: 0 msec
   ;; SERVER: 127.0.0.11#53(127.0.0.11)
   ;; WHEN: Tue Oct 01 23:47:24 UTC 2019
   ;; MSG SIZE  rcvd: 44
   ```

   In the "ANSWER SECTION", you will see an `A` record for `mysql` that resolves to `172.23.0.2` (your IP address will most likely have a different value). While `mysql` isn't normally a valid hostname, Docker was able to resolve it to the IP address of the container that had that network alias. Remember, you used the `--network-alias` earlier.
   在“答案部分”中，您将看到一条 `A` 解析为 `172.23.0.2` 的记录 `mysql` （您的 IP 地址很可能具有不同的值）。虽然通常不是有效的主机名，但 `mysql` Docker 能够将其解析为具有该网络别名的容器的 IP 地址。请记住，您之前使用过。 `--network-alias` 

   What this means is that your app only simply needs to connect to a host named `mysql` and it'll talk to the database.
   这意味着您的应用程序只需要连接到名为 `mysql` 的主机，它就会与数据库通信。

## [Run your app with MySQL 使用 MySQL 运行您的应用程序](https://docs.docker.com/guides/workshop/07_multi_container/#run-your-app-with-mysql)

The todo app supports the setting of a few environment variables to specify MySQL connection settings. They are:
todo 应用程序支持设置几个环境变量来指定 MySQL 连接设置。他们是：

- `MYSQL_HOST` - the hostname for the running MySQL server
   `MYSQL_HOST` - 正在运行的MySQL服务器的主机名
- `MYSQL_USER` - the username to use for the connection
   `MYSQL_USER` - 用于连接的用户名
- `MYSQL_PASSWORD` - the password to use for the connection
   `MYSQL_PASSWORD` - 用于连接的密码
- `MYSQL_DB` - the database to use once connected
   `MYSQL_DB` - 连接后要使用的数据库

> **Note 注意**
>
> While using env vars to set connection settings is generally accepted for development, it's highly discouraged when running applications in production. Diogo Monica, a former lead of security at Docker, [wrote a fantastic blog post](https://diogomonica.com/2017/03/27/why-you-shouldnt-use-env-variables-for-secret-data/)

> explaining why.
> 虽然使用 env vars 设置连接设置通常被接受用于开发，但在生产环境中运行应用程序时，强烈建议不要这样做。Diogo Monica 是 Docker 的前安全主管，他写了一篇精彩的博客文章，解释了原因。
>
> A more secure mechanism is to use the secret support provided by your container orchestration framework. In most cases, these secrets are mounted as files in the running container. You'll see many apps (including the MySQL image and the todo app) also support env vars with a `_FILE` suffix to point to a file containing the variable.
> 更安全的机制是使用容器编排框架提供的秘密支持。在大多数情况下，这些机密将作为文件装载到正在运行的容器中。您会看到许多应用程序（包括 MySQL 图像和 todo 应用程序）还支持带有 `_FILE` 后缀的 env vars，以指向包含变量的文件。
>
> As an example, setting the `MYSQL_PASSWORD_FILE` var will cause the app to use the contents of the referenced file as the connection password. Docker doesn't do anything to support these env vars. Your app will need to know to look for the variable and get the file contents.
> 例如，设置 `MYSQL_PASSWORD_FILE` var 将导致应用程序使用引用文件的内容作为连接密码。Docker 不做任何事情来支持这些环境变量。你的应用需要知道如何查找变量并获取文件内容。

You can now start your dev-ready container.
现在可以启动开发就绪容器。

1. Specify each of the previous environment variables, as well as connect the  container to your app network. Make sure that you are in the `getting-started-app` directory when you run this command.
   指定上述每个环境变量，并将容器连接到您的应用网络。请确保在运行此命令时位于目录中 `getting-started-app` 。

------

```console
 docker run -dp 127.0.0.1:3000:3000 \
  -w /app -v "$(pwd):/app" \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:18-alpine \
  sh -c "yarn install && yarn run dev"
```

------

If you look at the logs for the container (`docker logs -f <container-id>`), you should see a message similar to the following, which indicates it's using the mysql database.
如果您查看容器 （ `docker logs -f <container-id>` ） 的日志，您应该会看到类似于以下内容的消息，这表明它正在使用 mysql 数据库。



```console
 nodemon src/index.js
[nodemon] 2.0.20
[nodemon] to restart at any time, enter `rs`
[nodemon] watching dir(s): *.*
[nodemon] starting `node src/index.js`
Connected to mysql db at host mysql
Listening on port 3000
```

Open the app in your browser and add a few items to your todo list.
在浏览器中打开该应用程序，然后将一些项目添加到您的待办事项列表中。

Connect to the mysql database and prove that the items are being written to the database. Remember, the password is `secret`.
连接到 mysql 数据库，并证明项目正在写入数据库。请记住，密码是 `secret` 。

```console
 docker exec -it <mysql-container-id> mysql -p todos
```

And in the mysql shell, run the following:
在mysql shell中，运行以下内容：

1. ```console
   mysql> select * from todo_items;
   +--------------------------------------+--------------------+-----------+
   | id                                   | name               | completed |
   +--------------------------------------+--------------------+-----------+
   | c906ff08-60e6-44e6-8f49-ed56a0853e85 | Do amazing things! |         0 |
   | 2912a79e-8486-4bc3-a4c5-460793a575ab | Be awesome!        |         0 |
   +--------------------------------------+--------------------+-----------+
   ```

   Your table will look different because it has your items. But, you should see them stored there.
   你的桌子看起来会有所不同，因为它有你的物品。但是，您应该看到它们存储在那里。

## [Summary 总结](https://docs.docker.com/guides/workshop/07_multi_container/#summary)

At this point, you have an application that now stores its data in an external database running in a separate container. You learned a little bit about container networking and service discovery using DNS.
此时，您有一个应用程序，该应用程序现在将其数据存储在运行在单独容器中的外部数据库中。您学到了一些关于使用 DNS 的容器网络和服务发现的知识。

Related information: 相关信息：

- [docker CLI reference docker CLI 参考](https://docs.docker.com/reference/cli/docker/)
- [Networking overview 网络概述](https://docs.docker.com/network/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/07_multi_container/#next-steps)

There's a good chance you are starting to feel a little overwhelmed with everything you need to do to start up this application. You have to create a network, start containers, specify all of the environment variables, expose ports, and more. That's a lot to remember and it's certainly making things harder to pass along to someone else.
您很有可能开始对启动此应用程序所需做的一切感到有些不知所措。您必须创建网络、启动容器、指定所有环境变量、公开端口等。这需要记住很多东西，这肯定会使事情更难传递给其他人。

In the next section, you'll learn about Docker Compose. With Docker Compose, you can share your application stacks in a much easier way and let others spin them up with a single, simple command.
在下一节中，您将了解 Docker Compose。使用 Docker Compose，您可以以更简单的方式共享您的应用程序堆栈，并让其他人使用一个简单的命令来启动它们。

# Use Docker Compose 使用 Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is a tool that helps you define and share multi-container applications. With Compose, you can create a YAML file to define the services and with a single command, you can spin everything up or tear it all down.
Docker Compose 是一个工具，可帮助您定义和共享多容器应用程序。使用 Compose，您可以创建一个 YAML 文件来定义服务，并且只需一个命令，您就可以启动或关闭所有内容。

The big advantage of using Compose is you can define your application stack in a file, keep it at the root of your project repository (it's now version controlled), and easily enable someone else to contribute to your project. Someone would only need to clone your repository and start the app using Compose. In fact, you might see quite a few projects on GitHub/GitLab doing exactly this now.
使用 Compose  的最大优势是您可以在文件中定义应用程序堆栈，将其保存在项目存储库的根目录下（现在由版本控制），并轻松让其他人为您的项目做出贡献。有人只需要克隆您的仓库并使用 Compose 启动应用程序。事实上，你现在可能会在 GitHub/GitLab 上看到很多项目都在这样做。

## [Create the Compose file 创建 Compose 文件](https://docs.docker.com/guides/workshop/08_using_compose/#create-the-compose-file)

In the `getting-started-app` directory, create a file named `compose.yaml`.
在目录中 `getting-started-app` ，创建一个名为 `compose.yaml` 的文件。

```text
├── getting-started-app/
│ ├── Dockerfile
│ ├── compose.yaml
│ ├── node_modules/
│ ├── package.json
│ ├── spec/
│ ├── src/
│ └── yarn.lock
```

## [Define the app service 定义应用服务](https://docs.docker.com/guides/workshop/08_using_compose/#define-the-app-service)

In [part 7](https://docs.docker.com/guides/workshop/07_multi_container/), you used the following command to start the application service.
在第 7 部分中，您使用了以下命令来启动应用程序服务。

```console
 docker run -dp 127.0.0.1:3000:3000 \
  -w /app -v "$(pwd):/app" \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:18-alpine \
  sh -c "yarn install && yarn run dev"
```

You'll now define this service in the `compose.yaml` file.
现在，您将在 `compose.yaml` 文件中定义此服务。

1. Open `compose.yaml` in a text or code editor, and start by defining the name and image of  the first service (or container) you want to run as part of your  application. The name will automatically become a network alias, which will be useful when defining your MySQL service.
   在文本编辑器或代码编辑器中打开 `compose.yaml` ，首先定义要作为应用程序的一部分运行的第一个服务（或容器）的名称和图像。该名称将自动成为网络别名，这在定义 MySQL 服务时非常有用。

```yaml
services:
  app:
    image: node:18-alpine
```

Typically, you will see `command` close to the `image` definition, although there is no requirement on ordering. Add the `command` to your `compose.yaml` file.
通常，您会看到 `command` 接近定义的内容 `image` ，尽管对排序没有要求。将 `command` 添加到您的 `compose.yaml` 文件中。

```yaml
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
```

Now migrate the `-p 127.0.0.1:3000:3000` part of the command by defining the `ports` for the service.
现在，通过定义服务的来 `ports` 迁移命令 `-p 127.0.0.1:3000:3000` 的部分。

```yaml
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 127.0.0.1:3000:3000
```

Next, migrate both the working directory (`-w /app`) and the volume mapping (`-v "$(pwd):/app"`) by using the `working_dir` and `volumes` definitions.
接下来，使用 `working_dir` and `volumes` 定义迁移工作目录 （ `-w /app` ） 和卷映射 （ `-v "$(pwd):/app"` ）。

One advantage of Docker Compose volume definitions is you can use relative paths from the current directory.
Docker Compose 卷定义的一个优点是您可以使用当前目录中的相对路径。

```yaml
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 127.0.0.1:3000:3000
    working_dir: /app
    volumes:
      - ./:/app
```

Finally, you need to migrate the environment variable definitions using the `environment` key.
最后，您需要使用 `environment` 键迁移环境变量定义。

1. ```yaml
   services:
     app:
       image: node:18-alpine
       command: sh -c "yarn install && yarn run dev"
       ports:
         - 127.0.0.1:3000:3000
       working_dir: /app
       volumes:
         - ./:/app
       environment:
         MYSQL_HOST: mysql
         MYSQL_USER: root
         MYSQL_PASSWORD: secret
         MYSQL_DB: todos
   ```

### [Define the MySQL service 定义 MySQL 服务](https://docs.docker.com/guides/workshop/08_using_compose/#define-the-mysql-service)

Now, it's time to define the MySQL service. The command that you used for that container was the following:
现在，是时候定义MySQL服务了。用于该容器的命令如下：



```console
 docker run -d \
  --network todo-app --network-alias mysql \
  -v todo-mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=todos \
  mysql:8.0
```

1. First define the new service and name it `mysql` so it automatically gets the network alias. Also specify the image to use as well.
   首先定义新服务并为其 `mysql` 命名，以便它自动获取网络别名。此外，还要指定要使用的图像。

```yaml
services:
  app:
    # The app service definition
  mysql:
    image: mysql:8.0
```

Next, define the volume mapping. When you ran the container with `docker run`, Docker created the named volume automatically. However, that doesn't happen when running with Compose. You need to define the volume in the top-level `volumes:` section and then specify the mountpoint in the service config. By simply providing only the volume name, the default options are used.
接下来，定义卷映射。当您运行 `docker run` 容器时，Docker 会自动创建命名卷。但是，使用 Compose 运行时不会发生这种情况。您需要在顶级 `volumes:` 部分定义卷，然后在服务配置中指定挂载点。只需提供卷名称，即可使用默认选项。

```yaml
services:
  app:
    # The app service definition
  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql

volumes:
  todo-mysql-data:
```

Finally, you need to specify the environment variables.
最后，您需要指定环境变量。

1. ```yaml
   services:
     app:
       # The app service definition
     mysql:
       image: mysql:8.0
       volumes:
         - todo-mysql-data:/var/lib/mysql
       environment:
         MYSQL_ROOT_PASSWORD: secret
         MYSQL_DATABASE: todos
   
   volumes:
     todo-mysql-data:
   ```

At this point, your complete `compose.yaml` should look like this:
此时，您的完整 `compose.yaml` 应如下所示：

```yaml
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 127.0.0.1:3000:3000
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos

  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-mysql-data:
```

## [Run the application stack 运行应用程序堆栈](https://docs.docker.com/guides/workshop/08_using_compose/#run-the-application-stack)

Now that you have your `compose.yaml` file, you can start your application.
现在您已经有 `compose.yaml` 了文件，可以启动您的应用程序。

1. Make sure no other copies of the containers are running first. Use `docker ps` to list the containers and `docker rm -f <ids>` to remove them.
   确保没有容器的其他副本首先运行。用于 `docker ps` 列出容器并 `docker rm -f <ids>` 删除它们。

2. Start up the application stack using the `docker compose up` command. Add the `-d` flag to run everything in the background.
   使用命令 `docker compose up` 启动应用程序堆栈。添加标志 `-d` 以在后台运行所有内容。

   

```console
 docker compose up -d
```

When you run the previous command, you should see output like the following:
运行上一个命令时，应看到如下所示的输出：

```plaintext
Creating network "app_default" with the default driver
Creating volume "app_todo-mysql-data" with default driver
Creating app_app_1   ... done
Creating app_mysql_1 ... done
```

You'll notice that Docker Compose created the volume as well as a network. By  default, Docker Compose automatically creates a network specifically for the application stack (which is why you didn't define one in the  Compose file).
您会注意到 Docker Compose 创建了卷以及网络。默认情况下，Docker Compose 会自动为应用程序堆栈专门创建一个网络（这就是您没有在 Compose 文件中定义一个网络的原因）。

Look at the logs using the `docker compose logs -f` command. You'll see the logs from each of the services interleaved into a single stream. This is incredibly useful when you want to watch for timing-related issues. The `-f` flag follows the log, so will give you live output as it's generated.
使用命令 `docker compose logs -f` 查看日志。你将看到每个服务的日志交错到一个流中。当您想要关注与时间相关的问题时，这非常有用。该 `-f` 标志跟随日志，因此将在生成日志时为您提供实时输出。

If you have run the command already, you'll see output that looks like this:
如果已运行该命令，则会看到如下所示的输出：

```plaintext
mysql_1  | 2019-10-03T03:07:16.083639Z 0 [Note] mysqld: ready for connections.
mysql_1  | Version: '8.0.31'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
app_1    | Connected to mysql db at host mysql
app_1    | Listening on port 3000
```

The service name is displayed at the beginning of the line (often colored) to help distinguish messages. If you want to view the logs for a specific service, you can add the service name to the end of the logs command (for example, `docker compose logs -f app`).
服务名称显示在行的开头（通常为彩色），以帮助区分消息。如果要查看特定服务的日志，可以将服务名称添加到 logs 命令的末尾（例如， `docker compose logs -f app` ）。

At this point, you should be able to open your app in your browser on http://localhost:3000

1.  and see it running.
   此时，您应该能够在 http://localhost:3000 上的浏览器中打开您的应用程序并看到它正在运行。

## [See the app stack in Docker Dashboard 在 Docker Dashboard 中查看应用堆栈](https://docs.docker.com/guides/workshop/08_using_compose/#see-the-app-stack-in-docker-dashboard)

If you look at the Docker Dashboard, you'll see that there is a group named **getting-started-app**. This is the project name from Docker Compose and used to group the containers together. By default, the project name is simply the name of the directory that the `compose.yaml` was located in.
如果您查看 Docker 仪表板，您会看到有一个名为 getting-started-app 的组。这是 Docker Compose 中的项目名称，用于将容器组合在一起。默认情况下，项目名称只是 所在的 `compose.yaml` 目录的名称。

If you expand the stack, you'll see the two containers you defined in the Compose file. The names are also a little more descriptive, as they follow the pattern of `<service-name>-<replica-number>`. So, it's very easy to quickly see what container is your app and which container is the mysql database.
如果展开堆栈，您将看到在 Compose 文件中定义的两个容器。这些名称也更具描述性，因为它们遵循 `<service-name>-<replica-number>` 的模式。因此，很容易快速查看哪个容器是您的应用程序，哪个容器是 mysql 数据库。

## [Tear it all down 把它全部拆掉](https://docs.docker.com/guides/workshop/08_using_compose/#tear-it-all-down)

When you're ready to tear it all down, simply run `docker compose down` or hit the trash can on the Docker Dashboard for the entire app. The containers will stop and the network will be removed.
当您准备好将其全部拆除时，只需在整个 `docker compose down` 应用程序的 Docker 仪表板上运行或点击垃圾桶即可。容器将停止，网络将被删除。

> **Warning 警告**
>
> By default, named volumes in your compose file are not removed when you run `docker compose down`. If you want to remove the volumes, you need to add the `--volumes` flag.
> 默认情况下，运行 `docker compose down` 时不会删除复合文件中的命名卷。如果要删除卷，则需要添加标志 `--volumes` 。
>
> The Docker Dashboard does not remove volumes when you delete the app stack.
> 当您删除应用程序堆栈时，Docker Dashboard 不会删除卷。

## [Summary 总结](https://docs.docker.com/guides/workshop/08_using_compose/#summary)

In this section, you learned about Docker Compose and how it helps you simplify the way you define and share multi-service applications.
在本节中，您了解了 Docker Compose 以及它如何帮助您简化定义和共享多服务应用程序的方式。

Related information: 相关信息：

- [Compose overview Compose 概述](https://docs.docker.com/compose/)
- [Compose file reference 撰写文件引用](https://docs.docker.com/compose/compose-file/)
- [Compose CLI reference Compose CLI 参考](https://docs.docker.com/compose/reference/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/08_using_compose/#next-steps)

Next, you'll learn about a few best practices you can use to improve your Dockerfile.
接下来，您将了解一些可用于改进 Dockerfile 的最佳实践。

[Image-building best practices
图像构建最佳实践](https://docs.docker.com/guides/workshop/09_image_best/)

# Image-building best practices 图像构建最佳实践

## [Image layering 图像分层](https://docs.docker.com/guides/workshop/09_image_best/#image-layering)

Using the `docker image history` command, you can see the command that was used to create each layer within an image.
使用该 `docker image history` 命令，您可以查看用于在图像中创建每个层的命令。

1. Use the `docker image history` command to see the layers in the `getting-started` image you created.
   使用该 `docker image history` 命令可查看您创建的图像中的 `getting-started` 图层。

```console
 docker image history getting-started
```

You should get output that looks something like the following.
您应该得到如下所示的输出。

```plaintext
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a78a40cbf866        18 seconds ago      /bin/sh -c #(nop)  CMD ["node" "src/index.j…    0B                  
f1d1808565d6        19 seconds ago      /bin/sh -c yarn install --production            85.4MB              
a2c054d14948        36 seconds ago      /bin/sh -c #(nop) COPY dir:5dc710ad87c789593…   198kB               
9577ae713121        37 seconds ago      /bin/sh -c #(nop) WORKDIR /app                  0B                  
b95baba1cfdb        13 days ago         /bin/sh -c #(nop)  CMD ["node"]                 0B                  
<missing>           13 days ago         /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B                  
<missing>           13 days ago         /bin/sh -c #(nop) COPY file:238737301d473041…   116B                
<missing>           13 days ago         /bin/sh -c apk add --no-cache --virtual .bui…   5.35MB              
<missing>           13 days ago         /bin/sh -c #(nop)  ENV YARN_VERSION=1.21.1      0B                  
<missing>           13 days ago         /bin/sh -c addgroup -g 1000 node     && addu…   74.3MB              
<missing>           13 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=12.14.1     0B                  
<missing>           13 days ago         /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B                  
<missing>           13 days ago         /bin/sh -c #(nop) ADD file:e69d441d729412d24…   5.59MB   
```

Each of the lines represents a layer in the image. The display here shows the base at the bottom with the newest layer at the top. Using this, you can also quickly see the size of each layer, helping diagnose large images.
每条线代表图像中的一个图层。此处的显示显示底部为底部，顶部为最新图层。使用此功能，您还可以快速查看每层的大小，从而帮助诊断大型图像。

You'll notice that several of the lines are truncated. If you add the `--no-trunc` flag, you'll get the full output.
您会注意到其中几行被截断。如果添加标志 `--no-trunc` ，将获得完整的输出。

1. ```console
    docker image history --no-trunc getting-started
   ```

## [Layer caching 图层缓存](https://docs.docker.com/guides/workshop/09_image_best/#layer-caching)

Now that you've seen the layering in action, there's an important lesson to learn to help decrease build times for your container images. Once a layer changes, all downstream layers have to be recreated as well.
现在，您已经了解了分层的实际效果，接下来需要学习一个重要的课程，以帮助减少容器映像的构建时间。一旦图层发生更改，也必须重新创建所有下游图层。

Look at the following Dockerfile you created for the getting started app.
请查看为入门应用创建的以下 Dockerfile。

```dockerfile
# syntax=docker/dockerfile:1
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

Going back to the image history output, you see that each command in the  Dockerfile becomes a new layer in the image. You might remember that when you made a change to the image, the yarn  dependencies had to be reinstalled. It doesn't make much sense to ship  around the same dependencies every time you build.
回到镜像历史输出，您会看到 Dockerfile 中的每个命令都成为镜像中的新层。您可能还记得，当您对图像进行更改时，必须重新安装 yarn 依赖项。每次构建时都围绕相同的依赖项发布没有多大意义。

To fix it, you need to restructure your Dockerfile to help support the caching of the dependencies. For Node-based applications, those dependencies are defined in the `package.json` file. You can copy only that file in first, install the dependencies, and then copy in everything else. Then, you only recreate the yarn dependencies if there was a change to the `package.json`.
要修复它，您需要重组 Dockerfile 以帮助支持依赖项的缓存。对于基于 Node 的应用程序，这些依赖项在 `package.json` 文件中定义。您可以先复制该文件，然后安装依赖项，然后再复制其他所有内容。然后，仅当 对 进行更改时，才重新创建 yarn 依赖项 `package.json` 。

1. Update the Dockerfile to copy in the `package.json` first, install dependencies, and then copy everything else in.
   首先更新 Dockerfile 以复制 `package.json` ，安装依赖项，然后复制其他所有内容。

```dockerfile
# syntax=docker/dockerfile:1
FROM node:18-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]
```

Build a new image using `docker build`.
使用 `docker build` 构建新映像。



```console
 docker build -t getting-started .
```

You should see output like the following.
您应看到如下所示的输出。

```plaintext
[+] Building 16.1s (10/10) FINISHED
=> [internal] load build definition from Dockerfile
=> => transferring dockerfile: 175B
=> [internal] load .dockerignore
=> => transferring context: 2B
=> [internal] load metadata for docker.io/library/node:18-alpine
=> [internal] load build context
=> => transferring context: 53.37MB
=> [1/5] FROM docker.io/library/node:18-alpine
=> CACHED [2/5] WORKDIR /app
=> [3/5] COPY package.json yarn.lock ./
=> [4/5] RUN yarn install --production
=> [5/5] COPY . .
=> exporting to image
=> => exporting layers
=> => writing image     sha256:d6f819013566c54c50124ed94d5e66c452325327217f4f04399b45f94e37d25
=> => naming to docker.io/library/getting-started
```

Now, make a change to the `src/static/index.html` file. For example, change the `<title>` to "The Awesome Todo App".
现在，对 `src/static/index.html` 文件进行更改。例如，将更改为 `<title>` “The Awesome Todo App”。

Build the Docker image now using `docker build -t getting-started .` again. This time, your output should look a little different.
现在再次使用 `docker build -t getting-started .` 构建 Docker 镜像。这一次，您的输出应该看起来略有不同。

1. ```plaintext
   [+] Building 1.2s (10/10) FINISHED
   => [internal] load build definition from Dockerfile
   => => transferring dockerfile: 37B
   => [internal] load .dockerignore
   => => transferring context: 2B
   => [internal] load metadata for docker.io/library/node:18-alpine
   => [internal] load build context
   => => transferring context: 450.43kB
   => [1/5] FROM docker.io/library/node:18-alpine
   => CACHED [2/5] WORKDIR /app
   => CACHED [3/5] COPY package.json yarn.lock ./
   => CACHED [4/5] RUN yarn install --production
   => [5/5] COPY . .
   => exporting to image
   => => exporting layers
   => => writing image     sha256:91790c87bcb096a83c2bd4eb512bc8b134c757cda0bdee4038187f98148e2eda
   => => naming to docker.io/library/getting-started
   ```

   First off, you should notice that the build was much faster. And, you'll see that several steps are using previously cached layers. Pushing and pulling this image and updates to it will be much faster as well.
   首先，您应该注意到构建速度要快得多。而且，您会看到有几个步骤正在使用以前缓存的图层。推送和拉取此映像及其更新也将快得多。

## [Multi-stage builds 多阶段构建](https://docs.docker.com/guides/workshop/09_image_best/#multi-stage-builds)

Multi-stage builds are an incredibly powerful tool to help use multiple stages to create an image. There are several advantages for them:
多阶段构建是一个非常强大的工具，可帮助使用多个阶段创建映像。它们有几个优点：

- Separate build-time dependencies from runtime dependencies
  将构建时依赖项与运行时依赖项分开
- Reduce overall image size by shipping only what your app needs to run
  通过仅发送应用运行所需的内容来减小整体图像大小

### [Maven/Tomcat example Maven/Tomcat 示例](https://docs.docker.com/guides/workshop/09_image_best/#maventomcat-example)

When building Java-based applications, you need a JDK to compile the source code to Java bytecode. However, that JDK isn't needed in production. Also, you might be using tools like Maven or Gradle to help build the app. Those also aren't needed in your final image. Multi-stage builds help.
在构建基于 Java 的应用程序时，您需要一个 JDK 来将源代码编译为 Java 字节码。但是，生产环境中不需要该 JDK。此外，您可能正在使用 Maven 或 Gradle 等工具来帮助构建应用程序。最终图像中也不需要这些。多阶段构建有助于。

```dockerfile
# syntax=docker/dockerfile:1
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps 
```

In this example, you use one stage (called `build`) to perform the actual Java build using Maven. In the second stage (starting at `FROM tomcat`), you copy in files from the `build` stage. The final image is only the last stage being created, which can be overridden using the `--target` flag.
在此示例中，您将使用一个阶段（称为 `build` ）来使用 Maven 执行实际的 Java 构建。在第二阶段（从 开始）， `FROM tomcat` 您将从该 `build` 阶段复制文件。最终图像只是正在创建的最后一个阶段，可以使用 `--target` 标志覆盖该阶段。

### [React example React 示例](https://docs.docker.com/guides/workshop/09_image_best/#react-example)

When building React applications, you need a Node environment to compile the JS code (typically JSX), SASS stylesheets, and more into static HTML, JS, and CSS. If you aren't doing server-side rendering, you don't even need a Node environment for your production build. You can ship the static resources in a static nginx container.
在构建 React 应用程序时，您需要一个 Node 环境来将 JS 代码（通常是 JSX）、SASS 样式表等编译为静态 HTML、JS 和  CSS。如果你不做服务器端渲染，你甚至不需要一个节点环境来做你的生产构建。您可以将静态资源发送到静态 nginx 容器中。

```dockerfile
# syntax=docker/dockerfile:1
FROM node:18 AS build
WORKDIR /app
COPY package* yarn.lock ./
RUN yarn install
COPY public ./public
COPY src ./src
RUN yarn run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
```

In the previous Dockerfile example, it uses the `node:18` image to perform the build (maximizing layer caching) and then copies the output into an nginx container.
在前面的 Dockerfile 示例中，它使用 `node:18` 镜像执行构建（最大化层缓存），然后将输出复制到 nginx 容器中。

## [Summary 总结](https://docs.docker.com/guides/workshop/09_image_best/#summary)

In this section, you learned a few image building best practices, including layer caching and multi-stage builds.
在本节中，您学习了一些映像构建最佳实践，包括层缓存和多阶段构建。

Related information: 相关信息：

- [Dockerfile reference Dockerfile 参考](https://docs.docker.com/reference/dockerfile/)
- [Build with Docker guide
  使用 Docker 构建指南](https://docs.docker.com/build/guide/)
- [Dockerfile best practices
  Dockerfile 最佳实践](https://docs.docker.com/build/building/best-practices/)

## [Next steps 后续步骤](https://docs.docker.com/guides/workshop/09_image_best/#next-steps)

In the next section, you'll learn about additional resources you can use to continue learning about containers.
在下一部分中，你将了解可用于继续了解容器的其他资源。

# What next after the Docker workshop Docker 研讨会之后的下一步是什么

Although you're done with the workshop, there's still a lot more to learn about containers.
虽然您已经完成了研讨会，但仍有很多东西需要学习有关容器的知识。

Here are a few other areas to look at next.
以下是接下来要研究的其他一些领域。

## [Container orchestration 容器编排](https://docs.docker.com/guides/workshop/10_what_next/#container-orchestration)

Running containers in production is tough. You don't want to log into a machine and simply run a `docker run` or `docker compose up`. Why not? Well, what happens if the containers die? How do you scale across several machines? Container orchestration solves this problem. Tools like Kubernetes, Swarm, Nomad, and ECS all help solve this problem, all in slightly different ways.
在生产环境中运行容器非常困难。您不想登录到计算机并简单地运行 `docker run` or `docker compose up` .为什么不呢？那么，如果集装箱死了会发生什么？如何在多台机器上进行扩展？容器编排解决了这个问题。Kubernetes、Swarm、Nomad 和 ECS 等工具都有助于解决这个问题，但方式略有不同。

The general idea is that you have managers who receive the expected state. This state might be "I want to run two instances of my web app and expose port 80." The managers then look at all of the machines in the cluster and delegate work to worker nodes. The managers watch for changes (such as a container quitting) and then work to make the actual state reflect the expected state.
一般的想法是，你有接收预期状态的经理。此状态可能是“我想运行我的 Web 应用的两个实例并公开端口 80”。然后，管理员查看集群中的所有计算机，并将工作委派给工作器节点。管理器监视更改（例如容器退出），然后努力使实际状态反映预期状态。

## [Cloud Native Computing Foundation projects 云原生计算基金会项目](https://docs.docker.com/guides/workshop/10_what_next/#cloud-native-computing-foundation-projects)

The CNCF is a vendor-neutral home for various open-source projects, including Kubernetes, Prometheus, Envoy, Linkerd, NATS, and more. You can view the [graduated and incubated projects here](https://www.cncf.io/projects/)

and the entire [CNCF Landscape here](https://landscape.cncf.io/)

. There are a lot of projects to help solve problems around monitoring, logging, security, image registries, messaging, and more.
CNCF 是各种开源项目的供应商中立之家，包括 Kubernetes、Prometheus、Envoy、Linkerd、NATS  等。您可以在此处查看毕业和孵化的项目，并在此处查看整个 CNCF  景观。有很多项目可以帮助解决有关监视、日志记录、安全性、图像注册表、消息传递等方面的问题。

## [Getting started video workshop 入门视频研讨会](https://docs.docker.com/guides/workshop/10_what_next/#getting-started-video-workshop)

Docker recommends watching the video workshop from DockerCon 2022. Watch the  entire video or use the following links to open the video at a  particular section.
Docker 建议观看 DockerCon 2022 的视频研讨会。观看整个视频或使用以下链接在特定部分打开视频。

- [Docker overview and installation
  Docker 概述和安装](https://youtu.be/gAGEar5HQoU)

[Pull, run, and explore containers
拉取、运行和浏览容器](https://youtu.be/gAGEar5HQoU?t=1400)

[Build a container image
构建容器镜像](https://youtu.be/gAGEar5HQoU?t=3185)

[Containerize an app 容器化应用](https://youtu.be/gAGEar5HQoU?t=4683)

[Connect a DB and set up a bind mount
连接数据库并设置绑定挂载](https://youtu.be/gAGEar5HQoU?t=6305)

[Deploy a container to the cloud
将容器部署到云](https://youtu.be/gAGEar5HQoU?t=8280)

<iframe src="https://www.youtube-nocookie.com/embed/gAGEar5HQoU" style="max-width:100%;aspect-ratio:16/9" width="560" height="auto" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>

## [Creating a container from scratch 从头开始创建容器](https://docs.docker.com/guides/workshop/10_what_next/#creating-a-container-from-scratch)

If you'd like to see how containers are built from scratch, Liz Rice from  Aqua Security has a fantastic talk in which she creates a container from scratch in Go. While the talk does not go into networking, using images for the filesystem, and other advanced topics, it gives a deep dive  into how things are working.
如果您想了解如何从头开始构建容器，来自 Aqua Security 的 Liz Rice 进行了一次精彩的演讲，她在演讲中用 Go 从头开始创建一个容器。虽然这个演讲没有涉及网络、使用图像作为文件系统以及其他高级主题，但它深入探讨了事物是如何工作的。