# tftp

[TOC]

## 概述

TFTP作为一种基于UDP协议的简单文件传输协议，不需要进行用户认证即可获取到所需的文件资源。TFTP是一种非常精简的文件传输服务程序，它的运行和关闭是由xinetd网络守护进程服务来管理的。（CentOS 9 经测试不需要）

## 安装

```bash
# 安装tftp服务程序：
dnf install tftp-server xinetd
# CentOS 9
dnf install tftp-server

# 编辑xinetd配置文件，启动TFTP服务程序
# CentOS 9 不需要执行此项
vim /etc/xinetd.d/tftp

# 将disable的值修改为no。
service tftp
{
    socket_type             = dgram
    protocol                = udp
    wait                    = yes
    user                    = root
    server                  = /usr/sbin/in.tftpd
    server_args             = -s /var/lib/tftpboot
    disable                 = no
    per_source              = 11
    cps                     = 100 2
    flags                   = IPv4
}

# 重启xinetd服务并添加到开机启动项中
# CentOS 9 不需要执行此项
systemctl restart xinetd
systemctl enable xinetd

# CentOS 9
systemctl start tftp
systemctl enable tftp

# 添加防火墙对tftp服务允许的规则
firewall-cmd --permanent --add-port=69/udp
firewall-cmd --reload
```

##### **11.3 TFTP简单文件传输协议**

简单文件传输协议（Trivial File Transfer Protocol，TFTP）是一种基于UDP协议在客户端和服务器之间进行简单文件传输的协议。顾名思义，它提供不复杂、开销不大的文件传输服务，可将其当作FTP协议的简化版本。

TFTP的命令功能不如FTP服务强大，甚至不能遍历目录，在安全性方面也弱于FTP服务。而且，由于TFTP在传输文件时采用的是UDP协议，占用的端口号为69，因此文件的传输过程也不像FTP协议那样可靠。但是，因为TFTP不需要客户端的权限认证，也就减少了无谓的系统和网络带宽消耗，因此在传输琐碎（trivial）不大的文件时，效率更高。

接下来在系统上安装相关的软件包，进行体验。其中，tftp-server是服务程序，tftp是用于连接测试的客户端工具，xinetd是管理服务（后面会讲到）：

```
[root@linuxprobe ~]# dnf install tftp-server tftp xinetd
Updating Subscription Management repositories.
Unable to read consumer identity
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
AppStream                                               3.1 MB/s | 3.2 kB     00:00    
BaseOS                                                  2.7 MB/s | 2.7 kB     00:00    
Dependencies resolved.
========================================================================================
 Package              Arch            Version                  Repository          Size
========================================================================================
Installing:
 tftp                 x86_64          5.2-24.el8               AppStream           42 k
 tftp-server          x86_64          5.2-24.el8               AppStream           50 k
 xinetd               x86_64          2:2.3.15-23.el8          AppStream          135 k

Transaction Summary
========================================================================================
Install  3 Packages

Total size: 227 k
Installed size: 397 k
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                1/1 
  Installing       : xinetd-2:2.3.15-23.el8.x86_64                                  1/3 
  Running scriptlet: xinetd-2:2.3.15-23.el8.x86_64                                  1/3 
  Installing       : tftp-server-5.2-24.el8.x86_64                                  2/3 
  Running scriptlet: tftp-server-5.2-24.el8.x86_64                                  2/3 
  Installing       : tftp-5.2-24.el8.x86_64                                         3/3 
  Running scriptlet: tftp-5.2-24.el8.x86_64                                         3/3 
  Verifying        : tftp-5.2-24.el8.x86_64                                         1/3 
  Verifying        : tftp-server-5.2-24.el8.x86_64                                  2/3 
  Verifying        : xinetd-2:2.3.15-23.el8.x86_64                                  3/3 
Installed products updated.

Installed:
  tftp-5.2-24.el8.x86_64  tftp-server-5.2-24.el8.x86_64  xinetd-2:2.3.15-23.el8.x86_64 

Complete!
```

在Linux系统中，TFTP服务是使用xinetd服务程序来管理的。xinetd服务可以用来管理多种轻量级的网络服务，而且具有强大的日志功能。它专门用于控制那些比较小的应用程序的开启与关闭，有点类似于带有独立开关的插线板（见图11-3），想开启那个服务，就编辑对应的xinetd配置文件的开关参数。

![第11章 使用Vsftpd服务传输文件第11章 使用Vsftpd服务传输文件](https://www.linuxprobe.com/wp-content/uploads/2021/03/未标题-1-1-1.jpg)

图11-3 一个带有独立开关的插线板

简单来说，在安装TFTP软件包后，还需要在xinetd服务程序中将其开启。在RHEL  8系统中，tftp所对应的配置文件默认不存在，需要用户根据示例文件（/usr/share/doc/xinetd/sample.conf）自行创建。大家可以直接将下面的内容复制到文件中，就可以使用了：

```
[root@linuxprobe ~]# vim /etc/xinetd.d/tftp
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
```

然后，重启xinetd服务并将它添加到系统的开机启动项中，以确保TFTP服务在系统重启后依然处于运行状态。考虑到有些系统的防火墙默认没有允许UDP协议的69端口，因此需要手动将该端口号加入到防火墙的允许策略中：

```
[root@linuxprobe ~]# systemctl restart tftp
[root@linuxprobe ~]# systemctl enable tftp
[root@linuxprobe ~]# systemctl restart xinetd
[root@linuxprobe ~]# systemctl enable xinetd
[root@linuxprobe ~]# firewall-cmd --zone=public --permanent --add-port=69/udp
success
[root@linuxprobe ~]# firewall-cmd --reload 
success
```

TFTP的根目录为/var/lib/tftpboot。可以使用刚才安装好的tftp命令尝试访问其中的文件，亲身体验TFTP服务的文件传输过程。在使用tftp命令访问文件时，可能会用到表11-6中的参数。

表11-6                     tftp命令中可用的参数以及作用

| 参数    | 作用                |
| ------- | ------------------- |
| ?       | 帮助信息            |
| put     | 上传文件            |
| get     | 下载文件            |
| verbose | 显示详细的处理信息  |
| status  | 显示当前的状态信息  |
| binary  | 使用二进制进行传输  |
| ascii   | 使用ASCII码进行传输 |
| timeout | 设置重传的超时时间  |
| quit    | 退出                |



```
[root@linuxprobe ~]# echo "i love linux" > /var/lib/tftpboot/readme.txt
[root@linuxprobe ~]# tftp 192.168.10.10
tftp> get readme.txt
tftp> quit
[root@linuxprobe ~]# ls
anaconda-ks.cfg  Documents  initial-setup-ks.cfg  Pictures  readme.txt  Videos
Desktop          Downloads  Music                 Public    Templates
[root@linuxprobe ~]# cat readme.txt 
i love linux
```

