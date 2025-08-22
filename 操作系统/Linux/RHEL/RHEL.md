# Red Hat Enterprise Linux 10

[TOC]

## 构架

Red Hat Enterprise Linux 9 带有内核版本 5.14 ，支持构架： 	

- AMD 和 Intel 64 位构架（x86-64-v2）
- 64 位 ARM 架构（ARMv8.0-A）
- IBM Power Systems, Little Endian（POWER9）
- 64-bit IBM Z（z14）

## 软件仓库

Red Hat Enterprise Linux 10 由两个主要软件仓库发布： 	

- BaseOS 			
- AppStream 			

两个软件仓库都需要一个基本的 RHEL 安装。 	

BaseOS 仓库的内容旨在提供底层操作系统功能的核心组件，为所有安装提供基础操作系统的基础。这部分内容采用 RPM 格式。

AppStream 仓库的内容包括额外的用户空间应用程序、运行时语言和数据库来支持各种工作负载和使用案例。

所有 RHEL 订阅都可以使用 CodeReady Linux Builder 软件仓库。它为开发人员提供了额外的软件包。不支持包括在 CodeReady Linux Builder 存储库中的软件包。

## 应用程序流

用户空间组件的多个版本会以 Application Streams（应用程序流）的形式提供，其更新频率会比核心操作系统软件包的更新频率更快。这为自定义 RHEL 提供了更大的灵活性，而不影响平台或特定部署的基本稳定性。

每个 Application Stream 组件都有其特定的生命周期，可能和 RHEL 9 的生命周期相同或更短。

提供以下格式的应用程序流：

- 熟悉的 RPM 格式
- 作为 RPM 格式的扩展，称为模块
- 作为 Software Collections
- 作为 Flatpaks。

RHEL 9 改进了应用程序流的使用体验，它提供了初始的应用程序流版本，可以使用传统的 `dnf install` 命令作为 RPM 软件包进行安装。

> 注意：
>
> 某些 RPM 格式的初始应用程序流的生命周期比 Red Hat Enterprise Linux 9 要短。

一些额外的 Application Stream 版本将作为模块发布，并在以后的 RHEL 9 次要发行本中带有较短的生命周期。

需要快速更新的内容（例如备用编译器和容器工具）会在滚动流中提供，且不会并行提供替代版本。滚动流可以打包为 RPM 或模块。

## Kdump

Kdump 附加组件添加了对配置内核崩溃转储的支持。这个附加组件在 Kickstart 中完全支持（使用 `%addon com_redhat_kdump` 命令及其选项）,并在图形和文本用户界面中作为附加窗口完全整合。

### 5.2.1. 设备命名方案

​					Red Hat Enterprise Linux 8 提供了一个新的网络设备命名方案，它根据用户定义的前缀生成网络接口名称。`net.ifnames.prefix` 引导选项允许安装程序和安装的系统使用设备命名方案。详情请查看 `dracut.cmdline(7)` man page。 			



### 5.3.3. 统一 ISO

​					在 Red Hat Enterprise Linux 8 中，统一的 ISO 会自动加载 **BaseOS** 和 **AppStream** 安装源程序库。这个功能适用于安装时载入的第一个基本存储库。例如： 如果您在没有配置库的情况下引导安装，且在图形用户界面(GUI)中有统一的 ISO 作为基本存储库，或者使用指向统一 ISO 的 `inst.repo=` 选项引导安装。 			

​					因此，AppStream 软件仓库会在 **Installation Source** GUI 窗口的 **Additional Repositories** 部分启用。您不能删除 AppStream 存储库或更改其设置，但您可以在 **安装源中禁用它**。如果您使用不同基础程序库引导安装，然后将其改为统一 ISO，则该功能将不起作用。如果这样做，基本软件仓库将被替换。但是 AppStream 软件仓库不会被替换并指向原始文件。 			

### 5.3.4. Stage2 镜像

​					在 Red Hat Enterprise Linux 8 中，可以指定 `stage2` 或 Kickstart 文件的多个网络位置以防止安装失败。这个版本支持使用 `stage2` 网络位置和 Kickstart 文件指定多个 `inst.stage2` 和 `inst.ks` 引导选项。这可避免发生因为无法访问 `stage2` 或 Kickstart 文件而导致无法获得需要的文件并使安装失败。 			

​					在这个版本中，如果指定了多个位置，可以避免安装失败。如果所有定义的位置都是 URL， `HTTP`、`HTTPS` 或 `FTP`，它们将按顺序被尝试，直到成功获取请求的文件为止。如果有一个不是 URL 的位置，则只尝试最后一个指定的位置。剩余的位置会被忽略。 			

### 5.3.5. inst.addrepo parameter

​					在以前的版本中,您只能从内核引导参数指定基本存储库。在 Red Hat Enterprise Linux 8 中, 一个新的内核参数，`inst.addrepo=<name>,<url>`，允许您在安装过程中指定附加程序库。这个参数有两个强制值：仓库名称和指向存储库的 URL。如需更多信息,请参阅 [inst-addrepo 使用](https://anaconda-installer.readthedocs.io/en/latest/boot-options.html#inst-addrepo)。 			

### 5.3.6. 从扩展的 ISO 进行安装

​					Red Hat Enterprise Linux 8 支持从本地硬盘中的软件仓库进行安装。之前，从硬盘中安装的唯一方法是使用 ISO  镜像作为安装源。但是，Red Hat Enterprise Linux 8 ISO 映像对于某些文件系统来说可能太大了。例如： FAT32  文件系统无法存储大于 4 GiB 的文件。在 Red Hat Enterprise Linux 8  中，您可从本地硬盘中的库启用安装，您只需要指定该目录而不是指定 ISO 镜像。例如： `inst.repo=hd:<device>:<path to the repository>`。 			

​					有关 Red Hat Enterprise Linux 8 BaseOS 和 AppStream 软件仓库的详情,请参考本文档中的 Repositories 部分 。 			

## 5.4. 安装程序图形化用户界面

## 安装程序

**Anaconda 会自动为互动安装激活网络**

​					Anaconda 现在会在执行交互式安装时自动激活网络，而无需用户在网络 spoke 中手动激活该网络。在这个版本中，不会更改 Kickstart 安装的安装体验，并使用 `ip=` 引导选项安装。 			

**用于`锁定 root 账户`和`允许使用密码进行 root SSH 登陆`的新选项**

​					RHEL 9 在 root 密码配置屏幕中添加以下新选项： 			

- ​						`锁定 root 帐户` ：锁定对计算机的 root 访问权限。 				
- ​						`允许使用密码的 root SSH 登录` ：启用基于密码的 SSH root 登录。 				

​				在 Kickstart 安装方法中，通过向 Kickstart 文件中添加以下行启用基于密码的 SSH root 登录： 		



```none
%post
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitrootlogin.conf
%end
```

**在标准安装后禁用了许可证、系统和用户设置配置屏幕**

​					在以前的版本中，在 `gnome-initial-setup` 和 `登录`屏幕前，RHEL 用户配置 Licensing、System(Subscription Manager)和用户设置。从 RHEL 9 开始，初始设置屏幕已默认禁用，以改进用户体验。如果需要运行初始设置以便用户创建或许可证显示，请根据要求安装以下软件包。 			

1. ​						安装初始设置软件包： 				

   

   ```none
   # dnf install initial-setup initial-setup-gui
   ```

2. ​						在系统下次重新引导后启用初始设置。 				

   

   ```none
   # systemctl enable initial-setup
   ```

3. ​						重启系统以查看初始设置。 				

​				对于 Kickstart 安装，在 packages 部分添加 `initial-setup-gui` 并启用 `initial-setup` 服务。 		



```none
firstboot --enable
%packages
@^graphical-server-environment
initial-setup-gui
%end
```

**现在，Satellite 通过 Kickstart 进行机器置备的 `rhsm` 命令现在可用**

​					`rhsm` 命令替代了 `%post` 脚本用于在 RHEL 9 上进行机器置备。`rhsm` 命令有助于执行所有置备任务，如注册系统、附加 RHEL 订阅并从 Satellite 实例安装。如需更多信息，请参阅执行高级 [RHEL 安装指南中的使用 Kickstart 注册和安装](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/performing_an_advanced_rhel_9_installation/assembly_registering-and-installing-rhel-from-satellite-via-kickstart_installing-rhel-as-an-experienced-user) RHEL 部分。 			

**新的 Kickstart 命令 - `timesource`**

​					新的 `timesource` Kickstart 命令是可选的，它可帮助设置 NTP、NTS 服务器和提供时间数据的 NTP 池。它还有助于控制或禁用系统上的 NTP 服务。timezone 命令的 `--ntpservers` 选项已弃用，并已被这个新命令替代。 			

**支持没有 inst. 前缀的 Anaconda 引导参数不再可用**

​					自 RHEL 7 开始，没有 `inst.` 前缀的 Anaconda 引导参数已被弃用，RHEL 9 中删除了对这些引导参数的支持。要继续使用这些选项，请使用 `inst.` 前缀 			

​				例如：要强制安装程序在 `文本模式` 而不是 `图形模式下` 运行，请使用以下选项： 		



```none
inst.text
```

**删除的 Kickstart 命令和选项**

​					以下 Kickstart 命令和选项已从 RHEL 9 中删除。在 Kickstart 文件中使用它们会导致错误。 			

- ​						`device` 				
- ​						`deviceprobe` 				
- ​						`dmraid` 				
- ​						`install` - 使用子命令或者方法作为命令 				
- ​						`multipath` 				
- ​						`bootloader` `--upgrade` 				
- ​						`ignoredisk` `--interactive` 				
- ​						`partition` `--active` 				
- ​						`harddrive` `--biospart` 				
- ​						`autostep` 				

​				如果只列出具体选项和值，则基础命令及其它选项仍可用且没有被删除。 		

**删除引导选项**

​					以下引导选项已从 Red Hat Enterprise Linux 中删除： 			

- ​						`inst.zram` 				

  ​						RHEL 9 不支持 `zram` 服务。详情请查看 `zram-generator(8)` man page。 				

- ​						`inst.singlelang` 				

  ​						RHEL 9 不支持单一语言模式。 				

- ​						`inst.loglevel` 				

  ​						日志级别始终设置为 debug。 				

### 5.4.1. 安装概述窗口

​					Red Hat Enterprise Linux 8 图形安装的安装概述窗口已更新为一个新的三栏布局，它改进了图形安装设置的组织。 			

## 5.5. RHEL 中新的系统目的

### 5.5.1. 在图形安装中提供了对系统目的支持

​					在以前的版本中，Red Hat Enterprise Linux 安装程序没有为 Subscription Manager 提供系统目的信息。在 Red Hat Enterprise Linux 8 中，您可以使用 **System Purpose** 窗口，或使用 `syspurpose` 命令在 Kickstart 配置文件中，在图形安装过程中设定系统的预期目的。当您设置系统目的时，授权服务器会收到有助于自动附加满足系统预期使用的订阅的信息。 			

### 5.5.2. Pykickstart 中的系统目的支持

​					在以前的版本中, `pykickstart` 库无法向 Subscription Manager 提供系统目的信息。在 Red Hat Enterprise Linux 8 中 `pykickstart` 解析新的 `syspurpose` 用途命令，并记录系统在自动化和部分自动化安装过程中的预期目的。然后,这个信息会被传递给安装程序,保存在新安装的系统上,在订阅系统时可用于 Subscription Manager。 			

## 5.6. 安装程序模块支持

### 5.6.1. 使用 Kickstart 安装模块

​					在 Red Hat Enterprise Linux 8 中，已将安装程序扩展为处理所有模块化特性。Kickstart 脚本现在可以启用模块和流组合、安装模块配置集以及安装模块化软件包。 			

## 5.7. Kickstart 的修改

​				以下小节描述了 Red Hat Enterprise Linux 8 中 Kickstart 命令和选项的更改。 		

### 5.7.1. 在 RHEL 8 中弃用了 auth 或 authconfig

​					因为已经删除了该 `authconfig` 工具和软件包，所以在 Red Hat Enterprise Linux 8 中弃用了 `auth` 或 `authconfig` Kickstart 命令。 			

​					和命令行中的 `authconfig` 命令类似，Kickstart 脚本中的 `authconfig` 命令现在使用这个 `authselect-compat` 工具来运行新 `authselect` 工具。有关这个兼容性层及其已知问题的描述，请查看手册页 `authselect-migration(7)`。安装程序将自动检测弃用命令的使用并在系统上安装该 `authselect-compat` 软件包以提供兼容性层。 			

### 5.7.2. Kickstart 不再支持 Btrfs

​					Red Hat Enterprise Linux 8 不支持 Btrfs 文件系统。因此，图形用户界面(GUI)和 Kickstart 命令不再支持 Btrfs。 			

### 5.7.3. 使用之前 RHEL 发行本中的 Kickstart 文件

​					如果您正在使用之前的 RHEL 版本中的 Kickstart 文件,请参阅 [*RHEL 8 文档中*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index/) 的 *Repositories* 部分，以了解有关 Red Hat Enterprise Linux 8 BaseOS 和 AppStream 软件仓库的详情。 			

### 5.7.4. 弃用的 Kickstart 命令和选项

​					在Red Hat Enterprise Linux 8 中弃用了以下 Kickstart 命令和选项。 			

​					如果只列出具体选项，则基础命令及其它选项仍可用且没有弃用。 			

- ​							`auth` 或者 `authconfig` - 使用 `authselect instead` 					
- ​							`device` 					
- ​							`deviceprobe` 					
- ​							`dmraid` 					
- ​							`install` - 直接使用子命令或者方法作为命令 					
- ​							`multipath` 					
- ​							`bootloader --upgrade` 					
- ​							`ignoredisk --interactive` 					
- ​							`partition --active` 					
- ​							`reboot --kexec` 					

​					除 `auth` 或 `authconfig` 命令外，使用 Kickstart 文件中的命令在日志中打印警告信息。 			

​					您可以使用 `inst.ksstrict` 引导选项将已弃用的命令警告放入出错信息，但 `auth` 或 `authconfig` 命令除外。 			

### 5.7.5. 删除的 Kickstart 命令和选项

​					在 Red Hat Enterprise Linux 8 中完全删除了以下 Kickstart 命令和选项。在 Kickstart 文件中使用它们将导致错误。 			

- ​							`upgrade` （这个命令之前已弃用。） 					
- ​							`btrfs` 					
- ​							`part/partition btrfs` 					
- ​							`part --fstype btrfs` 或者 `partition --fstype btrfs` 					
- ​							`logvol --fstype btrfs` 					
- ​							`raid --fstype btrfs` 					
- ​							`unsupported_hardware` 					

​					如果只列出具体选项和值，则基础命令及其它选项仍可用且没有被删除。 			

### 5.7.6. 新的 Kickstart 命令和选项

​					在 Red Hat Enterprise Linux 8.2 中添加了以下命令和选项。 			

**RHEL 8.2**

- ​							`rhsm` 					
- ​							`zipl` 					

​					在 Red Hat Enterprise Linux 8 中添加了以下命令和选项。 			

**RHEL 8.0**

- ​							`authselect` 					
- ​							`module` 					

## 5.8. 镜像创建

### 5.8.1. 使用镜像构建程序自定义系统镜像创建

​					Image Builder 工具可让用户创建自定义的 RHEL 镜像。从 Red Hat Enterprise Linux 8.3 开始，镜像构建器作为系统服务 **osbuild-composer** 软件包运行。 			

​					使用镜像构建器，用户可以创建包含其他软件包的自定义系统镜像。镜像构建器功能可以通过以下方式访问： 			

- ​							web 控制台中的图形用户界面 					
- ​							`composer-cli` 工具中的命令行界面。 					

​					镜像构建器输出格式包括： 			

- ​							TAR 归档 					
- ​							可以直接用于虚拟机或 OpenStack 的 qcow2 文件 					
- ​							QEMU QCOW2 镜像 					
- ​							Azure、VMWare 和 AWS 的云镜像 					

​					如需了解更多有关镜像构建器的信息，请参阅文档标题 [组成自定义的 RHEL 系统镜像](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/composing_a_customized_rhel_system_image/)。 			

​				从 Red Hat Enterprise Linux 9.0 开始： 		

**镜像构建器支持 LVM 上的自定义文件系统分区**

​					通过对 LVM 中的自定义文件系统分区的支持，如果您在系统中添加任何文件系统自定义，文件系统将转换为 LVM 分区。 			

**镜像构建器现在支持文件系统配置**

​					从 Red Hat Enterprise Linux 9.0 开始，Image Builder 支持用户在蓝图中指定自定义文件系统配置，以创建带有特定磁盘布局的镜像，而不是使用默认的布局配置。 			

**镜像构建器可以创建可引导 ISO 安装程序镜像**

​					您可以使用 Image Builder GUI 和 CLI 创建可引导 ISO 安装程序镜像。这些镜像由 tarball 组成，包含可用于直接安装到裸机服务器的根文件系统。 			

# 第 6 章 订阅管理

## 6.1. 订阅管理的显著变化

**在 `subscription-manager syspurpose` 命令下合并系统目的命令**

​					在以前的版本中，有两个不同的命令来设置系统目的属性： `syspurpose` 和 `subscription-manager`。要在一个模块下统一所有系统目的属性，subscription-manager 中的所有 `addons`, `role`, `service-level`, 和 `usage` 命令都已移至新的子模块 `subscription-manager syspurpose`。 			

​				新子模块之外的现有 `subscription-manager` 命令已弃用。在 RHEL 9 中删除了提供 `syspurpose` 命令行工具的独立软件包(`python3-syspurpose`)。 		

​				这个版本提供了一种一致的方法，使用 subscription-manager 的单一命令来查看、设置和更新所有系统目的属性。这个命令将所有现有系统目的命令替换为新子命令的等效版本。例如，`subscription-manager role --set SystemRole` 变成 `subscription-manager syspurpose role --set SystemRole` 等等。 		

​				有关新命令、选项和其他属性的完整信息，请参阅 `subscription-manager` man page 中的 `SYSPURPOSE OPTIONS` 部分，或[使用订阅管理器命令行工具 配置系统目的](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/performing_a_standard_rhel_9_installation/index#proc_configuring-system-purpose-using-the-subscription-manager-command-line-tool_post-installation-tasks)。 		

**`virt-who` 现在使用 `/etc/virt-who.conf` 用于全局选项，而不是 `/etc/sysconfig/virt-who`**

​					在 RHEL 9 中，`virt-who` 实用程序的全局选项存储在 `/etc/virt-who.conf` 文件中。因此，`/etc/sysconfig/virt-who` 文件不再被使用，且已被删除。 			

# 第 6 章 软件管理

## 6.1. YUM 的主要变化

​				在 Red Hat Enterprise Linux（RHEL）8 上，使用新版本的 **YUM** 工具用来安装软件，它基于 **DNF** 技术（**YUM v4**）。 		

### 6.1.1. YUM v4 与 YUM v3 相比的优点

​					**yum v4** 比 RHEL 7 上之前使用的 **YUM v3** 有以下优点： 			

- ​							提高了性能 					
- ​							支持模块化内容 					
- ​							设计良好的稳定 API，用于与工具集成 					

​					有关新 **YUM v4** 工具与 RHEL 7 以前的 **YUM v3** 版本之间的区别,请参阅与 YUM [相比的 DNF CLI 的变化](http://dnf.readthedocs.io/en/latest/cli_vs_yum.html)。 			

### 6.1.2. 如何使用 YUM v4

##### 安装软件

​					**yum v4** 在使用命令行、编辑或者创建配置文件时与 **YUM v3** 兼容。 			

​					要安装软件，您可以使用 `yum` 命令及其具体选项，方式与在 RHEL 7 中相同。 			

​					请参阅 [yum 安装软件](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#installing-software-with-yum_configuring-basic-system-settings) 的更多详细信息。 			

##### 插件可用性

​					旧的 **YUM v3** 插件与 **YUM v4** 的新版本不兼容。所选的一些 yum 插件和工具已被移植到新的 DNF 后端，可使用与 RHEL 7 中相同的名称进行安装。它们也提供兼容性符号链接，因此可在通常的位置找到 二进制文件、配置文件和目录。 			

​					如果插件不再包括,或者替换没有满足可用性需求,请联系红帽支持来请求一个功能增强功能,如 [如何打开和管理客户门户网站中的支持问题单所述？](https://access.redhat.com/articles/38363) 			

​					如需更多信息,请参阅 [插件接口](https://dnf.readthedocs.io/en/latest/api_plugins.html)。 			

##### API 的可用性

​					请注意，**YUM v3** 提供的旧版本的 Python API 不再可用。我们建议用户将插件和脚本迁移到 **YUM v4**（DNF Python API）提供的新 API 中，它是稳定的且被完全支持。上游项目提供了新的 DNF Python API - 请参阅 [DNF API 参考](https://dnf.readthedocs.io/en/latest/api.html)。 			

​					Libdnf 和 Hawkey API（C 和 Python）被视为不稳定，在 RHEL 8 生命周期中可能会有所变化。 			

### 6.1.3. YUM 配置文件选项的可用性

​					本节总结了在 RHEL 7 和 RHEL 8 之间 `/etc/yum.conf` 和 `/etc/yum.repos.d/*.repo` 文件的配置文件选项的更改。 			

**表 6.1. /etc/yum.conf 文件配置文件选项的更改**

| RHEL 7 选项                         | RHEL 8 状态 |
| ----------------------------------- | ----------- |
| alwaysprompt                        | 删除        |
| assumeno                            | 可用        |
| assumeyes                           | 可用        |
| autocheck_running_kernel            | 可用        |
| autosavets                          | 删除        |
| bandwidth                           | 可用        |
| bugtracker_url                      | 可用        |
| cachedir                            | 可用        |
| check_config_file_age               | 可用        |
| clean_requirements_on_remove        | 可用        |
| color                               | 可用        |
| color_list_available_downgrade      | 可用        |
| color_list_available_install        | 可用        |
| color_list_available_reinstall      | 可用        |
| color_list_available_running_kernel | 删除        |
| color_list_available_upgrade        | 可用        |
| color_list_installed_extra          | 可用        |
| color_list_installed_newer          | 可用        |
| color_list_installed_older          | 可用        |
| color_list_installed_reinstall      | 可用        |
| color_list_installed_running_kernel | 删除        |
| color_search_match                  | 可用        |
| color_update_installed              | 可用        |
| color_update_local                  | 可用        |
| color_update_remote                 | 可用        |
| commands                            | 删除        |
| config_file_path                    | 可用        |
| debuglevel                          | 可用        |
| deltarpm                            | 可用        |
| deltarpm_metadata_percentage        | 删除        |
| deltarpm_percentage                 | 可用        |
| depsolve_loop_limit                 | 删除        |
| disable_excludes                    | 可用        |
| diskspacecheck                      | 可用        |
| distroverpkg                        | 删除        |
| enable_group_conditionals           | 删除        |
| errorlevel                          | 可用        |
| exactarchlist                       | 删除        |
| exclude                             | 可用        |
| exit_on_lock                        | 可用        |
| fssnap_abort_on_errors              | 删除        |
| fssnap_automatic_keep               | 删除        |
| fssnap_automatic_post               | 删除        |
| fssnap_automatic_pre                | 删除        |
| fssnap_devices                      | 删除        |
| fssnap_percentage                   | 删除        |
| ftp_disable_epsv                    | 删除        |
| gpgcheck                            | 可用        |
| group_command                       | 删除        |
| group_package_types                 | 可用        |
| groupremove_leaf_only               | 删除        |
| history_list_view                   | 可用        |
| history_record                      | 可用        |
| history_record_packages             | 可用        |
| http_caching                        | 删除        |
| Include                             | 删除        |
| installonly_limit                   | 可用        |
| installonlypkgs                     | 可用        |
| installrootkeep                     | 删除        |
| ip_resolve                          | 可用        |
| keepalive                           | 删除        |
| keepcache                           | 可用        |
| kernelpkgnames                      | 删除        |
| loadts_ignoremissing                | 删除        |
| loadts_ignorenewrpm                 | 删除        |
| loadts_ignorerpm                    | 删除        |
| localpkg_gpgcheck                   | 可用        |
| logfile                             | 删除        |
| max_connections                     | 删除        |
| mddownloadpolicy                    | 删除        |
| mdpolicy                            | 删除        |
| metadata_expire                     | 可用        |
| metadata_expire_filter              | 删除        |
| minrate                             | 可用        |
| mirrorlist_expire                   | 删除        |
| multilib_policy                     | 可用        |
| obsoletes                           | 可用        |
| override_install_langs              | 删除        |
| overwrite_groups                    | 删除        |
| password                            | 可用        |
| payload_gpgcheck                    | 删除        |
| persistdir                          | 可用        |
| pluginconfpath                      | 可用        |
| pluginpath                          | 可用        |
| plugins                             | 可用        |
| protected_multilib                  | 删除        |
| protected_packages                  | 可用        |
| proxy                               | 可用        |
| proxy_password                      | 可用        |
| proxy_username                      | 可用        |
| query_install_excludes              | 删除        |
| recent                              | 可用        |
| recheck_installed_requires          | 删除        |
| remove_leaf_only                    | 删除        |
| repo_gpgcheck                       | 可用        |
| repopkgsremove_leaf_only            | 删除        |
| reposdir                            | 可用        |
| reset_nice                          | 可用        |
| retries                             | 可用        |
| rpmverbosity                        | 可用        |
| shell_exit_status                   | 删除        |
| showdupesfromrepos                  | 可用        |
| skip_broken                         | 可用        |
| skip_missing_names_on_install       | 删除        |
| skip_missing_names_on_update        | 删除        |
| ssl_check_cert_permissions          | 删除        |
| sslcacert                           | 可用        |
| sslclientcert                       | 可用        |
| sslclientkey                        | 可用        |
| sslverify                           | 可用        |
| syslog_device                       | 删除        |
| syslog_facility                     | 删除        |
| syslog_ident                        | 删除        |
| throttle                            | 可用        |
| timeout                             | 可用        |
| tolerant                            | 删除        |
| tsflags                             | 可用        |
| ui_repoid_vars                      | 删除        |
| upgrade_group_objects_upgrade       | 可用        |
| upgrade_requirements_on_install     | 删除        |
| usercache                           | 删除        |
| username                            | 可用        |
| usr_w_check                         | 删除        |

**表 6.2. /etc/yum.repos.d/\*.repo 文件配置文件选项更改**

| RHEL 7 选项                  | RHEL 8 状态 |
| ---------------------------- | ----------- |
| async                        | 删除        |
| bandwidth                    | 可用        |
| baseurl                      | 可用        |
| compare_providers_priority   | 删除        |
| cost                         | 可用        |
| deltarpm_metadata_percentage | 删除        |
| deltarpm_percentage          | 可用        |
| enabled                      | 可用        |
| enablegroups                 | 可用        |
| exclude                      | 可用        |
| failovermethod               | 删除        |
| ftp_disable_epsv             | 删除        |
| gpgcakey                     | 删除        |
| gpgcheck                     | 可用        |
| gpgkey                       | 可用        |
| http_caching                 | 删除        |
| includepkgs                  | 可用        |
| ip_resolve                   | 可用        |
| keepalive                    | 删除        |
| metadata_expire              | 可用        |
| metadata_expire_filter       | 删除        |
| metalink                     | 可用        |
| mirrorlist                   | 可用        |
| mirrorlist_expire            | 删除        |
| name                         | 可用        |
| password                     | 可用        |
| proxy                        | 可用        |
| proxy_password               | 可用        |
| proxy_username               | 可用        |
| repo_gpgcheck                | 可用        |
| repositoryid                 | 删除        |
| retries                      | 可用        |
| skip_if_unavailable          | 可用        |
| ssl_check_cert_permissions   | 删除        |
| sslcacert                    | 可用        |
| sslclientcert                | 可用        |
| sslclientkey                 | 可用        |
| sslverify                    | 可用        |
| throttle                     | 可用        |
| timeout                      | 可用        |
| ui_repoid_vars               | 删除        |
| username                     | 可用        |

### 6.1.4. YUM v4 的不同行为

​					**YUM v3** 的一些功能在 **YUM v4** 中的行为可能不同。如果此类更改对您的工作流有影响，请向红帽支持创建一个问题单，请参阅 [如何打开和管理客户门户网站中的支持问题单所述？](https://access.redhat.com/articles/38363) 			

#### 6.1.4.1. yum list 显示重复条目

​						当使用 `yum list` 命令列出软件包时,可能会显示重复条目,每个库都有一个相同名称和版本的软件包。 				

​						这是有意设计的，用户在需要时也可区分这些软件包。 				

​						例如，如果 package-1.2 在 repo1 和 repo2 中都可用，**YUM v4** 会输出这两个实例： 				

```
[…]
package-1.2    repo1
package-1.2    repo2
[…]
```

​						相反，传统的 **YUM v3** 命令会过滤出此类的重复，因此只显示一个实例： 				

```
[…]
package-1.2    repo1
[…]
```

### 6.1.5. 事务历史记录文件的更改

​					本节总结了 RHEL 7 和 RHEL 8 之间的事务历史日志文件的变化。 			

​					在 RHEL 7 中, `/var/log/yum.log` 文件存储： 			

- ​							软件包的安装、更新和删除 registry 					
- ​							来自 yum 和 **PackageKit** 的事务 					

​					在 RHEL 8 中，没有直接对应的 `/var/log/yum.log` 文件。要显示事务信息，包括 **PackageKit** 和 **microdnf**，使用 `yum history` 命令。 			

​					另外，您可以搜索 `/var/log/dnf.rpm.log` 文件，但此日志文件不包含 PackageKit 和 microdnf 的事务，它有一个日志轮转来定期删除存储的信息。 			

## 6.2. 重要的 RPM 特性和变化

​				Red Hat Enterprise Linux (RHEL) 8 使用 RPM 4.14。这个版本比 RPM 4.11 提供了很多改进，具体信息包括在 RHEL 7 中。 		

​				主要特性包括： 		

- ​						debuginfo 软件包可并行安装 				

- ​						支持弱依赖项 				

- ​						支持丰富的或布尔值的依赖项 				

- ​						支持大小超过 4 GB 的打包文件 				

- ​						支持文件触发器 				

- ​						新的 `--nopretrans` 和 `--noposttrans` 参数被分别用来禁用 `%pretrans` 和 `%posttrans` 脚本的执行。 				

- ​						新的 `--noplugins` 参数用来禁用载入和执行所有 RPM 插件。 				

- ​						新的 `syslog` 插件,用于记录任何 RPM 活动,由系统日志记录协议(syslog)记录。 				

- ​						`rpmbuild` 命令现在可以直接从源软件包中执行所有构建步骤。 				

  ​						它通过在 `rpmbuild` 中使用任何 `-r[abpcils]` 选项实现。 				

- ​						支持重新安装模式。 				

  ​						新的 `--reinstall` 选项可保证这一点。要重新安装之前安装的软件包，请使用以下语法： 				

  ```
  rpm {--reinstall} [install-options] PACKAGE_FILE
  ```

  ​						这个选项可确保正确安装新软件包并删除旧软件包。 				

- ​						支持 SSD conservation 模式。 				

  ​						新的 `%_minimize_writes` 宏保证了这一点，该文件包括在 `/usr/lib/rpm/macros` 文件中。宏默认设置为 0。要最小化对 SSD 磁盘的写入操作，将 `%_minimize_writes` 设置为 1。 				

- ​						将 rpm 有效负载转换为 tar 归档的新工具 `rpm2archive` 				

​				请参阅 [RHEL 8 中的新 RPM 功能](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/packaging_and_distributing_software/index#new-features-in-rhel-8_packaging-and-distributing-software)。 		

​				主要变更包括： 		

- ​						更严格的 spec-parser 				

- ​						简化对非详细模式输出的签名检查 				

- ​						改进了对可重复生成的构建的支持（创建相同软件包的构建）: 				

  - ​								设置构建时间 						
  - ​								设置文件 mtime（文件修改时间） 						
  - ​								设置构建主机 						

- ​						使用 `-p` 选项查询卸载的 PACKAGE_FILE 现在是可选的。对于这个情况，在带有或不带有 `-p` 选项时， `rpm` 命令现在都会返回相同的结果。需要 `-p` 选项的唯一用例是，验证文件名与 `rpmdb` 数据库中的任何 `Provides` 都不匹配。 				

- ​						在宏中添加和弃用 				

  - ​								`%makeinstall` 宏已弃用。要安装程序，使用 `%make_install` 宏。 						

- ​						`rpmbuild --sign` 命令已弃用。 				

  ​						请注意，在 `rpmbuild` 命令中使用 `--sign` 选项已弃用。要在已经存在的软件包中添加签名，请使用 `rpm --addsign`。 				

​			本章列出了 RHEL 8 和 RHEL 9 之间软件管理的最显著更改。 	

## 7.1. 软件管理的主要变化

**使用 DNF/YUM 进行软件包管理**

​					在 Red Hat Enterprise Linux 9 中，使用 **DNF** 确保软件安装 。红帽继续支持使用 `yum` 术语，以便与以前的 RHEL 主版本保持一致。如果您键入 `dnf` 而不是 `yum`，则命令按预期运行，因为它们都是兼容性的别名。 			

​				虽然 RHEL 8 和 RHEL 9 基于 **DNF**，但它们与 RHEL 7 中使用的 **YUM** 兼容。 		

​				如需更多信息，请参阅使用 [DNF 工具管理软件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/managing_software_with_the_dnf_tool/index)。 		

**重要的 RPM 特性和变化**

​					Red Hat Enterprise Linux 9 带有 RPM 版本 4.16。与之前的版本相比，这个版本引入了很多改进。 			

​				主要特性包括： 		

- ​						新的 SPEC 功能，最重要的是： 				

  - ​								快速基于宏的依赖关系生成器 						

    ​								现在可以将依赖项生成器定义为常规 RPM 宏。这在使用嵌入式 Lua 解释器时非常有用 (`%{lua:…}`），因为它启用了编写复杂的快速生成器，并避免冗余分叉和执行 shell 脚本。 						

    ​								例如： 						

    

    ```none
    %__foo_provides()    %{basename:%{1}}
    ```

  - ​								启用生成动态构建依赖项的 `%generate_buildrequires` 部分 						

    ​								现在，可以使用新可用的 `%generate_buildrequires` 部分，以编程方式生成额外的构建依赖项。这在使用特殊实用程序编写的语言打包软件时很有用，它用于确定运行时或构建运行时依赖项，如 Rust、Node.js、Ruby、Python 或 Haskell。 						

  - ​								元（未排序）依赖项 						

    ​								新的名为 `meta` 的依赖项限定器，可以用来指定不特定于安装时或运行时依赖项的依赖项。这可用于避免因正常依赖关系顺序而产生的不必要的依赖关系循环，比如在指定 meta 软件包的依赖项时。 						

    ​								例如： 						

    

    ```none
    Requires(meta): <pkgname>
    ```

  - ​								表达式中的原生版本比较 						

    ​								现在，可以使用新支持的格式来比较表达式中的任意版本字符串 `v"…"` 格式。 						

    ​								例如： 						

    

    ```none
    %if v"%{python_version}" < v"3.9"
    ```

  - ​								尖号( ^ ) 操作符，与波形符（ ~ ）相反 						

    ​								新的 caret(`^`)运算符，可用于指定高于基本版本的版本。它是一个与现有波形符(`~`)运算符的补充，其具有相反语义。 						

  - ​								`%elif`、`%elifos` 和 `%elifarch` 语句 						

  - ​								可选的自动补丁和源编号 						

    ​								`Patch:` 和 `Source:` 标签现在根据列出的顺序自动为没有数字编号。 						

  - ​								`%autopatch` 现在接受补丁范围 						

    ​								`%autopatch` 宏现在接受 `-m` 和 `-M` 参数，以分别限制要应用的最小和最大补丁号。 						

  - ​								`%patchlist` 和 `%sourcelist` 部分 						

    ​								现在，可以通过使用新添加的 `%patchlist` 和 `%sourcelist` 部分，列出补丁和源文件，而无需之前带有相应 `Patch`: 和 `Source:` 标签。 						

- ​						RPM 数据库现在基于 `sqlite` 库。为迁移和查询目的保留了对 `BerkeleyDB` 数据库的只读支持。 				

- ​						一个新的 `rpm-plugin-audit` 插件，用于发出交易的审计日志事件，之前内置在 RPM 自身中 				

- ​						增加了软件包构建的并行性 				

  ​						对软件包构建过程进行并行化的方式有大量改进。这些改进涉及各种 buildroot 策略脚本和健全性检查、文件分类和子软件包创建和排序。因此，在多处理器系统上构建软件包，特别是对于大型软件包，现在应该更快且效率更高。 				

- ​						构建时强制进行标头数据的 UTF-8 验证 				

- ​						RPM 现在支持 Zstandard (`zstd`) 压缩算法 				

  ​						在 RHEL 9 中，默认的 RPM 压缩算法已切换到 Zstandard(`zstd`)。因此，软件包现在可以更快地安装，这在大型环境中会特别明显。 				

​			本章列出了 RHEL 8 和 RHEL 9 之间的 shell 和命令行工具的最显著变化。 	

## 8.1. 系统管理的显著变化

**Red Hat Enterprise Linux 9 中的 net-snmp 通信无法使用数据加密标准(DES)算法**

​					在以前的 RHEL 版本中，DES 被用作 net-snmp 客户端和服务器间安全通信的加密算法。在 RHEL 9 中，OpenSSL 库不支持 DES 算法。该算法被标记为不安全，因此删除了对 net-snmp 的 DES 支持。 			

**ABRT 工具已被删除**

​					RHEL 9 不提供用于检测和报告应用程序崩溃的自动错误报告工具(ABRT)。 			

​				作为替代，使用 `systemd-coredump` 工具记录和存储核心转储，其是程序崩溃后自动生成的文件。 		

**RHEL 9 `systemd`不支持 `hidepid=n` 挂载选项**

​					挂载选项 `hidepid=n`，其控制谁可以访问 `/proc/[pid]` 目录中的信息，与 RHEL 9 提供的 `systemd` 基础架构不兼容。 			

​				另外，使用这个选项可能会导致 `systemd` 启动的某些服务生成 SELinux AVC 拒绝消息，并阻止完成其他操作。 		

**`dump` 软件包中的 `dump` 的工具程序已被删除。**

​					Red Hat Enterprise Linux 8 已弃用用于文件系统备份的 `dump` 工具工具程序，在 RHEL 9 中已不再提供它。 			

​				在 RHEL 9 中，红帽建议使用 `tar` 或 `dd` 作为 ext2、ext3 和 ext4 文件系统的备份工具。`dump` 实用程序将是 EPEL 9 存储库的一部分。 		

​				请注意，`dump` 软件包中的 `restore` 工具仍可用，在 RHEL 9 中也被支持，并作为 `restore` 软件包提供。 		

**RHEL 9 不包含 ReaR crontab**

​					`rear` 软件包中的 `/etc/cron.d/rear` crontab（它在磁盘布局更改后运行 `rear mkrescue`）已在 RHEL 9 中删除。 			

​				如果您依赖 `/etc/cron.d/rear` crontab 来运行 `rear mkrescue`，您可以手动配置 ReaR 的定期运行。 		

注意

​					RHEL 中的 `rear` 软件包包含以下调度作业的示例： 			

- ​							`/usr/share/doc/rear/rear.cron` 示例 crontab 					
- ​							`/usr/share/doc/rear/rear.{service,timer}` 示例 systemd 单元 					

​					不要在没有针对特定环境进行修改的情况下使用这些示例，或者进行其他操作来对系统恢复进行更新。除了重新创建救援镜像外，还需要定期进行备份。进行备份的步骤取决于本地配置。如果您在运行 `rear mkrescue` 命令时没有同时进行更新的备份，系统恢复过程将使用以前的备份，这与保存的布局不一致。 			

# 8.2. 命令行工具的显著变化

**删除了对 `raw` 命令行工具的支持**

​					有了这个版本，`raw` (`/usr/bin/raw`)命令行工具已从 `util-linux` 软件包中删除，因为 Linux 内核从版本 5.14 后不支持 `raw` 设备。 			

​				目前，没有可用的替换。 		

# 第 7 章 基础架构服务

# 第 9 章 基础架构服务

​			本章列出了 RHEL 8 和 RHEL 9 间的基础架构服务的显著更改。 	

## 9.1. 基础架构服务的显著变化

**删除了对 `Berkeley DB` 动态后端的支持**

​					在这个版本中，`Berkeley DB` (`libdb`)动态后端不再被支持。不再提供 `named-sdb` 构建。您可以为每个后端使用 `DLZ 载入插件`，例如 `sqlite3` 或 `mysql`。这些插件没有构建或发布，且必须从源构建。 			

​			本章列出了 RHEL 8 和 RHEL 9 之间与安全相关的主要更改。 	

## 10.1. 安全合规性

**CIS 和 DISA STIG 配置集作为 DRAFT 提供**

​					该配置集基于互联网安全中心(CIS)和防御行业安全技术实施指南(DISA STIG)的基准，作为 DRAFT 提供，因为发出的机构尚未公布 RHEL 9 的官方基准。另外，OSSP 配置集在 DRAFT 中被实施。 			

​				有关 RHEL 9 中可用的配置文件的完整列表，请参阅 [RHEL 9 支持的 SCAP 安全指南配置文件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/security_hardening#scap-security-guide-profiles-supported-in-rhel-9_scanning-the-system-for-configuration-compliance-and-vulnerabilities)。 		

**OpenSCAP 不再支持 SHA-1 和 MD5**

​					由于在 Red Hat Enterprise Linux 9 中删除 SHA-1 和 MD5 哈希功能后，从 OpenSCAP 中删除了对 OVAL `filehash_test` 的支持。另外，从 OpenSCAP 中的 OVAL `filehash58_test` 实现中删除了对 SHA-1 和 MD5 哈希功能的支持。因此，OpenSCAP 会评估使用 OVAL `filehash_test` 的 SCAP 内容中的规则作为 `notchecked`。另外，在评估 OVAL `filehash58_test`（`filehash58_object` 中的 `hash_type` 项设置为 `SHA-1` 或 `MD5`）时，OpenSCAP 会返回 `notchecked`。 			

​				要更新 OVAL 内容，请重写受影响的 SCAP 内容，使其使用 `filehash58_test` 而不是 `filehash_test`，并在 `filehash58_object` 中的 `hash_type` 项中使用`SHA-224`, `SHA-256`, `SHA-384`, `SHA-512` 之一。 		

**OpenSCAP 使用数据流文件而不是 XCCDF 文件**

​					SCAP 源数据流文件(`ssg-rhel9-ds.xml`)包含以前版本的 RHEL 中包含在 XCCDF 文件(`ssg-rhel9-xccdf.xml`)中的所有数据。SCAP 源数据流是一个容器文件，其包含执行合规性扫描所需的所有组件（XCCDF、OVAL 和 CPE）。从 RHEL 7 开始，建议使用 SCAP  源数据流而不是 XCCDF。在之前的 RHEL 版本中，XCCDF 文件和 SCAP 源数据流中的数据是重复的。在 RHEL 9  中，这种重复已被删除，以减少 RPM 软件包的大小。如果您的场景需要使用单独的文件而不是数据流，您可以使用这个命令分割数据流文件：`# oscap ds-split /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml output_directory`. 			

# 10.2. crypto-policies、RHEL 内核加密组件和协议

**弃用了 SHA-1**

​					在 RHEL 9 中，使用 SHA-1 签名在 DEFAULT 系统范围的加密策略中受到限制。除了 HMAC  外，TLS、DTLS、SSH、IKEv2、DNSSEC 和 Kerberos 协议中不再允许使用 SHA-1。没有由 RHEL  系统范围的加密策略控制的单个应用程序也在 RHEL 9 中使用 SHA-1 哈希。 			

​				如果您的场景需要使用 SHA-1 来验证现有或第三方加密签名，您可以输入以下命令启用它： 		



```none
# update-crypto-policies --set DEFAULT:SHA1
```

​				或者，您可以将系统范围的加密策略切换到 `LEGACY` 策略。请注意，`LEGACY` 也启用了很多不安全的其他算法。如需更多信息，请参阅 [RHEL 9 安全强化](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/security_hardening/index) 文档中的 [重新启用 SHA-1](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening#proc_re-enabling-sha-1_using-the-system-wide-cryptographic-policies) 部分。 		

​				有关仍需要 SHA-1 的系统的兼容性问题的解决方案，请查看以下 KCS 文章： 		

- ​						[从 RHEL 9 SSH 到 RHEL 6 系统无法正常工作](https://access.redhat.com/solutions/6816771) 				
- ​						[使用 SHA-1 签名的软件包无法安装或升级](https://access.redhat.com/solutions/6868611) 				
- ​						[与不支持"server-sig-algs"扩展的 SSH 服务器和客户端的连接失败](https://access.redhat.com/solutions/6954602) 				
- ​						[使用 RSASHA1 签名的 DNSSEC 记录无法验证](https://access.redhat.com/solutions/6955455) 				

**在所有策略级别禁用算法**

​					以下算法在 RHEL 9 提供的 `LEGACY`、`DEFAULT` 和 `FUTURE` 加密策略中被禁用： 			

- ​						早于版本 1.2 的 TLS （自 RHEL 9 开始，在 RHEL 8 中为 < 1.0） 				
- ​						早于 版本 1.2 的 DTLS （自 RHEL 9 开始，在 RHEL 8 中为 < 1.0） 				
- ​						DH 的参数 < 2048 位（自 RHEL 9 开始，在 RHEL 8 中是 < 1024 位） 				
- ​						RSA 的密钥大小 < 2048 位（自 RHEL 9 开始，在 RHEL 8 中是 < 1024 位） 				
- ​						DSA（自 RHEL 9 开始，在 RHEL 8 中是 < 1024 位） 				
- ​						3DES（自 RHEL 9 开始） 				
- ​						RC4（自 RHEL 9 开始） 				
- ​						FFDHE-1024 (自 RHEL 9 开始) 				
- ​						RbacConfig-DSS（自 RHEL 9 开始） 				
- ​						Camellia（自 RHEL 9 开始） 				
- ​						ARIA 				
- ​						SEED 				
- ​						IDEA 				
- ​						仅完整性密码套件 				
- ​						使用 SHA-384 HMAC 的 TLS CBC 模式密码组合 				
- ​						AES-CCM8 				
- ​						所有 ECC curves 与 TLS 1.3 不兼容，包括 secp256k1 				
- ​						IKEv1（自 RHEL 8 开始） 				

小心

​				如果您的场景需要禁用的策略，您可以通过应用自定义加密策略或明确配置单个应用程序来启用它，但不支持生成的配置。 		

**对 TLS 的更改**

​					在 RHEL 9 中，TLS 配置是使用系统范围的加密策略机制执行的。不再支持 1.2 以下的 TLS 版本。`DEFAULT`、`FUTURE` 和 `LEGACY` 加密策略只允许 TLS 1.2 和 1.3。如需更多信息，请参阅 [使用系统范围的加密策略](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)。 			

​				RHEL 9 中包含的库所提供的默认设置对于大多数部署来说已经足够安全了。TLS  实现尽可能使用安全算法，而不阻止来自或到旧客户端或服务器的连接。在具有严格安全要求的环境中应用强化设置，在这些环境中，不支持安全算法或协议的旧客户端或服务器不应连接或不允许连接。 		

**RHEL 9 不支持 SCP**

​					安全复制协议(SCP)协议不再被支持，因为它很难安全。它已经造成了安全问题，如 [CVE-2020-15778](https://access.redhat.com/security/cve/CVE-2020-15778)。在 RHEL 9 中，SCP 默认由 SSH 文件传输协议(SFTP)替代。 			

小心

​				默认情况下，SSH 无法从 RHEL 9 系统连接到旧的系统（例如，RHEL 6）或从旧的系统连接到 RHEL  9。这是因为旧版本中使用的加密算法现在被视为不安全。如果您的用例需要连接到旧的系统，您可以使用 ECDSA 和 ECDH  算法作为旧系统上的密钥，或者在 RHEL 9 系统中使用旧的加密策略。如需了解更多详细信息，请参阅 [从 RHEL 9 SSH 到 RHEL 6 系统不能工作](https://access.redhat.com/solutions/6816771) 和 [与不支持 server-sigalgs 扩展 的 SSH 服务器和客户端的连接失败](https://access.redhat.com/solutions/6954602)。 		

**默认禁用 OpenSSH root 密码登录**

​					RHEL 9 中 OpenSSH 的默认配置不允许用户以 `root` 身份使用密码登录，以防止攻击者获得对密码的暴力攻击。 			

**gnutls 不再支持 TPM 1.2**

​					GnuTLS 库不再支持受信任的平台模块(TPM)1.2 技术。通过 GnuTLS API 使用 TPM 的应用程序必须支持 TPM 2.0。 			

**gnutls 对 GOST 的支持已被删除**

​					在 RHEL 8 中，通过系统范围的加密策略禁用了 GOST 密码。在 RHEL 9 中，GnuTLS 库中删除了对这些加密机制的支持。 			

**`cyrus-sasl` 现在使用 GDBM 而不是 Berkeley DB**

​					`cyrus-sasl` 软件包构建时没有 `libdb` 依赖项，`sasldb` 插件使用 GDBM 数据库格式而不是 Berkeley DB。要迁移以旧 Berkeley DB 格式存储的现有简单身份验证和安全层(SASL)数据库，请使用 `cyrusbdb2current` 工具，语法如下： 			



```none
cyrusbdb2current <sasldb_path> <new_path>
```

**NSS 不再支持 DBM 和 `pk12util` 默认值更改**

​					网络安全服务(NSS)库不再支持对信任数据库的 DBM 文件格式。在 RHEL 8 中，SQLite 文件格式是默认格式，现有的  DBM 数据库以只读模式打开，并自动转换为 SQLite。升级到 RHEL 9 之前，请将所有信任数据库从 DBM 更新到 SQLite。 			

​				另外，`pk12util` 工具现在在导出私钥时默认使用 AES 和 SHA-256 算法而不是 DES-3 和 SHA-1。 		

​				请注意，RHEL 9 中所有签名的默认系统范围的加密策略禁用了 SHA-1。 		

**NSS 不再支持少于 1023 位的 RSA 密钥**

​					网络安全服务(NSS)库的更新将所有 RSA 操作的最小密钥大小从 128 位改为 1023 位。这意味着 NSS 不再执行以下功能： 			

- ​						生成大于 1023 位的 RSA 密钥。 				
- ​						使用 RSA 密钥签名或验证 RSA 签名少于 1023 位。 				
- ​						使用 RSA 密钥加密或解密值少于 1023 位。 				

**FIPS 模式不支持 openssl ENGINE 扩展 API**

​					传统的适用于 OpenSSL 的扩展系统(ENGINE API)与新供应商 API 不兼容。因此，依赖于 OpenSSL 引擎提供功能的应用程序，如 `openssl-pkcs11` 和 `openssl-ibmca` 模块无法在 FIPS 模式中使用。 			

**OpenSSL 中的 FIPS 模式必须启用才能正常工作**

​					如果您在启用了 FIPS 模式的 `openssl.cnf` 配置文件中使用非默认值，特别是在使用第三方 FIPS 提供程序时，请将 `fips=1` 添加到 `openssl.cnf` 文件中。 			

**OpenSSL 在 FIPS 模式下不接受显式 curve 参数**

​					指定显式 curve 参数的 Elliptic curve 加密参数、私钥、公钥和证书不能在 FIPS 模式下继续工作。使用  ASN.1 对象标识符（其使用 FIPS 批准的 curve 之一）指定 curve 参数，仍可在 FIPS 模式下继续工作。 			

**libreswan 现在默认请求 ESN**

​					在 Libreswan 中，配置选项 `esn=` 的默认值已从 `no` 改为 `either`。这意味着，在启动连接时，Libreswan 会默认请求使用扩展序列号(ESN)。特别是，当使用硬件卸载时，这个新行为会防止某些网络接口卡(NIC)在不支持 ESN 时建立 IPsec 连接。要禁用 ESN，将 `esn=` 设为 `no`，将 `replay_window=` 选项设为 32 或更小的值。例如： 			



```none
  esn=no
  replay_window=32
```

​				`replay_window=` 选项是必需的，因为不同的机制使用 ESN 进行窗口大小大于 32 的反重放保护。 		

# 10.3. SELinux

**删除了通过 `/etc/selinux/config` 禁用 SELinux 的支持**

​					在这个版本中，支持通过 `/etc/selinux/config` 文件中的 `SELINUX=disabled` 选项禁用 SELinux。当您只通过 `/etc/selinux/config` 禁用 SELinux 时，系统会以启用了 SELinux 的方式启动，但没有加载策略，SELinux 安全钩子仍注册在内核中。这意味着，通过 `/etc/selinux/config` 禁用的 SELinux 仍然需要一些系统资源，您应该最好在所有性能敏感的情况下通过内核命令行禁用。 			

​				另外，Anaconda 安装程序和相应的 man page 已被更新以反映这个更改。此更改还为 Linux 安全模块(LSM)hook 启用只读初始保护功能。 		

​				如果您需要禁用 SELinux，请在内核命令行中添加 `selinux=0` 参数。 		

​				如需更多信息，请参阅 [删除对 SELinux 运行时禁用](https://fedoraproject.org/wiki/Changes/Remove_Support_For_SELinux_Runtime_Disable) Fedora wiki 页面。 		

## 7.1. 时间同步

​				因为许多原因，系统准确计时非常重要。在 Linux 系统中，`Network Time Protocol (NTP)` 协议由在用户空间运行的守护进程实现。 		

### 7.1.1. NTP 的实现

​					RHEL 7 支持 `NTP` 协议的两个实现： **ntp** 和 **chrony**。 			

​					在 RHEL 8 中，`NTP` 协议仅由 `chronyd` 守护进程实施，由 `chrony` 软件包提供。 			

​					`ntp` 守护进程不再可用。如果您在 RHEL 7 系统中使用了 `ntp`，可能需要[迁移至 chrony](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#migrating-to-chrony_using-chrony-to-configure-ntp)。 			

​					之前被 chrony 支持的 **ntp** 功能的替代信息包括在 Achgradeing 中,在 **chrony** 中被 [ntp 支持的一些设置中](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#achieving-settings-supported-by-ntp_using-chrony-to-configure-ntp)。 			

### 7.1.2. chrony 套件介绍

​					**chrony** 是 `NTP` 的实现，它在多数情况下表现良好,包括持续的网络连接、有大量网络数据的网络、温度不稳定（普通计算机时钟对温度敏感）以及不持续运行或在虚拟机上运行的系统。 			

​					您可以使用 **chrony**: 			

- ​							将系统时钟与 `NTP` 服务器同步 					
- ​							将系统时钟与参考时钟同步，如 GPS 接收器 					
- ​							将系统时钟与手动时间输入同步 					
- ​							作为 `NTPv4(RFC 5905)` 服务器或 peer 为网络中的其他计算机提供时间服务 					

​					有关 **chrony** 的更多信息，请参阅[配置基本系统设置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#chrony-intro_using-chrony-to-configure-ntp)。 			

#### 7.1.2.1. chrony 和 ntp 之间的差别

​						有关 **chrony** 和 **ntp** 之间的区别，请参见以下资源： 				

- ​								[配置基本系统设置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#differences-between-ntp-and-chrony_using-chrony-to-configure-ntp) 						
- ​								[NTP 实现对比](https://chrony.tuxfamily.org/comparison.html) 						

##### 7.1.2.1.1. Chrony 会默认应用闰秒调整

​							在 RHEL 8 中，默认 **chrony** 配置文件 `/etc/chrony.conf` 包括 `leapsectz` 指令。 					

​							`leapsectz` 指令启用 `chronyd` 进行： 					

- ​									从系统 tz 数据库获取有关闰秒（leap second）的信息（`tzdata`） 							
- ​									设置系统时钟的 TAI-UTC 偏移,以便系统提供准确的 Atomic Time(TAI)时钟(CLOCK_TAI) 							

​							该指令与那些使用 `leap smear` 的客户端隐藏闰秒的服务器不兼容,比如使用 `leapsecmode` 和 `smoothtime` 指令配置的 `chronyd` 服务器。如果将客户端 `chronyd` 配置为同步这样的服务器，请从配置文件中删除 `leapsectz`。 					

### 7.1.3. 附加信息

​					有关如何使用 **chrony** 套件配置 `NTP` 的更多信息，请参阅[配置基本系统设置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#using-chrony-to-configure-ntp)。 			

## 7.2. BIND - DNS 的实现

​				RHEL 8 在包含 BIND（Berkeley Internet Name Domain）版本 9.11。与版本 9.10 相比，这个版本的 DNS 服务器引入了多个新功能和功能变化。 		

​				新特性： 		

- ​						添加了一个新的置备二级服务器的方法,称为 **Catalog Zones**。 				
- ​						Domain Name System Cookies 现在由 `named` 服务和 `dig` 工具程序发送。 				
- ​						现在，**Response Rate Limiting** 功能可以帮助缓解 DNS 扩展攻击。 				
- ​						提高了 response-policy 区(RPZ)的性能。 				
- ​						添加了名为 `map` 的新区文件格式。以这种格式存储的区域数据可直接映射到内存中,这样区域可以更快地加载。 				
- ​						添加了名为 `delv` （域实体查找和验证）的新工具,其中包含用于查找 DNS 数据以及执行内部 DNS 安全扩展(DNSSEC)验证的类似语义的语义。 				
- ​						新的 `mdig` 命令现在可用。这个命令是 `dig` 命令的一个版本，它会发送多个管道形式的查询，然后等待响应，而不是只发送一个查询，并等待其响应才发送下一个查询。 				
- ​						添加了一个新的 `prefetch` 选项来提高递归解析器性能。 				
- ​						添加了一个新的 `in-view` 区选项，它允许在视图间共享区数据。当使用这个选项时，多个视图可以在不需要在内存中存储多个副本的情况下为相同的区域服务。 				
- ​						添加了一个新的 `max-zone-ttl` 选项，它强制执行区的最大 TTL。当加载包含更高 TTL 的区域时，加载会失败。带有更高 TTL 的动态 DNS（DDNS）更新会被接受，但 TTL 会被截断。 				
- ​						添加了新的配额,以限制递归解析器向有拒绝服务攻击的权威服务器发送的查询。 				
- ​						`nslookup` 工具现在默认查找 IPv6 和 IPv4 地址。 				
- ​						`named` 服务现在在启动前检查其他名称服务器进程是否正在运行。 				
- ​						载入签名区时, `named` 现在会检查资源记录签名的(RSIG)时间是否在以后,如果是,它会立即重新生成 RRSIG。 				
- ​						区传输现在使用较小的消息大小来改进消息压缩,这可减少网络使用。 				

​				功能更改： 		

- ​						HTTP 接口提供了统计频道的版本 `3 XML` 模式，其中包括新统计数据和用于更快解析的 XML 树。旧版本 `2 XML` 模式不再被支持。 				
- ​						`named` 服务现在默认侦听 IPv6 和 IPv4 接口。 				
- ​						`named` 服务不再支持 GeoIP。由查询发送方假定位置定义的访问控制列表（ACL）不可用。 				

## 7.3. DNS 解析

​				在 RHEL 7 中，`nslookup` 和 `host` 工具可以接受任何来自任何名称服务器列出的没有 `recursion available` 标记的回复。在 RHEL 8 中，`nslookup` 和 `host` 会忽略来自 recursion 不可用的名称服务器的回复，除非它是最后一个配置的名称服务器。如果是最后配置的名称服务器，即使没有 `recursion available` 标志，也可以接受回复。 		

​				但是，如果最后配置的域名服务器无法响应或者无法访问，名字解析会失败。要防止这种失败，您可以使用以下方法之 一 : 		

- ​						确定配置的域名服务器总是使用 `recursion available` 标志进行回复。 				
- ​						允许为所有内部客户端进行 recursion。 				

​				另外，您还可以使用 `dig` 工具来检测是否可以进行 recursion。 		

## 7.4. postfix

​				在 RHEL 8 中, `Postfix` 使用带有 TLS 的 MD5 指纹进行向后兼容。但是在 FIPS 模式中, MD5 hashing 功能不可用,这可能会导致 TLS 在默认 `Postfix` 配置中正常工作。作为临时解决方案, hashing 功能需要改为 postfix 配置文件中的 `SHA-256`。 		

​				如需了解更多详细信息,请参阅相关链接： https://access.redhat.com/articles/5824391 		

## 7.5. 打印

### 7.5.1. 打印设置工具

​					RHEL 7 中使用的 **Print Settings** 配置工具不再可用。 			

​					要实现各种与打印相关的任务，您可以选择以下工具之 一 : 			

- ​							**CUPS Web 用户界面(UI)** 					
- ​							**GNOME 控制中心** 					

​					有关 RHEL 8 中打印设置工具的更多信息，请参阅 [部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/#print-settings-tools_configuring-printing)。 			

### 7.5.2. CUPS 日志的位置

​					CUPS 提供三种日志： 			

- ​							错误日志 					
- ​							访问日志 					
- ​							页面日志 					

​					在 RHEL 8 中，日志不再存储在 /var/log/cups 目录下的特定文件中，这些文件在 RHEL 7 中使用。相反，所有三种类型都会通过 systemd-journald，集中记录来自其他程序的日志。 			

​					有关如何在 RHEL 8 中使用 CUPS 日志的更多信息，请参阅 [部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/#working-with-cups-logs_configuring-printing)。 			

### 7.5.3. 附加信息

​					有关如何在 RHEL 8 中配置打印的更多信息，请参阅[部署不同类型的服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/index#configuring-printing_Deploying-different-types-of-servers)。 			

## 7.6. 性能和电源管理选项

### 7.6.1. 推荐的 Tuned 配置集中显著更改

​					在 RHEL 8 中，根据以下规则选择由 `tuned-adm recommend` 命令报告的推荐的 Tuned 配置集： 			

- ​							如果 `syspurpose` 角色（由 `syspurpose show` 命令报告）包含 `atomic`，同时： 					
  - ​									如果 Tuned 在裸机中运行，则会选择 `atomic-host` 配置集 							
  - ​									如果 Tuned 在虚拟机中运行，则会选择 `atomic-guest` 配置集 							
- ​							如果 Tuned 在虚拟机中运行，则会选择 `virtual-guest` 配置集 					
- ​							如果 `syspurpose` 角色包含 `desktop` 或 `workstation`，且机箱类型（由 `dmidecode`报告）是 `Notebook`、`Laptop` 或 `Portable`，则会选择 `balanced` 配置集 					
- ​							如果以上规则都不匹配，则会选择 `throughput-performance` 配置集 					

​					请注意，第一个匹配的规则会起作用。 			

## 7.7. 基础架构服务组件的其它变化

​				本节总结了对特定基础架构服务组件的其他显著变化。 		

**表 7.1. 基础架构服务组件的显著变化**

| Name         | 更改类型               | 附加信息                                                     |
| ------------ | ---------------------- | ------------------------------------------------------------ |
| acpid        | 选项的更改             | `-d` （debug）不再代表 `-f`（foreground）                    |
| bind         | 配置选项删除           | `dnssec-lookaside auto` 已删除，使用 `no` 替代               |
| brltty       | 配置选项更改           | `--message-delay brltty` 重命名为 `--message-timeout`        |
| brltty       | 配置选项删除           | `-U [--update-interval=]` 删除                               |
| brltty       | 配置选项更改           | 现在，蓝牙设备地址可能包含横线（-）而不是冒号（:）。不再支持 `bth:` 和 `bluez:` 设备限定别名。 |
| cups         | 删除功能               | 由于安全原因，上游删除了接口脚本的支持。使用 OS 或商用商提供的 ppd 和驱动。 |
| cups         | 指令选项删除           | 删除了 `/etc/cups/cupsd.conf` 中的 AuthType 和 DefaultAuthType 指令的 `Digest` 和 `BasicDigest` 验证类型。迁移到 `Basic`。 |
| cups         | 指令选项删除           | 从 `cupsd.conf` 中删除 `Include`                             |
| cups         | 指令选项删除           | 从 `cups-files.conf` 中删除了 `ServerCertificate` 和 `ServerKey`，使用 `Serverkeychain` 替代 |
| cups         | 在配置文件间移动的指令 | `SetEnv` 和 `PassEnv` 从 `cupsd.conf` 移到 `cups-files.conf` |
| cups         | 在配置文件间移动的指令 | `PrintcapFormat` 从 `cupsd.conf` 移动到 `cups-files.conf`    |
| cups-filters | 默认配置更改           | 由 cups-browsed 发现的远程打印队列的名称现在根据打印机的设备 ID 而不是远程打印队列的名称创建。 |
| cups-filters | 默认配置更改           | `CreateIPPPrinterQueues` 需要设置为 `All` 来自动创建 IPP 打印机队列 |
| cyrus-imapd  | 数据格式更改           | Cyrus-imapd 3.0.7 有不同的数据格式。                         |
| dhcp         | 行为更改               | `dhclient` 默认将硬件地址作为客户端标识符发送。`client-id` 选项是可配置的。如需更多信息，请参阅 `/etc/dhcp/dhclient.conf` 文件。 |
| dhcp         | 选项不兼容             | `-I` 选项现在用于 standard-ddns-updates。对于以前的功能（dhcp-client-identifier），使用新的 `-C` 选项。 |
| dosfstools   | 行为更改               | 数据结构现在会自动与集群大小保持一致。要禁用协调，使用 `-a` 选项。`fsck.fat` 现在默认使用交互式修复模式，在以前需要通过 `-r` 选项进行选择。 |
| finger       | 删除功能               |                                                              |
| GeoIP        | 删除功能               |                                                              |
| grep         | 行为更改               | 现在，`grep` 会将包含了没有适当地对当前的语言进行编码的数据的文件视为二进制文件。 |
| grep         | 行为更改               | `grep -P` 不再报告错误并在给出无效 UTF-8 数据时退出          |
| grep         | 行为更改               | `grep` 现在在使用 GREP_OPTIONS 环境变量时会发出警告。使用别名或脚本来替代。 |
| grep         | 行为更改               | 现在，当使用多字节字符的语言使用 UTF-8 以外的编码时，`grep -P` 会报告错误并退出 |
| grep         | 行为更改               | 当搜索二进制数据时, `grep` 可能会将非文本字节视为行终止器,这会显著影响性能。 |
| grep         | 行为更改               | `grep -z` 不再自动将字节 '\200' 视为二进制数据。             |
| grep         | 行为更改               | 因为 `-m`,上下文不再排除所选行被忽略。                       |
| irssi        | 行为更改               | `SSLv2` `SSLv3` 不再被支持                                   |
| lftp         | 更改选项               | `xfer:log` 和 `xfer:log-file`deprecated; now available under `log:enabled` 和 `log:file` 命令 |
| ntp          | 删除功能               | 已删除 NTP，改为使用 chrony                                  |
| postfix      | 配置更改               | 3.X 版本具有兼容性安全网络,可在升级后运行带有向后兼容默认设置的 Postfix 程序。 |
| postfix      | 配置更改               | 在 Postfix MySQL 数据库客户端中，默认的 options_group 值已改为 `client`，并将其设置为空值以向后兼容行为。 |
| postfix      | 配置更改               | postqueue 命令不再强制在 UTC 中报告所有消息。要获得旧行为，在 `main.cf:import_environment` 中设置 `TZ=UTC`。例如： 						 						  							`import_environment = MAIL_CONFIG MAIL_DEBUG MAIL_LOGTAG TZ=UTC XAUTHORITY DISPLAY LANG=C.` |
| postfix      | 配置更改               | ECDHE - `smtpd_tls_eecdh_grade` 默认为 `auto`; 新参数 `tls_eecdh_auto_curves` 带有可能为 curves 的名称 |
| postfix      | 配置更改               | 更改了 `append_dot_mydomain` 的默认值（现在为 no，过去为 yes）、`master.cf chroot` （现在为 n，过去为 y）、`smtputf8`（现在为 yes，过去为 no）。 |
| postfix      | 配置更改               | 更改了 `relay_domains` 的默认值（现在为 empty，过去为 $mydestination）。 |
| postfix      | 配置更改               | `mynetworks_style` 默认值已从 `subnet` 更改为 `host`。       |
| powertop     | 选项删除               | `-d` 删除                                                    |
| powertop     | 选项的更改             | `-h` 不再是 `--html` 的别名。现在它是 `--help` 的别名。      |
| powertop     | 选项删除               | `-u` 删除                                                    |
| quagga       | 删除功能               |                                                              |
| sendmail     | 配置更改               | 发送电子邮件默认使用未压缩的 IPv6 地址,这使零子网有更具体的匹配。配置数据必须使用相同的格式,因此请确定在使用 8.15 前更新 `IPv6:[0-9a-fA-F:]*::` 和 `IPv6::` 等模式。 |
| spamassasin  | 命令行选项删除         | 删除了 spamd 中的 `--ssl-version`。                          |
| spamassasin  | 命令行选项更改         | 在 spamc 中，命令行选项 `-S/--ssl` 不再用于指定 SSL/TLS 版本。现在，这个选项只能在没有参数的情况下被使用来启用 TLS。 |
| spamassasin  | 支持的 SSL 版本更改    | 在 spamc 和 spamd 中，SSLv3 不再被支持。                     |
| spamassasin  | 删除功能               | `sa-update` 不再支持 SHA1 验证过滤规则，而是使用 SHA256/SHA512 验证。 |
| vim          | 默认设置更改           | 如果没有 ~/.vimrc 文件，vim 运行 default.vim 脚本。          |
| vim          | 默认设置更改           | Vim 现在支持来自终端的粘贴操作。在 vimrc 中包含 'set t_BE=' 用于以前的行为。 |
| vsftpd       | 默认配置更改           | `anonymous_enable` 禁用                                      |
| vsftpd       | 默认配置更改           | `strict_ssl_read_eof` 现在默认为 YES                         |
| vsftpd       | 删除功能               | `tcp_wrappers` 不再支持                                      |
| vsftpd       | 默认配置更改           | TLSv1 和 TLSv1.1 默认禁用                                    |
| wireshark    | Python 绑定删除        | 不再能够使用 Python 编写 Dissectors，而是使用 C。            |
| wireshark    | 选项删除               | 用于异步 DNS 名称解析的 `-N` 选项的 `-C` 子选项已删除        |
| wireshark    | 输出更改               | 使用 `-H` 选项，输出不再显示 SHA1、RIPEMD160 和 MD5 哈希。现在显示 SHA256、RIPEMD160 和 SHA1 哈希。 |
| wvdial       | 删除功能               |                                                              |

## Security

### 软件更新

### 安全更新

显示 **没有** 在主机上安装的安全更新

```bash
yum updateinfo list updates security
```

显示在主机上安装的安全更新

```bash
yum updateinfo list security installed				
```

使用 yum 显示具体公告信息。			

```bash
# 显示 RHSA-2019:0997 公告详情	
yum updateinfo info RHSA-2019:0997

====================================================================
  Important: python3 security update
====================================================================
  Update ID: RHSA-2019:0997
       Type: security
    Updated: 2019-05-07 05:41:52
       Bugs: 1688543 - CVE-2019-9636 python: Information Disclosure due to urlsplit improper NFKC normalization
       CVEs: CVE-2019-9636
Description: ...	
```

安装所有可用的安全更新

```bash
yum update --security
```

列出安装更新的软件包后需要手动重启系统的进程： 				

```bash
yum needs-restarting

1107 : /usr/sbin/rsyslogd -n
1199 : -bash
```

**注意:** 这个命令只列出需要重启的进程,而不包括服务。这意味着您无法使用 `systemctl` 重启所有列出的进程。例如,当拥有此进程的用户注销时,输出中的 `bash` 进程会被终止。

安装特定公告提供的安全更新	

```bash
yum update --advisory=RHSA-2019:0997
```


## 8.1. 更改核心加密组件

### 8.1.1. 默认应用系统范围的加密策略

​					Crypto-policies 是 Red Hat Enterprise Linux 8 中的一个组件，它配置核心加密子系统，包括  TLS、IPsec、DNSSEC、Kerberos 协议以及 OpenSSH 套件。它提供一组策略，管理员可以使用 `update-crypto-policies` 命令进行选择。 			

​					`DEFAULT` 系统范围的加密策略为当前的威胁模型提供安全设置。它允许 TLS 1.2 和 1.3 协议，以及 IKEv2 和 SSH2 协议。如果超过 2047 位,则接受 RSA 密钥和 Diffie-Hellman 参数。 			

​					详情请查看 [Red Hat 博客的 Red Hat Enterprise Linux 8 文章和 `update-crypto-policies(8)` man page 中的使用加密策略](https://www.redhat.com/en/blog/consistent-security-crypto-policies-red-hat-enterprise-linux-8) 的安全性。 			

### 8.1.2. 强大的加密默认方法是删除不安全的密码套件和协议

​					以下列表包含从 RHEL 8 核心加密库中删除的密码套件和协议。它们不存在于源中,或者它们在构建期间被禁用支持,因此应用程序无法使用它们。 			

- ​							DES（自 RHEL 7 开始） 					
- ​							所有导出等级的密码套件（自 RHEL 7 开始） 					
- ​							MD5 以签名（自 RHEL 7 开始） 					
- ​							SSLv2（自 RHEL 7 开始） 					
- ​							SSLv3（自 RHEL 8 开始） 					
- ​							所有 ECC curves < 224 位（自 RHEL 6 开始） 					
- ​							所有二进制字段 ECC 策展（自 RHEL 6 开始） 					

### 8.1.3. 在所有策略级别中禁用了密码套件和协议

​					下面的密码套件和协议在所有加密策略级别都被禁用。它们只能通过明确配置单个应用程序来启用。 			

- ​							DH 带有参数 < 1024 位 					
- ​							RSA 带有密钥大小 < 1024 位 					
- ​							Camellia 					
- ​							ARIA 					
- ​							SEED 					
- ​							IDEA 					
- ​							只使用完整性加密套件 					
- ​							使用 SHA-384 HMAC 的 TLS CBC 模式密码组合 					
- ​							AES-CCM8 					
- ​							所有 ECC curves 与 TLS 1.3 不兼容，包括 secp256k1 					
- ​							IKEv1（自 RHEL 8 开始） 					

### 8.1.4. 将系统切换到 FIPS 模式

​					系统范围的加密策略包含一个策略级别,它允许根据美国信息处理标准(FIPS)公共 140-2 的要求进行加密模块自我检查。在内部启用或禁用 FIPS 模式的 `fips-mode-setup` 工具使用 `FIPS` 系统范围的加密策略级别。 			

​					要在 RHEL 8 中将系统切换成 FIPS 模式，请输入以下命令并重启您的系统： 			

```
# fips-mode-setup --enable
```

​					详情请查看 `fips-mode-setup(8)` man page。 			

### 8.1.5. TLS 1.0 和 TLS 1.1 已弃用

​					TLS 1.0 和 TLS 1.1 协议在 `DEFAULT` 系统范围的加密策略级别被禁用。如果需要使用启用的协议，如 Firefox 网页浏览器中的视频检查程序，把系统范围的加密策略切换到 `LEGACY` 级别： 			

```
# update-crypto-policies --set LEGACY
```

​					如需更多信息，请参阅红帽客户门户网站中的 [RHEL 8 中的强加密默认设置以及弃用的弱加密算法](https://access.redhat.com/articles/3642912)，以及 `update-crypto-policies(8)` man page。 			

### 8.1.6. 加密库中的 TLS 1.3 支持

​					这个版本在所有主后端加密库中默认启用传输层安全(TLS)1.3。这启用了操作系统通信层的低延迟,并利用新的算法（如 RSA-PSS 或 X25519）提高应用程序的隐私和安全性。 			

### 8.1.7. 在 RHEL 8 中弃用 DSA

​					数字签名算法(DSA)在 Red Hat Enterprise Linux 8 中被视为已弃用。依赖于 DSA 密钥的身份验证机制在默认配置中不起作用。请注意，即使 `LEGACY` 系统范围的加密策略级别中，`OpenSSH` 客户端都不接受 DSA 主机密钥。 			

### 8.1.8. `SSL2` `Client Hello` 已在 `NSS` 中弃用

​					传输层安全（`TLS`）协议版本 1.2 及更早版本允许与 `Client Hello` 消息进行协商，其格式与安全套接字层（`SSL`）协议版本 2 后兼容。网络安全服务（`NSS`）库中对这个功能的支持已被弃用，默认是禁用的。 			

​					需要这个功能支持的应用程序需要使用新的 `SSL_ENABLE_V2_COMPATIBLE_HELLO` API 启用它。以后的 Red Hat Enterprise Linux 8 版本中可以完全删除对这个功能的支持。 			

### 8.1.9. NSS 现在默认使用 SQL

​					Network Security Services(NSS)库现在默认为信任数据库使用 SQL  文件格式。在以前的版本中,作为默认数据库格式的 DBM 文件格式不支持被多个进程并发访问同一数据库,且在上游社区已弃用。因此,使用 NSS  信任数据库存储密钥、证书和撤销信息的应用程序现在默认以 SQL 格式创建数据库。尝试使用旧的 DBM 格式创建数据库会失败。现有 DBM  数据库以只读模式打开，它们会自动转换为 SQL 格式。请注意，自 Red Hat Enterprise Linux 6 之后，NSS 支持  SQL 文件格式。 			

## 8.2. SSH

### 8.2.1. `OpenSSH` rebase 到版本 7.8p1

​					`openssh` 软件包已升级到上游版本 7.8p1。主要变更包括： 			

- ​							删除了对 `SSH version 1` 协议的支持。 					
- ​							删除了对 `hmac-ripemd160` 消息验证代码的支持。 					
- ​							删除了对 RC4（`arcfour`）加密的支持。 					
- ​							删除了对 `Blowfish` 加密的支持。 					
- ​							删除了对 `CAST` 加密的支持。 					
- ​							将 `UseDNS` 选项的默认值改为 `no`。 					
- ​							默认禁用 `DSA` 公钥算法。 					
- ​							将 `Diffie-Hellman` 参数的最小 modulus 大小改为 2048 字节。 					
- ​							更改 `ExposeAuthInfo` 配置选项的语义。 					
- ​							`UsePrivilegeSeparation=sandbox` 选项现在是必须的且无法禁用。 					
- ​							最小接受的 `RSA` 密钥大小为 1024 字节。 					

### 8.2.2. `libssh` 实现 SSH 作为核心加密组件

​					在 Red Hat Enterprise Linux 8 中引进了 `libssh` 作为核心加密组件。`libssh` 库实施安全 SHell(SSH)协议。 			

​					请注意，`libssh` 不遵循系统范围的加密策略。 			

### 8.2.3. `libssh2` 在 RHEL 8 中不再可用

​					弃用的 `libssh2` 库丢失了功能,比如对 elliptic curves 或通用安全服务应用程序接口(GSSAPI)的支持,它已从 RHEL 8 中删除,而是使用它。 `libssh` 			

## 8.3. Rsyslog

### 8.3.1. 现在，默认的 `rsyslog` 配置文件格式为 non-legacy

​					`rsyslog` 软件包中的配置文件现在默认使用 non-legacy 格式。旧（legacy）格式仍可以被使用，但在混合使用新的配置格式和旧的配置格式语句时会有一些限制。需要检查来自以前的 RHEL 版本的配置。详情请查看 `rsyslog.conf(5)` man page。 			

### 8.3.2. 增加了一个 `imjournal` 选项用来配置系统日志以最小化使用 `journald`

​					为了避免当 `journald` 轮转其文件时可能会出现的重复记录，添加了 `imjournal` 选项。请注意，使用这个选项可能会影响性能。 			

​					请注意,使用 `rsyslog` 的系统可以被配置为提供更好的性能,如 [配置无 journald 系统日志或最小化日志用量](https://access.redhat.com/articles/4058681) 知识库文章中所述。 			

### 8.3.3. 默认日志设置在性能上的负面影响

​					默认日志环境设置可能会消耗 4 GB 内存甚至更多，当 `systemd-journald` 使用 `rsyslog` 运行时，速率限制值的调整会很复杂。 			

​					如需更多信息，请参阅 [RHEL 默认日志设置对性能的负面影响及环境方案](https://access.redhat.com/articles/4095141)。 			

## 8.4. OpenSCAP

### 8.4.1. 合并 OpenSCAP API

​					此更新提供了已合并的 OpenSCAP 共享库 API。删除了 63 个符号，添加了 14， 4 个有更新的签名。OpenSCAP 1.3.0 里删除的符号包括： 			

- ​							在 1.2.0 版本中标记为已弃用的符号 					
- ​							SEAP 协议符号 					
- ​							内部帮助程序功能 					
- ​							未使用的库符号 					
- ​							未实现的符号 					

### 8.4.2. `oscap-podman` 替换了 `oscap-docker` 以进行容器的安全和合规扫描

​					在 RHEL 8.2 中,增加了一个新的用于容器安全和合规性扫描工具。`oscap-podman` 工具与 `oscap-docker` 实用程序相同，用于在 RHEL 7 中扫描容器和容器镜像。 			

​					如需更多信息,请参阅 [扫描容器和容器镜像中的漏洞](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/index) 部分。 			

## 8.5. Audit

### 8.5.1. Audit 3.0 将 `audispd` 替换为 `auditd`

​					在这个版本中，`audispd` 的功能被移到 `auditd`。因此, `audispd` 配置选项现在是 `auditd.conf` 的一部分。另外, `plugins.d` 目录已移到 `/etc/audit` 下。现在,通过运行 `service auditd state` 命令可以检查 `auditd` 的当前状态及其插件。 			

## 8.6. SELinux

### 8.6.1. SELinux 软件包迁移到 Python 3

- ​							`policycoreutils-python` 已被 `policycoreutils-python-utils` 和 `python3-policycoreutils` 软件包替代。 					
- ​							`libselinux-python` 软件包的功能现在由 `python3-libselinux` 软件包提供。 					
- ​							`setools-libs` 软件包的功能现在由 `python3-setools` 软件包提供。 					
- ​							`libsemanage-python` 软件包的功能现在由 `python3-libsemanage` 软件包提供。 					

### 8.6.2. SELinux 子软件包的更改

- ​							`libselinux-static`、`libsemanage-static`、`libsepol-static` 和 `setools-libs-tcl` 已被删除。 					
- ​							RHEL 8.0 和 8.1 不提供 `setools-gui` 和 `setools-console-analyses`。RHEL 8.2 是包含这些子软件包的 RHEL 8 的第一个次要版本。 					

### 8.6.3. SELinux 策略的更改

​					`init_t` 域类型不再在 RHEL 8 中不受限制。这可能会对使用不同 SELinux 标记方法的第三方应用程序造成问题。 			

​					要解决非标准位置中的 SELinux 标记问题,您可以为此类位置配置文件上下文对等。 			

1. ​							为 `/my/apps` 和 `/` 目录配置文件上下文对等： 					

   ```
   # semanage fcontext -a -e / /my/apps
   ```

2. ​							通过列出 SELinux 策略的本地自定义来验证文件上下文对等： 					

   ```
   # semanage fcontext -l -C
   
   SELinux Local fcontext Equivalence
   
   /my/apps = /
   ```

3. ​							将 `/my/apps` 的上下文恢复为默认值,它等同于 `/` 上下文： 					

   ```
   # restorecon -Rv /my/apps
   restorecon reset /my/apps context unconfined_u:object_r:default_t:s0->unconfined_u:object_r:root_t:s0
   restorecon reset /my/apps/bin context unconfined_u:object_r:default_t:s0->unconfined_u:object_r:bin_t:s0
   restorecon reset /my/apps/bin/executable context unconfined_u:object_r:default_t:s0->unconfined_u:object_r:bin_t:s0
   ```

​					这个方法为安装在非标准位置的大多数文件和目录分配正确的标签,这也会导致一些可执行文件启动的进程被正确标记。 			

​					要删除文件上下文对等性,请使用以下命令： 			

```
# semanage fcontext -d -e / /my/apps
```

- ​							详情请查看 `semanage-fcontext` man page。 					

### 8.6.4. SELinux 布尔值的更改

#### 8.6.4.1. 新 SELinux 布尔值

​						这个 SELinux 系统策略更新引进了以下布尔值： 				

- ​								`colord_use_nfs` 						
- ​								`deny_bluetooth` 						
- ​								`httpd_use_opencryptoki` 						
- ​								`logrotate_use_fusefs` 						
- ​								`mysql_connect_http` 						
- ​								`pdns_can_network_connect_db` 						
- ​								`ssh_use_tcpd` 						
- ​								`sslh_can_bind_any_port` 						
- ​								`sslh_can_connect_any_port` 						
- ​								`tor_can_onion_services` 						
- ​								`unconfined_dyntrans_all` 						
- ​								`use_virtualbox` 						
- ​								`virt_sandbox_share_apache_content` 						
- ​								`virt_use_pcscd` 						

#### 8.6.4.2. 删除的 SELinux 布尔值

​						以前版本中提供的以下布尔值在 RHEL 8 SELinux 策略中不提供： 				

- ​								`container_can_connect_any` 						
- ​								`ganesha_use_fusefs` 						

#### 8.6.4.3. 更改默认值

​						在 RHEL 8 中，以下 SELinux 布尔值被设置为与上一版本不同的默认值： 				

- ​								`domain_can_map_files` 现在默认为 `off`。 						
- ​								`httpd_graceful_shutdown` 现在默认为 `off`。 						
- ​								`mozilla_plugin_can_network_connect` 现在默认为 `on`。 						
- ​								`named_write_master_zones` 现在默认为 `on`。 						

​						另外, `antivirus_use_jit` 和 `ssh_chroot_rw_homedirs` 布尔值的描述已被更改。 				

​						要获得包括布尔值的列表,并找出它们是否启用或禁用,请安装 `selinux-policy-devel` 软件包并使用： 				

```
# semanage boolean -l
```

### 8.6.5. SELinux 端口类型更改

​					RHEL 8 SELinux 策略提供以下额外端口类型： 			

- ​							`appswitch_emp_port_t` 					
- ​							`babel_port_t` 					
- ​							`bfd_control_port_t` 					
- ​							`conntrackd_port_t` 					
- ​							`firepower_port_t` 					
- ​							`nmea_port_t` 					
- ​							`nsca_port_t` 					
- ​							`openqa_port_t` 					
- ​							`openqa_websockets_port_t` 					
- ​							`priority_e_com_port_t` 					
- ​							`qpasa_agent_port_t` 					
- ​							`rkt_port_t` 					
- ​							`smntubootstrap_port_t` 					
- ​							`statsd_port_t` 					
- ​							`versa_tek_port_t` 					

​					另外，`dns_port_t` 和 `ephemeral_port_t` 端口类型的定义已改变，并删除了 `gluster_port_t` 端口类型。 			

### 8.6.6. `sesearch` 使用方式的更改

- ​							`sesearch` 命令不再使用 `-C` 选项，它需要包含条件表达式。 					
- ​							`-T`、`--type` 选项已更改为： 					
  - ​									`-T`, `--type_trans` - 查找 type_transition 规则。 							
  - ​									`--type_member` - 查找 type_member 规则。 							
  - ​									`--type_change` - 找到 type_change 规则。 							

## 8.7. 删除的安全功能

### 8.7.1. `shadow-utils` 不再允许完全由数字组成的用户名和组群名称

​					`useradd` 和 `groupadd` 命令不允许完全由数字组成的用户名和组名。不允许此类名称的原因是，这可能会导致很多工具混淆用户和组群名称以及用户和组群  ID（是数字）。请注意，完全使用数字的用户名和组群名称在 Red Hat Enterprise Linux 7 中已被弃用，在 Red Hat  Enterprise Linux 8 中被完全删除。 			

### 8.7.2. `securetty` 现在默认禁用

​					由于现代 Linux 系统中 `tty` 设备文件具有动态的特性，所以默认禁用了 `securetty` PAM 模块，且 `/etc/securetty` 配置文件不再包含在 RHEL 中。因为 `/etc/securetty` 列出了很多可能的设备，因此在多数情况下实际效果是默认允许，这个更改只会产生较小的影响。然而，如果您使用更严格的配置，则需要在 `/etc/pam.d` 目录的适当文件中添加一行来启用 `pam_securetty.so` 模块，并创建一个新的 `/etc/securetty` 文件。 			

### 8.7.3. 已删除 `Clevis` HTTP pin

​					`Clevis` HTTP pin 已从 RHEL 8 中删除, `clevis encrypt http` 子命令不再可用。 			

#### 8.7.3.1. `Coolkey` 已删除

​						智能卡的 `Coolkey` 驱动程序已从 RHEL 8 中删除, `OpenSC` 现在提供它的功能。 				

#### 8.7.3.2. `crypto-utils` 已删除

​						`crypto-utils` 软件包已从 RHEL 8 中删除。您可以使用由 `openssl`、`gnutls-utils` 和 `nss-tools` 软件包提供的工具程序。 				

#### 8.7.3.3. KLIPS 已从 `Libreswan` 中删除

​						在 Red Hat Enterprise Linux 8 中，从 `Libreswan` 中删除了对 Kernel IP Security（KLIPS）IPsec 堆栈的支持。 				

# 第 9 章 网络

# 第 11 章 Networking

​			本章列出了 RHEL 8 和 RHEL 9 之间的与网络相关的显著更改。 	

## 11.1. 内核

**WireGuard VPN 作为技术预览提供**

​					WireGuard（红帽作为技术预览提供）是一个在 Linux 内核中运行的高性能 VPN 解决方案。它使用现代加密，比其他 VPN 解决方案更容易配置。此外，因为 WireGuard 较小的代码基础，减少了受攻击的风险，因此提高了安全性。 			

​				详情请查看[设置 WireGuard VPN](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/assembly_setting-up-a-wireguard-vpn_configuring-and-managing-networking)。 		

# 11.2. 网络类型

**网络团队已弃用**

​					`teamd` 服务和 `libteam` 库在 Red Hat Enterprise Linux 9 中已弃用，并将在下一个主发行版本中删除。作为替换，配置绑定而不是网络组。 			

​				红帽注重于基于内核的绑定操作，以避免维护具有类似功能的两个功能：绑定和团队（team）。绑定代码具有较高的客户采用率，非常可靠，具有活跃的社区开发。因此，绑定代码会收到功能增强和更新。 		

​				有关如何将团队迁移到绑定的详情，请参阅将[网络组配置迁移到网络绑定](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9-beta/html/configuring_and_managing_networking/configuring-network-teaming_configuring-and-managing-networking#proc_migrating-a-network-team-configuration-to-network-bond_configuring-network-teaming)。 		

# 11.3. NetworkManager

**NetworkManager 以 keyfile 格式保存新的网络配置**

​					在以前的版本中，NetworkManager 将新的网络配置以 `ifcfg` 格式保存到 `/etc/sysconfig/network-scripts/`。从 RHEL 9.0 开始，RHEL 将新网络配置存储在 `/etc/NetworkManager/system-connections/` 中，采用 key 文件格式。配置以旧格式存储在 `/etc/sysconfig/network-scripts/` 中的连接仍然可以正常工作。对现有配置集的修改会继续更新旧的文件。 			

**删除了 WEP Wi-Fi 连接方法**

​					RHEL 9 中删除了与不安全线等同的隐私(WEP)Wi-Fi 连接方法。对于安全的 Wi-Fi 连接，请使用 Wi-Fi Protected Access 3(WPA3)或 WPA2 连接方法。 			

# 11.4. MPTCP

**mptcpd 服务可用**

​					在这个版本中，`mptcpd` 服务可供使用。它是基于 `MPTCP` 路径管理器并带有集成的 `mptcpize` 工具的一个用户空间。 			

​				`mptcpd` 服务为 `MPTCP'path 提供简化的自动配置。在出现网络故障或重新配置时，它具有更高的 'MPTCP` 套接字可靠性。 		

​				现在，您可以使用 `mptcpize` 工具在现有 `systemd` 单元中启用 `MPTCP` 协议，而无需额外的外部依赖项。 		

# 11.5. firewall

**`ipset` 和 `iptables-nft` 软件包已弃用**

​					RHEL 中弃用了 `ipset` 和 `iptables-nft` 软件包。`iptables-nft` 软件包包含不同的工具，如 `iptables`、`ip6tables`、`ebtables` 和 `arptables`。这些工具将不再获得新功能，我们不建议将其用于新部署。建议使用 `nftables` 软件包提供的 `nft` 命令行工具替换它。现有设置应尽可能迁移到 `nft`。 			

​				有关迁移到 nftables 的更多信息，请参阅[从 iptables 迁移到 nftables](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/configuring_firewalls_and_packet_filters/getting-started-with-nftables_firewall-packet-filters#assembly_migrating-from-iptables-to-nftables_getting-started-with-nftables)，以及 `iptables-translate(8)` 和 `ip6tables-translate(8)` man page。 		

**不受支持的 `xt_u32` Netfilter 模块已被删除**

​					RHEL 8 包含不受支持的 `xt_u32` 模块，它可以使 `iptables` 用户与数据包标头或有效负载中的任意 32 位匹配。此模块已从 RHEL 9 中删除。作为替换，使用 `nftables` 数据包过滤框架。如果 `nftables` 中不存在原生匹配，请使用 `nftables` 的原始有效负载匹配功能。详情请查看 `nft(8)` 手册页中 `原始有效负载表达式` 部分。 			

# 11.6. InfiniBand 和 RDMA 网络

**`ibdev2netdev` 脚本已从 RHEL 9 中删除**

​					`ibdev2netdev` 是一个帮助程序，它可以显示网络设备和远程直接内存访问(RDMA)适配器端口之间的所有关联。在以前的版本中，红帽在 `rdma-core` 软件包中包含 `ibdev2netdev`。从 Red Hat Enterprise Linux 9，`ibdev2netdev` 已被删除，由 `rdmatool` 程序替代。现在，`iproute` 软件包包含 `rdmatool`。 			

# 11.7. 删除的功能

**RHEL 9 不包含旧的网络脚本**

​					RHEL 9 不包含在 RHEL 8 中提供已弃用的旧网络脚本的 `network-scripts` 软件包。要在 RHEL 9 中配置网络连接，请使用 NetworkManager。详情请参阅[配置和管理网络文档](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9-beta/html/configuring_and_managing_networking/)。 			

**不受支持的 `xt_u32` Netfilter 模块已被删除**

​					RHEL 8 包含不受支持的 `xt_u32` 模块，它可以使 `iptables` 用户与数据包标头或有效负载中的任意 32 位匹配。此模块已从 RHEL 9 中删除。作为替换，使用 `nftables` 数据包过滤框架。如果 `nftables` 中不存在原生匹配，请使用 `nftables` 的原始有效负载匹配功能。详情请查看 `nft(8)` 手册页中 `原始有效负载表达式` 部分。 			

**Red Hat Enterprise Linux 9 中的 net-snmp 通信无法使用数据加密标准(DES)算法**

​					在以前的 RHEL 版本中，DES 被用作 net-snmp 客户端和服务器间安全通信的加密算法。在 RHEL 9 中，OpenSSL 库不支持 DES 算法。该算法标记为不安全，因此删除了对 net-snmp 的 DES 支持。 			

# 第 12 章 内核

​			本章列出了 RHEL 8 和 RHEL 9 之间的与内核相关的重要更改。 	

## 12.1. kdump 内存分配的显著变化

**`kexec-tools` 软件包现在支持 RHEL 9 的默认 `crashkernel` 内存保留值**

​					`kexec-tools` 软件包现在维护默认的 `crashkernel` 内存保留值。`kdump` 服务使用默认值为每个内核保留 `crashkernel` 内存。通过这个实现，当系统的可用内存少于 4GB 时，对 `kdump` 的内存分配有所改进。 			

​				如果系统上默认 `crashkernel` 值保留的内存还不够，您可以使用默认值作为参考来增加 `crashkernel` 参数。 		

​				查询默认的 `crashkernel` 值： 		



```none
 $ kdumpctl get-default-crashkernel
```

​				请注意，RHEL 9 及更新的版本中不再支持引导命令行中的 `crashkernel=auto` 选项。 		

​				如需更多信息，请参阅 `/usr/share/doc/kexec-tools/crashkernel-howto.txt` 文件。 		

# 12.2. RHEL 9 中支持 TPM 1.2 安全加密处理器的显著变化

**RHEL 9 不再支持 TPM 1.2 安全加密处理器**

​					Trusted Platform Module(TPM)安全加密处理器版本 1.2 已被删除，且在 RHEL 9 及更新的版本中不再受支持。TPM 2.0 替换 TPM 1.2，并比 TPM 1.2 提供了很多改进。TPM 2.0 不是向后兼容。 			

​				请注意，对于需要支持 TPM 1.2 的应用程序，红帽建议您使用 RHEL 8。 		

**在 ARM、AMD 和 Intel 64 位构架上启用了动态抢占调度**

​					使用动态调度时，您可以在引导或运行时，而不是在编译时间更改内核的抢占模式。通过动态抢占处理，您可以覆盖默认的抢占模型，以改进调度延迟。 			

​				`/sys/kernel/debug/sched/preempt` 文件包含了支持运行时修改的当前设置。使用 `DYNAMIC_PREEMPT` 选项，将启动时的 `preempt=` 变量设为 `none`、`voluntary` 或 `full`。`voluntary` 抢占是默认值。 		

# 12.3. 内核的显著变化

**RHEL 9 中默认启用 `cgroup-v2`**

​					控制组版本 2(`cgroup-v2)`功能实施单一层次结构模型，以简化控制组的管理。此外，它确保一个进程一次只能是一个控制组的成员。与 `systemd` 的深度集成提高了在 RHEL 系统上配置资源控制时的最终用户体验。 			

​				新功能的开发主要针对 `cgroup-v2`，其具有 `cgroup-v1` 缺少的一些功能。类似地，`cgroup-v1` 还包含 `cgroup-v2` 中缺少的一些传统功能。此外，控制接口也不同。因此，直接依赖 `cgroup-v1` 的第三方软件在 `cgroup-v2` 环境中可能无法正常运行。 		

​				要使用 `cgroup-v1`，您需要在内核命令行中添加以下参数： 		



```none
systemd.unified_cgroup_hierarchy=0
systemd.legacy_systemd_cgroup_controller
```

注意

​					内核中完全启用了 `cgroup-v1` 和 `cgroup-v2`。从内核的角度来看，没有默认的控制组版本，并且由 `systemd` 决定在启动时挂载。 			

**可能会影响第三方内核模块的内核更改**

​					Linux 分发自 5.9 之前内核版本，支持导出 GPL 功能，作为非 GPL 功能。因此，用户可以通过 `shim` 机制将专有功能链接到 GPL 内核功能。在这个版本中，RHEL 内核融合了上游更改，这些更改提高了 RHEL 通过重新调整 `shim` 来强制实施 GPL 的能力。 			

重要

​					合作伙伴和独立软件供应商(ISV)应利用早期版本的 RHEL 9 测试他们的内核模块，以确保其符合 GPL。 			

**RHEL 9 支持内核调度**

​					借助内核调度功能，用户可以防止不应相互信任的任务共享相同的 CPU 内核。类似地，用户可以定义可共享 CPU 内核的任务组。 			

​				可以指定这些组： 		

- ​						通过减少一些跨严重多线程(SMT)攻击来提高安全性 				
- ​						隔离需要整个内核的任务。例如，对于实时环境中的任务，或依赖特定处理器功能的任务，如单指令、多数据(¢D)处理 				

​				如需更多信息，请参阅 [Core Scheduling](https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/core-scheduling.html)。 		

**`kernelopts` 环境变量已在 RHEL 9 中删除**

​					在 RHEL 8 中，使用 GRUB2 引导装载程序的系统的内核命令行参数定义在 `kernelopts` 环境变量中。此变量存储在每个内核引导条目的 `/boot/grub2/grubenv` 文件中。但是，使用 `kernelopts` 存储内核命令行参数并不可靠。因此，Red Hat 删除了 `kernelopts`，且内核命令行参数保存在 Boot Loader Specification(BLS)片断中，而不是在 `/boot/loader/entries/<*KERNEL_BOOT_ENTRY*>.conf` 文件中。 			

**红帽只为次版本保护内核符号**

​					红帽保证，在您使用受保护的内核符号编译内核模块时，内核模块将继续在延长更新支持(EUS)版本中的所有更新中载入，。RHEL 9 的次版本之间没有内核应用程序二进制接口(ABI)保证。 			12.4. 引导装载程序的显著变化

**默认隐藏引导装载程序菜单**

​					从 RHEL 9.1 开始，如果 RHEL 是唯一安装的操作系统，并且之前的引导成功，则 GRUB 引导装载程序被配置为默认隐藏引导菜单。这会在此类系统上获得更顺畅的引导体验。 			

​				要访问引导菜单，请使用以下选项之一： 		

- ​						在启动系统后，重复按 **Esc 键**。 				
- ​						引导系统后，重复按 **F8**。 				
- ​						在启动过程中按住 **Shift**. 				

​				要禁用这个功能并配置引导装载程序菜单默认显示，请使用以下命令： 		



```none
# grub2-editenv - unset menu_auto_hide
```

**引导装载程序配置文件跨 CPU 架构统一**

​					GRUB 引导装载程序的配置文件现在保存在所有支持的 CPU 架构的 `/boot/grub2/` 目录中。GRUB 之前在 UEFI 系统上用作主配置文件的 `/boot/efi/EFI/redhat/grub.cfg` 文件现在只加载 `/boot/grub2/grub.cfg` 文件。 			

​				此更改简化了 GRUB 配置文件的布局，改进了用户体验，并提供以下显著优点： 		

- ​						您可以使用 EFI 或旧 BIOS 引导相同的安装。 				
- ​						您可以将相同的文档和命令用于所有架构。 				
- ​						GRUB 配置工具更加强大，因为它们不再依赖于符号链接，而且不必处理平台特定的情况。 				
- ​						GRUB 配置文件的使用与 CoreOS Assembler(COSA)和 OSBuild 生成的镜像一致。 				
- ​						GRUB 配置文件的使用与其他 Linux 发行版一致。 				

**RHEL 不再在 32 位 UEFI 上启动**

​					支持 32 位 UEFI 固件已从 GRUB 和 `shim` 引导装载程序中删除。因此，RHEL 9 需要 64 位 UEFI，且无法在使用 32 位 UEFI 的 64 位系统中引导。 			

​				在本次更改中删除了以下软件包： 		

- ​						`grub2-efi-ia32` 				
- ​						`grub2-efi-ia32-cdboot` 				
- ​						`grub2-efi-ia32-modules` 				
- ​						`shim-ia32` 				

# 第 13 章 硬件启用

​			本章列出了 RHEL 8 和 RHEL 9 之间硬件启用的最显著更改。 	

## 13.1. 未维护的硬件支持

​				在 RHEL 9 中，以下设备（驱动程序、适配器）不再在常规基础上进行测试或更新。红帽可酌情解决严重的错误，包括安全漏洞。这些设备不应该在生产环境中使用，这很可能会在下一个主发行版本中禁用。 		

​				PCI 设备 ID 采用 *vendor:device:subvendor:subdevice* 的格式。如果没有列出设备 ID，则与对应驱动程序关联的所有设备都会被不维护。要在您的系统中检查硬件的 PCI ID，请运行 `lspci -nn` 命令。 		

| 设备 ID       | 驱动         | 设备名称                                                     |
| ------------- | ------------ | ------------------------------------------------------------ |
|               | bnx2         | QLogic BCM5706/5708/5709/5716 Driver                         |
|               | e1000        | Intel® PRO/1000 网络驱动程序                                 |
|               | hpsa         | 惠普公司：Smart Array Controller                             |
| 0x10df:0x0724 | lpfc         | Emulex Corporation:OneConnect FCoE Initiator (Skyhawk)       |
| 0x10df:0xe200 | lpfc         | Emulex Corporation:LPe15000/LPe16000 Series 8Gb/16Gb Fibre Channel Adapter |
| 0x10df:0xf011 | lpfc         | Emulex Corporation:Saturn:LightPulse Fibre Channel Host Adapter |
| 0x10df:0xf015 | lpfc         | Emulex Corporation:Saturn:LightPulse Fibre Channel Host Adapter |
| 0x10df:0xf100 | lpfc         | Emulex Corporation:LPe12000 Series 8Gb Fibre Channel Adapter |
| 0x10df:0xfc40 | lpfc         | Emulex Corporation:Saturn-X:LightPulse Fibre Channel Host Adapter |
| 0x10df:0xe220 | be2net       | Emulex Corporation:OneConnect NIC (Lancer)                   |
| 0x1000:0x0071 | megaraid_sas | Broadcom / LSI:MR SAS HBA 2004                               |
| 0x1000:0x0073 | megaraid_sas | Broadcom / LSI:MegaRAID SAS 2008 [Falcon]                    |
| 0x1000:0x0079 | megaraid_sas | Broadcom / LSI:MegaRAID SAS 2108 [Liberator]                 |
| 0x1000:0x005b | megaraid_sas | Broadcom / LSI:MegaRAID SAS 2208 [Thunderbolt]               |
| 0x1000:0x006E | mpt3sas      | Broadcom / LSI:SAS2308 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0080 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0081 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0082 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0083 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0084 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0085 | mpt3sas      | Broadcom / LSI:SAS2208 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0086 | mpt3sas      | Broadcom / LSI:SAS2308 PCI-Express Fusion-MPT SAS-2          |
| 0x1000:0x0087 | mpt3sas      | Broadcom / LSI:SAS2308 PCI-Express Fusion-MPT SAS-2          |
|               | mptbase      | Fusion MPT SAS 主机驱动程序                                  |
|               | mptsas       | Fusion MPT SAS 主机驱动程序                                  |
|               | mptscsih     | Fusion MPT SCSI 主机驱动程序                                 |
|               | mptspi       | Fusion MPT SAS 主机驱动程序                                  |
|               | myri10ge     | Myricom 10G 驱动程序(10GbE)                                  |
|               | netxen_nic   | QLogic/NetXen(1/10)GbE 智能以太网驱动程序                    |
| 0x1077:0x2031 | qla2xxx      | QLogic Corp.:基于 ISP8324 的 16Gb Fibre Channel to PCI Express Adapter |
| 0x1077:0x2532 | qla2xxx      | QLogic Corp.:基于 ISP2532 的 8Gb Fibre Channel 到 PCI Express HBA |
| 0x1077:0x8031 | qla2xxx      | QLogic Corp.:8300 系列 10GbE Converged Network Adapter(FCoE) |
|               | qla3xxx      | QLogic ISP3XXX 网络驱动程序 v2.03.00-k5                      |
| 0x1924:0x0803 | sfc          | Solarflare Communications:SFC9020 10G Ethernet Controller    |
| 0x1924:0x0813 | sfc          | Solarflare Communications:SFL9021 10GBASE-T Ethernet Controller |

# 13.2. 删除的硬件支持

​				以下设备（驱动程序、适配器）已从 RHEL 9 中删除。 		

​				PCI 设备 ID 采用 *vendor:device:subvendor:subdevice* 的格式。如果没有列出设备 ID，则与对应驱动程序关联的所有设备都会被不维护。要在您的系统中检查硬件的 PCI ID，请运行 `lspci -nn` 命令。 		

| 设备 ID                | 驱动                 | 设备名称                                            |
| ---------------------- | -------------------- | --------------------------------------------------- |
|                        | Soft-RoCE (rdma_rxe) |                                                     |
|                        | HNS-RoCE             | HNS GE/10GE/25GE/50GE/100GE RDMA Network Controller |
|                        | liquidio             | Cavium LiquidIO 智能服务器适配器驱动程序            |
|                        | liquidio_vf          | Cavium LiquidIO 智能服务器适配器虚拟功能驱动程序    |
| aarch64:Ampere:Potenza |                      | Ampere eMAG                                         |
| aarch64:APM:Potenza    |                      | Applied Micro X-Gene                                |
| ppc64le:ibm:4d:*       |                      | Power8                                              |
| ppc64le:ibm:4b:*       |                      | Power8E                                             |
| ppc64le:ibm:4c:*       |                      | Power8NVL                                           |
| s390x:ibm:2964:*       |                      | z13                                                 |
| s390x:ibm:2965:*       |                      | z13s                                                |
| v4l/dvb                |                      | 电视和视频捕获设备                                  |

# 第 14 章 文件系统和存储

​			本章列出了 RHEL 8 和 RHEL 9 之间文件系统和存储的最显著更改。 	

## 14.1. 文件系统

**XFS 文件系统现在支持 `bigtime` 和 `inobtcount` 功能**

​					XFS 文件系统现在支持两个新的 on-disk 功能，它们各自在 RHEL 9 的 `mkfs.xfs` 中被默认启用。这两个新功能包括： 			

- ​						超过 2038 年的时间戳支持（`bigtime`）。 				
- ​						索引节点 btree 计数器（`inobtcount`），以减少大型文件系统的挂载时间。 				

​				在这个版本中，使用默认 `mkfs.xfs` 参数创建的文件系统无法在 RHEL 8 系统中挂载。 		

​				要创建一个与 RHEL 8 内核兼容的新文件系统，请通过在 `mkfs.xfs` 命令行中添加 `-m bigtime=0,inobtcount=0` 来禁用这些新功能。以这种方式创建的文件系统将不支持超过 2038 年的时间戳。 		

​				在 RHEL 8 中创建并不支持这些功能的文件系统，可以使用包含文件系统的卸载块设备中的 `xfs_admin` 实用程序升级。建议在此操作前检查文件系统一致性。该命令还会在更改后在设备上运行 `xfs_repair`。 		

​				启用 `bigtime` 支持。 		

- ​						`xfs_admin -O bigtime=1 /dev/device` 				

​				启用内节点 btree 计数器： 		

- ​						`xfs_admin -O inobtcount=1 /dev/device` 				

​				同时启用这两者： 		

- ​						`xfs_admin -O bigtime=1,inobtcount=1 /dev/device` 				

​				详情请查看 `xfs_admin(8)` 手册页。 		

**RHEL 9 现在支持 exFAT 文件系统**

​					RHEL 9 现在支持 exFAT 文件系统。这是设计用于外部 USB 存储和与其他操作系统间的互操作性和数据交换的文件系统。文件系统并不能是通用的、性能或可扩展的 Linux 文件系统。可通过安装 `exfatprogs` 软件包并使用 `mkfs.exfat` 创建 ex FAT 文件系统。 			

​				详情请查看 `mkfs.exfat(8)` man page。 		

**ext4 文件系统现在支持年超过 2038 的时间戳**

​					ext4 文件系统现在支持超过 2038 年的时间戳。这个功能是完全自动的，不需要任何用户操作就能使用它。唯一的要求是内节点要大于 128 字节，这是默认值。 			

**新的 `nfsv4-client-utils` 软件包**

​					添加了新软件包 `nfsv4-client-utils`，其中包含只支持 NFSv4 的 demons 和工具集合。这是标准的 `nfs-utils` 软件包的替代。 			

**现在，使用版本 1802 创建 GFS2 文件系统**

​					RHEL 9 中的 GFS2 文件系统采用格式版本 1802 创建。这可启用以下功能： 			

- ​						`trusted` 命名空间的扩展属性 ("trusted.* xattrs") 可被 `gfs2` 和 `gfs2-utils` 识别。 				
- ​						`rgrplvb` 选项默认为活动状态。这允许 `allowgfs2` 将更新的资源组数据附加到 DLM 锁定请求，因此获取锁定的节点不需要从磁盘更新资源组信息。这在某些情况下提高了性能。 				

​				使用新格式版本创建的文件系统将无法被挂载到以前的 RHEL 版本以及 `fsck.gfs2` 工具的旧版本下，将无法对其进行检查。 		

​				用户可以运行带有 `-o format=1801` 选项的 `mkfs.gfs2` 命令，创建采用较旧版本的文件系统。 		

​				用户可以在卸载的文件系统中通过运行 `tunegfs2 -r 1802 *device*` 来升级旧文件系统的格式版本。不支持降级格式版本。 		

**Samba 工具中的选项已被重命名和删除，以获得一致的用户体验**

​					Samba 工具已被改进，来提供一致的命令行界面。这些改进包括重命名和删除的选项。因此，为了避免更新后出现问题，请查看使用 Samba 工具的脚本，并在需要时更新它们。 			

​				Samba 4.15 在 Samba 工具中引进了以下更改： 		

- ​						在以前的版本中，Samba 命令行工具会悄悄忽略未知选项。为防止意外行为，工具现在一致拒绝未知选项。 				
- ​						现在，几个命令行选项有一个对应的 `smb.conf` 变量来控制它们的默认值。请参阅工具的手册页来识别命令行选项是否有 `smb.conf` 变量名。 				
- ​						默认情况下，Samba 工具现在记录到标准错误(`stderr`)。使用 `--debug-stdout` 选项更改此行为。 				
- ​						`--client-protection=off|sign|encrypt` 选项已添加到通用解析程序中。 				
- ​						在所有工具中已重命名了以下选项： 				
  - ​								`--Kerberos` 变为 `--use-kerberos=required|desired|off` 						
  - ​								`--krb5-ccache` 变为 `--use-krb5-ccache=*CCACHE*` 						
  - ​								`--scope` 变为 `--netbios-scope=*SCOPE*` 						
  - ​								`--use-ccache` 变为 `--use-winbind-ccache` 						
- ​						以下选项已从所有工具中删除： 				
  - ​								`-e` 和 `--encrypt` 						
  - ​								从 `--use-winbind-ccache` 中删除了 `-c` 						
  - ​								从 `--netbios-scope` 中删除了 `-i` 						
  - ​								`-S` 和 `--signing` 						
- ​						要避免重复选项，某些选项已从以下工具中删除或重命名了： 				
  - ​								`ndrdump`:`-l` 对于 `--load-dso` 不再可用 						
  - ​								`net`:`-l` 对于 `--long` 不再可用 						
  - ​								`sharesec`:`-V` 对于 `--viewsddl` 不再可用 						
  - ​								`smbcquotas`:`--user` 已重命名为 `--quota-user` 						
  - ​								`nmbd`:`--log-stdout` 已重命名为 `--debug-stdout` 						
  - ​								`smbd`:`--log-stdout` 已重命名为 `--debug-stdout` 						
  - ​								`winbindd`:`--log-stdout` 已重命名为 `--debug-stdout` 						

**`cramfs` 模块已被删除**

​					由于缺少用户，已删除了 `cramfs` 内核模块。建议使用 `squashfs` 作为替代解决方案。 			

**RHEL 9 中删除了强制文件锁定支持**

​					RHEL 9 及更新的版本不再支持强制文件锁定。该内核会忽略 `mand` 挂载选项，其使用会在系统日志中生成警告。 			

**NFSv2 不再被支持**

​					RHEL 9 NFS 客户端和服务器不再支持 NFSv2。 			

# 14.2. 存储

**VDO 管理软件已被删除**

​					RHEL 9 不再提供基于 python 的 VDO Management 软件。使用 LVM-VDO 实现来管理 VDO 卷，而不是使用这个软件。 			

**从 VDO 中删除了多个写入策略**

​					VDO 不再有多个写入策略。VDO 现在只使用 `async` 写入策略。删除了 'sync' 和 'async-unsafe' 写入策略。 			

# 第 15 章 高可用性和集群

​			本章列出了 RHEL 8 和 RHEL 9 之间与高可用性和集群相关的主要变化。 	

## 15.1. 高可用性和集群的显著变化

**支持 `clufter` 工具的 `pcs` 命令已被删除**

​					删除了支持 `clufter` 工具用于分析集群配置格式的 `pcs` 命令。删除了以下命令： 			

- ​						用于导入 CMAN / RHEL6 HA 集群配置的 `pcs config import-cman` 				
- ​						`pcs config export` 用于将集群配置导出到可重新创建同一集群的 `pcs` 命令列表中 				

**`pcs` 支持 OCF Resource Agent API 1.1 标准**

​					`pcs` 命令行界面现在支持 OCF 1.1 资源和 STONITH 代理。作为此支持的实施的一部分，任何代理的元数据都必须符合 OCF 模式，代理是否为 OCF 1.0 还是 OCF 1.1 代理。如果代理的元数据不符合 OCF 架构，`pcs` 会考虑代理无效，除非指定了 `--force` 选项，否则不会创建或更新代理的资源。`pcsd` Web UI 和 `pcs` 命令用于列出代理，现在从列表中省略带有无效元数据的代理。 			

# 第 16 章 动态编程语言、网页服务器、数据库服务器

​			本章列出了 RHEL 8 和 RHEL 9 之间的动态编程语言、Web 服务器和数据库服务器的最显著变化。 	

## 16.1. 动态编程语言、Web 和数据库服务器的显著变化

**RHEL 9 中初始应用程序流版本**

​					RHEL 9 改进了应用程序流的使用体验，它提供了初始的应用程序流版本，可以使用传统的 `dnf install` 命令作为 RPM 软件包进行安装。 			

​				RHEL 9.0 提供以下动态编程语言： 		

- ​						**Node.js 16** 				
- ​						**Perl 5.32** 				
- ​						**PHP 8.0** 				
- ​						**Python 3.9** 				
- ​						**Ruby 3.0** 				

​				RHEL 9.0 包括以下版本控制系统： 		

- ​						**Git 2.31** 				
- ​						**Subversion 1.14** 				

​				以下 web 服务器随 RHEL 9.0 一起发布： 		

- ​						**Apache HTTP Server 2.4** 				
- ​						**nginx 1.20** 				

​				以下代理缓存服务器可用： 		

- ​						**Varnish Cache 6.6** 				
- ​						**Squid 5.2** 				

​				RHEL 9.0 提供以下数据库服务器： 		

- ​						**MariaDB 10.5** 				
- ​						**MySQL 8.0** 				
- ​						**PostgreSQL 13** 				
- ​						**Redis 6.2** 				

​				一些额外的 Application Stream 版本将作为模块发布，并在以后的 RHEL 9 次要发行本中带有较短的生命周期。 		

**自 RHEL 8 开始的 Python 生态系统的主要区别**

​					**统一的 `python` 命令** 			

​				`python` 命令的未指定版本形式(`/usr/bin/python`)在 `python-unversioned-command` 软件包中提供。在某些系统中，默认情况下不安装此软件包。要手动安装 `python` 命令的未指定版本形式，请使用 `dnf install /usr/bin/python` 命令。 		

​				在 RHEL 9 中，`python` 命令的未指定版本形式指向默认的 Python 3.9 版本，它等同于 `python3` 和 `python3.9` 命令。 		

​				`python` 命令用于交互式会话。在生产环境中，红帽建议明确使用 `python3` 或 `python3.9`。 		

​				您可以使用 `dnf remove /usr/bin/python` 命令卸载未指定版本的 `python` 命令。如果需要不同的 python 命令，您可以在 `/usr/local/bin` 或 `~/.local/bin` 中创建自定义符号链接。 		

​				还提供了其他未版本化的命令，如 `python3-pip` 软件包中的 `/usr/bin/pip`。在 RHEL 9 中，所有未指定版本的命令都指向默认的 Python 3.9 版本。 		

​				**特定于架构的 Python `wheels`** 		

​				在 RHEL 9 上 构建的特定于体系结构的 Python `wheel` 新建了上游架构命名，允许客户在 RHEL 9 上构建其 Python `wheel` 并在非 RHEL 系统中安装它们。在以前的 RHEL 版本构建的 Python `wheel` 是向前兼容的，可以在 RHEL 9 上安装。请注意，这仅影响包含 Python 扩展的 `wheel`，这些扩展针对每个架构构建，而不影响包含纯 Python 代码的 Python `wheels`，这不是特定于架构的 Python wheel。 		

**`libdb`的显著变化**

​					RHEL 8 和 RHEL 9 目前提供 Berkeley DB(`libdb`)版本 5.3.28，该版本根据 LGPLv2 许可证发布。上游 Berkeley DB 版本 6 在 AGPLv3 许可证下提供，该许可证更严格。 			

​				从 RHEL 9 开始，`libdb` 软件包已弃用，可能不会在以后的 RHEL 版本中可用。在 RHEL 9 中，加密算法已从 `libdb` 中删除。从 RHEL 9 中删除了多个 `libdb` 依赖项。 		

​				建议 `libdb` 用户迁移到其他键值数据库。如需更多信息，请参阅 [RHEL 中已弃用的 Berkeley DB(libdb)](https://access.redhat.com/articles/6464541) 的知识库文章。 		

# 第 17 章 编译器和开发工具

​			本章列出了 RHEL 8 和 RHEL 9 之间对编译器和开发工具的最显著更改。 	

## 17.1. 对**glibc** 的显著变化

**现在，所有线程 API 都合并到 `libc.so.6` 中**

​					在 RHEL 8 中，系统线程库 `libpthread.so` 是不同的库。在 RHEL 9 中，所有线程 API 都已合并到核心 C 库 `libc.so.6` 中。将线程移到核心 C 库可使库默认支持线程。由于线程 API 和核心 C，POSIX 以及 BSD API 都同时更新（没有不同的库），因此使用一个文件，就地升级过程也变得更加顺畅。 			

​				在链接线程应用程序时，开发人员可以继续使用 `-lpthread` 选项，但不再是必需的。 		

​				过去，库使用弱引用 `pthread_create` 或 `pthread_cancel` 来检测进程是否可能是多线程的。由于这个检查现在始终成功，因为 `libpthread.so` 现在位于核心 C 库中，所以库应该改为使用 [`__libc_single_threaded`](https://www.gnu.org/software/libc/manual/html_node/Single_002dThreaded.html) 符号。 		

**`libdl` 库现在合并到 `libc.so.6`**

​					在 RHEL 8 中，`libdl` 库是一个不同的库。在 RHEL 9 中，`libdl` 库已合并到 核心 C 库 `libc.so.6` 中。这意味着，插入 `dlsym` 函数现在更加困难。需要控制符号解析如何工作的应用程序应该切换到审核程序(`LD_AUDIT`)接口。 			

**`dns` 和 `files` 的 名字服务切换服务插件现在合并到 `libc.so.6`**

​					在 RHEL 8 中，为用户和组群身份管理 API 提供数据的`files` 和 `dns` 的名字服务切换(NSS)服务是不同的插件。在 RHEL 9 中，插件已合并到核心 C 库 `libc.so.6` 中。移动 `files` 和 `dns` 服务提供程序确保需要跨挂载命名空间边界（例如，输入一个容器）应用程序可以这样做，知道 NSS `files` 和 `dns` 访问服务总是在进程启动时被加载。 			

​				调用依赖于引用 `files` 或 `dns` 的 `nsswitch.conf` 的用户和组 API 时，开发人员可以预期这些服务始终存在，并提供底层服务数据。 		



## 9.1. NetworkManager

### 9.1.1. 旧版网络脚本支持

​					网络脚本在 Red Hat Enterprise Linux 8 中已弃用，且不再默认提供。基本安装提供了 `ifup` 和 `ifdown` 脚本的新版本，它们通过 **nmcli** 工具调用 **NetworkManager**。在 Red Hat Enterprise Linux 8 中,要运行 `ifup` 和 `ifdown` 脚本, **NetworkManager** 必须正在运行。 			

注意

​						`/sbin/ifup-local`、`ifdown-pre-local` 和 `ifdown-local` 脚本中的自定义命令没有被执行。 				

​						如果需要这些脚本，您仍可以使用以下命令在系统中安装已弃用的网络脚本： 				

```
~]# yum install network-scripts
```

​						`ifup` 和 `ifdown` 脚本链接到已安装的旧网络脚本。 				

​						调用旧的网络脚本会显示一个关于它们已过时的警告。 				

### 9.1.2. NetworkManager 支持 SR-IOV 虚拟功能

​					在 Red Hat Enterprise Linux 8 中，**NetworkManager** 允许为支持单根 I/O 虚拟化（SR-IOV）的接口配置虚拟功能（VF）的数量。另外, **NetworkManager** 允许配置 VF 的一些属性,如 MAC 地址、VLAN、`spoof checking` 设置和允许的字节速率。请注意,与 SR-IOV 相关的所有属性都位于 `sriov` 连接设置中。详情请查看 `nm-settings(5)` man page。 			

### 9.1.3. NetworkManager 支持连接的通配符接口名称匹配

​					在以前的版本中，只能使用接口名的完全匹配来限制到给定接口的连接。在这个版本中,连接会有一个支持通配符的 match.interface-name 属性。在这个版本中,用户可以使用通配符模式以更灵活的方式为连接选择接口。 			

### 9.1.4. NetworkManager 支持配置 ethtool offload 功能

​					在这个版本中, `NetworkManager` 支持配置 `ethtool` 卸载功能,用户不再需要使用初始化脚本或 `NetworkManager` 分配程序脚本。现在，用户可以使用以下方法之一将下载功能配置为连接配置集的一部分： 			

- ​							使用 `nmcli` 工具 					
- ​							通过编辑 `/etc/NetworkManager/system-connections/` 目录中的密钥文件 					
- ​							编辑 `/etc/sysconfig/network-scripts/ifcfg-*` 文件 					

​					请注意，图形界面和 `nmtui` 实用程序目前不支持这个功能。 			

### 9.1.5. NetworkManager 现在默认使用内部 DHCP 插件

​					**NetworkManager** 支持 `internal` 和 `dhclient` DHCP 插件。默认情况下，Red Hat Enterprise Linux（RHEL）7 中的 **NetworkManager** 使用 `dhclient`，RHEL 8 使用 `internal` 插件。在某些情况下，插件的行为不同。例如： `dhclient` 可以使用 `/etc/dhcp/` 目录中指定的附加设置。 			

​					如果您从 RHEL 7 升级到 RHEL 8，**NetworkManager** 的行为有所不同，请在 `/etc/NetworkManager/NetworkManager.conf` 文件中的 `[main]` 部分添加以下设置以使用 `dhclient` 插件： 			

```
[main]
dhcp=dhclient
```

### 9.1.6. 在 RHEL 8 中，默认不会安装 NetworkManager-config-server 软件包

​					只有在设置过程中选择了 `Server` 或 `Server with GUI` 基础环境时,才会默认安装 `NetworkManager-config-server` 软件包。如果您选择了不同的环境，使用 `yum install NetworkManager-config-server` 命令安装软件包。 			

## 9.2. 数据包过滤

### 9.2.1. `nftables` 替换 `iptables` 作为默认网络数据包过滤框架

​					`nftables` 框架提供数据包分类工具,它是 `iptables`、`ip6tables`、`arptables`、`ebtables` 和 `ipset` 工具的指定后台。与之前的数据包过滤工具相比，它在方便、特性和性能方面提供了大量改进，最重要的是： 			

- ​							查找表而不是线性处理 					
- ​							`IPv4` 和 `IPv6` 协议都使用同一个框架 					
- ​							规则会以一个整体被应用，而不是分为抓取、更新和存储完整的规则集的步骤 					
- ​							支持在规则集（`nftrace`）中进行调试和追踪，并监控追踪事件（在 `nft` 工具中） 					
- ​							更加一致和压缩的语法，没有特定协议的扩展 					
- ​							用于第三方应用程序的 Netlink API 					

​					和 `iptables`类似， `nftables` 使用表来存储链。链包含执行动作的独立规则。`nft` 工具替换了之前数据包过滤框架中的所有工具。`libnftables` 库可用于通过 `libmnl` 库与 `nftables` Netlink API 进行底层交互。 			

​					`iptables`、`ip6tables`、`ebtables` 和 `arptables` 工具由基于 nftables 的具有相同名称的程序替换。虽然其外部行为与其旧的程序相同，但在内部会通过兼容性接口使用 `nftables` 和旧的 `netfilter` 内核模块。 			

​					您可以使用 `nft list ruleset` 命令查看模块对 `nftables` 规则集的影响。这些工具将表、链和规则添加到 `nftables` 规则集中，请注意, `nftables` 规则集操作（如 `nft flush ruleset` 命令）可能会影响使用以前独立的旧命令安装的规则集。 			

​					为了帮助快速识存在该工具的哪个变体，版本信息已被更新，其中包含了后端名称。在 RHEL 8 中，基于 nftables 的 `iptables` 工具打印以下版本字符串： 			

```
$ iptables --version
iptables v1.8.0 (nf_tables)
```

​					如果存在旧的 `iptables` 工具，则会打印以下版本信息： 			

```
$ iptables --version
iptables v1.8.0 (legacy)
```

### 9.2.2. `Arptables` FORWARD 从 RHEL 8 的过滤表中删除

​					`arptables` FORWARD 链功能已在 Red Hat Enterprise Linux(RHEL)8 中删除。现在，您可以使用 `ebtables` 工具的 FORWARD 链将规则添加到其中。 			

### 9.2.3. `iptables-ebtables` 的输出与 `ebtables` 并不完全兼容

​					在 RHEL 8 中，`ebtables` 命令由 `iptables-ebtables` 软件包提供，它包含了基于 `nftables` 的新的实现。这个工具有不同的代码基础,其输出在方面会有所不同,它们是微不足道的,或者是特意设计选择。 			

​					因此，在迁移用于解析 `ebtables` 输出的脚本时，需要对脚本进行以下调整： 			

- ​							将 MAC 地址格式化改为固定长度。必要时，在独立的字节值的开始包含一个 0，用于维护每个字段值带有两个字符。 					
- ​							已更改 IPv6 前缀的格式以符合 RFC 4291。斜杠字符后的结尾部分不再包含 IPv6 地址格式的子网掩码，而是一个前缀长度。这个更改只适用于有效的（left-contiguous）掩码，其他更改则仍然以旧格式打印。 					

### 9.2.4. 将 `iptables` 转换为 `nftables` 的新工具

​					在这个版本中，添加了 `iptables-translate` 和 `ip6tables-translate` 工具,将现有 `iptables` 或 `ip6tables` 规则转换为 `nftables` 的对等规则。请注意，一些扩展可能缺少响应的转换支持。如果存在这种扩展，该工具会输出以 `#` 符号为前缀的未转换的规则。例如： 			

```
| % iptables-translate -A INPUT -j CHECKSUM --checksum-fill
| nft # -A INPUT -j CHECKSUM --checksum-fill
```

​					另外，用户还可以使用 `iptables-restore-translate` 和 `ip6tables-restore-translate` 工具来翻译规则转储。请注意，在此之前，用户可以使用 `iptables-save` 或者 `ip6tables-save` 命令打印当前规则的转储。例如： 			

```
| % sudo iptables-save >/tmp/iptables.dump
| % iptables-restore-translate -f /tmp/iptables.dump
| # Translated by iptables-restore-translate v1.8.0 on Wed Oct 17 17:00:13 2018
| add table ip nat
| ...
```

## 9.3. `wpa_supplicant` 中的变化

### 9.3.1. `journalctl` 现在可以读取 `wpa_supplicant` 日志

​					在 Red Hat Enterprise Linux（RHEL）8 中，`wpa_supplicant` 软件包在启用`CONFIG_DEBUG_SYSLOG` 的情况下被构建。这允许使用 `journalctl` 实用程序读取 `wpa_supplicant` 日志，而不是检查 `/var/log/wpa_supplicant.log` 文件的内容。 			

### 9.3.2. 禁用了 `wpa_supplicant` 中无线扩展的编译时间支持

​					`wpa_supplicant` 软件包不支持无线扩展。当用户试图使用 `wext` 作为命令行参数时，或者在只支持无线扩展的旧适配器中尝试使用它时，将无法运行 `wpa_supplicant` 守护进程。 			

## 9.4. 向 SCTP 中添加的新数据块类型 `I-DATA`

​				在这个版本中,在流控制传输协议(SCTP)中添加了新的数据块类型 `I-DATA` 和流调度程序。在以前的版本中,SCTP 发送的用户信息与用户发送的顺序相同。因此,大的 SCTP 用户消息会阻断任意流中的所有其他信息,直到完全发送为止。当使用 `I-DATA` 块时, Transmission Sequence Number(TSN)字段不会被超载。因此,SCTP 现在可以以不同的方式调度流, `I-DATA` 允许用户信息交集(RFC 8260)。请注意，两个 peer 都必须支持 `I-DATA` 块类型。 		

## 9.5. RHEL 8 中的主要 TCP 特性

​				Red Hat Enterprise Linux 8 提供了 TCP 网络堆栈版本 4.18，它提供更高的性能、更好的可伸缩性和稳定性。性能会提高，特别是对于入站连接率高的忙碌的 TCP 服务器的性能。 		

​				另外，提供了两个新的 TCP 阻塞算法 `BBR` 和 `NV`，它们在大多数情况下都会提供较低延迟和更好的吞吐量。 		

### 9.5.1. RHEL 8 中的 TCP BBR 支持

​					Red Hat Enterprise Linux(RHEL)8 现在支持一个新的 TCP 阻塞控制算法、Bottleneck  Bandwidth 和□-trip 时间(BBR)。BBR 会尝试决定 bottleneck 链接和 RT-trip  时间(RTT)的带宽。大多数阻塞算法都基于数据包丢失（包括默认的 Linux TCP 阻塞控制算法）。高吞吐量链接存在问题。BBR  不直接响应丢失事件，它会调整 TCP 架构率使其与可用带宽匹配。 			

​					有关此问题的详情，请参考[如何配置 TCP BBR 阻塞控制算法](https://access.redhat.com/solutions/3713681)。 			

## 9.6. 与 VLAN 相关的更改

### 9.6.1. IPVLAN 虚拟网络驱动程序现在被支持

​					在 Red Hat Enterprise Linux 8.0 中,内核包含对 IPVLAN  虚拟网络驱动程序的支持。在这个版本中,IPVLAN 虚拟网络接口卡(NIC)为多个容器启用网络连接,从而向本地网络公开一个 MAC  地址。这允许单个主机对等网络设备支持的 MAC 地址数量产生大量容器的影响。 			

### 9.6.2. 某些网络适配器需要更新固件来完全支持 802.1ad

​					某些网络适配器的固件并不完全支持 802.1ad 标准,该标准也称为 Q-in-Q  或堆栈的虚拟本地网络(VLAN)。如需了解如何验证您的网络适配器使用支持 802.1ad  标准的固件以及如何更新固件的详情,请联络您的硬件厂商。因此，在 RHEL 8.0 中配置堆栈的 VLAN 可以正常工作。 			

## 9.7. 网络接口名称更改

​				在 Red Hat Enterprise Linux 8 中，默认使用与 RHEL 7 相同的一致的网络设备命名方案。但是,某些内核驱动程序,如 `e1000e`、`nfp`、`qede`、`sfc`、`tg3` 和 `bnxt_en` 在 RHEL 8 的新安装中更改了它们的一致性名称。但是，名称会在从 RHEL 7 升级时保留。 		

## 9.8. 已删除 `ipv6`、`netmask`、`gateway` 和 `hostname` 内核参数

​				从 RHEL 8.3 开始，在内核命令行中配置网络的 `ipv6`、`netmask`、`gateway` 和 `hostname` 内核参数将不再可用。使用接受不同格式的合并的 `ip` 参数，如下所示： 		

```
ip=IP_address:peer:gateway_IP_address:net_mask:host_name:interface_name:configuration_method
```

​				有关各个字段以及这个参数接受的其他格式的详情，请查看 `dracut.cmdline(7)` man page 中的 `ip` 参数描述。 		

## 9.9. 删除 `tc` 命令的 `-ok` 选项

​				在 Red Hat Enterprise Linux 8 中删除了 `tc` 命令的 `-ok` 选项。作为临时解决方案，用户可以实施代码直接通过与内核的 netlink 进行通信。收到的响应消息,指明发送请求的完成和状态。另一个方法是为每个命令单独调用 `tc`。这可能会在一个自定义脚本中使用,它会在每次成功 `tc` 调用时打印 `OK` 来模拟 `tc -batch` 行为。 		

# 第 10 章 内核

## 10.1. 资源控制

### 10.1.1. 控制组 v2 在 RHEL 8 中作为技术预览提供

​					**控制组群 v2** 机制是一个统一的分级控制组群。**Control group v2** 以受控、可配置的方式在分级结构上组织进程,并在层次结构上分配系统资源。 			

​					与上一个版本不同, **控制组群 v2** 只有一个层次结构。这个单一层次结构使 Linux 内核能够： 			

- ​							根据拥有者的角色对进程进行分类。 					
- ​							解决多个分级冲突策略的问题。 					

​					**控制组群 v2** 支持大量控制器： 			

- ​							CPU 控制器规定了 CPU 周期的分布。这个控制器实现： 					
  - ​									常规调度策略的权重和绝对带宽限制模型。 							
  - ​									实时调度策略的绝对带宽分配模型。 							
- ​							内存控制器规定了内存分布。目前，会追踪以下类型的内存用量： 					
  - ​									Userland memory - 页面缓存和匿名内存。 							
  - ​									内核数据结构，如密度和内节点。 							
  - ​									TCP 套接字缓冲。 							
- ​							I/O 控制器规定了 I/O 资源的分配。 					
- ​							远程直接内存访问(RDMA)控制器限制特定进程可以使用的 RDMA/IB 特定资源。这些进程通过 RDMA 控制器分组。 					
- ​							进程号控制器可让控制组在特定限制后停止任何被 `fork()` 或 `clone()` 的新任务。 					
- ​							写回控制器作为一种机制，可平衡 I/O 和内存控制器之间的冲突。 					

​					以上信息基于 *[cgroups-v2 在线文档](https://www.kernel.org/doc/Documentation/cgroup-v2.txt)*。您可以参照同一链接获得有关特定 **控制组 v2** 控制器的更多信息。 			

## 10.2. 内存管理

### 10.2.1. 为 64 位 ARM 提供了 52-bit PA

​					在这个版本中，支持 64 位 ARM 架构的 52 位物理寻址（PA）。这提供了比之前 48 位 PA 更大的物理地址空间。 			

### 10.2.2. 5 级页面表 x86_64

​					在 Red Hat Enterprise Linux 7 中,现有内存总线有 48 位虚拟/物理内存寻址容量,Linux 内核实施了 4 级页面表来管理这些虚拟地址到物理地址。物理总线寻址行会使物理内存上限限制为 64TB。 			

​					这些限制已扩展到使用 128 个 PiB 的虚拟地址空间（64PB 用户/64PB 内核）和 4 PB 的物理内存容量的虚拟/物理内存寻址。 			

​					通过扩展地址范围，Red Hat Enterprise Linux 8 中的内存管理增加了对 5  级页面表实现的支持，以便可以处理扩展的地址范围。默认情况下，RHEL8 将禁用 5  级页面表支持，即使在支持此功能的系统上也是如此。这是因为，在使用 5  个页面表时，如果不需要扩展虚拟或物理地址空间，则性能可能会下降。引导参数将启用支持此功能的硬件的系统使用该功能。 			

## 10.3. 性能分析和可观察工具

### 10.3.1. bpftool 添加到内核中

​					`bpftool` 工具基于扩展的 Berkeley Packet 过滤(eBPF)进行检查和简单操作,它已被添加到 Linux 内核中。`bpftool` 是内核源树的一部分，由 **bpftool** 软件包提供，该软件包作为 **kernel** 软件包的子软件包包含在内。 			

### 10.3.2. eBPF 作为技术预览提供

​					**扩展的 Berkeley Packet 过滤(eBPF)** 功能可作为网络和追踪的技术预览提供。**eBPF** 可让用户空间将自定义程序附加到各种点（套接字、追踪点、数据包接收器）来接收和处理数据。该功能包括新系统调用 `bpf()`,它支持创建各种映射类型,以及将各种程序类型插入内核中。请注意，只有具有 `CAP_SYS_ADMIN` 能力的用户（如 root 用户）才可以成功使用 `bpf()` syscall。详情请查看 `bpf`(2) 手册页。 			

### 10.3.3. BCC 作为技术预览提供

​					`BPF Compiler Collection (BCC)` 用户空间工具套件是创建高效内核追踪和操作程序,在 Red Hat Enterprise Linux 8 中作为技术预览提供。`BCC` 使用 `extended Berkeley Packet Filtering (eBPF)` 提供用于 I/O 分析、联网和监控 Linux 操作系统的工具。 			

## 10.4. 引导过程

### 10.4.1. 如何在 RHEL 8 中安装和引导自定义内核

​					Boot Loader 规格(BLS)定义了一个计划和文件格式,用于管理 drop-in  目录中每个引导选项的引导装载程序配置。不需要操作单独的 drop-in 配置文件。这在 Red Hat Enterprise Linux 8  中尤其重要，因为不是所有构架都使用相同的引导装载程序： 			

- ​							带有开源固件的 `x86_64`、`aarch64` 和 `ppc64le` 使用 `GRUB2` 					
- ​							使用 Open Power Abstraction Layer（OPAL）的 `ppc64le` 使用 `Petitboot` 					
- ​							`s390x` 使用 `zipl` 					

​					每个引导装载程序都有不同的配置文件和格式，在安装或删除新内核时必须修改这些格式。在以前的 Red Hat Enterprise Linux 版本中，允许进行此任务的组件是 `grubby` 工具。但是，对于 Red Hat Enterprise Linux 8，引导装载程序配置通过实施 BLS 文件格式实现标准化，其中 `grubby` 作为与 BLS 操作相关的精简打包程序。 			

### 10.4.2. RHEL 8 对 kdump 的早期支持

​					在以前的版本中，`kdump` 服务启动太晚，无法注册引导过程早期发生的内核崩溃。因此，崩溃信息以及进行故障排除的机会会丢失。 			

​					为了解决这个问题，RHEL 8 引入了 `early kdump` 支持。要了解有关此机制的更多信息，请参阅 `/usr/share/doc/kexec-tools/early-kdump-howto.txt` 文件。另请参阅[早期 kdump 支持以及如何配置它？](https://access.redhat.com/solutions/3700611) 			

# 第 11 章 硬件启用

## 11.1. 删除的硬件支持

​				本节列出了 RHEL 7 支持但在 RHEL 8.0 中不再提供的设备驱动程序和适配器。 		

### 11.1.1. 删除的设备驱动程序

​					RHEL 8 中删除了对以下设备驱动程序的支持： 			

- ​							3w-9xxx 					
- ​							3w-sas 					
- ​							aic79xx 					
- ​							aoe 					
- ​							arcmsr 					
- ​							ata 驱动： 					
  - ​									acard-ahci 							
  - ​									sata_mv 							
  - ​									sata_nv 							
  - ​									sata_promise 							
  - ​									sata_qstor 							
  - ​									sata_sil 							
  - ​									sata_sil24 							
  - ​									sata_sis 							
  - ​									sata_svw 							
  - ​									sata_sx4 							
  - ​									sata_uli 							
  - ​									sata_via 							
  - ​									sata_vsc 							
- ​							bfa 					
- ​							cxgb3 					
- ​							cxgb3i 					
- ​							e1000 					
- ​							floppy 					
- ​							hptiop 					
- ​							initio 					
- ​							isci 					
- ​							iw_cxgb3 					
- ​							mptbase - 此驱动程序保留给虚拟化用例，并便于开发人员过渡。但是，它不被支持。 					
- ​							mptctl 					
- ​							mptsas - 此驱动程序保留给虚拟化用例，并方便开发人员过渡。但是，它不被支持。 					
- ​							mptscsih - 此驱动程序保留给虚拟化用例，并便于开发人员过渡。但是，它不被支持。 					
- ​							mptspi - 此驱动程序保留给虚拟化用例，并方便开发人员过渡。但是，它不被支持。 					
- ​							mthca 					
- ​							mtip32xx 					
- ​							mvsas 					
- ​							mvumi 					
- ​							OSD 驱动程序： 					
  - ​									osd 							
  - ​									libosd 							
- ​							osst 					
- ​							pata 驱动： 					
  - ​									pata_acpi 							
  - ​									pata_ali 							
  - ​									pata_amd 							
  - ​									pata_arasan_cf 							
  - ​									pata_artop 							
  - ​									pata_atiixp 							
  - ​									pata_atp867x 							
  - ​									pata_cmd64x 							
  - ​									pata_cs5536 							
  - ​									pata_hpt366 							
  - ​									pata_hpt37x 							
  - ​									pata_hpt3x2n 							
  - ​									pata_hpt3x3 							
  - ​									pata_it8213 							
  - ​									pata_it821x 							
  - ​									pata_jmicron 							
  - ​									pata_marvell 							
  - ​									pata_netcell 							
  - ​									pata_ninja32 							
  - ​									pata_oldpiix 							
  - ​									pata_pdc2027x 							
  - ​									pata_pdc202xx_old 							
  - ​									pata_piccolo 							
  - ​									pata_rdc 							
  - ​									pata_sch 							
  - ​									pata_serverworks 							
  - ​									pata_sil680 							
  - ​									pata_sis 							
  - ​									pata_via 							
  - ​									pdc_adma 							
- ​							pm80xx(pm8001) 					
- ​							pmcraid 					
- ​							qla3xxx - 此驱动程序保留给虚拟化用例，并便于开发人员过渡。但是，它不被支持。 					
- ​							qlcnic 					
- ​							qlge 					
- ​							stex 					
- ​							sx8 					
- ​							tulip 					
- ​							ufshcd 					
- ​							无线驱动程序： 					
  - ​									carl9170 							
  - ​									iwl4965 							
  - ​									iwl3945 							
  - ​									mwl8k 							
  - ​									rt73usb 							
  - ​									rt61pci 							
  - ​									rtl8187 							
  - ​									wil6210 							

### 11.1.2. 删除的适配器

​					RHEL 8 中删除了对以下列出的适配器的支持。对以上驱动程序中列出的适配器以外的适配器的支持没有改变。 			

​					PCI ID 的格式是 *vendor:device:subvendor:subdevice*。如果没有列出 *subdevice* 或 *subvendor:subdevice* 条目，则会删除具有此类缺失条目值的设备。 			

​					要在您的系统中检查硬件的 PCI ID，请运行 `lspci -nn` 命令。 			

- ​							从 `aacraid` 驱动程序中删除了以下适配器： 					
  - ​									PERC 2/Si (Iguana/PERC2Si), PCI ID 0x1028:0x0001:0x1028:0x0001 							
  - ​									PERC 3/Di (Opal/PERC3Di), PCI ID 0x1028:0x0002:0x1028:0x0002 							
  - ​									PERC 3/Si (SlimFast/PERC3Si), PCI ID 0x1028:0x0003:0x1028:0x0003 							
  - ​									PERC 3/Di (Iguana FlipChip/PERC3DiF), PCI ID 0x1028:0x0004:0x1028:0x00d0 							
  - ​									PERC 3/Di (Viper/PERC3DiV), PCI ID 0x1028:0x0002:0x1028:0x00d1 							
  - ​									PERC 3/Di (Lexus/PERC3DiL), PCI ID 0x1028:0x0002:0x1028:0x00d9 							
  - ​									PERC 3/Di (Jaguar/PERC3DiJ), PCI ID 0x1028:0x000a:0x1028:0x0106 							
  - ​									PERC 3/Di (Dagger/PERC3DiD), PCI ID 0x1028:0x000a:0x1028:0x011b 							
  - ​									PERC 3/Di (Boxster/PERC3DiB), PCI ID 0x1028:0x000a:0x1028:0x0121 							
  - ​									catapult, PCI ID 0x9005:0x0283:0x9005:0x0283 							
  - ​									tomcat, PCI ID 0x9005:0x0284:0x9005:0x0284 							
  - ​									Adaptec 2120S (Crusader), PCI ID 0x9005:0x0285:0x9005:0x0286 							
  - ​									Adaptec 2200S (Vulcan), PCI ID 0x9005:0x0285:0x9005:0x0285 							
  - ​									Adaptec 2200S (Vulcan-2m), PCI ID 0x9005:0x0285:0x9005:0x0287 							
  - ​									Legend S220 (Legend Crusader), PCI ID 0x9005:0x0285:0x17aa:0x0286 							
  - ​									Legend S230 (Legend Vulcan), PCI ID 0x9005:0x0285:0x17aa:0x0287 							
  - ​									Adaptec 3230S (Harrier), PCI ID 0x9005:0x0285:0x9005:0x0288 							
  - ​									Adaptec 3240S (Tornado), PCI ID 0x9005:0x0285:0x9005:0x0289 							
  - ​									ASR-2020ZCR SCSI PCI-X ZCR (Skyhawk), PCI ID 0x9005:0x0285:0x9005:0x028a 							
  - ​									ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator), PCI ID 0x9005:0x0285:0x9005:0x028b 							
  - ​									ASR-2230S + ASR-2230SLP PCI-X (Lancer), PCI ID 0x9005:0x0286:0x9005:0x028c 							
  - ​									ASR-2130S (Lancer), PCI ID 0x9005:0x0286:0x9005:0x028d 							
  - ​									AAR-2820SA (Intruder), PCI ID 0x9005:0x0286:0x9005:0x029b 							
  - ​									AAR-2620SA (Intruder), PCI ID 0x9005:0x0286:0x9005:0x029c 							
  - ​									AAR-2420SA (Intruder), PCI ID 0x9005:0x0286:0x9005:0x029d 							
  - ​									ICP9024RO (Lancer), PCI ID 0x9005:0x0286:0x9005:0x029e 							
  - ​									ICP9014RO (Lancer), PCI ID 0x9005:0x0286:0x9005:0x029f 							
  - ​									ICP9047MA (Lancer), PCI ID 0x9005:0x0286:0x9005:0x02a0 							
  - ​									ICP9087MA (Lancer), PCI ID 0x9005:0x0286:0x9005:0x02a1 							
  - ​									ICP5445AU (Hurricane44), PCI ID 0x9005:0x0286:0x9005:0x02a3 							
  - ​									ICP9085LI (Marauder-X), PCI ID 0x9005:0x0285:0x9005:0x02a4 							
  - ​									ICP5085BR (Marauder-E), PCI ID 0x9005:0x0285:0x9005:0x02a5 							
  - ​									ICP9067MA (Intruder-6), PCI ID 0x9005:0x0286:0x9005:0x02a6 							
  - ​									Themisto Jupiter Platform, PCI ID 0x9005:0x0287:0x9005:0x0800 							
  - ​									Themisto Jupiter Platform, PCI ID 0x9005:0x0200:0x9005:0x0200 							
  - ​									Callisto Jupiter Platform, PCI ID 0x9005:0x0286:0x9005:0x0800 							
  - ​									ASR-2020SA SATA PCI-X ZCR (Skyhawk), PCI ID 0x9005:0x0285:0x9005:0x028e 							
  - ​									ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator), PCI ID 0x9005:0x0285:0x9005:0x028f 							
  - ​									AAR-2410SA PCI SATA 4ch (Jaguar II), PCI ID 0x9005:0x0285:0x9005:0x0290 							
  - ​									CERC SATA RAID 2 PCI SATA 6ch (DellCorsair), PCI ID 0x9005:0x0285:0x9005:0x0291 							
  - ​									AAR-2810SA PCI SATA 8ch (Corsair-8), PCI ID 0x9005:0x0285:0x9005:0x0292 							
  - ​									AAR-21610SA PCI SATA 16ch (Corsair-16), PCI ID 0x9005:0x0285:0x9005:0x0293 							
  - ​									ESD SO-DIMM PCI-X SATA ZCR (Prowler), PCI ID 0x9005:0x0285:0x9005:0x0294 							
  - ​									AAR-2610SA PCI SATA 6ch, PCI ID 0x9005:0x0285:0x103C:0x3227 							
  - ​									ASR-2240S (SabreExpress), PCI ID 0x9005:0x0285:0x9005:0x0296 							
  - ​									ASR-4005, PCI ID 0x9005:0x0285:0x9005:0x0297 							
  - ​									IBM 8i (AvonPark), PCI ID 0x9005:0x0285:0x1014:0x02F2 							
  - ​									IBM 8i (AvonPark Lite), PCI ID 0x9005:0x0285:0x1014:0x0312 							
  - ​									IBM 8k/8k-l8 (Aurora), PCI ID 0x9005:0x0286:0x1014:0x9580 							
  - ​									IBM 8k/8k-l4 (Aurora Lite), PCI ID 0x9005:0x0286:0x1014:0x9540 							
  - ​									ASR-4000 (BlackBird), PCI ID 0x9005:0x0285:0x9005:0x0298 							
  - ​									ASR-4800SAS (Marauder-X), PCI ID 0x9005:0x0285:0x9005:0x0299 							
  - ​									ASR-4805SAS (Marauder-E), PCI ID 0x9005:0x0285:0x9005:0x029a 							
  - ​									ASR-3800 (Hurricane44), PCI ID 0x9005:0x0286:0x9005:0x02a2 							
  - ​									Perc 320/DC, PCI ID 0x9005:0x0285:0x1028:0x0287 							
  - ​									Adaptec 5400S (Mustang), PCI ID 0x1011:0x0046:0x9005:0x0365 							
  - ​									Adaptec 5400S (Mustang), PCI ID 0x1011:0x0046:0x9005:0x0364 							
  - ​									Dell PERC2/QC, PCI ID 0x1011:0x0046:0x9005:0x1364 							
  - ​									HP NetRAID-4M, PCI ID 0x1011:0x0046:0x103c:0x10c2 							
  - ​									Dell Catchall, PCI ID 0x9005:0x0285:0x1028 							
  - ​									Legend Catchall, PCI ID 0x9005:0x0285:0x17aa 							
  - ​									Adaptec Catch All, PCI ID 0x9005:0x0285 							
  - ​									Adaptec Rocket Catch All, PCI ID 0x9005:0x0286 							
  - ​									Adaptec NEMER/ARK Catch All, PCI ID 0x9005:0x0288 							
- ​							`mlx4_core` 驱动程序中的以下 Mellanox Gen2 和 ConnectX-2 适配器已被删除： 					
  - ​									PCI ID 0x15B3:0x1002 							
  - ​									PCI ID 0x15B3:0x676E 							
  - ​									PCI ID 0x15B3:0x6746 							
  - ​									PCI ID 0x15B3:0x6764 							
  - ​									PCI ID 0x15B3:0x675A 							
  - ​									PCI ID 0x15B3:0x6372 							
  - ​									PCI ID 0x15B3:0x6750 							
  - ​									PCI ID 0x15B3:0x6368 							
  - ​									PCI ID 0x15B3:0x673C 							
  - ​									PCI ID 0x15B3:0x6732 							
  - ​									PCI ID 0x15B3:0x6354 							
  - ​									PCI ID 0x15B3:0x634A 							
  - ​									PCI ID 0x15B3:0x6340 							
- ​							从 `mpt2sas` 驱动程序中删除了以下适配器： 					
  - ​									SAS2004, PCI ID 0x1000:0x0070 							
  - ​									SAS2008, PCI ID 0x1000:0x0072 							
  - ​									SAS2108_1, PCI ID 0x1000:0x0074 							
  - ​									SAS2108_2, PCI ID 0x1000:0x0076 							
  - ​									SAS2108_3, PCI ID 0x1000:0x0077 							
  - ​									SAS2116_1, PCI ID 0x1000:0x0064 							
  - ​									SAS2116_2, PCI ID 0x1000:0x0065 							
  - ​									SSS6200, PCI ID 0x1000:0x007E 							
- ​							从 `megaraid_sas` 驱动程序中删除了以下适配器： 					
  - ​									Dell PERC5, PCI ID 0x1028:0x0015 							
  - ​									SAS1078R, PCI ID 0x1000:0x0060 							
  - ​									SAS1078DE, PCI ID 0x1000:0x007C 							
  - ​									SAS1064R, PCI ID 0x1000:0x0411 							
  - ​									VERDE_ZCR, PCI ID 0x1000:0x0413 							
  - ​									SAS1078GEN2, PCI ID 0x1000:0x0078 							
  - ​									SAS0079GEN2, PCI ID 0x1000:0x0079 							
  - ​									SAS0073SKINNY, PCI ID 0x1000:0x0073 							
  - ​									SAS0071SKINNY, PCI ID 0x1000:0x0071 							
- ​							从 `qla2xxx` 驱动程序中删除了以下适配器： 					
  - ​									ISP24xx, PCI ID 0x1077:0x2422 							
  - ​									ISP24xx, PCI ID 0x1077:0x2432 							
  - ​									ISP2422, PCI ID 0x1077:0x5422 							
  - ​									QLE220, PCI ID 0x1077:0x5432 							
  - ​									QLE81xx, PCI ID 0x1077:0x8001 							
  - ​									QLE10000, PCI ID 0x1077:0xF000 							
  - ​									QLE84xx, PCI ID 0x1077:0x8044 							
  - ​									QLE8000, PCI ID 0x1077:0x8432 							
  - ​									QLE82xx, PCI ID 0x1077:0x8021 							
- ​							从 `qla4xxx` 驱动程序中删除了以下适配器： 					
  - ​									QLOGIC_ISP8022, PCI ID 0x1077:0x8022 							
  - ​									QLOGIC_ISP8324, PCI ID 0x1077:0x8032 							
  - ​									QLOGIC_ISP8042, PCI ID 0x1077:0x8042 							
- ​							从 `be2iscsi` 驱动程序中删除了以下适配器： 					
  - ​									BladeEngine 2(BE2)设备 							
    - ​											BladeEngine2 10Gb iSCSI Initiator (generic), PCI ID 0x19a2:0x212 									
    - ​											OneConnect OCe10101, OCm10101, OCe10102, OCm10102 BE2 适配器系列, PCI ID 0x19a2:0x702 									
    - ​											OCE10100 BE2 适配器系列, PCI ID 0x19a2:0x703 									
  - ​									BladeEngine 3（BE3）设备 							
    - ​											OneConnect TOMCAT iSCSI, PCI ID 0x19a2:0x0712 									
    - ​											BladeEngine3 iSCSI, PCI ID 0x19a2:0x0222 									
- ​							移除了由 `be2net` 驱动程序控制的以下以太网适配器： 					
  - ​									BladeEngine 2(BE2)设备 							
    - ​											OneConnect TIGERSHARK NIC, PCI ID 0x19a2:0x0700 									
    - ​											BladeEngine2 Network Adapter, PCI ID 0x19a2:0x0211 									
  - ​									BladeEngine 3（BE3）设备 							
    - ​											OneConnect TOMCAT NIC, PCI ID 0x19a2:0x0710 									
    - ​											BladeEngine3 Network Adapter, PCI ID 0x19a2:0x0221 									
- ​							从 `lpfc` 驱动程序中删除了以下适配器： 					
  - ​									BladeEngine 2(BE2)设备 							
    - ​											OneConnect TIGERSHARK FCoE, PCI ID 0x19a2:0x0704 									
  - ​									BladeEngine 3（BE3）设备 							
    - ​											OneConnect TOMCAT FCoE, PCI ID 0x19a2:0x0714 									
  - ​									光纤通道(FC)设备 							
    - ​											FIREFLY, PCI ID 0x10df:0x1ae5 									
    - ​											PROTEUS_VF, PCI ID 0x10df:0xe100 									
    - ​											BALIUS, PCI ID 0x10df:0xe131 									
    - ​											PROTEUS_PF, PCI ID 0x10df:0xe180 									
    - ​											RFLY, PCI ID 0x10df:0xf095 									
    - ​											PFLY, PCI ID 0x10df:0xf098 									
    - ​											LP101, PCI ID 0x10df:0xf0a1 									
    - ​											TFLY, PCI ID 0x10df:0xf0a5 									
    - ​											BSMB, PCI ID 0x10df:0xf0d1 									
    - ​											BMID, PCI ID 0x10df:0xf0d5 									
    - ​											ZSMB, PCI ID 0x10df:0xf0e1 									
    - ​											ZMID, PCI ID 0x10df:0xf0e5 									
    - ​											NEPTUNE, PCI ID 0x10df:0xf0f5 									
    - ​											NEPTUNE_SCSP, PCI ID 0x10df:0xf0f6 									
    - ​											NEPTUNE_DCSP, PCI ID 0x10df:0xf0f7 									
    - ​											FALCON, PCI ID 0x10df:0xf180 									
    - ​											SUPERFLY, PCI ID 0x10df:0xf700 									
    - ​											DRAGONFLY, PCI ID 0x10df:0xf800 									
    - ​											CENTAUR, PCI ID 0x10df:0xf900 									
    - ​											PEGASUS, PCI ID 0x10df:0xf980 									
    - ​											THOR, PCI ID 0x10df:0xfa00 									
    - ​											VIPER, PCI ID 0x10df:0xfb00 									
    - ​											LP10000S, PCI ID 0x10df:0xfc00 									
    - ​											LP11000S, PCI ID 0x10df:0xfc10 									
    - ​											LPE11000S, PCI ID 0x10df:0xfc20 									
    - ​											PROTEUS_S, PCI ID 0x10df:0xfc50 									
    - ​											HELIOS, PCI ID 0x10df:0xfd00 									
    - ​											HELIOS_SCSP, PCI ID 0x10df:0xfd11 									
    - ​											HELIOS_DCSP, PCI ID 0x10df:0xfd12 									
    - ​											ZEPHYR, PCI ID 0x10df:0xfe00 									
    - ​											HORNET, PCI ID 0x10df:0xfe05 									
    - ​											ZEPHYR_SCSP, PCI ID 0x10df:0xfe11 									
    - ​											ZEPHYR_DCSP, PCI ID 0x10df:0xfe12 									
  - ​									Lancer FCoE CNA devices 							
    - ​											OCe15104-FM, PCI ID 0x10df:0xe260 									
    - ​											OCe15102-FM, PCI ID 0x10df:0xe260 									
    - ​											OCm15108-F-P, PCI ID 0x10df:0xe260 									

### 11.1.3. 其他删除的硬件支持

#### 11.1.3.1. 不再支持 AGP 图形卡

​						Red Hat Enterprise Linux 8 不支持使用图形化端口（AGP）总线的图形卡。推荐使用 PCI Express 总线的图形卡替换。 				

#### 11.1.3.2. 删除 FCoE 软件

​						已从 Red Hat Enterprise Linux 8 中删除了使用以太网的光纤（FCoE）软件。具体来说, `fcoe.ko` 内核模块无法通过以太网适配器和驱动程序创建软件 FCoE 接口。这一变化是因为没有为软件管理的 FCoE 采用行业。 				

​						Red Hat Enterprise 8 的具体变更包括： 				

- ​								`fcoe.ko` 内核模块不再可用。这删除了对启用了以太网适配器和驱动程序的数据中心 Bridging 的软件 FCoE 的支持。 						
- ​								FCoE 不再支持通过 Data Center Bridging eXchange(DCBX)进行链路级别的软件配置。`lldpad` 						
  - ​										`fcoe-utils` 工具（特别是 `fcoemon`）默认配置为不验证 DCB 配置或与 `lldpad` 通信。 								
  - ​										`fcoemon` 中的 `lldpad` 集成可能会被永久禁用。 								
- ​								`fcoe-utils` 不再使用 `libhbaapi` 和 `libhbalinux` 库，并不会直接进行红帽测试。 						

​						对以下内容的支持保持不变： 				

- ​								目前支持将显示为光纤通道适配器的 FCoE 适配器到操作系统，且不使用 `fcoe-utils` 管理工具，除非单独备注。这适用于选择 `lpfc` FC 驱动程序支持的适配器。请注意，Red Hat Enterprise Linux 8 没有包括 `bfa` 驱动程序。 						
- ​								目前支持卸载 FCoE 适配器,这些适配器使用 `fcoe-utils` 管理工具,但有自己的内核驱动程序,而不是 `fcoe.ko`,并在驱动程序和/或固件中管理 DCBX 配置,除非在单独的备注中说明。Red Hat Enterprise Linux 8 将继续完全支持 `fnic`、`bnx2fc` 和 `qedf` 驱动程序。 						
- ​								上一个声明涵盖的一些受支持的驱动程序需要 `libfc.ko` 和 `libfcoe.ko` 内核模块。 						

​						如需更多信息，请参阅 [第 12.2.8 节 “Software FCoE 和 Fibre Channel 不再支持目标模式”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index#software-fcoe-and-fibre-channel-no-longer-support-the-target-mode_file-systems-and-storage)。 				

#### 11.1.3.3. RHEL 8 不支持 **e1000** 网络驱动程序

​						在 Red Hat Enterprise Linux 8 中不支持 **e1000** 网络驱动程序。这会影响裸机和虚拟环境。但是，在 RHEL 8 中仍会全面支持较新的 **e1000e** 网络驱动程序。 				

#### 11.1.3.4. RHEL 8 不支持 **tulip** 驱动程序

​						在这个版本中, **tulip** 网络驱动程序不再被支持。因此,当在 Microsoft Hyper-V hypervisor 中使用 RHEL 1 虚拟机(VM)时,"Legacy Network Adapter"设备无法正常工作,从而导致此类虚拟机的 PXE 安装失败。 				

​						要使 PXE 安装正常工作，请在生成 2 Hyper-V 虚拟机上安装 RHEL 8。如果您需要 RHEL 8 第一代虚拟机，请使用 ISO 安装。 				

#### 11.1.3.5. `qla2xxx` 驱动程序不再支持目标模式

​						支持使用 `qla2xxx` QLogic Fibre Channel 驱动程序的目标模式。这一变化的影响有： 				

- ​								内核不再提供 `tcm_qla2xxx` 模块。 						
- ​								`rtslib` 库和 `targetcli` 工具不再支持 `qla2xxx`。 						

​						仍然支持带有 `qla2xxx` 的 initiator 模式。 				

# 第 12 章 文件系统和存储

## 12.1. 文件系统

### 12.1.1. Btrfs 已删除

​					Red Hat Enterprise Linux 8 删除了 Btrfs 文件系统。这包括以下组件： 			

- ​							`btrfs.ko` 内核模块 					
- ​							`btrfs-progs` 软件包 					
- ​							`snapper` 软件包 					

​					您无法再创建、挂载或者安装 Red Hat Enterprise Linux 8 的 Btrfs 文件系统。Anaconda 安装程序和 Kickstart 命令不再支持 Btrfs。 			

### 12.1.2. XFS 现在支持共享的 copy-on-write 数据扩展

​					XFS 支持共享的 copy-on-write  数据扩展功能这个功能可让两个或者多个文件共享一组通用的数据块。当任何一个共享通用块更改的文件时, XFS  会破坏到通用块的链接并创建新文件。这与其他文件系统中找到的 copy-on-write（COW）功能类似。 			

​					共享复制时写入数据扩展： 			

- 速度快

  ​								创建共享副本不会利用磁盘 I/O。 						

- 空间效率

  ​								共享块不消耗额外的磁盘空间。 						

- 透明

  ​								共享常见块操作的文件，类似常规文件。 						

​					用户空间工具可以使用共享的复制时写入数据扩展： 			

- ​							高效文件克隆，比如使用 `cp --reflink` 命令 					
- ​							针对文件的快照 					

​					内核子系统（如 Overlayfs 和 NFS）也使用这个功能来更有效地操作。 			

​					从 `xfsprogs` 软件包版本 `4.17.0-2.el8` 开始，在创建 XFS 文件系统时默认启用共享复制时的数据扩展。 			

​					请注意： Direct Access(DAX)设备目前不支持带有共享复制时写入数据的扩展的 XFS。要创建没有这个功能的 XFS 文件系统，请使用以下命令： 			

```
# mkfs.xfs -m reflink=0 block-device
```

​					Red Hat Enterprise Linux 7 可以使用共享复制时写入数据扩展以只读模式挂载 XFS 文件系统。 			

### 12.1.3. ext4 文件系统现在支持元数据 checksum

​					在这个版本中, ext4 元数据受到 checksum 的保护。这可让文件系统识别损坏的元数据,这样可避免损坏并增加文件系统的恢复能力。 			

### 12.1.4. `/etc/sysconfig/nfs` 文件和旧的 NFS 服务名称不再可用

​					在 Red Hat Enterprise Linux 8.0 中，NFS 配置已从 `/etc/sysconfig/nfs` 配置文件移至 `/etc/nfs.conf`。 			

​					`/etc/nfs.conf` 文件使用不同的语法。Red Hat Enterprise Linux 8 尝试在从 Red Hat Enterprise Linux 7 升级时自动将所有选项从 `/etc/sysconfig/nfs` 转换为 `/etc/nfs.conf`。 			

​					这两个配置文件在 Red Hat Enterprise Linux 7 中都被支持。红帽建议您使用新的 `/etc/nfs.conf` 文件在所有 Red Hat Enterprise Linux 版本与自动配置系统兼容时进行 NFS 配置。 			

​					另外，以下 NFS 服务别名已被删除，并使用它们的上游名称替换： 			

- ​							`nfs.service`，被 `nfs-server.service` 替换 					
- ​							`nfs-secure.service`，被 `rpc-gssd.service` 替换 					
- ​							`rpcgssd.service`，被 `rpc-gssd.service` 替换 					
- ​							`nfs-idmap.service`，被 `nfs-idmapd.service` 替换 					
- ​							`rpcidmapd.service`，被 `nfs-idmapd.service` 替换 					
- ​							`nfs-lock.service`，被 `rpc-statd.service` 替换 					
- ​							`nfslock.service`，被 `rpc-statd.service` 替换 					

## 12.2. 存储

### 12.2.1. BOOM 引导管理器简化了创建引导条目的过程

​					BOOM 是 Linux 系统的引导管理器,它使用引导装载程序支持 BootLoader 规格进行引导条目配置。它启用了灵活的引导配置,并简化了新引导条目的创建过程：例如：引导使用 LVM 创建的系统的快照镜像。 			

​					BOOM 不会修改现有的引导装载程序配置，仅插入附加条目。现有配置已被维护,所有发行版集成（如内核安装和更新脚本）都可以象以前一样继续正常工作。 			

​					BOOM 有一个简化的命令行界面(CLI)和 API,用于简化引导条目的任务。 			

### 12.2.2. Stratis 现在可用

​					Stratis 是一个新的本地存储管理器。它在存储池的上面为用户提供额外的功能。 			

​					Stratis 可让您更轻松地执行存储任务，比如： 			

- ​							管理快照和精简配置 					
- ​							根据需要自动增大文件系统大小 					
- ​							维护文件系统 					

​					要管理 Stratis 存储，使用 `stratis` 工具与 `stratisd` 后台服务通信。 			

​					Stratis 作为技术预览提供。 			

​					如需更多信息，请参阅 Stratis 文档：[使用 Stratis 管理分层本地存储](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/managing-layered-local-storage-with-stratis_managing-file-systems)。 			

### 12.2.3. LUKS2 现在是加密卷的默认格式

​					在 RHEL 8 中,LUKS 版本 2(LUKS2)格式替换了旧的 LUKS(LUKS1)格式。`dm-crypt` 子系统和 `cryptsetup` 工具现在使用 LUKS2 作为加密卷的默认格式。LUKS2 在出现部分元数据崩溃事件时，为加密卷提供元数据冗余和自动恢复功能。 			

​					由于内部布局，LUKS2 也是将来功能的启用器。它支持通过 `libcryptsetup` 中构建的通用内核密钥令牌自动解锁，允许用户使用存储在内核密钥环保留服务的密码短语解锁 LUKS2 卷。 			

​					其他显著改进包括： 			

- ​							使用嵌套密钥加密方案进行保护的密钥设置。 					
- ​							更轻松地与基于策略的加密（Clevis）集成。 					
- ​							最多 32 个密钥插槽 - LUKS1 只提供 8 个密钥插槽。 					

​					详情请查看 `cryptsetup(8)` 和 `cryptsetup-reencrypt(8)` man page。 			

### 12.2.4. 块设备的多队列调度

​					块设备现在在 Red Hat Enterprise Linux 8 中使用多队列调度。这可让块层性能针对使用快速固态驱动器（SSD）和多核系统进行正常扩展。 			

​					SCSI 多队列（`scsi-mq`）驱动程序现在默认启用，内核使用 `scsi_mod.use_blk_mq=Y` 选项引导。这个改变与上游 Linux 内核是一致的。 			

​					设备映射器多路径（DM 多路径）需要 `scsi-mq` 驱动程序处于活跃状态。 			

### 12.2.5. VDO 现在支持所有构架

​					Virtual Data Optimizer(VDO)现在包括在 RHEL 8 支持的所有架构中。 			

### 12.2.6. VDO 不再支持读取缓存

​					读取缓存功能已从 Virtual Data Optimizer(VDO)中删除。VDO 卷中总是禁用读取缓存，您无法再使用 `vdo` 工具的 `--readCache` 选项启用它。 			

​					红帽可能会使用不同的实现在以后的 Red Hat Enterprise Linux 发行版本中重新引入 VDO 读取缓存。 			

### 12.2.7. 已删除 `dmraid` 软件包

​					`dmraid` 软件包已从 Red Hat Enterprise Linux 8 中删除。需要支持组合硬件和软件 RAID 主机总线适配器(HBA)的用户应该使用 `mdadm` 工具,它支持原生 MD 软件 RAID、SNIA RAID Common Disk Data Format(DDF)格式,以及 Intel® Matrix Storage Manager(IMSM)格式。 			

### 12.2.8. Software FCoE 和 Fibre Channel 不再支持目标模式

- ​							Software FCoE: NIC Software FCoE 目标功能在 Red Hat Enterprise Linux 8.0 中被删除。 					
- ​							Fibre Channel 不再支持目标模式。在 Red Hat Enterprise Linux 8.0 中，`qla2xxx` QLogic Fibre Channel 驱动程序禁用目标模式。 					

​					如需更多信息，请参阅 [第 11.1.3.2 节 “删除 FCoE 软件”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index#fcoe-sw-removal_hardware-enablement)。 			

### 12.2.9. 改进了在 DM 多路径中发现的边缘路径

​					`multipathd` 服务现在支持改进的路径检测。这有助于多路径设备避免可能重复失败的路径,并提高性能。边缘路径（Marginal paths）是带有持久性但可能会出现 I/O 错误的路径。 			

​					`/etc/multipath.conf` 文件中的以下选项控制边缘路径行为： 			

- ​							`marginal_path_double_failed_time` 					
- ​							`marginal_path_err_sample_time` 					
- ​							`marginal_path_err_rate_threshold` 					
- ​							`marginal_path_err_recheck_gap_time` 					

​					DM 多路径在配置的示例时间中禁用路径并使用重复 I/O 进行测试，如果： 			

- ​							设定了列出的 `multipath.conf` 选项， 					
- ​							路径在配置的时间里失败两次，同时 					
- ​							其它路径可用。 					

​					如果在测试过程中该路径的配置的错误率大于配置的错误率,DM 多路径会忽略它来配置的空白时间,然后重新测试它以查看它是否正常工作足以恢复。 			

​					详情请查看 `multipath.conf` man page。 			

### 12.2.10. DM 多路径配置文件的新 `overrides` 部分

​					`/etc/multipath.conf` 文件现在包含一个 `overrides` 部分，它允许您为所有设备设置配置值。这些属性可由 DM 多路径为所有设备使用，除非被文件 `/etc/multipath.conf` 的 `multipaths` 部分中指定的属性覆盖。这个功能替换了配置文件的 `devices` 部分中的 `all_devs` 参数，这个参数不再被支持。 			

### 12.2.11. Broadcom Emulex 和 Marvell Qlogic Fibre Channel 适配器完全支持 NVMe/FC

​					现在,当与支持 NVMe 的 Broadcom Emulex 和 Marvell Qlogic Fibre Channel  32Gbit 适配器一起使用时,Initiator 模式中完全支持 NVMe over Fibre Channel(NVMe/FC)传输类型。 			

​					NVMe over Fibre Channel 是 Nonvolatile Memory  Express(NVMe)协议的附加光纤传输类型,它之前在 Red Hat Enterprise Linux 中引进了 Remote  Direct Memory Access(RDMA)协议。 			

​					启用 NVMe/FC: 			

- ​							要在 `lpfc` 驱动程序中启用 NVMe/FC,编辑 `/etc/modprobe.d/lpfc.conf` 文件并添加以下选项： 					

  ```
  lpfc_enable_fc4_type=3
  ```

- ​							要在 `qla2xxx` 驱动程序中启用 NVMe/FC，编辑 `/etc/modprobe.d/qla2xxx.conf` 文件并添加以下选项： 					

  ```
  qla2xxx.ql2xnvmeenable=1
  ```

​					其他限制： 			

- ​							NVMe/FC 不支持多路径。 					
- ​							NVMe/FC 不支持 NVMe 集群。 					
- ​							使用 Marvell QLogic 适配器时，Red Hat Enterprise Linux 不支持同时在启动端口中使用 NVMe/FC 和 SCSI/FC。 					
- ​							`kdump` 不支持 NVMe/FC。 					
- ​							不支持从 Storage Area Network (SAN) NVMe/FC 引导。 					

### 12.2.12. 支持 Data Integrity Field/Data Integrity Extension（DIF/DIX）

​					DIF/DIX 是 SCSI 标准的补充。它在所有 HBA 和存储阵列中仍为技术预览,但那些特别列为受支持的数组除外。 			

​					DIF/DIX 将通常使用的 512 字节磁盘块的大小从 512 字节增加到 520 字节,添加了 Data Integrity  字段(DIF)。DIF 为数据块存储 checksum 值,该值由主机总线适配器(HBA)在写入时计算。然后存储设备会确认 unit 的  checksum,并存储数据和 checksum。相反,当发生读取时,可以通过存储设备和接收的 HBA 验证 checksum。 			

### 12.2.13. 已删除 libstoragemgmt-netapp-plugin

​					`libStorageMgmt` 库使用的 `libstoragemgmt-netapp-plugin` 软件包已被删除。它不再被支持，因为： 			

- ​							软件包需要 NetApp 7-mode API，NetApp 会逐渐弃用它。 					
- ​							RHEL 8 删除了使用 `TLS_RSA_WITH_3DES_EDE_CBC_SHA` 密码的 TLSv1.0 协议的默认支持，在 TLS 中使用此插件无法正常工作。 					

## 12.3. LVM

### 12.3.1. 移除 `clvmd` 管理共享存储设备

​					LVM 不再使用 `clvmd` （集群 lvm 守护进程）来管理共享存储设备。LVM 现在使用 `lvmlockd` （lvm lock 守护进程）。 			

- ​							有关使用 `lvmlockd` 的详情，请查看 `lvmlockd(8)` man page。有关一般使用共享存储的详情，请查看 `lvmsystemid(7)` man page。 					
- ​							有关在 Pacemaker 集群中使用 LVM 的详情，请参考 `LVM-activate` 资源代理的帮助页面。 					
- ​							有关在红帽高可用性集群中配置共享逻辑卷的步骤示例，请参考[在集群中配置 GFS2 文件系统。](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_high_availability_clusters/#assembly_configuring-gfs2-in-a-cluster-configuring-and-managing-high-availability-clusters) 					

### 12.3.2. 删除 `lvmetad` 守护进程

​					LVM 不再使用 `lvmetad` 守护进程来缓存元数据，并将始终从磁盘读取元数据。LVM 磁盘读取减少,这降低了缓存的好处。 			

​					在以前的版本中,自动激活逻辑卷会间接与 `lvm.conf` 配置文件中的 `use_lvmetad` 设置关联。禁用自动激活的正确方法是在 `lvm.conf` 文件中设置 `auto_activation_volume_list`。 			

### 12.3.3. LVM 无法再管理使用 GFS 池卷管理器或 `lvm1` 元数据格式格式格式的设备。

​					LVM 无法再管理使用 GFS 池卷管理器或'lvm1 元数据格式格式的设备。如果您在引入 Red Hat Enterprise Linux 4 前创建了逻辑卷,则这可能会影响到您。使用 `lvm1` 格式的卷组应该使用 `vgconvert` 命令转换为 `lvm2` 格式。 			

### 12.3.4. 已删除 LVM 库和 LVM Python 绑定

​					由 `lvm2-python-libs` 软件包提供的 `lvm2app` 库和 LVM Python 绑定已被删除。红帽建议使用以下解决方案： 			

- ​							LVM D-Bus API 与 `lvm2-dbusd` 服务相结合。这需要使用 Python 版本 3。 					
- ​							LVM 命令行工具带有 JSON 格式 ; 这个格式化自 `lvm2` 软件包 2.02.158 开始可用。 					
- ​							用于 C/C++ 的 `libblockdev` 库（包含在 AppStream 中） 					

​					在升级到 Red Hat Enterprise Linux 8 前，您必须将任何应用程序使用删除的库和绑定到 D-Bus API。 			

### 12.3.5. 删除了 LVM 镜像日志的镜像功能

​					已删除镜像 LVM 卷的镜像日志功能。Red Hat Enterprise Linux(RHEL)8 不再支持创建或激活带有镜像镜像日志的 LVM 卷。 			

​					推荐的替换有： 			

- ​							RAID1 LVM 卷。RAID1 卷的主要优点是即使在降级模式下工作并在临时故障后恢复的能力。 					
- ​							磁盘镜像日志。要将镜像镜像日志转换为磁盘镜像日志，请使用以下命令： `lvconvert --mirrorlog disk my_vg/my_lv`。 					

# 第 13 章 高可用性和集群

​			在 Red Hat Enterprise Linux 8 中, `pcs` 完全支持 Corosync 3 集群引擎和 Kronosnet(knet)网络抽象层用于集群通信。在计划从现有 RHEL 7 集群升级到 RHEL 8 集群时，您必须考虑以下事项： 	

- ​					**应用程序版本：** RHEL 8 集群需要什么版本的高可用性应用程序？ 			
- ​					**应用程序进程顺序：** 应用程序的启动和停止进程可能需要什么改变？ 			
- ​					**集群基础架构：** 由于 `pcs` 支持 RHEL 8 中的多个网络连接,所以已知的 NIC 数量是否改变？ 			
- ​					**所需的软件包：** 是否需要在新集群中安装所有相同的软件包？ 			

​			由于在 RHEL 8 中运行 Pacemaker 集群的这些注意事项及其他因素,所以无法从 RHEL 7 升级到 RHEL 8 集群,因此您必须在 RHEL 8 中配置一个新集群。您无法运行包含运行 RHEL 7 和 RHEL 8 节点的集群。 	

​			另外，您应该在进行升级前计划进行以下内容： 	

- ​					**最后的中断：** 停止在旧集群中运行的应用程序的过程是什么,并在新集群中启动以减少应用程序停机时间？ 			
- ​					**测试：** 在开发/测试环境中是否可以提前测试您的升级策略？ 			

​			以下列出了 RHEL 7 和 RHEL 8 之间集群创建和管理的主要区别。 	

## 13.1. `pcs cluster setup`、`pcs cluster node add` 和 `pcs cluster node remove` 命令的新格式

​				在 Red Hat Enterprise Linux 8 中, `pcs` 完全支持使用节点名称,这些名称现在需要,并替换节点标识符角色中的节点地址。节点地址现在是可选的。 		

- ​						在 `pcs host auth` 命令中，节点地址默认为节点名称。 				
- ​						在 `pcs cluster setup` 和 `pcs cluster node add` 命令中，节点地址默认为 `pcs host auth` 命令中指定的节点地址。 				

​				进行了这些更改,设置集群、在集群中添加节点以及从集群中删除节点的命令格式已改变。有关这些新命令格式的详情，请查看 `pcs cluster setup`、`pcs cluster node add` 和 `pcs cluster node remove` 命令的帮助信息。 		

## 13.2. 重命名为可升级克隆资源的 master 资源

​				Red Hat Enterprise Linux (RHEL) 8 支持 Pacemaker 2.0，其中的 master/slave 资源不再是一个独立的资源类型，而是带有 `promotable` meta-attribute 设置为 `true` 的标准克隆资源。实施以下更改后，支持此次更新： 		

- ​						无法再使用 `pcs` 命令创建 master 资源。相反，可以创建 `promotable` 克隆资源。相关关键字和命令已从 `master` 改为 `promotable`。 				
- ​						所有现有的 master 资源都显示为 promotable 克隆资源。 				
- ​						在 Web UI 中管理 RHEL7 集群时,master 资源仍称为 master,因为 RHEL7 集群不支持可升级克隆。 				

## 13.3. 用于验证集群中的节点的新命令

​				Red Hat Enterprise Linux(RHEL)8 在用来验证集群中节点的命令中包含了以下更改。 		

- ​						新命令为 `pcs host auth`。此命令允许用户指定主机名、地址和 `pcsd` 端口。 				
- ​						`pcs cluster auth` 命令只验证本地集群中的节点,且不接受节点列表 				
- ​						现在可以为每个节点指定地址。`pcs`/`pcsd` 然后将使用指定的地址与每个节点通信。这些地址可以与 `corosync` 内部使用的地址不同。 				
- ​						`pcs pcsd clear-auth` 命令已被 `pcs pcsd deauth` 和 `pcs host deauth` 命令替代。新命令允许用户验证单个主机以及所有主机。 				
- ​						在以前的版本中,节点身份验证是双向的,运行 `pcs cluster auth` 命令会导致相互验证所有指定的节点。但是, `pcs host auth` 命令只会导致根据指定节点验证本地主机。这样可更好地控制在运行此命令时根据其他节点验证哪些节点。在集群设置本身上,同时在添加节点时, `pcs` 会自动同步集群中的令牌,因此集群中的所有节点仍会像之前自动进行身份验证,集群节点可以相互通信。 				

​				请注意,这些更改不是后向兼容的。在 RHEL 7 系统中验证的节点需要再次进行身份验证。 		

## 13.4. 红帽高可用性主动/被动集群中的 LVM 卷

​				当在 RHEL 8 中将 LVM 卷配置为 Red Hat HA 主动/被动集群中的资源时,您可以将该卷配置为 `LVM-activate` 资源。在 RHEL 7 中，您可以将卷配置为 `LVM` 资源。有关在 RHEL 8 中将 LVM 卷配置为资源的集群配置步骤示例，请参考在[红帽高可用性集群中配置主动/被动 Apache HTTP 服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_high_availability_clusters/index#assembly_configuring-active-passive-http-server-in-a-cluster-configuring-and-managing-high-availability-clusters)。 		

## 13.5. 红帽高可用性主动/主动集群中的共享 LVM 卷

​				在 RHEL 8 中,LVM 使用 LVM 锁定守护进程 `lvmlockd` 而不是 `clvmd` 在主动/主动集群中管理共享存储设备。这要求您配置将 GFS2 文件系统作为共享逻辑卷挂载的逻辑卷。 		

​				另外，这需要您使用 `LVM-activate` 资源代理来管理 LVM 卷，并使用 `lvmlockd` 资源代理来管理 `lvmlockd` 守护进程。 		

​				有关配置使用共享逻辑卷包含 GFS2 文件系统的 RHEL 8 Pacemaker 集群的完整步骤，请参考[在集群中配置 GFS2 文件系统](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_high_availability_clusters/index#proc_configuring-gfs2-in-a-cluster.adoc-configuring-gfs2-cluster)。 		

## 13.6. RHEL 8 Pacemaker 集群中的 GFS2 文件系统

​				在 RHEL 8 中，LVM 使用 LVM 锁定守护进程 `lvmlockd` 而不是 `clvmd` 在主动/主动集群中管理共享存储设备，如 [第 12.3.1 节 “移除 `clvmd` 管理共享存储设备”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index#removal-of-clvmd-for-managing-shared-storage-devices_file-systems-and-storage) 所述。 		

​				要使用在 RHEL 8 集群中的 RHEL 7 系统中创建的 GFS2 文件系统,您必须配置它们在 RHEL 8  系统中作为共享逻辑卷挂载的逻辑卷,且您必须开始锁定卷组。有关将现有 RHEL 7 逻辑卷配置为用于 RHEL 8 Pacemaker  集群的共享逻辑卷的步骤示例，请参考 [从 RHEL7 迁移到 RHEL8 的 GFS2 文件系统](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_high_availability_clusters/index#proc_migrate-gfs2-rhel7-rhel8-configuring-gfs2-cluster)。 		

# 第 14 章 Shell 和命令行工具

## 14.1. 本地化的内容由多个软件包提供

​				在 RHEL 8 中，本地化的内容和翻译不再由单个 `glibc-common` 软件包提供。相反，每个本地化内容和语言都位于 `glibc-langpack-*CODE*` 软件包中。另外，默认不会安装所有本地化内容，而只安装在安装程序中选择的本地化内容。用户必须单独安装所需的本地化软件包。 		

​				为系统的每个软件包安装额外附加软件包（包含翻译、字典和本地化内容）的元数据软件包被称之为 langpacks。 		

​				如需更多信息，请参阅 [安装和使用 langpacks](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/using-langpacks_configuring-basic-system-settings)。 		

## 14.2. 删除了完全由数字组成的用户和组群名称的支持

​				在 Red Hat Enterprise Linux(RHEL)8 中, `useradd` 和 `groupadd` 命令不允许使用完全由数字字符组成的用户和组群名称。不允许此类名称的原因是,这可能会导致一些工具混淆用户和组群名称以及用户和组群 ID。 		

​				请参阅有关[使用命令行工具管理用户](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#managing-users-group-cli_managing-users-groups-permissions)的更多信息。 		

## 14.3. nobody 用户替换 nfsnobody

​				Red Hat Enterprise Linux(RHEL)7 使用 `nobody` 用户和组群对, ID 为 99, `nfsnobody` 用户和组群对 ID 为 65534,也是默认内核溢出 ID。 		

​				在 RHEL 8 中，这两个对已合并到 `nobody` 用户和组对中，其 ID 为 65534。RHEL 8 中没有创建 `nfsnobody` 对。 		

​				这个变化可减少 `nobody` 拥有但与 NFS 无关的文件的混乱。 		

## 14.4. 版本控制系统

​				RHEL 8 提供以下版本控制系统： 		

- ​						`Git 2.18` 是一个分布式修订控制系统，它带有一个分散的构架。 				
- ​						`Mercurial 4.8` 是一个轻量级分布式版本控制系统，用于高效处理大型项目。 				
- ​						`Subversion 1.10` 是一个集中版本控制系统。 				

​				请注意,RHEL 7 中提供的 Concurrent Versions System(CVS)和修订控制系统(RCS)不会在 RHEL 8 中发布。 		

### 14.4.1. `Subversion 1.10` 中的显著变化

​					`Subversion 1.10` 从 RHEL 7 中发布的版本 1.7 开始引入了很多新功能,以及以下兼容性更改： 			

- ​							由于 `Subversion` 库中用于支持语言绑定的不兼容, `Subversion 1.10` 的 `Python 3` 绑定不可用。因此，不支持为 `Subversion` 需要 `Python` 绑定的应用程序。 					
- ​							基于 `Berkeley DB` 的软件仓库不再被支持。在升级前，使用 `svnadmin dump` 命令备份通过 `Subversion 1.7` 创建的软件仓库。安装 RHEL 8 后，使用 `svnadmin load` 命令恢复软件仓库。 					
- ​							在 RHEL 7 中, `Subversion 1.7` 客户端检查的现有工作副本必须升级到新的格式,然后才能从 `Subversion 1.10` 使用。安装 RHEL 8 后，请在每个工作副本中运行 `svn upgrade` 命令。 					
- ​							不再支持通过 `https://` 访问软件仓库的智能卡验证。 					

## 14.5. 软件包从 crontab 条目移到 systemd 计时器

​				`crontab` 条目中使用的软件包现在使用 `systemd` 计时器。运行以下命令以使用 `systemd` 计时器条目查找软件包： 		

```
$ repoquery --qf %{name} -f '/usr/lib/systemd/system/*.timer'
$ repoquery --qf %{name} -f '/etc/cron.*/*'
```

# 第 15 章 动态编程语言、网页服务器、数据库服务器

## 15.1. 动态编程语言

### 15.1.1. Python 中的显著变化

#### 15.1.1.1. RHEL 8 中，`Python 3` 是默认的 `Python` 实现

​						Red Hat Enterprise Linux 8 有几个版本的 `Python 3`。`Python 3.6` RHEL 8 的整个生命周期将受到支持。默认情况下可能不会安装对应的软件包。 				

​						`Python 2.7` 包括在 `python2` 软件包中。但是, `Python 2` 的生命周期会更短,它的目的是为客户提供更慢的生命周期 `Python 3`。 				

​						详情请查看 [Python 版本](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#con_python-versions_assembly_introduction-to-python)。 				

​						RHEL 8 均未提供默认 `python` 软件包和未指定版本的 `/usr/bin/python` 执行文件。我们建议用户直接使用 `python3` 或者 `python2`。另外，管理员也可以使用 `alternatives` 命令配置未指定版本的 `python` 命令。请参阅 [配置未指定版本的 Python](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index#assembly_configuring-the-unversioned-python_dynamic-programming-languages-web-servers-database-servers)。 				

**其它资源**

- ​								[安装和使用 Python](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#assembly_installing-and-using-python_configuring-basic-system-settings) 						
- ​								[打包 Python 3 RPM](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#assembly_packaging-python-3-rpms_configuring-basic-system-settings) 						

#### 15.1.1.2. 从 Python 2 迁移到 Python 3

​						作为开发者，您可能想要将之前使用 Python 2 编写的代码迁移到 Python 3。 				

​						有关如何将大型代码库迁移到 Python 3 的更多信息，请参阅 [Storageative Python 3 Porting Guide](https://portingguide.readthedocs.io/en/latest/#fconservative)。 				

​						请注意,在迁移后,原始 Python 2 代码就可以被 Python 3 解释器解释，也可以被 Python 2 解释器解析。 				

#### 15.1.1.3. 配置未指定版本的 Python

​						系统管理员可以使用 `alternatives` 命令配置位于 `/usr/bin/python` 的未指定版本的 `python` 命令。请注意,在将未指定版本的命令配置为对应的版本前,必须安装所需的 `python3`、`python38`、`python39` 或 `python2` 软件包。 				

重要

​							`/usr/bin/python` 可执行文件由 `alternatives` 系统控制。更新时可能会覆盖任何手动更改。 					

​							其他 Python 相关命令，如 `pip3`，没有可配置的未指定版本的变体。 					

##### 15.1.1.3.1. 直接配置未指定版本的 python 命令

​							您可以将未指定版本的 `python` 命令直接配置为特定的 Python 版本。 					

**先决条件**

- ​									确定安装了 Python 所需的版本。 							

**流程**

- ​									要将未指定版本的 `python` 命令配置为 Python 3.6,请使用： 							

  ```
  # alternatives --set python /usr/bin/python3
  ```

- ​									要将未指定版本的 `python` 命令配置为 Python 3.8,请使用： 							

  ```
  # alternatives --set python /usr/bin/python3.8
  ```

- ​									要将未指定版本的 `python` 命令配置为 Python 3.9,请使用： 							

  ```
  # alternatives --set python /usr/bin/python3.9
  ```

- ​									要将未指定版本的 `python` 命令配置为 Python 2，请使用： 							

  ```
  # alternatives --set python /usr/bin/python2
  ```

##### 15.1.1.3.2. 以互动方式将未指定版本的 python 命令配置为所需的 Python 版本

​							您可以交互式地将未指定版本的 `python` 命令配置为所需的 Python 版本。 					

**先决条件**

- ​									确定安装了 Python 所需的版本。 							

**流程**

1. ​									要以互动方式配置未指定版本的 `python` 命令,请使用： 							

   ```
   # alternatives --config python
   ```

2. ​									从提供的列表中选择所需版本。 							

3. ​									要重置此配置并删除未指定版本的 `python` 命令,请使用： 							

   ```
   # alternatives --auto python
   ```

##### 15.1.1.3.3. 其它资源

- ​									`alternatives(8)` 和 `unversioned-python(1)` man page 							

#### 15.1.1.4. 处理 Python 脚本中的解释器指令

​						在 Red Hat Enterprise Linux 8 中,可执行 Python 脚本应该使用解释器指令（也称为 hashbangs 或 shebangs）,该指令至少明确指定了主 Python 版本。例如： 				

```
#!/usr/bin/python3
#!/usr/bin/python3.6
#!/usr/bin/python2
```

​						在构建任何 RPM 软件包时, `/usr/lib/rpm/redhat/brp-mangle-shebangs` buildroot 策略(BRP)脚本会自动运行,并尝试在所有可执行文件中更正解释器指令。 				

​						BRP 脚本在遇到带有模糊解释器指令的 Python 脚本时会产生错误,例如： 				

```
#!/usr/bin/python
```

​						或者 				

```
#!/usr/bin/env python
```

##### 15.1.1.4.1. 修改 Python 脚本中的解释器指令

​							修改 Python 脚本中导致 RPM 构建时构建错误的解释器指令。 					

**先决条件**

- ​									Python 脚本中的一些解释指令会导致构建错误。 							

**流程**

​								要修改解释器指令,请完成以下任务之一： 						

- ​									应用 `platform-python-devel` 软件包中的 `pathfix.py` 脚本： 							

  ```
  # pathfix.py -pn -i %{__python3} PATH …
  ```

  ​									请注意,可以指定多个 `*PATH*s`。如果 `*PATH*` 是一个目录, `pathfix.py` 将递归扫描与模式 `^[a-zA-Z0-9_]+\.py$` 匹配的 Python 脚本,而不只是那些带有模糊解释器指令的脚本。在 `%prep` 部分添加这个命令,或者在 `%install` 部分末尾添加这个命令。 							

- ​									修改打包的 Python 脚本,使其符合预期格式。为此, `pathfix.py` 也可以在 RPM 构建过程之外使用。当在 RPM 构建之外运行 `pathfix.py` 时,将上面示例中的 `*%{__python3}*` 替换为解释器指令的路径,如 `/usr/bin/python3`。 							

​							如果打包的 Python 脚本需要 Python 3.6 以外的版本,请调整前面的命令使其包含所需的版本。 					

##### 15.1.1.4.2. 更改自定义软件包中的 /usr/bin/python3 解释器指令

​							默认情况下, `/usr/bin/python3` 格式的解释器指令被从 `platform-python` 软件包中指向 Python 的解释器指令替代,该指令用于使用 Red Hat Enterprise Linux 的系统工具。您可以更改自定义软件包中的 `/usr/bin/python3` 解释器指令,以指向从 AppStream 软件仓库安装的 Python 的特定版本。 					

**流程**

- ​									要为 Python 的特定版本构建您的软件包,请将相应的 `python` 软件包的 `*python**-rpm-macros` 子软件包添加到 **SPEC** 文件的 BuildRequires 部分。例如,对于 Python 3.6,包括以下行： 							

  ```
  BuildRequires:  python36-rpm-macros
  ```

  ​									因此,自定义软件包中的 `/usr/bin/python3` 解释器指令会自动转换为 `/usr/bin/python3.6`。 							

注意

​								要防止 BRP 脚本检查和修改解释器指令,请使用以下 RPM 指令： 						

```
%undefine %brp_mangle_shebangs
```

#### 15.1.1.5. `Python` 绑定 `net-snmp` 软件包不可用

​						`Net-SNMP` 工具套件没有为 `Python 3` 提供绑定，它是 RHEL 8 中的默认 `Python` 实现。因此，RHEL 8 不提供 `python-net-snmp`、`python2-net-snmp` 或 `python3-net-snmp` 软件包。 				

### 15.1.2. `PHP` 中的显著变化

​					Red Hat Enterprise Linux 8 带有 `PHP 7.2`。这个版本对 `PHP 5.4` 进行了以下主要更改,可在 RHEL 7 中找到： 			

- ​							`PHP` 默认使用 FastCGI Process Manager(FPM)（与线程搭配使用 `httpd`） 					
- ​							在 `httpd` 配置文件中不应该使用 `php_value` 和 `php-flag` 变量 ; 它们应该在池配置中设置： `/etc/php-fpm.d/*.conf` 					
- ​							`PHP` 脚本错误和警告记录到 `/var/log/php-fpm/www-error.log` 文件，而不是记录到 `/var/log/httpd/error.log` 					
- ​							当更改 PHP `max_execution_time` 配置变量时，应增加 `httpd` `ProxyTimeout` 设置以匹配 					
- ​							运行 `PHP` 脚本的用户现在在 FPM 池配置中配置（ `/etc/php-fpm.d/www.conf` 文件, `apache` 用户是默认的） 					
- ​							`php-fpm` 服务需要在配置更改或安装新扩展后重启 					
- ​							`zip` 扩展已经从 `php-common` 软件包移动到单独的软件包中, `php-pecl-zip` 					

​					删除了以下扩展： 			

- ​							`aspell` 					
- ​							`mysql` （注意 `mysqli` 和 `pdo_mysql` 扩展仍可用，由 `php-mysqlnd` 软件包提供） 					
- ​							`memcache` 					

### 15.1.3. `Perl` 中的显著变化

​					RHEL 8 中的 `Perl 5.26` 与 RHEL 7 中的版本相比有以下变化： 			

- ​							`Unicode 9.0` 现在被支持。 					
- ​							提供了新的 `op-entry`、`loading-file` 和 `loaded-file` `SystemTap` 探测。 					
- ​							在分配 scalars 以提高性能时使用 copy-on-write 机制。 					
- ​							添加了用于处理 IPv4 和 IPv6 套接字的 `IO::Socket::IP` 模块。 					
- ​							添加了以结构方式访问 `perl -V` 数据的 `Config::Perl::V` 模块。 					
- ​							添加了一个新的 `perl-App-cpanminus` 软件包，其中包含从 Perl Archive Network（CPAN）仓库获取、提取、构建和安装模块的 `cpanm` 工具。 					
- ​							出于安全考虑，当前目录 `.` 已从 `@INC` 模块搜索路径中删除。 					
- ​							现在，当因为上述行为更改而加载文件时，`do` 语句会返回弃用警告。 					
- ​							`do subroutine(LIST)` 调用不再被支持，并导致语法错误。 					
- ​							现在，默认随机化哈希。键和值从每个 `perl` 运行的哈希更改返回的顺序。要禁用随机化，将 `PERL_PERTURB_KEYS` 环境变量设置为 `0`。 					
- ​							不再允许在正则表达式中使用未转义的 `{` 字符。 					
- ​							删除了对 `$_` 变量的样式范围支持。 					
- ​							在阵列或哈希中使用 `defined` operator 会导致严重错误。 					
- ​							从 `UNIVERSAL` 模块导入功能会导致严重错误。 					
- ​							`find2perl`、`s2p`、`a2p` `c2ph` 和 `pstruct` 工具已被删除。 					
- ​							`${^ENCODING}` 工具已被删除。`encoding` sragma 的默认模式不再被支持。要在 `UTF-8` 以外的其它编码中写入源代码，请使用编码的 `Filter` 选项。 					
- ​							`perl` 打包现在与上游社区一致。`perl` 软件包也安装核心模块, `/usr/bin/perl` 解释器由 `perl-interpreter` 软件包提供。在以前的版本中, `perl` 软件包只包含一个最小解释器,而 `perl-core` 软件包包含解释器和核心模块。 					
- ​							`IO::Socket::SSL` Perl 模块不再从 `./certs/my-ca.pem` 文件或 `./ca` 目录中载入证书颁发机构证书、`./certs/server-key.pem` 文件中的服务器私钥、来自 `./certs/server-cert.pem` 文件的服务器证书、`./certs/client-key.pem` 文件中的客户端私钥以及 `./certs/client-cert.pem` 文件中的客户端证书。明确指定文件的路径。 					

### 15.1.4. `Ruby` 中的显著变化

​					RHEL 8 提供 `Ruby 2.5`，它比 RHEL 7 中的 `Ruby 2.0.0` 提供了多个新功能和增强。主要变更包括： 			

- ​							添加了增量垃圾收集器。 					
- ​							添加了 `Refinements` 语法。 					
- ​							现在会对符号进行垃圾收集。 					
- ​							`$SAFE=2` 和 `$SAFE=3` 安全级别现已过时。 					
- ​							`Fixnum` 和 `Bignum` 类已统一为 `Integer` 类。 					
- ​							通过优化 `Hash` 类提供了性能，改进了对实例变量的访问，`Mutex` 类更小、更快。 					
- ​							某些旧的 API 已被弃用。 					
- ​							捆绑的库，如 `RubyGems`、`Rake`、`RDoc`、`Psych`、`Minitest` 和 `test-unit` 已更新。 					
- ​							以前，通过 `Ruby` 发布的其它库，如 `mathn`、`DL`、`ext/tk` 和 `XMLRPC` 已被弃用或不再包含。 					
- ​							`SemVer` 版本方案现在用于 `Ruby` 版本。 					

### 15.1.5. `SWIG` 中的显著变化

​					RHEL 8 包括了简化的 Wrapper 和 Interface Generator 版本 3.0,它提供了与 RHEL 7 中发布的 2.0 版本相比的新功能、功能增强和程序错误修复。最值得注意的是，实现了对 C++11 标准的支持。`SWIG` 现在还支持 `Go 1.6`、`PHP 7`、`Octave 4.2` 和 `Python 3.5`。 			

### 15.1.6. `Node.js` RHEL 提供了新功能

​					`Node.js` 是一个软件开发平台,用于使用 JavaScript 编程语言开发快速、可扩展的网络应用程序。它首次在 RHEL 中提供。之前，它只通过 Software Collection 提供。RHEL 8 提供 `Node.js 10`。 			

### 15.1.7. Tcl

​					**工具命令语言(Tcl)** 是一个动态编程语言。这个语言的解释器以及 C 库由 `tcl` 软件包提供。 			

​					使用与 **Tk(\**Tcl/Tk\**** ) **配对** 的 Tcl 可启用跨平台 GUI 应用程序。**TK** 由 `tk` 软件包提供。 			

​					请注意，**Tk** 可以引用以下任意一种： 			

- ​							用于多种语言的编程工具包 					
- ​							Tk C 库绑定可用于多种语言，如 C、Ruby、Perl 和 Python 					
- ​							一个需要解释器来实例化 Tk 控制台 					
- ​							为特定 Tcl 解释器添加多个新命令的 Tk 扩展 					

#### 15.1.7.1. Tcl/Tk 8.6 中的显著变化

​						RHEL 8 提供了 **Tcl/Tk 版本 8.6**,它与 **Tcl/Tk 版本 8.5** 提供了多个显著变化： 				

- ​								基于对象的编程支持 						

- ​								无堆栈评估实施 						

- ​								增强的例外处理 						

- ​								使用 Tcl 构建并安装的第三方软件包集合 						

- ​								启用多线程操作 						

- ​								对 SQL 数据库增强脚本的支持 						

- ​								IPv6 网络支持 						

- ​								内置 Zlib 压缩 						

- ​								列表处理 						

  ​								有两个新命令 `lmap` 和 `dict map` 可用，允许对 **Tcl** 容器进行转换。 						

- ​								根据脚本堆栈的频道 						

  ​								有两个新命令 `chan push` 和 `chan pop` 可用，允许向 I/O 频道添加或删除转换。 						

​						有关 **Tcl/Tk 版本 8.6** 更改和新的功能的详情，请查看以下资源： 				

- ​								[配置基本系统设置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#tcl-notable-changes_getting-started-with-tcl) 						
- ​								[Tcl/Tk 8.6 的更改](https://wiki.tcl-lang.org/page/Changes+in+Tcl%2FTk+8.6) 						

​						如果您需要迁移到 **Tcl/Tk 8.6**，请参阅[迁移到 Tcl/Tk 8.6](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#migrate-to-tcl8.6_getting-started-with-tcl)。 				

## 15.2. Web 服务器

### 15.2.1. Apache HTTP 服务器中的显著变化

​					**Apache HTTP 服务器** 已从 RHEL 7 提供的版本 2.4.6 更新至 RHEL 8 提供的版本 2.4.37。这个版本包括了几个新功能，但在外部模块的配置和应用程序二进制接口（ABI）级别上保持与 RHEL 7 版本的向后兼容性。 			

​					新特性包括： 			

- ​							现在，`mod_http2` 软件包提供了 `HTTP/2` 支持，该软件包是 `httpd` 模块的一部分。 					
- ​							支持 systemd 套接字激活。详情请查看 `httpd.socket(8)` man page。 					

- ​							添加了多个新模块： 					
  - ​									`mod_proxy_hcheck` - 代理健康检查模块 							
  - ​									`mod_proxy_uwsgi` - Web Server 网关接口（WSGI）代理 							
  - ​									`mod_proxy_fdpass` - 支持将客户端套接字传递给另一个进程 							
  - ​									`mod_cache_socache` - 使用 memcache 后端的 HTTP 缓存 							
  - ​									`mod_md` - ACME 协议 SSL/TLS 证书服务 							
- ​							现在默认载入以下模块： 					
  - ​									`mod_request` 							
  - ​									`mod_macro` 							
  - ​									`mod_watchdog` 							
- ​							添加了一个新的子软件包 `httpd-filesystem`，它包含 **Apache HTTP 服务器**的基本目录布局，其中包括这些目录的正确权限。 					
- ​							对实例化服务的支持，引进了 `httpd@.service`。详情请查看 `httpd.service` man page。 					

- ​							新的 `httpd-init.service` 替换了 `%post script` 以创建一个自签名的 `mod_ssl` 密钥对。 					

- ​							现在，通过 `mod_md` 软件包支持使用自动证书管理环境（ACME）协议自动 TLS 证书置备和续订（与证书提供程序，如 `Let’s Encrypt` 一起使用）。 					

- ​							**Apache HTTP 服务器**现在支持直接从 `PKCS#11` 模块的硬件安全令牌加载 TLS 证书和私钥。因此，`mod_ssl` 配置现在可以使用 `PKCS#11` URL 识别 TLS 私钥，以及可选的 `SSLCertificateKeyFile` 和 `SSLCertificateFile` 指令中的 TLS 证书。 					

- ​							现在支持 `/etc/httpd/conf/httpd.conf` 文件中的新 `ListenFree` 指令。 					

  ​							与 `Listen` 指令类似，`ListenFree` 提供服务器侦听的 IP 地址、端口或 IP 地址和端口组合的信息。但是，使用 `ListenFree` 时，`IP_FREEBIND` socket 选项会被默认启用。因此，`httpd` 允许绑定到一个非本地 IP 地址，或绑定到不存在的 IP 地址。这允许 `httpd` 在不需要在 `httpd` 绑定时启用底层网络接口或指定的动态 IP 地址处于活跃状态的情况下，侦听套接字。 					

  ​							请注意，`ListenFree` 指令目前仅适用于 RHEL 8。 					

  ​							有关 `ListenFree` 的详情，请查看下表： 					

  **表 15.1. ListenFree 指令的语法、状态和模块**

  | 语法                                          | 状态 | 模块                                                     |
  | --------------------------------------------- | ---- | -------------------------------------------------------- |
  | ListenFree [IP-address:]portnumber [protocol] | MPM  | event、worker、prefork、mpm_winnt、mpm_netware、mpmt_os2 |

​					其他显著变化包括： 			

- ​							删除了以下模块： 					

  - ​									`mod_file_cache` 							

  - ​									`mod_nss` 							

    ​									使用 `mod_ssl` 作为替换。有关从 `mod_nss` 迁移的详情,请参阅 [从 NSS 数据库中导出私钥和证书以便在 `Deploying different types of servers` 文档中的 Apache web 服务器配置部分使用这些](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/setting-apache-http-server_deploying-different-types-of-servers#exporting-a-private-key-and-certificates-from-an-nss-database-to-use-them-in-an-apache-web-server-configuration_setting-apache-http-server) 私钥和证书。 							

  - ​									`mod_perl` 							

- ​							在 RHEL 8 中，**Apache HTTP 服务器** 使用的默认 DBM 验证数据库类型已从 `SDBM` 改为 `db5`。 					

- ​							**Apache HTTP 服务器**的 `mod_wsgi` 模块已更新为 Python 3。WSGI 应用程序现在只支持 Python 3,且必须从 Python 2 中迁移。 					

- ​							使用 **Apache HTTP 服务器** 默认配置的多处理模块（MPM）已从多处理模型（称为 `prefork`）改为高性能多线程模型 `event`。 					

  ​							任何不是线程的第三方模块都需要被替换或删除。要更改配置的 MPM，编辑 `/etc/httpd/conf.modules.d/00-mpm.conf` 文件。详情请查看 `httpd.service(8)` man page。 					

- ​							现在，suEXEC 允许的用户的 UID 和 GID 最少为 1000 和 500（之前为 100 和 100）。 					

- ​							`/etc/sysconfig/httpd` 文件不再是一个支持用来为 `httpd` 服务设置环境变量的接口。为 systemd 服务添加了 `httpd.service(8)` man page。 					

- ​							现在，停止 `httpd` 服务默认使用"安全停止（graceful stop）"。 					

- ​							`mod_auth_kerb` 模块已被 `mod_auth_gssapi` 模块替代。 					

​					有关部署的步骤，请参阅[设置 Apache HTTP web 服务器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/index#setting-apache-http-server_Deploying-different-types-of-servers)。 			

### 15.2.2. `nginx` web 服务器包括在 RHEL 中

​					RHEL 8 引进了 `nginx 1.14`,它是一个支持 HTTP 和其他协议的 web 和代理服务器,它着重注意高度并发、性能和内存用量。`nginx` 以前,仅作为 Software Collection 提供。 			

​					`nginx` web 服务器现在支持直接从 `PKCS#11` 模块的硬件安全令牌加载 TLS 私钥。因此, `nginx` 配置可以使用 `PKCS#11` URL 在 `ssl_certificate_key` 指令中识别 TLS 私钥。 			

### 15.2.3. 已删除 Apache Tomcat

​					Apache Tomcat 服务器已从 Red Hat Enterprise Linux 中删除。Apache Tomcat 是  Java Servlet 和 JavaServer Pages(JSP)技术的 servlet 容器。红帽建议需要 servlet  容器的用户使用 [JBoss Web Server](https://www.redhat.com/en/technologies/jboss-middleware/web-server)。 			

## 15.3. 代理缓存服务器

### 15.3.1. RHEL 中新提供了 `Varnish Cache` 功能

​					`Varnish Cache` 首次在 RHEL 中提供，它是一个高性能 HTTP 反向代理。之前，它只通过 Software Collection 提供。`Varnish Cache` 保存内存中的文件或片段,它们用于减少响应时间和网络带宽消耗。RHEL 8.0 提供了 `Varnish Cache 6.0`。 			

### 15.3.2. `Squid` 中的显著变化

​					RHEL 8.0 提供了 `Squid 4.4`，它是一个用于 Web 客户端的高性能代理缓存服务器，支持 FTP、Gopher 和 HTTP 数据对象。与 RHEL 7 提供的版本 3.5 相比，这个版本包括的新功能、改进和程序错误修复。 			

​					主要变更包括： 			

- ​							可配置的 helper 队列大小 					
- ​							对 helper 并发频道的更改 					
- ​							更改 helper 二 进制文件 					
- ​							安全互联网内容适应协议(ICAP) 					
- ​							改进了对 Symmetric Multi Processing（SMP）的支持 					
- ​							改进的进程管理 					
- ​							删除了对 SSL 的支持 					
- ​							删除了 Edge Side Inudes(ESI)自定义解析程序 					
- ​							多配置更改 					

## 15.4. 数据库服务器

​				RHEL 8 提供以下数据库服务器： 		

- ​						`MySQL 8.0` 是一个多用户、多线程的 SQL 数据库服务器。它由 `MySQL` 服务器守护进程 `mysqld` 和很多客户端程序组成。 				
- ​						`MariaDB 10.3`是一个多用户、多线程的 SQL 数据库服务器。就所有实际目的来说，`MariaDB` 与 `MySQL` 二进制兼容。 				
- ​						`PostgreSQL 10` 和 `PostgreSQL 9.6` 是高级对象相关数据库管理系统（DBMS）。 				
- ​						`Redis 5` 是一个高级的键值存储。它通常被称为数据结构服务器,因为键可以包含字符串、哈希、列表、集合和排序集。RHEL 中第一次提供 `Redis`。 				

​				请注意, NoSQL `MongoDB` 数据库服务器没有包括在 RHEL 8.0 中,因为它使用 Server Side Public License(SSPL)。 		

#### 数据库服务器无法并行安装

​				因为 RPM 软件包有冲突，所以在 RHEL 8.0 中无法并行安装 `mariadb` 和 `mysql` 模块。 		

​				根据设计,无法并行安装多个版本(stream)的同一模块。例如：您需要从 `postgresql` 模块中只选择一个可用流，可以是 `10` （默认）或 `9.6`。在 RHEL 6 和 RHEL 7 的 Red Hat Software Collections 中可以并行安装组件。在 RHEL 8 中，可在容器中使用不同版本的数据库服务器。 		

### 15.4.1. `MariaDB 10.3` 中的显著变化

​					`MariaDB 10.3` 与 RHEL 7 提供的版本 5.5 相比，提供了多个新功能，例如： 			

- ​							常见表表达式 					
- ​							system-versioned 表 					
- ​							`FOR` 循环 					
- ​							不可见的栏 					
- ​							序列 					
- ​							适合于 `ADD COLUMN` `InnoDB` 					
- ​							独立于存储引擎的栏压缩 					
- ​							并行复制 					
- ​							多源复制 					

​					另外，新的 `mariadb-connector-c` 软件包为 `MySQL` 和 `MariaDB` 提供了一个通用的客户端库。这个程序库可用于 `MySQL` 和 `MariaDB` 数据库服务器的任何版本。因此，用户可以将应用程序的一个构建连接到 RHEL 8 提供的 `MySQL` 和 `MariaDB` 服务器。 			

​					其他显著变化包括： 			

- ​							`MariaDB Galera Cluster`（一个同步的多 master 集群）现在是 `MariaDB` 的标准部分。 					
- ​							`InnoDB` 现在为默认存储引擎，而不是 `XtraDB`。 					
- ​							已删除 mariadb-bench 子包。 					
- ​							默认允许插件成熟度等级已改为比服务器成熟度低 一 个等级。因此，在之前使用的，但成熟度较低的插件将不再加载。 					

​					另请参阅 [在 Red Hat Enterprise Linux 8 中使用 MariaDB](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/#using-mariadb)。 			

### 15.4.2. `MySQL 8.0` 中的显著变化

​					RHEL 8 提供了 `MySQL 8.0`，它包括以下改进： 			

- ​							`MySQL` 现在集成了一个事务性数据字典，它存储了数据库对象的信息。 					
- ​							`MySQL` 现在支持角色（权限的集合）。 					
- ​							默认字符集已从 `latin1` 改为 `utf8mb4`。 					
- ​							添加了对非重复和递归的通用表表达式的支持。 					
- ​							`MySQL` 现在支持窗口功能，该功能使用相关的行为每个行执行计算。 					
- ​							`InnoDB` 现在支持带锁定读声明的 `NOWAIT` 和 `SKIP LOCKED` 选项。 					
- ​							改进了与 GIS 相关的功能。 					
- ​							JSON 功能已被改进。 					
- ​							新的 `mariadb-connector-c` 软件包为 `MySQL` 和 `MariaDB` 提供通用客户端库。这个程序库可用于 `MySQL` 和 `MariaDB` 数据库服务器的任何版本。因此，用户可以将应用程序的一个构建连接到 RHEL 8 提供的 `MySQL` 和 `MariaDB` 服务器。 					

​					另外，RHEL 8 中包括的 `MySQL 8.0` 服务器被配置为使用 `mysql_native_password` 作为默认身份验证插件，因为 RHEL 8 中的客户端工具和库与 `caching_sha2_password` 方法不兼容，上游 `MySQL 8.0` 版本默认使用它。 			

​					要将默认身份验证插件更改为 `caching_sha2_password`,请按如下方式编辑 `/etc/my.cnf.d/mysql-default-authentication-plugin.cnf` 文件： 			

```
[mysqld]
default_authentication_plugin=caching_sha2_password
```

### 15.4.3. `PostgreSQL` 中的显著变化

​					RHEL 8.0 提供了 `PostgreSQL` 数据库服务器的两个版本版本，它们由 `postgresql` 模块的两个流提供： `PostgreSQL 10` （默认流）和 `PostgreSQL 9.6`。RHEL 7 包括 `PostgreSQL` 版本 9.2。 			

​					`PostgreSQL 9.6` 中的显著变化包括： 			

- ​							对顺序操作并性执行： `scan`、`join` 和 `aggregate` 					
- ​							同步复制的改进 					
- ​							改进了全文本搜索功能用于使用短语进行搜索 					
- ​							`postgres_fdw` 数据 federation 驱动程序现在支持远程 `join`、`sort`、`UPDATE` 和 `DELETE` 操作 					
- ​							显著性能改进,特别是多 CPU 套接字服务器的可扩展性 					

​					`PostgreSQL 10` 的主要改进包括： 			

- ​							使用 `publish` 和 `subscribe` 关键字进行逻辑复制 					
- ​							根据 `SCRAM-SHA-256` 机制进行更强大的密码验证 					
- ​							声明性表分区 					
- ​							改进了查询并行性 					
- ​							显著的常规性能改进 					
- ​							改进了监控和控制 					

​					另请参阅[在 Red Hat Enterprise Linux 8 中使用 PostgreSQL](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_different_types_of_servers/index#using-postgresql)。 			

# 第 16 章 编译器和开发工具

## 16.1. RHEL 7 后对 toolchain 的更改

​				以下小节列出了自 Red Hat Enterprise Linux 7 中描述组件发行版本起的更改。另请参阅 [Red Hat Enterprise Linux 8.0 发行注记](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/8.0_release_notes/)。 		

### 16.1.1. RHEL 8 中的 GCC 的更改

​					在 Red Hat Enterprise Linux 8 中，GCC 工具链基于 GCC 8.2 发行系列。从 Red Hat Enterprise Linux 7 开始的显著变化包括： 			

- ​							添加了很多通用优化功能,如别名分析、向量器改进、相同的代码组合、流程间分析、存储合并优化通过等。 					
- ​							改进了 Address Sanitizer。 					
- ​							添加了用来检测内存泄漏的 Leak Sanitizer。 					
- ​							添加了用于检测未定义行为的 Undefined Behavior Sanitizer。 					
- ​							现在可使用 DWARF5 格式生成调试信息。这个功能是实验性的。 					
- ​							源代码覆盖分析工具 GCOV 已进行了各种改进。 					
- ​							添加了对 OpenMP 4.5 规格的支持。另外, OpenMP 4.0 规格的卸载功能现在被 C、C ++ 和 Fortran 编译器支持。 					
- ​							添加了新的警告并改进了诊断,以静态检测某些可能的编程错误。 					
- ​							现在,源位置被跟踪为范围而不是点,这样就可以进行更丰富的诊断。编译器现在提供"fix-it"提示,建议可能对代码进行修改。添加了一个检查程序来提供替代名称并可方便地检测拼写错误。 					

**Security**

​						GCC 已被扩展，提供一些工具以确保增加生成的代码的强化。与安全相关的改进包括： 				

- ​							添加了带有溢出检查的 `__builtin_add_overflow`、`__builtin_sub_overflow` 和 `__builtin_mul_overflow` 内置功能。 					
- ​							添加了 `-fstack-clash-protection` 选项来生成额外的代码保护堆栈冲突。 					
- ​							引进了 `-fcf-protection` 选项来检查 control-flow 指令的目标地址来提高程序安全性。 					
- ​							新的 `-Wstringop-truncation` 警告选项列出了绑定字符串操作功能的调用,如 `strncat`、`strncpy` 或 `stpncpy`,这些调用可能会丢弃复制的字符串或使目的地不受影响。 					
- ​							改进了 `-Warray-bounds` 警告选项,以更好地检测绑定外阵列索引和指针偏移。 					
- ​							在通过原始内存访问功能（如 `memcpy` 或 `realloc` ）对非 trivial 类的对象进行安全操作时,添加了 `-Wclass-memaccess` 警告选项。 					

**构架和处理器支持**

​						架构和处理器支持的改进包括： 				

- ​							为 Intel AVX-512 构架、多个微架构架构和 Intel Software Guard 扩展(SGX)添加了多个与架构相关的新选项。 					
- ​							Code 生成可以针对 64 位 ARM 架构 LSE 扩展、ARMv8.2-A 16 位 Floating-Point 扩展(FPE)和 ARMv8.2-A、ARMv8.3-A 和 ARMv8.4-A 架构版本。 					
- ​							处理 ARM 和 64 位 ARM 架构的 `-march=native` 选项已被修复。 					
- ​							添加了对 64 位 IBM Z 架构的 z13 和 z14 处理器的支持。 					

**语言和标准**

​						与语言和标准有关的显著变化包括： 				

- ​							C 语言编译代码时使用的默认标准已改为使用 GNU 扩展的 C17。 					
- ​							C++ 语言编译代码时使用的默认标准已改为使用 GNU 扩展的 C++14。 					
- ​							C++ 运行时程序库现在支持 C++11 和 C++14 标准。 					
- ​							C++ 编译器现在以许多新功能实现 C++14 标准,如变量模板、非静态数据成员初始化工具、扩展 `constexpr` 规格、大小取消分配功能、通用 lambdas、变量边数数组、数字分隔器等。 					
- ​							改进了对 C 语言标准 C11 的支持：现在提供了 ISO C11 atomics、通用选择和线程存储。 					
- ​							新的 `__auto_type` GNU C 扩展提供了 C++11 `auto` 关键字功能的子集。 					
- ​							ISO/IEC TS 18661-3:2015 标准指定的 `_FloatN` 和 `_FloatNx` 类型名称现在由 C 前端识别。 					
- ​							C 语言编译代码时使用的默认标准已改为使用 GNU 扩展的 C17。这与使用 `--std=gnu17` 选项的效果相同。在以前的版本中，默认值是带有 GNU 扩展的 C89。 					
- ​							GCC 现在可以使用 C++17 语言标准以及 C++20 标准中的某些功能对代码进行实验性编译。 					
- ​							现在，传递空类作为参数不包括在 Intel 64 和 AMD64 构架中，如平台 ABI 要求。传递或返回只删除复制的类,移动构造器现在使用相同的调用约定,与具有非商用副本或移动构造器的类相同。 					
- ​							C++11 `alignof` operator 返回的值已被修正以匹配 C `_Alignof` operator 并返回最小协调。要查找首选的协调，请使用 GNU 扩展 `__alignof__`。 					
- ​							用于 Fortran 语言代码的 `libgfortran` 库的主要版本已改为 5。 					
- ​							对 Ada(GNAT)、GCC Go 和 Objective C/C++ 语言的支持已被删除。使用 Go Toolset 进行 Go 代码开发。 					

**其它资源**

- ​							另请参阅 [Red Hat Enterprise Linux 8 发行注记](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/) 。 					
- ​							[使用 Go 工具集](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/2018.4/html/using_go_toolset/index) 					

### 16.1.2. RHEL 8 中 GCC 的安全性增强

​					本节详细介绍了在 Red Hat Enterprise Linux 7.0 发行版本后，GCC 中与安全性相关的变化。 			

**新警告**

​						添加了这些警告选项： 				

| 选项                              | 显示警告信息                                                 |
| --------------------------------- | ------------------------------------------------------------ |
| `-Wstringop-truncation`           | 调用有绑定字符串操作功能,如 `strncat`、`strncpy` 和 `stpncpy`,这些功能可能会断开复制的字符串或使目的地不受影响。 |
| `-Wclass-memaccess`               | 原始内存功能可能会以不安全的方式处理类型为非 trivial 类的对象,如 `memcpy` 或 `realloc`。 							 							  								该警告有助于检测调用,绕过用户定义的构造器或复制分配 operator、损坏的虚拟表格指针、限定类型或参考的数据成员或者成员指针。该警告还会检测到可绕过数据成员的访问控制的调用。 |
| `-Wmisleading-indentation`        | 代码缩进对于阅读代码的人可能会造成对代码块结构的误导。       |
| `-Walloc-size-larger-than=*size*` | 调用内存分配超过 *size* 的内存分配功能。还可用于通过乘以两个参数并使用属性 `alloc_size` 来指定分配的功能。 |
| `-Walloc-zero`                    | 调用内存分配功能,试图分配零内存。还可用于通过乘以两个参数并使用属性 `alloc_size` 来指定分配的功能。 |
| `-Walloca`                        | 所有对 `alloca` 功能的调用。                                 |
| `-Walloca-larger-than=*size*`     | 请求内存大于 *size* 时调用 `alloca` 功能。                   |
| `-Wvla-larger-than=*size*`        | 可超过指定大小或者其绑定未知约束的 Variable Length Arrays(VLA)定义。 |
| `-Wformat-overflow=*level*`       | 对格式化输出功能的 `sprintf` 系列调用时可能会出现特定和可能的缓冲溢出。有关 *level* 值的详情和说明，请参阅 *gcc(1)* 手册页。 |
| `-Wformat-truncation=*level*`     | 对格式化输出功能的 `snprintf` 系列调用的特定和可能的输出截断。有关 *level* 值的详情和说明，请参阅 *gcc(1)* 手册页。 |
| `-Wstringop-overflow=*type*`      | 对字符串处理功能（如 `memcpy` 和 `strcpy` ）调用的缓冲溢出。有关 *level* 值的详情和说明，请参阅 *gcc(1)* 手册页。 |

**警告改进**

​						改进了以下 GCC 警告： 				

- ​							改进了 `-Warray-bounds` 选项,以检测更多绑定范围数组索引和指针偏移实例。例如,会检测到成灵活的阵列成员和字符串字面的负或过量索引。 					
- ​							GCC 7 中引入的 `-Wrestrict` 选项已被改进,通过限制参数到标准内存和字符串操作功能（如 `memcpy` 和 `strcpy` ）来检测到多个对象的重叠访问实例。 					
- ​							`-Wnonnull` 选项已被改进,以检测到一组更宽松的情况,将 null pointers 传递给希望使用非无效参数的功能（使用属性 `nonnull`引用）。 					

**新的 UndefinedBehaviorSanitizer**

​						添加了一个新的用于检测未定义行为的运行时清理程序，称为 UndefinedBehaviorSanitizer。以下选项需要加以注意： 				

| 选项                                 | 检查                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| `-fsanitize=float-divide-by-zero`    | 检查浮点被被零除。                                           |
| `-fsanitize=float-cast-overflow`     | 检查浮点类型到整数转换的结果是否溢出。                       |
| `-fsanitize=bounds`                  | 启用阵列绑定控制并检测对边界外的访问。                       |
| `-fsanitize=alignment`               | 启用协调检查并检测各种没有对齐的对象。                       |
| `-fsanitize=object-size`             | 启用对象大小检查并检测到各种对边界外的访问。                 |
| `-fsanitize=vptr`                    | 启用对 C++ 成员功能调用、成员访问以及指针到基本类别和派生类之间的一些转换。另外，检测引用的对象没有正确的动态类型。 |
| `-fsanitize=bounds-strict`           | 启用对阵列绑定的严格的检查。这启用了 `-fsanitize=bounds` 并支持如灵活数组成员的数组。 |
| `-fsanitize=signed-integer-overflow` | 即使在使用通用向量的诊断操作中诊断异常溢出。                 |
| `-fsanitize=builtin`                 | 在运行时诊断为 `__builtin_clz` 或 `__builtin_ctz` 前缀的内置无效参数。包括来自 `-fsanitize=undefined` 的检查。 |
| `-fsanitize=pointer-overflow`        | 为指针嵌套执行 cheap run-time 测试。包括来自 `-fsanitize=undefined` 的检查。 |

**AddressSanitizer 的新选项**

​						这些选项已经被添加到 AddressSanitizer 中： 				

| 选项                                 | 检查                                              |
| ------------------------------------ | ------------------------------------------------- |
| `-fsanitize=pointer-compare`         | 指向不同内存对象的指针的警告。                    |
| `-fsanitize=pointer-subtract`        | 指向不同内存对象的指针的小数警告。                |
| `-fsanitize-address-use-after-scope` | 定义变量的范围后获取并使用其地址的 Thitize 变量。 |

**其他清理程序和工具**

- ​							添加了选项 `-fstack-clash-protection`,以便在静态分配或动态分配堆栈空间时插入探测,以可靠检测到堆栈溢出,从而缓解依赖于操作系统提供的堆栈保护页面跳过的攻击向量。 					
- ​							添加了一个新的选项 `-fcf-protection=[full|branch|return|none]` 来执行代码工具并提高程序安全性,方法是检查控制流传输指令的目标地址（如间接功能调用、函数返回、间接跳过）是否有效。 					

**其它资源**

- ​							有关为上述一些选项提供的值的详情和解释,请参见 *gcc(1)* 手册页： 					

  ```
  $ man gcc
  ```

### 16.1.3. RHEL 8 中 GCC 中破坏兼容性的更改

##### C++ ABI 的更改 `std::string` 和 `std::list`

​					`libstdc++` 库中的 `std::string` 和 `std::list` 类的 Application Binary Interface(ABI)在 RHEL 7(GCC 4.8)和 RHEL 8(GCC 8)间进行了更改,以符合 C++11 标准。`libstdc++` 库支持旧的和新的 ABI,但其他一些 C++ 系统库不支持。因此,需要重建针对这些库动态链接的应用程序。这会影响所有 C++ 标准模式,包括  C++98。它还会影响通过 Red Hat Developer Toolset 编译器为 RHEL 7 构建的应用程序,这些应用程序使旧的  ABI 保持与系统库的兼容性。 			

##### GCC 不再构建 Ada、Go 和 Objective C/C++ 代码

​					从 GCC 编译器中删除了 Ada(GNAT)、GCC Go 和 Objective C/C++ 语言构建代码的能力。 			

​					要构建 Go 代码,请使用 Go Toolset。 			

## 16.2. 编译器工具集

​				RHEL 8 提供以下编译器工具集作为 Application Streams: 		

- ​						LLVM Toolset 11.0.0,它提供 LLVM 编译器基础架构框架、C 和 C++ 语言的 Clang 编译器、LLDB 调试器以及相关代码分析工具。请参阅 [使用 LLVM Toolset](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/1/html-single/using_llvm_9.0.1_toolset/index) 指南。 				
- ​						rust Toolset 1.49.0,它提供 Rust 编程语言编译器 `rustc`、`cargo` 构建工具和依赖项管理器、`cargo-vendor` 插件以及所需的库。请参阅 [使用 Rust Toolset](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/1/html-single/using_rust_1.41_toolset/index) 指南。 				
- ​						Go Toolset 1.15.7,它提供 Go 编程语言工具和程序库。Go 也称为 `golang`。请参阅 [使用 Go Toolset](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/1/html-single/using_go_1.13_toolset/index) 指南。 				

## 16.3. RHEL 8 中的 Java 实现和 Java 工具

​				RHEL 8 AppStream 软件仓库包括： 		

- ​						`java-11-openjdk` 软件包,提供 OpenJDK 11 Java 运行时环境和 OpenJDK 11 Java 软件开发 Kit。 				
- ​						`java-1.8.0-openjdk` 软件包,提供 OpenJDK 8 Java 运行时环境和 OpenJDK 8 Java 软件开发 Kit。 				
- ​						`icedtea-web` 软件包,提供 Java Web Start 的实现。 				
- ​						`ant` 模块,它为编译、汇编、测试和运行 Java 应用程序提供了 Java 库和命令行工具。`Ant` 已更新至 1.10 版本。 				
- ​						`maven` 模块,提供软件项目管理和组合工具。`Maven` 以前,它只能作为 Software Collection 或不受支持的 Optional 频道提供。 				
- ​						`scala` 模块,为 Java 平台提供通用目的编程语言。`Scala` 以前,仅作为 Software Collection 提供。 				

​				另外, `java-1.8.0-ibm` 软件包通过 Supplementary 软件仓库发布。请注意,这个软件仓库中的软件包不被红帽支持。 		

## 16.4. GDB 中破坏兼容性的更改

​				Red Hat Enterprise Linux 8 中提供的 GDB 版本包含很多与兼容性问题相关的更改,特别是直接从终端读取 GDB 输出的情况。以下小节详细介绍了这些更改。 		

​				不建议解析 GDB 的输出。使用 Python GDB API 或 GDB Machine Interface(MI)的首选脚本。 		

#### gdbserver 现在使用 shell 启动 feriors

​				要启用扩展和变量替换命令行参数,GDBserver 现在与 GDB 一样在 shell 中启动下级。 		

​				使用 shell 禁用： 		

- ​						使用 `target extended-remote` GDB 命令时,使用 `set startup-with-shell off` 命令禁用 shell。 				
- ​						当使用 `target remote` GDB 命令时,使用 `--no-startup-with-shell` 选项的 GDBserver 禁用 shell。 				

**例 16.1. 远程 GDB 推断器中的 shell 扩展示例**

​					这个示例演示了在 Red Hat Enterprise Linux 版本 7 和 8 中通过 GDBserver 运行 `/bin/echo /*` 命令的不同： 			

- ​							对于 RHEL 7: 					

  ```
  $ gdbserver --multi :1234
  $ gdb -batch -ex 'target extended-remote :1234' -ex 'set remote exec-file /bin/echo' -ex 'file /bin/echo' -ex 'run /*'
  /*
  ```

- ​							对于 RHEL 8: 					

  ```
  $ gdbserver --multi :1234
  $ gdb -batch -ex 'target extended-remote :1234' -ex 'set remote exec-file /bin/echo' -ex 'file /bin/echo' -ex 'run /*'
  /bin /boot (...) /tmp /usr /var
  ```

#### `gcj` 支持已删除

​				支持通过 GNU Compiler for Java(`gcj`)编译的调试 Java 程序已被删除。 		

#### 符号转储维护命令的新语法

​				符号转储维护命令语法现在包含文件名前的选项。因此,在 RHEL 7 中使用 GDB 的命令无法在 RHEL 8 中正常工作。 		

​				例如,以下命令不再将符号存储在文件中,但会生成出错信息： 		

```
(gdb) maintenance print symbols /tmp/out main.c
```

​				符号转储维护命令的新语法是： 		

```
maint print symbols [-pc address] [--] [filename]
maint print symbols [-objfile objfile] [-source source] [--] [filename]
maint print psymbols [-objfile objfile] [-pc address] [--] [filename]
maint print psymbols [-objfile objfile] [-source source] [--] [filename]
maint print msymbols [-objfile objfile] [--] [filename]
```

#### 线程数不再是全局的

​				在以前的版本中,GDB 只使用全局线程编号。该编号已扩展为以 `inferior_num.thread_num` 格式为每个下级显示,如 `2.1`。因此, `$_thread` 方便变量和 `InferiorThread.num` Python 属性中的线程数字在下级之间不再是唯一的。 		

​				GDB 现在为每个线程保存第二个线程 ID,称为全局线程 ID,这是之前版本中的线程数的新值。要访问全局线程号,请使用 `$_gthread` 方便变量和 `InferiorThread.global_num` Python 属性。 		

​				为了向后兼容,Machine Interface(MI)线程 ID 始终包含全局 ID。 		

**例 16.2. GDB 线程数更改示例**

​					在 Red Hat Enterprise Linux 7 上： 			

```
# debuginfo-install coreutils
$ gdb -batch -ex 'file echo' -ex start -ex 'add-inferior' -ex 'inferior 2' -ex 'file echo' -ex start -ex 'info threads' -ex 'pring $_thread' -ex 'inferior 1' -ex 'pring $_thread'
(...)
  Id   Target Id         Frame
* 2    process 203923 "echo" main (argc=1, argv=0x7fffffffdb88) at src/echo.c:109
  1    process 203914 "echo" main (argc=1, argv=0x7fffffffdb88) at src/echo.c:109
$1 = 2
(...)
$2 = 1
```

​					在 Red Hat Enterprise Linux 8 中： 			

```
# dnf debuginfo-install coreutils
$ gdb -batch -ex 'file echo' -ex start -ex 'add-inferior' -ex 'inferior 2' -ex 'file echo' -ex start -ex 'info threads' -ex 'pring $_thread' -ex 'inferior 1' -ex 'pring $_thread'
(...)
  Id   Target Id         Frame
  1.1  process 4106488 "echo" main (argc=1, argv=0x7fffffffce58) at ../src/echo.c:109
* 2.1  process 4106494 "echo" main (argc=1, argv=0x7fffffffce58) at ../src/echo.c:109
$1 = 1
(...)
$2 = 1
```

#### 值内容的内存可能会受限制

​				在以前的版本中，GDB 不会限制为值内容分配的内存量。因此，调试不正确的程序可能会导致 GDB 分配过多的内存。添加了 `max-value-size` 设置来限制分配的内存量。这个限制的默认值为 64 KiB。因此，Red Hat Enterprise Linux 8 中的 GDB 不会显示太大的值，而是会报告这个值太大。 		

​				例如,打印一个定义为 `char s[128*1024];` 的值会产生不同的结果： 		

- ​						在 Red Hat Enterprise Linux 7 中, `$1 = 'A' <repeats 131072 times>` 				
- ​						在 Red Hat Enterprise Linux 8 中, `value requires 131072 bytes, which is more than max-value-size` 				

#### 不再支持 Sun 版本的 stabs 格式

​				对 Sun 版本的 `stabs` 调试文件格式的支持已删除。GDB 仍支持 GCC 在 RHEL 中使用 `gcc -gstabs` 选项生成的 `stabs` 格式。 		

#### sysroot 处理更改

​				`set sysroot *path*` 命令在搜索调试所需文件时指定系统根。现在,为这个命令提供的目录名可能会带有字符串 `target:` 前缀,使 GDB 从目标系统中（本地和远程）读取共享的库。以前可用的 `remote:` 前缀现在被视为 `target:`。另外,默认的系统根值已从空字符串改为 `target:`,以便向后兼容。 		

​				指定的系统 root 先于主可执行文件名,当 GDB 远程启动时,或者它附加到已在运行的进程（本地和远程）。这意味着,对于远程进程,默认值 `target:` 使 GDB 总是尝试从远程系统加载调试信息。要防止这种情况,请在 `target remote` 命令前运行 `set sysroot` 命令以便在远程符号前找到本地符号文件。 		

#### HISTSIZE 不再控制 GDB 命令历史大小

​				在以前的版本中,GDB 使用 `HISTSIZE` 环境变量来决定命令历史记录应保留的时长。GDB 已被修改为使用 `GDBHISTSIZE` 环境变量。该变量只适用于 GDB。可能的值及其影响如下： 		

- ​						一个正数 - 使用这个大小的命令历史记录, 				
- ​						`-1` 或者空字符串 - 保留所有命令的历史记录, 				
- ​						非数字值 - 忽略。 				

#### 添加了完成限制

​				现在,可以使用 `set max-completions` 命令限制完成期间考虑的最大候选数。要显示当前的限制,请运行 `show max-completions` 命令。默认值为 200。这个限制可防止 GDB 生成过大的完成列表且变得无响应。 		

​				例如,输入 `p <tab><tab>` 后的输出为： 		

- ​						对于 RHEL 7: `Display all 29863 possibilities? (y or n)` 				
- ​						对于 RHEL 8: `Display all 200 possibilities? (y or n)` 				

#### 删除了 HP-UX XDB 兼容性模式

​				HP-UX XDB 兼容模式的 `-xdb` 选项已从 GDB 中删除。 		

#### 为线程处理信号

​				在以前的版本中,GDB 可以向当前的线程发送信号,而不是发送信号的线程。这个程序错误已被解决,GDB 现在会在恢复执行时将信号传递给正确的线程。 		

​				另外,现在 `signal` 命令总是正确地向当前的线程发送请求的信号。如果程序停止了信号并且用户切换了线程,GDB 需要确认。 		

#### breakpoint 模式总是关闭并自动合并

​				已更改 `breakpoint always-inserted` 设置。已删除 `auto` 值和对应行为。默认值现在为 `off`。另外, `off` 值现在会导致 GDB 在所有线程停止前不会从目标中删除断点。 		

#### 不再支持 remotebaud 命令

​				不再支持 `set remotebaud` 和 `show remotebaud` 命令。使用 `set serial baud` 和 `show serial baud` 命令替代。 		

## 16.5. 编译器和开发工具中破坏兼容性的更改

#### **librtkaio** 删除

​				在这个版本中, **librtkaio 库** 已被删除。这个程序库为一些文件提供了高性能实时 I/O 访问权限,它们基于 Linux 内核 Asynchronous I/O 支持(KAIO)。 		

​				由于删除的结果： 		

- ​						使用 `LD_PRELOAD` 方法加载 **librtkaio** 的应用程序会显示对缺少库的警告,而是加载 **librt 库** 并正确运行。 				
- ​						使用 `LD_LIBRARY_PATH` 方法加载 **librtkaio 的应用程序** 加载 **librt 库** 并正常运行,没有任何警告。 				
- ​						使用 `dlopen()` 系统调用来访问 **librtkaio** 的应用程序直接载入 **librt 库**。 				

​				**librtkaio** 用户有以下选项： 		

- ​						使用上面描述的回退机制,而不对其应用程序进行任何更改。 				
- ​						将应用程序代码改为使用 **librt 库,** 它提供了一个兼容的 POSIX API。 				
- ​						将应用程序代码改为使用 libaio 库 **,** 该库提供了一个兼容的 API。 				

​				**librt** 和 libaio **可** 在特定条件下提供功能和性能。 		

​				请注意, **libaio** 软件包的红帽兼容性级别为 2,而 **librtk** 和删除了 **librtkaio** 级别 1。 		

​				如需了解更多详细信息,请参阅 https://fedoraproject.org/wiki/Changes/GLIBC223_librtkaio_removal 		

#### 从中删除的 Sun RPC 和 NIS 接口 `glibc`

​				`glibc` 库不再为新应用程序提供 Sun RPC 和 NIS 接口。现在,这些接口仅适用于运行旧应用程序。开发人员必须更改其应用程序,才能使用 `libtirpc` 库,而不是使用 Sun RPC 和 `libnsl2` 而不是 NIS。应用程序可从替换库中的 IPv6 支持中受益。 		

#### 32 位 Xen 的 `nosegneg` 库已被删除

​				在以前的版本中, `glibc` i686 软件包包含一个替代的 `glibc` 构建,它避免使用带有负偏移(`nosegneg`)的线程描述符寄存器。这个替代构建只用于 Xen Project hypervisor 的 32 位版本,但没有硬件虚拟化支持,从而可以降低完全半虚拟化的成本。现在,这些替代构建不再被使用,它们已被删除。 		

#### `make` 新的 operator `!=` 会对某些现有的 makefile 语法有不同的解释

​				在 GNU `make` 中添加了 `!=` shell 分配运算符,作为 `$(shell …)` 功能的替代来提高与 BSD makefile 的兼容性。因此,名称以声明标记结尾的变量,然后再分配（如 `variable!=value` ）现在被解释为 shell 分配。要恢复之前的行为,请在声明标记后添加一个空格,如 `variable! =value`。 		

​				有关运算符和功能之间的更多详情和区别,请查看 GNU `make` 手册。 		

#### 用于 MPI 调试支持的 Valgrind 库已删除

​				由 `valgrind-openmpi` 软件包提供的 **Valgrind** 的 `libmpiwrap.so` wrapper 库已被删除。这个库启用了 **Valgrind** 使用 Message Passing Interface(MPI)调试程序。这个程序库专用于之前 Red Hat Enterprise Linux 版本中的 Open MPI 实现版本。 		

​				建议 `libmpiwrap.so` 用户从特定于其 MPI 实现和版本的上游源构建自己的版本。使用 `LD_PRELOAD` 技术向 **Valgrind** 提供这些自定义构建的库。 		

#### 从中移除开发标头和静态库 `valgrind-devel`

​				在以前的版本中,用来包括用于开发自定义 valgrind 工具的开发文件 `valgrind-devel` 子软件包。在这个版本中删除了这些文件,因为它们没有保证的 API,且必须静态链接,且不被支持。`valgrind-devel` 软件包仍然包含 valgrind-aware 程序及标头文件（如 `valgrind.h`、`callgrind.h`、`drd.h`、`helgrind.h` 和 `memcheck.h` ）的开发文件,它们是稳定并被良好支持的。 		

# 第 17 章 Identity Management

## 17.1. 身份管理软件包作为模块安装

​				在 RHEL 8 中,安装 Identity Management(IdM)服务器和客户端所需的软件包作为模块发布。`client` 流是 `idm` 模块的默认流,您可以在不启用流的情况下下载安装客户端所需的软件包。 		

​				IdM 服务器模块流名为 `DL1`,它包含与不同类型的 IdM 服务器对应的多个配置集： 		

- ​						`server`: 没有集成 DNS 的 IdM 服务器 				
- ​						`dns`: 带有集成 DNS 的 IdM 服务器 				
- ​						`adtrust`: 与 Active Directory 有信任协议的 IdM 服务器 				
- ​						`client`: IdM 客户端 				

​				要在 `DL1` 流的特定配置集中下载软件包： 		

1. ​						启用流： 				

   ```
   # yum module enable idm:DL1
   ```

2. ​						切换到通过流交付的 RPM: 				

   ```
   # yum distro-sync
   ```

3. ​						安装所选配置集： 				

   ```
   # yum module install idm:DL1/profile
   ```

   ​						使用以上定义的特定配置集之一替换 *profile*。 				

​				详情请查看 [安装身份管理服务器所需的软件包以及 安装身份管理 客户端所需的软件包](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/installing_identity_management/index#packages-required-for-an-ipa-server_installing-identity-management)。 		

## 17.2. 活跃目录用户现在可以管理身份管理

​				在 Red Hat Enterprise Linux(RHEL)7 中,外部组成员资格允许 AD 用户和组在系统安全服务守护进程(SSSD)帮助下在 POSIX 环境中访问 IdM 资源。 		

​				IdM LDAP 服务器有自己的机制来授予访问控制。RHEL 8 引进了一个更新，它许作为 IdM 组成员为 AD 用户添加 ID  用户覆盖。ID 覆盖是一个记录,它描述了特定 Active Directory 用户或组属性应类似于特定 ID 视图,在本例中为 Default Trust View。因此,IdM LDAP 服务器可以将 IdM 组的访问控制规则应用到 AD 用户。 		

​				AD 用户现在可以使用 IdM UI 的自助服务功能,例如上传其 SSH 密钥或更改其个人数据。AD 管理员可以在没有两个不同的帐户和密码的情况下完全管理 IdM。 		

注意

​					目前,IdM 中的一些功能可能仍不可供 AD 用户使用。例如：将 IdM 用户设置为 IdM `admins` 组中的 AD 用户的密码可能会失败。 			

## 17.3. 添加了 RHEL 8 的会话记录解决方案

​				在 Red Hat Enterprise Linux 8（RHEL 8）添加了记录会话记录解决方案。新的 `tlog` 软件包及其关联的 Web 控制台会话播放器可以记录并回放用户终端会话。可以通过 System Security Services  Daemon（SSSD）服务针对每个用户或用户组配置记录。所有终端输入和输出都会捕获并保存在系统日志中以基于文本的格式。出于安全考虑,默认输入不活跃,不截获原始密码和其他敏感信息。 		

​				这个解决方案可用于审核对安全敏感系统的用户会话。如果出现安全问题，可以检查记录的会话作为分析的 一 部分。系统管理员现在可以在本地配置会话记录,并从 RHEL 8 web 控制台界面或使用 `tlog-play` 工具从 Command-Line Interface 中查看结果。 		

## 17.4. 删除了身份管理功能

### 17.4.1. 没有 `NTP Server` IdM 服务器角色

​					因为在 RHEL 8 中, `ntpd` 已被弃用,而是使用 `chronyd`,所以 IdM 服务器不再被配置为网络时间协议(NTP)服务器,且只配置为 NTP 客户端。RHEL 7 `NTP Server` IdM 服务器角色在 RHEL 8 中已被弃用。 			

### 17.4.2. OpenLDAP 不支持 NSS 数据库

​					在以前版本的 Red Hat Enterprise Linux（RHEL）中的 OpenLDAP 套件使用 Mozilla  网络安全服务（NSS）进行加密。在 RHEL 8 中, OpenLDAP 社区支持的 OpenSSL 替换 NSS。OpenSSL 不支持  NSS 数据库存储证书和密钥。然而,它仍然支持具有同样目的的增强隐私的邮件(PEM)文件。 			

### 17.4.3. 一些 Python Kerberos 软件包已被替代

​					在 Red Hat Enterprise Linux(RHEL)8 中, `python-gssapi` 软件包替换了 Python Kerberos 软件包,如 `python-krbV`、`python-kerberos`、`python-requests-kerberos` 和 `python-urllib2_kerberos`。主要优点包括： 			

- ​							`python-gssapi` 比 `python-kerberos` 和 `python-krbV` 更容易使用。 					
- ​							`python-gssapi` 支持 `python 2` 和 `python 3`,而 `python-krbV` 不支持。 					
- ​							额外的 Kerberos 软件包 `python-requests-gssapi` 和 `python-urllib-gssapi` 目前包括在 Enterprise Linux(EPEL)程序库中。 					

​					基于 GSSAPI 的软件包允许在 Kerberos 之外使用其他通用安全服务 API(GSSAPI)机制,如 NT LAN Manager `NTLM` 出于向后兼容性的原因。 			

​					这个版本提高了 RHEL 8 中 GSSAPI 的维护性和调试性。 			

## 17.5. SSSD

### 17.5.1. 现在默认强制实施 AD GPOs

​					在 RHEL 8 中, `ad_gpo_access_control` 选项的默认设置是 `enforcing`,这样可确保评估并强制基于 Active Directory Group 策略对象(GPOs)的访问控制规则。 			

​					而 RHEL 7 中这个选项的默认设置是 `permissive`,它会评估,但不强制执行基于 GPO 的访问控制规则。使用 `permissive` 模式时,当用户每次 GPO 拒绝访问时都会记录 syslog 信息,但这些用户仍被允许登录。 			

注意

​						红帽建议确保在从 RHEL 7 升级到 RHEL 8 前，在 Active Directory 中正确配置 GPO。 				

​						不会影响默认 RHEL 7 主机中授权的 GPOs 可能会影响默认的 RHEL 8 主机。 				

​					有关 GPOs 的详情,请参考 `ad_gpo_access_control` 手册页 [中的应用组策略对象访问控制](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/integrating_rhel_systems_directly_with_windows_active_directory/managing-direct-connections-to-ad_integrating-rhel-systems-directly-with-active-directory#applying-group-policy-object-access-control-in-rhel_managing-direct-connections-to-ad) 以及 `sssd-ad` 手册页中的 条目。 			

### 17.5.2. `authselect` replaces `authconfig`

​					在 RHEL 8 中, `authselect` 替换了 `authconfig` 工具。`authselect` 采用更安全的 PAM 堆栈管理方法使 PAM 配置对系统管理员更简单。`authselect` 可用于配置验证方法,如密码、证书、智能卡和指纹。`authselect` 不要配置加入远程域所需的服务。此任务由特殊工具执行,如 `realmd` 或 `ipa-client-install`。 			

### 17.5.3. KCM 替换 KEYRING 作为默认凭证缓存存储

​					在 RHEL 8 中,默认凭证缓存存储是 Kerberos Credential Manager(KCM),它由 `sssd-kcm` 守护进程支持。KCM 解决了之前使用的 KEYRING 的限制,例如,因为没有命名空间,很难在容器化环境中使用它,以及查看和管理配额。 			

​					在这个版本中,RHEL 8 包含一个凭证缓存,它更适合容器化环境,为以后的版本中构建更多功能提供了基础。 			

### 17.5.4. `sssctl` 为 IdM 域输出 HBAC 规则报告

​					在这个版本中,System Security Services Daemon(SSSD)的 `sssctl` 工具可以为 Identity Management(IdM)域打印访问控制报告。此功能满足特定环境的需要,需要查看可访问特定客户端机器的用户和组列表。在 IdM 客户端中运行 `sssctl access-report` `domain_name` 会在应用到客户端的 IdM 域中输出基于主机的访问控制(HBAC)规则的解析子集。 			

​					请注意,除了 IdM 外，其它供应商都不支持这个特性。 			

### 17.5.5. SSSD 缓存本地用户,并通过 `nss_sss` 模块提供

​					在 RHEL 8 中,System Security Services Daemon(SSSD)默认服务于 `/etc/passwd` 和 `/etc/groups` 文件中的用户和组。`sss` nsswitch 模块先于 `/etc/nsswitch.conf` 文件中的文件。 			

​					通过 SSSD 为本地用户提供服务的好处是 `nss_sss` 模块具有快速 `memory-mapped cache`,与访问磁盘并在每个 NSS 请求上打开文件相比,可以加快 Name Service Switch(NSS)查找的速度。在以前的版本中, Name 服务缓存守护进程(`nscd`)可帮助加快访问磁盘的过程。但是,在 SSSD 的同时使用 `nscd` 非常困难,因为 SSSD 和 `nscd` 都使用它们自己的独立缓存。因此,在 SSSD 还为来自远程域（如 LDAP 或 Active Directory）的用户提供服务的设置中使用 `nscd`,可能会导致无法预计的行为。 			

​					因此，在 RHEL 8 中，本地用户和组的解析速度更快。请注意, `root` 用户永远不会被 SSSD 处理,因此 `root` 解析不会受到 SSSD 中的潜在错误的影响。另请注意,如果 SSSD 没有运行, `nss_sss` 模块会安全地处理情况,回退到 `nss_files` 以避免出现问题。您不必以任何方式配置 SSSD,文件域会自动添加。 			

### 17.5.6. SSSD 现在允许您选择多个智能卡验证设备之一

​					默认情况下,System Security Services Daemon(SSSD)会尝试自动检测智能卡验证设备。如果连接了多个设备,SSSD 会选择第一个检测到的设备。因此,您无法选择特定设备,这有时会导致失败。 			

​					在这个版本中,您可以为 `sssd.conf` 配置文件的 `[pam]` 部分配置新的 `p11_uri` 选项。这个选项可让您定义使用哪个设备进行智能卡验证。 			

​					例如,要选择一个带有 OpenSC PKCS#11 模块检测到的插槽 ID `2` 的读取器,请添加： 			

```
p11_uri = library-description=OpenSC%20smartcard%20framework;slot-id=2
```

​					到 `sssd.conf` 的 `[pam]` 部分。 			

​					详情请查看 `man sssd.conf` 页面。 			

## 17.6. 删除了 SSSD 功能

### 17.6.1. `sssd-secrets` 已被删除

​					系统安全性服务守护进程(SSSD)的 `sssd-secrets` 组件已在 Red Hat Enterprise Linux 8 中删除。这是因为 secret 服务提供程序 Custodia 不再活跃开发。使用其他身份管理工具存储 secret,如身份管理 Vault。 			

# 第 18 章 Web 控制台

## 18.1. Web 控制台现在默认可用

​				RHEL 8 web 控制台的软件包（也称为 Cockpit）现已是 Red Hat Enterprise Linux 默认软件仓库的一部分,因此可立即安装在注册的 RHEL 8 系统中。 		

​				另外,在 RHEL 8 的非最小安装中,Web 控制台会自动安装,控制台所需的防火墙端口会自动打开。 		

​				在登录前还添加了一个系统消息,它提供了有关如何启用或访问 Web 控制台的信息。 		

## 18.2. 新的防火墙接口

​				RHEL 8 web 控制台中的 **Networking** 标签页现在包含 **防火墙** 设置。在这个部分中，用户可以： 		

- ​						启用/禁用防火墙 				
- ​						添加/删除服务 				

​				详情请参阅 [使用 Web 控制台管理防火墙](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_systems_using_the_rhel_8_web_console/managing-firewall-using-the-web-console_system-management-using-the-rhel-8-web-console)。 		

## 18.3. 订阅管理

​				RHEL 8 web 控制台为使用在本地系统中安装的红帽订阅管理器提供了一个界面。Subscription Manager 连接到红帽客户门户网站，并验证所有可用信息： 		

- ​						活跃订阅 				
- ​						过期的订阅 				
- ​						续订的订阅 				

​				如果要更新订阅或在红帽客户门户网站中获取不同的订阅,则不必手动更新 Subscription Manager 数据。Subscription Manager 会自动将数据与红帽客户门户网站同步。 		

注意

​					Web 控制台的订阅页面现在由新的 subscription-manager-cockpit 软件包提供。 			

​				详情请参阅 [web 控制台中的管理订阅](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_systems_using_the_rhel_8_web_console/managing-subscriptions-in-the-web-console_system-management-using-the-rhel-8-web-console)。 		

## 18.4. 为 Web 控制台提供更好的 IdM 集成

​				如果您的系统注册在 Identity Management(IdM)域中,RHEL 8 web 控制台现在默认使用该域集中管理的 IdM 资源。这包括以下优点： 		

- ​						IdM 域的管理员可以使用 web 控制台来管理本地机器。 				
- ​						控制台的 Web 服务器会自动切换到由 IdM 证书颁发机构(CA)发布的,并被浏览器接受的证书。 				
- ​						在 IdM 域中有 Kerberos 票据的用户不需要提供登录凭证来访问 Web 控制台。 				
- ​						web 控制台可以在不手动添加 SSH 连接的情况下访问 IdM 域已知的 SSH 主机。 				

​				请注意,为了使 IdM 与 Web 控制台集成可以正常工作,用户首先需要使用 IdM master 系统中的 enable-admins-sudo 选项运行 ipa-advise 程序。 		

## 18.5. Web 控制台现在与移动浏览器兼容

​				在这个版本中,Web 控制台菜单和页面可以在移动浏览器变体上导航。这样就可以使用移动设备中的 RHEL 8 web 控制台管理系统。 		

## 18.6. Web 控制台前端页面现在显示缺少的更新和订阅

​				如果由 RHEL 8 web 控制台管理的系统有过时的软件包或已过期的订阅,现在会在系统的 web 控制台前端显示警告信息。 		

## 18.7. Web 控制台现在支持 PBD 注册

​				在这个版本中,您可以使用 RHEL 8 web 控制台界面将基于策略的 Decryption(PBD)规则应用到受管系统中的磁盘。这使用 Clevis decryption 客户端在 web 控制台中提供各种安全管理功能,比如自动解锁 LUKS 加密的磁盘分区。 		

## 18.8. 支持 LUKS v2

​				在 web 控制台的 **Storage** 选项卡中,您可以使用 LUKS(Linux Unified Key Setup)版本 2 格式创建、锁定、解锁、改变大小并配置加密设备。 		

​				这个 LUKS 的新版本提供： 		

- ​						更灵活的解锁策略 				
- ​						更强大的加密 				
- ​						更好地与将来的更改兼容 				

## 18.9. 现在可以使用 web 控制台管理虚拟机

​				现在, Virtual Machines 页面可以添加到 RHEL 8 web 控制台界面中,这可让用户创建和管理基于 libvirt 的虚拟机。 		

​				有关 web 控制台和虚拟机管理器之间虚拟管理功能的 [不同,请参阅 Virtual Machine Manager 和 Web 控制台中的虚拟化功能的不同](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization#differences-between-virtualization-features-in-virtual-machine-manager-and-the-rhel-8-web-console_managing-virtual-machines-in-the-web-console)。 		

## 18.10. Web 控制台不支持 Internet Explorer

​				RHEL 8 web 控制台中删除了对 Internet Explorer 浏览器的支持。现在,在 Internet Explorer 中尝试打开 Web 控制台会显示一个错误屏幕,其中包含可以使用的推荐浏览器列表。 		

# 第 19 章 虚拟化

## 19.1. 现在可以使用 web 控制台管理虚拟机

​				现在, Virtual Machines 页面可以添加到 RHEL 8 web 控制台界面中,这可让用户创建和管理基于 libvirt 的虚拟机(VM)。 		

​				另外,虚拟机管理器(`virt-manager`)应用程序已弃用,并可能在以后的 RHEL 主发行版本中不被支持。 		

​				但请注意,Web 控制台目前未提供 `virt-manager` 具有的所有虚拟管理功能。有关 RHEL 8 web 控制台和虚拟机管理器之间可用功能不同的详情,请参阅 [配置和管理虚拟化文档](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization#differences-between-virtualization-features-in-virtual-machine-manager-and-the-rhel-8-web-console_managing-virtual-machines-in-the-web-console)。 		

## 19.2. 虚拟化现在支持 Q35 机器类型

​				Red hat Enterprise Linux 8 引入了对 `Q35` 的支持,这是一个更现代的基于 PCI Express 的机器类型。这为虚拟设备的特性和性能提供了各种改进,并确保更广泛的现代设备与虚拟化兼容。另外，Red Hat Enterprise Linux 8 中创建的虚拟机被设置为默认使用 Q35。 		

​				请注意,以前的默认 `PC` 机器类型已弃用,并可能在以后的 RHEL 主发行版本中不被支持。但不建议将现有虚拟机的机器类型从 `PC` 改为 `Q35`。 		

​				`PC` 和 `Q35` 之间的显著区别包括： 		

- ​						旧的操作系统（如 Windows XP）不支持 Q35,如果在 Q35 虚拟机中使用则不会引导。 				

- ​						目前,当在 Q35 虚拟机中使用 RHEL 6 作为操作系统时,在一些情况下,热将 PCI 设备路由到该虚拟机时无法正常工作。另外,某些旧的 virtio 设备无法在 RHEL 6 Q35 虚拟机中正常工作。 				

  ​						因此，推荐在 RHEL 6 虚拟机中使用 PC 机器类型。 				

- ​						Q35 模拟 PCI Express(PCI-e)buses 而不是 PCI。因此,客户端操作系统中会显示不同的设备拓扑和地址方案。 				

- ​						Q35 有内置的 SATA/AHCI 控制器,而不是 IDE 控制器。 				

- ​						SecureBoot 功能仅适用于 Q35 虚拟机。 				

## 19.3. 删除了虚拟化功能

#### `cpu64-rhel6` CPU 模型已弃用并删除

​				`cpu64-rhel6` QEMU 虚拟 CPU 模型已在 RHEL 8.1 中弃用,已从 RHEL 8.2 中删除。根据主机上的 CPU,建议您使用 QEMU 和 `libvirt` 提供的其他 CPU 模型。 		

#### IVSHMEM 已经被禁用

​				现在,Red Hat Enterprise Linux 8 中禁用了使用多个虚拟机间共享内存的 VM 间共享内存设备(IVSHMEM)功能。使用这个设备配置的虚拟机将无法引导。同样，尝试热插拔这样的设备也会失败。 		

#### `virt-install` 无法再使用 NFS 位置

​				在这个版本中, `virt-install` 工具无法挂载 NFS 位置。因此,使用 `virt-install` 安装带有 `--location` 选项值的 NFS 地址的虚拟机会失败。要临时解决这个问题,请在使用 `virt-install` 之前挂载 NFS 共享,或使用 HTTP 位置。 		

#### RHEL 8 不支持 tulip 驱动程序

​				在这个版本中, tulip 网络驱动程序不再被支持。因此,当在 Microsoft Hyper-V hypervisor 中使用  RHEL 1 虚拟机(VM)时,"Legacy Network Adapter"设备无法正常工作,从而导致此类虚拟机的 PXE 安装失败。 		

​				要使 PXE 安装正常工作，请在生成 2 Hyper-V 虚拟机上安装 RHEL 8。如果您需要 RHEL 8 第一代虚拟机，请使用 ISO 安装。 		

#### 不支持 LSI Logic SAS 和 Parallel SCSI 驱动程序

​				不再支持 SCSI 的 LSI Logic SAS 驱动程序(`mptsas`)和 LSI Logic Parallel 驱动程序(`mptspi`)。因此,这些驱动程序可以用来将 RHEL 8 作为 VMWare hypervisor 上的客户机操作系统安装到 SCSI 磁盘,但创建的虚拟机不被红帽支持。 		

#### 安装 virtio-win 不再使用 Windows 驱动程序创建软磁盘镜像

​				由于软盘的限制, virtio-win 驱动程序不再以软镜像形式提供。用户应使用 ISO 镜像。 		

# 第 20 章 容器

​			一组容器镜像可用于 Red Hat Enterprise Linux 8。主要变更包括： 	

- ​					Docker 不包含在 RHEL 8.0 中。要使用容器,请使用 **podman**、**buildah**、**skopeo** 和 **runc 工具**。 			

  ​					有关这些工具以及 RHEL 8 中容器使用的信息,请参阅构建 [、运行和管理容器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index)。 			

- ​					**podman** 已作为完全支持的功能发布。 			

  ​					**podman** 管理单节点上的 pod、容器镜像和容器。它基于 **libpod** 库构建,它允许管理名为 pod 的容器和容器组。 			

  ​					了解如何使用 **podman**,查看 [构建、运行和管理容器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index)。 			

- ​					在 RHEL 8 GA 中,红帽通用基础镜像(UBI)是新提供的。UBI 替换了之前红帽提供的一些镜像,如标准及最小 RHEL 基础镜像。 			

  ​					与旧的红帽镜像不同, UBI 可以自由重新分发。这意味着它们可以在任何环境中使用并在任何位置共享。即使不是红帽客户,您可以使用它们。 			

  ​					如需 UBI 文档,请参阅 [构建、运行和管理容器](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index)。 			

- ​					在 RHEL 8 GA 中,提供了 AppStream 组件的其他容器镜像,容器镜像通过 RHEL 7 中的 **Red Hat Software Collections** 发布。所有 RHEL 8 镜像都基于 `ubi8` 基础镜像。 			

- ​					RHEL 8 完全支持 64 位 ARM 架构的容器镜像 ARM。 			

- ​					`rhel-tools` 容器已在 RHEL 8 中删除。`sos` 和 `redhat-support-tool` 工具在 `support-tools` 容器中提供。系统管理员也可以使用此镜像来构建系统工具容器镜像。 			

- ​					在 RHEL 8 中，对无根容器的支持作为技术预览提供。 			

  ​					无根容器是常规系统用户创建和管理的容器,无需管理权限。 			

# 第 21 章 国际化

## 21.1. RHEL 8 国际语言

​				Red Hat Enterprise Linux 8 支持多种语言的安装，并根据您的需要更改语言。 		

- ​						东亚语言 - 日语、韩语、简体中文和繁体中文。 				
- ​						欧洲语言 - 英语、德语、西班牙语、法语、意大利语、葡萄牙语和俄语。 				

​				下表列出了为各种主要语言提供的字体和输入法。 		

| 语言     | 默认字体（字体软件包）                                       | 输入法                    |
| -------- | ------------------------------------------------------------ | ------------------------- |
| English  | dejavu-sans-fonts                                            |                           |
| 法语     | dejavu-sans-fonts                                            |                           |
| 德语     | dejavu-sans-fonts                                            |                           |
| 意大利语 | dejavu-sans-fonts                                            |                           |
| 俄语     | dejavu-sans-fonts                                            |                           |
| 西班牙语 | dejavu-sans-fonts                                            |                           |
| 葡萄牙语 | dejavu-sans-fonts                                            |                           |
| 简体中文 | google-noto-sans-cjk-ttc-fonts, google-noto-serif-cjk-ttc-fonts | ibus-libpinyin, libpinyin |
| 繁体中文 | google-noto-sans-cjk-ttc-fonts, google-noto-serif-cjk-ttc-fonts | ibus-libzhuyin, libzhuyin |
| 日语     | google-noto-sans-cjk-ttc-fonts, google-noto-serif-cjk-ttc-fonts | ibus-kkc, libkc           |
| 韩语     | google-noto-sans-cjk-ttc-fonts, google-noto-serif-cjk-ttc-fonts | ibus-hangul, libhangu     |

## 21.2. RHEL 8 中国际化的显著变化

​				RHEL 8 与 RHEL 7 相比，对国际化进行了以下更改： 		

- ​						添加了对 **Unicode 11** 计算行业标准的支持。 				
- ​						国际化发布在多个软件包中，这样就可以进行较小的内存占用安装。如需更多信息，请参阅 [使用 langpacks](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/using-langpacks_configuring-basic-system-settings)。 				
- ​						现在,对多个位置的 `glibc` 软件包更新与 Common Locale Data Repository(CLDR)同步。 				

# 第 22 章 Red Hat Enterprise Linux for SAP Solutions

​			Red Hat Enterprise Linux for SAP Solutions 为 SAP 工作负载提供一致的基础。有关 RHEL for SAP Solutions 订阅为业务关键 IT 环境（如 SAP 环境）提供的功能和优势列表,请参阅 [Red Hat Enterprise Linux for SAP Solutions 订阅概述](https://access.redhat.com/solutions/3082481)。以下资源概述 RHEL 7 和 RHEL 8 之间的更改。 	

- ​					有关 RHEL for SAP Solutions 生命周期的详情,请参考 [Red Hat Enterprise Linux 生命周期](https://access.redhat.com/support/policy/updates/errata/)。 			
- ​					有关 RHEL 8 使用方法的详细信息,请参阅 [RHEL 8 产品文档](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/)。 			
- ​					有关从 RHEL 7 升级到 RHEL 8 的原位升级的详情,请参考 [从 RHEL 7 升级到 RHEL 8](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_from_rhel_7_to_rhel_8/index)。 			

​			除了两个主要 RHEL 软件仓库（BaseOS 和 AppStream）外,RHEL 8 for SAP Solutions 订阅包括 SAP Solutions 和 SAP NetWeaver 软件仓库。SAP 环境和工作负载都需要两个软件仓库。 	

**RHEL 7 和 RHEL 8 之间的软件仓库名称更改**

​				下表列出了在 RHEL 7 for SAP HANA / Solutions 和 RHEL 8 for SAP Solutions 间被重命名的软件仓库： 		

| 原始软件仓库名称                                     | 新存储库名称*                          | 修改自   | 备注                                                         |
| ---------------------------------------------------- | -------------------------------------- | -------- | ------------------------------------------------------------ |
| rhel-sap-hana-for-rhel-7-<server\|for-power-le>-rpms | rhel-8-for-*<arch>*-sap-solutions-rpms | RHEL 8.0 | 适用于延长更新支持(EUS)和 Update Services for SAP Solutions(E4S)软件仓库 |
| rhel-sap-for-rhel-7-<server\|for-power-le>-rpms      | rhel-8-for-*<arch>*-sap-netweaver-rpms | RHEL 8.0 | 适用于延长更新支持(EUS)和 Update Services for SAP Solutions(E4S)软件仓库 |

​			* 这个表使用示例来帮助识别完整的存储库 ID,其中 *<arch>* 是具体的架构。 	

# 第 23 章 相关信息

- ​					[Red Hat Enterprise Linux 的技术功能及限制](https://access.redhat.com/articles/rhel-limits) 			
- ​					[Red Hat Enterprise Linux 生命周期](https://access.redhat.com/support/policy/updates/errata/) 			
- ​					[RHEL 8 产品文档](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/8/) 			
- ​					[RHEL 8.0 发行注记](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/8.0_release_notes/) 			
- ​					[RHEL 8 软件包清单](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/package_manifest/) 			
- ​					[从 RHEL 7 升级至 RHEL 8](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_from_rhel_7_to_rhel_8/) 			
- ​					[应用程序兼容性指南](https://access.redhat.com/articles/rhel8-abi-compatibility) 			
- ​					[RHEL 7 迁移计划指南](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/migration_planning_guide/index) 			
- ​					[Customer Portal Labs](https://access.redhat.com/labs/) 			
- ​					[Red Hat Insights](https://access.redhat.com/products/red-hat-insights) 			
- ​					[获得最好的支持体验](https://access.redhat.com/articles/4073751) 			

# 附录 A. 对软件包的更改

​			本章列出了 RHEL 7 和 RHEL 8 之间软件包的更改，以及 RHEL 8 的次版本更改。 	

## A.1. 新软件包

### A.1.1. RHEL 8 次要发行本中添加的软件包

​					从 RHEL 8.1 开始，在 RHEL 8 中添加了以下软件包： 			

| 软件包                                          | 软件仓库        | 新内容   |
| ----------------------------------------------- | --------------- | -------- |
| accel-config                                    | rhel8-BaseOS    | RHEL 8.4 |
| accel-config-devel                              | rhel8-CRB       | RHEL 8.4 |
| accel-config-libs                               | rhel8-BaseOS    | RHEL 8.4 |
| alsa-sof-firmware                               | rhel8-BaseOS    | RHEL 8.3 |
| alsa-sof-firmware-debug                         | rhel8-BaseOS    | RHEL 8.3 |
| annobin-annocheck                               | rhel8-AppStream | RHEL 8.3 |
| ansible-freeipa                                 | rhel8-AppStream | RHEL 8.1 |
| apiguardian                                     | rhel8-AppStream | RHEL 8.4 |
| asio-devel                                      | rhel8-CRB       | RHEL 8.1 |
| asio-devel                                      | rhel8-CRB       | RHEL 8.3 |
| aspnetcore-runtime-3.1                          | rhel8-AppStream | RHEL 8.2 |
| aspnetcore-runtime-5.0                          | rhel8-AppStream | RHEL 8.3 |
| aspnetcore-targeting-pack-3.1                   | rhel8-AppStream | RHEL 8.2 |
| aspnetcore-targeting-pack-5.0                   | rhel8-AppStream | RHEL 8.3 |
| autogen-libopts-devel                           | rhel8-CRB       | RHEL 8.3 |
| avahi-glib-devel                                | rhel8-CRB       | RHEL 8.4 |
| avahi-gobject-devel                             | rhel8-CRB       | RHEL 8.4 |
| avahi-ui                                        | rhel8-CRB       | RHEL 8.4 |
| avahi-ui-devel                                  | rhel8-CRB       | RHEL 8.4 |
| batik-css                                       | rhel8-AppStream | RHEL 8.4 |
| batik-util                                      | rhel8-AppStream | RHEL 8.4 |
| bcc-devel                                       | rhel8-CRB       | RHEL 8.2 |
| Chan                                            | rhel8-AppStream | RHEL 8.3 |
| compat-exiv2-026                                | rhel8-AppStream | RHEL 8.2 |
| compat-sap-c++-10                               | rhel8-SAP       | RHEL 8.3 |
| conmon                                          | rhel8-AppStream | RHEL 8.2 |
| crit                                            | rhel8-AppStream | RHEL 8.2 |
| crun                                            | rhel8-AppStream | RHEL 8.3 |
| crypto-policies-scripts                         | rhel8-BaseOS    | RHEL 8.3 |
| dejavu-lgc-sans-fonts                           | rhel8-AppStream | RHEL 8.4 |
| delve                                           | rhel8-AppStream | RHEL 8.2 |
| directory-maven-plugin-javadoc                  | rhel8-AppStream | RHEL 8.2 |
| directory-maven-plugin                          | rhel8-AppStream | RHEL 8.2 |
| dotnet-apphost-pack-3.1                         | rhel8-AppStream | RHEL 8.2 |
| dotnet-apphost-pack-5.0                         | rhel8-AppStream | RHEL 8.3 |
| dotnet-hostfxr-3.1                              | rhel8-AppStream | RHEL 8.2 |
| dotnet-hostfxr-5.0                              | rhel8-AppStream | RHEL 8.3 |
| dotnet-runtime-3.1                              | rhel8-AppStream | RHEL 8.2 |
| dotnet-runtime-5.0                              | rhel8-AppStream | RHEL 8.3 |
| dotnet-sdk-3.1                                  | rhel8-AppStream | RHEL 8.2 |
| dotnet-sdk-5.0                                  | rhel8-AppStream | RHEL 8.3 |
| dotnet-targeting-pack-3.1                       | rhel8-AppStream | RHEL 8.2 |
| dotnet-targeting-pack-5.0                       | rhel8-AppStream | RHEL 8.3 |
| dotnet-templates-3.1                            | rhel8-AppStream | RHEL 8.2 |
| dotnet-templates-5.0                            | rhel8-AppStream | RHEL 8.3 |
| dwarves                                         | rhel8-CRB       | RHEL 8.2 |
| eclipse-ecf-core                                | rhel8-AppStream | RHEL 8.4 |
| eclipse-ecf-runtime                             | rhel8-AppStream | RHEL 8.4 |
| eclipse-emf-core                                | rhel8-AppStream | RHEL 8.4 |
| eclipse-emf-runtime                             | rhel8-AppStream | RHEL 8.4 |
| eclipse-emf-xsd                                 | rhel8-AppStream | RHEL 8.4 |
| eclipse-equinox-osgi                            | rhel8-AppStream | RHEL 8.4 |
| eclipse-jdt                                     | rhel8-AppStream | RHEL 8.4 |
| eclipse-p2-discovery                            | rhel8-AppStream | RHEL 8.4 |
| eclipse-pde                                     | rhel8-AppStream | RHEL 8.4 |
| eclipse-platform                                | rhel8-AppStream | RHEL 8.4 |
| eclipse-swt                                     | rhel8-AppStream | RHEL 8.4 |
| ee4j-parent                                     | rhel8-AppStream | RHEL 8.2 |
| elfutils-debuginfod                             | rhel8-BaseOS    | RHEL 8.3 |
| elfutils-debuginfod-client-devel                | rhel8-AppStream | RHEL 8.2 |
| elfutils-debuginfod-client                      | rhel8-AppStream | RHEL 8.2 |
| emoji-picker                                    | rhel8-AppStream | RHEL 8.4 |
| evince-devel                                    | rhel8-CRB       | RHEL 8.4 |
| fapolicyd                                       | rhel8-AppStream | RHEL 8.1 |
| fapolicyd-selinux                               | rhel8-AppStream | RHEL 8.3 |
| felix-gogo-command                              | rhel8-AppStream | RHEL 8.4 |
| felix-gogo-runtime                              | rhel8-AppStream | RHEL 8.4 |
| felix-gogo-shell                                | rhel8-AppStream | RHEL 8.4 |
| felix-scr                                       | rhel8-AppStream | RHEL 8.4 |
| flatpak-selinux                                 | rhel8-AppStream | RHEL 8.2 |
| flatpak-session-helper                          | rhel8-AppStream | RHEL 8.2 |
| flatpak-spawn                                   | rhel8-AppStream | RHEL 8.4 |
| flatpak-xdg-utils                               | rhel8-AppStream | RHEL 8.4 |
| fstrm                                           | rhel8-AppStream | RHEL 8.4 |
| fstrm-devel                                     | rhel8-AppStream | RHEL 8.4 |
| gcc-toolset-10                                  | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-annobin                          | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-binutils                         | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-binutils-devel                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-build                            | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-dwz                              | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-dyninst                          | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-dyninst-devel                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils                         | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-debuginfod-client       | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-debuginfod-client-devel | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-devel                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-libelf                  | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-libelf-devel            | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-elfutils-libs                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gcc                              | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gcc-c++                          | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gcc-gdb-plugin                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gcc-gfortran                     | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gdb                              | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gdb-doc                          | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-gdb-gdbserver                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libasan-devel                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libatomic-devel                  | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libitm-devel                     | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-liblsan-devel                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libquadmath-devel                | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libstdc++-devel                  | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libstdc++-docs                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libtsan-devel                    | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-libubsan-devel                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-ltrace                           | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-make                             | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-make-devel                       | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-perftools                        | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-runtime                          | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-strace                           | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap                        | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-client                 | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-devel                  | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-initscript             | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-runtime                | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-sdt-devel              | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-systemtap-server                 | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-toolchain                        | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-valgrind                         | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-10-valgrind-devel                   | rhel8-AppStream | RHEL 8.3 |
| gcc-toolset-9-libasan-devel                     | rhel8-AppStream | RHEL 8.2 |
| gcc-toolset-9-libatomic-devel                   | rhel8-AppStream | RHEL 8.2 |
| gcc-toolset-9-liblsan-devel                     | rhel8-AppStream | RHEL 8.2 |
| gcc-toolset-9-libtsan-devel                     | rhel8-AppStream | RHEL 8.2 |
| gcc-toolset-9-libubsan-devel                    | rhel8-AppStream | RHEL 8.2 |
| git-credential-libsecret                        | rhel8-AppStream | RHEL 8.3 |
| git-lfs                                         | rhel8-AppStream | RHEL 8.3 |
| glassfish-jsp                                   | rhel8-AppStream | RHEL 8.4 |
| google-gson                                     | rhel8-AppStream | RHEL 8.4 |
| grafana-pcp                                     | rhel8-AppStream | RHEL 8.2 |
| graphviz-python3                                | rhel8-CRB       | RHEL 8.2 |
| greenboot                                       | rhel8-AppStream | RHEL 8.3 |
| greenboot-grub2                                 | rhel8-AppStream | RHEL 8.3 |
| greenboot-reboot                                | rhel8-AppStream | RHEL 8.3 |
| greenboot-rpm-ostree-grub2                      | rhel8-AppStream | RHEL 8.3 |
| greenboot-status                                | rhel8-AppStream | RHEL 8.3 |
| guava                                           | rhel8-AppStream | RHEL 8.2 |
| HdrHistogram                                    | rhel8-AppStream | RHEL 8.3 |
| HdrHistogram_c                                  | rhel8-AppStream | RHEL 8.3 |
| HdrHistogram-javadoc                            | rhel8-AppStream | RHEL 8.3 |
| http-parser-devel                               | rhel8-CRB       | RHEL 8.2 |
| ibus-table-devel                                | rhel8-CRB       | RHEL 8.4 |
| ibus-table-tests                                | rhel8-CRB       | RHEL 8.4 |
| ibus-typing-booster-tests                       | rhel8-CRB       | RHEL 8.4 |
| icu4j                                           | rhel8-AppStream | RHEL 8.4 |
| idn2                                            | rhel8-AppStream | RHEL 8.1 |
| ima-evm-utils0                                  | rhel8-BaseOS    | RHEL 8.4 |
| intel-cmt-cat-devel                             | rhel8-CRB       | RHEL 8.4 |
| ipa-client-epn                                  | rhel8-AppStream | RHEL 8.3 |
| ipa-client-samba                                | rhel8-AppStream | RHEL 8.1 |
| ipa-healthcheck                                 | rhel8-AppStream | RHEL 8.1 |
| ipa-healthcheck-core                            | rhel8-AppStream | RHEL 8.2 |
| ipa-selinux                                     | rhel8-AppStream | RHEL 8.3 |
| iscsi-initiator-utils-devel                     | rhel8-CRB       | RHEL 8.3 |
| jaf-javadoc                                     | rhel8-AppStream | RHEL 8.2 |
| jaf                                             | rhel8-AppStream | RHEL 8.2 |
| java-1.8.0-openjdk-accessibility-fastdebug      | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-accessibility-slowdebug      | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-demo-fastdebug               | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-demo-slowdebug               | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-devel-fastdebug              | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-devel-slowdebug              | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-fastdebug                    | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-headless-fastdebug           | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-headless-slowdebug           | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-slowdebug                    | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-src-fastdebug                | rhel8-CRB       | RHEL 8.4 |
| java-1.8.0-openjdk-src-slowdebug                | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-demo-fastdebug                  | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-demo-slowdebug                  | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-devel-fastdebug                 | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-devel-slowdebug                 | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-fastdebug                       | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-headless-fastdebug              | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-headless-slowdebug              | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-jmods-fastdebug                 | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-jmods-slowdebug                 | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-slowdebug                       | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-src-fastdebug                   | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-src-slowdebug                   | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-static-libs                     | rhel8-AppStream | RHEL 8.3 |
| java-11-openjdk-static-libs-fastdebug           | rhel8-CRB       | RHEL 8.4 |
| java-11-openjdk-static-libs-slowdebug           | rhel8-CRB       | RHEL 8.4 |
| jetty-continuation                              | rhel8-AppStream | RHEL 8.4 |
| jetty-http                                      | rhel8-AppStream | RHEL 8.4 |
| jetty-io                                        | rhel8-AppStream | RHEL 8.4 |
| jetty-security                                  | rhel8-AppStream | RHEL 8.4 |
| jetty-server                                    | rhel8-AppStream | RHEL 8.4 |
| jetty-servlet                                   | rhel8-AppStream | RHEL 8.4 |
| jetty-util                                      | rhel8-AppStream | RHEL 8.4 |
| jmc-core-javadoc                                | rhel8-AppStream | RHEL 8.2 |
| jmc-core                                        | rhel8-AppStream | RHEL 8.2 |
| jmc                                             | rhel8-AppStream | RHEL 8.2 |
| jolokia-jvm-agent                               | rhel8-AppStream | RHEL 8.2 |
| js-d3-flame-graph                               | rhel8-AppStream | RHEL 8.3 |
| Judy-devel                                      | rhel8-BaseOS    | RHEL 8.1 |
| Judy-devel                                      | rhel8-CRB       | RHEL 8.3 |
| junit5                                          | rhel8-AppStream | RHEL 8.4 |
| kernel-abi-stablelists                          | rhel8-BaseOS    | RHEL 8.4 |
| kmod-redhat-oracleasm                           | rhel8-BaseOS    | RHEL 8.4 |
| kpatch-dnf                                      | rhel8-BaseOS    | RHEL 8.4 |
| libasan6                                        | rhel8-AppStream | RHEL 8.4 |
| libbabeltrace-devel                             | rhel8-CRB       | RHEL 8.3 |
| libblockdev-crypto-devel                        | rhel8-CRB       | RHEL 8.3 |
| libblockdev-devel                               | rhel8-CRB       | RHEL 8.3 |
| libblockdev-fs-devel                            | rhel8-CRB       | RHEL 8.3 |
| libblockdev-loop-devel                          | rhel8-CRB       | RHEL 8.3 |
| libblockdev-lvm-devel                           | rhel8-CRB       | RHEL 8.3 |
| libblockdev-mdraid-devel                        | rhel8-CRB       | RHEL 8.3 |
| libblockdev-part-devel                          | rhel8-CRB       | RHEL 8.3 |
| libblockdev-swap-devel                          | rhel8-CRB       | RHEL 8.3 |
| libblockdev-utils-devel                         | rhel8-CRB       | RHEL 8.3 |
| libblockdev-vdo-devel                           | rhel8-CRB       | RHEL 8.3 |
| libbpf-devel                                    | rhel8-CRB       | RHEL 8.2 |
| libbpf-static                                   | rhel8-CRB       | RHEL 8.2 |
| libbpf                                          | rhel8-BaseOS    | RHEL 8.2 |
| libbytesize-devel                               | rhel8-CRB       | RHEL 8.3 |
| libdazzle-devel                                 | rhel8-CRB       | RHEL 8.4 |
| libdnf-devel                                    | rhel8-CRB       | RHEL 8.4 |
| libdwarves1                                     | rhel8-CRB       | RHEL 8.2 |
| libecpg                                         | rhel8-AppStream | RHEL 8.4 |
| libecpg-devel                                   | rhel8-CRB       | RHEL 8.4 |
| libepubgen-devel                                | rhel8-CRB       | RHEL 8.4 |
| libnbd                                          | rhel8-AppStream | RHEL 8.3 |
| libnbd-devel                                    | rhel8-AppStream | RHEL 8.3 |
| libnftnl-devel                                  | rhel8-CRB       | RHEL 8.2 |
| libnumbertext                                   | rhel8-AppStream | RHEL 8.4 |
| libpgtypes                                      | rhel8-AppStream | RHEL 8.4 |
| libpsl-devel                                    | rhel8-CRB       | RHEL 8.3 |
| librepo-devel                                   | rhel8-CRB       | RHEL 8.4 |
| librhsm-devel                                   | rhel8-CRB       | RHEL 8.4 |
| libsemanage-devel                               | rhel8-CRB       | RHEL 8.3 |
| libslirp                                        | rhel8-AppStream | RHEL 8.3 |
| libslirp-devel                                  | rhel8-AppStream | RHEL 8.3 |
| libsmi-devel                                    | rhel8-CRB       | RHEL 8.4 |
| libsolv-devel                                   | rhel8-CRB       | RHEL 8.4 |
| libsolv-tools                                   | rhel8-CRB       | RHEL 8.4 |
| libssh-config                                   | rhel8-BaseOS    | RHEL 8.1 |
| libstoragemgmt-devel                            | rhel8-BaseOS    | RHEL 8.3 |
| libstoragemgmt-devel                            | rhel8-CRB       | RHEL 8.3 |
| libudisks2-devel                                | rhel8-CRB       | RHEL 8.3 |
| liburing-devel                                  | rhel8-CRB       | RHEL 8.3 |
| liburing                                        | rhel8-AppStream | RHEL 8.2 |
| libuv-devel                                     | rhel8-CRB       | RHEL 8.4 |
| libvirt-daemon-driver-storage-iscsi-direct      | rhel8-AppStream | RHEL 8.3 |
| libxdp                                          | rhel8-AppStream | RHEL 8.3 |
| libxkbfile-1.1.0-1.el8                          | rhel8-AppStream | RHEL 8.3 |
| libxmlb                                         | rhel8-BaseOS    | RHEL 8.3 |
| libXvMC-devel                                   | rhel8-CRB       | RHEL 8.3 |
| libzstd-devel                                   | rhel8-BaseOS    | RHEL 8.2 |
| libzstd                                         | rhel8-BaseOS    | RHEL 8.2 |
| lld-test                                        | rhel8-AppStream | RHEL 8.2 |
| lmdb-libs                                       | rhel8-AppStream | RHEL 8.1 |
| lucene                                          | rhel8-AppStream | RHEL 8.4 |
| lucene-analysis                                 | rhel8-AppStream | RHEL 8.4 |
| lucene-analyzers-smartcn                        | rhel8-AppStream | RHEL 8.4 |
| lucene-queries                                  | rhel8-AppStream | RHEL 8.4 |
| lucene-queryparser                              | rhel8-AppStream | RHEL 8.4 |
| lucene-sandbox                                  | rhel8-AppStream | RHEL 8.4 |
| lz4-java                                        | rhel8-AppStream | RHEL 8.4 |
| lz4-java-javadoc                                | rhel8-AppStream | RHEL 8.4 |
| mariadb-pam                                     | rhel8-AppStream | RHEL 8.4 |
| maven-openjdk11                                 | rhel8-AppStream | RHEL 8.2 |
| maven-openjdk8                                  | rhel8-AppStream | RHEL 8.2 |
| mdevctl                                         | rhel8-AppStream | RHEL 8.3 |
| memstrack                                       | rhel8-BaseOS    | RHEL 8.3 |
| micropipenv                                     | rhel8-AppStream | RHEL 8.4 |
| mingw32-spice-vdagent                           | rhel8-CRB       | RHEL 8.2 |
| mingw64-spice-vdagent                           | rhel8-CRB       | RHEL 8.2 |
| mod_auth_mellon-diagnostics                     | rhel8-AppStream | RHEL 8.1 |
| mpich-doc                                       | rhel8-AppStream | RHEL 8.4 |
| mvapich2-devel                                  | rhel8-AppStream | RHEL 8.4 |
| mvapich2-doc                                    | rhel8-AppStream | RHEL 8.4 |
| mvapich2-psm2-devel                             | rhel8-AppStream | RHEL 8.4 |
| mysql-selinux                                   | rhel8-AppStream | RHEL 8.4 |
| nbdfuse                                         | rhel8-AppStream | RHEL 8.3 |
| nbdkit-basic-filters                            | rhel8-AppStream | RHEL 8.3 |
| nbdkit-curl-plugin                              | rhel8-AppStream | RHEL 8.3 |
| nbdkit-gzip-plugin                              | rhel8-AppStream | RHEL 8.3 |
| nbdkit-linuxdisk-plugin                         | rhel8-AppStream | RHEL 8.3 |
| nbdkit-python-plugin                            | rhel8-AppStream | RHEL 8.3 |
| nbdkit-server                                   | rhel8-AppStream | RHEL 8.3 |
| nbdkit-ssh-plugin                               | rhel8-AppStream | RHEL 8.3 |
| nbdkit-vddk-plugin                              | rhel8-AppStream | RHEL 8.3 |
| nbdkit-xz-filter                                | rhel8-AppStream | RHEL 8.3 |
| net-snmp-perl                                   | rhel8-AppStream | RHEL 8.3 |
| NetworkManager-cloud-setup                      | rhel8-AppStream | RHEL 8.2 |
| nispor                                          | rhel8-AppStream | RHEL 8.4 |
| nispor-devel                                    | rhel8-AppStream | RHEL 8.4 |
| nmstate-plugin-ovsdb                            | rhel8-AppStream | RHEL 8.3 |
| nodejs-full-i18n                                | rhel8-AppStream | RHEL 8.3 |
| numatop                                         | rhel8-BaseOS    | RHEL 8.2 |
| ocaml-libnbd                                    | rhel8-CRB       | RHEL 8.3 |
| ocaml-libnbd-devel                              | rhel8-CRB       | RHEL 8.3 |
| oci-seccomp-bpf-hook                            | rhel8-AppStream | RHEL 8.3 |
| oci-seccomp-bpf-hook                            | rhel8-BaseOS    | RHEL 8.3 |
| opae                                            | rhel8-BaseOS    | RHEL 8.3 |
| open-vm-tools-sdmp                              | rhel8-AppStream | RHEL 8.3 |
| opentest4j                                      | rhel8-AppStream | RHEL 8.4 |
| osbuild                                         | rhel8-AppStream | RHEL 8.3 |
| osbuild-composer                                | rhel8-AppStream | RHEL 8.3 |
| osbuild-composer-core                           | rhel8-AppStream | RHEL 8.4 |
| osbuild-composer-worker                         | rhel8-AppStream | RHEL 8.3 |
| osbuild-ostree                                  | rhel8-AppStream | RHEL 8.3 |
| osbuild-selinux                                 | rhel8-AppStream | RHEL 8.3 |
| owasp-java-encoder-javadoc                      | rhel8-AppStream | RHEL 8.2 |
| owasp-java-encoder                              | rhel8-AppStream | RHEL 8.2 |
| pcp-export-pcp2elasticsearch                    | rhel8-AppStream | RHEL 8.2 |
| pcp-export-pcp2spark                            | rhel8-AppStream | RHEL 8.2 |
| pcp-pmda-bpftrace                               | rhel8-AppStream | RHEL 8.2 |
| pcp-pmda-hacluster                              | rhel8-AppStream | RHEL 8.4 |
| pcp-pmda-mssql                                  | rhel8-AppStream | RHEL 8.2 |
| pcp-pmda-netcheck                               | rhel8-AppStream | RHEL 8.2 |
| pcp-pmda-openmetrics                            | rhel8-AppStream | RHEL 8.2 |
| pcp-pmda-openvswitch                            | rhel8-AppStream | RHEL 8.3 |
| pcp-pmda-rabbitmq                               | rhel8-AppStream | RHEL 8.3 |
| pcp-pmda-sockets                                | rhel8-AppStream | RHEL 8.4 |
| pcp-pmda-statsd                                 | rhel8-AppStream | RHEL 8.3 |
| pcre2-tools                                     | rhel8-CRB       | RHEL 8.3 |
| perl-Convert-ASN1                               | rhel8-AppStream | RHEL 8.2 |
| perl-LDAP                                       | rhel8-AppStream | RHEL 8.2 |
| perl-Mail-Sender                                | rhel8-AppStream | RHEL 8.3 |
| perl-Object-HashBase                            | rhel8-AppStream | RHEL 8.3 |
| perl-Object-HashBase-tools                      | rhel8-AppStream | RHEL 8.3 |
| pgaudit                                         | rhel8-AppStream | RHEL 8.2 |
| php-ffi                                         | rhel8-AppStream | RHEL 8.3 |
| php-pecl-rrd                                    | rhel8-AppStream | RHEL 8.2 |
| php-pecl-xdebug                                 | rhel8-AppStream | RHEL 8.2 |
| pipewire0.2                                     | rhel8-AppStream | RHEL 8.3 |
| pipewire0.2-devel                               | rhel8-AppStream | RHEL 8.3 |
| pipewire0.2-libs                                | rhel8-AppStream | RHEL 8.3 |
| pkI-acme                                        | rhel8-AppStream | RHEL 8.4 |
| pmix-devel                                      | rhel8-CRB       | RHEL 8.3 |
| podman-catatonit                                | rhel8-AppStream | RHEL 8.3 |
| podman-plugins                                  | rhel8-AppStream | RHEL 8.4 |
| postfix-cdb                                     | rhel8-AppStream | RHEL 8.2 |
| postfix-pcre                                    | rhel8-AppStream | RHEL 8.2 |
| postfix-sqlite                                  | rhel8-AppStream | RHEL 8.2 |
| postgres-decoderbufs                            | rhel8-AppStream | RHEL 8.2 |
| prometheus-jmx-exporter                         | rhel8-AppStream | RHEL 8.2 |
| protobuf-lite-devel                             | rhel8-CRB       | RHEL 8.3 |
| py3c-devel                                      | rhel8-CRB       | RHEL 8.4 |
| py3c-doc                                        | rhel8-CRB       | RHEL 8.4 |
| python2-pip-wheel                               | rhel8-Modules   | RHEL 8.1 |
| python2-setuptools-wheel                        | rhel8-Modules   | RHEL 8.1 |
| python2-wheel-wheel                             | rhel8-Modules   | RHEL 8.1 |
| python3-brotli                                  | rhel8-AppStream | RHEL 8.3 |
| python3-criu                                    | rhel8-AppStream | RHEL 8.2 |
| python3-dasbus                                  | rhel8-AppStream | RHEL 8.3 |
| python3-distro                                  | rhel8-Modules   | RHEL 8.1 |
| python3-dnf-plugin-post-transaction-actions     | rhel8-BaseOS    | RHEL 8.2 |
| python3-freeradius                              | rhel8-AppStream | RHEL 8.3 |
| python3-ipatests                                | rhel8-AppStream | RHEL 8.4 |
| python3-libmodulemd                             | rhel8-AppStream | RHEL 8.3 |
| python3-libmount                                | rhel8-AppStream | RHEL 8.3 |
| python3-libnbd                                  | rhel8-AppStream | RHEL 8.3 |
| python3-networkx-core                           | rhel8-AppStream | RHEL 8.2 |
| python3-networkx                                | rhel8-AppStream | RHEL 8.2 |
| python3-nftables                                | rhel8-BaseOS    | RHEL 8.2 |
| python3-nispor                                  | rhel8-AppStream | RHEL 8.4 |
| python3-osbuild                                 | rhel8-AppStream | RHEL 8.3 |
| python3-pip-wheel                               | rhel8-BaseOS    | RHEL 8.1 |
| python3-protobuf                                | rhel8-AppStream | RHEL 8.2 |
| python3-pyodbc                                  | rhel8-AppStream | RHEL 8.4 |
| python3-pyverbs                                 | rhel8-BaseOS    | RHEL 8.4 |
| python3-setuptools-wheel                        | rhel8-BaseOS    | RHEL 8.1 |
| python3-solv                                    | rhel8-BaseOS    | RHEL 8.3 |
| python3-subversion                              | rhel8-AppStream | RHEL 8.4 |
| python3-tracer                                  | rhel8-AppStream | RHEL 8.4 |
| python3-wheel-wheel                             | rhel8-AppStream | RHEL 8.1 |
| python3-wx-siplib                               | rhel8-AppStream | RHEL 8.3 |
| python38-asn1crypto                             | rhel8-AppStream | RHEL 8.2 |
| python38-atomicwrites                           | rhel8-CRB       | RHEL 8.2 |
| python38-attrs                                  | rhel8-CRB       | RHEL 8.2 |
| python38-babel                                  | rhel8-AppStream | RHEL 8.2 |
| python38-cffi                                   | rhel8-AppStream | RHEL 8.2 |
| python38-chardet                                | rhel8-AppStream | RHEL 8.2 |
| python38-cryptography                           | rhel8-AppStream | RHEL 8.2 |
| python38-Cython                                 | rhel8-AppStream | RHEL 8.2 |
| python38-debug                                  | rhel8-AppStream | RHEL 8.2 |
| python38-devel                                  | rhel8-AppStream | RHEL 8.2 |
| python38-idle                                   | rhel8-AppStream | RHEL 8.2 |
| python38-idna                                   | rhel8-AppStream | RHEL 8.2 |
| python38-jinja2                                 | rhel8-AppStream | RHEL 8.2 |
| python38-libs                                   | rhel8-AppStream | RHEL 8.2 |
| python38-lxml                                   | rhel8-AppStream | RHEL 8.2 |
| python38-markupsafe                             | rhel8-AppStream | RHEL 8.2 |
| python38-mod_wsgi                               | rhel8-AppStream | RHEL 8.2 |
| python38-more-itertools                         | rhel8-CRB       | RHEL 8.2 |
| python38-numpy-doc                              | rhel8-AppStream | RHEL 8.2 |
| python38-numpy-f2py                             | rhel8-AppStream | RHEL 8.2 |
| python38-numpy                                  | rhel8-AppStream | RHEL 8.2 |
| python38-packaging                              | rhel8-CRB       | RHEL 8.2 |
| python38-pip-wheel                              | rhel8-AppStream | RHEL 8.2 |
| python38-pip                                    | rhel8-AppStream | RHEL 8.2 |
| python38-pluggy                                 | rhel8-CRB       | RHEL 8.2 |
| python38-ply                                    | rhel8-AppStream | RHEL 8.2 |
| python38-psutil                                 | rhel8-AppStream | RHEL 8.2 |
| python38-psycopg2-doc                           | rhel8-AppStream | RHEL 8.2 |
| python38-psycopg2-tests                         | rhel8-AppStream | RHEL 8.2 |
| python38-psycopg2                               | rhel8-AppStream | RHEL 8.2 |
| python38-py                                     | rhel8-CRB       | RHEL 8.2 |
| python38-pycparser                              | rhel8-AppStream | RHEL 8.2 |
| python38-PyMySQL                                | rhel8-AppStream | RHEL 8.2 |
| python38-pyparsing                              | rhel8-CRB       | RHEL 8.2 |
| python38-pysocks                                | rhel8-AppStream | RHEL 8.2 |
| python38-pytest                                 | rhel8-CRB       | RHEL 8.2 |
| python38-pytz                                   | rhel8-AppStream | RHEL 8.2 |
| python38-pyyaml                                 | rhel8-AppStream | RHEL 8.2 |
| python38-requests                               | rhel8-AppStream | RHEL 8.2 |
| python38-rpm-macros                             | rhel8-AppStream | RHEL 8.2 |
| python38-scipy                                  | rhel8-AppStream | RHEL 8.2 |
| python38-setuptools-wheel                       | rhel8-AppStream | RHEL 8.2 |
| python38-setuptools                             | rhel8-AppStream | RHEL 8.2 |
| python38-six                                    | rhel8-AppStream | RHEL 8.2 |
| python38-test                                   | rhel8-AppStream | RHEL 8.2 |
| python38-tkinter                                | rhel8-AppStream | RHEL 8.2 |
| python38-urllib3                                | rhel8-AppStream | RHEL 8.2 |
| python38-wcwidth                                | rhel8-CRB       | RHEL 8.2 |
| python38-wheel-wheel                            | rhel8-AppStream | RHEL 8.2 |
| python38-wheel                                  | rhel8-AppStream | RHEL 8.2 |
| python38                                        | rhel8-AppStream | RHEL 8.2 |
| python39                                        | rhel8-AppStream | RHEL 8.4 |
| python39-attrs                                  | rhel8-CRB       | RHEL 8.4 |
| python39-cffi                                   | rhel8-AppStream | RHEL 8.4 |
| python39-chardet                                | rhel8-AppStream | RHEL 8.4 |
| python39-cryptography                           | rhel8-AppStream | RHEL 8.4 |
| python39-Cython                                 | rhel8-CRB       | RHEL 8.4 |
| python39-debug                                  | rhel8-CRB       | RHEL 8.4 |
| python39-devel                                  | rhel8-AppStream | RHEL 8.4 |
| python39-idle                                   | rhel8-AppStream | RHEL 8.4 |
| python39-idna                                   | rhel8-AppStream | RHEL 8.4 |
| python39-iniconfig                              | rhel8-CRB       | RHEL 8.4 |
| python39-libs                                   | rhel8-AppStream | RHEL 8.4 |
| python39-lxml                                   | rhel8-AppStream | RHEL 8.4 |
| python39-mod_wsgi                               | rhel8-AppStream | RHEL 8.4 |
| python39-more-itertools                         | rhel8-CRB       | RHEL 8.4 |
| python39-numpy                                  | rhel8-AppStream | RHEL 8.4 |
| python39-numpy-doc                              | rhel8-AppStream | RHEL 8.4 |
| python39-numpy-f2py                             | rhel8-AppStream | RHEL 8.4 |
| python39-packaging                              | rhel8-CRB       | RHEL 8.4 |
| python39-pip                                    | rhel8-AppStream | RHEL 8.4 |
| python39-pip-wheel                              | rhel8-AppStream | RHEL 8.4 |
| python39-pluggy                                 | rhel8-CRB       | RHEL 8.4 |
| python39-ply                                    | rhel8-AppStream | RHEL 8.4 |
| python39-psutil                                 | rhel8-AppStream | RHEL 8.4 |
| python39-psycopg2                               | rhel8-AppStream | RHEL 8.4 |
| python39-psycopg2-doc                           | rhel8-AppStream | RHEL 8.4 |
| python39-psycopg2-tests                         | rhel8-AppStream | RHEL 8.4 |
| python39-py                                     | rhel8-CRB       | RHEL 8.4 |
| python39-pybind11                               | rhel8-CRB       | RHEL 8.4 |
| python39-pybind11-devel                         | rhel8-CRB       | RHEL 8.4 |
| python39-pycparser                              | rhel8-AppStream | RHEL 8.4 |
| python39-PyMySQL                                | rhel8-AppStream | RHEL 8.4 |
| python39-pyparsing                              | rhel8-CRB       | RHEL 8.4 |
| python39-pysocks                                | rhel8-AppStream | RHEL 8.4 |
| python39-pytest                                 | rhel8-CRB       | RHEL 8.4 |
| python39-pyyaml                                 | rhel8-AppStream | RHEL 8.4 |
| python39-requests                               | rhel8-AppStream | RHEL 8.4 |
| python39-rpm-macros                             | rhel8-AppStream | RHEL 8.4 |
| python39-scipy                                  | rhel8-AppStream | RHEL 8.4 |
| python39-setuptools                             | rhel8-AppStream | RHEL 8.4 |
| python39-setuptools-wheel                       | rhel8-AppStream | RHEL 8.4 |
| python39-six                                    | rhel8-AppStream | RHEL 8.4 |
| python39-test                                   | rhel8-AppStream | RHEL 8.4 |
| python39-tkinter                                | rhel8-AppStream | RHEL 8.4 |
| python39-toml                                   | rhel8-AppStream | RHEL 8.4 |
| python39-urllib3                                | rhel8-AppStream | RHEL 8.4 |
| python39-wcwidth                                | rhel8-CRB       | RHEL 8.4 |
| python39-wheel                                  | rhel8-AppStream | RHEL 8.4 |
| python39-wheel-wheel                            | rhel8-AppStream | RHEL 8.4 |
| qatengine                                       | rhel8-AppStream | RHEL 8.4 |
| qatlib                                          | rhel8-AppStream | RHEL 8.4 |
| qatlib-devel                                    | rhel8-CRB       | RHEL 8.4 |
| qgpgme-devel                                    | rhel8-CRB       | RHEL 8.4 |
| qt5-qtbase-private-devel                        | rhel8-AppStream | RHEL 8.2 |
| quota-devel                                     | rhel8-CRB       | RHEL 8.4 |
| rhc                                             | rhel8-AppStream | RHEL 8.4 |
| rhc-worker-playbook                             | rhel8-AppStream | RHEL 8.4 |
| rhsm-icons                                      | rhel8-BaseOS    | RHEL 8.2 |
| rpm-plugin-fapolicyd                            | rhel8-AppStream | RHEL 8.4 |
| rshim                                           | rhel8-AppStream | RHEL 8.4 |
| rsyslog-omamqp1                                 | rhel8-AppStream | RHEL 8.3 |
| rsyslog-udpspoof                                | rhel8-AppStream | RHEL 8.4 |
| ruby-default-gems                               | rhel8-AppStream | RHEL 8.3 |
| samba-devel                                     | rhel8-CRB       | RHEL 8.4 |
| samba-winexe                                    | rhel8-BaseOS    | RHEL 8.4 |
| sat4j                                           | rhel8-AppStream | RHEL 8.4 |
| sblim-cmpi-base                                 | rhel8-AppStream | RHEL 8.1 |
| sblim-indication_helper                         | rhel8-AppStream | RHEL 8.1 |
| sblim-wbemcli                                   | rhel8-AppStream | RHEL 8.1 |
| setools-console-analyses                        | rhel8-AppStream | RHEL 8.2 |
| setools-gui                                     | rhel8-AppStream | RHEL 8.2 |
| sisu                                            | rhel8-AppStream | RHEL 8.2 |
| spice-client-win-x64                            | rhel8-AppStream | RHEL 8.2 |
| spice-client-win-x86                            | rhel8-AppStream | RHEL 8.2 |
| spice-qxl-wddm-dod                              | rhel8-AppStream | RHEL 8.2 |
| spice-qxl-xddm                                  | rhel8-AppStream | RHEL 8.2 |
| spice-streaming-agent                           | rhel8-AppStream | RHEL 8.2 |
| spice-vdagent-win-x64                           | rhel8-AppStream | RHEL 8.2 |
| spice-vdagent-win-x86                           | rhel8-AppStream | RHEL 8.2 |
| sssd-polkit-rules                               | rhel8-BaseOS    | RHEL 8.1 |
| stalld                                          | rhel8-AppStream | RHEL 8.4 |
| Placach-ng                                      | rhel8-NFV       | RHEL 8.3 |
| swig (swig:4.0)                                 | rhel8-AppStream | RHEL 8.4 |
| swig-doc (swig:4.0)                             | rhel8-BaseOS    | RHEL 8.4 |
| swig-gdb (swig:4.0)                             | rhel8-AppStream | RHEL 8.4 |
| texlive-context                                 | rhel8-AppStream | RHEL 8.3 |
| texlive-pst-arrow                               | rhel8-AppStream | RHEL 8.3 |
| texlive-pst-tools                               | rhel8-AppStream | RHEL 8.3 |
| Thermald                                        | rhel8-AppStream | RHEL 8.3 |
| tigervnc-selinux                                | rhel8-AppStream | RHEL 8.3 |
| tracer-common                                   | rhel8-AppStream | RHEL 8.4 |
| tracker-devel                                   | rhel8-CRB       | RHEL 8.3 |
| twolame-devel                                   | rhel8-CRB       | RHEL 8.4 |
| ucx-cma                                         | rhel8-AppStream | RHEL 8.4 |
| ucx-devel                                       | rhel8-AppStream | RHEL 8.4 |
| ucx-ib                                          | rhel8-AppStream | RHEL 8.4 |
| ucx-rdmacm                                      | rhel8-AppStream | RHEL 8.4 |
| udica                                           | rhel8-AppStream | RHEL 8.1 |
| udisks2-lsm                                     | rhel8-AppStream | RHEL 8.3 |
| univocity-parsers                               | rhel8-AppStream | RHEL 8.4 |
| usbguard-notifier                               | rhel8-AppStream | RHEL 8.3 |
| usbguard-selinux                                | rhel8-AppStream | RHEL 8.3 |
| vdo-support                                     | rhel8-BaseOS    | RHEL 8.3 |
| WALinuxAgent-udev                               | rhel8-AppStream | RHEL 8.4 |
| whois-nls                                       | rhel8-AppStream | RHEL 8.2 |
| whois                                           | rhel8-AppStream | RHEL 8.2 |
| woff2-devel                                     | rhel8-CRB       | RHEL 8.4 |
| xdp-tools                                       | rhel8-AppStream | RHEL 8.3 |
| xmlgraphics-commons                             | rhel8-AppStream | RHEL 8.4 |
| xorg-x11-server-source                          | rhel8-CRB       | RHEL 8.3 |
| zstd                                            | rhel8-AppStream | RHEL 8.2 |

​					有关当前 RHEL 8 次要发行本中可用软件包的完整列表，请查看 [软件包清单](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/package_manifest/)。 			

### A.1.2. RHEL 8.0 中的新软件包

​					以下软件包在 RHEL 8.0 中是新的： 			

​					**#** | `389-ds-base-legacy-tools` 			

​					**A** | `aajohan-comfortaa-fonts, abrt-addon-coredump-helper, abrt-cli-ng, abrt-plugin-machine-id,  abrt-plugin-sosreport, adcli-doc, alsa-ucm, alsa-utils-alsabat,  anaconda-install-env-deps, annobin, ant-lib, ant-xz, apcu-panel,  apr-util-bdb, aspell-en, assertj-core, assertj-core-javadoc,  atlas-corei2, atlas-corei2-devel, audispd-plugins-zos, authselect,  authselect-compat, authselect-libs` 			

​					**B** | `bacula-logwatch, beignet, blivet-data, bluez-obexd, bnd-maven-plugin, boom-boot,  boom-boot-conf, boom-boot-grub2, boost-container, boost-coroutine,  boost-fiber, boost-log, boost-mpich-python3, boost-numpy3,  boost-openmpi-python3, boost-python3, boost-python3-devel,  boost-stacktrace, boost-type_erasure, brltty-dracut, brltty-espeak-ng,  brotli, brotli-devel, bubblewrap, buildah` 			

​					**C** | `c2esp, cargo, cargo-doc, cargo-vendor, cjose, cjose-devel, clang,  clang-analyzer, clang-devel, clang-libs, clang-tools-extra,  cldr-emoji-annotation, clippy, cmake-data, cmake-doc, cmake-filesystem,  cmake-rpm-macros, cockpit-composer, cockpit-dashboard, cockpit-machines, cockpit-packagekit, cockpit-pcp, cockpit-session-recording,  cockpit-storaged, compat-guile18, compat-guile18-devel,  compat-libgfortran-48, compat-libpthread-nonshared, compat-openssl10,  compiler-rt, composer-cli, container-exception-logger,  container-selinux, containernetworking-plugins, containers-common,  coreutils-common, coreutils-single, cppcheck, createrepo_c,  createrepo_c-devel, createrepo_c-libs, crypto-policies, CUnit,  CUnit-devel, cyrus-imapd-vzic` 			

​					**D** | `dbus-c, dbus-c-devel, dbus-c++-glib, dbus-common, dbus-daemon, dbus-tools,  dhcp-client, dhcp-relay, dhcp-server, dleyna-renderer, dnf,  dnf-automatic, dnf-data, dnf-plugin-spacewalk,  dnf-plugin-subscription-manager, dnf-plugins-core, dnf-utils,  dnssec-trigger-panel, docbook2X, dotnet, dotnet-host,  dotnet-host-fxr-2.1, dotnet-runtime-2.1, dotnet-sdk-2.1,  dotnet-sdk-2.1.5xx, dpdk, dpdk-devel, dpdk-doc, dpdk-tools, dracut-live, dracut-squash, driverctl, drpm, drpm-devel, dtc` 			

​					**E** | `edk2-aarch64, edk2-ovmf, efi-filesystem, efi-srpm-macros, egl-wayland,  eglexternalplatform-devel, eigen3-devel, emacs-lucid, enca, enca-devel,  enchant2, enchant2-devel, espeak-ng, evemu, evemu-libs, execstack` 			

​					**F** | `fence-agents-lpar, fence-agents-zvm, fftw-libs-quad, freeradius-rest, fuse-common,  fuse-overlayfs, fuse-sshfs, fuse3, fuse3-devel, fuse3-libs` 			

​					**G** | `galera, gcc-gdb-plugin, gcc-offload-nvptx, gdb-headless, gdbm-libs,  gdk-pixbuf2-modules, gdk-pixbuf2-xlib, gdk-pixbuf2-xlib-devel, gegl04,  gegl04-devel, genwqe-tools, genwqe-vpd, genwqe-zlib, genwqe-zlib-devel,  geronimo-jpa, geronimo-jpa-javadoc, gfbgraph, gflags, gflags-devel,  ghc-srpm-macros, ghostscript-tools-dvipdf, ghostscript-tools-fonts,  ghostscript-tools-printing, ghostscript-x11, git-clang-format, git-core, git-core-doc, git-subtree, glassfish-annotation-api,  glassfish-annotation-api-javadoc, glassfish-jax-rs-api,  glassfish-jax-rs-api-javadoc, glassfish-jaxb-bom,  glassfish-jaxb-bom-ext, glassfish-jaxb-codemodel,  glassfish-jaxb-codemodel-annotation-compiler,  glassfish-jaxb-codemodel-parent, glassfish-jaxb-core,  glassfish-jaxb-external-parent, glassfish-jaxb-parent,  glassfish-jaxb-rngom, glassfish-jaxb-runtime,  glassfish-jaxb-runtime-parent, glassfish-jaxb-txw-parent,  glassfish-jaxb-txw2, glassfish-legal, glassfish-master-pom,  glassfish-servlet-api, glassfish-servlet-api-javadoc,  glibc-all-langpacks, glibc-langpack-aa, glibc-langpack-af,  glibc-langpack-agr, glibc-langpack-ak, glibc-langpack-am,  glibc-langpack-an, glibc-langpack-anp, glibc-langpack-ar,  glibc-langpack-as, glibc-langpack-ast, glibc-langpack-ayc,  glibc-langpack-az, glibc-langpack-be, glibc-langpack-bem,  glibc-langpack-ber, glibc-langpack-bg, glibc-langpack-bhb,  glibc-langpack-bho, glibc-langpack-bi, glibc-langpack-bn,  glibc-langpack-bo, glibc-langpack-br, glibc-langpack-brx,  glibc-langpack-bs, glibc-langpack-byn, glibc-langpack-ca,  glibc-langpack-ce, glibc-langpack-chr, glibc-langpack-cmn,  glibc-langpack-crh, glibc-langpack-cs, glibc-langpack-csb,  glibc-langpack-cv, glibc-langpack-cy, glibc-langpack-da,  glibc-langpack-de, glibc-langpack-doi, glibc-langpack-dsb,  glibc-langpack-dv, glibc-langpack-dz, glibc-langpack-el,  glibc-langpack-en, glibc-langpack-eo, glibc-langpack-es,  glibc-langpack-et, glibc-langpack-eu, glibc-langpack-fa,  glibc-langpack-ff, glibc-langpack-fi, glibc-langpack-fil,  glibc-langpack-fo, glibc-langpack-fr, glibc-langpack-fur,  glibc-langpack-fy, glibc-langpack-ga, glibc-langpack-gd,  glibc-langpack-gez, glibc-langpack-gl, glibc-langpack-gu,  glibc-langpack-gv, glibc-langpack-ha, glibc-langpack-hak,  glibc-langpack-he, glibc-langpack-hi, glibc-langpack-hif,  glibc-langpack-hne, glibc-langpack-hr, glibc-langpack-hsb,  glibc-langpack-ht, glibc-langpack-hu, glibc-langpack-hy,  glibc-langpack-ia, glibc-langpack-id, glibc-langpack-ig,  glibc-langpack-ik, glibc-langpack-is, glibc-langpack-it,  glibc-langpack-iu, glibc-langpack-ja, glibc-langpack-ka,  glibc-langpack-kab, glibc-langpack-kk, glibc-langpack-kl,  glibc-langpack-km, glibc-langpack-kn, glibc-langpack-ko,  glibc-langpack-kok, glibc-langpack-ks, glibc-langpack-ku,  glibc-langpack-kw, glibc-langpack-ky, glibc-langpack-lb,  glibc-langpack-lg, glibc-langpack-li, glibc-langpack-lij,  glibc-langpack-ln, glibc-langpack-lo, glibc-langpack-lt,  glibc-langpack-lv, glibc-langpack-lzh, glibc-langpack-mag,  glibc-langpack-mai, glibc-langpack-mfe, glibc-langpack-mg,  glibc-langpack-mhr, glibc-langpack-mi, glibc-langpack-miq,  glibc-langpack-mjw, glibc-langpack-mk, glibc-langpack-ml,  glibc-langpack-mn, glibc-langpack-mni, glibc-langpack-mr,  glibc-langpack-ms, glibc-langpack-mt, glibc-langpack-my,  glibc-langpack-nan, glibc-langpack-nb, glibc-langpack-nds,  glibc-langpack-ne, glibc-langpack-nhn, glibc-langpack-niu,  glibc-langpack-nl, glibc-langpack-nn, glibc-langpack-nr,  glibc-langpack-nso, glibc-langpack-oc, glibc-langpack-om,  glibc-langpack-or, glibc-langpack-os, glibc-langpack-pa,  glibc-langpack-pap, glibc-langpack-pl, glibc-langpack-ps,  glibc-langpack-pt, glibc-langpack-quz, glibc-langpack-raj,  glibc-langpack-ro, glibc-langpack-ru, glibc-langpack-rw,  glibc-langpack-sa, glibc-langpack-sah, glibc-langpack-sat,  glibc-langpack-sc, glibc-langpack-sd, glibc-langpack-se,  glibc-langpack-sgs, glibc-langpack-shn, glibc-langpack-shs,  glibc-langpack-si, glibc-langpack-sid, glibc-langpack-sk,  glibc-langpack-sl, glibc-langpack-sm, glibc-langpack-so,  glibc-langpack-sq, glibc-langpack-sr, glibc-langpack-ss,  glibc-langpack-st, glibc-langpack-sv, glibc-langpack-sw,  glibc-langpack-szl, glibc-langpack-ta, glibc-langpack-tcy,  glibc-langpack-te, glibc-langpack-tg, glibc-langpack-th,  glibc-langpack-the, glibc-langpack-ti, glibc-langpack-tig,  glibc-langpack-tk, glibc-langpack-tl, glibc-langpack-tn,  glibc-langpack-to, glibc-langpack-tpi, glibc-langpack-tr,  glibc-langpack-ts, glibc-langpack-tt, glibc-langpack-ug,  glibc-langpack-uk, glibc-langpack-unm, glibc-langpack-ur,  glibc-langpack-uz, glibc-langpack-ve, glibc-langpack-vi,  glibc-langpack-wa, glibc-langpack-wae, glibc-langpack-wal,  glibc-langpack-wo, glibc-langpack-xh, glibc-langpack-yi,  glibc-langpack-yo, glibc-langpack-yue, glibc-langpack-yuw,  glibc-langpack-zh, glibc-langpack-zu, glibc-locale-source,  glibc-minimal-langpack, glog, glog-devel, gmock, gmock-devel, gmp-c++,  gnome-autoar, gnome-backgrounds-extras, gnome-characters,  gnome-control-center, gnome-control-center-filesystem, gnome-logs,  gnome-photos, gnome-photos-tests, gnome-remote-desktop,  gnome-shell-extension-desktop-icons, gnome-tweaks,  go-compilers-golang-compiler, go-srpm-macros, go-toolset, golang,  golang-bin, golang-docs, golang-misc, golang-race, golang-src,  golang-tests, google-droid-kufi-fonts, google-droid-sans-fonts,  google-droid-sans-mono-fonts, google-droid-serif-fonts,  google-noto-cjk-fonts-common, google-noto-mono-fonts,  google-noto-nastaliq-urdu-fonts, google-noto-sans-cjk-jp-fonts,  google-noto-sans-cjk-ttc-fonts, google-noto-sans-oriya-fonts,  google-noto-sans-oriya-ui-fonts, google-noto-sans-tibetan-fonts,  google-noto-serif-bengali-fonts, google-noto-serif-cjk-ttc-fonts,  google-noto-serif-devanagari-fonts, google-noto-serif-gujarati-fonts,  google-noto-serif-kannada-fonts, google-noto-serif-malayalam-fonts,  google-noto-serif-tamil-fonts, google-noto-serif-telugu-fonts,  google-roboto-slab-fonts, gpgmepp, gpgmepp-devel, grub2-tools-efi,  gssntlmssp, gstreamer1-plugins-good-gtk, gtest, gtest-devel, guava20,  guava20-javadoc, guava20-testlib, guice-assistedinject, guice-bom,  guice-extensions, guice-grapher, guice-jmx, guice-jndi,  guice-multibindings, guice-servlet, guice-testlib,  guice-throwingproviders, gutenprint-libs, gutenprint-libs-ui` 			

​					**H** | `hamcrest-core, hawtjni-runtime, hexchat, hexchat-devel, httpcomponents-client-cache,  httpd-filesystem, hunspell-es-AR, hunspell-es-BO, hunspell-es-CL,  hunspell-es-CO, hunspell-es-CR, hunspell-es-CU, hunspell-es-DO,  hunspell-es-EC, hunspell-es-ES, hunspell-es-GT, hunspell-es-HN,  hunspell-es-MX, hunspell-es-NI, hunspell-es-PA, hunspell-es-PE,  hunspell-es-PR, hunspell-es-PY, hunspell-es-SV, hunspell-es-US,  hunspell-es-UY, hunspell-es-VE` 			

​					**I** | `i2c-tools-perl, ibus-libzhuyin, ibus-wayland, iio-sensor-proxy,  infiniband-diags-compat, integritysetup, ipa-idoverride-memberof-plugin, ipcalc, ipmievd, iproute-tc, iptables-arptables, iptables-ebtables,  iptables-libs, isl, isl-devel, isns-utils-devel, isns-utils-libs,  istack-commons-runtime, istack-commons-tools, ivy-local` 			

​					**J** | `jackson-annotations, jackson-annotations-javadoc, jackson-core, jackson-core-javadoc,  jackson-databind, jackson-databind-javadoc, jackson-jaxrs-json-provider, jackson-jaxrs-providers, jackson-jaxrs-providers-datatypes,  jackson-jaxrs-providers-javadoc, jackson-module-jaxb-annotations,  jackson-module-jaxb-annotations-javadoc, javapackages-filesystem,  javapackages-local, jbig2dec-libs, jboss-annotations-1.2-api,  jboss-interceptors-1.2-api, jboss-interceptors-1.2-api-javadoc,  jboss-jaxrs-2.0-api, jboss-logging, jboss-logging-tools, jcl-over-slf4j, jdeparser, jdom2, jdom2-javadoc, jimtcl, jimtcl-devel, jq, js-uglify,  Judy, jul-to-slf4j, julietaula-montserrat-fonts` 			

​					**K** | `kabi-dw, kdump-anaconda-addon, kernel-core, kernel-cross-headers,  kernel-debug-core, kernel-debug-modules, kernel-debug-modules-extra,  kernel-modules, kernel-modules-extra, kernel-rpm-macros, kernel-rt-core, kernel-rt-debug-core, kernel-rt-debug-modules,  kernel-rt-debug-modules-extra, kernel-rt-modules,  kernel-rt-modules-extra, kernelshark, koan, kyotocabinet-libs` 			

​					**L** | `lame-devel, lame-libs, langpacks-af, langpacks-am, langpacks-ar, langpacks-as,  langpacks-ast, langpacks-be, langpacks-bg, langpacks-bn, langpacks-br,  langpacks-bs, langpacks-ca, langpacks-cs, langpacks-cy, langpacks-da,  langpacks-de, langpacks-el, langpacks-en, langpacks-en_GB, langpacks-es, langpacks-et, langpacks-eu, langpacks-fa, langpacks-fi, langpacks-fr,  langpacks-ga, langpacks-gl, langpacks-gu, langpacks-he, langpacks-hi,  langpacks-hr, langpacks-hu, langpacks-ia, langpacks-id, langpacks-is,  langpacks-it, langpacks-ja, langpacks-kk, langpacks-kn, langpacks-ko,  langpacks-lt, langpacks-lv, langpacks-mai, langpacks-mk, langpacks-ml,  langpacks-mr, langpacks-ms, langpacks-nb, langpacks-ne, langpacks-nl,  langpacks-nn, langpacks-nr, langpacks-nso, langpacks-or, langpacks-pa,  langpacks-pl, langpacks-pt, langpacks-pt_BR, langpacks-ro, langpacks-ru, langpacks-si, langpacks-sk, langpacks-sl, langpacks-sq, langpacks-sr,  langpacks-ss, langpacks-sv, langpacks-ta, langpacks-te, langpacks-th,  langpacks-tn, langpacks-tr, langpacks-ts, langpacks-uk, langpacks-ur,  langpacks-ve, langpacks-vi, langpacks-xh, langpacks-zh_CN,  langpacks-zh_TW, langpacks-zu, lato-fonts, lensfun, lensfun-devel,  leptonica, leptonica-devel, liba52, libaec, libaec-devel, libatomic_ops, libbabeltrace, libblockdev-lvm-dbus, libcephfs-devel, libcephfs2,  libcmocka, libcmocka-devel, libcomps, libcomps-devel, libcurl-minimal,  libdap, libdap-devel, libdatrie, libdatrie-devel, libdazzle, libdc1394,  libdnf, libEMF, libEMF-devel, libeot, libepubgen,  libertas-sd8686-firmware, libertas-sd8787-firmware,  libertas-usb8388-firmware, libertas-usb8388-olpc-firmware, libev,  libev-devel, libev-libevent-devel, libev-source, libfdisk,  libfdisk-devel, libfdt, libfdt-devel, libgit2, libgit2-devel,  libgit2-glib, libgit2-glib-devel, libgomp-offload-nvptx, libgudev,  libgudev-devel, libi2c, libidn2, libidn2-devel, libijs, libinput-utils,  libipt, libisoburn, libisoburn-devel, libkcapi, libkcapi-hmaccalc,  libkeepalive, libknet1, libknet1-compress-bzip2-plugin,  libknet1-compress-lz4-plugin, libknet1-compress-lzma-plugin,  libknet1-compress-lzo2-plugin, libknet1-compress-plugins-all,  libknet1-compress-zlib-plugin, libknet1-crypto-nss-plugin,  libknet1-crypto-openssl-plugin, libknet1-crypto-plugins-all,  libknet1-devel, libknet1-plugins-all, liblangtag-data, libmad,  libmad-devel, libmcpp, libmemcached-libs, libmetalink, libmodulemd,  libmodulemd-devel, libmodulemd1, libnghttp2, libnghttp2-devel,  libnice-gstreamer1, libnsl, libnsl2, libnsl2-devel, liboggz, libomp,  libomp-devel, libomp-test, libpeas-loader-python3, libpkgconf, libpq,  libpq-devel, libproxy-webkitgtk4, libpsl, libqhull, libqhull_p,  libqhull_r, libqxp, librados-devel, libradosstriper-devel,  libradosstriper1, librbd-devel, libreoffice-help-en,  libreoffice-langpack-af, libreoffice-langpack-ar,  libreoffice-langpack-as, libreoffice-langpack-bg,  libreoffice-langpack-bn, libreoffice-langpack-br,  libreoffice-langpack-ca, libreoffice-langpack-cs,  libreoffice-langpack-cy, libreoffice-langpack-da,  libreoffice-langpack-de, libreoffice-langpack-dz,  libreoffice-langpack-el, libreoffice-langpack-es,  libreoffice-langpack-et, libreoffice-langpack-eu,  libreoffice-langpack-fa, libreoffice-langpack-fi,  libreoffice-langpack-fr, libreoffice-langpack-ga,  libreoffice-langpack-gl, libreoffice-langpack-gu,  libreoffice-langpack-he, libreoffice-langpack-hi,  libreoffice-langpack-hr, libreoffice-langpack-hu,  libreoffice-langpack-id, libreoffice-langpack-it,  libreoffice-langpack-ja, libreoffice-langpack-kk,  libreoffice-langpack-kn, libreoffice-langpack-ko,  libreoffice-langpack-lt, libreoffice-langpack-lv,  libreoffice-langpack-mai, libreoffice-langpack-ml,  libreoffice-langpack-mr, libreoffice-langpack-nb,  libreoffice-langpack-nl, libreoffice-langpack-nn,  libreoffice-langpack-nr, libreoffice-langpack-nso,  libreoffice-langpack-or, libreoffice-langpack-pa,  libreoffice-langpack-pl, libreoffice-langpack-pt-BR,  libreoffice-langpack-pt-PT, libreoffice-langpack-ro,  libreoffice-langpack-ru, libreoffice-langpack-si,  libreoffice-langpack-sk, libreoffice-langpack-sl,  libreoffice-langpack-sr, libreoffice-langpack-ss,  libreoffice-langpack-st, libreoffice-langpack-sv,  libreoffice-langpack-ta, libreoffice-langpack-te,  libreoffice-langpack-th, libreoffice-langpack-tn,  libreoffice-langpack-tr, libreoffice-langpack-ts,  libreoffice-langpack-uk, libreoffice-langpack-ve,  libreoffice-langpack-xh, libreoffice-langpack-zh-Hans,  libreoffice-langpack-zh-Hant, libreoffice-langpack-zu, librhsm, librx,  librx-devel, libsass, libsass-devel, libserf, libsigsegv,  libsigsegv-devel, libssh, libssh-devel, libstemmer, libstemmer-devel,  libubsan, libucil, libucil-devel, libunicap, libunicap-devel, libuv,  libvarlink, libvarlink-devel, libvarlink-util, libvirt-dbus, libX11-xcb, libxcam, libxcrypt, libxcrypt-devel, libxcrypt-static, libXNVCtrl,  libXNVCtrl-devel, libzhuyin, libzip-tools, lld, lld-devel, lld-libs,  lldb, lldb-devel, lldpd, lldpd-devel, llvm, llvm-devel, llvm-doc,  llvm-googletest, llvm-libs, llvm-static, llvm-test, llvm-toolset,  log4j-over-slf4j, log4j12, log4j12-javadoc, lohit-gurmukhi-fonts,  lohit-odia-fonts, lorax-composer, lorax-lmc-novirt, lorax-lmc-virt,  lorax-templates-generic, lorax-templates-rhel, lttng-ust,  lttng-ust-devel, lua-expat, lua-filesystem, lua-json, lua-libs,  lua-lpeg, lua-lunit, lua-posix, lua-socket, lvm2-dbusd, lz4-libs` 			

​					**M** | `make-devel, man-db-cron, mariadb-backup, mariadb-common, mariadb-connector-c,  mariadb-connector-c-config, mariadb-connector-c-devel,  mariadb-connector-odbc, mariadb-errmsg, mariadb-gssapi-server,  mariadb-java-client, mariadb-oqgraph-engine, mariadb-server-galera,  mariadb-server-utils, maven-artifact-transfer,  maven-artifact-transfer-javadoc, maven-lib, maven-resolver,  maven-resolver-api, maven-resolver-connector-basic, maven-resolver-impl, maven-resolver-javadoc, maven-resolver-spi, maven-resolver-test-util,  maven-resolver-transport-classpath, maven-resolver-transport-file,  maven-resolver-transport-http, maven-resolver-transport-wagon,  maven-resolver-util, maven-wagon-file, maven-wagon-ftp,  maven-wagon-http, maven-wagon-http-lightweight, maven-wagon-http-shared, maven-wagon-provider-api, maven-wagon-providers, mcpp, mecab,  mecab-ipadic, mecab-ipadic-EUCJP, mesa-vulkan-devel, meson, metis,  metis-devel, microdnf, mingw-binutils-generic, mingw-filesystem-base,  mingw32-binutils, mingw32-bzip2, mingw32-bzip2-static, mingw32-cairo,  mingw32-cpp, mingw32-crt, mingw32-expat, mingw32-filesystem,  mingw32-fontconfig, mingw32-freetype, mingw32-freetype-static,  mingw32-gcc, mingw32-gcc-c, mingw32-gettext, mingw32-gettext-static,  mingw32-glib2, mingw32-glib2-static, mingw32-gstreamer1,  mingw32-harfbuzz, mingw32-harfbuzz-static, mingw32-headers, mingw32-icu, mingw32-libffi, mingw32-libjpeg-turbo, mingw32-libjpeg-turbo-static,  mingw32-libpng, mingw32-libpng-static, mingw32-libtiff,  mingw32-libtiff-static, mingw32-openssl, mingw32-pcre,  mingw32-pcre-static, mingw32-pixman, mingw32-pkg-config,  mingw32-readline, mingw32-sqlite, mingw32-sqlite-static,  mingw32-termcap, mingw32-win-iconv, mingw32-win-iconv-static,  mingw32-winpthreads, mingw32-winpthreads-static, mingw32-zlib,  mingw32-zlib-static, mingw64-binutils, mingw64-bzip2,  mingw64-bzip2-static, mingw64-cairo, mingw64-cpp, mingw64-crt,  mingw64-expat, mingw64-filesystem, mingw64-fontconfig, mingw64-freetype, mingw64-freetype-static, mingw64-gcc, mingw64-gcc-c, mingw64-gettext,  mingw64-gettext-static, mingw64-glib2, mingw64-glib2-static,  mingw64-gstreamer1, mingw64-harfbuzz, mingw64-harfbuzz-static,  mingw64-headers, mingw64-icu, mingw64-libffi, mingw64-libjpeg-turbo,  mingw64-libjpeg-turbo-static, mingw64-libpng, mingw64-libpng-static,  mingw64-libtiff, mingw64-libtiff-static, mingw64-openssl, mingw64-pcre,  mingw64-pcre-static, mingw64-pixman, mingw64-pkg-config,  mingw64-readline, mingw64-sqlite, mingw64-sqlite-static,  mingw64-termcap, mingw64-win-iconv, mingw64-win-iconv-static,  mingw64-winpthreads, mingw64-winpthreads-static, mingw64-zlib,  mingw64-zlib-static, mockito, mockito-javadoc, mod_http2, mod_md,  mozvoikko, mpich, mpich-devel, mpitests-mvapich2-psm2,  multilib-rpm-config, munge, munge-devel, munge-libs, mvapich2,  mvapich2-psm2, mysql, mysql-common, mysql-devel, mysql-errmsg,  mysql-libs, mysql-server, mysql-test` 			

​					**N** | `nbdkit-bash-completion, nbdkit-plugin-gzip, nbdkit-plugin-python3, nbdkit-plugin-xz,  ncurses-c++-libs, ncurses-compat-libs, netconsole-service,  network-scripts, network-scripts-team,  NetworkManager-config-connectivity-redhat, nghttp2, nginx,  nginx-all-modules, nginx-filesystem, nginx-mod-http-image-filter,  nginx-mod-http-perl, nginx-mod-http-xslt-filter, nginx-mod-mail,  nginx-mod-stream, ninja-build, nkf, nodejs, nodejs-devel, nodejs-docs,  nodejs-nodemon, nodejs-packaging, npm, npth, nss_db, nss_nis,  nss_wrapper, nss-altfiles, ntpstat` 			

​					**O** | `objectweb-pom, objenesis, objenesis-javadoc, ocaml-cppo, ocaml-labltk,  ocaml-labltk-devel, oci-systemd-hook, oci-umount, ocl-icd,  ocl-icd-devel, ongres-scram, ongres-scram-client, oniguruma,  oniguruma-devel, openal-soft, openal-soft-devel, openblas,  openblas-devel, openblas-openmp, openblas-openmp64, openblas-openmp64_,  openblas-Rblas, openblas-serial64, openblas-serial64_,  openblas-srpm-macros, openblas-static, openblas-threads,  openblas-threads64, openblas-threads64_, opencl-filesystem,  opencl-headers, opencv-contrib, OpenIPMI-lanserv, openscap-python3,  openssl-ibmpkcs11, openssl-pkcs11, openwsman-python3, os-maven-plugin,  os-maven-plugin-javadoc, osad, osgi-annotation, osgi-annotation-javadoc, osgi-compendium, osgi-compendium-javadoc, osgi-core, osgi-core-javadoc, ostree, ostree-devel, ostree-grub2, ostree-libs, overpass-mono-fonts` 			

​					**P** | `p11-kit-server, pacemaker-schemas, pam_cifscreds, pandoc, pandoc-common, papi-libs,  pcaudiolib, pcp-pmda-podman, pcre-cpp, pcre-utf16, pcre-utf32, peripety, perl-AnyEvent, perl-Attribute-Handlers, perl-B-Debug,  perl-B-Hooks-EndOfScope, perl-bignum, perl-Canary-Stability,  perl-Class-Accessor, perl-Class-Factory-Util,  perl-Class-Method-Modifiers, perl-Class-Tiny, perl-Class-XSAccessor,  perl-common-sense, perl-Compress-Bzip2, perl-Config-AutoConf,  perl-Config-Perl-V, perl-CPAN-DistnameInfo, perl-CPAN-Meta-Check,  perl-Data-Dump, perl-Data-Section, perl-Data-UUID, perl-Date-ISO8601,  perl-DateTime-Format-Builder, perl-DateTime-Format-HTTP,  perl-DateTime-Format-ISO8601, perl-DateTime-Format-Mail,  perl-DateTime-Format-Strptime, perl-DateTime-TimeZone-SystemV,  perl-DateTime-TimeZone-Tzfile, perl-Devel-CallChecker,  perl-Devel-Caller, perl-Devel-GlobalDestruction, perl-Devel-LexAlias,  perl-Devel-Peek, perl-Devel-PPPort, perl-Devel-SelfStubber,  perl-Devel-Size, perl-Digest-CRC, perl-DynaLoader-Functions,  perl-encoding, perl-Errno, perl-Eval-Closure, perl-experimental,  perl-Exporter-Tiny, perl-ExtUtils-Command, perl-ExtUtils-Miniperl,  perl-ExtUtils-MM-Utils, perl-Fedora-VSP, perl-File-BaseDir,  perl-File-chdir, perl-File-DesktopEntry, perl-File-Find-Object,  perl-File-MimeInfo, perl-File-ReadBackwards, perl-Filter-Simple,  perl-generators, perl-Import-Into, perl-Importer, perl-inc-latest,  perl-interpreter, perl-IO, perl-IO-All, perl-IO-Multiplex,  perl-IPC-System-Simple, perl-IPC-SysV, perl-JSON-XS, perl-libintl-perl,  perl-libnet, perl-libnetcfg, perl-List-MoreUtils-XS,  perl-Locale-gettext, perl-Math-BigInt, perl-Math-BigInt-FastCalc,  perl-Math-BigRat, perl-Math-Complex, perl-Memoize, perl-MIME-Base64,  perl-MIME-Charset, perl-MIME-Types, perl-Module-CoreList-tools,  perl-Module-CPANfile, perl-Module-Install-AuthorTests,  perl-Module-Install-ReadmeFromPod, perl-MRO-Compat,  perl-namespace-autoclean, perl-namespace-clean, perl-Net-Ping,  perl-Net-Server, perl-NKF, perl-NTLM, perl-open, perl-Params-Classify,  perl-Params-ValidationCompiler, perl-Parse-PMFile, perl-Path-Tiny,  perl-Perl-Destruct-Level, perl-perlfaq, perl-PerlIO-utf8_strict,  perl-PerlIO-via-QuotedPrint, perl-Pod-Html, perl-Pod-Markdown,  perl-Ref-Util, perl-Ref-Util-XS, perl-Role-Tiny, perl-Scope-Guard,  perl-SelfLoader, perl-Software-License, perl-Specio,  perl-Sub-Exporter-Progressive, perl-Sub-Identify, perl-Sub-Info,  perl-Sub-Name, perl-SUPER, perl-Term-ANSIColor, perl-Term-Cap,  perl-Term-Size-Any, perl-Term-Size-Perl, perl-Term-Table, perl-Test,  perl-Test-LongString, perl-Test-Warnings, perl-Test2-Suite,  perl-Text-Balanced, perl-Text-Tabs+Wrap, perl-Text-Template,  perl-Types-Serialiser, perl-Unicode-Collate,  perl-Unicode-EastAsianWidth, perl-Unicode-LineBreak,  perl-Unicode-Normalize, perl-Unicode-UTF8, perl-Unix-Syslog, perl-utils, perl-Variable-Magic, perl-YAML-LibYAML, php-dbg, php-gmp, php-json,  php-opcache, php-pecl-apcu, php-pecl-apcu-devel, php-pecl-zip, pigz,  pinentry-emacs, pinentry-gnome3, pipewire, pipewire-devel, pipewire-doc, pipewire-libs, pipewire-utils, pkgconf, pkgconf-m4, pkgconf-pkg-config, pki-servlet-4.0-api, pki-servlet-container, platform-python,  platform-python-coverage, platform-python-debug, platform-python-devel,  platform-python-pip, platform-python-setuptools,  plexus-interactivity-api, plexus-interactivity-jline, plexus-languages,  plexus-languages-javadoc, plotutils, plotutils-devel, pmix, pmreorder,  podman, podman-docker, policycoreutils-dbus,  policycoreutils-python-utils, polkit-libs, poppler-qt5,  poppler-qt5-devel, postfix-mysql, postfix-pgsql, postgresql-odbc-tests,  postgresql-plpython3, postgresql-server-devel,  postgresql-test-rpm-macros, postgresql-upgrade-devel, potrace,  powermock-api-easymock, powermock-api-mockito, powermock-api-support,  powermock-common, powermock-core, powermock-javadoc, powermock-junit4,  powermock-reflect, powermock-testng, prefixdevname, pstoedit,  ptscotch-mpich, ptscotch-mpich-devel, ptscotch-mpich-devel-parmetis,  ptscotch-openmpi, ptscotch-openmpi-devel, publicsuffix-list,  publicsuffix-list-dafsa, python-pymongo-doc, python-qt5-rpm-macros,  python-sphinx-locale, python-sqlalchemy-doc, python-virtualenv-doc,  python2, python2-attrs, python2-babel, python2-backports,  python2-backports-ssl_match_hostname, python2-bson, python2-cairo,  python2-cairo-devel, python2-chardet, python2-coverage, python2-Cython,  python2-debug, python2-devel, python2-dns, python2-docs,  python2-docs-info, python2-docutils, python2-funcsigs, python2-idna,  python2-ipaddress, python2-iso8601, python2-jinja2, python2-libs,  python2-lxml, python2-markupsafe, python2-mock, python2-nose,  python2-numpy, python2-numpy-doc, python2-numpy-f2py, python2-pip,  python2-pluggy, python2-psycopg2, python2-psycopg2-debug,  python2-psycopg2-tests, python2-py, python2-pygments, python2-pymongo,  python2-pymongo-gridfs, python2-PyMySQL, python2-pysocks,  python2-pytest, python2-pytest-mock, python2-pytz, python2-pyyaml,  python2-requests, python2-scipy, python2-scour, python2-setuptools,  python2-setuptools_scm, python2-six, python2-sqlalchemy, python2-talloc, python2-test, python2-tkinter, python2-tools, python2-urllib3,  python2-virtualenv, python2-wheel, python3-abrt, python3-abrt-addon,  python3-abrt-container-addon, python3-abrt-doc, python3-argcomplete,  python3-argh, python3-asn1crypto, python3-attrs, python3-audit,  python3-augeas, python3-avahi, python3-azure-sdk, python3-babel,  python3-bcc, python3-bind, python3-blivet, python3-blockdev,  python3-boom, python3-boto3, python3-botocore, python3-brlapi,  python3-bson, python3-bytesize, python3-cairo, python3-cffi,  python3-chardet, python3-click, python3-clufter, python3-configobj,  python3-configshell, python3-cpio, python3-createrepo_c,  python3-cryptography, python3-cups, python3-custodia, python3-Cython,  python3-dateutil, python3-dbus, python3-dbus-client-gen,  python3-dbus-python-client-gen, python3-dbus-signature-pyparsing,  python3-decorator, python3-dmidecode, python3-dnf,  python3-dnf-plugin-spacewalk, python3-dnf-plugin-versionlock,  python3-dnf-plugins-core, python3-dns, python3-docs, python3-docutils,  python3-enchant, python3-ethtool, python3-evdev, python3-fasteners,  python3-firewall, python3-flask, python3-gevent, python3-gflags,  python3-gobject, python3-gobject-base, python3-google-api-client,  python3-gpg, python3-greenlet, python3-greenlet-devel, python3-gssapi,  python3-hawkey, python3-hivex, python3-html5lib, python3-httplib2,  python3-humanize, python3-hwdata, python3-hypothesis, python3-idna,  python3-imagesize, python3-iniparse, python3-inotify,  python3-into-dbus-python, python3-ipaclient, python3-ipalib,  python3-ipaserver, python3-iscsi-initiator-utils, python3-iso8601,  python3-itsdangerous, python3-jabberpy, python3-javapackages,  python3-jinja2, python3-jmespath, python3-jsonpatch,  python3-jsonpointer, python3-jsonschema, python3-justbases,  python3-justbytes, python3-jwcrypto, python3-jwt, python3-kdcproxy,  python3-keycloak-httpd-client-install, python3-kickstart, python3-kmod,  python3-koan, python3-langtable, python3-ldap, python3-ldb,  python3-lesscpy, python3-lib389, python3-libcomps, python3-libdnf,  python3-libguestfs, python3-libipa_hbac, python3-libnl3, python3-libpfm, python3-libproxy, python3-librepo, python3-libreport,  python3-libselinux, python3-libsemanage, python3-libsss_nss_idmap,  python3-libstoragemgmt, python3-libstoragemgmt-clibs, python3-libuser,  python3-libvirt, python3-libvoikko, python3-libxml2,  python3-linux-procfs, python3-lit, python3-lldb, python3-louis,  python3-lxml, python3-magic, python3-mako, python3-markdown,  python3-markupsafe, python3-meh, python3-meh-gui, python3-mock,  python3-mod_wsgi, python3-mpich, python3-netaddr, python3-netifaces,  python3-newt, python3-nose, python3-nss, python3-ntplib, python3-numpy,  python3-numpy-f2py, python3-oauth2client, python3-oauthlib,  python3-openipmi, python3-openmpi, python3-ordered-set,  python3-osa-common, python3-osad, python3-packaging, python3-pcp,  python3-perf, python3-pexpect, python3-pid, python3-pillow, python3-pki, python3-pluggy, python3-ply, python3-policycoreutils,  python3-prettytable, python3-productmd, python3-psycopg2,  python3-ptyprocess, python3-pwquality, python3-py, python3-pyasn1,  python3-pyasn1-modules, python3-pyatspi, python3-pycparser,  python3-pycurl, python3-pydbus, python3-pygments, python3-pymongo,  python3-pymongo-gridfs, python3-PyMySQL, python3-pyOpenSSL,  python3-pyparsing, python3-pyparted, python3-pyqt5-sip,  python3-pyserial, python3-pysocks, python3-pytest, python3-pytoml,  python3-pytz, python3-pyudev, python3-pyusb, python3-pywbem,  python3-pyxattr, python3-pyxdg, python3-pyyaml, python3-qrcode,  python3-qrcode-core, python3-qt5, python3-qt5-base, python3-qt5-devel,  python3-reportlab, python3-requests, python3-requests-file,  python3-requests-ftp, python3-requests-oauthlib, python3-rhn-check,  python3-rhn-client-tools, python3-rhn-setup, python3-rhn-setup-gnome,  python3-rhn-virtualization-common, python3-rhn-virtualization-host,  python3-rhncfg, python3-rhncfg-actions, python3-rhncfg-client,  python3-rhncfg-management, python3-rhnlib, python3-rhnpush, python3-rpm, python3-rrdtool, python3-rtslib, python3-s3transfer, python3-samba,  python3-samba-test, python3-schedutils, python3-scipy, python3-scons,  python3-semantic_version, python3-setools, python3-setuptools_scm,  python3-simpleline, python3-sip, python3-sip-devel, python3-six,  python3-slip, python3-slip-dbus, python3-snowballstemmer,  python3-spacewalk-abrt, python3-spacewalk-backend-libs,  python3-spacewalk-koan, python3-spacewalk-oscap, python3-spacewalk-usix, python3-speechd, python3-sphinx, python3-sphinx_rtd_theme,  python3-sphinx-theme-alabaster, python3-sphinxcontrib-websupport,  python3-sqlalchemy, python3-sss, python3-sss-murmur, python3-sssdconfig, python3-subscription-manager-rhsm, python3-suds, python3-sure,  python3-sushy, python3-syspurpose, python3-systemd, python3-talloc,  python3-tbb, python3-tdb, python3-tevent, python3-unbound,  python3-unittest2, python3-uritemplate, python3-urllib3, python3-urwid,  python3-varlink, python3-virtualenv, python3-webencodings,  python3-werkzeug, python3-whoosh, python3-yubico, python36,  python36-debug, python36-devel, python36-rpm-macros` 			

​					**Q** | `qemu-kvm-block-curl, qemu-kvm-block-gluster, qemu-kvm-block-iscsi, qemu-kvm-block-rbd,  qemu-kvm-block-ssh, qemu-kvm-core, qemu-kvm-tests, qgpgme, qhull-devel,  qt5-devel, qt5-srpm-macros, quota-rpc` 			

​					**R** | `re2c, readonly-root, redhat-backgrounds, redhat-logos-httpd,  redhat-logos-ipa, redhat-release, redis, redis-devel, redis-doc,  resteasy, resteasy-javadoc, rhel-system-roles, rhn-custom-info,  rhn-virtualization-host, rhncfg, rhncfg-actions, rhncfg-client,  rhncfg-management, rhnpush, rls, rpcgen, rpcsvc-proto-devel,  rpm-mpi-hooks, rpm-ostree, rpm-ostree-libs, rpm-plugin-ima,  rpm-plugin-prioreset, rpm-plugin-selinux, rpm-plugin-syslog,  rsync-daemon, rubygem-bson, rubygem-bson-doc, rubygem-did_you_mean,  rubygem-diff-lcs, rubygem-mongo, rubygem-mongo-doc, rubygem-mysql2,  rubygem-mysql2-doc, rubygem-net-telnet, rubygem-openssl, rubygem-pg,  rubygem-pg-doc, rubygem-power_assert, rubygem-rspec, rubygem-rspec-core, rubygem-rspec-expectations, rubygem-rspec-mocks, rubygem-rspec-support, rubygem-test-unit, rubygem-xmlrpc, runc, rust, rust-analysis,  rust-debugger-common, rust-doc, rust-gdb, rust-lldb, rust-src,  rust-srpm-macros, rust-std-static, rust-toolset, rustfmt` 			

​					**S** | `samyak-odia-fonts, sane-backends-daemon, sblim-sfcCommon, scala, scala-apidoc,  scala-swing, scotch, scotch-devel, SDL2, SDL2-devel, SDL2-static,  sendmail-milter-devel, sil-scheherazade-fonts, sisu-mojos,  sisu-mojos-javadoc, skopeo, slf4j-ext, slf4j-jcl, slf4j-jdk14,  slf4j-log4j12, slf4j-sources, slirp4netns, smc-tools, socket_wrapper,  sombok, sombok-devel, sos-audit, spacewalk-abrt, spacewalk-client-cert,  spacewalk-koan, spacewalk-oscap, spacewalk-remote-utils, spacewalk-usix, sparsehash-devel, spec-version-maven-plugin,  spec-version-maven-plugin-javadoc, speech-dispatcher-espeak-ng,  speexdsp, speexdsp-devel, spice-gtk, spirv-tools-libs, splix,  sqlite-libs, sscg, sssd-nfs-idmap, stratis-cli, stratisd, SuperLU,  SuperLU-devel, supermin-devel, swig-gdb, switcheroo-control,  syslinux-extlinux-nonlinux, syslinux-nonlinux, systemd-container,  systemd-journal-remote, systemd-pam, systemd-tests, systemd-udev,  systemtap-exporter, systemtap-runtime-python3` 			

​					**T** | `target-restore, tcl-doc, texlive-anyfontsize, texlive-awesomebox,  texlive-babel-english, texlive-breqn, texlive-capt-of,  texlive-classpack, texlive-ctablestack, texlive-dvisvgm,  texlive-environ, texlive-eqparbox, texlive-finstrut,  texlive-fontawesome, texlive-fonts-tlwg, texlive-graphics-cfg,  texlive-graphics-def, texlive-import, texlive-knuth-lib,  texlive-knuth-local, texlive-latex2man, texlive-lib, texlive-lib-devel,  texlive-linegoal, texlive-lineno, texlive-ltabptch, texlive-lualibs,  texlive-luatex85, texlive-manfnt-font, texlive-mathtools,  texlive-mflogo-font, texlive-needspace, texlive-tabu, texlive-tabulary,  texlive-tex-ini-files, texlive-texlive-common-doc,  texlive-texlive-docindex, texlive-texlive-en,  texlive-texlive-msg-translations, texlive-texlive-scripts,  texlive-trimspaces, texlive-unicode-data, texlive-updmap-map,  texlive-upquote, texlive-wasy2-ps, texlive-xmltexconfig,  thai-scalable-laksaman-fonts, timedatex, tinycdb, tinycdb-devel,  tinyxml2, tinyxml2-devel, tlog, torque, torque-devel, torque-libs,  tpm2-abrmd-selinux, tracker-miners, trousers-lib,  tuned-profiles-nfv-host-bin, twolame-libs` 			

​					**U** | `uglify-js, uid_wrapper, usbguard-dbus, userspace-rcu, userspace-rcu-devel, utf8proc, uthash-devel, util-linux-user` 			

​					**V** | `varnish, varnish-devel, varnish-docs, varnish-modules, vulkan-headers, vulkan-loader, vulkan-loader-devel` 			

​					**W** | `WALinuxAgent, web-assets-devel, web-assets-filesystem, webkit2gtk3,  webkit2gtk3-devel, webkit2gtk3-jsc, webkit2gtk3-jsc-devel,  webkit2gtk3-plugin-process-gtk2, wireshark-cli, woff2` 			

​					**X** | `Xaw3d, Xaw3d-devel, xmlstreambuffer, xmlstreambuffer-javadoc, xmvn-api,  xmvn-bisect, xmvn-connector-aether, xmvn-connector-ivy, xmvn-core,  xmvn-install, xmvn-minimal, xmvn-mojo, xmvn-parent-pom, xmvn-resolve,  xmvn-subst, xmvn-tools-pom, xorg-x11-drv-wacom-serial-support,  xterm-resize` 			

​					**Y** | `yasm` 			

## A.2. 软件包替换

​				下表列出了被替换、重命名、合并或者分割的软件包： 		

| 原始软件包                                                   | 新软件包                                                     | 修改自   | 备注                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | ------------------------------------------------------------ |
| 389-ds-base                                                  | 389-ds-base, 389-ds-base-legacy-tools                        | RHEL 8.0 | RHEL 7 中的 `389-ds-base` 软件包包含操作目录服务器的 Perl Tools。在 RHEL 8 中,使用 Python 编写的新工具集合会在 `389-ds-base` 软件包中发布。旧的 Perl Tools 已提取到一个单独的软件包 `389-ds-base-legacy-tools`,但已被弃用且不推荐使用。 |
| AAVMF                                                        | edk2-aarch64                                                 | RHEL 8.0 |                                                              |
| abrt-addon-python                                            | python3-abrt-addon                                           | RHEL 8.0 |                                                              |
| abrt-python                                                  | python3-abrt                                                 | RHEL 8.0 |                                                              |
| abrt-python-doc                                              | python3-abrt-doc                                             | RHEL 8.0 |                                                              |
| adcli                                                        | adcli, adcli-doc                                             | RHEL 8.0 |                                                              |
| adwaita-qt5                                                  | adwaita-qt                                                   | RHEL 8.0 |                                                              |
| alsa-utils                                                   | alsa-utils, alsa-utils-alsabat                               | RHEL 8.0 |                                                              |
| anaconda-core                                                | anaconda-core, anaconda-install-env-deps                     | RHEL 8.0 |                                                              |
| apache-commons-collections-testframework-javadoc             | apache-commons-collections-javadoc                           | RHEL 8.0 |                                                              |
| apr-util                                                     | apr-util, apr-util-bdb, apr-util-openssl                     | RHEL 8.0 | `apr-util-bdb` 和 `apr-util-openssl` 软件包已从 `apr-util` 中分离。这些软件包在 `apr_dbm.h` 接口中提供支持 Berkeley DB 和 `apr_crypto.h` 接口中的 OpenSSL 的可加载模块。`apr-util-bdb` 和 `apr-util-openssl` 软件包都来自 `apr-util`,因此使用这些 API 的软件包可以在无需更改的情况下继续工作。 |
| aqute-bndlib-javadoc                                         | aqute-bnd-javadoc                                            | RHEL 8.0 |                                                              |
| arptables                                                    | iptables-arptables                                           | RHEL 8.0 |                                                              |
| authconfig                                                   | authselect-compat                                            | RHEL 8.0 | `authselect` 工具改进了 RHEL 8 主机上的用户身份验证配置,它是配置操作系统 PAM 堆栈的唯一方法。为简化从 `authconfig` 的迁移, `authselect-compat` 软件包由对应的兼容性命令提供。 |
| bacula-director                                              | bacula-director、bacula-logwatch                             | RHEL 8.0 |                                                              |
| bind-libs-lite                                               | bind-export-libs, bind-libs-lite                             | RHEL 8.0 | `bind-libs-lite` 库已移至 `bind-export-libs` 软件包,供 `dhcp-client` 和 `dhcp-server` 软件包使用。`bind-libs-lite` 库现在包含 `bind-libs` 的子集,它依赖于 `bind-libs-lite` 软件包。`dhcp-server` 和 `dhcp-client` 现在依赖于 `bind-export-libs` 软件包。 |
| bind-lite-devel                                              | bind-export-devel, bind-lite-devel                           | RHEL 8.0 | `bind-export-devel` 软件包提供了 `bind-lite-devel` 软件包的替换。应该从 `isc-export-config.sh` 输出中获得用于链接到导出库的 cflags 和库。应该使用 `isc-export-config.sh` 参数来针对 `bind-export-libs` 库进行连接。 |
| bluez                                                        | bluez, bluez-obexd                                           | RHEL 8.0 |                                                              |
| boost-devel                                                  | boost-devel, boost-python3-devel                             | RHEL 8.0 |                                                              |
| boost-mpich-python                                           | boost-mpich-python3                                          | RHEL 8.0 |                                                              |
| boost-openmpi-python                                         | boost-openmpi-python3                                        | RHEL 8.0 |                                                              |
| boost-python                                                 | boost-python3                                                | RHEL 8.0 |                                                              |
| brltty-at-spi                                                | brltty-at-spi2                                               | RHEL 8.0 |                                                              |
| cjkuni-uming-fonts                                           | google-noto-serif-cjk-ttc-fonts                              | RHEL 8.0 |                                                              |
| cockpit-docker                                               | cockpit-podman (container-tools:1.0)                         | RHEL 8.0 |                                                              |
| compat-libgfortran-41                                        | compat-libgfortran-48                                        | RHEL 8.0 |                                                              |
| compat-locales-sap                                           | compat-locales-sap, compat-locales-sap-common                | RHEL 8.1 |                                                              |
| compat-locales-sap, compat-locales-sap-common                | compat-locales-sap                                           | RHEL 8.0 |                                                              |
| control-center                                               | gnome-control-center                                         | RHEL 8.0 |                                                              |
| control-center-filesystem                                    | gnome-control-center-filesystem                              | RHEL 8.0 |                                                              |
| coolkey                                                      | opensc                                                       | RHEL 8.0 |                                                              |
| coreutils                                                    | coreutils, coreutils-common                                  | RHEL 8.0 |                                                              |
| createrepo                                                   | createrepo_c, python3-createrepo_c                           | RHEL 8.0 |                                                              |
| Cython                                                       | python2-Cython, python3-Cython                               | RHEL 8.0 |                                                              |
| dbus                                                         | dbus, dbus-common, dbus-daemon, dbus-tools                   | RHEL 8.0 |                                                              |
| dbus-python                                                  | python3-dbus                                                 | RHEL 8.0 |                                                              |
| deltarpm                                                     | drpm                                                         | RHEL 8.0 |                                                              |
| dhclient                                                     | dhcp-client                                                  | RHEL 8.0 |                                                              |
| dhcp                                                         | dhcp-relay, dhcp-server                                      | RHEL 8.0 |                                                              |
| dnf-utils                                                    | yum-utils                                                    | RHEL 8.1 |                                                              |
| dnssec-trigger                                               | DNSSEC-trigger, dnssec-trigger-panel                         | RHEL 8.0 |                                                              |
| dracut                                                       | dracut, dracut-live, dracut-squash                           | RHEL 8.0 |                                                              |
| dstat                                                        | pcp-system-tools                                             | RHEL 8.0 |                                                              |
| easymock2                                                    | easymock                                                     | RHEL 8.0 |                                                              |
| easymock2-javadoc                                            | easymock-javadoc                                             | RHEL 8.0 |                                                              |
| ebtables                                                     | iptables-ebtables                                            | RHEL 8.0 |                                                              |
| edac-utils                                                   | rasdaemon                                                    | RHEL 8.0 |                                                              |
| emacs-common, emacs-el                                       | emacs-common                                                 | RHEL 8.0 |                                                              |
| emacs-libidn, libidn                                         | libidn                                                       | RHEL 8.0 |                                                              |
| emacs-mercurial, emacs-mercurial-el, mercurial               | mercurial                                                    | RHEL 8.0 |                                                              |
| espeak                                                       | espeak-ng                                                    | RHEL 8.0 | `espeak` 软件包（为发音引擎提供后端）已被一个活跃开发的 `espeak-ng` 软件包所替代。`espeak-ng` 主要与 `espeak` 兼容。 |
| firstboot                                                    | gnome-initial-setup                                          | RHEL 8.0 |                                                              |
| foomatic-filters                                             | cups-filters                                                 | RHEL 8.0 |                                                              |
| freerdp                                                      | freerdp, libwinpr                                            | RHEL 8.0 |                                                              |
| freerdp-devel                                                | freerdp-devel, libwinpr-devel                                | RHEL 8.0 |                                                              |
| freerdp-libs, freerdp-plugins                                | freerdp-libs                                                 | RHEL 8.0 |                                                              |
| fuse                                                         | fuse, fuse-common                                            | RHEL 8.0 |                                                              |
| gdb                                                          | gdb, gdb-headless                                            | RHEL 8.0 |                                                              |
| gdbm                                                         | gdbm, gdbm-libs                                              | RHEL 8.0 |                                                              |
| gdk-pixbuf2                                                  | gdk-pixbuf2, gdk-pixbuf2-modules, gdk-pixbuf2-xlib           | RHEL 8.0 |                                                              |
| gdk-pixbuf2-devel                                            | gdk-pixbuf2-devel, gdk-pixbuf2-xlib-devel                    | RHEL 8.0 |                                                              |
| gdm, pulseaudio-gdm-hooks                                    | gdm                                                          | RHEL 8.0 |                                                              |
| ghostscript                                                  | ghostscript, libgs, libijs                                   | RHEL 8.0 |                                                              |
| ghostscript-devel                                            | libgs-devel                                                  | RHEL 8.0 |                                                              |
| ghostscript-fonts                                            | urw-base35-fonts                                             | RHEL 8.0 |                                                              |
| git                                                          | git, git-core, git-core-doc, git-subtree                     | RHEL 8.0 |                                                              |
| glassfish-el-api-javadoc                                     | glassfish-el-javadoc                                         | RHEL 8.0 |                                                              |
| glassfish-fastinfoset                                        | glassfish-fastinfoset, glassfish-fastinfoset-javadoc         | RHEL 8.0 |                                                              |
| glassfish-jaxb                                               | glassfish-jaxb-bom, glassfish-jaxb-bom-ext,  glassfish-jaxb-codemodel, glassfish-jaxb-codemodel-annotation-compiler,  glassfish-jaxb-codemodel-parent, glassfish-jaxb-core,  glassfish-jaxb-external-parent, glassfish-jaxb-parent,  glassfish-jaxb-rngom, glassfish-jaxb-runtime,  glassfish-jaxb-runtime-parent, glassfish-jaxb-txw-parent,  glassfish-jaxb-txw2 | RHEL 8.0 |                                                              |
| glassfish-jaxb-api                                           | glassfish-jaxb-api, glassfish-jaxb-api-javadoc               | RHEL 8.0 |                                                              |
| glibc                                                        | glibc, glibc-all-langpacks, glibc-locale-source, glibc-minimal-langpack, libnsl, libxcrypt, nss_db | RHEL 8.0 | NIS 和其他数据源的非内核 NSS 模块已被分成独立的软件包（`nss_db`、`libnsl`）。语言支持已被分成语言软件包支持（`glibc-all-langpacks`、`glibc-minimal-langpack`、`glibc-locale-source` 和 `glibc-langpack-*` 模块）。`libxcrypt` 软件包不同。 |
| glibc-common                                                 | glibc-common, rpcgen                                         | RHEL 8.0 |                                                              |
| glibc-devel                                                  | compat-libpthread-nonshared, glibc-devel, libnsl2-devel, libxcrypt-devel | RHEL 8.0 |                                                              |
| glibc-headers                                                | glibc-headers, rpcsvc-proto-devel                            | RHEL 8.0 |                                                              |
| glibc-static                                                 | glibc-static, libxcrypt-static                               | RHEL 8.0 |                                                              |
| gmp                                                          | gmp, gmp-c++                                                 | RHEL 8.0 |                                                              |
| gnome-backgrounds                                            | gnome-backgrounds, gnome-backgrounds-extras                  | RHEL 8.0 |                                                              |
| gnome-session, gnome-session-custom-session                  | gnome-session                                                | RHEL 8.0 |                                                              |
| gnome-system-log                                             | gnome-logs                                                   | RHEL 8.0 |                                                              |
| gnome-tweak-tool                                             | gnome-tweaks                                                 | RHEL 8.0 |                                                              |
| golang                                                       | go-srpm-macros, golang                                       | RHEL 8.0 |                                                              |
| google-noto-sans-cjk-fonts                                   | google-noto-sans-cjk-ttc-fonts                               | RHEL 8.0 |                                                              |
| google-noto-sans-japanese-fonts                              | google-noto-sans-cjk-jp-fonts                                | RHEL 8.0 |                                                              |
| grub2-common                                                 | efi-filesystem, grub2-common                                 | RHEL 8.0 |                                                              |
| grub2-tools                                                  | grub2-tools, grub2-tools-efi                                 | RHEL 8.0 |                                                              |
| gstreamer1-plugins-bad-free-gtk                              | gstreamer1-plugins-good-gtk                                  | RHEL 8.0 |                                                              |
| guava                                                        | guava20                                                      | RHEL 8.0 |                                                              |
| guava-javadoc                                                | guava20-javadoc                                              | RHEL 8.0 |                                                              |
| gutenprint                                                   | gutenprint, gutenprint-libs, gutenprint-libs-ui              | RHEL 8.0 |                                                              |
| hawkey, libhif                                               | libdnf                                                       | RHEL 8.0 |                                                              |
| hmaccalc                                                     | libkcapi-hmaccalc                                            | RHEL 8.0 |                                                              |
| hpijs                                                        | hplip                                                        | RHEL 8.0 |                                                              |
| i2c-tools                                                    | i2c-tools, i2c-tools-perl                                    | RHEL 8.0 |                                                              |
| ibus-chewing                                                 | ibus-libzhuyin                                               | RHEL 8.0 |                                                              |
| infiniband-diags, libibmad                                   | infiniband-diags                                             | RHEL 8.0 |                                                              |
| infiniband-diags-devel, libibmad-devel                       | infiniband-diags-devel                                       | RHEL 8.0 |                                                              |
| infiniband-diags-devel-static, libibmad-static               | infiniband-diags-devel-static                                | RHEL 8.0 |                                                              |
| initscripts                                                  | initscripts、netconsole-service、network-scripts、readonly-root | RHEL 8.0 |                                                              |
| ipmitool                                                     | ipmievd, ipmitool                                            | RHEL 8.0 |                                                              |
| iproute                                                      | iproute, iproute-tc                                          | RHEL 8.0 |                                                              |
| iptables                                                     | iptables, iptables-libs                                      | RHEL 8.0 |                                                              |
| iscsi-initiator-utils                                        | iscsi-initiator-utils, python3-iscsi-initiator-utils         | RHEL 8.0 |                                                              |
| istack-commons                                               | istack-commons、istack-commons-runtime、istack-commons-tools | RHEL 8.0 |                                                              |
| ivtv-firmware, linux-firmware                                | linux-firmware                                               | RHEL 8.0 |                                                              |
| iwl7260-firmware, iwl7265-firmware                           | iwl7260-firmware                                             | RHEL 8.0 |                                                              |
| jabberpy                                                     | python3-jabberpy                                             | RHEL 8.0 |                                                              |
| Jackson                                                      | jackson-annotations, jackson-core, jackson-databind,  jackson-jaxrs-json-provider, jackson-jaxrs-providers,  jackson-jaxrs-providers-datatypes, jackson-module-jaxb-annotations | RHEL 8.0 |                                                              |
| jackson-javadoc                                              | jackson-annotations-javadoc, jackson-core-javadoc,  jackson-databind-javadoc, jackson-jaxrs-providers-javadoc,  jackson-module-jaxb-annotations-javadoc | RHEL 8.0 |                                                              |
| javapackages-tools                                           | ivy-local, javapackages-filesystem, javapackages-tools       | RHEL 8.0 |                                                              |
| jboss-annotations-1.1-api                                    | jboss-annotations-1.2-api                                    | RHEL 8.0 |                                                              |
| jboss-interceptors-1.1-api                                   | jboss-interceptors-1.2-api                                   | RHEL 8.0 |                                                              |
| jboss-interceptors-1.1-api-javadoc                           | jboss-interceptors-1.2-api-javadoc                           | RHEL 8.0 |                                                              |
| joda-time                                                    | Java-1.8.0-openjdk-headless                                  | RHEL 8.0 |                                                              |
| joda-time-javadoc                                            | java-1.8.0-openjdk-javadoc                                   | RHEL 8.0 |                                                              |
| kernel                                                       | kernel, kernel-core, kernel-modules, kernel-modules-extra    | RHEL 8.0 |                                                              |
| kernel-debug                                                 | kernel-debug、kernel-debug-core、kernel-debug-modules、kernel-debug-modules-extra | RHEL 8.0 |                                                              |
| kernel-rt                                                    | kernel-rt, kernel-rt-core, kernel-rt-modules, kernel-rt-modules-extra | RHEL 8.0 |                                                              |
| kernel-rt-debug                                              | kernel-rt-debug、kernel-rt-debug-core、kernel-rt-debug-modules、kernel-rt-debug-modules-extra | RHEL 8.0 |                                                              |
| kernel-tools, qemu-kvm-tools                                 | kernel-tools                                                 | RHEL 8.0 |                                                              |
| kexec-tools, kexec-tools-eppic                               | kexec-tools                                                  | RHEL 8.0 |                                                              |
| kexec-tools-anaconda-addon                                   | kdump-anaconda-addon                                         | RHEL 8.0 |                                                              |
| koan                                                         | koan, python3-koan                                           | RHEL 8.0 |                                                              |
| langtable-python                                             | python3-langtable                                            | RHEL 8.0 |                                                              |
| ldns                                                         | ldns, ldns-utils                                             | RHEL 8.0 |                                                              |
| libgnome-keyring                                             | libsecret                                                    | RHEL 8.0 |                                                              |
| libgudev1                                                    | libgudev                                                     | RHEL 8.0 |                                                              |
| libgudev1-devel                                              | libgudev-devel                                               | RHEL 8.0 |                                                              |
| libinput                                                     | libinput, libinput-utils                                     | RHEL 8.0 |                                                              |
| liblouis-python                                              | python3-louis                                                | RHEL 8.0 |                                                              |
| libmemcached                                                 | libmemcached, libmemcached-libs                              | RHEL 8.0 |                                                              |
| libmodulemd                                                  | libmodulemd, libmodulemd1                                    | RHEL 8.0 |                                                              |
| libmusicbrainz                                               | libmusicbrainz5                                              | RHEL 8.0 |                                                              |
| libmusicbrainz-devel                                         | libmusicbrainz5-devel                                        | RHEL 8.0 |                                                              |
| libnice                                                      | libnice, libnice-gstreamer1                                  | RHEL 8.0 |                                                              |
| libpeas-loader-python                                        | libpeas-loader-python3                                       | RHEL 8.0 |                                                              |
| libpfm-python                                                | python3-libpfm                                               | RHEL 8.0 |                                                              |
| libproxy-mozjs                                               | libproxy-webkitgtk4                                          | RHEL 8.0 |                                                              |
| libproxy-python                                              | python3-libproxy                                             | RHEL 8.0 |                                                              |
| libproxy-webkitgtk3                                          | libproxy-webkitgtk4                                          | RHEL 8.0 |                                                              |
| librabbitmq-examples                                         | librabbitmq-tools                                            | RHEL 8.0 |                                                              |
| librados2-devel                                              | librados-devel                                               | RHEL 8.0 |                                                              |
| librbd1-devel                                                | librbd-devel                                                 | RHEL 8.0 |                                                              |
| libreoffice-base                                             | libreoffice-base, libreoffice-help-en                        | RHEL 8.0 |                                                              |
| libreoffice-calc                                             | libreoffice-calc, libreoffice-help-en                        | RHEL 8.0 |                                                              |
| libreoffice-core                                             | libreoffice-core, libreoffice-help-en                        | RHEL 8.0 |                                                              |
| libreoffice-draw                                             | libreoffice-draw、libreoffice-help-en                        | RHEL 8.0 |                                                              |
| libreoffice-gtk2                                             | libreoffice-gtk3                                             | RHEL 8.3 |                                                              |
| libreoffice-impress                                          | libreoffice-help-en, libreoffice-impress                     | RHEL 8.0 |                                                              |
| libreoffice-math                                             | libreoffice-help-en, libreoffice-math                        | RHEL 8.0 |                                                              |
| libreoffice-writer                                           | libreoffice-help-en, libreoffice-writer                      | RHEL 8.0 |                                                              |
| libreport-python                                             | python3-libreport                                            | RHEL 8.0 |                                                              |
| libselinux-python                                            | python3-libselinux                                           | RHEL 8.0 |                                                              |
| libselinux-python3                                           | python3-libselinux                                           | RHEL 8.0 |                                                              |
| libsemanage-python                                           | python3-libsemanage                                          | RHEL 8.0 |                                                              |
| libssh2                                                      | libssh, libssh2                                              | RHEL 8.0 | 由于依赖 `qemu-kvm`, `libssh2` 软件包在 RHEL 8.0 中临时可用。从 RHEL 8.1 开始,QEMU 模拟器使用 `libssh` 库, `libssh2` 已被删除。 |
| libstoragemgmt-python                                        | python3-libstoragemgmt                                       | RHEL 8.0 |                                                              |
| libstoragemgmt-python-clibs                                  | python3-libstoragemgmt-clibs                                 | RHEL 8.0 |                                                              |
| libuser-python                                               | python3-libuser                                              | RHEL 8.0 |                                                              |
| libvirt-python                                               | python3-libvirt                                              | RHEL 8.0 |                                                              |
| libX11                                                       | libX11, libX11-xcb                                           | RHEL 8.0 |                                                              |
| libxml2-python                                               | python3-libxml2                                              | RHEL 8.0 |                                                              |
| llvm-private                                                 | llvm                                                         | RHEL 8.0 |                                                              |
| llvm-private-devel                                           | llvm-devel                                                   | RHEL 8.0 |                                                              |
| log4j                                                        | log4j12                                                      | RHEL 8.0 |                                                              |
| log4j-javadoc                                                | log4j12-javadoc                                              | RHEL 8.0 |                                                              |
| lohit-oriya-fonts                                            | lohit-odia-fonts                                             | RHEL 8.0 |                                                              |
| lohit-punjabi-fonts                                          | lohit-gurmukhi-fonts                                         | RHEL 8.0 |                                                              |
| lua                                                          | lua, lua-libs                                                | RHEL 8.0 |                                                              |
| lvm2-python-boom                                             | boom-boot, boom-boot-conf, boom-boot-grub2, python3-boom     | RHEL 8.0 |                                                              |
| lz4                                                          | lz4, lz4-libs                                                | RHEL 8.0 |                                                              |
| make                                                         | make, make-devel                                             | RHEL 8.0 |                                                              |
| mariadb-devel                                                | mariadb-connector-c-devel, mariadb-devel                     | RHEL 8.0 |                                                              |
| mariadb-libs                                                 | mariadb-connector-c                                          | RHEL 8.0 |                                                              |
| mariadb-server                                               | mariadb-server, mariadb-server-utils                         | RHEL 8.0 |                                                              |
| maven                                                        | maven, maven-lib                                             | RHEL 8.0 |                                                              |
| maven-downloader                                             | maven-artifact-transfer                                      | RHEL 8.0 |                                                              |
| maven-downloader-javadoc                                     | maven-artifact-transfer-javadoc                              | RHEL 8.0 |                                                              |
| maven-doxia-tools                                            | maven-doxia-sitetools                                        | RHEL 8.0 |                                                              |
| maven-doxia-tools-javadoc                                    | maven-doxia-sitetools-javadoc                                | RHEL 8.0 |                                                              |
| maven-local                                                  | javapackages-local, maven-local                              | RHEL 8.0 |                                                              |
| maven-wagon                                                  | maven-wagon, maven-wagon-file, maven-wagon-ftp,  maven-wagon-http, maven-wagon-http-lightweight, maven-wagon-http-shared, maven-wagon-provider-api, maven-wagon-providers | RHEL 8.0 |                                                              |
| mesa-libEGL-devel                                            | mesa-khr-devel, mesa-libEGL-devel                            | RHEL 8.0 |                                                              |
| mesa-libwayland-egl                                          | libwayland-egl                                               | RHEL 8.0 |                                                              |
| mesa-libwayland-egl-devel, wayland-devel                     | wayland-devel                                                | RHEL 8.0 |                                                              |
| mod_auth_kerb                                                | mod_auth_gssapi                                              | RHEL 8.0 |                                                              |
| mod_nss                                                      | mod_ssl                                                      | RHEL 8.0 |                                                              |
| mod_wsgi                                                     | python3-mod_wsgi                                             | RHEL 8.0 | Apache HTTP 服务器的 `mod_wsgi` 模块已更新为 Python 3。WSGI 应用程序现在只支持 Python 3,且必须从 Python 2 中迁移。 |
| mpich-3.0, mpich-3.2                                         | mpich                                                        | RHEL 8.0 |                                                              |
| mpich-3.0-devel, mpich-3.2-devel                             | mpich-devel                                                  | RHEL 8.0 |                                                              |
| mpitests-mpich, mpitests-mpich32                             | mpitests-mpich                                               | RHEL 8.0 |                                                              |
| mpitests-mvapich2, mpitests-mvapich222, mpitests-mvapich23   | mpitests-mvapich2                                            | RHEL 8.0 |                                                              |
| mpitests-mvapich2-psm, mpitests-mvapich222-psm,  mpitests-mvapich222-psm2, mpitests-mvapich23-psm,  mpitests-mvapich23-psm2 | mpitests-mvapich2-psm2                                       | RHEL 8.0 |                                                              |
| mpitests-openmpi, mpitests-openmpi3                          | mpitests-openmpi                                             | RHEL 8.0 |                                                              |
| mvapich2-2.0、mvapich2-2.2、mvapich23                        | mvapich2                                                     | RHEL 8.0 |                                                              |
| mvapich2-2.0-psm, mvapich2-2.2-psm, mvapich2-2.2-psm2, mvapich23-psm, mvapich23-psm2 | mvapich2-psm2                                                | RHEL 8.0 |                                                              |
| mysql-connector-java                                         | mariadb-java-client                                          | RHEL 8.0 |                                                              |
| mysql-connector-odbc                                         | mariadb-connector-odbc                                       | RHEL 8.0 |                                                              |
| MySQL-python                                                 | python2-PyMySQL, python3-PyMySQL                             | RHEL 8.0 |                                                              |
| nbdkit-plugin-python2                                        | nbdkit-plugin-python3                                        | RHEL 8.0 |                                                              |
| ncurses-libs                                                 | ncurses-c++-libs, ncurses-compat-libs, ncurses-libs          | RHEL 8.0 |                                                              |
| network-manager-applet                                       | libnma, network-manager-applet                               | RHEL 8.3 |                                                              |
| newt-python                                                  | python3-newt                                                 | RHEL 8.0 |                                                              |
| nextgen-yum4                                                 | yum                                                          | RHEL 8.0 |                                                              |
| nhn-nanum-gothic-fonts                                       | google-noto-sans-cjk-ttc-fonts                               | RHEL 8.0 |                                                              |
| ntp                                                          | chrony, ntpstat                                              | RHEL 8.0 | 详情请查看 [使用 Chrony 来配置 NTP](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/using-chrony-to-configure-ntp)。 |
| ntpdate                                                      | chrony                                                       | RHEL 8.0 |                                                              |
| numpy                                                        | python2-numpy, python3-numpy                                 | RHEL 8.0 |                                                              |
| numpy-f2py                                                   | python2-numpy-f2py, python3-numpy-f2py                       | RHEL 8.0 |                                                              |
| objectweb-asm4                                               | objectweb-asm                                                | RHEL 8.0 |                                                              |
| objectweb-asm4-javadoc                                       | objectweb-asm-javadoc                                        | RHEL 8.0 |                                                              |
| opencv                                                       | opencv, opencv-contrib, opencv-core                          | RHEL 8.0 |                                                              |
| OpenIPMI                                                     | OpenIPMI、OpenIPMI-lanserv                                   | RHEL 8.0 |                                                              |
| OpenIPMI-python                                              | python3-openipmi                                             | RHEL 8.0 |                                                              |
| openjpeg                                                     | openjpeg2                                                    | RHEL 8.0 |                                                              |
| openjpeg-devel                                               | openjpeg2-devel                                              | RHEL 8.0 |                                                              |
| openmpi, openmpi3                                            | openmpi                                                      | RHEL 8.0 |                                                              |
| openmpi-devel, openmpi3-devel                                | openmpi-devel                                                | RHEL 8.0 |                                                              |
| openscap, openscap-extra-probes                              | openscap                                                     | RHEL 8.0 |                                                              |
| openscap-python                                              | openscap-python3                                             | RHEL 8.0 |                                                              |
| openwsman-python                                             | openwsman-python3                                            | RHEL 8.0 |                                                              |
| oprofile                                                     | perf                                                         | RHEL 8.0 |                                                              |
| osa-common                                                   | python3-osa-common                                           | RHEL 8.0 |                                                              |
| osad                                                         | osad, python3-osad                                           | RHEL 8.0 |                                                              |
| ostree                                                       | ostree, ostree-libs                                          | RHEL 8.0 |                                                              |
| ostree-fuse                                                  | ostree                                                       | RHEL 8.0 |                                                              |
| OVMF                                                         | edk2-ovmf                                                    | RHEL 8.0 |                                                              |
| p11-kit-doc                                                  | p11-kit-devel                                                | RHEL 8.0 |                                                              |
| pacemaker-cli                                                | pacemaker-cli, pacemaker-schemas                             | RHEL 8.0 |                                                              |
| PackageKit, PackageKit-yum                                   | PackageKit                                                   | RHEL 8.0 |                                                              |
| pam_krb5                                                     | SSSD                                                         | RHEL 8.0 | 有关从 pam_krb5 迁移到 ssd 的详情,请参考上游 SSSD 文档中的 [从 pam_krb5 迁移到 sssd](https://docs.pagure.org/SSSD.sssd/users/pam_krb5_migration.html)。 |
| pam_pkcs11                                                   | SSSD                                                         | RHEL 8.0 |                                                              |
| papi                                                         | papi, papi-libs                                              | RHEL 8.0 |                                                              |
| parfait                                                      | parfait, parfait-examples, parfait-javadoc, pcp-parfait-agent | RHEL 8.0 |                                                              |
| pcp-pmda-kvm                                                 | pcp                                                          | RHEL 8.0 |                                                              |
| pcp-webapi                                                   | pcp                                                          | RHEL 8.2 |                                                              |
| pcp-webapp-blinkenlights                                     | grafana-pcp                                                  | RHEL 8.2 |                                                              |
| pcp-webapp-grafana                                           | grafana-pcp                                                  | RHEL 8.2 |                                                              |
| pcp-webapp-graphite                                          | grafana-pcp                                                  | RHEL 8.2 |                                                              |
| pcp-webapp-vector                                            | grafana-pcp                                                  | RHEL 8.2 |                                                              |
| pcp-webjs                                                    | grafana-pcp                                                  | RHEL 8.2 |                                                              |
| pcre                                                         | pcre, pcre-cpp, pcre-utf16, pcre-utf32                       | RHEL 8.0 | 带有 C++ API 的 PCRE `libpcrecpp.so.0` 库已从 `pcre` 软件包移到 `pcre-cpp` 软件包。具有 UTF-16 支持的 `libpcre16.so.0` 库已从 `pcre` 软件包移到 `pcre-utf16` 软件包,带有 UTF-32 支持的 `libpcre32.so.0` 库已移到 `pcre-utf32` 软件包中。 |
| perl                                                         | perl, perl-Attribute-Handlers, perl-B-Debug, perl-bignum,  perl-Devel-Peek, perl-Devel-PPPort, perl-Devel-SelfStubber, perl-Errno,  perl-ExtUtils-Command, perl-ExtUtils-Miniperl, perl-Filter-Simple,  perl-interpreter, perl-IO, perl-IPC-SysV, perl-Math-BigInt,  perl-Math-BigInt-FastCalc, perl-Math-BigRat, perl-Math-Complex,  perl-Memod, perl-MIQ-BigInt, perl-Memoing, perl-MI-k perl-SelfLoader,  perl-Term-ANSIColor, perl-Term-Cap, perl-Test, perl-Text-Balanced,  perl-Unicode-Collate, perl-Unicode-Normalize | RHEL 8.0 | 在 RHEL 8 中,提供 Perl 解释器的软件包已从 `perl` 重命名为 `perl-interpreter`,而 `perl` 软件包现在只是一个 meta-package。基本语言支持模块已移至 `perl-libs`,之前在 `perl` 中捆绑的多个模块现在作为单独的软件包发布。 |
| perl-core                                                    | perl                                                         | RHEL 8.0 |                                                              |
| perl-gettext                                                 | perl-Locale-gettext                                          | RHEL 8.0 |                                                              |
| perl-libintl                                                 | perl-libintl-perl                                            | RHEL 8.0 |                                                              |
| pexpect                                                      | python3-pexpect                                              | RHEL 8.0 |                                                              |
| PHP-common                                                   | php-common, php-gmp, php-json, php-pecl-zip, php-xml         | RHEL 8.0 |                                                              |
| php-mysql                                                    | php-mysqlnd                                                  | RHEL 8.0 | 使用 `libmysqlclient` 库的 `php-mysql` 软件包已被 `php-mysqlnd` 软件包替代,该软件包使用 MySQL Native 驱动程序。 |
| pkgconfig                                                    | pkgconf-pkg-config                                           | RHEL 8.0 |                                                              |
| pki-base                                                     | pki-base, python3-pki                                        | RHEL 8.0 |                                                              |
| pki-servlet-container                                        | pki-servlet-engine                                           | RHEL 8.1 |                                                              |
| plexus-cdc                                                   | plexus-containers-component-metadata                         | RHEL 8.0 |                                                              |
| plexus-cdc-javadoc                                           | plexus-containers-javadoc                                    | RHEL 8.0 |                                                              |
| plexus-interactive                                           | plexus-interactivity, plexus-interactivity-api, plexus-interactivity-jline | RHEL 8.0 |                                                              |
| policycoreutils-gui                                          | policycoreutils-dbus, policycoreutils-gui                    | RHEL 8.0 |                                                              |
| policycoreutils-python                                       | policycoreutils-python-utils, python3-policycoreutils        | RHEL 8.0 |                                                              |
| polkit                                                       | polkit, polkit-libs                                          | RHEL 8.0 |                                                              |
| postfix                                                      | postfix, postfix-mysql                                       | RHEL 8.0 |                                                              |
| postfix                                                      | postfix, postfix-ldap, postfix-pcre                          | RHEL 8.2 |                                                              |
| postgresql-devel                                             | libpq-devel                                                  | RHEL 8.0 |                                                              |
| postgresql-libs                                              | libpq                                                        | RHEL 8.0 |                                                              |
| postgresql-plpython                                          | postgresql-plpython3                                         | RHEL 8.0 |                                                              |
| prelink                                                      | execstack                                                    | RHEL 8.0 |                                                              |
| pth                                                          | npth                                                         | RHEL 8.0 |                                                              |
| pycairo                                                      | python2-Cairo, python3-Cairo                                 | RHEL 8.0 |                                                              |
| pycairo-devel                                                | python2-cairo-devel                                          | RHEL 8.0 |                                                              |
| PyGreSQL                                                     | python3-psycopg2                                             | RHEL 8.0 |                                                              |
| pykickstart                                                  | pykickstart, python3-kickstart                               | RHEL 8.0 |                                                              |
| pyldb                                                        | python3-ldb                                                  | RHEL 8.0 |                                                              |
| pyOpenSSL                                                    | python3-pyOpenSSL                                            | RHEL 8.0 |                                                              |
| pyparsing                                                    | python3-pyparsing                                            | RHEL 8.0 |                                                              |
| pyparted                                                     | python3-pyparted                                             | RHEL 8.0 |                                                              |
| pyserial                                                     | python3-pyserial                                             | RHEL 8.0 |                                                              |
| pytalloc                                                     | python3-talloc                                               | RHEL 8.0 |                                                              |
| pytest                                                       | python2-pytest, python3-pytest                               | RHEL 8.0 |                                                              |
| python, python3                                              | platform-python                                              | RHEL 8.0 |                                                              |
| python-augeas                                                | python3-augeas                                               | RHEL 8.0 |                                                              |
| python-azure-sdk                                             | python3-azure-sdk                                            | RHEL 8.0 |                                                              |
| python-babel                                                 | python2-babel, python3-babel                                 | RHEL 8.0 |                                                              |
| python-backports                                             | python2-backports                                            | RHEL 8.0 |                                                              |
| python-backports-ssl_match_hostname                          | python2-backports-ssl_match_hostname                         | RHEL 8.0 |                                                              |
| python-bcc                                                   | python3-bcc                                                  | RHEL 8.0 |                                                              |
| python-blivet                                                | python3-blivet                                               | RHEL 8.0 |                                                              |
| python-boto3                                                 | python3-boto3                                                | RHEL 8.0 |                                                              |
| python-brlapi                                                | python3-brlapi                                               | RHEL 8.0 |                                                              |
| python-cffi                                                  | python3-cffi                                                 | RHEL 8.0 |                                                              |
| python-chardet                                               | python2-chardet, python3-chardet                             | RHEL 8.0 |                                                              |
| python-clufter                                               | python3-clufter                                              | RHEL 8.0 |                                                              |
| python-configobj                                             | python3-configobj                                            | RHEL 8.0 |                                                              |
| python-configshell                                           | python3-configshell                                          | RHEL 8.0 |                                                              |
| python-coverage                                              | platform-python-coverage, python2-coverage                   | RHEL 8.0 |                                                              |
| python-cpio                                                  | python3-cpio                                                 | RHEL 8.0 |                                                              |
| python-cups                                                  | python3-cups                                                 | RHEL 8.0 |                                                              |
| python-custodia                                              | python3-custodia                                             | RHEL 8.0 |                                                              |
| python-custodia-ipa                                          | python3-custodia                                             | RHEL 8.0 |                                                              |
| python-dateutil                                              | python3-dateutil                                             | RHEL 8.0 |                                                              |
| python-decorator                                             | python3-decorator                                            | RHEL 8.0 |                                                              |
| python-devel                                                 | python2-devel                                                | RHEL 8.0 |                                                              |
| python-dmidecode                                             | python3-dmidecode                                            | RHEL 8.0 |                                                              |
| python-dns                                                   | python2-dns, python3-dns                                     | RHEL 8.0 |                                                              |
| python-docs                                                  | python2-docs、python3-docs                                   | RHEL 8.0 |                                                              |
| python-docutils                                              | python2-docutils, python3-docutils                           | RHEL 8.0 |                                                              |
| python-enum34                                                | python3-libs                                                 | RHEL 8.0 |                                                              |
| python-ethtool                                               | python3-ethtool                                              | RHEL 8.0 |                                                              |
| python-firewall                                              | python3-firewall                                             | RHEL 8.0 |                                                              |
| python-flask                                                 | python3-flask                                                | RHEL 8.0 |                                                              |
| python-gevent                                                | python3-gevent                                               | RHEL 8.0 |                                                              |
| python-gobject                                               | python3-gobject                                              | RHEL 8.0 |                                                              |
| python-gobject-base                                          | python3-gobject-base                                         | RHEL 8.0 |                                                              |
| python-greenlet                                              | python3-greenlet                                             | RHEL 8.0 |                                                              |
| python-greenlet-devel                                        | python3-greenlet-devel                                       | RHEL 8.0 |                                                              |
| python-gssapi                                                | python3-gssapi                                               | RHEL 8.0 |                                                              |
| python-hivex                                                 | python3-hivex                                                | RHEL 8.0 |                                                              |
| python-httplib2                                              | python3-httplib2                                             | RHEL 8.0 |                                                              |
| python-hwdata                                                | python3-hwdata                                               | RHEL 8.0 |                                                              |
| python-idna                                                  | python2-idna, python3-idna                                   | RHEL 8.0 |                                                              |
| python-iniparse                                              | python3-iniparse                                             | RHEL 8.0 |                                                              |
| python-inotify                                               | python3-inotify                                              | RHEL 8.0 |                                                              |
| python-ipaddress                                             | python2-ipAddress, python3-libs                              | RHEL 8.0 |                                                              |
| python-itsdangerous                                          | python3-itsdangerous                                         | RHEL 8.0 |                                                              |
| python-javapackages                                          | python3-javapackages                                         | RHEL 8.0 |                                                              |
| python-jinja2                                                | python2-jinja2, python3-jinja2                               | RHEL 8.0 |                                                              |
| python-jsonpatch                                             | python3-jsonpatch                                            | RHEL 8.0 |                                                              |
| python-jsonpointer                                           | python3-jsonpointer                                          | RHEL 8.0 |                                                              |
| python-jwcrypto                                              | python3-jwcrypto                                             | RHEL 8.0 |                                                              |
| python-jwt                                                   | python3-jwt                                                  | RHEL 8.0 |                                                              |
| python-kdcproxy                                              | python3-kdcproxy                                             | RHEL 8.0 |                                                              |
| python-kerberos                                              | python3-gssapi                                               | RHEL 8.0 |                                                              |
| python-kmod                                                  | python3-kmod                                                 | RHEL 8.0 |                                                              |
| python-krbV                                                  | python3-gssapi                                               | RHEL 8.0 |                                                              |
| python-ldap                                                  | python3-ldap                                                 | RHEL 8.0 |                                                              |
| python-libguestfs                                            | python3-libguestfs                                           | RHEL 8.0 |                                                              |
| python-libipa_hbac                                           | python3-libipa_hbac                                          | RHEL 8.0 |                                                              |
| python-librepo                                               | python3-librepo                                              | RHEL 8.0 |                                                              |
| python-libs                                                  | python2-libs, python3-libs                                   | RHEL 8.0 |                                                              |
| python-libsss_nss_idmap                                      | python3-libsss_nss_idmap                                     | RHEL 8.0 |                                                              |
| python-linux-procfs                                          | python3-linux-procfs                                         | RHEL 8.0 |                                                              |
| python-lxml                                                  | python2-lxml, python3-lxml                                   | RHEL 8.0 |                                                              |
| python-magic                                                 | python3-magic                                                | RHEL 8.0 |                                                              |
| python-mako                                                  | python3-mako                                                 | RHEL 8.0 |                                                              |
| python-markupsafe                                            | python2-markupsafe, python3-markupsafe                       | RHEL 8.0 |                                                              |
| python-meh                                                   | python3-meh                                                  | RHEL 8.0 |                                                              |
| python-meh-gui                                               | python3-meh-gui                                              | RHEL 8.0 |                                                              |
| python-netaddr                                               | python3-netaddr                                              | RHEL 8.0 |                                                              |
| python-netifaces                                             | python3-netifaces                                            | RHEL 8.0 |                                                              |
| python-nose                                                  | python2-nose, python3-nose                                   | RHEL 8.0 |                                                              |
| python-nss                                                   | python3-nss                                                  | RHEL 8.0 |                                                              |
| python-ntplib                                                | python3-ntplib                                               | RHEL 8.0 |                                                              |
| python-pcp                                                   | python3-pcp                                                  | RHEL 8.0 |                                                              |
| python-perf                                                  | python3-perf                                                 | RHEL 8.0 |                                                              |
| python-pillow                                                | python3-pillow                                               | RHEL 8.0 |                                                              |
| python-ply                                                   | python3-ply                                                  | RHEL 8.0 |                                                              |
| python-prettytable                                           | python3-prettytable                                          | RHEL 8.0 |                                                              |
| python-psycopg2                                              | python2-psycopg2, python3-psycopg2                           | RHEL 8.0 |                                                              |
| python-psycopg2-debug                                        | python2-psycopg2-debug                                       | RHEL 8.0 |                                                              |
| python-pwquality                                             | python3-pwquality                                            | RHEL 8.0 |                                                              |
| python-py                                                    | python2-py, python3-py                                       | RHEL 8.0 |                                                              |
| python-pycparser                                             | python3-pycparser                                            | RHEL 8.0 |                                                              |
| python-pycurl                                                | python3-pycurl                                               | RHEL 8.0 |                                                              |
| python-pygments                                              | python2-pygments, python3-pygments                           | RHEL 8.0 |                                                              |
| python-pytoml                                                | python3-pytoml                                               | RHEL 8.0 |                                                              |
| python-pyudev                                                | python3-pyudev                                               | RHEL 8.0 |                                                              |
| python-qrcode                                                | python3-qrcode                                               | RHEL 8.0 |                                                              |
| python-qrcode-core                                           | python3-qrcode-core                                          | RHEL 8.0 |                                                              |
| python-reportlab                                             | python3-reportlab                                            | RHEL 8.0 |                                                              |
| python-requests                                              | python2-requests, python3-requests                           | RHEL 8.0 |                                                              |
| python-rhsm                                                  | python3-subscription-manager-rhsm                            | RHEL 8.0 |                                                              |
| python-rhsm-certificates                                     | subscription-manager-rhsm-certificates                       | RHEL 8.0 |                                                              |
| python-rtslib                                                | python3-rtslib, target-restore                               | RHEL 8.0 |                                                              |
| python-s3transfer                                            | python3-botocore, python3-jmespath, python3-s3transfer       | RHEL 8.0 |                                                              |
| python-schedutils                                            | python3-schedutils                                           | RHEL 8.0 |                                                              |
| python-setuptools                                            | python2-setuptools                                           | RHEL 8.0 |                                                              |
| python-six                                                   | python2-six, python3-six                                     | RHEL 8.0 |                                                              |
| python-slip                                                  | python3-slip                                                 | RHEL 8.0 |                                                              |
| python-slip-dbus                                             | python3-slip-dbus                                            | RHEL 8.0 |                                                              |
| python-sphinx                                                | python-sphinx-locale, python3-sphinx                         | RHEL 8.0 |                                                              |
| python-sqlalchemy                                            | python2-sqlalchemy, python3-sqlalchemy                       | RHEL 8.0 |                                                              |
| python-sss                                                   | python3-sss                                                  | RHEL 8.0 |                                                              |
| python-sss-murmur                                            | python3-sss-murmur                                           | RHEL 8.0 |                                                              |
| python-sssdconfig                                            | python3-sssdconfig                                           | RHEL 8.0 |                                                              |
| python-suds                                                  | python3-suds                                                 | RHEL 8.0 |                                                              |
| python-syspurpose                                            | python3-syspurpose                                           | RHEL 8.0 |                                                              |
| python-tdb                                                   | python3-tdb                                                  | RHEL 8.0 |                                                              |
| python-test                                                  | python2-test, python3-test                                   | RHEL 8.0 |                                                              |
| python-tevent                                                | python3-tevent                                               | RHEL 8.0 |                                                              |
| python-tools                                                 | python2-tools                                                | RHEL 8.0 |                                                              |
| python-urllib3                                               | python2-urllib3, python3-urllib3                             | RHEL 8.0 |                                                              |
| python-urwid                                                 | python3-urwid                                                | RHEL 8.0 |                                                              |
| python-virtualenv                                            | python2-virtualenv, python3-virtualenv                       | RHEL 8.0 |                                                              |
| python-werkzeug                                              | python3-werkzeug                                             | RHEL 8.0 |                                                              |
| python-yubico                                                | python3-yubico                                               | RHEL 8.0 |                                                              |
| python2-blockdev                                             | python3-blockdev                                             | RHEL 8.0 |                                                              |
| python2-bytesize                                             | python3-bytesize                                             | RHEL 8.0 |                                                              |
| python2-createrepo_c                                         | python3-createrepo_c                                         | RHEL 8.0 |                                                              |
| python2-cryptography                                         | python3-cryptography                                         | RHEL 8.0 |                                                              |
| python2-dnf                                                  | python3-dnf                                                  | RHEL 8.0 |                                                              |
| python2-dnf-plugin-versionlock                               | python3-dnf-plugin-versionlock                               | RHEL 8.0 |                                                              |
| python2-dnf-plugins-core                                     | python3-dnf-plugins-core                                     | RHEL 8.0 |                                                              |
| python2-hawkey                                               | python3-hawkey                                               | RHEL 8.0 |                                                              |
| python2-ipaclient                                            | python3-ipaclient                                            | RHEL 8.0 |                                                              |
| python2-ipalib                                               | python3-ipalib                                               | RHEL 8.0 |                                                              |
| python2-ipaserver                                            | python3-ipaserver                                            | RHEL 8.0 |                                                              |
| python2-jmespath                                             | python3-jmespath                                             | RHEL 8.0 |                                                              |
| python2-keycloak-httpd-client-install                        | python3-keycloak-httpd-client-install                        | RHEL 8.0 |                                                              |
| python2-libcomps                                             | python3-libcomps                                             | RHEL 8.0 |                                                              |
| python2-libdnf                                               | python3-libdnf                                               | RHEL 8.0 |                                                              |
| python2-oauthlib                                             | python3-oauthlib                                             | RHEL 8.0 |                                                              |
| python2-pyasn1                                               | python3-pyasn1                                               | RHEL 8.0 |                                                              |
| python2-pyasn1-modules                                       | python3-pyasn1-modules                                       | RHEL 8.0 |                                                              |
| python2-pyatspi                                              | python3-pyatspi                                              | RHEL 8.0 |                                                              |
| python2-requests-oauthlib                                    | python3-requests-oauthlib                                    | RHEL 8.0 |                                                              |
| python3-setuptools                                           | platform-python-setuptools, python3-setuptools               | RHEL 8.0 |                                                              |
| pytz                                                         | python2-pytz, python3-pytz                                   | RHEL 8.0 |                                                              |
| pyusb                                                        | python3-pyusb                                                | RHEL 8.0 |                                                              |
| pywbem                                                       | python3-pywbem                                               | RHEL 8.0 |                                                              |
| pyxattr                                                      | python3-pyxattr                                              | RHEL 8.0 |                                                              |
| PyYAML                                                       | python2-pyyaml, python3-pyyaml                               | RHEL 8.0 |                                                              |
| qemu-img-ma                                                  | qemu-img                                                     | RHEL 8.0 |                                                              |
| qemu-img-rhev                                                | qemu-img(ADVANCED-VIRT:latest)                               | RHEL 8.0 |                                                              |
| qemu-kvm                                                     | qemu-kvm(ADVANCED-VIRT:latest),  qemu-kvm-block-curl(ADVANCED-VIRT:latest),  qemu-kvm-block-gluster(ADVANCED-VIRT:latest),  qemu-kvm-block-iscsi(ADVANCED-VIRT:latest),  qemu-kvm-block-rbd(ADVANCED-VIRT:latest),  qemu-kvm-block-ssh(ADVANCED-VIRT:latest),  qemu-kvm-core(ADVANCED-VIRT:latest) | RHEL 8.0 |                                                              |
| qemu-kvm-common-ma                                           | qemu-kvm-common                                              | RHEL 8.0 |                                                              |
| qemu-kvm-common-rhev                                         | qemu-kvm-common(ADVANCED-VIRT:latest)                        | RHEL 8.0 |                                                              |
| qemu-kvm-ma                                                  | qemu-kvm, qemu-kvm-block-curl, qemu-kvm-block-gluster,  qemu-kvm-block-iscsi, qemu-kvm-block-rbd, qemu-kvm-block-ssh,  qemu-kvm-core | RHEL 8.0 | `qemu-kvm-ma` 软件包在 RHEL 7 中引入,用于 ARM、IBM POWER 和 IBM Z 架构中的虚拟化支持,已被替换为提供对所有架构支持的 `qemu-kvm` 软件包。 |
| qemu-kvm-rhev                                                | qemu-kvm(ADVANCED-VIRT:latest)                               | RHEL 8.0 |                                                              |
| qemu-kvm-rhev-debuginfo                                      | qemu-guest-agent-debuginfo, qemu-img-debuginfo,  qemu-kvm-block-curl-debuginfo, qemu-kvm-block-gluster-debuginfo,  qemu-kvm-block-iscsi-debuginfo, qemu-kvm-block-rbd-debuginfo,  qemu-kvm-block-ssh-debuginfo, qemu-kvm-common-debuginfo,  qemu-kvm-core-debuginfo, qemu-kvm-debuginfo, qemu-kvm-debugsource,  qemu-kvm-tests-debuginfo | RHEL 8.0 |                                                              |
| qemu-kvm-tools-ma                                            | qemu-kvm-common, tuned-profiles-nfv-host-bin                 | RHEL 8.0 |                                                              |
| qemu-kvm-tools-rhev                                          | qemu-kvm-common(ADVANCED-VIRT:latest), tuned-profiles-nfv-host-bin | RHEL 8.0 |                                                              |
| quagga                                                       | frr                                                          | RHEL 8.1 |                                                              |
| quagga-contrib                                               | frr-contrib                                                  | RHEL 8.1 |                                                              |
| quota                                                        | quota, quota-rpc                                             | RHEL 8.0 | `rpc.rquotad` 守护进程已从 `quota` RPM 软件包移动到 `quota-rpc`。要在 NFS 服务器上使用磁盘配额限制,并让其它机器可读或可设置限制,请安装 `quota-rpc` 软件包,并启用并启动 `rpc-rquotad.service` systemd 服务。 |
| redhat-logos                                                 | redhat-backgrounds, redhat-logos, redhat-logos-httpd         | RHEL 8.0 |                                                              |
| redhat-release-client                                        | redhat-release、redhat-release-eula                          | RHEL 8.0 |                                                              |
| redhat-release-computenode                                   | redhat-release、redhat-release-eula                          | RHEL 8.0 |                                                              |
| redhat-release-server                                        | redhat-release、redhat-release-eula                          | RHEL 8.0 |                                                              |
| redhat-release-workstation                                   | redhat-release、redhat-release-eula                          | RHEL 8.0 |                                                              |
| redhat-rpm-config                                            | kernel-rpm-macros, redhat-rpm-config                         | RHEL 8.0 |                                                              |
| resteasy-base                                                | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-atom-provider                                  | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-client                                         | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-jackson-provider                               | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-javadoc                                        | resteasy-javadoc                                             | RHEL 8.0 |                                                              |
| resteasy-base-jaxb-provider                                  | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-jaxrs                                          | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-jaxrs-all                                      | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-jaxrs-api                                      | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-providers-pom                                  | resteasy                                                     | RHEL 8.0 |                                                              |
| resteasy-base-resteasy-pom                                   | resteasy                                                     | RHEL 8.0 |                                                              |
| rh-dotnet21-dotnet                                           | dotnet                                                       | RHEL 8.0 |                                                              |
| rhn-virtualization-common                                    | python3-rhn-virtualization-common                            | RHEL 8.0 |                                                              |
| rhn-virtualization-host                                      | python3-rhn-virtualization-host, rhn-virtualization-host     | RHEL 8.0 |                                                              |
| rhncfg                                                       | python3-rhncfg, rhncfg                                       | RHEL 8.0 |                                                              |
| rhncfg-actions                                               | python3-rhncfg-actions, rhncfg-actions                       | RHEL 8.0 |                                                              |
| rhncfg-client                                                | python3-rhncfg-client, rhncfg-client                         | RHEL 8.0 |                                                              |
| rhncfg-management                                            | python3-rhncfg-management, rhncfg-management                 | RHEL 8.0 |                                                              |
| rhnpush                                                      | python3-rhnpush, rhnpush                                     | RHEL 8.0 |                                                              |
| rpm-python                                                   | python3-rpm                                                  | RHEL 8.0 |                                                              |
| rrdtool-python                                               | python3-rrdtool                                              | RHEL 8.0 |                                                              |
| rsync                                                        | rsync, rsync-daemon                                          | RHEL 8.0 |                                                              |
| samba-python                                                 | python3-samba                                                | RHEL 8.0 |                                                              |
| samba-python-test                                            | python3-samba-test                                           | RHEL 8.0 |                                                              |
| samyak-oriya-fonts                                           | samyak-odia-fonts                                            | RHEL 8.0 |                                                              |
| sane-backends                                                | sane-backends, sane-backends-daemon                          | RHEL 8.0 |                                                              |
| scipy                                                        | python2-scipy, python3-scipy                                 | RHEL 8.0 |                                                              |
| scons                                                        | python3-scons                                                | RHEL 8.0 |                                                              |
| selinux-policy-devel                                         | selinux-policy-devel, selinux-policy-doc                     | RHEL 8.0 |                                                              |
| sendmail-devel                                               | sendmail-milter-devel                                        | RHEL 8.0 |                                                              |
| setools-libs                                                 | python3-setools                                              | RHEL 8.0 |                                                              |
| shotwell                                                     | gnome-photos                                                 | RHEL 8.0 |                                                              |
| si-units                                                     | si-units, si-units-javadoc                                   | RHEL 8.0 |                                                              |
| sip                                                          | python3-pyqt5-sip, python3-sip                               | RHEL 8.0 |                                                              |
| sip-devel                                                    | python3-sip-devel, sip                                       | RHEL 8.0 |                                                              |
| sip-macros                                                   | sip                                                          | RHEL 8.0 |                                                              |
| sisu-bean, sisu-bean-binders, sisu-bean-containers,  sisu-bean-converters, sisu-bean-inject, sisu-bean-locators,  sisu-bean-reflect, sisu-bean-scanners, sisu-containers,  sisu-inject-bean, sisu-osgi-registry, sisu-registries, sisu-spi-registry | sisu-inject                                                  | RHEL 8.0 |                                                              |
| sisu-inject-plexus, sisu-plexus-binders, sisu-plexus-converters, sisu-plexus-lifecycles, sisu-plexus-locators, sisu-plexus-metadata,  sisu-plexus-scanners, sisu-plexus-shim | sisu-plexus                                                  | RHEL 8.0 |                                                              |
| sisu-maven-plugin                                            | sisu-mojos                                                   | RHEL 8.0 |                                                              |
| sisu-maven-plugin-javadoc                                    | sisu-mojos-javadoc                                           | RHEL 8.0 |                                                              |
| slf4j                                                        | jcl-over-slf4j, jul-to-slf4j, log4j-over-slf4j, slf4j, slf4j-ext, slf4j-jcl, slf4j-jdk14, slf4j-log4j12 | RHEL 8.0 |                                                              |
| slirp4netns                                                  | libslirp, slirp4netns                                        | RHEL 8.3 |                                                              |
| spacewalk-abrt                                               | python3-spacewalk-abrt, spacewalk-abrt                       | RHEL 8.0 |                                                              |
| spacewalk-backend-libs                                       | python3-spacewalk-backend-libs                               | RHEL 8.0 |                                                              |
| spacewalk-koan                                               | python3-spacewalk-koan, spacewalk-koan                       | RHEL 8.0 |                                                              |
| spacewalk-oscap                                              | python3-spacewalk-oscap, spacewalk-oscap                     | RHEL 8.0 |                                                              |
| spacewalk-usix                                               | python3-spacewalk-usix, spacewalk-usix                       | RHEL 8.0 |                                                              |
| speech-dispatcher                                            | speech-dispatcher, speech-dispatcher-eSpeak-ng               | RHEL 8.0 |                                                              |
| speech-dispatcher-python                                     | python3-speechd                                              | RHEL 8.0 |                                                              |
| speex                                                        | speex, speexdsp                                              | RHEL 8.0 |                                                              |
| speex-devel                                                  | speex-devel, speexdsp-devel                                  | RHEL 8.0 |                                                              |
| spice-gtk3                                                   | spice-gtk, spice-gtk3                                        | RHEL 8.0 |                                                              |
| sssd-common                                                  | sssd-common, sssd-nfs-idmap                                  | RHEL 8.0 |                                                              |
| stax-ex                                                      | stax-ex, stax-ex-javadoc                                     | RHEL 8.0 |                                                              |
| strace, strace32                                             | strace                                                       | RHEL 8.0 |                                                              |
| subscription-manager-gui                                     | subscription-manager-cockpit                                 | RHEL 8.0 |                                                              |
| subscription-manager-rhsm                                    | python3-subscription-manager-rhsm                            | RHEL 8.0 |                                                              |
| supermin                                                     | supermin                                                     | RHEL 8.0 |                                                              |
| supermin5                                                    | supermin                                                     | RHEL 8.0 |                                                              |
| supermin5-devel                                              | supermin-devel                                               | RHEL 8.0 |                                                              |
| syslinux                                                     | syslinux, syslinux-nonlinux                                  | RHEL 8.0 |                                                              |
| syslinux-extlinux                                            | syslinux-extlinux, syslinux-extlinux-nonlinux                | RHEL 8.0 |                                                              |
| system-config-kdump                                          | cockpit-system                                               | RHEL 8.0 |                                                              |
| system-config-users                                          | cockpit                                                      | RHEL 8.0 |                                                              |
| systemd                                                      | systemd, systemd-container, systemd-udev, timedatex          | RHEL 8.0 |                                                              |
| systemd-journal-gateway                                      | systemd-journal-remote                                       | RHEL 8.0 |                                                              |
| systemd-libs                                                 | systemd-libs, systemd-pam                                    | RHEL 8.0 |                                                              |
| systemd-networkd, systemd-resolved                           | systemd                                                      | RHEL 8.0 |                                                              |
| systemd-python                                               | python3-systemd                                              | RHEL 8.0 |                                                              |
| systemtap-runtime-python2                                    | systemtap-runtime-python3                                    | RHEL 8.0 |                                                              |
| sysvinit-tools                                               | procps-ng, util-linux                                        | RHEL 8.0 |                                                              |
| tcl                                                          | tcl, tcl-doc                                                 | RHEL 8.0 |                                                              |
| teamd                                                        | network-scripts-team, teamd                                  | RHEL 8.0 |                                                              |
| texlive-adjustbox, texlive-adjustbox-doc                     | texlive-adjustbox                                            | RHEL 8.0 |                                                              |
| texlive-ae, texlive-ae-doc                                   | texlive-ae                                                   | RHEL 8.0 |                                                              |
| texlive-algorithms, texlive-algorithms-doc                   | texlive-algorithms                                           | RHEL 8.0 |                                                              |
| texlive-amscls, texlive-amscls-doc                           | texlive-amscls                                               | RHEL 8.0 |                                                              |
| texlive-amsfonts, texlive-amsfonts-doc                       | texlive-amsfonts                                             | RHEL 8.0 |                                                              |
| texlive-amsmath, texlive-amsmath-doc                         | texlive-amsmath                                              | RHEL 8.0 |                                                              |
| texlive-anysize, texlive-anysize-doc                         | texlive-anysize                                              | RHEL 8.0 |                                                              |
| texlive-appendix, texlive-appendix-doc                       | texlive-appendix                                             | RHEL 8.0 |                                                              |
| texlive-arabxetex, texlive-arabxetex-doc                     | texlive-arabxetex                                            | RHEL 8.0 |                                                              |
| texlive-arphic, texlive-arphic-doc                           | texlive-arphic                                               | RHEL 8.0 |                                                              |
| texlive-attachfile, texlive-attachfile-doc                   | texlive-attachfile                                           | RHEL 8.0 |                                                              |
| texlive-Babel, texlive-Babel-doc                             | texlive-babel                                                | RHEL 8.0 |                                                              |
| texlive-babelbib, texlive-babelbib-doc                       | texlive-babelbib                                             | RHEL 8.0 |                                                              |
| texlive-beamer, texlive-beamer-doc                           | texlive-beamer                                               | RHEL 8.0 |                                                              |
| texlive-bera, texlive-bera-doc                               | texlive-bera                                                 | RHEL 8.0 |                                                              |
| texlive-beton, texlive-beton-doc                             | texlive-beton                                                | RHEL 8.0 |                                                              |
| texlive-bibtex-bin, texlive-bibtex-doc                       | texlive-bibtex                                               | RHEL 8.0 |                                                              |
| texlive-bibtopic, texlive-bibtopic-doc                       | texlive-bibtopic                                             | RHEL 8.0 |                                                              |
| texlive-bidi, texlive-bidi-doc                               | texlive-bidi                                                 | RHEL 8.0 |                                                              |
| texlive-bigfoot, texlive-bigfoot-doc                         | texlive-bigfoot                                              | RHEL 8.0 |                                                              |
| texlive-booktabs, texlive-booktabs-doc                       | texlive-booktabs                                             | RHEL 8.0 |                                                              |
| texlive-breakurl, texlive-breakurl-doc                       | texlive-breakurl                                             | RHEL 8.0 |                                                              |
| texlive-caption, texlive-caption-doc                         | texlive-caption                                              | RHEL 8.0 |                                                              |
| texlive-carlisle, texlive-carlisle-doc                       | texlive-carlisle                                             | RHEL 8.0 |                                                              |
| texlive-changebar, texlive-changebar-doc                     | texlive-changebar                                            | RHEL 8.0 |                                                              |
| texlive-changepage, texlive-changepage-doc                   | texlive-changepage                                           | RHEL 8.0 |                                                              |
| texlive-charter, texlive-charter-doc                         | texlive-charter                                              | RHEL 8.0 |                                                              |
| texlive-chngcntr, texlive-chngcntr-doc                       | texlive-chngcntr                                             | RHEL 8.0 |                                                              |
| texlive-cite, texlive-cite-doc                               | texlive-cite                                                 | RHEL 8.0 |                                                              |
| texlive-cjk, texlive-cjk-doc                                 | texlive-cjk                                                  | RHEL 8.0 |                                                              |
| texlive-cm, texlive-cm-doc                                   | texlive-cm                                                   | RHEL 8.0 |                                                              |
| texlive-cm-lgc, texlive-cm-lgc-doc                           | texlive-cm-lgc                                               | RHEL 8.0 |                                                              |
| texlive-cm-super, texlive-cm-super-doc                       | texlive-cm-super                                             | RHEL 8.0 |                                                              |
| texlive-cmap, texlive-cmap-doc                               | texlive-cmap                                                 | RHEL 8.0 |                                                              |
| texlive-cns, texlive-cns-doc                                 | texlive-cns                                                  | RHEL 8.0 |                                                              |
| texlive-collectbox, texlive-collectbox-doc                   | texlive-collectbox                                           | RHEL 8.0 |                                                              |
| texlive-colortbl, texlive-colortbl-doc                       | texlive-colortbl                                             | RHEL 8.0 |                                                              |
| texlive-crop, texlive-crop-doc                               | texlive-crop                                                 | RHEL 8.0 |                                                              |
| texlive-csquotes, texlive-csquotes-doc                       | texlive-csquotes                                             | RHEL 8.0 |                                                              |
| texlive-ctable, texlive-ctable-doc                           | texlive-ctable                                               | RHEL 8.0 |                                                              |
| texlive-currfile, texlive-currfile-doc                       | texlive-currfile                                             | RHEL 8.0 |                                                              |
| texlive-datetime, texlive-datetime-doc                       | texlive-datetime                                             | RHEL 8.0 |                                                              |
| texlive-dvipdfm, texlive-dvipdfm-bin, texlive-dvipdfm-doc, texlive-dvipdfmx, texlive-dvipdfmx-bin, texlive-dvipdfmx-doc | texlive-dvipdfmx                                             | RHEL 8.0 |                                                              |
| texlive-dvipdfmx-def                                         | texlive-graphics-def                                         | RHEL 8.0 |                                                              |
| texlive-dvipng, texlive-dvipng-bin, texlive-dvipng-doc       | texlive-dvipng                                               | RHEL 8.0 |                                                              |
| texlive-dvips, texlive-dvips-bin, texlive-dvips-doc          | texlive-dvips                                                | RHEL 8.0 |                                                              |
| texlive-ec, texlive-ec-doc                                   | texlive-ec                                                   | RHEL 8.0 |                                                              |
| texlive-eepic, texlive-eepic-doc                             | texlive-eepic                                                | RHEL 8.0 |                                                              |
| texlive-enctex, texlive-enctex-doc                           | texlive-enctex                                               | RHEL 8.0 |                                                              |
| texlive-enumitem, texlive-enumitem-doc                       | texlive-enumitem                                             | RHEL 8.0 |                                                              |
| texlive-epsf, texlive-epsf-doc                               | texlive-epsf                                                 | RHEL 8.0 |                                                              |
| texlive-epstopdf, texlive-epstopdf-bin, texlive-epstopdf-doc | texlive-epstopdf                                             | RHEL 8.0 |                                                              |
| texlive-eso-pic, texlive-eso-pic-doc                         | texlive-eso-pic                                              | RHEL 8.0 |                                                              |
| texlive-eso-pic, texlive-eso-pic-doc                         | texlive-eso-pic                                              | RHEL 8.0 |                                                              |
| texlive-etex, texlive-etex-doc                               | texlive-etex                                                 | RHEL 8.0 |                                                              |
| texlive-etex-pkg, texlive-etex-pkg-doc                       | texlive-etex-pkg                                             | RHEL 8.0 |                                                              |
| texlive-etoolbox, texlive-etoolbox-doc                       | texlive-etoolbox                                             | RHEL 8.0 |                                                              |
| texlive-euenc, texlive-euenc-doc                             | texlive-euenc                                                | RHEL 8.0 |                                                              |
| texlive-euler, texlive-euler-doc                             | texlive-euler                                                | RHEL 8.0 |                                                              |
| texlive-euro, texlive-euro-doc                               | texlive-euro                                                 | RHEL 8.0 |                                                              |
| texlive-eurosym, texlive-eurosym-doc                         | texlive-eurosym                                              | RHEL 8.0 |                                                              |
| texlive-extsizes, texlive-extsizes-doc                       | texlive-extsizes                                             | RHEL 8.0 |                                                              |
| texlive-fancybox, texlive-fancybox-doc                       | texlive-fancybox                                             | RHEL 8.0 |                                                              |
| texlive-fancyhdr, texlive-fancyhdr-doc                       | texlive-fancyhdr                                             | RHEL 8.0 |                                                              |
| texlive-fancyref, texlive-fancyref-doc                       | texlive-fancyref                                             | RHEL 8.0 |                                                              |
| texlive-fancyvrb, texlive-fancyvrb-doc                       | texlive-fancyvrb                                             | RHEL 8.0 |                                                              |
| texlive-filecontents, texlive-filecontents-doc               | texlive-filecontents                                         | RHEL 8.0 |                                                              |
| texlive-filehook, texlive-filehook-doc                       | texlive-filehook                                             | RHEL 8.0 |                                                              |
| texlive-fix2col, texlive-fix2col-doc                         | texlive-fix2col                                              | RHEL 8.0 |                                                              |
| texlive-fixlatvian, texlive-fixlatvian-doc                   | texlive-fixlatvian                                           | RHEL 8.0 |                                                              |
| texlive-float, texlive-float-doc                             | texlive-float                                                | RHEL 8.0 |                                                              |
| texlive-fmtcount, texlive-fmtcount-doc                       | texlive-fmtcount                                             | RHEL 8.0 |                                                              |
| texlive-fncychap, texlive-fncychap-doc                       | texlive-fncychap                                             | RHEL 8.0 |                                                              |
| texlive-fontbook, texlive-fontbook-doc                       | texlive-fontbook                                             | RHEL 8.0 |                                                              |
| texlive-fontspec, texlive-fontspec-doc                       | texlive-fontspec                                             | RHEL 8.0 |                                                              |
| texlive-fontware, texlive-fontware-bin                       | texlive-fontware                                             | RHEL 8.0 |                                                              |
| texlive-fontwrap, texlive-fontwrap-doc                       | texlive-fontwrap                                             | RHEL 8.0 |                                                              |
| texlive-footmisc, texlive-footmisc-doc                       | texlive-footmisc                                             | RHEL 8.0 |                                                              |
| texlive-fp, texlive-fp-doc                                   | texlive-fp                                                   | RHEL 8.0 |                                                              |
| texlive-fpl, texlive-fpl-doc                                 | texlive-fpl                                                  | RHEL 8.0 |                                                              |
| texlive-framed, texlive-framed-doc                           | texlive-framed                                               | RHEL 8.0 |                                                              |
| texlive-geometry, texlive-geometry-doc                       | texlive-geometry                                             | RHEL 8.0 |                                                              |
| texlive-graphics, texlive-graphics-doc, texlive-rotating, texlive-rotating-doc | texlive-graphics                                             | RHEL 8.0 |                                                              |
| texlive-gsftopk, texlive-gsftopk-bin                         | texlive-gsftopk                                              | RHEL 8.0 |                                                              |
| texlive-hyperref, texlive-hyperref-doc                       | texlive-hyperref                                             | RHEL 8.0 |                                                              |
| texlive-hyph-utf8, texlive-hyph-utf8-doc                     | texlive-hyph-utf8                                            | RHEL 8.0 |                                                              |
| texlive-hyph-utf8, texlive-hyph-utf8-doc                     | texlive-hyph-utf8                                            | RHEL 8.0 |                                                              |
| texlive-hyphenat, texlive-hyphenat-doc                       | texlive-hyphenat                                             | RHEL 8.0 |                                                              |
| texlive-ifetex, texlive-ifetex-doc                           | texlive-ifetex                                               | RHEL 8.0 |                                                              |
| texlive-ifluatex, texlive-ifluatex-doc                       | texlive-ifluatex                                             | RHEL 8.0 |                                                              |
| texlive-ifmtarg, texlive-ifmtarg-doc                         | texlive-ifmtarg                                              | RHEL 8.0 |                                                              |
| texlive-ifoddpage, texlive-ifoddpage-doc                     | texlive-ifoddpage                                            | RHEL 8.0 |                                                              |
| texlive-iftex, texlive-iftex-doc                             | texlive-iftex                                                | RHEL 8.0 |                                                              |
| texlive-ifxetex, texlive-ifxetex-doc                         | texlive-ifxetex                                              | RHEL 8.0 |                                                              |
| texlive-index, texlive-index-doc                             | texlive-index                                                | RHEL 8.0 |                                                              |
| texlive-jadetex, texlive-jadetex-bin, texlive-jadetex-doc    | texlive-jadetex                                              | RHEL 8.0 |                                                              |
| texlive-jknapltx, texlive-jknapltx-doc                       | texlive-jknapltx                                             | RHEL 8.0 |                                                              |
| texlive-kastrup, texlive-kastrup-doc                         | texlive-kastrup                                              | RHEL 8.0 |                                                              |
| texlive-kerkis, texlive-kerkis-doc                           | texlive-kerkis                                               | RHEL 8.0 |                                                              |
| texlive-kpathsea, texlive-kpathsea-bin, texlive-kpathsea-doc | texlive-kpathsea                                             | RHEL 8.0 |                                                              |
| texlive-kpathsea-lib                                         | texlive-lib                                                  | RHEL 8.0 |                                                              |
| texlive-kpathsea-lib-devel                                   | texlive-lib-devel                                            | RHEL 8.0 |                                                              |
| texlive-l3experimental, texlive-l3experimental-doc           | texlive-l3experimental                                       | RHEL 8.0 |                                                              |
| texlive-l3kernel, texlive-l3kernel-doc                       | texlive-l3kernel                                             | RHEL 8.0 |                                                              |
| texlive-l3packages, texlive-l3packages-doc                   | texlive-l3packages                                           | RHEL 8.0 |                                                              |
| texlive-lastpage, texlive-lastpage-doc                       | texlive-lastpage                                             | RHEL 8.0 |                                                              |
| texlive-latex, texlive-latex-bin, texlive-latex-bin-bin, texlive-latex-doc | texlive-latex                                                | RHEL 8.0 |                                                              |
| texlive-latex-fonts, texlive-latex-fonts-doc                 | texlive-latex-fonts                                          | RHEL 8.0 |                                                              |
| texlive-lettrine, texlive-lettrine-doc                       | texlive-lettrine                                             | RHEL 8.0 |                                                              |
| texlive-listings, texlive-listings-doc                       | texlive-listings                                             | RHEL 8.0 |                                                              |
| texlive-lm, texlive-lm-doc                                   | texlive-lm                                                   | RHEL 8.0 |                                                              |
| texlive-lm-math, texlive-lm-math-doc                         | texlive-lm-math                                              | RHEL 8.0 |                                                              |
| texlive-lua-alt-getopt, texlive-lua-alt-getopt-doc           | texlive-lua-alt-getopt                                       | RHEL 8.0 |                                                              |
| texlive-lua-alt-getopt, texlive-lua-alt-getopt-doc           | texlive-lua-alt-getopt                                       | RHEL 8.0 |                                                              |
| texlive-lualatex-math, texlive-lualatex-math-doc             | texlive-lualatex-math                                        | RHEL 8.0 |                                                              |
| texlive-lualatex-math, texlive-lualatex-math-doc             | texlive-lualatex-math                                        | RHEL 8.0 |                                                              |
| texlive-luaotfload, texlive-luaotfload-bin, texlive-luaotfload-doc | texlive-luaotfload                                           | RHEL 8.0 |                                                              |
| texlive-luatex, texlive-luatex-bin, texlive-luatex-doc       | texlive-luatex                                               | RHEL 8.0 |                                                              |
| texlive-luatexbase, texlive-luatexbase-doc                   | texlive-luatexbase                                           | RHEL 8.0 |                                                              |
| texlive-makecmds, texlive-makecmds-doc                       | texlive-makecmds                                             | RHEL 8.0 |                                                              |
| texlive-makeindex, texlive-makeindex-bin, texlive-makeindex-doc | texlive-makeindex                                            | RHEL 8.0 |                                                              |
| texlive-marginnote, texlive-marginnote-doc                   | texlive-marginnote                                           | RHEL 8.0 |                                                              |
| texlive-marvosym, texlive-marvosym-doc                       | texlive-marvosym                                             | RHEL 8.0 |                                                              |
| texlive-mathpazo, texlive-mathpazo-doc                       | texlive-mathpazo                                             | RHEL 8.0 |                                                              |
| texlive-mathspec, texlive-mathspec-doc                       | texlive-mathspec                                             | RHEL 8.0 |                                                              |
| texlive-mdwtools, texlive-mdwtools-doc                       | texlive-mdwtools                                             | RHEL 8.0 |                                                              |
| texlive-memoir, texlive-memoir-doc                           | texlive-memoir                                               | RHEL 8.0 |                                                              |
| texlive-metafont, texlive-metafont-bin                       | texlive-metafont                                             | RHEL 8.0 |                                                              |
| texlive-metalogo, texlive-metalogo-doc                       | texlive-metalogo                                             | RHEL 8.0 |                                                              |
| texlive-metapost, texlive-metapost-bin, texlive-metapost-doc, texlive-metapost-examples-doc | texlive-metapost                                             | RHEL 8.0 |                                                              |
| texlive-mflogo, texlive-mflogo-doc                           | texlive-mflogo                                               | RHEL 8.0 |                                                              |
| texlive-mfnfss, texlive-mfnfss-doc                           | texlive-mfnfss                                               | RHEL 8.0 |                                                              |
| texlive-mfware, texlive-mfware-bin                           | texlive-mfware                                               | RHEL 8.0 |                                                              |
| texlive-microtype, texlive-microtype-doc                     | texlive-microtype                                            | RHEL 8.0 |                                                              |
| texlive-mnsymbol, texlive-mnsymbol-doc                       | texlive-mnsymbol                                             | RHEL 8.0 |                                                              |
| texlive-mparhack, texlive-mparhack-doc                       | texlive-mparhack                                             | RHEL 8.0 |                                                              |
| texlive-mptopdf, texlive-mptopdf-bin                         | texlive-mptopdf                                              | RHEL 8.0 |                                                              |
| texlive-ms, texlive-ms-doc                                   | texlive-ms                                                   | RHEL 8.0 |                                                              |
| texlive-multido, texlive-multido-doc                         | texlive-multido                                              | RHEL 8.0 |                                                              |
| texlive-multirow, texlive-multirow-doc                       | texlive-multirow                                             | RHEL 8.0 |                                                              |
| texlive-natbib, texlive-natbib-doc                           | texlive-natbib                                               | RHEL 8.0 |                                                              |
| texlive-ncctools, texlive-ncctools-doc                       | texlive-ncctools                                             | RHEL 8.0 |                                                              |
| texlive-ntgclass, texlive-ntgclass-doc                       | texlive-ntgclass                                             | RHEL 8.0 |                                                              |
| texlive-oberdiek, texlive-oberdiek-doc                       | texlive-oberdiek                                             | RHEL 8.0 |                                                              |
| texlive-overpic, texlive-overpic-doc                         | texlive-overpic                                              | RHEL 8.0 |                                                              |
| texlive-paralist, texlive-paralist-doc                       | texlive-paralist                                             | RHEL 8.0 |                                                              |
| texlive-parallel, texlive-parallel-doc                       | texlive-parallel                                             | RHEL 8.0 |                                                              |
| texlive-parskip, texlive-parskip-doc                         | texlive-parskip                                              | RHEL 8.0 |                                                              |
| texlive-pdfpages, texlive-pdfpages-doc                       | texlive-pdfpages                                             | RHEL 8.0 |                                                              |
| texlive-pdftex, texlive-pdftex-bin, texlive-pdftex-doc       | texlive-pdftex                                               | RHEL 8.0 |                                                              |
| texlive-pdftex-def                                           | texlive-graphics-def                                         | RHEL 8.0 |                                                              |
| texlive-pgf, texlive-pgf-doc                                 | texlive-pgf                                                  | RHEL 8.0 |                                                              |
| texlive-philokalia, texlive-philokalia-doc                   | texlive-philokalia                                           | RHEL 8.0 |                                                              |
| texlive-placeins, texlive-placeins-doc                       | texlive-placeins                                             | RHEL 8.0 |                                                              |
| texlive-polyglosia, texlive-polyglosia-doc                   | texlive-polyglossia                                          | RHEL 8.0 |                                                              |
| texlive-powerdot, texlive-powerdot-doc                       | texlive-powerdot                                             | RHEL 8.0 |                                                              |
| texlive-preprint, texlive-preprint-doc                       | texlive-preprint                                             | RHEL 8.0 |                                                              |
| texlive-psfrag, texlive-psfrag-doc                           | texlive-psfrag                                               | RHEL 8.0 |                                                              |
| texlive-psnfss, texlive-psnfss-doc                           | texlive-psnfss                                               | RHEL 8.0 |                                                              |
| texlive-pspicture, texlive-pspicture-doc                     | texlive-pspicture                                            | RHEL 8.0 |                                                              |
| texlive-pst-3d, texlive-pst-3d-doc                           | texlive-pst-3d                                               | RHEL 8.0 |                                                              |
| texlive-pst-3d, texlive-pst-3d-doc                           | texlive-pst-3d                                               | RHEL 8.0 |                                                              |
| texlive-pst-blur, texlive-pst-blur-doc                       | texlive-pst-blur                                             | RHEL 8.0 |                                                              |
| texlive-pst-coil, texlive-pst-coil-doc                       | texlive-pst-coil                                             | RHEL 8.0 |                                                              |
| texlive-pst-eps, texlive-pst-eps-doc                         | texlive-pst-eps                                              | RHEL 8.0 |                                                              |
| texlive-pst-fill, texlive-pst-fill-doc                       | texlive-pst-fill                                             | RHEL 8.0 |                                                              |
| texlive-pst-grad, texlive-pst-grad-doc                       | texlive-pst-grad                                             | RHEL 8.0 |                                                              |
| texlive-pst-math, texlive-pst-math-doc                       | texlive-pst-math                                             | RHEL 8.0 |                                                              |
| texlive-pst-node, texlive-pst-node-doc                       | texlive-pst-node                                             | RHEL 8.0 |                                                              |
| texlive-pst-plot, texlive-pst-plot-doc                       | texlive-pst-plot                                             | RHEL 8.0 |                                                              |
| texlive-pst-slpe, texlive-pst-slpe-doc                       | texlive-pst-slpe                                             | RHEL 8.0 |                                                              |
| texlive-pst-text, texlive-pst-text-doc                       | texlive-pst-text                                             | RHEL 8.0 |                                                              |
| texlive-pst-tree, texlive-pst-tree-doc                       | texlive-pst-tree                                             | RHEL 8.0 |                                                              |
| texlive-pstricks, texlive-pstricks-doc                       | texlive-pstricks                                             | RHEL 8.0 |                                                              |
| texlive-pstricks-add, texlive-pstricks-add-doc               | texlive-pstricks-add                                         | RHEL 8.0 |                                                              |
| texlive-ptext, texlive-ptext-doc                             | texlive-ptext                                                | RHEL 8.0 |                                                              |
| texlive-pxfonts, texlive-pxfonts-doc                         | texlive-pxfonts                                              | RHEL 8.0 |                                                              |
| texlive-qstest, texlive-qstest-doc                           | texlive-qstest                                               | RHEL 8.0 |                                                              |
| texlive-rcs, texlive-rcs-doc                                 | texlive-rcs                                                  | RHEL 8.0 |                                                              |
| texlive-realscripts, texlive-realscripts-doc                 | texlive-realscripts                                          | RHEL 8.0 |                                                              |
| texlive-rsfs, texlive-rsfs-doc                               | texlive-rsfs                                                 | RHEL 8.0 |                                                              |
| texlive-sansmath, texlive-sansmath-doc                       | texlive-sansmath                                             | RHEL 8.0 |                                                              |
| texlive-sauerj, texlive-sauerj-doc                           | texlive-sauerj                                               | RHEL 8.0 |                                                              |
| texlive-section, texlive-section-doc                         | texlive-section                                              | RHEL 8.0 |                                                              |
| texlive-sectsty, texlive-sectsty-doc                         | texlive-sectsty                                              | RHEL 8.0 |                                                              |
| texlive-seminar, texlive-seminar-doc                         | texlive-seminar                                              | RHEL 8.0 |                                                              |
| texlive-sepnum, texlive-sepnum-doc                           | texlive-sepnum                                               | RHEL 8.0 |                                                              |
| texlive-setspace, texlive-setspace-doc                       | texlive-setspace                                             | RHEL 8.0 |                                                              |
| texlive-showexpl, texlive-showexpl-doc                       | texlive-showexpl                                             | RHEL 8.0 |                                                              |
| texlive-soul, texlive-soul-doc                               | texlive-soul                                                 | RHEL 8.0 |                                                              |
| texlive-stmaryrd, texlive-stmaryrd-doc                       | texlive-stmaryrd                                             | RHEL 8.0 |                                                              |
| texlive-subfig, texlive-subfig-doc                           | texlive-subfig                                               | RHEL 8.0 |                                                              |
| texlive-subfigure, texlive-subfigure-doc                     | texlive-subfigure                                            | RHEL 8.0 |                                                              |
| texlive-svn-prov, texlive-svn-prov-doc                       | texlive-svn-prov                                             | RHEL 8.0 |                                                              |
| texlive-svn-prov, texlive-svn-prov-doc                       | texlive-svn-prov                                             | RHEL 8.0 |                                                              |
| texlive-t2, texlive-t2-doc                                   | texlive-t2                                                   | RHEL 8.0 |                                                              |
| texlive-tetex, texlive-tetex-bin, texlive-tetex-doc          | texlive-tetex                                                | RHEL 8.0 |                                                              |
| texlive-tex, texlive-tex-bin                                 | texlive-tex                                                  | RHEL 8.0 |                                                              |
| texlive-tex-gyre, texlive-tex-gyre-doc                       | texlive-tex-gyre                                             | RHEL 8.0 |                                                              |
| texlive-tex-gyre-math, texlive-tex-gyre-math-doc             | texlive-tex-gyre-math                                        | RHEL 8.0 |                                                              |
| texlive-tex4ht, texlive-tex4ht-bin, texlive-tex4ht-doc       | texlive-tex4ht                                               | RHEL 8.0 |                                                              |
| texlive-texconfig, texlive-texconfig-bin                     | texlive-texconfig                                            | RHEL 8.0 |                                                              |
| texlive-texlive.infra, texlive-texlive.infra-bin, texlive-texlive.infra-doc | texlive-texlive.infra                                        | RHEL 8.0 |                                                              |
| texlive-textcase, texlive-textcase-doc                       | texlive-textcase                                             | RHEL 8.0 |                                                              |
| texlive-textpos, texlive-textpos-doc                         | texlive-textpos                                              | RHEL 8.0 |                                                              |
| texlive-threeparttable, texlive-threeparttable-doc           | texlive-threeparttable                                       | RHEL 8.0 |                                                              |
| texlive-thumbpdf, texlive-thumbpdf-bin, texlive-thumbpdf-doc | texlive-thumbpdf                                             | RHEL 8.0 |                                                              |
| texlive-tipa, texlive-tipa-doc                               | texlive-tipa                                                 | RHEL 8.0 |                                                              |
| texlive-titlesec, texlive-titlesec-doc                       | texlive-titlesec                                             | RHEL 8.0 |                                                              |
| texlive-titling, texlive-titling-doc                         | texlive-titling                                              | RHEL 8.0 |                                                              |
| texlive-tocloft, texlive-tocloft-doc                         | texlive-tocloft                                              | RHEL 8.0 |                                                              |
| texlive-tools, texlive-tools-doc                             | texlive-tools                                                | RHEL 8.0 |                                                              |
| texlive-txfonts, texlive-txfonts-doc                         | texlive-txfonts                                              | RHEL 8.0 |                                                              |
| texlive-type1cm, texlive-type1cm-doc                         | texlive-type1cm                                              | RHEL 8.0 |                                                              |
| texlive-typehtml, texlive-typehtml-doc                       | texlive-typehtml                                             | RHEL 8.0 |                                                              |
| texlive-ucharclasses, texlive-ucharclasses-doc               | texlive-ucharclasses                                         | RHEL 8.0 |                                                              |
| texlive-ucs, texlive-ucs-doc                                 | texlive-ucs                                                  | RHEL 8.0 |                                                              |
| texlive-uhc, texlive-uhc-doc                                 | texlive-uhc                                                  | RHEL 8.0 |                                                              |
| texlive-ulem, texlive-ulem-doc                               | texlive-ulem                                                 | RHEL 8.0 |                                                              |
| texlive-underscore, texlive-underscore-doc                   | texlive-underscore                                           | RHEL 8.0 |                                                              |
| texlive-unicode-math, texlive-unicode-math-doc               | texlive-unicode-math                                         | RHEL 8.0 |                                                              |
| texlive-unicode-math, texlive-unicode-math-doc               | texlive-unicode-math                                         | RHEL 8.0 |                                                              |
| texlive-unisugar, texlive-unisugar-doc                       | texlive-unisugar                                             | RHEL 8.0 |                                                              |
| texlive-url, texlive-url-doc                                 | texlive-url                                                  | RHEL 8.0 |                                                              |
| texlive-utopia, texlive-utopia-doc                           | texlive-utopia                                               | RHEL 8.0 |                                                              |
| texlive-varwidth, texlive-varwidth-doc                       | texlive-varwidth                                             | RHEL 8.0 |                                                              |
| texlive-wadalab, texlive-wadalab-doc                         | texlive-wadalab                                              | RHEL 8.0 |                                                              |
| texlive-was, texlive-was-doc                                 | texlive-was                                                  | RHEL 8.0 |                                                              |
| texlive-wasy, texlive-wasy-doc                               | texlive-wasy                                                 | RHEL 8.0 |                                                              |
| texlive-wasysym, texlive-wasysym-doc                         | texlive-wasysym                                              | RHEL 8.0 |                                                              |
| texlive-wrapfig, texlive-wrapfig-doc                         | texlive-wrapfig                                              | RHEL 8.0 |                                                              |
| texlive-xcolor, texlive-xcolor-doc                           | texlive-xcolor                                               | RHEL 8.0 |                                                              |
| texlive-xdvi, texlive-xdvi-bin                               | texlive-xdvi                                                 | RHEL 8.0 |                                                              |
| texlive-xecjk, texlive-xecjk-doc                             | texlive-xecjk                                                | RHEL 8.0 |                                                              |
| texlive-xecolor, texlive-xecolor-doc                         | texlive-xecolor                                              | RHEL 8.0 |                                                              |
| texlive-xecyr, texlive-xecyr-doc                             | texlive-xecyr                                                | RHEL 8.0 |                                                              |
| texlive-xeindex, texlive-xeindex-doc                         | texlive-xeindex                                              | RHEL 8.0 |                                                              |
| texlive-xepersian, texlive-xepersian-doc                     | texlive-xepersian                                            | RHEL 8.0 |                                                              |
| texlive-xesearch, texlive-xesearch-doc                       | texlive-xesearch                                             | RHEL 8.0 |                                                              |
| texlive-xetex, texlive-xetex-bin, texlive-xetex-doc          | texlive-xetex                                                | RHEL 8.0 |                                                              |
| texlive-xetex-def                                            | texlive-graphics-def                                         | RHEL 8.0 |                                                              |
| texlive-xetex-itrans, texlive-xetex-itrans-doc               | texlive-xetex-itrans                                         | RHEL 8.0 |                                                              |
| texlive-xetex-pstricks, texlive-xetex-pstricks-doc           | texlive-xetex-pstricks                                       | RHEL 8.0 |                                                              |
| texlive-xetex-tibetan, texlive-xetex-tibetan-doc             | texlive-xetex-tibetan                                        | RHEL 8.0 |                                                              |
| texlive-xetexfontinfo, texlive-xetexfontinfo-doc             | texlive-xetexfontinfo                                        | RHEL 8.0 |                                                              |
| texlive-xifthen, texlive-xifthen-doc                         | texlive-xifthen                                              | RHEL 8.0 |                                                              |
| texlive-xkeyval, texlive-xkeyval-doc                         | texlive-xkeyval                                              | RHEL 8.0 |                                                              |
| texlive-xltxtra, texlive-xltxtra-doc                         | texlive-xltxtra                                              | RHEL 8.0 |                                                              |
| texlive-xmltex, texlive-xmltex-bin, texlive-xmltex-doc       | texlive-xmltex                                               | RHEL 8.0 |                                                              |
| texlive-xstring, texlive-xstring-doc                         | texlive-xstring                                              | RHEL 8.0 |                                                              |
| texlive-xtab, texlive-xtab-doc                               | texlive-xtab                                                 | RHEL 8.0 |                                                              |
| texlive-xunicode, texlive-xunicode-doc                       | texlive-xunicode                                             | RHEL 8.0 |                                                              |
| tkinter                                                      | python2-tkinter, python3-tkinter                             | RHEL 8.0 |                                                              |
| trace-cmd                                                    | kernelshark, trace-cmd                                       | RHEL 8.0 |                                                              |
| tracker                                                      | tracker, tracker-miners                                      | RHEL 8.0 |                                                              |
| trousers                                                     | Itrousers, trousers-lib                                      | RHEL 8.0 |                                                              |
| unbound-python                                               | python3-unbound                                              | RHEL 8.0 |                                                              |
| unit-api                                                     | unit-api, unit-api-javadoc                                   | RHEL 8.0 |                                                              |
| uom-lib                                                      | uom-lib, uom-lib-javadoc                                     | RHEL 8.0 |                                                              |
| uom-se                                                       | uom-se, uom-se-javadoc                                       | RHEL 8.0 |                                                              |
| uom-systems                                                  | uom-systems, uom-systems-javadoc                             | RHEL 8.0 |                                                              |
| urw-fonts                                                    | urw-base35-fonts                                             | RHEL 8.0 |                                                              |
| util-linux                                                   | util-linux, util-linux-user                                  | RHEL 8.0 |                                                              |
| vlgothic-fonts                                               | google-noto-sans-cjk-ttc-fonts                               | RHEL 8.0 |                                                              |
| vulkan                                                       | vulkan-loader, vulkan-tools, vulkan-validation-layers        | RHEL 8.0 |                                                              |
| vulkan-devel                                                 | mesa-vulkan-devel, vulkan-headers, vulkan-loader-devel       | RHEL 8.0 |                                                              |
| vulkan-filesystem                                            | vulkan-loader                                                | RHEL 8.0 |                                                              |
| webkitgtk4                                                   | webkit2gtk3                                                  | RHEL 8.0 |                                                              |
| webkitgtk4-devel                                             | webkit2gtk3-devel                                            | RHEL 8.0 |                                                              |
| webkitgtk4-jsc                                               | webkit2gtk3-jsc                                              | RHEL 8.0 |                                                              |
| webkitgtk4-jsc-devel                                         | webkit2gtk3-jsc-devel                                        | RHEL 8.0 |                                                              |
| webkitgtk4-plugin-process-gtk2                               | webkit2gtk3-plugin-process-gtk2                              | RHEL 8.0 | RHEL 8.3 中删除了 `webkit2gtk3-plugin-process-gtk2` 软件包,因为 WebKitGTK 2.26 删除了对链接到 GTK 2 的 NPAPI 插件的支持。值得注意的是,这意味着 Adobe Flash 不再工作。 |
| wireshark                                                    | wireshark-cli                                                | RHEL 8.0 |                                                              |
| wireshark-gnome                                              | wireshark                                                    | RHEL 8.0 |                                                              |
| wqy-zenhei-fonts                                             | google-noto-sans-cjk-ttc-fonts                               | RHEL 8.0 |                                                              |
| xchat                                                        | hexchat                                                      | RHEL 8.0 |                                                              |
| xmvn                                                         | xmvn, xmvn-api, xmvn-bisect, xmvn-connector-aether,  xmvn-connector-ivy, xmvn-core, xmvn-install, xmvn-minimal, xmvn-mojo,  xmvn-parent-pom, xmvn-resolve, xmvn-subst, xmvn-tools-pom | RHEL 8.0 |                                                              |
| xorg-x11-drv-wacom                                           | xorg-x11-drv-wacom, xorg-x11-drv-wacom-serial-support        | RHEL 8.0 |                                                              |
| xsom                                                         | xsom, xsom-javadoc                                           | RHEL 8.0 |                                                              |
| xterm                                                        | xterm, xterm-resize                                          | RHEL 8.0 |                                                              |
| yum-cron                                                     | dnf-automatic                                                | RHEL 8.0 | `dnf-automatic` 软件包提供类似的功能,但与 `yum-cron` 配置文件不兼容。 |
| yum-metadata-parser                                          | python3-dnf                                                  | RHEL 8.0 | 用户现在应该使用 DNF API（查询、软件包对象等）来使用 repodata 内容。 |
| yum-plugin-aliases, yum-plugin-fastestmirror,  yum-plugin-priorities, yum-plugin-remove-with-leaves,  yum-plugin-tmprepo, yum-plugin-tsflags | dnf                                                          | RHEL 8.0 | 以上的功能由 DNF 提供。`yum-plugin-tmprepo` 的功能由 `--repofrompath` 选项提供。设置 `tsflags` 选项现在是 `dnf` 的一个完整部分：使用 `--setopt=tsflags=<flags>`。 |
| yum-plugin-auto-update-debug-info, yum-plugin-changelog, yum-plugin-copr | dnf-plugins-core                                             | RHEL 8.0 | 所有这些插件现在都是 `dnf-plugins-core` 软件包的一部分,但仍可在原始名称下安装。 |
| yum-plugin-versionlock                                       | python3-dnf-plugin-versionlock                               | RHEL 8.0 | 仍可在原始名称下安装。                                       |
| yum-rhn-plugin                                               | dnf-plugin-spacewalk                                         | RHEL 8.0 |                                                              |
| yum-utils                                                    | dnf-utils                                                    | RHEL 8.0 |                                                              |

​				有关当前 RHEL 8 次要发行本中可用软件包的完整列表，请查看 [软件包清单](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/package_manifest/)。 		

## A.3. 移动软件包

​				以下软件包在 RHEL 8 中的软件仓库间移动： 		

| 软件包                                   | 原始软件仓库*       | 当前软件仓库*       | 修改自   |
| ---------------------------------------- | ------------------- | ------------------- | -------- |
| apache-commons-collections-javadoc       | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| apache-commons-collections-testframework | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| apache-commons-lang-javadoc              | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| apache-commons-net                       | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| brotli-devel                             | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| compat-locales-sap                       | rhel8-AppStream     | rhel8-SAP-NetWeaver | RHEL 8.1 |
| daxctl-devel                             | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| elfutils-debuginfod-client               | rhel8-AppStream     | rhel8-BaseOS        | RHEL 8.3 |
| elfutils-debuginfod-client-devel         | rhel8-AppStream     | rhel8-BaseOS        | RHEL 8.3 |
| ghostscript-x11                          | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| gobject-introspection-devel              | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| iso-codes-devel                          | rhel8-CRB           | rhel8-AppStream     | RHEL 8.1 |
| jakarta-commons-httpclient-demo          | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| jakarta-commons-httpclient-javadoc       | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| jakarta-commons-httpclient-manual        | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| jna                                      | rhel8-CRB           | rhel8-AppStream     | RHEL 8.1 |
| json-c-devel                             | rhel8-CRB           | rhel8-AppStream     | RHEL 8.4 |
| jsr-305                                  | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| libbabeltrace                            | rhel8-AppStream     | rhel8-BaseOS        | RHEL 8.3 |
| libcacard-devel                          | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| libidn2-devel                            | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| libmaxminddb-devel                       | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| libmnl-devel                             | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| libogg-devel                             | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| libseccomp-devel                         | rhel8-CRB           | rhel8-AppStream     | RHEL 8.1 |
| maven-resolver                           | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| maven-wagon                              | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| ndctl-devel                              | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| Opus-devel                               | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| perl-Importer                            | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| perl-IO-String                           | rhel8-CRB           | rhel8-AppStream     | RHEL 8.4 |
| perl-Term-Table                          | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| perl-Tk                                  | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| protobuf-c-compiler                      | rhel8-CRB           | rhel8-AppStream     | RHEL 8.4 |
| protobuf-c-devel                         | rhel8-CRB           | rhel8-AppStream     | RHEL 8.4 |
| protobuf-compiler                        | rhel8-CRB           | rhel8-AppStream     | RHEL 8.4 |
| resource-agents-sap-hana                 | rhel8-SAP-NetWeaver | rhel8-SAP-Solutions | RHEL 8.2 |
| resource-agents-sap-hana-scaleout        | rhel8-SAP-NetWeaver | rhel8-SAP-Solutions | RHEL 8.2 |
| rt-tests                                 | rhel8-RT            | rhel8-AppStream     | RHEL 8.4 |
| rt-tests                                 | rhel8-NFV           | rhel8-AppStream     | RHEL 8.4 |
| samba-test                               | rhel8-AppStream     | rhel8-BaseOS        | RHEL 8.2 |
| samba-test                               | rhel8-BaseOS        | rhel8-AppStream     | RHEL 8.1 |
| sip                                      | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| spirv-tools-libs                         | rhel8-CRB           | rhel8-AppStream     | RHEL 8.1 |
| tinycdb                                  | rhel8-CRB           | rhel8-AppStream     | RHEL 8.2 |
| usbredir-devel                           | rhel8-CRB           | rhel8-AppStream     | RHEL 8.3 |
| velocity-demo                            | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| velocity-javadoc                         | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| velocity-manual                          | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| virtio-win                               | rhel8-Supplementary | rhel8-AppStream     | RHEL 8.1 |
| xerces-j2-demo                           | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| xerces-j2-javadoc                        | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| xkeyboard-config-devel                   | rhel8-CRB           | rhel8-AppStream     | RHEL 8.1 |
| xml-commons-apis-javadoc                 | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| xml-commons-apis-manual                  | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |
| xml-commons-resolver-javadoc             | rhel8-AppStream     | rhel8-CRB           | RHEL 8.1 |

​				* 这个表使用缩写名称来表示存储库 ID。使用以下示例来帮助识别完整的存储库 ID,其中 *<arch>* 是具体的架构： 		

- ​						**rhel8-BaseOS:** rhel-8-for-*<arch>*-baseos-rpms, rhel-8-for-*<arch>*-baseos-eus-rpms, rhel-8-for-*<arch>*-baseos-e4s-rpms。 				
- ​						**rhel8-AppStream:** rhel-8-for-*<arch>*-appstream-rpms, rhel-8-for-*<arch>*-appstream-eus-rpms, rhel-8-for-*<arch>*-appstream-e4s-rpms。 				
- ​						**rhel8-CRB:** codeready-builder-for-rhel-8-*<arch>*-rpms, codeready-builder-for-rhel-8-*<arch>*-eus-rpms。 				
- ​						**rhel8-SAP-Solutions:** rhel-8-for-*<arch>*-sap-solutions-rpms, rhel-8-for-*<arch>*-sap-solutions-eus-rpms, rhel-8-for-*<arch>*-sap-solutions-e4s-rpms。 				
- ​						**rhel8-SAP-NetWeaver:** rhel-8-for-*<arch>*-sap-netweaver-rpms, rhel-8-for-*<arch>*-sap-netweaver-eus-rpms, rhel-8-for-*<arch>*-sap-netweaver-e4s-rpms。 				

​				有关当前 RHEL 8 次要发行本中可用软件包的完整列表，请查看 [软件包清单](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/package_manifest/)。 		

## A.4. 删除的软件包

​				以下软件包是 RHEL 7 的一部分，但没有包括在 RHEL 8 中： 		

| 软件包                                         | 备注                                                         |
| ---------------------------------------------- | ------------------------------------------------------------ |
| a2ps                                           | 已删除 `a2ps` 软件包。`enscript` 软件包可覆盖其一些功能。用户可以在 `/etc/enscript.cfg` 文件中配置 `enscript`。 |
| abrt-addon-upload-watch                        |                                                              |
| abrt-devel                                     |                                                              |
| abrt-gui-devel                                 |                                                              |
| abrt-retrace-client                            |                                                              |
| acpid-sysvinit                                 |                                                              |
| advancecomp                                    |                                                              |
| adwaita-icon-theme-devel                       |                                                              |
| adwaita-qt-common                              |                                                              |
| adwaita-qt4                                    |                                                              |
| agg                                            |                                                              |
| agg-devel                                      |                                                              |
| aic94xx-firmware                               |                                                              |
| akonadi                                        |                                                              |
| akonadi-devel                                  |                                                              |
| akonadi-mysql                                  |                                                              |
| alacarte                                       |                                                              |
| alsa-tools                                     |                                                              |
| anaconda-widgets-devel                         |                                                              |
| ant-antunit                                    |                                                              |
| ant-antunit-javadoc                            |                                                              |
| antlr-C++-doc                                  |                                                              |
| antlr-python                                   |                                                              |
| apache-commons-configuration                   |                                                              |
| apache-commons-configuration-javadoc           |                                                              |
| apache-commons-daemon                          |                                                              |
| apache-commons-daemon-javadoc                  |                                                              |
| apache-commons-daemon-jsvc                     |                                                              |
| apache-commons-dbcp                            |                                                              |
| apache-commons-dbcp-javadoc                    |                                                              |
| apache-commons-digester                        |                                                              |
| apache-commons-digester-javadoc                |                                                              |
| apache-commons-jexl                            |                                                              |
| apache-commons-jexl-javadoc                    |                                                              |
| apache-commons-pool                            |                                                              |
| apache-commons-pool-javadoc                    |                                                              |
| apache-commons-validator                       |                                                              |
| apache-commons-validator-javadoc               |                                                              |
| apache-commons-vfs                             |                                                              |
| apache-commons-vfs-ant                         |                                                              |
| apache-commons-vfs-examples                    |                                                              |
| apache-commons-vfs-javadoc                     |                                                              |
| apache-rat                                     |                                                              |
| apache-rat-core                                |                                                              |
| apache-rat-javadoc                             |                                                              |
| apache-rat-plugin                              |                                                              |
| apache-rat-tasks                               |                                                              |
| apr-util-nss                                   | `apr-util-nss` 软件包使用 NSS Cryptography 库为 `apr_crypto.h` 接口提供后端。任何使用这个接口的 `NSS` 后端的应用程序都应该使用 `OpenSSL` 后端进行迁移,该后端在 `apr-util-openssl` 软件包中提供。 |
| args4j                                         |                                                              |
| args4j-javadoc                                 |                                                              |
| ark                                            |                                                              |
| ark-libs                                       |                                                              |
| asciidoc-latex                                 |                                                              |
| at-spi                                         |                                                              |
| at-spi-devel                                   |                                                              |
| at-spi-python                                  |                                                              |
| at-sysvinit                                    |                                                              |
| atlas-static                                   |                                                              |
| attica                                         |                                                              |
| attica-devel                                   |                                                              |
| audiocd-kio                                    |                                                              |
| audiocd-kio-devel                              |                                                              |
| audiocd-kio-libs                               |                                                              |
| audiofile                                      |                                                              |
| audiofile-devel                                |                                                              |
| audit-libs-python                              |                                                              |
| audit-libs-static                              |                                                              |
| authconfig-gtk                                 |                                                              |
| authd                                          |                                                              |
| automoc                                        |                                                              |
| autotrace-devel                                |                                                              |
| avahi-dnsconfd                                 |                                                              |
| avahi-qt3                                      |                                                              |
| avahi-qt3-devel                                |                                                              |
| avahi-qt4                                      |                                                              |
| avahi-qt4-devel                                |                                                              |
| avahi-tools                                    |                                                              |
| avahi-ui-tools                                 |                                                              |
| avalon-framework                               |                                                              |
| avalon-framework-javadoc                       |                                                              |
| avalon-logkit                                  |                                                              |
| avalon-logkit-javadoc                          |                                                              |
| bacula-console-bat                             |                                                              |
| bacula-devel                                   |                                                              |
| bacula-traymonitor                             |                                                              |
| baekmuk-ttf-batang-fonts                       |                                                              |
| baekmuk-ttf-dotum-fonts                        |                                                              |
| baekmuk-ttf-fonts-common                       |                                                              |
| baekmuk-ttf-fonts-ghostscript                  |                                                              |
| baekmuk-ttf-gulim-fonts                        |                                                              |
| baekmuk-ttf-hline-fonts                        |                                                              |
| base64coder                                    |                                                              |
| base64coder-javadoc                            |                                                              |
| batik                                          |                                                              |
| batik-demo                                     |                                                              |
| batik-javadoc                                  |                                                              |
| batik-rasterizer                               |                                                              |
| batik-slideshow                                |                                                              |
| batik-squiggle                                 |                                                              |
| batik-svgpp                                    |                                                              |
| batik-ttf2svg                                  |                                                              |
| bison-devel                                    |                                                              |
| blas-static                                    |                                                              |
| blas64-devel                                   |                                                              |
| blas64-static                                  |                                                              |
| bltk                                           |                                                              |
| bluedevil                                      |                                                              |
| bluedevil-autostart                            |                                                              |
| bmc-snmp-proxy                                 |                                                              |
| bogofilter-bogoupgrade                         |                                                              |
| bridge-utils                                   |                                                              |
| bsdcpio                                        |                                                              |
| bsh-demo                                       |                                                              |
| bsh-utils                                      |                                                              |
| btrfs-progs                                    |                                                              |
| btrfs-progs-devel                              |                                                              |
| buildnumber-maven-plugin                       |                                                              |
| buildnumber-maven-plugin-javadoc               |                                                              |
| bwidget                                        |                                                              |
| bzr                                            |                                                              |
| bzr-doc                                        |                                                              |
| joe-tools                                      |                                                              |
| caribou                                        |                                                              |
| caribou-antler                                 |                                                              |
| caribou-devel                                  |                                                              |
| caribou-gtk2-module                            |                                                              |
| caribou-gtk3-module                            |                                                              |
| cdparanoia-static                              |                                                              |
| cdrskin                                        |                                                              |
| ceph-common                                    |                                                              |
| check-static                                   |                                                              |
| cheese-libs-devel                              |                                                              |
| cifs-utils-devel                               |                                                              |
| cim-schema-docs                                |                                                              |
| cim-schema-docs                                |                                                              |
| cjkuni-ukai-fonts                              |                                                              |
| clutter-gst2-devel                             |                                                              |
| clutter-tests                                  |                                                              |
| cmpi-bindings-pywbem                           |                                                              |
| cobertura                                      |                                                              |
| cobertura-javadoc                              |                                                              |
| cockpit-kubernetes                             |                                                              |
| cockpit-machines-ovirt                         |                                                              |
| codehaus-parent                                |                                                              |
| codemodel-javadoc                              |                                                              |
| cogl-tests                                     |                                                              |
| colord-extra-profiles                          |                                                              |
| colord-kde                                     |                                                              |
| compat-cheese314                               |                                                              |
| compat-dapl                                    |                                                              |
| compat-dapl-devel                              |                                                              |
| compat-dapl-static                             |                                                              |
| compat-dapl-utils                              |                                                              |
| compat-db                                      |                                                              |
| compat-db-headers                              |                                                              |
| compat-db47                                    |                                                              |
| compat-exiv2-023                               |                                                              |
| compat-gcc-44                                  |                                                              |
| compat-gcc-44-c++                              |                                                              |
| compat-gcc-44-gfortran                         |                                                              |
| compat-glade315                                |                                                              |
| compat-glew                                    |                                                              |
| compat-glibc                                   |                                                              |
| compat-glibc-headers                           |                                                              |
| compat-gnome-desktop314                        |                                                              |
| compat-grilo02                                 |                                                              |
| compat-libcap1                                 |                                                              |
| compat-libcogl-pango12                         |                                                              |
| compat-libcogl12                               |                                                              |
| compat-libcolord1                              |                                                              |
| compat-libf2c-34                               |                                                              |
| compat-libgdata13                              |                                                              |
| compat-libgfortran-41                          |                                                              |
| compat-libgnome-bluetooth11                    |                                                              |
| compat-libgnome-desktop3-7                     |                                                              |
| compat-libgweather3                            |                                                              |
| compat-libical1                                |                                                              |
| compat-libmediaart0                            |                                                              |
| compat-libmpc                                  |                                                              |
| compat-libpackagekit-glib2-16                  |                                                              |
| compat-libstdc++-33                            |                                                              |
| compat-libtiff3                                |                                                              |
| compat-libupower-glib1                         |                                                              |
| compat-libxcb                                  |                                                              |
| compat-openldap                                |                                                              |
| compat-openmpi16                               |                                                              |
| compat-openmpi16-devel                         |                                                              |
| compat-opensm-libs                             |                                                              |
| compat-poppler022                              |                                                              |
| compat-poppler022-cpp                          |                                                              |
| compat-poppler022-glib                         |                                                              |
| compat-poppler022-qt                           |                                                              |
| compat-sap-c++-5                               |                                                              |
| compat-sap-c++-6                               |                                                              |
| compat-sap-c++-7                               |                                                              |
| compat-sap-c++-8                               |                                                              |
| comps-extras                                   |                                                              |
| conman                                         |                                                              |
| console-setup                                  |                                                              |
| coolkey-devel                                  |                                                              |
| cpptest                                        |                                                              |
| cpptest-devel                                  |                                                              |
| cppunit                                        |                                                              |
| cppunit-devel                                  |                                                              |
| cppunit-doc                                    |                                                              |
| cpuid                                          |                                                              |
| cracklib-python                                |                                                              |
| crash-spu-commands                             | `crash-spu-commands` 软件包只支持 IBM POWER,大端架构,在 RHEL 8 中不被支持。您可以从 [上游 crash-extensions](https://crash-utility.github.io/extensions.html) 存储库获取 `spu.c crash` 扩展。 |
| crda-devel                                     |                                                              |
| crit                                           |                                                              |
| criu-devel                                     |                                                              |
| crypto-utils                                   |                                                              |
| cryptsetup-python                              |                                                              |
| cvs                                            | RHEL 8 支持的版本控制系统是 `Git`、`Mercurial` 和 `Subversion`。 |
| cvs-contrib                                    | RHEL 8 支持的版本控制系统是 `Git`、`Mercurial` 和 `Subversion`。 |
| cvs-doc                                        | RHEL 8 支持的版本控制系统是 `Git`、`Mercurial` 和 `Subversion`。 |
| cvs-inetd                                      | RHEL 8 支持的版本控制系统是 `Git`、`Mercurial` 和 `Subversion`。 |
| cvsps                                          |                                                              |
| cyrus-imapd-devel                              |                                                              |
| dapl                                           |                                                              |
| dapl-devel                                     |                                                              |
| dapl-static                                    |                                                              |
| dapl-utils                                     |                                                              |
| dbus-doc                                       |                                                              |
| dbus-python-devel                              |                                                              |
| dbus-tests                                     |                                                              |
| dbusmenu-qt                                    |                                                              |
| dbusmenu-qt-devel                              |                                                              |
| dbusmenu-qt-devel-docs                         |                                                              |
| debugmode                                      |                                                              |
| dejavu-lgc-sans-fonts                          |                                                              |
| dejavu-lgc-sans-mono-fonts                     |                                                              |
| dejavu-lgc-serif-fonts                         |                                                              |
| deltaiso                                       |                                                              |
| device-mapper-multipath-sysvinit               |                                                              |
| dhcp-devel                                     |                                                              |
| dialog-devel                                   |                                                              |
| dleyna-connector-dbus-devel                    |                                                              |
| dleyna-core-devel                              |                                                              |
| dlm-devel                                      |                                                              |
| dmraid                                         | 用户需要支持组合硬件和软件 RAID 主机总线适配器(HBA)应该使用 `mdadm` 工具。 |
| dmraid-devel                                   |                                                              |
| dmraid-events                                  |                                                              |
| dmraid-events-logwatch                         |                                                              |
| docbook-simple                                 |                                                              |
| docbook-slides                                 |                                                              |
| docbook-utils-pdf                              |                                                              |
| docbook5-style-xsl                             |                                                              |
| docbook5-style-xsl-extensions                  |                                                              |
| docker-rhel-push-plugin                        |                                                              |
| dom4j                                          |                                                              |
| dom4j-demo                                     |                                                              |
| dom4j-javadoc                                  |                                                              |
| dom4j-manual                                   |                                                              |
| dracut-fips                                    | `dracut-fips` 软件包的功能由 RHEL 8 中的 `crypto-policies` 软件包和 `fips-mode-setup` 工具提供。 |
| dracut-fips-aesni                              |                                                              |
| dragon                                         |                                                              |
| drm-utils                                      |                                                              |
| drpmsync                                       |                                                              |
| dtdinst                                        |                                                              |
| dumpet                                         |                                                              |
| dvgrab                                         |                                                              |
| e2fsprogs-static                               |                                                              |
| ecj                                            |                                                              |
| edac-utils-devel                               |                                                              |
| efax                                           |                                                              |
| efivar-devel                                   |                                                              |
| egl-utils                                      |                                                              |
| ekiga                                          |                                                              |
| ElectricFence                                  |                                                              |
| emacs-a2ps                                     |                                                              |
| emacs-a2ps-el                                  |                                                              |
| emacs-auctex                                   |                                                              |
| emacs-auctex-doc                               |                                                              |
| emacs-git                                      |                                                              |
| emacs-git-el                                   |                                                              |
| emacs-gnuplot                                  |                                                              |
| emacs-gnuplot-el                               |                                                              |
| emacs-php-mode                                 |                                                              |
| empathy                                        | RHEL 8 支持的即时消息客户端是 `hexchat` 和 `pidgin`。        |
| enchant-aspell                                 |                                                              |
| enchant-voikko                                 |                                                              |
| eog-devel                                      |                                                              |
| epydoc                                         |                                                              |
| espeak-devel                                   |                                                              |
| evince-dvi                                     |                                                              |
| evolution-devel-docs                           |                                                              |
| evolution-tests                                |                                                              |
| expat-static                                   | 不再提供为 `expat` XML 库提供静态库的 `expat-static` 软件包。改为使用动态链接。 |
| expected-devel                                 |                                                              |
| expectk                                        |                                                              |
| farstream                                      |                                                              |
| farstream-devel                                |                                                              |
| farstream-python                               |                                                              |
| hugestream02-devel                             |                                                              |
| fedfs-utils-admin                              |                                                              |
| fedfs-utils-client                             |                                                              |
| fedfs-utils-common                             |                                                              |
| fedfs-utils-devel                              |                                                              |
| fedfs-utils-lib                                |                                                              |
| fedfs-utils-nsdbparams                         |                                                              |
| fedfs-utils-python                             |                                                              |
| fedfs-utils-server                             |                                                              |
| felix-bundlerepository                         |                                                              |
| felix-bundlerepository-javadoc                 |                                                              |
| felix-framework                                |                                                              |
| felix-framework-javadoc                        |                                                              |
| felix-osgi-obr                                 |                                                              |
| felix-osgi-obr-javadoc                         |                                                              |
| felix-shell                                    |                                                              |
| felix-shell-javadoc                            |                                                              |
| fence-sanlock                                  |                                                              |
| festival                                       |                                                              |
| festival-devel                                 |                                                              |
| festival-docs                                  |                                                              |
| festival-freebsoft-utils                       |                                                              |
| festival-lib                                   |                                                              |
| festival-speechtools-devel                     |                                                              |
| festival-speechtools-libs                      |                                                              |
| festival-speechtools-utils                     |                                                              |
| festvox-awb-arctic-hts                         |                                                              |
| festvox-bdl-arctic-hts                         |                                                              |
| festvox-clb-arctic-hts                         |                                                              |
| festvox-jmk-arctic-hts                         |                                                              |
| festvox-kal-diphone                            |                                                              |
| festvox-ked-diphone                            |                                                              |
| festvox-rms-arctic-hts                         |                                                              |
| festvox-slt-arctic-hts                         |                                                              |
| file-static                                    |                                                              |
| filebench                                      |                                                              |
| filesystem-content                             |                                                              |
| finch                                          |                                                              |
| finch-devel                                    |                                                              |
| finger                                         | `finger` 客户端/服务器的用户可以使用 `who`、`pinky` 和 `last` 命令。对于远程机器，请在 SSH 中使用这些命令。 |
| finger-server                                  |                                                              |
| flatpak-devel                                  |                                                              |
| fltk-fluid                                     |                                                              |
| fltk-static                                    |                                                              |
| flute-javadoc                                  |                                                              |
| folks                                          |                                                              |
| folks-devel                                    |                                                              |
| folks-tools                                    |                                                              |
| fontforge-devel                                |                                                              |
| fontpackages-tools                             |                                                              |
| fonttools                                      |                                                              |
| fop                                            |                                                              |
| fop-javadoc                                    |                                                              |
| fprintd-devel                                  |                                                              |
| freeradius-python                              |                                                              |
| freetype-demos                                 |                                                              |
| fros                                           |                                                              |
| fros-gnome                                     |                                                              |
| fros-recordmydesktop                           |                                                              |
| fuseiso                                        |                                                              |
| fwupd-devel                                    |                                                              |
| fwupdate-devel                                 |                                                              |
| gamin-python                                   |                                                              |
| gavl-devel                                     |                                                              |
| gcab                                           |                                                              |
| gcc-gnat                                       |                                                              |
| gcc-go                                         |                                                              |
| gcc-objc                                       |                                                              |
| gcc-objc++                                     |                                                              |
| gconf-editor                                   |                                                              |
| gd-progs                                       |                                                              |
| gdk-pixbuf2-tests                              |                                                              |
| gdm-devel                                      |                                                              |
| gdm-pam-extensions-devel                       |                                                              |
| gedit-devel                                    |                                                              |
| gedit-plugin-bookmarks                         |                                                              |
| gedit-plugin-bracketcompletion                 |                                                              |
| gedit-plugin-charmap                           |                                                              |
| gedit-plugin-codecomment                       |                                                              |
| gedit-plugin-colorpicker                       |                                                              |
| gedit-plugin-colorschemer                      |                                                              |
| gedit-plugin-commander                         |                                                              |
| gedit-plugin-drawspaces                        |                                                              |
| gedit-plugin-findinfiles                       |                                                              |
| gedit-plugin-joinlines                         |                                                              |
| gedit-plugin-multiedit                         |                                                              |
| gedit-plugin-smartspaces                       |                                                              |
| gedit-plugin-synctex                           |                                                              |
| gedit-plugin-terminal                          |                                                              |
| gedit-plugin-textsize                          |                                                              |
| gedit-plugin-translate                         |                                                              |
| gedit-plugin-wordcompletion                    |                                                              |
| gedit-plugins                                  |                                                              |
| gedit-plugins-data                             |                                                              |
| gegl-devel                                     |                                                              |
| geoclue                                        |                                                              |
| geoclue-devel                                  |                                                              |
| geoclue-doc                                    |                                                              |
| geoclue-gsmloc                                 |                                                              |
| geoclue-gui                                    |                                                              |
| GeoIP                                          | `GeoIp` 软件包只能用于旧的数据库。RHEL 8 中提供的替代方案是新的 `libmaxminddb` 软件包,以及 `geoipupdate` 软件包。这是一个由上游 GeoIP 项目创建的新 API,它支持新的数据库格式 `mmdb`。 |
| GeoIP-data                                     |                                                              |
| GeoIP-devel                                    |                                                              |
| GeoIP-update                                   |                                                              |
| geronimo-jaspic-spec                           |                                                              |
| geronimo-jaspic-spec-javadoc                   |                                                              |
| geronimo-jaxrpc                                |                                                              |
| geronimo-jaxrpc-javadoc                        |                                                              |
| geronimo-jta                                   |                                                              |
| geronimo-jta-javadoc                           |                                                              |
| geronimo-osgi-support                          |                                                              |
| geronimo-osgi-support-javadoc                  |                                                              |
| geronimo-saaj                                  |                                                              |
| geronimo-saaj-javadoc                          |                                                              |
| ghostscript-chinese                            |                                                              |
| ghostscript-chinese-zh_CN                      |                                                              |
| ghostscript-chinese-zh_TW                      |                                                              |
| ghostscript-cups                               |                                                              |
| ghostscript-gtk                                |                                                              |
| giflib-utils                                   |                                                              |
| gimp-data-extras                               |                                                              |
| gimp-help                                      |                                                              |
| gimp-help-ca                                   |                                                              |
| gimp-help-da                                   |                                                              |
| IMP-help-de                                    |                                                              |
| IMP-help-el                                    |                                                              |
| IMP-help-en_GB                                 |                                                              |
| gIMP-help-es                                   |                                                              |
| gimp-help-fr                                   |                                                              |
| gimp-help-it                                   |                                                              |
| gimp-help-ja                                   |                                                              |
| gimp-help-ko                                   |                                                              |
| gimp-help-nl                                   |                                                              |
| gimp-help-nn                                   |                                                              |
| gimp-help-pt_BR                                |                                                              |
| gimp-help-ru                                   |                                                              |
| gimp-help-sl                                   |                                                              |
| gimp-help-sv                                   |                                                              |
| gimp-help-zh_CN                                |                                                              |
| git-bzr                                        |                                                              |
| git-cvs                                        |                                                              |
| git-gnome-keyring                              |                                                              |
| git-hg                                         |                                                              |
| git-p4                                         |                                                              |
| gjs-tests                                      |                                                              |
| glade                                          |                                                              |
| glade3                                         |                                                              |
| glade3-libgladeui                              |                                                              |
| glade3-libgladeui-devel                        |                                                              |
| glassfish-dtd-parser                           |                                                              |
| glassfish-dtd-parser-javadoc                   |                                                              |
| glassfish-jaxb-javadoc                         |                                                              |
| glassfish-jsp                                  |                                                              |
| glassfish-jsp-javadoc                          |                                                              |
| glew                                           |                                                              |
| glib-networking-tests                          |                                                              |
| gmp-static                                     |                                                              |
| gnome-clocks                                   |                                                              |
| gnome-contacts                                 |                                                              |
| gnome-desktop3-tests                           |                                                              |
| gnome-devel-docs                               |                                                              |
| gnome-dictionary                               |                                                              |
| gnome-doc-utils                                |                                                              |
| gnome-doc-utils-stylesheets                    |                                                              |
| gnome-documents                                |                                                              |
| gnome-documents-libs                           |                                                              |
| gnome-icon-theme                               |                                                              |
| gnome-icon-theme-devel                         |                                                              |
| gnome-icon-theme-extras                        |                                                              |
| gnome-icon-theme-legacy                        |                                                              |
| gnome-icon-theme-symbolic                      |                                                              |
| gnome-packagekit                               |                                                              |
| gnome-packagekit-common                        |                                                              |
| gnome-packagekit-installer                     |                                                              |
| gnome-packagekit-updater                       |                                                              |
| gnome-python2                                  |                                                              |
| gnome-python2-bonobo                           |                                                              |
| gnome-python2-canvas                           |                                                              |
| gnome-python2-devel                            |                                                              |
| gnome-python2-gconf                            |                                                              |
| gnome-python2-gnome                            |                                                              |
| gnome-python2-gnomevfs                         |                                                              |
| gnome-settings-daemon-devel                    |                                                              |
| gnome-software-devel                           |                                                              |
| gnome-vfs2                                     |                                                              |
| gnome-vfs2-devel                               |                                                              |
| gnome-vfs2-smb                                 |                                                              |
| gnome-weather                                  |                                                              |
| gnome-weather-tests                            |                                                              |
| gnote                                          |                                                              |
| gnu-efi-utils                                  |                                                              |
| gnu-getopt                                     |                                                              |
| gnu-getopt-javadoc                             |                                                              |
| gnuplot-latex                                  |                                                              |
| gnuplot-minimal                                |                                                              |
| gob2                                           |                                                              |
| gom-devel                                      |                                                              |
| google-noto-sans-korean-fonts                  |                                                              |
| google-noto-sans-simplified-chinese-fonts      |                                                              |
| google-noto-sans-traditional-chinese-fonts     |                                                              |
| gperftools                                     |                                                              |
| gperftools-devel                               |                                                              |
| gperftools-libs                                |                                                              |
| gpm-static                                     |                                                              |
| grantlee                                       |                                                              |
| grantlee-apidocs                               |                                                              |
| grantlee-devel                                 |                                                              |
| graphviz-graphs                                |                                                              |
| graphviz-guile                                 |                                                              |
| graphviz-java                                  |                                                              |
| graphviz-lua                                   |                                                              |
| graphviz-ocaml                                 |                                                              |
| graphviz-perl                                  |                                                              |
| graphviz-php                                   |                                                              |
| graphviz-python                                |                                                              |
| graphviz-ruby                                  |                                                              |
| graphviz-tcl                                   |                                                              |
| Groff-doc                                      |                                                              |
| groff-perl                                     |                                                              |
| groff-x11                                      |                                                              |
| groovy                                         |                                                              |
| groovy-javadoc                                 |                                                              |
| grub2                                          |                                                              |
| grub2-ppc-modules                              |                                                              |
| grub2-ppc64-modules                            |                                                              |
| gsm-tools                                      |                                                              |
| gsound-devel                                   |                                                              |
| gssdp-utils                                    |                                                              |
| gstreamer                                      |                                                              |
| gstreamer-devel                                |                                                              |
| gstreamer-devel-docs                           |                                                              |
| gstreamer-plugins-bad-free                     |                                                              |
| gstreamer-plugins-bad-free-devel               |                                                              |
| gstreamer-plugins-bad-free-devel-docs          |                                                              |
| gstreamer-plugins-base                         |                                                              |
| gstreamer-plugins-base-devel                   |                                                              |
| gstreamer-plugins-base-devel-docs              |                                                              |
| gstreamer-plugins-base-tools                   |                                                              |
| gstreamer-plugins-good                         |                                                              |
| gstreamer-plugins-good-devel-docs              |                                                              |
| gstreamer-python                               |                                                              |
| gstreamer-python-devel                         |                                                              |
| gstreamer-tools                                |                                                              |
| gstreamer1-devel-docs                          |                                                              |
| gstreamer1-plugins-base-devel-docs             |                                                              |
| gstreamer1-plugins-base-tools                  |                                                              |
| gstreamer1-plugins-ugly-free-devel             |                                                              |
| gtk-vnc                                        |                                                              |
| gtk-vnc-devel                                  |                                                              |
| gtk-vnc-python                                 |                                                              |
| gtk-vnc2-devel                                 |                                                              |
| gtk3-devel-docs                                |                                                              |
| gtk3-immodules                                 |                                                              |
| gtk3-tests                                     |                                                              |
| gtkhtml3                                       |                                                              |
| gtkhtml3-devel                                 |                                                              |
| gtksourceview3-tests                           |                                                              |
| gucharmap                                      |                                                              |
| gucharmap-devel                                |                                                              |
| gucharmap-libs                                 |                                                              |
| gupnp-av-devel                                 |                                                              |
| gupnp-av-docs                                  |                                                              |
| gupnp-dlna-devel                               |                                                              |
| gupnp-dlna-docs                                |                                                              |
| gupnp-docs                                     |                                                              |
| gupnp-igd-python                               |                                                              |
| gutenprint-devel                               |                                                              |
| gutenprint-extras                              |                                                              |
| gutenprint-foomatic                            |                                                              |
| gvfs-tests                                     |                                                              |
| gvnc-devel                                     |                                                              |
| gvnc-tools                                     |                                                              |
| gvncpulse                                      |                                                              |
| gvncpulse-devel                                |                                                              |
| gwenview                                       |                                                              |
| gwenview-libs                                  |                                                              |
| hawkey-devel                                   |                                                              |
| highcontrast-qt                                |                                                              |
| highcontrast-qt4                               |                                                              |
| highcontrast-qt5                               |                                                              |
| hispavoces-pal-diphone                         |                                                              |
| hispavoces-sfl-diphone                         |                                                              |
| hsakmt                                         |                                                              |
| hsakmt-devel                                   |                                                              |
| hspell-devel                                   |                                                              |
| hsqldb                                         |                                                              |
| hsqldb-demo                                    |                                                              |
| hsqldb-javadoc                                 |                                                              |
| hsqldb-manual                                  |                                                              |
| htdig                                          |                                                              |
| html2ps                                        |                                                              |
| http-parser-devel                              |                                                              |
| httpunit                                       |                                                              |
| httpunit-doc                                   |                                                              |
| httpunit-javadoc                               |                                                              |
| i2c-tools-eepromer                             |                                                              |
| i2c-tools-python                               |                                                              |
| ibus-pygtk2                                    |                                                              |
| ibus-qt                                        |                                                              |
| ibus-qt-devel                                  |                                                              |
| ibus-qt-docs                                   |                                                              |
| ibus-rawcode                                   |                                                              |
| ibus-table-devel                               |                                                              |
| ibutils                                        |                                                              |
| ibutils-devel                                  |                                                              |
| ibutils-libs                                   |                                                              |
| icc-profiles-openicc                           |                                                              |
| icon-naming-utils                              |                                                              |
| im-chooser                                     |                                                              |
| im-chooser-common                              |                                                              |
| ImageMagick                                    |                                                              |
| ImageMagick-c++                                |                                                              |
| ImageMagick-c++-devel                          |                                                              |
| ImageMagick-devel                              |                                                              |
| ImageMagick-doc                                |                                                              |
| ImageMagick-perl                               |                                                              |
| imsettings                                     |                                                              |
| imsettings-devel                               |                                                              |
| imsettings-gsettings                           |                                                              |
| imsettings-libs                                |                                                              |
| imsettings-qt                                  |                                                              |
| imsettings-xim                                 |                                                              |
| indent                                         |                                                              |
| infinipath-psm                                 |                                                              |
| infinipath-psm-devel                           |                                                              |
| iniparser                                      |                                                              |
| iniparser-devel                                |                                                              |
| iok                                            |                                                              |
| ipa-gothic-fonts                               |                                                              |
| ipa-mincho-fonts                               |                                                              |
| ipa-pgothic-fonts                              |                                                              |
| ipa-pmincho-fonts                              |                                                              |
| iperf3-devel                                   |                                                              |
| iproute-doc                                    |                                                              |
| ipset-devel                                    |                                                              |
| ipsilon                                        |                                                              |
| ipsilon-authform                               |                                                              |
| ipsilon-authgssapi                             |                                                              |
| ipsilon-authldap                               |                                                              |
| ipsilon-base                                   |                                                              |
| ipsilon-client                                 |                                                              |
| ipsilon-filesystem                             |                                                              |
| ipsilon-infosssd                               |                                                              |
| ipsilon-persona                                |                                                              |
| ipsilon-saml2                                  |                                                              |
| ipsilon-saml2-base                             |                                                              |
| ipsilon-tools-ipa                              |                                                              |
| iputils-sysvinit                               |                                                              |
| isdn4k-utils                                   |                                                              |
| isdn4k-utils-devel                             |                                                              |
| isdn4k-utils-doc                               |                                                              |
| isdn4k-utils-static                            |                                                              |
| isdn4k-utils-vboxgetty                         |                                                              |
| isomd5sum-devel                                |                                                              |
| istack-commons-javadoc                         |                                                              |
| ixpdimm-cli                                    |                                                              |
| ixpdimm-monitor                                |                                                              |
| ixpdimm_sw                                     |                                                              |
| ixpdimm_sw-devel                               |                                                              |
| jai-imageio-core                               |                                                              |
| jai-imageio-core-javadoc                       |                                                              |
| jakarta-taglibs-standard                       |                                                              |
| jakarta-taglibs-standard-javadoc               |                                                              |
| jandex                                         |                                                              |
| jandex-javadoc                                 |                                                              |
| jansson-devel-doc                              |                                                              |
| jarjar                                         |                                                              |
| jarjar-javadoc                                 |                                                              |
| jarjar-maven-plugin                            |                                                              |
| jasper                                         |                                                              |
| jasper-utils                                   |                                                              |
| java-1.6.0-openjdk                             |                                                              |
| java-1.6.0-openjdk-demo                        |                                                              |
| java-1.6.0-openjdk-devel                       |                                                              |
| java-1.6.0-openjdk-javadoc                     |                                                              |
| java-1.6.0-openjdk-src                         |                                                              |
| java-1.7.0-openjdk                             |                                                              |
| java-1.7.0-openjdk-accessibility               |                                                              |
| java-1.7.0-openjdk-demo                        |                                                              |
| java-1.7.0-openjdk-devel                       |                                                              |
| java-1.7.0-openjdk-headless                    |                                                              |
| java-1.7.0-openjdk-javadoc                     |                                                              |
| java-1.7.0-openjdk-src                         |                                                              |
| java-1.8.0-openjdk-accessibility-debug         |                                                              |
| java-1.8.0-openjdk-debug                       |                                                              |
| java-1.8.0-openjdk-demo-debug                  |                                                              |
| java-1.8.0-openjdk-devel-debug                 |                                                              |
| Java-1.8.0-openjdk-headless-debug              |                                                              |
| java-1.8.0-openjdk-javadoc-debug               |                                                              |
| java-1.8.0-openjdk-javadoc-zip-debug           |                                                              |
| java-1.8.0-openjdk-src-debug                   |                                                              |
| java-11-openjdk-debug                          |                                                              |
| java-11-openjdk-demo-debug                     |                                                              |
| java-11-openjdk-devel-debug                    |                                                              |
| java-11-openjdk-headless-debug                 |                                                              |
| java-11-openjdk-javadoc-debug                  |                                                              |
| java-11-openjdk-javadoc-zip-debug              |                                                              |
| java-11-openjdk-jmods-debug                    |                                                              |
| java-11-openjdk-src-debug                      |                                                              |
| jbigkit                                        |                                                              |
| jboss-annotations-1.1-api-javadoc              |                                                              |
| jboss-ejb-3.1-api                              |                                                              |
| jboss-ejb-3.1-api-javadoc                      |                                                              |
| jboss-el-2.2-api                               |                                                              |
| jboss-el-2.2-api-javadoc                       |                                                              |
| jboss-jaxrpc-1.1-api                           |                                                              |
| jboss-jaxrpc-1.1-api-javadoc                   |                                                              |
| jboss-servlet-2.5-api                          |                                                              |
| jboss-servlet-2.5-api-javadoc                  |                                                              |
| jboss-servlet-3.0-api                          |                                                              |
| jboss-servlet-3.0-api-javadoc                  |                                                              |
| jboss-specs-parent                             |                                                              |
| jboss-transaction-1.1-api                      |                                                              |
| jboss-transaction-1.1-api-javadoc              |                                                              |
| jettison                                       |                                                              |
| jettison-javadoc                               |                                                              |
| jetty-annotations                              |                                                              |
| jetty-ant                                      |                                                              |
| jetty-artifact-remote-resources                |                                                              |
| jetty-assembly-descriptors                     |                                                              |
| jetty-build-support                            |                                                              |
| jetty-build-support-javadoc                    |                                                              |
| jetty-client                                   |                                                              |
| jetty-continuation                             |                                                              |
| jetty-deploy                                   |                                                              |
| jetty-distribution-remote-resources            |                                                              |
| jetty-http                                     |                                                              |
| jetty-io                                       |                                                              |
| jetty-jaas                                     |                                                              |
| jetty-jaspi                                    |                                                              |
| jetty-javadoc                                  |                                                              |
| jetty-jmx                                      |                                                              |
| jetty-jndi                                     |                                                              |
| jetty-jsp                                      |                                                              |
| jetty-jspc-maven-plugin                        |                                                              |
| jetty-maven-plugin                             |                                                              |
| jetty-monitor                                  |                                                              |
| jetty-parent                                   |                                                              |
| jetty-plus                                     |                                                              |
| jetty-project                                  |                                                              |
| jetty-proxy                                    |                                                              |
| jetty-rewrite                                  |                                                              |
| jetty-runner                                   |                                                              |
| jetty-security                                 |                                                              |
| jetty-server                                   |                                                              |
| jetty-servlet                                  |                                                              |
| jetty-servlets                                 |                                                              |
| jetty-start                                    |                                                              |
| jetty-test-policy                              |                                                              |
| jetty-test-policy-javadoc                      |                                                              |
| jetty-toolchain                                |                                                              |
| jetty-util                                     |                                                              |
| jetty-util-ajax                                |                                                              |
| jetty-version-maven-plugin                     |                                                              |
| jetty-version-maven-plugin-javadoc             |                                                              |
| jetty-webapp                                   |                                                              |
| jetty-websocket-api                            |                                                              |
| jetty-websocket-client                         |                                                              |
| jetty-websocket-common                         |                                                              |
| jetty-websocket-parent                         |                                                              |
| jetty-websocket-server                         |                                                              |
| jetty-websocket-servlet                        |                                                              |
| jetty-xml                                      |                                                              |
| jing                                           |                                                              |
| jing-javadoc                                   |                                                              |
| jline-demo                                     |                                                              |
| jna-contrib                                    |                                                              |
| jna-javadoc                                    |                                                              |
| joda-convert                                   |                                                              |
| joda-convert-javadoc                           |                                                              |
| js                                             |                                                              |
| js-devel                                       |                                                              |
| jsch-demo                                      |                                                              |
| json-glib-tests                                |                                                              |
| jsr-311                                        |                                                              |
| jsr-311-javadoc                                |                                                              |
| juk                                            |                                                              |
| junit-demo                                     |                                                              |
| k3b                                            |                                                              |
| k3b-common                                     |                                                              |
| k3b-devel                                      |                                                              |
| k3b-libs                                       |                                                              |
| kaccessable                                    |                                                              |
| kaccessible-libs                               |                                                              |
| kivities                                       |                                                              |
| kactivities-devel                              |                                                              |
| kamera                                         |                                                              |
| kate                                           |                                                              |
| kate-devel                                     |                                                              |
| kate-libs                                      |                                                              |
| kate-part                                      |                                                              |
| kcalc                                          |                                                              |
| kcharselect                                    |                                                              |
| kcm-gtk                                        |                                                              |
| kcm_colors                                     |                                                              |
| kcm_touchpad                                   |                                                              |
| kcolorchooser                                  |                                                              |
| kcoloredit                                     |                                                              |
| kde-base-artwork                               |                                                              |
| kde-baseapps                                   |                                                              |
| kde-baseapps-devel                             |                                                              |
| kde-baseapps-libs                              |                                                              |
| kde-filesystem                                 |                                                              |
| kde-l10n                                       |                                                              |
| kde-l10n-Arabic                                |                                                              |
| kde-l10n-Basque                                |                                                              |
| kde-l10n-Bosnian                               |                                                              |
| kde-l10n-British                               |                                                              |
| kde-l10n-Bulgarian                             |                                                              |
| kde-l10n-Catalan                               |                                                              |
| kde-l10n-Catalan-Valencian                     |                                                              |
| kde-l10n-Croatian                              |                                                              |
| kde-l10n-Czech                                 |                                                              |
| kde-l10n-Danish                                |                                                              |
| kde-l10n-Dutch                                 |                                                              |
| kde-l10n-Estonian                              |                                                              |
| kde-l10n-Farsi                                 |                                                              |
| kde-l10n-Finnish                               |                                                              |
| kde-l10n-Galician                              |                                                              |
| kde-l10n-Greek                                 |                                                              |
| kde-l10n-Hebrew                                |                                                              |
| kde-l10n-Hungarian                             |                                                              |
| kde-l10n-Icelandic                             |                                                              |
| kde-l10n-Interlingua                           |                                                              |
| kde-l10n-Irish                                 |                                                              |
| kde-l10n-Kazakh                                |                                                              |
| kde-l10n-Khmer                                 |                                                              |
| kde-l10n-Latvian                               |                                                              |
| kde-l10n-Lithuanian                            |                                                              |
| kde-l10n-LowSaxon                              |                                                              |
| kde-l10n-Norwegian                             |                                                              |
| kde-l10n-Norwegian-Nynorsk                     |                                                              |
| kde-l10n-Polish                                |                                                              |
| kde-l10n-Portuguese                            |                                                              |
| kde-l10n-Romanian                              |                                                              |
| kde-l10n-Serbian                               |                                                              |
| kde-l10n-Slovak                                |                                                              |
| kde-l10n-Slovenian                             |                                                              |
| kde-l10n-Swedish                               |                                                              |
| kde-l10n-Tajik                                 |                                                              |
| kde-l10n-Thai                                  |                                                              |
| kde-l10n-Turkish                               |                                                              |
| kde-l10n-Ukrainian                             |                                                              |
| kde-l10n-Uyghur                                |                                                              |
| kde-l10n-Vietnamese                            |                                                              |
| kde-l10n-Walloon                               |                                                              |
| kde-plasma-networkmanagement                   |                                                              |
| kde-plasma-networkmanagement-libreswan         |                                                              |
| kde-plasma-networkmanagement-libs              |                                                              |
| kde-plasma-networkmanagement-mobile            |                                                              |
| kde-print-manager                              |                                                              |
| kde-runtime                                    |                                                              |
| kde-runtime-devel                              |                                                              |
| kde-runtime-drkonqi                            |                                                              |
| kde-runtime-libs                               |                                                              |
| kde-settings                                   |                                                              |
| kde-settings-ksplash                           |                                                              |
| kde-settings-minimal                           |                                                              |
| kde-settings-plasma                            |                                                              |
| kde-settings-pulseaudio                        |                                                              |
| kde-style-oxygen                               |                                                              |
| kde-style-phase                                |                                                              |
| kde-wallpapers                                 |                                                              |
| kde-workspace                                  |                                                              |
| kde-workspace-devel                            |                                                              |
| kde-workspace-ksplash-themes                   |                                                              |
| kde-workspace-libs                             |                                                              |
| kdeaccessibility                               |                                                              |
| kdeadmin                                       |                                                              |
| kdeartwork                                     |                                                              |
| kdeartwork-screensavers                        |                                                              |
| kdeartwork-sounds                              |                                                              |
| kdeartwork-wallpapers                          |                                                              |
| kdeclassic-cursor-theme                        |                                                              |
| kdegraphics                                    |                                                              |
| kdegraphics-devel                              |                                                              |
| kdegraphics-libs                               |                                                              |
| kdegraphics-strigi-analyzer                    |                                                              |
| kdegraphics-thumbnailers                       |                                                              |
| kdelibs                                        |                                                              |
| kdelibs-apidocs                                |                                                              |
| kdelibs-common                                 |                                                              |
| kdelibs-devel                                  |                                                              |
| kdelibs-ktexteditor                            |                                                              |
| kdemultimedia                                  |                                                              |
| kdemultimedia-common                           |                                                              |
| kdemultimedia-devel                            |                                                              |
| kdemultimedia-libs                             |                                                              |
| kdenetwork                                     |                                                              |
| kdenetwork-common                              |                                                              |
| kdenetwork-devel                               |                                                              |
| kdenetwork-fileshare-samba                     |                                                              |
| kdenetwork-kdnssd                              |                                                              |
| kdenetwork-kget                                |                                                              |
| kdenetwork-kget-libs                           |                                                              |
| kdenetwork-kopete                              |                                                              |
| kdenetwork-kopete-devel                        |                                                              |
| kdenetwork-kopete-libs                         |                                                              |
| kdenetwork-krdc                                |                                                              |
| kdenetwork-krdc-devel                          |                                                              |
| kdenetwork-krdc-libs                           |                                                              |
| kdenetwork-krfb                                |                                                              |
| kdenetwork-krfb-libs                           |                                                              |
| kdepim                                         |                                                              |
| kdepim-devel                                   |                                                              |
| kdepim-libs                                    |                                                              |
| kdepim-runtime                                 |                                                              |
| kdepim-runtime-libs                            |                                                              |
| kdepimlibs                                     |                                                              |
| kdepimlibs-akonadi                             |                                                              |
| kdepimlibs-apidocs                             |                                                              |
| kdepimlibs-devel                               |                                                              |
| kdepimlibs-kxmlrpcclient                       |                                                              |
| kdeplasma-addons                               |                                                              |
| kdeplasma-addons-devel                         |                                                              |
| kdeplasma-addons-libs                          |                                                              |
| kdesdk                                         |                                                              |
| kdesdk-cervisia                                |                                                              |
| kdesdk-common                                  |                                                              |
| kdesdk-devel                                   |                                                              |
| kdesdk-dolphin-plugins                         |                                                              |
| kdesdk-kapptemplate                            |                                                              |
| kdesdk-kapptemplate-template                   |                                                              |
| kdesdk-kcachegrind                             |                                                              |
| kdesdk-kioslave                                |                                                              |
| kdesdk-kmtrace                                 |                                                              |
| kdesdk-kmtrace-devel                           |                                                              |
| kdesdk-kmtrace-libs                            |                                                              |
| kdesdk-kompare                                 |                                                              |
| kdesdk-kompare-devel                           |                                                              |
| kdesdk-kompare-libs                            |                                                              |
| kdesdk-kpartloader                             |                                                              |
| kdesdk-kstartperf                              |                                                              |
| kdesdk-kuiviewer                               |                                                              |
| kdesdk-lokalize                                |                                                              |
| kdesdk-okteta                                  |                                                              |
| kdesdk-okteta-devel                            |                                                              |
| kdesdk-okteta-libs                             |                                                              |
| kdesdk-poxml                                   |                                                              |
| kdesdk-scripts                                 |                                                              |
| kdesdk-strigi-analyzer                         |                                                              |
| kdesdk-thumbnailers                            |                                                              |
| kdesdk-umbrello                                |                                                              |
| kdeutils                                       |                                                              |
| kdeutils-common                                |                                                              |
| kdeutils-minimal                               |                                                              |
| kdf                                            |                                                              |
| kernel-bootwrapper                             |                                                              |
| kernel-rt-doc                                  |                                                              |
| kernel-rt-trace                                |                                                              |
| kernel-rt-trace-devel                          |                                                              |
| kernel-rt-trace-kvm                            |                                                              |
| keytool-maven-plugin                           |                                                              |
| keytool-maven-plugin-javadoc                   |                                                              |
| kgamma                                         |                                                              |
| kgpg                                           |                                                              |
| kgreeter-plugins                               |                                                              |
| khotkeys                                       |                                                              |
| khotkeys-libs                                  |                                                              |
| kiconedit                                      |                                                              |
| kinfocenter                                    |                                                              |
| kio_sysinfo                                    |                                                              |
| kmag                                           |                                                              |
| kmenuedit                                      |                                                              |
| kmix                                           |                                                              |
| kmod-oracleasm                                 |                                                              |
| kolourpaint                                    |                                                              |
| kolourpaint-libs                               |                                                              |
| konkretcmpi                                    |                                                              |
| konkretcmpi-devel                              |                                                              |
| konkretcmpi-python                             |                                                              |
| konsole                                        |                                                              |
| konsole-part                                   |                                                              |
| kross-interpreters                             |                                                              |
| kross-python                                   |                                                              |
| kross-ruby                                     |                                                              |
| kruler                                         |                                                              |
| ksaneplugin                                    |                                                              |
| kscreen                                        |                                                              |
| ksnapshot                                      |                                                              |
| ksshaskpass                                    |                                                              |
| ksysguard                                      |                                                              |
| ksysguard-libs                                 |                                                              |
| ksysguardd                                     |                                                              |
| ktimer                                         |                                                              |
| kwallet                                        |                                                              |
| kwin                                           |                                                              |
| kwin-gles                                      |                                                              |
| kwin-gles-libs                                 |                                                              |
| kwin-libs                                      |                                                              |
| kwrite                                         |                                                              |
| kxml                                           |                                                              |
| kxml-javadoc                                   |                                                              |
| lapack64-devel                                 |                                                              |
| lapack64-static                                |                                                              |
| lasso-devel                                    |                                                              |
| lasso-python                                   |                                                              |
| latencytop                                     |                                                              |
| latencytop-common                              |                                                              |
| latencytop-tui                                 |                                                              |
| latrace                                        |                                                              |
| lcms2-utils                                    |                                                              |
| ldns-doc                                       |                                                              |
| ldns-python                                    |                                                              |
| libabw-devel                                   |                                                              |
| libabw-doc                                     |                                                              |
| libabw-tools                                   |                                                              |
| libappindicator                                |                                                              |
| libappindicator-devel                          |                                                              |
| libappindicator-docs                           |                                                              |
| libappstream-glib-builder                      |                                                              |
| libappstream-glib-builder-devel                |                                                              |
| libart_lgpl                                    |                                                              |
| libart_lgpl-devel                              |                                                              |
| libasan-static                                 |                                                              |
| libavc1394-devel                               |                                                              |
| libbase-javadoc                                |                                                              |
| libblockdev-btrfs                              |                                                              |
| libblockdev-btrfs-devel                        |                                                              |
| libblockdev-dm-devel                           |                                                              |
| libblockdev-kbd-devel                          |                                                              |
| libblockdev-mpath-devel                        |                                                              |
| libblockdev-nvdimm-devel                       |                                                              |
| libbluedevil                                   |                                                              |
| libbluedevil-devel                             |                                                              |
| libbluray-devel                                |                                                              |
| libbonobo                                      |                                                              |
| libbonobo-devel                                |                                                              |
| libbonoboui                                    |                                                              |
| libbonoboui-devel                              |                                                              |
| libbytesize-devel                              |                                                              |
| libcacard-tools                                |                                                              |
| libcap-ng-python                               |                                                              |
| libcdr-devel                                   |                                                              |
| libcdr-doc                                     |                                                              |
| libcdr-tools                                   |                                                              |
| libcgroup-devel                                |                                                              |
| libchamplain-demos                             |                                                              |
| libchewing                                     |                                                              |
| libchewing-devel                               |                                                              |
| libchewing-python                              |                                                              |
| libcmis-devel                                  |                                                              |
| libcmis-tools                                  |                                                              |
| libcmpiutil                                    |                                                              |
| libcmpiutil-devel                              |                                                              |
| libcryptui                                     |                                                              |
| libcryptui-devel                               |                                                              |
| libdb-devel-static                             |                                                              |
| libdb-java                                     |                                                              |
| libdb-java-devel                               |                                                              |
| libdb-tcl                                      |                                                              |
| libdb-tcl-devel                                |                                                              |
| libdbi                                         |                                                              |
| libdbi-dbd-mysql                               |                                                              |
| libdbi-dbd-pgsql                               |                                                              |
| libdbi-dbd-sqlite                              |                                                              |
| libdbi-devel                                   |                                                              |
| libdbi-drivers                                 |                                                              |
| libdbusmenu-gtk2                               |                                                              |
| libdbusmenu-gtk2-devel                         |                                                              |
| libdbusmenu-jsonloader                         |                                                              |
| libdbusmenu-jsonloader-devel                   |                                                              |
| libdbusmenu-tools                              |                                                              |
| libdhash-devel                                 |                                                              |
| libdmapsharing-devel                           |                                                              |
| libdmmp-devel                                  |                                                              |
| libdmx-devel                                   |                                                              |
| libdnet-progs                                  |                                                              |
| libdnet-python                                 |                                                              |
| libdv-tools                                    |                                                              |
| libdvdnav-devel                                |                                                              |
| libeasyfc-devel                                |                                                              |
| libeasyfc-gobject-devel                        |                                                              |
| libee                                          |                                                              |
| libee-devel                                    |                                                              |
| libee-utils                                    |                                                              |
| libesmtp                                       |                                                              |
| libesmtp-devel                                 |                                                              |
| libestr-devel                                  |                                                              |
| libetonyek-doc                                 |                                                              |
| libetonyek-tools                               |                                                              |
| libevdev-utils                                 |                                                              |
| libexif-doc                                    |                                                              |
| libexttextcat-devel                            |                                                              |
| libexttextcat-tools                            |                                                              |
| libfastjson-devel                              |                                                              |
| libfonts-javadoc                               |                                                              |
| libformula-javadoc                             |                                                              |
| libfprint-devel                                |                                                              |
| libfreehand-devel                              |                                                              |
| libfreehand-doc                                |                                                              |
| libfreehand-tools                              |                                                              |
| libgcab1-devel                                 |                                                              |
| libgccjit                                      |                                                              |
| libgdither-devel                               |                                                              |
| libgee06                                       |                                                              |
| libgee06-devel                                 |                                                              |
| libgepub                                       |                                                              |
| libgepub-devel                                 |                                                              |
| libgfortran-static                             |                                                              |
| libgfortran4                                   |                                                              |
| libgfortran5                                   |                                                              |
| libglade2                                      |                                                              |
| libglade2-devel                                |                                                              |
| libGLEWmx                                      |                                                              |
| libgnat                                        |                                                              |
| libgnat-devel                                  |                                                              |
| libgnat-static                                 |                                                              |
| libgnome                                       |                                                              |
| libgnome-devel                                 |                                                              |
| libgnome-keyring-devel                         |                                                              |
| libgnomecanvas                                 |                                                              |
| libgnomecanvas-devel                           |                                                              |
| libgnomeui                                     |                                                              |
| libgnomeui-devel                               |                                                              |
| libgo                                          |                                                              |
| libgo-devel                                    |                                                              |
| libgo-static                                   |                                                              |
| libgovirt-devel                                |                                                              |
| libgxim                                        |                                                              |
| libgxim-devel                                  |                                                              |
| libgxps-tools                                  |                                                              |
| libhangul-devel                                |                                                              |
| libhbaapi-devel                                |                                                              |
| libhif-devel                                   |                                                              |
| libibcommon                                    |                                                              |
| libibcommon-devel                              |                                                              |
| libibcommon-static                             |                                                              |
| libical-glib                                   |                                                              |
| libical-glib-devel                             |                                                              |
| libical-glib-doc                               |                                                              |
| libid3tag                                      |                                                              |
| libid3tag-devel                                |                                                              |
| libiec61883-utils                              |                                                              |
| libieee1284-python                             |                                                              |
| libimobiledevice-python                        |                                                              |
| libimobiledevice-utils                         |                                                              |
| libindicator                                   |                                                              |
| libindicator-devel                             |                                                              |
| libindicator-gtk3-tools                        |                                                              |
| libindicator-tools                             |                                                              |
| libinvm-cim                                    |                                                              |
| libinvm-cim-devel                              |                                                              |
| libinvm-cli                                    |                                                              |
| libinvm-cli-devel                              |                                                              |
| libinvm-i18n                                   |                                                              |
| libinvm-i18n-devel                             |                                                              |
| libiodbc                                       |                                                              |
| libiodbc-devel                                 |                                                              |
| libipa_hbac-devel                              |                                                              |
| libiptcdata-devel                              |                                                              |
| libiptcdata-python                             |                                                              |
| libitm-static                                  |                                                              |
| libixpdimm-cim                                 |                                                              |
| libixpdimm-core                                |                                                              |
| libjpeg-turbo-static                           |                                                              |
| libkcddb                                       |                                                              |
| libkcddb-devel                                 |                                                              |
| libkcompactdisc                                |                                                              |
| libkcompactdisc-devel                          |                                                              |
| libkdcraw                                      |                                                              |
| libkdcraw-devel                                |                                                              |
| libkexiv2                                      |                                                              |
| libkexiv2-devel                                |                                                              |
| libkipi                                        |                                                              |
| libkipi-devel                                  |                                                              |
| libkkc-devel                                   |                                                              |
| libkc-tools                                    |                                                              |
| libksane                                       |                                                              |
| libksane-devel                                 |                                                              |
| libkscreen                                     |                                                              |
| libkscreen-devel                               |                                                              |
| libkworkspace                                  |                                                              |
| liblayout-javadoc                              |                                                              |
| libloader-javadoc                              |                                                              |
| liblognorm-devel                               |                                                              |
| liblouis-devel                                 |                                                              |
| liblouis-doc                                   |                                                              |
| liblouis-utils                                 |                                                              |
| libmatchbox-devel                              |                                                              |
| libmaxminddb-devel-debuginfo                   |                                                              |
| libmbim-devel                                  |                                                              |
| libmediaart-devel                              |                                                              |
| libmediaart-tests                              |                                                              |
| libmnl-static                                  |                                                              |
| libmodman-devel                                |                                                              |
| libmpc-devel                                   |                                                              |
| libmsn                                         |                                                              |
| libmsn-devel                                   |                                                              |
| libmspub-devel                                 |                                                              |
| libmspub-doc                                   |                                                              |
| libmspub-tools                                 |                                                              |
| libmtp-examples                                |                                                              |
| libmudflap                                     |                                                              |
| libmudflap-devel                               |                                                              |
| libmudflap-static                              |                                                              |
| libmwaw-devel                                  |                                                              |
| libmwaw-doc                                    |                                                              |
| libmwaw-tools                                  |                                                              |
| libmx                                          |                                                              |
| libmx-devel                                    |                                                              |
| libmx-docs                                     |                                                              |
| libndp-devel                                   |                                                              |
| libnetfilter_cthelper-devel                    |                                                              |
| libnetfilter_cttimeout-devel                   |                                                              |
| libnl                                          |                                                              |
| libnl-devel                                    |                                                              |
| libnm-gtk                                      |                                                              |
| libnm-gtk-devel                                |                                                              |
| libntlm                                        |                                                              |
| libntlm-devel                                  |                                                              |
| libobjc                                        |                                                              |
| libodfgen-doc                                  |                                                              |
| libofa                                         |                                                              |
| libofa-devel                                   |                                                              |
| liboil                                         |                                                              |
| liboil-devel                                   |                                                              |
| libopenraw-pixbuf-loader                       |                                                              |
| liborcus-devel                                 |                                                              |
| liborcus-doc                                   |                                                              |
| liborcus-tools                                 |                                                              |
| libosinfo-devel                                |                                                              |
| libosinfo-vala                                 |                                                              |
| libotf-devel                                   |                                                              |
| libpagemaker-devel                             |                                                              |
| libpagemaker-doc                               |                                                              |
| libpagemaker-tools                             |                                                              |
| libpinyin-devel                                |                                                              |
| libpinyin-tools                                |                                                              |
| libpipeline-devel                              |                                                              |
| libplist-python                                |                                                              |
| libpmemcto                                     |                                                              |
| libpmemcto-debug                               |                                                              |
| libpmemcto-devel                               |                                                              |
| libpmemobj++-devel                             |                                                              |
| libpng-static                                  |                                                              |
| libpng12-devel                                 |                                                              |
| libproxy-kde                                   |                                                              |
| libpst                                         |                                                              |
| libpst-devel                                   |                                                              |
| libpst-devel-doc                               |                                                              |
| libpst-doc                                     |                                                              |
| libpst-python                                  |                                                              |
| libpurple-perl                                 |                                                              |
| libpurple-tcl                                  |                                                              |
| libqmi-devel                                   |                                                              |
| libquadmath-static                             |                                                              |
| LibRaw-static                                  |                                                              |
| librelp-devel                                  |                                                              |
| libreoffice                                    |                                                              |
| libreoffice-bsh                                |                                                              |
| libreoffice-glade                              |                                                              |
| libreoffice-librelogo                          |                                                              |
| libreoffice-nlpsolver                          |                                                              |
| libreoffice-officebean                         |                                                              |
| libreoffice-officebean-common                  |                                                              |
| libreoffice-postgresql                         |                                                              |
| libreoffice-rhino                              |                                                              |
| libreofficekit-devel                           |                                                              |
| libreport-compat                               |                                                              |
| libreport-devel                                |                                                              |
| libreport-gtk-devel                            |                                                              |
| libreport-web-devel                            |                                                              |
| librepository-javadoc                          |                                                              |
| librevenge-doc                                 |                                                              |
| libselinux-static                              |                                                              |
| libsemanage-static                             |                                                              |
| libserializer-javadoc                          |                                                              |
| libsexy                                        |                                                              |
| libsexy-devel                                  |                                                              |
| libsmbios-devel                                |                                                              |
| libsndfile-utils                               |                                                              |
| libsolv-demo                                   |                                                              |
| libspiro-devel                                 |                                                              |
| libss-devel                                    |                                                              |
| libssh2                                        | 由于依赖 `qemu-kvm`, `libssh2` 软件包在 RHEL 8.0 中临时可用。从 RHEL 8.1 开始,QEMU 模拟器使用 `libssh` 库, `libssh2` 已被删除。 |
| libssh2-devel                                  |                                                              |
| libsss_certmap-devel                           |                                                              |
| libsss_idmap-devel                             |                                                              |
| libsss_simpleifp-devel                         |                                                              |
| libstaroffice-devel                            |                                                              |
| libstaroffice-doc                              |                                                              |
| libstaroffice-tools                            |                                                              |
| libstoragemgmt-targetd-plugin                  |                                                              |
| libtar-devel                                   |                                                              |
| libteam-devel                                  |                                                              |
| libtheora-devel-docs                           |                                                              |
| libtiff-static                                 |                                                              |
| libtimezonemap-devel                           |                                                              |
| libtnc                                         |                                                              |
| libtnc-devel                                   |                                                              |
| libtranslit                                    |                                                              |
| libtranslit-devel                              |                                                              |
| libtranslit-icu                                |                                                              |
| libtranslit-m17n                               |                                                              |
| libtsan-static                                 |                                                              |
| libuninameslist-devel                          |                                                              |
| libunwind                                      |                                                              |
| libunwind-devel                                |                                                              |
| libusal-devel                                  |                                                              |
| libusb-static                                  |                                                              |
| libusbmuxd-utils                               |                                                              |
| libuser-devel                                  |                                                              |
| libusnic_verbs                                 |                                                              |
| libvdpau-docs                                  |                                                              |
| libverto-glib                                  |                                                              |
| libverto-glib-devel                            |                                                              |
| libverto-libevent-devel                        |                                                              |
| libverto-tevent                                |                                                              |
| libverto-tevent-devel                          |                                                              |
| libvirt-cim                                    |                                                              |
| libvirt-daemon-driver-lxc                      |                                                              |
| libvirt-daemon-lxc                             |                                                              |
| libvirt-gconfig-devel                          |                                                              |
| libvirt-glib-devel                             |                                                              |
| libvirt-gobject-devel                          |                                                              |
| libvirt-java                                   |                                                              |
| libvirt-java-devel                             |                                                              |
| libvirt-java-javadoc                           |                                                              |
| libvirt-login-shell                            |                                                              |
| libvirt-snmp                                   |                                                              |
| libvisio-doc                                   |                                                              |
| libvisio-tools                                 |                                                              |
| libvma-devel                                   |                                                              |
| libvma-utils                                   |                                                              |
| libvoikko-devel                                |                                                              |
| libvpx-utils                                   |                                                              |
| libwebp-java                                   |                                                              |
| libwebp-tools                                  |                                                              |
| libwpd-tools                                   |                                                              |
| libwpg-tools                                   |                                                              |
| libwps-tools                                   |                                                              |
| libwvstreams                                   |                                                              |
| libwvstreams-devel                             |                                                              |
| libwvstreams-static                            |                                                              |
| libxcb-doc                                     |                                                              |
| libXevie                                       |                                                              |
| libXevie-devel                                 |                                                              |
| libXfont                                       |                                                              |
| libXfont-devel                                 |                                                              |
| libxml2-static                                 |                                                              |
| libxslt-python                                 |                                                              |
| libzapojit                                     |                                                              |
| libzapojit-devel                               |                                                              |
| libzmf-devel                                   |                                                              |
| libzmf-doc                                     |                                                              |
| libzmf-tools                                   |                                                              |
| lldpad-devel                                   |                                                              |
| log4cxx                                        |                                                              |
| log4cxx-devel                                  |                                                              |
| log4j-manual                                   |                                                              |
| lpsolve-devel                                  |                                                              |
| lua-static                                     |                                                              |
| lvm2-cluster                                   |                                                              |
| lvm2-python-libs                               |                                                              |
| lvm2-sysvinit                                  |                                                              |
| lz4-static                                     |                                                              |
| m17n-contrib                                   |                                                              |
| m17n-contrib-extras                            |                                                              |
| m17n-db-devel                                  |                                                              |
| m17n-db-extras                                 |                                                              |
| m17n-lib-devel                                 |                                                              |
| m17n-lib-tools                                 |                                                              |
| m2crypto                                       |                                                              |
| malaga-devel                                   |                                                              |
| man-pages-cs                                   |                                                              |
| man-pages-es                                   |                                                              |
| man-pages-es-extra                             |                                                              |
| man-pages-fr                                   |                                                              |
| man-pages-it                                   |                                                              |
| man-pages-ja                                   |                                                              |
| man-pages-ko                                   |                                                              |
| man-pages-pl                                   |                                                              |
| man-pages-ru                                   |                                                              |
| man-pages-zh-CN                                |                                                              |
| mariadb-bench                                  |                                                              |
| marisa-devel                                   |                                                              |
| marisa-perl                                    |                                                              |
| marisa-python                                  |                                                              |
| marisa-ruby                                    |                                                              |
| marisa-tools                                   |                                                              |
| maven-changes-plugin                           |                                                              |
| maven-changes-plugin-javadoc                   |                                                              |
| maven-deploy-plugin                            |                                                              |
| maven-deploy-plugin-javadoc                    |                                                              |
| maven-doxia-module-fo                          |                                                              |
| maven-ear-plugin                               |                                                              |
| maven-ear-plugin-javadoc                       |                                                              |
| maven-ejb-plugin                               |                                                              |
| maven-ejb-plugin-javadoc                       |                                                              |
| maven-error-diagnostics                        |                                                              |
| maven-gpg-plugin                               |                                                              |
| maven-gpg-plugin-javadoc                       |                                                              |
| maven-istack-commons-plugin                    |                                                              |
| maven-jarsigner-plugin                         |                                                              |
| maven-jarsigner-plugin-javadoc                 |                                                              |
| maven-javadoc-plugin                           |                                                              |
| maven-javadoc-plugin-javadoc                   |                                                              |
| maven-jxr                                      |                                                              |
| maven-jxr-javadoc                              |                                                              |
| maven-osgi                                     |                                                              |
| maven-osgi-javadoc                             |                                                              |
| maven-plugin-jxr                               |                                                              |
| maven-project-info-reports-plugin              |                                                              |
| maven-project-info-reports-plugin-javadoc      |                                                              |
| maven-release                                  |                                                              |
| maven-release-javadoc                          |                                                              |
| maven-release-manager                          |                                                              |
| maven-release-plugin                           |                                                              |
| maven-reporting-exec                           |                                                              |
| maven-repository-builder                       |                                                              |
| maven-repository-builder-javadoc               |                                                              |
| maven-scm                                      |                                                              |
| maven-scm-javadoc                              |                                                              |
| maven-scm-test                                 |                                                              |
| maven-shared-jar                               |                                                              |
| maven-shared-jar-javadoc                       |                                                              |
| maven-site-plugin                              |                                                              |
| maven-site-plugin-javadoc                      |                                                              |
| maven-verifier-plugin                          |                                                              |
| maven-verifier-plugin-javadoc                  |                                                              |
| maven-wagon-provider-test                      |                                                              |
| maven-wagon-scm                                |                                                              |
| maven-war-plugin                               |                                                              |
| maven-war-plugin-javadoc                       |                                                              |
| mdds-devel                                     |                                                              |
| meanwhile-devel                                |                                                              |
| meanwhile-doc                                  |                                                              |
| memcached-devel                                |                                                              |
| memstomp                                       |                                                              |
| mesa-demos                                     |                                                              |
| mesa-libxatracker-devel                        |                                                              |
| mesa-private-llvm                              |                                                              |
| mesa-private-llvm-devel                        |                                                              |
| metacity-devel                                 |                                                              |
| mgetty                                         | 可使用 `agetty` 通过串行进行登录。用户可以使用其他方式进行传真（网页传真、多功能打印机等）。 |
| mgetty-sendfax                                 |                                                              |
| mgetty-viewfax                                 |                                                              |
| mgetty-voice                                   |                                                              |
| migrationtools                                 |                                                              |
| minizip                                        |                                                              |
| minizip-devel                                  |                                                              |
| mipv6-daemon                                   |                                                              |
| mkbootdisk                                     |                                                              |
| mobile-broadband-provider-info-devel           |                                                              |
| mod_revocator                                  |                                                              |
| ModemManager-vala                              |                                                              |
| mono-icon-theme                                |                                                              |
| mozjs17                                        |                                                              |
| mozjs17-devel                                  |                                                              |
| mozjs24                                        |                                                              |
| mozjs24-devel                                  |                                                              |
| mpage                                          |                                                              |
| mpich-3.0-autoload                             |                                                              |
| mpich-3.0-doc                                  |                                                              |
| mpich-3.2-autoload                             |                                                              |
| mpich-3.2-doc                                  |                                                              |
| mpitests-compat-openmpi16                      |                                                              |
| msv-demo                                       |                                                              |
| msv-msv                                        |                                                              |
| msv-rngconv                                    |                                                              |
| msv-xmlgen                                     |                                                              |
| mvapich2-2.0-devel                             |                                                              |
| mvapich2-2.0-doc                               |                                                              |
| mvapich2-2.0-psm-devel                         |                                                              |
| mvapich2-2.2-devel                             |                                                              |
| mvapich2-2.2-doc                               |                                                              |
| mvapich2-2.2-psm-devel                         |                                                              |
| mvapich2-2.2-psm2-devel                        |                                                              |
| mvapich23-devel                                |                                                              |
| mvapich23-doc                                  |                                                              |
| mvapich23-psm-devel                            |                                                              |
| mvapich23-psm2-devel                           |                                                              |
| nagios-plugins-bacula                          |                                                              |
| nasm-doc                                       |                                                              |
| nasm-rdoff                                     |                                                              |
| ncurses-static                                 |                                                              |
| nekohtml                                       |                                                              |
| nekohtml-demo                                  |                                                              |
| nekohtml-javadoc                               |                                                              |
| nepomuk-core                                   |                                                              |
| nepomuk-core-devel                             |                                                              |
| nepomuk-core-libs                              |                                                              |
| nepomuk-widgets                                |                                                              |
| nepomuk-widgets-devel                          |                                                              |
| net-snmp-gui                                   |                                                              |
| net-snmp-python                                |                                                              |
| net-snmp-sysvinit                              |                                                              |
| netsniff-ng                                    |                                                              |
| NetworkManager-glib                            |                                                              |
| NetworkManager-glib-devel                      |                                                              |
| newt-static                                    |                                                              |
| nfsometer                                      |                                                              |
| nfstest                                        |                                                              |
| nhn-nanum-brush-fonts                          |                                                              |
| nhn-nanum-fonts-common                         |                                                              |
| nhn-nanum-myeongjo-fonts                       |                                                              |
| nhn-nanum-pen-fonts                            |                                                              |
| nmap-frontend                                  |                                                              |
| nss-pem                                        |                                                              |
| nss-pkcs11-devel                               |                                                              |
| nss_compat_ossl                                |                                                              |
| nss_compat_ossl-devel                          |                                                              |
| ntp-doc                                        |                                                              |
| ntp-perl                                       |                                                              |
| nuvola-icon-theme                              |                                                              |
| nuxwdog                                        |                                                              |
| nuxwdog-client-java                            |                                                              |
| nuxwdog-client-perl                            |                                                              |
| nuxwdog-devel                                  |                                                              |
| obex-data-server                               |                                                              |
| obexd                                          |                                                              |
| objectweb-anttask                              |                                                              |
| objectweb-anttask-javadoc                      |                                                              |
| ocaml-brlapi                                   |                                                              |
| ocaml-calendar                                 |                                                              |
| ocaml-calendar-devel                           |                                                              |
| ocaml-csv                                      |                                                              |
| ocaml-csv-devel                                |                                                              |
| ocaml-curses                                   |                                                              |
| ocaml-curses-devel                             |                                                              |
| ocaml-docs                                     |                                                              |
| ocaml-emacs                                    |                                                              |
| ocaml-fileutils                                |                                                              |
| ocaml-fileutils-devel                          |                                                              |
| ocaml-gettext                                  |                                                              |
| ocaml-gettext-devel                            |                                                              |
| ocaml-libvirt                                  |                                                              |
| ocaml-libvirt-devel                            |                                                              |
| ocaml-ocamlbuild-doc                           |                                                              |
| ocaml-source                                   |                                                              |
| ocaml-x11                                      |                                                              |
| ocaml-xml-light                                |                                                              |
| ocaml-xml-light-devel                          |                                                              |
| oci-register-machine                           |                                                              |
| okular                                         |                                                              |
| okular-devel                                   |                                                              |
| okular-libs                                    |                                                              |
| okular-part                                    |                                                              |
| opa-libopamgt-devel                            |                                                              |
| opal                                           |                                                              |
| opal-devel                                     |                                                              |
| open-vm-tools-devel                            |                                                              |
| open-vm-tools-test                             |                                                              |
| opencc                                         |                                                              |
| opencc-devel                                   |                                                              |
| opencc-tools                                   |                                                              |
| openchange-client                              |                                                              |
| openchange-devel                               |                                                              |
| openchange-devel-docs                          |                                                              |
| opencv-devel-docs                              |                                                              |
| opencv-python                                  |                                                              |
| OpenEXR                                        |                                                              |
| openhpi-devel                                  |                                                              |
| OpenIPMI-modalias                              |                                                              |
| openjpeg-libs                                  |                                                              |
| openldap-servers                               |                                                              |
| openldap-servers-sql                           |                                                              |
| openlmi                                        |                                                              |
| openlmi-account                                |                                                              |
| openlmi-account-doc                            |                                                              |
| openlmi-fan                                    |                                                              |
| openlmi-fan-doc                                |                                                              |
| openlmi-hardware                               |                                                              |
| openlmi-hardware-doc                           |                                                              |
| openlmi-indicationmanager-libs                 |                                                              |
| openlmi-indicationmanager-libs-devel           |                                                              |
| openlmi-journald                               |                                                              |
| openlmi-journald-doc                           |                                                              |
| openlmi-logicalfile                            |                                                              |
| openlmi-logicalfile-doc                        |                                                              |
| openlmi-networking                             |                                                              |
| openlmi-networking-doc                         |                                                              |
| openlmi-pcp                                    |                                                              |
| openlmi-powermanagement                        |                                                              |
| openLMI-powermanagement-doc                    |                                                              |
| openlmi-providers                              |                                                              |
| openlmi-providers-devel                        |                                                              |
| openlmi-python-base                            |                                                              |
| openlmi-python-providers                       |                                                              |
| openlmi-python-test                            |                                                              |
| openlmi-realmd                                 |                                                              |
| openlmi-realmd-doc                             |                                                              |
| openlmi-service                                |                                                              |
| openlmi-service-doc                            |                                                              |
| openlmi-software                               |                                                              |
| openlmi-software-doc                           |                                                              |
| openlmi-storage                                |                                                              |
| openlmi-storage-doc                            |                                                              |
| openlmi-tools                                  |                                                              |
| openlmi-tools-doc                              |                                                              |
| openobex                                       | 用户可以使用 `gnome-bluetooth` 通过蓝牙在 PC 和移动设备间传输文件,或使用 `gvfs-afc` 在移动设备中读取文件。使用 OBEX 协议的应用程序需要被重写。 |
| openobex-apps                                  |                                                              |
| openobex-devel                                 |                                                              |
| openscap-containers                            |                                                              |
| openslp-devel                                  |                                                              |
| openslp-server                                 |                                                              |
| opensm-static                                  |                                                              |
| openssh-server-sysvinit                        |                                                              |
| openssl-static                                 |                                                              |
| openssl098e                                    |                                                              |
| openvswitch                                    |                                                              |
| openvswitch-controller                         |                                                              |
| openvswitch-test                               |                                                              |
| openwsman-perl                                 |                                                              |
| openwsman-ruby                                 |                                                              |
| oprofile-devel                                 |                                                              |
| oprofile-gui                                   |                                                              |
| oprofile-jit                                   |                                                              |
| optipng                                        |                                                              |
| ORBit2                                         |                                                              |
| ORBit2-devel                                   |                                                              |
| orc-doc                                        |                                                              |
| ortp                                           |                                                              |
| ortp-devel                                     |                                                              |
| oscilloscope                                   |                                                              |
| oxygen-cursor-themes                           |                                                              |
| oxygen-gtk                                     |                                                              |
| oxygen-gtk2                                    |                                                              |
| oxygen-gtk3                                    |                                                              |
| oxygen-icon-theme                              |                                                              |
| PackageKit-yum-plugin                          |                                                              |
| pakchois-devel                                 |                                                              |
| pam_snapper                                    |                                                              |
| pango-tests                                    |                                                              |
| paps-devel                                     |                                                              |
| passivetex                                     |                                                              |
| pax                                            |                                                              |
| pciutils-devel-static                          |                                                              |
| pcp-collector                                  |                                                              |
| pcp-monitor                                    |                                                              |
| pcre-tools                                     |                                                              |
| pcre2-static                                   |                                                              |
| pentaho-libxml-javadoc                         |                                                              |
| pentaho-reporting-flow-engine-javadoc          |                                                              |
| perl-AppConfig                                 |                                                              |
| Perl-Archive-Extract                           |                                                              |
| perl-B-Keywords                                |                                                              |
| perl-Browser-Open                              |                                                              |
| perl-Business-ISBN                             |                                                              |
| perl-Business-ISBN-Data                        |                                                              |
| Perl-CGI-Session                               |                                                              |
| perl-Class-Load                                |                                                              |
| perl-Class-Load-XS                             |                                                              |
| perl-Config-Simple                             |                                                              |
| perl-Config-Tiny                               |                                                              |
| perl-CPAN-Changes                              |                                                              |
| perl-CPANPLUS                                  |                                                              |
| perl-CPANPLUS-Dist-Build                       |                                                              |
| perl-Crypt-CBC                                 |                                                              |
| perl-Crypt-DES                                 |                                                              |
| perl-Crypt-PasswdMD5                           |                                                              |
| perl-Crypt-SSLeay                              |                                                              |
| perl-CSS-Tiny                                  |                                                              |
| perl-Data-Peek                                 |                                                              |
| perl-DateTime-Format-DateParse                 |                                                              |
| perl-DBD-Pg-tests                              |                                                              |
| perl-DBIx-Simple                               |                                                              |
| Perl-Devel-Cover                               |                                                              |
| Perl-Devel-Cycle                               |                                                              |
| perl-Devel-EnforceEncapsulation                |                                                              |
| Perl-Devel-Leak                                |                                                              |
| perl-Email-Address                             |                                                              |
| perl-FCGI                                      |                                                              |
| perl-File-Find-Rule-Perl                       |                                                              |
| perl-File-Inplace                              |                                                              |
| perl-Font-AFM                                  |                                                              |
| perl-Font-TTF                                  |                                                              |
| perl-FreezeThaw                                |                                                              |
| perl-GD                                        |                                                              |
| perl-GD-Barcode                                |                                                              |
| perl-Hook-LexWrap                              |                                                              |
| perl-HTML-Format                               |                                                              |
| perl-HTML-FormatText-WithLinks                 |                                                              |
| perl-HTML-FormatText-WithLinks-AndTables       |                                                              |
| perl-Image-Base                                |                                                              |
| perl-Image-Info                                |                                                              |
| perl-Image-Xbm                                 |                                                              |
| perl-Image-Xpm                                 |                                                              |
| Perl-Inline                                    |                                                              |
| Perl-Inline-Files                              |                                                              |
| perl-IO-CaptureOutput                          |                                                              |
| perl-JSON-tests                                |                                                              |
| perl-libxml-perl                               |                                                              |
| perl-Locale-Maketext-Gettext                   |                                                              |
| perl-Locale-PO                                 |                                                              |
| perl-Log-Message                               |                                                              |
| perl-Log-Message-Simple                        |                                                              |
| perl-Mixin-Lineether                           |                                                              |
| perl-Module-Manifest                           |                                                              |
| perl-Module-Signature                          |                                                              |
| perl-Net-Daemon                                |                                                              |
| perl-Net-DNS-Nameserver                        |                                                              |
| perl-Net-DNS-Resolver-Programmable             |                                                              |
| perl-Net-LibIDN                                |                                                              |
| perl-Net-Telnet                                |                                                              |
| perl-Newt                                      |                                                              |
| perl-Object-Accessor                           |                                                              |
| perl-Object-Deadly                             |                                                              |
| perl-Package-Constants                         |                                                              |
| perl-PAR-Dist                                  |                                                              |
| Perl-Parallel-Iterator                         |                                                              |
| perl-Parse-CPAN-Meta                           |                                                              |
| perl-Parse-RecDescent                          |                                                              |
| Perl-Perl-Critic                               |                                                              |
| perl-Perl-Critic-More                          |                                                              |
| perl-Perl-MinimumVersion                       |                                                              |
| perl-Perl4-CoreLibs                            |                                                              |
| perl-PlRPC                                     |                                                              |
| perl-Pod-Coverage-TrustPod                     |                                                              |
| perl-Pod-Eventual                              |                                                              |
| perl-Pod-POM                                   |                                                              |
| perl-Pod-Spell                                 |                                                              |
| Perl-PPI                                       |                                                              |
| perl-PPI-HTML                                  |                                                              |
| perl-PPIx-Regexp                               |                                                              |
| perl-PPIx-Utilities                            |                                                              |
| perl-Probe-Perl                                |                                                              |
| perl-Readonly-XS                               |                                                              |
| perl-Sort-Versions                             |                                                              |
| perl-String-Format                             |                                                              |
| perl-String-Similarity                         |                                                              |
| perl-Syntax-Highlight-Engine-Kate              |                                                              |
| perl-Task-Weaken                               |                                                              |
| perl-Template-Toolkit                          |                                                              |
| perl-Term-UI                                   |                                                              |
| perl-Test-ClassAPI                             |                                                              |
| perl-Test-CPAN-Meta                            |                                                              |
| perl-Test-DistManifest                         |                                                              |
| perl-Test-EOL                                  |                                                              |
| perl-Test-HasVersion                           |                                                              |
| perl-Test-Inter                                |                                                              |
| Perl-Test-Manifest                             |                                                              |
| Perl-Test-Memory-Cycle                         |                                                              |
| perl-Test-MinimumVersion                       |                                                              |
| perl-Test-MockObject                           |                                                              |
| perl-Test-NoTabs                               |                                                              |
| perl-Test-Object                               |                                                              |
| perl-Test-Output                               |                                                              |
| perl-Test-Perl-Critic                          |                                                              |
| Perl-Test-Perl-Critic-Policy                   |                                                              |
| perl-Test-Portability-Files                    |                                                              |
| perl-Test-Script                               |                                                              |
| perl-Test-Spelling                             |                                                              |
| perl-Test-SubCalls                             |                                                              |
| perl-Test-Synopsis                             |                                                              |
| perl-Test-Tester                               |                                                              |
| perl-Test-Vars                                 |                                                              |
| perl-Test-Without-Module                       |                                                              |
| perl-Text-CSV_XS                               |                                                              |
| perl-Text-Iconv                                |                                                              |
| perl-Tree-DAG_Node                             |                                                              |
| perl-Unicode-Map8                              |                                                              |
| perl-Unicode-String                            |                                                              |
| perl-universal-can                             |                                                              |
| perl-universal-isa                             |                                                              |
| perl-Version-Requirements                      |                                                              |
| perl-WWW-Curl                                  |                                                              |
| perl-XML-Dumper                                |                                                              |
| perl-XML-Filter-BufferText                     |                                                              |
| perl-XML-Grove                                 |                                                              |
| perl-XML-Handler-YAWriter                      |                                                              |
| perl-XML-LibXSLT                               |                                                              |
| perl-XML-SAX-Writer                            |                                                              |
| perl-XML-TreeBuilder                           |                                                              |
| perl-XML-Writer                                |                                                              |
| perl-XML-XPathEngine                           |                                                              |
| phonon                                         |                                                              |
| phonon-backend-gstreamer                       |                                                              |
| phonon-devel                                   |                                                              |
| php-pecl-memcache                              |                                                              |
| php-pspell                                     |                                                              |
| pidgin-perl                                    |                                                              |
| pinentry-qt                                    |                                                              |
| pinentry-qt4                                   |                                                              |
| pki-javadoc                                    |                                                              |
| plasma-scriptengine-python                     |                                                              |
| plasma-scriptengine-ruby                       |                                                              |
| plexus-digest                                  |                                                              |
| plexus-digest-javadoc                          |                                                              |
| plexus-mail-sender                             |                                                              |
| plexus-mail-sender-javadoc                     |                                                              |
| plexus-tools-pom                               |                                                              |
| plymouth-devel                                 |                                                              |
| pm-utils                                       |                                                              |
| pm-utils-devel                                 |                                                              |
| pngcrush                                       |                                                              |
| pngnq                                          |                                                              |
| polkit-kde                                     |                                                              |
| polkit-qt                                      |                                                              |
| polkit-qt-devel                                |                                                              |
| polkit-qt-doc                                  |                                                              |
| poppler-demos                                  |                                                              |
| poppler-qt                                     |                                                              |
| poppler-qt-devel                               |                                                              |
| popt-static                                    |                                                              |
| postfix-sysvinit                               |                                                              |
| pothana2000-fonts                              |                                                              |
| powerpc-utils-python                           |                                                              |
| pprof                                          |                                                              |
| pps-tools                                      |                                                              |
| pptp-setup                                     |                                                              |
| procps-ng-devel                                |                                                              |
| protobuf-emacs                                 |                                                              |
| protobuf-emacs-el                              |                                                              |
| protobuf-java                                  |                                                              |
| protobuf-javadoc                               |                                                              |
| protobuf-lite-static                           |                                                              |
| protobuf-python                                |                                                              |
| protobuf-static                                |                                                              |
| protobuf-vim                                   |                                                              |
| psutils                                        |                                                              |
| psutils-perl                                   |                                                              |
| pth-devel                                      |                                                              |
| ptlib                                          |                                                              |
| ptlib-devel                                    |                                                              |
| publican                                       |                                                              |
| publican-common-db5-web                        |                                                              |
| publican-common-web                            |                                                              |
| publican-doc                                   |                                                              |
| publican-redhat                                |                                                              |
| pulseaudio-esound-compat                       |                                                              |
| pulseaudio-module-gconf                        |                                                              |
| pulseaudio-module-zeroconf                     |                                                              |
| pulseaudio-qpaeq                               |                                                              |
| pygpgme                                        |                                                              |
| pygtk2-libglade                                |                                                              |
| pykde4                                         |                                                              |
| pykde4-akonadi                                 |                                                              |
| pykde4-devel                                   |                                                              |
| pyldb-devel                                    |                                                              |
| pyliblzma                                      |                                                              |
| PyOpenGL                                       |                                                              |
| PyOpenGL-Tk                                    |                                                              |
| pyOpenSSL-doc                                  |                                                              |
| pyorbit                                        |                                                              |
| pyorbit-devel                                  |                                                              |
| PyPAM                                          |                                                              |
| pyparsing-doc                                  |                                                              |
| PyQt4                                          |                                                              |
| PyQt4-devel                                    |                                                              |
| pytalloc-devel                                 |                                                              |
| python-adal                                    |                                                              |
| python-appindicator                            |                                                              |
| python-beaker                                  |                                                              |
| python-cffi-doc                                |                                                              |
| python-cherrypy                                |                                                              |
| python-criu                                    |                                                              |
| python-deltarpm                                |                                                              |
| python-di                                      |                                                              |
| python-dmidecode                               |                                                              |
| python-dtopt                                   |                                                              |
| python-fpconst                                 |                                                              |
| python-gpod                                    |                                                              |
| python-gudev                                   |                                                              |
| python-inotify-examples                        |                                                              |
| python-ipaddr                                  |                                                              |
| python-IPy                                     |                                                              |
| python-isodate                                 |                                                              |
| python-isomd5sum                               |                                                              |
| python-kitchen                                 |                                                              |
| python-kitchen-doc                             |                                                              |
| python-libteam                                 |                                                              |
| python-lxml-docs                               |                                                              |
| python-matplotlib                              |                                                              |
| python-matplotlib-doc                          |                                                              |
| python-matplotlib-qt4                          |                                                              |
| python-matplotlib-tk                           |                                                              |
| python-memcached                               |                                                              |
| python-msrest                                  |                                                              |
| python-msrestazure                             |                                                              |
| python-mutagen                                 |                                                              |
| python-openvswitch                             |                                                              |
| python-paramiko                                |                                                              |
| python-paramiko-doc                            |                                                              |
| python-paste                                   |                                                              |
| python-pillow-devel                            |                                                              |
| python-pillow-doc                              |                                                              |
| python-pillow-qt                               |                                                              |
| python-pillow-sane                             |                                                              |
| python-pillow-tk                               |                                                              |
| python-pyblock                                 |                                                              |
| python-rados                                   |                                                              |
| python-rbd                                     |                                                              |
| python-reportlab-docs                          |                                                              |
| python-rtslib-doc                              |                                                              |
| python-setproctitle                            |                                                              |
| python-slip-gtk                                |                                                              |
| python-smbc                                    |                                                              |
| python-smbc-doc                                |                                                              |
| python-smbios                                  |                                                              |
| python-sphinx-doc                              |                                                              |
| python-sphinx-theme-openlmi                    |                                                              |
| python-tempita                                 |                                                              |
| python-tornado                                 |                                                              |
| python-tornado-doc                             |                                                              |
| python-twisted-core                            |                                                              |
| python-twisted-core-doc                        |                                                              |
| python-twisted-web                             |                                                              |
| python-twisted-words                           |                                                              |
| python-urlgrabber                              |                                                              |
| python-volume_key                              |                                                              |
| python-webob                                   |                                                              |
| python-webtest                                 |                                                              |
| python-which                                   |                                                              |
| python-zope-interface                          |                                                              |
| python2-caribou                                |                                                              |
| python2-futures                                |                                                              |
| python2-gexiv2                                 |                                                              |
| python2-smartcols                              |                                                              |
| python2-solv                                   |                                                              |
| python2-subprocess32                           |                                                              |
| python3-debug                                  |                                                              |
| python3-devel                                  |                                                              |
| qca-ossl                                       |                                                              |
| qca2                                           |                                                              |
| qca2-devel                                     |                                                              |
| qimageblitz                                    |                                                              |
| qimageblitz-devel                              |                                                              |
| qimageblitz-examples                           |                                                              |
| qjson                                          |                                                              |
| qjson-devel                                    |                                                              |
| qpdf-devel                                     |                                                              |
| qt                                             |                                                              |
| qt-assistant                                   |                                                              |
| qt-config                                      |                                                              |
| qt-demos                                       |                                                              |
| qt-devel                                       |                                                              |
| qt-devel-private                               |                                                              |
| qt-doc                                         |                                                              |
| qt-examples                                    |                                                              |
| qt-mysql                                       |                                                              |
| qt-odbc                                        |                                                              |
| qt-postgresql                                  |                                                              |
| qt-qdbusviewer                                 |                                                              |
| qt-qvfb                                        |                                                              |
| qt-settings                                    |                                                              |
| qt-x11                                         |                                                              |
| qt3                                            |                                                              |
| qt3-config                                     |                                                              |
| qt3-designer                                   |                                                              |
| qt3-devel                                      |                                                              |
| qt3-devel-docs                                 |                                                              |
| qt3-MySQL                                      |                                                              |
| qt3-ODBC                                       |                                                              |
| qt3-PostgreSQL                                 |                                                              |
| qt5-qt3d-doc                                   |                                                              |
| qt5-qtbase-doc                                 |                                                              |
| qt5-qtcanvas3d-doc                             |                                                              |
| qt5-qtconnectivity-doc                         |                                                              |
| qt5-qtdeclarative-doc                          |                                                              |
| qt5-qtenginio                                  |                                                              |
| qt5-qtenginio-devel                            |                                                              |
| qt5-qtenginio-doc                              |                                                              |
| qt5-qtenginio-examples                         |                                                              |
| qt5-qtgraphicaleffects-doc                     |                                                              |
| qt5-qtimageformats-doc                         |                                                              |
| qt5-qtlocation-doc                             |                                                              |
| qt5-qtmultimedia-doc                           |                                                              |
| qt5-qtquickcontrols-doc                        |                                                              |
| qt5-qtquickcontrols2-doc                       |                                                              |
| qt5-qtscript-doc                               |                                                              |
| qt5-qtsensors-doc                              |                                                              |
| qt5-qtserialbus-devel                          |                                                              |
| qt5-qtserialbus-doc                            |                                                              |
| qt5-qtserialport-doc                           |                                                              |
| qt5-qtsvg-doc                                  |                                                              |
| qt5-qttools-doc                                |                                                              |
| qt5-qtwayland-doc                              |                                                              |
| qt5-qtwebchannel-doc                           |                                                              |
| qt5-qtwebsockets-doc                           |                                                              |
| qt5-qtx11extras-doc                            |                                                              |
| qt5-qtxmlpatterns-doc                          |                                                              |
| quagga                                         | 从 RHEL 8.1 开始, Quagga 被一个由 AppStream 仓库中的 `frr` 软件包提供的 Free Range Routing（FRRouting 或 FRR）替代。FRR 提供基于 TCP/IP  的路由服务,并支持多个 IPv4 和 IPv6 路由协议,如 BGP、IS-IS、OSPF、PIM 和 RIP。如需更多信息,请参阅 [为您的系统设置路由协议](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_networking/setting-your-routing-protocols_configuring-and-managing-networking#setting-your-routing-protocols_configuring-and-managing-networking)。 |
| quagga-contrib                                 |                                                              |
| qv4l2                                          |                                                              |
| rarian-devel                                   |                                                              |
| ras-utils                                      |                                                              |
| rcs                                            | RHEL 8 支持的版本控制系统是 `Git`、`Mercurial` 和 `Subversion`。 |
| rdate                                          |                                                              |
| rdist                                          |                                                              |
| readline-static                                |                                                              |
| realmd-devel-docs                              |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-as-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-bn-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-de-DE |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-en-US |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-es-ES |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-fr-FR |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-gu-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-hi-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-it-IT |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-ja-JP |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-kn-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-ko-KR |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-ml-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-mr-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-or-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-pa-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-pt-BR |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-ru-RU |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-ta-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-te-IN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-zh-CN |                                                              |
| Red_Hat_Enterprise_Linux-Release_Notes-7-zh-TW |                                                              |
| redhat-access-gui                              |                                                              |
| redhat-access-plugin-ipa                       |                                                              |
| redhat-bookmarks                               |                                                              |
| redhat-lsb-supplemental                        |                                                              |
| redhat-lsb-trialuse                            |                                                              |
| redhat-upgrade-dracut                          |                                                              |
| redhat-upgrade-dracut-plymouth                 |                                                              |
| redhat-upgrade-tool                            |                                                              |
| redland-mysql                                  |                                                              |
| redland-pgsql                                  |                                                              |
| redland-virtuoso                               |                                                              |
| relaxngcc                                      |                                                              |
| rest-devel                                     |                                                              |
| resteasy-base-jettison-provider                |                                                              |
| resteasy-base-tjws                             |                                                              |
| rfkill                                         |                                                              |
| rhdb-utils                                     |                                                              |
| rhino                                          |                                                              |
| rhino-demo                                     |                                                              |
| rhino-javadoc                                  |                                                              |
| rhino-manual                                   |                                                              |
| rhythmbox-devel                                |                                                              |
| rngom                                          |                                                              |
| rngom-javadoc                                  |                                                              |
| rp-pppoe                                       |                                                              |
| rrdtool-php                                    |                                                              |
| rrdtool-python                                 |                                                              |
| rsh                                            | 要登录到远程系统，请使用 SSH。                               |
| rsh-server                                     |                                                              |
| rsyslog-libdbi                                 |                                                              |
| rtcheck                                        |                                                              |
| rtctl                                          |                                                              |
| ruby-tcltk                                     |                                                              |
| rubygem-did_you_mean                           |                                                              |
| rubygem-net-http-persistent                    |                                                              |
| rubygem-net-http-persistent-doc                |                                                              |
| rubygem-thor                                   |                                                              |
| rubygem-thor-doc                               |                                                              |
| rusers                                         |                                                              |
| rusers-server                                  |                                                              |
| rwho                                           |                                                              |
| sac-javadoc                                    |                                                              |
| samba-dc                                       |                                                              |
| samba-dc-libs                                  |                                                              |
| sanlock-python                                 |                                                              |
| sapconf                                        |                                                              |
| satyr-devel                                    |                                                              |
| satyr-python                                   |                                                              |
| saxon                                          |                                                              |
| saxon-demo                                     |                                                              |
| saxon-javadoc                                  |                                                              |
| saxon-manual                                   |                                                              |
| saxon-scripts                                  |                                                              |
| sbc-devel                                      |                                                              |
| sblim-cim-client2                              |                                                              |
| sblim-cim-client2-javadoc                      |                                                              |
| sblim-cim-client2-manual                       |                                                              |
| sblim-cmpi-base-devel                          |                                                              |
| sblim-cmpi-base-test                           |                                                              |
| sblim-cmpi-fsvol                               |                                                              |
| sblim-cmpi-fsvol-devel                         |                                                              |
| sblim-cmpi-fsvol-test                          |                                                              |
| sblim-cmpi-network                             |                                                              |
| sblim-cmpi-network-devel                       |                                                              |
| sblim-cmpi-network-test                        |                                                              |
| sblim-cmpi-nfsv3                               |                                                              |
| sblim-cmpi-nfsv3-test                          |                                                              |
| sblim-cmpi-nfsv4                               |                                                              |
| sblim-cmpi-nfsv4-test                          |                                                              |
| sblim-cmpi-params                              |                                                              |
| sblim-cmpi-params-test                         |                                                              |
| sblim-cmpi-sysfs                               |                                                              |
| sblim-cmpi-sysfs-test                          |                                                              |
| sblim-cmpi-syslog                              |                                                              |
| sblim-cmpi-syslog-test                         |                                                              |
| sblim-gather                                   |                                                              |
| sblim-gather-devel                             |                                                              |
| sblim-gather-provider                          |                                                              |
| sblim-gather-test                              |                                                              |
| sblim-indication_helper-devel                  |                                                              |
| sblim-smis-hba                                 |                                                              |
| sblim-testsuite                                |                                                              |
| scannotation                                   |                                                              |
| scannotation-javadoc                           |                                                              |
| scpio                                          |                                                              |
| screen                                         |                                                              |
| SDL-static                                     |                                                              |
| sdparm                                         |                                                              |
| seahorse-nautilus                              |                                                              |
| seahorse-sharing                               |                                                              |
| sendmail-sysvinit                              |                                                              |
| setools-devel                                  |                                                              |
| setools-libs-tcl                               |                                                              |
| setuptool                                      |                                                              |
| shared-desktop-ontology                        |                                                              |
| shared-desktop-ontologies-devel                |                                                              |
| shim-unsigned-ia32                             |                                                              |
| shim-unsigned-x64                              |                                                              |
| sisu                                           |                                                              |
| sisu-parent                                    |                                                              |
| slang-slsh                                     |                                                              |
| slang-static                                   |                                                              |
| smbios-utils                                   |                                                              |
| smbios-utils-bin                               |                                                              |
| smbios-utils-python                            |                                                              |
| snakeyaml                                      |                                                              |
| snakeyaml-javadoc                              |                                                              |
| snapper                                        |                                                              |
| snapper-devel                                  |                                                              |
| snapper-libs                                   |                                                              |
| sntp                                           |                                                              |
| SOAPpy                                         |                                                              |
| soprano                                        |                                                              |
| soprano-apidocs                                |                                                              |
| soprano-devel                                  |                                                              |
| source-highlight-devel                         |                                                              |
| sox                                            |                                                              |
| sox-devel                                      |                                                              |
| speex-tools                                    |                                                              |
| spice-streaming-agent                          |                                                              |
| spice-streaming-agent-devel                    |                                                              |
| spice-xpi                                      |                                                              |
| sqlite-tcl                                     |                                                              |
| squid-migration-script                         |                                                              |
| squid-sysvinit                                 |                                                              |
| sssd-libwbclient-devel                         |                                                              |
| stax2-api                                      |                                                              |
| stax2-api-javadoc                              |                                                              |
| strigi                                         |                                                              |
| strigi-devel                                   |                                                              |
| strigi-libs                                    |                                                              |
| strongimcv                                     |                                                              |
| subversion-kde                                 |                                                              |
| subversion-python                              |                                                              |
| subversion-ruby                                |                                                              |
| sudo-devel                                     |                                                              |
| suitesparse-doc                                |                                                              |
| suitesparse-static                             |                                                              |
| supermin-helper                                |                                                              |
| svgpart                                        |                                                              |
| svrcore                                        |                                                              |
| svrcore-devel                                  |                                                              |
| sweeper                                        |                                                              |
| syslinux-devel                                 |                                                              |
| syslinux-perl                                  |                                                              |
| system-config-date                             |                                                              |
| system-config-date-docs                        |                                                              |
| system-config-firewall                         |                                                              |
| system-config-firewall-base                    |                                                              |
| system-config-firewall-tui                     |                                                              |
| system-config-keyboard                         |                                                              |
| system-config-keyboard-base                    |                                                              |
| system-config-kickstart                        |                                                              |
| system-config-language                         |                                                              |
| system-config-printer                          | 已删除 `system-config-printer` 软件包。它的工作站功能已包括在 `gnome-control-center` 中,其服务器用例由 CUPS Web UI 涵盖。 |
| system-config-users-docs                       |                                                              |
| system-switch-java                             |                                                              |
| systemd-sysv                                   |                                                              |
| t1lib                                          |                                                              |
| t1lib-apps                                     |                                                              |
| t1lib-devel                                    |                                                              |
| t1lib-static                                   |                                                              |
| t1utils                                        |                                                              |
| taglib-doc                                     |                                                              |
| talk                                           |                                                              |
| talk-server                                    |                                                              |
| tang-nagios                                    |                                                              |
| targetd                                        |                                                              |
| tcl-pgtcl                                      |                                                              |
| tclx                                           |                                                              |
| tclx-devel                                     |                                                              |
| tcp_wrappers                                   | 请参阅 [RHEL 8 中替换 TCP 抓取器](https://access.redhat.com/solutions/3906701)。 |
| tcp_wrappers-devel                             |                                                              |
| tcp_wrappers-libs                              |                                                              |
| teamd-devel                                    |                                                              |
| teckit-devel                                   |                                                              |
| telepathy-farstream                            |                                                              |
| telepathy-farstream-devel                      |                                                              |
| telepathy-filesystem                           |                                                              |
| telepathy-gabble                               |                                                              |
| telepathy-glib                                 |                                                              |
| telepathy-glib-devel                           |                                                              |
| telepathy-glib-vala                            |                                                              |
| telepathy-haze                                 |                                                              |
| telepathy-logger                               |                                                              |
| telepathy-logger-devel                         |                                                              |
| telepathy-mission-control                      |                                                              |
| telepathy-mission-control-devel                |                                                              |
| telepathy-salut                                |                                                              |
| tex-preview                                    |                                                              |
| texlive-collection-documentation-base          |                                                              |
| texlive-mh                                     |                                                              |
| texlive-mh-doc                                 |                                                              |
| texlive-misc                                   |                                                              |
| texlive-thailatex                              |                                                              |
| texlive-thailatex-doc                          |                                                              |
| tix-doc                                        |                                                              |
| tn5250                                         |                                                              |
| tn5250-devel                                   |                                                              |
| tncfhh                                         |                                                              |
| tncfhh-devel                                   |                                                              |
| tncfhh-examples                                |                                                              |
| tncfhh-libs                                    |                                                              |
| tncfhh-utils                                   |                                                              |
| tog-pegasus-test                               |                                                              |
| tokyocabinet-devel-doc                         |                                                              |
| tomcat                                         | Apache Tomcat 服务器已从 RHEL 中删除。Apache Tomcat 是 Java Servlet 和 JavaServer Pages(JSP)技术的 servlet 容器。红帽建议需要 servlet 容器的用户使用 [JBoss Web Server](https://www.redhat.com/en/technologies/jboss-middleware/web-server)。 |
| tomcat-admin-webapps                           |                                                              |
| tomcat-docs-webapp                             |                                                              |
| tomcat-el-2.2-api                              |                                                              |
| tomcat-javadoc                                 |                                                              |
| tomcat-jsp-2.2-api                             |                                                              |
| tomcat-jsvc                                    |                                                              |
| tomcat-lib                                     |                                                              |
| tomcat-servlet-3.0-api                         |                                                              |
| tomcat-webapps                                 |                                                              |
| totem-devel                                    |                                                              |
| totem-pl-parser-devel                          |                                                              |
| traceer-docs                                   |                                                              |
| tracker-needle                                 |                                                              |
| traceer-preferences                            |                                                              |
| trang                                          |                                                              |
| trousers-static                                |                                                              |
| txw2                                           |                                                              |
| txw2-javadoc                                   |                                                              |
| udftools                                       |                                                              |
| udisks2-vdo                                    |                                                              |
| unique3                                        |                                                              |
| unique3-devel                                  |                                                              |
| unique3-docs                                   |                                                              |
| unoconv                                        |                                                              |
| uriparser                                      |                                                              |
| uriparser-devel                                |                                                              |
| usbguard-devel                                 |                                                              |
| usbredir-server                                |                                                              |
| usnic-tools                                    |                                                              |
| ustr-debug                                     |                                                              |
| ustr-debug-static                              |                                                              |
| ustr-devel                                     |                                                              |
| ustr-static                                    |                                                              |
| uuid-c++                                       |                                                              |
| uuid-c++-devel                                 |                                                              |
| uuid-dce                                       |                                                              |
| uuid-dce-devel                                 |                                                              |
| uuid-perl                                      |                                                              |
| uuid-php                                       |                                                              |
| v4l-utils                                      |                                                              |
| v4l-utils-devel-tools                          |                                                              |
| vala-doc                                       |                                                              |
| valadoc                                        |                                                              |
| valadoc-devel                                  |                                                              |
| valgrind-openmpi                               |                                                              |
| vemana2000-fonts                               |                                                              |
| vigra                                          |                                                              |
| vigra-devel                                    |                                                              |
| virtuoso-opensource                            |                                                              |
| virtuoso-opensource-utils                      |                                                              |
| vlgothic-p-fonts                               |                                                              |
| vsftpd-sysvinit                                |                                                              |
| vte3                                           |                                                              |
| vte3-devel                                     |                                                              |
| wayland-doc                                    |                                                              |
| webkit2gtk3-plugin-process-gtk2                | 因为 WebKitGTK 2.26 删除了链接到 GTK 2 的 NPAPI 插件的支持,所以这个 `webkit2gtk3-plugin-process-gtk2` 软件包已被删除。值得注意的是,这意味着 Adobe Flash 不再工作。 |
| webkitgtk3                                     |                                                              |
| webkitgtk3-devel                               |                                                              |
| webkitgtk3-doc                                 |                                                              |
| webkitgtk4-doc                                 |                                                              |
| webrtc-audio-processing-devel                  |                                                              |
| woodstox-core                                  |                                                              |
| woodstox-core-javadoc                          |                                                              |
| wordnet                                        |                                                              |
| wordnet-browser                                |                                                              |
| wordnet-devel                                  |                                                              |
| wordnet-doc                                    |                                                              |
| ws-commons-util                                |                                                              |
| ws-commons-util-javadoc                        |                                                              |
| ws-jaxme                                       |                                                              |
| ws-jaxme-javadoc                               |                                                              |
| ws-jaxme-manual                                |                                                              |
| wsdl4j                                         |                                                              |
| wsdl4j-javadoc                                 |                                                              |
| wvdial                                         |                                                              |
| x86info                                        |                                                              |
| xchat-tcl                                      |                                                              |
| xdg-desktop-portal-devel                       |                                                              |
| xerces-c                                       |                                                              |
| xerces-c-devel                                 |                                                              |
| xerces-c-doc                                   |                                                              |
| xferstats                                      |                                                              |
| xguest                                         |                                                              |
| xhtml2fo-style-xsl                             |                                                              |
| xhtml2ps                                       |                                                              |
| xisdnload                                      |                                                              |
| xml-commons-apis12                             |                                                              |
| xml-commons-apis12-javadoc                     |                                                              |
| xml-commons-apis12-manual                      |                                                              |
| xmlgraphics-commons                            |                                                              |
| xmlgraphics-commons-javadoc                    |                                                              |
| xmlrpc-c-apps                                  |                                                              |
| xmlrpc-client                                  |                                                              |
| xmlrpc-common                                  |                                                              |
| xmlrpc-javadoc                                 |                                                              |
| xmlrpc-server                                  |                                                              |
| xmlsec1-gcrypt-devel                           |                                                              |
| xmlsec1-nss-devel                              |                                                              |
| xmlto-tex                                      |                                                              |
| xmlto-xhtml                                    |                                                              |
| xorg-x11-drv-intel-devel                       |                                                              |
| xorg-x11-drv-keyboard                          |                                                              |
| xorg-x11-drv-mouse                             |                                                              |
| xorg-x11-drv-mouse-devel                       |                                                              |
| xorg-x11-drv-openchrome                        |                                                              |
| xorg-x11-drv-openchrome-devel                  |                                                              |
| xorg-x11-drv-synaptics                         |                                                              |
| xorg-x11-drv-synaptics-devel                   |                                                              |
| xorg-x11-drv-vmmouse                           |                                                              |
| xorg-x11-drv-void                              |                                                              |
| xorg-x11-xkb-extras                            |                                                              |
| xpp3                                           |                                                              |
| xpp3-javadoc                                   |                                                              |
| xpp3-minimal                                   |                                                              |
| xsettings-kde                                  |                                                              |
| xstream                                        |                                                              |
| xstream-javadoc                                |                                                              |
| xulrunner                                      |                                                              |
| xulrunner-devel                                |                                                              |
| xvattr                                         |                                                              |
| xz-compat-libs                                 |                                                              |
| yelp-xsl-devel                                 |                                                              |
| yum-langpacks                                  | 本地化现在是 DNF 的 一 个完整部分。                          |
| yum-NetworkManager-dispatcher                  |                                                              |
| yum-plugin-filter-data                         |                                                              |
| yum-plugin-fs-snapshot                         |                                                              |
| yum-plugin-keys                                |                                                              |
| yum-plugin-list-data                           |                                                              |
| yum-plugin-local                               |                                                              |
| yum-plugin-merge-conf                          |                                                              |
| yum-plugin-ovl                                 |                                                              |
| yum-plugin-post-transaction-actions            |                                                              |
| yum-plugin-pre-transaction-actions             |                                                              |
| yum-plugin-protectbase                         |                                                              |
| yum-plugin-ps                                  |                                                              |
| yum-plugin-rpm-warm-cache                      |                                                              |
| yum-plugin-show-leaves                         |                                                              |
| yum-plugin-upgrade-helper                      |                                                              |
| yum-plugin-verify                              |                                                              |
| yum-updateonboot                               |                                                              |

## A.5. 带有不被支持的软件包

​				RHEL 8 中的某些软件包通过 CodeReady Linux Builder 软件仓库发布,该软件仓库包含不受支持的软件包供开发人员使用。有关这个存储库中软件包的完整列表,请查看 [软件包清单](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/package_manifest/codereadylinuxbuilder-repository)。本节仅涵盖 RHEL 7 支持但在 RHEL 8 中不支持的软件包。 		

​				以下软件包在 RHEL 7 和 RHEL 8 中支持的频道中发布,它们是 CodeReady Linux Builder 软件仓库的一部分： 		

| 软件包                          | RHEL 7 频道  |
| ------------------------------- | ------------ |
| antlr-tool                      | rhel7-base   |
| bcel                            | rhel7-base   |
| cal10n                          | rhel7-base   |
| cdi-api-javadoc                 | rhel7-base   |
| codemodel                       | rhel7-base   |
| dejagnu                         | rhel7-base   |
| docbook-style-dsssl             | rhel7-base   |
| docbook-utils                   | rhel7-base   |
| docbook5-schemas                | rhel7-base   |
| flex-devel                      | rhel7-base   |
| geronimo-jms                    | rhel7-base   |
| gnome-common                    | rhel7-base   |
| hamcrest                        | rhel7-base   |
| imake                           | rhel7-base   |
| isorelax                        | rhel7-base   |
| jakarta-oro                     | rhel7-base   |
| javamail                        | rhel7-base   |
| jaxen                           | rhel7-base   |
| jdom                            | rhel7-base   |
| jna                             | rhel7-base   |
| junit                           | rhel7-base   |
| jvnet-parent                    | rhel7-base   |
| libdbusmenu-doc                 | rhel7-base   |
| libdbusmenu-gtk3-devel          | rhel7-base   |
| libfdt                          | rhel7-base   |
| libgit2-devel                   | rhel7-extras |
| libindicator-gtk3-devel         | rhel7-base   |
| libmodulemd-devel               | rhel7-extras |
| libseccomp-devel                | rhel7-base   |
| libstdc++-static                | rhel7-base   |
| nasm                            | rhel7-base   |
| objectweb-asm                   | rhel7-base   |
| openjade                        | rhel7-base   |
| openldap-servers                | rhel7-base   |
| opensp                          | rhel7-base   |
| perl-Class-Singleton            | rhel7-base   |
| perl-DateTime                   | rhel7-base   |
| perl-DateTime-Locale            | rhel7-base   |
| perl-DateTime-TimeZone          | rhel7-base   |
| Perl-Devel-Symdump              | rhel7-base   |
| perl-Digest-SHA1                | rhel7-base   |
| perl-HTML-Tree                  | rhel7-base   |
| perl-HTTP-Daemon                | rhel7-base   |
| perl-IO-stringy                 | rhel7-base   |
| perl-List-MoreUtils             | rhel7-base   |
| perl-Module-Implementation      | rhel7-base   |
| perl-Package-DeprecationManager | rhel7-base   |
| perl-Package-stash              | rhel7-base   |
| perl-Package-Stash-XS           | rhel7-base   |
| perl-Params-Validate            | rhel7-base   |
| perl-Pod-Coverage               | rhel7-base   |
| perl-SGMLSpm                    | rhel7-base   |
| perl-Test-Pod                   | rhel7-base   |
| perl-Test-Pod-Coverage          | rhel7-base   |
| perl-XML-Twig                   | rhel7-base   |
| perl-YAML-Tiny                  | rhel7-base   |
| perltidy                        | rhel7-base   |
| qdox                            | rhel7-base   |
| regexp                          | rhel7-base   |
| texinfo                         | rhel7-base   |
| ustr                            | rhel7-base   |
| weld-parent                     | rhel7-base   |
| xmltoman                        | rhel7-base   |
| xorg-x11-apps                   | rhel7-base   |

​				以下软件包已移至 RHEL 8 中的 CodeReady Linux Builder 软件仓库： 		

| 软件包                                   | 原始 RHEL 8 软件仓库 | 修改自   |
| ---------------------------------------- | -------------------- | -------- |
| apache-commons-collections-javadoc       | rhel8-AppStream      | RHEL 8.1 |
| apache-commons-collections-testframework | rhel8-AppStream      | RHEL 8.1 |
| apache-commons-lang-javadoc              | rhel8-AppStream      | RHEL 8.1 |
| jakarta-commons-httpclient-demo          | rhel8-AppStream      | RHEL 8.1 |
| jakarta-commons-httpclient-javadoc       | rhel8-AppStream      | RHEL 8.1 |
| jakarta-commons-httpclient-manual        | rhel8-AppStream      | RHEL 8.1 |
| velocity-demo                            | rhel8-AppStream      | RHEL 8.1 |
| velocity-javadoc                         | rhel8-AppStream      | RHEL 8.1 |
| velocity-manual                          | rhel8-AppStream      | RHEL 8.1 |
| xerces-j2-demo                           | rhel8-AppStream      | RHEL 8.1 |
| xerces-j2-javadoc                        | rhel8-AppStream      | RHEL 8.1 |
| xml-commons-apis-javadoc                 | rhel8-AppStream      | RHEL 8.1 |
| xml-commons-apis-manual                  | rhel8-AppStream      | RHEL 8.1 |
| xml-commons-resolver-javadoc             | rhel8-AppStream      | RHEL 8.1 |

# 法律通告

​		Copyright © 2021 Red Hat, Inc. 

​		The text of and illustrations in this document are licensed by Red Hat under a Creative Commons Attribution–Share Alike 3.0 Unported license  ("CC-BY-SA"). An explanation of CC-BY-SA is available at http://creativecommons.org/licenses/by-sa/3.0/. In accordance with CC-BY-SA, if you distribute this document or an  adaptation of it, you must provide the URL for the original version. 

​		Red Hat, as the licensor of this document, waives the right to  enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law. 

​		Red Hat, Red Hat Enterprise Linux, the Shadowman logo, the Red Hat  logo, JBoss, OpenShift, Fedora, the Infinity logo, and RHCE are  trademarks of Red Hat, Inc., registered in the United States and other  countries. 

​		Linux® is the registered trademark of Linus Torvalds in the United States and other countries. 

​		Java® is a registered trademark of Oracle and/or its affiliates. 

​		XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries. 

​		MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries. 

​		Node.js® is an official trademark of  Joyent. Red Hat is not formally related to or endorsed by the official  Joyent Node.js open source or commercial project. 

​		The OpenStack® Word Mark and OpenStack  logo are either registered trademarks/service marks or  trademarks/service marks of the OpenStack Foundation, in the United  States and other countries and are used with the OpenStack Foundation's  permission. We are not affiliated with, endorsed or sponsored by the  OpenStack Foundation, or the OpenStack community. 

​		All other trademarks are the property of their respective owners. 

------

为了尽快向用户提供最新的信息，本文档可能会包括由机器自动从英文原文翻译的内容。如需更多信息，请参阅[此说明。](https://access.redhat.com/zh_CN/articles/4935271)

  

​                [                                                                                                                              ](https://redhat.com)

[                       ](https://redhat.com)[                       ](https://redhat.com)

[                                    ](https://redhat.com)              

### Quick Links

- [Downloads](https://access.redhat.com/downloads/)
- [Subscriptions](https://access.redhat.com/management)
- [Support Cases](https://access.redhat.com/support)
- [Customer Service](https://access.redhat.com/support/customer-service)
- [Product Documentation](https://access.redhat.com/documentation)

### Help

- [Contact Us](https://access.redhat.com/support/contact/)
- [Customer Portal FAQ](https://access.redhat.com/articles/33844)
- [Log-in Assistance](https://access.redhat.com/help/login_assistance)

### Site Info

- [Trust Red Hat](https://www.redhat.com/en/trust)
- [Browser Support Policy](https://access.redhat.com/help/browsers/)
- [Accessibility](https://access.redhat.com/help/accessibility/)
- [Awards and Recognition](https://access.redhat.com/recognition/)
- [Colophon](https://access.redhat.com/help/colophon/)

### Related Sites

- [redhat.com](https://www.redhat.com/)
- [developers.redhat.com](http://developers.redhat.com/)
- [connect.redhat.com](https://connect.redhat.com/)
- [cloud.redhat.com](https://cloud.redhat.com/)

### About

- [Red Hat Subscription Value](https://access.redhat.com/subscription-value)
- [About Red Hat](https://www.redhat.com/about/)
- [Red Hat Jobs](http://jobs.redhat.com)

Copyright © 2021 Red Hat, Inc.

- [Privacy Statement](http://www.redhat.com/en/about/privacy-policy)
- [Customer Portal Terms of Use](https://access.redhat.com/help/terms/)
- [All Policies and Guidelines](http://www.redhat.com/en/about/all-policies-guidelines)
- Cookie 喜好设置

[                       ![Red Hat Summit](https://access.redhat.com/chrome_themes/nimbus/img/rh-summit-red-a.svg)                     ](http://www.redhat.com/summit/)

​                        [Twitter](https://twitter.com/RedHatSupport)                        [Facebook](https://www.facebook.com/RedHatSupport)                    

**支持的架构**

AMD & Intel 64-bit architectures

64-bit ARM architecture

IBM Power Systems, Little Endian

IBM Z 					

## 安装				

### 安装方式

- Quick install

  on AMD64, Intel 64, and 64-bit  ARM architectures using the graphical user interface. 

- Graphical install

  using the graphical user  interface and customize the graphical settings for your specific  requirements.

- Automated install

  using Kickstart. 				

### Ports for network-based installation

| Protocol used | Ports to open    |
| ------------- | ---------------- |
| HTTP          | 80               |
| HTTPS         | 443              |
| FTP           | 21               |
| NFS           | 2049, 111, 20048 |
| TFTP          | 69               |

### security policy

The Red Hat Enterprise Linux security policy adheres to  restrictions and recommendations (compliance policies) defined by the  Security Content Automation Protocol (SCAP) standard. The packages are  automatically installed. However, by default, no policies are enforced  and therefore no checks are performed during or after installation  unless specifically configured. 						

Applying a security policy is not a mandatory feature of the  installation program. If you apply a security policy to the system, it  is installed using restrictions and recommendations defined in the  profile that you selected. The **openscap-scanner**  package is added to your package selection, providing a preinstalled  tool for compliance and vulnerability scanning. After the installation  finishes, the system is automatically scanned to verify compliance. The  results of this scan are saved to the `/root/openscap_data` directory on the installed system. You can also load additional profiles from an HTTP, HTTPS, or FTP server. 							

### System Purpose					

The `System Purpose` tool  ensures that you are provided with the subscription you have purchased.  By supplying the necessary information - Role, Service Level Agreement,  and Usage - you enable the system to auto-attach the most appropriate  subscription. The `System Purpose` tool also ensures that existing customers can continue using the same subscription that they have already purchased. 			

- **Role**						
  - Red Hat Enterprise Linux Server 										
  - Red Hat Enterprise Linux Workstation 										
  - Red Hat Enterprise Linux Compute Node 										
- **Service Level Agreement** 								
  - Premium 										
  - Standard 										
  - Self-Support 										
- **Usage**
  - Production
  - Development/Test
  - Disaster Recovery

[![System Purpose](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-8-Performing_a_standard_RHEL_installation-en-US/images/97c78647c1f74e72c0d63496508e0822/configuring-system-purpose.jpg)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-8-Performing_a_standard_RHEL_installation-en-US/images/97c78647c1f74e72c0d63496508e0822/configuring-system-purpose.jpg)						

#### System Purpose status

The System Purpose status changes according to the number of  attributes matched against the set of attached subscriptions. The  possible statuses are: 						

-  									**Matched** 								

   All attributes of specified System Purpose have been covered by one of the attached subscriptions. 

-  									**Mismatched** 								

   One or more specified attributes of System Purpose are not  covered by the attached subscription. In such case, details about each  attribute of System Purpose that is mismatched are provided. 				

-  									**Not specified** 							

   None of the attributes were specified for the system. 					

### Securing your system

1.  							To update your system					

   ```
   # yum update
   ```

2.  							To start `firewalld`

        ```
        
        ```

systemctl start firewalld

systemctl enable firewalld

   ```
3.  							To enhance security, disable services that you do not need. For  example, if your system has no printers installed, disable the cups  service using the following command: 						

   ```
   # systemctl mask cups
   ```

    To review active services, run the following command: 						

   ```
   $ systemctl list-units | grep service
   ```

## Appendix A. Troubleshooting

 				The following sections cover various troubleshooting information which may be helpful when diagnosing installation issues. 			

## A.1. Consoles and logging during installation

 					The Red Hat Enterprise Linux installer uses the **tmux**  terminal multiplexer to display and control several windows you can use  in addition to the main interface. Each of these windows serves a  different purpose - they display several different logs, which can be  used to troubleshoot any issues during the installation, and one of the  windows provides an interactive shell prompt with `root` privileges, unless this prompt was specifically disabled using a boot option or a Kickstart command. 				

Note

 						In general, there is no reason to leave the default graphical  installation environment unless you need to diagnose an installation  problem. 					

 					The terminal multiplexer is running in virtual console 1. To switch from the actual installation environment to **tmux**, press **Ctrl**+**Alt**+**F1**. To go back to the main installation interface which runs in virtual console 6, press **Ctrl**+**Alt**+**F6**. 				

Note

 						If you choose text mode installation, you will start in virtual console 1 (**tmux**), and switching to console 6 will open a shell prompt instead of a graphical interface. 					

 					The console running **tmux**  has 5 available windows; their contents are described in the table  below, along with keyboard shortcuts used to access them. Note that the  keyboard shortcuts are two-part: first press **Ctrl**+**b**, then release both keys, and press the number key for the window you want to use. 				

 					You can also use **Ctrl**+**b** **n** and **Ctrl**+**b** **p** to switch to the next or previous **tmux** window, respectively. 				

**Table A.1. Available tmux windows**

| Shortcut             | Contents                                                     |
| -------------------- | ------------------------------------------------------------ |
| **Ctrl**+**b** **1** | Main installation program window. Contains text-based prompts  (during text mode installation or if you use VNC direct mode), and also  some debugging information. |
| **Ctrl**+**b** **2** | Interactive shell prompt with `root` privileges.             |
| **Ctrl**+**b** **3** | Installation log; displays messages stored in `/tmp/anaconda.log`. |
| **Ctrl**+**b** **4** | Storage log; displays messages related to storage devices from kernel and system services, stored in `/tmp/storage.log`. |
| **Ctrl**+**b** **5** | Program log; displays messages from other system utilities, stored in `/tmp/program.log`. |

## A.2. Saving screenshots

 					You can press **Shift**+**Print Screen** at any time during the graphical installation to capture the current screen. These screenshots are saved to `/tmp/anaconda-screenshots`. 				

## A.3. Resuming an interrupted download attempt

 					You can resume an interrupted download using the `curl` command. 				

**Prerequisite**

 						You have navigated to the **Product Downloads** section of the Red Hat Customer Portal at https://access.redhat.com/downloads, and selected the required variant, version, and architecture. You have right-clicked on the required ISO file, and selected **Copy Link Location** to copy the URL of the ISO image file to your clipboard. 					

**Procedure**

1.  							Download the ISO image from the new link. Add the `--continue-at -` option to automatically resume the download: 						

   ```
   $ curl --output directory-path/filename.iso 'new_copied_link_location' --continue-at -
   ```

2.  							Use a checksum utility such as **sha256sum** to verify the integrity of the image file after the download finishes: 						

   ```
   $ sha256sum rhel-8.0-x86_64-dvd.iso
   			`85a...46c rhel-8.0-x86_64-dvd.iso`
   ```

    							Compare the output with reference checksums provided on the Red Hat Enterprise Linux **Product Download** web page. 						

**Example A.1. Resuming an interrupted download attempt**

 						The following is an example of a `curl` command for a partially downloaded ISO image: 					

   ```
$ curl --output _rhel-8.0-x86_64-dvd.iso 'https://access.cdn.redhat.com//content/origin/files/sha256/85/85a...46c/rhel-8.0-x86_64-dvd.iso?_auth=141...963' --continue-at -
```

## Appendix B. System requirements reference

 				This section provides information and guidelines for hardware,  installation target, system, memory, and RAID when installing Red Hat  Enterprise Linux. 			

## B.1. Hardware compatibility

 					Red Hat works closely with hardware vendors on supported hardware. 				

-  							To verify that your hardware is supported, see the Red Hat Hardware Compatibility List, available at https://access.redhat.com/ecosystem/search/#/category/Server. 						
-  							To view supported memory sizes or CPU counts, see https://access.redhat.com/articles/rhel-limits for information. 						

## B.2. Supported installation targets

 					An installation target is a storage device that stores Red Hat  Enterprise Linux and boots the system. Red Hat Enterprise Linux supports  the following installation targets for AMD64, Intel 64, and 64-bit ARM  systems: 				

-  							Storage connected by a standard internal interface, such as SCSI, SATA, or SAS 						
-  							BIOS/firmware RAID devices 						
-  							NVDIMM devices in sector mode on the Intel64 and AMD64 architectures, supported by the nd_pmem driver. 						
-  							Fibre Channel Host Bus Adapters and multipath devices. Some can require vendor-provided drivers. 						
-  							Xen block devices on Intel processors in Xen virtual machines. 						
-  							VirtIO block devices on Intel processors in KVM virtual machines. 						

 					Red Hat does not support installation to USB drives or SD memory  cards. For information about support for third-party virtualization  technologies, see the [Red Hat Hardware Compatibility List](https://hardware.redhat.com/). 				

## B.3. System specifications

 					The Red Hat Enterprise Linux installation program automatically  detects and installs your system’s hardware, so you should not have to  supply any specific system information. However, for certain Red Hat  Enterprise Linux installation scenarios, it is recommended that you  record system specifications for future reference. These scenarios  include: 				

**Installing RHEL with a customized partition layout**

 						**Record:** The  model numbers, sizes, types, and interfaces of the hard drives attached  to the system. For example, Seagate ST3320613AS 320 GB on SATA0, Western  Digital WD7500AAKS 750 GB on SATA1. 					

**Installing RHEL as an additional operating system on an existing system**

 						**Record:**  Partitions used on the system. This information can include file system  types, device node names, file system labels, and sizes, and allows you  to identify specific partitions during the partitioning process. If one  of the operating systems is a Unix operating system, Red Hat  Enterprise Linux may report the device names differently. Additional  information can be found by executing the equivalent of the **mount** command and the **blkid** command, and in the **/etc/fstab** file. 					

 					If multiple operating systems are installed, the Red Hat  Enterprise Linux installation program attempts to automatically detect  them, and to configure boot loader to boot them. You can manually  configure additional operating systems if they are not detected  automatically. See *Configuring boot loader* in [Section 6.5, “Configuring software options”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#configuring-software-settings_graphical-installation) for more information. 				

**Installing RHEL from an image on a local hard drive**

 						**Record:** The hard drive and directory that holds the image. 					

**Installing RHEL from a network location**

 						If the network has to be configured manually, that is, DHCP is not used. 					

 					**Record:** 				

-  							IP address 						
-  							Netmask 						
-  							Gateway IP address 						
-  							Server IP addresses, if required 						

 					Contact your network administrator if you need assistance with networking requirements. 				

**Installing RHEL on an iSCSI target**

 						**Record:** The  location of the iSCSI target. Depending on your network, you may need a  CHAP user name and password, and a reverse CHAP user name and password. 					

**Installing RHEL if the system is part of a domain**

 						Verify that the domain name is supplied by the DHCP server. If it is not, enter the domain name during installation. 					

## B.4. Disk and memory requirements

 					If several operating systems are installed, it is important that  you verify that the allocated disk space is separate from the disk space  required by Red Hat Enterprise Linux. 				

Note

-  								For AMD64, Intel 64, and 64-bit ARM, at least two partitions (`/` and `swap`) must be dedicated to Red Hat Enterprise Linux. 							
-  								For IBM Power Systems servers, at least three partitions (`/`, `swap`, and a `PReP` boot partition) must be dedicated to Red Hat Enterprise Linux. 							

 					You must have a minimum of 10 GiB of available disk space. See [Appendix C, *Partitioning reference*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#partitioning-reference_installing-RHEL) for more information. 				

 					To install Red Hat Enterprise Linux, you must have a minimum of 10  GiB of space in either unpartitioned disk space or in partitions that  can be deleted. See [Appendix C, *Partitioning reference*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#partitioning-reference_installing-RHEL) for more information. 				

**Table B.1. Minimum RAM requirements**

| Installation type                       | Recommended minimum RAM |
| --------------------------------------- | ----------------------- |
| Local media installation (USB, DVD)     | 768 MiB                 |
| NFS network installation                | 768 MiB                 |
| HTTP, HTTPS or FTP network installation | 1.5 GiB                 |

Note

 						It is possible to complete the installation with less memory than  the recommended minimum requirements. The exact requirements depend on  your environment and installation path. It is recommended that you test  various configurations to determine the minimum required RAM for your  environment. Installing Red Hat Enterprise Linux using a Kickstart file  has the same recommended minimum RAM requirements as a standard  installation. However, additional RAM may be required if your Kickstart  file includes commands that require additional memory, or write data to  the RAM disk. See the [*Performing an advanced RHEL installation*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_an_advanced_rhel_installation/index/) document for more information. 					

## B.5. RAID requirements

 					It is important to understand how storage technologies are  configured and how support for them may have changed between major  versions of Red Hat Enterprise Linux. 				

**Hardware RAID**

 						Any RAID functions provided by the mainboard of your computer, or  attached controller cards, need to be configured before you begin the  installation process. Each active RAID array appears as one drive within  Red Hat Enterprise Linux. 					

**Software RAID**

 						On systems with more than one hard drive, you can use the Red Hat  Enterprise Linux installation program to operate several of the drives  as a Linux software RAID array. With a software RAID array, RAID  functions are controlled by the operating system rather than the  dedicated hardware. 					

Note

 						When a pre-existing RAID array’s member devices are all  unpartitioned disks/drives, the installation program treats the array as  a disk and there is no method to remove the array. 					

**USB Disks**

 						You can connect and configure external USB storage after  installation. Most devices are recognized by the kernel, but some  devices may not be recognized. If it is not a requirement to configure  these disks during installation, disconnect them to avoid potential  problems. 					

**NVDIMM devices**

 						To use a Non-Volatile Dual In-line Memory Module (NVDIMM) device as storage, the following conditions must be satisfied: 					

-  							Version of Red Hat Enterprise Linux is 7.6 or later. 						
-  							The architecture of the system is Intel 64 or AMD64. 						
-  							The device is configured to sector mode. Anaconda can reconfigure NVDIMM devices to this mode. 						
-  							The device must be supported by the nd_pmem driver. 						

 					Booting from an NVDIMM device is possible under the following additional conditions: 				

-  							The system uses UEFI. 						
-  							The device must be supported by firmware available on the system,  or by a UEFI driver. The UEFI driver may be loaded from an option ROM  of the device itself. 						
-  							The device must be made available under a namespace. 						

 					To take advantage of the high performance of NVDIMM devices during booting, place the `/boot` and `/boot/efi` directories on the device. 				

Note

 						The Execute-in-place (XIP) feature of NVDIMM devices is not  supported during booting and the kernel is loaded into conventional  memory. 					

**Considerations for Intel BIOS RAID Sets**

 						Red Hat Enterprise Linux uses `mdraid`  for installing on Intel BIOS RAID sets. These sets are automatically  detected during the boot process and their device node paths can change  across several booting processes. For this reason, local modifications  to the `/etc/fstab`, `/etc/crypttab`  or other configuration files that refer to the devices by their device  node paths may not work in Red Hat Enterprise Linux. It is recommended  that you replace device node paths (such as `/dev/sda`) with file system labels or device UUIDs. You can find the file system labels and device UUIDs using the `blkid` command. 					

## Appendix C. Partitioning reference

## C.1. Supported device types

- Standard partition

   								A standard partition can contain a file system or swap space. Standard partitions are most commonly used for `/boot` and the `BIOS Boot` and `EFI System partitions`. LVM logical volumes are recommended for most other uses. 							

- LVM

   								Choosing `LVM` (or Logical Volume  Management) as the device type creates an LVM logical volume. If no LVM  volume group currently exists, one is automatically created to contain  the new volume; if an LVM volume group already exists, the volume is  assigned. LVM can improve performance when using physical disks, and it  allows for advanced setups such as using multiple physical disks for one  mount point, and setting up software RAID for increased performance,  reliability, or both. 							

- LVM thin provisioning

   								Using thin provisioning, you can manage a storage pool of free  space, known as a thin pool, which can be allocated to an arbitrary  number of devices when needed by applications. You can dynamically  expand the pool when needed for cost-effective allocation of storage  space. 							

Warning

 						The installation program does not support overprovisioned LVM thin pools. 					

## C.2. Supported file systems

 					This section describes the file systems available in Red Hat Enterprise Linux. 				

- xfs

   								`XFS` is a highly scalable,  high-performance file system that supports file systems up to 16  exabytes (approximately 16 million terabytes), files up to 8 exabytes  (approximately 8 million terabytes), and directory structures containing  tens of millions of entries. `XFS` also  supports metadata journaling, which facilitates quicker crash recovery.  The maximum supported size of a single XFS file system is 500 TB. `XFS` is the default and recommended file system on Red Hat Enterprise Linux. 							

- ext4

   								The `ext4` file system is based on the `ext3`  file system and features a number of improvements. These include  support for larger file systems and larger files, faster and more  efficient allocation of disk space, no limit on the number of  subdirectories within a directory, faster file system checking, and more  robust journaling. The maximum supported size of a single `ext4` file system is 50 TB. 							

- ext3

   								The `ext3` file system is based on the `ext2`  file system and has one main advantage - journaling. Using a journaling  file system reduces the time spent recovering a file system after it  terminates unexpectedly, as there is no need to check the file system  for metadata consistency by running the fsck utility every time. 							

- ext2

   								An `ext2` file system supports  standard Unix file types, including regular files, directories, or  symbolic links. It provides the ability to assign long file names, up to  255 characters. 							

- swap

   								Swap partitions are used to support virtual memory. In other  words, data is written to a swap partition when there is not enough RAM  to store the data your system is processing. 							

- vfat

   								The `VFAT` file system is a Linux file system that is compatible with Microsoft Windows long file names on the FAT file system. 							

- BIOS Boot

   								A very small partition required for booting from a device with a  GUID partition table (GPT) on BIOS systems and UEFI systems in BIOS  compatibility mode. 							

- EFI System Partition

   								A small partition required for booting a device with a GUID partition table (GPT) on a UEFI system. 							

- PReP

   								This small boot partition is located on the first partition of the hard drive. The `PReP` boot partition contains the GRUB2 boot loader, which allows other IBM Power Systems servers to boot Red Hat Enterprise Linux. 							

## C.3. Supported RAID types

 					RAID stands for Redundant Array of Independent Disks, a technology  which allows you to combine multiple physical disks into logical units.  Some setups are designed to enhance performance at the cost of  reliability, while others will improve reliability at the cost of  requiring more disks for the same amount of available space. 				

 					This section describes supported software RAID types which you can  use with LVM and LVM Thin Provisioning to set up storage on the  installed system. 				

- None

   								No RAID array will be set up. 							

- RAID0

   								Performance: Distributes data across multiple disks. RAID 0  offers increased performance over standard partitions and can be used to  pool the storage of multiple disks into one large virtual device. Note  that RAID 0 offers no redundancy and that the failure of one device in  the array destroys data in the entire array. RAID 0 requires at least  two disks. 							

- RAID1

   								Redundancy: Mirrors all data from one partition onto one or more  other disks. Additional devices in the array provide increasing levels  of redundancy. RAID 1 requires at least two disks. 							

- RAID4

   								Error checking: Distributes data across multiple disks and uses  one disk in the array to store parity information which safeguards the  array in case any disk in the array fails. As all parity information is  stored on one disk, access to this disk creates a "bottleneck" in the  array’s performance. RAID 4 requires at least three disks. 							

- RAID5

   								Distributed error checking: Distributes data and parity  information across multiple disks. RAID 5 offers the performance  advantages of distributing data across multiple disks, but does not  share the performance bottleneck of RAID 4 as the parity information is  also distributed through the array. RAID 5 requires at least three  disks. 							

- RAID6

   								Redundant error checking: RAID 6 is similar to RAID 5, but  instead of storing only one set of parity data, it stores two sets. RAID  6 requires at least four disks. 							

- RAID10

   								Performance and redundancy: RAID 10 is nested or hybrid RAID. It  is constructed by distributing data over mirrored sets of disks. For  example, a RAID 10 array constructed from four RAID partitions consists  of two mirrored pairs of striped partitions. RAID 10 requires at least  four disks. 							

## C.4. Recommended partitioning scheme

 					Red Hat recommends that you create separate file systems at the following mount points: 				

-  							`/boot` 						

-  							`/` (root) 						

-  							`/home` 						

-  							`swap` 						

-  							`/boot/efi` 						

-  							`PReP` 						

  - `/boot` partition - recommended size at least 1 GiB

     										The partition mounted on `/boot`  contains the operating system kernel, which allows your system to boot  Red Hat Enterprise Linux 8, along with files used during the bootstrap  process. Due to the limitations of most firmwares, creating a small  partition to hold these is recommended. In most scenarios, a 1 GiB boot  partition is adequate. Unlike other mount points, using an LVM volume  for `/boot` is not possible - `/boot` must be located on a separate disk partition. 									Warning 											Normally, the `/boot` partition is created automatically by the installation program. However, if the `/` (root) partition is larger than 2 TiB and (U)EFI is used for booting, you need to create a separate `/boot` partition that is smaller than 2 TiB to boot the machine successfully. 										Note 											If you have a RAID card, be aware that some BIOS types do not  support booting from the RAID card. In such a case, the `/boot` partition must be created on a partition outside of the RAID array, such as on a separate hard drive. 										

  - `root` - recommended size of 10 GiB

     										This is where "`/`", or the root  directory, is located. The root directory is the top-level of the  directory structure. By default, all files are written to this file  system unless a different file system is mounted in the path being  written to, for example, `/boot` or `/home`. 									 										While a 5 GiB root file system allows you to install a minimal  installation, it is recommended to allocate at least 10 GiB so that you  can install as many package groups as you want. 									Important 											Do not confuse the `/` directory with the `/root` directory. The `/root` directory is the home directory of the root user. The `/root` directory is sometimes referred to as *slash root* to distinguish it from the root directory. 										

  - `/home` - recommended size at least 1 GiB

     										To store user data separately from system data, create a dedicated file system for the `/home`  directory. Base the file system size on the amount of data that is  stored locally, number of users, and so on. You can upgrade or reinstall  Red Hat Enterprise Linux 8 without erasing user data files. If you  select automatic partitioning, it is recommended to have at least 55 GiB  of disk space available for the installation, to ensure that the `/home` file system is created. 									

  - `swap` partition - recommended size at least 1 GB

     										Swap file systems support virtual memory; data is written to a  swap file system when there is not enough RAM to store the data your  system is processing. Swap size is a function of system memory workload,  not total system memory and therefore is not equal to the total system  memory size. It is important to analyze what applications a system will  be running and the load those applications will serve in order to  determine the system memory workload. Application providers and  developers can provide guidance. 									 										When the system runs out of swap space, the kernel terminates  processes as the system RAM memory is exhausted. Configuring too much  swap space results in storage devices being allocated but idle and is a  poor use of resources. Too much swap space can also hide memory leaks.  The maximum size for a swap partition and other additional information  can be found in the `mkswap(8)` manual page. 									 										The following table provides the recommended size of a swap  partition depending on the amount of RAM in your system and if you want  sufficient memory for your system to hibernate. If you let the  installation program partition your system automatically, the swap  partition size is established using these guidelines. Automatic  partitioning setup assumes hibernation is not in use. The maximum size  of the swap partition is limited to 10 percent of the total size of the  hard drive, and the installation program cannot create swap partitions  more than 128 GB in size. To set up enough swap space to allow for  hibernation, or if you want to set the swap partition size to more than  10 percent of the system’s storage space, or more than 128 GB, you must  edit the partitioning layout manually. 									

  - `/boot/efi` partition - recommended size of 200 MiB

     										UEFI-based AMD64, Intel 64, and 64-bit ARM require a 200 MiB  EFI system partition. The recommended minimum size is 200 MiB, the  default size is 600 MiB, and the maximum size is 600 MiB. BIOS systems  do not require an EFI system partition. 									

**Table C.1. Recommended System Swap Space**

| Amount of RAM in the system | Recommended swap space              | Recommended swap space if allowing for hibernation |
| --------------------------- | ----------------------------------- | -------------------------------------------------- |
| Less than 2 GB              | 2 times the amount of RAM           | 3 times the amount of RAM                          |
| 2 GB - 8 GB                 | Equal to the amount of RAM          | 2 times the amount of RAM                          |
| 8 GB - 64 GB                | 4 GB to 0.5 times the amount of RAM | 1.5 times the amount of RAM                        |
| More than 64 GB             | Workload dependent (at least 4GB)   | Hibernation not recommended                        |

 					At the border between each range, for example, a system with 2 GB,  8 GB, or 64 GB of system RAM, discretion can be exercised with regard to  chosen swap space and hibernation support. If your system resources  allow for it, increasing the swap space can lead to better performance. 				

 					Distributing swap space over multiple storage devices -  particularly on systems with fast drives, controllers and interfaces -  also improves swap space performance. 				

 					Many systems have more partitions and volumes than the minimum  required. Choose partitions based on your particular system needs. 				

Note

-  								Only assign storage capacity to those partitions you require  immediately. You can allocate free space at any time, to meet needs as  they occur. 							
-  								If you are unsure about how to configure partitions, accept the  automatic default partition layout provided by the installation program. 							

- `PReP` boot partition - recommended size of 4 to 8 MiB

   								When installing Red Hat Enterprise Linux on IBM Power System  servers, the first partition of the hard drive should include a `PReP`  boot partition. This contains the GRUB2 boot loader, which allows other  IBM Power Systems servers to boot Red Hat Enterprise Linux. 							

## C.5. Advice on partitions

 					There is no best way to partition every system; the optimal setup  depends on how you plan to use the system being installed. However, the  following tips may help you find the optimal layout for your needs: 				

-  							Create partitions that have specific requirements first, for  example, if a particular partition must be on a specific disk. 						

-  							Consider encrypting any partitions and volumes which might  contain sensitive data. Encryption prevents unauthorized people from  accessing the data on the partitions, even if they have access to the  physical storage device. In most cases, you should at least encrypt the `/home` partition, which contains user data. 						

-  							In some cases, creating separate mount points for directories other than `/`, `/boot` and `/home` may be useful; for example, on a server running a **MySQL** database, having a separate mount point for `/var/lib/mysql`  will allow you to preserve the database during a reinstallation without  having to restore it from backup afterwards. However, having  unnecessary separate mount points will make storage administration more  difficult. 						

-  							Some special restrictions apply to certain directories with  regards on which partitioning layouts can they be placed. Notably, the `/boot` directory must always be on a physical partition (not on an LVM volume). 						

-  							If you are new to Linux, consider reviewing the *Linux Filesystem Hierarchy Standard* at http://refspecs.linuxfoundation.org/FHS_2.3/fhs-2.3.html for information about various system directories and their contents. 						

-  							Each kernel installed on your system requires approximately 56 MB on the `/boot` partition: 						

  -  									32 MB initramfs 								

  -  									14 MB kdump initramfs 								

  -  									3.5 MB system map 								

  -  									6.6 MB vmlinuz 								

    Note

     										For rescue mode, `initramfs` and `vmlinuz` require 80 MB. 									

     									The default partition size of 1 GB for `/boot`  should suffice for most common use cases. However, it is recommended  that you increase the size of this partition if you are planning on  retaining multiple kernel releases or errata kernels. 								

-  							The `/var` directory holds content for a number of applications, including the **Apache** web server, and is used by the **DNF** package manager to temporarily store downloaded package updates. Make sure that the partition or volume containing `/var` has at least 3 GB. 						

-  							The contents of the `/var`  directory usually change very often. This may cause problems with older  solid state drives (SSDs), as they can handle a lower number of  read/write cycles before becoming unusable. If your system root is on an  SSD, consider creating a separate mount point for `/var` on a classic (platter) HDD. 						

-  							The `/usr` directory holds  the majority of software on a typical Red Hat Enterprise Linux  installation. The partition or volume containing this directory should  therefore be at least 5 GB for minimal installations, and at least 10 GB  for installations with a graphical environment. 						

-  							If `/usr` or `/var`  is partitioned separately from the rest of the root volume, the boot  process becomes much more complex because these directories contain  boot-critical components. In some situations, such as when these  directories are placed on an iSCSI drive or an FCoE location, the system  may either be unable to boot, or it may hang with a `Device is busy` error when powering off or rebooting. 						

            							This limitation only applies to `/usr` or `/var`, not to directories below them. For example, a separate partition for `/var/www` will work without issues. 						

-  							Consider leaving a portion of the space in an LVM volume group  unallocated. This unallocated space gives you flexibility if your space  requirements change but you do not wish to remove data from other  volumes. You can also select the `LVM Thin Provisioning` device type for the partition to have the unused space handled automatically by the volume. 						

-  							The size of an XFS file system can not be reduced - if you need  to make a partition or volume with this file system smaller, you must  back up your data, destroy the file system, and create a new, smaller  one in its place. Therefore, if you expect needing to manipulate your  partitioning layout later, you should use the ext4 file system instead. 						

-  							Use Logical Volume Management (LVM) if you anticipate expanding  your storage by adding more hard drives or expanding virtual machine  hard drives after the installation. With LVM, you can create physical  volumes on the new drives, and then assign them to any volume group and  logical volume as you see fit - for example, you can easily expand your  system’s `/home` (or any other directory residing on a logical volume). 						

-  							Creating a BIOS Boot partition or an EFI System Partition may be  necessary, depending on your system’s firmware, boot drive size, and  boot drive disk label. See [Section C.4, “Recommended partitioning scheme”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#recommended-partitioning-scheme_partitioning-reference)  for information about these partitions. Note that graphical  installation will not let you create a BIOS Boot or EFI System Partition  if your system does **not** require one - in that case, they will be hidden from the menu. 						

-  							If you need to make any changes to your storage configuration  after the installation, Red Hat Enterprise Linux repositories offer  several different tools which can help you do this. If you prefer a  command line tool, try **system-storage-manager**. 						

## Appendix D. Boot options reference

 				This section contains information about some of the boot options  that you can use to modify the default behavior of the installation  program. For Kickstart and advanced boot options, see the [*Performing an advanced RHEL installation*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_an_advanced_rhel_installation/index/) document. 			

## D.1. Installation source boot options

 					This section contains information about the various installation source boot options. 				

- inst.repo=

   								The `inst.repo=` boot option specifies the installation source, that is, the location providing the package repositories and a valid `.treeinfo` file that describes them. For example: `inst.repo=cdrom`. The target of the `inst.repo=` option must be one of the following installation media: 							 										an installable tree, which is a directory structure containing  the installation program images, packages, and repository data as well  as a valid `.treeinfo` file 									 										a DVD (a physical disk present in the system DVD drive) 									 										an ISO image of the full Red Hat Enterprise Linux installation  DVD, placed on a hard drive or a network location accessible to the  system. 									 										You can use the `inst.repo=` boot option to configure different installation methods using different formats. The following table contains details of the `inst.repo=` boot option syntax: 									**Table D.1. inst.repo= installation source boot options**Source typeBoot option formatSource format  														CD/DVD drive 													 													   														`inst.repo=cdrom[:*device*]` 													 													   														Installation DVD as a physical disk. [[a\]](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#ftn.idm140366010010976) 													 													   														Installable tree 													 													   														`inst.repo=hd:*device*:*/path*` 													 													   														Image file of the installation DVD, or an installation  tree, which is a complete copy of the directories and files on the  installation DVD. 													 													   														NFS Server 													 													   														`inst.repo=nfs:[*options*:]*server*:*/path*` 													 													   														Image file of the installation DVD. [[b\]](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#ftn.idm140366009995792) 													 													   														HTTP Server 													 													   														`inst.repo=http://*host/path*` 													 													   														Installation tree, which is a complete copy of the directories and files on the installation DVD. 													 													   														HTTPS Server 													 													   														`inst.repo=https://*host/path*` 													 													   														FTP Server 													 													   														`inst.repo=ftp://*username*:*password*@*host*/*path*` 													 													   														HMC 													 													   														`inst.repo=hmc` 													 													  [[a\] ](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#idm140366010010976) 															If *device* is left out, installation program automatically searches for a drive containing the installation DVD. 														[[b\] ](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#idm140366009995792) 															The NFS Server option uses NFS protocol version 3 by default. To use a different version *X*, add `+nfsvers=*X*` to *options*. 														Note 											The NFS Server option uses NFS protocol version 3 by default. To use a different version, add `+nfsvers=X` to the option. 										 										You can set disk device names with the following formats: 									 										Kernel device name, for example `/dev/sda1` or `sdb2` 									 										File system label, for example `LABEL=Flash` or `LABEL=RHEL8` 									 										File system UUID, for example `UUID=8176c7bf-04ff-403a-a832-9557f94e61db` 									 										Non-alphanumeric characters must be represented as `\xNN`, where *NN* is the hexadecimal representation of the character. For example, `\x20` is a white space `(" ")`. 									

- inst.addrepo=

   								Use the `inst.addrepo=` boot option to add an additional repository that can be used as another installation source along with the main repository (`inst.repo=`). You can use the `inst.addrepo=` boot option multip le times during one boot. The following table contains details of the `inst.addrepo=` boot option syntax. 							Note 									The `REPO_NAME` is the name of the  repository and is required in the installation process. These  repositories are only used during the installation process; they are not  installed on the installed system. 								**Table D.2. inst.addrepo installation source boot options**Installation sourceBoot option formatAdditional information  												Installable tree at a URL 											 											   												`inst.addrepo=REPO_NAME,[http,https,ftp]://<host>/<path>` 											 											   												Looks for the installable tree at a given URL. 											 											   												Installable tree at an NFS path 											 											   												`inst.addrepo=REPO_NAME,nfs://<server>:/<path>` 											 											   												Looks for the installable tree at a given NFS path. A colon  is required after the host. The installation program passes every thing  after `nfs://` directly to the mount command instead of parsing URLs according to RFC 2224. 											 											   												Installable tree in the installation environment 											 											   												`inst.addrepo=REPO_NAME,file://<path>` 											 											   												Looks for the installable tree at the given location in the  installation environment. To use this option, the repositor y must be  mounted before the installation program attempts to load the available  software groups. The benefit of this option is that you can have  multiple repositories on one bootable ISO, and you can install both the  main repository and additional repositories from the ISO. The path to  the additional repositories is `/run/install/source/REPO_ISO_PATH`. Additional, you can mount the repository directory in the `%pre` secti on in the Kickstart file. The path must be absolute and start with `/`, for example `inst.addrepo=REPO_NAME,file:///<path>` 											 											   												Hard Drive 											 											   												`inst.addrepo=REPO_NAME,hd:<device>:<path>` 											 											   												Mounts the given *<device>* partition and installs from the ISO that is specified by the *<path>*. If the *<path>* is not specified, the installation p rogram looks for a valid installation ISO on the *<device>*. This installation method requires an ISO with a valid installable tree. 											 											 

- inst.noverifyssl=

   								The `noverifyssl=` boot option  prevents the installation program from verifying the SSL certificate for  all HTTPS connections with the exception of the additional Kickstart  repositories, where `--noverifyssl` can be set per repository. 							

- inst.stage2=

   								Use the `inst.stage2=` boot option to  specify the location of the installation program runtime image. This  option expects a path to a directory containing a valid `.treeinfo` file. The location of the runtime image is read from the `.treeinfo` file. If the `.treeinfo` file is not available, the installation program attempts to load the image from `LiveOS/squashfs.img`. 							 								When the `inst.stage2` option is not specified, the installation program attempts to use the location specified with `inst.repo` option. 							 								You should specify this option only for PXE boot. The installation DVD and Boot ISO already contain a correct `inst.stage2` option to boot the installation program from themselves. 							Note 									By default, the `inst.stage2=` boot option is used on the installation media and is set to a specific label, for example, `inst.stage2=hd:LABEL=RHEL-8-0-0-BaseOS-x86_64`.  If you modify the default label of the file system containing the  runtime image, or if you use a customized procedure to boot the  installation system, you must verify that the `inst.stage2=` boot option is set to the correct value. 								

- inst.stage2.all

   								The `inst.stage2.all` boot option is used to specify several HTTP, HTTPS, or FTP sources. You can use the `inst.stage2=` boot option multiple times with the `inst.stage2.all` option to fetch the image from the sources sequentially until one succeeds. For example: 							`inst.stage2.all inst.stage2=http://hostname1/path_to_install_tree/ inst.stage2=http://hostname2/path_to_install_tree/ inst.stage2=http://hostname3/path_to_install_tree/`

- inst.dd=

   								The `inst.dd=` boot option is used to perform a driver update during the installation. See the [*Performing an advanced RHEL installation*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_an_advanced_rhel_installation/index/) document for information on how to update drivers during installation. 							

- inst.repo=hmc

   								When booting from a Binary DVD, the installation program prompts  you to enter additional kernel parameters. To set the DVD as an  installation source, append `inst.repo=hmc` to the kernel parameters. The installation program then enables `SE` and `HMC`  file access, fetches the images for stage2 from the DVD, and provides  access to the packages on the DVD for software selection. This option  eliminates the requirement of an external network setup and expands the  installation options. 							

- inst.proxy

   								The `inst.proxy` boot option is used when performing an installation from a HTTP, HTTPS, FTP source. For example: 							`[PROTOCOL://][USERNAME[:PASSWORD]@]HOST[:PORT]`

- inst.nosave

   								Use the `inst.nosave` boot option to control which installation logs and related files are not saved to the installed system, for example `input_ks`, `output_ks`, `all_ks`, `logs` and `all`. Multiple values can be combined as a comma-separated list, for example: `input_ks,logs`. 							Note 									The `inst.nosave` boot option is  used for excluding files from the installed system that can’t be removed  by a Kickstart %post script, such as logs and input/output Kickstart  results. 								**Table D.3. inst.nosave boot options**OptionDescription  												input_ks 											 											   												Disables the ability to save the input Kickstart results. 											 											   												output_ks 											 											   												Disables the ability to save the output Kickstart results generated by the installation program. 											 											   												all_ks 											 											   												Disables the ability to save the input and output Kickstart results. 											 											   												logs 											 											   												Disables the ability to save all installation logs. 											 											   												all 											 											   												Disables the ability to save all Kickstart results, and all logs. 											 											 

- inst.multilib

   								Use the `inst.multilib` boot option to set DNF’s `multilib_policy` to **all**, instead of **best**. 							

- memcheck

   								The `memcheck` boot option performs a  check to verify that the system has enough RAM to complete the  installation. If there isn’t enough RAM, the installation process is  stopped. The system check is approximate and memory usage during  installation depends on the package selection, user interface, for  example graphical or text, and other parameters. 							

- nomemcheck

   								The `nomemcheck` boot option does not  perform a check to verify if the system has enough RAM to complete the  installation. Any attempt to perform the installation with less than the  recommended minimum amount of memory is unsupported, and might result  in the installation process failing. 							

## D.2. Network boot options

 					This section contains information about commonly used network boot options. 				

Note

 						Initial network initialization is handled by `dracut`. For a complete list, see the `dracut.cmdline(7)` man page. 					

- ip=

   								Use the `ip=` boot option to configure one or more network interfaces. To configure multiple interfaces, you can use the `ip` option multiple times, once for each interface; to do so, you must use the `rd.neednet=1` option, and you must specify a primary boot interface using the `bootdev` option. Alternatively, you can use the `ip`  option once, and then use Kickstart to set up further interfaces. This  option accepts several different formats. The following tables contain  information about the most common options. 							Note 									In the following tables: 								 											The `ip` parameter specifies the client IP address. You can specify IPv6 addresses in square brackets, for example, [2001:DB8::1]. 										 											The `gateway` parameter is the default gateway. IPv6 addresses are also accepted. 										 											The `netmask` parameter is the  netmask to be used. This can be either a full netmask (for example,  255.255.255.0) or a prefix (for example, 64). 										 											The `hostname` parameter is the host name of the client system. This parameter is optional. 										**Table D.4. Network interface configuration boot option formats**Configuration methodBoot option format  												Automatic configuration of any interface 											 											   												`ip=method` 											 											   												Automatic configuration of a specific interface 											 											   												`ip=interface:method` 											 											   												Static configuration 											 											   												`ip=ip::gateway:netmask:hostname:interface:none` 											 											   												Automatic configuration of a specific interface with an override 											 											   												`ip=ip::gateway:netmask:hostname:interface:method:mtu` 											 											 Note 									The method `automatic configuration of a specific interface with an override` brings up the interface using the specified method of automatic configuration, such as `dhcp`,  but overrides the automatically-obtained IP address, gateway, netmask,  host name or other specified parameters. All parameters are optional, so  specify only the parameters that you want to override. 								 								The `method` parameter can be any of the following: 							**Table D.5. Automatic interface configuration methods**Automatic configuration methodValue  												DHCP 											 											   												`dhcp` 											 											   												IPv6 DHCP 											 											   												`dhcp6` 											 											   												IPv6 automatic configuration 											 											   												`auto6` 											 											   												iSCSI Boot Firmware Table (iBFT) 											 											   												`ibft` 											 											 Note 											If you use a boot option that requires network access, such as `inst.ks=http://host:/path`, without specifying the ip option, the installation program uses `ip=dhcp`. 										 											To connect to an iSCSI target automatically, you must  activate a network device for accessing the target. The recommended way  to activate a network is to use the `ip=ibft` boot option. 										

- nameserver=

   								The `nameserver=` option specifies the address of the name server. You can use this option multiple times. 							

- bootdev=

   								The `bootdev=` option specifies the boot interface. This option is mandatory if you use more than one `ip` option. 							

- ifname=

   								The `ifname=` options assigns an  interface name to a network device with a given MAC address. You can use  this option multiple times. The syntax is `ifname=interface:MAC`. For example: 							`ifname=eth0:01:23:45:67:89:ab`Note 									The `ifname=` option is the only supported way to set custom network interface names during installation. 								

- inst.dhcpclass=

   								The `inst.dhcpclass=` option specifies the DHCP vendor class identifier. The `dhcpd` service sees this value as `vendor-class-identifier`. The default value is `anaconda-$(uname -srm)`. 							

- inst.waitfornet=

   								Using the `inst.waitfornet=SECONDS` boot option causes the installation system to wait for network connectivity before installation. The value given in the `SECONDS`  argument specifies the maximum amount of time to wait for network  connectivity before timing out and continuing the installation process  even if network connectivity is not present. 							

#### Additional resources

-  							For more information about networking, see the [*Configuring and managing networking*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_networking/index/) document. 						

## D.3. Console boot options

 					This section contains information about configuring boot options for your console, monitor display, and keyboard. 				

- console=

   								Use the `console=` option to specify a  device that you want to use as the primary console. For example, to use  a console on the first serial port, use `console=ttyS0`. Use this option in conjunction with the `inst.text` option. You can use the `console=`  option multiple times. If you do, the boot message is displayed on all  specified consoles, but only the last one is used by the installation  program. For example, if you specify `console=ttyS0 console=ttyS1`, the installation program uses `ttyS1`. 							

- inst.lang=

   								Use the `inst.lang=` option to set the language that you want to use during the installation. The `locale -a | grep _` or `localectl list-locales | grep _` options return a list of locales. 							

- inst.singlelang

   								Use the `inst.singlelang` option to  install in single language mode, which results in no available  interactive options for the installation language and language support  configuration. If a language is specified using the `inst.lang` boot option or the `lang` Kickstart command, then it is used. If no language is specified, the installation program defaults to `en_US.UTF-8`. 							

- inst.geoloc=

   								Use the `inst.geoloc=` option to  configure geolocation usage in the installation program. Geolocation is  used to preset the language and time zone, and uses the following  syntax: `inst.geoloc=value`. The `value` can be any of the following parameters: 							**Table D.6. Values for the inst.geoloc boot option**ValueBoot option format  												Disable geolocation 											 											   												`inst.geoloc=0` 											 											   												Use the Fedora GeoIP API 											 											   												`inst.geoloc=provider_fedora_geoip` 											 											   												Use the Hostip.info GeoIP API 											 											   												`inst.geoloc=provider_hostip` 											 											  								If you do not specify the `inst.geoloc=` option, the installation program uses `provider_fedora_geoip`. 							

- inst.keymap=

   								Use the `inst.keymap=` option to specify the keyboard layout that you want to use for the installation. 							

- inst.cmdline

   								Use the `inst.cmdline` option to  force the installation program to run in command-line mode. This mode  does not allow any interaction, and you must specify all options in a  Kickstart file or on the command line. 							

- inst.graphical

   								Use the `inst.graphical` option to force the installation program to run in graphical mode. This mode is the default. 							

- inst.text

   								Use the `inst.text` option to force the installation program to run in text mode instead of graphical mode. 							

- inst.noninteractive

   								Use the `inst.noninteractive` boot  option to run the installation program in a non-interactive mode. User  interaction is not permitted in the non-interactive mode, and `inst.noninteractive` can be used with a graphical or text installation. When the `inst.noninteractive` option is used in text mode it behaves the same as the `inst.cmdline` option. 							

- inst.resolution=

   								Use the `inst.resolution=` option to specify the screen resolution in graphical mode. The format is `NxM`, where *N* is the screen width and *M* is the screen height (in pixels). The lowest supported resolution is 1024x768. 							

- inst.vnc=

   								Use the `inst.vnc=` option to run the  graphical installation using VNC. You must use a VNC client application  to interact with the installation program. When VNC sharing is enabled,  multiple clients can connect. A system installed using VNC starts in  text mode. 							

- inst.vncpassword=

   								Use the `inst.vncpassword=` option to set a password on the VNC server that is used by the installation program. 							

- inst.vncconnect=

   								Use the `inst.vncconnect=` option to connect to a listening VNC client at the given host location. For example `inst.vncconnect=<host>[:<port>]` The default port is 5900. This option can be used with `vncviewer -listen`. 							

- inst.xdriver=

   								Use the `inst.xdriver=` option to specify the name of the X driver that you want to use both during installation and on the installed system. 							

- inst.usefbx=

   								Use the `inst.usefbx` option to  prompt the installation program to use the frame buffer X driver instead  of a hardware-specific driver. This option is equivalent to `inst.xdriver=fbdev`. 							

- modprobe.blacklist=

   								Use the `modprobe.blacklist=` option  to blacklist or completely disable one or more drivers. Drivers (mods)  that you disable using this option cannot load when the installation  starts, and after the installation finishes, the installed system  retains these settings. You can find a list of the blacklisted drivers  in the `/etc/modprobe.d/` directory. Use a comma-separated list to disable multiple drivers. For example: 							`modprobe.blacklist=ahci,firewire_ohci`

- inst.xtimeout=

   								Use the `inst.xtimeout=` option to specify the timeout in seconds for starting X server. 							

- inst.sshd

   								Use the `inst.sshd` option to start the `sshd`  service during installation, so that you can connect to the system  during the installation using SSH, and monitor the installation  progress. For more information about SSH, see the `ssh(1)` man page. By default, the `sshd` option is automatically started only on the IBM Z architecture. On other architectures, `sshd` is not started unless you use the `inst.sshd` option. 							Note 									During installation, the root account has no password by  default. You can set a root password during installation with the `sshpw` Kickstart command. 								

- inst.kdump_addon=

   								Use the `inst.kdump_addon=` option to  enable or disable the Kdump configuration screen (add-on) in the  installation program. This screen is enabled by default; use `inst.kdump_addon=off` to disable it. Disabling the add-on disables the Kdump screens in both the graphical and text-based interface as well as the `%addon com_redhat_kdump` Kickstart command. 							

## D.4. Debug boot options

 					This section contains information about the options that you can use when debugging issues. 				

- inst.rescue=

   								Use the `inst.rescue=` option to run the rescue environment. The option is useful for trying to diagnose and fix systems. 							

- inst.updates=

   								Use the `inst.updates=` option to specify the location of the `updates.img` file that you want to apply during installation. There are a number of sources for the updates. 							**Table D.7. inst.updates= source updates**SourceDescriptionExample  												Updates from a network 											 											   												The easiest way to use `inst.updates=` is to specify the network location of `updates.img`. This does not require any modification to the installation tree. To use this method, edit the kernel command line to include `inst.updates`. 											 											   												`inst.updates=http://some.website.com/path/to/updates.img`. 											 											   												Updates from a disk image 											 											   												You can save an `updates.img` on a floppy drive or a USB key. This can be done only with an `ext2` filesystem type of `updates.img`. To save the contents of the image on your floppy drive, insert the floppy disc and run the command. 											 											   												`dd if=updates.img of=/dev/fd0 bs=72k count=20`. To use a USB key or flash media, replace `/dev/fd0` with the device name of your USB key. 											 											   												Updates from an installation tree 											 											   												If you are using a CD, hard drive, HTTP, or FTP install, you can save the `updates.img` in the installation tree so that all installations can detect the .img file. Save the file in the `images/` directory. The file name must be `updates.img`. 											 											   												For NFS installs, there are two options: You can either save the image in the `images/` directory, or in the `RHupdates/` directory in the installation tree. 											 											 

- inst.loglevel=

   								Use the `inst.loglevel=` option to  specify the minimum level of messages logged on a terminal. This  concerns only terminal logging; log files always contain messages of all  levels. Possible values for this option from the lowest to highest  level are: `debug`, `info`, `warning`, `error` and `critical`. The default value is `info`, which means that by default, the logging terminal displays messages ranging from `info` to `critical`. 							

- inst.syslog=

   								When installation starts, the `inst.syslog=` option sends log messages to the `syslog` process on the specified host. The remote `syslog` process must be configured to accept incoming connections. 							

- inst.virtiolog=

   								Use the `inst.virtiolog=` option to specify the virtio port (a character device at `/dev/virtio-ports/name`) that you want to use for forwarding logs. The default value is `org.fedoraproject.anaconda.log.0`; if this port is present, it is used. 							

- inst.zram

   								The `inst.zram` option controls the  usage of zRAM swap during installation. The option creates a compressed  block device inside the system RAM and uses it for swap space instead of  the hard drive. This allows the installation program to run with less  available memory than is possible without compression, and it might also  make the installation faster. By default, swap on zRAM is enabled on  systems with 2 GiB or less RAM, and disabled on systems with more than 2  GiB of memory. You can use this option to change this behavior; on a  system with more than 2 GiB RAM, use `inst.zram=1` to enable the feature, and on systems with 2 GiB or less memory, use `inst.zram=0` to disable the feature. 							

- rd.live.ram

   								If the `rd.live.ram` option is specified, the `stage 2` image is copied into RAM. Using this option when the `stage 2` image is on an NFS server increases the minimum required memory by the size of the image by roughly 500 MiB. 							

- inst.nokill

   								The `inst.nokill` option is a  debugging option that prevents the installation program from rebooting  when a fatal error occurs, or at the end of the installation process.  Use the `inst.nokill` option to capture installation logs which would be lost upon reboot. 							

- inst.noshell

   								Use `inst.noshell` option if you do not want a shell on terminal session 2 (tty2) during installation. 							

- inst.notmux

   								Use `inst.notmux` option if you do  not want to use tmux during installation. The output is generated  without terminal control characters and is meant for non-interactive  uses. 							

- remotelog

   								You can use the `remotelog` option to send all of the logs to a remote `host:port` using a TCP connection. The connection is retired if there is no listener and the installation proceeds as normal. 							

## D.5. Storage boot options

- inst.nodmraid=

   								Use the `inst.nodmraid=` option to disable `dmraid` support. 							

Warning

 						Use this option with caution. If you have a disk that is  incorrectly identified as part of a firmware RAID array, it might have  some stale RAID metadata on it that must be removed using the  appropriate tool, for example, `dmraid` or `wipefs`. 					

- inst.nompath=

   								Use the `inst.nompath=` option to  disable support for multipath devices. This option can be used for  systems on which a false-positive is encountered which incorrectly  identifies a normal block device as a multipath device. There is no  other reason to use this option. 							

Warning

 						Use this option with caution. You should not use this option with  multipath hardware. Using this option to attempt to install to a single  path of a multipath is not supported. 					

- inst.gpt

   								The `inst.gpt` boot option forces the  installation program to install partition information to a GUID  Partition Table (GPT) instead of a Master Boot Record (MBR). This option  is not valid on UEFI-based systems, unless they are in BIOS  compatibility mode. Normally, BIOS-based systems and UEFI-based systems  in BIOS compatibility mode attempt to use the MBR schema for storing  partitioning information, unless the disk is 232 sectors in size or  larger. Disk sectors are typically 512 bytes in size, meaning that this  is usually equivalent to 2 TiB. Using the `inst.gpt` boot option changes this behavior, allowing a GPT to be written to smaller disks. 							

## D.6. Deprecated boot options

 					This section contains information about deprecated boot options.  These options are still accepted by the installation program but they  are deprecated and are scheduled to be removed in a future release of  Red Hat Enterprise Linux. 				

- method

   								The `method` option is an alias for `inst.repo`. 							

- repo=nfsiso

   								The `repo=nfsiso:` option is the same as `inst.repo=nfs:`. 							

- dns

   								Use `nameserver` instead of `dns`. Note that nameserver does not accept comma-separated lists; use multiple nameserver options instead. 							

- netmask, gateway, hostname

   								The `netmask`, `gateway`, and `hostname` options are provided as part of the `ip` option. 							

- ip=bootif

   								A PXE-supplied `BOOTIF` option is used automatically, so there is no requirement to use `ip=bootif`. 							

- ksdevice

  **Table D.8. Values for the ksdevice boot option**ValueInformation  												Not present 											 											   												N/A 											 											   												`ksdevice=link` 											 											   												Ignored as this option is the same as the default behavior 											 											   												`ksdevice=bootif` 											 											   												Ignored as this option is the default if `BOOTIF=` is present 											 											   												`ksdevice=ibft` 											 											   												Replaced with `ip=ibft`. See `ip` for details 											 											   												`ksdevice=<MAC>` 											 											   												Replaced with `BOOTIF=${MAC/:/-}` 											 											   												`ksdevice=<DEV>` 											 											   												Replaced with `bootdev` 											 											 

## D.7. Removed boot options

 					This section contains the boot options that have been removed from Red Hat Enterprise Linux. 				

Note

 						`dracut` provides advanced boot options. For more information about `dracut`, see the `dracut.cmdline(7)` man page. 					

- askmethod, asknetwork

   								`initramfs` is completely non-interactive, so the `askmethod` and `asknetwork` options have been removed. Instead, use `inst.repo` or specify the appropriate network options. 							

- blacklist, nofirewire

   								The `modprobe` option handles blacklisting kernel modules; use `modprobe.blacklist=<mod1>,<mod2>`. You can blacklist the firewire module by using `modprobe.blacklist=firewire_ohci`. 							

- inst.headless=

   								The `headless=` option specified that  the system that is being installed to does not have any display  hardware, and that the installation program is not required to look for  any display hardware. 							

- inst.decorated

   								The `inst.decorated` option was used  to specify the graphical installation in a decorated window. By default,  the window is not decorated, so it doesn’t have a title bar, resize  controls, and so on. This option was no longer required. 							

- serial

   								Use the `console=ttyS0` option. 							

- updates

   								Use the `inst.updates` option. 							

- essid, wepkey, wpakey

   								Dracut does not support wireless networking. 							

- ethtool

   								This option was no longer required. 							

- gdb

   								This option was removed as there are many options available for debugging dracut-based `initramfs`. 							

- inst.mediacheck

   								Use the `dracut option rd.live.check` option. 							

- ks=floppy

   								Use the `inst.ks=hd:<device>` option. 							

- display

   								For a remote display of the UI, use the `inst.vnc` option. 							

- utf8

   								This option was no longer required as the default TERM setting behaves as expected. 							

- noipv6

   								ipv6 is built into the kernel and cannot be removed by the installation program. You can disable ipv6 using `ipv6.disable=1`. This setting is used by the installed system. 							

- upgradeany

   								This option was no longer required as the installation program no longer handles upgrades. 							

# Part II. Installing Red Hat Enterprise Linux on IBM Power System LC servers



 				This section describes how to install Red Hat Enterprise Linux on the IBM Power Systems LC server. 			

## Chapter 8. Installing Red Hat Enterprise Linux on IBM Power System LC servers

 				This guide helps you install Red Hat Enterprise Linux on a Linux on  Power Systems LC server. Use these instructions for the following IBM  Power System servers: 			

-  						8335-GCA (IBM Power System S822LC) 					
-  						8335-GTA (IBM Power System S822LC) 					
-  						8335-GTB (IBM Power System S822LC) 					
-  						8001-12C (IBM Power System S821LC) 					
-  						8001-22C (IBM Power System S822LC for Big Data) 					
-  						9006-12P (IBM Power System LC921) 					
-  						9006-22P (IBM Power System LC922) 					

## 8.1. Overview

 					Use this information to install Red Hat Enterprise Linux 8 on a  non-virtualized or bare metal IBM Power System LC server. This procedure  follows these general steps: 				

-  							Create a bootable USB device 						
-  							Connect to the BMC firmware to set up network connection 						
-  							Connect to the BMC firmware with IPMI 						
-  							Choose your installation method: 						
  -  									Install Red Hat Enterprise Linux from USB device 								
  -  									Install Red Hat Enterprise Linux with virtual media Download your ISO file from the Red Hat Enterprise Linux website. 								

#### Additional Resources

-  							For a list of virtualization options, see [Supported Linux distributions and virtualization options for POWER8 and POWER9 Linux on Power systems](https://www.ibm.com/support/knowledgecenter/linuxonibm/liaam/liaamdistros.htm). 						

### 8.1.1. Creating a bootable USB device on Linux

 						Follow this procedure to create a bootable USB device on a Linux system. 					

##### Prerequisites

-  								You have downloaded an installation ISO image as described in [Section 4.5, “Downloading the installation ISO image”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#downloading-beta-installation-images_preparing-for-your-installation). 							
-  								The **Binary DVD** ISO image is larger than 4.7 GB, so you must have a USB flash drive that is large enough to hold the ISO image. 							

##### Procedure

Note

 							This procedure is destructive and data on the USB flash drive is destroyed without a warning. 						

1.  								Connect the USB flash drive to the system. 							

2.  								Open a terminal window and run the `dmesg` command: 							

```
   $ dmesg|tail
   ```

    								The `dmesg` command returns a log  that details all recent events. Messages resulting from the attached USB  flash drive are displayed at the bottom of the log. Record the name of  the connected device. 							

3.  								Switch to user root: 							

   ```
   $ su -
   ```

4.  								Enter your root password when prompted. 							

5.  								Find the device node assigned to the drive. In this example, the drive name is `sdd`. 							

   ```
   # dmesg|tail
   [288954.686557] usb 2-1.8: New USB device strings: Mfr=0, Product=1, SerialNumber=2
   [288954.686559] usb 2-1.8: Product: USB Storage
   [288954.686562] usb 2-1.8: SerialNumber: 000000009225
   [288954.712590] usb-storage 2-1.8:1.0: USB Mass Storage device detected
   [288954.712687] scsi host6: usb-storage 2-1.8:1.0
   [288954.712809] usbcore: registered new interface driver usb-storage
   [288954.716682] usbcore: registered new interface driver uas
   [288955.717140] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9228 PQ: 0 ANSI: 0
   [288955.717745] sd 6:0:0:0: Attached scsi generic sg4 type 0
   [288961.876382] sd 6:0:0:0: sdd Attached SCSI removable disk
   ```

6.  								Run the `dd` command to write the ISO image directly to the USB device. 							

   ```
   # dd if=/image_directory/image.iso of=/dev/device
   ```

    								Replace */image_directory/image.iso* with the full path to the ISO image file that you downloaded, and replace *device* with the device name that you retrieved with the `dmesg` command. In this example, the full path to the ISO image is `/home/testuser/Downloads/rhel-8-x86_64-boot.iso`, and the device name is `sdd`: 							

   ```
   # dd if=/home/testuser/Downloads/rhel-8-x86_64-boot.iso of=/dev/sdd
   ```

   Note

    									Ensure that you use the correct device name, and not the name  of a partition on the device. Partition names are usually device names  with a numerical suffix. For example, `sdd` is a device name, and `sdd1` is the name of a partition on the device `sdd`. 								

7.  								Wait for the `dd` command to finish writing the image to the device. The data transfer is complete when the **#**  prompt appears. When the prompt is displayed, log out of the root  account and unplug the USB drive. The USB drive is now ready to be used  as a boot device. 							

### 8.1.2. Creating a bootable USB device on Windows

 						Follow the steps in this procedure to create a bootable USB device  on a Windows system. The procedure varies depending on the tool. Red  Hat recommends using Fedora Media Writer, available for download at https://github.com/FedoraQt/MediaWriter/releases. 					

Note

 							Fedora Media Writer is a community product and is not supported by Red Hat. You can report any issues with the tool at https://github.com/FedoraQt/MediaWriter/issues. 						

##### Prerequisites

-  								You have downloaded an installation ISO image as described in [Section 4.5, “Downloading the installation ISO image”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#downloading-beta-installation-images_preparing-for-your-installation). 							
-  								The **Binary DVD** ISO image is larger than 4.7 GB, so you must have a USB flash drive that is large enough to hold the ISO image. 							

##### Procedure

Note

 							This procedure is destructive and data on the USB flash drive is destroyed without a warning. 						

1.  								Download and install Fedora Media Writer from https://github.com/FedoraQt/MediaWriter/releases. 							

   Note

    									To install Fedora Media Writer on Red Hat Enterprise Linux, use  the pre-built Flatpak package. You can obtain the package from the  official Flatpak repository Flathub.org at https://flathub.org/apps/details/org.fedoraproject.MediaWriter. 								

2.  								Connect the USB flash drive to the system. 							

3.  								Open Fedora Media Writer. 							

4.  								From the main window, click **Custom Image** and select the previously downloaded Red Hat Enterprise Linux ISO image. 							

5.  								From **Write Custom Image** window, select the drive that you want to use. 							

6.  								Click **Write to disk**.  The boot media creation process starts. Do not unplug the drive until  the operation completes. The operation may take several minutes,  depending on the size of the ISO image, and the write speed of the USB  drive. 							

7.  								When the operation completes, unmount the USB drive. The USB drive is now ready to be used as a boot device. 							

### 8.1.3. Creating a bootable USB device on Mac OS X

 						Follow the steps in this procedure to create a bootable USB device on a Mac OS X system. 					

##### Prerequisites

-  								You have downloaded an installation ISO image as described in [Section 4.5, “Downloading the installation ISO image”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#downloading-beta-installation-images_preparing-for-your-installation). 							
-  								The **Binary DVD** ISO image is larger than 4.7 GB, so you must have a USB flash drive that is large enough to hold the ISO image. 							

##### Procedure

Note

 							This procedure is destructive and data on the USB flash drive is destroyed without a warning. 						

1.  								Connect the USB flash drive to the system. 							

2.  								Identify the device path with the `diskutil list` command. The device path has the format of */dev/disknumber*,  where number is the number of the disk. The disks are numbered starting  at zero (0). Typically, Disk 0 is the OS X recovery disk, and Disk 1 is  the main OS X installation. In the following example, the USB device is  `disk2`: 							

   ```
   $ diskutil list
   /dev/disk0
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *500.3 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:          Apple_CoreStorage                         400.0 GB   disk0s2
   3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3
   4:          Apple_CoreStorage                         98.8 GB    disk0s4
   5:                 Apple_Boot Recovery HD             650.0 MB   disk0s5
   /dev/disk1
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                  Apple_HFS YosemiteHD             *399.6 GB   disk1
   Logical Volume on disk0s1
   8A142795-8036-48DF-9FC5-84506DFBB7B2
   Unlocked Encrypted
   /dev/disk2
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *8.0 GB     disk2
   1:               Windows_NTFS SanDisk USB             8.0 GB     disk2s1
   ```

3.  								To identify your USB flash drive, compare the NAME, TYPE and  SIZE columns to your flash drive. For example, the NAME should be the  title of the flash drive icon in the **Finder** tool. You can also compare these values to those in the information panel of the flash drive. 							

4.  								Use the `diskutil unmountDisk` command to unmount the flash drive’s filesystem volumes: 							

   ```
   $ diskutil unmountDisk /dev/disknumber
   					Unmount of all volumes on disknumber was successful
   ```

    								When the command completes, the icon for the flash drive  disappears from your desktop. If the icon does not disappear, you may  have selected the wrong disk. Attempting to unmount the system disk  accidentally returns a **failed to unmount** error. 							

5.  								Log in as root: 							

   ```
   $ su -
   ```

6.  								Enter your root password when prompted. 							

7.  								Use the `dd` command as a parameter of the sudo command to write the ISO image to the flash drive: 							

   ```
   # sudo dd if=/path/to/image.iso of=/dev/rdisknumber bs=1m>
   ```

   Note

    									Mac OS X provides both a block (/dev/disk*) and character  device (/dev/rdisk*) file for each storage device. Writing an image to  the /dev/rdisknumber character device is faster than writing to the  /dev/disknumber block device. 								

8.  								To write the */Users/user_name/Downloads/rhel-8-x86_64-boot.iso* file to the */dev/rdisk2* device, run the following command: 							

   ```
   # sudo dd if=/Users/user_name/Downloads/rhel-8-x86_64-boot.iso of=/dev/rdisk2
   ```

9.  								Wait for the `dd` command to finish writing the image to the device. The data transfer is complete when the **#**  prompt appears. When the prompt is displayed, log out of the root  account and unplug the USB drive. The USB drive is now ready to be used  as a boot device. 							

## 8.2. Completing the prerequisites and booting your firmware

 					Before you power on the system, ensure that you have the following items: 				

-  							Ethernet cable 						
-  							VGA monitor. The VGA resolution must be set to 1024x768-60Hz. 						
-  							USB Keyboard 						
-  							Power cords and outlet for your system. 						
  -  									PC or notebook that has IPMItool level 1.8.15 or greater. (Verifying this piece of info) 								
  -  									Bootable USB device 								

 					**Complete these steps**: 				

1.  							If your system belongs in a rack, install your system into that  rack. For instructions, see IBM Power Systems information at https://www.ibm.com/support/knowledgecenter/. 						
2.  							Connect an Ethernet cable to the embedded Ethernet port next to  the serial port on the back of your system. Connect the other end to  your network. 						
3.  							Connect your VGA monitor to the VGA port on back of system. 						
4.  							Connect your USB keyboard to an available USB port. 						
5.  							Connect the power cords to the system and plug them into the outlets. 						

 					At this point, your firmware is booting. Wait for the green LED on  the power button to start flashing, indicating that it is ready to use.  If your system does not have a green LED indicator light, then wait 1 to  2 minutes. 				

## 8.3. Configuring the IP address IBM Power

 					To set up or enable your network connection to the baseboard  management controller (BMC) firmware, use the Petitboot bootloader  interface. Follow these steps: 				

1.  							Power on your server using the power button on the front of your  system. Your system will power on to the Petitboot bootloader menu. This  process takes about 1 - 2 minutes to complete. Do not walk away from  your system! When Petitboot loads, your monitor will become active and  you will need to push any key in order to interrupt the boot process. 						

2.  							At the Petitboot bootloader main menu, select Exit to Shell. 						

3.  							Run `ipmitool lan print 1`. If this command returns an IP address, verify that is correct and continue. To set a static IP address, follow these steps: 						

   1.  									Set the mode to static by running this command: `ipmitool lan set 1 ipsrc static` 								

   2.  									Set your IP address by running this command: `ipmitool lan set 1 ipaddr *ip_address*` where *ip_address* is the static IP address that you are assigning to this system. 								

   3.  									Set your netmask by running this command: `ipmitool lan set 1 netmask *netmask_address*` where *netmask_address* is the netmask for the system. 								

   4.  									Set your gateway server by running this command: `ipmitool lan set 1 defgw ipaddr *gateway_server*` where gateway_server is the gateway for this system. 								

   5.  									Confirm the IP address by running the command `ipmitool lan print 1` again. 								

                   									This network interface is not active until after you perform the following steps: 								

4.  							To reset your firmware, run the following command: `ipmitool mc reset cold`. 						

                							This command must complete before continuing the process;  however, it does not return any information. To verify that this command  has completed, ping your system BMC address (the same IP address used  in your IPMItool command). When the ping returns successfully, continue  to the next step. 						

   1.  									If your ping does not return successfully within a reasonable  amount of time (2 - 3 minutes), try these additional steps: 								
      1.  											Power your system off with this command: `ipmitool power off`. 										
      2.  											Unplug the power cords from the back of the system. Wait 30 seconds and then apply power to boot BMC. 										

## 8.4. Powering on your server with IPMI

 					Intelligent Platform Management Interface (IPMI) is the default console to use when connecting to the OPAL firmware. 				

 					Use the default values for IPMI: 				

-  							Default user: `ADMIN` 						
-  							Default password: `admin` 						

Note

 						After your system powers on, the Petitboot interface loads. If you  do not interrupt the boot process by pressing any key within 10  seconds, Petitboot automatically boots the first option. To power on  your server from a PC or notebook that is running Linux, follow these  steps: 					

1.  							Open a terminal program on your PC or notebook. 						

2.  							To power on your server, run the following command: 						

   ```
   ipmitool -I lanplus -H server_ip_address -U ipmi_user -P ipmi_password chassis power on
   ```

    							where *server_ip_ipaddress* is the IP address of the Power system and *ipmi_password* is the password set up for IPMI. 						

   Note

    								If your system is already powered on, continue to activate your IPMI console. 							

3.  							Activate your IPMI console by running this command 						

   ```
   ipmitool -I lanplus -H server_ip_address -U ipmi_user -P ipmi_password sol activate
   ```

Note

 						Use your keyboard up arrow to display the previous `ipmitool`  command. You can edit previous commands to avoid typing the entire  command again. If you need to power off or reboot your system,  deactivate the console by running this command: 					

   ```
ipmitool -I lanplus -H server_ip_address -U user-name -P ipmi_password sol deactivate
```

 						To reboot the system, run this command: 					

```
ipmitool -I lanplus -H server_ip_address -U user-name -P ipmi_password chassis power reset
```

## 8.5. Choose your installation method on IBM LC servers

 					You can either install Red Hat Enterprise Linux from a USB device or through virtual media. 				

### 8.5.1. Configuring Petitboot for installation with USB device

 						After the system powers on, the Petitboot bootloader scans local  boot devices and network interfaces to find boot options that are  available to the system. For information about creating a bootable USB  device, see [Section 8.1.1, “Creating a bootable USB device on Linux”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#create-bootable-usb-linux_installing-red-hat-enterprise-linux-on-ibm-power-system-lc-servers). 					

 						Use one of the following USB devices: 					

-  								USB attached DVD player with a single USB cable to stay under 1.0 Amps 							
-  								8 GB 2.0 USB flash drive 							

 						Follow these steps to configure Petitboot: 					

1.  								Insert your bootable USB device into the front USB port. Petitboot displays the following option: 							

```
   [USB: sdb1 / 2015-10-30-11-05-03-00]
       Rescue a Red Hat Enterprise Linux system (64-bit kernel)
       Test this media & install Red Hat Enterprise Linux 8.0  (64-bit kernel)
    *  Install Red Hat Enterprise Linux 8.0 (64-bit kernel)
   ```

   Note

    									Select Rescan devices if the USB device does not appear. If  your device is not detected, you may have to try a different type. 								

2.  								Record the UUID of the USB device. For example, the UUID of the  USB device in the above example is 2015-10-30-11-05-03-00. 							

3.  								Select Install Red Hat Enterprise Linux 8.0 (64-bit kernel) and  press e (Edit) to open the Petitboot Option Editor window. 							

4.  								Move the cursor to the Boot arguments section and add the following information: 							

   ```
   inst.stage2=hd:UUID=your_UUID
   where your_UUID is the UUID that you recorded.
   Petitboot Option Editor
   qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq

     Device:    ( ) sda2 [f8437496-78b8-4b11-9847-bb2d8b9f7cbd]
                (*) sdb1 [2015-10-30-11-05-03-00]
                ( ) Specify paths/URLs manually
       
                        Kernel:         /ppc/ppc64/vmlinuz
                        Initrd:         /ppc/ppc64/initrd.img
                        Device tree:
                        Boot arguments: ro inst.stage2=hd:UUID=2015-10-30-11-05-03-00
       
                           [    OK    ]  [   Help   ]  [  Cancel  ]
   ```

5.  								Select OK to save your options and return to the Main menu. 							

6.  								Verify that Install Red Hat Enterprise Linux 8.x (64-bit kernel)  is selected and then press Enter to begin your installation. 							

### 8.5.2. Access BMC Advanced System Management interface to configure virtual media

 						Baseboard Management Controller (BMC) Advanced Systems Management  is a remote management controller used to access system information,  status, and other process for your server. You can use the BMC Advanced  Systems Management to set up your installation and provide the CD image  as virtual media to the Power System. However, the actual installation  requires a serial-over-LAN (SOL) connection through IPMI. 					

 						To access the BMC Advanced Systems Management, open a web browser to `http://*ip_address*` where *ip_address* is the IP address for the BMC. Log in using these default values: 					

-  								Default user name: ADMIN 							
-  								Default password: admin 							

 						In order to fully use the BMC Advanced Systems Management, you  need to add the IP address of the BMC firmware to the Exceptions list in  the Java Control Panel of your laptop or PC. On a Windows system, this  is usually located by selecting Control Panel > Control Panel for  Java. 					

 						On a Linux system, this is usually located by selecting the Control Center and then selecting the Java web browser plugin. 					

 						After accessing the Control Panel for Java, select Security tab.  Then add the IP address of the BMC firmware to the Exceptions list, by  clicking Edit Site List and then clicking Add. Enter the IP address and  click OK. 					

 						To create a virtual CD/DVD, follow these steps: 					

1.  								Log into the BMC Advanced Systems Management interface from a PC or notebook using the default user name and password. 							

2.  								**Select** Remote Control > Console Redirection. 							

3.  								**Select** Java Console. As the console opens, you might need to direct your browser to open the `jviewer.jnlp` file by selecting to Open with Java Web Start and click OK. Accept the warning and click Run. 							

4.  								In the Console Redirection window, **select** Media > Virtual Media wizard from the menu. 							

5.  								In the Virtual Media wizard, **select** CD/DVD Media:1. 							

6.  								**Select** CD Image and the path to the Linux distribution ISO file. For example, `/tmp/RHEL-7.2-20151030.0-Server-ppc64el-dvd1.iso`. Click Connect CD/DVD. If the connection is successful, the message Device redirected in Read Only Mode is displayed. 							

7.  								Verify that CD/DVD is shown as an option in Petitboot as `sr0`: 							

   ```
          CD/DVD: sr0
                          Install
                          Repair
   ```

   Note

    									Select Rescan devices if CD/DVD does not appear. 								

8.  								**Select**  Install. Ater selecting Install, your remote console may become  inactive. Open or reactivate your IPMI console to complete the  installation. 							

Note

 							Be patient! It can sometimes take a couple minutes for the installation to begin. 						

## 8.6. Completing your LC server installation

 					After you select to boot the Red Hat Enterprise Linux 8 (RHEL) installer, the installer wizard walks you through the steps. 				

1.  							Follow the installation wizard for RHEL to set up disk options,  your user name and password, time zones, and so on. The last step is to  restart your system. 						

   Note

    								While your system is restarting, remove the USB device. 							

2.  							After the system restarts, Petitboot displays the option to boot Red Hat Enterprise Linux 8. **Select** this option and press Enter. 						

# Part III. Installing Red Hat Enterprise Linux on IBM Power System AC servers



 				This section describes how to install Red Hat Enterprise Linux on the IBM Power Systems accelerated server. 			

## Chapter 9. Installing Red Hat Enterprise Linux on IBM Power System accelerated servers

 				This guide helps you install Red Hat Enterprise Linux on an IBM  Power Systems accelerated server (AC). Use these instructions for the  following IBM Power System servers: 			

-  						8335-GTG (IBM Power System AC922) 					
-  						8335-GTH (IBM Power System AC922) 					
-  						8335-GTX (IBM Power System AC922) 					

## 9.1. Overview

 					Use this information to install Red Hat Enterprise Linux on a  non-virtualized, or bare metal IBM Power System accelerated server. This  procedure follows these general steps: 				

-  							Connect to the BMC firmware to set up network connection 						
-  							Choose your installation method: 						
  -  									Install Red Hat Enterprise Linux from USB device 								
  -  									Install Red Hat Enterprise Linux from network 								
-  							Install Red Hat Enterprise Linux 						

#### Additional resources

-  							For a list of supported Red Hat Enterprise Linux versions, see [Supported Linux distributions for POWER8 and POWER9 Linux on Power systems](https://www.ibm.com/support/knowledgecenter/linuxonibm/liaam/liaamdistros.htm). 						

## 9.2. Completing the prerequisites and booting your firmware

 					Before you power on the system, ensure that you have the following items: 				

-  							Ethernet cable 						
-  							VGA monitor. The VGA resolution must be set to 1024x768-60Hz. 						
-  							USB Keyboard 						
-  							Power cords and outlet for your system 						

 					These instructions require that you have a network server set up  with Red Hat Enterprise Linux 7.x. Download Red Hat Enterprise Linux 7.x  LE ALT at https://access.redhat.com/products/red-hat-enterprise-linux/#addl-arch. 				

1.  							Take the link for **Downloads for Red Hat Enterprise Linux for Power, little endian**. 						
2.  							Log into your Red Hat account (if you have not already done so). Select **Red Hat Enterprise Linux for Power 9** from the Product Variant list. 						
3.  							Look for the Red Hat Enterprise Linux for Power 9 (v. 7.x for ppc64le) ISO file. The downloaded ISO file will include **rhel-alt……iso** rather than **rhel….iso** in the path name. 						

 					Complete these steps: 				

-  							If your system belongs in a rack, install your system into that  rack. For instructions, see IBM Power Systems information at https://www.ibm.com/support/knowledgecenter/POWER9/p9hdx/POWER9welcome.htm. 						
-  							Connect an Ethernet cable to the embedded Ethernet port next to  the serial port on the back of your system. Connect the other end to  your network. 						
-  							Connect your VGA monitor to the VGA port on back of system. 						
-  							Connect your USB keyboard to an available USB port. 						
-  							Connect the power cords to the system and plug them into the outlets. 						

 					At this point, your firmware is booting. Wait for the green LED on  the power button to start flashing, indicating that it is ready to use.  If your system does not have a green LED indicator light, then wait 1 to  2 minutes. 				

## 9.3. Configuring the firmware IP address

 					To set up or enable your network connection to the BMC firmware,  use the Petitboot bootloader interface. Follow these steps: 				

1.  							Power on your server using the power button on the front of your  system. Your system will power on to the Petitboot bootloader menu. This  process usually takes about 1 - 2 minutes to complete, but may take 5 -  10 minutes on the first boot or after a firmware update. Do not walk  away from your system! When Petitboot loads, your monitor will become  active and you will need to push any key in order to interrupt the boot  process. 						

2.  							At the Petitboot bootloader main menu, select Exit to Shell. 						

3.  							Run `ipmitool lan print 1`. If this  command returns an IP address, verify that is correct and continue to  step 4. If no IP addresses are returned, follow these steps: 						

   1.  									Set the mode to static by running this command: 								

   ```
      ipmitool lan set 1 ipsrc static
      ```

   2.  									Set your IP address by running this command: 								

      ```
      ipmitool lan set 1 ipaddr _ip_address_
      ```

       									Where *ip_address* is the static IP address that you are assigning to this system. 								

   3.  									Set your netmask by running this command: 								

      ```
      ipmitool lan set 1 netmask _netmask_address_
      ```

       									Where netmask_address is the netmask for the system. 								

   4.  									Set your gateway server by running this command: 								

      ```
      ipmitool lan set 1 defgw ipaddr _gateway_server_
      ```

      ```
      Where gateway_server is the gateway for this system.
      ```

   5.  									Confirm the IP address by running the command `ipmitool lan print 1` again. 								

      Note

       										This interface is not active until after you perform the following steps. 									

   6.  									To reset your firmware, run the following command: 								

      ```
      ipmitool raw 0x06 0x40.
      ```

       									This command must complete before continuing the process;  however, it does not return any information. To verify that this command  has completed, ping your system BMC address (the same IP address used  in your IPMItool command). When the ping returns successfully, continue  to the next step. 								

      Note

       										**Note**: If your ping does not return successfully within a reasonable amount of time (2 - 3 minutes), try these additional steps 									

   7.  									Power your system off with this command: `poweroff.h.` 								

   8.  									Unplug the power cords from the back of the system. Wait 30 seconds and then apply power to boot BMC. 								

## 9.4. Powering on your server with OpenBMC commands

Note

 						After your system powers on, the Petitboot interface loads. If you  do not interrupt the boot process by pressing any key within 10  seconds, Petitboot automatically boots the first option. 					
 	
 					To power on your server from a PC or notebook that is running Linux, follow these steps: 				

-  							Default user name: `root` 						

-  							Default password: `0penBmc` (where, 0penBMC is using a zero and not a capital O) 						

  1.  									Open a terminal program on your PC or notebook. 								

  2.  									Log in to the BMC by running the following commands. 								

     ```
     ssh root@<BMC server_ip_address>
     root@<BMC server password>
     ```

      									Where *BMC server_ip_address* is the IP address of the BMC and *BMC server password* is the password to authenticate. 								

  3.  									To power on your server, run the following command: 								

     ```
     $ root@witherspoon:~# obmcutil poweron
     ```

  4.  									Connect to OS console and use the default password `0penBmc`. 								

     ```
     ssh -p 2200 root@<BMC server_ip_address> root@
     ```

 					Where *BMC server_ip_address* is the IP address of the BMC and *BMC server password* is the password to authenticate. 				

## 9.5. Choose your installation method on IBM accelerated servers

 					You can either install Red Hat Enterprise Linux from a USB device or through the network. 				

## 9.6. Configuring Petitboot for network installation

 					After the system powers on, the Petitboot bootloader scans local  boot devices and network interfaces to find boot options that are  available to the system. To install Red Hat Enterprise Linux from a  network server, you need to set up a network interface (that is not the  BMC network interface). 				
 	
 					Set up a network connection and provide the network boot detail to Petitboot by following these steps: 				

1.  							Connect an Ethernet cable to the second Ethernet port on the back of your system. Connect the other end to your network. 						

2.  							On the Petitboot main screen, select c to configure your system options. 						

3.  							In the Network field of the configuration screen, enter your network information: 						

   1.  									Select your network type 								
   2.  									Select your network device (remember the interface name and mac address) 								
   3.  									Specify your IP/mask, Gateway, and DNS server (remember these setting as you will need them in the next step) 								
   4.  									Select OK to return to the main menu. 								

4.  							Back on the Petitboot main screen, select `n` to create new options. 						

5.  							Choose your boot device or select to Specify paths/URLs manually and then enter your boot options: 						

   1.  									In the Kernel field, enter the path to the kernel. This field  is mandatory. Enter a URL similar to this one for a network: 								

      ```
      http://&lt;http_server_ip&gt;/ppc/ppc64/vmlinuz
      ```

   2.  									In the Initrd field, enter the path to the init ramdisk. Enter a URL similar to this one for a network: 								

      ```
      http://&lt;http_server_ip&gt;/ppc/ppc64/initrd.gz
      ```

   3.  									In the Boot parameter field, set up the set up the repository  path and the IP address of the server where the operating system is  installed. For example: 								

      ```
      append repo=http://<http_server_ip>/ root=live:http://<http_server_ip>/os/LiveOS/squashfs.img ipv6.disable=1 ifname=<ethernet_interface_name>:<mac_addr> ip=<os ip>::<gateway>:<2 digit mask>:<hostname>:<ethernet_interface_name>:none nameserver=<anem_server> inst.text
      ```

       									You can accept the defaults for the rest of the fields. 								

6.  							After you set your netboot options, select OK and press Enter. 						

7.  							On the Petitboot main window, select User Item 1 as your boot option and press Enter. 						

## 9.7. Configuring Petitboot for installation with USB device on accelerated servers

 					After the system powers on, the Petitboot bootloader scans local  boot devices and network interfaces to find boot options that are  available to the system. For information about creating a bootable USB  device, see [Section 8.1.1, “Creating a bootable USB device on Linux”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#create-bootable-usb-linux_installing-red-hat-enterprise-linux-on-ibm-power-system-lc-servers). 				
 	
 					Use one of the following USB devices: 				

-  							USB attached DVD player with a single USB cable to stay under 1.0 Amps 						
-  							8 GB 2.0 USB flash drive 						

 					Follow these steps to configure Petitboot: 				

1.  							Insert your bootable USB device into the front USB port. Petitboot displays the following: 						

   ```
   
   ```

   ```
   [USB: sdb1 / 2015-10-30-11-05-03-00]
   
       Rescue a Red Hat Enterprise Linux system (64-bit kernel)
       Test this media & install Red Hat Enterprise Linux 8.x  (64-bit kernel)
   
     *  Install Red Hat Enterprise Linux 8.x (64-bit kernel)
   ```

   Note

    								Select Rescan devices if the USB device does not appear. If your  device is not detected, you may have to try a different type. 							

2.  							Record the UUID of the USB device. For example, the UUID of the  USB device in the above example is 2015-10-30-11-05-03-00. 						

3.  							Select Install Red Hat Enterprise Linux 8.x (64-bit kernel) and  press e (Edit) to open the Petitboot Option Editor window. 						

4.  							Move the cursor to the Boot arguments section and add the following information: 						

   ```
   
   ```

   ```
          inst.text inst.stage2=hd:UUID=your_UUID
          where your_UUID is the UUID that you recorded.
          Petitboot Option Editor
   qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
   
                        Device:    ( ) sda2 [f8437496-78b8-4b11-9847-bb2d8b9f7cbd]
                                        (*) sdb1 [2015-10-30-11-05-03-00]
                                        ( ) Specify paths/URLs manually
   
                        Kernel:         /ppc/ppc64/vmlinuz
                        Initrd:         /ppc/ppc64/initrd.img
                        Device tree:
                        Boot arguments: ro inst.text inst.stage2=hd:UUID=2015-10-30-11-05-03-00
   
                           [    OK    ]  [   Help   ]  [  Cancel  ]
   ```

5.  							**Select** OK to save your options and return to the Main menu. 						

6.  							Verify that Install Red Hat Enterprise Linux 8.x (64-bit kernel) is selected and then **press** Enter to begin your installation. 						

## 9.8. Completing your accelerated server installation

 					After you select to boot the Red Hat Enterprise Linux 8.x installer, the installer wizard walks you through the steps. 				

1.  							Follow the installation wizard for Red Hat Enterprise Linux to  set up disk options, your user name and password, time zones, and so on.  The last step is to restart your system. 						

   Note

    								While your system is restarting, remove the USB device. 							

2.  							After the system restarts, Petitboot displays the option to boot  Red Hat Enterprise Linux 8.x. Select this option and press Enter. 						

# Part IV. Installing Red Hat Enterprise Linux on IBM Power System L servers



 				This section describes how to install Red Hat Enterprise Linux on the IBM L servers. 			

## Chapter 10. Installing Red Hat Enterprise Linux on IBM Power System L server

 				This guide helps you install Red Hat Enterprise Linux on an IBM  Power System L server. Use these instructions for the following IBM  Power System servers: 			

-  						88247-22L (IBM Power System S822L) 					
-  						8247-21L (IBM Power System S812L) 					
-  						8247-42L (IBM Power System S824L) 					

 				For a list of supported distributions, see [Supported Linux distributions for POWER8 and POWER9 Linux on Power systems](https://www.ibm.com/support/knowledgecenter/linuxonibm/liaam/liaamdistros.htm?view=kc). 			

## 10.1. Overview

 					Use this information to install Red Hat Enterprise Linux on a  non-virtualized or bare metal IBM Power System L server. This procedure  follows these general steps: 				

-  							Complete prerequisites 						
-  							Connecting to the ASMI 						
  -  									Connect using DHCP 								
  -  									Connect using Static IP 								
-  							Enabling IPMI 						
-  							Powering on your server with IPMI 						
  -  									Connecting from Linux notebook 								
  -  									Connecting from Windows notebook 								
-  							Configuring Petitboot and installing Red Hat Enterprise Linux 						

## 10.2. Completing the prerequisites and booting your firmware on L server

 					Before you install Red Hat Enterprise Linux, ensure that you have the following items: 				

-  							Ethernet cable 						
-  							VGA monitor. The VGA resolution must be set to 1024x768-60Hz. 						
-  							USB Keyboard 						
-  							Power cords and outlet for your system 						

 					Before you power on the system, follow these steps: 				

-  							If your system belongs in a rack, install your system into that  rack. For instructions, see IBM Power Systems information at https://www.ibm.com/support/knowledgecenter/. 						
-  							Remove the shipping brackets from the power supplies. Ensure that the power supplies are fully seated in the system 						
-  							Access the server control panel. 						
-  							Connect the power cords to the system and plug them into the outlets. 						

 					At this point, your firmware is booting. Wait for the green power  LED on the control panel to start flashing, indicating that it is ready  to use, and for the prompt 01 N OPAL T to appear on the display. 				

## 10.3. Connecting to ASMI with DHCP

 					To connect to the Advanced System Management Interface (ASMI) you  need to set up your network connection. You can set up DHCP or static  IP. 				
 	
 					Use this type of connection if you are using DHCP. Use these steps  to find the IP address of the service processor and then connect with  the ASMI web interface. If you know what IP address that your server is  using, complete step 1 and then skip to Step 5: Enabling 				

1.  							Connect an Ethernet cable to the HMC1 or HMC2 port on the back of your Power system to your DHCP network. 						
2.  							Access the control panel for your server. 						
3.  							Scroll to function 02 using Increment `(↑)` or Decrement `(↓)` buttons (up and down arrows) and then press Enter. 						
4.  							Move the cursor to the N by pressing Enter. The display looks like this example: `02 A N< T` 						
5.  							Change N to M to start manual mode using the Increment `(↑)` or Decrement `(↓)` buttons. The display looks like this example: `02 A M< T` 						
6.  							Press Enter two times to exit the mode menu. 						
7.  							Scroll to function 30 using Increment or Decrement buttons 						
8.  							Press Enter to enter subfunction. The display looks like this example: `30**` 						
9.  							Use the Increment `(↑)` or Decrement `(↓)`  buttons to select a network device. 3000 displays the IP address that  is assigned to ETH0 (HMC1). 3001 displays the IP address that is  assigned to ETH1 (HMC2) 						
10.  							Press Enter to display the selected IP address. Be sure to record this IP address. 						
11.  							Use the Increment `(↑)` or Decrement `(↓)` buttons to select subfunction exit (30**). 						
12.  							Press Enter to exit subfunction mode. 						
13.  							Scroll to 02 using Increment `(↑)` or Decrement `(↓)` buttons and press Enter. 						
14.  							Change the mode to N. The display looks like this example: `02 A N< T` 						

## 10.4. Connecting to ASMI with static IP address

 					Use this type of connection if you are using a static IP address.  This connection configures a console interface to the ASMI. 				

1.  							Connect an Ethernet cable from the PC or notebook to the Ethernet port labeled HMC1 on the back of the managed system. 						
2.  							Set your IP address on your PC or notebook to match the default  values on your Power system. IP address on PC or notebook: 						

```
169.254.2.140 Subnet mask: 255.255.255.0
The default IP address of HMC1: 169.254.2.147
```

Note

 						The default values of HMC1 are already set and you do not need to  change them. If you want to verify the IP address, follow the steps in  Connecting to ASMI with DHCP to find the IP addresses with the control  panel. 					
 	
 					If you are running Linux on your PC or notebook, set your IP address by following these steps: 				

1.  							Log in as root. 						
2.  							Start a terminal session. 						
3.  							Run the follow command: ifconfig -a. Record these values so that you can reset your network connection later. 						
4.  							Type `ifconfig *ethx* 169.254.2.140 netmask 255.255.255.0`. Replace *ethx* with either eth0 or eth1, depending on what your PC or notepad is using. 						

 					If you are running Windows 7 on your PC or notebook, set your IP address by following these steps: 				

1.  							**Click** Start > Control Panel. 						
2.  							**Select** Network and Sharing Center. 						
3.  							**Click** the network that is displayed in Connections. 						
4.  							**Click** Properties. 						
5.  							If the Security dialog box is displayed, **click** Continue. 						
6.  							**Select** Internet Protocol Version 4. 						
7.  							**Click** Properties. 						
8.  							**Select** Use the following IP address. 						
9.  							**Use** `169.254.2.140` for IP address and `255.255.255.0` for Subnet mask. 						
10.  							**Click** OK > Close > Close 						

Note

 						If HMC1 is occupied, use HMC2. Use IP address 169.254.3.140 and  Subnet mask: 255.255.255.0 on your PC or notebook. The default IP  address of the HMC2 is 169.254.3.147. 					

## 10.5. Enabling IPMI

1.  							The first time that you connect to the firmware, enter the admin  ID admin and password admin. After you log in, you will be forced to  change the password. Be sure to record this password! 						
2.  							From the main menu, select System Configuration→Firmware  Configuration. Verify that OPAL is selected as your Hypervisor Mode. 						
3.  							Follow these steps to set a password for your IPMI session: 						
   1.  									From the main menu, select Login Profile → Change Passwords. 								
   2.  									Select IPMI from the list of user IDs. 								
   3.  									Enter the current password for the administrator (set in step 2) and then enter and confirm a password for IPMI. 								
   4.  									Click Continue. 								
4.  							If your Power system is not using DHCP, you need to configure  Network access. From the main menu, select Network Services > Network  Configuration. To configure network access, follow these steps: 						
   1.  									From the Network Configuration display, select IPv4 and Continue. 								
   2.  									Select Configure this interface? 								
   3.  									Verify that IPv4 is enabled. 								
   4.  									Select Static for the type of IP address. 								
   5.  									Enter a name for the host system. 								
   6.  									Enter an IP address for the system. 								
   7.  									Enter a subnet mask. 								
   8.  									At the bottom of the page, enter a default gateway, Domain name, and IP address for the DNS server. 								
   9.  									After you set the values for the Network configuration, click Continue. 								
   10.  									Click Save Settings. 								
   11.  									If you connected with a PC or notebook, you can remove the  Ethernet cable from your PC or notebook and connect it to the network  switch. To continue with a console connection, change the default IP  address to the IP address that you assigned to the service processor. 								

## 10.6. Powering on your L server with IPMI

 					Intelligent Platform Management Interface (IPMI) is the default  console to use when you configure your Power system. If you are using a  Linux notebook or PC, use the `ipmitool` utility. If you are using a Windows notebook or PC, use the `ipmiutil` utility. 				
 	
 					As the system powers up, you might notice the following actions: 				

-  							System reference codes appear on the control panel display while the system is being started. 						
-  							The system cooling fans are activated after approximately 30 seconds and accelerate to operating speed. 						
-  							The power LED on the control panel stops flashing and remains on, indicating that system power is on. 						

Note

 						After your system powers on, the Petitboot interface loads. If you  do not interrupt the boot process by pressing any key within 10  seconds, Petitboot automatically boots the first option. 					

## 10.7. Powering on your system from a notebook or PC running Linux

 					To power on your server from a notebook or PC running Linux, follow these steps: 				

1.  							Open a terminal program. 						

2.  							To power on your server, run the following command: 						

   ```
   ipmitool -I lanplus -H fsp_ip_address -P _ipmi_password_ power on
   ```

    							Where *ipaddress* is the IP address of the Power system and *ipmi_password* is the password set up for IPMI. 						

3.  							Immediately activate your IPMI console by running this command: 						

   ```
   ipmitool -I lanplus -H fsp_ip_address -P ipmi_password sol activate
   ```

   Tip

    							Use your keyboard up arrow to display the previous `ipmitool` command. You can edit previous commands to avoid typing the entire command again. 						

Note

 						If you need to restart your system, follow these steps: 					

1.  							Deactivate the console by running this command: 						

   ```
   ipmitool -I lanplus -H fsp_ip_address -P ipmi_password sol deactivate
   ```

2.  							Power your system off with this command: 						

   ```
    ipmitool -I lanplus -H fsp_ip_address -P ipmi_password power off
   ```

3.  							Power your system on with this command: 						

   ```
    ipmitool -I lanplus -H fsp_ip_address -P ipmi_password power on
   ```

Note

 						If you have not already done so, insert your DVD into the DVD drive or confirm the installer image in your network 					

## 10.8. Powering on your system from a notebook or PC running Windows

 					To power on your server from a notebook or PC running Windows, follow these steps: 				

1.  							Open a command prompt and change the directory to `C:\Program Files\sourceforge\ipmiutil` 						

2.  							To power on your server, run the following command 						

   ```
   ipmiutil power -u -N ipaddress -P ipmi_password
   ```

    							Where *ipaddress* is the IP address of the Power system and *ipmi_password* is the password set up for IPMI. 						

3.  							Immediately activate your IPMI console by running this command: 						

   ```
    ipmiutil sol -a -r -N ipaddress -P ipmi_password
   ```

Tip

 					Use your keyboard up arrow to display the previous `ipmiutil` command. You can edit previous commands to avoid typing the entire command again. 				

Note

 						If you need to restart your system, follow these steps: . Deactivate the console by running this command: 					

```
ipmiutil sol -d -N ipaddress -P ipmi_password
```

1.  								Power your system off with this command: 							

```
ipmiutil power -d -N ipaddress -P ipmi_password
```

1.  								Power your system on with this command: 							

```
ipmiutil power -u -N ipaddress -P ipmi_password
```

Note

 						If you have not already done so, insert your DVD into the DVD drive or confirm the installer image in your network. 					

## 10.9. Configuring Petitboot and installing Red Hat Enterprise Linux

 					After the system powers on, the Petitboot bootloader scans local  boot devices and network interfaces to find boot options that are  available to the system. If you do not have network connectivity or the  installation DVD in the disk drive, there will not be any boot options  listed. 				

1.  							On the Petitboot main screen, verify that you are booting Red Hat Enterprise Linux 8.0 from the DVD drive. 						
2.  							Select the Red Hat Enterprise Linux installer boot option and then press Enter. 						
3.  							The installation will begin. 						

Note

 						If you do not interrupt the boot process by pressing any key  within 10 seconds after the Petitboot main screen appears, Petitboot  automatically boots the first option. 					

# Part V. Installing Red Hat Enterprise Linux on IBM Z



 				This section describes how to install Red Hat Enterprise Linux on the IBM Z architecture. 			

## Chapter 11. Preparing for installation on IBM Z

## 11.1. Overview of the IBM Z installation process

 					You can install Red Hat Enterprise Linux on IBM Z interactively or  in unattended mode. Installation on IBM Z differs from installation on  other architectures in that it is typically performed over a network and  not from local media. The installation consists of two phases: 				

1.  							**Booting the installation** 						

   -  									Connect with the mainframe 								
   -  									Perform an initial program load (IPL), or boot, from the medium containing the installation program. 								

2.  							**Anaconda** 						

                                							Use the **Anaconda** installation program to: 						

   -  									Configure the network 								
   -  									Specify language support 								
   -  									Specify installation source 								
   -  									Specify software packages to be installed 								
   -  									Perform the rest of the installation 								

## 11.2. Planning for installation on IBM Z

### 11.2.1. Pre-installation

 						Red Hat Enterprise Linux 8 runs on z13 or later IBM mainframe systems. 					
 	
 						The installation process assumes that you are familiar with the IBM Z and can set up *logical partitions* (LPARs) and z/VM guest virtual machines. 					
 	
 						For installation of Red Hat Enterprise Linux on IBM Z, Red Hat  supports Direct Access Storage Device (DASD) and Fiber Channel Protocol  (FCP) storage devices. 					
 	
 						**Pre-installation decisions** 					

-  								Whether the operating system is to be run on an LPAR or as a z/VM guest operating system. 							
-  								If swap space is needed, and how much. Although it is  recommended to assign enough memory to a z/VM guest virtual machine and  let z/VM do the necessary swapping, there are cases where the amount of  required RAM is hard to predict. Such instances should be examined on a  case-by-case basis. 							
-  								Network configuration. Red Hat Enterprise Linux 8 for IBM Z supports the following network devices: 							
  -  										Real and virtual *Open Systems Adapter* (OSA) 									
  -  										Real and virtual HiperSockets 									
  -  										*LAN channel station* (LCS) for real OSA 									

 						**Disk space** 					
 	
 						You will need to calculate and allocate sufficient disk space on DASDs or SCSI disks. 					

-  								A minimum of 10 GB is needed for a server installation, 20 GB if you want to install all packages. 							
-  								Disk space is also required for any application data. After the  installation, you can add or delete more DASD or SCSI disk partitions. 							
-  								The disk space used by the newly installed Red Hat  Enterprise Linux system (the Linux instance) must be separate from the  disk space used by other operating systems you have installed on your  system. 							

 						**RAM** 					
 	
 						You will have to ensure enough RAM is available. 					

-  								1 GB is recommended for the Linux instance. With some tuning, an instance might run with as little as 512 MB RAM. 							
-  								If installing from NFS, 1 GB is sufficient. However, if installing from an HTTP or FTP source, 1.5 GB is needed. 							
-  								Running at 512 MB in text mode can be done only when installing from NFS. 							

Note

 							When initializing swap space on a Fixed Block Architecture (FBA) DASD using the **SWAPGEN** utility, the `FBAPART` option must be used. 						

###### Additional Resources

-  								For additional information on IBM Z, see http://www.ibm.com/systems/z. 							

## 11.3. Installing under z/VM

 					Use the **x3270** or **c3270**  terminal emulator, to log in to z/VM from other Linux systems, or use  the IBM 3270 terminal emulator on the IBM Z Hardware Management Console  (HMC). If you are running Microsoft Windows operating system, there are  several options available, and can be found through an internet search. A  free native Windows port of **c3270** called **wc3270** also exists. 				
 	
 					When installing under z/VM, you can boot from: 				

-  							The z/VM virtual reader 						
-  							A DASD or an FCP-attached SCSI device prepared with the **zipl** boot loader 						
-  							An FCP-attached SCSI DVD drive 						
  1.  									Log on to the z/VM guest virtual machine chosen for the Linux installation. 								

Note

 						If your 3270 connection is interrupted and you cannot log in again  because the previous session is still active, you can replace the old  session with a new one by entering the following command on the z/VM  logon screen: 					

```
logon user here
```

 						Replace *user* with the name  of the z/VM guest virtual machine. Depending on whether an external  security manager, for example RACF, is used, the logon command might  vary. 					
 	
 					If you are not already running **CMS** (single-user operating system shipped with z/VM) in your guest, boot it now by entering the command: 				

```
cp ipl cms
```

 					Be sure not to use CMS disks such as your A disk (often device  number 0191) as installation targets. To find out which disks are in use  by CMS, use the following query: 				

```
query disk
```

 					You can use the following CP (z/VM Control Program, which is the  z/VM hypervisor) query commands to find out about the device  configuration of your z/VM guest virtual machine: 				

-  							Query the available main memory, which is called *storage* in IBM Z terminology. Your guest should have at least 1 GB of main memory. 						

  ```
  cp query virtual storage
  ```

-  							Query available network devices by type: 						

  - `osa`

     										OSA - CHPID type OSD, real or virtual (VSWITCH or GuestLAN), both in QDIO mode 									

  - `hsi`

     										HiperSockets - CHPID type IQD, real or virtual (GuestLAN type Hipers) 									

  - `lcs`

     										LCS - CHPID type OSE 									 										For example, to query all of the network device types mentioned above, run: 									`cp query virtual osa`

-  							Query available DASDs. Only those that are flagged `RW` for read-write mode can be used as installation targets: 						

  ```
  cp query virtual dasd
  ```

-  							Query available FCP channels: 						

  ```
  cp query virtual fcp
  ```

## 11.4. Using parameter and configuration files on IBM Z

 					The IBM Z architecture can use a customized parameter file to pass  boot parameters to the kernel and the installation program. 				
 	
 					You need to change the parameter file if you want to: 				

-  							Install unattended with Kickstart. 						
-  							Choose non-default installation settings that are not accessible  through the installation program’s interactive user interface, such as  rescue mode. 						

 					The parameter file can be used to set up networking non-interactively before the installation program (**Anaconda**) starts. 				
 	
 					The kernel parameter file is limited to 895 characters plus an  end-of-line character. The parameter file can be variable or fixed  record format. Fixed record format increases the file size by padding  each line up to the record length. Should you encounter problems with  the installation program not recognizing all specified parameters in  LPAR environments, you can try to put all parameters in one single line  or start and end each line with a space character. 				
 	
 					The parameter file contains kernel parameters, such as `ro`, and parameters for the installation process, such as `vncpassword=test` or `vnc`. 				

## 11.5. Required configuration file parameters on IBM Z

 					Several parameters are required and must be included in the parameter file. These parameters are also provided in the file `generic.prm` in directory `images/` of the installation DVD. 				

-  							`ro` 						

                        							Mounts the root file system, which is a RAM disk, read-only. 						

-  							`ramdisk_size=*size*` 						

                        							Modifies the memory size reserved for the RAM disk to ensure that  the Red Hat Enterprise Linux installation program fits within it. For  example: `ramdisk_size=40000`. 						

 					The `generic.prm` file also contains the additional parameter `cio_ignore=all,!condev`.  This setting speeds up boot and device detection on systems with many  devices. The installation program transparently handles the activation  of ignored devices. 				

Important

 						To avoid installation problems arising from `cio_ignore` support not being implemented throughout the entire stack, adapt the `cio_ignore=`  parameter value to your system or remove the parameter entirely from  your parameter file used for booting (IPL) the installation program. 					

## 11.6. IBM Z/VM configuration file

 					Under z/VM, you can use a configuration file on a CMS-formatted  disk. The purpose of the CMS configuration file is to save space in the  parameter file by moving the parameters that configure the initial  network setup, the DASD, and the FCP specification out of the parameter  file. 				
 	
 					Each line of the CMS configuration file contains a single variable  and its associated value, in the following shell-style syntax: `*variable*=*value*`. 				
 	
 					You must also add the `CMSDASD` and `CMSCONFFILE` parameters to the parameter file. These parameters point the installation program to the configuration file: 				

- `CMSDASD=*cmsdasd_address*`

   								Where *cmsdasd_address* is the device number of a CMS-formatted disk that contains the configuration file. This is usually the CMS user’s `A` disk. 							 								For example: `CMSDASD=191` 							

- `CMSCONFFILE=*configuration_file*`

   								Where *configuration_file* is the name of the configuration file. **This value must be specified in lower case.** It is specified in a Linux file name format: `*CMS_file_name*.*CMS_file_type*`. 							 								The CMS file `REDHAT CONF` is specified as `redhat.conf`. The CMS file name and the file type can each be from one to eight characters that follow the CMS conventions. 							 								For example: `CMSCONFFILE=redhat.conf` 							

## 11.7. Installation network parameters on IBM Z

 					These parameters can be used to automatically set up the  preliminary network, and can be defined in the CMS configuration file.  These parameters are the only parameters that can also be used in a CMS  configuration file. All other parameters in other sections must be  specified in the parameter file. 				

- `NETTYPE="*type*"`

   								Where *type* must be one of the following: `qeth`, `lcs`, or `ctc`. The default is `qeth`. 							 								Choose `lcs` for: 							 										OSA-2 Ethernet/Token Ring 									 										OSA-Express Fast Ethernet in non-QDIO mode 									 										OSA-Express High Speed Token Ring in non-QDIO mode 									 										Gigabit Ethernet in non-QDIO mode 									 										Choose `qeth` for: 									 										OSA-Express Fast Ethernet 									 										Gigabit Ethernet (including 1000Base-T) 									 										High Speed Token Ring 									 										HiperSockets 									 										ATM (running Ethernet LAN emulation) 									

- `SUBCHANNELS="*device_bus_IDs*"`

   								Where *device_bus_IDs* is a comma-separated list of two or three device bus IDs. The IDs must be specified in lowercase. 							 								Provides required device bus IDs for the various network interfaces: 							`qeth: SUBCHANNELS="*read_device_bus_id*,*write_device_bus_id*,*data_device_bus_id*" lcs or ctc: SUBCHANNELS="*read_device_bus_id*,*write_device_bus_id*"` 								For example (a sample qeth SUBCHANNEL statement): 							`SUBCHANNELS="0.0.f5f0,0.0.f5f1,0.0.f5f2"`

- `PORTNAME="*osa_portname*"` `PORTNAME="*lcs_portnumber*"`

   								This variable supports OSA devices operating in qdio mode or in non-qdio mode. 							 								When using qdio mode (`NETTYPE="qeth"`), *osa_portname* is the portname specified on the OSA device when operating in qeth mode. 							 								When using non-qdio mode (`NETTYPE="lcs"`), *lcs_portnumber* is used to pass the relative port number as a decimal integer in the range of 0 through 15. 							

- `PORTNO="*portnumber*"`

   								You can add either `PORTNO="0"` (to use port 0) or `PORTNO="1"` (to use port 1 of OSA features with two ports per CHPID) to the CMS configuration file to avoid being prompted for the mode. 							

- `LAYER2="*value*"`

   								Where *value* can be `0` or `1`. 							 								Use `LAYER2="0"` to operate an OSA or HiperSockets device in layer 3 mode (`NETTYPE="qeth"`). Use `LAYER2="1"`  for layer 2 mode. For virtual network devices under z/VM this setting  must match the definition of the GuestLAN or VSWITCH to which the device  is coupled. 							 								To use network services that operate on layer 2 (the Data Link  Layer or its MAC sublayer) such as DHCP, layer 2 mode is a good choice. 							 								The qeth device driver default for OSA devices is now layer 2  mode. To continue using the previous default of layer 3 mode, set `LAYER2="0"` explicitly. 							

- `VSWITCH="*value*"`

   								Where *value* can be `0` or `1`. 							 								Specify `VSWITCH="1"` when connecting to a z/VM VSWITCH or GuestLAN, or `VSWITCH="0"` (or nothing at all) when using directly attached real OSA or directly attached real HiperSockets. 							

- `MACADDR="*MAC_address*"`

   								If you specify `LAYER2="1"` and `VSWITCH="0"`,  you can optionally use this parameter to specify a MAC address. Linux  requires six colon-separated octets as pairs lower case hex digits - for  example, `MACADDR=62:a3:18:e7:bc:5f`. Note that this is different from the notation used by z/VM. 							 								If you specify `LAYER2="1"` and `VSWITCH="1"`, you must not specify the `MACADDR`, because z/VM assigns a unique MAC address to virtual network devices in layer 2 mode. 							

- `CTCPROT="*value*"`

   								Where *value* can be `0`, `1`, or `3`. 							 								Specifies the CTC protocol for `NETTYPE="ctc"`. The default is `0`. 							

- `HOSTNAME="*string*"`

   								Where *string* is the host name of the newly-installed Linux instance. 							

- `IPADDR="*IP*"`

   								Where *IP* is the IP address of the new Linux instance. 							

- `NETMASK="*netmask*"`

   								Where *netmask* is the netmask. 							 								The netmask supports the syntax of a prefix integer (from 1 to 32) as specified in IPv4 *classless interdomain routing* (CIDR). For example, you can specify `24` instead of `255.255.255.0`, or `20` instead of `255.255.240.0`. 							

- `GATEWAY="*gw*"`

   								Where *gw* is the gateway IP address for this network device. 							

- `MTU="*mtu*"`

   								Where *mtu* is the *Maximum Transmission Unit* (MTU) for this network device. 							

- `DNS="*server1:server2:additional_server_terms:serverN*"`

   								Where "*server1:server2:additional_server_terms:serverN*" is a list of DNS servers, separated by colons. For example: 							`DNS="10.1.2.3:10.3.2.1"`

- `SEARCHDNS="*domain1:domain2:additional_dns_terms:domainN*"`

   								Where "*domain1:domain2:additional_dns_terms:domainN*" is a list of the search domains, separated by colons. For example: 							`SEARCHDNS="subdomain.domain:domain"` 								You only need to specify `SEARCHDNS=` if you specify the `DNS=` parameter. 							

- `DASD=`

   								Defines the DASD or range of DASDs to configure for the installation. 							 								The installation program supports a comma-separated list of  device bus IDs, or ranges of device bus IDs with the optional attributes  `ro`, `diag`, `erplog`, and `failfast`.  Optionally, you can abbreviate device bus IDs to device numbers with  leading zeros stripped. Any optional attributes should be separated by  colons and enclosed in parentheses. Optional attributes follow a device  bus ID or a range of device bus IDs. 							 								The only supported global option is `autodetect`.  This does not support the specification of non-existent DASDs to  reserve kernel device names for later addition of DASDs. Use persistent  DASD device names (for example `/dev/disk/by-path/…`) to enable transparent addition of disks later. Other global options such as `probeonly`, `nopav`, or `nofcx` are not supported by the installation program. 							 								Only specify those DASDs that need to be installed on your  system. All unformatted DASDs specified here must be formatted after a  confirmation later on in the installation program. 							 								Add any data DASDs that are not needed for the root file system or the `/boot` partition after installation. 							 								For example: 							`DASD="eb1c,0.0.a000-0.0.a003,eb10-eb14(diag),0.0.ab1c(ro:diag)"` 								For FCP-only environments, remove the `DASD=` option from the CMS configuration file to indicate no DASD is present. 							`FCP_*n*="*device_bus_ID* *WWPN* *FCP_LUN*"` 								Where: 							 										*n* is typically an integer value (for example `FCP_1` or `FCP_2`) but could be any string with alphabetic or numeric characters or underscores. 									 										*device_bus_ID* specifies the device bus ID of the FCP device representing the *host bus adapter* (HBA) (for example `0.0.fc00` for device fc00). 									 										*WWPN* is the world wide  port name used for routing (often in conjunction with multipathing) and  is as a 16-digit hex value (for example `0x50050763050b073d`). 									 										*FCP_LUN* refers to the  storage logical unit identifier and is specified as a 16-digit  hexadecimal value padded with zeroes to the right (for example `0x4020400100000000`). 									 										These variables can be used on systems with FCP devices to  activate FCP LUNs such as SCSI disks. Additional FCP LUNs can be  activated during the installation interactively or by means of a  Kickstart file. An example value looks similar to the following: 									`FCP_1="0.0.fc00 0x50050763050b073d 0x4020400100000000"`Important 											Each of the values used in the FCP parameters (for example `FCP_1` or `FCP_2`) are site-specific and are normally supplied by the FCP storage administrator. 										

 					The installation program prompts you for any required parameters  not specified in the parameter or configuration file except for FCP_n. 				

## 11.8. Parameters for kickstart installations on IBM Z

 					The following parameters can be defined in a parameter file but do not work in a CMS configuration file. 				

- `inst.ks=*URL*`

   								References a Kickstart file, which usually resides on the network for Linux installations on IBM Z. Replace *URL*  with the full path including the file name of the Kickstart file. This  parameter activates automatic installation with Kickstart. 							

- `inst.cmdline`

   								When this option is specified, output on line-mode terminals  (such as 3270 under z/VM or operating system messages for LPAR) becomes  readable, as the installation program disables escape terminal sequences  that are only applicable to UNIX-like consoles. This requires  installation with a Kickstart file that answers all questions, because  the installation program does not support interactive user input in  cmdline mode. 							

 					Ensure that your Kickstart file contains all required parameters before you use the `inst.cmdline` option. If a required command is missing, the installation will fail. 				

## 11.9. Miscellaneous parameters on IBM Z

 					The following parameters can be defined in a parameter file but do not work in a CMS configuration file. 				

- `rd.live.check`

   								Turns on testing of an ISO-based installation source; for example, when booted from an FCP-attached DVD or using `inst.repo=` with an ISO on local hard disk or mounted with NFS. 							

- `inst.nompath`

   								Disables support for multipath devices. 							

- `inst.proxy=[*protocol*://][*username*[:*password*]@]*host*[:*port*]`

   								Specify a proxy to use with installation over HTTP, HTTPS or FTP. 							

- `inst.rescue`

   								Boot into a rescue system running from a RAM disk that can be used to fix and restore an installed system. 							

- `inst.stage2=*URL*`

   								Specifies a path to a tree containing `install.img`, not to the `install.img` directly. Otherwise, follows the same syntax as `inst.repo=`. If `inst.stage2` is specified, it typically takes precedence over other methods of finding `install.img`. However, if **Anaconda** finds `install.img` on local media, the `inst.stage2` URL will be ignored. 							 								If `inst.stage2` is not specified and `install.img` cannot be found locally, **Anaconda** looks to the location given by `inst.repo=` or `method=`. 							 								If only `inst.stage2=` is given without `inst.repo=` or `method=`, **Anaconda** uses whatever repos the installed system would have enabled by default for installation. 							 								Use the option multiple times to specify multiple HTTP, HTTPS or  FTP sources. The HTTP, HTTPS or FTP paths are then tried sequentially  until one succeeds: 							`inst.stage2=http://hostname/path_to_install_tree/ inst.stage2=http://hostname/path_to_install_tree/ inst.stage2=http://hostname/path_to_install_tree/`

- `inst.syslog=*IP/hostname*[:*port*]`

   								Sends log messages to a remote syslog server. 							

 					The boot parameters described here are the most useful for  installations and trouble shooting on IBM Z, but only a subset of those  that influence the installation program. 				

## 11.10. Sample parameter file and CMS configuration file on IBM Z

 					To change the parameter file, begin by extending the shipped `generic.prm` file. 				
 	
 					Example of `generic.prm` file: 				

```
ro ramdisk_size=40000 cio_ignore=all,!condev
CMSDASD="191" CMSCONFFILE="redhat.conf"
inst.vnc
inst.repo=http://example.com/path/to/dvd-contents
```

 					Example of `redhat.conf` file configuring a QETH network device (pointed to by `CMSCONFFILE` in `generic.prm`): 				

```
NETTYPE="qeth"
SUBCHANNELS="0.0.0600,0.0.0601,0.0.0602"
PORTNAME="FOOBAR"
PORTNO="0"
LAYER2="1"
MACADDR="02:00:be:3a:01:f3"
HOSTNAME="foobar.systemz.example.com"
IPADDR="192.168.17.115"
NETMASK="255.255.255.0"
GATEWAY="192.168.17.254"
DNS="192.168.17.1"
SEARCHDNS="systemz.example.com:example.com"
DASD="200-203"
```

## Chapter 12. Configuring a Linux instance on IBM Z

 				This section describes most of the common tasks for installing Red Hat Enterprise Linux on IBM Z. 			

## 12.1. Adding DASDs

 					Direct Access Storage Devices (DASDs) are a type of storage  commonly used with IBM Z. Additional information about working with  these storage devices can be found at the IBM Knowledge Center at http://www-01.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lgdd/lgdd_t_dasd_wrk.html. 				
 	
 					The following is an example of how to set a DASD online, format it, and make the change persistent. 				
 	
 					Make sure the device is attached or linked to the Linux system if running under z/VM. 				

```
CP ATTACH EB1C TO *
```

 					To link a mini disk to which you have access, issue, for example: 				

```
CP LINK RHEL7X 4B2E 4B2E MR
DASD 4B2E LINKED R/W
```

## 12.2. Dynamically setting DASDs online

 					To set a DASD online, follow these steps: 				

1.  							Use the `cio_ignore` utility to remove the DASD from the list of ignored devices and make it visible to Linux: 						

   ```
   # cio_ignore -r device_number
   ```

    							Replace *device_number* with the device number of the DASD. For example: 						

   ```
   # cio_ignore -r 4b2e
   ```

2.  							Set the device online. Use a command of the following form: 						

   ```
   # chccwdev -e device_number
   ```

    							Replace *device_number* with the device number of the DASD. For example: 						

   ```
   # chccwdev -e 4b2e
   ```

    							As an alternative, you can set the device online using sysfs attributes: 						

   1.  									Use the `cd` command to change to the /sys/ directory that represents that volume: 								

      ```
      # cd /sys/bus/ccw/drivers/dasd-eckd/0.0.4b2e/
      # ls -l
      total 0
      -r--r--r--  1 root root 4096 Aug 25 17:04 availability
      -rw-r--r--  1 root root 4096 Aug 25 17:04 cmb_enable
      -r--r--r--  1 root root 4096 Aug 25 17:04 cutype
      -rw-r--r--  1 root root 4096 Aug 25 17:04 detach_state
      -r--r--r--  1 root root 4096 Aug 25 17:04 devtype
      -r--r--r--  1 root root 4096 Aug 25 17:04 discipline
      -rw-r--r--  1 root root 4096 Aug 25 17:04 online
      -rw-r--r--  1 root root 4096 Aug 25 17:04 readonly
      -rw-r--r--  1 root root 4096 Aug 25 17:04 use_diag
      ```

   2.  									Check to see if the device is already online: 								

      ```
      # cat online
      0
      ```

   3.  									If it is not online, enter the following command to bring it online: 								

      ```
      # echo 1 > online
      # cat online
      1
      ```

3.  							Verify which block devnode it is being accessed as: 						

   ```
   # ls -l
   total 0
   -r--r--r--  1 root root 4096 Aug 25 17:04 availability
   lrwxrwxrwx  1 root root    0 Aug 25 17:07 block -> ../../../../block/dasdb
   -rw-r--r--  1 root root 4096 Aug 25 17:04 cmb_enable
   -r--r--r--  1 root root 4096 Aug 25 17:04 cutype
   -rw-r--r--  1 root root 4096 Aug 25 17:04 detach_state
   -r--r--r--  1 root root 4096 Aug 25 17:04 devtype
   -r--r--r--  1 root root 4096 Aug 25 17:04 discipline
   -rw-r--r--  1 root root    0 Aug 25 17:04 online
   -rw-r--r--  1 root root 4096 Aug 25 17:04 readonly
   -rw-r--r--  1 root root 4096 Aug 25 17:04 use_diag
   ```

    							As shown in this example, device 4B2E is being accessed as /dev/dasdb. 						

 					These instructions set a DASD online for the current session, but  this is not persistent across reboots. For instructions on how to set a  DASD online persistently, see [Section 12.4, “Persistently setting DASDs online”](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#persistently-setting-dasds-online_configuring-a-linux-instance-on-ibm-z). When you work with DASDs, use the persistent device symbolic links under `/dev/disk/by-path/`. 				

## 12.3. Preparing a new DASD with low-level formatting

 					Once the disk is online, change back to the `/root` directory and low-level format the device. This is only required once for a DASD during its entire lifetime: 				

```
# cd /root
# dasdfmt -b 4096 -d cdl -p /dev/disk/by-path/ccw-0.0.4b2e
Drive Geometry: 10017 Cylinders * 15 Heads =  150255 Tracks

I am going to format the device /dev/disk/by-path/ccw-0.0.4b2e in the following way:
Device number of device : 0x4b2e
Labelling device        : yes
Disk label              : VOL1
Disk identifier         : 0X4B2E
Extent start (trk no)   : 0
Extent end (trk no)     : 150254
Compatible Disk Layout  : yes
Blocksize               : 4096

--->> ATTENTION! <<---
All data of that device will be lost.
Type "yes" to continue, no will leave the disk untouched: yes
cyl    97 of  3338 |#----------------------------------------------|   2%
```

 					When the progress bar reaches the end and the format is complete, **dasdfmt** prints the following output: 				

```
Rereading the partition table...
Exiting...
```

 					Now, use **fdasd**  to partition the DASD. You can create up to three partitions on a DASD.  In our example here, we create one partition spanning the whole disk: 				

```
# fdasd -a /dev/disk/by-path/ccw-0.0.4b2e
reading volume label ..: VOL1
reading vtoc ..........: ok

auto-creating one partition for the whole disk...
writing volume label...
writing VTOC...
rereading partition table...
```

 					After a (low-level formatted) DASD is online, it can be used like  any other disk under Linux. For instance, you can create file systems,  LVM physical volumes, or swap space on its partitions, for example `/dev/disk/by-path/ccw-0.0.4b2e-part1`. Never use the full DASD device (`dev/dasdb`) for anything but the commands `dasdfmt` and `fdasd`. If you want to use the entire DASD, create one partition spanning the entire drive as in the `fdasd` example above. 				
 	
 					To add additional disks later without breaking existing disk entries in, for example, `/etc/fstab`, use the persistent device symbolic links under `/dev/disk/by-path/`. 				

## 12.4. Persistently setting DASDs online

 					The above instructions described how to activate DASDs dynamically  in a running system. However, such changes are not persistent and do not  survive a reboot. Making changes to the DASD configuration persistent  in your Linux system depends on whether the DASDs belong to the root  file system. Those DASDs required for the root file system need to be  activated very early during the boot process by the `initramfs` to be able to mount the root file system. 				
 	
 					The `cio_ignore` commands are  handled transparently for persistent device configurations and you do  not need to free devices from the ignore list manually. 				

## 12.5. DASDs that are part of the root file system

 					The file you have to modify to add DASDs that are part of the root  file system has changed in Red Hat Enterprise Linux 8. Instead of  editing the `/etc/zipl.conf` file, the new file to be edited, and its location, may be found by running the following commands: 				

```
# machine_id=$(cat /etc/machine-id)
# kernel_version=$(uname -r)
# ls /boot/loader/entries/$machine_id-$kernel_version.conf
```

 					There is one boot option to activate DASDs early in the boot process: `rd.dasd=`.  This option takes a comma-separated list as input. The list contains a  device bus ID and optional additional parameters consisting of key-value  pairs that correspond to DASD **sysfs** attributes. 				
 	
 					Below is an example of the `/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-80.el8.s390x.conf` file for a system that uses physical volumes on partitions of two DASDs for an LVM volume group `vg_devel1` that contains a logical volume `lv_root` for the root file system. 				

```
title Red Hat Enterprise Linux (4.18.0-80.el8.s390x) 8.0 (Ootpa)
version 4.18.0-80.el8.s390x
linux /boot/vmlinuz-4.18.0-80.el8.s390x
initrd /boot/initramfs-4.18.0-80.el8.s390x.img
options root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.dasd=0.0.0200 rd.dasd=0.0.0207 rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0
id rhel-20181027190514-4.18.0-80.el8.s390x
grub_users $grub_users
grub_arg --unrestricted
grub_class kernel
```

 					To add another physical volume on a partition of a third DASD with device bus ID `0.0.202b`. To do this, add `rd.dasd=0.0.202b` to the parameters line of your boot kernel in `/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-32.el8.s390x.conf`: 				

```
title Red Hat Enterprise Linux (4.18.0-80.el8.s390x) 8.0 (Ootpa)
version 4.18.0-80.el8.s390x
linux /boot/vmlinuz-4.18.0-80.el8.s390x
initrd /boot/initramfs-4.18.0-80.el8.s390x.img
options root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.dasd=0.0.0200 rd.dasd=0.0.0207 rd.dasd=0.0.202b rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0
id rhel-20181027190514-4.18.0-80.el8.s390x
grub_users $grub_users
grub_arg --unrestricted
grub_class kernel
```

Warning

 						Make sure the length of the kernel command line in the  configuration file does not exceed 896 bytes. Otherwise, the boot loader  cannot be saved, and the installation fails. 					
 	
 					Run `zipl` to apply the changes of the configuration file for the next IPL: 				

```
# zipl -V
Using config file '/etc/zipl.conf'
Using BLS config file '/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-80.el8.s390x.conf'
Target device information
  Device..........................: 5e:00
  Partition.......................: 5e:01
  Device name.....................: dasda
  Device driver name..............: dasd
  DASD device number..............: 0201
  Type............................: disk partition
  Disk layout.....................: ECKD/compatible disk layout
  Geometry - heads................: 15
  Geometry - sectors..............: 12
  Geometry - cylinders............: 13356
  Geometry - start................: 24
  File system block size..........: 4096
  Physical block size.............: 4096
  Device size in physical blocks..: 262152
Building bootmap in '/boot'
Building menu 'zipl-automatic-menu'
Adding #1: IPL section '4.18.0-80.el8.s390x' (default)
  initial ramdisk...: /boot/initramfs-4.18.0-80.el8.s390x.img
  kernel image......: /boot/vmlinuz-4.18.0-80.el8.s390x
  kernel parmline...: 'root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.dasd=0.0.0200 rd.dasd=0.0.0207 rd.dasd=0.0.202b rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0'
  component address:
    kernel image....: 0x00010000-0x0049afff
    parmline........: 0x0049b000-0x0049bfff
    initial ramdisk.: 0x004a0000-0x01a26fff
    internal loader.: 0x0000a000-0x0000cfff
Preparing boot menu
  Interactive prompt......: enabled
  Menu timeout............: 5 seconds
  Default configuration...: '4.18.0-80.el8.s390x'
Preparing boot device: dasda (0201).
Syncing disks...
Done.
```

## 12.6. FCP LUNs that are part of the root file system

 					The only file you have to modify for adding FCP LUNs that are part  of the root file system has changed in Red Hat Enterprise Linux 8.  Instead of editing the `/etc/zipl.conf` file, the new file to be edited, and its location, may be found by running the following commands: 				

```
# machine_id=$(cat /etc/machine-id)
# kernel_version=$(uname -r)
# ls /boot/loader/entries/$machine_id-$kernel_version.conf
```

 					Red Hat Enterprise Linux provides a parameter to activate FCP LUNs early in the boot process: `rd.zfcp=`. The value is a comma-separated list containing the device bus ID, the WWPN as 16 digit hexadecimal number prefixed with `0x`, and the FCP LUN prefixed with `0x` and padded with zeroes to the right to have 16 hexadecimal digits. 				
 	
 					Below is an example of the `/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-80.el8.s390x.conf` file for a system that uses physical volumes on partitions of two FCP LUNs for an LVM volume group `vg_devel1` that contains a logical volume `lv_root` for the root file system. For simplicity, the example shows a configuration without multipathing. 				

```
title Red Hat Enterprise Linux (4.18.0-32.el8.s390x) 8.0 (Ootpa)
version 4.18.0-32.el8.s390x
linux /boot/vmlinuz-4.18.0-32.el8.s390x
initrd /boot/initramfs-4.18.0-32.el8.s390x.img
options root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a000000000 rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a100000000 rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0
id rhel-20181027190514-4.18.0-32.el8.s390x
grub_users $grub_users
grub_arg --unrestricted
grub_class kernel
```

 					To add another physical volume on a partition of a third FCP LUN  with device bus ID 0.0.fc00, WWPN 0x5105074308c212e9 and FCP LUN  0x401040a300000000, add `rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a300000000` to the parameters line of your boot kernel in `/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-32.el8.s390x.conf`. For example: 				

```
title Red Hat Enterprise Linux (4.18.0-32.el8.s390x) 8.0 (Ootpa)
version 4.18.0-32.el8.s390x
linux /boot/vmlinuz-4.18.0-32.el8.s390x
initrd /boot/initramfs-4.18.0-32.el8.s390x.img
options root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a000000000 rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a100000000 rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a300000000 rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0
id rhel-20181027190514-4.18.0-32.el8.s390x
grub_users $grub_users
grub_arg --unrestricted
grub_class kernel
```

Warning

 						Make sure the length of the kernel command line in the  configuration file does not exceed 896 bytes. Otherwise, the boot loader  cannot be saved, and the installation fails. 					
 	
 					Run `zipl` to apply the changes of the configuration file for the next IPL: 				

```
# zipl -V
Using config file '/etc/zipl.conf'
Using BLS config file '/boot/loader/entries/4ab74e52867b4f998e73e06cf23fd761-4.18.0-32.el8.s390x.conf'
Target device information
Device..........................: 08:00
Partition.......................: 08:01
Device name.....................: sda
Device driver name..............: sd
Type............................: disk partition
Disk layout.....................: SCSI disk layout
Geometry - start................: 2048
File system block size..........: 4096
Physical block size.............: 512
Device size in physical blocks..: 10074112
Building bootmap in '/boot/'
Building menu 'rh-automatic-menu'
Adding #1: IPL section '4.18.0-32.el8.s390x' (default)
kernel image......: /boot/vmlinuz-4.18.0-32.el8.s390x
kernel parmline...: 'root=/dev/mapper/vg_devel1-lv_root crashkernel=auto rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a000000000 rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a100000000 rd.zfcp=0.0.fc00,0x5105074308c212e9,0x401040a300000000 rd.lvm.lv=vg_devel1/lv_root rd.lvm.lv=vg_devel1/lv_swap cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0'
initial ramdisk...: /boot/initramfs-4.18.0-32.el8.s390x.img
component address:
kernel image....: 0x00010000-0x007a21ff
parmline........: 0x00001000-0x000011ff
initial ramdisk.: 0x02000000-0x028f63ff
internal loader.: 0x0000a000-0x0000a3ff
Preparing boot device: sda.
Detected SCSI PCBIOS disk layout.
Writing SCSI master boot record.
Syncing disks...
Done.
```

## 12.7. FCP LUNs that are not part of the root file system

 					FCP LUNs that are not part of the root file system, such as data disks, are persistently configured in the file `/etc/zfcp.conf`.  It contains one FCP LUN per line. Each line contains the device bus ID  of the FCP adapter, the WWPN as 16 digit hexadecimal number prefixed  with `0x`, and the FCP LUN prefixed with `0x` and padded with zeroes to the right to have 16 hexadecimal digits, separated by a space or tab. Entries in `/etc/zfcp.conf`  are activated and configured by udev when an FCP adapter is added to  the system. At boot time, all FCP adapters visible to the system are  added and trigger **udev**. 				
 	
 					Example content of `/etc/zfcp.conf`: 				

```
0.0.fc00 0x5105074308c212e9 0x401040a000000000
0.0.fc00 0x5105074308c212e9 0x401040a100000000
0.0.fc00 0x5105074308c212e9 0x401040a300000000
0.0.fcd0 0x5105074308c2aee9 0x401040a000000000
0.0.fcd0 0x5105074308c2aee9 0x401040a100000000
0.0.fcd0 0x5105074308c2aee9 0x401040a300000000
```

 					Modifications of `/etc/zfcp.conf` only  become effective after a reboot of the system or after the dynamic  addition of a new FCP channel by changing the system’s I/O configuration  (for example, a channel is attached under z/VM). Alternatively, you can  trigger the activation of a new entry in `/etc/zfcp.conf` for an FCP adapter which was previously not active, by executing the following commands: 				

1.  							Use the `cio_ignore` utility to remove the FCP adapter from the list of ignored devices and make it visible to Linux: 						

   ```
   # cio_ignore -r device_number
   ```

    							Replace *device_number* with the device number of the FCP adapter. For example: 						

   ```
   # cio_ignore -r fcfc
   ```

2.  							To trigger the uevent that activates the change, issue: 						

   ```
   # echo add > /sys/bus/ccw/devices/device-bus-ID/uevent
   ```

    							For example: 						

   ```
   # echo add > /sys/bus/ccw/devices/0.0.fcfc/uevent
   ```

## 12.8. Adding a qeth device

 					The `qeth` network device driver supports IBM Z OSA-Express features in QDIO mode, HiperSockets, z/VM guest LAN, and z/VM VSWITCH. 				
 	
 					The qeth device driver assigns the same interface name for Ethernet and Hipersockets devices: `encbus_ID`.  The bus ID is composed of the channel subsystem ID, subchannel set ID,  and device number, and does not contain leading zeros and dots. For  example enca00 for a device with the bus ID `0.0.0a00`. 				

## 12.9. Dynamically adding a qeth device

 					To add a `qeth` device dynamically, follow these steps: 				

1.  							Determine whether the `qeth` device driver modules are loaded. The following example shows loaded `qeth` modules: 						

   ```
   # lsmod | grep qeth
   qeth_l3                69632  0
   qeth_l2                49152  1
   qeth                  131072  2 qeth_l3,qeth_l2
   qdio                   65536  3 qeth,qeth_l3,qeth_l2
   ccwgroup               20480  1 qeth
   ```

    							If the output of the `lsmod` command shows that the `qeth` modules are not loaded, run the `modprobe` command to load them: 						

   ```
   # modprobe qeth
   ```

2.  							Use the `cio_ignore` utility to remove the network channels from the list of ignored devices and make them visible to Linux: 						

   ```
   # cio_ignore -r read_device_bus_id,write_device_bus_id,data_device_bus_id
   ```

    							Replace *read_device_bus_id*,*write_device_bus_id*,*data_device_bus_id* with the three device bus IDs representing a network device. For example, if the *read_device_bus_id* is `0.0.f500`, the *write_device_bus_id* is `0.0.f501`, and the *data_device_bus_id* is `0.0.f502`: 						

   ```
   # cio_ignore -r 0.0.f500,0.0.f501,0.0.f502
   ```

3.  							Use the **znetconf** utility to sense and list candidate configurations for network devices: 						

   ```
   # znetconf -u
   Scanning for network devices...
   Device IDs                 Type    Card Type      CHPID Drv.
   ------------------------------------------------------------
   0.0.f500,0.0.f501,0.0.f502 1731/01 OSA (QDIO)        00 qeth
   0.0.f503,0.0.f504,0.0.f505 1731/01 OSA (QDIO)        01 qeth
   0.0.0400,0.0.0401,0.0.0402 1731/05 HiperSockets      02 qeth
   ```

4.  							Select the configuration you want to work with and use **znetconf** to apply the configuration and to bring the configured group device online as network device. 						

   ```
   # znetconf -a f500
   Scanning for network devices...
   Successfully configured device 0.0.f500 (encf500)
   ```

5.  							Optionally, you can also pass arguments that are configured on the group device before it is set online: 						

   ```
   # znetconf -a f500 -o portname=myname
   Scanning for network devices...
   Successfully configured device 0.0.f500 (encf500)
   ```

    							Now you can continue to configure the `encf500` network interface. 						

 					Alternatively, you can use `sysfs` attributes to set the device online as follows: 				

1.  							Create a `qeth` group device: 						

   ```
   # echo read_device_bus_id,write_device_bus_id,data_device_bus_id > /sys/bus/ccwgroup/drivers/qeth/group
   ```

    							For example: 						

   ```
   # echo 0.0.f500,0.0.f501,0.0.f502 > /sys/bus/ccwgroup/drivers/qeth/group
   ```

2.  							Next, verify that the `qeth` group device was created properly by looking for the read channel: 						

   ```
   # ls /sys/bus/ccwgroup/drivers/qeth/0.0.f500
   ```

    							You can optionally set additional parameters and features,  depending on the way you are setting up your system and the features you  require, such as: 						

   -  									`portno` 								
   -  									`layer2` 								
   -  									`portname` 								

3.  							Bring the device online by writing `1` to the online `sysfs` attribute: 						

   ```
   # echo 1 > /sys/bus/ccwgroup/drivers/qeth/0.0.f500/online
   ```

4.  							Then verify the state of the device: 						

   ```
   # cat /sys/bus/ccwgroup/drivers/qeth/0.0.f500/online
   											1
   ```

    							A return value of `1` indicates that the device is online, while a return value `0` indicates that the device is offline. 						

5.  							Find the interface name that was assigned to the device: 						

   ```
   # cat /sys/bus/ccwgroup/drivers/qeth/0.0.f500/if_name
   encf500
   ```

    							Now you can continue to configure the `encf500` network interface. 						
    	
    							The following command from the **s390utils** package shows the most important settings of your `qeth` device: 						

   ```
   # lsqeth encf500
   Device name                     : encf500
   -------------------------------------------------
   card_type               : OSD_1000
   cdev0                   : 0.0.f500
   cdev1                   : 0.0.f501
   cdev2                   : 0.0.f502
   chpid                   : 76
   online                  : 1
   portname                : OSAPORT
   portno                  : 0
   state                   : UP (LAN ONLINE)
   priority_queueing       : always queue 0
   buffer_count            : 16
   layer2                  : 1
   isolation               : none
   ```

## 12.10. Persistently adding a qeth device

 					To make your new `qeth` device  persistent, you need to create the configuration file for your new  interface. The network interface configuration files are placed in the `/etc/sysconfig/network-scripts/` directory. 				
 	
 					The network configuration files use the naming convention `ifcfg-*device*`, where *device* is the value found in the `if_name` file in the `qeth` group device that was created earlier, for example `enc9a0`. The `cio_ignore`  commands are handled transparently for persistent device configurations  and you do not need to free devices from the ignore list manually. 				
 	
 					If a configuration file for another device of the same type already  exists, the simplest way to add the config file is to copy it to the  new name and then edit it: 				

```
# cd /etc/sysconfig/network-scripts
# cp ifcfg-enc9a0 ifcfg-enc600
```

 					To learn IDs of your network devices, use the **lsqeth** utility: 				

```
# lsqeth -p
devices                    CHPID interface        cardtype       port chksum prio-q'ing rtr4 rtr6 lay'2 cnt
-------------------------- ----- ---------------- -------------- ---- ------ ---------- ---- ---- ----- -----
0.0.09a0/0.0.09a1/0.0.09a2 x00   enc9a0    Virt.NIC QDIO  0    sw     always_q_2 n/a  n/a  1     64
0.0.0600/0.0.0601/0.0.0602 x00   enc600    Virt.NIC QDIO  0    sw     always_q_2 n/a  n/a  1     64
```

 					If you do not have a similar device defined, you must create a new file. Use this example of `/etc/sysconfig/network-scripts/ifcfg-0.0.09a0` as a template: 				

```
# IBM QETH
DEVICE=enc9a0
BOOTPROTO=static
IPADDR=10.12.20.136
NETMASK=255.255.255.0
ONBOOT=yes
NETTYPE=qeth
SUBCHANNELS=0.0.09a0,0.0.09a1,0.0.09a2
PORTNAME=OSAPORT
OPTIONS='layer2=1 portno=0'
MACADDR=02:00:00:23:65:1a
TYPE=Ethernet
```

 					Edit the new `ifcfg-0.0.0600` file as follows: 				

1.  							Modify the `DEVICE` statement to reflect the contents of the `if_name` file from your `ccw` group. 						

2.  							Modify the `IPADDR` statement to reflect the IP address of your new interface. 						

3.  							Modify the `NETMASK` statement as needed. 						

4.  							If the new interface is to be activated at boot time, then make sure `ONBOOT` is set to `yes`. 						

5.  							Make sure the `SUBCHANNELS` statement matches the hardware addresses for your qeth device. 						

6.  							Modify the `PORTNAME` statement or leave it out if it is not necessary in your environment. 						

7.  							You can add any valid `sysfs` attribute and its value to the `OPTIONS` parameter. The Red Hat Enterprise Linux installation program currently uses this to configure the layer mode (`layer2`) and the relative port number (`portno`) of `qeth` devices. 						

                                							The `qeth` device driver default for OSA devices is now layer 2 mode. To continue using old `ifcfg` definitions that rely on the previous default of layer 3 mode, add `layer2=0` to the `OPTIONS` parameter. 						

 					`/etc/sysconfig/network-scripts/ifcfg-0.0.0600` 				

```
# IBM QETH
DEVICE=enc600
BOOTPROTO=static
IPADDR=192.168.70.87
NETMASK=255.255.255.0
ONBOOT=yes
NETTYPE=qeth
SUBCHANNELS=0.0.0600,0.0.0601,0.0.0602
PORTNAME=OSAPORT
OPTIONS='layer2=1 portno=0'
MACADDR=02:00:00:b3:84:ef
TYPE=Ethernet
```

 					Changes to an `ifcfg` file only become  effective after rebooting the system or after the dynamic addition of  new network device channels by changing the system’s I/O configuration  (for example, attaching under z/VM). Alternatively, you can trigger the  activation of a `ifcfg` file for network channels which were previously not active yet, by executing the following commands: 				

1.  							Use the `cio_ignore` utility to remove the network channels from the list of ignored devices and make them visible to Linux: 						

   ```
   # cio_ignore -r read_device_bus_id,write_device_bus_id,data_device_bus_id
   ```

    							Replace *read_device_bus_id*,*write_device_bus_id*,*data_device_bus_id* with the three device bus IDs representing a network device. For example, if the *read_device_bus_id* is `0.0.0600`, the *write_device_bus_id* is `0.0.0601`, and the *data_device_bus_id* is `0.0.0602`: 						

   ```
   #  cio_ignore -r 0.0.0600,0.0.0601,0.0.0602
   ```

2.  							To trigger the uevent that activates the change, issue: 						

   ```
   # echo add > /sys/bus/ccw/devices/read-channel/uevent
   ```

    							For example: 						

   ```
   # echo add > /sys/bus/ccw/devices/0.0.0600/uevent
   ```

3.  							Check the status of the network device: 						

   ```
   # lsqeth
   ```

4.  							Now start the new interface: 						

   ```
   # ifup enc600
   ```

5.  							Check the status of the interface: 						

   ```
   # ip addr show enc600
   3: enc600:  <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
   link/ether 3c:97:0e:51:38:17 brd ff:ff:ff:ff:ff:ff
   inet 10.85.1.245/24 brd 10.34.3.255 scope global dynamic enc600
   valid_lft 81487sec preferred_lft 81487sec
   inet6 1574:12:5:1185:3e97:eff:fe51:3817/64 scope global noprefixroute dynamic
   valid_lft 2591994sec preferred_lft 604794sec
   inet6 fe45::a455:eff:d078:3847/64 scope link
   valid_lft forever preferred_lft forever
   ```

6.  							Check the routing for the new interface: 						

   ```
   # ip route
   default via 10.85.1.245 dev enc600  proto static  metric 1024
   12.34.4.95/24 dev enp0s25  proto kernel  scope link  src 12.34.4.201
   12.38.4.128 via 12.38.19.254 dev enp0s25  proto dhcp  metric 1
   192.168.122.0/24 dev virbr0  proto kernel  scope link  src 192.168.122.1
   ```

7.  							Verify your changes by using the `ping` utility to ping the gateway or another host on the subnet of the new device: 						

   ```
   # ping -c 1 192.168.70.8
   PING 192.168.70.8 (192.168.70.8) 56(84) bytes of data.
   64 bytes from 192.168.70.8: icmp_seq=0 ttl=63 time=8.07 ms
   ```

8.  							If the default route information has changed, you must also update `/etc/sysconfig/network` accordingly. 						

## 12.11. Configuring an IBM Z network device for network root file system

 					To add a network device that is required to access the root file  system, you only have to change the boot options. The boot options can  be in a parameter file, however, the `/etc/zipl.conf`  file no longer contains specifications of the boot records. The file  that needs to be modified can be located using the following commands: 				

```
# machine_id=$(cat /etc/machine-id)
# kernel_version=$(uname -r)
# ls /boot/loader/entries/$machine_id-$kernel_version.conf
```

 					There is no need to recreate the initramfs. 				
 	
 					**Dracut**, the **mkinitrd** successor that provides the functionality in the initramfs that in turn replaces **initrd**, provides a boot parameter to activate network devices on IBM Z early in the boot process: `rd.znet=`. 				
 	
 					As input, this parameter takes a comma-separated list of the `NETTYPE`  (qeth, lcs, ctc), two (lcs, ctc) or three (qeth) device bus IDs, and  optional additional parameters consisting of key-value pairs  corresponding to network device sysfs attributes. This parameter  configures and activates the IBM Z network hardware. The configuration  of IP addresses and other network specifics works the same as for other  platforms. See the **dracut** documentation for more details. 				
 	
 					The **cio_ignore** commands for the network channels are handled transparently on boot. 				
 	
 					Example boot options for a root file system accessed over the network through NFS: 				

```
root=10.16.105.196:/nfs/nfs_root cio_ignore=all,!condev rd.znet=qeth,0.0.0a00,0.0.0a01,0.0.0a02,layer2=1,portno=0,portname=OSAPORT ip=10.16.105.197:10.16.105.196:10.16.111.254:255.255.248.0:nfs‑server.subdomain.domain:enc9a0:none rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us
```

# Legal Notice

 		Copyright © 2019 Red Hat, Inc. 	
 	
 		The text of and illustrations in this document are licensed by Red Hat  under a Creative Commons Attribution–Share Alike 3.0 Unported license  ("CC-BY-SA"). An explanation of CC-BY-SA is available at http://creativecommons.org/licenses/by-sa/3.0/.  In accordance with CC-BY-SA, if you distribute this document or an  adaptation of it, you must provide the URL for the original version. 	
 	
 		Red Hat, as the licensor of this document, waives the right to  enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest  extent permitted by applicable law. 	
 	
 		Red Hat, Red Hat Enterprise Linux, the Shadowman logo, the Red Hat  logo, JBoss, OpenShift, Fedora, the Infinity logo, and RHCE are  trademarks of Red Hat, Inc., registered in the United States and other  countries. 	
 	
 		Linux® is the registered trademark of Linus Torvalds in the United States and other countries. 	
 	
 		Java® is a registered trademark of Oracle and/or its affiliates. 	
 	
 		XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries. 	
 	
 		MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries. 	
 	
 		Node.js® is an official trademark of  Joyent. Red Hat is not formally related to or endorsed by the official  Joyent Node.js open source or commercial project. 	
 	
 		The OpenStack® Word Mark and OpenStack  logo are either registered trademarks/service marks or  trademarks/service marks of the OpenStack Foundation, in the United  States and other countries and are used with the OpenStack Foundation's  permission. We are not affiliated with, endorsed or sponsored by the  OpenStack Foundation, or the OpenStack community. 	
 	
 		All other trademarks are the property of their respective owners. 	

   








## Upgrading to RHEL 8

### Requirements

- RHEL 7.6 installed					
- The Server variant 					
- The Intel 64 architecture 					
- At least 100MB of free space available on the boot partition (mounted at `/boot`) 					
- FIPS mode disabled				
- Minimum hardware requirements for RHEL 8
- The system registered to the Red Hat Content Delivery Network or  Red Hat Satellite 6.5 or later using the Red Hat Subscription Manager 					

### Known limitations		

- A rollback to the last known good state has not been implemented in the **Leapp**  utility. A complete system backup prior to the upgrade is recommended,  for example, by using the Relax-and-Recover (ReaR) utility. 			
- Packages that are not a part of the Minimal (`@minimal`) or Base (`@base`) package groups might cause the upgrade to fail. 					
- No disk, LVM, or file-system encryption can currently be used on a system targeted for an in-place upgrade. 					
- No Multipath or any kind of network storage mount can be used as a system partition (for example, iSCSI, FCoE, or NFS). 					
- During the upgrade process, the **Leapp** utility sets SELinux mode to permissive and disables firewall. 					
- No support for other Red Hat products running on top of the OS,  Red Hat Software Collections, Red Hat Developer Tools, or add-ons, such  as High Availability or Network Function Virtualization, is currently  provided. 					
- On systems where the root file system is formatted as XFS with `ftype=0`  (default in RHEL 7.2 and earlier versions), the RPM upgrade transaction  calculation might fail if numerous packages are installed on the  system. If the cause of such a failure is insufficient space, increase  the available space by using the `LEAPP_OVL_SIZE=<SIZE_IN_MB>` environment variable with the `leapp upgrade` command, and set the size to more than 2048 MB (see a related [solution](https://access.redhat.com/solutions/4122431) for more information). To determine the `ftype` value, use the `xfs_info` command. 					
- The whole system must be mounted under the root file system, with the exception of `/home` and `/boot`. For example, the `/var` or `/usr` directories cannot be mounted on a separate partition. 					
- The in-place upgrade is currently unsupported for on-demand  instances on Public Clouds (Amazon EC2, Azure, Huawei Cloud, Alibaba  Cloud, Google Cloud) that use Red Hat Update Infrastructure but not Red  Hat Subscription Manager for a RHEL subscription. 					
- UEFI is currently unsupported.  			

# Chapter 2. Preparing a RHEL 7 system for the upgrade

 			This procedure describes the steps that are necessary before performing an in-place upgrade to RHEL 8 using the **Leapp** utility. 		

### Prerequisites

-  					The system meets conditions listed in [Chapter 1, *Requirements and known limitations*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#requirements-and-known-limitationsupgrading-to-rhel-8). 				

### Procedure

1.  					Make sure your system has been successfully registered to the Red  Hat Content Delivery Network (CDN) or Red Hat Satellite 6.5 or later  using the Red Hat Subscription Manager. 				

   Note

    						If your system is registered to a Satellite Server, the RHEL 8  repositories need to be made available by importing a Subscription  Manifest file, created in the Red Hat Customer Portal, into the  Satellite Server. For instructions, see the *Managing Subscriptions* section in the *Content Management Guide* for the particular version of [Red Hat Satellite](https://access.redhat.com/documentation/en-us/red_hat_satellite/), for example, for [version 6.5](https://access.redhat.com/documentation/en-us/red_hat_satellite/6.5/html/content_management_guide/managing_subscriptions). 					

2.  					Verify that you have the Red Hat Enterprise Linux Server subscription attached. 				

   ```
   # subscription-manager list --installed
   +-------------------------------------------+
       	  Installed Product Status
   +-------------------------------------------+
   Product Name:  	Red Hat Enterprise Linux Server
   Product ID:     69
   Version:        7.6
   Arch:           x86_64
   Status:         Subscribed
   ```

3.  					Make sure you have the [Extended Update Support (EUS)](https://access.redhat.com/support/policy/updates/errata#Extended_Update_Support)  repositories enabled. This is necessary for a successful update of the  RHEL 7.6 system to the latest versions of packages in step 6 of this  procedure, and a prerequisite for a supported in-place upgrade scenario. 				

   ```
   # subscription-manager repos --disable rhel-7-server-rpms --enable rhel-7-server-eus-rpms
   ```

    					If you have the Optional channel enabled, enable also the Optional EUS repository by running: 				

   ```
   # subscription-manager repos --disable rhel-7-server-optional-rpms --enable rhel-7-server-eus-optional-rpms
   ```

4.  					If you use the `yum-plugin-versionlock` plug-in to lock packages to a specific version, clear the lock by running: 				

   ```
   # yum versionlock clear
   ```

    					See [How to restrict yum to install or upgrade a package to a fixed specific package version?](https://access.redhat.com/solutions/98873) for more information. 				

5.  					Set the Red Hat Subscription Manager to consume the RHEL 7.6 content: 				

   ```
   # subscription-manager release --set 7.6
   ```

   Note

    						The upgrade is designed for RHEL 7.6 as a starting point. If you  have any packages from a later version of RHEL, please downgrade them to  their RHEL 7.6 versions. 					

6.  					Update all packages to the latest RHEL 7.6 version: 				

   ```
   # yum update
   ```

7.  					Reboot the system: 				

   ```
   # reboot
   ```

8.  					Enable the Extras repository where some of the dependencies are available: 				

   ```
   # subscription-manager repos --enable rhel-7-server-extras-rpms
   ```

9.  					Install the Leapp utility: 				

   ```
   # yum install leapp
   ```

10.  					Download additional required data files (RPM package changes and  RPM repository mapping) attached to the Knowledgebase article [Data required by the Leapp utility for an in-place upgrade from RHEL 7 to RHEL 8](https://access.redhat.com/articles/3664871) and place them in the `/etc/leapp/files/` directory. 				

11.  					Make sure you have any configuration management (such as **Salt**, **Chef**, **Puppet**, **Ansible**) disabled or adequately reconfigured to not attempt to restore the original RHEL 7 system. 				

12.  					Make sure your system does not use more than one Network Interface  Card (NIC) with a name based on the prefix used by the kernel (`eth`). For instructions on how to migrate to another naming scheme before an in-place upgrade to RHEL 8, see [How to perform an in-place upgrade to RHEL 8 when using kernel NIC names on RHEL 7](https://access.redhat.com/solutions/4067471). 				

13.  					Make sure you have a full system backup or a virtual machine  snapshot. You should be able to get your system to the pre-upgrade state  if you follow standard disaster recovery procedures within your  environment. 				

# Chapter 3. Performing the upgrade from RHEL 7 to RHEL 8

 			This procedure describes how to upgrade to RHEL 8 using the **Leapp** utility. 		

### Prerequisites

-  					The steps listed in [Chapter 2, *Preparing a RHEL 7 system for the upgrade*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#preparing-a-rhel-7-system-for-the-upgrade_upgrading-to-rhel-8) have been completed, including a full system backup. 				

### Procedure

1.  					*Optional*: On your RHEL 7 system, perform the pre-upgrade phase separately: 				

   ```
   # leapp preupgrade
   ```

    					During the pre-upgrade process, the **Leapp** utility collects data about the system, checks the upgradability, and produces a pre-upgrade report in the `/var/log/leapp/leapp-report.txt`  file. This enables you to obtain early information about the planned  upgrade and to assess whether it is possible or advisable to proceed  with the upgrade. 				

2.  					On your RHEL 7 system, start the upgrade process: 				

   ```
   # leapp upgrade
   ```

    					At the beginning of the upgrade process, **Leapp** performs the pre-upgrade phase, described in the preceding step, and produces a pre-upgrade report in the `/var/log/leapp/leapp-report.txt` file. 				

   Note

    						During the pre-upgrade phase, **Leapp** neither simulates the whole in-place upgrade process nor downloads all RPM packages, and even if no problems are reported in `/var/log/leapp/leapp-report.txt`, **Leapp** can still inhibit the upgrade process in later phases. 					
 	
    					If the system is upgradable, **Leapp** downloads necessary data and prepares an RPM transaction for the upgrade. 				
 	
    					If your system does not meet the parameters for a reliable upgrade, **Leapp** terminates the upgrade process and provides a record describing the issue and a recommended solution in the `/var/log/leapp/leapp-report.txt` file. For more information, see [Chapter 5, *Troubleshooting*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#troubleshooting_upgrading-to-rhel-8). 				

3.  					Manually reboot the system: 				

   ```
   # reboot
   ```

    					In this phase, the system boots into a RHEL 8-based initial RAM disk image, initramfs. **Leapp** upgrades all packages and automatically reboots to the RHEL 8 system. 				
 	
    					If a failure occurs, investigate logs as described in [Chapter 5, *Troubleshooting*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#troubleshooting_upgrading-to-rhel-8). 				

4.  					Perform the following post-upgrade tasks: 				

   1.  							Log in to the RHEL 8 system. 						

   2.  							Change SELinux mode to enforcing: 						

      -  									Ensure that there are no SELinux denials before you switch from permissive mode, for example, by using the **ausearch** utility. See [Chapter 5, *Troubleshooting*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#troubleshooting_upgrading-to-rhel-8) for more details. 								

      -  									Enable SELinux in enforcing mode: 								

        ```
        # setenforce 1
        ```

   3.  							Enable firewall: 						

      ```
      # systemctl start firewalld
      # systemctl enable firewalld
      ```

       							See [Using and configuring firewalls](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/using-and-configuring-firewalls_securing-networks) for more information. 						

   4.  							Verify the state of the system as described in [Chapter 4, *Verifying the post-upgrade state of the RHEL 8 system*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#verifying-the-post-upgrade-state-of-the-rhel-8-system_upgrading-to-rhel-8). 						

# Chapter 4. Verifying the post-upgrade state of the RHEL 8 system

 			This procedure lists steps recommended to perform after an in-place upgrade to RHEL 8. 		

### Prerequisites

-  					The system has been upgraded following the steps described in [Chapter 3, *Performing the upgrade from RHEL 7 to RHEL 8*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#performing-the-upgrade-from-rhel-7-to-rhel-8_upgrading-to-rhel-8) and you were able to log in to RHEL 8. 				

### Procedure

 			After the upgrade completes, determine whether the system is in the required state, at least: 		

-  					Verify that the current OS version is Red Hat Enterprise Linux 8: 				

  ```
  # cat /etc/redhat-release
  Red Hat Enterprise Linux release 8.0 (Ootpa)
  ```

-  					Check the OS kernel version: 				

  ```
  # uname -r
  4.18.0-80.el8.x86_64
  ```

   					Note that `.el8` is important. 				

-  					Verify that the correct product is installed: 				

  ```
  # subscription-manager list --installed
  +-----------------------------------------+
      	  Installed Product Status
  +-----------------------------------------+
  Product Name: Red Hat Enterprise Linux for x86_64
  Product ID:   479
  Version:      8.0
  Arch:         x86_64
  Status:       Subscribed
  ```

-  					Verify that the release version is correctly set to 8.0: 				

  ```
  # subscription-manager release
  Release: 8.0
  ```

   					Note that when the release version is set to 8.0, you will be receiving **yum**  updates only for this specific version of RHEL. If you want to unset  the release version to be able to consume updates from the latest minor  version of RHEL 8, use the following command: 				

  ```
  # subscription-manager release --unset
  ```

-  					Verify that network services are operational, for example, try to connect to a server using SSH. 				

## 5.1. Troubleshooting resources

### Console output

 				By default, only error and critical log level messages are printed to the console output by the **Leapp** utility. To change the log level, use the `--verbose` or `--debug` options with the `leapp upgrade` command. 			

-  						In *verbose* mode, **Leapp** prints info, warning, error, and critical messages. 					
-  						In *debug* mode, **Leapp** prints debug, info, warning, error, and critical messages. 					

#### Logs

-  						The `/var/log/leapp/dnf-debugdata/` directory contains transaction debug data. This directory is present only if **Leapp** is executed with the `--debug` option. 					
-  						The `/var/log/leapp/leapp-upgrade.log` file lists issues found during the initramfs phase. 					
-  						The **journalctl** utility provides complete logs. 					

#### Reports

-  						The `/var/log/leapp/leapp-report.txt` file lists issues found during the pre-upgrade phase. 					

## 5.2. Troubleshooting tips

#### Pre-upgrade phase

-  						Verify that your system meets all conditions listed in [Chapter 1, *Requirements and known limitations*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#requirements-and-known-limitationsupgrading-to-rhel-8). For example, use the `df -h` command to see whether the system has sufficient available space in the `/boot` partition. 					
-  						Make sure you have followed all steps described in [Chapter 2, *Preparing a RHEL 7 system for the upgrade*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#preparing-a-rhel-7-system-for-the-upgrade_upgrading-to-rhel-8),  for example, your system does not use more than one Network Interface  Card (NIC) with a name based on the prefix used by the kernel (`eth`). 					
-  						Investigate the pre-upgrade report in the `/var/log/leapp/leapp-report.txt` file to determine the problem and a recommended solution. 					

#### Download phase

-  						If a problem occurs during downloading RPM packages, examine transaction debug data located in the `/var/log/leapp/dnf-debugdata/` directory. 					

#### initramfs phase

-  						During this phase, potential failures redirect you into the dracut shell. Check the journal: 					

  ```
  # journalctl
  ```

   						Alternatively, restart the system from the dracut shell using the `reboot` command and check the `/var/log/leapp/leapp-upgrade.log` file. 					

#### Post-upgrade phase

-  						If your system seems to be successfully upgraded but booted with  the old RHEL 7 kernel, restart the system and check the kernel version  of the default entry in GRUB. 					

-  						Make sure you have followed the recommended steps in [Chapter 4, *Verifying the post-upgrade state of the RHEL 8 system*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#verifying-the-post-upgrade-state-of-the-rhel-8-system_upgrading-to-rhel-8). 					

-  						If your application or a service stops working or behaves  incorrectly after you have switched SELinux to enforcing mode, search  for denials using the **ausearch**, **journalctl**, or **dmesg** utilities: 					

  ```
  # ausearch -m AVC,USER_AVC -ts recent
  # journalctl -t setroubleshoot
  # dmesg | grep -i -e selinux -e type=1400
  ```

   						The most common problems are caused by incorrect labeling. See [Troubleshooting problems related to SELinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux) for more details. 					

## 5.3. Known issues

- Network teaming currently does not work when the in-place upgrade  is performed while Network Manager is disabled or not installed. (BZ#[1717330](https://bugzilla.redhat.com/show_bug.cgi?id=1717330)) 					

-  						The **Leapp** utility currently fails to upgrade packages from the Supplementary channel, such as the `virtio-win`  package, due to missing mapping support for this channel. In addition,  the corresponding RHEL 8 Supplementary repository fails to be enabled on  the upgraded system. (BZ#1621775) 					

-  						If you use an HTTP proxy, Red Hat Subscription Manager must be configured to use such a proxy, or the `subscription-manager` command must be executed with the `--proxy <hostname>` option. Otherwise, an execution of the `subscription-manager` command fails. If you use the `--proxy` option instead of the configuration change, the upgrade process fails because **Leapp** is unable to detect the proxy. To prevent this problem from occurring, manually edit the `rhsm.conf` file as described in [How to configure HTTP Proxy for Red Hat Subscription Management](https://access.redhat.com/solutions/57669). (BZ#[1689294](https://bugzilla.redhat.com/show_bug.cgi?id=1689294)). 					

-  						If your RHEL 7 system is installed on an FCoE Logical Unit Number (LUN) and connected to a network card that uses the `bnx2fc` driver, the LUN is not detected in RHEL 8 after the upgrade. Consequently, the upgraded system fails to boot. (BZ#1718147) 					

-  						If your RHEL 7 system uses a device driver that is provided by Red Hat but is not available in RHEL 8, **Leapp**  will inhibit the upgrade. However, if the RHEL 7 system uses a  third-party device driver that is not included in the list of removed  drivers (located at `/etc/leapp/repos.d/system_upgrade/el7toel8/actors/kernel/checkkerneldrivers/files/removed_drivers.txt`), **Leapp** will not detect such a driver and will proceed with the upgrade. Consequently, the system might fail to boot after the upgrade. 					

-  						If you see the following error message: 					

  ```
  [ERROR] Actor: target_userspace_creator Message: There are no enabled target repositories for the upgrade process to proceed.
  Detail: {u'hint': u'Ensure your system is correctly registered with the subscription manager and that your current subscription is entitled to install the requested target version 8.0'}
  ```

   						and you are sure that the appropriate subscription is correctly attached, check the presence of the `repomap.csv` and `pes-events.json` files in the `/etc/leapp/files/` directory. If these files are missing, download them as described in step 10 of the procedure in [Chapter 2, *Preparing a RHEL 7 system for the upgrade*](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/upgrading_to_rhel_8/index#preparing-a-rhel-7-system-for-the-upgrade_upgrading-to-rhel-8). 					

-  						If you see an error message similar to this: 					

  ```
  [ERROR] Actor: target_userspace_creator Message: A subscription-manager command failed to execute
  Detail: {u'hint': u'Please ensure you have a valid RHEL subscription and your network is up.'}
  ```

   						while the RHEL server subscription is correctly attached and the  network connection is functioning, check the RHEL 7 version from which  you are trying to upgrade and make sure it is **7.6**. 					

-  						Under certain circumstances, traceback messages similar to the following example might occur: 					

  ```
  2019-02-11T08:00:38Z CRITICAL Traceback (most recent call last):
    File "/usr/lib/python2.7/site-packages/dnf/yum/rpmtrans.py", line 272, in callback
    File "/usr/lib/python2.7/site-packages/dnf/yum/rpmtrans.py", line 356, in _uninst_progress
    File "/usr/lib/python2.7/site-packages/dnf/yum/rpmtrans.py", line 244, in _extract_cbkey
  RuntimeError: TransactionItem not found for key: lz4
  ```

   						It is safe to ignore such messages, which neither interrupt nor affect the result of the upgrade process. 



# 第 18 章 身份管理

​			本章列出了 RHEL 8 和 RHEL 9 之间的身份管理(IdM)的最显著更改。 	

## 18.1. 新功能

**身份管理安装软件包已进行演示**

​					在以前的版本中，在 RHEL 8 中，IdM 软件包作为模块发布，需要启用流并安装与所需安装对应的配置集。IdM 安装软件包在 RHEL 9 中进行了演示，因此您可以使用以下 dnf 命令安装 IdM 服务器软件包： 			

- ​						对于没有集成 DNS 服务的服务器： 				

  

  ```none
  # dnf install ipa-server
  ```

- ​						对于具有集成 DNS 服务的服务器： 				

  

  ```none
  # dnf install ipa-server ipa-server-dns
  ```

**SSSD 隐式文件供应商域默认禁用**

​					SSSD 隐式 `文件` 供应商域，从 `/etc/shadow` 和 `/etc/` groups 等本地文件检索用户信息，现已默认禁用。 			

​				使用 SSSD 从本地文件检索用户和组信息： 		

1. ​						配置 SSSD.选择以下选项之一： 				

   1. ​								使用 `sssd.conf` 配置文件中的 `id_provider=files` 选项明确配置本地域。 						

      

      ```none
      [domain/local]
      id_provider=files
      ...
      ```

   2. ​								通过在 `sssd.conf` 配置文件中设置 `enable_files_domain=true` 选项来启用`文件`供应商。 						

      

      ```none
      [sssd]
      enable_files_domain = true
      ```

2. ​						配置名称服务切换。 				

   

   ```none
   # authselect enable-feature with-files-provider
   ```

**KDC 的新领域配置模板启用 FIPS 140-3 兼容密钥加密**

​					此更新在 `/var/kerberos/krb5kdc/kdc.conf` 文件中提供了一个新的 `EXAMPLE.COM` 示例领域配置。它会带来两个变化： 			

- ​						FIPS 140-3 兼容 `AES HMAC SHA-2` 系列被添加到密钥加密的支持类型的列表中。 				
- ​						KDC 主密钥的加密类型从 `AES 256 HMAC SHA-1` 切换到 `AES 256 HMAC SHA-384`。 				

警告

​					这个更新是独立的 MIT 领域。不要更改 RHEL 身份管理中的 Kerberos 分发中心(KDC)配置。 			

​				建议为新领域使用新的配置模板。模板不会影响任何已部署的领域。如果您计划根据模板升级领域的配置，请考虑以下几点： 		

​				对于升级主密钥，更改 KDC 配置中的设置不够充分。按照 [MIT Kerberos 文档](https://web.mit.edu/kerberos/krb5-1.20/doc/admin/database.html#updating-the-master-key) 中所述的流程进行操作。 		

​				将 `AES HMAC SHA-2`  系列添加到密钥加密的支持类型中在任何时候都安全，因为它不会影响 KDC  中的现有条目。只有在创建新主体或续订凭证时，才会生成密钥。请注意，无法根据现有密钥生成此新类型的密钥。要使这些新加密类型对某个主体可用，必须续订其凭证，这意味着也续订服务主体的 keytab。 		

​				主体不具有 `AES HMAC SHA-2` 密钥的唯一情况是活动目录(AD)跨域票据授予票据(TGT)。由于 AD 不实现 RFC8009，所以不使用 `AES HMAC SHA-2` 加密类型系列。因此，使用 `AES HMAC SHA-2` 加密的 跨域 TGT 的跨域 TGS-REQ 将失败。防止 MIT Kerberos 客户端使用针对 AD 的 `AES HMAC SHA-2` 的最佳方法是不为 AD 跨域主体提供 `AES HMAC SHA-2` 密钥。要做到这一点，请确保使用 AD 支持的密钥加密类型的明确列表创建跨域 TGT 条目： 		



```none
  kadmin.local <<EOF
  add_principal +requires_preauth -e aes256-cts-hmac-sha1-96,aes128-cts-hmac-sha1-96 -pw [password] krbtgt/[MIT realm]@[AD realm]
  add_principal +requires_preauth -e aes256-cts-hmac-sha1-96,aes128-cts-hmac-sha1-96 -pw [password] krbtgt/[AD realm]@[MIT realm]
  EOF
```

​				要确保 MIT Kerboros 客户端使用 `AES HMAC SHA-2` 加密类型，您还必须在客户端和 KDC 配置中将这些加密类型设为 `permitted`。在 RHEL 上，此设置由加密策略系统管理。例如，在使用 `DEFAULT` 加密策略的 RHEL 9 主机上允许 `AES HMAC SHA-2` 和 `AES HMAC SHA-1` 加密票据，而使用 `FIPS` 加密策略的主机只接受 `AES HMAC SHA-2` 票据。 		

# 18.2. 已知问题

**将 FIPS 模式下的 RHEL 9 副本添加到用 RHEL 8.6 或更早版本初始化的 FIPS 模式下的 IdM 部署会失败**

​					略旨在遵守 FIPS 140-3 的默认 RHEL 9 FIPS 加密策不允许使用 AES HMAC-SHA1 加密类型的密钥派生功能，如 5.1 章节 RFC3961 所定义的。 			

​				此约束不允许在 FIPS 模式下将 RHEL 9 身份管理(IdM)副本添加到 FIPS 模式下的 RHEL 8 IdM  环境，在此环境中，第一个服务器安装在 RHEL 8.6 或更早版本的系统上。这是因为在 RHEL 9 和之前的 RHEL  版本之间没有通用的加密类型，它们通常使用 AES HMAC-SHA1 加密类型，但不使用 AES HMAC-SHA2 加密类型。 		

​				要临时解决这个问题，在 RHEL 9 副本上启用 AES HMAC-SHA1 ： 		



```none
# update-crypto-policies --set FIPS:AD-SUPPORT
```

​				通过将加密策略设为 `FIPS:AD-SUPPORT`，您将以下加密类型添加到符合 FIPS 140-3 的已允许的加密类型列表中： 		

- ​						aes256-cts:normal 				
- ​						aes256-cts:special 				
- ​						aes128-cts:normal 				
- ​						aes128-cts:special 				

​				因此，向 IdM 部署添加 RHEL 9 副本可以正确进行。 		

注意

​					目前正在进行的工作是提供在 RHEL 7 和 RHEL 8 服务器上生成缺少 AES HMAC-SHA2 加密的 Kerberos  密钥的流程。这将在 RHEL 9 副本上取得 FIPS 140-3 合规性。但是，这个过程无法完全自动化，因为 Kerberos  密钥加密的设计不可能将现有密钥转换为不同的加密类型。唯一的方法是要求用户更新其密码。 			

注意

​					您可以通过在 RHEL 8 部署中的第一个 IdM 服务器上输入以下命令来查看 IdM 主密钥的加密类型： 			



```none
# kadmin.local getprinc K/M | grep -E '^Key:'
```

​					如果输出中的字符串包含 `sha1` 术语，您必须对 RHEL 9 副本启用 AES HMAC-SHA1。 			

警告

​					Microsoft 的活动目录实现尚不支持使用 SHA-2 HMAC 的任何 RFC8009 Kerberos 加密类型。如果您配置了 IdM-AD 信任，因此即使 IdM 主密钥的加密类型是 `aes256-cts-hmac-sha384-192`，也需要使用 FIPS:AD-SUPPORT 加密子策略。 			

# 18.3. 重新定位的软件包

**`Ansible-freeipa` 现在可在带有所有依赖项的 AppStream 存储库中**

​					以前，在 RHEL 8 中，安装 `ansible-freeipa` 软件包之前，您必须首先启用 Ansible 存储库并安装 `ansible` 软件包。在 RHEL 9 中，您可以安装 `ansible-freeipa`，而无需任何初始步骤。安装 `ansible-freeipa` 会自动安装 `ansible-core` 作为依赖项。这两个软件包都位于 `rhel-9-for-x86_64-appstream-rpms` 存储库中。 			

​				RHEL 9 中的 Ansible free `ipa` 包含于 RHEL 8 中的所有模块。 		

**集群 Samba 软件包现在通过 Resilient Storage 和 Gluster Samba 仓库提供**

​					`ctdb` 集群 Samba 软件包现在可从 Resilient Storage 和 Gluster Samba 存储库获得。在 RHEL 8 中，集群的 Samba 软件包包括在 BaseOS 软件仓库中。 			

# 18.4. 删除的功能

**nss-pam-ldapd 软件包已被删除**

​					`nss-pam-ldapd` 软件包已从 RHEL 中删除。红帽建议迁移到 SSSD 及其 `ldap` 供应商，它完全替换了 `nslcd` 服务的功能。SSSD 具有专门解决 `nss-pam-ldapd` 用户需求的功能，例如： 			

- ​						主机数据库 				
- ​						网络数据库 				
- ​						服务数据库 				

**NIS 软件包已被删除**

​					以下网络信息服务(NIS)组件已从 RHEL 中删除： 			

- ​						`nss_nis` 				
- ​						`yp-tools` 				
- ​						`ypbind` 				
- ​						`ypserv` 				

​				无法直接替换完全兼容功能，因为 NIS 技术基于过时的设计模式，不再被视为安全。 		

​				红帽建议改用 RHEL Identity Management 和 SSSD。 		

**openssh-ldap 软件包已被删除**

​					因为 `openssh-ldap` 子软件包没有被上游维护，它已从 RHEL 中删除。红帽建议使用 SSSD 和 `sss_ssh_authorizedkeys` 帮助程序，它们与其他 IdM 解决方案更好地集成且更安全。 			

​				默认情况下，SSSD `ldap` 和 `ipa` 供应商会读取用户对象的 `sshPublicKey` LDAP 属性（如果可用）。请注意，您无法为 `ad` provider 或 IdM 可信域使用默认的 SSSD 配置从 Active Directory(AD)检索 SSH 公钥，因为 AD 没有存储公钥的默认 LDAP 属性。 		

​				要允许 `sss_ssh_authorizedkeys` 帮助程序从 SSSD 获取密钥，在 `sssd.conf` 文件的 `services` 选项中添加 `ssh` 来启用 `ssh` 响应程序。详情请查看 `sssd.conf(5)` 手册页。 		

​				要允许 `sshd` 使用 `sss_ssh_authorizedkeys`，请在 `/etc/ssh/sshd_config` 文件中添加以下选项，如 `sss_ssh_authorizedkeys(1)` man page 所述： 		



```none
AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys
AuthorizedKeysCommandUser nobody
```

**custodia 软件包已被删除**

​					`custodia` 软件包已集成到 RHEL 9 中的 Red Hat Identity Management 中，不再作为单独的服务提供。 			

**gsntlmssp 软件包已被删除**

​					由于 Windows New Technology LAN Manager(NTLM)被视为不安全，因此删除了 `gssntlmssp` 软件包。 			
