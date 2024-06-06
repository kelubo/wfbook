# PoE基本组网配置

## 1.1 简介

本案例介绍设备通过PoE接口为PD设备供电的配置方法。

## 1.2 配置注意事项

如果没有开启PoE接口的远程供电功能，系统不会给PoE接口下挂的PD供电，也不会给PD预留功率。

如果该PoE接口的加入不会导致PSE功率过载，则允许该PoE接口为下挂的PD供电；如果该PoE接口的加入会导致PSE功率过载，则由该PoE接口是否开启PoE接口优先级策略决定。

不能通过重复执行apply poe-profile或apply poe-profile interface命令修改PoE Profile。如需修改PoE Profile，请先取消PoE profile在PoE接口的应用，修改PoE Profile后，再将PoE profile应用到PoE接口。

## 1.3 配置步骤

#### 1. 开启单个PoE接口远程供电功能

\# 进入系统视图。

<Device> system-view

\# 开启GigabitEthernet 1/0/1接口的PoE接口远程供电功能。

[Device] interface GigabitEthernet 1/0/1

[Device-GigabitEthernet1/0/1] poe enable 

[Device-GigabitEthernet1/0/1] quit

\#保存配置

[Device] save force

#### 2. 批量开启GigabitEthernet1/0/1到GigabitEthernet1/0/6接口的远程供电功能。

\# 创建名称为abc的PoE profile，指定索引为1。

<Device> system-view

[Device] poe-profile abc 1

\# 开启PoE接口远程供电功能

[Device-poe-profile-abc-1] poe enable

[Device-poe-profile-abc-1] return

\# 将索引为1的PoE profile应用到PoE接口GigabitEthernet1/0/1至GigabitEthernet1/0/6。

<Device> system-view

[Device] apply poe-profile abc index 1 interface gigabitethernet 1/0/1 to gigabitethernet 1/0/6

\#保存配置

[Device] save force

## 1.4 验证配置

配置完成后，下挂的PD设备被供电，能够正常工作。

## 1.5 配置文件

·   开启单个PoE接口远程供电功能

\#

interface GigabitEthernet 1/0/1

poe enable 

\#

·   批量开启PoE接口远程供电功能

\#

poe-profile abc 1

 poe enable

 apply poe-profile index 1

save force

\#