# virsh

[TOC]

## 域管理

```bash
list				                          #列出当前节点上所有域
domstate <ID / Name /UUID>			          #显示域的运行状态
dominfo	<ID>             			          #显示域的基本信息
domid <Name / UUID>                           #根据域的名称或UUID返回域的ID
?? domuuid				
domname	<ID / UUID>     			          #根据域的ID或UUID返回域的名称
dommemstat <ID>                               #获取一个域的内存使用情况的统计信息
setmem <ID> <mem-size>				          #设置一个域的内存大小（默认单位KB）
vcpuinfo <ID>           			          #获取一个域的vCPU信息
setvcpus <ID> <vCPU-num>			          #设置一个域的vCPU数目
vcpupin <ID> <vCPU> <pCPU>			          #将一个域的vCPU绑定到某个物理CPU上运行
vncdisplay <ID>						          #获取一个域的VNC连接IP地址和端口
create <dom.xml>				              #从XML配置文件创建一个域
suspend <ID>				                  #暂停域
resume <ID>				                      #恢复暂停的域
shutdown <ID>			                      #关闭某个域（关机）
reboot <ID>				                      #重新启动域
reset <ID>                                    #强制重新启动域，相当于物理机电源reset按钮
destroy	 <ID>			                      #立即销毁一个域（相当于拔掉物理机电源线）
save <ID> <file.img>	    		          #将域当前状态保存到某个文件中
restore	<file.img>		                      #从一个被保存的文件中恢复一个域的运行
migrate	<ID> <dest_url>	    		          #将域迁移至另一台主机中
dumpxml	<ID>			                      #以XML格式转存出一个域的信息到标准输出中
attach-device <ID> <device.xml>	              #向一个域添加XML文件中的设备（热插拔）
detach-device <ID> <device.xml>	              #将XML文件中的设备从一个域中移除
console <ID>                                  #连接到一个域的控制台
```

## 宿主机和Hypervisor管理

```bash
version				                          #显示libvirt和Hypervisor版本信息
sysinfo                                       #以XML格式打印宿主机系统的信息
nodeinfo			                          #显示该节点的基本信息
uri                                           #显示当前连接的URI
hostname                                      #显示当前宿主机的主机名
capabilities                                  #显示该节点宿主机和客户机的架构和特性
freecell                                      #显示当前MUMA单元的可用空闲内存
nodememstats <cell>                           #显示该节点的某个内存单元使用情况的统计
connect <URI>                                 #连接到URI指示的Hypervisor
nodecpustats <cpu-num>                        #显示该节点的某个CPU使用情况的统计
qemu-attach <pid>                             #根据PID添加一个QEMU进程到libvirt中
qemu-monitor-command domain [--hmp] command   #向域的QEMU monitor中发送一个命令；一般需要“--hmp”参数，
                                              #以便直接传入monitor中的命令而不需要转换
```

## 网络的管理

```bash
iface-list				                      #显示出物理主机的网络接口列表
iface-mac <if-name>		                      #根据网络接口名称查询其对应的MAC地址
iface-name <MAC>		                      #根据MAC地址查询其对应的网络接口名称
iface-edit <if-name-or-uuid>                  #编辑一个物理主机的网络接口的XML配置文件
iface-dumpxml <if-name-or-uuid>		          #以XML格式转存出一个网络接口的状态信息
iface-destroy <if-name-or-uuid>		          #关闭宿主机上的一个物理网络接口
net-list							          #列出libvirt管理的虚拟网络
net-info <net-name-or-uuid>			          #根据名称查询一个虚拟网络的基本信息
net-uuid <net-name>					          #根据名称查询一个虚拟网络的UUID
net-name <net-uuid>					          #根据UUID查询一个虚拟网络的名称
net-create <net.xml>				          #根据一个网络XML配置文件创建一个虚拟网络
net-edit <net-name-or-uuid>			          #编译一个虚拟网络的XML配置文件
net-dumpxml <net-name-or-uuid>		          #转存出一个虚拟网络的XML格式化的配置信息
net-destroy <net-name-or-uuid>		          #销毁一个虚拟网络
```

## 存储池和存储卷的管理

```bash
pool-list									  #显示出libvirt管理的存储池
pool-info <pool-name>						  #根据一个存储池名称查询其基本信息
pool-uuid <pool-name>						  #根据存储池名称查询其UUID
pool-create <pool.xml>						  #根据XML配置文件的信息创建一个存储池
pool-edit <pool-name-or-uuid>				  #编辑一个存储池的XML配置文件
pool-destroy <pool-name-or-uuid>			  #在libvirt可见范围内关闭一个存储池		
pool-delete <pool-name-or-uuid>				  #删除一个存储池,不可恢复
vol-list <pool-name-or-uuid>				  #查询一个存储池中的存储卷的列表
vol-name <vol-key-or-path>					  #查询一个存储卷的名称
vol-path --pool  <pool>  <vol-name-or-key>	  #查询一个存储卷的路径
vol-create <vol.xml>						  #根据XML配置文件创建一个存储池
vol-clone <vol-name-path> <name>			  #克隆一个存储卷
vol-delete <vol-name-or-key-or-path>		  #删除一个存储卷
```

## 其他

```bash
help				                          #打印基本帮助信息
pwd											  #显示当前的工作目录
cd <dir>									  #改变当前工作目录
echo "test-content"							  #回显echo命令后参数中的内容
quit				                          #退出当前的互动终端
exit										  #退出当前的互动终端



start				#启动未激活的客户端
define				#为客户端输出XML配置文件
domin				#显示客户端ID
undefine			#删除与客户端关联的所有文件
setmaxmem			#为管理程序设定内存上限
domblkstat			#显示正在运行的客户端的块设备统计
domifstat			#显示正在运行的客户端的网络接口统计
attach-disk			#在客户端中附加新磁盘设备
attach-interface	#在客户端中附加新网络接口
detach-disk			#从客户端中分离磁盘设备
detach-interface	#从客户端中分离网络接口
```

