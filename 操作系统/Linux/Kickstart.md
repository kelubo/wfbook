# PXE+Kickstart
## PXE概念介绍
 PXE技术与RPL技术不同之处为RPL是静态路由，PXE是动态路由。RPL是根据网卡上的ID号加上其他记录组成的一个Frame（帧）向服务器发出请求。而服务器中已有这个ID数据，匹配成功则进行远程启动。PXE则是根据服务器端收到的工件站MAC地址，使用DHCP服务为这个MAC地址指定个IP地址。每次启动可能同一台工作站有与上次启动有不同的IP，即动态分配地址。  
 **PXE的原理**  
（1）客户端开机后，PXE BootROM（自启动芯片）获得控制权之前执行自我测试，然后以广播形式发出一个请求FIND帧。  
（2）如果服务器收到客户端所送出的要求，就会送回DHCP回应，包括用户端的IP地址、预设通信通道，以及开机映像文件；否则服务器会忽略这个要求。  
（3）客户端收到服务器发回的响应后则会回应一个帧，以请求传送启动所需文件，并把自己的MAC地址写到服务器端的Netnames.db文件中。  
（4）将有更多的消息在客户端与服务器之间应答，用于决定启动参数。BootROM由TFTP通信协议从服务器下载开机映像文档。客户端使用TFTP协议接收启动文件后，将控制权转交启动块以引导操作系统，完成远程启动。

## KickStart概念介绍
 KickStart是一种无人职守安装方式。KickStart的工作原理是通过记录典型的安装过程中所需人工干预填写的各种参数，并生成一个名为ks.cfg的文件；在其后的安装过程中(不只局限于生成KickStart安装文件的机器)当出现要求填写参数的情况时，安装程序会首先去查找KickStart生成的文件，当找到合适的参数时，就采用找到的参数，当没有找到合适的参数时，才需要安装者手工干预。这样，如果KickStart文件涵盖了安装过程中出现的所有需要填写的参数时，安装者完全可以只告诉安装程序从何处取ks.cfg文件，然后去忙自己的事情。等安装完毕，安装程序会根据ks.cfg中设置的重启选项来重启系统，并结束安装。

KickStart流程：

大体流程：DHCP(获取IP，寻找TFTP)>TFTP(交换获取开机启动文件 /tftpboot即此文件夹)>HTTP（加载安装文件）>本地安装



安装过程：

一、关闭了selinux iptables

二、配置yum源以及用yum安装

    yum install -y httpd* tftp-server-* xinetd-* \  
    system-config-kickstart-* syslinux dhcp*
挂载Linxu iso镜像

    mount /dev/cdrom   /mnt
    cp -rf   /mnt/*   /var/www/html/

三、配置tftp加载文件

开机启动：

    vi /etc/xinetd.d/tftpdisable                 = no
#disable的直由yes变为no

加载FTP文件：

    cd /tftpboot/cp /usr/lib/syslinux/pxelinux.0 /tftpboot
    cp /var/www/html/images/pxeboot/initrd.img   /tftpboot
    cp /var/www/html/images/pxeboot/vmlinux   /tftpboot
    cp /var/www/html/images/pxeboot/vmlinux   /tftpboot
    mkdir pxelinux.cfg
    cp /var/www/html/isolinux/isolinux.cfg   /tftpboot/default

四、配置dhcp文件  
 vim /etc/dhcpd.conf

    # # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
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

五、配置KickSyack自动安装配置文件
图形界面配置：

    #system-config-kickstart
Shell配置：参考代码区进行修改。



六、后续工作重启服务以及开机启动

     service httpd restart
     service xinetd restart
     service dhcpd restart
     chkconfig httpd on
     chkconfig xinetd on
     chkconfig dhcpd on
代码：  

    [root@wh-kickstart-100-60 ~]# vim /tftpboot/pxelinux.cfg/default
    default linux
    prompt 0
    timeout 10
    display boot.msg
    F1 boot.msg
    F2 options.msg
    F3 general.msg
    F4 param.msg
    F5 rescue.msg
    label linux
      kernel vmlinuz
      append initrd=initrd.img ks=http://192.168.100.60/ks.cfg
    label text
      kernel vmlinuz
      append initrd=initrd.img text
    label ks
      kernel vmlinuz
      append ks initrd=initrd.img
    label local
      localboot 1
    label memtest86
      kernel memtest
      append -

    [root@wh-kickstart-100-60 ~]# vim /etc/dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample  
    #
    ddns-update-style interim;
    ignore client-updates;
    subnet 192.168.100.0 netmask 255.255.255.0 {
    option routers 192.168.100.1;
    option subnet-mask 255.255.255.0;
    range 192.168.100.100 192.168.100.200;
    next-server 192.168.100.60;
    filename "pxelinux.0";
    allow booting;
    allow bootp;
    }

    [root@wh-kickstart-100-60 ~]# vim /var/www/html/ks.cfg
    #platform=x86, AMD64, or Intel EM64T
    # System authorization information
    auth  --useshadow  --enablemd5
    # System bootloader configuration
    bootloader --location=mbr
    # Partition clearing information
    clearpart --none
    # Use graphical install
    graphical
    # Firewall configuration
    firewall --enabled
    # Run the Setup Agent on first boot
    firstboot --disable
    # System keyboard
    keyboard us
    # System language
    lang en_US
    # Installation logging level
    logging --level=info
    # Use network installation
    url --url=http://192.168.100.60/
    # Network information
    network --bootproto=dhcp --device=eth0 --onboot=on
    #Root password
    rootpw --iscrypted $1$vraKvWxT$xevNz205XcKgz8pnf43BV1
    # SELinux configuration
    selinux --disabled
    # System timezone
    timezone  Asia/Shanghai
    # Install OS instead of upgrade
    install
    # X Window System configuration information
    xconfig  --defaultdesktop=GNOME --depth=8 --resolution=640x480
    # Disk partitioning information
    part / --bytes-per-inode=4096 --fstype="ext3" --size=4096
    part /boot --bytes-per-inode=4096 --fstype="ext3" --size=100
    part swap --bytes-per-inode=4096 --fstype="swap" --size=1024
    part /home --bytes-per-inode=4096 --fstype="ext3" --grow --size=1
    %packages
    @gnome-desktop


DHCP介绍：
ddns-update-style interim：这个是动态获取IP地址啦。必须放在第一项哇。
ignore client-updates：服务端与客户端传输相关
Subnet：获取IP段，要配置正确。
Routers：是路由地址
Range：dhcp分配IP段。
next-server：是tftp地址。
Allow booting bootp：放行传输和协议。

TFTP介绍：
Default：用在于tftp建立传输入协议后会去tftpboot里找文件，啥都找不着之后就会找default。
tftp-server ：这个是用来传送引导文件的，
Initrd.img/vmlinux： 看用来安装前的一些工作。但tftp是用来传输这些文件的协议。

网络结构：
如图为网络安装环境的一个原理示意，安装环境由一个局域网和连接到该局域网的启动服务器、安装服务器和待安装客户端，其中启动服务器和安装服务器可以部署在同一台物理机上。

服务相关作用：
Dhcpd: 分发IP地址。
Tftpd: 分发启动文件安装。
Httpd：分发系统文件安装。
