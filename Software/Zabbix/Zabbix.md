# Zabbix

[TOC]

## 概述

Zabbix 是由 Alexei Vladishev 创建，目前是由 Zabbix SIA 在持续开发和提供支持。

Zabbix 是一种企业级的分布式开源监控解决方案。是一款能够监控众多网络参数和服务器的健康度和完整性的软件。

Zabbix 支持轮询和被动捕获。

Zabbix 是免费的。Zabbix 是根据 GPL 通用公共许可证的第二版编写和分发的。

商业支持由 Zabbix 公司提供。

## 架构

### Server

是 Zabbix agent 向其报告可用性、系统完整性信息和统计信息的核心组件。是存储所有配置信息、统计信息和操作信息的核心存储库。

### 数据库

所有配置信息以及 Zabbix 收集到的数据都被存储在数据库中。

### Web 界面

为了从任何地方和任何平台轻松访问 Zabbix ，提供了基于 web 的界面。该界面是 Zabbix server 的一部分，通常（但不一定）和 Zabbix server 运行在同一台物理机器上。

### Proxy

可以替 Zabbix server 收集性能和可用性数据。Zabbix proxy 是 Zabbix 环境部署的可选部分；然而，对于单个 Zabbix server 负载的分担是非常有益的。

### Agent

被部署在被监控目标上，用于主动监控本地资源和应用程序，并将收集的数据发送给 Zabbix server。

### 数据流

1. 为了创建一个采集数据的监控项，必须先创建主机。
2. 必须有一个监控项来创建触发器。
3. 必须有一个触发器来创建一个动作，这几个点构成了一个完整的数据流。

## 定义

**主机（host）**

想要监控的联网设备，有IP/DNS。

**主机组（host group)**

主机的逻辑组；可能包含主机和模板。一个主机组里的主机和模板之间并没有任何直接的关联。通常在给不同用户组的主机分配权限时候使用主机组。

**监控项（item）**

想要接收的主机的特定数据，一个度量/指标数据。

**值预处理（value preprocessing）**

在存入数据库之前，转化/预处理接收到的指标数据。

**触发器（trigger）**

一个被用于定义问题阈值和“评估”监控项接收到的数据的逻辑表达式

当接收到的数据高于阈值时，触发器从“OK”变成“Problem”状态。当接收到的数据低于阈值时，触发器保留/返回“OK”的状态。

**事件（event）**

一次发生的需要注意的事情，例如触发器状态改变、发现/监控代理自动注册

**事件标签（event tag）**

提前设置的事件标记可以被用于事件关联，权限细化设置等。

**事件关联（event correlation）**

自动灵活的、精确的关联问题和解决方案

例如，可以定义触发器A告警的异常可以由触发器B解决，触发器B可能采用完全不同的数据采集方式。

**异常（problems）**

一个处在“异常”状态的触发器

**异常更新（problem update）**

Zabbix提供的问题管理选项，例如添加评论、确认异常、改变问题级别或者手动关闭等。

**动作（action）**

预先定义的应对事件的操作。一个动作由操作(例如发出通知)和条件(什么时间进行操作)组成

**升级（escalation）**

一个在动作内执行操作的自定义方式; 发送通知/执行远程命令的顺序安排。

**媒介（media）**

发送告警通知的方式；传送途径

**通知（notification）**

关于事件的信息，将通过选设定的媒介途径发送给用户。

**远程命令（remote command）**

一个预定义好的，满足特定条件的情况下，可以在被监控主机上自动执行的命令。

**模版（template)**

一组可以被应用到一个或多个主机上的实体（监控项，触发器，图形，聚合图形，应用，LLD，Web场景）的集合

模版的应用使得主机上的监控任务部署快捷方便；也可以使监控任务的批量修改更加简单。模版是直接关联到每台单独的主机上。

**应用（application)**

一组监控项组成的逻辑分组

**Web场景（web scenario）**

检查网站可浏览性的一个或多个HTTP请求

**前端（frontend)**

Zabbix提供的web界面

**Zabbix API**

Zabbix API允许用户使用JSON RPC协议来创建、更新和获取Zabbix对象（如主机、监控项、图形和其他）信息或者执行任何其他的自定义的任务

**Zabbix server**

Zabbix监控的核心程序，主要功能是与Zabbix proxies和Agents进行交互、触发器计算、发送告警通知；并将数据集中保存等

**Zabbix agent**

部署在监控对象上的，能够主动监控本地资源和应用的程序

**Zabbix proxy**

一个帮助Zabbix Server收集数据，分担Zabbix Server的负载的程序

**加密（encryption）**

支持Zabbix组建之间的加密通讯(server, proxy, agent, zabbix_sender 和 zabbix_get 程序) 使用TLS（Transport Layer Security ）协议。


## 进程

### Server

是整个 Zabbix 软件的核心程序。

负责执行数据的主动轮询和被动获取，计算触发器条件，向用户发送通知。它是 Zabbix Agent 和 Proxy  报告系统可用性和完整性数据的核心组件。Server 自身可以通过简单服务远程检查网络服务。

是所有配置、统计和操作数据的中央存储中心，也是Zabbix监控系统的告警中心。在监控的系统中出现任何异常，将被发出通知给管理员。

基本的 Zabbix Server 的功能分解成为三个不同的组件：Zabbix server、Web前端和数据库。

Zabbix 的所有配置信息都存储在 Server  和Web前端进行交互的数据库中。例如，当通过Web前端（或者API）新增一个监控项时，它会被添加到数据库的监控项表里。然后，Zabbix  server 以每分钟一次的频率查询监控项表中的有效项，接着将它存储在 Zabbix server 中的缓存里。这就是为什么 Zabbix  前端所做的任何更改需要花费两分钟左右才能显示在最新的数据段的原因。

#### 服务进程

##### 通过二进制包安装的组件

Zabbix server 进程以守护进程（Deamon）运行。

```bash
service zabbix-server start | stop | restart | status
/etc/init.d/zabbix-server start | stop | restart | status
```

##### 手动启动

找到 Zabbix Server 二进制文件的路径并且执行：

```bash
zabbix_server [Option]

-c --config <file>              # 配置文件路径（默认的是/usr/local/etc/zabbix_server.conf）
-R --runtime-control <option>   # 执行管理功能
-h --help                       # 帮助
-V --version                    # 显示版本号
```

运行时控制不支持 OpenBSD 和 NetBSD 系统。

##### 运行时控制

| 选项                              | 描述                                             | 目标                                                         |
| --------------------------------- | ------------------------------------------------ | ------------------------------------------------------------ |
| config_cache_reload               | 重新加载配置缓存。如果当前正在加载缓存，则忽略。 |                                                              |
| housekeeper_execute               | 启动管家程序。忽略当前正在进行中的管家程序。     |                                                              |
| log_level_increase[=<**target**>] | 增加日志级别，如果未指定目标，将影响所有进程。   | **pid** - 进程标识符 (1 to 65535)   **process type** - 指定进程的所有类型 (例如，poller)    **process type,N** - 进程类型和编号 (例如，poller,3) |
| log_level_decrease[=<**target**>] | 降低日志级别，如果未指定目标，则会影响所有进程。 |                                                              |

单一 Zabbix 进程的日志级别改变后，进程的 PIDs 的值也会改变，允许的范围为1~65535。在具有大 PIDs <process type,N> 目标选项可更改单个进程的日志级别。

```bash
# 使用 config_cache_reload 选项重新加载 server 的配置缓存
zabbix_server -c /usr/local/etc/zabbix_server.conf -R config_cache_reload

# 使用 housekeeper_execute 选项来触发管家服务执行
zabbix_server -c /usr/local/etc/zabbix_server.conf -R housekeeper_execute

# 使用 log_level_increase 选项来改变日志级别
# 增加所有进程的日志级别：
zabbix_server -c /usr/local/etc/zabbix_server.conf -R log_level_increase

# 增加第二个 Poller 进程的日志级别：
zabbix_server -c /usr/local/etc/zabbix_server.conf -R log_level_increase=poller,2

# 增加 PID 为 1234 进程的日志级别：
zabbix_server -c /usr/local/etc/zabbix_server.conf -R log_level_increase=1234

# 降低 http poller 进程的日志级别：
zabbix_server -c /usr/local/etc/zabbix_server.conf -R log_level_decrease="http poller"
```

##### 进程用户

Zabbix server 允许使用非 root 用户运行。它将以任何非 root 用户的身份运行。因此，使用非 root 用户运行 server 是没有任何问题的.

如果试图以“root”身份运行它，它将会切换到一个已经“写死”的“zabbix”用户。按此相应地修改 Zabbix server 配置文件中的“AllowRoot”参数，则可以只以“root”身份运行 Zabbix server。

如果 Zabbix server 和 agent 均运行在同一台服务器上，建议使用不同的用户运行 server 和 agent 。否则，如果两者都以相同的用户运行，Agent 可以访问  Server 的配置文件, 任何 Zabbix 管理员级别的用户都可以很容易地检索到 Server 的信息。例如，数据库密码。

