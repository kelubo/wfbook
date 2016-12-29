# SVN主从配置
1.在备用机上新建空版本库。  
2.改备用库hooks/pre-revprop-change，清空(或注释)文件，并增加执行权限x  
3.修改备机conf/passwd和conf/authz文件，增加帐号信息  
4.备用机上执行

    svnsync init 备用库 源版本库
5.备用机上执行

    svnsync sync 备用库
6.更改源库hooks/post-commit文件：

    /usr/bin/svnsync sync --non-interactive 备用库 --username xx --password xx

## 恢复
### 主机损坏
1.主机上复制备用库  
2.主库清除掉 pre-revprop-change 的可执行权限。

    chmod  -x  pre-revprop-change

3.备用库上执行同步命令，会出现主库的uuid 。

    svnsync sync 备用库URL

4.主库修改uuid 。

    svnadmin setuuid 主库本地路径 xxxxxxxxxxxxxxxxx(uuid)

5.主库修改 post-commit ，并增加可执行权限。

    /usr/bin/svnsync sync --non-interactive 备用库URL --username root --password XXX

### 备机损坏

修复过程同主从同步。
