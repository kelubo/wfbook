# Cobbler

[TOC]

## 概述

Cobbler 是一个配置（安装）和更新服务器。它支持通过 PXE（网络引导）、虚拟化（Xen、QEMU / KVM 或 VMware）进行部署，以及现有 Linux 系统的重新安装。后两个功能通过在远程系统上使用 “Koan” 来启用。更新服务器功能包括 yum 镜像以及将这些镜像与自动安装文件集成。Cobbler 有一个命令行界面、WebUI 和广泛的 Python 和 XML-RPC API ，用于与外部脚本和应用程序集成。

Cobbler 可能是一个有点复杂的系统，因为它被设计用于管理各种各样的技术，但它确实在安装后立即支持大量功能，几乎不需要定制。

支持众多的发行版：Red Hat、Fedora、CentOS、Debian、Ubuntu 和 SuSE。当添加一个操作系统（通常通过使用 ISO 文件）时，Cobbler 知道如何解压缩合适的文件并调整网络服务，以正确引导机器。

Cobbler 可使用 kickstart 模板。基于 Red Hat 或 Fedora 的系统使用 kickstart  文件来自动化安装流程。通过使用模板，就会拥有基本的 kickstart  模板，然后定义如何针对一种配置文件或机器配置而替换其中的变量。例如，一个模板可能包含两个变量 *$domain* 和 *$machine_name*。在 Cobbler 配置中，一个配置文件指定 `domain=mydomain.com`，并且每台使用该配置文件的机器在 *machine_name* 变量中指定其名称。该配置文件中的所有机器都使用相同的 kickstart 安装且针对 `domain=mydomain.com` 进行配置，但每台机器拥有其自己的机器名称。您仍然可以使用 kickstart 模板在不同的域中安装其他机器并使用不同的机器名称。

为了协助管理系统，Cobbler 可通过 *fence scripts* 连接到各种电源管理环境。Cobbler 支持  apc_snmp、bladecenter、bullpap、drac、ether_wake、ilo、integrity、ipmilan、ipmitool、lpar、rsa、virsh 和 wti。要重新安装一台机器，可运行 `reboot system foo` 命令，而且 Cobbler 会使用必要的凭据和信息来为您运行恰当的 fence scripts（比如机器插槽数）。

可使用一个配置管理系统 (CMS)。有两种选择：该工具内的一个内部系统，或者集成一个现有的外部 CMS，比如 Chef 或  Puppet。借助内部系统，您可以指定文件模板，这些模板会依据配置参数进行处理（与 kickstart  模板的处理方式一样），然后复制到您指定的位置。如果必须自动将配置文件部署到特定机器，那么此功能很有用。

使用 koan 客户端，Cobbler 可从客户端配置虚拟机并重新安装系统。

## 集成的服务

