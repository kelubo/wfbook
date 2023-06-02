# systemd

[TOC]

## 概述

要管理服务，可以使用 `systemctl` 命令行工具来控制 `systemd` 系统和服务管理器，也可以使用 RHEL web 控制台。

作为系统管理员，您需要与 `systemd` 进行交互，即 Linux 操作系统的系统和服务管理器。`systemd` 软件套件提供控制和报告系统状态的工具和服务，以便在启动期间启动期间初始化您的系统。从 Red Hat Enterprise Linux 7 开始，`systemd` 是 Upstart 作为默认 init 系统的替代，并与 SysV init 脚本向后兼容。`systemd` 软件套件提供很多功能，例如： 	

- ​					系统服务并行启动， 			
- ​					按需激活守护进程， 			
- ​					基于依赖性的服务控制逻辑。 			

## 启用、禁用、屏蔽服务

作为系统管理员，可以启用或禁用要在引导时启动的服务，这些更改将在下次重启时应用。

如果希望服务在引导时自动启动，必须启用此服务。

如果禁用某个服务，它不会在引导时启动，但可以手动启动。

可以屏蔽服务，使其无法手动启动。屏蔽是一种禁用服务的方法，使该服务能够永久不可用，直到再次屏蔽该服务。

1. 在引导时启用服务：

   ```bash
   systemctl enable service_name		
   ```

   还可以使用一个命令启用并启动服务：

   ```bash
   systemctl enable --now service_name
   ```

2. 禁用要在引导时启动的服务：

   ```bash
   systemctl disable service_name
   ```

3. 如果想使服务永久不可用，请屏蔽该服务： 

   ```bash
   systemctl mask service_name
   ```

   如果您有一个屏蔽的服务，取消屏蔽它： 											

   ```bash
   systemctl unmask service_name
   ```



​			

​			作为系统资源和服务表示，`systemd` 引进了 *systemd 单元*的概念。执行或控制特定任务的 systemd 单元是 systemd 管理的基本对象。请参阅以下各种 systemd 单元类型示例： 	

- ​					service, 			
- ​					target, 			
- ​					device, 			
- ​					mount, 			
- ​					timer, 			
- ​					与 init 系统相关的其他类型。 			

注意

​				如果要显示所有可用的单元类型，请使用： 		



```none
 # systemctl -t help
```

​			systemd 单元由一个名称、类型和配置文件组成，该文件定义这个单元的任务。单元配置文件位于下表中列出的目录中之一： 	

表 12.1. systemd 单元文件位置

| 目录                       | 描述                                                         |
| -------------------------- | ------------------------------------------------------------ |
| `/usr/lib/systemd/system/` | 与安装的 RPM 软件包一起分发的 systemd 单元文件。             |
| `/run/systemd/system/`     | 在运行时创建的 systemd 单元文件。该目录优先于安装了的服务单元文件的目录。 |
| `/etc/systemd/system/`     | 由 `systemctl enable` 创建，并为扩展服务作为单元文件添加的 systemd 单元文件。这个目录优先于带有运行时单元文件的目录。 |

​			`systemd` 的默认配置在编译过程中定义，您可以在 `/etc/systemd/system.conf` 文件中找到配置。如果您想与那些默认值分离，并全局覆盖所选的 systemd 单元默认值，请使用这个文件。 	

​			例如，若要覆盖设为 90 秒的超时限制的默认值，可使用 `DefaultTimeoutStartSec` 参数输入所需的值（以秒为单位）。 	



```none
DefaultTimeoutStartSec=required value
```

# 第 13 章 使用 systemctl 管理系统服务

​			作为系统管理员，您要管理系统服务并执行与不同服务相关的不同任务，如启动、停止、重启、启用和禁用服务、列出服务以及显示系统服务状态等。要与 `systemd` 系统和服务管理器交互，请使用 `systemctl` 实用程序。 	

## 13.1. 列出系统服务

​				您可以列出所有当前载入的服务单元，以及所有可用服务单元的状态。 		

**流程**

- ​						要列出所有当前载入的服务单元，请输入： 				

  

  ```none
  $ systemctl list-units --type service
  UNIT                     LOAD   ACTIVE SUB     DESCRIPTION
  abrt-ccpp.service        loaded active exited  Install ABRT coredump hook
  abrt-oops.service        loaded active running ABRT kernel log watcher
  abrtd.service            loaded active running ABRT Automated Bug Reporting Tool
  ----
  systemd-vconsole-setup.service loaded active exited  Setup Virtual Console
  tog-pegasus.service            loaded active running OpenPegasus CIM Server
  
  LOAD   = Reflects whether the unit definition was properly loaded.
  ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
  SUB    = The low-level unit activation state, values depend on unit type.
  
  46 loaded units listed. Pass --all to see loaded but inactive units, too.
  To show all installed unit files use 'systemctl list-unit-files'
  ```

  ​						默认情况下，`systemctl list-units` 命令只显示活跃的单位。对于每个服务单元文件，命令会显示： 				

  - ​								`UNIT` ：其全名 						
  - ​								`LOAD` ：是否单元文件已被载入的信息 						
  - ​								`ACTIVE` 或 `SUB` ：它的高级别和低级单元文件激活状态 						
  - ​								`DESCRIPTION`: 简短描述 						

- ​						要列出 **所有载入的单元，而不管它们的状态** ，请输入以下命令及 `--all` 或 `-a` 命令行选项： 				

  

  ```none
  $ systemctl list-units --type service --all
  ```

- ​						要列出所有可用服务单元的状态（**启用的**或**禁用的**），请输入： 				

  

  ```none
  $ systemctl list-unit-files --type service
  UNIT FILE                               STATE
  abrt-ccpp.service                       enabled
  abrt-oops.service                       enabled
  abrtd.service                           enabled
  ...
  wpa_supplicant.service                  disabled
  ypbind.service                          disabled
  
  208 unit files listed.
  ```

  ​						对于每个服务单元，这个命令会显示： 				

  - ​								`UNIT FILE` ：其全名 						
  - ​								`STATE` ：是否服务单元已启用或禁用的信息 						

**其他资源**

- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				

## 13.2. 显示系统服务状态

​				您可以检查任何服务单元以获取其详细信息，并验证服务的状态是启用还是正在运行。您还可以查看在特定的服务单元之后或之前启动的服务。 		

**流程**

