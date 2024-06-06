#  登录设备

## 1.1 通过Console口连接设备，为什么配置终端无显示或显示乱码？

设备上电后，通过Console口连接的配置终端无显示信息或显示乱码，首先应检查：电源是否正常；以及配置口（Console口）电缆是否正确连接。如果以上检查未发现问题，很可能是配置电缆有问题或者终端参数的设置错误，请确认终端的参数设置：

·   波特率：9600

·   数据位：8

·   停止位：1

·   奇偶校验：无

·   流量控制：无

确认终端参数设置正确但故障无法解决时，请更换配置电缆进行替换测试。

## 1.2 如何恢复Console口密码？

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458694_x_Img_x_png_1_1644624_30005_0.png)

建议优先使用方法一恢复Console口密码，如果忘记所有登录设备的密码，再使用其他方法。

 

#### 1. 方法一：通过Stelnet/telnet登录设备修改Console口密码。

(1)   通过Stelnet/telnet登录设备。

(2)   进入系统视图。

system-view

(3)   进入AUX用户线或AUX用户线类视图。

¡   进入AUX用户线视图。

line aux first-number [ last-number ]

¡   进入AUX用户线类视图。

line class aux

(4)   设置登录用户的认证方式为密码认证。

authentication-mode password

(5)   设置认证密码。

set authentication password { hash | simple } password

(6)   配置从当前用户线登录设备的用户角色。

user-role role-name

#### 2. 方法二：通过bootware菜单选择跳过配置文件启动后手工修改console口密码。

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458705_x_Img_x_png_2_1644624_30005_0.png)

不同产品的bootware页面可能有所不同，此处以S5130系列以太网交换机为例。

 

(1)   通过console口连接设备后将设备重新启动。

(2)   设备重启时按下Ctrl+B进入bootware菜单，选择跳过当前配置启动，如[图1-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699703)所示。

图1-1 进入bootware菜单并跳过当前配置启动

