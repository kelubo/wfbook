# 重启Ceph集群的OSD进程失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

1. Ceph集群测试读写性能，进行一轮测试后。重启集群OSD节点，继续开展读写测试，测试工具报错，如图所示：

   ![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0231911597.png)

2. 查看Ceph集群状态发现部分OSD状态为down，如图所示：

   ![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578582.png)

#### 处理步骤

1. 查看Ceph日志时发现往Ceph分配内存时失败，怀疑在OSD进程在获取内存是有异常。

2. 输入如图命令发现“osd_memory_target”的值并非官方发布的默认的4G。

   

   ![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578576.png)

   

3. 在ceph.conf文件中添加“osd_memory_target = 4294967296” ，使分配给每个osd的内存限制为4GB。

   

   ![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578571.png)

   

4. 将修改后的文件推送到其他节点。

   

   `ceph-deploy --overwrite-conf admin ceph1 ceph2 ceph3 client1 client2 client3 `





重启集群。



```
systemctl  restart ceph.target 
```

# PG分布不均匀

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

测试IO密集，磁盘负载较高的场景下，观测发现存储端部分硬盘的负载已到100%，部分负载只有不到80%，整体磁盘负载不均衡。通过**ceph pg dump**查看到Ceph集群PG分布有优化空间。

#### 处理步骤

每个OSD上承载的PG数量应相同或非常接近，否则容易出现个别OSD压力较大成为瓶颈，运用balancer插件可以实现PG分布优化。

1. 

   

   查看当前PG分布情况。

   

   `ceph balancer eval `