- ​						要显示对应于系统服务的服务单元的详细信息，请输入： 				

  

  ```none
  $ systemctl status <name>.service
  ```

  ​						将 *<name>* 替换为您要检查的服务单元的名称（例如：`gdm`）。 				

  ​						此命令显示所选服务单元的名称，后跟其简短描述，一个或多个在 [可用的服务单元信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#tabl-Managing_Services_with_systemd-Services-Status_managing-system-services-with-systemctl) 中描述的字段（如果其通过 `root` 用户执行），以及最新的日志条目。 				

  表 13.1. 可用的服务单元信息

  | 项         | 描述                                                         |
  | ---------- | ------------------------------------------------------------ |
  | `Loaded`   | 是否载入了服务单元、到这个单元文件的绝对路径，以及是否启用该单位的信息。 |
  | `Active`   | 服务单元是否在运行的信息，后面有一个时间戳。                 |
  | `Main PID` | 对应系统服务的 PID 及其名称。                                |
  | `Status`   | 相关系统服务的额外信息。                                     |
  | `Process`  | 有关相关进程的附加信息。                                     |
  | `CGroup`   | 有关相关的控制组(`cgroups)` 的其他信息。                     |

  例 13.1. 显示服务状态

  ​							GNOME 显示管理器的服务单元名为 `gdm.service`。要确定这个服务单元的当前状态，在 shell 提示下键入以下内容： 					

  

  ```none
  # systemctl status gdm.service
  gdm.service - GNOME Display Manager
     Loaded: loaded (/usr/lib/systemd/system/gdm.service; enabled)
     Active: active (running) since Thu 2013-10-17 17:31:23 CEST; 5min ago
   Main PID: 1029 (gdm)
     CGroup: /system.slice/gdm.service
             ├─1029 /usr/sbin/gdm
             ├─1037 /usr/libexec/gdm-simple-slave --display-id /org/gno...
             └─1047 /usr/bin/Xorg :0 -background none -verbose -auth /r...
  
  Oct 17 17:31:23 localhost systemd[1]: Started GNOME Display Manager.
  ```

- ​						要只验证特定的服务单元是否正在运行，请输入： 				

  

  ```none
  $ systemctl is-active <name>.service
  ```

- ​						要确定是否一个特定的服务单元已启用，请输入： 				

  

  ```none
  $ systemctl is-enabled <name>.service
  ```

  注意

  ​							如果指定的服务单元正在运行或已启用，则 `systemctl is-active` 和 `systemctl is-enabled` 都会返回一个状态为 `0` 的退出状态。 					

- ​						要确定在指定的服务单元之前启动哪些服务，请输入： 				

  

  ```none
  # systemctl list-dependencies --after <name>.service
  ```

  ​						在命令中将 *<name>* 替换为服务的名称。 				

  ​						例如，要查看在 `gdm` 之前启动的服务的列表，请输入： 				

  

  ```none
  # systemctl list-dependencies --after gdm.service
  gdm.service
  ├─dbus.socket
  ├─getty@tty1.service
  ├─livesys.service
  ├─plymouth-quit.service
  ├─system.slice
  ├─systemd-journald.socket
  ├─systemd-user-sessions.service
  └─basic.target
  [output truncated]
  ```

- ​						要确定在指定的服务单元之后排序启动哪些服务，请输入： 				

  

  ```none
  # systemctl list-dependencies --before <name>.service
  ```

  ​						在命令中将 *<name>* 替换为服务的名称。 				

  ​						例如，要查看在 `gdm` 之后要启动的服务的列表，请输入： 				

  

  ```none
  # systemctl list-dependencies --before gdm.service
  gdm.service
  ├─dracut-shutdown.service
  ├─graphical.target
  │ ├─systemd-readahead-done.service
  │ ├─systemd-readahead-done.timer
  │ └─systemd-update-utmp-runlevel.service
  └─shutdown.target
    ├─systemd-reboot.service
    └─final.target
      └─systemd-reboot.service
  ```

**其他资源**

- ​						[列出系统服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#listing-system-services_managing-system-services-with-systemctl) 				

## 13.3. 启动一个系统服务

​				您可以使用 `start` 命令在当前会话中启动系统服务。 		

**先决条件**

- ​						您必须有对该系统的根权限。 				

**流程**

- ​						要启动一个所选的对应于系统服务的服务单元，情以 `root` 用户身份输入以下命令： 				

  

  ```none
  # systemctl start <name>.service
  ```

  ​						将 *<name>* 替换为您要启动的服务单元的名称（例如 `httpd.service`）。 				

  例 13.2. 启动 httpd.service

  ​							Apache HTTP 服务器的服务单元名为 `httpd.service`。要激活这个服务单元并在当前会话中启动 `httpd` 守护进程，请以 `root` 用户身份输入以下命令： 					

  

  ```none
  # systemctl start httpd.service
  ```

  注意

  ​							在 `systemd` 中，服务之间存在正和负的依赖项。启动一个特定的服务可能需要启动一个或多个其他服务（**正依赖项**）或停止一个或多个服务（**负依赖项**）。 					

  ​							当您尝试启动一个新服务时，`systemd` 会自动解析所有依赖项，而不明确通知用户。这意味着，如果您已运行了一个服务，并且您尝试使用负依赖项启动另一个服务，则第一个服务会自动停止。 					

  ​							例如，如果您运行 `postfix` 服务，并且您尝试启动 `sendmail` 服务，则 `systemd` 会首先自动停止 `postfix`，因为这两个服务有冲突，且无法在同一个端口上运行。 					

**其他资源**

- ​						[正和负的服务依赖项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#positive-and-negative-service-dependencies_managing-system-services-with-systemctl) 				
- ​						[启用一个系统服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#enabling-a-system-service_managing-system-services-with-systemctl) 				
- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				

## 13.4. 停止一个系统服务

​				如果要在当前会话中停止系统服务，请使用 `stop` 命令。 		

**先决条件**

- ​						您必须有对该系统的根权限。 				

**流程**

- ​						要停止对应于系统服务的服务单元，请以 `root` 用户身份输入以下命令： 				

  

  ```none
  # systemctl stop <name>.service
  ```

  ​						将 *<name>* 替换为您要停止的服务单元的名称（例如：`bluetooth`）。 				

  例 13.3. 停止 bluetoothd.service

  ​							`bluetoothd` 守护进程的服务单元名为 `bluetooth.service`。要停用这个服务单元，并在当前会话中停止 `bluetoothd` 守护进程，请以 `root` 用户身份输入以下命令： 					

  

  ```none
  # systemctl stop bluetooth.service
  ```

**其他资源**

- ​						[禁用一个系统服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#disabling-a-system-service_managing-system-services-with-systemctl) 				
- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				

## 13.5. 重启一个系统服务

​				您可以使用 `restart` 命令在当前会话中重启系统服务。 		

​				这个流程描述了如何： 		

- ​						在当前会话中停止所选的服务单元，并立即重新启动它 				
- ​						如果相应服务已在运行，仅重启服务单元 				
- ​						重新加载系统服务的配置，而不中断其执行 				

**先决条件**

- ​						您必须有对该系统的根权限。 				

**流程**

- ​						重启与系统服务对应的服务单元： 				

  

  ```none
  # systemctl restart <name>.service
  ```

  ​						将 *<name>* 替换为您要重启的服务单元的名称（例如 `httpd`）。 				

  注意

  ​							如果所选服务单元没有运行，这个命令也会启动它。 					

- ​						或者，只有在对应的服务已在运行时，重启服务单元： 				

  

  ```none
  # systemctl try-restart <name>.service
  ```

- ​						或者，在不中断服务执行的情况下重新载入配置： 				

  

  ```none
  # systemctl reload <name>.service
  ```

  注意

  ​							不支持此功能的系统服务忽略此命令。要重新启动这些服务，请改为使用 `reload-or-restart` 和 `reload-or-try-restart` 命令。 					

  例 13.4. 重新加载 httpd.service

  ​							为了防止用户遇到不必要的错误消息或部分渲染的 Web 页面，Apache HTTP 服务器允许您编辑和重新加载其配置，而无需重新启动它并中断主动处理的请求。要做到这一点，请使用以下命令： 					

  

  ```none
  # systemctl reload httpd.service
  ```

**其他资源**

- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				

## 13.6. 启用一个系统服务

​				您可以将服务配置为在系统引导时自动启动。`enable` 命令读取所选服务单元的 `[Install]` 部分，并创建指向 `/etc/systemd/system/` 目录及其子目录中 `/usr/lib/systemd/system/*name*.service` 文件的合适的符号链接。但是，它不会重写已经存在的链接。 		

**先决条件**

- ​						您必须有对该系统的根权限。 				

**流程**

- ​						配置与系统服务对应的服务单元，在引导时自动启动： 				

  

  ```none
  # systemctl enable <name>.service
  ```

  ​						将 *<name>* 替换为您要启用的服务单元的名称（例如 `httpd`）。 				

- ​						或者，如果您想要确保重新创建符号链接，请重新启用系统单元： 				

  

  ```none
  # systemctl reenable <name>.service
  ```

  ​						该命令禁用所选服务单元，并立即再次启用。 				

  例 13.5. 启用 httpd.service

  ​							要将 Apache HTTP 服务器配置为在引导时自动启动，请使用以下命令： 					

  

  ```none
  # systemctl enable httpd.service
  Created symlink from /etc/systemd/system/multi-user.target.wants/httpd.service to /usr/lib/systemd/system/httpd.service.
  ```

**其他资源**

- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				
- ​						[启动一个系统服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#starting-a-system-service_managing-system-services-with-systemctl) 				

## 13.7. 禁用一个系统服务

​				您可以防止服务单元在引导时自动启动。`disable` 命令读取所选服务单元的 `[Install]` 部分，并从 `etc/systemd/system/` 目录及其子目录中删除到 `/usr/lib/systemd/system/*name*.service` 文件的合适的符号链接。 		

**先决条件**

- ​						您必须有对该系统的根权限。 				

**流程**

- ​						要将对应于系统服务的服务单元配置为在引导时不自动启动，请以 `root` 用户身份输入以下命令： 				

  

  ```none
  # systemctl disable <name>.service
  ```

  ​						将 *<name>* 替换为您要禁用的服务单元的名称（例如：`bluetooth`）。 				

  例 13.6. 禁用 bluetoothd.service

  ​							`bluetoothd` 守护进程的服务单元命名为 `bluetooth.service`。要防止这个服务单元在引导时启动，请以 `root` 用户身份输入以下命令： 					

  

  ```none
  # systemctl disable bluetooth.service
  Removed symlink /etc/systemd/system/bluetooth.target.wants/bluetooth.service.
  Removed symlink /etc/systemd/system/dbus-org.bluez.service.
  ```

- ​						或者，您可以屏蔽任何服务单元，并阻止手动启动或者由其他服务启动： 				

  

  ```none
  # systemctl mask <name>.service
  ```

  ​						这个命令将 `/etc/systemd/system/*name*.service` 文件替换为到 `/dev/null` 的符号链接，从而导致 `systemd` 无法访问实际的单元文件。 				

- ​						要恢复这个动作，并显示一个服务单元，请输入： 				

  

  ```none
  # systemctl unmask <name>.service
  ```

**其他资源**

- ​						[显示系统服务状态](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#displaying-system-service-status_managing-system-services-with-systemctl) 				
- ​						[停止一个系统服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/managing-system-services-with-systemctl_configuring-basic-system-settings#stopping-a-system-service_managing-system-services-with-systemctl) 				

# 第 14 章 使用 systemd 目标

​			`systemd` 中的目标在系统开始期间作为同步点。目标单元文件以 `.target` 文件扩展名结尾，代表 `systemd` 目标。目标单元的目的是通过一组依赖项将各种 `systemd` 单元分组到一起。 	

​			请考虑以下示例： 	

- ​					用于启动图形会话的 `graphical.target 单元` 启动系统服务，如 GNOME 显示管理器(`gdm.service`)或 Accounts Service (`accounts-daemon.service`)，同时还激活 `multi-user.target 单元`。 			
- ​					同样，`multi-user.target` 单元启动其他基本系统服务，如 NetworkManager (`NetworkManager.service`) 或 D-Bus (`dbus.service`)，并激活另一个名为 `basic.target` 的目标单元。 			

​			在使用 `systemd` 目标时，您可以查看默认目标，更改它或更改当前目标。 	

## 14.1. 查看默认对象

​				您可以使用 `systemctl` 命令显示默认目标，或检查 `/etc/systemd/system/default.target` 文件，该文件代表默认目标单元。 		

**流程**

- ​						确定默认使用哪个目标单元： 				

  

  ```none
  $ systemctl get-default
  graphical.target
  ```

- ​						使用符号链接确定默认目标： 				

  

  ```none
  $  ls -l /usr/lib/systemd/system/default.target
  ```

## 14.2. 查看目标单元

​				您可以显示所有单元类型，或将搜索限制为当前载入的目标单元。默认情况下，`systemctl list-units` 命令只显示活跃的单元。 		

**流程**

- ​						列出所有载入的单元，而不考虑它们的状态： 				

  

  ```none
  $ systemctl list-units --type target --all
  ```

- ​						或者，列出所有当前载入的目标单元： 				

  

  ```none
  $ systemctl list-units --type target
  
  UNIT                  LOAD   ACTIVE SUB    DESCRIPTION
  basic.target          loaded active active Basic System
  cryptsetup.target     loaded active active Encrypted Volumes
  getty.target          loaded active active Login Prompts
  graphical.target      loaded active active Graphical Interface
  local-fs-pre.target   loaded active active Local File Systems (Pre)
  local-fs.target       loaded active active Local File Systems
  multi-user.target     loaded active active Multi-User System
  network.target        loaded active active Network
  paths.target          loaded active active Paths
  remote-fs.target      loaded active active Remote File Systems
  sockets.target        loaded active active Sockets
  sound.target          loaded active active Sound Card
  spice-vdagentd.target loaded active active Agent daemon for Spice guests
  swap.target           loaded active active Swap
  sysinit.target        loaded active active System Initialization
  time-sync.target      loaded active active System Time Synchronized
  timers.target         loaded active active Timers
  
  LOAD   = Reflects whether the unit definition was properly loaded.
  ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
  SUB    = The low-level unit activation state, values depend on unit type.
  
  17 loaded units listed.
  ```

## 14.3. 更改默认对象

​				默认目标单元由 `/etc/systemd/system/default.target` 文件表示。以下流程描述了如何使用 systemctl 命令更改默认目标： 		

**流程**

1. ​						要确定默认目标单元： 				

   

   ```none
   # systemctl get-default
   ```

2. ​						将系统配置为默认使用不同的目标单元： 				

   

   ```none
   # systemctl set-default multi-user.target
   rm /etc/systemd/system/default.target
   ln -s /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target
   ```

   ​						这个命令将 `/etc/systemd/system/default.target` 文件替换为指向 `/usr/lib/systemd/system/name.target` 的符号链接，其中 *name* 是您要使用的目标单元的名称。使用您要默认使用的目标单元的名称替换 *multi-user*。 				

   表 14.1. set-default 命令的通用目标

   | 基本的  | 涵盖基本引导的单元目标                           |
   | ------- | ------------------------------------------------ |
   | rescue  | 在基本系统中拉取的单元目标，并生成一个救援 shell |
   | 多用户  | 用于设置多用户系统的单元目标                     |
   | 图形化  | 用于设置图形登录屏幕的单元目标                   |
   | 紧急    | 在主控制台上启动紧急 shell 的单元目标            |
   | sysinit | 在系统初始化所需的服务中拉取的单元目标           |

3. ​						重启 				

   

   ```none
   # reboot
   ```

**其他资源**

- ​						`systemd.special` man page 				
- ​						`bootup` 手册页 				

## 14.4. 使用符号链接更改默认对象

​				您可以通过创建一个到您想要的目标的符号链接来更改默认目标。 		

**流程**

1. ​						确定默认的目标单元： 				

   

   ```none
   #  ls -l /etc/systemd/system/default.target
   ```

   ​						请注意，在某些情况下，`/etc/systemd/system/default.target` 链接可能不存在，systemd 会在 `/usr` 中查找默认的目标单元。在这种情况下，使用以下命令确定默认的目标单元： 				

   

   ```none
   #  ls -l /usr/lib/systemd/system/default.target
   ```

2. ​						删除 `/etc/systemd/system/default.target` 链接： 				

   

   ```none
   # rm /etc/systemd/system/default.target
   ```

3. ​						创建一个符号链接： 				

   

   ```none
   #  ln -sf /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target
   ```

4. ​						重启系统： 				

   

   ```none
   # reboot
   ```

**验证步骤**

- ​						验证新创建的 `default.target`: 				

  

  ```none
  $ systemctl get-default
  multi-user.target
  ```

## 14.5. 更改当前目标

​				当您设置默认目标单元时，当前目标将保持不变，直到下次重启为止。如果要在不重启的情况下更改当前会话中的目标单元，请使用 `systemctl isolate` 命令。 		

**流程**

- ​						在当前会话中切换到不同的目标单元： 				

  

  ```none
  # systemctl isolate multi-user.target
  ```

  ​						这个命令启动名为 *multi-user* 以及所有依赖的单元的目标单元，并立即停止所有其他单元。 				

​				使用您要默认使用的目标单元的名称替换 *multi-user*。 		

**验证步骤**

- ​						验证新创建的 default.target: 				

  

  ```none
  $ systemctl get-default
  multi-user.target
  ```

## 14.6. 引导至救援模式

​				*救援模式*提供了一个方便的单用户环境，它可让您在无法完成常规引导过程时修复您的系统。在救援模式中，系统会尝试挂载所有本地文件系统并启动某些重要的系统服务，但它不会激活网络接口或者同时允许更多的用户登录到该系统。 		

**流程**

- ​						要进入救援模式，在当前会话中更改当前目标： 				

  

  ```none
  # systemctl rescue
  
  Broadcast message from root@localhost on pts/0 (Fri 2013-10-25 18:23:15 CEST):
  
  The system is going down to rescue mode NOW!
  ```

  注意

  ​							这个命令与 `systemctl isolate rescue.target` 类似，但它也会向当前登录到该系统的所有用户发送信息性消息。 					

  ​							要防止 `systemd` 发送信息，使用 `--no-wall` 命令行选项运行以下命令： 					

  

  ```none
  # systemctl --no-wall rescue
  ```

## 14.7. 引导至紧急模式

​				*紧急模式* 提供最小的环境，并可在系统无法进入救援模式的情况下修复您的系统。在紧急模式下，系统仅挂载用于读取的 root 文件系统，不会尝试挂载任何其他本地文件系统，不激活网络接口，并且仅启动几个必要的服务。 		

**流程**

- ​						要进入紧急模式，请更改当前目标： 				

  

  ```none
  # systemctl emergency
  ```

  注意

  ​							这个命令与 `systemctl isolate emergency.target` 类似，但它也会向当前登录到系统的所有用户发送信息性消息。 					

  ​							要防止 systemd 发送这个信息，使用 `--no-wall` 命令行选项运行以下命令： 					

  

  ```none
  # systemctl --no-wall emergency
  ```

# 第 16 章 使用 systemd 单元文件

​			本章包括 **systemd** 单元文件的描述。以下部分介绍了如何进行： 	

- ​					创建自定义单元文件 			
- ​					将 SysV init 脚本转换为单元文件 			
- ​					修改现有单元文件 			
- ​					使用实例化单元 			

## 16.1. 单元文件简介

​				单元文件包含描述这个单元并定义其行为的配置指令。几个 `systemctl` 命令可在后台使用单元文件。要进行更细的调整，系统管理员必须手动编辑或创建单元文件。[systemd 单元文件位置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/introduction-to-systemd_configuring-basic-system-settings) 列出了系统上存储单元文件的三个主目录，`/etc/systemd/system/` 目录为系统管理员创建或自定义的单元文件保留。 		

​				单元文件名的格式如下： 		



```none
unit_name.type_extension
```

​				这里的 *unit_name* 代表单元名称，*type_extension* 标识单元类型。有关单元类型的完整列表，请参阅 [systemd 单元文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/introduction-to-systemd_configuring-basic-system-settings#ref_systemd-unit-types_introduction-to-systemd) 		

​				例如，系统通常会有 `sshd.service` 和 `sshd.socket` 单元。 		

​				可通过一个目录来补充单元文件，以了解额外的配置文件。例如，要将自定义配置选项添加到 `sshd.service` 中，请创建 `sshd.service.d/custom.conf` 文件，并在其中插入额外的指令：有关配置目录的更多信息，请参阅 [修改现有的单元文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_modifying-existing-unit-files_assembly_working-with-systemd-unit-files)。 		

​				另外, `sshd.service.wants/` 和 `sshd.service.requires/` 目录可以被创建。这些目录包含到 `sshd` 服务依赖的单元文件的符号链接。符号链接会在安装过程中根据 [Install] 单元文件选项自动创建，或者根据 [Unit] 选项在运行时自动创建。也可以手动创建这些目录和符号链接。有关 [Install] 和 [Unit] 选项的详情请参考下表。 		

​				可以使用所谓的 **单元指定符** 来设置许多单元文件选项 - 在加载单元文件时，通配符字符串被动态地替换为单元参数。这可创建通用单元文件，来用作生成实例化单元的模板。请参阅 [使用实例化单元](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#con_working-with-instantiated-units_assembly_working-with-systemd-unit-files)。 		

## 16.2. 单元文件结构

​				单元文件通常由三个部分组成： 		

- ​						`[Unit]` 部分 - 包含不依赖于该单元类型的通用选项。这些选项提供了单元描述，指定了单元的行为，并设置了其他单元的依赖项。有关最常用的 [Unit] 选项的列表，请参阅 [重要 [单元\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#tabl-systemd-Unit_Sec_Options)。 				
- ​						`[Unit type]` 部分 - 如果单元具有特定于类型的指令，则这些指令分组在以单元类型命名的部分下。例如，服务单元文件包含 `[Service]` 部分。 				
- ​						`[Install]` 部分 - 包含 `systemctl enable` 和 `disable` 命令使用的单元安装信息。有关 `[Install]` 部分的选项列表，请参阅 [重要 [Install\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#tabl-systemd-Install_Sec_Options)。 				

**其他资源**

- ​						[重要 [Unit\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#ref_important-unit-section-options_assembly_working-with-systemd-unit-files) 				
- ​						[重要 [Service\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#ref_important-service-section-options_assembly_working-with-systemd-unit-files) 				
- ​						[重要 [Install\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#ref_important-install-section-options_assembly_working-with-systemd-unit-files) 				

## 16.3. 重要 [Unit] 部分选项

​				下表列出了 [Unit] 部分的重要选项。 		

表 16.1. 重要 [Unit] 部分选项

| 选项 [[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#ftn.idm140630196342736) | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `描述`                                                       | 单元的有意义的描述。这个文本显示在 `systemctl status` 命令的输出中。 |
| `Documentation`                                              | 提供单元参考文档的 URI 列表。                                |
| `之后`[[b\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#ftn.idm140630196261984) | 定义启动单位的顺序。这个单元仅在 `After` 中指定的单元处于活跃状态后才启动。与 `Requires` 不同，`After` 不会显式激活指定的单元。`Before` 选项与 `After` 的功能相反。 |
| `Requires`                                                   | 配置其它单元上的依赖关系。`Requires` 中列出的单元与单元一同被激活。如果任何需要的单元无法启动，则该单位就不会被激活。 |
| `期望`                                                       | 配置比 `Requires` 更弱的依赖项。如果列出的单元没有成功启动，它对单元激活不会有影响。这是建立自定义单元依赖项的建议方法。 |
| `Conflicts`                                                  | 配置负的依赖关系，与 `Requires` 相反。                       |
| [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#idm140630196342736) 							有关 [Unit] 部分中可配置的选项的完整列表，请查看 `systemd.unit(5)` 手册页。 						[[b\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#idm140630196261984) 								在大多数情况下，只需要`After` 和 `Before` 单元文件选项设置顺序依赖关系就足够了。如果还使用 `Wants`（推荐）或 `Requires`设置了需要的依赖关系，仍需要指定依赖关系顺序。这是因为排序和要求依赖关系可以独立地工作。 |                                                              |

## 16.4. 重要 [Service] 部分选项

​				下表列出了 [Service] 部分的重要选项。 		

表 16.2. 重要 [Service] 部分选项

| 选项 [[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#ftn.idm140630199459392) | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Type`                                                       | 配置影响 `ExecStart` 功能的单元进程启动类型和相关选项。其中之一： 						 						  							* `simple` - 默认值。使用 `ExecStart` 启动的进程是该服务的主要进程。 						 						  							* `forking` - 使用 `ExecStart` 启动的进程生成一个成为服务主进程的子进程，。父进程在启动完成后会退出。 						 						  							* `oneshot` – 这个类型与 `simple` 类似，但在启动相应单位前会退出。 						 						  							* `dbus` - 这个类型与 `simple` 类似，但后续单元仅在主进程获得 D-Bus 名称后启动。 						 						  							* `notify` - 此类型与 `simple` 类似，但只有在通过 sd_notify（）函数发送通知消息后，后续单元才启动。 						 						  							* `idle` - 与 `simple` 类似，服务二进制文件的实际执行会延迟，直到所有作业都完成，这避免了将状态输出与服务的 shell 输出混在一起。 |
| `ExecStart`                                                  | 指定在启动该单元时要执行的命令或脚本。`ExecStartPre` 和 `ExecStartPost` 指定在 `ExecStartPtart` 之前和之后要执行的自定义命令。`Type=oneshot` 启用指定可按顺序执行的多个自定义命令。 |
| `ExecStop`                                                   | 指定在该单元停止时要执行的命令或脚本。                       |
| `ExecReload`                                                 | 指定重新载入该单元时要执行的命令或脚本。                     |
| `Restart`                                                    | 启用此选项后，服务会在进程退出后重新启动，但 `systemctl` 命令的完全停止除外。 |
| `RemainAfterExit`                                            | 如果设置为 True，即使所有进程都退出了，该服务也被视为活动状态。默认值为 False。这个选项在配置了 `Type=oneshot` 时特别有用。 |
| [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#idm140630199459392) 							有关 [Service] 部分中可配置的选项的完整列表，请参阅 `systemd.service(5)` 手册页。 |                                                              |

## 16.5. 重要 [Install] 部分选项

​				下表列出了 [Install] 部分的重要选项。 		

表 16.3. 重要 [Install] 部分选项

| 选项 [[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#ftn.idm140630197565792) | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Alias`                                                      | 为这个单元提供空格分开的额外名称列表。除 `systemctl enable` 以外，多数`systemctl` 命令可使用别名而不是实际的单元名称。 |
| `RequiredBy`                                                 | 依赖于这个单元的单元列表。当启用此单元时，在 `RequiredBy` 中列出的单元会获得对这个单元的一个 `Require` 依赖项。 |
| `WantedBy`                                                   | 依赖于这个单元的单位列表。当启用这个单元时，在 `WantedBy` 中列出的单元会得到一个 `Want` 依赖项。 |
| `Also`                                                       | 指定要随这个单元一起安装或卸载的单元列表。                   |
| `DefaultInstance`                                            | 仅限于实例化单元，这个选项指定启用单位的默认实例。请参阅 [使用实例化单元](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#con_working-with-instantiated-units_assembly_working-with-systemd-unit-files)。 |
| [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#idm140630197565792) 							有关 [Install] 部分中可配置的选项的完整列表，请查看 `systemd.unit(5)` 手册页。 |                                                              |

## 16.6. 创建自定义单元文件

​				从头开始创建单元文件有几个用例：您可以运行一个自定义的守护进程，创建现有服务的第二个实例，如 [如使用 sshd 服务的第二个实例来创建一个自定义单元文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_creating-a-custom-unit-file-by-using-the-second-instance-of-the-sshd-service_assembly_working-with-systemd-unit-files) 中所述 		

​				另一方面，如果您只想修改或扩展现有单元的行为，请使用 [修改单元文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_modifying-existing-unit-files_assembly_working-with-systemd-unit-files) 中的说明。 		

**流程**

​					以下流程描述了创建自定义服务的一般过程： 			

1. ​						使用自定义服务准备可执行文件。这可以是自定义创建的脚本，也可以是软件供应商提供的可执行文件。如果需要，准备 PID 文件来保存自定义服务主要进程的恒定 PID。也可以包含环境文件来存储该服务的 shell 变量。确保源脚本是可执行的（通过执行 `chmod a+x`）且不是交互的。 				

2. ​						在 `/etc/systemd/system/` 目录中创建一个单元文件，并确定它有正确的文件权限。以 `root` 用户身份执行： 				

   

   ```none
   touch /etc/systemd/system/name.service
   
   chmod 664 /etc/systemd/system/name.service
   ```

   ​						使用要创建的服务的名称替换 *name*。请注意，该文件不需要可执行。 				

3. ​						打开上一步中创建的 `*name*.service` 文件并添加服务配置选项。根据您要创建的服务类型，有多种选项可以使用，请查看 [单元文件结构](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#con_unit-file-structure_assembly_working-with-systemd-unit-files)。 				

   ​						以下是网络相关服务的单元配置示例： 				

   

   ```none
   [Unit]
   Description=service_description
   After=network.target
   
   [Service]
   ExecStart=path_to_executable
   Type=forking
   PIDFile=path_to_pidfile
   
   [Install]
   WantedBy=default.target
   ```

   ​						其中： 				

   - ​								*service_description* 是一个信息性描述，显示在 journal 日志文件和 `systemctl status` 命令的输出中。 						
   - ​								`After` 设置确保服务仅在网络运行后启动。添加一个空格分隔的其他相关服务或目标的列表。 						
   - ​								*path_to_executable* 代表到实际可执行服务的路径。 						
   - ​								`Type=forking` 用于进行 fork 系统调用的守护进程。该服务的主要进程使用 *path_to_pidfile* 中指定的 PID 创建。在 [重要 [Service\] 部分选项](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_basic_system_settings/index#tabl-systemd-Service_Sec_Options)中查找其他启动类型。 						
   - ​								`WantedBy` 指出服务应在其下启动的目标。将这些目标视为旧的运行级别概念的替代品。 						

4. ​						以 `root` 用户身份执行以下命令来通知 **systemd** 是否存在一个新 的`*name*.service` 文件： 				

   

   ```none
   systemctl daemon-reload
   
   systemctl start name.service
   ```

   警告

   ​							在创建新单元文件或修改现有单元文件后，总是要运行 `systemctl daemon-reload` 命令。否则，`systemctl start` 或 `systemctl enable` 命令可能会因为 **systemd** 和磁盘上的实际服务单元文件的状态不匹配而失败。请注意，对于有大量单元的系统来说，这需要很长时间，因为每个单元的状态必须在重新载入的过程中被序列化，然后再进行反序列化。 					

## 16.7. 使用 sshd 服务的第二个实例创建一个自定义单元文件

​				系统管理员通常需要配置并运行多个服务实例。这可以通过创建原始服务配置文件的副本并修改某些参数来避免与服务的主实例冲突。以下流程演示了如何创建 `sshd` 服务第二个实例。 		

**流程**

1. ​						创建第二个守护进程将使用的 `sshd_config` 文件副本： 				

   

   ```none
   # cp /etc/ssh/sshd{,-second}_config
   ```

2. ​						编辑上一步中创建的 `sshd-second_config` 文件，为第二个守护进程分配不同的端口号和 PID 文件： 				

   

   ```none
   Port 22220
   PidFile /var/run/sshd-second.pid
   ```

   ​						有关 `Port` 和 `PidFile` 选项的详情，请查看 `sshd_config`(5)手册页。请确定您选择的端口没有被其他服务使用。在运行该服务前，PID 文件不一定存在，它会在服务启动时自动生成。 				

3. ​						为 `sshd` 服务创建 systemd 单元文件副本： 				

   

   ```none
   # cp /usr/lib/systemd/system/sshd.service /etc/systemd/system/sshd-second.service
   ```

4. ​						按如下方式更改上一步中创建的 `sshd-second.service`: 				

   1. ​								修改 `Description` 选项： 						

      

      ```none
      Description=OpenSSH server second instance daemon
      ```

   2. ​								将 sshd.service 添加到 `After` 选项中指定的服务，因此第二实例仅在第一个实例启动后启动： 						

      

      ```none
      After=syslog.target network.target auditd.service sshd.service
      ```

   3. ​								sshd 的第一个实例包括密钥生成，因此删除 **ExecStartPre=/usr/sbin/sshd-keygen** 行。 						

   4. ​								为 `sshd` 命令添加 `-f /etc/ssh/sshd-second_config` 参数，以便使用其它配置文件： 						

      

      ```none
      ExecStart=/usr/sbin/sshd -D -f /etc/ssh/sshd-second_config $OPTIONS
      ```

   5. ​								在进行以上修改后，sshd-second.service 应该如下所示： 						

      

      ```none
      [Unit]
      Description=OpenSSH server second instance daemon
      After=syslog.target network.target auditd.service sshd.service
      
      [Service]
      EnvironmentFile=/etc/sysconfig/sshd
      ExecStart=/usr/sbin/sshd -D -f /etc/ssh/sshd-second_config $OPTIONS
      ExecReload=/bin/kill -HUP $MAINPID
      KillMode=process
      Restart=on-failure
      RestartSec=42s
      
      [Install]
      WantedBy=multi-user.target
      ```

5. ​						如果使用 SELinux，请将第二个 sshd 实例的端口添加到 SSH 端口中，否则 sshd 的第二个实例将被拒绝绑定到端口： 				

   

   ```none
   # semanage port -a -t ssh_port_t -p tcp 22220
   ```

6. ​						启用 sshd-second.service，以便在引导时自动启动： 				

   

   ```none
   # systemctl enable sshd-second.service
   ```

7. ​						使用 `systemctl status` 命令验证 sshd-second.service 是否在运行。 				

8. ​						通过连接到该服务来验证是否正确启用了端口： 				

   

   ```none
   $ ssh -p 22220 user@server
   ```

   ​						如果使用防火墙，请确定正确配置了防火墙以便允许到第二个 sshd 实例的连接。 				

## 16.8. 将 SysV init 脚本转换为单元文件

​				在将 SysV init 脚本转换为单元文件前，请确保在其它位置还没有进行相关的转换。Red Hat Enterprise Linux 中安装的所有核心服务都带有默认的单元文件，很多第三方软件包也是如此。 		

​				 将初始化脚本转换成单元文件需要分析脚本并从中提取所需信息。基于这个数据，您可以创建一个单元文件。因为初始化脚本可能会随服务类型有很大的变化，因此您可能需要使用比本章中所介绍的更多的配置选项来进行转换。请注意，systemd 单元不再支持 init 脚本提供某种级别的定制。 		

​				转换所需要的大多数信息都会在脚本的标头中提供。以下示例显示了在 Red Hat Enterprise Linux 6 中启动 `postfix` 服务初始化脚本的打开部分： 		



```none
#!/bin/bash
# postfix      Postfix Mail Transfer Agent
# chkconfig: 2345 80 30
# description: Postfix is a Mail Transport Agent, which is the program that moves mail from one machine to another.
# processname: master
# pidfile: /var/spool/postfix/pid/master.pid
# config: /etc/postfix/main.cf
# config: /etc/postfix/master.cf
### BEGIN INIT INFO
# Provides: postfix MTA
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop postfix
# Description: Postfix is a Mail Transport Agent, which is the program that moves mail from one machine to another.
### END INIT INFO
```

​				在上面的例子中,只有以 **# chkconfig** 和 **# description** 开头的行是强制的，因此您可能不会在不同的 init 文件中找到其他行。**BEGIN INIT INFO**  和 **END INIT INFO** 行之间连接的文本名为 **Linux Standard Base (LSB) header**。如果指定了，LSB 标头包含定义服务描述、依赖项和默认运行级别的指令。下面是一个分析任务概述，旨在收集新单元文件所需的数据。postfix 初始化脚本被用作一个示例。 		

## 16.9. 查找 systemd 服务描述

​				您可以在以 **#description** 开头的行中找到有关脚本的描述性信息。将此描述与单元文件的 [Unit] 部分中的 `Description` 选项中的服务名称一同使用。LSB 标头可能在 **#Short-Description** 和 **#Description** 行中包含类似的数据。 		

## 16.10. 查找 systemd 服务的依赖项

​				LSB 标头可能包含一些在服务间组成相依性指令。大多数可以转换为 systemd 单元选项，请查看下表： 		

表 16.4. LSB 标头中的依赖项选项

| LSB 选项                       | 描述                                                         | 单元文件的对等    |
| ------------------------------ | ------------------------------------------------------------ | ----------------- |
| `Provides`                     | 指定服务的引导工具名称，可在其他初始化脚本中引用（使用"$"前缀）。因为单元文件根据文件名指向其他单元，所以不再需要这个操作。 | –                 |
| `Required-Start`               | 包含所需服务的引导工具名称。这被转换为一个排序依赖关系，引导工具名被替换为其所属的相应服务或目标的单元文件名。例如，如果是 `postfix`，$network 上的 Required-Start 依赖关系被转换为 network.target 上的 After 依赖关系。 | `After`, `Before` |
| `Should-Start`                 | 比 Required-Start 更弱的依赖项。Should-Start 依赖项失败不会影响服务的启动。 | `After`, `Before` |
| `required-Stop`, `Should-Stop` | 组成负依赖关系。                                             | `Conflicts`       |

## 16.11. 查找服务的默认目标

​				以 **#chkconfig** 开始的行包含三个数字值。最重要的是第一个代表启动该服务的默认运行级别的数字。将这些运行级别映射到等同的 systemd 目标。然后在单元文件的 [Install] 部分中的 `WantedBy` 选项中列出这些目标。例如： `postfix` 之前在运行级别 2、3、4 和 5 中启动，它们转换为 multi-user.target 和  graphical.target。请注意，graphical.target 依赖于  multiuser.target，因此不需要指定它们。您可能会在 LSB 标头的 **#Default-Start** 和 **#Default-Stop** 行中找到默认和禁用运行级别的信息。 		

​				**#chkconfig** 行里指定的其他两个值代表初始化脚本的启动和关闭优先级。如果 systemd 加载了初始化脚本，则这些值由 **systemd** 解释，但没有等效的单元文件。 		

## 16.12. 查找该服务使用的文件

​				初始化脚本需要从专用目录中载入功能库，并允许导入配置、环境和 PID 文件。环境变量在初始化脚本标头中以 **#config** 开头的行中指定，它转换为 `EnvironmentFile` 单元文件选项。**#pidfile** 初始化脚本行中指定的 PID 文件使用 `PIDFile` 选项导入到单元文件中。 		

​				未包含在初始化脚本标头中的关键信息是该服务可执行文件的路径，以及该服务可能需要的一些其他文件。在以前的 Red Hat Enterprise Linux 版本中，init 脚本使用 Bash case 语句定义默认操作的服务行为，如 **start**, **stop**, 或 **restart**，以及自定义的操作。以下来自 `postfix` init 脚本的摘录显示了在服务启动时要执行的代码块。 		

```none
conf_check() {
    [ -x /usr/sbin/postfix ] || exit 5
    [ -d /etc/postfix ] || exit 6
    [ -d /var/spool/postfix ] || exit 5
}

make_aliasesdb() {
	if [ "$(/usr/sbin/postconf -h alias_database)" == "hash:/etc/aliases" ]
	then
		# /etc/aliases.db might be used by other MTA, make sure nothing
		# has touched it since our last newaliases call
		[ /etc/aliases -nt /etc/aliases.db ] ||
			[ "$ALIASESDB_STAMP" -nt /etc/aliases.db ] ||
			[ "$ALIASESDB_STAMP" -ot /etc/aliases.db ] || return
		/usr/bin/newaliases
		touch -r /etc/aliases.db "$ALIASESDB_STAMP"
	else
		/usr/bin/newaliases
	fi
}

start() {
	[ "$EUID" != "0" ] && exit 4
	# Check that networking is up.
	[ ${NETWORKING} = "no" ] && exit 1
	conf_check
	# Start daemons.
	echo -n $"Starting postfix: "
	make_aliasesdb >/dev/null 2>&1
	[ -x $CHROOT_UPDATE ] && $CHROOT_UPDATE
	/usr/sbin/postfix start 2>/dev/null 1>&2 && success || failure $"$prog start"
	RETVAL=$?
	[ $RETVAL -eq 0 ] && touch $lockfile
        echo
	return $RETVAL
}
```

​				初始化脚本的可扩展性允许指定两个自定义函数，`start()` 函数块调用的 `conf_check()` 和 `make_aliasesdb()`。然后,上面的代码中提到几个外部文件和目录：主服务可执行文件 `/usr/sbin/postfix`、`/etc/postfix/` 和 `/var/spool/postfix/` 配置目录，以及 `/usr/sbin/postconf/` 目录。 		

​				**systemd** 只支持预定义的操作，但可以执行带有 `ExecStart`、`ExecStartPre`、`ExecStartPost`、`ExecStop` 和 `ExecReload` 选项的自定义的可执行文件。在 service start 中执行 `/usr/sbin/postfix` 以及支持脚本。转换复杂的初始化脚本需要了解脚本中每个语句的用途。其中一些语句特定于操作系统版本，因此您不需要转换它们。另一方面，在新环境中可能需要在单元文件、以及服务可执行文件和支持文件中进行一些调整，。 		

## 16.13. 修改现有单元文件

​				在系统中安装的服务会附带保存在 `/usr/lib/systemd/system/` 目录中的默认单元文件。系统管理员不应该直接修改这些文件，因此任何自定义都必须仅限于 `/etc/systemd/system/` 目录中的配置文件。 		

**流程**

1. ​						根据所需更改的程度，选择以下方法之一： 				

   - ​								在 `/etc/systemd/system/*unit*.d/` 中创建一个附加配置文件的目录。我们推荐在大多数用例中使用这个方法。它启用了额外的功能来扩展默认配置，同时仍然引用原始的单元文件。因此，软件包升级引入的默认单元的更改会被自动应用。如需更多信息，请参阅 [扩展默认的单元配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_extending-the-default-unit-configuration_assembly_working-with-systemd-unit-files)。 						
   - ​								在 `/etc/systemd/system/` 中创建原始单元文件 `/usr/lib/systemd/system/` 的副本并在此进行修改。这个副本会覆盖原始文件，因此不会应用软件包更新带来的更改。这个方法对无论软件包更新都应保留的重要单元更改都很有用。详情请参阅 [覆盖默认的单元配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_overriding-the-default-unit-configuration_assembly_working-with-systemd-unit-files)。 						

2. ​						要返回单元的默认配置，请删除 `/etc/systemd/system/` 中自定义的配置文件。 				

3. ​						要在不重启系统的情况下对单元文件应用更改，请执行： 				

   

   ```none
   systemctl daemon-reload
   ```

   ​						`daemon-reload` 选项重新加载所有单元文件，并重新创建依赖项树，这需要立即将任何更改应用到单元文件中。另外，您可以使用以下命令得到同样的结果，该命令必须以 `root` 用户执行： 				

   

   ```none
   init q
   ```

4. ​						如果修改后的单元文件属于一个正在运行的服务，则该服务必须重启才能接受新设置： 				

   

   ```none
   systemctl restart name.service
   ```

重要

​					要修改由 SysV initscript 处理的服务（如依赖项或超时）的属性，请不要修改 initscript 本身。反之，为服务创建一个 `systemd` 置入配置文件，如下所述：[扩展默认单元配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_extending-the-default-unit-configuration_assembly_working-with-systemd-unit-files) 和 [覆盖默认单元配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_overriding-the-default-unit-configuration_assembly_working-with-systemd-unit-files)。 			

​					然后，像普通 `systemd` 服务一样管理该服务。 			

​					例如：要扩展 `network` 服务的配置，不要修改 `/etc/rc.d/init.d/network` initscript 文件。反之，创建新目录 `/etc/systemd/system/network.service.d/` 和一个 `systemd` drop-in 文件 `/etc/systemd/system/network.service.d/*my_config*.conf`。然后将修改的值放到 drop-in 文件中。注： `systemd` 知道 `network` 服务为 `network.service`，这就是为什么创建的目录必须名为 `network.service.d` 			

## 16.14. 扩展默认单元配置

​				这部分描述了如何使用额外的配置选项扩展默认的单元文件。 		

**流程**

1. ​						要使用额外的配置选项扩展默认的单元文件，请首先在 `/etc/systemd/system/` 中创建一个配置目录。如果扩展服务单元，以 `root` 用户身份执行以下命令： 				

   

   ```none
   mkdir /etc/systemd/system/name.service.d/
   ```

   ​						使用您要扩展的服务的名称替换 *name*。以上语法适用于所有单元类型。 				

2. ​						在上一步中创建的目录中创建配置文件。请注意，文件名必须以 **.conf** 后缀结尾。类型： 				

   

   ```none
   touch /etc/systemd/system/name.service.d/config_name.conf
   ```

   ​						使用配置文件的名称替换 *config_name*。此文件遵循通常的单元文件结构，因此必须在合适的部分中指定所有的指令，请参阅 [单元文件结构](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#con_unit-file-structure_assembly_working-with-systemd-unit-files)。 				

   ​						例如，要添加自定义依赖项，请使用以下内容创建配置文件： 				

   

   ```none
   [Unit]
   Requires=new_dependency
   After=new_dependency
   ```

   ​						这里的 *new_dependency* 代表这个单元被标记为依赖项。另一个例子是主进程退出后重新启动服务的配置文件，延迟 30 秒： 				

   

   ```none
   [Service]
   Restart=always
   RestartSec=30
   ```

   ​						建议您创建仅关注一项任务的小配置文件。这些文件可轻松地移动或者链接到其他服务的配置目录。 				

3. ​						要应用对单位所做的更改，以 `root` 用户身份执行： 				

   

   ```none
   systemctl daemon-reload
   systemctl restart name.service
   ```

例 16.1. 扩展 httpd.service 配置

​					要修改 httpd.service 单元，以便在启动 Apache 服务时自动执行自定义 shell 脚本，请执行以下步骤。 			

1. ​							创建目录和自定义配置文件： 					

   

   ```none
   # mkdir /etc/systemd/system/httpd.service.d/
   ```

   

   ```none
   # touch /etc/systemd/system/httpd.service.d/custom_script.conf
   ```

2. ​							如果想要用 Apache 自动启动的脚本位于 `/usr/local/bin/custom.sh`，在 `custom_script.conf` 文件中插入以下文本： 					

   

   ```none
   [Service]
   ExecStartPost=/usr/local/bin/custom.sh
   ```

3. ​							要应用单元更改，请执行： 					

   

   ```none
   # systemctl daemon-reload
   ```

   

   ```none
   # systemctl restart httpd.service
   ```

注意

​					`/etc/systemd/system/` 配置文件中的配置文件优先于 `/usr/lib/systemd/system/` 中的单元文件。因此，如果配置文件包含一个只能指定一次的选项，如 `Description` 或 `ExecStart`，则此选项的默认值可被覆盖。请注意，在 `systemd-delta` 命令的输出中，如 [监控覆盖单元](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#proc_monitoring-overriden-units_assembly_working-with-systemd-unit-files) 中所述，这些单元总是被标记为 [EXTENDED]，即使在总和中，某些选项实际上也会被覆盖。 			

## 16.15. 覆盖默认单元配置

​				这部分描述了如何覆盖默认的单元配置。 		

**流程**

1. ​						要在更新提供该单元文件的软件包后保留更改，首先要将该文件复制到 `/etc/systemd/system/` 目录。要做到这一点，以 `root` 用户身份执行以下命令： 				

   

   ```none
   cp /usr/lib/systemd/system/name.service /etc/systemd/system/name.service
   ```

   ​						其中 *name* 代表您希望修改的服务单元的名称。以上语法适用于所有单元类型。 				

2. ​						使用文本编辑器打开复制的文件，并进行必要的修改。要应用单元更改，以 `root` 用户身份执行： 				

   

   ```none
   systemctl daemon-reload
   systemctl restart name.service
   ```

## 16.16. 更改超时限制

​				您可以为每个服务指定一个超时值，以防止出现故障的服务中断。否则，一般服务的超时时间会被默认设置为 90 秒，SysV 兼容的服务会被设置为 300 秒。 		

​				例如：要为 `httpd` 服务扩展超时限制： 		

**流程**

1. ​						将 `httpd` 单元文件复制到 `/etc/systemd/system/` 目录中： 				

   

   ```none
   cp /usr/lib/systemd/system/httpd.service /etc/systemd/system/httpd.service
   ```

2. ​						打开文件 `/etc/systemd/system/httpd.service`，并在 `[Service]` 部分指定 `TimeoutStartUSec` 值: 				

   

   ```none
   …
   [Service]
   …
   PrivateTmp=true
   TimeoutStartSec=10
   
   [Install]
   WantedBy=multi-user.target
   …
   ```

3. ​						重新载入 `systemd` 守护进程： 				

   

   ```none
   systemctl daemon-reload
   ```

4. ​						**Optional.**验证新的超时值： 				

   

   ```none
   systemctl show httpd -p TimeoutStartUSec
   ```

   注意

   ​							要全局更改超时限制，在`/etc/systemd/system.conf` 中输入 `DefaultTimeoutStartSec`。 					

## 16.17. 监控覆盖的单元

​				这部分描述了如何显示覆盖或修改的单元文件的概述。 		

**流程**

- ​						要显示覆盖或修改的单元文件概述，请使用以下命令： 				

  

  ```none
  systemd-delta
  ```

  ​						例如，以上命令的输出结果如下： 				

  

  ```none
  [EQUIVALENT] /etc/systemd/system/default.target → /usr/lib/systemd/system/default.target
  [OVERRIDDEN] /etc/systemd/system/autofs.service → /usr/lib/systemd/system/autofs.service
  
  --- /usr/lib/systemd/system/autofs.service      2014-10-16 21:30:39.000000000 -0400
  + /etc/systemd/system/autofs.service  2014-11-21 10:00:58.513568275 -0500
  @@ -8,7 +8,8 @@
   EnvironmentFile=-/etc/sysconfig/autofs
   ExecStart=/usr/sbin/automount $OPTIONS --pid-file /run/autofs.pid
   ExecReload=/usr/bin/kill -HUP $MAINPID
  -TimeoutSec=180
  +TimeoutSec=240
  +Restart=Always
  
   [Install]
   WantedBy=multi-user.target
  
  [MASKED]     /etc/systemd/system/cups.service → /usr/lib/systemd/system/cups.service
  [EXTENDED]   /usr/lib/systemd/system/sssd.service → /etc/systemd/system/sssd.service.d/journal.conf
  
  4 overridden configuration files found.
  ```

## 16.18. 使用实例化单元

​				可以在运行时使用单一模板配置文件实例化多个单元。"@"字符用于标记模板并与其关联。实例化的单元可以从另一个单元文件（使用 `Requires` 或者 `Wants` 选项）或者 `systemctl start 命令启动`。以下列方式命名实例化服务单元： 		



```none
template_name@instance_name.service
```

​				其中 *template_name* 代表模板配置文件的名称。将 *instance_name* 替换为单元实例的名称。多个实例可以指向带有通用于单元所有实例的配置选项的同一个模板文件。模板单元名称具有以下格式： 		



```none
unit_name@.service
```

​				例如，单位文件中的以下 `Wants` 设置： 		



```none
Wants=getty@ttyA.service getty@ttyB.service
```

​				首先为给定服务单元进行 systemd 搜索。如果没有找到这样的单元，"@" 和类型后缀间的部分会被忽略，**systemd** 搜索 `getty@.service` 文件，从中读取配置并启动服务。 		

​				例如, `getty@.service` 模板包含以下指令： 		



```none
[Unit]
Description=Getty on %I
…
[Service]
ExecStart=-/sbin/agetty --noclear %I $TERM
…
```

​				当从上述模板中实例化 getty@ttyA.service 和 getty@ttyB.service 时, `Description`= 会被解析为 **Getty on ttyA** 和 **Getty on ttyB**。 		

## 16.19. 重要单元指定符

​				可在任何单元配置文件中使用通配符字符（称为 **单元指定符**）。单元指定符替换某些单元参数，并在运行时被解释。下表列出了对模板单元特别有用的单元指定符。 		

表 16.5. 重要单元指定符

| 单元指定符 | 含义         | 描述                                                         |
| ---------- | ------------ | ------------------------------------------------------------ |
| `%n`       | 完整单元名称 | 代表包括类型后缀在内的完整单元名称。`%N` 具有相同的意义，而且使用 ASCII 代码替换禁止的字符。 |
| `%p`       | 前缀名称     | 代表删除了类型后缀的单元名称。对于实例化单元，%p 代表"@"字符前的单元名称的部分。 |
| `%i`       | 实例名称     | 是"@"字符和类型后缀之间的实例化单元名称的一部分。`%I` 具有相同的意义，但也会取代 ASCII 代码禁止的字符。 |
| `%H`       | 主机名       | 代表在载入单元配置时的运行系统的主机名。                     |
| `%t`       | 运行时目录   | 代表运行时目录，对于 `root` 用户是 `/run`，对于非特权用户是 XDG_RUNTIME_DIR 变量的值。 |

​				有关单元指定符的完整列表，请参见 `systemd.unit(5)` 手册页。 		

## 16.20. 其他资源

- ​						[如何编写强制必须启动特定服务的服务单元文件](https://access.redhat.com/solutions/3120581) 				
- ​						[如何决定 systemd 服务单元定义应具有哪些依赖项](https://access.redhat.com/solutions/3116611) 				
- ​						[是否有任何有关编写单元文件的有用的信息？](https://access.redhat.com/solutions/3120801) 				
- ​						[如何在 RHEL 7 和 systemd 中为服务设置限制](https://access.redhat.com/solutions/1257953) 				

# 第 17 章 优化 systemd 以缩短引导时间

​			有一组默认启用的 systemd 单元文件列表。由这些单元文件定义的系统服务会在引导时自动运行，这会影响引导时间。 	

​			本节描述： 	

- ​					检查系统引导性能的工具。 			
- ​					默认启用 systemd 单元以及您可以安全禁用 systemd 单元以便缩短引导时间的情况。 			

## 17.1. 检查系统引导性能

​				要检查系统引导性能，您可以使用 `systemd-analyze 命令`。这个命令有很多可用选项。然而，本节只涵盖所选对 systemd 调整很重要以便缩短引导时间的选择。 		

​				有关所有选项的完整列表和详细描述请查看 `systemd-analyze` man page。 		

**先决条件**

- ​						在开始检查 systemd 以调整引导时间之前，您可能需要列出所有启用的服务： 				

**流程**

​					



```none
$ systemctl list-unit-files --state=enabled
```

#### 分析整个引导时间

**流程**

- ​						有关最后一次成功引导时间的总体信息，请使用： 				



```none
$ systemd-analyze
```

#### 分析单元初始化时间

**流程**

- ​						有关每个 systemd 单元初始化时间的信息，请使用： 				



```none
$ systemd-analyze blame
```

​				输出会根据在上一次成功引导过程中初始化的时间以降序列出。 		

#### 识别关键单元

**流程**

- ​						要识别在最后一次引导成功时需要花费最多时间的单元，请使用： 				



```none
$ systemd-analyze critical-chain
```

​				输出突出显示使用红色的引导速度非常慢的单元。 		

图 17.1. systemd-analyze critical-chain 命令的输出

[![systemd analyze critical](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_basic_system_settings-zh-CN/images/daa941d9ec69b5bd4a400577ebeb578d/systemd-analyze-critical.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_basic_system_settings-zh-CN/images/daa941d9ec69b5bd4a400577ebeb578d/systemd-analyze-critical.png)

## 17.2. 为选择可安全禁用的服务提供指导信息

​				如果系统的引导时间较长，您可以通过禁用引导时启用的一些服务来缩短这个时间。 		

​				要列出这些服务，请运行： 		



```none
$ systemctl list-unit-files --state=enabled
```

​				要禁用某个服务，请运行： 		



```none
# systemctl disable service_name
```

​				然而，某些服务必须启用才能确保操作系统安全，并使其可以正常工作。 		

​				您可以使用下面的表格来选择可安全禁用的服务。这个表格列出了在 Red Hat Enterprise Linux 最小安装中默认启用的所有服务。对于每个服务，它还显示是否可安全禁用这个服务。 		

​				表还提供有关可禁用该服务的情况的更多信息，或者您不应该禁用该服务的原因。 		

表 17.1. 在 RHEL 的最小安装中默认启用的服务

| 服务名称                                    | 它可用被禁用吗？ | 更多信息                                                     |
| ------------------------------------------- | ---------------- | ------------------------------------------------------------ |
| auditd.service                              | 是               | 仅在不需要内核提供审核信息时禁用 `auditd.service`。请注意，如果禁用 `auditd.service`，则不会生成 `/var/log/audit/audit.log` 文件。因此,您无法追溯检查一些常见的动作或事件，如用户登录、服务启动或密码更改。还请注意 auditd 有两个部分：内核部分和服务本身。使用 `systemctl disable auditd` 命令，您只是禁用了该服务，而不是禁用内核的部分。要禁用系统审核，请在内核命令行中设置 `audit=0`。 |
| autovt@.service                             | 否               | 这个服务只在真正需要时才运行，因此不需要禁用它。             |
| crond.service                               | 是               | 请注意，如果您禁用 crond.service，则不会运行 crontab 中的项目。 |
| dbus-org.fedoraproject.FirewallD1.service   | 是               | 到 `firewalld.service` 的符号链接                            |
| dbus-org.freedesktop.NetworkManager.service | 是               | 到 `NetworkManager.service` 的符号链接                       |
| dbus-org.freedesktop.nm-dispatcher.service  | 是               | 到 `NetworkManager-dispatcher.service`的符号链接             |
| firewalld.service                           | 是               | 仅在不需要防火墙时禁用 `firewalld.service`。                 |
| getty@.service                              | 否               | 这个服务只在真正需要时才运行，因此不需要禁用它。             |
| import-state.service                        | 是               | 仅在不需要从网络存储引导时才禁用 `import-state.service`。    |
| irqbalance.service                          | 是               | 仅在只有一个 CPU 时禁用 `irqbalance.service`。不要在有多个 CPU 的系统中禁用 `irqbalance.service`。 |
| kdump.service                               | 是               | 仅在不需要内核崩溃报告时禁用 `kdump.service`。               |
| loadmodules.service                         | 是               | 除非 `/etc/rc.modules` 或 `/etc/sysconfig/modules` 目录存在，否则不会启动该服务，这意味着它不会在最小 RHEL 安装中启动。 |
| lvm2-monitor.service                        | 是               | 仅在不使用逻辑卷管理器(LVM)时禁用 `lvm2-monitor.service`。   |
| microcode.service                           | 否               | 不要禁用该服务，因为它在 CPU 中提供了 microcode 软件的更新。 |
| NetworkManager-dispatcher.service           | 是               | 只在不需要在网络配置更改时通知时才禁用 `NetworkManager-dispatcher.service` （例如在静态网络中）。 |
| NetworkManager-wait-online.service          | 是               | 只有在引导后不需要工作网络连接时才禁用 `NetworkManager-wait-online.service`。如果启用该服务，则该系统不会在网络连接正常工作前完成引导。这可能会大大延长引导时间。 |
| NetworkManager.service                      | 是               | 仅在不需要连接到网络时禁用 `NetworkManager.service`。        |
| nis-domainname.service                      | 是               | 仅在不使用网络信息服务（NIS）时禁用 `nis-domainname.service`。 |
| rhsmcertd.service                           | 否               |                                                              |
| rngd.service                                | 是               | 只在您的系统不需要很多熵或者没有任何硬件生成器时禁用 `rngd.service`。请注意，在需要大量好熵的环境中，比如用于生成 X.509 证书的系统（如 FreeIPA 服务器）中，该服务是必需的。 |
| rsyslog.service                             | 是               | 仅在不需要持久性日志，或把 `systemd-journald` 设置为持久性模式时，禁用 `rsyslog.service`。 |
| selinux-autorelabel-mark.service            | 是               | 仅在不使用 SELinux 时禁用 `selinux-autorelabel-mark.service`。 |
| sshd.service                                | 是               | 仅在不需要 OpenSSH 服务器远程登录时禁用 `sshd.service`。     |
| sssd.service                                | 是               | 仅在没有通过网络登录系统的用户（例如，使用 LDAP 或 Kerberos）时禁用 `sssd.service`。如果禁用了 `sssd.service`，红帽建议禁用所有 `sssd-*` 单元。 |
| syslog.service                              | 是               | `rsyslog.service` 的别名                                     |
| tuned.service                               | 是               | 仅在需要使用性能调整时禁用 `tuned.service`。                 |
| lvm2-lvmpolld.socket                        | 是               | 仅在您不使用逻辑卷管理器（LVM）时禁用 `lvm2-lvmpolld.socket`。 |
| dnf-makecache.timer                         | 是               | 仅在不需要自动更新软件包元数据时禁用 `dnf-makecache.timer`。 |
| unbound-anchor.timer                        | 是               | 仅在不需要每日更新 DNS 安全扩展（DNSSEC）的根信任锚时禁用 `unbound-anchor.timer`。Unbound resolver 和 resolver 库使用这个根信任锚器进行 DNSSEC 验证。 |

​				要查找有关服务的更多信息，您可以运行以下命令之一： 		



```none
$ systemctl cat <service_name>
```



```none
$ systemctl help <service_name>
```

​				`systemctl cat` 命令提供位于 `/usr/lib/systemd/system/<service>` 下的服务文件的内容，以及所有适用的覆盖。可用的覆盖包括 `/etc/systemd/system/<service>` 文件中的单元文件覆盖，或者来自对应的 `unit.type.d` 目录中的单元文件覆盖。 		

​				有关置入文件的详情,请参考 `systemd.unit` 手册页。 		

​				`systemctl help` 命令显示特定服务的手册页。 		

## 17.3. 其他资源

- ​						`systemctl`(1)手册页 				
- ​						`systemd`(1)手册页 				
- ​						`systemd-delta`(1)手册页 				
- ​						`systemd.directives`(7)手册页 				
- ​						`systemd.unit`(5)手册页 				
- ​						`systemd.service`(5)手册页 				
- ​						`systemd.target`(5)手册页 				
- ​						`systemd.kill`(5)手册页 				
- ​						[systemd 主页](http://www.freedesktop.org/wiki/Software/systemd) 				