![img](https://resource.h3c.com/cn/202207/07/20220707_7458711_x_Img_x_png_3_1644624_30005_0.png)

 

(3)   选择Reboot重启设备，如[图1-2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699718)所示。

图1-2 重启设备

![img](https://resource.h3c.com/cn/202207/07/20220707_7458712_x_Img_x_png_4_1644624_30005_0.png)

 

(4)   设备重启时按下Ctrl+C或Ctrl+D跳过自动配置，如[图1-3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699727)所示。

图1-3 跳过自动配置

![img](https://resource.h3c.com/cn/202207/07/20220707_7458713_x_Img_x_png_5_1644624_30005_0.png)

 

(5)   按下Enter键成功跳过配置文件启动。

(6)   查看配置文件内容。

more startup.cfg

(7)   将配置文件全部选中后复制粘贴到本地，如[图1-4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699742)与[图1-5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699756)所示

图1-4 导出配置文件（一）

![img](https://resource.h3c.com/cn/202207/07/20220707_7458714_x_Img_x_png_6_1644624_30005_0.png)

 

图1-5 导出配置文件（二）

![img](https://resource.h3c.com/cn/202207/07/20220707_7458715_x_Img_x_png_7_1644624_30005_0.png)

 

(8)   修改配置文件，配置新密码为hello12345，如[图1-6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63699773)所示

图1-6 配置新密码

![img](https://resource.h3c.com/cn/202207/07/20220707_7458716_x_Img_x_png_8_1644624_30005_0.png)

 

(9)   进入系统视图。

system-view

(10)   将修改后的配置文件复制粘贴到设备，如[图1-7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref63597661)所示。

图1-7 导入配置文件

![img](https://resource.h3c.com/cn/202207/07/20220707_7458717_x_Img_x_png_9_1644624_30005_0.png)

 

(11)   保存配置。

save

(12)   重启设备。

Reboot

#### 3. 方法三：通过bootware菜单选择跳过配置文件启动后配置回滚。

(1)   通过方法二跳过配置文件启动后进入系统视图。

system-view

(2)   将当前配置回滚至默认配置文件startup.cfg中的配置状态

configuration replace file startup.cfg

(3)   输入N，选择不保存当前配置。

(4)   等待配置回滚完成后进入系统视图。

system-view

(5)   进入AUX用户线或AUX用户线类视图。

¡   进入AUX用户线视图。

line aux first-number [ last-number ]

¡   进入AUX用户线类视图。

line class aux

(6)   设置登录用户的认证方式为密码认证。

authentication-mode password

(7)   设置认证密码。

set authentication password { hash | simple } password

(8)   配置从当前用户线登录设备的用户角色。

user-role role-name

#### 4. 方法四：通过bootware菜单选择跳过配置文件启动后将设备恢复出厂设置。

![注意](https://resource.h3c.com/cn/202207/07/20220707_7458695_x_Img_x_png_10_1644624_30005_0.png)

此操作会清空设备所有配置，请确保当前业务不会受到影响时再进行。

 

(1)   通过方法二跳过配置文件启动后保存当前空配置。

save

(2)   重启设备。

reboot

## 1.3 如何修改web登录密码？

可以通过Console口、Stelnet/telnet等方式登录设备后设置新的web登录密码。

(1)   通过Console口、Stelnet/telnet等方式登录设备。

(2)   进入系统视图。

system-view

(3)   进入用于Web登录的本地用户视图。

**local-user** *user-name*

(4)   修改用户的密码。

**Password** [ { **hash** | **simple** } *password* ]

# 2 用户权限

## 2.1 为什么无法执行某些命令或提示配置权限不足？

可能是当前用户角色的权限不足，请使用具有network-admin角色的用户登录设备再次尝试。

# 3 设备管理

## 3.1 对于支持可插拔风扇模块的设备，开机后SYS灯红色常亮该如何解决？

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458696_x_Img_x_png_11_1644624_30005_0.png)

不同产品的指示灯情况有所不同，此处以S5560X-EI系列以太网交换机为例，各产品的具体情况请参考对应的安装指导。

 

支持可插拔风扇模块的设备，若风扇模块正常，但风扇模块的实际风道风向与设备期望的风扇模块的风道风向不一致，则设备系统指示灯（SYS灯）异常（红色常亮），但风扇模块的指示灯正常（黄色常亮），此时风扇运行噪音通常比较大，设备会打印风扇告警的日志信息。

风扇模块的实际风道方向，由所选风扇模块的型号决定。通常有：端口侧进风、电源侧出风或电源侧进风、端口侧出风两种。可查看对应的风扇手册了解；也可以通过在设备上执行display fan命令，查看字段“Airflow Direction”（风扇模块的实际风道方向）了解。

设备期望的风扇模块的风道方向，支持通过命令行进行配置，并可通过执行display fan命令，查看字段“Prefer Airflow Direction”（期望的风扇模块的风道方向）了解。

<Sysname> display fan

 Slot 1:

 Fan 1:

 State  : Normal

 Airflow Direction: Port-to-power

 Prefer Airflow Direction: Port-to-power

当二者不一致时，可通过系统视图下的fan prefer-direction命令调整设备期望的风道方向，使其与风扇模块的实际风道方向一致。

·   指定参数port-to-power，表示期望风道方向为端口侧进风，电源侧出风。

·   指定参数power-to-port，表示期望风道方向为电源侧进风，端口侧出风。

需要注意的是：设备上电后，是否检查风扇模块的实际风道风向与设备期望的风扇模块的风道风向一致，与产品和软件版本有关。各产品的具体情况请参考安装指导。

## 3.2 风扇模块没有正确安装会引起什么故障？

当风扇模块没有正确安装时，可能引起的故障包括但不限于：设备上电后无法启动、设备低负载运行但风扇声音很大、设备自动关机、设备温度过高、打印报错日志等。以下情况属于风扇模块没有正确安装：

·   风扇模块没有插到位或松动

·   安装的风扇模块不是适配的型号

·   没有安装风扇模块或仅安装一个风扇模块

·   安装的2个风扇模块的型号不同（风道风向不一致）

·   风扇实际的风道风向与期望的风道风向不一致

设备出现以上故障且用户发现风扇模块没有正确安装时，应及时重新安装风扇模块，确保设备安装两个适配的、相同型号的风扇模块，保证风扇模块插到位，并将期望的风道风向和风扇模块实际的风道风向配置成一致。

## 3.3 BIDI型号的光模块能否与其他光模块混合使用？

不可以，BIDI型号的光模块必须成对使用。例如SFP-XG-LX-SM1270-BIDI必须和SFP-XG-LX-SM1330-BIDI成对使用，否则光模块无法正常工作。关于设备支持的BIDI光模块型号及可以成对使用的型号，请查看设备的硬件安装指导。

## 3.4 为什么以太网端口正常的情况下，设备上的对应的以太网端口指示灯不亮？

在指示灯未损坏的情况下，若设备的前面板有端口状态指示灯模式切换按钮（MODE按钮），则有以下可能：

·   设备是PoE机型

¡   当端口模式指示灯呈绿色闪烁状态时，此时设备的端口处于PoE模式。在这种模式下，若设备端口未使能PoE功能，端口的指示灯是不亮的。

¡   当端口模式指示灯呈黄色闪烁状态时，此时设备的端口处于IRF模式。在这种模式下，端口状态指示灯绿色常亮表示设备的成员编号，其他灯灭。

·   设备是非PoE机型

¡   当端口模式指示灯呈黄色闪烁状态时，此时设备的端口处于IRF模式。在这种模式下，端口状态指示灯绿色常亮表示设备的成员编号，其他灯灭。

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458697_x_Img_x_png_12_1644624_30005_0.png)

当端口处于IRF模式时，若设备的成员编号为n：对于S5560X-EI系列、S6520X-EI、S6520X-HI等系列，编号为n的端口状态指示灯绿色常亮，其它灯灭；对于S5130S-EI、S5130S-HI、S5560S-EI等系列，编号为1~n的端口状态指示灯绿色常亮，其他灯灭。关于端口状态指示灯模式切换按钮的介绍，请参见各产品安装指导里的指示灯介绍章节。

 

## 3.5 新增ACL时提示资源不足，可能的原因有哪些？

原因一：当前设备已达到ACL资源上限，请使用display qos-acl resource命令查看acl资源是否用尽，若用尽，请删除无用的ACL规则、QoS策略、策略路由等无关业务确保设备有足够的内存进行ACL新增。

原因二：设备达到了缺省内存告警门限，请使用display memory命令查看设备的内存使用情况，并通过释放内存来确保有足够的内存空间新增ACL。

原因三：误将内存告警门限配置得过低，导致设备异常认为达到了资源上限。可使用display memory-threshold命令来查看内存告警门限的相关信息，并使用undo memory-threshold命令用来恢复门限值缺省情况，保证设备剩余内存不在门限告警范围内即可正常创建acl。有关设备内存告警门限的配置请查看产品配套资料“基础配置”中的“设备管理”。

如果上述方法不能解决您的问题，请联系H3C技术支持。

## 3.6 交换机未运行业务，但CPU使用率高，如何解决？

请先使用display process cpu命令显示设备所有进程的CPU使用率信息，若发现是TMTH进程的CPU使用率过高，可通过如下方式排查：TMTH进程是端口训练进程，如果接口接了网线或者光模块但是对端无设备连接，设备会不断训练端口让其处于up状态，占用CPU。请排查下是否有将插入模块和网线但是未接终端的接口情况，如果有，请先将这些端口手动shutdown之后再使用display cpu-usage命令查看CPU利用率信息，确保CPU使用率恢复正常。

如果上述方法不能解决您的问题，请联系H3C技术支持。

# 4 IRF

## 4.1 将物理端口与IRF端口绑定时提示需要先将端口shutdown，如何解决？

将物理端口与IRF端口绑定时提示需要先将端口shutdown，输出类似如下提示（提示仅为示例，不同设备输出的提示信息可能有所区别）。

<Sysname> system-view

[Sysname-irf-port1/1] port group interface ten-gigabitethernet 1/0/1

Please shutdown the current interface first.

以如上设备显示为例，配置IRF物理端口的过程如下：

(1)   进入端口Ten-GigabitEthernet1/0/1视图，执行shutdown命令关闭端口；

(2)   进入IRF1/1端口配置端口Ten-GigabitEthernet1/0/1与IRF1/1端口绑定；

(3)   再次进入端口Ten-GigabitEthernet1/0/1视图，执行undo shutdown命令开启端口。

(4)   完成全部物理端口绑定后，执行save命令保存配置。

(5)   执行irf-port-configuration active命令激活IRF物理端口配置。

[Sysname] interface ten-gigabitethernet 1/0/1

[Sysname-Ten-GigabitEthernet1/0/1] shutdown

[Sysname] irf-port 1/1

[Sysname-irf-port1/1] port group interface ten-gigabitethernet 1/0/1

You must perform the following tasks for a successful IRF setup:

Save the configuration after completing IRF configuration.

Execute the "irf-port-configuration active" command to activate the IRF ports.

[Sysname-irf-port1/1] quit

[Sysname-Ten-GigabitEthernet1/0/1] undo shutdown

[Sysname-Ten-GigabitEthernet1/0/1] quit

[Sysname] save

The current configuration will be written to the device. Are you sure? [Y/N]:y

Please input the file name(*.cfg)[flash:/startup.cfg]

(To leave the existing filename unchanged, press the enter key):

Validating file. Please wait...

The startup.cfg file already exists.

Compared with the startup.cfg file, The current configuration adds 5 commands and d

eletes 1 commands.

If you want to see the configuration differences, please cancel this operation,

and then use the display diff command to show the details.

If you continue the save operation, the file will be overwritten.

Are you sure you want to continue the save operation? [Y/N]:y

Saving the current configuration to the file. Please wait...

Saved the current configuration to mainboard device successfully.

[Sysname] irf-port-configuration active

此步骤仅包含IRF物理端口的配置过程，IRF的全部配置过程请查看“虚拟化技术配置指导”中的“IRF”。

## 4.2 将物理端口与IRF端口绑定时失败，如何解决？

几个出现概率较高的原因为：

(1)   指定端口不支持作IRF物理端口。请查看配置指导确定该端口是否支持作IRF物理端口，选择支持作IRF物理端口的接口进行绑定。

(2)   IRF物理端口没有工作在最高速率下。部分产品要求IRF物理端口必须工作在最高速率下（拆分接口工作在拆分后的最高速率下即可）。对于有此要求的产品和端口，请更换对端端口或端口连接介质使IRF物理端口工作在最高速率下。

(3)   IRF物理端口的分组使用限制。

部分设备上存在端口分组，同一个IRF端口仅能绑定同一组的物理端口。产品对IRF物理端口的具体要求请参见“虚拟化技术配置指导”中的“IRF”或安装指导。

如果上述方法不能解决您的问题，请联系H3C技术支持。

## 4.3 将物理端口与IRF端口绑定时提示某些端口为一组需要将这些端口全部关闭，如何解决？

将物理端口与IRF端口绑定时提示某些端口为一组需要将这些端口全部关闭，输出类似如下提示（提示仅为示例，不同设备输出的提示信息可能有所区别）。

<Sysname> system-view

[Sysname]irf-port 1/2

[Sysname-irf-port1/2]port group interface Twenty-FiveGigE 1/0/13:1

Check failed for reason:

 Twenty-FiveGigE1/0/13:2, Twenty-FiveGigE1/0/13:3 and Twenty-FiveGigE1/0/13:4 be

long to a port group, Please shutdown all of them before changing the working mo

de.

某些设备上存在IRF物理端口按组使用限制，即一组端口必须全部作为普通业务端口或全部作为IRF物理端口，在这些设备上将物理端口与IRF端口绑定时，如果系统判断有同组端口处于UP状态，则不允许绑定，需要将同组端口全部配置shutdown关闭后才允许绑定。哪些端口属于同一组可以查看显示信息或者配置指导。

以如上设备显示为例，配置IRF物理端口的过程如下：

(1)   进入Twenty-FiveGigE1/0/13:1、Twenty-FiveGigE1/0/13:2、Twenty-FiveGigE1/0/13:3、Twenty-FiveGigE1/0/13:4端口组视图，执行shutdown命令关闭端口；

(2)   进入IRF1/2端口视图，配置端口Twenty-FiveGigE1/0/13:1与IRF1/2端口绑定；

(3)   再次进入端口Twenty-FiveGigE1/0/13:1视图，执行undo shutdown命令开启端口。同组端口中，其他未与IRF端口绑定的物理端口不允许开启。

(4)   完成全部物理端口绑定后，执行save命令保存配置。

(5)   执行irf-port-configuration active命令激活IRF物理端口配置。

[Sysname] interface range twenty-fivegige 1/0/13:1 twenty-fivegige 1/0/13:2 twenty-fivegige 1/0/13:3 twenty-fivegige 1/0/13:4

[Sysname-if-range] shutdown

[Sysname-if-range] quit

[Sysname] irf-port 1/2

[Sysname-irf-port1/2] port group interface twenty-fivegige 1/0/13:1

You must perform the following tasks for a successful IRF setup:

Save the configuration after completing IRF configuration.

Execute the "irf-port-configuration active" command to activate the IRF ports.

[Sysname-irf-port1/2] quit

[Sysname-Twenty-FiveGigE1/0/13:1] undo shutdown

[Sysname-Twenty-FiveGigE1/0/13:1] quit

[Sysname] save

The current configuration will be written to the device. Are you sure? [Y/N]:y

Please input the file name(*.cfg)[flash:/startup.cfg]

(To leave the existing filename unchanged, press the enter key):

Validating file. Please wait...

The startup.cfg file already exists.

Compared with the startup.cfg file, The current configuration adds 5 commands and d

eletes 1 commands.

If you want to see the configuration differences, please cancel this operation,

and then use the display diff command to show the details.

If you continue the save operation, the file will be overwritten.

Are you sure you want to continue the save operation? [Y/N]:y

Saving the current configuration to the file. Please wait...

Saved the current configuration to mainboard device successfully.

[Sysname] irf-port-configuration active

此步骤仅包含IRF物理端口的配置过程，IRF的全部配置过程请查看“虚拟化技术配置指导”中的“IRF”。

如果上述方法不能解决您的问题，请联系H3C技术支持。

## 4.4 使用undo shutdown命令开启端口时提示需要将一组端口全部与IRF端口绑定或全部取消绑定，如何解决？

使用undo shutdown命令开启端口时提示需要将一组端口全部与IRF端口绑定或全部取消绑定，输出类似如下提示（提示仅为示例，不同设备输出的提示信息可能有所区别）。

<Sysname> system-view

[Sysname] interface Twenty-FiveGigE 1/0/13:2

[Sysname-Twenty-FiveGigE1/0/13:2] undo shutdown

Bind all interfaces in the same group to IRF ports or cancel the bindings on all

 of them.

某些设备上存在IRF物理端口按组使用限制，即一组端口必须全部作为普通业务端口或全部作为IRF物理端口。在这些设备上使用undo shutdown命令开启端口时，如果系统判断有同组端口已经与IRF端口绑定，则不允许开启该端口，需要将该端口与IRF端口绑定或将同组端口全部与IRF端口解除绑定后才允许开启。在IRF端口执行display this命令可以查看已经与IRF端口绑定的物理端口，也可以通过配置指导查看IRF物理端口分组信息。

如果上述方法不能解决您的问题，请联系H3C技术支持。

## 4.5 完成IRF成员编号、IRF物理端口等配置，重启设备后没有形成IRF，是什么原因？

请确认是否进行了保存配置的操作。

盒式设备建议IRF的配置顺序如下：

·   进行物理端口与IRF端口绑定等配置；

·   执行save命令保存配置；

·   执行irf-port-configuration active命令激活IRF物理端口配置；

·   连接各成员设备间的IRF物理端口。

框式设备建议IRF的配置顺序如下：

·   进行物理端口与IRF端口绑定等配置；

·   执行save命令保存配置；

·   连接各成员设备间的IRF物理端口；

·   切换到IRF模式。

无法形成IRF的原因较多，忘记保存配置为容易疏忽、出现概率较高的一条。更多IRF无法形成的原因请查看故障处理手册。

## 4.6 执行irf-port-configuration active命令激活IRF物理端口的配置之后，设备提示由于XX配置不一致无法形成IRF，如何处理？

多台设备组成IRF时，部分涉及设备工作模式和资源使用的配置要求各成员设备配置相同，常见的有如下项目（不同产品上要求的项目和配置命令可能不同，产品的具体要求请参见“虚拟化技术配置指导”中的“IRF”）：

·   系统工作模式（通过system-working-mode命令配置）；

·   硬件资源模式（通过hardware-resource switch-mode命令配置或switch-mode命令配置）；

·   设备的聚合能力（通过link-aggregation capability命令配置）；

·   等价路由模式（通过ecmp mode命令配置）；

·   等价路由最大条数（通过max-ecmp-num命令配置）；

·   前缀大于64位的IPv6路由功能（通过hardware-resource routing-mode ipv6-128命令配置）；

·   VXLAN硬件资源模式（通过hardware-resource vxlan命令配置）。

如果设备在加入IRF的过程中检测到要求配置一致的项目与邻居成员设备不同，则无法加入IRF。例如，执行irf-port-configuration active命令激活IRF物理端口的配置之后设备输出如下提示信息：

[Sysname]irf-port-configuration a

[Sysname]irf-port-configuration active

[Sysname]%Jan 14 20:53:07:484 2013 H3C STM/6/STM_LINK_UP: IRF port 2 came up.

 

The max-ecmp-num and switch-mode settings should be the same across devices in an IRF fabric. The local max-ecmp-num setting is 8, and the local switch-mode setting is VXLAN. Please check the settings on the neighbor device connected to IRF-port 2.

%Jan 14 20:53:07:864 2013 H3C STM/3/STM_SOMER_CHECK: Neighbor of IRF port 2 can't be stacked.

%Jan 14 20:53:08:088 2013 H3C STM/3/STM_LINK_DOWN: IRF port 2 went down.

此时，请根据提示信息修改本设备配置或其他成员设备配置，使相关配置一致。不同设备上提示信息的描述可能不同，本文以上述显示信息提示的情况为例介绍：

(1)   查看本成员设备提示信息。提示信息显示所有成员设备等价路由最大条数配置和硬件资源模式的配置需要相同。本端等价路由最大条数为8，硬件资源模式为VXLAN。设备检测到等价路由最大条数配置或硬件资源模式的配置与IRF-port 2连接的邻居成员设备不一致。

(2)   查看IRF-port 2连接的邻居成员设备等价路由条数和硬件资源模式。

[Sysname] display switch-mode status

   Switch-mode in use: NORMAL MODE(default).

   Switch-mode for next reboot: NORMAL MODE(default).

[Sysname]display max-ecmp-num

 Max-ECMP-Num in use: 8

 Max-ECMP-Num at the next reboot: 8

IRF-port 2连接的邻居成员设备等价路由条数为8，硬件资源模式为NORMAL，硬件资源模式配置与本设备不同。

(3)   修改本设备或邻居成员设备硬件资源模式配置使二者一致。如果修改邻居成员设备配置，则需要确认IRF中是否还有其他成员设备，如有需要一并修改。请注意：修改后需要保存配置并重启设备，方能使配置生效。本文以修改本设备配置为例：

[Sysname]switch-mode ?

 0 NORMAL MODE(default)

 1 VXLAN MODE

 2 802.1BR MODE

 3 MPLS MODE

 4 MPLS-IRF MODE

 

[Sysname]switch-mode 0

Reboot device to make the configuration take effect.

[Sysname]

<Sysname>reboot

Start to check configuration with next startup configuration file, please wait..

.......DONE!

Current configuration may be lost after the reboot, save current configuration?

[Y/N]: y

Please input the file name(*.cfg)[flash:/test.cfg]

(To leave the existing filename unchanged, press the enter key):

flash:/test.cfg exists, overwrite? [Y/N]:y

Validating file. Please wait...

Saved the current configuration to mainboard device successfully.

This command will reboot the device. Continue? [Y/N]:y

Now rebooting, please wait........

## 4.7 框式交换机是否支持IRF环形连接拓扑？

对于仅支持两台设备组成IRF的框式交换机，不支持IRF环形连接拓扑。

对于最多支持四台设备组成IRF的框式交换机，使用三台或四台设备组建IRF时，可以支持环形连接拓扑。

交换机支持的IRF成员设备数量和连接拓扑请查看产品配套“虚拟化技术配置指导”中的“IRF”。

## 4.8 IRF重启后为什么有配置丢失？

常见原因有如下几种：

·   IRF重启前，修改了配置，但是没有保存。

·   在IRF上保存配置时，从设备正在重启，此时保存的配置文件中没有包含从设备的配置。当从设备启动完成并加入IRF后，无法从主设备的配置文件中恢复配置，导致从设备上的配置丢失。

·   IRF的软件版本升级后有部分软件功能不支持，相关功能的配置会丢失。

·   对于分布式交换机，如果设备长期不上电，可能会导致主控板上的NVRAM供电不足，NVRAM中记录的设备启动配置文件路径信息丢失。此时，设备会以空配置的方式启动，设备上原有的配置丢失。这种情况可以通过设备启动后查看系统时间是否准确进行判断，如果系统时间显示和之前配置的不匹配，则可以确认是主控板上NVRAM供电不足，请联系技术支持更换主控板上的电池。

## 4.9 LACP MAD检测采用的组网有何要求？

LACP MAD适用于IRF使用聚合链路和上行设备或下行设备连接，组网通常要求：

·   每个成员设备都需要连接到中间设备。

·   成员设备连接中间设备的链路务必加入动态聚合组。

·   中间设备需要支持扩展LACP报文，即中间设备需要采用H3C设备。

## 4.10 BFD MAD检测VLAN有何限制及注意事项？

BFD MAD检测VLAN通常有如下使用限制和注意事项：

·   不允许在Vlan-interface1接口上开启BFD MAD检测功能。

·   如果使用中间设备，需要进行如下配置：

¡   在IRF设备和中间设备上，创建专用于BFD MAD检测的VLAN。

¡   在IRF设备和中间设备上，将用于BFD MAD检测的物理接口添加到BFD MAD检测专用VLAN中。

¡   在IRF设备上，创建BFD MAD检测VLAN的VLAN接口。

·   如果网络中存在多个IRF，在配置BFD MAD时，各IRF必须使用不同的VLAN作为BFD MAD检测专用VLAN。

·   用于BFD MAD检测的VLAN接口对应的VLAN中只能包含BFD MAD检测链路上的端口，请不要将其它端口加入该VLAN。当某个业务端口需要使用port trunk permit vlan all命令允许所有VLAN通过时，请使用undo port trunk permit命令将用于BFD MAD的VLAN排除。

![注意](https://resource.h3c.com/cn/202207/07/20220707_7458698_x_Img_x_png_13_1644624_30005_0.png)

如下产品创建VSI虚接口后，部分VLAN接口不能作为用于BFD MAD检测的VLAN接口：

·   对于S5560X-EI、S5500V2-EI、ES5500C、MS4520V2系列交换机，编号为3581~4092的VLAN接口不能作为用于BFD MAD检测的VLAN接口。

·   对于S6520X-SI、S6520-SI、MS4600系列交换机，编号为3581~4092的VLAN接口不能作为用于BFD MAD检测的VLAN接口。

·   对于S6520X-EI系列交换机，编号为3069~4092的VLAN接口不能作为用于BFD MAD检测的VLAN接口。

·   对于S6520X-HI、S5560X-HI、S5000-EI系列交换机，编号为2045~4092的VLAN接口不能作为用于BFD MAD检测的VLAN接口。

·   对于S6813&S6812系列交换机，编号为2045~4092的VLAN接口不能作为用于BFD MAD检测的VLAN接口。

 

·   IRF设备使用BFD MAD检测功能时，请务必注意：开启BFD检测功能的VLAN接口只能专用于BFD检测，不允许运行其他业务。

¡   开启BFD检测功能的VLAN接口只能配置mad bfd enable和mad ip address命令。如果用户配置了其它业务，可能会影响该业务以及BFD检测功能的运行。

¡   BFD MAD检测功能与生成树功能互斥，在开启了BFD MAD检测功能的VLAN接口对应VLAN内的端口上，请不要开启生成树协议。

# 5 MAC地址表

## 5.1 为什么设备无法转发源MAC地址是VLAN接口的MAC地址的流量？

报文入接口与静态MAC地址表项匹配检查功能处于开启状态时，设备会将接收到的报文的源MAC地址与静态MAC地址表项进行匹配。如果存在MAC地址与报文的源MAC相同的表项，但表项的出接口不是接收报文的端口，设备会丢弃该报文。对于源MAC地址是VLAN接口的MAC地址的流量，需要在对应VLAN所在的二层接口上关闭报文入接口与静态MAC地址表项匹配检查功能才能转发该流量。请客户按以下配置步骤在对应VLAN所在的二层接口上关闭该功能。

配置步骤：

(1)   进入系统视图。

system-view

(2)   进入二层以太网接口视图。

interface interface-type interface-number

(3)   在接口上关闭报文入接口与静态MAC地址表项匹配检查功能。

undo mac-address static source-check enable

缺省情况下，接口上的报文入接口与静态MAC地址表项匹配检查功能处于开启状态。

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458699_x_Img_x_png_14_1644624_30005_0.png)

对于不支持undo mac-address static source-check enable命令的产品（如S12500X-AF/S12500F-AF/S6890），则不涉及此问题。

# 6 接口与聚合

## 6.1 电口或光口互连是否应该设置强制双工和速率？

电口具有很好的自协商能力，一般都能自协商成功，所以不要设置强制双工和速率。

光口自协商能力比电口稍差，极少部分光口会出现自协商不成功的现象，所以大部分光口在开局时候都被设置强制双工和速率。这样不加分析的设置强制双工和速率，会掩盖一些问题，需要注意查看端口信息中有没有错包。是否光衰过大，必要时要用光功率仪进行测试，确实是否需要更换光纤等。

电口或光口的协商机制可以遵循以下2个原则：

·   除非有特别的理由，双方均采用自协商方式。如果端口没有UP，可以查看安装手册确认端口有无需要强制速率和双工的要求，如有相关描述，请按要求配置。

·   双方方式必须一致，要么双方都是自协商方式，要么双方都设置强制双工和速率，不允许一端自协商，一端设置强制双工和速率，也不允许只设置双工方式而不设置速率，同样也不允许只设置速率而不设置双工方式。

## 6.2 Combo口为什么不UP？

Combo接口是一个逻辑接口，一个Combo接口物理上对应设备面板上一个电口和一个光口。电口与其对应的光口是光电复用关系，两者不能同时工作（当激活其中的一个接口时，另一个接口就自动处于禁用状态），用户可根据组网需求选择使用电口或光口。

·   请根据设备面板上的标识了解设备Combo接口的编号。例如，下图中设备前面板上的最后2个10/100/1000BASE-T自适应以太网端口和前2个SFP口（端口编号为9、10）组成了Combo接口。

图6-1 前面板Combo接口示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458700_x_Img_x_png_15_1644624_30005_0.png)

| (1): 10/100/1000BASE-T自适应以太网端口 | (2): SFP口 |
| -------------------------------------- | ---------- |
|                                        |            |

 

·   通过**display interface**命令查看该Combo接口信息，如果显示信息中包含“Media type is twisted pair”，则表示电口处于激活状态，否则，则表示光口处于激活状态。

·   使用combo enable { copper | fiber }命令激活Combo接口中的电口或者光口。

## 6.3 聚合接口和成员接口的配置有哪些要求？

接口加入聚合组前，有以下两种情况，不同产品要求不同，请以设备实际情况为准：

·   接口加入聚合组前，如果接口上的属性类配置和聚合接口不同，则该接口不能加入聚合组。

·   接口加入聚合组前，如果接口上的属性类配置和聚合接口不同，则该接口可以加入聚合组，但会处于非选中状态。

接口加入聚合组后，有以下两种情况，不同产品要求不同，请以设备实际情况为准：

·   接口加入聚合组后，不能修改接口的属性类配置。

·   接口加入聚合组后，可以修改接口的属性类配置，但会导致接口变为非选中状态。

处于非选中状态下的成员端口不能参与数据的转发，有关成员端口状态的详细介绍请参见各产品“二层技术—以太网交换配置指导”中的“以太网链路聚合”。

属性类配置包含的配置内容如[表6-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref57746018)所示。

表6-1 属性类配置的内容

| 配置项   | 内容                                                         |
| -------- | ------------------------------------------------------------ |
| 端口隔离 | 端口是否加入隔离组、端口所属的端口隔离组                     |
| QinQ配置 | 端口的QinQ功能开启/关闭状态、VLAN Tag的TPID值、VLAN透传。    |
| VLAN映射 | 端口上配置的各种VLAN映射关系。                               |
| VLAN配置 | 端口上允许通过的VLAN、端口缺省VLAN、端口的链路类型（即Trunk、Hybrid、Access类型）、端口的工作模式（即promiscuous、trunk promiscuous、host、trunk secondary模式）、基于IP子网的VLAN配置、基于协议的VLAN配置、VLAN报文是否带Tag配置。 |

 

接口加入聚合组时，还存在如下限制：

·   不要将镜像反射端口加入聚合组。

·   PEX二层聚合组的成员端口必须是同一PEX上的接口或同一PEX组中同一层的不同PEX上的接口。同时必须使用同系列的PEX设备进行链路聚合。有关PEX的详细介绍请参见各产品“虚拟化技术配置指导”。

## 6.4 聚合链路两端如何选择聚合模式？

链路聚合分为静态聚合和动态聚合两种模式，聚合链路的两端应配置相同的聚合模式。对于不同模式的聚合组，其选中端口存在如下限制：

·   对于静态聚合模式，用户需要保证在同一链路两端端口的选中/非选中状态的一致性，否则聚合功能无法正常使用。

·   对于动态聚合模式：

¡   聚合链路两端的设备会自动协商同一链路两端的端口在各自聚合组内的选中/非选中状态，用户只需保证本端聚合在一起的端口的对端也同样聚合在一起，聚合功能即可正常使用。

¡   如果聚合链路一端使用半自动动态聚合方式，则链路另外一端使用手工动态聚合方式。

## 6.5 如何处理链路聚合负载分担不均匀的问题？

针对不同的业务场景，对应的负载分担方式也是不同的。当出现链路聚合负载分担不均匀的问题时，可以进行如下尝试改善负载分担不均的问题：

·   调整负载分担类型

可通过系统视图下的link-aggregation global load-sharing mode命令调整全局的负载分担类型；部分交换机还可以通过聚合接口视图下的link-aggregation load-sharing mode命令调整聚合接口的负载分担类型。具体支持的负载分担类型以产品实际情况为准。

针对不同业务流量，调整负载分担类型：

¡   对于IP报文，可以基于源IP地址或目的IP地址进行负载分担。

¡   对于二层报文，可以基于源MAC地址或目的MAC地址进行负载分担。

·   关闭本地优先转发功能

跨IRF成员设备聚合场景中，可以使用undo link-aggregation load-sharing mode local-first命令关闭本地优先转发功能。

需要注意，跨IRF成员设备流量不能过大，否则可能影响IRF系统稳定。

## 6.6 使用链路聚合如何与服务器互通？

与服务器对接时，需要在聚合接口下使用lacp edge-port命令将聚合接口配置为聚合边缘接口。该场景下聚合接口需要工作在动态聚合模式。

在服务器未配置动态聚合模式时，该服务器与网络设备间的链路可以形成备份，使该聚合组内的所有成员端口都作为普通物理口转发报文，从而保证终端设备与网络设备间的多条链路可以相互备份，增加可靠性。在服务器完成动态聚合模式配置时，其聚合成员端口正常发送LACP报文后，网络设备上符合选中条件的聚合成员端口会自动被选中，从而使聚合链路恢复正常工作。

# 7 DRNI

## 7.1 DRNI组网中管理IP地址互访不通如何处理？

DRNI组网中需要进行以下部署：

·   需要在系统视图下或IPP口下配置undo mac-address static source-check enable命令，关闭报文入接口与静态MAC地址表项匹配检查功能。

·   DR接口仅允许业务流量所在VLAN通过。

·   DRNI主备设备均与上行设备连接，实现冗余备份。

## 7.2 DRNI+VRRP组网中，单挂接入DR设备时，如何避免同一ICMP报文被DR主设备收到两次？

在DRNI+VRRP组网场景中，需要DR设备上任意一个DR接口允许特定的VLAN通过，该特定VLAN为配置VRID的VLAN接口对应的VLAN。

# 8 VLAN

## 8.1 为什么部分VLAN无法通过Trunk端口？

部分VLAN无法通过Trunk端口，可能是用户未将相应的VLAN加入到Trunk端口。此外，本端设备Trunk端口的缺省VLAN ID和相连的对端设备的Trunk端口的缺省VLAN ID必须一致，否则报文将不能转发。出现该问题时，可以通过display vlan命令来查看相应的VLAN是否加入了Trunk端口。若未加入，可以在接口视图下通过port trunk permit vlan命令设置相应的VLAN加入Trunk口，同时通过port trunk pvid命令正确配置Trunk端口的PVID。

## 8.2 如何正确配置允许指定VLAN或全部VLAN通过Trunk端口？

基于Trunk端口的VLAN只能在接口视图下配置，正确配置步骤如下：

(1)   进入系统视图。

system-view

(2)   进入接口视图。

¡   进入二层以太网接口视图。

interface interface-type interface-number

¡   进入二层聚合接口视图。

interface bridge-aggregation interface-number

(3)   配置端口的链路类型为Trunk类型。

port link-type trunk

缺省情况下，端口的链路类型为Access类型。

(4)   允许指定的VLAN或全部VLAN通过当前Trunk端口。

port trunk permit vlan { *vlan-id-list* | **all** }

缺省情况下，Trunk端口只允许VLAN 1的报文通过。

(5)   配置Trunk端口的PVID。

port trunk pvid vlan vlan-id

缺省情况下，Trunk端口的PVID为VLAN 1。

建议用户谨慎使用port trunk permit vlan all命令，以防止未授权VLAN的用户通过该端口访问受限资源。

## 8.3 为什么设备获取不到IP Phone的MAC地址？

设备获取不到IP Phone的MAC地址，可能是该话机不在设备缺省的OUI地址中，请客户按以下配置步骤预先配置话机的OUI地址，然后执行display voice-vlan mac-address命令查看，确保表项中存在该话机。

配置步骤：

(1)   进入系统视图。

system-view

(2)   配置Voice VLAN识别的OUI地址。

voice-vlan mac-address oui mask oui-mask [ description text ]

Voice VLAN启动后将有缺省的OUI地址。有关缺省OUI地址的详细介绍，请参见各产品“二层技术-以太网交换配置指导”中的“VLAN”。

在配置Voice VLAN的OUI时：

·   OUI地址不能是广播地址或者组播地址，也不能是全0的地址。

·   OUI地址是mac-address和oui-mask参数相与的结果。

·   设备最多支持配置OUI地址个数以具体产品实际规格为准。

## 8.4 如何限制广播域的范围？

可以通过划分设备所属VLAN，将广播报文限制在同一个VLAN内，有效地限制广播域的范围。交换机可支持的VLAN划分方式包括：基于端口、MAC地址、IP子网、协议方式来划分VLAN。不同设备支持的具体情况，请参考各系列交换机“二层技术-以太网交换配置指导”中的“VLAN配置”部分。

## 8.5 错误配置接口链路类型导致无法正常通信怎么办？

首先要正确区分三种端口的链路类型：

·   Access：端口只能发送一个VLAN的报文，发出去的报文不带VLAN Tag。一般用于和不能识别VLAN Tag的用户终端设备相连，或者不需要区分不同VLAN成员时使用。

·   Trunk：端口能发送多个VLAN的报文，发出去的端口缺省VLAN的报文不带VLAN Tag，其他VLAN的报文都必须带VLAN Tag。通常用于网络传输设备之间的互连。

·   Hybrid：端口能发送多个VLAN的报文，端口发出去的报文可根据需要配置某些VLAN的报文带VLAN Tag，某些VLAN的报文不带VLAN Tag。

然后根据接口转发报文时是否需要携带VLAN tag或是否允许转发多个VLAN的报文，使用port link-type命令将错误的接口类型切换为正确的接口类型。

切换接口类型应注意：

·   Trunk端口不能直接切换为Hybrid端口，只能先将Trunk端口配置为Access端口，再配置为Hybrid端口。

·   Hybrid端口不能直接切换为Trunk端口，只能先将Hybrid端口配置为Access端口，再配置为Trunk端口。

## 8.6 在Voice VLAN中出现除语音数据之外的业务数据丢失情况怎么办？

在Voice VLAN中发生业务数据丢失情况时，请执行undo voice-vlan security enable命令关闭Voice VLAN的安全模式。在安全模式下，设备将对每一个要进入Voice VLAN传输的报文进行源MAC地址匹配检查，对于不能匹配OUI地址的报文，将其丢弃。因此建议用户尽量不要在Voice VLAN中同时传输语音和业务数据。如确有此需要，请确认Voice VLAN的安全模式已关闭，否则业务数据会被丢弃。

## 8.7 如何选择端口的Voice VLAN工作模式？

根据端口加入Voice VLAN的不同方式，可以将Voice VLAN的工作模式分为自动模式和手动模式，选择方式如下。

#### 1. 自动模式

自动模式适用于主机和IP电话串联接入（端口同时传输语音数据和普通业务数据）的组网方式，如[图8-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref344198513)所示。

图8-1 主机与IP电话串联接入组网图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458701_x_Img_x_png_16_1644624_30005_0.png)

 

#### 2. 手动模式

手动模式适用于IP电话单独接入（端口仅传输语音报文）的组网方式，如[图8-2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref344198781)所示。该组网方式可以使该端口专用于传输语音数据，最大限度避免业务数据对语音数据传输的影响。单独接入适用于IP电话发出Untagged语音报文的情况，不同类型端口支持Untagged语音数据配置要求，如[表8-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref105610304)所示。

图8-2 IP电话单独接入组网图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458702_x_Img_x_png_17_1644624_30005_0.png)

 

表8-1 不同类型端口支持Untagged语音数据配置要求

| Voice VLAN工作模式 | 端口类型 | 是否支持Untagged语音数据                               | 配置要求            |
| ------------------ | -------- | ------------------------------------------------------ | ------------------- |
| 手动模式           | Access   | 支持                                                   | 端口加入Voice  VLAN |
| Trunk              | 支持     | PVID必须为Voice VLAN，且接入端口允许PVID通过           |                     |
| Hybrid             | 支持     | PVID必须为Voice VLAN，且允许PVID的报文不带VLAN Tag通过 |                     |

 

# 9 生成树

## 9.1 什么情况下需要配置生成树边缘端口？

与交换机连接的用户侧设备（如服务器等）无需运行生成树协议。若交换机上与这些设备相连的端口使能了生成树协议，则该端口的物理状态可能频繁震荡，在Up/Down上不停跳转；或生成树拓扑变化时端口角色需要计算，导致该端口一段时间后才能进入转发状态等问题；这对一些需要高链路稳定性或低转发延迟的业务是不可接受的。为了避免上述问题，需要将与用户侧设备连接的端口配置为边缘端口。边缘端口状态变为Up后可以快速进入转发状态，并且不会发送TC报文，也不会对其他运行了生成树协议的网络造成影响。

## 9.2 在生成树拓扑中，不同的设备可以配置不同的生成树工作模式吗？

H3C设备在运行生成树协议时，不同的设备间的不同生成树工作模式可以互相兼容。其中：

·   MSTP模式可以兼容RSTP模式和STP模式，RSTP模式可以兼容STP模式。

·   对于Access端口，PVST模式在任意VLAN中都能与其他模式互相兼容；对于Trunk端口或Hybrid端口，PVST模式仅在缺省VLAN中能与其他模式互相兼容。

若设备的对端设备为其他产商设备，建议对端设备与H3C设备使用同一种工作模式，以避免因产商差异而出现的不兼容问题。

## 9.3 开启生成树协议后，可通过哪些方法维持网络拓扑的稳定？

在使能了生成树协议的网络中，生成树计算后阻塞的部分二层通路，可能导致下行终端获取不到地址或获取地址慢、部分业务流量不通等问题，此时可通过下列方法尝试维护生成树的拓扑稳定，以保障正常的二层通路：

(1)   根桥保护

在一些组网环境中，用户指定的根桥设备因为未进行过根桥保护的相关配置，导致新设备加入组网时，成为新的根桥，引发生成树拓扑重新收敛和网络的震荡。

可通过下列方法避免其他设备的抢根：

·   设备的优先级参与生成树计算，数值越小表示优先级越高，用户可配置**stp priority**命令，直接将指定的设备优先级设置为0或值较小的优先级，以达到指定设备成为生成树根桥的目的。

·   通过配置**stp root primary**命令，用户可指定设备为生成树的根桥。需要注意的是，当设备一旦被配置为根桥之后，便不能再修改该设备的优先级。

·   设备被选举为根桥后，开启根保护功能。在接口视图下配置**stp root-protection**命令后，此接口在所有MSTI上的端口角色只能为指定端口。一旦该端口收到某MSTI优先级更高的BPDU，立即将该MSTI端口设置为侦听状态，不再转发报文（相当于将此端口相连的链路断开）。当在2倍的Forward Delay时间（缺省情况下Forward Delay时间为15秒）内没有收到更优的BPDU时，端口会恢复原来的正常状态。根保护功能，可以避免因错误配置或恶性攻击导致的生成树拓扑不合法的变动。

(2)   配置边缘端口和BPDU保护

对于接入层设备，接入端口一般直接与用户终端（如PC）或文件服务器相连，此时接入端口应被设置为边缘端口以实现这些端口的快速迁移。正常情况下，接入端口不应该与用户终端交互生成树协议的BPDU报文，如果收到BPDU报文可能会引起网络拓扑结构的变化，造成网路震荡。

生成树协议提供了BPDU保护功能来解决这类问题：在全局或接口视图下配置**stp bpdu-protection**命令后，如果边缘端口收到了BPDU，系统就将这些端口关闭，同时通知用户这些端口已被生成树协议关闭。被关闭的端口在经过一定时间间隔之后将被重新激活，这个时间间隔可通过**shutdown-interval**命令配置。

(3)   配置环路保护

下游设备依靠不断接收上游设备发送的BPDU来维持根端口和其他阻塞端口的状态。如果出现了链路拥塞或者单项链路故障，这些端口会收不到上游设备的BPDU，此时下游设备会重新选择端口角色，导致下游设备的根端口转变为指定端口，而阻塞端口会迁移到转发状态，导致交换网络中产生环路。

在下游设备的根端口和替换端口上通过stp loop-protection命令配置环路保护功能后，可以抑制上述环路的产生。在开启了环路保护功能的端口上，其所有MSTI的初始状态均为Discarding状态：如果该端口收到了BPDU，这些MSTI可以进行正常的状态迁移；否则，这些MSTI将一直处于Discarding状态以避免环路的产生。

需要注意的是，无需在与用户终端相连的端口上配置环路保护功能，否则该端口会因一直处于Discarding状态而无法正常转发用户报文。

(4)   配置防TC-BPDU攻击保护功能

在遭受到TC-BPDU恶意攻击行为时，设备会频繁地刷新转发地址表项。此类攻击给设备带来了很大负担，随时威胁着网络的稳定性。此时可以开启防TC-BPDU攻击保护功能，以避免频繁地刷新转发地址表项。该功能的描述如下：

·   在系统视图下执行stp tc-protection命令，可以开启防TC-BPDU攻击保护功能。

·   在系统视图下执行stp tc-protection threshold number命令，可以配置在单位时间（固定为十秒）内，设备收到TC-BPDU后立即刷新转发地址表项的最高次数。

·   开启本功能后，如果设备在单位时间（固定为十秒）内收到TC-BPDU的次数大于number次，那么该设备在这段时间之内将只进行number次刷新转发地址表项的操作，而对于超出number次的那些TC-BPDU，设备会在这段时间过后再统一进行一次地址表项刷新的操作。

## 9.4 设备频繁收到TC报文时该如何操作？

设备收到TC报文后会进行如下两个操作：

(1)   TC报文所在的实例触发MAC地址删除及重新学习。

在MAC地址删除重新学习过程中，会产生未知单播流量导致网络中流量泛洪。

(2)   TC报文所在的实例触发ARP探测。

ARP探测会导致ARP广播报文在网络中泛洪，增加设备负担。

如果设备频繁收到TC报文，就会频繁进行如上两种操作，会对网络中的设备产生冲击，因此要尽量避免这种情况。一般可按照如下步骤进行排查解决：

(1)   确定网络中频繁产生TC报文的设备。

分析设备日志信息，确定是哪个端口频繁收到TC报文。确定端口后，进一步排查与该端口对接设备的日志信息，继续分析是该设备产生的还是其下一级设备产生的TC报文。采用逐级排查的方式确认是哪台设备产生的TC报文。

![注意](https://resource.h3c.com/cn/202207/07/20220707_7458703_x_Img_x_png_18_1644624_30005_0.png)

PVST模式下端口收到TC报文后，默认不打印日志信息。可通过配置**stp log enable tc**命令配置在PVST模式下设备检测或接收到TC报文时打印日志信息功能。

 

(2)   确定设备频繁产生TC报文的原因。

设备开启生成树协议的情况下，如果端口UP/DOWN，则会产生TC报文。即如果存在端口频繁UP/DOWN的情况，便会频繁产生TC报文。

(3)   消除TC报文。

如果设备上存在端口频繁UP/DOWN，则分析定位端口UP/DOWN的原因并解决，即可消除设备频繁产生TC报文的情况。

如果暂时无法排查出频繁产生TC报文的原因或无法解决端口UP/DOWN问题，可以按照如下方式进行临时规避：

(1)   如果该端口对接的是终端设备，可配置端口为边缘端口（通过**stp edged-port**命令配置）。端口配置为边缘端口后，该端口UP/DOWN时，不再产生TC报文。

(2)   如果该端口对接的是非终端设备，可通过如下两种方式进行临时规避：

¡   开启TC-BPDU传播限制功能（通过**stp tc-restriction**命令开启，缺省情况下处于关闭状态）。当开启了端口的TC-BPDU传播限制功能之后，该端口将不再向其它端口传播TC-BPDU，也不删除本机的转发地址表项。

¡   开启防TC-BPDU攻击保护功能（通过**stp tc-protection**命令开启，缺省情况下处于开启状态），并通过配置收到TC-BPDU后立即刷新转发地址表项的最高次数来控制刷新频率（通过**stp tc-protection threshold**命令配置，缺省情况为在单位时间（固定为十秒）内，设备收到TC-BPDU后立即刷新转发地址表项的最高次数为6）。

## 9.5 开启生成树协议后，如何避免对其他网络造成不良影响？

与其他网络相连的边缘设备开启生成树功能后，会通过相连的端口发送BPDU报文至外部，引发其他网络重新计算生成树，造成网络震荡。此时通过配置BPDU过滤功能，可以使端口不再发送BPDU报文，以免对其他网络造成不良影响。请客户按以下配置步骤开启边缘端口的BPDU过滤功能。

(1)   进入系统视图。

system-view

(2)   进入接口视图。

interface interface-type interface-number

(3)   配置端口的BPDU过滤功能。

stp port bpdu-filter { disable | enable }

# 10 环路检测

## 10.1 如何选择环路检测时间间隔？

设备以一定的时间间隔发送环路检测报文来确定是否存在环路，这个时间间隔就称为环路检测的时间间隔。同时这个时间间隔决定了环路检测在Block模式和No-learning模式下的端口恢复正常转发状态的速度：时间间隔越小，端口的恢复速度越快，环路检测的灵敏度越高，占用设备的系统资源越多；时间间隔越大，端口的恢复速度越慢，环路检测的灵敏度越低，占用设备的系统资源越小。请用户根据设备实际情况及组网的二层防环需求，灵活配置环路检测时间间隔。

同时需要注意的是，环路检测在Shutdown模式下，被关闭的端口的恢复不受环路检测时间间隔的影响，而是在**shutdown-interval**命令配置的端口状态检测定时器超时后，端口自动恢复为UP状态。

## 10.2 环路检测和生成树功能可以同时配置吗？

不建议同时配置，因为环路检测和生成树都具有二层防环功能，如果两者同时配置，可能其中一者在另一者计算出环路之前就已经消除了环路，造成环路检测功能不生效或生成树功能不生效等问题。

# 11 镜像

## 11.1 希望为本地端口镜像组配置多于一个目的端口，但部分设备不支持加入第二个目的端口怎么处理？

部分设备上，本地端口镜像组支持配置多个目的端口。

部分设备上，本地端口镜像组不支持配置多个目的端口，为镜像组配置第二个目的接口时输出类似如下提示信息：

<Sysname> system-view

[Sysname] mirroring-group 1 monitor-port HundredGigE 1/0/26

Mirroring group 1 already has a monitor port.

对于本地端口镜像组不支持配置多个目的接口的设备，可以使用远程镜像VLAN实现本地镜像组支持多个目的端口。

该方式利用二层远程端口镜像中镜像报文在远程镜像VLAN中广播发送的原理实现。具体实现方式为：

(1)   在本地设备上创建远程源镜像组、远程镜像VLAN和反射端口，并将本设备上连接监测设备的多个端口加入该VLAN。

(2)   镜像报文在远程镜像VLAN中广播时即可从这些端口中发送出去，实现将镜像报文发送到多个目的端口。

具体配置方式请参见“网络管理和监控配置指导”中的“镜像”。

## 11.2 配置二层远程端口镜像后，为什么与镜像无关的端口有异常的流量增加？

查看这些端口是否加入到了远程镜像VLAN中，如是，请将与镜像无关的端口从远程镜像VLAN中删除。远程镜像VLAN需要专用，不要用作其他用途，也不要将镜像无关端口加入远程镜像VLAN。

## 11.3 配置镜像组的源端口失败，可能的原因有哪些？

最常见的原因为接口类型支持情况限制和一个接口允许加入的聚合组数量限制。

请确认该接口是否支持配置为镜像源接口，特别是聚合接口、VLAN接口等全局接口。VLAN接口一般不支持作为镜像源接口，请配置VLAN中的物理端口作为镜像源接口。聚合接口是否支持作为镜像源接口与设备型号有关，请查询产品“网络管理和监控配置指导”和“网络管理和监控命令参考”中的“镜像”。

一个接口可以作为镜像源加入的镜像组数目受设备支持情况限制：

·   部分设备上：一个接口仅支持作为一个镜像组的源端口，将该接口配置为第二个镜像组的源接口时输出类似如下提示信息，表示该接口已经配置为其他镜像组的源端口：

<Sysname> system-view

[sysname] mirroring-group 2 mirroring-port ten-gigabitethernet 1/0/1 both

ten-gigabitethernet 1/0/1 is a mirroring port of mirroring group 1. 

·   部分设备上：一个接口作为单向源端口最多可以加入四个镜像组，作为双向源端口最多可以加入两个镜像组，或者以一个双向源端口和两个单向源端口的形式加入三个镜像组。请查看接口作为镜像源端口的配置是否已超过数量限制。

镜像的配置较复杂，如果上述方法不能解决您的问题请联系技术支持。

## 11.4 为什么配置远程镜像VLAN的VLAN接口可能导致镜像功能异常？

如果远程镜像VLAN配置了对应的VLAN接口，当镜像报文的目的MAC地址正好是VLAN接口的MAC地址时，报文只进行三层转发，不会从镜像目的端口发出。建议不要配置远程镜像VLAN的VLAN接口。

# 12 DHCP

## 12.1 在DHCP地址池视图下配置客户端MAC地址与IP地址的静态绑定，需要注意什么？

在DHCP地址池视图下执行命令static-bind ip-address ip-address [ mask-length | mask mask ] hardware-address hardware-address [ ethernet | token-ring ] }

需要注意的是，配置静态绑定时，必须确保绑定的MAC地址与实际用户的MAC地址保持一致，并且配置的MAC地址必须是有效的MAC地址（MAC地址为4～39个字符的字符串，字符串中只能包括十六进制数和“-”，且形式为H-H-H…，除最后一个H表示2位或4位十六进制数外，其他均表示4位十六进制数。例如：aabb-cccc-dd为有效的客户端硬件地址，aabb-c-dddd和aabb-cc-dddd为无效的客户端硬件地址。）。

## 12.2 指定接口引用不存在的DHCP策略会怎样？

执行命令dhcp policy policy-name创建DHCP策略，并在指定接口下执行dhcp apply-policy policy-name命令引用该策略后，该接口接收到DHCP请求报文时，则根据配置顺序逐个匹配DHCP策略中通过class ip-pool命令指定的DHCP用户类，如果接收DHCP请求报文的接口引用的DHCP策略不存在或匹配的DHCP用户类关联的DHCP地址池不存在时，IP地址和其他参数分配会失败。

## 12.3 地址池IP网段范围规划小了会发生什么？

如果可供分配的IP网段范围过小，会导致动态分配的IP地址范围内没有空闲地址，DHCP服务器无法为剩余的DHCP客户端分配地址，因此建议用户合理规划IP网段范围，保证所有客户端都能获取到IP地址。

## 12.4 配置DHCP Snooping之后，下挂用户无法获取IP地址

缺省情况下，在开启DHCP Snooping功能后，设备上所有支持DHCP Snooping功能的端口均为不信任端口。如[图12-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref215284432)，需要通过dhcp snooping trust命令将连接DHCP服务器的端口设置为信任端口，并且设置的信任端口与DHCP客户端相连的端口必须在同一个VLAN内，以便DHCP Snooping设备正常转发DHCP服务器的应答报文，保证DHCP客户端能够从合法的DHCP服务器获取IP地址。

图12-1 信任端口和非信任端口

![img](https://resource.h3c.com/cn/202207/07/20220707_7458704_x_Img_x_png_19_1644624_30005_0.png)

 

## 12.5 私网客户端申请IP地址时，作为DHCP服务器的V5设备和V7设备配置上有何不同？

对于处于VPN私网中的客户端申请IP地址，若V5设备作为DHCP服务器，不需要在DHCP地址池下绑定VPN实例，客户端就可以获取到IP地址。但当V7设备作为DHCP服务器时，需要在相应地址池中配置绑定对应的VPN实例。例如位于VPN实例abc中的客户端申请IP地址时，需要在DHCP服务器上对应的DHCP地址池视图下执行vpn-instance abc命令来绑定VPN实例abc，原因是DHCP服务器可以将网络划分成公网和VPN私网，未配置VPN属性的地址池被划分到公网，配置了VPN属性的地址池被划分到相应的VPN私网，这样服务器就可以更好的选择合适的地址池来为客户端分配租约并且记录该客户端的状态信息。

## 12.6 配置DHCP服务器或DHCP中继生效的前提是什么?

只有在系统视图下执行dhcp enable命令后，DHCP服务器或DHCP中继配置才能生效。

## 12.7 记录DHCP客户端IP地址与MAC地址的对应关系，缺省是开启的吗？

缺省情况下，DHCP Snooping表项记录功能处于关闭状态，如果有其他特性（例如IP Source Guard）打算利用这些表项信息，可以在系统视图、VLAN视图、VSI视图或接口视图下执行dhcp snooping binding record命令生成DHCP Snooping安全表项。需要注意的是，不同产品系列支持开启DHCP snooping功能和表项记录功能的视图不同，请以设备实际情况为准。

## 12.8 重新指定地址池动态分配的IP地址范围时，应该注意什么？

在DHCP地址池视图下，使用**address range**命令修改已存在的动态分配的IP地址范围时，新的IP地址范围需要覆盖之前该DHCP地址池已分配出去的IP地址，否则系统会提示配置错误。如果用户仍然打算继续配置，需要使用**reset dhcp server ip-in-use**命令释放分配的地址租约后，再进行**address range**命令配置。

## 12.9 DHCP Snooping的信任端口和非信任端口设置在什么位置上？

网络中如果存在私自架设的非法DHCP服务器，则可能导致DHCP客户端获取到错误的IP地址和网络配置参数，从而无法正常通信。为了使DHCP客户端能通过合法的DHCP服务器获取IP地址，DHCP Snooping安全机制允许将端口设置为信任端口和不信任端口。

在DHCP Snooping设备上指向DHCP服务器方向的端口需要设置为信任端口，其他端口设置为不信任端口，从而保证DHCP客户端只能从合法的DHCP服务器获取IP地址，私自架设的伪DHCP服务器无法为DHCP客户端分配IP地址。

## 12.10 交换机作为DHCP服务器，如何配置才能使网络中的设备获得固定IP或不与已有IP地址的设备发生地址冲突？

交换机作为DHCP服务器为客户端分配IP地址，如果想让某客户端获得固定IP地址，而不是随机获取IP地址。可以在DHCP地址池视图下，使用**static-bind** **ip-address**命令配置该客户端的静态地址绑定。当客户端申请IP地址时，服务器会根据客户端的客户ID或MAC地址分配固定的IP地址。例如，在DHCP地址池0中配置为客户端ID为00aa-aabb的客户端，固定分配IP地址10.1.1.1/24。

<Sysname> system-view

[Sysname] dhcp server ip-pool 0

[Sysname-dhcp-pool-0] static-bind ip-address 10.1.1.1 mask 255.255.255.0 client-identifier 00aa-aabb

如果网络中的设备（如网关、FTP服务器）已占用了DHCP服务器的地址池中的IP地址，为避免DHCP服务器把这些IP地址分配出去，引起IP地址冲突。请在作为DHCP服务器的设备的系统视图下，使用dhcp server forbidden-ip命令配置全局不参与自动分配的IP地址；或在DHCP地址池视图下，使用for**bidden-ip**命令配置地址池中不参与自动分配的IP地址。

## 12.11 为什么在DHCP snooping组网下，DHCP服务器的部分地址无法分配？

DHCP Snooping会记录客户端的MAC地址、DHCP服务器为DHCP客户端分配的IP地址、与DHCP客户端连接的端口及VLAN等信息，并生成绑定表。一些安全特性会利用此绑定表实现相应的安全功能，如IP Source Guard。

当DHCP Snooping设备上已经存在绑定表，且有MAC地址相同的客户端上线申请IP地址时，由于相关安全特性，设备无法区分是合法用户还是非法用户仿冒合法用户，所以DHCP Snooping设备不会修改已有的绑定表，从而导致客户端无法获得IP地址。可以通过删除DHCP Snooping设备上的绑定表解决。

# 13 IP业务

## 13.1 为什么将两台交换机接入到同一个局域网，登录交换机的Web管理页面时会出现闪退？

目前，部分型号的交换机，默认支持Web登录，且出厂时Vlan-interface1均配置了缺省的管理IP地址。用户通过设备铭牌标签上打印的管理IP信息，可以获取该地址，该IP地址的掩码为255.255.255.0。

当多台缺省管理IP地址相同的以太网交换机接入同一局域网时，可能因IP地址冲突导致无法登录Web管理页面或登录后闪退。请管理员通过Console口登录交换机，并在Vlan-interface1接口下通过ip address命令配置新的IP地址和掩码，注意新配置的IP地址应在该局域网的网段内，且与其他设备的IP地址不冲突。

## 13.2 为什么会出现网页打不开，但是能Ping通对方IP地址的情况？

对方的IP地址能够Ping通，说明设备之间的路由可达且链路是连通的，报文能够正常收发。那么这时候出现网页打不开或者打开速度慢的原因有可能是链路拥塞、防火墙安全策略问题或TCP MSS值过小。

对于链路拥塞问题，可以通过配置QoS策略或者拥塞管理等方式来缓解；对于防火墙安全策略问题，请检查已配置的防火墙策略是否过滤了Web服务；对于TCP MSS值过小的问题，请使用tcp mss value命令将TCP MSS调整到一个合理的取值（通常取值1460）。

## 13.3 反复出现通过Telnet登录上设备后又断开的情况是什么原因？

物理链路时断时连、接口故障或者IP地址冲突都会导致Telnet登录上设备后又断开。

## 13.4 IP地址冲突会导致出现什么故障？

IP地址冲突，往往会导致网络设备之间无法正常通信。比较常见的故障现象有：

·   无法Ping通其他设备或无法被其他设备Ping通

·   无法登录Web管理界面或登录后闪退

·   Telnet连接设备时断时连

·   使用FTP、TFTP等方式传输文件时异常断开

## 13.5 设备Ping网关地址有丢包，可以从哪些方面排查？

(1)   检查设备是否正确学习到了网关IP地址对应的ARP表项，即执行display arp命令查看ARP表项中网关IP地址对应的MAC地址是否和实际网关MAC地址一致。如果一致，说明ARP表项正常，需要考虑是其他原因导致故障；如果不一致，则有可能是IP地址问题，需要进行第(2)、(3)步的排查。

(2)   IP地址设置错误。例如子网掩码错误、设备的IP和网关的IP不在同一个网段等情况，重新配置设备正确的IP地址即可。

(3)   IP地址冲突。例如局域网内有其他网络设备的IP地址与设备或网关的IP地址冲突的情况，重新分配一个未占用的IP地址即可。

(4)   链路故障。例如端口链路协议异常、接口物理故障、链路断开等情况，出现这种情况则需要对链路和接口进行故障排查。

(5)   当以上原因都不存在时，可以在Ping报文沿途的设备上通过抓包工具和流量统计等手段定位丢包的位置，从而进一步确定故障原因。

## 13.6 两台主机的IP地址属于同一网段，但是被设备分割在不同的物理网络，如何实现两台主机之间的ARP报文正常通信？

可以在设备上配置代理ARP功能。

如果ARP请求是从一个网络的主机发往同一网段却不在同一物理网络上的另一台主机，那么连接它们的具有代理ARP功能的设备就可以应答该请求，这个过程称作代理ARP（Proxy ARP）。

代理ARP功能屏蔽了分离的物理网络这一事实，使用户使用起来，好像在同一个物理网络上。

代理ARP分为普通代理ARP和本地代理ARP，二者的应用场景有所区别：

·   普通代理ARP的应用场景为：想要互通的主机分别连接到设备的不同三层接口上，且这些主机不在同一个广播域中。在接口视图下执行proxy-arp enable命令即可开启普通代理ARP功能。

·   本地代理ARP的应用场景为：想要互通的主机连接到设备的同一个三层接口上，且这些主机不在同一个广播域中。在接口视图下执行local-proxy-arp enable [ ip-range start-ip-address to end-ip-address ]命令即可开启本地代理ARP功能。

## 13.7 二层交换机如何配置IP地址？

二层交换机的以太网端口无法配置IP地址，只能将端口绑定到某个VLAN下，再给该VLAN对应的VLAN接口配置IP地址。以二层交换机的GigabitEthernet1/0/1端口加入VLAN 10并将VLAN接口10配置IP地址192.168.1.2/24为例：

\# 创建VLAN 10。

<Switch> system-view

[Switch] vlan 10

[Switch-vlan10] quit

\# 将接口GigabitEthernet1/0/1加入到VLAN 10中。

[Switch] interface gigabitethernet 1/0/1

[Switch-GigabitEthernet1/0/1] port access vlan 10

[Switch-GigabitEthernet1/0/1] quit

\# 创建接口Vlan-interface10，并配置IP地址。

[Switch] interface vlan-interface 10

[Switch-vlan-interface10] ip address 192.168.1.2 24

## 13.8 配置静态ARP表项时需要注意哪些地方？

·   确保静态ARP表项的IP地址和MAC地址是正确的对应关系。

·   静态ARP表项不会被动态ARP表项更新。当发现网络中静态ARP表项关联的设备链路出现故障，或者更换了设备的接口，请及时手动更新静态ARP表项。

·   静态ARP表项不会老化。当设备支持学习的ARP表项数量太低时，请尽可能减少静态ARP表项的数量，以免影响动态ARP表项的学习。如果静态ARP表项关联的设备或接口从网络中移除，请及时删除对应的静态ARP表项。

# 14 接入认证

## 14.1 接入用户认证时，按照什么顺序选择认证域？

接入用户认证时，设备将按照如下先后顺序为其选择认证域：

(1)   接入模块指定的认证域：

¡   对于802.1X认证用户，是指通过**dot1x mandatory-domain**命令，在端口上指定的802.1X用户使用的强制认证域；

¡   对于MAC地址认证用户，是指通过**mac-authentication domain**命令，在端口上或全局指定的MAC地址认证域，其中端口上指定的认证域优先级高于全局指定的认证域。

¡   对于Portal地址认证用户，是指通过**portal domain**或**portal ipv6 domain**命令在端口上指定的IPv4 Portal用户或IPv6 Portal用户的认证域；

(2)   用户名“*userid@domain-name*”中携带的ISP域“*domain-name*”；

(3)   设备系统缺省的ISP域（通过**display domain**命令的Default domain name可查看）

如果根据以上原则决定的认证域在设备上不存在，但设备上通过**domain if-unknown**命令为未知域名的用户指定了ISP域，则最终使用该指定的ISP域认证，否则，用户将无法认证。

## 14.2 如何修改或删除缺省的ISP域？

修改缺省ISP域的方法为：

(1)   执行命令**display domain**，并通过“Default domain name”字段的显示信息查看当前的缺省ISP域；

(2)   通过**domain** isp-name命令，进入当前缺省的ISP域视图；使用命令**undo** **domain** **default enable**将其修改为非缺省ISP域。

(3)   通过**domain** isp-name命令，创建新的ISP域，并进入其视图；使用命令**domain** **default enable**将新创建的ISP域设置为缺省的ISP域。

删除缺省ISP域，需要注意的是：

·   一个ISP域被配置为缺省的ISP域后，将不能够被删除，必须首先使用命令**undo** **domain** **default enable**将其修改为非缺省ISP域，然后才可以被删除。

·   系统缺省存在的system域只能被修改，不能被删除。

## 14.3 本地用户没有配置服务类型会导致认证失败吗？常用服务类型有哪些？

AAA支持的本地认证方式是指：认证过程在接入设备上完成。这时用户信息（包括用户名、密码和服务类型等各种属性）也需要配置在接入设备上,我们称之为配置本地用户。配置本地用户包括创建一个本地用户并进入本地用户视图，然后在本地用户视图下配置密码和相应的用户属性。

服务类型是指用户可使用的网络服务类型，该属性是本地认证的检测项，如果没有用户可以使用的服务类型，则该用户无法通过认证。

缺省情况下，本地用户不能使用任何服务类型。在本地用户视图下，通过**service-type**命令设置用户可以使用的服务类型，多次执行该命令，可以设置用户使用多种服务类型。常见的服务类型包括：

·   ftp：指定用户可以使用FTP服务。

·   http：指定用户可以使用HTTP服务。

·   https：指定用户可以使用HTTPS服务。

·   lan-access：指定用户可以使用lan-access服务。主要指以太网接入，比如用户可以通过802.1X认证、MAC地址认证接入。

·   portal：指定用户可以使用Portal服务。

·   ssh：指定用户可以使用SSH服务。

·   telnet：指定用户可以使用Telnet服务。

·   terminal：指定用户可以使用terminal服务（即从Console口登录）。

## 14.4 RADIUS认证时为什么需要配置nas-ip？

RADIUS服务器通过IP地址来标识接入设备，并根据收到的RADIUS报文的源IP地址（即NAS-IP）是否与服务器所管理的接入设备的IP地址匹配，来决定是否处理来自该接入设备的认证或计费请求。

为保证认证和计费报文可被服务器正常接收并处理，接入设备上发送RADIUS报文使用的源IP地址必须与RADIUS服务器上指定的接入设备的IP地址保持一致。

缺省情况下，未指定发送RADIUS报文使用的源IP地址，设备将使用到达RADIUS服务器的路由出接口的主IPv4地址或IPv6地址作为发送RADIUS报文的源IP地址。如果接入设备上发送RADIUS报文使用的源IP地址与RADIUS服务器上指定的接入设备的IP地址不一致，可采用**nas-ip**命令进行配置。

在接入设备上配置设备发送RADIUS报文使用的源IP地址（即NAS-IP）的方法有：

·   RADIUS方案视图下，通过如下命令配置NAS-IP，只对本RADIUS方案有效；且优先级高于系统视图下的配置。

**nas-ip** { *ipv4-address* | **interface** *interface-type interface-number* | **ipv6** *ipv6-address* }

·   系统视图下，通过如下命令配置NAS-IP，对所有RADIUS方案有效；

radius nas-ip { interface interface-type interface-number | { ipv4-address | ipv6 ipv6-address } [ vpn-instance vpn-instance-name ] }

配置NAS-IP的注意事项：

·   通过指定接口配置NAS-IP和通过指定IP来配置NAS-IP的方式不可同时使用，后配置的生效。

·   为避免物理接口故障时从服务器返回的报文不可达，可使用Loopback接口地址为发送RADIUS报文使用的源IP地址。

## 14.5 802.1X在线用户握手功能的应用场景和注意事项有哪些？

802.1X在线用户握手功能是指：802.1X用户在线期间，设备通过向客户端定期发送握手报文的方法，对用户的在线情况进行监测。具体的说，通过**dot1x handshake**命令开启设备的在线用户握手功能后，设备会根据**dot1x timer handshake-period**命令设置的时间间隔，向在线用户发送握手请求报文（EAP-Request/Identity），以定期检测用户的在线情况。如果设备连续多次（通过命令**dot1x retry**设置）没有收到客户端的应答报文（EAP-Response/Identity），则将用户置为下线状态。开启802.1X在线用户握手功能，可以防止802.1X用户因为异常原因下线而设备无法感知。

802.1X在线握手功能的注意事项如下：

·   部分802.1X客户端不支持与设备进行握手报文的交互，建议在这种情况下，执行命令undo dot1x handshake关闭设备的在线用户握手功能，避免该类型的在线用户因没有回应握手报文而被强制下线。

·   设备在线用户过多，资源不够，需要适当增加握手时间间隔（通过命令**dot1x timer handshake-period**设置）和向接入用户发送认证请求报文的最大次数（通过命令**dot1x** **retry**设置），重新进行认证尝试。

## 14.6 在线用户握手安全功能有哪些使用限制？

开启在线用户握手安全功能（可执行**dot1x handshake secure**命令来开启）后，可以防止在线的802.1X认证用户使用非法的客户端与设备进行握手报文的交互，而逃过代理检测、双网卡检测等iNode客户端的安全检查功能。

需要注意的是：

只有设备上的在线用户握手功能处于开启状态时，安全握手功能才会生效。

本功能仅能在iNode客户端和iMC服务器配合使用的组网环境中生效。

## 14.7 什么情况下需要开启在线握手成功报文功能？

端口上开启在线用户握手功能（可执行**dot1x handshake**命令来开启）后，缺省情况下，设备收到该端口上802.1X在线用户的在线握手应答报文（EAP-Response/Identity报文）后，则认为该用户在线，并不给客户端回应在线握手成功报文（EAP-Success报文）。但是，有些802.1X客户端如果没有收到设备回应的在线握手成功报文（EAP-Success报文），就会自动下线。为了避免这种情况发生，需要在端口上配置**dot1x handshake reply enable**命令来开启发送在线握手成功报文功能。

只有当802.1X客户端需要收到在线握手成功报文时，才需要开启此功能。

## 14.8 配置设备端和服务端的认证、授权、计费时需要注意什么？

配置认证、授权、计费时，需保证设备端与服务器的配置一致，否则会导致用户上线失败。常见的例如以下情况均会导致上线失败：

·   远端服务器侧已配置用户授权vlan为vlan name，但设备并不存在这个name，导致授权失败。

·   设备上与IMC配置的授权密码不一致，会导致无法上线。

·   接入设备上配置的Portal密钥和Portal认证服务器上配置的密钥不一致，导致Portal认证服务器报文验证出错，Portal认证服务器拒绝弹出认证页面。在Portal认证服务器视图下使用**display this**命令查看接入设备上是否配置了Portal认证服务器密钥，若没有配置密钥，请补充配置；若配置了密钥，请在Portal认证服务器视图中使用**ip**或**ipv6**命令修改密钥，或者在Portal认证服务器上查看对应接入设备的密钥并修改密钥，直至两者的密钥设置一致。

## 14.9 什么情况下需要配置允许MAC迁移功能？

允许MAC迁移功能是指，允许在线的802.1X用户、MAC地址认证用户或Web认证用户迁移到设备的其它端口上或迁移到同一端口下的其它VLAN（指不同于上一次发起认证时所在的VLAN）接入后可以重新认证上线。可以通过在接口下执行**port-security mac-move permit**命令用来开启允许MAC迁移功能。缺省情况下，允许MAC迁移功能处于关闭状态。

通常，不建议开启该功能，只有在用户漫游迁移需求的情况下建议开启此功能。

需要注意的是：

如果用户进行MAC地址迁移前，服务器在线用户数已达到上限，则用户MAC地址迁移不成功。

对于迁移到同一端口下的其它VLAN内接入的用户，MAC地址认证的多VLAN模式优先级高于MAC迁移功能。当开启端口的多VLAN模式（通过**mac-authentication host-mode multi-vlan**命令）后，设备直接允许用户在新的VLAN通过，无需再次认证。

## 14.10 如何配置和查看802.1X用户使用的强制认证域？

在端口上指定强制认证域为802.1X接入提供了一种安全控制策略。所有从该端口接入的802.1X用户将被强制使用指定的认证域来进行认证、授权和计费，从而防止用户通过恶意假冒其它域账号从本端口接入网络。另外，管理员也可以通过配置强制认证域对不同端口接入的用户指定不同的认证域，从而增加了管理员部署802.1X接入策略的灵活性。

缺省情况下，未指定802.1X用户使用的强制认证域。在二层以太网接口视图或二层聚合接口视图（产品不支持二层聚合口除外）下，通过**dot1x mandatory-domain**命令可以指定端口上802.1X用户使用的强制认证域。通过**display dot1x**命令的“Mandatory auth domain”字段可以查看指定接口的802.1X强制认证域配置。

## 14.11 当前ISP域中未指定具体授权方法的情况下，缺省授权方法是什么？如何配置缺省授权？

每个接入用户都属于一个ISP域，如果用户所属的ISP域下未配置任何认证、授权、计费方法，系统将使用缺省的认证、授权、计费方法，分别为本地认证、本地授权和本地计费。以配置授权为例，缺省情况下，ISP域的缺省授权方法为**local**。在当前ISP域视图下，可以通过如下命令配置缺省的授权方法：

authorization default { hwtacacs-scheme hwtacacs-scheme-name [ radius-scheme radius-scheme-name ] [ local ] [ none ] | local [ none ] | none | radius-scheme radius-scheme-name [ hwtacacs-scheme hwtacacs-scheme-name ] [ local ] [ none ] }

需要注意的是：

在一个ISP域中，只有配置的认证和授权方法中引用了相同的RADIUS方案时，RADIUS授权过程才能生效。

可以指定多个备选的授权方法，在当前的授权方法无效时按照配置顺序尝试使用备选的方法完成授权。例如，**radius-scheme** *radius-scheme-name* **local** **none**表示，先进行RADIUS授权，若RADIUS授权无效则进行本地授权，若本地授权也无效则不进行授权。

## 14.12 使用iNode客户端作为802.1X客户端时，iNode该如何配置？

以iNode PC 7.3版本为例配置客户端如下：

(1)   启动客户端

图14-1 iNode客户端界面示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458690_image014_1644624_30005_0.png)

 

(2)   新建802.1X连接

点击<新建>按钮，进入新建连接向导对话框。

图14-2 新建802.1X连接示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458691_image015_1644624_30005_0.png)

 

(3)   输入用户名和密码

图14-3 802.1X用户名、密码配置示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458706_x_Img_x_png_22_1644624_30005_0.png)

 

需要注意：iNode认证连接的用户名、设备用于认证的域以及服务器的后缀三者密切相连，具体的配置关系参见下表。

表14-1 认证域配置关系表

| iNode认证连接的用户名 | 设备用于认证的domian                 | 设备配置的相关命令 | iMC中的服务后缀 |
| --------------------- | ------------------------------------ | ------------------ | --------------- |
| X@Y                   | Y                                    | with-domain        | Y               |
| without-domain        | 无                                   |                    |                 |
| X                     | Default domain  (设备上指定的缺省域) | with-domain        | Default domain  |
| without-domain        | 无                                   |                    |                 |

 

(4)   设置连接属性

图14-4 802.1X连接属性配置示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458692_image017_1644624_30005_0.png)

 

