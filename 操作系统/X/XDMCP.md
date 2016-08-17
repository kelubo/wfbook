# XDMCP
## CentOS(Gnome)
1.修改/etc/inittab文件

    id:5:initdefault:

2.配置XDMCP  
方法1：

    /etc/gdm/custom.conf
    [daemon]
    RemoteGreeter=/usr/libexec/gdmgreeter
    #远程登录界面与本地登录界面相同，无此项，登录界面为简洁型
    [security]
    AllowRemoteRoot=true
    [xdmcp]
    Enable=true
    [greeter]
    Browser=true
    #远程登录界面为“带头像浏览器的简洁主题”，若定义了[daemon]，此项不起作用。

方法2：  

运行命令

    gdmsetup

## Ubuntu 14.04
Ubuntu 14.04之后的系统采用了３D Gnome桌面，因此需要更换。采用mate桌面。  
1.安装mate桌面所用源

    $ sudo apt-add-repository ppa:ubutu-mate-dev/ppa
    $ sudo apt-add-repository ppa:ubutu-mate-dev/trusty-mate
    $ sudo apt-get update

2.安装mate桌面

    $ sudo apt-get install mate-desktop-environment-core
    # 安装一个最小化的桌面。
    $ sudo apt-get install mate-desktop-environment
    # 安装一个完整的桌面。
    $ sudo apt-get install mate-desktop-environment-extras
    # 安装一个完整的桌面，并安装推荐的软件。

3.启用XDMCP协议

    $ sudo vim /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
    [SeatDefaults]
    user-session=mate
    # 由ubuntu改为mate
    allow-guest=false
    greeter-show-manual-login=true
    greeter-hide-users=true

    [XDMCPServer]
    enabled=true

    $ sudo service lightdm restart

4.确认端口开启情况

    $ netstat -anp | grep :177
    udp    0     0 0.0.0.0:177    0.0.0.0:*
    udp6   0     0 :::177         :::*

Ubuntu 16.04以后，配置文件更改为50-ubuntu-mate.conf
