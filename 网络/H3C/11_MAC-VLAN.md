## 产生背景

VLAN最常用的划分方式是基于端口划分，该方式按照设备端口来划分VLAN成员，将指定端口加入到指定VLAN中之后，该端口就可以转发该VLAN的报文。该方式配置简单，适用于终端设备物理位置比较固定的组网环境。随着移动办公和无线接入的普及，终端设备不再通过固定端口接入设备，它可能本次使用端口A接入网络，下次使用端口B接入网络。如果端口A和端口B的VLAN配置不同，则终端设备第二次接入后就会被划分到另一VLAN，导致无法使用原VLAN内的资源；如果端口A和端口B的VLAN配置相同，当端口B被分配给别的终端设备时，又会引入安全问题。如何在这样灵活多变的网络环境中部署VLAN呢？MAC VLAN应运而生。

MAC VLAN是基于MAC划分VLAN，它根据报文的源MAC地址来划分VLAN，决定为报文添加某个VLAN的标签。该功能通常和安全技术（比如802.1X）联合使用，以实现终端的安全、灵活接入。

## 1.2 技术优点

MAC VLAN具有以下优点：

l   MAC VLAN能够实现精确的接入控制，它能精确定义某个终端和VLAN的绑定关系，从而实现将指定终端的报文在指定VLAN中转发。

l   MAC VLAN能够实现灵活的接入控制，同一终端通过不同端口接入设备时，设备会给终端分配相同的VLAN，不需要重新配置VLAN；而不同终端通过同一端口接入设备时，设备可以给不同终端分配不同的VLAN。

# 2 技术实现

## 2.1 运行机制

设备是如何根据MAC地址来划分VLAN的呢？当端口收到一个untagged报文后，以报文的源MAC地址为匹配关键字，通过查找MAC VLAN表项来获知该终端绑定的VLAN，从而实现将指定终端的报文在指定VLAN中转发。

MAC VLAN表项有两种生成方式：静态配置和动态配置。

### 2.1.1 静态MAC VLAN

#### 1. 手动配置静态MAC VLAN

手动配置静态MAC VLAN常用于VLAN中用户相对较少的网络环境。在该方式下，用户需要手动配置MAC VLAN表项，开启基于MAC地址的VLAN功能，并将端口加入MAC VLAN。其原理为：

·   当端口收到的报文为Untagged报文时，根据报文的源MAC地址匹配MAC VLAN表项。

a.   首先进行模糊匹配，即查询MAC VLAN表中掩码不是全F的表项。将源MAC地址和掩码相与运算后与MAC VLAN表项中的MAC地址匹配。如果完全相同，则模糊匹配成功，为报文添加表项中对应的VLAN Tag并转发该报文。

b.   如果模糊匹配失败，则进行精确匹配，即查询表中掩码为全F的表项。如果报文中的源MAC地址与某MAC VLAN表项中的MAC地址完全相同，则精确匹配成功，为报文添加表项中对应的VLAN Tag并转发该报文。

c.   如果没有找到匹配的MAC VLAN表项，则继续按照其他原则（基于IP子网的VLAN、基于协议的VLAN、基于端口的VLAN）确定报文所属的VLAN，为报文添加对应的VLAN Tag并转发该报文。

·   当端口收到的报文为Tagged报文时，如果报文的VLAN ID在该端口允许通过的VLAN ID列表里，则转发该报文；否则丢弃该报文。

该方式实现简单，只涉及接入设备，但该方式下需要在终端可能接入的端口手工配置允许终端的MAC VLAN通过，配置量大。

#### 2. 动态触发端口加入静态MAC VLAN

手动配置静态MAC VLAN时，如果不能确定从哪些端口收到指定VLAN的报文，就不能把相应端口加入到MAC VLAN。采用动态触发方式可以将端口自动加入静态MAC VLAN。在该方式下，配置MAC VLAN表项后，需要在端口上开启基于MAC的VLAN功能和MAC VLAN的动态触发功能，不需要手动把端口加入MAC VLAN。

配置动态触发端口加入静态MAC VLAN后，端口在收到报文时，首先判断报文是否携带VLAN Tag，若带VLAN Tag，则直接获取报文源MAC地址；若不带VLAN Tag，则先进行报文VLAN选择（按照基于MAC的VLAN->基于IP子网的VLAN->基于协议的VLAN->基于端口的VLAN的优先次序为该Untagged报文添加对应的VLAN Tag，并获取该VLAN Tag），再获取报文源MAC地址，然后根据报文的源MAC地址和VLAN查询静态MAC VLAN表项：

