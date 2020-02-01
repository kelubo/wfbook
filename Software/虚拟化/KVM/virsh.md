# virsh

```bash
# virsh
help				#打印基本帮助信息
list				#列出所有客户端
dumpxml				#输出客户端XML配置文件
create				#从XML配置文件生成客户端并启动新客户端
start				#启动未激活的客户端
destroy				#强制客户端停止
define				#为客户端输出XML配置文件
domin				#显示客户端ID
domuuid				#显示客户端UUID
dominfo				#显示客户端信息
domname				#显示客户端名称
domstate			#显示客户端状态
quit				#退出当前的互动终端
reboot				#重新启动客户端
restore				#恢复以前保存在文件中的客户端
resume				#恢复暂停的客户端
save				#将客户端当前状态保存到某个文件中
shutdown			#关闭某个域
suspend				#暂停客户端
undefine			#删除与客户端关联的所有文件
migrate				#将客户端迁移至另一台主机中

#管理客户端及程序资源
setmem				#为客户端设定分配的内存
setmaxmem			#为管理程序设定内存上限
setvcpus			#修改为客户端分配的虚拟CPU数目
vcpuinfo			#显示客户端的虚拟CPU信息
vcpupin				#控制客户端的虚拟CPU亲和性
domblkstat			#显示正在运行的客户端的块设备统计
domifstat			#显示正在运行的客户端的网络接口统计
attach-device		#使用XML文件中的设备定义在客户端中添加设备
attach-disk			#在客户端中附加新磁盘设备
attach-interface	#在客户端中附加新网络接口
detach-device		#从客户端中分离设备，使用同样的XML描述作为命令attach-device
detach-disk			#从客户端中分离磁盘设备
detach-interface	#从客户端中分离网络接口

#Other
version				#显示virsh版本
nodeinfo			#有关管理程序的输出信息
```

