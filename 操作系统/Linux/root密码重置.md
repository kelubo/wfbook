# 重置 RHEL7/CentOS7 系统的root密码
**启动进入最小模式**

重启系统并在内核列表页面在系统启动之前按下 e。进入编辑模式。

**中断启动进程**

在内核字符串中 - 在以 linux 16 /vmlinuz- ect 结尾的行中输入 rd.break。接着 Ctrl+X 重启。系统启动进入初始化内存磁盘，并挂载在 /sysroot。在此模式中不需要输入密码。

**重新挂载文件系统以便读写**

    switch_root:/# mount -o remount,rw /sysroot/

**使 /sysroot 成为根目录**

    switch_root:/# chroot /sysroot

命令行提示符会稍微改变。

**修改 root 密码**

    sh-4.2# passwd

**加载 SELinux 策略**

    sh-4.2# load_policy -i

在 /etc/shadow 中设置上下文类型

    sh-4.2# chcon -t shadow_t /etc/shadow

注意：可以通过如下创建 autorelabel 文件的方式来略过最后两步，但自动重建卷标会花费很长时间。

    sh-4.2# touch /.autorelabel

**退出并重启**

退出并重启并用新的 root 密码登录。
