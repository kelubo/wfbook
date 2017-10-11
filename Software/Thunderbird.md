# 在 Linux 中安装最新的 Thunderbird 邮件客户端
雷鸟是一个开源自由的跨平台的基于 web 的电子邮件、新闻和聊天客户端应用程序，其旨在用于管理多个电子邮件帐户和新闻源。

在 2016 年 12 月 28 日，Mozilla 团队宣布 Thunderbird 45.6.0 的发布。这个新版本带有如下功能：
Thunderbird 45.6.0 功能

    每次启动 Thunderbird 时都会显示系统集成对话框
    各种错误修复和性能改进。
    各种安全修复。

查看更多关于 Thunderbird 45.6.0 版本的新功能和已知问题在 Thunderbird 发行说明中有。

本文将解释如何在 Linux 发行版（如 Fedora、Ubuntu 及其衍生版）中安装 Thunderbird 邮件客户端。

在许多 Linux 发行版中，Thunderbird 包已经默认包含在内，并且可以使用默认包管理系统来安装，这样可以：

    确保你具有所有需要的库
    添加桌面快捷方式以启动 Thunderbird
    使 Thunderbird 可供计算机上的所有系统用户访问
    它可能不会为你提供最新版本的 Thunderbird

在 Linux 中安装 Thunderbird 邮件客户端

要从系统默认仓库中安装 Thunderbird：

    $ sudo apt-get install thunderbird   [在基于 Ubuntu 的系统中]
    $ dnf install thunderbird            [在基于 Fedora 的系统中]

如我所说，从默认仓库中安装的话将带给你的是旧版本 Thunderbird。如果要安装最新版本的 Mozilla Thunderbird，可以使用 Mozilla 团队维护的 PPA。

在 Ubuntu 及其衍生版中使用 CTRL + ALT + T 从桌面打开终端并添加 Thunderbird 仓库。

    $ sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa

接下来，使用 apt-get update 命令升级软件包。

    $ sudo apt-get update

系统升级完成后，使用下面的命令安装。

    $ sudo apt-get install thunderbird
