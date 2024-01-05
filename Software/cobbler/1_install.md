# 安装

[TOC]

## 安装前准备

### SELinux

在开始使用 Cobbler 之前，禁用 SELinux 或将其设置为 “permissive” 模式可能会很方便，特别是如果不熟悉 SELinux 故障排除或修改 SELinux 策略时。Cobbler constantly evolves to assist in managing new system technologies, and the policy that ships with your OS can sometimes lag behind the feature-set we provide, resulting in AVC denials that break Cobbler’s functionality.Cobbler 不断发展以帮助管理新的系统技术，操作系统附带的策略有时会落后于我们提供的功能集，导致 AVC 拒绝破坏 Cobbler 的功能。

### Firewall

配置防火墙，开启TCP：80 端口、TCP：25151 端口、UDP：69 端口

禁用firewalld

## 安装并启动相关服务

```bash
# 目前新系统，Fedora 37 、 CentOS 8 stream
# 配置epel源
dnf install epel-release
dnf module enable cobbler:3

# CentOS 7
yum -y install cobbler cobbler-web dhcp httpd debmirror pykickstart fence-agents xinetd tftp-server
# CentOS 8 stream
dnf install cobbler cobbler-web yum-utils fence-agents pykickstart debmirror syslinux dhcp-server tftp-server dnf-plugins-core

# CentOS 7
systemctl enable xinetd
systemctl start xinetd
systemctl enable dhcpd
systemctl start dhcpd
systemctl enable httpd
systemctl start httpd
systemctl enable cobblerd.service
systemctl start cobblerd.service
# CentOS 8 stream
systemctl enable --now dhcpd
systemctl enable --now httpd
systemctl enable --now tftp
systemctl enable --now cobblerd.service
```

Cobbler has both definite and optional prerequisites, based on the features you’d like to use. This section documents the definite prerequisites for both a basic installation and when building/installing from source.

## 2.1. Prerequisites

### 2.1.1. Packages

Please note that installing any of the packages here via a package manager (such as dnf/yum or apt) can and will require a large number of ancilary packages, which we do not document here. The package definition should automatically pull these packages in and install them along with Cobbler, however it is always best to verify these requirements have been met prior to installing cobbler or any of its components.

First and foremost, Cobbler requires Python. Any 2.x version should work for 2.8.x releases. Since 3.0.0 you will need Python 3. Cobbler also requires the installation of the following packages:

- createrepo
- httpd / apache2
- xorriso
- mod_wsgi / libapache2-mod-wsgi
- mod_ssl / libapache2-mod-ssl
- python-cheetah
- python-netaddr
- python-simplejson
- PyYAML / python-yaml
- rsync
- syslinux
- tftp-server / atftpd
- yum-utils

Cobbler-web only has one other requirement besides Cobbler itself:

- Django / python-django

Koan can be installed apart from Cobbler, and has only the following requirement (besides python itself of course):

- python-simplejson

### 2.1.2. Source

Installation from source requires the following additional software:

- git
- make
- python-devel
- python-cheetah
- openssl

## 2.2. Installation

Cobbler is available for installation for many Linux variants through their native packaging systems. However, the Cobbler project also provides packages for all supported distributions which is the preferred method of installation.

### 2.2.1. Packages

We leave packaging to downstream; this means you have to check the repositories provided by your distribution vendor. However we provide docker files for

- CentOS 7
- CentOS 8
- Debian 10 Buster

which will give you packages which will work better then building from source yourself.

### 2.2.2. Packages from source

For some platforms it’s also possible to build packages directly from the source tree.

## 2.3. RPM

```
$ make rpms
... (lots of output) ...
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.src.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/koan-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-web-3.0.0-1.fc20.noarch.rpm
```

As you can see, an RPM is output for each component of Cobbler, as well as a source RPM. This command was run on a system running Fedora 20, hence the fc20 in the RPM name - this will be different based on the distribution you’re running.

## 2.4. DEB

To install Cobbler from source on a Debian-Based system, the following steps need to be made (tested on Debian Buster):

```
$ apt-get -y install make git
$ apt-get -y install python3-yaml python3-cheetah python3-netaddr python3-simplejson
$ apt-get -y install python3-future python3-distro python3-setuptools python3-sphinx python3-coverage
$ apt-get -y install pyflakes3 python3-pycodestyle
$ apt-get -y install apache2 libapache2-mod-wsgi-py3
$ apt-get -y install atftpd
# In case you want cobbler-web
$ apt-get -y install python3-django

$ a2enmod proxy
$ a2enmod proxy_http
$ a2enmod rewrite

$ ln -s /srv/tftp /var/lib/tftpboot

$ systemctl restart apache2
```

Change all `/var/www/cobbler` in `/etc/apache2/conf.d/cobbler.conf` to `/usr/share/cobbler/webroot/` Init script: - add Required-Stop line - path needs to be `/usr/local/...` or fix the install location

### 2.4.1. Source

The latest source code is available through git:

```
$ git clone https://github.com/cobbler/cobbler.git
$ cd cobbler
```

The release30 branch corresponds to the official release version for the 3.0.x series. The master branch is the development series, and always uses an odd number for the minor version (for example, 3.1.0).

When building from source, make sure you have the correct prerequisites. Once they are, you can install Cobbler with the following command:

```
$ make install
```

This command will rewrite all configuration files on your system if you have an existing installation of Cobbler (whether it was installed via packages or from an older source tree). To preserve your existing configuration files, snippets and automatic installation files, run this command:

```
$ make devinstall
```

To install the Cobbler web GUI, use this command:

```
$ make webtest
```

This will do a full install, not just the web GUI. `make webtest` is a wrapper around `make devinstall`, so your configuration files will also be saved when running this command. Be adviced that we don’t copy the service file into the correct directory and that the path to the binary may be wrong depending on the location of the binary on your system. Do this manually and then you should be good to go. The same is valid for the Apache2 webserver config.

Also note that this is not enough to run Cobbler-Web. Cobbler web needs the directories `/usr/share/cobbler/web` with the file `cobbler.wsgi` in it. This is currently a manual step. Also remember to manually enter a value for `SECRET_KEY` in `settings.py` and copy that to above mentioned directory as well as the templates directory.



## 2.5. Relocating your installation

Often folks don’t have a very large `/var` partition, which is what Cobbler uses by default for mirroring install trees and the like.

You’ll notice you can reconfigure the webdir location just by going into `/etc/cobbler/settings`, but it’s not the best way to do things – especially as the packaging process does include some files and directories in the stock path. This means that, for upgrades and the like, you’ll be breaking things somewhat. Rather than attempting to reconfigure Cobbler, your Apache configuration, your file permissions, and your SELinux rules, the recommended course of action is very simple.

1. Copy everything you have already in `/var/www/cobbler` to another location – for instance, `/opt/cobbler_data`
2. Now just create a symlink or bind mount at `/var/www/cobbler` that points to `/opt/cobbler_data`.

Done. You’re up and running.

If you decided to access Cobbler’s data store over NFS (not recommended) you really want to mount NFS on `/var/www/cobbler` with SELinux context passed in as a parameter to mount versus the symlink. You may also have to deal with problems related to rootsquash. However if you are making a mirror of a Cobbler server for a multi-site setup, mounting read only is OK there.

Also Note: `/var/lib/cobbler` can not live on NFS, as this interferes with locking (“flock”) Cobbler does around it’s storage files.