# 研发运算服务器部署流程
## Hostname
格式如下：

    linuxnn.tsinghuaic.com

## 分区
系统默认，具体配置如下：

    LVM Volume Groups
       VolGroup00
            LogVol00        /                ext3
            LogVol01                         swap          130912MB
    Hard Drives
        /dev/sda
            /dev/sda1       /boot            ext3          100MB
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

## Yum Repo

    192.9.200.16

## Selinux

    disabled

## Firewall

    systemctl stop firewalld
    systemctl disable firewalld

## FreeIPA Client