需要注意的是：用户选项中如果选择了“上传客户端版本号”则客户端会对标准的认证协议进行扩展，在上传用户名的报文中添加客户端版本号来与iMC服务器配合进行认证。如果不选此项，则采用标准的EAP报文进行身份认证。

如果配置的认证方式为RADIUS认证失败转本地认证，由于本地认证不能对客户端上传的版本号进行识别，请不要勾选“上传客户端版本号”选项。

(5)   发起802.1X连接

完成新建连接后，点击iNode客户端的<连接>按钮，发起802.1X连接。

## 14.13 端口安全模式分为哪两类？配置之前，端口需要满足什么条件？

端口安全模式分为两大类：控制MAC学习类和认证类。缺省情况下，端口处于noRestrictions模式，此时该端口的安全功能关闭，端口处于不受端口安全限制的状态。通过**port-security port-mode**命令可以配置端口安全模式。

·   控制MAC学习类：无需认证，包括端口自动学习MAC地址和禁止MAC地址学习两种模式。

·   认证类：利用MAC地址认证和802.1X认证机制来实现，包括单独认证和组合认证等多种模式。

在配置端口安全模式之前，端口上首先需要满足以下条件：

·   802.1X认证关闭。

·   MAC地址认证关闭。

·   端口未加入业务环回组。