##### 配置文件

```bash

```



##### 启动脚本

用于在系统启动和关闭期间自动启动和停止 Zabbix 进程。脚本位于 misc/init.d 目录下。

#### 支持的平台

-  Linux
-  Solaris
-  AIX
-  HP-UX
-  Mac OS X
-  FreeBSD
-  OpenBSD
-  NetBSD
-  SCO Open Server 
-  Tru64/OSF1

#### 语言环境

Zabbix server 需要 UTF-8 语言环境，以便可以正确解释某些文本项。 大多数现代类 Unix 系统都默认使用 UTF-8 语言环境，但是，有些系统可能需要做特定的设置。

###  Agent

Zabbix agent 部署在被监控目标上，以主动监控本地资源和应用程序（硬盘、内存、处理器统计信息等）。

Zabbix agent 收集本地的操作信息并将数据报告给 Zabbix server 用于进一步处理。一旦出现异常 (例如硬盘空间已满或者有崩溃的服务进程)，Zabbix server 会主动警告管理员指定机器上的异常。

Zabbix agents 的极高效率缘于它可以利用本地系统调用来完成统计数据的采集。

#### 被动和主动检查

可以运行被动检查和主动检查。

在**被动检查**模式中，agent 应答数据请求。Zabbix server（或 proxy）询求数据，例如 CPU load，然后 Zabbix agent 返还结果。

**主动检查**处理过程将相对复杂。Agent 必须首先从 Zabbix sever 索取监控项列表以进行独立处理，然后会定期发送采集到的新值给 Zabbix server。

是否执行被动或主动检查是通过选择相应的**监控项类型**来配置的。 Zabbix agent 处理“Zabbix agent”或“Zabbix agent（active）”类型的监控项。

#### 支持的平台

-  Linux
-  IBM AIX 
-  FreeBSD 
-  NetBSD
-  OpenBSD 
-  HP-UX 
-  Mac OS X 
-  Solaris: 9, 10, 11
-  Windows：支持从 Windows XP 之后的桌面版和服务器版。

#### 类 UNIX 系统上的 Agent

通常，32位 Zabbix agent 可以在 64 位系统上运行，但在某些情况下可能会失败。

##### 通过二进制包安装的组件

Zabbix agent 进程以守护进程（Deamon）运行。

```bash
service zabbix-agent start | stop | restart | status
/etc/init.d/zabbix-agent start | stop | restart | status
```

##### 手动启动

```bash
zabbix_agentd
```

#### Windows 系统上的 Agent

Windows 系统上的 Zabbix agent 作为一个Windows服务运行。

Zabbix agent 作为 zip 压缩文件分发。下载该文件后，将其解压缩。 选择任何文件夹来存储Zabbix代理和配置文件，例如：

```bash
C:\zabbix
```

复制二进制文件 \bin\zabbix_agentd.exe 和配置文件 \conf\zabbix_agentd.conf 到 c:\zabbix 下。

按需编辑 c:\zabbix\zabbix_agentd.conf 配置文件，确保指定了正确的 “Hostname” 参数。

```bash
# 将 Zabbix agent 安装为 Windows 服务
c:\zabbix\zabbix_agentd.exe -c c:\zabbix\zabbix_agentd.conf -i
```

#### 其他 Agent 选项

您可以在主机上运行单个或多个 Agent 实例。 单个实例可以使用默认配置文件或命令行中指定的配置文件。 如果是多个实例，则每个 Agent 程序实例必须具有自己的配置文件（其中一个实例可以使用默认配置文件）。

```bash
# UNIX 和 Windows agent
-c --config <config-file>      # 使用此选项来制定配置文件文件。
                               # 在 UNIX 上，默认的配置文件是 /usr/local/etc/zabbix_agentd.conf 或由compile-time 中的 --sysconfdir 或
                               # --prefix 变量来确定。在 Windows上, 默认的配置文件是 c:\zabbix_agentd.conf
-p --print                     # 输出已知的监控项并退出。要返回用户自定义参数的结果，必须指定配置文件。
-t --test <item key>           # 测试指定的监控项并退出。要返回用户自定义参数的结果，必须指定配置文件。
-h --help				       # 显示帮助信息
-V --version                   # 显示版本号

# 仅 UNIX agent
-R --runtime-control <option>  # 执行管理功能。

# 仅 Windows agent
-m --multiple-agents           # 使用多 Agent 实例（使用-i、-d、-s、-x）。为了区分实例的服务名称，每项服务名会包涵来自配置文件里的 Hostname 值。

# 仅 Windows agent（功能）
-i --install                   # 以服务的形式安装 Zabbix Windows agent。
-d --uninstall                 # 卸载 Zabbix indows agent 服务。
-s --start                     # 启动 Zabbix Windows agent 服务。
-x --stop                      # 停止 Zabbix Windows agent 服务。
```

**示例**：

```bash
# 打印输出所有内置监控项和它们的值。
zabbix_agentd --print
# 使用指定的配置文件中的“mysql.ping”键值来测试用户自定义参数。
zabbix_agentd -t "mysql.ping" -c /etc/zabbix/zabbix_agentd.conf
# 在 Windows 下使用默认路径下的配置文件 c:\zabbix_agentd.conf 安装 Zabbix agent 服务。
zabbix_agentd.exe -i
# 使用位于与 agent 可执行文件同一文件夹中的配置文件 zabbix_agentd.conf 为 Windows 安装“Zabbix Agent [Hostname]”服务，并通过从配置文件中的唯一 Hostname 值来命名。
zabbix_agentd.exe -i -m -c zabbix_agentd.conf
```

#### 运行时控制

更改代理进程的日志级别。

| 选项                          | 描述                                             | 目标                                                         |
| ----------------------------- | ------------------------------------------------ | ------------------------------------------------------------ |
| log_level_increase[=<target>] | 增加日志级别。  如果未指定目标，将影响所有进程。 | 目标可以被指定为：  `pid` - 进程标识符 (1 to 65535)   `process type` - 指定进程的所有类型 (例如，poller)    `process type,N` - 进程类型和编号 (例如，poller,3) |
| log_level_decrease[=<target>] | 降低日志级别。  如果未指定目标，将影响所有进程。 |                                                              |

值得注意的是，用于更改单个 Agent 进程的日志级别的 PIDs 的可用范围是1到65535。在具有大 PIDs 的系统上，<process type,N> 目标可用于更改单个进程的日志级别。

例子：

```bash
# 给所有进程增加日志级别。
zabbix_agentd -R log_level_increase
# 给第二个监听进程增加日志级别。
zabbix_agentd -R log_level_increase=listener,2
# 给 PID 号为 1234 的进程增加日志级别。
zabbix_agentd -R log_level_increase=1234
# 给所有主动检查进程降低日志级别。
zabbix_agentd -R log_level_decrease="active checks"
```

运行时控制不支持 OpenBSD 和 NetBSD 和 Windows 系统。

#### 进程用户

Zabbix agent 在 UNIX 上允许使用非 root 用户运行。它将以任何非 root 用户的身份运行。因此，使用非 root 用户运行 agent 是没有任何问题的.

如果你试图以“root”身份运行它，它将会切换到一个已经“写死”的“zabbix”用户，该用户必须存在于您的系统上。如果您只想以“root”用户运行 agent，您必须在 agent 配置文件里修改‘AllowRoot‘参数。

#### 配置文件



#### 语言环境

值得注意的是，Zabbix agent 需要 UTF-8 语言环境，以便某些文本 Zabbix agent 监控项可以返回预期的内容。 大多数现代类 Unix 系统都默认使用 UTF-8 语言环境，但是，有些系统可能需要特定的设置。

#### 退出码

在 2.2 版之前，Zabbix agent 在成功退出时返回0，在异常时返回255。 从版本 2.2 及更高版本开始，Zabbix agent 在成功退出时返回0，在异常时返回1。

### Agent 2

新一代zabbix agent，未来可能会替代原Zabbix agent。

Zabbix agent 2可以实现：

-  降低TCP连接数。
-  具有更大的检查并发性。
-  易于通过插件进行扩展. 插件可以是:
  -  仅由几行简单代码实现的简单检查。
  -  由长时间运行的脚本及数据周期回传的独立数据采集的复杂检查。
-  可以替代原有的Zabbix agent（可以兼容原Zabbix agent的所有功能）。

用Go语言开发的(复用了原Zabbix Agent的部分C代码)。 Zabbix agent 2需要在1.13+版本的Go环境编译。

Agent 2不支持Linux上的守护进程; 而且从Zabbix 5.0.4开始，它可以作为Windows service服务运行。 

被动检查的工作原理与Zabbix agent类似。主动检查支持scheduled/flexible间隔和并行检查。

 **并行检查** 

