# RBAC

## 产生背景

随着网络技术的高速发展，大型数据中心技术尤其是网络虚拟化技术的广泛应用对网络设备的管理提出了更高的要求。传统的基于用户优先级的权限控制技术已经无法适应日新月异的网络应用。为了应对新的技术挑战，引入了RBAC（Role-Based Access Control，基于角色的访问控制）权限管理模型——一种已经广泛应用于各种管理系统的权限管理模型。在RBAC中，操作权限与角色之间建立关联，再通过在角色与用户之间建立关联来完成对用户的授权，大大提高了权限控制的灵活性。

## 1.2 技术优点

在传统的基于用户优先级的权限控制模型中，用户的权限和用户级别静态绑定，用户具有的权限完全由系统预定义确定。在RBAC模型中，系统管理员可以通过配置将特定功能的操作权限赋予自定义的用户角色，从而灵活地控制用户权限。另外，RBAC增加了对系统资源访问权限的控制，可以限定用户对VLAN、接口、VPN实例、安全域和地区标识的访问。

另外，由于权限与用户的分离，RBAC具有以下特点：

·      管理员不需要针对用户去逐一指定权限，只需要预先定义具有相应权限的角色，再将角色赋予用户即可。因此RBAC更能适应用户的变化，提高了用户权限分配的灵活性。

·      由于角色与用户的关系常常会发生变化，但是角色和权限的关系相对稳定，因此利用这种稳定的关联可减小用户授权管理的复杂性，降低管理成本。

# 2 RBAC技术实现

## 2.1 概念介绍

### 2.1.1 用户账户

Comware系统支持通过创建用户账户来对用户进行身份验证和授权。用户账户分为设备管理用户和网络接入用户两类。设备管理类用户，用于登录设备，对设备进行配置和监控；网络接入类用户，用于通过设备接入网络，访问网络资源。RBAC功能用来控制设备管理类用户对设备的操作权限。

### 2.1.2 动作

是指用户对系统的一次操作。例如通过命令行或者SNMP协议对系统进行功能配置，通过基于Web的用户界面查看设备运行状态等。

### 2.1.3 命令属性

根据操作性质的不同可分为读、写和执行三种属性。

·      读属性：表示仅对系统配置信息和运行状态信息进行查看；

·      写属性：表示对系统进行配置；

·      执行属性：表示可以执行特定的程序（如ping命令调用ping程序完成探测功能），并对系统运行状态不产生影响。

### 2.1.4 特性

与一个功能相关的所有命令的集合，例如OSPF特性包含了所有OSPF的配置、显示及调试命令。

### 2.1.5 特性组

一个或者多个特性的集合。其主要目的是为了方便管理员对用户权限进行配置。

### 2.1.6 用户角色

用户角色是一组权限规则和多种类型的资源控制策略的集合。权限规则定义了允许用户执行的动作和拒绝执行的动作；资源控制策略分别定义了允许用户可以操作的接口、VLAN、VPN实例、安全域和地区标识。

### 2.1.7 权限规则

权限规则具体定义了用户角色的执行权限，一个用户角色可以拥有多条权限规则。权限规则可以分为以下几类：

·      基于命令特征字符串的权限规则：此类规则由命令关键字与通配符组成，用于控制与之匹配的命令是否有权限被执行。如果设置为允许执行（permit），并且用户被授权用户角色包含这个规则时，此用户有权限执行此命令。如果是设置为拒绝时（deny），用户没有权限执行此命令。

·      基于特性的权限规则：此规则可以控制特性包含的命令是否有权限被执行。特性中每条命令均具有动作属性，所以在定义基于特性的权限规则时，可以精细地控制所包含的读命令或者写命令能否被执行。

·      基于特性组的权限规则：此规则和基于特性的权限规则类似，区别是一个特性组中包含了一个或者多个特性。

·      基于Web菜单的权限规则：此规则可以控制指定的Web菜单是否允许被操作。Web菜单对应的用户界面中的各种控件具有动作属性，所以在定义此类规则时，可以精细地控制Web菜单中所包含的读控件或者写控件能否被操作。

·      基于XML元素的权限规则：此规则可以控制指定的XML元素的XPath是否允许被操作。与Web菜单相似，XML元素的XPath对应的用户界面中的各种控件具有动作属性。定义此类规则时，可以精细地控制读控件或者写控件能否被操作。

·      基于SNMP OID的权限规则：此规则可以控制指定的OID是否允许被SNMP访问。

一个用户角色中可以定义多条规则，各规则以创建时指定的编号为唯一标识，被授权该角色的用户的权限是这些规则中定义的操作的并集。若这些规则定义的权限内容有冲突，则规则编号大的有效。其中，OID规则遵循最长匹配，相同长度的匹配规则中编号大的有效。

### 2.1.8 资源控制策略

资源控制策略规定了用户对系统资源的操作权限。在用户角色中可定义四种类型的资源控制策略：接口策略、VLAN策略、VPN策略、安全域策略和地区标识策略，它们分别定义了用户允许操作的接口、VLAN、VPN实例、安全域或者地区标识。

## 2.2 运行机制

### 2.2.1 用户与角色的关联

角色与用户的关联是通过为用户赋予角色建立的。将有效的用户角色成功授权给用户后，登录设备的用户才能以各角色所具有的权限来配置、管理或者监控设备。根据用户登录设备时采用的不同认证方式，可以将为用户授权角色分为AAA方式和非AAA方式。

·      AAA方式：用户登录设备后所拥有的用户角色由AAA功能进行授权。

¡ 如果对用户采用本地授权方式，则授权的用户角色是在本地用户中设置的。

¡ 如果对用户采用远程服务器授权，则可以在远程服务器上灵活地配置授权方案，可以实现单个用户或者一组用户的角色关联。

·      非AAA方式：用户登录后所拥有的用户角色是用户线下配置的用户角色。

### 2.2.2 基于角色的用户权限控制

当系统获得用户的授权角色后，将根据角色名称读取系统配置并依据角色中的权限规则和资源控制策略为其生成两个表，分别是权限规则表和资源控制策略表。

