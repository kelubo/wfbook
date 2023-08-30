# 安装

## 概述

Bareos 为许多 Linux 发行版预先打包。因此，最简单的方法来获得一个运行的 Bareos 安装，是使用一个平台，其中预包装的 Bareos 包可用。

如果 Bareos 作为一个软件包提供，只需要 4 个步骤就可以获得一个正在运行的 Bareos 系统：

1. 决定要使用的 Bareos 版本。
2. 安装 Bareos 软件包。
3. 准备 Bareos 数据库。
4. 启动守护进程。

这将启动一个非常基本的Bareos安装，它将定期将目录备份到磁盘。为了使其符合需要，必须调整配置，并且可能需要备份其他客户端。

## 配置 Bareos 软件库

验证存储库的公钥位于存储库目录中（基于 Debian 的发行版为 Release.key，基于 RPM 的发行版为 repodata/repomd.xml.key ）。

为了简化安装，https://download.bareos.org/ 和 https://download.bareos.com/ 上的所有 Linux 和 FreeBSD 存储库都包含一个名为 add_bareos_repositories.sh 的脚本。

下载与所请求的 Bareos 发行版和目标系统发行版相匹配的 add_bareos_repositories.sh 脚本。将脚本复制到目标系统上，并以 root 用户身份使用 shell（sh）执行该脚本（例如使用 sudo ）或手动执行脚本中记录的步骤。

```bash
# Debian 11
https://download.bareos.org/current/Debian_11/add_bareos_repositories.sh

# CentOS
http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo
http://download.bareos.org/bareos/release/latest/CentOS_8/bareos.repo
```

## 安装 PostgreSQL

Bareos Director 需要 PostgreSQL 数据库作为其目录。Bareos 数据库包仅依赖于数据库客户端包，因此数据库本身必须手动安装。

安装并启动 PostgreSQL 数据库服务器。

## 安装 Bareos

bareos 包只是一个 Meta 包，它包含了对 Bareos 主要组件的依赖，请参阅 Bareos 包。如果想设置一个分布式环境（比如一个 Bareos Director，单独的数据库服务器，多个 Bareos Storage Daemons），必须选择在每个主机上安装有关 Bareos 包，而不仅仅是安装 bareos 包。

### RHEL and derivatives, Fedora

Bareos *Version >= 15.2.0* 需要 Jansson 库包。在 RHEL 7 上，可通过 RHEL 服务器可选通道获得。

RHEL 存储库适用于Red Hat Enterprise Linux，EL 存储库适用于 RHEL 衍生产品，如 AlmaLinux、CentOS Stream、Oracle 和 Rocky Linux 。这些存储库会自动针对这些发行版进行测试。

从 https://download.bareos.com/bareos/release/ ，https://download.bareos.org/current/ 或 https://download.bareos.com/next/   下载匹配的`add_bareos_repositories.sh` 脚本，复制到目标系统并执行：

```bash
sh ./add_bareos_repositories.sh
yum install bareos
```

如果需要身份验证凭据（https://download.bareos.com），则将其存储在 repo 文件 `/etc/yum.repos.d/bareos.repo` 中。

**firewalld**

```bash
# 配置防火墙策略
firewall-cmd --permanent --add-port 9101-9103/tcp
firewall-cmd --permanent --add-service http
firewall-cmd --reload

# 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld
```

### SUSE Linux Enterprise Server (SLES), openSUSE

从 https://download.bareos.com/bareos/release/ ，https://download.bareos.org/current/ 或 https://download.bareos.com/next/   下载匹配的`add_bareos_repositories.sh` 脚本，复制到目标系统并执行：

```bash
sh ./add_bareos_repositories.sh
zypper install bareos
```

如果需要身份验证凭据（https://download.bareos.com），则将其存储在文件 `/etc/zypp/credentials.d/bareos` 中。

### Debian / Ubuntu / Univention Corporate Server (UCS)

从 https://download.bareos.com/bareos/release/ ，https://download.bareos.org/current/ 或 https://download.bareos.com/next/   下载匹配的`add_bareos_repositories.sh` 脚本，复制到目标系统并执行：

