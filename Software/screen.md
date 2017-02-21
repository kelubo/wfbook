screen 命令使用及示例

screen 是一个非常有用的命令，提供从单个 SSH 会话中使用多个 shell 窗口（会话）的能力。当会话被分离或网络中断时，screen 会话中启动的进程仍将运行，你可以随时重新连接到 screen 会话。如果你想运行一个持久的进程或者从多个位置连接到 shell 会话，这也很方便。

在本文中，我们将展示在 Linux 上安装和使用 screen 的基本知识。
如何安装 screen

screen 在一些流行的发行版上已经预安装了。你可以使用下面的命令检查是否已经在你的服务器上安装了。

    screen -v
    Screen version 4.00.03 (FAU)

如果在 Linux 中还没有 screen，你可以使用系统提供的包管理器很简单地安装它。

CentOS/RedHat/Fedora

    yum -y install screen

Ubuntu/Debian

    apt-get -y install screen

如何启动一个 screen 会话

你可以在命令行中输入 screen 来启动它，接着会有一个看上去和命令行提示符一样的 screen 会话启动。

    screen

使用描述性名称启动屏幕会话是一个很好的做法，这样你可以轻松地记住会话中正在运行的进程。要使用会话名称创建新会话，请运行以下命令：

    screen -S name

将 “name” 替换为对你会话有意义的名字。
从 screen 会话中分离

要从当前的 screen 会话中分离，你可以按下 Ctrl-A 和 d。所有的 screen 会话仍将是活跃的，你之后可以随时重新连接。
重新连接到 screen 会话

如果你从一个会话分离，或者由于某些原因你的连接被中断了，你可以使用下面的命令重新连接：

    screen -r

如果你有多个 screen 会话，你可以用 ls 参数列出它们。

    screen -ls
    There are screens on:
    7880.session    (Detached)
    7934.session2   (Detached)
    7907.session1   (Detached)
    3 Sockets in /var/run/screen/S-root.

在我们的例子中，我们有三个活跃的 screen 会话。因此，如果你想要还原 “session2” 会话，你可以执行：

    screen -r 7934

或者使用 screen 名称。

    screen -r -S session2

中止 screen 会话

有几种方法来中止 screen 会话。你可以按下 Ctrl+d，或者在命令行中使用 exit 命令。

要查看 screen 命令所有有用的功能，你可以查看 screen 的 man 手册。

    man screen
    NAME
    screen - screen manager with VT100/ANSI terminal emulation
    SYNOPSIS
    screen [ -options ] [ cmd [ args ] ]
    screen -r [[pid.]tty[.host]]
    screen -r sessionowner/[[pid.]tty[.host]]
