# 配置设备作为SSH服务器

## 1.1 简介

本案例介绍配置设备作为SSH服务器的方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref79001870)所示，Switch作为SSH服务器，与客户端Host1和Host2之间路由可达。Host1和Host2需要通过SSH登录到Switch上对其进行相关配置。并要求：

·   Switch通过SSH的password认证方式和publickey认证方式分别对Host1和Host2进行认证，认证过程在Switch本地完成；

·   Host1的登录用户名为client001，密码为hello12345，登录设备后可以使用所有命令。

·   Host2的登录用户名为client002，使用的公钥算法为RSA，登录设备后可以使用所有命令。

图1 设备作为SSH服务器组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774759_x_Img_x_png_0_1816260_30005_0.png)

 

## 1.3 配置步骤

#### 1. 配置SSH客户端Host2

\# 生成RSA密钥对。

在客户端运行PuTTYGen.exe，在参数栏中选择“SSH-2 RSA”，点击<Generate>，产生客户端密钥对。

图2 生成客户端密钥（步骤1）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774760_x_Img_x_png_1_1816260_30005_0.png)

 

在产生密钥对的过程中需不停地移动鼠标，鼠标移动仅限于下图蓝色框中除绿色标记进程条外的地方，否则进程条的显示会不动，密钥对将停止产生，见[图3](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref258930577)。

图3 生成客户端密钥（步骤2）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774771_x_Img_x_png_2_1816260_30005_0.png)

 

密钥对产生后，点击<Save public key>，输入存储公钥的文件名key.pub，点击<保存>按钮。

图4 生成客户端密钥（步骤3）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774782_x_Img_x_png_3_1816260_30005_0.png)

 

点击<Save private key>存储私钥，弹出警告框，提醒是否保存没做任何保护措施的私钥，点击<Yes>，输入私钥文件名为private.ppk，点击保存。

图5 生成客户端密钥（步骤4）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774787_x_Img_x_png_4_1816260_30005_0.png)

 

客户端生成密钥对后，需要将保存的公钥文件key.pub通过FTP/TFTP方式上传到服务器，具体过程略。

#### 2. 配置SSH服务器

\# 配置设备生成RSA密钥对。

<Switch> system-view

[Switch] public-key local create rsa

The range of public key modulus is (512 ~ 4096).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

..

Create the key pair successfully.

\# 配置设备生成DSA密钥对。

[Switch] public-key local create dsa

The range of public key modulus is (512 ~ 2048).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

......

Create the key pair successfully.

\# 配置设备生成ECDSA密钥对。

[Switch] public-key local create ecdsa secp256r1

Generating Keys...

.

Create the key pair successfully.

\# 开启SSH服务器功能。

[Switch] ssh server enable

\# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。

[Switch] vlan 2

[Switch-vlan2] port ten-gigabitethernet 1/0/2

[Switch-vlan2] quit

\# 配置VLAN接口2的IP地址，客户端将通过该地址连接SSH服务器。

[Switch] interface vlan-interface 2

[Switch-Vlan-interface2] ip address 192.168.1.40 255.255.255.0

[Switch-Vlan-interface2] quit

\# 配置VTY用户线的认证方式为scheme，SSH客户端使用VTY用户线登录设备。

[Switch] line vty 0 63

[Switch-line-vty0-63] authentication-mode scheme

[Switch-line-vty0-63] quit

\# 创建本地用户client001，并设置用户密码为hello12345、服务类型为SSH、用户角色为network-admin。

[Switch] local-user client001 class manage

New local user added.

[Switch-luser-manage-client001] password simple hello12345

[Switch-luser-manage-client001] service-type ssh

[Switch-luser-manage-client001] authorization-attribute user-role network-admin

[Switch-luser-manage-client001] quit

\# 从文件key.pub中导入远端的公钥，并命名为switchkey。

[Switch] public-key peer switchkey import sshkey key.pub

\# 设置SSH用户client002的认证方式为publickey，并指定公钥为switchkey。

[Switch] ssh user client002 service-type stelnet authentication-type publickey assign publickey switchkey

\# 创建设备管理类本地用户client002，并设置服务类型为SSH，用户角色为network-admin。

[Switch] local-user client002 class manage