·   对于autoLearn模式，还需要提前设置端口安全允许的最大安全MAC地址数。但是如果端口已经工作在autoLearn模式下，则无法更改端口安全允许的最大安全MAC地址数。

## 14.14 802.1X环境如何实现终端免认证？

开启802.1X功能的设备可以通过配置端口静态绑定MAC地址来实现终端免认证。缺省情况下，未配置任何MAC地址表项，可通过**mac-address** **static**命令配置静态MAC地址绑定端口。例如：需要实现免认证的终端的MAC地址为0001-0001-0001，与交换机的端口GE1/0/1端口相连，GE1/0/1端口属于VLAN10，通过在系统视图下执行mac-address static 0001-0001-0001 interface GigabitEthernet 1/0/1 vlan 10命令，配置静态MAC地址绑定端口，从而实现免认证。

## 14.15 设备对RADIUS 15号属性的检查方式该如何配置？

RADIUS 15号属性为Login-Service属性，该属性携带在Access-Accept报文中，由RADIUS服务器下发给设备，表示认证用户的业务类型，例如属性值0表示Telnet业务。设备检查用户登录时采用的业务类型与服务器下发的Login-Service属性所指定的业务类型是否一致，如果不一致则用户认证失败。由于RFC中并未定义SSH、FTP和Terminal这三种业务的Login-Service属性值，因此设备无法针对SSH、FTP、Terminal用户进行业务类型一致性检查，为了支持对这三种业务类型的检查，H3C为Login-Service属性定义了下表所示的扩展取值。