```
ceph pg dump 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

以上命令二选一即可。



使能Ceph PG自动均衡优化。



```
ceph balancer mode upmap ceph balancer on 
```

1. 

   Ceph每隔60秒会调整少量PG分布。

   

2. 不定时重复[1](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0002.html#kunpengsdss_09_0002__li1615202975016)，若PG分布情况不再变化，则说明分布已达到最佳。



​					 					 [上一篇：重启Ceph集群的OSD进程失败 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0001.html) 				 				 			

​					 					 [下一篇：COSBench读取大文件失败](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0004.html) 				 				 			

# COSBench读取大文件失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

当测试256k get时，COSBench读取文件失败。

#### 处理步骤

1. 查看cosbench log发现以下错误信息：（log路径为“/path/to/cosbench/archive/workload/workload.log”）

   

   ```
   Uploading large file fails with ResetException: Failed to reset the request input stream
   ```

根本原因是cosbench默认读文件的大小是128k。



调整读取文件大小参数，在/path/to/cosbench/cosbench-start.sh脚本中的Java命令行加入以下参数：



```
-Dcom.amazonaws.sdk.s3.defaultStreamBufferSize=<YOUR_MAX_PUT_SIZE> 
```

# COSBench测试异常终止

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

COSBench校验数据完整性失败导致测试终止。

#### 处理步骤

1. 查看Cosbench log发现以下错误信息：（log路径为“/path/to/cosbench/archive/workload/workload.log”）。

   

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578549.png)

   根本原因是cosbench校验数据MD5失败，导致测试终止。

   

2. 关闭MD5校验，在/path/to/cosbench/cosbench-start.sh脚本中的java命令行加入以下参数：

   

   `-Dcom.amazonaws.services.s3.disableGetObjectMD5Validation=true `

1. 

   

2. 重启所有COSBench进程。

​					 					 [上一篇：COSBench读取大文件失败 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0004.html) 				 				 			

​					 					 [下一篇：高并发测试失败](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0006.html) 				 				 			

# 高并发测试失败

​                        更新时间：2021/03/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

一个RGW的访问并发数大于512时，COSBench测试异常终止。

#### 处理步骤

1. 查看COSBench log发现以下错误信息：（log路径为“/path/to/cosbench/archive/workload/workload.log”）

   

   ```
   HTTP Request Time Out
   ```



查看RGW log发现以下错误信息，log路径为“/var/log/ceph/<rgw>.log”。



![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0231913356.png)



查看RGW默认线程数。



```
radosgw-admin --show-config | grep thread 
```



![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0241992579.png)

参数rgw_thread_pool_size，即RGW默认线程数为512，当并发数高于512时，RGW无法处理客户端请求，所有测试失败。



增加RGW线程，在任意一个Ceph节点上执行如下命令。



```
sed -i 's/rgw_frontends.*/& num_threads=1024/g' ceph.conf 
```





重启COSBench进程。



```
systemctl restart ceph-radosgw.target 
```

# RGW无法启动

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

RGW端口重复，导致RGW无法启动。

#### 处理步骤

1. 查看RGW进程。

   

   `ps -ef | grep rgw `



1. 查看RGW进程只有一个进程。

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578548.png)

2. 查看系统里面配置存在8个RGW服务。

   ![img](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578551.png)

3. 手动启动ceph-rgw.rgw* 和ceph-rgw.ceph-zip3，发现rgw.ceph-zip3没有启动。

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578586.png)

4. 查看对应的RGW端口，发现7482端口未启动，7480端口启动。

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578552.png)

5. 与配置文件对于发现7480对应的值ceph-zip*的RGW进程，7482对应的是rgw2的进程，怀疑是由于端口冲突导致进程启动失败。

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578560.png)



重启RGW进程。



1. 停止rgw2的进程。

   `systemctl stop ceph-radosgw@rgw.rgw2.service `



启动ceph-zip3进程，启动rgw2进程，问题解决。

```
systemctl start ceph-radosgw@rgw.ceph-zip3.service systemctl start ceph-radosgw@rgw.rgw2.service 
```

1. 1. 

      ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578569.png)

   

​					 					 [上一篇：高并发测试失败 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0006.html) 				 				 			

​					 					 [下一篇：集群只能显示部分RGW](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0008.html) 				 				 			

# 集群只能显示部分RGW

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

RGW重名，集群只能显示部分RGW。

![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578573.png)

![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578566.png)

![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578570.png)

![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578578.png)

![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578572.png)

#### 处理步骤

1. 修改Zone配置。

   

   1. 查看Zone。

      `radosgw-admin zone list `



![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578565.png)

查看placement的信息。

```
radosgw-admin zone placement list 
```



![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578558.png)

修改zone的压缩选项。

```
radosgw-admin zone placement modify --rgw-zone=default --compression=zlib --placement-id=default-placement 
```

1. 

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578574.png)



重启集群上的所有RGW服务，使配置生效。



```
for i in {1..7};do service ceph-radosgw@rgw.rgw$i restart;done 
```

1. 

   ![点击放大](https://support.huaweicloud.com/trouble-kunpengsdss/zh-cn_image_0200578559.png)

   

​					 					 [上一篇：RGW无法启动 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0007.html) 				 				 			

​					 					 [下一篇：Ceph性能测试时服务](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0009.html)

# Ceph性能测试时服务器重启

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

TaiShan 200服务器配置了板载网卡和1822网卡情况下，做Ceph性能测试，服务器重启。

#### 处理步骤

1. 检查发现是板载网卡驱动问题，内核参数需配置。
2. 升级板载网卡驱动、在kernel启动项添加irqpoll参数。

# fio连接失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

执行fio测试时，提示无法连接远程客户端，错误信息如下：

```
fio: connect: Connection refused
fio: failed to connect to 192.168.3.132:8765
```

#### 处理步骤

1. 检查发现远程客户端fio服务未启动。

2. 在远程客户端上启动fio服务。

   

   `fio --server `

1. 

   

​					 					 [上一篇：Ceph性能测试时服务器重启 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0009.html) 				 				 			

​					 					 [下一篇：fio执行测试失败](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0011.html) 				 				 			

# fio执行测试失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

执行fio测试过程中，管理节点提示命令错误，远程客户端提示服务端/客户端版本不匹配，错误信息如下：

```
fio: bad server cmd version 78
fio: server bad crc on command (got 0, wanted 4b0a)
fio: bad server cmd version 78
fio: server bad crc on command (got 0, wanted 27cd)
fio: client/server version mismatch (66 != 78)
```

#### 处理步骤

检查发现管理节点与客户端上安装的fio版本不一致，在管理节点和所有fio客户端上安装相同版本的fio即可解决该问题。

# fio引擎libaio加载失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

执行fio测试时，提示libaio引擎加载失败。

#### 原因分析

客户端所安装的fio版本不支持libaio引擎。

#### 处理步骤

安装libaio-devel，重新编译安装fio，具体操作如下：

```
yum -y install libaio-devel cd /path/to/fio/ ./configure make make install 
```



​					 					 [上一篇：fio执行测试失败 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0011.html) 				 				 			

​					 					 [下一篇：osq_lock函数CPU利用率较高](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0013.html) 				 				 			

# osq_lock函数CPU利用率较高

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

在使用libaio引擎执行fio测试时，perf top显示内核空间osq_lock函数的CPU利用率超过40% 。

#### 处理步骤

用fio的RBD引擎替换libaio引擎。

# 创建OSD失败

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

创建OSD失败，错误信息如下：

```
[ceph4][ERROR ] RuntimeError: command returned non-zero exit status: 1
[ceph_deploy.osd][ERROR ] Failed to execute command: /usr/sbin/ceph-volume --cluster ceph lvm create --bluestore --data /dev/nvme0n1p1
[ceph_deploy][ERROR ] GenericError: Failed to create 1 OSDs
```

#### 原因分析

OSD所依赖的lvm创建失败，lvs查看逻辑卷信息时未找到Ceph的逻辑卷，但lsblk可以发现Ceph逻辑卷，可见Ceph逻辑卷的DM映射未清除。

#### 处理步骤

清除逻辑卷的DM映射，操作如下：

```
dmsetup info -C dmsetup remove [dm_map_name] 
```



​					 					 [上一篇：osq_lock函数CPU利用率较高 					](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0013.html) 				 				 			

​					 					 [下一篇：Ceph mon异常](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss_09_0015.html) 				 				 			

# Ceph mon异常

​                        更新时间：2021/01/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/trouble-kunpengsdss/kunpengsdss-trouble.pdf) 			

​	[分享](javascript:void(0);) 

#### 现象描述

通过**ceph -s**观察到Ceph mon进程有slow ops，错误信息如下：

```
HEALTH_WARN 376 slow ops, oldest one blocked for 894 sec, daemons [mon,ceph4,mon,ceph5,mon,ceph6] have slow ops.
SLOW_OPS 376 slow ops, oldest one blocked for 894 sec, daemons [mon,ceph4,mon,ceph5,mon,ceph6] have slow ops.
```

#### 原因分析

Ceph集群重新部署后，用原来Ceph集群的配置文件覆盖当前集群的配置文件，导致NUMA亲和性配置与实际情况不匹配。

#### 处理步骤

重新配置NUMA亲和性，根据实际情况修改ceph.conf中的NUMA亲和性配置，具体如下：

```
[osd.N]： osd_numa_node = 1 public_network_interface = bond1 cluster_network_interface = bond1 
```