不同的插件的检查可以并行执行。 每个插件的并行检查数量取决于对应插件的能力设置。每个插件可能有一个硬编码的能力设置值(缺省比如是100)，该值可在插件配置参数，通过 `Plugins.<Plugin name>.Capacity=N` 的命令行进行配置。

#### 支持的平台

支持Linux 和 Windows 平台。目前, Agent 2 在 Windows平台上支持的监控项数量是受限的。 

-  RHEL/CentOS 6, 7, 8
-  SLES 15 SP1+
-  Debian 9, 10
-  Ubuntu 18.04

#### 安装

Zabbix agent 2 可使用预先编译好的安装包。若用源码编译 Zabbix agent 2 需要在编译时指定`--enable-agent2` 配置选项。

#### Agent选项

| **参数**                      | **描述**                                                     |
| ----------------------------- | ------------------------------------------------------------ |
| -c --config <config-file>     | 配置文件的绝对路径。  您可以使用此选项来制定配置文件，而不是使用默认文件。  在 UNIX 上，默认的配置文件是 /usr/local/etc/zabbix_agentd.conf 或 由 [compile-time](https://www.zabbix.com/documentation/5.0/zh/manual/installation/install#installing_zabbix_daemons) 中的 *--sysconfdir* or *--prefix*  变量来确定。 |
| -f --foreground               | 在前台运行 Zabbix agent (缺省: true)。                       |
| -p --print                    | 输出已知的监控项并退出。  *注意*: 要返回 [用户自定义参数](https://www.zabbix.com/documentation/5.0/zh/manual/config/items/userparameters) 的结果, 您必须指定配置文件（如果它不在默认路径下）。 |
| -t --test <item key>          | 测试指定的监控项并退出。  *注意*:  要返回 [用户自定义参数](https://www.zabbix.com/documentation/5.0/zh/manual/config/items/userparameters) 的结果, 您必须指定配置文件（如果它不在默认路径下）。 |
| -h --help                     | 显示帮助信息并退出。                                         |
| -v --verbose                  | 显示debugging信息，使用 -p 和 -t 选项。                      |
| -V --version                  | 显示agent版本号并退出。                                      |
| -R --runtime-control <option> | 执行管理功能。                                               |

示例：

```bash
# 显示agent全部的内建监控项和对应的值。
zabbix_agent2 --print
# 使用指定的配置文件中的“mysql.ping”键值来测试用户自定义参数。
zabbix_agent2 -t "mysql.ping" -c /etc/zabbix/zabbix_agentd.conf
```

#### 运行时控制

| 选项               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| log_level_increase | 增加日志级别。  在 Zabbix 5.0.0-5.0.3 版本使用 "loglevel increase" 替代(quoted)。 |
| log_level_decrease | 降低日志级别。  在 Zabbix 5.0.0-5.0.3 版本使用 "loglevel decrease" 替代 (quoted)。 |
| metrics            | 显示可用的指标项。                                           |
| version            | 显示agent版本。                                              |
| help               | 在运行时控制显示帮助信息。                                   |

例:

-  

```bash
# 增加agent 2日志级别
zabbix_agent2 -R log_level_increase
# 打印运行时控制的选项
zabbix_agent2 -R help
```

#### 配置文件

Agent 2的配置参数除了如下几个有差异外，其余与Agent都是兼容的。

| 新参数                                                       | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| *ControlSocket*                                              | 运行时控制的 socket 路径。 Agent 2 的 [运行时命令行 ](https://www.zabbix.com/documentation/5.0/zh/manual/concepts/agent2#runtime_control)使用控制 socket。 |
| *EnablePersistentBuffer*,   *PersistentBufferFile*,   *PersistentBufferPeriod* | agent 2的这些参数用于配置已激活监控项的持久化存储。          |
| *Plugins*                                                    | 插件可以有自己的参数, 以 `Plugins.<Plugin name>.<Parameter>=<value>`的格式进行设置。 插件的常用参数 *Capacity*的各检查项限制可同时设置。 |
| *StatusPort*                                                 | agent 2监听HTTP状态请求的端口及显示配置插件列表和一些内部参数。 |

| 删除的参数                                                   | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| *AllowRoot*, *User*                                          | 不支持,因不支持守护进程。                                    |
| *LoadModule*, *LoadModulePath*                               | 可加载模块不支持。                                           |
| *StartAgents*                                                | Zabbix agent中用于使能或关闭增加并行被动检查数。Agent 2中，因并行检查数是插件层面的配置，且可以通过插件能力配置进行限制，故不支持关闭被动检查。 |
| *HostInterface*, *HostInterfaceItem*                         | 目前暂不支持。                                               |

#### 退出码

自4.4.8版本起，Zabbix agent 2也可以与较老的OpenSSL版本(1.0.1, 1.0.2)一起编译。

这样Zabbix就可以提供OpenSSL中用的互斥锁。如果互斥锁锁定或者解锁失败时就会向标准错误输出(STDERR) 打印一条错误消息，Agent2会返回错误码 2 或者 3 并退出。

### Proxy

是一个可以从一个或多个受监控设备采集监控数据并将信息发送到 Zabbix server 的进程，主要是代表  Zabbix server 工作。 所有收集的数据都在本地缓存，然后传输到 proxy 所属的 Zabbix server。

部署Zabbix proxy 是可选的，但可能非常有利于分担单个 Zabbix server 的负载。 如果只有代理采集数据，则 Zabbix server 上会减少 CPU 和磁盘 I/O 的开销。

Zabbix proxy 是无需本地管理员即可集中监控远程位置、分支机构和网络的理想解决方案。

Zabbix proxy 需要使用独立的数据库。

Zabbix proxy 支持 SQLite、MySQL和PostgreSQL 作为数据库 。

#### 通过二进制包安装的组件

Zabbix proxy 进程以守护进程（Deamon）运行。

```bash
service zabbix-proxy start | stop | restart | status
/etc/init.d/zabbix-proxy start | stop | restart | status
```

#### 手动启动

```bash
zabbix_proxy

-c --config <file>              # 配置文件路径
-R --runtime-control <option>   # 执行管理功能
-h --help                       # 帮助
-V --version                    # 显示版本号
```

运行时机制的控制不支持 OpenBSD 和 NetBSD 系统。

示例:：

```bash
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf
zabbix_proxy --help
zabbix_proxy -V
```

#### 运行时控制

| 选项                              | 描述                                                         | 目标                                                         |
| --------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| config_cache_reload               | 重新加载配置缓存。如果当前正在加载缓存，则忽略。  主动模式下的 Zabbix proxy 将连接到Zabbix server 并请求配置数据。 |                                                              |
| housekeeper_execute               | 启动管家程序。忽略当前正在进行中的管家程序。                 |                                                              |
| log_level_increase[=<**target**>] | 增加日志级别，如果未指定目标，将影响所有进程。               | **pid** - 进程标识符 (1 to 65535)   **process type** - 指定进程的所有类型 (例如，poller)    **process type,N** - 进程类型和编号 (例如，poller,3) |
| log_level_decrease[=<**target**>] | 降低日志级别，如果未指定目标，则会影响所有进程。             |                                                              |

单一 Zabbix 进程的日志级别改变后，进程的 PIDs 的值也会改变，允许的范围为1~65535。在具有大 PIDs <process type,N> 目标选项可更改单个进程的日志级别。

```bash
# 使用 config_cache_reload 选项重新加载 proxy 的配置缓存
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R config_cache_reload
# 使用 housekeeper_execute 选项来触发管家服务执行
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R housekeeper_execute

# 增加所有进程的日志级别：
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R log_level_increase
# 增加第二个 Poller 进程的日志级别：
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R log_level_increase=poller,2
# 增加 PID 为 1234 进程的日志级别：
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R log_level_increase=1234
# 降低 http poller 进程的日志级别：
zabbix_proxy -c /usr/local/etc/zabbix_proxy.conf -R log_level_decrease="http poller"
```

#### 进程用户

Zabbix proxy 允许使用非 root 用户运行。它将以任何非 root 用户的身份运行。因此，使用非 root 用户运行 proxy 是没有任何问题的.

如果你试图以“root”身份运行它，它将会切换到一个已经“写死”的“zabbix”用户，该用户必须存在于您的系统上。如果您只想以“root”用户运行 proxy，您必须在 proxy 配置文件里修改‘AllowRoot‘参数。

#### 配置文件



#### 语言环境

值得注意的是，Zabbix proxy 需要 UTF-8 语言环境，以便可以正确解释某些文本项。 大多数现代类 Unix 系统都默认使用 UTF-8 语言环境，但是，有些系统可能需要专门设置。

### Java 网关

从 Zabbix 2.0 开始，以 Zabbix 守护进程方式原生支持监控 JMX 应用程序就存在了，称之为“Zabbix Java  gateway”。

守护进程是用 Java 编写。为了在特定主机上找到 JMX 计数器的值，Zabbix server 向 Zabbix Java gateway 发送请求，后者使用 JMX 管理 API 来远程查询相关的应用。该应用不需要安装额外的软件。只需要在启动时，命令行添加`-Dcom.sun.management.jmxremote`选项即可。

Java gateway 接受来自 Zabbix server 或 Zabbix proxy 的传入连接，并且只能用作“被动 proxy”。与  Zabbix proxy 相反，它也可以从 Zabbix proxy （Zabbix proxy 不能被链接）调用。在 Zabbix  server 或 Zabbix proxy 配置文件中，可以直接配置每个 Java gateway 的访问，因此每个 Zabbix  pserver 或 Zabbix proxy 只能配置一个 Java gateway。如果主机将有 **JMX agent** 或其他类型的监控项，则只将 **JMX agent** 监控项传递给 Java gateway 进行检索。

当必须通过 Java gateway 更新监控项时，Zabbix server 或 proxy 将连接到 Java gateway  并请求该值，Java gateway 将检索该值并将其传递回 Zabbix server 或 Zabbix proxy。 因此，Java  gateway 不会缓存任何值。

Zabbix server 或 Zabbix proxy 具有连接到 Java gateway 的特定类型的进程，由 **StartJavaPollers** 选项控制。在内部，Java gateway 启动多个线程，由 **START_POLLERS** 选项控制。 在服务器端，如果连接超过 **Timeout** 选项配置的秒数，它将被终止，但 Java gateway 可能仍在忙于从 JMX 计数器检索值。 为了解决这个问题，从 Zabbix 2.0.15、Zabbix 2.2.10 和 Zabbix 2.4.5 开始，Java gateway 中有 **TIMEOUT** 选项，允许为 JMX 网络操作设置超时。

Zabbix server 或 proxy 尝试尽可能地将请求汇集到单个 JMX 目标（受监控项取值间隔影响），并在单个连接中将它们发送到 Java Gateway 以获得更好的性能。

此外，建议让 **StartJavaPollers** 选项的值小于或等于 **START_POLLERS**，否则可能会出现 Java gateway 中没有可用线程来为传入请求提供服务的情况。

#### 获取 Java gateway

##### 1. 从 Zabbix 网站下载

Zabbix Java gateway 二进制包 （RHEL, Debian, Ubuntu）可以从 [http://www.zabbix.com/download.php](https://www.zabbix.com/download.php) 下载。

##### 2. 从源码包中编译

为了编译 Java gateway，首先使用 `--enable-java` 选项运行 `./configure` 脚本。建议使用 `--prefix` 选项来指定其他路径，而非默认的 /usr/local 路径，因为安装 Java gateway 将创建整个目录树，并非单个可执行文件。

```bash
./configure --enable-java --prefix=$PREFIX
```

要将 Java gateway 编译并打包到 JAR 文件中，运行 `make`。

```bash
make
```

现在 src/zabbix_java/bin 路径下 有 zabbix-java-gateway-$VERSION.jar  文件。

```bash
make install
```

#### Java gateway 分发中的文件概述

在 $PREFIX/sbin/zabbix_java 路径下会获得一系列的 shell 脚本、JAR 和配置文件。这些文件的作用的概述如下。

```bash
bin/zabbix-java-gateway-$VERSION.jar   # Java gateway JAR 文件。

# 依赖 Logback 、 SLF4J  和 Android JSON 库。
lib/logback-core-0.9.27.jar
lib/logback-classic-0.9.27.jar
lib/slf4j-api-1.6.1.jar
lib/android-json-4.3_r3.1.jar

# 用于 Logback 的配置文件
lib/logback.xml  
lib/logback-console.xml

# 启动和停止 Java gateway 的便捷脚本
shutdown.sh  
startup.sh

# 由上面启动和停止脚本提供的配置文件
settings.sh
```

#### 配置和运行 Java gateway

默认情况下，Java gateway 监听 10052 端口。如果您计划使用不同的端口来运行 Java gateway，则可以通过 setting.sh 脚本中指定端口。

值得注意的是，端口 10052 并没有在 IANA 注册。

运行 startup 脚本来启动 Java gateway：

```bash
./startup.sh
```

运行 shutdown 脚本即可关闭它。

```bash
./shutdown.sh
```

与 Zabbix server 或 Zabbix proxy 不同，Java gateway 是轻量级的，并不需要数据库。

#### 配置 server 以使用 Java gateway

在 Zabbix server 配置文件中指定 JavaGateway 和 JavaGatewayPort 参数。如果 Zabbix proxy 监控运行着 JMX 应用程序的主机，则在 Zabbix proxy 配置文件中指定连接参数。

```bash
JavaGateway=192.168.3.14
JavaGatewayPort=10052
```

默认情况下，Zabibx server 不会启动与 JMX 监控相关的任何进程。但是，如果要使用它，则必须指定 Java pollers 的 pre-forked 实例数。 同样的，也可以指定常规的 pollers 和 trappers。

```bash
StartJavaPollers=5
```

在完成配置后，重新启动 Zabbix server 或 Zabbix proxy。

#### Java gateway 的调试

如果 Java gateway 出现任何问题或者您看到 Zabbix 前端中的监控项错误消息不充分时，您可以查看 Java gateway 的日志文件。

默认情况下，Java gateway 的日志会记录到 /tmp/zabbix_java.log  文件中，日志级别为“info”。有时候这些信息是不够的，需要将日志级别修改为“dubug”。为了提高日志记录级别，需要修改lib/logback.xml 文件并将 <root> 标记的 level 属性更改为“debug”：

```xml
<root level="debug">
  <appender-ref ref="FILE" />
</root>
```

与 Zabbix server 或 Zabbix proxy 不同，更改 logback.xml 文件后无需重新启动 Zabbix Java gateway，将自动完成 logback.xml 中的更改。 完成调试后，可以将日志记录级别修改回“info”。

如果希望记录到其他文件或完全不同的介质（如数据库），调整 logback.xml 文件以满足需要。

有时为了方便调试，将 Java gateway 作为控制台应用程序而不是守护程序启动是更有用的。 为此，请在 settings.sh 中注释掉  PID_FILE 变量。 如果省略 PID_FILE ，则 startup.sh 脚本将 Java gateway 作为控制台应用程序启动，并让 Logback 使用 lib/logback-console.xml 文件，这不仅会记录到控制台，还会启用日志记录级别“debug”。

最后，值得注意的，由于 Java gateway 使用 SLF4J 进行日志记录，因此可以适当地将 JAR 包放置在 lib 目录中， 来将 Logback 替换为您所选的框架。

#### 从 RHEL/CentOS 包安装

```bash
/etc/zabbix/zabbix_java_gateway.conf

service zabbix-java-gateway restart

systemctl enable zabbix-java-gateway
chkconfig --level 12345 zabbix-java-gateway on
```

##### 调试JAVA网关

Zabbix Java 网关日志路径:

```bash
/var/log/zabbix/zabbix_java_gateway.log
```

如果要增加日志记录，编辑以下文件：

```bash
/etc/zabbix/zabbix_java_gateway_logback.xml
```

并将 `level="info"` 更改为 "debug" 或 "trace" （为了深度排错）：

```xml
<configuration scan="true" scanPeriod="15 seconds">
[...]
      <root level="info">
              <appender-ref ref="FILE" />
      </root>

</configuration>
```

#### 从 Debian/Ubuntu 包安装

```bash
/etc/zabbix/zabbix_java_gateway.conf

service zabbix-java-gateway restart
systemctl enable zabbix-java-gateway
```

##### 调试JAVA网关

Zabbix Java 网关的日志文件为：

```bash
/var/log/zabbix/zabbix_java_gateway.log
```

如果要增加日志记录，编辑以下文件：

```bash
/etc/zabbix/zabbix_java_gateway_logback.xml
```

并将 `level="info"` 更改为 "debug" 或 "trace" （为了深度排错）：

```xml
<configuration scan="true" scanPeriod="15 seconds">
[...]
      <root level="info">
              <appender-ref ref="FILE" />
      </root>

</configuration>
```

### Sender

Zabbix sender 是一个命令行应用程序，可用于将性能数据发送到 Zabbix server 进行处理。

该实用程序通常用于长时间运行的用户脚本，用于定期发送可用性和性能数据。

要将结果直接发送到 Zabbix server 或 proxy，必须配置 trapper 监控项类型。 

```bash
cd bin
./zabbix_sender -z zabbix -s "Linux DB3" -k db.connections -o 43

-z         	# Zabbix server 主机（也可以使用 IP 地址）
-s          # 被监控主机的名称（在前端注册）
-k			# 监控项键值
-o 			# 要发送的值
```

包含空格的选项必须使用双引号引用。

Zabbix sender 可通过从输入文件发送多个值。

Zabbix sender 接受 UTF-8 编码的字符串（对于类 UNIX 系统和 Windows ），且在文件中没有字节顺序标记（BOM）。

在 Windows 上运行：

```bash
zabbix_sender.exe [options]
```

从 Zabbix 1.8.4 开始，zabbix_sender 实时发送方案已得到改进，可以连续接收多个传递给它的值，并通过单个连接将它们发送到服务器。 两个不超过0.2秒的值可以放在同一堆栈中，但最大 pooling 时间仍然是1秒。

Zabbix sender 如果指定的配置文件中存在无效（不遵循 *parameter=value* 注释）的参数条目，则 Zabbix sender 将终止。

### Get

Zabbix get 是一个命令行应用，它可以用于与 Zabbix agent 进行通信，并从 Zabbix agent 那里获取所需的信息。

该应用通常被用于 Zabbix agent 故障排错。

一个在 UNIX 下运行 Zabbix get 以从 Zabbix agent 获取 processor load 的值的例子。

```bash
cd bin
./zabbix_get -s 127.0.0.1 -p 10050 -k system.cpu.load[all,avg1]
```

另一个运行 Zabbix get 以从网站捕获一个字符串的例子：

```bash
cd bin
./zabbix_get -s 192.168.1.1 -p 10050 -k "web.page.regexp[www.zabbix.com,,,\"USA: ([a-zA-Z0-9.-]+)\",,\1]"
```

此处的监控项键值包含空格，因此引号用于将监控项键值标记为 shell。 引号不是监控项键值的一部分；它们将被 shell 修剪，不会被传递给Zabbix agent。

命令行参数：

```bash
-s --host <host name or IP>      	# 指定目标主机名或IP地址
-p --port <port number>          	# 指定主机上运行 Zabbix agent 的端口号。默认端口10050
-I --source-address <IP address> 	# 指定源 IP 地址
-k --key <item key>              	# 指定要从监控项键值检索的值
-h --help                        	# 获得帮助
-V --version                     	# 显示版本号
```

在 Windows 上运行：

```bash
zabbix_get.exe [options]
```

###  JS

zabbix_js 是一个命令行实用程序，可用于嵌入脚本测试。 

该程序可执行带有字符串参数的用户自定义脚本并打印结果。脚本的执行是由内嵌的Zabbix脚本引擎来完成的。

在编译或执行错误的情况下，zabbix_js将在stderr中打印错误并以代码1退出。

```bash
zabbix_js -s script-file -p input-param [-l log-level] [-t timeout]
zabbix_js -s script-file -i input-file [-l log-level] [-t timeout]

-s, --script script-file         # 指定待执行脚本的文件名。若 '-' 作为文件名时，脚本名由stdin输入。
-i, --input input-file           # 指定输入参数的文件名。若 '-' 作为文件名时，脚本名由stdin输入。
-p, --param input-param          # 指定输入参数。
-l, --loglevel log-level         # 指定日志级别。
-t, --timeout timeout            # 指定超时时间（单位：秒）。
-h, --help                       # 显示帮助信息。
-V, --version                    # 显示版本号。
```

例如:

```bash
zabbix_js -s script-file.js -p example
```

### 登陆和配置用户



#### 简介

本章你会学习到如何登陆Zabbix以及在Zabbix内建立一个系统用户。

#### 登陆

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/login.png?w=350&tok=9f2001)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/login.png?id=zh%3Amanual%3Aquickstart%3Alogin)

这是Zabbix的“欢迎”界面。输入用户名 **Admin** 以及密码 **zabbix** 以作为 [Zabbix超级用户](https://www.zabbix.com/documentation/5.0/manual/config/users_and_usergroups/permissions)登陆。

登陆后，你将会在页面右下角看到“以管理员连接（Connected as Admin）”。同时会获得访问 *配置（Configuration）* and *管理（Administration）* 菜单的权限。

##### 暴力破解攻击的保护机制

为了防止暴力破解和词典攻击，如果发生连续五次尝试登陆失败，Zabbix接口将暂停30秒。

在下次成功登陆后，将会在界面上显示登录尝试失败的IP地址。

#### 增加用户

可以在*管理（Administration） → 用户（Users）*下查看用户信息。

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/userlist.png?w=600&tok=1e69e1)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/userlist.png?id=zh%3Amanual%3Aquickstart%3Alogin)

点击 *创建用户（Create user）* 以增加用户。

在添加用户的表单中，请确保将新增的用户添加到了一个已有的[用户组](https://www.zabbix.com/documentation/5.0/manual/config/users_and_usergroups/usergroup)，比如'Zabbix administrators'。

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/new_user.png)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/new_user.png?id=zh%3Amanual%3Aquickstart%3Alogin)

所有必填字端都以红色星标标记。

默认情况下，没有为新增的用户定义媒介（media，即通知发送方式) 。如需要创建，可以到'媒介（Media）'标签下，然后点击*增加（Add）*。 

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/new_media.png)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/new_media.png?id=zh%3Amanual%3Aquickstart%3Alogin)

