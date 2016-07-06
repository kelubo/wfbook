# screenFetch
screenFetch 是一个“命令行信息截图工具”。可以在终端上显示系统信息，并进行桌面截图。能生成漂亮的文本的系统信息和ASCII艺术的发行版LOGO，然后显示在截屏图片中。  

screenFetch将显示以下系统信息：

    当前登录用户
    操作系统版本
    内核版本
    总计运行时间
    已安装包数量
    当前shell详情
    当前屏幕分辨率
    当前桌面环境
    当前窗口管理器（文件管理器）
    总计及空闲磁盘使用百分比
    CPU详情，如处理器速度、类型
    总计及当前内存使用量

使用命令克隆screenFectch库:

    # git clone git://github.com/KittyKatt/screenFetch.git screenfetch

复制文件到/usr/bin/目录，并设置执行权限:

    # cp screenfetch/screenfetch-dev /usr/bin/screenfetch
    # chmod +x /usr/bin/screenfetch

运行screenFectch:

    # screenfetch
