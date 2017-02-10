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
## 安装类型

    Minimal Desktop （CentOS 6）
    Desktop-Gnome   (CentOS 5)

## 软件列表

    compat-libstdc++
    gcc
    gcc-c++
    glibc-devel
    libXp
    screen
    vim-X11

## Yum Repo

    192.9.200.16

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

## FreeIPA Client