在这个对话框中，为用户输入一个Email地址。 

你可以为媒介指定一个时间活动周期，(访问[时间周期说明](https://www.zabbix.com/documentation/5.0/manual/appendix/time_period)页面，查看该字段格式的描述）。默认情况下，媒介一直是活动的。你也可以通过自定义[触发器严重等级](https://www.zabbix.com/documentation/5.0/manual/config/triggers/severity)来激活媒介，默认所有的等级都保持开启。 

点击*新增（Add）*，然后在用户属性表单中点击*新增（Add）*。新的用户将出现在用户清单中。

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/userlist2.png?w=600&tok=34dc39)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/userlist2.png?id=zh%3Amanual%3Aquickstart%3Alogin)

##### 添加权限

默认情况下，新用户没有访问主机的权限。 若要授予用户权限，请单击“组”列中的用户组(在本例中为“administrators”组)。 在“组属性”表单中，转到“权限”选项卡。

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/group_permissions.png?w=600&tok=969b6c)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/group_permissions.png?id=zh%3Amanual%3Aquickstart%3Alogin)

此用户是要有只读访问Linux Server组的权限，所以点击用户组选择字段旁边的Select。

[![img](https://www.zabbix.com/documentation/5.0/_media/zh/manual/quickstart/add_permissions.png)](https://www.zabbix.com/documentation/5.0/_detail/zh/manual/quickstart/add_permissions.png?id=zh%3Amanual%3Aquickstart%3Alogin)

在此弹出框中，选中在“Linux servers”旁边的复选框，然后单击“选择”。 Linux server就会显示在选择清单中。 单击“Read”按钮设置权限级别，然后添加到权限列表中。 在“用户组属性”表单中，单击“更新。

重要提醒：在Zabbix中，主机的访问权限被分配给 [用户组](https://www.zabbix.com/documentation/5.0/manual/config/users_and_usergroups/usergroup), 而不是单独的用户。

权限设置完成了！ 您可以尝试使用新用户的凭据登录。







# ZABBIX_AGENT2

## 名称

zabbix_agent2 - Zabbix agent 2 

 

## 概要简介

**zabbix_agent2** [**-c***config-file*] 
**zabbix_agent2** [**-c***config-file*] **-p**
**zabbix_agent2** [**-c***config-file*] **-t***item-key*
**zabbix_agent2** [**-c***config-file*] **-R***runtime-option*
**zabbix_agent2 -h**
**zabbix_agent2 -V**

 

## 描述

**zabbix_agent2** 是用于监视各种服务的参数的应用程序。  

 

## 选项

- **-c**, **--config** *config-file*

  使用自定义*配置文件（config-file）* 而不是默认的配置文件

- **-R**, **--runtime-control** *runtime-option*

  根据*runtime-option*执行管理功能.

#### 运行时控制选项:

- 

  **loglevel increase** 增加日志级别

- 

  **loglevel decrease** 降低日志级别

- 

  **help** 列出可用的运行时控件选项

- 

  **metrics** 列出可用指标

- 

  **version** 显示版本

- **-p**, **--print**

  打印已知项目并退出。对于每个项目，要么使用通用默认值，要么提供用于测试的特定默认值。这些默认值在方括号中作为项目关键参数列出。返回值括在方括号中，并以返回值的类型作为前缀，并以竖线字符分隔。对于用户参数，类型始终为t，因为代理无法确定所有可能的返回值。当查询正在运行的代理守护程序时，由于权限或环境可能不同，显示为工作中的项目不能保证在Zabbix服务器或zabbix_get中可以工作。返回值类型为：  d 带有小数部分的数字。   m 不支持。这可能是由于查询仅在活动模式下工作的项目（例如日志监视项目或需要多个收集值的项目）引起的。权限问题或不正确的用户参数也可能导致不支持状态。   s 文本。最大长度没有限制。   t 文本。与**s**相同。   u 无符号整数   

- **-t**, **--test** *item-key*

  测试单个项目并退出。有关输出说明，请参见**--print** 

- **-h**, **--help**

  显示此帮助并退出

- **-V**, **--version**

  输出版本信息并退出.

 

## 档案

- */usr/local/etc/zabbix_agent2.conf*

  Zabbix agent 2配置文件的默认位置(如果在编译时没有修改)。







a.从windows下控制面板->字体->选择一种中文字库，例如“微软雅黑”

b.把它拷贝到zabbix的web端的fonts目录下例如：/usr/local/apache2/htdocs/zabbix/fonts，并且把TTF后缀改为ttf

c.修改zabbix的web端 include/defines.inc.php

cd /usr/local/apache2/htdocs/zabbix

vi include/defines.inc.php

搜索 'DejaVuSans'

用"//"注释掉系统默认行，并添加新的字体参数行。

其中msyh为字库名字,不包含ttf后缀

----------------------

//define('ZBX_FONT_NAME', 'DejaVuSans');

define('ZBX_FONT_NAME', 'msyh');


//define('ZBX_GRAPH_FONT_NAME', 'DejaVuSans');

define('ZBX_GRAPH_FONT_NAME', 'msyh');


3.监控windows主机：

下载地址：http://www.zabbix.com/downloads/2.0.6/zabbix_agents_2.0.6.win.zip

在C:\Program Files\下创建zabbix文件夹

解压zip包后：将包内bin/win64/下的所有文件复制到 C:\Program Files\zabbix下

并在该目录下创建一个zabbix_agentd.conf文件，内容为

-------------------

LogFile=C:\Program Files\zabbix\zabbix_agentd.log

Server=192.168.7.11

UnsafeUserParameters=1

-------------------

进入cmd命令行：

cd C:\Program Files\zabbix

安装zabbix客户端：

zabbix_agentd.exe -c "c:\Program Files\zabbix\zabbix_agentd.conf" -i

启动zabbix服务：

zabbix_agentd.exe -c "c:\Program Files\zabbix\zabbix_agentd.conf" -s

参数含义：

-c    制定配置文件所在位置

-i    安装客户端

-s    启动客户端

-x    停止客户端

-d    卸载客户端

如图:

1

在服务端添加客户端主机监控同上。。





# ZABBIX_AGENTD

## 名称

zabbix_agentd - Zabbix agent 守护进程 

## 概要

**zabbix_agentd** [**-c***config-file*] 
**zabbix_agentd** [**-c***config-file*] **-p**
**zabbix_agentd** [**-c***config-file*] **-t***item-key*
**zabbix_agentd** [**-c***config-file*] **-R***runtime-option*
**zabbix_agentd -h**
**zabbix_agentd -V** 

## 描述

**zabbix_agentd** 是用于监视各种服务器参数的守护程序。 

## 选项

- **-c**, **--config** *config-file*

  使用自定义 *配置文件（config-file）* 而不是默认配置文件。

- **-f**, **--foreground**

  在前台运行 Zabbix agent.

- **-R**, **--runtime-control** *runtime-option*

  根据*runtime-option*执行管理功能.

 

运行时控制选项

- 

  **log_level_increase**[=*target*] 增加日志级别，如果未指定目标，则影响所有进程

- 

  **log_level_decrease**[=*target*] 降低日志级别，如果未指定目标，则会影响所有进程

 

### 

日志级别控制目标

- 

  *pid*  Process identifier

- 

  *process-type*  指定类型的所有进程（活动检查，收集器，侦听器）

- 

  *process-type,N*  进程类型和编号（例如，listener，3）

- 

  *pid*  进程标识符，最多65535。对于较大的值，将target指定为“ process-type，N”

- **-p**, **--print**

  打印已知项目并退出。对于每个项目，要么使用通用默认值，要么提供用于测试的特定默认值。这些默认值在方括号中作为项目关键参数列出。返回值括在方括号中，并以返回值的类型作为前缀，并以竖线字符分隔。对于用户参数，类型始终为t，因为代理无法确定所有可能的返回值。当查询正在运行的代理守护程序时，由于权限或环境可能不同，显示为工作中的项目不能保证在Zabbix服务器或zabbix_get中可以工作。返回值类型为：  d 带有小数部分的数字   m 不支持。这可能是由于查询仅在活动模式下工作的项目（例如日志监视项目或需要多个收集值的项目）引起的。权限问题或不正确的用户参数也可能导致不支持状态.   s 文本。最大长度没有限制。   t 文本。与**s**相同.   u 无符号整数.

- **-t**, **--test** *item-key*

  测试单个项目并退出。有关输出说明，请参见**--print**.

- **-h**, **--help**

  显示此帮助并退出.

- **-V**, **--version**

  输出版本信息并退出.

 

## 档案

- */usr/local/etc/zabbix_agentd.conf*

  Zabbix agent 配置文件的默认位置（如果在编译时未修改）.





# ZABBIX_GET



## 名称

zabbix_get - Zabbix get 实用程序 

## 概要

**zabbix_get -s***主机名或IP* [**-p***p端口号*] [**-I***IP地址*] **-k** *监控项关键字*
**zabbix_get -s***主机名或IP* [**-p***端口号*] [**-I***IP地址*] **--tls-connect****cert****--tls-ca-file***CA-文件* [**--tls-crl-file***CRL-file*] [**--tls-agent-cert-issuer***cert-issuer*] [**--tls-agent-cert-subject***cert-subject*] **--tls-cert-file***cert-file***--tls-key-file***key-file***-k** *item-key*
**zabbix_get -s***主机名或IP* [**-p***端口号*] [**-I***IP地址*] **--tls-connect****psk****--tls-psk-identity***PSK-identity***--tls-psk-file***PSK-file***-k** *item-key*
**zabbix_get -h**
**zabbix_get -V** 

## 描述

**zabbix_get** zabbix_get是一个命令行实用程序，用于从Zabbix agent获取数据. 

## 选项

- **-s**, **--host** *主机名或IP*

  指定主机的主机名或IP地址.

- **-p**, **--port** *端口号*

  指定主机上运行的代理的端口号。默认值为10050.

- **-I**, **--source-address** *IP地址*

  指定源IP地址.

- **-k**, **--key** *item-key*

  指定要为其检索值的监控项的键.

- **--tls-connect** *value*

  如何连接到 agent. 值:

 

### 

- **unencrypted**

  不加密连接（默认）

- 

  **psk**  使用TLS和预共享密钥进行连接

- 

  **cert**  使用TLS和证书进行连接

- **--tls-ca-file** *CA文件*

  包含用于对等证书验证的顶级CA证书的文件的完整路径名.

- **--tls-crl-file** *CRL文件*

  包含已撤销证书的文件的完整路径名.

- **--tls-agent-cert-issuer** *证书颁发者/I>*

  *允许的代理证书颁发者.*

- ***--tls-agent-cert-subject** \*证书主题**

  *允许的代理证书主题.*

- ***--tls-cert-file** \*证书文件**

  *包含证书或证书链的文件的完整路径名.*

- ***--tls-key-file** \*密钥文件**

  *包含私钥的文件的完整路径名.*

- ***--tls-psk-identity** \*PSK身份**

  *PSK身份字符串.*

- ***--tls-psk-file** \*PSK文件**

  *包含预共享密钥的文件的完整路径名.*

- ***--tls-cipher13** \*密码字符串**

  *OpenSSL 1.1.1或TLS 1.3或更高版本的密码字符串。覆盖默认密码套件选择条件。如果OpenSSL版本低于1.1.1，则此选项不可用.*

- ***--tls-cipher** \*密码字符串**

  *GnuTLS优先级字符串（用于TLS 1.2及更高版本）或OpenSSL密码字符串（仅用于TLS 1.2）。覆盖默认密码套件选择条件*

- ***-h**, **--help***

  *显示此帮助并退出.*

- ***-V**, **--version***

  *输出版本信息并退出.*

 *例子 **zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.load[all,avg1]"** 
 **zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.load[all,avg1]"  --tls-connect cert --tls-ca-file /home/zabbix/zabbix_ca_file  --tls-agent-cert-issuer "CN=Signing CA,OU=IT operations,O=Example  Corp,DC=example,DC=com" --tls-agent-cert-subject "CN=server1,OU=IT  operations,O=Example Corp,DC=example,DC=com" --tls-cert-file  /home/zabbix/zabbix_get.crt --tls-key-file /home/zabbix/zabbix_get.key 
 zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.load[all,avg1]"  --tls-connect psk --tls-psk-identity "PSK ID Zabbix agentd"  --tls-psk-file /home/zabbix/zabbix_agentd.psk**  另请参阅*



# ZABBIX_JS

部分：用户命令（1）
更新时间: 2019-01-29
[索引](https://www.zabbix.com/documentation/5.0/zh/manpages/zabbix_js#index)[返回主目录](https://www.zabbix.com/documentation/5.0/manpages)

------

 

## 名称

zabbix_js - Zabbix JS实用程序 

## 概要

**zabbix_js -s***脚本文件***-p***输入参数* [**-l***日志级别*] [**-t***超时*] 
**zabbix_js -s***脚本文件***-i***输入文件* [**-l***日志级别*] [**-t***超时*] 
**zabbix_js -h**
**zabbix_js -V** 

## 描述

**zabbix_js** 是可用于嵌入式脚本测试的命令行实用程序. 

## 选项

- **-s**, **--script** *脚本文件*

  指定要执行的脚本的文件名。如果将“-”指定为文件名，则将从标准输入中读取脚本.

- **-p**, **--param** *input-param*

  指定输入参数.

- **-i**, **--input** *输入文件*

  指定输入参数的文件名。如果将“-”指定为文件名，则将从标准输入中读取输入.

- **-l**, **--loglevel** *log-level*

  日志级别.

- **-t**, **--timeout** *超时*

  指定超时（以秒为单位）.

- **-h**, **--help**

  显示此帮助并退出.

- **-V**, **--version**

  输出版本信息并退出.

 

## 例子

**zabbix_js -s script-file.js -p example**  



# ZABBIX_PROXY

章节: 维护命令 (8)
更新时间: 2020-09-04
[索引](https://www.zabbix.com/documentation/5.0/zh/manpages/zabbix_proxy#index)[返回主目录](https://www.zabbix.com/documentation/3.0/manpages)

------

 

## 名称

zabbix_proxy - Zabbix proxy 守护程序 

## 概要

**zabbix_proxy** [**-c***配置文件*] 
**zabbix_proxy** [**-c***配置文件*] **-R***运行时选项*
**zabbix_proxy -h**
**zabbix_proxy -V** 

## 描述

**zabbix_proxy** 是一个守护程序，用于从设备收集监视数据并将其发送到Zabbix server. 

## 选项

- **-c**, **--config** *配置文件*

  使用自定义*配置文件* 而不是默认*配置文件*.

- **-f**, **--foreground**

  在前台运行 Zabbix proxy.

- **-R**, **--runtime-control** *运行时选项*

  根据*runtime-option*执行管理功能.

 

### 

运行时控制选项

- 

  **config_cache_reload**  重新加载配置缓存。忽略当前是否正在加载缓存。活动的Zabbix代理将连接到Zabbix服务器并请求配置数据。默认配置文件（除非指定了-c选项）将用于查找PID文件，并将信号发送到进程，列在PID文件中.

- 

  **snmp_cache_reload**  重新加载SNMP缓存。

- 

  **housekeeper_execute**  执行管家。如果当前正在执行管家，则将其忽略.

- 

  **diaginfo**[=*section*] 记录指定节的内部诊断信息。Section可以是*historycache, preprocessing\*。缺省情况下，记录所有节的诊断信息**

****log_level_increase**[=\*target\*] 如果未指定目标，则增加日志级别，影响所有进程。   **log_level_decrease**[=\*target\*] 降低日志级别，如果未指定目标，则会影响所有进程      日志级别控制目标  \*process-type\*  指定类型的所有进程（配置同步器，数据发送器，发现器，心跳发送器，历史记录同步器，管家，http轮询器，icmp  pinger，ipmi管理器，ipmi轮询器，java轮询器，轮询器，自我监控，snmp捕获器，任务管理器，捕获器，无法访问的轮询器，vmware收集器）   \*process-type,N\*  进程类型和编号(例如，轮询器，3)   \*pid\*  进程标识符，最多65535。对于较大的值，将target指定为“ process-type，N”   **-h**, **--help** 显示此帮助并退出. **-V**, **--version** 输出版本信息并退出.   档案  \*/usr/local/etc/zabbix_proxy.conf\*  Zabbix proxy 配置文件的默认位置（如果在编译时未修改）.**

# ZABBIX_SENDER

章节:用户命令 (1)
更新: 2020-02-29
[索引](https://www.zabbix.com/documentation/5.0/zh/manpages/zabbix_sender#index)[返回主目录](https://www.zabbix.com/documentation/5.0/manpages)

------

 

## 名称

zabbix_sender - Zabbix sender 实用程序 

## 概要

**zabbix_sender** [**-v**] **-z***服务器* [**-p***端口*] [**-I***IP-地址*] **-s***主机***-k***key***-o***value*
**zabbix_sender** [**-v**] **-z***服务器* [**-p***端口*] [**-I***IP地址*] [**-s***主机*] [**-T**] [**-r**] **-i***输入文件*
**zabbix_sender** [**-v**] **-c***配置文件* [**-z***服务器*] [**-p***端口*] [**-I***IP地址*] [**-s***主机*] **-k***key***-o***value*
**zabbix_sender** [**-v**] **-c***配置文件* [**-z***服务器*] [**-p***端口*] [**-I***IP地址*] [**-s***主机*] [**-T**] [**-r**] **-i***输入文件*
**zabbix_sender** [**-v**] **-z***服务器* [**-p***端口*] [**-I***IP地址*] **-s***主机***--tls-connect****cert****--tls-ca-file***CA-file* [**--tls-crl-file***CRL-file*] [**--tls-server-cert-issuer***cert-issuer*] [**--tls-server-cert-subject***cert-subject*] **--tls-cert-file***cert-file***--tls-key-file***key-file***-k***key***-o***value*
**zabbix_sender** [**-v**] **-z***server* [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****cert****--tls-ca-file***CA-file* [**--tls-crl-file***CRL-file*] [**--tls-server-cert-issuer***cert-issuer*] [**--tls-server-cert-subject***cert-subject*] **--tls-cert-file***cert-file***--tls-key-file***key-file* [**-T**] [**-r**] **-i***input-file*
**zabbix_sender** [**-v**] **-c***config-file* [**-z***server*] [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****cert****--tls-ca-file***CA-file* [**--tls-crl-file***CRL-file*] [**--tls-server-cert-issuer***cert-issuer*] [**--tls-server-cert-subject***cert-subject*] **--tls-cert-file***cert-file***--tls-key-file***key-file***-k***key***-o***value*
**zabbix_sender** [**-v**] **-c***config-file* [**-z***server*] [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****cert****--tls-ca-file***CA-file* [**--tls-crl-file***CRL-file*] [**--tls-server-cert-issuer***cert-issuer*] [**--tls-server-cert-subject***cert-subject*] **--tls-cert-file***cert-file***--tls-key-file***key-file* [**-T**] [**-r**] **-i***input-file*
**zabbix_sender** [**-v**] **-z***server* [**-p***port*] [**-I***IP-address*] **-s***host***--tls-connect****psk****--tls-psk-identity***PSK-identity***--tls-psk-file***PSK-file***-k***key***-o***value*
**zabbix_sender** [**-v**] **-z***server* [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****psk****--tls-psk-identity***PSK-identity***--tls-psk-file***PSK-file* [**-T**] [**-r**] **-i***input-file*
**zabbix_sender** [**-v**] **-c***config-file* [**-z***server*] [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****psk****--tls-psk-identity***PSK-identity***--tls-psk-file***PSK-file***-k***key***-o***value*
**zabbix_sender** [**-v**] **-c***config-file* [**-z***server*] [**-p***port*] [**-I***IP-address*] [**-s***host*] **--tls-connect****psk****--tls-psk-identity***PSK-identity***--tls-psk-file***PSK-file* [**-T**] [**-r**] **-i***input-file*
**zabbix_sender -h**
**zabbix_sender -V** 

## 描述

**zabbix_sender** 是一个命令行实用程序，用于将监视数据发送到Zabbix server 或 proxy。在Zabbixserver 上，应使用相应的密钥创建**Zabbix trapper**类型的项目。请注意，此值仅接受来自**允许的主机**字段中指定的主机的值。 

## 选项

- **-c**, **--config** *配置文件*

  使用*config-file*。 **Zabbix sender**从代理配置文件中读取服务器详细信息。默认情况下， **Zabbix sender** 不读取任何配置文件。参数只有**Hostname**，**ServerActive**，**SourceIP**，**TLSConnect**，**TLSCAFile**，**TLSCRLFile**， **TLSServerCertIssuer**，**TLSServerCertSubject**，**TLSCertFile**，**TLSKeyFile**，**TLSPSKIdentity** 和**TLSPSKFile**支持。在agent中定义**ServerActive**的所有地址配置参数用于发送数据。如果批处理数据发送到一个地址失败，则以下批处理不会发送到该地址。

- **-z**, **--zabbix-server** *server*

  Zabbix server的主机名或IP地址。如果主机由代理监视，则应改用代理主机名或IP地址。与**--config**一起使用时，将覆盖代理配置文件中指定的**ServerActive**参数的条目。

- **-p**, **--port** *port*

  指定服务器上运行的Zabbix服务器陷阱程序的端口号。缺省值为10051。与**--config**一起使用时，将覆盖代理配置文件中指定的**ServerActive**参数的端口条目.

- **-I**, **--source-address** *IP-address*

  指定源IP地址。当与一起使用**--config**，覆盖**SourceIP**在agentd配置文件中指定的参数.

- **-s**, **--host** *host*

  指定项目所属的主机名（在Zabbix前端中注册）。主机IP地址和DNS名称将不起作用。与**--config**一起使用时，将覆盖代理配置文件中指定的**Hostname**参数.

- **-k**, **--key** *key*

  指定要发送值的项目键.

- **-o**, **--value** *value*

  指定项目值.

- **-i**, **--input-file** *input-file*

  从输入文件加载值。指定**-** as 从标准输入读取值。文件的每一行包含分隔的空格: 。每个值必须在自己的行中指定。每一行必须包含3个由空格分隔的条目: ，其中**<hostname> <key> <value>**是被监控主机在Zabbix前端注册的名称，“key”是目标项目的key，“value”是要发送的值。指定**-**as 以使用代理配置文件中的 **<hostname>** 或 **--host**参数 输入文件的一行示例:  **"Linux DB3" db.connections 43** 必须在Zabbix前端的项目配置中正确设置值类型。Zabbix发件人将在一个连接中最多发送250个值。输入文件的内容必须采用UTF-8编码。输入文件中的所有值均按自上而下的顺序发送。条目必须使用以下规则设置格式:   • 支持带引号和不带引号的条目. • 双引号是引号字符. • 带有空格的条目必须用引号引起来. • 带引号的条目中的双引号和反斜杠字符必须以反斜杠转义. • 未引用的条目不支持转义. • 带引号的字符串支持换行转义序列（\n）. • 从条目的末尾开始修剪换行符转义序列.

- **-T**, **--with-timestamps**

  此选项只能与**--input-file**选项一起使用。 输入文件的每一行必须包含4个以空格分隔的条目：**<hostname> <key> <timestamp> <value>**。时间戳记应以Unix时间戳记格式指定。如果目标项目具有引用它的触发器，则所有时间戳记必须按升序排列，否则事件计算将不正确. 输入文件的一行示例:  **"Linux DB3" db.connections 1429533600 43** 有关更多详细信息，请参见选项 **--input-file**. 如果为“无数据”维护类型的主机发送带有时间戳的值，则该值将被删除；否则，该值将被删除。但是，可以在过期的维护期内发送带有时间戳的值，并且该值将被接受.

- **-N**, **--with-ns**

  该选项只能与--with-timestamps选项一起使用。 输入文件的每一行必须包含5个以空格分隔的条目：**<hostname> <key> <timestamp> <value>** 输入文件的一行示例:  **"Linux DB3" db.connections 1429533600 7402561 43** 有关更多详细信息，请参见选项 **--input-file**.

- **-r**, **--real-time**

  收到值后立即一一发送。从标准输入读取时可以使用此功能.

- **--tls-connect** *value*

  如何连接到server 或proxy。值:

 

### 

- **unencrypted**

  不加密连接（默认）

- 

  **psk**  c使用TLS和预共享密钥进行连接

- 

  **cert**  使用TLS和证书进行连接

- **--tls-ca-file** *CA-file*

  包含用于对等证书验证的顶级CA证书的文件的完整路径名.

- **--tls-crl-file** *CRL-file*

  包含已撤销证书的文件的完整路径名.

- **--tls-server-cert-issuer** *cert-issuer*

  允许的服务器证书颁发者.

- **--tls-server-cert-subject** *cert-subject*

  允许的服务器证书主题.

- **--tls-cert-file** *cert-file*

  包含证书或证书链的文件的完整路径名.

- **--tls-key-file** *key-file*

  包含私钥的文件的完整路径名.

- **--tls-psk-identity** *PSK-identity*

  PSK身份字符串.

- **--tls-psk-file** *PSK-file*

  包含预共享密钥的文件的完整路径名.

- **--tls-cipher13** *cipher-string*

  OpenSSL 1.1.1或TLS 1.3或更高版本的密码字符串。覆盖默认密码套件选择条件。如果OpenSSL版本低于1.1.1，则此选项不可用.

- **--tls-cipher** *cipher-string*

  GnuTLS优先级字符串（用于TLS 1.2及更高版本）或OpenSSL密码字符串（仅用于TLS 1.2）。覆盖默认密码套件选择条件.

- **-v**, **--verbose**

  详细模式，**-vv**了解更多详细信息.

- **-h**, **--help**

  显示此帮助并退出.

- **-V**, **--version**

  输出版本信息并退出.

 

## 退出状态

如果已发送值并且服务器已成功处理所有值，则退出状态为0。如果发送了数据，但是至少一个值的处理失败，则退出状态为2。如果数据发送失败，则退出状态为1.

 

## 例子

**zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k mysql.queries -o 342.45**

- 

  发送342.45作为受监视主机的mysql.queries项目的值。使用代理配置文件中定义的受监视主机和Zabbix服务器

**zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s "Monitored Host" -k mysql.queries -o 342.45** 

- 

  使用代理配置文件中定义的Zabbix服务器 发送342.45作为“受监视的主机”主机的mysql.queries项目的值.


 **zabbix_sender -z 192.168.1.113 -i data_values.txt**

- 

    将文件data_values.txt中的值发送到IP为192.168.1.113的Zabbix server。主机名和密钥在文件中定义.


 **echo "- hw.serial.number 1287872261 SQ4321ASDF" | zabbix_sender -c /usr/local/etc/zabbix_agentd.conf -T -i -** 

- 

  将带有时间戳的值从命令行发送到代理配置文件中指定的Zabbix服务器。输入数据中的短划线表示还应从同一配置文件中使用主机名.


 **echo '"Zabbix server" trapper.item ""' | zabbix_sender -z 192.168.1.113 -p 10000 -i -** 

- 

  从命令行在端口10000上将空值的项目发送到IP地址为192.168.1.113的Zabbix服务器。空值必须用空双引号表示.

**zabbix_sender -z 192.168.1.113  -s "Monitored Host" -k mysql.queries  -o 342.45 --tls-connect cert --tls-ca-file /home/zabbix/zabbix_ca_file  --tls-cert-file /home/zabbix/zabbix_agentd.crt --tls-key-file  /home/zabbix/zabbix_agentd.key** 

- 

  使用带有证书的TLS 将342.45作为“受监视的主机”主机中mysql.queries项目的值发送到IP为192.168.1.113的服务器

**zabbix_sender -z 192.168.1.113  -s "Monitored Host" -k mysql.queries  -o 342.45 --tls-connect psk --tls-psk-identity "PSK ID Zabbix agentd"  --tls-psk-file /home/zabbix/zabbix_agentd.psk** 

- 

  使用带有预共享密钥（PSK）的TLS 将342.45作为“受监视的主机”主机中mysql.queries项目的值发送到IP为192.168.1.113的服务器.

 

# ZABBIX_SERVER

章节: 维护命令 (8)
更新时间: 2020-09-04
[索引](https://www.zabbix.com/documentation/5.0/zh/manpages/zabbix_server#index)[返回主目录](https://www.zabbix.com/documentation/5.0/manpages)

------

 

## NAME

zabbix_server - Zabbix server 守护程序  

## 概要

**zabbix_server** [**-c***配置文件*] 
**zabbix_server** [**-c***配置文件*] **-R***运行时选项*
**zabbix_server -h**
**zabbix_server -V** 

## 描述

**zabbix_server** 是Zabbix软件的核心守护程序. 

## 选项

- **-c**, **--config** *配置文件*

  使用自定义 *配置文件*而不是默认配置文件.

- **-f**, **--foreground**

  在前台运行 Zabbix serve.

- **-R**, **--runtime-control** *runtime-option*

  根据*runtime-option*执行管理功能.

 

### 

运行时控制选项

- 

  **config_cache_reload**  重新加载配置缓存。忽略当前是否正在加载缓存。默认配置文件（除非指定了-c选项）将用于查找PID文件，并将信号发送到进程，列在PID文件中。

- 

  **snmp_cache_reload**  重新加载SNMP缓存。

- 

  **housekeeper_execute**  执行管家。如果当前正在执行管家，则将其忽略.

- 

  **diaginfo**[=*section*] 记录指定节的内部诊断信息。Section可以是historycache、preprocessing、alerting、lld、valuecache。缺省情况下，记录所有节的诊断信息。

- 

  **log_level_increase**[=*target*] 增加日志级别，如果未指定目标，则影响所有进程

- 

  **log_level_decrease**[=*target*] 降低日志级别，如果未指定目标，则会影响所有进程

 

### 

日志级别控制目标

- 

  *process-type*  指定类型的所有进程（警报器，警报管理器，配置同步器，发现程序，自动扶梯，历史记录同步器，管家，http轮询器，icmp  pinger，ipmi管理器，ipmi轮询器，java轮询器，lld管理器，lld工作者，轮询器，预处理器管理器，预处理工作者，代理轮询器，自我监控，snmp陷阱器，任务管理器，计时器，陷阱器，无法访问的轮询器，vmware收集器）

- 

  *process-type,N*  进程类型和编号(例如，轮询器，3)

- 

  *pid*  进程标识符，最多65535。对于较大的值，将target指定为“process-type,N”

- **-h**, **--help**

  显示此帮助并退出.

- **-V**, **--version**

  输出版本信息并退出.

 

## 档案

- */usr/local/etc/zabbix_server.conf*

  Zabbix server 配置文件的默认位置（如果在编译时未修改）.

 

