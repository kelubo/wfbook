# vsftpd
默认设置为禁止root账户登录,开启的方式如下：

    1.编辑/etc/vsftpd/user_list和/etc/vsftpd/ftpusers两个设置文件脚本，将root账户前加上#号变为注释。（即让root账户从禁止登录的用户列表中排除）

    2.重新开启vsftpd   service vsftpd reload
