# Ubuntu

[TOC]

## 概述

**Ubuntu Server** 是 Ubuntu 操作系统的一个版本，是作为互联网的骨干而设计和制造的。

## Support

There are a couple of different ways that the Ubuntu Server edition is  supported: commercial support and community support. The main commercial support (and development funding) is available from Canonical, Ltd.  They supply reasonably- priced support contracts on a per desktop or  per-server basis. For more information see the [Ubuntu Advantage](http://www.ubuntu.com/advantage) page.

Community support is also provided by dedicated individuals and companies that  wish to make Ubuntu the best distribution possible. Support is provided  through multiple mailing lists, IRC channels, forums, blogs, wikis, etc. The large amount of information available can be overwhelming, but a  good search engine query can usually provide an answer to your  questions. See the [Ubuntu Support](https://ubuntu.com/support/community-support) page for more information.

​				

# Package Management



# Package management 包管理 

Ubuntu features a comprehensive package management system for installing, upgrading, configuring, and removing software.
Ubuntu提供了一个全面的软件包管理系统，用于安装、升级、配置和删除软件。 

It provides access to an organised base of over 60,000 software packages  for your Ubuntu computer, and includes the ability to resolve  dependencies and check for software updates.
它为您的Ubuntu计算机提供了对超过60，000个软件包的有组织的基础的访问，并包括解决依赖关系和检查软件更新的能力。 

Several tools are available for interacting with Ubuntu’s package management  system, from command-line utilities that can be easily automated by  system administrators, to an easy-to-use graphical interface for those  new to Ubuntu.
有几个工具可用于与Ubuntu的软件包管理系统进行交互，从系统管理员可以轻松自动化的命令行实用程序到Ubuntu新手易于使用的图形界面。 

## Introduction 介绍 

Ubuntu’s package management system is derived from the same system used by the  Debian GNU/Linux distribution. The package files contain all the  necessary files, metadata, and instructions to implement a particular  function or software application on your Ubuntu computer.
Ubuntu的软件包管理系统源自Debian GNU/Linux发行版所使用的同一系统。软件包文件包含在Ubuntu计算机上实现特定功能或软件应用程序所需的所有文件、元数据和指令。 

Debian package files typically have the extension `.deb`, and usually exist in **repositories**, which are collections of packages typically found online, or on  physical media such as CD-ROMs. Packages are normally in a pre-compiled  binary format; installation is quick and requires no software  compilation.
Debian软件包文件通常具有扩展名 `.deb` ，并且通常存在于存储库中，这些存储库通常是在线或物理介质（如CD-ROM）上的软件包集合。软件包通常是预编译的二进制格式;安装很快，不需要软件编译。

Many packages use **dependencies**. Dependencies are additional packages required by a given package for it to function properly. For example, the speech synthesis package `festival` depends upon the package `alsa-utils`, which is a package supplying the [Advanced Linux Sound Architecture (ALSA)](https://www.alsa-project.org/wiki/Main_Page) sound library tools needed for audio playback. For `festival` to function, it – and all of its dependencies – must be installed. The  software management tools in Ubuntu will do this automatically.
许多包使用依赖项。附加包是一个给定的包所需要的附加包，以使其正常工作。例如，语音合成包 `festival` 依赖于包 `alsa-utils` ，包 `alsa-utils` 是提供音频回放所需的高级Linux声音体系结构（ALSA）声音库工具的包。要使 `festival` 正常工作，必须安装它及其所有依赖项。Ubuntu中的软件管理工具将自动执行此操作。

## Advanced Packaging Tool 高级封装工具 

The `apt` command is a powerful command-line tool, which works with Ubuntu’s  Advanced Packaging Tool (APT). The commands contained within `apt` provide the means to install new software packages, upgrade existing  software packages, update the package list index, and even upgrade the  entire Ubuntu system.
 `apt` 命令是一个强大的命令行工具，它与Ubuntu的高级打包工具（APT）一起工作。 `apt` 中包含的命令提供了安装新软件包、升级现有软件包、更新软件包列表索引，甚至升级整个Ubuntu系统的方法。

Actions of the `apt` command, such as installation and removal of packages, are logged in the `/var/log/dpkg.log` log file.
 `apt` 命令的操作（如安装和删除软件包）将记录在 `/var/log/dpkg.log` 日志文件中。

Some examples of popular uses for `apt` include:
 `apt` 的一些常见用途包括：

### Installing packages 安装包 

As an example, to install the `nmap` network scanner, run the following command:
例如，要安装 `nmap` 网络扫描程序，请运行以下命令：

```bash
sudo apt install nmap
```

> **Tip**: 提示：
>  You can install or remove multiple packages at once by separating them with spaces.
>  您可以一次安装或删除多个软件包，方法是用空格分隔它们。

### Removing packages 去除包 

To remove the package installed in the previous example, run the following:
要删除在上一个示例中安装的程序包，请运行以下命令： 

```bash
sudo apt remove nmap
```

Adding the `--purge` option to `apt remove` will remove the package configuration files as well. This may or may not be what you want, so use it with caution.
将 `--purge` 选项添加到 `apt remove` 也会删除包配置文件。这可能是你想要的，也可能不是，所以要小心使用。

> **Note**: 注意事项：
>  While `apt` is a command-line tool, it is intended to be used interactively, and not to be called from non-interactive scripts. The `apt-get` command should be used in scripts (perhaps with the `--quiet` flag). For basic commands the syntax of the two tools is identical.
>  虽然 `apt` 是一个命令行工具，但它旨在以交互方式使用，而不是从非交互式脚本中调用。 `apt-get` 命令应该在脚本中使用（可能带有 `--quiet` 标志）。对于基本命令，这两个工具的语法是相同的。

### Updating the package index 更新包索引 

The APT package index is a database of available packages from the repositories defined in the `/etc/apt/sources.list` file and in the `/etc/apt/sources.list.d` directory. To update the local package index with the latest changes made in the repositories, type the following:
APT软件包索引是一个数据库，包含了在 `/etc/apt/sources.list` 文件和 `/etc/apt/sources.list.d` 目录中定义的存储库中的可用软件包。要使用存储库中的最新更改更新本地包索引，请键入以下内容：

```bash
sudo apt update
```

### Upgrading packages 升级软件包 

Installed packages on your computer may periodically have upgrades available from the package repositories (e.g., security updates). To upgrade your  system, first update your package index and then perform the upgrade –  as follows:
您计算机上已安装的软件包可能会定期从软件包存储库（例如，安全更新）。要升级您的系统，请先更新软件包索引，然后执行升级-如下所示： 

```bash
sudo apt update
sudo apt upgrade
```

For details on how to upgrade to a new Ubuntu release, see our [guide on upgrading releases](https://ubuntu.com/server/docs/how-to-upgrade-your-release). For further information about using APT, read the comprehensive [APT User’s Guide](https://www.debian.org/doc/user-manuals#apt-guide), or type `apt help`.
有关如何升级到新Ubuntu版本的详细信息，请参阅我们的版本升级指南。有关使用APT的更多信息，请阅读全面的APT用户指南，或键入 `apt help` 。

## Aptitude 资质 

Launching Aptitude with no command-line options will give you a menu-driven,  text-based frontend to the APT system. Many of the common package  management functions, such as installation, removal, and upgrade, can be performed in Aptitude with single-key commands, which are typically  lowercase letters.
在没有命令行选项的情况下启动Aptitude将给予一个菜单驱动的、基于文本的APT系统前端。许多常见的软件包管理功能，如安装，删除和升级，可以在Aptitude中使用单键命令执行，这些命令通常是字母。 

Aptitude is best suited for use in a non-graphical terminal environment to  ensure the command keys work properly. You can start the menu-driven  interface of Aptitude as a regular user by typing the following command  at a terminal prompt:
Aptitude最适合在非图形终端环境中使用，以确保命令键正常工作。作为普通用户，您可以在终端提示符处键入以下命令，启动Aptitude的菜单驱动界面： 

```bash
sudo aptitude
```

When Aptitude starts, you will see a menu bar at the top of the screen and  two panes below the menu bar. The top pane contains package categories,  such as “New Packages” and “Not Installed Packages”. The bottom pane  contains information related to the packages and package categories.
当Aptitude启动时，您将在屏幕顶部看到一个菜单栏，菜单栏下方有两个窗格。顶部窗格包含软件包类别，例如“新建软件包”和“未安装的软件包”。底部窗格包含与包和包类别相关的信息。 

Using Aptitude for package management is relatively straightforward thanks to its user interface. The following are examples of common package  management functions as performed in Aptitude:
使用Aptitude进行包管理相对简单，这要归功于它的用户界面。以下是在Aptitude中执行的常见软件包管理功能的示例： 

### Installing packages 安装包 

To install a package, locate it in the “Not Installed Packages” category by using the keyboard arrow keys and the Enter key.
要安装软件包，请使用键盘箭头键和 Enter 键在“未安装的软件包”类别中找到该软件包。

Highlight the desired package, then press the + key. The package entry should turn **green**, which indicates it has been marked for installation. Now press g to be presented with a summary of package actions. Press g again, and the package will be downloaded and installed. When finished, press Enter to return to the menu.
突出显示所需的软件包，然后按 + 键。软件包条目应变为绿色，表示已标记为安装。现在按 g 以显示软件包操作的摘要。再次按 g ，软件包将被下载并安装。完成后，按 Enter 返回菜单。

### Remove Packages 删除包 

To remove a package, locate it in the “Installed Packages” category by using the keyboard arrow keys and the Enter key.
要删除一个软件包，请使用键盘箭头键和 Enter 键在“已安装的软件包”类别中找到它。

Highlight the package you want to remove, then press the - key. The package entry should turn **pink**, indicating it has been marked for removal. Now press g to be presented with a summary of package actions. Press g again, and the package will be removed. When finished, press Enter to return to the menu.
突出显示要删除的软件包，然后按 - 键。软件包条目应变为粉红色，表示已标记为删除。现在按 g 以显示软件包操作的摘要。再次按 g ，软件包将被删除。完成后，按 Enter 返回菜单。

### Updating the package index 更新包索引 

To update the package index, press the u key.
要更新软件包索引，请按 u 键。

### Upgrade packages 升级包 

To upgrade packages, first update the package index as detailed above, and then press the U key to mark all packages with available updates. Now press g, which will present you with a summary of package actions. Press g again to begin the download and installation. When finished, press Enter to return to the menu.
要升级软件包，请首先按照上面的详细说明更新软件包索引，然后按 U 键标记所有具有可用更新的软件包。现在按 g ，这将为您提供软件包操作的摘要。再次按 g 以开始下载和安装。完成后，按 Enter 返回菜单。

The first column of information displayed in the package list (in the top  pane) lists the current state of the package (when viewing packages). It uses the following key to describe the package state:
软件包列表（在顶部窗格中）中显示的第一列信息列出了软件包的当前状态（查看软件包时）。它使用以下键来描述包状态： 

- **i** : Installed package i：已安装的软件包
- **c** : Package not installed, but package configuration remains on the system
  c：未安装软件包，但软件包配置仍保留在系统上
- **p** : Purged from system
  p：从系统中清除
- **v** : Virtual package v：虚拟包
- **B** : Broken package B：包装破损
- **u** : Unpacked files, but package not yet configured
  u：解压缩的文件，但尚未配置包
- **C** : Half-configured - configuration failed and requires fix
  C：半配置—配置失败，需要修复
- **H** : Half-installed - removal failed and requires a fix
  H：半安装-移除失败，需要修复

To exit Aptitude, simply press the q key and confirm you want to exit. Many other functions are available from the Aptitude menu by pressing the F10 key.
要退出Aptitude，只需按下 q 键并确认您要退出。按下 F10 键，可从Aptitude（能力）菜单中获得许多其他功能。

### Command-line Aptitude 命令行能力 

You can also use Aptitude as a command-line tool, similar to `apt`. To install the `nmap` package with all necessary dependencies (as in the `apt` example), you would use the following command:
您也可以使用Aptitude作为命令行工具，类似于 `apt` 。要安装带有所有必要依赖项的 `nmap` 包（如 `apt` 示例中所示），您可以使用以下命令：

```bash
sudo aptitude install nmap
```

To remove the same package, you would use the command:
要删除同一个包，您可以使用以下命令： 

```bash
sudo aptitude remove nmap
```

Consult the [Aptitude manpages](https://manpages.ubuntu.com/manpages/man8/aptitude-curses.8.html) for full details of Aptitude’s command-line options.
有关Aptitude命令行选项的完整详细信息，请参阅Aptitude手册页。

## dpkg

`dpkg` is a package manager for Debian-based systems. It can install, remove,  and build packages, but unlike other package management systems, it  cannot automatically download and install packages – or their  dependencies.
 `dpkg` 是一个基于Debian系统的包管理器。它可以安装、删除和构建软件包，但与其他软件包管理系统不同的是，它不能自动下载和安装软件包或它们的依赖项。

APT and Aptitude are newer, and layer additional features on top of `dpkg`. This section covers using `dpkg` to manage locally installed packages.
APT和Aptitude是较新的，并且在 `dpkg` 之上添加了额外的功能。本节介绍如何使用 `dpkg` 管理本地安装的软件包。

### List packages 列出软件包 

To list *all* packages in the system’s package database (both installed and uninstalled) run the following command from a terminal prompt:
要列出系统软件包数据库中的所有软件包（包括已安装的和已安装的），请在终端提示符下运行以下命令：

```bash
dpkg -l
```

Depending on the number of packages on your system, this can generate a large amount of output. Pipe the output through `grep` to see if a specific package is installed:
根据系统上的软件包数量，这可能会生成大量的输出。通过 `grep` 管道输出以查看是否安装了特定的软件包：

```bash
dpkg -l | grep apache2
```

Replace `apache2` with any package name, part of a package name, or a regular expression.
将 `apache2` 替换为任何包名、包名的一部分或正则表达式。

### List files 列表文件 

To list the files installed by a package, in this case the `ufw` package, enter:
要列出软件包（在本例中为 `ufw` 软件包）安装的文件，请输入：

```bash
dpkg -L ufw
```

If you are unsure which package installed a file, `dpkg -S` may be able to tell you. For example:
如果你不确定哪个软件包安装了一个文件， `dpkg -S` 可以告诉你。举例来说，请注意：

```bash
dpkg -S /etc/host.conf 
base-files: /etc/host.conf
```

The output shows that the `/etc/host.conf` belongs to the base-files package.
输出显示 `/etc/host.conf` 属于base-files包。

> **Note**: 注意事项：
>  Many files are automatically generated during the package install process, and even though they are on the filesystem, `dpkg -S` may not know which package they belong to.
>  许多文件是在软件包安装过程中自动生成的，即使它们在文件系统上， `dpkg -S` 也可能不知道它们属于哪个软件包。

### Installing a deb file 安装deb文件 

You can install a local `.deb` file by entering:
您可以通过输入以下命令安装本地 `.deb` 文件：

```bash
sudo dpkg -i zip_3.0-4_amd64.deb
```

Change `zip_3.0-4_amd64.deb` to the actual file name of the local `.deb` file you wish to install.
将 `zip_3.0-4_amd64.deb` 更改为您希望安装的本地 `.deb` 文件的实际文件名。

### Uninstalling packages 正在卸载软件包 

You can uninstall a package by running:
您可以通过运行以下命令卸载程序包： 

```bash
sudo dpkg -r zip
```

> **Caution**: 注意事项：
>  Uninstalling packages using `dpkg`, is **NOT** recommended in most cases. It is better to use a package manager that  handles dependencies to ensure that the system is left in a consistent  state. For example, using `dpkg -r zip` will remove the `zip` package, but any packages that depend on it will still be installed and may no longer function correctly as a result.
>  在大多数情况下，不建议使用 `dpkg` 卸载软件包。最好使用一个包管理器来处理依赖项，以确保系统保持一致的状态。例如，使用 `dpkg -r zip` 将删除 `zip` 包，但依赖于它的任何包仍然会被安装，并且可能不再正常运行。

For more `dpkg` options see the [`dpkg` manpage](https://manpages.ubuntu.com/manpages/en/man1/dpkg.1.html): `man dpkg`.
有关更多 `dpkg` 选项，请参见 `dpkg` 手册页： `man dpkg` 。

## APT configuration APT配置 

Configuration of the APT system repositories is stored in the `/etc/apt/sources.list` file and the `/etc/apt/sources.list.d` directory. An example of this file is referenced here, along with  information on adding or removing repository references from the file.
APT系统存储库的配置存储在 `/etc/apt/sources.list` 文件和 `/etc/apt/sources.list.d` 目录中。这里引用了此文件的一个示例，沿着了有关在文件中添加或删除存储库引用的信息。

You can edit the file to enable and disable repositories. For example, to  disable the requirement to insert the Ubuntu CD-ROM whenever package  operations occur, simply comment out the appropriate line for the  CD-ROM, which appears at the top of the file:
您可以编辑该文件以启用和禁用存储库。例如，要禁用每当包操作发生时插入Ubuntu CD-ROM的要求，只需注释掉出现在文件顶部的CD-ROM的相应行： 

```plaintext
# no more prompting for CD-ROM please
# deb cdrom:[DISTRO-APT-CD-NAME - Release i386 (20111013.1)]/ DISTRO-SHORT-CODENAME main restricted
```

### Extra repositories 额外的存储库 

In addition to the officially-supported package repositories available for Ubuntu, there are also community-maintained repositories which add  thousands more packages for potential installation. Two of the most  popular are the *universe* and *multiverse* repositories. These repositories are not officially supported by  Ubuntu, but because they are maintained by the community they generally  provide packages which are safe for use with your Ubuntu computer.
除了官方支持的Ubuntu软件包存储库外，还有社区维护的存储库，可以添加数千个软件包供潜在安装。其中两个最受欢迎的是宇宙和多元宇宙存储库。Ubuntu并不正式支持这些仓库，但是因为它们是由社区维护的，所以它们通常提供可以在Ubuntu计算机上安全使用的软件包。

For more information, see our guide on [using third-party repositories](https://ubuntu.com/server/docs/third-party-repository-usage).
有关更多信息，请参阅我们的使用第三方存储库指南。

> **Warning**: 警告：
>  Be advised that neither *universe* nor *multiverse* contain officially-supported packages. In particular, there may not be security updates for these packages.
>  请注意，universe和multiverse都不包含官方支持的软件包。特别是，这些软件包可能没有安全更新。
>
> Packages in the *multiverse* repository often have licensing issues that prevent them from being  distributed with a free operating system, and they may be illegal in  your locality.
> 多重宇宙仓库中的软件包通常存在许可问题，这使得它们无法与自由操作系统一起分发，并且它们在您所在的地方可能是非法的。

Many other package sources are available – sometimes even offering only one  package, as in the case of packages provided by the developer of a  single application. You should always be cautious when using  non-standard package sources/repos, however. Research the packages and  their origins carefully before performing any installation, as some  packages could render your system unstable or non-functional in some  respects.
许多其他的包源是可用的-有时甚至只提供一个包，就像单个应用程序的开发人员提供的包一样。但是，在使用非标准包源/仓库时，您应该始终保持谨慎。在执行任何安装之前，请仔细研究软件包及其来源，因为某些软件包可能会使您的系统在某些方面不稳定或无法正常工作。 

By default, the *universe* and *multiverse* repositories are enabled. If you would like to disable them, edit `/etc/apt/sources.list` and comment out the following lines:
默认情况下，universe和multiverse存储库是启用的。如果您想禁用它们，请编辑 `/etc/apt/sources.list` 并注释掉以下行：

```plaintext
deb http://archive.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME universe multiverse
deb-src http://archive.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME universe multiverse
    
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME universe
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME universe
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates universe
    
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME multiverse
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates multiverse
    
deb http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security universe
deb-src http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security universe
deb http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security multiverse
deb-src http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security multiverse
```

## Automatic updates 自动更新 

The `unattended-upgrades` package can be used to automatically update installed packages and can  be configured to update all packages or to only install security  updates. First, install the package by entering the following in a  terminal:
 `unattended-upgrades` 软件包可用于自动更新已安装的软件包，并可配置为更新所有软件包或仅安装安全更新。首先，通过在终端中输入以下内容来安装软件包：

```bash
sudo apt install unattended-upgrades
```

To configure `unattended-upgrades`, edit `/etc/apt/apt.conf.d/50unattended-upgrades` and adjust the following to fit your needs:
要配置 `unattended-upgrades` ，请编辑 `/etc/apt/apt.conf.d/50unattended-upgrades` 并调整以下内容以满足您的需求：

```plaintext
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
//      "${distro_id}:${distro_codename}-updates";
//      "${distro_id}:${distro_codename}-proposed";
//      "${distro_id}:${distro_codename}-backports";
};
```

Certain packages can also be excluded and therefore will not be automatically updated. To block a package, add it to the list:
某些软件包也可以被排除，因此不会自动更新。要阻止一个包，请将其添加到列表中： 

```plaintext
Unattended-Upgrade::Package-Blacklist {
//      "vim";
//      "libc6";
//      "libc6-dev";
//      "libc6-i686";
};
```

> **Note**: 注意事项：
>  The double “//” serve as comments, so whatever follows “//” will not be evaluated.
>  双“//”作为注释，因此“//”之后的任何内容都不会被计算。

To enable automatic updates, edit `/etc/apt/apt.conf.d/20auto-upgrades` and set the appropriate APT configuration options:
要启用自动更新，请编辑 `/etc/apt/apt.conf.d/20auto-upgrades` 并设置相应的APT配置选项：

```plaintext
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```

The above configuration updates the package list, then downloads and  installs available upgrades every day. These actions are triggered by  timer units at a set time but with a random delay:  `apt-daily.timer` and `apt-daily-upgrade.timer`. These timers activate the corresponding services that run the `/usr/lib/apt/apt.systemd.daily` script.
上述配置会更新软件包列表，然后每天下载并安装可用的升级。这些动作由定时器单元在设定的时间触发，但具有随机延迟： `apt-daily.timer` 和 `apt-daily-upgrade.timer` 。这些计时器激活运行 `/usr/lib/apt/apt.systemd.daily` 脚本的相应服务。

However, it may happen that if the server is off at the time the timer unit  elapses, the timer will be triggered immediately at the next startup. As a result, they will often run on system startup
然而，如果服务器在定时器单元过去时关闭，则定时器将在下一次启动时立即被触发。因此，它们通常会在系统启动时运行
 and thereby cause immediate activity and hold the apt-lock.
 从而引起立即活动并保持APT锁。

In many cases this is beneficial, but in some cases it might be  counter-productive; examples are administrators with many shut-down  machines or VM images that are only started for some quick action, which is delayed or even blocked by the unattended upgrades. To adapt this  behaviour, we can change/override the configuration of both APT’s timer  units [`apt-daily-upgrade.timer, apt-daily.timer`]. To do so, use `systemctl edit <timer_unit>` and override the *Persistent* attribute, for example with `Persistent=delay`:
在许多情况下，这是有益的，但在某些情况下，它可能会适得其反;例如，管理员有许多关闭的机器或虚拟机映像，这些映像只是为了一些快速操作而启动，这会被无人值守的升级延迟甚至阻止。为了适应这种行为，我们可以改变/覆盖两个APT定时器单元的配置[ `apt-daily-upgrade.timer, apt-daily.timer` ]。为此，使用 `systemctl edit <timer_unit>` 并覆盖Persistent属性，例如使用 `Persistent=delay` ：

```auto
[Timer]
Persistent=delay
```

The local download archive is cleaned every week. On servers upgraded to  newer versions of Ubuntu, depending on your responses, the file listed  above may not be there. In this case, creating a new file of the same  name should also work.
本地下载存档每周清理一次。在升级到较新版本Ubuntu的服务器上，根据您的回答，上面列出的文件可能不存在。在这种情况下，创建一个同名的新文件也应该起作用。 

> **Note**: 注意事项：
>  You can read more about `apt` *Periodic* configuration options in the `apt.conf(5)` manpage and in the `/usr/lib/apt/apt.systemd.daily` script header.
>  您可以在 `apt.conf(5)` 手册页和 `/usr/lib/apt/apt.systemd.daily` 脚本标题中阅读更多关于 `apt` 定期配置选项的信息。

The results of `unattended-upgrades` will be logged to `/var/log/unattended-upgrades`.
 `unattended-upgrades` 的结果将记录到 `/var/log/unattended-upgrades` 。

### Notifications 通知 

Configuring `Unattended-Upgrade::Mail` in `/etc/apt/apt.conf.d/50unattended-upgrades` will enable `unattended-upgrades` to email an administrator detailing any packages that need upgrading or have problems.
在 `/etc/apt/apt.conf.d/50unattended-upgrades` 中配置 `Unattended-Upgrade::Mail` 将使 `unattended-upgrades` 能够向管理员发送电子邮件，详细说明任何需要升级或有问题的软件包。

Another useful package is `apticron`. `apticron` will configure a cron job to email an administrator information about  any packages on the system that have updates available, as well as a  summary of changes in each package.
另一个有用的包是 `apticron` 。 `apticron` 将配置一个cron作业，通过电子邮件向管理员发送有关系统上任何可用更新的软件包的信息，以及每个软件包中更改的摘要。

To install the `apticron` package, enter the following command in a terminal:
要安装 `apticron` 软件包，请在终端中输入以下命令：

```bash
sudo apt install apticron
```

Once the package is installed, edit `/etc/apticron/apticron.conf`, to set the email address and other options:
安装软件包后，编辑 `/etc/apticron/apticron.conf` ，设置电子邮件地址和其他选项：

```plaintext
EMAIL="root@example.com"
```

## Further reading 进一步阅读 

Most of the material covered in this chapter is available in the respective man pages, many of which are available online.
本章中涉及的大部分材料都可以在各自的手册页中找到，其中许多都可以在线获得。 

- The [Installing Software](https://help.ubuntu.com/community/InstallingSoftware) Ubuntu wiki page has more information.
  安装软件Ubuntu wiki页面有更多信息。
- The [APT User’s Guide](https://www.debian.org/doc/user-manuals#apt-guide) contains useful information regarding APT usage.
  APT用户指南包含有关APT使用的有用信息。
- For more information about systemd timer units (and systemd in general), visit the [systemd man page](https://manpages.ubuntu.com/manpages/en/man1/systemd.1.html) and [systemd.timer man page](https://manpages.ubuntu.com/manpages/en/man5/systemd.timer.5.html).
  有关systemd计时器单元（以及systemd的一般信息）的详细信息，请访问systemd手册页和systemd.timer手册页。
- See the [Aptitude user’s manual](https://www.debian.org/doc/user-manuals#aptitude-guide) for more Aptitude options.
  查看Aptitude用户手册了解更多Aptitude选项。
- The [Adding Repositories HOWTO (Ubuntu Wiki)](https://help.ubuntu.com/community/Repositories/Ubuntu) page contains more details on adding repositories.
  添加存储库HOWTO（Ubuntu Wiki）页面包含有关添加存储库的更多详细信息。



Ubuntu features a comprehensive package management system for  installing, upgrading, configuring, and removing software. In addition  to providing access to an organized base of over 60,000 software  packages for your Ubuntu computer, the package management facilities  also feature dependency resolution capabilities and software update  checking.

Several tools are available for interacting with Ubuntu’s package  management system, from simple command-line utilities which may be  easily automated by system administrators, to a graphical interface  which is easy to use by those new to Ubuntu.

## Introduction

Ubuntu’s package management system is derived from the same system  used by the Debian GNU/Linux distribution. The package files contain all of the necessary files, meta-data, and instructions to implement a  particular functionality or software application on your Ubuntu  computer.

Debian package files typically have the extension `.deb`, and usually exist in *repositories* which are collections of packages found online or on physical media,  such as CD-ROM discs. Packages are normally in a pre-compiled binary  format; thus installation is quick and requires no compiling of  software.

Many packages use *dependencies*. Dependencies are additional  packages required by the principal package in order to function  properly. For example, the speech synthesis package `festival` depends upon the package `alsa-utils`, which is a package supplying the ALSA sound library tools needed for  audio playback. In order for festival to function, it and all of its  dependencies must be installed. The software management tools in Ubuntu  will do this automatically.

## Apt

The apt command is a powerful command-line tool, which works with Ubuntu’s *Advanced Packaging Tool* (APT) performing such functions as installation of new software  packages, upgrade of existing software packages, updating of the package list index, and even upgrading the entire Ubuntu system.

Some examples of popular uses for the apt utility:

- **Install a Package**: Installation of packages using  the apt tool is quite simple. For example, to install the nmap network  scanner, type the following:

  ```
  sudo apt install nmap
  ```

- **Remove a Package**: Removal of a package (or packages) is also straightforward. To remove the package installed in the  previous example, type the following:

  ```
  sudo apt remove nmap
  ```

  > **Tip**
  >
  > **Multiple Packages**: You may specify multiple packages to be installed or removed, separated by spaces.

  > **Notice**
  >
  > **Scripting**: While apt is a command-line tool, it is  intended to be used interactively, and not to be called from  non-interactive scripts. The `apt-get` command should be used in scripts (perhaps with the `--quiet` flag). For basic commands the syntax of the two tools is identical.

  Also, adding the `--purge` option to `apt remove` will remove the package configuration files as well. This may or may not be the desired effect, so use with caution.

- **Update the Package Index**: The APT package index is essentially a database of available packages from the repositories defined in the `/etc/apt/sources.list` file and in the `/etc/apt/sources.list.d` directory. To update the local package index with the latest changes made in the repositories, type the following:

  ```
  sudo apt update
  ```

- **Upgrade Packages**: Over time, updated versions of  packages currently installed on your computer may become available from  the package repositories (for example security updates). To upgrade your system, first, update your package index as outlined above, and then  type:

  ```
  sudo apt upgrade
  ```

  For information on upgrading to a new Ubuntu release see [Upgrading](https://ubuntu.com/server/docs/upgrade-introduction).

Actions of the apt command, such as installation and removal of packages, are logged in the `/var/log/dpkg.log` log file.

For further information about the use of APT, read the comprehensive [APT User’s Guide](https://www.debian.org/doc/user-manuals#apt-guide)  or type:

```
apt help
```

## Aptitude

Launching Aptitude with no command-line options will give you a menu-driven, text-based front-end to the *Advanced Packaging Tool* (APT) system. Many of the common package management functions, such as  installation, removal, and upgrade, can be performed in Aptitude with  single-key commands, which are typically lowercase letters.

Aptitude is best suited for use in a non-graphical terminal  environment to ensure proper functioning of the command keys. You may  start the menu-driven interface of Aptitude as a normal user by typing  the following command at a terminal prompt:

```
sudo aptitude
```

When Aptitude starts, you will see a menu bar at the top of the  screen and two panes below the menu bar. The top pane contains package  categories, such as *New Packages* and *Not Installed Packages*. The bottom pane contains information related to the packages and package categories.

Using Aptitude for package management is relatively straightforward,  and the user interface makes common tasks simple to perform. The  following are examples of common package management functions as  performed in Aptitude:

- **Install Packages**: To install a package, locate the package via the *Not Installed Packages* package category, by using the keyboard arrow keys and the ENTER key.  Highlight the desired package, then press the + key. The package entry  should turn *green*, indicating that it has been marked for  installation. Now press g to be presented with a summary of package  actions. Press g again, and downloading and installation of the package  will commence. When finished, press ENTER, to return to the menu.
- **Remove Packages**: To remove a package, locate the package via the *Installed Packages* package category, by using the keyboard arrow keys and the ENTER key.  Highlight the desired package you wish to remove, then press the - key.  The package entry should turn *pink*, indicating it has been  marked for removal. Now press g to be presented with a summary of  package actions. Press g again, and removal of the package will  commence. When finished, press ENTER, to return to the menu.
- **Update Package Index**: To update the package index, simply press the u key. Updating of the package index will commence.
- **Upgrade Packages**: To upgrade packages, perform the  update of the package index as detailed above, and then press the U key  to mark all packages with updates. Now press g whereby you’ll be  presented with a summary of package actions. Press g again, and the  download and installation will commence. When finished, press ENTER, to  return to the menu.

The first column of the information displayed in the package list in  the top pane, when actually viewing packages lists the current state of  the package, and uses the following key to describe the state of the  package:

- **i**: Installed package
- **c**: Package not installed, but package configuration remains on the system
- **p**: Purged from system
- **v**: Virtual package
- **B**: Broken package
- **u**: Unpacked files, but package not yet configured
- **C**: Half-configured - Configuration failed and requires fix
- **H**: Half-installed - Removal failed and requires a fix

To exit Aptitude, simply press the q key and confirm you wish to  exit. Many other functions are available from the Aptitude menu by  pressing the F10 key.

### Command Line Aptitude

You can also use Aptitude as a command-line tool, similar to apt. To  install the nmap package with all necessary dependencies, as in the apt  example, you would use the following command:

```
sudo aptitude install nmap
```

To remove the same package, you would use the command:

```
sudo aptitude remove nmap
```

Consult the man pages for more details of command-line options for Aptitude.

## dpkg

dpkg is a package manager for *Debian*-based systems. It can  install, remove, and build packages, but unlike other package management systems, it cannot automatically download and install packages or their dependencies. **Apt and Aptitude are newer, and layer additional features on top of dpkg.** This section covers using dpkg to manage locally installed packages:

- To list all packages in the system’s package database, including all  packages, installed and uninstalled, from a terminal prompt type:

  ```
  dpkg -l
  ```

- Depending on the number of packages on your system, this can generate a large amount of output. Pipe the output through grep to see if a  specific package is installed:

  ```
  dpkg -l | grep apache2
  ```

  Replace `apache2` with any package name, part of a package name, or a regular expression.

- To list the files installed by a package, in this case the ufw package, enter:

  ```
  dpkg -L ufw
  ```

- If you are not sure which package installed a file, `dpkg -S` may be able to tell you. For example:

  ```
  dpkg -S /etc/host.conf 
  base-files: /etc/host.conf
  ```

  The output shows that the `/etc/host.conf` belongs to the base-files package.

  > **Note**
  >
  > Many files are automatically generated during the package install process, and even though they are on the filesystem, `dpkg -S` may not know which package they belong to.

- You can install a local `.deb` file by entering:

  ```
  sudo dpkg -i zip_3.0-4_amd64.deb
  ```

  Change `zip_3.0-4_amd64.deb` to the actual file name of the local .deb file you wish to install.

- Uninstalling a package can be accomplished by:

  ```
  sudo dpkg -r zip
  ```

  > **Caution**
  >
  > Uninstalling packages using dpkg, in most cases, is *NOT*  recommended. It is better to use a package manager that handles  dependencies to ensure that the system is in a consistent state. For  example, using `dpkg -r zip` will remove the zip package, but any packages that depend on it will still be installed and may no longer function correctly.

For more dpkg options see the man page: `man dpkg`.

## APT Configuration

Configuration of the *Advanced Packaging Tool* (APT) system repositories is stored in the `/etc/apt/sources.list` file and the `/etc/apt/sources.list.d` directory. An example of this file is referenced here, along with  information on adding or removing repository references from the file.

You may edit the file to enable repositories or disable them. For  example, to disable the requirement of inserting the Ubuntu CD-ROM  whenever package operations occur, simply comment out the appropriate  line for the CD-ROM, which appears at the top of the file:

```
# no more prompting for CD-ROM please
# deb cdrom:[DISTRO-APT-CD-NAME - Release i386 (20111013.1)]/ DISTRO-SHORT-CODENAME main restricted
```

### Extra Repositories

In addition to the officially supported package repositories  available for Ubuntu, there exist additional community-maintained  repositories which add thousands more packages for potential  installation. Two of the most popular are the *universe* and *multiverse* repositories. These repositories are not officially supported by  Ubuntu, but because they are maintained by the community they generally  provide packages which are safe for use with your Ubuntu computer.

> **Note**
>
> Packages in the *multiverse* repository often have licensing  issues that prevent them from being distributed with a free operating  system, and they may be illegal in your locality.

> **Warning**
>
> Be advised that neither the *universe* or *multiverse* repositories contain officially supported packages. In particular, there may not be security updates for these packages.

Many other package sources are available, sometimes even offering  only one package, as in the case of package sources provided by the  developer of a single application. You should always be very careful and cautious when using non-standard package sources, however. Research the source and packages carefully before performing any installation, as  some package sources and their packages could render your system  unstable or non-functional in some respects.

By default, the *universe* and *multiverse* repositories are enabled but if you would like to disable them edit `/etc/apt/sources.list` and comment the following lines:

```
deb http://archive.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME universe multiverse
deb-src http://archive.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME universe multiverse

deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME universe
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME universe
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates universe

deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME multiverse
deb http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ DISTRO-SHORT-CODENAME-updates multiverse

deb http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security universe
deb-src http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security universe
deb http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security multiverse
deb-src http://security.ubuntu.com/ubuntu DISTRO-SHORT-CODENAME-security multiverse
```

## Automatic Updates

The unattended-upgrades package can be used to automatically install  updated packages and can be configured to update all packages or just  install security updates. First, install the package by entering the  following in a terminal:

```
sudo apt install unattended-upgrades
```

To configure unattended-upgrades, edit `/etc/apt/apt.conf.d/50unattended-upgrades` and adjust the following to fit your needs:

```
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
//      "${distro_id}:${distro_codename}-updates";
//      "${distro_id}:${distro_codename}-proposed";
//      "${distro_id}:${distro_codename}-backports";
};
```

Certain packages can also be *blacklisted* and therefore will not be automatically updated. To blacklist a package, add it to the list:

```
Unattended-Upgrade::Package-Blacklist {
//      "vim";
//      "libc6";
//      "libc6-dev";
//      "libc6-i686";
};
```

> **Note**
>
> The double *“//”* serve as comments, so whatever follows “//” will not be evaluated.

To enable automatic updates, edit `/etc/apt/apt.conf.d/20auto-upgrades` and set the appropriate apt configuration options:

```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```

The above configuration updates the package list, downloads, and  installs available upgrades every day. The local download archive is  cleaned every week. On servers upgraded to newer versions of Ubuntu,  depending on your responses, the file listed above may not be there. In  this case, creating a new file of this name should also work.

> **Note**
>
> You can read more about apt Periodic configuration options in the `apt.conf(5)` manpage and in the `/usr/lib/apt/apt.systemd.daily` script header.

The results of unattended-upgrades will be logged to `/var/log/unattended-upgrades`.

## Notifications

Configuring `Unattended-Upgrade::Mail` in `/etc/apt/apt.conf.d/50unattended-upgrades` will enable unattended-upgrades to email an administrator detailing any packages that need upgrading or have problems.

Another useful package is apticron. apticron will configure a cron  job to email an administrator information about any packages on the  system that have updates available, as well as a summary of changes in  each package.

To install the apticron package, in a terminal enter:

```
sudo apt install apticron
```

Once the package is installed edit `/etc/apticron/apticron.conf`, to set the email address and other options:

```
EMAIL="root@example.com"
```

## References

Most of the material covered in this chapter is available in man pages, many of which are available online.

- The [InstallingSoftware](https://help.ubuntu.com/community/InstallingSoftware) Ubuntu wiki page has more information.
- For more dpkg details see the [dpkg man page](http://manpages.ubuntu.com/cgi-bin/search.py?q=dpkg&cx=003883529982892832976%3A5zl6o8w6f0s&cof=FORID%3A9&ie=UTF-8&siteurl=manpages.ubuntu.com%2Fmanpages%2Fbionic%2F&ref=manpages.ubuntu.com%2Fcgi-bin%2Fsearch.py%3Fq%3Daptitude%26cx%3D003883529982892832976%3A5zl6o8w6f0s%26cof%3DFORID%3A9%26ie%3DUTF-8%26siteurl%3Dmanpages.ubuntu.com%2Fcgi-bin%2Fsearch.py%3Fcx%3D003883529982892832976%253A5zl6o8w6f0s%26cof%3DFORID%253A9%26ie%3DUTF-8%26titles%3D404%26lr%3Dlang_en%26q%3Daptitude-curses.8.html%3F_ga%3D2.120690824.1895992339.1585586740-477599657.1580128091%26ref%3Dmanpages.ubuntu.com%2Fmanpages%2F%26distro-short-codename%3B%2Fman8%2Faptitude-curses.8.html%3F_ga%3D2.120690824.1895992339.1585586740-477599657.1580128091%26ss%3D2049j799925j9&ss=368j49562j4).
- The [APT User’s Guide](https://www.debian.org/doc/user-manuals#apt-guide) and [apt man page](http://manpages.ubuntu.com/cgi-bin/search.py?q=apt&cx=003883529982892832976%3A5zl6o8w6f0s&cof=FORID%3A9&ie=UTF-8&siteurl=manpages.ubuntu.com%2Fmanpages%2Fbionic%2F&ref=manpages.ubuntu.com%2Fcgi-bin%2Fsearch.py%3Fq%3Daptitude%26cx%3D003883529982892832976%3A5zl6o8w6f0s%26cof%3DFORID%3A9%26ie%3DUTF-8%26siteurl%3Dmanpages.ubuntu.com%2Fcgi-bin%2Fsearch.py%3Fcx%3D003883529982892832976%253A5zl6o8w6f0s%26cof%3DFORID%253A9%26ie%3DUTF-8%26titles%3D404%26lr%3Dlang_en%26q%3Daptitude-curses.8.html%3F_ga%3D2.120690824.1895992339.1585586740-477599657.1580128091%26ref%3Dmanpages.ubuntu.com%2Fmanpages%2F%26distro-short-codename%3B%2Fman8%2Faptitude-curses.8.html%3F_ga%3D2.120690824.1895992339.1585586740-477599657.1580128091%26ss%3D2049j799925j9&ss=192j19080j3) contain useful information regarding apt usage.
- See the [aptitude user’s manual](https://www.debian.org/doc/user-manuals#aptitude-guide) for more aptitude options.
- The [Adding Repositories HOWTO (Ubuntu Wiki)](https://help.ubuntu.com/community/Repositories/Ubuntu) page contains more details on adding repositories.

# Reporting Bugs in Ubuntu Server

# 如何报告Ubuntu Server中的bug 

The Ubuntu project, including Ubuntu Server, [uses Launchpad](https://launchpad.net/) as its bug tracker. To file a bug, you will first need to [create a Launchpad account](https://help.launchpad.net/YourAccount/NewAccount).
Ubuntu项目，包括Ubuntu Server，使用Launchpad作为其bug跟踪器。要提交bug，您首先需要创建一个Launchpad帐户。

## Report bugs with apport-cli 使用apport-task报告错误 

The preferred way to report a bug is with the `apport-cli` command. This command collects information from the machine on which it is run and publishes it to the bug report on Launchpad.
报告bug的首选方法是使用 `apport-cli` 命令。此命令从运行它的计算机收集信息，并将其发布到Launchpad上的错误报告。

Getting this information to Launchpad can be a challenge if the system is not  running a desktop environment with a browser (a common scenario with  servers) or if it does not have Internet access. The steps to take in  these situations are described below.
如果系统没有运行带有浏览器的桌面环境（服务器的常见情况）或没有Internet访问，则将此信息发送到Launchpad可能是一个挑战。在这些情况下应采取的步骤如下所述。 

> **Note**: 注意事项：
>  The commands `apport-cli` and `ubuntu-bug` should give the same results on a command-line interface (CLI) server. The latter is actually a symlink to `apport-bug`, which is intelligent enough to know whether a desktop environment is in use, and will choose `apport-cli` if not. Since server systems tend to be CLI-only, `apport-cli` was chosen from the outset in this guide.
>  在命令行界面（CLI）服务器上，命令 `apport-cli` 和 `ubuntu-bug` 应提供给予相同的结果。后者实际上是到 `apport-bug` 的符号链接，它足够智能，可以知道桌面环境是否在使用中，如果没有，它将选择 `apport-cli` 。由于服务器系统倾向于只支持CLI，因此本指南从一开始就选择了 `apport-cli` 。

Bug reports in Ubuntu need to be filed against a specific software package, so the name of the package (source package or program name/path)  affected by the bug needs to be supplied to `apport-cli`:
Ubuntu中的错误报告需要针对特定的软件包进行归档，因此受错误影响的软件包名称（源软件包或程序名称/路径）需要提供给 `apport-cli` ：

```bash
apport-cli PACKAGENAME
```

Once `apport-cli` has finished gathering information you will be asked what to do with it. For instance, to report a bug against vim using `apport-cli vim` produces output like this:
一旦 `apport-cli` 收集完信息，你会被问到如何处理它。例如，使用 `apport-cli vim` 报告Vim的bug会产生这样的输出：

```plaintext
*** Collecting problem information
    
The collected information can be sent to the developers to improve the
application. This might take a few minutes.
...
    
*** Send problem report to the developers?
    
After the problem report has been sent, please fill out the form in the
automatically opened web browser.
   
What would you like to do? Your options are:
  S: Send report (2.8 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C):
```

The first three options are described below.
前三个备选方案介绍如下。 

### S: Send report S：发送报告 

Submits the collected information to Launchpad as part of the process of filing a new bug report. You will be given the opportunity to describe the bug in your own words.
将收集的信息提交到Launchpad，作为提交新错误报告过程的一部分。您将有机会用自己的话描述这个bug。 

```plaintext
*** Uploading problem information
    
The collected information is being sent to the bug tracking system.
This might take a few minutes.
94%
    
*** To continue, you must visit the following URL:
    
  https://bugs.launchpad.net/ubuntu/+source/vim/+filebug/09b2495a-e2ab-11e3-879b-68b5996a96c8?
    
You can launch a browser now, or copy this URL into a browser on another computer.
    
    
Choices:
  1: Launch a browser now
  C: Cancel
Please choose (1/C):  1
```

The browser that will be used when choosing ‘1’ will be the one known on the system as `www-browser` via the [Debian alternatives system](https://manpages.ubuntu.com/manpages/en/man1/update-alternatives.1.html). Examples of text-based browsers to install include links, elinks, lynx, and w3m. You can also manually point an existing browser at the given  URL.
选择“1”时使用的浏览器将是Debian替代系统中的 `www-browser` 浏览器。可以安装的基于文本的浏览器包括links、elinks、lynx和w3m。您也可以手动将现有浏览器指向给定的URL。

### V: View V：视图 

This displays the collected information on the screen for review. This can be a lot of information! Press Enter to scroll through the screens. Press q to quit and return to the choice menu.
这将在屏幕上显示收集的信息以供查看。这可能是很多信息！按 Enter 滚动屏幕。按 q 退出并返回选择菜单。

### K: Keep 基：保持 

This writes the collected information to disk. The resulting file can be  later used to file the bug report, typically after transferring it to  another Ubuntu system.
这会将收集的信息写入磁盘。生成的文件可以稍后用于提交错误报告，通常是在将其传输到另一个Ubuntu系统之后。 

```plaintext
What would you like to do? Your options are:
  S: Send report (2.8 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C): k
Problem report file: /tmp/apport.vim.1pg92p02.apport
```

To report the bug, get the file onto an Internet-enabled Ubuntu system and apply `apport-cli` to it. This will cause the menu to appear immediately (since the information is already collected). You should then press s to send:
要报告该错误，请将文件放到支持Internet的Ubuntu系统上，并对其应用 `apport-cli` 。这将导致菜单立即出现（因为信息已经收集）。然后，您应按 s 发送：

```bash
apport-cli apport.vim.1pg92p02.apport
```

To directly save a report to disk (without menus) you can run:
要直接将报告保存到磁盘（不带菜单），您可以运行： 

```bash
apport-cli vim --save apport.vim.test.apport
```

Report names should end in `.apport`.
报告名称应以 `.apport` 结尾。

> **Note**: 注意事项：
>  If this Internet-enabled system is non-Ubuntu/Debian, `apport-cli` is not available so the bug will need to be created manually. An `apport` report is also not to be included as an attachment to a bug either so it is completely useless in this scenario.
>  如果这个支持互联网的系统不是Ubuntu/Debian，那么 `apport-cli` 是不可用的，所以这个bug需要手动创建。 `apport` 报告也不能作为bug的附件，所以在这种情况下它完全没用。

## Reporting application crashes 报告应用程序崩溃 

The software package that provides the `apport-cli` utility, `apport`, can be configured to automatically capture the state of a crashed application. This is enabled by default in `/etc/default/apport`.
提供 `apport-cli` 实用程序 `apport` 的软件包可以配置为自动捕获崩溃应用程序的状态。这在 `/etc/default/apport` 中默认启用。

After an application crashes, if enabled, `apport` will store a crash report under `/var/crash`:
应用崩溃后，如果启用， `apport` 将在 `/var/crash` 下存储崩溃报告：

```plaintext
-rw-r----- 1 peter    whoopsie 150K Jul 24 16:17 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.crash
```

Use the `apport-cli` command with no arguments to process any pending crash reports. It will offer to report them one by one, as in the following example:
使用不带参数的 `apport-cli` 命令处理任何挂起的崩溃报告。它将提供逐个报告，如下例所示：

```bash
apport-cli
*** Send problem report to the developers?
    
After the problem report has been sent, please fill out the form in the
automatically opened web browser.
    
What would you like to do? Your options are:
  S: Send report (153.0 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C): s
```

If you send the report, as was done above, the prompt will be returned immediately and the `/var/crash` directory will then contain 2 extra files:
如果您发送报告，如上所述，提示将立即返回，然后 `/var/crash` 目录将包含2个额外的文件：

```plaintext
-rw-r----- 1 peter    whoopsie 150K Jul 24 16:17 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.crash
-rw-rw-r-- 1 peter    whoopsie    0 Jul 24 16:37 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.upload
-rw------- 1 whoopsie whoopsie    0 Jul 24 16:37 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.uploaded
```

Sending in a crash report like this will not immediately result in the creation of a new public bug. The report will be made private on Launchpad,  meaning that it will be visible to only a limited set of bug triagers.  These triagers will then scan the report for possible private data  before creating a public bug.
发送这样的崩溃报告不会立即导致创建新的公共bug。该报告将在Launchpad上被私有化，这意味着它将只对有限的一组bug triager可见。然后，这些triager将在创建公共bug之前扫描报告中可能的私有数据。 

## Further reading 进一步阅读 

- See the [Reporting Bugs](https://help.ubuntu.com/community/ReportingBugs) Ubuntu wiki page.
  请参阅报告错误Ubuntu wiki页面。
- Also, [the Apport page](https://wiki.ubuntu.com/Apport) has some useful information. Though some of it pertains to using a GUI.
  此外，外观页面有一些有用的信息。虽然其中一些涉及到使用GUI。

------

The Ubuntu Project, and thus Ubuntu Server, uses [Launchpad](https://launchpad.net/) as its bug tracker. In order to file a bug, you will need a Launchpad account. [Create one here](https://help.launchpad.net/YourAccount/NewAccount) if necessary.

## Reporting Bugs With apport-cli

The preferred way to report a bug is with the apport-cli command. It  must be invoked on the machine affected by the bug because it collects  information from the system on which it is being run and publishes it to the bug report on Launchpad. Getting that information to Launchpad can, therefore, be a challenge if the system is not running a desktop  environment in order to use a browser (common with servers) or if it  does not have Internet access. The steps to take in these situations are described below.

> **Note**
>
> The commands apport-cli and ubuntu-bug should give the same results  on a CLI server. The latter is actually a symlink to apport-bug which is intelligent enough to know whether a desktop environment is in use and  will choose apport-cli if not. Since server systems tend to be CLI-only  apport-cli was chosen from the outset in this guide.

Bug reports in Ubuntu need to be filed against a specific software  package, so the name of the package (source package or program  name/path) affected by the bug needs to be supplied to apport-cli:

```
apport-cli PACKAGENAME
```

Once apport-cli has finished gathering information you will be asked what to do with it. For instance, to report a bug in vim:

```
$ apport-cli vim

*** Collecting problem information

The collected information can be sent to the developers to improve the
application. This might take a few minutes.
...

*** Send problem report to the developers?

After the problem report has been sent, please fill out the form in the
automatically opened web browser.

What would you like to do? Your options are:
  S: Send report (2.8 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C):
```

The first three options are described below:

- **Send:** submits the collected information to Launchpad as part of the process of filing a new bug report. You will be given  the opportunity to describe the bug in your own words.

  ```auto
  *** Uploading problem information
  
  The collected information is being sent to the bug tracking system.
  This might take a few minutes.
  94%
  
  *** To continue, you must visit the following URL:
  
    https://bugs.launchpad.net/ubuntu/+source/vim/+filebug/09b2495a-e2ab-11e3-879b-68b5996a96c8?
  
  You can launch a browser now, or copy this URL into a browser on another computer.
  
  
  Choices:
    1: Launch a browser now
    C: Cancel
  Please choose (1/C):  1
  ```

  The browser that will be used when choosing ‘1’ will be the one known on the system as www-browser via the [Debian alternatives system](http://manpages.ubuntu.com/cgi-bin/search.py?q=update-alternatives&cx=003883529982892832976%3A5zl6o8w6f0s&cof=FORID%3A9&ie=UTF-8&siteurl=manpages.ubuntu.com%2Fcgi-bin%2Fsearch.py%3Fcx%3D003883529982892832976%3A5zl6o8w6f0s%26cof%3DFORID%3A9%26ie%3DUTF-8%26titles%3D404%26lr%3Dlang_en%26q%3Dupdate-alternatives.8.html%3F_ga%3D2.113375495.1895992339.1585586740-477599657.1580128091&ref=manpages.ubuntu.com%2Fmanpages%2Fen%2Fman8%2Fupdate-alternatives.8.html%3F_ga%3D2.113375495.1895992339.1585586740-477599657.1580128091&ss=2209j328867j18). Examples of text-based browsers to install include links, elinks, lynx, and w3m. You can also manually point an existing browser at the given  URL.

- **View:** displays the collected information on the  screen for review. This can be a lot of information. Press ‘Enter’ to  scroll by a screenful. Press ‘q’ to quit and return to the choice menu.

- **Keep:** writes the collected information to disk. The  resulting file can be later used to file the bug report, typically after transferring it to another Ubuntu system.

  ```
  What would you like to do? Your options are:
    S: Send report (2.8 KB)
    V: View report
    K: Keep report file for sending later or copying to somewhere else
    I: Cancel and ignore future crashes of this program version
    C: Cancel
  Please choose (S/V/K/I/C): k
  Problem report file: /tmp/apport.vim.1pg92p02.apport
  ```

  To report the bug, get the file onto an Internet-enabled Ubuntu  system and apply apport-cli to it. This will cause the menu to appear  immediately (the information is already collected). You should then  press ‘s’ to send:

  ```
  apport-cli apport.vim.1pg92p02.apport
  ```

  To directly save a report to disk (without menus) you can do:

  ```
  apport-cli vim --save apport.vim.test.apport
  ```

  Report names should end in *.apport*.

  > **Note**
  >
  > If this Internet-enabled system is non-Ubuntu/Debian, apport-cli is  not available so the bug will need to be created manually. An apport  report is also not to be included as an attachment to a bug either so it is completely useless in this scenario.

## Reporting Application Crashes

The software package that provides the apport-cli utility, apport,  can be configured to automatically capture the state of a crashed  application. This is enabled by default (in `/etc/default/apport`).

After an application crashes, if enabled, apport will store a crash report under `/var/crash`:

```
-rw-r----- 1 peter    whoopsie 150K Jul 24 16:17 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.crash
```

Use the apport-cli command without arguments to process any pending crash reports. It will offer to report them one by one.

```
apport-cli

*** Send problem report to the developers?

After the problem report has been sent, please fill out the form in the
automatically opened web browser.

What would you like to do? Your options are:
  S: Send report (153.0 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C): s
```

If you send the report, as was done above, the prompt will be returned immediately and the `/var/crash` directory will then contain 2 extra files:

```
-rw-r----- 1 peter    whoopsie 150K Jul 24 16:17 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.crash
-rw-rw-r-- 1 peter    whoopsie    0 Jul 24 16:37 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.upload
-rw------- 1 whoopsie whoopsie    0 Jul 24 16:37 _usr_lib_x86_64-linux-gnu_libmenu-cache2_libexec_menu-cached.1000.uploaded
```

Sending in a crash report like this will not immediately result in  the creation of a new public bug. The report will be made private on  Launchpad, meaning that it will be visible to only a limited set of bug  triagers. These triagers will then scan the report for possible private  data before creating a public bug.

## Resources

- See the [Reporting Bugs](https://help.ubuntu.com/community/ReportingBugs) Ubuntu wiki page.
- Also, the [Apport](https://wiki.ubuntu.com/Apport) page has some useful information. Though some of it pertains to using a GUI.

# Kernel Crash Dump

# Kernel crash dump 内核崩溃转储 

A ‘kernel crash dump’ refers to a portion of the contents of volatile  memory (RAM) that is copied to disk whenever the execution of the kernel is disrupted. The following events can cause a kernel disruption:
“内核崩溃转储”指的是每当内核执行中断时复制到磁盘的易失性存储器（RAM）的一部分内容。以下事件可能导致内核中断： 

- Kernel panic
- Non-maskable interrupts (NMI)
  不可屏蔽中断（NMI） 
- Machine check exceptions (MCE)
  机器检查异常（MCE） 
- Hardware failure 硬件故障 
- Manual intervention 人工干预 

For some of these events (kernel panic, NMI) the kernel will react automatically and trigger the crash dump mechanism through *kexec*. In other situations a manual intervention is required in order to  capture the memory. Whenever one of the above events occurs, it is  important to find out the root cause in order to prevent it from  happening again. The cause can be determined by inspecting the copied  memory contents.
对于其中的一些事件（内核恐慌，NMI），内核将自动做出反应，并通过kexec触发崩溃转储机制。在其他情况下，需要手动干预以捕获存储器。每当发生上述事件之一时，重要的是要找出根本原因，以防止再次发生。原因可以通过检查复制的内存内容来确定。

## Kernel crash dump mechanism 内核崩溃转储机制 

When a kernel panic occurs, the kernel relies on the *kexec* mechanism to quickly reboot a new instance of the kernel in a  pre-reserved section of memory that had been allocated when the system  booted (see below). This permits the existing memory area to remain  untouched in order to safely copy its contents to storage.
当发生内核死机时，内核依赖于kexec机制，在系统引导时分配的预先保留的内存部分中快速重新引导内核的新实例（参见下文）。这允许现有的内存区域保持不变，以便安全地将其内容复制到存储器。

## Installation 安装 

The kernel crash dump utility is installed with the following command:
使用以下命令安装内核崩溃转储实用程序： 

```bash
sudo apt install linux-crashdump
```

> **Note**: 注意事项：
>  Starting with 16.04, the kernel crash dump mechanism is enabled by default.
>  从16.04开始，内核崩溃转储机制默认启用。

During the installation, you will be prompted with the following dialogs.
在安装过程中，系统将提示您以下对话框。 

```plaintext
 |------------------------| Configuring kexec-tools |------------------------|
 |                                                                           |
 |                                                                           |
 | If you choose this option, a system reboot will trigger a restart into a  |
 | kernel loaded by kexec instead of going through the full system boot      |
 | loader process.                                                           |
 |                                                                           |
 | Should kexec-tools handle reboots (sysvinit only)?                        |
 |                                                                           |
 |                    <Yes>                       <No>                       |
 |                                                                           |
 |---------------------------------------------------------------------------|
```

Select ‘Yes’ to select `kexec-tools` for all reboots.
选择“是”，为所有重新启动选择 `kexec-tools` 。

```plaintext
 |------------------------| Configuring kdump-tools |------------------------|
 |                                                                           |
 |                                                                           |
 | If you choose this option, the kdump-tools mechanism will be enabled.  A  |
 | reboot is still required in order to enable the crashkernel kernel        |
 | parameter.                                                                |
 |                                                                           |
 | Should kdump-tools be enabled be default?                                 |
 |                                                                           |
 |                    <Yes>                       <No>                       |
 |                                                                           |
 |---------------------------------------------------------------------------|
```

‘Yes’ should be selected here as well, to enable `kdump-tools`.
这里也应该选择"是"，以启用 `kdump-tools` 。

If you ever need to manually enable the functionality, you can use the  `dpkg-reconfigure kexec-tools` and `dpkg-reconfigure kdump-tools` commands and answer ‘Yes’ to the questions. You can also edit `/etc/default/kexec` and set parameters directly:
如果您需要手动启用该功能，您可以使用 `dpkg-reconfigure kexec-tools` 和 `dpkg-reconfigure kdump-tools` 命令并对问题回答"是"。您也可以编辑 `/etc/default/kexec` 并直接设置参数：

```plaintext
# Load a kexec kernel (true/false)
LOAD_KEXEC=true
```

As well, edit `/etc/default/kdump-tools` to enable `kdump` by including the following line:
同样，编辑 `/etc/default/kdump-tools` 以启用 `kdump` ，方法是包含以下行：

```plaintext
USE_KDUMP=1
```

If a reboot has not been done since installation of the `linux-crashdump` package, a reboot will be required in order to activate the `crashkernel= boot` parameter. Upon reboot, `kdump-tools` will be enabled and active.
如果在安装了 `linux-crashdump` 软件包后没有重新启动，则需要重新启动以激活 `crashkernel= boot` 参数。重新启动后， `kdump-tools` 将启用并处于活动状态。

If you enable `kdump-tools` after a reboot, you will only need to issue the `kdump-config load` command to activate the `kdump` mechanism.
如果在重新启动后启用 `kdump-tools` ，则只需发出 `kdump-config load` 命令即可激活 `kdump` 机制。

You can view the current status of `kdump` via the command `kdump-config show`.  This will display something like this:
您可以通过命令 `kdump-config show` 查看 `kdump` 的当前状态。这将显示如下内容：

```plaintext
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 
   /var/lib/kdump/vmlinuz
kdump initrd: 
   /var/lib/kdump/initrd.img
current state:    ready to kdump
kexec command:
  /sbin/kexec -p --command-line="..." --initrd=...
```

This tells us that we will find core dumps in `/var/crash`.
这告诉我们，我们将在 `/var/crash` 中找到核心转储。

## Configuration 配置 

In addition to local dump, it is now possible to use the remote dump  functionality to send the kernel crash dump to a remote server, using  either the SSH or NFS protocols.
除了本地转储之外，现在还可以使用远程转储功能，通过SSH或NFS协议将内核崩溃转储发送到远程服务器。 

### Local kernel crash dumps 本地内核崩溃转储 

Local dumps are configured automatically and will remain in use unless a  remote protocol is chosen. Many configuration options exist and are  thoroughly documented in the `/etc/default/kdump-tools` file.
本地转储会自动配置，除非选择远程协议，否则将一直使用。存在许多配置选项，并在 `/etc/default/kdump-tools` 文件中详细记录。

### Remote kernel crash dumps using the SSH protocol 使用SSH协议远程内核崩溃转储 

To enable remote dumps using the SSH protocol, the `/etc/default/kdump-tools` must be modified in the following manner:
要使用SSH协议启用远程转储，必须按以下方式修改 `/etc/default/kdump-tools` ：

```plaintext
# ---------------------------------------------------------------------------
# Remote dump facilities:
# SSH - username and hostname of the remote server that will receive the dump
#       and dmesg files.
# SSH_KEY - Full path of the ssh private key to be used to login to the remote
#           server. use kdump-config propagate to send the public key to the
#           remote server
# HOSTTAG - Select if hostname of IP address will be used as a prefix to the
#           timestamped directory when sending files to the remote server.
#           'ip' is the default.
SSH="ubuntu@kdump-netcrash"
```

The only mandatory variable to define is SSH. It must contain the username and hostname of the remote server using the format `{username}@{remote server}`.
唯一需要定义的强制变量是SSH。它必须包含远程服务器的用户名和主机名，格式为 `{username}@{remote server}` 。

`SSH_KEY` may be used to provide an existing private key to be used. Otherwise, the `kdump-config propagate` command will create a new keypair. The `HOSTTAG` variable may be used to use the hostname of the system as a prefix to  the remote directory to be created instead of the IP address.
 `SSH_KEY` 可以用于提供要使用的现有私钥。否则， `kdump-config propagate` 命令将创建一个新的密钥对。 `HOSTTAG` 变量可用于使用系统的主机名作为要创建的远程目录的前缀，而不是IP地址。

The following example shows how `kdump-config propagate` is used to create and propagate a new keypair to the remote server:
以下示例显示如何使用 `kdump-config propagate` 创建新密钥对并将其传播到远程服务器：

```bash
sudo kdump-config propagate
```

Which produces an output like this:
它会产生这样的输出： 

```plaintext
Need to generate a new ssh key...
The authenticity of host 'kdump-netcrash (192.168.1.74)' can't be established.
ECDSA key fingerprint is SHA256:iMp+5Y28qhbd+tevFCWrEXykDd4dI3yN4OVlu3CBBQ4.
Are you sure you want to continue connecting (yes/no)? yes
ubuntu@kdump-netcrash's password: 
propagated ssh key /root/.ssh/kdump_id_rsa to server ubuntu@kdump-netcrash
```

The password of the account used on the remote server will be required in  order to successfully send the public key to the server.
为了成功地将公钥发送到服务器，需要在远程服务器上使用的帐户的密码。 

The `kdump-config show` command can be used to confirm that `kdump` is correctly configured to use the SSH protocol:
可以使用 `kdump-config show` 命令确认 `kdump` 已正确配置为使用SSH协议：

```bash
kdump-config show
```

Whose output appears like this:
其输出如下所示： 

```plaintext
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
   /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
SSH:              ubuntu@kdump-netcrash
SSH_KEY:          /root/.ssh/kdump_id_rsa
HOSTTAG:          ip
current state:    ready to kdump
```

### Remote kernel crash dumps using the NFS protocol 使用NFS协议的远程内核崩溃转储 

To enable remote dumps using the NFS protocol, the `/etc/default/kdump-tools` must be modified in the following manner:
要使用NFS协议启用远程转储，必须按以下方式修改 `/etc/default/kdump-tools` ：

```plaintext
# NFS -     Hostname and mount point of the NFS server configured to receive
#           the crash dump. The syntax must be {HOSTNAME}:{MOUNTPOINT} 
#           (e.g. remote:/var/crash)
#
NFS="kdump-netcrash:/var/crash"
```

As with the SSH protocol, the `HOSTTAG` variable can be used to replace the IP address by the hostname as the prefix of the remote directory.
与SSH协议一样，可以使用 `HOSTTAG` 变量将IP地址替换为主机名作为远程目录的前缀。

The `kdump-config show` command can be used to confirm that `kdump` is correctly configured to use the NFS protocol :
可以使用 `kdump-config show` 命令确认 `kdump` 已正确配置为使用NFS协议：

```bash
kdump-config show
```

Which produces an output like this:
它会产生这样的输出： 

```plaintext
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
   /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
NFS:              kdump-netcrash:/var/crash
HOSTTAG:          hostname
current state:    ready to kdump
```

## Verification 验证 

To confirm that the kernel dump mechanism is enabled, there are a few things to verify. First, confirm that the `crashkernel` boot parameter is present (note that the following line has been split into two to fit the format of this document):
要确认内核转储机制已启用，需要验证几件事。首先，确认存在 `crashkernel` 靴子参数（请注意，以下行已被分成两行，以适应本文档的格式）：

```bash
cat /proc/cmdline
    
BOOT_IMAGE=/vmlinuz-3.2.0-17-server root=/dev/mapper/PreciseS-root ro
     crashkernel=384M-2G:64M,2G-:128M
```

The `crashkernel` parameter has the following syntax:
 `crashkernel` 参数的语法如下：

```plaintext
crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end] 'start' is inclusive and 'end' is exclusive.
```

So for the `crashkernel` parameter found in `/proc/cmdline` we would have :
因此，对于在 `/proc/cmdline` 中找到的 `crashkernel` 参数，我们将有：

```bash
crashkernel=384M-2G:64M,2G-:128M
```

The above value means:
上述值表示： 

- if the RAM is smaller than 384M, then don’t reserve anything (this is the “rescue” case)
  如果RAM小于384M，则不保留任何内容（这是“救援”情况） 
- if the RAM size is between 386M and 2G (exclusive), then reserve 64M
  如果RAM大小在386M和2G（不含）之间，则保留64M 
- if the RAM size is larger than 2G, then reserve 128M
  如果RAM大小大于2G，则保留128M 

Second, verify that the kernel has reserved the requested memory area for the `kdump` kernel by running:
第二，运行以下命令，验证内核是否为 `kdump` 内核保留了请求的内存区域：

```bash
dmesg | grep -i crash
```

Which produces the following output in this case:
在本例中，它会生成以下输出： 

```bash
...
[    0.000000] Reserving 64MB of memory at 800MB for crashkernel (System RAM: 1023MB)
```

Finally, as seen previously, the `kdump-config show` command displays the current status of the `kdump-tools` configuration :
最后，如前所述， `kdump-config show` 命令显示 `kdump-tools` 配置的当前状态：

```bash
kdump-config show
```

Which produces: 它产生： 

```plaintext
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
      /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
current state:    ready to kdump

kexec command:
      /sbin/kexec -p --command-line="BOOT_IMAGE=/vmlinuz-4.4.0-10-generic root=/dev/mapper/VividS--vg-root ro debug break=init console=ttyS0,115200 irqpoll maxcpus=1 nousb systemd.unit=kdump-tools.service" --initrd=/var/lib/kdump/initrd.img /var/lib/kdump/vmlinuz
```

## Testing the crash dump mechanism 测试崩溃转储机制 

> **Warning**: 警告：
>  Testing the crash dump mechanism **will cause a system reboot**. In certain situations, this can cause data loss if the system is under  heavy load. If you want to test the mechanism, make sure that the system is idle or under very light load.
>  测试崩溃转储机制将导致系统重新启动。在某些情况下，如果系统处于重负载下，这可能会导致数据丢失。如果您想测试该机制，请确保系统处于空闲状态或处于非常轻的负载下。

Verify that the *SysRQ* mechanism is enabled by looking at the value of the `/proc/sys/kernel/sysrq` kernel parameter:
通过查看 `/proc/sys/kernel/sysrq` 内核参数的值，验证是否启用了SysRQ机制：

```bash
cat /proc/sys/kernel/sysrq
```

If a value of *0* is returned, the dump and then reboot feature is disabled. A value greater than *1* indicates that a sub-set of `sysrq` features is enabled. See `/etc/sysctl.d/10-magic-sysrq.conf` for a detailed description of the options and their default values. Enable dump then reboot testing with the following command:
如果返回值为0，则禁用转储然后重新引导功能。大于1的值表示启用了 `sysrq` 功能的子集。有关选项及其默认值的详细说明，请参见 `/etc/sysctl.d/10-magic-sysrq.conf` 。使用以下命令启用转储然后重新启动测试：

```bash
sudo sysctl -w kernel.sysrq=1
```

Once this is done, you must become root, as just using `sudo` will not be sufficient. As the *root* user, you will have to issue the command `echo c > /proc/sysrq-trigger`. If you are using a network connection, you will lose contact with the  system. This is why it is better to do the test while being connected to the system console. This has the advantage of making the kernel dump  process visible.
完成此操作后，您必须成为root用户，因为仅使用 `sudo` 是不够的。作为root用户，您必须发出命令 `echo c > /proc/sysrq-trigger` 。如果您使用网络连接，您将失去与系统的联系。这就是为什么最好在连接到系统控制台时进行测试。这样做的好处是使内核转储进程可见。

A typical test output should look like the following :
典型的测试输出应该如下所示： 

```plaintext
sudo -s
[sudo] password for ubuntu: 
# echo c > /proc/sysrq-trigger
[   31.659002] SysRq : Trigger a crash
[   31.659749] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   31.662668] IP: [<ffffffff8139f166>] sysrq_handle_crash+0x16/0x20
[   31.662668] PGD 3bfb9067 PUD 368a7067 PMD 0 
[   31.662668] Oops: 0002 [#1] SMP 
[   31.662668] CPU 1 
....
```

The rest of the output is truncated, but you should see the system  rebooting and somewhere in the log, you will see the following line :
输出的其余部分被截断，但您应该看到系统重新启动，并且在日志中的某个地方，您将看到以下行： 

```plaintext
Begin: Saving vmcore from kernel crash ...
```

Once completed, the system will reboot to its normal operational mode. You  will then find the kernel crash dump file, and related subdirectories,  in the `/var/crash` directory by running, e.g. `ls /var/crash `, which produces the following:
一旦完成，系统将重新启动到其正常操作模式。然后，您将在 `/var/crash` 目录中找到内核崩溃转储文件和相关的子目录，例如运行 `ls /var/crash ` ，这将产生以下内容：

```bash
201809240744  kexec_cmd  linux-image-4.15.0-34-generic-201809240744.crash
```

If the dump does not work due to an ‘out of memory’ (OOM) error, then try increasing the amount of reserved memory by editing `/etc/default/grub.d/kdump-tools.cfg`. For example, to reserve 512 megabytes:
如果转储由于“内存不足”（OOM）错误而不起作用，则尝试通过编辑 `/etc/default/grub.d/kdump-tools.cfg` 来增加保留内存的量。例如，要保留512 MB：

```plaintext
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=384M-:512M"
```

You can then run `sudo update-grub`, reboot afterwards, and then test again.
然后，您可以运行 `sudo update-grub` ，然后重新启动，然后再次测试。

## Resources 资源 

Kernel crash dump is a vast topic that requires good knowledge of the Linux  kernel. You can find more information on the topic here:
内核崩溃转储是一个庞大的主题，需要对Linux内核有很好的了解。您可以在此处找到有关该主题的更多信息： 

- [Kdump kernel documentation](http://www.kernel.org/doc/Documentation/kdump/kdump.txt).
   Kdump内核文档。
- [Analyzing Linux Kernel Crash](http://www.dedoimedo.com/computers/crash-analyze.html) (Based on Fedora, it still gives a good walkthrough of kernel dump analysis)
   分析Linux内核崩溃（基于Fedora，它仍然提供了一个很好的内核转储分析的演练）

------

## Introduction

A Kernel Crash Dump refers to a portion of the contents of volatile  memory (RAM) that is copied to disk whenever the execution of the kernel is disrupted. The following events can cause a kernel disruption :

- Kernel Panic
- Non Maskable Interrupts (NMI)
- Machine Check Exceptions (MCE)
- Hardware failure
- Manual intervention

For some of those events (panic, NMI) the kernel will react automatically and trigger the crash dump mechanism through *kexec*. In other situations a manual intervention is required in order to  capture the memory. Whenever one of the above events occurs, it is  important to find out the root cause in order to prevent it from  happening again. The cause can be determined by inspecting the copied  memory contents.

## Kernel Crash Dump Mechanism

When a kernel panic occurs, the kernel relies on the *kexec*  mechanism to quickly reboot a new instance of the kernel in a  pre-reserved section of memory that had been allocated when the system  booted (see below). This permits the existing memory area to remain  untouched in order to safely copy its contents to storage.

## Installation

The kernel crash dump utility is installed with the following command:

```
sudo apt install linux-crashdump
```

> **Note**
>
> Starting with 16.04, the kernel crash dump mechanism is enabled by  default. During the installation, you will be prompted with the  following dialogs.

```auto
 |------------------------| Configuring kexec-tools |------------------------|
 |                                                                           |
 |                                                                           |
 | If you choose this option, a system reboot will trigger a restart into a  |
 | kernel loaded by kexec instead of going through the full system boot      |
 | loader process.                                                           |
 |                                                                           |
 | Should kexec-tools handle reboots (sysvinit only)?                        |
 |                                                                           |
 |                    <Yes>                       <No>                       |
 |                                                                           |
 |---------------------------------------------------------------------------|
        
```

Select Yes to hook up `kexec-tools` for all reboots.

```auto
 |------------------------| Configuring kdump-tools |------------------------|
 |                                                                           |
 |                                                                           |
 | If you choose this option, the kdump-tools mechanism will be enabled.  A  |
 | reboot is still required in order to enable the crashkernel kernel        |
 | parameter.                                                                |
 |                                                                           |
 | Should kdump-tools be enabled be default?                                 |
 |                                                                           |
 |                    <Yes>                       <No>                       |
 |                                                                           |
 |---------------------------------------------------------------------------|
        
```

Yes should be selected here as well, to enable `kdump-tools`.

If you ever need to manually enable the functionality, you can use the  `dpkg-reconfigure kexec-tools` and `dpkg-reconfigure kdump-tools` commands and answer Yes to the questions. You can also edit `/etc/default/kexec` and set parameters directly:

```
# Load a kexec kernel (true/false)
LOAD_KEXEC=true
```

As well, edit `/etc/default/kdump-tools` to enable kdump by including the following line:

```
USE_KDUMP=1
```

If a reboot has not been done since installation of the `linux-crashdump` package, a reboot will be required in order to activate the `crashkernel= boot` parameter. Upon reboot, `kdump-tools` will be enabled and active.

If you enable `kdump-tools` after a reboot, you will only need to issue the `kdump-config load` command to activate the kdump mechanism.

You can view the current status of kdump via the command `kdump-config show`.  This will display something like this:

```
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 
   /var/lib/kdump/vmlinuz
kdump initrd: 
   /var/lib/kdump/initrd.img
current state:    ready to kdump
kexec command:
  /sbin/kexec -p --command-line="..." --initrd=...
```

This tells us that we will find core dumps in /var/crash.

## Configuration

In addition to local dump, it is now possible to use the remote dump  functionality to send the kernel crash dump to a remote server, using  either the *SSH* or *NFS* protocols.

### Local Kernel Crash Dumps

Local dumps are configured automatically and will remain in use  unless a remote protocol is chosen. Many configuration options exist and are thoroughly documented in the `/etc/default/kdump-tools` file.

### Remote Kernel Crash Dumps using the SSH protocol

To enable remote dumps using the *SSH* protocol, the `/etc/default/kdump-tools` must be modified in the following manner :

```auto
# ---------------------------------------------------------------------------
# Remote dump facilities:
# SSH - username and hostname of the remote server that will receive the dump
#       and dmesg files.
# SSH_KEY - Full path of the ssh private key to be used to login to the remote
#           server. use kdump-config propagate to send the public key to the
#           remote server
# HOSTTAG - Select if hostname of IP address will be used as a prefix to the
#           timestamped directory when sending files to the remote server.
#           'ip' is the default.
SSH="ubuntu@kdump-netcrash"
        
```

The only mandatory variable to define is SSH. It must contain the  username and hostname of the remote server using the format  {username}@{remote server}.

SSH_KEY may be used to provide an existing private key to be used. Otherwise, the `kdump-config propagate` command will create a new keypair. The HOSTTAG variable may be used to  use the hostname of the system as a prefix to the remote directory to be created instead of the IP address.

The following example shows how `kdump-config propagate` is used to create and propagate a new keypair to the remote server :

```auto
sudo kdump-config propagate
Need to generate a new ssh key...
The authenticity of host 'kdump-netcrash (192.168.1.74)' can't be established.
ECDSA key fingerprint is SHA256:iMp+5Y28qhbd+tevFCWrEXykDd4dI3yN4OVlu3CBBQ4.
Are you sure you want to continue connecting (yes/no)? yes
ubuntu@kdump-netcrash's password: 
propagated ssh key /root/.ssh/kdump_id_rsa to server ubuntu@kdump-netcrash
        
```

The password of the account used on the remote server will be  required in order to successfully send the public key to the server

The `kdump-config show` command can be used to confirm that kdump is correctly configured to use the SSH protocol :

```auto
kdump-config show
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
   /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
SSH:              ubuntu@kdump-netcrash
SSH_KEY:          /root/.ssh/kdump_id_rsa
HOSTTAG:          ip
current state:    ready to kdump
        
```

### Remote Kernel Crash Dumps using the NFS protocol

To enable remote dumps using the *NFS* protocol, the `/etc/default/kdump-tools` must be modified in the following manner :

```auto
# NFS -     Hostname and mount point of the NFS server configured to receive
#           the crash dump. The syntax must be {HOSTNAME}:{MOUNTPOINT} 
#           (e.g. remote:/var/crash)
#
NFS="kdump-netcrash:/var/crash"
          
```

As with the SSH protocol, the HOSTTAG variable can be used to replace the IP address by the hostname as the prefix of the remote directory.

The `kdump-config show` command can be used to confirm that kdump is correctly configured to use the NFS protocol :

```auto
kdump-config show
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
   /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
NFS:              kdump-netcrash:/var/crash
HOSTTAG:          hostname
current state:    ready to kdump
      
```

## Verification

To confirm that the kernel dump mechanism is enabled, there are a few things to verify. First, confirm that the *crashkernel* boot parameter is present (note: The following line has been split into two to fit the format of this document:

```
cat /proc/cmdline

BOOT_IMAGE=/vmlinuz-3.2.0-17-server root=/dev/mapper/PreciseS-root ro
 crashkernel=384M-2G:64M,2G-:128M
```

The *crashkernel* parameter has the following syntax:

```auto
crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end] 'start' is inclusive and 'end' is exclusive.
        
```

So for the crashkernel parameter found in `/proc/cmdline` we would have :

```
crashkernel=384M-2G:64M,2G-:128M
```

The above value means:

- if the RAM is smaller than 384M, then don’t reserve anything (this is the “rescue” case)
- if the RAM size is between 386M and 2G (exclusive), then reserve 64M
- if the RAM size is larger than 2G, then reserve 128M

Second, verify that the kernel has reserved the requested memory area for the kdump kernel by doing:

```
dmesg | grep -i crash

...
[    0.000000] Reserving 64MB of memory at 800MB for crashkernel (System RAM: 1023MB)
```

Finally, as seen previously, the `kdump-config show` command displays the current status of the kdump-tools configuration :

```auto
        kdump-config show
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 0x2c000000
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-4.4.0-10-generic
kdump initrd: 
      /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-4.4.0-10-generic
current state:    ready to kdump

kexec command:
      /sbin/kexec -p --command-line="BOOT_IMAGE=/vmlinuz-4.4.0-10-generic root=/dev/mapper/VividS--vg-root ro debug break=init console=ttyS0,115200 irqpoll maxcpus=1 nousb systemd.unit=kdump-tools.service" --initrd=/var/lib/kdump/initrd.img /var/lib/kdump/vmlinuz
      
```

## Testing the Crash Dump Mechanism

> **Warning**
>
> Testing the Crash Dump Mechanism will cause *a system reboot.* In certain situations, this can cause data loss if the system is under  heavy load. If you want to test the mechanism, make sure that the system is idle or under very light load.

Verify that the *SysRQ* mechanism is enabled by looking at the value of the `/proc/sys/kernel/sysrq` kernel parameter :

```
cat /proc/sys/kernel/sysrq
```

If a value of *0* is returned the dump and then reboot feature is disabled. A value greater than *1* indicates that a sub-set of sysrq features is enabled. See `/etc/sysctl.d/10-magic-sysrq.conf` for a detailed description of the options and the default value. Enable dump then reboot testing with the following command :

```
sudo sysctl -w kernel.sysrq=1
```

Once this is done, you must become root, as just using `sudo` will not be sufficient. As the *root* user, you will have to issue the command `echo c > /proc/sysrq-trigger`. If you are using a network connection, you will lose contact with the  system. This is why it is better to do the test while being connected to the system console. This has the advantage of making the kernel dump  process visible.

A typical test output should look like the following :

```
sudo -s
[sudo] password for ubuntu: 
# echo c > /proc/sysrq-trigger
[   31.659002] SysRq : Trigger a crash
[   31.659749] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   31.662668] IP: [<ffffffff8139f166>] sysrq_handle_crash+0x16/0x20
[   31.662668] PGD 3bfb9067 PUD 368a7067 PMD 0 
[   31.662668] Oops: 0002 [#1] SMP 
[   31.662668] CPU 1 
....
```

The rest of the output is truncated, but you should see the system  rebooting and somewhere in the log, you will see the following line :

```
Begin: Saving vmcore from kernel crash ...
```

Once completed, the system will reboot to its normal operational  mode. You will then find the Kernel Crash Dump file, and related  subdirectories, in the `/var/crash` directory :

```
ls /var/crash
201809240744  kexec_cmd  linux-image-4.15.0-34-generic-201809240744.crash
```

If the dump does not work due to OOM (Out Of Memory) error, then try increasing the amount of reserved memory by editing `/etc/default/grub.d/kdump-tools.cfg`. For example, to reserve 512 megabytes :

```
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=384M-:512M"
```

run `sudo update-grub` and then reboot afterwards, and then test again.

## Resources

Kernel Crash Dump is a vast topic that requires good knowledge of the linux kernel. You can find more information on the topic here :

- [Kdump kernel documentation](http://www.kernel.org/doc/Documentation/kdump/kdump.txt).
- [The crash tool](http://people.redhat.com/~anderson/)
- [Analyzing Linux Kernel Crash](http://www.dedoimedo.com/computers/crash-analyze.html) (Based on Fedora, it still gives a good walkthrough of kernel dump analysis)

# Upgrading

We recommend running a Long Term Support (LTS) release as it provides 5  years of standard support and security updates, whereas interim releases are only supported for nine months.
我们建议运行长期支持（LTS）版本，因为它提供5年的标准支持和安全更新，而临时版本仅支持9个月。 

After the initial standard support period ends for an LTS release, an extended maintenance period is available via an [Ubuntu Pro subscription](http://ubuntu.com/pro), which provides coverage for an additional five years and is available  for free on up to five machines. Find out more about the [release lifecycle and support period](https://ubuntu.com/about/release-cycle) for your release.
在LTS版本的初始标准支持期结束后，可以通过Ubuntu Pro订阅获得延长的维护期，该订阅提供额外五年的覆盖范围，最多可在五台机器上免费使用。了解有关您的版本的版本生命周期和支持期的更多信息。

## Upgrade paths 升级路径 

Ubuntu supports the ability to upgrade from one LTS to the next in sequential  order. For example, a user on Ubuntu 16.04 LTS can upgrade to Ubuntu  18.04 LTS, but cannot jump directly to Ubuntu 20.04 LTS. To do this, the user would need to upgrade twice: once to Ubuntu 18.04 LTS, and then  upgrade again to Ubuntu 20.04 LTS.
Ubuntu支持按顺序从一个LTS升级到下一个LTS的能力。例如，Ubuntu 16.04 LTS上的用户可以升级到Ubuntu 18.04 LTS，但不能直接跳转到Ubuntu 20.04  LTS。要做到这一点，用户需要升级两次：一次升级到Ubuntu 18.04 LTS，然后再次升级到Ubuntu 20.04 LTS。 

## Pre-upgrade checklist 升级前检查表 

To ensure a successful upgrade, review the following items:
要确保成功升级，请查看以下项目： 

- Check the release notes (for the new release) for any known issues or  important changes. Release notes for each release are found on the [Ubuntu Wiki releases page](https://wiki.ubuntu.com/Releases).
  检查发行说明（新版本）以了解任何已知问题或重要更改。每个发行版的发行说明都可以在Ubuntu Wiki发行版页面上找到。

- Fully update the system. The upgrade process works best when the current  system has all the latest updates installed. You should confirm that  these commands complete successfully and that no further updates are  available. We also suggest rebooting the system after all the updates  are applied, to ensure the latest kernel is being run. To upgrade, run  the following commands:
  全面更新系统。当当前系统已安装所有最新更新时，升级过程最有效。您应该确认这些命令已成功完成，并且没有进一步的更新可用。我们还建议在应用所有更新后重新启动系统，以确保运行最新的内核。要升级，请运行以下命令： 

  ```bash
  sudo apt update
  sudo apt upgrade
  ```

- Check that there is enough free disk space for the upgrade. Upgrading a  system will include downloading new packages, which is likely to be on  the order of hundreds of new packages. Systems with additional software  installed may therefore require a few gigabytes of free disk space.
  检查是否有足够的可用磁盘空间进行升级。升级系统将包括下载新的软件包，这可能是数百个新软件包的数量级。因此，安装了附加软件的系统可能需要几千兆字节的可用磁盘空间。 

- The upgrade process takes time to complete. You should have dedicated time to participate in the upgrade process.
  升级过程需要时间才能完成。您应该有专门的时间参与升级过程。 

- Third-party software repositories and personal package archives (PPAs) are disabled during the upgrade. However, any software installed from these  repositories is not removed or downgraded. Software installed from these repositories is the most common cause of upgrade issues.
  在升级过程中将禁用第三方软件资料库和个人软件包归档（PPA）。但是，从这些存储库安装的任何软件都不会被删除或降级。从这些存储库安装的软件是升级问题的最常见原因。 

- Backup all your data. Although upgrades are normally safe, there is always a  chance that something could go wrong. It is extremely important that the data is safely copied to a backup location to allow restoration if  there are any problems during the upgrade process.
  备份所有数据。虽然升级通常是安全的，但总有可能出现问题。将数据安全地复制到备份位置非常重要，以便在升级过程中出现任何问题时进行恢复。 

## Upgrade the system 升级系统 

We recommend upgrading the system using the `do-release-upgrade` command on Server edition and cloud images. This command can handle  system configuration changes that are sometimes needed between releases. To begin the process, run the following command:
我们建议在Server Edition和云镜像上使用 `do-release-upgrade` 命令升级系统。此命令可以处理在两个版本之间有时需要的系统配置更改。要开始此过程，请运行以下命令：

```bash
sudo do-release-upgrade
```

> **Note**: 注意事项：
>  Upgrading to a development release of Ubuntu is available using the `-d` flag. However, using the development release (or the `-d` flag) is **not recommended** for production environments.
>  升级到Ubuntu的开发版本可以使用 `-d` 标志。但是，不建议在生产环境中使用开发版本（或 `-d` 标志）。

Upgrades from one LTS release to the next one are only available after the first point release. For example, Ubuntu 18.04 LTS will only upgrade to  Ubuntu 20.04 LTS after the 20.04.1 point release. If users wish to  update before the point release (e.g., on a subset of machines to  evaluate the LTS upgrade) users can force the upgrade via the `-d` flag.
从一个LTS版本升级到下一个版本仅在第一个点版本之后可用。例如，Ubuntu 18.04 LTS仅在20.04.1版本发布后升级到Ubuntu 20.04 LTS。如果用户希望在点发布之前更新（例如，在机器子集上评估LTS升级），用户可以通过 `-d` 标志强制升级。

### Pre-upgrade summary 升级前摘要 

Before making any changes the command will first do some checks to verify the  system is ready to upgrade, and provide a summary of the upgrade before  proceeding. If you accept the changes, the process will begin to update  the system’s packages:
在进行任何更改之前，该命令将首先执行一些检查以验证系统是否已准备好升级，并在继续之前提供升级摘要。如果您接受更改，该过程将开始以更新系统的软件包： 

```plaintext
Do you want to start the upgrade?  


5 installed packages are no longer supported by Canonical. You can  
still get support from the community.  

4 packages are going to be removed. 117 new packages are going to be  
installed. 424 packages are going to be upgraded.  

You have to download a total of 262 M. This download will take about  
33 minutes with a 1Mbit DSL connection and about 10 hours with a 56k  
modem.  

Fetching and installing the upgrade can take several hours. Once the  
download has finished, the process cannot be canceled.  

Continue [yN]  Details [d]
```

### Configuration changes 配置更改 

During the upgrade process you may be presented with a message to make  decisions about package updates. These prompts occur when there are  existing configuration files (e.g. edited by the user) and the new  package configuration file are different. Below is an example prompt:
在升级过程中，您可能会收到一条消息，要求您做出有关软件包更新的决定。当存在现有的配置文件（例如，由用户编辑的）并且新的包配置文件不同时，会出现这些提示。下面是一个示例提示： 

```plaintext
Configuration file '/etc/ssh/ssh_config'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** ssh_config (Y/I/N/O/D/Z) [default=N] ?
```

You should look at the differences between the files and decide what to do. The default response is to keep the current version of the file. There  are situations where accepting the new version, like with `/boot/grub/menu.lst`, is required for the system to boot correctly with the new kernel.
您应该查看文件之间的差异并决定如何处理。默认响应是保留文件的当前版本。在某些情况下，需要接受新版本（如使用 `/boot/grub/menu.lst` ），系统才能使用新内核正确地靴子。

### Package removal 拆包 

After all packages are updated, you can choose to remove any obsolete, no-longer-needed packages:
更新所有软件包后，您可以选择删除任何过时的、不再需要的软件包： 

```plaintext
Remove obsolete packages?  


30 packages are going to be removed.  

Continue [yN]  Details [d]
```

### Reboot 重新启动 

Finally, when the upgrade is complete you are prompted to reboot the system. The system is not considered upgraded until this reboot occurs:
最后，升级完成后，系统会提示您重新启动系统。在重新启动之前，系统不会被视为已升级： 

```plaintext
System upgrade is complete.

Restart required  

To finish the upgrade, a restart is required.  
If you select 'y' the system will be restarted.  

Continue [yN]
```

## Further reading 进一步阅读 

- For a complete list of releases and current support status see the [Ubuntu Wiki Releases](https://wiki.ubuntu.com/Releases) page.
  有关版本和当前支持状态的完整列表，请参阅Ubuntu Wiki版本页面。

The following details how to upgrade an Ubuntu Server or Ubuntu cloud image to the next release.

## Upgrade paths

Ubuntu supports the ability to upgrade from one LTS to the next LTS  in sequential order. For example, a user on Ubuntu 16.04 LTS can upgrade to Ubuntu 18.04 LTS, but cannot jump directly to Ubuntu 20.04 LTS. To  do this, the user would need to upgrade twice: once to Ubuntu 18.04 LTS, and then upgrade again to Ubuntu 20.04 LTS.

It is recommended that users run an LTS release as it provides 5  years of standard support and security updates. After the initial  standard support, an extended support period is available via an [Ubuntu Advantage](http://ubuntu.com/advantage) subscription.

For a complete list of releases and current support status see the [Ubuntu Wiki Releases](https://wiki.ubuntu.com/Releases) page.

## Upgrade checklist

To ensure a successful upgrade, please review the following items:

- Check the release notes for the new release for any known issues or  important changes. Release notes for each release are found on the [Ubuntu Wiki Releases](https://wiki.ubuntu.com/Releases) page.

- Fully update the system. The upgrade process works best when the  current system has all the latest updates installed. Users should  confirm that these commands complete successfully and that no further  updates are available. It is also suggested that users reboot the system after all the updates are applied to verify a user is running the  latest kernel. To upgrade run the following commands:

  ```nohighlight
  sudo apt update
  sudo apt upgrade
  ```

- Users should check that there is sufficient free disk space for the  upgrade. Upgrading a system will at least download hundreds of new  packages. Systems with additional software installed may require a few  gigabytes of disk space.

- The upgrade process takes time to complete. Users should have dedicated time to participate in the upgrade process.

- Third-party software repositories and PPAs are disabled during the  upgrade. However, any software installed from these repositories is not  removed or downgraded. Software installed from these repositories is the single most common cause of upgrade issues.

- Backup any and all data. Upgrades are normally safe, however, there  is always the chance that something may go wrong. It is extremely  important that the data is safely copied to a backup location to allow  restoration if there are any problems or complications during the  upgrade process.

## Upgrade

It is recommended to upgrade the system using the `do-release-upgrade` command on server edition and cloud images. This command can handle  system configuration changes that are sometimes needed between releases.

### do-release-upgrade

To begin this process run the following command:

```nohighlight
sudo do-release-upgrade
```

Upgrading to a development release of Ubuntu is available using the `-d` flag. However, using the development release or this flag is not recommended for production environments.

Upgrades from one LTS to the next LTS release are only available  after the first point release. For example, Ubuntu 18.04 LTS will only  upgrade to Ubuntu 20.04 LTS after the 20.04.1 point release. If users  wish to update before the point release (e.g. on a subset of machines to evaluate the LTS upgrade) users can force the upgrade via the `-d` flag.

### Pre-upgrade summary

Before making any changes the command will first do some checks to  verify the system is ready to update. The user will get prompted with a  summary of the upgrade before proceeding. If the user accepts the  changes, the process will begin to update the system’s packages:

```nohighlight
Do you want to start the upgrade?  


5 installed packages are no longer supported by Canonical. You can  
still get support from the community.  

4 packages are going to be removed. 117 new packages are going to be  
installed. 424 packages are going to be upgraded.  

You have to download a total of 262 M. This download will take about  
33 minutes with a 1Mbit DSL connection and about 10 hours with a 56k  
modem.  

Fetching and installing the upgrade can take several hours. Once the  
download has finished, the process cannot be canceled.  

Continue [yN]  Details [d]
```

### Configuration changes

It is possible during the upgrade process the user gets presented  with a message to make decisions about package updates. These prompts  occur when there are existing configuration files edited by the user and the new package configuration file are different. Below is an example  prompt:

```nohighlight
Configuration file '/etc/ssh/ssh_config'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** ssh_config (Y/I/N/O/D/Z) [default=N] ?
```

Users should look at the differences between the files and decide  what to do. The default response is to keep the current version of the  file. There are situations where accepting the new version, like with `/boot/grub/menu.lst`, is required for the system to boot correctly with the new kernel.

### Package removal

After all packages are updated the user will again remove any obsolete, no longer needed, packages:

```nohighlight
Remove obsolete packages?  


30 packages are going to be removed.  

Continue [yN]  Details [d]
```

### Reboot

Finally, when the upgrade is complete the user is prompted to reboot  the system. The system is not considered upgraded until a reboot occurs:

```nohighlight
System upgrade is complete.

Restart required  

To finish the upgrade, a restart is required.  
If you select 'y' the system will be restarted.  

Continue [yN]
```

# Using the installer

This document explains how to use the installer in general terms. There is [another document](https://ubuntu.com/server/docs/install/step-by-step) that contains documentation for each screen of the installer.

## Getting the installer

You can download the server installer for amd64 from https://ubuntu.com/download/server and other architectures from http://cdimage.ubuntu.com/releases/20.04/release/.

Installer images are made (approximately) daily and are available from http://cdimage.ubuntu.com/ubuntu-server/focal/daily-live/current/. These are not tested as extensively as the images from release day, but they contain the latest packages and installer so fewer updates will be required during or after installation.

## Installer UI generalities

In general, the installer can be used with the up and down arrow and  space or enter keys and a little typing. Tab and shift-tab move the  focus down and up respectively. Home / End / Page Up / Page Down can be  used to navigate through long lists more quickly in the usual way.

## Running the installer over serial

By default, the installer runs on the first virtual terminal, tty1.  This is what is displayed on any connected monitor by default. Clearly  though, servers do not always have a monitor. Some out-of-band  management systems provide a remote virtual terminal, but some times it  is necessary to run the installer on the serial port. To do this, the  kernel command line needs to [have an appropriate console](https://www.kernel.org/doc/html/latest/admin-guide/serial-console.html) specified on it – a common value is `console=ttyS0` but this is not something that can be generically documented.

When running on serial, the installer starts in a basic mode that  does using only the ASCII character set and black and white colours. If  you are connecting from a terminal emulator such as gnome-terminal that  supports unicode and rich colours you can switch to “rich mode” which  uses unicode, colours and supports many languages.



## Connecting to the installer over SSH

If the only available terminal is very basic, an alternative is to  connect via SSH. If the network is up by the time the installer starts,  instructions are offered on the initial screen in basic mode. Otherwise, instructions are available from the help menu once networking is  configured.

In addition, connecting via SSH is assumed to be capable of  displaying all unicode characters, enabling more translations to be used than can be displayed on a virtual terminal.

## Help menu

The help menu is always in the top right of the screen. It contains  help, both general and for the currently displayed screen, and some  general actions.

## Switching to a shell prompt

You can switch to a shell at any time by selecting “Enter shell” from the help menu, or pressing Control-Z or F2.

If you are accessing the installer via tty1, you can also access a  shell by switching to a different virtual terminal (control-alt-arrow or control-alt-number keys move between virtual terminals).

## Global keys

There are some global keys you can press at any time:

| Key           | Action                                        |
| ------------- | --------------------------------------------- |
| ESC           | go back                                       |
| F1            | open help menu                                |
| Control-Z, F2 | switch to shell                               |
| Control-L, F3 | redraw screen                                 |
| Control-T, F4 | toggle rich mode (colour, unicode) on and off |

​						Last updated 10 months ago. [Help improve this document in the forum](https://discourse.ubuntu.com/t/using-the-server-installer/16689). 				

# Using the installer step by step

The installer is designed to be easy to use without constant reference to documentation.

## Language selection



[![welcome_c](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/92bda8a0ed1ed1ac3137015191ee81e69c38ff3d.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/92bda8a0ed1ed1ac3137015191ee81e69c38ff3d.png)



This screen selects the language for the installer and the default language for the installed system.

More languages can be displayed if you [connect via SSH](https://ubuntu.com/server/docs/install/general#connect-via-ssh).

## Refresh



[![refresh](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/924950b31519ac77263f87943c75db0dd70e6ba5.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/924950b31519ac77263f87943c75db0dd70e6ba5.png)



This screen is shown if there is an update for the installer  available. This allows you to get improvements and bug fixes made since  release.

If you choose to update, the new version will be downloaded and the  installer will restart at the same point of the installation.

## Keyboard



[![keyboard](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/d/d18d2a56923b5ced7b2484bd94e9e04ba0c6b0ae.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/d/d18d2a56923b5ced7b2484bd94e9e04ba0c6b0ae.png)



Choose the layout and variant of keyboard attached to the system, if  any. When running in a virtual terminal, it is possible to guess the  layout and variant by answering questions about the keyboard.

## Zdev (s390x only)

```auto
====================================================================
  Zdev setup                                                      
====================================================================
  ID                          ONLINE  NAMES                                  ^
                                                                             │
  generic-ccw                                                                │
  0.0.0009                                    >                              │
  0.0.000c                                    >                              │
  0.0.000d                                    >                              │
  0.0.000e                                    >                              │
                                                                             │
  dasd-eckd                                                                  │
  0.0.0190                                    >                              │
  0.0.0191                                    >                              │
  0.0.019d                                    >                              │
  0.0.019e                                    >┌────────────┐                 
  0.0.0200                                    >│< (close)   │                 
  0.0.0300                                    >│  Enable    │                 
  0.0.0400                                    >│  Disable   │                 
  0.0.0592                                    >└────────────┘                v
                                                                              
                                 [ Continue   ]                               
                                 [ Back       ]                               
```

This screen is only shown on s390x and allows z-specific configuration of devices.

The list of device can be long. Home / End / Page Up / Page Down can be used to navigate through the list more quickly.

## Network



[![network](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/28369a33c14efbbd4769a17e7235666b4c908d1a.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/28369a33c14efbbd4769a17e7235666b4c908d1a.png)



This screen allows the configuration of the network. Ubuntu Server  uses netplan to configure networking and the UI of the installer can  configure a subset of netplan’s capabilities. In particular it can  configure DHCP or static addressing, VLANs and bonds.

If networking is present (defined as “at least one interface has a  default route”) then the installer will install updates from the archive at the end of installation.

## Proxy



[![proxy](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/6/6c7f84e37cda91e797f62b61148e10d1aa93c056.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/6/6c7f84e37cda91e797f62b61148e10d1aa93c056.png)



The proxy configured on this screen is used for accessing the package repository and the snap store both in the installer environment and in  the installed system.

## Mirror



[![mirror](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/3/30b527e810914da07ab11c3448750868809f88ac.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/3/30b527e810914da07ab11c3448750868809f88ac.png)



The installer will attempt to use geoip to look up an appropriate  default package mirror for your location. If you want or need to use a  different mirror, enter its URL here.

## Storage



[![storage_config](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/7484e986d5be44cf83952ede99e2bb8aaf9ed9c7.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/7484e986d5be44cf83952ede99e2bb8aaf9ed9c7.png)



Storage configuration is a complicated topic and [has its own page for documentation](https://ubuntu.com/server/docs/install/storage).



[![storage_confirm](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/c/cc7abf276409bdb9cb0d653f700785c421afe332.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/c/cc7abf276409bdb9cb0d653f700785c421afe332.png)



Once the storage configuration is confirmed, the install begins in the background.

## Identity



[![identity](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/9e79b5ead9b27622c6eccb3e075bbafc8d6644dd.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/9e79b5ead9b27622c6eccb3e075bbafc8d6644dd.png)



The default user will be an administrator, able to use sudo (this is  why a password is needed, even if SSH public key access is enabled on  the next screen).

## SSH



[![ssh](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/f/fb7af722915a3fd55954df01e8ea418846055123.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/f/fb7af722915a3fd55954df01e8ea418846055123.png)



A default Ubuntu install has no open ports. It is very common to  administer servers via SSH so the installer allows it to be installed  with the click of a button.

You can import keys for the default user from Github or Launchpad.

If you import a key, then password authentication is disabled by default but it can be re-enabled again if you wish.

## Snaps



[![snaps](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/3/3bd814edad81fbdfd8a13d3c8b5e79eb2a55293c.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/3/3bd814edad81fbdfd8a13d3c8b5e79eb2a55293c.png)



If a network connection is enabled, a selection of snaps that are  useful in a server environment are presented and can be selected for  installation.

## Installation logs



[![install_progress](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2e65fa0e78235d4a3b9f0dc071577d5f5e4d938d.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2e65fa0e78235d4a3b9f0dc071577d5f5e4d938d.png)



The final screen of the installer shows the progress of the installer and allows viewing of the full log file. Once the install has completed and security updates installed, the installer waits for confirmation  before restarting.



[![install_done](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2e77da21332fcf631c1995271b58518a87b2dbd1.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2e77da21332fcf631c1995271b58518a87b2dbd1.png)



​						Last updated 10 months ago. [Help improve this document in the forum](https://discourse.ubuntu.com/t/using-the-server-installer-step-by-step/16690). 				

# Reporting problems with the installer

We of course hope that every install with the server installer  succeeds. But of course reality doesn’t always work that way and there  will be failures of various kinds. This section explains the most useful way to report them so that we can fix the bugs causing them, and we’ll  keep the topic up to date as the installer changes.

The first thing to do is to update your subiquity snap. Not only  because we fix issues that cause failures over time but also because  we’ve been working on features to make failure reporting easier.

A failure will result in a crash report being generated which bundles up all the information we need to fully diagnose a failure. These live  in /var/crash in the installer environment, and for Ubuntu 19.10 and  newer this is persisted to the install media by default (if there is  space).

When an error occurs you are presented with a dialog which allows you to upload the report to the error tracker and offers options for  continuing. Uploads to the error tracker are non-interactive and  anonymous, so they are useful for tracking which kinds of errors are  affecting most users, but they do not give us a way to ask you to help  diagnose the failure.

You can create a Launchpad bug report, which does let us establish  this kind of two way communication, based on the contents of a crash  report by using the standard `apport-cli` tool that is part  of Ubuntu. Copy the crash report to another system, run “apport-cli  /path/to/report.crash” and follow the prompts.

You can also run apport-cli in the installer environment by switching to a shell but apport won’t be able to open a browser to allow you to  complete the report so you’ll have to type the URL by hand on another  machine.

# Configuring storage in the server installer

## Guided options



[![storage_guided](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/744833c87593ff7edc192e2929e465f915f7c07b.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/744833c87593ff7edc192e2929e465f915f7c07b.png)



Selecting “Use an entire disk” on the Guided storage configuration  screen will install Ubuntu onto the selected disk, replacing any  partitions or data already there.

You can choose whether or not to set up LVM, and if you do whether or not to encrypt the volume with LUKS. If you encrypt the volume, you  need to choose a passphrase that will need to be entered each time the  system boots.

If you select “Custom storage layout” no configuration will be applied to the disks.

In either case, the installer moves onto the main storage customization screen.

## The main storage screen



[![storage_manual](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/76b44c11caa4a196d067f86cf7b71a656cafbb83.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/76b44c11caa4a196d067f86cf7b71a656cafbb83.png)



This screen presents a summary of the current storage configuration.  Each device or partition of a device corresponds to a selectable row,  and pressing enter or space while a device is selected opens a menu of  actions that apply to that device.

## Partitions

![add_partition_menu](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/5/5ea88227b380081d4897e896ab1f60273db126b2.png)

To add a partition to a device, select “Add GPT partition” for that device.



[![add_dialog](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2a625d95e41dc4e4b46a628bee78206bc2d2a9b4.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/2a625d95e41dc4e4b46a628bee78206bc2d2a9b4.png)



You can leave size blank to use all the remaining space on the device.

## RAID



[![add_raid](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/a/acc5cb0c5921c43bf6178cc83e46b85fe3328f65.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/a/acc5cb0c5921c43bf6178cc83e46b85fe3328f65.png)



[Linux software RAID](https://raid.wiki.kernel.org/index.php/Linux_Raid) (RAID stands for “Redundant Array of Inexpensive Disks”) can be used to combine several disks into a single device that (usually) is tolerant  to any one disk failure.

A software RAID device can be created out of entire disks or  unformatted partitions. Select the “Create software RAID (md)” button to open the creation dialog.

The server installer supports creating devices with RAID level 0, 1,  5, 6 or 10. It does not allow customizing other options such as metadata format or RAID10 layout at this time.  See the [linux RAID documentation](https://raid.wiki.kernel.org/index.php/Linux_Raid) for more.

A software RAID device can be formatted and mounted directly, or  partitioned into several partitions (or even be used as part of another  RAID device or LVM volume group).

## LVM



[![add_lvm](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/b/b532023338fe853154a6f95248dc0799569c1e0c.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/b/b532023338fe853154a6f95248dc0799569c1e0c.png)



LVM (the “Logical Volume Manager”) is a system of managing logical  volumes, or filesystems, that is much more advanced and flexible than  the traditional method of partitioning a disk into one or more segments  and formatting that partition with a filesystem. It can be used to  combine several disks into one larger pool of storage but it offers  advantages even in a single disk system, such as snapshots and easy  resizing of logical volumes.

As with RAID, a LVM volume group can be created out of entire disks  or unformatted partitions. Select the “Create volume group (LVM)” button to open the creation dialog.

Once a volume group has been created, it can be divided into named  logical volumes which can then be formatted and mounted. It generally  makes sense to leave some space in the volume group for storage of  snapshots and creation of more logical volumes as needed.

The server installer does not supported configuring any of the many,  many options LVM supports when creating volume groups and logical  volumes.

## Selecting boot devices

![add_boot_device](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/5/59512a3cd3efc07127163cd101b3bff36034f82a.png)

On all architectures other than s390x, the bootloader needs to be  installed to a disk in a way such that the system firmware can find it  on boot. By default, the first device to have a partition created on it  is selected as a boot device but this can be changed later.

On amd64 and arm64 systems, multiple disks can be selected as boot  devices, which means a system can be configured so that it will continue to boot after a failure of any one drive (assuming the root filesystem  is placed on a RAID). The bootloader will be installed to each of these  drives, and the operating system configured to install new versions of  grub to each drive as it is updated.

amd64 systems use grub as the bootloader. amd64 systems can boot in  either UEFI or legacy (sometimes called “BIOS”) mode (many systems can  be configured to boot in either mode) and the bootloader is located  completely differently in the two modes.

In legacy mode, the bootloader is read from the first “sector” of a  hard drive (exactly which hard drive is up to the system firmware, which can usually be configured in a vendor specific way). The installer will write grub to the start of all disks selected as a boot devices. As  Grub does not entirely fit in one sector, a small unformatted partition  is needed at the start of the disk, which will automatically be created  when a disk is selected as a boot device (a disk with an existing GPT  partition table can only be used as a boot device if it has this  partition).

In UEFI mode, the bootloader loaded from a “EFI System Partition”  (ESP), which is a partition with a particular type GUID. The installer  automatically creates an 512MiB ESP on a disk when it is selected as a  boot device and will install grub to there (a disk with an existing  partition table can only be used as a boot device if it has an ESP –  bootloaders for multiple operating systems can be installed into a  single ESP). UEFI defines a standard way to configure the way in which  the operating system is chosen on boot, and the installer uses this to  configure the system to boot the just-installed operating system. One of the ESPs must be mounted at /boot/efi.

Supported arm64 servers boot using UEFI, and are configured the same way as an UEFI-booting amd64 system.

ppc64el systems also load their bootloader (petitboot, a small linux  kernel) from a “PReP” partition with a special flag, so in most ways  they are similar to a UEFI system. The installer only supports one PReP  partition at this time.

## Limitations and workarounds

Currently the installer cannot *edit* partition tables. You  can use existing partitions or reformat a drive entirely but you cannot, for example, remove a large partition and replace it with two smaller  ones.

The installer allows the creation of LVM volume groups and logical  volumes and MD raid devices, but does not allow tweaking of the  parameters – for example, all logical volumes are linear and all MD raid devics use the default metadata format (1.2).

These limits can both be worked around in the same way: drop to a  shell and use the usual shell commands to edit the partition table or  create the LV or RAID with desired parameters, and then select these  partitions or devices as mount points in the installer. Any changes you  make while the installer is running but before altering the storage  configuration will reflected in the installer.

The installer cannot yet configure iSCSI mounts, ZFS at all, or btrfs subvolumes.



## Configuring DHCP/bootp and tftp

There are several implementations of the DHCP/bootp and tftp  protocols available. This document will briefly describe how to  configure dnsmasq to perform both of these roles.

1. Install dnsmasq with “sudo apt install dnsmasq”

2. Put something like this in /etc/dnsmasq.conf.d/pxe.conf:

   ```
   interface=<your interface>,lo
   bind-interfaces
   dhcp-range=<your interface>,192.168.0.100,192.168.0.200
   dhcp-boot=pxelinux.0
   dhcp-match=set:efi-x86_64,option:client-arch,7
   dhcp-boot=tag:efi-x86_64,bootx64.efi
   enable-tftp
   tftp-root=/srv/tftp
   ```

   (This assumes several things about your network; read `man dnsmasq` or the default `/etc/dnsmasq.conf` for lots more options).

3. restart dnsmasq with `sudo systemctl restart dnsmasq.service`.

## Serving the bootloaders and configuration.

**We need to make this section possible to write sanely**

Ideally this would be something like:

```
# apt install cd-boot-images-amd64
# ln -s /usr/share/cd-boot-images-amd64 /srv/tftp/boot-amd64
```

### Mode independent set up

1. Download the latest live server ISO for the release you want to install:

   ```
   # wget http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-amd64.iso
   ```

2. Mount it.

   ```
   # mount ubuntu-19.10-live-server-amd64.iso /mnt
   ```

3. Copy the kernel and initrd from it to where the dnsmasq serves tftp from:

   ```
    # cp /mnt/casper/{vmlinuz,initrd} /srv/tftp/
   ```

### Setting up the files for UEFI booting

1. Copy the signed shim binary into place:

   ```
   # apt download shim-signed
   # dpkg-deb --fsys-tarfile shim-signed*deb | tar x ./usr/lib/shim/shimx64.efi.signed -O > /srv/tftp/bootx64.efi
   ```

2. Copy the signed grub binary into place:

   ```
   # apt download grub-efi-amd64-signed
   # dpkg-deb --fsys-tarfile grub-efi-amd64-signed*deb | tar x ./usr/lib/grub/x86_64-efi-signed/grubnetx64.efi.signed -O > /srv/tftp/grubx64.efi
   ```

3. Grub also needs a font to be available over tftp:

   ```
   # apt download grub-common
   #  dpkg-deb --fsys-tarfile grub-common*deb | tar x ./usr/share/grub/unicode.pf2 -O > /srv/tftp/unicode.pf2
   ```

4. Create /srv/tftp/grub/grub.cfg that contains:

   ```
   set default="0"
   set timeout=-1
   
   if loadfont unicode ; then
     set gfxmode=auto
     set locale_dir=$prefix/locale
     set lang=en_US
   fi
   terminal_output gfxterm
   
   set menu_color_normal=white/black
   set menu_color_highlight=black/light-gray
   if background_color 44,0,30; then
     clear
   fi
   
   function gfxmode {
           set gfxpayload="${1}"
           if [ "${1}" = "keep" ]; then
                   set vt_handoff=vt.handoff=7
           else
                   set vt_handoff=
           fi
   }
   
   set linux_gfx_mode=keep
   
   export linux_gfx_mode
   
   menuentry 'Ubuntu 20.04' {
           gfxmode $linux_gfx_mode
           linux /vmlinux $vt_handoff quiet splash
           initrd /initrd
   }
   ```

### Setting up the files for legacy boot

1. Download pxelinux.0 and put it into place:

   ```
   # wget http://archive.ubuntu.com/ubuntu/dists/eoan/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/pxelinux.0
   # mkdir -p /srv/tftp
   # mv pxelinux.0 /srv/tftp/
   ```

2. Make sure to have installed package `syslinux-common` and then:

   ```
    # cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /srv/tftp/
   ```

3. Create `/srv/tftp/pxelinux.cfg/default` containing:

   ```
   DEFAULT install
   LABEL install
     KERNEL vmlinuz
     INITRD initrd
     APPEND root=/dev/ram0 ramdisk_size=1500000 ip=dhcp url=http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-amd64.iso
   ```

   As you can see, this downloads the ISO from Ubuntu’s servers. You may well want to host it somewhere on your infrastructure and change the  url to match.

This configuration is obviously very simple. PXELINUX has many, many options, and you can consult its documentation at https://wiki.syslinux.org/wiki/index.php?title=PXELINUX for more.

:

- Ubuntu live server image

  - For arm64 architecture, its image name has a *-arm64* suffix. For example, *ubuntu-20.04.1-live-server-arm64.iso*.
  - For amd64 architecture, its image name has a *-amd64* suffix. For example, *ubuntu-20.04.1-live-server-amd64.iso*.

- grub efi binary (and the corresponding 

  grub.cfg
  
  , which is a txt file)

  - For arm64 architecture, it is `grubnetaa64.efi.signed`.
  - For amd64 architecture, it is `grubnetx64.efi.signed`.
  
- `initrd` extracted from your target Ubuntu live server image (use `hwe-initrd` instread if you want to boot with HWE kernel)

- `vmlinuz` extracted from your target Ubuntu live server image (use `hwe-vmlinuz` instead if you want to boot with HWE kernel)

## Examples

In the following sections, we will take arm64 image as an example. This means the following files are used:

- Ubuntu 20.04.1 live server image *ubuntu-20.04.1-live-server-arm64.iso* from http://cdimage.ubuntu.com/ubuntu/releases/20.04.1/release/ubuntu-20.04.1-live-server-arm64.iso
- grub efi binary `grubnetaa64.efi.signed` from http://ports.ubuntu.com/ubuntu-ports/dists/focal/main/uefi/grub2-arm64/current/grubnetaa64.efi.signed
- `initrd` extracted from *ubuntu-20.04.1-live-server-arm64.iso*
- `vmlinuz` extracted from *ubuntu-20.04.1-live-server-arm64.iso*

Please replace the corresponding files when you want to work on amd64 image. For example, your files may be:

- Ubuntu 20.04.1 live server image *ubuntu-20.04.1-live-server-amd64.iso* from https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-live-server-amd64.iso
- grub efi binary `grubnetx64.efi.signed` from http://archive.ubuntu.com/ubuntu/dists/focal/main/uefi/grub2-amd64/current/grubnetx64.efi.signed
- `initrd` extracted from *ubuntu-20.04.1-live-server-amd64.iso*
- `vmlinuz` extracted from *ubuntu-20.04.1-live-server-amd64.iso*

## Download and Serve Grub EFI Binary

The grub binary helps us redirect the downloading path to the target files via `grub.cfg`. You may refer to [this discourse post](https://discourse.ubuntu.com/t/netbooting-the-live-server-installer/14510) to get more information about the PXE process and why we need this binary.

```auto
$ sudo wget http://ports.ubuntu.com/ubuntu-ports/dists/focal/main/uefi/grub2-arm64/current/grubnetaa64.efi.signed -O /var/lib/tftpboot/grubnetaa64.efi.signed
```

Please note you may need to change **the archive dists name** from `focal` to your target distribution name.

## Download and Serve More Files

Fetch the installer by downloading a Ubuntu arm server iso, e.g. [20.04.1 live server arm64 iso](http://cdimage.ubuntu.com/ubuntu/releases/20.04.1/release/ubuntu-20.04.1-live-server-arm64.iso). Please note the prefix *live* is significant. We will need the files available only in the live version.

Mount the iso and copy the target files we need to the TFTP folder

```auto
$ sudo mount ./ubuntu-20.04.1-live-server-arm64.iso /mnt
$ sudo mkdir /var/lib/tftpboot/grub /var/lib/tftpboot/casper
$ sudo cp /mnt/boot/grub/grub.cfg /var/lib/tftpboot/grub/
$ sudo cp /mnt/casper/initrd /var/lib/tftpboot/casper/
$ sudo cp /mnt/casper/vmlinuz /var/lib/tftpboot/casper/
```

So, the TFTP root folder should look like this now:

```auto
$ find /var/lib/tftpboot/
/var/lib/tftpboot/
/var/lib/tftpboot/grub
/var/lib/tftpboot/grub/grub.cfg
/var/lib/tftpboot/grubnetaa64.efi.signed
/var/lib/tftpboot/casper
/var/lib/tftpboot/casper/initrd
/var/lib/tftpboot/casper/vmlinuz
```

Finally, let’s customize the grub menu so we could install our target image by fetching it directly over the internet.

```auto
$ sudo chmod +w /var/lib/tftpboot/grub/grub.cfg
$ sudo vi /var/lib/tftpboot/grub/grub.cfg
```

Add an new entry

```auto
menuentry "Install Ubuntu Server (Focal 20.04.1) (Pull the iso from web)" {
        set gfxpayload=keep
        linux   /casper/vmlinuz url=http://cdimage.ubuntu.com/ubuntu/releases/20.04.1/release/ubuntu-20.04.1-live-server-arm64.iso only-ubiquity ip=dhcp ---
        initrd  /casper/initrd
}
```

*ip=dhcp* is for the dhcp management setup in the lab. *url* is used to point to your target image download url. Remember to change them according to your scenario.

If everything goes well, you should get into the expected grub menu  of the ephemeral live prompt. Select the entry you just put in `grub.cfg`, which is `Install Ubuntu Server (Focal 20.04.1) (Pull the iso from web)` in our example. Waiting a bit for downloading the iso and then you will see the subiquity welcome message. Enjoy the installation!

# Appendix

## Always Make Sure of the Serving File Names

For example, please make sure the target file name for *linux* and *initrd* is correct. For example, the default initrd binary file name of 20.04.1 is *initrd*, and it is *initrd.lz* for 20.10. Always make sure you serve the right file names. This is a  frequent troubleshooting issue. Pay attention on this detail could save a lot of your time.

## Booting Screenshots

If your setup is correct, your `grub.cfg` should redirect the process to an ephemeral environment to download your target image assigned in the grub entry of `grub.cfg`. You will see a screen like this if you are able to access console or monitor device of your target machine:



[![uefi-ubuntu-live-server-01-ephemeral-env-download-image](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/f/fbdff13bcc3164b82de40e45956055f33d07d283.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/f/fbdff13bcc3164b82de40e45956055f33d07d283.png)



Wait a bit to complete downloading. If you see this subiquity welcome page, the installer is successfully launched via your UEFI PXE setup.  Configurations!!



[![uefi-ubuntu-live-server-02-subiquity-welcome-page](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/e/ef037190829e30e0f20eec7d346e249094a6e0b4.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/e/ef037190829e30e0f20eec7d346e249094a6e0b4.png)



​						Last updated 2 months ago. [Help improve this document in the forum](https://discourse.ubuntu.com/t/netbooting-the-live-server-installer-via-uefi-pxe-on-arm-aarch64-arm64-and-x86-64-amd64/19240). 				

**Netbooting the live server installer on IBM Power (ppc64el) with Petitboot**

- Open a terminal window on your workstation and make sure the ‘ipmitool’ package is installed.

- Verify if you can reach the BMC of the IBM Power system via ipmitool with a simple ipmitool call like:

  ```auto
  $ ipmitool -I lanplus -H Power9Box -U <user> -P <password> power status 
  Chassis Power is off
  ```

  or:

  ```auto
  $ ipmitool -I lanplus -H Power9Box -U <user> -P <password> fru print 47
    Product Name          : OpenPOWER Firmware
    Product Version       : open-power-SUPERMICRO-P9DSU-V2.12-20190404-prod
    Product Extra         : 	op-build-1b9269e
    Product Extra         : 	buildroot-2018.11.3-12-g222837a
    Product Extra         : 	skiboot-v6.0.19
    Product Extra         : 	hostboot-c00d44a-pb1307d7
    Product Extra         : 	occ-8fa3854
    Product Extra         : 	linux-4.19.30-openpower1-p22d1df8
    Product Extra         : 	petitboot-v1.7.5-p8f5fc86
  ```

  or:

  ```auto
  $ ipmitool -I lanplus -H Power9Box -U <user> -P <password> sol info
    Set in progress                 : set-complete
    Enabled                         : true
    Force Encryption                : false
    Force Authentication            : false
    Privilege Level                 : OPERATOR
    Character Accumulate Level (ms) : 0
    Character Send Threshold        : 0
    Retry Count                     : 0
    Retry Interval (ms)             : 0
    Volatile Bit Rate (kbps)        : 115.2
    Non-Volatile Bit Rate (kbps)    : 115.2
    Payload Channel                 : 1 (0x01)
    Payload Port                    : 623
  ```

- Open a second terminal and activate serial-over-LAN (sol), so that you have two terminal windows open:

  1. to control the BMC via IPMI
  2. for the serial-over-LAN console

- Activate serial-over-LAN:

  ```auto
  $ ipmitool -I lanplus -H Power9Box -U <user> -P <password> sol activate
  ...
  ```

- And power the system on in the ‘control terminal’ and watch the sol console:

  ```auto
  $ ipmitool -I lanplus -H Power9Box -U <user> -P <password> power on
  ...
  ```

  It takes some time to see the first lines in the sol console:

  ```auto
  [SOL Session operational.  Use ~? for help]
  --== Welcome to Hostboot  ==--
  
    2.77131|secure|SecureROM valid - enabling functionality
    3.15860|secure|Booting in secure mode.
    5.59684|Booting from SBE side 0 on master proc=00050000
    5.60502|ISTEP  6. 5 - host_init_fsi
    5.87228|ISTEP  6. 6 - host_set_ipl_parms
    6.11032|ISTEP  6. 7 - host_discover_targets
    6.67868|HWAS|PRESENT> DIMM[03]=A0A0000000000000
    6.67870|HWAS|PRESENT> Proc[05]=8800000000000000
    6.67871|HWAS|PRESENT> Core[07]=3FFF0C33FFC30000
    6.98988|ISTEP  6. 8 - host_update_master_tpm
    7.22711|SECURE|Security Access Bit> 0xC000000000000000
    7.22711|SECURE|Secure Mode Disable (via Jumper)> 0x0000000000000000
    7.22731|ISTEP  6. 9 - host_gard
    7.43353|HWAS|FUNCTIONAL> DIMM[03]=A0A0000000000000
    7.43354|HWAS|FUNCTIONAL> Proc[05]=8800000000000000
    7.43356|HWAS|FUNCTIONAL> Core[07]=3FFF0C33FFC30000
    7.44509|ISTEP  6.10 - host_revert_sbe_mcs_setup
  …
  ```

- After a moment the system reaches the Petitboot screen:

  ```auto
   Petitboot (v1.7.5-p8f5fc86)                                   9006-12P 1302NXA 
  ─────────────────────────────────────────────────
    [Network: enP2p1s0f0 / 0c:c4:7a:87:04:d8]
      Execute
      netboot enP2p1s0f0 (pxelinux.0)
    [CD/DVD: sr0 / 2019-10-17-13-35-12-00]
      Install Ubuntu Server
    [Disk: sda2 / 295f571b-b731-4ebb-b752-60aadc80fc1b]
      Ubuntu, with Linux 5.4.0-14-generic (recovery mode)
      Ubuntu, with Linux 5.4.0-14-generic
      Ubuntu
  
    System information
    System configuration
    System status log
    Language
    Rescan devices
    Retrieve config from URL
    Plugins (0)
  
      *Exit to shell                                        
   ─────────────────────────────────────────────────
   Enter=accept, e=edit, n=new, x=exit, l=language, g=log, h=help
  ```

  Select ‘*Exit to shell’

  **Notice:**
   Make sure you really watch the sol, since the petitboot screen (above)  has a time out (usually 10 or 30 seconds) and afterwards it  automatically proceeds and it tries to boot from the configured devices  (usually disk). This can be prevented by just navigating in petitboot.
   The petitboot shell is small Linux based OS:

  ```auto
  ...
  Exiting petitboot. Type 'exit' to return.
  You may run 'pb-sos' to gather diagnostic data
  ```

  **Notice:**
   In case one needs to gather system details and diagnostic data for IBM  support, this can be done here by running ‘pb-sos’ (see msg).

- Now download the ‘live-server’ ISO image (notice that  ‘focal-live-server-ppc64el.iso’ uses subiquity, ‘focal-server-s390x.iso’ uses d-i):
   Again for certain web locations a proxy needs to be used:

  ```auto
  / # export http_proxy=http://squid.proxy:3128   # in case a proxy is required
  / # 
  / # wget http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-ppc64el.iso
  Connecting to <proxy-ip>:3128 (<proxy-ip>:3128)
  focal-live-server-pp 100% |....................|  922M  0:00:00 ETA
  ```

- Next is to loop-back mount the ISO:

  ```auto
  / # mkdir iso
  / # mount -o loop focal-live-server-ppc64el.iso iso
  ```

  Or in case autodetect of type iso9660 is not supported or not working, explicitly specify the ‘iso9660’ type:

  ```auto
  / # mount -t iso9660 -o loop focal-live-server-ppc64el.iso iso
  ```

- Now load kernel and initrd from the loop-back mount, specify any needed kernel parameters and get it going:

  ```auto
  / # kexec -l ./iso/casper/vmlinux --initrd=./iso/casper/initrd.gz --append="ip=dhcp url=http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-ppc64el.iso http_proxy=http://squid.proxy:3128 --- quiet"
  / # kexec -e
  The system is going down NOW!
  Sent SIGTERM to all processes
  Sent SIGKILL to all processes
  ...
  ```

**Note** that in order to boot with and install the hwe kernel (if available), just substitute `vmlinux` with `vmlinux-hwe` in the first `kexec` line.

- The system now performs the initial boot of the installer:

  ```auto
  [ 1200.687004] kexec_core: Starting new kernel
  [ 1277.493883374,5] OPAL: Switch to big-endian OS
  [ 1280.465061219,5] OPAL: Switch to little-endian OS
  ln: /tmp/mountroot-fail-hooks.d//scripts/init-premount/lvm2: No such file or directory
  Internet Systems Consortium DHCP Client 4.4.1
  Copyright 2004-2018 Internet Systems Consortium.
  All rights reserved.
  For info, please visit https://www.isc.org/software/dhcp/
  Listening on LPF/enP2p1s0f3/0c:c4:7a:87:04:db
  Sending on   LPF/enP2p1s0f3/0c:c4:7a:87:04:db
  Listening on LPF/enP2p1s0f2/0c:c4:7a:87:04:da
  Sending on   LPF/enP2p1s0f2/0c:c4:7a:87:04:da
  Listening on LPF/enP2p1s0f1/0c:c4:7a:87:04:d9
  Sending on   LPF/enP2p1s0f1/0c:c4:7a:87:04:d9
  Listening on LPF/enP2p1s0f0/0c:c4:7a:87:04:d8
  Sending on   LPF/enP2p1s0f0/0c:c4:7a:87:04:d8
  Sending on   Socket/fallback
  DHCPDISCOVER on enP2p1s0f3 to 255.255.255.255 port 67 interval 3
  (xid=0x8d5704c)
  DHCPDISCOVER on enP2p1s0f2 to 255.255.255.255 port 67 interval 3
  (xid=0x94b25b28)
  DHCPDISCOVER on enP2p1s0f1 to 255.255.255.255 port 67 interval 3
  (xid=0x4edd0558)
  DHCPDISCOVER on enP2p1s0f0 to 255.255.255.255 port 67 interval 3
  (xid=0x61c90d28)
  DHCPOFFER of 10.245.71.102 from 10.245.71.3
  DHCPREQUEST for 10.245.71.102 on enP2p1s0f0 to 255.255.255.255 port 67
  (xid=0x280dc961)
  DHCPACK of 10.245.71.102 from 10.245.71.3 (xid=0x61c90d28)
  bound to 10.245.71.102 -- renewal in 236 seconds.
  Connecting to 91.189.89.11:3128 (91.189.89.11:3128)
  focal-live-server-pp   1% |                                | 14.0M  0:01:04 ETA
  focal-live-server-pp   4% |*                               | 45.1M  0:00:38 ETA
  focal-live-server-pp   8% |**                              | 76.7M  0:00:33 ETA
  focal-live-server-pp  11% |***                             |  105M  0:00:31 ETA
  focal-live-server-pp  14% |****                            |  133M  0:00:29 ETA
  focal-live-server-pp  17% |*****                           |  163M  0:00:27 ETA
  focal-live-server-pp  20% |******                          |  190M  0:00:26 ETA
  focal-live-server-pp  24% |*******                         |  222M  0:00:25 ETA
  focal-live-server-pp  27% |********                        |  253M  0:00:23 ETA
  focal-live-server-pp  30% |*********                       |  283M  0:00:22 ETA
  focal-live-server-pp  34% |**********                      |  315M  0:00:21 ETA
  focal-live-server-pp  37% |***********                     |  343M  0:00:20 ETA
  focal-live-server-pp  39% |************                    |  367M  0:00:19 ETA
  focal-live-server-pp  42% |*************                   |  392M  0:00:18 ETA
  focal-live-server-pp  45% |**************                  |  420M  0:00:17 ETA
  focal-live-server-pp  48% |***************                 |  451M  0:00:16 ETA
  focal-live-server-pp  52% |****************                |  482M  0:00:15 ETA
  focal-live-server-pp  55% |*****************               |  514M  0:00:14 ETA
  focal-live-server-pp  59% |******************              |  546M  0:00:13 ETA
  focal-live-server-pp  62% |********************            |  578M  0:00:11 ETA
  focal-live-server-pp  65% |*********************           |  607M  0:00:10 ETA
  focal-live-server-pp  69% |**********************          |  637M  0:00:09 ETA
  focal-live-server-pp  72% |***********************         |  669M  0:00:08 ETA
  focal-live-server-pp  75% |************************        |  700M  0:00:07 ETA
  focal-live-server-pp  79% |*************************       |  729M  0:00:06 ETA
  focal-live-server-pp  82% |**************************      |  758M  0:00:05 ETA
  focal-live-server-pp  85% |***************************     |  789M  0:00:04 ETA
  focal-live-server-pp  88% |****************************    |  817M  0:00:03 ETA
  focal-live-server-pp  91% |*****************************   |  842M  0:00:02 ETA
  focal-live-server-pp  93% |******************************  |  867M  0:00:01 ETA
  focal-live-server-pp  97% |******************************* |  897M  0:00:00 ETA
  focal-live-server-pp 100% |********************************|  922M  0:00:00 ETA
  mount: mounting /cow on /root/cow failed: No such file or directory
  Connecting to plymouth: Connection refused
  passwd: password expiry information changed.
  [   47.202736] /dev/loop3: Can't open blockdev
  [   52.672550] cloud-init[3759]: Cloud-init v. 20.1-10-g71af48df-0ubuntu1 running
   'init-local' at Wed, 18 Mar 2020 15:18:07 +0000. Up 51.87 seconds.
  ...
  ```

- And you will eventually reach the initial subiquity installer screen:

~~~auto
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
   Willkommen! Bienvenue! Welcome! Добро пожаловать! Welkom          
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
   Use UP, DOWN and ENTER keys to select your language.                        
 
                 [ English                                    ▸ ]              
                 [ Asturianu                                  ▸ ]              
                 [ Català                                     ▸ ]              
                 [ Hrvatski                                   ▸ ]              
                 [ Nederlands                                 ▸ ]              
                 [ Suomi                                      ▸ ]              
                 [ Français                                   ▸ ]              
                 [ Deutsch                                    ▸ ]              
                 [ Ελληνικά                                   ▸ ]              
                 [ Magyar                                     ▸ ]              
                 [ Latviešu                                   ▸ ]              
                 [ Norsk bokmål                               ▸ ]              
                 [ Polski                                     ▸ ]              
                 [ Русский                                    ▸ ]              
                 [ Español                                    ▸ ]              
                 [ Українська                                 ▸ ]              
   ```
* The rest is (subiquity-) installation as usual...
~~~

​	

# Automated Server Installs

# Introduction

The server installer for 20.04 supports a new mode of operation:  automated installation, autoinstallation for short. You might also know  this feature as unattended or handsoff or preseeded installation.

Autoinstallation lets you answer all those configuration questions ahead of time with an *autoinstall config* and lets the installation process run without any interaction.

# Differences from debian-installer preseeding

*preseeds* are the way to automate an installer based on debian-installer (aka d-i).

autoinstalls for the new server installer differ from preseeds in the following main ways:

- the format is completely different (cloud-init config, usually yaml, vs debconf-set-selections format)
- when the answer to a question is not present in a preseed, d-i    stops and asks the user for input. autoinstalls are not like this:   by  default, if there is any autoinstall config at all, the   installer  takes the default for any unanswered question (and fails if there is no  default).
  - You can designate particular sections in   the config as  “interactive”, which means the installer will still stop and ask about  those.

# Providing the autoinstall config

The autoinstall config is provided via cloud-init configuration,  which is almost endlessly flexible. In most scenarios the easiest way  will be to provide user-data via the [nocloud](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html) data source.

The autoinstall config should be provided under the `autoinstall` key in the config. For example:

```
#cloud-config
autoinstall:
  version: 1
  ...
```

# Running a truly automatic autoinstall

Even if a fully noninteractive autoinstall config is found, the  server installer will ask for confirmation before writing to the disks  unless `autoinstall` is present on the kernel command line.  This is to make it harder to accidentally create a USB stick that will  reformat a machine it is plugged into at boot. Many autoinstalls will be done via netboot, where the kernel command line is controlled by the  netboot config – just remember to put `autoinstall` in there!

# Quick start

So you just want to try it out? Well we have [the page for you](https://ubuntu.com/server/docs/install/autoinstall-quickstart).

# Creating an autoinstall config

When any system is installed using the server installer, an autoinstall file for repeating the install is created  at `/var/log/installer/autoinstall-user-data`.

# Translating a preseed file

If you have a preseed file already, the [autoinstall-generator](https://snapcraft.io/autoinstall-generator) snap can assist in translating that preseed data to an autoinstall file.  See this [discussion](https://discourse.ubuntu.com/t/autoinstall-generator-tool-to-help-with-creation-of-autoinstall-files-based-on-preseed/21334) for more details.

# The structure of an autoinstall config

The autoinstall config has [full documentation](https://ubuntu.com/server/docs/install/autoinstall-reference).

Technically speaking the config is not defined as a textual format,  but cloud-init config is usually provided as YAML so that is the syntax  the documentation uses.

A minimal config is:

```
version: 1
identity:
    hostname: hostname
    username: username
    password: $crypted_pass
```

Here is an example file that shows off most features:

```
version: 1
reporting:
    hook:
        type: webhook
        endpoint: http://example.com/endpoint/path
early-commands:
    - ping -c1 198.162.1.1
locale: en_US
keyboard:
    layout: en
    variant: uk
network:
    network:
        version: 2
        ethernets:
            enp0s25:
               dhcp4: yes
            enp3s0: {}
            enp4s0: {}
        bonds:
            bond0:
                dhcp4: yes
                interfaces:
                    - enp3s0
                    - enp4s0
                parameters:
                    mode: active-backup
                    primary: enp3s0
proxy: http://squid.internal:3128/
apt:
    primary:
        - arches: [default]
          uri: http://repo.internal/
    sources:
        my-ppa.list:
            source: "deb http://ppa.launchpad.net/curtin-dev/test-archive/ubuntu $RELEASE main"
            keyid: B59D 5F15 97A5 04B7 E230  6DCA 0620 BBCF 0368 3F77
storage:
    layout:
        name: lvm
identity:
    hostname: hostname
    username: username
    password: $crypted_pass
ssh:
    install-server: yes
    authorized-keys:
      - $key
    allow-pw: no
snaps:
    - name: go
      channel: 1.14/stable
      classic: true
debconf-selections: |
    bind9      bind9/run-resolvconf    boolean false
packages:
    - libreoffice
    - dns-server^
user-data:
    disable_root: false
late-commands:
    - sed -ie 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=30/' /target/etc/default/grub
error-commands:
    - tar c /var/log/installer | nc 192.168.0.1 1000
```

Many keys and values correspond straightforwardly to questions the  installer asks (e.g. keyboard selection). See the reference for details  of those that do not.

# Error handling

Progress through the installer is reported via the [`reporting`](https://ubuntu.com/server/docs/install/autoinstall-reference#reporting) system, including errors. In addition, when a fatal error occurs, the [`error-commands`](https://ubuntu.com/server/docs/install/autoinstall-reference#error-commands) are executed and the traceback printed to the console. The server then just waits.

# Possible future directions

We might want to extend the ‘match specs’ for disks to cover other ways of selecting disks.

# Autoinstall Quick Start

The intent of this page is to provide simple instructions to perform an autoinstall in a VM on your machine.

This page assumes you are on the amd64 architecture. There is a version for [s390x](https://ubuntu.com/server/docs/install/autoinstall-quickstart-s390x) too.

## Providing the autoinstall data over the network

This method is the one that generalizes most easily to doing an  entirely network-based install, where a machine netboots and then is  automatically installed.

### Download the ISO

Go to the [20.04 ISO download page](http://releases.ubuntu.com/20.04/) and download the latest Ubuntu 20.04 live-server ISO.

### Mount the ISO

```
sudo mount -r ~/Downloads/ubuntu-20.04-live-server-amd64.iso /mnt
```

### Write your autoinstall config

This means creating cloud-init config as follows:

```
mkdir -p ~/www
cd ~/www
cat > user-data << 'EOF'
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: ubuntu-server
    password: "$6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0"
    username: ubuntu
EOF
touch meta-data
```

The crypted password is just “ubuntu”.

### Serve the cloud-init config over http

Leave this running in one terminal window:

```
cd ~/www
python3 -m http.server 3003
```

### Create a target disk

```
truncate -s 10G image.img
```

### Run the install!

```
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio \
    -cdrom ~/Downloads/ubuntu-20.04-live-server-amd64.iso \
    -kernel /mnt/casper/vmlinuz \
    -initrd /mnt/casper/initrd \
    -append 'autoinstall ds=nocloud-net;s=http://_gateway:3003/'
```

This will boot, download the config from the server set up in the  previous step and run the install. The installer reboots at the end but  the -no-reboot flag to kvm means that kvm will exit when this happens.  It should take about 5 minutes.

### Boot the installed system

```
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio
```

This will boot into the freshly installed system and you should be able to log in as ubuntu/ubuntu.

## Using another volume to provide the autoinstall config

This is the method to use when you want to create media that you can just plug into a system to have it be installed.

### Download the live-server ISO

Go to the [20.04 ISO download page](http://releases.ubuntu.com/20.04/) and download the latest Ubuntu 20.04 live-server ISO.

### Create your user-data & meta-data files

```
mkdir -p ~/cidata
cd ~/cidata
cat > user-data << 'EOF'
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: ubuntu-server
    password: "$6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0"
    username: ubuntu
EOF
touch meta-data
```

The crypted password is just “ubuntu”.

### Create an ISO to use as a cloud-init data source

```
sudo apt install cloud-image-utils
cloud-localds ~/seed.iso user-data meta-data
```

### Create a target disk

```
truncate -s 10G image.img
```

### Run the install!

```
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio \
    -drive file=~/seed.iso,format=raw,cache=none,if=virtio \
    -cdrom ~/Downloads/ubuntu-20.04-live-server-amd64.iso
```

This will boot and run the install. Unless you interrupt boot to add  ‘autoinstall’ to the kernel command line, the installer will prompt for  confirmation before touching the disk.

The installer reboots at the end but the -no-reboot flag to kvm means that kvm will exit when this happens.

The whole process should take about 5 minutes.

### Boot the installed system

```
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio
```

This will boot into the freshly installed system and you should be able to log in as ubuntu/ubuntu.

# Autoinstall Quick Start for s390x

The intent of this page is to provide simple instructions to perform an autoinstall in a VM on your machine on s390x.

This page is just a slightly adapted page of [Automated Server Install Quickstart](https://ubuntu.com/server/docs/install/autoinstall-quickstart) mapped to s390x.

## Download an ISO

At the time of writing (just before focal release), the best place to go is here:
 http://cdimage.ubuntu.com/ubuntu/releases/20.04/release/

```
wget http://cdimage.ubuntu.com/ubuntu/releases/20.04/release/ubuntu-20.04-live-server-s390x.iso -P ~/Downloads
```

## Mount the ISO

```
mkdir -p ~/iso
sudo mount -r ~/Downloads/ubuntu-20.04-live-server-s390x.iso ~/iso
```

## Write your autoinstall config

This means creating cloud-init config as follows:

```
mkdir -p ~/www
cd ~/www
cat > user-data << 'EOF'
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: ubuntu-server
    password: "$6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0"
    username: ubuntu
EOF
touch meta-data
```

The crypted password is just “ubuntu”.

## Serve the cloud-init config over http

Leave this running in one terminal window:

```
cd ~/www
python3 -m http.server 3003
```

## Create a target disk

Proceed with a second terminal window:

```
sudo apt install qemu-utils
...
qemu-img create -f qcow2 disk-image.qcow2 10G
Formatting 'disk-image.qcow2', fmt=qcow2 size=10737418240 cluster_size=65536 lazy_refcounts=off refcount_bits=16

qemu-img info disk-image.qcow2
image: disk-image.qcow2
file format: qcow2
virtual size: 10 GiB (10737418240 bytes)
disk size: 196 KiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
```

## Run the install!

```
sudo apt install qemu-kvm
...
```

You may need to add the default user to the kvm group:  <
\>
 `sudo usermod -a -G kvm ubuntu # re-login to make the changes take effect`

```
kvm -no-reboot -name auto-inst-test -nographic -m 2048 \
    -drive file=disk-image.qcow2,format=qcow2,cache=none,if=virtio \
    -cdrom ~/Downloads/ubuntu-20.04-live-server-s390x.iso \
    -kernel ~/iso/boot/kernel.ubuntu \
    -initrd ~/iso/boot/initrd.ubuntu \
    -append 'autoinstall ds=nocloud-net;s=http://_gateway:3003/ console=ttysclp0'
```

This will boot, download the config from the server set up in the previous step and run the install.
 The installer reboots at the end but the -no-reboot flag to kvm means that kvm will exit when this happens.
 It should take about 5 minutes.

## Boot the installed system

```
kvm -no-reboot -name auto-inst-test -nographic -m 2048 \
    -drive file=disk-image.qcow2,format=qcow2,cache=none,if=virtio
```

This will boot into the freshly installed system and you should be able to log in as ubuntu/ubuntu.

# Automated Server Installs Config File Reference

# Overall format

The autoinstall file is YAML. At top level it must be a mapping  containing the keys described in this document. Unrecognized keys are  ignored.

# Schema

Autoinstall configs [are validated against a JSON schema](https://ubuntu.com/server/docs/install/autoinstall-schema) before they are used.



# Command lists

Several config keys are lists of commands to be executed. Each  command can be a string (in which case it is executed via “sh -c”) or a  list, in which case it is executed directly. Any command exiting with a  non-zero return code is considered an error and aborts the install  (except for error-commands, where it is ignored).

# Top-level keys



## version

**type:** integer
 **default:** no default

A future-proofing config file version field. Currently this must be “1”.



## interactive-sections

**type:** list of strings
 **default:** []

A list of config keys to still show in the UI. So for example:

```
version: 1
interactive-sections:
 - network
identity:
 username: ubuntu
 password: $crypted_pass
```

Would stop on the network screen and allow the user to change the  defaults. If a value is provided for an interactive section it is used  as the default.

You can use the special section name of “*” to indicate that the  installer should ask all the usual questions – in this case, the `autoinstall.yaml` file is not really an “autoinstall” file at all, instead just a way to change the defaults in the UI.

Not all config keys correspond to screens in the UI. This documentation indicates if a given section can be interactive or not.

If there are any interactive sections at all, the [reporting](https://ubuntu.com/server/docs/install/autoinstall-reference#reporting) key is ignored.



## early-commands

**type:** [command list](https://ubuntu.com/server/docs/install/autoinstall-reference#commandlist)
 **default:** no commands
 **can be interactive:** no

A list of shell commands to invoke as soon as the installer starts,  in particular before probing for block and network devices. The  autoinstall config is available at `/autoinstall.yaml` (irrespective of how it was provided) and the file will be re-read after the `early-commands` have run to allow them to alter the config if necessary.



## locale

**type:** string
 **default:** `en_US.UTF-8`
 **can be interactive:** yes, always interactive if any section is

The locale to configure for the installed system.



## refresh-installer

**type:** mapping
 **default:** see below
 **can be interactive:** yes

Controls whether the installer updates to a new version available in the given channel before continuing.

The mapping contains keys:

### update

**type:** boolean
 **default**: `no`

Whether to update or not.

### channel

**type:** string
 **default**: `"stable/ubuntu-$REL"`

The channel to check for updates.



## keyboard

**type:** mapping, see below
 **default:** US English keyboard
 **can be interactive:** yes

The layout of any attached keyboard. Often systems being  automatically installed will not have a keyboard at all in which case  the value used here does not matter.

The mapping’s keys correspond to settings in the `/etc/default/keyboard` configuration file. See [its manual page](http://manpages.ubuntu.com/manpages/bionic/en/man5/keyboard.5.html) for more details.

The mapping contains keys:

### layout

**type:** string
 **default**: `"us"`

Corresponds to the `XKBLAYOUT` setting.

### variant

**type:** string
 **default**: `""`

Corresponds to the `XKBVARIANT` setting.

### toggle

**type:** string or null
 **default**: `null`

Corresponds to the value of `grp:` option from the `XKBOPTIONS` setting. Acceptable values are (but note that the installer does not validate these): `caps_toggle`, `toggle`, `rctrl_toggle`, `rshift_toggle`, `rwin_toggle`, `menu_toggle`, `alt_shift_toggle`, `ctrl_shift_toggle`, `ctrl_alt_toggle`, `alt_caps_toggle`, `lctrl_lshift_toggle`, `lalt_toggle`, `lctrl_toggle`, `lshift_toggle`, `lwin_toggle`, `sclk_toggle`

The version of subiquity released with 20.04 GA does not accept `null` for this field due to a bug.



## network

**type:** netplan-format mapping, see below
 **default:** DHCP on interfaces named eth* or en*
 **can be interactive:** yes

[netplan](https://netplan.io/reference) formatted network  configuration. This will be applied during installation as well as in  the installed system. The default is to interpret the config for the  install media, which runs DHCPv4 on any interface with a name matching  “eth*” or “en*” but then disables any interface that does not receive an address.

For example, to run dhcp6 on a particular NIC:

```
network:
  version: 2
  ethernets:
    enp0s31f6:
      dhcp6: yes
```

Note that thanks to a bug, the version of subiquity released with  20.04 GA forces you to write this with an extra “network:” key like so:

```
network:
  network:
    version: 2
    ethernets:
      enp0s31f6:
        dhcp6: yes
```

Later versions support this syntax too for compatibility but if you can assume a newer version you should use the former.



## proxy

**type:** URL or `null`
 **default:** no proxy
 **can be interactive:** yes

The proxy to configure both during installation and for apt and for snapd in the target system.



## apt

**type:** mapping
 **default:** see below
 **can be interactive:** yes

Apt configuration, used both during the install and once booted into the target system.

This uses the same format as curtin which is documented at https://curtin.readthedocs.io/en/latest/topics/apt_source.html, with one extension: the `geoip` key controls whether a geoip lookup is done.

The default is:

```
apt:
    preserve_sources_list: false
    primary:
        - arches: [i386, amd64]
          uri: "http://archive.ubuntu.com/ubuntu"
        - arches: [default]
          uri: "http://ports.ubuntu.com/ubuntu-ports"
    geoip: true
```

If geoip is true and the mirror to be used is the default, a request is made to `https://geoip.ubuntu.com/lookup` and the mirror uri to be used changed to be `http://CC.archive.ubuntu.com/ubuntu` where `CC` is the country code returned by the lookup (or similar for ports). If  this section is not interactive, the request is timed out after 10  seconds.

Any supplied config is merged with the default rather than replacing it.

If you just want to set a mirror, use a config like this:

```
apt:
    primary:
        - arches: [default]
          uri: YOUR_MIRROR_GOES_HERE
```

To add a ppa:

```
apt:
    sources:
        curtin-ppa:
            source: ppa:curtin-dev/test-archive
```



## storage

**type:** mapping, see below
 **default:** use “lvm” layout in a single disk system, no default in a multiple disk system
 **can be interactive:** yes

Storage configuration is a complex topic and the description of the  desired configuration in the autoinstall file can necessarily also be  complex. The installer supports “layouts”, simple ways of expressing  common configurations.

### Supported layouts

The two supported layouts at the time of writing are “lvm” and “direct”.

```
storage:
  layout:
    name: lvm
storage:
  layout:
    name: direct
```

By default these will install to the largest disk in a system, but  you can supply a match spec (see below) to indicate which disk to use:

```
storage:
  layout:
    name: lvm
    match:
      serial: CT*
storage:
  layout:
    name: disk
    match:
      ssd: yes
```

(you can just say “`match: {}`” to match an arbitrary disk)

The default is to use the lvm layout.

### action-based config

For full flexibility, the installer allows storage configuration to  be done using a syntax which is a superset of that supported by curtin,  described at https://curtin.readthedocs.io/en/latest/topics/storage.html. As well as putting the list of actions under the ‘config’ key, the [grub](https://curtin.readthedocs.io/en/latest/topics/config.html#grub) and [swap](https://curtin.readthedocs.io/en/latest/topics/config.html#swap) curtin config items can be put here. So a storage section might look like:

```
storage:
    swap:
        size: 0
    config:
        - type: disk
          id: disk0
          serial: ADATA_SX8200PNP_XXXXXXXXXXX
        - type: partition
          ...
```

The extensions to the curtin syntax are around disk selection and partition/logical volume sizing.

#### Disk selection extensions

Curtin supported identifying disks by serial (e.g. `Crucial_CT512MX100SSD1_14250C57FECE`) or by path (e.g. `/dev/sdc`) and the server installer supports this as well. The installer  additionally supports a ‘‘match spec’’ on a disk action that supports  more flexible matching.

The actions in the storage config are processed in the order they are in the autoinstall file. Any disk action is assigned a matching disk –  chosen arbitrarily from the set of unassigned disks if there is more  than one, and causing the installation to fail if there is no unassigned matching disk.

A match spec supports the following keys:

- `model: foo`: matches a disk where ID_VENDOR=foo in udev, supporting globbing
- `path: foo`: matches a disk where DEVPATH=foo in udev,  supporting globbing (the globbing support distinguishes this from  specifying path: foo directly in the disk action)
- `serial: foo`: matches a disk where ID_SERIAL=foo in udev,  supporting globbing (the globbing support distinguishes this from  specifying serial: foo directly in the disk action)
- `ssd: yes|no`: matches a disk that is or is not an SSD (vs a rotating drive)
- `size: largest|smallest`: take the largest or smallest disk rather than an arbitrary one if there are multiple matches (support for `smallest` added in version 20.06.1)

So for example, to match an arbitrary disk it is simply:

```
 - type: disk
   id: disk0
```

To match the largest ssd:

```
 - type: disk
   id: big-fast-disk
   match:
     ssd: yes
     size: largest
```

To match a Seagate drive:

```
 - type: disk
   id: data-disk
   match:
     model: Seagate
```

#### partition/logical volume extensions

The size of a partition or logical volume in curtin is specified as a number of bytes. The autoinstall config is more flexible:

- You can specify the size using the “1G”, “512M” syntax supported in the installer UI
- You can specify the size as a percentage of the containing disk (or RAID), e.g. “50%”
- For the last partition specified for a particular device, you can  specify the size as “-1” to indicate that the partition should fill the  remaining space.

```
 - type: partition
   id: boot-partition
   device: root-disk
   size: 10%
 - type: partition
   id: root-partition
   size: 20G
 - type: partition
   id: data-partition
   device: root-disk
   size: -1
```



## identity

**type:** mapping, see below
 **default:** no default
 **can be interactive:** yes

Configure the initial user for the system. This is the only config key that must be present (unless the [user-data section](https://ubuntu.com/server/docs/install/autoinstall-reference#user-data) is present, in which case it is optional).

A mapping that can contain keys, all of which take string values:

### realname

The real name for the user. This field is optional.

### username

The user name to create.

### hostname

The hostname for the system.

### password

The password for the new user, crypted. This is required for use with sudo, even if SSH access is configured.



## ssh

**type:** mapping, see below
 **default:** see below
 **can be interactive:** yes

Configure ssh for the installed system. A mapping that can contain keys:

### install-server

**type:** boolean
 **default:** `false`

Whether to install OpenSSH server in the target system.

### authorized-keys

**type:** list of strings
 **default:** `[]`

A list of SSH public keys to install in the initial user’s account.

### allow-pw

**type:** boolean
 **default:** `true` if `authorized_keys` is empty, `false` otherwise



## snaps

**type:** list
 **default:** install no extra snaps
 **can be interactive:** yes

A list of snaps to install. Each snap is represented as a mapping with required `name` and optional `channel` (defaulting to `stable`) and classic (defaulting to `false`) keys. For example:

```
snaps:
    - name: etcd
      channel: edge
      classic: false
```



## debconf-selections

**type:** string
 **default:** no config
 **can be interactive:** no

The installer will update the target with debconf set-selection  values. Users will need to be familiar with the package debconf options.



## packages

**type:** list
 **default:** no packages
 **can be interactive:** no

A list of packages to install into the target system. More precisely, a list of strings to pass to “`apt-get install`”, so this includes things like task selection (`dns-server^`) and installing particular versions of a package (`my-package=1-1`).



## late-commands

**type:** [command list](https://ubuntu.com/server/docs/install/autoinstall-reference#commandlist)
 **default:** no commands
 **can be interactive:** no

Shell commands to run after the install has completed successfully  and any updates and packages installed, just before the system reboots.  They are run in the installer environment with the installed system  mounted at `/target`. You can run `curtin in-target -- $shell_command` (with the version of subiquity released with 20.04 GA you need to specify this as `curtin in-target --target=/target -- $shell_command`) to run in the target system (similar to how plain `in-target` can be used in `d-i preseed/late_command`).



## error-commands

**type:** [command list](https://ubuntu.com/server/docs/install/autoinstall-reference#commandlist)
 **default:** no commands
 **can be interactive:** no

Shell commands to run after the install has failed. They are run in  the installer environment, and the target system (or as much of it as  the installer managed to configure) will be mounted at /target. Logs  will be available at `/var/log/installer` in the live session.



## reporting

**type:** mapping
 **default:** `type: print` which causes output on tty1 and any configured serial consoles
 **can be interactive:** no

The installer supports reporting progress to a variety of destinations.  Note that this section is ignored if there are any [interactive sections](https://ubuntu.com/server/docs/install/autoinstall-reference#interactive-sections); it only applies to fully automated installs.

The config, and indeed the implementation, is 90% the same as [that used by curtin](https://curtin.readthedocs.io/en/latest/topics/reporting.html).

Each key in the `reporting` mapping in the config defines a destination, where the `type` sub-key is one of:

**The rsyslog reporter does not yet exist**

- **print**: print progress information on tty1 and any configured serial console. There is no other configuration.
- **rsyslog**: report progress via rsyslog. The **destination** key specifies where to send output.
- **webhook**: report progress via POSTing JSON reports to a URL. Accepts the same configuration as [curtin](https://curtin.readthedocs.io/en/latest/topics/reporting.html#webhook-reporter).
- **none**: do not report progress. Only useful to inhibit the default output.

Examples:

The default configuration is:

```
reporting:
 builtin:
  type: print
```

Report to rsyslog:

```
reporting:
 central:
  type: rsyslog
  destination: @192.168.0.1
```

Suppress the default output:

```
reporting:
 builtin:
  type: none
```

Report to a curtin-style webhook:

```
reporting:
 hook:
  type: webhook
  endpoint: http://example.com/endpoint/path
  consumer_key: "ck_foo"
  consumer_secret: "cs_foo"
  token_key: "tk_foo"
  token_secret: "tk_secret"
  level: INFO
```



## user-data

**type:** mapping
 **default:** `{}`
 **can be interactive:** no

Provide cloud-init user-data which will be merged with the user-data  the installer produces. If you supply this, you don’t need to supply an [identity section](https://ubuntu.com/server/docs/install/autoinstall-reference#identity) (but then it’s your responsibility to make sure that you can log into the installed system!).

# JSON Schema for autoinstall config

## Introduction

The server installer validates the provided autoinstall config against a [JSON Schema](https://ubuntu.com/server/docs/install/autoinstall-schema#Schema).

## How the config is validated

Although the schema is presented below as a single document, and if  you want to pre-validate your config you should validate it against this document, the config is not actually validated against this document at run time. What happens instead is that some sections are loaded,  validated and applied first, before all other sections are validated. In detail:

1. The reporting section is loaded, validated and applied.
2. The error commands are loaded and validated.
3. The early commands are loaded and validated.
4. The early commands, if any, are run.
5. The config is reloaded, and now all sections are loaded and validated.

This is so that validation errors in most sections can be reported  via the reporting and error-commands configuration, as all other errors  are.

## Schema

The [JSON schema](https://json-schema.org/) for autoinstall data is as follows:

```
{
    "type": "object",
    "properties": {
        "version": {
            "type": "integer",
            "minumum": 1,
            "maximum": 1
        },
        "early-commands": {
            "type": "array",
            "items": {
                "type": [
                    "string",
                    "array"
                ],
                "items": {
                    "type": "string"
                }
            }
        },
        "reporting": {
            "type": "object",
            "additionalProperties": {
                "type": "object",
                "properties": {
                    "type": {
                        "type": "string"
                    }
                },
                "required": [
                    "type"
                ],
                "additionalProperties": true
            }
        },
        "error-commands": {
            "type": "array",
            "items": {
                "type": [
                    "string",
                    "array"
                ],
                "items": {
                    "type": "string"
                }
            }
        },
        "user-data": {
            "type": "object"
        },
        "packages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "debconf-selections": {
            "type": "string"
        },
        "locale": {
            "type": "string"
        },
        "refresh-installer": {
            "type": "object",
            "properties": {
                "update": {
                    "type": "boolean"
                },
                "channel": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "keyboard": {
            "type": "object",
            "properties": {
                "layout": {
                    "type": "string"
                },
                "variant": {
                    "type": "string"
                },
                "toggle": {
                    "type": [
                        "string",
                        "null"
                    ]
                }
            },
            "required": [
                "layout"
            ],
            "additionalProperties": false
        },
        "network": {
            "oneOf": [
                {
                    "type": "object",
                    "properties": {
                        "version": {
                            "type": "integer",
                            "minimum": 2,
                            "maximum": 2
                        },
                        "ethernets": {
                            "type": "object",
                            "properties": {
                                "match": {
                                    "type": "object",
                                    "properties": {
                                        "name": {
                                            "type": "string"
                                        },
                                        "macaddress": {
                                            "type": "string"
                                        },
                                        "driver": {
                                            "type": "string"
                                        }
                                    },
                                    "additionalProperties": false
                                }
                            }
                        },
                        "wifis": {
                            "type": "object",
                            "properties": {
                                "match": {
                                    "type": "object",
                                    "properties": {
                                        "name": {
                                            "type": "string"
                                        },
                                        "macaddress": {
                                            "type": "string"
                                        },
                                        "driver": {
                                            "type": "string"
                                        }
                                    },
                                    "additionalProperties": false
                                }
                            }
                        },
                        "bridges": {
                            "type": "object"
                        },
                        "bonds": {
                            "type": "object"
                        },
                        "tunnels": {
                            "type": "object"
                        },
                        "vlans": {
                            "type": "object"
                        }
                    },
                    "required": [
                        "version"
                    ]
                },
                {
                    "type": "object",
                    "properties": {
                        "network": {
                            "type": "object",
                            "properties": {
                                "version": {
                                    "type": "integer",
                                    "minimum": 2,
                                    "maximum": 2
                                },
                                "ethernets": {
                                    "type": "object",
                                    "properties": {
                                        "match": {
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                    "type": "string"
                                                },
                                                "macaddress": {
                                                    "type": "string"
                                                },
                                                "driver": {
                                                    "type": "string"
                                                }
                                            },
                                            "additionalProperties": false
                                        }
                                    }
                                },
                                "wifis": {
                                    "type": "object",
                                    "properties": {
                                        "match": {
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                    "type": "string"
                                                },
                                                "macaddress": {
                                                    "type": "string"
                                                },
                                                "driver": {
                                                    "type": "string"
                                                }
                                            },
                                            "additionalProperties": false
                                        }
                                    }
                                },
                                "bridges": {
                                    "type": "object"
                                },
                                "bonds": {
                                    "type": "object"
                                },
                                "tunnels": {
                                    "type": "object"
                                },
                                "vlans": {
                                    "type": "object"
                                }
                            },
                            "required": [
                                "version"
                            ]
                        }
                    },
                    "required": [
                        "network"
                    ]
                }
            ]
        },
        "proxy": {
            "type": [
                "string",
                "null"
            ],
            "format": "uri"
        },
        "apt": {
            "type": "object",
            "properties": {
                "preserve_sources_list": {
                    "type": "boolean"
                },
                "primary": {
                    "type": "array"
                },
                "geoip": {
                    "type": "boolean"
                },
                "sources": {
                    "type": "object"
                }
            }
        },
        "storage": {
            "type": "object"
        },
        "identity": {
            "type": "object",
            "properties": {
                "realname": {
                    "type": "string"
                },
                "username": {
                    "type": "string"
                },
                "hostname": {
                    "type": "string"
                },
                "password": {
                    "type": "string"
                }
            },
            "required": [
                "username",
                "hostname",
                "password"
            ],
            "additionalProperties": false
        },
        "ssh": {
            "type": "object",
            "properties": {
                "install-server": {
                    "type": "boolean"
                },
                "authorized-keys": {
                    "type": "array",
                    "items": {
                        "type": "string"
                    }
                },
                "allow-pw": {
                    "type": "boolean"
                }
            }
        },
        "snaps": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string"
                    },
                    "channel": {
                        "type": "string"
                    },
                    "classic": {
                        "type": "boolean"
                    }
                },
                "required": [
                    "name"
                ],
                "additionalProperties": false
            }
        },
        "late-commands": {
            "type": "array",
            "items": {
                "type": [
                    "string",
                    "array"
                ],
                "items": {
                    "type": "string"
                }
            }
        }
    },
    "required": [
        "version"
    ],
    "additionalProperties": true
}
```

## Regeneration

The schema above can be regenerated by running “make schema” in a subiquity source checkout.

# Cloud Images

Canonical produces a variety of cloud-specific images, which are available directly on the cloud’s themselves as well as on https://cloud-images.ubuntu.com.

## Public Clouds

### Compute Offerings

Users can find Ubuntu images for virtual machines and bare-metal offerings published directly to the following clouds:

- [Amazon Elastic Compute Cloud (EC2)](https://ubuntu.com/server/docs/cloud-images/amazon-ec2)
- [Google Cloud Engine (GCE)](https://ubuntu.com/server/docs/cloud-images/google-cloud-engine)
- IBM Cloud
- Microsoft Azure
- Oracle Cloud

### Container Offerings

Ubuntu images are also produced for a number of container offerings:

- Amazon Elastic Kubernetes Service (EKS)
- Google Kubernetes Engine (GKE)

## Private Clouds

On [cloud-images.ubuntu.com](https://cloud-images.ubuntu.com), users can find standard and minimal images for the following:

- Hyper-V
- KVM
- OpenStack
- Vagrant
- VMware

## Release Support

Cloud images are published and supported throughout the [lifecycle of an Ubuntu release](https://ubuntu.com/about/release-cycle). During this time images can receive all published security updates and bug fixes.

For users wanting to upgrade from one release to the next, the  recommended path is to launch a new image with the desired release and  then migrate whatever workload or data to the new image.

Some cloud image customization must be applied during image creation, these would be missing if an in-place upgrade were performed.  For that reason in-place upgrades of cloud images are not recommended.

# Amazon EC2

Amazon Web Service’s Elastic Compute Cloud (EC2) provides a platform for deploying and running applications.

## Images

On EC2, cloud images are referred to as Amazon Machine Images (AMIs). Canonical produces a wide variety of images to support numerous  features found on EC2:

- Generally, all images utilize EBS storage and HVM virtualization  types. Older releases may also support PV and instance-store, but users  benefit from the newer storage and virtualization technologies.
- Standard server images as well as minimal images for `amd64`. As well, `arm64` images for the standard server set.
- Daily (untested) and release images are published.

### Find Images with SSM

The AWS Systems Manager (SSM) parameter store is used by Canonical to store the latest AMI release versions for EC2. This provides users with a programmatic method of querying for the latest AMI ID.

Canonical stores SSM parameters under `/aws/service/canonical/`. To find the latest AMI ID user’s can use the AWS CLI:

```auto
aws ssm get-parameters --names \
     /aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id
```

The path follows the following format:

```auto
ubuntu/$PRODUCT/$RELEASE/stable/current/$ARCH/$VIRT_TYPE/$VOL_TYPE/ami-id
```

- PRODUCT: `server` or `server-minimal`
- RELEASE: `focal`, `20.04`, `bionic`, `18.04`, `xenial`, or `16.04`
- ARCH: `amd64` or `arm64`
- VIRT_TYPE: `pv` or `hvm`
- VOL_TYPE: `ebs-gp2`, `ebs-io1`, `ebs-standard`, or `instance-store`

The given serial for an image (e.g. 20210222) is also uploaded in place of current:

```auto
ubuntu/$PRODUCT/$RELEASE/stable/$SERIAL/$ARCH/$VIRT_TYPE/$VOL_TYPE/ami-id
```

For more details on SSM check out the following [Discourse thread](https://discourse.ubuntu.com/t/finding-ubuntu-images-with-the-aws-ssm-parameter-store/15507).

#### Ownership Verification

User’s can verify that an AMI was published by Canonical by ensuring the  `OwnerId` field of an image is `099720109477`. This ID is stored in SSM and is discoverable by running:

```auto
aws ssm get-parameters --names /aws/service/canonical/meta/publisher-id
```

With the value returned by that command, user’s can then run the `describe-images` command against an AMI ID and verify the `OwnerId` field matches the above ID:

```auto
aws ec2 describe-images --image-ids $AMI_ID
```

Note that listings on the AWS Marketplace will always show the `OwnerId` as Amazon (e.g. `679593333241`). In these cases, users can verify the Amazon ID and look for `aws-marketplace/ubuntu` in the `ImageLocation` field.

### Image Locator

Canonical also produces a [Ubutnu Cloud Image Finder](https://cloud-images.ubuntu.com/locator/) where users can filter down based on a variety of criteria (e.g. region, release, etc. ).

# AWS EKS

EKS is a managed Kubernetes service provided by AWS that lets users run Kubernetes applications in the cloud or on-premises.

Canonical provides [minimized Ubuntu images customized for use with EKS](https://cloud-images.ubuntu.com/docs/aws/eks/). These are fully tested release images that cover all Kubernetes versions supported by the EKS service.

# AWS Marketplace

AWS Marketplace is a digital catalog with thousands of software  listings from independent software vendors that make it easy to find,  test, buy, and deploy software that runs on AWS.

Canonical maintains [image listings](https://aws.amazon.com/marketplace/seller-profile?id=565feec9-3d43-413e-9760-c651546613f2) for recent Ubuntu releases on AWS Marketplace, including images in minimal and arm64 flavors.

Customers can also use the AWS Marketplace to launch and subscribe to official [Ubuntu](https://aws.amazon.com/marketplace/pp/B0821T9RL2) [Pro](https://aws.amazon.com/marketplace/pp/B087L1R4G4) images that allow users to pay for additional support.

# Google Cloud Engine

Google Cloud Platform lets you build and host applications and  websites, store data, and analyze data on Google’s scalable  infrastructure.

## Images

On GCE, Canonical produces standard server and minimal images for all supported releases.

### Finding Images

Users can find the latest Ubuntu images on the GCE UI by selecting  “Ubuntu” as the Operating System under the Boot Disk settings.

For a programmatic method, users can use the `gcloud` command to find the latest, release images:

```auto
gcloud compute images list --filter ubuntu-os-cloud
```

Daily, untested, images are found under the `ubuntu-os-cloud-devel` project:

```auto
gcloud compute images --project ubuntu-os-cloud-devel list --filter ubuntu-os-cloud-devel
```

### Image Locator

Canonical also produces a [Ubuntu Cloud Image Finder](https://cloud-images.ubuntu.com/locator/) where users can filter down based on a variety of criteria (e.g. region, release, etc. ).

# Networking

Networks consist of two or more devices, such as computer systems,  printers, and related equipment which are connected by either physical  cabling or wireless links for the purpose of sharing and distributing  information among the connected devices.

This section provides general and specific information pertaining to  networking, including an overview of network concepts and detailed  discussion of popular network protocols.

# TCP/IP

The Transmission Control Protocol and Internet Protocol (TCP/IP) is a standard set of protocols developed in the late 1970s by the Defense  Advanced Research Projects Agency (DARPA) as a means of communication  between different types of computers and computer networks. TCP/IP is  the driving force of the Internet, and thus it is the most popular set  of network protocols on Earth.

## TCP/IP Introduction

The two protocol components of TCP/IP deal with different aspects of computer networking. *Internet Protocol*, the “IP” of TCP/IP is a connectionless protocol which deals only with network packet routing using the *IP Datagram* as the basic unit of networking information. The IP Datagram consists of a header followed by a message. The *Transmission Control Protocol* is the “TCP” of TCP/IP and enables network hosts to establish  connections which may be used to exchange data streams. TCP also  guarantees that the data between connections is delivered and that it  arrives at one network host in the same order as sent from another  network host.

## TCP/IP Configuration

The TCP/IP protocol configuration consists of several elements which  must be set by editing the appropriate configuration files, or deploying solutions such as the Dynamic Host Configuration Protocol (DHCP) server which in turn, can be configured to provide the proper TCP/IP  configuration settings to network clients automatically. These  configuration values must be set correctly in order to facilitate the  proper network operation of your Ubuntu system.

The common configuration elements of TCP/IP and their purposes are as follows:

- **IP address** The IP address is a unique identifying  string expressed as four decimal numbers ranging from zero (0) to  two-hundred and fifty-five (255), separated by periods, with each of the four numbers representing eight (8) bits of the address for a total  length of thirty-two (32) bits for the whole address. This format is  called *dotted quad notation*.

- **Netmask** The Subnet Mask (or simply, *netmask*) is a local bit mask, or set of flags which separate the portions of an  IP address significant to the network from the bits significant to the *subnetwork*. For example, in a Class C network, the standard netmask is  255.255.255.0 which masks the first three bytes of the IP address and  allows the last byte of the IP address to remain available for  specifying hosts on the subnetwork.

- **Network Address** The Network Address represents the  bytes comprising the network portion of an IP address. For example, the  host 12.128.1.2 in a Class A network would use 12.0.0.0 as the network  address, where twelve (12) represents the first byte of the IP address,  (the network part) and zeroes (0) in all of the remaining three bytes to represent the potential host values. A network host using the private  IP address 192.168.1.100 would in turn use a Network Address of  192.168.1.0, which specifies the first three bytes of the Class C  192.168.1 network and a zero (0) for all the possible hosts on the  network.

- **Broadcast Address** The Broadcast Address is an IP  address which allows network data to be sent simultaneously to all hosts on a given subnetwork rather than specifying a particular host. The  standard general broadcast address for IP networks is 255.255.255.255,  but this broadcast address cannot be used to send a broadcast message to every host on the Internet because routers block it. A more appropriate broadcast address is set to match a specific subnetwork. For example,  on the private Class C IP network, 192.168.1.0, the broadcast address is 192.168.1.255. Broadcast messages are typically produced by network  protocols such as the Address Resolution Protocol (ARP) and the Routing  Information Protocol (RIP).

- **Gateway Address** A Gateway Address is the IP address  through which a particular network, or host on a network, may be  reached. If one network host wishes to communicate with another network  host, and that host is not located on the same network, then a *gateway* must be used. In many cases, the Gateway Address will be that of a  router on the same network, which will in turn pass traffic on to other  networks or hosts, such as Internet hosts. The value of the Gateway  Address setting must be correct, or your system will not be able to  reach any hosts beyond those on the same network.

- **Nameserver Address** Nameserver Addresses represent  the IP addresses of Domain Name Service (DNS) systems, which resolve  network hostnames into IP addresses. There are three levels of  Nameserver Addresses, which may be specified in order of precedence: The *Primary* Nameserver, the *Secondary* Nameserver, and the *Tertiary* Nameserver. In order for your system to be able to resolve network  hostnames into their corresponding IP addresses, you must specify valid  Nameserver Addresses which you are authorized to use in your system’s  TCP/IP configuration. In many cases these addresses can and will be  provided by your network service provider, but many free and publicly  accessible nameservers are available for use, such as the Level3  (Verizon) servers with IP addresses from 4.2.2.1 to 4.2.2.6.

  > **Tip**
  >
  > The IP address, Netmask, Network Address, Broadcast Address, Gateway  Address, and Nameserver Addresses are typically specified via the  appropriate directives in the file `/etc/network/interfaces`. For more information, view the system manual page for `interfaces`, with the following command typed at a terminal prompt:

  Access the system manual page for `interfaces` with the following command:

  ```
  man interfaces
  ```

## IP Routing

IP routing is a means of specifying and discovering paths in a TCP/IP network along which network data may be sent. Routing uses a set of *routing tables* to direct the forwarding of network data packets from their source to  the destination, often via many intermediary network nodes known as *routers*. There are two primary forms of IP routing: *Static Routing* and *Dynamic Routing.*

Static routing involves manually adding IP routes to the system’s  routing table, and this is usually done by manipulating the routing  table with the route command. Static routing enjoys many advantages over dynamic routing, such as simplicity of implementation on smaller  networks, predictability (the routing table is always computed in  advance, and thus the route is precisely the same each time it is used), and low overhead on other routers and network links due to the lack of a dynamic routing protocol. However, static routing does present some  disadvantages as well. For example, static routing is limited to small  networks and does not scale well. Static routing also fails completely  to adapt to network outages and failures along the route due to the  fixed nature of the route.

Dynamic routing depends on large networks with multiple possible IP  routes from a source to a destination and makes use of special routing  protocols, such as the Router Information Protocol (RIP), which handle  the automatic adjustments in routing tables that make dynamic routing  possible. Dynamic routing has several advantages over static routing,  such as superior scalability and the ability to adapt to failures and  outages along network routes. Additionally, there is less manual  configuration of the routing tables, since routers learn from one  another about their existence and available routes. This trait also  eliminates the possibility of introducing mistakes in the routing tables via human error. Dynamic routing is not perfect, however, and presents  disadvantages such as heightened complexity and additional network  overhead from router communications, which does not immediately benefit  the end users, but still consumes network bandwidth.

## TCP and UDP

TCP is a connection-based protocol, offering error correction and guaranteed delivery of data via what is known as *flow control*. Flow control determines when the flow of a data stream needs to be  stopped, and previously sent data packets should to be re-sent due to  problems such as *collisions*, for example, thus ensuring  complete and accurate delivery of the data. TCP is typically used in the exchange of important information such as database transactions.

The User Datagram Protocol (UDP), on the other hand, is a *connectionless* protocol which seldom deals with the transmission of important data  because it lacks flow control or any other method to ensure reliable  delivery of the data. UDP is commonly used in such applications as audio and video streaming, where it is considerably faster than TCP due to  the lack of error correction and flow control, and where the loss of a  few packets is not generally catastrophic.

## ICMP

The Internet Control Messaging Protocol (ICMP) is an extension to the Internet Protocol (IP) as defined in the Request For Comments (RFC) #792 and supports network packets containing control, error, and  informational messages. ICMP is used by such network applications as the ping utility, which can determine the availability of a network host or device. Examples of some error messages returned by ICMP which are  useful to both network hosts and devices such as routers, include *Destination Unreachable* and *Time Exceeded*.

## Daemons

Daemons are special system applications which typically execute  continuously in the background and await requests for the functions they provide from other applications. Many daemons are network-centric; that is, a large number of daemons executing in the background on an Ubuntu  system may provide network-related functionality. Some examples of such  network daemons include the *Hyper Text Transport Protocol Daemon* (httpd), which provides web server functionality; the *Secure SHell Daemon* (sshd), which provides secure remote login shell and file transfer capabilities; and the *Internet Message Access Protocol Daemon* (imapd), which provides E-Mail services.

## Resources

- There are man pages for [TCP](https://manpages.ubuntu.com/manpages/focal/en/man7/tcp.7.html) and [IP](http://manpages.ubuntu.com/manpages/focal/man7/ip.7.html) that contain more useful information.
- Also, see the [TCP/IP Tutorial and Technical Overview](http://www.redbooks.ibm.com/abstracts/gg243376.html) IBM Redbook.
- Another resource is O’Reilly’s [TCP/IP Network Administration](http://oreilly.com/catalog/9780596002978/).

# Network Configuration

Ubuntu ships with a number of graphical utilities to configure your  network devices. This document is geared toward server administrators  and will focus on managing your network on the command line.

## Ethernet Interfaces

Ethernet interfaces are identified by the system using predictable network interface names. These names can appear as *eno1* or *enp0s25*. However, in some cases an interface may still use the kernel *eth#* style of naming.

### Identify Ethernet Interfaces

To quickly identify all available Ethernet interfaces, you can use the ip command as shown below.

```
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:e2:52:42 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.102.66.200/24 brd 10.102.66.255 scope global dynamic eth0
       valid_lft 3257sec preferred_lft 3257sec
    inet6 fe80::216:3eff:fee2:5242/64 scope link
       valid_lft forever preferred_lft forever
```

Another application that can help identify all network interfaces  available to your system is the lshw command. This command provides  greater details around the hardware capabilities of specific adapters.  In the example below, lshw shows a single Ethernet interface with the  logical name of *eth0* along with bus information, driver details and all supported capabilities.

```
sudo lshw -class network
  *-network
       description: Ethernet interface
       product: MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s]
       vendor: Mellanox Technologies
       physical id: 0
       bus info: pci@0004:01:00.0
       logical name: eth4
       version: b0
       serial: e4:1d:2d:67:83:56
       slot: U78CB.001.WZS09KB-P1-C6-T1
       size: 10Gbit/s
       capacity: 10Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm vpd msix pciexpress bus_master cap_list ethernet physical fibre 10000bt-fd
       configuration: autonegotiation=off broadcast=yes driver=mlx4_en driverversion=4.0-0 duplex=full firmware=2.9.1326 ip=192.168.1.1 latency=0 link=yes multicast=yes port=fibre speed=10Gbit/s
       resources: iomemory:24000-23fff irq:481 memory:3fe200000000-3fe2000fffff memory:240000000000-240007ffffff
```

### Ethernet Interface Logical Names

Interface logical names can also be configured via a netplan  configuration. If you would like control which interface receives a  particular logical name use the *match* and *set-name*  keys. The match key is used to find an adapter based on some criteria  like MAC address, driver, etc. Then the set-name key can be used to  change the device to the desired logial name.

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth_lan0:
      dhcp4: true
      match:
        macaddress: 00:11:22:33:44:55
      set-name: eth_lan0
```

### Ethernet Interface Settings

ethtool is a program that displays and changes Ethernet card settings such as auto-negotiation, port speed, duplex mode, and Wake-on-LAN. The following is an example of how to view supported features and  configured settings of an Ethernet interface.

```
sudo ethtool eth4
Settings for eth4:
    Supported ports: [ FIBRE ]
    Supported link modes:   10000baseT/Full
    Supported pause frame use: No
    Supports auto-negotiation: No
    Supported FEC modes: Not reported
    Advertised link modes:  10000baseT/Full
    Advertised pause frame use: No
    Advertised auto-negotiation: No
    Advertised FEC modes: Not reported
    Speed: 10000Mb/s
    Duplex: Full
    Port: FIBRE
    PHYAD: 0
    Transceiver: internal
    Auto-negotiation: off
    Supports Wake-on: d
    Wake-on: d
    Current message level: 0x00000014 (20)
                   link ifdown
    Link detected: yes
```

## IP Addressing

The following section describes the process of configuring your  systems IP address and default gateway needed for communicating on a  local area network and the Internet.

### Temporary IP Address Assignment

For temporary network configurations, you can use the ip command  which is also found on most other GNU/Linux operating systems. The ip  command allows you to configure settings which take effect immediately,  however they are not persistent and will be lost after a reboot.

To temporarily configure an IP address, you can use the ip command in the following manner. Modify the IP address and subnet mask to match  your network requirements.

```
sudo ip addr add 10.102.66.200/24 dev enp0s25
```

The ip can then be used to set the link up or down.

```
ip link set dev enp0s25 up
ip link set dev enp0s25 down
```

To verify the IP address configuration of enp0s25, you can use the ip command in the following manner.

```
ip address show dev enp0s25
10: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:e2:52:42 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.102.66.200/24 brd 10.102.66.255 scope global dynamic eth0
       valid_lft 2857sec preferred_lft 2857sec
    inet6 fe80::216:3eff:fee2:5242/64 scope link
       valid_lft forever preferred_lft forever6
```

To configure a default gateway, you can use the ip command in the  following manner. Modify the default gateway address to match your  network requirements.

```
sudo ip route add default via 10.102.66.1
```

To verify your default gateway configuration, you can use the ip command in the following manner.

```
ip route show
default via 10.102.66.1 dev eth0 proto dhcp src 10.102.66.200 metric 100
10.102.66.0/24 dev eth0 proto kernel scope link src 10.102.66.200
10.102.66.1 dev eth0 proto dhcp scope link src 10.102.66.200 metric 100 
```

If you require DNS for your temporary network configuration, you can add DNS server IP addresses in the file `/etc/resolv.conf`. In general, editing `/etc/resolv.conf` directly is not recommanded, but this is a temporary and non-persistent configuration. The example below shows how to enter two DNS servers to `/etc/resolv.conf`, which should be changed to servers appropriate for your network. A more lengthy description of the proper persistent way to do DNS client  configuration is in a following section.

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

If you no longer need this configuration and wish to purge all IP  configuration from an interface, you can use the ip command with the  flush option as shown below.

```
ip addr flush eth0
```

> **Note**
>
> Flushing the IP configuration using the ip command does not clear the contents of `/etc/resolv.conf`. You must remove or modify those entries manually, or re-boot which should also cause `/etc/resolv.conf`, which is a symlink to `/run/systemd/resolve/stub-resolv.conf`, to be re-written.

### Dynamic IP Address Assignment (DHCP Client)

To configure your server to use DHCP for dynamic address assignment, create a netplan configuration in the file `/etc/netplan/99_config.yaml`. The example below assumes you are configuring your first Ethernet interface identified as *enp3s0*.

```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true
```

The configuration can then be applied using the netplan command.

```
sudo netplan apply
```

### Static IP Address Assignment

To configure your system to use static address assignment, create a netplan configuration in the file `/etc/netplan/99_config.yaml`. The example below assumes you are configuring your first Ethernet interface identified as *eth0*. Change the *addresses*, *gateway4*, and *nameservers* values to meet the requirements of your network.

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.10.10.2/24
      gateway4: 10.10.10.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [10.10.10.1, 1.1.1.1]
```

The configuration can then be applied using the netplan command.

```
sudo netplan apply
```

### Loopback Interface

The loopback interface is identified by the system as *lo* and has a default IP address of 127.0.0.1. It can be viewed using the ip command.

```
ip address show lo
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
```

## Name Resolution

Name resolution as it relates to IP networking is the process of  mapping IP addresses to hostnames, making it easier to identify  resources on a network. The following section will explain how to  properly configure your system for name resolution using DNS and static  hostname records.

### DNS Client Configuration

Traditionally, the file `/etc/resolv.conf` was a static  configuration file that rarely needed to be changed or automatically  changed via DCHP client hooks. Systemd-resolved handles name server  configuration, and it should be interacted with through the `systemd-resolve` command. Netplan configures systemd-resolved to generate a list of nameservers and domains to put in `/etc/resolv.conf`, which is a symlink:

```
/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

To configure the resolver, add the IP addresses of the nameservers  that are appropriate for your network to the netplan configuration file. You can also add an optional DNS suffix search-lists to match your  network domain names. The resulting file might look like the following:

```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      addresses:
        - 192.168.0.100/24
      gateway4: 192.168.0.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [1.1.1.1, 8.8.8.8, 4.4.4.4]
```

The *search* option can also be used with multiple domain  names so that DNS queries will be appended in the order in which they  are entered. For example, your network may have multiple sub-domains to  search; a parent domain of *`example.com`*, and two sub-domains, *`sales.example.com`* and *`dev.example.com`*.

If you have multiple domains you wish to search, your configuration might look like the following:

```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      addresses:
        - 192.168.0.100/24
      gateway4: 192.168.0.1
      nameservers:
          search: [example.com, sales.example.com, dev.example.com]
          addresses: [1.1.1.1, 8.8.8.8, 4.4.4.4]
```

If you try to ping a host with the name of *server1*, your system will automatically query DNS for its Fully Qualified Domain Name (FQDN) in the following order:

1. `server1.example.com`
2. `server1.sales.example.com`
3. `server1.dev.example.com`

If no matches are found, the DNS server will provide a result of *notfound* and the DNS query will fail.

### Static Hostnames

Static hostnames are locally defined hostname-to-IP mappings located in the file `/etc/hosts`. Entries in the `hosts` file will have precedence over DNS by default. This means that if your  system tries to resolve a hostname and it matches an entry in  /etc/hosts, it will not attempt to look up the record in DNS. In some  configurations, especially when Internet access is not required, servers that communicate with a limited number of resources can be conveniently set to use static hostnames instead of DNS.

The following is an example of a `hosts` file where a  number of local servers have been identified by simple hostnames,  aliases and their equivalent Fully Qualified Domain Names (FQDN’s).

```
127.0.0.1   localhost
127.0.1.1   ubuntu-server
10.0.0.11   server1 server1.example.com vpn
10.0.0.12   server2 server2.example.com mail
10.0.0.13   server3 server3.example.com www
10.0.0.14   server4 server4.example.com file
```

> **Note**
>
> In the above example, notice that each of the servers have been given aliases in addition to their proper names and FQDN’s. *Server1* has been mapped to the name *vpn*, *server2* is referred to as *mail*, *server3* as *www*, and *server4* as *file*.

### Name Service Switch Configuration

The order in which your system selects a method of resolving  hostnames to IP addresses is controlled by the Name Service Switch (NSS) configuration file `/etc/nsswitch.conf`. As mentioned in the previous section, typically static hostnames defined in the systems `/etc/hosts` file have precedence over names resolved from DNS. The following is an  example of the line responsible for this order of hostname lookups in  the file `/etc/nsswitch.conf`.

```
hosts:          files mdns4_minimal [NOTFOUND=return] dns mdns4
```

- **files** first tries to resolve static hostnames located in `/etc/hosts`.
- **mdns4_minimal** attempts to resolve the name using Multicast DNS.
- **[NOTFOUND=return]** means that any response of *notfound* by the preceding *mdns4_minimal* process should be treated as authoritative and that the system should not try to continue hunting for an answer.
- **dns** represents a legacy unicast DNS query.
- **mdns4** represents a Multicast DNS query.

To modify the order of the above mentioned name resolution methods, you can simply change the *hosts:* string to the value of your choosing. For example, if you prefer to use legacy Unicast DNS versus Multicast DNS, you can change the string in `/etc/nsswitch.conf` as shown below.

```
hosts:          files dns [NOTFOUND=return] mdns4_minimal mdns4
```

## Bridging

Bridging multiple interfaces is a more advanced configuration, but is very useful in multiple scenarios. One scenario is setting up a bridge  with multiple network interfaces, then using a firewall to filter  traffic between two network segments. Another scenario is using bridge  on a system with one interface to allow virtual machines direct access  to the outside network. The following example covers the latter  scenario.

Configure the bridge by editing your netplan configuration found in `/etc/netplan/`:

```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: no
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - enp3s0
```

> **Note**
>
> Enter the appropriate values for your physical interface and network.

Now apply the configuration to enable the bridge:

```
sudo netplan apply
```

The new bridge interface should now be up and running. The brctl  provides useful information about the state of the bridge, controls  which interfaces are part of the bridge, etc. See `man brctl` for more information.

## networkd-dispatcher for pre-up, post-up, etc. hook scripts

Users of the former  `ifupdown` may be familiar with using hook scripts (e.g pre-up, post-up, etc.) in their interfaces file. [Netplan configuration](https://netplan.io/reference/) does not currently support hook scripts in its configuration definition.

Instead to achieve this functionality with the `networkd renderer`, users can use [networkd-dispatcher](http://manpages.ubuntu.com/manpages/focal/man8/networkd-dispatcher.8.html). The package provides users and packages hook points when specific  network states are reached to aid in reacting to network state.

Note: If not on Ubuntu Server, but Desktop the network is driven by Network Manager - in that case you’d need [NM Dispatcher scripts](https://developer.gnome.org/NetworkManager/unstable/NetworkManager.html) instead.

The [Netplan FAQ has a great table](https://netplan.io/faq/#use-pre-up%2C-post-up%2C-etc.-hook-scripts) that compares event timings between `ifupdown`/`systemd-networkd`/`network-manager`

It is important to be aware that those hooks run asychronous; that is they will not block transition into another state.

The [Netplan FAQ also has an example](https://netplan.io/faq/#example-for-an-ifupdown-legacy-hook-for-post-up%2Fpost-down-states) on converting an old `ifupdown` hook to `networkd-dispatcher`.

## Resources

- The [Ubuntu Wiki Network page](https://help.ubuntu.com/community/Network) has links to articles covering more advanced network configuration.
- The [netplan website](https://netplan.io) has additional examples and documentation.
- The [netplan man page](https://manpages.ubuntu.com/manpages/focal/man5/netplan.5.html) has more information on netplan.
- The [systemd-resolve man page](https://manpages.ubuntu.com/manpages/focal/man1/systemd-resolve.1.html) has details on systemd-resolve command.
- The [systemd-resolved man page](https://manpages.ubuntu.com/manpages/focal/man8/systemd-resolved.8.html) has more information on systemd-resolved service.
- For more information on *bridging* see the [netplan.io examples page](https://netplan.io/examples) and the Linux Foundation’s [Networking-Bridge](http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge) page.

# Dynamic Host Configuration Protocol (DHCP)

The Dynamic Host Configuration Protocol (DHCP) is a network service  that enables host computers to be automatically assigned settings from a server as opposed to manually configuring each network host. Computers  configured to be DHCP clients have no control over the settings they  receive from the DHCP server, and the configuration is transparent to  the computer’s user.

The most common settings provided by a DHCP server to DHCP clients include:

- IP address and netmask
- IP address of the default-gateway to use
- IP adresses of the DNS servers to use

However, a DHCP server can also supply configuration properties such as:

- Host Name
- Domain Name
- Time Server
- Print Server

The advantage of using DHCP is that changes to the network, for  example a change in the address of the DNS server, need only be changed  at the DHCP server, and all network hosts will be reconfigured the next  time their DHCP clients poll the DHCP server. As an added advantage, it  is also easier to integrate new computers into the network, as there is  no need to check for the availability of an IP address. Conflicts in IP  address allocation are also reduced.

A DHCP server can provide configuration settings using the following methods:

- Manual allocation (MAC address)
   This method entails using DHCP to identify the unique hardware address  of each network card connected to the network and then continually  supplying a constant configuration each time the DHCP client makes a  request to the DHCP server using that network device. This ensures that a particular address is assigned automatically to that network card,  based on it’s MAC address.
- Dynamic allocation (address pool)
   In this method, the DHCP server will assign an IP address from a pool of addresses (sometimes also called a range or scope) for a period of time or lease, that is configured on the server or until the client informs  the server that it doesn’t need the address anymore. This way, the  clients will be receiving their configuration properties dynamically and on a “first come, first served” basis. When a DHCP client is no longer  on the network for a specified period, the configuration is expired and  released back to the address pool for use by other DHCP Clients. This  way, an address can be leased or used for a period of time. After this  period, the client has to renegociate the lease with the server to  maintain use of the address.
- Automatic allocation
   Using this method, the DHCP automatically assigns an IP address  permanently to a device, selecting it from a pool of available  addresses. Usually DHCP is used to assign a temporary address to a  client, but a DHCP server can allow an infinite lease time.

The last two methods can be considered “automatic” because in each  case the DHCP server assigns an address with no extra intervention  needed. The only difference between them is in how long the IP address  is leased, in other words whether a client’s address varies over time.  The DHCP server Ubuntu makes available is dhcpd (dynamic host  configuration protocol daemon), which is easy to install and configure  and will be automatically started at system boot.

## Installation

At a terminal prompt, enter the following command to install dhcpd:

```
sudo apt install isc-dhcp-server
```

NOTE: dhcpd’s messages are being sent to syslog. Look there for diagnostics messages.

## Configuration

You will probably need to change the default configuration by editing `/etc/dhcp/dhcpd.conf` to suit your needs and particular configuration.

Most commonly, what you want to do is assign an IP address randomly. This can be done with settings as follows:

```
# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.1.0 netmask 255.255.255.0 {
 range 192.168.1.150 192.168.1.200;
 option routers 192.168.1.254;
 option domain-name-servers 192.168.1.1, 192.168.1.2;
 option domain-name "mydomain.example";
}
```

This will result in the DHCP server giving clients an IP address from the range 192.168.1.150-192.168.1.200. It will lease an IP address for  600 seconds if the client doesn’t ask for a specific time frame.  Otherwise the maximum (allowed) lease will be 7200 seconds. The server  will also “advise” the client to use 192.168.1.254 as the  default-gateway and 192.168.1.1 and 192.168.1.2 as its DNS servers.

You also may need to edit `/etc/default/isc-dhcp-server` to specify the interfaces dhcpd should listen to.

```
INTERFACESv4="eth4"
```

After changing the config files you have to restart the dhcpd service:

```
sudo systemctl restart isc-dhcp-server.service
```

## References

- The [dhcp3-server Ubuntu Wiki](https://help.ubuntu.com/community/dhcp3-server) page has more information.
- For more `/etc/dhcp/dhcpd.conf` options see the [dhcpd.conf man page](https://manpages.ubuntu.com/manpages/focal/en/man5/dhcpd.conf.5.html).
- [ISC dhcp-server](https://www.isc.org/software/dhcp)

# Time Synchronization

NTP is a TCP/IP protocol for synchronizing time over a network.  Basically a client requests the current time from a server, and uses it  to set its own clock.

Behind this simple description, there is a lot of complexity - there  are tiers of NTP servers, with the tier one NTP servers connected to  atomic clocks, and tier two and three servers spreading the load of  actually handling requests across the Internet. Also the client software is a lot more complex than you might think - it has to factor out  communication delays, and adjust the time in a way that does not upset  all the other processes that run on the server. But luckily all that  complexity is hidden from you!

Ubuntu by default uses *timedatectl / timesyncd* to synchronize time and users can optionally use chrony to serve the Network Time Protocol.

## Synchronizing your systems time

Since Ubuntu 16.04 *timedatectl / timesyncd* (which are part of systemd) replace most of *ntpdate / ntp*.

timesyncd is available by default and replaces not only ntpdate, but  also the client portion of chrony (or formerly ntpd). So on top of the  one-shot action that ntpdate provided on boot and network activation,  now timesyncd by default regularly checks and keeps your local time in  sync. It also stores time updates locally, so that after reboots  monotonically advances if applicable.

If chrony is installed timedatectl steps back to let chrony do the  time keeping. That shall ensure that no two time syncing services are  fighting. While no more recommended to be used, this still also applies  to ntpd being installed to retain any kind of old behavior/config that  you had through an upgrade. But it also implies that on an upgrade from a former release ntp/ntpdate might still be installed and therefore  renders the new systemd based services disabled.

ntpdate is considered deprecated in favor of timedatectl (or chrony)  and thereby no more installed by default. timesyncd will generally do  the right thing keeping your time in sync, and chrony will help with  more complex cases. But if you had one of a few known special ntpdate  use cases, consider the following:

- If you require a one-shot sync use: `chronyd -q`
- If you require a one-shot time check, without setting the time use: `chronyd -Q`

## Configuring timedatectl and timesyncd

The current status of time and time configuration via timedatectl and timesyncd can be checked with `timedatectl status`.

```auto
$ timedatectl status
                       Local time: Fr 2018-02-23 08:47:13 UTC
                   Universal time: Fr 2018-02-23 08:47:13 UTC
                         RTC time: Fr 2018-02-23 08:47:13
                        Time zone: Etc/UTC (UTC, +0000)
        System clock synchronized: yes
 systemd-timesyncd.service active: yes
                  RTC in local TZ: no
```

If chrony is running it will automatically switch to:

```auto
[...]
 systemd-timesyncd.service active: no 
```

Via timedatectl an admin can control the timezone, how the system  clock should relate to the hwclock and if permanent synronization should be enabled or not. See `man timedatectl` for more details.

timesyncd itself is still a normal service, so you can check its status also more in detail via.

```
$ systemctl status systemd-timesyncd
  systemd-timesyncd.service - Network Time Synchronization
   Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2018-02-23 08:55:46 UTC; 10s ago
     Docs: man:systemd-timesyncd.service(8)
 Main PID: 3744 (systemd-timesyn)
   Status: "Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com)."
    Tasks: 2 (limit: 4915)
   CGroup: /system.slice/systemd-timesyncd.service
           |-3744 /lib/systemd/systemd-timesyncd

Feb 23 08:55:46 bionic-test systemd[1]: Starting Network Time Synchronization...
Feb 23 08:55:46 bionic-test systemd[1]: Started Network Time Synchronization.
Feb 23 08:55:46 bionic-test systemd-timesyncd[3744]: Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com).
```

The nameserver to fetch time for timedatectl and timesyncd from can be specified in `/etc/systemd/timesyncd.conf` and additional config files can be stored in `/etc/systemd/timesyncd.conf.d/`. The entries for NTP= and FallbackNTP= are space separated lists. See `man timesyncd.conf` for more.

## Serve the Network Time Protocol

If in addition to synchronizing your system you also want to serve  NTP information you need an NTP server. There are several options with  chrony, ntpd and open-ntp. The recommended solution is chrony.

## chrony(d)

The NTP daemon chronyd calculates the drift and offset of your system clock and continuously adjusts it, so there are no large corrections  that could lead to inconsistent logs for instance. The cost is a little  processing power and memory, but for a modern server this is usually  negligible.

## Installation

To install chrony, from a terminal prompt enter:

```
sudo apt install chrony
```

This will provide two binaries:

- chronyd - the actual daemon to sync and serve via the NTP protocol
- chronyc - command-line interface for chrony daemon

## Chronyd Configuration

Edit `/etc/chrony/chrony.conf` to add/remove server lines. By default these servers are configured:

```
# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst
```

See `man chrony.conf` for more details on the configuration options. After changing the any of the config file you have to restart chrony:

```
sudo systemctl restart chrony.service
```

Of the pool `2.ubuntu.pool.ntp.org` as well as `ntp.ubuntu.com` also support ipv6 if needed. If one needs to force ipv6 there also is `ipv6.ntp.ubuntu.com` which is not configured by default.

## Serving the NTP Protocol

You can install chrony (above) and configure special Hardware (below) for a local synchronization
 and as-installed that is the default to stay on the secure and conservative side. But if you want to *serve* NTP you need adapt your configuration.

To enable serving the NTP protocol you’ll need at least to set the `allow` rule to which controls which clients/networks you want chrony to serve NTP to.

An example would be

```auto
allow 1.2.3.4
```

See the section “NTP server” in the [man page](http://manpages.ubuntu.com/manpages/focal/man5/chrony.conf.5.html) for more details on how you can control and restrict access to your NTP server.

## View status

Use chronyc to see query the status of the chrony daemon. For example to get an overview of the currently available and selected time  sources.

```
chronyc sources

MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ gamma.rueckgr.at              2   8   377   135  -1048us[-1048us] +/-   29ms
^- 2b.ncomputers.org             2   8   377   204  -1141us[-1124us] +/-   50ms
^+ www.kashra.com                2   8   377   139  +3483us[+3483us] +/-   18ms
^+ stratum2-4.NTP.TechFak.U>     2   8   377   143  -2090us[-2073us] +/-   19ms
^- zepto.mcl.gg                  2   7   377     9   -774us[ -774us] +/-   29ms
^- mirrorhost.pw                 2   7   377    78   -660us[ -660us] +/-   53ms
^- atto.mcl.gg                   2   7   377     8   -823us[ -823us] +/-   50ms
^- static.140.107.46.78.cli>     2   8   377     9  -1503us[-1503us] +/-   45ms
^- 4.53.160.75                   2   8   377   137    -11ms[  -11ms] +/-  117ms
^- 37.44.185.42                  3   7   377    10  -3274us[-3274us] +/-   70ms
^- bagnikita.com                 2   7   377    74  +3131us[+3131us] +/-   71ms
^- europa.ellipse.net            2   8   377   204   -790us[ -773us] +/-   97ms
^- tethys.hot-chilli.net         2   8   377   141   -797us[ -797us] +/-   59ms
^- 66-232-97-8.static.hvvc.>     2   7   377   206  +1669us[+1686us] +/-  133ms
^+ 85.199.214.102                1   8   377   205   +175us[ +192us] +/-   12ms
^* 46-243-26-34.tangos.nl        1   8   377   141   -123us[ -106us] +/-   10ms
^- pugot.canonical.com           2   8   377    21    -95us[  -95us] +/-   57ms
^- alphyn.canonical.com          2   6   377    23  -1569us[-1569us] +/-   79ms
^- golem.canonical.com           2   7   377    92  -1018us[-1018us] +/-   31ms
^- chilipepper.canonical.com     2   8   377    21  -1106us[-1106us] +/-   27ms

chronyc sourcestats

210 Number of sources = 20
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
gamma.rueckgr.at           25  15   32m     -0.007      0.142   -878us   106us
2b.ncomputers.org          26  16   35m     -0.132      0.283  -1169us   256us
www.kashra.com             25  15   32m     -0.092      0.259  +3426us   195us
stratum2-4.NTP.TechFak.U>  25  14   32m     -0.018      0.130  -2056us    96us
zepto.mcl.gg               13  11   21m     +0.148      0.196   -683us    66us
mirrorhost.pw               6   5   645     +0.117      0.445   -591us    19us
atto.mcl.gg                21  13   25m     -0.069      0.199   -904us   103us
static.140.107.46.78.cli>  25  18   34m     -0.005      0.094  -1526us    78us
4.53.160.75                25  10   32m     +0.412      0.110    -11ms    84us
37.44.185.42               24  12   30m     -0.983      0.173  -3718us   122us
bagnikita.com              17   7   31m     -0.132      0.217  +3527us   139us
europa.ellipse.net         26  15   35m     +0.038      0.553   -473us   424us
tethys.hot-chilli.net      25  11   32m     -0.094      0.110   -864us    88us
66-232-97-8.static.hvvc.>  20  11   35m     -0.116      0.165  +1561us   109us
85.199.214.102             26  11   35m     -0.054      0.390   +129us   343us
46-243-26-34.tangos.nl     25  16   32m     +0.129      0.297   -307us   198us
pugot.canonical.com        25  14   34m     -0.271      0.176   -143us   135us
alphyn.canonical.com       17  11  1100     -0.087      0.360  -1749us   114us
golem.canonical.com        23  12   30m     +0.057      0.370   -988us   229us
chilipepper.canonical.com  25  18   34m     -0.084      0.224  -1116us   169us
```

Certain chronyc commands are privileged and can not be run via the network without explicitly allowing them. See section *Command and monitoring access* in `man chrony.conf` for more details. A local admin can use sudo as usually as this will grant him access to the local admin socket `/var/run/chrony/chronyd.sock`.

## PPS Support

Chrony supports various PPS types natively. It can use kernel PPS API as well as PTP hardware clock. Most general GPS receivers can be  leveraged via GPSD. The latter (and potentially more) can be accessed  via *SHM* or via a *socket* (recommended). All of the  above can be used to augment chrony with additional high quality time  sources for better accuracy, jitter, drift, longer-or-short term  accuracy (Usually each kind of clock type is good at one of those, but  non-perfect at the others). For more details on configuration see some  of the external PPS/GPSD resource listed below.

Note: at the release of 20.04 there was a bug which until fixed you might want to add this [content](https://bugs.launchpad.net/ubuntu/+source/gpsd/+bug/1872175/comments/21)  to your `/etc/apparmor.d/local/usr.sbin.gpsd`.

### Example configuration for GPSD to feed Chrony

For the setup you need
 `$ sudo apt install gpsd chrony`

But you will want to test/debug your setup and especially the GPS reception, therefore also install
 `$ sudo apt install pps-tools gpsd-clients`

GPS devices usually will communicate via serial interfaces, yet the  most common type these days are USB GPS devices which have a serial  converter behind USB. If you want to use this for PPS please be aware  that the majority does not signal PPS via USB. Check the [GPSD hardware](https://gpsd.gitlab.io/gpsd/hardware.html) list for details. The examples below were run with a Navisys GR701-W.

When plugging in such a device (or at boot time) `dmesg` should report serial connection of some sorts, example:

```
[   52.442199] usb 1-1.1: new full-speed USB device number 3 using xhci_hcd
[   52.546639] usb 1-1.1: New USB device found, idVendor=067b, idProduct=2303, bcdDevice= 4.00
[   52.546654] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   52.546665] usb 1-1.1: Product: USB-Serial Controller D
[   52.546675] usb 1-1.1: Manufacturer: Prolific Technology Inc. 
[   52.602103] usbcore: registered new interface driver usbserial_generic
[   52.602244] usbserial: USB Serial support registered for generic
[   52.609471] usbcore: registered new interface driver pl2303
[   52.609503] usbserial: USB Serial support registered for pl2303
[   52.609564] pl2303 1-1.1:1.0: pl2303 converter detected
[   52.618366] usb 1-1.1: pl2303 converter now attached to ttyUSB0
```

We see above that it appeared as `ttyUSB0`. To later on have `chrony` accept being feeded time information by that we have to set it up in `/etc/chrony/chrony.conf` (Please replace `USB0` to whatever applies to your setup):

```
refclock SHM 0 refid GPS precision 1e-1 offset 0.9999 delay 0.2
refclock SOCK /var/run/chrony.ttyUSB0.sock refid PPS
```

Then restart `chrony` to make the socket available and waiting.
 `sudo systemctl restart chrony`

Next one needs to tell `gpsd` which device to manager, therefore in `/etc/default/gpsd` we set:
 `DEVICES="/dev/ttyUSB0"`

Furthermore the *default* use-case of `gpsd` is, well for *gps position tracking*. Therefore it will normally not consume any cpu since it is not running the service but waiting on a *socket* for clients.  Furthermore the client will then tell `gpsd` what it requests and `gpsd` will only do that.
 For the use case of gpsd as PPS-providing-daemon you want to set the option to:

- immediately start even without a client connected, this can be set in 

  ```
  GPSD_OPTIONS
  ```

   of 

  ```
  /etc/default/gpsd
  ```

  :

  - `GPSD_OPTIONS="-n"`

- enable the service itself and not wait for a client to reach the socket in the future:

  - `sudo systemctl enable /lib/systemd/system/gpsd.service`

Restarting `gpsd` will now initialize the PPS from GPS and in `dmesg` you will see

```
 pps_ldisc: PPS line discipline registered
 pps pps0: new PPS source usbserial0
 pps pps0: source "/dev/ttyUSB0" added
```

In case you have multiple PPS the tool `ppsfind` might be useful to identify which PPS belongs to which GPS. You could check that with:

```
$ sudo ppsfind /dev/ttyUSB0 
pps0: name=usbserial0 path=/dev/ttyUSB0
```

To get any further you need your GPS to get a lock.
 Tools like `cgps` or `gpsmon` need to report a 3D Fix for the data being any good.
 Then you’d want to check to really have PPS data reported on that with `ppstest`

```
$ cgps
...
│ Status:         3D FIX (7 secs) ...
```

Next one might want to ensure that the pps device really submits PPS data, to do so run `ppstest`:

```
$ sudo ppstest /dev/pps0 
trying PPS source "/dev/pps0"
found PPS source "/dev/pps0"
ok, found 1 source(s), now start fetching data...
source 0 - assert 1588140739.099526246, sequence: 69 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140740.999786664, sequence: 71
source 0 - assert 1588140741.099792447, sequence: 71 - clear  1588140740.999786664, sequence: 71
```

Ok, `gpsd` is now running, the GPS reception has found a fix and this is fed into `chrony`.
 Now lets check that from the point of view of `chrony`.

Initially (e.g. before `gpsd` has started or before it has a lock) those will be new and “untrusted” sources marked with an “?”.  If your devices stay in the “?” state and won’t leave it even after  quite some time then `gpsd` seems not to feed any data to `chrony` and you’d need to debug why.

```
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#? PPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
```

Over time chrony will classify them as good or bad.
 In the example case the raw GPS had too much deviation but PPS is good.

```
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS 0 4 177 24 -876ms[ -876ms] +/- 200ms
#- PPS 0 4 177 21 +916us[ +916us] +/- 63us
^- chilipepper.canonical.com 2 6 37 53 +33us[ +33us] +/- 33ms
```

And finally after a while it used the hardware PPS input as it was better:

```
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS                           0   4   377    20   -884ms[ -884ms] +/-  200ms
#* PPS                           0   4   377    18  +6677ns[  +52us] +/-   58us
^- alphyn.canonical.com          2   6   377    20  -1303us[-1258us] +/-  114ms
```

The PPS might also be ok but used in a combined way with e.g. the selected server.
 See `man chronyc` for more details about how all these combinations will look like.

```
chronyc> sources
210 Number of sources = 11
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#+ PPS                           0   4   377    22   +154us[ +154us] +/- 8561us
^* chilipepper.canonical.com     2   6   377    50   -353us[ -300us] +/-   44ms
```

And if you wonder if your shm based GPS data is any good, you can check for that as well.
 First of all chrony will not only tell you if it classified it as good or bad. Via `sourcestats` you can also check the details

```
chronyc> sourcestats
210 Number of sources = 10
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
GPS                        20   9   302     +1.993     11.501   -868ms  1208us
PPS                         6   3    78     +0.324      5.009  +3365ns    41us
golem.canonical.com        15  10   783     +0.859      0.509   -750us   108us
```

You can also track the raw data that gpsd or other ntpd compliant refclocks are sending via shared memory by using `ntpshmmon`:

```
$ sudo ntpshmmon -o  
ntpshmmon: version 3.20
#      Name          Offset       Clock                 Real                 L Prc
sample NTP1          0.000223854  1588265805.000223854  1588265805.000000000 0 -10
sample NTP0          0.125691783  1588265805.125999851  1588265805.000308068 0 -20
sample NTP1          0.000349341  1588265806.000349341  1588265806.000000000 0 -10
sample NTP0          0.130326636  1588265806.130634945  1588265806.000308309 0 -20
sample NTP1          0.000485216  1588265807.000485216  1588265807.000000000 0 -10
```

## References

- [Chrony FAQ](https://chrony.tuxfamily.org/faq.html)
- [ntp.org: home of the Network Time Protocol project](http://www.ntp.org/)
- [pool.ntp.org: project of virtual cluster of timeservers](http://www.pool.ntp.org/)
- [Freedesktop.org info on timedatectl](https://www.freedesktop.org/software/systemd/man/timedatectl.html)
- [Freedesktop.org info on systemd-timesyncd service](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html#)
- [Feeding chrony from GPSD](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)
- See the [Ubuntu Time](https://help.ubuntu.com/community/UbuntuTime) wiki page for more information.

# Data Plane Development Kit

The DPDK is a set of libraries and drivers for fast packet processing and runs mostly in Linux userland. It is a set of libraries that  provide the so called “Environment Abstraction Layer” (EAL). The EAL  hides the details of the environment and provides a standard programming interface. Common use cases are around special solutions for instance  network function virtualization and advanced high-throughput network  switching. The DPDK uses a run-to-completion model for fast data plane  performance and accesses devices via polling to eliminate the latency of interrupt processing at the tradeoff of higher cpu consumption. It was  designed to run on any processors. The first supported CPU was Intel x86 and it is now extended to IBM PPC64 and ARM64.

Ubuntu further provides some infrastructure to ease DPDKs usability.

## Prerequisites

This package is currently compiled for the lowest possible CPU requirements allowed by upstream. Starting with [DPDK 17.08](https://git.dpdk.org/dpdk/commit/?id=f27769f796a0639368117ce22fb124b6030dbf73) that means it requires at least SSE4_2 and anything else activated by -march=corei7 (in gcc) to be supported by the CPU.

The list of upstream DPDK supported network cards can be found at [supported NICs](http://dpdk.org/doc/nics). But a lot of those are disabled by default in the upstream Project as  they are not yet in a stable state. The subset of network cards that  DPDK has enabled in the package as available in Ubuntu 16.04 is:

DPDK has “userspace” drivers for the cards called PMDs.
 The packages for these follow the pattern of `librte-pmd-<type>-<version>`. Therefore the example for an intel e1000 in 18.11 would be `librte-pmd-e1000-18.11`.

The more commonly used, tested and fully supported drivers are installed as dependencies of `dpdk`. But there are way more in [universe](https://help.ubuntu.com/community/Repositories/Ubuntu#The_Four_Main_Repositories) that follow the same naming pattern.

## Unassigning the default Kernel drivers

Cards have to be unassigned from their kernel driver and instead be assigned to `uio_pci_generic` of `vfio-pci`. `uio_pci_generic` is older and usually getting to work more easily, but also has less features and isolation.

The newer vfio-pci requires that you activate the following kernel parameters to enable iommu.

```auto
iommu=pt intel_iommu=on          
```

Or on AMD

```auto
amd_iommu=pt
```

On top for vfio-pci you then have to configure and assign the iommu  groups accordingly. That is mostly done in Firmware and by HW layout,  you can check the group assignment the kernel probed in `/sys/kernel/iommu_groups/`.

> Note: virtio is special, dpdk can directly work on those devices  without vfio_pci/uio_pci_generic. But to avoid issues by kernel and DPDK managing the device you still have to unassign the kernel driver.

Manual configuration and status checks can be done via sysfs or with the tool `dpdk_nic_bind`

```
dpdk_nic_bind.py --help
```

## Usage:

```auto
dpdk-devbind.py [options] DEVICE1 DEVICE2 ....

where DEVICE1, DEVICE2 etc, are specified via PCI "domain:bus:slot.func" syntax
or "bus:slot.func" syntax. For devices bound to Linux kernel drivers, they may
also be referred to by Linux interface name e.g. eth0, eth1, em0, em1, etc.

Options:
--help, --usage:
    Display usage information and quit

-s, --status:
    Print the current status of all known network, crypto, event
    and mempool devices.
    For each device, it displays the PCI domain, bus, slot and function,
    along with a text description of the device. Depending upon whether the
    device is being used by a kernel driver, the igb_uio driver, or no
    driver, other relevant information will be displayed:
    * the Linux interface name e.g. if=eth0
    * the driver being used e.g. drv=igb_uio
    * any suitable drivers not currently using that device
        e.g. unused=igb_uio
    NOTE: if this flag is passed along with a bind/unbind option, the
    status display will always occur after the other operations have taken
    place.

--status-dev:
    Print the status of given device group. Supported device groups are:
    "net", "crypto", "event", "mempool" and "compress"

-b driver, --bind=driver:
    Select the driver to use or "none" to unbind the device

-u, --unbind:
    Unbind a device (Equivalent to "-b none")

--force:
    By default, network devices which are used by Linux - as indicated by
    having routes in the routing table - cannot be modified. Using the
    --force flag overrides this behavior, allowing active links to be
    forcibly unbound.
    WARNING: This can lead to loss of network connection and should be used
    with caution.

Examples:
---------

To display current device status:
    dpdk-devbind.py --status

To display current network device status:
    dpdk-devbind.py --status-dev net

To bind eth1 from the current driver and move to use igb_uio
    dpdk-devbind.py --bind=igb_uio eth1

To unbind 0000:01:00.0 from using any driver
    dpdk-devbind.py -u 0000:01:00.0

To bind 0000:02:00.0 and 0000:02:00.1 to the ixgbe kernel driver
    dpdk-devbind.py -b ixgbe 02:00.0 02:00.1
```

## DPDK Device configuration



The package *dpdk* provides init scripts that ease  configuration of device assignment and huge pages. It also makes them  persistent across reboots.

The following is an example of the file `/etc/dpdk/interfaces` configuring two ports of a network card. One with `uio_pci_generic` and the other one with `vfio-pci`.

```auto
# <bus>         Currently only "pci" is supported
# <id>          Device ID on the specified bus
# <driver>      Driver to bind against (vfio-pci or uio_pci_generic)
#
# Be aware that the two DPDK compatible drivers uio_pci_generic and vfio-pci are
# part of linux-image-extra-<VERSION> package.
# This package is not always installed by default - for example in cloud-images.
# So please install it in case you run into missing module issues.
#
# <bus> <id>     <driver>
pci 0000:04:00.0 uio_pci_generic
pci 0000:04:00.1 vfio-pci     
```

Cards are identified by their PCI-ID. If you are unsure you might use the tool `dpdk_nic_bind.py` to show the current available devices and the drivers they are assigned to.

```auto
dpdk_nic_bind.py --status

Network devices using DPDK-compatible driver
============================================
0000:04:00.0 'Ethernet Controller 10-Gigabit X540-AT2' drv=uio_pci_generic unused=ixgbe

Network devices using kernel driver
===================================
0000:02:00.0 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth0 drv=tg3 unused=uio_pci_generic *Active*
0000:02:00.1 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth1 drv=tg3 unused=uio_pci_generic
0000:02:00.2 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth2 drv=tg3 unused=uio_pci_generic
0000:02:00.3 'NetXtreme BCM5719 Gigabit Ethernet PCIe' if=eth3 drv=tg3 unused=uio_pci_generic
0000:04:00.1 'Ethernet Controller 10-Gigabit X540-AT2' if=eth5 drv=ixgbe unused=uio_pci_generic

Other network devices
=====================
<none>
```

## DPDK HugePage configuration

DPDK makes heavy use of huge pages to eliminate pressure on the TLB. Therefore hugepages have to be configured in your system.

The *dpdk* package has a config file and scripts that try to ease hugepage configuration for DPDK in the form of `/etc/dpdk/dpdk.conf`. If you have more consumers of hugepages than just DPDK in your system  or very special requirements how your hugepages are going to be set up  you likely want to allocate/control them by yourself. If not this can be a great simplification to get DPDK configured for your needs.

Here an example configuring 1024 Hugepages of 2M each and 4 1G pages.

```auto
NR_2M_PAGES=1024
NR_1G_PAGES=4
          
```

As shown this supports configuring 2M and the larger 1G hugepages (or a mix of both). It will make sure there are proper hugetlbfs  mountpoints for DPDK to find both sizes no matter what your default huge page size is. The config file itself holds more details on certain  corner cases and a few hints if you want to allocate hugepages manually  via a kernel parameter.

It depends on your needs which size you want - 1G pages are certainly more effective regarding TLB pressure. But there were reports of them  fragmenting inside the DPDK memory allocations. Also it can be harder to grab enough free space to set up a certain amount of 1G pages later in  the life-cycle of a system.

## Compile DPDK Applications

Currently there are not a lot consumers of the DPDK library that are  stable and released. OpenVswitch-DPDK being an exception to that (see  below) and more are appearing. But in general it might still happen that you might want to compile an app against the library.

You will often find guides that tell you to fetch the DPDK sources,  build them to your needs and eventually build your application based on  DPDK by setting values RTE_* for the build system. Since Ubuntu provides an already compiled DPDK for you can can skip all that.

DPDK provides a valid [pkg-config](https://people.freedesktop.org/~dbn/pkg-config-guide.html) file
 to simplify setting the proper variables and options.

```auto
sudo apt-get install dpdk-dev libdpdk-dev
gcc testdpdkprog.c $(pkg-config --libs --cflags libdpdk) -o testdpdkprog
```

An example of a complex (autoconfigure) user of pkg-config of DPDK  including fallbacks to older non pkg-config style can be seen in the [OpenVswitch build system](https://github.com/openvswitch/ovs/blob/master/acinclude.m4#L283).

Depending on what you build it might be a good addition to install  all of DPDK build dependencies before the make, which on Ubuntu can be  done automatically with.

```auto
sudo apt-get install build-dep dpdk
```

## DPDK in KVM Guests

If you have no access to DPDK supported network cards you can still  work with DPDK by using its support for virtio. To do so you have to  create guests backed by hugepages (see above).

On top of that there it is required to have at least SSE3. The  default CPU model qemu/libvirt uses is only up to SSE2. So you will have to define a model that passed the proper feature flags (or use  host-passthrough).
 An example can be found in following snippet to your virsh xml (or the equivalent virsh interface you use).

```auto
<cpu mode='host-passthrough'>
```

Also virtio nowadays supports multiqueue which DPDK in turn can  exploit for better speed. To modify a normal virtio definition to have  multiple queues add the following to your interface definition. This is  about enhancing a normal virtio nic to have multiple queues, to later on be consumed e.g. by DPDK in the guest.

```auto
<driver name="vhost" queues="4"/>
```

## Use DPDK

Since DPDK on its own is only (massive) library you most likely might continue to [OpenVswitch-DPDK](https://ubuntu.com/server/docs/openvswitch-dpdk) as an example to put it to use.

## Resources

- [DPDK Documentation](http://dpdk.org/doc)
- [Release Notes matching the version packages in Ubuntu 16.04](http://dpdk.org/doc/guides/rel_notes/release_2_2.html)
- [Linux DPDK User Getting Started](http://dpdk.org/doc/guides/linux_gsg/index.html)
- [EAL Command-line Options](http://dpdk.org/doc/guides/testpmd_app_ug/run_app.html)
- [DPDK Api Documentation](http://dpdk.org/doc/api/)
- [OpenVswitch DPDK installation](https://github.com/openvswitch/ovs/blob/branch-2.5/INSTALL.DPDK.md)
- [Wikipedias definition of DPDK](https://en.wikipedia.org/wiki/Data_Plane_Development_Kit)

## OpenVswitch-DPDK

With DPDK being *just* a library it doesn’t do a lot on its own, so it depends on emerging projects making use of it. One  consumer of the library that already is part of Ubuntu is OpenVswitch  with DPDK support in the package openvswitch-switch-dpdk.

Here an example how to install and configure a basic OpenVswitch using DPDK for later use via libvirt/qemu-kvm.

```auto
sudo apt-get install openvswitch-switch-dpdk
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk
ovs-vsctl set Open_vSwitch . "other_config:dpdk-init=true"
# run on core 0 only
ovs-vsctl set Open_vSwitch . "other_config:dpdk-lcore-mask=0x1"
# Allocate 2G huge pages (not Numa node aware)
ovs-vsctl set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
# limit to one whitelisted device
ovs-vsctl set Open_vSwitch . "other_config:dpdk-extra=--pci-whitelist=0000:04:00.0"
sudo service openvswitch-switch restart
```

Please remember that you have to assign devices to DPDK compatible drivers see above at [Network - DPDK](https://ubuntu.com/server/docs/openvswitch-dpdk#unassigndrivers) before restarting.

Please note that the section *dpdk-alloc-mem=2048* above is  the most basic numa setup for a single socket system. If you have  multiple sockets you might want to define how to split your memory among them. More details about these options are outlined in [OpenVswitch setup](http://docs.openvswitch.org/en/latest/intro/install/dpdk/#setup-ovs).

### Attaching DPDK ports to OpenVswitch

The OpenVswitch you now started supports all port types OpenVswitch  usually does, plus DPDK port types. Here an example how to create a  bridge and - instead of a normal external port - add an external DPDK  port to it. When doing so you can specify the device that will be  associated.

```auto
ovs-vsctl add-br ovsdpdkbr0 -- set bridge ovsdpdkbr0 datapath_type=netdev
ovs-vsctl add-port ovsdpdkbr0 dpdk0 -- set Interface dpdk0 type=dpdk  "options:dpdk-devargs=${OVSDEV_PCIID}"      
```

Further tuning can be applied by setting options:

```
ovs-vsctl set Interface dpdk0 "options:n_rxq=2"
```

## OpenVswitch DPDK to KVM Guests

If you are not building some sort of SDN switch or NFV on top of DPDK it is very likely that you want to forward traffic to KVM guests. The  good news is, that with the new qemu/libvirt/dpdk/openvswitch versions  in Ubuntu this is no more about manually appending commandline string.  This chapter covers a basic configuration how to connect a KVM guest to a OpenVswitch-DPDK instance.

The recommended way to get to a KVM guest is using `vhost_user_client`.
 This will cause OVS-DPDK to create connect to a socket that qemu  created. That way old issues like guest failures on OVS restart are  avoided. Here an example how to add such a port to the bridge you  created above.

```auto
ovs-vsctl add-port ovsdpdkbr0 vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuserclient "options:vhost-server-path=/var/run/vhostuserclient/vhost-user-client-1"
```

This will connect to the specified path that has to be created by a guest listening on it.

To let libvirt/kvm consume this socket and create a guest virtio  network device for it add a snippet like this to your guest definition  as the network definition.

```auto
<interface type='vhostuser'>
<source type='unix'
path='/var/run/vhostuserclient/vhost-user-client-1'
mode='server'/>
<model type='virtio'/>
</interface>
```

## Tuning Openvswitch-DPDK

DPDK has plenty of options - in combination with Openvswitch-DPDK the two most commonly used are:

```auto
ovs-vsctl set Open_vSwitch . other_config:n-dpdk-rxqs=2
ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0x6
```

The first select how many rx queues are to be used for each DPDK  interface, while the second controls how many and where to run PMD  threads. The example above will utilize two rx queues and run PMD  threads on CPU 1 and 2. See the referred links to “EAL Command-line  Options” and “OpenVswitch DPDK installation” at the end of this document for more.

As usual with tunings you have to know your system and workload  really well - so please verify any tunings with workloads matching your  real use case.

## Support and Troubleshooting

DPDK is a fast evolving project. In any case of a search for support  and further guides it is highly recommended to first check if they apply to the current version.

Check if it is a known issue on:

- [DPDK Mailing Lists](http://dpdk.org/ml)
- For OpenVswitch-DPDK [OpenStack Mailing Lists](http://openvswitch.org/mlists)
- Known issues in [DPDK Launchpad Area](https://bugs.launchpad.net/ubuntu/+source/dpdk)
- Join the IRC channels #DPDK or #openvswitch on freenode.

Issues are often due to missing small details in the general setup.  Later on, these missing details cause problems which can be hard to  track down to their root cause. A common case seems to be the “could not open network device dpdk0 (No such device)” issue. This occurs rather  late when setting up a port in Open vSwitch with DPDK. But the root  cause most of the time is very early in the setup and initialization.  Here an example how a proper initialization of a device looks - this can be found in the syslog/journal when starting Open vSwitch with DPDK  enabled.

```auto
ovs-ctl[3560]: EAL: PCI device 0000:04:00.1 on NUMA socket 0
ovs-ctl[3560]: EAL:   probe driver: 8086:1528 rte_ixgbe_pmd
ovs-ctl[3560]: EAL:   PCI memory mapped at 0x7f2140000000
ovs-ctl[3560]: EAL:   PCI memory mapped at 0x7f2140200000
```

If this is missing, either by ignored cards, failed initialization or other reasons, later on there will be no DPDK device to refer to.  Unfortunately the logging is spread across syslog/journal and the  openvswitch log. To allow some cross checking here an example what can  be found in these logs, relative to the entered command.

```auto
#Note: This log was taken with dpdk 2.2 and openvswitch 2.5 but still looks quite similar (a bit extended) these days
Captions:
CMD: that you enter
SYSLOG: (Inlcuding EAL and OVS Messages)
OVS-LOG: (Openvswitch messages)

#PREPARATION
Bind an interface to DPDK UIO drivers, make Hugepages available, enable DPDK on OVS

CMD: sudo service openvswitch-switch restart

SYSLOG:
2016-01-22T08:58:31.372Z|00003|daemon_unix(monitor)|INFO|pid 3329 died, killed (Terminated), exiting
2016-01-22T08:58:33.377Z|00002|vlog|INFO|opened log file /var/log/openvswitch/ovs-vswitchd.log
2016-01-22T08:58:33.381Z|00003|ovs_numa|INFO|Discovered 12 CPU cores on NUMA node 0
2016-01-22T08:58:33.381Z|00004|ovs_numa|INFO|Discovered 1 NUMA nodes and 12 CPU cores
2016-01-22T08:58:33.381Z|00005|reconnect|INFO|unix:/var/run/openvswitch/db.sock: connecting...
2016-01-22T08:58:33.383Z|00006|reconnect|INFO|unix:/var/run/openvswitch/db.sock: connected
2016-01-22T08:58:33.386Z|00007|bridge|INFO|ovs-vswitchd (Open vSwitch) 2.5.0

OVS-LOG:
systemd[1]: Stopping Open vSwitch...
systemd[1]: Stopped Open vSwitch.
systemd[1]: Stopping Open vSwitch Internal Unit...
ovs-ctl[3541]: * Killing ovs-vswitchd (3329)
ovs-ctl[3541]: * Killing ovsdb-server (3318)
systemd[1]: Stopped Open vSwitch Internal Unit.
systemd[1]: Starting Open vSwitch Internal Unit...
ovs-ctl[3560]: * Starting ovsdb-server
ovs-vsctl: ovs|00001|vsctl|INFO|Called as ovs-vsctl --no-wait -- init -- set Open_vSwitch . db-version=7.12.1
ovs-vsctl: ovs|00001|vsctl|INFO|Called as ovs-vsctl --no-wait set Open_vSwitch . ovs-version=2.5.0 "external-ids:system-id=\"e7c5ba80-bb14-45c1-b8eb-628f3ad03903\"" "system-type=\"Ubuntu\"" "system-version=\"16.04-xenial\""
ovs-ctl[3560]: * Configuring Open vSwitch system IDs
ovs-ctl[3560]: 2016-01-22T08:58:31Z|00001|dpdk|INFO|No -vhost_sock_dir provided - defaulting to /var/run/openvswitch
ovs-vswitchd: ovs|00001|dpdk|INFO|No -vhost_sock_dir provided - defaulting to /var/run/openvswitch
ovs-ctl[3560]: EAL: Detected lcore 0 as core 0 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 1 as core 1 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 2 as core 2 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 3 as core 3 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 4 as core 4 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 5 as core 5 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 6 as core 0 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 7 as core 1 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 8 as core 2 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 9 as core 3 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 10 as core 4 on socket 0
ovs-ctl[3560]: EAL: Detected lcore 11 as core 5 on socket 0
ovs-ctl[3560]: EAL: Support maximum 128 logical core(s) by configuration.
ovs-ctl[3560]: EAL: Detected 12 lcore(s)
ovs-ctl[3560]: EAL: VFIO modules not all loaded, skip VFIO support...
ovs-ctl[3560]: EAL: Setting up physically contiguous memory...
ovs-ctl[3560]: EAL: Ask a virtual area of 0x100000000 bytes
ovs-ctl[3560]: EAL: Virtual area found at 0x7f2040000000 (size = 0x100000000)
ovs-ctl[3560]: EAL: Requesting 4 pages of size 1024MB from socket 0
ovs-ctl[3560]: EAL: TSC frequency is ~2397202 KHz
ovs-vswitchd[3592]: EAL: TSC frequency is ~2397202 KHz
ovs-vswitchd[3592]: EAL: Master lcore 0 is ready (tid=fc6cbb00;cpuset=[0])
ovs-vswitchd[3592]: EAL: PCI device 0000:04:00.0 on NUMA socket 0
ovs-vswitchd[3592]: EAL:   probe driver: 8086:1528 rte_ixgbe_pmd
ovs-vswitchd[3592]: EAL:   Not managed by a supported kernel driver, skipped
ovs-vswitchd[3592]: EAL: PCI device 0000:04:00.1 on NUMA socket 0
ovs-vswitchd[3592]: EAL:   probe driver: 8086:1528 rte_ixgbe_pmd
ovs-vswitchd[3592]: EAL:   PCI memory mapped at 0x7f2140000000
ovs-vswitchd[3592]: EAL:   PCI memory mapped at 0x7f2140200000
ovs-ctl[3560]: EAL: Master lcore 0 is ready (tid=fc6cbb00;cpuset=[0])
ovs-ctl[3560]: EAL: PCI device 0000:04:00.0 on NUMA socket 0
ovs-ctl[3560]: EAL:   probe driver: 8086:1528 rte_ixgbe_pmd
ovs-ctl[3560]: EAL:   Not managed by a supported kernel driver, skipped
ovs-ctl[3560]: EAL: PCI device 0000:04:00.1 on NUMA socket 0
ovs-ctl[3560]: EAL:   probe driver: 8086:1528 rte_ixgbe_pmd
ovs-ctl[3560]: EAL:   PCI memory mapped at 0x7f2140000000
ovs-ctl[3560]: EAL:   PCI memory mapped at 0x7f2140200000
ovs-vswitchd[3592]: PMD: eth_ixgbe_dev_init(): MAC: 4, PHY: 3
ovs-vswitchd[3592]: PMD: eth_ixgbe_dev_init(): port 0 vendorID=0x8086 deviceID=0x1528
ovs-ctl[3560]: PMD: eth_ixgbe_dev_init(): MAC: 4, PHY: 3
ovs-ctl[3560]: PMD: eth_ixgbe_dev_init(): port 0 vendorID=0x8086 deviceID=0x1528
ovs-ctl[3560]: Zone 0: name:<RG_MP_log_history>, phys:0x83fffdec0, len:0x2080, virt:0x7f213fffdec0, socket_id:0, flags:0
ovs-ctl[3560]: Zone 1: name:<MP_log_history>, phys:0x83fd73d40, len:0x28a0c0, virt:0x7f213fd73d40, socket_id:0, flags:0
ovs-ctl[3560]: Zone 2: name:<rte_eth_dev_data>, phys:0x83fd43380, len:0x2f700, virt:0x7f213fd43380, socket_id:0, flags:0
ovs-ctl[3560]: * Starting ovs-vswitchd
ovs-ctl[3560]: * Enabling remote OVSDB managers
systemd[1]: Started Open vSwitch Internal Unit.
systemd[1]: Starting Open vSwitch...
systemd[1]: Started Open vSwitch.


CMD: sudo ovs-vsctl add-br ovsdpdkbr0 -- set bridge ovsdpdkbr0 datapath_type=netdev

SYSLOG:
2016-01-22T08:58:56.344Z|00008|memory|INFO|37256 kB peak resident set size after 24.5 seconds
2016-01-22T08:58:56.346Z|00009|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath supports recirculation
2016-01-22T08:58:56.346Z|00010|ofproto_dpif|INFO|netdev@ovs-netdev: MPLS label stack length probed as 3
2016-01-22T08:58:56.346Z|00011|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath supports unique flow ids
2016-01-22T08:58:56.346Z|00012|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath does not support ct_state
2016-01-22T08:58:56.346Z|00013|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath does not support ct_zone
2016-01-22T08:58:56.346Z|00014|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath does not support ct_mark
2016-01-22T08:58:56.346Z|00015|ofproto_dpif|INFO|netdev@ovs-netdev: Datapath does not support ct_label
2016-01-22T08:58:56.360Z|00016|bridge|INFO|bridge ovsdpdkbr0: added interface ovsdpdkbr0 on port 65534
2016-01-22T08:58:56.361Z|00017|bridge|INFO|bridge ovsdpdkbr0: using datapath ID 00005a4a1ed0a14d
2016-01-22T08:58:56.361Z|00018|connmgr|INFO|ovsdpdkbr0: added service controller "punix:/var/run/openvswitch/ovsdpdkbr0.mgmt"

OVS-LOG:
ovs-vsctl: ovs|00001|vsctl|INFO|Called as ovs-vsctl add-br ovsdpdkbr0 -- set bridge ovsdpdkbr0 datapath_type=netdev
systemd-udevd[3607]: Could not generate persistent MAC address for ovs-netdev: No such file or directory
kernel: [50165.886554] device ovs-netdev entered promiscuous mode
kernel: [50165.901261] device ovsdpdkbr0 entered promiscuous mode


CMD: sudo ovs-vsctl add-port ovsdpdkbr0 dpdk0 -- set Interface dpdk0 type=dpdk

SYSLOG:
2016-01-22T08:59:06.369Z|00019|memory|INFO|peak resident set size grew 155% in last 10.0 seconds, from 37256 kB to 95008 kB
2016-01-22T08:59:06.369Z|00020|memory|INFO|handlers:4 ports:1 revalidators:2 rules:5
2016-01-22T08:59:30.989Z|00021|dpdk|INFO|Port 0: 8c:dc:d4:b3:6d:e9
2016-01-22T08:59:31.520Z|00022|dpdk|INFO|Port 0: 8c:dc:d4:b3:6d:e9
2016-01-22T08:59:31.521Z|00023|dpif_netdev|INFO|Created 1 pmd threads on numa node 0
2016-01-22T08:59:31.522Z|00001|dpif_netdev(pmd16)|INFO|Core 0 processing port 'dpdk0'
2016-01-22T08:59:31.522Z|00024|bridge|INFO|bridge ovsdpdkbr0: added interface dpdk0 on port 1
2016-01-22T08:59:31.522Z|00025|bridge|INFO|bridge ovsdpdkbr0: using datapath ID 00008cdcd4b36de9
2016-01-22T08:59:31.523Z|00002|dpif_netdev(pmd16)|INFO|Core 0 processing port 'dpdk0'

OVS-LOG:
ovs-vsctl: ovs|00001|vsctl|INFO|Called as ovs-vsctl add-port ovsdpdkbr0 dpdk0 -- set Interface dpdk0 type=dpdk
ovs-vswitchd[3595]: PMD: ixgbe_dev_tx_queue_setup(): sw_ring=0x7f211a79ebc0 hw_ring=0x7f211a7a6c00 dma_addr=0x81a7a6c00
ovs-vswitchd[3595]: PMD: ixgbe_set_tx_function(): Using simple tx code path
ovs-vswitchd[3595]: PMD: ixgbe_set_tx_function(): Vector tx enabled.
ovs-vswitchd[3595]: PMD: ixgbe_dev_rx_queue_setup(): sw_ring=0x7f211a78a6c0 sw_sc_ring=0x7f211a786580 hw_ring=0x7f211a78e800 dma_addr=0x81a78e800
ovs-vswitchd[3595]: PMD: ixgbe_set_rx_function(): Vector rx enabled, please make sure RX burst size no less than 4 (port=0).
ovs-vswitchd[3595]: PMD: ixgbe_dev_tx_queue_setup(): sw_ring=0x7f211a79ebc0 hw_ring=0x7f211a7a6c00 dma_addr=0x81a7a6c00
...


CMD: sudo ovs-vsctl add-port ovsdpdkbr0 vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuser

OVS-LOG:
2016-01-22T09:00:35.145Z|00026|dpdk|INFO|Socket /var/run/openvswitch/vhost-user-1 created for vhost-user port vhost-user-1
2016-01-22T09:00:35.145Z|00003|dpif_netdev(pmd16)|INFO|Core 0 processing port 'dpdk0'
2016-01-22T09:00:35.145Z|00004|dpif_netdev(pmd16)|INFO|Core 0 processing port 'vhost-user-1'
2016-01-22T09:00:35.145Z|00027|bridge|INFO|bridge ovsdpdkbr0: added interface vhost-user-1 on port 2

SYSLOG:
ovs-vsctl: ovs|00001|vsctl|INFO|Called as ovs-vsctl add-port ovsdpdkbr0 vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuser
ovs-vswitchd[3595]: VHOST_CONFIG: socket created, fd:46
ovs-vswitchd[3595]: VHOST_CONFIG: bind to /var/run/openvswitch/vhost-user-1

Eventually we can see the poll thread in top
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 3595 root      10 -10 4975344 103936   9916 S 100.0  0.3  33:13.56 ovs-vswitchd
```

## Resources

- [DPDK Documentation](http://dpdk.org/doc)
- [Release Notes matching the version packages in Ubuntu 16.04](http://dpdk.org/doc/guides/rel_notes/release_2_2.html)
- [Linux DPDK User Getting Started](http://dpdk.org/doc/guides/linux_gsg/index.html)
- [EAL Command-line Options](http://dpdk.org/doc/guides/testpmd_app_ug/run_app.html)
- [DPDK Api Documentation](http://dpdk.org/doc/api/)
- [OpenVswitch DPDK installation](https://github.com/openvswitch/ovs/blob/branch-2.5/INSTALL.DPDK.md)
- [Wikipedias definition of DPDK](https://en.wikipedia.org/wiki/Data_Plane_Development_Kit)

# Device Mapper Multipathing - Introduction

> Device Mapper Multipath will be referred here as **multipath** only.

Multipath allows you to configure multiple I/O paths between server  nodes and storage arrays into a single device. These I/O paths are  physical SAN connections that can include separate cables, switches, and controllers.

Multipathing aggregates the I/O paths, creating a new device that consists of the aggregated paths. This chapter provides an **introduction and a high-level overview of multipath**.

## Overview


 Multipath can be used to provide:

- *Redundancy*
  
   multipath can provide failover in an active/passive configuration. In an active/passive configuration, only half the paths are used at any time  for I/O. If any element of an I/O path (the cable, switch, or  controller) fails, multipath switches to an alternate path.
- *Improved Performance*
  
   Multipath can be configured in active/active mode, where I/O is spread  over the paths in a round-robin fashion. In some configurations,  multipath can detect loading on the I/O paths and dynamically re-balance the load.

## Storage Array Overview


 It is a very good idea to consult your **storage vendor** *installation guide* for the recommended multipath configuration variables for your storage  model. The default configuration will probably work but will likely need adjustments based on your storage setup.

## Multipath Components

 

| Component                      | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| **dm_multipath kernel module** | Reroutes I/O and supports **failover** for paths and path groups. |
| **multipath command**          | Lists and configures **multipath** devices. Normally started up with `/etc/rc.sysinit`, it can also be started up by a udev program whenever a block device is added or it can be run by the initramfs file system. |
| **multipathd daemon**          | Monitors paths; as paths fail and come back, it may initiate path group switches. Provides for interactive changes to **multipath** devices. This daemon must be restarted for any changes to the `/etc/multipath.conf` file to take effect. |
| **kpartx command**             | Creates device mapper devices for the partitions on a device It is  necessary to use this command for DOS-based partitions with multipath.  The kpartx is provided in its own package, but the **multipath-tools** package depends on it. |

## Multipath Setup Overview


 multipath includes compiled-in default settings that are suitable for  common multipath configurations. Setting up multipath is often a simple  procedure. The basic procedure for configuring your system with  multipath is as follows:

1. Install the **multipath-tools** and **multipath-tools-boot** packages
2. Create an empty config file called `/etc/multipath.conf`
3. Edit the **multipath.conf** file to modify default values and save the updated file.
4. Start the multipath daemon
5. Update initial ramdisk

For detailed setup instructions for multipath configuration see [DM-Multipath Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuration/) and [DM-Multipath Setup](https://discourse.ubuntu.com/t/device-mapper-multipathing-setup/).

# Multipath Devices


 Without multipath, each path from a server node to a storage controller  is treated by the system as a separate device, even when the I/O path  connects the same server node to the same storage controller. Multipath  provides a way of organizing the I/O paths logically, by creating a  single device on top of the underlying paths.

## Multipath Device Identifiers


 Each multipath device has a World Wide Identifier (WWID), which is  guaranteed to be globally unique and unchanging. By default, the name of a multipath device is set to its WWID. Alternately, you can set the **user_friendly_names** option in `multipath.conf`, which causes multipath to use a **node-unique** alias of the form **mpathn** as the name.

For example, a node with two HBAs attached to a storage controller  with two ports via a single unzoned FC switch sees four devices:  **/dev/sda**, **/dev/sdb**, **/dev/sdc**, and **/dev/sdd**. Multipath creates a single device with a unique WWID that reroutes I/O  to those four underlying devices according to the multipath  configuration.

When the user_friendly_names configuration option is set to **yes**, the name of the multipath device is set to **mpathn**. When new devices are brought under the control of multipath, the new devices may be seen in two different places under the **/dev** directory: **/dev/mapper/mpathn** and **/dev/dm-n**.

- The devices in **/dev/mapper** are created early in the boot process. **Use these devices to access the multipathed devices.**
- Any devices of the form **/dev/dm-n** are for **internal use only** and should never be used directly.

You can also set the name of a multipath device to a name of your choosing by using the **alias** option in the **multipaths** section of the multipath configuration file.

> For information on the multipath configuration defaults, including the **user_friendly_names** and **alias** configuration options, see [DM-Multipath Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuration/).

## Consistent Multipath Device Names in a Cluster


 When the **user_friendly_names** configuration option is  set to yes, the name of the multipath device is unique to a node, but it is not guaranteed to be the same on all nodes using the multipath  device. Similarly, if you set the **alias** option for a device in the **multipaths** section of `/etc/multipath.conf`, the name is not automatically consistent across all nodes in the cluster.

This should not cause any difficulties if you use LVM to create  logical devices from the multipath device, but if you require that your  multipath device names be consistent in every node it is recommended  that you leave the **user_friendly_names** option set to **no** and that you not configure aliases for the devices.

If you configure an alias for a device that you would like to be  consistent across the nodes in the cluster, you should ensure that the `/etc/multipath.conf` file is the same for each node in the cluster by following the same procedure:

1. Configure the aliases for the multipath devices in the in the `multipath.conf` file on one machine.

2. Disable all of your multipath devices on your other machines by running the following commands:

   ```
   # systemctl stop multipath-tools.service
   # multipath -F
   ```

3. Copy the `/etc/multipath.conf` file from the first machine to all the other machines in the cluster.

4. Re-enable the multipathd daemon on all the other machines in the cluster by running the following command:

   ```
   # systemctl start multipath-tools.service
   ```

When you add a new device you will need to repeat this process.

## Multipath Device attributes


 In addition to the **user_friendly_names** and **alias** options, a multipath device has numerous attributes. You can modify  these attributes for a specific multipath device by creating an entry  for that device in the **multipaths** section of `/etc/multipath.conf`.

For information on the **multipaths** section of the multipath configuration file, see [DM-Multipath Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuration).

## Multipath Devices in Logical Volumes


 After creating multipath devices, you can use the multipath device names just as you would use a physical device name when creating an LVM  physical volume.

For example, if /dev/mapper/mpatha is the name of a multipath device, the following command will mark /dev/mapper/mpatha as a physical  volume:

```auto
# pvcreate /dev/mapper/mpatha
```

You can use the resulting LVM physical device when you create an LVM  volume group just as you would use any other LVM physical device.

> **Note**
>
> If you attempt to create an LVM physical volume on a whole device on  which you have configured partitions, the pvcreate command will fail.

When you create an LVM logical volume that uses active/passive  multipath arrays as the underlying physical devices, you should include  filters in the **lvm.conf** to exclude the disks that  underlie the multipath devices. This is because if the array  automatically changes the active path to the passive path when it  receives I/O, multipath will failover and failback whenever LVM scans  the passive path if these devices are not filtered.

For active/passive arrays that require a command to make the passive  path active, LVM prints a warning message when this occurs. To filter  all SCSI devices in the LVM configuration file (lvm.conf), include the  following filter in the devices section of the file.

```
filter = [ "r/block/", "r/disk/", "r/sd.*/", "a/.*/" ]
```

After updating `/etc/lvm.conf`, it’s necessary to update the **initrd** so that this file will be copied there, where the filter matters the most, during boot.

Perform:

```
update-initramfs -u -k all
```

> **Note**
>
> Every time either `/etc/lvm.conf` or `/etc/multipath.conf` is updated, the initrd should be rebuilt to reflect these changes. This is imperative when blacklists and filters are necessary to maintain a  stable storage configuration.

# Device Mapper Multipathing - Configuration

> Device Mapper Multipath will be referred here as  **multipath**  only.

> Before moving on with this session it is recommended that you read:
>  [1. Device Mapper Multipathing - Introduction](https://discourse.ubuntu.com/t/device-mapper-multipathing-introduction/)

Multipath is usually able to work out-of-the-box with most common  storages. This doesn’t mean the default configuration variables should  be used in production: they don’t treat important parameters your  storage might need.

> Consult your **storage manufacturer’s install guide**  for the Linux Multipath configuration options. It is very common that  storage vendors provide the most adequate options for Linux, including  minimal kernel and multipath-tools versions required.

Default configuration values for DM-Multipath can be overridden by editing the `/etc/multipath.conf` file and restarting the `multipathd` service.

This chapter provides information on parsing and modifying the `multipath.conf` file and it is split into the following configuration file sections:

- Configuration File Overview
- Configuration File Defaults
- Configuration File Blacklist & Exceptions
- Configuration File Multipath Section
- Configuration File Devices Section

## Configuration File Overview

The configuration file contains entries of the form:

```
<section> {
       <attribute> <value>
       ...
       <subsection> {
              <attribute> <value>
              ...
       }
}
```

The following keywords are recognized:

- **defaults** - This section defines default values for  attributes which are used whenever no values are given in the  appropriate device or multipath sections.
- **blacklist** - This section defines which devices should be excluded from the multipath topology discovery.
- **blacklist_exceptions** - This section defines which  devices should be included in the multipath topology discovery, despite  being listed in the blacklist section.
- **multipaths** - This section defines the multipath  topologies. They are indexed by a World Wide Identifier(WWID).Attributes set in this section take **precedence over all others**.
- **devices** - This section defines the device-specific settings. Devices are identified by vendor, product, and revision.
- **overrides** - This section defines values for attributes that should override the device-specific settings for all devices.

## Configuration File Defaults

Currently, the multipath configuration file **ONLY** includes a minor **defaults** section that sets the **user_friendly_names** parameter to **yes**:

```
defaults {
    user_friendly_names yes
}
```

This overwrites the default value of the **user_friendly_names** parameter.

All the multipath attributes that can set in the **defaults** section of the `multipath.conf` file can be found [HERE](https://manpages.ubuntu.com/manpages/focal/en/man5/multipath.conf.5.html#defaults section) with an explanation of what they mean. The attributes are:

- verbosity
- polling_interval
- max_polling_interval
- reassign_maps
- multipath_dir
- path_selector
- path_grouping_policy
- uid_attrs
- uid_attribute
- getuid_callout
- prio
- prio_args
- features
- path_checker
- alias_prefix
- failback
- rr_min_io
- rr_min_io_rq
- max_fds
- rr_weight
- no_path_retry
- queue_without_daemon
- checker_timeout
- flush_on_last_del
- user_friendly_names
- fast_io_fail_tmo
- dev_loss_tmo
- bindings_file
- wwids_file
- prkeys_file
- log_checker_err
- reservation_key
- all_tg_pt
- retain_attached_hw_handler
- detect_prio
- detect_checker
- force_sync
- strict_timing
- deferred_remove
- partition_delimiter
- config_dir
- san_path_err_threshold
- san_path_err_forget_rate
- san_path_err_recovery_time
- marginal_path_double_failed_time
- marginal_path_err_sample_time
- marginal_path_err_rate_threshold
- marginal_path_err_recheck_gap_time
- delay_watch_checks
- delay_wait_checks
- marginal_pathgroups
- find_multipaths
- find_multipaths_timeout
- uxsock_timeout
- retrigger_tries
- retrigger_delay
- missing_uev_wait_timeout
- skip_kpartx
- disable_changed_wwids
- remove_retries
- max_sectors_kb
- ghost_delay
- enable_foreign

> Previously the multipath-tools project used to provide a complete  configuration file with all the most used options for each of the most  used storage devices. Currently you can see all those default options by executing [`sudo multipath -t`](https://paste.ubuntu.com/p/gfGkHwGyXw/). This will dump used configuration file including all the embedded default options.

## Configuration File Blacklist & Exceptions

The blacklist section is used to exclude specific devices from the  multipath topology. It is most commonly used to exclude local disks,  non-multipathed OR non-disk devices.

1. Blacklist by devnode

   The default blacklist consists of the regular expressions  “^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]” and  “^(td|hd|vd)[a-z]”. This causes virtual devices, non-disk devices, and  some other device types to be excluded from multipath handling by  default.

   ```auto
   blacklist {
       devnode "^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]"
       devnode "^(td|hd|vd)[a-z]"
       devnode "^cciss!c[0-9]d[0-9]*"
   }
   ```

2. Blacklist by wwid

   Regular expression for the World Wide Identifier of a device to be excluded/included

3. Blacklist by device

   Subsection for the device description. This subsection recognizes the **vendor** and **product** keywords. Both are regular expressions.

   ```auto
   device {
       vendor "LENOVO"
       product "Universal Xport"
   }
   ```

4. Blacklist by property

   Regular expression for an udev property. All devices that have  matching udev properties will be excluded/included. The handling of the  property keyword is special, because devices must have at least one  whitelisted udev property; otherwise they’re treated as blacklisted, and the message “blacklisted, udev property missing” is displayed in the  logs.

5. Blacklist by protocol

   The protocol strings that multipath recognizes are scsi:fcp,  scsi:spi, scsi:ssa, scsi:sbp, scsi:srp, scsi:iscsi, scsi:sas, scsi:adt,  scsi:ata, scsi:unspec, ccw, cciss, nvme, and undef. The protocol that a  path is using can be viewed by running multipathd show paths format “%d  %P”

6. Blacklist Exceptions

   The blacklist_exceptions section is used to revert the actions of the blacklist section. This allows one to selectively include (“whitelist”) devices which would normally be excluded via the blacklist section.

   ```auto
   blacklist_exceptions {
       property "(SCSI_IDENT_|ID_WWN)"
   }
   ```

> A common usage is to blacklist “everything” using a catch-all regular expression, and create specific blacklist_exceptions entries for those  devices that should be handled by multipath-tools.

## Configuration File Multipath Section

The multipaths section allows setting attributes of **multipath maps**. The attributes that are set via the **multipaths section** (see list below) take precedence over all other configuration settings, including those from the overrides section.

The only recognized attribute for the multipaths section is the  multipath subsection. If there are multiple multipath subsections  matching a given WWID, the contents of these sections are merged, and  settings from later entries take precedence.

The multipath subsection recognizes the following attributes:

- **wwid** = (Mandatory) World Wide Identifier. Detected  multipath maps are matched agains this attribute. Note that, unlike the  wwid attribute in the blacklist section, this is not a regular  expression or a substring; WWIDs must match exactly inside the  multipaths section.
- **alias** = Symbolic name for the multipath map. This takes precedence over a an entry for the same WWID in the bindings_file.

The following attributes are optional; if not set the default values are taken from the overrides, devices, or [**defaults section**](https://manpages.ubuntu.com/manpages/focal/en/man5/multipath.conf.5.html#defaults section):

- path_grouping_policy
- path_selector
- prio
- prio_args
- failback
- rr_weight
- no_path_retry
- rr_min_io
- rr_min_io_rq
- flush_on_last_del
- features
- reservation_key
- user_friendly_names
- deferred_remove
- san_path_err_threshold
- san_path_err_forget_rate
- san_path_err_recovery_time
- marginal_path_err_sample_time
- marginal_path_err_rate_threshold
- marginal_path_err_recheck_gap_time
- marginal_path_double_failed_time
- delay_watch_checks
- delay_wait_checks
- skip_kpartx
- max_sectors_kb
- ghost_delay

Example:

```auto
multipaths {
    multipath {
        wwid                    3600508b4000156d700012000000b0000
        alias                   yellow
        path_grouping_policy    multibus
        path_selector           "round-robin 0"
        failback                manual
        rr_weight               priorities
        no_path_retry           5
    }
    multipath {
        wwid                    1DEC_____321816758474
        alias                   red
    }
}
```

## Configuration File Devices Section

multipath-tools have a built-in device table with reasonable defaults for more than 100 known multipath-capable storage devices.The devices  section can be used to override these settings. If there are multiple  matches for a given device, the attributes of all matching entries are  applied to it. If an attribute is specified in several matching device  subsections, later entries take precedence.

The only recognized attribute for the devices section is the device  subsection. Devices detected in the system are matched against the  device entries using the vendor, product, and revision fields.

The vendor, product, and revision fields that multipath or multipathd detect for devices in a system depend on the device type. For SCSI  devices, they correspond to the respective fields of the SCSI INQUIRY  page. In general, the command ‘multipathd show paths format “%d %s”’  command can be used to see the detected properties for all devices in  the system.

The device subsection recognizes the following attributes:

1. **vendor**
   (Mandatory) Regular expression to match the vendor name.

2. **product**
   (Mandatory) Regular expression to match the product name.

3. **revision**
   Regular expression to match the product revision.

4. **product_blacklist**
   Products with the given vendor matching this string are blacklisted.

5. **alias_prefix**
   The user_friendly_names prefix to use for this device type, instead of the default “mpath”.

6. hardware_handler

   The hardware handler to use for this device type. The following hardware handler are implemented:

   - **1 emc** - (Hardware-dependent) Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX and Unity families.
   - **1 rdac** - (Hardware-dependent) Hardware handler for LSI / Engenio / NetApp RDAC class as NetApp SANtricity E/EF Series, and OEM  arrays from IBM DELL SGI STK and SUN.
   - **1 hp_sw** - (Hardware-dependent) Hardware handler for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with Active/Standby mode exclusively.
   - **1 alua** - (Hardware-dependent) Hardware handler for SCSI-3 ALUA compatible arrays.
   - **1 ana** - (Hardware-dependent) Hardware handler for NVMe ANA compatible arrays.

The following attributes are optional; if not set the default values are taken from the defaults section:

- path_grouping_policy
- uid_attribute
- getuid_callout
- path_selector
- path_checker
- prio
- prio_args
- features
- failback
- rr_weight
- no_path_retry
- rr_min_io
- rr_min_io_rq
- fast_io_fail_tmo
- dev_loss_tmo
- flush_on_last_del
- user_friendly_names
- retain_attached_hw_handler
- detect_prio
- detect_checker
- deferred_remove
- san_path_err_threshold
- san_path_err_forget_rate
- san_path_err_recovery_time
- marginal_path_err_sample_time
- marginal_path_err_rate_threshold
- marginal_path_err_recheck_gap_time
- marginal_path_double_failed_time
- delay_watch_checks
- delay_wait_checks
- skip_kpartx
- max_sectors_kb
- ghost_delay
- all_tg_pt

Example:

```auto
devices {
    device {
        vendor "3PARdata"
        product "VV"
        path_grouping_policy "group_by_prio"
        hardware_handler "1 alua"
        prio "alua"
        failback "immediate"
        no_path_retry 18
        fast_io_fail_tmo 10
        dev_loss_tmo "infinity"
    }
    device {
        vendor "DEC"
        product "HSG80"
        path_grouping_policy "group_by_prio"
        path_checker "hp_sw"
        hardware_handler "1 hp_sw"
        prio "hp_sw"
        no_path_retry "queue"
    }
}
```

# Device Mapper Multipathing - Setup

> Device Mapper Multipath will be referred here as **multipath** only.

> Before moving on with this session it is recommended that you read:
>  [1. Device Mapper Multipathing - Introduction](https://discourse.ubuntu.com/t/device-mapper-multipathing-introduction/)
>  [2. Device Mapper Multipathing - Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuratio)

This section provides step-by-step example procedures for configuring multipath.

It includes the following procedures:

- **Basic setup**
  - Main **defaults** & **devices** attributes.
  - Shows how to **ignore disks** with blacklists
  - Shows how to **rename disks** using WWIDs
- **Configuring active/active paths**

## Basic Setup

Before setting up multipath on your system, ensure that your system has been updated and includes the **multipath-tools** package. If boot from SAN is desired, then the **multipath-tools-boot** package is also required.

A very simple **/etc/multipath.conf** file exists, as explained in [Device Mapper Multipathing - Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuration/) session. All the non-declared in multipath.conf attributes are taken  from multipath-tools internal database and its internal blacklist.

The internal attributes database can be acquired by doing:

[$ sudo multipath -t](https://paste.ubuntu.com/p/gfGkHwGyXw/)

Multipath is usually able to work out-of-the-box with most common storages. This **does not** mean the default configuration variables should be **used in production**: they don’t treat important parameters your storage might need.

With the **internal attributes**, described above, and the given example bellow, you will likely be able to create your `/etc/multipath.conf` file by squashing the code blocks bellow. Make sure to read every **defaults** section attribute comments and change it based on your environment needs.

- Example of a **defaults** section:

```auto
defaults {
    #
    # name    : polling_interval
    # scope   : multipathd
    # desc    : interval between two path checks in seconds. For
    #           properly functioning paths, the interval between checks
    #           will gradually increase to (4 * polling_interval).
    # values  : n > 0
    # default : 5
    #
    polling_interval 10
    
    #
    # name    : path_selector
    # scope   : multipath & multipathd
    # desc    : the default path selector algorithm to use
    #           these algorithms are offered by the kernel multipath target
    # values  : "round-robin 0"  = Loop through every path in the path group,
    #                              sending the same amount of IO to each.
    #           "queue-length 0" = Send the next bunch of IO down the path
    #                              with the least amount of outstanding IO.
    #           "service-time 0" = Choose the path for the next bunch of IO
    #                              based on the amount of outstanding IO to
    #                              the path and its relative throughput.
    # default : "service-time 0"
    #
    path_selector "round-robin 0"
    
    #
    # name    : path_grouping_policy
    # scope   : multipath & multipathd
    # desc    : the default path grouping policy to apply to unspecified
    #           multipaths
    # values  : failover           = 1 path per priority group
    #           multibus           = all valid paths in 1 priority group
    #           group_by_serial    = 1 priority group per detected serial
    #                                number
    #           group_by_prio      = 1 priority group per path priority
    #                                value
    #           group_by_node_name = 1 priority group per target node name
    # default : failover
    #
    path_grouping_policy multibus
    
    #
    # name    : uid_attribute
    # scope   : multipath & multipathd
    # desc    : the default udev attribute from which the path
    #       identifier should be generated.
    # default : ID_SERIAL
    #
    uid_attribute "ID_SERIAL"
    
    #
    # name    : getuid_callout
    # scope   : multipath & multipathd
    # desc    : the default program and args to callout to obtain a unique
    #           path identifier. This parameter is deprecated.
    #           This parameter is deprecated, superseded by uid_attribute
    # default : /lib/udev/scsi_id --whitelisted --device=/dev/%n
    #
    getuid_callout "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
    
    #
    # name    : prio
    # scope   : multipath & multipathd
    # desc    : the default function to call to obtain a path
    #           priority value. The ALUA bits in SPC-3 provide an
    #           exploitable prio value for example.
    # default : const
    #
    # prio "alua"
    
    #
    # name    : prio_args
    # scope   : multipath & multipathd
    # desc    : The arguments string passed to the prio function
    #           Most prio functions do not need arguments. The
    #       datacore prioritizer need one.
    # default : (null)
    #
    # prio_args "timeout=1000 preferredsds=foo"
    
    #
    # name    : features
    # scope   : multipath & multipathd
    # desc    : The default extra features of multipath devices.
    #           Syntax is "num[ feature_0 feature_1 ...]", where `num' is the
    #           number of features in the following (possibly empty) list of
    #           features.
    # values  : queue_if_no_path = Queue IO if no path is active; consider
    #                              using the `no_path_retry' keyword instead.
    #           no_partitions    = Disable automatic partitions generation via
    #                              kpartx.
    # default : "0"
    #
    features    "0"
    #features   "1 queue_if_no_path"
    #features   "1 no_partitions"
    #features   "2 queue_if_no_path no_partitions"
    
    #
    # name    : path_checker, checker
    # scope   : multipath & multipathd
    # desc    : the default method used to determine the paths' state
    # values  : readsector0|tur|emc_clariion|hp_sw|directio|rdac|cciss_tur
    # default : directio
    #
    path_checker directio
    
    #
    # name    : rr_min_io
    # scope   : multipath & multipathd
    # desc    : the number of IO to route to a path before switching
    #           to the next in the same path group for the bio-based
    #           multipath implementation. This parameter is used for
    #           kernels version up to 2.6.31; newer kernel version
    #           use the parameter rr_min_io_rq
    # default : 1000
    #
    rr_min_io 100
    
    #
    # name    : rr_min_io_rq
    # scope   : multipath & multipathd
    # desc    : the number of IO to route to a path before switching
    #           to the next in the same path group for the request-based
    #           multipath implementation. This parameter is used for
    #           kernels versions later than 2.6.31.
    # default : 1
    #
    rr_min_io_rq 1
    
    #
    # name    : flush_on_last_del
    # scope   : multipathd
    # desc    : If set to "yes", multipathd will disable queueing when the
    #           last path to a device has been deleted.
    # values  : yes|no
    # default : no
    #
    flush_on_last_del yes
    
    #
    # name    : max_fds
    # scope   : multipathd
    # desc    : Sets the maximum number of open file descriptors for the
    #           multipathd process.
    # values  : max|n > 0
    # default : None
    #
    max_fds 8192
    
    #
    # name    : rr_weight
    # scope   : multipath & multipathd
    # desc    : if set to priorities the multipath configurator will assign
    #           path weights as "path prio * rr_min_io"
    # values  : priorities|uniform
    # default : uniform
    #
    rr_weight priorities
    
    #
    # name    : failback
    # scope   : multipathd
    # desc    : tell the daemon to manage path group failback, or not to.
    #           0 means immediate failback, values >0 means deffered
    #           failback expressed in seconds.
    # values  : manual|immediate|n > 0
    # default : manual
    #
    failback immediate
    
    #
    # name    : no_path_retry
    # scope   : multipath & multipathd
    # desc    : tell the number of retries until disable queueing, or
    #           "fail" means immediate failure (no queueing),
    #           "queue" means never stop queueing
    # values  : queue|fail|n (>0)
    # default : (null)
    #
    no_path_retry fail
    
    #
    # name    : queue_without_daemon
    # scope   : multipathd
    # desc    : If set to "no", multipathd will disable queueing for all
    #           devices when it is shut down.
    # values  : yes|no
    # default : yes
    queue_without_daemon no
    
    #
    # name    : user_friendly_names
    # scope   : multipath & multipathd
    # desc    : If set to "yes", using the bindings file
    #           /etc/multipath/bindings to assign a persistent and
    #           unique alias to the multipath, in the form of mpath<n>.
    #           If set to "no" use the WWID as the alias. In either case
    #           this be will be overriden by any specific aliases in this
    #           file.
    # values  : yes|no
    # default : no
    user_friendly_names yes
    
    #
    # name    : mode
    # scope   : multipath & multipathd
    # desc    : The mode to use for the multipath device nodes, in octal.
    # values  : 0000 - 0777
    # default : determined by the process
    mode 0644
    
    #
    # name    : uid
    # scope   : multipath & multipathd
    # desc    : The user id to use for the multipath device nodes. You
    #           may use either the numeric or symbolic uid
    # values  : <user_id>
    # default : determined by the process
    uid 0
    
    #
    # name    : gid
    # scope   : multipath & multipathd
    # desc    : The group id to user for the multipath device nodes. You
    #           may use either the numeric or symbolic gid
    # values  : <group_id>
    # default : determined by the process
    gid disk
    
    #
    # name    : checker_timeout
    # scope   : multipath & multipathd
    # desc    : The timeout to use for path checkers and prioritizers
    #           that issue scsi commands with an explicit timeout, in
    #           seconds.
    # values  : n > 0
    # default : taken from /sys/block/sd<x>/device/timeout
    checker_timeout 60
    
    #
    # name    : fast_io_fail_tmo
    # scope   : multipath & multipathd
    # desc    : The number of seconds the scsi layer will wait after a
    #           problem has been detected on a FC remote port before failing
    #           IO to devices on that remote port.
    # values  : off | n >= 0 (smaller than dev_loss_tmo)
    # default : determined by the OS
    fast_io_fail_tmo 5
    
    #
    # name    : dev_loss_tmo
    # scope   : multipath & multipathd
    # desc    : The number of seconds the scsi layer will wait after a
    #           problem has been detected on a FC remote port before
    #           removing it from the system.
    # values  : infinity | n > 0
    # default : determined by the OS
    dev_loss_tmo 120
    
    #
    # name    : bindings_file
    # scope   : multipath
    # desc    : The location of the bindings file that is used with
    #           the user_friendly_names option.
    # values  : <full_pathname>
    # default : "/var/lib/multipath/bindings"
    # bindings_file "/etc/multipath/bindings"
    
    #
    # name    : wwids_file
    # scope   : multipath
    # desc    : The location of the wwids file multipath uses to
    #           keep track of the created multipath devices.
    # values  : <full_pathname>
    # default : "/var/lib/multipath/wwids"
    # wwids_file "/etc/multipath/wwids"
    
    #
    # name    : reservation_key
    # scope   : multipath
    # desc    : Service action reservation key used by mpathpersist.
    # values  : <key>
    # default : (null)
    # reservation_key "mpathkey"
    
    #
    # name    : force_sync
    # scope   : multipathd
    # desc    : If set to yes, multipath will run all of the checkers in
    #           sync mode, even if the checker has an async mode.
    # values  : yes|no
    # default : no
    force_sync yes
    
    #
    # name    : config_dir
    # scope   : multipath & multipathd
    # desc    : If not set to an empty string, multipath will search
    #           this directory alphabetically for files ending in ".conf"
    #           and it will read configuration information from these
    #           files, just as if it was in /etc/multipath.conf
    # values  : "" or a fully qualified pathname
    # default : "/etc/multipath/conf.d"
    
    #
    # name    : delay_watch_checks
    # scope   : multipathd
    # desc    : If set to a value greater than 0, multipathd will watch
    #           paths that have recently become valid for this many
    #           checks.  If they fail again while they are being watched,
    #           when they next become valid, they will not be used until
    #           they have stayed up for delay_wait_checks checks.
    # values  : no|<n> > 0
    # default : no
    delay_watch_checks 12
    
    #
    # name    : delay_wait_checks
    # scope   : multipathd
    # desc    : If set to a value greater than 0, when a device that has
    #           recently come back online fails again within
    #           delay_watch_checks checks, the next time it comes back
    #           online, it will marked and delayed, and not used until
    #           it has passed delay_wait_checks checks.
    # values  : no|<n> > 0
    # default : no
    delay_wait_checks 12
}
```

- Example of a **multipaths** section.

> Note: You can obtain the WWIDs for your LUNs executing:
>
> $ multipath -ll
>
> after the service multipath-tools.service has been restarted.

```auto
multipaths {
    multipath {
        wwid 360000000000000000e00000000030001
        alias yellow
    }
    multipath {
        wwid 360000000000000000e00000000020001
        alias blue
    }
    multipath {
        wwid 360000000000000000e00000000010001
        alias red
    }
    multipath {
        wwid 360000000000000000e00000000040001
        alias green
    }
    multipath {
        wwid 360000000000000000e00000000050001
        alias purple
    }
}
```

- Small example of a **devices** section:

```auto
# devices {
#     device {
#         vendor "IBM"
#         product "2107900"
#         path_grouping_policy group_by_serial
#     }
# }
#
```

- Example of a **blacklist** section:

```auto
# name    : blacklist
# scope   : multipath & multipathd
# desc    : list of device names to discard as not multipath candidates
#
# Devices can be identified by their device node name "devnode",
# their WWID "wwid", or their vender and product strings "device"
# default : fd, hd, md, dm, sr, scd, st, ram, raw, loop, dcssblk
#
# blacklist {
#     wwid 26353900f02796769
#     devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\*"
#     devnode "^hd[a-z]"
#     devnode "^dcssblk[0-9]\*"
#     device {
#         vendor DEC.\*
#         product MSA[15]00
#     }
# }
```

- Example of a **blacklist exception** section:

```auto
# name    : blacklist_exceptions
# scope   : multipath & multipathd
# desc    : list of device names to be treated as multipath candidates
#           even if they are on the blacklist.
#
# Note: blacklist exceptions are only valid in the same class.
# It is not possible to blacklist devices using the devnode keyword
# and to exclude some devices of them using the wwid keyword.
# default : -
#
# blacklist_exceptions {
#        devnode "^dasd[c-d]+[0-9]\*"
#        wwid    "IBM.75000000092461.4d00.34"
#        wwid    "IBM.75000000092461.4d00.35"
#        wwid    "IBM.75000000092461.4d00.36"
# }
```

# Device Mapper Multipathing - Usage & Debug

> Device Mapper Multipath will be referred here as **multipath** only.

> Before moving on with this session it is recommended that you read:
>  [1. Device Mapper Multipathing - Introduction](https://discourse.ubuntu.com/t/device-mapper-multipathing-introduction/)
>  [2. Device Mapper Multipathing - Configuration](https://discourse.ubuntu.com/t/device-mapper-multipathing-configuration)
>  [3. Device Mapper Multipathing - Setup](https://discourse.ubuntu.com/t/device-mapper-multipathing-setup/)

This section provides step-by-step example procedures for configuring multipath.

It includes the following procedures:

- **Resizing Online** Multipath Devices
- **Moving root** File System from a **Single** Path Device to a **Multipath Device**
- The **Multipath Daemon**
- Issues with **queue_if_no_path**
- Multipath **Command Output**
- Multipath **Queries **with multipath Command
- Determining **Device Mapper Entries** with dmsetup Command
- Troubleshooting with the **multipathd interactive console**

## **Resizing Online** Multipath Devices

First find all the paths to the LUN about to be resized:

```auto
$ sudo multipath -ll
mpathb (360014056eee8ec6e1164fcb959086482) dm-0 LIO-ORG,lun01
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:1 sde 8:64 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:1 sdf 8:80 active ready running
mpatha (36001405e3c2841430ee4bf3871b1998b) dm-1 LIO-ORG,lun02
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:2 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:2 sdd 8:48 active ready running
```

Now I’ll reconfigure **mpathb** (with wwid = 360014056eee8ec6e1164fcb959086482) to have 2GB instead of just 1Gb and check if has changed:

```auto
$ echo 1 | sudo tee /sys/block/sde/device/rescan
1
$ echo 1 | sudo tee /sys/block/sdf/device/rescan
1
$ sudo multipath -ll
mpathb (360014056eee8ec6e1164fcb959086482) dm-0 LIO-ORG,lun01
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:1 sde 8:64 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:1 sdf 8:80 active ready running
mpatha (36001405e3c2841430ee4bf3871b1998b) dm-1 LIO-ORG,lun02
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:2 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:2 sdd 8:48 active ready running
```

**Not yet!** We still need to re-scan the multipath map:

```auto
$ sudo multipathd resize map mpathb
ok
```

And **then** we are good:

```auto
$ sudo multipath -ll
mpathb (360014056eee8ec6e1164fcb959086482) dm-0 LIO-ORG,lun01
size=2.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:1 sde 8:64 active ready running
.`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:1 sdf 8:80 active ready running
mpatha (36001405e3c2841430ee4bf3871b1998b) dm-1 LIO-ORG,lun02
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:2 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:2 sdd 8:48 active ready running
```

Make sure to run `resize2fs /dev/mapper/mpathb` to resize the filesystem.

## **Moving root** File System from a **Single** Path Device to a **Multipath Device**

This is dramatically simplified by the use of UUIDs to identify  devices as an intrinsic label. Simply install multipath-tools-boot and  reboot. This will rebuild the initial ramdisk and afford multipath the  opportunity to build it’s paths before the root filesystem is mounted by UUID.

> **Note**
>  Whenever `multipath.conf` is updated, so should the initrd by executing:
>  `update-initramfs -u -k all`
>  The reason behind is `multipath.conf` is copied to the ramdisk and is integral to determining the available devices to map via it’s blacklist and devices sections.

## The **Multipath Daemon**

If you find you have trouble implementing a multipath configuration,  you should ensure the multipath daemon is running as described in [Device Mapper Multipathing - Setup](https://discourse.ubuntu.com/t/device-mapper-multipathing-setup/). The **multipathd** daemon must be running in order to use** multipath** devices.

## Multipath **Command Output**

When you create, modify, or list a multipath device, you get a  printout of the current device setup. The format is as follows. For each multipath device:

```auto
action_if_any: alias (wwid_if_different_from_alias) dm_device_name_if_known vendor,product
   size=size features='features' hwhandler='hardware_handler' wp=write_permission_if_known
```

For each path group:

```auto
  -+- policy='scheduling_policy' prio=prio_if_known
  status=path_group_status_if_known
```

For each path:

```auto
   `- host:channel:id:lun devnode major:minor dm_status_if_known path_status
  online_status
```

For example, the output of a multipath command might appear as follows:

```auto
mpathb (360014056eee8ec6e1164fcb959086482) dm-0 LIO-ORG,lun01
size=2.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| `- 7:0:0:1 sde 8:64 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  `- 8:0:0:1 sdf 8:80 active ready running
```

If the path is up and ready for I/O, the status of the path is **ready** or **ghost.** If the path is down, the status is **faulty** or **shaky.** The path status is updated periodically by the **multipathd** daemon based on the *polling interval* defined in the `/etc/multipath.conf`  file.

The dm_status is similar to the path status, but from the kernel’s point of view. The dm_status has two states: **failed**, which is analogous to **faulty**, and **active**, which covers all other path states. Occasionally, the path state and the dm state of a device will temporary not agree.

The possible values for **online_status** are **running** and **offline**. A status of **offline** means that the SCSI device has been disabled.

## Multipath **Queries **with multipath Command

You can use the -l and -ll options of the multipath command to  display the current multipath configuration. The -l option displays  multipath topology gathered from information in sysfs and the device  mapper. The -ll option displays the information the -l displays in  addition to all other available components of the system.

When displaying the multipath configuration, there are three verbosity levels you can specify with the **-v** option of the multipath command. Specifying **-v0** yields **no output**. Specifying**-v1** outputs the **created or updated multipath names only**, which you can then feed to other tools such as kpartx. Specifying **-v2** prints **all detected paths, multipaths, and device maps**.

> **Note**
>  The default **verbosity** level of multipath is **2** and can be globally modified by defining the [verbosity attribute](https://ubuntu.com/server/docs/device-mapper-multipathing-usage-debug#attribute-verbosity) in the **defaults** section of `multipath.conf`.

The following example shows the output of a **multipath -l** command.

```auto
$ sudo multipath -l
mpathb (360014056eee8ec6e1164fcb959086482) dm-0 LIO-ORG,lun01
size=2.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| `- 7:0:0:1 sde 8:64 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
  `- 8:0:0:1 sdf 8:80 active undef running
mpatha (36001405e3c2841430ee4bf3871b1998b) dm-1 LIO-ORG,lun02
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| `- 7:0:0:2 sdc 8:32 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
  `- 8:0:0:2 sdd 8:48 active undef running
```

## Determining **Device Mapper Entries** with dmsetup Command

You can use the dmsetup command to find out which device mapper entries match the **multipathed** devices. The following command displays all the device mapper devices  and their major and minor numbers. The minor numbers determine the name  of the dm device. For example, a minor number of 1 corresponds to the  multipathd device /dev/dm-1.

```auto
$ sudo dmsetup ls
mpathb  (253:0)
mpatha  (253:1)

$ ls -lahd /dev/dm*
brw-rw---- 1 root disk 253, 0 Apr 27 14:49 /dev/dm-0
brw-rw---- 1 root disk 253, 1 Apr 27 14:47 /dev/dm-1
```

## Troubleshooting with the **multipathd interactive console**

The **multipathd -k** command is an interactive interface to the **multipathd** daemon. Entering this command brings up an interactive multipath  console. After entering this command, you can enter help to get a list  of available commands, you can enter a interactive command, or you can  enter **CTRL-D** to quit.

The multipathd interactive console can be used to troubleshoot  problems you may be having with your system. For example, the following  command sequence displays the multipath configuration, including the  defaults, before exiting the console.

```auto
$ sudo multipathd -k
  > show config
  > CTRL-D
```

The following command sequence ensures that multipath has picked up any changes to the multipath.conf,

```auto
$ sudo multipathd -k
> reconfigure
> CTRL-D
```

Use the following command sequence to ensure that the path checker is working properly.

```auto
$ sudo multipathd -k
> show paths
> CTRL-D
```

Commands can also be streamed into multipathd using STDIN like so:

```auto
$ echo 'show config' | sudo multipathd -k
```

# Security

Security should always be considered when installing, deploying, and  using any type of computer system. Although a fresh installation of  Ubuntu is relatively safe for immediate use on the Internet, it is  important to have a balanced understanding of your system’s security  posture based on how it will be used after deployment.

This chapter provides an overview of security-related topics as they  pertain to Ubuntu DISTRO-REV Server Edition, and outlines simple  measures you may use to protect your server and network from any number  of potential security threats.

# User Management

User management is a critical part of maintaining a secure system.  Ineffective user and privilege management often lead many systems into  being compromised. Therefore, it is important that you understand how  you can protect your server through simple and effective user account  management techniques.

## Where is root?

Ubuntu developers made a conscientious decision to disable the  administrative root account by default in all Ubuntu installations. This does not mean that the root account has been deleted or that it may not be accessed. It merely has been given a password hash which matches no  possible value, therefore may not log in directly by itself.

Instead, users are encouraged to make use of a tool by the name of  ‘sudo’ to carry out system administrative duties. Sudo allows an  authorized user to temporarily elevate their privileges using their own  password instead of having to know the password belonging to the root  account. This simple yet effective methodology provides accountability  for all user actions, and gives the administrator granular control over  which actions a user can perform with said privileges.

- If for some reason you wish to enable the root account, simply give it a password:

  ```
  sudo passwd
  ```

  Sudo will prompt you for your password, and then ask you to supply a new password for root as shown below:

  ```
  [sudo] password for username: (enter your own password)
  Enter new UNIX password: (enter a new password for root)
  Retype new UNIX password: (repeat new password for root)
  passwd: password updated successfully
  ```

- To disable the root account password, use the following passwd syntax:

  ```
  sudo passwd -l root
  ```

- You should read more on Sudo by reading the man page:

  ```
  man sudo
  ```

By default, the initial user created by the Ubuntu installer is a member of the group `sudo` which is added to the file `/etc/sudoers` as an authorized sudo user. If you wish to give any other account full root access through sudo, simply add them to the `sudo` group.

## Adding and Deleting Users

The process for managing local users and groups is straightforward  and differs very little from most other GNU/Linux operating systems.  Ubuntu and other Debian based distributions encourage the use of the  ‘adduser’ package for account management.

- To add a user account, use the following syntax, and follow the  prompts to give the account a password and identifiable characteristics, such as a full name, phone number, etc.

  ```
  sudo adduser username
  ```

- To delete a user account and its primary group, use the following syntax:

  ```
  sudo deluser username
  ```

  Deleting an account does not remove their respective home folder. It  is up to you whether or not you wish to delete the folder manually or  keep it according to your desired retention policies.

  Remember, any user added later on with the same UID/GID as the  previous owner will now have access to this folder if you have not taken the necessary precautions.

  You may want to change these UID/GID values to something more  appropriate, such as the root account, and perhaps even relocate the  folder to avoid future conflicts:

  ```
  sudo chown -R root:root /home/username/
  sudo mkdir /home/archived_users/
  sudo mv /home/username /home/archived_users/
  ```

- To temporarily lock or unlock a user password, use the following syntax, respectively:

  ```
  sudo passwd -l username
  sudo passwd -u username
  ```

- To add or delete a personalized group, use the following syntax, respectively:

  ```
  sudo addgroup groupname
  sudo delgroup groupname
  ```

- To add a user to a group, use the following syntax:

  ```
  sudo adduser username groupname
  ```

## User Profile Security

When a new user is created, the adduser utility creates a brand new home directory named `/home/username`. The default profile is modeled after the contents found in the directory of `/etc/skel`, which includes all profile basics.

If your server will be home to multiple users, you should pay close  attention to the user home directory permissions to ensure  confidentiality. By default, user home directories in Ubuntu are created with world read/execute permissions. This means that all users can  browse and access the contents of other users home directories. This may not be suitable for your environment.

- To verify your current user home directory permissions, use the following syntax:

  ```
  ls -ld /home/username
  ```

  The following output shows that the directory `/home/username` has world-readable permissions:

  ```
  drwxr-xr-x  2 username username    4096 2007-10-02 20:03 username
  ```

- You can remove the world readable-permissions using the following syntax:

  ```
  sudo chmod 0750 /home/username
  ```

  > **Note**
  >
  > Some people tend to use the recursive option (-R) indiscriminately  which modifies all child folders and files, but this is not necessary,  and may yield other undesirable results. The parent directory alone is  sufficient for preventing unauthorized access to anything below the  parent.

  A much more efficient approach to the matter would be to modify the  adduser global default permissions when creating user home folders.  Simply edit the file `/etc/adduser.conf` and modify the `DIR_MODE` variable to something appropriate, so that all new home directories will receive the correct permissions.

  ```
  DIR_MODE=0750
  ```

- After correcting the directory permissions using any of the  previously mentioned techniques, verify the results using the following  syntax:

  ```
  ls -ld /home/username
  ```

  The results below show that world-readable permissions have been removed:

  ```
  drwxr-x---   2 username username    4096 2007-10-02 20:03 username
  ```

## Password Policy

A strong password policy is one of the most important aspects of your security posture. Many successful security breaches involve simple  brute force and dictionary attacks against weak passwords. If you intend to offer any form of remote access involving your local password  system, make sure you adequately address minimum password complexity  requirements, maximum password lifetimes, and frequent audits of your  authentication systems.

### Minimum Password Length

By default, Ubuntu requires a minimum password length of 6  characters, as well as some basic entropy checks. These values are  controlled in the file `/etc/pam.d/common-password`, which is outlined below.

```
password        [success=1 default=ignore]      pam_unix.so obscure sha512
```

If you would like to adjust the minimum length to 8 characters,  change the appropriate variable to min=8. The modification is outlined  below.

```
password        [success=1 default=ignore]      pam_unix.so obscure sha512 minlen=8
```

> **Note**
>
> Basic password entropy checks and minimum length rules do not apply  to the administrator using sudo level commands to setup a new user.

### Password Expiration

When creating user accounts, you should make it a policy to have a  minimum and maximum password age forcing users to change their passwords when they expire.

- To easily view the current status of a user account, use the following syntax:

  ```
  sudo chage -l username
  ```

  The output below shows interesting facts about the user account, namely that there are no policies applied:

  ```
  Last password change                                    : Jan 20, 2015
  Password expires                                        : never
  Password inactive                                       : never
  Account expires                                         : never
  Minimum number of days between password change          : 0
  Maximum number of days between password change          : 99999
  Number of days of warning before password expires       : 7
  ```

- To set any of these values, simply use the following syntax, and follow the interactive prompts:

  ```
  sudo chage username
  ```

  The following is also an example of how you can manually change the  explicit expiration date (-E) to 01/31/2015, minimum password age (-m)  of 5 days, maximum password age (-M) of 90 days, inactivity period (-I)  of 30 days after password expiration, and a warning time period (-W) of  14 days before password expiration:

  ```
  sudo chage -E 01/31/2015 -m 5 -M 90 -I 30 -W 14 username
  ```

- To verify changes, use the same syntax as mentioned previously:

  ```
  sudo chage -l username
  ```

  The output below shows the new policies that have been established for the account:

  ```
  Last password change                                    : Jan 20, 2015
  Password expires                                        : Apr 19, 2015
  Password inactive                                       : May 19, 2015
  Account expires                                         : Jan 31, 2015
  Minimum number of days between password change          : 5
  Maximum number of days between password change          : 90
  Number of days of warning before password expires       : 14
  ```

## Other Security Considerations

Many applications use alternate authentication mechanisms that can be easily overlooked by even experienced system administrators. Therefore, it is important to understand and control how users authenticate and  gain access to services and applications on your server.

### SSH Access by Disabled Users

Simply disabling/locking a user password will not prevent a user from logging into your server remotely if they have previously set up SSH  public key authentication. They will still be able to gain shell access  to the server, without the need for any password. Remember to check the  users home directory for files that will allow for this type of  authenticated SSH access, e.g. `/home/username/.ssh/authorized_keys`.

Remove or rename the directory `.ssh/` in the user’s home folder to prevent further SSH authentication capabilities.

Be sure to check for any established SSH connections by the disabled  user, as it is possible they may have existing inbound or outbound  connections. Kill any that are found.

```
who | grep username  (to get the pts/# terminal)
sudo pkill -f pts/#
```

Restrict SSH access to only user accounts that should have it. For  example, you may create a group called “sshlogin” and add the group name as the value associated with the `AllowGroups` variable located in the file `/etc/ssh/sshd_config`.

```
AllowGroups sshlogin
```

Then add your permitted SSH users to the group “sshlogin”, and restart the SSH service.

```
sudo adduser username sshlogin
sudo systemctl restart sshd.service
```

### External User Database Authentication

Most enterprise networks require centralized authentication and  access controls for all system resources. If you have configured your  server to authenticate users against external databases, be sure to  disable the user accounts both externally and locally. This way you  ensure that local fallback authentication is not possible.

# AppArmor

AppArmor is a Linux Security Module implementation of name-based  mandatory access controls. AppArmor confines individual programs to a  set of listed files and posix 1003.1e draft capabilities.

AppArmor is installed and loaded by default. It uses *profiles* of an application to determine what files and permissions the  application requires. Some packages will install their own profiles, and additional profiles can be found in the apparmor-profiles package.

To install the apparmor-profiles package from a terminal prompt:

```
sudo apt install apparmor-profiles
```

AppArmor profiles have two modes of execution:

- Complaining/Learning: profile violations are permitted and logged. Useful for testing and developing new profiles.
- Enforced/Confined: enforces profile policy as well as logging the violation.

## Using AppArmor

The optional apparmor-utils package contains command line utilities  that you can use to change the AppArmor execution mode, find the status  of a profile, create new profiles, etc.

- apparmor_status is used to view the current status of AppArmor profiles.

  ```
  sudo apparmor_status
  ```

- aa-complain places a profile into *complain* mode.

  ```
  sudo aa-complain /path/to/bin
  ```

- aa-enforce places a profile into *enforce* mode.

  ```
  sudo aa-enforce /path/to/bin
  ```

- The `/etc/apparmor.d` directory is where the AppArmor profiles are located. It can be used to manipulate the *mode* of all profiles.

  Enter the following to place all profiles into complain mode:

  ```
  sudo aa-complain /etc/apparmor.d/*
  ```

  To place all profiles in enforce mode:

  ```
  sudo aa-enforce /etc/apparmor.d/*
  ```



- apparmor_parser is used to load a profile into the kernel. It can also be used to reload a currently loaded profile using the *-r* option after modifying it to have the changes take effect.
   To reload a profile:

  ```
  sudo apparmor_parser -r /etc/apparmor.d/profile.name
  ```

- `systemctl` can be used to *reload* all profiles:

  ```
  sudo systemctl reload apparmor.service
  ```

- The `/etc/apparmor.d/disable` directory can be used along with the apparmor_parser -R option to *disable* a profile.

  ```
  sudo ln -s /etc/apparmor.d/profile.name /etc/apparmor.d/disable/
  sudo apparmor_parser -R /etc/apparmor.d/profile.name
  ```

  To *re-enable* a disabled profile remove the symbolic link to the profile in `/etc/apparmor.d/disable/`. Then load the profile using the *-a* option.

  ```
  sudo rm /etc/apparmor.d/disable/profile.name
  cat /etc/apparmor.d/profile.name | sudo apparmor_parser -a
  ```

- AppArmor can be disabled, and the kernel module unloaded by entering the following:

  ```
  sudo systemctl stop apparmor.service
  sudo systemctl disable apparmor.service
  ```

- To re-enable AppArmor enter:

  ```
  sudo systemctl enable apparmor.service
  sudo systemctl start apparmor.service
  ```

> **Note**
>
> Replace *profile.name* with the name of the profile you want to manipulate. Also, replace `/path/to/bin/` with the actual executable file path. For example for the ping command use `/bin/ping`

## Profiles

AppArmor profiles are simple text files located in `/etc/apparmor.d/`. The files are named after the full path to the executable they profile replacing the “/” with “.”. For example `/etc/apparmor.d/bin.ping` is the AppArmor profile for the `/bin/ping` command.

There are two main type of rules used in profiles:

- *Path entries:* detail which files an application can access in the file system.
- *Capability entries:* determine what privileges a confined process is allowed to use.

As an example, take a look at `/etc/apparmor.d/bin.ping`:

```
#include <tunables/global>
/bin/ping flags=(complain) {
  #include <abstractions/base>
  #include <abstractions/consoles>
  #include <abstractions/nameservice>

  capability net_raw,
  capability setuid,
  network inet raw,
  
  /bin/ping mixr,
  /etc/modules.conf r,
}
```

- *#include <tunables/global>:* include statements from other files. This allows statements pertaining to multiple applications to be placed in a common file.
- */bin/ping flags=(complain):* path to the profiled program, also setting the mode to *complain*.
- *capability net_raw,:* allows the application access to the CAP_NET_RAW Posix.1e capability.
- */bin/ping mixr,:* allows the application read and execute access to the file.

> **Note**
>
> After editing a profile file the profile must be reloaded. See above at [Using AppArmor](https://ubuntu.com/server/docs/security-apparmor#loadrules) for details.

### Creating a Profile

- *Design a test plan:* Try to think about how the application  should be exercised. The test plan should be divided into small test  cases. Each test case should have a small description and list the steps to follow.

  Some standard test cases are:

  - Starting the program.
  - Stopping the program.
  - Reloading the program.
  - Testing all the commands supported by the init script.

- *Generate the new profile:* Use aa-genprof to generate a new profile. From a terminal:

  ```
  sudo aa-genprof executable
  ```

  For example:

  ```
  sudo aa-genprof slapd
  ```

- To get your new profile included in the apparmor-profiles package, file a bug in *Launchpad* against the [AppArmor](https://bugs.launchpad.net/ubuntu/+source/apparmor/+filebug) package:

  - Include your test plan and test cases.
  - Attach your new profile to the bug.

### Updating Profiles

When the program is misbehaving, audit messages are sent to the log  files. The program aa-logprof can be used to scan log files for AppArmor audit messages, review them and update the profiles. From a terminal:

```
sudo aa-logprof
```

### Further pre-existing Profiles

The packages `apport-profiles` and `apparmor-profiles-extra` ship some experimental profiles for AppArmor security policies.
 Do not expect these profiles to work out-of-the-box, but they can give  you a head start when trynig to create a new profile by starting off a  base that exists.

These profiles are not considered mature enough to be shipped in  enforce mode by default. Therefore they are shipped in complain mode so  that users can test them, choose which are desired, and help improve  them upstream if needed.

Some even more experimental profiles carried by the package are placed in` /usr/share/doc/apparmor-profiles/extras/`

## Checking and debugging denies

You will see in ‘dmesg’ and any log that collects kernel messages if you have hit a deny.
 Right away it is worth to know that this will cover any access that was denied `because it was not allowed`, but `explicit denies` will put no message in your logs at all.

Examples might look like:

```
[1521056.552037] audit: type=1400 audit(1571868402.378:24425): apparmor="DENIED" operation="open" profile="/usr/sbin/cups-browsed" name="/var/lib/libvirt/dnsmasq/" pid=1128 comm="cups-browsed" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[1482106.651527] audit: type=1400 audit(1571829452.330:24323): apparmor="DENIED" operation="sendmsg" profile="snap.lxd.lxc" pid=24115 comm="lxc" laddr=10.7.0.69 lport=48796 faddr=10.7.0.231 fport=445 family="inet" sock_type="stream" protocol=6 requested_mask="send" denied_mask="send"
```

That follows a generic structure starting with a timestamp, an audit tag and the category `apparmor="DENIED"`.
 From the following fields you can derive what was going on and why it was failing.

In the examples above that would be

First example:

- operation: `open` (program tried to open a file)
- profile: `/usr/sbin/cups-browsed` (you’ll find `/etc/apparmor.d/usr.bin.cups-browsed`)
- name: `/var/lib/libvirt/dnsmasq` (what it wanted to access)
- pid/comm: the program that did trigger the access
- requested_mask/denied_mask/fsuid/ouid: parameters of that open call

Second example:

- operation: `sendmsg` (program tried send via network)
- profile: `snap.lxd.lxc` (snaps are special, you’ll find `/var/lib/snapd/apparmor/profiles/snap.lxd.lxc`)
- pid/comm: the program that did trigger the access
- laddr/lport/faddr/fport/family/sock_type/protocol: parameters of that sendmsg call

That way you know in which profile and at what action you have to  start if you consider either debugging or adapting the profiles.

## Profile customization

Profiles are meant to provide security and thereby can’t be all too  open. But quite often a very special setup would work with a profile if  it wold *just allow this one extra access*. To handle that there are three ways.

- modify the profile itself
  - always works, but has the drawback that profiles are in /etc and  considered conffiles. So after modification on a related package update  you might get a conffile prompt. Worst case depending on configuration  automatic updates might even override it and your custom rule is gone.
- use tunables
  - those provide variables that can be used in templates, for example  if you want a custom dir considered as it would be a home directory you  could modify `/etc/apparmor.d/tunables/home` which defines the base path rules use for home directories
  - by design those variables will only influence profiles that use them
- modify a local override
  - to mitigate the drawbacks of above approaches *local includes* got introduced adding the ability to write arbitrary rules that will be used, and not get issues on upgrades that modify the packaged rule.
  - The files can be found in `/etc/apparmor.d/local/` and exist for the packages that are known to sometimes need slight tweaks for special setups

## References

- See the [AppArmor Administration Guide](http://www.novell.com/documentation/apparmor/apparmor201_sp10_admin/index.html?page=/documentation/apparmor/apparmor201_sp10_admin/data/book_apparmor_admin.html) for advanced configuration options.
- For details using AppArmor with other Ubuntu releases see the [AppArmor Community Wiki](https://help.ubuntu.com/community/AppArmor) page.
- The [OpenSUSE AppArmor](http://en.opensuse.org/SDB:AppArmor_geeks) page is another introduction to AppArmor.
- (https://wiki.debian.org/AppArmor) is another introduction and basic howto for AppArmor.
- A great place to ask for AppArmor assistance, and get involved with the Ubuntu Server community, is the *#ubuntu-hardened* IRC channel on [freenode](http://freenode.net).

# Firewall

## Introduction

The Linux kernel includes the *Netfilter* subsystem, which is  used to manipulate or decide the fate of network traffic headed into or  through your server. All modern Linux firewall solutions use this system for packet filtering.

The kernel’s packet filtering system would be of little use to  administrators without a userspace interface to manage it. This is the  purpose of iptables: When a packet reaches your server, it will be  handed off to the Netfilter subsystem for acceptance, manipulation, or  rejection based on the rules supplied to it from userspace via iptables. Thus, iptables is all you need to manage your firewall, if you’re  familiar with it, but many frontends are available to simplify the task.

## ufw - Uncomplicated Firewall

The default firewall configuration tool for Ubuntu is ufw. Developed  to ease iptables firewall configuration, ufw provides a user-friendly  way to create an IPv4 or IPv6 host-based firewall.

ufw by default is initially disabled. From the ufw man page:

“ufw is not intended to provide complete firewall functionality via  its command interface, but instead provides an easy way to add or remove simple rules. It is currently mainly used for host-based firewalls.”

The following are some examples of how to use ufw:

- First, ufw needs to be enabled. From a terminal prompt enter:

  ```
  sudo ufw enable
  ```

- To open a port (SSH in this example):

  ```
  sudo ufw allow 22
  ```

- Rules can also be added using a *numbered* format:

  ```
  sudo ufw insert 1 allow 80
  ```

- Similarly, to close an opened port:

  ```
  sudo ufw deny 22
  ```

- To remove a rule, use delete followed by the rule:

  ```
  sudo ufw delete deny 22
  ```

- It is also possible to allow access from specific hosts or networks  to a port. The following example allows SSH access from host 192.168.0.2 to any IP address on this host:

  ```
  sudo ufw allow proto tcp from 192.168.0.2 to any port 22
  ```

  Replace 192.168.0.2 with 192.168.0.0/24 to allow SSH access from the entire subnet.

- Adding the *–dry-run* option to a *ufw* command will  output the resulting rules, but not apply them. For example, the  following is what would be applied if opening the HTTP port:

  ```auto
   sudo ufw --dry-run allow http
  ```

  ```
  *filter
  :ufw-user-input - [0:0]
  :ufw-user-output - [0:0]
  :ufw-user-forward - [0:0]
  :ufw-user-limit - [0:0]
  :ufw-user-limit-accept - [0:0]
  ### RULES ###
  
  ### tuple ### allow tcp 80 0.0.0.0/0 any 0.0.0.0/0
  -A ufw-user-input -p tcp --dport 80 -j ACCEPT
  
  ### END RULES ###
  -A ufw-user-input -j RETURN
  -A ufw-user-output -j RETURN
  -A ufw-user-forward -j RETURN
  -A ufw-user-limit -m limit --limit 3/minute -j LOG --log-prefix "[UFW LIMIT]: "
  -A ufw-user-limit -j REJECT
  -A ufw-user-limit-accept -j ACCEPT
  COMMIT
  Rules updated
  ```

- ufw can be disabled by:

  ```
  sudo ufw disable
  ```

- To see the firewall status, enter:

  ```
  sudo ufw status
  ```

- And for more verbose status information use:

  ```
  sudo ufw status verbose
  ```

- To view the *numbered* format:

  ```
  sudo ufw status numbered
  ```

> **Note**
>
> If the port you want to open or close is defined in `/etc/services`, you can use the port name instead of the number. In the above examples, replace *22* with *ssh*.

This is a quick introduction to using ufw. Please refer to the ufw man page for more information.

### ufw Application Integration

Applications that open ports can include an ufw profile, which  details the ports needed for the application to function properly. The  profiles are kept in `/etc/ufw/applications.d`, and can be edited if the default ports have been changed.

- To view which applications have installed a profile, enter the following in a terminal:

  ```
  sudo ufw app list
  ```

- Similar to allowing traffic to a port, using an application profile is accomplished by entering:

  ```
  sudo ufw allow Samba
  ```

- An extended syntax is available as well:

  ```
  ufw allow from 192.168.0.0/24 to any app Samba
  ```

  Replace *Samba* and *192.168.0.0/24* with the application profile you are using and the IP range for your network.

  > **Note**
  >
  > There is no need to specify the *protocol* for the application, because that information is detailed in the profile. Also, note that the *app* name replaces the *port* number.

- To view details about which ports, protocols, etc., are defined for an application, enter:

  ```
  sudo ufw app info Samba
  ```

Not all applications that require opening a network port come with  ufw profiles, but if you have profiled an application and want the file  to be included with the package, please file a bug against the package  in Launchpad.

```
ubuntu-bug nameofpackage
```

## IP Masquerading

The purpose of IP Masquerading is to allow machines with private,  non-routable IP addresses on your network to access the Internet through the machine doing the masquerading. Traffic from your private network  destined for the Internet must be manipulated for replies to be routable back to the machine that made the request. To do this, the kernel must  modify the *source* IP address of each packet so that replies  will be routed back to it, rather than to the private IP address that  made the request, which is impossible over the Internet. Linux uses *Connection Tracking* (conntrack) to keep track of which connections belong to which machines and reroute each return packet accordingly. Traffic leaving your  private network is thus “masqueraded” as having originated from your  Ubuntu gateway machine. This process is referred to in Microsoft  documentation as Internet Connection Sharing.

### ufw Masquerading

IP Masquerading can be achieved using custom ufw rules. This is  possible because the current back-end for ufw is iptables-restore with  the rules files located in `/etc/ufw/*.rules`. These files  are a great place to add legacy iptables rules used without ufw, and  rules that are more network gateway or bridge related.

The rules are split into two different files, rules that should be  executed before ufw command line rules, and rules that are executed  after ufw command line rules.

- First, packet forwarding needs to be enabled in ufw. Two configuration files will need to be adjusted, in `/etc/default/ufw` change the *DEFAULT_FORWARD_POLICY* to “ACCEPT”:

  ```
  DEFAULT_FORWARD_POLICY="ACCEPT"
  ```

  Then edit `/etc/ufw/sysctl.conf` and uncomment:

  ```
  net/ipv4/ip_forward=1
  ```

  Similarly, for IPv6 forwarding uncomment:

  ```
  net/ipv6/conf/default/forwarding=1
  ```

- Now add rules to the `/etc/ufw/before.rules` file. The default rules only configure the *filter* table, and to enable masquerading the *nat* table will need to be configured. Add the following to the top of the file just after the header comments:

  ```
  # nat Table rules
  *nat
  :POSTROUTING ACCEPT [0:0]
  
  # Forward traffic from eth1 through eth0.
  -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
  
  # don't delete the 'COMMIT' line or these nat table rules won't be processed
  COMMIT
  ```

  The comments are not strictly necessary, but it is considered good  practice to document your configuration. Also, when modifying any of the *rules* files in `/etc/ufw`, make sure these lines are the last line for each table modified:

  ```
  # don't delete the 'COMMIT' line or these rules won't be processed
  COMMIT
  ```

  For each *Table* a corresponding *COMMIT* statement is required. In these examples only the *nat* and *filter* tables are shown, but you can also add rules for the *raw* and *mangle* tables.

  > **Note**
  >
  > In the above example replace *eth0*, *eth1*, and *192.168.0.0/24* with the appropriate interfaces and IP range for your network.

- Finally, disable and re-enable ufw to apply the changes:

  ```
  sudo ufw disable && sudo ufw enable
  ```

IP Masquerading should now be enabled. You can also add any additional FORWARD rules to the `/etc/ufw/before.rules`. It is recommended that these additional rules be added to the *ufw-before-forward* chain.

### iptables Masquerading

iptables can also be used to enable Masquerading.

- Similar to ufw, the first step is to enable IPv4 packet forwarding by editing `/etc/sysctl.conf` and uncomment the following line:

  ```
  net.ipv4.ip_forward=1
  ```

  If you wish to enable IPv6 forwarding also uncomment:

  ```
  net.ipv6.conf.default.forwarding=1
  ```

- Next, execute the sysctl command to enable the new settings in the configuration file:

  ```
  sudo sysctl -p
  ```

- IP Masquerading can now be accomplished with a single iptables rule,  which may differ slightly based on your network configuration:

  ```
  sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

  The above command assumes that your private address space is  192.168.0.0/16 and that your Internet-facing device is ppp0. The syntax  is broken down as follows:

  - -t nat – the rule is to go into the nat table
  - -A POSTROUTING – the rule is to be appended (-A) to the POSTROUTING chain
  - -s 192.168.0.0/16 – the rule applies to traffic originating from the specified address space
  - -o ppp0 – the rule applies to traffic scheduled to be routed through the specified network device
  - -j MASQUERADE – traffic matching this rule is to “jump” (-j) to the MASQUERADE target to be manipulated as described above

- Also, each chain in the filter table (the default table, and where most or all packet filtering occurs) has a default *policy* of ACCEPT, but if you are creating a firewall in addition to a gateway  device, you may have set the policies to DROP or REJECT, in which case  your masqueraded traffic needs to be allowed through the FORWARD chain  for the above rule to work:

  ```
  sudo iptables -A FORWARD -s 192.168.0.0/16 -o ppp0 -j ACCEPT
  sudo iptables -A FORWARD -d 192.168.0.0/16 -m state \
  --state ESTABLISHED,RELATED -i ppp0 -j ACCEPT
  ```

  The above commands will allow all connections from your local network to the Internet and all traffic related to those connections to return  to the machine that initiated them.

- If you want masquerading to be enabled on reboot, which you probably do, edit `/etc/rc.local` and add any commands used above. For example add the first command with no filtering:

  ```
  iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

## Logs

Firewall logs are essential for recognizing attacks, troubleshooting  your firewall rules, and noticing unusual activity on your network. You  must include logging rules in your firewall for them to be generated,  though, and logging rules must come before any applicable terminating  rule (a rule with a target that decides the fate of the packet, such as  ACCEPT, DROP, or REJECT).

If you are using ufw, you can turn on logging by entering the following in a terminal:

```
sudo ufw logging on
```

To turn logging off in ufw, simply replace *on* with *off* in the above command.

If using iptables instead of ufw, enter:

```
sudo iptables -A INPUT -m state --state NEW -p tcp --dport 80 \
-j LOG --log-prefix "NEW_HTTP_CONN: "
```

A request on port 80 from the local machine, then, would generate a  log in dmesg that looks like this (single line split into 3 to fit this  document):

```
[4304885.870000] NEW_HTTP_CONN: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00
SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=58288 DF PROTO=TCP
SPT=53981 DPT=80 WINDOW=32767 RES=0x00 SYN URGP=0
```

The above log will also appear in `/var/log/messages`, `/var/log/syslog`, and `/var/log/kern.log`. This behavior can be modified by editing `/etc/syslog.conf` appropriately or by installing and configuring ulogd and using the ULOG target instead of LOG. The ulogd daemon is a userspace server that  listens for logging instructions from the kernel specifically for  firewalls, and can log to any file you like, or even to a PostgreSQL or  MySQL database. Making sense of your firewall logs can be simplified by  using a log analyzing tool such as logwatch, fwanalog, fwlogwatch, or  lire.

## Other Tools

There are many tools available to help you construct a complete  firewall without intimate knowledge of iptables. A command-line tool  with plain-text configuration files:

- [Shorewall](http://www.shorewall.net/) is a very powerful solution to help you configure an advanced firewall for any network.

## References

- The [Ubuntu Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) wiki page contains information on the development of ufw.
- Also, the ufw manual page contains some very useful information: `man ufw`.
- See the [packet-filtering-HOWTO](http://www.netfilter.org/documentation/HOWTO/packet-filtering-HOWTO.html) for more information on using iptables.
- The [nat-HOWTO](http://www.netfilter.org/documentation/HOWTO/NAT-HOWTO.html) contains further details on masquerading.
- The [IPTables HowTo](https://help.ubuntu.com/community/IptablesHowTo) in the Ubuntu wiki is a great resource.

# Certificates

One of the most common forms of cryptography today is *public-key* cryptography. Public-key cryptography utilizes a *public key* and a *private key*. The system works by encrypting information using the public key. The  information can then only be decrypted using the private key.

A common use for public-key cryptography is encrypting application  traffic using a Secure Socket Layer (SSL) or Transport Layer Security  (TLS) connection. One example: configuring Apache to provide *HTTPS*, the HTTP protocol over SSL/TLS. This allows a way to encrypt traffic using a protocol that does not itself provide encryption.

A *certificate* is a method used to distribute a *public key* and other information about a server and the organization who is responsible for it. Certificates can be digitally signed by a *Certification Authority*, or CA. A CA is a trusted third party that has confirmed that the information contained in the certificate is accurate.

## Types of Certificates

To set up a secure server using public-key cryptography, in most  cases, you send your certificate request (including your public key),  proof of your company’s identity, and payment to a CA. The CA verifies  the certificate request and your identity, and then sends back a  certificate for your secure server. Alternatively, you can create your  own *self-signed* certificate.

> **Note**
>
> Note that self-signed certificates should not be used in most production environments.

Continuing the HTTPS example, a CA-signed certificate provides two  important capabilities that a self-signed certificate does not:

- Browsers (usually) automatically recognize the CA signature and allow a secure connection to be made without prompting the user.
- When a CA issues a signed certificate, it is guaranteeing the  identity of the organization that is providing the web pages to the  browser.

Most of the software supporting SSL/TLS have a list of CAs whose  certificates they automatically accept. If a browser encounters a  certificate whose authorizing CA is not in the list, the browser asks  the user to either accept or decline the connection. Also, other  applications may generate an error message when using a self-signed  certificate.

The process of getting a certificate from a CA is fairly easy. A quick overview is as follows:

1. Create a private and public encryption key pair.

2. Create a certificate signing request based on the public key. The  certificate request contains information about your server and the  company hosting it.

3. Send the certificate request, along with documents proving your  identity, to a CA. We cannot tell you which certificate authority to  choose. Your decision may be based on your past experiences, or on the  experiences of your friends or colleagues, or purely on monetary  factors.

   Once you have decided upon a CA, you need to follow the instructions they provide on how to obtain a certificate from them.

4. When the CA is satisfied that you are indeed who you claim to be, they send you a digital certificate.

5. Install this certificate on your secure server, and configure the appropriate applications to use the certificate.

## Generating a Certificate Signing Request (CSR)

Whether you are getting a certificate from a CA or generating your  own self-signed certificate, the first step is to generate a key.

If the certificate will be used by service daemons, such as Apache,  Postfix, Dovecot, etc., a key without a passphrase is often appropriate. Not having a passphrase allows the services to start without manual  intervention, usually the preferred way to start a daemon.

This section will cover generating a key with a passphrase, and one  without. The non-passphrase key will then be used to generate a  certificate that can be used with various service daemons.

> **Warning**
>
> Running your secure service without a passphrase is convenient  because you will not need to enter the passphrase every time you start  your secure service. But it is insecure and a compromise of the key  means a compromise of the server as well.

To generate the *keys* for the Certificate Signing Request (CSR) run the following command from a terminal prompt:

```
openssl genrsa -des3 -out server.key 2048

Generating RSA private key, 2048 bit long modulus
..........................++++++
.......++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:
```

You can now enter your passphrase. For best security, it should at  least contain eight characters. The minimum length when specifying `-des3` is four characters. As a best practice it should include numbers and/or punctuation and not be a word in a dictionary. Also remember that your  passphrase is case-sensitive.

Re-type the passphrase to verify. Once you have re-typed it correctly, the server key is generated and stored in the `server.key` file.

Now create the insecure key, the one without a passphrase, and shuffle the key names:

```
openssl rsa -in server.key -out server.key.insecure
mv server.key server.key.secure
mv server.key.insecure server.key
```

The insecure key is now named `server.key`, and you can use this file to generate the CSR without passphrase.

To create the CSR, run the following command at a terminal prompt:

```
openssl req -new -key server.key -out server.csr
```

It will prompt you enter the passphrase. If you enter the correct  passphrase, it will prompt you to enter Company Name, Site Name, Email  Id, etc. Once you enter all these details, your CSR will be created and  it will be stored in the `server.csr` file.

You can now submit this CSR file to a CA for processing. The CA will  use this CSR file and issue the certificate. On the other hand, you can  create self-signed certificate using this CSR.

## Creating a Self-Signed Certificate

To create the self-signed certificate, run the following command at a terminal prompt:

```
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

The above command will prompt you to enter the passphrase. Once you  enter the correct passphrase, your certificate will be created and it  will be stored in the `server.crt` file.

> **Warning**
>
> If your secure server is to be used in a production environment, you  probably need a CA-signed certificate. It is not recommended to use  self-signed certificate.

## Installing the Certificate

You can install the key file `server.key` and certificate file `server.crt`, or the certificate file issued by your CA, by running following commands at a terminal prompt:

```
sudo cp server.crt /etc/ssl/certs
sudo cp server.key /etc/ssl/private
```

Now simply configure any applications, with the ability to use public-key cryptography, to use the *certificate* and *key* files. For example, Apache can provide HTTPS, Dovecot can provide IMAPS and POP3S, etc.

## Certification Authority

If the services on your network require more than a few self-signed  certificates it may be worth the additional effort to setup your own  internal Certification Authority (CA). Using certificates signed by your own CA, allows the various services using the certificates to easily  trust other services using certificates issued from the same CA.

First, create the directories to hold the CA certificate and related files:

```
sudo mkdir /etc/ssl/CA
sudo mkdir /etc/ssl/newcerts
```

The CA needs a few additional files to operate, one to keep track of  the last serial number used by the CA, each certificate must have a  unique serial number, and another file to record which certificates have been issued:

```
sudo sh -c "echo '01' > /etc/ssl/CA/serial"
sudo touch /etc/ssl/CA/index.txt
```

The third file is a CA configuration file. Though not strictly  necessary, it is very convenient when issuing multiple certificates.  Edit `/etc/ssl/openssl.cnf`, and in the *[ CA_default ]* change:

```
dir             = /etc/ssl              # Where everything is kept
database        = $dir/CA/index.txt     # database index file.
certificate     = $dir/certs/cacert.pem # The CA certificate
serial          = $dir/CA/serial        # The current serial number
private_key     = $dir/private/cakey.pem# The private key
```

Next, create the self-signed root certificate:

```
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
```

You will then be asked to enter the details about the certificate.

Now install the root certificate and key:

```
sudo mv cakey.pem /etc/ssl/private/
sudo mv cacert.pem /etc/ssl/certs/
```

You are now ready to start signing certificates. The first item needed is a Certificate Signing Request (CSR), see [Generating a Certificate Signing Request (CSR)](https://ubuntu.com/server/docs/security-certificates#generating-a-csr) for details. Once you have a CSR, enter the following to generate a certificate signed by the CA:

```
sudo openssl ca -in server.csr -config /etc/ssl/openssl.cnf
```

After entering the password for the CA key, you will be prompted to  sign the certificate, and again to commit the new certificate. You  should then see a somewhat large amount of output related to the  certificate creation.

There should now be a new file, `/etc/ssl/newcerts/01.pem`, containing the same output. Copy and paste everything beginning with the line: *-----BEGIN CERTIFICATE-----* and continuing through the line: *----END CERTIFICATE-----* lines to a file named after the hostname of the server where the certificate will be installed. For example `mail.example.com.crt`, is a nice descriptive name.

Subsequent certificates will be named `02.pem`, `03.pem`, etc.

> **Note**
>
> Replace *mail.example.com.crt* with your own descriptive name.

Finally, copy the new certificate to the host that needs it, and  configure the appropriate applications to use it. The default location  to install certificates is `/etc/ssl/certs`. This enables multiple services to use the same certificate without overly complicated file permissions.

For applications that can be configured to use a CA certificate, you should also copy the `/etc/ssl/certs/cacert.pem` file to the `/etc/ssl/certs/` directory on each server.

## References

- The Wikipedia [HTTPS](http://en.wikipedia.org/wiki/HTTPS) page has more information regarding HTTPS.
- For more information on *OpenSSL* see the [OpenSSL Home Page](https://www.openssl.org/).
- Also, O’Reilly’s [Network Security with OpenSSL](http://oreilly.com/catalog/9780596002701/) is a good in-depth reference.

# Console Security

As with any other security barrier you put in place to protect your  server, it is pretty tough to defend against untold damage caused by  someone with physical access to your environment, for example, theft of  hard drives, power or service disruption, and so on. Therefore, console  security should be addressed merely as one component of your overall  physical security strategy. A locked “screen door” may deter a casual  criminal, or at the very least slow down a determined one, so it is  still advisable to perform basic precautions with regard to console  security.

The following instructions will help defend your server against issues that could otherwise yield very serious consequences.

## Disable Ctrl+Alt+Delete

Anyone that has physical access to the keyboard can simply use the Ctrl+Alt+Delete key combination to reboot the server without having to log on. While  someone could simply unplug the power source, you should still prevent  the use of this key combination on a production server. This forces an  attacker to take more drastic measures to reboot the server, and will  prevent accidental reboots at the same time.

To disable the reboot action taken by pressing the Ctrl+Alt+Delete key combination, run the following two commands:

```
sudo systemctl mask ctrl-alt-del.target
sudo systemctl daemon-reload
```

Virtualization is being adopted in many different environments and  situations. If you are a developer, virtualization can provide you with a contained environment where you can safely do almost any sort of  development safe from messing up your main working environment. If you  are a systems administrator, you can use virtualization to more easily  separate your services and move them around based on demand.

The default virtualization technology supported in Ubuntu is [KVM](https://www.linux-kvm.org/page/Main_Page). For Intel and AMD hardware KVM requires virtualization extensions. But  KVM is also available for IBM Z and LinuxONE, IBM POWER as well as for  ARM64.
 [Qemu](https://www.qemu.org/) is part of the [KVM](https://wiki.qemu.org/Features/KVM) experience being the userspace backend for it, but it also can be used  for hardware without virtualization extensions by using its [TCG](https://wiki.qemu.org/Features/TCG) mode.

While virtualization is in many ways similar to containers those are different and implemented via other solutions like [LXD](https://linuxcontainers.org/lxd/introduction/), [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html), [containerd](https://containerd.io) and others.

# Qemu

[Qemu](http://wiki.qemu.org/Main_Page) is a machine  emulator that can run operating systems and programs for one machine on a different machine. Mostly it is not used as emulator but as virtualizer in collaboration with KVM kernel components. In that case it utilizes  the virtualization technology of the hardware to virtualize guests.

While qemu has a [command line interface](http://wiki.qemu.org/download/qemu-doc.html#sec_005finvocation) and a [monitor](http://wiki.qemu.org/download/qemu-doc.html#pcsys_005fmonitor) to interact with running guests those is rarely used that way for other means than development purposes. [Libvirt](https://ubuntu.com/server/docs/virtualization-qemu#libvirt) provides an abstraction from specific versions and hypervisors and encapsulates some workarounds and best practices.

## Running Qemu/KVM

While there are much more user friendly and comfortable ways, using  the command below is probably the quickest way to see some called Ubuntu moving on screen is directly running it from the netboot iso.

> **Warning**: this is just for illustration - not generally recommended without verifying the checksums; [Multipass](https://discourse.ubuntu.com/t/virtualization-multipass) and [UVTool](https://discourse.ubuntu.com/t/virtualization-uvt) are much better ways to get actual guests easily.

Run:

> ```
> sudo qemu-system-x86_64 -enable-kvm -cdrom  http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/mini.iso
> ```

You could download the ISO for faster access at runtime and e.g. add a disk to the same by:

- creating the disk

  > `qemu-img create -f qcow2 disk.qcow 5G`

- Using the disk by adding `-drive file=disk.qcow,format=qcow2`

Those tools can do much more, as you’ll find in their respective  (long) man pages. There also is a vast assortment of auxiliary tools to  make them more consumable for specific use-cases and needs - for example [virt-manager](https://virt-manager.org/) for UI driven use through libvirt. But in general - even the tools eventually use that - it comes down to:

> qemu-system-x86_64 options image[s]

So take a look at the man page of [qemu](http://manpages.ubuntu.com/manpages/bionic/man1/qemu-system.1.html), [qemu-img](http://manpages.ubuntu.com/manpages/bionic/man1/qemu-img.1.html) and the documentation of [qemu](https://www.qemu.org/documentation/) and see which options are the right one for your needs.

## Graphics

Graphics for qemu/kvm always comes in two pieces.

- A `front end` - controlled via the `-vga` argument - which is provided to the guest. Usually one of `cirrus`, `std`, `qxl`, `virtio`. The default these days is `qxl` which strikes a good balance between guest compatibility and  performance. The guest needs a driver for what is selected, which is the most common reason to switch from the default to either `cirrus ` (e.g. very old Windows versions)
- A `back end` - controlled via the `-display` argument - which is what the host uses to actually display the graphical content. That can be an application window via `gtk` or a `vnc`.
- In addition one can enable the `-spice` back-end (can be done in addition to `vnc`) which can be faster and provides more authentication methods than vnc.
- if you want no graphical output at all you can save some memory and cpu cycles by setting `-nographic`

If you run with `spice` or `vnc` you can use native vnc tools or virtualization focused tools like `virt-viewer`. More about these in the libvirt section.

All those options above are considered basic usage of graphics. There are advanced options for further needs. Those cases usually differ in  their [ease-of-use and capability](https://cpaelzer.github.io/blogs/006-mediated-device-to-pass-parts-of-your-gpu-to-a-guest/) are:

- *Need some 3D acceleration*: `-vga virtio` with a local display having a GL context `-display gtk,gl=on`; That will use  [virgil3d](https://virgil3d.github.io/) on the host and needs guest drivers for [virt3d] which are common in Linux since [Kernels >=4.4](https://www.kraxel.org/blog/2016/09/using-virtio-gpu-with-libvirt-and-spice/) but hard to get by for other cases. While not as fast as the next two  options, the big benefit is that it can be used without additional  hardware and without a proper [IOMMU setup for device passthrough](https://www.kernel.org/doc/Documentation/vfio-mediated-device.txt).
- *Need native performance*: use PCI passthrough of additional GPUs in the system. You’ll need an IOMMU setup and unbind the cards from the host before you can pass it through like `-device vfio-pci,host=05:00.0,bus=1,addr=00.0,multifunction=on,x-vga=on -device vfio-pci,host=05:00.1,bus=1,addr=00.1`
- *Need native performance, but multiple guests per card*: Like PCI Passthrough, but using mediated devices to shard a card on the Host into multiple devices and pass those like `-display gtk,gl=on -device  vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/4dd511f6-ec08-11e8-b839-2f163ddee3b3,display=on,rombar=0`. More at [kraxel on vgpu](https://www.kraxel.org/blog/2018/04/vgpu-display-support-finally-merged-upstream/) and [Ubuntu GPU mdev evaluation](https://cpaelzer.github.io/blogs/006-mediated-device-to-pass-parts-of-your-gpu-to-a-guest/). The sharding of the cards is driver specific and therefore will differ per manufacturer like [Intel](https://github.com/intel/gvt-linux/wiki/GVTg_Setup_Guide) or [Nvidia](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html).

Especially the advanced cases can get pretty complex, therefore it is recommended to use qemu through libvirt for those cases. [Libvirt](https://discourse.ubuntu.com/t/virtualization-libvirt) will take care of all but the host kernel/bios tasks of such configurations.

## Upgrading the machine type

If you are unsure what this is, you might consider this as buying  (virtual) Hardware of the same spec but a newer release date. You are  encouraged in general and might want to update your machine type of an  existing defined guests in particular to:

- to pick up latest security fixes and features
- continue using a guest created on a now unsupported release

In general it is recommended to update machine types when upgrading  qemu/kvm to a new major version. But this can likely never be an  automated task as this change is guest visible. The guest devices might  change in appearance, new features will be announced to the guest and so on. Linux is usually very good at tolerating such changes, but it  depends so much on the setup and workload of the guest that this has to  be evaluated by the owner/admin of the system. Other operating systems  where known to often have severe impacts by changing the hardware.  Consider a machine type change similar to replacing all devices and  firmware of a physical machine to the latest revision - all  considerations that apply there apply to evaluating a machine type  upgrade as well.

As usual with major configuration changes it is wise to back up your  guest definition and disk state to be able to do a rollback just in  case. There is no integrated single command to update the machine type  via virsh or similar tools. It is a normal part of your machine  definition. And therefore updated the same way as most others.

First shutdown your machine and wait until it has reached that state.

```auto
virsh shutdown <yourmachine>
# wait
virsh list --inactive
# should now list your machine as "shut off"
        
```

Then edit the machine definition and find the type in the type tag at the machine attribute.

```auto
virsh edit <yourmachine>
<type arch='x86_64' machine='pc-i440fx-bionic'>hvm</type>
        
```

Change this to the value you want. If you need to check what types  are available via “-M ?” Note that while providing upstream types as  convenience only Ubuntu types are supported. There you can also see what the current default would be. In general it is strongly recommended  that you change to newer types if possible to exploit newer features,  but also to benefit of bugfixes that only apply to the newer device  virtualization.

```auto
kvm -M ?
# lists machine types, e.g.
pc-i440fx-xenial       Ubuntu 16.04 PC (i440FX + PIIX, 1996) (default)
...
pc-i440fx-bionic       Ubuntu 18.04 PC (i440FX + PIIX, 1996) (default)
...
        
```

After this you can start your guest again. You can check the current machine type from guest and host depending on your needs.

```auto
virsh start <yourmachine>
# check from host, via dumping the active xml definition
virsh dumpxml <yourmachine> | xmllint --xpath "string(//domain/os/type/@machine)" -
# or from the guest via dmidecode (if supported)
sudo dmidecode | grep Product -A 1
        Product Name: Standard PC (i440FX + PIIX, 1996)
        Version: pc-i440fx-bionic
        
```

If you keep non-live definitions around - like xml files - remember to update those as well.

> **Note**
>
> This also is documented along some more constraints and considerations at the [Ubuntu Wiki](https://wiki.ubuntu.com/QemuKVMMigration#Upgrade_machine_type)

## QEMU usage for microvms

QEMU became another use case being used in a [container-like style providing an enhanced isolation](https://ubuntu.com/blog/what-is-kata-containers) compared to containers but being focused on initialization speed.

To achieve that several components have been added:

- the [microvm machine type](https://github.com/qemu/qemu/blob/master/docs/microvm.rst)
- alternative simple FW that can boot linux [called qboot](https://github.com/bonzini/qboot)
- qemu build with reduced features matching these use cases called `qemu-system-x86-microvm`

For example if you happen to already have a stripped down workload  that has all it would execute in an initrd you would run it maybe like  the following:

```
$ sudo qemu-system-x86_64 -M ubuntu-q35 -cpu host -m 1024  -enable-kvm -serial mon:stdio -nographic -display curses -append  'console=ttyS0,115200,8n1' -kernel vmlinuz-5.4.0-21 -initrd  /boot/initrd.img-5.4.0-21-workload
```

To run the same with `microvm`, `qboot` and the minimized qemu you would do the following

1. run it with with type microvm, so change -M to
    `-M microvm`
2. use the qboot bios, add
    `-bios /usr/share/qemu/bios-microvm.bin`
3. install the feature-minimized qemu-system package, do
    `$ sudo apt install qemu-system-x86-microvm`

An invocation will now look like:

$ sudo qemu-system-x86_64 -M microvm -bios  /usr/share/qemu/bios-microvm.bin -cpu host -m 1024 -enable-kvm -serial  mon:stdio -nographic -display curses -append ‘console=ttyS0,115200,8n1’  -kernel vmlinuz-5.4.0-21 -initrd /boot/initrd.img-5.4.0-21-workload

That will have cut down the qemu, bios and virtual-hw initialization time down a lot.
 You will now - more than you already have before - spend the majority  inside the guest which implies that further tuning probably has to go  into that kernel and userspace initialization time.

> ** Note **
>  For now microvm, the qboot bios and other components of this are rather  new upstream and not  as verified as many other parts of the  virtualization stack. Therefore none of the above is the default.  Further being the default would also mean many upgraders would regress  finding a qemu that doesn’t have most features they are used to use. Due to that the qemu-system-x86-microvm package is intentionally a strong  opt-in conflicting with the normal qemu-system-x86 package.

# libvirt

The libvirt library is used to interface with different  virtualization technologies. Before getting started with libvirt it is  best to make sure your hardware supports the necessary virtualization  extensions for KVM. Enter the following from a terminal prompt:

```
kvm-ok
```

A message will be printed informing you if your CPU *does* or *does not* support hardware virtualization.

> **Note**
>
> On many computers with processors supporting hardware assisted  virtualization, it is necessary to activate an option in the BIOS to  enable it.

## Virtual Networking

There are a few different ways to allow a virtual machine access to  the external network. The default virtual network configuration includes *bridging* and *iptables* rules implementing *usermode* networking, which uses the SLIRP protocol. Traffic is NATed through the host interface to the outside network.

To enable external hosts to directly access services on virtual machines a different type of *bridge* than the default needs to be configured. This allows the virtual  interfaces to connect to the outside network through the physical  interface, making them appear as normal hosts to the rest of the  network.

There is a [great example](https://netplan.io/examples#configuring-network-bridges) how to configure an own bridge and combining it with libvirt so that guests will use it at the [netplan.io](https://netplan.io/examples).

## Installation

To install the necessary packages, from a terminal prompt enter:

```
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system
```

After installing libvirt-daemon-system, the user used to manage virtual machines will need to be added to the *libvirt* group. This is done automatically for members of the sudo group, but  needs to be done in additon for anyone else that should access system  wide libvirt resources. Doing so will grant the user access to the  advanced networking options.

In a terminal enter:

```
sudo adduser $USER libvirt
```

> **Note**
>
> If the user chosen is the current user, you will need to log out and back in for the new group membership to take effect.

You are now ready to install a *Guest* operating system.  Installing a virtual machine follows the same process as installing the  operating system directly on the hardware.

You either need:

- a way to automate the installation
- a keyboard and monitor will need to be attached to the physical machine.
- use cloud images which are meant to self-initialize (see [Multipass](https://discourse.ubuntu.com/t/virtualization-multipass) and [UVTool](https://discourse.ubuntu.com/t/virtualization-uvt))

In the case of virtual machines a Graphical User Interface (GUI) is  analogous to using a physical keyboard and mouse on a real computer.  Instead of installing a GUI the virt-viewer or virt-manager application  can be used to connect to a virtual machine’s console using VNC. See [Virtual Machine Manager / Viewer](https://ubuntu.com/server/docs/virtualization-virt-tools#libvirt-virt-manager) for more information.

## Virtual Machine Management

The following section covers the command-line tools around *virsh* that are part of libvirt itself. But there are various options at different levels of complexities and feature-sets, like:

- [multipass](https://ubuntu.com/server/docs/virtualization-multipass)
- [uvt](https://ubuntu.com/server/docs/virtualization-uvt)
- [virt-* tools](https://ubuntu.com/server/docs/virtualization-virt-tools)
- [openstack](https://ubuntu.com/openstack)

## virsh

There are several utilities available to manage virtual machines and  libvirt. The virsh utility can be used from the command line. Some  examples:

- To list running virtual machines:

  ```
  virsh list
  ```

- To start a virtual machine:

  ```
  virsh start <guestname>
  ```

- Similarly, to start a virtual machine at boot:

  ```
  virsh autostart <guestname>
  ```

- Reboot a virtual machine with:

  ```
  virsh reboot <guestname>
  ```

- The *state* of virtual machines can be saved to a file in  order to be restored later. The following will save the virtual machine  state into a file named according to the date:

  ```
  virsh save <guestname> save-my.state
  ```

  Once saved the virtual machine will no longer be running.

- A saved virtual machine can be restored using:

  ```
  virsh restore save-my.state
  ```

- To shutdown a virtual machine do:

  ```
  virsh shutdown <guestname>
  ```

- A CDROM device can be mounted in a virtual machine by entering:

  ```
  virsh attach-disk <guestname> /dev/cdrom /media/cdrom
  ```

- To change the definition of a guest virsh exposes the domain via

  ```
  virsh edit <guestname>
  ```

That will allow one to edit the [XML representation that defines the guest](https://libvirt.org/formatdomain.html) and when saving it will apply format and integrity checks on these definitions.

Editing the XML directly certainly is the most powerful way, but also the most complex one. Tools like [Virtual Machine Manager / Viewer](https://ubuntu.com/server/docs/virtualization-virt-tools#libvirt-virt-manager) can help unexperienced users to do most of the common tasks.

> If virsh (or other vir* tools) shall connect to something else than  the default qemu-kvm/system hypervisor one can find alternatives for the *connect* option in *man virsh* or [libvirt doc](http://libvirt.org/uri.html)

### system and session scope

Virsh - as well as most other tools to manage virtualization - can be passed connection strings.

$ virsh --connect qemu:///system

There are two options for the connection.

- `qemu:///system` - connect locally as root to the daemon supervising QEMU and KVM domains
- `qemu:///session` - connect locally as a normal user to his own set of QEMU and KVM domains

The *default* always was (and still is) `qemu:///system` as that is the behavior users are used to.
 But there are a few benefits (and drawbacks) to `qemu:///session` to consider it.

`qemu:///session` is per user and can on a multi-user system be used to separate the people.
 But most importantly things run under the permissions of the user which  means no permission struggle on the just donwloaded image in your *$HOME* or the just attached USB-stick.
 On the other hand it can’t access system resources that well, which includes network setup that is known to be hard with `qemu:///session`. It falls back to [slirp networking](https://en.wikipedia.org/wiki/Slirp) which is functional but slow and makes it impossible to be reached from other systems.

`qemu:///system` is different in that it is run by the global system wide libvirt that can arbitrate resources as needed.
 But you might need to mv and/or chown files to the right places permssions to have them usable.

Applications usually will decide on their primary use-case. Desktop-centric applications often choose `qemu:///session` while most solutions that involve an administrator anyway continue to default to `qemu:///system`.

Read more about that in the [libvirt FAQ](https://wiki.libvirt.org/page/FAQ#What_is_the_difference_between_qemu:.2F.2F.2Fsystem_and_qemu:.2F.2F.2Fsession.3F_Which_one_should_I_use.3F) and this [blog](https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html) about the topic.

## Migration

There are different types of migration available depending on the  versions of libvirt and the hypervisor being used. In general those  types are:

- [offline migration](https://libvirt.org/migration.html#offline)
- [live migration](https://libvirt.org/migration.html)
- [postcopy migration](http://wiki.qemu.org/Features/PostCopyLiveMigration)

There are various options to those methods, but the entry point for all of them is *virsh migrate*. Read the integrated help for more detail.

```auto
 virsh migrate --help 
```

Some useful documentation on constraints and considerations about live migration can be found at the [Ubuntu Wiki](https://wiki.ubuntu.com/QemuKVMMigration)

## Device Passthrough / Hotplug

If instead of the here described hotplugging you want to always pass  through a device add the xml content of the device to your static guest  xml representation via e.g. `virsh edit <guestname>`. In that case you don’t need to use *attach/detach*. There are different kinds of passthrough. Types available to you depend on your Hardware and software setup.

- USB hotplug/passthrough
- VF hotplug/Passthrough

But both kinds are handled in a very similar way and while there are  various way to do it (e.g. also via qemu monitor) driving such a change  via libvirt is recommended. That way libvirt can try to manage all sorts of special cases for you and also somewhat masks version differences.

In general when driving hotplug via libvirt you create a xml snippet that describes the device just as you would do in a static [guest description.](https://libvirt.org/formatdomain.html) A usb device is usually identified by Vendor/Product id’s:

```
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='0x0b6d'/>
    <product id='0x3880'/>
  </source>
</hostdev>
```

Virtual functions are usually assigned via their PCI-ID (domain, bus, slot, function).

```
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x04' slot='0x10' function='0x0'/>
  </source>
</hostdev>
```

> **Note**
>
> To get the Virtual function in the first place is very device  dependent and can therefore not be fully covered here. But in general it involves setting up an iommu, registering via [VFIO](https://www.kernel.org/doc/Documentation/vfio.txt) and sometimes requesting a number of VFs. Here an example on ppc64el to get 4 VFs on a device:
>
> ```auto
> $ sudo modprobe vfio-pci
> # identify device
> $ lspci -n -s 0005:01:01.3
> 0005:01:01.3 0200: 10df:e228 (rev 10)
> # register and request VFs
> $ echo 10df e228 | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id
> $ echo 4 | sudo tee /sys/bus/pci/devices/0005\:01\:00.0/sriov_numvfs
>               
> ```

You then attach or detach the device via libvirt by relating the guest with the xml snippet.

```
virsh attach-device <guestname> <device-xml>
# Use the Device int the Guest
virsh detach-device <guestname> <device-xml>
```

## Access Qemu Monitor via libvirt

The [Qemu Monitor](https://en.wikibooks.org/wiki/QEMU/Monitor) is the way to interact with qemu/KVM while a guest is running. This  interface has many and very powerful features for experienced users.  When running under libvirt that monitor interface is bound by libvirt  itself for management purposes, but a user can run qemu monitor commands via libvirt still. The general syntax is `virsh qemu-monitor-command [options] [guest] 'command'`

Libvirt covers most use cases needed, but if you every want/need to  work around libvirt or want to tweak very special options you can e.g.  add a device that way:

```
virsh qemu-monitor-command --hmp focal-test-log 'drive_add 0 if=none,file=/var/lib/libvirt/images/test.img,format=raw,id=disk1'
```

But since the monitor is so powerful, you can do a lot especially for debugging purposes like showing the guest registers:

```
virsh qemu-monitor-command --hmp y-ipns 'info registers'
RAX=00ffffc000000000 RBX=ffff8f0f5d5c7e48 RCX=0000000000000000 RDX=ffffea00007571c0
RSI=0000000000000000 RDI=ffff8f0fdd5c7e48 RBP=ffff8f0f5d5c7e18 RSP=ffff8f0f5d5c7df8
[...]
```

## Huge Pages

Using huge pages can help to reduce TLB pressure, page table overhead and speed up some further memory relate actions. Furthermore by default [Transparent huge pages](https://www.kernel.org/doc/Documentation/vm/transhuge.txt) are useful, but can be quite some overhead - so if it is clear that  using huge pages is preferred making them explicit usually has some  gains.

While huge page are admittedly harder to manage, especially later in  the lifetime of a system if memory is fragmented they provide a useful  boost especially for rather large guests.

Bonus: When using device pass through on very large guests there is  an extra benefit of using huge pages as it is faster to do the initial  memory clear on vfio dma pin.

### Huge page allocation

Huge pages come in different sizes. A *normal* page usually is 4k and huge pages are eithe 2M or 1G, but depending on the architecture other options are possible.

The most simple, yet least reliable way to allocate some huge pages is to just echo a value to sysfs
 Be sure to re-check if it worked.

```auto
$ echo 256 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
$ cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
256
```

There one of these sizes is “default huge page size” which will be used in the auto-mounted */dev/hugepages*.
 Changing the default size requires a reboot and is set via [default_hugepagesz](https://www.kernel.org/doc/html/v5.4/admin-guide/kernel-parameters.html)

You can check the current default size:

```auto
$ grep Hugepagesize /proc/meminfo
Hugepagesize:       2048 kB
```

But there can be more than one at the same time one better check:

```auto
$ tail /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages` 
==> /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages <==
0
==> /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages <==
2
```

And even that could on bigger systems be further split per [Numa node](https://www.kernel.org/doc/html/v5.4/vm/numa.html).

One can allocate huge pages at [boot or runtime](https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt), but due to fragmentation there are no guarantees it works later. The [kernel documentation](https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt) lists details on both ways.

Huge pages need to be allocated by the kernel as mentioned above but to be consumable they also have to be mounted.
 By default *systemd* will make `/dev/hugepages` available for the default huge page size.
 Feel free to add more mount points if you need different sized.
 An overview can be queried with

```auto
$ hugeadm --list-all-mounts
Mount Point          Options
/dev/hugepages       rw,relatime,pagesize=2M
```

A one-stop info for the overall huge page status of the system can be reported with

```auto
$ hugeadm --explain
```

### Huge page usage in libvirt

With the above in place libvirt can map guest memory to huge pages.
 In a guest definition add the most simple form of

```auto
  <memoryBacking>
    <hugepages/>
  </memoryBacking>
```

That will allocate the huge pages using the default huge page size from a autodetected mountpoint.
 For more control e.g. how memory is spread over [Numa nodes](https://www.kernel.org/doc/html/v5.4/vm/numa.html) or which page size to use check out the details at the [libvirt doc](https://libvirt.org/formatdomain.html#elementsMemoryBacking).

## Apparmor isolation

By default libvirt will spawn qemu guests using apparmor isolation for enhanced security. The [apparmor rules for a guest](https://gitlab.com/apparmor/apparmor/-/wikis/Libvirt#implementation-overview) will consist of multiple elements:

- a static part that all guests share => `/etc/apparmor.d/abstractions/libvirt-qemu`
- a dynamic part created at guest start time and modified on hotplug/unplug => `/etc/apparmor.d/libvirt/libvirt-f9533e35-6b63-45f5-96be-7cccc9696d5e.files`

Of the above the former is provided and updated by the `libvirt-daemon` package and the latter is generated on guest start. None of the two  should be manually edited. They will by default cover the vast majority  of use cases and work fine. But there are certain cases where users  either want to:

- further lock down the guest (e.g. by explicitly denying access that usually would be allowed)
- open up the guest isolation (most of the time this is needed if the  setup on the local machine does not follow the commonly used paths.

To do so there are two files to do so. Both are local overrides which allow you to modify them without getting them clobbered or command file prompts on package upgrades.

- `/etc/apparmor.d/local/abstractions/libvirt-qemu` this will  be applied to every guest. Therefore it is rather powerful, but also a  rather blunt tool. It is a quite useful place thou to add additional [deny rules](https://gitlab.com/apparmor/apparmor/-/wikis/FAQ#what-is-default-deny-white-listing).
- `/etc/apparmor.d/local/usr.lib.libvirt.virt-aa-helper` the above mentioned *dynamic part* that is individual per guest is generated by a tool called `libvirt.virt-aa-helper`. That is under apparmor isolation as well. This is most commonly used if you want to use uncommon paths as it allows to ahve those uncommon  paths in the [guest XML](https://libvirt.org/formatdomain.html) (see `virsh edit`) and have those paths rendered to the per-guest dynamic rules.

## Sharing files between Host<->Guest

To be able to exchange data the memory of the guest has to be allocated
 as “shared” to do so you need to add the following to the guest config:

```
 <memoryBacking>
   <access mode='shared'/>
 </memoryBacking>
```

For performance reasons (it helps virtiofs, but also is generally wise to consider) it
 is recommended to use huge pages which then would look like:

```
 <memoryBacking>
   <hugepages>
     <page size='2048' unit='KiB'/>
   </hugepages>
   <access mode='shared'/>
 </memoryBacking>
```

In the guest definition one then can add `filesytem` sections to specify host
 paths to share with the guest. The *target dir* is a bit special as it isn’t really a directory, instead it is a *tag* that in the guest can be used to access this particular virtiofs instance.

```
 <filesystem type='mount' accessmode='passthrough'>
   <driver type='virtiofs'/>
   <source dir='/var/guests/h-virtiofs'/>
   <target dir='myfs'/>
 </filesystem>
```

And in the guest this can now be used based on the tag `myfs` like:

```
 $ sudo mount -t virtiofs myfs /mnt/
```

Compared to other Host/Guest file sharing options - commonly samba, nfs
 or 9p - virtiofs is usually much faster and also more compatible with usual
 file system semantics. For some extra compatibility in regard to filesystem
 semantics one can add:

```
  <binary xattr='on'>
    <lock posix='on' flock='on'/>
  </binary>
```

See the [libvirt domain/filesytem](https://libvirt.org/formatdomain.html#filesystems) documentation for further details on these.

> Note:
>  While virtiofs works with >=20.10 (Groovy), with >=21.04 (Hirsute) it got
>  much more comfortable, especially in small environments (no hard requirement
>  to specify guest numa topology, no hard requirement to use huge pages).
>  If needed to set up on 20.10 or just interested in those details - the libvirt
>  [knowledge-base about virtiofs](https://libvirt.org/kbase/virtiofs.html) hold more details about these.

## Resources

- See the [KVM](http://www.linux-kvm.org/) home page for more details.
- For more information on libvirt see the [libvirt home page](http://libvirt.org/)
  - xml configuration of [domains](https://libvirt.org/formatdomain.html) and [storage](https://libvirt.org/formatstorage.html) being the most often used libvirt reference
- Another good resource is the [Ubuntu Wiki KVM](https://help.ubuntu.com/community/KVM) page.
- For basics how to assign VT-d devices to qemu/KVM, please see the [linux-kvm](http://www.linux-kvm.org/page/How_to_assign_devices_with_VT-d_in_KVM#Assigning_the_device) page.

[Multipass](https://multipass.run) is the recommended  method to create Ubuntu VMs on Ubuntu. It’s designed for developers who  want a fresh Ubuntu environment with a single command and works on  Linux, Windows and macOS.

On Linux it’s available as a snap:

```
sudo snap install multipass --beta --classic
```

# Usage

## Find available images

```auto
$ multipass find
Image                   Aliases           Version          Description
core                    core16            20190424         Ubuntu Core 16
core18                                    20190213         Ubuntu Core 18
16.04                   xenial            20190628         Ubuntu 16.04 LTS
18.04                   bionic,lts        20190627.1       Ubuntu 18.04 LTS
18.10                   cosmic            20190628         Ubuntu 18.10
19.04                   disco             20190628         Ubuntu 19.04
daily:19.10             devel,eoan        20190623         Ubuntu 19.10
```

## Launch a fresh instance of the current Ubuntu LTS

```auto
$ multipass launch ubuntu
Launching dancing-chipmunk...
Downloading Ubuntu 18.04 LTS..........
Launched: dancing chipmunk
```

## Check out the running instances

```auto
$ multipass list
Name                    State             IPv4             Release
dancing-chipmunk        RUNNING           10.125.174.247   Ubuntu 18.04 LTS
live-naiad              RUNNING           10.125.174.243   Ubuntu 18.04 LTS
snapcraft-asciinema     STOPPED           --               Ubuntu Snapcraft builder for Core 18
```

## Learn more about the VM instance you just launched

```auto
$ multipass info dancing-chipmunk
Name:           dancing-chipmunk
State:          RUNNING
IPv4:           10.125.174.247
Release:        Ubuntu 18.04.1 LTS
Image hash:     19e9853d8267 (Ubuntu 18.04 LTS)
Load:           0.97 0.30 0.10
Disk usage:     1.1G out of 4.7G
Memory usage:   85.1M out of 985.4M
```

## Connect to a running instance

```auto
$ multipass shell dancing-chipmunk
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-42-generic x86_64)

...
```

Don’t forget to logout (or Ctrl-D) or you may find yourself heading all the
 way down the Inception levels… ![:wink:](https://discourse.ubuntu.com/images/emoji/emoji_one/wink.png?v=9)

## Run commands inside an instance from outside

```auto
$ multipass exec dancing-chipmunk -- lsb_release -a
No LSB modules are available.
Distributor ID:  Ubuntu
Description:     Ubuntu 18.04.1 LTS
Release:         18.04
Codename:        bionic
```

## Stop an instance to save resources

```auto
$ multipass stop dancing-chipmunk
```

## Delete the instance

```auto
$ multipass delete dancing-chipmunk
```

It will now show up as deleted:

```auto
Name                    State             IPv4             Release
snapcraft-asciinema     STOPPED           --               Ubuntu Snapcraft builder for Core 18
dancing-chipmunk        DELETED           --               Not Available
```

And when you want to completely get rid of it:

```auto
$ multipass purge
```

## Integrate into the rest of your virtualization

You might have other virtualization already based on libvirt either through using the similar older uvtool already or through the common [virt-manager](https://virt-manager.org/).

You might for example want those guests to be on the same bridge to  communicate to each other or you need access to the graphical output for some reason.

Fortunately it is possible to integrate this by using the [libvirt](https://ubuntu.com/server/docs/virtualization-libvirt) backend of multipass

```auto
$ sudo multipass set local.driver=libvirt
```

After that when you start a guest you can also access it via tools like [virt-manager](https://virt-manager.org/) or `virsh`

```auto
$ multipass launch ubuntu
Launched: engaged-amberjack 

$ virsh list
 Id    Name                           State
----------------------------------------------------
 15    engaged-amberjack              running
```

## Get help

```auto
multipass help
multipass help <command>
```

See the [multipass documentation](https://discourse.ubuntu.com/t/multipass-documentation-outline/8294) for more details.

# Cloud images and uvtool

## Introduction

With Ubuntu being one of the most used operating systems on many  cloud platforms, the availability of stable and secure cloud images has  become very important. As of 12.04 the utilization of cloud images  outside of a cloud infrastructure has been improved. It is now possible  to use those images to create a virtual machine without the need of a  complete installation.

## Creating virtual machines using uvtool

Starting with 14.04 LTS, a tool called uvtool greatly facilitates the task of generating virtual machines (VM) using the cloud images. uvtool provides a simple mechanism to synchronize cloud-images locally and use them to create new VMs in minutes.

### Uvtool packages

The following packages and their dependencies will be required in order to use uvtool:

- uvtool
- uvtool-libvirt

To install uvtool, run:

```
$ sudo apt -y install uvtool
```

This will install uvtool’s main commands:

- uvt-simplestreams-libvirt
- uvt-kvm

### Get the Ubuntu Cloud Image with uvt-simplestreams-libvirt

This is one of the major simplifications that uvtool brings. It is  aware of where to find the cloud images so only one command is required  to get a new cloud image. For instance, if you want to synchronize all  cloud images for the amd64 architecture, the uvtool command would be:

```
$ uvt-simplestreams-libvirt --verbose sync arch=amd64
```

After an amount of time required to download all the images from the  Internet, you will have a complete set of cloud images stored locally.  To see what has been downloaded use the following command:

```
$ uvt-simplestreams-libvirt query
release=bionic arch=amd64 label=daily (20191107)
release=focal arch=amd64 label=daily (20191029)
...
```

In the case where you want to synchronize only one specific  cloud-image, you need to use the release= and arch= filters to identify  which image needs to be synchronized.

```
$ uvt-simplestreams-libvirt sync release=DISTRO-SHORT-CODENAME arch=amd64
```

Furthermore you can provide an alternative URL to fetch images from. A common case are the daily images which helps to get the very latest  images or if you need access to the not yet released development release of Ubuntu.

```
$ uvt-simplestreams-libvirt sync --source http://cloud-images.ubuntu.com/daily [... further options]
```

### Create the VM using uvt-kvm

In order to connect to the virtual machine once it has been created,  you must have a valid SSH key available for the Ubuntu user. If your  environment does not have an SSH key, you can easily create one using  the following command:

```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.
The key fingerprint is:
4d:ba:5d:57:c9:49:ef:b5:ab:71:14:56:6e:2b:ad:9b ubuntu@DISTRO-SHORT-CODENAMES
The key's randomart image is:
+--[ RSA 2048]----+
|               ..|
|              o.=|
|          .    **|
|         +    o+=|
|        S . ...=.|
|         o . .+ .|
|        . .  o o |
|              *  |
|             E   |
+-----------------+
```

To create of a new virtual machine using uvtool, run the following in a terminal:

```
$ uvt-kvm create firsttest
```

This will create a VM named **firsttest** using the  current LTS cloud image available locally. If you want to specify a  release to be used to create the VM, you need to use the **release=** filter:

```
$ uvt-kvm create secondtest release=DISTRO-SHORT-CODENAME
```

uvt-kvm wait can be used to wait until the creation of the VM has completed:

```
$ uvt-kvm wait secondttest
```

### Connect to the running VM

Once the virtual machine creation is completed, you can connect to it using SSH:

```
$ uvt-kvm ssh secondtest
```

You can also connect to your VM using a regular SSH session using the IP address of the VM. The address can be queried using the following  command:

```auto
$ uvt-kvm ip secondtest
192.168.122.199
$ ssh -i ~/.ssh/id_rsa ubuntu@192.168.122.199
[...]
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@secondtest:~$ 
```

### Get the list of running VMs

You can get the list of VMs running on your system with this command:

```
$ uvt-kvm list
secondtest
```

### Destroy your VM

Once you are done with your VM, you can destroy it with:

```
$ uvt-kvm destroy secondtest
```

Note: other than libvirts destroy action this will by default also remove the associated virtual storage files.

### More uvt-kvm options

The following options can be used to change some of the characteristics of the VM that you are creating:

- –memory : Amount of RAM in megabytes. Default: 512.
- –disk : Size of the OS disk in gigabytes. Default: 8.
- –cpu : Number of CPU cores. Default: 1.

Some other parameters will have an impact on the cloud-init configuration:

- –password password : Allow login to the VM using the Ubuntu account and this provided password.
- –run-script-once script_file : Run script_file as root on the VM the first time it is booted, but never again.
- –packages package_list : Install the comma-separated packages specified in package_list on first boot.

A complete description of all available modifiers is available in the manpage of uvt-kvm.

## Resources

If you are interested in learning more, have questions or suggestions, please contact the Ubuntu Server Team at:

- IRC: #ubuntu-server on freenode
- Mailing list: [ubuntu-server at lists.ubuntu.com](https://lists.ubuntu.com/mailman/listinfo/ubuntu-server)

## Introduction

The virt-manager source contains not only virt-manager itself but  also a collection of further helpful tools like virt-install, virt-clone and virt-viewer.

## Virtual Machine Manager



The virt-manager package contains a graphical utility to manage local and remote virtual machines. To install virt-manager enter:

```
sudo apt install virt-manager
```

Since virt-manager requires a Graphical User Interface (GUI)  environment it is recommended to be installed on a workstation or test  machine instead of a production server. To connect to the local libvirt  service enter:

```
virt-manager
```

You can connect to the libvirt service running on another host by entering the following in a terminal prompt:

```
virt-manager -c qemu+ssh://virtnode1.mydomain.com/system
```

> **Note**
>
> The above example assumes that SSH connectivity between the  management system and the target system has already been configured, and uses SSH keys for authentication. SSH *keys* are needed because libvirt sends the password prompt to another process.

### virt-manager guest lifecycle

When using `virt-manager` it is always important to know the context you look at.
 The main window initially lists only the currently defined guests, you’ll see their *name*, *state* and a small chart on *cpu usage*.

![virt-manager-gui-start](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/0/07edc140441fff1ece44c8409f75acd728e15c28.png)

On that context there isn’t much one can do except start/stop a guest.
 But by double-clicking on a guest or by clicking the *open*  button at the top one can see the guest itself. For a running guest that includes the guests main-console/virtual-screen output.



[![virt-manager-gui-showoutput](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/7/7859f9fc0c79ef6866fc436bb775a28f1b342cde_2_690x386.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/7/7859f9fc0c79ef6866fc436bb775a28f1b342cde.png)



If you are deeper in the guest config a click in the top left onto “*show the graphical console*” will get you back to this output.

### virt-manager guest modification

`virt-manager` provides a gui assisted way to edit guest definitions which can be handy.
 To do so the per-guest context view will at the top have “*show virtual hardware details*”.
 Here a user can edit the virtual hardware of the guest which will under the cover alter the [guest representation](https://libvirt.org/formatdomain.html).



[![virt-manager-gui-edit](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/f/f5d42f8bdcb87b3818b5b6c04f5ccec5a15fef3d_2_690x346.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/f/f5d42f8bdcb87b3818b5b6c04f5ccec5a15fef3d.png)



The UI edit is limited to the features known and supported to that  GUI feature. Not only does libvirt grow features faster than  virt-manager can keep up - adding every feature would also overload the  UI to the extend to be unusable. To strike a balance between the two  there also is the XML view which can be reached via the “*edit libvirt XML*” button.



[![virt-manager-gui-XML](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/1/102df4e3030498b1768cc48685cb6f922cec0244_2_690x346.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/1/102df4e3030498b1768cc48685cb6f922cec0244.png)



By default this will be read-only and you can see what the UI driven  actions have changed, but one can allow RW access in this view in the *preferences*.
 This is the same content that the `virsh edit` of the [libvirt-client](https://ubuntu.com/server/docs/virtualization-libvirt) exposes.

## Virtual Machine Viewer



The virt-viewer application allows you to connect to a virtual  machine’s console like virt-manager reduced to the GUI functionality.  virt-viewer does require a Graphical User Interface (GUI) to interface  with the virtual machine.

To install virt-viewer from a terminal enter:

```
sudo apt install virt-viewer
```

Once a virtual machine is installed and running you can connect to the virtual machine’s console by using:

```
virt-viewer <guestname>
```

The UI will be a window representing the virtual screen of the guest, just like virt-manager above but without the extra buttons and features around it.



[![virt-viewer-gui-showoutput](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/4/43f32c1efdd95a44b512cb6461bf360e64f60277_2_690x598.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/4/43f32c1efdd95a44b512cb6461bf360e64f60277.png)



Similar to virt-manager, virt-viewer can connect to a remote host using *SSH* with key authentication, as well:

```
virt-viewer -c qemu+ssh://virtnode1.mydomain.com/system <guestname>
```

Be sure to replace *web_devel* with the appropriate virtual machine name.

If configured to use a *bridged* network interface you can also setup SSH access to the virtual machine.

## virt-install

virt-install is part of the virtinst package.
 It can help installing classic ISO based systems and provides a CLI  options for the most common options needed to do so. To install it, from a terminal prompt enter:

```
sudo apt install virtinst
```

There are several options available when using virt-install. For example:

```
virt-install -n web_devel -r 8192 \
--disk path=/home/doug/vm/web_devel.img,bus=virtio,size=50 \
-c focal-desktop-amd64.iso \
--network network=default,model=virtio \
--video=vmvga --graphics vnc,listen=0.0.0.0 --noautoconsole -v --vcpus=4
```

There are much more arguments that can be found in the man page, explaining those of the example above one by one:

- -n web_devel
   the name of the new virtual machine will be web_devel in this example.
- -r 8192
   specifies the amount of memory the virtual machine will use in megabytes.
- –disk path=/home/doug/vm/web_devel.img,bus=virtio,size=50
   indicates the path to the virtual disk which can be a file, partition,  or logical volume. In this example a file named web_devel.img in the  current users directory, with a size of 50 gigabytes, and using virtio  for the disk bus. Depending on the disk path, virt-install my need to be run with elevated privileges.
- -c focal-desktop-amd64.iso
   file to be used as a virtual CDROM. The file can be either an ISO file or the path to the host’s CDROM device.
- –network
   provides details related to the VM’s network interface. Here the default network is used, and the interface model is configured for virtio.
- –video=vmvga
   the video driver to use.
- –graphics vnc,listen=0.0.0.0
   exports the guest’s virtual console using VNC and on all host  interfaces. Typically servers have no GUI, so another GUI based computer on the Local Area Network (LAN) can connect via VNC to complete the  installation.
- –noautoconsole
   will not automatically connect to the virtual machine’s console.
- -v: creates a fully virtualized guest.
- –vcpus=4
   allocate 4 virtual CPUs.

After launching virt-install you can connect to the virtual machine’s console either locally using a GUI (if your server has a GUI), or via a remote VNC client from a GUI-based computer.

## virt-clone

The virt-clone application can be used to copy one virtual machine to another. For example:

```
virt-clone --auto-clone --original focal
```

Options used:

- –auto-clone: to have virt-clone come up with guest names and disk paths on its own
- –original: name of the virtual machine to copy

Also, use -d or --debug option to help troubleshoot problems with virt-clone.

Replace *focal* and with appropriate virtual machine names of your case.

> Warning: please be aware that this is a full clone, therefore any  sorts of secrets, keys and for example /etc/machine-id will be shared  causing e.g. issues to security and anything that needs to identify the  machine like DHCP. You most likely want to edit those afterwards and  de-duplicate them as needed.

## Resources

- See the [KVM](http://www.linux-kvm.org/) home page for more details.
- For more information on libvirt see the [libvirt home page](http://libvirt.org/)
- The [Virtual Machine Manager](http://virt-manager.org/) site has more information on virt-manager development.

# LXD

LXD (pronounced lex-dee) is the lightervisor, or lightweight  container hypervisor. LXC (lex-see) is a program which creates and  administers “containers” on a local system. It also provides an API to  allow higher level managers, such as LXD, to administer containers. In a sense, one could compare LXC to QEMU, while comparing LXD to libvirt.

The LXC API deals with a ‘container’. The LXD API deals with  ‘remotes’, which serve images and containers. This extends the LXC  functionality over the network, and allows concise management of tasks  like container migration and container image publishing.

LXD uses LXC under the covers for some container management tasks.  However, it keeps its own container configuration information and has  its own conventions, so that it is best not to use classic LXC commands  by hand with LXD containers. This document will focus on how to  configure and administer LXD on Ubuntu systems.

## Online Resources

There is excellent documentation for [getting started with LXD](https://linuxcontainers.org/lxd/getting-started-cli/) and an online server allowing you to [try out LXD remotely](http://linuxcontainers.org/lxd/try-it). Stephane Graber also has an [excellent blog series](https://www.stgraber.org/2016/03/11/lxd-2-0-blog-post-series-012/) on LXD 2.0. Finally, there is great documentation on how to [drive lxd using juju](https://docs.jujucharms.com/devel/en/clouds-lxd).

This document will offer an Ubuntu Server-specific view of LXD, focusing on administration.

## Installation

LXD is pre-installed on Ubuntu Server cloud images. On other systems, the lxd package can be installed using:

```auto
sudo snap install lxd
```

This will install the self-contained LXD snap package.

## Kernel preparation

In general, Ubuntu should have all the desired features enabled by  default. One exception to this is that in order to enable swap  accounting the boot argument `swapaccount=1` must be set. This can be done by appending it to the `GRUB_CMDLINE_LINUX_DEFAULT=`variable in /etc/default/grub, then running ‘update-grub’ as root and rebooting.

## Configuration

In order to use LXD, some basic settings need to be configured first. This is done by running `lxd init`, which will allow you to choose:

- Directory or [ZFS](http://open-zfs.org) container backend. If you choose ZFS, you can choose which block devices to use, or the size of a file to use as backing store.
- Availability over the network.
- A ‘trust password’ used by remote clients to vouch for their client certificate.

You must run ‘lxd init’ as root. ‘lxc’ commands can be run as any  user who is a member of group lxd. If user joe is not a member of group  ‘lxd’, you may run:

```auto
adduser joe lxd
```

as root to change it. The new membership will take effect on the next login, or after running `newgrp lxd` from an existing login.

For more information on server, container, profile, and device  configuration, please refer to the definitive configuration provided  with the source code, which can be found [online](https://github.com/lxc/lxd/blob/master/doc/configuration.md).

## Creating your first container

This section will describe the simplest container tasks.

### Creating a container

Every new container is created based on either an image, an existing  container, or a container snapshot. At install time, LXD is configured  with the following image servers:

- `ubuntu`: this serves official Ubuntu server cloud image releases.
- `ubuntu-daily`: this serves official Ubuntu server cloud images of the daily development releases.
- `images`: this is a default-installed alias for [images.linuxcontainers.org](http://images.linuxcontainers.org). This is serves classical lxc images built using the same images which  the LXC ‘download’ template uses. This includes various distributions  and minimal custom-made Ubuntu images. This is not the recommended  server for Ubuntu images.

The command to create and start a container is

```auto
lxc launch remote:image containername
```

Images are identified by their hash, but are also aliased. The `ubuntu` remote knows many aliases such as `18.04` and `bionic`. A list of all images available from the Ubuntu Server can be seen using:

```auto
lxc image list ubuntu:
```

To see more information about a particular image, including all the aliases it is known by, you can use:

```auto
lxc image info ubuntu:bionic
```

You can generally refer to an Ubuntu image using the release name (`bionic`) or the release number (`18.04`). In addition, `lts` is an alias for the latest supported LTS release. To choose a different architecture, you can specify the desired architecture:

```auto
lxc image info ubuntu:lts/arm64
```

Now, let’s start our first container:

```auto
lxc launch ubuntu:bionic b1
```

This will download the official current Bionic cloud image for your current architecture, then create a container named `b1` using that image, and finally start it. Once the command returns, you can see it using:

```auto
lxc list
lxc info b1
```

and open a shell in it using:

```auto
lxc exec b1 -- bash
```

The try-it page mentioned above gives a full synopsis of the commands you can use to administer containers.

Now that the `xenial` image has been downloaded, it will  be kept in sync until no new containers have been created based on it  for (by default) 10 days. After that, it will be deleted.

## LXD Server Configuration

By default, LXD is socket activated and configured to listen only on a local UNIX socket. While LXD may not be running when you first look at  the process listing, any LXC command will start it up. For instance:

```auto
lxc list
```

This will create your client certificate and contact the LXD server  for a list of containers. To make the server accessible over the network you can set the http port using:

```auto
lxc config set core.https_address :8443
```

This will tell LXD to listen to port 8843 on all addresses.

### Authentication

By default, LXD will allow all members of group `lxd` to talk to it over the UNIX socket. Communication over the network is authorized using server and client certificates.

Before client `c1` wishes to use remote `r1`, `r1` must be registered using:

```auto
lxc remote add r1 r1.example.com:8443
```

The fingerprint of r1’s certificate will be shown, to allow the user  at c1 to reject a false certificate. The server in turn will verify that c1 may be trusted in one of two ways. The first is to register it in  advance from any already-registered client, using:

```auto
lxc config trust add r1 certfile.crt
```

Now when the client adds r1 as a known remote, it will not need to provide a password as it is already trusted by the server.

The other step is to configure a ‘trust password’ with `r1`, either at initial configuration using `lxd init`, or after the fact using:

```auto
lxc config set core.trust_password PASSWORD
```

The password can then be provided when the client registers `r1` as a known remote.

### Backing store

LXD supports several backing stores. The recommended and the default backing store is `zfs`. If you already have a ZFS pool configured, you can tell LXD to use it during the `lxd init` procedure, otherwise a file-backed zpool will be created automatically. With ZFS, launching a new container is fast because the filesystem  starts as a copy on write clone of the images’ filesystem. Note that  unless the container is privileged (see below) LXD will need to change  ownership of all files before the container can start, however this is  fast and change very little of the actual filesystem data.

The other supported backing stores are described in detail in the [Storage configuration](https://lxd.readthedocs.io/en/latest/storage/) section of the LXD documentation.

## Container configuration

Containers are configured according to a set of profiles, described  in the next section, and a set of container-specific configuration.  Profiles are applied first, so that container specific configuration can override profile configuration.

Container configuration includes properties like the architecture,  limits on resources such as CPU and RAM, security details including  apparmor restriction overrides, and devices to apply to the container.

Devices can be of several types, including UNIX character, UNIX  block, network interface, or disk. In order to insert a host mount into a container, a ‘disk’ device type would be used. For instance, to mount `/opt` in container `c1` at `/opt`, you could use:

```auto
lxc config device add c1 opt disk source=/opt path=opt
```

See:

```auto
lxc help config
```

for more information about editing container configurations. You may also use:

```auto
lxc config edit c1
```

to edit the whole of `c1`’s configuration. Comments at the top of the configuration will show examples of correct syntax to help  administrators hit the ground running. If the edited configuration is  not valid when the editor is exited, then the editor will be restarted.

## Profiles

Profiles are named collections of configurations which may be applied to more than one container. For instance, all containers created with `lxc launch`, by default, include the `default` profile, which provides a network interface `eth0`.

To mask a device which would be inherited from a profile but which  should not be in the final container, define a device by the same name  but of type ‘none’:

```auto
lxc config device add c1 eth1 none
```

## Nesting

Containers all share the same host kernel. This means that there is  always an inherent trade-off between features exposed to the container  and host security from malicious containers. Containers by default are  therefore restricted from features needed to nest child containers. In  order to run lxc or lxd containers under a lxd container, the `security.nesting` feature must be set to true:

```auto
lxc config set container1 security.nesting true
```

Once this is done, `container1` will be able to start sub-containers.

In order to run unprivileged (the default in LXD) containers nested  under an unprivileged container, you will need to ensure a wide enough  UID mapping. Please see the ‘UID mapping’ section below.

## Limits

LXD supports flexible constraints on the resources which containers can consume. The limits come in the following categories:

- CPU: limit cpu available to the container in several ways.
- Disk: configure the priority of I/O requests under load
- RAM: configure memory and swap availability
- Network: configure the network priority under load
- Processes: limit the number of concurrent processes in the container.

For a full list of limits known to LXD, see [the configuration documentation](https://github.com/lxc/lxd/blob/master/doc/configuration.md).

## UID mappings and Privileged containers

By default, LXD creates unprivileged containers. This means that root in the container is a non-root UID on the host. It is privileged  against the resources owned by the container, but unprivileged with  respect to the host, making root in a container roughly equivalent to an unprivileged user on the host. (The main exception is the increased  attack surface exposed through the system call interface)

Briefly, in an unprivileged container, 65536 UIDs are ‘shifted’ into  the container. For instance, UID 0 in the container may be 100000 on the host, UID 1 in the container is 100001, etc, up to 165535. The starting value for UIDs and GIDs, respectively, is determined by the ‘root’  entry the `/etc/subuid` and `/etc/subgid` files. (See the [subuid(5)](http://manpages.ubuntu.com/manpages/xenial/en/man5/subuid.5.html) man page.)

It is possible to request a container to run without a UID mapping by setting the `security.privileged` flag to true:

```auto
lxc config set c1 security.privileged true
```

Note however that in this case the root user in the container is the root user on the host.

## Apparmor

LXD confines containers by default with an apparmor profile which  protects containers from each other and the host from containers. For  instance this will prevent root in one container from signaling root in  another container, even though they have the same uid mapping. It also  prevents writing to dangerous, un-namespaced files such as many sysctls  and ` /proc/sysrq-trigger`.

If the apparmor policy for a container needs to be modified for a container `c1`, specific apparmor policy lines can be added in the `raw.apparmor` configuration key.

## Seccomp

All containers are confined by a default seccomp policy. This policy  prevents some dangerous actions such as forced umounts, kernel module  loading and unloading, kexec, and the `open_by_handle_at`  system call. The seccomp configuration cannot be modified, however a  completely different seccomp policy – or none – can be requested using `raw.lxc` (see below).

## Raw LXC configuration

LXD configures containers for the best balance of host safety and  container usability. Whenever possible it is highly recommended to use  the defaults, and use the LXD configuration keys to request LXD to  modify as needed. Sometimes, however, it may be necessary to talk to the underlying lxc driver itself. This can be done by specifying LXC  configuration items in the ‘raw.lxc’ LXD configuration key. These must  be valid items as documented in [the lxc.container.conf(5) manual page](http://manpages.ubuntu.com/manpages/focal/en/man5/lxc.container.conf.5.html).

### Snapshots

Containers can be renamed and live-migrated using the `lxc move` command:

```auto
lxc move c1 final-beta
```

They can also be snapshotted:

```auto
lxc snapshot c1 YYYY-MM-DD
```

Later changes to c1 can then be reverted by restoring the snapshot:

```auto
lxc restore u1 YYYY-MM-DD
```

New containers can also be created by copying a container or snapshot:

```auto
lxc copy u1/YYYY-MM-DD testcontainer
```

### Publishing images

When a container or container snapshot is ready for consumption by others, it can be published as a new image using;

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0
```

The published image will be private by default, meaning that LXD will not allow clients without a trusted certificate to see them. If the  image is safe for public viewing (i.e. contains no private information), then the ‘public’ flag can be set, either at publish time using

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0 public=true
```

or after the fact using

```auto
lxc image edit foo-2.0
```

and changing the value of the public field.

### Image export and import

Image can be exported as, and imported from, tarballs:

```auto
lxc image export foo-2.0 foo-2.0.tar.gz
lxc image import foo-2.0.tar.gz --alias foo-2.0 --public
```

## Troubleshooting

To view debug information about LXD itself, on a systemd based host use

```auto
journalctl -u lxd
```

Container logfiles for container c1 may be seen using:

```auto
lxc info c1 --show-log
```

The configuration file which was used may be found under ` /var/log/lxd/c1/lxc.conf` while apparmor profiles can be found in ` /var/lib/lxd/security/apparmor/profiles/c1` and seccomp profiles in ` /var/lib/lxd/security/seccomp/c1`.

# LXD

LXD (pronounced lex-dee) is the lightervisor, or lightweight  container hypervisor. LXC (lex-see) is a program which creates and  administers “containers” on a local system. It also provides an API to  allow higher level managers, such as LXD, to administer containers. In a sense, one could compare LXC to QEMU, while comparing LXD to libvirt.

The LXC API deals with a ‘container’. The LXD API deals with  ‘remotes’, which serve images and containers. This extends the LXC  functionality over the network, and allows concise management of tasks  like container migration and container image publishing.

LXD uses LXC under the covers for some container management tasks.  However, it keeps its own container configuration information and has  its own conventions, so that it is best not to use classic LXC commands  by hand with LXD containers. This document will focus on how to  configure and administer LXD on Ubuntu systems.

## Online Resources

There is excellent documentation for [getting started with LXD](https://linuxcontainers.org/lxd/getting-started-cli/) and an online server allowing you to [try out LXD remotely](http://linuxcontainers.org/lxd/try-it). Stephane Graber also has an [excellent blog series](https://www.stgraber.org/2016/03/11/lxd-2-0-blog-post-series-012/) on LXD 2.0. Finally, there is great documentation on how to [drive lxd using juju](https://docs.jujucharms.com/devel/en/clouds-lxd).

This document will offer an Ubuntu Server-specific view of LXD, focusing on administration.

## Installation

LXD is pre-installed on Ubuntu Server cloud images. On other systems, the lxd package can be installed using:

```auto
sudo snap install lxd
```

This will install the self-contained LXD snap package.

## Kernel preparation

In general, Ubuntu should have all the desired features enabled by  default. One exception to this is that in order to enable swap  accounting the boot argument `swapaccount=1` must be set. This can be done by appending it to the `GRUB_CMDLINE_LINUX_DEFAULT=`variable in /etc/default/grub, then running ‘update-grub’ as root and rebooting.

## Configuration

In order to use LXD, some basic settings need to be configured first. This is done by running `lxd init`, which will allow you to choose:

- Directory or [ZFS](http://open-zfs.org) container backend. If you choose ZFS, you can choose which block devices to use, or the size of a file to use as backing store.
- Availability over the network.
- A ‘trust password’ used by remote clients to vouch for their client certificate.

You must run ‘lxd init’ as root. ‘lxc’ commands can be run as any  user who is a member of group lxd. If user joe is not a member of group  ‘lxd’, you may run:

```auto
adduser joe lxd
```

as root to change it. The new membership will take effect on the next login, or after running `newgrp lxd` from an existing login.

For more information on server, container, profile, and device  configuration, please refer to the definitive configuration provided  with the source code, which can be found [online](https://github.com/lxc/lxd/blob/master/doc/configuration.md).

## Creating your first container

This section will describe the simplest container tasks.

### Creating a container

Every new container is created based on either an image, an existing  container, or a container snapshot. At install time, LXD is configured  with the following image servers:

- `ubuntu`: this serves official Ubuntu server cloud image releases.
- `ubuntu-daily`: this serves official Ubuntu server cloud images of the daily development releases.
- `images`: this is a default-installed alias for [images.linuxcontainers.org](http://images.linuxcontainers.org). This is serves classical lxc images built using the same images which  the LXC ‘download’ template uses. This includes various distributions  and minimal custom-made Ubuntu images. This is not the recommended  server for Ubuntu images.

The command to create and start a container is

```auto
lxc launch remote:image containername
```

Images are identified by their hash, but are also aliased. The `ubuntu` remote knows many aliases such as `18.04` and `bionic`. A list of all images available from the Ubuntu Server can be seen using:

```auto
lxc image list ubuntu:
```

To see more information about a particular image, including all the aliases it is known by, you can use:

```auto
lxc image info ubuntu:bionic
```

You can generally refer to an Ubuntu image using the release name (`bionic`) or the release number (`18.04`). In addition, `lts` is an alias for the latest supported LTS release. To choose a different architecture, you can specify the desired architecture:

```auto
lxc image info ubuntu:lts/arm64
```

Now, let’s start our first container:

```auto
lxc launch ubuntu:bionic b1
```

This will download the official current Bionic cloud image for your current architecture, then create a container named `b1` using that image, and finally start it. Once the command returns, you can see it using:

```auto
lxc list
lxc info b1
```

and open a shell in it using:

```auto
lxc exec b1 -- bash
```

The try-it page mentioned above gives a full synopsis of the commands you can use to administer containers.

Now that the `xenial` image has been downloaded, it will  be kept in sync until no new containers have been created based on it  for (by default) 10 days. After that, it will be deleted.

## LXD Server Configuration

By default, LXD is socket activated and configured to listen only on a local UNIX socket. While LXD may not be running when you first look at  the process listing, any LXC command will start it up. For instance:

```auto
lxc list
```

This will create your client certificate and contact the LXD server  for a list of containers. To make the server accessible over the network you can set the http port using:

```auto
lxc config set core.https_address :8443
```

This will tell LXD to listen to port 8843 on all addresses.

### Authentication

By default, LXD will allow all members of group `lxd` to talk to it over the UNIX socket. Communication over the network is authorized using server and client certificates.

Before client `c1` wishes to use remote `r1`, `r1` must be registered using:

```auto
lxc remote add r1 r1.example.com:8443
```

The fingerprint of r1’s certificate will be shown, to allow the user  at c1 to reject a false certificate. The server in turn will verify that c1 may be trusted in one of two ways. The first is to register it in  advance from any already-registered client, using:

```auto
lxc config trust add r1 certfile.crt
```

Now when the client adds r1 as a known remote, it will not need to provide a password as it is already trusted by the server.

The other step is to configure a ‘trust password’ with `r1`, either at initial configuration using `lxd init`, or after the fact using:

```auto
lxc config set core.trust_password PASSWORD
```

The password can then be provided when the client registers `r1` as a known remote.

### Backing store

LXD supports several backing stores. The recommended and the default backing store is `zfs`. If you already have a ZFS pool configured, you can tell LXD to use it during the `lxd init` procedure, otherwise a file-backed zpool will be created automatically. With ZFS, launching a new container is fast because the filesystem  starts as a copy on write clone of the images’ filesystem. Note that  unless the container is privileged (see below) LXD will need to change  ownership of all files before the container can start, however this is  fast and change very little of the actual filesystem data.

The other supported backing stores are described in detail in the [Storage configuration](https://lxd.readthedocs.io/en/latest/storage/) section of the LXD documentation.

## Container configuration

Containers are configured according to a set of profiles, described  in the next section, and a set of container-specific configuration.  Profiles are applied first, so that container specific configuration can override profile configuration.

Container configuration includes properties like the architecture,  limits on resources such as CPU and RAM, security details including  apparmor restriction overrides, and devices to apply to the container.

Devices can be of several types, including UNIX character, UNIX  block, network interface, or disk. In order to insert a host mount into a container, a ‘disk’ device type would be used. For instance, to mount `/opt` in container `c1` at `/opt`, you could use:

```auto
lxc config device add c1 opt disk source=/opt path=opt
```

See:

```auto
lxc help config
```

for more information about editing container configurations. You may also use:

```auto
lxc config edit c1
```

to edit the whole of `c1`’s configuration. Comments at the top of the configuration will show examples of correct syntax to help  administrators hit the ground running. If the edited configuration is  not valid when the editor is exited, then the editor will be restarted.

## Profiles

Profiles are named collections of configurations which may be applied to more than one container. For instance, all containers created with `lxc launch`, by default, include the `default` profile, which provides a network interface `eth0`.

To mask a device which would be inherited from a profile but which  should not be in the final container, define a device by the same name  but of type ‘none’:

```auto
lxc config device add c1 eth1 none
```

## Nesting

Containers all share the same host kernel. This means that there is  always an inherent trade-off between features exposed to the container  and host security from malicious containers. Containers by default are  therefore restricted from features needed to nest child containers. In  order to run lxc or lxd containers under a lxd container, the `security.nesting` feature must be set to true:

```auto
lxc config set container1 security.nesting true
```

Once this is done, `container1` will be able to start sub-containers.

In order to run unprivileged (the default in LXD) containers nested  under an unprivileged container, you will need to ensure a wide enough  UID mapping. Please see the ‘UID mapping’ section below.

## Limits

LXD supports flexible constraints on the resources which containers can consume. The limits come in the following categories:

- CPU: limit cpu available to the container in several ways.
- Disk: configure the priority of I/O requests under load
- RAM: configure memory and swap availability
- Network: configure the network priority under load
- Processes: limit the number of concurrent processes in the container.

For a full list of limits known to LXD, see [the configuration documentation](https://github.com/lxc/lxd/blob/master/doc/configuration.md).

## UID mappings and Privileged containers

By default, LXD creates unprivileged containers. This means that root in the container is a non-root UID on the host. It is privileged  against the resources owned by the container, but unprivileged with  respect to the host, making root in a container roughly equivalent to an unprivileged user on the host. (The main exception is the increased  attack surface exposed through the system call interface)

Briefly, in an unprivileged container, 65536 UIDs are ‘shifted’ into  the container. For instance, UID 0 in the container may be 100000 on the host, UID 1 in the container is 100001, etc, up to 165535. The starting value for UIDs and GIDs, respectively, is determined by the ‘root’  entry the `/etc/subuid` and `/etc/subgid` files. (See the [subuid(5)](http://manpages.ubuntu.com/manpages/xenial/en/man5/subuid.5.html) man page.)

It is possible to request a container to run without a UID mapping by setting the `security.privileged` flag to true:

```auto
lxc config set c1 security.privileged true
```

Note however that in this case the root user in the container is the root user on the host.

## Apparmor

LXD confines containers by default with an apparmor profile which  protects containers from each other and the host from containers. For  instance this will prevent root in one container from signaling root in  another container, even though they have the same uid mapping. It also  prevents writing to dangerous, un-namespaced files such as many sysctls  and ` /proc/sysrq-trigger`.

If the apparmor policy for a container needs to be modified for a container `c1`, specific apparmor policy lines can be added in the `raw.apparmor` configuration key.

## Seccomp

All containers are confined by a default seccomp policy. This policy  prevents some dangerous actions such as forced umounts, kernel module  loading and unloading, kexec, and the `open_by_handle_at`  system call. The seccomp configuration cannot be modified, however a  completely different seccomp policy – or none – can be requested using `raw.lxc` (see below).

## Raw LXC configuration

LXD configures containers for the best balance of host safety and  container usability. Whenever possible it is highly recommended to use  the defaults, and use the LXD configuration keys to request LXD to  modify as needed. Sometimes, however, it may be necessary to talk to the underlying lxc driver itself. This can be done by specifying LXC  configuration items in the ‘raw.lxc’ LXD configuration key. These must  be valid items as documented in [the lxc.container.conf(5) manual page](http://manpages.ubuntu.com/manpages/focal/en/man5/lxc.container.conf.5.html).

### Snapshots

Containers can be renamed and live-migrated using the `lxc move` command:

```auto
lxc move c1 final-beta
```

They can also be snapshotted:

```auto
lxc snapshot c1 YYYY-MM-DD
```

Later changes to c1 can then be reverted by restoring the snapshot:

```auto
lxc restore u1 YYYY-MM-DD
```

New containers can also be created by copying a container or snapshot:

```auto
lxc copy u1/YYYY-MM-DD testcontainer
```

### Publishing images

When a container or container snapshot is ready for consumption by others, it can be published as a new image using;

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0
```

The published image will be private by default, meaning that LXD will not allow clients without a trusted certificate to see them. If the  image is safe for public viewing (i.e. contains no private information), then the ‘public’ flag can be set, either at publish time using

```auto
lxc publish u1/YYYY-MM-DD --alias foo-2.0 public=true
```

or after the fact using

```auto
lxc image edit foo-2.0
```

and changing the value of the public field.

### Image export and import

Image can be exported as, and imported from, tarballs:

```auto
lxc image export foo-2.0 foo-2.0.tar.gz
lxc image import foo-2.0.tar.gz --alias foo-2.0 --public
```

## Troubleshooting

To view debug information about LXD itself, on a systemd based host use

```auto
journalctl -u lxd
```

Container logfiles for container c1 may be seen using:

```auto
lxc info c1 --show-log
```

The configuration file which was used may be found under ` /var/log/lxd/c1/lxc.conf` while apparmor profiles can be found in ` /var/lib/lxd/security/apparmor/profiles/c1` and seccomp profiles in ` /var/lib/lxd/security/seccomp/c1`.

# LXC

Containers are a lightweight virtualization technology. They are more akin to an enhanced chroot than to full virtualization like Qemu or  VMware, both because they do not emulate hardware and because containers share the same operating system as the host. Containers are similar to  Solaris zones or BSD jails. Linux-vserver and OpenVZ are two  pre-existing, independently developed implementations of containers-like functionality for Linux. In fact, containers came about as a result of  the work to upstream the vserver and OpenVZ functionality.

There are two user-space implementations of containers, each  exploiting the same kernel features. Libvirt allows the use of  containers through the LXC driver by connecting to `lxc:///`. This can be very convenient as it supports the same usage as its other  drivers. The other implementation, called simply ‘LXC’, is not  compatible with libvirt, but is more flexible with more userspace tools. It is possible to switch between the two, though there are  peculiarities which can cause confusion.

In this document we will mainly describe the `lxc` package. Use of libvirt-lxc is not generally recommended due to a lack of Apparmor protection for libvirt-lxc containers.

In this document, a container name will be shown as CN, C1, or C2.

## Installation

The lxc package can be installed using

```auto
sudo apt install lxc
```

This will pull in the required and recommended dependencies, as well  as set up a network bridge for containers to use. If you wish to use  unprivileged containers, you will need to ensure that users have  sufficient allocated subuids and subgids, and will likely want to allow  users to connect containers to a bridge (see *Basic unprivileged usage* below).

## Basic usage

LXC can be used in two distinct ways - privileged, by running the lxc commands as the root user; or unprivileged, by running the lxc commands as a non-root user. (The starting of unprivileged containers by the  root user is possible, but not described here.) Unprivileged containers  are more limited, for instance being unable to create device nodes or  mount block-backed filesystems. However they are less dangerous to the  host, as the root UID in the container is mapped to a non-root UID on  the host.

### Basic privileged usage

To create a privileged container, you can simply do:

```auto
sudo lxc-create --template download --name u1
```

or, abbreviated

```auto
sudo lxc-create -t download -n u1
```

This will interactively ask for a container root filesystem type to  download – in particular the distribution, release, and architecture. To create the container non-interactively, you can specify these values on the command line:

```auto
sudo lxc-create -t download -n u1 -- --dist ubuntu --release DISTRO-SHORT-CODENAME --arch amd64
```

or

```auto
sudo lxc-create -t download -n u1 -- -d ubuntu -r DISTRO-SHORT-CODENAME -a amd64
```

You can now use `lxc-ls` to list containers, `lxc-info` to obtain detailed container information, `lxc-start` to start and `lxc-stop` to stop the container. `lxc-attach` and `lxc-console` allow you to enter a container, if ssh is not an option. `lxc-destroy` removes the container, including its rootfs. See the manual pages for  more information on each command. An example session might look like:

```auto
sudo lxc-ls --fancy
sudo lxc-start --name u1 --daemon
sudo lxc-info --name u1
sudo lxc-stop --name u1
sudo lxc-destroy --name u1
```

### User namespaces

Unprivileged containers allow users to create and administer  containers without having any root privilege. The feature underpinning  this is called user namespaces. User namespaces are hierarchical, with  privileged tasks in a parent namespace being able to map its ids into  child namespaces. By default every task on the host runs in the initial  user namespace, where the full range of ids is mapped onto the full  range. This can be seen by looking at `/proc/self/uid_map` and `/proc/self/gid_map`, which both will show `0 0 4294967295` when read from the initial user namespace. As of Ubuntu 14.04, when new users are created they are by default offered a range of UIDs. The list of assigned ids can be seen in the files `/etc/subuid` and `/etc/subgid` See their respective manpages for more information. Subuids and subgids are by convention started at id 100000 to avoid conflicting with system users.

If a user was created on an earlier release, it can be granted a range of ids using `usermod`, as follows:

```auto
sudo usermod -v 100000-200000 -w 100000-200000 user1
```

The programs `newuidmap` and `newgidmap` are setuid-root programs in the `uidmap` package, which are used internally by lxc to map subuids and subgids  from the host into the unprivileged container. They ensure that the user only maps ids which are authorized by the host configuration.

### Basic unprivileged usage

To create unprivileged containers, a few first steps are needed. You  will need to create a default container configuration file, specifying  your desired id mappings and network setup, as well as configure the  host to allow the unprivileged user to hook into the host network. The  example below assumes that your mapped user and group id ranges are  100000–165536. Check your actual user and group id ranges and modify the example accordingly:

```auto
grep $USER /etc/subuid
grep $USER /etc/subgid
mkdir -p ~/.config/lxc
echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
echo "$USER veth lxcbr0 2" | sudo tee -a /etc/lxc/lxc-usernet
```

After this, you can create unprivileged containers the same way as privileged ones, simply without using sudo.

```auto
lxc-create -t download -n u1 -- -d ubuntu -r DISTRO-SHORT-CODENAME -a amd64
lxc-start -n u1 -d
lxc-attach -n u1
lxc-stop -n u1
lxc-destroy -n u1
```

### Nesting

In order to run containers inside containers - referred to as nested  containers - two lines must be present in the parent container  configuration file:

```auto
lxc.mount.auto = cgroup
lxc.aa_profile = lxc-container-default-with-nesting
```

The first will cause the cgroup manager socket to be bound into the  container, so that lxc inside the container is able to administer  cgroups for its nested containers. The second causes the container to  run in a looser Apparmor policy which allows the container to do the  mounting required for starting containers. Note that this policy, when  used with a privileged container, is much less safe than the regular  policy or an unprivileged container. See the *Apparmor* section for more information.

## Global configuration

The following configuration files are consulted by LXC. For privileged use, they are found under `/etc/lxc`, while for unprivileged use they are under `~/.config/lxc`.

- `lxc.conf` may optionally specify alternate values for  several lxc settings, including the lxcpath, the default configuration,  cgroups to use, a cgroup creation pattern, and storage backend settings  for lvm and zfs.
- `default.conf` specifies configuration which every newly  created container should contain. This usually contains at least a  network section, and, for unprivileged users, an id mapping section
- `lxc-usernet.conf` specifies how unprivileged users may connect their containers to the host-owned network.

`lxc.conf` and `default.conf` are both under `/etc/lxc` and `$HOME/.config/lxc`, while `lxc-usernet.conf` is only host-wide.

By default, containers are located under /var/lib/lxc for the root user.

## Networking

By default LXC creates a private network namespace for each  container, which includes a layer 2 networking stack. Containers usually connect to the outside world by either having a physical NIC or a veth  tunnel endpoint passed into the container. LXC creates a NATed bridge,  lxcbr0, at host startup. Containers created using the default  configuration will have one veth NIC with the remote end plugged into  the lxcbr0 bridge. A NIC can only exist in one namespace at a time, so a physical NIC passed into the container is not usable on the host.

It is possible to create a container without a private network  namespace. In this case, the container will have access to the host  networking like any other application. Note that this is particularly  dangerous if the container is running a distribution with upstart, like  Ubuntu, since programs which talk to init, like `shutdown`, will talk over the abstract Unix domain socket to the host’s upstart, and shut down the host.

To give containers on lxcbr0 a persistent ip address based on domain name, you can write entries to `/etc/lxc/dnsmasq.conf` like:

```auto
dhcp-host=lxcmail,10.0.3.100
dhcp-host=ttrss,10.0.3.101
```

If it is desirable for the container to be publicly accessible, there are a few ways to go about it. One is to use `iptables` to forward host ports to the container, for instance

```auto
iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 587 -j DNAT \
    --to-destination 10.0.3.100:587
```

Then, specify the host’s bridge in the container configuration file in place of lxcbr0, for instance

```auto
lxc.network.type = veth
lxc.network.link = br0
```

Finally, you can ask LXC to use macvlan for the container’s NIC. Note that this has limitations and depending on configuration may not allow  the container to talk to the host itself. Therefore the other two  options are preferred and more commonly used.

There are several ways to determine the ip address for a container. First, you can use `lxc-ls --fancy` which will print the ip addresses for all running containers, or `lxc-info -i -H -n C1` which will print C1’s ip address. If dnsmasq is installed on the host, you can also add an entry to `/etc/dnsmasq.conf` as follows

```auto
server=/lxc/10.0.3.1
```

after which dnsmasq will resolve `C1.lxc` locally, so that you can do:

```auto
ping C1
ssh C1
```

For more information, see the `lxc.conf(5)` manpage as well as the example network configurations under `/usr/share/doc/lxc/examples/`.

## LXC startup

LXC does not have a long-running daemon. However it does have three upstart jobs.

- `/etc/init/lxc-net.conf:` is an optional job which only runs if `/etc/default/lxc-net` specifies `USE_LXC_BRIDGE` (true by default). It sets up a NATed bridge for containers to use.
- `/etc/init/lxc.conf` loads the lxc apparmor profiles and  optionally starts any autostart containers. The autostart containers  will be ignored if LXC_AUTO (true by default) is set to true in `/etc/default/lxc`. See the lxc-autostart manual page for more information on autostarted containers.
- `/etc/init/lxc-instance.conf` is used by `/etc/init/lxc.conf` to autostart a container.

## Backing Stores

LXC supports several backing stores for container root filesystems.  The default is a simple directory backing store, because it requires no  prior host customization, so long as the underlying filesystem is large  enough. It also requires no root privilege to create the backing store,  so that it is seamless for unprivileged use. The rootfs for a privileged directory backed container is located (by default) under `/var/lib/lxc/C1/rootfs`, while the rootfs for an unprivileged container is under `~/.local/share/lxc/C1/rootfs`. If a custom lxcpath is specified in [lxc.system.com](http://lxc.system.com), then the container rootfs will be under `$lxcpath/C1/rootfs`.

A snapshot clone C2 of a directory backed container C1 becomes an overlayfs backed container, with a rootfs called `overlayfs:/var/lib/lxc/C1/rootfs:/var/lib/lxc/C2/delta0`. Other backing store types include loop, btrfs, LVM and zfs.

A btrfs backed container mostly looks like a directory backed  container, with its root filesystem in the same location. However, the  root filesystem comprises a subvolume, so that a snapshot clone is  created using a subvolume snapshot.

The root filesystem for an LVM backed container can be any separate  LV. The default VG name can be specified in lxc.conf. The filesystem  type and size are configurable per-container using lxc-create.

The rootfs for a zfs backed container is a separate zfs filesystem, mounted under the traditional `/var/lib/lxc/C1/rootfs` location. The zfsroot can be specified at lxc-create, and a default can be specified in lxc.system.conf.

More information on creating containers with the various backing stores can be found in the lxc-create manual page.

## Templates

Creating a container generally involves creating a root filesystem for the container. `lxc-create` delegates this work to *templates*, which are generally per-distribution. The lxc templates shipped with lxc can be found under `/usr/share/lxc/templates`, and include templates to create Ubuntu, Debian, Fedora, Oracle, centos, and gentoo containers among others.

Creating distribution images in most cases requires the ability to  create device nodes, often requires tools which are not available in  other distributions, and usually is quite time-consuming. Therefore lxc  comes with a special *download* template, which downloads  pre-built container images from a central lxc server. The most important use case is to allow simple creation of unprivileged containers by  non-root users, who could not for instance easily run the `debootstrap` command.

When running `lxc-create`, all options which come after *–* are passed to the template. In the following command, *–name*, *–template* and *–bdev* are passed to `lxc-create`, while *–release* is passed to the template:

```auto
lxc-create --template ubuntu --name c1 --bdev loop -- --release DISTRO-SHORT-CODENAME
```

You can obtain help for the options supported by any particular container by passing *–help* and the template name to `lxc-create`. For instance, for help with the download template,

```auto
lxc-create --template download --help
```

## Autostart

LXC supports marking containers to be started at system boot. Prior  to Ubuntu 14.04, this was done using symbolic links under the directory `/etc/lxc/auto`. Starting with Ubuntu 14.04, it is done through the container configuration files. An entry

```auto
lxc.start.auto = 1
lxc.start.delay = 5
```

would mean that the container should be started at boot, and the  system should wait 5 seconds before starting the next container. LXC  also supports ordering and grouping of containers, as well as reboot and shutdown by autostart groups. See the manual pages for lxc-autostart  and lxc.container.conf for more information.

## Apparmor

LXC ships with a default Apparmor profile intended to protect the  host from accidental misuses of privilege inside the container. For  instance, the container will not be able to write to `/proc/sysrq-trigger` or to most `/sys` files.

The `usr.bin.lxc-start` profile is entered by running `lxc-start`. This profile mainly prevents `lxc-start` from mounting new filesystems outside of the container’s root filesystem. Before executing the container’s `init`, `LXC` requests a switch to the container’s profile. By default, this profile is the `lxc-container-default` policy which is defined in `/etc/apparmor.d/lxc/lxc-default`. This profile prevents the container from accessing many dangerous paths, and from mounting most filesystems.

Programs in a container cannot be further confined - for instance,  MySQL runs under the container profile (protecting the host) but will  not be able to enter the MySQL profile (to protect the container).

`lxc-execute` does not enter an Apparmor profile, but the container it spawns will be confined.

### Customizing container policies

If you find that `lxc-start` is failing due to a  legitimate access which is being denied by its Apparmor policy, you can  disable the lxc-start profile by doing:

```auto
sudo apparmor_parser -R /etc/apparmor.d/usr.bin.lxc-start
sudo ln -s /etc/apparmor.d/usr.bin.lxc-start /etc/apparmor.d/disabled/
```

This will make `lxc-start` run unconfined, but continue to confine the container itself. If you also wish to disable confinement  of the container, then in addition to disabling the `usr.bin.lxc-start` profile, you must add:

```auto
lxc.aa_profile = unconfined
```

to the container’s configuration file.

LXC ships with a few alternate policies for containers. If you wish  to run containers inside containers (nesting), then you can use the  lxc-container-default-with-nesting profile by adding the following line  to the container configuration file

```auto
lxc.aa_profile = lxc-container-default-with-nesting
```

If you wish to use libvirt inside containers, then you will need to edit that policy (which is defined in `/etc/apparmor.d/lxc/lxc-default-with-nesting`) by uncommenting the following line:

```auto
mount fstype=cgroup -> /sys/fs/cgroup/**,
```

and re-load the policy.

Note that the nesting policy with privileged containers is far less  safe than the default policy, as it allows containers to re-mount `/sys` and `/proc` in nonstandard locations, bypassing apparmor protections. Unprivileged  containers do not have this drawback since the container root cannot  write to root-owned `proc` and `sys` files.

Another profile shipped with lxc allows containers to mount block  filesystem types like ext4. This can be useful in some cases like maas  provisioning, but is deemed generally unsafe since the superblock  handlers in the kernel have not been audited for safe handling of  untrusted input.

If you need to run a container in a custom profile, you can create a new profile under `/etc/apparmor.d/lxc/`. Its name must start with `lxc-` in order for `lxc-start` to be allowed to transition to that profile. The `lxc-default` profile includes the re-usable abstractions file `/etc/apparmor.d/abstractions/lxc/container-base`. An easy way to start a new profile therefore is to do the same, then add extra permissions at the bottom of your policy.

After creating the policy, load it using:

```auto
sudo apparmor_parser -r /etc/apparmor.d/lxc-containers
```

The profile will automatically be loaded after a reboot, because it is sourced by the file `/etc/apparmor.d/lxc-containers`. Finally, to make container `CN` use this new `lxc-CN-profile`, add the following line to its configuration file:

```auto
lxc.aa_profile = lxc-CN-profile
```

## Control Groups

Control groups (cgroups) are a kernel feature providing hierarchical  task grouping and per-cgroup resource accounting and limits. They are  used in containers to limit block and character device access and to  freeze (suspend) containers. They can be further used to limit memory  use and block i/o, guarantee minimum cpu shares, and to lock containers  to specific cpus.

By default, a privileged container CN will be assigned to a cgroup called `/lxc/CN`. In the case of name conflicts (which can occur when using custom  lxcpaths) a suffix “-n”, where n is an integer starting at 0, will be  appended to the cgroup name.

By default, a privileged container CN will be assigned to a cgroup called `CN` under the cgroup of the task which started the container, for instance `/usr/1000.user/1.session/CN`. The container root will be given group ownership of the directory (but  not all files) so that it is allowed to create new child cgroups.

As of Ubuntu 14.04, LXC uses the cgroup manager (cgmanager) to  administer cgroups. The cgroup manager receives D-Bus requests over the  Unix socket `/sys/fs/cgroup/cgmanager/sock`. To facilitate safe nested containers, the line

```auto
lxc.mount.auto = cgroup
```

can be added to the container configuration causing the `/sys/fs/cgroup/cgmanager` directory to be bind-mounted into the container. The container in turn  should start the cgroup management proxy (done by default if the  cgmanager package is installed in the container) which will move the `/sys/fs/cgroup/cgmanager` directory to `/sys/fs/cgroup/cgmanager.lower`, then start listening for requests to proxy on its own socket `/sys/fs/cgroup/cgmanager/sock`. The host cgmanager will ensure that nested containers cannot escape  their assigned cgroups or make requests for which they are not  authorized.

## Cloning

For rapid provisioning, you may wish to customize a canonical  container according to your needs and then make multiple copies of it.  This can be done with the `lxc-clone` program.

Clones are either snapshots or copies of another container. A copy is a new container copied from the original, and takes as much space on  the host as the original. A snapshot exploits the underlying backing  store’s snapshotting ability to make a copy-on-write container  referencing the first. Snapshots can be created from btrfs, LVM, zfs,  and directory backed containers. Each backing store has its own  peculiarities - for instance, LVM containers which are not  thinpool-provisioned cannot support snapshots of snapshots; zfs  containers with snapshots cannot be removed until all snapshots are  released; LVM containers must be more carefully planned as the  underlying filesystem may not support growing; btrfs does not suffer any of these shortcomings, but suffers from reduced fsync performance  causing dpkg and apt to be slower.

Snapshots of directory-packed containers are created using the  overlay filesystem. For instance, a privileged directory-backed  container C1 will have its root filesystem under `/var/lib/lxc/C1/rootfs`. A snapshot clone of C1 called C2 will be started with C1’s rootfs mounted readonly under `/var/lib/lxc/C2/delta0`. Importantly, in this case C1 should not be allowed to run or be removed while C2 is running. It is advised instead to consider C1 a *canonical* base container, and to only use its snapshots.

Given an existing container called C1, a copy can be created using:

```auto
sudo lxc-clone -o C1 -n C2
```

A snapshot can be created using:

```auto
sudo lxc-clone -s -o C1 -n C2
```

See the lxc-clone manpage for more information.

### Snapshots

To more easily support the use of snapshot clones for iterative container development, LXC supports *snapshots*. When working on a container C1, before making a potentially dangerous or hard-to-revert change, you can create a snapshot

```auto
sudo lxc-snapshot -n C1
```

which is a snapshot-clone called ‘snap0’ under /var/lib/lxcsnaps or  $HOME/.local/share/lxcsnaps. The next snapshot will be called ‘snap1’,  etc. Existing snapshots can be listed using `lxc-snapshot -L -n C1`, and a snapshot can be restored - erasing the current C1 container - using `lxc-snapshot -r snap1 -n C1`. After the restore command, the snap1 snapshot continues to exist, and  the previous C1 is erased and replaced with the snap1 snapshot.

Snapshots are supported for btrfs, lvm, zfs, and overlayfs  containers. If lxc-snapshot is called on a directory-backed container,  an error will be logged and the snapshot will be created as a  copy-clone. The reason for this is that if the user creates an overlayfs snapshot of a directory-backed container and then makes changes to the  directory-backed container, then the original container changes will be  partially reflected in the snapshot. If snapshots of a directory backed  container C1 are desired, then an overlayfs clone of C1 should be  created, C1 should not be touched again, and the overlayfs clone can be  edited and snapshotted at will, as such

```auto
lxc-clone -s -o C1 -n C2
lxc-start -n C2 -d # make some changes
lxc-stop -n C2
lxc-snapshot -n C2
lxc-start -n C2 # etc
```

### Ephemeral Containers

While snapshots are useful for longer-term incremental development of images, ephemeral containers utilize snapshots for quick, single-use  throwaway containers. Given a base container C1, you can start an  ephemeral container using

```auto
lxc-start-ephemeral -o C1
```

The container begins as a snapshot of C1. Instructions for logging  into the container will be printed to the console. After shutdown, the  ephemeral container will be destroyed. See the lxc-start-ephemeral  manual page for more options.

## Lifecycle management hooks

Beginning with Ubuntu 12.10, it is possible to define hooks to be executed at specific points in a container’s lifetime:

- Pre-start hooks are run in the host’s namespace before the container ttys, consoles, or mounts are up. If any mounts are done in this hook,  they should be cleaned up in the post-stop hook.
- Pre-mount hooks are run in the container’s namespaces, but before  the root filesystem has been mounted. Mounts done in this hook will be  automatically cleaned up when the container shuts down.
- Mount hooks are run after the container filesystems have been mounted, but before the container has called `pivot_root` to change its root filesystem.
- Start hooks are run immediately before executing the container’s  init. Since these are executed after pivoting into the container’s  filesystem, the command to be executed must be copied into the  container’s filesystem.
- Post-stop hooks are executed after the container has been shut down.

If any hook returns an error, the container’s run will be aborted. Any *post-stop* hook will still be executed. Any output generated by the script will be logged at the debug priority.

Please see the `lxc.container.conf(5)` manual page for the configuration file format with which to specify hooks. Some sample  hooks are shipped with the lxc package to serve as an example of how to  write and use such hooks.

## Consoles

Containers have a configurable number of consoles. One always exists on the container’s `/dev/console`. This is shown on the terminal from which you ran `lxc-start`, unless the *-d* option is specified. The output on `/dev/console` can be redirected to a file using the *-c console-file* option to `lxc-start`. The number of extra consoles is specified by the `lxc.tty` variable, and is usually set to 4. Those consoles are shown on `/dev/ttyN` (for 1 <= N <= 4). To log into console 3 from the host, use:

```auto
sudo lxc-console -n container -t 3
```

or if the `-t N` option is not specified, an unused console will be automatically chosen. To exit the console, use the escape sequence `Ctrl-a q`. Note that the escape sequence does not work in the console resulting from `lxc-start` without the `-d` option.

Each container console is actually a Unix98 pty in the host’s (not the guest’s) pty mount, bind-mounted over the guest’s `/dev/ttyN` and `/dev/console`. Therefore, if the guest unmounts those or otherwise tries to access the actual character device `4:N`, it will not be serving getty to the LXC consoles. (With the default  settings, the container will not be able to access that character device and getty will therefore fail.) This can easily happen when a boot  script blindly mounts a new `/dev`.

## Troubleshooting

### Logging

If something goes wrong when starting a container, the first step should be to get full logging from LXC:

```auto
sudo lxc-start -n C1 -l trace -o debug.out
```

This will cause lxc to log at the most verbose level, `trace`, and to output log information to a file called ‘debug.out’. If the file `debug.out` already exists, the new log information will be appended.

### Monitoring container status

Two commands are available to monitor container state changes. `lxc-monitor` monitors one or more containers for any state changes. It takes a container name as usual with the *-n* option, but in this case the container name can be a posix regular  expression to allow monitoring desirable sets of containers. `lxc-monitor` continues running as it prints container changes. `lxc-wait` waits for a specific state change and then exits. For instance,

```auto
sudo lxc-monitor -n cont[0-5]*
```

would print all state changes to any containers matching the listed regular expression, whereas

```auto
sudo lxc-wait -n cont1 -s 'STOPPED|FROZEN'
```

will wait until container cont1 enters state STOPPED or state FROZEN and then exit.

### Attach

As of Ubuntu 14.04, it is possible to attach to a container’s namespaces. The simplest case is to simply do

```auto
sudo lxc-attach -n C1
```

which will start a shell attached to C1’s namespaces, or, effectively inside the container. The attach functionality is very flexible,  allowing attaching to a subset of the container’s namespaces and  security context. See the manual page for more information.

### Container init verbosity

If LXC completes the container startup, but the container init fails  to complete (for instance, no login prompt is shown), it can be useful  to request additional verbosity from the init process. For an upstart  container, this might be:

```auto
sudo lxc-start -n C1 /sbin/init loglevel=debug
```

You can also start an entirely different program in place of init, for instance

```auto
sudo lxc-start -n C1 /bin/bash
sudo lxc-start -n C1 /bin/sleep 100
sudo lxc-start -n C1 /bin/cat /proc/1/status
```

## LXC API

Most of the LXC functionality can now be accessed through an API exported by `liblxc` for which bindings are available in several languages, including Python, lua, ruby, and go.

Below is an example using the python bindings (which are available in the python3-lxc package) which creates and starts a container, then  waits until it has been shut down:

```auto
# sudo python3
Python 3.2.3 (default, Aug 28 2012, 08:26:03)
[GCC 4.7.1 20120814 (prerelease)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import lxc
__main__:1: Warning: The python-lxc API isn't yet stable and may change at any point in the future.
>>> c=lxc.Container("C1")
>>> c.create("ubuntu")
True
>>> c.start()
True
>>> c.wait("STOPPED")
True
```

## Security

A namespace maps ids to resources. By not providing a container any  id with which to reference a resource, the resource can be protected.  This is the basis of some of the security afforded to container users.  For instance, IPC namespaces are completely isolated. Other namespaces,  however, have various *leaks* which allow privilege to be inappropriately exerted from a container into another container or to the host.

By default, LXC containers are started under a Apparmor policy to  restrict some actions. The details of AppArmor integration with lxc are  in section *Apparmor*. Unprivileged containers go further by mapping root in the container to an unprivileged host UID. This prevents access to `/proc` and `/sys` files representing host resources, as well as any other files owned by root on the host.

### Exploitable system calls

It is a core container feature that containers share a kernel with  the host. Therefore if the kernel contains any exploitable system calls  the container can exploit these as well. Once the container controls the kernel it can fully control any resource known to the host.

In general to run a full distribution container a large number of  system calls will be needed. However for application containers it may  be possible to reduce the number of available system calls to only a  few. Even for system containers running a full distribution security  gains may be had, for instance by removing the 32-bit compatibility  system calls in a 64-bit container. See the lxc.container.conf manual  page for details of how to configure a container to use seccomp. By  default, no seccomp policy is loaded.

## Resources

- The DeveloperWorks article [LXC: Linux container tools](https://developer.ibm.com/tutorials/l-lxc-containers/) was an early introduction to the use of containers.
- The [Secure Containers Cookbook](http://www.ibm.com/developerworks/linux/library/l-lxc-security/index.html) demonstrated the use of security modules to make containers more secure.
- The upstream LXC project is hosted at [linuxcontainers.org](http://linuxcontainers.org).

# Network File System (NFS)

NFS allows a system to share directories and files with others over a network. By using NFS, users and programs can access files on remote  systems almost as if they were local files.

Some of the most notable benefits that NFS can provide are:

- Local workstations use less disk space because commonly used data can be stored on a single machine and still remain accessible to others  over the network.
- There is no need for users to have separate home directories on every network machine. Home directories could be set up on the NFS server and made available throughout the network.
- Storage devices such as floppy disks, CDROM drives, and USB Thumb  drives can be used by other machines on the network. This may reduce the number of removable media drives throughout the network.

## Installation

At a terminal prompt enter the following command to install the NFS Server:

```
sudo apt install nfs-kernel-server
```

To start the NFS server, you can run the following command at a terminal prompt:

```
sudo systemctl start nfs-kernel-server.service
```

## Configuration

You can configure the directories to be exported by adding them to the `/etc/exports` file. For example:

```
/srv     *(ro,sync,subtree_check)
/home    *.hostname.com(rw,sync,no_subtree_check)
/scratch *(rw,async,no_subtree_check,no_root_squash,noexec)
```

Make sure any custom mount points you’re adding have been created (/srv and /home will already exist):

```
sudo mkdir /scratch
```

Apply the new config via:

```
sudo exportfs -a
```

You can replace * with one of the hostname formats. Make the hostname declaration as specific as possible so unwanted systems cannot access  the NFS mount.  Be aware that `*.hostname.com` will match` foo.hostname.com` but not `foo.bar.my-domain.com`.

The *sync*/*async* options control whether changes are gauranteed to be committed to stable storage before replying to requests.  *async* thus gives a performance benefit but risks data loss or corruption.  Even though *sync* is the default, it’s worth setting since exportfs will issue a warning if it’s left unspecified.

*subtree_check* and *no_subtree_check* enables or  disables a security verification that subdirectories a client attempts  to mount for an exported filesystem are ones they’re permitted to do so.  This verification step has some performance implications for some use  cases, such as home directories with frequent file renames.  Read-only  filesystems are more suitable to enable *subtree_check* on.  Like with sync, exportfs will warn if it’s left unspecified.

There are a number of optional settings for NFS mounts for tuning  performance, tightening security, or providing conveniences.  These  settings each have their own trade-offs so it is important to use them  with care, only as needed for the particular use case.  *no_root_squash*, for example, adds a convenience to allow root-owned files to be  modified by any client system’s root user; in a multi-user environment  where executables are allowed on a shared mount point, this could lead  to security problems.  *noexec* prevents executables from running from the mount point.

## NFS Client Configuration

To enable NFS support on a client system, enter the following command at the terminal prompt:

```
sudo apt install nfs-common
```

Use the mount command to mount a shared NFS directory from another  machine, by typing a command line similar to the following at a terminal prompt:

```
sudo mkdir /opt/example
sudo mount example.hostname.com:/srv /opt/example
```

> **Warning**
>
> The mount point directory `/opt/example` must exist. There should be no files or subdirectories in the `/opt/example` directory, else they will become inaccessible until the nfs filesystem is unmounted.

An alternate way to mount an NFS share from another machine is to add a line to the `/etc/fstab` file. The line must state the hostname of the NFS server, the directory on the server being exported, and the directory on the local machine  where the NFS share is to be mounted.

The general syntax for the line in `/etc/fstab` file is as follows:

```
example.hostname.com:/srv /opt/example nfs rsize=8192,wsize=8192,timeo=14,intr
```

## References

[Linux NFS wiki](http://linux-nfs.org/wiki/)
 [Linux NFS faq](http://nfs.sourceforge.net/)

[Ubuntu Wiki NFS Howto](https://help.ubuntu.com/community/SettingUpNFSHowTo)
 [Ubuntu Wiki NFSv4 Howto](https://help.ubuntu.com/community/NFSv4Howto)

# OpenSSH Server

## Introduction

OpenSSH is a powerful collection of tools for the remote control of,  and transfer of data between, networked computers. You will also learn  about some of the configuration settings possible with the OpenSSH  server application and how to change them on your Ubuntu system.

OpenSSH is a freely available version of the Secure Shell (SSH)  protocol family of tools for remotely controlling, or transferring files between, computers. Traditional tools used to accomplish these  functions, such as telnet or rcp, are insecure and transmit the user’s  password in cleartext when used. OpenSSH provides a server daemon and  client tools to facilitate secure, encrypted remote control and file  transfer operations, effectively replacing the legacy tools.

The OpenSSH server component, sshd, listens continuously for client  connections from any of the client tools. When a connection request  occurs, sshd sets up the correct connection depending on the type of  client tool connecting. For example, if the remote computer is  connecting with the ssh client application, the OpenSSH server sets up a remote control session after authentication. If a remote user connects  to an OpenSSH server with scp, the OpenSSH server daemon initiates a  secure copy of files between the server and client after authentication. OpenSSH can use many authentication methods, including plain password,  public key, and Kerberos tickets.

## Installation

Installation of the OpenSSH client and server applications is simple. To install the OpenSSH client applications on your Ubuntu system, use  this command at a terminal prompt:

```
sudo apt install openssh-client
```

To install the OpenSSH server application, and related support files, use this command at a terminal prompt:

```
sudo apt install openssh-server
```

## Configuration

You may configure the default behavior of the OpenSSH server application, sshd, by editing the file `/etc/ssh/sshd_config`. For information about the configuration directives used in this file,  you may view the appropriate manual page with the following command,  issued at a terminal prompt:

```
man sshd_config
```

There are many directives in the sshd configuration file controlling  such things as communication settings, and authentication modes. The  following are examples of configuration directives that can be changed  by editing the `/etc/ssh/sshd_config` file.

> **Tip**
>
> Prior to editing the configuration file, you should make a copy of  the original file and protect it from writing so you will have the  original settings as a reference and to reuse as necessary.
>
> Copy the `/etc/ssh/sshd_config` file and protect it from writing with the following commands, issued at a terminal prompt:
>
> ```
> sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
> sudo chmod a-w /etc/ssh/sshd_config.original
> ```

Furthermore since losing an ssh server might mean losing your way to  reach a server, check the configuration after changing it and before  restarting the server:

```
sudo sshd -t -f /etc/ssh/sshd_config
```

The following are *examples* of configuration directives you may change:

- To set your OpenSSH to listen on TCP port 2222 instead of the default TCP port 22, change the Port directive as such:

> Port 2222

- To make your OpenSSH server display the contents of the `/etc/issue.net` file as a pre-login banner, simply add or modify this line in the `/etc/ssh/sshd_config` file:

> Banner /etc/issue.net

After making changes to the `/etc/ssh/sshd_config` file,  save the file, and restart the sshd server application to effect the  changes using the following command at a terminal prompt:

```
sudo systemctl restart sshd.service
```

> **Warning**
>
> Many other configuration directives for sshd are available to change  the server application’s behavior to fit your needs. Be advised,  however, if your only method of access to a server is ssh, and you make a mistake in configuring sshd via the `/etc/ssh/sshd_config`  file, you may find you are locked out of the server upon restarting it.  Additionally, if an incorrect configuration directive is supplied, the  sshd server may refuse to start, so be extra careful when editing this  file on a remote server.

## SSH Keys

SSH allow authentication between two hosts without the need of a password. SSH key authentication uses a *private key* and a *public key*.

To generate the keys, from a terminal prompt enter:

```
ssh-keygen -t rsa
```

This will generate the keys using the *RSA Algorithm*.  At the time of this writing, the generated keys will have 3072 bits.  You can modify the number of bits by using the `-b` option.  For example, to generate keys with 4096 bits, you can do:

```
ssh-keygen -t rsa -b 4096
```

During the process you will be prompted for a password. Simply hit *Enter* when prompted to create the key.

By default the *public* key is saved in the file `~/.ssh/id_rsa.pub`, while `~/.ssh/id_rsa` is the *private* key. Now copy the `id_rsa.pub` file to the remote host and append it to `~/.ssh/authorized_keys` by entering:

```
ssh-copy-id username@remotehost
```

Finally, double check the permissions on the `authorized_keys` file, only the authenticated user should have read and write permissions. If the permissions are not correct change them by:

```
chmod 600 .ssh/authorized_keys
```

You should now be able to SSH to the host without being prompted for a password.

## Import keys from public keyservers

These days many users have already ssh keys registered with services  like launchpad or github. Those can be easily imported with:

```
ssh-import-id <username-on-remote-service>
```

The prefix `lp:` is implied and means fetching from launchpad, the alternative `gh:` will make the tool fetch from github instead.

## Two factor authentication with U2F/FIDO

OpenSSH 8.2 [added support for U2F/FIDO hardware authentication devices](https://www.openssh.com/txt/release-8.2). These devices are used to provide an extra layer of security on top of  the existing key-based authentication, as the hardware token needs to be present to finish the authentication.

It’s very simple to use and setup. The only extra step is generate a  new keypair that can be used with the hardware device. For that, there  are two key types that can be used: `ecdsa-sk` and `ed25519-sk`. The former has broader hardware support, while the latter might need a more recent device.

Once the keypair is generated, it can be used as you would normally  use any other type of key in openssh. The only requirement is that in  order to use the private key, the U2F device has to be present on the  host.

For example, plug the U2F device in and generate a keypair to use with it:

```
$ ssh-keygen -t ecdsa-sk
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation. <-- touch device
Enter file in which to save the key (/home/ubuntu/.ssh/id_ecdsa_sk): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ubuntu/.ssh/id_ecdsa_sk
Your public key has been saved in /home/ubuntu/.ssh/id_ecdsa_sk.pub
The key fingerprint is:
SHA256:V9PQ1MqaU8FODXdHqDiH9Mxb8XK3o5aVYDQLVl9IFRo ubuntu@focal
```

Now just transfer the public part to the server to `~/.ssh/authorized_keys` and you are ready to go:

```
$ ssh -i .ssh/id_ecdsa_sk ubuntu@focal.server
Confirm user presence for key ECDSA-SK SHA256:V9PQ1MqaU8FODXdHqDiH9Mxb8XK3o5aVYDQLVl9IFRo <-- touch device
Welcome to Ubuntu Focal Fossa (GNU/Linux 5.4.0-21-generic x86_64)
(...)
ubuntu@focal.server:~$
```

## References

- [Ubuntu Wiki SSH](https://help.ubuntu.com/community/SSH) page.
- [OpenSSH Website](http://www.openssh.org/)
- [OpenSSH 8.2 release notes](https://www.openssh.com/txt/release-8.2)
- [Advanced OpenSSH Wiki Page](https://wiki.ubuntu.com/AdvancedOpenSSH)

# SSSD

SSSD stands for System Security Services Daemon and it’s actually a  collection of daemons that handle authentication, authorization, and  user and group information from a variety of network sources. At its  core it has support for:

- Active Directory
- LDAP
- Kerberos

SSSD provides PAM and NSS modules to integrate these remote sources  into your system and allow remote users to login and be recognized as  valid users, including group membership. To allow for disconnected  operation, SSSD also can also cache this information, so that users can  continue to login in the event of a network failure, or other problem of the same sort.

This guide will focus on the most common scenarios where SSSD is deployed.

## SSSD and Active Directory

This section describes the use of sssd to authenticate user logins  against an Active Directory via using sssd’s “ad” provider. At the end,  Active Directory users will be able to login on the host using their AD  credentials. Group membership will also be maintained.

### Prerequisites, Assumptions, and Requirements

- This guide does not explain Active Directory, how it works, how to set one up, or how to maintain it.
- This guide assumes that a working Active Directory domain is already  configured and you have access to the credentials to join a machine to  that domain.
- The domain controller is acting as an authoritative DNS server for the domain.
- The domain controller is the primary DNS resolver (check with `systemd-resolve --status`)
- System time is correct and in sync, maintained via a service like *chrony* or *ntp*
- The domain used in this example is *`ad1.example.com`* .

### Software Installation

Install the following packages:

```
sudo apt install sssd-ad sssd-tools realmd adcli
```

### Join the domain

We will use the `realm` command, from the `realmd` package, to join the domain and create the sssd configuration.

Let’s verify the domain is discoverable via DNS:

```
$ sudo realm -v discover ad1.example.com
 * Resolving: _ldap._tcp.ad1.example.com
 * Performing LDAP DSE lookup on: 10.51.0.5
 * Successfully discovered: ad1.example.com
ad1.example.com
  type: kerberos
  realm-name: AD1.EXAMPLE.COM
  domain-name: ad1.example.com
  configured: no
  server-software: active-directory
  client-software: sssd
  required-package: sssd-tools
  required-package: sssd
  required-package: libnss-sss
  required-package: libpam-sss
  required-package: adcli
  required-package: samba-common-bin
```

This performs several checks and determines the best software stack to use with sssd. sssd can install the missing packages via *packagekit*, but we installed them already previously.

Now let’s join the domain:

```
$ sudo realm join ad1.example.com
Password for Administrator: 
```

That was quite uneventful. If you want to see what it was doing, pass the `-v` option:

```
$ sudo realm join -v ad1.example.com
 * Resolving: _ldap._tcp.ad1.example.com
 * Performing LDAP DSE lookup on: 10.51.0.5
 * Successfully discovered: ad1.example.com
Password for Administrator: 
 * Unconditionally checking packages
 * Resolving required packages
 * LANG=C /usr/sbin/adcli join --verbose --domain ad1.example.com --domain-realm AD1.EXAMPLE.COM --domain-controller 10.51.0.5 --login-type user --login-user Administrator --stdin-password
 * Using domain name: ad1.example.com
 * Calculated computer account name from fqdn: AD-CLIENT
 * Using domain realm: ad1.example.com
 * Sending NetLogon ping to domain controller: 10.51.0.5
 * Received NetLogon info from: SERVER1.ad1.example.com
 * Wrote out krb5.conf snippet to /var/cache/realmd/adcli-krb5-hUfTUg/krb5.d/adcli-krb5-conf-hv2kzi
 * Authenticated as user: Administrator@AD1.EXAMPLE.COM
 * Looked up short domain name: AD1
 * Looked up domain SID: S-1-5-21-2660147319-831819607-3409034899
 * Using fully qualified name: ad-client.ad1.example.com
 * Using domain name: ad1.example.com
 * Using computer account name: AD-CLIENT
 * Using domain realm: ad1.example.com
 * Calculated computer account name from fqdn: AD-CLIENT
 * Generated 120 character computer password
 * Using keytab: FILE:/etc/krb5.keytab
 * Found computer account for AD-CLIENT$ at: CN=AD-CLIENT,CN=Computers,DC=ad1,DC=example,DC=com
 * Sending NetLogon ping to domain controller: 10.51.0.5
 * Received NetLogon info from: SERVER1.ad1.example.com
 * Set computer password
 * Retrieved kvno '3' for computer account in directory: CN=AD-CLIENT,CN=Computers,DC=ad1,DC=example,DC=com
 * Checking RestrictedKrbHost/ad-client.ad1.example.com
 *    Added RestrictedKrbHost/ad-client.ad1.example.com
 * Checking RestrictedKrbHost/AD-CLIENT
 *    Added RestrictedKrbHost/AD-CLIENT
 * Checking host/ad-client.ad1.example.com
 *    Added host/ad-client.ad1.example.com
 * Checking host/AD-CLIENT
 *    Added host/AD-CLIENT
 * Discovered which keytab salt to use
 * Added the entries to the keytab: AD-CLIENT$@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: host/AD-CLIENT@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: host/ad-client.ad1.example.com@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: RestrictedKrbHost/AD-CLIENT@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * Added the entries to the keytab: RestrictedKrbHost/ad-client.ad1.example.com@AD1.EXAMPLE.COM: FILE:/etc/krb5.keytab
 * /usr/sbin/update-rc.d sssd enable
 * /usr/sbin/service sssd restart
 * Successfully enrolled machine in realm
```

By default, *realm* will use the *Administrator* account of the domain to request the join. If you need to use another account, pass it to the tool with the `-U` option.

Another popular way of joining a domain is using an *OTP*, or *One Time Password*, token. For that, use the `--one-time-password` option.

### SSSD Configuration

The *realm* tool already took care of creating an sssd configuration, adding the pam and nss modules, and starting the necessary services.

Let’s take a look at `/etc/sssd/sssd.conf`:

```
[sssd]
domains = ad1.example.com
config_file_version = 2
services = nss, pam

[domain/ad1.example.com]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = AD1.EXAMPLE.COM
realmd_tags = manages-system joined-with-adcli 
id_provider = ad
fallback_homedir = /home/%u@%d
ad_domain = ad1.example.com
use_fully_qualified_names = True
ldap_id_mapping = True
access_provider = ad
```

> **Note**
>
> Something very important to remember is that this file must have permissions *0600* and ownership *root:root*, or else sssd won’t start!

Let’s highlight a few things from this config:

- *cache_credentials*: this allows logins when the AD server is unreachable
- home directory: it’s by default `/home/<user>@<domain>`. For example, the AD user *john* will have a home directory of */home/john@ad1.example.com*
- *use_fully_qualified_names*: users will be of the form *user@domain*, not just *user*. This should only be changed if you are certain no other domains will  ever join the AD forest, via one of the several possible trust  relationships

### Automatic home directory creation

What the `realm` tool didn’t do for us is setup `pam_mkhomedir`, so that network users can get a home directory when they login. This  remaining step can be done by running the following command:

```
sudo pam-auth-update --enable mkhomedir
```

### Checks

You should now be able to fetch information about AD users. In this example, *John Smith* is an AD user:

```
$ getent passwd john@ad1.example.com
john@ad1.example.com:*:1725801106:1725800513:John Smith:/home/john@ad1.example.com:/bin/bash
```

Let’s see his groups:

```
$ groups john@ad1.example.com
john@ad1.example.com : domain users@ad1.example.com engineering@ad1.example.com
```

> **Note**
>
> If you just changed the group membership of a user, it may be a while before sssd notices due to caching.

Finally, how about we try a login:

```
$ sudo login
ad-client login: john@ad1.example.com
Password: 
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
...
Creating directory '/home/john@ad1.example.com'.
john@ad1.example.com@ad-client:~$ 
```

Notice how the home directory was automatically created.

You can also use ssh, but note that the command will look a bit funny because of the multiple *@* signs:

```
$ ssh john@ad1.example.com@10.51.0.11
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Last login: Thu Apr 16 21:22:55 2020
john@ad1.example.com@ad-client:~$ 
```

> **Note**
>
> In the ssh example, public key authentication was used, so no  password was required. Remember that ssh password authentication is by  default disabled in `/etc/ssh/sshd_config`.

### Kerberos Tickets

If you install `krb5-user`, your AD users will also get a kerberos ticket upon logging in:

```
john@ad1.example.com@ad-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1725801106_9UxVIz
Default principal: john@AD1.EXAMPLE.COM

Valid starting     Expires            Service principal
04/16/20 21:32:12  04/17/20 07:32:12  krbtgt/AD1.EXAMPLE.COM@AD1.EXAMPLE.COM
	renew until 04/17/20 21:32:12
```

> **Note**
>
> *realm* also configured `/etc/krb5.conf` for you, so there should be no further configuration prompts when installing `krb5-user`

Let’s test with *smbclient* using kerberos authentication to list he shares of the domain controller:

```
john@ad1.example.com@ad-client:~$ smbclient -k -L server1.ad1.example.com

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	NETLOGON        Disk      Logon server share 
	SYSVOL          Disk      Logon server share 
SMB1 disabled -- no workgroup available
```

Notice how we now have a ticket for the *cifs* service, which was used for the share list above:

```
john@ad1.example.com@ad-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1725801106_9UxVIz
Default principal: john@AD1.EXAMPLE.COM

Valid starting     Expires            Service principal
04/16/20 21:32:12  04/17/20 07:32:12  krbtgt/AD1.EXAMPLE.COM@AD1.EXAMPLE.COM
	renew until 04/17/20 21:32:12
04/16/20 21:32:21  04/17/20 07:32:12  cifs/server1.ad1.example.com@AD1.EXAMPLE.COM
```

### Desktop Ubuntu Authentication

The desktop login only shows local users in the list to pick from, and that’s on purpose.

To login with an Active Directory user for the first time, follow these steps:

- click on the “Not listed?” option:



[![click-not-listed](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/2/291d9ae9e6db85986154208a843963a6bd4eb350_2_345x258.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/2/291d9ae9e6db85986154208a843963a6bd4eb350.png)



- type in the login name followed by the password:



[![type-in-username](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/6/6940e589fd250228137dce0ac847583b52217583_2_345x258.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/6/6940e589fd250228137dce0ac847583b52217583.png)



- the next time you login, the AD user will be listed as if it was a local user:



[![next-time](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/optimized/2X/9/9c1744413a7e6fad58fc38f3dfbe21ea2d1541e2_2_345x258.png)](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/9/9c1744413a7e6fad58fc38f3dfbe21ea2d1541e2.png)



### Resources

- [GitHub SSSD Project](https://github.com/SSSD/sssd)
- [Active Directory DNS Zone Entries](https://technet.microsoft.com/en-us/library/cc759550(v=ws.10).aspx)

## SSSD and LDAP

SSSD can also use LDAP for authentication, authorization, and  user/group information. In this section we will configure a host to  authenticate users from an OpenLDAP directory.

### Prerequisites, Assumptions, and Requirements

For this setup, we need:

- an existing OpenLDAP server with SSL enabled and using the RFC2307 schema for users and groups
- a client host where we will install the necessary tools and login as an user from the LDAP server

### Software Installation

Install the following packages:

```
sudo apt install sssd-ldap ldap-utils
```

### SSSD Configuration

Create the `/etc/sssd/sssd.conf` configuration file, with permissions *0600* and ownership *root:root*, and this content:

```
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://ldap01.example.com
cache_credentials = True
ldap_search_base = dc=example,dc=com
```

Make sure to start the *sssd* service:

```
sudo systemctl start sssd.service
```

> **Note**
>
> *sssd* will use *START_TLS* by default for authentication requests against the LDAP server (the *auth_provider*), but not for the *id_provider*. If you want to also enable *START_TLS* for the *id_provider*, specify `ldap_id_use_start_tls = true`.

### Automatic home directory creation

To enable automatic home directory creation, run the following command:

```
sudo pam-auth-update --enable mkhomedir
```

### Check SSL setup on the client

The client must be able to use *START_TLS* when connecting to the LDAP server, with full certificate checking. This means:

- the client host knows and trusts the CA that signed the LDAP server certificate
- the server certificate was issued for the correct host (`ldap01.example.com` in this guide)
- the time is correct on all hosts performing the TLS connection
- and, of course, that neither certificate (CA or server’s) expired

If using a custom CA, an easy way to have a host trust it is to place it in `/usr/local/share/ca-certificates/` with a `.crt` extension and run `sudo update-ca-certificates`.

Alternatively, you can edit `/etc/ldap/ldap.conf` and point `TLS_CACERT` to the CA public key file.

> **Note**
>
> You may have to restart `sssd` after these changes: `sudo systemctl restart sssd`

Once that is all done, check that you can connect to the LDAP server using verified SSL connections:

```
$ ldapwhoami -x -ZZ -h ldap01.example.com
anonymous
```

The `-ZZ` parameter tells the tool to use *START_TLS*, and that it must not fail. If you have LDAP logging enabled on the server, it will show something like this:

```
slapd[779]: conn=1032 op=0 STARTTLS
slapd[779]: conn=1032 op=0 RESULT oid= err=0 text=
slapd[779]: conn=1032 fd=15 TLS established tls_ssf=256 ssf=256
slapd[779]: conn=1032 op=1 BIND dn="" method=128
slapd[779]: conn=1032 op=1 RESULT tag=97 err=0 text=
slapd[779]: conn=1032 op=2 EXT oid=1.3.6.1.4.1.4203.1.11.3
slapd[779]: conn=1032 op=2 WHOAMI
slapd[779]: conn=1032 op=2 RESULT oid= err=0 text=
```

*START_TLS* with *err=0* and *TLS established* is what we want to see there, and, of course, the *WHOAMI* extended operation.

### Final verification

In this example, the LDAP server has the following user and group entry we are going to use for testing:

```
dn: uid=john,ou=People,dc=example,dc=com
uid: john
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Smith
sn: Smith
givenName: John
mail: john@example.com
userPassword: johnsecret
uidNumber: 10001
gidNumber: 10001
loginShell: /bin/bash
homeDirectory: /home/john

dn: cn=john,ou=Group,dc=example,dc=com
cn: john
objectClass: posixGroup
gidNumber: 10001
memberUid: john

dn: cn=Engineering,ou=Group,dc=example,dc=com
cn: Engineering
objectClass: posixGroup
gidNumber: 10100
memberUid: john
```

The user *john* should be known to the system:

```
ubuntu@ldap-client:~$ getent passwd john
john:*:10001:10001:John Smith:/home/john:/bin/bash

ubuntu@ldap-client:~$ id john
uid=10001(john) gid=10001(john) groups=10001(john),10100(Engineering)
```

And we should be able to authenticate as *john*:

```
ubuntu@ldap-client:~$ sudo login
ldap-client login: john
Password:
Welcome to Ubuntu Focal Fossa (development branch) (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Creating directory '/home/john'.
john@ldap-client:~$
```

## SSSD, LDAP and Kerberos

Finally, we can mix it all together in a setup that is very similar  to Active Directory in terms of the technologies used: use LDAP for  users and groups, and Kerberos for authentication.

### Prerequisites, Assumptions, and Requirements

For this setup, we will need:

- an existing OpenLDAP server using the RFC2307 schema for users and  groups. SSL support is recommended, but not strictly necessary because  authentication in this setup is being done via Kerberos, and not LDAP.
- a Kerberos server. It doesn’t have to be using the OpenLDAP backend
- a client host where we will install and configure SSSD

### Software Installation

On the client host, install the following packages:

```
sudo apt install sssd-ldap sssd-krb5 ldap-utils krb5-user
```

You may be asked about the default Kerberos realm. For this guide, we are using `EXAMPLE.COM`.

At this point, you should alreaedy be able to obtain tickets from  your Kerberos server, assuming DNS records point at it like explained  elsewhere in this guide:

```
$ kinit ubuntu
Password for ubuntu@EXAMPLE.COM:

ubuntu@ldap-krb-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_1000
Default principal: ubuntu@EXAMPLE.COM

Valid starting     Expires            Service principal
04/17/20 19:51:06  04/18/20 05:51:06  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 04/18/20 19:51:05
```

But we want to be able to login as an LDAP user, authenticated via Kerberos. Let’s continue with the configuration.

### SSSD Configuration

Create the `/etc/sssd/sssd.conf` configuration file, with permissions *0600* and ownership *root:root*, and this content:

```
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
ldap_uri = ldap://ldap01.example.com
ldap_search_base = dc=example,dc=com
auth_provider = krb5
krb5_server = kdc01.example.com,kdc02.example.com
krb5_kpasswd = kdc01.example.com
krb5_realm = EXAMPLE.COM
cache_credentials = True
```

This example uses two KDCs, which made it necessary to also specify the *krb5_kpasswd* server because the second KDC is a replica and is not running the admin server.

Start the *sssd* service:

```
sudo systemctl start sssd.service
```

### Automatic home directory creation

To enable automatic home directory creation, run the following command:

```
sudo pam-auth-update --enable mkhomedir
```

### Final verification

In this example, the LDAP server has the following user and group entry we are going to use for testing:

```
dn: uid=john,ou=People,dc=example,dc=com
uid: john
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Smith
sn: Smith
givenName: John
mail: john@example.com
uidNumber: 10001
gidNumber: 10001
loginShell: /bin/bash
homeDirectory: /home/john

dn: cn=john,ou=Group,dc=example,dc=com
cn: john
objectClass: posixGroup
gidNumber: 10001
memberUid: john

dn: cn=Engineering,ou=Group,dc=example,dc=com
cn: Engineering
objectClass: posixGroup
gidNumber: 10100
memberUid: john
```

Note how the *john* user has no *userPassword* attribute.

The user *john* should be known to the system:

```
ubuntu@ldap-client:~$ getent passwd john
john:*:10001:10001:John Smith:/home/john:/bin/bash

ubuntu@ldap-client:~$ id john
uid=10001(john) gid=10001(john) groups=10001(john),10100(Engineering)
```

Let’s try a login as this user:

```
ubuntu@ldap-krb-client:~$ sudo login
ldap-krb-client login: john
Password: 
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-24-generic x86_64)
(...)
Creating directory '/home/john'.

john@ldap-krb-client:~$ klist
Ticket cache: FILE:/tmp/krb5cc_10001_BOrxWr
Default principal: john@EXAMPLE.COM

Valid starting     Expires            Service principal
04/17/20 20:29:50  04/18/20 06:29:50  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 04/18/20 20:29:50
john@ldap-krb-client:~$
```

We logged in using the kerberos password, and user/group information from the LDAP server.

## SSSD and KDC spoofing

When using SSSD to manage kerberos logins on a Linux host, there is an attack scenario you should be aware of: KDC spoofing.

The objective of the attacker is to login on a workstation that is using Kerberos authentication. Let’s say he knows `john` is a valid user on that machine.

The attacker first deploys a rogue KDC server in the network, and creates the `john` principal there with a password of his choosing. What he has to do now  is to have his rogue KDC respond to the login request from the  workstation, before (or instead of) the real KDC. If the workstation  isn’t authenticating the KDC, it will accept the reply from the rogue  server and let `john` in.

There is a configuration parameter that can be set to protect the  workstation from this attack. It will have SSSD authenticate the KDC,  and block the login if the KDC cannot be verified. This option is called `krb5_validate`, and it’s `false` by default.

To enable it, edit `/etc/sssd/sssd.conf` and add this line to the domain section:

```
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
...
krb5_validate = True
```

The second step is to create a `host` principal on the KDC for this workstation. This is how the KDC’s authenticity is verified.  It’s like a “machine account”, with a shared secret that the attacker  cannot control and replicate in his rogue KDC…The `host` principal has the format `host/<fqdn>@REALM`.

After the host principal is created, its keytab needs to be stored on the workstation. This two step process can be easily done on the  workstation itself via `kadmin` (not `kadmin.local`) to contact the KDC remotely:

```
$ sudo kadmin -p ubuntu/admin
kadmin:  addprinc -randkey host/ldap-krb-client.example.com@EXAMPLE.COM
WARNING: no policy specified for host/ldap-krb-client.example.com@EXAMPLE.COM; defaulting to no policy
Principal "host/ldap-krb-client.example.com@EXAMPLE.COM" created.

kadmin:  ktadd -k /etc/krb5.keytab host/ldap-krb-client.example.com
Entry for principal host/ldap-krb-client.example.com with kvno 6, encryption type aes256-cts-hmac-sha1-96 added to keytab WRFILE:/etc/krb5.keytab.
Entry for principal host/ldap-krb-client.example.com with kvno 6, encryption type aes128-cts-hmac-sha1-96 added to keytab WRFILE:/etc/krb5.keytab.
```

Then exit the tool and make sure the permissions on the keytab file are tight:

```
sudo chmod 0600 /etc/krb5.keytab
sudo chown root:root /etc/krb5.keytab
```

You can also do it on the KDC itself using `kadmin.local`, but you will have to store the keytab temporarily in another file and securely copy it over to the workstation.

Once these steps are complete, you can restart sssd on the  workstation and perform the login. If the rogue KDC picks the attempt up and replies, it will fail the host verification. With debugging we can  see that happening on the workstation:

```
==> /var/log/sssd/krb5_child.log <==
(Mon Apr 20 19:43:58 2020) [[sssd[krb5_child[2102]]]] [validate_tgt] (0x0020): TGT failed verification using key for [host/ldap-krb-client.example.com@EXAMPLE.COM].
(Mon Apr 20 19:43:58 2020) [[sssd[krb5_child[2102]]]] [get_and_save_tgt] (0x0020): 1741: [-1765328377][Server host/ldap-krb-client.example.com@EXAMPLE.COM not found in Kerberos database]
```

And the login is denied. If the real KDC picks it up, however, the host verification succeeds:

```
==> /var/log/sssd/krb5_child.log <==
(Mon Apr 20 19:46:22 2020) [[sssd[krb5_child[2268]]]] [validate_tgt] (0x0400): TGT verified using key for [host/ldap-krb-client.example.com@EXAMPLE.COM].
```

And the login is accepted.

## Debugging and troubleshooting

Here are some tips to help troubleshoot sssd.

### `debug_level`

The debug level of sssd can be changed on-the-fly via `sssctl`, from the `sssd-tools` package:

```
sudo apt install sssd-tools
sssctl debug-level <new-level>
```

Or change add it to the config file and restart sssd:

```
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
debug_level = 6
...
```

Either will yield more logs in `/var/log/sssd/*.log` and can help identify what is going on. The `sssctl` approach has the clear advantage of not having to restart the service.

### Caching

Caching is useful to speed things up, but it can get in the way big  time when troubleshooting. It’s useful to be able to remove the cache  while chasing down a problem. This can also be done with the `sssctl` tool from the `sssd-tools` package.

You can either remove the whole cache:

```
# sssctl cache-remove
Creating backup of local data...
SSSD backup of local data already exists, override? (yes/no) [no] yes
Removing cache files...
SSSD= needs to be running. Start SSSD now? (yes/no) [yes] yes
```

Or just one element:

```
sssctl cache-expire -u john
```

Or expire everything:

```
sssctl cache-expire -E
```

# Web Servers

The primary function of a web server is to store, process and deliver Web pages to clients. The clients communicate with the server sending  HTTP requests. Clients, mostly via Web Browsers, request for a specific  resources and the server responds with the content of that resource or  an error message. The response is usually a Web page such as HTML  documents which may include images, style sheets, scripts, and the  content in form of text.

When accessing a Web Server, every HTTP request that is received is  responded to with a content and a HTTP status code. HTTP status codes  are three-digit codes, and are grouped into five different classes. The  class of a status code can be quickly identified by its first digit:

- **1xx** :  *Informational* - Request received, continuing process
- **2xx** :  *Success* - The action was successfully received, understood, and accepted
- **3xx** :  *Redirection* - Further action must be taken in order to complete the request
- **4xx** :  *Client Error* - The request contains bad syntax or cannot be fulfilled
- **5xx** :  *Server Error* - The server failed to fulfill an apparently valid request

More information about status code check the [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html#sec6.1.1).

### Implementation

Web Servers are heavily used in the deployment of Web sites and in this scenario we can use two different implementations:

- **Static Web Server**: The content of the server’s response will be the hosted files “as-is”.
- **Dynamic  Web Server**:  Consist in a Web Server plus an extra software, usually an *application server* and a *database*. For example, to produce the Web pages you see in the Web browser, the  application server might fill an HTML template with contents from a  database. Due to that we say that the content of the server’s response  is generated dynamically.

​						Last updated 1 year, 5 months ago. [Help improve this doc](https://discourse.ubuntu.com/t/web-servers-introduction/11509)

# HTTPD - Apache2 Web Server

Apache is the most commonly used Web server on Linux systems. Web  servers are used to serve Web pages requested by client computers.  Clients typically request and view Web pages using Web browser  applications such as Firefox, Opera, Chromium, or Internet Explorer.

Users enter a Uniform Resource Locator (URL) to point to a Web server by means of its Fully Qualified Domain Name (FQDN) and a path to the  required resource. For example, to view the home page of the [Ubuntu Web site](https://www.ubuntu.com) a user will enter only the FQDN:

```
www.ubuntu.com
```

To view the [community](https://www.ubuntu.com/community) sub-page, a user will enter the FQDN followed by a path:

```
www.ubuntu.com/community
```

The most common protocol used to transfer Web pages is the Hyper Text Transfer Protocol (HTTP). Protocols such as Hyper Text Transfer  Protocol over Secure Sockets Layer (HTTPS), and File Transfer Protocol  (FTP), a protocol for uploading and downloading files, are also  supported.

Apache Web Servers are often used in combination with the MySQL  database engine, the HyperText Preprocessor (PHP) scripting language,  and other popular scripting languages such as Python and Perl. This  configuration is termed LAMP (Linux, Apache, MySQL and Perl/Python/PHP)  and forms a powerful and robust platform for the development and  deployment of Web-based applications.

## Installation

The Apache2 web server is available in Ubuntu Linux. To install Apache2:

At a terminal prompt enter the following command:

```
sudo apt install apache2
```

## Configuration

Apache2 is configured by placing *directives* in plain text configuration files. These *directives* are separated between the following files and directories:

- *apache2.conf:* the main Apache2 configuration file. Contains settings that are *global* to Apache2.
- *httpd.conf:* historically the main Apache2 configuration  file, named after the httpd daemon. In other distributions (or older  versions of Ubuntu), the file might be present. In Ubuntu, all  configuration options have been moved to *apache2.conf* and the below referenced directories, and this file no longer exists.
- *conf-available:* this directory contains available configuration files. All files that were previously in `/etc/apache2/conf.d` should be moved to `/etc/apache2/conf-available`.
- *conf-enabled:* holds *symlinks* to the files in `/etc/apache2/conf-available`. When a configuration file is symlinked, it will be enabled the next time apache2 is restarted.
- *envvars:* file where Apache2 *environment* variables are set.
- *mods-available:* this directory contains configuration files to both load *modules* and configure them. Not all modules will have specific configuration files, however.
- *mods-enabled:* holds *symlinks* to the files in `/etc/apache2/mods-available`. When a module configuration file is symlinked it will be enabled the next time apache2 is restarted.
- *ports.conf:* houses the directives that determine which TCP ports Apache2 is listening on.
- *sites-available:* this directory has configuration files for Apache2 *Virtual Hosts*. Virtual Hosts allow Apache2 to be configured for multiple sites that have separate configurations.
- *sites-enabled:* like mods-enabled, `sites-enabled` contains symlinks to the `/etc/apache2/sites-available` directory. Similarly when a configuration file in sites-available is  symlinked, the site configured by it will be active once Apache2 is  restarted.
- *magic:* instructions for determining MIME type based on the first few bytes of a file.

In addition, other configuration files may be added using the *Include* directive, and wildcards can be used to include many configuration  files. Any directive may be placed in any of these configuration files.  Changes to the main configuration files are only recognized by Apache2  when it is started or restarted.

The server also reads a file containing mime document types; the filename is set by the *TypesConfig* directive, typically via `/etc/apache2/mods-available/mime.conf`, which might also include additions and overrides, and is `/etc/mime.types` by default.

### Basic Settings

This section explains Apache2 server essential configuration parameters. Refer to the [Apache2 Documentation](http://httpd.apache.org/docs/2.4/) for more details.

- Apache2 ships with a virtual-host-friendly default configuration.  That is, it is configured with a single default virtual host (using the *VirtualHost* directive) which can be modified or used as-is if you have a single  site, or used as a template for additional virtual hosts if you have  multiple sites. If left alone, the default virtual host will serve as  your default site, or the site users will see if the URL they enter does not match the *ServerName* directive of any of your custom sites. To modify the default virtual host, edit the file `/etc/apache2/sites-available/000-default.conf`.

  > **Note**
  >
  > The directives set for a virtual host only apply to that particular  virtual host. If a directive is set server-wide and not defined within  the virtual host settings, the default setting is used. For example, you can define a Webmaster email address and not define individual email  addresses for each virtual host.

  If you wish to configure a new virtual host or site, copy that file into the same directory with a name you choose. For example:

  ```
  sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/mynewsite.conf
  ```

  Edit the new file to configure the new site using some of the directives described below.

- The *ServerAdmin* directive specifies the email address to be  advertised for the server’s administrator. The default value is  webmaster@localhost. This should be changed to an email address that is  delivered to you (if you are the server’s administrator). If your  website has a problem, Apache2 will display an error message containing  this email address to report the problem to. Find this directive in your site’s configuration file in /etc/apache2/sites-available.

- The *Listen* directive specifies the port, and optionally the  IP address, Apache2 should listen on. If the IP address is not  specified, Apache2 will listen on all IP addresses assigned to the  machine it runs on. The default value for the Listen directive is 80.  Change this to 127.0.0.1:80 to cause Apache2 to listen only on your  loopback interface so that it will not be available to the Internet, to  (for example) 81 to change the port that it listens on, or leave it as  is for normal operation. This directive can be found and changed in its  own file, `/etc/apache2/ports.conf`

- The *ServerName* directive is optional and specifies what FQDN your site should answer to. The default virtual host has no ServerName  directive specified, so it will respond to all requests that do not  match a ServerName directive in another virtual host. If you have just  acquired the domain name `mynewsite.com` and wish to host it  on your Ubuntu server, the value of the ServerName directive in your  virtual host configuration file should be `mynewsite.com`. Add this directive to the new virtual host file you created earlier (`/etc/apache2/sites-available/mynewsite.conf`).

  You may also want your site to respond to `www.mynewsite.com`, since many users will assume the www prefix is appropriate. Use the *ServerAlias* directive for this. You may also use wildcards in the ServerAlias directive.

  For example, the following configuration will cause your site to respond to any domain request ending in *.mynewsite.com*.

  ```
  ServerAlias *.mynewsite.com
  ```

- The *DocumentRoot* directive specifies where Apache2 should  look for the files that make up the site. The default value is  /var/www/html, as specified in `/etc/apache2/sites-available/000-default.conf`. If desired, change this value in your site’s virtual host file, and remember to create that directory if necessary!

Enable the new *VirtualHost* using the a2ensite utility and restart Apache2:

```
sudo a2ensite mynewsite
sudo systemctl restart apache2.service
```

> **Note**
>
> Be sure to replace *mynewsite* with a more descriptive name for the VirtualHost. One method is to name the file after the *ServerName* directive of the VirtualHost.

Similarly, use the a2dissite utility to disable sites. This is can be useful when troubleshooting configuration problems with multiple  VirtualHosts:

```
sudo a2dissite mynewsite
sudo systemctl restart apache2.service
```

### Default Settings

This section explains configuration of the Apache2 server default  settings. For example, if you add a virtual host, the settings you  configure for the virtual host take precedence for that virtual host.  For a directive not defined within the virtual host settings, the  default value is used.

- The *DirectoryIndex* is the default page served by the server  when a user requests an index of a directory by specifying a forward  slash (/) at the end of the directory name.

  For example, when a user requests the page `http://www.example.com/this_directory/`, he or she will get either the DirectoryIndex page if it exists, a  server-generated directory list if it does not and the Indexes option is specified, or a Permission Denied page if neither is true. The server  will try to find one of the files listed in the DirectoryIndex directive and will return the first one it finds. If it does not find any of  these files and if *Options Indexes* is set for that directory,  the server will generate and return a list, in HTML format, of the  subdirectories and files in the directory. The default value, found in `/etc/apache2/mods-available/dir.conf` is “index.html index.cgi index.pl index.php index.xhtml index.htm”.  Thus, if Apache2 finds a file in a requested directory matching any of  these names, the first will be displayed.

- The *ErrorDocument* directive allows you to specify a file for Apache2 to use for specific error events. For example, if a user  requests a resource that does not exist, a 404 error will occur. By  default, Apache2 will simply return a HTTP 404 Return code. Read `/etc/apache2/conf-available/localized-error-pages.conf` for detailed instructions for using ErrorDocument, including locations of example files.

- By default, the server writes the transfer log to the file `/var/log/apache2/access.log`. You can change this on a per-site basis in your virtual host configuration files with the *CustomLog* directive, or omit it to accept the default, specified in `           /etc/apache2/conf-available/other-vhosts-access-log.conf`. You may also specify the file to which errors are logged, via the *ErrorLog* directive, whose default is `/var/log/apache2/error.log`. These are kept separate from the transfer logs to aid in  troubleshooting problems with your Apache2 server. You may also specify  the *LogLevel* (the default value is “warn”) and the *LogFormat* (see `           /etc/apache2/apache2.conf` for the default value).

- Some options are specified on a per-directory basis rather than per-server. *Options* is one of these directives. A Directory stanza is enclosed in XML-like tags, like so:

  ```
  <Directory /var/www/html/mynewsite>
  ...
  </Directory>
  ```

  The *Options* directive within a Directory stanza accepts one or more of the following values (among others), separated by spaces:

  - **ExecCGI** - Allow execution of CGI scripts. CGI scripts are not executed if this option is not chosen.

    > **Caution**
    >
    > Most files should not be executed as CGI scripts. This would be very  dangerous. CGI scripts should kept in a directory separate from and  outside your DocumentRoot, and only this directory should have the  ExecCGI option set. This is the default, and the default location for  CGI scripts is `/usr/lib/cgi-bin`.

  - **Includes** - Allow server-side includes. Server-side includes allow an HTML file to *include* other files. See [Apache SSI documentation (Ubuntu community)](https://help.ubuntu.com/community/ServerSideIncludes) for more information.

  - **IncludesNOEXEC** - Allow server-side includes, but disable the *[#exec](https://discourse.ubuntu.com/tag/exec)* and *#include* commands in CGI scripts.

  - **Indexes** - Display a formatted list of the directory’s contents, if no *DirectoryIndex* (such as index.html) exists in the requested directory.

    > **Caution**
    >
    > For security reasons, this should usually not be set, and certainly  should not be set on your DocumentRoot directory. Enable this option  carefully on a per-directory basis only if you are certain you want  users to see the entire contents of the directory.

  - **Multiview** - Support content-negotiated multiviews; this option is disabled by default for security reasons. See the [Apache2 documentation on this option](https://httpd.apache.org/docs/2.4/mod/mod_negotiation.html#multiviews).

  - **SymLinksIfOwnerMatch** - Only follow symbolic links if the target file or directory has the same owner as the link.

### apache2 Settings

This section explains some basic apache2 daemon configuration settings.

**LockFile** - The LockFile directive sets the path to  the lockfile used when the server is compiled with either  USE_FCNTL_SERIALIZED_ACCEPT or USE_FLOCK_SERIALIZED_ACCEPT. It must be  stored on the local disk. It should be left to the default value unless  the logs directory is located on an NFS share. If this is the case, the  default value should be changed to a location on the local disk and to a directory that is readable only by root.

**PidFile** - The PidFile directive sets the file in  which the server records its process ID (pid). This file should only be  readable by root. In most cases, it should be left to the default value.

**User** - The User directive sets the userid used by  the server to answer requests. This setting determines the server’s  access. Any files inaccessible to this user will also be inaccessible to your website’s visitors. The default value for User is “www-data”.

> **Warning**
>
> Unless you know exactly what you are doing, do not set the User  directive to root. Using root as the User will create large security  holes for your Web server.

**Group** - The Group directive is similar to the User  directive. Group sets the group under which the server will answer  requests. The default group is also “www-data”.

### Apache2 Modules

Apache2 is a modular server. This implies that only the most basic  functionality is included in the core server. Extended features are  available through modules which can be loaded into Apache2. By default, a base set of modules is included in the server at compile-time. If the  server is compiled to use dynamically loaded modules, then modules can  be compiled separately, and added at any time using the LoadModule  directive. Otherwise, Apache2 must be recompiled to add or remove  modules.

Ubuntu compiles Apache2 to allow the dynamic loading of modules.  Configuration directives may be conditionally included on the presence  of a particular module by enclosing them in an *<IfModule>* block.

You can install additional Apache2 modules and use them with your Web server. For example, run the following command at a terminal prompt to  install the Python 3 WSGI module:

```
sudo apt install libapache2-mod-wsgi-py3
```

The installation will enable the module automatically, but we can disable it with `a2dismod`:

```
sudo a2dismod wsgi
sudo systemctl restart apache2.service
```

And then use the `a2enmod` utility to re-enable it:

```
sudo a2enmod wsgi
sudo systemctl restart apache2.service
```

See the `/etc/apache2/mods-available` directory for additional modules already available on your system.

## HTTPS Configuration

The `mod_ssl` module adds an important feature to the  Apache2 server - the ability to encrypt communications. Thus, when your  browser is communicating using SSL, the `https://` prefix is used at the beginning of the Uniform Resource Locator (URL) in the browser navigation bar.

The `mod_ssl` module is available in apache2-common package. Execute the following command at a terminal prompt to enable the `mod_ssl` module:

```
sudo a2enmod ssl
```

There is a default HTTPS configuration file in `/etc/apache2/sites-available/default-ssl.conf`. In order for Apache2 to provide HTTPS, a *certificate* and *key* file are also needed. The default HTTPS configuration will use a certificate and key generated by the `ssl-cert` package. They are good for testing, but the auto-generated certificate  and key should be replaced by a certificate specific to the site or  server. For information on generating a key and obtaining a certificate  see [Certificates](https://ubuntu.com/server/docs/security-certificates).

To configure Apache2 for HTTPS, enter the following:

```
sudo a2ensite default-ssl
```

> **Note**
>
> The directories `/etc/ssl/certs` and `/etc/ssl/private` are the default locations. If you install the certificate and key in another directory make sure to change *SSLCertificateFile* and *SSLCertificateKeyFile* appropriately.

With Apache2 now configured for HTTPS, restart the service to enable the new settings:

```
sudo systemctl restart apache2.service
```

> **Note**
>
> Depending on how you obtained your certificate you may need to enter a passphrase when Apache2 starts.

You can access the secure server pages by typing `https://your_hostname/url/` in your browser address bar.

## Sharing Write Permission

For more than one user to be able to write to the same directory it  will be necessary to grant write permission to a group they share in  common. The following example grants shared write permission to `/var/www/html` to the group “webmasters”.

```
sudo chgrp -R webmasters /var/www/html
sudo chmod -R g=rwX /var/www/html/
```

These commands recursively set the group permission on all files and directories in `/var/www/html` to allow reading, writing and searching of directories. Many admins  find this useful for allowing multiple users to edit files in a  directory tree.

> **Warning**
>
> The `apache2` daemon will run as the `www-data` user, which has a corresponding `www-data` group. These *should not* be granted write access to the document root, as this would mean that  vulnerabilities in Apache or the applications it is serving would allow  attackers to overwrite the served content.

## References

- [Apache2 Documentation](https://httpd.apache.org/docs/2.4/) contains in depth information on Apache2 configuration directives.  Also, see the apache2-doc package for the official Apache2 docs.
- O’Reilly’s [Apache Cookbook](http://shop.oreilly.com/product/9780596529949.do) is a good resource for accomplishing specific Apache2 configurations.
- For Ubuntu specific Apache2 questions, ask in the *#ubuntu-server* IRC channel on [freenode.net](http://freenode.net/).

# Introduction to High Availability

A definition of High Availability Clusters [from Wikipedia:](https://en.wikipedia.org/wiki/High-availability_cluster)

## High Availability Clusters

> **High-availability clusters**  (also known as  **HA clusters**  ,  **fail-over clusters**  or  **Metroclusters Active/Active** ) are groups of [computers](https://en.wikipedia.org/wiki/Computer) that support [server](https://en.wikipedia.org/wiki/Server_(computing)) [applications](https://en.wikipedia.org/wiki/Application_software) that can be reliably utilized with [a minimum amount of down-time](https://en.wikipedia.org/wiki/High_availability).
>
> They operate by using [high availability software](https://en.wikipedia.org/wiki/High_availability_software) to harness [redundant](https://en.wikipedia.org/wiki/Redundancy_(engineering)) computers in groups or [clusters](https://en.wikipedia.org/wiki/Computer_cluster) that provide continued service when system components fail. 
>
> Without clustering, if a server running a particular application  crashes, the application will be unavailable until the crashed server is fixed. HA clustering remedies this situation by detecting  hardware/software faults, and immediately restarting the application on  another system without requiring administrative intervention, a process  known as [failover](https://en.wikipedia.org/wiki/Failover). 
>
> As part of this process, clustering software may configure the node  before starting the application on it. For example, appropriate file  systems may need to be imported and mounted, network hardware may have  to be configured, and some supporting applications may need to be  running as well.
>
> HA clusters are often used for critical [databases](https://en.wikipedia.org/wiki/Database_management_system), file sharing on a network, business applications, and customer services such as [electronic commerce](https://en.wikipedia.org/wiki/Electronic_commerce) [websites](https://en.wikipedia.org/wiki/Websites).

## High Availability Cluster Heartbeat

> HA cluster implementations attempt to build redundancy into a cluster to eliminate single points of failure, including multiple network  connections and data storage which is redundantly connected via [storage area networks](https://en.wikipedia.org/wiki/Storage_area_network).
>
> HA clusters usually use a [heartbeat](https://en.wikipedia.org/wiki/Heartbeat_(computing)) private network connection which is used to monitor the health and  status of each node in the cluster. One subtle but serious condition all clustering software must be able to handle is [split-brain](https://en.wikipedia.org/wiki/Split-brain_(computing)), which occurs when all of the private links go down simultaneously, but the cluster nodes are still running. 
>
> If that happens, each node in the cluster may mistakenly decide that  every other node has gone down and attempt to start services that other  nodes are still running. Having duplicate instances of services may  cause data corruption on the shared storage.

## High Availability Cluster Quorum

> HA clusters often also use [quorum](https://en.wikipedia.org/wiki/Quorum_(distributed_computing)) witness storage (local or cloud) to avoid this scenario. A witness  device cannot be shared between two halves of a split cluster, so in the event that all cluster members cannot communicate with each other  (e.g., failed heartbeat), if a member cannot access the witness, it  cannot become active.

## Example



![2nodeHAcluster](https://ubuntucommunity.s3.dualstack.us-east-2.amazonaws.com/original/2X/1/148964016f20d651dd7da7a3d58b024b2e3e9569.png)

## Fencing

Fencing protects your data from being corrupted, and your application from becoming unavailable, due to unintended concurrent access by rogue nodes.

Just because a node is unresponsive doesn’t mean it has stopped  accessing your data. The only way to be 100% sure that your data is  safe, is to use fencing to ensure that the node is truly offline before  allowing the data to be accessed from another node.

Fencing also has a role to play in the event that a clustered service cannot be stopped. In this case, the cluster uses fencing to force the  whole node offline, thereby making it safe to start the service
 elsewhere.

Fencing is also known as STONITH, an acronym for “Shoot The Other  Node In The Head”, since the most popular form of fencing is cutting a  host’s power.

Key Benefits:

- Active countermeasure taken by a functioning host to isolate a misbehaving (usually dead) host from shared data.
- **MOST CRITICAL** part of a cluster utilizing SAN or other shared storage technology (*Ubuntu HA Clusters can only be supported if the fencing mechanism is configured*).
- Required by OCFS2, GFS2, cLVMd (before Ubuntu 20.04), lvmlockd (from 20.04 and beyond).

# Linux High Availability Projects

There are many upstream high availability related projects that are  included in Ubuntu Linux. This section will describe the most important  ones.

The following packages are present in latest Ubuntu LTS release:

## Ubuntu HA Core Packages

Packages in this list are supported just like any other package available in  **[main] repository**  would be.

| Package         | URL                                                          |
| --------------- | ------------------------------------------------------------ |
| libqb           | [Ubuntu](https://launchpad.net/ubuntu/+source/libqb) \| [Upstream](http://clusterlabs.github.io/libqb/) |
| kronosnet       | [Ubuntu](https://launchpad.net/ubuntu/+source/kronosnet) \| [Upstream](https://kronosnet.org/) |
| corosync        | [Ubuntu](https://launchpad.net/ubuntu/+source/corosync) \| [Upstream](http://corosync.github.io/corosync/) |
| pacemaker       | [Ubuntu](https://launchpad.net/ubuntu/+source/pacemaker) \| [Upstream](https://www.clusterlabs.org/pacemaker/) |
| resource-agents | [Ubuntu](https://launchpad.net/ubuntu/+source/resource-agents) \| [Upstream](https://github.com/ClusterLabs/resource-agents) |
| fence-agents    | [Ubuntu](https://launchpad.net/ubuntu/+source/fence-agents) \| [Upstream](https://github.com/ClusterLabs/fence-agents) |
| crmsh           | [Ubuntu](https://launchpad.net/ubuntu/+source/crmsh) \| [Upstream](https://github.com/ClusterLabs/crmsh) |
| cluster-glue    | [Ubuntu](https://launchpad.net/ubuntu/+source/cluster-glue) \| [Upstream](https://github.com/ClusterLabs/cluster-glue) |
| drbd-utils      | [Ubuntu](https://launchpad.net/ubuntu/+source/drbd-utils) \| [Upstream](https://www.linbit.com/drbd/) |
| dlm             | [Ubuntu](https://launchpad.net/ubuntu/+source/dlm) \| [Upstream](https://pagure.io/dlm) |
| gfs2-utils      | [Ubuntu](https://launchpad.net/ubuntu/+source/gfs2-utils) \| [Upstream](https://pagure.io/gfs2-utils) |
| keepalived      | [Ubuntu](https://launchpad.net/ubuntu/+source/keepalived) \| [Upstream](https://www.keepalived.org/) |

- **Kronosnet** - Kronosnet, often referred to as knet, is a network abstraction layer designed for High Availability. Corosync  uses Kronosnet to provide multiple networks for its interconnect  (replacing the old [Totem Redundant Ring Protocol](https://discourse.ubuntu.com/t/corosync-and-redundant-rings/11627)) and add support for some more features like interconnect network hot-plug.
- **Corosync** - or *Cluster Membership Layer*,  provides reliable messaging, membership and quorum information about the cluster. Currently, Pacemaker supports Corosync as this layer.
- **Resource Agents** - Scripts or operating system  components that start, stop or monitor resources, given a set of  resource parameters. These provide a uniform interface between pacemaker and the managed services.
- **Fence Agents** - Scripts that execute node fencing actions, given a target and fence device parameters.
- **Pacemaker** - or *Cluster Resource Manager*,  provides the brain that processes and reacts to events that occur in the cluster. Events might be: nodes joining or leaving the cluster,  resource events caused by failures, maintenance, or scheduled  activities. To achieve the desired availability, Pacemaker may start and stop resources and fence nodes.
- **DRBD** - Distributed Replicated Block Device, **DRBD**  is a [distributed replicated storage system](https://en.wikipedia.org/wiki/Distributed_Replicated_Block_Device) for the Linuxplatform. It is implemented as a kernel driver, several  userspace management applications, and some shell scripts. DRBD is  traditionally used in high availability (HA) clusters.
- **DLM** - A distributed lock manager (DLM) runs in every machine in a cluster, with an identical copy of a cluster-wide lock  database. In this way   DLM provides software applications which are  distributed across a cluster on multiple machines with a means to  synchronize their accesses to shared resources.
- **Keepalived** - Keepalived provides simple and robust  facilities for loadbalancing and high-availability to Linux system and  Linux based infrastructures. Loadbalancing framework relies on  well-known and widely used [Linux Virtual Server (IPVS)](http://www.linux-vs.org/) kernel module providing Layer4 loadbalancing. Keepalived implements a  set of checkers to dynamically and adaptively maintain and manage  loadbalanced server pool according their health. On the other hand  high-availability is achieved by [VRRP](http://datatracker.ietf.org/wg/vrrp/) protocol.

## Ubuntu HA Community Packages

Packages in this list are supported just like any other package available in  **[universe] repository**  would be.

| Package          | URL                                                          |
| ---------------- | ------------------------------------------------------------ |
| pcs*             | [Ubuntu](https://launchpad.net/ubuntu/+source/libqb) \| [Upstream](https://github.com/ClusterLabs/pcs) |
| csync2           | [Ubuntu](https://launchpad.net/ubuntu/+source/csync2) \| [Upstream](https://github.com/LINBIT/csync2) |
| corosync-qdevice | [Ubuntu](https://launchpad.net/ubuntu/+source/corosync-qdevice) \| [Upstream](https://github.com/corosync/corosync-qdevice) |
| fence-virt       | [Ubuntu](https://launchpad.net/ubuntu/+source/fence-virt) \| [Upstream](https://github.com/ClusterLabs/fence-virt) |
| sbd              | [Ubuntu](https://launchpad.net/ubuntu/+source/sbd) \| [Upstream](https://github.com/ClusterLabs/sbd) |
| booth            | [Ubuntu](https://launchpad.net/ubuntu/+source/booth) \| [Upstream](https://github.com/ClusterLabs/booth) |

- **Corosync-Qdevice** - Its primary use is for even-node  clusters, operates at corosync (quorum) layer. Corosync-Qdevice is an  independent arbiter for solving split-brain situations. (qdevice-net  supports multiple algorithms).
- **SBD** - STONITH Block Device can be particularly  useful in environments where traditional fencing mechanisms are not  possible. SBD integrates with Pacemaker, a watchdog device and shared  storage to arrange for nodes to reliably self-terminate when  fencing is required.

> Note: pcs will likely replace **crmsh** in [main] repository in future Ubuntu versions.

## Ubuntu HA Deprecated Packages

Packages in this list are  **only supported by the upstream community** . All bugs opened against these agents will be forwarded to upstream IF makes sense (affected version is close to upstream).

| Package     | URL                                                          |
| ----------- | ------------------------------------------------------------ |
| ocfs2-tools | [Ubuntu](https://launchpad.net/ubuntu/+source/ocfs2-tools) \| [Upstream](https://github.com/markfasheh/ocfs2-tools.git) |

## Ubuntu HA Related Packages

Packages in this list aren’t necessarily **HA** related  packages, but they have a very important role in High Availability  Clusters and are supported like any other package provide by the **[main]** repository.

| Package              | URL                                                          |
| -------------------- | ------------------------------------------------------------ |
| multipath-tools      | [Ubuntu](https://launchpad.net/ubuntu/+source/multipath-tools) \| [Upstream](https://git.opensvc.com/multipath-tools/.git/) |
| open-iscsi           | [Ubuntu](https://launchpad.net/ubuntu/+source/open-iscsi) \| [Upstream](https://github.com/open-iscsi/open-iscsi) |
| sg3-utils            | [Ubuntu](https://launchpad.net/ubuntu/+source/sg3-utils) \| [Upstream](http://sg.danny.cz/sg/sg3_utils.html) |
| tgt OR targetcli-fb* | [Ubuntu](https://launchpad.net/ubuntu/+source/tgt) \| [Upstream](https://github.com/fujita/tgt) |
| lvm2                 | [Ubuntu](https://launchpad.net/ubuntu/+source/lvm2) \| [Upstream](https://sourceware.org/lvm2/) |

- LVM2

   in a Shared-Storage Cluster Scenario:

  CLVM

   \- supported before 

  Ubuntu 20.04

  A distributed lock manager (DLM) is used to broker concurrent LVM  metadata accesses. Whenever a cluster node needs to modify the LVM  metadata, it must secure permission from its local  

  ```
  clvmd
  ```

   , which is in constant contact with other  

  ```
  clvmd
  ```

    daemons in the cluster and can communicate a desire to get a lock on a particular set of objects.

  [lvmlockd](http://manpages.ubuntu.com/manpages/focal/man8/lvmlockd.8.html)

   \- supported after 

  Ubuntu 20.04

  As of 2017, a stable LVM component that is designed to replace  

  ```
  clvmd
  ```

    by making the locking of LVM objects transparent to the rest of LVM, without relying on a distributed lock manager.

  The lvmlockd benefits over clvm are:

  - lvmlockd supports two cluster locking plugins: DLM and SANLOCK.  SANLOCK plugin can supports up to ~2000 nodes that benefits LVM usage in big virtualization / storage cluster, while DLM plugin fits HA cluster.
  - lvmlockd has better design than clvmd. clvmd is command-line level  based locking system, which means the whole LVM software will get hang  if any LVM command gets dead-locking issue.
  - lvmlockd can work with lvmetad.

> Note: **targetcli-fb (Linux LIO)** will likely replace **tgt** in future Ubuntu versions.

## Upstream Documentation

The server guide does not have the intent to document every existing  option for all the HA related softwares described in this page, but to  document recommended scenarios for Ubuntu HA Clusters. You will find  more complete documentation upstream at:

- ClusterLabs
  - [Clusters From Scratch](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Clusters_from_Scratch/index.html)
  - [Managing Pacemaker Clusters](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Administration/index.html)
  - [Pacemaker Configuration Explained](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Explained/index.html)
  - [Pacemaker Remote - Scaling HA Clusters](https://clusterlabs.org/pacemaker/doc/en-US/Pacemaker/2.0/html-single/Pacemaker_Remote/index.html)
- Other
  - [Ubuntu Bionic HA in Shared Disk Environments (Azure)](https://discourse.ubuntu.com/t/ubuntu-high-availability-corosync-pacemaker-shared-disk-environments/14874)

> A very special thanks, and all the credits, to [ClusterLabs Project](https://clusterlabs.org/) for all that detailed documentation.

# LAMP Applications

# Overview

LAMP installations (Linux + Apache + MySQL + PHP/Perl/Python) are a  popular setup for Ubuntu servers. There is a plethora of Open Source  applications written using the LAMP application stack. Some popular LAMP applications are Wiki’s, Content Management Systems, and Management  Software such as phpMyAdmin.

One advantage of LAMP is the substantial flexibility for different  database, web server, and scripting languages. Popular substitutes for  MySQL include PostgreSQL and SQLite. Python, Perl, and Ruby are also  frequently used instead of PHP. While Nginx, Cherokee and Lighttpd can  replace Apache.

The fastest way to get started is to install LAMP using tasksel.  Tasksel is a Debian/Ubuntu tool that installs multiple related packages  as a co-ordinated “task” onto your system. To install a LAMP server:

At a terminal prompt enter the following command:

```
sudo tasksel install lamp-server
```

After installing it you’ll be able to install most *LAMP* applications in this way:

- Download an archive containing the application source files.
- Unpack the archive, usually in a directory accessible to a web server.
- Depending on where the source was extracted, configure a web server to serve the files.
- Configure the application to connect to the database.
- Run a script, or browse to a page of the application, to install the database needed by the application.
- Once the steps above, or similar steps, are completed you are ready to begin using the application.

A disadvantage of using this approach is that the application files  are not placed in the file system in a standard way, which can cause  confusion as to where the application is installed. Another larger  disadvantage is updating the application. When a new version is  released, the same process used to install the application is needed to  apply updates.

Fortunately, a number of *LAMP* applications are already  packaged for Ubuntu, and are available for installation in the same way  as non-LAMP applications. Depending on the application some extra  configuration and setup steps may be needed, however.

This section covers how to install some *LAMP* applications.

# phpMyAdmin

phpMyAdmin is a LAMP application specifically written for  administering MySQL servers. Written in PHP, and accessed through a web  browser, phpMyAdmin provides a graphical interface for database  administration tasks.

## Installation

Before installing phpMyAdmin you will need access to a MySQL database either on the same host as that phpMyAdmin is installed on, or on a  host accessible over the network. For more information see [MySQL documentation](https://ubuntu.com/server/docs/databases-mysql). From a terminal prompt enter:

```
sudo apt install phpmyadmin
```

At the prompt choose which web server to be configured for  phpMyAdmin. The rest of this section will use Apache2 for the web  server.

In a browser go to *`http://servername/phpmyadmin`*, replacing *servername* with the server’s actual hostname. At the login, page enter *root* for the *username*, or another MySQL user, if you have any setup, and enter the MySQL user’s password.

Once logged in you can reset the *root* password if needed, create users, create/destroy databases and tables, etc.

## Configuration

The configuration files for phpMyAdmin are located in `/etc/phpmyadmin`. The main configuration file is `/etc/phpmyadmin/config.inc.php`. This file contains configuration options that apply globally to phpMyAdmin.

To use phpMyAdmin to administer a MySQL database hosted on another server, adjust the following in `/etc/phpmyadmin/config.inc.php`:

```
$cfg['Servers'][$i]['host'] = 'db_server';
```

> **Note**
>
> Replace *db_server* with the actual remote database server  name or IP address. Also, be sure that the phpMyAdmin host has  permissions to access the remote database.

Once configured, log out of phpMyAdmin and back in, and you should be accessing the new server.

The `config.header.inc.php` and `config.footer.inc.php` files in `/etc/phpmyadmin` directory are used to add a HTML header and footer to phpMyAdmin.

Another important configuration file is `/etc/phpmyadmin/apache.conf`, this file is symlinked to `/etc/apache2/conf-available/phpmyadmin.conf`, and, once enabled, is used to configure Apache2 to serve the phpMyAdmin site. The file contains directives for loading PHP, directory  permissions, etc. From a terminal type:

```
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf
sudo systemctl reload apache2.service
```

For more information on configuring Apache2 see this [documentation](https://ubuntu.com/server/docs/web-servers-apache).

## References

- The phpMyAdmin documentation comes installed with the package and can be accessed from the *phpMyAdmin Documentation* link (a question mark with a box around it) under the phpMyAdmin logo. The official docs can also be access on the [phpMyAdmin](http://www.phpmyadmin.net/home_page/docs.php) site.
- Another resource is the [phpMyAdmin Ubuntu Wiki](https://help.ubuntu.com/community/phpMyAdmin) page.

# WordPress

Wordpress is a blog tool, publishing platform and CMS implemented in PHP and licensed under the GNU GPLv2.

## Installation

To install WordPress, run the following comand in the command prompt:

```auto
    sudo apt install wordpress
```

You should also install apache2 web server and mysql server. For installing apache2 web server, please refer to [Apache2 documentation](https://ubuntu.com/server/docs/web-servers-apache). For installing mysql server, please refer to [MySQL documentation](https://ubuntu.com/server/docs/databases-mysql).

## Configuration

For configuring your first WordPress application, configure an apache site. Open `/etc/apache2/sites-available/wordpress.conf` and write the following lines:

```auto
        Alias /blog /usr/share/wordpress
        <Directory /usr/share/wordpress>
            Options FollowSymLinks
            AllowOverride Limit Options FileInfo
            DirectoryIndex index.php
            Order allow,deny
            Allow from all
        </Directory>
        <Directory /usr/share/wordpress/wp-content>
            Options FollowSymLinks
            Order allow,deny
            Allow from all
        </Directory>
           
```

Enable this new WordPress site

```auto
    sudo a2ensite wordpress
```

Once you configure the apache2 web server and make it ready for your  WordPress application, you should restart it. You can run the following  command to restart the apache2 web server:

```
sudo systemctl reload apache2.service
```

To facilitate multiple WordPress installations, the name of this  configuration file is based on the Host header of the HTTP request. This means that you can have a configuration per VirtualHost by simply  matching the hostname portion of this configuration with your Apache  Virtual Host. e.g. /etc/wordpress/config-10.211.55.50.php,  /etc/wordpress/config-hostalias1.php, etc. These instructions assume you can access Apache via the localhost hostname (perhaps by using an ssh  tunnel) if not, replace /etc/wordpress/config-localhost.php with  /etc/wordpress/config-NAME_OF_YOUR_VIRTUAL_HOST.php.

Once the configuration file is written, it is up to you to choose a  convention for username and password to mysql for each WordPress  database instance. This documentation shows only one, localhost,  example.

Now configure WordPress to use a mysql database. Open `/etc/wordpress/config-localhost.php` file and write the following lines:

```
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'yourpasswordhere');
define('DB_HOST', 'localhost');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
```

Now create this mysql database. Open a temporary file with mysql commands `wordpress.sql` and write the following lines:

```
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'localhost'
IDENTIFIED BY 'yourpasswordhere';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON wordpress.*
TO wordpress@localhost;
FLUSH PRIVILEGES;
```

Execute these commands.

```
cat wordpress.sql | sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf
```

Your new WordPress can now be configured by visiting http://localhost/blog/wp-admin/install.php. (Or http://NAME_OF_YOUR_VIRTUAL_HOST/blog/wp-admin/install.php if your server has no GUI and you are completing WordPress  configuration via a web browser running on another computer.) Fill out  the Site Title, username, password, and E-mail and click Install  WordPress.

Note the generated password (if applicable) and click the login password. Your WordPress is now ready for use.

## References

- [WordPress.org Codex](https://codex.wordpress.org/)
- [Ubuntu Wiki WordPress](https://help.ubuntu.com/community/WordPress)

# Backups

There are many ways to backup an Ubuntu installation. The most important thing about backups is to develop a *backup plan* consisting of what to backup, where to back it up to, and how to restore it.

It is good practice to take backup media off-site in case of a  disaster. For backup plans involving physical tape or removable hard  drives, the tapes or drives can be manually taken off-site, but in other cases this may not be practical and the archives will need copied over a WAN link to a server in another location.

# Archive Rotation

The shell script in [Shell Scripts](https://ubuntu.com/server/docs/backups-shell-scripts) only allows for seven different archives. For a server whose data  doesn’t change often, this may be enough. If the server has a large  amount of data, a more complex rotation scheme should be used.

## Rotating NFS Archives

In this section, the shell script will be slightly modified to  implement a grandfather-father-son rotation scheme  (monthly-weekly-daily):

- The rotation will do a *daily* backup Sunday through Friday.
- On Saturday a *weekly* backup is done giving you four weekly backups a month.
- The *monthly* backup is done on the first of the month rotating two monthly backups based on if the month is odd or even.

Here is the new script:

```
#!/bin/bash
####################################
#
# Backup to NFS mount script with
# grandfather-father-son rotation.
#
####################################

# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup"

# Setup variables for the archive filename.
day=$(date +%A)
hostname=$(hostname -s)

# Find which week of the month 1-4 it is.
day_num=$(date +%-d)
if (( $day_num <= 7 )); then
        week_file="$hostname-week1.tgz"
elif (( $day_num > 7 && $day_num <= 14 )); then
        week_file="$hostname-week2.tgz"
elif (( $day_num > 14 && $day_num <= 21 )); then
        week_file="$hostname-week3.tgz"
elif (( $day_num > 21 && $day_num < 32 )); then
        week_file="$hostname-week4.tgz"
fi

# Find if the Month is odd or even.
month_num=$(date +%m)
month=$(expr $month_num % 2)
if [ $month -eq 0 ]; then
        month_file="$hostname-month2.tgz"
else
        month_file="$hostname-month1.tgz"
fi

# Create archive filename.
if [ $day_num == 1 ]; then
    archive_file=$month_file
elif [ $day != "Saturday" ]; then
        archive_file="$hostname-$day.tgz"
else 
    archive_file=$week_file
fi

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest/
```

The script can be executed using the same methods as in [Executing the Script](https://ubuntu.com/server/docs/backups-shell-scripts).

As discussed in the introduction, a copy of the backup archives and/or media can then be transferred off-site.

## Tape Drives

A tape drive attached to the server can be used instead of an NFS  share. Using a tape drive simplifies archive rotation, and makes taking  the media off-site easier as well.

When using a tape drive, the filename portions of the script aren’t  needed because the data is sent directly to the tape device. Some  commands to manipulate the tape are needed. This is accomplished using  mt, a magnetic tape control utility part of the cpio package.

Here is the shell script modified to use a tape drive:

```
#!/bin/bash
####################################
#
# Backup to tape drive script.
#
####################################

# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/dev/st0"

# Print start status message.
echo "Backing up $backup_files to $dest"
date
echo

# Make sure the tape is rewound.
mt -f $dest rewind

# Backup the files using tar.
tar czf $dest $backup_files

# Rewind and eject the tape.
mt -f $dest rewoffl

# Print end status message.
echo
echo "Backup finished"
date
```

> **Note**
>
> The default device name for a SCSI tape drive is `/dev/st0`. Use the appropriate device path for your system.

Restoring from a tape drive is basically the same as restoring from a file. Simply rewind the tape and use the device path instead of a file  path. For example to restore the `/etc/hosts` file to `/tmp/etc/hosts`:

```
mt -f /dev/st0 rewind
tar -xzf /dev/st0 -C /tmp etc/hosts
```

# Bacula

Bacula is a backup program enabling you to backup, restore, and  verify data across your network. There are Bacula clients for Linux,  Windows, and Mac OS X - making it a cross-platform network wide  solution.

## Overview

Bacula is made up of several components and services used to manage which files to backup and backup locations:

- Bacula Director: a service that controls all backup, restore, verify, and archive operations.
- Bacula Console: an application allowing communication with the Director. There are three versions of the Console:
  - Text based command line version.
  - Gnome based GTK+ Graphical User Interface (GUI) interface.
  - wxWidgets GUI interface.
- Bacula File: also known as the Bacula Client program. This  application is installed on machines to be backed up, and is responsible for the data requested by the Director.
- Bacula Storage: the programs that perform the storage and recovery of data to the physical media.
- Bacula Catalog: is responsible for maintaining the file indexes and  volume databases for all files backed up, enabling quick location and  restoration of archived files. The Catalog supports three different  databases MySQL, PostgreSQL, and SQLite.
- Bacula Monitor: allows the monitoring of the Director, File daemons,  and Storage daemons. Currently the Monitor is only available as a GTK+  GUI application.

These services and applications can be run on multiple servers and  clients, or they can be installed on one machine if backing up a single  disk or volume.

## Installation

> **Note**
>
> If using MySQL or PostgreSQL as your database, you should already  have the services available. Bacula will not install them for you. For  more information take a look at [Databases -MySQL](https://ubuntu.com/server/docs/databases-mysql) and [Databases - PostgreSQL](https://ubuntu.com/server/docs/databases-postgresql).

There are multiple packages containing the different Bacula components. To install Bacula, from a terminal prompt enter:

```
sudo apt install bacula
```

By default installing the bacula package will use a PostgreSQL  database for the Catalog. If you want to use SQLite or MySQL, for the  Catalog, install `bacula-director-sqlite3` or `bacula-director-mysql` respectively.

During the install process you will be asked to supply a password for the database *owner* of the *bacula* database.

## Configuration

Bacula configuration files are formatted based on *resources* comprising of *directives* surrounded by “{}” braces. Each Bacula component has an individual file in the `/etc/bacula` directory.

The various Bacula components must authorize themselves to each other. This is accomplished using the *password* directive. For example, the *Storage* resource password in the `/etc/bacula/bacula-dir.conf` file must match the *Director* resource password in `/etc/bacula/bacula-sd.conf`.

By default the backup job named *BackupClient1* is configured  to archive the Bacula Catalog. If you plan on using the server to backup more than one client you should change the name of this job to  something more descriptive. To change the name edit `/etc/bacula/bacula-dir.conf`:

```
#
# Define the main nightly save backup job
#   By default, this job will back up to disk in 
Job {
  Name = "BackupServer"
  JobDefs = "DefaultJob"
  Write Bootstrap = "/var/lib/bacula/Client1.bsr"
}
```

> **Note**
>
> The example above changes the job name to *BackupServer* matching the machine’s host name. Replace “BackupServer” with your appropriate hostname, or other descriptive name.

The *Console* can be used to query the *Director* about jobs, but to use the Console with a *non-root* user, the user needs to be in the *bacula* group. To add a user to the bacula group enter the following from a terminal:

```
sudo adduser $username bacula
```

> **Note**
>
> Replace *$username* with the actual username. Also, if you are adding the current user to the group you should log out and back in for the new permissions to take effect.

## Localhost Backup

This section describes how to backup specified directories on a single host to a local tape drive.

- First, the *Storage* device needs to be configured. Edit `/etc/bacula/bacula-sd.conf` add:

  ```
  Device {
    Name = "Tape Drive"
    Device Type = tape
    Media Type = DDS-4
    Archive Device = /dev/st0
    Hardware end of medium = No;
    AutomaticMount = yes;               # when device opened, read it
    AlwaysOpen = Yes;
    RemovableMedia = yes;
    RandomAccess = no;
    Alert Command = "sh -c 'tapeinfo -f %c | grep TapeAlert'"
  }
  ```

  The example is for a *DDS-4* tape drive. Adjust the “Media Type” and “Archive Device” to match your hardware.

  You could also uncomment one of the other examples in the file.

- After editing `/etc/bacula/bacula-sd.conf` the Storage daemon will need to be restarted:

  ```
  sudo systemctl restart bacula-sd.service
  ```

- Now add a *Storage* resource in `/etc/bacula/bacula-dir.conf` to use the new Device:

  ```
  # Definition of "Tape Drive" storage device
  Storage {
    Name = TapeDrive
    # Do not use "localhost" here    
    Address = backupserver               # N.B. Use a fully qualified name here
    SDPort = 9103
    Password = "Cv70F6pf1t6pBopT4vQOnigDrR0v3LT3Cgkiyjc"
    Device = "Tape Drive"
    Media Type = tape
  }
  ```

  The *Address* directive needs to be the Fully Qualified Domain Name (FQDN) of the server. Change *backupserver* to the actual host name.

  Also, make sure the *Password* directive matches the password string in `/etc/bacula/bacula-sd.conf`.

- Create a new *FileSet*, which will determine what directories to backup, by adding:

  ```
  # LocalhostBacup FileSet.
  FileSet {
    Name = "LocalhostFiles"
    Include {
      Options {
        signature = MD5
        compression=GZIP
      }
      File = /etc
      File = /home
    }
  }
  ```

  This *FileSet* will backup the `/etc` and `/home` directories. The *Options* resource directives configure the FileSet to create an MD5 signature  for each file backed up, and to compress the files using GZIP.

- Next, create a new *Schedule* for the backup job:

  ```
  # LocalhostBackup Schedule -- Daily.
  Schedule {
    Name = "LocalhostDaily"
    Run = Full daily at 00:01
  }
  ```

  The job will run every day at 00:01 or 12:01 am. There are many other scheduling options available.

- Finally create the *Job*:

  ```auto
  # Localhost backup.
  Job {
    Name = "LocalhostBackup"
    JobDefs = "DefaultJob"
    Enabled = yes
    Level = Full
    FileSet = "LocalhostFiles"
    Schedule = "LocalhostDaily"
    Storage = TapeDrive
    Write Bootstrap = "/var/lib/bacula/LocalhostBackup.bsr"
  }  
  ```

  The job will do a *Full* backup every day to the tape drive.

- Each tape used will need to have a *Label*. If the current  tape does not have a label Bacula will send an email letting you know.  To label a tape using the Console enter the following from a terminal:

  ```
  bconsole
  ```

- At the Bacula Console prompt enter:

  ```
  label
  ```

- You will then be prompted for the *Storage* resource:

  ```auto
  Automatically selected Catalog: MyCatalog
  Using Catalog "MyCatalog"
  The defined Storage resources are:
       1: File
       2: TapeDrive
  Select Storage resource (1-2):2
  ```

- Enter the new *Volume* name:

  ```auto
  Enter new Volume name: Sunday
  Defined Pools:
       1: Default
       2: Scratch
  ```

  Replace *Sunday* with the desired label.

- Now, select the *Pool*:

  ```auto
  Select the Pool (1-2): 1
  Connecting to Storage daemon TapeDrive at backupserver:9103 ...
  Sending label command for Volume "Sunday" Slot 0 ...
  ```

Congratulations, you have now configured *Bacula* to backup the localhost to an attached tape drive.

## Resources

- For more *Bacula* configuration options, refer to [Bacula’s Documentation](http://blog.bacula.org/documentation/documentation/).
- The [Bacula Home Page](http://www.bacula.org/) contains the latest Bacula news and developments.
- Also, see the [Bacula Ubuntu Wiki](https://help.ubuntu.com/community/Bacula) page.

# Shell Scripts

One of the simplest ways to backup a system is using a *shell script*. For example, a script can be used to configure which directories to  backup, and pass those directories as arguments to the tar utility,  which creates an archive file. The archive file can then be moved or  copied to another location. The archive can also be created on a remote  file system such as an *NFS* mount.

The tar utility creates one archive file out of many files or  directories. tar can also filter the files through compression  utilities, thus reducing the size of the archive file.

## Simple Shell Script

The following shell script uses tar to create an archive file on a  remotely mounted NFS file system. The archive filename is determined  using additional command line utilities.

```
#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################

# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
```

- *$backup_files:* a variable listing which directories you would like to backup. The list should be customized to fit your needs.
- *$day:* a variable holding the day of the week (Monday,  Tuesday, Wednesday, etc). This is used to create an archive file for  each day of the week, giving a backup history of seven days. There are  other ways to accomplish this including using the date utility.
- *$hostname:* variable containing the *short* hostname  of the system. Using the hostname in the archive filename gives you the  option of placing daily archive files from multiple systems in the same  directory.
- *$archive_file:* the full archive filename.
- *$dest:* destination of the archive file. The directory needs to be created and in this case *mounted* before executing the backup script. See [???](https://ubuntu.com/server/docs/backups-shell-scripts#network-file-system) for details of using *NFS*.
- *status messages:* optional messages printed to the console using the echo utility.
- *tar czf $dest/$archive_file $backup_files:* the tar command used to create the archive file.
  - *c:* creates an archive.
  - *z:* filter the archive through the gzip utility compressing the archive.
  - *f:* output to an archive file. Otherwise the tar output will be sent to STDOUT.
- *ls -lh $dest:* optional statement prints a *-l* long listing in *-h* human readable format of the destination directory. This is useful for a quick file size check of the archive file. This check should not  replace testing the archive file.

This is a simple example of a backup shell script; however there are many options that can be included in such a script. See [References](https://ubuntu.com/server/docs/backups-shell-scripts#References) for links to resources providing more in-depth shell scripting information.

## Executing the Script

### Executing from a Terminal

The simplest way of executing the above backup script is to copy and paste the contents into a file. `backup.sh` for example. The file must be made executable:

```
chmod u+x backup.sh
```

Then from a terminal prompt:

```
sudo ./backup.sh
```

This is a great way to test the script to make sure everything works as expected.

### Executing with cron

The cron utility can be used to automate the script execution. The  cron daemon allows the execution of scripts, or commands, at a specified time and date.

cron is configured through entries in a `crontab` file. `crontab` files are separated into fields:

```
# m h dom mon dow   command
```

- *m:* minute the command executes on, between 0 and 59.
- *h:* hour the command executes on, between 0 and 23.
- *dom:* day of month the command executes on.
- *mon:* the month the command executes on, between 1 and 12.
- *dow:* the day of the week the command executes on, between 0 and 7. Sunday may be specified by using 0 or 7, both values are valid.
- *command:* the command to execute.

To add or change entries in a `crontab` file the crontab -e command should be used. Also, the contents of a `crontab` file can be viewed using the crontab -l command.

To execute the backup.sh script listed above using cron. Enter the following from a terminal prompt:

```
sudo crontab -e
```

> **Note**
>
> Using sudo with the crontab -e command edits the *root* user’s crontab. This is necessary if you are backing up directories only the root user has access to.

Add the following entry to the `crontab` file:

```
# m h dom mon dow   command
0 0 * * * bash /usr/local/bin/backup.sh
```

The `backup.sh` script will now be executed every day at 12:00 pm.

> **Note**
>
> The backup.sh script will need to be copied to the `/usr/local/bin/` directory in order for this entry to execute properly. The script can  reside anywhere on the file system, simply change the script path  appropriately.

For more in-depth crontab options see [References](https://ubuntu.com/server/docs/backups-shell-scripts#References).

## Restoring from the Archive

Once an archive has been created it is important to test the archive. The archive can be tested by listing the files it contains, but the  best test is to *restore* a file from the archive.

- To see a listing of the archive contents. From a terminal prompt type:

  ```
  tar -tzvf /mnt/backup/host-Monday.tgz
  ```

- To restore a file from the archive to a different directory enter:

  ```
  tar -xzvf /mnt/backup/host-Monday.tgz -C /tmp etc/hosts
  ```

  The *-C* option to tar redirects the extracted files to the specified directory. The above example will extract the `/etc/hosts` file to `/tmp/etc/hosts`. tar recreates the directory structure that it contains.

  Also, notice the leading *“/”* is left off the path of the file to restore.

- To restore all files in the archive enter the following:

  ```
  cd /
  sudo tar -xzvf /mnt/backup/host-Monday.tgz
  ```

> **Note**
>
> This will overwrite the files currently on the file system.

## References

- For more information on shell scripting see the [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/)
- The book [Teach Yourself Shell Programming in 24 Hours](http://safari.samspublishing.com/0672323583) is available online and a great resource for shell scripting.
- The [CronHowto Wiki Page](https://help.ubuntu.com/community/CronHowto) contains details on advanced cron options.
- See the [GNU tar Manual](http://www.gnu.org/software/tar/manual/index.html) for more tar options.
- The Wikipedia [Backup Rotation Scheme](http://en.wikipedia.org/wiki/Backup_rotation_scheme) article contains information on other backup rotation schemes.
- The shell script uses tar to create the archive, but there many other command line utilities that can be used. For example:
  - [cpio](http://www.gnu.org/software/cpio/): used to copy files to and from archives.
  - [dd](http://www.gnu.org/software/coreutils/): part of the coreutils package. A low level utility that can copy data from one format to another.
  - [rsnapshot](http://www.rsnapshot.org/): a file system snapshot utility used to create copies of an entire file system. Also check the [Tools - rsnapshot](https://ubuntu.com/server/docs/tools-rsnapshot) for some information.
  - [rsync](http://manpages.ubuntu.com/manpages/focal/man1/rsync.1.html): a flexible utility used to create incremental copies of files.

# PHP - Scripting Language

PHP is a general-purpose scripting language suited for Web  development. PHP scripts can be embedded into HTML. This section  explains how to install and configure PHP in an Ubuntu System with  Apache2 and MySQL.

This section assumes you have installed and configured Apache2 Web  Server and MySQL Database Server. You can refer to the Apache2 and MySQL sections in this document to install and configure Apache2 and MySQL  respectively.

## Installation

PHP is available in Ubuntu Linux. Unlike Python, which is installed in the base system, PHP must be added.

To install PHP and the Apache PHP module you can enter the following command at a terminal prompt:

```
sudo apt install php libapache2-mod-php
```

You can run PHP scripts at a terminal prompt. To run PHP scripts at a terminal prompt you should install the php-cli package. To install  php-cli you can enter the following command:

```
sudo apt install php-cli
```

You can also execute PHP scripts without installing the Apache PHP  module. To accomplish this, you should install the php-cgi package via  this command:

```
sudo apt install php-cgi
```

To use MySQL with PHP you should install the php-mysql package, like so:

```
sudo apt install php-mysql
```

Similarly, to use PostgreSQL with PHP you should install the php-pgsql package:

```
sudo apt install php-pgsql
```

## Configuration

If you have installed the libapache2-mod-php or php-cgi packages, you can run PHP scripts from your web browser. If you have installed the  php-cli package, you can run PHP scripts at a terminal prompt.

By default, when libapache2-mod-php is installed, the Apache 2 Web  server is configured to run PHP scripts using this module. Please verify if the files `/etc/apache2/mods-enabled/php7.*.conf` and `/etc/apache2/mods-enabled/php7.*.load` exist. If they do not exist, you can enable the module using the `a2enmod` command.

Once you have installed the PHP related packages and enabled the  Apache PHP module, you should restart the Apache2 Web server to run PHP  scripts, by running the following command:

```
sudo systemctl restart apache2.service 
```

## Testing

To verify your installation, you can run the following PHP phpinfo script:

```
<?php
  phpinfo();
?>
```

You can save the content in a file `phpinfo.php` and place it under the `DocumentRoot` directory of the Apache2 Web server. Pointing your browser to `http://hostname/phpinfo.php` will display the values of various PHP configuration parameters.

## References

- For more in depth information see the [php.net](http://www.php.net/docs.php) documentation.
- There are a plethora of books on PHP. A good book from O’Reilly is [Learning PHP](http://oreilly.com/catalog/0636920043034/), which includes an exploration of PHP 7’s enhancements to the language. [PHP Cook Book, 3rd Edition](http://shop.oreilly.com/product/0636920029335.do) is also good, but has not yet been updated for PHP 7.
- Also, see the [Apache MySQL PHP Ubuntu Wiki](https://help.ubuntu.com/community/ApacheMySQLPHP) page for more information.

# etckeeper

etckeeper allows the contents of `/etc` to be stored in a Version Control System (VCS) repository. It integrates with APT and automatically commits changes to `/etc` when packages are installed or upgraded. Placing `/etc` under version control is considered an industry best practice, and the  goal of etckeeper is to make this process as painless as possible.

Install etckeeper by entering the following in a terminal:

```
sudo apt install etckeeper
```

The main configuration file, `/etc/etckeeper/etckeeper.conf`, is fairly simple. The main option is which VCS to use and by default  etckeeper is configured to use git. The repository is automatically  initialized (and committed for the first time) during package  installation. It is possible to undo this by entering the following  command:

```
sudo etckeeper uninit
```

By default, etckeeper will commit uncommitted changes made to /etc  daily. This can be disabled using the AVOID_DAILY_AUTOCOMMITS  configuration option. It will also automatically commit changes before  and after package installation. For a more precise tracking of changes,  it is recommended to commit your changes manually, together with a  commit message, using:

```
sudo etckeeper commit "Reason for configuration change"
```

The `vcs` etckeeper command allows to run any subcommand of the VCS that etckeeper is configured to run.  t will be run in `/etc`. For example, in the case of git:

```
sudo etckeeper vcs log /etc/passwd
```

To demonstrate the integration with the package management system (APT), install postfix:

```
sudo apt install postfix
```

When the installation is finished, all the postfix configuration files should be committed to the repository:

```
[master 5a16a0d] committing changes in /etc made by "apt install postfix"
 Author: Your Name <xyz@example.com>
 36 files changed, 2987 insertions(+), 4 deletions(-)
 create mode 100755 init.d/postfix
 create mode 100644 insserv.conf.d/postfix
 create mode 100755 network/if-down.d/postfix
 create mode 100755 network/if-up.d/postfix
 create mode 100644 postfix/dynamicmaps.cf
 create mode 100644 postfix/main.cf
 create mode 100644 postfix/main.cf.proto
 create mode 120000 postfix/makedefs.out
 create mode 100644 postfix/master.cf
 create mode 100644 postfix/master.cf.proto
 create mode 100755 postfix/post-install
 create mode 100644 postfix/postfix-files
 create mode 100755 postfix/postfix-script
 create mode 100755 ppp/ip-down.d/postfix
 create mode 100755 ppp/ip-up.d/postfix
 create mode 120000 rc0.d/K01postfix
 create mode 120000 rc1.d/K01postfix
 create mode 120000 rc2.d/S01postfix
 create mode 120000 rc3.d/S01postfix
 create mode 120000 rc4.d/S01postfix
 create mode 120000 rc5.d/S01postfix
 create mode 120000 rc6.d/K01postfix
 create mode 100755 resolvconf/update-libc.d/postfix
 create mode 100644 rsyslog.d/postfix.conf
 create mode 120000 systemd/system/multi-user.target.wants/postfix.service
 create mode 100644 ufw/applications.d/postfix
```

For an example of how etckeeper tracks manual changes, add new a host to `/etc/hosts`. Using git you can see which files have been modified:

```
sudo etckeeper vcs status
```

and how:

```
sudo etckeeper vcs diff
```

If you are happy with the changes you can now commit them:

```
sudo etckeeper commit "added new host"
```

## Resources

- See the [etckeeper](https://etckeeper.branchable.com/) site for more details on using etckeeper.
- For documentation on the git VCS tool see the [Git](https://git-scm.com/) website.

# pam_motd

# Pam_motd

When logging into an Ubuntu server you may have noticed the informative  Message Of The Day (MOTD). This information is obtained and displayed  using a couple of packages:
登录 Ubuntu 服务器时，您可能已经注意到信息丰富的每日消息 （MOTD）。此信息是使用几个包获取和显示的：

- *landscape-common:* provides the core libraries of landscape-client, which is needed to manage systems with [Landscape](http://landscape.canonical.com/) (proprietary). Yet the package also includes the landscape-sysinfo  utility which is responsible for displaying core system data involving  cpu, memory, disk space, etc. For instance:
  landscape-common：提供 landscape-client 的核心库，这是使用 Landscape（专有）管理系统所必需的。然而，该软件包还包括  landscape-sysinfo 实用程序，该实用程序负责显示涉及 cpu、内存、磁盘空间等的核心系统数据。例如：

  ```auto
        System load:  0.0               Processes:           76
        Usage of /:   30.2% of 3.11GB   Users logged in:     1
        Memory usage: 20%               IP address for eth0: 10.153.107.115
        Swap usage:   0%
  
        Graph this data and manage this system at https://landscape.canonical.com/
  ```

  > **Note 注意**
  >
  > You can run landscape-sysinfo manually at any time.
  > 您可以随时手动运行 landscape-sysinfo。

- *update-notifier-common:* provides information on available package updates, impending filesystem checks (fsck), and required reboots (e.g.: after a kernel upgrade).
  update-notifier-common：提供有关可用软件包更新、即将进行的文件系统检查 （FSCK） 和所需的重新启动（例如：内核升级后）的信息。

pam_motd executes the scripts in `/etc/update-motd.d` in order based on the number prepended to the script. The output of the scripts is written to `/var/run/motd`, keeping the numerical order, then concatenated with `/etc/motd.tail`.
pam_motd根据附加到脚本前面的数字 `/etc/update-motd.d` 按顺序执行脚本。脚本的输出写入 `/var/run/motd` ，保持数字顺序，然后与 `/etc/motd.tail` 连接。

You can add your own dynamic information to the MOTD. For example, to add local weather information:
您可以将自己的动态信息添加到 MOTD。例如，要添加当地天气信息：

- First, install the weather-util package:
  首先，安装 weather-util 软件包：

  ```
  sudo apt install weather-util
  ```

- The weather utility uses METAR data from the National Oceanic and  Atmospheric Administration and forecasts from the National Weather  Service. In order to find local information you will need the  4-character ICAO location indicator. This can be determined by browsing  to the [National Weather Service](https://www.weather.gov/tg/siteloc) site.
  该气象实用程序使用美国国家海洋和大气管理局的 METAR 数据以及美国国家气象局的预报。为了查找本地信息，您需要 4 个字符的 ICAO 位置指示器。这可以通过浏览国家气象局网站来确定。

  Although the National Weather Service is a United States government agency there are weather stations available world wide. However, local weather  information for all locations outside the U.S. may not be available.
  虽然国家气象局是美国政府机构，但世界各地都有气象站。但是，美国以外所有地点的当地天气信息可能不可用。

- Create `/usr/local/bin/local-weather`, a simple shell script to use weather with your local ICAO indicator:
  创建 `/usr/local/bin/local-weather` 一个简单的 shell 脚本，将天气与您当地的 ICAO 指标一起使用：

  ```
  #!/bin/sh
  #
  #
  # Prints the local weather information for the MOTD.
  #
  #
  
  # Replace KINT with your local weather station.
  # Local stations can be found here: http://www.weather.gov/tg/siteloc.shtml
  
  echo
  weather KINT
  echo
  ```

- Make the script executable:
  使脚本可执行：

  ```
  sudo chmod 755 /usr/local/bin/local-weather
  ```

- Next, create a symlink to `/etc/update-motd.d/98-local-weather`:
  接下来，创建一个符号 `/etc/update-motd.d/98-local-weather` 链接：

  ```
  sudo ln -s /usr/local/bin/local-weather /etc/update-motd.d/98-local-weather
  ```

- Finally, exit the server and re-login to view the new MOTD.
  最后，退出服务器并重新登录以查看新的 MOTD。

You should now be greeted with some useful information, and some  information about the local weather that may not be quite so useful.  Hopefully the local-weather example demonstrates the flexibility of  pam_motd.
现在，您应该会看到一些有用的信息，以及一些可能不太有用的有关当地天气的信息。希望当地天气的例子能证明pam_motd的灵活性。

## Resources 资源

- See the [update-motd man page](http://manpages.ubuntu.com/manpages/jammy/en/man5/update-motd.5.html) for more options available to update-motd.
  有关 update-motd 的更多可用选项，请参见 update-motd 手册页。
- The Debian Package of the Day [weather](http://debaday.debian.net/2007/10/04/weather-check-weather-conditions-and-forecasts-on-the-command-line/) article has more details about using the weatherutility.
  Debian Package of the Day 天气文章提供了更多关于使用 weatherutility 的细节。

------

When logging into an Ubuntu server you may have noticed the  informative Message Of The Day (MOTD). This information is obtained and  displayed using a couple of packages:

- *landscape-common:* provides the core libraries of landscape-client, which is needed to manage systems with [Landscape](http://landscape.canonical.com/) (proprietary). Yet the package also includes the landscape-sysinfo  utility which is responsible for displaying core system data involving  cpu, memory, disk space, etc. For instance:

  ```auto
        System load:  0.0               Processes:           76
        Usage of /:   30.2% of 3.11GB   Users logged in:     1
        Memory usage: 20%               IP address for eth0: 10.153.107.115
        Swap usage:   0%
  
        Graph this data and manage this system at https://landscape.canonical.com/
  ```

  > **Note**
  >
  > You can run landscape-sysinfo manually at any time.

- *update-notifier-common:* provides information on available  package updates, impending filesystem checks (fsck), and required  reboots (e.g.: after a kernel upgrade).

pam_motd executes the scripts in `/etc/update-motd.d` in order based on the number prepended to the script. The output of the scripts is written to `/var/run/motd`, keeping the numerical order, then concatenated with `/etc/motd.tail`.

You can add your own dynamic information to the MOTD. For example, to add local weather information:

- First, install the weather-util package:

  ```
  sudo apt install weather-util
  ```

- The weather utility uses METAR data from the National Oceanic and  Atmospheric Administration and forecasts from the National Weather  Service. In order to find local information you will need the  4-character ICAO location indicator. This can be determined by browsing  to the [National Weather Service](https://www.weather.gov/tg/siteloc) site.

  Although the National Weather Service is a United States government  agency there are weather stations available world wide. However, local  weather information for all locations outside the U.S. may not be  available.

- Create `/usr/local/bin/local-weather`, a simple shell script to use weather with your local ICAO indicator:

  ```
  #!/bin/sh
  #
  #
  # Prints the local weather information for the MOTD.
  #
  #
  
  # Replace KINT with your local weather station.
  # Local stations can be found here: http://www.weather.gov/tg/siteloc.shtml
  
  echo
  weather KINT
  echo
  ```

- Make the script executable:

  ```
  sudo chmod 755 /usr/local/bin/local-weather
  ```

- Next, create a symlink to `/etc/update-motd.d/98-local-weather`:

  ```
  sudo ln -s /usr/local/bin/local-weather /etc/update-motd.d/98-local-weather
  ```

- Finally, exit the server and re-login to view the new MOTD.

You should now be greeted with some useful information, and some  information about the local weather that may not be quite so useful.  Hopefully the local-weather example demonstrates the flexibility of  pam_motd.

## Resources

- See the [update-motd man page](http://manpages.ubuntu.com/manpages/eoan/en/man5/update-motd.5.html) for more options available to update-motd.
- The Debian Package of the Day [weather](http://debaday.debian.net/2007/10/04/weather-check-weather-conditions-and-forecasts-on-the-command-line/) article has more details about using the weatherutility.



# Migrate from crmsh to pcs 从 crmsh 迁移到 pcs

From Ubuntu 23.04 Lunar Lobster onwards, `pcs` is the recommended and supported tool for setting up and managing  Corosync/Pacemaker clusters in Ubuntu. This is the final Ubuntu release  where `crmsh` will be supported (but not recommended) so users will have time to migrate away from `crmsh`.
从 Ubuntu 23.04 开始， `pcs` Lunar Lobster 是用于在 Ubuntu 中设置和管理 Corosync/Pacemaker 集群的推荐和支持工具。这是支持（但不推荐）的最终 Ubuntu 版本 `crmsh` ，因此用户将有时间从 `crmsh` .

The migration from `crmsh` to `pcs` is not very complex since both have a similar command-line interface  (CLI). Here is a direct mapping of some useful commands from `crmsh` to `pcs`.
从 `crmsh` 到 `pcs` 的迁移不是很复杂，因为两者都具有类似的命令行界面 （CLI）。下面是一些有用的命令从 `crmsh` 到 `pcs` 的直接映射。

| **Action**                                                   | **`crmsh`**                                                  | **`pcs`**                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Show configuration (raw XML) 显示配置（原始 XML）            | `crm configure show xml`                                     | `pcs cluster cib`                                            |
| Show configuration (human-friendly) 显示配置（人性化）       | `crm configure show`                                         | `pcs config`                                                 |
| Show cluster status 显示集群状态                             | `crm status`                                                 | `pcs status`                                                 |
| Put a node in standby mode 将节点置于待机模式                | `crm node standby NODE`                                      | `pcs node standby NODE`                                      |
| Remove a node from standby mode 从待机模式中删除节点         | `crm node online NODE`                                       | `pcs node unstandby NODE`                                    |
| Set cluster property 设置集群属性                            | `crm configure property PROPERTY=VALUE`                      | `pcs property set PROPERTY=VALUE`                            |
| List resource agent classes 列出资源代理类                   | `crm ra classes`                                             | `pcs resource standards`                                     |
| List available resource agents by standard 按标准列出可用的资源代理 | `crm ra list ocf`                                            | `pcs resource agents ocf 'PCS 资源代理 OCF                   |
| List available resource agents by OCF provider 按 OCF 提供程序列出可用的资源代理 | `crm ra list ocf pacemaker`                                  | `pcs resource agents ocf:pacemaker`                          |
| List available resource agent parameters 列出可用的资源代理参数 | `crm ra info AGENT`                                          | `pcs resource describe AGENT`                                |
| Show available fence agent parameters 显示可用的围栏代理参数 | `crm ra info stonith:AGENT`                                  | `pcs stonith describe AGENT`                                 |
| Create a resource 创建资源                                   | `crm configure primitive NAME AGENT params PARAMETERS`       | `pcs resource create NAME AGENT PARAMETERS`                  |
| Show configuration of all resources 显示所有资源的配置       | `crm configure show`                                         | `pcs resource config`                                        |
| Show configuration of one resource 显示一个资源的配置        | `crm configure show RESOURCE`                                | `pcs resource config RESOURCE`                               |
| Show configuration of fencing resources 显示隔离资源的配置   | `crm resource status`                                        | `pcs stonith config`                                         |
| Start a resource 启动资源                                    | `crm resource start  RESOURCE`                               | `pcs resource enable RESOURCE`                               |
| Stop a resource 停止资源                                     | `crm resource stop RESOURCE`                                 | `pcs resource disable RESOURCE`                              |
| Remove a resource 删除资源                                   | `crm configure delete RESOURCE`                              | `pcs resource delete RESOURCE`                               |
| Modify a resource’s instance parameters 修改资源的实例参数   | `crm resource param RESOURCE set PARAMETER=VALUE`            | `pcs resource update RESOURCE PARAMETER=VALUE`               |
| Delete a resource’s instance parameters 删除资源的实例参数   | `crm resource param RESOURCE delete PARAMETER`               | `pcs resource update RESOURCE PARAMETER=`                    |
| List current resource defaults 列出当前资源默认值            | `crm configure show type:rsc_defaults`                       | `pcs resource defaults`                                      |
| Set resource defaults 设置资源默认值                         | `crm configure rsc_defaults OPTION=VALUE`                    | `pcs resource defaults OPTION=VALUE`                         |
| List current operation defaults 列出当前操作默认值           | `crm configure show type:op_defaults`                        | `pcs resource op defaults`                                   |
| Set operation defaults 设置操作默认值                        | `crm configure op_defaults OPTION=VALUE`                     | `pcs resource op defaults OPTION=VALUE`                      |
| Clear fail counts for a resource 清除资源的失败计数          | `crm resource cleanup RESOURCE`                              | `pcs resource cleanup`                                       |
| Create a colocation constraint 创建主机托管约束              | `crm configure colocation NAME INFINITY: RESOURCE_1 RESOURCE_2` | `pcs constraint colocation add RESOURCE_1 with RESOURCE_2 INFINITY` |
| Create an ordering constraint 创建排序约束                   | `crm configure order NAME mandatory: RESOURCE_1 RESOURCE_2`  | `pcs constraint order RESOURCE_1 then RESOURCE_2`            |
| Create a location constraint 创建位置约束                    | `crm configure location NAME RESOURCE 50: NODE`              | `pcs constraint location RESOURCE prefers NODE=50`           |
| Move a resource to a specific node 将资源移动到特定节点      | `crm resource move RESOURCE NODE`                            | `pcs resource move  RESOURCE NODE`                           |
| Move a resource away from its current node 将资源移离其当前节点 | `crm resource ban RESOURCE NODE`                             | `pcs resource ban RESOURCE NODE`                             |
| Remove any constraints created by moving a resource 删除通过移动资源创建的任何约束 | `crm resource unmove RESOURCE`                               | `pcs resource clear RESOURCE`                                |

------

# Basic backup shell script 基本备份 shell 脚本

The following shell script uses tar to create an archive file on a remotely mounted NFS file system. The archive filename is determined using  additional command line utilities.
以下 shell 脚本使用 tar 在远程挂载的 NFS 文件系统上创建归档文件。存档文件名是使用其他命令行实用程序确定的。

Either copy the code into a file, or for instructions of how to use the script, [refer to this guide](https://ubuntu.com/server/docs/how-to-back-up-using-shell-scripts).
将代码复制到文件中，或者有关如何使用脚本的说明，请参阅本指南。

```auto
#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################
    
# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"
    
# Where to backup to.
dest="/mnt/backup"
    
# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"
    
# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo
    
# Backup the files using tar.
tar czf $dest/$archive_file $backup_files
    
# Print end status message.
echo
echo "Backup finished"
date
    
# Long listing of files in $dest to check file sizes.
ls -lh $dest
```

- `$backup_files`: A variable listing which directories you would like to backup. The list should be customized to fit your needs.
   `$backup_files` ：列出要备份的目录的变量。该列表应根据您的需求进行自定义。
- `$day`: A variable holding the day of the week (Monday, Tuesday, Wednesday,  etc). This is used to create an archive file for each day of the week,  giving a backup history of seven days. There are other ways to  accomplish this including using the `date` utility.
   `$day` ：保存星期几（星期一、星期二、星期三等）的变量。这用于为一周中的每一天创建一个存档文件，提供 7 天的备份历史记录。还有其他方法可以实现此目的，包括使用 `date` 实用程序。
- `$hostname`: A variable containing the *short* hostname of the system. Using the hostname in the archive filename  gives you the option of placing daily archive files from multiple  systems in the same directory.
   `$hostname` ：包含系统短主机名的变量。使用归档文件名中的主机名，可以选择将来自多个系统的每日归档文件放在同一目录中。
- `$archive_file`: The full archive filename.
   `$archive_file` ：完整的存档文件名。
- `$dest`: Destination of the archive file. The directory needs to be created and in this case *mounted* before executing the backup script. See [NFS](https://ubuntu.com/server/docs/network-file-system-nfs) for details of using NFS.
   `$dest` ：存档文件的目标。在执行备份脚本之前，需要创建并挂载目录。有关使用 NFS 的详细信息，请参阅 NFS。
- `status messages`: Optional messages printed to the console using the `echo` utility.
   `status messages` ：使用 `echo` 实用程序打印到控制台的可选消息。
- `tar czf $dest/$archive_file $backup_files`: The tar command used to create the archive file.
   `tar czf $dest/$archive_file $backup_files` ：用于创建归档文件的 tar 命令。
  - `c`: Creates an archive.
     `c` ：创建存档。
  - `z`: Filter the archive through the `gzip` utility, compressing the archive.
     `z` ：通过 `gzip` 实用程序过滤存档，压缩存档。
  - `f`: Output to an archive file. Otherwise the `tar` output will be sent to STDOUT.
     `f` ：输出到存档文件。否则， `tar` 输出将发送到 STDOUT。
- `ls -lh $dest`: Optional statement prints a `-l` long listing in `-h` human-readable format of the destination directory. This is useful for a quick file size check of the archive file. This check should not  replace testing the archive file.
   `ls -lh $dest` ：可选语句以 `-h` 人类可读的格式打印目标目录的 `-l` 长列表。这对于快速检查存档文件的文件大小非常有用。此检查不应取代对存档文件的测试。

This is a simple example of a backup shell script; however there are many  options that can be included in such a script. For more information on  shell scripting see the [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/).
这是备份 shell 脚本的简单示例;但是，此类脚本中可以包含许多选项。有关 shell 脚本的更多信息，请参见高级 Bash 脚本指南。

## Further reading 延伸阅读

- The [CronHowto Wiki Page](https://help.ubuntu.com/community/CronHowto) contains details on advanced `cron` options.
  CronHowto Wiki 页面包含有关高级 `cron` 选项的详细信息。
- See the [GNU tar Manual](http://www.gnu.org/software/tar/manual/index.html) for more `tar` options.
  有关更多 `tar` 选项，请参见 GNU tar 手册。
- The Wikipedia [Backup Rotation Scheme](http://en.wikipedia.org/wiki/Backup_rotation_scheme) article contains information on other backup rotation schemes.
  维基百科备份轮换方案一文包含有关其他备份轮换方案的信息。
- The shell script uses `tar` to create the archive, but there many other command line utilities that can be used. For example:
  shell 脚本用于 `tar` 创建存档，但还有许多其他命令行实用程序可以使用。例如：
  - [`cpio`](http://www.gnu.org/software/cpio/): Used to copy files to and from archives.
     `cpio` ：用于将文件复制到存档或从存档复制文件。
  - [`dd`](http://www.gnu.org/software/coreutils/): Part of the `coreutils` package. A low level utility that can copy data from one format to another.
     `dd` ： `coreutils` 包的一部分。一个低级实用程序，可以将数据从一种格式复制到另一种格式。
  - [`rsnapshot`](http://www.rsnapshot.org/): A filesystem snapshot utility used to create copies of an entire file system. Also check the [Install rsnapshot guide](https://ubuntu.com/server/docs/how-to-install-and-configure-rsnapshot) for more information.
     `rsnapshot` ：用于创建整个文件系统副本的文件系统快照实用程序。另请查看安装 rsnapshot 指南以获取更多信息。
  - [`rsync`](http://manpages.ubuntu.com/manpages/focal/man1/rsync.1.html): A flexible utility used to create incremental copies of files.
     `rsync` ：用于创建文件增量副本的灵活实用程序。

------

# Archive rotation shell script 存档轮换 shell 脚本

The [simple backup shell script](https://ubuntu.com/server/docs/basic-backup-shell-script) only allows for seven different archives. For a server whose data  doesn’t change often, this may be enough. If the server has a large  amount of data, a more complex rotation scheme should be used.
简单的备份 shell 脚本只允许 7 个不同的存档。对于数据不经常更改的服务器，这可能就足够了。如果服务器有大量数据，则应使用更复杂的轮换方案。

## Rotating NFS archives 轮换 NFS 存档

Here, the shell script is slightly modified to implement a grandparent-parent-child rotation scheme (monthly-weekly-daily):
在这里，shell 脚本稍作修改，以实现祖父母-父母-子轮换方案（每月-每周-每天）：

- The rotation will do a *daily* backup from Sunday to Friday.
  轮换将从周日到周五进行每日备份。
- On Saturday, a *weekly* backup is done – giving four weekly backups per month.
  在星期六，每周进行一次备份 - 每月进行四次每周备份。
- The *monthly* backup is done on the first day of the month, rotating two monthly backups based on whether the month is odd or even.
  每月备份在每月的第一天完成，根据月份是奇数还是偶数轮换两个月备份。

Here is the new script:
下面是新脚本：

```sh
#!/bin/bash
####################################
#
# Backup to NFS mount script with
# grandparent-parent-child rotation.
#
####################################
    
# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"
    
# Where to backup to.
dest="/mnt/backup"
    
# Setup variables for the archive filename.
day=$(date +%A)
hostname=$(hostname -s)
    
# Find which week of the month 1-4 it is.
day_num=$(date +%-d)
if (( $day_num <= 7 )); then
        week_file="$hostname-week1.tgz"
elif (( $day_num > 7 && $day_num <= 14 )); then
        week_file="$hostname-week2.tgz"
elif (( $day_num > 14 && $day_num <= 21 )); then
        week_file="$hostname-week3.tgz"
elif (( $day_num > 21 && $day_num < 32 )); then
        week_file="$hostname-week4.tgz"
fi
    
# Find if the Month is odd or even.
month_num=$(date +%m)
month=$(expr $month_num % 2)
if [ $month -eq 0 ]; then
        month_file="$hostname-month2.tgz"
else
        month_file="$hostname-month1.tgz"
fi
    
# Create archive filename.
if [ $day_num == 1 ]; then
        archive_file=$month_file
elif [ $day != "Saturday" ]; then
        archive_file="$hostname-$day.tgz"
else 
        archive_file=$week_file
fi
    
# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo
    
# Backup the files using tar.
tar czf $dest/$archive_file $backup_files
    
# Print end status message.
echo
echo "Backup finished"
date
    
# Long listing of files in $dest to check file sizes.
ls -lh $dest/
```

The script can be executed using the same methods as in our guide on [how to back up using shell scripts](https://ubuntu.com/server/docs/how-to-back-up-using-shell-scripts).
可以使用与如何使用 shell 脚本进行备份的指南中相同的方法来执行该脚本。

As discussed in the introduction, a copy of the backup archives and/or media can then be transferred off-site.
如引言所述，备份档案和/或介质的副本可以转移到异地。

## Backing up to tape drives 备份到磁带驱动器

A tape drive attached to the server can be used instead of an NFS share.  Using a tape drive simplifies archive rotation, and makes taking the  media off-site easier as well.
可以使用连接到服务器的磁带机代替 NFS 共享。使用磁带机可以简化存档轮换，并且还可以更轻松地将介质移出异地。

When using a tape drive, the filename portions of the script aren’t needed  because the data is sent directly to the tape device. Some commands to  manipulate the tape *are* needed, however. This is accomplished using `mt`, a magnetic tape control utility – part of the `cpio` package.
使用磁带驱动器时，不需要脚本的文件名部分，因为数据直接发送到磁带设备。但是，需要一些命令来操作磁带。这是使用 `mt` 磁带控制实用程序（ `cpio` 包装的一部分）实现的。

Here is the shell script modified to use a tape drive:
下面是修改为使用磁带驱动器的 shell 脚本：

```sh
#!/bin/bash
####################################
#
# Backup to tape drive script.
#
####################################
    
# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"
    
# Where to backup to.
dest="/dev/st0"
    
# Print start status message.
echo "Backing up $backup_files to $dest"
date
echo
    
# Make sure the tape is rewound.
mt -f $dest rewind
    
# Backup the files using tar.
tar czf $dest $backup_files
    
# Rewind and eject the tape.
mt -f $dest rewoffl
    
# Print end status message.
echo
echo "Backup finished"
date
```

> **Note**: 注意：
>  The default device name for a SCSI tape drive is `/dev/st0`. Use the appropriate device path for your system.
> SCSI 磁带机的默认设备名称为 `/dev/st0` 。为您的系统使用适当的设备路径。

Restoring from a tape drive is basically the same as restoring from a file.  Simply rewind the tape and use the device path instead of a file path.  For example, to restore the `/etc/hosts` file to `/tmp/etc/hosts`:
从磁带机恢复与从文件恢复基本相同。只需倒带并使用设备路径而不是文件路径即可。例如，要将 `/etc/hosts` 文件还原为 `/tmp/etc/hosts` ：

```bash
mt -f /dev/st0 rewind
tar -xzf /dev/st0 -C /tmp etc/hosts
```

------

# About debuginfod 关于debuginfod

[`debuginfod`](https://sourceware.org/elfutils/Debuginfod.html) is a service for software developers. It helps with diagnosing issues  in software and centralises the storage of debug symbols, source code,  etc.
 `debuginfod` 是面向软件开发人员的服务。它有助于诊断软件中的问题，并集中存储调试符号、源代码等。

One of the main advantages to `debuginfod` is that debugging information can be retrieved on-demand for packages shipped with Ubuntu without the need to [manually install](https://ubuntu.com/server/docs/debug-symbol-packages) the debug symbol packages.
其 `debuginfod` 主要优点之一是，可以按需检索 Ubuntu 附带的软件包的调试信息，而无需手动安装调试符号软件包。

Ubuntu maintains its own `debuginfod` service, which regularly indexes the debug symbols present in `ddebs` and other packages and serves this information over HTTPS.
Ubuntu 维护自己的 `debuginfod` 服务，该服务定期索引和其他软件包中 `ddebs` 存在的调试符号，并通过 HTTPS 提供此信息。

Currently, the service only provides DWARF information. There are plans for it to  also index and serve source-code in the future.
目前，该服务仅提供 DWARF 信息。它计划在未来也为源代码编制索引和提供。

## Using the service 使用服务

`debuginfod` is indexing `ddebs` packages from all [supported Ubuntu releases](https://releases.ubuntu.com/).  Once a release goes unsupported, we stop indexing `ddebs` from it and eventually stop serving debug symbols for its packages.
 `debuginfod` 正在索引 `ddebs` 所有受支持的 Ubuntu 版本中的包。一旦某个版本不受支持，我们就会停止 `ddebs` 从中建立索引，并最终停止为其包提供调试符号。

From Kinetic onwards, when you install [GNU Debugger (GDB)](https://www.sourceware.org/gdb/) your system will be automatically configured to use Ubuntu’s `debuginfod` service.  For previous Ubuntu releases, you can manually enable the service by setting the `DEBUGINFOD_URLS` environment variable in your shell. If you use Bash, you can do that by adding the following snippet to your `~/.bashrc`:
从 Kinetic 开始，当您安装 GNU 调试器 （GDB） 时，您的系统将自动配置为使用 Ubuntu `debuginfod` 的服务。对于以前的 Ubuntu 版本，您可以通过在 shell 中设置 `DEBUGINFOD_URLS` 环境变量来手动启用服务。如果您使用 Bash，则可以通过将以下代码片段添加到您的 `~/.bashrc` ：

```plaintext
export DEBUGINFOD_URLS="https://debuginfod.ubuntu.com"
```

When you run GDB, and if you have the `DEBUGINFOD_URLS` variable in your environment, you will be asked whether you would like  to use the service.  If you want to make sure that GDB always uses `debuginfod`, you can put the following snippet inside your `~/.gdbinit` file:
当您运行 GDB 时，如果您的环境中有该 `DEBUGINFOD_URLS` 变量，系统将询问您是否要使用该服务。如果要确保 GDB 始终使用 `debuginfod` ，可以将以下代码片段放入文件中 `~/.gdbinit` ：

```plaintext
set debuginfod enabled on
```

The debug symbol files will be downloaded on-the-fly during your debugging session, and will be saved locally inside the `$XDG_CACHE_HOME/.debuginfod_client/` directory. If `$XDG_CACHE_HOME` is empty, then `~/.cache/debuginfod_client` is used instead.
调试符号文件将在调试会话期间即时下载，并将保存在本地 `$XDG_CACHE_HOME/.debuginfod_client/` 目录中。如果 `$XDG_CACHE_HOME` 为空，则改用 then `~/.cache/debuginfod_client` 。

You can safely remove this directory or any files inside it; they will only be downloaded again if and when they are needed.
您可以安全地删除此目录或其中的任何文件;只有在需要时才会再次下载它们。

## Example session with GDB 与 GDB 的示例会话

If you have enabled use of `debuginfod` on your system, here is what happens when you invoke GDB to debug a binary from an Ubuntu package:
如果您在系统上启用了使用， `debuginfod` 则在调用 GDB 以调试 Ubuntu 包中的二进制文件时，会发生以下情况：

```bash
$ gdb -q program
Reading symbols from program...

This GDB supports auto-downloading debuginfo from the following URLs:
https://debuginfod.ubuntu.com 
Enable debuginfod for this session? (y or [n]) 
```

When you answer `y` to the question above, GDB will download the debug symbols for `program`:
当您回答 `y` 上述问题时，GDB 将下载以下 `program` 的调试符号：

```auto
Enable debuginfod for this session? (y or [n]) y
Debuginfod has been enabled.
To make this setting permanent, add 'set debuginfod enabled on' to .gdbinit.
Downloading 0.20 MB separate debug info for /home/ubuntu/program
Reading symbols from /home/ubuntu/.cache/debuginfod_client/c0fbda15a807f880e9d0b2dcc635eeeb1f0f728e/debuginfo...                                                                           
(gdb) 
```

## Opting out of the service 选择退出服务

If, for some reason, you prefer not to use the service, you can opt-out of it by un-setting the `DEBUGINFOD_URLS` environment variable.  This can be done by putting the following snippet inside your shell’s configuration file:
如果出于某种原因，您不想使用该服务，则可以通过取消 `DEBUGINFOD_URLS` 设置环境变量来选择退出该服务。这可以通过将以下代码片段放入 shell 的配置文件中来完成：

```auto
unset DEBUGINFOD_URLS
```

You can also disable GDB’s willingness to use `debuginfod` by putting the following snippet inside your `~/.gdbinit`:
您还可以 `debuginfod` 通过将以下代码片段放入您的 `~/.gdbinit` ：

```auto
set debuginfod enabled off
```

## How does `debuginfod` find the debug symbols for the binary I am debugging? 如何 `debuginfod` 找到我正在调试的二进制文件的调试符号？

`debuginfod` relies on a unique hash that identifies binaries and shared libraries called **Build-ID**.  This 160-bit SHA-1 hash is generated by the compiler, and can be consulted using tools like `readelf`:
 `debuginfod` 依赖于标识二进制文件和共享库的唯一哈希，称为 Build-ID。此 160 位 SHA-1 哈希值由编译器生成，可以使用以下 `readelf` 工具进行查询：

```auto
$ readelf -n /usr/bin/bash

Displaying notes found in: .note.gnu.property
  Owner                Data size        Description
  GNU                  0x00000020       NT_GNU_PROPERTY_TYPE_0
      Properties: x86 feature: IBT, SHSTK
        x86 ISA needed: x86-64-baseline

Displaying notes found in: .note.gnu.build-id
  Owner                Data size        Description
  GNU                  0x00000014       NT_GNU_BUILD_ID (unique build ID bitstring)
    Build ID: 3e770d2cd0302c6ff2a184e8d2bf4ec98cfcded4

Displaying notes found in: .note.ABI-tag
  Owner                Data size        Description
  GNU                  0x00000010       NT_GNU_ABI_TAG (ABI version tag)
    OS: Linux, ABI: 3.2.0
```

When you are debugging a program, GDB will send the program’s Build-ID to the `debuginfod` server, which will check if it has the corresponding debug information  for that binary/library.  If it does, then it will send the debug  symbols via HTTPS back to GDB.
调试程序时，GDB 会将程序的 Build-ID 发送到 `debuginfod` 服务器，服务器将检查它是否具有该二进制文件/库的相应调试信息。如果是这样，那么它将通过 HTTPS 将调试符号发送回 GDB。

## Can `ddebs` packages co-exist with `debuginfod`? 软件包可以 `ddebs` 与 `debuginfod` 共存吗？

Yes. GDB will try to use local debug information if available.  That means that if you have a `ddeb` package installed that provides the necessary debug symbols for the  program being debugged (or if you have already downloaded that  information from the `debuginfod` service earlier), then GDB will use it in favour of performing the download.
是的。GDB 将尝试使用本地调试信息（如果可用）。这意味着，如果您安装了一个 `ddeb` 软件包，该软件包为正在调试的程序提供了必要的调试符号（或者如果您之前已经从 `debuginfod` 服务中下载了该信息），那么 GDB 将使用它来执行下载。

## Can I use `debuginfod` with my own binary that links against system libraries? 我可以与我自己的二进制文件一起使用 `debuginfod` 链接到系统库吗？

Yes! `debuginfod` will not be able to provide any debug symbols for your own program, but it will happily serve debug information for any system libraries that  your program links against.
是的！ `debuginfod` 无法为您自己的程序提供任何调试符号，但它很乐意为您的程序链接的任何系统库提供调试信息。

# Debug symbol packages 调试符号包

If you want to debug a crash – whether in a project you are developing  yourself or from a third-party package – or if you frequently need the  debug symbols for specific libraries, it might be helpful to install  them permanently on your system if you can’t use debuginfod.
如果你想调试崩溃 - 无论是在你自己开发的项目中还是从第三方包 - 或者如果你经常需要特定库的调试符号，如果你不能使用debuginfod，将它们永久安装在你的系统上可能会有所帮助。

This document describes how to set up the debugging symbol packages (`*-dbg.deb` and `*-dbgsym.ddeb`). You might need to do this when you are performing tasks like a [Backtrace](https://wiki.ubuntu.com/Backtrace) or using [Valgrind](https://wiki.ubuntu.com/Valgrind).
本文档介绍如何设置调试符号包（ `*-dbg.deb` 和 `*-dbgsym.ddeb` ）。在执行回溯或使用 Valgrind 等任务时，可能需要执行此操作。

## Debuginfod 调试信息

If you are on Ubuntu Jammy (22.04) or later, you don’t need to worry about installing debug symbol packages since the Ubuntu project maintains a [Debuginfod](https://ubuntu.com/server/docs/about-debuginfod) server. [GNU Debugger (GDB)](https://www.sourceware.org/gdb/) and other debuginfo-consumer applications support Debuginfod (mostly)  out of the box. For more information about it, please refer [to our Debuginfod guide](https://ubuntu.com/server/docs/about-debuginfod).
如果您使用的是 Ubuntu Jammy （22.04） 或更高版本，则无需担心安装调试符号包，因为 Ubuntu 项目维护 Debuginfod  服务器。GNU 调试器 （GDB） 和其他 debuginfo-consumer 应用程序（大部分）支持开箱即用的  Debuginfod。有关它的更多信息，请参阅我们的 Debuginfod 指南。

You will only need to follow the methods outlined in this section if you are on Ubuntu Focal (20.04) or earlier.
如果您使用的是 Ubuntu Focal （20.04） 或更早版本，则只需遵循本节中概述的方法。

## Getting -dbgsym.ddeb packages 获取 -dbgsym.ddeb 包

If you are debugging without debuginfod, your first step will be to enable the `ddebs.ubuntu.com` repository as described in this section, which will provide access to the `-dbgsym` packages.
如果在不使用 debuginfod 的情况下进行调试，则第一步是 `ddebs.ubuntu.com` 启用本节中所述的存储库，这将提供对包的 `-dbgsym` 访问。

In the rare cases where the `-dbgsym` package is not available, you might need to install the `-dbg` package instead. The subsequent section (Manual install of debug packages) provides more information about this case.
在极少数情况下，如果该 `-dbgsym` 软件包不可用，则可能需要改为安装该 `-dbg` 软件包。后续部分（手动安装调试包）提供了有关此案例的详细信息。

### Import the signing key 导入签名密钥

Import the debug symbol archive [signing key](https://help.ubuntu.com/community/Repositories/Ubuntu#Authentication_Tab) from the Ubuntu server. On Ubuntu 18.04 LTS and newer, run the following command:
从 Ubuntu 服务器导入调试符号存档签名密钥。在 Ubuntu 18.04 LTS 及更高版本上，运行以下命令：

```bash
sudo apt install ubuntu-dbgsym-keyring
```

### Create a ddebs.list file 创建 ddebs.list 文件

Create an `/etc/apt/sources.list.d/ddebs.list` by running the following line at a terminal:
 `/etc/apt/sources.list.d/ddebs.list` 通过在终端上运行以下行来创建一个：

```bash
echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse
deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | \
sudo tee -a /etc/apt/sources.list.d/ddebs.list
```

You can also add these repositories in your software sources from the Ubuntu software center or from Synaptic (refer to [this article](https://help.ubuntu.com/community/Repositories/Ubuntu), especially the section on [adding other repositories](https://help.ubuntu.com/community/Repositories/Ubuntu#Adding_Other_Repositories)). You will need to add lines like:
您还可以从 Ubuntu 软件中心或 Synaptic 将这些存储库添加到您的软件源中（请参阅本文，尤其是有关添加其他存储库的部分）。您需要添加如下行：

```bash
deb http://ddebs.ubuntu.com focal main restricted universe multiverse
```

> **Note**: 注意：
>  Make sure you replace “focal” with the Ubuntu release name you’re using.
> 确保将“focal”替换为您正在使用的 Ubuntu 版本名称。

### Update package list 更新软件包列表

Run the following to update your package list or click the Reload button if you used the Synaptic Package Manager:
运行以下命令以更新包列表，或单击“重新加载”按钮（如果使用了Synaptic包管理器）：

```bash
sudo apt-get update
```

## Manual install of debug packages 手动安装调试包

To install the debug symbol package (`*-dbgsym.ddeb`) for a specific package, you can now invoke:
若要安装特定包的调试符号包 （ `*-dbgsym.ddeb` ），现在可以调用：

```bash
sudo apt-get install PACKAGE-dbgsym
```

For example, to install the debug symbols for `xserver-xorg-core`:
例如，要安装以下的 `xserver-xorg-core` 调试符号：

```bash
sudo apt-get install xserver-xorg-core-dbgsym
```

As mentioned in the section above, some packages will ship their debug symbols via `*-dbg.deb` packages instead. Using `glibc` as an example, you can install its debug symbols using:
如上一节所述，某些软件包将通过 `*-dbg.deb` 软件包提供其调试符号。 `glibc` 例如，您可以使用以下命令安装其调试符号：

```bash
sudo apt-get install libc6-dbg
```

This procedure will install the debug symbol package for a single package  only. It is likely that the binary uses shared libraries in other  packages, and their debug symbols may be needed in order to obtain a  readable stack trace or perform other debugging tasks.
此过程将仅为单个包安装调试符号包。二进制文件可能使用其他包中的共享库，并且可能需要它们的调试符号才能获得可读的堆栈跟踪或执行其他调试任务。

### The debian-goodies tool debian-goodies 工具

You can use the `find-dbgsym-packages` command from the `debian-goodies` package to find debug symbols for a core file, running PID or binary path.
您可以使用 `debian-goodies` 包中 `find-dbgsym-packages` 的命令查找运行 PID 或二进制路径的核心文件的调试符号。

For a binary path it only finds debug symbols for the actual binary itself, and not any dynamically linked library dependencies or other libraries  loaded at runtime. For that functionality to work you need to use either a core file or a running PID (which is the preferred method).
对于二进制路径，它只查找实际二进制文件本身的调试符号，而不查找任何动态链接的库依赖项或在运行时加载的其他库。要使该功能正常工作，您需要使用核心文件或正在运行的 PID（这是首选方法）。

This tool will find both `-dbg` and `-dbgsym` style packages. However it only finds debug symbols for APT  repositories that are currently enabled and updated, so you need to  ensure that you enable at least the `ddebs.ubuntu.com` archive as described above. For a Launchpad PPA or the Ubuntu Cloud  Archive you need to add another source line with the component changed  from `main` to `main/debug`:
此工具将查找包 `-dbg` 并 `-dbgsym` 设置样式包。但是，它只查找当前启用和更新的 APT 存储库的调试符号，因此您需要确保至少启用上述 `ddebs.ubuntu.com` 存档。对于 Launchpad PPA 或 Ubuntu Cloud Archive，您需要添加另一个源代码行，并将组件从 `main` `main/debug` ：

```bash
sudo apt install debian-goodies
find-dbgsym-packages [core_path|running_pid|binary_path]
```

## “debs” versus “ddebs” “debs”与“ddebs”

It used to be the case that Debian/Ubuntu maintainers needed to manually  create debug symbol packages as part of the packaging process, and  included them in the same repository as their binary package. These  debug symbol packages had the `-dbg.deb` suffix, so for example, both the `apache2-bin.deb` package and the `apache2-dbg.deb` package would be placed in the same repository. However, since the  process is a manual one, not every maintainer did this, and the `.deb` package was not always kept up-to-date.
过去的情况是，Debian/Ubuntu 维护者需要手动创建调试符号包作为打包过程的一部分，并将它们包含在与二进制包相同的存储库中。这些调试符号包具有 `-dbg.deb` 后缀，因此例如， `apache2-bin.deb` 包和 `apache2-dbg.deb` 包将放在同一个存储库中。但是，由于该过程是手动过程，因此并非每个维护人员都这样做，并且软件 `.deb` 包并不总是保持最新状态。

Modern package building tools automatically create the debug symbol packages  when binary packages are compiled on Ubuntu servers, so the older  (manual) process is no longer used. These automatically-created debug  symbol packages have the `-dbgsym.ddeb` suffix. Unlike `-dbg.deb` packages, `-dbgsym.ddeb` packages are hosted in [their own separate repository](http://ddeb.ubuntu.com), since these packages are used relatively rarely.
当在 Ubuntu 服务器上编译二进制包时，现代包构建工具会自动创建调试符号包，因此不再使用较旧的（手动）过程。这些自动创建的调试符号包具有 `-dbgsym.ddeb` 后缀。与包不同 `-dbg.deb` ， `-dbgsym.ddeb` 包托管在自己单独的存储库中，因为这些包相对较少使用。

You can choose to use either `-dbg.deb` or `-dbgsym.ddeb` packages, but for any given binary package only one debug symbol package can be used at once.
您可以选择使用其中一个 `-dbg.deb`  `-dbgsym.ddeb` 包，但对于任何给定的二进制包，一次只能使用一个调试符号包。

------

# Byobu

One of the most useful applications for any system administrator is an  xterm multiplexer such as screen or tmux. It allows for the execution of multiple shells in one terminal. To make some of the advanced  multiplexer features more user-friendly and provide some useful  information about the system, the byobu package was created. It acts as a wrapper to these programs. By default Byobu is installed in Ubuntu  server and it uses tmux (if installed) but this can be changed by the  user.
对于任何系统管理员来说，最有用的应用程序之一是 xterm 多路复用器，例如 screen 或 tmux。它允许在一个终端中执行多个  shell。为了使一些高级多路复用器功能更加用户友好，并提供有关系统的一些有用信息，创建了 byobu  软件包。它充当这些程序的包装器。默认情况下，Byobu 安装在 Ubuntu 服务器中，它使用 tmux（如果已安装），但用户可以更改。

Invoke it simply with:
只需使用以下方法调用它：

```
byobu
```

Now bring up the configuration menu. By default this is done by pressing the *F9* key. This will allow you to:
现在调出配置菜单。默认情况下，这是通过按 F9 键完成的。这将允许您：

- Help – Quick Start Guide
  Help – 快速入门指南
- Toggle status notifications
  切换状态通知
- Change the escape sequence
  更改转义序列
- Byobu currently does not launch at login (toggle on)
  Byobu 当前无法在登录时启动（打开）

byobu provides a menu which displays the Ubuntu release, processor  information, memory information, and the time and date. The effect is  similar to a desktop menu.
byobu 提供了一个菜单，其中显示 Ubuntu 版本、处理器信息、内存信息以及时间和日期。效果类似于桌面菜单。

Using the *“Byobu currently does not launch at login (toggle on)”* option will cause byobu to be executed any time a terminal is opened.  Changes made to byobu are on a per user basis, and will not affect other users on the system.
使用“Byobu 当前不会在登录时启动（打开）”选项将导致 byobu 在任何时候打开终端时执行。对 byobu 所做的更改是按用户进行的，不会影响系统上的其他用户。

One difference when using byobu is the *scrollback* mode. Press the *F7* key to enter scrollback mode. Scrollback mode allows you to navigate past output using *vi* like commands. Here is a quick list of movement commands:
使用 byobu 时的一个区别是回滚模式。按 F7 键进入回滚模式。回滚模式允许您使用类似 vi 的命令浏览过去的输出。以下是移动命令的快速列表：

- *h* - Move the cursor left by one character
  h - 将光标向左移动一个字符
- *j* - Move the cursor down by one line
  j - 将光标向下移动一行
- *k* - Move the cursor up by one line
  k - 将光标向上移动一行
- *l* - Move the cursor right by one character
  l - 将光标向右移动一个字符
- *0* - Move to the beginning of the current line
  0 - 移动到当前行的开头
- *$* - Move to the end of the current line
  $ - 移动到当前行的末尾
- *G* - Moves to the specified line (defaults to the end of the buffer)
  G - 移动到指定的行（默认为缓冲区的末尾）
- */* - Search forward / - 向前搜索
- *?* - Search backward ?- 向后搜索
- *n* - Moves to the next match, either forward or backward
  n - 向前或向后移动到下一场比赛

## Resources 资源

- For more information on screen see the [screen web site](http://www.gnu.org/software/screen/).
  有关屏幕的详细信息，请参阅屏幕网站。
- And the [Ubuntu Wiki screen](https://help.ubuntu.com/community/Screen) page.
  以及 Ubuntu Wiki 屏幕页面。
- Also, see the byobu [project page](https://launchpad.net/byobu) for more information.
  另外，有关详细信息，请参阅 byobu 项目页面。
