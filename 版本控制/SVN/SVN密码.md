# linux下清除svn的用户名和密码
**方法一：**

linux下删除~/.subversion/auth即可清除之前的用户名和密码：rm -rf ~/.subversion/auth

以后再操作svn会提示你输入用户名，这时就可以使用新的了

**方法二：**

svn操作时带上--username参数，比如svn --username=smile  co  svn_path local_path