New local user added.

[Switch-luser-manage-client002] service-type ssh

[Switch-luser-manage-client002] authorization-attribute user-role network-admin

[Switch-luser-manage-client002] quit

## 1.4 验证配置

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774788_x_Img_x_png_5_1816260_30005_0.png)

SSH客户端软件很多，本文中以客户端软件PuTTY0.60为例说明SSH客户端的配置方法。

 

\# 安装PuTTY0.60软件。

\# 打开PuTTY.exe程序，点击“Session”功能区，出现如[图6](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref339530216)所示的客户端配置界面。

·   在“Host Name（or IP address）”文本框中输入SSH服务器的IP地址为192.168.1.40。

·   在“Port”文本框中输入SSH协议端口号22。

·   在“Connection type”区域选择SSH协议。

图6 SSH客户端配置界面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774789_x_Img_x_png_6_1816260_30005_0.png)

 

#### 1. Host1端client001用password认证方式连接SSH服务器。

\# 在[图6](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref339530216)界面中，单击<Open>按钮。弹出“PuTTY Security Alert”对话框。

图7 SSH客户端登录界面（一）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774790_x_Img_x_png_7_1816260_30005_0.png)

 

\# 单击“Yes”按钮，并输入用户名“client001”和密码“hello12345”（输入密码的不会显示），即可成功登录设备并使用所有命令。

图8 SSH客户端登录界面（二）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774791_x_Img_x_png_8_1816260_30005_0.png)

 

#### 2. Host2端client002用RSA认证方式连接SSH服务器。

\# 单击左侧导航栏“Connection->SSH”，出现如[图9](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref340839251)的界面。选择“Preferred SSH protocol version”为“2”。

图9 Stelnet客户端配置界面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774792_x_Img_x_png_9_1816260_30005_0.png)

 

单击左侧导航栏“Connection->SSH”下面的“Auth”（认证），出现如[图10](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref155692920)的界面。单击<Browse…>按钮，弹出文件选择窗口。选择与配置到服务器端的公钥对应的私钥文件private.ppk。

图10 Stelnet客户端配置界面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774761_x_Img_x_png_10_1816260_30005_0.png)

 

单击<Open>按钮。按提示输入用户名client002，即可进入Switch的配置界面。

## 1.5 配置文件

\#

vlan 2

\#

interface Vlan-interface2

 ip address 192.168.1.40 255.255.255.0

\#

interface Ten-GigabitEthernet1/0/2

 port access vlan 2

\#

line vty 0 63

 authentication-mode scheme

\#

ssh server enable

\#

local-user client001 class manage

 password hash $h$6$CqMnWdX6LIW/hz2Z$4+0Pumk+A98VlGVgqN3n/mEi7hJka9fEZpRZIpSNi9b

cBEXhpvIqaYTvIVBf7ZUNGnovFsqW7nYxjoToRDvYBg==

 service-type ssh

 authorization-attribute user-role network-admin

 authorization-attribute user-role network-operator

\#

public-key peer clientkey import sshkey key.pub

ssh user client002 service-type stelnet authentication-type publickey assign publickey ackey

\#

local-user client002 class manage

 service-type ssh

 authorization-attribute user-role network-admin

\#

## 1.6 相关资料

·   产品配套“安全配置指导”中的“SSH”。

·   产品配套“安全命令参考”中的“SSH”。



 

# 2 配置设备作为SSH客户端

## 2.1 简介

本案例介绍配置设备作为SSH客户端的方法。

## 2.2 组网需求

如[图11](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref358538196)所示，Switch A作为SSH客户端，Switch B作为SSH服务器，Switch A采用SSH协议远程登录到Switch B上。并要求：

·   Switch B采用本地认证的方式认证用户，认证方式为password认证。

·   登录用户名为client001，密码为hello12345，登录设备后可以使用所有命令。

图11 设备作为SSH客户端配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774762_x_Img_x_png_11_1816260_30005_0.png)

 

## 2.3 配置步骤

#### 1. 配置Switch A

\# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。

<SwitchA> system-view

[SwitchA] vlan 2

[SwitchA-vlan2] port ten-gigabitethernet 1/0/2