·      权限规则表项的组成元素包括：规则编号、权限（允许/禁止）、规则类型（命令/Web/XML/SNMP）、动作属性（读/写/执行）、规则内容。

·      资源控制策略表项的组成元素包括：资源类型（VLAN/接口/VPN/安全域/地区标识）、权限（允许/禁止）、资源标识（VLAN编号/接口名称/VPN名称/安全域名称/地区标识）。

每个登录到系统中的用户都具有上述两个权限控制表，用户只能执行权限控制表内规定的操作。

当用户通过命令行或者其他配置工具对系统进行操作时，系统将查找该用户的权限控制表来判断用户的当前操作是否被允许。资源控制策略表项需要与权限规则表项相配合才能生效。下面以执行某条配置命令为例，详细描述具体处理过程：

(1)    用户输入配置命令，例如：vlan 1。

(2)    系统读取到用户的输入后，查找该用户对应的权限规则表：

a.  按照规则编号从大到小查找。

b.  判断规则类型，如果不是命令规则，则跳过该表项；否则，继续进行下一步处理。

c.  将字符串“vlan 1”与规则中的正则表达式内容进行匹配，如果不匹配，继续查找下一条规则；否则，得到该表项对应的权限（允许/禁止）。

(3)    如果步骤（2）中的匹配结果为允许执行，则查找资源控制策略表。因为vlan 1命令操作的对象是VLAN资源，所以查找该用户VLAN类型的资源控制表项，如果VLAN 1在允许的列表中，则允许用户执行vlan 1；否则，返回禁止执行，并提示用户“Permission denied.”。

(4)    如果步骤（2）中的匹配结果为禁止执行，则提示用户“Permission denied.”。

# 3 Comware实现的技术特色

## 3.1 丰富的系统预定义角色

