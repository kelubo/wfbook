# SVN主从配置
1.在备用机上新建空版本库。  
2.改备用库pre-revprop-change，清空(或注释)文件，并增加执行权限x  
3.修改备机conf/passwd和conf/authz文件，增加帐号信息  
4.备用机上执行
 
    svnsync init 备用库 源版本库 
5.备用机上执行 

    svnsync sync 备用库
6.更改源库hooks/post-commit文件：
 
    /usr/bin/svnsync sync --non-interactive 备用库 --username xx --password xx