```bash
sh ./add_bareos_repositories.sh
apt update
apt install bareos
```

`add_bareos_repositories.sh` 脚本将：

- 创建一个 Bareos 签名密钥文件 `/etc/apt/keyrings/bareos-*.gpg` 。

- 创建 Bareos 存储库配置文件 `/etc/apt/sources.list.d/bareos.sources` 。

  > 此文件引用下载服务器上的 Bareos 存储库和本地 `/etc/apt/keyrings/bareos-*.gpg` 文件。

- 如果需要身份验证凭据（https://download.bareos.com），则将其存储在文件 `/etc/apt/auth.conf.d/download_bareos_com.conf` 中。

#### Univention Corporate Server

[Univention Corporate Server (UCS)](https://www.univention.de/) 是一个基于 Debian 的企业级 Linux 发行版。

早期版本（Bareos < 21，UCS < 5.0）提供了与 UCS 的扩展集成，并通过 Univation App Center 提供了软件。With version 5.0 of the UCS App Center the method of integration changed requiring commercially not reasonable efforts for deep integration.在 UCS App Center 5.0 版本中，集成方法发生了变化，需要商业上不合理的深度集成努力。

Bareos 继续支持 UCS，其功能与其他 Linux 发行版相同。

在构建过程中，Bareos Debian 10 软件包会在 UCS 5.0 系统上自动测试。只有通过此验收测试的软件包才会被 Bareos 项目发布。

> **注意事项：**
>
> 虽然 Bareos 提供了 UCS >= 5 的软件存储库，但该存储库与相应的 Debian 存储库相同。包含的 APT 源文件也将引用 Debian 存储库。

### FreeBSD based Distributions

从 https://download.bareos.com/bareos/release/ ，https://download.bareos.org/current/ 或 https://download.bareos.com/next/   下载匹配的`add_bareos_repositories.sh` 脚本，复制到目标系统并执行：

```bash
sh ./add_bareos_repositories.sh

# install Bareos packages
pkg install --yes bareos.com-director bareos.com-storage bareos.com-filedaemon bareos.com-database-postgresql bareos.com-bconsole
```

`add_bareos_repositories.sh` 脚本将：

- 创建 Bareos 存储库配置文件 `/usr/local/etc/pkg/repos/bareos.conf` 。
- 如果需要身份验证凭据（https://download.bareos.com），则将其存储在 Bareos 存储库配置文件中。

## 配置数据库

### Debian based Linux Distributions

自 Bareos Version >= 14.2.0 以来，基于 Debian（和 Ubuntu）的软件包支持 dbconfig-common 机制来创建和更新 Bareos 数据库。

在安装过程中按照说明进行操作，以根据您的需要进行配置。

 ![](../../../../Image/d/dbconfig-1-enable.png)

如果决定不使用 dbconfig-common（在初始对话框中选择 <No> ），请按照 [其他平台](#chapter) 的说明操作。

### 其他平台 {#chapter}

如果 PostgreSQL 管理用户是 postgres（默认），请使用以下命令：

```bash
su postgres -c /usr/lib/bareos/scripts/create_bareos_database
su postgres -c /usr/lib/bareos/scripts/make_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

## 启动服务

### Linux

```bash
systemctl enable --now bareos-dir
systemctl enable --now bareos-sd
systemctl enable --now bareos-fd
```

### FreeBSD

```bash
# enable services
sysrc bareosdir_enable=YES
sysrc bareossd_enable=YES
sysrc bareosfd_enable=YES
# start services
service bareos-dir start
service bareos-sd start
service bareos-fd start
```

## 安装 Bareos Client

安装 Bareos 客户端时，应该选择与 Bareos 服务器上相同的版本。

**bareos-client** 包是一个元包。安装它还将安装 **bareos-filedaemon**， **bareos-bconsole** 并建议安装 **bareos-traymonitor** 。

如果希望只安装备份客户端，则只安装 **bareos-filedaemon** 包就足够了。

### Linux Distributions

只需安装包 bareos-filedaemon 或 bareos-client （bareos-filedaemon，bareos-bconsole 和 bareos-traymonitor ）而不是元包 bareos 。

### Universal Linux Client

Bareos 项目为所有主要 Linux 发行版的当前版本提供了软件包。为了支持更多的平台，Bareos Version >= 21.0.0 提供了所谓的通用 Linux 客户端（ULC）。

通用 Linux 客户端是一个 Bareos 文件守护程序，以最小化对其他库的依赖的方式构建。

> 注意事项：
>
> 通用 Linux 客户端依赖于主机的 OpenSSL 库，以便利用此库的安全更新。

它包含了正常备份和恢复操作的所有功能，但它只有有限的插件支持。

目前它是作为 Debian 软件包提供的。然而，计划也以其他格式提供它。

ULC 有额外的存储库，它们的名称以 ULC_ 开头（例如 ULC_deb_OpenSSL_1.1 ），请访问 https://download.bareos.com/bareos/release/ 和 https://download.bareos.org/current/ 。根据打包标准和剩余的依赖项，将有不同的存储库。这些存储库包含 bareos-universal-client 包，有时还包含相应的 debug 包。您可以将存储库添加到系统中，也可以仅下载并安装软件包文件。

ULC 的目标之一是支持本机软件包尚未可用的新平台。一旦本地包可用，就可以添加它们的存储库，并且在更新时，ULC 包将被正常的 Bareos File Daemon 包无缝替换。无需更改 Bareos 配置。

>  警告：
>
> 虽然 ULC 包被设计为在尽可能多的 Linux 平台上运行，但它们只应该在 Bareos 项目不直接支持该平台的情况下使用。如果可用，应首选本机软件包。

功能概述：

* 单包安装。
* 基于存储库的安装。
* 对系统库的依赖性最小（OpenSSL 除外）。
* 使用主机 OpenSSL 库。
* 可由正常的 Bareos 文件守护程序替换。无需更改配置。

### FreeBSD

Installing the Bareos client is very similar to [Install on FreeBSD based Distributions](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-installbareospackagesfreebsd).

Get the `add_bareos_repositories.sh` matching the requested Bareos release and the distribution of the target system from https://download.bareos.org/ or https://download.bareos.com/ and execute it on the target system:

Shell example script for Bareos installation on FreeBSD[](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#id1)

```
sh ./add_bareos_repositories.sh
pkg install --yes bareos.com-filedaemon
# enable services
sysrc bareosfd_enable=YES
# start services
service bareos-fd start
```

### Oracle Solaris

The Bareos File Daemon is available as **IPS** (*Image Packaging System*) packages for **Oracle Solaris 11.4**.

First, download the Solaris package to the local disk and add the package as publisher **bareos**:

Add bareos publisher[](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#id2)

```
pkg set-publisher -p bareos-fd-<version>.p5p  bareos
pkg set-publisher:
  Added publisher(s): bareos
```

Then, install the filedaemon with **pkg install**:

Install solaris package[](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#id3)

```
pkg install bareos-fd
          Packages to install:  1
           Services to change:  1
      Create boot environment: No
Create backup boot environment: No

DOWNLOAD                                PKGS         FILES    XFER (MB)   SPEED
Completed                                1/1         44/44      1.0/1.0  4.8M/s

PHASE                                          ITEMS
Installing new actions                         94/94
Updating package state database                 Done
Updating package cache                           0/0
Updating image state                            Done
Creating fast lookup database                working |
```

After installation, check the bareos-fd service status with **svcs bareos-fd**:

Check solaris service[](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#id4)

```
svcs bareos-fd
STATE          STIME      FMRI
online         16:16:14   svc:/bareos-fd:default
```

Finish the installation by adapting the configuration in `/usr/local/etc/bareos` and restart the service with **svcadm restart bareos-fd**:

Restart solaris service[](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#id5)

```
svcadm restart bareos-fd
```

The Bareos File Daemon service on solaris is now ready for use.



### Mac OS X

Bareos for MacOS X is available either

- via the [Homebrew project](https://brew.sh/) (https://formulae.brew.sh/formula/bareos-client) or
- as pkg file from https://download.bareos.org/ or https://download.bareos.com/.

However, you have to choose upfront, which client you want to use. Otherwise conflicts do occur.

Both packages contain the Bareos File Daemon and **bconsole**.

#### Installing the Bareos Client as PKG

The Bareos installer package for Mac OS X contains the Bareos File Daemon for Mac OS X 10.5 or later.

On your local Mac, you must be an admin user. The main user is an admin user.

Download the `bareos-*.pkg` installer package from https://download.bareos.org/ or  or https://download.bareos.com/.

Find the .pkg you just downloaded. Install the .pkg by holding the CTRL key, left-clicking the installer and choosing “open”.

Follow the directions given to you and finish the installation.

#### Configuration

To make use of your Bareos File Daemon on your system, it is required to configure the Bareos Director and the local Bareos File Daemon.

Configure the server-side by follow the instructions at [Adding a Client](https://docs.bareos.org/IntroductionAndTutorial/Tutorial.html#section-addaclient).

After configuring the server-side you can either transfer the  necessary configuration file using following command or configure the  client locally.

##### Option 1: Copy the director resource from the Bareos Director to the Client

Assuming your client has the DNS entry **client2.example.com** and has been added to Bareos Director as [`client2-fd (Dir->Client)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Client_Name):

```
scp /etc/bareos/bareos-dir-export/client/client2-fd/bareos-fd.d/director/bareos-dir.conf root@client2.example.com:/usr/local/etc/bareos/bareos-fd.d/director/
```

This differs in so far, as on Linux the configuration files are located under `/etc/bareos/`, while on MacOS they are located at `/usr/local/etc/bareos/`.

##### Option 2: Edit the director resource on the Client

Alternatively, you can edit the file `/usr/local/etc/bareos/bareos-fd.d/director/bareos-dir.conf`.

This can be done by right-clicking the finder icon in your task bar, select “Go to folder …” and paste `/usr/local/etc/bareos/bareos-fd.d/director/`.

Select the `bareos-dir.conf` file and open it.

Alternatively you can also call following command on the command console:

```
open -t /usr/local/etc/bareos/bareos-fd.d/director/bareos-dir.conf
```

The file should look similar to this:

bareos-fd.d/director/bareos-dir.conf

```
Director {
  Name = bareos-dir
  Password = "SOME_RANDOM_PASSWORD"
  Description = "Allow the configured Director to access this file daemon."
}
```

Set this client-side password to the same value as given on the server-side.

Warning

The configuration file contains passwords and therefore must not be accessible for any users except admin users.

#### Restart bareos-fd after changing the configuration

The bareos-fd must be restarted to reread its configuration:

Restart the Bareos File Daemon

```
sudo launchctl stop  org.bareos.bareos-fd
sudo launchctl start org.bareos.bareos-fd
```

#### Verify that the Bareos File Daemon is working

Open the **bconsole** on your Bareos Director and check the status of the client with

```
*status client=client2-fd
```

In case, the client does not react, following command are useful the check the status:

Verify the status of Bareos File Daemon

```
check if bareos-fd is started by system:
sudo launchctl list org.bareos.bareos-fd
get process id (PID) of bareos-fd
pgrep bareos-fd
show files opened by bareos-fd
sudo lsof -p `pgrep bareos-fd`
check what process is listening on the |fd| port
sudo lsof -n -iTCP:9102 | grep LISTEN
```

You can also manually start bareos-fd in debug mode by:

Start Bareos File Daemon in debug mode

```
sudo /usr/local/sbin/bareos-fd -f -d 100
```

### Windows

See [Windows Installation](https://docs.bareos.org/TasksAndConcepts/TheWindowsVersionOfBareos.html#windows-installation).



################################ 

以下为历史内容，仅供参考。后期会进行删除。

################################

### RedHat based Linux Distributions

#### RHEL>7, CentOS>7, Fedora

Bareos *Version >= 15.2.0* requires the [Jansson library](https://docs.bareos.org/Appendix/SystemRequirements.html#jansson) package. On RHEL 7 it is available through the RHEL Server Optional  channel. On CentOS 7 and Fedora is it included in the main repository.

```bash
yum install bareos bareos-database-postgresql
```

#### RHEL 6, CentOS 6

Bareos *Version >= 15.2.0* requires the [Jansson library](https://docs.bareos.org/Appendix/SystemRequirements.html#jansson) package. This package is available on [EPEL](https://fedoraproject.org/wiki/EPEL) 6. Make sure, it is available on your system.

```bash
rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install bareos bareos-database-postgresql
```

### SUSE based Linux Distributions

#### SUSE Linux Enterprise Server (SLES), openSUSE

```bash
zypper addrepo --refresh $URL/bareos.repo
zypper install bareos bareos-database-postgresql
```

### Debian based Linux Distributions

#### Debian / Ubuntu

Bareos *Version >= 15.2.0* requires the [Jansson library](https://docs.bareos.org/Appendix/SystemRequirements.html#jansson) package. On Ubuntu is it available in Ubuntu Universe. In Debian, is it included in the main repository.

```bash
!/bin/sh
 See http://download.bareos.org/bareos/release/
 for applicable releases and distributions

DIST=Debian_10
 or
 DIST=Debian_9.0
 DIST=xUbuntu_18.04
 DIST=xUbuntu_16.04

RELEASE=release/19.2
 or
 RELEASE=release/latest
 RELEASE=experimental/nightly
DIST
 add the Bareos repository
printf "deb $URL /\n" > /etc/apt/sources.list.d/bareos.list
 add package key
wget -q $URL/Release.key -O- | apt-key add -
 install Bareos packages
apt-get update
apt-get install bareos bareos-database-postgresql
```

If you prefer using the versions of Bareos directly integrated into  the distributions, please note that there are some differences, see [Limitations of the Debian.org/Ubuntu Universe version of Bareos](https://docs.bareos.org/Appendix/OperatingSystems.html#section-debianorglimitations).

### FreeBSD based Distributions

```bash
!/bin/sh
 See http://download.bareos.org/bareos/release/
 for applicable releases and distributions

DIST=FreeBSD_12.1
 or
 DIST=FreeBSD_12.0
 DIST=FreeBSD_11.3

RELEASE=release/19.2/
 or
 RELEASE=release/latest/
 RELEASE=experimental/nightly/
DIST
 add the Bareos repository
cd /usr/local/etc/pkg/repos
wget -q $URL/bareos.conf
 install Bareos packages
pkg install --yes bareos.com-director bareos.com-storage bareos.com-filedaemon bareos.com-database-postgresql bareos.com-bconsole
 setup the Bareos database
su postgres -c /usr/lib/bareos/scripts/create_bareos_database
su postgres -c /usr/lib/bareos/scripts/make_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
 enable services
sysrc bareosdir_enable=YES
sysrc bareossd_enable=YES
sysrc bareosfd_enable=YES
 start services
service bareos-dir start
service bareos-sd start
service bareos-fd start
```

### Oracle Solaris

Bareos offers **IPS** (*Image Packaging System*) filedaemon Packages for **Oracle Solaris 11.4**.

First, download the Solaris package to the local disk and add the package as publisher **bareos**:

Add bareos publisher

```bash
 pkg set-publisher -p bareos-fd-<version>.p5p  bareos
pkg set-publisher:
  Added publisher(s): bareos
```

Then, install the filedaemon with **pkg install**:

Install solaris package

```bash
 pkg install bareos-fd
          Packages to install:  1
           Services to change:  1
      Create boot environment: No
Create backup boot environment: No

DOWNLOAD                                PKGS         FILES    XFER (MB)   SPEED
Completed                                1/1         44/44      1.0/1.0  4.8M/s

PHASE                                          ITEMS
Installing new actions                         94/94
Updating package state database                 Done
Updating package cache                           0/0
Updating image state                            Done
Creating fast lookup database                working |
```

After installation, check the bareos-fd service status with **svcs bareos-fd**:

Check solaris service

```bash
 svcs bareos-fd
STATE          STIME      FMRI
online         16:16:14   svc:/bareos-fd:default
```

Finish the installation by adapting the configuration in `/usr/local/etc/bareos` and restart the service with **svcadm restart bareos-fd**:

Restart solaris service

```bash
 svcadm restart bareos-fd
```

The bareos filedaemon service on solaris is now ready for use.
