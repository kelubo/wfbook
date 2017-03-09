# 研发运算服务器部署流程
## Hostname
格式如下：

    linuxnn.tsinghuaic.com

## 分区
系统默认，具体配置如下：

    LVM Volume Groups
       VolGroup00
            LogVol00        /                ext4
            LogVol01                         swap          130912MB
    Hard Drives
        /dev/sda
            /dev/sda1       /boot            ext4          200MB
            /dev/sda2       VolGroup00       LVM PV

**注：** 以前同郑孝宇讨论过swap分区的容量问题。按照RedHat官方的描述，容量为8GB即可。但EDA开发环境中，swap占用的较大，原因不明。故增大容量，如果后期确认空间无需这么大，再进行缩减。

## 安装类型

    Minimal Desktop （CentOS 6）
    Desktop-Gnome   (CentOS 5)

## Yum Repo

    http://192.9.200.16/

## Selinux

    disabled

## Firewall

    1. CentOS 7
    systemctl stop firewalld
    systemctl disable firewalld

    2. CentOS 6
    service iptables stop
    service ip6tables stop
    chkconfig iptables off
    chkconfig ip6tables off


## 软件列表

    compat-libstdc++
    firefox
    gcc
    gcc-c++
    glibc               (i386 + x86_64 , ld-linux.so.2)
    glibc-devel
    ksh
    libXext             (i386 + x86_64 , libXext.so.6)
    libXft              (i386 + x86_64 , libXft.so.2)
    libXi               (i386 + x86_64 , libXi.so.6)
    libXp               (i386 + x86_64 , libXp.so.6)
    libXrandr           (i386 + x86_64 , libXrandr.so.2)
    libXrender          (i386 + x86_64 , libXrender.so.1)
    libXt               (i386 + x86_64)
    nautilus-open-terminal
    ncurses-libs        (libncurses.so.5)
    nscd
    nss-pam-ldapd
    screen
    subversion
    tcl
    tclx
    tcsh
    vim
    vim-X11

## LDAP

    dc=tsinghuaic,dc=com
    ldap://192.9.200.4

## FreeIPA Client
暂且不用
