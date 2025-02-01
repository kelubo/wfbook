# Introduction to ROCK images ROCK图像简介

## What are ROCKs? 什么是岩石？

Ordinary software packages can often be installed in a variety of different  types of environments that satisfy the given packaging system.  However, these environments can be quite varied, such as including versions of  language runtimes, system libraries, and other library dependencies that the software was not well tested with.
普通软件包通常可以安装在满足给定打包系统的各种不同类型的环境中。但是，这些环境可能非常多样化，例如包括语言运行时、系统库和其他库依赖项的版本，而这些版本以及软件没有经过良好测试的库依赖项。

Software containers address this by encapsulating both the software and the  surrounding environment.  Instead of installing and maintaining a  collection of software packages, the user runs and maintains a single  container, instantiated from a container image with the desired software already installed.  The user relies on the provider of the container  image to perform the necessary software testing and maintenance updates.  There is a rich ecosystem of container providers thanks to mainstream  tools like Docker, and popular container registries like Docker Hub,  Amazon ECR, etc., which make it easy for anyone to build and publish a  container image.  Unfortunately, with that freedom and flexibility  invariably comes unreliability of maintenance and inconsistency of  implementation.
软件容器通过封装软件和周围环境来解决这个问题。用户无需安装和维护软件包的集合，而是运行和维护单个容器，该容器从已安装所需软件的容器映像实例化。用户依靠容器映像的提供程序来执行必要的软件测试和维护更新。由于 Docker 等主流工具以及 Docker Hub、Amazon ECR  等流行的容器注册表，容器提供商拥有丰富的生态系统，这使得任何人都可以轻松构建和发布容器映像。不幸的是，这种自由和灵活性总是伴随着维护的不可靠性和实施的不一致。

The *Open Container Initiative* (OCI) establishes standards for constructing container images that can  be reliably installed across a variety of compliant host environments.
开放容器倡议 （OCI） 建立了用于构建容器映像的标准，这些映像可以可靠地安装在各种合规的主机环境中。