[SwitchA-vlan2] quit

\# 配置VLAN接口2的IP地址。

[SwitchA] interface vlan-interface 2

[SwitchA-Vlan-interface2] ip address 192.168.1.56 255.255.255.0

[SwitchA-Vlan-interface2] quit

#### 2. 配置Switch B

请参见[1 ](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref82076426)[配置设备作为SSH服务器](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref82076429)配置Switch B作为SSH服务器。

## 2.4 验证配置

\# Switch A建立到服务器192.168.1.40的SSH连接。输入正确的用户名后根据提示输入Y确认，然后输入N不保存公钥，最后输入密码，即可成功登录到Switch B上，用户角色为network-admin。

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774763_x_Img_x_png_12_1816260_30005_0.png)

若输入Y保存公钥，当Switch B公钥变化时，需要在Switch A系统视图下执行delete ssh client server-public-key命令删除已保存的公钥才能再次建立连接。

 

<SwitchA> ssh2 192.168.1.40 

Username: client001

Press CTRL+C to abort.

Connecting to 192.168.1.40 port 22.

The server is not authenticated. Continue? [Y/N]:Y

Do you want to save the server public key? [Y/N]:N

Enter password:

 

******************************************************************************

\* Copyright (c) 2004-2021 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<SwitchB>

## 2.5 配置文件

·   Switch A

\#

vlan 2

\#

interface Vlan-interface2

ip address 192.168.1.56 255.255.255.0

\#

interface Ten-GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 2

\#

·   Switch B

请参见[1.5 ](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref82080039)[配置文件](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref82080043)查看Switch B的配置文件。

## 2.6 相关资料

·   产品配套“安全配置指导”中的“SSH”。

·   产品配套“安全命令参考”中的“SSH”。



# 3 配置SSH用户的RADIUS认证和授权

## 3.1 简介

本案例介绍SSH用户的RADIUS认证和授权的配置方法。

## 3.2 组网需求

如[图12](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref358294798)所示，通过在作为NAS的Device上配置远程RADIUS认证、授权功能，实现SSH用户的安全登录。在网络架构上采用主从RADIUS服务器的方式来提高用户认证的稳定性。要求在Device上配置实现：

·   使用RADIUS服务器对登录Device的SSH用户进行认证和授权，登录用户名为hello*@*bbb，密码为aabbcc；

·   Device向RADIUS服务器发送的用户名带域名，服务器根据用户名携带的域名来区分提供给用户的服务。

·   用户通过认证后可执行系统所有功能和资源的相关**display**命令。

图12 SSH用户的远端RADIUS认证和授权配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774764_x_Img_x_png_13_1816260_30005_0.png)

 

## 3.3 配置步骤

#### 1. 配置RADIUS服务器

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774765_x_Img_x_png_14_1816260_30005_0.png)

·   本节以iMC为例（使用iMC版本为：iMC PLAT 7.0(E0102)、iMC EIA 7.0(E0201)），说明该例中RADIUS服务器的基本配置。

·   主从RADIUS服务器设置相同，本节以主RADIUS服务器设置为例。

 

\# 登录进入iMC管理平台，选择“用户”页签，单击导航树中的[接入策略管理/接入设备管理/接入设备配置]菜单项，进入接入设备配置页面，在该页面中单击“增加”按钮，进入增加接入设备页面。

·   设置与Device交互报文时使用的认证和授权共享密钥为“expert”；

·   设置认证及计费的端口号分别为“1812”（RADIUS服务器的认证端口为UDP端口1812）和“1813”（RADIUS服务器的计费端口为UDP端口1813）；

·   选择业务类型为“设备管理业务”；

·   选择接入设备类型为“H3C(General)”；

·   选择或手工增加接入设备，添加IP地址为10.1.1.2的接入设备；

·   其它参数采用缺省值，并单击<确定>按钮完成操作。

图13 增加接入设备

