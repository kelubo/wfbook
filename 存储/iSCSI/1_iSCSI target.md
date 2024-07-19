# iSCSI Target

[TOC]

## 方案1  targetd

1. 准备作为 LUN 发布的存储设备。

2. 安装 iSCSI target 服务程序及配置工具，并启动服务。

   ```bash
   yum install targetd targetcli
   dnf install targetd targetcli
   
   systemctl start targetd
   systemctl enable targetd
   ```

3. 创建存储对象。

   targetcli 命令用于管理 iSCSI target 存储设备，格式为：

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
     
   # /backstores/block 是 iSCSI 服务端配置共享设备的位置。
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

4. 配置iSCSI target目标。

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

5. 设置访问控制列表。iSCSI 协议是通过客户端名称进行验证的。用户在访问存储共享资源时不需要输入密码，只要 iSCSI 客户端的名称与服务端中设置的访问控制列表中某一名称条目一致即可，因此需要在 iSCSI 服务端的配置文件中写入一串能够验证用户信息的名称。acls 参数目录用于存放能够访问 iSCSI 服务端共享存储资源的客户端名称。

   切换到acls目录中：

   ```bash
   /iscsi/iqn.20...d80/tpg1/luns> cd ..
   /iscsi/iqn.20...c356ad80/tpg1> cd acls
   ```

   创建访问控制列表：

   ```bash
   /iscsi/iqn.20...d80/tpg1/acls> create iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80:client
   Created Node ACL for iqn.2003-01.org.linux-iscsi.linuxprobe.x8664:sn.d497c356ad80:client
   Created mapped LUN 0.
   ```

   切换到portals目录中：

   ```bash
   /iscsi/iqn.20...d80/tpg1/acls> cd ..
   /iscsi/iqn.20...c356ad80/tpg1> cd portals
   ```

   设置 iSCSI 服务端的监听 IP 地址和端口号。位于生产环境中的服务器上可能有多块网卡，可以进行选择。

   ```bash
   /iscsi/iqn.20.../tpg1/portals> create 192.168.10.10
   Using default IP port 3260
   Created network portal 192.168.10.10:3260.
   ```

   在配置文件中默认是允许所有网卡提供iSCSI服务，如果认为这有些许不安全，可以手动删除：

   ```bash
   /iscsi/iqn.20.../tpg1/portals> delete 0.0.0.0 3260
   Deleted network portal 0.0.0.0:3260
   ```

6. 查看配置概述后退出工具：

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

7. 创建防火墙允许规则：

   ```bash
   firewall-cmd --permanent  --add-port=3260/tcp
   firewall-cmd --reload
   ```

