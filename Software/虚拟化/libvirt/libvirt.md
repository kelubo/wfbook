# libvirt

[TOC]

## 配置

### 配置文件

```bash
/etc/libvirt/
             |-  cim
             |-	 libvirt.conf              #配置一些常用libvirt连接的别名
             |-  libvirtd.conf             #守护进程libvirtd的配置文件
             |-  lxc.conf
             |-  nwfilter
             |-  qemu                      #使用QEMU
             |       |-  networks          #保存了创建一个域时默认使用的网络配置。
             |       |-  rhel6u3.xml  
             |-  qemu.conf                 #对QEMU的驱动的配置文件，包括VNC、SPICE等
             |                             #和连接他们时采用的权限认证方式的配置，也包
             |                             #括内存大页、SELinux、Cgroups等相关配置。
             |-  qemu-sanlock.conf
             |-  storage
```

