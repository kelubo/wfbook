# iSCSI
传统的SCSI小型计算机系统接口(Small Computer System Interface)技术是存储设备最基本的标准协议，但通常需要设备互相靠近并用SCSI总线链接，因此受到了物理环境的限制。

iSCSI小型计算机系统接口（即Internet Small Computer System Interface）则是由IBM公司研究开发用于实现在IP网络上运行SCSI协议的新存储技术，即能够让SCSI接口与以太网技术相结合，使用iSCSI协议基于以太网传送SCSI命令与数据，克服了SCSI需要直接连接存储设备的局限性，使得我们可以跨越不同的服务器共享存储设备，并可以做到不停机状态下扩展存储容量。

SAN存储区域网络技术(Storage Area Network)便是基于iSCSI存储协议，采用高速光纤通道传输存储数据的服务程序。

服务器会基于iSCSI协议将SCSI设备、命令与数据打包成标准的TCP/IP包然后通过IP网络传输到目标存储设备，而远端存储设备接收到数据包后需要基于iSCSI协议将TCP/IP包解包成SCSI设备、命令与数据，这个过程无疑会消耗系统CPU资源，因此我们可以将SCSI协议的封装动作交由独立的iSCSI HBA硬件卡来处理，减少了对服务器性能的影响。

iSCSI-HBA。与一般的网卡不同（连接网络总线和内存，供计算机上网使用），iSCSI-HBA卡连接的则是SCSI接口或FC（光纤通道）总线和内存，专门用于在主机之间交换存储数据，其使用的协议也与一般网卡有本质的不同。运行Linux系统的服务器会基于iSCSI协议把硬盘设备[命令](https://www.linuxcool.com/)与数据打包成标准的TCP/IP数据包，然后通过以太网传输到目标存储设备，而当目标存储设备接收到这些数据包后，还需要基于iSCSI协议把TCP/IP数据包解压成硬盘设备命令与数据。

## iSCSI存储
iSCSI的工作方式分为服务端（target）与客户端（initiator）

逻辑单元LUN(即Logical Unit Number)是使用iSCSI协议中的重要概念，因为当客户机想要使用服务端存储设备时都必需输入对应的名称(Target ID)，而一个服务端可能会同时提供多个可用的存储设备，于是便用LUN来详细的描述设备或对象，同时每个LUN Device可能代表一个硬盘或RAID设备，LUN的名称由用户指定。

## 配置iSCSI服务端

### 方案1  targetd

第1步:准备作为LUN发布的存储设备。

第2步:安装iSCSI target服务程序：

```bash
yum -y install targetd targetcli
systemctl start targetd
systemctl enable targetd
```

第3步:创建存储对象。
targetcli命令用于管理iSCSI target存储设备，格式为：“targetcli”

```bash
targetcli
```

查看当前的存储目录树：

```bash
/> ls
o- / ..................................................................... [...]
o- backstores .......................................................... [...]
| o- block .............................................. [Storage Objects: 0]
| o- fileio ............................................. [Storage Objects: 0]
| o- pscsi .............................................. [Storage Objects: 0]
| o- ramdisk ............................................ [Storage Objects: 0]
o- iscsi ........................................................ [Targets: 0]
o- loopback ..................................................... [Targets: 0]
```

进入/backstores/block目录中：

```bash
/> cd /backstores/block
/backstores/block>
```

使用/dev/md0创建设备disk0：

```bash
/backstores/block> create disk0 /dev/md0
Created block storage object disk0 using /dev/md0.
```

返回到根目录中：

```bash
/backstores/block> cd ..
/backstores> cd ..
/>
```

查看创建后的设备：

```bash
/> ls
o- / ................................................................... [...]
  o- backstores ........................................................ [...]
  | o- block ............................................ [Storage Objects: 1]
  | | o- disk0 ................... [/dev/md0 (40.0GiB) write-thru deactivated]
  | o- fileio ........................................... [Storage Objects: 0]
  | o- pscsi ............................................ [Storage Objects: 0]
  | o- ramdisk .......................................... [Storage Objects: 0]
  o- iscsi ...................................................... [Targets: 0]
  o- loopback ................................................... [Targets: 0]
```

第4步:配置iSCSI target目标。
进入到iscsi目录中：

```bash
/> cd iscsi
/iscsi>
```

创建iSCSI target目标：

```bash
/iscsi> create
Created target iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80.
Created TPG 1.
```

依次进入到target的luns目录中：

```bash
/iscsi> cd iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80/
/iscsi/iqn.20....d497c356ad80> ls
o- iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80 ..... [TPGs: 1]
  o- tpg1 .............................................. [no-gen-acls, no-auth]
    o- acls ......................................................... [ACLs: 0]
    o- luns ......................................................... [LUNs: 0]
    o- portals ................................................... [Portals: 0]
/iscsi/iqn.20....d497c356ad80> cd tpg1/
/iscsi/iqn.20...c356ad80/tpg1> cd luns
/iscsi/iqn.20...d80/tpg1/luns>
```

创建LUN设备：

```bash
/iscsi/iqn.20...d80/tpg1/luns> create /backstores/block/disk0
Created LUN 0.
```

第5步：设置访问控制列表。
切换到acls目录中：

```bash
/iscsi/iqn.20...d80/tpg1/luns> cd ..
/iscsi/iqn.20...c356ad80/tpg1> cd acls
```

创建访问控制列表：

    /iscsi/iqn.20...d80/tpg1/acls> create iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80:client
    Created Node ACL for iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80:client
    Created mapped LUN 0.

切换到portals目录中：

    /iscsi/iqn.20...d80/tpg1/acls> cd ..
    /iscsi/iqn.20...c356ad80/tpg1> cd portals

添加允许监听的IP地址：

    /iscsi/iqn.20.../tpg1/portals> create 192.168.10.10
    Using default IP port 3260
    Created network portal 192.168.10.10:3260.

查看配置概述后退出工具：

```bash
/iscsi/iqn.20.../tpg1/portals> ls /
o- / ........................... [...]
  o- backstores................. [...]
  | o- block ................... [Storage Objects: 1]
  | | o- disk0 ................. [/dev/md0 (40.0GiB) write-thru activated]
  | o- fileio .................. [Storage Objects: 0]
  | o- pscsi ................... [Storage Objects: 0]
  | o- ramdisk ................. [Storage Objects: 0]
  o- iscsi ..................... [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad0 .. [TPGs: 1]
  |   o- tpg1 .................. [no-gen-acls, no-auth]
  |     o- acls ..................................................... [ACLs: 1]
  |     | o- iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80:client [Mapped LUNs: 1]
  |     |   o- mapped_lun0 .......................... [lun0 block/disk0 (rw)]  
    o- luns .................... [LUNs: 1]
  |     | o- lun0 .............. [block/disk0 (/dev/md0)]
  |     o- portals ............. [Portals: 1]
  |       o- 192.168.10.10:3260  [OK]
  o- loopback .................. [Targets: 0]
/> exit
Global pref auto_save_on_exit=true
Last 10 configs saved in /etc/target/backup.
Configuration saved to /etc/target/saveconfig.json
```

第4步:创建防火墙允许规则：

```bash
firewall-cmd --permanent  --add-port=3260/tcp
firewall-cmd --reload
```

## 配置iSCSI客户端

红帽RHEL7系统已经默认安装了iscsi客户端服务程序：

```bash
yum install iscsi-initiator-utils
```

编辑的iscsi客户端名称文件：
该名称是initiator客户端的唯一标识。

```bash
vim /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2003-01.org.linux-scsi.linuxprobe.x8664:sn.d497c356ad80:client
```

重启iscsi客户端服务程序：

```bash
systemctl restart iscsid
```

将iscsi客户端服务程序添加到开机启动项中：

```bash
systemctl enable iscsid
```

发现iscsi服务端的可用存储设备：
iscsiadm命令用于管理（插入、查询、更新或删除）iSCSI数据库配置文件的命令行工具，格式见下面演示。

```bash
iscsiadm -m discovery -t st -p 192.168.10.10
192.168.10.10:3260,1 iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80
```

连接iscsi服务端的可用存储设备：

```bash
iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80 -p 192.168.10.10 --login
```

查看设备的UUID值：

```bash
blkid | grep /dev/sdb
/dev/sdb: UUID="eb9cbf2f-fce8-413a-b770-8b0f243e8ad6" TYPE="xfs"
```

设置为开机后自动挂载时因为iSCSI服务程序基于IP网络传输数据，所以我们必需在fstab文件中添加参数_netdev，代表网络联通后再挂载：

```bash
vim /etc/fstab
UUID=eb9cbf2f-fce8-413a-b770-8b0f243e8ad6 /iscsi xfs defaults,_netdev 0 0
```

卸载

```bash
iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80 -u
```

