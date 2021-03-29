## 安装

## 操作系统及数据库准备

Bareos comes prepackaged for a number of Linux distributions. So the  easiest way to get to a running Bareos installation, is to use a  platform where prepacked Bareos packages are available. Bareos是为许多Linux发行版预先打包的。因此，要安装运行中的Bareos，最简单的方法就是使用一个平台，在这个平台上可以使用预打包的Bareos包。

If Bareos is available as a package, only 4 steps are required to get to a running Bareos system:

1. [Decide about the Bareos release to use](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-addsoftwarerepository)
2. [Install the Bareos Software Packages](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-installbareospackages)
3. [Prepare Bareos database](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-createdatabase)
4. [Start the daemons](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-startdaemons)

This will start a very basic Bareos installation which will regularly backup a directory to disk. In order to fit it to your needs, you’ll  have to adapt the configuration and might want to backup other clients.


如果Bareos作为一个软件包提供，则只需4个步骤即可进入正在运行的Bareos系统：

决定要使用的Bareos版本

安装Bareos软件包

准备Bareos数据库

启动守护程序

这将启动一个非常基本的Bareos安装，定期将目录备份到磁盘。为了使它适合您的需要，您必须调整配置，并且可能需要备份其他客户机。

### CentOS

**Bareos软件仓库**

```bash
http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo
http://download.bareos.org/bareos/release/latest/CentOS_8/bareos.repo
```

**firewalld**

```bash
# 配置防火墙策略
firewall-cmd --permanent --add-port 9101-9103/tcp
firewall-cmd --permanent --add-service http
firewall-cmd --reload
firewall-cmd --list-all

# 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld
```

### Database Backend

支持如下 database backend:

- PostgreSQL

  This is the preferred default database backend. It is contained in package **bareos-database-postgresql**. If you need to think about which backend to use, this is your choice!这是首选的默认数据库后端。它包含在包bareos数据库postgresql中。如果您需要考虑使用哪个后端，这是您的选择！

- MariaDB/MySQL

  Deprecated since version 19.0.0. This backend is provided only for backwards compatibility with existing MariaDB/MySQL deployments. It is contained in package **bareos-database-mysql**. **This is not the right choice for a new deployment.**自版本19.0.0以来已弃用。

  此后端仅用于与现有Maria DB/My SQL部署向后兼容。它包含在包bareos数据库mysql中。这不是新部署的正确选择。

- SQLite

  Deprecated since version 20.0.0. This backend is for testing purposes only. It is contained in package **bareos-database-sqlite3**. 不能在生产环境中使用。自版本20.0.0以来已弃用。

  此后端仅用于测试目的。它包含在包bareos-database-sqlite3中。请勿在生产中使用。

The Bareos database packages have their dependencies only to the  database client packages, therefore the database itself must be  installed manually.Bareos数据库包只依赖于数据库客户机包，因此必须手动安装数据库本身。

If you do not explicitly choose a database backend, your operating  system installer will choose one for you. The default should be  PostgreSQL, but depending on your operating system and the already  installed packages, this may differ.Bareos数据库包只依赖于数据库客户机包，因此必须手动安装数据库本身。

## Starting the Database

If you are using PostgreSQL or MySQL/MariaDB as the Bareos database,  you should start it before you install Bareos. If you are using Sqlite  you need do nothing. Sqlite is automatically started by the Bareos  Director.

The package **bareos** is only a meta package which contains dependencies on the main components of Bareos。If you want to setup a distributed environment (like one Director,  separate database server, multiple Storage daemons) you have to choose  the regarding Bareos packages to install on each of the hosts instead of just installing the **bareos** package.bareos包只是一个元包，它包含对bareos主要组件的依赖关系，请参阅bareos包。如果要设置分布式环境（如一个控制器、单独的数据库服务器、多个存储守护进程），则必须选择要在每个主机上安装的Bareos包，而不是只安装Bareos包。

The following code snippets are shell scripts that can be used as  orientation how to download the package repositories and install bareos. The release version number for **bareos** and the corresponding Linux distribution have to be updated for your needs, respectively.下面的代码片段是shell脚本，可以作为如何下载包存储库和安装bareos的方向。必须根据您的需要分别更新bareos的发行版本号和相应的Linux发行版。



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

### Univention Corporate Server

**Univention**

Bareos offers additional functionality and integration into an  Univention Corporate Server environment. Please follow the instructions  in [Univention Corporate Server](https://docs.bareos.org/Appendix/OperatingSystems.html#section-univentioncorporateserver).

If you are not interested in this additional functionality, the commands described in [Install on Debian based Linux Distributions](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-installbareospackagesdebian) will also work for Univention Corporate Servers.

### Prepare Bareos database

#### Debian based Linux Distributions

Since Bareos *Version >= 14.2.0* the Debian (and Ubuntu) based packages support the **dbconfig-common** mechanism to create and update the Bareos database.

[![../_images/dbconfig-1-enable.png](https://docs.bareos.org/_images/dbconfig-1-enable.png)](https://docs.bareos.org/_images/dbconfig-1-enable.png)[![../_images/dbconfig-2-select-database-type.png](https://docs.bareos.org/_images/dbconfig-2-select-database-type.png)](https://docs.bareos.org/_images/dbconfig-2-select-database-type.png)

The selectable database backends depend on the **bareos-database-\*** packages installed.

#### 其他平台

如果使用 PostgreSQL ，并且 PostgreSQL administration user 是 **postgres** (default)。Setup Bareos catalog with PostgreSQL

```bash
su postgres -c /usr/lib/bareos/scripts/create_bareos_database
su postgres -c /usr/lib/bareos/scripts/make_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

### 启动服务

```bash
systemctl start bareos-dir
systemctl enable bareos-dir

systemctl start bareos-sd
systemctl enable bareos-sd

systemctl start bareos-fd
systemctl enable bareos-fd
```