表14-2 扩展的Login-Service属性值

| 属性值 | 描述                     |
| ------ | ------------------------ |
| 50     | 用户的业务类型为SSH      |
| 51     | 用户的业务类型为FTP      |
| 52     | 用户的业务类型为Terminal |

 

可以通过配置设备对RADIUS 15号属性的检查方式，控制设备是否使用扩展的Login-Service属性值对用户进行业务类型一致性检查。

·   严格检查方式（**strict**）：设备使用标准属性值和扩展属性值对用户业务类型进行检查，对于SSH、FTP、Terminal用户，当RADIUS服务器下发的Login-Service属性值为对应的扩展取值时才能够通过认证。

·   松散检查方式（**loose**）：设备使用标准属性值对用户业务类型进行检查，对于SSH、FTP、Terminal用户，在RADIUS服务器下发的Login-Service属性值为0（表示用户业务类型为Telnet）时才能够通过认证。

在RADIUS方案视图下，通过执行**attribute 15 check-mode** { **loose** | **strict** }命令用来配置对RADIUS Attribute 15的检查方式。

由于某些RADIUS服务器不支持自定义的属性，无法下发扩展的Login-Service属性，若要使用这类RADIUS服务器对SSH、FTP、Terminal用户进行认证，建议设备上对RADIUS 15号属性值采用松散检查方式。

## 14.16 对802.1X用户进行周期性重认证时，设备按什么顺序为其选择重认证时间间隔？

对802.1X用户进行周期性重认证时，设备将按照如下先后顺序为其选择重认证时间间隔：

(1)   服务器下发的重认证时间间隔；

(2)   通过接口视图下的**dot1x timer** **reauth-period**命令配置的周期性重认证定时器的值；

(3)   通过系统视图下的**dot1x timer** **reauth-period**命令配置的周期性重认证定时器的值；

(4)   设备缺省的周期性重认证定时器的值：3600秒。

## 14.17 802.1X的Free IP功能是否可以与端口安全同时开启？

在802.1X的EAD快速部署方案中，可允许未通过认证的802.1X终端用户访问指定的IP地址段，该IP地址段中通常配置一个或多个特定服务器，用于提供EAD客户端的下载升级或者动态地址分配等服务。这种网段称为Free IP，可通过**dot1x ead-assistant free-ip**命令进行配置。

由于端口安全特性不支持802.1X的EAD的快速部署功能，全局使能端口安全功能将会使EAD快速部署功能失效。如果接口下开启了端口安全，会导致配置free-ip不生效，建议删除。

## 14.18 802.1X的Free IP功能是否可以与MAC地址认证同时开启？

在802.1X的EAD快速部署方案中，可允许未通过认证的802.1X终端用户访问指定的IP地址段，该IP地址段中通常配置一个或多个特定服务器，用于提供EAD客户端的下载升级或者动态地址分配等服务。这种网段称为Free IP，可通过**dot1x ead-assistant free-ip**命令进行配置。

部分设备上，EAD快速部署功能和MAC地址认证功能互斥。

部分设备上，支持同时配置EAD快速部署辅助功能和MAC地址认证功能，需要注意的是：

·   同时开启EAD快速部署辅助功能和MAC地址认证功能时，MAC地址认证用户认证失败后，该用户的MAC地址不会加入静默MAC。若服务器上没有相关的用户信息，MAC地址认证用户认证失败后，需要等EAD表项老化之后，才能再次触发认证。

·   开启EAD快速部署辅助功能与MAC地址认证的Guest VLAN、Guest VSI或Critical VLAN、Critical VSI功能不建议同时配置，否则可能导致MAC地址认证的Guest VLAN、Guest VSI或Critical VLAN、Critical VSI功能无法正常使用。

·   同时开启EAD快速部署辅助功能和MAC地址认证功能时，不建议同时配置Web认证或IP Source Guard功能，否则可能导致Web认证或IP Source Guard功能无法正常使用。

·   开启EAD快速部署辅助功能后，对于在使能EAD快速部署辅助功能之前就加入静默MAC的用户，需要等静默MAC老化后才能触发EAD快速部署功能。

## 14.19 为什么在接入设备上强制Portal用户下线失败？

在接入设备上使用**portal delete-user**命令强制用户下线时，由接入设备主动发送下线通知报文到Portal认证服务器，Portal认证服务器会在指定的端口监听该报文（缺省为50100），但是接入设备发送的下线通知报文的目的端口和Portal认证服务器真正的监听端口不一致，故Portal认证服务器无法收到下线通知报文，Portal认证服务器上的用户无法下线。

当使用客户端的“断开”属性让用户下线时，由Portal认证服务器主动向接入设备发送下线请求，其源端口为50100，接入设备的下线应答报文的目的端口使用请求报文的源端口，避免了其配置上的错误，使得Portal认证服务器可以收到下线应答报文，从而Portal认证服务器上的用户成功下线。

使用**display portal server**命令查看接入设备对应服务器的端口，并在系统视图中使用**portal server**命令修改服务器的端口，使其和Portal认证服务器上的监听端口一致。

## 14.20 什么情况需要配置认证触发功能？

对于不支持主动发送EAPOL-Start报文来发起802.1X认证的客户端，设备支持配置认证触发功能，即设备主动向该端口上的客户端发送认证请求来触发802.1X认证。设备提供了以下两种类型的认证触发功能：

·   组播触发功能：启用了该功能的端口会定期（间隔时间通过命令**dot1x timer tx-period**设置）向客户端组播发送EAP-Request/Identity报文来检测客户端并触发认证。

