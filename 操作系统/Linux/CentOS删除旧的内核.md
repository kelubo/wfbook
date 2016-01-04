# CentOS删除旧的内核 
CentOS时常会更新内核，导致启动时会增加很多启动项，可以删除旧的内核，保留最新的内核，这样可以释放一些磁盘空间。   

（1）查看已经安装的内核

    rpm -q kernel

显示结果：

    kernel-2.6.32-279.el6.i686
    kernel-2.6.32-279.9.1.el6.i686
    kernel-2.6.32-279.11.1.el6.i686
    kernel-2.6.32-279.14.1.el6.i686

（2）删除旧的内核

安装yum-utls：

    yum install yum-utils

(不明确此项目的)

设置你想要保留多少旧的内核，比如我想保留两个：

    package-cleanup --oldkernels --count=2

再次用rpm -q kernel查看内核信息，只剩最新的两个：

    kernel-2.6.32-279.11.1.el6.i686
    kernel-2.6.32-279.14.1.el6.i686

(3) 设置永久的内核安装数量 ，我设置的是两个

    gedit /etc/yum.conf

(4) 重启，就只会看见两个内核启动项了。

经过测试的系统：

    CentOS 6.3
    CentOS 6.5


