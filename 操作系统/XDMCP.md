# XDMCP
1.修改/etc/inittab文件

    id:5:initdefault:

2.CentOS (Gnome)  
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