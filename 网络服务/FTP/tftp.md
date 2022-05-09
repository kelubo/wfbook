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

