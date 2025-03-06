Getting Docker Desktop up and running is the first crucial step for developers diving into containerization, offering a seamless and user-friendly interface for managing Docker containers. Docker Desktop simplifies the process of building, sharing, and running applications in containers, ensuring consistency across different environments.
启动并运行 Docker Desktop 是开发人员深入研究容器化的第一个关键步骤，它为管理 Docker 容器提供了一个无缝且用户友好的界面。Docker Desktop 简化了在容器中构建、共享和运行应用程序的过程，确保了不同环境之间的一致性。

[Start 开始](https://docs.docker.com/guides/getting-started/get-docker-desktop/)



Learn how to run your first container, gaining hands-on experience with Docker's powerful features. We'll cover making real-time changes to both backend and frontend code within the containerized environment, ensuring seamless integration and testing.
了解如何运行您的第一个容器，获得使用 Docker 强大功能的实践经验。我们将介绍如何在容器化环境中对后端和前端代码进行实时更改，以确保无缝集成和测试。

[Start 开始](https://docs.docker.com/guides/getting-started/develop-with-containers/)



Learn how to build your first Docker image, a key step in containerizing your application. We'll guide you through the process of creating an image repository and building and pushing your image to Docker Hub. This enables you to share your image easily within your team.
了解如何构建您的第一个 Docker 镜像，这是容器化应用程序的关键步骤。我们将指导您完成创建镜像仓库以及构建镜像并将其推送到 Docker Hub 的过程。这使您能够在团队中轻松共享您的图像。

[Start 开始](https://docs.docker.com/guides/getting-started/build-and-push-first-image/)



Now that you have set up Docker Desktop, developed with containers, and built and pushed your first image, you are ready to take the next step and dive deep into what a container is and how it works.
现在，您已经设置了 Docker Desktop，使用容器进行了开发，并构建并推送了您的第一个镜像，您可以采取下一步行动，深入了解什么是容器及其工作原理。

# Get Docker Desktop 获取 Docker Desktop

[SERIES 系列 Getting started 开始](https://docs.docker.com/guides/getting-started/)

[1](https://docs.docker.com/guides/getting-started/get-docker-desktop/)

[2](https://docs.docker.com/guides/getting-started/develop-with-containers/)

[3](https://docs.docker.com/guides/getting-started/build-and-push-first-image/)

[4](https://docs.docker.com/guides/getting-started/whats-next/)

<iframe id="youtube-player-C2bPVhiNU-0" data-video-id="C2bPVhiNU-0" class="youtube-video aspect-video w-full" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" title="Docker Concepts: Get Docker Desktop" width="100%" height="100%" src="https://www.youtube.com/embed/C2bPVhiNU-0?rel=0&amp;iv_load_policy=3&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fdocs.docker.com&amp;widgetid=1" data-gtm-yt-inspected-17="true"></iframe>

## [Explanation 解释](https://docs.docker.com/guides/getting-started/get-docker-desktop/#explanation)

Docker Desktop is the all-in-one package to build images, run containers, and so much more. This guide will walk you through the installation process, enabling you to experience Docker Desktop firsthand.
Docker Desktop 是用于构建映像、运行容器等的多合一包。本指南将引导您完成安装过程，使您能够亲身体验 Docker Desktop。

> **Docker Desktop terms Docker Desktop 术语**
>
> Commercial use of Docker Desktop in larger enterprises (more than 250 employees OR more than $10 million USD in annual revenue) requires a [paid subscription](https://www.docker.com/pricing/?_gl=1*1nyypal*_ga*MTYxMTUxMzkzOS4xNjgzNTM0MTcw*_ga_XJWPQMJYHQ*MTcxNjk4MzU4Mi4xMjE2LjEuMTcxNjk4MzkzNS4xNy4wLjA.)

> .
> 在大型企业（员工人数超过 250 人或年收入超过 1000 万美元）中将 Docker Desktop 用于商业用途需要付费订阅。

![img](https://docs.docker.com/assets/images/apple_48.svg)

Docker Desktop for Mac 适用于 Mac 的 Docker Desktop

[Download (Apple Silicon)](https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-arm64)

 | [Download (Intel)](https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-amd64)

 | [Install instructions](https://docs.docker.com/desktop/install/mac-install)
下载 （Apple Silicon） |下载 （Intel） |安装说明

![img](https://docs.docker.com/assets/images/windows_48.svg)

Docker Desktop for Windows 适用于 Windows 的 Docker Desktop

[Download](https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-windows)

 | [Install instructions](https://docs.docker.com/desktop/install/windows-install)
下载 |安装说明

![img](https://docs.docker.com/assets/images/linux_48.svg)

Docker Desktop for Linux 适用于 Linux 的 Docker Desktop

[Install instructions 安装说明](https://docs.docker.com/desktop/install/linux-install/)

Once it's installed, complete the setup process and you're all set to run a Docker container.
安装完成后，完成设置过程，就可以运行 Docker 容器了。

## [Try it out 尝试一下](https://docs.docker.com/guides/getting-started/get-docker-desktop/#try-it-out)

In this hands-on guide, you will see how to run a Docker container using Docker Desktop.
在本实践指南中，您将了解如何使用 Docker Desktop 运行 Docker 容器。

Follow the instructions to run a container using the CLI.
按照说明使用 CLI 运行容器。

## [Run your first container 运行您的第一个容器](https://docs.docker.com/guides/getting-started/get-docker-desktop/#run-your-first-container)

Open your CLI terminal and start a container by running the `docker run` command:
打开 CLI 终端，然后运行以下 `docker run` 命令启动容器：



```console
 docker run -d -p 8080:80 docker/welcome-to-docker
```

## [Access the frontend 访问前端](https://docs.docker.com/guides/getting-started/get-docker-desktop/#access-the-frontend)

For this container, the frontend is accessible on port `8080`. To open the website, visit http://localhost:8080

 in your browser.
对于此容器，前端可以在 port `8080` 上访问。要打开该网站，请在浏览器中访问 http://localhost:8080。

![Screenshot of the landing page of the Nginx web server, coming from the running container](https://docs.docker.com/guides/docker-concepts/the-basics/images/access-the-frontend.webp)

## [Manage containers using Docker Desktop 使用 Docker Desktop 管理容器](https://docs.docker.com/guides/getting-started/get-docker-desktop/#manage-containers-using-docker-desktop)

1. Open Docker Desktop and select the **Containers** field on the left sidebar.
   打开 Docker Desktop，然后选择左侧边栏的 Containers 字段。

2. You can view information about your container including logs, and files, and even access the shell by selecting the **Exec** tab.
   您可以查看有关容器的信息，包括日志和文件，甚至可以通过选择“执行”选项卡来访问 shell。

   ![Screenshot of exec into the running container in Docker Desktop](https://docs.docker.com/guides/getting-started/images/exec-into-docker-container.webp)

3. Select the **Inspect** field to obtain detailed information about the container. You can  perform various actions such as pause, resume, start or stop containers, or explore the **Logs**, **Bind mounts**, **Exec**, **Files**, and **Stats** tabs.
   选择〖检查〗字段以获取有关容器的详细信息。您可以执行各种操作，例如暂停、恢复、启动或停止容器，或浏览 Logs、Bind mounts、Exec、Files 和 Stats 选项卡。

![Screenshot of inspecting the running container in Docker Desktop](https://docs.docker.com/guides/getting-started/images/inspecting-container.webp)

Docker Desktop simplifies container management for developers by streamlining  the setup, configuration, and compatibility of applications across  different environments, thereby addressing the pain points of  environment inconsistencies and deployment challenges.
Docker Desktop 通过简化应用程序在不同环境中的设置、配置和兼容性，简化了开发人员的容器管理，从而解决了环境不一致和部署挑战的痛点。

## [What's next? 下一步是什么？](https://docs.docker.com/guides/getting-started/get-docker-desktop/#whats-next)

Now that you have Docker Desktop installed and ran your first container, it's time to start developing with containers.
现在，您已经安装并运行了第一个容器，是时候开始使用容器进行开发了。

In this hands-on, you will see how to run a Docker container using the Docker Desktop GUI.
在本实践中，您将了解如何使用 Docker Desktop GUI 运行 Docker 容器。

------

Use the following instructions to run a container.
按照以下说明运行容器。

1. Open Docker Desktop and select the **Search** field on the top navigation bar.
   打开 Docker Desktop，然后在顶部导航栏上选择“搜索”字段。

2. Specify `welcome-to-docker` in the search input and then select the **Pull** button.
   在搜索输入中指定， `welcome-to-docker` 然后选择“拉取”按钮。

   ![A screenshot of the Docker Dashboard showing the search result for welcome-to-docker Docker image ](https://docs.docker.com/guides/docker-concepts/the-basics/images/search-the-docker-image.webp)

3. Once the image is successfully pulled, select the **Run** button.
   成功拉取图像后，选择“运行”按钮。

4. Expand the **Optional settings**.
   展开可选设置。

5. In the **Container name**, specify `welcome-to-docker`.
   在“容器名称”中，指定 `welcome-to-docker` 。

6. In the **Host port**, specify `8080`.
   在主机端口中，指定 `8080` 。

   ![A screenshot of Docker Dashboard showing the container run dialog with welcome-to-docker typed in as the container name and 8080 specified as the port number](https://docs.docker.com/guides/docker-concepts/the-basics/images/run-a-new-container.webp)

7. Select **Run** to start your container.
   选择“运行”以启动容器。

Congratulations! You just ran your first container! 🎉
祝贺！您刚刚运行了第一个容器！🎉