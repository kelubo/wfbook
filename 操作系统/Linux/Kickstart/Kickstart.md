# PXE + Kickstart

[TOC]

## 概述

> 在以下系统中进行过测试：、
>
> * CentOS 8 stream
>
> 建议采用 Cobbler 替代。

PXE (**P**re-boot E**x**ecute **E**nvironment)：一种能够让计算机通过网络启动的引导方式，只要网卡支持 PXE 协议即可使用。是由英特尔设计的。协议有 Server 端和 Client 端，PXE Client 保存在网卡的 ROM 中，当计算机启动时，BIOS 把 PXE Client 调入内存中执行，然后 PXE Client 通过网络将放在 PXE Server 端的启动文件下载到本地运行。注意，PXE Client 和 PXE Server 之间传递数据是通过 TFTP 进行的，所以需要配置 TFTP 服务器。

Kickstart：是一种无人值守的安装方式，工作原理就是预先把原本需要运维人员手工填写的参数保存成一个 ks.cfg 文件，当安装过程中出现需要填写参数时则自动匹配 Kickstart 生成的文件。所以只要Kickstart 文件包含了安装过程中需要人工填写的所有参数，那么从理论上来讲完全不需要运维人员的干预，就可以自动完成安装工作。

TFTP (**T**rivial **F**ile **T**ransfer **P**rotocol，简单文本传输协议)：是一种基于 UDP 协议的传输协议，虽不具备 FTP 的许多功能（例如列出目录，密码认证等等），但配置非常简单，而且资源消耗更低，非常适合传输不敏感的文件。

## PXE

原理：

1. 客户端开机后，PXE BootROM（自启动芯片）获得控制权之前执行自我测试，然后以广播形式发出一个请求 FIND 帧。
2. 如果服务器收到客户端所送出的要求，就会送回 DHCP 回应，包括用户端的 IP 地址、预设通信通道，以及开机映像文件；否则服务器会忽略这个要求。
3. 客户端收到服务器发回的响应后则会回应一个帧，以请求传送启动所需文件，并把自己的 MAC 地址写到服务器端的 Netnames.db 文件中。
4. 将有更多的消息在客户端与服务器之间应答，用于决定启动参数。BootROM 由 TFTP 通信协议从服务器下载开机映像文档。客户端使用 TFTP 协议接收启动文件后，将控制权转交启动块以引导操作系统，完成远程启动。

## KickStart
KickStart 是一种无人职守安装方式。KickStart 的工作原理是通过记录典型的安装过程中所需人工干预填写的各种参数，并生成一个名为 ks.cfg 的文件；在其后的安装过程中，当出现要求填写参数的情况时，安装程序会首先去查找 ks.cfg 文件，当找到合适的参数时，就采用找到的参数，当没有找到合适的参数时，才需要安装者手工干预。这样，如果 ks.cfg 文件涵盖了安装过程中出现的所有需要填写的参数时，安装者完全可以只告诉安装程序从何处取 ks.cfg 文件，然后去忙自己的事情。等安装完毕，安装程序会根据 ks.cfg 中设置的重启选项来重启系统，并结束安装。

KickStart流程：

1. DHCP（获取 IP，寻找 TFTP）
2. TFTP（交换获取开机启动文件 /tftpboot 即此文件夹）
3. HTTP（加载安装文件）
4. 本地安装

## 安装过程

1. 关闭 selinux iptables 。

2. 安装相关软件：

   ```bash
   yum install httpd tftp-server syslinux dhcp
   ```

3. 挂载 Linux iso 镜像：

   ```bash
   mount /dev/cdrom /mnt
   cp -rf /mnt/* /var/www/html/
   ```

4. 生成 ks.cfg 文件，并放置于 /var/www/html 目录中。

5. 加载 tftp 相关文件：

   ```bash
   cp /usr/share/syslinux/pxelinux.0            /var/lib/tftpboot/
   cp /var/www/html/images/pxeboot/initrd.img   /var/lib/tftpboot/
   cp /var/www/html/images/pxeboot/vmlinuz      /var/lib/tftpboot/
   cp /var/www/html/isolinux/boot.msg           /var/lib/tftpboot/
   cp /var/www/html/isolinux/ldlinux.c32        /var/lib/tftpboot/
   
   cd /var/lib/tftpboot
   mkdir pxelinux.cfg
   cp /var/www/html/isolinux/isolinux.cfg       /var/lib/tftpboot/pxelinux.cfg/default
   chmod 644 pxelinux.cfg/default
   
   vim pxelinux.cfg/default
   # default vesamenu.c32 行改为：
   default linux
   # append initrd=initrd.img inst.stage2=hd:LABEL=CentOS-Stream-8-x86_64-dvd quiet 行改为：
   append initrd=initrd.img ks=http://192.168.1.8/ks.cfg
   ```

6. 配置 dhcp 服务

   ```bash
   cp /usr/share/doc/dhcp-server/dhcpd.conf.example /etc/dhcp/
   mv dhcpd.conf.example dhcpd.conf
   ```

   编辑文件 /etc/dhcpd.conf

   ```bash
   ddns-update-style interim;
   ignore client-updates;
   subnet 192.168.10.0 netmask 255.255.255.0 {
   option routers 192.168.10.1;
   option subnet-mask 255.255.255.0;
   range 192.168.10.100 192.168.10.200;
   next-server 192.168.10.85;
   filename "pxelinux.0";
   allow booting;
   allow bootp;
   }
   ```

7. 重启服务以及开机启动:

   ```
   systemctl enable --now httpd
   systemctl enable --now tftp
   systemctl enable --now dhcpd
   ```

8. 需要安装系统的主机设置通过 PXE 启动，进入安装过程。

## 启动Anaconda并将其指向Kickstart文件

通过将 **inst.ks=LOCATION** 参数传递给安装内核。

```bash
inst.ks=http://server/dir/file
inst.ks=ftp://server/dir/file
inst.ks=nfs:server:/dir/file
inst.ks=hd:device:/dir/file
inst.ks=cdrom:设备
```

对于使用 **Virtual Machine Manager** 或 **virt-manager** 的虚拟机安装，可以在 **URL Options** 下的框中指定 **Kickstart URL**。安装物理计算机时，使用安装介质启动，然后按 **Tab** 键中断启动过程。向安装内核中添加 **inst.ks=LOCATION** 参数。