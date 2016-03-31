# Node.js

Node.js 是建立在谷歌的 V8 JavaScript 引擎服务器端的软件平台上。在构建高性能的服务器端应用程序上，Node.js 在 JavaScript 中已是首选方案。Node.js 自带一个被称为 npm 的命令行工具可以轻松地安装它，进行版本控制并使用 npm 的在线仓库来管理 Node.js 库和应用程序的依赖关系。

## 安装

在 Debian 上安装 Node.js on

    $ sudo apt-get install npm

在 Debian 7 (Wheezy) 以前的版本中,要使用下面的方式来源码安装：

    $ sudo apt-get install python g++ make
    $ wget http://nodejs.org/dist/node-latest.tar.gz
    $ tar xvfvz node-latest.tar.gz
    $ cd node-v0.10.21 (replace a version with your own)
    $ ./configure
    $ make
    $ sudo make install

在 Ubuntu 或 Linux Mint 中安装 Node.js

Node.js 被包含在 Ubuntu（13.04 及更高版本）。因此，安装非常简单。以下方式将安装 Node.js 和 npm。

    $ sudo apt-get install npm
    $ sudo ln -s /usr/bin/nodejs /usr/bin/node

而 Ubuntu 中的 Node.js 可能版本比较老，你可以从 其 PPA 中安装最新的版本。

    $ sudo apt-get install python-software-properties python g++ make
    $ sudo add-apt-repository -y ppa:chris-lea/node.js
    $ sudo apt-get update
    $ sudo apt-get install npm

在 Fedora 中安装 Node.js

Node.js 被包含在 Fedora 的 base 仓库中。因此，你可以在 Fedora 中用 yum 安装 Node.js。

    $ sudo yum install npm

如果你想安装 Node.js 的最新版本，可以按照以下步骤使用源码来安装。

    $ sudo yum groupinstall 'Development Tools'
    $ wget http://nodejs.org/dist/node-latest.tar.gz
    $ tar xvfvz node-latest.tar.gz
    $ cd node-v0.10.21 (replace a version with your own)
    $ ./configure
    $ make
    $ sudo make install

在 CentOS 或 RHEL 中安装 Node.js

在 CentOS 使用 yum 包管理器来安装 Node.js，首先启用 EPEL 软件库，然后运行：

    $ sudo yum install npm

在 Arch Linux 上安装 Node.js

    $ sudo pacman -S nodejs npm