·   单播触发功能：当启用了该功能的端口收到源MAC地址未知的报文时，会主动向该MAC地址单播发送EAP-Request/Identity报文，若端口在指定的时间内（通过命令**dot1x timer tx-period**设置）没有收到客户端的响应，则重发该报文（重发次数通过命令**dot1x retry**设置）。

缺省情况下，组播触发功能处于开启状态，单播触发功能处于关闭状态。

建议组播触发功能和单播触发功能不要同时开启，以免认证报文重复发送。

## 14.21 什么情况下端口会加入Critical VLAN？

802.1X Critical VLAN功能允许用户在认证时，当所有认证服务器都不可达的情况下访问某一特定VLAN中的资源，这个VLAN称之为Critical VLAN。目前，只采用RADIUS认证方式的情况下，在所有RADIUS认证服务器都不可达后，端口才会加入Critical VLAN。若采用了其它认证方式，则端口不会加入Critical VLAN。

## 14.22 端口安全允许的最大用户接入数有何限制？

端口安全允许某个端口下有多个用户接入，但是允许的用户数不能超过规定的最大值。

配置端口允许的最大安全MAC地址数有两个作用：

·   控制端口允许接入网络的最大用户数。对于采用802.1X、MAC地址认证或者两者组合形式的认证类安全模式，端口允许的最大用户数取通过**port-security max-mac-count** *max-count* [ **vlan** [ *vlan-id-list* ] ]命令配置的*max-count*值与相应模式下允许认证用户数*max-number*（通过**dot1x** **max-user** *max-number*命令配置端口上最多允许同时接入的802.1X用户数，通过**mac-authentication** **max-user** *max-number*命令配置端口上最多允许同时接入的MAC地址认证用户数）的最小值；

·   控制autoLearn模式下端口能够添加的最大安全MAC地址数。如果配置了**vlan**关键字，但未指定具体的*vlan-id-list*时，可控制接口允许的每个VLAN内的最大安全MAC地址数；否则表示控制指定*vlan-id-list*内的最大安全MAC地址数。

## 14.23 同一端口下，同时进行MAC地址认证的终端过多时，重新认证时间间隔该如何设置？

用户被加入Guest VLAN或Guest VSI之后，设备将以指定的时间间隔对该用户定期发起重新认证，可通过**mac-authentication guest-vlan re-authenticate**命令开启Guest VLAN中用户的重新认证功能（通过**mac-authentication guest-vsi re-authenticate**命令开启Guest VSI中用户的重新认证功能），设备缺省开启Guest VLAN和Guest VSI中用户的重新认证功能。

当端口上同时进行认证的用户数大于300时，建议通过**mac-authentication guest-vlan auth-period**命令将设备对Guest VLAN中的用户进行重新认证的时间间隔（通过**mac-authentication guest-vsi auth-period**命令将设备对Guest VSI中的用户进行重新认证的时间间隔）设置为30秒以上。

## 14.24 IP Source Guard动态绑定表项可以来源于哪些功能模块？

IP Source Guard功能通常配置在接入用户侧的接口上，通过手工配置或动态获取的表项对接口收到的报文进行过滤控制，以防止非法用户报文通过，从而限制了对网络资源的非法使用。

在通过**ip verify source**或**ipv6 verify source**命令配置了IP Source Guard动态绑定功能的接口上，IP Source Guard可以通过与不同的模块配合生成IP Source Guard动态绑定表项。

表14-3 IP Source Guard动态绑定功能信息表

| 接口类型                   | IPv4表项来源模块            | IPv6表项来源模块             |
| -------------------------- | --------------------------- | ---------------------------- |
| 二层以太网接口             | DHCP Snooping、ARP Snooping | DHCPv6 Snooping、ND Snooping |
| 802.1X                     | 802.1X                      |                              |
| 三层以太网接口  或VLAN接口 | DHCP中继                    | DHCPv6中继、ND RA            |
| DHCP服务器                 | DHCPv6服务器                |                              |

 

需要注意的是：要实现IP Source Guard动态绑定功能正常使用，请保证网络中的802.1X、ARP Snooping 、DHCP Snooping、DHCP中继、DHCP服务器或ND RA配置有效且工作正常。

## 14.25 配置了IP Source Guard静态绑定表项，为什么绑定功能不生效？

在全局或接口视图下通过ip source binding命令，可配置IP Source Guard静态绑定表项。只有同时在接口下通过ip verify source命令配置IPv4接口绑定功能，才算打开根据绑定表项过滤报文的开关。这种情况下设备通过配置的IPv4静态绑定表项和从其它模块获取的IPv4动态绑定表项对接口转发的报文进行过滤或者配合其它模块提供相关的安全服务。

## 14.26 Portal HTTPS重定向为什么不生效？

HTTP重定向是一种将用户的HTTP/HTTPS请求转到某个指定URL的方法，对HTTP请求报文，无需进行任何配置，设备即可进行重定向处理；对于HTTPS报文，必须配置对HTTPS报文进行重定向的内部侦听端口号，设备才会进行重定向。

缺省情况下，对HTTPS报文进行重定向的内部侦听端口号为6654。为了避免端口号冲突导致服务不可用，需确保内部侦听端口号不是知名协议使用的端口号，且不能被其它基于TCP协议的服务占用（已被其他服务占用的TCP端口号可以通过display tcp命令查看）。可通过http-redirect https-port命令配置对HTTPS报文进行重定向的内部侦听端口号。

## 14.27 为什么需要配置RADIUS报文的共享密钥？

RADIUS客户端与RADIUS服务器使用MD5算法并在共享密钥的参与下生成验证字，接受方根据收到报文中的验证字来判断对方报文的合法性。只有在共享密钥一致的情况下，彼此才能接收对方发来的报文并作出响应。

通常，在设备上配置RADIUS认证/计费服务器时应同时指定与主/备服务器交互的共享密钥，配置命令为**primary accounting**、**primary authentication**、**secondary accounting**、**secondary authentication**。若通过上述命令指定服务器时未同时配置共享密钥，则需要通过在RADIUS方案视图下执行**key**命令来配置RADIUS报文的共享密钥。

需要注意的是：必须保证设备上设置的共享密钥与RADIUS服务器上的完全一致。

## 14.28 配置AAA时如果没有计费服务器，需要配置当前ISP域的计费方法吗？

ISP域的缺省计费方法为**local**，即本地计费。因此，即使没有指定远程计费服务器，也需要通过配置ac**counting default none**命令将当前ISP域的缺省计费方法配置为不计费，否则会导致用户认证失败。

## 14.29 在ISP域下，若配置AAA认证/授权/计费方法使用的RADIUS方案不存在，AAA认证/授权/计费方法会生效吗？

在ISP域下，若配置AAA认证/授权/计费方法使用的RADIUS方案不存在，AAA认证/授权/计费方法不会生效。可以执行**display radius scheme**命令查看ISP域下AAA认证/授权/计费方法中指定的RADIUS方案是否存在。例如如下配置：

[system] domain aaa

[system-isp-aaa]authentication login radius-scheme bbb

[system-isp-aaa]display radius scheme bbb

The RADIUS scheme does not exist.

虽然为login用户配置的认证方法指定了RADIUS方案bbb，但RADIUS方案bbb实际不存在，所以配置不生效。

## 14.30 在实际应用场景中，若需要通过iMC服务器下发安全ACL，应该如何配置？

在实际应用场景中，若需要通过iMC服务器下发安全ACL，请在设备上通过radius session-control enable命令开启RADIUS session control功能，否则相关安全ACL无法生效。

iMC RADIUS服务器使用session control报文向设备发送授权信息（例如授权ACL/VLAN/用户组/VSI/黑洞MAC）的动态修改请求以及断开连接请求。在使用iMC RADIUS服务器且服务器需要对用户授权信息进行动态修改或强制用户下线的情况下，必须开启RADIUS session control功能。

## 14.31 802.1X在线用户较多时，用户重认证周期过长该如何解决？

当RADIUS服务器从不可达变为可达时，处于Critical VLAN或Critical VSI中的用户也会再次发起认证，在设备上802.1X在线用户较多的情况下，如果通过dot1x server-recovery online-user-sync命令开启了RADIUS服务器变为可达后的802.1X在线用户信息同步功能，会因为同时进行认证的用户数量较大，而导致用户的上线时间变长。

可以执行undo dot1x server-recovery online-user-sync命令关闭802.1X在线用户信息同步功能，使重认证周期恢复正常。

## 14.32 如何解决设备因无法感知802.1X认证用户离线导致用户再次上线失败？

设备因无法感知802.1X认证用户离线导致用户再次上线失败，通常有如下几种方法可以解决：

·   执行dot1x offline-detect enable命令开启端口的802.1X认证下线检测功能，若设备在一个下线检测定时器间隔之内，未收到此端口下某802.1X在线用户的报文，则将切断该用户的连接，同时通知RADIUS服务器停止对此用户进行计费。

·   执行port-security traffic-statistics enable命令开启端口安全接入用户的流量统计功能，设备会根据802.1X认证用户的MAC地址统计流量信息，并将统计数据发送给计费服务器。部分产品不支持此方式。

·   执行port-security mac-move permit命令开启允许MAC迁移功能，如果用户从某一端口上线成功，则允许该在线用户在设备的其它端口上（无论该端口是否与当前端口属于同一VLAN）发起认证。如果该用户在后接入的端口上认证成功，则当前端口会将该用户立即进行下线处理（不论用户在当前端口上通过哪种方式进行认证），保证该用户仅在一个端口上处于上线状态。

## 14.33 配置802.1X Guest VLAN功能前有哪些配置准备？

配置802.1X Guest VLAN之前，需要进行以下配置准备：

·   创建需要配置为Guest VLAN的VLAN。

·   在接入控制方式为MAC-based的端口上，保证端口类型为Hybrid，端口上的MAC VLAN功能处于使能状态。MAC VLAN功能的具体配置请参见“二层技术-以太网交换配置指导”中的“VLAN”。

## 14.34 端口接入控制方式为Port-based时可以配置单播触发功能吗？

单播触发功能建议只在端口接入控制方式为MAC-based时配置；若在端口接入控制方式为Port-based时配置单播触发功能，可能会导致用户正常无法上线。

另外，建议组播触发功能和单播触发功能不要同时开启，以免认证报文重复发送。

## 14.35 如何配置MAC地址认证用户使用的账号格式？

开启MAC地址认证后，设备默认使用用户的MAC地址作为用户名和密码，其中字母为小写，且不带连字符“-”。可以通过执行**mac-authentication user-name-format**命令来配置MAC地址认证用户的账号格式。MAC地址认证用户认证时，请确保使用的用户名格式符合配置的账户格式，否则，将导致认证失败。

需要注意的是：**mac-authentication mac-range-account**命令（用来配置指定MAC地址范围的MAC地址认证用户名和密码）的优先级高于**mac-authentication user-name-format**命令。缺省情况下，未对指定MAC地址范围的MAC地址认证用户设置用户名和密码，MAC地址认证用户采用**mac-authentication user-name-format**命令设置的用户名和密码接入设备。

## 14.36 开启802.1X或MAC地址认证对端口安全功能有何影响？

如果已全局开启了802.1X或MAC地址认证，则无法使能端口安全。

反之，如果开启了端口安全，则不能开启端口上的802.1X以及MAC地址认证，也不能修改802.1X端口接入控制方式和端口授权状态，它们只能随端口安全模式的改变由系统更改。

可以通过undo port-security enable命令关闭端口安全。但需要注意的是，在端口上有用户在线的情况下，关闭端口安全会导致在线用户下线。

执行使能或关闭端口安全的命令后，端口上的相关配置将会恢复为如下情况：

·   802.1X端口接入控制方式恢复为**macbased**；

·   802.1X端口的授权状态恢复为**auto**。

## 14.37 如何修改端口安全模式？

二层以太网接口或二层聚合接口视图下，通过执行**port-security port-mode**命令可配置端口安全模式。缺省情况下，端口处于noRestrictions模式，此时该端口的安全功能关闭，端口处于不受端口安全限制的状态。

当端口安全已经使能且当前端口安全模式不是noRestrictions时，若要改变端口安全模式，必须首先执行**undo port-security port-mode**命令恢复端口安全模式为noRestrictions模式；再重新配置为其它端口安全模式。

端口上有用户在线的情况下，端口安全模式无法改变。

端口安全模式与端口下的802.1X认证使能、端口接入控制方式、端口授权状态以及端口下的MAC地址认证使能配置互斥。

# 15 路由

## 15.1 路由配置不完整或配置错误会导致网络出现哪些故障，如何进行排查？

可能会出现的故障有：

·   交换机或主机设备跨网段Ping不通某个IP地址

·   主机无法跨网段访问交换机设备的web页面

·   交换机直连网段的设备无法访问外部网络

·   交换机学习不到跨网段设备的ARP表项

·   交换机到达目的地址的路由单通，只能发送或只能接收数据包

在排查路由问题之前，需要确保网络中没有出现链路故障，并且各设备的IP地址配置正确、网段未发生冲突。

·   如果主机通过交换机无法访问其他网段的设备，则需要检查主机设备上是否配置了正确的网关地址。如果修改后仍无法访问，则需要继续检查交换机的路由配置。

·   如果交换机无法访问目的网络地址的设备，则需要检查交换机上有没有到达目的网络地址的路由，中间设备有没有到达源地址和目的网段地址的路由，以及目的设备有没有正确的回程路由。

如[图15-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref65521672)所示，当用户在SwitchA上配置了去往服务器B所在网段10.2.2.0/24的路由后，终端A还是无法与服务器B进行通信。

图15-1 三层通信示意图