Ubuntu’s [LTS Docker Image Portfolio](https://ubuntu.com/security/docker-images) provides OCI-compliant images that receive stable security updates and  predictable software updates, thus ensuring consistency in both  maintenance schedule and operational interfaces for the underlying  software your software builds on.
Ubuntu 的 LTS Docker 映像产品组合提供符合 OCI 标准的映像，这些映像可接收稳定的安全更新和可预测的软件更新，从而确保软件构建的底层软件的维护计划和操作界面的一致性。

## Container Creation and Deletion 容器创建和删除

Over the course of this tutorial we’ll explore deriving a customized Apache  container, and then networking in a Postgres container backend for it.   By the end you’ll have a working knowledge of how to set up a  container-based environment using Canonical’s ROCKs.
在本教程中，我们将探索如何派生一个自定义的 Apache 容器，然后在 Postgres 容器后端为其建立联网。最后，您将掌握如何使用 Canonical 的 ROCK 设置基于容器的环境的工作知识。

First the absolute basics.  Let’s spin up a single container providing the Apache2 web server software:
首先是绝对的基础知识。让我们启动一个提供 Apache2 Web 服务器软件的容器：

```
$ sudo apt-get update
$ sudo apt-get -y install docker.io
$ sudo docker run -d --name my-apache2-container -p 8080:80 ubuntu/apache2:2.4-22.04_beta
Unable to find image 'ubuntu/apache2:2.4-22.04_beta' locally
2.4-22.04_beta: Pulling from ubuntu/apache2
13c61b50dd15: Pull complete 
34dadde438e6: Pull complete 
d8e11cec95e6: Pull complete 
Digest: sha256:11647ce68a130540150dfebbb755ee79c908103fafbf805074eb6513e6b9df83
Status: Downloaded newer image for ubuntu/apache2:2.4-22.04_beta
4031e6ed24a6e08185efd1c60e7df50f8f60c21ed9961c858ca0cb6bb300a72a
```

This container, named `my-apache2-container` runs in an Ubuntu 22.04 LTS environment and can be accessed via local  port 8080.  Load the website up in your local web browser:
此名为 `my-apache2-container` 的容器在 Ubuntu 22.04 LTS 环境中运行，可通过本地端口 8080 访问。在本地 Web 浏览器中加载网站：

```
$ firefox http://localhost:8080
```

![apache2-container](https://assets.ubuntu.com/v1/d81ac993-rocks_intro.png)

If you don’t have firefox handy, `curl` can be used instead:
如果你手边没有火狐， `curl` 可以改用：

```
$ curl -s http://localhost:8080 | grep "<title>"
<title>Apache2 Ubuntu Default Page: It works</title>
```

The run command had a number of parameters to it.  The Usage section of [Ubuntu’s Docker hub page for Apache2](https://hub.docker.com/r/ubuntu/apache2) has a table with an overview of parameters specific to the image, and [Docker itself](https://docs.docker.com/engine/reference/commandline/run/) has a formal reference of all available parameters, but lets go over what we’re doing in this particular case:
run 命令具有许多参数。Apache2 的 Ubuntu Docker 中心页面的 Usage 部分有一个表格，其中包含特定于映像的参数的概述，并且 Docker 本身具有所有可用参数的正式引用，但让我们回顾一下我们在这种特殊情况下正在做什么：

```
$ sudo docker run -d --name my-apache2-container -e TZ=UTC -p 8080:80 ubuntu/apache2:2.4-22.04_beta
```

The `-d` parameter causes the container to be detached so it runs in the  background.  If you omit this, then you’ll want to use a different  terminal window for interacting with the container.  The `--name` parameter allows you to use a defined name; if it’s omitted you can still reference the container by its Docker id.  The `-e` option lets you set environment variables used when creating the container; in this case we’re just setting the timezone (`TZ`) to universal time (`UTC`).  The `-p` parameter allows us to map port 80 of the container to 8080 on localhost, so we can reference the service as `http://localhost:8080`.  The last parameter indicates what software image we want.
该 `-d` 参数会导致容器分离，使其在后台运行。如果省略此项，则需要使用其他终端窗口与容器进行交互。该 `--name` 参数允许您使用定义的名称;如果省略了它，你仍然可以通过容器的 Docker ID 引用容器。该 `-e` 选项允许您设置创建容器时使用的环境变量;在本例中，我们只需将时区 （ `TZ` ） 设置为世界时 （ `UTC` ）。该 `-p` 参数允许我们将容器的端口 80 映射到 localhost 上的 8080，因此我们可以将服务引用为 `http://localhost:8080` .最后一个参数表示我们想要的软件映像。

A variety of other container images are provided on [Ubuntu’s Docker Hub](https://hub.docker.com/r/ubuntu/) and on [Amazon ECR](https://gallery.ecr.aws/lts?page=1), including documentation of supported customization parameters and  debugging tips.  This lists the different major/minor versions of each  piece of software, packaged on top of different Ubuntu LTS releases.  So for example, in specifying our requested image as `ubuntu/apache2:2.4-22.04_beta` we used Apache2 version 2.4 running on a Ubuntu 22.04 environment.
Ubuntu 的 Docker Hub 和 Amazon ECR 上提供了各种其他容器映像，包括支持的自定义参数和调试提示的文档。这列出了每个软件的不同主要/次要版本，打包在不同的 Ubuntu LTS 版本之上。例如，在指定我们请求的映像时， `ubuntu/apache2:2.4-22.04_beta` 我们使用了在 Ubuntu 22.04 环境中运行的 Apache2 版本 2.4。

Notice that the image version we requested has `_beta` appended to it.  This is called a *Channel Tag*.  Like most software, Apache2 provides incremental releases numbered  like 2.4.51, 2.4.52, and 2.4.53.  Some of these releases are strictly  bugfix-only, or even just CVE security fixes; others may include new  features or other improvements.  If we think of the series of these  incremental releases for Apache2 2.4 on Ubuntu 22.04 as running in a *Channel*, the *Channel Tags* point to the newest incremental release that’s been confirmed to the  given level of stability.  So, if a new incremental release 2.4.54  becomes available, `ubuntu/apache2:2.4-22.04_edge` images would be updated to that version rapidly, then `ubuntu/apache2:2.4-22.04_beta` once it’s received some basic testing; eventually, if no problems are found, it will also be available in `ubuntu/apache2:2.4-22.04_candidate` and then in `ubuntu/apache2:2.4-22.04_stable` once it’s validated as completely safe.
请注意，我们请求的图像版本已 `_beta` 附加到其中。这称为频道标签。与大多数软件一样，Apache2 提供编号为 2.4.51、2.4.52 和 2.4.53  的增量版本。其中一些版本严格来说只是错误修复，甚至只是 CVE 安全修复;其他可能包括新功能或其他改进。如果我们将 Ubuntu 22.04  上的 Apache2 2.4 的这些增量版本系列视为在通道中运行，则通道标签指向已确认为给定稳定性级别的最新增量版本。因此，如果新的增量版本  2.4.54 可用， `ubuntu/apache2:2.4-22.04_edge` 映像将快速更新到该版本，然后 `ubuntu/apache2:2.4-22.04_beta` 一旦它接受了一些基本测试;最终，如果没有发现问题， `ubuntu/apache2:2.4-22.04_stable` 它也将在验证为完全安全后提供 `ubuntu/apache2:2.4-22.04_candidate` 。

For convenience there’s also a `latest` tag and an `edge` tag which are handy for experimentation or where you don’t care what  version is used and just want the newest available.  For example, to  launch the latest version of Nginx, we can do so as before, but  specifying `latest` instead of the version:
为了方便起见，还有一个 `latest` 标签和一个 `edge` 标签，它们对于实验来说很方便，或者你不在乎使用什么版本，只想要最新的可用版本。例如，要启动最新版本的 Nginx，我们可以像以前一样这样做，但指定 `latest` 而不是版本：

```
$ sudo docker run -d --name my-nginx-container -e TZ=UTC -p 9080:80 ubuntu/nginx:latest
4dac8d77645d7ed695bdcbeb3409a8eda942393067dad49e4ef3b8b1bdc5d584

$ curl -s http://localhost:9080 | grep "<title>"
<title>Welcome to nginx!</title>
```

We’ve also changed the port to 9080 instead of 8080 using the `-p` parameter, since port 8080 is still being used by our apache2  container.  If we were to try to also launch Nginx (or another Apache2  container) on port 8080, we’d get an error message, `Bind for 0.0.0.0:8080 failed: port is already allocated` and then would need to remove the container and try again.
我们还使用该 `-p` 参数将端口更改为 9080 而不是 8080，因为我们的 apache2 容器仍在使用端口 8080。如果我们尝试在端口 8080 上启动 Nginx（或其他 Apache2 容器），我们会收到一条错误消息， `Bind for 0.0.0.0:8080 failed: port is already allocated` 然后需要删除容器并重试。

Speaking of removing containers, now that we know how to create generic default containers, let’s clean up:
说到删除容器，现在我们知道了如何创建通用的默认容器，让我们清理一下：

```
$ sudo docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                   NAMES
d86e93c98e20   ubuntu/apache2:2.4-22.04_beta   "apache2-foreground"     29 minutes ago    Up 29 minutes    0.0.0.0:8080->80/tcp, :::8080->80/tcp   my-apache2-container
eed23be5f65d   ubuntu/nginx:latest             "/docker-entrypoint.…"   18 minutes ago   Up 18 minutes   0.0.0.0:9080->80/tcp, :::9080->80/tcp   my-nginx-container

$ sudo docker stop my-apache2-container
$ sudo docker rm my-apache2-container

$ sudo docker stop my-nginx-container
$ sudo docker rm my-nginx-container
```

To be able to actually use the containers, we’ll have to configure and customize them, which we’ll look at  [next](https://ubuntu.com/server/docs/rock-customisation-with-docker).
为了能够实际使用容器，我们必须配置和自定义它们，我们接下来将介绍这些容器。

------

# ROCK customisation with Docker 使用 Docker 进行 ROCK 定制

In the [last section](https://ubuntu.com/server/docs/introduction-to-rock-images) we looked at the basics of how to start and stop containers.  Here we’ll apply our own modifications to the images.
在上一节中，我们介绍了如何启动和停止容器的基础知识。在这里，我们将对图像应用我们自己的修改。

You’ll recall we used the `-p` parameter to give the two containers we created different ports so they didn’t conflict with each other.  We can think of this type of  customization as a *container configuration*, as opposed to an *image configuration* change defined in the `Dockerfile` settings for the image itself.  From a single image definition we can  create an arbitrary number of different containers with different ports  (or other pre-defined aspects), which are all otherwise reliably  identical.  A third approach is to modify the running container after it has been launched, applying whatever arbitrary changes we wish as *runtime modifications*.
您可能还记得，我们使用该 `-p` 参数为我们创建的两个容器提供了不同的端口，因此它们不会相互冲突。我们可以将这种类型的自定义视为容器配置，而不是在映像本身 `Dockerfile` 的设置中定义的映像配置更改。从单个映像定义中，我们可以创建任意数量的具有不同端口（或其他预定义方面）的不同容器，这些容器在其他方面都是可靠的相同。第三种方法是在启动正在运行的容器后对其进行修改，将我们希望的任何任意更改应用为运行时修改。

- **image configuration**:  Done in `Dockerfile`, changes common to all container instances of that image.  Requires rebuilding the image.
  映像配置：在 `Dockerfile` 中完成，该映像的所有容器实例都具有的更改。需要重新生成映像。
- **container configuration**:  Done at container launch, allowing variation between instances of a  given image.  Requires re-launching the container to change.
  容器配置：在容器启动时完成，允许给定映像的实例之间发生差异。需要重新启动容器才能进行更改。
- **runtime modifications**:  Done dynamically after container launch.  Does not require re-launching the container.
  运行时修改：在容器启动后动态完成。不需要重新启动容器。

The second approach follows Docker’s immutable infrastructure principle,  and is what the ROCKs system intends for production environments.  For  the sake of this tutorial we’ll use the third approach for introductory  purposes, building on that later to show how to achieve the same with  only configuration at container creation time.
第二种方法遵循 Docker 的不可变基础结构原则，也是 ROCKs 系统对生产环境的预期。在本教程中，我们将使用第三种方法进行介绍，稍后在此基础上展示如何在容器创建时仅通过配置来实现相同的目的。

## Setting up a Development Environment 设置开发环境

Speaking of doing things properly, let’s prepare a virtual machine (VM) to do our tutorial work in.
说到正确做事，让我们准备一个虚拟机 （VM） 来执行我们的教程工作。

While you can of course install the `docker.io` package directly on your desktop, as you may have done in the previous  section of this tutorial, using it inside a VM has a few advantages.   First, it encapsulates the system changes you want to experiment with,  so that they don’t affect your desktop; if anything gets seriously  messed up you just can delete the VM and start over.  Second, it  facilitates experimenting with different versions of Ubuntu, Docker, or  other tools than would be available from your desktop.  Third, since  “The Cloud” is built with VM’s, developing in a VM from the start lets  you more closely emulate likely types of environments you’ll be  deploying to.
虽然你当然可以直接在桌面上安装该 `docker.io` 包，正如你在本教程的上一节中所做的那样，但在 VM  中使用它有一些优点。首先，它封装了您要试验的系统更改，以便它们不会影响您的桌面;如果有任何严重混乱，您可以删除 VM  并重新开始。其次，它有助于尝试使用不同版本的 Ubuntu、Docker 或其他工具，而不是从桌面上获得的工具。第三，由于“云”是使用 VM  构建的，因此从一开始就在 VM 中进行开发可以更紧密地模拟将要部署到的可能类型的环境。

There are a number of different VM technologies available, any of which will  suit our purposes, but for this tutorial we’ll set one up using  Canonical’s Multipass software, which you can install [on Windows using a downloadable installer](https://multipass.run/docs/installing-on-windows), or [on macOS via brew](https://multipass.run/docs/installing-on-macos), or [any flavor of Linux via snapd](https://multipass.run/docs/installing-on-linux).
有许多不同的 VM 技术可用，其中任何一种都适合我们的目的，但在本教程中，我们将使用 Canonical 的 Multipass  软件进行设置，您可以使用可下载的安装程序将其安装在 Windows 上，或者通过 brew 安装在 macOS 上，或者通过 snapd  安装任何类型的 Linux。

Here’s how to launch a Ubuntu 22.04 VM with a bit of extra resources, and log in:
下面介绍如何使用一些额外资源启动 Ubuntu 22.04 VM，然后登录：

```
host> multipass launch --cpus 2 --mem 4G --disk 10G --name my-vm daily:20.04
host> multipass shell my-vm
```

If later you wish to suspend or restart the VM, use the stop/start commands:
如果稍后要挂起或重新启动 VM，请使用 stop/start 命令：

```
host> multipass stop my-vm
host> multipass start my-vm
```

Go ahead and set up your new VM devel environment with Docker, your  preferred editor, and any other tools you like having on hand:
继续使用 Docker、您首选的编辑器以及您喜欢的任何其他工具设置新的 VM 开发环境：

```
$ sudo apt-get update
$ sudo apt-get -y install docker.io
```

## Data Customization 数据定制

The most basic customization for a webserver would be the index page.   Let’s replace the default one with the typical hello world example:
Web 服务器最基本的自定义是索引页。让我们用典型的 hello world 示例替换默认的：

```
$ echo '<html><title>Hello Docker...</title><body>Hello Docker!</body></html>' > index.html
```

The technique we’ll use to load this into the webserver container is called *bind mounting a volume*, and this is done with the `-v` (or `--volume`) flag to `docker run` (not to be confused with `docker -v` which of course just prints the docker version).  A *volume* is a file or directory tree or other data on the host we wish to provide via the container.  A *bind mount* means rather than copying the data *into* the container, we establish a linkage between the local file and the file in the container.  Have a look at how this works:
我们将用于将其加载到 Web 服务器容器中的技术称为绑定挂载卷，这是通过 `-v` （或 `--volume` ） 标志 to `docker run` 完成的（当然不要与 `docker -v` 只打印 docker 版本混淆）。卷是我们希望通过容器提供的主机上的文件或目录树或其他数据。绑定挂载意味着我们不是将数据复制到容器中，而是在本地文件和容器中的文件之间建立链接。看看这是如何工作的：

```
$ sudo docker run -d --name my-apache2-container -e TZ=UTC -p 8080:80 -v "${HOME}/index.html:/var/www/html/index.html" ubuntu/apache2:latest
...

$ curl http://localhost:8080
<html><title>Hello Docker...</title></html>

$ sudo docker inspect -f "{{ .Mounts }}" my-apache2-container
[{bind  /home/ubuntu/index.html /var/www/html/index.html   true rprivate}]
```

Watch what happens when we change the `index.html` contents:
观察当我们更改 `index.html` 内容时会发生什么：

```
$ echo '<html><title>...good day!</title></html>' > index.html

$ curl http://localhost:8080
<html><title>...good day</title></html>
```

This linkage is two-way, which means that the container itself can change the data.  (We mentioned *runtime modifications* earlier – this would be an example of doing that.)
这种链接是双向的，这意味着容器本身可以更改数据。（我们之前提到过运行时修改 - 这将是一个示例。

```
$ sudo docker exec -ti my-apache2-container /bin/bash

root@abcd12345678:/# echo '<html><title>Hello, again</title></html>' > /var/www/html/index.html
root@abcd12345678:/# exit
exit

$ curl http://localhost:8080
<html><title>Hello, again</title></html>
```

What if we don’t want that behavior, and don’t want to grant the container  the ability to do so?  We can set the bind mount to be read-only by  appending `:ro`:
如果我们不希望出现这种行为，并且不想授予容器这样做的能力，该怎么办？我们可以通过附加以下内容将绑定挂载设置为只读 `:ro` ：

```
$ sudo docker stop my-apache2-container
$ sudo docker rm my-apache2-container
$ sudo docker run -d --name my-apache2-container -e TZ=UTC -p 8080:80 -v ${HOME}/index.html:/var/www/html/index.html:ro ubuntu/apache2:latest

$ sudo docker exec -ti my-apache2-container /bin/bash

root@abcd12345678:/# echo '<html><title>good day, sir!</title></html>' > /var/www/html/index.html
bash: /var/www/html/index.html: Read-only file system

root@abcd12345678:/# exit

$ curl http://localhost:8080
<html><title>Hello, again</title></html>
```

However, the read-only mount still sees changes on the host side:
但是，只读装载仍会在主机端看到更改：

```
$ echo '<html><title>I said good day!</title></html>' > ./index.html

$ curl http://localhost:8080
<html><title>I said good day!</title></html>
```

This same approach can be used to seed database containers:
可以使用相同的方法为数据库容器设定种子：

```
$ echo 'CREATE DATABASE my_db;' > my-database.sql
$ sudo docker run -d --name my-database -e TZ=UTC \
     -e POSTGRES_PASSWORD=mysecret \
     -v $(pwd)/my-database.sql:/docker-entrypoint-initdb.d/my-database.sql:ro \
     ubuntu/postgres:latest
```

The `docker-entrypoint-initdb.d/` directory we’re using here is special in that files ending in the `.sql` extension (or `.sql.gz` or `.sql.xz`) will be executed to the database on container initialization.  Bash scripts (`.sh`) can also be placed in this directory to perform other initialization steps.
我们在这里使用的 `docker-entrypoint-initdb.d/` 目录很特殊，因为以 `.sql` 扩展名（或 `.sql.gz` `.sql.xz` 或）结尾的文件将在容器初始化时执行到数据库。Bash 脚本 （ `.sh` ） 也可以放在此目录中以执行其他初始化步骤。

Let’s verify the database’s creation:
让我们验证数据库的创建：

```
$ sudo docker exec -ti my-database su postgres --command "psql my_db --command 'SELECT * FROM pg_database WHERE datistemplate = false;'"
oid  | datname  | datdba | encoding | datcollate |  datctype  | datistemplate | datallowconn | datconnlimit | datlastsysoid | datfrozenxid | datminmxid | dattablespace | datacl   -------+----------+--------+----------+------------+------------+---------------+--------------+--------------+---------------+--------------+------------+---------------+--------
13761 | postgres |     10 |        6 | en_US.utf8 | en_US.utf8 | f          | t            |           -1 |         13760 |          727 |          1 |          1663 |
16384 | my_db    |     10 |        6 | en_US.utf8 | en_US.utf8 | f           | t            |           -1 |         13760 |          727 |          1 |          1663 |
(2 rows)
```

## Debugging Techniques 调试技术

Most containers are configured to make pertinent status information (such as their error log) visible through Docker’s `logs` command:
大多数容器都配置为通过 Docker `logs` 的命令使相关状态信息（例如其错误日志）可见：

```
$ sudo docker logs my-apache2-container
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
...
```

Sometimes this isn’t sufficient to diagnose a problem.  In the previous example  we shelled into our container to experiment with, via:
有时，这不足以诊断问题。在前面的示例中，我们通过以下方式进入容器进行实验：

```
$ sudo docker exec -it my-apache2-container /bin/bash
root@abcd12345678:/# cat /proc/cmdline 
BOOT_IMAGE=/boot/vmlinuz-5.15.0-25-generic root=LABEL=cloudimg-rootfs ro console=tty1 console=ttyS0
```

This places you inside a bash shell inside the container; commands you issue will be executed within the scope of the container.  While tinkering  around inside the container isn’t suitable for normal production  operations, it can be a handy way to debug problems such as if you need  to examine logs or system settings.  For example, if you’re trying to  examine the network:
这会将您置于容器内的 bash shell 中;您发出的命令将在容器范围内执行。虽然在容器内部进行修补并不适合正常的生产操作，但它可能是调试问题的便捷方法，例如是否需要检查日志或系统设置。例如，如果您尝试检查网络：

```
root@abcd12345678:/# apt-get update && apt-get install -y iputils-ping iproute2
root@abcd12345678:/# ip addr | grep inet
    inet 127.0.0.1/8 scope host lo
    inet 172.17.0.3/16 brd 172.17.255.255 scope global eth0

root@abcd12345678:/# ping my-apache2-container
ping: my-apache2-container: Name or service not known
root@abcd12345678:/# ping -c1 172.17.0.1 | tail -n2
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.194/0.194/0.194/0.000 ms
root@abcd12345678:/# ping -c1 172.17.0.2 | tail -n2
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.044/0.044/0.044/0.000 ms
root@abcd12345678:/# ping -c1 172.17.0.3 | tail -n2
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
```

We won’t use this container any further, so can remove it:
我们不会进一步使用此容器，因此可以将其删除：

```
$ sudo docker stop my-apache2-container
$ sudo docker rm my-apache2-container
```

## Network 网络

IP addresses may be suitable for debugging purposes, but as we move beyond individual containers we’ll want to refer to them by network hostnames.  First we create the network itself:
IP 地址可能适合用于调试目的，但当我们超越单个容器时，我们将希望通过网络主机名来引用它们。首先，我们创建网络本身：

```
$ sudo docker network create my-network
c1507bc90cfb6100fe0e696986eb99afe64985c7c4ea44ad319f8080e640616b

$ sudo docker network list
NETWORK ID     NAME         DRIVER    SCOPE
7e9ce8e7c0fd   bridge       bridge    local
6566772ff02f   host         host      local
c1507bc90cfb   my-network   bridge    local
8b992742eb38   none         null      local
```

Now when creating containers we can attach them to this network:
现在，在创建容器时，我们可以将它们附加到此网络：

```
$ sudo docker run -d --name my-container-0 --network my-network ubuntu/apache2:latest
$ sudo docker run -d --name my-container-1 --network my-network ubuntu/apache2:latest

$ sudo docker exec -it my-container-0 /bin/bash
root@abcd12345678:/# apt-get update && apt-get install -y iputils-ping bind9-dnsutils 
root@abcd12345678:/# ping my-container-1 -c 1| grep statistics -A1
--- my-container-1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms

root@abcd12345678:/# dig +short my-container-0 my-container-1
172.18.0.2
172.18.0.3

root@abcd12345678:/# exit

$ sudo docker stop my-container-0 my-container-1
$ sudo docker rm my-container-0 my-container-1
```

A common use case for networked containers is load balancing.  Docker’s `--network-alias` option provides one means of setting up *round-robin* load balancing at the network level during container creation:
联网容器的一个常见用例是负载均衡。Docker `--network-alias` 的选项提供了一种在容器创建期间在网络级别设置循环负载均衡的方法：

```
$ sudo docker run -d --name my-container-0 --network my-network --network-alias my-website -e TZ=UTC -p 8080:80 -v ${HOME}/index.html:/var/www/html/index.html:ro ubuntu/apache2:latest
$ sudo docker run -d --name my-container-1 --network my-network --network-alias my-website -e TZ=UTC -p 8081:80 -v ${HOME}/index.html:/var/www/html/index.html:ro ubuntu/apache2:latest
$ sudo docker run -d --name my-container-2 --network my-network --network-alias my-website -e TZ=UTC -p 8082:80 -v ${HOME}/index.html:/var/www/html/index.html:ro ubuntu/apache2:latest

$ sudo docker ps
CONTAINER ID   IMAGE                   COMMAND                CREATED      STATUS      PORTS                                   NAMES
665cf336ba9c   ubuntu/apache2:latest   "apache2-foreground"   4 days ago   Up 4 days   0.0.0.0:8082->80/tcp, :::8082->80/tcp   my-container-2
fd952342b6f8   ubuntu/apache2:latest   "apache2-foreground"   4 days ago   Up 4 days   0.0.0.0:8081->80/tcp, :::8081->80/tcp   my-container-1
0592e413e81d   ubuntu/apache2:latest   "apache2-foreground"   4 days ago   Up 4 days   0.0.0.0:8080->80/tcp, :::8080->80/tcp   my-container-0
```

The `my-website` alias selects a different container for each request it handles, allowing load to be distributed across all of them.
 `my-website` 别名为其处理的每个请求选择不同的容器，从而允许将负载分布在所有请求之间。

```
$ sudo docker exec -it my-container-0 /bin/bash
root@abcd12345678:/# apt update; apt install -y bind9-dnsutils
root@abcd12345678:/# dig +short my-website
172.18.0.3
172.18.0.2
172.18.0.4
```

Run that command several times, and the output should display in a different order each time.
多次运行该命令，每次输出都应以不同的顺序显示。

```
root@abcd12345678:/# dig +short my-website
172.18.0.3
172.18.0.4
172.18.0.2
root@abcd12345678:/# dig +short my-website
172.18.0.2
172.18.0.3
172.18.0.4
root@abcd12345678:/# exit

$ sudo docker stop my-container-0 my-container-1  my-container-2
$ sudo docker rm my-container-0 my-container-1  my-container-2
```

## Installing Software 安装软件

By default Apache2 can serve static pages, but for more than that it’s  necessary to enable one or more of its modules.  As we mentioned above,  there are three approaches you could take:  Set things up at runtime by  logging into the container and running commands directly; configuring  the container at creation time; or, customizing the image definition  itself.
默认情况下，Apache2 可以提供静态页面，但除此之外，还需要启用一个或多个模块。正如我们上面提到的，您可以采取三种方法：通过登录容器并直接运行命令在运行时进行设置;在创建时配置容器;或者，自定义图像定义本身。

Ideally, we’d use the second approach to pass a parameter or setup.sh script to install software and run `a2enmod <mod>`, however the Apache2 image lacks the equivalent of Postgres’ `/docker-entrypoint-initdb.d/` directory and automatic processing of shell scripts.  So for a  production system you’d need to derive your own customized Apache2 image and build containers from that.
理想情况下，我们会使用第二种方法来传递参数或 setup.sh 脚本来安装软件并运行 `a2enmod <mod>` ，但是 Apache2 映像缺少 Postgres `/docker-entrypoint-initdb.d/` 目录的等效项和对 shell 脚本的自动处理。因此，对于生产系统，您需要派生自己的自定义 Apache2 映像并从中构建容器。

For the purposes of this tutorial, though, we can use the runtime configuration approach just for experimental purposes.
但是，出于本教程的目的，我们可以仅将运行时配置方法用于实验目的。

First, create our own config file that enables CGI support:
首先，创建我们自己的配置文件来启用 CGI 支持：

```
$ cat > ~/my-apache2.conf << 'EOF'
User ${APACHE_RUN_USER}
Group ${APACHE_RUN_GROUP}
ErrorLog ${APACHE_LOG_DIR}/error.log
ServerName localhost
HostnameLookups Off
LogLevel warn
Listen 80

# Include module configuration:
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf

<Directory />
        AllowOverride None
        Require all denied
</Directory>

<Directory /var/www/html/>
        AllowOverride None
        Require all granted
</Directory>

<Directory /var/www/cgi-bin/>
        AddHandler cgi-script .cgi
        AllowOverride None
        Options +ExecCGI -MultiViews
        Require all granted
</Directory>

<VirtualHost *:80>
        DocumentRoot /var/www/html/
        ScriptAlias /cgi-bin/ /var/www/cgi-bin/
</VirtualHost>
EOF
```

Next, copy the following into a file named `fortune.cgi`.
接下来，将以下内容复制到名为 `fortune.cgi` 的文件中。

```
$ cat > ~/fortune.cgi << 'EOF'
#!/usr/bin/env bash
echo -n -e "Content-Type: text/plain\n\n"
echo "Hello ${REMOTE_ADDR}, I am $(hostname -f) at ${SERVER_ADDR}"
echo "Today is $(date)"
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune
fi
EOF
$ chmod a+x ~/fortune.cgi
```

Now create our container:
现在创建我们的容器：

```
$ sudo docker run -d --name my-fortune-cgi -e TZ=UTC -p 9080:80 \
     -v $(pwd)/my-apache2.conf:/etc/apache2/apache2.conf:ro \
     -v $(pwd)/fortune.cgi:/var/www/cgi-bin/fortune.cgi:ro \
     ubuntu/apache2:latest
c3709dc03f24fbf862a8d9499a03015ef7ccb5e76fdea0dc4ac62a4c853597bf
```

Next, perform the runtime configuration steps:
接下来，执行运行时配置步骤：

```
$ sudo docker exec -it my-fortune-cgi /bin/bash

root@abcd12345678:/# apt-get update && apt-get install -y fortune
root@abcd12345678:/# a2enmod cgid
root@abcd12345678:/# service apache2 force-reload
```

Finally, restart the container so our changes take effect:
最后，重新启动容器，以便我们的更改生效：

```
$ sudo docker restart my-fortune-cgi
my-fortune-cgi
```

Let’s test it out:
让我们测试一下：

```
$ curl http://localhost:9080/cgi-bin/fortune.cgi
Hello 172.17.0.1, I am 8ace48b71de7 at 172.17.0.2
Today is Wed Jun  1 16:59:40 UTC 2022
Q:	Why is Christmas just like a day at the office?
A:	You do all of the work and the fat guy in the suit
        gets all the credit.
```

Finally is cleanup, if desired:
最后是清理，如果需要：

```
$ sudo docker stop my-fortune-cgi
$ sudo docker rm my-fortune-cgi
```

## Next 下一个

While it’s interesting to be able to customize a basic container, how can we  do this without resorting to runtime configuration?  As well, a single  container by itself is not terrible useful, so in the [next section](https://ubuntu.com/server/docs/multi-node-rock-configuration-with-docker-compose) we’ll practice setting up a database node to serve data to our webserver.
虽然能够自定义基本容器很有趣，但我们如何在不求助于运行时配置的情况下做到这一点？同样，单个容器本身并不是很有用，因此在下一节中，我们将练习设置一个数据库节点来为我们的 Web 服务器提供数据。

# Multi-node ROCK configuration with Docker-Compose 使用 Docker-Compose 的多节点 ROCK 配置

The [prior section](https://ubuntu.com/server/docs/rock-customisation-with-docker) explained the use of a single container for running a single software  instance, but the principle benefit of using ROCKs is the ability to  easily create and architecturally organize, or “orchestrate”, them to  operate together in a modular fashion.
上一节解释了使用单个容器来运行单个软件实例，但使用 ROCK 的主要好处是能够轻松地创建和架构组织或“编排”它们以模块化方式一起运行。

If you set up a VM while following that section, you can continue to use  that here, or if not feel free to create a new VM for this section,  using those same directions.
如果在遵循该部分时设置了 VM，则可以在此处继续使用它，或者如果不能，请使用相同的说明为本部分创建新的 VM。

### Colors Web App Colors Web 应用程序

This section will demonstrate use of `docker-compose` to set up two nodes that inter-operate to implement a trivial CGI web  app that lets the user select a background color from the standard `rgb.txt` color codes.  Here’s the table definition itself:
本部分将演示如何使用 来 `docker-compose` 设置两个节点，这两个节点可以互操作以实现一个简单的 CGI Web 应用程序，该应用程序允许用户从标准 `rgb.txt` 颜色代码中选择背景颜色。下面是表定义本身：

```
$ cat > ~/my-color-database.sql <<'EOF'
CREATE DATABASE my_color_db;

CREATE TABLE "color"
(
    id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    red INTEGER,
    green INTEGER,
    blue INTEGER,
    colorname VARCHAR NOT NULL
);

REVOKE ALL ON "color" FROM public;
GRANT SELECT ON "color" TO "postgres";

EOF
```

For the data, we’ll scarf up X11’s `rgb.txt` file, which should be readily at hand with most Ubuntu desktop installations:
对于数据，我们将围起来 X11 `rgb.txt` 的文件，它应该很容易与大多数 Ubuntu 桌面安装一起使用：

```
$ sudo apt-get install x11-common
$ grep -v ^! /usr/share/X11/rgb.txt | \
  awk 'BEGIN{print "INSERT INTO color(red, green, blue, colorname) VALUES"}
      $1 != $2 || $2 != $3 {
          printf("    (%d, %d, %d, '\''", $1, $2, $3);
          for (i = 4; i <= NF; i++) {
              printf("%s", $i);
          }
          printf("'\''),\n");
     }
  END  {print "    (0, 0, 0, '\''black'\'');"}' >> ~/my-color-database.sql
```

Here’s the corresponding CGI script:
下面是相应的 CGI 脚本：

```
$ cat > ~/my-colors.cgi <<'EOF'
#!/usr/bin/env python3

import cgi
import psycopg2

# Get web form data (if any)
query_form = cgi.FieldStorage()
if 'bgcolor' in query_form.keys():
    bgcolor = query_form["bgcolor"].value
else:
    bgcolor = 'FFFFFF'

print("Content-Type: text/html\n\n");

# Head
body_style = "body { background-color: #%s; }" %(bgcolor)
text_style = ".color-invert { filter: invert(1); mix-blend-mode: difference; }"
print(f"<html>\n<head><style>\n{body_style}\n{text_style}\n</style></head>\n")
print("<body>\n<h1 class=\"color-invert\">Pick a background color:</h1>\n")
print("<table width=\"500\" cellspacing=\"0\" cellpadding=\"0\">\n")
print("  <tr><th width=\"50\">Color</th><th>Name</th><th width=\"100\">Code</th></tr>\n")

# Connect database
db = psycopg2.connect(host='examples_postgres_1', user='postgres', password='myS&cret')

# Display the colors
colors = db.cursor()
colors.execute("SELECT * FROM color;")
for row in colors.fetchall():
    code = ''.join('{:02X}'.format(a) for a in row[1:4])
    color = row[4]
    print(f"  <tr style=\"background-color:#{code}\">\n")
    print(f"    <td><a href=\"my-colors.cgi?bgcolor={code}\">{color}</td>\n")
    print(f"    <td>{code}</td></tr>\n")

# Foot
print("</table>\n")
print("</body>\n</html>\n")
EOF
```

By default, Apache2 is configured to allow CGI scripts in the `/usr/lib/cgi-bin` system directory, but rather than installing the script there, let’s use our own directory to serve from:
默认情况下，Apache2 配置为允许 `/usr/lib/cgi-bin` 在系统目录中使用 CGI 脚本，但与其在那里安装脚本，不如使用我们自己的目录来提供：

```
$ cat > ~/my-apache.conf <<'EOF'
User ${APACHE_RUN_USER}
Group ${APACHE_RUN_GROUP}
ErrorLog ${APACHE_LOG_DIR}/error.log
ServerName localhost
HostnameLookups Off
LogLevel warn
Listen 80

# Include module configuration:
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf

<Directory />
        AllowOverride None
        Require all denied
</Directory>

<Directory /var/www/html/>
        AllowOverride None
        Require all granted
</Directory>

<Directory /var/www/cgi-bin/>
        AddHandler cgi-script .cgi
        AllowOverride None
        Options +ExecCGI -MultiViews
        Require all granted
</Directory>

<VirtualHost *:80>
        DocumentRoot /var/www/html/
        ScriptAlias /cgi-bin/ /var/www/cgi-bin/
</VirtualHost>
EOF
```

### Install Docker Compose 安装 Docker Compose

With our web app developed, we’re ready to containerize it.  We’ll install  Docker Compose, pull in the two base images for the database and web  server, and create our own containers with our web app files and  configuration layered on top.
随着 Web 应用程序的开发，我们已准备好将其容器化。我们将安装 Docker Compose，拉取数据库和 Web 服务器的两个基本映像，并创建我们自己的容器，并将我们的 Web 应用程序文件和配置分层在上面。

First, install what we’ll need:
首先，安装我们需要的东西：

```
$ sudo apt-get update
$ sudo apt-get install -y docker.io docker-compose
```

### Create Database Container 创建数据库容器

Next, prepare the Postgres container.  Each of Ubuntu’s Docker Images has a  git repository, referenced from the respective Docker Hub page.  These  repositories include some example content that we can build from:
接下来，准备 Postgres 容器。每个 Ubuntu 的 Docker 镜像都有一个 git 存储库，从相应的 Docker Hub 页面引用。这些存储库包括一些我们可以从中构建的示例内容：

```
$ git clone https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/postgresql my-postgresql-oci
$ cd my-postgresql-oci/
$ git checkout origin/14-22.04 -b my-postgresql-oci-branch
$ find ./examples/ -type f
./examples/README.md
./examples/postgres-deployment.yml
./examples/docker-compose.yml
./examples/config/postgresql.conf
```

Notice the two YAML files.  The `docker-compose.yml` file lets us create a derivative container where we can insert our own  customizations such as config changes and our own SQL data to  instantiate our database.  (The other YAML file is for Kubernetes-based  deployments.)
请注意两个 YAML 文件。该 `docker-compose.yml` 文件允许我们创建一个派生容器，我们可以在其中插入我们自己的自定义项，例如配置更改和我们自己的 SQL 数据来实例化我们的数据库。（另一个 YAML 文件用于基于 Kubernetes 的部署。

```
$ mv -iv ~/my-color-database.sql ./examples/
renamed '/home/ubuntu/my-color-database.sql' -> './examples/my-color-database.sql'
$ git add ./examples/my-color-database.sql
```

Modify the services section of the file `examples/docker-compose.yml` to look like this:
修改文件 `examples/docker-compose.yml` 的 services 部分，如下所示：

```
services:
    postgres:
        image: ubuntu/postgres:14-22.04_beta
        ports:
            - 5432:5432
        environment:
            - POSTGRES_PASSWORD=myS&cret
        volumes:
            - ./config/postgresql.conf:/etc/postgresql/postgresql.conf:ro
            - ./my-color-database.sql:/docker-entrypoint-initdb.d/my-color-database.sql:ro
```

The volumes section of the file lets us bind files from our local git repository into our new container.  Things like the `postgresql.conf` configuration file get installed to the normal system as you’d expect.
该文件的 volumes 部分允许我们将本地 git 存储库中的文件绑定到新容器中。像 `postgresql.conf` 配置文件这样的东西会像你所期望的那样安装到普通系统中。

But the `/docker-entrypoint-initdb.d/` directory will look unusual – this is a special directory provided by  Ubuntu’s Postgres Docker container that will automatically run `.sql` (or `.sql.gz` or `.sql.xz`) and `.sh` files through the `psql` interpreter during initialization, in POSIX alphanumerical order.  In our case we have a single `.sql` file that we want invoked during initialization.
但是该 `/docker-entrypoint-initdb.d/` 目录看起来很不寻常——这是 Ubuntu 的 Postgres Docker 容器提供的特殊目录，它将在初始化期间以 POSIX 字母数字顺序自动运行 `.sql` （或 `.sql.xz` 或）并通过 `psql` 解释器 `.sh` 运行（或 `.sql.gz` ）和文件。在我们的例子中，我们有一个 `.sql` 文件，我们希望在初始化期间调用它。

Ubuntu’s ROCKs are also built with environment variables to customize behavior;  above we can see where we can specify our own password.
Ubuntu 的 ROCK 也是用环境变量构建的，用于自定义行为;上面我们可以看到在哪里可以指定自己的密码。

Commit everything so far to our branch:
将到目前为止的所有内容都提交到我们的分支：

```
$ git commit -a -m "Add a color database definition"
[my-postgresql-oci-branch 0edeb20] Add a color database definition
 2 files changed, 549 insertions(+)
 create mode 100644 examples/my-color-database.sql
```

Now we’re ready to create and start our application’s database container:
现在，我们已准备好创建并启动应用程序的数据库容器：

```
$ cd ./examples/
$ sudo docker-compose up -d
Pulling postgres (ubuntu/postgres:edge)...
...
Creating examples_postgres_1 ... done

$ sudo docker-compose logs
...
postgres_1  | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/my-color-database.sql
...
postgres_1  | 2022-06-02 03:14:28.040 UTC [1] LOG:  database system is ready to accept connections
```

The `-d` flag causes the container to run in the background (you might omit it  if you want to run it in its own window so you can watch the service log info live.)
该 `-d` 标志会导致容器在后台运行（如果要在容器自己的窗口中运行容器，则可以省略它，以便可以实时查看服务日志信息。

Note that if there is an error, such as a typo in your `.sql` file, you can’t just re-run `docker-compose up` (or `restart`) because it’ll attempt to re-attach and may appear successful at first glance:
请注意，如果出现错误，例如 `.sql` 文件中的拼写错误，则不能重新运行 `docker-compose up` （或 `restart` ），因为它会尝试重新附加，乍一看可能会成功：

```
...
postgres_1  | psql:/docker-entrypoint-initdb.d/my-color-database.sql:10: ERROR:  type "sometypo" does not exist
postgres_1  | LINE 3:     "id" SOMETYPO,
postgres_1  |                  ^
examples_postgres_1 exited with code 3

$ sudo docker-compose up
Starting examples_postgres_1 ... done
Attaching to examples_postgres_1
postgres_1  |
postgres_1  | PostgreSQL Database directory appears to contain a database; Skipping initialization
...
postgres_1  | 2022-06-02 04:00:51.400 UTC [25] LOG:  database system was not properly shut down; automatic recovery in progress
...
postgres_1  | 2022-06-02 04:00:51.437 UTC [1] LOG:  database system is ready to accept connections
```

However, while there is a live database, our data didn’t load into it so it is invalid.
但是，虽然有一个实时数据库，但我们的数据没有加载到其中，因此它是无效的。

Instead, always issue a down command before attempting a restart when fixing issues:
相反，在解决问题时，在尝试重新启动之前，请始终发出 down 命令：

```
$ sudo docker-compose down; sudo docker-compose up
...
```

Note that in our environment `docker-compose` needs to be run with root permissions; if it isn’t, you may see an error similar to this:
请注意，在我们的环境中 `docker-compose` 需要使用 root 权限运行;如果不是，您可能会看到类似于以下内容的错误：

```
ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?
If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.
```

At this point we could move on to the webserver container, but we can  double-check our work so far by installing the Postgres client locally  in the VM and running a sample query:
此时，我们可以继续使用 Web 服务器容器，但我们可以通过在 VM 中本地安装 Postgres 客户端并运行示例查询来仔细检查我们迄今为止的工作：

```
$ sudo apt-get install postgresql-client
$ psql -h localhost -U postgres
Password for user postgres: myS&cret
postgres=# \d
              List of relations
 Schema |     Name     |   Type   |  Owner
--------+--------------+----------+----------
 public | color        | table    | postgres
 public | color_id_seq | sequence | postgres
(2 rows)

postgres=# SELECT * FROM color WHERE id<4;
 id | red | green | blue | colorname
----+-----+-------+------+------------
  1 | 255 |   250 |  250 | snow
  2 | 248 |   248 |  255 | ghostwhite
  3 | 248 |   248 |  255 | GhostWhite
(3 rows)
```

### Create Webserver Docker Container 创建 Webserver Docker 容器

Now we do the same thing for the Apache2 webserver.
现在我们对 Apache2 Web 服务器做同样的事情。

Get the example files from Canonical’s Apache2 image repository via git:
通过 git 从 Canonical 的 Apache2 镜像库中获取示例文件：

```
$ cd ~
$ git clone https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/postgresql my-postgresql-oci
$ cd my-apache2-oci/
$ git checkout origin/2.4-22.04 -b my-apache2-oci-branch
$ find ./examples/ -type f
./examples/apache2-deployment.yml
./examples/README.md
./examples/docker-compose.yml
./examples/config/apache2.conf
./examples/config/html/index.html

$ mv -ivf ~/my-apache2.conf ./examples/config/apache2.conf
renamed '/home/ubuntu/my-apache2.conf' -> './examples/config/apache2.conf'
$ mv -iv ~/my-colors.cgi ./examples/
renamed '/home/ubuntu/my-colors.cgi' -> 'examples/my-colors.cgi'
$ chmod a+x ./examples/my-colors.cgi
$ git add ./examples/config/apache2.conf ./examples/my-colors.cgi
```

Modify the `examples/docker-compose.yml` file to look like this:
将 `examples/docker-compose.yml` 文件修改为如下所示：

```
version: '2'

services:
    apache2:
        image: ubuntu/apache2:2.4-22.04_beta
        ports:
            - 8080:80
        volumes:
            - ./config/apache2.conf:/etc/apache2/apache2.conf:ro
            - ./config/html:/srv/www/html/index.html:ro
            - ./my-colors.cgi:/var/www/cgi-bin/my-colors.cgi:ro
        command: bash -c "apt-get update && apt-get -y install python3 python3-psycopg2; a2enmod cgid; apache2-foreground"
        restart: always
```

Commit everything to the branch:
将所有内容提交到分支：

```
$ git commit -a -m "Add a color CGI web application"
```

Now launch the web server container:
现在启动 Web 服务器容器：

```
$ cd ./examples/
$ sudo docker-compose up -d
```

You will now be able to connect to the service:
现在，您将能够连接到该服务：

```
$ firefox http://localhost:8080/cgi-bin/my-colors.cgi?bgcolor=FFDEAD
```

![colors_screenshot_1](https://assets.ubuntu.com/v1/cc77bef8-colors_screenshot_1.png)

Click on one of the colors to see the background color change:
单击其中一种颜色可查看背景颜色更改：

![colors_screenshot_2](https://assets.ubuntu.com/v1/62100d84-colors_screenshot_2.png)

Once you’re done, if you wish you can cleanup the containers as before, or  if you used Multipass you can shutdown and delete the VM:
完成后，如果希望可以像以前一样清理容器，或者使用 Multipass，则可以关闭并删除 VM：

```
$ exit
host> multipass stop my-vm
host> multipass delete my-vm
```

### Next Steps 后续步骤

As you can see, docker-compose makes it convenient to set up  multi-container applications without needing to perform runtime changes  to the containers.  As you can imagine, this can permit building a more  sophisticated management system to handle fail-over, load-balancing,  scaling, upgrading old nodes, and monitoring status.  But rather than  needing to implement all of this directly on top of docker-container,  you can next investigate Kubernetes-style cluster management software  such as [microk8s](https://microk8s.io/docs).
正如你所看到的，docker-compose  可以方便地设置多容器应用程序，而无需对容器执行运行时更改。可以想象，这可以允许构建一个更复杂的管理系统来处理故障转移、负载平衡、扩展、升级旧节点和监控状态。但是，与其直接在docker-container上实现所有这些，不如接下来研究Kubernetes风格的集群管理软件，如microk8s。

------