* PXE 服务支持
* DHCP 服务管理
* DNS 服务管理(可选 bind，dnsmasq )
* 电源管理
* Kickstart 服务支持
* YUM 仓库管理
* TFTP ( PXE 启动时需要)
* Apache (提供 Kickstart 的安装源，并提供定制化的 Kickstart 配置）

## 工作流程

 ![](../../Image/c/cobbler02.jpg)

1. Client裸机配置了从网络启动后，开机后会广播包请求DHCP服务器 （Cobbler server）发送其分配好的一个IP
2. DHCP服务器（Cobbler server）收到请求后发送responese，包括其ip地址
3. Client裸机拿到ip后再向Cobbler server发送请求OS引导文件的请求
4. Cobbler server告诉裸机OS引导文件的名字和TFTP server的ip和port
5. Client裸机通过上面告知的TFTP server地址通信，下载引导文件
6. Client裸机执行执行该引导文件，确定加载信息，选择要安装的OS， 期间会再向cobbler server请求kickstart文件和OS image
7. Cobbler server发送请求的kickstart和OS iamge
8. Client裸机加载kickstart文件
9. Client裸机接收os image，安装该OS image

## 组件

Cobbler 的配置结构基于一组注册的对象。每个对象表示一个与另一个实体相关联的实体（该对象指向另一个对象，或者另一个对象指向该对象）。当一个对象指向另一个对象时，它就继承了被指向对象的数据，并可覆盖或添加更多特定信息。

* repository                 提供安装树，可指mirror与import。保存了一个yum或者rsync存储库的镜像信息。

* distribution               用来指明安装哪个系统。

* 配置文件(profile)      用来组合repository与distrioution还能用来自定义安装环境与位置。包含了一个发行版（distro），一个

  ​                                    kickstart文件以及可能的存储库（repository），还包含了更多的内核参数等其他数据。

* 发行版(distro）        表示一个操作系统，它承载了内核和`initrd`的信息，以及内核等其他数据。

* 系统(system)             表示要配给的机器，它包含了一个配置文件或一个镜像，还包含了ip和mac地址，电源管理（地址、凭据、类

  ​                                    型）以及更为专业的数据信息。

* 镜像(image)               可替换一个包含不属于此类别的文件的发行版对象（无法分为内核和initrd的对象）。

以上各个组件中， 发行版，存储库， 配置文件为必须配置项，只有在虚拟环境中，必须要用cobbler来引导虚拟机启动时候，才会用到系统组件。

![](../../Image/c/cobbler01.jpg)

## 简单配置

### 相关目录及文件

```bash
# 配置文件
/etc/cobbler
/etc/cobbler/settings               # cobbler主配置文件，这个文件是YAML格式
/etc/cobbler/settings.yaml          # 新版本，上述文件名称变更
/etc/cobbler/iso/                   # iso模板配置文件
/etc/cobbler/pxe                    # pxe模板文件
/etc/cobbler/power                  # 电源配置文件
/etc/cobbler/user.conf              # web服务授权配置文件
/etc/cobbler/users.digest           # web访问的用户名密码配置文件
/etc/cobbler/dhcp.template          # dhcp服务器的的配置模板
/etc/cobbler/dnsmasq.template       # dns服务器的配置模板
/etc/cobbler/tftpd.template         # tftp服务的配置模板
/etc/cobbler/rsync.template         # rsync服务的配置模板
/etc/cobbler/modules.conf           # 模块的配置文件

# 数据目录
/var/lib/cobbler/config/            # 用于存放distros，system，profiles等信息配置文件
/var/lib/cobbler/triggers/          # 用于存放用户定义的cobbler命令
/var/lib/cobbler/kickstart/         # 默认存放kickstart文件
/var/lib/cobbler/loaders/           # 存放各种引导程序镜像目录

# 镜像目录
/var/www/cobbler/ks_mirror/         # 导入的发行版系统的所有数据
/var/www/cobbler/images/            # 导入发行版的kernel和initrd镜像用于远程网络启动
/var/www/cobbler/repo_mirror/       # yum仓库存储目录

# 日志目录
/var/log/cobbler/installing         # 客户端安装日志
/var/log/cobbler/cobbler.log        # cobbler日志

```

### 修改默认密码

此设置控制 handsoff 安装期间为新系统设置的 root 密码。

```yaml
default_password_crypted: "$1$bfI7WLZz$PxXetL97LkScqJFxnW7KS1"
```

应该通过运行以下命令并将其输出插入到上面的字符串中来修改它（确保保留引号）：

```bash
openssl passwd -1
```

### server 和 next_server

`server` 选项设置用于 Cobbler 服务的 IP 。不能使用 0.0.0.0 ，因为它不是监听地址。这应该设置为希望正在构建的主机与 Cobbler 服务器联系以使用 HTTP 和 TFTP 等协议的 IP 。

```bash
# default, localhost
server: 127.0.0.1
```

`next_server` 选项用于 DHCP / PXE，作为下载网络引导文件的 TFTP 服务器的 IP 。通常，这将与 `server` 设置相同的 IP 。

```bash
# default, localhost
next_server: 127.0.0.1
```

### DHCP 管理和 DHCP 服务器模板

The choice of DHCP management engine is in `/etc/cobbler/modules.conf`

为了进行 PXE 引导，需要一个 DHCP 服务器来分发地址并将引导系统定向到 TFTP 服务器，在那里它可以下载网络引导文件。Cobbler 可以通过 `manage_dhcp` 设置进行管理：

```bash
#方法1：编辑/etc/cobbler/settings
# default 0, don't manage
manage_dhcp: 1

#方法2：
cobbler setting edit --name=manage_dhcp --value=1
```

将该设置更改为 1，以便 Cobbler 将根据随 Cobbler 提供的 `dhcp.template` 生成 `dhcpd.conf` 文件。此模板可能需要根据网络设置进行修改：

```bash
vi /etc/cobbler/dhcp.template
```

在大多数情况下，只需要修改此块：

```ini
subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.1;
     option domain-name-servers 192.168.1.5,192.168.1.6;
     option subnet-mask         255.255.255.0;
     filename                   "/pxelinux.0";
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server_v4;
}
```

无论如何，请确保不要修改 `next-server $next_server_v4;` 行，因为这是下一个服务器设置被拉入配置的方式。此文件是一个 cheetah 模板，因此请确保不要修改此行之后的任何内容：

```bash
#for dhcp_tag in $dhcp_tags.keys():
```

确认运行情况

```bash
netstat -tulp | grep dhcp
```

### 关于文件和目录的说明

Cobbler 大量使用 `/var` 目录。`/var/www/cobbler/distro_mirror` 目录是复制所有发行版和存储库文件的地方，因此需要为每个希望导入的发行版提供 5 - 10 GB 的可用空间。

### 配置文件

#### /etc/cobbler/modules.conf

```bash
# cobbler module configuration file
# =================================

# authentication: 
# what users can log into the WebUI and Read-Write XMLRPC?
# choices:
#    authn_denyall    -- no one (default)
#    authn_configfile -- use /etc/cobbler/users.digest (for basic setups)
#    authn_passthru   -- ask Apache to handle it (used for kerberos)
#    authn_ldap       -- authenticate against LDAP
#    authn_spacewalk  -- ask Spacewalk/Satellite (experimental)
#    authn_pam        -- use PAM facilities
#    authn_testing    -- username/password is always testing/testing (debug)
#    (user supplied)  -- you may write your own module
# WARNING: this is a security setting, do not choose an option blindly.
# for more information:
# https://github.com/cobbler/cobbler/wiki/Cobbler-web-interface
# https://github.com/cobbler/cobbler/wiki/Security-overview
# https://github.com/cobbler/cobbler/wiki/Kerberos
# https://github.com/cobbler/cobbler/wiki/Ldap

[authentication]
module = authn_configfile

# authorization: 
# once a user has been cleared by the WebUI/XMLRPC, what can they do?
# choices:
#    authz_allowall   -- full access for all authneticated users (default)
#    authz_ownership  -- use users.conf, but add object ownership semantics
#    (user supplied)  -- you may write your own module
# WARNING: this is a security setting, do not choose an option blindly.
# If you want to further restrict cobbler with ACLs for various groups,
# pick authz_ownership.  authz_allowall does not support ACLs.  configfile
# does but does not support object ownership which is useful as an additional
# layer of control.

# for more information:
# https://github.com/cobbler/cobbler/wiki/Cobbler-web-interface
# https://github.com/cobbler/cobbler/wiki/Security-overview
# https://github.com/cobbler/cobbler/wiki/Web-authorization

[authorization]
module = authz_allowall

# dns:
# chooses the DNS management engine if manage_dns is enabled
# in /etc/cobbler/settings, which is off by default.
# choices:
#    manage_bind    -- default, uses BIND/named
#    manage_dnsmasq -- uses dnsmasq, also must select dnsmasq for dhcp below
# NOTE: more configuration is still required in /etc/cobbler
# for more information:
# https://github.com/cobbler/cobbler/wiki/Dns-management

[dns]
module = manage_bind

# dhcp:
# chooses the DHCP management engine if manage_dhcp is enabled
# in /etc/cobbler/settings, which is off by default.
# choices:
#    manage_isc     -- default, uses ISC dhcpd
#    manage_dnsmasq -- uses dnsmasq, also must select dnsmasq for dns above
# NOTE: more configuration is still required in /etc/cobbler
# for more information:
# https://github.com/cobbler/cobbler/wiki/Dhcp-management
  
[dhcp]
module = manage_isc

# tftpd:
# chooses the TFTP management engine if manage_tftp is enabled
# in /etc/cobbler/settings, which is ON by default.
#
# choices:
#    manage_in_tftpd -- default, uses the system's tftp server
#    manage_tftpd_py -- uses cobbler's tftp server
#
  
[tftpd]
module = manage_in_tftpd

#--------------------------------------------------

```

#### /etc/cobbler/dhcp.template

```bash
# ******************************************************************
# Cobbler managed dhcpd.conf file
#
# generated from cobbler dhcp.conf template ($date)
# Do NOT make changes to /etc/dhcpd.conf. Instead, make your changes
# in /etc/cobbler/dhcp.template, as /etc/dhcpd.conf will be
# overwritten.
#
# ******************************************************************

ddns-update-style interim;

allow booting;
allow bootp;

ignore client-updates;
set vendorclass = option vendor-class-identifier;

option pxe-system-type code 93 = unsigned integer 16;

subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.5;
     option domain-name-servers 192.168.1.1;
     option subnet-mask         255.255.255.0;
     range dynamic-bootp        192.168.1.100 192.168.1.254;
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server;
     class "pxeclients" {
          match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
          if option pxe-system-type = 00:02 {
                  filename "ia64/elilo.efi";
          } else if option pxe-system-type = 00:06 {
                  filename "grub/grub-x86.efi";
          } else if option pxe-system-type = 00:07 {
                  filename "grub/grub-x86_64.efi";
          } else if option pxe-system-type = 00:09 {
                  filename "grub/grub-x86_64.efi";
          } else {
                  filename "pxelinux.0";
          }
     }

}

#for dhcp_tag in $dhcp_tags.keys():
    ## group could be subnet if your dhcp tags line up with your subnets
    ## or really any valid dhcpd.conf construct ... if you only use the
    ## default dhcp tag in cobbler, the group block can be deleted for a
    ## flat configuration
# group for Cobbler DHCP tag: $dhcp_tag
group {
        #for mac in $dhcp_tags[$dhcp_tag].keys():
            #set iface = $dhcp_tags[$dhcp_tag][$mac]
    host $iface.name {
        #if $iface.interface_type == "infiniband":
        option dhcp-client-identifier = $mac;
        #else
        hardware ethernet $mac;
        #end if
        #if $iface.ip_address:
        fixed-address $iface.ip_address;
        #end if
        #if $iface.hostname:
        option host-name "$iface.hostname";
        #end if
        #if $iface.netmask:
        option subnet-mask $iface.netmask;
        #end if
        #if $iface.gateway:
        option routers $iface.gateway;
        #end if
        #if $iface.enable_gpxe:
        if exists user-class and option user-class = "gPXE" {
            filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
        } else if exists user-class and option user-class = "iPXE" {
            filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
        } else {
            filename "undionly.kpxe";
        }
        #else
        filename "$iface.filename";
        #end if
        ## Cobbler defaults to $next_server, but some users
        ## may like to use $iface.system.server for proxied setups
        next-server $next_server;
        ## next-server $iface.next_server;
    }
        #end for
}
#end for
```

## 检查问题并首次 Sync

Cobbler 的 check 命令将提供一些建议，但重要的是要记住，这些主要只是建议，可能对基本功能并不重要。如果正在运行 iptables 或 SELinux ，那么查看与该检查可能报告的内容有关的任何消息是很重要的。

```bash
cobbler check
The following are potential configuration items that you may want to fix:

1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or automatic features will not work. This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.
2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
3 : change 'disable' to 'no' in /etc/xinetd.d/tftp
4 : Some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely. Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
5 : enable and start rsyncd.service with systemctl
6 : debmirror package is not installed, it will be required to manage debian deployments and repositories
7 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
8 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them
9 : reposync is not installed, install yum-utils or dnf-plugins-core
10 : yumdownloader is not installed, install yum-utils or dnf-plugins-core
11 : ksvalidator was not found, install pykickstart
12 : comment out 'dists' on /etc/debmirror.conf for proper debian support
13 : comment out 'arches' on /etc/debmirror.conf for proper debian support

Restart cobblerd and then run 'cobbler sync' to apply changes.
```

**处理方式:**

设置为可以动态配置，也可以直接更改配置文件。

```bash
# 设置可以动态修改配置文件
# 新版本内该命令可能会出现异常。1 改为 true
# 新版本配置文件为 settings.yaml
sed -ri '/allow_dynamic_settings:/c\allow_dynamic_settings: 1' /etc/cobbler/settings.yaml

grep allow_dynamic_settings /etc/cobbler/settings.yaml
allow_dynamic_settings: 1

systemctl restart cobblerd
```

```bash
1 : 修改 /etc/cobbler/settings.yaml 中 server 为本机 IP
    cobbler setting edit --name=server --value=192.168.1.6
2 : 修改 /etc/cobbler/settings.yaml 中 next_server 为本机 IP
    cobbler setting edit --name=next_server --value=192.168.1.6
3 : sed -ri '/disable/c\disable = no' /etc/xinetd.d/tftp
    systemctl enable xinetd
    systemctl restart xinetd
4 : cobbler get-loaders #可能因网络问题失败，多次尝试
    #该命令在新版本(2.8.5以上)中被取消
    #dnf install syslinux
    #cp /usr/share/syslinux/pxelinux.0 /var/lib/cobbler/loaders/
    #cp /usr/share/syslinux/menu.c32 /var/lib/cobbler/loaders/
    
    bash /usr/share/cobbler/bin/mkgrub.sh
    
5 : systemctl start rsyncd
    systemctl enable rsyncd
6 : yum install debmirror
7 : openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'
    修改 /etc/cobbler/settings 中 default_password_crypted 的值替换为上方命令的输出结果
    示例：
    openssl passwd -1 -salt `openssl rand -hex 4` 'admin'
          $1$675f1d08$oJoAMVxdbdKHjQXbGqNTX0
    cobbler setting edit --name=default_password_crypted --value='$1$675f1d08$oJoAMVxdbdKHjQXbGqNTX0'

8 : dnf install fence-agents 
9 - 10 : dnf install yum-utils
11 : dnf install pykickstart
12 - 13 : dnf install debmirror
          sed -i 's/@dists="sid";/#@dists="sid";/' /etc/debmirror.conf
          sed -i 's/@arches="i386";/#@arches="i386";/' /etc/debmirror.conf
```

重新启动 cobblerd，然后运行 `cobbler sync` 以应用更改。

```bash
cobbler sync

task started: 2012-06-24_224243_sync
task started (id=Sync, time=Sun Jun 24 22:42:43 2012)
running pre-sync triggers
...
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
cleaning link caches
running: find /var/lib/tftpboot/images/.link_cache -maxdepth 1 -type f -links 1 -exec rm -f '{}' ';'
received on stdout:
received on stderr:
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout:
received on stderr:
running: service dhcpd restart
received on stdout:
received on stderr:
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
```

这时候创建一个新虚拟机可以获取到如下信息，没有镜像选择，只能从本地启动。

 ![](../../Image/c/cobbler03.jpg)

## 导入发行版

Cobbler 通过 `cobbler import` 命令自动添加发行版和配置文件。此命令可以（通常）自动检测您导入的发行版的类型和版本，并使用正确的设置创建（一个或多个）配置文件。

### 挂载ISO

必须使用 full DVD ，而非 Live CD ISO。

```bash
mount -t iso9660 -o loop,ro /path/to/isos/Fedora-Server-dvd-x86_64-28-1.1.iso /mnt
```

当通过 systemd 运行 Cobbler 时，不能将 ISO 挂载到 `/tmp` 或它的子文件夹，因为我们正在使用选项 Private Temporary Directory 来增强应用程序的安全性。

### 进行导入

name 和 path 参数是导入所必需的选项：

```bash
cobbler import --name=fedora28 --arch=x86_64 --path=/mnt

# --path 镜像路径
# --name 为安装源定义一个名字
# --arch 指定安装源是32位、64位、ia64, 目前支持的选项有: x86│x86_64│ia64
# 安装源的唯一标示就是根据name参数来定义
```

不需要指定 --arch 选项，因为它通常会被自动检测到。在这个例子中这样做，是为了防止发现多个架构(Fedora ships i386 packages on the full DVD, and cobbler will create both x86_64 and i386 distros by default)。

### 列出对象

如果在导入过程中没有报告错误，可以查看导入过程中创建的发行版和配置文件的详细信息。

```bash
cobbler distro list
cobbler profile list
```

import 命令通常会创建至少一个发行版 / 配置文件对，它们的名称与上面所示的相同。在某些情况下（例如，当发现基于 Xen 的内核时），将创建多个发行版 / 配置文件对。

### 对象详细信息

report 命令显示 Cobbler 中对象的详细信息：

```bash
cobbler distro report --name=fedora28-x86_64

Name                           : fedora28-x86_64
Architecture                   : x86_64
TFTP Boot Files                : {}
Breed                          : redhat
Comment                        :
Fetchable Files                : {}
Initrd                         : /var/www/cobbler/ks_mirror/fedora28-x86_64/images/pxeboot/initrd.img
Kernel                         : /var/www/cobbler/ks_mirror/fedora28-x86_64/images/pxeboot/vmlinuz
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart Metadata             : {'tree': 'http://@@http_server@@/cblr/links/fedora28-x86_64'}
Management Classes             : []
OS Version                     : fedora28
Owners                         : ['admin']
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Template Files                 : {}

cobbler profile report --name=fedora28-x86_64

Name                           : fedora28-x86_64
TFTP Boot Files                : {}
Comment                        : 
DHCP Tag                       : default
Distribution                   : fedora28-x86_64
Enable gPXE?                   : 0
Enable PXE Menu?               : 1
Fetchable Files                : {}
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : /var/lib/cobbler/kickstarts/sample_end.ks
Kickstart Metadata             : {}
Management Classes             : []
Management Parameters          : <<inherit>>
Name Servers                   : []
Name Servers Search Path       : []
Owners                         : ['admin']
Parent Profile                 : 
Internal proxy                 : 
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos                          : []
Server Override                : <<inherit>>
Template Files                 : {}
Virt Auto Boot                 : 1
Virt Bridge                    : xenbr0
Virt CPUs                      : 1
Virt Disk Driver Type          : raw
Virt File Size(GB)             : 5
Virt Path                      : 
Virt RAM (MB)                  : 512
Virt Type                      : kvm
```

正如在上面看到的，import 命令自动填写了很多字段，比如品种 breed 、操作系统版本和 initrd / kernel 文件位置。The “Kickstart Metadata” field (–ksmeta internally) is used for miscellaneous variables, and contains the critical “tree” variable. “ Kickstart Metadata ”字段（内部为 `--autoinstall_meta` ）用于杂项变量，并包含关键的 tree 变量。这在 kickstart 模板中用于指定可以找到安装文件的 URL 。

还有一点需要注意：有些字段设置为 `<<inherit>>` 。This means they will use either the default setting (found in the settings file), or (in the case of profiles, sub-profiles, and systems) will use whatever is set in the parent object.这意味着它们将使用默认设置（在设置文件中找到），或者（在配置文件、子配置文件和系统的情况下）将使用父对象中设置的任何设置。

### 创建系统

现在有了一个发行版和配置文件，可以创建一个系统了。配置文件可用于 PXE 引导，but most of the features in cobbler revolve around system objects. 但 Cobbler 中的大多数特性都围绕着系统对象。给予的关于系统的信息越多，Cobbler 自动做的就越多。

首先，将根据导入过程中创建的配置文件创建一个系统对象。在创建系统时，name 和 profile 是两个必填字段：

```bash
cobbler system add --name=test --profile=fedora28-x86_64

cobbler system list
test

cobbler system report --name=test
Name                           : test
TFTP Boot Files                : {}
Comment                        :
Enable gPXE?                   : 0
Fetchable Files                : {}
Gateway                        :
Hostname                       :
Image                          :
IPv6 Autoconfiguration         : False
IPv6 Default Device            :
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : <<inherit>>
Kickstart Metadata             : {}
LDAP Enabled                   : False
LDAP Management Type           : authconfig
Management Classes             : []
Management Parameters          : <<inherit>>
Monit Enabled                  : False
Name Servers                   : []
Name Servers Search Path       : []
Netboot Enabled                : True
Owners                         : ['admin']
Power Management Address       :
Power Management ID            :
Power Management Password      :
Power Management Type          : ipmitool
Power Management Username      :
Profile                        : fedora28-x86_64
Proxy                          : <<inherit>>
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos Enabled                  : False
Server Override                : <<inherit>>
Status                         : production
Template Files                 : {}
Virt Auto Boot                 : <<inherit>>
Virt CPUs                      : <<inherit>>
Virt Disk Driver Type          : <<inherit>>
Virt File Size(GB)             : <<inherit>>
Virt Path                      : <<inherit>>
Virt RAM (MB)                  : <<inherit>>
Virt Type                      : <<inherit>>
```

创建系统对象的主要原因是网络配置。当使用配置文件时，您仅限于 DHCP 接口，但对于系统，可以指定更多的网络配置选项。

现在，将在 `192.168.1/24` 网络中设置一个简单的接口：

```bash
cobbler system edit --name=test --interface=eth0 --mac=00:11:22:AA:BB:CC --ip-address=192.168.1.100 --netmask=255.255.255.0 --static=1 --dns-name=test.mydomain.com
```

默认网关不是按 NIC 指定的，所以只需单独添加（along with the hostname沿着主机名）：

```bash
cobbler system edit --name=test --gateway=192.168.1.1 --hostname=test.mydomain.com
```

`--hostname` 字段对应于本地系统名，由 `hostname` 命令返回。The `--dns-name` (which can be set per-NIC) should correspond to a DNS A-record tied to the IP of that interface. `--dns-name`（可以按 NIC 设置）应该对应于与该接口的 IP 绑定的 DNS A 记录。两者都不是必需的，但最好同时指定两者。一些高级功能（如配置管理）依赖于 `--dns-name` 字段来查找系统记录。

每当系统被编辑时，Cobbler 都会执行所谓的 “lite sync” ，这会重新生成 TFTP 根目录中的关键文件，如 PXE 引导文件。它不会执行服务管理操作，比如重新生成 dhcpd.conf 和重新启动 DHCP 服务。在添加了一个带有静态接口的系统之后，最好执行一个完整的 cobbler sync ，ensure the dhcpd.conf file is rewritten with the correct static lease and the service is bounced.以确保 dhcpd.conf 文件被正确的静态租约重写，并且服务被退回。



```bash
[root@lizihan ~]# cobbler validateks        //查看语法是否有错误
task started: 2018-10-29_180600_validateks

task started (id=Kickstart Validation, time=Mon Oct 29 18:06:00 2018)
----------------------------

osversion: rhel7
checking url: http://172.16.11.17/cblr/svc/op/ks/profile/rhel-7-x86_64
running: /usr/bin/ksvalidator -v "rhel7" "http://172.16.11.17/cblr/svc/op/ks/profile/rhel-7-x86_64"
received on stdout: 
received on stderr: 
*** all kickstarts seem to be ok ***
*** TASK COMPLETE ***
```

## Cobblerd

cobbler - 配置和更新服务器

在这里将 cobblerd 称为 “cobbler” ，因为 cobblerd 是 cobbler-daemon 的缩写，它基本上是服务器。CLI 将被称为 Cobbler-CLI ，Koan 将被称为 Koan 。

Cobbler manages provisioning using a tiered concept of Distributions, Profiles, Systems, and (optionally) Images and Repositories.

Cobbler 使用分发、配置文件、系统以及（可选）镜像和存储库的分层概念来管理配置。

Distributions contain information about what kernel and initrd are used, plus metadata (required kernel parameters, etc).

发行版包含有关使用的内核和initrd的信息，以及元数据（必需的内核参数等）。

Profiles associate a Distribution with an automated installation template file and optionally customize the metadata further.

配置文件将分发与自动安装模板文件相关联，并可选择进一步自定义元数据。

Systems associate a MAC, IP, and other networking details with a profile and optionally customize the metadata further.

系统将 MAC、IP 和其他网络细节与配置文件相关联，并且可选地进一步定制元数据。

Using cobbler to mirror repositories is an optional feature, though provisioning and package management share a lot in common.

存储库包含 yum 镜像信息。使用cobbler来镜像仓库是一个可选的特性，尽管供应和包管理有很多共同之处。

Images are a catch-all concept for things that do not play nicely in the “distribution” category.  Most users will not need these records initially and these are described later in the document.

图像是一个包罗万象的概念，用于那些在“分发”类别中不起作用的东西。大多数用户最初并不需要这些记录，这些将在本文档后面进行描述。

The main advantage of cobbler is that it glues together many disjoint technologies and concepts and abstracts the user from the need to understand them. It allows the systems administrator to concentrate on what he needs to do, and not how it is done.

cobbler的主要优点是它将许多不相关的技术和概念粘合在一起，并将用户从理解它们的需求中抽象出来。它允许系统管理员专注于他需要做什么，而不是如何完成。

### 设置

安装后，运行 `cobbler check` 以验证 cobbler 的生态系统是否配置正确。Cobbler check 将指导您如何使用文本编辑器修改它的配置文件。

检测到的任何问题都应该得到纠正，但 DHCP 相关警告可能除外，需要判断这些警告是否适用于您的环境。在对配置文件进行任何更改后运行 `cobbler sync` ，以确保这些更改应用于环境。

It is especially important that the server name field be accurate in `/etc/cobbler/settings`, without this field being correct, automatic installation trees will not be found, and automated installations will fail.

在/etc/cobbler/settings.yaml中，服务器名称字段的准确性尤其重要，如果该字段不正确，自动安装树将无法找到，自动安装将失败。

对于 PXE ，如果要从 cobbler 服务器运行 DHCP ，则应按照 `cobbler check` 的建议更改 DHCP 配置文件。如果 DHCP 不在本地运行，DHCP 服务器上的 `next-server` 字段至少应该指向 cobbler 服务器的 IP ，并且文件名应该设置为 `pxelinux.0` 。或者，如果想在本地运行 DHCP，cobbler 也可以生成 DHCP 配置文件。如果还没有通过其他工具管理 DHCP 设置，允许 cobbler 管理 DHCP 环境将被证明是有用的，as it can manage DHCP reservations and other data因为它可以管理 DHCP 保留和其他数据。如果已经有一个 DHCP 设置，moving an existing setup to be managed from within cobbler is relatively painless移动一个现有的设置来管理从cobbler是相对无痛的-虽然使用 DHCP 管理功能是完全可选的。如果对通过 PXE 进行网络引导不感兴趣，而只是想使用 Koan 安装虚拟系统或替换现有系统，则可以完全忽略 DHCP 配置。Koan 还有一个 liveCD 功能，可用于模拟 PXE环境。

### 自动安装 (Autoyast / Kickstart)

要获得构建 kickstart 的帮助，请尝试使用 `system-config-kickstart` 工具，或者安装一个新系统并查看安装程序遗留的 `/root/anaconda-ks.cfg` 文件。Cobbler 在 /etc/cobbler 中提供了一些自动安装模板，这些模板也可能很有用。

有关 AutoYaST 指南和帮助，请参阅 opensuse 项目。

### 选项

- -B  –daemonize

  如果没有传递任何选项，这是默认选项。Cobbler-Server 在后台运行。

- -F   –no-daemonize

  Cobbler-Server 在前台运行。

- -f   –log-file

  Choose a destination for the logfile (currently has no effect).为日志文件选择一个目标（当前无效）。

- -l   –log-level

  为应用程序选择一个日志级别（当前无效）。

- –c  –config

  Cobbler 配置文件的位置。

- --disable-automigration

  do no execute automigration from older settings filles to the most recent.如果给定，则不执行从旧设置填充到最新设置填充的自动迁移。



# 6.1. Web-Interface

Please be patient until we have time to rework this section or please file a PR for this section.

The standard login for the WebUI can be read below. We would recommend to change this as soon as possible!

Username: `cobbler` Password: `cobbler`

## 6.1.1. Old Release 2.8.x

https://cobbler.readthedocs.io/en/release28/web-interface.html

## 6.1.2. Old GitHub-Wiki Entry

Most of the day-to-day actions in cobbler’s command line can be performed in Cobbler’s Web UI.

With the web user interface (WebUI), you can:

> - View all of the cobbler objects and the settings
> - Add and delete a system, distro, profile, or system
> - Run the equivalent of a `cobbler sync`
> - Edit kickstart files (which must be in `/etc/cobbler` and `/var/lib/cobbler/kickstarts`)

You cannot (yet):

> - Auto-Import media
> - Auto-Import a rsync mirror of install trees
> - Do a `cobbler reposync` to mirror or update yum content
> - Do a `cobbler validateks`

The WebUI can be very good for day-to-day configuring activities, but the CLI is still required for basic bootstrapping and certain other activities.

The WebUI is intended to be self-explanatory and contains tips and explanations for nearly every field you can edit. It also contains links to additional documentation, including the Cobbler manpage documentation in HTML format.

Who logs in and what they can access is controlled by [Web Authentication](Web Authentication) and [Web Authorization](Web Authorization). The default options are mostly good for getting started, but for safety reasons the default authentication is “denyall” so you will at least need to address that.

### 6.1.2.1. Basic Setup

1. You must have installed the cobbler-web package
2. Your `/etc/httpd/conf.d/cobbler_web.conf` should look something like this:

```
# This configuration file enables the cobbler web interface (django version)
# Force everything to go to https
RewriteEngine on
RewriteCond %{HTTPS} off
RewriteCond %{REQUEST_URI} ^/cobbler_web
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}

WSGIScriptAlias /cobbler_web /usr/share/cobbler/web/cobbler.wsgi

# The following Directory Entry in Apache Configs solves 403 Forbidden errors.
<Directory "/usr/share/cobbler/web">
  Order allow,deny
  Allow from all
</Directory>

# Display Cobbler Themes + Logo graphics.
<Directory "/var/www/cobbler_webui_content">
Order allow,deny
Allow from all
</Directory>
```

1. Your `/etc/cobbler/modules.conf` should look something like this:

```
[authentication]
module = authn_configfile

[authorization]
module = authz_allowall
```

1. Change the password for the ‘cobbler’ username:

```
htdigest /etc/cobbler/users.digest "Cobbler" cobbler
```

1. If this is not a new install, your Apache configuration for Cobbler might not be current.

```
cp /etc/httpd/conf.d/cobbler.conf.rpmnew /etc/httpd/conf.d/cobbler.conf
```

1. Now restart Apache and cobblerd.

```
/sbin/service cobblerd restart
/sbin/service httpd restart
```

1. If you use SELinux, you may also need to set the following, so that the WebUI can connect with the [XMLRPC](XMLRPC):

```
setsebool -P httpd_can_network_connect true
```

### 6.1.2.2. Basic setup (2.2.x and higher)

In addition to the steps above, cobbler 2.2.x has a requirement for `mod_wsgi` which, when installed via EPEL, will be disabled by default. Attempting to start httpd will result in:

```
Invalid command 'WSGIScriptAliasMatch', perhaps misspelled \
  or defined by a module not included in the server configuration
```

You can enable this module by editing `/etc/httpd/conf.d/wsgi.conf` and un-commenting the “LoadModule wsgi_module modules/mod_wsgi.so” line.

### 6.1.2.3. Next steps

It should be ready to go. From your web browser visit the URL on your bootserver that resembles:

```
https://bootserver.example.com/cobbler_web
```

and log in with the username (usually cobbler) and password that you set earlier.

Should you ever need to debug things, see the following log files:

```
/var/log/httpd/error_log
/var/log/cobbler/cobbler.log
```

### 6.1.2.4. Further setup

Cobbler authenticates all WebUI logins through `cobblerd`, which uses a configurable authentication mechanism. You may wish to adjust that for your environment. For instance, if in `modules.conf` above you choose to stay with the `authentication.configfile` module, you may want to add your system administrator usernames to the digest file. To do this it is recommended to use either `openssl` or Python directly.

Example using `openssl 1.1.1` or later:

```
printf "foobar" | openssl dgst -sha3-512
```

It is possible with `openssl` to generate hashes for the following hash algorithms which are configurable: blake2b512, blake2s256, shake128, shake256, sha3-224m sha3-256, sha3-384, sha3-512

Example using Python (using the python interactive shell):

```
import hashlib
hashlib.sha3_512("<PASSWORD>".encode('utf-8')).hexdigest()
```

Python of course will always have all possible hash algorithms available which are valid in the context of Cobbler.

Both examples return the same result when executed with the same password. The file itself is structured according to the following: `<USERNAME>:<REALM>:<PASSWORDHASH>`. Normally `<REALM>` will be `Cobbler`. Other values are currently not valid. Please add the user, realm and passwordhash with your preferred editor. Normally there should be no need to restart cobbler when a new user is added, removed or the password is changed. The authentication process reads the file every time a user is authenticated.

You may also want to refine for authorization settings.

Before Cobbler 3.1.2 it was recommended to do edit the file `users.digest` with the following command. Since `md5` is not FIPS compatible from Cobbler 3.1.3 and onwards this is not possible anymore. The file was also just read once per Cobbler start and thus a change of the data requires that Cobbler is restarted that it picks up these changes.

```
htdigest /etc/cobbler/users.digest "Cobbler" <username>
```

### 6.1.2.5. Rewrite Rule for secure-http

To redirect access to the WebUI via HTTPS on an Apache webserver, you can use the following rewrite rule, probably at the end of Apache’s `ssl.conf`:

```
### Force SSL only on the WebUI
<VirtualHost *:80>
    <LocationMatch "^/cobbler_web/*">
       RewriteEngine on
       RewriteRule ^(.*) https://%{SERVER_NAME}/%{REQUEST_URI} [R,L]
   </LocationMatch>
</VirtualHost>
```

​              

​          

- 6.2. Configuration Management Integrations

  - [6.2.1. Background considerations](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#background-considerations)
  - [6.2.2. General scheme](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#general-scheme)
  - [6.2.3. Built-In Configuration Management](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#built-in-configuration-management)
  - [6.2.4. Terraform Provider](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#terraform-provider)
  - [6.2.5. Ansible](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#ansible)
  - [6.2.6. Saltstack](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#saltstack)
  - [6.2.7. Vagrant](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#vagrant)
  - [6.2.8. Puppet](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#id5)
  - [6.2.9. cfengine support](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#cfengine-support)
  - [6.2.10. bcfg2 support](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#bcfg2-support)
  - [6.2.11. Chef](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#id6)
  - [6.2.12. Conclusion](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#conclusion)
  - [6.2.13. Attachments](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#attachments)



## 6.2.13. Attachments

- [puppet_node.py](/cobbler/attachment/wiki/UsingCobblerWithConfigManagementSystem/puppet_node.py) (2.5 kB) -Alternate External Nodes Script, added by shenson on 12/09/10 20:33:36.

## 6.3. API

Cobbler also makes itself available as an XML-RPC API for use by higher level management software. Learn more at https://cobbler.github.io

## 6.3. API

Cobbler also makes itself available as an XML-RPC API for use by higher level management software. Learn more at https://cobbler.github.io

## 6.4. Triggers

Triggers provide a way to integrate Cobbler with arbitrary 3rd party software without modifying Cobbler’s code. When adding a distro, profile, system, or repo, all scripts in `/var/lib/cobbler/triggers/add` are executed for the particular object type. Each particular file must be executable and it is executed with the name of the item being added as a parameter. Deletions work similarly – delete triggers live in `/var/lib/cobbler/triggers/delete`. Order of execution is arbitrary, and Cobbler does not ship with any triggers by default. There are also other kinds of triggers – these are described on the Cobbler Wiki. For larger configurations, triggers should be written in Python – in which case they are installed differently. This is also documented on the Wiki.

## 6.5. Images

Cobbler can help with booting images physically and virtually, though the usage of these commands varies substantially by the type of image. Non-image based deployments are generally easier to work with and lead to more sustainable infrastructure. Some manual use of other commands beyond of what is typically required of Cobbler may be needed to prepare images for use with this feature.



## 6.6. Power Management

Cobbler contains a power management feature that allows the user to associate system records in Cobbler with the power management configuration attached to them. This can ease installation by making it easy to reassign systems to new operating systems and then reboot those systems.

## 6.7. Non-import (manual) workflow

The following example uses a local kernel and initrd file (already downloaded), and shows how profiles would be created using two different automatic installation files – one for a web server configuration and one for a database server. Then, a machine is assigned to each profile.

```
cobbler check
cobbler distro add --name=rhel4u3 --kernel=/dir1/vmlinuz --initrd=/dir1/initrd.img
cobbler distro add --name=fc5 --kernel=/dir2/vmlinuz --initrd=/dir2/initrd.img
cobbler profile add --name=fc5webservers --distro=fc5-i386 --autoinst=/dir4/kick.ks --kopts="something_to_make_my_gfx_card_work=42 some_other_parameter=foo"
cobbler profile add --name=rhel4u3dbservers --distro=rhel4u3 --autoinst=/dir5/kick.ks
cobbler system add --name=AA:BB:CC:DD:EE:FF --profile=fc5-webservers
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=rhel4u3-dbservers
cobbler report
```

## 6.8. Repository Management

### 6.8.1. REPO MANAGEMENT

This has already been covered a good bit in the command reference section.

Yum repository management is an optional feature, and is not required to provision through Cobbler. However, if Cobbler is configured to mirror certain repositories, it can then be used to associate profiles with those repositories. Systems installed under those profiles will then be autoconfigured to use these repository mirrors in `/etc/yum.repos.d`, and if supported (Fedora Core 6 and later) these repositories can be leveraged even within Anaconda.  This can be useful if (A) you have a large install base, (B) you want fast installation and upgrades for your systems, or (C) have some extra software not in a standard repository but want provisioned systems to know about that repository.

Make sure there is plenty of space in Cobbler’s webdir, which defaults to `/var/www/cobbler`.

```
cobbler reposync [--only=ONLY] [--tries=N] [--no-fail]
```

Cobbler reposync is the command to use to update repos as configured with “cobbler repo add”.  Mirroring can take a long time, and usage of Cobbler reposync prior to usage is needed to ensure provisioned systems have the files they need to actually use the mirrored repositories.  If you just add repos and never run “cobbler reposync”, the repos will never be mirrored.  This is probably a command you would want to put on a crontab, though the frequency of that crontab and where the output goes is left up to the systems administrator.

For those familiar with dnf’s reposync, Cobbler’s reposync is (in most uses) a wrapper around the dnf reposync command.  Please use “cobbler reposync” to update Cobbler mirrors, as dnf’s reposync does not perform all required steps. Also Cobbler adds support for rsync and SSH locations, where as dnf’s reposync only supports what yum supports (http/ftp).

If you ever want to update a certain repository you can run:

```
cobbler reposync --only="reponame1" ...
```

When updating repos by name, a repo will be updated even if it is set to be not updated during a regular reposync operation (ex: cobbler repo edit –name=reponame1 –keep-updated=0).

Note that if a Cobbler import provides enough information to use the boot server as a yum mirror for core packages, Cobbler can set up automatic installation files to use the Cobbler server as a mirror instead of the outside world. If this feature is desirable, it can be turned on by setting yum_post_install_mirror to 1 in /etc/settings (and running “cobbler sync”).  You should not use this feature if machines are provisioned on a different VLAN/network than production, or if you are provisioning laptops that will want to acquire updates on multiple networks.

The flags `--tries=N` (for example, `--tries=3`) and `--no-fail` should likely be used when putting reposync on a crontab. They ensure network glitches in one repo can be retried and also that a failure to synchronize one repo does not stop other repositories from being synchronized.

### 6.8.2. Importing trees

Cobbler can auto-add distributions and profiles from remote sources, whether this is a filesystem path or an rsync mirror. This can save a lot of time when setting up a new provisioning environment. Import is a feature that many users will want to take advantage of, and is very simple to use.

After an import is run, Cobbler will try to detect the distribution type and automatically assign automatic installation files. By default, it will provision the system by erasing the hard drive, setting up eth0 for DHCP, and using a default password of “cobbler”.  If this is undesirable, edit the automatic installation files in `/etc/cobbler` to do something else or change the automatic installation setting after Cobbler creates the profile.

Mirrored content is saved automatically in `/var/www/cobbler/distro_mirror`.

Example 1: `cobbler import --path=rsync://mirrorserver.example.com/path/ --name=fedora --arch=x86`

Example 2: `cobbler import --path=root@192.168.1.10:/stuff --name=bar`

Example 3: `cobbler import --path=/mnt/dvd --name=baz --arch=x86_64`

Example 4: `cobbler import --path=/path/to/stuff --name=glorp`

Example 5: `cobbler import --path=/path/where/filer/is/mounted --name=anyname --available-as=nfs://nfs.example.org:/where/mounted/`

Once imported, run a `cobbler list` or `cobbler report` to see what you’ve added.

By default, the rsync operations will exclude content of certain architectures, debug RPMs, and ISO images – to change what is excluded during an import, see `/etc/cobbler/rsync.exclude`.

Note that all of the import commands will mirror install tree content into `/var/www/cobbler` unless a network accessible location is given with `--available-as`.  –available-as will be primarily used when importing distros stored on an external NAS box, or potentially on another partition on the same machine that is already accessible via `http://` or `ftp://`.

For import methods using rsync, additional flags can be passed to rsync with the option `--rsync-flags`.

Should you want to force the usage of a specific Cobbler automatic installation template for all profiles created by an import, you can feed the option `--autoinst` to import, to bypass the built-in automatic installation file auto-detection.

### 6.8.3. Repository mirroring workflow

The following example shows how to set up a repo mirror for all  enabled Cobbler host repositories and two additional repositories, and create a profile that will auto install those repository  configurations on provisioned systems using that profile.

```
cobbler check
# set up your cobbler distros here.
cobbler autoadd
cobbler repo add --mirror=http://mirrors.kernel.org/fedora/core/updates/6/i386/ --name=fc6i386updates
cobbler repo add --mirror=http://mirrors.kernel.org/fedora/extras/6/i386/ --name=fc6i386extras
cobbler reposync
cobbler profile add --name=p1 --distro=existing_distro_name --autoinst=/etc/cobbler/kickstart_fc6.ks --repos="fc6i386updates fc6i386extras"
```

### 6.8.4. Import Workflow

Import is a very useful command that makes starting out with Cobbler very quick and easy.

This example shows how to create a provisioning infrastructure from a distribution mirror or DVD ISO. Then a default PXE configuration is created, so that by default systems will PXE boot into a fully automated install process for that distribution.

You can use a network rsync mirror, a mounted DVD location, or a tree you have available via a network filesystem.

Import knows how to autodetect the architecture of what is being imported, though to make sure things are named correctly, it’s always a good idea to specify `--arch`. For instance, if you import a distribution named “fedora8” from an ISO, and it’s an x86_64 ISO, specify `--arch=x86_64` and the distro will be named “fedora8-x86_64” automatically, and the right architecture field will also be set on the distribution object. If you are batch importing an entire mirror (containing multiple distributions and arches), you don’t have to do this, as Cobbler will set the names for things based on the paths it finds.

```
cobbler check
cobbler import --path=rsync://yourfavoritemirror.com/rhel/5/os/x86_64 --name=rhel5 --arch=x86_64
# OR
cobbler import --path=/mnt/dvd --name=rhel5 --arch=x86_64
# OR (using an external NAS box without mirroring)
cobbler import --path=/path/where/filer/is/mounted --name=anyname --available-as=nfs://nfs.example.org:/where/mounted/
# wait for mirror to rsync...
cobbler report
cobbler system add --name=default --profile=name_of_a_profile1
cobbler system add --name=AA:BB:CC:DD:EE:FF --profile=name_of_a_profile2
cobbler sync
```

## 6.9. Virtualization

For Virt, be sure the distro uses the correct kernel (if paravirt) and follow similar steps as above, adding additional parameters as desired:

```
cobbler distro add --name=fc7virt [options...]
```

Specify reasonable values for the Virt image size (in GB) and RAM requirements (in MB):

```
cobbler profile add --name=virtwebservers --distro=fc7virt --autoinst=path --virt-file-size=10 --virt-ram=512 [...]
```

Define systems if desired. Koan can also provision based on the profile name.

```
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=virtwebservers [...]
```

If you have just installed Cobbler, be sure that the cobblerd service is running and that port 25151 is unblocked.

See the manpage for Koan for the client side steps.

## 6.11. Network Topics

### 6.11.1. PXE Menus

Cobbler will automatically generate PXE menus for all profiles it has defined. Running `cobbler sync` is required to generate and update these menus.

To access the menus, type `menu` at the `boot:` prompt while a system is PXE booting. If nothing is typed, the network boot will default to a local boot. If “menu” is typed, the user can then choose and provision any Cobbler profile the system knows about.

If the association between a system (MAC address) and a profile is already known, it may be more useful to just use `system add` commands and declare that relationship in Cobbler; however many use cases will prefer having a PXE system, especially when provisioning is done at the same time as installing new physical machines.

If this behavior is not desired, run `cobbler system add --name=default --profile=plugh` to default all PXE booting machines to get a new copy of the profile `plugh`. To go back to the menu system, run `cobbler system remove --name=default` and then `cobbler sync` to regenerate the menus.

When using PXE menu deployment exclusively, it is not necessary to make Cobbler system records, although the two can easily be mixed.

Additionally, note that all files generated for the PXE menu configurations are templatable, so if you wish to change the color scheme or equivalent, see the files in `/etc/cobbler`.

### 6.11.2. Default PXE Boot behavior

What happens when PXE booting a system when Cobbler has no record of the system being booted?

By default, Cobbler will configure PXE to boot to the contents of `/etc/cobbler/default.pxe`, which (if unmodified) will just fall through to the local boot process. Administrators can modify this file if they like to change that behavior.

An easy way to specify a default Cobbler profile to PXE boot is to create a system named `default`. This will cause `/etc/cobbler/default.pxe` to be ignored. To restore the previous behavior do a `cobbler system remove` on the `default` system.

```
cobbler system add --name=default --profile=boot_this
cobbler system remove --name=default
```

As mentioned in earlier sections, it is also possible to control the default behavior for a specific network:

```
cobbler system add --name=network1 --ip-address=192.168.0.0/24 --profile=boot_this
```

### 6.11.3. PXE boot loop prevention

If you have your machines set to PXE first in the boot order (ahead of hard drives), change the `pxe_just_once` flag in `/etc/cobbler/settings` to 1. This will set the machines to not PXE on successive boots once they complete one install. To re-enable PXE for a specific system, run the following command:

```
cobbler system edit --name=name --netboot-enabled=1
```

### 6.11.4. Automatic installation tracking

Cobbler knows how to keep track of the status of automatic installation of machines.

```
cobbler status
```

Using the status command will show when Cobbler thinks a machine started automatic installation and when it finished, provided the proper snippets are found in the automatic installation template. This is a good way to track machines that may have gone interactive (or stalled/crashed) during automatic installation.

## 6.12. Boot CD

Cobbler can build all of it’s profiles into a bootable CD image using the `cobbler buildiso` command. This allows for PXE-menu like bring up of bare metal in environments where PXE is not possible. Another more advanced method is described in the Koan manpage, though this method is easier and sufficient for most applications.



### 6.12.1. DHCP Management

Cobbler can optionally help you manage DHCP server. This feature is off by default.

Choose either `management = isc_and_bind` in `/etc/cobbler/dhcp.template` or `management = "dnsmasq"` in `/etc/cobbler/modules.conf`.  Then set `manage_dhcp=1` in `/etc/cobbler/settings`.

This allows DHCP to be managed via “cobbler system add” commands, when you specify the mac address and IP address for systems you add into Cobbler.

Depending on your choice, Cobbler will use `/etc/cobbler/dhcpd.template` or `/etc/cobbler/dnsmasq.template` as a starting point. This file must be user edited for the user’s particular networking environment. Read the file and understand how the particular app (ISC dhcpd or dnsmasq) work before proceeding.

If you already have DHCP configuration data that you would like to preserve (say DHCP was manually configured earlier), insert the relevant portions of it into the template file, as running `cobbler sync` will overwrite your previous configuration.

By default, the DHCP configuration file will be updated each time `cobbler sync` is run, and not until then, so it is important to remember to use `cobbler sync` when using this feature.

If omapi_enabled is set to 1 in `/etc/cobbler/settings`, the need to sync when adding new system records can be eliminated. However, the OMAPI feature is experimental and is not recommended for most users.



### 6.12.2. DNS configuration management

Cobbler can optionally manage DNS configuration using BIND and dnsmasq.

Choose either `management = isc_and_bind` or `management = dnsmasq` in `/etc/cobbler/modules.conf` and then enable `manage_dns` in `/etc/cobbler/settings`.

This feature is off by default. If using BIND, you must define the zones to be managed with the options `manage_forward_zones` and `manage_reverse_zones`.  (See the Wiki for more information on this).

If using BIND, Cobbler will use `/etc/cobbler/named.template` and `/etc/cobbler/zone.template` as a starting point for the `named.conf` and individual zone files, respectively. You may drop zone-specific template files in `/etc/cobbler/zone_templates/name-of-zone` which will override the default. These files must be user edited for the user’s particular networking environment.  Read the file and understand how BIND works before proceeding.

If using dnsmasq, the template is `/etc/cobbler/dnsmasq.template`. Read this file and understand how dnsmasq works before proceeding.

All managed files (whether zone files and `named.conf` for BIND, or `dnsmasq.conf` for dnsmasq) will be updated each time `cobbler sync` is run, and not until then, so it is important to remember to use `cobbler sync` when using this feature.

## 6.13. Containerization

We have a test-image which you can find in the Cobbler repository and an old image made by the community: https://github.com/osism/docker-cobbler

​              

## 6.4. Triggers

Triggers provide a way to integrate Cobbler with arbitrary 3rd party software without modifying Cobbler’s code. When adding a distro, profile, system, or repo, all scripts in `/var/lib/cobbler/triggers/add` are executed for the particular object type. Each particular file must be executable and it is executed with the name of the item being added as a parameter. Deletions work similarly – delete triggers live in `/var/lib/cobbler/triggers/delete`. Order of execution is arbitrary, and Cobbler does not ship with any triggers by default. There are also other kinds of triggers – these are described on the Cobbler Wiki. For larger configurations, triggers should be written in Python – in which case they are installed differently. This is also documented on the Wiki.

## 6.5. Images

Cobbler can help with booting images physically and virtually, though the usage of these commands varies substantially by the type of image. Non-image based deployments are generally easier to work with and lead to more sustainable infrastructure. Some manual use of other commands beyond of what is typically required of Cobbler may be needed to prepare images for use with this feature.



## 6.6. Power Management

Cobbler contains a power management feature that allows the user to associate system records in Cobbler with the power management configuration attached to them. This can ease installation by making it easy to reassign systems to new operating systems and then reboot those systems.

## 6.7. Non-import (manual) workflow

The following example uses a local kernel and initrd file (already downloaded), and shows how profiles would be created using two different automatic installation files – one for a web server configuration and one for a database server. Then, a machine is assigned to each profile.

```
cobbler check
cobbler distro add --name=rhel4u3 --kernel=/dir1/vmlinuz --initrd=/dir1/initrd.img
cobbler distro add --name=fc5 --kernel=/dir2/vmlinuz --initrd=/dir2/initrd.img
cobbler profile add --name=fc5webservers --distro=fc5-i386 --autoinst=/dir4/kick.ks --kopts="something_to_make_my_gfx_card_work=42 some_other_parameter=foo"
cobbler profile add --name=rhel4u3dbservers --distro=rhel4u3 --autoinst=/dir5/kick.ks
cobbler system add --name=AA:BB:CC:DD:EE:FF --profile=fc5-webservers
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=rhel4u3-dbservers
cobbler report
```

## 6.8. Repository Management

### 6.8.1. REPO MANAGEMENT

This has already been covered a good bit in the command reference section.

Yum repository management is an optional feature, and is not required to provision through Cobbler. However, if Cobbler is configured to mirror certain repositories, it can then be used to associate profiles with those repositories. Systems installed under those profiles will then be autoconfigured to use these repository mirrors in `/etc/yum.repos.d`, and if supported (Fedora Core 6 and later) these repositories can be leveraged even within Anaconda.  This can be useful if (A) you have a large install base, (B) you want fast installation and upgrades for your systems, or (C) have some extra software not in a standard repository but want provisioned systems to know about that repository.

Make sure there is plenty of space in Cobbler’s webdir, which defaults to `/var/www/cobbler`.

```
cobbler reposync [--only=ONLY] [--tries=N] [--no-fail]
```

Cobbler reposync is the command to use to update repos as configured with “cobbler repo add”.  Mirroring can take a long time, and usage of Cobbler reposync prior to usage is needed to ensure provisioned systems have the files they need to actually use the mirrored repositories.  If you just add repos and never run “cobbler reposync”, the repos will never be mirrored.  This is probably a command you would want to put on a crontab, though the frequency of that crontab and where the output goes is left up to the systems administrator.

For those familiar with dnf’s reposync, Cobbler’s reposync is (in most uses) a wrapper around the dnf reposync command.  Please use “cobbler reposync” to update Cobbler mirrors, as dnf’s reposync does not perform all required steps. Also Cobbler adds support for rsync and SSH locations, where as dnf’s reposync only supports what yum supports (http/ftp).

If you ever want to update a certain repository you can run:

```
cobbler reposync --only="reponame1" ...
```

When updating repos by name, a repo will be updated even if it is set to be not updated during a regular reposync operation (ex: cobbler repo edit –name=reponame1 –keep-updated=0).

Note that if a Cobbler import provides enough information to use the boot server as a yum mirror for core packages, Cobbler can set up automatic installation files to use the Cobbler server as a mirror instead of the outside world. If this feature is desirable, it can be turned on by setting yum_post_install_mirror to 1 in /etc/settings (and running “cobbler sync”).  You should not use this feature if machines are provisioned on a different VLAN/network than production, or if you are provisioning laptops that will want to acquire updates on multiple networks.

The flags `--tries=N` (for example, `--tries=3`) and `--no-fail` should likely be used when putting reposync on a crontab. They ensure network glitches in one repo can be retried and also that a failure to synchronize one repo does not stop other repositories from being synchronized.

### 6.8.2. Importing trees

Cobbler can auto-add distributions and profiles from remote sources, whether this is a filesystem path or an rsync mirror. This can save a lot of time when setting up a new provisioning environment. Import is a feature that many users will want to take advantage of, and is very simple to use.

After an import is run, Cobbler will try to detect the distribution type and automatically assign automatic installation files. By default, it will provision the system by erasing the hard drive, setting up eth0 for DHCP, and using a default password of “cobbler”.  If this is undesirable, edit the automatic installation files in `/etc/cobbler` to do something else or change the automatic installation setting after Cobbler creates the profile.

Mirrored content is saved automatically in `/var/www/cobbler/distro_mirror`.

Example 1: `cobbler import --path=rsync://mirrorserver.example.com/path/ --name=fedora --arch=x86`

Example 2: `cobbler import --path=root@192.168.1.10:/stuff --name=bar`

Example 3: `cobbler import --path=/mnt/dvd --name=baz --arch=x86_64`

Example 4: `cobbler import --path=/path/to/stuff --name=glorp`

Example 5: `cobbler import --path=/path/where/filer/is/mounted --name=anyname --available-as=nfs://nfs.example.org:/where/mounted/`

Once imported, run a `cobbler list` or `cobbler report` to see what you’ve added.

By default, the rsync operations will exclude content of certain architectures, debug RPMs, and ISO images – to change what is excluded during an import, see `/etc/cobbler/rsync.exclude`.

Note that all of the import commands will mirror install tree content into `/var/www/cobbler` unless a network accessible location is given with `--available-as`.  –available-as will be primarily used when importing distros stored on an external NAS box, or potentially on another partition on the same machine that is already accessible via `http://` or `ftp://`.

For import methods using rsync, additional flags can be passed to rsync with the option `--rsync-flags`.

Should you want to force the usage of a specific Cobbler automatic installation template for all profiles created by an import, you can feed the option `--autoinst` to import, to bypass the built-in automatic installation file auto-detection.

### 6.8.3. Repository mirroring workflow

The following example shows how to set up a repo mirror for all  enabled Cobbler host repositories and two additional repositories, and create a profile that will auto install those repository  configurations on provisioned systems using that profile.

```
cobbler check
# set up your cobbler distros here.
cobbler autoadd
cobbler repo add --mirror=http://mirrors.kernel.org/fedora/core/updates/6/i386/ --name=fc6i386updates
cobbler repo add --mirror=http://mirrors.kernel.org/fedora/extras/6/i386/ --name=fc6i386extras
cobbler reposync
cobbler profile add --name=p1 --distro=existing_distro_name --autoinst=/etc/cobbler/kickstart_fc6.ks --repos="fc6i386updates fc6i386extras"
```

### 6.8.4. Import Workflow

Import is a very useful command that makes starting out with Cobbler very quick and easy.

This example shows how to create a provisioning infrastructure from a distribution mirror or DVD ISO. Then a default PXE configuration is created, so that by default systems will PXE boot into a fully automated install process for that distribution.

You can use a network rsync mirror, a mounted DVD location, or a tree you have available via a network filesystem.

Import knows how to autodetect the architecture of what is being imported, though to make sure things are named correctly, it’s always a good idea to specify `--arch`. For instance, if you import a distribution named “fedora8” from an ISO, and it’s an x86_64 ISO, specify `--arch=x86_64` and the distro will be named “fedora8-x86_64” automatically, and the right architecture field will also be set on the distribution object. If you are batch importing an entire mirror (containing multiple distributions and arches), you don’t have to do this, as Cobbler will set the names for things based on the paths it finds.

```
cobbler check
cobbler import --path=rsync://yourfavoritemirror.com/rhel/5/os/x86_64 --name=rhel5 --arch=x86_64
# OR
cobbler import --path=/mnt/dvd --name=rhel5 --arch=x86_64
# OR (using an external NAS box without mirroring)
cobbler import --path=/path/where/filer/is/mounted --name=anyname --available-as=nfs://nfs.example.org:/where/mounted/
# wait for mirror to rsync...
cobbler report
cobbler system add --name=default --profile=name_of_a_profile1
cobbler system add --name=AA:BB:CC:DD:EE:FF --profile=name_of_a_profile2
cobbler sync
```

## 6.9. Virtualization

For Virt, be sure the distro uses the correct kernel (if paravirt) and follow similar steps as above, adding additional parameters as desired:

```
cobbler distro add --name=fc7virt [options...]
```

Specify reasonable values for the Virt image size (in GB) and RAM requirements (in MB):

```
cobbler profile add --name=virtwebservers --distro=fc7virt --autoinst=path --virt-file-size=10 --virt-ram=512 [...]
```

Define systems if desired. Koan can also provision based on the profile name.

```
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=virtwebservers [...]
```

If you have just installed Cobbler, be sure that the cobblerd service is running and that port 25151 is unblocked.

See the manpage for Koan for the client side steps.

## 6.11. Network Topics

### 6.11.1. PXE Menus

Cobbler will automatically generate PXE menus for all profiles it has defined. Running `cobbler sync` is required to generate and update these menus.

To access the menus, type `menu` at the `boot:` prompt while a system is PXE booting. If nothing is typed, the network boot will default to a local boot. If “menu” is typed, the user can then choose and provision any Cobbler profile the system knows about.

If the association between a system (MAC address) and a profile is already known, it may be more useful to just use `system add` commands and declare that relationship in Cobbler; however many use cases will prefer having a PXE system, especially when provisioning is done at the same time as installing new physical machines.

If this behavior is not desired, run `cobbler system add --name=default --profile=plugh` to default all PXE booting machines to get a new copy of the profile `plugh`. To go back to the menu system, run `cobbler system remove --name=default` and then `cobbler sync` to regenerate the menus.

When using PXE menu deployment exclusively, it is not necessary to make Cobbler system records, although the two can easily be mixed.

Additionally, note that all files generated for the PXE menu configurations are templatable, so if you wish to change the color scheme or equivalent, see the files in `/etc/cobbler`.

### 6.11.2. Default PXE Boot behavior

What happens when PXE booting a system when Cobbler has no record of the system being booted?

By default, Cobbler will configure PXE to boot to the contents of `/etc/cobbler/default.pxe`, which (if unmodified) will just fall through to the local boot process. Administrators can modify this file if they like to change that behavior.

An easy way to specify a default Cobbler profile to PXE boot is to create a system named `default`. This will cause `/etc/cobbler/default.pxe` to be ignored. To restore the previous behavior do a `cobbler system remove` on the `default` system.

```
cobbler system add --name=default --profile=boot_this
cobbler system remove --name=default
```

As mentioned in earlier sections, it is also possible to control the default behavior for a specific network:

```
cobbler system add --name=network1 --ip-address=192.168.0.0/24 --profile=boot_this
```

### 6.11.3. PXE boot loop prevention

If you have your machines set to PXE first in the boot order (ahead of hard drives), change the `pxe_just_once` flag in `/etc/cobbler/settings` to 1. This will set the machines to not PXE on successive boots once they complete one install. To re-enable PXE for a specific system, run the following command:

```
cobbler system edit --name=name --netboot-enabled=1
```

### 6.11.4. Automatic installation tracking

Cobbler knows how to keep track of the status of automatic installation of machines.

```
cobbler status
```

Using the status command will show when Cobbler thinks a machine started automatic installation and when it finished, provided the proper snippets are found in the automatic installation template. This is a good way to track machines that may have gone interactive (or stalled/crashed) during automatic installation.

## 6.12. Boot CD

Cobbler can build all of it’s profiles into a bootable CD image using the `cobbler buildiso` command. This allows for PXE-menu like bring up of bare metal in environments where PXE is not possible. Another more advanced method is described in the Koan manpage, though this method is easier and sufficient for most applications.



### 6.12.1. DHCP Management

Cobbler can optionally help you manage DHCP server. This feature is off by default.

Choose either `management = isc_and_bind` in `/etc/cobbler/dhcp.template` or `management = "dnsmasq"` in `/etc/cobbler/modules.conf`.  Then set `manage_dhcp=1` in `/etc/cobbler/settings`.

This allows DHCP to be managed via “cobbler system add” commands, when you specify the mac address and IP address for systems you add into Cobbler.

Depending on your choice, Cobbler will use `/etc/cobbler/dhcpd.template` or `/etc/cobbler/dnsmasq.template` as a starting point. This file must be user edited for the user’s particular networking environment. Read the file and understand how the particular app (ISC dhcpd or dnsmasq) work before proceeding.

If you already have DHCP configuration data that you would like to preserve (say DHCP was manually configured earlier), insert the relevant portions of it into the template file, as running `cobbler sync` will overwrite your previous configuration.

By default, the DHCP configuration file will be updated each time `cobbler sync` is run, and not until then, so it is important to remember to use `cobbler sync` when using this feature.

If omapi_enabled is set to 1 in `/etc/cobbler/settings`, the need to sync when adding new system records can be eliminated. However, the OMAPI feature is experimental and is not recommended for most users.



### 6.12.2. DNS configuration management

Cobbler can optionally manage DNS configuration using BIND and dnsmasq.

Choose either `management = isc_and_bind` or `management = dnsmasq` in `/etc/cobbler/modules.conf` and then enable `manage_dns` in `/etc/cobbler/settings`.

This feature is off by default. If using BIND, you must define the zones to be managed with the options `manage_forward_zones` and `manage_reverse_zones`.  (See the Wiki for more information on this).

If using BIND, Cobbler will use `/etc/cobbler/named.template` and `/etc/cobbler/zone.template` as a starting point for the `named.conf` and individual zone files, respectively. You may drop zone-specific template files in `/etc/cobbler/zone_templates/name-of-zone` which will override the default. These files must be user edited for the user’s particular networking environment.  Read the file and understand how BIND works before proceeding.

If using dnsmasq, the template is `/etc/cobbler/dnsmasq.template`. Read this file and understand how dnsmasq works before proceeding.

All managed files (whether zone files and `named.conf` for BIND, or `dnsmasq.conf` for dnsmasq) will be updated each time `cobbler sync` is run, and not until then, so it is important to remember to use `cobbler sync` when using this feature.

## 6.13. Containerization

We have a test-image which you can find in the Cobbler repository and an old image made by the community: https://github.com/osism/docker-cobbler



## 6.18. API[](https://cobbler.readthedocs.io/en/latest/user-guide.html#api)

Cobbler also makes itself available as an XML-RPC API for use by higher level management software. Learn more at https://cobbler.github.io

## 6.19. Triggers[](https://cobbler.readthedocs.io/en/latest/user-guide.html#triggers)

Triggers provide a way to integrate Cobbler with arbitrary 3rd party software without modifying Cobbler’s code. When adding a distro, profile, system, or repo, all scripts in `/var/lib/cobbler/triggers/add` are executed for the particular object type. Each particular file must be executable and it is executed with the name of the item being added as a parameter. Deletions work similarly – delete triggers live in `/var/lib/cobbler/triggers/delete`. Order of execution is arbitrary, and Cobbler does not ship with any triggers by default. There are also other kinds of triggers – these are described on the Cobbler Wiki. For larger configurations, triggers should be written in Python – in which case they are installed differently. This is also documented on the Wiki.

## 6.20. Images[](https://cobbler.readthedocs.io/en/latest/user-guide.html#images)

Cobbler can help with booting images physically and virtually, though the usage of these commands varies substantially by the type of image. Non-image based deployments are generally easier to work with and lead to more sustainable infrastructure. Some manual use of other commands beyond of what is typically required of Cobbler may be needed to prepare images for use with this feature.

## 6.21. Non-import (manual) workflow[](https://cobbler.readthedocs.io/en/latest/user-guide.html#non-import-manual-workflow)

The following example uses a local kernel and initrd file (already downloaded), and shows how profiles would be created using two different automatic installation files – one for a web server configuration and one for a database server. Then, a machine is assigned to each profile.

```
cobbler check
cobbler distro add --name=rhel4u3 --kernel=/dir1/vmlinuz --initrd=/dir1/initrd.img
cobbler distro add --name=fc5 --kernel=/dir2/vmlinuz --initrd=/dir2/initrd.img
cobbler profile add --name=fc5webservers --distro=fc5-i386 --autoinstall=/dir4/kick.ks --kernel-options="something_to_make_my_gfx_card_work=42 some_other_parameter=foo"
cobbler profile add --name=rhel4u3dbservers --distro=rhel4u3 --autoinstall=/dir5/kick.ks
cobbler system add --name=AA:BB:CC:DD:EE:FF --profile=fc5-webservers
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=rhel4u3-dbservers
cobbler report
```

## 6.22. Virtualization[](https://cobbler.readthedocs.io/en/latest/user-guide.html#virtualization)

For Virt, be sure the distro uses the correct kernel (if paravirt) and follow similar steps as above, adding additional parameters as desired:

```
cobbler distro add --name=fc7virt [options...]
```

Specify reasonable values for the Virt image size (in GB) and RAM requirements (in MB):

```
cobbler profile add --name=virtwebservers --distro=fc7virt --autoinstall=path --virt-file-size=10 --virt-ram=512 [...]
```

Define systems if desired. Koan can also provision based on the profile name.

```
cobbler system add --name=AA:BB:CC:DD:EE:FE --profile=virtwebservers [...]
```

If you have just installed Cobbler, be sure that the cobblerd service is running and that port 25151 is unblocked.

See the manpage for Koan for the client side steps.

## 6.23. Network Topics[](https://cobbler.readthedocs.io/en/latest/user-guide.html#network-topics)

### 6.23.1. PXE Menus[](https://cobbler.readthedocs.io/en/latest/user-guide.html#pxe-menus)

Cobbler will automatically generate PXE menus for all profiles that have the `enable_menu` property set. You can enable this with:

```
cobbler profile edit --name=PROFILE --enable-menu=yes
```

Running `cobbler sync` is required to generate and update these menus.

To access the menus, type `menu` at the `boot:` prompt while a system is PXE booting. If nothing is typed, the network boot will default to a local boot. If “menu” is typed, the user can then choose and provision any Cobbler profile the system knows about.

If the association between a system (MAC address) and a profile is already known, it may be more useful to just use `system add` commands and declare that relationship in Cobbler; however many use cases will prefer having a PXE system, especially when provisioning is done at the same time as installing new physical machines.

If this behavior is not desired, run `cobbler system add --name=default --profile=plugh` to default all PXE booting machines to get a new copy of the profile `plugh`. To go back to the menu system, run `cobbler system remove --name=default` and then `cobbler sync` to regenerate the menus.

When using PXE menu deployment exclusively, it is not necessary to make Cobbler system records, although the two can easily be mixed.

Additionally, note that all files generated for the PXE menu configurations are templatable, so if you wish to change the color scheme or equivalent, see the files in `/etc/cobbler`.

### 6.23.2. Default PXE Boot behavior[](https://cobbler.readthedocs.io/en/latest/user-guide.html#default-pxe-boot-behavior)

What happens when PXE booting a system when Cobbler has no record of the system being booted?

By default, Cobbler will configure PXE to boot to the contents of `/etc/cobbler/default.pxe`, which (if unmodified) will just fall through to the local boot process. Administrators can modify this file if they like to change that behavior.

An easy way to specify a default Cobbler profile to PXE boot is to create a system named `default`. This will cause `/etc/cobbler/default.pxe` to be ignored. To restore the previous behavior do a `cobbler system remove` on the `default` system.

```
cobbler system add --name=default --profile=boot_this
cobbler system remove --name=default
```

As mentioned in earlier sections, it is also possible to control the default behavior for a specific network:

```
cobbler system add --name=network1 --ip-address=192.168.0.0/24 --profile=boot_this
```

### 6.23.3. PXE boot loop prevention[](https://cobbler.readthedocs.io/en/latest/user-guide.html#pxe-boot-loop-prevention)

If you have your machines set to PXE first in the boot order (ahead of hard drives), change the `pxe_just_once` flag in `/etc/cobbler/settings.yaml` to 1. This will set the machines to not PXE on successive boots once they complete one install. To re-enable PXE for a specific system, run the following command:

```
cobbler system edit --name=name --netboot-enabled=1
```

### 6.23.4. Automatic installation tracking[](https://cobbler.readthedocs.io/en/latest/user-guide.html#automatic-installation-tracking)

Cobbler knows how to keep track of the status of automatic installation of machines.

```
cobbler status
```

Using the status command will show when Cobbler thinks a machine started automatic installation and when it finished, provided the proper snippets are found in the automatic installation template. This is a good way to track machines that may have gone interactive (or stalled/crashed) during automatic installation.

## 6.24. Containerization[](https://cobbler.readthedocs.io/en/latest/user-guide.html#containerization)

We have a test-image which you can find in the Cobbler repository and an old image made by the community: https://github.com/osism/docker-cobbler

## 6.25. Web-Interface[](https://cobbler.readthedocs.io/en/latest/user-guide.html#web-interface)

Please be patient until we have time with the 4.0.0 release to create a new web UI. The old Django based was preventing needed change inside the internals in Cobbler.









- ##### 我们查看到这里可以定义内核参数

```bash
cobbler profile edit --name=CentOS-7-x86_64 --kopts='net.ifnames=0 biosdevname=0'
```



## 使用

### 定义distro
可以通过为其指定外部的安装引导内核及ramdisk文件的方式实现。如已经有完整的系统安装树（如CentOS的安装镜像）则推荐使用import直接导入的方式进行。

**示例：**

```bash
# 将/dev/cdrom中的centos7 iso镜像挂载到/media
cobbler import --name=CentOS-7.0-x86_64 --path=/var/www/centos7/
task started: 2016-10-17_145028_import
task started (id=Media import, time=Mon Oct 17 14:50:28 2016)
Found a candidate signature: breed=redhat, version=rhel6
Found a candidate signature: breed=redhat, version=rhel7
Found a matching signature: breed=redhat, version=rhel7
Adding distros from path /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64:
creating new distro: CentOS-7.0-x86_64
trying symlink: /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64 /var/www/cobbler/links/CentOS-7.0-x86_64
creating new profile: CentOS-7.0-x86_64
associating repos
checking for rsync repo(s)
checking for rhn repo(s)
checking for yum repo(s)
starting descent into /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64 for CentOS-7.0-x86_64
processing repo at : /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64
need to process repo/comps: /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64
looking for /var/www/cobbler/ks_mirror/CentOS-7.0-x86_64/repodata/comps.xml
Keeping repodata as-is :/var/www/cobbler/ks_mirror/CentOS-7.0-x86_64/repodata
*** TASK COMPLETE ***

cobbler distro list 
# 查看所有distro
```

### 定义profile

使用profile来为特定的需求类别提供所需要安装配置，即在distro的基础上通过提供kickstart文件来生成一个特定的系统安装配置。distro的profile可以出现在PXE的引导菜单中作为安装的选择之一。

**示例：**

如果需要为前面创建的centos7这个distro提供一个可引导安装条目，其用到的kickstart文件为/tmp/centos7-test1.cfg(自动安装后的IP为172.16.1.50)，则可通过如下命令实现:

```bash
cobbler profile add --name=centos-7.0-test1 --distro=CentOS-7.0-x86_64 --kickstart=/var/lib/cobbler/kickstarts/centos7-test1.cfg
# 注意如果没有把 ks文件放到/var/lib/cobbler/kickstarts中会出现：
# exception on server: 'Invalid kickstart template file location /tmp/XXXXX.cfg, it is not inside   
#   /var/lib/cobbler/kickstarts/'

cobbler profile list
# 查看profile
```

## 安装系统

创建一个虚拟机使用pxe引导











```bash
[root@cobbler ~]# cd /var/lib/cobbler/kickstarts/
[root@cobbler kickstarts]# ls
default.ks    install_profiles  sample_autoyast.xml  sample_esxi4.ks  sample.ks
esxi4-ks.cfg  legacy.ks         sample_end.ks        sample_esxi5.ks  sample_old.seed
esxi5-ks.cfg  pxerescue.ks      sample_esx4.ks       sample_esxi6.ks  sample.seed
[root@cobbler kickstarts]# cp sample_end.ks centos6.ks

# 编辑centos6的kickstart文件
[root@cobbler kickstarts]# vim centos6.ks 

install
# Use text mode install
text
# System keyboard
keyboard us
# System language
lang en_US
# System timezone
timezone  Asia/ShangHai
#Root password
rootpw --iscrypted $default_password_crypted
# System authorization information
auth  --useshadow  --enablemd5
# Firewall configuration
firewall --disabled
# SELinux configuration
selinux --disabled
# Use network installation
url --url=$tree

# Clear the Master Boot Record
zerombr
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
part /boot --fstype=ext4 --size=500
part swap --fstype=swap --size=2048
part / --fstype=ext4 --grow --size=200 

# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Do not configure the X Window System
skipx
# Run the Setup Agent on first boot
firstboot --disable
# Reboot after installation
reboot


%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('func_install_if_enabled')
@core
@base
tree
nmap
wget
lftp
lrzsz
telnet
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps

sed -ri "/^#UseDNS/c\UseDNS no" /etc/ssh/sshd_config
sed -ri "/^GSSAPIAuthentication/c\GSSAPIAuthentication no" /etc/ssh/sshd_config
%end
```

7）编辑`centos6`镜像所使用的`kickstart`文件

```bash
# 动态编辑指定使用新的kickstart文件
[root@cobbler ~]# cobbler profile edit --name=centos6.9-x86_64 --kickstart=/var/lib/cobbler/kickstarts/centos6.ks

# 验证是否更改成功
[root@cobbler ~]# cobbler profile report --name=centos6.9-x86_64 |grep Kickstart
Kickstart                      : /var/lib/cobbler/kickstarts/centos6.ks
```







说明：在`client`端系统安装时，可以在`cobbler`服务端上查看日志`/var/log/messages`，观察安装的每一个流程







​                                                                                                                                                                                                                                                  

这个过程并不简单，而且手动注册每个必须配置的客户端机器可能很麻烦。对配置一台机器的任何参数更改（比如要使用一个不同的操作系统），都需要对配置进行手动干预，并有可能对自动部署文件进行手动干预。当机器数量增加时，如果不高度重视文件组织的条理性，TFTP 目录等元素就可能变得混乱。

Cobbler 通过为机器配置的所有方面创建一个中央管理点，从而解决了这些不足。Cobbler  可重新配置服务，创建存储库，解压缩操作系统媒介，代理或集成一个配置管理系统，控制电源管理等。Cobbler 创建了一个抽象层，您可在其中运行  “add new repository” 或 “change client machine operating system”  等命令。Cobbler  负责处理所有事情：创建或更新配置文件，重新启动服务，或者将媒介解压到新创建的目录中。它的目的是隐藏所有与系统相关的问题，以便您可专注于任务本身。



配置和使用 Cobbler 的方式包括命令行、API、XML-RPC 和 Web UI。



首先，安装该工具和 fence 代理包，Cobbler 使用这个程序包执行电源管理活动。以 root 用户的身份，执行发行版的包管理器的 `install` 命令：

```
yum -y install cobbler fence-agents
```

要测试 Cobbler 是否在正常运行，可键入 `cobbler check`。这个命令显示可能需要调整的配置点。不要担心它们；该命令只是一个为用户提供帮助的指南。后续步骤将配置相关的各个方面（惟一的例外是 SELinux 警告，可按照来自 Cobbler 的指令调整它们）。如果您碰巧获得一条连接错误消息，则需要验证各种服务 — 以及  SELinux 日志（如果已启用）— 是否已正常启动。您可能需要将 SELinux 布尔值 `httpd_can_network_connect_cobbler` 设置为 true (`setsebool -P httpd_can_network_connect_cobbler 1`)。如果需要这么做，则请记住在完成后重新启动各项服务。

### 配置 Cobbler

主要的 Cobbler 配置文件是 /etc/cobbler/settings。使用文本编辑器打开这个文件，并设置以下选项：

- manage_dhcp：1
- manage_dns：1
- manage_tftpd：1
- restart_dhcp：1
- restart_dns：1
- pxe_just_once：1
- next_server：<服务器的 IP 地址>
- server：<服务器的 IP 地址>

选项 `manage_*` 和 `restart_*` 无需加以说明。选项 `next_server` 用在 DHCP 配置文件中，向机器告知提供引导文件的服务器地址。选项 `server` 在机器安装期间用于引用 Cobbler 服务器地址。最后，选项 `pxe_just_once` 预防将机器中的安装循环配置为始终从网络引导。激活此选项时，机器告诉 Cobbler 安装已完成。Cobbler 将系统对象的 netboot 标志更改为 false，这会强制机器从本地磁盘引导。本示例稍后面将使用此选项。

##### 仅配置部分服务

可以将 Cobbler 配置为仅管理某些服务来适应您的需要。例如，您可能管理一台文件服务器，但网络中您无法访问的另一台机器提供  DHCP。在这种情况下，DHCP 管理员设置 filename 选项来询问引导文件（x86 系统为 pxelinux.0，PowerPC 为  yaboot），设置 `next_server` 选项来指向您的文件服务器的 IP 地址。在网络中引导的机器会从您的服务器请求引导文件。然后，配置 Cobbler 来管理 TFTP 服务并在该工具中注册机器，以便它为这些机器提供合适的文件。

您可能未激活所有选项（参阅 [仅配置部分服务](https://www.ibm.com/developerworks/cn/linux/l-cobbler/index.html#configsome)）。在本例中，配置 Cobbler 来管理所有服务，因为这是一种常见场景，并可展示如何进行配置。

现在，Cobbler 已知道要管理哪些服务，请告诉它要使用哪些程序。使用的选项为：

- DHCP：ISC dhcpd 或 dnsmasq
- DNS：BIND 或 dnsmasq
- TFTP：in.tftpd 或 cobbler 的内部 TFTP

为 DHCP 和 DNS 使用 dnsmasq 是一个不错的主意，因为 dnsmasq 的配置过程很容易。可使用 in.tftpd，因为这是系统的默认选择。使用清单 1 中的设置编辑文件 /etc/cobbler/modules.conf：

##### 清单 1. 配置设置

```
[dns]``module = manage_dnsmasq` `[dhcp]``module = manage_dnsmasq` `[tftpd]``module = manage_in_tftpd
```

Cobbler 使用一个模板来创建服务的配置文件。需要编辑 /etc/cobbler/dnsmasq.template 上的 dnsmasq  模板来修改网络信息，比如要使用的网关地址和 IP 范围。假设运行 Cobbler 的服务器也是网关，而且我们的 IP 范围为  192.168.122.5-192.168.122.254，那么在文件中输入以下这行内容：

```
dhcp-range=192.168.122.5,192.168.122.254,255.255.255.0
```

通常，您希望阻止未注册的客户端从服务器引导。为此，添加参数 `dhcp-ignore=tag:!known`。（在以前的版本中，语法可能有所不同：`dhcp-ignore=#known`。如果有疑问，您可以同时插入两个版本。）文件内容类似于清单 2 中的代码：

##### 清单 2. dnsmasq 模板文件

```
# Cobbler generated configuration file for dnsmasq``# $date``#` `# resolve.conf .. ?``#no-poll``#enable-dbus``read-ethers``addn-hosts = /var/lib/cobbler/cobbler_hosts` `dhcp-range=192.168.122.5,192.168.122.254,255.255.255.0``dhcp-ignore=tag:!known``dhcp-option=3,$next_server``dhcp-lease-max=1000``dhcp-authoritative``dhcp-boot=pxelinux.0``dhcp-boot=net:normalarch,pxelinux.0``dhcp-boot=net:ia64,$elilo` `$insert_cobbler_system_definitions
```

Cobbler 基本上已可以使用了。重新启动服务，并将更改同步到文件系统以使它们生效。还要记住重新启动 `xinetd` 服务以提供 TFTP。运行以下命令：

```
service cobblerd restart``cobbler sync``service xinetd restart
```

您可添加发行版和存储库，创建配置文件，以及注册系统。请记得要验证您的防火墙配置是否允许网络服务 TFTP、DHCP 和 HTTP/HTTPS 使用端口上的流量。



但是，在这么做之前，要考虑到您有一个 yum 存储库，这个存储库中包含更多要在安装中使用的程序包。为此，创建一个存储库对象：

```
cobbler repo add --arch=x86_64 --name=Flash-plugin \`` ``--mirror=http://linuxdownload.adobe.com/linux/x86_64/``cobbler reposync``cobbler repo report
```

对于 yum 存储库 URL，Cobbler 接受 http://、ftp://、rsync://、文件系统路径和 ssh 位置（通过使用基于私钥的身份验证）。`reposync` 操作很重要，因为它会从远程存储库中复制文件。如果创建了存储库对象但未运行 `reposync`，那么您的存储库将是空的，而且您的安装可能会失败。

要完成存储库激活，可将存储库与一个配置文件相关联。使用以下命令将其与 Fedora 配置文件相关联：

```
cobbler profile edit --name=Fedora17-x86_64 --repos=Flash-plugin
```

## 创建配置文件

下一步是创建配置文件。对于自动安装，使用 kickstart 模板特性指定一个 kickstart 文件。创建一个基于 /var/lib/cobbler/kickstarts  中的文件的简单 kickstart。然后，在 %packages 一节中，定义变量 *$desktop_pkg_group*，该变量在后面会被替换来确定安装哪些桌面包。清单 4 显示了 kickstart 文件的内容：

##### 清单 4. kickstart 文件的内容

```
# System bootloader configuration``bootloader --location=mbr``# Partition clearing information``clearpart --all --initlabel``# Run the Setup Agent on first boot``firstboot --disable``# Activate X``xconfig --startxonboot``# Use network installation``url --url=$tree``# additional repostories get added here``$yum_repo_stanza``# Reboot after installation``reboot``# System keyboard``keyboard us``# System language``lang en_US``# System timezone``timezone America/New_York``# Root password``rootpw --iscrypted $default_password_crypted``# Install OS instead of upgrade``install``# Clear the Master Boot Record``zerombr``# Allow anaconda to partition the system as needed``autopart` `%packages``@base``@base-x``firefox``flash-plugin``$desktop_pkg_group``%end` `%post``# create a default user to log in X``useradd desktop-user``passwd -d desktop-user` `# adds the yum repositories to the installed system``$yum_config_stanza``# cobbler final steps``$SNIPPET('kickstart_done')``%end
```

以 *$* 开头的变量替换为 Cheetah 程序（参阅 [参考资料](https://www.ibm.com/developerworks/cn/linux/l-cobbler/index.html#artrelatedtopics)），Cobbler 使用该程序处理其模板。如果熟悉 Cheetah 模板，那么规则都是一样的。如需了解有关内部 Cobbler 变量的更多信息，比如 *$yum_config_stanza*，请查阅 /var/lib/cobbler/kickstarts 中的可用 kickstart。

创建该文件后，将其复制到 /var/lib/cobbler/kickstarts（如果不这么做，Cobbler 可能无法使用它）。Cobbler 知道 *$desktop_pkg_group* 的值，因为您在创建配置文件时已使用 `--ksmeta` 选项对其定义过。使用此选项，可确定在替换 kickstart 模板中的一个变量时要使用的值。清单 5 中的命令创建了 Xfce 和 GNOME 配置文件：

##### 清单 5. 创建 Xfce 和 GNOME 配置文件的命令

```
cobbler profile add --name=Fedora17-xfce \``          ``--ksmeta='desktop_pkg_group=@xfce-desktop' \``          ``--kickstart=/var/lib/cobbler/kickstarts/example.ks \``          ``--parent=Fedora17-x86_64``cobbler profile add --name=Fedora17-gnome \``          ``--ksmeta='desktop_pkg_group=@gnome-desktop' \``          ``--kickstart=/var/lib/cobbler/kickstarts/example.ks \``          ``--parent=Fedora17-x86_64``cobbler profile report
```

`--parent` 参数告诉这些配置文件继承 Fedora 配置文件。这些配置文件使用 Fedora 发行版和额外的 Flash-plugin 存储库。要确保一切设置都是正确的，可在处理之后验证 kickstart 内容。结果类似于清单 6：

##### 清单 6. 验证 kickstart 内容

```
cobbler profile getks --name=Fedora17-xfce` `# System bootloader configuration``bootloader --location=mbr``# Partition clearing information``clearpart --all --initlabel``# Run the Setup Agent on first boot``firstboot --disable``# Activate X``xconfig --startxonboot``# Use network installation``url --url=http://192.168.122.1/cblr/links/Fedora17-x86_64``# additional repostories get added here``repo --name=Flash-plugin --baseurl=http://192.168.122.1/cobbler/repo_mirror/Flash-plugin``repo --name=source-1 --baseurl=http://192.168.122.1/cobbler/ks_mirror/Fedora17-x86_64` `# Reboot after installation``reboot``# System keyboard``keyboard us``# System language``lang en_US``# System timezone``timezone America/New_York``# Root password``rootpw --iscrypted $1$mF86/UHC$WvcIcX2t6crBz2onWxyac.``# Install OS instead of upgrade``install``# Clear the Master Boot Record``zerombr``# Allow anaconda to partition the system as needed``autopart` `%packages``@base``@base-x``firefox``flash-plugin``@xfce-desktop``%end` `%post``# create a user we can use to log on X``useradd desktop-user``passwd -d desktop-user` `# adds the yum repositories to the installed system``wget "http://192.168.122.1/cblr/svc/op/yum/profile/Fedora17-xfce" \``  ``--output-document=/etc/yum.repos.d/cobbler-config.repo` `# cobbler final steps` `wget "http://192.168.122.1/cblr/svc/op/ks/profile/Fedora17-xfce" -O /root/cobbler.ks``wget "http://192.168.122.1/cblr/svc/op/trig/mode/post/profile/Fedora17-xfce" -O /dev/null``%end
```

变量 *$dekstop_pkg_group* 已被正确替换为 *@xfce-desktop*，它告诉 Anaconda 安装程序安装 Xfce 桌面包分组。

### 将机器与配置文件相关联

您基本上已准备好开始进行安装。最后一步是将机器（每个桌面一台机器）与您希望向其安装的配置文件相关联。使用的命令如清单 7 所示：

##### 清单 7. 将机器与它们的配置文件相关联

```
cobbler system add --name=desktop-xfce-1 \``          ``--profile=Fedora17-xfce \``          ``--mac=52:54:00:b8:5e:8f \``          ``--ip-address=192.168.122.10``cobbler system add --name=desktop-gnome-1 \``          ``--profile=Fedora17-gnome \``          ``--mac=52:54:00:88:f3:44 \``          ``--ip-address=192.168.122.11``cobbler system report
```

Cobbler 中的电源管理特性可为您打开、关闭和重新引导机器。在有许多机器且必须组织电源管理信息时（比如每台机器的用户和密码，因为 Cobbler  在其数据库中注册了它们），此功能也很有用。假设机器 desktop-xfce-1 位于 Bay 2 的 IBM Bladecenter 中，并且 desktop-gnome-1 是一台由 RSA 委员会管理的机器。您可按照清单 8 中所示设置您的系统：

##### 清单 8. 添加电源管理信息

```
cobbler system edit --name=desktop-xfce-1 \``          ``--power-type=bladecenter \``          ``--power-id=2 \``          ``--power-user=admin_user \``          ``--power-pass=admin_password \``          ``--power-address=192.168.122.2``cobbler system edit --name=desktop-gnome-1 \``          ``--power-type=rsa \``          ``--power-user=rsa_user \``          ``--power-pass=rsa_password \``          ``--power-address=192.168.122.3
```



您已准备好引导机器并安装它们。这些机器必须配置为从网络引导 — 否则，它们可能从硬盘引导而且永远不会开始安装。如果激活了电源管理，那么 Cobbler 就可为您重新引导机器，这样您就可以使用一个简单命令开始安装：

```
cobbler system reboot --name=desktop-xfce-1
```

这个命令让 Cobbler 使用您指定的凭据连接到 Bladecenter，并向刀片服务器 2  发出一个重新引导命令。该刀片服务器通过网络引导重新启动，并从 Cobbler 中接收引导文件。安装过程会自动执行，而且该过程完成后将显示  Fedora 登录屏幕。

## Web 界面 cobbler-web

```bash
yum -y install cobbler-web
```

安装该程序包后，配置 Cobbler 授权和身份验证系统，以便登录。配置位于文件 `/etc/cobbler/modules.conf` 中。

```bash
# authentication:
# what users can log into the WebUI and Read-Write XMLRPC?
# choices:
#  authn_denyall  -- no one (default)
#  authn_configfile -- use /etc/cobbler/users.digest (for basic setups)
#  authn_passthru  -- ask Apache to handle it (used for kerberos)
#  authn_ldap    -- authenticate against LDAP
#  authn_spacewalk -- ask Spacewalk/Satellite (experimental)
#  authn_pam    -- use PAM facilities
#  authn_testing  -- username/password is always testing/testing (debug)
#  (user supplied) -- you may write your own module
# WARNING: this is a security setting, do not choose an option blindly.
# for more information:
# https://github.com/cobbler/cobbler/wiki/Cobbler-web-interface
# https://github.com/cobbler/cobbler/wiki/Security-overview
# https://github.com/cobbler/cobbler/wiki/Kerberos
# https://github.com/cobbler/cobbler/wiki/Ldap
[authentication]
module = authn_denyall
# authorization:
# once a user has been cleared by the WebUI/XMLRPC, what can they do?
# choices:
#  authz_allowall  -- full access for all authneticated users (default)
#  authz_ownership -- use users.conf, but add object ownership semantics
#  (user supplied) -- you may write your own module
# WARNING: this is a security setting do not choose an option blindly.
# If you want to further restrict cobbler with ACLs for various groups,
# pick authz_ownership. authz_allowall does not support ACLs. configfile
# does but does not support object ownership which is useful as an additional
# layer of control.
# for more information:
# https://github.com/cobbler/cobbler/wiki/Cobbler-web-interface
# https://github.com/cobbler/cobbler/wiki/Security-overview
# https://github.com/cobbler/cobbler/wiki/Web-authorization
[authorization]
module = authz_allowall
```

可使用 LDAP、PAM 和配置文件等身份验证选项。因为 PAM 非常常见，所以使用它执行身份验证。在授权一节中，定义哪些用户拥有使用该工具的官方许可。将 module 值设置为 `authz_ownership`，以便您可在 users.conf 文件中指定谁能够访问 Web 界面。

```bash
[authentication]
module = authn_pam
[authorization]
module = authz_ownership
```

保存该文件。接下来，您需要一个名为 `myuser` 的系统用户（如果没有，可使用 `useradd myuser && passwd myuser` 创建）。然后，打开文件 /etc/cobbler/users.conf 并将 `myuser` 添加到 admins 组（这个组拥有对象的完整访问权），如清单 11 所示：

```bash
# Cobbler WebUI / Web Services authorization config file
#
# NOTICE:
# this file is only used when /etc/cobbler/modules.conf
# specifies an authorization mode of either:
#
#  (A) authz_configfile
#  (B) authz_ownership
#
# For (A), any user in this file, in any group, are allowed
# full access to any object in cobbler configuration.
#
# For (B), users in the "admins" group are allowed full access
# to any object, otherwise users can only edit an object if
# their username/group is listed as an owner of that object. If a
# user is not listed in this file they will have no access.
#
#   cobbler command line example:
#
#   cobbler system edit --name=server1 --owner=dbas,mac,pete,jack
#
# NOTE: yes, you do need the equal sign after the names.
# don't remove that part. It's reserved for future use.
 
[admins]
  myuser = ""
```

配置已完成。现在，重新启动 Cobbler 和 Apache 服务以应用更改：

```bash
service cobblerd restart
service httpd restart
```

`https://ip/cobbler_web`
默认账号为`cobbler`，密码也为`cobbler`。

```bash
/etc/cobbler/users.conf     #Web服务授权配置文件
/etc/cobbler/users.digest   #用于web访问的用户名密码

[root@cobbler ~]# cat /etc/cobbler/users.digest 
cobbler:Cobbler:a2d6bae81669d707b72c0bd9806e01f3

# 设置密码，在Cobbler组添加cobbler用户，输入2遍密码确

[root@cobbler ~]# htdigest /etc/cobbler/users.digest "Cobbler" cobbler
Changing password for user cobbler in realm Cobbler
New password: superman
Re-type new password: superman

# 同步配置并重启httpd、cobbler

[root@cobbler ~]# cobbler sync
[root@cobbler ~]# systemctl restart httpd
[root@cobbler ~]# systemctl restart cobblerd
```

