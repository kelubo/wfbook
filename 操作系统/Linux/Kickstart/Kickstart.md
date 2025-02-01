# PXE + Kickstart

[TOC]

## 概述

> 在以下系统中进行过测试：、
>
> * CentOS 8 stream
>
> 建议采用 Cobbler 替代。

Kickstart 是一种无人值守的安装方式，工作原理就是预先把原本需要运维人员手工填写的参数保存成一个 ks.cfg 文件，当安装过程中出现需要填写参数时，则自动匹配 Kickstart 生成的文件。所以只要文件包含了安装过程中需要人工填写的所有参数，那么从理论上来讲完全不需要运维人员的干预，就可以自动完成安装工作。

TFTP (**T**rivial **F**ile **T**ransfer **P**rotocol，简单文本传输协议)：是一种基于 UDP 协议的传输协议，虽不具备 FTP 的许多功能（例如列出目录，密码认证等等），但配置非常简单，而且资源消耗更低，非常适合传输不敏感的文件。

Kickstart 流程：

1. DHCP（获取 IP，寻找 TFTP）
2. TFTP（交换获取开机启动文件 /tftpboot 即此文件夹）
3. HTTP（加载安装文件）
4. 本地安装

## 安装过程

1. 关闭 selinux 和 iptables 。

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
   option domain-name-servers 192.168.10.6;
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