![img](https://resource.h3c.com/cn/202207/07/20220707_7458707_x_Img_x_png_24_1644624_30005_0.png)

 

一般情况下终端A和服务器B之间的通信是双向的，即不仅SwitchA上要有到10.2.2.0/24的路由，而且SwitchB上也要有到10.1.1.0/24的路由。因此，当用户在SwitchA上配置了去往服务器B所在网段10.2.2.0/24的路由后，还要在SwitchB上配置去往终端A所在的网段10.1.1.0/24的路由。在只有同时满足这两个条件，终端A才能与服务器B正常通信。

## 15.2 在同一设备上配置的VPN网段和公网网段相同，会冲突吗？

会因为网段冲突而导致网络故障。在同一设备上配置的VPN网段和公网网段相同，其他设备在转发报文时，优先选择直连路由的下一跳地址，而不是为VPN网段配置的静态路由下一跳，导致ping不通。需要将直连网段地址修改为其他网段的地址才可解决该问题。

## 15.3 策略路由配置错误导致Ping不通故障如何排查？

配置了策略路由后，满足一定条件的报文会优先通过策略路由执行指定的操作（例如设置报文的下一跳）。如果策略路由配置错误，可能会导致报文转发失败。

可通过如下步骤查看策略路由的配置，并作出相应的修改。

(1)   执行**display ip policy-based-route**命令，查看已经配置的策略。如果配置了策略路由，则继续执行下一步。

(2)   执行display ip policy-based-route setup命令，查看已经应用的策略路由信息，并分别通过如下命令查看具体类型的策略路由信息：

¡   执行display ip policy-based-route local命令，查看本地策略路由的配置信息和统计信息

¡   执行**display ip policy-based-route interface**命令，查看接口下转发策略路由的配置信息和统计信息

¡   执行**display ip policy-based-route apply**命令，查看VLAN接口上应用的策略路由及其统计信息。

¡   执行**display ip policy-based-route global**命令，查看全局策略路由的配置信息和统计信息

¡   执行**display ip policy-based-route egress interface**命令，查看VXLAN隧道接口出方向策略路由的配置信息和统计信息。

(3)   如果策略路由的if-match子句配置了ACL匹配规则，可通过**display** **acl**命令查看ACL的配置和运行情况。

(4)   修改策略路由，保证设备间流量正常转发。

¡   如果是策略路由的匹配规则或apply子句导致的流量不通，则需要修改策略路由的匹配规则或apply子句。

¡   如果是策略路由应用的接口错误，则需要先取消对应接口的策略路由配置，再重新将策略路由应用到正确的接口上。

¡   如果应用的全局策略路由或本地策略路由配置有误，则需要先取消对应的配置，再修改并重新应用策略路由。

## 15.4 静态路由的出接口没UP会导致Ping不通吗？

在配置静态路由时，指定的出接口需要为UP状态，否则静态路由不生效。

## 15.5 终端设备如果未配置网关，会导致通信故障吗？

会出现故障。如果组网环境中有多个网段，为实现终端设备跨网段互相通信，则终端设备需要配置网关，并且非直连的网关设备之间需要配置到达目的网段的路由。

## 15.6 为什么配置的备份静态路由未及时生效？

设备上配置了到达目的网段的主用静态路由和备用静态路由，当主用链路故障时，设备可能未及时检测到，备用链路的静态路由不能及时生效导致流量丢失。

建议配置静态路由关联track项，通过track联动nqa对主用链路进行检测。当主用链路发生故障时，设备能及时发现并撤销主用静态路由，启用备用静态路由指导报文转发，将链路故障的影响降到最低。

## 15.7 为什么配置了静态路由关联track项，却无法通过track关联的检测模块及时检测链路故障？

请按照如下顺序进行排查：

(1)   首先排查检测模块的配置是否正常，如果检查没问题，再进行下一步骤。

(2)   检查静态路由关联track项的配置是否成功。执行display current-configuration | include route-static命令查看静态路由的配置情况。在配置静态路由时，应严格按照各产品命令参考里的顺序配置各个参数，否则会配置失败。其中，description参数后面不能配置其他参数，只能输入静态路由描述信息。

## 15.8 BGP邻居关系未建立的常见原因有哪些？如果处理此类故障？

本类故障的常见原因主要包括：

·   BGP报文转发不通

·   ACL过滤了TCP的179端口

·   配置的邻居的AS号错误

·   邻居的IP地址/IPv6地址配置错误

·   未配置peer enable命令

·   用Loopback口建立邻居时没有配置peer connect-interface

·   用非直连的EBGP邻居未配置peer ebgp-max-hop

·   peer valid-ttl-hops配置错误

·   对端配置了peer ignore

·   两端的地址族不匹配

故障处理步骤：

(1)   使用ping命令检查链路是否畅通。

(2)   检查路由表中是否存在到邻居的可用路由。

(3)   使用display tcp verbose命令或display ipv6 tcp verbose命令检查TCP连接是否正常。

(4)   检查是否配置了禁止TCP端口179的ACL。

(5)   执行display current-configuration命令查看当前配置，检查邻居的AS号配置是否正确。

(6)   执行display bgp peer ipv4 unicast命令或display bgp peer ipv6 unicast命令检查邻居的IP地址/IPv6地址是否正确。

(7)   如果使用Loopback接口，检查是否配置了peer connect-interface命令。

(8)   如果是物理上非直连的EBGP邻居，检查是否配置了peer ebgp-max-hop命令。

(9)   如果配置了peer ttl-security hops命令，请检查对端是否也配置了该命令，且保证双方配置的hop-count不小于两台设备实际需要经过的跳数。

(10)   检查两端设备是否配置了peer ignore，如果想建立邻居关系，执行undo peer ignore命令即可。

(11)   请检查BGP会话两端的地址族能力是否匹配。例如，建立BGP VPNv4邻居时，需要两端都要在BGP-VPNv4地址族下配置命令peer enable。

## 15.9 怎么查看和配置等价路由条数？

当到达同一目的地址的多条等价路由的条数超过了设备支持的最大条数时，新增的等价路由无法和已存在的等价路由一起形成负载分担。

通过如下命令可以查看系统当前支持的最大等价路由的条数：

·   执行display max-ecmp-num命令用来显示系统支持IPv4最大等价路由的条数。

·   执行display ipv6 max-ecmp-num命令用来显示系统支持IPv6最大等价路由的条数。

通过如下命令可以调整系统支持的最大等价路由的条数：

·   执行max-ecmp-num命令调整设备支持的最大IPv4等价路由的条数。

·   执行**ipv6 max-ecmp-num**命令用来配置系统支持IPv6最大等价路由的条数。

部分设备不支持配置系统支持的最大等价路由的条数，在这些设备上，可以通过各路由协议视图的**maximum load-balancing**命令取值范围查看路由协议支持的最大等价路由条数。需要注意的是，等价路由模式的配置可能会影响等价路由条数，通过ecmp mode命令可以调整等价路由模式。有关等价路由模式的详细介绍，请参见“IP路由配置指导”中的“IP路由基础”。

## 15.10 不同VRF或公网与VRF如何通过三层接口实现互访？

可通过多种方式实现不同VRF之间或公网与VRF之间通过三层接口实现互相访问：

·   配置静态路由实现三层接口路由互通：在执行**ip route-static vpn-instance**命令时，同时指定源和目的VPN实例，实现不同VPN实例下三层接口之间的路由互通；在执行**ip route-static vpn-instance**命令时，指定下一跳地址属于公网实例，实现公网与指定VPN实例的路由互通；在执行**ip route-static**命令时，同时指定下一跳地址属于VPN实例，实现公网与指定VPN实例的路由互通。

·   配置BGP路由协议实现三层接口路由互通：执行**import-route**命令引入不同VPN实例的IGP路由，实现三层接口路由互通。

·   配置路由信息引入功能实现三层接口路由互通：在VPN实例IPv4地址族视图下执行**route-replicate**命令，将公网或其他VPN实例的路由信息引入到指定VPN实例中；在公网实例IPv4地址族视图下执行**route-replicate**命令，将指定VPN实例的路由信息引入到公网中。

## 15.11 设备配置前缀大于64位的IPv6路由后为什么不生效？

部分产品需要通过指定命令行开启前缀大于64位的IPv6路由功能并重启设备后，前缀大于64位的IPv6路由才会生效。不同产品的开启命令行不同：

·   部分产品通过display switch-routing-mode status命令查看前缀大于64位的IPv6路由功能的配置情况。通过switch-routing-mode ipv6-128命令开启前缀大于64位的IPv6路由功能。

·   部分产品通过display hardware-resource routing-mode命令查看前缀大于64位的IPv6路由功能的配置情况。通过hardware-resource routing-mode ipv6-128命令开启前缀大于64位的IPv6路由功能。

## 15.12 部署OSPF后，为什么无法建立邻居关系？

OSPF邻居无法建立的常见原因主要包括：

·   物理连接和下层协议故障

·   接口没有up

·   两端IP地址不在同一网段

·   Router ID配置冲突

·   两端区域类型不一致

·   两端OSPF参数配置不一致

请尝试按照如下步骤排除故障：

(1)   使用display ospf interface命令查看OSPF接口的信息。如果接口状态为Down，表明此接口没有发送和接收任何路由协议的报文，请检查接口是否up。

(2)   检查物理连接及下层协议是否正常运行，可通过ping命令测试。若从本地路由器Ping对端路由器不通，则表明物理连接和下层协议有问题。

(3)   检查接口上配置的OSPF参数，必须保证与相邻路由器的参数一致，区域号相同，网段与掩码也必须一致（点到点与虚连接的网段与掩码可以不同）。如果配置了验证，需要保证：

¡   如果使用OSPF区域验证，需要保证一个区域中所有路由器的验证模式和验证密码必须一致。如果引用keychain验证方式，必须使用OSPF能够支持的验证算法。

¡   如果使用OSPF接口验证，需要保证同一网段的接口的验证字口令必须相同。如果引用keychain验证方式，必须使用OSPF能够支持的验证算法。

(4)   检查OSPF定时器，在同一接口上邻居失效时间应至少为Hello报文发送时间间隔的4倍。

(5)   如果是NBMA网络，则应该使用peer ip-address命令手工指定邻居。

(6)   如果网络类型为广播网或NBMA，则至少有一个接口的路由器优先级大于零。

# 16 组播

## 16.1 组播组网，接入设备配置二层组播后，为什么网络卡顿、延迟高？

需要配置未知组播数据报文丢弃功能。

当未配置丢弃未知组播数据报文功能时，二层设备收到未知组播数据报文时，会在未知组播数据报文所属的VLAN/VSI内广播该报文。当二层设备收到的大量未知组播报文时，网络中会充斥着大量的未知组播报文，从而导致网络卡顿、延迟高，如[图16-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref57645596)所示。

配置丢弃未知组播数据报文后，二层设备只向其路由器端口转发未知组播数据报文，不在VLAN/VSI内广播；如果二层设备没有路由器端口，未知组播数据报文会被丢弃，不再转发。

图16-1 配置丢弃未知组播数据报文功能前后的对比

![img](https://resource.h3c.com/cn/202207/07/20220707_7458708_x_Img_x_png_25_1644624_30005_0.png)

 

## 16.2 组播组网，二层接入设备配置了IGMP Snooping和IGMP Snooping drop-unknown功能后，为什么组播转发表项异常？

需要将二层接入设备的IGMP Snooping版本配置为3。

缺省情况下，二层设备开启IGMP Snooping功能后，设备上的IGMP Snooping版本为2。当三层设备的IGMP版本和用户主机的IGMP版本为3时，二层设备收到用户主机发送的IGMPv3的成员关系报告报文后，无法处理IGMPv3的成员关系报文，将在VLAN/VSI内广播该报文。

将二层设备的IGMP Snooping版本修改为3后，IGMP Snooping设备在收到IGMP成员关系报告报文时，二层设备将其通过VLAN/VSI内的所有路由器端口转发出去，从该报文中解析出主机要加入的组播组地址，并对该报文的接收端口做如下处理：

·   如果不存在该组播组所对应的转发表项，则创建转发表项，将该端口作为动态成员端口添加到出端口列表中，并启动其老化定时器；

·   如果已存在该组播组所对应的转发表项，但其出端口列表中不包含该端口，则将该端口作为动态成员端口添加到出端口列表中，并启动其老化定时器；

·   如果已存在该组播组所对应的转发表项，且其出端口列表中已包含该动态成员端口，则重置其老化定时器。

## 16.3 什么情况下需要配置查询器？是否可以配置多个查询器？

在运行了IGMP的组播网络中，会有一台三层组播设备充当IGMP查询器。该查询器负责发送IGMP查询报文，在网络层建立并维护组播转发表项，从而正常转发组播数据。

当组播组网中没有三层设备时，而二层设备不支持IGMP。如果没有设备充当查询器，会导致无法建立组播转发表项。此时就需要在二层设备上开启IGMP Snooping查询器功能，从而能够在数据链路层建立并维护组播转发表项。

为了防止因单一IGMP Snooping查询器发生故障而引起组播业务中断，在同一网段、同一VLAN/VSI内可以配置多个查询器。但正常情况下，同一网段、同一VLAN/VSI内只需要一个查询器。过多的查询器会导致网络中充斥着大量的查询报文、组播接收者也会接收到多份同样的数据报文，导致网络非常拥塞。

通过在设备上开启IGMP Snooping查询器选举功能可以解决这个问题。选举出的IGMP Snooping查询器发生故障无法正常工作后，VLAN/VSI内各设备会重新选举出新的IGMP Snooping查询器以保证组播业务正常转发。

## 16.4 同一PIM域内，配置三层组播功能后，三层组播流量不通？

本类故障的常见原因主要包括：

(1)   单播路由不通。

(2)   未开启multicast routing功能。

(3)   未正确配置PIM和IGMP功能。

(4)   对于PIM-SM或双向PIM网络，没有配置RP或RP信息不正确。

(5)   转发组播数据的接口上配置了组播边界。

(6)   对于PIM-SM或双向PIM网络，配置了错误的组播源过滤策略。

(7)   组播转发表项未生成。

问题定位过程如下：

(1)   检查组播转发路径上单播路由是否正常。使用ping命令检查组播源与组播接收者间的单播路由是否正常。若无法ping通，使用display ip routing-table命令查看路由表项是否存在到达组播源和组播接收者的路由。若没有，请先排查单播路由配置是否正确。若单播路由没有问题，请执行步骤（2）。

(2)   检查所有三层组播设备上是否开启了multicast routing功能。缺省情况下，multicast routing功能处于关闭状态。在系统视图下，使用display this命令查看是否开启了multicast routing。若所有三层组播设备上开启了multicast routing功能，请执行步骤（3）。

(3)   检查是否正确配置PIM和IGMP功能。在组播转发路径上，除连接组播接收者的端口上，均需要开启PIM功能；连接组播接收者的端口上，需要开启IGMP功能。在接口视图，使用display this命令查看当前端口上是否配置了igmp enable或者pim dm、pim sm。若所有设备上正确配置PIM和IGMP功能：

a.   对于PIM SM或者双向PIM网络，请执行步骤（4）。

b.   对于PIM DM网络，请执行步骤（5）。

(4)   对于PIM-SM或双向PIM，检查是否配置了RP且RP信息配置是否正确。在设备上使用display pim rp-info查看不同设备上的RP信息是否正确，主要检查如下字段：Scope、Group/MaskLen、RP address，确认服务于相同组播组的RP地址是否在相同、是否在相同的PIM域内。若RP信息不正确，请在所有设备上执行c-rp/**static-rp**命令将为某组播组服务的RP地址配置为一致，若RP信息配置正确，请执行步骤（5）。

(5)   检查组播转发路径上的接口是否配置了组播转发边界。在转发组播数据的接口上执行display this命令，查看接口的配置信息中是否配置multicast boundary命令。若存在，使用**undo multicast boundary**命令删除该配置。若不存在，请执行步骤（6）。

(6)   检查组播转发路径上是否配置了组播数据过滤器。在组播转发路径的设备上，进入PIM视图，使用display this命令查看是否配置了**source-policy**命令。若配置了，检查过滤策略是否正确。若过滤策略不正确，请删除该过滤器或者通过**source-policy**命令调整组播数据报文的源地址范围。若没有配置，请执行步骤（7）。

(7)   检查组播表项是否存在。

**a.**   通过display pim routing-table命令检查设备上PIM路由表项是否存在。对于连接组播接收者的设备，设备上应该存在（*，G）和（S，G）表项。对于没有连接接收者的PIM设备，设备上应该存在（S，G）表项。

b.   通过**display multicast routing-table**和display multicast fast-forwarding cache查看组播路由表和组播快速转发表是否存在。若这2个表项不存在，组播报文会转发失败。

c.   通过如上检查，若组播表项存在，组播数据仍然转发不通，请收集表项信息，然后请执行步骤（8）。

d.   若组播表项不存在，请执行步骤（8）。

(8)   请联系H3C技术支持人员。

# 17 安全

## 17.1 为什么配置了密码控制却不生效？

没有开启全局密码控制功能，需要先开启全局密码控制功能。

(1)   进入系统视图。

system-view

(2)   开启全局密码控制功能。

password-control enable

## 17.2 设备作为SSH服务器，为什么配置了NTP后登录不上设备？

检查设备是否开启了password-control功能，此功能开启后设备对密码的控制更加严格。在password-control功能开启时，密码存在老化时间，设备配置了NTP后系统时间发生改变，密码老化。此时可通过console口登录设备，关闭password-control功能即可。

(1)   进入系统视图。

system-view

(2)   关闭password-control功能。

undo password-control enable

系统时间修改完成后，如需使用password-control功能，可正常启用。关于password-control的详细描述请参见各产品“安全配置指导”中的“Password Control”。

## 17.3 为什么无法修改设备密码？

检查设备是否开启了password-control功能，此功能开启后密码更新的最小时间间隔功能默认开启。修改密码时，通常会看到设备提示Cannot change password until the update-wait time expires.此时可通过password-control update-interval interval命令修改密码更新的最小时间间隔。

## 17.4 设备作为SSH服务器，什么情况下需要修改认证超时时间？

缺省情况下，SSH用户的认证超时时间为60秒。

为了防止不法用户建立起TCP连接后，不进行接下来的认证而空占进程，妨碍其它合法用户的正常登录，可以设置认证超时时间，如果在规定的时间内没有完成认证就拒绝该连接。

如果认证超时时间设置过短，可能会造成SSH登录设备失败，设备返回Authentication timed out for x.x.x.x（用户实际IP地址），此时在系统视图下，使用ssh server authentication-timeout命令可调整认证超时时间。

## 17.5 设备作为SSH客户端，如何删除本地文件中的指定服务器公钥？

设备作为SSH客户端，在系统视图下执行delete ssh client server-public-key可以删除本地文件中的指定服务器公钥。

设备作为SSH客户端，登录SSH服务器后，在提示信息“Do you want to save the server public key?”后输入Y，设备会保存服务器公钥到本地文件。如果SSH客户端首次连接服务器后,服务器重新生成了公钥文件，会导致客户端的公钥文件与服务器不一致，SSH客户端登录服务器失败。通常会看到提示信息：The server's host key does not match the local cached key…这种情况下，可以通过delete ssh client server-public-key删除本地文件中的指定服务器公钥解决。

## 17.6 为什么启用了SSH服务器功能后，客户端连接到设备时提示连接中断？

执行ssh server enable命令开启设备Stelnet服务器功能并配置了相应的用户后，还需要配置Stelnet客户端登录时使用的VTY用户线。

(1)   进入系统视图。

**system-view**

(2)   进入VTY用户线视图。

**line vty** *number* [ *ending-number* ]

(3)   配置登录用户线的认证方式为scheme方式。

**authentication-mode scheme**

缺省情况下，用户线认证方式为**password**方式。

若没有配置用户线的认证方式为scheme方式，连接会自动中断，无法连接到设备。

# 18 ACL和QoS

## 18.1 QoS策略流分类中配置了多条匹配规则，为什么没有一条规则能够匹配到相应的流量呢？

请修改流分类规则之间的逻辑关系为or。

当一个流分类中配置了多条if-match规则时，若指定流分类规则之间的逻辑关系为“and”时，数据包必须匹配全部规则才属于该类；若指定流分类规则之间的逻辑关系为“or”时，数据包只要匹配其中任何一个规则就属于该类。用户可通过traffic classifier命令修改各规则的逻辑关系。

## 18.2 应用ACL进行报文过滤、禁止某IP地址段的主机发出的报文通过，为什么不生效呢？

请检查ACL rule规则中IP地址的反掩码配置的是否正确。

使用ACL匹配报文的源或目的IP地址时，紧挨着IP地址后面输入的是反掩码，而不是掩码。

例如，如果您希望匹配192.168.1.0/24这个IP地址段的所有IP地址，您在ACL中使用rule命令配置的“IP地址+反掩码”应为“192.168.1.0 0.0.0.255”。

## 18.3 在VLAN接口上应用ACL进行报文过滤，对二层转发报文不生效。

可通过如下两种方式之一解决：

·   请将VLAN接口上配置的报文过滤删除，然后在相应的二层以太网接口上重新配置。

·   对于支持packet-filter filter命令的设备，在VLAN接口视图下配置packet-filter filter all命令。此命令的缺省情况为packet-filter filter route，即报文过滤仅对通过VLAN接口进行三层转发的报文生效。

## 18.4 为什么报文命中IP Source Guard表项，但却无法转发呢？

请执行以下命令，检查是否配置了报文过滤：

·   display packet-filter

·   display acl

若配置了报文过滤，请在报文过滤引用的ACL中配置软件统计规则。然后，使用display packet-filter statistics命令查看报文是否命中了报文过滤中的deny规则。

报文过滤优先级高于IP Source Guard，所以当报文同时匹配报文过滤和IP Source Guard表项时，报文过滤优先生效。

## 18.5 ACL规则的匹配顺序是怎么样的？

当一个ACL中包含多条规则时，报文会按照一定的顺序与这些规则进行匹配，一旦匹配上某条规则便结束匹配过程。ACL的规则匹配顺序有以下两种：

·   配置顺序：按照规则编号由小到大进行匹配。

·   自动排序：按照“深度优先”原则由深到浅进行匹配，各类型ACL的“深度优先”排序法则如[表18-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Quick_Starts/FAQ/H3C_CJWT_FAQ_Long/?CHID=711744#_Ref102743267)所示。

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458709_x_Img_x_png_26_1644624_30005_0.png)

可通过acl命令中的match-order { auto | config }参数指定规则的匹配顺序，auto表示按照自动排序（即“深度优先”原则）的顺序进行规则匹配，config表示按照配置顺序进行规则匹配。缺省情况下，规则的匹配顺序为配置顺序。用户自定义ACL不支持本参数，其规则匹配顺序只能为配置顺序。

‌

表18-1 各类型ACL的“深度优先”排序法则

| ACL类型     | “深度优先”排序法则                                           |
| ----------- | ------------------------------------------------------------ |
| IPv4基本ACL | **a**   先判断规则的匹配条件中是否包含VPN实例，包含者优先  **b**   如果VPN实例的包含情况相同，再比较源IPv4地址范围，较小者优先  **c**   如果源IPv4地址范围也相同，再比较配置的先后次序，先配置者优先 |
| IPv4高级ACL | **a**   先判断规则的匹配条件中是否包含VPN实例，包含者优先  **b**   如果VPN实例的包含情况相同，再比较协议范围，指定有IPv4承载的协议类型者优先  **c**   如果协议范围也相同，再比较源IPv4地址范围，较小者优先  **d**   如果源IPv4地址范围也相同，再比较目的IPv4地址范围，较小者优先  **e**   如果目的IPv4地址范围也相同，再比较四层端口（即TCP/UDP端口）号的覆盖范围，较小者优先  **f**   如果四层端口号的覆盖范围无法比较，再比较配置的先后次序，先配置者优先 |
| IPv6基本ACL | **a**   先判断规则的匹配条件中是否包含VPN实例，包含者优先  **b**   如果VPN实例的包含情况相同，再比较源IPv6地址范围，较小者优先  **c**   如果源IPv6地址范围也相同，再比较配置的先后次序，先配置者优先 |
| IPv6高级ACL | **a**   先判断规则的匹配条件中是否包含VPN实例，包含者优先  **b**   如果VPN实例的包含情况相同，再比较协议范围，指定有IPv6承载的协议类型者优先  **c**   如果协议范围相同，再比较源IPv6地址范围，较小者优先  **d**   如果源IPv6地址范围也相同，再比较目的IPv6地址范围，较小者优先  **e**   如果目的IPv6地址范围也相同，再比较四层端口（即TCP/UDP端口）号的覆盖范围，较小者优先  **f**   如果四层端口号的覆盖范围无法比较，再比较配置的先后次序，先配置者优先 |
| 二层ACL     | **a**   先比较源MAC地址范围，较小者优先  **b**   如果源MAC地址范围相同，再比较目的MAC地址范围，较小者优先  **c**   如果目的MAC地址范围也相同，再比较配置的先后次序，先配置者优先 |

‌

![说明](https://resource.h3c.com/cn/202207/07/20220707_7458710_x_Img_x_png_27_1644624_30005_0.png)

·   比较IPv4地址范围的大小，就是比较IPv4地址通配符掩码中“0”位的多少：“0”位越多，范围越小。通配符掩码（又称反向掩码）以点分十进制表示，并以二进制的“0”表示“匹配”，“1”表示“不关心”，这与子网掩码恰好相反，譬如子网掩码255.255.255.0对应的通配符掩码就是0.0.0.255。此外，通配符掩码中的“0”或“1”可以是不连续的，这样可以更加灵活地进行匹配，譬如0.255.0.255就是一个合法的通配符掩码。

·   比较IPv6地址范围的大小，就是比较IPv6地址前缀的长短：前缀越长，范围越小。

·   比较MAC地址范围的大小，就是比较MAC地址掩码中“1”位的多少：“1”位越多，范围越小。

 

# 19 可靠性

## 19.1 修改了VRRP备份组的VRRP使用版本后，VRRP为什么失效了？

VRRP备份组中的所有设备上配置的VRRP版本必须一致。并且如果使用的是VRRPv2版本，则VRRP通告报文时间间隔也必须保持一致。

请在VRRP备份组中的所有设备上，通过执行display vrrp verbose命令，查看“Version”显示的当前VRRP备份组的VRRP版本，如果不一致，请执行vrrp version命令将版本修改一致。

如果版本均为VRRPv2版本，则继续通过执行display vrrp verbose命令，查看“Adver Timer”显示的当前配置的VRRP通告报文时间间隔，如果不一致，请执行vrrp vrid timer advertise命令将时间间隔修改一致。

## 19.2 VRRP备份组网，当Master设备上行链路状态down后，备份组为什么没有切换？

VRRP自身并不具备链路状态检测能力，请在VRRP备份组的Master设备上，通过执行display vrrp verbose命令，查看“VRRP Track Information”是否关联了Track项。如果没有配置，请通过vrrp vrid track命令在Master设备上配置VRRP与Track联动、Track与NQA或BFD联动，实现VRRP Master设备监视上行链路状态功能。

## 19.3 配置VRRP与Track联动监视Master设备上行链路状态，Track状态变为Negative时，为什么VRRP备份组中的主备未进行切换？

如果希望Track状态变为Negative时VRRP备份组进行主备切换，需要配置当被监视Track项的状态变为Negative时，Master设备的优先级降低足够的数值，使得当前的Master设备的优先级不是组内优先级最高的设备，其它设备才会抢占成为新的Master设备。

请在Master设备上执行display vrrp verbose命令，查看“VRRP Track Information”中是否配置“Pri Reduced”，如果是配置“Weight Reduced”，则表示降低虚拟转发器的权重，请使用**vrrp vrid track**命令修改为降低Master设备的优先级。

如果配置了“Pri Reduced”，请继续查看Master设备的“Running Pri”（当前优先级）是否低于VRRP备份组中的其它设备，否则请使用**vrrp vrid track**命令加大“Pri Reduced”数值，使得Master设备降低优先级后低于其它设备的优先级。

## 19.4 支持拨码开关的IE系列交换机，配置RRPP相关功能并保存配置，设备重启后RRPP配置丢失是什么原因？

部分IE系列工业交换机支持两种RRPP配置方式：手工配置和通过拨码开关配置。

当拨码4置“ON”后，设备将进行如下配置：

(1)   创建RRPP域，设备的域ID为domain 1。

(2)   指定主控制VLAN为VLAN 4092，子控制VLAN为VLAN 4093。

(3)   配置保护VLAN映射到MSTP instance 0上。

(4)   配置RRPP环和RRPP节点。设备为传输节点，并指定主端口和副端口。其中接入RRPP环的端口中，端口号小的作为主端口，端口号大的作为副端口。

(5)   激活RRPP域。

设备启动时，先轮询检测拨码开关的状态，当拨码开关处于“ON”时，设备自动完成以上配置。如果配置文件中的配置与拨码开关配置冲突，例如配置文件创建RRPP domain 2，并指定其控制VLAN为VLAN 4093，与RRPP domain 1子控制VLAN相同，则配置恢复失败。

为避免出现以上问题，如果需要同时使用拨码开关和手工配置，请确保手工配置内容与拨码开关配置不存在冲突。

# 20 网络管理与监控

## 20.1 PoE端口无法正常供电的常见原因有哪些？

如果出现设备开启PoE接口供电功能后PoE接口频繁up/down、PoE交换机只能给部分的PD正常供电或者PoE交换机端口模式指示灯不亮等现象，可能是由于以下原因引起的。

(1)   未开启接口PoE功能

确认设备电源、电缆正确连接的情况下，首先可以使用display poe interface命令查看设备PoE接口的供电状态。如果显示信息的PoE Status字段为Disabled，则接口PoE功能是关闭状态，可以在PoE接口视图下执行命令poe enable来开启PoE功能。

(2)   未开启非标准PD检测功能

受电PD设备分为标准PD和非标准PD，标准PD是指符合IEEE 802.3af和IEEE 802.3at标准的PD设备。如果是非标准PD供电，只有在开启非标准PD检测功能后，PSE才对非标准PD供电。设备支持以下两种非标准PD检测功能的配置，使用任意一种配置方式均可开启该功能。

·   方法一：在系统视图下执行命令poe legacy enable pse pse-id开启PSE的非标准PD检测功能

·   方法二：在PoE接口视图下执行命令poe legacy enable开启PoE接口的非标准PD检测功能

(3)   未升级PSE固件

确认不是由上述1、2的原因导致PoE端口无法正常供电，该问题很可能是由于未升级PSE固件引起。

在进行在线升级操作前，请先联系H3C技术支持获取最新PSE固件版本文件。升级有以下两种模式：

·   refresh模式：在系统视图执行命令poe update full filename [ pse pse-id ]（由于该模式升级过程简单快速，一般情况下推荐使用该模式来升级PSE固件。）

·   full模式：在系统视图执行命令poe update full filename [ pse pse-id ]

需要注意的是，如果PSE固件的升级过程因设备重启而中断，重启完成后用full方式升级失败时，请将设备断电重启后再用full方式升级即可升级成功。

具体操作步骤，以采用refresh模式在线升级PSE 4固件为示例：

<Sysname> system-view

[Sysname] poe update refresh POE-168.bin pse 4

## 20.2  为什么NMS对设备的远程管理和操作出现异常？

NMS和Agent能够建立SNMP连接后，很可能是由以下原因导致。

如果出现无法读取设备信息，NMS对设备的远程管理和操作异常、NMS无法收到设备发出的告警信息等异常情况。请按照以下顺序对配置进行排查：

1、 确认版本一致。

请确认在NMS和Agent配置的SNMP版本是否一致。对此可以执行命令display snmp-agent sys-info查看设备配置的SNMP版本，如果NMS和Agent配置的SNMP版本不一致，可以在系统视图下执行命令执行命令**snmp-agent** **sys-info version**配置SNMP版本。

需要注意的是，设备运行于非FIPS模式时，支持SNMPv1、SNMPv2c和SNMPv3三种版本；设备运行于FIPS模式时，只支持SNMPv3版本。

2、 确认团体名一致。

确保NMS和Agent使用的SNMP版本相同时，如果NMS仍不能读取到Agent的信息，可以执行命令**display** **snmp-agent** **community**查看SNMPv1或SNMPv2c的团体名，如果NMS和Agent配置的团体名不一致，可以使用以下两种方式配置团体：

·   方法一：基于名称配置SNMPv1/v2c团体

使用该方法直接执行命令创建团体有以下两种方式：

¡   VACM方式：在系统视图下执行命令snmp-agent community { read | write } [ simple | cipher ] community-name [ mib-view view-name ] [ acl { ipv4-acl-number | name ipv4-acl-name } | acl ipv6 { ipv6-acl-number | name ipv6-acl-name } ] *

¡   RBAC方式：在系统视图下执行命令snmp-agent community [ simple | cipher ] community-name user-role role-name [ acl { ipv4-acl-number | name ipv4-acl-name } | acl ipv6 { ipv6-acl-number | name ipv6-acl-name } ] *

·   方法二：基于用户配置SNMPv1/v2c团体

首先在系统视图下执行命令snmp-agent group { v1 | v2c } group-name [ notify-view view-name | read-view view-name | write-view view-name ] * [ acl { ipv4-acl-number | name ipv4-acl-name } | acl ipv6 { ipv6-acl-number | name ipv6-acl-name } ] *创建SNMPv1/v2c组；

其次再执行命令snmp-agent usm-user { v1 | v2c } user-name group-name [ acl { ipv4-acl-number | name ipv4-acl-name } | acl ipv6 { ipv6-acl-number | name ipv6-acl-name } ] *创建SNMPv1/v2c用户。

以上两种团体配置方式，效果相同。如果采用第二种方式配置团体，创建的SNMPv1/v2c用户名相当于SNMPv1/v2c的团体名。如需删除SNMP团体，可以在系统视图下执行命令undo snmp-agent community。

## 20.3 设置本地时钟作为参考时钟会影响NTP客户端和服务器进行时间同步吗？

会影响。

实际网络中，通常将从权威时钟（如原子时钟）获得时间同步，并将其作为主时间服务器同步网络中其他设备的时钟，该情况不需要设置本地时钟作为参考时钟。

只有在某些特殊网络中，例如无法与外界通信的孤立网络，网络中的设备无法与权威时钟进行时间同步。此时，可以从该网络中选择一台时钟较为准确的设备，在系统视图下执行命令ntp-service refclock-master [ ip-address ] [ stratum ]，指定该设备与本地时钟进行时间同步，即采用本地时钟作为参考时钟，使得设备的时钟处于同步状态。

请谨慎使用本配置，以免导致网络中设备的时间错误，影响NTP客户端和服务器进行时间同步。

## 20.4 配置客户端/服务器模式下的NTP，服务器端的时钟层数是否要小于客户端的时钟层数？

是。当NTP服务器端的时钟层数大于或等于客户端的时钟层数时，NTP客户端将不会其进行时间同步。

## 20.5 NTP客户端/服务器时间不同步，时间相差若干小时的原因是什么？

客户端的夏令时、时区和服务器上的配置不一致。因为NTP客户端从服务器同步的是UTC时间，如果服务器上配置了夏令时、时区，请在客户端上执行clock timezone和clock summer-time命令，让客户端的夏令时、时区和服务器上的配置保持一致。

## 20.6 什么情况下需要配置PTP接口角色才能实现PTP时间同步，有哪些配置限制？

一般建议使用BMC协议自动协商PTP接口角色。

配置PTP接口角色适用于但不限于以下几种情况：

·   网络中只有少量PTP接口

·   BMC协议自动协商PTP接口角色失败，造成网络中有多个接口状态为Master。

网络中是否有多个接口状态为Master，可以执行命令display ptp interface brief查看接口的角色。请确保网络中只有一个接口状态为Master用于对外发布时间信息，如果有多个接口状态为Master，可以在接口视图下执行命令ptp force-state命令强制修改PTP接口的角色。

配置限制

·   如果修改了PTP接口角色，则整个PTP域内的所有PTP接口均需手工执行命令ptp force-state命令配置角色，否则会导致PTP域内未配置角色的接口PTP功能不生效，域内时钟不能同步。

·   必须先配置PTP协议标准、时钟节点类型和PTP域后，才允许配置该命令。

·   一台设备上最多只允许配置一个从接口。

## 20.7 为什么无法通过云平台（绿洲云）远程管理设备？

请确认设备是否支持通过云平台远程管理设备，对于支持通过云平台远程管理的设备，请参考“网络管理和监控配置指导”中的“云平台连接”。

对于支持通过云平台远程管理的设备，若无法通过云平台远程管理设备，请排查是否配置了如下配置：

·   配置云平台服务器域名。可以通过display current-configuration命令查看设备是否配置了云平台服务器域名，如果未配置，则需要通过cloud-management server domain oasis.h3c.com命令配置设备连接的云平台服务器域名。

·   配置正确的域名解析，以便将云平台服务器的域名解析为正确的IP地址。

·   在云平台服务器上添加待管理设备的序列号。可以通过display device manuinfo命令查看设备序列号，将序列号添加到云平台上。

## 20.8 设备产生的日志信息过多，如何处理？

信息中心是设备的信息枢纽，它接收各模块生成的日志信息，能够按模块和等级将收到的日志信息输出到控制台、监视终端、日志主机等方向，为管理员监控设备运行情况和诊断网络故障提供了有力的支持。

但是如果设备在短时间内产生大量的日志信息，会造成INFO进程CPU使用率比较高，主要通过以下几种方法解决：

(1)   排查这些日志信息产生的原因：根据设备记录的日志信息内容，排查这些信息产生的原因，从根本上解决问题。例如：设备有大量端口的UP/DOWN信息输出，那么就要排查对应的端口是否有问题，端口UP/DOWN的问题解决后，日志信息就不再产生。

(2)   修改日志信息的输出级别：如果无法阻止日志信息的产生，可以修改日志信息的输出级别，使这些无用的信息不再向指定方向输出。例如：只允许VLAN模块信息级别为notification及以上的日志信息（即等级0～5的日志信息）输出到控制台，修改方法为：info-center source vlan console level notification。

(3)   禁止指定应用模块日志信息的输出：如果某个模块的日志信息管理员不需要关注，可以禁止该模块的日志信息输出到指定的方向。例如：禁止Portal模块信息输出到监视终端，修改方法为：info-center source portal monitor deny。

# 21 VXLAN

## 21.1 为什么设备上无法配置VXLAN特性相关的命令？

若设备上无法配置VXLAN特性相关的命令，请排查是否存在如下问题：

(1)   确认设备是否支持VXLAN特性。

(2)   部分设备上只有特定的工作模式下支持VXLAN特性，不同设备上工作模式的配置方式可能不同：

¡   部分设备上：通过display switch-mode status命令查看设备是否处于VXLAN工作模式；若未处于VXLAN工作模式，则通过switch-mode命令将设备配置为VXLAN工作模式，并保存配置重启设备。

¡   部分设备上：通过display system-working-mode命令查看设备的工作模式；若设备目前处于不支持VXLAN的工作模式，则需要通过system-working-mode命令将设备切换为支持VXLAN的工作模式，修改工作模式需要保存配置重启设备。

(3)   部分设备上不同的角色需要使用不同的硬件资源模式，如果硬件资源模式与配置不匹配，可能导致配置无法执行。通过display hardware-resource vxlan命令可以查看设备VXLAN的硬件资源模式；通过hardware-resource vxlan命令可以配置VXLAN的硬件资源模式，修改VXLAN的硬件资源模式需要保存配置并重启设备。

产品对VXLAN特性的具体要求请参见“VXLAN配置指导”中的“VXLAN”。