Comware提供了丰富的系统预定义角色，用户可以直接使用这些预定义角色来对设备进行权限控制。系统预定义的用户角色名和对应的权限如[表3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RBAC_Tech-6W100/?CHID=949058#_Ref19178364)所示。这些用户角色缺省均具有操作所有系统资源的权限，但具有不同的系统功能操作权限。

表3-1 系统预定义的用户角色名和对应的权限

| 用户角色名          | 权限                                                         |
| ------------------- | ------------------------------------------------------------ |
| network-admin       | 可操作系统所有功能和资源（除安全日志文件管理相关命令之外）   |
| network-operator    | ·      可执行系统所有功能和资源的相关显示命令（除display history-command all、display security-logfile summary等命令，具体请通过display role命令查看）  ·      可执行切换MDC（Multitenant Device Context，多租户设备环境）视图的命令  ·      如果用户采用本地认证方式登录系统并被授予该角色，则可以修改自己的密码  ·      可执行进入XML视图的命令  ·      可允许用户操作所有读类型的Web菜单选项  ·      可允许用户操作所有读类型的XML元素  ·      可允许用户操作所有读类型的OID |
| mdc-admin           | 可操作该MDC所有功能和资源（除安全日志文件管理相关命令之外），但不包括操作仅缺省MDC支持，非缺省MDC不支持的功能的权限 |
| mdc-operator        | ·      可执行该MDC所有功能和资源的相关显示命令（除display history-command all、display  security-logfile summary等命令，具体请通过display role命令查看），但不包括仅缺省MDC支持，非缺省MDC不支持的功能的相关**display**命令的执行权限  ·      如果用户采用本地认证方式登录系统并被授予该角色，则可以修改自己的密码  ·      可执行进入XML视图的命令  ·      可允许用户操作所有读类型的Web菜单选项  ·      可允许用户操作所有读类型的XML元素  ·      可允许用户操作所有读类型的OID |
| level-n (n = 0～15) | ·      level-0：可执行命令ping、tracert、ssh2、telne**t**和super，且管理员可以为其配置权限  ·      level-1：具有level-0用户角色的权限，并且可执行系统所有功能和资源的相关显示命令（除display history-command all之外），以及管理员可以为其配置权限  ·      level-2～level-8和level-10～level-14：无缺省权限，需要管理员为其配置权限  ·      level-9：可操作系统中绝大多数的功能和所有的资源，且管理员可以为其配置权限，但不能操作display history-command all命令、RBAC的命令（Debug命令除外）、MDC、文件管理、设备管理以及本地用户特性。对于本地用户，若用户登录系统并被授予该角色，可以修改自己的密码  ·      level-15：具有与network-admin角色相同的权限（不支持MDC、Context的设备）  ·      level-15：在缺省MDC中，具有与network-admin角色相同的权限；在非缺省MDC中，具有与mdc-admin角色相同的权限（支持MDC的设备）  ·      level-15：在缺省Context中，具有与network-admin角色相同的权限；在非缺省Context中，具有与context-admin角色相同的权限（支持Context的设备） |
| security-audit      | 安全日志管理员，仅具有安全日志文件的读、写、执行权限，具体如下：  ·      可执行安全日志文件管理相关的命令  ·      可执行安全日志文件操作相关的命令，例如more显示安全日志文件内容；dir、mkdir操作安全日志文件目录等  以上权限，仅安全日志管理员角色独有，其它任何角色均不具备  该角色不能被授权给从当前用户线登录系统的用户 |
| guest-manager       | 来宾用户管理员，只能查看和配置与来宾有关的Web页面，没有控制命令行的权限 |
| context-admin       | 可操作该Context所有功能和资源（除安全日志文件管理相关命令之外） |
| context-operator    | ·      可执行该Context所有功能和资源的相关display命令（除display history-command all、display security-logfile summary等命令，具体请通过display role命令查看）  ·      如果用户采用本地认证方式登录系统并被授予该角色，则可以修改自己的密码  ·      可执行进入XML视图的命令  ·      可允许用户操作所有读类型的Web菜单选项  ·      可允许用户操作所有读类型的XML元素  ·      可允许用户操作所有读类型的OID |
| system-admin        | 系统管理员，具有部分Web页面菜单的读、写、执行权限，具体如下：  ·      对概览菜单具有读、写、执行权限  ·      对监控菜单下的系统日志菜单具有读、写、执行权限  ·      对系统菜单具体权限如下：  ¡ 对管理员和角色菜单仅有读权限  ¡ 对其它子菜单菜单具有读、写、执行权限  系统管理员角色目前仅实现Web页面功能，命令行只有ping和tracert的权限，具体权限请通过display role命令查看  该角色不能被授权给从当前用户线登录系统的用户 |
| security-admin      | 安全管理员，具有大部分Web页面菜单的读、写、执行权限，具体如下：  ·      对策略、对象和网络菜单具有读、写、执行权限  ·      对监控菜单具体权限如下：  ¡ 对系统日志、操作日志子菜单无读、写、执行权限  ¡ 对于其他子菜单拥有读、写、执行权限  安全管理员角色目前仅实现Web页面功能，命令行只有执行ping和tracert命令的权限，具体权限请通过display role命令查看  该角色不能被授权给当前用户线登录系统的用户 |
| audit-admin         | 审计管理员，仅具有对监控菜单下的操作日志子菜单具有读、写、执行权限  审计管理员角色目前仅实现Web页面功能，命令行只有执行ping和tracert命令的权限，具体权限请通过display role命令查看  该角色不能授权给当前用户线登录系统的用户 |

 

## 3.2 灵活的用户权限控制

### 3.2.1 支持不同粒度的权限规则配置

#### 1. 基于命令特征的规则

当需要限制用户对符合某些特征的命令的权限时，可以配置基于命令特征的规则。规则由允许/禁止（permit/deny）关键字及命令匹配字符串（command-string）定义是否允许执行一条命令或者与指定命令关键字相匹配的一组命令。

#### 2. 基于特性的规则

当需要限制用户对某个功能的整体操作权限时，可以配置基于特性的规则。规则由允许/禁止（permit/deny）关键字、特性名称（feature-name）以及该特性中命令的类型（读/写/执行）定义是否允许执行一个特性中包含的指定类型的命令。当不指定特性名称时，将理解为指定所有特性。

#### 3. 基于特性组的规则

当需要限制用户对某些功能的整体操作权限时，可以配置基于特性组的规则。规则由允许/禁止（permit/deny）关键字、特性组名称（feature-group-name）以及该特性组中命令的类型（读/写/执行）定义是否允许执行一个特性组中的特性包含的指定类型的命令。

#### 4. 基于Web菜单的权限规则

当需要限制用户对Web界面上某菜单项的权限时，可以配置基于Web菜单的规则。规则由允许/禁止（permit/deny）关键字，Web菜单选项的ID路径以及该菜单中控件的操作类型（读/写/执行）定义是否允许操作一个Web菜单中包含的指定类型的控件。如果不指定Web菜单项，则对所有Web菜单项生效。

#### 5. 基于XML路径的权限规则

当需要限制用户对XML路径的权限时，可以配置基于XML路径的规则。规则由允许/禁止（permit/deny）关键字，XML路径描述符以及控件的操作类型（读/写/执行）定义是否允许操作一个XML路径中包含的指定类型的控件。如果不指定XML路径，则对所有XML路径生效。

#### 6. 基于OID的权限规则

当需要限制用户通过SNMP对OID的权限时，可以配置基于OID的规则。规则由允许/禁止（permit/deny）关键字、OID（oid-string）以及对该OID的操作类型（读/写/执行）定义是否允许执行一个或所有指定类型的OID。

### 3.2.2 对文件系统访问的控制

通过配置基于文件系统特性的规则，可以控制用户在命令行界面对文件系统的访问权限。例如：定义规则rule rule-num permit read feature filesystem，可以允许用户在命令行界面仅拥有读文件系统的操作权限。

需要关注的是：

·      访问文件系统的命令，受基于文件系统特性规则以及具体命令规则的双重控制。

·      对于FTP用户，规则中对文件系统读、写属性的控制将影响FTP用户的上传和下载权限。

·      对于需要将输出信息重定向到文件中保存的命令，只有在用户角色被授权了文件系统写权限后才允许执行。

### 3.2.3 多种方式为用户授权角色

#### 1. 为远程AAA认证用户授权角色

对于通过远程AAA认证登录设备的用户，由AAA服务器的配置决定为其授权的用户角色。如果用户没有被授权任何用户角色，将无法成功登录设备。为此，系统提供了一个缺省用户角色授权功能。使能该功能后，用户在AAA服务器没有为其授权角色的情况下，将具有一个缺省的用户角色。该缺省用户角色可以通过配置来指定。

RADIUS服务器上的授权角色配置与服务器的具体情况有关，请参考服务器的配置指导进行；HWTACACS服务器上的授权角色配置必须满足格式：roles="name1 name2 namen"，其中name1、name2、namen为要授权下发给用户的用户角色，可为多个，并使用空格分隔。

#### 2. 为本地AAA认证用户授权角色

对于通过本地AAA认证登录设备的用户，由本地用户配置决定为其授权的用户角色。由于本地用户缺省拥有一个用户角色，如果要赋予本地用户新的用户角色，请确认是否需要保留这个缺省的用户角色，若不需要，请删除。但需要注意的是，一个本地用户至少必须拥有一个用户角色。

#### 3. 为非AAA认证用户授权角色

对于不使用AAA认证登录设备的非SSH用户，由用户线的配置决定为其授权的用户角色。通过publickey或password-publickey方式认证登录的SSH用户，由同名的设备管理类本地用户配置决定为其授权的用户角色。

### 3.2.4 用户角色的切换

Comware系统提供了super命令用于切换当前登录用户的角色，从而满足用户临时提升/降低自身权限的需求。

切换用户角色是指在不退出当前登录、不断开当前连接的前提下修改用户的用户角色，改变用户所拥有的命令行权限。切换后的用户角色只对当前登录生效，用户重新登录后，又会恢复到原有角色。

·      为了防止对设备的误操作，通常情况下建议管理员使用较低权限的用户角色登录设备、查看设备运行参数，当需要对设备进行维护时，再临时切换到较高权限的用户角色。

·      当管理员需要暂时离开设备或者将设备暂时交给其它人代为管理时，为了安全起见，可以临时切换到较低权限的用户角色，来限制其他人员的操作。

# 4 典型组网应用

## 4.1 RBAC典型组网应用

图4-1 RBAC典型应用组网图

![img](https://resource.h3c.com/cn/202001/02/20200102_4667596_image001_1256807_30005_0.png)

 

某企业内部为隔离部门间流量将不同VLAN划分给不同的部门使用，并允许各部门网络管理员在Core设备上部署QoS流量控制策略。另外，为了防止部门网络管理员操作Core设备的其它的配置，可以采用RBAC对各部门网络管理的权限进行控制。

具体的权限管理需求如下：

·      部门网络管理员角色为depart-admin，该角色具有QoS流量控制策略相关功能的配置权限。

·      部门A资源控制角色为departA-resource，该角色具有操作VLAN 100~VLAN 199的操作权限；

·      部门B资源控制角色为departB-resource，该角色具有操作VLAN 200~VLAN 299的操作权限。

在AAA服务器上为部门A管理员授权角色depart-admin和departA-resource，为部门B管理员授权角色depart-admin和departB-resouce角色。这样，即可通过RBAC实现权限的精细控制。

# 概述

## 1.1 产生背景

设备采用RBAC（Role-Based Access Control，基于角色的访问控制）机制对用户的访问权限进行控制。用户的角色与相应的系统功能以及系统资源使用权限相对应，不同角色的用户登录设备后，只能使用指定角色的命令。但在有些情况下，用户希望在不退出当前登录、不断开当前连接的前提下，修改自身的用户角色，即需要切换用户角色。例如：

·   通常情况下管理员使用较低权限的用户角色登录设备、查看设备运行参数，当需要对设备进行维护时，要求临时切换到较高权限的用户角色。

·   管理员需要暂时离开设备或者将设备暂时交给其它人代为管理时，为了安全起见，可以临时切换到较低权限的用户角色，来限制其他人员的操作。

用户角色切换认证，就是设备对用户角色切换行为进行的认证。目前，设备支持两种基本的用户角色切换认证方案：

·   本地密码认证

当用户执行**super**命令希望将自身当前的用户角色切换到其它用户角色时，设备使用一个本地预先设置的密码（称为用户角色切换密码，通过**super password**命令设置）对该用户角色切换行为进行认证。如下例所示，用户只需要输入正确的切换密码xxx即可成功切换自身的用户角色为network-admin。

<Device> super network-admin

Password: xxx

·   远程AAA认证

当用户执行**super**命令希望将自身当前的用户角色切换到其它用户角色时，设备提示用户输入用户名和密码，并使用远程AAA服务器（RADIUS服务器或HWTACACS服务器）对该用户角色切换行为进行认证。如下例所示，用户需要输入用户名test@bbb和正确的切换密码yyy才能成功切换自身的用户角色为network-admin。

<Device> super network-admin

Username: test@bbb

Password: yyy

User privilege role is network-admin, and only those commands that authorized to the role can be used.

## 1.2 认证方案特点

本地认证方式具有配置简单、易用的优点，但在也存在以下问题：

·   无法对用户角色切换的操作者进行身份区分，任何拥有本地切换密码的用户都可以使用相同的切换密码来修改自身的用户角色。

·   本地密码的存储信息量以及管理策略上均有一定的局限性，且容易产生安全隐患。

相比较而言，远程AAA认证需要部署相应的AAA服务器来配合，用户信息的管理与维护上比本地密码认证方式稍显复杂，但它具有如下优点：

·   可提升用户角色切换的安全性

用户进行角色切换操作时使用相应的用户名和密码在远程AAA（RADIUS或HWTACACS）服务器上进行身份认证，不同的用户可拥有不同的切换权限。

·   可提高设备管理的灵活性

通过与本地认证组合使用，增强了认证的可靠性，提高了设备管理的灵活性。

# 2 技术实现

## 2.1 用户角色切换认证方式

目前，设备支持四种用户角色切换认证方式，具体含义如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/YHJS_White_Paper-6W100/?CHID=949179#_Ref477455008)所述。其中，后两种认证方式为前两种基本认证方式的灵活组合，提高了用户角色切换认证的可靠性。

表1 用户角色的切换认证方式

| 认证方式     | 含义                                  | 说明                                                         |
| ------------ | ------------------------------------- | ------------------------------------------------------------ |
| local        | 仅本地密码认证                        | 设备上预先通过**super password**命令设置一个目标用户角色对应的切换密码，然后当用户切换该目标角色时，由设备验证用户输入的用户角色切换密码是否准确 |
| scheme       | 仅通过HWTACACS或RADIUS进行远程AAA认证 | HWTACACS/RADIUS服务器上预先配置对应的用户名和密码信息，然后当用户切换目标角色时，由设备将用户输入的角色切换使用的用户名和密码发送给HWTACACS/RADIUS服务器进行远程验证 |
| local scheme | 先本地密码认证，后远程AAA认证         | 先由设备进行本地密码认证，若设备上未设置本地用户角色切换密码，则：  ·   使用Console、TTY、VTY用户线登录的用户转为远程AAA认证  ·   使用AUX用户线登录的用户直接可以成功切换用户角色 |
| scheme local | 先远程AAA认证，后本地密码认证         | 先进行远程AAA认证，远程HWTACACS/RADIUS服务器无响应或设备上的AAA远程认证配置无效时，转由设备进行本地密码认证 |

 

## 2.2 用户角色切换认证机制

### 2.2.1 本地用户角色切换认证

如果设备上设置了对应的本地用户角色切换密码，则系统提示用户输入该密码，并把用户输入的密码和对应的本地用户角色切换密码进行比较，如果一致则提示用户认证成功；如果认证尝试次数达到3次则提示用户认证失败，否则提示用户重新输入本地用户角色切换密码。

如下例所示，任何登录到设备上的用户，要切换到network-admin角色时，只需要正确输入该设备上预先设置的本地用户角色切换密码就可以。

<Device> super network-admin

Password: <——此处输入本地用户角色切换密码

User privilege role is network-admin, and only those commands that authorized to the role can be used.

### 2.2.2 通过RADIUS进行远程用户角色切换认证

当使用RADIUS方案进行用户角色切换认证时，系统统一使用“$enabn$”形式的用户名进行用户角色切换认证，其中n为用户希望切换到的用户角色level-n中的n，RADIUS服务器上也必须存在该形式用户名的用户。因此，使用RADIUS方案对用户进行角色切换时，用户输入的用户名称在认证过程中无实际意义。

·   当用户要切换到level-n的用户角色时，要求RADIUS服务器上存在用户名为“$enabn$”的用户。例如，用户希望切换到用户角色level-3，输入任意用户名，系统忽略用户输入的用户名，使用用户名“$enab3$”进行用户角色切换认证。

·   当用户要切换到非level-n的用户角色时，要求RADIUS服务器上存在用户名为“$enab0$”的用户，且该用户配置了取值为allowed-roles=”role”的自定义属性（其中role为要切换的目的用户角色名称），具体配置要求请以服务器侧的要求为准。

RADIUS服务器接收到认证请求报文后，对角色切换用户名和密码进行认证。如果认证成功，RADIUS服务器返回认证成功消息；如果认证失败，则返回认证失败消息。如果认证尝试次数达到3次，则提示用户认证失败，否则提示用户重新输入角色切换用户名和密码。

### 2.2.3 通过HWTACACS进行远程用户角色切换认证

当使用HWTACACS方案进行用户角色切换认证时，若未配置用户角色切换认证时使用用户登录的用户名认证，则系统使用用户输入的用户角色切换用户名进行角色切换认证，HWTACACS服务器上也必须存在相应的用户。用户输入的用户名和密码需要与服务器上的配置保持一致。

·   当用户要切换到level-n的用户角色时，要求HWTACACS服务器上存在能提供切换到level-n角色的用户。在HWTACACS服务器上，支持切换到用户角色level-n的用户也能够支持切换到level-0到level-n之间任意的用户角色。

·   当用户要切换到非level-n的用户角色时，要求HWTACACS服务器上存在至少能提供切换到level-0角色的用户，且该用户配置了取值为allowed-roles=”role”的自定义属性（其中role为要切换的目的用户角色名称，多个角色可用空格间隔）。

HWTACACS服务器接收到认证请求报文后，对角色切换用户名和密码进行认证。如果认证成功，HWTACACS服务器返回认证成功消息；如果认证失败，则返回认证失败消息。如果认证尝试次数达到3次则提示用户认证失败，否则提示用户重新输入角色切换用户名和密码。

## 2.3 不同登录认证方式下的用户角色切换认证用户名和密码要求

用户角色切换认证过程中，是否需要提供用户名和密码以及所使用的用户名和密码与用户登录设备的认证方式有密切的关联，会因为不同的用户登录方式而存在一些差异，具体情况如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/YHJS_White_Paper-6W100/?CHID=949179#_Ref15462329)所示。

表2 不同登录认证方式下的用户角色切换认证用户名和密码

| 登录认证方式    | 用户角色切换   认证方式                                      | 用户角色切换时的   用户名和密码                    |
| --------------- | ------------------------------------------------------------ | -------------------------------------------------- |
| none/  password | local                                                        | ·   用户名：不需要  ·   密码：本地用户角色切换密码 |
| scheme          | ·   用户名：用户角色切换用户名  ·   密码：服务器上的用户角色切换密码 |                                                    |
| scheme          | local                                                        | ·   用户名：不需要  ·   密码：本地用户角色切换密码 |
| scheme          | ·   用户名：用户角色切换用户名或用户登录用户名  ·   密码：服务器上的用户角色切换密码  缺省情况下，系统提示用户输入用户角色切换用户名。可以通过配置允许系统自动获取用户登录用户名作为用户角色切换用户名，而不需要用户输入 |                                                    |

 

![说明](https://resource.h3c.com/cn/201911/20/20191120_4598613_x_Img_x_png_0_1244596_30005_0.png)

建议用户角色切换的认证方法（由authentication super命令设置）与登录域下配置的用户登录授权方法（由**authorization login**命令设置）保持一致，否则在与当前登录用户相同的ISP域中执行用户角色切换认证时,可能无法切换到非level-*n*用户角色。

 

# 3 典型组网应用

典型的组网应用如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/YHJS_White_Paper-6W100/?CHID=949179#_Ref15407174)所示。在该组网中，用户登录设备时需要进行RADIUS认证，为了避免对设备的误操作，登录后仅被授予具有较低权限的用户角色level-0。后续，当该用户需要以管理员的身份进行设备维护时，可以直接切换到高权限的用户角色network-admin。考虑到用户角色切换认证的安全性和灵活性，首先对该用户的角色切换行为使用RADIUS认证，若AAA配置无效或者RADIUS服务器没有响应则转为本地密码认证。

图1 RADIUS用户角色切换典型组网图

 ![img](https://resource.h3c.com/cn/201911/20/20191120_4598614_x_Img_x_png_1_1244596_30005_0.png)

 

假设用户使用Telnet客户端远程登录Device，则按照如下提示输入正确的用户名及登录密码后，即可成功登录，且只能访问指定权限的命令。

<Device> telnet 192.168.1.70

Trying 192.168.1.70 ...

Press CTRL+K to abort

Connected to 192.168.1.70 ...

login: test@bbb

Password: <——此处需输入登录密码

******************************************************************************

\* Copyright (c) 2004-2019 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<Device>?

User view commands:

 ping     Ping function

 quit     Exit from current command view

 ssh2     Establish a secure shell client connection

 super    Switch to a user role

 system-view Enter the System View

 telnet    Establish a telnet connection

 tracert   Tracert function

 

<Device>

如果该用户需要提升自己的管理权限，则在当前的用户线下执行切换到用户角色network-admin的命令，并按照提示输入正确的RADIUS用户角色切换认证密码即可。

<Device> super network-admin

Username: test@bbb

Password: <——此处需输入RADIUS用户角色切换认证密码

User privilege role is network-admin, and only those commands that authorized to the role can be used.

若RADIUS服务器无响应，再按照系统提示输入本地用户角色切换认证密码，若认证成功即可将当前用户角色切换到network-admin。

<Device> super network-admin

Username: test@bbb

Password: <——此处需输入RADIUS用户角色切换认证密码

Invalid configuration or no response from the authentication server.

Change authentication mode to local.

Password: <——此处需输入本地用户角色切换认证密码

User privilege role is network-admin, and only those commands that authorized to the role can be used.

# 配置用户角色

## 1.1 简介

本案例介绍用户角色的配置方法。

## 1.2 组网需求

Telnet用户主机与Switch相连，需要实现Switch对Telnet用户进行本地认证并授权用户角色。Telnet用户的登录用户名为user1@bbb，认证通过后被授权的用户角色为role1。

role1具有如下用户权限：

·   允许用户执行所有特性中读类型的命令；

·   允许用户执行创建VLAN以及进入VLAN视图后的相关命令，并只具有操作VLAN 10～VLAN 20的权限。

图1-1 Telnet用户本地认证/授权配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774686_x_Img_x_png_0_1816241_30005_0.png)

 

## 1.3 配置注意事项

·   一个ISP域被配置为缺省的ISP域后将不能够被删除，必须首先使用命令undo domain default enable将其修改为非缺省ISP域，然后才可以被删除。

·   一个用户角色中允许创建多条规则，各规则以创建时指定的编号为唯一标识，被授权该角色的用户可以执行的命令为这些规则定义的可执行命令的并集。若这些规则定义的权限内容有冲突，则规则编号大的有效。例如，规则1允许执行命令A，规则2允许执行命令B，规则3禁止执行命令A，则最终规则2和规则3生效，即禁止执行命令A，允许执行命令B。

## 1.4 配置步骤

\# 设置交换机系统名称为Switch。

<H3C> system-view

[H3C] sysname Switch

\# 配置VLAN接口2的IP地址，Telnet用户将通过该地址连接Switch。

[Switch] interface vlan-interface 2

[Switch-Vlan-interface2] ip address 192.168.1.70 255.255.255.0

[Switch-Vlan-interface2] quit

\# 开启Switch的Telnet服务器功能。

[Switch] telnet server enable

\# 配置Telnet用户登录采用AAA认证方式。

[Switch] line vty 0 63

[Switch-line-vty0-63] authentication-mode scheme

[Switch-line-vty0-63] quit

\# 配置ISP域bbb的AAA方法为本地认证和本地授权。

[Switch] domain bbb

[Switch-isp-bbb] authentication login local

[Switch-isp-bbb] authorization login local

[Switch-isp-bbb] quit

\# 创建用户角色role1。

[Switch] role name role1

\# 配置用户角色规则1，允许用户执行所有特性中读类型的命令。

[Switch-role-role1] rule 1 permit read feature

\# 配置用户角色规则2，允许用户执行创建VLAN以及进入VLAN视图后的相关命令。

[Switch-role-role1] rule 2 permit command system-view ; vlan *

\# 进入VLAN策略视图，允许用户具有操作VLAN 10～VLAN 20的权限。

[Switch-role-role1] vlan policy deny

[Switch-role-role1-vlanpolicy] permit vlan 10 to 20

[Switch-role-role1-vlanpolicy] quit

[Switch-role-role1] quit

\# 创建设备管理类本地用户user1。

[Switch] local-user user1 class manage

\# 配置用户的密码是明文的123456TESTplat&!。

[Switch-luser-manage-user1] password simple 123456TESTplat&!

\# 指定用户的服务类型是Telnet。

[Switch-luser-manage-user1] service-type telnet

\# 指定用户user1的授权角色为role1。

[Switch-luser-manage-user1] authorization-attribute user-role role1

\# 为保证用户仅使用授权的用户角色role1，删除用户user1具有的缺省用户角色network-operator。

[Switch-luser-manage-user1] undo authorization-attribute user-role network-operator

[Switch-luser-manage-user1] quit

## 1.5 验证配置

用户向设备发起Telnet连接，在Telnet客户端按照提示输入用户名user1@bbb及正确的密码后，成功登录设备。

C:\Documents and Settings\user> telnet 192.168.1.50

login: user1@bbb

Password:

******************************************************************************

\* Copyright (c) 2004-2019 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<Switch>

登录用户并被授予用户角色role1，具有相应的命令行执行权限。可通过如下步骤验证用户的权限：

·   可操作VLAN 10～VLAN 20。（以创建VLAN 10为例）

<Switch> system-view

[Switch] vlan 10

[Switch-vlan10] quit

·   不能操作其它VLAN。（以创建VLAN 30为例）

[Switch] vlan 30

Permission denied.

·   可执行所有特性中读类型的命令。（以**display clock**为例）

[Switch] display clock

09:31:56.258 UTC Sat 01/01/2017

[Switch] quit

·   不能执行特性中写类型和执行类型的命令。

<Switch> debugging role all

Permission denied.

<Switch> ping 192.168.1.58

Permission denied.

## 1.6 配置文件

\#

 sysname Switch

\#

 telnet server enable

\#

vlan 2

\#

interface Vlan-interface2

 ip address 192.168.1.50 255.255.255.0

\#

line vty 0 63

 authentication-mode scheme

\#

domain bbb

 authentication login local

 authorization login local

\#

role name role1

 rule 1 permit read feature

 rule 2 permit command system-view ; vlan *

 vlan policy deny

 permit vlan 10 to 20

\#

local-user user1 class manage

 password hash $h$6$3nDcf1enrif2H0W6$QUWsXcld9MjeCMWGlkU6qleuV3WqFFEE8i2TTSoFRL3

ENZ2ExkhXZZrRmOl3pblfbje6fim7vV+u5FbCif+SjA==

 service-type telnet

 authorization-attribute user-role role1

 undo authorization-attribute user-role network-operator

\#

## 1.7 相关资料

·   产品配套“基础配置指导”中的“RBAC”。

·   产品配套“基础命令参考”中的“RBAC”。



 

# 2 切换用户角色

## 2.1 简介

本案例介绍切换用户角色的配置方法。

## 2.2 组网需求

为了加强用户登录的安全性，采用本地AAA认证对登录设备的Telnet用户进行认证。登录设备的Telnet用户能够进行用户角色的切换，即在不下线的情况下，临时改变自身对系统的操作权限。当前Telnet用户被授权为用户角色role1，用户角色role1具有如下权限：

·   允许执行系统预定义特性组L3相关的所有命令。

·   允许执行所有以display开头的命令。

·   允许执行所有以super开头的命令。

·   具有所有接口、VLAN和VPN实例资源的操作权限。

现要求，Telnet用户能够被切换到用户角色role2和network-operator，其中用户角色role2具有如下权限：

·   允许执行系统预定义特性组L2相关的所有命令。

·   具有所有接口、VLAN和VPN实例资源的操作权限。

图2-1 切换用户角色权限配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774687_x_Img_x_png_1_1816241_30005_0.png)

 

## 2.3 配置注意事项

·   一个ISP域被配置为缺省的ISP域后将不能够被删除，必须首先使用命令undo domain default enable将其修改为非缺省ISP域，然后才可以被删除。

·   一个用户角色中允许创建多条规则，各规则以创建时指定的编号为唯一标识，被授权该角色的用户可以执行的命令为这些规则定义的可执行命令的并集。若这些规则定义的权限内容有冲突，则规则编号大的有效。例如，规则1允许执行命令A，规则2允许执行命令B，规则3禁止执行命令A，则最终规则2和规则3生效，即禁止执行命令A，允许执行命令B。

·   切换后的用户角色只对当前登录生效，用户重新登录后，又会恢复到原有用户角色。

## 2.4 配置步骤

\# 设置交换机系统名称为Switch。

<H3C> system-view

[H3C] sysname Switch

\# 创建VLAN 2并将Switch连接Telnet user的端口划分到VLAN 2中。

[Switch] vlan 2

[Switch-vlan2] quit

[Switch] interface GigabitEthernet1/0/10

[Switch-GigabitEthernet1/0/10] port access vlan 2

[Switch-GigabitEthernet1/0/10] quit

\# 创建VLAN接口2并配置IP地址。

[Switch] interface Vlan-interface 2

[Switch-Vlan-interface2] ip address 192.168.1.50 24

\# 开启设备的Telnet服务器功能。

[Switch] telnet server enable

\# 在编号为0～63的VTY用户线下，配置Telnet用户登录采用AAA认证方式。

[Switch] line vty 0 63

[Switch-line-vty0-63] authentication-mode scheme

[Switch-line-vty0-63] quit

\# 配置ISP域bbb的AAA方法为本地认证和本地授权。

[Switch] domain bbb

[Switch-isp-bbb] authentication login local

[Switch-isp-bbb] authorization login local

[Switch-isp-bbb] quit

\# 创建用户角色role1，进入用户角色视图。

[Switch] role name role1

\# 配置用户角色规则1，允许用户执行预定义特性组L3相关的所有命令。

[Switch-role-role1] rule 1 permit execute read write feature-group L3

\# 配置用户角色规则2，允许用户执行所有以display开头的命令。

[Switch-role-role1] rule 2 permit command display *

\# 配置用户角色规则3，允许用户执行所有以super开头的命令。

[Switch-role-role1] rule 3 permit command super *

[Switch-role-role1] quit

\# 创建用户角色role2，进入用户角色视图。

[Switch] role name role2

\# 配置用户角色规则1，允许用户执行预定义特性组L2相关的所有命令。

[Switch-role-role2] rule 1 permit execute read write feature-group L2

[Switch-role-role2] quit

\# 创建设备管理类本地用户telnetuser。

[Switch] local-user telnetuser class manage

\# 配置用户的密码是明文的aabbcc。

[Switch-luser-manage-telnetuser] password simple aabbcc

\# 指定用户的服务类型是Telnet。

[Switch-luser-manage-telnetuser] service-type telnet

\# 指定用户telnetuser的授权角色为role1。

[Switch-luser-manage-telnetuser] authorization-attribute user-role role1

\# 为保证用户仅使用授权的用户角色role1，删除用户telnetuser具有的缺省用户角色network-operator。

[Switch-luser-manage-telnetuser] undo authorization-attribute user-role network-operator

[Switch-luser-manage-telnetuser] quit

\# 配置Telnet用户切换用户角色时采用**local**认证方式（系统缺省值为**local**）。

[Switch] super authentication-mode local

\# 配置Telnet用户将用户角色切换到role2时使用的密码为明文密码123456TESTplat&!。

[Switch] super password role role2 simple 123456TESTplat&!

\# 配置Telnet用户将用户角色切换到network-operator时使用的密码为明文密码987654TESTplat&!。

[Switch] super password role network-operator simple 987654TESTplat&!

## 2.5 验证配置

(1)   查看用户角色和特性组信息

通过display role命令查看用户角色role1、role2和network-operator的信息。

\# 显示用户角色role1的信息。

<Switch> display role name role1

Role: role1

 Description:

 VLAN policy: permit (default)

 Interface policy: permit (default)

 VPN instance policy: permit (default)

 \-------------------------------------------------------------------

 Rule  Perm  Type Scope     Entity

 \-------------------------------------------------------------------

 1    permit RWX  feature-group L3

 2    permit    command    display *

 3    permit    command    super *

 R:Read W:Write X:Execute

\# 显示用户角色role2的信息。

<Switch> display role name role2

Role: role2

 Description:

 VLAN policy: permit (default)

 Interface policy: permit (default)

 VPN instance policy: permit (default)

 \-------------------------------------------------------------------

 Rule  Perm  Type Scope     Entity

 \-------------------------------------------------------------------

 1    permit RWX  feature-group L2

 R:Read W:Write X:Execute

\# 显示用户角色network-operator的信息。

<Switch> display role name network-operator

Role: network-operator

 Description: Predefined network operator role has access to all read commands

on the device

 VLAN policy: permit (default)

 Interface policy: permit (default)

 VPN instance policy: permit (default)

 \-------------------------------------------------------------------

 Rule  Perm  Type Scope     Entity

 \-------------------------------------------------------------------

 sys-1  permit    command    display *

 sys-2  permit    command    xml

 sys-3  permit    command    system-view ; probe ; display *

 sys-4  deny     command    display history-command all

 sys-5  deny     command    display exception *

 sys-6  deny     command    display cpu-usage configuration

​                   *

 sys-7  deny     command    display kernel exception *

 sys-8  deny     command    display kernel deadloop *

 sys-9  deny     command    display kernel starvation *

 sys-10 deny     command    display kernel reboot *

 sys-13 permit    command    system-view ; local-user *

 sys-16 permit R--  web-menu   -

 sys-17 permit RW-  web-menu   m_device/m_maintenance/m_changep

​                   assword

 sys-18 permit R--  xml-element  -

 sys-19 deny     command    display security-logfile summary

 sys-20 deny     command    display security-logfile buffer

 sys-21 deny     command    system-view ; info-center securi

​                   ty-logfile directory *

 sys-22 deny     command    security-logfile save

 sys-23 deny     command    system-view ; local-user-import

​                   *

 sys-24 deny     command    system-view ; local-user-export

​                   *

 sys-25 permit R--  oid      1

 R:Read W:Write X:Execute

 通过display role feature-group命令查看特性组L2和L3中包括的特性信息，此处不详细介绍。

(2)   用户登录设备

用户向设备发起Telnet连接，在Telnet客户端按照提示输入用户名telnetuser@bbb及正确的密码后，成功登录设备。

C:\Documents and Settings\user> telnet 192.168.1.50

login: telnetuser@bbb

Password:

******************************************************************************

\* Copyright (c) 2004-2019 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<Switch>

(3)   验证切换用户角色前的用户权限

Telnet用户成功登录设备后，可通过如下步骤验证用户的权限：

¡   可执行特性组L3中特性相关的所有命令。（以创建VPN实例vpn1为例）

<Switch> system-view

[Switch] ip vpn-instance vpn1

¡   可执行所有以display开头的命令。（以显示系统当前日期和时间为例）

<Switch> display clock

13:53:24.357 test Sat 01/01/2018

Time Zone : test add 05:00:00

Summer Time : PDT 06:00:00 08/01 06:00:00 09/01 01:00:00

(4)   验证切换用户角色

Telnet用户成功登录设备后，可通过如下步骤验证用户的权限：

a.   在用户视图下使用super开头的命令。（以切换到用户角色role2并输入相应的切换密码为例）

<Switch> super role2

Password:

User privilege role is role2, and only those commands that authorized to the role can be used.

<Switch>

b.   切换到用户角色role2后，可执行特性组L2中特性相关的所有命令。（以创建VLAN 10为例）

<Switch> system-view

[Switch] vlan 10

[Switch-vlan10] quit

[Switch] quit

c.   切换到用户角色role2后，不能执行非特性组L2中特性相关的命令。（以切换到用户角色network-operator为例）

<Switch> super network-operator

Permission denied.

d.   切换到用户角色role2后，不能执行以display开头的命令。（以显示系统当前日期和时间为例）

<Switch> display clock

Permission denied.

e.   Telnet用户重新登录设备后，才能执行所有以super开头的命令。（以切换到用户角色network-operator并输入相应的切换密码为例）

C:\Documents and Settings\user> telnet 192.168.1.50

login: telnetuser@bbb

Password:

******************************************************************************

\* Copyright (c) 2004-2019 New H3C Technologies Co., Ltd. All rights reserved.*

\* Without the owner's prior written consent,                 *

\* no decompiling or reverse-engineering shall be allowed.          *

******************************************************************************

 

<Switch>

<Switch> super network-operator

Password:

User privilege role is network-operator, and only those commands that authorized

 to the role can be used.

<Switch>

通过显示信息可以确认配置生效。

## 2.6 配置文件

\#

 sysname Switch

\#

 telnet server enable

\#

vlan 2

\#

interface Vlan-interface2

 ip address 192.168.1.50 255.255.255.0

\#

interface GigabitEthernet1/0/10

port access vlan 2

\#

line vty 0 63

 authentication-mode scheme

 user-role network-operator

\#

 super password role role2 hash $h$6$D0kjHFktkktzgR5g$e673xFnIcKytCj6EDAw+pvwgh3

/ung3WNWHnrUTnXT862B+s7PaLfKTdil8ef71RBOvuJvPAZHjiLjrMPyWHQw==

 super password role network-operator hash $h$6$3s5KMmscn9hJ6gPx$IcxbNjUc8u4yxwR

m87b/Jki8BoPAxw/s5bEcPQjQj/cbbXwTVcnQGL91WOd7ssO2rX/wKzfyzAO5VhBTn9Q4zQ==

\#

domain bbb

 authentication login local

 authorization login local

\#

role name role1

 rule 1 permit read write execute feature-group L3

 rule 2 permit command display *

 rule 3 permit command super *

\#

role name role2

 rule 1 permit read write execute feature-group L2

\#

 local-user telnetuser class manage

 password hash $h$6$kZw1rKFsAY4lhgUz$+teVLy8gmKN4Mr00VWgXQTB8ai94gKHlrys5OkytGf4

kT+nz5X1ZGASjc282CYAR6A1upH2jbmRoTcfDzZ9Gmw==

 service-type telnet

 authorization-attribute user-role role1

\#