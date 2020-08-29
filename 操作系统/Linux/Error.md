# 错误处理

## CentOS

### 1. Authentication is required to set the network proxy used for downloading packages

弹出"Authentication is required to set the network proxy used for downloading packages"的对话框，解决方法禁掉Gnome里面自动更新的部分，具体：


```shell
vi /etc/xdg/autostart/gpk-update-icon.desktop
X-GNOME-Autostart-enabled=false 
```

### 2. 修改密码时报错“authentication token manipulation error”

根目录所在文件系统可能为只读状态，重新挂载。