·   如果报文源MAC地址与MAC VLAN表项中的MAC地址精确匹配，再检查报文的VLAN ID是否与对应表项中的VLAN ID一致。若一致，通过该报文动态触发端口加入相应VLAN，同时转发该报文；否则丢弃该报文。

·   如果报文源MAC地址与MAC VLAN表项的MAC地址不精确匹配，当报文VLAN ID为PVID（Port VLAN ID，端口缺省VLAN），判断端口是否允许报文在PVID内转发。若允许，则在PVID中转发该报文，否则丢弃该报文。当报文VLAN ID不为PVID，判断是否报文VLAN ID为Primary VLAN ID且PVID为对应的Secondary VLAN ID。若是，则转发该报文；否则丢弃该报文。处理流程如[2.1.1 2. 图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/MAC_VLAN_Tech_White_Paper-6W100/?CHID=949086#_Ref453663757)所示：

图1 动态触发端口加入静态MAC VLAN的处理流程

![img](https://resource.h3c.com/cn/201908/20/20190820_4449570_image001_1220688_30005_0.png)

 

### 2.1.2 动态MAC VLAN

动态MAC VLAN是由接入认证过程来动态决定接入用户报文所属的VLAN。该方式下，需要在设备上同时配置MAC VLAN和基于MAC的接入认证方式（比如MAC地址认证或者基于MAC的802.1X认证）。如果用户发起认证请求，认证服务器会对认证用户名和密码进行验证，如果通过，则会下发VLAN信息。此时设备就可根据认证请求报文的源MAC地址和下发的VLAN信息生成MAC VLAN表项，并自动将MAC VLAN添加到端口允许通过的untagged VLAN列表中。用户下线后，设备又自动删除MAC VLAN表项，并将MAC VLAN从端口允许通过的VLAN列表中删除。

该方式的优点是灵活、安全：

l   它能够自动识别MAC地址、能够自动创建MAC VLAN表项、能够自动允许MAC VLAN通过接入端口。因此该方式应用于大型网络时能够大大简化配置，使用灵活。

l   只有用户接入认证成功，才能通过指定的VLAN接入网络，因此提高了网络的安全性。

## 2.2 应用限制

l   MAC VLAN只对Hybrid端口配置有效，所以在开启MAC VLAN前，请将端口的链路类型配置为Hybrid。

l   MAC VLAN有静态配置和动态配置两种方式，但是同一MAC地址只能绑定一个VLAN。因此，如果已进行了静态配置，而动态下发的绑定关系与静态配置不一致，则动态下发失败，用户不能通过认证；反之，如果动态下发已生效，而静态配置与动态下发的不一致，则静态配置失败。

l   采用动态方式配置MAC VLAN时需要基于MAC地址的AAA远程认证的配合，网络中需要部署AAA认证服务器，服务器必须能够下发VLAN。

·   MAC VLAN的配置会影响聚合成员端口的选中状态。所以，建议不要在聚合成员端口上配置MAC VLAN功能。

·   Super VLAN不能作为MAC VLAN表项中的VLAN。

# 3 典型组网应用

## 3.1 静态配置MAC VLAN

某公司为了实现通信安全以及隔离广播报文，给不同的部门指定了不同的VLAN。销售部的办公区在1002房间，部门所有资产属于VLAN 2；技术支持部门的办公区在1003房间，部门所有资产属于VLAN 3。因为人员的流动性很大，公司在Meeting room里提供了临时办公场所，职员可以通过无线接入公司网络，但要求接入后只能划分到自己部门所在的VLAN，比如Host A到Meeting room办公后必须归属于VLAN 2，Host D到Meeting room办公后必须归属于VLAN 3。

基于以上需求，在1002房间和1003房间因为人员和工位比较稳定，可以采用基于端口的方式划分VLAN。但是在Meeting room里，因为人员流动性比较大，人员接入网络的端口不确定，所以可以通过MAC VLAN，将MAC地址和员工所在部门的VLAN绑定。从而不管员工从哪个接口接入，不需要修改配置，就能被划分到部门所在的VLAN。

图2 静态配置MAC VLAN组网图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449571_image002_1220688_30005_0.png)

 

## 3.2 动态配置MAC VLAN

用户通过无线接入点AP 1和AP n接入网络，在AP 1和AP n上同时使能MAC VLAN和基于MAC的802.1X方式认证，就能很简便地实现：

l   用户接入前需先通过认证，从而防止非法用户占用网络资源；

·   用户通过任意AP的任意端口接入网络，仍能属于原来的VLAN。

图3 动态配置MAC VLAN组网图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449572_image003_1220688_30005_0.png)

 

 