![2014-03-26_140058.png](https://resource.h3c.com/cn/202303/28/20230328_8774766_x_Img_x_png_15_1816260_30005_0.png)

 

\# 选择“用户”页签，单击导航树中的[接入用户管理视图/设备管理用户]菜单项，进入设备管理用户列表页面，在该页面中单击<增加>按钮，进入增加设备管理用户页面。

·   输入用户名“hello@bbb”和密码。

·   选择服务类型为“SSH”。

·   输入用户角色名“network-operator”

·   添加所管理设备的IP地址，IP地址范围为“10.1.1.0～10.1.1.255”。

·   单击<确定>按钮完成操作。

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774767_x_Img_x_png_16_1816260_30005_0.png)

添加的所管理设备的IP地址范围要包含添加的接入设备的IP地址。

 

图14 增加设备管理用户

![img](https://resource.h3c.com/cn/202303/28/20230328_8774768_x_Img_x_png_17_1816260_30005_0.png)

 

#### 2. 配置Device

\# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。

<Device> system-view

[Device] vlan 2

[Device-vlan2] port ten-gigabitethernet 1/0/2

[Device-vlan2] quit

\# 配置VLAN接口2的IP地址。

[Device] interface vlan-interface 2

[Device-Vlan-interface2] ip address 192.168.1.70 255.255.255.0

[Device-Vlan-interface2] quit

\# 创建VLAN 3，并将Ten-GigabitEthernet1/0/1加入VLAN 3。

[Device] vlan 3

[Device-vlan3] port ten-gigabitethernet 1/0/1

[Device-vlan3] quit

\# 配置VLAN接口3的IP地址。

[Device] interface vlan-interface 3

[Device-Vlan-interface3] ip address 10.1.1.2 255.255.255.0

[Device-Vlan-interface3] quit

\# 生成RSA密钥对。

[Device] public-key local create rsa

The range of public key modulus is (512 ~ 4096).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

...........

Create the key pair successfully.

\# 生成DSA密钥对。

[Device] public-key local create dsa

The range of public key modulus is (512 ~ 2048).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

.......

Create the key pair successfully.

\# 生成secp256r1类型的ECDSA密钥对。

[Device] public-key local create ecdsa secp256r1

Generating Keys...

Create the key pair successfully.

\# 生成secp384r1类型的ECDSA密钥对。

[Device] public-key local create ecdsa secp384r1

Generating Keys...

.

Create the key pair successfully.

\# 开启SSH服务器功能。

[Device] ssh server enable

\# 配置SSH用户登录采用AAA认证方式。

[Device] line vty 0 63

[Device-line-vty0-63] authentication-mode scheme

[Device-line-vty0-63] quit

\# 创建RADIUS方案rad。

[Device] radius scheme rad

\# 配置主认证服务器的IP地址为10.1.1.1，认证端口号为1812。

[Device-radius-rad] primary authentication 10.1.1.1 1812

\# 配置从认证服务器的IP地址为10.1.1.11，认证端口号为1812。

[Device-radius-rad] secondary authentication 10.1.1.11 1812

\# 配置主计费服务器的IP地址为10.1.1.1，计费端口号为1813。

[Device-radius-rad] primary accounting 10.1.1.1 1813

\# 配置从计费服务器的IP地址为10.1.1.11，计费端口号为1813。

[Device-radius-rad] secondary accounting 10.1.1.11 1813

 \# 配置与认证和计费服务器交互报文时的共享密钥为明文expert。

[Device-radius-rad] key authentication simple expert

[Device-radius-rad] key accounting simple expert

\# 配置向RADIUS服务器发送的用户名要携带域名。

[Device-radius-rad] user-name-format with-domain

[Device-radius-rad] quit

\# 创建ISP域bbb，为login用户配置AAA认证方法为RADIUS认证、授权和计费。

[Device] domain bbb

[Device-isp-bbb] authentication login radius-scheme rad

[Device-isp-bbb] authorization login radius-scheme rad

[Device-isp-bbb] accounting login radius-scheme rad

[Device-isp-bbb] quit

## 3.4 验证配置

用户向Device发起SSH连接，在SSH客户端按照提示输入用户名hello*@*bbb和密码aabbcc通过认证，并且获得用户角色network-operator（用户通过认证后可执行系统所有功能和资源的相关**display**命令）。

主服务器可达时，设备与主RADIUS服务器进行交互。

\# 显示主服务器可达时的RADIUS方案的配置信息。

<Sysname> display radius scheme

Total 1 RADIUS schemes

 

\------------------------------------------------------------------

RADIUS scheme name: rad

 Index: 0

 Primary authentication server:

  Host name: Not Configured

  IP  : 10.1.1.1                 Port: 1812

  VPN : Not configured

  State: Active

  Test profile: Not configured

  Weight: 0

 Primary accounting server:

  Host name: Not Configured

  IP  : 10.1.1.1                 Port: 1813

  VPN : Not configured

  State: Active

  Weight: 0

 Second authentication server:

  Host name: Not Configured

  IP  : 10.1.1.11                Port: 1812

  VPN : Not configured

  State: Active

  Test profile: Not configured

  Weight: 0

 Second accounting server:

  Host name: Not Configured

  IP  : 10.1.1.11                Port: 1813

  VPN : Not configured

  State: Active

  Weight: 0

 Accounting-On function           : Disabled

  extended function            : Disabled

  retransmission times           : 50

  retransmission interval(seconds)     : 3

 Timeout Interval(seconds)         : 3

 Retransmission Times            : 3

 Retransmission Times for Accounting Update : 5

 Server Quiet Period(minutes)        : 5

 Realtime Accounting Interval(seconds)   : 720

 Stop-accounting packets buffering     : Enabled

  Retransmission times           : 500

 NAS IP Address               : Not configured

 VPN                    : Not configured

 User Name Format              : with-domain

 Data flow unit               : Byte

 Packet unit                : One

 Attribute 15 check-mode          : Strict

 Attribute 25                : Standard

 Attribute Remanent-Volume unit       : Kilo

 server-load-sharing            : Disabled

 Attribute 31 MAC format          : HH-HH-HH-HH-HH-HH

 Stop-accounting packets send-force     : Disabled

 Reauthentication server selection     : Inherit

主服务器不可达时，再查看RADIUS方案的配置信息，会发现主服务器的状态从Active变为Block。此时，设备变成与从RADIUS服务器进行交互。

## 3.5 配置文件

\#

vlan 2 to 3

\#

interface Vlan-interface2

 ip address 192.168.1.70 255.255.255.0

\#

interface Vlan-interface3

 ip address 10.1.1.2 255.255.255.0

\#

interface Ten-GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 2

\#

interface Ten-GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 3

\#

line vty 0 63

 authentication-mode scheme

 user-role network-operator

\#

 ssh server enable

\#

radius scheme rad

 primary authentication 10.1.1.1

 primary accounting 10.1.1.1

 secondary authentication 10.1.1.11

 secondary accounting 10.1.1.11

 key authentication cipher $c$3$GBZ1jhslcGwSOpSejsESMnOr8Gb8SIT5ew==

 key accounting cipher $c$3$nGb/DWK8pxbHaLXQVc+xsmbUr1etIZVd7Q==

\#

domain bbb

 authentication login radius-scheme rad

 authorization login radius-scheme rad

 accounting login radius-scheme rad

\#

## 3.6 相关资料

·   产品配套“安全配置指导”中的“SSH”和“AAA”。

·   产品配套“安全命令参考”中的“SSH”和“AAA”。



# 4 SSH用户的HWTACACS认证、授权、计费配置（ACS server）

## 4.1 简介

本案例介绍SSH用户的HWTACACS认证、授权、计费配置方法。

## 4.2 组网需求

程访问的安全性，需要在Device和管理员主机之间建立SSH连接，具体要求如下：

·   Device使用Cisco ACS server作为HWTACACS服务器对Stelnet客户端进行认证和授权；

·   管理员在主机上运行Stelnet客户端，并采用用户名manager@bbb和密码1234ab##登录Device，且登录后享有最高配置权限。

图15 SSH用户的HWTACACS认证和授权配置举例

![img](https://resource.h3c.com/cn/202303/28/20230328_8774769_x_Img_x_png_18_1816260_30005_0.png)

 

## 4.3 配置思路

·   为了保证Device可以使用ACS server认证用户，需要在ACS server上完成添加AAA client以及用户的相关配置。

·   为了要求用户通过用户线登录Device时输入用户名和密码，需要在Device上配置登录用户线的认证方式为scheme方式。

·   未了保证Device能够对登录用户进行认证和授权，需要在Device上完成AAA配置，包括配置ISP域，以及与HWTACACS服务器交互的TACACS方案。

·   为了保证管理员可以运行采用了不同公钥算法的Stelnet客户端与Device建立SSH连接，需要在Device上生成RSA、DSA、ECDSA密钥对。

·   为了使Stelnet用户登录设备后能享有最高配置权限，指定缺省用户角色为network-admin。

## 4.4 配置步骤

#### 1. 配置HWTACACS服务器

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774770_x_Img_x_png_19_1816260_30005_0.png)

·   本文以ACSv4.2为例，说明TACACS server的基本配置。

·   在进行下面的配置之前，请保证设备管理员的主机与ACS服务器之间路由可达。

 

(1)   登录ACS server

\# 如[图16](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref422415636)所示的Web登录页面中，输入Web登录用户名和密码，单击“Login”按钮，即可登录ACS server。

图16 登录ACS server

![img](https://resource.h3c.com/cn/202303/28/20230328_8774772_x_Img_x_png_20_1816260_30005_0.png)

 

(2)   添加接入设备

\# 在左侧导航栏中选择[Network Configuration]，打开网络配置界面，单击<Add Entry>，进入AAA Client的编辑页面。

图17 添加接入设备

![img](https://resource.h3c.com/cn/202303/28/20230328_8774773_x_Img_x_png_21_1816260_30005_0.png)

 

\# 在AAA Client的编辑页面中进行如下配置：

·   输入接入设备名称、接入设备IP地址、交互TACACS报文的共享密钥；

·   选择认证协议类型为“TACACS+ (Cisco IOS)”；

·   单击“Submit + Apply”按钮完成操作。

图18 配置接入设备

![img](https://resource.h3c.com/cn/202303/28/20230328_8774774_x_Img_x_png_22_1816260_30005_0.png)

 

(3)   添加登录用户

\# 在左侧导航栏中选择[User Setup]，打开用户配置界面，在文本框中输入用户名“manager”，单击“Add/Edit”后，进入该用户的编辑页面。

图19 添加登录用户

![img](https://resource.h3c.com/cn/202303/28/20230328_8774775_x_Img_x_png_23_1816260_30005_0.png)

 

\# 填写用户的相关信息，配置用户登录密码，选择用户所属组（本例中使用缺省组）。

图20 配置登录用户信息

![img](https://resource.h3c.com/cn/202303/28/20230328_8774776_x_Img_x_png_24_1816260_30005_0.png)

 

#### 2. 配置Device

\# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。

<Device> system-view

[Device] vlan 2

[Device-vlan2] port ten-gigabitethernet 1/0/2

[Device-vlan2] quit

\# 配置VLAN接口2的IP地址。

[Device] interface vlan-interface 2

[Device-Vlan-interface2] ip address 192.168.1.65 255.255.255.0

[Device-Vlan-interface2] quit

\# 创建VLAN 3，并将Ten-GigabitEthernet1/0/1加入VLAN 3。

[Device] vlan 3

[Device-vlan3] port ten-gigabitethernet 1/0/1

[Device-vlan3] quit

\# 配置VLAN接口3的IP地址。

[Device] interface vlan-interface 3

[Device-Vlan-interface3] ip address 10.1.1.2 255.255.255.0

[Device-Vlan-interface3] quit

\# 生成RSA密钥对。

[Device] public-key local create rsa

The range of public key modulus is (512 ~ 4096).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

...

Create the key pair successfully.

\# 生成DSA密钥对。

[Device] public-key local create dsa

The range of public key modulus is (512 ~ 2048).

If the key modulus is greater than 512, it will take a few minutes.

Press CTRL+C to abort.

Input the modulus length [default = 1024]:

Generating Keys...

........

Create the key pair successfully.

\# 生成secp256r1类型的ECDSA密钥对。

[Device] public-key local create ecdsa secp256r1

Generating Keys...

Create the key pair successfully.

\# 生成secp384r1类型的ECDSA密钥对。

[Device] public-key local create ecdsa secp384r1

Generating Keys...

.

Create the key pair successfully.

\# 使能SSH服务器功能。

[Device] ssh server enable

\# 设置Stelnet客户端登录用户界面的认证方式为scheme。

[Device] line vty 0 63

[Device-line-vty0-63] authentication-mode scheme

[Device-line-vty0-63] quit

\# 使能缺省用户角色授权功能，使得认证通过后的用户具有缺省的用户角色network-admin。

[Device] role default-role enable network-admin

\# 创建TACACS方案rad。

[Device] hwtacacs scheme tac

\# 配置主认证服务器的IP地址为10.1.1.1，认证端口号为49。

[Device-hwtacacs-tac] primary authentication 10.1.1.1 49

\# 配置与认证服务器交互报文时的共享密钥为明文expert。

[Device-hwtacacs-tac] key authentication simple expert

\# 配置主授权服务器的IP地址为10.1.1.1，授权端口号为49。

[Device-hwtacacs-tac] primary authorization 10.1.1.1 49

\# 配置与授权服务器交互报文时的共享密钥为明文expert。

[Device-hwtacacs-tac] key authorization simple expert

\# 配置向TACACS服务器发送的用户名不携带域名。

[Device-hwtacacs-tac] user-name-format without-domain

[Device-hwtacacs-tac] quit

\# 创建ISP域bbb，为login用户配置AAA认证方法为TACACS认证/授权、不计费。

[Device] domain bbb

[Device-isp-bbb] authentication login hwtacacs-scheme tac

[Device-isp-bbb] authorization login hwtacacs-scheme tac

[Device-isp-bbb] accounting login none

[Device-isp-bbb] quit

## 4.5 验证配置

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774777_x_Img_x_png_25_1816260_30005_0.png)

Stelnet客户端软件有很多，例如PuTTY、OpenSSH等。本文中仅以客户端软件PuTTY0.58为例，说明Stelnet客户端的配置方法。

 

\# 安装PuTTY 0.58软件。

\# 打开PuTTY.exe程序，点击“Session”功能区，在[图21](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref422417060)所示的配置界面中进行如下配置：

·   在“Host Name（or IP address）”文本框中输入Stelnet服务器的IP地址为192.168.1.65。

·   在“Port”文本框中输入SSH协议端口号22。

·   在“Connection type”区域选择SSH协议。

\# 单击<Open>按钮。

图21 Stelnet客户端配置界面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774778_x_Img_x_png_26_1816260_30005_0.png)

 

\# 如果弹出[图22](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref422418527)所示“PuTTY Security Alert”对话框，请根据实际情况做出选择。本例中选择信任该服务器，则单击“Yes”按钮。

图22 Stelnet客户端登录界面（一）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774779_x_Img_x_png_27_1816260_30005_0.png)

 

\# 如果弹出[图23](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref422418550)所示“PuTTY Security Alert”对话框，请根据实际情况做出选择。本例中选择信任该主机密钥，则单击“Yes”按钮。

图23 Stelnet客户端登录界面（二）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774780_x_Img_x_png_28_1816260_30005_0.png)

 

\# 在如下登录界面中输入用户名manager@bbb和密码1234ab##，即可成功登录设备使用所有命令。

login as: manager@bbb

manager@bbb@192.168.1.65's password:

 

******************************************************************************

\* Copyright (c) 2004-2018 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<Device>

## 4.6 配置文件

\#

vlan 2 to 3

\#

interface Vlan-interface2

 ip address 192.168.1.65 255.255.255.0

\#

interface Vlan-interface3

 ip address 10.1.1.2 255.255.255.0

\#

interface Ten-GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 2

\#

interface Ten-GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 3

\#

line vty 0 63

 authentication-mode scheme

 user-role network-operator

\#

ssh server enable

\#

hwtacacs scheme tac

 primary authentication 10.1.1.1

 primary authorization 10.1.1.1

 key authentication cipher $c$3$/9bCuPjMxjOtUvBx8NjtN+AnAsuLT2SrNA==

 key authorization cipher $c$3$QF/fFJNv9IyKyFlsNOpeBYnDXArNhOvOdQ==

 user-name-format without-domain

\#

domain bbb

 authentication login hwtacacs-scheme tac

 authorization login hwtacacs-scheme tac

 accounting login none

\#

role default-role enable network-admin

\#

## 4.7 相关资料

·   产品配套“安全配置指导”中的“SSH”。

·   产品配套“安全命令参考”中的“SSH”。

·   产品配套“安全配置指导”中的“AAA”。

·   产品配套“安全命令参考”中的“AAA”。



# 5 SSH用户的AAA local认证配置

## 5.1 简介

本案例介绍SSH用户的AAA local认证配置方法。

## 5.2 组网需求

通过配置Switch实现AAA local认证。SSH用户的用户名为client001，密码为hello12345，登录设备后可以使用所有命令。

图24 SSH用户local认证配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774781_x_Img_x_png_29_1816260_30005_0.png)

 

## 5.3 配置步骤

\# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。

[Switch] vlan 2

[Switch-vlan2] port ten-gigabitethernet 1/0/2

[Switch-vlan2] quit

\# 配置VLAN接口2的IP地址，客户端将通过该地址连接SSH服务器。

[Switch] interface vlan-interface 2

[Switch-Vlan-interface2] ip address 192.168.1.40 255.255.255.0

[Switch-Vlan-interface2] quit

\# 创建本地RSA及DSA密钥对。

<Switch> system-view

[Switch] public-key local create rsa

[Switch] public-key local create dsa

\# 使能SSH服务器功能。

[Switch] ssh server enable

\# 设置SSH用户登录用户线的认证方式为AAA认证。

[Switch] line vty 0 63

[Switch-line-vty0-63] authentication-mode scheme

[Switch-line-vty0-63] quit

\# 创建本地用户client001，并设置用户密码为hello12345、服务类型为SSH、用户角色为network-admin。

[Switch] local-user client001 class manage

New local user added.

[Switch-luser-manage-client001] password simple hello12345

[Switch-luser-manage-client001] service-type ssh

[Switch-luser-manage-client001] authorization-attribute user-role network-admin

[Switch-luser-manage-client001] quit

\# 创建ISP域bbb，为login用户配置AAA认证方法为本地认证。

[Switch] domain bbb

[Switch-isp-bbb] authentication login local

[Switch-isp-bbb] quit

## 5.4 验证配置

![说明](https://resource.h3c.com/cn/202303/28/20230328_8774783_x_Img_x_png_30_1816260_30005_0.png)

SSH客户端软件很多，本文中以客户端软件PuTTY0.60为例说明SSH客户端的配置方法。

 

\# 安装PuTTY0.60软件。

\# 打开PuTTY.exe程序，点击“Session”功能区，出现如[图25](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref127202202)所示的客户端配置界面。

·   在“Host Name（or IP address）”文本框中输入SSH服务器的IP地址为192.168.1.40。

·   在“Port”文本框中输入SSH协议端口号22。

·   在“Connection type”区域选择SSH协议。

图25 SSH客户端配置界面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774784_x_Img_x_png_31_1816260_30005_0.png)

 

\# 在[图25](https://www.h3c.com/cn/d_202303/1816260_30005_0.htm#_Ref127202202)界面中，单击<Open>按钮。弹出“PuTTY Security Alert”对话框。

图26 SSH客户端登录界面（一）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774785_x_Img_x_png_32_1816260_30005_0.png)

 

\# 单击“Yes”按钮，并输入用户名“client001”和密码“hello12345”（输入密码的不会显示），即可成功登录设备并使用所有命令。

图27 SSH客户端登录界面（二）

![img](https://resource.h3c.com/cn/202303/28/20230328_8774786_x_Img_x_png_33_1816260_30005_0.png)

 

 

## 5.5 配置文件

 

\#

vlan 2

\#

interface Vlan-interface2

 ip address 192.168.1.40 255.255.255.0

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 2

\#

line vty 0 63

 authentication-mode scheme

 user-role network-operator

\#

 ssh server enable

\#

domain bbb

 authentication login local

\#

local-user client001 class manage

 password hash $h$6$rLDGxBtUHlyovI15$k8yc//6l73h6CRK89jqTVf8Hu6VicbEl5EjUPqzykYj33YSQxPdHrSr+BIMeZUZDfsRAiy28ME9Vhb7VcVXpZw==

 service-type ssh

 authorization-attribute user-role network-admin

 authorization-attribute user-role network-operator

\#